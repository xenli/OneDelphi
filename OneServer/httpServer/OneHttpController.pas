unit OneHttpController;

// 控制器基类
interface

uses
  System.SysUtils, System.Classes, System.Generics.Collections, Web.HTTPApp,
  System.StrUtils, System.NetEncoding, System.Rtti, System.ObjAuto,
  System.TypInfo, OneHttpControllerRtti, OneHttpCtxtResult, OneHttpRouterManage,
  System.JSON, System.JSON.Serializers, Rest.JSON, System.Variants,
  Neon.Core.Persistence.JSON, System.Contnrs, OneNeonHelper, OneHttpConst, OneMultipart,
  OneTokenManage;

type
{$M+}
{$METHODINFO ON}
  TOneControllerBase = class(TPersistent)
  protected
    { 是否支持跨域访问 }
    FbAllowOrigin: Boolean;
    { 当前调用的路由信息 }
    FRouterItem: TOneRouterWorkItem;
    // 验证模式
    FAutoCheckHeadAuthor: Boolean;
    // 是否自动校验 Token参数
    FAutoCheckToken: Boolean;
    FAutoCheckSign: Boolean;
    // 多例模式下这个货才能用
    FHTTPCtxt: THTTPCtxt;
    // 多例模式下这个货才能用
    FHTTPResult: THTTPResult;
    FCurrentThreadLocks: TDictionary<TThreadID, THTTPCtxt>;
  private
    function AddCurrentThreadLock(QHTTPCtxt: THTTPCtxt): TThreadID;
    function GetCurrentThreadLock(): THTTPCtxt;
    procedure RemoveCurrentThreadLock(QThreadID: TThreadID);
  protected
    // 调用方法前做的事,可以基类重写
    function InitOther: Boolean; virtual;
    // Procedure InitRe
    { 验证模式 }
    function CheckAuthor(QHTTPCtxt: THTTPCtxt; QHTTPResult: THTTPResult): Boolean; virtual;
    { 验证Token 合法性 }
    function CheckToken(QHTTPCtxt: THTTPCtxt; QHTTPResult: THTTPResult): Boolean; virtual;
    { 验证Token 签名 合法性 }
    function CheckSign(QHTTPCtxt: THTTPCtxt; QHTTPResult: THTTPResult): Boolean; virtual;
    // 获取方法参数值   var QParamNewObjs: TList<Tobject>
    function DoMethodGetParams(QHTTPCtxt: THTTPCtxt; QHTTPResult: THTTPResult; QOneMethodRtti: TOneMethodRtti; QParamObjRttiList: TList<TRttiType>; QParamNewObjList: TList<TObject>;
      Var QErrMsg: string): TArray<TValue>;
    { 执行相关方法 }
    procedure DoMethodFreeParams(QParamObjList: TList<TObject>; QParamObjRttiList: TList<TRttiType>);
    function DoMethod(QHTTPCtxt: THTTPCtxt; QHTTPResult: THTTPResult;
      QParamNewObjList: TList<TObject>; QParamObjRttiList: TList<TRttiType>): Boolean; virtual;
    { 结果输出编码设置 }
    procedure EndCodeResultOut(QHTTPCtxt: THTTPCtxt; QHTTPResult: THTTPResult); virtual;
    //
    function CheckCureentToken(var QErrMsg: string): Boolean;
    function GetCureentToken(var QErrMsg: string): TOneTokenItem;
    function GetCureentHTTPCtxt(var QErrMsg: string): THTTPCtxt;
    // 自定义输出错误格式
    procedure DoWorkCustErrResult(QHTTPCtxt: THTTPCtxt; QHTTPResult: THTTPResult); virtual;
  protected
    // QCompact JSON是否紧密型的，默认是，减少传输量
    function JSONToObject(Instance: TObject; const JSON: string): Boolean;
  public
    constructor Create; overload; virtual;
    destructor Destroy; override;
    { 工作 }
    // function DoWork(Ctxt:THttpServerRequest;QWorkInfo:THTTPWorkInfo):cardinal;virtual;overload;
    function DoWork(QHTTPCtxt: THTTPCtxt; QHTTPResult: THTTPResult; QRouterItem: TOneRouterWorkItem): cardinal; virtual;
  published
    // property AutoJsonResult:Boolean read FAutoJsonResult write FAutoJsonResult;
    property bAllowOrigin: Boolean read FbAllowOrigin write FbAllowOrigin;
    property RouterItem: TOneRouterWorkItem read FRouterItem write FRouterItem;
    property HTTPCtxt: THTTPCtxt read FHTTPCtxt write FHTTPCtxt;
    property HTTPResult: THTTPResult read FHTTPResult write FHTTPResult;
  end;
{$METHODINFO OFF}
{$M-}

implementation

uses
  OneGlobal;

constructor TOneControllerBase.Create;
begin
  inherited Create;
  // 默认支持跨域
  FbAllowOrigin := true;
  // 默认不开启验证
  FAutoCheckToken := False;
  FAutoCheckSign := False;
  FCurrentThreadLocks := TDictionary<TThreadID, THTTPCtxt>.Create;
end;

destructor TOneControllerBase.Destroy;
begin
  FRouterItem := nil;
  FCurrentThreadLocks.Clear;
  FCurrentThreadLocks.Free;
  inherited Destroy;
end;

function TOneControllerBase.AddCurrentThreadLock(QHTTPCtxt: THTTPCtxt): TThreadID;
var
  lThreadID: TThreadID;
begin
  Result := 0;
  // 如果在多例下 属性 self.HTTPCtxt 是独立的,无需考虑多线程共用一个实例类
  if self.FRouterItem <> nil then
  begin
    // 多例模式，多是独立的可以有
    if self.FRouterItem.RouterMode = emRouterMode.pool then
    begin
      // 多例模式退出
      exit;
    end;
  end;
  lThreadID := TThread.CurrentThread.ThreadID;
  FCurrentThreadLocks.Add(lThreadID, QHTTPCtxt);
  Result := lThreadID;
end;

function TOneControllerBase.GetCurrentThreadLock(): THTTPCtxt;
var
  lThreadID: TThreadID;
  lHTTPCtxt: THTTPCtxt;
begin
  Result := nil;
  if self.FRouterItem <> nil then
  begin
    // 多例模式，多是独立的可以有
    if self.FRouterItem.RouterMode = emRouterMode.pool then
    begin
      // 多例模式退出
      Result := self.HTTPCtxt;
      exit;
    end;
  end;
  lThreadID := TThread.CurrentThread.ThreadID;
  lHTTPCtxt := nil;
  FCurrentThreadLocks.TryGetValue(lThreadID, lHTTPCtxt);
  Result := lHTTPCtxt;
end;

procedure TOneControllerBase.RemoveCurrentThreadLock(QThreadID: TThreadID);
begin
  if QThreadID > 0 then
  begin
    FCurrentThreadLocks.Remove(QThreadID);
  end;
end;

function TOneControllerBase.CheckCureentToken(var QErrMsg: string): Boolean;
var
  lTokenID: string;
  lThreadID: TThreadID;
  lHTTPCtxt: THTTPCtxt;
begin
  Result := False;
  QErrMsg := '';
  // 处理获取TokenID
  lHTTPCtxt := self.GetCurrentThreadLock();
  if lHTTPCtxt = nil then
  begin
    QErrMsg := '当前请求找不到线程相关HTTP上下文消息。';
    exit;
  end;
  lTokenID := '';
  if self.FAutoCheckToken then
  begin
    lTokenID := lHTTPCtxt.UrlParams.Values[HTTP_URL_TokenName];
  end
  else if self.FAutoCheckHeadAuthor then
  begin
    lTokenID := lHTTPCtxt.HeadParamList.Values['Authorization'];
    if lTokenID <> '' then
      lTokenID := lTokenID.Replace('Bearer', '').Trim; // 删除Bearer
  end
  else
  begin
    // 先找Url后找头部
    lTokenID := lHTTPCtxt.UrlParams.Values[HTTP_URL_TokenName];
    if lTokenID = '' then
    begin
      lTokenID := lHTTPCtxt.HeadParamList.Values['Authorization'];
      if lTokenID <> '' then
        lTokenID := lTokenID.Replace('Bearer', '').Trim;
    end;
  end;
  if lTokenID = '' then
  begin
    QErrMsg := 'HTTP上下文找不到相关的TokenID信息';
    exit;
  end;
  Result := TOneGlobal.GetInstance().TokenManage.CheckToken(lTokenID);
  if not Result then
  begin
    QErrMsg := '验证Token失败,请登录';
  end;
end;

function TOneControllerBase.GetCureentToken(var QErrMsg: string): TOneTokenItem;
var
  lTokenID: string;
  lThreadID: TThreadID;
  lHTTPCtxt: THTTPCtxt;
begin
  Result := nil;
  QErrMsg := '';
  // 处理获取TokenID
  lHTTPCtxt := self.GetCurrentThreadLock();
  if lHTTPCtxt = nil then
  begin
    QErrMsg := '当前请求找不到线程相关HTTP上下文消息。';
    exit;
  end;
  lTokenID := '';
  if self.FAutoCheckToken then
  begin
    lTokenID := lHTTPCtxt.UrlParams.Values[HTTP_URL_TokenName];
  end
  else if self.FAutoCheckHeadAuthor then
  begin
    lTokenID := lHTTPCtxt.HeadParamList.Values['Authorization'];
    if lTokenID <> '' then
      lTokenID := lTokenID.Replace('Bearer', '').Trim; // 删除Bearer
  end
  else
  begin
    // 先找Url后找头部
    lTokenID := lHTTPCtxt.UrlParams.Values[HTTP_URL_TokenName];
    if lTokenID = '' then
    begin
      lTokenID := lHTTPCtxt.HeadParamList.Values['Authorization'];
      if lTokenID <> '' then
        lTokenID := lTokenID.Replace('Bearer', '').Trim;
    end;
  end;
  //
  if lTokenID = '' then
  begin
    QErrMsg := 'HTTP上下文找不到相关的TokenID信息';
    exit;
  end;
  //
  Result := TOneGlobal.GetInstance().TokenManage.GetToken(lTokenID);
  if Result = nil then
    QErrMsg := '获取Token信息失败，请重新登陆';
end;

function TOneControllerBase.GetCureentHTTPCtxt(var QErrMsg: string): THTTPCtxt;
begin
  Result := self.GetCurrentThreadLock();
end;

function TOneControllerBase.InitOther: Boolean;
begin
  //
  Result := true;
end;

function TOneControllerBase.CheckAuthor(QHTTPCtxt: THTTPCtxt; QHTTPResult: THTTPResult): Boolean;
var
  lBearerToken: string;
begin
  Result := False;
  if not self.FAutoCheckHeadAuthor then
  begin
    Result := true;
    exit;
  end;
  lBearerToken := QHTTPCtxt.HeadParamList.Values['Authorization'];
  if lBearerToken = '' then
  begin
    QHTTPResult.ResultCode := HTTP_ResultCode_TokenFail;
    QHTTPResult.ResultMsg := '没有Authorization信息,请登录';
    exit;
  end;
  delete(lBearerToken, 1, 6); // 删除Bearer
  Result := TOneGlobal.GetInstance().TokenManage.CheckToken(Trim(lBearerToken));
  if not Result then
  begin
    QHTTPResult.ResultCode := HTTP_ResultCode_TokenFail;
    QHTTPResult.ResultMsg := '验证Authorization失败,请登录';
  end;
end;

function TOneControllerBase.CheckToken(QHTTPCtxt: THTTPCtxt; QHTTPResult: THTTPResult): Boolean;
var
  lTokenID: string;
begin
  Result := False;
  if not self.FAutoCheckToken then
  begin
    Result := true;
    exit;
  end;
  lTokenID := QHTTPCtxt.UrlParams.Values[HTTP_URL_TokenName];
  if lTokenID = '' then
  begin
    QHTTPResult.ResultCode := HTTP_ResultCode_TokenFail;
    QHTTPResult.ResultMsg := '验证Token失败,请登陆';
    exit;
  end;
  Result := TOneGlobal.GetInstance().TokenManage.CheckToken(lTokenID);
  if not Result then
  begin
    QHTTPResult.ResultCode := HTTP_ResultCode_TokenFail;
    QHTTPResult.ResultMsg := '验证Token失败,请登陆';
  end;
end;

function TOneControllerBase.CheckSign(QHTTPCtxt: THTTPCtxt; QHTTPResult: THTTPResult): Boolean;
var
  lTokenID: string;
  lTimeStr: string;
  lSign: string;
begin
  Result := False;
  if not self.FAutoCheckSign then
  begin
    Result := true;
    exit;
  end;
  //
  lTokenID := QHTTPCtxt.UrlParams.Values[HTTP_URL_TokenName];
  if lTokenID = '' then
  begin
    QHTTPResult.ResultCode := HTTP_ResultCode_TokenFail;
    QHTTPResult.ResultMsg := '验证Token失败,请登陆';
    exit;
  end;
  lTimeStr := QHTTPCtxt.UrlParams.Values[HTTP_URL_TokenTime];
  lSign := QHTTPCtxt.UrlParams.Values[HTTP_URL_TokenSign];
  if (lTimeStr = '') or (lSign = '') then
  begin
    QHTTPResult.ResultCode := HTTP_ResultCode_TokenSignFail;
    QHTTPResult.ResultMsg := '数据合法性验证失败(token,time,sign)不可为空';
    exit;
  end;
  // 默认简单签名 请求的数据不参与签名
  Result := TOneGlobal.GetInstance().TokenManage.CheckSign(lTokenID, lTimeStr, lSign);
  if not Result then
  begin
    QHTTPResult.ResultCode := HTTP_ResultCode_TokenSignFail;
    QHTTPResult.ResultMsg := '验签失败,请检查验签方法';
  end;
end;

function TOneControllerBase.DoWork(QHTTPCtxt: THTTPCtxt; QHTTPResult: THTTPResult; QRouterItem: TOneRouterWorkItem): cardinal;
var
  i: Integer;
  LParamNewObjList: TList<TObject>;
  LParamObjRttiList: TList<TRttiType>;
  lThreadID: TThreadID;
  isInvokeOK: Boolean;
begin
  self.FHTTPCtxt := nil;
  self.FHTTPResult := nil;
  // 是否正确执行了Invoke事件
  isInvokeOK := False;
  if self.FRouterItem = nil then
  begin
    // 挂载RTTI信息
    self.FRouterItem := QRouterItem;
  end;
  if self.FRouterItem <> nil then
  begin
    // 多例模式，多是独立的可以有
    if self.FRouterItem.RouterMode = emRouterMode.pool then
    begin
      self.FHTTPCtxt := QHTTPCtxt;
      self.FHTTPResult := QHTTPResult;
    end;
  end;
  lThreadID := self.AddCurrentThreadLock(QHTTPCtxt);
  // 是否要自动解析参数
  LParamNewObjList := TList<TObject>.Create;
  LParamObjRttiList := TList<TRttiType>.Create;
  try
    try
      if not self.InitOther then
      begin
        if QHTTPResult.ResultMsg = '' then
          QHTTPResult.ResultMsg := '初始化InitOther失败,请检查提交的数据是否合法,有可能不是合法JSON';
        exit;
      end;
      if QHTTPCtxt.Method = 'OPTIONS' then
      begin
        if bAllowOrigin then
        begin
          // 响应可以接受的命令,及头部
          QHTTPCtxt.AddCustomerHead('Access-Control-Allow-Methods', 'POST,GET');
          QHTTPCtxt.AddCustomerHead('Access-Control-Allow-Headers', 'content-type');
        end;
      end
      else
      begin
        // 只有post,get才接受,防止其它命令入侵
        if (QHTTPCtxt.Method = 'POST') or (QHTTPCtxt.Method = 'GET') then
        begin
          // URL包括Token的参数,对token进行验证
          if not self.CheckToken(QHTTPCtxt, QHTTPResult) then
          begin
            QHTTPResult.ResultStatus := HTTP_Status_TokenFail;
            exit;
          end;
          if not self.CheckSign(QHTTPCtxt, QHTTPResult) then
          begin
            exit;
          end;
          // 统一进行验权的虚类，各个具体类各自实现
          if not self.CheckAuthor(QHTTPCtxt, QHTTPResult) then
          begin
            exit;
          end;
          // 调用自已的业务方法
          if not DoMethod(QHTTPCtxt, QHTTPResult, LParamNewObjList, LParamObjRttiList) then
          begin
            exit;
          end
          else
          begin
            isInvokeOK := true;
          end;
        end;
      end;
    except
      on e: Exception do
      begin
        // 写入错误日志
        TOneGlobal.GetInstance().Log.WriteLog('OneExcept', e.Message);
        QHTTPResult.ResultException := e.Message;
        QHTTPResult.ResultStatus := 500;
      end;
    end;
  finally
    self.RemoveCurrentThreadLock(lThreadID);
    // 返回的code
    { 结果进行编码,目标没有明确说明编码时,采用utf8编码 }
    EndCodeResultOut(QHTTPCtxt, QHTTPResult);
    if not isInvokeOK then
    begin
      self.DoWorkCustErrResult(QHTTPCtxt, QHTTPResult)
    end;

    Result := QHTTPResult.ResultStatus;
    { 是否支持跨域访问 }
    if bAllowOrigin then
    begin
      QHTTPCtxt.AddCustomerHead('Access-Control-Allow-Origin', '*');
      QHTTPCtxt.AddCustomerHead('Access-Control-Allow-Credentials', 'true');
      QHTTPCtxt.AddCustomerHead('Access-Control-Allow-Headers', 'DNT,X-Mx-ReqToken,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Authorization');
    end;
    if self.FRouterItem <> nil then
    begin
      // 多例模式，多是独立的可以有
      if self.FRouterItem.RouterMode = emRouterMode.pool then
      begin
        self.FHTTPCtxt := nil;
        self.FHTTPResult := nil;
      end;
    end;
    // 释放参数放在最后，有可能输出结果要用到参数
    self.DoMethodFreeParams(LParamNewObjList, LParamObjRttiList);
    LParamNewObjList.Clear;
    LParamNewObjList.Free;
    LParamObjRttiList.Clear;
    LParamObjRttiList.Free;
  end;
end;

procedure TOneControllerBase.EndCodeResultOut(QHTTPCtxt: THTTPCtxt; QHTTPResult: THTTPResult);
begin
  OneHttpCtxtResult.EndCodeResultOut(QHTTPCtxt, QHTTPResult);
end;

// ;var QParamNewObjs: TList<Tobject>
function TOneControllerBase.DoMethodGetParams(QHTTPCtxt: THTTPCtxt; QHTTPResult: THTTPResult; QOneMethodRtti: TOneMethodRtti; QParamObjRttiList: TList<TRttiType>; QParamNewObjList: TList<TObject>;
  Var QErrMsg: string): TArray<TValue>;
var
  lArgs: TArray<TValue>;
  lParameters: TArray<TRttiParameter>;
  lParam: TRttiParameter;
  lParamTClass: TClass;
  iParamLen, iParam, iIndex: Integer;
  tempInt: Integer;
  tempInt64: Int64;
  tempFloat: double;
  tempStr: string;
  tempStrArr: TArray<string>;
  tempObj: TObject;
  tempTValue: TValue;
  lFormList: TStringList;
  // lJsonObj: TJsonObject;
  lJsonArr: TJSONArray;
  lJSonValue, lJsonValueClass: TJSONValue;
  LReader: TNeonDeserializerJSON;
  lCreateMethodRtti: TRttiMethod;
  lCreateTValue: TValue;
  // 表单提交
  lMultipartDecode: TOneMultipartDecode;
  isOnlyHttpParam: Boolean;
begin
  lArgs := nil;
  Result := nil;
  lJSonValue := nil;
  QErrMsg := '';
  lParameters := QOneMethodRtti.RttiMethod.GetParameters();
  if lParameters = nil then
    exit;
  iParamLen := length(lParameters);
  if iParamLen = 0 then
    exit;
  setLength(lArgs, iParamLen);
  try

    //
    case QOneMethodRtti.HttpMethodType of

      emOneHttpMethodMode.OneGet, emOneHttpMethodMode.OneDownload:
        begin
{$REGION}
          // url获取参数,不能有类
          if QOneMethodRtti.HaveClassParam then
          begin
            QErrMsg := '取URL参数,参数不可为类';
            exit;
          end;
          for iParam := Low(lParameters) to High(lParameters) do
          begin
            lParam := lParameters[iParam];
            // 获取参数值
            iIndex := QHTTPCtxt.UrlParams.IndexOfName(lParam.Name);
            case lParam.ParamType.TypeKind of
              tkInteger, tkInt64, tkFloat:
                begin
                  if iIndex >= 0 then
                  begin
                    tempStr := QHTTPCtxt.UrlParams.Values[lParam.Name];
                    tempStr := tempStr.Trim;
                    if tempStr = '' then
                    begin
                      lArgs[iParam] := 0;
                    end
                    else
                    begin
                      if lParam.ParamType.TypeKind = tkInteger then
                      begin
                        if tryStrToInt(tempStr, tempInt) then
                        begin
                          lArgs[iParam] := tempInt;
                        end
                        else
                        begin
                          QErrMsg := 'URL参数' + lParam.Name + '转化成整型出错';
                          exit;
                        end;
                      end
                      else if lParam.ParamType.TypeKind = tkInt64 then
                      begin
                        if tryStrToInt64(tempStr, tempInt64) then
                        begin
                          lArgs[iParam] := tempInt64;
                        end
                        else
                        begin
                          QErrMsg := 'URL参数' + lParam.Name + '转化成整型64出错';
                          exit;
                        end;
                      end
                      else if lParam.ParamType.TypeKind = tkFloat then
                      begin
                        if TryStrToFloat(tempStr, tempFloat) then
                        begin
                          lArgs[iParam] := tempFloat;
                        end
                        else
                        begin
                          QErrMsg := 'URL参数' + lParam.Name + '转化成小数出错';
                          exit;
                        end;
                      end;
                    end;
                  end
                  else
                  begin
                    lArgs[iParam] := 0;
                  end;
                end;
              tkString, tkUString, tkWChar, tkLString, tkWString, tkChar:
                begin
                  // 不存在这个参数会默认''
                  if iIndex >= 0 then
                    lArgs[iParam] := QHTTPCtxt.UrlParams.Values[lParam.Name]
                  else
                    lArgs[iParam] := '';
                end;
            end;
          end;
{$ENDREGION}
        end;

      emOneHttpMethodMode.OnePost, emOneHttpMethodMode.OneAll:
        begin
{$REGION}
          isOnlyHttpParam := False;
          if iParamLen > 0 then
          begin
            // 如果参数只有  THTTPCtxt,THTTPResult不需要判断上传内容格式
            // 自由把控
            isOnlyHttpParam := true;
            for iParam := Low(lParameters) to High(lParameters) do
            begin
              lParam := lParameters[iParam];
              case lParam.ParamType.TypeKind of
                tkClass:
                  begin
                    lParamTClass := QOneMethodRtti.ParamClassList[iParam];
                    if lParamTClass.InheritsFrom(THTTPCtxt) then
                    begin
                    end
                    else if lParamTClass.InheritsFrom(THTTPResult) then
                    begin
                    end
                    else
                    begin
                      isOnlyHttpParam := False;
                    end;
                  end
              else
                isOnlyHttpParam := False;
              end;
            end;
          end;

          if not isOnlyHttpParam then
          begin
            // 判断是不是JSON格式
            if QHTTPCtxt.RequestInContent = '' then
            begin
              QErrMsg := '此接口需提供相关参数,当前POST提交的数据为空';
              exit;
            end;
            // 转成JSON参数
            lJSonValue := nil;
            // 判断是不是表单
            if OneMultipart.IsMultipartForm(QHTTPCtxt.RequestContentType) then
            begin
              if iParamLen > 1 then
              begin
                QErrMsg := '表单提交,只能有一个参数且类型TOneMultipartDecode';
                exit;
              end;
            end
            else
            begin

              lJSonValue := TJsonObject.ParseJSONValue(string(QHTTPCtxt.RequestInContent));
              if lJSonValue = nil then
              begin
                QErrMsg := '提交的数据不是合法JSON格式';
                exit;
              end;
              if not((lJSonValue is TJsonObject) or (lJSonValue is TJSONArray)) then
              begin
                QErrMsg := '提交的数据不是合法JSON格式';
                exit;
              end;
            end;
          end;

          //
          for iParam := Low(lParameters) to High(lParameters) do
          begin
            lParam := lParameters[iParam];
            case lParam.ParamType.TypeKind of
              tkInteger, tkInt64, tkFloat:
                begin
                  if not lJSonValue.TryGetValue<string>(lParam.Name, tempStr) then
                  begin
                    lArgs[iParam] := 0;
                    continue;
                  end;
                  if tempStr = '' then
                  begin
                    lArgs[iParam] := 0;
                  end;
                  tempStr := tempStr.Trim;
                  if tempStr = '' then
                  begin
                    lArgs[iParam] := 0;
                  end
                  else
                  begin
                    if lParam.ParamType.TypeKind = tkInteger then
                    begin
                      if tryStrToInt(tempStr, tempInt) then
                      begin
                        lArgs[iParam] := tempInt;
                      end
                      else
                      begin
                        QErrMsg := '提交的参数' + lParam.Name + '转化成整型出错';
                        exit;
                      end;
                    end
                    else if lParam.ParamType.TypeKind = tkInt64 then
                    begin
                      if tryStrToInt64(tempStr, tempInt64) then
                      begin
                        lArgs[iParam] := tempInt64;
                      end
                      else
                      begin
                        QErrMsg := '提交的参数' + lParam.Name + '转化成整型64出错';
                        exit;
                      end;
                    end
                    else if lParam.ParamType.TypeKind = tkFloat then
                    begin
                      if TryStrToFloat(tempStr, tempFloat) then
                      begin
                        lArgs[iParam] := tempFloat;
                      end
                      else
                      begin
                        QErrMsg := '提交的参数' + lParam.Name + '转化成小数出错';
                        exit;
                      end;
                    end;
                  end;
                end;
              tkString, tkUString, tkWChar, tkLString, tkWString, tkChar:
                begin
                  // 不存在这个参数会默认''
                  if not lJSonValue.TryGetValue<string>(lParam.Name, tempStr) then
                  begin
                    lArgs[iParam] := '';
                    continue;
                  end;
                  lArgs[iParam] := tempStr;
                end;
              tkClass:
                begin
                  lParamTClass := QOneMethodRtti.ParamClassList[iParam];
                  if lParamTClass.InheritsFrom(THTTPCtxt) then
                  begin
                    lArgs[iParam] := QHTTPCtxt;
                  end
                  else if lParamTClass.InheritsFrom(THTTPResult) then
                  begin
                    lArgs[iParam] := QHTTPResult;
                  end
                  else if lParamTClass.InheritsFrom(TJSONValue) then
                  begin
                    if iParamLen > 1 then
                    begin
                      QErrMsg := '提交的参数' + lParam.Name + '是必需的参数,否则对像为nil';
                      exit;
                    end;
                    if (lJSonValue is TJsonObject) or (lJSonValue is TJSONArray) then
                    begin
                      lJsonValueClass := TJSONValue(lJSonValue.Clone);
                      lArgs[iParam] := lJsonValueClass;
                      QParamNewObjList.Add(lJsonValueClass);
                      QParamObjRttiList.Add(lParam.ParamType);
                    end
                    else
                    begin
                      QErrMsg := '提交的参数' + lParam.Name + '必需是Json对象或JSON数组';
                      exit;
                    end;
                  end
                  else if lParamTClass.InheritsFrom(TOneMultipartDecode) then
                  begin
                    lMultipartDecode := OneMultipart.MultipartFormDeCode(QHTTPCtxt.RequestContentType, QHTTPCtxt.RequestInContent, QErrMsg);
                    if lMultipartDecode = nil then
                      exit;
                    lArgs[iParam] := lMultipartDecode;
                    QParamNewObjList.Add(lMultipartDecode);
                    QParamObjRttiList.Add(lParam.ParamType);
                  end
                  else
                  begin
                    lJsonValueClass := lJSonValue;
                    if iParamLen > 1 then
                    begin
                      // 参数多个时跟据参数名称转到对应的节点
{$IF CompilerVersion >=33}
                      lJsonValueClass := lJSonValue.FindValue(lParam.Name);
{$ELSE}
                      // 10.2 FindValue 没开放
                      lJsonValueClass := lJSonValue.GetValue<TJSONValue>(lParam.Name, nil);
{$ENDIF}
                      if lJsonValueClass = nil then
                      begin
                        // 找不到传nil
                        QErrMsg := '提交的参数' + lParam.Name + '是必需的参数,否则对像为nil';
                        exit;
                      end;
                    end;
                    // lJsonValueClass,判断类型
                    if (lJSonValue is TJsonObject) or (lJSonValue is TJSONArray) then
                    begin
                      // 判断是不是容器,不是的话，退出
                      if not QOneMethodRtti.ParamIsArryList[iParam] then
                      begin
                        if lJSonValue is TJSONArray then
                        begin
                          QErrMsg := '请提交Json对象,参数非容器数组。';
                          exit;
                        end;
                      end;

                    end
                    else
                    begin
                      QErrMsg := '提交的参数' + lParam.Name + '必需是Json对象或JSON数组';
                      exit;
                    end;

                    // tempObj := TList<TPersonDemo>.Create;
                    lCreateMethodRtti := lParam.ParamType.GetMethod('Create');
                    if lCreateMethodRtti = nil then
                    begin
                      QErrMsg := lParam.Name + '是类参数,无法找到CreateRtti信息';
                      exit;
                    end;
                    // 动态创建对角
                    lCreateTValue := lCreateMethodRtti.Invoke(lParamTClass, []);
                    tempObj := lCreateTValue.AsObject;
                    QParamNewObjList.Add(tempObj);
                    QParamObjRttiList.Add(lParam.ParamType);
                    // 把JSON序列化成对象
                    LReader := TNeonDeserializerJSON.Create(OneNeonHelper.GetDefalutNeonConfiguration());
                    try
                      tempTValue := LReader.JSONToTValue(lJsonValueClass, lParam.ParamType, tempObj);
                      lArgs[iParam] := tempTValue.AsObject;
                    finally
                      LReader.Free;
                    end;
                  end;

                end;
              tkRecord:
                begin
                  // 结构体支持
                  lJsonValueClass := lJSonValue;
                  if iParamLen > 1 then
                  begin
                    // 参数多个时跟据参数名称转到对应的节点
                    // 参数多个时跟据参数名称转到对应的节点
{$IF CompilerVersion >=33}
                    lJsonValueClass := lJSonValue.FindValue(lParam.Name);
{$ELSE}
                    // 10.2 FindValue 没开放
                    lJsonValueClass := lJSonValue.GetValue<TJSONValue>(lParam.Name, nil);
{$ENDIF}
                    if lJsonValueClass = nil then
                    begin
                      // 找不到传nil
                      QErrMsg := '提交的参数' + lParam.Name + '是必需的参数,否则对像为nil';
                      exit;
                    end;
                  end;
                  // lJsonValueClass,判断类型

                  // 动态创建结构
                  TValue.Make(nil, lParam.ParamType.Handle, lCreateTValue);
                  // 把JSON序列化成结构
                  LReader := TNeonDeserializerJSON.Create(OneNeonHelper.GetDefalutNeonConfiguration());
                  try
                    tempTValue := LReader.JSONToTValue(lJsonValueClass, lParam.ParamType, lCreateTValue);
                    lArgs[iParam] := tempTValue;
                  finally
                    LReader.Free;
                  end;
                end;
            end;
          end;
{$ENDREGION}
        end;
      emOneHttpMethodMode.OnePath:
        begin
          // 分析Url获取参数
          tempStr := QHTTPCtxt.URLPath.Substring(length(QOneMethodRtti.UrlMethod) + 1);
          tempStrArr := SplitString(tempStr, '/');
          if length(tempStrArr) <> QOneMethodRtti.paramCount then
          begin
            QErrMsg := 'Url路径参数与所需的函数参数个数不一至';
            exit;
          end;
          for iParam := Low(lParameters) to High(lParameters) do
          begin
            lParam := lParameters[iParam];
            // 获取参数值
            tempStr := tempStrArr[iParam];
            case lParam.ParamType.TypeKind of
              tkInteger, tkInt64, tkFloat:
                begin
                  if lParam.ParamType.TypeKind = tkInteger then
                  begin
                    if tryStrToInt(tempStr, tempInt) then
                    begin
                      lArgs[iParam] := tempInt;
                    end
                    else
                    begin
                      QErrMsg := 'URL参数' + lParam.Name + '转化成整型出错';
                      exit;
                    end;
                  end
                  else if lParam.ParamType.TypeKind = tkInt64 then
                  begin
                    if tryStrToInt64(tempStr, tempInt64) then
                    begin
                      lArgs[iParam] := tempInt64;
                    end
                    else
                    begin
                      QErrMsg := 'URL参数' + lParam.Name + '转化成整型64出错';
                      exit;
                    end;
                  end
                  else if lParam.ParamType.TypeKind = tkFloat then
                  begin
                    if TryStrToFloat(tempStr, tempFloat) then
                    begin
                      lArgs[iParam] := tempFloat;
                    end
                    else
                    begin
                      QErrMsg := 'URL参数' + lParam.Name + '转化成小数出错';
                      exit;
                    end;
                  end;
                end;
              tkString, tkUString, tkWChar, tkLString, tkWString, tkChar:
                begin
                  // 不存在这个参数会默认''
                  lArgs[iParam] := tempStr;
                end;
            end;
          end;
        end;
      emOneHttpMethodMode.OneForm:
        begin
{$REGION}
          if QOneMethodRtti.HaveClassParam then
          begin
            QErrMsg := '表单提交不支持类参数';
            exit;
          end;
          // 判断是不是JSON格式
          if QHTTPCtxt.RequestInContent = '' then
          begin
            QErrMsg := '表单提交无任何数据';
            exit;
          end;
          //
          lFormList := TStringList.Create;
          lFormList.LineBreak := '&';
          try
            lFormList.Text := QHTTPCtxt.RequestInContent;
            for iParam := Low(lParameters) to High(lParameters) do
            begin
              lParam := lParameters[iParam];
              // 获取参数值
              iIndex := lFormList.IndexOfName(lParam.Name);
              case lParam.ParamType.TypeKind of
                tkInteger, tkInt64, tkFloat:
                  begin
                    if iIndex >= 0 then
                    begin
                      tempStr := lFormList.Values[lParam.Name];
                      tempStr := tempStr.Trim;
                      if tempStr = '' then
                      begin
                        lArgs[iParam] := 0;
                      end
                      else
                      begin
                        if lParam.ParamType.TypeKind = tkInteger then
                        begin
                          if tryStrToInt(tempStr, tempInt) then
                          begin
                            lArgs[iParam] := tempInt;
                          end
                          else
                          begin
                            QErrMsg := 'URL参数' + lParam.Name + '转化成整型出错';
                            exit;
                          end;
                        end
                        else if lParam.ParamType.TypeKind = tkInt64 then
                        begin
                          if tryStrToInt64(tempStr, tempInt64) then
                          begin
                            lArgs[iParam] := tempInt64;
                          end
                          else
                          begin
                            QErrMsg := 'URL参数' + lParam.Name + '转化成整型64出错';
                            exit;
                          end;
                        end
                        else if lParam.ParamType.TypeKind = tkFloat then
                        begin
                          if TryStrToFloat(tempStr, tempFloat) then
                          begin
                            lArgs[iParam] := tempFloat;
                          end
                          else
                          begin
                            QErrMsg := 'URL参数' + lParam.Name + '转化成小数出错';
                            exit;
                          end;
                        end;
                      end;
                    end
                    else
                    begin
                      lArgs[iParam] := 0;
                    end;
                  end;
                tkString, tkUString, tkWChar, tkLString, tkWString, tkChar:
                  begin
                    // 不存在这个参数会默认''
                    if iIndex >= 0 then
                      lArgs[iParam] := lFormList.Values[lParam.Name]
                    else
                      lArgs[iParam] := '';
                  end;
              end;
            end;
          finally
            lFormList.Clear;
            lFormList.Free;
          end;
{$ENDREGION}
        end;
    end;
  finally
    if lJSonValue <> nil then
    begin
      lJSonValue.Free;
    end;
    tempStrArr := nil;
  end;
  Result := lArgs;
end;

procedure TOneControllerBase.DoMethodFreeParams(QParamObjList: TList<TObject>; QParamObjRttiList: TList<TRttiType>);
var
  i, iItem: Integer;
  lParamRtti: TRttiType;
  lOneResultType: emOneMethodResultType;
  lList: TList;
  lObjeList: TObjectList;
  lListT: TList<TObject>;
  lObjeListT: TObjectList<TObject>;
  LMethodAdd: TRttiMethod;
  LItemType: TRttiType;
begin
  for i := 0 to QParamObjList.Count - 1 do
  begin
    // 这边还得判断参数是不是List要释放,如果对象是个List要释放
    lParamRtti := QParamObjRttiList[i];
    if QParamObjList[i] = nil then
      continue;
    lOneResultType := TOneControllerRtti.GetRttiTypeToResultType(lParamRtti);
    case lOneResultType of
      objResult:
        begin
          if QParamObjList[i] <> nil then
          begin
            QParamObjList[i].Free;
            QParamObjList[i] := nil;
          end;
        end;
      listResult:
        begin
          // 还得判断
          lList := TList(QParamObjList[i]);
          for iItem := 0 to lList.Count - 1 do
          begin
            if TObject(lList[iItem]) <> nil then
            begin
              TObject(lList[iItem]).Free;
            end;
          end;
          lList.Clear;
        end;
      objListResult:
        begin
          lObjeList := TObjectList(QParamObjList[i]);
          if not lObjeList.OwnsObjects then
          begin
            for iItem := 0 to lObjeList.Count - 1 do
            begin
              if lObjeList[iItem] <> nil then
                lObjeList[iItem].Free;
            end;
          end;
          lObjeList.Clear;
          lObjeList.Free;
        end;
      genericsListResult:
        begin
          // 还得判断item类型
          LMethodAdd := lParamRtti.GetMethod('Add');
          if not Assigned(LMethodAdd) or (length(LMethodAdd.GetParameters) <> 1) then
            exit;
          LItemType := LMethodAdd.GetParameters[0].ParamType;
          case LItemType.TypeKind of
            tkClass:
              begin
                // 是类要释放
                lListT := TList<TObject>(QParamObjList[i]);
                for iItem := 0 to lListT.Count - 1 do
                begin
                  if lListT[iItem] <> nil then
                    lListT[iItem].Free;
                end;
                lListT.Clear;
                lListT.Free;
              end
          else
            begin
              QParamObjList[i].Free;
            end;
          end;
        end;
      genericsObjListResult:
        begin
          lObjeListT := TObjectList<TObject>(QParamObjList[i]);
          if not lObjeListT.OwnsObjects then
          begin
            for iItem := 0 to lObjeListT.Count - 1 do
            begin
              if lObjeListT[iItem] <> nil then
              begin
                lObjeListT[iItem].Free;
                lObjeListT[iItem] := nil;
              end;
            end;
          end;
          lObjeListT.Clear;
          lObjeListT.Free;
        end;
    end;
  end;
end;

function TOneControllerBase.DoMethod(QHTTPCtxt: THTTPCtxt; QHTTPResult: THTTPResult;
  QParamNewObjList: TList<TObject>; QParamObjRttiList: TList<TRttiType>): Boolean;
var
  lOneMethodRtti: TOneMethodRtti;
  lArgs: TArray<TValue>;
  LValue: TValue;
  lParamErrMsg: string;
  i: Integer;
  isInvoke: Boolean;
begin
  // 根据rtti来反射方法
  Result := False;
  LValue := nil;
  isInvoke := False;
  if FRouterItem = nil then
  begin
    QHTTPResult.ResultMsg := '无相关的路由信息,无法进行方法调用!!!';
    exit;
  end;
  // 解析反射信息调用
  lOneMethodRtti := FRouterItem.GetRttiMethod(QHTTPCtxt.ControllerMethodName);
  if lOneMethodRtti = nil then
  begin
    QHTTPResult.ResultMsg := '无相关的路由方法反射信息,无法进行方法调用!!!';
    exit;
  end;
  if lOneMethodRtti.ErrMsg <> '' then
  begin
    QHTTPResult.ResultMsg := lOneMethodRtti.ErrMsg;
    exit;
  end;
  // 访问方式控制
  if lOneMethodRtti.HttpMethodType <> emOneHttpMethodMode.OneAll then
  begin
    case lOneMethodRtti.HttpMethodType of
      emOneHttpMethodMode.OneGet:
        begin
          if QHTTPCtxt.Method.ToUpper() <> 'GET' then
          begin
            QHTTPResult.ResultMsg := QHTTPCtxt.ControllerMethodName + '只支持GET访问!!!';
            exit;
          end;
        end;
      emOneHttpMethodMode.OnePost, emOneHttpMethodMode.OneForm:
        begin
          if QHTTPCtxt.Method.ToUpper() <> 'POST' then
          begin
            QHTTPResult.ResultMsg := UTF8Encode(QHTTPCtxt.ControllerMethodName + '只支持POST访问!!!');
            exit;
          end;
        end;
    end;
  end;
  lArgs := nil;
  try
    // 反射调用
    case lOneMethodRtti.MethodType of
      resultProcedure:
        begin
          try
            lOneMethodRtti.RttiMethod.Invoke(self, [QHTTPCtxt, QHTTPResult]);
          except
            on e: Exception do
            begin
              QHTTPResult.ResultMsg := e.Message;
              exit;
            end;
          end;
          isInvoke := true;
        end;
      sysProcedure, sysFunction:
        begin
          lArgs := self.DoMethodGetParams(QHTTPCtxt, QHTTPResult, lOneMethodRtti, QParamObjRttiList, QParamNewObjList, lParamErrMsg);
          if lParamErrMsg <> '' then
          begin
            QHTTPResult.ResultMsg := lParamErrMsg;
            exit;
          end;
          // 这边如果产生异常,会造成LValue未释放
          try
            LValue := lOneMethodRtti.RttiMethod.Invoke(self, lArgs);
          except
            on e: Exception do
            begin
              QHTTPResult.ResultMsg := e.Message;
              exit;
            end;
          end;
          if (lOneMethodRtti.MethodType = sysProcedure) then
          begin
            exit;
          end;
          isInvoke := true;
          // 结果判断
          case LValue.TypeInfo.Kind of
            tkInteger, tkFloat, tkInt64:
              begin
                QHTTPResult.ResultOut := VarToStr(LValue.AsVariant);
                QHTTPResult.ResultOutMode := THTTPResultMode.Text;
                QHTTPResult.SetHTTPResultTrue();
              end;
            tkString, tkUString, tkWChar, tkLString, tkWString:
              begin
                QHTTPResult.ResultOut := LValue.AsString;
                QHTTPResult.ResultOutMode := THTTPResultMode.Text;
                QHTTPResult.SetHTTPResultTrue();
              end;
            tkClass:
              begin
                QHTTPResult.ResultObj := LValue.AsObject;
                QHTTPResult.SetMethodRtti(lOneMethodRtti);
                QHTTPResult.ResultOutMode := THTTPResultMode.Text;
                QHTTPResult.SetHTTPResultTrue();
                // 如果参数就是结果返回
              end;
            tkRecord, tkEnumeration:
              begin
                QHTTPResult.ResultTValue := LValue;
                QHTTPResult.ResultOutMode := THTTPResultMode.Text;
                QHTTPResult.SetHTTPResultTrue();
              end;
            // 数组
            // tkDynArray,tkArray:
            // begin
            //
            // end
          else
            begin
              QHTTPResult.ResultMsg := '未支持的函数[' + QHTTPCtxt.ControllerMethodName + ']返回值类型!!!';
              exit;
            end;
          end;
        end;
    else
      begin
        QHTTPResult.ResultMsg := '未知的方法[' + QHTTPCtxt.ControllerMethodName + ']类型调用!!!';
        exit;
      end;
    end;
  finally
    setLength(lArgs, 0);
    lArgs := nil;
  end;
  Result := true;
end;

function TOneControllerBase.JSONToObject(Instance: TObject; const JSON: string): Boolean;
begin
end;

procedure TOneControllerBase.DoWorkCustErrResult(QHTTPCtxt: THTTPCtxt; QHTTPResult: THTTPResult);
begin

end;

end.

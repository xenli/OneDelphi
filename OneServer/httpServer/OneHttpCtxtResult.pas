unit OneHttpCtxtResult;

interface

uses
  System.SysUtils, System.Classes, Web.HTTPApp, System.Generics.Collections,
  System.StrUtils, System.JSON, System.JSON.Serializers, Rest.JSON,
  Rest.JsonReflect, Neon.Core.Persistence.JSON, Neon.Core.Persistence,
  System.Contnrs, OneHttpControllerRtti, Neon.Core.Serializers.DB,
  Neon.Core.Serializers.RTL, Neon.Core.Serializers.Nullables, OneNeonHelper,
  System.Rtti, OneRttiHelper, OneHttpConst, OneControllerResult, OneMultipart;

type
  THTTPCtxt = class;
  THTTPResult = class;
  // 挂载路由函数模式
  TEvenControllerProcedure = procedure(QHTTPCtxt: THTTPCtxt; QHTTPResult: THTTPResult);
  // 创建控制层获取一个对象
  THTTPResultMode = (ResultJSON, TEXT, URL, OUTFILE, HTML);

  // standResult 字符串，数字，时间，布尔
  // objResult返回的是个对象
  // objListResult 返回的是个TObjectList
  // listResult 返回的是个TList
  // genericsListResult 返回的是个TList<T> 或对象
  // genericsObjListResult TObjectList<T>
  // arrayResult 返回的是数组或动态数组
  TPersonDemo = class
  private
    FaName: string;
    FAag: integer;
  public
    property name: string read FaName write FaName;
    property age: integer read FAag write FAag;
  end;

  TPersonrecord = record
  public
    name: string;
    age: integer;
  end;

  // 与TActionResult保持一至
  THTTPResult = class
  private
    FResultSuccess: boolean;
    FResultStatus: cardinal;
    FResultCode: string;
    FResultMsg: RawByteString;
    FResultOutMode: THTTPResultMode;
    FResultOut: string;
    FResultObj: TObject;
    FResultTValue: TValue;
    FResultCount: integer;
    { 服务端返回一个URL重定向 }
    FResultRedirect: string;
    FResultParams: String;
    // 异常捕捉
    FResultException: string;
    //
    FOneMethodRtti: TOneMethodRtti;
  public
    procedure SetHTTPResultTrue();
    procedure SetMethodRtti(QOneMethodRtti: TOneMethodRtti);
    destructor Destroy; override;
    function ResultToJson(): string;

  published
    property ResultSuccess: boolean read FResultSuccess write FResultSuccess;
    property ResultStatus: cardinal read FResultStatus write FResultStatus;
    property ResultCode: string read FResultCode write FResultCode;
    property ResultMsg: RawByteString read FResultMsg write FResultMsg;
    property ResultOutMode: THTTPResultMode read FResultOutMode write FResultOutMode;
    property ResultOut: string read FResultOut write FResultOut;
    property ResultObj: TObject read FResultObj write FResultObj;
    property ResultTValue: TValue read FResultTValue write FResultTValue;
    property ResultCount: integer read FResultCount write FResultCount;
    property ResultRedirect: string read FResultRedirect write FResultRedirect;
    property ResultParams: string read FResultParams write FResultParams;
    property ResultException: string read FResultException write FResultException;
  end;

  THTTPCtxt = class
  private
    FConnectionID: int64;
    // HTTP请求方法 GET,POST等
    FMethod: string;
    // 执行控制器哪个方法
    FControllerMethodName: string;
    // 客户端IP
    FClientIP: string;
    // 客户端MAC地址
    FClientMAC: string;
    // URL路径 有参数代参数 ?xxxx=zzzz
    FUrl: String;
    // url不代参数 ？?xxxx=zzzz
    FUrlPath: string;
    // URL请求的参数
    FUrlParams: TStringList;
    // 头部参数
    FHeadParamList: TStringList;
    // 获取请求数据发起的格式和编码
    FRequestContentType: string;
    FRequestContentTypeCharset: String;
    // 请求的数据
    FRequestInContent: RawByteString;
    // 请求的头部
    FRequestInHeaders: RawByteString;
    // HTTP请求的内容
    FOutContent: RawByteString;
    // 获取请求返回接受的格式和编码
    FRequestAccept: string;
    FRequestAcceptCharset: string;
    { 自定义head解析 }
    FResponCustHeaderList: RawByteString;
    FTokenUserCode: string;
  public
    destructor Destroy; override;
    procedure SetUrlParams();
    procedure SetHeadParams();
    procedure SetInContent(qInContent: RawByteString);
  public
    procedure AddCustomerHead(QHead: string; QConnect: string);
    property ConnectionID: int64 read FConnectionID write FConnectionID;
    property URL: String read FUrl write FUrl;
    property URLPath: String read FUrlPath write FUrlPath;
    property ClientIP: String read FClientIP write FClientIP;
    property ClientMAC: String read FClientMAC write FClientMAC;
    property UrlParams: TStringList read FUrlParams write FUrlParams;
    property HeadParamList: TStringList read FHeadParamList write FHeadParamList;
    property RequestContentType: String read FRequestContentType write FRequestContentType;
    property RequestContentTypeCharset: String read FRequestContentTypeCharset write FRequestContentTypeCharset;
    property RequestInContent: RawByteString read FRequestInContent write FRequestInContent;
    property RequestInHeaders: RawByteString read FRequestInHeaders write FRequestInHeaders;
    property OutContent: RawByteString read FOutContent write FOutContent;
    property RequestAccept: String read FRequestAccept write FRequestAccept;
    property ResponCustHeaderList: RawByteString read FResponCustHeaderList write FResponCustHeaderList;
    property TokenUserCode: String read FTokenUserCode write FTokenUserCode;
    property Method: String read FMethod write FMethod;
    property ControllerMethodName: String read FControllerMethodName write FControllerMethodName;
    property RequestAcceptCharset: string read FRequestAcceptCharset write FRequestAcceptCharset;
  end;

function CreateNewHTTPResult: THTTPResult;
function IsMultipartForm(QContentType: string): boolean;
function FormatRootName(QRootName: string): string;
procedure EndCodeResultOut(QHTTPCtxt: THTTPCtxt; QHTTPResult: THTTPResult);

implementation

const
  sMultiPartFormData = 'multipart/form-data';

function IsMultipartForm(QContentType: string): boolean;
var
  lList: TList;
  lList2: TList<integer>;
  l: TObjectList;
begin
  Result := StrLIComp(PChar(QContentType), PChar(sMultiPartFormData), Length(sMultiPartFormData)) = 0;
end;

function FormatRootName(QRootName: string): string;
var
  lRootName: string;
  iFirst: integer;
begin
  lRootName := QRootName.Trim();
  lRootName := lRootName.ToLower;
  if lRootName = '' then
  begin
    Result := '';
    exit;
  end;
  lRootName := lRootName.Replace('\', '/');
  // lRootName处理  /name1/name2 最终格式
  // 判断第一个是不是/不是话的加上
  iFirst := lRootName.IndexOf('/');
  if iFirst <> 0 then
  begin
    lRootName := '/' + lRootName;
  end;
  // 判断最后一个是不是/是的话去除
  if RightStr(lRootName, 1) = '/' then
  begin
    lRootName := Copy(lRootName, 0, lRootName.Length - 1);
  end;
  Result := lRootName;
end;

procedure EndCodeResultOut(QHTTPCtxt: THTTPCtxt; QHTTPResult: THTTPResult);
var
  vBytes: TBytes;
  LJSON: TJSONValue;
  LWriter: TNeonSerializerJSON;
  lSerializerObj: TObject;
  lListT: TList<TObject>;
  i: integer;
  lNeonConfiguration: INeonConfiguration;
  lResultStr: TActionResult<string>;
begin
  if QHTTPResult.ResultRedirect <> '' then
  begin
    if QHTTPCtxt.Method = 'GET' then
      QHTTPResult.ResultStatus := 302;
    QHTTPCtxt.AddCustomerHead('Location', QHTTPResult.ResultRedirect);
  end
  else
  begin
    if (QHTTPResult.ResultOutMode = THTTPResultMode.ResultJSON) then
    begin
      QHTTPCtxt.OutContent := QHTTPResult.ResultToJson()
    end
    else if QHTTPResult.ResultOutMode = THTTPResultMode.TEXT then
    begin
      if QHTTPResult.ResultObj <> nil then
      begin
        // 序列化对象
        lListT := nil;
        lSerializerObj := QHTTPResult.ResultObj;
        if QHTTPResult.FOneMethodRtti <> nil then
        begin
          // 容器转化成泛型容器,因为序列化对泛型容器比较友好
          if (QHTTPResult.FOneMethodRtti.ResultType = emOneMethodResultType.listResult) or (QHTTPResult.FOneMethodRtti.ResultType = emOneMethodResultType.objListResult) then
          begin
            lListT := TList<TObject>.Create;
            for i := 0 to TList(lSerializerObj).Count - 1 do
            begin
              lListT.Add(TList(lSerializerObj)[i]);
            end;
            lSerializerObj := lListT;
          end;
        end;
        //
        if lSerializerObj is TJSONValue then
        begin
          // 返回的是JSON对象直接输出JSON
          QHTTPCtxt.OutContent := TJSONValue(lSerializerObj).ToString();
        end
        else if lSerializerObj is TActionResult<string> then
        begin
          lResultStr := TActionResult<string>(lSerializerObj);
          if (lResultStr.IsResultFile) and (lResultStr.ResultSuccess) then
          begin
            QHTTPResult.ResultOutMode := THTTPResultMode.OUTFILE;
            QHTTPCtxt.OutContent := TActionResult<string>(lSerializerObj).ResultData;
          end
          else
          begin
            QHTTPCtxt.OutContent := OneNeonHelper.ObjectToJsonString(lSerializerObj);
          end;
        end
        else
        begin
          try
            QHTTPCtxt.OutContent := OneNeonHelper.ObjectToJsonString(lSerializerObj);
          finally
            if lListT <> nil then
            begin
              lListT.Clear;
              lListT.Free;
            end;
          end;
        end;
      end
      else if (not QHTTPResult.ResultTValue.IsEmpty) then
      begin
        // TValue序列化
        QHTTPCtxt.OutContent := OneNeonHelper.ValueToJSONString(QHTTPResult.ResultTValue);
      end
      else
      begin
        QHTTPCtxt.OutContent := QHTTPResult.ResultOut;
      end;
    end
    else
    begin
      QHTTPCtxt.OutContent := QHTTPResult.ResultOut;
    end;

    if QHTTPCtxt.RequestAcceptCharset = 'UTF-8' then
    begin
      QHTTPCtxt.OutContent := RawByteString(UTF8Encode(QHTTPCtxt.OutContent));
    end
    ELSE if QHTTPCtxt.RequestAcceptCharset = 'GB2312' then
    begin
      vBytes := TEncoding.UTF8.GetBytes(QHTTPCtxt.OutContent);
      QHTTPCtxt.OutContent := RawByteString(TEncoding.getencoding(936).GetString(vBytes));
    end
    else if QHTTPCtxt.RequestAcceptCharset = 'BIG5' then
    BEGIN
      vBytes := TEncoding.UTF8.GetBytes(QHTTPCtxt.OutContent);
      QHTTPCtxt.OutContent := RawByteString(TEncoding.getencoding(950).GetString(vBytes));
    END
    ELSE
    BEGIN
      QHTTPCtxt.OutContent := RawByteString(UTF8Encode(QHTTPCtxt.OutContent));
    END;
  end;
end;

function CreateNewHTTPResult: THTTPResult;
begin
  Result := THTTPResult.Create;
  Result.ResultStatus := 200;
  Result.ResultSuccess := false;
  Result.ResultCode := HTTP_ResultCode_Fail;
  Result.ResultMsg := '';
  Result.ResultOutMode := THTTPResultMode.ResultJSON;
  Result.ResultOut := '';
  Result.ResultCount := 0;
  Result.ResultRedirect := '';
  Result.ResultParams := '';
end;

destructor THTTPResult.Destroy;
// 对象释放
var
  i: integer;
  lListT: TList<TObject>;
  lObjListT: TObjectList<TObject>;
  lList: TList;
  lObjList: TObjectList;
begin
  if FResultObj <> nil then
  begin
    // 泛型List释放
    if self.FOneMethodRtti <> nil then
    begin
      if self.FOneMethodRtti.ResultType = emOneMethodResultType.genericsListResult then
      begin
        if self.FOneMethodRtti.ResultCollectionsValueType = emOneMethodResultType.objResult then
        begin
          lListT := TList<TObject>(FResultObj);
          for i := 0 to lListT.Count - 1 do
          begin
            if lListT[i] <> nil then
              lListT[i].Free;
          end;
          lListT.Clear;
          lListT.Free;
        end
        else
        begin
          FResultObj.Free;
        end;
      end
      else if self.FOneMethodRtti.ResultType = emOneMethodResultType.genericsObjListResult then
      begin
        if self.FOneMethodRtti.ResultCollectionsValueType = emOneMethodResultType.objResult then
        begin
          lObjListT := TObjectList<TObject>(FResultObj);
          if not lObjListT.OwnsObjects then
          begin
            // 自已释放
            for i := 0 to lObjListT.Count - 1 do
            begin
              if lObjListT[i] <> nil then
                lObjListT[i].Free;
            end;
          end;
          lObjListT.Clear;
          lObjListT.Free;
        end
        else
        begin
          FResultObj.Free;
        end;
      end
      else if self.FOneMethodRtti.ResultType = emOneMethodResultType.listResult then
      begin
        lList := TList(FResultObj);
        // 里面是不是对象要遍历判断，这边不处理
        // 主要放 string,int 这些常用类型
        // 自已释放
        for i := 0 to lList.Count - 1 do
        begin
          if TObject(lList[i]) <> nil then
            TObject(lList[i]).Free;
        end;
        lList.Clear;
        FResultObj.Free;
      end
      else if self.FOneMethodRtti.ResultType = emOneMethodResultType.objListResult then
      begin
        if self.FOneMethodRtti.ResultCollectionsValueType = emOneMethodResultType.objResult then
        begin
          lObjList := TObjectList(FResultObj);
          if not lObjList.OwnsObjects then
          begin
            // 自已释放
            for i := 0 to lObjList.Count - 1 do
            begin
              if lObjList[i] <> nil then
                lObjList[i].Free;
            end;
          end;
          lObjListT.Clear;
          FResultObj.Free;
        end
        else
        begin
          FResultObj.Free;
        end;
      end
      else if self.FOneMethodRtti.ResultType = emOneMethodResultType.mapResult then
      begin
        // map如何释放，通过RTTI释放未处理
        if self.FOneMethodRtti.ResultCollectionsKeyType = emOneMethodResultType.objResult then
        begin
          self.FOneMethodRtti.ResultRtti.GetProperty('Keys').GetValue(self.FResultObj);
        end;
        if self.FOneMethodRtti.ResultCollectionsValueType = emOneMethodResultType.objResult then
        begin
          self.FOneMethodRtti.ResultRtti.GetProperty('Values').GetValue(self.FResultObj);
        end;
        FResultObj.Free;
      end
      else
      begin
        FResultObj.Free;
      end;
    end
    else
      FResultObj.Free;
    FResultObj := nil;
  end;
  inherited;
end;

procedure THTTPResult.SetHTTPResultTrue();
begin
  self.FResultSuccess := true;
  self.FResultCode := HTTP_ResultCode_True;
end;

procedure THTTPResult.SetMethodRtti(QOneMethodRtti: TOneMethodRtti);
begin
  self.FOneMethodRtti := QOneMethodRtti;
end;

function THTTPResult.ResultToJson(): string;
var
  lJsonObj: TJsonObject;
  lJsonValue: TJSONValue;
  LWriter: TNeonSerializerJSON;
  i: integer;
  lListT: TList<TObject>;
  lSerializerObj: TObject;
  lNeonConfiguration: INeonConfiguration;
begin
  if self.ResultOutMode <> THTTPResultMode.ResultJSON then
  begin
    Result := '只有ResultOutMode=ResultJSON才格式化JSON';
    exit;
  end;
  lJsonObj := TJsonObject.Create;
  try
    // 与TActionResult保持一至大小写,前台框架统一也是一样的大小写
    lJsonObj.AddPair('ResultSuccess', TJSONBool.Create(self.ResultSuccess));
    lJsonObj.AddPair('ResultCode', self.ResultCode);
    lJsonObj.AddPair('ResultMsg', self.ResultMsg);
    lJsonObj.AddPair('ResultCount', TJSONNumber.Create(self.ResultCount));
    if self.ResultObj <> nil then
    begin
      lListT := nil;
      lSerializerObj := self.ResultObj;
      if self.FOneMethodRtti <> nil then
      begin
        if (self.FOneMethodRtti.ResultType = emOneMethodResultType.listResult) or (self.FOneMethodRtti.ResultType = emOneMethodResultType.objListResult) then
        begin
          lListT := TList<TObject>.Create;
          for i := 0 to TList(lSerializerObj).Count - 1 do
          begin
            lListT.Add(TList(lSerializerObj)[i]);
          end;
          lSerializerObj := lListT;
        end;
      end;
      // 序列化对象
      lNeonConfiguration := OneNeonHelper.GetDefalutNeonConfiguration();
      LWriter := TNeonSerializerJSON.Create(lNeonConfiguration);
      try
        lJsonValue := LWriter.ObjectToJSON(self.ResultObj);
      finally
        LWriter.Free;
        if lListT <> nil then
        begin
          lListT.Clear;
          lListT.Free;
        end;
      end;
      lJsonObj.AddPair('ResultData', lJsonValue);
    end
    else
    begin
      lJsonObj.AddPair('ResultData', self.ResultOut);
    end;
    if self.ResultException <> '' then
    begin
      lJsonObj.AddPair('resultException', self.ResultException);
    end;
    Result := lJsonObj.ToString();
  finally
    lJsonObj.Free;
    lJsonObj := nil;
  end;
end;

procedure THTTPCtxt.SetUrlParams();
var
  iUrl, i: integer;
  vUrlParams: string;
  vArr: TArray<string>;
begin
  // URL参数
  iUrl := 0;
  vUrlParams := '';
  iUrl := PosEx('?', self.FUrl);
  if iUrl > 0 then
  begin
    vUrlParams := Copy(self.FUrl, iUrl + 1, Length(self.FUrl));
    vUrlParams := HTTPDecode(vUrlParams);
    vArr := vUrlParams.Split(['amp;', '&'], TStringSplitOptions.ExcludeEmpty);
    // 如果参数字符串有'&'先切割后解析,保证参数正确
    for i := Low(vArr) to High(vArr) do
    begin
      self.FUrlParams.Add(vArr[i]);
    end;
  end
end;

procedure THTTPCtxt.SetHeadParams();
var
  P, S: PAnsiChar;
  vTagchar: string;
  tempStr: RawByteString;
  vHeadA, vHeadB, vValue: string;
begin
  P := pointer(self.RequestInHeaders);
  S := P;
  while not(S^ in [#0]) do
  begin
    if S^ in [':', '=', ';', #13, #10] then
    begin
      SetString(tempStr, P, S - P);
      vValue := tempStr;
      if S^ = ':' then
      begin
        vHeadA := Trim(tempStr);
      end
      else if S^ = '=' then
      begin
        vHeadB := Trim(tempStr);
      end
      else
      begin
        if (vHeadA = 'Content-Type') and (vHeadB = 'charset') then
        begin
          FRequestContentTypeCharset := vValue.ToUpper;
        end
        else if (vHeadA = 'Accept') and (vHeadB = 'charset') then
        begin
          FRequestAcceptCharset := vValue.ToUpper;
        end
        else if vHeadA <> '' then
        begin
          self.FHeadParamList.Add(vHeadA + '=' + Trim(vValue));
        end;
        if S^ = ';' then
        begin
          vHeadB := '';
        end
        else
        begin
          vHeadB := '';
          vHeadA := '';
        end;
      end;
      P := S;
      Inc(P);
    end;
    Inc(S);
  end;
end;

procedure THTTPCtxt.SetInContent(qInContent: RawByteString);
var
  vBytes: TBytes;
begin
  // 判断是不是mulpart文件
  if IsMultipartForm(self.FRequestContentType) then
  begin
    // 不做处理到自已单元处理
    FRequestInContent := qInContent;
  end
  else if FRequestContentTypeCharset = 'UTF-8' then
  begin
    FRequestInContent := UTF8Decode(qInContent);
  end
  else if FRequestContentTypeCharset = 'UNICODE' then
  begin
    FRequestInContent := String(qInContent);
  end
  else if FRequestContentTypeCharset = 'GB2312' then
  begin
    vBytes := TEncoding.UTF8.GetBytes(qInContent);
    FRequestInContent := TEncoding.getencoding(936).GetString(vBytes);
  end
  else
    FRequestInContent := UTF8Decode(qInContent);
end;

procedure THTTPCtxt.AddCustomerHead(QHead: string; QConnect: string);
begin
  FResponCustHeaderList := FResponCustHeaderList + #13#10 + QHead + ':' + QConnect;
end;

destructor THTTPCtxt.Destroy;
begin
  inherited Destroy;
  FUrlParams.Clear;
  FHeadParamList.Clear;
  FUrlParams.Free;
  FHeadParamList.Free;
end;

end.

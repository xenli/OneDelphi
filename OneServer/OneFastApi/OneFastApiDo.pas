unit OneFastApiDo;

interface

uses
  system.JSON, system.Generics.Collections, system.Variants, system.TypInfo,
  FireDAC.Comp.Client, Data.DB, system.Classes, system.SysUtils, system.StrUtils,
  FireDAC.Comp.DataSet, system.NetEncoding, system.DateUtils,
  OneTokenManage, OneZTManage, OneFastApiManage, FireDAC.Stan.Param;

type
  TApiAll = class;

  TApiFieldTemp = class
  private
    FFieldName: string;
    FFormat: string;
    FJsonName: string;
    FField: TField;
  end;

  TApiStepResult = class
  private
    FPFilterField: string;
    FFilterField: string;
    FPStepResult: TApiStepResult;
    FApiDataID: string;
    FDataSet: TDataSet;
    FResultJsonObj: TJsonObject;
    FResultDataJsonArr: TJsonArray;
    FResultDataJsonArrIsFree: boolean;
    FResultAffected: integer;
    FBuildParams: TParams;
    FBuildFilterSQL: string;
    FApiData: TFastApiData;
    FChilds: TList<TApiStepResult>;
  public
    constructor Create;
    destructor Destroy; override;
  public
    property DataSet: TDataSet read FDataSet;
    property ApiData: TFastApiData read FApiData;
    property Childs: TList<TApiStepResult> read FChilds;
  end;

  TApiAll = class
  private
    UnionID: string;
    // 传进来的参数
    token: TOneTokenItem;
    postDataJson: TJsonObject;

    pageJson: TJsonObject;
    //
    ClientZT: TOneZTItem;
    ZTDict: TDictionary<string, TOneZTItem>;

    //
    isDoOK: boolean;
    resultCode: string;

  public
    paramJson: TJsonObject;
    //
    StepResultList: TList<TApiStepResult>;
    errMsg: string;
  public
    constructor Create;
    destructor Destroy; override;
    function GetZTItem(QZTCode: string): TOneZTItem;
    function IsErr(): boolean;
  end;

function DoFastApiResultApiAll(QToken: TOneTokenItem; QPostDataJson: TJsonObject; var QApiInfo: TFastApiInfo): TApiAll;
function DoFastApi(QToken: TOneTokenItem; QPostDataJson: TJsonObject): TJsonValue;
function DoCheckApiAuthor(QToken: TOneTokenItem; QApiInfo: TFastApiInfo; QApiAll: TApiAll): boolean;
//
function DoFastApiStep(QApiDatas: TList<TFastApiData>; QApiAll: TApiAll; QPStepResult: TApiStepResult): boolean;
function DoFastResultJson(QApiInfo: TFastApiInfo; QApiAll: TApiAll): TJsonValue;
// openData打开数据
function DoOpenData(QApiData: TFastApiData; QApiAll: TApiAll; QStepResult: TApiStepResult): boolean;
function DoDataStore(QApiData: TFastApiData; QApiAll: TApiAll; QStepResult: TApiStepResult): boolean;
function DoDml(QApiData: TFastApiData; QApiAll: TApiAll; QStepResult: TApiStepResult): boolean;

function BuildDataSQLAndParams(QApiData: TFastApiData; QApiAll: TApiAll; QStepResult: TApiStepResult): boolean;
function BuildFilterSQLAndParams(QApiData: TFastApiData; QApiFilter: TFastApiFilter; QApiAll: TApiAll; QStepResult: TApiStepResult): boolean;
function BuildFilterParamValue(QApiAll: TApiAll; QApiFilter: TFastApiFilter; QParam: TParam; QValue: string): boolean;

function BuildDataToJsonArray(QApiData: TFastApiData; Query: TDataSet; QApiAll: TApiAll): TJsonArray;
function BlobFieldToBase64(ABlobField: TBlobField): string;

implementation

uses OneGlobal, OneGUID, OneStreamString;

constructor TApiStepResult.Create;
begin
  FPStepResult := nil;
  FDataSet := nil;
  FApiData := nil;
  FResultJsonObj := nil;
  FResultDataJsonArr := nil;
  FResultDataJsonArrIsFree := false;
  FBuildParams := TParams.Create(nil);
  FChilds := TList<TApiStepResult>.Create;
end;

destructor TApiStepResult.Destroy;
var
  iChild: integer;
  iArr: integer;
begin
  FBuildParams.Clear;
  FBuildParams.Free;
  if FDataSet <> nil then
    FDataSet.Free;
  for iChild := 0 to FChilds.Count - 1 do
  begin
    FChilds[iChild].Free;
  end;
  FChilds.Clear;
  FChilds.Free;
  if FResultDataJsonArrIsFree and (FResultDataJsonArr <> nil) then
  begin
    for iArr := FResultDataJsonArr.Count - 1 downto 0 do
    begin
      FResultDataJsonArr.Remove(iArr);
    end;
    FResultDataJsonArr.Free;
  end;
  inherited Destroy
end;

constructor TApiAll.Create;
var
  ii: TGUID;
begin
  CreateGUID(ii);
  // 本次请求全局维一ID
  self.UnionID := Copy(AnsiReplaceStr(GUIDToString(ii), '-', ''), 2, 32);
  self.token := nil;
  self.postDataJson := nil;
  self.paramJson := nil;
  self.pageJson := nil;
  self.ZTDict := nil;
  self.ClientZT := nil;
  self.StepResultList := TList<TApiStepResult>.Create;
  //
  self.resultCode := 'FastApiFail';
  self.isDoOK := false;
  self.errMsg := '';
end;

destructor TApiAll.Destroy;
var
  i: integer;
begin
  for i := 0 to self.StepResultList.Count - 1 do
  begin
    self.StepResultList[i].Free;
  end;
  self.StepResultList.Clear;
  self.StepResultList.Free;

  token := nil;
  postDataJson := nil;
  paramJson := nil;
  pageJson := nil;
  self.ZTDict := nil;
  self.ClientZT := nil;
  inherited;
end;

function TApiAll.GetZTItem(QZTCode: string): TOneZTItem;
var
  lZTItem: TOneZTItem;
begin
  if self.ClientZT <> nil then
  begin
    Result := self.ClientZT;
    exit;
  end;
  lZTItem := nil;
  self.ZTDict.TryGetValue(QZTCode, lZTItem);
  Result := lZTItem;
end;

function TApiAll.IsErr(): boolean;
begin
  Result := not self.isDoOK;
end;

function DoFastApiResultApiAll(QToken: TOneTokenItem; QPostDataJson: TJsonObject; var QApiInfo: TFastApiInfo): TApiAll;
var
  lFastApiManage: TOneFastApiManage;
  lApiInfo: TFastApiInfo;
  lApiData: TFastApiData;
  iData: integer;
  isHaveTran: boolean;
  //
  lZTItemDict: TDictionary<string, TOneZTItem>;
  lZTCode: string;
  lZTManage: TOneZTManage;
  lZTItem: TOneZTItem;
  lZTItems: TList<TOneZTItem>;
  iZT: integer;
  //
  lClientZTCode: string;
  lApiCode: string;
  lApiDataJson, lApiParamJson, lApiPageJson: TJsonValue;
  lApiAll: TApiAll;
  iComitStep: integer;
  isStepOK: boolean;
begin
  Result := nil;
  isStepOK := false;
  lApiDataJson := nil;
  lApiParamJson := nil;
  lApiPageJson := nil;
  isHaveTran := false;
  lApiInfo := nil;
  lApiAll := TApiAll.Create;
  try
    if not QPostDataJson.TryGetValue<string>('apiCode', lApiCode) then
    begin
      lApiAll.errMsg := '提交的Json数据,接口代码不存在键值【apiCode】,且为字符串';
      exit;
    end;
    if not QPostDataJson.TryGetValue<TJsonValue>('apiData', lApiDataJson) then
    begin
      lApiAll.errMsg := '提交的Json数据,接口数据不存在键值【apiData】,且为JSON数据';
      exit;
    end;
    if not QPostDataJson.TryGetValue<TJsonValue>('apiParam', lApiParamJson) then
    begin
      lApiAll.errMsg := '提交的Json数据,接口数据不存在键值【apiParam】,且为JSON对象数据';
      exit;
    end;
    if QPostDataJson.TryGetValue<TJsonValue>('apiPage', lApiPageJson) then
    begin
      // 非必需的,如果有传必需传json对象
      if not(lApiPageJson is TJsonObject) then
      begin
        lApiAll.errMsg := '提交的Json数据,接口数据 【apiPage】不合法,应为JSON对象{"pageIndex":1,"pageSize":20}';
        exit;
      end;
    end;
    lClientZTCode := '';
    QPostDataJson.TryGetValue<string>('apiZTCode', lClientZTCode);

    if not((lApiDataJson is TJsonObject) or (lApiDataJson is TJsonArray)) then
    begin
      lApiAll.errMsg := '提交的Json数据,接口数据 【apiData】不合法,应为JSON对象{"a":"b"....}或JSON数组对象[{},{}]';
      exit;
    end;
    if not(lApiParamJson is TJsonObject) then
    begin
      lApiAll.errMsg := '提交的Json数据,接口数据 【apiParam】不合法,应为JSON对象{"a":"b"....}';
      exit;
    end;
    lFastApiManage := UnitFastApiManage();
    lApiInfo := lFastApiManage.GetApiInfo(lApiCode, lApiAll.errMsg);
    if lApiInfo = nil then
      exit;
    QApiInfo := lApiInfo;
    // 开始分析
    if not lApiInfo.CheckApiInfo() then
    begin
      lApiAll.errMsg := lApiInfo.errMsg;
      exit;
    end;
    // 权限把控
    if not DoCheckApiAuthor(QToken, lApiInfo, lApiAll) then
    begin
      exit;
    end;
    //
    lZTItemDict := TDictionary<string, TOneZTItem>.Create;
    try
      lApiAll.token := QToken;
      lApiAll.postDataJson := QPostDataJson;
      lApiAll.paramJson := TJsonObject(lApiParamJson);
      lApiAll.pageJson := TJsonObject(lApiPageJson);
      lApiAll.ZTDict := lZTItemDict;
      // 处理有事务的先执行
      for iData := 0 to lApiInfo.fastDatas.Count - 1 do
      begin
        lApiData := lApiInfo.fastDatas[iData];
        if not lZTItemDict.ContainsKey(lApiData.FDataZTCode) then
        begin
          lZTItemDict.Add(lApiData.FDataZTCode, nil);
        end;
        case lApiData.DataOpenMode() of
          openData, openDataStore, doStore:
            begin
            end;
          doDMLSQL, appendDatas:
            begin
              isHaveTran := true;
            end;
        else
          begin
            lApiAll.errMsg := '未归类的设计模式[' + lApiData.FDataOpenMode + ']';
            exit;
          end;
        end;
      end;
      if lClientZTCode <> '' then
      begin
        if lZTItemDict.Count > 1 then
        begin
          // 如果一个模板,多个数据集,取的是不同的账套,那么此时无法切换账套
          lClientZTCode := '前台账套【' + lClientZTCode + '】，后台配置账套';
          for lZTCode in lZTItemDict.keys do
          begin
            lClientZTCode := lClientZTCode + '[' + lZTCode + ']'
          end;
          lApiAll.errMsg := '一个模板配置账套为多个账套，无法切换账套';
          exit;
        end
        else
        begin
          // 如果一个模板配置是单账套,跟据前台切换账套
          lZTItemDict.Clear;
          lZTItemDict.Add(lClientZTCode, nil);
        end;
      end;

      iComitStep := 0;
      lZTItems := TList<TOneZTItem>.Create;
      try
        // 有事务的开启事务并行执行
        lZTManage := TOneGlobal.GetInstance().ZTManage;
        for lZTCode in lZTItemDict.keys do
        begin
          lZTItem := lZTManage.LockZTItem(lZTCode, lApiAll.errMsg);
          if lZTItem = nil then
          begin
            exit;
          end;
          lZTItemDict.Items[lZTCode] := lZTItem;
          lZTItems.Add(lZTItem);
          if (lClientZTCode <> '') and (lZTItemDict.Count = 1) then
            lApiAll.ClientZT := lZTItem;
        end;
        //
        if isHaveTran then
        begin
          for iZT := 0 to lZTItems.Count - 1 do
          begin
            lZTItem := lZTItems[iZT];
            lZTItem.ADTransaction.StartTransaction;
          end;
          iComitStep := 1;
        end;
        if not DoFastApiStep(lApiInfo.fastDatas, lApiAll, nil) then
        begin
          exit;
        end;
        if isHaveTran then
        begin
          for iZT := 0 to lZTItems.Count - 1 do
          begin
            lZTItem := lZTItems[iZT];
            lZTItem.ADTransaction.Commit;
          end;
          iComitStep := 0;
        end;
      finally
        if iComitStep = 1 then
        begin
          for iZT := 0 to lZTItems.Count - 1 do
          begin
            lZTItem := lZTItems[iZT];
            lZTItem.ADTransaction.Rollback;
          end;
        end;
        for iZT := 0 to lZTItems.Count - 1 do
        begin
          lZTItem := lZTItems[iZT];
          lZTItem.UnLockWork;
        end;
        lZTItems.Clear;
        lZTItems.Free;
      end;
      // 结果输出
      lApiAll.isDoOK := true;
      if lApiAll.resultCode = 'FastApiFail' then
      begin
        lApiAll.resultCode := 'FastApiSuccess'
      end;
    finally
      lZTItemDict.Clear;
      lZTItemDict.Free;
    end;
  finally
    // 错误返回
    Result := lApiAll;
  end;
end;

function DoFastApi(QToken: TOneTokenItem; QPostDataJson: TJsonObject): TJsonValue;
var
  lApiAll: TApiAll;
  lApiInfo: TFastApiInfo;
begin
  Result := nil;
  lApiInfo := nil;
  lApiAll := nil;
  try
    lApiAll := DoFastApiResultApiAll(QToken, QPostDataJson, lApiInfo);
  finally
    // 错误返回
    if lApiAll <> nil then
    begin
      Result := DoFastResultJson(lApiInfo, lApiAll);
      lApiAll.Free;
    end;
  end;
end;

function DoCheckApiAuthor(QToken: TOneTokenItem; QApiInfo: TFastApiInfo; QApiAll: TApiAll): boolean;
begin
  Result := false;
  if QApiInfo.fastApi.FApiAuthor = '' then
  begin
    // 不需要权限
    Result := true;
    exit;
  end;
  if QApiInfo.fastApi.FApiAuthor = '公开' then
  begin
    Result := true;
    exit;
  end
  else if QApiInfo.fastApi.FApiAuthor = 'Token验证' then
  begin
    if QToken = nil then
    begin
      QApiAll.errMsg := '请先登陆,此接口需要Token验证';
      exit;
    end;
    //
    if QApiInfo.fastApi.FApiRole <> '' then
    begin
      if QApiInfo.fastApi.FApiRole = '超级管理员' then
      begin
        if QToken.TokenRole < TOneTokenRole.superRole then
        begin
          QApiAll.errMsg := '此接口只有超级管理员可以访问';
          exit;
        end
        else
        begin
          Result := true;
        end;
      end
      else if QApiInfo.fastApi.FApiRole = '管理员' then
      begin
        if QToken.TokenRole < TOneTokenRole.sysAdminRole then
        begin
          QApiAll.errMsg := '此接口只有管理员以上级别可以访问';
          exit;
        end
        else
        begin
          Result := true;
        end;
      end
      else if QApiInfo.fastApi.FApiRole = '系统用户' then
      begin
        if QToken.TokenRole < TOneTokenRole.sysUserRole then
        begin
          QApiAll.errMsg := '此接口只有系统用户以上级别可以访问';
          exit;
        end
        else
        begin
          Result := true;
        end;
      end
      else
      begin
        QApiAll.errMsg := '未设计的角色权限[' + QApiInfo.fastApi.FApiRole + ']';
        exit;
      end;
    end;
  end
  else if QApiInfo.fastApi.FApiAuthor = 'AppID验证' then
  begin
    //
    QApiAll.errMsg := '未设计的验证方式[' + QApiInfo.fastApi.FApiAuthor + ']';
    exit;
  end
  else
  begin
    //
    QApiAll.errMsg := '未设计的验证方式[' + QApiInfo.fastApi.FApiAuthor + ']';
    exit;
  end;
end;

function DoFastResultJson(QApiInfo: TFastApiInfo; QApiAll: TApiAll): TJsonValue;
var
  lJsonObj, lJsonResultData, lStepJson, lParamJson: TJsonObject;
  lJsonArr: TJsonArray;
  iStep, iParam: integer;
  lParam: TParam;
  lStepResult: TApiStepResult;
  procedure DoChildStepResult(QSetpChildList: TList<TApiStepResult>);
  var
    iChild: integer;
    tempStepResult, tempPStepResult: TApiStepResult;
    tempJsonArr: TJsonArray;
    tempData, tempPData: TDataSet;
    tempIArr: integer;
    tempIAdd: integer;
  begin
    if (QSetpChildList = nil) or (QSetpChildList.Count = 0) then
      exit;
    for iChild := 0 to QSetpChildList.Count - 1 do
    begin
      tempStepResult := QSetpChildList[iChild];
      if tempStepResult.FDataSet <> nil then
      begin
        if (tempStepResult.FPFilterField <> '') and (tempStepResult.FFilterField <> '') then
        begin
          tempData := tempStepResult.FDataSet;
          tempPStepResult := tempStepResult.FPStepResult;
          tempPData := tempPStepResult.FDataSet;
          tempPData.First;
          tempIArr := 0;
          while not tempPData.Eof do
          begin
            tempData.Filtered := false;
            tempData.Filter := tempStepResult.FFilterField + '=' + QuoTedStr(tempPData.FieldByName(tempStepResult.FPFilterField).AsString);
            tempData.Filtered := true;
            tempJsonArr := BuildDataToJsonArray(tempStepResult.FApiData, tempData, QApiAll);
            if tempStepResult.FResultDataJsonArr = nil then
            begin
              tempStepResult.FResultDataJsonArr := TJsonArray.Create;
              tempStepResult.FResultDataJsonArrIsFree := true; // 需要释放自已
            end
            else
            begin
              for tempIAdd := 0 to tempJsonArr.Count - 1 do
              begin
                tempStepResult.FResultDataJsonArr.AddElement(tempJsonArr.Items[tempIAdd]);
              end;
            end;
            TJsonObject(tempPStepResult.FResultDataJsonArr.Items[tempIArr]).AddPair(tempStepResult.FApiData.FDataJsonName, tempJsonArr);
            tempIArr := tempIArr + 1;
            tempPData.Next;
          end;
        end
        else
        begin
          tempPStepResult := tempStepResult.FPStepResult;
          if tempPStepResult.FResultJsonObj <> nil then
          begin
            tempJsonArr := BuildDataToJsonArray(tempStepResult.FApiData, tempStepResult.FDataSet, QApiAll);
            tempPStepResult.FResultJsonObj.AddPair(tempStepResult.FApiData.FDataJsonName, tempJsonArr);
          end;
        end;
      end;
      if lStepResult.FApiData.DataOpenMode = doDMLSQL then
      begin
        lStepJson.AddPair('AffectedCount', TJsonNumber.Create(lStepResult.FResultAffected));
      end;
      DoChildStepResult(tempStepResult.FChilds);
    end;
  end;

begin
  lJsonObj := TJsonObject.Create();
  Result := lJsonObj;
  lJsonObj.AddPair('ResultSuccess', TJSONBool.Create(QApiAll.isDoOK));
  lJsonObj.AddPair('ResultCode', QApiAll.resultCode);
  lJsonObj.AddPair('ResultMsg', QApiAll.errMsg);
  if not QApiAll.isDoOK then
  begin
    exit;
  end;
  try
    lJsonResultData := TJsonObject.Create;
    lJsonObj.AddPair('ResultData', lJsonResultData);
    for iStep := 0 to QApiAll.StepResultList.Count - 1 do
    begin
      lStepJson := TJsonObject.Create();
      lStepResult := QApiAll.StepResultList[iStep];
      lStepResult.FResultJsonObj := lStepJson;
      lJsonResultData.AddPair(lStepResult.FApiData.FDataJsonName, lStepJson);
      if lStepResult.FDataSet <> nil then
      begin
        lJsonArr := BuildDataToJsonArray(lStepResult.FApiData, lStepResult.FDataSet, QApiAll);
        if lStepResult.FApiData.FDataJsonType = 'JsonObject' then
        begin
          if lJsonArr.Count = 0 then
          begin
            lStepJson.AddPair('Data', TJsonNull.Create);
          end
          else
          begin
            lStepJson.AddPair('Data', TJsonValue(lJsonArr.Items[0].clone));
          end;
          lJsonArr.Free;
        end
        else
        begin
          lStepJson.AddPair('Data', lJsonArr);
          lStepResult.FResultDataJsonArr := lJsonArr;
        end;
        // 参数增加
        if lStepResult.FApiData.DataOpenMode in [openDataStore, doStore] then
        begin
          lParamJson := TJsonObject.Create;
          lStepJson.AddPair('Params', lParamJson);
          for iParam := 0 to lStepResult.FBuildParams.Count - 1 do
          begin
            lParam := lStepResult.FBuildParams[iParam];
            if lParam.ParamType in [ptOutput, ptInputOutput] then
            begin
              // 输出参数
              lParamJson.AddPair(lParam.Name, lParam.AsString);
            end;
          end;
        end;

        lStepJson.AddPair('DataCount', TJsonNumber.Create(lStepResult.FDataSet.RecordCount));
      end
      else
      begin
        if lStepResult.FApiData.DataOpenMode in [openDataStore, doStore] then
        begin
          // 添加输出参数,如果没有返回数据集
          lParamJson := TJsonObject.Create;
          lStepJson.AddPair('Params', lParamJson);
          for iParam := 0 to lStepResult.FBuildParams.Count - 1 do
          begin
            lParam := lStepResult.FBuildParams[iParam];
            if lParam.ParamType in [ptOutput, ptInputOutput] then
            begin
              // 输出参数
              lParamJson.AddPair(lParam.Name, lParam.AsString);
            end;
          end;
        end;
      end;
      if lStepResult.FApiData.DataOpenMode = doDMLSQL then
      begin
        lStepJson.AddPair('AffectedCount', TJsonNumber.Create(lStepResult.FResultAffected));
      end;
      DoChildStepResult(lStepResult.FChilds);
    end;
    //
  except
    on e: exception do
    begin
      lJsonObj.Get('ResultSuccess').JsonValue := TJSONBool.Create(false);
      lJsonObj.Get('ResultMsg').JsonValue := TJsonString.Create(e.Message);
    end;
  end;
end;

function DoFastApiStep(QApiDatas: TList<TFastApiData>; QApiAll: TApiAll; QPStepResult: TApiStepResult): boolean;
var
  iData: integer;
  lApiData: TFastApiData;
  lDataSet: TDataSet;
  lStepResult: TApiStepResult;
begin
  Result := false;
  for iData := 0 to QApiDatas.Count - 1 do
  begin
    lApiData := QApiDatas[iData];
    lStepResult := TApiStepResult.Create;
    lStepResult.FApiDataID := lApiData.FDataID;
    lStepResult.FApiData := lApiData;
    lStepResult.FPStepResult := QPStepResult;
    if QPStepResult <> nil then
      QPStepResult.FChilds.Add(lStepResult)
    else
      QApiAll.StepResultList.Add(lStepResult);

    case lApiData.DataOpenMode() of
      openData:
        begin
          // 跟据SQL打开数据
          if not DoOpenData(lApiData, QApiAll, lStepResult) then
          begin
            exit;
          end;
        end;
      openDataStore:
        begin
          // 执行存储过程,有返回数据集
          if not DoDataStore(lApiData, QApiAll, lStepResult) then
            exit;
        end;
      doStore:
        begin
          // 执行存储过程,无返回数据集
          if not DoDataStore(lApiData, QApiAll, lStepResult) then
            exit;
        end;
      doDMLSQL:
        begin
          if not DoDml(lApiData, QApiAll, lStepResult) then
            exit;
        end;
      appendDatas:
        begin
          // 批量增加数据
        end;
    end;
    if (lApiData.ChildDatas <> nil) and (lApiData.ChildDatas.Count > 0) then
    begin
      // 查询儿子关联数据
      if not DoFastApiStep(lApiData.ChildDatas, QApiAll, lStepResult) then
      begin
        exit;
      end;
    end;
  end;
  Result := true;
end;

function DoOpenData(QApiData: TFastApiData; QApiAll: TApiAll; QStepResult: TApiStepResult): boolean;
var
  iData, iParam: integer;
  lApiData: TFastApiData;
  lPageJson: TJsonObject;
  iPageIndex, iPageSize, tempI: integer;
  // {"pageIndex":1,"pageSize":20}
  lStringList: TStringList;
  lZTItem: TOneZTItem;
  lQuery: TFDQuery;
  lFDParam: TFDParam;
  lParam: TParam;
begin
  Result := false;
  iPageIndex := -1;
  iPageSize := -1;

  lPageJson := QApiAll.pageJson;
  if lPageJson <> nil then
  begin
    if lPageJson.TryGetValue<integer>('pageIndex', tempI) then
    begin
      iPageIndex := tempI;
    end;
    if lPageJson.TryGetValue<integer>('pageSize', tempI) then
    begin
      iPageSize := tempI;
    end;
  end;
  if iPageSize <= 0 then
  begin
    iPageSize := QApiData.FDataPageSize;
  end;
  if iPageSize <= 0 then
    iPageSize := -1;
  // 解析参数 以及组装出SQL
  if not BuildDataSQLAndParams(QApiData, QApiAll, QStepResult) then
    exit;
  lQuery := nil;
  try
    lStringList := TStringList.Create;
    TRY
      lStringList.Text := QApiData.FDataSQL;
      if QApiData.FilterLine >= 0 then
      begin
        lStringList[QApiData.FilterLine] := QStepResult.FBuildFilterSQL;
      end;
      // 获取账套
      lZTItem := QApiAll.GetZTItem(QApiData.FDataZTCode);
      // 打开数据
      lQuery := lZTItem.CreateNewQuery(true);
      lQuery.SQL.Text := lStringList.Text;
      // 分页处理
      if (iPageSize > 0) and (iPageIndex > 0) then
      begin
        lQuery.FetchOptions.RecsSkip := (iPageIndex - 1) * iPageSize;
        lQuery.FetchOptions.RecsMax := iPageSize;
      end
      else
      begin
        lQuery.FetchOptions.RecsSkip := -1;
        if iPageSize > 0 then
          lQuery.FetchOptions.RecsMax := iPageSize
        else
          lQuery.FetchOptions.RecsMax := -1;
      end;
      // 参数处理
      for iParam := 0 to lQuery.params.Count - 1 do
      begin
        lFDParam := lQuery.params[iParam];
        lParam := QStepResult.FBuildParams.FindParam(lFDParam.Name);
        if lParam = nil then
        begin
          QApiAll.errMsg := '参数[' + lFDParam.Name + ']找不到,请开发人员检查组装的参数代码';
          exit;
        end;
        lFDParam.DataType := lParam.DataType;
        lFDParam.ParamType := lParam.ParamType;
        lFDParam.Value := lParam.Value;
      end;
      //
      lQuery.Open;
      if not lQuery.Active then
      begin
        QApiAll.errMsg := '打开数据失败';
        exit;
      end;
      if QApiData.FDataJsonType = 'JsonObject' then
      begin
        if lQuery.RecordCount > 1 then
        begin
          QApiAll.errMsg := '数据集[' + QApiData.FDataName + ']设定是返回Json对象,实际结果数据量大于1';
          exit;
        end;
      end;
      QStepResult.FDataSet := lQuery;
    FINALLY
      lStringList.Free;
    END;
    Result := true;
  finally
    if not Result then
    begin
      if lQuery <> nil then
      begin
        lQuery.Free;
      end;
      QStepResult.FDataSet := nil;
    end;
  end;
end;

function DoDataStore(QApiData: TFastApiData; QApiAll: TApiAll; QStepResult: TApiStepResult): boolean;
var
  iData, iParam: integer;
  lApiData: TFastApiData;
  tempI: integer;
  // {"pageIndex":1,"pageSize":20}
  lZTItem: TOneZTItem;
  lFDStored: TFDStoredProc;
  lFDParam: TFDParam;
  lParam: TParam;
  //
  lPTResult: integer;
begin
  Result := false;
  // 解析参数 以及组装出SQL
  if not BuildDataSQLAndParams(QApiData, QApiAll, QStepResult) then
    exit;
  // 获取账套
  lZTItem := QApiAll.GetZTItem(QApiData.FDataZTCode);
  // 打开数据
  lFDStored := lZTItem.ADStoredProc;
  lFDStored.StoredProcName := QApiData.FDataStoreName;
  lFDStored.Prepare;
  if not lFDStored.Prepared then
  begin
    QApiAll.errMsg := '校验存储过程失败,请检查是否有此存储过程[' + QApiData.FDataStoreName + ']';
    exit;
  end;
  // 参数处理
  for iParam := lFDStored.params.Count - 1 downto 0 do
  begin
    lFDParam := lFDStored.params[iParam];
    if lFDParam.ParamType = TParamType.ptResult then
    begin
      lPTResult := lPTResult + 1;
      continue;
    end;
    if lFDParam.Name.StartsWith('@') then
    begin
      // SQL数据库返回参数代@去掉
      lFDParam.Name := lFDParam.Name.Substring(1);
    end;
  end;

  if QStepResult.FBuildParams.Count <> lFDStored.params.Count - lPTResult then
  begin
    QApiAll.errMsg := '参数个数错误->服务端参数个数[' + lFDStored.params.Count.ToString + '],如下[';
    for iParam := lFDStored.params.Count - 1 downto 0 do
    begin
      QApiAll.errMsg := QApiAll.errMsg + lFDStored.params[iParam].Name;
    end;
    QApiAll.errMsg := QApiAll.errMsg + ';客户端参数个数[' + QStepResult.FBuildParams.Count.ToString + '],如下[';
    for iParam := QStepResult.FBuildParams.Count - 1 downto 0 do
    begin
      QApiAll.errMsg := QApiAll.errMsg + QStepResult.FBuildParams[iParam].Name;
    end;
    QApiAll.errMsg := QApiAll.errMsg + ']';
    exit;
  end;
  //
  // 参数赋值
  for iParam := 0 to lFDStored.params.Count - 1 do
  begin
    lFDParam := lFDStored.params[iParam];
    if lFDParam.ParamType = TParamType.ptResult then
    begin
      continue;
    end;
    // 处理参数
    lParam := QStepResult.FBuildParams.FindParam(lFDParam.Name);
    if lParam = nil then
    begin
      QApiAll.errMsg := '存储过程参数[' + lFDParam.Name + ']找不到相关的参数配置';
      exit;
    end;
    // lFDParam.DataType := lParam.DataType;
    lParam.ParamType := lFDParam.ParamType;
    if not lParam.IsNull then
      lFDParam.Value := lParam.Value;
  end;

  try
    if QApiData.DataOpenMode = emDataOpenMode.openDataStore then
    begin
      if not lFDStored.OpenOrExecute then
      begin
        QApiAll.errMsg := lZTItem.FDException.FErrmsg;
        exit;
      end;
    end
    else
    begin
      lFDStored.ExecProc;
    end;

    if lFDStored.Active then
    begin
      QStepResult.FDataSet := TFDMemtable.Create(nil);
      TFDMemtable(QStepResult.FDataSet).Data := lFDStored.Data;
      // 关闭下，获取参数返回的值
      lFDStored.close;
    end;
    //
    for iParam := 0 to lFDStored.params.Count - 1 do
    begin
      lFDParam := lFDStored.params[iParam];
      if lFDParam.ParamType in [TParamType.ptInputOutput, TParamType.ptOutput] then
      begin
        lParam := QStepResult.FBuildParams.FindParam(lFDParam.Name);
        lParam.Value := lFDParam.Value;
      end;
    end;
  except
    on e: exception do
    begin
      QApiAll.errMsg := '执行存储过程异常:' + e.Message;
      exit;
    end;
  end;
  Result := true;
end;

function DoDml(QApiData: TFastApiData; QApiAll: TApiAll; QStepResult: TApiStepResult): boolean;
var
  iData, iParam: integer;
  lApiData: TFastApiData;
  tempI: integer;
  // {"pageIndex":1,"pageSize":20}
  lStringList: TStringList;
  lZTItem: TOneZTItem;
  LZTQuery: TFDQuery;
  lFDParam: TFDParam;
  lParam: TParam;
  iRowsAffected: integer;
begin
  Result := false;
  // 解析参数 以及组装出SQL
  if not BuildDataSQLAndParams(QApiData, QApiAll, QStepResult) then
    exit;

  lStringList := TStringList.Create;
  TRY
    lStringList.Text := QApiData.FDataSQL;
    if QApiData.FilterLine >= 0 then
    begin
      lStringList[QApiData.FilterLine] := QStepResult.FBuildFilterSQL;
    end;
    // 获取账套
    lZTItem := QApiAll.GetZTItem(QApiData.FDataZTCode);
    // 打开数据
    LZTQuery := lZTItem.ADQuery;
    LZTQuery.SQL.Text := lStringList.Text;
    // 参数处理
    for iParam := 0 to LZTQuery.params.Count - 1 do
    begin
      lFDParam := LZTQuery.params[iParam];
      lParam := QStepResult.FBuildParams.FindParam(lFDParam.Name);
      if lParam = nil then
      begin
        QApiAll.errMsg := '参数[' + lFDParam.Name + ']找不到,请开发人员检查组装的参数代码';
        exit;
      end;
      lFDParam.DataType := lParam.DataType;
      lFDParam.ParamType := lParam.ParamType;
      lFDParam.Value := lParam.Value;
    end;
    //
    try
      LZTQuery.ExecSQL;
      iRowsAffected := LZTQuery.RowsAffected;
      QStepResult.FResultAffected := iRowsAffected;
      if QApiData.FMinAffected > 0 then
      begin
        if iRowsAffected < QApiData.FMinAffected then
        begin
          QApiAll.errMsg := '执行失败:数据集[' + QApiData.FDataName + ']当前影响行数[' + iRowsAffected.ToString + ']小于设置最小影响行数[' + QApiData.FMinAffected.ToString + ']';
          exit;
        end;
      end;
      if QApiData.FMaxAffected > 0 then
      begin
        if iRowsAffected > QApiData.FMaxAffected then
        begin
          QApiAll.errMsg := '执行失败:数据集[' + QApiData.FDataName + ']当前影响行数[' + iRowsAffected.ToString + ']大于设置最大影响行数[' + QApiData.FMaxAffected.ToString + ']';
          exit;
        end;
      end;
    except
      on e: exception do
      begin
        QApiAll.errMsg := '执行DML语句异常,原因:' + e.Message;
        exit;
      end;
    end;
    Result := true;
  FINALLY
    lStringList.Free;
  END;
end;

function BuildDataSQLAndParams(QApiData: TFastApiData; QApiAll: TApiAll; QStepResult: TApiStepResult): boolean;
var
  iFilter: integer;
  lApiFilter: TFastApiFilter;
  lParams: TParams;
begin
  Result := false;
  for iFilter := 0 to QApiData.ChildFilters.Count - 1 do
  begin
    lApiFilter := QApiData.ChildFilters[iFilter];
    if not BuildFilterSQLAndParams(QApiData, lApiFilter, QApiAll, QStepResult) then
      exit;
  end;
  Result := true;
end;

function BuildFilterSQLAndParams(QApiData: TFastApiData; QApiFilter: TFastApiFilter; QApiAll: TApiAll; QStepResult: TApiStepResult): boolean;
var
  lParam: TParam;
  tempValue: string;
  tempSQL: string;
  lJSONPair: TJSONPair;
  isGetDefault: boolean;
  //
  lFieldNames: TArray<string>;
  iField: integer;
  lFieldName, lFieldParamName: string;
  //
  lParamNames: string;
  iValue: integer;
  lArrValues: TArray<string>;
  //
  lData: TDataSet;
begin
  Result := false;
  tempValue := '';
  isGetDefault := true;
  tempSQL := '';
  // fromJsonData,fromJsonParam,fromConst,
  if QApiFilter.FJsonIsEmptyGetDefault then
  begin
    // 优先取Json数据
    // 取Post上来的Json参数
    if QApiAll.paramJson = nil then
    begin
      QApiAll.errMsg := 'QParamJson参数为nil';
      exit;
    end;
    lJSONPair := QApiAll.paramJson.Get(QApiFilter.FFilterJsonName);
    if lJSONPair <> nil then
    begin
      tempValue := lJSONPair.Value;
    end;
    if tempValue <> '' then
      isGetDefault := false;
  end;

  if isGetDefault then
  begin
    if QApiFilter.FFilterFieldMode = '父级关联' then
    begin
      tempValue := '';
      if QStepResult.FPStepResult = nil then
      begin
        QApiAll.errMsg := '数据集配置[' + QApiData.FDataName + ']无父级数据集,不可配置参数来源父数据集';
        exit;
      end;
      if (QStepResult.FPStepResult.FDataSet = nil) or (QStepResult.FPStepResult.FDataSet.RecordCount = 0) then
      begin
        QApiAll.errMsg := '数据集配置[' + QApiData.FDataName + ']父级数据集为nil或无数据,不可配置参数来源父数据集';
        exit;
      end;
      QApiFilter.FFilterExpression := '包含';
      QStepResult.FPFilterField := QApiFilter.FPFilterField;
      QStepResult.FFilterField := QApiFilter.FFilterField;
      lData := QStepResult.FPStepResult.FDataSet;
      lData.First;
      while not lData.Eof do
      begin
        tempValue := tempValue + lData.FieldByName(QApiFilter.FPFilterField).AsString + '|';
        lData.Next;
      end;
    end
    else if QApiFilter.FFilterDefaultType = 'fromConst' then
    begin
      // 固定常量
      tempValue := QApiFilter.FFilterDefaultValue;
    end
    else if QApiFilter.FFilterDefaultType = 'fromJsonParam' then
    begin
      // 取Post上来的Json参数
      if QApiAll.paramJson = nil then
      begin
        QApiAll.errMsg := 'QParamJson参数为nil';
        exit;
      end;
      lJSONPair := QApiAll.paramJson.Get(QApiFilter.FFilterJsonName);
      if QApiFilter.FFilterbMust then
      begin
        if lJSONPair = nil then
        begin
          QApiAll.errMsg := '参数[' + QApiFilter.FFilterJsonName + ']是必需的参数';
          exit;
        end;
      end;
      if lJSONPair <> nil then
        tempValue := lJSONPair.JsonValue.Value;
    end
    else if QApiFilter.FFilterDefaultType = 'fromSysToken' then
    begin
      tempValue := QApiFilter.FFilterDefaultValue;
      if tempValue = 'TokenID' then
      begin
        tempValue := QApiAll.token.TokenID;
      end
      else if tempValue = 'TokenUserID' then
      begin
        tempValue := QApiAll.token.SysUserID;
      end
      else if tempValue = 'TokenUserCode' then
      begin
        tempValue := QApiAll.token.SysUserCode;
      end
      else if tempValue = 'TokenUserName' then
      begin
        tempValue := QApiAll.token.SysUserName;
      end
      else if tempValue = 'TokenLoginCode' then
      begin
        tempValue := QApiAll.token.LoginUserCode;
      end
      else
      begin
        QApiAll.errMsg := '参数配置[' + QApiFilter.FFilterName + '],类型[' + QApiFilter.FFilterDefaultType + ']值[' + tempValue + ']未实现';
        exit;
      end;
    end
    else if QApiFilter.FFilterDefaultType = 'fromPData' then
    begin
      // 获取父级数据
      tempValue := '';
      if QStepResult.FPStepResult = nil then
      begin
        QApiAll.errMsg := '数据集配置[' + QApiData.FDataName + ']无父级数据集,不可配置参数来源父数据集';
        exit;
      end;
      if (QStepResult.FPStepResult.FDataSet = nil) or (QStepResult.FPStepResult.FDataSet.RecordCount = 0) then
      begin
        QApiAll.errMsg := '数据集配置[' + QApiData.FDataName + ']父级数据集为nil或无数据,不可配置参数来源父数据集';
        exit;
      end;
      lData := QStepResult.FPStepResult.FDataSet;
      tempValue := lData.FieldByName(QApiFilter.FFilterDefaultValue).AsString;
    end
    else if QApiFilter.FFilterDefaultType = 'fromSys' then
    begin
      if tempValue = 'UnionID' then
      begin
        tempValue := QApiAll.UnionID;
      end
      else if tempValue = 'SysGUID' then
      begin
        tempValue := OneGUID.GetGUID32;
      end
      else if tempValue = 'SysDateTime' then
      begin
        tempValue := FormatDateTime('yyyy-mm-dd hh:mm:ss', now);
      end
      else if tempValue = 'SysDate' then
      begin
        tempValue := FormatDateTime('yyyy-mm-dd', now);
      end
      else if tempValue = 'SysTime' then
      begin
        tempValue := FormatDateTime('hh:mm', now);
      end
      else if tempValue = 'SysYear' then
      begin
        tempValue := FormatDateTime('yyyy', now);
      end
      else
      begin
        QApiAll.errMsg := '参数配置[' + QApiFilter.FFilterName + '],类型[' + QApiFilter.FFilterDefaultType + ']值[' + tempValue + ']未实现';
        exit;
      end;
    end
    else
    begin
      QApiAll.errMsg := '参数配置[' + QApiFilter.FFilterName + '],类型[' + QApiFilter.FFilterDefaultType + ']未设计';
      exit;
    end;
  end;

  if QApiFilter.FFilterbValue then
  begin
    if tempValue.Trim = '' then
    begin
      QApiAll.errMsg := '参数[' + QApiFilter.FFilterJsonName + ']参数必需有值';
      exit;
    end;
  end;
  // 添加参数
  if tempValue = '' then
  begin
    if QApiData.DataOpenMode in [openDataStore, doStore] then
    begin
      if QApiFilter.FbOutParam then
      begin
        lParam := QStepResult.FBuildParams.AddParameter;
        lParam.Name := QApiFilter.FFilterField;
        lParam.ParamType := TParamType.ptInputOutput;
      end;
    end;
  end
  else
  begin
    if QApiFilter.FFilterFieldMode = '值选择' then
    begin
      Result := QApiFilter.GetValueSQL(tempValue, tempSQL);
      if not Result then
      begin
        QStepResult.FBuildFilterSQL := QStepResult.FBuildFilterSQL + ' ' + tempSQL + ' ';
      end
      else
      begin
        QApiAll.errMsg := '参数[' + QApiFilter.FFilterJsonName + ']值选择找不到对应值的SQL语句';
      end;
      // 值选对SQL 这边就退出去了
      exit;
    end;

    lFieldNames := QApiFilter.FieldNames;
    // 非SQL固定字段需要组装SQL
    // 多字段过滤
    for iField := low(lFieldNames) to High(lFieldNames) do
    begin
      lFieldName := lFieldNames[iField];
      if QApiFilter.IsFixSQLParam or (QApiData.DataOpenMode in [doStore, openDataStore]) then
      begin
        // 保持参数名称
        lFieldParamName := lFieldName;
      end
      else
      begin
        lFieldParamName := 'ft' + QApiFilter.FFilterName + lFieldName;
      end;
      // 组装SQL
      if tempSQL <> '' then
        tempSQL := tempSQL + ' or ';
      if QApiFilter.FFilterExpression = '=' then
      begin
        tempSQL := tempSQL + ' (' + lFieldName + ' ' + QApiFilter.FFilterExpression + ' :' + lFieldParamName + ' ) ';
        lParam := QStepResult.FBuildParams.AddParameter;
        lParam.Name := lFieldParamName;
        if not BuildFilterParamValue(QApiAll, QApiFilter, lParam, tempValue) then
          exit;
      end
      else if QApiFilter.FFilterExpression = '相似' then
      begin
        tempSQL := tempSQL + ' (' + lFieldName + ' ' + 'like' + ' :' + lFieldParamName + ' ) ';
        lParam := QStepResult.FBuildParams.AddParameter;
        lParam.Name := lFieldParamName;
        if not BuildFilterParamValue(QApiAll, QApiFilter, lParam, '%' + tempValue + '%') then
          exit;
      end
      else if QApiFilter.FFilterExpression = '左相似' then
      begin
        tempSQL := tempSQL + ' (' + lFieldName + ' ' + 'like' + ' :' + lFieldParamName + ' ) ';
        lParam := QStepResult.FBuildParams.AddParameter;
        lParam.Name := lFieldParamName;
        if not BuildFilterParamValue(QApiAll, QApiFilter, lParam, '%' + tempValue) then
          exit;
      end
      else if QApiFilter.FFilterExpression = '右相似' then
      begin
        tempSQL := tempSQL + ' (' + lFieldName + ' ' + 'like' + ' :' + lFieldParamName + ' ) ';
        lParam := QStepResult.FBuildParams.AddParameter;
        lParam.Name := lFieldParamName;
        if not BuildFilterParamValue(QApiAll, QApiFilter, lParam, tempValue + '%') then
          exit;
      end
      else if QApiFilter.FFilterExpression = '包含' then
      begin
        lArrValues := tempValue.Split(['|']);
        lParamNames := '';
        for iValue := Low(lArrValues) to High(lArrValues) do
        begin
          if lParamNames <> '' then
            lParamNames := lParamNames + ',';
          lParamNames := lParamNames + ':' + lFieldParamName + iValue.ToString;
        end;
        tempSQL := tempSQL + ' (' + lFieldName + ' ' + 'in' + ' ( ' + lParamNames + ') ) ';
        for iValue := Low(lArrValues) to High(lArrValues) do
        begin
          tempValue := lArrValues[iValue];
          lParam := QStepResult.FBuildParams.AddParameter;
          lParam.Name := lFieldParamName + iValue.ToString;
          if not BuildFilterParamValue(QApiAll, QApiFilter, lParam, tempValue) then
            exit;
        end;
      end
      else if QApiFilter.FFilterExpression = '不包含' then
      begin
        lArrValues := tempValue.Split(['|']);
        lParamNames := '';
        for iValue := Low(lArrValues) to High(lArrValues) do
        begin
          if lParamNames <> '' then
            lParamNames := lParamNames + ',';
          lParamNames := lParamNames + ':' + lFieldParamName + iValue.ToString;
        end;
        tempSQL := tempSQL + ' (' + lFieldName + ' ' + 'not in' + ' ( ' + lParamNames + ') ) ';
        for iValue := Low(lArrValues) to High(lArrValues) do
        begin
          tempValue := lArrValues[iValue];
          lParam := QStepResult.FBuildParams.AddParameter;
          lParam.Name := lFieldParamName + iValue.ToString;
          if not BuildFilterParamValue(QApiAll, QApiFilter, lParam, tempValue) then
            exit;
        end;
      end
      else
      begin
        tempSQL := tempSQL + ' (' + lFieldName + ' ' + QApiFilter.FFilterExpression + ' :' + lFieldParamName + ' ) ';
        lParam := QStepResult.FBuildParams.AddParameter;
        lParam.Name := lFieldParamName;
        if not BuildFilterParamValue(QApiAll, QApiFilter, lParam, tempValue) then
          exit;
      end;
    end;
    if (tempSQL <> '') and (not QApiFilter.IsFixSQLParam) then
    begin
      // 动态参数才组装SQL
      tempSQL := ' and ( ' + tempSQL + ' ) ';
      QStepResult.FBuildFilterSQL := QStepResult.FBuildFilterSQL + tempSQL;
    end;
  end;
  Result := true;
end;

function BuildFilterParamValue(QApiAll: TApiAll; QApiFilter: TFastApiFilter; QParam: TParam; QValue: string): boolean;
var
  tempI64: int64;
  tempFloat: double;
  tempDataTime: TDateTime;
begin
  Result := false;
  if QApiFilter.FFilterDataType = '字符串' then
  begin
    QParam.AsString := QValue;
  end
  else if QApiFilter.FFilterDataType = '整型' then
  begin
    if TryStrToInt64(QValue, tempI64) then
    begin
      QParam.AsLargeInt := tempI64;
    end
    else
    begin
      QApiAll.errMsg := '条件[' + QApiFilter.FFilterName + ']转化成整型出错,当前值[' + QValue + ']';
      exit;
    end;
  end
  else if QApiFilter.FFilterDataType = '数字' then
  begin
    if TryStrToFloat(QValue, tempFloat) then
    begin
      QParam.AsFloat := tempFloat;
    end
    else
    begin
      QApiAll.errMsg := '条件[' + QApiFilter.FFilterName + ']转化成数字出错,当前值[' + QValue + ']';
      exit;
    end;
  end
  else if QApiFilter.FFilterDataType = '布尔' then
  begin
    QParam.AsBoolean := false;
    if (QValue.ToLower = 'true') or (QValue = '1') or (QValue.ToLower = 't') then
    begin
      QParam.AsBoolean := true;
    end;
  end
  else if QApiFilter.FFilterDataType = '时间' then
  begin
    if TryStrToDateTime(QValue, tempDataTime) then
    begin
      if QApiFilter.FFilterFormat <> '' then
      begin
        if QApiFilter.FFilterFormat = 'yyyy-mm-dd' then
        begin
          QParam.AsDate := tempDataTime;
        end
        else if QApiFilter.FFilterFormat = 'hh:nn:ss' then
        begin
          QParam.AsTime := tempDataTime;
        end
        else
        begin
          QParam.AsDateTime := tempDataTime;
        end;
      end
      else
      begin
        QParam.AsDateTime := tempDataTime;
      end;
    end
    else
    begin
      QApiAll.errMsg := '条件[' + QApiFilter.FFilterName + ']转化成时间出错,当前值[' + QValue + ']';
      exit;
    end;
  end
  else
  begin
    QParam.AsString := QValue;
  end;
  Result := true;
end;

function BuildDataToJsonArray(QApiData: TFastApiData; Query: TDataSet; QApiAll: TApiAll): TJsonArray;
var
  lData: TFDMemtable;
  lJsonArray: TJsonArray;
  lJsonObj: TJsonObject;
  lApiField: TFastApiField;
  lField: TField;
  iField: integer;
  lFieldTemp: TApiFieldTemp;
  lFieldList: TList<TApiFieldTemp>;
begin
  Result := nil;
  lFieldList := TList<TApiFieldTemp>.Create;
  try
    if (QApiData.ChildFields = nil) or (QApiData.ChildFields.Count = 0) then
    begin
      for iField := 0 to Query.FieldCount - 1 do
      begin
        lFieldTemp := TApiFieldTemp.Create;
        lFieldList.Add(lFieldTemp);
        lFieldTemp.FField := Query.Fields[iField];
        lFieldTemp.FFieldName := lFieldTemp.FField.Name;
        lFieldTemp.FFormat := '';
        lFieldTemp.FJsonName := lFieldTemp.FField.Name;
      end;
    end
    else
    begin
      for iField := 0 to QApiData.ChildFields.Count - 1 do
      begin
        lApiField := QApiData.ChildFields[iField];
        lField := Query.FindField(lApiField.FFieldName);
        if lField = nil then
        begin
          QApiAll.errMsg := '数据集[' + QApiData.FDataName + ']字段[' + lApiField.FFieldName + ']打开的数据集找不到相关字段';
          exit;
        end;
        lFieldTemp := TApiFieldTemp.Create;
        lFieldList.Add(lFieldTemp);
        lFieldTemp.FField := lField;
        lFieldTemp.FFieldName := lFieldTemp.FField.Name;
        lFieldTemp.FJsonName := lApiField.FFieldJsonName;
        lFieldTemp.FFormat := lApiField.FFieldFormat;
      end;
    end;
    // 数据集转Json
    lJsonArray := TJsonArray.Create;
    try
      Query.First;
      while not Query.Eof do
      begin
        lJsonObj := TJsonObject.Create;
        lJsonArray.Add(lJsonObj);
        for iField := 0 to lFieldList.Count - 1 do
        begin
          lFieldTemp := lFieldList[iField];
          lField := lFieldTemp.FField;
          if lField.IsNull then
          begin
            lJsonObj.AddPair(lFieldTemp.FJsonName, TJsonNull.Create);
            continue;
          end;
          // 开始
          case lField.DataType of
            TFieldType.ftString:
              lJsonObj.AddPair(lFieldTemp.FJsonName, TJsonString.Create(lField.AsString));
            TFieldType.ftSmallint:
              lJsonObj.AddPair(lFieldTemp.FJsonName, TJsonNumber.Create(lField.AsInteger));
            TFieldType.ftInteger:
              lJsonObj.AddPair(lFieldTemp.FJsonName, TJsonNumber.Create(lField.AsInteger));
            TFieldType.ftWord:
              lJsonObj.AddPair(lFieldTemp.FJsonName, TJsonNumber.Create(lField.AsInteger));
            TFieldType.ftBoolean:
              lJsonObj.AddPair(lFieldTemp.FJsonName, TJSONBool.Create(lField.AsBoolean));
            TFieldType.ftFloat:
              lJsonObj.AddPair(lFieldTemp.FJsonName, TJsonNumber.Create(lField.AsFloat));
            TFieldType.ftCurrency:
              lJsonObj.AddPair(lFieldTemp.FJsonName, TJsonNumber.Create(lField.AsCurrency));
            TFieldType.ftBCD:
              lJsonObj.AddPair(lFieldTemp.FJsonName, TJsonNumber.Create(lField.AsFloat));
            TFieldType.ftDate:
              if lFieldTemp.FFormat <> '' then
              begin
                lJsonObj.AddPair(lFieldTemp.FJsonName,
                  TJsonString.Create(FormatDateTime(lFieldTemp.FFormat, lField.AsDateTime)));
              end
              else
              begin
                lJsonObj.AddPair(lFieldTemp.FJsonName,
                  TJsonString.Create(DateToISO8601(lField.AsDateTime, false)));
              end;
            TFieldType.ftTime:
              if lFieldTemp.FFormat <> '' then
              begin
                lJsonObj.AddPair(lFieldTemp.FJsonName,
                  TJsonString.Create(FormatDateTime(lFieldTemp.FFormat, lField.AsDateTime)));
              end
              else
              begin
                lJsonObj.AddPair(lFieldTemp.FJsonName,
                  TJsonString.Create(DateToISO8601(lField.AsDateTime, false)));
              end;
            TFieldType.ftDateTime:
              begin
                if lFieldTemp.FFormat <> '' then
                begin
                  lJsonObj.AddPair(lFieldTemp.FJsonName,
                    TJsonString.Create(FormatDateTime(lFieldTemp.FFormat, lField.AsDateTime)));
                end
                else
                begin
                  lJsonObj.AddPair(lFieldTemp.FJsonName,
                    TJsonString.Create(DateToISO8601(lField.AsDateTime, false)));
                end;
              end;
            TFieldType.ftBytes:
              lJsonObj.AddPair(lFieldTemp.FJsonName,
                TJsonString.Create(TNetEncoding.Base64.EncodeBytesToString(lField.AsBytes)));
            TFieldType.ftVarBytes:
              lJsonObj.AddPair(lFieldTemp.FJsonName,
                TJsonString.Create(TNetEncoding.Base64.EncodeBytesToString(lField.AsBytes)));
            TFieldType.ftAutoInc:
              lJsonObj.AddPair(lFieldTemp.FJsonName, TJsonNumber.Create(lField.AsInteger));
            TFieldType.ftBlob:
              lJsonObj.AddPair(lFieldTemp.FJsonName,
                TJsonString.Create(BlobFieldToBase64(lField as TBlobField)));
            TFieldType.ftMemo:
              lJsonObj.AddPair(lFieldTemp.FJsonName, TJsonString.Create(lField.AsString));
            TFieldType.ftGraphic:
              lJsonObj.AddPair(lFieldTemp.FJsonName,
                TJsonString.Create(TNetEncoding.Base64.EncodeBytesToString(lField.AsBytes)));
            TFieldType.ftTypedBinary:
              lJsonObj.AddPair(lFieldTemp.FJsonName,
                TJsonString.Create(TNetEncoding.Base64.EncodeBytesToString(lField.AsBytes)));
            TFieldType.ftFixedChar:
              lJsonObj.AddPair(lFieldTemp.FJsonName, TJsonString.Create(lField.AsString));
            TFieldType.ftWideString:
              lJsonObj.AddPair(lFieldTemp.FJsonName, TJsonString.Create(lField.AsWideString));
            TFieldType.ftLargeint:
              lJsonObj.AddPair(lFieldTemp.FJsonName, TJsonNumber.Create(lField.AsLargeInt));
            TFieldType.ftADT:
              lJsonObj.AddPair(lFieldTemp.FJsonName,
                TJsonString.Create(TNetEncoding.Base64.EncodeBytesToString(lField.AsBytes)));
            TFieldType.ftArray:
              lJsonObj.AddPair(lFieldTemp.FJsonName,
                TJsonString.Create(TNetEncoding.Base64.EncodeBytesToString(lField.AsBytes)));
            TFieldType.ftOraBlob:
              lJsonObj.AddPair(lFieldTemp.FJsonName,
                TJsonString.Create(TNetEncoding.Base64.EncodeBytesToString(lField.AsBytes)));
            TFieldType.ftOraClob:
              lJsonObj.AddPair(lFieldTemp.FJsonName,
                TJsonString.Create(TNetEncoding.Base64.EncodeBytesToString(lField.AsBytes)));
            TFieldType.ftVariant:
              lJsonObj.AddPair(lFieldTemp.FJsonName, TJsonString.Create(lField.AsString));
            TFieldType.ftGuid:
              lJsonObj.AddPair(lFieldTemp.FJsonName, TJsonString.Create(lField.AsString));
            TFieldType.ftTimeStamp:
              if lFieldTemp.FFormat <> '' then
              begin
                lJsonObj.AddPair(lFieldTemp.FJsonName,
                  TJsonString.Create(FormatDateTime(lFieldTemp.FFormat, lField.AsDateTime)));
              end
              else
              begin
                lJsonObj.AddPair(lFieldTemp.FJsonName,
                  TJsonString.Create(DateToISO8601(lField.AsDateTime, false)));
              end;
            TFieldType.ftFMTBcd:
              lJsonObj.AddPair(lFieldTemp.FJsonName, TJsonNumber.Create(lField.AsFloat));
            TFieldType.ftFixedWideChar:
              lJsonObj.AddPair(lFieldTemp.FJsonName, TJsonString.Create(lField.AsString));
            TFieldType.ftWideMemo:
              lJsonObj.AddPair(lFieldTemp.FJsonName, TJsonString.Create(lField.AsString));
            TFieldType.ftOraTimeStamp:
              lJsonObj.AddPair(lFieldTemp.FJsonName,
                TJsonString.Create(DateToISO8601(lField.AsDateTime, false)));
            TFieldType.ftOraInterval:
              lJsonObj.AddPair(lFieldTemp.FJsonName, TJsonString.Create(lField.AsString));
            TFieldType.ftLongWord:
              lJsonObj.AddPair(lFieldTemp.FJsonName, TJsonNumber.Create(lField.AsInteger));
            TFieldType.ftShortint:
              lJsonObj.AddPair(lFieldTemp.FJsonName, TJsonNumber.Create(lField.AsInteger));
            TFieldType.ftByte:
              lJsonObj.AddPair(lFieldTemp.FJsonName, TJsonNumber.Create(lField.AsInteger));
            TFieldType.ftExtended:
              lJsonObj.AddPair(lFieldTemp.FJsonName, TJsonNumber.Create(lField.AsFloat));
            TFieldType.ftTimeStampOffset:
              lJsonObj.AddPair(lFieldTemp.FJsonName, TJsonString.Create(lField.AsString));
            TFieldType.ftSingle:
              lJsonObj.AddPair(lFieldTemp.FJsonName, TJsonNumber.Create(lField.AsFloat));
          end;
        end;

        Query.Next;
      end;
      Result := lJsonArray;
    except
      on e: exception do
      begin
        lJsonArray.Free;
        QApiAll.errMsg := e.Message;
      end;
    end;
  finally
    for iField := 0 to lFieldList.Count - 1 do
    begin
      lFieldList[iField].Free;
    end;
    lFieldList.Clear;
    lFieldList.Free;
  end;

end;

function BlobFieldToBase64(ABlobField: TBlobField): string;
var
  LBlobStream: TMemoryStream;
begin
  LBlobStream := TMemoryStream.Create;
  try
    ABlobField.SaveToStream(LBlobStream);
    LBlobStream.Position := soFromBeginning;
    Result := OneStreamString.StreamToBase64Str(LBlobStream);
  finally
    LBlobStream.Free;
  end;
end;

end.

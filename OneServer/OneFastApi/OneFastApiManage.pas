unit OneFastApiManage;

interface

uses system.Generics.Collections, system.Classes, system.StrUtils, system.SysUtils, system.TypInfo, Data.DB;

type
  // openData跟据SQSL语句打开数据
  // openDataStore跟据存储过程打开数据
  // doStore执行存储过程
  // dmlInsert 执行DMl语句插入
  // dmlUpdate 执行DMl语句更新
  // dmlDel执行DML语句删除
  // appendDatas 批量执行插入数据
  emDataOpenMode = (unkown, openData, openDataStore, doStore, doDMLSQL, appendDatas);

  TFastApi = class;
  TFastApiData = class;
  TFastApiField = class;
  TFastApiFilter = class;

  TFastApi = class
  private
    FApiID_: string;
    FPApiID_: string;
    FApiCode_: string;
    FApiCaption_: string;
    FOrderNumber_: integer;
    FIsMenu_: boolean;
    FIsEnabled_: boolean;
    // Token登陆
    FApiAuthor_: string; // 权限验证
    FApiRole_: string; // 用户角色
  published
    property FApiID: string read FApiID_ write FApiID_;
    property FPApiID: string read FPApiID_ write FPApiID_;
    property FApiCode: string read FApiCode_ write FApiCode_;
    property FApiCaption: string read FApiCaption_ write FApiCaption_;
    property FOrderNumber: integer read FOrderNumber_ write FOrderNumber_;
    property FIsMenu: boolean read FIsMenu_ write FIsMenu_;
    property FIsEnabled: boolean read FIsEnabled_ write FIsEnabled_;
    property FApiAuthor: string read FApiAuthor_ write FApiAuthor_;
    property FApiRole: string read FApiRole_ write FApiRole_;
  end;

  TFastApiData = class
  private
    FMyDataOpenMode_: emDataOpenMode;
    FMyFilterLine_: integer;
    FMyIsChangeField_: boolean;
    FMyDataIndex_: integer;
    FMyTreeLeve_: integer;
  private
    FDataID_: string;
    FPDataID_: string;
    FApiID_: string;
    FTreeCode_: string;
    FDataName_: string;
    FDataCaption_: string;
    FDataJsonName_: string;
    FDataJsonType_: string;
    FDataZTCode_: string;
    FDataTable_: string;
    FDataStoreName_: string;
    FDataPrimaryKey_: string;
    FDataOpenMode_: string;
    FDataPageSize_: integer;
    FDataUpdateMode_: string;
    FDataSQL_: string;
    FMinAffected_: integer; // 执行DML最小影响行数
    FMaxAffected_: integer; // 执行DML最大影响行数
    //
    FChildFields_: TList<TFastApiField>;
    FChildFilters_: TList<TFastApiFilter>;
    FChildDatas_: TList<TFastApiData>;
  public
    constructor Create;
    destructor Destroy; override;
    function DataOpenMode(): emDataOpenMode;
    function FilterLine(): integer;
    function DataIndex(): integer;
    function TreeLeve(): integer;
    function IsChangeField(): boolean;
  published
    property FDataID: string read FDataID_ write FDataID_;
    property FPDataID: string read FPDataID_ write FPDataID_;
    property FApiID: string read FApiID_ write FApiID_;
    property FTreeCode: string read FTreeCode_ write FTreeCode_;
    property FDataName: string read FDataName_ write FDataName_;
    property FDataCaption: string read FDataCaption_ write FDataCaption_;
    property FDataJsonName: string read FDataJsonName_ write FDataJsonName_;
    property FDataJsonType: string read FDataJsonType_ write FDataJsonType_;
    property FDataZTCode: string read FDataZTCode_ write FDataZTCode_;
    property FDataTable: string read FDataTable_ write FDataTable_;
    property FDataStoreName: string read FDataStoreName_ write FDataStoreName_;
    property FDataPrimaryKey: string read FDataPrimaryKey_ write FDataPrimaryKey_;
    property FDataOpenMode: string read FDataOpenMode_ write FDataOpenMode_;
    property FDataPageSize: integer read FDataPageSize_ write FDataPageSize_;
    property FDataUpdateMode: string read FDataUpdateMode_ write FDataUpdateMode_;
    property FDataSQL: string read FDataSQL_ write FDataSQL_;
    property FMinAffected: integer read FMinAffected_ write FMinAffected_;
    property FMaxAffected: integer read FMaxAffected_ write FMaxAffected_;

    property ChildFields: TList<TFastApiField> read FChildFields_ write FChildFields_;
    property ChildFilters: TList<TFastApiFilter> read FChildFilters_ write FChildFilters_;
    property ChildDatas: TList<TFastApiData> read FChildDatas_ write FChildDatas_;
  end;

  TFastApiField = class
  private
    FFieldID_: string;
    FDataID_: string;
    FApiID_: string;
    FOrderNumber_: integer;
    FFieldName_: string;
    FFieldCaption_: string;
    FFieldJsonName_: string;
    FFieldFormat_: string;
    FFieldKind_: string;
    FFieldDataType_: string;
    FFieldSize_: integer;
    FFieldPrecision_: integer;
    FFieldProvidFlagKey_: boolean;
    FFieldProvidFlagUpdate_: boolean;
    FFieldProvidFlagWhere_: boolean;
    FFieldDefaultValueType_: string;
    FFieldDefaultValue_: string;
    FFieldShowPass_: string;
    FFieldCheckEmpty_: boolean;
  published
    property FFieldID: string read FFieldID_ write FFieldID_;
    property FDataID: string read FDataID_ write FDataID_;
    property FApiID: string read FApiID_ write FApiID_;
    property FOrderNumber: integer read FOrderNumber_ write FOrderNumber_;
    property FFieldName: string read FFieldName_ write FFieldName_;
    property FFieldCaption: string read FFieldCaption_ write FFieldCaption_;
    property FFieldJsonName: string read FFieldJsonName_ write FFieldJsonName_;
    property FFieldFormat: string read FFieldFormat_ write FFieldFormat_;
    property FFieldKind: string read FFieldKind_ write FFieldKind_;
    property FFieldDataType: string read FFieldDataType_ write FFieldDataType_;
    property FFieldSize: integer read FFieldSize_ write FFieldSize_;
    property FFieldPrecision: integer read FFieldPrecision_ write FFieldPrecision_;
    property FFieldProvidFlagKey: boolean read FFieldProvidFlagKey_ write FFieldProvidFlagKey_;
    property FFieldProvidFlagUpdate: boolean read FFieldProvidFlagUpdate_ write FFieldProvidFlagUpdate_;
    property FFieldProvidFlagWhere: boolean read FFieldProvidFlagWhere_ write FFieldProvidFlagWhere_;
    property FFieldDefaultValueType: string read FFieldDefaultValueType_ write FFieldDefaultValueType_;
    property FFieldDefaultValue: string read FFieldDefaultValue_ write FFieldDefaultValue_;
    property FFieldShowPass: string read FFieldShowPass_ write FFieldShowPass_;
    property FFieldCheckEmpty: boolean read FFieldCheckEmpty_ write FFieldCheckEmpty_;
  end;

  TFastApiFilter = class
  private
    // SQL语句已经写好的参数，固定参数,不需要组装SQL
    FMyIsFixSQLParam_: boolean;
    FMyFieldNames: TArray<string>;
  private
    FFilterID_: string;
    FDataID_: string;
    FApiID_: string;
    FOrderNumber_: integer;
    FFilterName_: string;
    FFilterCaption_: string;
    FFilterJsonName_: string;
    FFilterFieldMode_: string; // 单字段,多字段,值选择，父级关联
    FFilterField_: string;
    FPFilterField_: string;
    FFilterFieldItems_: string; // 多字段或值选择SQLL
    FFilterDataType_: string;
    FFilterFormat_: string;
    FFilterExpression_: string;
    FFilterbMust_: boolean;
    FFilterbValue_: boolean;
    FJsonIsEmptyGetDefault_: boolean;
    FFilterDefaultType_: string;
    FFilterDefaultValue_: string;
    FbOutParam_: boolean;
    FOutParamTag_: string;
  public
    constructor Create;
    destructor Destroy; override;
    function IsFixSQLParam(): boolean;
    function FieldNames(): TArray<string>;
    function GetValueSQL(QValue: string; var QSQL: string): boolean;
  published
    property FFilterID: string read FFilterID_ write FFilterID_;
    property FDataID: string read FDataID_ write FDataID_;
    property FApiID: string read FApiID_ write FApiID_;
    property FOrderNumber: integer read FOrderNumber_ write FOrderNumber_;
    property FFilterName: string read FFilterName_ write FFilterName_;
    property FFilterCaption: string read FFilterCaption_ write FFilterCaption_;
    property FFilterJsonName: string read FFilterJsonName_ write FFilterJsonName_;
    property FFilterFieldMode: string read FFilterFieldMode_ write FFilterFieldMode_;
    property FFilterField: string read FFilterField_ write FFilterField_;
    property FPFilterField: string read FPFilterField_ write FPFilterField_;
    property FFilterFieldItems: string read FFilterFieldItems_ write FFilterFieldItems_;
    property FFilterDataType: string read FFilterDataType_ write FFilterDataType_;
    property FFilterFormat: string read FFilterFormat_ write FFilterFormat_;
    property FFilterExpression: string read FFilterExpression_ write FFilterExpression_;
    property FFilterbMust: boolean read FFilterbMust_ write FFilterbMust_;
    property FFilterbValue: boolean read FFilterbValue_ write FFilterbValue_;
    property FJsonIsEmptyGetDefault: boolean read FJsonIsEmptyGetDefault_ write FJsonIsEmptyGetDefault_;
    property FFilterDefaultType: string read FFilterDefaultType_ write FFilterDefaultType_;
    property FFilterDefaultValue: string read FFilterDefaultValue_ write FFilterDefaultValue_;
    property FbOutParam: boolean read FbOutParam_ write FbOutParam_;
    property FOutParamTag: string read FOutParamTag_ write FOutParamTag_;
  end;

  TFastApiInfo = class
  private
    fastApi_: TFastApi;
    fastDatas_: TList<TFastApiData>;
    isCheck_: boolean;
    errMsg_: string;
  private
    function CheckDatas(QDatas: TList<TFastApiData>; QTreeLeve: integer): boolean;
  public
    constructor Create;
    destructor Destroy; override;
    function CheckApiInfo(): boolean;
  published
    property fastApi: TFastApi read fastApi_ write fastApi_;
    property fastDatas: TList<TFastApiData> read fastDatas_ write fastDatas_;
    property errMsg: string read errMsg_ write errMsg_;
  end;

  TOneFastApiManage = class
  private
    FStop: boolean;
    FLockObj: TObject;
    FZTCode: string;
    FApiInfos: TDictionary<string, TFastApiInfo>;
  public
    constructor Create;
    destructor Destroy; override;
  public
    function GetApiInfo(QApiCode: string; var QErrMsg: string): TFastApiInfo;
    function RefreshApiInfo(QApiCode: string; var QErrMsg: string): boolean;
    function RefreshApiInfoAll(var QErrMsg: string): boolean;
  published
    property ZTCode: string read FZTCode write FZTCode;
    property ApiInfos: TDictionary<string, TFastApiInfo> read FApiInfos write FApiInfos;
  end;

function UnitFastApiManage(): TOneFastApiManage;

implementation

uses OneOrm;

var
  Unit_FastApiManage: TOneFastApiManage = nil;

function UnitFastApiManage(): TOneFastApiManage;
begin
  if Unit_FastApiManage = nil then
  begin
    Unit_FastApiManage := TOneFastApiManage.Create;
  end;
  Result := Unit_FastApiManage;
end;

constructor TFastApiData.Create;
begin
  self.FMyDataOpenMode_ := emDataOpenMode.unkown;
  self.FMyFilterLine_ := -1;
  self.FMyIsChangeField_ := false;
  self.FChildFields_ := TList<TFastApiField>.Create;
  self.FChildFilters_ := TList<TFastApiFilter>.Create;
  self.FChildDatas_ := TList<TFastApiData>.Create;
end;

destructor TFastApiData.Destroy;
var
  i: integer;
begin
  for i := 0 to self.FChildFields_.Count - 1 do
  begin
    self.FChildFields_[i].Free;
  end;
  self.FChildFields_.clear;
  self.FChildFields_.Free;

  for i := 0 to self.FChildFilters_.Count - 1 do
  begin
    self.FChildFilters_[i].Free;
  end;
  self.FChildFilters_.clear;
  self.FChildFilters_.Free;

  for i := 0 to self.FChildDatas_.Count - 1 do
  begin
    self.FChildDatas_[i].Free;
  end;
  self.FChildDatas_.clear;
  self.FChildDatas_.Free;
  inherited;
end;

function TFastApiData.DataOpenMode(): emDataOpenMode;
begin
  if self.FMyDataOpenMode_ = emDataOpenMode.unkown then
  begin
    self.FMyDataOpenMode_ := emDataOpenMode(GetEnumValue(TypeInfo(emDataOpenMode), self.FDataOpenMode_));
  end;
  Result := self.FMyDataOpenMode_;
end;

function TFastApiData.FilterLine(): integer;
begin
  Result := self.FMyFilterLine_;
end;

function TFastApiData.DataIndex(): integer;
begin
  Result := self.FMyDataIndex_;
end;

function TFastApiData.TreeLeve(): integer;
begin
  Result := self.FMyTreeLeve_;
end;

function TFastApiData.IsChangeField(): boolean;
begin
  Result := self.FMyIsChangeField_;
end;

constructor TFastApiFilter.Create;
begin
  self.FMyIsFixSQLParam_ := false;
end;

destructor TFastApiFilter.Destroy;
begin
  setLength(self.FMyFieldNames, 0);
  self.FMyFieldNames := nil;
  inherited;
end;

function TFastApiFilter.IsFixSQLParam(): boolean;
begin
  Result := self.FMyIsFixSQLParam_;
end;

function TFastApiFilter.FieldNames(): TArray<string>;
var
  tempList: TStringList;
  i: integer;
begin
  if Length(self.FMyFieldNames) = 0 then
  begin
    tempList := TStringList.Create;
    try
      if self.FFilterFieldMode = '多字段' then
      begin
        // 一行一个
        tempList.Text := self.FFilterFieldItems;
        setLength(self.FMyFieldNames, tempList.Count);
        for i := 0 to tempList.Count - 1 do
        begin
          self.FMyFieldNames[i] := tempList[i];
        end;
      end
      else if self.FFilterFieldMode = '值选择' then
      begin
        //
      end
      else
      begin
        setLength(self.FMyFieldNames, 1);
        self.FMyFieldNames[0] := self.FFilterField;
      end;
    finally
      tempList.Free;
    end;
  end;
  Result := self.FMyFieldNames;
end;

function TFastApiFilter.GetValueSQL(QValue: string; var QSQL: string): boolean;
var
  tempList: TStringList;
  i: integer;
begin
  Result := false;
  QSQL := '';
  tempList := TStringList.Create;
  try
    tempList.Text := self.FFilterFieldItems;
    for i := 0 to tempList.Count - 1 do
    begin
      if tempList.Names[i] = QValue then
      begin
        QSQL := tempList.ValueFromIndex[i];
        QSQL := QSQL.Trim;
        if not QSQL.StartsWith('and') then
        begin
          QSQL := ' and ' + QSQL + ' ';
        end;
        Result := true;
        exit;
      end;
    end;
  finally
    tempList.Free;
  end;
end;

constructor TFastApiInfo.Create;
begin
  self.fastDatas_ := TList<TFastApiData>.Create;
  self.isCheck_ := false;
  self.errMsg_ := '';
end;

destructor TFastApiInfo.Destroy;
var
  i: integer;
begin
  for i := 0 to self.fastDatas_.Count - 1 do
  begin
    self.fastDatas_[i].Free;
  end;
  self.fastDatas_.clear;
  self.fastDatas_.Free;
  self.fastApi_.Free;
  inherited;
end;

function TFastApiInfo.CheckDatas(QDatas: TList<TFastApiData>; QTreeLeve: integer): boolean;
var
  iSQL, iData, iParam, iField, iFilter: integer;
  iFilterLine: integer; // 'and 101=102'
  isFindParam: boolean;
  lApiData: TFastApiData;
  lApiField: TFastApiField;
  lApiFilter: TFastApiFilter;
  LSQLParams: TParams;
  lParam: TParam;
  lParamName: string;
  //
  lSQLList: TStringList;
  tempSQL: string;
begin
  Result := false;
  if QDatas = nil then
  begin
    Result := true;
    exit;
  end;
  if QDatas.Count = 0 then
  begin
    Result := true;
    exit;
  end;
  // FMyDataIndex_: integer;
  // FMyTreeLeve_: integer;

  for iData := 0 to QDatas.Count - 1 do
  begin
    lApiData := QDatas[iData];
    lApiData.FMyTreeLeve_ := QTreeLeve;
    lApiData.FMyDataIndex_ := iData;
    if lApiData.DataOpenMode() = emDataOpenMode.unkown then
    begin
      self.errMsg_ := '数据集打开模式[' + lApiData.FDataOpenMode + ']未设计';
      exit;
    end;
    if lApiData.FDataName = '' then
    begin
      self.errMsg_ := '数据集名称不可为空,且不能重复';
      exit;
    end;
    if lApiData.FDataJsonName = '' then
    begin
      lApiData.FDataJsonName := lApiData.FDataName;
    end;

    if lApiData.DataOpenMode() in [openDataStore, doStore] then
    begin
      if lApiData.FDataStoreName = '' then
      begin
        self.errMsg_ := '数据集打开模式[' + lApiData.FDataOpenMode + ']存储过程名称不可为空';
        exit;
      end;
    end;

    // Json为空时默认为字段
    for iField := 0 to lApiData.ChildFields.Count - 1 do
    begin
      lApiField := lApiData.ChildFields[iField];
      if lApiField.FFieldJsonName = '' then
      begin
        lApiField.FFieldJsonName := lApiField.FFieldName;
      end;
      if lApiField.FFieldName_ <> lApiField.FFieldJsonName then
        lApiData.FMyIsChangeField_ := true;
    end;
    for iFilter := 0 to lApiData.ChildFilters.Count - 1 do
    begin
      lApiFilter := lApiData.ChildFilters[iFilter];
      if lApiFilter.FFilterJsonName = '' then
      begin
        lApiFilter.FFilterJsonName := lApiFilter.FFilterName;
      end;
      if lApiFilter.FFilterExpression = '' then
        lApiFilter.FFilterExpression := '=';
      if lApiFilter.FFilterFieldMode = '' then
        lApiFilter.FFilterFieldMode := '单字段';
      if lApiFilter.FFilterDefaultType = '' then
        lApiFilter.FFilterDefaultType := 'fromJsonParam';
    end;

    // 有条件的要单独设计一行条件行 and (101=102)
    LSQLParams := TParams.Create(nil);
    lSQLList := TStringList.Create;
    try
      lSQLList.Text := lApiData.FDataSQL;
      LSQLParams.ParseSQL(lApiData.FDataSQL, true);
      for iParam := 0 to LSQLParams.Count - 1 do
      begin
        lParam := LSQLParams[iParam];
        lParamName := lParam.Name;
        isFindParam := false;
        // 在条件是否能找到相关配置
        for iFilter := 0 to lApiData.ChildFilters.Count - 1 do
        begin
          lApiFilter := lApiData.ChildFilters[iFilter];
          if lApiFilter.FFilterField.ToLower = lParamName.ToLower then
          begin
            // SQL里面的参数是必需的条件
            isFindParam := true;
            lApiFilter.FMyIsFixSQLParam_ := true;

            if lApiData.DataOpenMode() in [openDataStore, doStore] then
            begin
              if lApiFilter.FbOutParam then
              else
              begin
                // 非输出参数,必输入值
                lApiFilter.FFilterbMust := true;
              end;
            end
            else
            begin
              // 只能是单字段过滤,固定SQL
              lApiFilter.FFilterbMust := true;
              lApiFilter.FFilterbValue := true;
            end;

            // 条件字段也是固定的
            lApiFilter.FFilterField := lParamName;
            // 也是固定的不组装SQL,也不解析多字段
            if lApiFilter.FFilterFieldMode = '父级关联' then
            begin
              if lApiFilter.FPFilterField = '' then
              begin
                self.errMsg_ := '数据集[' + lApiData.FDataName + ']条件[' + lApiFilter.FFilterName + ']父级关联【FPFilterField】关联字段未设置';
                exit;
              end;
            end
            else
            begin
              lApiFilter.FFilterFieldMode := '单字段';
              lApiFilter.FFilterExpression := '=';
            end;
            break;
          end;
        end;
        if not isFindParam then
        begin
          self.errMsg_ := 'SQL语句参数[' + lParamName + ']在条件设置未设置';
          exit;
        end;
      end;
      // 有其它多余的条件行
      if lApiData.ChildFilters.Count > LSQLParams.Count then
      begin
        // 必定设置
        if lApiData.DataOpenMode() = emDataOpenMode.openData then
        begin
          iFilterLine := -1;
          for iSQL := 0 to lSQLList.Count - 1 do
          begin
            tempSQL := lSQLList[iSQL];
            if tempSQL.Trim.ToLower = 'and 101=102' then
            begin
              iFilterLine := iSQL;
              break;
            end;
          end;
          if iFilterLine = -1 then
          begin
            self.errMsg_ := '当为查询语句时，且有条件设置,那么请设置条件行，独立一行SQL如下[and 101=102]，中括号里面SQL语句';
            exit;
          end;
          // 设置条件行
          lApiData.FMyFilterLine_ := iFilterLine;
        end;
      end;
    finally
      LSQLParams.Free;
      lSQLList.Free;
    end;
    if lApiData.ChildDatas = nil then
    begin
      continue;
    end;
    if not self.CheckDatas(lApiData.ChildDatas, QTreeLeve + 1) then
      exit;
  end;
  Result := true;
end;

function TFastApiInfo.CheckApiInfo(): boolean;
begin
  if self.isCheck_ then
  begin
    Result := (self.errMsg_ = '');
    exit;
  end;
  try
    // 开始校验一些信息
    if not self.fastApi.FIsEnabled then
    begin
      self.errMsg_ := '接口未启用';
      exit;
    end;
    //
    if (self.fastDatas = nil) or (self.fastDatas.Count = 0) then
    begin
      self.errMsg_ := '无相关数据集';
      exit;
    end;
    if not self.CheckDatas(self.fastDatas, 0) then
    begin
      exit;
    end;
    Result := true;
  finally
    self.isCheck_ := true;
  end;
end;

constructor TOneFastApiManage.Create;
begin
  FLockObj := TObject.Create;
  FApiInfos := TDictionary<string, TFastApiInfo>.Create;
end;

destructor TOneFastApiManage.Destroy;
var
  lApiInfo: TFastApiInfo;
begin
  for lApiInfo in FApiInfos.Values do
  begin
    lApiInfo.Free;
  end;
  FApiInfos.clear;
  FApiInfos.Free;
  FLockObj.Free;
  inherited;
end;

function TOneFastApiManage.GetApiInfo(QApiCode: string; var QErrMsg: string): TFastApiInfo;
var
  lApiInfo: TFastApiInfo;
  lApiList: TList<TFastApi>;
  lOrmModule: IOneOrm<TFastApi>;
  //
  lFastApi: TFastApi;
  lData, lPData: TFastApiData;
  lField: TFastApiField;
  lFilter: TFastApiFilter;
  //
  lOrmData: IOneOrm<TFastApiData>;
  lOrmField: IOneOrm<TFastApiField>;
  lOrmFilter: IOneOrm<TFastApiFilter>;
  //
  lApiDatas: TList<TFastApiData>;
  lApiFields: TList<TFastApiField>;
  lApiFilters: TList<TFastApiFilter>;
  isErr, isRepate: boolean;
  i, iData, iField, iFilter: integer;
  lDictDatas: TDictionary<string, TFastApiData>;
  lObjList: TList<TObject>;
  lDataIntList, lIntList: TList<integer>;
begin
  Result := nil;
  QErrMsg := '';
  isErr := false;
  isRepate := false;
  if self.FStop then
  begin
    QErrMsg := '接口管理已禁用';
    exit;
  end;
  if self.FApiInfos.ContainsKey(QApiCode) then
  begin
    self.FApiInfos.TryGetValue(QApiCode, lApiInfo);
    if not lApiInfo.fastApi.FIsEnabled then
    begin
      QErrMsg := '接口[' + QApiCode + ']未启用';
      exit;
    end;
    Result := lApiInfo;
    exit;
  end;
  lApiList := nil;
  lApiDatas := nil;
  lApiFields := nil;
  lApiFilters := nil;
  lFastApi := nil;
  lDictDatas := TDictionary<string, TFastApiData>.Create;
  lObjList := TList<TObject>.Create;
  lDataIntList := TList<integer>.Create;
  lIntList := TList<integer>.Create;
  try
    // 查询模块信息
    lOrmModule := TOneOrm<TFastApi>.Start();
    try
      lApiList := lOrmModule.ZTCode(self.FZTCode).Query('select * from onefast_api where FApiCode=:FApiCode', [QApiCode]).ToList();
    except
      on e: Exception do
      begin
        isErr := true;
        QErrMsg := e.Message;
        exit;
      end;
    end;
    if lApiList.Count = 0 then
    begin
      isErr := true;
      QErrMsg := '不存在此接口代码配置';
      exit;
    end;
    lFastApi := lApiList[0];
    for i := lApiList.Count - 1 downto 0 do
    begin
      lObjList.Add(lApiList[i]);
      lApiList.Delete(i);
    end;

    if lApiList.Count > 1 then
    begin
      isErr := true;
      QErrMsg := '此接口代码配置[' + QApiCode + ']重复,请联系管理员修正';
      exit;
    end;

    if not lFastApi.FIsEnabled then
    begin
      isErr := true;
      QErrMsg := '此接口代码配置[' + QApiCode + ']未启用';
      exit;
    end;

    // 查询模块相关信息
    lOrmData := TOneOrm<TFastApiData>.Start();
    lOrmField := TOneOrm<TFastApiField>.Start();
    lOrmFilter := TOneOrm<TFastApiFilter>.Start();

    try
      lApiDatas := lOrmData.ZTCode(self.FZTCode).Query('select * from onefast_api_data where FApiID=:FApiID order by FTreeCode Asc ', [lFastApi.FApiID]).ToList();
      lApiFields := lOrmField.ZTCode(self.FZTCode).Query('select * from onefast_api_field where FApiID=:FApiID order by FDataID,FOrderNumber Asc ', [lFastApi.FApiID]).ToList();
      lApiFilters := lOrmFilter.ZTCode(self.FZTCode).Query('select * from onefast_api_filter where FApiID=:FApiID order by FDataID,FOrderNumber Asc ', [lFastApi.FApiID]).ToList();
    except
      on e: Exception do
      begin
        isErr := true;
        QErrMsg := e.Message;
        exit;
      end;
    end;
    // 数据集组装
    Result := TFastApiInfo.Create;
    Result.fastApi := lFastApi;
    for iData := 0 to lApiDatas.Count - 1 do
    begin
      lData := lApiDatas[iData];
      if lDictDatas.TryGetValue(lData.FPDataID, lPData) then
      begin
        lPData.ChildDatas.Add(lData);
      end
      else
      begin
        Result.fastDatas.Add(lData);
      end;
      lObjList.Add(lData);
      lDataIntList.Add(iData);
      lDictDatas.Add(lData.FDataID, lData);
      // 增加字段
      lIntList.clear;
      for iField := 0 to lApiFields.Count - 1 do
      begin
        lField := lApiFields[iField];
        if lField.FDataID = lData.FDataID then
        begin
          lData.ChildFields.Add(lField);
          lObjList.Add(lField);
          lIntList.Add(iField);
        end;
      end;
      // 删除已使用的字段
      for iField := lIntList.Count - 1 downto 0 do
      begin
        lApiFields.Delete(lIntList[iField]);
      end;

      // 增加条件
      lIntList.clear;
      for iFilter := 0 to lApiFilters.Count - 1 do
      begin
        lFilter := lApiFilters[iFilter];
        if lFilter.FDataID = lData.FDataID then
        begin
          lData.ChildFilters.Add(lFilter);
          lObjList.Add(lFilter);
          lIntList.Add(iFilter);
        end;
      end;
      // 删除已使用的条件
      for iFilter := lIntList.Count - 1 downto 0 do
      begin
        lApiFilters.Delete(lIntList[iFilter]);
      end;
    end;
    for iData := lDataIntList.Count - 1 downto 0 do
    begin
      lApiDatas.Delete(lDataIntList[iData]);
    end;

    TMonitor.Enter(self.FLockObj);
    try
      if self.FApiInfos.ContainsKey(QApiCode) then
      begin
        isRepate := true;
        self.FApiInfos.TryGetValue(QApiCode, lApiInfo);
        Result := lApiInfo;
        exit;
      end
      else
      begin
        self.FApiInfos.Add(QApiCode, Result);
      end;
    finally
      TMonitor.exit(self.FLockObj);
    end;
  finally
    if lDictDatas <> nil then
    begin
      lDictDatas.clear;
      lDictDatas.Free;
    end;

    if lApiList <> nil then
    begin
      for i := 0 to lApiList.Count - 1 do
      begin
        lApiList[i].Free;
      end;
      lApiList.clear;
      lApiList.Free;
    end;
    if lApiDatas <> nil then
    begin
      for i := 0 to lApiDatas.Count - 1 do
      begin
        lApiDatas[i].Free;
      end;
      lApiDatas.clear;
      lApiDatas.Free;
    end;

    if lApiFields <> nil then
    begin
      for i := 0 to lApiFields.Count - 1 do
      begin
        lApiFields[i].Free;
      end;
      lApiFields.clear;
      lApiFields.Free;
    end;

    if lApiFilters <> nil then
    begin
      for i := 0 to lApiFilters.Count - 1 do
      begin
        lApiFilters[i].Free;
      end;
      lApiFilters.clear;
      lApiFilters.Free;
    end;
    if (isErr) or (isRepate) then
    begin
      for i := 0 to lObjList.Count - 1 do
      begin
        lObjList[i].Free;
      end;
    end;
    lObjList.clear;
    lObjList.Free;
    lDataIntList.clear;
    lDataIntList.Free;
    lIntList.clear;
    lIntList.Free;
  end;
end;

function TOneFastApiManage.RefreshApiInfo(QApiCode: string; var QErrMsg: string): boolean;
begin
  Result := false;
  QErrMsg := '';
  self.FApiInfos.Remove(QApiCode);
  self.GetApiInfo(QApiCode, QErrMsg);
  Result := (QErrMsg = '');
end;

function TOneFastApiManage.RefreshApiInfoAll(var QErrMsg: string): boolean;
var
  lApiInfo: TFastApiInfo;
  lApiList: TList<TFastApi>;
  lOrmApi: IOneOrm<TFastApi>;
  //
  lFastApi: TFastApi;
  lData, lPData: TFastApiData;
  lField: TFastApiField;
  lFilter: TFastApiFilter;
  //
  lOrmData: IOneOrm<TFastApiData>;
  lOrmField: IOneOrm<TFastApiField>;
  lOrmFilter: IOneOrm<TFastApiFilter>;
  //
  lApiDatas: TList<TFastApiData>;
  lApiFields: TList<TFastApiField>;
  lApiFilters: TList<TFastApiFilter>;
  isErr, isRepate: boolean;
  i, iApi, iData, iField, iFilter: integer;
  iDataStep, itempStep: integer;
  //
  lDictApiCodes: TDictionary<string, boolean>;
  lDictDatas: TDictionary<string, TFastApiData>;
  //
  lObjList: TList<TObject>;
  lIntApiList, lIntDataList, lIntList: TList<integer>;
begin
  Result := false;
  QErrMsg := '';
  isErr := false;
  isRepate := false;

  lApiList := nil;
  lApiDatas := nil;
  lApiFields := nil;
  lApiFilters := nil;
  lFastApi := nil;
  lDictApiCodes := nil;
  lDictDatas := TDictionary<string, TFastApiData>.Create;
  lObjList := TList<TObject>.Create;
  lIntApiList := TList<integer>.Create;;
  lIntDataList := TList<integer>.Create;
  lIntList := TList<integer>.Create;
  TMonitor.Enter(self.FLockObj);
  try
    for lApiInfo in self.FApiInfos.Values do
    begin
      lApiInfo.Free;
    end;
    self.FApiInfos.clear;
    // 查询模块信息
    lOrmApi := TOneOrm<TFastApi>.Start();
    lApiList := lOrmApi.ZTCode(self.FZTCode).Query('select * from onefast_api order by FApiID', []).ToList();
    if lApiList.Count = 0 then
      exit;

    lDictApiCodes := TDictionary<string, boolean>.Create;
    for iApi := lApiList.Count - 1 downto 0 do
    begin
      lFastApi := lApiList[iApi];
      if (lFastApi.FApiCode = '') or (lFastApi.FIsMenu) then
      begin
        lFastApi.Free;
        lApiList.Delete(iApi);
        continue;
      end;
      if lDictApiCodes.ContainsKey(lFastApi.FApiCode.ToLower) then
      begin
        isErr := true;
        QErrMsg := '接口代码配置[' + lFastApi.FApiCode + ']重复,请联系管理员修正';
        exit;
      end;
      lDictApiCodes.Add(lFastApi.FApiCode.ToLower, true);
    end;
    if lApiList.Count = 0 then
      exit;

    lOrmData := TOneOrm<TFastApiData>.Start();
    lOrmField := TOneOrm<TFastApiField>.Start();
    lOrmFilter := TOneOrm<TFastApiFilter>.Start();
    try
      lApiDatas := lOrmData.ZTCode(self.FZTCode).Query('select * from onefast_api_data order by FApiID, FTreeCode Asc ', []).ToList();
      lApiFields := lOrmField.ZTCode(self.FZTCode).Query('select * from onefast_api_field order by FApiID,FDataID,FOrderNumber Asc ', []).ToList();
      lApiFilters := lOrmFilter.ZTCode(self.FZTCode).Query('select * from onefast_api_filter order by FApiID,FDataID,FOrderNumber Asc ', []).ToList();
    except
      on e: Exception do
      begin
        isErr := true;
        QErrMsg := e.Message;
        exit;
      end;
    end;
    // 数据集组装
    for iApi := 0 to lApiList.Count - 1 do
    begin
      lFastApi := lApiList[iApi];
      lApiInfo := TFastApiInfo.Create;
      lApiInfo.fastApi := lFastApi;
      lIntApiList.Add(iApi);
      lObjList.Add(lFastApi);
      self.FApiInfos.Add(lFastApi.FApiCode, lApiInfo);
      // 增加数据集关联
      iDataStep := 0;
      lDictDatas.clear;
      lIntDataList.clear;
      for iData := 0 to lApiDatas.Count - 1 do
      begin
        lData := lApiDatas[iData];
        if lData.FApiID <> lFastApi.FApiID then
        begin
          if iDataStep = 1 then
          begin
            // 减少不必要的循环,因为是按FModuleID排序,，一样后有不一样,说明已经完成了本模块的循环
            break;
          end
          else
          begin
            continue;
          end;
        end;
        iDataStep := 1;
        if lDictDatas.TryGetValue(lData.FPDataID, lPData) then
        begin
          lPData.ChildDatas.Add(lData);
        end
        else
        begin
          lApiInfo.fastDatas.Add(lData);
        end;
        lObjList.Add(lData);
        lIntDataList.Add(iData);
        lDictDatas.Add(lData.FDataID, lData);
        // 增加字段
        itempStep := 0;
        lIntList.clear;
        for iField := 0 to lApiFields.Count - 1 do
        begin
          lField := lApiFields[iField];
          if lField.FDataID = lData.FDataID then
          begin
            itempStep := 1;
            lData.ChildFields.Add(lField);
            lObjList.Add(lField);
            lIntList.Add(iField);
          end
          else
          begin
            if itempStep = 1 then
            begin
              break;
            end;
          end;
        end;
        // 删除已使用的字段
        for iField := lIntList.Count - 1 downto 0 do
        begin
          lApiFields.Delete(lIntList[iField]);
        end;

        // 增加条件
        itempStep := 0;
        lIntList.clear;
        for iFilter := 0 to lApiFilters.Count - 1 do
        begin
          lFilter := lApiFilters[iFilter];
          if lFilter.FDataID = lData.FDataID then
          begin
            itempStep := 1;
            lData.ChildFilters.Add(lFilter);
            lObjList.Add(lFilter);
            lIntList.Add(iFilter);
          end
          else
          begin
            if itempStep = 1 then
            begin
              break;
            end;
          end;
        end;
        // 删除已使用的条件
        for iFilter := lIntList.Count - 1 downto 0 do
        begin
          lApiFilters.Delete(lIntList[iFilter]);
        end;

      end;
      // 删除已使用的数据集
      for iData := lIntDataList.Count - 1 downto 0 do
      begin
        lApiDatas.Delete(lIntDataList[iData]);
      end;
    end;

    for iApi := lIntApiList.Count - 1 downto 0 do
    begin
      lApiList.Delete(lIntApiList[iApi]);
    end;

    Result := true;
  finally
    TMonitor.exit(self.FLockObj);
    if lDictApiCodes <> nil then
    begin
      lDictApiCodes.clear;
      lDictApiCodes.Free;
    end;
    if lDictDatas <> nil then
    begin
      lDictDatas.clear;
      lDictDatas.Free;
    end;

    if lApiList <> nil then
    begin
      for i := 0 to lApiList.Count - 1 do
      begin
        lApiList[i].Free;
      end;
      lApiList.clear;
      lApiList.Free;
    end;
    if lApiDatas <> nil then
    begin
      for i := 0 to lApiDatas.Count - 1 do
      begin
        lApiDatas[i].Free;
      end;
      lApiDatas.clear;
      lApiDatas.Free;
    end;

    if lApiFields <> nil then
    begin
      for i := 0 to lApiFields.Count - 1 do
      begin
        lApiFields[i].Free;
      end;
      lApiFields.clear;
      lApiFields.Free;
    end;

    if lApiFilters <> nil then
    begin
      for i := 0 to lApiFilters.Count - 1 do
      begin
        lApiFilters[i].Free;
      end;
      lApiFilters.clear;
      lApiFilters.Free;
    end;
    if (isErr) or (isRepate) then
    begin
      for i := 0 to lObjList.Count - 1 do
      begin
        lObjList[i].Free;
      end;
    end;
    lObjList.clear;
    lObjList.Free;
    lIntApiList.clear;
    lIntApiList.Free;
    lIntList.clear;
    lIntList.Free;
    lIntDataList.clear;
    lIntDataList.Free;
  end;
end;

initialization

finalization

if Unit_FastApiManage <> nil then
  Unit_FastApiManage.Free;

end.

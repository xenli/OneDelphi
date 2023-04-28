unit OneFastLshManage;

interface

uses
  system.Generics.Collections, system.SysUtils, system.Classes, system.StrUtils, system.DateUtils;

type
  TFastLshSet = class;
  TFastLshHis = class;

  TFastLshSet = class
  private
    FLshID_: string;
    FLshCode_: string;
    FLshCaption_: string;
    FLshHead_: string;
    FLshDateFormat_: string;
    FLshNoLength_: integer;
    FIsEnabled_: boolean;
  published
    property FLshID: string read FLshID_ write FLshID_;
    property FLshCode: string read FLshCode_ write FLshCode_;
    property FLshCaption: string read FLshCaption_ write FLshCaption_;
    property FLshHead: string read FLshHead_ write FLshHead_;
    property FLshDateFormat: string read FLshDateFormat_ write FLshDateFormat_;
    property FLshNoLength: integer read FLshNoLength_ write FLshNoLength_;
    property FIsEnabled: boolean read FIsEnabled_ write FIsEnabled_;
  end;

  TFastLshHis = class
  private
    FHisID_: string;
    FLshCode_: string;
    FLshYear_: integer;
    FLshMonth_: integer;
    FLshDay_: integer;
    FLshMax_: integer;
    FUpdateTime_: TDateTime;
  published
    property FHisID: string read FHisID_ write FHisID_;
    property FLshCode: string read FLshCode_ write FLshCode_;
    property FLshYear: integer read FLshYear_ write FLshYear_;
    property FLshMonth: integer read FLshMonth_ write FLshMonth_;
    property FLshDay: integer read FLshDay_ write FLshDay_;
    property FLshMax: integer read FLshMax_ write FLshMax_;
    property FUpdateTime: TDateTime read FUpdateTime_ write FUpdateTime_;
  end;

  TFastLshMange = class(TObject)
  private
    FZTCode: string;
    FLshSetDict: TDictionary<string, TFastLshSet>;
    FLshHisDict: TDictionary<string, TFastLshHis>;
  private
    function GetLshHisLast(QLshSet: TFastLshSet; QNow: TDateTime; var QErrMsg: string): TFastLshHis;
    function UpdateLsh(QLshHis: TFastLshHis; QNewMax: integer; var QErrMsg: string): boolean;
  public
    constructor Create(QZTCode: string = '');
    destructor Destroy; override;
  public
    // 批量获取流水号
    function RefreshLshSet(Var QErrMsg: string): boolean;
    function GetLsh(QLshCode: string; Var QErrMsg: string): string;
    function GetLshList(QLshCode: string; QStepInt: integer; Var QErrMsg: string): TList<string>;
  end;

function UnitFastLshMange(): TFastLshMange;

implementation

uses OneOrm, OneGUID;

var
  Unit_LshMange: TFastLshMange = nil;

function UnitFastLshMange(): TFastLshMange;
var
  lErrMsg: string;
begin
  if Unit_LshMange = nil then
  begin
    Unit_LshMange := TFastLshMange.Create;
    if not Unit_LshMange.RefreshLshSet(lErrMsg) then
    begin

    end;
  end;
  Result := Unit_LshMange;
end;

constructor TFastLshMange.Create(QZTCode: string = '');
begin
  inherited Create;
  FLshSetDict := TDictionary<string, TFastLshSet>.Create;
  FLshHisDict := TDictionary<string, TFastLshHis>.Create;
  self.FZTCode := QZTCode;
end;

destructor TFastLshMange.Destroy;
var
  lSet: TFastLshSet;
  lHis: TFastLshHis;
begin
  for lSet in FLshSetDict.Values do
  begin
    lSet.Free;
  end;
  FLshSetDict.Clear;
  FLshSetDict.Free;

  for lHis in FLshHisDict.Values do
  begin
    lHis.Free;
  end;
  FLshHisDict.Clear;
  FLshHisDict.Free;
  inherited Destroy;
end;

function TFastLshMange.RefreshLshSet(Var QErrMsg: string): boolean;
var
  lSet: TFastLshSet;
  lOrmLshSet: IOneOrm<TFastLshSet>;
  lLshSetList: TList<TFastLshSet>;
  i: integer;
  lLshCode: string;
begin
  Result := false;
  for lSet in FLshSetDict.Values do
  begin
    lSet.Free;
  end;
  FLshSetDict.Clear;
  // 处理
  lLshSetList := nil;
  lOrmLshSet := TOneOrm<TFastLshSet>.Start();
  lLshSetList := lOrmLshSet.ZTCode(self.FZTCode).Query('select * from onefast_lsh_set', []).ToList();
  if lOrmLshSet.IsErr then
  begin
    QErrMsg := lOrmLshSet.ErrMsg;
    exit;
  end;
  if lLshSetList = nil then
  begin
    QErrMsg := '返回的对象 LshSetList=nil';
    exit;
  end;
  try
    for i := lLshSetList.Count - 1 downto 0 do
    begin
      lSet := lLshSetList[i];
      lLshCode := lSet.FLshCode.ToUpper;
      if not FLshSetDict.ContainsKey(lLshCode) then
      begin
        FLshSetDict.Add(lLshCode, lSet);
        lLshSetList.Delete(i);
      end;
    end;
    Result := true;
  finally
    if lLshSetList <> nil then
    begin
      for i := lLshSetList.Count - 1 downto 0 do
      begin
        lLshSetList[i].Free;
      end;
      lLshSetList.Clear;
      lLshSetList.Free;
    end;
  end;
end;

// 获取单个流水号
function TFastLshMange.GetLsh(QLshCode: string; Var QErrMsg: string): string;
var
  lList: TList<string>;
begin
  Result := '';
  QErrMsg := '开始获取流水号';
  lList := nil;
  try
    lList := self.GetLshList(QLshCode, 1, QErrMsg);
    if (lList <> nil) and (lList.Count > 0) then
    begin
      Result := lList[0];
      QErrMsg := '';
    end;
  finally
    if lList <> nil then
      lList.Free;
  end;
end;

// 批量获取多个流水号
function TFastLshMange.GetLshList(QLshCode: string; QStepInt: integer; Var QErrMsg: string): TList<string>;
var
  iStep: integer;
  lSet: TFastLshSet;
  lHis: TFastLshHis;
  lOldMax, lNewMax: integer;
  lLsh, lMaxStr: string;
  //
  lNow: TDateTime;
  lYear, lMonth, lDay: integer;
begin
  //
  Result := nil;
  QErrMsg := '开始获取流水号';
  QLshCode := QLshCode.ToUpper;
  if not FLshSetDict.TryGetValue(QLshCode, lSet) then
  begin
    QErrMsg := '[' + QLshCode + ']配置不存在';
    exit;
  end;
  if not lSet.FIsEnabled then
  begin
    QErrMsg := '[' + QLshCode + ']配置未启用';
    exit;
  end;
  if QStepInt <= 0 then
    QStepInt := 1;
  // 获取His最大值,没有的话 新建一条并插入
  TMonitor.Enter(lSet);
  try
    lNow := now;
    lYear := yearof(lNow);
    lMonth := monthof(lNow);
    lDay := dayOf(lNow);
    if lSet.FLshDateFormat = '按年' then
    begin
      lMonth := 0;
      lDay := 0;
    end
    else if lSet.FLshDateFormat = '按月' then
    begin
      lDay := 0;
    end;

    lHis := nil;
    if FLshHisDict.TryGetValue(QLshCode, lHis) then
    begin
      if (lHis.FLshYear <> lYear) or (lHis.FLshMonth <> lMonth) or (lHis.FLshDay <> lDay) then
      begin
        // 移除,不等于当前日期
        FLshHisDict.Remove(QLshCode);
        lHis.Free;
        lHis := nil;
      end;
    end;
    if lHis = nil then
    begin
      FLshHisDict.Remove(QLshCode);
      // 查询缓存是否有相关配置,没有的话新建一条
      lHis := self.GetLshHisLast(lSet, lNow, QErrMsg);
      if lHis = nil then
        exit;
      FLshHisDict.Add(QLshCode, lHis);
    end;
    // 获取最新流水号最大值,并更新最新流水号最大值至his表,更新成功才代表获取成功
    lOldMax := lHis.FLshMax;
    lNewMax := lHis.FLshMax + QStepInt;
    if not self.UpdateLsh(lHis, lNewMax, QErrMsg) then
    begin
      // 更新失败，移除下一次获取最新的记录信息
      FLshHisDict.Remove(QLshCode);
      lHis.Free;
      lHis := nil;
      exit;
    end;
    if lSet.FLshNoLength <= 0 then
      lSet.FLshNoLength := 4;
    if lSet.FLshNoLength > 20 then
      lSet.FLshNoLength := 20;
    // 设置成最大值
    lHis.FLshMax := lNewMax;
    Result := TList<string>.Create;
    for iStep := 1 to QStepInt do
    begin
      lNewMax := lOldMax + iStep;
      lLsh := '';
      lLsh := lLsh + lSet.FLshHead;
      if lSet.FLshDateFormat = '按年' then
      begin
        lLsh := lLsh + FormatDateTime('yyyy', lNow);
      end
      else if lSet.FLshDateFormat = '按月' then
      begin
        lLsh := lLsh + FormatDateTime('yyyymm', lNow);
      end
      else
      begin
        lLsh := lLsh + FormatDateTime('yyyymmdd', lNow);
      end;
      lMaxStr := lNewMax.ToString;
      while Length(lMaxStr) < lSet.FLshNoLength do
      begin
        lMaxStr := '0' + lMaxStr;
      end;
      lLsh := lLsh + lMaxStr;
      Result.Add(lLsh);
    end;
  finally
    TMonitor.exit(lSet);
  end;
end;

function TFastLshMange.GetLshHisLast(QLshSet: TFastLshSet; QNow: TDateTime; var QErrMsg: string): TFastLshHis;
var
  lYear, lMonth, lDay, i: integer;
  lOrmLshHis: IOneOrm<TFastLshHis>;
  lHisList: TList<TFastLshHis>;
  lHis: TFastLshHis;
  lSQL: string;
  iComit: integer;
  isOK: boolean;
begin
  Result := nil;
  isOK := false;
  QErrMsg := '';
  lYear := yearof(QNow);
  lMonth := monthof(QNow);
  lDay := dayOf(QNow);
  if QLshSet.FLshDateFormat = '按年' then
  begin
    lMonth := 0;
    lDay := 0;
  end
  else if QLshSet.FLshDateFormat = '按月' then
  begin
    lDay := 0;
  end;
  lHisList := nil;
  lHis := nil;
  try
    lSQL := 'select * from onefast_lsh_his where FLshCode=:FLshCode ' +
      ' and FLshYear=:FLshYear and FLshMonth=:FLshMonth and FLshDay=:FLshDay ';
    lOrmLshHis := TOneOrm<TFastLshHis>.Start();
    lHisList := lOrmLshHis.ZTCode(self.FZTCode).Query(lSQL, [QLshSet.FLshCode, lYear, lMonth, lDay]).ToList();
    if lOrmLshHis.IsErr then
    begin
      QErrMsg := lOrmLshHis.ErrMsg;
      exit;
    end;
    if lHisList = nil then
    begin
      QErrMsg := '返回的对象 HistList=nil';
      exit;
    end;

    if lHisList.Count = 0 then
    begin
      // 新建一条并插入到数据库
      lHis := TFastLshHis.Create;
      lHis.FHisID := OneGUID.GetGUID32;
      lHis.FLshCode := QLshSet.FLshCode;
      lHis.FLshYear := lYear;
      lHis.FLshMonth := lMonth;
      lHis.FLshDay := lDay;
      lHis.FLshMax := 0;
      lHis.FUpdateTime := QNow;
      iComit := 0;
      iComit := lOrmLshHis.InitOrm().ZTCode(self.FZTCode).SetTableName('onefast_lsh_his').SetPrimaryKey('FHisID')
        .Inserter(lHis).toCmd().ToExecCommand();
      if lOrmLshHis.IsErr then
      begin
        QErrMsg := lOrmLshHis.ErrMsg;
        exit;
      end;
      if iComit <> 1 then
      begin
        QErrMsg := '插入流水号历史表失败,影响行数不为1,当前影响行数' + iComit.ToString;
        exit;
      end;
      Result := lHis;
      isOK := true;
    end
    else if lHisList.Count = 1 then
    begin
      Result := lHisList[0];
      lHisList.Delete(0);
      isOK := true;
    end
    else
    begin
      QErrMsg := '在流水号历史表,当前流水号[' + QLshSet.FLshCode + ']' + QLshSet.FLshDateFormat + ',标识' +
        '年[' + lYear.ToString + ']月[' + lMonth.ToString + ']日[' + lDay.ToString + ']数据重在重复';
      exit;
    end;

  finally
    if lHisList <> nil then
    begin
      for i := 0 to lHisList.Count - 1 do
      begin
        lHisList[i].Free;
      end;
      lHisList.Clear;
      lHisList.Free;
    end;
    if not isOK then
    begin
      if lHis <> nil then
        lHis.Free;
    end;
  end;
end;

function TFastLshMange.UpdateLsh(QLshHis: TFastLshHis; QNewMax: integer; var QErrMsg: string): boolean;
var
  lOrmLshHis: IOneOrm<TFastLshHis>;
  iComit: integer;
  lSQL: string;
begin
  // 更新
  Result := false;
  QErrMsg := '';
  QLshHis.FUpdateTime := now;
  lSQL := ' update onefast_lsh_his set FLshMax=:FLshMax,FUpdateTime=:FUpdateTime ' +
    ' where FHisID=:FHisID and FLshMax=:FOldLshMax ';
  lOrmLshHis := TOneOrm<TFastLshHis>.Start();
  // 必需有一条受影响
  iComit := lOrmLshHis.ZTCode(self.FZTCode).SetAffectedMustCount(1)
    .ExecSQL(lSQL, [QNewMax, QLshHis.FUpdateTime, QLshHis.FHisID, QLshHis.FLshMax]).ToExecCommand();
  if lOrmLshHis.IsErr then
  begin
    QErrMsg := lOrmLshHis.ErrMsg;
    exit;
  end;
  if iComit <> 1 then
  begin
    QErrMsg := '受影响行数不为1，更新失败';
    exit;
  end;
  Result := true;
end;

initialization

finalization

if Unit_LshMange <> nil then
  Unit_LshMange.Free;

end.

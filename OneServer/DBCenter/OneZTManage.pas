unit OneZTManage;

// 账套管理
{ http://docwiki.embarcadero.com/RADStudio/Berlin/en/Caching_Updates_(FireDAC) }
interface

uses
  FireDAC.Comp.Client, FireDAC.Stan.Param, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.DApt, FireDAC.Stan.Async, FireDAC.Comp.Script, FireDAC.Stan.Option,
  FireDAC.Stan.StorageBin, FireDAC.Stan.StorageXML, FireDAC.Stan.StorageJSON,
  FireDAC.Phys.MySQLDef, FireDAC.Phys.MySQL, FireDAC.Phys.OracleDef,
  FireDAC.Phys.Oracle, FireDAC.Phys.MSSQLDef, FireDAC.Phys.ODBCBase,
  FireDAC.Phys.MSSQL, FireDAC.Phys, FireDAC.Comp.UI, FireDAC.Stan.Intf,
  FireDAC.Phys.MySQLCli, FireDAC.Phys.MySQLWrapper, FireDAC.DatS,
  FireDAC.Stan.Error, FireDAC.Comp.DataSet, FireDAC.Comp.ScriptCommands,
  System.Generics.Collections, System.SyncObjs, Data.DB, System.SysUtils,
  System.Classes, System.StrUtils, System.Variants, System.NetEncoding,
  FireDAC.Phys.PG, System.Diagnostics,
  System.JSON, System.Zip, FireDAC.Phys.FB, FireDAC.Phys.SQLite,
  FireDAC.Phys.ASA, FireDAC.Phys.ODBCDef, FireDAC.Phys.ODBC, System.TypInfo,
  FireDAC.Phys.MSAccDef, FireDAC.Phys.MSAcc, FireDAC.Stan.ExprFuncs,
{$IF CompilerVersion >= 35}FireDAC.Phys.SQLiteWrapper.Stat, {$ENDIF}
  FireDAC.Phys.SQLiteDef, OneDataInfo,
  OneThread, OneGUID, OneFileHelper, System.Threading, OneNeonHelper,
  OneStreamString, OneILog, System.DateUtils, System.IOUtils;

type
  TOneZTSet = class;
  TOneZTMangeSet = class;
  TOneZTItem = class;
  TOneZTPool = class;
  TOneFDException = class;
  emZTKeepMode = (keepTran, keepTempData);

  TOneFDException = class(EFDException)
  public
    FErrmsg: string;
  end;

  TZTKeepInfo = class
  private
    FKeepID: string;
    FKeepMode: emZTKeepMode;
    FKeepSec: integer;
    FLastTime: TDateTime;
  end;

  // 账套配置
  TOneZTSet = class
  private
    FZTCode: string; // 账套代码
    FZTCaption: string; // 账套标签
    FInitPoolCount: integer; // 初始化账套池数量
    FMaxPoolCount: integer; // 最大账套池数量
    FPoolAuto: boolean;
    FPhyDriver: string; // 驱动类型
    FConnectionStr: string; // 连接字符串
    FIsEnable: boolean; // 是否启用
    FIsMain: boolean; // 默认主账套
  public
    property ZTCode: string read FZTCode write FZTCode;
    property ZTCaption: string read FZTCaption write FZTCaption;
    property InitPoolCount: integer read FInitPoolCount write FInitPoolCount;
    property MaxPoolCount: integer read FMaxPoolCount write FMaxPoolCount;
    property PoolAuto: boolean read FPoolAuto write FPoolAuto;
    property PhyDriver: string read FPhyDriver write FPhyDriver;
    property ConnectionStr: string read FConnectionStr write FConnectionStr;
    property IsEnable: boolean read FIsEnable write FIsEnable;
    property IsMain: boolean read FIsMain write FIsMain;
  end;

  TOneZTMangeSet = class
  private
    FAutoWork: boolean;
    FZTSetList: TList<TOneZTSet>;
  public
    constructor Create();
    destructor Destroy; override;
  public
    property AutoWork: boolean read FAutoWork write FAutoWork;
    property ZTSetList: TList<TOneZTSet> read FZTSetList write FZTSetList;
  end;

  { 一个连接 }
  TOneZTItem = class(TObject)
  private
    FCreateID: string; // 每个一个编号
    //
    FOwnerZTPool: TOneZTPool;
    FIsWorking: boolean; // 正在工作中
    // FD套件,每个连接创建多有这几个，拿来就用，省去创建的过程
    FDConnection: TFDConnection;
    FDTransaction: TFDTransaction;
    FDQuery: TFDQuery;
    FDScript: TFDScript;
    FDStoredProc: TFDStoredProc;
    // 临时保存流的地方
    FTempStream: TMemoryStream;
    FException: TOneFDException;
    //
    FCharacterSet: String;
    // 二层一样控由客户端控制事务
    FCustTran: boolean;
    // 锁定最长时间,毫秒为单位
    // -1无限长,客户端调起释放才释放，如果事务还在执行中
    // 0 代表事务不得超过30分钟，如果30分钟还没事务完成,服务端回滚事务
    // >0  代表事务不得超过>0分钟，如果>0分钟还没事务完成,服务端回滚事务
    FCustTranMaxSpanSec: integer;
    // 最后交互时间
    FLastTime: TDateTime;
    // 不工作时释放
    FUnLockFree: boolean;
  private
    // 单纯获取一个连接 FDConnection
    function GetADConnection: TFDConnection;
    // 获取一个事务连接 FDTransaction其中connection已绑定 FDConnection
    function GetADTransaction: TFDTransaction;
    // 获取一个Query查询 其中connection已绑定 FDConnection
    function GetQuery: TFDQuery;
    // 获取一个Script角本执行 其中connection已绑定 FDConnection
    function GetScript: TFDScript;
    // 获取一个Stored存储过程执行器 其中connection已绑定 FDConnection
    function GetStoredProc: TFDStoredProc;
    function GetTempStream: TMemoryStream;
    procedure FDQueryError(ASender, AInitiator: TObject; var AException: Exception);
    procedure FDScriptError(ASender, AInitiator: TObject; var AException: Exception);
  public
    constructor Create(AOwner: TOneZTPool; QPhyDriver: string; QConnectionString: string); overload;
    destructor Destroy; override;
    procedure UnLockWork();
    function CreateNewQuery(QIsOpenData: boolean = false): TFDQuery;
  Public
    property ADConnection: TFDConnection read FDConnection;
    property ADTransaction: TFDTransaction read GetADTransaction;
    property ADQuery: TFDQuery read GetQuery;
    Property ADScript: TFDScript read GetScript;
    Property ADStoredProc: TFDStoredProc read GetStoredProc;
    Property IsWorking: boolean read FIsWorking write FIsWorking;
    property DataStream: TMemoryStream read GetTempStream;
    property FDException: TOneFDException read FException;
  end;

  { 一个账套池 }
  TOneZTPool = class(TObject)
  private
    FZTCode: string; // 账套代码
    FInitPoolCount: integer; // 初如化池数量
    FMaxPoolCount: integer; // 最大池数量
    FPoolCreateCount: integer; // 已创建池数量
    FPoolWorkCount: integer; // 正在工作的数量
    FPoolAuto: boolean;
    FPhyDriver: string; // 数据库驱动
    FConnectionStr: string; // 数据库连接
    FStop: boolean; // 停止运作
    FLockObj: TObject; // 锁
    FZTItems: TList<TOneZTItem>; // 账套池
  private

  public
    // 创建一个池
    constructor Create(QZTSet: TOneZTSet); overload;
    destructor Destroy; override;
    // 从池中锁定一个账套出来
    function LockZTItem(var QErrMsg: string): TOneZTItem;
    procedure UnLockWorkCount();
  public

  public
    property Stop: boolean read FStop write FStop;
    property ZTCode: string read FZTCode write FZTCode;
    property InitPoolCount: integer read FInitPoolCount; // 初如化池数量
    property MaxPoolCount: integer read FMaxPoolCount; // 最大池数量
    property PoolCreateCount: integer read FPoolCreateCount; // 已创建池数量
    property PoolWorkCount: integer read FPoolWorkCount; // 正在工作的数量
  end;

  { 账套管理-采用hase管理 }
type
  TOneZTManage = class(TObject)
  private
    FZTMain: string;
    FStop: boolean;
    FZTPools: TDictionary<String, TOneZTPool>;
    FTranZTItemList: TDictionary<String, TOneZTItem>;
    FFileDataDict: TDictionary<String, TDateTime>;
    FLockObject: TObject;
    FLog: IOneLog;
    FKeepList: TList<TZTKeepInfo>;
    // 在事务太久的,自动最还连接
    FTimerThread: TOneTimerThread;
  private
    procedure onTimerWork(Sender: TObject);
  public
    constructor Create(QOneLog: IOneLog); overload;
    destructor Destroy; override;
    function StarWork(QZTSetList: TList<TOneZTSet>; var QErrMsg: string): boolean;
  public
    // 某个账套停止工作
    function StopZT(QZTCode: string; QStop: boolean; Var QErrMsg: string): boolean;
    // 获取一个账套
    function LockZTItem(QZTCode: string; var QErrMsg: string): TOneZTItem;
    // ************ 对接客户端的事务,有点像二层事务,一般很少用,额外福利***********//
    // 锁定一个账套,由客户端自由控制
    function LockTranItem(QZTCode: string; QMaxSpanSec: integer; var QErrMsg: string): string;
    // 归还一个账套,由客户端自由控制
    function UnLockTranItem(QTranID: string; var QErrMsg: string): boolean;
    // 账套开启事务,由客户端自由控制
    function StartTranItem(QTranID: string; var QErrMsg: string): boolean;
    // 账套提交事务,由客户端自由控制
    function CommitTranItem(QTranID: string; var QErrMsg: string): boolean;
    // 账套回滚事务,由客户端自由控制
    function RollbackTranItem(QTranID: string; var QErrMsg: string): boolean;
    // 获取客户自由管理的账套
    function GetTranItem(QTranID: string; var QErrMsg: string): TOneZTItem;
    // 跟据账套代码创建账套池
    // **********************************************//
    function InitZTPool(QZTSet: TOneZTSet; var QErrMsg: string): boolean;
    function HaveZT(QZTCode: string): boolean;
  public
    function GetZTMain: string;
    // 打开数据
    function OpenData(QOpenData: TOneDataOpen; QOneDataResult: TOneDataResult): boolean; overload;
    // IsServer是不是服务端自已发起的请求
    function OpenDatas(QOpenDatas: TList<TOneDataOpen>; var QOneDataResult: TOneDataResult): boolean;
    // 保存数据
    function SaveDatas(QSaveDMLDatas: TList<TOneDataSaveDML>; var QOneDataResult: TOneDataResult): boolean;
    // 执行存储过程
    function ExecStored(QOpenData: TOneDataOpen; var QOneDataResult: TOneDataResult): boolean;

    // 执行SQL脚本语句
    function ExecScript(QOpenData: TOneDataOpen; var QErrMsg: string): boolean;

    // 获取数据库相关信息
    function GetDBMetaInfo(QDBMetaInfo: TOneDBMetaInfo; var QOneDataResult: TOneDataResult): boolean;
  public
    // 主要提供给Orm用的
    function OpenData(QOpenData: TOneDataOpen; QParams: array of Variant; var QErrMsg: string): TFDMemtable; overload;
    function ExecSQL(QDataSaveDML: TOneDataSaveDML; QParams: array of Variant; var QErrMsg: string): integer;
  public
    property ZTMain: string read FZTMain write FZTMain;
    property ZTPools: TDictionary<String, TOneZTPool> read FZTPools write FZTPools;
  end;

  // 去 Order by SQL
function ClearOrderBySQL(QSQL: string): string;
// 初始化驱动
procedure InitPhyDriver;

var
  Var_ADOZTMgr: TOneZTManage;
  // 驱动加载
  Var_MSSQLDriverLink: TFDPhysMSSQLDriverLink = nil;
  Var_2000MSSQLDriverLink: TFDPhysMSSQLDriverLink = nil;
  Var_MySQLDriverLink: TFDPhysMySQLDriverLink = nil;
  Var_OracleDriverLink: TFDPhysOracleDriverLink = nil;
  var_PGDriverLink: TFDPhysPgDriverLink = nil;
  var_FireBirdDriverLinK: TFDPhysFBDriverLink = nil;
  var_FireBirdDriverLinKB: TFDPhysFBDriverLink = nil;
  var_SQLiteDriverLinK: TFDPhysSQLiteDriverLink = nil;
  var_ASADriverLink: TFDPhysASADriverLink = nil;
  var_ODBCDriverLink: TFDPhysODBCDriverLink = nil;
  var_MSAccDriverLink: TFDPhysMSAccessDriverLink = nil;

var
  // OneGlobal初始化时赋值,其它单元可以速用
  Unit_ZTManage: TOneZTManage = nil;

implementation

uses OneGlobal;

constructor TOneZTMangeSet.Create();
begin
  inherited Create;
  FZTSetList := TList<TOneZTSet>.Create;
end;

destructor TOneZTMangeSet.Destroy;
var
  i: integer;
begin
  for i := 0 to FZTSetList.Count - 1 do
  begin
    FZTSetList[i].Free;
  end;
  FZTSetList.Clear;
  FZTSetList.Free;
  inherited Destroy;
end;
{$REGION 'TOneZTItem'}


constructor TOneZTItem.Create(AOwner: TOneZTPool; QPhyDriver: string; QConnectionString: string);
begin
  inherited Create;
  FCreateID := OneGUID.GetGUID32();
  self.FCustTran := false;
  self.FLastTime := Now;
  self.FOwnerZTPool := AOwner;
  self.FUnLockFree := false;
  { 数据库才有这些 }
  FDConnection := TFDConnection.Create(nil);
  FDConnection.LoginPrompt := false;
  FDConnection.ConnectionString := QConnectionString;
  // 解析是什么编码
  FCharacterSet := FDConnection.Params.Values['CharacterSet'];
  FCharacterSet := FCharacterSet.ToLower;

  FDConnection.DriverName := QPhyDriver;
  FDConnection.ResourceOptions.AutoReconnect := true;
  FDConnection.ResourceOptions.KeepConnection := true;
  // 当着特定整型用 number(5,0)--至number(10,0),oracle ，pg多有
  FDConnection.FormatOptions.MapRules.Add(5, 10, 0, 0, dtBCD, dtInt32);
  // FDConnection.FormatOptions.MapRules.Add(0, 0, 0, 0, dtDateTime, dtDateTimeStamp);
  if QPhyDriver.StartsWith('Ora') then
    FDConnection.FormatOptions.MapRules.Add(1, 1, 0, 0, dtBCD, dtBoolean);
  //
  FDTransaction := TFDTransaction.Create(nil);

  FDQuery := TFDQuery.Create(nil);
  FDQuery.FetchOptions.Mode := TFDFetchMode.fmall;
  // FDQuery.FetchOptions.RecordCountMode := TFDRecordCountMode.cmTotal;
  FDQuery.CachedUpdates := true;
  FDQuery.FetchOptions.AutoClose := false; // 返回多个数据集要设成false
  FDQuery.FetchOptions.Unidirectional := false;
  FDQuery.UpdateOptions.UpdateMode := TUpdateMode.upWhereKeyOnly;
  FDQuery.ResourceOptions.MacroCreate := false;
  FDQuery.ResourceOptions.MacroExpand := false;
  FDQuery.FormatOptions.StrsTrim2Len := true;
  // 错误绑定
  FDQuery.OnError := FDQueryError;
  FDScript := TFDScript.Create(nil);
  FDScript.OnError := FDQueryError;
  FDStoredProc := TFDStoredProc.Create(nil);
  // fiMeta 不保存存储过程结构每次多是重新获取
  // 设成false可以返回多个数据集,但参数返回不了,默认true只能返回一个数据集
  FDStoredProc.FetchOptions.AutoClose := false; // 返回多个数据集要设成false
  FDStoredProc.FetchOptions.Mode := TFDFetchMode.fmall;
  FDStoredProc.FetchOptions.Cache := FDStoredProc.FetchOptions.Cache - [fiMeta];
  FDStoredProc.ResourceOptions.EscapeExpand := false;
  FDStoredProc.ResourceOptions.MacroCreate := false;
  FDStoredProc.ResourceOptions.MacroExpand := false;
  FDStoredProc.OnError := FDQueryError;
  // FDStoredProc.FetchOptions.Items := [fiBlobs,fiDetails,fiMeta];
  FTempStream := TMemoryStream.Create;

  FException := TOneFDException.Create;
  FException.FDCode := -1;

end;

destructor TOneZTItem.Destroy;
begin
  FOwnerZTPool := nil;
  if FDTransaction <> nil then
    FDTransaction.Free;
  if FDQuery <> nil then
    FDQuery.Free;
  if FDScript <> nil then
    FDScript.Free;
  if FDStoredProc <> nil then
    FDStoredProc.Free;
  if FDConnection <> nil then
  begin
    FDConnection.Close;
    FDConnection.Free;
  end;
  if FTempStream <> nil then
  begin
    FTempStream.Clear;
    FTempStream.Free;
  end;
  FException.Free;
  inherited Destroy;
end;

function TOneZTItem.GetADConnection: TFDConnection;
begin
  Result := nil;
  if not FDConnection.Connected then
    FDConnection.Connected := true;
  if FDConnection.Connected then
    Result := FDConnection;
end;

function TOneZTItem.GetADTransaction: TFDTransaction;
begin
  Result := FDTransaction;
  FDTransaction.Connection := FDConnection;
end;

function TOneZTItem.GetQuery: TFDQuery;
begin
  Result := FDQuery;
  if FDQuery.Active then
  begin
    FDQuery.Close;
  end;
  FDQuery.SQL.Clear;
  FDQuery.Params.Clear;
  FDQuery.UpdateOptions.UpdateTableName := '';
  FDQuery.UpdateOptions.KeyFields := '';
  FDQuery.FetchOptions.RecsSkip := -1;
  FDQuery.FetchOptions.RecsMax := -1;
  FDQuery.FetchOptions.Mode := TFDFetchMode.fmall;
  FDQuery.UpdateOptions.UpdateMode := TUpdateMode.upWhereKeyOnly;
  FDQuery.Connection := FDConnection;
end;

function TOneZTItem.CreateNewQuery(QIsOpenData: boolean = false): TFDQuery;
begin
  Result := TFDQuery.Create(nil);
  Result.CachedUpdates := true;
  Result.FetchOptions.RecsSkip := -1;
  Result.FetchOptions.RecsMax := -1;
  Result.FetchOptions.Mode := TFDFetchMode.fmall;
  Result.UpdateOptions.UpdateMode := TUpdateMode.upWhereKeyOnly;
  Result.FetchOptions.AutoClose := false; // 返回多个数据集要设成false
  Result.FetchOptions.Unidirectional := false;
  Result.ResourceOptions.MacroCreate := false;
  Result.ResourceOptions.MacroExpand := false;
  Result.FormatOptions.StrsTrim2Len := true;
  if QIsOpenData then
  begin
    Result.UpdateOptions.EnableDelete := false;
    Result.UpdateOptions.EnableInsert := false;
    Result.UpdateOptions.EnableUpdate := false;
  end;
  Result.Connection := FDConnection;
end;

function TOneZTItem.GetScript: TFDScript;
begin
  Result := nil;
  if not FDScript.Finished then
    FDScript.AbortJob(false);
  FDScript.SQLScripts.Clear;
  FDScript.Connection := FDConnection;
  Result := FDScript;
end;

function TOneZTItem.GetStoredProc: TFDStoredProc;
begin
  Result := nil;
  if (FDStoredProc <> nil) then
  begin
    FDStoredProc.Free;
    FDStoredProc := nil;
  end;
  // 每次多新建一个
  FDStoredProc := TFDStoredProc.Create(nil);
  FDStoredProc.FetchOptions.AutoClose := false; // 返回多个数据集要设成false
  FDStoredProc.FetchOptions.Mode := TFDFetchMode.fmall;
  FDStoredProc.FetchOptions.Cache := FDStoredProc.FetchOptions.Cache - [fiMeta];
  FDStoredProc.ResourceOptions.EscapeExpand := false;
  FDStoredProc.ResourceOptions.MacroCreate := false;
  FDStoredProc.ResourceOptions.MacroExpand := false;
  FDStoredProc.OnError := FDQueryError;

  if FDStoredProc.Active then
    FDStoredProc.Close;
  FDStoredProc.Params.Clear;
  FDStoredProc.Connection := FDConnection;
  // 如果是取数据,这边要配置下，不然最多50条分页掉了,纠正此BUG
  FDStoredProc.FetchOptions.RecsSkip := -1;
  FDStoredProc.FetchOptions.RecsMax := -1;
  FDStoredProc.FetchOptions.Mode := TFDFetchMode.fmall;
  Result := FDStoredProc;
end;

function TOneZTItem.GetTempStream: TMemoryStream;
begin
  FTempStream.Clear;
  FTempStream.Position := 0;
  Result := FTempStream;
end;

function IsUTF8(const S: string): boolean;
begin
  Result := TEncoding.UTF8.GetByteCount(S) = Length(S);
end;

procedure TOneZTItem.FDQueryError(ASender, AInitiator: TObject; var AException: Exception);
begin
  if (AException <> nil) and (AException.Message <> '') then
  begin
    if IsUTF8(AException.Message) then
      self.FException.FErrmsg := UTF8DeCode(AException.Message)
    else
      self.FException.FErrmsg := AException.Message;
    OneGlobal.TOneGlobal.GetInstance().Log.WriteLog('SQLErr', AException.Message);
    // 有异常直接中断
    abort;
  end;
end;

procedure TOneZTItem.FDScriptError(ASender, AInitiator: TObject; var AException: Exception);
begin

end;

procedure TOneZTItem.UnLockWork();
var
  aTask: ITask;
begin
  // 事务自行控制
  // UnLockTranItem没进行解锁是不释放的
  if self.FCustTran then
    exit;
  if self.FUnLockFree then
  begin
    // 未事务提交,回滚
    if FDConnection.InTransaction then
      FDConnection.Rollback;
    self.FOwnerZTPool.UnLockWorkCount();
    self.Free;
  end
  else
  begin
    // 放在任务里面,大数据时close就非常慢的，比如取了100万条数据
    aTask := TTask.Create(
      procedure
      begin
        self.FDException.FErrmsg := '';
        // 释放时事务没提交,回滚
        if FDConnection.InTransaction then
          FDConnection.Rollback;
        FDTransaction.Connection := nil;
        // 大数据时 FDQuery.Close 是非常久的
        // FDQuery.EmptyDataSet
        if FDQuery.Active then
        begin
          FDQuery.Close;
        end;
        FDQuery.SQL.Clear;
        FDQuery.Params.Clear;

        FDQuery.Connection := nil;
        FDScript.Connection := nil;
        //
        // 自增清空
        FDQuery.UpdateOptions.AutoIncFields := '';
        FDConnection.UpdateOptions.EnableDelete := true;
        FDConnection.UpdateOptions.EnableInsert := true;
        FDConnection.UpdateOptions.EnableUpdate := true;
        //
        if FDStoredProc.Active then
        begin
          FDStoredProc.Close;
        end;
        if FDStoredProc.Params.Count > 0 then
          FDStoredProc.Params.Clear;
        FDStoredProc.Connection := nil;
        if FTempStream <> nil then
        begin
          FTempStream.Position := 0;
          FTempStream.Clear;
        end;
        // 默认1800秒事务锁
        FCustTranMaxSpanSec := 30 * 60;
        FIsWorking := false;
        self.FOwnerZTPool.UnLockWorkCount();
      end);
    aTask.Start;
  end;
end;

{$ENDREGION}
// 一个账磁连接池
{$REGION 'TOneZTPool'}


constructor TOneZTPool.Create(QZTSet: TOneZTSet);
var
  i: integer;
  lZTItem: TOneZTItem;
begin
  inherited Create;
  if QZTSet.InitPoolCount <= 0 then
    QZTSet.InitPoolCount := 5;
  if QZTSet.MaxPoolCount <= 0 then
    QZTSet.MaxPoolCount := 10;
  // self.InitZTPool(lZTSet.ZTCode, lZTSet.PhyDriver,
  // lZTSet.ConnectionStr, lZTSet.InitPoolCount, lZTSet.MaxPoolCount, QErrMsg);
  FZTCode := QZTSet.ZTCode;
  FInitPoolCount := QZTSet.InitPoolCount;
  FMaxPoolCount := QZTSet.MaxPoolCount;
  FPoolAuto := QZTSet.PoolAuto;
  FPoolCreateCount := 0; // 已创建池数量
  FPoolWorkCount := 0;; // 正在工作的数量
  FPhyDriver := QZTSet.PhyDriver;
  FConnectionStr := QZTSet.ConnectionStr;
  self.FZTItems := TList<TOneZTItem>.Create();
  FLockObj := TObject.Create;
  if FConnectionStr <> '' then
  begin
    for i := 0 to FInitPoolCount - 1 do
    begin
      lZTItem := TOneZTItem.Create(self, FPhyDriver, FConnectionStr);
      lZTItem.FLastTime := Now;
      self.FZTItems.Add(lZTItem);
      self.FPoolCreateCount := self.FPoolCreateCount + 1;
    end;
  end;
end;

destructor TOneZTPool.Destroy;
var
  i: integer;
begin
  if FLockObj <> nil then
    FLockObj.Free;
  if self.FZTItems <> nil then
  begin
    for i := 0 to FZTItems.Count - 1 do
    begin
      FZTItems[i].Free;
    end;
    FZTItems.Clear;
    FZTItems.Free;
  end;
  inherited Destroy;
end;

function TOneZTPool.LockZTItem(var QErrMsg: string): TOneZTItem;
var
  i: integer;
  lZTItem: TOneZTItem;
  isCreateNew: boolean;
begin
  Result := nil;
  lZTItem := nil;
  QErrMsg := '';
  if not TMonitor.TryEnter(self.FLockObj) then
  begin
    QErrMsg := '账套池[' + self.FZTCode + ']获取锁失败!!!';
    exit;
  end;
  isCreateNew := false;
  try
    if self.FPoolWorkCount >= self.FMaxPoolCount then
    begin
      if not self.FPoolAuto then
      begin
        QErrMsg := '账套池[' + self.FZTCode + ']已达到最大工作量[' + FPoolWorkCount.ToString() + ']';
        exit;
      end
      else
      begin
        isCreateNew := true;
      end;
    end;
    if isCreateNew then
    else
    begin
      // 遍历看哪个是空闲的
      for i := 0 to self.FZTItems.Count - 1 do
      begin
        if self.FZTItems[i].IsWorking then
          continue;
        lZTItem := self.FZTItems[i];
        // 找到一个中断
        break;
      end;
    end;
    if lZTItem = nil then
    begin
      // 没找到就开始创建一个新的
      lZTItem := TOneZTItem.Create(self, FPhyDriver, FConnectionStr);
      if isCreateNew then
      begin
        // 不加入池中，新建的服完就释放
        lZTItem.FUnLockFree := true;
      end
      else
      begin
        // 加入到池中
        self.FZTItems.Add(lZTItem);
        self.FPoolCreateCount := self.FPoolCreateCount + 1;
      end;
    end;
    lZTItem.FLastTime := Now;
    // 工作量加1
    lZTItem.IsWorking := true;
    self.FPoolWorkCount := self.FPoolWorkCount + 1;
    Result := lZTItem;
  finally
    TMonitor.exit(self.FLockObj);
  end;
end;

procedure TOneZTPool.UnLockWorkCount();
begin
  TMonitor.Enter(self.FLockObj);
  try
    self.FPoolWorkCount := self.FPoolWorkCount - 1;
  finally
    TMonitor.exit(self.FLockObj);
  end;
end;
{$ENDREGION}
{$REGION 'TOneZTManage'}


constructor TOneZTManage.Create(QOneLog: IOneLog);
begin
  inherited Create;
  self.FLog := QOneLog;
  FZTPools := TDictionary<String, TOneZTPool>.Create;
  FTranZTItemList := TDictionary<String, TOneZTItem>.Create;
  FFileDataDict := TDictionary<String, TDateTime>.Create;
  FLockObject := TObject.Create;
  FKeepList := TList<TZTKeepInfo>.Create;
  FTimerThread := TOneTimerThread.Create(self.onTimerWork);
  // 加载驱动
  InitPhyDriver;
end;

destructor TOneZTManage.Destroy;
var
  i: integer;
  lZTPool: TOneZTPool;
  lZTItem: TOneZTItem;
  lFileName, lFileID: string;
begin
  if FTimerThread <> nil then
    FTimerThread.FreeWork;
  // 二层事务的
  for lZTItem in FTranZTItemList.Values do
  begin
    if lZTItem.ADConnection.InTransaction then
    begin
      // 回滚
      lZTItem.ADConnection.Rollback;
    end;
  end;
  FTranZTItemList.Clear;
  FTranZTItemList.Free;
  // 释放连接池
  for lZTPool in FZTPools.Values do
  begin
    lZTPool.Free;
  end;
  FZTPools.Clear;
  FZTPools.Free;
  try
    // 临时文件删除
    for lFileID in FFileDataDict.Keys do
    begin
      lFileName := OneFileHelper.CombineExeRunPath('OnePlatform\OneDataTemp\' + lFileID + '.data');
      TFile.Delete(lFileName);
    end;
    FFileDataDict.Clear;
    FFileDataDict.Free;
  except

  end;
  FLockObject.Free;
  for i := 0 to FKeepList.Count - 1 do
  begin
    FKeepList[i].Free;
  end;
  FKeepList.Clear;
  FKeepList.Free;
  inherited Destroy;
end;

procedure TOneZTManage.onTimerWork(Sender: TObject);
var
  lZTItem: TOneZTItem;
  lNow: TDateTime;
  lSpanSec: integer;
  //
  lFileName, lFileID: string;
  lFileDateTime: TDateTime;
  tempList: TList<string>;
  iTemp: integer;
begin
  TMonitor.Enter(FLockObject);
  try
    lNow := Now;
    // 二层事务的
    for lZTItem in FTranZTItemList.Values do
    begin
      if lZTItem.FCustTranMaxSpanSec < 0 then
        continue;

      if lZTItem.FCustTranMaxSpanSec = 0 then
      begin
        lZTItem.FCustTranMaxSpanSec := 30 * 60;
      end;
      // 事务到期了,还没操作归还
      if SecondsBetween(lNow, lZTItem.FLastTime) >= lZTItem.FCustTranMaxSpanSec then
      begin
        if lZTItem.ADConnection.InTransaction then
        begin
          // 回滚
          lZTItem.ADConnection.Rollback;
        end;
        lZTItem.FCustTran := false;
        lZTItem.UnLockWork;
        FTranZTItemList.Remove(lZTItem.FCreateID);
      end;
    end;
    tempList := TList<string>.Create;
    try
      for lFileID in FFileDataDict.Keys do
      begin
        if FFileDataDict.TryGetValue(lFileID, lFileDateTime) then
        begin
          // 临时保存文件的地方,10分钟后自动删除,保持硬盘健康
          if SecondsBetween(lNow, lFileDateTime) >= 600 then
          begin
            lFileName := OneFileHelper.CombineExeRunPath('OnePlatform\OneDataTemp\' + lFileID + '.data');
            TFile.Delete(lFileName);
            tempList.Add(lFileID);
          end;
        end;
      end;
      for iTemp := 0 to tempList.Count - 1 do
      begin
        // 删除
        FFileDataDict.Remove(tempList[iTemp]);
      end;
    finally
      tempList.Clear;
      tempList.Free;
    end;

  finally
    TMonitor.exit(FLockObject);
  end;
end;

function TOneZTManage.GetZTMain: string;
begin
  Result := FZTMain;
end;

function TOneZTManage.LockZTItem(QZTCode: string; var QErrMsg: string): TOneZTItem;
var
  lZTPool: TOneZTPool;
BEGIN
  Result := nil;
  QErrMsg := '';
  TMonitor.Enter(FLockObject);
  try
    if FStop then
    begin
      QErrMsg := '账套管理目前状态处于停止工作状态!!!';
      exit;
    end;
    if QZTCode = '' then
    begin
      QZTCode := self.ZTMain;
    end;
    if QZTCode = '' then
    begin
      QErrMsg := '账套代码为空或者请设置一个主账套';
      exit;
    end;
    if FZTPools.TryGetValue(QZTCode.ToUpper, lZTPool) then
    begin
      if lZTPool.Stop then
      begin
        QErrMsg := '账套[' + QZTCode + ']池目前状态处于停止工作状态';
        exit;
      end;
      Result := lZTPool.LockZTItem(QErrMsg);
      if Result = nil then
      begin
        exit;
      end;
    end
    else
    begin
      QErrMsg := '账套管理不存在账套代码[' + QZTCode + ']';
    end;
  finally
    TMonitor.exit(FLockObject);
  end;
  if Result <> nil then
  begin
    if not Result.ADConnection.Connected then
    begin
      // 不是连接状态，连下
      Result.ADConnection.Close;
      Result.ADConnection.Open;
    end
  end;
END;

function TOneZTManage.LockTranItem(QZTCode: string; QMaxSpanSec: integer; var QErrMsg: string): string;
var
  lFireZTPool: TOneZTPool;
  lZTItem: TOneZTItem;
  lStartTranID: string;
begin
  Result := '';
  QErrMsg := '';
  lZTItem := nil;
  lZTItem := self.LockZTItem(QZTCode, QErrMsg);
  if lZTItem = nil then
  begin
    exit;
  end;
  TMonitor.Enter(FLockObject);
  try
    lZTItem.FCustTran := true;
    lZTItem.FCustTranMaxSpanSec := QMaxSpanSec;
    self.FTranZTItemList.Add(lZTItem.FCreateID, lZTItem);
    Result := lZTItem.FCreateID;
  finally
    TMonitor.exit(FLockObject);
  end;
end;

function TOneZTManage.UnLockTranItem(QTranID: string; var QErrMsg: string): boolean;
var
  lZTItem: TOneZTItem;
BEGIN
  Result := false;
  QErrMsg := '';
  TMonitor.Enter(FLockObject);
  try
    if FTranZTItemList.TryGetValue(QTranID, lZTItem) then
    begin
      if lZTItem.ADConnection.InTransaction then
      begin
        lZTItem.ADConnection.Commit;
        lZTItem.FLastTime := Now;
      end;
      lZTItem.FCustTran := false;
      lZTItem.UnLockWork;
      Result := true;
    end
    else
    begin
      QErrMsg := '不存在此事务的账套连接';
      Result := false;
    end;
  finally
    FTranZTItemList.Remove(QTranID);
    TMonitor.exit(FLockObject);
  end;

END;

function TOneZTManage.GetTranItem(QTranID: string; var QErrMsg: string): TOneZTItem;
var
  lZTItem: TOneZTItem;
BEGIN
  Result := nil;
  QErrMsg := '';
  TMonitor.Enter(FLockObject);
  try
    if FTranZTItemList.TryGetValue(QTranID, lZTItem) then
    begin
      Result := lZTItem;
      Result.FLastTime := Now;
    end
    else
    begin
      QErrMsg := '不存在此事务的账套连接';
    end;
  finally
    TMonitor.exit(FLockObject);
  end;
END;

// 此种模式用在客户端开启事务,相当于两层写事务
function TOneZTManage.StartTranItem(QTranID: string; var QErrMsg: string): boolean;
var
  lZTItem: TOneZTItem;
BEGIN
  Result := false;
  QErrMsg := '';
  TMonitor.Enter(FLockObject);
  try
    if FTranZTItemList.TryGetValue(QTranID, lZTItem) then
    begin
      lZTItem.ADConnection.StartTransaction;
      lZTItem.FLastTime := Now;
      Result := true;
    end
    else
    begin
      QErrMsg := '不存在此事务的账套连接';
      Result := false;
    end;
  finally
    TMonitor.exit(FLockObject);
  end;
END;

function TOneZTManage.CommitTranItem(QTranID: string; var QErrMsg: string): boolean;
var
  lZTItem: TOneZTItem;
begin
  Result := false;
  QErrMsg := '提交事务开始';
  if self.FTranZTItemList.TryGetValue(QTranID, lZTItem) then
  begin
    try
      if lZTItem.ADConnection.InTransaction then
      begin
        lZTItem.ADConnection.Commit;
        lZTItem.FLastTime := Now;
        Result := true;
      end
      else
      begin
        Result := true;
      end;
    except
      on e: Exception do
      begin
        QErrMsg := '事务异常,原因:' + e.Message;
      end;
    end;
  end
  else
  begin
    QErrMsg := '此事务已经不存在';
  end;
end;

function TOneZTManage.RollbackTranItem(QTranID: string; var QErrMsg: string): boolean;
var
  lZTItem: TOneZTItem;
begin
  Result := false;
  QErrMsg := '回滚事务开始';
  if self.FTranZTItemList.TryGetValue(QTranID, lZTItem) then
  begin
    try
      if lZTItem.ADConnection.InTransaction then
      begin
        lZTItem.ADConnection.Rollback;
        lZTItem.FLastTime := Now;
        Result := true;
      end
      else
      begin
        Result := true;
      end;
    except
      on e: Exception do
      begin
        QErrMsg := '事务异常,原因:' + e.Message;
      end;
    end;
  end
  else
  begin
    QErrMsg := '此事务已经不存在';
  end;
end;

function TOneZTManage.StopZT(QZTCode: string; QStop: boolean; Var QErrMsg: string): boolean;
var
  lZTPool: TOneZTPool;
begin
  Result := false;
  QErrMsg := '';
  QZTCode := QZTCode.ToUpper;
  if FZTPools.TryGetValue(QZTCode, lZTPool) then
  begin
    lZTPool.Stop := QStop;
    Result := true;
  end
  else
  begin
    QErrMsg := '找不到相关账套';
  end;
end;

function TOneZTManage.InitZTPool(QZTSet: TOneZTSet; var QErrMsg: string): boolean;
var
  lZTPool: TOneZTPool;
  lZTCode: String;
begin
  Result := false;
  QErrMsg := '';
  if QZTSet.ZTCode.Trim = '' then
    exit;
  QZTSet.ZTCode := QZTSet.ZTCode.ToUpper;
  lZTCode := QZTSet.ZTCode.ToUpper;
  TMonitor.Enter(FLockObject);
  try
    if FZTPools.TryGetValue(lZTCode, lZTPool) then
    begin
      lZTPool.Free;
      FZTPools.Remove(lZTCode);
    end;
    lZTPool := TOneZTPool.Create(QZTSet);
    FZTPools.Add(lZTCode, lZTPool);
    Result := true;
  finally
    TMonitor.exit(FLockObject);
  end;
end;

function TOneZTManage.HaveZT(QZTCode: string): boolean;
begin
  QZTCode := QZTCode.ToUpper;
  Result := FZTPools.ContainsKey(QZTCode);
end;
{$ENDREGION}


function TOneZTManage.StarWork(QZTSetList: TList<TOneZTSet>; var QErrMsg: string): boolean;
var
  i: integer;
  lZTSet: TOneZTSet;
  lZTPool: TOneZTPool;
begin
  Result := false;
  QErrMsg := '';
  try
    // 先释放原有的
    TMonitor.Enter(FLockObject);
    try
      for lZTPool in FZTPools.Values do
      begin
        // 全停止
        lZTPool.Stop := true;
        if lZTPool.FPoolWorkCount > 0 then
        begin
          QErrMsg := lZTPool.ZTCode + '还有正在运行的连接,不可重新加载';
          exit;
        end;
      end;
      for lZTPool in FZTPools.Values do
      begin
        lZTPool.Free;
      end;
      FZTPools.Clear;
    finally
      TMonitor.exit(FLockObject);
    end;
    //
    for i := 0 to QZTSetList.Count - 1 do
    begin
      lZTSet := QZTSetList[i];
      lZTSet.ZTCode := lZTSet.ZTCode.Trim;
      if not lZTSet.IsEnable then
        continue;
      if lZTSet.ZTCode = '' then
        continue;
      if lZTSet.ConnectionStr = '' then
        continue;
      if self.HaveZT(lZTSet.ZTCode) then
        continue;
      self.InitZTPool(lZTSet, QErrMsg);
      if lZTSet.IsMain then
      BEGIN
        self.FZTMain := lZTSet.FZTCode.ToUpper;
      END;
    end;
    FTimerThread.StartWork;
    Result := true;
  except
    on e: Exception do
    begin
      QErrMsg := e.Message;
    end;
  end;
end;

function TOneZTManage.OpenData(QOpenData: TOneDataOpen; QOneDataResult: TOneDataResult): boolean;
var
  lOpenDatas: TList<TOneDataOpen>;
begin
  lOpenDatas := TList<TOneDataOpen>.Create;
  try
    lOpenDatas.Add(QOpenData);
    Result := self.OpenDatas(lOpenDatas, QOneDataResult)
  finally
    // 只释放容器 QOneOpenData不释放
    lOpenDatas.Clear;
    lOpenDatas.Free;
  end;
end;

function TOneZTManage.OpenData(QOpenData: TOneDataOpen; QParams: array of Variant; var QErrMsg: string): TFDMemtable;
var
  lZTItem: TOneZTItem;
  LZTQuery: TFDQuery;
  iParam: integer;
begin
  Result := nil;
  QErrMsg := '';
  lZTItem := self.LockZTItem(QOpenData.ZTCode, QErrMsg);
  if lZTItem = nil then
  begin
    if QErrMsg = '' then
      QErrMsg := '获取账套' + QOpenData.ZTCode + '连接失败,原因未知';
    exit;
  end;
  //
  try
    // 打开数据屏B删除,插入,删除功能防止打开数据的SQL里面放有执行DML语句
    lZTItem.ADConnection.UpdateOptions.EnableDelete := false;
    lZTItem.ADConnection.UpdateOptions.EnableInsert := false;
    lZTItem.ADConnection.UpdateOptions.EnableUpdate := false;
    LZTQuery := lZTItem.GetQuery;
    if (QOpenData.PageSize > 0) and (QOpenData.PageIndex > 0) then
    begin
      LZTQuery.FetchOptions.RecsSkip := (QOpenData.PageIndex - 1) * QOpenData.PageSize;
      LZTQuery.FetchOptions.RecsMax := QOpenData.PageSize;
    end
    else
    begin
      LZTQuery.FetchOptions.RecsSkip := -1;
      if QOpenData.PageSize > 0 then
        LZTQuery.FetchOptions.RecsMax := QOpenData.PageSize
      else
        LZTQuery.FetchOptions.RecsMax := -1;
    end;
    LZTQuery.SQL.Text := QOpenData.OpenSQL;
    // 参数赋值
    if LZTQuery.Params.Count <> Length(QParams) then
    begin
      QErrMsg := 'SQL最终参数个数和传进的参数个数不一至';
      exit;
    end;
    for iParam := 0 to Length(QParams) - 1 do
    begin
      LZTQuery.Params[iParam].Value := QParams[iParam];
    end;
    //
    try
      LZTQuery.Open;
      if not LZTQuery.Active then
      begin
        QErrMsg := '数据打开失败';
        exit;
      end;
      Result := TFDMemtable.Create(nil);
      Result.Data := LZTQuery.Data;
    except
      on e: Exception do
      begin
        QErrMsg := '打开数据发生异常,原因：' + e.Message;
        exit;
      end;
    end;
  finally
    lZTItem.UnLockWork;
  end;
end;

function TOneZTManage.OpenDatas(QOpenDatas: TList<TOneDataOpen>; var QOneDataResult: TOneDataResult): boolean;
var
  i, iParam, iErr: integer;
  lOpenData: TOneDataOpen;
  lZTItem: TOneZTItem;
  LZTQuery: TFDQuery;
  lMemoryStream, lParamStream: TMemoryStream;
  lRequestMilSec: integer;
  lwatchTimer: TStopwatch;
  LJsonValue: TJsonValue;
  lFileName, lFileGuid: string;
  lZip: TZipFile;
  lSQL: string;
  lErrMsg: string;
  lDataResultItem: TOneDataResultItem;
  //
  LFDParam: TFDParam;
  LOneParam: TOneParam;
begin
  Result := false;
  lErrMsg := '';
  if QOneDataResult = nil then
  begin
    QOneDataResult := TOneDataResult.Create;
  end;
  lwatchTimer := TStopwatch.StartNew;
  try
    // 遍历打开多个数据集
    for i := 0 to QOpenDatas.Count - 1 do
    begin
      lDataResultItem := TOneDataResultItem.Create;
      QOneDataResult.ResultCount := QOneDataResult.ResultCount + 1;
      QOneDataResult.ResultItems.Add(lDataResultItem);
      lOpenData := QOpenDatas[i];
      if lOpenData.ZTCode = '' then
        lOpenData.ZTCode := self.ZTMain;
      lOpenData.ZTCode := lOpenData.ZTCode.ToUpper;
      lZTItem := nil;
      // 客户端发起事务,像两层一样运作
      if lOpenData.TranID <> '' then
      begin
        lZTItem := self.GetTranItem(lOpenData.TranID, lErrMsg);
      end
      else
      begin
        lZTItem := self.LockZTItem(lOpenData.ZTCode, lErrMsg);
      end;
      if lZTItem = nil then
      begin
        if lErrMsg = '' then
          lErrMsg := '获取账套' + lOpenData.ZTCode + '连接失败,原因未知';
        exit;
      end;

      try
        // 打开数据屏B删除,插入,删除功能防止打开数据的SQL里面放有执行DML语句
        lZTItem.ADConnection.UpdateOptions.EnableDelete := false;
        lZTItem.ADConnection.UpdateOptions.EnableInsert := false;
        lZTItem.ADConnection.UpdateOptions.EnableUpdate := false;
        // lZTItem.ADQuery 获取连接现成的Query直接用
        // lZTItem.FDConnection 获取连接
        LZTQuery := lZTItem.ADQuery;
        if (lOpenData.PageSize > 0) and (lOpenData.PageIndex > 0) then
        begin
          LZTQuery.FetchOptions.RecsSkip := (lOpenData.PageIndex - 1) * lOpenData.PageSize;
          LZTQuery.FetchOptions.RecsMax := lOpenData.PageSize;
        end
        else
        begin
          LZTQuery.FetchOptions.RecsSkip := -1;
          if lOpenData.PageSize > 0 then
            LZTQuery.FetchOptions.RecsMax := lOpenData.PageSize
          else
            LZTQuery.FetchOptions.RecsMax := -1;
        end;
        LZTQuery.SQL.Text := lOpenData.OpenSQL;
        if LZTQuery.Params.Count <> 0 then
        begin
          if lOpenData.Params.Count <> LZTQuery.Params.Count then
          begin
            lErrMsg := '参数提供不全';
            exit;
          end;
          // 参数赋值
          for iParam := 0 to LZTQuery.Params.Count - 1 do
          begin
            //
            LFDParam := LZTQuery.Params[iParam];
            LOneParam := lOpenData.Params[iParam];
            // 格式转化
            LFDParam.DataType := TFieldType(GetEnumValue(TypeInfo(TFieldType), LOneParam.ParamDataType));
            LFDParam.ParamType := TParamType(GetEnumValue(TypeInfo(TParamType), LOneParam.ParamType));
            // 值赋值
            if LOneParam.ParamValue = const_OneParamIsNull_Value then
            begin
              // Null值情况
              LFDParam.Clear();
            end
            else
            begin
              case LFDParam.DataType of
                ftUnknown:
                  begin
                    LFDParam.Value := LOneParam.ParamValue;
                  end;
                ftStream:
                  begin
                    lParamStream := TMemoryStream.Create;
                    OneStreamString.StreamWriteBase64Str(lParamStream, LOneParam.ParamValue);
                    LFDParam.AsStream := lParamStream;
                  end;
              else
                begin
                  LFDParam.Value := LOneParam.ParamValue;
                end;
              end;
            end;

          end;
        end;
        try
          LZTQuery.Open;
          if not LZTQuery.Active then
          begin
            lErrMsg := '打开数据失败';
            exit;
          end;
          lDataResultItem.RecordCount := LZTQuery.RecordCount;
          lDataResultItem.ResultDataCount := lDataResultItem.ResultDataCount + 1;
          if lOpenData.DataReturnMode = const_DataReturnMode_File then
          begin
            lDataResultItem.ResultDataMode := const_DataReturnMode_File;
            lFileGuid := OneGUID.GetGUID32;
            lFileName := OneFileHelper.CombineExeRunPath('OnePlatform\OneDataTemp\' + lFileGuid + '.zip');
            // 进行文件压缩
            lMemoryStream := TMemoryStream.Create;
            lZip := TZipFile.Create;
            try
              LZTQuery.SaveToStream(lMemoryStream, TFDStorageFormat.sfBinary);
              lMemoryStream.Position := 0;
              lZip.Open(lFileName, TZipMode.zmWrite);
              lZip.Add(lMemoryStream, lFileName);
              lDataResultItem.ResultContext := lFileGuid;
              self.FFileDataDict.Add(lFileGuid, Now);
            finally
              lZip.Free;
              lMemoryStream.Free;
            end;
          end
          else if lOpenData.DataReturnMode = const_DataReturnMode_Stream then
          begin
            lMemoryStream := TMemoryStream.Create;
            LZTQuery.SaveToStream(lMemoryStream, TFDStorageFormat.sfBinary);
            if lMemoryStream.Size >= 1024 * 1024 * 1 then
            begin
              lDataResultItem.ResultDataMode := const_DataReturnMode_File;
              lFileGuid := OneGUID.GetGUID32;
              lFileName := OneFileHelper.CombineExeRunPath('OnePlatform\OneDataTemp\' + lFileGuid + '.zip');
              lZip := TZipFile.Create;
              try
                lMemoryStream.Position := 0;
                lZip.Open(lFileName, TZipMode.zmWrite);
                lZip.Add(lMemoryStream, lFileName);
                lDataResultItem.ResultContext := lFileGuid;
                self.FFileDataDict.Add(lFileGuid, Now);
              finally
                lZip.Free;
                lMemoryStream.Clear;
                lMemoryStream.Free;
              end;
            end
            else
            begin
              lDataResultItem.ResultDataMode := const_DataReturnMode_Stream;
              lDataResultItem.SetStream(lMemoryStream);
            end;
          end
          else if lOpenData.DataReturnMode = const_DataReturnMode_JSON then
          begin
            LJsonValue := OneNeonHelper.ObjectToJson(LZTQuery, lErrMsg);
            try
              if lErrMsg <> '' then
              begin
                exit;
              end;
              lDataResultItem.ResultContext := LJsonValue.ToJSON();
            finally
              LJsonValue.Free;
            end;
          end;
          // 分页取总数，第一页才去取
          if ((lOpenData.PageSize > 0) and (lOpenData.PageIndex = 1)) or (lOpenData.PageRefresh) then
          begin
            lDataResultItem.ResultPage := true;
            LZTQuery.FetchOptions.RecsSkip := -1;
            LZTQuery.FetchOptions.RecsMax := -1;
            lSQL := ClearOrderBySQL(lOpenData.OpenSQL);
            lSQL := lSQL.Replace(' * ', ' 1 as one_zsys_temp_aaa ');
            lSQL := 'select count(1) from ( ' + lSQL + ' ) tempCount';
            LZTQuery.SQL.Text := lSQL;
            for iParam := 0 to LZTQuery.Params.Count - 1 do
            begin
              LZTQuery.Params[iParam].Value := lOpenData.Params[iParam].ParamValue;
            end;
            LZTQuery.Open();
            lDataResultItem.ResultTotal := LZTQuery.Fields[0].AsInteger;
          end;
        except
          on e: Exception do
          begin
            if lZTItem.FDException.FErrmsg <> '' then
              lErrMsg := lZTItem.FDException.FErrmsg
            else
              lErrMsg := e.Message;
            exit;
          end;
        end;
      finally
        // 释放连接池
        if lZTItem <> nil then
        begin
          lZTItem.UnLockWork();
        end;
      end;
      if lErrMsg <> '' then
      begin
        Result := false;
        exit;;
      end;
    end;
    Result := true;
    QOneDataResult.ResultOK := true;
  finally
    QOneDataResult.ResultMsg := lErrMsg;
    lwatchTimer.Stop;
    lRequestMilSec := lwatchTimer.ElapsedMilliseconds;
    if (self.FLog <> nil) and (self.FLog.IsSQLLog) then
    begin
      self.FLog.WriteSQLLog('账套方法[OpenDatas]:');
      self.FLog.WriteSQLLog('总共用时:[' + lRequestMilSec.ToString + ']毫秒');
      self.FLog.WriteSQLLog('错误消息:[' + lErrMsg + ']');
      for i := 0 to QOpenDatas.Count - 1 do
      begin
        lOpenData := QOpenDatas[i];
        self.FLog.WriteSQLLog('SQL语句:[' + lOpenData.OpenSQL + ']');
        for iParam := 0 to lOpenData.Params.Count - 1 do
        begin
          LOneParam := lOpenData.Params[iParam];
          self.FLog.WriteSQLLog('参数:[' + LOneParam.ParamName + ']值[' + LOneParam.ParamValue + ']');
        end;
      end;
    end;
  end;
end;

// 保存数据
function TOneZTManage.SaveDatas(QSaveDMLDatas: TList<TOneDataSaveDML>; var QOneDataResult: TOneDataResult): boolean;
var
  lDataResultItem: TOneDataResultItem;
  //
  lZTItemList: TDictionary<string, TOneZTItem>;
  lZTItem: TOneZTItem;
  LZTQuery: TFDQuery;
  i: integer;
  lDataSaveDML: TOneDataSaveDML;
  LOneParam: TOneParam;
  lErrMsg: string;
  lTranCount: integer;
  //
  lSaveStream: TMemoryStream;
  lArrKeys: TArray<string>;
  iKey: integer;
  iUpdateErrCount, iParamCount, iParam: integer;
  lFieldType: TFieldType;
  isCommit: boolean;
  //
  lRequestMilSec: integer;
  lwatchTimer: TStopwatch;
begin
  Result := false;
  lErrMsg := '';
  isCommit := false;
  if QOneDataResult = nil then
  begin
    QOneDataResult := TOneDataResult.Create;
  end;
  // 校验
  lTranCount := 0;
  for i := 0 to QSaveDMLDatas.Count - 1 do
  begin
    lDataSaveDML := QSaveDMLDatas[i];
    if lDataSaveDML.ZTCode = '' then
      lDataSaveDML.ZTCode := self.ZTMain;
    lDataSaveDML.ZTCode := lDataSaveDML.ZTCode.ToUpper;
    if lDataSaveDML.DataSaveMode = const_DataSaveMode_SaveData then
    begin
      if lDataSaveDML.TableName = '' then
      begin
        QOneDataResult.ResultMsg := '第' + (i + 1).ToString + '个数据集保存数据集时,保存的表名不可为空';
        exit;
      end;
      if lDataSaveDML.Primarykey = '' then
      begin
        QOneDataResult.ResultMsg := '第' + (i + 1).ToString + '个数据集保存数据集时,保存的主键不可为空';
        exit;
      end;
      if lDataSaveDML.SaveData = '' then
      begin
        QOneDataResult.ResultMsg := '第' + (i + 1).ToString + '个数据集提交的数据为空,请检查';
        exit;
      end;
    end
    else if lDataSaveDML.DataSaveMode = const_DataSaveMode_SaveDML then
    begin
      if lDataSaveDML.SQL = '' then
      begin
        QOneDataResult.ResultMsg := '第' + (i + 1).ToString + '个数据集执行DML操作语句时,操作语句不可为空';
        exit;
      end;
    end
    else
    begin
      QOneDataResult.ResultMsg := '第' + (i + 1).ToString + '个数据集未知的提交模式' + lDataSaveDML.DataSaveMode;
      exit;
    end;
    // 要么事务全由客户端控制,要么全由服务端控制,不混合提交
    if lDataSaveDML.TranID <> '' then
    begin
      lTranCount := lTranCount + 1;
    end;
  end;
  if (lTranCount > 0) and (QSaveDMLDatas.Count <> lTranCount) then
  begin
    QOneDataResult.ResultMsg := '事务不可混合,要么全服务端控制，要么全由客户端控制' + lDataSaveDML.DataSaveMode;
    exit;
  end;

  // 临时保存锁定的账套连接
  lwatchTimer := TStopwatch.StartNew;
  lZTItemList := TDictionary<string, TOneZTItem>.Create;
  try
    for i := 0 to QSaveDMLDatas.Count - 1 do
    begin
      lDataSaveDML := QSaveDMLDatas[i];
      if lDataSaveDML.TranID <> '' then
      begin
        if lZTItemList.TryGetValue(lDataSaveDML.TranID, lZTItem) then
        begin
          // 同个事务的连接
          continue;
        end;
      end
      else
      begin
        // 已经存在此账套连接
        if lZTItemList.TryGetValue(lDataSaveDML.ZTCode, lZTItem) then
        begin
          continue;
        end;
      end;
      //
      lZTItem := nil;
      if lDataSaveDML.TranID <> '' then
      begin
        lZTItem := self.GetTranItem(lDataSaveDML.TranID, lErrMsg);
      end
      else
      begin
        lZTItem := self.LockZTItem(lDataSaveDML.ZTCode, lErrMsg);
      end;
      if lZTItem = nil then
      begin
        // 锁定账套连接失败
        QOneDataResult.ResultMsg := lErrMsg;
        exit;
      end;

      if lDataSaveDML.TranID <> '' then
      begin
        lZTItemList.Add(lDataSaveDML.TranID, lZTItem);
      end
      else
      begin
        lZTItemList.Add(lDataSaveDML.ZTCode, lZTItem);
      end;
    end;

    try
      try
        // 开启事务
        for lZTItem in lZTItemList.Values do
        begin
          // 自定义事务的,是由客户端自由控制
          if not lZTItem.FCustTran then
            lZTItem.ADTransaction.StartTransaction;
        end;
        // 循环提交的数据，处理
        for i := 0 to QSaveDMLDatas.Count - 1 do
        begin
          lDataResultItem := TOneDataResultItem.Create;
          QOneDataResult.ResultItems.Add(lDataResultItem);
          lDataResultItem.ResultDataMode := const_DataReturnMode_Empty;
          lDataSaveDML := QSaveDMLDatas[i];
          lZTItem := nil;
          if lDataSaveDML.TranID <> '' then
          begin
            lZTItemList.TryGetValue(lDataSaveDML.TranID, lZTItem);
          end
          else
          begin
            lZTItemList.TryGetValue(lDataSaveDML.ZTCode, lZTItem);
          end;
          //
          if lZTItem = nil then
          begin
            QOneDataResult.ResultMsg := '获取账套' + lDataSaveDML.ZTCode + '连接失败';
            exit;
          end;
          //
          if lDataSaveDML.DataSaveMode = const_DataSaveMode_SaveData then
          begin
            // 提交数据
            LZTQuery := lZTItem.ADQuery;
            LZTQuery.SQL.Text := 'select *  from ' + lDataSaveDML.TableName;
            LZTQuery.UpdateOptions.UpdateTableName := lDataSaveDML.TableName;
            LZTQuery.UpdateOptions.KeyFields := lDataSaveDML.Primarykey;
            //
            LZTQuery.UpdateOptions.UpdateMode := TUpdateMode.upWhereKeyOnly;
            if lDataSaveDML.UpdateMode <> '' then
            begin
              LZTQuery.UpdateOptions.UpdateMode := TUpdateMode(GetEnumValue(TypeInfo(TUpdateMode), lDataSaveDML.UpdateMode));
            end;
            // 直接预创建好的变量拿来用
            lSaveStream := lZTItem.DataStream;
            OneStreamString.StreamWriteBase64Str(lSaveStream, lDataSaveDML.SaveData);
            lSaveStream.Position := 0;
            // 加载流
            LZTQuery.LoadFromStream(lSaveStream, TFDStorageFormat.sfBinary);
            if not LZTQuery.Active then
            begin
              QOneDataResult.ResultMsg := '加载第' + (i + 1).ToString + '数据失败';
              exit;
            end;
            // 主键也设定成所有
            if lDataSaveDML.Primarykey <> '' then
            begin
              lArrKeys := lDataSaveDML.Primarykey.Split([';', ','], TStringSplitOptions.ExcludeEmpty);
              for iKey := Low(lArrKeys) to High(lArrKeys) do
              begin
                // 主键参与所有
                LZTQuery.FieldByName(lArrKeys[iKey]).ProviderFlags := [pfInUpdate, pfInWhere, pfInKey];
              end;
            end;
            // 其它主键也设成所有
            if lDataSaveDML.OtherKeys <> '' then
            begin
              lArrKeys := lDataSaveDML.OtherKeys.Split([';', ','], TStringSplitOptions.ExcludeEmpty);
              for iKey := Low(lArrKeys) to High(lArrKeys) do
              begin
                // 主键参与所有
                LZTQuery.FieldByName(lArrKeys[iKey]).ProviderFlags := [pfInUpdate, pfInWhere, pfInKey];
              end;
            end;

            try
              iUpdateErrCount := LZTQuery.ApplyUpdates(0);
              lDataResultItem.RecordCount := LZTQuery.RowsAffected;
              if lDataSaveDML.IsReturnData then
              begin
                // 返回数据集,比如有自增ID，需返回数据集
                lDataResultItem.ResultDataMode := const_DataReturnMode_Stream;
                lSaveStream := TMemoryStream.Create;
                LZTQuery.SaveToStream(lSaveStream, TFDStorageFormat.sfBinary);
                lSaveStream.Position := 0;
                lDataResultItem.SetStream(lSaveStream);
              end;
            except
              on e: Exception do
              begin
                QOneDataResult.ResultMsg := '保存出现异常:异常原因:' + e.Message;
                exit;
              end;
            end;
            if iUpdateErrCount > 0 then
            begin
              if lZTItem.FException.FErrmsg <> '' then
                QOneDataResult.ResultMsg := '保存出现异常:异常原因:' + lZTItem.FException.FErrmsg;
              exit;
            end;
          end
          else if lDataSaveDML.DataSaveMode = const_DataSaveMode_SaveDML then
          begin
            // 执行DML语句
            LZTQuery := lZTItem.ADQuery;
            LZTQuery.SQL.Text := lDataSaveDML.SQL;
            iParamCount := LZTQuery.ParamCount;
            if iParamCount > 0 then
            begin
              if iParamCount > lDataSaveDML.Params.Count then
              begin
                QOneDataResult.ResultMsg := '加载第' + (i + 1).ToString + '异常参数不足';
                exit;
              end;
              //
              for iParam := 0 to LZTQuery.Params.Count - 1 do
              begin
                LOneParam := lDataSaveDML.Params[iParam];
                lFieldType := TFieldType.ftUnknown;
                if LOneParam.ParamDataType <> '' then
                begin
                  lFieldType := TFieldType(GetEnumValue(TypeInfo(TFieldType), LOneParam.ParamDataType));
                end;
                LZTQuery.Params[iParam].DataType := lFieldType;
                //
                if LOneParam.ParamValue = const_OneParamIsNull_Value then
                begin
                  LZTQuery.Params[iParam].Clear();
                end
                else if lFieldType = TFieldType.ftStream then
                begin
                  LZTQuery.Params[iParam].AsStream := OneStreamString.Base64ToStream(LOneParam.ParamValue);
                end
                else
                  LZTQuery.Params[iParam].Value := LOneParam.ParamValue;
              end;
            end;
            try
              LZTQuery.ExecSQL;
              lDataResultItem.RecordCount := LZTQuery.RowsAffected;
            except
              on e: Exception do
              begin
                QOneDataResult.ResultMsg := '执行DML语句异常,原因:' + e.Message;
                exit;
              end;
            end;
            if lDataSaveDML.AffectedMustCount > 0 then
            begin
              if LZTQuery.RowsAffected <> lDataSaveDML.AffectedMustCount then
              begin
                QOneDataResult.ResultMsg := '执行DML语句异常,原因:必需影响行数[' + lDataSaveDML.AffectedMustCount.ToString + '],当前影响行数[' + LZTQuery.RowsAffected.ToString + ']';
                exit
              end;
            end;
            if lDataSaveDML.AffectedMaxCount > 0 then
            BEGIN
              if LZTQuery.RowsAffected > lDataSaveDML.AffectedMaxCount then
              BEGIN
                QOneDataResult.ResultMsg := '执行DML语句异常,原因:最大影响行数[' + lDataSaveDML.AffectedMaxCount.ToString + '],当前影响行数[' + LZTQuery.RowsAffected.ToString + ']';
                exit
              END;
            END;
          end;
        end;
        for lZTItem in lZTItemList.Values do
        begin
          if not lZTItem.FCustTran then
            lZTItem.ADTransaction.Commit;
        end;
        QOneDataResult.ResultOK := true;
        isCommit := true;
      except
        on e: Exception do
        begin
          QOneDataResult.ResultOK := false;
          isCommit := false;
          QOneDataResult.ResultMsg := '保存出现异常:异常原因:' + e.Message;
          exit;
        end;
      end;
    finally
      // 事务处理
      if not isCommit then
      begin
        for lZTItem in lZTItemList.Values do
        begin
          if not lZTItem.FCustTran then
            lZTItem.ADTransaction.Rollback;
        end;
      end;
    end;
  finally
    lwatchTimer.Stop;
    lRequestMilSec := lwatchTimer.ElapsedMilliseconds;
    for lZTItem in lZTItemList.Values do
    begin
      // 归还连接
      if not lZTItem.FCustTran then
        lZTItem.UnLockWork;
    end;
    lZTItemList.Clear;
    lZTItemList.Free;

    if (self.FLog <> nil) and (self.FLog.IsSQLLog) then
    begin
      self.FLog.WriteSQLLog('账套方法[SaveDatas]:');
      self.FLog.WriteSQLLog('总共用时:[' + lRequestMilSec.ToString + ']毫秒');
      self.FLog.WriteSQLLog('错误消息:[' + QOneDataResult.ResultMsg + ']');
      for i := 0 to QSaveDMLDatas.Count - 1 do
      begin
        lDataSaveDML := QSaveDMLDatas[i];
        self.FLog.WriteSQLLog('SQL语句:[' + lDataSaveDML.SQL + ']');
        for iParam := 0 to lDataSaveDML.Params.Count - 1 do
        begin
          LOneParam := lDataSaveDML.Params[iParam];
          self.FLog.WriteSQLLog('参数:[' + LOneParam.ParamName + ']值[' + LOneParam.ParamValue + ']');
        end;
      end;
    end;
  end;
end;

function TOneZTManage.ExecSQL(QDataSaveDML: TOneDataSaveDML; QParams: array of Variant; var QErrMsg: string): integer;
var
  lZTItem: TOneZTItem;
  LZTQuery: TFDQuery;
  iParam: integer;
  isCommit: boolean;
begin
  Result := -1;
  QErrMsg := '';
  lZTItem := self.LockZTItem(QDataSaveDML.ZTCode, QErrMsg);
  if lZTItem = nil then
  begin
    if QErrMsg = '' then
      QErrMsg := '获取账套' + QDataSaveDML.ZTCode + '连接失败,原因未知';
    exit;
  end;
  //
  isCommit := false;
  lZTItem.ADConnection.StartTransaction;
  try
    // 打开数据屏B删除,插入,删除功能防止打开数据的SQL里面放有执行DML语句
    LZTQuery := lZTItem.GetQuery;
    LZTQuery.SQL.Text := QDataSaveDML.SQL;
    // 参数赋值
    if LZTQuery.Params.Count <> Length(QParams) then
    begin
      QErrMsg := 'SQL最终参数个数和传进的参数个数不一至';
      exit;
    end;
    for iParam := 0 to Length(QParams) - 1 do
    begin
      LZTQuery.Params[iParam].Value := QParams[iParam];
    end;
    //
    try
      LZTQuery.ExecSQL;
      Result := LZTQuery.RowsAffected;
      if QDataSaveDML.AffectedMustCount > 0 then
      begin
        if LZTQuery.RowsAffected <> QDataSaveDML.AffectedMustCount then
        begin
          QErrMsg := '执行DML语句异常,原因:必需影响行数[' + QDataSaveDML.AffectedMustCount.ToString + '],当前影响行数[' + LZTQuery.RowsAffected.ToString + ']';
          exit
        end;
      end;
      if QDataSaveDML.AffectedMaxCount > 0 then
      BEGIN
        if LZTQuery.RowsAffected > QDataSaveDML.AffectedMaxCount then
        BEGIN
          QErrMsg := '执行DML语句异常,原因:最大影响行数[' + QDataSaveDML.AffectedMaxCount.ToString + '],当前影响行数[' + LZTQuery.RowsAffected.ToString + ']';
          exit
        END;
      END;
      lZTItem.ADConnection.Commit;
      isCommit := true;
      QErrMsg := 'true';
    except
      on e: Exception do
      begin
        QErrMsg := '打开数据发生异常,原因：' + e.Message;
        exit;
      end;
    end;
  finally
    if not isCommit then
    begin
      lZTItem.ADConnection.Rollback;
    end;
    lZTItem.UnLockWork;
  end;
end;

function TOneZTManage.ExecStored(QOpenData: TOneDataOpen; var QOneDataResult: TOneDataResult): boolean;
var
  lZTItem: TOneZTItem;
  lErrMsg: string;
  lFDStored: TFDStoredProc;
  i, iParam: integer;
  tempStr: string;
  LFDParam: TFDParam;
  lDictParam: TDictionary<string, TOneParam>;
  LOneParam: TOneParam;
  lStream, lParamStream: TMemoryStream;
  lDataResultItem: TOneDataResultItem;
  lPTResult: integer;
  lRequestMilSec: integer;
  lwatchTimer: TStopwatch;
begin
  Result := false;
  lPTResult := 0;
  if QOneDataResult = nil then
  begin
    QOneDataResult := TOneDataResult.Create;
  end;
  if QOpenData.Params = nil then
  begin
    QOpenData.Params := TList<TOneParam>.Create;;
  end;
  // 处理数据
  if QOpenData = nil then
  begin
    QOneDataResult.ResultMsg := '请传入要执行存储过程的信息';
    exit;
  end;
  if QOpenData.SPName.Trim = '' then
  begin
    QOneDataResult.ResultMsg := '执行的存储过程名字为空';
    exit;
  end;
  //
  lZTItem := nil;
  lErrMsg := '';
  lwatchTimer := TStopwatch.StartNew;
  lDictParam := TDictionary<string, TOneParam>.Create;
  try
    for iParam := 0 to QOpenData.Params.Count - 1 do
    begin
      LOneParam := QOpenData.Params[iParam];
      lDictParam.Add(LOneParam.ParamName.ToLower, LOneParam);
    end;

    if QOpenData.ZTCode = '' then
      QOpenData.ZTCode := self.ZTMain;
    QOpenData.ZTCode := QOpenData.ZTCode.ToUpper;
    lZTItem := nil;
    // 客户端发起事务,像两层一样运作
    if QOpenData.TranID <> '' then
    begin
      lZTItem := self.GetTranItem(QOpenData.TranID, lErrMsg);
    end
    else
    begin
      lZTItem := self.LockZTItem(QOpenData.ZTCode, lErrMsg);
    end;
    if lZTItem = nil then
    begin
      if lErrMsg = '' then
        lErrMsg := '获取账套' + QOpenData.ZTCode + '连接失败,原因未知';
      exit;
    end;
    lFDStored := lZTItem.ADStoredProc;
    lFDStored.PackageName := QOpenData.PackageName;
    lFDStored.StoredProcName := QOpenData.SPName;
    // 准备参数
    lFDStored.Prepare;
    if not lFDStored.Prepared then
    begin
      lErrMsg := '校验存储过程失败,请检查是否有此存储过程[' + QOpenData.SPName + ']';
      exit;
    end;
    for iParam := lFDStored.Params.Count - 1 downto 0 do
    begin
      LFDParam := lFDStored.Params[iParam];
      if LFDParam.ParamType = TParamType.ptResult then
      begin
        lPTResult := lPTResult + 1;
        continue;
      end;
      if LFDParam.Name.StartsWith('@') then
      begin
        // SQL数据库返回参数代@去掉
        LFDParam.Name := LFDParam.Name.Substring(1);
      end;
    end;
    //
    if QOpenData.Params.Count <> lFDStored.Params.Count - lPTResult then
    begin
      tempStr := '参数个数错误->服务端参数个数[' + lFDStored.Params.Count.ToString + '],如下[';
      for iParam := lFDStored.Params.Count - 1 downto 0 do
      begin
        tempStr := tempStr + lFDStored.Params[iParam].Name;
      end;
      tempStr := tempStr + ';客户端参数个数[' + QOpenData.Params.Count.ToString + '],如下[';
      for iParam := QOpenData.Params.Count - 1 downto 0 do
      begin
        tempStr := tempStr + QOpenData.Params[iParam].ParamName;
      end;
      tempStr := tempStr + ']';
      lErrMsg := tempStr;
      exit;
    end;
    // 参数赋值
    for iParam := 0 to lFDStored.Params.Count - 1 do
    begin
      LFDParam := lFDStored.Params[iParam];
      if LFDParam.ParamType = TParamType.ptResult then
      begin
        continue;
      end;
      // 处理参数
      LOneParam := nil;
      if not lDictParam.TryGetValue(LFDParam.Name.ToLower, LOneParam) then
      begin
        lErrMsg := '参数[' + LFDParam.Name + '],找不到对应的参数,请检查传上来的参数';
        exit;
      end;
      if LFDParam.ParamType in [TParamType.ptInput, TParamType.ptInputOutput, TParamType.ptOutput] then
      begin
        if LFDParam.DataType = ftWideMemo then
        begin
          LFDParam.AsWideMemo := LOneParam.ParamValue;
        end
        else if LFDParam.DataType = ftWideString then
        begin
          LFDParam.AsWideString := LOneParam.ParamValue;
        end
        else if LFDParam.DataType = ftStream then
        begin
          lParamStream := TMemoryStream.Create;
          OneStreamString.StreamWriteBase64Str(lParamStream, LOneParam.ParamValue);
          LFDParam.AsStream := lParamStream;
        end
        else
          LFDParam.Value := LOneParam.ParamValue;
      end;
    end;
    // ExecProc 执行一个存储过程返回参数
    try
      if QOpenData.SPIsOutData then
      begin
        if not lFDStored.OpenOrExecute then
        begin
          lErrMsg := lZTItem.FException.FErrmsg;
          exit;
        end;
      end
      else
      begin
        lFDStored.ExecProc;
      end;

      // 说明有返回数据集,添加数据集,可以返回多个数据集
      if not lFDStored.Active then
      begin
        lDataResultItem := TOneDataResultItem.Create;
        QOneDataResult.ResultItems.Add(lDataResultItem);
      end;
      begin
        // 返回数据
        while lFDStored.Active do
        begin
          lDataResultItem := TOneDataResultItem.Create;
          QOneDataResult.ResultItems.Add(lDataResultItem);
          lDataResultItem.ResultDataMode := const_DataReturnMode_Stream;
          lStream := TMemoryStream.Create;
          lFDStored.SaveToStream(lStream, TFDStorageFormat.sfBinary);
          lDataResultItem.SetStream(lStream);
          lFDStored.NextRecordSet;
        end;
        //
        lDataResultItem := QOneDataResult.ResultItems[0];
      end;
      //
      for iParam := 0 to lFDStored.Params.Count - 1 do
      begin
        LFDParam := lFDStored.Params[iParam];
        if LFDParam.ParamType in [TParamType.ptInputOutput, TParamType.ptOutput] then
        begin
          if lDictParam.TryGetValue(LFDParam.Name.ToLower, LOneParam) then
          begin
            // 返回的参数放在第一个结果集
            LOneParam := TOneParam.Create;
            lDataResultItem.ResultParams.Add(LOneParam);
            LOneParam.ParamName := LFDParam.Name;
            LOneParam.ParamDataType := GetEnumName(TypeInfo(TFieldType), Ord(LFDParam.DataType));
            LOneParam.ParamValue := VarToStr(LFDParam.Value);
          end;
        end;
      end;
      Result := true;
      QOneDataResult.ResultOK := true;
    except
      on e: Exception do
      begin
        lErrMsg := '执行存储过程异常:' + e.Message;
        exit;
      end;
    end;
  finally
    QOneDataResult.ResultMsg := lErrMsg;
    if lZTItem <> nil then
    begin
      lZTItem.UnLockWork;
    end;
    lDictParam.Clear;
    lDictParam.Free;
    lwatchTimer.Stop;
    lRequestMilSec := lwatchTimer.ElapsedMilliseconds;
    if (self.FLog <> nil) and (self.FLog.IsSQLLog) then
    begin
      self.FLog.WriteSQLLog('账套方法[ExecStored]:');
      self.FLog.WriteSQLLog('总共用时:[' + lRequestMilSec.ToString + ']毫秒');
      self.FLog.WriteSQLLog('错误消息:[' + lErrMsg + ']');
      self.FLog.WriteSQLLog('SQL语句:[' + QOpenData.SPName + ']');
      for iParam := 0 to QOpenData.Params.Count - 1 do
      begin
        LOneParam := QOpenData.Params[iParam];
        self.FLog.WriteSQLLog('参数:[' + LOneParam.ParamName + ']值[' + LOneParam.ParamValue + ']');
      end;
    end;
  end;

end;

// 执行SQL脚本语句
function TOneZTManage.ExecScript(QOpenData: TOneDataOpen; var QErrMsg: string): boolean;
var
  lZTItem: TOneZTItem;
  lFDScript: TFDScript;
  lFDSQLScript: TFDSQLScript;
  lZTCode: string;
  lRequestMilSec: integer;
  lwatchTimer: TStopwatch;
begin
  Result := false;
  QErrMsg := '';
  lZTItem := nil;
  lwatchTimer := TStopwatch.StartNew;
  try
    if QOpenData.ZTCode = '' then
      QOpenData.ZTCode := self.ZTMain;
    QOpenData.ZTCode := QOpenData.ZTCode.ToUpper;
    lZTItem := nil;
    // 客户端发起事务,像两层一样运作
    if QOpenData.TranID <> '' then
    begin
      lZTItem := self.GetTranItem(QOpenData.TranID, QErrMsg);
    end
    else
    begin
      lZTItem := self.LockZTItem(QOpenData.ZTCode, QErrMsg);
    end;
    if lZTItem = nil then
    begin
      if QErrMsg = '' then
        QErrMsg := '获取账套' + QOpenData.ZTCode + '连接失败,原因未知';
      exit;
    end;
    lFDScript := lZTItem.ADScript;
    try
      lFDSQLScript := lFDScript.SQLScripts.Add;
      lFDSQLScript.SQL.Add(QOpenData.OpenSQL);
      lFDScript.ValidateAll;
      Result := lFDScript.ExecuteAll;
      if not Result then
      begin
        if lZTItem.FException <> nil then
        begin
          QErrMsg := lZTItem.FException.FErrmsg;
        end;
      end;
    except
      on e: Exception do
      begin
        QErrMsg := e.Message;
      end;
    end;
  finally
    if lZTItem <> nil then
    begin
      lZTItem.UnLockWork;
    end;
    lwatchTimer.Stop;
    lRequestMilSec := lwatchTimer.ElapsedMilliseconds;
    if (self.FLog <> nil) and (self.FLog.IsSQLLog) then
    begin
      self.FLog.WriteSQLLog('账套方法[ExecStored]:');
      self.FLog.WriteSQLLog('总共用时:[' + lRequestMilSec.ToString + ']毫秒');
      self.FLog.WriteSQLLog('错误消息:[' + QErrMsg + ']');
      self.FLog.WriteSQLLog('SQL语句:[' + QOpenData.OpenSQL + ']');
    end;
  end;
end;

function TOneZTManage.GetDBMetaInfo(QDBMetaInfo: TOneDBMetaInfo; var QOneDataResult: TOneDataResult): boolean;
var
  lZTItem: TOneZTItem;
  lErrMsg: string;
  lMetaInfoQuery: TFDMetaInfoQuery;
  tempStr: string;
  LOneParam: TOneParam;
  lStream, lParamStream: TMemoryStream;
  lDataResultItem: TOneDataResultItem;
  lPTResult: integer;
  lRequestMilSec: integer;
  lwatchTimer: TStopwatch;
begin
  Result := false;
  lPTResult := 0;
  if QOneDataResult = nil then
  begin
    QOneDataResult := TOneDataResult.Create;
  end;
  // 处理数据
  if QDBMetaInfo = nil then
  begin
    QOneDataResult.ResultMsg := '请传入要查询的数据库信息';
    exit;
  end;
  if QDBMetaInfo.MetaInfoKind = 'mkTableFields' then
  begin
    if QDBMetaInfo.MetaObjName = '' then
    begin
      QOneDataResult.ResultMsg := '获取表字段,相关表名称[MetaObjName]不可为空';
      exit;
    end;
  end;
  //
  lMetaInfoQuery := nil;
  lZTItem := nil;
  lErrMsg := '';
  lwatchTimer := TStopwatch.StartNew;
  try
    if QDBMetaInfo.ZTCode = '' then
      QDBMetaInfo.ZTCode := self.ZTMain;
    QDBMetaInfo.ZTCode := QDBMetaInfo.ZTCode.ToUpper;
    // 客户端发起事务,像两层一样运作
    lZTItem := self.LockZTItem(QDBMetaInfo.ZTCode, lErrMsg);
    if lZTItem = nil then
    begin
      if lErrMsg = '' then
        lErrMsg := '获取账套' + QDBMetaInfo.ZTCode + '连接失败,原因未知';
      exit;
    end;
    lMetaInfoQuery := TFDMetaInfoQuery.Create(nil);
    lMetaInfoQuery.Connection := lZTItem.ADConnection;
    lMetaInfoQuery.ObjectName := QDBMetaInfo.MetaObjName;
    lMetaInfoQuery.MetaInfoKind := TFDPhysMetaInfoKind(GetEnumValue(TypeInfo(TFDPhysMetaInfoKind), QDBMetaInfo.MetaInfoKind));
    // ExecProc 执行一个存储过程返回参数
    try
      lMetaInfoQuery.Open;
      lDataResultItem := TOneDataResultItem.Create;
      QOneDataResult.ResultItems.Add(lDataResultItem);
      lDataResultItem.ResultDataMode := const_DataReturnMode_Stream;
      lStream := TMemoryStream.Create;
      lMetaInfoQuery.SaveToStream(lStream, TFDStorageFormat.sfBinary);
      lDataResultItem.SetStream(lStream);
      Result := true;
      QOneDataResult.ResultOK := true;
    except
      on e: Exception do
      begin
        lErrMsg := '执行存储过程异常:' + e.Message;
        exit;
      end;
    end;
  finally
    QOneDataResult.ResultMsg := lErrMsg;
    if lZTItem <> nil then
    begin
      lZTItem.UnLockWork;
    end;
    if lMetaInfoQuery <> nil then
    begin
      lMetaInfoQuery.Free;
    end;
    lwatchTimer.Stop;
    lRequestMilSec := lwatchTimer.ElapsedMilliseconds;
    if (self.FLog <> nil) and (self.FLog.IsSQLLog) then
    begin
      self.FLog.WriteSQLLog('账套方法[GetDBMetaInfo]:');
      self.FLog.WriteSQLLog('总共用时:[' + lRequestMilSec.ToString + ']毫秒');
      self.FLog.WriteSQLLog('错误消息:[' + lErrMsg + ']');
      self.FLog.WriteSQLLog('类型:[' + QDBMetaInfo.MetaInfoKind + ']');
    end;
  end;
end;

procedure InitPhyDriver;
const
  // Ora数据库
  const_OraOciDll32: string = 'OnePlatform\OnePhyDBDLL\OracleDll\32\oci.dll';
  const_OraOciDll64: string = 'OnePlatform\OnePhyDBDLL\OracleDll\64\oci.dll';
  // mysql数据库
  const_Libmysql32: string = 'OnePlatform\OnePhyDBDLL\mySQLDLL\32\libmysql.dll';
  const_Libmysql64: string = 'OnePlatform\OnePhyDBDLL\mySQLDLL\64\libmysql.dll';
  // pg数据库
  const_Libpg32: string = 'OnePlatform\OnePhyDBDLL\pgDLL\32\libpq.dll';
  const_Libpg64: string = 'OnePlatform\OnePhyDBDLL\pgDLL\64\libpq.dll';
  // FireBird安装版
  const_Libfb32: string = 'OnePlatform\OnePhyDBDLL\fbDLL\32\fbclient.dll';
  const_Libfb64: string = 'OnePlatform\OnePhyDBDLL\fbDLL\64\fbclient.dll';
  // fireBird 嵌入式版本
  const_Libfbb32: string = 'OnePlatform\OnePhyDBDLL\fbbDLL\32\fbembed.dll';
  const_Libfbb64: string = 'OnePlatform\OnePhyDBDLL\fbbDLL\64\fbembed.dll';
  // SQLite3数据库
  const_Lib3SQLite32: string = 'OnePlatform\OnePhyDBDLL\SQLite3\32\sqlite3.dll';
  const_Lib3SQLite64: string = 'OnePlatform\OnePhyDBDLL\SQLite3\64\sqlite3.dll';
  // ASA数据库
  const_LibASA32: string = 'OnePlatform\OnePhyDBDLL\ASA\32\ASA.dll';
  const_LibASA64: string = 'OnePlatform\OnePhyDBDLL\ASA\64\ASA.dll';
  // ODBC驱动
  // const_ODBC32:string='phyDBDLL\ODBC\32\ASA.dll';
  // const_ODBC64:string='phyDBDLL\ODBC\64\ASA.dll';
  // MSAcc驱动

var
  vExeName, lExePath, lFileName: string;
begin
  if Var_MSSQLDriverLink = nil then
    Var_MSSQLDriverLink := TFDPhysMSSQLDriverLink.Create(nil);

  if Var_2000MSSQLDriverLink = nil then
  begin
    Var_2000MSSQLDriverLink := TFDPhysMSSQLDriverLink.Create(nil);
    Var_2000MSSQLDriverLink.DriverID := 'MSSQL2000';
    Var_2000MSSQLDriverLink.ODBCDriver := 'SQL Server';
  end;

  if var_MSAccDriverLink = nil then
  begin
    var_MSAccDriverLink := TFDPhysMSAccessDriverLink.Create(nil);
  end;

  //
  if Var_OracleDriverLink = nil then
    Var_OracleDriverLink := TFDPhysOracleDriverLink.Create(nil);
  //
  if Var_MySQLDriverLink = nil then
    Var_MySQLDriverLink := TFDPhysMySQLDriverLink.Create(nil);
  //
  if var_PGDriverLink = nil then
    var_PGDriverLink := TFDPhysPgDriverLink.Create(nil);
  //
  if var_SQLiteDriverLinK = nil then
    var_SQLiteDriverLinK := TFDPhysSQLiteDriverLink.Create(nil);
  //
  if var_ODBCDriverLink = nil then
    var_ODBCDriverLink := TFDPhysODBCDriverLink.Create(nil);

  lExePath := OneFileHelper.GetExeRunPath;
{$IF Defined(CPUX86)}
  lFileName := OneFileHelper.CombinePath(lExePath, const_OraOciDll32);
  if FileExists(lFileName) then
    Var_OracleDriverLink.VendorLib := lFileName;
  //
  lFileName := OneFileHelper.CombinePath(lExePath, const_Libmysql32);
  if FileExists(lFileName) then
    Var_MySQLDriverLink.VendorLib := lFileName;
  //
  lFileName := OneFileHelper.CombinePath(lExePath, const_Libpg32);
  if FileExists(lFileName) then
    var_PGDriverLink.VendorLib := lFileName;
  //
  lFileName := OneFileHelper.CombinePath(lExePath, const_Libfb32);
  if FileExists(lFileName) then
  begin
    var_FireBirdDriverLinK := TFDPhysFBDriverLink.Create(nil);
    var_FireBirdDriverLinK.VendorLib := lFileName;
  end;
  //
  lFileName := OneFileHelper.CombinePath(lExePath, const_Libfbb32);
  if FileExists(lFileName) then
  begin
    var_FireBirdDriverLinKB := TFDPhysFBDriverLink.Create(nil);
    var_FireBirdDriverLinKB.VendorLib := lFileName;
  end;
  //
  lFileName := OneFileHelper.CombinePath(lExePath, const_Lib3SQLite32);
  if FileExists(lFileName) then
  begin
    var_SQLiteDriverLinK.VendorLib := lFileName;
  end;
  //
  lFileName := OneFileHelper.CombinePath(lExePath, const_LibASA32);
  if FileExists(lFileName) then
  begin
    var_ASADriverLink.VendorLib := lFileName;
  end;
{$ELSEIF Defined(CPUX64)}
  lFileName := OneFileHelper.CombinePath(lExePath, const_OraOciDll64);
  if FileExists(lFileName) then
    Var_OracleDriverLink.VendorLib := lFileName;
  //
  lFileName := OneFileHelper.CombinePath(lExePath, const_Libmysql64);
  if FileExists(lFileName) then
    Var_MySQLDriverLink.VendorLib := lFileName;
  //
  lFileName := OneFileHelper.CombinePath(lExePath, const_Libpg64);
  if FileExists(lFileName) then
    var_PGDriverLink.VendorLib := lFileName;
  //
  lFileName := OneFileHelper.CombinePath(lExePath, const_Libfb64);
  if FileExists(lFileName) then
  begin
    var_FireBirdDriverLinK := TFDPhysFBDriverLink.Create(nil);
    var_FireBirdDriverLinK.VendorLib := lFileName;
  end;
  //
  lFileName := OneFileHelper.CombinePath(lExePath, const_Libfbb64);
  if FileExists(lFileName) then
  begin
    var_FireBirdDriverLinKB := TFDPhysFBDriverLink.Create(nil);
    var_FireBirdDriverLinKB.VendorLib := lFileName;
  end;
  //
  lFileName := OneFileHelper.CombinePath(lExePath, const_Lib3SQLite64);
  if FileExists(lFileName) then
  begin
    var_SQLiteDriverLinK.VendorLib := lFileName;
  end;
  //
  lFileName := OneFileHelper.CombinePath(lExePath, const_LibASA64);
  if FileExists(lFileName) then
  begin
    var_ASADriverLink.VendorLib := lFileName;
  end;
{$ENDIF CPUX64}
end;

procedure UnInitPhyDriver;
begin
  if Var_MSSQLDriverLink <> nil then
  begin
    Var_OracleDriverLink.Free;
    Var_MySQLDriverLink.Free;
    Var_MSSQLDriverLink.Free;
    Var_2000MSSQLDriverLink.Free;
    var_PGDriverLink.Free;
  end;
  if var_ODBCDriverLink <> nil then
    var_ODBCDriverLink.Free;
  if var_FireBirdDriverLinK <> nil then
    var_FireBirdDriverLinK.Free;
  if var_FireBirdDriverLinKB <> nil then
    var_FireBirdDriverLinKB.Free;
  if var_SQLiteDriverLinK <> nil then
    var_SQLiteDriverLinK.Free;
  if var_ASADriverLink <> nil then
    var_ASADriverLink.Free;
  if var_MSAccDriverLink <> nil then
    var_MSAccDriverLink.Free;
end;

function ClearOrderBySQL(QSQL: string): string;
var
  i: integer;
  lTempStr: String;
  lOrderIndex, lByIndex: integer;
begin
  lTempStr := '';
  lOrderIndex := -1;
  lByIndex := -1;
  for i := Low(QSQL) to High(QSQL) do
  begin
    if (QSQL[i] <> ' ') and (QSQL[i] <> Char(13)) and (QSQL[i] <> Char(10)) then
    begin
      lTempStr := lTempStr + QSQL[i];
    end
    else
    begin
      lTempStr := lTempStr.ToLower;
      if (lOrderIndex = -1) and (lTempStr = 'order') then
      begin
        lOrderIndex := i - 5;
      end
      else
      begin
        if (lOrderIndex > 0) then
        begin
          if lTempStr = 'by' then
          begin
            lByIndex := i - 2;
          end
          else if lTempStr = 'from' then
          begin
            if i > lOrderIndex then
            begin
              lOrderIndex := -1;
              lByIndex := -1;
            end;
          end
          else if (lByIndex = -1) and (Length(lTempStr) > 0) then
          begin
            lOrderIndex := -1;
          end;
        end;
      end;
      lTempStr := '';
    end;
  end;
  if lOrderIndex > 0 then
  begin
    Result := Copy(QSQL, Low(''), lOrderIndex - 1);
  end
  else
  begin
    Result := QSQL;
  end;
end;

initialization

finalization

UnInitPhyDriver;

end.

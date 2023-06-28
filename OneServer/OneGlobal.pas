unit OneGlobal;

// 一些共用的全局变量统一管理
interface

uses
  System.SysUtils, System.IOUtils, System.Generics.Collections, System.Classes,
  System.JSON, Rest.JSON, System.NetEncoding,
  OneHttpServer, OneZTManage, OneFileHelper, OneNeonHelper, OneTokenManage, OneVirtualFile,
  Neon.Core.Persistence, Neon.Core.Persistence.JSON, OneILog, OneLog, OneWebSocketServer;

type

  // 服务HTTP配置
  TOneServerSet = class
  private
    FHTTPPort: Integer; // HTTP端口
    FHTTPPool: Integer; // HTTP池数量
    FHTTPQueue: Integer; // HTTP队列大小
    FHTTPAutoWork: boolean; // 是否自启动
    FConnectSecretkey: string; // 连接安全密钥
    FTokenIntervalSec: Integer; // 连接有效安全时间,<=0代表无限长有效,但三天72小时必踢掉，如果没交互
    FWinTaskStart: boolean; // win随开机任务启动,无界面
    FWinRegisterStart: boolean; // win随开机进入界面启动,注册表方式
    FSuperAdminPass: string;
    //
    FIsHttps: boolean;
    FHttpsPort: Integer;
    FCertificateFile: string;
    FPrivateKeyFile: string;
    FCACertificatesFile: string;
    FPrivateKeyPassword: string;
    //
    FIsWs: boolean;
    FWsAutoStart: boolean;
    FWsPort: Integer;
    FWsPool: Integer;
    FWsQueue: Integer;
  public
    constructor Create;
  public
    property HTTPPort: Integer read FHTTPPort write FHTTPPort;
    property HTTPPool: Integer read FHTTPPool write FHTTPPool;
    property HTTPQueue: Integer read FHTTPQueue write FHTTPQueue;
    property HTTPAutoWork: boolean read FHTTPAutoWork write FHTTPAutoWork;
    property ConnectSecretkey: string read FConnectSecretkey write FConnectSecretkey;
    property TokenIntervalSec: Integer read FTokenIntervalSec write FTokenIntervalSec;
    property WinTaskStart: boolean read FWinTaskStart write FWinTaskStart;
    property WinRegisterStart: boolean read FWinRegisterStart write FWinRegisterStart;
    property SuperAdminPass: string read FSuperAdminPass write FSuperAdminPass;
    //
    property IsHttps: boolean read FIsHttps write FIsHttps;
    property HttpsPort: Integer read FHttpsPort write FHttpsPort;
    property CertificateFile: string read FCertificateFile write FCertificateFile;
    property PrivateKeyFile: string read FPrivateKeyFile write FPrivateKeyFile;
    property CACertificatesFile: string read FCACertificatesFile write FCACertificatesFile;
    property PrivateKeyPassword: string read FPrivateKeyPassword write FPrivateKeyPassword;
    //
    property IsWebSocket: boolean read FIsWs write FIsWs;
    property WsAutoStart: boolean read FWsAutoStart write FWsAutoStart;
    property WsPort: Integer read FWsPort write FWsPort;
    property WsPool: Integer read FWsPool write FWsPool;
    property WsQueue: Integer read FWsQueue write FWsQueue;
  end;

  TOneGlobal = class
  private
    // 服务端运行路径
    FExeRunPath: string;
    // 服务端运行EXE名称
    FExeName: string;
    // 日记:
    FLogSet: TOneLogSet;
    FLog: IOneLog;
    // 服务端配置
    FServerSet: TOneServerSet;
    // 账套管理配置
    FZTMangeSet: TOneZTMangeSet;
    // 虚拟目录配置
    FVirtualSet: TOneVirtualSet;
    // HTT服务
    FHTTPServer: TOneHttpServer;
    FWsServer: TOneWebSocketServer;
    // 账套管理服务
    FZTManage: TOneZTManage;
    // TOken管理服务
    FTokenManage: TOneTokenManage;
    //
    FVirtualManage: TOneVirtualManage;
    FIsConsole: boolean;
  public
    class function GetInstance(QIsConsole: boolean = false): TOneGlobal; static;
  public
    constructor Create();
    destructor Destroy; override;
    procedure IntiFile();
    function LoadLogSet(): boolean;
    function SaveLogSet(var QErrMsg: string): boolean;
    function LoadServerSet(): boolean;
    function SaveServerSet(var QErrMsg: string): boolean;
    function LoadZTMangeSet(): boolean;
    function SaveZTMangeSet(var QErrMsg: string): boolean;
    function LoadVirtualSet(): boolean;
    function SaveVirtualSet(var QErrMsg: string): boolean;
    //
    function HTTPServerStart(var QErrMsg: string): boolean;
    // 开始工作
    function StarWork(var QErrMsg: string): boolean;
  public
    property LogSet: TOneLogSet read FLogSet;
    property ServerSet: TOneServerSet read FServerSet;
    property ZTMangeSet: TOneZTMangeSet read FZTMangeSet;
    property VirtualSet: TOneVirtualSet read FVirtualSet;
    property HttpServer: TOneHttpServer read FHTTPServer;
    property WsServer: TOneWebSocketServer read FWsServer;
    property Log: IOneLog read FLog;
    property ZTManage: TOneZTManage read FZTManage;
    property TokenManage: TOneTokenManage read FTokenManage;
    property VirtualManage: TOneVirtualManage read FVirtualManage;
    property IsConsole: boolean read FIsConsole;
  end;

var
  const_OnePlatform: string = 'OnePlatform';
  const_OneSet: string = 'OneSet';

implementation

uses OneOrm, OneSQLCrypto;

var
  Unit_OneGlobal: TOneGlobal;

constructor TOneServerSet.Create;
begin
  inherited Create;
  FHTTPPort := 9090;
  FHTTPPool := 32;
  FHTTPQueue := 1000;
  FIsHttps := false;
  FHttpsPort := 9095;
  FIsWs := false;
  FWsPort := 9099;
end;

class function TOneGlobal.GetInstance(QIsConsole: boolean = false): TOneGlobal;
begin
  if Unit_OneGlobal = nil then
  begin
    Unit_OneGlobal := TOneGlobal.Create;
    Unit_OneGlobal.FIsConsole := QIsConsole;
  end;
  result := Unit_OneGlobal;
end;

constructor TOneGlobal.Create();
var
  lOneLog: TOneLog;
begin
  inherited Create;
  // 日记先实例化
  self.FExeRunPath := OneFileHelper.GetExeRunPath();
  self.FExeName := OneFileHelper.GetExeName;
  // 配置实例化
  self.FLogSet := TOneLogSet.Create;
  self.FServerSet := TOneServerSet.Create;
  self.FZTMangeSet := TOneZTMangeSet.Create;
  self.FVirtualSet := TOneVirtualSet.Create;
  self.IntiFile();
  // 加载日志配置
  self.LoadLogSet();
  // 创建日志
  lOneLog := TOneLog.Create(self.FLogSet);
  // 日志最先工作的
  lOneLog.StarWork;
  self.FLog := lOneLog;
  self.FLog._AddRef;
  // 加载HTTP配置
  self.LoadServerSet();
  // 加载账套配置
  self.LoadZTMangeSet();
  // 加载虚拟目录配置
  self.LoadVirtualSet();
  // 服务实例化
  FHTTPServer := TOneHttpServer.Create(self.FLog);
  FWsServer := TOneWebSocketServer.Create(self.FLog);
  FZTManage := TOneZTManage.Create(self.FLog);
  OneZTManage.Unit_ZTManage := FZTManage;
  FTokenManage := TOneTokenManage.Create(self.FLog);
  FTokenManage.TokenTimeOutSec := self.FServerSet.FTokenIntervalSec;
  FVirtualManage := TOneVirtualManage.Create();
  // 给ORM提供ZT取数据功能
  OneOrm.unit_OrmZTManage := self.FZTManage;
end;

destructor TOneGlobal.Destroy;
begin
  OneOrm.unit_OrmZTManage := nil;
  if FServerSet <> nil then
    FServerSet.Free;
  if FZTMangeSet <> nil then
    FZTMangeSet.Free;
  if FVirtualSet <> nil then
    FVirtualSet.Free;
  if FHTTPServer <> nil then
  begin
    FHTTPServer.Free;
  end;
  if FWsServer <> nil then
  begin
    FWsServer.Free;
  end;
  if FZTManage <> nil then
  begin
    FZTManage.Free;
  end;
  if FTokenManage <> nil then
  begin
    FTokenManage.Free;
  end;
  if FVirtualManage <> nil then
  begin
    FVirtualManage.Free;
  end;
  if FLog <> nil then
  begin
    FLog.StopWork;
    FLog._Release;
    FLog._Release;
  end;
  inherited Destroy;
end;

procedure TOneGlobal.IntiFile();
const
  // fireDac需要各自DLL驱动，把驱动放到Exe相关目录下面即可
  const_OraOciDll32: string = 'OnePhyDBDLL\OracleDll\32';
  const_OraOciDll64: string = 'OnePhyDBDLL\OracleDll\64';
  const_Libmysql32: string = 'OnePhyDBDLL\mySQLDLL\32';
  const_Libmysql64: string = 'OnePhyDBDLL\mySQLDLL\64';
  const_Libpg32: string = 'OnePhyDBDLL\pgDLL\32';
  const_Libpg64: string = 'OnePhyDBDLL\pgDLL\64';
  const_Libfb32: string = 'OnePhyDBDLL\fbDLL\32';
  const_Libfb64: string = 'OnePhyDBDLL\fbDLL\64';
  const_Libfbb32: string = 'OnePhyDBDLL\fbbDLL\32';
  const_Libfbb64: string = 'OnePhyDBDLL\fbbDLL\64';
  const_3SQLite32: string = 'OnePhyDBDLL\SQLite3\32';
  const_3SQLite64: string = 'OnePhyDBDLL\SQLite3\64';
  const_ASA32: string = 'OnePhyDBDLL\ASA\32';
  const_ASA64: string = 'OnePhyDBDLL\ASA\64';
  const_ODBC32: string = 'OnePhyDBDLL\ODBC\32';
  const_ODBC64: string = 'OnePhyDBDLL\ODBC\64';
var
  tempPath: string;
  lListPath: TList<string>;
  i: Integer;
begin
  tempPath := OneFileHelper.CombinePath(self.FExeRunPath, const_OnePlatform);
  if not DirectoryExists(tempPath) then
    ForceDirectories(tempPath);
  lListPath := TList<string>.Create;
  try
    // 配置默认目录
    lListPath.Add(const_OneSet);
    // 日记默认目录
    lListPath.Add('OneLogs');
    // 临时存储数据的
    lListPath.Add('OneDataTemp');
    lListPath.Add('OneWeb');
    // 更新目录
    lListPath.Add('OneFastUpload');
    // 服务端报表保存目录
    lListPath.Add('OneFastReport');
    lListPath.Add('OneFastReportExport');
    // 以下多是驱动的目录
    lListPath.Add(const_OraOciDll32);
    lListPath.Add(const_OraOciDll64);
    lListPath.Add(const_Libmysql32);
    lListPath.Add(const_Libmysql64);
    lListPath.Add(const_Libpg32);
    lListPath.Add(const_Libpg64);
    lListPath.Add(const_Libfb32);
    lListPath.Add(const_Libfb64);
    lListPath.Add(const_Libfbb32);
    lListPath.Add(const_Libfbb64);
    lListPath.Add(const_3SQLite32);
    lListPath.Add(const_3SQLite64);
    lListPath.Add(const_ASA32);
    lListPath.Add(const_ASA64);
    lListPath.Add(const_ODBC64);
    lListPath.Add(const_ODBC64);
    for i := 0 to lListPath.Count - 1 do
    begin
      tempPath := OneFileHelper.CombinePathC(self.FExeRunPath, const_OnePlatform, lListPath[i]);
      if not DirectoryExists(tempPath) then
        ForceDirectories(tempPath);
    end;
  finally
    lListPath.Clear;
    lListPath.Free;
  end;
end;

function TOneGlobal.LoadLogSet(): boolean;
var
  lLogSetFileName, lErrMsg: string;
begin
  lLogSetFileName := OneFileHelper.CombinePathD(self.FExeRunPath, const_OnePlatform, const_OneSet, 'OneLogSet.JSON');
  // 加载配置
  OneNeonHelper.JSONToObjectFormFile(self.FLogSet, lLogSetFileName, lErrMsg);
  // 序列化
  OneNeonHelper.ObjectToJsonFile(self.FLogSet, lLogSetFileName, lErrMsg);
end;

function TOneGlobal.SaveLogSet(var QErrMsg: string): boolean;
var
  lLogSetFileName: string;
begin
  lLogSetFileName := OneFileHelper.CombinePathD(self.FExeRunPath, const_OnePlatform, const_OneSet, 'OneLogSet.JSON');
  result := OneNeonHelper.ObjectToJsonFile(self.FLogSet, lLogSetFileName, QErrMsg);
end;

function TOneGlobal.LoadServerSet(): boolean;
var
  lServerSetFileName, lErrMsg: string;
begin
  lServerSetFileName := OneFileHelper.CombinePathD(self.FExeRunPath, const_OnePlatform, const_OneSet, 'OneServerSet.JSON');
  // 加载配置
  OneNeonHelper.JSONToObjectFormFile(self.FServerSet, lServerSetFileName, lErrMsg);
  // 序列化
  OneNeonHelper.ObjectToJsonFile(self.FServerSet, lServerSetFileName, lErrMsg);
  // self.SaveServerSet(lErrMsg);
  // 保存
  self.FServerSet.SuperAdminPass := OneSQLCrypto.SwapDecodeCrypto(self.FServerSet.SuperAdminPass);
end;

function TOneGlobal.SaveServerSet(var QErrMsg: string): boolean;
var
  lServerSetFileName: string;
  lSuperAdminPass: string;
begin
  lSuperAdminPass := self.FServerSet.SuperAdminPass;
  try
    self.FServerSet.SuperAdminPass := OneSQLCrypto.SwapCrypto(self.FServerSet.SuperAdminPass);
    lServerSetFileName := OneFileHelper.CombinePathD(self.FExeRunPath, const_OnePlatform, const_OneSet, 'OneServerSet.JSON');
    result := OneNeonHelper.ObjectToJsonFile(self.FServerSet, lServerSetFileName, QErrMsg);
  finally
    self.FServerSet.SuperAdminPass := lSuperAdminPass;
  end;
end;

function TOneGlobal.StarWork(var QErrMsg: string): boolean;
begin
  result := false;
  QErrMsg := '';
  if self.IsConsole then
    writeln('**启动账套**');
  if FZTManage <> nil then
  begin
    if FZTMangeSet.AutoWork then
    begin
      // 开启添加账套
      FZTManage.StarWork(FZTMangeSet.ZTSetList, QErrMsg);
      if self.IsConsole then
        writeln('启动账套成功');
    end
    else
    begin
      if self.IsConsole then
        writeln('账套未启动,原因账套设置不是自启动');
    end;
  end;
  if self.IsConsole then
    writeln('**启动HTTP服务**');
  if FHTTPServer <> nil then
  begin
    if self.IsConsole then
      writeln('HTTP端口:' + IntToStr(FServerSet.FHTTPPort));
    FHTTPServer.Port := FServerSet.FHTTPPort;
    FHTTPServer.ThreadPoolCount := FServerSet.FHTTPPool;
    FHTTPServer.HttpQueueLength := FServerSet.FHTTPQueue;
    if FServerSet.FHTTPAutoWork then
    begin
      if not FHTTPServer.ServerStart then
      begin
        QErrMsg := FHTTPServer.ErrMsg;
        if self.IsConsole then
          writeln('启动HTTP异常原因:' + QErrMsg);
      end
      else
      begin
        if self.IsConsole then
          writeln('启动HTTP服务成功');
      end;
    end
    else
    begin
      if self.IsConsole then
        writeln('HTTP服务未启动,原因HTTP服务设置不是自启动');
    end;
  end;
  if self.FWsServer <> nil then
  begin
    if self.IsConsole then
      writeln('WebSocket端口:' + IntToStr(FServerSet.FWsPort));
    self.FWsServer.Port := FServerSet.FWsPort;
    self.FWsServer.ThreadPoolCount := FServerSet.FWsPool;
    self.FWsServer.HttpQueueLength := FServerSet.FWsQueue;
    if FServerSet.FWsAutoStart then
    begin
      if not FWsServer.ServerStart then
      begin
        QErrMsg := FWsServer.ErrMsg;
        if self.IsConsole then
          writeln('启动Ws异常原因:' + QErrMsg);
      end
      else
      begin
        if self.IsConsole then
          writeln('启动Ws服务成功');
      end;
    end
    else
    begin
      if self.IsConsole then
        writeln('Ws服务未启动,原因Ws服务设置不是自启动');
    end;
  end;

  if FVirtualManage <> nil then
  begin
    FVirtualManage.StarWork(self.FVirtualSet.VirtualSetList);
  end;
  result := true;
end;

function TOneGlobal.LoadZTMangeSet(): boolean;
var
  lZTMangeSetFileName, lErrMsg: string;

begin
  // 读取配置
  lZTMangeSetFileName := OneFileHelper.CombinePathD(self.FExeRunPath, const_OnePlatform, const_OneSet, 'OneZTMangeSet.JSON');
  OneNeonHelper.JSONToObjectFormFile(self.FZTMangeSet, lZTMangeSetFileName, lErrMsg);
  // 保存配置
  OneNeonHelper.ObjectToJsonFile(self.FZTMangeSet, lZTMangeSetFileName, lErrMsg);
end;

function TOneGlobal.SaveZTMangeSet(var QErrMsg: string): boolean;
var
  lZTMangeSetFileName: string;
begin
  lZTMangeSetFileName := OneFileHelper.CombinePathD(self.FExeRunPath, const_OnePlatform, const_OneSet, 'OneZTMangeSet.JSON');
  result := OneNeonHelper.ObjectToJsonFile(self.FZTMangeSet, lZTMangeSetFileName, QErrMsg);
end;

function TOneGlobal.LoadVirtualSet(): boolean;
var
  lVirtualSetFileName, lErrMsg: string;

begin
  // 读取配置
  lVirtualSetFileName := OneFileHelper.CombinePathD(self.FExeRunPath, const_OnePlatform, const_OneSet, 'OneVirtualSet.JSON');
  OneNeonHelper.JSONToObjectFormFile(self.FVirtualSet, lVirtualSetFileName, lErrMsg);
  // 保存配置
  OneNeonHelper.ObjectToJsonFile(self.FVirtualSet, lVirtualSetFileName, lErrMsg);
end;

function TOneGlobal.SaveVirtualSet(var QErrMsg: string): boolean;
var
  lVirtualSetFileName: string;
begin
  lVirtualSetFileName := OneFileHelper.CombinePathD(self.FExeRunPath, const_OnePlatform, const_OneSet, 'OneVirtualSet.JSON');
  result := OneNeonHelper.ObjectToJsonFile(self.FVirtualSet, lVirtualSetFileName, QErrMsg);
end;

function TOneGlobal.HTTPServerStart(var QErrMsg: string): boolean;
begin
  result := false;
  QErrMsg := '';
  if FHTTPServer.Started then
  begin
    QErrMsg := '已运行，无需在运行，当前运行端口:' + FHTTPServer.Port.ToString();
    exit;
  end;
  //
  FHTTPServer.Port := FServerSet.FHTTPPort;
  FHTTPServer.HttpsPort := FServerSet.FHttpsPort;
  FHTTPServer.ThreadPoolCount := FServerSet.FHTTPPool;
  FHTTPServer.HttpQueueLength := FServerSet.FHTTPQueue;
  if not FHTTPServer.ServerStart then
  begin
    QErrMsg := FHTTPServer.ErrMsg;
    exit;
  end;
  result := true;
end;

end.

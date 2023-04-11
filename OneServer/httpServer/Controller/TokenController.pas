unit TokenController;

interface

uses OneHttpController, OneHttpRouterManage, OneHttpCtxtResult, OneTokenManage,
  system.Generics.Collections, OneControllerResult;

type
  TClientConnect = record
  public
    ConnectSecretkey: string;
    ClientIP: string; // 客户端传上来的客户端IP
    ClientMac: string; // 客户端传上来的客户端Mac地址
    TokenID: string; // 服务端返回的TokenID
    PrivateKey: string; // 服务端返回的私钥
  end;

  TClientLogin = record
  public
    TokenID: string; // ClientConnect返回的tokenID如果有先进行 ClientConnect, 有的话进行绑定
    LoginUserCode: string;
    LoginPass: string;
  end;

  TOneTokenController = class(TOneControllerBase)
  public
    function ClientConnect(QCleintConnect: TClientConnect): TActionResult<TClientConnect>;
    function ClientDisConnect(TokenID: string): TActionResult<string>;
    function ClientPing(): TActionResult<string>;
    function ClientConnectPing(QCleintConnect: TClientConnect): TActionResult<string>;
    // 批量产生UUIDs
    function GetUUID(): TActionResult<Int64>;
    function GetUUIDs(QCount: Integer): TActionResult<TList<Int64>>;
  end;

function CreateNewOneTokenController(QRouterItem: TOneRouterWorkItem): TObject;

implementation

uses OneGlobal, OneUUID;

function CreateNewOneTokenController(QRouterItem: TOneRouterWorkItem): TObject;
var
  lController: TOneTokenController;
begin
  // 自定义创建控制器类，否则会按 TPersistentclass.create
  // 最好自定义一个好
  lController := TOneTokenController.Create;
  // 挂载RTTI信息
  lController.RouterItem := QRouterItem;
  result := lController;
end;

function TOneTokenController.ClientConnect(QCleintConnect: TClientConnect): TActionResult<TClientConnect>;
var
  lOneGlobal: TOneGlobal;
  lTokenItem: TOneTokenItem;
  lList: TList<TOneTokenItem>;
  i: Integer;
begin
  // 结构体会自动释放,设成true,false多一样
  result := TActionResult<TClientConnect>.Create(false, false);
  lOneGlobal := TOneGlobal.GetInstance();
  if lOneGlobal.ServerSet.ConnectSecretkey <> QCleintConnect.ConnectSecretkey then
  begin
    // 安全密钥不一至
    result.ResultMsg := '安全密钥不一至,无法连接服务端!!!';
    exit;
  end;
  lTokenItem := lOneGlobal.TokenManage.AddNewToken();
  lTokenItem.LoginIP := QCleintConnect.ClientIP;
  lTokenItem.LoginMac := QCleintConnect.ClientMac;
  QCleintConnect.TokenID := lTokenItem.TokenID;
  QCleintConnect.PrivateKey := lTokenItem.PrivateKey;
  QCleintConnect.ConnectSecretkey := '';
  result.ResultData := QCleintConnect;
  result.SetResultTrue();
end;

function TOneTokenController.ClientDisConnect(TokenID: string): TActionResult<string>;
var
  lOneGlobal: TOneGlobal;
begin
  result := TActionResult<string>.Create(false, false);
  lOneGlobal := TOneGlobal.GetInstance();
  lOneGlobal.TokenManage.RemoveToken(TokenID);
  result.ResultData := 'Token删除成功';
  result.SetResultTrue();
end;

function TOneTokenController.ClientPing(): TActionResult<string>;
begin
  result := TActionResult<string>.Create(false, false);
  result.ResultData := '';
  result.SetResultTrue();
end;

function TOneTokenController.ClientConnectPing(QCleintConnect: TClientConnect): TActionResult<string>;
var
  lOneGlobal: TOneGlobal;
  lTokenItem: TOneTokenItem;
begin
  result := TActionResult<string>.Create(false, false);
  lOneGlobal := TOneGlobal.GetInstance();
  if lOneGlobal.ServerSet.ConnectSecretkey <> QCleintConnect.ConnectSecretkey then
  begin
    // 安全密钥不一至
    result.ResultMsg := '安全密钥不一至,无法连接服务端!!!';
    exit;
  end;
  result.ResultData := '';
  result.SetResultTrue();
end;

//只取一个
function TOneTokenController.GetUUID(): TActionResult<Int64>;
begin
  result := TActionResult<Int64>.Create(false, false);
  result.ResultData := OneUUID.GetUUID();
  result.SetResultTrue();
end;

// 一次性取多少个ID到服务端
function TOneTokenController.GetUUIDs(QCount: Integer): TActionResult<TList<Int64>>;
var
  i: Integer;
begin
  result := TActionResult < TList < Int64 >>.Create(true, false);
  if QCount <= 0 then
  begin
    QCount := 1;
  end;
  result.ResultData := TList<Int64>.Create;
  for i := 0 to QCount - 1 do
  begin
    result.ResultData.Add(OneUUID.GetUUID());
  end;
  result.SetResultTrue();
end;

initialization

// 单例模式注册
OneHttpRouterManage.GetInitRouterManage().AddHTTPSingleWork('/OneServer/Token', TOneTokenController, 0, CreateNewOneTokenController);

finalization

end.

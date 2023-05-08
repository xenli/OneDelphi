unit OneWsChatController;

{ Ws互发消息单元 }
interface

uses
  system.StrUtils, system.SysUtils, Math, system.JSON, system.Threading, system.Classes,
  OneHttpController, OneHttpRouterManage, OneHttpCtxtResult, OneTokenManage, OneHttpConst,
  system.Generics.Collections, OneControllerResult, FireDAC.Comp.Client, Data.DB, OneGuID,
  OneMultipart;

type
  TWsChatController = class(TOneControllerBase)
  public
    // 获取在线用户
    function GetOnLineUsers(): TActionResult<TList<TWsToken>>;
    // 发消息给其它用户
    function SendMsgToUser(QMsgID: string; QToUserID: int64; QToUserMsg: string): TActionResult<string>;
  end;

implementation

uses OneGlobal, OneFastLshManage, OneWebSocketServer;

function CreateNewWsChatController(QRouterItem: TOneRouterWorkItem): Tobject;
var
  lController: TWsChatController;
begin
  // 自定义创建控制器类，否则会按 TPersistentclass.create
  // 最好自定义一个好
  lController := TWsChatController.Create;
  // 挂载RTTI信息
  lController.RouterItem := QRouterItem;
  result := lController;
end;

function TWsChatController.GetOnLineUsers(): TActionResult<TList<TWsToken>>;
var
  lErrMsg: string;
  lOneGlobal: TOneGlobal;
  lWsServer: TOneWebSocketServer;
begin
  result := TActionResult < TList < TWsToken >>.Create(true, true);
  lOneGlobal := OneGlobal.TOneGlobal.GetInstance();
  lWsServer := lOneGlobal.WsServer;
  result.ResultData := lWsServer.GetWsTokenList();
  result.SetResultTrue();
end;

function TWsChatController.SendMsgToUser(QMsgID: string; QToUserID: int64; QToUserMsg: string): TActionResult<string>;
var
  lErrMsg: string;
  lOneGlobal: TOneGlobal;
  lWsServer: TOneWebSocketServer;
begin
  result := TActionResult<string>.Create(false, false);
  lOneGlobal := OneGlobal.TOneGlobal.GetInstance();
  lWsServer := lOneGlobal.WsServer;
  // 这边一般放在消息队列好点,由服务端队列发送,同时客户端确认收到消息,返回客户端
  // 后面在搞吧
  lWsServer.SendMsg(QToUserID, QToUserMsg);
  result.SetResultTrue;
end;

initialization

// 单例模式注册
OneHttpRouterManage.GetInitRouterManage().AddHTTPSingleWork('OneServer/WsChat', TWsChatController,
  0, CreateNewWsChatController);

finalization

end.

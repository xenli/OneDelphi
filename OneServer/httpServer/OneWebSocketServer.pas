unit OneWebSocketServer;

interface

uses mormot.net.ws.async, system.StrUtils, system.Classes, system.SysUtils,
  mormot.net.ws.core, oneILog, system.Generics.Collections;

type
  TOneWebSocketProtocol = class;
  TOneWebSocketServer = class;

  TOneWebSocketProtocol = class(TWebSocketProtocolChat)
  private
    FOwnerWebSocketMgr: TOneWebSocketServer;
  protected
    procedure DoIncomingFrame(Sender: TWebSocketProcess; const Frame: TWebSocketFrame);
  end;

  TOneWebSocketServer = class
  private
    // HTTP服务是否启动
    FStarted: boolean;
    // 拒绝请求
    FStopRequest: boolean;
    // 绑定HTTP端口，默认9090
    FPort: integer;
    // 线程池 ThreadPoolCount<0 将使用单个线程来对其进行全部规则, =0将为每个连接创建一个线程,>0将利用线程池
    // 一般设定大于0用线程池性能最好
    FThreadPoolCount: integer;
    // 队列默认1000,请求放进队列,然后有线程消费完成
    FHttpQueueLength: integer;
    // 默认30000毫秒，即30秒 连接保持活动的时间
    FKeepAliveTimeOut: integer;
    FWebSocketServer: TWebSocketAsyncServer;
    //
    FLog: IOneLog;
    FConnectionList: TDictionary<Int64, string>;
    // 错误消息
    FErrMsg: string;
  protected
  public
    constructor Create(QLog: IOneLog); overload;
    destructor Destroy; override;
  public
    // 启动服务
    function ServerStart(): boolean;
    // 停止服务
    function ServerStop(): boolean;
    // 拒绝任何请求
    function ServerStopRequest(): boolean;
    function SendMsgAll(QMsg: RawByteString): boolean;
    function SendMsg(QConnectionID: Int64; QMsg: RawByteString): boolean;
    function SendFrame(QConnectionID: Int64; QFrame: TWebSocketFrame): boolean;
  published
    // HTTP服务是否启动
    property Started: boolean read FStarted;
    // 拒绝请求
    property StopRequest: boolean read FStopRequest;
    // 绑定HTTP端口，默认9090
    property Port: integer read FPort write FPort;
    // 线程池
    property ThreadPoolCount: integer read FThreadPoolCount
      write FThreadPoolCount;
    // 队列默认1000,请求放进队列,然后有线程消费完成
    property HttpQueueLength: integer read FHttpQueueLength write FHttpQueueLength;
    // 默认30000毫秒，即30秒 连接保持活动的时间
    property KeepAliveTimeOut: integer read FKeepAliveTimeOut
      write FKeepAliveTimeOut;
    // 错误消息
    property ErrMsg: string read FErrMsg write FErrMsg;
  end;

implementation

procedure TOneWebSocketProtocol.DoIncomingFrame(Sender: TWebSocketProcess; const Frame: TWebSocketFrame);
var
  lResultFrame: TWebSocketFrame;
begin
  //
  case Frame.opcode of
    focContinuation:
      begin
        // 连接ID
        TThread.CreateAnonymousThread(
          procedure()
          begin
            sleep(1000);
            lResultFrame.opcode := focText;
            lResultFrame.content := [];
            lResultFrame.payload := UTF8Encode('连接服务器成功;');
            Self.SendFrame(Sender, lResultFrame);
          end
          ).Start;
      end;
    focConnectionClose:
      begin
        // 中断连接
      end;
    focText, focBinary:
      begin
        // 收到数据直接处理    Frame.payload
        // 自已的事件，不走下面火神的事件，全屏B掉
        lResultFrame.opcode := focText;
        lResultFrame.content := [];
        lResultFrame.payload := '';
        Self.SendFrame(Sender, lResultFrame);
      end;
  end;
end;

//
constructor TOneWebSocketServer.Create(QLog: IOneLog);
begin
  inherited Create;
  Self.FLog := QLog;
  Self.FStarted := false;
  Self.FStopRequest := false;
  Self.FPort := 9099;
  Self.FThreadPoolCount := 32;
  Self.FHttpQueueLength := 1000;
  Self.FKeepAliveTimeOut := 30000;
  Self.FWebSocketServer := nil;
  Self.FConnectionList := TDictionary<Int64, string>.Create();
end;

destructor TOneWebSocketServer.Destroy;
begin
  if FWebSocketServer <> nil then
  begin
    try
      FWebSocketServer.Free;
    except

    end;
  end;
  FConnectionList.Clear;
  FConnectionList.Free;
  inherited Destroy;
end;

// 启动服务
function TOneWebSocketServer.ServerStart(): boolean;
var
  lWSProtocol: TOneWebSocketProtocol;
begin
  result := false;
  // 已经启动
  if FStarted then
  begin
    Self.FErrMsg := 'WS服务已启动无需在启动';
    exit;
  end;
  if (Self.FPort <= 0) then
  begin
    Self.FErrMsg := 'WS服务端口未设置,请先设置,当前绑定端口【' + Self.FPort.toString() + '】';
    exit;
  end;
  if Self.FThreadPoolCount > 1000 then
    Self.FThreadPoolCount := 1000;
  // 创建HTTP服务
  try
    Self.FWebSocketServer := TWebSocketAsyncServer.Create(Self.FPort.toString(),
      nil, nil, 'OneWebSocket', Self.FThreadPoolCount, Self.FKeepAliveTimeOut);
    lWSProtocol := TOneWebSocketProtocol.Create('onews', 'onews');
    lWSProtocol.OnIncomingFrame := lWSProtocol.DoIncomingFrame;
    // 增加句柄
    Self.FWebSocketServer.WebSocketProtocols.Add(lWSProtocol);
    Self.FWebSocketServer.HttpQueueLength := Self.FHttpQueueLength;
    Self.FWebSocketServer.WaitStarted;
    Self.FStopRequest := false;
    Self.FStarted := true;
    result := true;
  except
    on e: Exception do
    begin
      Self.FErrMsg := '启动服务器失败,原因:' + e.Message +
        ';解决方案可偿试管理员启动程序或换个端口临听（端口重复绑定）。';
    end;
  end;

end;

// 停止服务
function TOneWebSocketServer.ServerStop(): boolean;
begin
  result := false;
  if Self.FWebSocketServer <> nil then
  begin
    Self.FWebSocketServer.Free;
    Self.FWebSocketServer := nil;
  end;
  Self.FStarted := false;
  result := true;
end;

// 拒绝任何请求
function TOneWebSocketServer.ServerStopRequest(): boolean;
begin
  // 返回  HTTP_NOTFOUND 404
  result := false;
  Self.FStopRequest := true;
  result := true;
end;

function TOneWebSocketServer.SendMsgAll(QMsg: RawByteString): boolean;
var
  lFrame: TWebSocketFrame;
  lWsConnection: TWebSocketAsyncConnection;
begin
  result := false;
  lFrame.opcode := focText;
  lFrame.content := [];
  lFrame.payload := QMsg;
  lWsConnection := nil;
  FWebSocketServer.WebSocketBroadcast(lFrame, nil);
  result := true;
end;

function TOneWebSocketServer.SendMsg(QConnectionID: Int64; QMsg: RawByteString): boolean;
var
  lFrame: TWebSocketFrame;
  lWsConnection: TWebSocketAsyncConnection;
begin
  result := false;
  lFrame.opcode := focText;
  lFrame.content := [];
  lFrame.payload := QMsg;
  lWsConnection := nil;
  FWebSocketServer.WebSocketBroadcast(lFrame, [QConnectionID]);
  result := true;
end;

function TOneWebSocketServer.SendFrame(QConnectionID: Int64; QFrame: TWebSocketFrame): boolean;
begin
  result := false;
  FWebSocketServer.WebSocketBroadcast(QFrame, [QConnectionID]);
  result := true;
end;

end.

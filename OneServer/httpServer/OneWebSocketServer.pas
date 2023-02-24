unit OneWebSocketServer;

interface

uses mormot.net.ws.async, system.StrUtils, system.Classes, system.SysUtils,
  mormot.net.ws.core;

type
  TOneWebSocketProtocol = class;
  TOneWebSocketServer = class;

  TOneWebSocketProtocol = class(TWebSocketProtocolChat)
  private
    FOwnerWebSocketMgr: TOneWebSocketServer;
  protected
    procedure OnIncomingFrame(Sender: TWebSocketProcess;
      const Frame: TWebSocketFrame);
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
    // 默认30000毫秒，即30秒 连接保持活动的时间
    FKeepAliveTimeOut: integer;
    FWebSocketServer: TWebSocketAsyncServer;
    // 错误消息
    FErrMsg: string;
  protected
  public
    constructor Create;
    destructor Destroy; override;
  public
    // 启动服务
    function ServerStart(): boolean;
    // 停止服务
    function ServerStop(): boolean;
    // 拒绝任何请求
    function ServerStopRequest(): boolean;
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
    // 默认30000毫秒，即30秒 连接保持活动的时间
    property KeepAliveTimeOut: integer read FKeepAliveTimeOut
      write FKeepAliveTimeOut;
    // 错误消息
    property ErrMsg: string read FErrMsg write FErrMsg;
  end;

implementation

procedure TOneWebSocketProtocol.OnIncomingFrame(Sender: TWebSocketProcess;
  const Frame: TWebSocketFrame);
begin

end;

//
constructor TOneWebSocketServer.Create;
begin
  inherited Create;
  self.FStarted := false;
  self.FStopRequest := false;
  self.FPort := 9090;
  self.FThreadPoolCount := 32;
  self.FKeepAliveTimeOut := 30000;
  FWebSocketServer := nil;
end;

destructor TOneWebSocketServer.Destroy;
begin
  if FWebSocketServer <> nil then
  begin
    FWebSocketServer.Free;
  end;
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
    self.FErrMsg := 'WS服务已启动无需在启动';
    exit;
  end;
  if (self.FPort <= 0) then
  begin
    self.FErrMsg := 'WS服务端口未设置,请先设置,当前绑定端口【' + self.FPort.toString() + '】';
    exit;
  end;
  if self.FThreadPoolCount > 1000 then
    self.FThreadPoolCount := 1000;
  // 创建HTTP服务
  try
    self.FWebSocketServer := TWebSocketAsyncServer.Create(self.FPort.toString(),
      nil, nil, 'OneWebSocket', self.FThreadPoolCount, self.FKeepAliveTimeOut);
    lWSProtocol := TOneWebSocketProtocol.Create('onews', 'onews');
    //增加句柄
    self.FWebSocketServer.WebSocketProtocols.Add(lWSProtocol);
    self.FWebSocketServer.WaitStarted;
    self.FStopRequest := false;
    self.FStarted := true;
    result := true;
  except
    on e: Exception do
    begin
      self.FErrMsg := '启动服务器失败,原因:' + e.Message +
        ';解决方案可偿试管理员启动程序或换个端口临听（端口重复绑定）。';
    end;
  end;

end;

// 停止服务
function TOneWebSocketServer.ServerStop(): boolean;
begin
  result := false;
  if self.FWebSocketServer <> nil then
  begin
    self.FWebSocketServer.Free;
    self.FWebSocketServer := nil;
  end;
  self.FStarted := false;
  result := true;
end;

// 拒绝任何请求
function TOneWebSocketServer.ServerStopRequest(): boolean;
begin
  // 返回  HTTP_NOTFOUND 404
  result := false;
  self.FStopRequest := true;
  result := true;
end;

end.

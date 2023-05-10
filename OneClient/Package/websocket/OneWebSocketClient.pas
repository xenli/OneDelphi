unit OneWebSocketClient;

{ 尊重原著，参考开源地址：https://github.com/mateusvicente100/bird-socket-client }
interface

uses
  System.Classes, System.SyncObjs, System.SysUtils, System.Math, System.Threading, System.DateUtils,
  IdURI, IdGlobal, IdTCPClient, IdSSLOpenSSL, IdCoderMIME, IdHashSHA, System.JSON,
  IdIOHandler, IdIOHandlerStream, IdIOHandlerSocket, IdIOHandlerStack, IdStack, OneClientConst,
  System.Generics.Collections, OneClientConnect, OneClientResult, System.NetEncoding;

const
  // 流水号获取相关功能
  URL_HTTPServer_WsChat_GetOnLineUsers = 'OneServer/WsChat/GetOnLineUsers';
  URL_HTTPServer_WsChat_SendMsgToUser = 'OneServer/WsChat/SendMsgToUser';
  WsMsg_cmd_toUserMsg = 'ToUserMsg';
  WsMsg_cmd_ServerNotify = 'ServerNotify';
  WsMsg_cmd_WsUserIDGet = 'WsUserIDGet';

type
  TWsUser = class;
  TWsMsg = class;
  TOperationCode = (CONTINUE, TEXT_FRAME, BINARY_FRAME, CONNECTION_CLOSE, PING, PONG);

  TOneWsExceptEvent = procedure(QExcept: Exception) of object;
  TOneWsMsgEvnet = procedure(QWsMsg: TWsMsg) of object;

  TOperationCodeHelper = record helper for TOperationCode
    function ToByte: Byte;
  end;

  TWsUser = class
  private
    FWsUserID: string;
    FOneTokenID: string; // TOneTokenItem
    FUserName: string;
  published
    property WsUserID: string read FWsUserID write FWsUserID;
    property OneTokenID: string read FOneTokenID write FOneTokenID;
    property UserName: string read FUserName write FUserName;
  end;

  TWsMsg = class
  private
    // 消息ID
    FMsgID: string;
    //
    FControllerRoot: string;
    // 发送者ConnectionID,''代表发送出去,基它值代表是接收到消息
    FFromUserID: string;
    FFromUserName: string;
    // 接收者ConnectionID
    FToUserID: string;
    // 消息成功失败代码
    FMsgCode: string;
    //
    FMsgCmd: string;
    // 消息
    FMsgData: string;
    // 消息时间
    FMsgTime: string;
  published
    property MsgID: string read FMsgID write FMsgID;
    property ControllerRoot: string read FControllerRoot write FControllerRoot;
    property FromUserID: string read FFromUserID write FFromUserID;
    property FromUserName: string read FFromUserName write FFromUserName;
    property ToUserID: string read FToUserID write FToUserID;
    property MsgCode: string read FMsgCode write FMsgCode;
    property MsgCmd: string read FMsgCmd write FMsgCmd;
    property MsgData: string read FMsgData write FMsgData;
    property MsgTime: string read FMsgTime write FMsgTime;
  end;

  [ComponentPlatformsAttribute(OneAllPlatforms)]
  TOneWebSocketClient = class(TComponent)
  private
    FHttpConnection: TOneConnection;
    FTCPClient: TIdTCPClient;
    FIsWss: boolean;
    FWsHost: string;
    FWsPort: integer;
    FWsProtocol: string;
    FUpgraded: boolean;
    // Ws用户ID
    FWsUserID: string;
    //
    FInternalLock: TCriticalSection;
    FIOHandler: TIdIOHandler;
    FSecWebSocketAcceptExpectedResponse: string;
    //
    FTaskReadFromWebSocket: ITask;
    // 相关事件
    FOnReceiveMessage: TGetStrProc;
    FOnOneWsMsg: TOneWsMsgEvnet;
    FOnWsUserIDGet: TGetStrProc;
    FOnErr: TOneWsExceptEvent;
    // 用户获取
    FUserList: TList<TWsUser>;
    // 缓存多少条消息，-1代表无限大,默认500条消息
    FCachMsgCount: integer;
    // 缓存的消息列表
    FMsgList: TList<TWsMsg>;
    //
    //
    FErrMsg: string;
  private
    procedure SetIOHandler(AValue: TIdIOHandler);
    function GenerateWebSocketKey: string;
    procedure SetSecWebSocketAcceptExpectedResponse(const AValue: string);
    // 接收到服务端消息分析
    function IsValidWebSocket: boolean;
    function IsValidHeaders(const AHeaders: TStrings): boolean;
    procedure ReadFromWebSocket;
    //
    function GetBit(const AValue: Cardinal; const AByte: Byte): boolean;
    function SetBit(const AValue: Cardinal; const AByte: Byte): Cardinal;
    function ClearBit(const AValue: Cardinal; const AByte: Byte): Cardinal;
    function EncodeFrame(const AMessage: string; const AOperationCode: TOperationCode = TOperationCode.TEXT_FRAME): TIdBytes;
    //
    procedure HandleException(const AException: Exception);

    procedure ReceiveMsgHandle(QMsg: string);
    procedure AddWsMsg(QWsMsg: TWsMsg);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  public
    function DoConnect(): boolean;
    procedure DisConnect();
    function Connected: boolean;
    function SendMessage(const AMessage: string): boolean;
    function GetUserList(): boolean;
    function SendMsgToUser(QUserID: string; QMsg: string): boolean;
  public
    property MsgList: TList<TWsMsg> read FMsgList;
    property UserList: TList<TWsUser> read FUserList;
    property WsUserID: string read FWsUserID;
  published
    property HttpConnection: TOneConnection read FHttpConnection write FHttpConnection;
    property TCPClient: TIdTCPClient read FTCPClient;
    property IsWss: boolean read FIsWss write FIsWss;
    property WsHost: string read FWsHost write FWsHost;
    property WsPort: integer read FWsPort write FWsPort;
    property WsProtocol: string read FWsProtocol write FWsProtocol;
    property IOHandler: TIdIOHandler read FIOHandler write SetIOHandler;
    property OnReceiveMessage: TGetStrProc read FOnReceiveMessage write FOnReceiveMessage;
    property OnOneWsMsg: TOneWsMsgEvnet read FOnOneWsMsg write FOnOneWsMsg;
    property OnWsUserIDGet: TGetStrProc read FOnWsUserIDGet write FOnWsUserIDGet;
    property OnErr: TOneWsExceptEvent read FOnErr write FOnErr;
    property ErrMsg: string read FErrMsg write FErrMsg;
  end;

implementation

uses OneNeonHelper, OneFunc;

function TOperationCodeHelper.ToByte: Byte;
begin
  case Self of
    TOperationCode.CONTINUE:
      Result := $0;
    TOperationCode.TEXT_FRAME:
      Result := $1;
    TOperationCode.BINARY_FRAME:
      Result := $2;
    TOperationCode.CONNECTION_CLOSE:
      Result := $8;
    TOperationCode.PING:
      Result := $9;
    TOperationCode.PONG:
      Result := $A;
  else
    Result := $0;
  end;
end;

{ TOneWebSocketClient }
constructor TOneWebSocketClient.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FInternalLock := TCriticalSection.Create;
  FTCPClient := TIdTCPClient.Create(nil);
  FWsProtocol := 'Onews';
  FUserList := TList<TWsUser>.Create;
  FCachMsgCount := 500;
  FMsgList := TList<TWsMsg>.Create;
end;

destructor TOneWebSocketClient.Destroy;
var
  i: integer;
begin
  //
  Self.DisConnect();
  for i := 0 to Self.FUserList.Count - 1 do
  begin
    Self.FUserList[i].Free;
  end;
  Self.FUserList.Clear;
  Self.FUserList.Free;

  for i := 0 to Self.FMsgList.Count - 1 do
  begin
    Self.FMsgList[i].Free;
  end;
  Self.FMsgList.Clear;
  Self.FMsgList.Free;

  FTCPClient.Free;
  FInternalLock.Free;
  FTaskReadFromWebSocket := nil;
  inherited Destroy;
end;

procedure TOneWebSocketClient.SetIOHandler(AValue: TIdIOHandler);
begin
  Self.FIOHandler := AValue;
  Self.FTCPClient.IOHandler := Self.FIOHandler;
end;

function TOneWebSocketClient.GenerateWebSocketKey: string;
var
  LBytes: TIdBytes;
  i: integer;
begin
  SetLength(LBytes, 16);
  for i := Low(LBytes) to High(LBytes) do
    LBytes[i] := Byte(random(255));
  Result := TIdEncoderMIME.EncodeBytes(LBytes);
  SetSecWebSocketAcceptExpectedResponse(Result + '258EAFA5-E914-47DA-95CA-C5AB0DC85B11');
end;

procedure TOneWebSocketClient.SetSecWebSocketAcceptExpectedResponse(const AValue: string);
var
  LHash: TIdHashSHA1;
begin
  LHash := TIdHashSHA1.Create;
  try
    FSecWebSocketAcceptExpectedResponse := TIdEncoderMIME.EncodeBytes(LHash.HashString(AValue));
  finally
    LHash.Free;
  end;
end;

function TOneWebSocketClient.DoConnect(): boolean;
var
  lWsUrl: string;
  LURI: TIdURI;
  LSecure: boolean;
begin
  Result := false;
  if Self.FTCPClient.Connected then
  begin
    Self.FErrMsg := '已连接,无需在连接';
    exit;
  end;
  if Self.FWsHost = '' then
  begin
    Self.FErrMsg := '请先设置Ws地址';
    exit;
  end;
  Self.FWsHost := Self.FWsHost.Trim;
  if (Self.FWsHost.Contains('wss:')) or (Self.FWsHost.Contains('ws:')) then
  begin
    lWsUrl := Self.FWsHost;
  end
  else
  begin
    if Self.FIsWss then
    begin
      lWsUrl := 'wss://' + Self.FWsHost;
    end
    else
    begin
      lWsUrl := 'ws://' + Self.FWsHost;
    end;
  end;

  if Self.FWsPort > 0 then
  begin
    lWsUrl := lWsUrl + ':' + Self.FWsPort.ToString;
  end;

  if Self.FWsProtocol <> '' then
  begin
    lWsUrl := lWsUrl + '/' + Self.FWsProtocol;
  end;

  LURI := TIdURI.Create(lWsUrl);
  try
    if Self.FIsWss and (not Assigned(FIOHandler)) then
    begin
      SetIOHandler(TIdSSLIOHandlerSocketOpenSSL.Create(Self));
      TIdSSLIOHandlerSocketOpenSSL(FIOHandler).SSLOptions.Mode := TIdSSLMode.sslmClient;
      TIdSSLIOHandlerSocketOpenSSL(FIOHandler).SSLOptions.SSLVersions := [TIdSSLVersion.sslvTLSv1, TIdSSLVersion.sslvTLSv1_1, TIdSSLVersion.sslvTLSv1_2];
      TIdSSLIOHandlerSocketOpenSSL(FIOHandler).SSLOptions.Method := sslvTLSv1_2;
      TIdSSLIOHandlerSocketOpenSSL(FIOHandler).PassThrough := false;
    end
    else if not Assigned(FIOHandler) then
    begin
      SetIOHandler(TIdIOHandlerStack.Create(Self));
    end;
    try
      Self.FTCPClient.Host := Self.FWsHost;
      Self.FTCPClient.Port := Self.FWsPort;
      Self.FTCPClient.Connect;
      if not Self.FTCPClient.Connected then
      begin
        Self.FErrMsg := '连接失败';
        exit;
      end;
    except
      on e: Exception do
      begin
        Self.FErrMsg := e.Message;
        exit;
      end;
    end;
    //
    if not LURI.Port.IsEmpty then
      LURI.Host := LURI.Host + ':' + LURI.Port;
    if (LURI.Params <> '') then
      Self.FTCPClient.Socket.WriteLn(Format('GET %s HTTP/1.1', [LURI.Path + LURI.Document + '?' + LURI.Params]))
    else
      Self.FTCPClient.Socket.WriteLn(Format('GET %s HTTP/1.1', [LURI.Path + LURI.Document]));
    Self.FTCPClient.Socket.WriteLn(Format('Host: %s', [LURI.Host]));
    Self.FTCPClient.Socket.WriteLn('User-Agent: Delphi WebSocket Simple Client');
    Self.FTCPClient.Socket.WriteLn('Connection: keep-alive, Upgrade');
    Self.FTCPClient.Socket.WriteLn('Upgrade: WebSocket');
    Self.FTCPClient.Socket.WriteLn('Sec-WebSocket-Version: 13');
    Self.FTCPClient.Socket.WriteLn(Format('Sec-WebSocket-Key: %s', [GenerateWebSocketKey]));
    if Self.FWsProtocol.Trim <> '' then
    begin
      Self.FTCPClient.Socket.WriteLn(Format('Sec-WebSocket-Protocol: %s', [FWsProtocol]));
    end;
    Self.FTCPClient.Socket.WriteLn(EmptyStr);
    if not IsValidWebSocket then
      exit;
    ReadFromWebSocket();
    Result := true;
  finally
    LURI.Free;
    if not Result then
      Self.DisConnect();
  end;
end;

procedure TOneWebSocketClient.DisConnect();
begin
  if not Self.FTCPClient.Connected then
    exit;
  FInternalLock.Enter;
  try
    try
      // Self.FTCPClient.Socket.Write(EncodeFrame(EmptyStr, TOperationCode.CONNECTION_CLOSE));
      // TThread.Sleep(200);
      Self.FTCPClient.DisConnect;
      // Self.FTCPClient.Connected := false;
      if Assigned(FIOHandler) then
      begin
        FIOHandler.InputBuffer.Clear;
        FIOHandler.CloseGracefully;
      end;
    except

    end;
  finally
    FInternalLock.Leave;

  end;
end;

function TOneWebSocketClient.Connected: boolean;
begin
  Result := Self.FTCPClient.Connected;
end;

function TOneWebSocketClient.SendMessage(const AMessage: string): boolean;
begin
  Result := false;
  if not Self.Connected then
  begin
    Self.FErrMsg := '未连接,请先连接';
    exit;
  end;
  try
    FInternalLock.Enter;
    try
      Self.FTCPClient.Socket.Write(EncodeFrame(AMessage));
      Self.FTCPClient.Socket.WriteBufferFlush;
    except
      on e: Exception do
      begin
        Self.FErrMsg := e.Message;
        exit;
      end;
    end;
  finally
    FInternalLock.Leave;
  end;
  Result := true;
end;

function TOneWebSocketClient.IsValidWebSocket: boolean;
var
  LSpool: string;
  LByte: Byte;
  LHeaders: TStringlist;
  iLen: integer;
begin
  Result := false;
  LSpool := EmptyStr;
  iLen := 0;
  LHeaders := TStringlist.Create;
  try
    try
      FUpgraded := false;
      while Self.FTCPClient.Connected and not FUpgraded do
      begin
        LByte := Self.FTCPClient.Socket.ReadByte;
        LSpool := LSpool + Chr(LByte);
        iLen := iLen + 1;
        if (not FUpgraded) and (LByte = Ord(#13)) then
        begin
          if (LSpool = #10#13) then
          begin
            if not IsValidHeaders(LHeaders) then
            begin
              exit;
            end;
            FUpgraded := true;
            LSpool := EmptyStr;
          end
          else
          begin
            // if Assigned(FOnOpen) then
            // FOnOpen(LSpool);
            LHeaders.Add(LSpool.Trim);
            LSpool := EmptyStr;
          end;
        end;
      end;
      Self.FTCPClient.Socket.InputBuffer.Clear;
      Result := true;
    except
      on e: Exception do
      begin
        Self.FErrMsg := e.Message;
        Result := false;
      end;
    end;
  finally
    LHeaders.Free;
  end;
end;

function TOneWebSocketClient.IsValidHeaders(const AHeaders: TStrings): boolean;
begin
  Result := false;
  AHeaders.NameValueSeparator := ':';
  if (AHeaders.Count = 0) then
  begin
    Self.FErrMsg := '相关请求头部内容不存在';
    exit;
  end;
  if (not AHeaders[0].Contains('HTTP/1.1 101')) and (AHeaders[0].Contains('HTTP/1.1')) then
  begin
    Self.FErrMsg := '头部HTTP协义不合法' + AHeaders[0].Substring(9);
    exit;
  end;
  if AHeaders.Values['Connection'].Trim.ToLower.Equals('upgrade') and AHeaders.Values['Upgrade'].Trim.ToLower.Equals('websocket') then
  begin
    if AHeaders.Values['Sec-WebSocket-Accept'].Trim.Equals(FSecWebSocketAcceptExpectedResponse) then
      exit(true);
    if AHeaders.Values['Sec-WebSocket-Accept'].Trim.IsEmpty then
      exit(true);
    Self.FErrMsg := '服务端返回无效的Sec-WebSocket-Accept[' + AHeaders.Values['Sec-WebSocket-Accept'] + ']';
  end;
end;

procedure TOneWebSocketClient.ReadFromWebSocket;
begin
  if not Self.FTCPClient.Connected then
    exit;
  FTaskReadFromWebSocket := TTask.Run(
    procedure
    var
      LOperationCode: Byte;
      LSpool: TIdBytes;
      LByte: Byte;
      LPosition: integer;
      LLinFrame, LMasked: boolean;
      LSize: Int64;
      LUInt16: UInt16;
      tempStream: TMemoryStream;
      tempByte: TBytes;
      tempStr: string;
      tempSize: integer;
    begin

      SetLength(LSpool, 0);
      LPosition := 0;
      LSize := 0;
      LOperationCode := 0;
      LLinFrame := false;
      while Self.FTCPClient.Connected do
      begin
        if not Self.FTCPClient.Socket.InputBufferIsEmpty then
        begin
          try
            SetLength(LSpool, 0);
            Self.FTCPClient.IOHandler.CheckForDataOnSource(10);
            Self.FTCPClient.IOHandler.InputBuffer.ExtractToBytes(LSpool, -1, false, -1);
            // 分析Byte
            LByte := LSpool[0];
            if GetBit(LByte, 7) then
            begin
              LOperationCode := ClearBit(LByte, 7);
              if LOperationCode = TOperationCode.TEXT_FRAME.ToByte then
              begin
                LByte := LSpool[1];
                LMasked := GetBit(LByte, 7);
                LSize := LByte;
                if LMasked then
                  LSize := LByte - SetBit(0, 7);
                if LSize = 126 then // get size from 2 next bytes
                begin
                  // 算出长度
                  LUInt16 := BytesToUInt16(LSpool, 2);
                  LUInt16 := GStack.NetworkToHost(LUInt16);
                  LSize := LUInt16;
                  LSpool := copy(LSpool, 4, LSize);
                end
                else if LSize = 127 then
                begin
                  LSize := BytesToUInt64(LSpool, 2);
                  LSize := GStack.NetworkToHost(LSize);
                  LSpool := copy(LSpool, 4, LSize);
                end
                else if LSize < 126 then
                begin
                  LSpool := copy(LSpool, 2, LSize);
                end;
                // copy长度
                Self.ReceiveMsgHandle(IndyTextEncoding_UTF8.GetString(LSpool));
              end
              else if LOperationCode = TOperationCode.PING.ToByte then
              begin
                FInternalLock.Enter;
                try
                  Self.FTCPClient.Socket.Write(EncodeFrame(IndyTextEncoding_UTF8.GetString(LSpool), TOperationCode.PONG));
                finally
                  FInternalLock.Leave;
                end;
              end
            end;
          except
            on e: Exception do
            begin
              HandleException(e);
            end;
          end;
        end;
        sleep(200);
      end;
    end);
end;

function TOneWebSocketClient.GetBit(const AValue: Cardinal; const AByte: Byte): boolean;
begin
  Result := (AValue and (1 shl AByte)) <> 0;
end;

function TOneWebSocketClient.SetBit(const AValue: Cardinal; const AByte: Byte): Cardinal;
begin
  Result := AValue or (1 shl AByte);
end;

function TOneWebSocketClient.ClearBit(const AValue: Cardinal; const AByte: Byte): Cardinal;
begin
  Result := AValue and not(1 shl AByte);
end;

function TOneWebSocketClient.EncodeFrame(const AMessage: string; const AOperationCode: TOperationCode): TIdBytes;
var
  LFin, LMask: Cardinal;
  LMaskingKey: array [0 .. 3] of Cardinal;
  LExtendedPayloads: array [0 .. 3] of Cardinal;
  LBuffer: TIdBytes;
  i: integer;
  LXorOne, LXorTwo: Char;
  LExtendedPayloadLength: integer;
  LMessage: RawByteString;
begin
  LFin := 0;
  LMessage := UTF8Encode(AMessage);
  LFin := SetBit(LFin, 7) or AOperationCode.ToByte;
  LMask := SetBit(0, 7);
  LExtendedPayloadLength := 0;
  if (Length(LMessage) <= 125) then
    LMask := LMask + Cardinal(Length(LMessage))
  else if (Length(LMessage).ToSingle < IntPower(2, 16)) then
  begin
    LMask := LMask + 126;
    LExtendedPayloadLength := 2;
    LExtendedPayloads[1] := Byte(Length(LMessage));
    LExtendedPayloads[0] := Byte(Length(LMessage) shr 8);
  end
  else
  begin
    LMask := LMask + 127;
    LExtendedPayloadLength := 4;
    LExtendedPayloads[3] := Byte(Length(LMessage));
    LExtendedPayloads[2] := Byte(Length(LMessage) shr 8);
    LExtendedPayloads[1] := Byte(Length(LMessage) shr 16);
    LExtendedPayloads[0] := Byte(Length(LMessage) shr 32);
  end;
  LMaskingKey[0] := random(255);
  LMaskingKey[1] := random(255);
  LMaskingKey[2] := random(255);
  LMaskingKey[3] := random(255);
  SetLength(LBuffer, 1 + 1 + LExtendedPayloadLength + 4 + Length(LMessage));
  LBuffer[0] := LFin;
  LBuffer[1] := LMask;
  for i := 0 to Pred(LExtendedPayloadLength) do
    LBuffer[1 + 1 + i] := LExtendedPayloads[i];
  for i := 0 to 3 do
    LBuffer[1 + 1 + LExtendedPayloadLength + i] := LMaskingKey[i];
  for i := 0 to Pred(Length(LMessage)) do
  begin
{$IF DEFINED(iOS) or DEFINED(ANDROID)}
    LXorOne := Char(LMessage[i]);
{$ELSE}
    LXorOne := Char(LMessage[Succ(i)]);
{$ENDIF}
    LXorTwo := Chr(LMaskingKey[((i) mod 4)]);
    LXorTwo := Chr(Ord(LXorOne) xor Ord(LXorTwo));
    LBuffer[1 + 1 + LExtendedPayloadLength + 4 + i] := Ord(LXorTwo);
  end;
  Result := LBuffer;
end;

procedure TOneWebSocketClient.HandleException(const AException: Exception);
var
  LForceDisconnect: boolean;
begin
  LForceDisconnect := true;
  if Assigned(Self.FOnErr) then
    FOnErr(AException);
end;

function TOneWebSocketClient.GetUserList(): boolean;
var
  lErrMsg: string;
  i: integer;
  //
  lResultJsonValue: TJsonValue;
  lOldUserList: TList<TWsUser>;
  lServerResult: TActionResult<TList<TWsUser>>;
begin
  Result := false;
  Self.FErrMsg := '';
  lOldUserList := nil;
  if Self.FHttpConnection = nil then
    Self.FHttpConnection := OneClientConnect.Unit_Connection;
  if Self.FHttpConnection = nil then
  begin
    Self.FErrMsg := '数据集HttpConnection=nil';
    exit;
  end;
  // 获取流水号
  lResultJsonValue := nil;
  lServerResult := TActionResult < TList < TWsUser >>.Create;
  lServerResult.ResultData := TList<TWsUser>.Create;
  try
    lResultJsonValue := Self.FHttpConnection.PostResultJsonValue(URL_HTTPServer_WsChat_GetOnLineUsers, '', lErrMsg);
    if not Self.FHttpConnection.IsErrTrueResult(lErrMsg) then
    begin
      Self.FErrMsg := lErrMsg;
      exit;
    end;
    if not OneNeonHelper.JsonToObject(lServerResult, lResultJsonValue, lErrMsg) then
    begin
      Self.FErrMsg := '返回的数据解析成TResult<TList<TWsUser>>出错,无法知道结果,数据:' + lResultJsonValue.ToJSON;
      exit;
    end;
    if not lServerResult.ResultSuccess then
    begin
      Self.FErrMsg := '服务端消息:' + lServerResult.ResultMsg;
      exit;
    end;
    lOldUserList := Self.FUserList;
    Self.FUserList := lServerResult.ResultData;
    lServerResult.ResultData := nil;
    Result := true;
  finally
    if lResultJsonValue <> nil then
    begin
      lResultJsonValue.Free;
    end;
    if lServerResult.ResultData <> nil then
    begin
      for i := 0 to lServerResult.ResultData.Count - 1 do
      begin
        lServerResult.ResultData[i].Free;
      end;
      lServerResult.ResultData.Clear;
      lServerResult.ResultData.Free;
    end;
    lServerResult.Free;
    if lOldUserList <> nil then
    begin
      for i := 0 to lOldUserList.Count - 1 do
      begin
        lOldUserList[i].Free;
      end;
      lOldUserList.Clear;
      lOldUserList.Free;
    end;
  end;
end;

function TOneWebSocketClient.SendMsgToUser(QUserID: string; QMsg: string): boolean;
var
  lMsg: TWsMsg;
  lJsonObj: TJsonObject;
  lErrMsg: string;
begin
  Result := false;
  if not Self.Connected then
  begin
    Self.FErrMsg := 'Ws未连接,请先连接';
    exit;
  end;
  if QUserID = '' then
  begin
    Self.FErrMsg := '接收方用户ID不可为空';
    exit;
  end;
  lMsg := TWsMsg.Create;
  lMsg.FMsgID := OneFunc.GetGUID32;
  // 发送者ConnectionID,''代表发送出去,基它值代表是接收到消息
  lMsg.FFromUserID := '';
  lMsg.FFromUserName := '';
  // 接收者ConnectionID
  lMsg.FToUserID := QUserID;
  // 消息代码
  lMsg.FMsgCode := '';
  lMsg.FMsgCmd := WsMsg_cmd_toUserMsg;
  // 消息
  lMsg.FMsgData := QMsg;
  // 消息时间
  lMsg.FMsgTime := FormatDateTime('yyyy-mm-dd hh:mm:ss', now);
  Self.FMsgList.Add(lMsg);
  lJsonObj := nil;
  lJsonObj := OneNeonHelper.ObjectToJson(lMsg, lErrMsg) as TJsonObject;
  if lJsonObj = nil then
  begin
    Self.FErrMsg := lErrMsg;
    exit;
  end;
  try
    FInternalLock.Enter;
    try
      Self.FTCPClient.Socket.Write(EncodeFrame(lJsonObj.ToString));
    except
      on e: Exception do
      begin
        Self.FErrMsg := e.Message;
        exit;
      end;
    end;
  finally
    FInternalLock.Leave;
    if lJsonObj <> nil then
      lJsonObj.Free;
  end;
  Result := true;
end;

procedure TOneWebSocketClient.ReceiveMsgHandle(QMsg: string);
var
  lJsonValue: TJsonValue;
  lJsonObj: TJsonObject;
  isWsMsg: boolean;
  lWsMsg: TWsMsg;
  lMsgID: string;
  lErrMsg: string;
begin
  isWsMsg := false;
  lJsonObj := nil;
  lJsonValue := nil;
  // 标准消息格式走这边
  lWsMsg := TWsMsg.Create;
  Self.AddWsMsg(lWsMsg);
  lJsonValue := TJsonObject.ParseJSONValue(QMsg);
  if lJsonValue <> nil then
  begin
    if lJsonValue is TJsonObject then
    begin
      lJsonObj := TJsonObject(lJsonValue);
    end
    else
    begin
      lJsonValue.Free;
    end;
  end;
  try
    if lJsonObj <> nil then
    begin
      if lJsonObj.TryGetValue<string>('MsgID', lMsgID) then
      begin
        isWsMsg := true;
      end;
    end;
    if isWsMsg then
    begin
      if not OneNeonHelper.JsonToObject(lWsMsg, lJsonObj, lErrMsg) then
      begin
        isWsMsg := false;
      end;
    end;
    if isWsMsg then
    begin
      if lWsMsg.FMsgCmd = WsMsg_cmd_WsUserIDGet then
      begin
        Self.FWsUserID := lWsMsg.ToUserID;
        if Assigned(FOnWsUserIDGet) then
        begin
          FOnWsUserIDGet(Self.FWsUserID);
        end;
        exit;
      end;
      if Assigned(FOnOneWsMsg) then
      begin
        FOnOneWsMsg(lWsMsg);
      end
      else
      begin
        FOnReceiveMessage(QMsg)
      end;
    end
    else
    begin
      lWsMsg.FMsgID := OneFunc.GetGUID32;
      // 代表服务端来的消息
      lWsMsg.FFromUserID := '0';
      lWsMsg.FFromUserName := '通知';
      lWsMsg.FMsgData := QMsg;
      lWsMsg.FMsgCmd := WsMsg_cmd_ServerNotify;
      // 非标准消息格式走这边
      if Assigned(FOnReceiveMessage) then
        FOnReceiveMessage(QMsg)
    end;
  finally
    if lJsonObj <> nil then
      lJsonObj.Free;
  end;
end;

procedure TOneWebSocketClient.AddWsMsg(QWsMsg: TWsMsg);
var
  tempList: TList<TWsMsg>;
  i, iCount: integer;
begin
  TMonitor.Enter(Self);
  tempList := TList<TWsMsg>.Create;
  try
    iCount := Self.FMsgList.Count;
    if Self.FCachMsgCount > 0 then
    begin
      if Self.FMsgList.Count > Self.FCachMsgCount then
      begin
        // 保留一半聊天记录其它清除
        for i := iCount - 1 downto Ceil(iCount / 2) do
        begin
          tempList.Add(Self.FMsgList[i]);
          Self.FMsgList.Delete(i);
        end;
      end;
    end
    else
    begin
      // 太多了清理吧，会暴内存
      if Self.FMsgList.Count >= 10000 then
      begin
        // 保留近1000条聊天记录,其它删除
        for i := iCount - 1 downto iCount - 1000 do
        begin
          tempList.Add(Self.FMsgList[i]);
          Self.FMsgList.Delete(i);
        end;
      end;
    end;
    for i := tempList.Count - 1 downto 0 do
    begin
      Self.FMsgList.Add(tempList[i]);
    end;
    Self.FMsgList.Add(QWsMsg);
  finally
    TMonitor.exit(Self);
    tempList.Clear;
    tempList.Free;
  end;
end;

end.

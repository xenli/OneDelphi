unit OneWebSocketClient;

{ 尊重原著，参考开源地址：https://github.com/mateusvicente100/bird-socket-client }
interface

uses
  System.Classes, System.SyncObjs, System.SysUtils, System.Math, System.Threading, System.DateUtils,
  IdURI, IdGlobal, IdTCPClient, IdSSLOpenSSL, IdCoderMIME, IdHashSHA, System.JSON,
  IdIOHandler, IdIOHandlerStream, IdIOHandlerSocket, IdIOHandlerStack;

type
  TOperationCode = (CONTINUE, TEXT_FRAME, BINARY_FRAME, CONNECTION_CLOSE, PING, PONG);

  TOneWsExceptEvent = procedure(QExcept: Exception) of object;

  TOperationCodeHelper = record helper for TOperationCode
    function ToByte: Byte;
  end;

  TOneWebSocketClient = class(TComponent)
  private
    FTCPClient: TIdTCPClient;
    FIsWss: boolean;
    FWsHost: string;
    FWsPort: Integer;
    FWsProtocol: string;
    FUpgraded: boolean;
    //
    FInternalLock: TCriticalSection;
    FIOHandler: TIdIOHandler;
    FSecWebSocketAcceptExpectedResponse: string;
    //
    FTaskReadFromWebSocket: ITask;
    // 相关事件
    FOnReceiveMessage: TGetStrProc;
    FOnErr: TOneWsExceptEvent;
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
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  public
    function DoConnect(): boolean;
    procedure DisConnect();
    function Connected: boolean;
    function SendMessage(const AMessage: string): boolean;
  published
    property TCPClient: TIdTCPClient read FTCPClient;
    property IsWss: boolean read FIsWss write FIsWss;
    property WsHost: string read FWsHost write FWsHost;
    property WsPort: Integer read FWsPort write FWsPort;
    property WsProtocol: string read FWsProtocol write FWsProtocol;
    property IOHandler: TIdIOHandler read FIOHandler write SetIOHandler;
    property OnReceiveMessage: TGetStrProc read FOnReceiveMessage write FOnReceiveMessage;
    property OnErr: TOneWsExceptEvent read FOnErr write FOnErr;
    property ErrMsg: string read FErrMsg write FErrMsg;
  end;

implementation

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
end;

destructor TOneWebSocketClient.Destroy;
begin
  Self.DisConnect();
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
  I: Integer;
begin
  SetLength(LBytes, 16);
  for I := Low(LBytes) to High(LBytes) do
    LBytes[I] := Byte(random(255));
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
    // Self.FTCPClient.Socket.Write(EncodeFrame(EmptyStr, TOperationCode.CONNECTION_CLOSE));
    // TThread.Sleep(200);
    Self.FTCPClient.DisConnect;
    // Self.FTCPClient.Connected := false;
    if Assigned(FIOHandler) then
    begin
      FIOHandler.InputBuffer.Clear;
      FIOHandler.CloseGracefully;
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
begin
  Result := false;
  LSpool := EmptyStr;
  LHeaders := TStringlist.Create;
  try
    try
      FUpgraded := false;
      while Self.FTCPClient.Connected and not FUpgraded do
      begin
        LByte := Self.FTCPClient.Socket.ReadByte;
        LSpool := LSpool + Chr(LByte);
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
var
  LOperationCode: Byte;
  LSpool: TIdBytes;
begin
  if not Self.FTCPClient.Connected then
    exit;
  FTaskReadFromWebSocket := TTask.Run(
    procedure
    var
      LByte: Byte;
      LPosition: Integer;
      LLinFrame, LMasked: boolean;
      LSize: Int64;
    begin
      SetLength(LSpool, 0);
      LPosition := 0;
      LSize := 0;
      LOperationCode := 0;
      LLinFrame := false;
      try
        while Self.FTCPClient.Connected do
        begin
          LByte := Self.FTCPClient.Socket.ReadByte;
          if FUpgraded and (LPosition = 0) and GetBit(LByte, 7) then
          begin
            LLinFrame := true;
            LOperationCode := ClearBit(LByte, 7);
            Inc(LPosition);
          end
          else if FUpgraded and (LPosition = 1) then
          begin
            LMasked := GetBit(LByte, 7);
            LSize := LByte;
            if LMasked then
              LSize := LByte - SetBit(0, 7);
            if (LSize = 0) then
              LPosition := 0
            else if (LSize = 126) then
              LSize := Self.FTCPClient.Socket.ReadUInt16
            else if LSize = 127 then
              LSize := Self.FTCPClient.Socket.ReadUInt64;
            Inc(LPosition);
          end
          else if LLinFrame then
          begin
            LSpool := LSpool + [LByte];
            if (FUpgraded and (Length(LSpool) = LSize)) then
            begin
              LPosition := 0;
              LLinFrame := false;
              if (LOperationCode = TOperationCode.PING.ToByte) then
              begin
                try
                  FInternalLock.Enter;
                  Self.FTCPClient.Socket.Write(EncodeFrame(IndyTextEncoding_UTF8.GetString(LSpool), TOperationCode.PONG));
                finally
                  FInternalLock.Leave;
                end;
              end
              else
              begin
                if FUpgraded and Assigned(FOnReceiveMessage) and (not(LOperationCode = TOperationCode.CONNECTION_CLOSE.ToByte)) then
                  FOnReceiveMessage(IndyTextEncoding_UTF8.GetString(LSpool));
              end;
              SetLength(LSpool, 0);
              if (LOperationCode = TOperationCode.CONNECTION_CLOSE.ToByte) then
              begin
                Self.DisConnect;
                Break
              end;
            end;
          end;
        end;
      except
        on e: Exception do
          HandleException(e);
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
  I: Integer;
  LXorOne, LXorTwo: Char;
  LExtendedPayloadLength: Integer;
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
  for I := 0 to Pred(LExtendedPayloadLength) do
    LBuffer[1 + 1 + I] := LExtendedPayloads[I];
  for I := 0 to 3 do
    LBuffer[1 + 1 + LExtendedPayloadLength + I] := LMaskingKey[I];
  for I := 0 to Pred(Length(LMessage)) do
  begin
{$IF DEFINED(iOS) or DEFINED(ANDROID)}
    LXorOne := Char(LMessage[I]);
{$ELSE}
    LXorOne := Char(LMessage[Succ(I)]);
{$ENDIF}
    LXorTwo := Chr(LMaskingKey[((I) mod 4)]);
    LXorTwo := Chr(Ord(LXorOne) xor Ord(LXorTwo));
    LBuffer[1 + 1 + LExtendedPayloadLength + 4 + I] := Ord(LXorTwo);
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

end.

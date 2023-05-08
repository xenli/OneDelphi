unit frmDemoWebSocket;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  OneWebSocketClient;

type
  TfrDemoWebSocket = class(TForm)
    plSet: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    edWsIP: TEdit;
    edWsPort: TEdit;
    tbClientConnect: TButton;
    tbClientDisConnect: TButton;
    checkWss: TCheckBox;
    OneWsClient: TOneWebSocketClient;
    edMessage: TMemo;
    edSendMsg: TEdit;
    tbSendMsg: TButton;
    Label3: TLabel;
    procedure OneWsClientReceiveMessage(const S: string);
    procedure tbClientConnectClick(Sender: TObject);
    procedure tbClientDisConnectClick(Sender: TObject);
    procedure tbSendMsgClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frDemoWebSocket: TfrDemoWebSocket;

implementation

{$R *.dfm}


procedure TfrDemoWebSocket.OneWsClientReceiveMessage(const S: string);
begin
  //
  edMessage.Lines.Add('***********');
  edMessage.Lines.Add('接收时间:  ' + FormatDateTime('yyyy-mm-dd hh:mm:ss', now));
  edMessage.Lines.Add('接收消息:  ' + S);
  edMessage.Lines.Add('***********');
end;

procedure TfrDemoWebSocket.tbClientConnectClick(Sender: TObject);
var
  tempStr: string;
  tempI: integer;
begin
  //
  OneWsClient.WsHost := edWsIP.Text;
  tempI := 0;
  tryStrToInt(edWsPort.Text, tempI);
  OneWsClient.WsPort := tempI;
  if not OneWsClient.DoConnect() then
  begin
    edMessage.Lines.Add('连接时间:  ' + FormatDateTime('yyyy-mm-dd hh:mm:ss', now));
    edMessage.Lines.Add('连接失败:  ' + OneWsClient.ErrMsg);
    edMessage.Lines.Add('');
    showMessage(OneWsClient.ErrMsg);
  end
  else
  begin
    edMessage.Lines.Add('连接时间:  ' + FormatDateTime('yyyy-mm-dd hh:mm:ss', now));
    edMessage.Lines.Add('连接成');
    edMessage.Lines.Add('');
    showMessage('连接成功');
  end;
end;

procedure TfrDemoWebSocket.tbClientDisConnectClick(Sender: TObject);
begin
  OneWsClient.DisConnect;
  edMessage.Lines.Add('断开时间:  ' + FormatDateTime('yyyy-mm-dd hh:mm:ss', now));
  edMessage.Lines.Add('');
end;

procedure TfrDemoWebSocket.tbSendMsgClick(Sender: TObject);
begin
  //
  if not OneWsClient.SendMessage(edSendMsg.Text) then
  begin
    showMessage(OneWsClient.ErrMsg);
    exit;
  end;
  edMessage.Lines.Add('发送时间:  ' + FormatDateTime('yyyy-mm-dd hh:mm:ss', now));
  edMessage.Lines.Add('发送消息:  ' + edSendMsg.Text);
  edMessage.Lines.Add('');
end;

end.

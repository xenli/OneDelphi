unit frmDemoWebSocketChat;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  OneClientHelper, OneClientConnect, OneWebSocketClient, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.Grids, Vcl.DBGrids, System.Generics.Collections,
  IdGlobal, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP;

type
  TfrDemWsChat = class(TForm)
    plSet: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label17: TLabel;
    edHTTPHost: TEdit;
    edHTTPPort: TEdit;
    edConnectSecretkey: TEdit;
    tbClientConnect: TButton;
    tbClientDisConnect: TButton;
    edZTCode: TEdit;
    Panel1: TPanel;
    Label4: TLabel;
    Label5: TLabel;
    edWsIP: TEdit;
    edWsPort: TEdit;
    tbWsConnect: TButton;
    tbWsDisConnect: TButton;
    checkWss: TCheckBox;
    OneConnection: TOneConnection;
    OneWsClient: TOneWebSocketClient;
    qryUser: TFDMemTable;
    GroupBox1: TGroupBox;
    tbGetOnLineUser: TButton;
    DBGrid1: TDBGrid;
    groupMsg: TGroupBox;
    edMessage: TMemo;
    edSendMsg: TEdit;
    tbSendMsg: TButton;
    qryUserUserName: TWideStringField;
    dsUser: TDataSource;
    qryUserWsUserID: TWideStringField;
    IdHTTP1: TIdHTTP;
    procedure tbClientConnectClick(Sender: TObject);
    procedure tbClientDisConnectClick(Sender: TObject);
    procedure tbWsConnectClick(Sender: TObject);
    procedure tbWsDisConnectClick(Sender: TObject);
    procedure tbGetOnLineUserClick(Sender: TObject);
    procedure tbSendMsgClick(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure OneWsClientReceiveMessage(const S: string);
    procedure OneWsClientOneWsMsg(QWsMsg: TWsMsg);
    procedure OneWsClientWsUserIDGet(const S: string);
  private
    { Private declarations }
    FToUserID: string;
    FToUserName: string;
  public
    { Public declarations }
  end;

var
  frDemWsChat: TfrDemWsChat;

implementation

{$R *.dfm}


procedure TfrDemWsChat.tbWsConnectClick(Sender: TObject);
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
    edMessage.Lines.Add('');
  end;
end;

procedure TfrDemWsChat.tbWsDisConnectClick(Sender: TObject);
begin
  OneWsClient.DisConnect;
  edMessage.Lines.Add('断开时间:  ' + FormatDateTime('yyyy-mm-dd hh:mm:ss', now));
  edMessage.Lines.Add('');
end;

procedure TfrDemWsChat.DBGrid1DblClick(Sender: TObject);
begin
  //
  if qryUser.IsEmpty then
    exit;
  self.FToUserID := qryUserWsUserID.AsString;
  self.FToUserName := qryUserUserName.AsString;
  groupMsg.Caption := '消息发送[' + qryUserWsUserID.AsString + '-' + qryUserUserName.AsString + ']';
end;

procedure TfrDemWsChat.FormCreate(Sender: TObject);
begin
  self.FToUserID := '';
  self.FToUserName := '';
end;

procedure TfrDemWsChat.OneWsClientOneWsMsg(QWsMsg: TWsMsg);
begin
  edMessage.Lines.Add('***********');
  edMessage.Lines.Add('来自用户:  ' + QWsMsg.FromUserID + '-' + QWsMsg.FromUserName);
  edMessage.Lines.Add('接收时间:  ' + FormatDateTime('yyyy-mm-dd hh:mm:ss', now));
  edMessage.Lines.Add('接收消息:  ' + QWsMsg.MsgData);
  edMessage.Lines.Add('***********');
end;

procedure TfrDemWsChat.OneWsClientReceiveMessage(const S: string);
begin
  edMessage.Lines.Add('***********');
  edMessage.Lines.Add('接收时间:  ' + FormatDateTime('yyyy-mm-dd hh:mm:ss', now));
  edMessage.Lines.Add('接收消息:  ' + S);
  edMessage.Lines.Add('***********');
end;

procedure TfrDemWsChat.OneWsClientWsUserIDGet(const S: string);
begin
  self.Caption := '在线聊天-当前用户ID[' + S + ']';
end;

procedure TfrDemWsChat.tbClientConnectClick(Sender: TObject);
begin
  if OneConnection.Connected then
  begin
    showMessage('已经连接成功,无需在连接');
    exit;
  end;
  OneConnection.HTTPHost := edHTTPHost.Text;
  OneConnection.HTTPPort := strToInt(edHTTPPort.Text);
  OneConnection.ZTCode := edZTCode.Text;
  OneConnection.ConnectSecretkey := edConnectSecretkey.Text;
  if not OneConnection.DoConnect() then
  begin
    showMessage(OneConnection.ErrMsg);
  end
  else
  begin
    // 全局设置，如果控件没挂勾 connetion,默认走的就是全局的
    OneClientConnect.Unit_Connection := OneConnection;
    showMessage('连接成功');
  end;
end;

procedure TfrDemWsChat.tbClientDisConnectClick(Sender: TObject);
begin
  OneConnection.DisConnect;
end;

procedure TfrDemWsChat.tbGetOnLineUserClick(Sender: TObject);
var
  i: integer;
  lWsUser: TWsUser;
begin
  if not OneWsClient.GetUserList then
  begin
    showMessage(OneWsClient.ErrMsg);
    exit;
  end;
  if qryUser.Active then
    qryUser.Close;
  qryUser.CreateDataSet;
  for i := 0 to OneWsClient.UserList.count - 1 do
  begin
    lWsUser := OneWsClient.UserList[i];
    qryUser.Append;
    qryUserWsUserID.AsString := lWsUser.WsUserID;
    qryUserUserName.AsString := lWsUser.UserName;
    qryUser.Post;
  end;
  qryUser.MergeChangeLog;
end;

procedure TfrDemWsChat.tbSendMsgClick(Sender: TObject);
begin
  //
  if self.FToUserID = '' then
  begin
    showMessage('请在左边列表双击选中要发送的用户');
    exit;
  end;
  if not OneWsClient.SendMsgToUser(self.FToUserID, edSendMsg.Text) then
  begin
    showMessage(OneWsClient.ErrMsg);
    exit;
  end;
  //
  edMessage.Lines.Add(FormatDateTime('yyyy-mm-dd hh:mm:ss', now));
  edMessage.Lines.Add('你向用户:[' + self.FToUserID + '-' + self.FToUserName + ']发送了一条消息');
  edMessage.Lines.Add('消息:' + edSendMsg.Text);
end;

end.

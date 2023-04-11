unit frmDemoUUID;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  OneClientHelper, OneClientConnect, OneClientUUID;

type
  TfrmUUID = class(TForm)
    plSet: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label17: TLabel;
    edHTTPHost: TEdit;
    edHTTPPort: TEdit;
    edConnectSecretkey: TEdit;
    tbClientConnect: TButton;
    edZTCode: TEdit;
    tbClientDisConnect: TButton;
    OneConnection: TOneConnection;
    OneUUID1: TOneUUID;
    edUUID: TMemo;
    tbGetUUID: TButton;
    procedure tbClientConnectClick(Sender: TObject);
    procedure tbClientDisConnectClick(Sender: TObject);
    procedure tbGetUUIDClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmUUID: TfrmUUID;

implementation

{$R *.dfm}


procedure TfrmUUID.tbClientConnectClick(Sender: TObject);
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
    showMessage('连接成功');
  end;
end;

procedure TfrmUUID.tbClientDisConnectClick(Sender: TObject);
begin
  OneConnection.DisConnect;
end;

procedure TfrmUUID.tbGetUUIDClick(Sender: TObject);
var
  vUrl: string;
  i: integer;
  tempI: Int64;
begin
  if not OneConnection.Connected then
  begin
    showMessage('未连接请先连接');
    exit;
  end;
  tempI := OneUUID1.GetUUID();
  if tempI = -1 then
  begin
    showMessage(OneUUID1.ErrMsg);
    exit;
  end;

  edUUID.Lines.Add(tempI.ToString);
end;

end.

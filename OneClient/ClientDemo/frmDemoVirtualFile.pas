unit frmDemoVirtualFile;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  OneClientHelper, OneClientConnect, OneClientVirtualFile;

type
  TForm6 = class(TForm)
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
    OneVirtualFile: TOneVirtualFile;
    groupUpload: TGroupBox;
    groupDown: TGroupBox;
    edRemark: TMemo;
    Label4: TLabel;
    edVirtualCodeA: TEdit;
    Label5: TLabel;
    edRemoteFileA: TEdit;
    Label6: TLabel;
    edLocalFileA: TEdit;
    tbUpLoad: TButton;
    Label7: TLabel;
    edVirtualCodeB: TEdit;
    Label8: TLabel;
    edRemoteFileB: TEdit;
    Label9: TLabel;
    edLocalFileB: TEdit;
    tbDownLoad: TButton;
    Label10: TLabel;
    edNewFileName: TEdit;
    Label11: TLabel;
    Label12: TLabel;
    edVirtualCodeC: TEdit;
    Label13: TLabel;
    edRemoteFileC: TEdit;
    tbDelFile: TButton;
    procedure tbClientConnectClick(Sender: TObject);
    procedure tbClientDisConnectClick(Sender: TObject);
    procedure tbDownLoadClick(Sender: TObject);
    procedure tbUpLoadClick(Sender: TObject);
    procedure tbDelFileClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form6: TForm6;

implementation

{$R *.dfm}

procedure TForm6.tbClientConnectClick(Sender: TObject);
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

procedure TForm6.tbClientDisConnectClick(Sender: TObject);
begin
  OneConnection.DisConnect;
end;

procedure TForm6.tbDelFileClick(Sender: TObject);
begin
  OneVirtualFile.VirtualCode := edVirtualCodeC.Text;
  OneVirtualFile.RemoteFile := edRemoteFileC.Text;
  if OneVirtualFile.DeleteFile() then
  begin
    showMessage('删除文件成功!!!');
  end
  else
  begin
    showMessage(OneVirtualFile.ErrMsg);
  end;
end;

procedure TForm6.tbDownLoadClick(Sender: TObject);
begin
  OneVirtualFile.VirtualCode := edVirtualCodeB.Text;
  OneVirtualFile.RemoteFile := edRemoteFileB.Text;
  OneVirtualFile.LocalFile := edLocalFileB.Text;
  if OneVirtualFile.DownloadFile() then
  begin
    showMessage('下载文件成功');
  end
  else
  begin
    showMessage(OneVirtualFile.ErrMsg);
  end;
end;

procedure TForm6.tbUpLoadClick(Sender: TObject);
begin
  OneVirtualFile.VirtualCode := edVirtualCodeA.Text;
  OneVirtualFile.RemoteFile := edRemoteFileA.Text;
  OneVirtualFile.LocalFile := edLocalFileA.Text;
  if OneVirtualFile.UploadFile() then
  begin
    edNewFileName.Text := OneVirtualFile.ReturnFileName;
    showMessage('下载文件成功,最终保存文件名称[' + OneVirtualFile.ReturnFileName + ']');
  end
  else
  begin
    showMessage(OneVirtualFile.ErrMsg);
  end;
end;

end.

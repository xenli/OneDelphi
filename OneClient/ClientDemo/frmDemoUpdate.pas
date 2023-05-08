unit frmDemoUpdate;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, OneClientFastUpdate, Vcl.StdCtrls,
  Vcl.ExtCtrls, OneClientHelper, OneClientConnect, Vcl.ComCtrls,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdIOHandler,
  IdIOHandlerSocket, IdIOHandlerStack, IdIOHandlerStream, IdHTTP;

type
  TfrDemoUpdate = class(TForm)
    OneFastUpdate1: TOneFastUpdate;
    plSet: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    edHTTPHost: TEdit;
    edHTTPPort: TEdit;
    edConnectSecretkey: TEdit;
    tbClientConnect: TButton;
    tbClientDisConnect: TButton;
    OneConnection: TOneConnection;
    ProgressFileCount: TProgressBar;
    ProgressFileSize: TProgressBar;
    Label4: TLabel;
    Label5: TLabel;
    tbUpdateOK: TButton;
    tbResh: TButton;
    edUpdate: TMemo;
    IdTCPClient1: TIdTCPClient;
    IdIOHandlerStack1: TIdIOHandlerStack;
    IdIOHandlerStream1: TIdIOHandlerStream;
    IdHTTP1: TIdHTTP;
    procedure tbClientConnectClick(Sender: TObject);
    procedure tbClientDisConnectClick(Sender: TObject);
    procedure OneFastUpdate1CallBack(QDownStep: enumUpdateDownStep; QFileCount,
      QIndexFile: Integer; QFileName: string; QFileSize, QFilePosition: Int64);
    procedure tbUpdateOKClick(Sender: TObject);
    procedure tbReshClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frDemoUpdate: TfrDemoUpdate;
  Restart_Flag: boolean = false;

implementation

{$R *.dfm}


procedure TfrDemoUpdate.OneFastUpdate1CallBack(QDownStep: enumUpdateDownStep;
  QFileCount, QIndexFile: Integer; QFileName: string; QFileSize,
  QFilePosition: Int64);
begin
  //
  Application.ProcessMessages;
  if QDownStep = emStepStart then
  begin
    ProgressFileCount.Position := 0;
    ProgressFileCount.Max := QFileCount;
    ProgressFileSize.Position := 0;

    edUpdate.Lines.Add('开始升级');
    edUpdate.Lines.Add('文件个数:' + QFileCount.ToString);
  end
  else if QDownStep = emStepEnd then
  begin
    // 升级文件下件下载成功
    edUpdate.Lines.Add('结束升级');
  end
  else if QDownStep = emFileStart then
  begin
    ProgressFileCount.Position := QIndexFile + 1;
    ProgressFileSize.Position := 0;
    ProgressFileSize.Max := 100;
    edUpdate.Lines.Add('开始下载文件:[' + QFileName + ']');
    edUpdate.Lines.Add('文件总长度:[' + QFileName + ']->' + QFileSize.ToString);
  end
  else if QDownStep = emFileProcess then
  begin
    if QFileSize > 0 then
      ProgressFileSize.Position := Round(QFilePosition / QFileSize) * 100;
    edUpdate.Lines.Add('文件下载进度:[' + QFileName + ']->' + QFilePosition.ToString + '/' + QFileSize.ToString);
  end
  else if QDownStep = emStepErr then
  begin
    edUpdate.Lines.Add('下载文件:[' + QFileName + ']发生错误');
    edUpdate.Lines.Add('错误原因:' + OneFastUpdate1.ErrMsg);
  end;
end;

procedure TfrDemoUpdate.tbClientConnectClick(Sender: TObject);
begin
  if OneConnection.Connected then
  begin
    showMessage('已经连接成功,无需在连接');
    exit;
  end;
  OneConnection.HTTPHost := edHTTPHost.Text;
  OneConnection.HTTPPort := strToInt(edHTTPPort.Text);
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

procedure TfrDemoUpdate.tbClientDisConnectClick(Sender: TObject);
begin
  OneConnection.DisConnect;
end;

procedure TfrDemoUpdate.tbReshClick(Sender: TObject);
begin
  if OneFastUpdate1.RefreshUpdateSet then
  begin
    showMessage('刷新配置成功');
  end
  else
  begin
    showMessage(OneFastUpdate1.ErrMsg);
  end;
end;

procedure TfrDemoUpdate.tbUpdateOKClick(Sender: TObject);
var
  lCheckUpdate: enumCheckUpdate;
begin
  edUpdate.Lines.Clear;
  // 检测是否可升级
  lCheckUpdate := OneFastUpdate1.CheckCanUpdate;
  if lCheckUpdate = emNotUpdate then
  begin
    showMessage('无需升级!');
    exit;
  end;
  if lCheckUpdate = emCheckErr then
  begin
    showMessage(OneFastUpdate1.ErrMsg);
    exit;
  end;
  // 进行升级
  if (lCheckUpdate = emCanUpdate) or (lCheckUpdate = emForceUpdate) then
  begin
    // 下载升级文件
    if not OneFastUpdate1.DoUpdateDownFile() then
    begin
      showMessage(OneFastUpdate1.ErrMsg);
      exit;
    end;
    // 复制文件升级相关文件
    if not OneFastUpdate1.CopyFileAndUpdate then
    begin
      showMessage(OneFastUpdate1.ErrMsg);
      exit;
    end;
    // 成功
    Restart_Flag := true;
    self.Close;
  end;

end;

end.

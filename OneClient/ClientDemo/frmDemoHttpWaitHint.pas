unit frmDemoHttpWaitHint;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  OneClientHelper, OneClientConnect, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  OneClientDataSet;

type
  TfrDemoHttpWaitHint = class(TForm)
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
    OneDataSet1: TOneDataSet;
    procedure tbClientConnectClick(Sender: TObject);
    procedure OneConnectionShowWaitHint(Sender: TObject);
    procedure OneConnectionShowWaitHintProcess(Sender: TObject);
    procedure OneConnectionShowWaitHintClose(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frDemoHttpWaitHint: TfrDemoHttpWaitHint;

implementation

{$R *.dfm}


uses frmWait;

procedure TfrDemoHttpWaitHint.OneConnectionShowWaitHint(Sender: TObject);
begin
  // 唤醒等待窗体
  frmWait.ShowWaitForm;
end;

procedure TfrDemoHttpWaitHint.OneConnectionShowWaitHintClose(Sender: TObject);
begin
  // 关闭等待窗体
  frmWait.CloseWaitForm;
end;

procedure TfrDemoHttpWaitHint.OneConnectionShowWaitHintProcess(Sender: TObject);
begin
  // 归还消息，否则什么造成错误,当是主线程时，非主线程也不会走这边
  // // win下用 application.ProcessMessages;
  // FMX下需引用相关单元 FMX.Forms 然后调用 Tapplication.ProcessMessages
  application.ProcessMessages;
end;

procedure TfrDemoHttpWaitHint.tbClientConnectClick(Sender: TObject);
begin
  // OneConnection.Connected := true;
  // OneDataSet1.OpenDataAsync(
  // procedure(QIsOK: boolean; QErrmsg: string)
  // begin
  //
  // end)
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

end.

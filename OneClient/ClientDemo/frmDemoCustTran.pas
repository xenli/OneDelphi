unit frmDemoCustTran;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  OneClientHelper, OneClientConnect, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  OneClientDataSet;

type
  TForm3 = class(TForm)
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
    GroupBox1: TGroupBox;
    edSQLA: TMemo;
    GroupBox2: TGroupBox;
    edSQLB: TMemo;
    tbDML: TButton;
    qryDataA: TOneDataSet;
    procedure tbClientConnectClick(Sender: TObject);
    procedure tbClientDisConnectClick(Sender: TObject);
    procedure tbDMLClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

{$R *.dfm}

procedure TForm3.tbClientConnectClick(Sender: TObject);
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

procedure TForm3.tbClientDisConnectClick(Sender: TObject);
begin
  OneConnection.DisConnect;
end;

procedure TForm3.tbDMLClick(Sender: TObject);
var
  isCommit: boolean;
  lErrMsg: string;
begin
  // 先获取事务ID
  // 初始变量是个好习惯,记住一定要
  isCommit := false;
  lErrMsg := '';
  if not qryDataA.LockTran then
  begin
    // 获取事务ID
    showMessage(qryDataA.DataInfo.ErrMsg);
    exit;
  end;
  if not qryDataA.StartTran then
  begin
    // 开始事务
    showMessage(qryDataA.DataInfo.ErrMsg);
    exit;
  end;
  try
    qryDataA.SQL.Text := edSQLA.Text;
    if not qryDataA.ExecDML then
    begin
      lErrMsg := qryDataA.DataInfo.ErrMsg;
      exit;
    end;
    qryDataA.SQL.Text := edSQLB.Text;
    if not qryDataA.ExecDML then
    begin
      lErrMsg := qryDataA.DataInfo.ErrMsg;
      exit;
    end;
    // 提交事务
    qryDataA.CommitTran();
    isCommit := true;
  finally
    if not isCommit then
    begin
      // 未正确提交回滚
      qryDataA.RollbackTran;
    end;
    // 归还
    qryDataA.UnLockTran;
    if isCommit then
    BEGIN
      showMessage('事务运行成功');
    END
    else
    begin
      showMessage(lErrMsg);
    end;
  end;

end;

end.

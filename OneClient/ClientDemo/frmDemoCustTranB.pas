unit frmDemoCustTranB;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  OneClientHelper, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, OneClientDataSet,
  OneClientConnect, Vcl.Grids, Vcl.DBGrids;

type
  TForm8 = class(TForm)
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
    qryDataA: TOneDataSet;
    GroupBox1: TGroupBox;
    Label4: TLabel;
    edSQLA: TMemo;
    Label6: TLabel;
    edCheckSQL: TMemo;
    qryCheck: TOneDataSet;
    tbSaveDatas: TButton;
    procedure tbClientConnectClick(Sender: TObject);
    procedure tbClientDisConnectClick(Sender: TObject);
    procedure tbSaveDatasClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form8: TForm8;

implementation

{$R *.dfm}

procedure TForm8.tbClientConnectClick(Sender: TObject);
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

procedure TForm8.tbClientDisConnectClick(Sender: TObject);
begin
  OneConnection.DisConnect;
end;

procedure TForm8.tbSaveDatasClick(Sender: TObject);
var
  vUrl: string;
  i: integer;
  lColumn: TColumn;
  isCommit: boolean;
  lErrMsg: string;
begin
  if not OneConnection.Connected then
  begin
    showMessage('未连接请先连接');
    exit;
  end;
  // 或者在控件UI直接设置 Connection
  qryDataA.SQL.Text := edSQLA.Lines.Text;
  // 开始事务
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
    try
      //设定必需有且一条受影响，跟据你的实际业务场景设置
      qryDataA.DataInfo.AffectedMustCount := 1;
      // 执行DML语句
      if not qryDataA.ExecDML then
      begin
        //执行失败退出
        lErrMsg :=  qryDataA.DataInfo.ErrMsg;
        exit;
      end;
      // 查询重复判断,必需在同一个事务里面查询,否则会造成阻塞
      // 除非你进行无锁查询，但无锁查询意义不大，你没办法查到此事务的结果
      //因此一定要放在同个事务
      qryCheck.DataInfo.TranID := qryDataA.DataInfo.TranID;
      qryCheck.SQL.Text := edCheckSQL.Lines.Text;
      if not qryCheck.OpenData then
      begin
        lErrMsg :=  qryCheck.DataInfo.ErrMsg;
        exit;
      end;
      if qryCheck.RecordCount > 1 then
      begin
        showMessage('数据存在重复,请检查');
        exit;
      end;
      if not qryDataA.ExecDML then
      begin
        //执行失败退出
        lErrMsg :=  qryDataA.DataInfo.ErrMsg;
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
      if isCommit then
      BEGIN
        showMessage('事务运行成功');
      END
      else
      begin
        showMessage(lErrMsg);
      end;
    end;
  finally
    // 归还锁
    qryDataA.UnLockTran;
  end;

end;

end.

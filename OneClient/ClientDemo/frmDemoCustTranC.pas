unit frmDemoCustTranC;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  OneClientHelper, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, OneClientDataSet,
  OneClientConnect, Vcl.Grids, Vcl.DBGrids;

type
  TForm9 = class(TForm)
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
    qryCheck: TOneDataSet;
    GroupBox1: TGroupBox;
    Label4: TLabel;
    Label5: TLabel;
    Label14: TLabel;
    edSQLA: TMemo;
    edTableNameA: TEdit;
    edPrimaryKeyA: TEdit;
    dbGridA: TDBGrid;
    Label6: TLabel;
    edCheckSQL: TMemo;
    dsDataA: TDataSource;
    tbOpenDatas: TButton;
    tbSaveDatas: TButton;
    tbSaveB: TButton;
    procedure tbClientConnectClick(Sender: TObject);
    procedure tbClientDisConnectClick(Sender: TObject);
    procedure tbOpenDatasClick(Sender: TObject);
    procedure tbSaveDatasClick(Sender: TObject);
    procedure tbSaveBClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form9: TForm9;

implementation

{$R *.dfm}

procedure TForm9.tbClientConnectClick(Sender: TObject);
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

procedure TForm9.tbClientDisConnectClick(Sender: TObject);
begin
  OneConnection.DisConnect;
end;

procedure TForm9.tbOpenDatasClick(Sender: TObject);
var
  vUrl: string;
  i: integer;
  lColumn: TColumn;
  lErrMsg: string;
begin
  if not OneConnection.Connected then
  begin
    showMessage('未连接请先连接');
    exit;
  end;
  // 或者在控件UI直接设置 Connection
  qryDataA.SQL.Text := edSQLA.Lines.Text;
  // 打开数据
  if not qryDataA.OpenData then
  begin
    showMessage(qryDataA.DataInfo.ErrMsg);
    exit;
  end;

  //
  qryDataA.DisableControls;
  try
    dbGridA.Columns.Clear;
    for i := 0 to qryDataA.Fields.Count - 1 do
    begin
      lColumn := dbGridA.Columns.Add;
      lColumn.FieldName := qryDataA.Fields[i].FieldName;
      lColumn.Title.Caption := qryDataA.Fields[i].FieldName;
      lColumn.Width := 100;
    end;
    showMessage('打开数据成功');
  finally
    qryDataA.EnableControls;
  end;

end;

procedure TForm9.tbSaveBClick(Sender: TObject);
var
  vUrl: string;
  i: integer;
  lColumn: TColumn;
  isCommit: boolean;
  lErrMsg: string;
begin
  if not qryDataA.Active then
  begin
    showMessage('数据未打开,请先打开数据');
    exit;
  end;

  if not OneConnection.Connected then
  begin
    showMessage('未连接请先连接');
    exit;
  end;
  // 代码修改业务数据
  qryDataA.Edit;
  qryDataA.FieldByName('FBillNo').AsString := FormatDateTime('yyyymmddhhnnss', now);
  if qryDataA.State in dsEditModes then
    qryDataA.Post;
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
      // 如果你SQL是固定写死在 qryDataA.sql.text，无需动态设置
      // 同理表名和主键一样，我这边是跟据配置动态设置的演示DEMO
      qryDataA.SQL.Text := edSQLA.Lines.Text;
      qryDataA.DataInfo.TableName := edTableNameA.Text;
      qryDataA.DataInfo.PrimaryKey := edPrimaryKeyA.Text;
      // 执行保存语句
      if not qryDataA.SaveData then
      begin
        // 执行失败退出
        lErrMsg := qryDataA.DataInfo.ErrMsg;
        exit;
      end;
      // 查询重复判断,必需在同一个事务里面查询,否则会造成阻塞
      // 除非你进行无锁查询，但无锁查询意义不大，你没办法查到此事务的结果
      // 因此一定要放在同个事务
      qryCheck.DataInfo.TranID := qryDataA.DataInfo.TranID;
      qryCheck.SQL.Text := edCheckSQL.Lines.Text;
      if not qryCheck.OpenData then
      begin
        lErrMsg := qryCheck.DataInfo.ErrMsg;
        exit;
      end;
      if qryCheck.RecordCount > 1 then
      begin
        lErrMsg := '数据存在重复,请检查';
        exit;
      end;
      // A数据集继续改数据 ,,不可以的。。delta提交无此功能
//      qryDataA.Edit;
//      qryDataA.FieldByName('FBillNo').AsString := 'my' + FormatDateTime('yyyymmddhhnnss', now);
//      if qryDataA.State in dsEditModes then
//        qryDataA.Post;
//      if not qryDataA.SaveData then
//      begin
//        // 执行失败退出
//        lErrMsg := qryDataA.DataInfo.ErrMsg;
//        exit;
//      end;
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

procedure TForm9.tbSaveDatasClick(Sender: TObject);
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
      // 如果你SQL是固定写死在 qryDataA.sql.text，无需动态设置
      // 同理表名和主键一样，我这边是跟据配置动态设置的演示DEMO
      qryDataA.SQL.Text := edSQLA.Lines.Text;
      qryDataA.DataInfo.TableName := edTableNameA.Text;
      qryDataA.DataInfo.PrimaryKey := edPrimaryKeyA.Text;
      // 执行保存语句
      if not qryDataA.SaveData then
      begin
        // 执行失败退出
        lErrMsg := qryDataA.DataInfo.ErrMsg;
        exit;
      end;
      // 查询重复判断,必需在同一个事务里面查询,否则会造成阻塞
      // 除非你进行无锁查询，但无锁查询意义不大，你没办法查到此事务的结果
      // 因此一定要放在同个事务
      qryCheck.DataInfo.TranID := qryDataA.DataInfo.TranID;
      qryCheck.SQL.Text := edCheckSQL.Lines.Text;
      if not qryCheck.OpenData then
      begin
        lErrMsg := qryCheck.DataInfo.ErrMsg;
        exit;
      end;
      if qryCheck.RecordCount > 1 then
      begin
        lErrMsg := '数据存在重复,请检查';
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

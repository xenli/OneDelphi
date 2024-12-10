unit frmDemoBillLock;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Data.DB,
  Vcl.Grids, Vcl.DBGrids, OneClientHelper, OneClientConnect, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, OneClientDataSet, OneClientFastBillLock;

type
  TForm11 = class(TForm)
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
    Label4: TLabel;
    edSQL: TMemo;
    Label5: TLabel;
    edTableName: TEdit;
    Label14: TLabel;
    edPrimaryKey: TEdit;
    tbOpenData: TButton;
    tbSaveData: TButton;
    DBGrid1: TDBGrid;
    OneConnection: TOneConnection;
    dsMain: TDataSource;
    qryMain: TOneDataSet;
    OneBillLock: TOneBillLock;
    tbBillUnLockForce: TButton;
    procedure tbClientConnectClick(Sender: TObject);
    procedure tbClientDisConnectClick(Sender: TObject);
    procedure tbOpenDataClick(Sender: TObject);
    procedure tbSaveDataClick(Sender: TObject);
    procedure tbBillUnLockForceClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form11: TForm11;

implementation

{$R *.dfm}

procedure TForm11.tbBillUnLockForceClick(Sender: TObject);
var
  lErrMsg: string;
begin
  if not OneBillLock.UnLockBillForce('myBillID', lErrMsg) then
  begin
    showMessage(lErrMsg);
    exit;
  end;
  showMessage('解锁成功');
end;

procedure TForm11.tbClientConnectClick(Sender: TObject);
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

procedure TForm11.tbClientDisConnectClick(Sender: TObject);
begin
  OneConnection.DisConnect;
end;

procedure TForm11.tbOpenDataClick(Sender: TObject);
var
  vUrl: string;
  i: integer;
  lColumn: TColumn;
  lErrMsg: string;
  lIsLockBill: boolean;
begin
  if not OneConnection.Connected then
  begin
    showMessage('未连接请先连接');
    exit;
  end;
  // 或者在控件UI直接设置 Connection
  qryMain.DataInfo.Connection := OneConnection;
  qryMain.SQL.Text := edSQL.Lines.Text;
  if not qryMain.OpenData then
  begin
    showMessage(qryMain.DataInfo.ErrMsg);
    exit;
  end;

  // 申请订单锁,或者你在点编辑按钮处理申请订单锁，我这边只是个演示,实际跟据自已业务
  // 可以以订单ID为BILLID，也可以自已命名一个唯一的
  // 用户ID可以是TokenID或者你自已业务的一个信息
  // -1代表不限时间,0代表默认30分钟自动解锁,其它时间代表多久不解锁自动解锁
  // 返回true代表申请锁成功
  lIsLockBill := OneBillLock.LockBill('myBillID', OneConnection.TokenID, 0, lErrMsg);
  // 直接设置字段只读，演示的，你可以跟据你的业务情况处理
  for i := 0 to qryMain.Fields.Count - 1 do
  begin
    qryMain.Fields[i].ReadOnly := not lIsLockBill;
  end;
  DBGrid1.Columns.Clear;
  for i := 0 to qryMain.Fields.Count - 1 do
  begin
    lColumn := DBGrid1.Columns.Add;
    lColumn.FieldName := qryMain.Fields[i].FieldName;
    lColumn.Title.Caption := qryMain.Fields[i].FieldName;
    lColumn.Width := 100;
  end;
  showMessage('打开数据成功');
end;

procedure TForm11.tbSaveDataClick(Sender: TObject);
var
  i: integer;
  lFieldName: string;
  lField: TField;
  lErrMsg: string;
  lIsLockBill: boolean;
begin
  qryMain.DataInfo.TableName := edTableName.Text;
  qryMain.DataInfo.PrimaryKey := edPrimaryKey.Text;
  // 有自增ID的这个打勾即可
  if qryMain.State in dsEditModes then
    qryMain.Post;
  // 保存前判断还是不自已的订单锁，如果多次申请只要是自已的多是返回true
  lIsLockBill := OneBillLock.LockBill('myBillID', OneConnection.TokenID, 0, lErrMsg);
  try
    if not lIsLockBill then
    begin
      showMessage(lErrMsg);
      // 不是自已的锁,退出保存，要干什么，自已业务自已处理
      // 比如提醒他数据发生改变，请重新刷新数据，防止数据覆盖
      exit;
    end;
    if qryMain.SaveData then
    begin
      showMessage('保存数据成功');
    end
    else
    begin
      showMessage(qryMain.DataInfo.ErrMsg);
    end;
  finally
    if lIsLockBill then
    begin
      // 进行订单解锁,允许其它人。
      // 当然你也可以在窗体关闭时解锁，看你业务形态，这个我只是做个DEMO演示
      OneBillLock.UnLockBill('myBillID', OneConnection.TokenID, lErrMsg);
    end;
  end;

end;

end.

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
  showMessage('�����ɹ�');
end;

procedure TForm11.tbClientConnectClick(Sender: TObject);
begin
  if OneConnection.Connected then
  begin
    showMessage('�Ѿ����ӳɹ�,����������');
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
    // ȫ�����ã�����ؼ�û�ҹ� connetion,Ĭ���ߵľ���ȫ�ֵ�
    OneClientConnect.Unit_Connection := OneConnection;
    showMessage('���ӳɹ�');
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
    showMessage('δ������������');
    exit;
  end;
  // �����ڿؼ�UIֱ������ Connection
  qryMain.DataInfo.Connection := OneConnection;
  qryMain.SQL.Text := edSQL.Lines.Text;
  if not qryMain.OpenData then
  begin
    showMessage(qryMain.DataInfo.ErrMsg);
    exit;
  end;

  // ���붩����,�������ڵ�༭��ť�������붩�����������ֻ�Ǹ���ʾ,ʵ�ʸ�������ҵ��
  // �����Զ���IDΪBILLID��Ҳ������������һ��Ψһ��
  // �û�ID������TokenID����������ҵ���һ����Ϣ
  // -1������ʱ��,0����Ĭ��30�����Զ�����,����ʱ������ò������Զ�����
  // ����true�����������ɹ�
  lIsLockBill := OneBillLock.LockBill('myBillID', OneConnection.TokenID, 0, lErrMsg);
  // ֱ�������ֶ�ֻ������ʾ�ģ�����Ը������ҵ���������
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
  showMessage('�����ݳɹ�');
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
  // ������ID������򹴼���
  if qryMain.State in dsEditModes then
    qryMain.Post;
  // ����ǰ�жϻ��ǲ����ѵĶ�����������������ֻҪ�����ѵĶ��Ƿ���true
  lIsLockBill := OneBillLock.LockBill('myBillID', OneConnection.TokenID, 0, lErrMsg);
  try
    if not lIsLockBill then
    begin
      showMessage(lErrMsg);
      // �������ѵ���,�˳����棬Ҫ��ʲô������ҵ�����Ѵ���
      // �������������ݷ����ı䣬������ˢ�����ݣ���ֹ���ݸ���
      exit;
    end;
    if qryMain.SaveData then
    begin
      showMessage('�������ݳɹ�');
    end
    else
    begin
      showMessage(qryMain.DataInfo.ErrMsg);
    end;
  finally
    if lIsLockBill then
    begin
      // ���ж�������,���������ˡ�
      // ��Ȼ��Ҳ�����ڴ���ر�ʱ����������ҵ����̬�������ֻ������DEMO��ʾ
      OneBillLock.UnLockBill('myBillID', OneConnection.TokenID, lErrMsg);
    end;
  end;

end;

end.

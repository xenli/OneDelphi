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
    showMessage('���ӳɹ�');
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
    showMessage('δ������������');
    exit;
  end;
  // �����ڿؼ�UIֱ������ Connection
  qryDataA.SQL.Text := edSQLA.Lines.Text;
  // ������
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
    showMessage('�����ݳɹ�');
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
    showMessage('����δ��,���ȴ�����');
    exit;
  end;

  if not OneConnection.Connected then
  begin
    showMessage('δ������������');
    exit;
  end;
  // �����޸�ҵ������
  qryDataA.Edit;
  qryDataA.FieldByName('FBillNo').AsString := FormatDateTime('yyyymmddhhnnss', now);
  if qryDataA.State in dsEditModes then
    qryDataA.Post;
  // ��ʼ����
  isCommit := false;
  lErrMsg := '';
  if not qryDataA.LockTran then
  begin
    // ��ȡ����ID
    showMessage(qryDataA.DataInfo.ErrMsg);
    exit;
  end;
  if not qryDataA.StartTran then
  begin
    // ��ʼ����
    showMessage(qryDataA.DataInfo.ErrMsg);
    exit;
  end;
  try
    try
      // �����SQL�ǹ̶�д���� qryDataA.sql.text�����趯̬����
      // ͬ�����������һ����������Ǹ������ö�̬���õ���ʾDEMO
      qryDataA.SQL.Text := edSQLA.Lines.Text;
      qryDataA.DataInfo.TableName := edTableNameA.Text;
      qryDataA.DataInfo.PrimaryKey := edPrimaryKeyA.Text;
      // ִ�б������
      if not qryDataA.SaveData then
      begin
        // ִ��ʧ���˳�
        lErrMsg := qryDataA.DataInfo.ErrMsg;
        exit;
      end;
      // ��ѯ�ظ��ж�,������ͬһ�����������ѯ,������������
      // ���������������ѯ����������ѯ���岻����û�취�鵽������Ľ��
      // ���һ��Ҫ����ͬ������
      qryCheck.DataInfo.TranID := qryDataA.DataInfo.TranID;
      qryCheck.SQL.Text := edCheckSQL.Lines.Text;
      if not qryCheck.OpenData then
      begin
        lErrMsg := qryCheck.DataInfo.ErrMsg;
        exit;
      end;
      if qryCheck.RecordCount > 1 then
      begin
        lErrMsg := '���ݴ����ظ�,����';
        exit;
      end;
      // A���ݼ����������� ,,�����Եġ���delta�ύ�޴˹���
//      qryDataA.Edit;
//      qryDataA.FieldByName('FBillNo').AsString := 'my' + FormatDateTime('yyyymmddhhnnss', now);
//      if qryDataA.State in dsEditModes then
//        qryDataA.Post;
//      if not qryDataA.SaveData then
//      begin
//        // ִ��ʧ���˳�
//        lErrMsg := qryDataA.DataInfo.ErrMsg;
//        exit;
//      end;
      // �ύ����
      qryDataA.CommitTran();
      isCommit := true;
    finally
      if not isCommit then
      begin
        // δ��ȷ�ύ�ع�
        qryDataA.RollbackTran;
      end;
      if isCommit then
      BEGIN
        showMessage('�������гɹ�');
      END
      else
      begin
        showMessage(lErrMsg);
      end;
    end;
  finally
    // �黹��
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
    showMessage('δ������������');
    exit;
  end;
  // ��ʼ����
  isCommit := false;
  lErrMsg := '';
  if not qryDataA.LockTran then
  begin
    // ��ȡ����ID
    showMessage(qryDataA.DataInfo.ErrMsg);
    exit;
  end;
  if not qryDataA.StartTran then
  begin
    // ��ʼ����
    showMessage(qryDataA.DataInfo.ErrMsg);
    exit;
  end;
  try
    try
      // �����SQL�ǹ̶�д���� qryDataA.sql.text�����趯̬����
      // ͬ�����������һ����������Ǹ������ö�̬���õ���ʾDEMO
      qryDataA.SQL.Text := edSQLA.Lines.Text;
      qryDataA.DataInfo.TableName := edTableNameA.Text;
      qryDataA.DataInfo.PrimaryKey := edPrimaryKeyA.Text;
      // ִ�б������
      if not qryDataA.SaveData then
      begin
        // ִ��ʧ���˳�
        lErrMsg := qryDataA.DataInfo.ErrMsg;
        exit;
      end;
      // ��ѯ�ظ��ж�,������ͬһ�����������ѯ,������������
      // ���������������ѯ����������ѯ���岻����û�취�鵽������Ľ��
      // ���һ��Ҫ����ͬ������
      qryCheck.DataInfo.TranID := qryDataA.DataInfo.TranID;
      qryCheck.SQL.Text := edCheckSQL.Lines.Text;
      if not qryCheck.OpenData then
      begin
        lErrMsg := qryCheck.DataInfo.ErrMsg;
        exit;
      end;
      if qryCheck.RecordCount > 1 then
      begin
        lErrMsg := '���ݴ����ظ�,����';
        exit;
      end;
      // �ύ����
      qryDataA.CommitTran();
      isCommit := true;
    finally
      if not isCommit then
      begin
        // δ��ȷ�ύ�ع�
        qryDataA.RollbackTran;
      end;
      if isCommit then
      BEGIN
        showMessage('�������гɹ�');
      END
      else
      begin
        showMessage(lErrMsg);
      end;
    end;
  finally
    // �黹��
    qryDataA.UnLockTran;
  end;

end;

end.

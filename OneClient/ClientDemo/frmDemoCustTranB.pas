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
    showMessage('δ������������');
    exit;
  end;
  // �����ڿؼ�UIֱ������ Connection
  qryDataA.SQL.Text := edSQLA.Lines.Text;
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
      //�趨��������һ����Ӱ�죬�������ʵ��ҵ�񳡾�����
      qryDataA.DataInfo.AffectedMustCount := 1;
      // ִ��DML���
      if not qryDataA.ExecDML then
      begin
        //ִ��ʧ���˳�
        lErrMsg :=  qryDataA.DataInfo.ErrMsg;
        exit;
      end;
      // ��ѯ�ظ��ж�,������ͬһ�����������ѯ,������������
      // ���������������ѯ����������ѯ���岻����û�취�鵽������Ľ��
      //���һ��Ҫ����ͬ������
      qryCheck.DataInfo.TranID := qryDataA.DataInfo.TranID;
      qryCheck.SQL.Text := edCheckSQL.Lines.Text;
      if not qryCheck.OpenData then
      begin
        lErrMsg :=  qryCheck.DataInfo.ErrMsg;
        exit;
      end;
      if qryCheck.RecordCount > 1 then
      begin
        showMessage('���ݴ����ظ�,����');
        exit;
      end;
      if not qryDataA.ExecDML then
      begin
        //ִ��ʧ���˳�
        lErrMsg :=  qryDataA.DataInfo.ErrMsg;
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

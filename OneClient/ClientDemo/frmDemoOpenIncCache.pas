unit frmDemoOpenIncCache;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  OneClientHelper, OneClientConnect, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  OneClientDataSet, Vcl.Grids, Vcl.DBGrids, Data.SqlTimSt;

type
  TForm10 = class(TForm)
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
    dsMain: TDataSource;
    qryMain: TOneDataSet;
    Label4: TLabel;
    edSQL: TMemo;
    Label5: TLabel;
    edVersionField: TEdit;
    Label14: TLabel;
    edPrimaryKey: TEdit;
    tbOpenData: TButton;
    DBGrid1: TDBGrid;
    procedure tbClientConnectClick(Sender: TObject);
    procedure tbClientDisConnectClick(Sender: TObject);
    procedure tbOpenDataClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form10: TForm10;

implementation

{$R *.dfm}

procedure TForm10.tbClientConnectClick(Sender: TObject);
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

procedure TForm10.tbClientDisConnectClick(Sender: TObject);
begin
  OneConnection.DisConnect;
end;

procedure TForm10.tbOpenDataClick(Sender: TObject);
var
  vUrl: string;
  i: integer;
  lColumn: TColumn;
begin
  if not OneConnection.Connected then
  begin
    showMessage('δ������������');
    exit;
  end;

  // �����ڿؼ�UIֱ������ Connection
  qryMain.DataInfo.Connection := OneConnection;
  qryMain.SQL.Text := edSQL.Lines.Text;
  qryMain.DataInfo.PrimaryKey := edPrimaryKey.Text;
  qryMain.DataInfo.OpenVersionField := edVersionField.Text;
  if not qryMain.OpenDataIncCache then
  begin
    showMessage(qryMain.DataInfo.ErrMsg);
    exit;
  end;

  //
  DBGrid1.Columns.Clear;
  for i := 0 to qryMain.Fields.Count - 1 do
  begin
    lColumn := DBGrid1.Columns.Add;
    lColumn.FieldName := qryMain.Fields[i].FieldName;
    lColumn.Title.Caption := qryMain.Fields[i].FieldName;
    lColumn.Width := 100;
  end;
  showMessage('���»���ɹ�,���γɹ����»���[' + qryMain.DataInfo.OpenVersionCount.ToString() + ']');
end;

end.

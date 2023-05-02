unit frmDemoDatas;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  OneClientHelper, OneClientConnect, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  OneClientDataSet, Vcl.Grids, Vcl.DBGrids;

type
  TForm2 = class(TForm)
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
    OneConnection: TOneConnection;
    tbClientDisConnect: TButton;
    qryDataA: TOneDataSet;
    qryDataB: TOneDataSet;
    dsDataA: TDataSource;
    dsDataB: TDataSource;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    tbOpenDatas: TButton;
    tbSaveDatas: TButton;
    Label4: TLabel;
    edSQLA: TMemo;
    Label5: TLabel;
    edTableNameA: TEdit;
    Label14: TLabel;
    edPrimaryKeyA: TEdit;
    dbGridA: TDBGrid;
    Label6: TLabel;
    edSQLB: TMemo;
    Label7: TLabel;
    edTableNameB: TEdit;
    Label8: TLabel;
    edPrimaryKeyB: TEdit;
    dbGridB: TDBGrid;
    procedure tbClientConnectClick(Sender: TObject);
    procedure tbClientDisConnectClick(Sender: TObject);
    procedure tbOpenDatasClick(Sender: TObject);
    procedure tbSaveDatasClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}


procedure TForm2.tbClientConnectClick(Sender: TObject);
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

procedure TForm2.tbClientDisConnectClick(Sender: TObject);
begin
  OneConnection.DisConnect;
end;

procedure TForm2.tbOpenDatasClick(Sender: TObject);
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
  qryDataB.SQL.Text := edSQLB.Lines.Text;
  // 打开数据
  if not OneConnection.OpenOneDatas([qryDataA, qryDataB]) then
  begin
    showMessage(OneConnection.ErrMsg);
    exit;
  end;
  //
  for i := 0 to qryDataA.Fields.Count - 1 do
  begin
    lColumn := dbGridA.Columns.Add;
    lColumn.FieldName := qryDataA.Fields[i].FieldName;
    lColumn.Title.Caption := qryDataA.Fields[i].FieldName;
    lColumn.Width := 100;
  end;
  //
  dbGridB.Columns.Clear;
  for i := 0 to qryDataB.Fields.Count - 1 do
  begin
    lColumn := dbGridB.Columns.Add;
    lColumn.FieldName := qryDataB.Fields[i].FieldName;
    lColumn.Title.Caption := qryDataB.Fields[i].FieldName;
    lColumn.Width := 100;
  end;
  showMessage('打开数据成功');
end;

procedure TForm2.tbSaveDatasClick(Sender: TObject);
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
  qryDataA.DataInfo.TableName := edTableNameA.Text;
  qryDataA.DataInfo.PrimaryKey := edPrimaryKeyA.Text;
  qryDataB.SQL.Text := edSQLB.Lines.Text;
  qryDataB.DataInfo.TableName := edTableNameB.Text;
  qryDataB.DataInfo.PrimaryKey := edPrimaryKeyB.Text;
  // 打开数据
  if not OneConnection.SaveOneDatas([qryDataA, qryDataB]) then
  begin
    showMessage(OneConnection.ErrMsg);
    exit;
  end;
  showMessage('保存数据成功');
end;

end.

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
    showMessage('未连接请先连接');
    exit;
  end;

  // 或者在控件UI直接设置 Connection
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
  showMessage('更新缓存成功,本次成功更新缓存[' + qryMain.DataInfo.OpenVersionCount.ToString() + ']');
end;

end.

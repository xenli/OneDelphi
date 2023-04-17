unit frmDemoMetaInfo;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  OneClientHelper, OneClientConnect, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  OneClientDataSet, Vcl.Grids, Vcl.DBGrids;

type
  TfrDemoMetaInfo = class(TForm)
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
    qryMeta: TOneDataSet;
    Panel1: TPanel;
    DBGrid1: TDBGrid;
    tbGetTables: TButton;
    dsMeta: TDataSource;
    Label4: TLabel;
    edMetaObj: TEdit;
    tbGetTableFields: TButton;
    procedure tbClientConnectClick(Sender: TObject);
    procedure tbClientDisConnectClick(Sender: TObject);
    procedure tbGetTablesClick(Sender: TObject);
    procedure tbGetTableFieldsClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frDemoMetaInfo: TfrDemoMetaInfo;

implementation

{$R *.dfm}


procedure TfrDemoMetaInfo.tbClientConnectClick(Sender: TObject);
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

procedure TfrDemoMetaInfo.tbClientDisConnectClick(Sender: TObject);
begin
  OneConnection.DisConnect;
end;

procedure TfrDemoMetaInfo.tbGetTableFieldsClick(Sender: TObject);
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
  qryMeta.DataInfo.Connection := OneConnection;
  qryMeta.DataInfo.MetaInfoKind := TFDPhysMetaInfoKind.mkTableFields;
  qryMeta.DataInfo.TableName := edMetaObj.Text;
  if not qryMeta.GetDBMetaInfo then
  begin
    showMessage(qryMeta.DataInfo.ErrMsg);
    exit;
  end;
  //
  DBGrid1.Columns.Clear;
  for i := 0 to qryMeta.Fields.Count - 1 do
  begin
    lColumn := DBGrid1.Columns.Add;
    lColumn.FieldName := qryMeta.Fields[i].FieldName;
    lColumn.Title.Caption := qryMeta.Fields[i].FieldName;
    lColumn.Width := 100;
  end;
  showMessage('打开数据成功');
end;

procedure TfrDemoMetaInfo.tbGetTablesClick(Sender: TObject);
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
  qryMeta.DataInfo.Connection := OneConnection;
  qryMeta.DataInfo.MetaInfoKind := TFDPhysMetaInfoKind.mkTables;
  qryMeta.DataInfo.TableName := edMetaObj.Text;
  if not qryMeta.GetDBMetaInfo then
  begin
    showMessage(qryMeta.DataInfo.ErrMsg);
    exit;
  end;
  //
  DBGrid1.Columns.Clear;
  for i := 0 to qryMeta.Fields.Count - 1 do
  begin
    lColumn := DBGrid1.Columns.Add;
    lColumn.FieldName := qryMeta.Fields[i].FieldName;
    lColumn.Title.Caption := qryMeta.Fields[i].FieldName;
    lColumn.Width := 100;
  end;
  showMessage('打开数据成功');
end;

end.

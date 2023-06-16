unit frmDemoDataRefreshSingle;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  OneClientHelper, OneClientConnect, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  OneClientDataSet, Vcl.Grids, Vcl.DBGrids;

type
  TForm1 = class(TForm)
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
    edSQL: TMemo;
    edRefreshSQL: TMemo;
    OneConnection: TOneConnection;
    qryOpenData: TOneDataSet;
    dsOpenData: TDataSource;
    Label4: TLabel;
    Label5: TLabel;
    tbOpenData: TButton;
    tbRefreshSingle: TButton;
    DBGrid1: TDBGrid;
    edValues: TMemo;
    Label6: TLabel;
    procedure tbOpenDataClick(Sender: TObject);
    procedure tbClientConnectClick(Sender: TObject);
    procedure tbClientDisConnectClick(Sender: TObject);
    procedure tbRefreshSingleClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}


procedure TForm1.tbClientConnectClick(Sender: TObject);
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

procedure TForm1.tbClientDisConnectClick(Sender: TObject);
begin
  OneConnection.DisConnect;
end;

procedure TForm1.tbOpenDataClick(Sender: TObject);
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
  qryOpenData.DataInfo.Connection := OneConnection;
  qryOpenData.SQL.Text := edSQL.Lines.Text;
  if not qryOpenData.OpenData then
  begin
    showMessage(qryOpenData.DataInfo.ErrMsg);
    exit;
  end;
  //
  DBGrid1.Columns.Clear;
  for i := 0 to qryOpenData.Fields.Count - 1 do
  begin
    lColumn := DBGrid1.Columns.Add;
    lColumn.FieldName := qryOpenData.Fields[i].FieldName;
    lColumn.Title.Caption := qryOpenData.Fields[i].FieldName;
    lColumn.Width := 100;
  end;
  showMessage('打开数据成功');
end;

procedure TForm1.tbRefreshSingleClick(Sender: TObject);
var
  lSQL: string;
  lArry: array of Variant;
  i: integer;
begin
  if qryOpenData.IsEmpty then
  begin
    showMessage('请先打开数据');
    exit;
  end;
  lSQL := edRefreshSQL.Lines.Text;
  setLength(lArry, edValues.Lines.Count);
  for i := 0 to edValues.Lines.Count - 1 do
  begin
    lArry[i] := edValues.Lines[i];
  end;

  if qryOpenData.RefreshSingle(lSQL, lArry) then
  begin
    showMessage('刷新单条数据成功');
    // 是否要确定数据集，清除更改缓存，自已业务自已决定
    // qryOpenData.MergeChangeLog;
  end
  else
  begin
    showMessage(qryOpenData.DataInfo.ErrMsg);
  end;
end;

end.

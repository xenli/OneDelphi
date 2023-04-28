unit frmDemoLsh;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  OneClientHelper, OneClientConnect, OneClientFastLsh, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, OneClientDataSet, Vcl.Grids, Vcl.DBGrids, System.StrUtils, System.Generics.Collections;

type
  TfrDemoLsh = class(TForm)
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
    OneFastLsh: TOneFastLsh;
    edSQL: TMemo;
    Label4: TLabel;
    qrySet: TOneDataSet;
    DBGrid1: TDBGrid;
    dsSet: TDataSource;
    tbOpenData: TButton;
    tbAppend: TButton;
    tbSaveData: TButton;
    tbRefreshLshSet: TButton;
    tbGetLsh: TButton;
    tbLshList: TButton;
    edLsh: TMemo;
    procedure tbClientConnectClick(Sender: TObject);
    procedure tbClientDisConnectClick(Sender: TObject);
    procedure tbOpenDataClick(Sender: TObject);
    procedure tbAppendClick(Sender: TObject);
    procedure tbSaveDataClick(Sender: TObject);
    procedure tbRefreshLshSetClick(Sender: TObject);
    procedure tbGetLshClick(Sender: TObject);
    procedure tbLshListClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frDemoLsh: TfrDemoLsh;

implementation

{$R *.dfm}


function GetGUID32(): string;
var
  ii: TGUID;
begin
  CreateGUID(ii);
  Result := Copy(AnsiReplaceStr(GUIDToString(ii), '-', ''), 2, 32);
end;

procedure TfrDemoLsh.tbRefreshLshSetClick(Sender: TObject);
var
  lErrMsg: string;
begin
  if not OneFastLsh.RefreshLshSet(lErrMsg) then
  begin
    showMessage(lErrMsg);
  end
  else
  begin
    showMessage('刷新服务端配置成功');
  end;
end;

procedure TfrDemoLsh.tbAppendClick(Sender: TObject);
begin
  qrySet.Append;
  qrySet.FieldByName('FLshID').AsString := GetGUID32();
  qrySet.FieldByName('FLshCaption').AsString := '新的流水号配置';
  qrySet.FieldByName('FLshDateFormat').AsString := '按日';
  qrySet.FieldByName('FLshNoLength').AsInteger := 4;
  qrySet.Post;
end;

procedure TfrDemoLsh.tbClientConnectClick(Sender: TObject);
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

procedure TfrDemoLsh.tbClientDisConnectClick(Sender: TObject);
begin
  OneConnection.DisConnect;
end;

procedure TfrDemoLsh.tbGetLshClick(Sender: TObject);
var
  lLshCode, lLshNo: string;
  lErrMsg: string;
begin
  if qrySet.IsEmpty then
  begin
    showMessage('请先打开流水号配置，并选中一条数据');
    exit;
  end;
  lLshCode := qrySet.FieldByName('FLshCode').AsString;
  lLshNo := OneFastLsh.GetLsh(lLshCode, lErrMsg);
  if lErrMsg <> '' then
  begin
    showMessage(lErrMsg);
    exit;
  end;
  edLsh.Lines.Add(lLshNo);
end;

procedure TfrDemoLsh.tbLshListClick(Sender: TObject);
var
  lLshCode: string;
  lLshList: TList<string>;
  lErrMsg: string;
  i: integer;
begin
  if qrySet.IsEmpty then
  begin
    showMessage('请先打开流水号配置，并选中一条数据');
    exit;
  end;
  lLshCode := qrySet.FieldByName('FLshCode').AsString;
  lLshList := nil;
  lLshList := OneFastLsh.GetLshList(lLshCode, 10, lErrMsg);
  try
    if lErrMsg <> '' then
    begin
      showMessage(lErrMsg);
      exit;
    end;
    for i := 0 to lLshList.Count - 1 do
    begin
      edLsh.Lines.Add(lLshList[i]);
    end;
  finally
    if lLshList <> nil then
    begin
      lLshList.Clear;
      lLshList.Free;
    end;
  end;
end;

procedure TfrDemoLsh.tbOpenDataClick(Sender: TObject);
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
  qrySet.DataInfo.Connection := OneConnection;
  if not qrySet.OpenData then
  begin
    showMessage(qrySet.DataInfo.ErrMsg);
    exit;
  end;
  //
  DBGrid1.Columns.Clear;
  for i := 0 to qrySet.Fields.Count - 1 do
  begin
    lColumn := DBGrid1.Columns.Add;
    lColumn.FieldName := qrySet.Fields[i].FieldName;
    lColumn.Title.Caption := qrySet.Fields[i].FieldName;
    lColumn.Width := 100;
    if qrySet.Fields[i].DataType = ftboolean then
    begin
      lColumn.PickList.Add('true');
      lColumn.PickList.Add('false');
    end;
    if qrySet.Fields[i].FieldName = 'FLshDateFormat' then
    begin
      lColumn.PickList.Add('按年');
      lColumn.PickList.Add('按月');
      lColumn.PickList.Add('按日');
    end;
  end;
  showMessage('打开数据成功');
end;

procedure TfrDemoLsh.tbSaveDataClick(Sender: TObject);
var
  lDict: TDictionary<string, integer>;
  lLshCode: string;
begin
  inherited;
  if qrySet.State in dsEditModes then
    qrySet.Post;
  // 确定流水号代码是否重复
  lDict := TDictionary<string, integer>.Create;
  qrySet.DisableControls;
  try
    qrySet.First;
    while not qrySet.Eof do
    begin
      lLshCode := qrySet.FieldByName('FLshCode').AsString.Trim;
      if lLshCode = '' then
      begin
        showMessage('流水号代码为空,不可保存');
        exit;
      end;
      if lDict.ContainsKey(lLshCode.ToLower) then
      begin
        showMessage('流水号代码[' + lLshCode + ']重复，不可保存');
        exit;
      end
      else
      begin
        lDict.Add(lLshCode.ToLower, 1);
      end;
      qrySet.Next;
    end;
  finally
    qrySet.EnableControls;
    lDict.Clear;
    lDict.Free;
  end;
  if not qrySet.SaveData then
  begin
    showMessage(qrySet.DataInfo.ErrMsg);
    exit;
  end;
  showMessage('保存成功');
end;

end.

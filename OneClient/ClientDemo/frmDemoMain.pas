unit frmDemoMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, System.StrUtils,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, OneClientConnect, Vcl.ExtCtrls,
  Vcl.StdCtrls, Vcl.Mask, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  OneClientDataSet, Vcl.ComCtrls, Vcl.Grids, Vcl.DBGrids, OneClientHelper;

type
  TfrDemoMain = class(TForm)
    plSet: TPanel;
    Label1: TLabel;
    edHTTPHost: TEdit;
    Label2: TLabel;
    edHTTPPort: TEdit;
    Label3: TLabel;
    edConnectSecretkey: TEdit;
    tbClientConnect: TButton;
    OneConnection: TOneConnection;
    LabeledEdit1: TLabeledEdit;
    qryOpenData: TOneDataSet;
    PageControl1: TPageControl;
    tabDataSet: TTabSheet;
    tabDML: TTabSheet;
    Label4: TLabel;
    edSQL: TMemo;
    Label31: TLabel;
    edSQLParams: TMemo;
    Label13: TLabel;
    edPageSize: TEdit;
    edPageNowll: TLabel;
    edPageNow: TEdit;
    Label25: TLabel;
    edPageCount: TEdit;
    Label26: TLabel;
    edPageTotal: TEdit;
    tbOpenData: TButton;
    Label5: TLabel;
    edTableName: TEdit;
    Label14: TLabel;
    edPrimaryKey: TEdit;
    tbAppend: TButton;
    tbDel: TButton;
    DBGrid1: TDBGrid;
    tbSaveData: TButton;
    Label17: TLabel;
    edZTCode: TEdit;
    dsOpenData: TDataSource;
    tabStroe: TTabSheet;
    qryDMLData: TOneDataSet;
    edDMLSQL: TMemo;
    Label6: TLabel;
    edDMLMaxRow: TEdit;
    Label7: TLabel;
    edDMLMustRow: TEdit;
    tbDML: TButton;
    Memo1: TMemo;
    edDMLParam: TMemo;
    Label8: TLabel;
    Label9: TLabel;
    edSPName: TEdit;
    Label10: TLabel;
    edSPPackage: TEdit;
    edSPSQL: TMemo;
    edSPParams: TMemo;
    gridSP: TDBGrid;
    edSPOutData: TCheckBox;
    tbSP: TButton;
    Label11: TLabel;
    Label12: TLabel;
    Label15: TLabel;
    qrySPData: TOneDataSet;
    dsSPData: TDataSource;
    edSPReturnParams: TMemo;
    Label16: TLabel;
    tbClientDisConnect: TButton;
    GroupBox1: TGroupBox;
    edNoJoinFields: TMemo;
    dbRetureData: TCheckBox;
    procedure tbClientConnectClick(Sender: TObject);
    procedure tbOpenDataClick(Sender: TObject);
    procedure tbSaveDataClick(Sender: TObject);
    procedure tbAppendClick(Sender: TObject);
    procedure tbDelClick(Sender: TObject);
    procedure tbDMLClick(Sender: TObject);
    procedure tbSPClick(Sender: TObject);
    procedure tbClientDisConnectClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frDemoMain: TfrDemoMain;

implementation

{$R *.dfm}


procedure TfrDemoMain.tbAppendClick(Sender: TObject);
begin
  if not qryOpenData.Active then
  begin
    showMessage('请先打开数据集');
    exit;
  end;
//  if dbRetureData.Checked then
//  begin
//    qryOpenData.FieldByName(edPrimaryKey.Text).AutoGenerateValue := TAutoRefreshFlag.arNone;
//  end;
  qryOpenData.Append;
  // if dbRetureData.Checked then
  // begin
  // qryOpenData.FieldByName(edPrimaryKey.Text).AsInteger := -1;
  // end;
end;

procedure TfrDemoMain.tbClientConnectClick(Sender: TObject);
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

procedure TfrDemoMain.tbClientDisConnectClick(Sender: TObject);
begin
  OneConnection.DisConnect;
end;

procedure TfrDemoMain.tbDelClick(Sender: TObject);
begin
  if not qryOpenData.Active then
  begin
    showMessage('请先打开数据集');
    exit;
  end;
  if qryOpenData.IsEmpty then
  begin
    showMessage('数据已为空无需删除');
    exit;
  end;
  qryOpenData.Delete;
end;

procedure TfrDemoMain.tbDMLClick(Sender: TObject);
var
  i: integer;
begin
  if not OneConnection.Connected then
  begin
    showMessage('未连接请先连接');
    exit;
  end;
  qryDMLData.DataInfo.Connection := OneConnection;
  qryDMLData.SQL.Text := edDMLSQL.Lines.Text;
  if trystrToInt(edDMLMaxRow.Text, i) then
  begin
    if i <= 0 then
      i := 0;
    qryDMLData.DataInfo.AffectedMaxCount := i;
  end
  else
  begin
    qryDMLData.DataInfo.AffectedMaxCount := 0;
  end;
  if trystrToInt(edDMLMustRow.Text, i) then
  begin
    if i <= 0 then
      i := 0;
    qryDMLData.DataInfo.AffectedMustCount := i;
  end
  else
  begin
    qryDMLData.DataInfo.AffectedMustCount := 0;
  end;
  for i := 0 to qryDMLData.Params.Count - 1 do
  begin
    //
    if edDMLParam.Lines.Count >= i + 1 then
    begin
      qryDMLData.Params[i].Value := edDMLParam.Lines[i];
    end;
  end;

  if not qryDMLData.ExecDML then
  begin
    showMessage('执行失败:' + qryDMLData.DataInfo.ErrMsg)
  end
  else
  begin
    showMessage('执行成功,受影响行数:' + qryDMLData.DataInfo.RowsAffected.ToString())
  end;
end;

procedure TfrDemoMain.tbOpenDataClick(Sender: TObject);
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
  for i := 0 to qryOpenData.Params.Count - 1 do
  begin
    //
    if edSQLParams.Lines.Count >= i + 1 then
    begin
      qryOpenData.Params[i].Value := edSQLParams.Lines[i];
    end;
  end;

  if trystrToInt(edPageSize.Text, i) then
  begin
    if i <= 0 then
      i := -1;
    qryOpenData.DataInfo.PageSize := i;
  end;
  if trystrToInt(edPageNow.Text, i) then
  begin
    if i <= 0 then
      i := 1;
    qryOpenData.DataInfo.PageIndex := i;
  end;

  if not qryOpenData.OpenData then
  begin
    showMessage(qryOpenData.DataInfo.ErrMsg);
    exit;
  end;
  //
  edPageCount.Text := qryOpenData.DataInfo.PageCount.ToString;
  edPageTotal.Text := qryOpenData.DataInfo.PageTotal.ToString;
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

procedure TfrDemoMain.tbSaveDataClick(Sender: TObject);
var
  i: integer;
  lFieldName: string;
  lField: TField;
begin
  // 不参与保存的字段,特别是多表关联单表保存
  for i := 0 to edNoJoinFields.Lines.Count - 1 do
  begin
    lFieldName := edNoJoinFields.Lines[i];
    if lFieldName = '' then
      continue;
    lField := qryOpenData.FindField(lFieldName);
    if lField <> nil then
    begin
      // 不参与保存任何动作
      lField.ProviderFlags := [];
    end;
  end;

  qryOpenData.DataInfo.Connection := OneConnection;
  qryOpenData.DataInfo.TableName := edTableName.Text;
  qryOpenData.DataInfo.PrimaryKey := edPrimaryKey.Text;
  // 有自增ID的这个打勾即可
  qryOpenData.DataInfo.IsReturnData := dbRetureData.Checked;
  if qryOpenData.State in dsEditModes then
    qryOpenData.Post;
  // 两个方法多行，最终调用同一个方法
  // if qryOpenData.save then
  if qryOpenData.SaveData then
  begin
    showMessage('保存数据成功');
  end
  else
  begin
    showMessage(qryOpenData.DataInfo.ErrMsg);
  end;
end;

procedure TfrDemoMain.tbSPClick(Sender: TObject);
var
  i: integer;
  lColumn: TColumn;
begin
  //
  if not OneConnection.Connected then
  begin
    showMessage('未连接请先连接');
    exit;
  end;
  // 或者在控件UI直接设置 Connection
  qrySPData.DataInfo.Connection := OneConnection;
  qrySPData.DataInfo.PackageName := edSPPackage.Text;
  qrySPData.DataInfo.StoredProcName := edSPName.Text;
  qrySPData.DataInfo.IsReturnData := edSPOutData.Checked;
  // 自动产生参数
  qrySPData.SQL.Text := edSPSQL.Lines.Text;
  for i := 0 to qrySPData.Params.Count - 1 do
  begin
    //
    if edSPParams.Lines.Count >= i + 1 then
    begin
      qrySPData.Params[i].Value := edSPParams.Lines[i];
    end;
  end;
  if qrySPData.DataInfo.IsReturnData then
  begin
    // 返回数据调用方法
    if not qrySPData.OpenStored then
    begin
      showMessage('执行存储过程异常:' + qrySPData.DataInfo.ErrMsg);
      exit;
    end;
    gridSP.Columns.Clear;
    for i := 0 to qrySPData.Fields.Count - 1 do
    begin
      lColumn := gridSP.Columns.Add;
      lColumn.FieldName := qrySPData.Fields[i].FieldName;
      lColumn.Title.Caption := qrySPData.Fields[i].FieldName;
      lColumn.Width := 100;
    end;
    // 返回参数展示
    edSPReturnParams.Lines.Clear;
    for i := 0 to qrySPData.Params.Count - 1 do
    begin
      //
      edSPReturnParams.Lines.Add(qrySPData.Params[i].AsString);
    end;

    showMessage('执行存储过程成功,获取数据成功');
  end
  else
  begin
    // 只是执行存储过程调用方法
    if not qrySPData.ExecStored then
    begin

      showMessage('执行存储过程异常:' + qrySPData.DataInfo.ErrMsg);
    end
    else
    begin
      // 返回参数展示
      edSPReturnParams.Lines.Clear;
      for i := 0 to qrySPData.Params.Count - 1 do
      begin
        //
        edSPReturnParams.Lines.Add(qrySPData.Params[i].AsString);
      end;
      showMessage('执行存储过程成功');
    end;
  end;

end;

end.

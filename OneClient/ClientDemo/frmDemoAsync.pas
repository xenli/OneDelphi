unit frmDemoAsync;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, System.Threading,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  OneClientHelper, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  OneClientDataSet, Vcl.Grids, Vcl.DBGrids, OneClientConnect;

type
  TForm5 = class(TForm)
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
    qryOpenData: TOneDataSet;
    dsOpenData: TDataSource;
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
    DBGrid1: TDBGrid;
    OneConnection: TOneConnection;
    tbOpenAsyncCust: TButton;
    tbOpenDataAsync2: TButton;
    Label5: TLabel;
    Label6: TLabel;
    edTableName: TEdit;
    Label14: TLabel;
    edPrimaryKey: TEdit;
    tbSaveData: TButton;
    procedure tbClientConnectClick(Sender: TObject);
    procedure tbClientDisConnectClick(Sender: TObject);
    procedure tbOpenDataClick(Sender: TObject);
    procedure tbOpenAsyncCustClick(Sender: TObject);
    procedure tbOpenDataAsync2Click(Sender: TObject);
    procedure tbSaveDataClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form5: TForm5;

implementation

{$R *.dfm}


procedure TForm5.tbClientConnectClick(Sender: TObject);
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

procedure TForm5.tbClientDisConnectClick(Sender: TObject);
begin
  OneConnection.DisConnect;
end;

procedure TForm5.tbOpenAsyncCustClick(Sender: TObject);
var
  vUrl: string;
  i: integer;
  lColumn: TColumn;
  aTask: ITask;
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

  // 异步打开数据
  aTask := TTask.Create(
    procedure
    var
      lIsOK: boolean;
    begin
      lIsOK := qryOpenData.OpenData;
      TThread.Synchronize(nil,
        procedure()
        var
          i: integer;
        begin
          if lIsOK then
          begin
            edPageCount.Text := qryOpenData.DataInfo.PageCount.ToString;
            edPageTotal.Text := qryOpenData.DataInfo.PageTotal.ToString;
            //
            qryOpenData.DisableControls;
            try
              DBGrid1.Columns.Clear;
              for i := 0 to qryOpenData.Fields.Count - 1 do
              begin
                lColumn := DBGrid1.Columns.Add;
                lColumn.FieldName := qryOpenData.Fields[i].FieldName;
                lColumn.Title.Caption := qryOpenData.Fields[i].FieldName;
                lColumn.Width := 100;
              end;
            finally
              qryOpenData.EnableControls;
            end;
            showMessage('打开数据成功');
          end
          else
            showMessage(qryOpenData.DataInfo.ErrMsg);
        end);
    end);
  aTask.Start;
end;

procedure TForm5.tbOpenDataAsync2Click(Sender: TObject);
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

  // 异步打开数据
  TThread.CreateAnonymousThread(
    procedure
    var
      lIsOK: boolean;
    begin
      lIsOK := qryOpenData.OpenData;
      TThread.Synchronize(nil,
        procedure()
        var
          i: integer;
        begin
          if lIsOK then
          begin
            edPageCount.Text := qryOpenData.DataInfo.PageCount.ToString;
            edPageTotal.Text := qryOpenData.DataInfo.PageTotal.ToString;
            //
            qryOpenData.DisableControls;
            try
              DBGrid1.Columns.Clear;
              for i := 0 to qryOpenData.Fields.Count - 1 do
              begin
                lColumn := DBGrid1.Columns.Add;
                lColumn.FieldName := qryOpenData.Fields[i].FieldName;
                lColumn.Title.Caption := qryOpenData.Fields[i].FieldName;
                lColumn.Width := 100;
              end;
            finally
              qryOpenData.EnableControls;
            end;
            showMessage('打开数据成功');
          end
          else
            showMessage(qryOpenData.DataInfo.ErrMsg);
        end);
    end).Start;
end;

procedure TForm5.tbOpenDataClick(Sender: TObject);
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
  // 异步打开数据
  qryOpenData.OpenDataAsync(
    procedure(QIsOK: boolean; QErrMsg: string)
    var
      i: integer;
    begin
      // 自代的已经包装好了
      if QIsOK then
      begin
        edPageCount.Text := qryOpenData.DataInfo.PageCount.ToString;
        edPageTotal.Text := qryOpenData.DataInfo.PageTotal.ToString;
        //
        qryOpenData.DisableControls;
        try
          DBGrid1.Columns.Clear;
          for i := 0 to qryOpenData.Fields.Count - 1 do
          begin
            lColumn := DBGrid1.Columns.Add;
            lColumn.FieldName := qryOpenData.Fields[i].FieldName;
            lColumn.Title.Caption := qryOpenData.Fields[i].FieldName;
            lColumn.Width := 100;
          end;
        finally
          qryOpenData.EnableControls;
        end;
        showMessage('打开数据成功');
      end
      else
        showMessage(QErrMsg);
    end);
end;

procedure TForm5.tbSaveDataClick(Sender: TObject);
begin
  qryOpenData.DataInfo.Connection := OneConnection;
  qryOpenData.DataInfo.TableName := edTableName.Text;
  qryOpenData.DataInfo.PrimaryKey := edPrimaryKey.Text;
  if qryOpenData.State in dsEditModes then
    qryOpenData.Post;
  qryOpenData.SaveDataAsync(
    procedure(QIsOK: boolean; QErrMsg: string)
    var
      i: integer;
    begin
      // 自代的已经包装好了
      if QIsOK then
      begin
        showMessage('保存成功');
      end
      else
        showMessage(QErrMsg);
    end);
end;

end.

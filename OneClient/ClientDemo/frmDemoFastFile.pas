unit frmDemoFastFile;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  OneClientHelper, OneClientConnect, OneClientFastFile, Vcl.ComCtrls,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, OneClientDataSet,
  Vcl.Grids, Vcl.DBGrids, System.StrUtils, System.Generics.Collections;

type
  TfrDemoFastFile = class(TForm)
    plSet: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    edHTTPHost: TEdit;
    edHTTPPort: TEdit;
    edConnectSecretkey: TEdit;
    tbClientConnect: TButton;
    tbClientDisConnect: TButton;
    OneConnection: TOneConnection;
    OneFastFile: TOneFastFile;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Label4: TLabel;
    edSQL: TMemo;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    qryMain: TOneDataSet;
    DBGrid1: TDBGrid;
    Panel1: TPanel;
    tbOpenData: TButton;
    tbAppend: TButton;
    tbSaveData: TButton;
    Button1: TButton;
    Label5: TLabel;
    edFileCode: TEdit;
    Label17: TLabel;
    edZTCode: TEdit;
    Label6: TLabel;
    edRelationID: TEdit;
    GridFile: TDBGrid;
    Label7: TLabel;
    tbFileUpload: TButton;
    tbFileDown: TButton;
    tbOpenFile: TButton;
    tbFileDel: TButton;
    dsMain: TDataSource;
    qryFile: TOneDataSet;
    dsFile: TDataSource;
    OpenDialog1: TOpenDialog;
    tbFilesUpload: TButton;
    FileOpenDialog1: TFileOpenDialog;
    ProgressFileSize: TProgressBar;
    Label9: TLabel;
    ProgressFileCount: TProgressBar;
    Label8: TLabel;
    procedure tbClientConnectClick(Sender: TObject);
    procedure tbClientDisConnectClick(Sender: TObject);
    procedure tbOpenDataClick(Sender: TObject);
    procedure tbAppendClick(Sender: TObject);
    procedure tbSaveDataClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure tbOpenFileClick(Sender: TObject);
    procedure tbFileUploadClick(Sender: TObject);
    procedure tbFilesUploadClick(Sender: TObject);
    procedure tbFileDelClick(Sender: TObject);
    procedure tbFileDownClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure OneFastFileCallBack(QFileStep: enumFileStep; QFileCount,
      QIndexFile: Integer; QFileName: string; QFileSize, QFilePosition: Int64);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frDemoFastFile: TfrDemoFastFile;

implementation

{$R *.dfm}


function GetGUID32(): string;
var
  ii: TGUID;
begin
  CreateGUID(ii);
  Result := Copy(AnsiReplaceStr(GUIDToString(ii), '-', ''), 2, 32);
end;

procedure TfrDemoFastFile.Button1Click(Sender: TObject);
begin
  if not OneFastFile.RefreshFileSetAll() then
  begin
    showMessage(OneFastFile.ErrMsg);
  end
  else
  begin
    showMessage('刷新成功');
  end;
end;

procedure TfrDemoFastFile.FormCreate(Sender: TObject);
begin
  PageControl1.ActivePageIndex := 0;
end;

procedure TfrDemoFastFile.OneFastFileCallBack(QFileStep: enumFileStep;
  QFileCount, QIndexFile: Integer; QFileName: string; QFileSize,
  QFilePosition: Int64);
begin
  //
  Application.ProcessMessages;
  if QFileStep = emStepStart then
  begin
    ProgressFileCount.Position := 0;
    ProgressFileCount.Max := QFileCount;
    ProgressFileSize.Position := 0;

    // edUpdate.Lines.Add('开始升级');
    // edUpdate.Lines.Add('文件个数:' + QFileCount.ToString);
  end
  else if QFileStep = emStepEnd then
  begin
    // 升级文件下件下载成功
    // edUpdate.Lines.Add('结束升级');
  end
  else if QFileStep = emFileStart then
  begin
    ProgressFileCount.Position := QIndexFile + 1;
    ProgressFileSize.Position := 0;
    ProgressFileSize.Max := 100;
    // edUpdate.Lines.Add('开始下载文件:[' + QFileName + ']');
    // edUpdate.Lines.Add('文件总长度:[' + QFileName + ']->' + QFileSize.ToString);
  end
  else if QFileStep = emFileProcess then
  begin
    if QFileSize > 0 then
      ProgressFileSize.Position := Round(QFilePosition / QFileSize) * 100;
    // edUpdate.Lines.Add('文件下载进度:[' + QFileName + ']->' + QFilePosition.ToString + '/' + QFileSize.ToString);
  end
  else if QFileStep = emStepErr then
  begin
    // edUpdate.Lines.Add('下载文件:[' + QFileName + ']发生错误');
    // edUpdate.Lines.Add('错误原因:' + OneFastUpdate1.ErrMsg);
  end;
end;

procedure TfrDemoFastFile.tbAppendClick(Sender: TObject);
begin
  qryMain.Append;
  qryMain.FieldByName('FFileSetID').AsString := GetGUID32();
  qryMain.FieldByName('FFileSetCaption').AsString := '新的文件配置';
  qryMain.FieldByName('FIsEnabled').AsBoolean := true;
  qryMain.Post;
end;

procedure TfrDemoFastFile.tbClientConnectClick(Sender: TObject);
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

procedure TfrDemoFastFile.tbClientDisConnectClick(Sender: TObject);
begin
  OneConnection.DisConnect;
end;

procedure TfrDemoFastFile.tbFileDelClick(Sender: TObject);
var
  lMsg: string;
begin
  if edFileCode.Text = '' then
  begin
    showMessage('文件配置代码为空');
    exit;
  end;
  OneFastFile.FileSetCode := edFileCode.Text;
  if qryFile.IsEmpty then
  begin
    showMessage('请先选中一个关联文件');
    exit;
  end;
  lMsg := '确定要删除当前关联文件' + qryFile.FieldByName('FFileName').AsString;
  if not(MessageBox(Handle, PWidechar(lMsg), '删除提示', MB_OKCANCEL + MB_ICONQUESTION) = IDOK) then
  begin
    exit;
  end;
  if OneFastFile.FileDel(qryFile.FieldByName('FFileID').AsString) then
  begin
    qryFile.Delete;
    qryFile.MergeChangeLog;
    showMessage('删除文件成功');
  end
  else
  begin
    showMessage(OneFastFile.ErrMsg);
  end;
end;

procedure TfrDemoFastFile.tbFileDownClick(Sender: TObject);
var
  lSavePath: string;
begin
  lSavePath := '';
  if edFileCode.Text = '' then
  begin
    showMessage('文件配置代码为空');
    exit;
  end;
  OneFastFile.FileSetCode := edFileCode.Text;
  // 当没有 lSavePath 默认保存在程序exe  \OnePlatform\OneFastFile 文件夹下面
  if FileOpenDialog1.Execute then
  begin
    lSavePath := FileOpenDialog1.FileName;
    if qryFile.IsEmpty then
    begin
      showMessage('请先选中一个关联文件下载');
      exit;
    end;
    if not OneFastFile.FileDown(qryFile.FieldByName('FFileID').AsString, lSavePath) then
    begin
      showMessage(OneFastFile.ErrMsg);
    end
    else
    begin
      showMessage('下载文件成功');
    end;
  end;

end;

procedure TfrDemoFastFile.tbFilesUploadClick(Sender: TObject);
var
  lFileNames: TList<string>;
  i: Integer;
begin
  // 单选情况
  if edFileCode.Text = '' then
  begin
    showMessage('文件配置代码为空');
    exit;
  end;
  if edRelationID.Text = '' then
  begin
    showMessage('关联的业务ID为空');
    exit;
  end;
  OneFastFile.FileSetCode := edFileCode.Text;
  OneFastFile.RelationID := edRelationID.Text;
  OpenDialog1.Options := OpenDialog1.Options + [ofAllowMultiSelect];
  if not OpenDialog1.Execute then
  begin
    exit;
  end;
  lFileNames := TList<string>.create;
  try
    for i := 0 to OpenDialog1.Files.Count - 1 do
    begin
      lFileNames.Add(OpenDialog1.Files[i]);
    end;
    if not OneFastFile.FilesUpLoad(lFileNames) then
    begin
      showMessage(OneFastFile.ErrMsg);
    end
    else
    begin
      showMessage('上传文件成功');
    end;
  finally
    lFileNames.Clear;
    lFileNames.Free;
  end;
end;

procedure TfrDemoFastFile.tbFileUploadClick(Sender: TObject);
var
  lFileName: string;
  i: Integer;
begin
  // 单选情况
  if edFileCode.Text = '' then
  begin
    showMessage('文件配置代码为空');
    exit;
  end;
  if edRelationID.Text = '' then
  begin
    showMessage('关联的业务ID为空');
    exit;
  end;

  OneFastFile.FileSetCode := edFileCode.Text;
  OneFastFile.RelationID := edRelationID.Text;
  OpenDialog1.Options := OpenDialog1.Options - [ofAllowMultiSelect];
  if not OpenDialog1.Execute then
  begin
    exit;
  end;
  lFileName := OpenDialog1.FileName;
  if not OneFastFile.FileUpLoad(lFileName) then
  begin
    showMessage(OneFastFile.ErrMsg);
  end
  else
  begin
    showMessage('上传文件成功');
  end;
end;

procedure TfrDemoFastFile.tbOpenDataClick(Sender: TObject);
var
  vUrl: string;
  i: Integer;
  lColumn: TColumn;
begin
  if not OneConnection.Connected then
  begin
    showMessage('未连接请先连接');
    exit;
  end;
  // 或者在控件UI直接设置 Connection
  qryMain.DataInfo.Connection := OneConnection;
  if not qryMain.OpenData then
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
    if qryMain.Fields[i].DataType = ftboolean then
    begin
      lColumn.PickList.Add('true');
      lColumn.PickList.Add('false');
    end;
  end;
  showMessage('打开数据成功');
end;

procedure TfrDemoFastFile.tbOpenFileClick(Sender: TObject);
var
  i: Integer;
  lColumn: TColumn;
begin
  //
  if edRelationID.Text = '' then
  begin
    showMessage('业务关联ID为空,请先输入');
    exit;
  end;
  qryFile.DataInfo.Connection := OneConnection;
  if qryFile.Active then
    qryFile.Close;
  qryFile.Params[0].AsString := edRelationID.Text;
  if not qryFile.OpenData then
  begin
    showMessage(qryFile.DataInfo.ErrMsg);
    exit;
  end;
  GridFile.Columns.Clear;
  for i := 0 to qryFile.Fields.Count - 1 do
  begin
    lColumn := GridFile.Columns.Add;
    lColumn.FieldName := qryFile.Fields[i].FieldName;
    lColumn.Title.Caption := qryFile.Fields[i].FieldName;
    lColumn.Width := 100;
  end;
  showMessage('打开数据成功');
end;

procedure TfrDemoFastFile.tbSaveDataClick(Sender: TObject);
var
  lDict: TDictionary<string, Integer>;
  lLshCode: string;
begin
  inherited;
  if qryMain.State in dsEditModes then
    qryMain.Post;
  // 确定流水号代码是否重复
  lDict := TDictionary<string, Integer>.create;
  qryMain.DisableControls;
  try
    qryMain.First;
    while not qryMain.Eof do
    begin
      lLshCode := qryMain.FieldByName('FFileSetCode').AsString.Trim;
      if lLshCode = '' then
      begin
        showMessage('文件配置代码为空,不可保存');
        exit;
      end;
      if lDict.ContainsKey(lLshCode.ToLower) then
      begin
        showMessage('文件配置代码[' + lLshCode + ']重复，不可保存');
        exit;
      end
      else
      begin
        lDict.Add(lLshCode.ToLower, 1);
      end;
      qryMain.Next;
    end;
  finally
    qryMain.EnableControls;
    lDict.Clear;
    lDict.Free;
  end;
  if not qryMain.SaveData then
  begin
    showMessage(qryMain.DataInfo.ErrMsg);
    exit;
  end;
  showMessage('保存成功');
end;

end.

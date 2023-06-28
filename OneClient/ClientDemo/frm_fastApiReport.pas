unit frm_fastApiReport;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, dxBar, cxClasses,
  frxExportImage, frxExportHTML, frxDesgn, frxClass, frxGZip, frxExportPPTX,
  frxExportXML, frxExportXLSX, frxExportXLS, frxExportPDF, frxExportBaseDialog,
  OneClientFastReport, Vcl.StdCtrls, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters, Vcl.Menus, cxButtons, cxControls, cxContainer, cxEdit,
  cxLabel, System.JSON, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  System.Generics.Collections, frxDBSet, cxTextEdit, cxStyles, cxCustomData,
  cxFilter, cxData, cxDataStorage, cxNavigator, dxDateRanges,
  dxScrollbarAnnotations, cxDBData, cxGridLevel, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid,
  cxDropDownEdit, OneClientHelper, OneClientDataSet, System.IOUtils;

type
  TfrmFastApiReport = class(TForm)
    frxJPEGExport1: TfrxJPEGExport;
    frxPDFExport1: TfrxPDFExport;
    ReportMain: TfrxReport;
    frxXLSExport1: TfrxXLSExport;
    frxBMPExport1: TfrxBMPExport;
    frxXLSXExport1: TfrxXLSXExport;
    frxXMLExport1: TfrxXMLExport;
    frxPPTXExport1: TfrxPPTXExport;
    frxGZipCompressor1: TfrxGZipCompressor;
    frDesign: TfrxDesigner;
    frxHTMLExport1: TfrxHTMLExport;
    frxGIFExport1: TfrxGIFExport;
    OneServerFastReport: TOneServerFastReport;
    tbOpenApiData: TcxButton;
    tbDownReport: TcxButton;
    tbSaveReport: TcxButton;
    tbReportDesign: TcxButton;
    cxLabel1: TcxLabel;
    frxDBDataset1: TfrxDBDataset;
    cxLabel2: TcxLabel;
    edApiCode: TcxTextEdit;
    qryParam: TFDMemTable;
    dsParam: TDataSource;
    qryParamFKey: TWideStringField;
    qryParamFValue: TWideStringField;
    qryParamFType: TWideStringField;
    grdParam: TcxGrid;
    vwParam: TcxGridDBTableView;
    lvParam: TcxGridLevel;
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    vwParamFKey: TcxGridDBColumn;
    vwParamFValue: TcxGridDBColumn;
    vwParamFType: TcxGridDBColumn;
    procedure tbExitClick(Sender: TObject);
    function frDesignSaveReport(Report: TfrxReport; SaveAs: Boolean): Boolean;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure tbOpenApiDataClick(Sender: TObject);
    procedure tbDownReportClick(Sender: TObject);
    procedure tbReportDesignClick(Sender: TObject);
    procedure tbSaveReportClick(Sender: TObject);
    procedure qryParamNewRecord(DataSet: TDataSet);
    procedure cxButton1Click(Sender: TObject);
    procedure cxButton2Click(Sender: TObject);
  private
    { Private declarations }
    FApiID: string;
    FApiCode: string;
    FDataList: TList<TOneDataSet>;
  private
    function GetSaveFile(): string;
  public
    { Public declarations }
  end;

procedure ShowFastApiReport(QApiID: string; QApiCode: string);

var
  frmFastApiReport: TfrmFastApiReport;

implementation

{$R *.dfm}


uses OneFileHelper;

procedure ShowFastApiReport(QApiID: string; QApiCode: string);
begin
  if QApiID = '' then
  begin
    showMessage('ApiID为空,请传参数');
    exit;
  end;
  frmFastApiReport := TfrmFastApiReport.Create(nil);
  try
    frmFastApiReport.FApiID := QApiID;
    frmFastApiReport.FApiCode := QApiCode;
    frmFastApiReport.edApiCode.Text := QApiCode;
    frmFastApiReport.ShowModal;
  finally
    FreeAndNil(frmFastApiReport);
  end;
end;

procedure TfrmFastApiReport.cxButton1Click(Sender: TObject);
begin
  inherited;
  qryParam.Append;
  qryParam.Post;
end;

procedure TfrmFastApiReport.cxButton2Click(Sender: TObject);
begin
  inherited;
  if qryParam.IsEmpty then
    exit;
  qryParam.Delete;
end;

procedure TfrmFastApiReport.FormCreate(Sender: TObject);
begin
  inherited;
  FDataList := TList<TOneDataSet>.Create;
  qryParam.CreateDataSet;
end;

procedure TfrmFastApiReport.FormDestroy(Sender: TObject);
var
  i: Integer;
begin
  inherited;
  for i := 0 to FDataList.Count - 1 do
  begin
    FDataList[i].Free;
  end;
  FDataList.clear;
  FDataList.Free;
end;

function TfrmFastApiReport.frDesignSaveReport(Report: TfrxReport;
  SaveAs: Boolean): Boolean;
var
  lSaveFile: string;
begin
  inherited;
  //
  Report.Designer.Modified := false;
  lSaveFile := self.GetSaveFile();
  ReportMain.SaveToFile(lSaveFile);
end;

function TfrmFastApiReport.GetSaveFile(): string;
var
  tempPath: string;
begin
  Result := '';
  tempPath := OneFileHelper.CombineExeRunPath('OnePlatform');
  tempPath := OneFileHelper.CombinePath(tempPath, 'OneFastReport');
  if not TDirectory.Exists(tempPath) then
  begin
    TDirectory.CreateDirectory(tempPath);
  end;

  Result := OneFileHelper.CombinePath(tempPath, self.FApiID + '.data');
end;

procedure TfrmFastApiReport.qryParamNewRecord(DataSet: TDataSet);
begin
  inherited;
  qryParamFType.AsString := '字符串';
end;

procedure TfrmFastApiReport.tbDownReportClick(Sender: TObject);
var
  lSaveFile: string;
begin
  inherited;
  if OneServerFastReport.IsExistReportFile(self.FApiID) then
  begin
    lSaveFile := self.GetSaveFile();
    if not OneServerFastReport.DownloadReportFile(self.FApiID, lSaveFile) then
    begin
      showMessage(OneServerFastReport.ErrMsg);
    end
    else
    begin
      showMessage('下载报表成功')
    end;
  end
  else
  begin
    showMessage('服务端不存在此报表,直接本地报表设计新建报表即可')
  end;
end;

procedure TfrmFastApiReport.tbExitClick(Sender: TObject);
begin
  inherited;
  self.Close;
end;

procedure TfrmFastApiReport.tbOpenApiDataClick(Sender: TObject);
var
  lJsonObj, lJsonParam: TJsonObject;
  lDataList: TList<TOneDataSet>;
  i: Integer;
  lfrxFDQuery: TfrxDBDataset;
begin
  inherited;
  lDataList := nil;
  lJsonObj := TJsonObject.Create;
  try
    lJsonObj.AddPair('apiCode', edApiCode.Text);
    lJsonObj.AddPair('apiData', TJsonObject.Create);
    lJsonParam := TJsonObject.Create;
    lJsonObj.AddPair('apiParam', lJsonParam);
    qryParam.First;
    while not qryParam.Eof do
    begin
      // 字符串 数字 布尔

      if qryParamFKey.AsString <> '' then
      begin
        if qryParamFType.AsString = '布尔' then
        begin
          lJsonParam.AddPair(qryParamFKey.AsString, TJsonBool.Create(false));
        end
        else if qryParamFType.AsString = '数字' then
        begin
          lJsonParam.AddPair(qryParamFKey.AsString, TJsonNumber.Create(qryParamFValue.AsString));
        end
        else
        begin
          lJsonParam.AddPair(qryParamFKey.AsString, qryParamFValue.AsString);
        end;
      end;
      qryParam.Next;
    end;
    lDataList := OneServerFastReport.OpenFastReportDatas(lJsonObj);
    if lDataList = nil then
    begin
      showMessage(OneServerFastReport.ErrMsg);
      exit;
    end;
    for i := 0 to self.FDataList.Count - 1 do
    begin
      self.FDataList[i].Free;
    end;
    self.FDataList.clear;
    for i := 0 to lDataList.Count - 1 do
    begin
      self.FDataList.Add(lDataList[i]);
    end;
    // 处理报表
    ReportMain.clear;
    // 增加参数
    ReportMain.Script.AddVariable('Var_UserID', 'string', '');
    ReportMain.Script.AddVariable('Var_UserCode', 'string', '');
    ReportMain.Script.AddVariable('Var_UserName', 'string', '');
    //
    for i := 0 to self.FDataList.Count - 1 do
    begin
      lfrxFDQuery := TfrxDBDataset.Create(self);
      lfrxFDQuery.Name := self.FDataList[i].Name;
      lfrxFDQuery.DataSet := self.FDataList[i];
      ReportMain.DataSets.Add(lfrxFDQuery);
    end;
    showMessage('打开接口数据成功,获取数据集个数' + self.FDataList.Count.ToString);
  finally
    lJsonObj.Free;
    if lDataList <> nil then
    begin
      lDataList.clear;
      lDataList.Free;
    end;
  end;
end;

procedure TfrmFastApiReport.tbReportDesignClick(Sender: TObject);
var
  lSaveFile: string;
begin
  inherited;
  lSaveFile := self.GetSaveFile();
  ReportMain.LoadFromFile(lSaveFile);
  ReportMain.DesignReport;
end;

procedure TfrmFastApiReport.tbSaveReportClick(Sender: TObject);
var
  lSaveFile: string;
begin
  inherited;
  //
  lSaveFile := self.GetSaveFile();
  if not OneServerFastReport.UploadReportFile(self.FApiID, lSaveFile) then
  begin
    showMessage(OneServerFastReport.ErrMsg);
    exit;
  end;
  showMessage('上传报表成功');
end;

end.

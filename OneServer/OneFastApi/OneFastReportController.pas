unit OneFastReportController;

{ 服务端FR报表打印,没错，它来了 }
interface

uses
  system.StrUtils, system.SysUtils, Math, system.JSON, system.Threading, system.Classes,
  OneHttpController, OneHttpRouterManage, OneHttpCtxtResult, OneTokenManage, OneHttpConst,
  system.Generics.Collections, OneControllerResult, FireDAC.Comp.Client, Data.DB, OneGuID,
  OneDataInfo, FireDAC.Comp.DataSet, FireDAC.Stan.Intf, system.IOUtils;

type
  TFastReportController = class(TOneControllerBase)
  public
    // 进行报表打印
    function DoFastReport(QPostJson: TJsonObject): TActionResult<string>;
    // 获取数据集,进行本地FR报表设计
    function OpenFastReportDatas(QPostJson: TJsonObject): TOneDataResult;
    function UploadReportFile(QApiID: string; QFileData: string): TActionResult<string>;
    function DownloadReportFile(QApiID: string): TActionResult<string>;
    function IsExistReportFile(QApiID: string): TActionResult<string>;
  end;

implementation

{ 这边引用到了FR如果没装此控件的，屏B这个单元 }
uses OneGlobal, OneFastApiManage, OneFastApiDo, OneFileHelper, OneStreamString,
  frxClass, frxDBSet, frxDesgn, frxCross, frxBarcode, frxExportHTMLDiv,
  frxExportPPTX, frxExportDOCX, frxExportXLSX, frxExportHTML, frxExportPDF,
  frxExportImage, frxExportText, frxExportCSV, frxExportDBF, frxExportODF,
  frxExportMail, frxExportXML, frxExportXLS, frxCrypt, frxGZip, frxDCtrl,
  frxDMPExport, frxGradient, frxChBox, frxRich, frxOLE, frxExportBaseDialog;

function CreateNewFastReportController(QRouterItem: TOneRouterWorkItem): Tobject;
var
  lController: TFastReportController;
begin
  // 自定义创建控制器类，否则会按 TPersistentclass.create
  // 最好自定义一个好
  lController := TFastReportController.Create;
  // 挂载RTTI信息
  lController.RouterItem := QRouterItem;
  result := lController;
end;

function TFastReportController.DoFastReport(QPostJson: TJsonObject): TActionResult<string>;
var
  lTokenItem: TOneTokenItem;
  lErrMsg: string;
  lFastApiInfo: TFastApiInfo;
  lApiAll: TApiAll;
  iParam, iStep: Integer;
  lJsonName, lJsonValue: string;
  lDataSet: TDataSet;
  lFileName, lPath, lExt, lExportFileName: string;
  //
  lReportType: string;
  lFrReport: TfrxReport;
  frxDBDataset: TfrxDBDataset;
  frxDatasetList: TList<TfrxDBDataset>;
  lExportFilter: TfrxBaseDialogExportFilter;
  frxPDFExport: TfrxPDFExport;
  frxXLSExport: TfrxXLSExport;
  frxJPEGExport: TfrxJPEGExport;
  frxBMPExport: TfrxBMPExport;
  frxGIFExport: TfrxGIFExport;
  frxHTMLExport: TfrxHTMLExport;
  frxXMLExport: TfrxXMLExport;
  frxXLSXExport: TfrxXLSXExport;
  frxPPTXExport: TfrxPPTXExport;
begin
  result := TActionResult<string>.Create(false, false);
  lTokenItem := nil;
  lFastApiInfo := nil;
  lApiAll := nil;
  lTokenItem := self.GetCureentToken(lErrMsg);
  lApiAll := OneFastApiDo.DoFastApiResultApiAll(lTokenItem, QPostJson, lFastApiInfo);
  try
    if lApiAll = nil then
    begin
      result.ResultMsg := '执行异常返回ApiAll=nil';
      exit;
    end;
    if lApiAll.IsErr then
    begin
      result.ResultMsg := lApiAll.errMsg;
      exit;
    end;
    //
    lFileName := lFastApiInfo.fastApi.FApiID + '.data';
    lPath := OneFileHelper.CombineExeRunPathB(const_OnePlatform, 'OneFastReport');
    lFileName := OneFileHelper.CombinePath(lPath, lFileName);
    if not FileExists(lFileName) then
    begin
      result.ResultMsg := '报表文件[' + lFileName + ']不存在，请先设计报表';
      exit;
    end;

    // 进行报表打印
    lExportFilter := nil;
    frxDatasetList := TList<TfrxDBDataset>.Create;
    lFrReport := TfrxReport.Create(nil);
    try
      // Token相关变量
      if lTokenItem <> nil then
      begin
        lFrReport.Script.AddVariable('Var_UserID', 'string', lTokenItem.sysUserID);
        lFrReport.Script.AddVariable('Var_UserCode', 'string', lTokenItem.sysUserCode);
        lFrReport.Script.AddVariable('Var_UserName', 'string', lTokenItem.sysUserName);
      end
      else
      begin
        lFrReport.Script.AddVariable('Var_UserID', 'string', '');
        lFrReport.Script.AddVariable('Var_UserCode', 'string', '');
        lFrReport.Script.AddVariable('Var_UserName', 'string', '');
      end;
      // 增加上传上来的条件变量
      if lApiAll.paramJson <> nil then
      begin
        for iParam := 0 to lApiAll.paramJson.count - 1 do
        begin
          lJsonName := lApiAll.paramJson.Pairs[iParam].JsonString.Value;
          lJsonValue := lApiAll.paramJson.Pairs[iParam].JsonValue.value;
          lFrReport.Script.AddVariable(lJsonName, 'string', lJsonValue);
        end;
      end;
      // 增加数据集
      if lApiAll.StepResultList <> nil then
      begin
        for iStep := 0 to lApiAll.StepResultList.count - 1 do
        begin
          lDataSet := lApiAll.StepResultList[iStep].DataSet;
          if lDataSet <> nil then
          begin
            frxDBDataset := TfrxDBDataset.Create(nil);
            frxDBDataset.Name := lApiAll.StepResultList[iStep].ApiData.FDataName;
            frxDBDataset.DataSet := lDataSet;
            lFrReport.DataSets.Add(frxDBDataset);
            frxDatasetList.Add(frxDBDataset);
          end;
        end;
      end;
      // for I := 0 to lApiAll.ch do
      // 加载报表
      lFrReport.LoadFromFile(lFileName);
      // 生成报表
      lFrReport.PrepareReport(true);
      //
      lPath := OneFileHelper.CombineExeRunPathB(const_OnePlatform, 'OneFastReportExport');
      if not TDirectory.Exists(lPath) then
      begin
        TDirectory.CreateDirectory(lPath);
      end;
      lReportType := '';

      QPostJson.TryGetValue<string>('apiReportType', lReportType);
      if lReportType = '' then
        lReportType := 'pdf';
      lReportType := lReportType.ToLower;

      lExt := lReportType;
      if lReportType = 'pdf' then
      begin
        frxPDFExport := TfrxPDFExport.Create(nil);
        lExportFilter := frxPDFExport;
      end
      else if lReportType = 'xlsx' then
      begin
        frxXLSXExport := TfrxXLSXExport.Create(nil);
        lExportFilter := frxXLSXExport;
      end
      else if lReportType = 'xls' then
      begin
        frxXLSExport := TfrxXLSExport.Create(nil);
        lExportFilter := frxXLSExport;
      end
      else if lReportType = 'jpg' then
      begin
        frxJPEGExport := TfrxJPEGExport.Create(nil);
        lExportFilter := frxJPEGExport;
      end
      else if lReportType = 'bmp' then
      begin
        frxBMPExport := TfrxBMPExport.Create(nil);
        lExportFilter := frxBMPExport;
        frxBMPExport.SeparateFiles := false;
      end
      else if lReportType = 'html' then
      begin
        frxHTMLExport := TfrxHTMLExport.Create(nil);
        lExportFilter := frxHTMLExport;
      end
      else
      begin
        frxPDFExport := TfrxPDFExport.Create(nil);
        lExportFilter := frxPDFExport;
      end;

      lExportFilter.ShowDialog := false;
      lExportFileName := OneFastApiManage.UnitFastApiManage().GetFileLsh();
      lExportFileName := lFastApiInfo.fastApi.FApiCaption + '_' + lExportFileName + '.' + lExt;
      lExportFileName := OneFileHelper.CombinePath(lPath, lExportFileName);
      lExportFilter.FileName := lExportFileName;
      lFrReport.Export(lExportFilter);

      result.ResultData := lExportFileName;
      result.SetResultTrueFile();
    finally
      for iParam := 0 to frxDatasetList.count - 1 do
      begin
        frxDatasetList[iParam].Free;
      end;
      frxDatasetList.clear;
      frxDatasetList.Free;
      lFrReport.Free;
      if lExportFilter <> nil then
        lExportFilter.Free;
    end;
  finally
    if lApiAll <> nil then
    begin
      lApiAll.Free;
    end;
  end;
end;

function TFastReportController.OpenFastReportDatas(QPostJson: TJsonObject): TOneDataResult;
var
  lTokenItem: TOneTokenItem;
  lFastApiInfo: TFastApiInfo;
  lErrMsg: string;
  lApiAll: TApiAll;
  iParam, iStep: Integer;
  lJsonName, lJsonValue: string;
  lDataSet: TDataSet;
  lDataResultItem: TOneDataResultItem;
  lMemoryStream: TMemoryStream;
begin
  lTokenItem := nil;
  lFastApiInfo := nil;
  lApiAll := nil;
  result := TOneDataResult.Create;
  try
    lTokenItem := self.GetCureentToken(lErrMsg);
    lApiAll := OneFastApiDo.DoFastApiResultApiAll(lTokenItem, QPostJson, lFastApiInfo);
    try
      if lApiAll = nil then
      begin
        result.ResultMsg := 'FastApi输出的结果为nil';
        exit;
      end;
      if lApiAll.IsErr then
      begin
        result.ResultMsg := lApiAll.errMsg;
        exit;
      end;
      // 转化成
      result.ResultCount := 0;
      // 数据处理输出到前台
      if lApiAll.StepResultList <> nil then
      begin
        for iStep := 0 to lApiAll.StepResultList.count - 1 do
        begin
          lDataSet := lApiAll.StepResultList[iStep].DataSet;
          if lDataSet <> nil then
          begin
            if lDataSet is TFDDataSet then
            begin
              result.ResultCount := result.ResultCount + 1;
              lDataResultItem := TOneDataResultItem.Create;
              result.ResultItems.Add(lDataResultItem);
              lDataResultItem.ResultDataName := lApiAll.StepResultList[iStep].ApiData.FDataName;
              lMemoryStream := TMemoryStream.Create;
              TFDDataSet(lDataSet).SaveToStream(lMemoryStream, TFDStorageFormat.sfBinary);
              lDataResultItem.ResultDataMode := const_DataReturnMode_Stream;
              lMemoryStream.Position := 0;
              lDataResultItem.SetStream(lMemoryStream);
            end;
          end;
        end;
      end;
      result.ResultOK := true;
      result.DoResultitems();
    finally
      if lApiAll <> nil then
      begin
        lApiAll.Free;
      end;
    end;
  except
    on e: Exception do
    begin
      result.ResultMsg := e.Message;
    end;
  end;
end;

function TFastReportController.UploadReportFile(QApiID: string; QFileData: string): TActionResult<string>;
var
  lFileName, lPath: string;
  lInStream: TMemoryStream;
begin
  result := TActionResult<string>.Create(true, false);
  if QApiID = '' then
  begin
    result.ResultMsg := 'ApiID为空,请上传[QApiID]';
    exit;
  end;
  if QFileData = '' then
  begin
    result.ResultMsg := '上传的文件数据为空,请上传数据[QFileData]';
    exit;
  end;
  lPath := OneFileHelper.CombineExeRunPathB(const_OnePlatform, 'OneFastReport');
  if not TDirectory.Exists(lPath) then
  begin
    TDirectory.CreateDirectory(lPath);
  end;
  lFileName := OneFileHelper.CombinePath(lPath, QApiID + '.data');
  // 拼接文件
  lInStream := TMemoryStream.Create;
  try
    // 反写base64到流中
    OneStreamString.StreamWriteBase64Str(lInStream, QFileData);
    // 解压流
    lInStream.Position := 0;
    lInStream.SaveToFile(lFileName);
  finally
    lInStream.clear;
    lInStream.Free;
  end;
  // 返回新的文件名给前端
  result.ResultData := lFileName;
  // 返回的是文件
  result.ResultMsg := '保存文件成功';
  result.SetResultTrue();
end;

function TFastReportController.DownloadReportFile(QApiID: string): TActionResult<string>;
var
  lFileName, lPath: string;
  lFileStream: TFileStream;
begin
  result := TActionResult<string>.Create(true, false);
  if QApiID = '' then
  begin
    result.ResultMsg := 'ApiID为空,请上传[QApiID]';
    exit;
  end;
  lPath := OneFileHelper.CombineExeRunPathB(const_OnePlatform, 'OneFastReport');
  if not TDirectory.Exists(lPath) then
  begin
    TDirectory.CreateDirectory(lPath);
  end;
  // 固定后缀名称
  lFileName := OneFileHelper.CombinePath(lPath, QApiID + '.data');
  if not FileExists(lFileName) then
  begin
    result.ResultMsg := '服务端文件不存在请检查';
    exit;
  end;
  lFileStream := TFileStream.Create(lFileName, fmopenRead, fmShareDenyRead);
  try
    lFileStream.Position := 0;
    result.ResultData := OneStreamString.StreamToBase64Str(lFileStream);
    result.SetResultTrue();
  finally
    lFileStream.Free;
  end;
end;

function TFastReportController.IsExistReportFile(QApiID: string): TActionResult<string>;
var
  lFileName, lPath: string;
  lFileStream: TFileStream;
begin
  result := TActionResult<string>.Create(true, false);
  if QApiID = '' then
  begin
    result.ResultMsg := 'ApiID为空,请上传[QApiID]';
    exit;
  end;
  lPath := OneFileHelper.CombineExeRunPathB(const_OnePlatform, 'OneFastReport');
  if not TDirectory.Exists(lPath) then
  begin
    TDirectory.CreateDirectory(lPath);
  end;
  // 固定后缀名称
  lFileName := OneFileHelper.CombinePath(lPath, QApiID + '.data');
  if not FileExists(lFileName) then
  begin
    result.ResultMsg := '服务端文件不存在请检查';
    exit;
  end;
  result.SetResultTrue();
end;

initialization

// 单例模式注册
OneHttpRouterManage.GetInitRouterManage().AddHTTPSingleWork('OneServer/FastReport', TFastReportController, 0, CreateNewFastReportController);

finalization

end.

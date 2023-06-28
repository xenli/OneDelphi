unit OneClientFastReport;

interface

uses system.Classes, system.SysUtils, OneClientConnect, system.Generics.Collections,
  system.json, system.IOUtils, system.NetEncoding, OneClientConst, FireDAC.Comp.Client,
  OneClientDataInfo, OneClientResult, OneClientDataSet;

const
  // 流水号获取相关功能
  URL_HTTP_FastReport_OpenFastReportDatas = 'OneServer/FastReport/OpenFastReportDatas';
  URL_HTTP_FastReport_UploadReportFile = 'OneServer/FastReport/UploadReportFile';
  URL_HTTP_FastReport_DownloadReportFile = 'OneServer/FastReport/DownloadReportFile';
  URL_HTTP_FastReport_IsExistReportFile = 'OneServer/FastReport/IsExistReportFile';

type

  [ComponentPlatformsAttribute(OneAllPlatforms)]
  TOneServerFastReport = class(TComponent)
  private
    FConnection: TOneConnection;
    FErrMsg: string;
  private
    function GetConnection: TOneConnection;
    procedure SetConnection(const AValue: TOneConnection);
  public
    // 获取报表数据
    function OpenFastReportDatas(QPostJson: TJsonObject): TList<TOneDataSet>;
    function UploadReportFile(QApiID: string; QUpFileName: string): boolean;
    function DownloadReportFile(QApiID: string; QSaveFileName: string): boolean;
    function IsExistReportFile(QApiID: string): boolean;
  published
    property Connection: TOneConnection read GetConnection write SetConnection;
    property ErrMsg: string read FErrMsg write FErrMsg;
  end;

implementation

uses OneNeonHelper, OneStreamString;

function TOneServerFastReport.GetConnection: TOneConnection;
begin
  Result := self.FConnection;
end;

procedure TOneServerFastReport.SetConnection(const AValue: TOneConnection);
begin
  self.FConnection := AValue;
end;

function TOneServerFastReport.OpenFastReportDatas(QPostJson: TJsonObject): TList<TOneDataSet>;
var
  lResultJsonValue: TJsonValue;
  lErrMsg: string;
  lDataResult: TOneDataResult;
  lObjectList: TList<Tobject>;
  lDataSet: TOneDataSet;
  i: integer;
  isOK: boolean;
begin
  Result := nil;
  self.FErrMsg := '';
  if self.FConnection = nil then
    self.FConnection := OneClientConnect.Unit_Connection;
  if self.FConnection = nil then
  begin
    self.FErrMsg := '数据集Connection=nil';
    exit;
  end;
  if not self.FConnection.Connected then
  begin
    self.FErrMsg := '服务器未连接';
    exit;
  end;
  // 与服务端交互获取数据
  isOK := false;
  lResultJsonValue := nil;
  lDataResult := TOneDataResult.create;
  try
    lResultJsonValue := self.FConnection.PostResultJsonValue(URL_HTTP_FastReport_OpenFastReportDatas, QPostJson.ToJSON(), lErrMsg);
    if not self.FConnection.IsErrTrueResult(lErrMsg) then
    begin
      self.FErrMsg := lErrMsg;
      exit;
    end;
    if not OneNeonHelper.JsonToObject(lDataResult, lResultJsonValue, lErrMsg) then
    begin
      self.FErrMsg := '返回的数据解析成TOneDataResult出错,无法知道结果,数据:' + lResultJsonValue.ToJSON;
      exit;
    end;
    if not lDataResult.ResultOK then
    begin
      self.FErrMsg := lDataResult.ResultMsg;
      exit;
    end;
    Result := TList<TOneDataSet>.create;
    // 创建数据集
    for i := 0 to lDataResult.ResultItems.count - 1 do
    begin
      lDataSet := TOneDataSet.create(nil);
      Result.Add(lDataSet);
      lDataSet.Name := lDataResult.ResultItems[i].ResultDataName;
    end;
    // 解析数据到dataSet
    lObjectList := TList<Tobject>(Result);
    if not self.FConnection.DataResultToDataSets(lDataResult, lObjectList, false, lErrMsg) then
    begin
      self.FErrMsg := lErrMsg;
      exit;
    end;
    isOK := true;
  finally
    if lResultJsonValue <> nil then
      lResultJsonValue.free;
    lDataResult.free;
    if not isOK then
    begin
      if Result <> nil then
      begin
        for i := 0 to Result.count - 1 do
        begin
          Result[i].free;
        end;
        Result.Clear;
        Result.free;
      end;
      Result := nil;
    end;
  end;
end;

function TOneServerFastReport.UploadReportFile(QApiID: string; QUpFileName: string): boolean;
var
  TempStream: TMemoryStream;
  tempMsg, lStreamBase64: string;
  lPostJsonValue: TJsonObject;
  lResultJsonValue: TJsonValue;
  lActionResult: TActionResult<string>;
begin
  Result := false;
  self.FErrMsg := '';
  if self.FConnection = nil then
    self.FConnection := OneClientConnect.Unit_Connection;
  if self.FConnection = nil then
  begin
    self.FErrMsg := '数据集Connection=nil';
    exit;
  end;
  if not self.FConnection.Connected then
  begin
    self.FErrMsg := '服务器未连接';
    exit;
  end;
  if QApiID = '' then
  begin
    self.FErrMsg := '关联的唯一ApiID为空';
    exit;
  end;
  if not TFile.Exists(QUpFileName) then
  begin
    self.FErrMsg := '本地路径文件[' + QUpFileName + ']文件不存在';
    exit;
  end;
  // 开始提交
  lResultJsonValue := nil;
  lActionResult := TActionResult<string>.create;
  lPostJsonValue := TJsonObject.create;
  TempStream := TMemoryStream.create;
  try
    TempStream.LoadFromFile(QUpFileName);
    TempStream.Position := 0;
    lStreamBase64 := OneStreamString.StreamToBase64Str(TempStream);
    // 提交
    lPostJsonValue.AddPair('QApiID', QApiID);
    lPostJsonValue.AddPair('QFileData', lStreamBase64);

    lResultJsonValue := self.FConnection.PostResultJsonValue(URL_HTTP_FastReport_UploadReportFile, lPostJsonValue.ToJSON(), tempMsg);
    if not self.FConnection.IsErrTrueResult(tempMsg) then
    begin
      self.FErrMsg := tempMsg;
      exit;
    end;
    if not OneNeonHelper.JsonToObject(lActionResult, lResultJsonValue, tempMsg) then
    begin
      self.FErrMsg := '返回的数据解析成TOneDataResult出错,无法知道结果,数据:' + lResultJsonValue.ToJSON;
      exit;
    end;
    if lActionResult.ResultMsg <> '' then
    begin
      self.FErrMsg := '服务端消息:' + lActionResult.ResultMsg;
    end;
    if lActionResult.ResultSuccess then
    begin
      Result := true;
    end;
  finally
    TempStream.Clear;
    TempStream.free;
    lActionResult.free;
    if lPostJsonValue <> nil then
      lPostJsonValue.free;
    if lResultJsonValue <> nil then
      lResultJsonValue.free;
  end;
end;

function TOneServerFastReport.DownloadReportFile(QApiID: string; QSaveFileName: string): boolean;
var
  TempStream: TMemoryStream;
  tempMsg, lStreamBase64: string;
  lPostJsonValue: TJsonObject;
  lResultJsonValue: TJsonValue;
  lActionResult: TActionResult<string>;
begin
  Result := false;
  self.FErrMsg := '';
  if self.FConnection = nil then
    self.FConnection := OneClientConnect.Unit_Connection;
  if self.FConnection = nil then
  begin
    self.FErrMsg := '数据集Connection=nil';
    exit;
  end;
  if not self.FConnection.Connected then
  begin
    self.FErrMsg := '服务器未连接';
    exit;
  end;
  if QSaveFileName = '' then
  begin
    self.FErrMsg := '保存的文件名称不可为空';
    exit;
  end;
  if QApiID = '' then
  begin
    self.FErrMsg := '关联的唯一ApiID为空';
    exit;
  end;
  // if  TFile.Exists(QSaveFileName) then
  // begin
  // self.FErrMsg := '本地路径文件[' + QUpFileName + ']文件不存在';
  // exit;
  // end;
  // 开始提交
  lResultJsonValue := nil;
  lActionResult := TActionResult<string>.create;
  lPostJsonValue := TJsonObject.create;
  try
    // 提交
    lPostJsonValue.AddPair('QApiID', QApiID);
    lResultJsonValue := self.FConnection.PostResultJsonValue(URL_HTTP_FastReport_DownloadReportFile,
      lPostJsonValue.ToJSON(), tempMsg);
    if not self.FConnection.IsErrTrueResult(tempMsg) then
    begin
      self.FErrMsg := tempMsg;
      exit;
    end;
    if not OneNeonHelper.JsonToObject(lActionResult, lResultJsonValue, tempMsg) then
    begin
      self.FErrMsg := '返回的数据解析成TOneDataResult出错,无法知道结果,数据:' + lResultJsonValue.ToJSON;
      exit;
    end;
    if lActionResult.ResultMsg <> '' then
    begin
      self.FErrMsg := '服务端消息:' + lActionResult.ResultMsg;
    end;
    if lActionResult.ResultSuccess then
    begin
      TempStream := TMemoryStream.create;
      try
        OneStreamString.StreamWriteBase64Str(TempStream, lActionResult.ResultData);
        TempStream.Position := 0;
        TempStream.saveToFile(QSaveFileName);
      finally
        TempStream.Clear;
        TempStream.free;
      end;
      Result := true;
    end;
  finally
    lActionResult.free;
    if lPostJsonValue <> nil then
      lPostJsonValue.free;
    if lResultJsonValue <> nil then
      lResultJsonValue.free;
  end;
end;

function TOneServerFastReport.IsExistReportFile(QApiID: string): boolean;
var
  tempMsg: string;
  lPostJsonValue: TJsonObject;
  lResultJsonValue: TJsonValue;
  lActionResult: TActionResult<string>;
begin
  Result := false;
  self.FErrMsg := '';
  if self.FConnection = nil then
    self.FConnection := OneClientConnect.Unit_Connection;
  if self.FConnection = nil then
  begin
    self.FErrMsg := '数据集Connection=nil';
    exit;
  end;
  if not self.FConnection.Connected then
  begin
    self.FErrMsg := '服务器未连接';
    exit;
  end;

  if QApiID = '' then
  begin
    self.FErrMsg := '关联的唯一ApiID为空';
    exit;
  end;
  // if  TFile.Exists(QSaveFileName) then
  // begin
  // self.FErrMsg := '本地路径文件[' + QUpFileName + ']文件不存在';
  // exit;
  // end;
  // 开始提交
  lResultJsonValue := nil;
  lActionResult := TActionResult<string>.create;
  lPostJsonValue := TJsonObject.create;
  try
    // 提交
    lPostJsonValue.AddPair('QApiID', QApiID);
    lResultJsonValue := self.FConnection.PostResultJsonValue(URL_HTTP_FastReport_IsExistReportFile,
      lPostJsonValue.ToJSON(), tempMsg);
    if not self.FConnection.IsErrTrueResult(tempMsg) then
    begin
      self.FErrMsg := tempMsg;
      exit;
    end;
    if not OneNeonHelper.JsonToObject(lActionResult, lResultJsonValue, tempMsg) then
    begin
      self.FErrMsg := '返回的数据解析成TOneDataResult出错,无法知道结果,数据:' + lResultJsonValue.ToJSON;
      exit;
    end;
    if lActionResult.ResultMsg <> '' then
    begin
      self.FErrMsg := '服务端消息:' + lActionResult.ResultMsg;
    end;
    if lActionResult.ResultSuccess then
    begin
      Result := true;
    end;
  finally
    lActionResult.free;
    if lPostJsonValue <> nil then
      lPostJsonValue.free;
    if lResultJsonValue <> nil then
      lResultJsonValue.free;
  end;
end;

end.

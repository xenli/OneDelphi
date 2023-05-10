unit OneClientFastFile;

interface

uses system.Classes, system.SysUtils, OneClientConnect, system.Generics.Collections,
  system.json, system.IOUtils, system.NetEncoding, OneClientConst;

const
  // 流水号获取相关功能
  URL_HTTP_FastFile_RefreshFileSetAll = 'OneServer/FastFile/RefreshFileSetAll';
  URL_HTTP_FastFile_CreateNewTask = 'OneServer/FastFile/CreateNewTask';
  URL_HTTP_FastFile_FileDel = 'OneServer/FastFile/FileDel';
  URL_HTTP_FastFile_FileUpLoad = 'OneServer/FastFile/FileUpLoad';
  URL_HTTP_FastFile_FileDown = 'OneServer/FastFile/FileDown';

type

  enumFileStep = (emStepStart, emStepEnd, emFileStart, emFileProcess, emFileEnd, emStepErr);
  // 回调事件类型
  evenFileCallBack = procedure(QFileStep: enumFileStep; QFileCount: integer; QIndexFile: integer;
    QFileName: string; QFileSize: int64; QFilePosition: int64) of object;

  // 附件上传下载任务
  TFileTask = class
  private
    FTaskID_: string; // 任务ID
    FTaskMode_: string; // 上传,下载,删除
    FFileSetCode_: string; // 文件配置代码
    FFileID_: string; // 下载时附件ID
    FFileName_: string; // 文件名称
    FFilePosition_: int64; // 上传或下载当前位置
    FFileSize_: int64; // 文件大小
    FFileChunkSize_: integer;
    FSaveFileName_: string; // 保存的文件名
    FSavePhyPath_: string; // 保存的物理地址
    FDataBase64_: string; // 数据
    //
    FRelationID_: string; // 关联的业务ID
    FPRelationID_: string; // 关联的业务父ID
    FLastTime_: TDateTime; // 最后交互时间
    //
    FErrMsg_: string;
  published
    property FTaskID: string read FTaskID_ write FTaskID_;
    property FTaskMode: string read FTaskMode_ write FTaskMode_;
    property FFileSetCode: string read FFileSetCode_ write FFileSetCode_;
    property FFileID: string read FFileID_ write FFileID_;
    property FFileName: string read FFileName_ write FFileName_;
    property FFilePosition: int64 read FFilePosition_ write FFilePosition_;
    property FFileSize: int64 read FFileSize_ write FFileSize_;
    property FFileChunkSize: integer read FFileChunkSize_ write FFileChunkSize_;
    property FSaveFileName: string read FSaveFileName_ write FSaveFileName_;
    property FSavePhyPath: string read FSavePhyPath_ write FSavePhyPath_;
    property FDataBase64: string read FDataBase64_ write FDataBase64_;
    property FRelationID: string read FRelationID_ write FRelationID_;
    property FPRelationID: string read FPRelationID_ write FPRelationID_;
    property FLastTime: TDateTime read FLastTime_ write FLastTime_;
    property FErrMsg: string read FErrMsg_ write FErrMsg_;
  end;

  { 升级控件 }
  [ComponentPlatformsAttribute(OneAllPlatforms)]
  TOneFastFile = class(TComponent)
  private
    FConnection: TOneConnection;
    //
    FFileSetCode: string;
    FRelationID: string;
    FPRelationID: string;
    FFileChunkSize: integer;
    //
    FTaskDicts: TDictionary<string, TFileTask>;
    //
    FErrMsg: string;
    FOnCallBack: evenFileCallBack;
  private
    // 获取连接
    function GetConnection: TOneConnection;
    procedure SetConnection(const AValue: TOneConnection);
    function GetTaskID(QTask: TFileTask): boolean;
    function DoUpLoad(QTask: TFileTask): boolean;
    function DoDownLoad(QTask: TFileTask): boolean;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    //
    function RefreshFileSetAll(): boolean;
    // 指定文件删除
    function FileDel(QFileID: string): boolean;
    // 跟据关联业务ID删除文件
    function FilesDelByRelationID(): boolean;
    // 上传文件
    function FileUpLoad(QFileName: string): boolean;
    function FilesUpLoad(QFileNames: TList<string>): boolean;
    // 指定文件下载
    function FileDown(QFileID: string; QSavePath: string = ''): boolean;
    function FilesDown(QFileIDs: TList<string>; QSavePath: string = ''): boolean;
  published
    property Connection: TOneConnection read GetConnection write SetConnection;
    property FileSetCode: string read FFileSetCode write FFileSetCode;
    property RelationID: string read FRelationID write FRelationID;
    property PRelationID: string read FPRelationID write FPRelationID;
    property FileChunkSize: integer read FFileChunkSize write FFileChunkSize;
    property ErrMsg: string read FErrMsg write FErrMsg;
    property OnCallBack: evenFileCallBack read FOnCallBack write FOnCallBack;
  end;

implementation

uses OneClientResult, OneNeonHelper, OneFileHelper;

//
constructor TOneFastFile.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FTaskDicts := TDictionary<string, TFileTask>.Create;
  FileChunkSize := 1024 * 1024;
end;

destructor TOneFastFile.Destroy;
var
  lTask: TFileTask;
begin
  for lTask in FTaskDicts.Values do
  begin
    lTask.Free;
  end;
  FTaskDicts.Clear;
  FTaskDicts.Free;
  inherited Destroy;
end;

function TOneFastFile.GetConnection: TOneConnection;
begin
  Result := self.FConnection;
end;

procedure TOneFastFile.SetConnection(const AValue: TOneConnection);
begin
  self.FConnection := AValue;
end;

//
function TOneFastFile.RefreshFileSetAll(): boolean;
var
  lErrMsg: string;
  //
  lJsonObj: TJsonObject;
  lResultJsonValue: TJsonValue;
  lServerResult: TActionResult<string>;
begin
  Result := false;
  self.ErrMsg := '';
  if self.FConnection = nil then
    self.FConnection := OneClientConnect.Unit_Connection;
  if self.FConnection = nil then
  begin
    self.ErrMsg := '数据集Connection=nil';
    exit;
  end;
  // 获取流水号
  lResultJsonValue := nil;
  lServerResult := TActionResult<string>.Create;
  lServerResult.ResultData := '';
  lJsonObj := TJsonObject.Create;
  try
    // lJsonObj.AddPair('QUpdateCode', self.FUpdateCode);
    lResultJsonValue := self.FConnection.PostResultJsonValue(URL_HTTP_FastFile_RefreshFileSetAll, '', lErrMsg);
    if not self.FConnection.IsErrTrueResult(lErrMsg) then
    begin
      self.ErrMsg := lErrMsg;
      exit;
    end;
    if not OneNeonHelper.JsonToObject(lServerResult, lResultJsonValue, lErrMsg) then
    begin
      self.ErrMsg := '返回的数据解析成TActionResult<TClientConnect>出错,无法知道结果,数据:' + lResultJsonValue.ToJSON;
      exit;
    end;
    if not lServerResult.ResultSuccess then
    begin
      self.ErrMsg := '服务端消息:' + lServerResult.ResultMsg;
      exit;
    end;
    Result := true;
  finally
    lJsonObj.Free;
    if lResultJsonValue <> nil then
    begin
      lResultJsonValue.Free;
    end;
    lServerResult.Free;
  end;
end;

// 指定文件删除
function TOneFastFile.FileDel(QFileID: string): boolean;
var
  lErrMsg: string;
  //
  lJsonObj: TJsonObject;
  lResultJsonValue: TJsonValue;
  lServerResult: TActionResult<string>;
begin
  Result := false;
  self.ErrMsg := '';
  if self.FFileSetCode = '' then
  begin
    self.ErrMsg := '文件配置代码[FFileSetCode]未设置相关值';
    exit;
  end;
  if QFileID = '' then
  begin
    self.ErrMsg := '关联文件ID为空';
    exit;
  end;

  if self.FConnection = nil then
    self.FConnection := OneClientConnect.Unit_Connection;
  if self.FConnection = nil then
  begin
    self.ErrMsg := '数据集Connection=nil';
    exit;
  end;
  // 获取流水号
  lResultJsonValue := nil;
  lServerResult := TActionResult<string>.Create;
  lServerResult.ResultData := '';
  lJsonObj := TJsonObject.Create;

  try
    lJsonObj.AddPair('FFileSetCode', self.FFileSetCode);
    lJsonObj.AddPair('FFileID', QFileID);
    lResultJsonValue := self.FConnection.PostResultJsonValue(URL_HTTP_FastFile_FileDel, lJsonObj.ToString(), lErrMsg);
    if not self.FConnection.IsErrTrueResult(lErrMsg) then
    begin
      self.ErrMsg := lErrMsg;
      exit;
    end;
    if not OneNeonHelper.JsonToObject(lServerResult, lResultJsonValue, lErrMsg) then
    begin
      self.ErrMsg := '返回的数据解析成TActionResult<string>出错,无法知道结果,数据:' + lResultJsonValue.ToJSON;
      exit;
    end;
    if not lServerResult.ResultSuccess then
    begin
      self.ErrMsg := '服务端消息:' + lServerResult.ResultMsg;
      exit;
    end;
    Result := true;
  finally
    lJsonObj.Free;
    if lResultJsonValue <> nil then
    begin
      lResultJsonValue.Free;
    end;
    lServerResult.Free;
  end;
end;

// 跟据关联ID删除文件
function TOneFastFile.FilesDelByRelationID(): boolean;
var
  lErrMsg: string;
  //
  lJsonObj: TJsonObject;
  lResultJsonValue: TJsonValue;
  lServerResult: TActionResult<string>;
begin
  Result := false;
  self.ErrMsg := '';
  if self.FFileSetCode = '' then
  begin
    self.ErrMsg := '文件配置代码[FFileSetCode]未设置相关值';
    exit;
  end;

  if self.FRelationID = '' then
  begin
    self.ErrMsg := '关联业务ID为空[FRelationID]';
    exit;
  end;

  if self.FConnection = nil then
    self.FConnection := OneClientConnect.Unit_Connection;
  if self.FConnection = nil then
  begin
    self.ErrMsg := '数据集Connection=nil';
    exit;
  end;
  // 获取流水号
  lResultJsonValue := nil;
  lServerResult := TActionResult<string>.Create;
  lServerResult.ResultData := '';
  lJsonObj := TJsonObject.Create;

  try
    lJsonObj.AddPair('FFileSetCode', self.FFileSetCode);
    lJsonObj.AddPair('FRelationID', self.FRelationID);
    lResultJsonValue := self.FConnection.PostResultJsonValue(URL_HTTP_FastFile_FileDel, lJsonObj.ToString(), lErrMsg);
    if not self.FConnection.IsErrTrueResult(lErrMsg) then
    begin
      self.ErrMsg := lErrMsg;
      exit;
    end;
    if not OneNeonHelper.JsonToObject(lServerResult, lResultJsonValue, lErrMsg) then
    begin
      self.ErrMsg := '返回的数据解析成TActionResult<string>出错,无法知道结果,数据:' + lResultJsonValue.ToJSON;
      exit;
    end;
    if not lServerResult.ResultSuccess then
    begin
      self.ErrMsg := '服务端消息:' + lServerResult.ResultMsg;
      exit;
    end;
    Result := true;
  finally
    lJsonObj.Free;
    if lResultJsonValue <> nil then
    begin
      lResultJsonValue.Free;
    end;
    lServerResult.Free;
  end;
end;

function TOneFastFile.GetTaskID(QTask: TFileTask): boolean;
var
  lErrMsg: string;
  //
  lTempJsonValue: TJsonValue;
  lPostJson: TJsonObject;
  lResultJsonValue: TJsonValue;
  lServerResult: TActionResult<TFileTask>;
begin
  Result := false;
  self.ErrMsg := '';

  if self.FConnection = nil then
    self.FConnection := OneClientConnect.Unit_Connection;
  if self.FConnection = nil then
  begin
    self.ErrMsg := '数据集Connection=nil';
    exit;
  end;
  lResultJsonValue := nil;
  lServerResult := TActionResult<TFileTask>.Create;
  lServerResult.ResultData := TFileTask.Create;
  lPostJson := nil;
  try
    lTempJsonValue := OneNeonHelper.ObjectToJson(QTask, lErrMsg);
    if lTempJsonValue = nil then
    begin
      self.ErrMsg := lErrMsg;
      exit;
    end;
    lPostJson := lTempJsonValue as TJsonObject;
    lResultJsonValue := self.FConnection.PostResultJsonValue(URL_HTTP_FastFile_CreateNewTask, lPostJson.ToString(), lErrMsg);
    if not self.FConnection.IsErrTrueResult(lErrMsg) then
    begin
      self.ErrMsg := lErrMsg;
      exit;
    end;
    if not OneNeonHelper.JsonToObject(lServerResult, lResultJsonValue, lErrMsg) then
    begin
      self.ErrMsg := '返回的数据解析成TActionResult<string>出错,无法知道结果,数据:' + lResultJsonValue.ToJSON;
      exit;
    end;
    if not lServerResult.ResultSuccess then
    begin
      self.ErrMsg := '服务端消息:' + lServerResult.ResultMsg;
      exit;
    end;
    //
    QTask.FTaskID := lServerResult.ResultData.FTaskID;
    if QTask.FTaskID = '' then
    begin
      self.ErrMsg := '返回的任务ID为空';
      exit;
    end;
    // 下载要赋值其它值
    if QTask.FTaskMode = '下载' then
    begin
      QTask.FFileName := lServerResult.ResultData.FFileName;
      QTask.FFileSize := lServerResult.ResultData.FFileSize;
    end;
    Result := true;
  finally
    if lPostJson <> nil then
      lPostJson.Free;
    //
    if lResultJsonValue <> nil then
    begin
      lResultJsonValue.Free;
    end;
    lServerResult.ResultData.Free;
    lServerResult.Free;
  end;
end;

// 上传文件
function TOneFastFile.FileUpLoad(QFileName: string): boolean;
var
  lList: TList<string>;
begin
  lList := TList<string>.Create;
  try
    lList.Add(QFileName);
    Result := self.FilesUpLoad(lList);
  finally
    lList.Clear;
    lList.Free;
  end;
end;

function TOneFastFile.DoUpLoad(QTask: TFileTask): boolean;
var
  lErrMsg: string;
  //
  lTempJsonValue: TJsonValue;
  lPostJson: TJsonObject;
  lResultJsonValue: TJsonValue;
  lServerResult: TActionResult<string>;
begin
  Result := false;
  self.ErrMsg := '';
  if self.FConnection = nil then
    self.FConnection := OneClientConnect.Unit_Connection;
  if self.FConnection = nil then
  begin
    self.ErrMsg := '数据集Connection=nil';
    exit;
  end;
  lResultJsonValue := nil;
  lServerResult := TActionResult<string>.Create;
  lServerResult.ResultData := '';
  lPostJson := nil;
  try
    lTempJsonValue := OneNeonHelper.ObjectToJson(QTask, lErrMsg);
    if lTempJsonValue = nil then
    begin
      self.ErrMsg := lErrMsg;
      exit;
    end;
    lPostJson := lTempJsonValue as TJsonObject;
    lResultJsonValue := self.FConnection.PostResultJsonValue(URL_HTTP_FastFile_FileUpLoad, lPostJson.ToString(), lErrMsg);
    if not self.FConnection.IsErrTrueResult(lErrMsg) then
    begin
      self.ErrMsg := lErrMsg;
      exit;
    end;
    if not OneNeonHelper.JsonToObject(lServerResult, lResultJsonValue, lErrMsg) then
    begin
      self.ErrMsg := '返回的数据解析成TActionResult<string>出错,无法知道结果,数据:' + lResultJsonValue.ToJSON;
      exit;
    end;
    if not lServerResult.ResultSuccess then
    begin
      self.ErrMsg := '服务端消息:' + lServerResult.ResultMsg;
      exit;
    end;
    Result := true;
  finally
    if lPostJson <> nil then
      lPostJson.Free;
    //
    if lResultJsonValue <> nil then
    begin
      lResultJsonValue.Free;
    end;
    lServerResult.Free;
  end;
end;

function TOneFastFile.FilesUpLoad(QFileNames: TList<string>): boolean;
var
  I: integer;
  lFileNamePath, lFileName: string;
  lTask: TFileTask;
  lFileStream: TFileStream;
  //
  isStepOK: boolean;
  lBytes: TBytes;
  iChunSize: integer;
begin
  Result := false;
  // 先判断文件存在不存在
  for I := 0 to QFileNames.Count - 1 do
  begin
    lFileNamePath := QFileNames[I];
    lFileName := TPath.GetFileName(lFileNamePath);
    if lFileName = '' then
    begin
      self.ErrMsg := '只能传具体文件,不可传文件夹';
      exit;
    end;
    if TPath.GetExtension(lFileNamePath) = '' then
    begin
      self.ErrMsg := '只能传具体文件,文件后缀名不可为空';
      exit;
    end;
    if not TFile.Exists(lFileNamePath) then
    begin
      self.ErrMsg := '文件不存在->' + lFileNamePath;
      exit;
    end;
  end;
  if Assigned(self.FOnCallBack) then
  begin
    self.FOnCallBack(enumFileStep.emStepStart, QFileNames.Count, 0, '', 0, 0);
  end;
  try
    // 创建Task一个一个上传
    for I := 0 to QFileNames.Count - 1 do
    begin
      isStepOK := false;
      lFileNamePath := QFileNames[I];
      lFileName := TPath.GetFileName(lFileNamePath);
      lFileStream := nil;
      lFileStream := TFileStream.Create(lFileNamePath, fmOpenRead or fmShareExclusive);
      try
        lFileStream.Position := 0;
        if Assigned(self.FOnCallBack) then
        begin
          self.FOnCallBack(enumFileStep.emFileStart, QFileNames.Count, I, lFileName, lFileStream.Size, 0);
        end;
        // 申请Task任务
        lTask := TFileTask.Create;
        lTask.FTaskID := '';
        lTask.FTaskMode := '上传';
        lTask.FFileSetCode := self.FFileSetCode;
        lTask.FFileID := '';
        lTask.FFileName := lFileName;
        lTask.FFilePosition := 0;
        lTask.FFileSize := lFileStream.Size;
        lTask.FFileChunkSize := self.FFileChunkSize;
        if lTask.FFileChunkSize <= 0 then
          lTask.FFileChunkSize := 1024 * 1024;
        lTask.FSaveFileName := '';
        lTask.FSavePhyPath := '';
        lTask.FDataBase64 := '';
        lTask.FRelationID := self.FRelationID;
        lTask.FPRelationID := self.FPRelationID;
        lTask.FLastTime := now;
        lTask.FErrMsg := '';
        if not self.GetTaskID(lTask) then
        begin
          lTask.Free;
          exit;
        end;
        // 加到临控列表
        self.FTaskDicts.Add(lTask.FTaskID, lTask);
        // 开始上传文件
        while lTask.FFilePosition < lTask.FFileSize do
        begin
          lFileStream.Position := lTask.FFilePosition;
          iChunSize := lTask.FFileChunkSize;
          if lFileStream.Position + iChunSize > lTask.FFileSize then
          BEGIN
            iChunSize := lTask.FFileSize - lFileStream.Position;
            lTask.FFileChunkSize := iChunSize;
          END;
          setLength(lBytes, iChunSize);
          lFileStream.Read(lBytes, iChunSize);
          lTask.FDataBase64 := TNetEncoding.Base64.EncodeBytesToString(lBytes);
          // 上传文件
          if not self.DoUpLoad(lTask) then
          begin
            exit;
          end;
          lTask.FFilePosition := lTask.FFilePosition + iChunSize;
          if Assigned(self.FOnCallBack) then
          begin
            self.FOnCallBack(enumFileStep.emFileProcess, QFileNames.Count, I, lFileName, lTask.FFileSize, lTask.FFilePosition);
          end;
        end;
        if Assigned(self.FOnCallBack) then
        begin
          self.FOnCallBack(enumFileStep.emFileEnd, QFileNames.Count, I, lFileName, lTask.FFileSize, lTask.FFilePosition);
        end;
        isStepOK := true;
      finally
        if lFileStream <> nil then
          lFileStream.Free;
        if not isStepOK then
        begin
          if Assigned(self.FOnCallBack) then
          begin
            self.FOnCallBack(enumFileStep.emStepErr, QFileNames.Count, I, lFileName, lTask.FFileSize, lTask.FFilePosition);
          end;
        end;
      end;
    end;
    Result := true;
  finally
    if Result then
    begin
      if Assigned(self.FOnCallBack) then
      begin
        self.FOnCallBack(enumFileStep.emStepEnd, QFileNames.Count, 0, '', 0, 0);
      end;
    end;
  end;
end;

// 指定文件下载
function TOneFastFile.FileDown(QFileID: string; QSavePath: string = ''): boolean;
var
  lList: TList<string>;
begin
  lList := TList<string>.Create;
  try
    lList.Add(QFileID);
    Result := self.FilesDown(lList, QSavePath);
  finally
    lList.Clear;
    lList.Free;
  end;
end;

function TOneFastFile.DoDownLoad(QTask: TFileTask): boolean;
var
  lErrMsg: string;
  //
  lTempJsonValue: TJsonValue;
  lPostJson: TJsonObject;
  lResultJsonValue: TJsonValue;
  lServerResult: TActionResult<string>;
begin
  Result := false;
  self.ErrMsg := '';
  if self.FConnection = nil then
    self.FConnection := OneClientConnect.Unit_Connection;
  if self.FConnection = nil then
  begin
    self.ErrMsg := '数据集Connection=nil';
    exit;
  end;
  lResultJsonValue := nil;
  lServerResult := TActionResult<string>.Create;
  lServerResult.ResultData := '';
  lPostJson := nil;
  try
    lTempJsonValue := OneNeonHelper.ObjectToJson(QTask, lErrMsg);
    if lTempJsonValue = nil then
    begin
      self.ErrMsg := lErrMsg;
      exit;
    end;
    lPostJson := lTempJsonValue as TJsonObject;
    lResultJsonValue := self.FConnection.PostResultJsonValue(URL_HTTP_FastFile_FileDown, lPostJson.ToString(), lErrMsg);
    if not self.FConnection.IsErrTrueResult(lErrMsg) then
    begin
      self.ErrMsg := lErrMsg;
      exit;
    end;
    if not OneNeonHelper.JsonToObject(lServerResult, lResultJsonValue, lErrMsg) then
    begin
      self.ErrMsg := '返回的数据解析成TActionResult<string>出错,无法知道结果,数据:' + lResultJsonValue.ToJSON;
      exit;
    end;
    if not lServerResult.ResultSuccess then
    begin
      self.ErrMsg := '服务端消息:' + lServerResult.ResultMsg;
      exit;
    end;
    if lServerResult.ResultData = '' then
    begin
      self.ErrMsg := '返回的文件数据为空';
      exit;
    end;
    QTask.FDataBase64 := lServerResult.ResultData;
    Result := true;
  finally
    if lPostJson <> nil then
      lPostJson.Free;
    //
    if lResultJsonValue <> nil then
    begin
      lResultJsonValue.Free;
    end;
    lServerResult.Free;
  end;
end;

function TOneFastFile.FilesDown(QFileIDs: TList<string>; QSavePath: string = ''): boolean;
var
  I: integer;
  lFileID: string;
  lFileNamePath, lFileName, lSaveFile: string;
  lTaskList: TList<TFileTask>;
  lTask: TFileTask;
  lFileStream: TFileStream;
  lTaskID: string;
  //
  isStepOK: boolean;
  lBytes: TBytes;
  iChunSize: integer;
begin
  Result := false;
  if QSavePath <> '' then
    lFileNamePath := QSavePath
  else
    lFileNamePath := OneFileHelper.CombinePath(TDirectory.GetCurrentDirectory(), '\OnePlatform\OneFastFile');
  if not TDirectory.Exists(lFileNamePath) then
  begin
    TDirectory.CreateDirectory(lFileNamePath);
  end;
  lTaskList := TList<TFileTask>.Create;
  try
    // 先判断文件存在不存在
    for I := 0 to QFileIDs.Count - 1 do
    begin
      lFileID := QFileIDs[I];
      lTask := TFileTask.Create;
      lTask.FTaskID := '';
      lTask.FTaskMode := '下载';
      lTask.FFileSetCode := self.FFileSetCode;
      lTask.FFileID := lFileID;
      lTask.FFileName := '';
      lTask.FFilePosition := 0;
      lTask.FFileSize := 0;
      lTask.FFileChunkSize := self.FFileChunkSize;
      if lTask.FFileChunkSize <= 0 then
        lTask.FFileChunkSize := 1024 * 1024;
      lTask.FSaveFileName := '';
      lTask.FSavePhyPath := '';
      lTask.FDataBase64 := '';
      lTask.FRelationID := '';
      lTask.FPRelationID := '';
      lTask.FLastTime := now;
      lTask.FErrMsg := '';
      if not self.GetTaskID(lTask) then
      begin
        lTask.Free;
        exit;
      end;
      // 获取TaskID
      self.FTaskDicts.Add(lTask.FTaskID, lTask);
      lTaskList.Add(lTask);
    end;
    if Assigned(self.FOnCallBack) then
    begin
      self.FOnCallBack(enumFileStep.emStepStart, lTaskList.Count, 0, '', 0, 0);
    end;
    // 一个一个下载
    for I := 0 to lTaskList.Count - 1 do
    begin
      isStepOK := false;
      lTask := lTaskList[I];
      lFileName := lTask.FFileName;
      lSaveFile := OneFileHelper.CombinePath(lFileNamePath, lFileName);
      if TFile.Exists(lSaveFile) then
      begin
        lFileName := TPath.GetFileNameWithoutExtension(lFileName)
          + FormatDateTime('yyyyMMddHHmmss', now) + TPath.GetExtension(lFileName);
        lSaveFile := OneFileHelper.CombinePath(lFileNamePath, lFileName);
      end;
      lTask.FSavePhyPath := lSaveFile;
      lFileStream := nil;
      lFileStream := TFileStream.Create(lSaveFile, fmCreate or fmOpenReadWrite or fmShareExclusive);
      try
        lFileStream.Position := 0;
        if Assigned(self.FOnCallBack) then
        begin
          self.FOnCallBack(enumFileStep.emFileStart, lTaskList.Count, I, lFileName, lFileStream.Size, 0);
        end;
        // 开始下载附件
        while lTask.FFilePosition < lTask.FFileSize do
        begin
          // 下载文件
          if not self.DoDownLoad(lTask) then
          begin
            exit;
          end;
          // base64转流
          lBytes := TNetEncoding.Base64.DecodeStringToBytes(lTask.FDataBase64);
          lFileStream.Position := lTask.FFilePosition;
          lFileStream.Write(lBytes, length(lBytes));
          // 移动位置
          lTask.FFilePosition := lTask.FFilePosition + length(lBytes);
          if Assigned(self.FOnCallBack) then
          begin
            self.FOnCallBack(enumFileStep.emFileProcess, lTaskList.Count, I, lFileName, lTask.FFileSize, lTask.FFilePosition);
          end;
        end;
        if Assigned(self.FOnCallBack) then
        begin
          self.FOnCallBack(enumFileStep.emFileEnd, lTaskList.Count, I, lFileName, lTask.FFileSize, lTask.FFilePosition);
        end;
        isStepOK := true;
      finally
        if lFileStream <> nil then
          lFileStream.Free;
        if not isStepOK then
        begin
          if Assigned(self.FOnCallBack) then
          begin
            self.FOnCallBack(enumFileStep.emStepErr, lTaskList.Count, I, lFileName, lTask.FFileSize, lTask.FFilePosition);
          end;
        end;
      end;
    end;
    Result := true;
  finally
    if Result then
    begin
      if Assigned(self.FOnCallBack) then
      begin
        self.FOnCallBack(enumFileStep.emStepEnd, lTaskList.Count, 0, '', 0, 0);
      end;
    end;
    lTaskList.Clear;
    lTaskList.Free;
  end;
end;

end.

unit OneFastFileMange;

interface

uses
  system.Generics.Collections, system.SysUtils, system.Classes, system.StrUtils, system.DateUtils,
  system.IOUtils, system.NetEncoding;

type

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
  end;

  // 附件配置表
  TFastFileSet = class
  private
    FFileSetID_: string;
    FFileSetCode_: string; // 文件代码
    FSavePhyPath_: string; // 保存的服务端路径
    FSaveTable_: string; // 默认oneFast_file表，如果怕数据量大不同业务保存在不同表,数据结构一样就行
    FSaveMode_: string; // 目录按日，目录按月份，目录按年，
    FIsEnabled_: boolean; // 启用
  published
    property FFileSetID: string read FFileSetID_ write FFileSetID_;
    property FFileSetCode: string read FFileSetCode_ write FFileSetCode_;
    property FSavePhyPath: string read FSavePhyPath_ write FSavePhyPath_;
    property FSaveTable: string read FSaveTable_ write FSaveTable_;
    property FSaveMode: string read FSaveMode_ write FSaveMode_;
    property FIsEnabled: boolean read FIsEnabled_ write FIsEnabled_;
  end;

  // 附件文件信息
  TFastFile = class
  private
    FFileID_: string;
    FFileSetCode_: string;
    FFileName_: string; // 文件名称
    FFilePhyPath_: string; // 保存的物理路径
    FFileHttpUrl_: string; // 保存的http路径,后期预留
    FFileSize_: int64; // 文件大小
    FRelationID_: string; // 业务关联ID
    FPRelationID_: string; // 上级关联业务ID
    FFileRemark_: string; // 备注
    FCreateTime_: TDateTime; // 创建时间
  published
    property FFileID: string read FFileID_ write FFileID_;
    property FFileSetCode: string read FFileSetCode_ write FFileSetCode_;
    property FFileName: string read FFileName_ write FFileName_;
    property FFilePhyPath: string read FFilePhyPath_ write FFilePhyPath_;
    property FFileHttpUrl: string read FFileHttpUrl_ write FFileHttpUrl_;
    property FFileSize: int64 read FFileSize_ write FFileSize_;
    property FRelationID: string read FRelationID_ write FRelationID_;
    property FPRelationID: string read FPRelationID_ write FPRelationID_;
    property FFileRemark: string read FFileRemark_ write FFileRemark_;
    property FCreateTime: TDateTime read FCreateTime_ write FCreateTime_;
  end;

  TFastFileMange = class
  private
    FZTCode: string;
    FFileSetDict: TDictionary<string, TFastFileSet>;
    FTaskDict: TDictionary<string, TFileTask>;
  public
    constructor Create(QZTCode: string = '');
    destructor Destroy; override;
  public
    function RefreshFileSet(QFileSetCode: string; var QErrMsg: string): boolean;
    function CreateNewTask(QFileTask: TFileTask; Var QErrMsg: string): TFileTask;
    //
    function FileDel(QFileTask: TFileTask; Var QErrMsg: string): boolean;
    function FileUpLoad(QUpLoadTask: TFileTask; Var QErrMsg: string): boolean;
    function FileDown(QDownTask: TFileTask; Var QErrMsg: string): boolean;
  end;

function UnitFileMange(): TFastFileMange;

implementation

uses oneOrm, OneGUID, OneFileHelper;

var
  Unit_FileMange: TFastFileMange = nil;

function UnitFileMange(): TFastFileMange;
var
  lErrMsg: string;
begin
  if Unit_FileMange = nil then
  begin
    Unit_FileMange := TFastFileMange.Create;
    Unit_FileMange.RefreshFileSet('', lErrMsg);
  end;
  Result := Unit_FileMange;
end;

constructor TFastFileMange.Create(QZTCode: string = '');
begin
  inherited Create;
  self.FZTCode := QZTCode;
  FFileSetDict := TDictionary<string, TFastFileSet>.Create;
  FTaskDict := TDictionary<string, TFileTask>.Create;
end;

destructor TFastFileMange.Destroy;
var
  lSet: TFastFileSet;
  lTask: TFileTask;
begin
  for lSet in FFileSetDict.Values do
  begin
    lSet.Free;
  end;
  FFileSetDict.Clear;
  FFileSetDict.Free;
  //
  for lTask in FTaskDict.Values do
  begin
    lTask.Free;
  end;
  FTaskDict.Clear;
  FTaskDict.Free;
  inherited Destroy;
end;

function TFastFileMange.RefreshFileSet(QFileSetCode: string; var QErrMsg: string): boolean;
var
  lSet: TFastFileSet;
  lOrmFileSet: IOneOrm<TFastFileSet>;
  lFileSetList: TList<TFastFileSet>;
  lFileSetCode: string;
  i: integer;
begin
  Result := false;
  if QFileSetCode = '' then
  begin
    for lSet in FFileSetDict.Values do
    begin
      lSet.Free;
    end;
    FFileSetDict.Clear;
  end
  else
  begin
    if FFileSetDict.TryGetValue(QFileSetCode.ToUpper, lSet) then
    begin
      lSet.Free;
    end;
    FFileSetDict.Remove(QFileSetCode.ToUpper);
  end;

  lFileSetList := nil;
  lOrmFileSet := TOneOrm<TFastFileSet>.Start();
  if QFileSetCode = '' then
  begin
    lFileSetList := lOrmFileSet.ZTCode(self.FZTCode).Query('select * from onefast_file_set', []).ToList();
  end
  else
  begin
    lFileSetList := lOrmFileSet.ZTCode(self.FZTCode).Query('select * from onefast_file_set where FFileSetCode=:FFileSetCode', [QFileSetCode]).ToList();
  end;
  if lOrmFileSet.IsErr then
  begin
    QErrMsg := lOrmFileSet.ErrMsg;
    exit;
  end;
  if lFileSetList = nil then
  begin
    QErrMsg := '返回的对象 FileSetList=nil';
    exit;
  end;
  try
    for i := lFileSetList.Count - 1 downto 0 do
    begin
      lSet := lFileSetList[i];
      lFileSetCode := lSet.FFileSetCode_.ToUpper;
      if not FFileSetDict.ContainsKey(lFileSetCode) then
      begin
        FFileSetDict.Add(lFileSetCode, lSet);
        lFileSetList.Delete(i);
      end;
    end;
    Result := true;
  finally
    if lFileSetList <> nil then
    begin
      for i := lFileSetList.Count - 1 downto 0 do
      begin
        lFileSetList[i].Free;
      end;
      lFileSetList.Clear;
      lFileSetList.Free;
    end;
  end;
  Result := true;
end;

function TFastFileMange.CreateNewTask(QFileTask: TFileTask; Var QErrMsg: string): TFileTask;
var
  lFileSet: TFastFileSet;
  lFileStream: TFileStream;
  lFileID: string;
  lSaveFilePath, lSaveFileName: string;
  //
  lOrmFile: IOneOrm<TFastFile>;
  lFastFile: TFastFile;
  lSQL: string;
begin
  Result := nil;
  QErrMsg := '';
  lFileSet := nil;
  if (QFileTask.FFileSetCode = '') then
  begin
    QErrMsg := '标识[FFileSetCode_]文件代码为空';
    exit;
  end;
  FFileSetDict.TryGetValue(QFileTask.FFileSetCode.ToUpper, lFileSet);
  if lFileSet = nil then
  begin
    QErrMsg := '文件代码[' + QFileTask.FFileSetCode + ']不存在';
    exit;
  end;

  if not lFileSet.FIsEnabled then
  begin
    QErrMsg := '文件代码[' + QFileTask.FFileSetCode + ']未启用';
    exit;
  end;

  if (QFileTask.FTaskMode <> '上传') and (QFileTask.FTaskMode <> '下载') then
  begin
    QErrMsg := '标识[FTaskMode]不合法,只能是上传或下载';
    exit;
  end;
  if QFileTask.FTaskMode = '上传' then
  begin
    if QFileTask.FFileName = '' then
    begin
      QErrMsg := '上传的文件名称[FFileName]为空';
      exit;
    end;

    if TPath.GetExtension(QFileTask.FFileName) = '' then
    begin
      QErrMsg := '上传的文件名称[' + QFileTask.FFileName + ']需包含相关的文件类型.xxxx否则无法确定是文件还是路径！';
      exit;
    end;
    if QFileTask.FFileSize <= 0 then
    begin
      QErrMsg := '上传的文件大小[FFileSize]为零';
      exit;
    end;
    if QFileTask.FRelationID = '' then
    begin
      QErrMsg := '上传的文件关联的业务ID[FRelationID]为空';
      exit;
    end;
  end
  else if QFileTask.FTaskMode = '下载' then
  begin
    if QFileTask.FFileID = '' then
    begin
      QErrMsg := '下载的文件ID[FFileID]为空，请先获取业务关联的附件ID';
      exit;
    end;
  end;
  //
  if QFileTask.FTaskMode = '上传' then
  begin
    lFileID := OneGUID.GetGUID32;
    lSaveFilePath := lFileSet.FSavePhyPath;
    if lSaveFilePath = '' then
    begin
      // 默认
      lSaveFilePath := OneFileHelper.GetExeRunPath();
      lSaveFilePath := OneFileHelper.CombinePathC(lSaveFilePath, 'OnePlatform', 'OneFastFile');
    end;
    if not TDirectory.Exists(lSaveFilePath) then
    begin
      TDirectory.CreateDirectory(lSaveFilePath);
    end;
    lSaveFileName := lFileID + TPath.GetExtension(QFileTask.FFileName);
    lSaveFilePath := OneFileHelper.CombinePath(lSaveFilePath, lSaveFileName);
    lFileStream := nil;
    try
      lFileStream := TFile.Create(lSaveFilePath);
    finally
      if lFileStream <> nil then
        lFileStream.Free;
    end;
    //
    Result := TFileTask.Create;
    Result.FTaskID := OneGUID.GetGUID32;
    Result.FTaskMode := QFileTask.FTaskMode;
    Result.FFileSetCode := QFileTask.FFileSetCode;
    Result.FFileID := lFileID;
    Result.FFileName := QFileTask.FFileName;
    Result.FFilePosition := 0;
    Result.FFileSize := QFileTask.FFileSize;
    Result.FSaveFileName := lSaveFileName;
    Result.FSavePhyPath := lSaveFilePath;
    Result.FDataBase64 := '';
    Result.FRelationID := QFileTask.FRelationID;
    Result.FPRelationID := QFileTask.FPRelationID;
    Result.FLastTime := now;
    self.FTaskDict.Add(Result.FTaskID, Result);
  end
  else if QFileTask.FTaskMode = '下载' then
  begin
    // 要查询业务数据是否存在相关的附件记录及附件是否存在
    lOrmFile := TOneOrm<TFastFile>.Start();

    lSQL := 'select * from onefast_file where FFileID=:FFileID';
    if lFileSet.FSaveTable <> '' then
      lSQL := 'select * from ' + lFileSet.FSaveTable + ' where FFileID=:FFileID';
    lFastFile := nil;
    try
      lFastFile := lOrmFile.ZTCode(self.FZTCode).Query(lSQL, [QFileTask.FFileID]).ToObject;
      if lOrmFile.IsErr then
      begin
        QErrMsg := lOrmFile.ErrMsg;
        exit;
      end;
      if lFastFile = nil then
      begin
        QErrMsg := '此文件关联的文件ID数据已不存在！';
        exit;
      end;
      if lFastFile.FFilePhyPath = '' then
      begin
        QErrMsg := '此文件关联的文件保存文件所在路径为空';
        exit;
      end;
      if not TFile.Exists(lFastFile.FFilePhyPath) then
      begin
        QErrMsg := '此文件ID关联的文件在服务端已不存在[' + lFastFile.FFilePhyPath + ']';
        exit;
      end;

      Result := TFileTask.Create;
      Result.FTaskID := OneGUID.GetGUID32;
      Result.FTaskMode := QFileTask.FTaskMode;
      Result.FFileSetCode := QFileTask.FFileSetCode;
      Result.FFileID := lFastFile.FFileID;
      Result.FFileName := lFastFile.FFileName;
      Result.FFilePosition := 0;
{$IF CompilerVersion > 34}
      // 11才有这个方法
      Result.FFileSize := TFile.GetSize(lFastFile.FFilePhyPath);
{$ELSE}
      lFileStream := nil;
      try
        lFileStream := TFileStream.Create(lSaveFilePath, fmOpenRead);
        Result.FFileSize := lFileStream.Size;

        // Result.FFileSize := TFile.GetSize(lFastFile.FFilePhyPath);
      finally
        if lFileStream <> nil then
          lFileStream.Free;
      end;
{$ENDIF}
      // Result.FSaveFileName := lFileName;
      Result.FSavePhyPath := lFastFile.FFilePhyPath;
      Result.FDataBase64 := '';
      Result.FRelationID := lFastFile.FRelationID;
      Result.FPRelationID := lFastFile.FPRelationID;
      Result.FLastTime := now;
      self.FTaskDict.Add(Result.FTaskID, Result);
    finally
      if lFastFile <> nil then
        lFastFile.Free;
    end;
  end;
end;

function TFastFileMange.FileDel(QFileTask: TFileTask; Var QErrMsg: string): boolean;
var
  lFileSet: TFastFileSet;
  lSQL: String;
  lArr: TList<variant>;
  //
  lOrmFile: IOneOrm<TFastFile>;
  lFileList: TList<TFastFile>;
  iFile: integer;
  lFile: TFastFile;
  lTabeName: string;
begin
  Result := false;
  QErrMsg := '';
  if QFileTask.FFileSetCode = '' then
  begin
    QErrMsg := '文件配置代码不可为空';
    exit;
  end;
  FFileSetDict.TryGetValue(QFileTask.FFileSetCode.ToUpper, lFileSet);
  if lFileSet = nil then
  begin
    QErrMsg := '文件配置代码[' + QFileTask.FFileSetCode + ']不存在';
    exit;
  end;
  //
  lFileList := nil;
  lArr := TList<variant>.Create;
  try
    lSQL := 'select * from onefast_file where 1=1';
    lTabeName := 'onefast_file';
    if lFileSet.FSaveTable <> '' then
    begin
      lTabeName := lFileSet.FSaveTable;
      lSQL := 'select * from ' + lFileSet.FSaveTable;
    end;
    if QFileTask.FFileID <> '' then
    begin
      lSQL := lSQL + ' and FFileID=:FFileID ';
      lArr.Add(QFileTask.FFileID);
    end;
    if QFileTask.FRelationID <> '' then
    begin
      lSQL := lSQL + ' and FRelationID=:FRelationID ';
      lArr.Add(QFileTask.FRelationID);
    end;
    if QFileTask.FPRelationID <> '' then
    begin
      lSQL := lSQL + ' and FPRelationID=:FPRelationID ';
      lArr.Add(QFileTask.FPRelationID);
    end;
    if lArr.Count = 0 then
    begin
      QErrMsg := '文件ID不可为空或文件关联业务ID不可为空';
      exit;
    end;
    lOrmFile := TOneOrm<TFastFile>.Start();
    lFileList := lOrmFile.ZTCode(self.FZTCode).Query(lSQL, lArr.ToArray).ToList();
    if lOrmFile.IsErr then
    begin
      QErrMsg := lOrmFile.ErrMsg;
      exit;
    end;
    if lFileList <> nil then
    begin
      // 删除相关文件
      for iFile := 0 to lFileList.Count - 1 do
      begin
        lFile := lFileList[iFile];
        if lFile.FFilePhyPath = '' then
          continue;
        if TFile.Exists(lFile.FFilePhyPath) then
        begin
          TFile.Delete(lFile.FFilePhyPath);
        end;
      end;
      lOrmFile.InitOrm();
      lOrmFile.ZTCode(self.FZTCode).SetTableName(lTabeName).SetPrimaryKey('FFileID').Delete(lFileList).toCmd().ToExecCommand();
      if lOrmFile.IsErr then
      begin
        QErrMsg := lOrmFile.ErrMsg;
        exit;
      end;
    end;
  finally
    lArr.Clear;
    lArr.Free;
    if lFileList <> nil then
    begin
      for iFile := 0 to lFileList.Count - 1 do
      begin
        lFileList[iFile].Free;
      end;
      lFileList.Clear;
      lFileList.Free;
    end;
  end;
  Result := true;
end;

function TFastFileMange.FileUpLoad(QUpLoadTask: TFileTask; Var QErrMsg: string): boolean;
var
  lFileTask: TFileTask;
  lFastFile: TFastFile;
  lFileStream: TFileStream;
  lBytes: TBytes;
  lFileSet: TFastFileSet;
  //
  lOrmFile: IOneOrm<TFastFile>;
  lSaveTableName: string;
begin
  Result := false;
  QErrMsg := '';
  if QUpLoadTask.FTaskID = '' then
  begin
    QErrMsg := '任务ID为空,请先申请任务ID';
    exit;
  end;
  if (QUpLoadTask.FFilePosition >= 0) and (QUpLoadTask.FDataBase64 = '') then
  begin
    QErrMsg := '上传的文件内容为空';
    exit;
  end;

  if not self.FTaskDict.TryGetValue(QUpLoadTask.FTaskID, lFileTask) then
  begin
    QErrMsg := '任务已不存在！';
    exit;
  end;
  lFileTask.FLastTime := now;

  if not FFileSetDict.TryGetValue(lFileTask.FFileSetCode.ToUpper, lFileSet) then
  begin
    QErrMsg := '文件配置代码不存在';
    exit;
  end;

  lFastFile := nil;
  lFileStream := TFileStream.Create(lFileTask.FSavePhyPath, fmOpenReadWrite);
  try
    lFileStream.Position := QUpLoadTask.FFilePosition;
    lBytes := TNetEncoding.Base64.DecodeStringToBytes(QUpLoadTask.FDataBase64);
    lFileStream.Write(lBytes, length(lBytes));
    lFileTask.FFilePosition := lFileStream.Position;
    if lFileStream.Size >= lFileTask.FFileSize then
    begin
      // 代表传完了
      // 文件上传完,在记录表插入一条记录
      lFastFile := TFastFile.Create;
      lFastFile.FFileID := lFileTask.FFileID;
      lFastFile.FFileName := lFileTask.FFileName;
      lFastFile.FFileSetCode := lFileTask.FFileSetCode;
      lFastFile.FFilePhyPath := lFileTask.FSavePhyPath;
      lFastFile.FFileHttpUrl := '';
      lFastFile.FFileSize := lFileTask.FFileSize;
      lFastFile.FRelationID := lFileTask.FRelationID;
      lFastFile.FPRelationID := lFileTask.FPRelationID;
      // lFile.FFileRemark := lFileTask.re;
      lFastFile.FCreateTime := now;
      lSaveTableName := 'onefast_file';
      if lFileSet.FSaveTable <> '' then
        lSaveTableName := lFileSet.FSaveTable;
      lOrmFile := TOneOrm<TFastFile>.Start();
      lOrmFile.ZTCode(self.FZTCode).SetTableName(lSaveTableName).SetPrimaryKey('FFileID')
        .Inserter(lFastFile).toCmd().ToExecCommand();
      if lOrmFile.IsErr then
      begin
        QErrMsg := lOrmFile.ErrMsg;
        exit;
      end;
    end;
  finally
    lFileStream.Free;
    if lFastFile <> nil then
      lFastFile.Free;
  end;
  Result := true;
end;

function TFastFileMange.FileDown(QDownTask: TFileTask; Var QErrMsg: string): boolean;
var
  lFileTask: TFileTask;
  lFile: TFastFile;
  lFileStream: TFileStream;
  lBytes: TBytes;
  lFileSet: TFastFileSet;
  iChunSize: integer;
begin
  Result := false;
  QErrMsg := '';
  if QDownTask.FTaskID = '' then
  begin
    QErrMsg := '任务ID为空,请先申请任务ID';
    exit;
  end;
  if (QDownTask.FFilePosition < 0) then
  begin
    QDownTask.FFilePosition := 0;
    exit;
  end;

  if not self.FTaskDict.TryGetValue(QDownTask.FTaskID, lFileTask) then
  begin
    QErrMsg := '任务已不存在！';
    exit;
  end;
  lFileTask.FLastTime := now;

  if not FFileSetDict.TryGetValue(lFileTask.FFileSetCode.ToUpper, lFileSet) then
  begin
    QErrMsg := '文件配置代码不存在';
    exit;
  end;

  if not TFile.Exists(lFileTask.FSavePhyPath) then
  begin
    QErrMsg := '服务端文件[' + lFileTask.FFileName + ']不存在';
    exit;
  end;

  lFileStream := TFileStream.Create(lFileTask.FSavePhyPath, fmOpenRead);
  try
    if lFileStream.Size <> lFileTask.FFileSize then
    begin
      QErrMsg := '服务端升级文件大小已发生变化,请重新升级,当前文件大小:' + lFileStream.Size.ToString;
      exit;
    end;
    if QDownTask.FFileChunkSize <= 0 then
    begin
      QDownTask.FFileChunkSize := 1024 * 1024;
    end;
    iChunSize := QDownTask.FFileChunkSize;
    lFileStream.Position := QDownTask.FFilePosition;
    if QDownTask.FFilePosition + iChunSize > lFileStream.Size then
    begin
      iChunSize := lFileStream.Size - QDownTask.FFilePosition;
    end;
    if iChunSize <= 0 then
    begin
      QErrMsg := '已超过文件最大容量，无需继续请求下载';
      exit;
    end;
    setLength(lBytes, iChunSize);
    lFileStream.Read(lBytes, iChunSize);
    QDownTask.FDataBase64 := TNetEncoding.Base64.EncodeBytesToString(lBytes);
  finally
    lFileStream.Free;
  end;
  Result := true;
end;

initialization

finalization

if Unit_FileMange <> nil then
  Unit_FileMange.Free;

end.

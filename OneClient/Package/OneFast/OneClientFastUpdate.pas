unit OneClientFastUpdate;

interface

uses system.Classes, system.SysUtils, OneClientConnect, system.Generics.Collections,
  system.json, system.IOUtils, system.NetEncoding, OneClientConst;

const
  // 流水号获取相关功能
  URL_HTTP_Update_RefreshUpdateSet = 'OneServer/FastUpdate/RefreshUpdateSet';
  URL_HTTP_Update_GetUpdateSet = 'OneServer/FastUpdate/GetUpdateSet';
  URL_HTTP_Update_UpdateDownFile = 'OneServer/FastUpdate/UpdateDownFile';

type
  // emUnknow未知,emNotUpdate无需更新, emCanUpdate可更新，
  // emForceUpdate强制更新，emCheckErr检测有问题
  enumCheckUpdate = (emUnknow, emCanUpdate, emForceUpdate, emCheckErr, emNotUpdate);
  enumUpdateDownStep = (emStepStart, emStepEnd, emFileStart, emFileProcess, emFileEnd, emStepErr);
  // 回调事件类型
  evenDownCallBack = procedure(QDownStep: enumUpdateDownStep; QFileCount: integer; QIndexFile: integer;
    QFileName: string; QFileSize: int64; QFilePosition: int64) of object;

  TOneFastUpdateFile = class
  private
    FFileName: string; // 文件名称,包括后缀
    FFileClientPath: string; // 客户端相对Exe相对路径
    FFileSize: int64;
    FFileRemark: string;
  published
    property FileName: string read FFileName write FFileName;
    property FileClientPath: string read FFileClientPath write FFileClientPath;
    property FileSize: int64 read FFileSize write FFileSize;
    property FileRemark: string read FFileRemark write FFileRemark;
  end;

  TOneFastUpdateSet = class
  private
    FUpdateCode: string;
    FUpdateVersion: string; // 如20230419,小版本可以用20230419.01......
    FUpdatePath: string;
    FUpdateFiles: TList<TOneFastUpdateFile>;
  public
    constructor Create();
    destructor Destroy; override;
  published
    property UpdateCode: string read FUpdateCode write FUpdateCode;
    property UpdateVersion: string read FUpdateVersion write FUpdateVersion;
    property UpdateFiles: TList<TOneFastUpdateFile> read FUpdateFiles write FUpdateFiles;
  end;

  { 升级控件 }
  [ComponentPlatformsAttribute(OneAllPlatforms)]
  TOneFastUpdate = class(TComponent)
  private
    FConnection: TOneConnection;
    FUpdateCode: string;
    FFastUpdateSet: TOneFastUpdateSet;
    FErrMsg: string;
    FClientSetFile: string;
    FOnCallBack: evenDownCallBack;
    FDownPath: string;
  private
    // 获取连接
    function GetConnection: TOneConnection;
    procedure SetConnection(const AValue: TOneConnection);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    // 刷新配置
    function RefreshUpdateSet(): boolean;
    // 获取升级配置信息
    function GetUpdateSet(): boolean;
    // 1.判断是否可更新
    function CheckCanUpdate(): enumCheckUpdate;
    // 2.进行升级文件下载到本地
    function DoUpdateDownFile(): boolean;
    // 3.进行本地文件老的重命名,新的替换到老的
    function CopyFileAndUpdate(): boolean;
  published
    property Connection: TOneConnection read GetConnection write SetConnection;
    /// <summary>
    /// 升级配置代码
    /// </summary>
    property UpdateCode: string read FUpdateCode write FUpdateCode;
    /// <summary>
    /// 客户端配置文件所在路径 d:/xxx/[UpdateCode].json,不设置程序会自动处理
    /// </summary>
    property ClientSetFile: string read FClientSetFile write FClientSetFile;
    /// <summary>
    /// 下载文件回调
    /// </summary>
    property OnCallBack: evenDownCallBack read FOnCallBack write FOnCallBack;
    property ErrMsg: string read FErrMsg write FErrMsg;
  end;

implementation

uses OneClientResult, OneNeonHelper, OneFileHelper;

constructor TOneFastUpdateSet.Create();
begin
  inherited Create;
  FUpdateFiles := TList<TOneFastUpdateFile>.Create;
end;

destructor TOneFastUpdateSet.Destroy;
var
  i: integer;
begin
  for i := 0 to FUpdateFiles.Count - 1 do
  begin
    FUpdateFiles[i].Free;
  end;
  FUpdateFiles.Clear;
  FUpdateFiles.Free;
  inherited Destroy;
end;

//
constructor TOneFastUpdate.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FFastUpdateSet := nil;
end;

destructor TOneFastUpdate.Destroy;
begin
  if self.FFastUpdateSet <> nil then
    self.FFastUpdateSet.Free;
  inherited Destroy;
end;

function TOneFastUpdate.GetConnection: TOneConnection;
begin
  Result := self.FConnection;
end;

procedure TOneFastUpdate.SetConnection(const AValue: TOneConnection);
begin
  self.FConnection := AValue;
end;

function TOneFastUpdate.RefreshUpdateSet(): boolean;
var
  lErrMsg: string;
  //
  lJsonObj: TJsonObject;
  lResultJsonValue: TJsonValue;
  lServerResult: TActionResult<string>;
begin
  Result := false;
  self.ErrMsg := '';
  if self.FUpdateCode = '' then
  begin
    self.ErrMsg := '更新代码[UpdateCode]未设置相关值';
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
    lJsonObj.AddPair('QUpdateCode', self.FUpdateCode);
    lResultJsonValue := self.FConnection.PostResultJsonValue(URL_HTTP_Update_RefreshUpdateSet, lJsonObj.ToJSON(), lErrMsg);
    if not self.FConnection.IsErrTrueResult(lErrMsg) then
    begin
      self.ErrMsg := lErrMsg;
      exit;
    end;
    if not OneNeonHelper.JsonToObject(lServerResult, lResultJsonValue, lErrMsg) then
    begin
      self.ErrMsg := '返回的数据解析成TResult<TClientConnect>出错,无法知道结果,数据:' + lResultJsonValue.ToJSON;
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

function TOneFastUpdate.GetUpdateSet(): boolean;
var
  lErrMsg: string;
  i: integer;
  //
  lJsonObj: TJsonObject;
  lResultJsonValue: TJsonValue;
  lServerResult: TActionResult<TOneFastUpdateSet>;
  //
  lUpdateFile: TOneFastUpdateFile;
begin
  Result := false;
  self.ErrMsg := '';
  if self.FUpdateCode = '' then
  begin
    self.ErrMsg := '更新代码[UpdateCode]未设置相关值';
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
  lServerResult := TActionResult<TOneFastUpdateSet>.Create;
  lServerResult.ResultData := TOneFastUpdateSet.Create;
  lJsonObj := TJsonObject.Create;
  try
    lJsonObj.AddPair('QUpdateCode', self.FUpdateCode);
    lResultJsonValue := self.FConnection.PostResultJsonValue(URL_HTTP_Update_GetUpdateSet, lJsonObj.ToJSON(), lErrMsg);
    if not self.FConnection.IsErrTrueResult(lErrMsg) then
    begin
      self.ErrMsg := lErrMsg;
      exit;
    end;
    if not OneNeonHelper.JsonToObject(lServerResult, lResultJsonValue, lErrMsg) then
    begin
      self.ErrMsg := '返回的数据解析成TResult<TClientConnect>出错,无法知道结果,数据:' + lResultJsonValue.ToJSON;
      exit;
    end;
    if not lServerResult.ResultSuccess then
    begin
      self.ErrMsg := '服务端消息:' + lServerResult.ResultMsg;
      exit;
    end;
    // 校验 TOneFastUpdateSet配置
    for i := 0 to lServerResult.ResultData.FUpdateFiles.Count - 1 do
    begin
      lUpdateFile := lServerResult.ResultData.FUpdateFiles[i];
      if lUpdateFile.FFileClientPath <> '' then
      begin
        if TPath.GetDirectoryName(lUpdateFile.FFileClientPath) <> '' then
        begin
          self.ErrMsg := lUpdateFile.FFileName + ':升级路径只能是相对路径,不能包含驱动路径';
          exit;
        end;
      end;
    end;

    Result := true;

  finally
    lJsonObj.Free;
    if lResultJsonValue <> nil then
    begin
      lResultJsonValue.Free;
    end;
    if not Result then
    begin
      lServerResult.ResultData.Free;
      lServerResult.ResultData := nil;
    end
    else
    begin
      if self.FFastUpdateSet <> nil then
        self.FFastUpdateSet.Free;
      self.FFastUpdateSet := lServerResult.ResultData;
      lServerResult.ResultData := nil;
    end;
    lServerResult.Free;
  end;
end;

function TOneFastUpdate.CheckCanUpdate(): enumCheckUpdate;
var
  lOldVersion: string;
  lStream: TMemoryStream;
  lJsonObject: TJsonObject;
  lBytes: TBytes;
  lArrOld, lArrNew: TArray<string>;
  iArr, iOld, iNew: integer;
  tempStr: string;
begin
  Result := enumCheckUpdate.emUnknow;
  lOldVersion := '0.0.0';
  if self.FUpdateCode = '' then
  begin
    self.FErrMsg := '升级代码不可为空!';
    Result := enumCheckUpdate.emCheckErr;
    exit;
  end;
  // 取客户端版本号
  if self.FClientSetFile = '' then
  begin
    // 获取程序所在目录
    self.FClientSetFile := TDirectory.GetCurrentDirectory();
    self.FClientSetFile := OneFileHelper.CombinePath(self.FClientSetFile,
      '\OnePlatform\OneFastUpdate\' + self.FUpdateCode + '\' + self.FUpdateCode + '.json');
  end;
  FDownPath := OneFileHelper.CombinePath(TDirectory.GetCurrentDirectory(),
    '\OnePlatform\OneFastUpdate\' + self.FUpdateCode);
  if not TDirectory.Exists(FDownPath) then
  begin
    TDirectory.CreateDirectory(FDownPath);
  end;
  if TFile.Exists(self.FClientSetFile) then
  begin
    // 加载取出版本号
    lJsonObject := nil;
    lStream := TMemoryStream.Create();
    try
      lStream.LoadFromFile(self.FClientSetFile);
      lStream.Position := 0;
      setLength(lBytes, lStream.Size);
      lStream.Read(lBytes, lStream.Size);
      lJsonObject := TJsonObject.ParseJSONValue(lBytes, 0, lStream.Size) as TJsonObject;
      if lJsonObject <> nil then
      begin
        lJsonObject.TryGetValue<string>('UpdateVersion', lOldVersion);
      end;
    finally
      lStream.Clear;
      lStream.Free;
      if lJsonObject <> nil then
        lJsonObject.Free;
    end;
  end;
  // 取服务端版本号
  if not self.GetUpdateSet() then
  begin
    Result := enumCheckUpdate.emCheckErr;
    exit;
  end;
  if self.FFastUpdateSet.FUpdateVersion = '' then
  begin
    self.FErrMsg := '服务升级文件未设置版本号,如果永不升级版本号设置为[0.0.0]即可!';
    Result := enumCheckUpdate.emCheckErr;
    exit;
  end;
  if self.FFastUpdateSet.FUpdateVersion = '0.0.0' then
  begin
    Result := enumCheckUpdate.emNotUpdate;
    exit;
  end;
  // 判断版本号大小
  if lOldVersion <> self.FFastUpdateSet.FUpdateVersion then
  begin
    // 分析判断版本号大小
    lArrOld := lOldVersion.Split(['.']);
    lArrNew := self.FFastUpdateSet.FUpdateVersion.Split(['.']);
    if length(lArrOld) <> 3 then
    begin
      // 版本号不合法，初始化版本号
      lArrOld := nil;
      setLength(lArrOld, 3);
      lArrOld[0] := '0';
      lArrOld[1] := '0';
      lArrOld[2] := '0';
    end;
    //
    if length(lArrNew) <> 3 then
    begin
      self.FErrMsg := '服务端升级文件配置格式不合法,请设置成[数字.数字.数字]版本标准格式!';
      Result := enumCheckUpdate.emCheckErr;
      exit;
    end;

    for iArr := Low(lArrNew) to High(lArrNew) do
    begin
      iOld := 0;
      iNew := 0;
      tempStr := lArrOld[iArr];
      if not tryStrToInt(tempStr, iOld) then
      begin
        iOld := 0;
      end;
      tempStr := lArrNew[iArr];
      if not tryStrToInt(tempStr, iNew) then
      begin
        self.FErrMsg := '服务端升级文件配置格式不合法,请设置成[数字.数字.数字]版本标准格式,只能有数字!';
        Result := enumCheckUpdate.emCheckErr;
        exit;
      end;
      if iNew > iOld then
      begin
        Result := enumCheckUpdate.emCanUpdate;
        exit;
      end;
    end;
    // 客户端版本号较大,不需要升级
    Result := enumCheckUpdate.emNotUpdate;
  end
  else
  begin
    Result := enumCheckUpdate.emNotUpdate;
  end;
end;

function TOneFastUpdate.DoUpdateDownFile(): boolean;
var
  i: integer;
  lFastUpdateFile: TOneFastUpdateFile;
  lFilePosition: int64;
  lFileChunkSize: integer;
  lErrMsg: string;
  //
  isErr: boolean;
  lResultSuccess: boolean;
  lBase64Str: string;
  lPostJsonValue: TJsonObject;
  lResultJsonValue: TJsonValue;
  //
  lFileName: string;
  lFileStream: TFileStream;
  lBytes: TBytes;
begin
  Result := false;
  lErrMsg := '';
  if assigned(self.FOnCallBack) then
  begin
    self.FOnCallBack(enumUpdateDownStep.emStepStart, self.FFastUpdateSet.FUpdateFiles.Count, 0,
      '', 0, 0);
  end;

  for i := 0 to self.FFastUpdateSet.FUpdateFiles.Count - 1 do
  begin
    lFastUpdateFile := self.FFastUpdateSet.FUpdateFiles[i];
    if lFastUpdateFile.FFileName = '' then
      continue;
    if lFastUpdateFile.FFileSize = 0 then
      continue;
    if lFastUpdateFile.FFileName.ToLower = '系统生成JSON格式.exe' then
      continue;
    // 请求保存在临时文件夹下面 本地文件存在删除否则
    lFileName := OneFileHelper.CombinePath(self.FDownPath, lFastUpdateFile.FFileName);
    if TFile.Exists(lFileName) then
      TFile.Delete(lFileName);

    lFileStream := TFileStream.Create(lFileName, fmCreate or fmOpenReadWrite or fmShareExclusive);
    try
      lFilePosition := 0;
      if assigned(self.FOnCallBack) then
      begin
        self.FOnCallBack(enumUpdateDownStep.emFileStart, self.FFastUpdateSet.FUpdateFiles.Count, i,
          lFastUpdateFile.FFileName, lFastUpdateFile.FFileSize, lFilePosition);
      end;
      // 下载文件 UpdateCode,UpdateVersion,FFileName,FFileSize,FFilePosion,FFileChunkSize
      while lFilePosition < lFastUpdateFile.FFileSize do
      begin
        isErr := false;
        lResultJsonValue := nil;
        lPostJsonValue := TJsonObject.Create;
        try
          lFileChunkSize := 1024 * 1024;
          lPostJsonValue.AddPair('UpdateCode', self.FUpdateCode);
          lPostJsonValue.AddPair('UpdateVersion', self.FFastUpdateSet.FUpdateVersion);
          lPostJsonValue.AddPair('FileName', lFastUpdateFile.FFileName);
          lPostJsonValue.AddPair('FileSize', TJsonNumber.Create(lFastUpdateFile.FFileSize));
          lPostJsonValue.AddPair('FilePosition', TJsonNumber.Create(lFilePosition));
          lPostJsonValue.AddPair('FileChunkSize', TJsonNumber.Create(lFileChunkSize));
          // 不停的向服务端请求文件下载
          lResultJsonValue := self.FConnection.PostResultJsonValue(URL_HTTP_Update_UpdateDownFile, lPostJsonValue.ToJSON(), lErrMsg);
          if not self.FConnection.IsErrTrueResult(lErrMsg) then
          begin
            self.ErrMsg := lErrMsg;
            isErr := true;
            exit;
          end;
          if not lResultJsonValue.TryGetValue<boolean>('ResultSuccess', lResultSuccess) then
          begin
            self.ErrMsg := '返回的Json格式有错,非标准TActionResult<T>,当前数据:' + lResultJsonValue.ToString();
            isErr := true;
            exit;
          end;
          if not lResultSuccess then
          begin
            isErr := true;
            if lResultJsonValue.TryGetValue<string>('ResultMsg', lErrMsg) then
            begin
              self.ErrMsg := lErrMsg;
            end
            else
            begin
              self.ErrMsg := lResultJsonValue.ToString;
            end;
            exit;
          end;
          if not lResultJsonValue.TryGetValue<string>('ResultData', lBase64Str) then
          begin
            self.ErrMsg := '返回的Json格式有错,非标准TActionResult<T>,当前数据:' + lResultJsonValue.ToString();
            isErr := true;
            exit;
          end;
          // base64转流
          lBytes := TNetEncoding.Base64.DecodeStringToBytes(lBase64Str);
          lFileStream.Position := lFilePosition;
          lFileStream.Write(lBytes, length(lBytes));
          // 移动位置
          lFilePosition := lFilePosition + lFileChunkSize;
          if lFilePosition > lFastUpdateFile.FFileSize then
            lFilePosition := lFastUpdateFile.FFileSize;
          if assigned(self.FOnCallBack) then
          begin
            self.FOnCallBack(enumUpdateDownStep.emFileProcess, self.FFastUpdateSet.FUpdateFiles.Count, i,
              lFastUpdateFile.FFileName, lFastUpdateFile.FFileSize, lFilePosition);
          end;
        finally
          lPostJsonValue.Free;
          if lResultJsonValue <> nil then
            lResultJsonValue.Free;
          if isErr then
          begin
            // 错误消息
            if assigned(self.FOnCallBack) then
            begin
              self.FOnCallBack(enumUpdateDownStep.emStepErr, self.FFastUpdateSet.FUpdateFiles.Count, i,
                lFastUpdateFile.FFileName, lFastUpdateFile.FFileSize, lFilePosition);
            end;
          end;
        end;
      end;
    finally
      lFileStream.Free;
    end;
    //
    if assigned(self.FOnCallBack) then
    begin
      self.FOnCallBack(enumUpdateDownStep.emFileEnd, self.FFastUpdateSet.FUpdateFiles.Count, i,
        lFastUpdateFile.FFileName, lFastUpdateFile.FFileSize, lFilePosition);
    end;
  end;
  if assigned(self.FOnCallBack) then
  begin
    self.FOnCallBack(enumUpdateDownStep.emStepEnd, self.FFastUpdateSet.FUpdateFiles.Count, 0,
      '', 0, 0);
  end;
  Result := true;
end;

function TOneFastUpdate.CopyFileAndUpdate(): boolean;
var
  i: integer;
  lFastUpdateFile: TOneFastUpdateFile;
  lSourceFile, lDestFile: string;
  lErrMsg: string;
begin
  Result := false;
  try
    try
      for i := 0 to self.FFastUpdateSet.FUpdateFiles.Count - 1 do
      begin
        lFastUpdateFile := self.FFastUpdateSet.FUpdateFiles[i];
        if lFastUpdateFile.FFileName = '' then
          continue;
        if lFastUpdateFile.FFileSize = 0 then
          continue;
        // 原来文件所在地
        lSourceFile := TDirectory.GetCurrentDirectory();
        if lFastUpdateFile.FFileClientPath <> '' then
        begin
          lSourceFile := OneFileHelper.CombinePath(lSourceFile, lFastUpdateFile.FFileClientPath);
        end;
        lSourceFile := OneFileHelper.CombinePath(lSourceFile, lFastUpdateFile.FFileName);
        if TFile.Exists(lSourceFile) then
        begin
          // 更改原文件名字
          lDestFile := lSourceFile + '.back';
          if TFile.Exists(lDestFile) then
          begin
            TFile.Delete(lDestFile);
          end;
          RenameFile(lSourceFile, lDestFile);
        end;
        // 升级的文件copy到对应的目录
        lDestFile := OneFileHelper.CombinePath(TDirectory.GetCurrentDirectory(),
          '\OnePlatform\OneFastUpdate\' + self.FUpdateCode + '\' + lFastUpdateFile.FFileName);
        TFile.Copy(lDestFile, lSourceFile);
      end;
      // 更改配置文件
      OneNeonHelper.ObjectToJsonFile(self.FFastUpdateSet, self.FClientSetFile, lErrMsg);
      //
      Result := true;
    except
      on e: exception do
      begin
        self.FErrMsg := e.Message;
      end;
    end;
  finally
    // 升级失败,名字改回去
  end;
end;

end.

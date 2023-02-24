unit OneClientVirtualFile;

interface

uses OneClientConst, system.Classes, OneClientConnect, system.IOUtils, OneStreamString,
  system.Threading, system.Generics.Collections, system.StrUtils, system.SysUtils;

type

  [ComponentPlatformsAttribute(OneAllPlatforms)]
  TOneVirtualFile = class(TComponent)
  private
    FConnection: TOneConnection;
    FVirtualCode: string;
    FRemoteFile: string;
    FLocalFile: string;
    FReturnFileName: string;
    FChunkBlock: Integer;
    // FUpDownChunkCallBack: EvenUpDownChunkCallBack;
    FIsBatch: boolean;
    FFileList: TList<string>;
    FErrMsg: string;
  private
    function GetConnection: TOneConnection;
    procedure SetConnection(const AValue: TOneConnection);
    procedure DoUploadChunkFile(QCallBack: EvenUpDownChunkCallBack);
  public
    // 单个文件上传下载
    function UploadFile(): boolean;
    function DownloadFile(): boolean;
    function DeleteFile(): boolean;
    // 单个文件上传下载异步
    procedure UploadFileAsync(QCallEven: EvenOKCallBack);
    procedure DownloadFileAsync(QCallEven: EvenOKCallBack);
    { 异步分块上传下载 }
    procedure UploadChunkFileAsync(QEven: EvenUpDownChunkCallBack);
    procedure DownloadChunkFileAsync(QEven: EvenUpDownChunkCallBack);
    { 批量上传文件 }
    procedure UploadFileListAsync(QEven: EvenUpDownChunkCallBack);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  public
    property FileList: TList<string> read FFileList write FFileList;
    property IsBatch: boolean read FIsBatch;
  published
    property Connection: TOneConnection read GetConnection write SetConnection;
    property VirtualCode: string read FVirtualCode write FVirtualCode;
    property RemoteFile: string read FRemoteFile write FRemoteFile;
    property LocalFile: string read FLocalFile write FLocalFile;
    property ReturnFileName: string read FReturnFileName write FReturnFileName;
    property ChunkBlock: Integer read FChunkBlock write FChunkBlock;
    property ErrMsg: string read FErrMsg write FErrMsg;
    // property onUpDownChunkCallBack: EvenUpDownChunkCallBack read FUpDownChunkCallBack write FUpDownChunkCallBack;
  end;

implementation

uses OneFileHelper;

constructor TOneVirtualFile.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FileList := TList<string>.Create;
end;

destructor TOneVirtualFile.Destroy;
begin
  FFileList.Clear;
  FFileList.Free;
  inherited Destroy;
end;

function TOneVirtualFile.GetConnection: TOneConnection;
begin
  Result := self.FConnection;
end;

procedure TOneVirtualFile.SetConnection(const AValue: TOneConnection);
begin
  self.FConnection := AValue;
end;

function TOneVirtualFile.UploadFile(): boolean;
var
  lVirtualInfo: TVirtualInfo;
begin
  Result := false;
  if self.FConnection = nil then
    self.FConnection := OneClientConnect.Unit_Connection;
  if self.FConnection = nil then
  begin
    self.FErrMsg := '数据集Connection=nil';
    exit;
  end;
  if not self.FConnection.Connected then
  begin
    self.ErrMsg := '服务器未连接';
    exit;
  end;
  lVirtualInfo := TVirtualInfo.Create;
  try
    lVirtualInfo.VirtualCode := self.VirtualCode;
    lVirtualInfo.RemoteFile := self.RemoteFile;
    lVirtualInfo.LocalFile := self.LocalFile;
    Result := self.FConnection.UploadFile(lVirtualInfo);
    self.ErrMsg := lVirtualInfo.ErrMsg;
    self.ReturnFileName := lVirtualInfo.RemoteFileName;
  finally
    lVirtualInfo.Free;
  end;
end;

function TOneVirtualFile.DownloadFile(): boolean;
var
  lVirtualInfo: TVirtualInfo;
begin
  Result := false;
  if self.FConnection = nil then
    self.FConnection := OneClientConnect.Unit_Connection;
  if self.FConnection = nil then
  begin
    self.FErrMsg := '数据集Connection=nil';
    exit;
  end;
  if not self.FConnection.Connected then
  begin
    self.ErrMsg := '服务器未连接';
    exit;
  end;
  lVirtualInfo := TVirtualInfo.Create;
  try
    lVirtualInfo.VirtualCode := self.VirtualCode;
    lVirtualInfo.RemoteFile := self.RemoteFile;
    lVirtualInfo.LocalFile := self.LocalFile;
    Result := self.FConnection.DownloadFile(lVirtualInfo);
    self.ErrMsg := lVirtualInfo.ErrMsg;
  finally
    lVirtualInfo.Free;
  end;
end;

function TOneVirtualFile.DeleteFile(): boolean;
var
  lVirtualInfo: TVirtualInfo;
begin
  Result := false;
  if self.FConnection = nil then
    self.FConnection := OneClientConnect.Unit_Connection;
  if self.FConnection = nil then
  begin
    self.FErrMsg := '数据集Connection=nil';
    exit;
  end;
  if not self.FConnection.Connected then
  begin
    self.ErrMsg := '服务器未连接';
    exit;
  end;
  lVirtualInfo := TVirtualInfo.Create;
  try
    lVirtualInfo.VirtualCode := self.VirtualCode;
    lVirtualInfo.RemoteFile := self.RemoteFile;
    lVirtualInfo.LocalFile := self.LocalFile;
    Result := self.FConnection.DeleteVirtualFile(lVirtualInfo);
    self.ErrMsg := lVirtualInfo.ErrMsg;
    self.ReturnFileName := lVirtualInfo.RemoteFileName;
  finally
    lVirtualInfo.Free;
  end;
end;

procedure TOneVirtualFile.UploadFileAsync(QCallEven: EvenOKCallBack);
var
  aTask: ITask;
begin
  aTask := TTask.Create(
    procedure
    var
      lResultOK: boolean;
    begin
      try
        lResultOK := self.UploadFile;
      finally
        if Assigned(QCallEven) then
        begin
          TThread.Synchronize(nil,
            procedure()
            var
              i: Integer;
            begin
              QCallEven(lResultOK, self.FErrMsg);
            end);
        end;
      end;
    end);
  aTask.Start;
end;

procedure TOneVirtualFile.DownloadFileAsync(QCallEven: EvenOKCallBack);
var
  aTask: ITask;
begin
  aTask := TTask.Create(
    procedure
    var
      lResultOK: boolean;
    begin
      try
        lResultOK := self.DownloadFile;
      finally
        if Assigned(QCallEven) then
        begin
          TThread.Synchronize(nil,
            procedure()
            var
              i: Integer;
            begin
              QCallEven(lResultOK, self.FErrMsg);
            end);
        end;
      end;
    end);
  aTask.Start;
end;

procedure TOneVirtualFile.DoUploadChunkFile(QCallBack: EvenUpDownChunkCallBack);
var
  lTask: TVirtualTask;
  lLoclFile: string;
  iFile, iCount: Integer;
begin
  if self.FConnection = nil then
    self.FConnection := OneClientConnect.Unit_Connection;
  if self.FConnection = nil then
  begin
    self.FErrMsg := '文件上传控件服务器连接Connection=nil';
    if Assigned(QCallBack) then
    begin
      QCallBack(emUpDownMode.UpLoad, emUpDownChunkStatus.upDownErr, 0, 0, self.FErrMsg);
    end;
    exit;
  end;
  if not self.FConnection.Connected then
  begin
    self.ErrMsg := '服务器未连接';
    QCallBack(emUpDownMode.UpLoad, emUpDownChunkStatus.upDownErr, 0, 0, self.FErrMsg);
    exit;
  end;
  { 单个文件上传时，把文件名称加到批量列表 }
  if not self.FIsBatch then
  begin
    self.FFileList.Clear;
    self.FFileList.Add(self.LocalFile);
  end;
  iCount := self.FFileList.Count;
  { 批量上传文件 }
  if Assigned(QCallBack) and (self.FIsBatch) then
  begin
    QCallBack(emUpDownMode.UpLoad, emUpDownChunkStatus.upDownListStar, iCount, 0, '');
  end;
  for iFile := 0 to iCount - 1 do
  begin
    lLoclFile := self.FFileList[iFile];
    if lLoclFile.Trim = '' then
    begin
      continue;
    end;
    lTask := TVirtualTask.Create;
    try
      lTask.VirtualCode := self.VirtualCode;
      lTask.RemoteFile := self.RemoteFile;
      lTask.LocalFile := lLoclFile;
      if self.FIsBatch then
      begin
        if lTask.RemoteFile <> '' then
          lTask.RemoteFile := TPath.GetDirectoryName(lTask.RemoteFile);
        lTask.RemoteFile := lTask.RemoteFile + TPath.GetFileName(lTask.LocalFile);
      end;
      if not self.FConnection.UploadChunkFile(lTask, QCallBack) then
      begin
        self.ErrMsg := lTask.ErrMsg;
        exit;
      end;
      self.ReturnFileName := lTask.NewFileName;
    finally
      lTask.Free;
    end;
    if Assigned(QCallBack) and (self.FIsBatch) then
    begin
      if iFile = iCount - 1 then
        QCallBack(emUpDownMode.UpLoad, emUpDownChunkStatus.upDownListEnd, iCount, iFile, '')
      else
        QCallBack(emUpDownMode.UpLoad, emUpDownChunkStatus.upDownListProcess, iCount, iFile, '');
    end;
  end;
end;

procedure TOneVirtualFile.UploadChunkFileAsync(QEven: EvenUpDownChunkCallBack);
var
  lTask: TVirtualTask;
begin
  self.FIsBatch := false;
  self.FFileList.Clear;
  self.DoUploadChunkFile(QEven);
end;

procedure TOneVirtualFile.UploadFileListAsync(QEven: EvenUpDownChunkCallBack);
begin
  self.FIsBatch := true;
  self.DoUploadChunkFile(QEven);
end;

procedure TOneVirtualFile.DownloadChunkFileAsync(QEven: EvenUpDownChunkCallBack);
var
  lTask: TVirtualTask;
begin
  if self.FConnection = nil then
    self.FConnection := OneClientConnect.Unit_Connection;
  if self.FConnection = nil then
  begin
    self.FErrMsg := '文件上传控件服务器连接Connection=nil';
    if Assigned(QEven) then
    begin
      QEven(emUpDownMode.DownLoad, emUpDownChunkStatus.upDownErr, 0, 0, self.FErrMsg);
    end;
    exit;
  end;
  if not self.FConnection.Connected then
  begin
    self.ErrMsg := '服务器未连接';
    QEven(emUpDownMode.DownLoad, emUpDownChunkStatus.upDownErr, 0, 0, self.FErrMsg);
    exit;
  end;
  lTask := TVirtualTask.Create;
  try
    lTask.VirtualCode := self.VirtualCode;
    lTask.RemoteFile := self.RemoteFile;
    lTask.LocalFile := self.LocalFile;
    self.FConnection.DownloadChunkFile(lTask, QEven);
    self.ErrMsg := lTask.ErrMsg;
  finally
    lTask.Free;
  end;
end;

end.

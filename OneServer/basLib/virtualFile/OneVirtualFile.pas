unit OneVirtualFile;

interface

uses system.Generics.Collections, system.StrUtils, system.SysUtils, system.DateUtils,
  OneThread;

type
  TOneVirtualItem = class;
  TOneVirtualSet = class;
  TVirtualInfo = class;
  TVirtualTask = class;
  TOneVirtualManage = class;

  TOneVirtualSet = class
  private
    FAutoWork: boolean;
    FVirtualSetList: TList<TOneVirtualItem>;
  public
    constructor Create();
    destructor Destroy; override;
  public
    property AutoWork: boolean read FAutoWork write FAutoWork;
    property VirtualSetList: TList<TOneVirtualItem> read FVirtualSetList
      write FVirtualSetList;
  end;

  TVirtualInfo = class
  private
    // 虚拟代码
    FVirtualCode: string;
    // 服务端路径文件
    FRemoteFile: string;
    //
    FRemoteFileName: string;
    //
    FLocalFile: string;
    //
    FStreamBase64: string;
    // 错误消息
    FErrMsg: string;
  public
    property VirtualCode: string read FVirtualCode write FVirtualCode;
    property RemoteFile: string read FRemoteFile write FRemoteFile;
    property RemoteFileName: string read FRemoteFileName write FRemoteFileName;
    property LocalFile: string read FLocalFile write FLocalFile;
    /// <param name="StreamBase64">流转化成base64</param>
    property StreamBase64: string read FStreamBase64 write FStreamBase64;
    property ErrMsg: string read FErrMsg write FErrMsg;
  end;

  TVirtualTask = class
  private
    FTaskID: string;
    FFileTotalSize: int64;
    FFileChunSize: int64;
    FFilePosition: int64;
    FVirtualCode: string;
    FRemoteFile: string;
    FLocalFile: string;
    FStreamBase64: string;
    FUpDownMode: string;
    FFileName: string;
    FNewFileName: string;
    FLastTime: TDateTime;
    FErrMsg: string;
    FIsEnd: boolean;
  public
    property TaskID: string read FTaskID write FTaskID;
    property FileTotalSize: int64 read FFileTotalSize write FFileTotalSize;
    property FileChunSize: int64 read FFileChunSize write FFileChunSize;
    property FilePosition: int64 read FFilePosition write FFilePosition;
    property VirtualCode: string read FVirtualCode write FVirtualCode;
    property RemoteFile: string read FRemoteFile write FRemoteFile;
    property LocalFile: string read FLocalFile write FLocalFile;
    property StreamBase64: string read FStreamBase64 write FStreamBase64;
    property UpDownMode: string read FUpDownMode write FUpDownMode;
    property FileName: string read FFileName write FFileName;
    property NewFileName: string read FNewFileName write FNewFileName;
    property ErrMsg: string read FErrMsg write FErrMsg;
    property IsEnd: boolean read FIsEnd write FIsEnd;
  end;

  TOneVirtualItem = class
  private
    FVirtualCode: string;
    FVirtualCaption: string;
    FPhyPath: string;
    FIsEnable: boolean;
    FIsWeb: boolean;
  public
    property VirtualCode: string read FVirtualCode write FVirtualCode;
    property VirtualCaption: string read FVirtualCaption write FVirtualCaption;
    property PhyPath: string read FPhyPath write FPhyPath;
    property IsEnable: boolean read FIsEnable write FIsEnable;
    property IsWeb: boolean read FIsWeb write FIsWeb;
  end;

  TOneVirtualManage = class
  private
    FVirtualList: TDictionary<string, TOneVirtualItem>;
    FVirtualTaskList: TDictionary<string, TVirtualTask>;
    FLockObj: Tobject;
    FLshNo: int64;
    FTimerThread: TOneTimerThread;
  private
    procedure onTimerWork(Sender: Tobject);
  public
    constructor Create();
    destructor Destroy; override;
    procedure StarWork(QSetList: TList<TOneVirtualItem>);
    function GetVirtual(QVirtualCode: string; var QErrMsg: string): TOneVirtualItem;
    function GetVirtualPhy(QVirtualCode: string; var QErrMsg: string): string;
    function CreateNewTask(): TVirtualTask;
    function GetTask(QTaskID: string): TVirtualTask;
    function GetFileLsh(): string;
  public
    property VirtualList: TDictionary<string, TOneVirtualItem> read FVirtualList
      write FVirtualList;
  end;

implementation

uses OneGUID;

constructor TOneVirtualSet.Create();
begin
  inherited Create;
  FVirtualSetList := TList<TOneVirtualItem>.Create;
end;

destructor TOneVirtualSet.Destroy;
var
  i: Integer;
begin
  for i := 0 to FVirtualSetList.Count - 1 do
  begin
    FVirtualSetList[i].Free;
  end;
  FVirtualSetList.Clear;
  FVirtualSetList.Free;
  inherited Destroy;
end;

constructor TOneVirtualManage.Create();
begin
  inherited Create;
  FVirtualList := TDictionary<string, TOneVirtualItem>.Create;
  FVirtualTaskList := TDictionary<string, TVirtualTask>.Create;
  FLockObj := Tobject.Create;
  FTimerThread := TOneTimerThread.Create(Self.onTimerWork);
  FLshNo := 0;
end;

destructor TOneVirtualManage.Destroy;
var
  i: Integer;
  lVirtualItem: TOneVirtualItem;
  lVirtualTask: TVirtualTask;
begin
  // 要先停止写
  if FTimerThread <> nil then
    FTimerThread.FreeWork;
  for lVirtualItem in FVirtualList.Values do
  begin
    lVirtualItem.Free;
  end;
  FVirtualList.Clear;
  FVirtualList.Free;
  for lVirtualTask in FVirtualTaskList.Values do
  begin
    lVirtualTask.Free;
  end;
  FVirtualTaskList.Clear;
  FVirtualTaskList.Free;
  FLockObj.Free;

  inherited Destroy;
end;

procedure TOneVirtualManage.onTimerWork(Sender: Tobject);
var
  lVirtualTask: TVirtualTask;
  lNow: TDateTime;
begin
  lNow := now;
  // 太久没交互的东东,直接踢除任务系统
  TMonitor.Enter(Self.FLockObj);
  try
    for lVirtualTask in FVirtualTaskList.Values do
    begin
      if SecondsBetween(lNow, lVirtualTask.FLastTime) > 30 * 60 then
      begin
        FVirtualTaskList.Remove(lVirtualTask.TaskID);
        lVirtualTask.Free;
      end;
    end;
  finally
    TMonitor.Exit(Self.FLockObj);
  end;
end;

procedure TOneVirtualManage.StarWork(QSetList: TList<TOneVirtualItem>);
var
  i: Integer;
  lVirtualItem: TOneVirtualItem;
  lKey: string;
begin
  for lVirtualItem in FVirtualList.Values do
  begin
    lVirtualItem.Free;
  end;
  FVirtualList.Clear;
  for i := 0 to QSetList.Count - 1 do
  begin
    lKey := QSetList[i].FVirtualCode.ToLower;
    if FVirtualList.ContainsKey(lKey) then
    begin
      continue;
    end;
    lVirtualItem := TOneVirtualItem.Create;
    lVirtualItem.FVirtualCode := QSetList[i].FVirtualCode;
    lVirtualItem.FVirtualCaption := QSetList[i].FVirtualCaption;
    lVirtualItem.FPhyPath := QSetList[i].FPhyPath;
    lVirtualItem.FIsEnable := QSetList[i].FIsEnable;
    lVirtualItem.FIsWeb := QSetList[i].FIsWeb;
    FVirtualList.Add(lKey, lVirtualItem);
  end;
  FTimerThread.StartWork;
end;

function TOneVirtualManage.GetVirtual(QVirtualCode: string; var QErrMsg: string): TOneVirtualItem;
var
  lVirtualItem: TOneVirtualItem;
  lKey: string;
begin
  Result := nil;
  QErrMsg := '';
  lKey := QVirtualCode.ToLower;
  lVirtualItem := nil;
  if not FVirtualList.TryGetValue(lKey, lVirtualItem) then
  begin
    QErrMsg := '不存在此虚拟路径代码[' + QVirtualCode + ']请检查';
    Exit;
  end;
  if not lVirtualItem.FIsEnable then
  begin
    QErrMsg := '虚拟路径代码[' + QVirtualCode + ']已禁用';
    Exit;
  end;
  if lVirtualItem.FPhyPath = '' then
  begin
    QErrMsg := '虚拟路径代码[' + QVirtualCode + ']对应的实际物理地址为空';
    Exit;
  end;
  Result := lVirtualItem;
end;

function TOneVirtualManage.GetVirtualPhy(QVirtualCode: string; var QErrMsg: string): string;
var
  lVirtualItem: TOneVirtualItem;
  lKey: string;
begin
  Result := '';
  QErrMsg := '';
  lKey := QVirtualCode.ToLower;
  lVirtualItem := nil;
  if not FVirtualList.TryGetValue(lKey, lVirtualItem) then
  begin
    QErrMsg := '不存在此虚拟路径代码[' + QVirtualCode + ']请检查';
    Exit;
  end;
  if not lVirtualItem.FIsEnable then
  begin
    QErrMsg := '虚拟路径代码[' + QVirtualCode + ']已禁用';
    Exit;
  end;
  if lVirtualItem.FPhyPath = '' then
  begin
    QErrMsg := '虚拟路径代码[' + QVirtualCode + ']对应的实际物理地址为空';
    Exit;
  end;
  Result := lVirtualItem.FPhyPath;
end;

function TOneVirtualManage.GetFileLsh(): string;
var
  lLsh: string;
begin
  TMonitor.Enter(Self.FLockObj);
  try
    lLsh := Self.FLshNo.ToString();
    while lLsh.Length < 4 do
    begin
      lLsh := '0' + lLsh;
    end;
    Result := FormatDateTime('yyyymmddhhmmsszzz', now) + lLsh;
  finally
    TMonitor.Exit(Self.FLockObj);
  end;
end;

function TOneVirtualManage.CreateNewTask(): TVirtualTask;
var
  lTask: TVirtualTask;
begin
  Result := nil;
  lTask := TVirtualTask.Create;
  lTask.FTaskID := OneGUID.GetGUID32();
  lTask.FLastTime := now;
  FVirtualTaskList.Add(lTask.FTaskID, lTask);
  Result := lTask;
end;

function TOneVirtualManage.GetTask(QTaskID: string): TVirtualTask;
var
  lVirtualTask: TVirtualTask;
begin
  Result := nil;
  lVirtualTask := nil;
  TMonitor.Enter(Self.FLockObj);
  try
    if FVirtualTaskList.TryGetValue(QTaskID, lVirtualTask) then
    begin
      lVirtualTask.FLastTime := now;
      Result := lVirtualTask;
    end;
  finally
    TMonitor.Exit(Self.FLockObj);
  end;
end;

end.

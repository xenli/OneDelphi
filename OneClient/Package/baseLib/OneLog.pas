unit OneLog;

interface

uses
  Winapi.Windows, Winapi.Messages, system.SysUtils, system.Variants,
  system.Classes, system.DateUtils, system.Generics.Collections, OneThread,
  OneILog;

type
  { 日记级别--All监听所有,OFF关闭所有 }
  TELogLevel = (DEBUG, INFO, WARN, ERROR, ALL, OFF);
  { 按分分文件记录,按小时分文件记录,按天分文件记录,按年分文件记录,一般是hour,day }
  TELogIntervalLevel = (Minute, hour, Day, Month);
  TLogCallBack = procedure(const QMsg: string) of object;

type
  // 日记配置
  TOneLogSet = class
  private
    FHTTPLog: boolean;
    FSQLLog: boolean;
    FLogPath: string;
    FLogSec: Integer;
  public
    property HTTPLog: boolean read FHTTPLog write FHTTPLog;
    property SQLLog: boolean read FSQLLog write FSQLLog;
    property LogPath: string read FLogPath write FLogPath;
    property LogSec: Integer read FLogSec write FLogSec;
  end;

  TOneLogItem = class(TObject)
  private
    FS: TFileStream;
    FCurFileName: string;
    FFileName: string;
    FBegCount: DWord;
    FBuffA, FBuffB: TMemoryStream;
    FCSLock: TObject;
    FCSFileNameLock: TObject;
    FLogBuff: TMemoryStream;
    { 监听级别 }
    FLogListenLevel: TELogLevel;
    { 记录级别 }
    FLogIntervalLevel: TELogIntervalLevel;
    { 记录间隔 }
    FLogInterval: Integer;
    { 写入到文件频率 }
    FWriteLastTime: TDateTime;
    { 保存的路径 }
    FLogPath: string;
    { 输出 }
    procedure WriteToFile();
    procedure setLogFileName(const Value: string);
  public
    constructor Create(QLogPath: string); overload;
    destructor Destroy(); override;
    procedure WriteLog_(const QMsg: string);
    procedure WriteLog(const QMsg: string);
    Procedure WriteDebug(const QMsg: string);
    procedure WriteERROR(const QMsg: string);
    procedure WriteWARN(const QMsg: string);
  public
    property FileName: string read FFileName write setLogFileName;
    property LogListenLevel: TELogLevel read FLogListenLevel
      write FLogListenLevel;
    property LogIntervalLevel: TELogIntervalLevel read FLogIntervalLevel
      write FLogIntervalLevel;
    property LogInterval: Integer read FLogInterval write FLogInterval;
  end;

type
  TOneLog = class(TInterfacedObject, IOneLog)
  private
    FLogPath: string;
    FMsgCode: string;
    FLogTimer: TOneTimerThread;
    { 公共日记下入 }
    FLogItemList: TDictionary<string, TOneLogItem>;
    FLogItemPublic: TOneLogItem;
    FIsOut: boolean;
    FCallBack: TLogCallBack;
    FLogItemLock: TObject;
    //
    FLogSet: TOneLogSet;
  private
    procedure SetMsgCode(QMsgCode: string);
    function GetMsgCode: string; stdcall;
    procedure onEvenWork(Sender: TObject);
    function getLogItem(QLogCode: string): TOneLogItem;
  public
    constructor Create(QLogSet: TOneLogSet); overload;
    destructor Destroy; override;
  public
    Procedure WriteDebug(const QMsg: string);
    procedure WriteLog(const QMsg: string); overload;
    procedure WriteLog(QLogCode: string; const QMsg: string); overload;
    // 写入日记到 专门SQL日记
    procedure WriteSQLLog(const QMsg: string);
    // 写入日记到专门 HTTP日记
    procedure WriteHTTPLog(const QMsg: string);
    function IsSQLLog(): boolean;
    function IsHTTPLog(): boolean;
    procedure StarWork;
    procedure StopWork;
  public
    property IsOut: boolean read FIsOut write FIsOut;
    property CallBack: TLogCallBack read FCallBack write FCallBack;
    property LogPath: string read FLogPath;
  end;

implementation

uses OneFileHelper;

// TOneLogItem
constructor TOneLogItem.Create(QLogPath: string);
begin
  inherited Create;
  FCSLock := TObject.Create;
  FCSFileNameLock := TObject.Create;
  FCurFileName := '';
  FFileName := '';
  FLogPath := QLogPath;
  FLogInterval := 1;
  FS := nil;
  // 队列缓冲区A,B运行的时候，交替使用
  Self.FBuffA := TMemoryStream.Create();
  // Self.FBuffA.Size := 1024 * 1024; //初始值可以根据需要自行调整
  Self.FBuffB := TMemoryStream.Create();
  // Self.FBuffB.Size := 1024 * 1024; //初始值可以根据需要自行调整
  Self.FLogBuff := Self.FBuffA;
  FLogListenLevel := TELogLevel.ALL;
  FLogIntervalLevel := TELogIntervalLevel.Day;
  FWriteLastTime := now;
end;

destructor TOneLogItem.Destroy;
begin
  FCSLock.Free;
  FCSFileNameLock.Free;
  FBuffA.Clear;
  FBuffA.Free();
  FBuffB.Clear;
  FBuffB.Free();
  if FS <> nil then
    FS.Free();
  inherited;
end;

procedure TOneLogItem.setLogFileName(const Value: string);
begin
  FFileName := Value;
end;

procedure TOneLogItem.WriteLog(const QMsg: string);
begin
  if FLogListenLevel in [TELogLevel.INFO, TELogLevel.ALL] then
  begin
    WriteLog_(QMsg);
  end;
end;

Procedure TOneLogItem.WriteDebug(const QMsg: string);
begin
  if DebugHook = 1 then
  BEGIN
    WriteLog_(QMsg);
  END;
end;

procedure TOneLogItem.WriteERROR(const QMsg: string);
begin
  if FLogListenLevel in [TELogLevel.ERROR, TELogLevel.ALL] then
  begin
    WriteLog_(QMsg);
  end;
end;

procedure TOneLogItem.WriteWARN(const QMsg: string);
begin
  if FLogListenLevel in [TELogLevel.WARN, TELogLevel.ALL] then
  begin
    WriteLog_(QMsg);
  end;
end;

procedure TOneLogItem.WriteLog_(const QMsg: string);
var
  SourceString: string;
  bytes: TBytes;
begin
  TMonitor.Enter(FCSLock);
  try
    SourceString := QMsg;
    if Length(SourceString) > 0 then
    begin
      SourceString := FormatDateTime('yyyy-mm-dd hh:mm:ss zzz', now()) + '->' +
        QMsg + #13#10;
      bytes := TEncoding.UTF8.GetBytes(SourceString);
      FLogBuff.WriteBuffer(bytes, Length(bytes));
    end;
  finally
    TMonitor.Exit(FCSLock);
  end;
end;

procedure TOneLogItem.WriteToFile;
var
  MS: TMemoryStream;
  IsLogFileNameChanged: boolean;
  vTempFileName: string;
  vData: TDateTime;
  vMinute, vHour, vDay, vYear: Word;
  vbuff: TBytes;
  TmpStr: string;
  vFileHandle: TextFile;
  lNewFileName: string;
begin
  TMonitor.Enter(FCSLock);
  // 交换缓冲区
  try
    MS := nil;
    if FLogBuff.Position > 0 then
    begin
      MS := FLogBuff;
      if FLogBuff = FBuffA then
      begin
        FLogBuff := FBuffB;
      end
      else
      begin
        FLogBuff := FBuffA;
      end;
      FLogBuff.Position := 0;
    end;
  finally
    TMonitor.Exit(FCSLock);
  end;
  // \\
  if MS = nil then
    Exit;

  vTempFileName := '';
  if FLogInterval >= 1 then
  begin
    vData := now;
    case FLogIntervalLevel of
      Minute:
        if MinutesBetween(FWriteLastTime, vData) >= FLogInterval then
        begin
          vTempFileName := FormatDateTime('yyyymmddhhmm', vData);
          FWriteLastTime := vData;
        end;
      hour:
        if HoursBetween(FWriteLastTime, vData) >= FLogInterval then
        begin
          vTempFileName := FormatDateTime('yyyymmddhh', vData);
          FWriteLastTime := vData;
        end;
      Day:
        if DaysBetween(FWriteLastTime, vData) >= FLogInterval then
        begin
          vTempFileName := FormatDateTime('yyyymmdd', vData);
          FWriteLastTime := vData;
        end;
      Month:
        if YearsBetween(FWriteLastTime, vData) >= FLogInterval then
        begin
          vTempFileName := FormatDateTime('yyyymm', vData);
          FWriteLastTime := vData;
        end;
    end;
  end;
  // 检测文件名称是否变化
  if vTempFileName = '' then
  begin
    vTempFileName := FormatDateTime('yyyymmdd', now);
  end;
  if FFileName = '' then
  begin
    FFileName := vTempFileName;
  end
  else
  begin
    // 日期在前
    vTempFileName := vTempFileName + '_' + FFileName;
  end;
  vTempFileName := FLogPath + vTempFileName + '.txt';

  TMonitor.Enter(FCSFileNameLock);
  try
    IsLogFileNameChanged := (FCurFileName <> vTempFileName);
  finally
    TMonitor.Exit(FCSFileNameLock);
  end;

  // 日志文件名称修改了
  if IsLogFileNameChanged then
  begin
    FCurFileName := vTempFileName;
    if FS <> nil then
      FS.Free();
    if FileExists(vTempFileName) then
    begin
      FS := TFileStream.Create(vTempFileName, fmOpenWrite or fmShareDenyWrite);
      FS.Position := FS.Size;
    end
    else
      FS := TFileStream.Create(vTempFileName, fmCreate or fmShareDenyWrite);
  end;
  // 文件大于等于20M自动切割，日记  FS.Position/(1024*1024)>=20
  // 分成几大块
  if FS.Position / (1024 * 1024) >= 20 then
  begin
    FS.Free;
    lNewFileName := FCurFileName + '.' + FormatDateTime('hhnnss', vData);
    // 把文件名进行更改,重新创建一个新的文件名
    RenameFile(FCurFileName, lNewFileName);
    FS := TFileStream.Create(vTempFileName, fmCreate or fmShareDenyWrite);
    FS.Position := FS.Size;
  end;

  // 写入文件
  try
    FS.Write(MS.Memory^, MS.Size)
  finally
    MS.Clear;
    MS.Position := 0;
  end;
end;

constructor TOneLog.Create(QLogSet: TOneLogSet);
begin
  inherited Create;
  if QLogSet = nil then
    QLogSet := TOneLogSet.Create;
  Self.FLogSet := QLogSet;
  if Self.FLogSet.LogPath = '' then
  begin
    FLogPath := OneFileHelper.CombineExeRunPath('OnePlatform')
  end
  else
  begin
    FLogPath := Self.FLogSet.LogPath;
    if FLogPath.EndsWith('\') then
    begin
      FLogPath := FLogPath.Substring(0, Length(FLogPath) - 1);
    end;
  end;
  FLogPath := FLogPath + '\OneLogs';
  if not DirectoryExists(FLogPath) then
    CreateDir(FLogPath);
  FIsOut := False;
  FCallBack := nil;
  FLogItemList := TDictionary<string, TOneLogItem>.Create;
  // 公共日记
  FLogItemPublic := TOneLogItem.Create(FLogPath + '\');
  FLogItemPublic.FileName := 'public';
  FLogItemList.Add(FLogItemPublic.FileName, FLogItemPublic);
  FLogTimer := TOneTimerThread.Create(Self.onEvenWork);
  // 5秒写入一次
  if Self.FLogSet.FLogSec <= 0 then
    Self.FLogSet.FLogSec := 5;
  FLogTimer.IntervalSec := Self.FLogSet.FLogSec;
  FLogItemLock := TObject.Create;
end;

destructor TOneLog.Destroy;
var
  lOneLogItem: TOneLogItem;
begin
  // 要先停止写
  if FLogTimer <> nil then
    FLogTimer.FreeWork;
  if FLogItemList <> nil then
  begin
    for lOneLogItem in FLogItemList.Values do
    begin
      lOneLogItem.Free;
    end;
    FLogItemList.Clear;
    FLogItemList.Free;
  end;
  //
  FCallBack := nil;
  if FLogItemLock <> nil then
    FLogItemLock.Free;
  if Self.FLogSet <> nil then
    Self.FLogSet.Free;
  inherited Destroy;
end;

procedure TOneLog.SetMsgCode(QMsgCode: string);
begin
  FMsgCode := QMsgCode;
end;

function TOneLog.GetMsgCode: string;
begin
  Result := FMsgCode;
end;

procedure TOneLog.onEvenWork(Sender: TObject);
var
  lOneLogItem: TOneLogItem;
begin
  // 由总线程去写，减少线程压力
  for lOneLogItem in FLogItemList.Values do
  begin
    lOneLogItem.WriteToFile;
  end;
end;

Procedure TOneLog.WriteDebug(const QMsg: string);
var
  lOneLogItem: TOneLogItem;
begin
  if not FLogTimer.bWork then
  begin
    if Assigned(FCallBack) then
    begin
      // 回调写法不堵线程
      FCallBack('日记未启动,请调用TOneLog.Star');
    end;
    Exit;
  end;
  lOneLogItem := Self.getLogItem('Debug');
  if lOneLogItem = nil then
  begin
    lOneLogItem := FLogItemPublic;
  end;
  lOneLogItem.WriteDebug(QMsg);
  if FIsOut then
  begin
    if Assigned(FCallBack) then
    begin
      // 回调写法不堵线程
      FCallBack(QMsg);
    end;
  end;
end;

procedure TOneLog.WriteLog(const QMsg: string);
begin
  if not FLogTimer.bWork then
  begin
    if Assigned(FCallBack) then
    begin
      // 回调写法不堵线程
      FCallBack('日记未启动,请调用TOneLog.Star');
    end;
    Exit;
  end;
  FLogItemPublic.WriteLog(QMsg);
  if FIsOut then
  begin
    if Assigned(FCallBack) then
    begin
      // 回调写法不堵线程
      FCallBack(QMsg);
    end;
  end;
end;

function TOneLog.getLogItem(QLogCode: string): TOneLogItem;
var
  lOneLogItem: TOneLogItem;
begin
  Result := nil;
  TMonitor.Enter(FLogItemLock);
  try
    if FLogItemList.TryGetValue(QLogCode.ToLower, lOneLogItem) then
    begin
      Result := lOneLogItem;
    end
    else
    begin
      lOneLogItem := TOneLogItem.Create(FLogPath + '\');
      lOneLogItem.FileName := QLogCode.ToLower;
      FLogItemList.Add(lOneLogItem.FileName, lOneLogItem);
      Result := lOneLogItem;
    end;
  finally
    TMonitor.Exit(FLogItemLock);
  end;
end;

procedure TOneLog.WriteLog(QLogCode: string; const QMsg: string);
var
  lOneLogItem: TOneLogItem;
begin
  if not FLogTimer.bWork then
  begin
    if Assigned(FCallBack) then
    begin
      // 回调写法不堵线程
      FCallBack('日记未启动,请调用TOneLog.Star');
    end;
    Exit;
  end;
  lOneLogItem := Self.getLogItem(QLogCode);
  if lOneLogItem = nil then
  begin
    lOneLogItem := FLogItemPublic;
  end;
  lOneLogItem.WriteLog(QMsg);
  if FIsOut then
  begin
    if Assigned(FCallBack) then
    begin
      // 回调写法不堵线程
      FCallBack(QMsg);
    end;
  end;
end;

function TOneLog.IsSQLLog(): boolean;
begin
  Result := Self.FLogSet.FSQLLog;
end;

function TOneLog.IsHTTPLog(): boolean;
begin
  Result := Self.FLogSet.FHTTPLog;
end;

// 写入日记到 专门SQL日记
procedure TOneLog.WriteSQLLog(const QMsg: string);
begin
  if Self.FLogSet.FSQLLog then
  begin
    Self.WriteLog('SQL', QMsg);
  end;
end;

// 写入日记到专门 HTTP日记
procedure TOneLog.WriteHTTPLog(const QMsg: string);
begin
  if Self.FLogSet.FHTTPLog then
  begin
    Self.WriteLog('HTTP', QMsg);
  end;
end;

procedure TOneLog.StarWork;
begin
  // 开始启动线程写日记
  FLogTimer.StartWork;
end;

procedure TOneLog.StopWork;
begin
  FLogTimer.StopWork;
  // Self.Free;
end;

end.

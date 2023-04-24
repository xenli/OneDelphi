unit OneFastUpdateManage;

{ 更新功能 }
interface

uses
  system.Generics.Collections, system.Classes, system.StrUtils, system.IOUtils,
  system.SysUtils;

type
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
    FUpdateCode: string; // 更新代码
    FUpdateVersion: string; // 如 1.0.1, 1.1.1,2.1.1
    FUpdateTime: string; // 更新时间
    FUpdatePath: string;
    FUpdateFiles: TList<TOneFastUpdateFile>; // 更新文件信息
  public
    constructor Create(QUpdateCode: string; QPath: string);
    destructor Destroy; override;
    function GetUpdateList(var QErrMsg: string): boolean;
    function GetFileFullName(QFileName: string): string;
  published
    property UpdateCode: string read FUpdateCode write FUpdateCode;
    property UpdateVersion: string read FUpdateVersion write FUpdateVersion;
    property UpdateTime: string read FUpdateTime write FUpdateTime;
    property UpdateFiles: TList<TOneFastUpdateFile> read FUpdateFiles write FUpdateFiles;
  end;

  TOneFastUpdateManage = class
  private
    // 更新列表
    FUpdatePath: string;
    FUpdateSetDic: TDictionary<string, TOneFastUpdateSet>;
  public
    constructor Create;
    destructor Destroy; override;
    function RefreshUpdateSet(QUpdateCode: string): boolean;
    function GetUpdateSet(QUpdateCode: string; var QErrMsg: string): TOneFastUpdateSet;
  end;

function UnitFastUpdateManage(): TOneFastUpdateManage;

implementation

uses
  OneNeonHelper, OneFileHelper;

var
  Unit_FastUpdateManage: TOneFastUpdateManage = nil;

function UnitFastUpdateManage(): TOneFastUpdateManage;
begin
  if Unit_FastUpdateManage = nil then
  begin
    Unit_FastUpdateManage := TOneFastUpdateManage.Create;
  end;
  Result := Unit_FastUpdateManage;
end;

constructor TOneFastUpdateSet.Create(QUpdateCode: string; QPath: string);
begin
  inherited Create;
  self.FUpdateCode := QUpdateCode;
  self.FUpdatePath := OneFileHelper.CombinePath(QPath, QUpdateCode);
  FUpdateFiles := TList<TOneFastUpdateFile>.Create;
end;

destructor TOneFastUpdateSet.Destroy;
var
  i: Integer;
begin
  for i := 0 to FUpdateFiles.Count - 1 do
  begin
    FUpdateFiles[i].Free;
  end;
  FUpdateFiles.Clear;
  FUpdateFiles.Free;
  inherited Destroy;
end;

function TOneFastUpdateSet.GetUpdateList(var QErrMsg: string): boolean;
var
  i: Integer;
  lSetFileName, lFileName: string;
  lErrMsg: string;
  lUpdateFile: TOneFastUpdateFile;
  lFileStream: TFileStream;
begin
  for i := 0 to FUpdateFiles.Count - 1 do
  begin
    FUpdateFiles[i].Free;
  end;
  FUpdateFiles.Clear;
  // 增加
  lSetFileName := OneFileHelper.CombinePath(self.FUpdatePath, self.FUpdateCode + '.json');
  OneNeonHelper.JSONToObjectFormFile(self, lSetFileName, lErrMsg);
  if FUpdateFiles.Count = 0 then
  begin
    lUpdateFile := TOneFastUpdateFile.Create;
    FUpdateFiles.Add(lUpdateFile);
    lUpdateFile.FFileName := '系统生成格式.exe';
    lUpdateFile.FFileClientPath := '';
    lUpdateFile.FFileSize := 0;
  end;
  // 读取文件大小
  for i := 0 to FUpdateFiles.Count - 1 do
  begin
    lUpdateFile := FUpdateFiles[i];
    if lUpdateFile.FFileName.ToLower = '系统生成格式.exe' then
      continue;
    // 读取文件大小
    lFileName := OneFileHelper.CombinePath(self.FUpdatePath, lUpdateFile.FFileName);
    if TFile.Exists(lFileName) then
    begin
      lFileStream := TFileStream.Create(lFileName, fmOpenRead);
      try
        lFileStream.Position := 0;
        lUpdateFile.FFileSize := lFileStream.Size;
      finally
        lFileStream.Free;
      end;
    end;
  end;
  // 保存配置
  OneNeonHelper.ObjectToJsonFile(self, lSetFileName, lErrMsg);
  // 删除掉系统生成JSON格式数据.EXE
  for i := FUpdateFiles.Count - 1 downto 0 do
  begin
    lUpdateFile := FUpdateFiles[i];
    if lUpdateFile.FFileName.ToLower = '系统生成格式.exe' then
    begin
      lUpdateFile.Free;
      FUpdateFiles.Delete(i);
    end;
  end;
end;

function TOneFastUpdateSet.GetFileFullName(QFileName: string): string;
begin
  Result := OneFileHelper.CombinePath(self.FUpdatePath, QFileName);
end;

constructor TOneFastUpdateManage.Create;
var
  lErrMsg: string;
  lExePath: string;
begin
  inherited Create;
  FUpdateSetDic := TDictionary<string, TOneFastUpdateSet>.Create;
  lExePath := OneFileHelper.GetExeRunPath();
  self.FUpdatePath := OneFileHelper.CombinePathC(lExePath, 'OnePlatform', 'OneFastUpload');
end;

destructor TOneFastUpdateManage.Destroy;
var
  i: Integer;
  lUpdateSet: TOneFastUpdateSet;
begin
  for lUpdateSet in FUpdateSetDic.Values do
  begin
    lUpdateSet.Free;
  end;
  FUpdateSetDic.Clear;
  FUpdateSetDic.Free;
  inherited Destroy;
end;

function TOneFastUpdateManage.RefreshUpdateSet(QUpdateCode: string): boolean;
var
  i: Integer;
  lUpdateSet: TOneFastUpdateSet;
begin

  Result := false;
  lUpdateSet := nil;
  QUpdateCode := QUpdateCode.ToLower;
  if FUpdateSetDic.ContainsKey(QUpdateCode) then
  begin
    FUpdateSetDic.TryGetValue(QUpdateCode, lUpdateSet);
    if lUpdateSet <> nil then
      lUpdateSet.Free;
    FUpdateSetDic.Remove(QUpdateCode);
  end;
  Result := true;
end;

function TOneFastUpdateManage.GetUpdateSet(QUpdateCode: string; var QErrMsg: string): TOneFastUpdateSet;
var
  lFastUpdateSet: TOneFastUpdateSet;
  lPath: string;
begin
  Result := nil;
  QErrMsg := '';
  lFastUpdateSet := nil;
  QUpdateCode := QUpdateCode.ToLower;
  TMonitor.Enter(self);
  try
    if FUpdateSetDic.ContainsKey(QUpdateCode) then
    begin
      FUpdateSetDic.TryGetValue(QUpdateCode, lFastUpdateSet);
    end;

    if lFastUpdateSet = nil then
    begin
      FUpdateSetDic.Remove(QUpdateCode);
      // 判断文件存不存在
      lPath := OneFileHelper.CombinePath(self.FUpdatePath, QUpdateCode);
      if not TDirectory.Exists(lPath) then
      begin
        QErrMsg := '升级目录不存在:OnePlatform/OneFastUpload/' + QUpdateCode;
        exit;
      end;
      lFastUpdateSet := TOneFastUpdateSet.Create(QUpdateCode, self.FUpdatePath);
      lFastUpdateSet.GetUpdateList(QErrMsg);
      FUpdateSetDic.Add(QUpdateCode, lFastUpdateSet);
    end;
    Result := lFastUpdateSet;
  finally
    TMonitor.exit(self);
  end;

end;

initialization

finalization

if Unit_FastUpdateManage <> nil then
  Unit_FastUpdateManage.Free;

end.

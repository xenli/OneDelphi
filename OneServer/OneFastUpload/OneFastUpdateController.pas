unit OneFastUpdateController;

interface

uses
  system.StrUtils, system.SysUtils, Math, system.JSON, system.Threading, system.Classes,
  OneHttpController, OneHttpRouterManage, OneHttpCtxtResult, OneTokenManage, OneHttpConst,
  system.Generics.Collections, OneControllerResult, FireDAC.Comp.Client, Data.DB, OneGuID,
  OneFastUpdateManage, system.IOUtils, system.NetEncoding;

type
  TFastUpdateDown = class
  private
    FUpdateCode: string;
    FUpdateVersion: string;
    FFileName: string;
    FFileSize: int64;
    FFilePosition: int64;
    FFileChunkSize: integer;
  published
    property UpdateCode: string read FUpdateCode write FUpdateCode;
    property UpdateVersion: string read FUpdateVersion write FUpdateVersion;
    property FileName: string read FFileName write FFileName;
    property FileSize: int64 read FFileSize write FFileSize;
    property FilePosition: int64 read FFilePosition write FFilePosition;
    property FileChunkSize: integer read FFileChunkSize write FFileChunkSize;
  end;

  TFastUpdateController = class(TOneControllerBase)
  public
    function RefreshUpdateSet(QUpdateCode: string): TActionResult<string>;
    function GetUpdateSet(QUpdateCode: string): TActionResult<TOneFastUpdateSet>;
    function UpdateDownFile(QUpdateDown: TFastUpdateDown): TActionResult<string>;
  end;

implementation

uses OneGlobal, OneFileHelper;

function CreateNewFastUpdateController(QRouterItem: TOneRouterWorkItem): Tobject;
var
  lController: TFastUpdateController;
begin
  // 自定义创建控制器类，否则会按 TPersistentclass.create
  // 最好自定义一个好
  lController := TFastUpdateController.Create;
  // 挂载RTTI信息
  lController.RouterItem := QRouterItem;
  result := lController;
end;

function TFastUpdateController.RefreshUpdateSet(QUpdateCode: string): TActionResult<string>;
begin
  result := TActionResult<string>.Create(false, false);
  if not OneFastUpdateManage.UnitFastUpdateManage().RefreshUpdateSet(QUpdateCode) then
  begin
    result.ResultMsg := '刷新缓存失败';
    exit;
  end;
  result.SetResultTrue();
end;

function TFastUpdateController.GetUpdateSet(QUpdateCode: string): TActionResult<TOneFastUpdateSet>;
var
  lErrMsg: string;
  lFastUpdateSet: TOneFastUpdateSet;
begin
  // 不释放,因为 TOneFastUpdate配置取置Mange管理
  result := TActionResult<TOneFastUpdateSet>.Create(false, false);
  lFastUpdateSet := OneFastUpdateManage.UnitFastUpdateManage().GetUpdateSet(QUpdateCode, lErrMsg);
  if (lFastUpdateSet = nil) or (lErrMsg <> '') then
  begin
    result.ResultMsg := lErrMsg;
    exit;
  end;
  result.ResultData := lFastUpdateSet;
  result.SetResultTrue();
end;

function TFastUpdateController.UpdateDownFile(QUpdateDown: TFastUpdateDown): TActionResult<string>;
var
  lErrMsg: string;
  lFastUpdateSet: TOneFastUpdateSet;
  iFile: integer;
  lUpdateFile: TOneFastUpdateFile;
  //
  lFileName: string;
  lFileStream: TFileStream;
  // lTempStream:TMemoryStream;
  iChunSize: integer;
  lBytes: TBytes;
begin
  result := TActionResult<string>.Create(false, false);
  if QUpdateDown.UpdateCode = '' then
  begin
    result.ResultMsg := '升级代码不可为空';
    exit;
  end;
  if QUpdateDown.FileName = '' then
  begin
    result.ResultMsg := '升级文件名称不可为空';
    exit;
  end;
  if QUpdateDown.FileSize = 0 then
  begin
    result.ResultMsg := '升级文件文件大小为0无法与服务端校验';
    exit;
  end;
  if QUpdateDown.FilePosition < 0 then
  begin
    result.ResultMsg := '升级文件名称文件起始位置小于0';
    exit;
  end;
  if QUpdateDown.FileChunkSize <= 0 then
  begin
    QUpdateDown.FileChunkSize := 1024 * 1024;
  end;

  lFastUpdateSet := OneFastUpdateManage.UnitFastUpdateManage().GetUpdateSet(QUpdateDown.UpdateCode, lErrMsg);
  if (lFastUpdateSet = nil) or (lErrMsg <> '') then
  begin
    result.ResultMsg := lErrMsg;
    exit;
  end;
  // 获取文件
  lUpdateFile := nil;
  for iFile := 0 to lFastUpdateSet.UpdateFiles.Count - 1 do
  begin
    lUpdateFile := lFastUpdateSet.UpdateFiles[iFile];
    if (lUpdateFile.FileName.ToLower = QUpdateDown.FileName.ToLower) and (lUpdateFile.FileSize = QUpdateDown.FileSize) then
    begin
      break;
    end
    else
    begin
      lUpdateFile := nil;
    end;
  end;
  if lUpdateFile = nil then
  begin
    result.ResultMsg := '服务端升级文件已发生变化,请重新升级';
    exit;
  end;
  //
  lFileName := lFastUpdateSet.GetFileFullName(lUpdateFile.FileName);
  if not TFile.Exists(lFileName) then
  begin
    result.ResultMsg := '服务端升级文件[' + lUpdateFile.FileName + ']不存在';
    exit;
  end;

  lFileStream := TFileStream.Create(lFileName, fmOpenRead);
  try
    if lFileStream.Size <> lUpdateFile.FileSize then
    begin
      result.ResultMsg := '服务端升级文件大小已发生变化,请重新升级,当前文件大小:' + lFileStream.Size.ToString;
      exit;
    end;
    iChunSize := QUpdateDown.FileChunkSize;
    lFileStream.Position := QUpdateDown.FilePosition;
    if QUpdateDown.FilePosition + iChunSize > lFileStream.Size then
    begin
      iChunSize := lFileStream.Size - QUpdateDown.FilePosition;
    end;
    if iChunSize <= 0 then
    begin
      result.ResultMsg := '已超过文件最大容量，无需继续请求下载';
      exit;
    end;
    setLength(lBytes, iChunSize);
    lFileStream.Read(lBytes, iChunSize);
    result.ResultData := TNetEncoding.Base64.EncodeBytesToString(lBytes);
    result.SetResultTrue;
  finally
    lFileStream.Free;
  end;
end;

initialization

// 单例模式注册
OneHttpRouterManage.GetInitRouterManage().AddHTTPSingleWork('OneServer/FastUpdate', TFastUpdateController, 0, CreateNewFastUpdateController);

finalization

end.

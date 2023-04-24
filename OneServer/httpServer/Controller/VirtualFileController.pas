unit VirtualFileController;

// 此单元主要对接 oneClient文件上传下载
interface

uses OneHttpController, OneHttpCtxtResult, OneHttpRouterManage, System.SysUtils,
  System.Generics.Collections, System.Contnrs, System.Classes, System.IOUtils, System.NetEncoding,
  FireDAC.Comp.Client, Data.DB, System.JSON, OneControllerResult, System.ZLib, OneVirtualFile;

type

  TOneVirtualFileController = class(TOneControllerBase)
  public
    function UploadFile(QVirtualInfo: TVirtualInfo): TActionResult<string>;
    function DownloadFile(QVirtualInfo: TVirtualInfo): TActionResult<string>;
    function GetTaskID(QVirtualTask: TVirtualTask): TActionResult<TVirtualTask>;
    function UploadChunkFile(QVirtualTask: TVirtualTask): TActionResult<string>;
    function DownloadChunkFile(QVirtualTask: TVirtualTask): TActionResult<string>;
    // 删除文件
    function DeleteFile(QVirtualInfo: TVirtualInfo): TActionResult<string>;
    // 获取文件MD5
    function GetFileMd5(QVirtualInfo: TVirtualInfo): TActionResult<string>;
  end;

function CreateNewVirtualFileController(QRouterItem: TOneRouterWorkItem): TObject;

implementation

uses OneGlobal, OneFileHelper, OneStreamString;

function CreateNewVirtualFileController(QRouterItem: TOneRouterWorkItem): TObject;
var
  lController: TOneVirtualFileController;
begin
  // 自定义创建控制器类，否则会按 TPersistentclass.create
  // 最好自定义一个好
  lController := TOneVirtualFileController.Create;
  // 挂载RTTI信息
  lController.RouterItem := QRouterItem;
  result := lController;
end;

function TOneVirtualFileController.UploadFile(QVirtualInfo: TVirtualInfo): TActionResult<string>;
var
  lOneGlobal: TOneGlobal;
  lErrMsg: string;
  lFileName, lExten, lPath: string;
  lVirtualItem: TOneVirtualItem;
  lInStream: TMemoryStream;
begin
  result := TActionResult<string>.Create(true, false);
  if QVirtualInfo = nil then
  begin
    result.ResultMsg := '传进的参数，无法转化成 TVirtualInfo类';
    exit;
  end;
  if QVirtualInfo.VirtualCode = '' then
  begin
    result.ResultMsg := '虚拟路径代码[VirtualCode]为空,请检查';
    exit;
  end;
  if QVirtualInfo.RemoteFile = '' then
  begin
    result.ResultMsg := '路径文件[RemoteFile]为空,请检查';
    exit;
  end;
  if TPath.DriveExists(QVirtualInfo.RemoteFile) then
  begin
    result.ResultMsg := '路径文件[RemoteFile]不可包含驱动，只能是路径/xxx/xxxx/xx';
    exit;
  end;
  if not TPath.HasExtension(QVirtualInfo.RemoteFile) then
  begin
    result.ResultMsg := '路径文件[RemoteFile]无文件扩展名,无法确这是路径,还是文件完整路径';
    exit;
  end;
  if QVirtualInfo.StreamBase64 = '' then
  begin
    result.ResultMsg := '文件内容[StreamBase64]为空,请检查';
    exit;
  end;
  lFileName := TPath.GetFileName(QVirtualInfo.RemoteFile);
  if lFileName = '' then
  begin
    result.ResultMsg := '要保存的的文件名秒为空,请检查文件路径';
    exit;
  end;
  //
  lOneGlobal := TOneGlobal.GetInstance();
  lVirtualItem := lOneGlobal.VirtualManage.GetVirtual(QVirtualInfo.VirtualCode, lErrMsg);
  if lErrMsg <> '' then
  begin
    result.ResultMsg := lErrMsg;
    exit;
  end;
  // 组装文件路径
  QVirtualInfo.RemoteFile := OneFileHelper.CombinePath(lVirtualItem.PhyPath, QVirtualInfo.RemoteFile);
  lPath := TPath.GetDirectoryName(QVirtualInfo.RemoteFile);
  if not TDirectory.Exists(lPath) then
  begin
    TDirectory.CreateDirectory(lPath);
  end;
  if TFile.Exists(QVirtualInfo.RemoteFile) then
  begin
    // 变个文件名
    lFileName := TPath.GetFileNameWithoutExtension(QVirtualInfo.RemoteFile);
    lExten := TPath.GetExtension(QVirtualInfo.RemoteFile);
    lFileName := lFileName + '_' + lOneGlobal.VirtualManage.GetFileLsh() + lExten;
    QVirtualInfo.RemoteFile := OneFileHelper.CombinePath(lPath, lFileName);
  end;
  // 拼接文件
  lInStream := TMemoryStream.Create;
  try
    // 反写base64到流中
    OneStreamString.StreamWriteBase64Str(lInStream, QVirtualInfo.StreamBase64);
    // 解压流
    lInStream.Position := 0;
    lInStream.SaveToFile(QVirtualInfo.RemoteFile);
  finally
    lInStream.Clear;
    lInStream.Free;
  end;
  // 返回新的文件名给前端
  result.ResultData := lFileName;
  // 返回的是文件
  result.ResultMsg := '保存文件成功';
  result.SetResultTrue();
end;

function TOneVirtualFileController.DownloadFile(QVirtualInfo: TVirtualInfo): TActionResult<string>;
var
  lOneGlobal: TOneGlobal;
  lErrMsg: string;
  lFileName: string;
  lVirtualItem: TOneVirtualItem;
  lFileStream: TFileStream;
begin
  result := TActionResult<string>.Create(true, false);
  if QVirtualInfo = nil then
  begin
    result.ResultMsg := '传进的参数，无法转化成 TVirtualInfo类';
    exit;
  end;
  if QVirtualInfo.VirtualCode = '' then
  begin
    result.ResultMsg := '虚拟路径代码[VirtualCode]为空,请检查';
    exit;
  end;
  if QVirtualInfo.RemoteFile = '' then
  begin
    result.ResultMsg := '路径文件[RemoteFile]为空,请检查';
    exit;
  end;
  if not TPath.HasExtension(QVirtualInfo.RemoteFile) then
  begin
    result.ResultMsg := '路径文件[RemoteFile]无文件扩展名称无法确定是路径还是文件';
    exit;
  end;
  lOneGlobal := TOneGlobal.GetInstance();
  lVirtualItem := lOneGlobal.VirtualManage.GetVirtual(QVirtualInfo.VirtualCode, lErrMsg);
  if lErrMsg <> '' then
  begin
    result.ResultMsg := lErrMsg;
    exit;
  end;
  lFileName := TPath.GetFileName(QVirtualInfo.RemoteFile);
  if lFileName = '' then
  begin
    result.ResultMsg := '文件名称为空,请检查[' + QVirtualInfo.RemoteFile + ']';
    exit;
  end;
  // 拼接文件
  lFileName := OneFileHelper.CombinePath(lVirtualItem.PhyPath, QVirtualInfo.RemoteFile);
  if not FileExists(lFileName) then
  begin
    result.ResultMsg := '服务端文件不存在请检查';
    exit;
  end;
  lFileStream := TFileStream.Create(lFileName, fmopenRead and fmShareDenyRead);
  try
    // 大于10M文件,请用分块下载
    if lFileStream.Size > 1024 * 1024 * 10 then
    begin
      result.ResultMsg := '文件过大超过10M,请用分块下载';
      result.ResultData := 'bigfile';
      exit;
    end;
    lFileStream.Position := 0;
    result.ResultData := OneStreamString.StreamToBase64Str(lFileStream);
    result.SetResultTrue();
  finally
    lFileStream.Free;
  end;
end;

function TOneVirtualFileController.GetTaskID(QVirtualTask: TVirtualTask): TActionResult<TVirtualTask>;
var
  lServerTask, lResultTask: TVirtualTask;
  lOneGlobal: TOneGlobal;
  lVirtualItem: TOneVirtualItem;
  lPath, lFileName, lExten, lNewFileName: string;
  lErrMsg: string;
  lFileStream: TFileStream;
begin
  result := TActionResult<TVirtualTask>.Create(true, false);
  if (QVirtualTask.UpDownMode <> '上传') and (QVirtualTask.UpDownMode <> '下载') then
  begin
    result.ResultMsg := '文件模式[UpDownMode]只能是上传或下载';
    exit;
  end;
  if QVirtualTask.VirtualCode = '' then
  begin
    result.ResultMsg := '虚拟路径代码[VirtualCode]为空,请检查';
    exit;
  end;
  if QVirtualTask.RemoteFile = '' then
  begin
    result.ResultMsg := '路径文件[RemoteFile]为空,请检查';
    exit;
  end;
  if TPath.DriveExists(QVirtualTask.RemoteFile) then
  begin
    result.ResultMsg := '路径文件[RemoteFile]不可包含驱动，只能是路径/xxx/xxxx/xx';
    exit;
  end;
  if not TPath.HasExtension(QVirtualTask.RemoteFile) then
  begin
    result.ResultMsg := '路径文件[RemoteFile]无文件扩展名,无法确这是路径,还是文件完整路径';
    exit;
  end;
  lFileName := TPath.GetFileName(QVirtualTask.RemoteFile);
  if lFileName = '' then
  begin
    result.ResultMsg := '路径文件[RemoteFile]无法取到相关文件名';
    exit;
  end;
  // 组装真实路径
  lOneGlobal := TOneGlobal.GetInstance();
  lVirtualItem := lOneGlobal.VirtualManage.GetVirtual(QVirtualTask.VirtualCode, lErrMsg);
  if lErrMsg <> '' then
  begin
    result.ResultMsg := lErrMsg;
    exit;
  end;
  QVirtualTask.RemoteFile := OneFileHelper.CombinePath(lVirtualItem.PhyPath, QVirtualTask.RemoteFile);
  // 上传特有
  if (QVirtualTask.UpDownMode = '上传') then
  begin

    lPath := TPath.GetDirectoryName(QVirtualTask.RemoteFile);
    if not TDirectory.Exists(lPath) then
    begin
      TDirectory.CreateDirectory(lPath);
    end;
    if TFile.Exists(QVirtualTask.RemoteFile) then
    begin
      // 变个文件名
      lNewFileName := TPath.GetFileNameWithoutExtension(QVirtualTask.RemoteFile);
      lExten := TPath.GetExtension(QVirtualTask.RemoteFile);
      lNewFileName := lNewFileName + '_' + lOneGlobal.VirtualManage.GetFileLsh() + lExten;
      QVirtualTask.RemoteFile := OneFileHelper.CombinePath(lPath, lNewFileName);
    end;
  end
  else if (QVirtualTask.UpDownMode = '下载') then
  begin
    if not FileExists(QVirtualTask.RemoteFile) then
    begin
      result.ResultMsg := '服务端文件不存在请检查';
      exit;
    end;
    lFileStream := TFileStream.Create(QVirtualTask.RemoteFile, fmShareDenyNone);
    try
      QVirtualTask.FileTotalSize := lFileStream.Size;
    finally
      lFileStream.Free;
    end;
  end;
  if lNewFileName = '' then
    lNewFileName := lFileName;
  lOneGlobal := TOneGlobal.GetInstance();
  lServerTask := lOneGlobal.VirtualManage.CreateNewTask();
  // 下载有这个值
  lServerTask.FileTotalSize := QVirtualTask.FileTotalSize;
  lServerTask.FilePosition := 0;
  lServerTask.VirtualCode := QVirtualTask.VirtualCode;
  lServerTask.RemoteFile := QVirtualTask.RemoteFile;
  lServerTask.StreamBase64 := '';
  lServerTask.UpDownMode := QVirtualTask.UpDownMode;
  lServerTask.FileName := lFileName;
  lServerTask.NewFileName := lNewFileName;
  lServerTask.LocalFile := QVirtualTask.LocalFile;
  // 返回这三个信息就够了
  lResultTask := TVirtualTask.Create;
  lResultTask.TaskID := lServerTask.TaskID;
  lResultTask.FileTotalSize := QVirtualTask.FileTotalSize;
  lResultTask.NewFileName := lNewFileName;
  result.ResultData := lResultTask;
  result.SetResultTrue();
end;

function TOneVirtualFileController.UploadChunkFile(QVirtualTask: TVirtualTask): TActionResult<string>;
var
  lTask: TVirtualTask;
  lOneGlobal: TOneGlobal;
  lFileStream: TFileStream;
  lInStream: TMemoryStream;
  // lBytes: TBytes;
begin
  result := TActionResult<string>.Create(false, false);
  if QVirtualTask.TaskID = '' then
  begin
    result.ResultMsg := '上传任务taskID为空,请先申请一个taskID';
    exit;
  end;
  lOneGlobal := TOneGlobal.GetInstance();
  lTask := lOneGlobal.VirtualManage.GetTask(QVirtualTask.TaskID);
  if lTask = nil then
  begin
    result.ResultMsg := '任务已不存在,请检查任务ID';
    exit;
  end;
  // 第一次需要上传相关信息
  if QVirtualTask.StreamBase64 = '' then
  begin
    result.ResultMsg := '文件内容[StreamBase64]为空,请检查';
    exit;
  end;
  //
  lInStream := TMemoryStream.Create;
  if TFile.Exists(lTask.RemoteFile) then
  begin
    lFileStream := TFileStream.Create(lTask.RemoteFile, fmOpenReadWrite or fmShareCompat);
  end
  else
  begin
    lFileStream := TFileStream.Create(lTask.RemoteFile, fmcreate);
  end;
  try
    OneStreamString.StreamWriteBase64Str(lInStream, QVirtualTask.StreamBase64);
    lInStream.Position := 0;
    // setLength(lBytes, lInStream.Size);
    // lInStream.Read(lBytes, lInStream.Size);
    lFileStream.Position := QVirtualTask.FilePosition;
    // lFileStream.Write(lBytes, lInStream.Size);
    lFileStream.CopyFrom(lInStream, lInStream.Size);
    lTask.FilePosition := QVirtualTask.FilePosition;
    if lTask.FilePosition + lInStream.Size >= lTask.FileTotalSize then
    begin
      lTask.FilePosition := lTask.FilePosition + lInStream.Size;
      lTask.IsEnd := true;
    end;
    result.SetResultTrue;
  finally
    lFileStream.Free;
    lInStream.Free;
  end;
end;

function TOneVirtualFileController.DownloadChunkFile(QVirtualTask: TVirtualTask): TActionResult<string>;
var
  lTask: TVirtualTask;
  lOneGlobal: TOneGlobal;
  lFileStream: TFileStream;
  lBytes: TBytes;
begin
  result := TActionResult<string>.Create(false, false);
  if QVirtualTask.TaskID = '' then
  begin
    result.ResultMsg := '上传任务taskID为空,请先申请一个taskID';
    exit;
  end;
  lOneGlobal := TOneGlobal.GetInstance();
  lTask := lOneGlobal.VirtualManage.GetTask(QVirtualTask.TaskID);
  if lTask = nil then
  begin
    result.ResultMsg := '任务已不存在,请检查任务ID';
    exit;
  end;
  if QVirtualTask.FileChunSize <= 0 then
    QVirtualTask.FileChunSize := 1024 * 1024 * 1;
  if QVirtualTask.FilePosition >= lTask.FileTotalSize - 1 then
  begin
    result.ResultMsg := '已下载完成';
    result.ResultData := '';
    result.SetResultTrue;
    exit;
  end;
  if QVirtualTask.FilePosition + QVirtualTask.FileChunSize > lTask.FileTotalSize then
  begin
    QVirtualTask.FileChunSize := lTask.FileTotalSize - QVirtualTask.FilePosition;
  end;
  //
  lFileStream := TFileStream.Create(lTask.RemoteFile, fmopenRead);
  try
    lFileStream.Position := QVirtualTask.FilePosition;
    setLength(lBytes, QVirtualTask.FileChunSize);
    lFileStream.Read(lBytes, QVirtualTask.FileChunSize);
    result.ResultData := TNetEncoding.Base64.EncodeBytesToString(lBytes);
    result.SetResultTrue;
  finally
    lFileStream.Free;
  end;
end;

// 删除文件
function TOneVirtualFileController.DeleteFile(QVirtualInfo: TVirtualInfo): TActionResult<string>;
var
  lOneGlobal: TOneGlobal;
  lErrMsg: string;
  lFileName, lExten, lPath: string;
  lVirtualItem: TOneVirtualItem;
begin
  result := TActionResult<string>.Create(true, false);
  if QVirtualInfo = nil then
  begin
    result.ResultMsg := '传进的参数，无法转化成 TVirtualInfo类';
    exit;
  end;
  if QVirtualInfo.VirtualCode = '' then
  begin
    result.ResultMsg := '虚拟路径代码[VirtualCode]为空,请检查';
    exit;
  end;
  if QVirtualInfo.RemoteFile = '' then
  begin
    result.ResultMsg := '路径文件[RemoteFile]为空,请检查';
    exit;
  end;
  if TPath.DriveExists(QVirtualInfo.RemoteFile) then
  begin
    result.ResultMsg := '路径文件[RemoteFile]不可包含驱动，只能是路径/xxx/xxxx/xx';
    exit;
  end;
  if not TPath.HasExtension(QVirtualInfo.RemoteFile) then
  begin
    result.ResultMsg := '路径文件[RemoteFile]无文件扩展名,无法确这是路径,还是文件完整路径';
    exit;
  end;
  lFileName := TPath.GetFileName(QVirtualInfo.RemoteFile);
  if lFileName = '' then
  begin
    result.ResultMsg := '要删除的文件名称为空,请检查文件路径';
    exit;
  end;
  //
  lOneGlobal := TOneGlobal.GetInstance();
  lVirtualItem := lOneGlobal.VirtualManage.GetVirtual(QVirtualInfo.VirtualCode, lErrMsg);
  if lErrMsg <> '' then
  begin
    result.ResultMsg := lErrMsg;
    exit;
  end;
  // 组装文件路径
  QVirtualInfo.RemoteFile := OneFileHelper.CombinePath(lVirtualItem.PhyPath, QVirtualInfo.RemoteFile);
  if TFile.Exists(QVirtualInfo.RemoteFile) then
  begin
    TFile.Delete(QVirtualInfo.RemoteFile)
  end;
  // 返回新的文件名给前端
  result.ResultData := lFileName;
  // 返回的是文件
  result.ResultMsg := '删除文件成功';
  result.SetResultTrue();
end;

// 获取文件MD5
function TOneVirtualFileController.GetFileMd5(QVirtualInfo: TVirtualInfo): TActionResult<string>;
begin

end;

// 注册到路由
initialization

// 注意，路由名称 不要一样，否则会判定已注册过，跳过
// 多例模式注册
OneHttpRouterManage.GetInitRouterManage().AddHTTPSingleWork('OneServer/VirtualFile', TOneVirtualFileController, 0, CreateNewVirtualFileController);

finalization

end.

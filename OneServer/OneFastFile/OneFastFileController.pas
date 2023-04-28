unit OneFastFileController;

interface

uses
  system.StrUtils, system.SysUtils, Math, system.JSON, system.Threading, system.Classes,
  OneHttpController, OneHttpRouterManage, OneHttpCtxtResult, OneTokenManage, OneHttpConst,
  system.Generics.Collections, OneControllerResult, FireDAC.Comp.Client, Data.DB, OneGuID,
  OneMultipart, OneFastFileMange;

type
  TFastFileController = class(TOneControllerBase)
  public
    function RefreshFileSetAll(): TActionResult<string>;
    function RefreshFileSet(QFileSetCode: string): TActionResult<string>;
    function CreateNewTask(QFileTask: TFileTask): TActionResult<TFileTask>;
    function FileDel(QFileTask: TFileTask): TActionResult<string>;
    function FileUpLoad(QUpLoadTask: TFileTask): TActionResult<string>;
    function FileDown(QDownTask: TFileTask): TActionResult<string>;
  end;

implementation

uses OneGlobal;

function CreateNewFastFileController(QRouterItem: TOneRouterWorkItem): Tobject;
var
  lController: TFastFileController;
begin
  // 自定义创建控制器类，否则会按 TPersistentclass.create
  // 最好自定义一个好
  lController := TFastFileController.Create;
  // 挂载RTTI信息
  lController.RouterItem := QRouterItem;
  result := lController;
end;

function TFastFileController.RefreshFileSetAll(): TActionResult<string>;
var
  lErrMsg: string;
begin
  result := TActionResult<string>.Create(false, false);
  if not OneFastFileMange.UnitFileMange().RefreshFileSet('', lErrMsg) then
  begin
    result.ResultMsg := lErrMsg;
    exit;
  end;
  result.SetResultTrue();
end;

function TFastFileController.RefreshFileSet(QFileSetCode: string): TActionResult<string>;
var
  lErrMsg: string;
begin
  result := TActionResult<string>.Create(false, false);
  if not OneFastFileMange.UnitFileMange().RefreshFileSet(QFileSetCode, lErrMsg) then
  begin
    result.ResultMsg := lErrMsg;
    exit;
  end;
  result.SetResultTrue();
end;

function TFastFileController.CreateNewTask(QFileTask: TFileTask): TActionResult<TFileTask>;
var
  lErrMsg: string;
  lFileTask: TFileTask;
begin
  result := TActionResult<TFileTask>.Create(false, false);
  lErrMsg := '';
  lFileTask := OneFastFileMange.UnitFileMange().CreateNewTask(QFileTask, lErrMsg);
  if lErrMsg <> '' then
  begin
    result.ResultMsg := lErrMsg;
    exit;
  end;
  if lFileTask = nil then
  begin
    result.ResultMsg := '未返回任务';
    exit;
  end;
  result.ResultData := lFileTask;
  result.SetResultTrue();
end;

function TFastFileController.FileDel(QFileTask: TFileTask): TActionResult<string>;
var
  lErrMsg: string;
begin
  result := TActionResult<string>.Create(false, false);
  if not OneFastFileMange.UnitFileMange().FileDel(QFileTask, lErrMsg) then
  begin
    result.ResultMsg := lErrMsg;
    exit;
  end;
  result.SetResultTrue();
end;

function TFastFileController.FileUpLoad(QUpLoadTask: TFileTask): TActionResult<string>;
var
  lErrMsg: string;
begin
  result := TActionResult<string>.Create(false, false);
  if not OneFastFileMange.UnitFileMange().FileUpLoad(QUpLoadTask, lErrMsg) then
  begin
    result.ResultMsg := lErrMsg;
    exit;
  end;
  result.SetResultTrue();
end;

function TFastFileController.FileDown(QDownTask: TFileTask): TActionResult<string>;
var
  lErrMsg: string;
begin
  result := TActionResult<string>.Create(false, false);
  if not OneFastFileMange.UnitFileMange().FileDown(QDownTask, lErrMsg) then
  begin
    result.ResultMsg := lErrMsg;
    exit;
  end;
  result.ResultData := QDownTask.FDataBase64;
  result.SetResultTrue();
end;

initialization

// 单例模式注册
OneHttpRouterManage.GetInitRouterManage().AddHTTPSingleWork('OneServer/FastFile', TFastFileController, 0, CreateNewFastFileController);

finalization

end.

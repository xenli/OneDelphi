unit OneFastModuleController;

interface

uses
  system.StrUtils, system.SysUtils, Math, system.JSON, system.Threading, system.Classes,
  OneHttpController, OneHttpRouterManage, OneHttpCtxtResult, OneTokenManage, OneHttpConst,
  system.Generics.Collections, OneControllerResult, FireDAC.Comp.Client, Data.DB, OneGuID,
  OneMultipart, OneFastModuleManage;

type
  TFastModuleController = class(TOneControllerBase)
  public
    function GetModuleInfo(QModuleCode: string): TActionResult<TModuleInfo>;
    function RefreshModuleInfo(QModuleCode: string): TActionResult<string>;
    function RefreshModuleInfoAll(): TActionResult<string>;
  end;

implementation

uses OneGlobal, OneZTManage;

function CreateNewFastModuleController(QRouterItem: TOneRouterWorkItem): Tobject;
var
  lController: TFastModuleController;
begin
  // 自定义创建控制器类，否则会按 TPersistentclass.create
  // 最好自定义一个好
  lController := TFastModuleController.Create;
  // 挂载RTTI信息
  lController.RouterItem := QRouterItem;
  result := lController;
end;

function TFastModuleController.GetModuleInfo(QModuleCode: string): TActionResult<TModuleInfo>;
var
  lFastModuleManage: TOneFastModuleManage;
  lErrMsg: string;
  lModuleInfo: TModuleInfo;
begin
  result := TActionResult<TModuleInfo>.Create(false, false);
  lFastModuleManage := OneFastModuleManage.UnitFastModuleManage();
  lModuleInfo := lFastModuleManage.GetModuleInfo(QModuleCode, lErrMsg);
  if lModuleInfo = nil then
  begin
    result.ResultMsg := lErrMsg;
    exit;
  end;
  result.ResultData := lModuleInfo;
  result.SetResultTrue;
end;

function TFastModuleController.RefreshModuleInfo(QModuleCode: string): TActionResult<string>;
var
  lFastModuleManage: TOneFastModuleManage;
  lErrMsg: string;
  lModuleInfo: TModuleInfo;
begin
  result := TActionResult<string>.Create(false, false);
  lFastModuleManage := OneFastModuleManage.UnitFastModuleManage();
  if not lFastModuleManage.RefreshModuleInfo(QModuleCode, lErrMsg) then
  begin
    result.ResultMsg := lErrMsg;
    exit;
  end;
  result.ResultData := '刷新模[' + QModuleCode + ']板信息成功';
  result.SetResultTrue;
end;

function TFastModuleController.RefreshModuleInfoAll(): TActionResult<string>;
var
  lFastModuleManage: TOneFastModuleManage;
  lErrMsg: string;
  lModuleInfo: TModuleInfo;
begin
  result := TActionResult<string>.Create(false, false);
  lFastModuleManage := OneFastModuleManage.UnitFastModuleManage();
  if not lFastModuleManage.RefreshModuleInfoAll(lErrMsg) then
  begin
    result.ResultMsg := lErrMsg;
    exit;
  end;
  result.ResultData := '刷新模板信息成功';
  result.SetResultTrue;
end;

initialization

// 单例模式注册
OneHttpRouterManage.GetInitRouterManage().AddHTTPSingleWork('/FastClient/FastModule', TFastModuleController, 0, CreateNewFastModuleController);

finalization

end.

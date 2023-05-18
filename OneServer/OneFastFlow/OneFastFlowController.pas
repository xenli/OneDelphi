unit OneFastFlowController;

interface

uses
  system.StrUtils, system.SysUtils, Math, system.JSON, system.Threading, system.Classes,
  OneHttpController, OneHttpRouterManage, OneHttpCtxtResult, OneTokenManage, OneHttpConst,
  system.Generics.Collections, OneControllerResult, FireDAC.Comp.Client, Data.DB, OneGuID,
  OneMultipart, OneFastFlowManage;

type
  TFastFlowController = class(TOneControllerBase)
  public
    function RefreshFlowManage(): TActionResult<string>;
    function GetFlowInfo(QFlowCode: string): TActionResult<TFlowInfo>;
  end;

implementation

uses OneGlobal;

function CreateNewFastFlowController(QRouterItem: TOneRouterWorkItem): Tobject;
var
  lController: TFastFlowController;
begin
  // 自定义创建控制器类，否则会按 TPersistentclass.create
  // 最好自定义一个好
  lController := TFastFlowController.Create;
  // 挂载RTTI信息
  lController.RouterItem := QRouterItem;
  result := lController;
end;

function TFastFlowController.RefreshFlowManage(): TActionResult<string>;
var
  lErrMsg: string;
begin
  result := TActionResult<string>.Create(false, false);
  if not OneFastFlowManage.UnitFastFlowManage().RefreshFlowManage(lErrMsg) then
  begin
    result.ResultMsg := lErrMsg;
    exit;
  end;
  result.SetResultTrue();
end;

function TFastFlowController.GetFlowInfo(QFlowCode: string): TActionResult<TFlowInfo>;
var
  lErrMsg: string;
  lFlowInfo: TFlowInfo;
begin
  result := TActionResult<TFlowInfo>.Create(false, false);
  lFlowInfo := nil;
  lFlowInfo := OneFastFlowManage.UnitFastFlowManage().GetFlowInfo(QFlowCode, lErrMsg);
  if lFlowInfo = nil then
  begin
    result.ResultMsg := lErrMsg;
    exit;
  end;
  result.ResultData := lFlowInfo;
  result.SetResultTrue();
end;

initialization

// 单例模式注册
OneHttpRouterManage.GetInitRouterManage()
  .AddHTTPSingleWork('OneServer/FastFlow', TFastFlowController, 0, CreateNewFastFlowController);

finalization

end.

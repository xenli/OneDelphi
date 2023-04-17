unit OneFastLshController;

interface

uses
  system.StrUtils, system.SysUtils, Math, system.JSON, system.Threading, system.Classes,
  OneHttpController, OneHttpRouterManage, OneHttpCtxtResult, OneTokenManage, OneHttpConst,
  system.Generics.Collections, OneControllerResult, FireDAC.Comp.Client, Data.DB, OneGuID,
  OneMultipart;

type
  TFastLshController = class(TOneControllerBase)
  public
    function RefreshLshSet(): TActionResult<string>;
    function GetLsh(QLshCode: string): TActionResult<string>;
    function GetLshList(QLshCode: string; QStep: integer): TActionResult<TList<string>>;
  end;

implementation

uses OneGlobal, OneFastLshManage;

function CreateNewFastLshController(QRouterItem: TOneRouterWorkItem): Tobject;
var
  lController: TFastLshController;
begin
  // 自定义创建控制器类，否则会按 TPersistentclass.create
  // 最好自定义一个好
  lController := TFastLshController.Create;
  // 挂载RTTI信息
  lController.RouterItem := QRouterItem;
  result := lController;
end;

function TFastLshController.RefreshLshSet(): TActionResult<string>;
var
  lErrMsg: string;
begin
  result := TActionResult<string>.Create(false, false);
  if not OneFastLshManage.UnitFastLshMange().RefreshLshSet(lErrMsg) then
  begin
    result.ResultMsg := lErrMsg;
    exit;
  end;
  result.SetResultTrue();
end;

function TFastLshController.GetLsh(QLshCode: string): TActionResult<string>;
var
  lLsh, lErrMsg: string;
begin
  result := TActionResult<string>.Create(false, false);
  lLsh := OneFastLshManage.UnitFastLshMange().GetLsh(QLshCode, lErrMsg);
  if lErrMsg <> '' then
  begin
    result.ResultMsg := lErrMsg;
    exit;
  end;
  result.ResultData := lLsh;
  result.SetResultTrue();
end;

function TFastLshController.GetLshList(QLshCode: string; QStep: integer): TActionResult<TList<string>>;
var
  lErrMsg: string;
  lLshList: TList<string>;
begin
  result := TActionResult < TList < string >>.Create(true, false);
  lLshList := nil;
  lLshList := OneFastLshManage.UnitFastLshMange().GetLshList(QLshCode, QStep, lErrMsg);
  if lErrMsg <> '' then
  begin
    result.ResultMsg := lErrMsg;
    exit;
  end;
  result.ResultData := lLshList;
  result.SetResultTrue;
end;

initialization

// 单例模式注册
OneHttpRouterManage.GetInitRouterManage().AddHTTPSingleWork('OneServer/FastLsh', TFastLshController, 0, CreateNewFastLshController);

finalization

end.

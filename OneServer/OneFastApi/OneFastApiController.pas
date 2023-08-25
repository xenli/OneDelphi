unit OneFastApiController;

interface

uses
  system.StrUtils, system.SysUtils, Math, system.JSON, system.Threading, system.Classes,
  OneHttpController, OneHttpRouterManage, OneHttpCtxtResult, OneTokenManage, OneHttpConst,
  system.Generics.Collections, OneControllerResult, FireDAC.Comp.Client, Data.DB, OneGuID,
  OneMultipart;

type
  TFastApiController = class(TOneControllerBase)
  public
    function DoFastApi(QPostJson: TJsonObject): string;
    function RefreshApiInfo(QApiCode: string): TActionResult<string>;
    function RefreshApiInfoAll(): TActionResult<string>;
  end;

implementation

uses OneGlobal, OneFastApiManage, OneFastApiDo;

function CreateNewFastApiController(QRouterItem: TOneRouterWorkItem): Tobject;
var
  lController: TFastApiController;
begin
  // 自定义创建控制器类，否则会按 TPersistentclass.create
  // 最好自定义一个好
  lController := TFastApiController.Create;
  // 挂载RTTI信息
  lController.RouterItem := QRouterItem;
  result := lController;
end;

function TFastApiController.DoFastApi(QPostJson: TJsonObject): string;
var
  lTokenItem: TOneTokenItem;
  lErrMsg: string;
  lJsonValue: TJsonValue;
begin
  lTokenItem := nil;
  lJsonValue := nil;
  try
    lTokenItem := self.GetCureentToken(lErrMsg);
    lJsonValue := OneFastApiDo.DoFastApi(lTokenItem, QPostJson);
    try
      result := lJsonValue.tostring;
    finally
      if lJsonValue <> nil then
      begin
        lJsonValue.free;
      end;
    end;
  except
    on e:exception do
    begin
      result := '发生异常,异常消息['+e.Message+']';
    end;
  end;
end;

function TFastApiController.RefreshApiInfo(QApiCode: string): TActionResult<string>;
var
  lApiManage: TOneFastApiManage;
  lErrMsg: string;
begin
  result := TActionResult<string>.Create(false, false);
  lApiManage := OneFastApiManage.UnitFastApiManage();
  if not lApiManage.RefreshApiInfo(QApiCode, lErrMsg) then
  begin
    result.ResultMsg := lErrMsg;
    exit;
  end;
  result.ResultData := '刷新FastApi模板[' + QApiCode + ']板信息成功';
  result.SetResultTrue;
end;

function TFastApiController.RefreshApiInfoAll(): TActionResult<string>;
var
  lApiManage: TOneFastApiManage;
  lErrMsg: string;
begin
  result := TActionResult<string>.Create(false, false);
  lApiManage := OneFastApiManage.UnitFastApiManage();
  if not lApiManage.RefreshApiInfoAll(lErrMsg) then
  begin
    result.ResultMsg := lErrMsg;
    exit;
  end;
  result.ResultData := '刷新FastApi模板信息成功';
  result.SetResultTrue;
end;

initialization

// 单例模式注册
OneHttpRouterManage.GetInitRouterManage().AddHTTPSingleWork('OneServer/FastApi', TFastApiController, 0, CreateNewFastApiController);

finalization

end.

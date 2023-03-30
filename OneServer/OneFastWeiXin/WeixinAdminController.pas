unit WeixinAdminController;

{ 微信回调，验证接口单元 }

interface

uses OneHttpController, OneHttpRouterManage, OneHttpCtxtResult, OneTokenManage,
  system.Generics.Collections, system.StrUtils, system.SysUtils, Data.DB,
  FireDAC.Comp.Client, OneControllerResult, system.Classes, system.Hash;

type

  TWeixinAdminController = class(TOneControllerBase)
  public
    function RefreshWeixinAccount(): TActionResult<string>;
    function RefreshWeixinAccessToken(): TActionResult<string>;
  end;

function CreateNewWeixinAdminController(QRouterItem: TOneRouterWorkItem): TObject;

implementation

uses OneGlobal, WeiXinManage;

function CreateNewWeixinAdminController(QRouterItem: TOneRouterWorkItem)
  : TObject;
var
  lController: TWeixinAdminController;
begin
  // 自定义创建控制器类，否则会按 TPersistentclass.create
  // 最好自定义一个好
  lController := TWeixinAdminController.Create;
  // 挂载RTTI信息
  lController.RouterItem := QRouterItem;
  result := lController;
end;

function TWeixinAdminController.RefreshWeixinAccount(): TActionResult<string>;
var
  lWeiXinManage: TWeiXinManage;
  lErrMsg: string;
begin
  result := TActionResult<string>.Create(false, false);
  lWeiXinManage := WeiXinManage.GetWeiXinManage();
  if not lWeiXinManage.RefreshWeixinAccount(lErrMsg) then
  begin
    result.ResultMsg := lErrMsg;
    exit;
  end;
  result.ResultData := '刷新数据成功！';
  result.SetResultTrue();
end;

function TWeixinAdminController.RefreshWeixinAccessToken(): TActionResult<string>;
var
  lWeiXinManage: TWeiXinManage;
  lErrMsg: string;
begin
  result := TActionResult<string>.Create(false, false);
  lWeiXinManage := WeiXinManage.GetWeiXinManage();
  if not lWeiXinManage.RefreshWeixinAccessToken(true, lErrMsg) then
  begin
    result.ResultMsg := lErrMsg;
    exit;
  end;
  result.ResultData := '刷新数据成功！';
  result.SetResultTrue();
end;

initialization

// 单例模式注册
OneHttpRouterManage.GetInitRouterManage().AddHTTPSingleWork('OneServer/WeixinAdmin', TWeixinAdminController, 0, CreateNewWeixinAdminController);

finalization

end.

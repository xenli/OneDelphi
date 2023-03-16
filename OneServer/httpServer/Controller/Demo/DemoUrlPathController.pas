unit DemoUrlPathController;

interface

uses OneHttpController, OneHttpRouterManage, OneHttpCtxtResult, OneTokenManage,
  system.Generics.Collections, system.StrUtils, system.SysUtils, Data.DB,
  FireDAC.Comp.Client, OneControllerResult;

type

  TDemoUrlPathController = class(TOneControllerBase)
  public
    // 请求 url xxxx/DemoUrlPath/OnePathTest/flm123
    function OnePathTest(id: string): string;
    // 请求 url xxxx/DemoUrlPath/OnePathTest/flm123/18
    function OnePathTest2(id: string; age: integer): string;
  end;

function CreateNewDemoUrlPathController(QRouterItem: TOneRouterWorkItem): TObject;

implementation

uses OneGlobal;

function CreateNewDemoUrlPathController(QRouterItem: TOneRouterWorkItem)
  : TObject;
var
  lController: TDemoUrlPathController;
begin
  // 自定义创建控制器类，否则会按 TPersistentclass.create
  // 最好自定义一个好
  lController := TDemoUrlPathController.Create;
  // 挂载RTTI信息
  lController.RouterItem := QRouterItem;
  result := lController;
end;

function TDemoUrlPathController.OnePathTest(id: string): string;
begin
  result := 'UrlPath参数:id=' + id;
end;

function TDemoUrlPathController.OnePathTest2(id: string; age: integer): string;
begin
  result := 'UrlPath参数:id1=' + id + ';age=' + age.ToString;
end;

initialization

// 单例模式注册
OneHttpRouterManage.GetInitRouterManage().AddHTTPSingleWork('DemoUrlPath', TDemoUrlPathController, 0, CreateNewDemoUrlPathController);

finalization

end.

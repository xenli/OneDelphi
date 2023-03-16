unit DemoJsonController;

// 结果返回是jsonobject,jsonArray事例
interface

uses OneHttpController, OneHttpCtxtResult, OneHttpRouterManage, System.SysUtils,
  System.Generics.Collections, System.Contnrs, System.Classes,
  FireDAC.Comp.Client, Data.DB, System.JSON;

type
  TDemoJsonController = class(TOneControllerBase)
  public
    // 返回结果 {"name":"flm0"}
    function GetJsonObject(): TJsonObject;
    // 返回结果 [{"name":"flm0"},{"name":"flm1"},{"name":"flm2"}]
    function GetJsonArray(): TJsonArray;

    // 最好是 TJsonValue做参数,如果传进的是一个数组也能正常接收
    // 然后在逻辑判断是JSONOBJECT还是JSONARRAY
    function GetJsonParam(QJsonObj: TJsonObject): string;
  end;

function CreateNewDemoJsonController(QRouterItem: TOneRouterWorkItem): TObject;

implementation

function CreateNewDemoJsonController(QRouterItem: TOneRouterWorkItem): TObject;
var
  lController: TDemoJsonController;
begin
  // 自定义创建控制器类，否则会按 TPersistentclass.create
  // 最好自定义一个好
  lController := TDemoJsonController.Create;
  // 挂载RTTI信息
  lController.RouterItem := QRouterItem;
  result := lController;
end;

function TDemoJsonController.GetJsonObject(): TJsonObject;
begin
  result := TJsonObject.Create;
  result.AddPair('name', 'flm');
end;

function TDemoJsonController.GetJsonArray(): TJsonArray;
var
  lJsonObj: TJsonObject;
  i: integer;
begin
  result := TJsonArray.Create;
  for i := 0 to 9 do
  begin
    lJsonObj := TJsonObject.Create;
    lJsonObj.AddPair('name', 'flm' + i.ToString);
    result.Add(lJsonObj);
  end;
end;

function TDemoJsonController.GetJsonParam(QJsonObj: TJsonObject): string;
begin
  result := QJsonObj.ToString;
end;

// 注册到路由
initialization

// 注意，路由名称 不要一样，否则会判定已注册过，跳过
// 多例模式注册
OneHttpRouterManage.GetInitRouterManage().AddHTTPPoolWork('DemoJson',
  TDemoJsonController, 10, CreateNewDemoJsonController);

finalization

end.

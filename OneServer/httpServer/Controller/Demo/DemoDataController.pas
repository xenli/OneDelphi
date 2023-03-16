unit DemoDataController;

// 结果返回是jsonobject,jsonArray事例
interface

uses OneHttpController, OneHttpCtxtResult, OneHttpRouterManage, System.SysUtils,
  System.Generics.Collections, System.Contnrs, System.Classes,
  FireDAC.Comp.Client, Data.DB, System.JSON;

type
  TDemoDataController = class(TOneControllerBase)
  public
    // 返回结果 [{"name":"flm0"},{"name":"flm1"},{"name":"flm2"}]
    function GetData(): TFDMemtable;
    // 返回结果 [{"name":"flm0"},{"name":"flm1"},{"name":"flm2"}]
    function GetQuery(): TFDQuery;
  end;

function CreateNewDemoDataController(QRouterItem: TOneRouterWorkItem): TObject;

implementation

function CreateNewDemoDataController(QRouterItem: TOneRouterWorkItem): TObject;
var
  lController: TDemoDataController;
begin
  // 自定义创建控制器类，否则会按 TPersistentclass.create
  // 最好自定义一个好
  lController := TDemoDataController.Create;
  // 挂载RTTI信息
  lController.RouterItem := QRouterItem;
  result := lController;
end;

function TDemoDataController.GetData(): TFDMemtable;
var
  i: integer;
begin
  result := TFDMemtable.Create(nil);
  result.FieldDefs.Add('name', ftString, 20, false);
  result.FieldDefs.Add('age', ftInteger, 0, True);
  result.CreateDataSet();
  for i := 0 to 99999 do
  begin
    result.Append;
    result.FieldByName('name').AsString := 'flm' + i.ToString();
    result.FieldByName('age').AsInteger := i;
    result.Post;
  end;
end;

function TDemoDataController.GetQuery(): TFDQuery;
var
  i: integer;
begin
  result := TFDQuery.Create(nil);
  // 当着本地缓存，否则要连接数据库
  result.CachedUpdates := True;
  result.FieldDefs.Add('name', ftString, 20, false);
  result.FieldDefs.Add('age', ftInteger, 0, True);
  result.CreateDataSet();
  for i := 0 to 9 do
  begin
    result.Append;
    result.FieldByName('name').AsString := 'flm' + i.ToString();
    result.FieldByName('age').AsInteger := i;
    result.Post;
  end;
end;

// 注册到路由
initialization

// 注意，路由名称 不要一样，否则会判定已注册过，跳过
// 多例模式注册
OneHttpRouterManage.GetInitRouterManage().AddHTTPSingleWork('DemoData', TDemoDataController, 0, CreateNewDemoDataController);

finalization

end.

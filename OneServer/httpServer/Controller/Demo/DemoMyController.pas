unit DemoMyController;

interface

uses OneHttpController, OneHttpCtxtResult, OneHttpRouterManage, System.SysUtils,
  System.Generics.Collections, System.Contnrs, System.Classes,
  FireDAC.Comp.Client, Data.DB, System.JSON;

type
  TMyClass = class
  public
    name: string;
    age: integer;
  end;

  TDemoMyController = class(TOneControllerBase)
  private
  public
    function test(name: string; age: integer): string;
    function testClass(myInfo: TMyClass): string;
    function testJson(QJson: TJsonObject): string;
    function OneGetTest(name: string; age: integer): string;
    function testGet(name: string): TMyClass;
    function getData(): TFDMemtable;
  end;

implementation

function CreateNewDemoMyController(QRouterItem: TOneRouterWorkItem): TObject;
var
  lController: TDemoMyController;
begin
  // 自定义创建控制器类，否则会按 TPersistentclass.create
  // 最好自定义一个好
  lController := TDemoMyController.Create;
  // 挂载RTTI信息
  lController.RouterItem := QRouterItem;
  result := lController;
end;

function TDemoMyController.test(name: string; age: integer): string;
var
  lSt: string;
begin
  result := '我接收到信息name:' + name + '年龄age:' + age.ToString;
end;

function TDemoMyController.testClass(myInfo: TMyClass): string;
begin
  result := '我接收到信息name:' + myInfo.name + '年龄age:' + myInfo.age.ToString;
end;

function TDemoMyController.testJson(QJson: TJsonObject): string;
begin
  result := '我接收到信息name:' + QJson.GetValue<string>('name') + '年龄age:' + QJson.GetValue<integer>('age').ToString;
end;

function TDemoMyController.OneGetTest(name: string; age: integer): string;
begin
  result := '我接收到信息name:' + name + '年龄age:' + age.ToString;
end;

function TDemoMyController.testGet(name: string): TMyClass;
begin
  result := TMyClass.Create;
  result.name := '我接收到信息name:' + name;
  result.age := 9999;
end;

function TDemoMyController.getData(): TFDMemtable;
var i:integer;
begin
  result := TFDMemtable.Create(nil);
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
OneHttpRouterManage.GetInitRouterManage().AddHTTPPoolWork('DemoMy', TDemoMyController, 10, CreateNewDemoMyController);

finalization

end.

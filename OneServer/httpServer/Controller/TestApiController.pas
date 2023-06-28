unit TestApiController;

interface

uses OneHttpController, OneHttpRouterManage, system.JSON, FireDAC.Comp.Client, data.DB,
  system.Classes, system.StrUtils, system.SysUtils;

type
  TTestApiController = class(TOneControllerBase)
  public
    function TestApi(): string;
    function TestName(name: string): string;
    function TestJson(QJson: TJsonObject): TJsonObject;
    function TestData(): TFDMemTable;
  end;

implementation

function CreateNewTestApiController(QRouterItem: TOneRouterWorkItem): TObject;
var
  lController: TTestApiController;
begin
  // 自定义创建控制器类，否则会按 TPersistentclass.create
  // 最好自定义一个好
  lController := TTestApiController.Create;
  // 挂载RTTI信息
  lController.RouterItem := QRouterItem;
  result := lController;
end;

function TTestApiController.TestApi(): string;
begin
  result := '欢迎您来到TestApi服务';
end;

function TTestApiController.TestName(name: string): string;
begin
  result := '欢迎您来到TestApi服务[' + name + ']';
end;

function TTestApiController.TestJson(QJson: TJsonObject): TJsonObject;
begin
  result := TJsonObject.Create;
  result.AddPair('QJson', QJson.ToString);
end;

function TTestApiController.TestData(): TFDMemTable;
var
  i: integer;
begin
  result := TFDMemTable.Create(nil);
  result.FieldDefs.Add('ID', ftInteger, 0, True);
  result.FieldDefs.Add('Name', ftString, 20, false);
  result.CreateDataSet();
  for i := 0 to 10 do
  begin
    result.Append;
    result.Fields[0].AsInteger := i;
    result.Fields[1].AsString := 'name' + inttostr(i);
    result.Post;
  end;

end;

// 注册到路由
initialization

// 注意，路由名称 不要一样，否则会判定已注册过，跳过
// 多例模式注册
OneHttpRouterManage.GetInitRouterManage().AddHTTPPoolWork('TestApi/myTest', TTestApiController, 0, CreateNewTestApiController);

finalization

end.

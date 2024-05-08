unit DemoAttributeController;

interface

uses OneHttpController, OneHttpCtxtResult, OneHttpRouterManage, System.SysUtils,
  System.Generics.Collections, System.Contnrs, System.Classes,
  FireDAC.Comp.Client, Data.DB, System.JSON, System.IOUtils, OneAttribute;

type
  TDemoAttributeController = class(TOneControllerBase)
  public
    // 取参数取的是ULR ?后面的参数,且只支持Get访问,不需要以OneGet开头
    [TOneHttpGet]
    function GetTest(name: string; sex: string): string;

    // 取参数取的是ULR路径的参数 /url路径/myname/mysex;,不需要以OnePath开头
    [TOneHttpPath]
    function GetPath(name: string; sex: string): string;

    // 取参数取的是post Data数据且为JSON格式,且只支持Post访问,不需要以OnePost开头
    [TOneHttpPost]
    function PostTest(name: string; sex: string): string;

    // 取参数取的是post Data数据,且只支持Post访问
    // data数据是表单格式 key1=value1&key2=value2
    // 数据之间是用&关联
    [TOneHttpForm]
    function PostForm(name: string; sex: string): string;

    //增加匿名路由,访问地址如下
    //http://127.0.0.1:9090/DemoAttribute/mytest
    //而不是 http://127.0.0.1:9090/DemoAttribute/CustRouter
    [TOneRouter('/mytest')]
    [TOneHttpPost]
    function CustRouter(name: string; sex: string): string;
  end;

implementation

function CreateNewDemoAttributeController(QRouterItem: TOneRouterWorkItem): TObject;
var
  lController: TDemoAttributeController;
begin
  // 自定义创建控制器类，否则会按 TPersistentclass.create
  // 最好自定义一个好
  lController := TDemoAttributeController.Create;
  // 挂载RTTI信息
  lController.RouterItem := QRouterItem;
  result := lController;
end;

function TDemoAttributeController.GetTest(name: string; sex: string): string;
begin
  result := '姓名:[' + name + '];姓别:[' + sex + ']';
end;

function TDemoAttributeController.GetPath(name: string; sex: string): string;
begin
  result := '姓名:[' + name + '];姓别:[' + sex + ']';
end;

function TDemoAttributeController.PostTest(name: string; sex: string): string;
begin
  result := '姓名:[' + name + '];姓别:[' + sex + ']';
end;

function TDemoAttributeController.PostForm(name: string; sex: string): string;
begin
  result := '姓名:[' + name + '];姓别:[' + sex + ']';
end;

function TDemoAttributeController.CustRouter(name: string; sex: string): string;
begin
  result := '姓名:[' + name + '];姓别:[' + sex + ']';
end;

// 注册到路由
initialization

// 注意，路由名称 不要一样，否则会判定已注册过，跳过
// 单例模式注册
OneHttpRouterManage.GetInitRouterManage().AddHTTPSingleWork('DemoAttribute', TDemoAttributeController, 100, CreateNewDemoAttributeController);

finalization

end.

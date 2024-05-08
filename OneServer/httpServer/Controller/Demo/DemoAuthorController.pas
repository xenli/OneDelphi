unit DemoAuthorController;

interface

uses OneHttpController, OneHttpCtxtResult, OneHttpRouterManage, System.SysUtils,
  System.Generics.Collections, System.Contnrs, System.Classes,
  FireDAC.Comp.Client, Data.DB, System.JSON, System.IOUtils, OneAttribute;

type
  TDemoAuthorController = class(TOneControllerBase)
  public
    // 建议使用方式
    // 跟据ulr?后面的参数获取相关验证信息
    [TOneAuthor(TOneAuthorGetMode.token)]
    [TOneHttpGet]
    function GetTestA(name: string; sex: string): string;

    // 建议使用方式
    // 跟据关部 Authorization获取验证信息
    [TOneAuthor(TOneAuthorGetMode.header)]
    [TOneHttpGet]
    function GetTestB(name: string; sex: string): string;

    // 底程有提供相关方法,线程安全直接调用
    // 但个人建议还是用注解方式
    [TOneHttpGet]
    function GetTestC(name: string; sex: string): string;
  end;

implementation

function CreateDemoAuthorController(QRouterItem: TOneRouterWorkItem): TObject;
var
  lController: TDemoAuthorController;
begin
  // 自定义创建控制器类，否则会按 TPersistentclass.create
  // 最好自定义一个好
  lController := TDemoAuthorController.Create;
  // 挂载RTTI信息
  lController.RouterItem := QRouterItem;
  result := lController;
end;

function TDemoAuthorController.GetTestA(name: string; sex: string): string;
begin
  //底程会先调用  TOneAuthor(TOneAuthorGetMode.token)注解，判断是否授权
  //没有的话，不会调用此方法，会返回无授权信息
  result := '姓名:[' + name + '];姓别:[' + sex + ']';
end;

function TDemoAuthorController.GetTestB(name: string; sex: string): string;
begin
   //底程会先调用  TOneAuthor(TOneAuthorGetMode.header)注解，判断是否授权
  //没有的话，不会调用此方法，会返回无授权信息
  result := '姓名:[' + name + '];姓别:[' + sex + ']';
end;

function TDemoAuthorController.GetTestC(name: string; sex: string): string;
var
  lErrMsg: string;
begin
  //一定会调用到此方法,手动判断是否授权
  if not self.CheckCureentToken(lErrMsg) then
  begin
    result :=  lErrMsg;
    exit;
  end;
  result := '姓名:[' + name + '];姓别:[' + sex + ']';
end;

// 注册到路由
initialization

// 注意，路由名称 不要一样，否则会判定已注册过，跳过
// 单例模式注册
OneHttpRouterManage.GetInitRouterManage().AddHTTPSingleWork('DemoAuthor', TDemoAuthorController, 100, CreateDemoAuthorController);

finalization

end.

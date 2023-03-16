unit DemoLogController;

// 结果返回是jsonobject,jsonArray事例
interface

uses OneHttpController, OneHttpCtxtResult, OneHttpRouterManage, System.SysUtils,
  System.Generics.Collections, System.Contnrs, System.Classes,
  FireDAC.Comp.Client, Data.DB, System.JSON, OneControllerResult;

type
  TDemoLogController = class(TOneControllerBase)
  public
    function TestWrite(): boolean;
  end;

function CreateNewDemoLogController(QRouterItem: TOneRouterWorkItem): TObject;

implementation

uses OneGlobal, OneZTManage;

function CreateNewDemoLogController(QRouterItem: TOneRouterWorkItem): TObject;
var
  lController: TDemoLogController;
begin
  // 自定义创建控制器类，否则会按 TPersistentclass.create
  // 最好自定义一个好
  lController := TDemoLogController.Create;
  // 挂载RTTI信息
  lController.RouterItem := QRouterItem;
  result := lController;
end;

function TDemoLogController.TestWrite(): boolean;
var
  lOneGlobal: TOneGlobal;
begin
  lOneGlobal := TOneGlobal.GetInstance();
  lOneGlobal.Log.WriteLog('当前时间:' + FormatDateTime
    ('yyyy-mm-dd hh:mm:ss zzz', now()));
  lOneGlobal.Log.WriteLog('写入数据测试12345678910');
  result := true;
end;

// 注册到路由
initialization

// 注意，路由名称 不要一样，否则会判定已注册过，跳过
// 多例模式注册
OneHttpRouterManage.GetInitRouterManage().AddHTTPPoolWork('DemoLog',
  TDemoLogController, 0, CreateNewDemoLogController);

finalization

end.

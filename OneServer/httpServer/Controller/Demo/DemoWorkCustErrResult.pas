unit DemoWorkCustErrResult;

{ 未执行到业务层Controll自定义输出错误 消息 }

interface

uses OneHttpController, OneHttpCtxtResult, OneHttpRouterManage, System.SysUtils,
  System.Generics.Collections, System.Contnrs, System.Classes,
  FireDAC.Comp.Client, Data.DB, System.JSON;

type

  TDemoErrController = class(TOneControllerBase)
  private
    procedure DoWorkCustErrResult(QHTTPCtxt: THTTPCtxt; QHTTPResult: THTTPResult); override;
  public
    function test(name: string; age: integer): string;
  end;

implementation

function CreateNewDemoErrorController(QRouterItem: TOneRouterWorkItem): TObject;
var
  lController: TDemoErrController;
begin
  // 自定义创建控制器类，否则会按 TPersistentclass.create
  // 最好自定义一个好
  lController := TDemoErrController.Create;
  // 挂载RTTI信息
  lController.RouterItem := QRouterItem;
  result := lController;
end;

procedure TDemoErrController.DoWorkCustErrResult(QHTTPCtxt: THTTPCtxt; QHTTPResult: THTTPResult);
var
  lJson: TJsonObject;
begin
  lJson := TJsonObject.Create;
  try
    lJson.AddPair('code', '211');
    lJson.AddPair('msg', QHTTPResult.ResultMsg);
    QHTTPCtxt.OutContent := UTF8EnCode(lJson.ToString());
  finally
    lJson.Free;
  end;
end;

function TDemoErrController.test(name: string; age: integer): string;
var
  lSt: string;
begin
  result := '我接收到信息name:' + name + '年龄age:' + age.ToString;
end;

// 注册到路由
initialization

// 注意，路由名称 不要一样，否则会判定已注册过，跳过
// 多例模式注册
OneHttpRouterManage.GetInitRouterManage().AddHTTPPoolWork('DemoErr', TDemoErrController, 10, CreateNewDemoErrorController);

finalization

end.

unit DemoVersionController;

interface

uses OneHttpController, OneHttpCtxtResult, OneHttpRouterManage, System.SysUtils,
  System.Generics.Collections, System.Contnrs, System.Classes, System.IOUtils,
  FireDAC.Comp.Client, Data.DB, System.JSON, OneControllerResult, OneFileHelper;

type
  TDemoV1Controller = class(TOneControllerBase)
  public
    function test(): string;
  end;

  TDemoV2Controller = class(TOneControllerBase)
  public
    function test(): string;
  end;

implementation

function TDemoV1Controller.test(): string;

begin
  result := '我是v1版本';
end;

function TDemoV2Controller.test(): string;

begin
  result := '我是v2版本';
end;

// 注册到路由
initialization

OneHttpRouterManage.GetInitRouterManage().AddHTTPPoolWork('v1/demo', TDemoV1Controller, 10, nil);
OneHttpRouterManage.GetInitRouterManage().AddHTTPPoolWork('v2/demo', TDemoV2Controller, 10, nil);

finalization

end.

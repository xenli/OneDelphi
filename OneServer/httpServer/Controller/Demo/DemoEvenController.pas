unit DemoEvenController;

interface

uses OneHttpController, OneHttpCtxtResult, OneHttpRouterManage, System.SysUtils,
  System.Generics.Collections, System.Contnrs, System.Classes,
  FireDAC.Comp.Client, Data.DB, System.JSON, Rtti;

type
{$M+}
  TMyProc = reference to procedure();
{$M-}

procedure myTest;

implementation

procedure myTest;
begin

end;

// 注册到路由
initialization

// 注意，路由名称 不要一样，否则会判定已注册过，跳过
// 多例模式注册
OneHttpRouterManage.GetInitRouterManage().AddHTTPPointerWork('DemoMyEven', TValue.From<TMyProc>(myTest), 10);

finalization

end.

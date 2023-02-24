unit DemoBController;

interface

uses OneHttpController, OneHttpCtxtResult, OneHttpRouterManage, System.SysUtils,
  System.Generics.Collections, System.Contnrs, System.Classes,
  FireDAC.Comp.Client, Data.DB, System.JSON;

type
  TDemoBController = class(TOneControllerBase)
  private

  public
    // 要对外访问的，方法全要放在pulibc部份,外面才可访问
    procedure DoTest();

  end;

implementation

function CreateNewDemoBController(QRouterItem: TOneRouterItem): TObject;
var
  lController: TDemoBController;
begin
  // 自定义创建控制器类，否则会按 TPersistentclass.create
  // 最好自定义一个好
  lController := TDemoBController.Create;
  // 挂载RTTI信息
  lController.RouterItem := QRouterItem;
  result := lController;
end;

procedure TDemoBController.DoTest();
var
  lStr: string;
begin
  lStr := '1231345';
end;

// 注册到路由
initialization

// 注意，路由名称 不要一样，否则会判定已注册过，跳过
// 多例模式注册
OneHttpRouterManage.GetInitRouterManage().AddHTTPPoolWork('DemoB',
  TDemoBController, 10, CreateNewDemoBController);

finalization

end.

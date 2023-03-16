unit DemoOneWorkThread;

interface

uses OneThread, OneHttpController, OneHttpRouterManage, system.SysUtils;

type
  TDemoThreadController = class(TOneControllerBase)
  public
    function CreateWork(): string;
    function StarWork(): string;
    function FreeWork(): string;
  end;

function CreateNewDemoController(QRouterItem: TOneRouterWorkItem): TObject;
procedure doWork();
procedure createUnitWork();

var
  unit_WorkThread: TOneSingleWorkThread;

implementation

procedure doWork();
begin
  sleep(1000 * 2);
end;

procedure createUnitWork();
begin
  if unit_WorkThread = nil then
  begin
    unit_WorkThread := TOneSingleWorkThread.Create(nil, doWork);
  end;
end;

function TDemoThreadController.CreateWork(): string;
begin
  if unit_WorkThread = nil then
  begin
    DemoOneWorkThread.createUnitWork();
    Result := '启动成功';
  end
  else
  begin
    Result := '已经启动';
  end;

end;

function TDemoThreadController.StarWork(): string;
begin
  if unit_WorkThread = nil then
  begin
    Result := '未启动，请先启动';
  end
  else
  begin
    unit_WorkThread.StartWork;
    Result := '开始工作';
  end;

end;

function TDemoThreadController.FreeWork(): string;
begin
  if unit_WorkThread = nil then
  begin
    Result := '未启动，请先启动';
  end
  else
  begin
    unit_WorkThread.Free;
    Result := '结束工作';
  end;
end;

function CreateNewDemoController(QRouterItem: TOneRouterWorkItem): TObject;
var
  lController: TDemoThreadController;
begin
  // 自定义创建控制器类，否则会按 TPersistentclass.create
  // 最好自定义一个好
  lController := TDemoThreadController.Create;
  // 挂载RTTI信息
  lController.RouterItem := QRouterItem;
  Result := lController;
end;

// 注册到路由
initialization

// 注意，路由名称 不要一样，否则会判定已注册过，跳过
// 多例模式注册
OneHttpRouterManage.GetInitRouterManage().AddHTTPPoolWork('DemoThread',
  TDemoThreadController, 100, CreateNewDemoController);

finalization

if unit_WorkThread <> nil then
begin
  unit_WorkThread.Free;
end

end.

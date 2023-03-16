unit DemoOrmController;

interface

uses OneHttpController, OneHttpRouterManage, OneHttpCtxtResult, OneTokenManage,
  system.Generics.Collections, system.StrUtils, system.SysUtils, Data.DB,
  FireDAC.Comp.Client, OneControllerResult, OneAttribute;

type
  emTest = (cmTestA, cmTestB);

  // 请自行创建一个表，包含以下字段，或者随意几个
  TTestOrm = class
  private
    FName: string;
    FAge: Integer;
  public
    constructor Create;
    destructor Destroy; override;
  public
    property Name: string read FName write FName;
    property Age: Integer read FAge write FAge;
  end;

  TDemoOrmController = class(TOneControllerBase)
  public
    // 跟据原生SQL获取数据
    function GetOrmQueryList(): TActionResult<TList<TTestOrm>>;
    // 跟据select命令获取数据
    function GetOrmSelectList(): TActionResult<TList<TTestOrm>>;
    // 跟据select命令分页获取数据
    function GetOrmPageList(): TActionResult<TList<TTestOrm>>;
    // 跟据seelct命令获取一条数据,如果获得多条会暴错
    function GetOrmObject(): TActionResult<TTestOrm>;
    // 插入一个对象
    function OrmInsertObject(QTest: TTestOrm): TActionResult<string>;
    // 插入一个对象列表
    function OrmInsertList(QList: TList<TTestOrm>): TActionResult<string>;
    // 更新一个对象
    function OrmUpdateObject(QTest: TTestOrm): TActionResult<string>;
    // 更新一个对象列表
    function OrmUpdateList(QList: TList<TTestOrm>): TActionResult<string>;
    // 删除一个对象
    function OrmDeleteObject(QTest: TTestOrm): TActionResult<string>;
    // 删除一个对象列表
    function OrmDeleteList(QList: TList<TTestOrm>): TActionResult<string>;
  end;

function CreateNewDemoOrmController(QRouterItem: TOneRouterWorkItem): TObject;

implementation

uses OneGlobal, oneOrm;

function CreateNewDemoOrmController(QRouterItem: TOneRouterWorkItem): TObject;
var
  lController: TDemoOrmController;
begin
  // 自定义创建控制器类，否则会按 TPersistentclass.create
  // 最好自定义一个好
  lController := TDemoOrmController.Create;
  // 挂载RTTI信息
  lController.RouterItem := QRouterItem;
  result := lController;
end;

function TDemoOrmController.GetOrmQueryList(): TActionResult<TList<TTestOrm>>;
var
  lList: TList<TTestOrm>;
  lTestOrm: TTestOrm;
begin
  result := TActionResult < TList < TTestOrm >>.Create(true, true);
  lList := TOneOrm<TTestOrm>.Start().Query('select * from test', []).ToList();
  result.ResultData := lList;
  result.SetResultTrue;
end;

function TDemoOrmController.GetOrmSelectList(): TActionResult<TList<TTestOrm>>;
var
  lList: TList<TTestOrm>;
begin
  result := TActionResult < TList < TTestOrm >>.Create(true, true);
  lList := TOneOrm<TTestOrm>.Start().Select('test').where('1=1', []).toCmd().ToList();
  result.ResultData := lList;
  result.SetResultTrue;
end;

function TDemoOrmController.GetOrmPageList(): TActionResult<TList<TTestOrm>>;
var
  lList: TList<TTestOrm>;
begin
  result := TActionResult < TList < TTestOrm >>.Create(true, true);
  lList := TOneOrm<TTestOrm>.Start().Select('test').where('1=1', []).SetPage(1, 2).toCmd().ToList();
  result.ResultData := lList;
  result.SetResultTrue;
end;

function TDemoOrmController.GetOrmObject(): TActionResult<TTestOrm>;
var
  lList: TList<TTestOrm>;
  lTestOrm: TTestOrm;
begin
  result := TActionResult<TTestOrm>.Create(true, true);
  lTestOrm := TOneOrm<TTestOrm>.Start().Query('select * from test where name=:name', ['flm']).ToObject();
  result.ResultData := lTestOrm;
end;

function TDemoOrmController.OrmInsertObject(QTest: TTestOrm): TActionResult<string>;
var
  i: Integer;
begin
  result := TActionResult<string>.Create(true, true);
  i := TOneOrm<TTestOrm>.Start().SetTableName('test').SetPrimaryKey('Name').Inserter(QTest).toCmd().ToExecCommand();
  // Fields([]) 什么字段参与,DisableFields什么字段不参与
  // TOneOrm<TTestOrm>.Start().Inserter(QTest).Fields([]).DisableFields([]);
  result.ResultData := '影响行数' + i.ToString();
  result.SetResultTrue;
end;

function TDemoOrmController.OrmInsertList(QList: TList<TTestOrm>): TActionResult<string>;
var
  i: Integer;
begin
  result := TActionResult<string>.Create(true, true);
  i := TOneOrm<TTestOrm>.Start().SetTableName('test').SetPrimaryKey('Name').Inserter(QList).toCmd().ToExecCommand();
  result.ResultData := '影响行数' + i.ToString();
  result.SetResultTrue;
end;

function TDemoOrmController.OrmUpdateObject(QTest: TTestOrm): TActionResult<string>;
var
  i: Integer;
begin
  result := TActionResult<string>.Create(true, true);
  // Fields(['Age']) 只更新Age字段，否则全部更新
  i := TOneOrm<TTestOrm>.Start().SetTableName('test').SetPrimaryKey('Name').Update(QTest).Fields(['Age']).toCmd().ToExecCommand();
  result.ResultData := '影响行数' + i.ToString();
  result.SetResultTrue;
end;

function TDemoOrmController.OrmUpdateList(QList: TList<TTestOrm>): TActionResult<string>;
var
  i: Integer;
begin
  result := TActionResult<string>.Create(true, true);
  // Fields(['Age']) 只更新Age字段，否则全部更新
  i := TOneOrm<TTestOrm>.Start().SetTableName('test').SetPrimaryKey('Name').Update(QList).Fields(['Age', 'myBit']).toCmd().ToExecCommand();
  result.ResultData := '影响行数' + i.ToString();
  result.SetResultTrue;
end;

function TDemoOrmController.OrmDeleteObject(QTest: TTestOrm): TActionResult<string>;
var
  i: Integer;
begin
  result := TActionResult<string>.Create(true, true);
  // Fields(['Age']) 只更新Age字段，否则全部更新
  i := TOneOrm<TTestOrm>.Start().SetTableName('test').SetPrimaryKey('Name').Delete(QTest).toCmd().ToExecCommand();
  result.ResultData := '影响行数' + i.ToString();
  result.SetResultTrue;
end;

function TDemoOrmController.OrmDeleteList(QList: TList<TTestOrm>): TActionResult<string>;
var
  i: Integer;
begin
  result := TActionResult<string>.Create(true, true);
  // Fields(['Age']) 只更新Age字段，否则全部更新
  i := TOneOrm<TTestOrm>.Start().SetTableName('test').SetPrimaryKey('Name').Delete(QList).toCmd().ToExecCommand();
  result.ResultData := '影响行数' + i.ToString();
  result.SetResultTrue;
end;

constructor TTestOrm.Create;
begin
  inherited Create;
  self.FName := '-';
end;

destructor TTestOrm.Destroy;
begin

end;

initialization

// 单例模式注册
OneHttpRouterManage.GetInitRouterManage().AddHTTPSingleWork('DemoOrm', TDemoOrmController, 0, CreateNewDemoOrmController);

finalization

end.

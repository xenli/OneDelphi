unit DemoCustResult;

interface

uses OneHttpController, OneHttpRouterManage, OneHttpCtxtResult, OneTokenManage,
  system.Generics.Collections, system.StrUtils, system.SysUtils, Data.DB,
  FireDAC.Comp.Client, OneControllerResult;

type

  TDemoCustResultController = class(TOneControllerBase)
  public
    // 返回结果格式 {ResultBool: false, ResultCode: "0002", ResultMsg: "", ResultData: "范联满"}
    function GetResultStr(): TActionResult<string>;
    // 返回结果格式 {ResultBool: false, ResultCode: "0002", ResultMsg: "", ResultData: ["范联满","范联满","范联满"]}
    function GetResultList(): TActionResult<TList<string>>;
    // 返回结果格式 {ResultBool: false, ResultCode: "0002", ResultMsg: "", ResultData: [{name: "范联满", age: 10},{name: "范联满", age: 10}]}
    function GetResultListPerson(): TActionResult<TList<TPerSonDemo>>;
    // 返回结果格式 {ResultBool: false, ResultCode: "0002", ResultMsg: "", ResultData: {name: "范联满", age: 10}}
    function GetResultRecord(): TActionResult<TPersonrecord>;
    // 返回结果格式 {ResultBool: false, ResultCode: "0002", ResultMsg: "", ResultData: [{name: "范联满", age: 10},{name: "范联满", age: 10}]}
    function GetResultData(): TActionResult<TDataSet>;
  end;

function CreateNewDemoCustResultController(QRouterItem: TOneRouterWorkItem)
  : TObject;

implementation

uses OneGlobal;

function CreateNewDemoCustResultController(QRouterItem: TOneRouterWorkItem)
  : TObject;
var
  lController: TDemoCustResultController;
begin
  // 自定义创建控制器类，否则会按 TPersistentclass.create
  // 最好自定义一个好
  lController := TDemoCustResultController.Create;
  // 挂载RTTI信息
  lController.RouterItem := QRouterItem;
  result := lController;
end;

function TDemoCustResultController.GetResultStr(): TActionResult<string>;
var
  i: integer;
begin
  // 返回的不是对象，第一个参数false无需释放,第二个参数false也没有item无需释放
  result := TActionResult<string>.Create(false, false);
  result.ResultData := '我是大傻B';
  // SetResultTrue=>   ResultBool := true; ResultCode := HTTP_ResultCode_True;
  result.SetResultTrue();
end;

function TDemoCustResultController.GetResultList(): TActionResult<TList<string>>;
var
  i: integer;
  lList: TList<string>;
begin
  // 返回的对象第一个参数true需释放,第二个参数item不是对象无需释放
  result := TActionResult < TList < string >>.Create(true, false);
  lList := TList<string>.Create;
  for i := 0 to 9 do
  begin
    lList.Add('flm' + i.ToString);
  end;
  result.ResultData := lList;
  // SetResultTrue=>   ResultBool := true; ResultCode := HTTP_ResultCode_True;
  result.SetResultTrue();
end;

function TDemoCustResultController.GetResultListPerson()
  : TActionResult<TList<TPerSonDemo>>;
var
  i: integer;
  lList: TList<TPerSonDemo>;
  lPerson: TPerSonDemo;
begin
  // 返回的对象第一个参数true需释放,第二个参数item是对象需释放
  // 当然如果item是全局变量,也可以设成false不释放
  result := TActionResult < TList < TPerSonDemo >>.Create(true, true);
  lList := TList<TPerSonDemo>.Create;
  for i := 0 to 9 do
  begin
    lPerson := TPerSonDemo.Create;
    lPerson.name := 'flm' + i.ToString;
    lPerson.age := i;
    lList.Add(lPerson);
  end;
  result.ResultData := lList;
  result.SetResultTrue();
end;

function TDemoCustResultController.GetResultRecord(): TActionResult<TPersonrecord>;
var
  lPersonrecord: TPersonrecord;
begin
  result := TActionResult<TPersonrecord>.Create(false, false);
  lPersonrecord.name := '范联满';
  lPersonrecord.age := 10;
  result.ResultData := lPersonrecord;
end;

function TDemoCustResultController.GetResultData(): TActionResult<TDataSet>;
var
  i: integer;
  lFDMemTable: TFDMemTable;
begin
  result := TActionResult<TDataSet>.Create(true, false);
  lFDMemTable := TFDMemTable.Create(nil);
  lFDMemTable.FieldDefs.Add('name', ftString, 20, false);
  lFDMemTable.FieldDefs.Add('age', ftInteger, 0, true);
  lFDMemTable.CreateDataSet();
  for i := 0 to 9 do
  begin
    lFDMemTable.Append;
    lFDMemTable.FieldByName('name').AsString := 'flm' + i.ToString();
    lFDMemTable.FieldByName('age').AsInteger := i;
    lFDMemTable.Post;
  end;
  result.ResultData := lFDMemTable;
end;

initialization

// 单例模式注册
OneHttpRouterManage.GetInitRouterManage().AddHTTPSingleWork('DemoCustResult',
  TDemoCustResultController, 0, CreateNewDemoCustResultController);

finalization

end.

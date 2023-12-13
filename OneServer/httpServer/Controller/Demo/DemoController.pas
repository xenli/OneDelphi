unit DemoController;

interface

uses OneHttpController, OneHttpCtxtResult, OneHttpRouterManage, System.SysUtils,
  System.Generics.Collections, System.Contnrs, System.Classes,
  FireDAC.Comp.Client, Data.DB, System.JSON, System.IOUtils;

type
  TPersonResult = class(TObject)
  private
    FPerson: TPersonDemo;
    FResultCode: string;
    FReslutMsg: string;
  public
    // 圈套类，需要在类释放时释放 FPerson
    constructor Create;
    destructor Destroy; override;
  public
    property resultCode: string read FResultCode write FResultCode;
    property resultMsg: string read FReslutMsg write FReslutMsg;
    property person: TPersonDemo read FPerson write FPerson;
  end;

  TPersonListResult = class
  private
    FPersons: TList<TPersonDemo>;
    FResultCode: string;
    FReslutMsg: string;
  public
    // 圈套类，需要在类释放时释放 FPerson
    constructor Create;
    destructor Destroy; override;
  public
    property resultCode: string read FResultCode write FResultCode;
    property resultMsg: string read FReslutMsg write FReslutMsg;
    property persons: TList<TPersonDemo> read FPersons write FPersons;
  end;

  TDemoController = class(TOneControllerBase)
  public
    // OnetGet支持Get访问
    procedure OneGetHelloWorld(QHTTPCtxt: THTTPCtxt; QHTTPResult: THTTPResult);
    // 最终结果:{ResultCode: "0001", ResultMsg: "", ResultCount: 0, ResultData: "欢迎来到HelloWorld"}
    procedure HelloWorld(QHTTPCtxt: THTTPCtxt; QHTTPResult: THTTPResult);
    // 最终结果只输出文本:欢迎来到HelloWorld
    procedure HelloWorldStr(QHTTPCtxt: THTTPCtxt; QHTTPResult: THTTPResult);
    // 输出文件
    procedure GetFile(QHTTPCtxt: THTTPCtxt; QHTTPResult: THTTPResult);
    // 最终结果:{ResultCode: "0001", ResultMsg: "", ResultCount: 0, ResultData: {name: "范联满flm123", aag: 32}}
    procedure person(QHTTPCtxt: THTTPCtxt; QHTTPResult: THTTPResult);
    // 无参数方法调用,如果要用到控制层 HTTPCtxt,HTTPResult必需是多例模式
    procedure TestNoParam();
    //
    function TestStr(): string;
    function TestStrList(qList: TList<string>): string;
    // 代函数返回值
    function GetStr(): string;
    function GetInt(): integer;
    // 返回结果 {name: "范联满flm123", age: 32}
    function GetPerson(): TPersonDemo;
    function GetPersonrecord(): TPersonrecord;
    // 返回结果 [{name: "范联满0", age: 32}, {name: "范联满1", age: 32}]
    function GetPersonListT(): TList<TPersonDemo>;
    function GetPersonListBigT(): TList<TPersonDemo>;
    // 返回结果 [{name: "范联满0", age: 32}, {name: "范联满1", age: 32}]
    function GetPersonObjListT(): TObjectList<TPersonDemo>;
    // TList只支持 item是对象
    // 建议用泛型 TList<T>,支持的更好
    // 返回结果 [{name: "范联满0", age: 32}, {name: "范联满1", age: 32}]
    function GetPersonList(): TList;
    // 建议用泛型 TList<T>,支持的更好
    // 返回结果 [{name: "范联满0", age: 32}, {name: "范联满1", age: 32}]
    function GetPersonObjList(): TObjectList;
    // 返回结果 [0,1,2,3,4,5]
    function GetIntListT(): TList<integer>;
    // 返回值以DataSet,返回结果 [{name: "范联满0", age: 32}, {name: "范联满1", age: 32}]
    function GetDataSet(): TFDMemTable;

    // 以OneGet开头只支持get访问,参数name取自url参数
    function OneGetName(name: string): string;
    // 以OneGet开头只支持get访问,参数name，age取自url参数
    function OneGetPerson(name: string; age: integer): TPersonDemo;
    // 以OnePost开头只支持post访问,参数name,age取自提交的JSON数据{name: "范联满1", age: 32}
    function OnePostPerson(name: string; age: integer): TPersonDemo;
    // 以OnePost开头只支持post访问,参数name,age取自提交的JSON数据{name: "范联满1", age: 32}反射成類 TPersonDemo
    // 底程負責釋放參數person用完自已釋壙
    function OnePostPersonClass(person: TPersonDemo): TPersonDemo;
    // 以OnePost开头只支持post访问,混合参数person,name取自提交的JSON数据{person:{name: "范联满1", age: 32},name:"范联满2"}反射成類 TPersonDemo
    // 底程負責釋放參數person用完自已釋壙
    function OnePostPersonB(person: TPersonDemo; name: string): TPersonDemo;
    // 提交一个数组 [{"name":"flm","age":18},{"name":"flm2","age":18},{"name":"flm3","age":18}]
    // 返回结果:[{"name":"flm","age":18},{"name":"flm2","age":18},{"name":"flm3","age":18}]
    function OnePostPersonList(persons: TList<TPersonDemo>): TList<TPersonDemo>;
    // 圈套类 TPersonResult对象含有对象属性
    function OneGetPersonResult(): TPersonResult;
    // 圈套类 提交的数据 TPersonResult对象含有对象属性
    // 在 TPersonResult.create要先创建好 FPerson :=  TPersonDemo.Create; 方可接收参数
    function OnePostPersonResult(personResult: TPersonResult): string;

    // 圈套类 TPersonResult对象含有对象属性
    function OneGetPersonListResult(): TPersonListResult;
    // 圈套类 提交的数据 TPersonResult对象含有对象属性
    // 在 TPersonResult.create要先创建好 FPerson :=  TPersonDemo.Create; 方可接收参数
    function OnePostPersonListResult(personListResult: TPersonListResult): string;
  end;

function CreateNewDemoController(QRouterItem: TOneRouterWorkItem): TObject;
// 方法类型注册
procedure HelloWorldEven(QHTTPCtxt: THTTPCtxt; QHTTPResult: THTTPResult);

implementation

constructor TPersonResult.Create;
begin
  inherited Create;
  // 如果JSON转类,需要预先创建属性
  FPerson := TPersonDemo.Create;
end;

destructor TPersonResult.Destroy;
begin
  if FPerson <> nil then
  begin
    FPerson.Free;
    FPerson := nil;
  end;
  inherited Destroy;
end;

constructor TPersonListResult.Create;
begin
  inherited Create;
  self.FPersons := TList<TPersonDemo>.Create;
end;

destructor TPersonListResult.Destroy;
var
  i: integer;
begin
  if self.FPersons <> nil then
  begin
    for i := 0 to FPersons.Count - 1 do
    begin
      FPersons[i].Free;
    end;
    FPersons.Clear;
    FPersons.Free;
  end;
  inherited Destroy;
end;

procedure TDemoController.OneGetHelloWorld(QHTTPCtxt: THTTPCtxt; QHTTPResult: THTTPResult);
begin
  QHTTPResult.ResultRedirect := 'https://baidu.com';
end;

procedure TDemoController.HelloWorld(QHTTPCtxt: THTTPCtxt; QHTTPResult: THTTPResult);
begin
  // 默认JSON输出，ResultData=QHTTPResult.ResultOut;
  // 最终结果:{ResultCode: "0001", ResultMsg: "", ResultCount: 0, ResultData: "欢迎来到HelloWorld"}
  QHTTPResult.ResultOut := '欢迎来到HelloWorld';
  QHTTPResult.SetHTTPResultTrue();
end;

procedure TDemoController.HelloWorldStr(QHTTPCtxt: THTTPCtxt; QHTTPResult: THTTPResult);
begin
  QHTTPResult.ResultOut := '欢迎来到HelloWorld';
  // 最终结果只输出文本:欢迎来到HelloWorld
  QHTTPResult.ResultOutMode := THTTPResultMode.TEXT;
  QHTTPResult.SetHTTPResultTrue();
end;

procedure TDemoController.GetFile(QHTTPCtxt: THTTPCtxt; QHTTPResult: THTTPResult);
begin
  QHTTPResult.ResultOutMode := THTTPResultMode.OUTFILE;
  QHTTPResult.ResultOut := 'C:\Users\Administrator\Pictures\测试ABCD47030062.bmp';
  QHTTPCtxt.AddCustomerHead('Content-Disposition', 'attachment;filename=' + TPath.GetFileName(QHTTPResult.ResultOut));
end;

procedure TDemoController.person(QHTTPCtxt: THTTPCtxt; QHTTPResult: THTTPResult);
var
  lPersonDemo: TPersonDemo;
begin
  // 默认Json输出,ResultData= QHTTPResult.ResultObj;
  // 最终结果:{ResultCode: "0001", ResultMsg: "", ResultCount: 0, ResultData: {name: "范联满flm123", aag: 32}}
  lPersonDemo := TPersonDemo.Create;
  lPersonDemo.name := '范联满flm123';
  lPersonDemo.age := 32;
  // lPersonDemo注意无需释放,当底程 THTTPResult.Destroy 时会释放 ResultObj对象
  QHTTPResult.ResultObj := lPersonDemo;
  QHTTPResult.SetHTTPResultTrue();
end;

// 返回字符串
function TDemoController.GetStr(): string;
begin
  result := '欢迎来到函数返回世界';
end;

// 返回整型
function TDemoController.GetInt(): integer;
begin
  result := 10000;
end;

// 返回一个对象
function TDemoController.GetPerson(): TPersonDemo;
var
  lPersonDemo: TPersonDemo;
begin
  lPersonDemo := TPersonDemo.Create;
  lPersonDemo.name := '范联满flm123';
  lPersonDemo.age := 32;
  lPersonDemo.Parent :='爸爸';
  result := lPersonDemo;
end;

function TDemoController.GetPersonrecord(): TPersonrecord;
begin
  result.name := '范联满';
  result.age := 32;
end;

function TDemoController.GetPersonListT(): TList<TPersonDemo>;
var
  lPersonDemo: TPersonDemo;
  lList: TList<TPersonDemo>;
  i: integer;
begin
  lList := TList<TPersonDemo>.Create;
  for i := 0 to 9 do
  begin
    lPersonDemo := TPersonDemo.Create;
    lPersonDemo.name := '范联满' + i.ToString;
    lPersonDemo.age := 32;
    lList.Add(lPersonDemo);
  end;
  result := lList;
end;

function TDemoController.GetPersonListBigT(): TList<TPersonDemo>;
var
  lPersonDemo: TPersonDemo;
  lList: TList<TPersonDemo>;
  i: integer;
begin
  lList := TList<TPersonDemo>.Create;
  // 一次返回10万数据
  for i := 0 to 99999 do
  begin
    lPersonDemo := TPersonDemo.Create;
    lPersonDemo.name := '范联满' + i.ToString;
    lPersonDemo.age := 32;
    lList.Add(lPersonDemo);
  end;
  result := lList;
end;

function TDemoController.GetPersonObjListT(): TObjectList<TPersonDemo>;
var
  lPersonDemo: TPersonDemo;
  lList: TObjectList<TPersonDemo>;
  i: integer;
begin
  lList := TObjectList<TPersonDemo>.Create;
  for i := 0 to 9 do
  begin
    lPersonDemo := TPersonDemo.Create;
    lPersonDemo.name := '范联满' + i.ToString;
    lPersonDemo.age := 32;
    lList.Add(lPersonDemo);
  end;
  result := lList;
end;

function TDemoController.GetPersonList(): TList;
var
  lPersonDemo: TPersonDemo;
  lList: TList;
  i: integer;
begin
  lList := TList.Create;
  for i := 0 to 9 do
  begin
    lPersonDemo := TPersonDemo.Create;
    lPersonDemo.name := '范联满' + i.ToString;
    lPersonDemo.age := 32;
    lList.Add(lPersonDemo);
  end;
  result := lList;
end;

function TDemoController.GetPersonObjList(): TObjectList;
var
  lPersonDemo: TPersonDemo;
  lList: TObjectList;
  i: integer;
begin
  result := nil;
  lList := TObjectList.Create;
  for i := 0 to 9 do
  begin
    lPersonDemo := TPersonDemo.Create;
    lPersonDemo.name := '范联满' + i.ToString;
    lPersonDemo.age := 32;
    lList.Add(lPersonDemo);
  end;
  result := lList;
end;

function TDemoController.GetIntListT(): TList<integer>;
var
  lList: TList<integer>;
  i: integer;
begin
  lList := TList<integer>.Create;
  for i := 0 to 9 do
  begin
    lList.Add(i);
  end;
  result := lList;
end;

// 返回值以DataSet
function TDemoController.GetDataSet(): TFDMemTable;
var
  i: integer;
begin
  result := TFDMemTable.Create(nil);
  result.FieldDefs.Add('name', ftString, 20, false);
  result.FieldDefs.Add('age', ftInteger, 0, True);
  result.CreateDataSet();
  for i := 0 to 9 do
  begin
    result.Append;
    result.FieldByName('name').AsString := 'flm' + i.ToString();
    result.FieldByName('age').AsInteger := i;
    result.Post;
  end;
end;

// 无参数，多例模式
procedure TDemoController.TestNoParam();
var
  lUrl: string;
begin
  // 多例模式  HTTPCtxt,HTTPResult多是独立的
  lUrl := self.HTTPCtxt.URL;
  self.HTTPResult.ResultOut := lUrl;
  self.HTTPResult.SetHTTPResultTrue();
end;

function TDemoController.TestStr(): string;
begin
  result := 'TestStr';
end;

function TDemoController.TestStrList(qList: TList<string>): string;
var
  tempStr: string;
  i: integer;
begin
  for i := 0 to qList.Count - 1 do
  begin
     tempStr := tempStr+','+ qList[i];
  end;
  result := tempStr;
end;

function TDemoController.OneGetName(name: string): string;
begin
  result := '上传的Url参数name=' + name;
end;

function TDemoController.OneGetPerson(name: string; age: integer): TPersonDemo;
var
  lPersonDemo: TPersonDemo;
begin
  lPersonDemo := TPersonDemo.Create;
  lPersonDemo.name := name;
  lPersonDemo.age := age;
  lPersonDemo.Parent := '爸爸';
  result := lPersonDemo;
end;

// 以OnePost开头只支持post访问,参数name,age取自提交的JSON数据{name: "范联满1", age: 32}
function TDemoController.OnePostPerson(name: string; age: integer): TPersonDemo;
var
  lPersonDemo: TPersonDemo;
begin
  lPersonDemo := TPersonDemo.Create;
  lPersonDemo.name := name;
  lPersonDemo.age := age;
  result := lPersonDemo;
end;

// 以OnePost开头只支持post访问,参数直接取自提交的JSON数据{name: "范联满1", age: 32}反射成類 TPersonDemo
function TDemoController.OnePostPersonClass(person: TPersonDemo): TPersonDemo;
var
  lPersonDemo: TPersonDemo;
begin
  //
  lPersonDemo := TPersonDemo.Create;
  lPersonDemo.name := person.name;
  lPersonDemo.age := person.age;
  // person，lPersonDemo 底程負責釋放,无需手动释放
  result := lPersonDemo;
end;

// 混合参数
// 以OnePost开头只支持post访问,混合参数person,name取自提交的JSON数据{person:{name: "范联满1", age: 32},name:"范联满2"}反射成類 TPersonDemo
function TDemoController.OnePostPersonB(person: TPersonDemo; name: string): TPersonDemo;
var
  lPersonDemo: TPersonDemo;
begin
  //
  lPersonDemo := TPersonDemo.Create;
  lPersonDemo.name := person.name + '_' + name;
  lPersonDemo.age := person.age;
  // person，lPersonDemo 底程負責釋放,无需手动释放
  result := lPersonDemo;
end;

function TDemoController.OnePostPersonList(persons: TList<TPersonDemo>): TList<TPersonDemo>;
var
  lPersonDemo: TPersonDemo;
  i: integer;
begin
  result := TList<TPersonDemo>.Create;
  for i := 0 to persons.Count - 1 do
  begin
    lPersonDemo := TPersonDemo.Create;
    lPersonDemo.name := persons[i].name;
    lPersonDemo.age := persons[i].age;
    result.Add(lPersonDemo);
  end;
end;

function TDemoController.OneGetPersonResult(): TPersonResult;
begin
  result := TPersonResult.Create;
  result.resultCode := '123';
  result.resultMsg := '哈哈哈';
  // 记得重写 TPersonResult 释放时要判断 person是不是为nil
  // 底程释圹只释圹 TPersonResult.free;
  result.person.name := 'flm';
  result.person.age := 19;
end;

function TDemoController.OnePostPersonResult(personResult: TPersonResult): string;
begin
  result := '收到数据成功 code->' + personResult.resultCode;
  if personResult.person <> nil then
  begin
    result := result + ';name->' + personResult.person.name;
  end;
end;

function TDemoController.OneGetPersonListResult(): TPersonListResult;
var
  lPersonDemo: TPersonDemo;
  i: integer;
begin
  result := TPersonListResult.Create;
  result.resultCode := '123';
  result.resultMsg := '哈哈哈';
  for i := 0 to 9 do
  begin
    lPersonDemo := TPersonDemo.Create;
    lPersonDemo.name := 'flm';
    lPersonDemo.age := 18;
    result.persons.Add(lPersonDemo)
  end;

end;

function TDemoController.OnePostPersonListResult(personListResult: TPersonListResult): string;
begin
  result := '收到数据成功 code->' + personListResult.resultCode;
  if personListResult.persons <> nil then
  begin
    result := result + ';count->' + personListResult.persons.Count.ToString();
  end;
end;

function CreateNewDemoController(QRouterItem: TOneRouterWorkItem): TObject;
var
  lController: TDemoController;
begin
  // 自定义创建控制器类，否则会按 TPersistentclass.create
  // 最好自定义一个好
  lController := TDemoController.Create;
  // 挂载RTTI信息
  lController.RouterItem := QRouterItem;
  result := lController;
end;

procedure HelloWorldEven(QHTTPCtxt: THTTPCtxt; QHTTPResult: THTTPResult);
begin
  QHTTPResult.ResultOut := '欢迎来到HelloWorldEven';
end;

// 注册到路由
initialization

// 注意，路由名称 不要一样，否则会判定已注册过，跳过
// 多例模式注册
OneHttpRouterManage.GetInitRouterManage().AddHTTPPoolWork('DemoA', TDemoController, 100, CreateNewDemoController);
// 单例模式注册
OneHttpRouterManage.GetInitRouterManage().AddHTTPSingleWork('DemoB', TDemoController, 100, CreateNewDemoController);
// 方法注册
OneHttpRouterManage.GetInitRouterManage().AddHTTPEvenWork('DemoEven', HelloWorldEven, 10);

finalization

end.

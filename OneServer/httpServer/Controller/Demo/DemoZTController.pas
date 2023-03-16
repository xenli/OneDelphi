unit DemoZTController;

// 结果返回是jsonobject,jsonArray事例
interface

uses OneHttpController, OneHttpCtxtResult, OneHttpRouterManage, System.SysUtils,
  System.Generics.Collections, System.Contnrs, System.Classes,
  FireDAC.Comp.Client, Data.DB, System.JSON, OneControllerResult;

type
  TDemoZTController = class(TOneControllerBase)
  public
    // 返回结果 [{"name":"flm0"},{"name":"flm1"},{"name":"flm2"}]
    function GetData(): TActionResult<TFDMemtable>;
    function SaveData(QPersons: TList<TPersonDemo>): TActionResult<string>;
  end;

function CreateNewDemoZTController(QRouterItem: TOneRouterWorkItem): TObject;

implementation

uses OneGlobal, OneZTManage;

function CreateNewDemoZTController(QRouterItem: TOneRouterWorkItem): TObject;
var
  lController: TDemoZTController;
begin
  // 自定义创建控制器类，否则会按 TPersistentclass.create
  // 最好自定义一个好
  lController := TDemoZTController.Create;
  // 挂载RTTI信息
  lController.RouterItem := QRouterItem;
  result := lController;
end;

function TDemoZTController.GetData(): TActionResult<TFDMemtable>;
var
  i: integer;
  lOneZTMange: TOneZTManage;
  lZTItem: TOneZTItem;
  lErrMsg: string;
  lConnection: TFDConnection;
  lFDQuery: TFDQuery;
begin
  // true:TFDMemtable需要释放,true:无item LIST 这种的，无效
  result := TActionResult<TFDMemtable>.Create(true, true);
  lOneZTMange := TOneGlobal.GetInstance().ZTManage;
  // 账套为空时,默认取主账套
  lZTItem := lOneZTMange.LockZTItem('', lErrMsg);
  if lZTItem = nil then
  begin
    result.ResultMsg := lErrMsg;
    exit;
  end;
  try
    // 从账套直接获取现成的连接
    lConnection := lZTItem.ADConnection;
    // 从账套获取现成的FDQuery,已绑定好 connetion,也无需释放
    lFDQuery := lZTItem.ADQuery;
    lFDQuery.SQL.Text :=
      'select ''范联满'' as Name, 18 as age union all select ''范联满''  , 18 ';
    // 打开数据
    try
      lFDQuery.Open;
      result.ResultData := TFDMemtable.Create(nil);
      result.ResultData.Data := lFDQuery.Data;
      result.SetResultTrue();
    except
      on e: Exception do
      begin
        result.ResultMsg := '打开数据发生异常:' + e.Message;
        exit;
      end;
    end;
  finally
    // 解锁,归还池
    lZTItem.UnLockWork;
  end;
end;

function TDemoZTController.SaveData(QPersons: TList<TPersonDemo>)
  : TActionResult<string>;
var
  i, iErr: integer;
  lOneZTMange: TOneZTManage;
  lZTItem: TOneZTItem;
  lErrMsg: string;
  lConnection: TFDConnection;
  lFDQuery: TFDQuery;
  isCommit: boolean;
begin
  // true:TFDMemtable需要释放,true:无item LIST 这种的，无效
  result := TActionResult<string>.Create(true, true);
  iErr := 0;
  lOneZTMange := TOneGlobal.GetInstance().ZTManage;
  // 账套为空时,默认取主账套
  lZTItem := lOneZTMange.LockZTItem('', lErrMsg);
  if lZTItem = nil then
  begin
    result.ResultMsg := lErrMsg;
    exit;
  end;
  // 从账套直接获取现成的连接
  isCommit := false;
  lConnection := lZTItem.ADConnection;
  lConnection.StartTransaction();
  try
    // 从账套获取现成的FDQuery,已绑定好 connetion,也无需释放
    lFDQuery := lZTItem.ADQuery;
    // 保存的表名,你要有这张表
    lFDQuery.UpdateOptions.UpdateTableName := 'person';
    // 主键直接name当主键,测试
    lFDQuery.UpdateOptions.KeyFields := 'name';
    lFDQuery.SQL.Text := 'select * from person where 1=2';
    try
      // 打开数据
      lFDQuery.Open;
      for i := 0 to QPersons.Count - 1 do
      begin
        lFDQuery.Append;
        lFDQuery.FieldByName('name').AsString := QPersons[i].name;
        lFDQuery.FieldByName('age').AsInteger := QPersons[i].age;
        lFDQuery.Post;
      end;
      if lFDQuery.State in dsEditModes then
        lFDQuery.Post;
      iErr := lFDQuery.ApplyUpdates(0);
      if iErr <> 0 then
      begin
        result.ResultMsg := '异常错误,请检查';
        exit;
      end;
      result.ResultMsg := '保存数据成功';
      result.SetResultTrue();
      lConnection.Commit;
      isCommit := true;
    except
      on e: Exception do
      begin
        result.ResultMsg := '保存数据发生异常:' + e.Message;
        exit;
      end;
    end;
  finally
    // 解锁,归还池
    if not isCommit then
    begin
      lConnection.Rollback;
    end;
    lZTItem.UnLockWork;
  end;
end;

// 注册到路由
initialization

// 注意，路由名称 不要一样，否则会判定已注册过，跳过
// 多例模式注册
OneHttpRouterManage.GetInitRouterManage().AddHTTPPoolWork('DemoZT',
  TDemoZTController, 0, CreateNewDemoZTController);

finalization

end.

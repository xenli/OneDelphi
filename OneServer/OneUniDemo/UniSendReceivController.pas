unit UniSendReceivController;

interface

uses
  system.StrUtils, system.SysUtils, Math, system.JSON, system.Threading, system.Classes,
  OneHttpController, OneHttpRouterManage, OneHttpCtxtResult, OneTokenManage, OneHttpConst,
  system.Generics.Collections, OneControllerResult, FireDAC.Comp.Client, Data.DB, OneGuID,
  OneMultipart, UniClass;

type

  TUniSendReceivController = class(TOneControllerBase)
  public
    function GetSendReceivList(pageIndex: integer; pageSize: integer; custtype: string; custInfo: string): TActionResult<TFDMemtable>;
    function GetSendReceiv(QCustomerID: string): TActionResult<TSendReceivDemo>;
    function SaveSendReceiv(QCustomer: TSendReceivDemo): TActionResult<string>;
  end;

function CreateNewSendReceivController(QRouterItem: TOneRouterWorkItem): TObject;

implementation

uses OneGlobal, OneZTManage;

function CreateNewSendReceivController(QRouterItem: TOneRouterWorkItem): TObject;
var
  lController: TUniSendReceivController;
begin
  // 自定义创建控制器类，否则会按 TPersistentclass.create
  // 最好自定义一个好
  lController := TUniSendReceivController.Create;
  // 挂载RTTI信息
  lController.RouterItem := QRouterItem;
  result := lController;
end;

function TUniSendReceivController.GetSendReceivList(pageIndex: integer; pageSize: integer; custtype: string; custInfo: string): TActionResult<TFDMemtable>;
var
  lZTItem: TOneZTItem;
  lFDQuery: TFDQuery;
  lOneTokenItem: TOneTokenItem;
  lOneZTMange: TOneZTManage;
  lOneTokenManage: TOneTokenManage;
  lGoodDemo: TGoodsDemo;
  lErrMsg: string;
begin
  result := TActionResult<TFDMemtable>.Create(true, false);
  // 获取用户Token信息,跟据当前线程ID,无需通过参数
  lOneTokenItem := self.GetCureentToken(lErrMsg);
  if lOneTokenItem = nil then
  begin
    result.SetTokenFail();
    exit;
  end;
  lOneZTMange := TOneGlobal.GetInstance().ZTManage;
  lZTItem := lOneZTMange.LockZTItem(lOneTokenItem.ZTCode, lErrMsg);
  if lZTItem = nil then
  begin
    result.resultMsg := lErrMsg;
    exit;
  end;

  try
    try
      // 理论查询用orm最好的
      // 从账套获取现成的FDQuery,已绑定好 connetion,也无需释放
      lFDQuery := lZTItem.ADQuery;
      // 查询所有
      if custInfo = '' then
      begin
        lFDQuery.SQL.Text := 'select * from demo_sendreceiv where FCustomerType=:FCustomerType order by FCreateTime desc ';
        lFDQuery.Params[0].AsString := custtype;
      end
      else
      begin
        // 相拟查询
        lFDQuery.SQL.Text := 'select * from demo_sendreceiv ' + ' where FCustomerType=:FCustomerType and  ( FCustomerCode like :custInfo or FCustomerName like :custInfo ) order by FCreateTime desc ';
        lFDQuery.Params[0].AsString := custtype;
        lFDQuery.Params[1].AsString := '%' + custInfo + '%';
      end;
      // 分页设置
      if (pageSize > 0) and (pageIndex > 0) then
      begin
        lFDQuery.FetchOptions.RecsSkip := (pageIndex - 1) * pageSize;
        lFDQuery.FetchOptions.RecsMax := pageSize;
      end
      else
      begin
        lFDQuery.FetchOptions.RecsSkip := -1;
        if pageSize > 0 then
          lFDQuery.FetchOptions.RecsMax := pageSize
        else
          lFDQuery.FetchOptions.RecsMax := 50;
      end;
      lFDQuery.Open;
      result.resultData := TFDMemtable.Create(nil);
      // lFDQuery是池中的数据集，不能放出去用。要COPY下数据
      result.resultData.Data := lFDQuery.Data;
      //
      result.SetResultTrue;
    except
      on e: Exception do
      begin
        result.resultMsg := '发生异常,原因:' + e.Message;
      end;
    end;
  finally
    // 解锁,归还池很重要
    lZTItem.UnLockWork;
  end;
end;

function TUniSendReceivController.GetSendReceiv(QCustomerID: string): TActionResult<TSendReceivDemo>;
var
  lZTItem: TOneZTItem;
  lFDQuery: TFDQuery;
  lOneTokenItem: TOneTokenItem;
  lOneZTMange: TOneZTManage;
  lOneTokenManage: TOneTokenManage;
  lSendReceivDemo: TSendReceivDemo;
  lErrMsg: string;
begin
  result := TActionResult<TSendReceivDemo>.Create(true, false);
  if QCustomerID = '' then
  begin
    result.resultMsg := '请上传参数{"QCustomerID":"值"}';
    exit;
  end;
  // 获取用户Token信息,跟据当前线程ID,无需通过参数
  lOneTokenItem := self.GetCureentToken(lErrMsg);
  if lOneTokenItem = nil then
  begin
    result.SetTokenFail();
    exit;
  end;
  lOneZTMange := TOneGlobal.GetInstance().ZTManage;
  lZTItem := lOneZTMange.LockZTItem(lOneTokenItem.ZTCode, lErrMsg);
  if lZTItem = nil then
  begin
    result.resultMsg := lErrMsg;
    exit;
  end;

  try
    try
      // 理论查询用orm最好的
      // 从账套获取现成的FDQuery,已绑定好 connetion,也无需释放
      lFDQuery := lZTItem.ADQuery;
      // 查询所有
      lFDQuery.SQL.Text := 'select * from demo_sendreceiv where FCustomerID=:FCustomerID';
      lFDQuery.Params[0].AsString := QCustomerID;
      lFDQuery.Open;
      if lFDQuery.RecordCount = 0 then
      begin
        result.resultMsg := '不存在当前ID的商品数据';
        exit;
      end;
      lSendReceivDemo := TSendReceivDemo.Create();
      result.resultData := lSendReceivDemo;
      lSendReceivDemo.FCustomerID := lFDQuery.FieldByName('FCustomerID').AsString;
      lSendReceivDemo.FCustomerCode := lFDQuery.FieldByName('FCustomerCode').AsString;
      lSendReceivDemo.FCustomerName := lFDQuery.FieldByName('FCustomerName').AsString;
      lSendReceivDemo.FCustomerType := lFDQuery.FieldByName('FCustomerType').AsString;
      lSendReceivDemo.FCustomerLXR := lFDQuery.FieldByName('FCustomerLXR').AsString;
      lSendReceivDemo.FCustomerTel := lFDQuery.FieldByName('FCustomerTel').AsString;
      lSendReceivDemo.FCustomerRemark := lFDQuery.FieldByName('FCustomerRemark').AsString;
      lSendReceivDemo.FCreateID := lFDQuery.FieldByName('FCreateID').AsString;
      lSendReceivDemo.FCreateName := lFDQuery.FieldByName('FCreateName').AsString;
      lSendReceivDemo.FCreateTime := FormatDateTime('yyyy-MM-dd hh:mm:ss', lFDQuery.FieldByName('FCreateTime').AsDateTime);
      //
      result.SetResultTrue;
    except
      on e: Exception do
      begin
        result.resultMsg := '发生异常,原因:' + e.Message;
      end;
    end;
  finally
    // 解锁,归还池很重要
    lZTItem.UnLockWork;
  end;
end;

function TUniSendReceivController.SaveSendReceiv(QCustomer: TSendReceivDemo): TActionResult<string>;
var
  lZTItem: TOneZTItem;
  lFDQuery: TFDQuery;
  lOneTokenItem: TOneTokenItem;
  lOneZTMange: TOneZTManage;
  lOneTokenManage: TOneTokenManage;
  lGoodDemo: TGoodsDemo;
  lErrMsg: string;
  pageSize, pageIndex: integer;
  goodInfo: string;
  isCommit: boolean;
  iCommit, iErr: integer;
begin
  // 多不释放,result.data := QGood,由参数自已释放
  result := TActionResult<string>.Create(true, false);
  // 检验数据
  if QCustomer.FCustomerType = '' then
  begin
    result.resultMsg := '客户类别不可为空';
    exit;
  end;

  if QCustomer.FCustomerCode = '' then
  begin
    result.resultMsg := QCustomer.FCustomerType + '代码不可为空';
    exit;
  end;

  if QCustomer.FCustomerName = '' then
  begin
    result.resultMsg := QCustomer.FCustomerType + '名称不可为空';
    exit;
  end;

  // 获取用户Token信息,跟据当前线程ID,无需通过参数
  lOneTokenItem := self.GetCureentToken(lErrMsg);
  if lOneTokenItem = nil then
  begin
    result.SetTokenFail();
    exit;
  end;
  lOneZTMange := TOneGlobal.GetInstance().ZTManage;
  lZTItem := lOneZTMange.LockZTItem(lOneTokenItem.ZTCode, lErrMsg);
  if lZTItem = nil then
  begin
    result.resultMsg := lErrMsg;
    exit;
  end;

  try
    isCommit := false;
    lZTItem.ADConnection.StartTransaction;
    try
      // 主键有值说明是编辑,无值说明是新增
      QCustomer.SetRowState(QCustomer.FCustomerID);
      // 理论查询用orm最好的
      // 从账套获取现成的FDQuery,已绑定好 connetion,也无需释放
      lFDQuery := lZTItem.ADQuery;
      lFDQuery.UpdateOptions.UpdateTableName := 'demo_sendreceiv'; // 设置表名
      lFDQuery.UpdateOptions.KeyFields := 'FCustomerID'; // 设置主键
      //
      lFDQuery.UpdateOptions.UpdateMode := TUpdateMode.upWhereKeyOnly; // 设置更新模式
      if QCustomer.GetRowState = emRowstate.insertState then
      begin
        // 打开一个空数据集
        lFDQuery.SQL.Text := 'select *  from demo_sendreceiv where 1=2';
      end
      else
      begin
        // 相拟查询
        lFDQuery.SQL.Text := 'select *  from demo_sendreceiv where FCustomerID=:FCustomerID';
        lFDQuery.Params[0].AsString := QCustomer.FCustomerID;
      end;
      lFDQuery.Open;
      if QCustomer.GetRowState = emRowstate.insertState then
      begin
        // 新增相关东东赋值下
        QCustomer.FCustomerID := OneGuID.GetGUID32;
        QCustomer.FCreateTime := FormatDateTime('yyyy-MM-dd hh:mm:ss', now);
        QCustomer.FCreateID := lOneTokenItem.SysUserID;
        QCustomer.FCreateName := lOneTokenItem.SysUserName;
        lFDQuery.Append;
        lFDQuery.FieldByName('FCustomerID').AsString := QCustomer.FCustomerID;
        lFDQuery.FieldByName('FCustomerCode').AsString := QCustomer.FCustomerCode;
        lFDQuery.FieldByName('FCustomerName').AsString := QCustomer.FCustomerName;
        lFDQuery.FieldByName('FCustomerType').AsString := QCustomer.FCustomerType;
        lFDQuery.FieldByName('FCustomerLXR').AsString := QCustomer.FCustomerLXR;
        lFDQuery.FieldByName('FCustomerTel').AsString := QCustomer.FCustomerTel;
        lFDQuery.FieldByName('FCustomerRemark').AsString := QCustomer.FCustomerRemark;
        lFDQuery.FieldByName('FCreateID').AsString := QCustomer.FCreateID;
        lFDQuery.FieldByName('FCreateName').AsString := QCustomer.FCreateName;
        lFDQuery.FieldByName('FCreateTime').AsString := QCustomer.FCreateTime;
        lFDQuery.post;
      end
      else
      begin
        // 编辑相关东东
        if lFDQuery.RecordCount = 0 then
        begin
          result.resultMsg := '数据不存在,请检查';
          exit;
        end;
        lFDQuery.edit;
        // lFDQuery.FieldByName('FCustomerID').AsString := QCustomer.FCustomerID;
        lFDQuery.FieldByName('FCustomerCode').AsString := QCustomer.FCustomerCode;
        lFDQuery.FieldByName('FCustomerName').AsString := QCustomer.FCustomerName;
        // lFDQuery.FieldByName('FCustomerType').AsString := QCustomer.FCustomerType;
        lFDQuery.FieldByName('FCustomerLXR').AsString := QCustomer.FCustomerLXR;
        lFDQuery.FieldByName('FCustomerTel').AsString := QCustomer.FCustomerTel;
        lFDQuery.FieldByName('FCustomerRemark').AsString := QCustomer.FCustomerRemark;
        // lFDQuery.FieldByName('FCreateID').AsString := QCustomer.FCreateID;
        // lFDQuery.FieldByName('FCreateName').AsString := QCustomer.FCreateName;
        // lFDQuery.FieldByName('FCreateTime').AsString := QCustomer.FCreateTime;
        lFDQuery.FieldByName('FCustomerType').ProviderFlags := [];
        lFDQuery.FieldByName('FCreateID').ProviderFlags := [];
        lFDQuery.FieldByName('FCreateName').ProviderFlags := [];
        lFDQuery.FieldByName('FCreateTime').ProviderFlags := [];
        lFDQuery.post;
      end;
      iErr := lFDQuery.ApplyUpdates(-1);
      if iErr <> 0 then
      begin
        result.resultMsg := '更新数据有误,错误行数' + iErr.ToString;
        exit;
      end;
      // iCommit := lFDQuery.RowsAffected;
      // if iCommit <> 1 then
      // begin
      // result.resultMsg := '更新数据有误,影响行数不为1,当前影响行数' + iCommit.ToString;
      // exit;
      // end;
      lZTItem.ADConnection.Commit;
      isCommit := true;
      result.resultData := QCustomer.FCustomerID;
      result.SetResultTrue;
    except
      on e: Exception do
      begin
        result.resultMsg := '发生异常,原因:' + e.Message;
      end;
    end;
  finally

    if not isCommit then
    begin
      lZTItem.ADConnection.Rollback;
    end;
    // 解锁,归还池很重要
    lZTItem.UnLockWork;
  end;
end;

initialization

// 单例模式注册
OneHttpRouterManage.GetInitRouterManage().AddHTTPSingleWork('/UniDemo/SendReceiv', TUniSendReceivController, 0, CreateNewSendReceivController);

finalization

end.

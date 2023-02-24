unit UniDemoController;

interface

uses
  system.StrUtils, system.SysUtils, Math, system.JSON, system.Threading, system.Classes,
  OneHttpController, OneHttpRouterManage, OneHttpCtxtResult, OneTokenManage, OneHttpConst,
  system.Generics.Collections, OneControllerResult, FireDAC.Comp.Client, Data.DB, OneGuID,
  OneMultipart;

type
  TLoginInfo = class
  private
    FloginCode: string; // 登陆代码
    FloginPass: string; // 登陆密码
    FloginZTCode: string; // 指定登陆账套
    FtokenID: string; // 返回去的TokenID
    FprivateKey: string; // 返回去的私钥
    FUserName: string; // 返回去的用户名称
    // 如果有其它信息自已加，本示例只是个demo
  published
    // 前后端参数及返回结果大写小请保证一至 ,不要问我为什么JSON是区分大小写的,
    property loginCode: string read FloginCode write FloginCode;
    property loginPass: string read FloginPass write FloginPass;
    property loginZTCode: string read FloginZTCode write FloginZTCode;
    property tokenID: string read FtokenID write FtokenID;
    property privateKey: string read FprivateKey write FprivateKey;
    property userName: string read FUserName write FUserName;
  end;

  // 商品资料
  TGoodsDemo = class(TOneOrmRowState)
  private
    FGoodsID_: string;
    FGoodsCode_: string;
    FGoodsName_: string;
    FGoodsPrice_: double;
    FGoodsRemark_: string;
    FGoodsImgUrl_: string;
  published
    // 前后端参数及返回结果大写小请保证一至 ,不要问我为什么JSON是区分大小写的,
    // 如果懒得数据库字段转化,请保持数据库字段也是一至的
    property FGoodsID: string read FGoodsID_ write FGoodsID_;
    property FGoodsCode: string read FGoodsCode_ write FGoodsCode_;
    property FGoodsName: string read FGoodsName_ write FGoodsName_;
    property FGoodsPrice: double read FGoodsPrice_ write FGoodsPrice_;
    property FGoodsRemark: string read FGoodsRemark_ write FGoodsRemark_;
    property FGoodsImgUrl: string read FGoodsImgUrl_ write FGoodsImgUrl_;
  end;

  // 订单资料
  TBillDemo = class(TOneOrmRowState)
  private
    FBillID_: string;
    FBillNo_: string;
    FBillType_: string;
    FBillSenderID_: string;
    FBillSenderCode_: string;
    FBillSenderName_: string;
    FBillSenderTel_: string;
    FBillSenderAddress_: string;
    FBillReceivID_: string;
    FBillReceivCode_: string;
    FBillReceivName_: string;
    FBillReceivTel_: string;
    FBillReceivAddress_: string;
    FBillAmount_: double;

  public

  end;

  TUniDemoController = class(TOneControllerBase)
  public
    // 登陆接口
    function Login(QLogin: TLoginInfo): TActionResult<TLoginInfo>;
    // 登出接口
    function LoginOut(QLogin: TLoginInfo): TActionResult<string>;
    // 返回一个商品类表
    function GetGoodDemoList(): TActionResult<TList<TGoodsDemo>>;
    // 返回部份商品数据
    // Json上传{"pageIndex":1,"pageSize":10}
    function GetGoodDemoListPage(pageIndex: integer; pageSize: integer): TActionResult<TList<TGoodsDemo>>;
    // 与数据库结合
    // 返回一个商品类表,跟据 goodInfo过滤相关数据,
    function GetGoodsList(pageIndex: integer; pageSize: integer; goodInfo: string): TActionResult<TFDMemtable>;
    // 返回一个商品类表,跟据传上来的Json数据过滤相关数据
    function GetGoodsListByJson(QJson: TJsonObject): TActionResult<TFDMemtable>;
    // 返回一个商品信息, 上传上来的参数 {"QGoodsID":"参数值"}
    function GetGoods(QGoodsID: string): TActionResult<TGoodsDemo>;

    function SaveGoods(QGoods: TGoodsDemo): TActionResult<TGoodsDemo>;

    // 文件上传
    function PostFile(QFormData: TOneMultipartDecode): TActionResult<string>;
  end;

function CreateNewUniDemoController(QRouterItem: TOneRouterItem): TObject;

implementation

uses OneGlobal, OneZTManage;

function CreateNewUniDemoController(QRouterItem: TOneRouterItem): TObject;
var
  lController: TUniDemoController;
begin
  // 自定义创建控制器类，否则会按 TPersistentclass.create
  // 最好自定义一个好
  lController := TUniDemoController.Create;
  // 挂载RTTI信息
  lController.RouterItem := QRouterItem;
  result := lController;
end;

// 前后端参数及返回结果大写小请保证一至 ,不要问我为什么JSON是区分大小写的,
function TUniDemoController.Login(QLogin: TLoginInfo): TActionResult<TLoginInfo>;
var
  lOneZTMange: TOneZTManage;
  lOneTokenManage: TOneTokenManage;
  lZTItem: TOneZTItem;
  lFDQuery: TFDQuery;
  lOneTokenItem: IOneTokenItem;
  lErrMsg: string;
begin
  result := TActionResult<TLoginInfo>.Create(true, false);
  lErrMsg := '';
  if QLogin.loginCode = '' then
  begin
    result.resultMsg := '用户代码不可为空';
    exit;
  end;
  if QLogin.loginPass = '' then
  begin
    result.resultMsg := '用户密码不可为空';
    exit;
  end;
  // 验证账号密码,比如数据库
  lOneZTMange := TOneGlobal.GetInstance().ZTManage;
  // 账套为空时,默认取主账套,多账套的话可以固定一个账套代码
  lZTItem := lOneZTMange.LockZTItem(QLogin.loginZTCode, lErrMsg);
  if lZTItem = nil then
  begin
    result.resultMsg := lErrMsg;
    exit;
  end;
  try
    // 从账套获取现成的FDQuery,已绑定好 connetion,也无需释放
    lFDQuery := lZTItem.ADQuery;
    // 这边改成你的用户表
    lFDQuery.SQL.Text := 'select FUserID,FUserCode,FUserName,FUserPass from demo_user where FUserCode=:FUserCode';
    lFDQuery.Params[0].AsString := QLogin.loginCode;
    lFDQuery.Open;
    if lFDQuery.RecordCount = 0 then
    begin
      result.resultMsg := '当前用户[' + QLogin.loginCode + ']不存在,请检查';
      exit;
    end;
    if lFDQuery.RecordCount > 1 then
    begin
      result.resultMsg := '当前用户[' + QLogin.loginCode + ']重复,请联系管理员检查数据';
      exit;
    end;
    // 为一条时要验证密码,前端一般是MD5加密的,后端也是保存MD5加密的
    if QLogin.loginPass.ToLower <> lFDQuery.FieldByName('FUserPass').AsString.ToLower then
    begin
      result.resultMsg := '当前用户[' + QLogin.loginCode + ']密码不正确,请检查';
      exit;
    end;
    // 正确增加Token返回相关的toeknID及私钥
    lOneTokenManage := TOneGlobal.GetInstance().TokenManage;
    // true允许同个账号共用token,测试接口共享下防止踢来踢去
    lOneTokenItem := lOneTokenManage.AddLoginToken('uniapp', QLogin.loginCode, true, lErrMsg);
    if lOneTokenItem = nil then
    begin
      result.resultMsg := lErrMsg;
      exit;
    end;
    // 为Token设置相关信息
    lOneTokenItem.SetLoginUserCode(QLogin.loginCode);
    lOneTokenItem.SetZTCode(QLogin.loginZTCode); // 指定账套
    lOneTokenItem.SetSysUserID(lFDQuery.FieldByName('FUserID').AsString);
    lOneTokenItem.SetSysUserName(lFDQuery.FieldByName('FUserName').AsString);
    lOneTokenItem.SetSysUserCode(lFDQuery.FieldByName('FUserCode').AsString);
    // 返回信息设置
    result.resultData := TLoginInfo.Create;
    result.resultData.loginCode := QLogin.loginCode;
    result.resultData.tokenID := lOneTokenItem.tokenID;
    result.resultData.privateKey := lOneTokenItem.privateKey;
    result.resultData.userName := lFDQuery.FieldByName('FUserName').AsString;
    //
    result.SetResultTrue;
  finally
    // 解锁,归还池很重要
    lZTItem.UnLockWork;
  end;
end;

function TUniDemoController.LoginOut(QLogin: TLoginInfo): TActionResult<string>;
var
  lOneGlobal: TOneGlobal;
begin
  result := TActionResult<string>.Create(false, false);
  if QLogin.tokenID = '' then
  begin
    result.resultMsg := 'tokenID为空请上传tokenID';
    exit;
  end;
  lOneGlobal := TOneGlobal.GetInstance();
  lOneGlobal.TokenManage.RemoveToken(QLogin.tokenID);
  result.resultData := 'Token删除成功';
  result.SetResultTrue();
end;

// 返回一个商品类表
function TUniDemoController.GetGoodDemoList(): TActionResult<TList<TGoodsDemo>>;
var
  lGoodDemo: TGoodsDemo;
  lList: TList<TGoodsDemo>;
  i: integer;
begin
  // TList<TGoodsDemo>即List里面的TGoodDemo用完多要设定成释放
  result := TActionResult < TList < TGoodsDemo >>.Create(true, true);
  result.resultData := TList<TGoodsDemo>.Create;
  for i := 1 to 50 do
  begin
    lGoodDemo := TGoodsDemo.Create;
    result.resultData.Add(lGoodDemo);
    lGoodDemo.FGoodsCode := 'code' + i.ToString;
    lGoodDemo.FGoodsName := 'name' + i.ToString;
    lGoodDemo.FGoodsPrice := i * 10;
    lGoodDemo.FGoodsRemark := '商品测试';
  end;
  result.SetResultTrue();
end;

function TUniDemoController.GetGoodDemoListPage(pageIndex: integer; pageSize: integer): TActionResult<TList<TGoodsDemo>>;
var
  lGoodDemo: TGoodsDemo;
  lList: TList<TGoodsDemo>;
  i, iPageTotal: integer;
begin
  // TList<TGoodsDemo>即List里面的TGoodDemo用完多要设定成释放
  result := TActionResult < TList < TGoodsDemo >>.Create(true, true);
  // 假设总共50条
  if pageSize <= 0 then
    pageSize := 10;
  if pageSize >= 50 then
    pageSize := 50;
  if pageIndex <= 0 then
    pageIndex := 1;
  iPageTotal := ceil(50 / pageSize);
  if pageIndex > iPageTotal then
  begin
    result.resultMsg := '最大页数[' + iPageTotal.ToString + ']数据已到底了';
    exit;
  end;
  //
  result.resultData := TList<TGoodsDemo>.Create;
  for i := (pageIndex - 1) * pageSize to pageIndex * pageSize do
  begin
    lGoodDemo := TGoodsDemo.Create;
    result.resultData.Add(lGoodDemo);
    lGoodDemo.FGoodsCode := 'code' + i.ToString;
    lGoodDemo.FGoodsName := 'name' + i.ToString;
    lGoodDemo.FGoodsPrice := i * 10;
    lGoodDemo.FGoodsRemark := '商品测试';
  end;
  result.SetResultTrue();
end;

// 从数据库中去获取相关商品资料信息 ,当然也可以直接返回TFDMemDataSet,只要前后端字段一至就行
function TUniDemoController.GetGoodsList(pageIndex: integer; pageSize: integer; goodInfo: string): TActionResult<TFDMemtable>;
var
  lZTItem: TOneZTItem;
  lFDQuery: TFDQuery;
  lOneTokenItem: IOneTokenItem;
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
      if goodInfo = '' then
      begin
        lFDQuery.SQL.Text := 'select FGoodsID,FGoodsCode,FGoodsName,FGoodsPrice,FGoodsRemark,FGoodsImgUrl from demo_goods where 1=1 order by FGoodsCode';
      end
      else
      begin
        // 相拟查询
        lFDQuery.SQL.Text := 'select FGoodsID,FGoodsCode,FGoodsName,FGoodsPrice,FGoodsRemark,FGoodsImgUrl from demo_goods ' + ' where FGoodsCode like :goodInfo or FGoodsName like :goodInfo order by FGoodsCode ';
        lFDQuery.Params[0].AsString := '%' + goodInfo + '%';
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
          lFDQuery.FetchOptions.RecsMax := -1;

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

// 返回一个商品类表,跟据传上来的Json数据过滤相关数据
function TUniDemoController.GetGoodsListByJson(QJson: TJsonObject): TActionResult<TFDMemtable>;
var
  lZTItem: TOneZTItem;
  lFDQuery: TFDQuery;
  lOneTokenItem: IOneTokenItem;
  lOneZTMange: TOneZTManage;
  lOneTokenManage: TOneTokenManage;
  lGoodDemo: TGoodsDemo;
  lErrMsg: string;
  pageSize, pageIndex: integer;
  goodInfo: string;
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
  QJson.TryGetValue<integer>('pageSize', pageSize);
  QJson.TryGetValue<integer>('pageIndex', pageIndex);
  QJson.TryGetValue<string>('goodInfo', goodInfo);
  try
    try
      // 理论查询用orm最好的
      // 从账套获取现成的FDQuery,已绑定好 connetion,也无需释放
      lFDQuery := lZTItem.ADQuery;
      // 查询所有
      if goodInfo = '' then
      begin
        lFDQuery.SQL.Text := 'select  FGoodsID,FGoodsCode,FGoodsName,FGoodsPrice,FGoodsRemark,FGoodsImgUrl  from demo_goods where 1=1 order by FGoodsCode';
      end
      else
      begin
        // 相拟查询
        lFDQuery.SQL.Text := 'select  FGoodsID,FGoodsCode,FGoodsName,FGoodsPrice,FGoodsRemark,FGoodsImgUrl  from demo_goods ' + ' where FGoodsCode like :goodInfo or FGoodsName like :goodInfo order by FGoodsCode ';
        lFDQuery.Params[0].AsString := '%' + goodInfo + '%';
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
          lFDQuery.FetchOptions.RecsMax := -1;

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

function TUniDemoController.GetGoods(QGoodsID: string): TActionResult<TGoodsDemo>;
var
  lZTItem: TOneZTItem;
  lFDQuery: TFDQuery;
  lOneTokenItem: IOneTokenItem;
  lOneZTMange: TOneZTManage;
  lOneTokenManage: TOneTokenManage;
  lGoodDemo: TGoodsDemo;
  lErrMsg: string;
begin
  result := TActionResult<TGoodsDemo>.Create(true, false);
  if QGoodsID = '' then
  begin
    result.resultMsg := '请上传参数{"QGoodsID":"值"}';
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
      lFDQuery.SQL.Text := 'select FGoodsID,FGoodsCode,FGoodsName,FGoodsPrice,FGoodsRemark,FGoodsImgUrl from demo_goods where FGoodsID=:FGoodsID';
      lFDQuery.Params[0].AsString := QGoodsID;
      lFDQuery.Open;
      if lFDQuery.RecordCount = 0 then
      begin
        result.resultMsg := '不存在当前ID的商品数据';
        exit;
      end;
      lGoodDemo := TGoodsDemo.Create();
      result.resultData := lGoodDemo;
      lGoodDemo.FGoodsID := lFDQuery.FieldByName('FGoodsID').AsString;
      lGoodDemo.FGoodsCode := lFDQuery.FieldByName('FGoodsCode').AsString;
      lGoodDemo.FGoodsName := lFDQuery.FieldByName('FGoodsName').AsString;
      lGoodDemo.FGoodsPrice := lFDQuery.FieldByName('FGoodsPrice').AsFloat;
      lGoodDemo.FGoodsRemark := lFDQuery.FieldByName('FGoodsRemark').AsString;
      lGoodDemo.FGoodsImgUrl := lFDQuery.FieldByName('FGoodsImgUrl').AsString;
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

function TUniDemoController.SaveGoods(QGoods: TGoodsDemo): TActionResult<TGoodsDemo>;
var
  lZTItem: TOneZTItem;
  lFDQuery: TFDQuery;
  lOneTokenItem: IOneTokenItem;
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
  result := TActionResult<TGoodsDemo>.Create(false, false);
  // 检验数据

  if QGoods.FGoodsCode = '' then
  begin
    result.resultMsg := '商品代码不可为空';
    exit;
  end;

  if QGoods.FGoodsName = '' then
  begin
    result.resultMsg := '商品名称不可为空';
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
      QGoods.SetRowState(QGoods.FGoodsID);
      // 理论查询用orm最好的
      // 从账套获取现成的FDQuery,已绑定好 connetion,也无需释放
      lFDQuery := lZTItem.ADQuery;
      lFDQuery.UpdateOptions.UpdateTableName := 'demo_goods'; // 设置表名
      lFDQuery.UpdateOptions.KeyFields := 'FGoodsID'; // 设置主键
      //
      lFDQuery.UpdateOptions.UpdateMode := TUpdateMode.upWhereKeyOnly; // 设置更新模式
      if QGoods.GetRowState = emRowstate.insertState then
      begin
        // 打开一个空数据集
        lFDQuery.SQL.Text := 'select  FGoodsID,FGoodsCode,FGoodsName,FGoodsPrice,FGoodsRemark,FGoodsImgUrl  from demo_goods where 1=2';
      end
      else
      begin
        // 相拟查询
        lFDQuery.SQL.Text := 'select  FGoodsID,FGoodsCode,FGoodsName,FGoodsPrice,FGoodsRemark,FGoodsImgUrl  from demo_goods where FGoodsID=:FGoodsID';
        lFDQuery.Params[0].AsString := QGoods.FGoodsID;
      end;
      lFDQuery.Open;
      if QGoods.GetRowState = emRowstate.insertState then
      begin
        // 新增相关东东赋值下
        QGoods.FGoodsID := OneGuID.GetGUID32;
        lFDQuery.Append;
        lFDQuery.FieldByName('FGoodsID').AsString := QGoods.FGoodsID;
        lFDQuery.FieldByName('FGoodsCode').AsString := QGoods.FGoodsCode;
        lFDQuery.FieldByName('FGoodsName').AsString := QGoods.FGoodsName;
        lFDQuery.FieldByName('FGoodsPrice').AsFloat := QGoods.FGoodsPrice;
        lFDQuery.FieldByName('FGoodsRemark').AsString := QGoods.FGoodsRemark;
        lFDQuery.FieldByName('FGoodsImgUrl').AsString := QGoods.FGoodsImgUrl;
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
        lFDQuery.FieldByName('FGoodsCode').AsString := QGoods.FGoodsCode;
        lFDQuery.FieldByName('FGoodsName').AsString := QGoods.FGoodsName;
        lFDQuery.FieldByName('FGoodsPrice').AsFloat := QGoods.FGoodsPrice;
        lFDQuery.FieldByName('FGoodsRemark').AsString := QGoods.FGoodsRemark;
        lFDQuery.FieldByName('FGoodsImgUrl').ProviderFlags := []; // 设定此字段不参与任何更新
        // lFDQuery.FieldByName('FGoodsImgUrl').
        lFDQuery.post;
      end;
      iErr := lFDQuery.ApplyUpdates(-1);
      if iErr <> 0 then
      begin
        result.resultMsg := '更新数据有误,错误行数' + iErr.ToString;
        exit;
      end;
      iCommit := lFDQuery.RowsAffected;
      if iCommit <> 1 then
      begin
        result.resultMsg := '更新数据有误,影响行数不为1,当前影响行数' + iCommit.ToString;
        exit;
      end;
      lZTItem.ADConnection.Commit;
      isCommit := true;
      result.resultData := QGoods;
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

function TUniDemoController.PostFile(QFormData: TOneMultipartDecode): TActionResult<string>;
var
  i: integer;
  lWebRequestFile: TOneRequestFile;
  tempStream: TCustomMemoryStream;
begin
  result := TActionResult<string>.Create(false, false);
  // 接收到的文件
  for i := 0 to QFormData.Files.count - 1 do
  begin
    lWebRequestFile := TOneRequestFile(QFormData.Files.items[i]);
    result.resultData := result.resultData + '当前接收到文件参数[' + lWebRequestFile.FieldName + ']' + '文件名称[' + lWebRequestFile.fileName + ']' + #10#13;
    // 文件流 ,至于要咱样是业务问题
    tempStream := TCustomMemoryStream(lWebRequestFile.Stream);
  end;
  // 接收到的参数,自已的业务自已分析
  for i := 0 to QFormData.ContentFields.count - 1 do
  begin
    result.resultData := result.resultData + '当前接收到参数[' + QFormData.ContentFields[i] + ']' + #10#13;
  end;
  result.SetResultTrue();
end;

initialization

// 单例模式注册
OneHttpRouterManage.GetInitRouterManage().AddHTTPSingleWork('/UniDemo', TUniDemoController, 0, CreateNewUniDemoController);

finalization

end.

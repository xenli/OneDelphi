unit UniLoginController;

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

  TUniLoginController = class(TOneControllerBase)
  public
    // 登陆接口
    function Login(QLogin: TLoginInfo): TActionResult<TLoginInfo>;
    function OneGetLogin(user: string; pass: string): TActionResult<TLoginInfo>;
    // 登出接口
    function LoginOut(QLogin: TLoginInfo): TActionResult<string>;
  end;

function CreateNewUniDemoController(QRouterItem: TOneRouterWorkItem): TObject;

implementation

uses OneGlobal, OneZTManage;

function CreateNewUniDemoController(QRouterItem: TOneRouterWorkItem): TObject;
var
  lController: TUniLoginController;
begin
  // 自定义创建控制器类，否则会按 TPersistentclass.create
  // 最好自定义一个好
  lController := TUniLoginController.Create;
  // 挂载RTTI信息
  lController.RouterItem := QRouterItem;
  result := lController;
end;

// 前后端参数及返回结果大写小请保证一至 ,不要问我为什么JSON是区分大小写的,
function TUniLoginController.Login(QLogin: TLoginInfo): TActionResult<TLoginInfo>;
var
  lOneZTMange: TOneZTManage;
  lOneTokenManage: TOneTokenManage;
  lZTItem: TOneZTItem;
  lFDQuery: TFDQuery;
  lOneTokenItem: TOneTokenItem;
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
    lOneTokenItem := lOneTokenManage.AddLoginToken('uniapp-' + QLogin.loginZTCode, QLogin.loginCode, true, lErrMsg);
    if lOneTokenItem = nil then
    begin
      result.resultMsg := lErrMsg;
      exit;
    end;
    // 为Token设置相关信息
    lOneTokenItem.LoginUserCode := QLogin.loginCode;
    lOneTokenItem.ZTCode := QLogin.loginZTCode; // 指定账套
    lOneTokenItem.SysUserID := lFDQuery.FieldByName('FUserID').AsString;
    lOneTokenItem.SysUserName := lFDQuery.FieldByName('FUserName').AsString;
    lOneTokenItem.SysUserCode := lFDQuery.FieldByName('FUserCode').AsString;
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

function TUniLoginController.OneGetLogin(user: string; pass: string): TActionResult<TLoginInfo>;
var
  lOneZTMange: TOneZTManage;
  lOneTokenManage: TOneTokenManage;
  lZTItem: TOneZTItem;
  lFDQuery: TFDQuery;
  lOneTokenItem: TOneTokenItem;
  lErrMsg: string;
begin
  try
    result := TActionResult<TLoginInfo>.Create(true, false);
    lErrMsg := '';
    if user = '' then
    begin
      result.resultMsg := '用户代码不可为空';
      exit;
    end;
    if pass = '' then
    begin
      result.resultMsg := '用户密码不可为空';
      exit;
    end;
    // 验证账号密码,比如数据库
    lOneZTMange := TOneGlobal.GetInstance().ZTManage;
    // 账套为空时,默认取主账套,多账套的话可以固定一个账套代码
    lZTItem := lOneZTMange.LockZTItem('', lErrMsg);
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
      lFDQuery.Params[0].AsString := user;
      lFDQuery.Open;
      if lFDQuery.RecordCount = 0 then
      begin
        result.resultMsg := '当前用户[' + user + ']不存在,请检查';
        exit;
      end;
      if lFDQuery.RecordCount > 1 then
      begin
        result.resultMsg := '当前用户[' + user + ']重复,请联系管理员检查数据';
        exit;
      end;
      // 为一条时要验证密码,前端一般是MD5加密的,后端也是保存MD5加密的
      if pass.ToLower <> lFDQuery.FieldByName('FUserPass').AsString.ToLower then
      begin
        result.resultMsg := '当前用户[' + user + ']密码不正确,请检查';
        exit;
      end;
      // 正确增加Token返回相关的toeknID及私钥
      lOneTokenManage := TOneGlobal.GetInstance().TokenManage;
      // true允许同个账号共用token,测试接口共享下防止踢来踢去
      lOneTokenItem := lOneTokenManage.AddLoginToken('uniapp', user, true, lErrMsg);
      if lOneTokenItem = nil then
      begin
        result.resultMsg := lErrMsg;
        exit;
      end;
      // 为Token设置相关信息
      lOneTokenItem.LoginUserCode := user;
      lOneTokenItem.ZTCode := ''; // 指定账套
      lOneTokenItem.SysUserID := lFDQuery.FieldByName('FUserID').AsString;
      lOneTokenItem.SysUserName := lFDQuery.FieldByName('FUserName').AsString;
      lOneTokenItem.SysUserCode := lFDQuery.FieldByName('FUserCode').AsString;
      // 返回信息设置
      result.resultData := TLoginInfo.Create;
      result.resultData.loginCode := user;
      result.resultData.tokenID := lOneTokenItem.tokenID;
      result.resultData.privateKey := lOneTokenItem.privateKey;
      result.resultData.userName := lFDQuery.FieldByName('FUserName').AsString;
      //
      result.SetResultTrue;
    finally
      // 解锁,归还池很重要
      lZTItem.UnLockWork;
    end;
  except

  end;
end;

function TUniLoginController.LoginOut(QLogin: TLoginInfo): TActionResult<string>;
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

initialization

// 单例模式注册
OneHttpRouterManage.GetInitRouterManage().AddHTTPSingleWork('/UniDemo/Login', TUniLoginController, 0, CreateNewUniDemoController);

finalization

end.

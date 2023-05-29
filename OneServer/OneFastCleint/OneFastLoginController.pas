unit OneFastLoginController;

interface

uses
  system.StrUtils, system.SysUtils, Math, system.JSON, system.Threading, system.Classes,
  OneHttpController, OneHttpRouterManage, OneHttpCtxtResult, OneTokenManage, OneHttpConst,
  system.Generics.Collections, OneControllerResult, FireDAC.Comp.Client, Data.DB, OneGuID,
  OneMultipart;

type

  TFastLogin = class
  private
    FloginCode: string; // 登陆代码
    FloginPass: string; // 登陆密码
    FloginZTCode: string; // 指定登陆账套
    FSecretkey: string;
    FtokenID: string; // 返回去的TokenID
    FprivateKey: string; // 返回去的私钥
    FAdminID: string; // 返回去的用户名称
    FAdminCode: string;
    FAdminName: string;
    // 如果有其它信息自已加，本示例只是个demo
  published
    // 前后端参数及返回结果大写小请保证一至 ,不要问我为什么JSON是区分大小写的,
    property loginCode: string read FloginCode write FloginCode;
    property loginPass: string read FloginPass write FloginPass;
    property loginZTCode: string read FloginZTCode write FloginZTCode;
    property secretkey: string read FSecretkey write FSecretkey;
    property tokenID: string read FtokenID write FtokenID;
    property privateKey: string read FprivateKey write FprivateKey;
    property adminID: string read FAdminID write FAdminID;
    property adminCode: string read FAdminCode write FAdminCode;
    property adminName: string read FAdminName write FAdminName;
  end;

  TWeixinBind = class
  private
    FloginCode: string; // 登陆代码
    FloginPass: string; // 登陆密码
    FnickName: string; // 微信昵称
  published
    property loginCode: string read FloginCode write FloginCode;
    property loginPass: string read FloginPass write FloginPass;
    property nickName: string read FnickName write FnickName;
  end;

  TFastLoginController = class(TOneControllerBase)
  public
    // 登陆接口
    // 登陆接口
    function Login(QLogin: TFastLogin): TActionResult<TFastLogin>;
    function OneGetLogin(user: string; pass: string): TActionResult<TFastLogin>;
    // 登出接口
    function LoginOut(QLogin: TFastLogin): TActionResult<string>;

    function LoginOutToken(): TActionResult<string>;

    // QBindID  单一个微信账号绑定多个指定哪个绑定登陆
    function WeixinMinTokenLogin(QBindID: string): TActionResult<TFastLogin>;

    // 现在前端只能获取到微信昵称了
    function WeixinMinTokenBind(QBind: TWeixinBind): TActionResult<string>;
  end;

function CreateNewFastLoginController(QRouterItem: TOneRouterWorkItem): TObject;

implementation

uses OneGlobal, OneZTManage, OneCrypto;

function CreateNewFastLoginController(QRouterItem: TOneRouterWorkItem): TObject;
var
  lController: TFastLoginController;
begin
  // 自定义创建控制器类，否则会按 TPersistentclass.create
  // 最好自定义一个好
  lController := TFastLoginController.Create;
  // 挂载RTTI信息
  lController.RouterItem := QRouterItem;
  result := lController;
end;

// 前后端参数及返回结果大写小请保证一至 ,不要问我为什么JSON是区分大小写的,
function TFastLoginController.Login(QLogin: TFastLogin): TActionResult<TFastLogin>;
var
  lOneGlobal: TOneGlobal;
  lOneZTMange: TOneZTManage;
  lOneTokenManage: TOneTokenManage;
  lZTItem: TOneZTItem;
  lFDQuery: TFDQuery;
  lOneTokenItem: TOneTokenItem;
  lErrMsg: string;
  lNow: TDateTime;
begin
  result := TActionResult<TFastLogin>.Create(true, false);
  lOneGlobal := TOneGlobal.GetInstance();
  lOneGlobal.Log.WriteLog('Login', '0');
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
  // if lOneGlobal.ServerSet.ConnectSecretkey <> QLogin.secretkey then
  // begin
  // // 安全密钥不一至
  // result.resultMsg := '安全密钥不一至,无法连接服务端!!!';
  // exit;
  // end;
  // 判断是不是超级管理员
  lOneGlobal.Log.WriteLog('Login', '1');
  if QLogin.loginCode = 'SuperAdmin' then
  begin
    // 超级管理员
    if QLogin.loginPass.ToLower = OneCrypto.MD5Endcode(lOneGlobal.ServerSet.SuperAdminPass, false) then
    begin
      // 正确增加Token返回相关的toeknID及私钥
      lOneTokenManage := TOneGlobal.GetInstance().TokenManage;
      // true允许同个账号共用token,测试接口共享下防止踢来踢去
      lOneTokenItem := lOneTokenManage.AddLoginToken('fastClient', QLogin.loginCode, true, lErrMsg);
      if lOneTokenItem = nil then
      begin
        result.resultMsg := lErrMsg;
        exit;
      end;
      // 为Token设置相关信息
      lOneTokenItem.LoginUserCode := QLogin.loginCode;
      lOneTokenItem.ZTCode := QLogin.loginZTCode; // 指定账套
      lOneTokenItem.SysUserID := QLogin.loginCode;
      lOneTokenItem.SysUserName := '超级管理员';
      lOneTokenItem.SysUserType := '超级管理员';
      lOneTokenItem.SysUserCode := QLogin.loginCode;
      // 返回信息设置
      result.resultData := TFastLogin.Create;
      result.resultData.loginCode := QLogin.loginCode;
      result.resultData.tokenID := lOneTokenItem.tokenID;
      result.resultData.privateKey := lOneTokenItem.privateKey;

      result.resultData.adminID := QLogin.loginCode;
      result.resultData.adminCode := QLogin.loginCode;
      result.resultData.adminName := '超级管理员';
      //
      result.SetResultTrue;
      exit;
    end;
    //
  end;
  lOneGlobal.Log.WriteLog('Login', '2');
  // 验证账号密码,比如数据库
  lOneZTMange := TOneGlobal.GetInstance().ZTManage;
  // 账套为空时,默认取主账套,多账套的话可以固定一个账套代码
  lZTItem := lOneZTMange.LockZTItem(QLogin.loginZTCode, lErrMsg);
  if lZTItem = nil then
  begin
    result.resultMsg := lErrMsg;
    exit;
  end;
  lOneGlobal.Log.WriteLog('Login', '3');
  try
    // 从账套获取现成的FDQuery,已绑定好 connetion,也无需释放
    lFDQuery := lZTItem.ADQuery;
    // 这边改成你的用户表
    lFDQuery.SQL.Text := 'select FAdminID,FAdminCode,FAdminName,FAdminPass,FAdminType,FIsEnable,FIsLimit,FLimtStartTime,FLimtEndTime,FIsMultiLogin ' +
      ' from onefast_admin where FAdminCode=:FAdminCode';
    lFDQuery.Params[0].AsString := QLogin.loginCode;
    lFDQuery.Open;
    lOneGlobal.Log.WriteLog('Login', '4');
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
    if not lFDQuery.FieldByName('FIsEnable').AsBoolean then
    begin
      result.resultMsg := '当前用户[' + QLogin.loginCode + ']未启用,请联系管理员启用';
      exit;
    end;
    if lFDQuery.FieldByName('FIsLimit').AsBoolean then
    begin
      //
      lNow := now;
      if lNow >= lFDQuery.FieldByName('FLimtEndTime').AsDateTime then
      begin
        result.resultMsg := '当前用户[' + QLogin.loginCode + ']已到期,请联系管理员';
        exit;
      end;
      if lNow < lFDQuery.FieldByName('FLimtStartTime').AsDateTime then
      begin
        result.resultMsg := '当前用户[' + QLogin.loginCode + ']限期开始时间' + FormatDateTime('yyyy-MM-dd hh:mm:ss', lFDQuery.FieldByName('FLimtStartTime').AsDateTime) + ',请联系管理员';
        exit;
      end;
      // 判断限时
      result.resultMsg := '当前用户[' + QLogin.loginCode + ']未启用,请联系管理员启用';
      exit;
    end;
    lOneGlobal.Log.WriteLog('Login', '5');
    // 为一条时要验证密码,前端一般是MD5加密的,后端也是保存MD5加密的
    if QLogin.loginPass.ToLower <> lFDQuery.FieldByName('FAdminPass').AsString.ToLower then
    begin
      result.resultMsg := '当前用户[' + QLogin.loginCode + ']密码不正确,请检查';
      exit;
    end;
    // 正确增加Token返回相关的toeknID及私钥
    lOneTokenManage := TOneGlobal.GetInstance().TokenManage;
    // true允许同个账号共用token,测试接口共享下防止踢来踢去
    lOneTokenItem := lOneTokenManage.AddLoginToken('fastClient', QLogin.loginCode,
      lFDQuery.FieldByName('FIsMultiLogin').AsBoolean, lErrMsg);
    if lOneTokenItem = nil then
    begin
      result.resultMsg := lErrMsg;
      exit;
    end;
    lOneGlobal.Log.WriteLog('Login', '6');
    // 为Token设置相关信息
    lOneTokenItem.LoginUserCode := QLogin.loginCode;
    lOneTokenItem.ZTCode := QLogin.loginZTCode; // 指定账套
    lOneTokenItem.SysUserID := lFDQuery.FieldByName('FAdminID').AsString;
    lOneTokenItem.SysUserName := lFDQuery.FieldByName('FAdminName').AsString;
    lOneTokenItem.SysUserCode := lFDQuery.FieldByName('FAdminCode').AsString;
    lOneTokenItem.SysUserType := lFDQuery.FieldByName('FAdminType').AsString;
    // 返回信息设置
    result.resultData := TFastLogin.Create;
    result.resultData.loginCode := QLogin.loginCode;
    result.resultData.tokenID := lOneTokenItem.tokenID;
    result.resultData.privateKey := lOneTokenItem.privateKey;
    result.resultData.adminID := lFDQuery.FieldByName('FAdminID').AsString;
    result.resultData.adminCode := lFDQuery.FieldByName('FAdminCode').AsString;
    result.resultData.adminName := lFDQuery.FieldByName('FAdminName').AsString;
    //
    result.SetResultTrue;
    lOneGlobal.Log.WriteLog('Login', '7');
  finally
    // 解锁,归还池很重要
    lZTItem.UnLockWork;
    lOneGlobal.Log.WriteLog('Login', '8');
  end;
end;

function TFastLoginController.OneGetLogin(user: string; pass: string): TActionResult<TFastLogin>;
var
  lOneGlobal: TOneGlobal;
  lOneZTMange: TOneZTManage;
  lOneTokenManage: TOneTokenManage;
  lZTItem: TOneZTItem;
  lFDQuery: TFDQuery;
  lOneTokenItem: TOneTokenItem;
  lErrMsg: string;
  lNow: TDateTime;
begin
  result := TActionResult<TFastLogin>.Create(true, false);
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
  lOneGlobal := TOneGlobal.GetInstance();
  // if lOneGlobal.ServerSet.ConnectSecretkey <> QLogin.secretkey then
  // begin
  // // 安全密钥不一至
  // result.resultMsg := '安全密钥不一至,无法连接服务端!!!';
  // exit;
  // end;
  // 判断是不是超级管理员
  if user = 'SuperAdmin' then
  begin
    // 超级管理员
    if user.ToLower = OneCrypto.MD5Endcode(lOneGlobal.ServerSet.SuperAdminPass, false) then
    begin
      // 正确增加Token返回相关的toeknID及私钥
      lOneTokenManage := TOneGlobal.GetInstance().TokenManage;
      // true允许同个账号共用token,测试接口共享下防止踢来踢去
      lOneTokenItem := lOneTokenManage.AddLoginToken('fastClient', user, true, lErrMsg);
      if lOneTokenItem = nil then
      begin
        result.resultMsg := lErrMsg;
        exit;
      end;
      // 为Token设置相关信息
      lOneTokenItem.LoginUserCode := user;
      lOneTokenItem.ZTCode := ''; // 指定账套
      lOneTokenItem.SysUserID := user;
      lOneTokenItem.SysUserName := '超级管理员';
      lOneTokenItem.SysUserType := '超级管理员';
      lOneTokenItem.SysUserCode := user;
      // 返回信息设置
      result.resultData := TFastLogin.Create;
      result.resultData.loginCode := user;
      result.resultData.tokenID := lOneTokenItem.tokenID;
      result.resultData.privateKey := lOneTokenItem.privateKey;

      result.resultData.adminID := user;
      result.resultData.adminCode := user;
      result.resultData.adminName := '超级管理员';
      //
      result.SetResultTrue;
      exit;
    end;
    //
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
    lFDQuery.SQL.Text := 'select FAdminID,FAdminCode,FAdminName,FAdminPass,FAdminType,FIsEnable,FIsLimit,FLimtStartTime,FLimtEndTime,FIsMultiLogin ' +
      ' from onefast_admin where FAdminCode=:FAdminCode';
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
    if not lFDQuery.FieldByName('FIsEnable').AsBoolean then
    begin
      result.resultMsg := '当前用户[' + user + ']未启用,请联系管理员启用';
      exit;
    end;
    if lFDQuery.FieldByName('FIsLimit').AsBoolean then
    begin
      //
      lNow := now;
      if lNow >= lFDQuery.FieldByName('FLimtEndTime').AsDateTime then
      begin
        result.resultMsg := '当前用户[' + user + ']已到期,请联系管理员';
        exit;
      end;
      if lNow < lFDQuery.FieldByName('FLimtStartTime').AsDateTime then
      begin
        result.resultMsg := '当前用户[' + user + ']限期开始时间' + FormatDateTime('yyyy-MM-dd hh:mm:ss', lFDQuery.FieldByName('FLimtStartTime').AsDateTime) + ',请联系管理员';
        exit;
      end;
      // 判断限时
      result.resultMsg := '当前用户[' + user + ']未启用,请联系管理员启用';
      exit;
    end;
    // 为一条时要验证密码,前端一般是MD5加密的,后端也是保存MD5加密的
    if pass.ToLower <> lFDQuery.FieldByName('FAdminPass').AsString.ToLower then
    begin
      result.resultMsg := '当前用户[' + user + ']密码不正确,请检查';
      exit;
    end;
    // 正确增加Token返回相关的toeknID及私钥
    lOneTokenManage := TOneGlobal.GetInstance().TokenManage;
    // true允许同个账号共用token,测试接口共享下防止踢来踢去
    lOneTokenItem := lOneTokenManage.AddLoginToken('fastClient', user,
      lFDQuery.FieldByName('FIsMultiLogin').AsBoolean, lErrMsg);
    if lOneTokenItem = nil then
    begin
      result.resultMsg := lErrMsg;
      exit;
    end;
    // 为Token设置相关信息
    lOneTokenItem.LoginUserCode := user;
    lOneTokenItem.ZTCode := ''; // 指定账套
    lOneTokenItem.SysUserID := lFDQuery.FieldByName('FAdminID').AsString;
    lOneTokenItem.SysUserName := lFDQuery.FieldByName('FAdminName').AsString;
    lOneTokenItem.SysUserCode := lFDQuery.FieldByName('FAdminCode').AsString;
    lOneTokenItem.SysUserType := lFDQuery.FieldByName('FAdminType').AsString;
    // 返回信息设置
    result.resultData := TFastLogin.Create;
    result.resultData.loginCode := user;
    result.resultData.tokenID := lOneTokenItem.tokenID;
    result.resultData.privateKey := lOneTokenItem.privateKey;
    result.resultData.adminID := lFDQuery.FieldByName('FAdminID').AsString;
    result.resultData.adminCode := lFDQuery.FieldByName('FAdminCode').AsString;
    result.resultData.adminName := lFDQuery.FieldByName('FAdminName').AsString;
    //
    result.SetResultTrue;
  finally
    // 解锁,归还池很重要
    lZTItem.UnLockWork;
  end;
end;

function TFastLoginController.LoginOut(QLogin: TFastLogin): TActionResult<string>;
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

function TFastLoginController.LoginOutToken(): TActionResult<string>;
var
  lOneGlobal: TOneGlobal;
  lErrMsg: string;
  lToken: TOneTokenItem;
begin
  result := TActionResult<string>.Create(false, false);
  lToken := self.GetCureentToken(lErrMsg);
  if lToken = nil then
  begin
    result.resultMsg := lErrMsg;
    exit;
  end;
  lOneGlobal := TOneGlobal.GetInstance();
  lOneGlobal.TokenManage.RemoveToken(lToken.tokenID);
  result.resultData := 'Token删除成功';
  result.SetResultTrue();
end;

function TFastLoginController.WeixinMinTokenLogin(QBindID: string): TActionResult<TFastLogin>;
var
  lToken: TOneTokenItem;
  lErrMsg: string;
  lZTMange: TOneZTManage;
  lZTItem: TOneZTItem;
  lQuery: TFDQuery;
  //
  lBindID: string;
  lUserID: string;
  lUserType: string;
  lSuperAdmin: boolean;
  lNow: TDateTime;
begin
  result := TActionResult<TFastLogin>.Create(true, false);
  lToken := self.GetCureentToken(lErrMsg);
  if lToken = nil then
  begin
    result.resultMsg := lErrMsg;
    exit;
  end;
  // 获取绑定数据
  if lToken.LoginUserCode = '' then
  begin
    result.resultMsg := '登陆代码OpenID为空';
    exit;
  end;
  // 验证账号密码,比如数据库
  lZTMange := TOneGlobal.GetInstance().ZTManage;
  // 账套为空时,默认取主账套,多账套的话可以固定一个账套代码
  lZTItem := lZTMange.LockZTItem(lToken.ZTCode, lErrMsg);
  if lZTItem = nil then
  begin
    result.resultMsg := lErrMsg;
    exit;
  end;
  try
    lQuery := lZTItem.ADQuery;
    if (QBindID <> '') and (QBindID <> '-1') then
    begin
      // 指定某条绑定登陆
      lQuery.SQL.Text := 'select * from onefast_wexin_userbind where FBindID=:FBindID';
      lQuery.Params[0].AsString := QBindID;
    end
    else
    begin
      // 跟据OpenID获取相关绑定,可能一个绑定多个
      lQuery.SQL.Text := 'select * from onefast_wexin_userbind where FOpenID=:FOpenID';
      lQuery.Params[0].AsString := lToken.LoginUserCode;
    end;
    lQuery.Open();
    if lQuery.RecordCount = 0 then
    begin
      // 返回未绑定
      result.ResultCode := 'NotBind';
      exit;
    end;
    if lQuery.RecordCount > 1 then
    begin
      // 返回选择列表
      result.ResultCode := 'MultiBind';
      exit;
    end;
    lBindID := lQuery.FieldByName('FBindID').AsString;
    lUserID := lQuery.FieldByName('FUserID').AsString;
    lUserType := lQuery.FieldByName('FUserType').AsString;
    lSuperAdmin := lQuery.FieldByName('FIsSuperAdmin').AsBoolean;
    // 进行登陆
    if lUserID = '' then
    begin
      exit;
    end;
    //
    lQuery := lZTItem.ADQuery;
    lQuery.SQL.Text := 'select * from onefast_admin where FAdminID=:FAdminID';
    lQuery.Params[0].AsString := lUserID;
    lQuery.Open();
    if lQuery.RecordCount = 0 then
    begin
      // 不存在此用户,需要重新绑定
      // 删除记录
      lQuery := lZTItem.ADQuery;
      lQuery.SQL.Text := 'delete from onefast_wexin_userbind where FBindID=:FBindID';
      lQuery.Params[0].AsString := lBindID;
      lQuery.ExecSQL;
      exit;
    end;
    if not lQuery.FieldByName('FIsEnable').AsBoolean then
    begin
      result.resultMsg := '当前用户[' + lQuery.FieldByName('FAdminCode').AsString + ']未启用,请联系管理员启用';
      exit;
    end;
    if lQuery.FieldByName('FIsLimit').AsBoolean then
    begin
      //
      lNow := now;
      if lNow >= lQuery.FieldByName('FLimtEndTime').AsDateTime then
      begin
        result.resultMsg := '当前用户[' + lQuery.FieldByName('FAdminCode').AsString + ']已到期,请联系管理员';
        exit;
      end;
      if lNow < lQuery.FieldByName('FLimtStartTime').AsDateTime then
      begin
        result.resultMsg := '当前用户[' + lQuery.FieldByName('FAdminCode').AsString + ']限期开始时间'
          + FormatDateTime('yyyy-MM-dd hh:mm:ss', lQuery.FieldByName('FLimtStartTime').AsDateTime) + ',请联系管理员';
        exit;
      end;
      // 判断限时
      result.resultMsg := '当前用户[' + lQuery.FieldByName('FAdminCode').AsString + ']未启用,请联系管理员启用';
      exit;
    end;
    // 存在进行Token数据写入
    lToken.SysUserID := lQuery.FieldByName('FAdminID').AsString;
    lToken.SysUserName := lQuery.FieldByName('FAdminName').AsString;
    lToken.SysUserCode := lQuery.FieldByName('FAdminCode').AsString;
    lToken.SysUserType := lQuery.FieldByName('FAdminType').AsString;
    if lSuperAdmin then
      lToken.SysUserType := '超级管理员';
    result.resultData := TFastLogin.Create;
    result.resultData.adminID := lQuery.FieldByName('FAdminID').AsString;
    result.resultData.adminCode := lQuery.FieldByName('FAdminCode').AsString;
    result.resultData.adminName := lQuery.FieldByName('FAdminName').AsString;
    //
    result.SetResultTrue;
  finally
    lZTItem.UnLockWork;
  end;

end;

function TFastLoginController.WeixinMinTokenBind(QBind: TWeixinBind): TActionResult<string>;
var
  lToken: TOneTokenItem;
  lErrMsg: string;
  lZTMange: TOneZTManage;
  lZTItem: TOneZTItem;
  lFDQuery: TFDQuery;
  lNow: TDateTime;
  lUserID: string;
begin
  result := TActionResult<string>.Create(false, false);
  if QBind.FloginCode = '' then
  begin
    result.resultMsg := '绑定用户的登陆代码不可为空';
    exit;
  end;
  if QBind.FloginPass = '' then
  begin
    result.resultMsg := '绑定用户的登陆密码不可为空';
    exit;
  end;
  lToken := self.GetCureentToken(lErrMsg);
  if lToken = nil then
  begin
    result.resultMsg := lErrMsg;
    exit;
  end;
  // 获取绑定数据
  if lToken.LoginUserCode = '' then
  begin
    result.resultMsg := '登陆代码OpenID为空';
    exit;
  end;
  // 验证账号密码,比如数据库
  lZTMange := TOneGlobal.GetInstance().ZTManage;
  // 账套为空时,默认取主账套,多账套的话可以固定一个账套代码
  lZTItem := lZTMange.LockZTItem(lToken.ZTCode, lErrMsg);
  if lZTItem = nil then
  begin
    result.resultMsg := lErrMsg;
    exit;
  end;
  try
    // 从账套获取现成的FDQuery,已绑定好 connetion,也无需释放
    lFDQuery := lZTItem.ADQuery;
    // 这边改成你的用户表
    lFDQuery.SQL.Text := 'select FAdminID,FAdminCode,FAdminName,FAdminPass,FAdminType,FIsEnable,FIsLimit,FLimtStartTime,FLimtEndTime,FIsMultiLogin ' +
      ' from onefast_admin where FAdminCode=:FAdminCode';
    lFDQuery.Params[0].AsString := QBind.FloginCode;
    lFDQuery.Open;
    if lFDQuery.RecordCount = 0 then
    begin
      result.resultMsg := '当前用户[' + QBind.FloginCode + ']不存在,请检查';
      exit;
    end;
    if lFDQuery.RecordCount > 1 then
    begin
      result.resultMsg := '当前用户[' + QBind.FloginCode + ']重复,请联系管理员检查数据';
      exit;
    end;
    if not lFDQuery.FieldByName('FIsEnable').AsBoolean then
    begin
      result.resultMsg := '当前用户[' + QBind.FloginCode + ']未启用,请联系管理员启用';
      exit;
    end;
    if lFDQuery.FieldByName('FIsLimit').AsBoolean then
    begin
      //
      lNow := now;
      if lNow >= lFDQuery.FieldByName('FLimtEndTime').AsDateTime then
      begin
        result.resultMsg := '当前用户[' + QBind.FloginCode + ']已到期,请联系管理员';
        exit;
      end;
      if lNow < lFDQuery.FieldByName('FLimtStartTime').AsDateTime then
      begin
        result.resultMsg := '当前用户[' + QBind.FloginCode + ']限期开始时间' + FormatDateTime('yyyy-MM-dd hh:mm:ss', lFDQuery.FieldByName('FLimtStartTime').AsDateTime) + ',请联系管理员';
        exit;
      end;
      // 判断限时
      result.resultMsg := '当前用户[' + QBind.FloginCode + ']未启用,请联系管理员启用';
      exit;
    end;
    // 为一条时要验证密码,前端一般是MD5加密的,后端也是保存MD5加密的
    if QBind.loginPass.ToLower <> lFDQuery.FieldByName('FAdminPass').AsString.ToLower then
    begin
      result.resultMsg := '当前用户[' + QBind.FloginCode + ']密码不正确,请检查';
      exit;
    end;
    lUserID := lFDQuery.FieldByName('FAdminID').AsString;
    // 添加一条绑定
    lFDQuery := lZTItem.ADQuery;
    lFDQuery.SQL.Text := 'select * from onefast_wexin_userbind where 1=2';
    lFDQuery.Open();
    lFDQuery.Append;
    lFDQuery.FieldByName('FBindID').AsString := OneGuID.GetGUID32;
    lFDQuery.FieldByName('FWXAppID').AsString := lToken.ThirdAppID;
    lFDQuery.FieldByName('FOpenID').AsString := lToken.ThirdAppUserID;
    lFDQuery.FieldByName('FUserType').AsString := 'FastAdmin';
    lFDQuery.FieldByName('FUserID').AsString := lUserID;
    lFDQuery.FieldByName('FCreateTime').AsDateTime := now;
    lFDQuery.Post;
    lFDQuery.ApplyUpdates();
    result.SetResultTrue;
  finally
    lZTItem.UnLockWork;
  end;
end;

initialization

// 单例模式注册
OneHttpRouterManage.GetInitRouterManage().AddHTTPSingleWork('/FastClient/Login', TFastLoginController, 0, CreateNewFastLoginController);

finalization

end.

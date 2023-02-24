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

  TFastLoginController = class(TOneControllerBase)
  public
    // 登陆接口
    // 登陆接口
    function Login(QLogin: TFastLogin): TActionResult<TFastLogin>;
    // 登出接口
    function LoginOut(QLogin: TFastLogin): TActionResult<string>;
  end;

function CreateNewFastLoginController(QRouterItem: TOneRouterItem): TObject;

implementation

uses OneGlobal, OneZTManage, OneCrypto;

function CreateNewFastLoginController(QRouterItem: TOneRouterItem): TObject;
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
  lOneTokenItem: IOneTokenItem;
  lErrMsg: string;
  lNow: TDateTime;
begin
  result := TActionResult<TFastLogin>.Create(true, false);
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
  lOneGlobal := TOneGlobal.GetInstance();
  if lOneGlobal.ServerSet.ConnectSecretkey <> QLogin.secretkey then
  begin
    // 安全密钥不一至
    result.resultMsg := '安全密钥不一至,无法连接服务端!!!';
    exit;
  end;
  // 判断是不是超级管理员
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
      lOneTokenItem.SetLoginUserCode(QLogin.loginCode);
      lOneTokenItem.SetZTCode(QLogin.loginZTCode); // 指定账套
      lOneTokenItem.SetSysUserID(QLogin.loginCode);
      lOneTokenItem.SetSysUserName('超级管理员');
      lOneTokenItem.SetSysUserCode(QLogin.loginCode);
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
    lFDQuery.SQL.Text := 'select FAdminID,FAdminCode,FAdminName,FAdminPass,FAdminType,FIsEnable,FIsLimit,FLimtStartTime,FLimtEndTime from onefast_admin where FAdminCode=:FAdminCode';
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
    // 为一条时要验证密码,前端一般是MD5加密的,后端也是保存MD5加密的
    if QLogin.loginPass.ToLower <> lFDQuery.FieldByName('FAdminPass').AsString.ToLower then
    begin
      result.resultMsg := '当前用户[' + QLogin.loginCode + ']密码不正确,请检查';
      exit;
    end;
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
    lOneTokenItem.SetLoginUserCode(QLogin.loginCode);
    lOneTokenItem.SetZTCode(QLogin.loginZTCode); // 指定账套
    lOneTokenItem.SetSysUserID(lFDQuery.FieldByName('FAdminID').AsString);
    lOneTokenItem.SetSysUserName(lFDQuery.FieldByName('FAdminName').AsString);
    lOneTokenItem.SetSysUserCode(lFDQuery.FieldByName('FAdminCode').AsString);
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

initialization

// 单例模式注册
OneHttpRouterManage.GetInitRouterManage().AddHTTPSingleWork('/FastClient/Login', TFastLoginController, 0, CreateNewFastLoginController);

finalization

end.

unit WeixinAuthController;

{ 微信回调，验证接口单元 }

interface

uses OneHttpController, OneHttpRouterManage, OneHttpCtxtResult, OneTokenManage,
  system.Generics.Collections, system.StrUtils, system.SysUtils, Data.DB,
  FireDAC.Comp.Client, OneControllerResult, system.Classes, system.Hash;

type
  TWeixinLogin = class
  private
    FAppID: string;
    FAuthCode: string;
    FResultToknID: string;
    FResultPrivateKey: string;
    FResultOpenID: string;
  published
    property AppID: string read FAppID write FAppID;
    property AuthCode: string read FAuthCode write FAuthCode;
    property ResultToknID: string read FResultToknID write FResultToknID;
    property ResultPrivateKey: string read FResultPrivateKey write FResultPrivateKey;
    property ResultOpenID: string read FResultOpenID write FResultOpenID;
  end;

  TWeixinAuthController = class(TOneControllerBase)
  public
    // 微信公众号，开发者配置,回调地址设置,
    // 设置方式 http://xxxx/OneServer/WeixinAuth/OnePathMsgCallBack/appID
    // 涉及到多个公众号,为什么不拼接在Url上面 xxxxxx?appid=?xxx,接在上面,微信回调会把&进行转义，切割参数麻烦
    function OnePathMsgCallBack(QAppID: string): string;
    // 微信公众号，开发者配置,回调地址设置,只有一个公众号配置可以简化
    // 设置方式 http://xxxx/OneServer/WeixinAuth/MsgCallBack
    // function MsgCallBack(): string;
    function MsgCallBack(): string;

    // 小程序一键登陆
    function MinLoginByAuthCode(QLogin: TWeixinLogin): TActionResult<TWeixinLogin>;

  end;

function CreateNewWeixinAuthController(QRouterItem: TOneRouterWorkItem): TObject;

implementation

uses OneGlobal, WeiXinManage, WeixinApiPublic, WeiXinMinApi;

function CreateNewWeixinAuthController(QRouterItem: TOneRouterWorkItem)
  : TObject;
var
  lController: TWeixinAuthController;
begin
  // 自定义创建控制器类，否则会按 TPersistentclass.create
  // 最好自定义一个好
  lController := TWeixinAuthController.Create;
  // 挂载RTTI信息
  lController.RouterItem := QRouterItem;
  result := lController;
end;

// 微信公众号消息回调签名验签
function Checksignature(QHTTPCtxt: THTTPCtxt; QWeixinAccount: TWeixinAccount): boolean;
var
  signature: string;
  timestamp: string;
  nonce: string;
  token: string;
  //
  TempList: TStringList;
  i: integer;
  tempStr: string;
begin
  result := false;
  signature := QHTTPCtxt.UrlParams.values['signature'];
  timestamp := QHTTPCtxt.UrlParams.values['timestamp'];
  nonce := QHTTPCtxt.UrlParams.values['nonce'];
  token := QWeixinAccount.FMessageToken;
  TempList := TStringList.Create;
  try
    TempList.Add(timestamp);
    TempList.Add(nonce);
    TempList.Add(token);
    TempList.Sort;
    tempStr := '';
    for i := 0 to TempList.Count - 1 do
    begin
      tempStr := tempStr + TempList[i];
    end;
    tempStr := THashSHA1.GetHashString(tempStr);
    if tempStr = signature then
    begin
      result := True;
    end
    else
    begin
      TOneGlobal.GetInstance().Log.WriteLog('WeixinAuth', '验证Checksignature失败');
      TOneGlobal.GetInstance().Log.WriteLog('WeixinAuth', '接收到参数:' + QHTTPCtxt.UrlParams.text);
      TOneGlobal.GetInstance().Log.WriteLog('WeixinAuth', '本次签名结果:' + tempStr);
    end;
  finally
    TempList.Free;
  end;
end;

// 微信公众号消息回调地址
function TWeixinAuthController.OnePathMsgCallBack(QAppID: string): string;
var
  lWeiXinManage: TWeiXinManage;
  lHTTPCtxt: THTTPCtxt;
  lErrMsg: string;
  lWeixinAccount: TWeixinAccount;
begin
  result := '';
  lWeiXinManage := WeiXinManage.GetWeiXinManage();
  if not lWeiXinManage.WeixinAccountDict.tryGetValue(QAppID, lWeixinAccount) then
  begin
    TOneGlobal.GetInstance().Log.WriteLog('WeixinAuth', '微信公众号AppID[' + QAppID + ']不存在');
    exit;
  end;
  lHTTPCtxt := self.GetCureentHTTPCtxt(lErrMsg);
  if lHTTPCtxt = nil then
  begin
    TOneGlobal.GetInstance().Log.WriteLog('WeixinAuth', '获取上下文为nil:' + lErrMsg);
    exit;
  end;
  //
  if not Checksignature(lHTTPCtxt, lWeixinAccount) then
  begin
    exit;
  end;
  if lHTTPCtxt.Method = 'GET' then
  begin
    // 回调
    result := lHTTPCtxt.UrlParams.values['echostr'];
    exit;
  end;
  if lHTTPCtxt.Method <> 'POST' then
  begin
    exit;
  end;
  // 消息处理，后面在扩展
end;

// 微信公众号消息回调地址
function TWeixinAuthController.MsgCallBack(): string;
var
  lWeiXinManage: TWeiXinManage;
  lHTTPCtxt: THTTPCtxt;
  lErrMsg: string;
  lWeixinAccount, TempAccount: TWeixinAccount;
begin
  result := '';
  lWeixinAccount := nil;
  lWeiXinManage := WeiXinManage.GetWeiXinManage();
  for TempAccount in lWeiXinManage.WeixinAccountDict.values do
  begin
    if TempAccount.FAppType = '公众号' then
    begin
      lWeixinAccount := TempAccount;
      break;
    end
  end;

  if lWeixinAccount = nil then
  begin
    TOneGlobal.GetInstance().Log.WriteLog('WeixinAuth', '微信公众号不存在');
    exit;
  end;
  lHTTPCtxt := self.GetCureentHTTPCtxt(lErrMsg);
  if lHTTPCtxt = nil then
  begin
    TOneGlobal.GetInstance().Log.WriteLog('WeixinAuth', '获取上下文为nil:' + lErrMsg);
    exit;
  end;
  //
  if not Checksignature(lHTTPCtxt, lWeixinAccount) then
  begin
    exit;
  end;
  if lHTTPCtxt.Method = 'GET' then
  begin
    // 回调
    result := lHTTPCtxt.UrlParams.values['echostr'];
    exit;
  end;
  if lHTTPCtxt.Method <> 'POST' then
  begin
    exit;
  end;
  // 消息处理，后面在扩展
end;

// 小程序跟据授权Code结合系统一键登陆
function TWeixinAuthController.MinLoginByAuthCode(QLogin: TWeixinLogin): TActionResult<TWeixinLogin>;
var
  lWeiXinManage: TWeiXinManage;
  lWeixinAccount: TWeixinAccount;
  lWeixinRequest: TWeixinRequest;
  lOpenID, lUnionID: string;
  //
  lTokenManage: TOneTokenManage;
  lTokenItem: TOneTokenItem;
  lErrMsg: string;
begin
  result := TActionResult<TWeixinLogin>.Create(True, false);
  if QLogin.AppID = '' then
  begin
    result.ResultMsg := '小程序AppID为空,请上传AppID';
    exit;
  end;
  if QLogin.AuthCode = '' then
  begin
    result.ResultMsg := '授权码为空,请上传授权码';
    exit;
  end;
  //
  lWeixinAccount := nil;
  lWeiXinManage := WeiXinManage.GetWeiXinManage();
  if not lWeiXinManage.WeixinAccountDict.tryGetValue(QLogin.AppID, lWeixinAccount) then
  begin
    result.ResultMsg := '微信管理无此小程序AppID,请先填加管理';
    exit;
  end;
  if lWeixinAccount.FAppType <> '小程序' then
  begin
    result.ResultMsg := '此账号非小程序类型，当前账号类型[' + lWeixinAccount.FAppType + ']';
    exit;
  end;
  if lWeixinAccount.FAppSecret = '' then
  begin
    result.ResultMsg := '小程序密钥为空';
    exit;
  end;

  // 处理获取用户OpenID
  lWeixinRequest := TWeixinRequest.Create;
  try
    lWeixinRequest.AppID := lWeixinAccount.FAppID;
    lWeixinRequest.appSecret := lWeixinAccount.FAppSecret;
    lWeixinRequest.AuthCode := QLogin.AuthCode;
    // 获取用户OpenID过程
    if WeiXinMinApi.MinGetOpenIDByCode(lWeixinRequest) then
    begin
      result.ResultMsg := lWeixinRequest.ResultMsg;
      exit;
    end;
    lOpenID := lWeixinRequest.ResultOpenID;
    lUnionID := lWeixinRequest.ResultUnionID;
  finally
    lWeixinRequest.Free;
  end;
  // 先获取Token,和系统用户结合的,在另一种绑定接口
  // 正确增加Token返回相关的toeknID及私钥
  lTokenManage := TOneGlobal.GetInstance().TokenManage;
  lTokenItem := lTokenManage.AddLoginToken('WeixinMin', lOpenID, false, lErrMsg);
  if lTokenItem = nil then
  begin
    result.ResultMsg := lErrMsg;
    exit;
  end;
  lTokenItem.ThirdAppID := QLogin.AppID;
  lTokenItem.ThirdAppUserID := lOpenID;
  lTokenItem.ThirdAppUnionID := lUnionID;
  result.ResultData := TWeixinLogin.Create;
  result.ResultData.ResultToknID := lTokenItem.TokenID;
  result.ResultData.ResultPrivateKey := lTokenItem.PrivateKey;
  result.ResultData.ResultOpenID := lOpenID;
  result.SetResultTrue;
end;

initialization

// 单例模式注册
OneHttpRouterManage.GetInitRouterManage()
  .AddHTTPSingleWork('OneServer/WeixinAuth', TWeixinAuthController, 0, CreateNewWeixinAuthController);

finalization

end.

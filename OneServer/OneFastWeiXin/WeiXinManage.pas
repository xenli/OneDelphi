unit WeiXinManage;

interface

Uses
  system.Generics.Collections, system.Classes, system.SysUtils,
  system.StrUtils, system.DateUtils,
  OneThread, WeixinApiPublic;

type
  TWeixinAccount = class
  private
    FAccountID_: string;
    FSourceID_: string;
    FAppType_: string;
    FAppID_: string;
    FAppSecret_: string;
    FMessageToken_: string;
    FMessageEncodingAESKey_: string;
    FAccessTokenExpireIn_: integer;
    FAccessToken_: string;
    FAccessTokenLastTime_: TDateTime;
    FGetAuthorCodeUrl_: string;
    FErrWebUrl_: string;
    FAccessTokenErrMsg_: string;
    FJsApiTicket_: string;
    FJsApiLastTime_: TDateTime;
    FGetAuthorCodeAPI_: string;
    FCreateTime_: TDateTime;
  published
    property FAccountID: string read FAccountID_ write FAccountID_;
    property FSourceID: string read FSourceID_ write FSourceID_;
    property FAppID: string read FAppID_ write FAppID_;
    property FAppType: string read FAppType_ write FAppType_;
    property FAppSecret: string read FAppSecret_ write FAppSecret_;
    property FMessageToken: string read FMessageToken_ write FMessageToken_;
    property FMessageEncodingAESKey: string read FMessageEncodingAESKey_ write FMessageEncodingAESKey_;
    property FAccessTokenExpireIn: integer read FAccessTokenExpireIn_ write FAccessTokenExpireIn_;
    property FAccessToken: string read FAccessToken_ write FAccessToken_;
    property FAccessTokenLastTime: TDateTime read FAccessTokenLastTime_ write FAccessTokenLastTime_;
    property FGetAuthorCodeUrl: string read FGetAuthorCodeUrl_ write FGetAuthorCodeUrl_;
    property FErrWebUrl: string read FErrWebUrl_ write FErrWebUrl_;
    property FAccessTokenErrMsg: string read FAccessTokenErrMsg_ write FAccessTokenErrMsg_;
    property FJsApiTicket: string read FJsApiTicket_ write FJsApiTicket_;
    property FJsApiLastTime: TDateTime read FJsApiLastTime_ write FJsApiLastTime_;
    property FGetAuthorCodeAPI: string read FGetAuthorCodeAPI_ write FGetAuthorCodeAPI_;
    property FCreateTime: TDateTime read FCreateTime_ write FCreateTime_;
  end;

  TWeiXinManage = class
  private
    FLockObj: TObject;
    FZTCode: string;
    FWeixinAccountDict: TDictionary<string, TWeixinAccount>;
    FAutoThread: TOneTimerThread;
  private
    procedure AutoWorkEven(send: TObject);
  public
    constructor Create;
    destructor Destroy; override;
  public
    // 定时刷新 Token数据
    // 重新获取账号
    function RefreshWeixinAccount(var QErrMsg: string): boolean;
    // 重新刷新账号Token
    function RefreshWeixinAccessToken(QbForce: boolean; var QErrMsg: string): boolean;
  public
    property WeixinAccountDict: TDictionary<string, TWeixinAccount> read FWeixinAccountDict write FWeixinAccountDict;
  end;

function GetWeiXinManage(): TWeiXinManage;

implementation

uses OneOrm, WeixinApi, OneGlobal, OneLog;

var
  Unit_WeiXinManage: TWeiXinManage = nil;

function GetWeiXinManage(): TWeiXinManage;
begin
  if Unit_WeiXinManage = nil then
  begin
    Unit_WeiXinManage := TWeiXinManage.Create;
  end;
  Result := Unit_WeiXinManage;
end;

constructor TWeiXinManage.Create;
var
  lErrMsg: string;
begin
  FWeixinAccountDict := TDictionary<string, TWeixinAccount>.Create;
  FLockObj := TObject.Create;
  self.RefreshWeixinAccount(lErrMsg);
  FAutoThread := TOneTimerThread.Create(self.AutoWorkEven);
  // 5分钟运作一次
  FAutoThread.IntervalSec := 60 * 5;
  FAutoThread.StartWork();
end;

destructor TWeiXinManage.Destroy;
var
  lWeixinAccount: TWeixinAccount;
begin
  for lWeixinAccount in FWeixinAccountDict.Values do
  begin
    lWeixinAccount.Free
  end;
  FWeixinAccountDict.Clear;
  FWeixinAccountDict.Free;
  FLockObj.Free;
  FAutoThread.StopWork;
  FAutoThread.FreeWork;
  inherited Destroy;
end;

procedure TWeiXinManage.AutoWorkEven(send: TObject);
var
  lErrMsg: string;
begin
  self.RefreshWeixinAccessToken(false, lErrMsg);
end;

function TWeiXinManage.RefreshWeixinAccount(var QErrMsg: string): boolean;
var
  lWeixinAccount: TWeixinAccount;
  lOrmAccount: IOneOrm<TWeixinAccount>;
  lList: TList<TWeixinAccount>;
  I: integer;
begin
  Result := false;
  TMonitor.Enter(self.FLockObj);
  try
    for lWeixinAccount in FWeixinAccountDict.Values do
    begin
      lWeixinAccount.Free
    end;
    FWeixinAccountDict.Clear;

    lOrmAccount := TOneOrm<TWeixinAccount>.Start();
    try
      lList := lOrmAccount.ZTCode(self.FZTCode).Query('select * from onefast_weixin', []).ToList();
      for I := lList.Count - 1 downto 0 do
      begin
        lWeixinAccount := lList[I];
        if lWeixinAccount.FAppID = '' then
          continue;
        if not FWeixinAccountDict.ContainsKey(lWeixinAccount.FAppID) then
        begin
          FWeixinAccountDict.Add(lWeixinAccount.FAppID, lWeixinAccount);
          lList.Delete(I);
        end;
      end;
    except
      on e: Exception do
      begin
        QErrMsg := e.Message;
        TOneGlobal.GetInstance().Log.WriteLog('WeiXinManage', '获取微信账套信息出错:');
        TOneGlobal.GetInstance().Log.WriteLog('WeiXinManage', QErrMsg);
        exit;
      end;
    end;
    Result := true;
  finally
    TMonitor.exit(self.FLockObj);
    if lList <> nil then
    begin
      for I := lList.Count - 1 downto 0 do
      begin
        lList[I].Free;
      end;
      lList.Clear;
      lList.Free;
    end;
  end;
end;

function TWeiXinManage.RefreshWeixinAccessToken(QbForce: boolean; var QErrMsg: string): boolean;
var
  lWeixinAccount: TWeixinAccount;
  lNow: TDateTime;
  isReshToken: boolean;
  lWeixinRequest: TWeixinRequest;
  lOrmAccount: IOneOrm<TWeixinAccount>;
begin
  Result := false;
  QErrMsg := '';
  lNow := now;
  TMonitor.Enter(self.FLockObj);
  try
    for lWeixinAccount in self.FWeixinAccountDict.Values do
    begin
      isReshToken := true;
      if not QbForce then
      begin
        // 判断失效了没
        if lWeixinAccount.FAccessTokenLastTime > 100 then
        begin
          // 要刷新了
          if SecondsBetween(lNow, lWeixinAccount.FAccessTokenLastTime) > 60 then
          begin
            if lNow > lWeixinAccount.FAccessTokenLastTime then
              isReshToken := true
            else
              isReshToken := false;
          end
          else
            isReshToken := false; // 不需刷新
        end;
      end
      else
      begin
        isReshToken := true;
      end;
      if not isReshToken then
        continue;
      lWeixinAccount.FAccessTokenErrMsg := '';
      // 获取Token
      lWeixinRequest := TWeixinRequest.Create;
      try
        lWeixinRequest.appID := lWeixinAccount.FAppID;
        lWeixinRequest.appSecret := lWeixinAccount.FAppSecret;
        if WeixinApi.GetWeixinAccesstoken(lWeixinRequest) then
        begin
          // 更新
          lWeixinAccount.FAccessToken := lWeixinRequest.accessToken;
          lWeixinAccount.FAccessTokenLastTime := IncSecond(lNow, 6600);
          lWeixinAccount.FAccessTokenErrMsg := '刷新Token成功';
        end
        else
        begin
          lWeixinAccount.FAccessTokenErrMsg := lWeixinRequest.resultMsg;
        end;
        // 更新数据
        lOrmAccount := TOneOrm<TWeixinAccount>.Start();
        lOrmAccount.Update(lWeixinAccount)
          .SetTableName('onefast_weixin').SetPrimaryKey('FAccountID')
          .Fields(['FAccessToken', 'FAccessTokenLastTime', 'FAccessTokenErrMsg'])
          .toCmd().ToExecCommand();
      finally
        lWeixinRequest.Free;
      end;
    end;
  finally
    TMonitor.exit(self.FLockObj);
  end;
  Result := true;
end;

initialization


finalization

if Unit_WeiXinManage <> nil then
  Unit_WeiXinManage.Free;

end.

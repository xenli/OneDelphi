unit WeiXinMinApi;

interface

uses
  System.JSON, System.Classes, System.SysConst, System.SysUtils,
  System.Net.URLClient, System.Net.HttpClient, System.Net.HttpClientComponent,
  WeixinApiPublic;

const
  const_weixinMinUrl_code2Session = 'https://api.weixin.qq.com/sns/jscode2session?' +
    'appid=%s&secret=%s&js_code=%s&grant_type=authorization_code';

  // 跟据前台授权Code获取小程序用户OpenID
  // 文档地址https://developers.weixin.qq.com/miniprogram/dev/OpenApiDoc/user-login/code2Session.html
function MinGetOpenIDByCode(QWeixinRequest: TWeixinRequest): boolean;

implementation

function MinGetOpenIDByCode(QWeixinRequest: TWeixinRequest): boolean;
var
  lNetHTTPClient: TNetHTTPClient;
  lUrl: string;
  lHTTPResponse: IHTTPResponse;
  lResponseStream: TMemoryStream;
  lResponseBytes: TBytes;
  lJsonObj: TJsonObject;
  lTempStr: string;
begin
  Result := false;
  if QWeixinRequest.appID = '' then
  begin
    QWeixinRequest.resultMsg := '小程序AppID不可为空';
    exit;
  end;
  if QWeixinRequest.appSecret = '' then
  begin
    QWeixinRequest.resultMsg := '小程序AppSecret不可为空';
    exit;
  end;
  if QWeixinRequest.authCode = '' then
  begin
    QWeixinRequest.resultMsg := '小程序authCode不可为空';
    exit;
  end;

  lNetHTTPClient := GetNetHTTPClient();
  lUrl := Format(const_weixinMinUrl_code2Session, [QWeixinRequest.appID, QWeixinRequest.appSecret, QWeixinRequest.authCode]);
  lJsonObj := nil;
  lResponseStream := TMemoryStream.Create;
  try
    lHTTPResponse := lNetHTTPClient.Get(lUrl, lResponseStream);
    if lHTTPResponse = nil then
    begin
      QWeixinRequest.resultMsg := 'HTTP请求失败,返回结果为nil';
      exit;
    end;
    if lHTTPResponse.StatusCode <> 200 then
    begin
      QWeixinRequest.resultMsg := 'HTTP请求失败,返回HTTP状态码[' + lHTTPResponse.StatusCode.ToString + '],状态消息[' + lHTTPResponse.StatusText + ']';
      exit;
    end;
    lResponseStream.Position := 0;
    setLength(lResponseBytes, lResponseStream.Size);
    lResponseStream.Read(lResponseBytes, lResponseStream.Size);
    QWeixinRequest.resultDataString := TEncoding.UTF8.GetString(lResponseBytes);
    lJsonObj := TJsonObject.ParseJSONValue(lResponseBytes, 0) as TJsonObject;
    if lJsonObj = nil then
    begin
      // 返回的数据有问题，无法解析成JSON
      QWeixinRequest.resultMsg := '返回的数据无法解析成Json请检查:' + QWeixinRequest.resultDataString;
      exit;
    end;
    // 处理结果
    if lJsonObj.TryGetValue<string>('openid', lTempStr) then
    begin
      QWeixinRequest.resultOpenID := lTempStr;
      if lJsonObj.TryGetValue<string>('unionid', lTempStr) then
      begin
        QWeixinRequest.resultUnionid := lTempStr;
      end;
    end;
    if lJsonObj.TryGetValue<string>('errcode', lTempStr) then
    begin
      QWeixinRequest.resultCode := lTempStr;
    end;
    if lJsonObj.TryGetValue<string>('errmsg', lTempStr) then
    begin
      QWeixinRequest.resultMsg := lTempStr;
    end;
    if QWeixinRequest.resultCode = '0' then
    begin
      QWeixinRequest.resultSucces := true;
      Result := true;
    end;
  finally
    lResponseStream.Free;
    if lJsonObj <> nil then
      lJsonObj.Free;
  end;
  //

end;

end.

unit WeixinApi;

interface

uses
  System.JSON, System.Classes, System.SysConst, System.SysUtils,
  System.Net.URLClient, System.Net.HttpClient, System.Net.HttpClientComponent,
  WeixinApiPublic;

const
  const_weixinUrl_GetToke = 'https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid=%s&secret=%s';

  // 获取微信公众号及小程序 access_token
  // URL地址:https://developers.weixin.qq.com/doc/offiaccount/Basic_Information/Get_access_token.html
function GetWeixinAccesstoken(QWeixinRequest: TWeixinRequest): boolean;

implementation


function GetWeixinAccesstoken(QWeixinRequest: TWeixinRequest): boolean;
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
    QWeixinRequest.resultMsg := '微信AppID不可为空';
    exit;
  end;
  if QWeixinRequest.appSecret = '' then
  begin
    QWeixinRequest.resultMsg := '微信AppSecret不可为空';
    exit;
  end;

  lNetHTTPClient := GetNetHTTPClient();
  lUrl := Format(const_weixinUrl_GetToke, [QWeixinRequest.appID, QWeixinRequest.appSecret]);
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
      QWeixinRequest.resultMsg := '返回的数据无法解析成Json请检查:' + TEncoding.UTF8.GetString(lResponseBytes);
      exit;
    end;
    // 处理结果
    if not lJsonObj.TryGetValue<string>('access_token', lTempStr) then
    begin
      if lJsonObj.TryGetValue<string>('errcode', lTempStr) then
      begin
        QWeixinRequest.resultCode := lTempStr;
      end;
      if lJsonObj.TryGetValue<string>('errmsg', lTempStr) then
      begin
        QWeixinRequest.resultMsg := lTempStr;
      end;
      if QWeixinRequest.resultMsg = '' then
      begin
        QWeixinRequest.resultMsg := lJsonObj.ToString;
      end;
      exit;
    end;
    QWeixinRequest.accessToken := lTempStr;
    QWeixinRequest.resultSucces := true;
    Result := true;
  finally
    lResponseStream.Free;
    if lJsonObj <> nil then
      lJsonObj.Free;
  end;
  //

end;

end.

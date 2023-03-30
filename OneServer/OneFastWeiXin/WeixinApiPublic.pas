unit WeixinApiPublic;

interface

uses
  System.JSON, System.Classes, System.SysConst, System.SysUtils,
  System.Net.URLClient, System.Net.HttpClient, System.Net.HttpClientComponent;

type
  TWeixinRequest = class
  public
    appID: string;
    appSecret: string;
    accessToken: string;
    authCode: string;
    // 请求结果
    resultSucces: boolean;
    resultCode: string;
    resultMsg: string;
    resultOpenID: string;
    resultUnionid: string;
    resultDataString: string;
  end;

function GetNetHTTPClient(): TNetHTTPClient;

implementation

var
  Unit_NetHTTPClient: TNetHTTPClient = nil;

function GetNetHTTPClient(): TNetHTTPClient;
begin
  if Unit_NetHTTPClient = nil then
  begin
    Unit_NetHTTPClient := TNetHTTPClient.Create(nil);
    Unit_NetHTTPClient.ContentType := 'application/x-www-form-urlencoded';
  end;
  Result := Unit_NetHTTPClient;
end;

initialization


finalization

if Unit_NetHTTPClient <> nil then
  Unit_NetHTTPClient.Free;

end.

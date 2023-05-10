unit OneClientFastLsh;

interface

uses system.Classes, system.SysUtils, OneClientConnect, system.Generics.Collections,
  system.json, OneClientConst;

const
  // 流水号获取相关功能
  URL_HTTP_HTTPServer_LSH_RefreshLshSet = 'OneServer/FastLsh/RefreshLshSet';
  URL_HTTP_HTTPServer_LSH_GetLsh = 'OneServer/FastLsh/GetLsh';
  URL_HTTP_HTTPServer_LSH_GetLshList = 'OneServer/FastLsh/GetLshList';

type

  [ComponentPlatformsAttribute(OneAllPlatforms)]
  TOneFastLsh = class(TComponent)
  private
    FConnection: TOneConnection;
    //
    FErrMsg: string;
  private
    // 获取连接
    function GetConnection: TOneConnection;
    procedure SetConnection(const AValue: TOneConnection);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    // 刷新流水号配置
    function RefreshLshSet(var QErrMsg: string): boolean;
    // 生成单个流水号
    function GetLsh(QLshCode: string; var QErrMsg: string): string;
    // 批量生成
    function GetLshList(QLshCode: string; QStep: integer; var QErrMsg: string): TList<string>;
  published
    property Connection: TOneConnection read GetConnection write SetConnection;
  end;

implementation

uses OneClientResult, OneNeonHelper;

constructor TOneFastLsh.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TOneFastLsh.Destroy;
begin
  inherited Destroy;
end;

function TOneFastLsh.GetConnection: TOneConnection;
begin
  Result := Self.FConnection;
end;

procedure TOneFastLsh.SetConnection(const AValue: TOneConnection);
begin
  Self.FConnection := AValue;
end;

function TOneFastLsh.RefreshLshSet(var QErrMsg: string): boolean;
var
  lErrMsg: string;
  //
  lJsonObj: TJsonObject;
  lResultJsonValue: TJsonValue;
  lServerResult: TActionResult<string>;
begin
  Result := false;
  QErrMsg := '';
  if Self.FConnection = nil then
    Self.FConnection := OneClientConnect.Unit_Connection;
  if Self.FConnection = nil then
  begin
    QErrMsg := '数据集Connection=nil';
    exit;
  end;
  // 获取流水号
  lResultJsonValue := nil;
  lServerResult := TActionResult<string>.Create;
  lServerResult.ResultData := '';
  lJsonObj := TJsonObject.Create;
  try
    lResultJsonValue := Self.FConnection.PostResultJsonValue(URL_HTTP_HTTPServer_LSH_RefreshLshSet, '', lErrMsg);
    if not Self.FConnection.IsErrTrueResult(lErrMsg) then
    begin
      QErrMsg := lErrMsg;
      exit;
    end;
    if not OneNeonHelper.JsonToObject(lServerResult, lResultJsonValue, lErrMsg) then
    begin
      QErrMsg := '返回的数据解析成TResult<TClientConnect>出错,无法知道结果,数据:' + lResultJsonValue.ToJSON;
      exit;
    end;
    if not lServerResult.ResultSuccess then
    begin
      QErrMsg := '服务端消息:' + lServerResult.ResultMsg;
      exit;
    end;
    Result := true;
  finally
    lJsonObj.free;
    if lResultJsonValue <> nil then
    begin
      lResultJsonValue.free;
    end;
    lServerResult.free;
  end;
end;

function TOneFastLsh.GetLsh(QLshCode: string; var QErrMsg: string): string;
var
  lErrMsg: string;
  //
  lJsonObj: TJsonObject;
  lResultJsonValue: TJsonValue;
  lServerResult: TActionResult<string>;
  IsOK: boolean;
begin
  Result := '';
  QErrMsg := '';
  if QLshCode = '' then
  begin
    QErrMsg := '流水号代码不可为空';
    exit;
  end;
  if Self.FConnection = nil then
    Self.FConnection := OneClientConnect.Unit_Connection;
  if Self.FConnection = nil then
  begin
    QErrMsg := '数据集Connection=nil';
    exit;
  end;
  // 获取流水号
  lResultJsonValue := nil;
  lServerResult := TActionResult<string>.Create;
  lServerResult.ResultData := '';
  lJsonObj := TJsonObject.Create;
  try
    lJsonObj.AddPair('QLshCode', QLshCode);
    lResultJsonValue := Self.FConnection.PostResultJsonValue(URL_HTTP_HTTPServer_LSH_GetLsh, lJsonObj.ToJSON(), lErrMsg);
    if not Self.FConnection.IsErrTrueResult(lErrMsg) then
    begin
      QErrMsg := lErrMsg;
      exit;
    end;
    if not OneNeonHelper.JsonToObject(lServerResult, lResultJsonValue, lErrMsg) then
    begin
      QErrMsg := '返回的数据解析成TResult<TClientConnect>出错,无法知道结果,数据:' + lResultJsonValue.ToJSON;
      exit;
    end;
    if not lServerResult.ResultSuccess then
    begin
      QErrMsg := '服务端消息:' + lServerResult.ResultMsg;
      exit;
    end;
    Result := lServerResult.ResultData;
    IsOK := true;
  finally
    lJsonObj.free;
    if lResultJsonValue <> nil then
    begin
      lResultJsonValue.free;
    end;
    lServerResult.free;
  end;
end;

function TOneFastLsh.GetLshList(QLshCode: string; QStep: integer; Var QErrMsg: string): TList<string>;
var
  lErrMsg: string;
  //
  lJsonObj: TJsonObject;
  lResultJsonValue: TJsonValue;
  lServerResult: TActionResult<TList<string>>;
  IsOK: boolean;
begin
  Result := nil;
  QErrMsg := '';
  if QLshCode = '' then
  begin
    QErrMsg := '流水号代码不可为空';
    exit;
  end;
  if QStep <= 0 then
    QStep := 1;
  if Self.FConnection = nil then
    Self.FConnection := OneClientConnect.Unit_Connection;
  if Self.FConnection = nil then
  begin
    QErrMsg := '数据集Connection=nil';
    exit;
  end;
  // 获取流水号
  IsOK := false;
  lResultJsonValue := nil;
  lServerResult := TActionResult < TList < string >>.Create;
  lServerResult.ResultData := TList<string>.Create;
  lJsonObj := TJsonObject.Create;
  try
    lJsonObj.AddPair('QLshCode', QLshCode);
    lJsonObj.AddPair('QStep', TJSONNumber.Create(QStep));
    lResultJsonValue := Self.FConnection.PostResultJsonValue(URL_HTTP_HTTPServer_LSH_GetLshList, lJsonObj.ToJSON(), lErrMsg);
    if not Self.FConnection.IsErrTrueResult(lErrMsg) then
    begin
      QErrMsg := lErrMsg;
      exit;
    end;
    if not OneNeonHelper.JsonToObject(lServerResult, lResultJsonValue, lErrMsg) then
    begin
      QErrMsg := '返回的数据解析成TResult<TList<string>>出错,无法知道结果,数据:' + lResultJsonValue.ToJSON;
      exit;
    end;
    if not lServerResult.ResultSuccess then
    begin
      QErrMsg := '服务端消息:' + lServerResult.ResultMsg;
      exit;
    end;
    Result := lServerResult.ResultData;
    IsOK := true;
  finally
    lJsonObj.free;
    if lResultJsonValue <> nil then
    begin
      lResultJsonValue.free;
    end;
    if not IsOK then
    begin
      lServerResult.ResultData.clear;
      lServerResult.ResultData.free;
      lServerResult.ResultData := nil;
    end
    else
    begin
      lServerResult.ResultData := nil;
    end;
    lServerResult.free;
  end;
end;

end.

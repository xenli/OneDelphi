unit OneClientFastBillLock;

interface

uses system.Classes, system.SysUtils, OneClientConnect, system.Generics.Collections,
  system.json, OneClientConst;

const
  // 流水号获取相关功能
  URL_HTTP_HTTPServer_BillLock_LockBill = 'OneServer/FastBillLock/LockBill';
  URL_HTTP_HTTPServer_BillLock_UnLockBill = 'OneServer/FastBillLock/UnLockBill';
  URL_HTTP_HTTPServer_BillLock_UnLockBillForce = 'OneServer/FastBillLock/UnLockBillForce';

type

  [ComponentPlatformsAttribute(OneAllPlatforms)]
  TOneBillLock = class(TComponent)
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
    /// <summary>
    /// 申请订单锁
    /// QBillID:订单ID，QUserID:用户ID，QLockSec:锁单时间(秒) -1无限时间，0默认30分钟
    /// </summary>
    /// <returns>失败返回False,错误信息在ErrMsg属性</returns>
    function LockBill(QBillID: string; QUserID: string; QLockSec: integer; var QErrMsg: string): boolean;
    /// <summary>
    /// 解锁订单锁
    /// </summary>
    /// <returns>失败返回False,错误信息在ErrMsg属性</returns>
    function UnLockBill(QBillID: string; QUserID: string; var QErrMsg: string): boolean;

    /// <summary>
    /// 强制解锁订单锁
    /// </summary>
    /// <returns>失败返回False,错误信息在ErrMsg属性</returns>
    function UnLockBillForce(QBillID: string; var QErrMsg: string): boolean;
  published
    property Connection: TOneConnection read GetConnection write SetConnection;
  end;

implementation

uses OneClientResult, OneNeonHelper;

constructor TOneBillLock.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TOneBillLock.Destroy;
begin
  inherited Destroy;
end;

function TOneBillLock.GetConnection: TOneConnection;
begin
  Result := Self.FConnection;
end;

procedure TOneBillLock.SetConnection(const AValue: TOneConnection);
begin
  Self.FConnection := AValue;
end;

function TOneBillLock.LockBill(QBillID: string; QUserID: string; QLockSec: integer; var QErrMsg: string): boolean;
var
  lErrMsg: string;
  //
  lJsonObj: TJsonObject;
  lResultJsonValue: TJsonValue;
  lServerResult: TActionResult<string>;
begin
  Result := false;
  QErrMsg := '';
  if QBillID = '' then
  begin
    QErrMsg := '锁单ID不可为空';
    exit;
  end;
  if QUserID = '' then
  begin
    QErrMsg := '锁单用户不可为空';
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
    lJsonObj.AddPair('BillID', QBillID);
    lJsonObj.AddPair('UserID', QUserID);
    lJsonObj.AddPair('LockSec', QLockSec);
    lResultJsonValue := Self.FConnection.PostResultJsonValue(URL_HTTP_HTTPServer_BillLock_LockBill, lJsonObj.ToJSON(), lErrMsg);
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
    Result := lServerResult.ResultSuccess;
  finally
    lJsonObj.free;
    if lResultJsonValue <> nil then
    begin
      lResultJsonValue.free;
    end;
    lServerResult.free;
  end;
end;

function TOneBillLock.UnLockBill(QBillID: string; QUserID: string; var QErrMsg: string): boolean;
var
  lErrMsg: string;
  //
  lJsonObj: TJsonObject;
  lResultJsonValue: TJsonValue;
  lServerResult: TActionResult<string>;
begin
  Result := false;
  QErrMsg := '';
  if QBillID = '' then
  begin
    QErrMsg := '锁单ID不可为空';
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
    lJsonObj.AddPair('BillID', QBillID);
    lJsonObj.AddPair('UserID', QUserID);
    lResultJsonValue := Self.FConnection.PostResultJsonValue(URL_HTTP_HTTPServer_BillLock_UnLockBill, lJsonObj.ToJSON(), lErrMsg);
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
    Result := lServerResult.ResultSuccess;
  finally
    lJsonObj.free;
    if lResultJsonValue <> nil then
    begin
      lResultJsonValue.free;
    end;
    lServerResult.free;
  end;
end;

function TOneBillLock.UnLockBillForce(QBillID: string; var QErrMsg: string): boolean;
var
  lErrMsg: string;
  //
  lJsonObj: TJsonObject;
  lResultJsonValue: TJsonValue;
  lServerResult: TActionResult<string>;
begin
  Result := false;
  QErrMsg := '';
  if QBillID = '' then
  begin
    QErrMsg := '锁单ID不可为空';
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
    lJsonObj.AddPair('BillID', QBillID);
    lResultJsonValue := Self.FConnection.PostResultJsonValue(URL_HTTP_HTTPServer_BillLock_UnLockBillForce, lJsonObj.ToJSON(), lErrMsg);
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
    Result := lServerResult.ResultSuccess;
  finally
    lJsonObj.free;
    if lResultJsonValue <> nil then
    begin
      lResultJsonValue.free;
    end;
    lServerResult.free;
  end;
end;

end.

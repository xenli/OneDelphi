unit OneClientFastBillLock;

interface

uses system.Classes, system.SysUtils, OneClientConnect, system.Generics.Collections,
  system.json, OneClientConst;

const
  // ��ˮ�Ż�ȡ��ع���
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
    // ��ȡ����
    function GetConnection: TOneConnection;
    procedure SetConnection(const AValue: TOneConnection);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    /// <summary>
    /// ���붩����
    /// QBillID:����ID��QUserID:�û�ID��QLockSec:����ʱ��(��) -1����ʱ�䣬0Ĭ��30����
    /// </summary>
    /// <returns>ʧ�ܷ���False,������Ϣ��ErrMsg����</returns>
    function LockBill(QBillID: string; QUserID: string; QLockSec: integer; var QErrMsg: string): boolean;
    /// <summary>
    /// ����������
    /// </summary>
    /// <returns>ʧ�ܷ���False,������Ϣ��ErrMsg����</returns>
    function UnLockBill(QBillID: string; QUserID: string; var QErrMsg: string): boolean;

    /// <summary>
    /// ǿ�ƽ���������
    /// </summary>
    /// <returns>ʧ�ܷ���False,������Ϣ��ErrMsg����</returns>
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
    QErrMsg := '����ID����Ϊ��';
    exit;
  end;
  if QUserID = '' then
  begin
    QErrMsg := '�����û�����Ϊ��';
    exit;
  end;
  if Self.FConnection = nil then
    Self.FConnection := OneClientConnect.Unit_Connection;
  if Self.FConnection = nil then
  begin
    QErrMsg := '���ݼ�Connection=nil';
    exit;
  end;
  // ��ȡ��ˮ��
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
      QErrMsg := '���ص����ݽ�����TResult<TClientConnect>����,�޷�֪�����,����:' + lResultJsonValue.ToJSON;
      exit;
    end;
    if not lServerResult.ResultSuccess then
    begin
      QErrMsg := '�������Ϣ:' + lServerResult.ResultMsg;
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
    QErrMsg := '����ID����Ϊ��';
    exit;
  end;
  if Self.FConnection = nil then
    Self.FConnection := OneClientConnect.Unit_Connection;
  if Self.FConnection = nil then
  begin
    QErrMsg := '���ݼ�Connection=nil';
    exit;
  end;
  // ��ȡ��ˮ��
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
      QErrMsg := '���ص����ݽ�����TResult<TClientConnect>����,�޷�֪�����,����:' + lResultJsonValue.ToJSON;
      exit;
    end;
    if not lServerResult.ResultSuccess then
    begin
      QErrMsg := '�������Ϣ:' + lServerResult.ResultMsg;
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
    QErrMsg := '����ID����Ϊ��';
    exit;
  end;
  if Self.FConnection = nil then
    Self.FConnection := OneClientConnect.Unit_Connection;
  if Self.FConnection = nil then
  begin
    QErrMsg := '���ݼ�Connection=nil';
    exit;
  end;
  // ��ȡ��ˮ��
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
      QErrMsg := '���ص����ݽ�����TResult<TClientConnect>����,�޷�֪�����,����:' + lResultJsonValue.ToJSON;
      exit;
    end;
    if not lServerResult.ResultSuccess then
    begin
      QErrMsg := '�������Ϣ:' + lServerResult.ResultMsg;
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

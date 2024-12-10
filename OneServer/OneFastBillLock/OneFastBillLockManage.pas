unit OneFastBillLockManage;
// �ṩ��������һЩ���׹���

interface

uses
  system.Generics.Collections, system.SysUtils, system.Classes, system.StrUtils, system.DateUtils,
  system.SyncObjs, OneThread, OneDate;

type

  TBillLockDo = class
  private
    FBillID: string;
    FUserID: string;
    FLockSec: integer;
  public
    property BillID: string read FBillID write FBillID;
    property UserID: string read FUserID write FUserID;
    property LockSec: integer read FLockSec write FLockSec;
  end;

  TBillLock = class(TObject)
  private
    FBillID: string; // ����ID
    FUserID: string; // ����˭
    FLockTime: TDateTime; // ����ʱ��
    FLastTime: TDateTime; // ��󽻻�ʱ��
    FLostSec: integer; // ʧЧ��������Ϊ-1Ϊ����ʱ��
  end;

  TFastBillLockManage = class(TObject)
  private
    FBillLockDict: TDictionary<string, TBillLock>;
    FLockObj: TCriticalSection;
    FTimerThread: TOneTimerThread;
  private
    procedure onTimerWork(Sender: TObject);
  public
    constructor Create();
    destructor Destroy; override;
  public
    function LockBill(QBillID: string; QUserID: string; QLockSec: integer; var QErrMsg: string): boolean;
    function UnLockBill(QBillID: string; QUserID: string; var QErrMsg: string): boolean;
    procedure UnLockBillForce(QBillID: string);
  end;

function UnitFastBillLockManage(): TFastBillLockManage;

implementation

var
  Unit_BillLockMange: TFastBillLockManage = nil;

function UnitFastBillLockManage(): TFastBillLockManage;
var
  lErrMsg: string;
begin
  if Unit_BillLockMange = nil then
  begin
    Unit_BillLockMange := TFastBillLockManage.Create;
  end;
  Result := Unit_BillLockMange;
end;

constructor TFastBillLockManage.Create();
begin
  inherited Create;
  FBillLockDict := TDictionary<string, TBillLock>.Create;
  FLockObj := TCriticalSection.Create;
  FTimerThread := TOneTimerThread.Create(self.onTimerWork);
end;

destructor TFastBillLockManage.Destroy;
var
  lBillLock: TBillLock;
begin
  for lBillLock in FBillLockDict.Values do
  begin
    lBillLock.Free;
  end;
  FBillLockDict.Clear;
  FBillLockDict.Free;
  FLockObj.Free;
  inherited Destroy;
end;

procedure TFastBillLockManage.onTimerWork(Sender: TObject);
var
  lNow: TDateTime;
  lBillLock: TBillLock;
  lDelList: TList<string>;
  i: integer;
begin
  // ��ʱ�����ʱ��
  lNow := now;
  lDelList := TList<string>.Create;
  FLockObj.Enter;
  try
    for lBillLock in FBillLockDict.Values do
    begin
      if lBillLock = nil then
        continue;
      if lBillLock.FLostSec <= 0 then
      begin
        // ����ʱ
        continue;
      end;
      if SecondsBetweenNotAbs(now, lBillLock.FLastTime) > lBillLock.FLostSec then
      begin
        lDelList.Add(lBillLock.FBillID);
        lBillLock.Free;
      end;
    end;
    // ɾ��ʧЧ����
    for i := 0 to lDelList.count - 1 do
    begin
      FBillLockDict.Remove(lDelList[i]);
    end;

  finally
    FLockObj.Leave;
    lDelList.Free;
  end;
end;

function TFastBillLockManage.LockBill(QBillID: string; QUserID: string; QLockSec: integer; var QErrMsg: string): boolean;
var
  lBillLock: TBillLock;
begin
  Result := false;
  QErrMsg := '';
  lBillLock := nil;
  // Ĭ����30����
  if QLockSec = 0 then
    QLockSec := 60 * 30;
  FLockObj.Enter;
  try
    if FBillLockDict.TryGetValue(QBillID, lBillLock) then
    begin
      // �ж��ǲ���ʧЧ,�����ʧЧ��,ֱ���滻
      if lBillLock.FLostSec > 0 then
      begin
        if SecondsBetweenNotAbs(now, lBillLock.FLastTime) > lBillLock.FLostSec then
        begin
          // ԭ����ʧЧ���滻���µ����ˣ��µ������ɹ�
          lBillLock.FBillID := QBillID;
          lBillLock.FUserID := QUserID;
          lBillLock.FLockTime := now();
          lBillLock.FLastTime := lBillLock.FLockTime;
          lBillLock.FLostSec := QLockSec;
          Result := true;
          exit;
        end;
      end;
      //
      if lBillLock.FUserID <> QUserID then
      begin
        QErrMsg := '�����ѱ��û�[' + QUserID + ']����';
        exit;
      end;
      // ����ʹ��ʱ��
      lBillLock.FLastTime := now();
      Result := true;
    end
    else
    begin
      lBillLock := TBillLock.Create;
      lBillLock.FBillID := QBillID;
      lBillLock.FUserID := QUserID;
      lBillLock.FLockTime := now();
      lBillLock.FLastTime := lBillLock.FLockTime;
      lBillLock.FLostSec := QLockSec;
      FBillLockDict.Add(QBillID, lBillLock);
      Result := true;
    end;
  finally
    FLockObj.Leave;
  end;

end;

function TFastBillLockManage.UnLockBill(QBillID: string; QUserID: string; var QErrMsg: string): boolean;
var
  lBillLock: TBillLock;
begin
  QErrMsg := '';
  FLockObj.Enter;
  try
    lBillLock := nil;
    if FBillLockDict.TryGetValue(QBillID, lBillLock) then
    begin
      if lBillLock.FUserID <> QUserID then
      begin
        QErrMsg := '�����ѱ��û�[' + QUserID + ']����';
        exit;
      end;
      FBillLockDict.Remove(QBillID);
      if lBillLock <> nil then
      begin
        lBillLock.Free;
        lBillLock := nil;
      end;
    end;
  finally
    FLockObj.Leave;
  end;
end;

procedure TFastBillLockManage.UnLockBillForce(QBillID: string);
var
  lBillLock: TBillLock;
begin
  FLockObj.Enter;
  try
    lBillLock := nil;
    if FBillLockDict.TryGetValue(QBillID, lBillLock) then
    begin
      FBillLockDict.Remove(QBillID);
      if lBillLock <> nil then
      begin
        lBillLock.Free;
        lBillLock := nil;
      end;
    end;
  finally
    FLockObj.Leave;
  end;
end;

initialization

finalization

if Unit_BillLockMange <> nil then
  Unit_BillLockMange.Free;

end.

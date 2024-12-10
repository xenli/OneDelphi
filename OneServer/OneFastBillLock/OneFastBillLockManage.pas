unit OneFastBillLockManage;
// 提供锁定定单一些简易管理

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
    FBillID: string; // 订单ID
    FUserID: string; // 属于谁
    FLockTime: TDateTime; // 锁定时间
    FLastTime: TDateTime; // 最后交互时间
    FLostSec: integer; // 失效秒数，当为-1为无限时间
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
  // 定时清除超时的
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
        // 无限时
        continue;
      end;
      if SecondsBetweenNotAbs(now, lBillLock.FLastTime) > lBillLock.FLostSec then
      begin
        lDelList.Add(lBillLock.FBillID);
        lBillLock.Free;
      end;
    end;
    // 删除失效订单
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
  // 默认锁30分钟
  if QLockSec = 0 then
    QLockSec := 60 * 30;
  FLockObj.Enter;
  try
    if FBillLockDict.TryGetValue(QBillID, lBillLock) then
    begin
      // 判断是不是失效,如果是失效的,直接替换
      if lBillLock.FLostSec > 0 then
      begin
        if SecondsBetweenNotAbs(now, lBillLock.FLastTime) > lBillLock.FLostSec then
        begin
          // 原本的失效，替换成新的主人，新的锁单成功
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
        QErrMsg := '订单已被用户[' + QUserID + ']锁定';
        exit;
      end;
      // 更新使用时间
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
        QErrMsg := '订单已被用户[' + QUserID + ']锁定';
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

unit OneFastBillLockController;

interface

uses
  system.StrUtils, system.SysUtils, Math, system.JSON, system.Threading, system.Classes,
  OneHttpController, OneHttpRouterManage, OneHttpCtxtResult, OneTokenManage, OneHttpConst,
  system.Generics.Collections, OneControllerResult, FireDAC.Comp.Client, Data.DB, OneGuID,
  OneMultipart, OneFastBillLockManage;

type
  TFastBillLockController = class(TOneControllerBase)
  public
    function LockBill(QBillLockDo: TBillLockDo): TActionResult<string>;
    function UnLockBill(QBillLockDo: TBillLockDo): TActionResult<string>;
    function UnLockBillForce(QBillLockDo: TBillLockDo): TActionResult<string>;
  end;

implementation

uses OneGlobal;

function CreateNewFastBillLockController(QRouterItem: TOneRouterWorkItem): Tobject;
var
  lController: TFastBillLockController;
begin
  // 自定义创建控制器类，否则会按 TPersistentclass.create
  // 最好自定义一个好
  lController := TFastBillLockController.Create;
  // 挂载RTTI信息
  lController.RouterItem := QRouterItem;
  result := lController;
end;

function TFastBillLockController.LockBill(QBillLockDo: TBillLockDo): TActionResult<string>;
var
  lErrMsg: string;
  lLockResult: boolean;
begin
  result := TActionResult<string>.Create(false, false);
  result.ResultData := '';
  if QBillLockDo.BillID = '' then
  begin
    result.ResultMsg := '订单ID为空';
    exit;
  end;
  if QBillLockDo.UserID = '' then
  begin
    result.ResultMsg := '用户ID为空';
    exit;
  end;
  lLockResult := UnitFastBillLockManage().LockBill(QBillLockDo.BillID, QBillLockDo.UserID, QBillLockDo.LockSec, lErrMsg);
  if not lLockResult then
  begin
    result.ResultMsg := lErrMsg;
    exit;
  end;
  // 锁单成功返回true标识
  result.SetResultTrue();
end;

function TFastBillLockController.UnLockBill(QBillLockDo: TBillLockDo): TActionResult<string>;
var
  lErrMsg: string;
  lLockResult: boolean;
begin
  result := TActionResult<string>.Create(false, false);
  result.ResultData := '';
  if QBillLockDo.BillID = '' then
  begin
    result.ResultMsg := '订单ID为空';
    exit;
  end;
  if QBillLockDo.UserID = '' then
  begin
    result.ResultMsg := '用户ID为空';
    exit;
  end;
  lLockResult := UnitFastBillLockManage().UnLockBill(QBillLockDo.BillID, QBillLockDo.UserID, lErrMsg);
  if not lLockResult then
  begin
    result.ResultMsg := lErrMsg;
    exit;
  end;
  // 锁单成功返回true标识
  result.SetResultTrue();
end;

function TFastBillLockController.UnLockBillForce(QBillLockDo: TBillLockDo): TActionResult<string>;
var
  lErrMsg: string;
begin
  result := TActionResult<string>.Create(false, false);
  UnitFastBillLockManage().UnLockBillForce(QBillLockDo.BillID);
  result.SetResultTrue();
end;

initialization

// 单例模式注册
OneHttpRouterManage.GetInitRouterManage().AddHTTPSingleWork('OneServer/FastBillLock', TFastBillLockController, 0, CreateNewFastBillLockController);

finalization

end.

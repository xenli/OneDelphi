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
  // �Զ��崴���������࣬����ᰴ TPersistentclass.create
  // ����Զ���һ����
  lController := TFastBillLockController.Create;
  // ����RTTI��Ϣ
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
    result.ResultMsg := '����IDΪ��';
    exit;
  end;
  if QBillLockDo.UserID = '' then
  begin
    result.ResultMsg := '�û�IDΪ��';
    exit;
  end;
  lLockResult := UnitFastBillLockManage().LockBill(QBillLockDo.BillID, QBillLockDo.UserID, QBillLockDo.LockSec, lErrMsg);
  if not lLockResult then
  begin
    result.ResultMsg := lErrMsg;
    exit;
  end;
  // �����ɹ�����true��ʶ
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
    result.ResultMsg := '����IDΪ��';
    exit;
  end;
  if QBillLockDo.UserID = '' then
  begin
    result.ResultMsg := '�û�IDΪ��';
    exit;
  end;
  lLockResult := UnitFastBillLockManage().UnLockBill(QBillLockDo.BillID, QBillLockDo.UserID, lErrMsg);
  if not lLockResult then
  begin
    result.ResultMsg := lErrMsg;
    exit;
  end;
  // �����ɹ�����true��ʶ
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

// ����ģʽע��
OneHttpRouterManage.GetInitRouterManage().AddHTTPSingleWork('OneServer/FastBillLock', TFastBillLockController, 0, CreateNewFastBillLockController);

finalization

end.

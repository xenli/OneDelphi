unit UniClass;

interface

uses OneHttpConst, system.Generics.Collections, system.SysUtils, system.Classes;

type

  // 商品资料
  TGoodsDemo = class(TOneOrmRowState)
  private
    FGoodsID_: string;
    FGoodsCode_: string;
    FGoodsName_: string;
    FGoodsPrice_: double;
    FGoodsRemark_: string;
    FGoodsImgUrl_: string;
  published
    // 前后端参数及返回结果大写小请保证一至 ,不要问我为什么JSON是区分大小写的,
    // 如果懒得数据库字段转化,请保持数据库字段也是一至的
    property FGoodsID: string read FGoodsID_ write FGoodsID_;
    property FGoodsCode: string read FGoodsCode_ write FGoodsCode_;
    property FGoodsName: string read FGoodsName_ write FGoodsName_;
    property FGoodsPrice: double read FGoodsPrice_ write FGoodsPrice_;
    property FGoodsRemark: string read FGoodsRemark_ write FGoodsRemark_;
    property FGoodsImgUrl: string read FGoodsImgUrl_ write FGoodsImgUrl_;
  end;

  // 发货单
  TBillSendDemo = class(TOneOrmRowState)
  private
    FBillID_: string;
    FBillNo_: string;
    FBillType_: string;
    FBillDate_: string;
    FBillSenderID_: string;
    FBillSenderCode_: string;
    FBillSenderName_: string;
    FBillSenderLXR_: string;
    FBillSenderTel_: string;
    FBillSenderAddress_: string;
    FBillReceivID_: string;
    FBillReceivCode_: string;
    FBillReceivName_: string;
    FBillReceivLXR_: string;
    FBillReceivTel_: string;
    FBillReceivAddress_: string;
    FBillAmount_: double;
    FBillRemark_: string;
    FIsCFM_: boolean;
    FCFMName_: string;
    FCFMTime_: string;
    FCreateID_: string;
    FCreateName_: string;
    FCreateTime_: string;
  published
    property FBillID: string read FBillID_ write FBillID_;
    property FBillNo: string read FBillNo_ write FBillNo_;
    property FBillType: string read FBillType_ write FBillType_;
    property FBillDate: string read FBillDate_ write FBillDate_;
    property FBillSenderID: string read FBillSenderID_ write FBillSenderID_;
    property FBillSenderCode: string read FBillSenderCode_ write FBillSenderCode_;
    property FBillSenderName: string read FBillSenderName_ write FBillSenderName_;
    property FBillSenderLXR: string read FBillSenderLXR_ write FBillSenderLXR_;
    property FBillSenderTel: string read FBillSenderTel_ write FBillSenderTel_;
    property FBillSenderAddress: string read FBillSenderAddress_ write FBillSenderAddress_;
    property FBillReceivID: string read FBillReceivID_ write FBillReceivID_;
    property FBillReceivCode: string read FBillReceivCode_ write FBillReceivCode_;
    property FBillReceivName: string read FBillReceivName_ write FBillReceivName_;
    property FBillReceivLXR: string read FBillReceivLXR_ write FBillReceivLXR_;
    property FBillReceivTel: string read FBillReceivTel_ write FBillReceivTel_;
    property FBillReceivAddress: string read FBillReceivAddress_ write FBillReceivAddress_;
    property FBillAmount: double read FBillAmount_ write FBillAmount_;
    property FBillRemark: string read FBillRemark_ write FBillRemark_;
    property FIsCFM: boolean read FIsCFM_ write FIsCFM_;
    property FCFMName: string read FCFMName_ write FCFMName_;
    property FCFMTime: string read FCFMTime_ write FCFMTime_;
    property FCreateID: string read FCreateID_ write FCreateID_;
    property FCreateName: string read FCreateName_ write FCreateName_;
    property FCreateTime: string read FCreateTime_ write FCreateTime_;
  end;

  // 商品明细
  TBillDetailDemo = class(TOneOrmRowState)
  private
    FDetailID_: string;
    FBillID_: string;
    FOrderNumber_: integer;
    FGoodsID_: string;
    FGoodsCode_: string;
    FGoodsName_: string;
    FGoodsQuantity_: double;
    FGoodsPrice_: double;
    FGoodsAmount_: double;
    FDetailRemark_: string;
  published
    property FDetailID: string read FDetailID_ write FDetailID_;
    property FBillID: string read FBillID_ write FBillID_;
    property FOrderNumber: integer read FOrderNumber_ write FOrderNumber_;
    property FGoodsID: string read FGoodsID_ write FGoodsID_;
    property FGoodsCode: string read FGoodsCode_ write FGoodsCode_;
    property FGoodsName: string read FGoodsName_ write FGoodsName_;
    property FGoodsQuantity: double read FGoodsQuantity_ write FGoodsQuantity_;
    property FGoodsPrice: double read FGoodsPrice_ write FGoodsPrice_;
    property FGoodsAmount: double read FGoodsAmount_ write FGoodsAmount_;
    property FDetailRemark: string read FDetailRemark_ write FDetailRemark_;
  end;

  // 发货单信息
  TBillSendInfo = class(Tobject)
  private
    FBillSend_: TBillSendDemo;
    FBillDetails_: TList<TBillDetailDemo>;
    FDels_: TList<string>;
  public
    constructor Create;
    destructor Destroy; virtual;
  published
    property BillSend: TBillSendDemo read FBillSend_ write FBillSend_;
    property BillDetails: TList<TBillDetailDemo> read FBillDetails_ write FBillDetails_;
    property Dels: TList<string> read FDels_ write FDels_;
  end;

  // 发送人和接收人客户信息
  TSendReceivDemo = class(TOneOrmRowState)
  private
    FCustomerID_: string;
    FCustomerCode_: string;
    FCustomerName_: string;
    FCustomerType_: string;
    FCustomerLXR_: string;
    FCustomerTel_: string;
    FCustomerRemark_: string;
    FCreateID_: string;
    FCreateName_: string;
    FCreateTime_: string;
  published
    property FCustomerID: string read FCustomerID_ write FCustomerID_;
    property FCustomerCode: string read FCustomerCode_ write FCustomerCode_;
    property FCustomerName: string read FCustomerName_ write FCustomerName_;
    property FCustomerType: string read FCustomerType_ write FCustomerType_;
    property FCustomerLXR: string read FCustomerLXR_ write FCustomerLXR_;
    property FCustomerTel: string read FCustomerTel_ write FCustomerTel_;
    property FCustomerRemark: string read FCustomerRemark_ write FCustomerRemark_;
    property FCreateID: string read FCreateID_ write FCreateID_;
    property FCreateName: string read FCreateName_ write FCreateName_;
    property FCreateTime: string read FCreateTime_ write FCreateTime_;
  end;

  // 订单锁
  TBillManger = class
  private
    FLockLsh: Tobject;
    FLockID: Tobject;
    FLshNo: integer;
    FLockIDList: TDictionary<string, boolean>;
  public
    constructor Create;
    destructor Destroy; virtual;
  public
    function GetLsh(): string;
    function LockBillSend(QBillID: string): boolean;
    procedure UnLockBillSend(QBillID: string);
  end;

function GetUnitBillManger(): TBillManger;

var
  Unit_BillManger: TBillManger = nil;

implementation

constructor TBillSendInfo.Create;
begin
  inherited Create;
  FBillSend_ := TBillSendDemo.Create;
  FBillDetails_ := TList<TBillDetailDemo>.Create;
  FDels_ := TList<string>.Create;
end;

destructor TBillSendInfo.Destroy;
var
  i: integer;
begin
  if FBillSend_ <> nil then
    FBillSend_.free;
  if FBillDetails_ <> nil then
  begin
    for i := 0 to FBillDetails_.Count - 1 do
    begin
      FBillDetails_[i].free;
    end;
    FBillDetails_.Clear;
    FBillDetails_.free;
  end;
  if FDels_ <> nil then
  begin
    FDels_.Clear;
    FDels_.free;
  end;
  inherited Destroy;
end;

function GetUnitBillManger(): TBillManger;
begin
  if Unit_BillManger = nil then
  begin
    Unit_BillManger := TBillManger.Create;
  end;
  Result := Unit_BillManger;
end;

//
constructor TBillManger.Create;
begin
  FLockLsh := Tobject.Create;
  FLockID := Tobject.Create;
  FLockIDList := TDictionary<string, boolean>.Create;
  FLshNo := 0;
end;

destructor TBillManger.Destroy;
begin
  FLockLsh.free;
  FLockID.free;
  FLockIDList.Clear;
  FLockIDList.free;
  inherited Destroy;
end;

function TBillManger.GetLsh(): string;
var
  lDateTime: TDateTime;
  lLshStr: string;
begin
  Result := '';
  TMonitor.Enter(FLockLsh);
  try
    FLshNo := FLshNo + 1;
    lLshStr := FLshNo.ToString;
    while lLshStr.Length < 4 do
    begin
      lLshStr := '0' + lLshStr;
    end;
    lLshStr := 'BILL' + FormatDateTime('yyyyMMddhhmmss', now) + lLshStr;
    Result := lLshStr;
  finally
    TMonitor.Exit(FLockLsh);
  end;
end;

function TBillManger.LockBillSend(QBillID: string): boolean;
begin
  Result := false;
  TMonitor.Enter(FLockID);
  try
    if FLockIDList.ContainsKey(QBillID) then
    begin
      Result := false;
      Exit;
    end;
    FLockIDList.Add(QBillID, true);
    Result := true;
  finally
    TMonitor.Exit(FLockID);
  end;
end;

procedure TBillManger.UnLockBillSend(QBillID: string);
begin
  TMonitor.Enter(FLockID);
  try
    FLockIDList.Remove(QBillID);
  finally
    TMonitor.Exit(FLockID);
  end;
end;

end.

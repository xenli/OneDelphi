unit UniBillSendController;

interface

uses
  system.StrUtils, system.SysUtils, Math, system.JSON, system.Threading, system.Classes,
  OneHttpController, OneHttpRouterManage, OneHttpCtxtResult, OneTokenManage, OneHttpConst,
  system.Generics.Collections, OneControllerResult, FireDAC.Comp.Client, Data.DB, OneGuID,
  OneMultipart, UniClass;

type

  TUniBillSendController = class(TOneControllerBase)
  public
    function GetBillSendList(QPageIndex: integer; QPageSize: integer; QStarTime: string; QEndTime: string; QCMFStatus: string): TActionResult<TList<TBillSendDemo>>;
    function GetBillSendInfo(QBillID: string): TActionResult<TBillSendInfo>;
    function SaveBillSendInfo(QBillInfo: TBillSendInfo): TActionResult<string>;
    function BillSendCmd(QBillID: string; QCmd: string): TActionResult<string>;
  end;

function CreateNewBillSendController(QRouterItem: TOneRouterWorkItem): TObject;

implementation

uses OneGlobal, OneZTManage;

function CreateNewBillSendController(QRouterItem: TOneRouterWorkItem): TObject;
var
  lController: TUniBillSendController;
begin
  // 自定义创建控制器类，否则会按 TPersistentclass.create
  // 最好自定义一个好
  lController := TUniBillSendController.Create;
  // 挂载RTTI信息
  lController.RouterItem := QRouterItem;
  result := lController;
end;

function TUniBillSendController.GetBillSendList(QPageIndex: integer; QPageSize: integer; QStarTime: string; QEndTime: string; QCMFStatus: string): TActionResult<TList<TBillSendDemo>>;
var
  lStartTime, lEndTime: TDateTime;
  LTokenItem: TOneTokenItem;
  lErrMsg: string;
  lOneZTMange: TOneZTManage;
  lOneTokenManage: TOneTokenManage;
  lZTItem: TOneZTItem;
  lFDQuery: TFDQuery;
  lSQL: string;
  lBillSend: TBillSendDemo;
begin
  result := TActionResult < TList < TBillSendDemo >>.Create(true, true);
  LTokenItem := self.GetCureentToken(lErrMsg);
  if LTokenItem = nil then
  begin
    result.SetTokenFail();
    exit;
  end;
  if QStarTime <> '' then
    tryStrToDateTime(QStarTime, lStartTime);
  if QEndTime <> '' then
    tryStrToDateTime(QEndTime, lEndTime);
  // 验证账号密码,比如数据库
  lOneZTMange := TOneGlobal.GetInstance().ZTManage;
  // 账套为空时,默认取主账套,多账套的话可以固定一个账套代码
  lZTItem := lOneZTMange.LockZTItem(LTokenItem.ZTCode, lErrMsg);
  if lZTItem = nil then
  begin
    result.resultMsg := lErrMsg;
    exit;
  end;
  try
    // 从账套获取现成的FDQuery,已绑定好 connetion,也无需释放
    lFDQuery := lZTItem.ADQuery;
    lSQL := 'select * from demo_billSend where 1=1 ';
    if lStartTime > 0 then
    begin
      lSQL := lSQL + ' and FBillDate>=:FBillDateA '
    end;
    if lEndTime > 0 then
    begin
      lSQL := lSQL + ' and FBillDate<=:FBillDateB '
    end;
    if (QCMFStatus = '已审核') or (QCMFStatus = '未审核') then
    begin
      lSQL := lSQL + ' and FIsCFM=:FIsCFM '
    end;

    lFDQuery.SQL.Text := lSQL;
    if lStartTime > 0 then
    begin
      lFDQuery.ParamByName('FBillDateA').AsDateTime := lStartTime;
    end;
    if lEndTime > 0 then
    begin
      lFDQuery.ParamByName('FBillDateB').AsDateTime := lEndTime;
    end;
    if (QCMFStatus = '已审核') then
    begin
      lFDQuery.ParamByName('FIsCFM').AsBoolean := true;
    end;
    if (QCMFStatus = '未审核') then
    begin
      lFDQuery.ParamByName('FIsCFM').AsBoolean := false;
    end;
    // 分页设置
    if (QPageSize > 0) and (QPageIndex > 0) then
    begin
      lFDQuery.FetchOptions.RecsSkip := (QPageIndex - 1) * QPageSize;
      lFDQuery.FetchOptions.RecsMax := QPageSize;
    end
    else
    begin
      lFDQuery.FetchOptions.RecsSkip := -1;
      if QPageSize > 0 then
        lFDQuery.FetchOptions.RecsMax := QPageSize
      else
        lFDQuery.FetchOptions.RecsMax := 50;
    end;
    lFDQuery.Open;
    //
    result.ResultData := TList<TBillSendDemo>.Create;
    lFDQuery.First;
    while not lFDQuery.Eof do
    begin
      lBillSend := TBillSendDemo.Create;
      result.ResultData.Add(lBillSend);
      lBillSend.FBillID := lFDQuery.FieldByName('FBillID').AsString;
      lBillSend.FBillNo := lFDQuery.FieldByName('FBillNo').AsString;
      lBillSend.FBillType := lFDQuery.FieldByName('FBillType').AsString;
      lBillSend.FBillDate := FormatDateTime('yyyy-MM-dd hh:mm:ss', lFDQuery.FieldByName('FBillDate').AsDateTime);
      lBillSend.FBillSenderID := lFDQuery.FieldByName('FBillSenderID').AsString;
      lBillSend.FBillSenderCode := lFDQuery.FieldByName('FBillSenderCode').AsString;
      lBillSend.FBillSenderName := lFDQuery.FieldByName('FBillSenderName').AsString;
      lBillSend.FBillSenderLXR := lFDQuery.FieldByName('FBillSenderLXR').AsString;
      lBillSend.FBillSenderTel := lFDQuery.FieldByName('FBillSenderTel').AsString;
      lBillSend.FBillSenderAddress := lFDQuery.FieldByName('FBillSenderAddress').AsString;
      lBillSend.FBillReceivID := lFDQuery.FieldByName('FBillReceivID').AsString;
      lBillSend.FBillReceivCode := lFDQuery.FieldByName('FBillReceivCode').AsString;
      lBillSend.FBillReceivName := lFDQuery.FieldByName('FBillReceivName').AsString;
      lBillSend.FBillReceivLXR := lFDQuery.FieldByName('FBillReceivLXR').AsString;
      lBillSend.FBillReceivTel := lFDQuery.FieldByName('FBillReceivTel').AsString;
      lBillSend.FBillReceivAddress := lFDQuery.FieldByName('FBillReceivAddress').AsString;
      lBillSend.FBillAmount := lFDQuery.FieldByName('FBillAmount').AsFloat;
      lBillSend.FBillRemark := lFDQuery.FieldByName('FBillRemark').AsString;
      lFDQuery.Next;
    end;
    result.SetResultTrue;
  finally
    // 解锁,归还池很重要
    lZTItem.UnLockWork;
  end;
end;

function TUniBillSendController.GetBillSendInfo(QBillID: string): TActionResult<TBillSendInfo>;
var
  lStartTime, lEndTime: TDateTime;
  LTokenItem: TOneTokenItem;
  lErrMsg: string;
  lOneZTMange: TOneZTManage;
  lOneTokenManage: TOneTokenManage;
  lZTItem: TOneZTItem;
  lFDQuery: TFDQuery;
  lSQL: string;
  lBillSend: TBillSendDemo;
  lBillDetail: TBillDetailDemo;
begin
  result := TActionResult<TBillSendInfo>.Create(true, true);
  LTokenItem := self.GetCureentToken(lErrMsg);
  if LTokenItem = nil then
  begin
    result.SetTokenFail();
    exit;
  end;
  // 验证账号密码,比如数据库
  lOneZTMange := TOneGlobal.GetInstance().ZTManage;
  // 账套为空时,默认取主账套,多账套的话可以固定一个账套代码
  lZTItem := lOneZTMange.LockZTItem(LTokenItem.ZTCode, lErrMsg);
  if lZTItem = nil then
  begin
    result.resultMsg := lErrMsg;
    exit;
  end;
  try
    result.ResultData := TBillSendInfo.Create;
    lBillSend := result.ResultData.BillSend;
    lFDQuery := lZTItem.ADQuery;
    // 从账套获取现成的FDQuery,已绑定好 connetion,也无需释放
    lFDQuery.SQL.Text := 'select *  from demo_billsend where FBillID=:FBillID';
    lFDQuery.Params[0].AsString := QBillID;
    lFDQuery.Open;
    if lFDQuery.RecordCount = 0 then
    begin
      result.resultMsg := '单据已不存在,请重新刷新列表数据。';
      exit;
    end;
    // 主单赋值
    lBillSend.FBillID := lFDQuery.FieldByName('FBillID').AsString;
    lBillSend.FBillNo := lFDQuery.FieldByName('FBillNo').AsString;
    lBillSend.FBillType := lFDQuery.FieldByName('FBillType').AsString;
    lBillSend.FBillDate := FormatDateTime('yyyy-MM-dd hh:mm:ss', lFDQuery.FieldByName('FBillDate').AsDateTime);
    lBillSend.FBillSenderID := lFDQuery.FieldByName('FBillSenderID').AsString;
    lBillSend.FBillSenderCode := lFDQuery.FieldByName('FBillSenderCode').AsString;
    lBillSend.FBillSenderName := lFDQuery.FieldByName('FBillSenderName').AsString;
    lBillSend.FBillSenderLXR := lFDQuery.FieldByName('FBillSenderLXR').AsString;
    lBillSend.FBillSenderTel := lFDQuery.FieldByName('FBillSenderTel').AsString;
    lBillSend.FBillSenderAddress := lFDQuery.FieldByName('FBillSenderAddress').AsString;
    lBillSend.FBillReceivID := lFDQuery.FieldByName('FBillReceivID').AsString;
    lBillSend.FBillReceivCode := lFDQuery.FieldByName('FBillReceivCode').AsString;
    lBillSend.FBillReceivName := lFDQuery.FieldByName('FBillReceivName').AsString;
    lBillSend.FBillReceivLXR := lFDQuery.FieldByName('FBillReceivLXR').AsString;
    lBillSend.FBillReceivTel := lFDQuery.FieldByName('FBillReceivTel').AsString;
    lBillSend.FBillReceivAddress := lFDQuery.FieldByName('FBillReceivAddress').AsString;
    lBillSend.FBillAmount := lFDQuery.FieldByName('FBillAmount').AsFloat;
    lBillSend.FBillRemark := lFDQuery.FieldByName('FBillRemark').AsString;
    lBillSend.FIsCFM := lFDQuery.FieldByName('FIsCFM').AsBoolean;
    lBillSend.FCFMName := lFDQuery.FieldByName('FCFMName').AsString;
    lBillSend.FCFMTime := FormatDateTime('yyyy-MM-dd hh:mm:ss', lFDQuery.FieldByName('FCFMTime').AsDateTime);
    lBillSend.FCreateID := lFDQuery.FieldByName('FCreateID').AsString;
    lBillSend.FCreateName := lFDQuery.FieldByName('FCreateName').AsString;
    lBillSend.FCreateTime := lFDQuery.FieldByName('FCreateTime').AsString;
    // 明细赋值
    lFDQuery := lZTItem.ADQuery;
    lFDQuery.SQL.Text := 'select * from demo_billdetail where FBillID=:FBillID';
    lFDQuery.Params[0].AsString := QBillID;
    lFDQuery.Open;

    lFDQuery.First;
    while not lFDQuery.Eof do
    begin
      lBillDetail := TBillDetailDemo.Create;
      result.ResultData.BillDetails.Add(lBillDetail);
      lBillDetail.FDetailID := lFDQuery.FieldByName('FDetailID').AsString;
      lBillDetail.FBillID := lFDQuery.FieldByName('FBillID').AsString;
      lBillDetail.FOrderNumber := lFDQuery.FieldByName('FOrderNumber').AsInteger;
      lBillDetail.FGoodsID := lFDQuery.FieldByName('FGoodsID').AsString;
      lBillDetail.FGoodsCode := lFDQuery.FieldByName('FGoodsCode').AsString;
      lBillDetail.FGoodsName := lFDQuery.FieldByName('FGoodsName').AsString;
      lBillDetail.FGoodsQuantity := lFDQuery.FieldByName('FGoodsQuantity').AsFloat;
      lBillDetail.FGoodsPrice := lFDQuery.FieldByName('FGoodsPrice').AsFloat;
      lBillDetail.FGoodsAmount := lFDQuery.FieldByName('FGoodsAmount').AsFloat;
      lBillDetail.FDetailRemark := lFDQuery.FieldByName('FDetailRemark').AsString;
      lFDQuery.Next;
    end;
    result.SetResultTrue;
  finally
    // 解锁,归还池很重要
    lZTItem.UnLockWork;
  end;
end;

function TUniBillSendController.SaveBillSendInfo(QBillInfo: TBillSendInfo): TActionResult<string>;
var
  lBillSend: TBillSendDemo;
  lBillDetail: TBillDetailDemo;
  LTokenItem: TOneTokenItem;
  I, iNumber: integer;
  lSumAmount: double;
  lErrMsg: string;
  //
  lOneZTMange: TOneZTManage;
  lOneTokenManage: TOneTokenManage;
  lZTItem: TOneZTItem;
  lBillSendQuery, lBillDetailQuery: TFDQuery;
  tempDetailID: string;
  //
  isCommit: boolean;
  iCommit, iErr: integer;
begin
  // 返回一个订单ID回去,前台重新打开数据就行了
  lBillSendQuery := nil;
  result := TActionResult<string>.Create(false, false);
  LTokenItem := self.GetCureentToken(lErrMsg);
  if LTokenItem = nil then
  begin
    result.SetTokenFail();
    exit;
  end;
  if QBillInfo.BillSend = nil then
  begin
    QBillInfo.BillSend := TBillSendDemo.Create;
  end;
  lBillSend := QBillInfo.BillSend;
  if QBillInfo.BillDetails = nil then
  begin
    QBillInfo.BillDetails := TList<TBillDetailDemo>.Create;
  end;
  if QBillInfo.Dels = nil then
  begin
    QBillInfo.Dels := TList<string>.Create;
  end;
  lBillSend.SetRowState(lBillSend.FBillID);
  // 校验数据,比如发货方，收货方不可为空
  if QBillInfo.BillSend.FBillSenderID = '' then
  begin
    result.resultMsg := '发货方不可为空';
    exit;
  end;
  if QBillInfo.BillSend.FBillReceivID = '' then
  begin
    result.resultMsg := '收货方不可为空';
    exit;
  end;
  // 校验明细数据
  iNumber := 1;
  for I := 0 to QBillInfo.BillDetails.count - 1 do
  begin
    lBillDetail := QBillInfo.BillDetails[I];
    if lBillDetail.FGoodsID = '' then
    begin
      result.resultMsg := '商品名细第[' + lBillDetail.FOrderNumber.ToString + ']条数据,商品ID为空。';
      exit;
    end;
    if lBillDetail.FGoodsPrice < 0 then
      lBillDetail.FGoodsPrice := 0;
    if lBillDetail.FGoodsQuantity < 0 then
      lBillDetail.FGoodsQuantity := 0;
    // 重新计算明细金额,最好保留两位小数的做法,后面在加
    lBillDetail.FGoodsAmount := lBillDetail.FGoodsPrice * lBillDetail.FGoodsQuantity;
    lBillDetail.FOrderNumber := iNumber;
    iNumber := iNumber + 1;
  end;
  // 如果是新建
  if lBillSend.GetRowState() = emRowState.insertState then
  begin
    lBillSend.FBillID := OneGuID.GetGUID32;
    // 获取订单号,先用简单的办法
    lBillSend.FBillNo := UniClass.GetUnitBillManger().GetLsh();
    lBillSend.FBillType := '要货单';
    // 创建人信息
    lBillSend.FCreateTime := FormatDateTime('yyyy-MM-dd hh:mm:ss', now);
    lBillSend.FCreateID := LTokenItem.SysUserID;
    lBillSend.FCreateName := LTokenItem.SysUserName;
  end
  else
  begin
    // 编辑模式
  end;
  if lBillSend.FBillDate = '' then
  begin
    lBillSend.FBillDate := FormatDateTime('yyyy-MM-dd hh:mm:ss', now);
  end;

  // 单据锁,防止多个同时操作同一个订单
  if not UniClass.GetUnitBillManger().LockBillSend(lBillSend.FBillID) then
  begin
    result.resultMsg := '单据正在使用中,请稍候在试';
    exit;
  end;
  try
    lOneZTMange := TOneGlobal.GetInstance().ZTManage;
    // 账套为空时,默认取主账套,多账套的话可以固定一个账套代码
    lZTItem := lOneZTMange.LockZTItem(LTokenItem.ZTCode, lErrMsg);
    if lZTItem = nil then
    begin
      result.resultMsg := lErrMsg;
      exit;
    end;
    try
      // 创建一个新的Query绑定好账套,这个需要自已释放Query
      lBillSendQuery := lZTItem.CreateNewQuery();
      lBillDetailQuery := lZTItem.CreateNewQuery();
      //
      lBillSendQuery.SQL.Text := 'select *  from demo_billsend where FBillID=:FBillID';
      lBillSendQuery.Params[0].AsString := lBillSend.FBillID;
      lBillSendQuery.UpdateOptions.UpdateTableName := 'demo_billsend';
      lBillSendQuery.UpdateOptions.KeyFields := 'FBillID';
      lBillSendQuery.Open();

      lBillDetailQuery.SQL.Text := 'select *  from demo_billdetail where FBillID=:FBillID order by  FOrderNumber asc ';
      lBillDetailQuery.Params[0].AsString := lBillSend.FBillID;
      lBillDetailQuery.UpdateOptions.UpdateTableName := 'demo_billdetail';
      lBillDetailQuery.UpdateOptions.KeyFields := 'FDetailID';
      lBillDetailQuery.Open();

      if lBillSend.GetRowState() = emRowState.insertState then
      begin
        lBillSendQuery.Append;
        lBillSendQuery.FieldByName('FBillID').AsString := lBillSend.FBillID;
        lBillSendQuery.FieldByName('FBillNo').AsString := lBillSend.FBillNo;
        lBillSendQuery.FieldByName('FBillType').AsString := lBillSend.FBillType;
        lBillSendQuery.FieldByName('FBillDate').AsString := lBillSend.FBillDate;
        lBillSendQuery.FieldByName('FBillSenderID').AsString := lBillSend.FBillSenderID;
        lBillSendQuery.FieldByName('FBillSenderCode').AsString := lBillSend.FBillSenderCode;
        lBillSendQuery.FieldByName('FBillSenderName').AsString := lBillSend.FBillSenderName;
        lBillSendQuery.FieldByName('FBillSenderLXR').AsString := lBillSend.FBillSenderLXR;
        lBillSendQuery.FieldByName('FBillSenderTel').AsString := lBillSend.FBillSenderTel;
        lBillSendQuery.FieldByName('FBillSenderAddress').AsString := lBillSend.FBillSenderAddress;
        lBillSendQuery.FieldByName('FBillReceivID').AsString := lBillSend.FBillReceivID;
        lBillSendQuery.FieldByName('FBillReceivCode').AsString := lBillSend.FBillReceivCode;
        lBillSendQuery.FieldByName('FBillReceivName').AsString := lBillSend.FBillReceivName;
        lBillSendQuery.FieldByName('FBillReceivLXR').AsString := lBillSend.FBillReceivLXR;
        lBillSendQuery.FieldByName('FBillReceivTel').AsString := lBillSend.FBillReceivTel;
        lBillSendQuery.FieldByName('FBillReceivAddress').AsString := lBillSend.FBillReceivAddress;
        lBillSendQuery.FieldByName('FBillAmount').AsFloat := lBillSend.FBillAmount;
        lBillSendQuery.FieldByName('FBillRemark').AsString := lBillSend.FBillRemark;
        lBillSendQuery.FieldByName('FIsCFM').AsBoolean := false;
        lBillSendQuery.FieldByName('FCFMName').AsString := '';
        lBillSendQuery.FieldByName('FCFMTime').clear;
        lBillSendQuery.FieldByName('FCreateID').AsString := lBillSend.FCreateID;
        lBillSendQuery.FieldByName('FCreateName').AsString := lBillSend.FCreateName;
        lBillSendQuery.FieldByName('FCreateTime').AsString := lBillSend.FCreateTime;
        lBillSendQuery.Post;
      end
      else if lBillSend.GetRowState() = emRowState.editState then
      begin
        if lBillSendQuery.RecordCount = 0 then
        begin
          result.resultMsg := '单据已不存在。请重新刷新单据列表数据。';
          exit;
        end;
        if lBillSendQuery.FieldByName('FIsCFM').AsBoolean then
        begin
          result.resultMsg := '单据已审核不可变更数据。';
          exit;
        end;
        lBillSendQuery.edit;
        // lBillSendQuery.FieldByName('FBillID').AsString := lBillSend.FBillID;
        // lBillSendQuery.FieldByName('FBillNo').AsString := lBillSend.FBillNo;
        // lBillSendQuery.FieldByName('FBillType').AsString := lBillSend.FBillType;
        lBillSendQuery.FieldByName('FBillDate').AsString := lBillSend.FBillDate;
        lBillSendQuery.FieldByName('FBillSenderID').AsString := lBillSend.FBillSenderID;
        lBillSendQuery.FieldByName('FBillSenderCode').AsString := lBillSend.FBillSenderCode;
        lBillSendQuery.FieldByName('FBillSenderName').AsString := lBillSend.FBillSenderName;
        lBillSendQuery.FieldByName('FBillSenderLXR').AsString := lBillSend.FBillSenderLXR;
        lBillSendQuery.FieldByName('FBillSenderTel').AsString := lBillSend.FBillSenderTel;
        lBillSendQuery.FieldByName('FBillSenderAddress').AsString := lBillSend.FBillSenderAddress;
        lBillSendQuery.FieldByName('FBillReceivID').AsString := lBillSend.FBillReceivID;
        lBillSendQuery.FieldByName('FBillReceivCode').AsString := lBillSend.FBillReceivCode;
        lBillSendQuery.FieldByName('FBillReceivName').AsString := lBillSend.FBillReceivName;
        lBillSendQuery.FieldByName('FBillReceivLXR').AsString := lBillSend.FBillReceivLXR;
        lBillSendQuery.FieldByName('FBillReceivTel').AsString := lBillSend.FBillReceivTel;
        lBillSendQuery.FieldByName('FBillReceivAddress').AsString := lBillSend.FBillReceivAddress;
        lBillSendQuery.FieldByName('FBillAmount').AsFloat := lBillSend.FBillAmount;
        lBillSendQuery.FieldByName('FBillRemark').AsString := lBillSend.FBillRemark;
        lBillSendQuery.FieldByName('FIsCFM').AsBoolean := false;
        lBillSendQuery.FieldByName('FCFMName').AsString := '';
        lBillSendQuery.FieldByName('FCFMTime').clear;
        // lBillSendQuery.FieldByName('FCreateID').AsString := lBillSend.FCreateID;
        // lBillSendQuery.FieldByName('FCreateName').AsString := lBillSend.FCreateName;
        // lBillSendQuery.FieldByName('FCreateTime').AsString := lBillSend.FCreateTime;
        // 字段标识更新处理
        lBillSendQuery.FieldByName('FBillID').ProviderFlags := [pfInWhere, pfInKey]; // 参与Where主键更新
        lBillSendQuery.FieldByName('FBillNo').ProviderFlags := [pfInWhere, pfInKey]; // 参与Where主键更新
        lBillSendQuery.FieldByName('FIsCFM').ProviderFlags := [pfInWhere, pfInKey]; // 参与Where主键更新,保证未审核的数据才可更新
        lBillSendQuery.FieldByName('FBillType').ProviderFlags := []; // 不参与任何更新,新建时固定死的
        lBillSendQuery.FieldByName('FCreateID').ProviderFlags := []; // 不参与任何更新 ,新建时固定死的
        lBillSendQuery.FieldByName('FCreateName').ProviderFlags := []; // 不参与任何更新,新建时固定死的
        lBillSendQuery.FieldByName('FCreateTime').ProviderFlags := []; // 不参与任何更新 ,新建时固定死的
        lBillSendQuery.Post;
      end;

      // 明细数据处理
      // 首先删除删除的数据
      for I := 0 to QBillInfo.Dels.count - 1 do
      begin
        tempDetailID := QBillInfo.Dels[I];
        if lBillDetailQuery.locate('FDetailID', tempDetailID) then
        begin
          // 删除的去掉
          lBillDetailQuery.delete;
        end;
      end;

      // 新增修改数据
      for I := 0 to QBillInfo.BillDetails.count - 1 do
      begin
        lBillDetail := QBillInfo.BillDetails[I];
        // DetailID有值说明是编辑,没值是新增
        lBillDetail.SetRowState(lBillDetail.FDetailID);
        if lBillDetail.GetRowState() = emRowState.insertState then
        begin
          lBillDetail.FDetailID := OneGuID.GetGUID32;
          //
          lBillDetailQuery.Append;
          lBillDetailQuery.FieldByName('FDetailID').AsString := lBillDetail.FDetailID;
          lBillDetailQuery.FieldByName('FBillID').AsString := lBillSend.FBillID;
          lBillDetailQuery.FieldByName('FOrderNumber').AsInteger := lBillDetail.FOrderNumber;
          lBillDetailQuery.FieldByName('FGoodsID').AsString := lBillDetail.FGoodsID;
          lBillDetailQuery.FieldByName('FGoodsCode').AsString := lBillDetail.FGoodsCode;
          lBillDetailQuery.FieldByName('FGoodsName').AsString := lBillDetail.FGoodsName;
          lBillDetailQuery.FieldByName('FGoodsQuantity').AsFloat := lBillDetail.FGoodsQuantity;
          lBillDetailQuery.FieldByName('FGoodsPrice').AsFloat := lBillDetail.FGoodsPrice;
          lBillDetailQuery.FieldByName('FGoodsAmount').AsFloat := lBillDetail.FGoodsAmount;
          lBillDetailQuery.FieldByName('FDetailRemark').AsString := lBillDetail.FDetailRemark;
          lBillDetailQuery.Post;
        end
        else if lBillDetail.GetRowState() = emRowState.editState then
        begin
          if lBillDetailQuery.locate('FDetailID', lBillDetail.FDetailID) then
          begin
            // 如果不存在说明这条明细已删除了,跳过
            lBillDetailQuery.edit;
            // lBillDetailQuery.FieldByName('FDetailID').AsString := lBillDetail.FDetailID;
            lBillDetailQuery.FieldByName('FBillID').AsString := lBillSend.FBillID;
            lBillDetailQuery.FieldByName('FOrderNumber').AsInteger := lBillDetail.FOrderNumber;
            lBillDetailQuery.FieldByName('FGoodsID').AsString := lBillDetail.FGoodsID;
            lBillDetailQuery.FieldByName('FGoodsCode').AsString := lBillDetail.FGoodsCode;
            lBillDetailQuery.FieldByName('FGoodsName').AsString := lBillDetail.FGoodsName;
            lBillDetailQuery.FieldByName('FGoodsQuantity').AsFloat := lBillDetail.FGoodsQuantity;
            lBillDetailQuery.FieldByName('FGoodsPrice').AsFloat := lBillDetail.FGoodsPrice;
            lBillDetailQuery.FieldByName('FGoodsAmount').AsFloat := lBillDetail.FGoodsAmount;
            lBillDetailQuery.FieldByName('FDetailRemark').AsString := lBillDetail.FDetailRemark;
            lBillDetailQuery.Post;
          end;
        end;
      end;

      // 统计明细总金额
      lSumAmount := 0;
      iNumber := 1;
      lBillDetailQuery.First;
      while not lBillDetailQuery.Eof do
      begin
        lSumAmount := lSumAmount + lBillDetailQuery.FieldByName('FGoodsAmount').AsFloat;
        lBillDetailQuery.edit;
        lBillDetailQuery.FieldByName('FOrderNumber').AsInteger := iNumber;
        lBillDetailQuery.Post;
        iNumber := iNumber + 1;
        lBillDetailQuery.Next;
      end;

      lBillSendQuery.edit;
      lBillSendQuery.FieldByName('FBillAmount').AsFloat := lSumAmount;
      lBillSendQuery.Post;

      // 开启事务统一提交
      iErr := 0;
      isCommit := false;
      lZTItem.ADConnection.StartTransaction;
      try
        iErr := lBillSendQuery.ApplyUpdates(-1);
        if iErr > 0 then
        begin
          result.resultMsg := '更新数据有误,错误行数' + iErr.ToString;
          exit;
        end;
        // iCommit := lBillSendQuery.RowsAffected;
        // if iCommit <> 1 then
        // begin
        // result.resultMsg := '更新数据有误,影响行数不为1,当前影响行数' + iCommit.ToString;
        // exit;
        // end;
        iErr := lBillDetailQuery.ApplyUpdates(-1);
        if iErr > 0 then
        begin
          result.resultMsg := '更新单据商品数据有误,错误行数' + iErr.ToString;
          exit;
        end;
        lZTItem.ADConnection.Commit;
        isCommit := true;
      finally
        if not isCommit then
        begin
          lZTItem.ADConnection.Rollback;
        end;
      end;
      if isCommit then
      begin
        result.ResultData := lBillSend.FBillID;
        result.SetResultTrue;
      end;
    finally
      lZTItem.UnLockWork;
      if lBillSendQuery <> nil then
      begin
        lBillSendQuery.free;
      end;
      if lBillDetailQuery <> nil then
      begin
        lBillDetailQuery.free;
      end;
    end;
  finally
    UniClass.GetUnitBillManger().UnLockBillSend(lBillSend.FBillID);
  end;
end;

function TUniBillSendController.BillSendCmd(QBillID: string; QCmd: string): TActionResult<string>;
var
  LTokenItem: TOneTokenItem;
  //
  lOneZTMange: TOneZTManage;
  lOneTokenManage: TOneTokenManage;
  lZTItem: TOneZTItem;
  lBillSendQuery, lBillDetailQuery: TFDQuery;
  tempDetailID, lErrMsg: string;
  //
  isCommit: boolean;
  iCommit, iErr: integer;
begin
  lBillSendQuery := nil;
  lBillDetailQuery := nil;
  result := TActionResult<string>.Create(false, false);
  if (QCmd <> '审核') and (QCmd <> '去审') and (QCmd <> '删除') then
  begin
    result.resultMsg := '单据操作标识[' + QCmd + ']不合法';
    exit;
  end;
  LTokenItem := self.GetCureentToken(lErrMsg);
  if LTokenItem = nil then
  begin
    result.SetTokenFail();
    exit;
  end;

  // 单据锁,防止多个同时操作同一个订单
  if not UniClass.GetUnitBillManger().LockBillSend(QBillID) then
  begin
    result.resultMsg := '单据正在使用中,请稍候在试';
    exit;
  end;
  try
    //
    lOneZTMange := TOneGlobal.GetInstance().ZTManage;
    // 账套为空时,默认取主账套,多账套的话可以固定一个账套代码
    lZTItem := lOneZTMange.LockZTItem(LTokenItem.ZTCode, lErrMsg);
    if lZTItem = nil then
    begin
      result.resultMsg := lErrMsg;
      exit;
    end;
    try
      lBillSendQuery := lZTItem.CreateNewQuery();
      lBillSendQuery.SQL.Text := 'select FBillID,FIsCFM from demo_billsend where FBillID=:FBillID';
      lBillSendQuery.Params[0].AsString := QBillID;
      lBillSendQuery.Open;
      if lBillSendQuery.RecordCount = 0 then
      begin
        result.resultMsg := '单据已不存在,请检查';
        exit;
      end;
      if lBillSendQuery.FieldByName('FIsCFM').AsBoolean then
      begin
        if QCmd = '删除' then
        begin
          result.resultMsg := '单据已审核,不可删除,请刷新单据';
          exit;
        end;
        if QCmd = '审核' then
        begin
          result.resultMsg := '单据已审核,无需在审核,请刷新单据';
          exit;
        end;
      end
      else
      begin
        if QCmd = '去审' then
        begin
          result.resultMsg := '单据已去审,无需在去审,请刷新单据';
          exit;
        end;
      end;

      lZTItem.ADConnection.StartTransaction;
      try
        isCommit := false;
        iCommit := 0;
        // 关闭数据集，重新获取
        lBillSendQuery.close;
        if QCmd = '删除' then
        begin
          lBillSendQuery.SQL.Text := 'delete from demo_billsend where FBillID=:FBillID and FIsCFM=:FIsCFM';
          lBillSendQuery.Params[0].AsString := QBillID;
          lBillSendQuery.Params[1].AsBoolean := false;
          lBillDetailQuery := lZTItem.CreateNewQuery();
          lBillDetailQuery.SQL.Text := 'delete from demo_billdetail where FBillID=:FBillID';
          lBillDetailQuery.Params[0].AsString := QBillID;
        end
        else if QCmd = '审核' then
        begin
          lBillSendQuery.SQL.Text := 'update demo_billsend set FIsCFM=:FIsCFM,FCFMName=:FCFMName,FCFMTime=:FCFMTime  where FBillID=:FBillID and FIsCFM=:OldFIsCFM';
          // 参数多的情况下,用名称好点
          lBillSendQuery.Params.ParamByName('FIsCFM').AsBoolean := true;
          lBillSendQuery.Params.ParamByName('FCFMName').AsString := LTokenItem.SysUserName;
          lBillSendQuery.Params.ParamByName('FCFMTime').AsDateTime := now;
          lBillSendQuery.Params.ParamByName('FBillID').AsString := QBillID;
          lBillSendQuery.Params.ParamByName('OldFIsCFM').AsBoolean := false;
        end
        else if QCmd = '去审' then
        begin
          lBillSendQuery.SQL.Text := 'update demo_billsend set FIsCFM=:FIsCFM,FCFMName=:FCFMName,FCFMTime=:FCFMTime  where FBillID=:FBillID and FIsCFM=:OldFIsCFM';
          lBillSendQuery.Params.ParamByName('FIsCFM').AsBoolean := false;
          lBillSendQuery.Params.ParamByName('FCFMName').AsString := LTokenItem.SysUserName;
          lBillSendQuery.Params.ParamByName('FCFMTime').AsDateTime := now;
          lBillSendQuery.Params.ParamByName('FBillID').AsString := QBillID;
          lBillSendQuery.Params.ParamByName('OldFIsCFM').AsBoolean := true;
        end;
        lBillSendQuery.execSQL;
        iCommit := lBillSendQuery.RowsAffected;
        if iCommit <> 1 then
        begin
          result.resultMsg := '操作[' + QCmd + '失败,受影响行数[' + iCommit.ToString + '],请刷新数据查看最新状态。';
          exit;
        end;
        if QCmd = '删除' then
        begin
          // 删除明细
          lBillDetailQuery.execSQL;
        end;
        lZTItem.ADConnection.Commit;
        isCommit := true;
        result.SetResultTrue();
      finally
        if not isCommit then
        begin
          lZTItem.ADConnection.Rollback;
        end;
      end;
    finally
      lZTItem.UnLockWork;
      if lBillSendQuery <> nil then
      begin
        lBillSendQuery.free;
      end;
      if lBillDetailQuery <> nil then
      begin
        lBillDetailQuery.free;
      end;
    end;
  finally
    UniClass.GetUnitBillManger().UnLockBillSend(QBillID);
  end;

end;

initialization

// 单例模式注册
OneHttpRouterManage.GetInitRouterManage().AddHTTPSingleWork('/UniDemo/BillSend', TUniBillSendController, 0, CreateNewBillSendController);

finalization

end.

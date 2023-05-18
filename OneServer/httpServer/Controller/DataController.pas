unit DataController;

// 此单元主要对接 oneClient的OneDataSet传统交互
interface

uses OneHttpController, OneHttpRouterManage, OneHttpCtxtResult, OneDataInfo,
  system.Generics.Collections, OneFileHelper, system.StrUtils, system.SysUtils,
  OneControllerResult;

type

  TOneDataController = class(TOneControllerBase)
  public
    { 只有这种类型的参数结果才注册到RTTI,防止所有的全注册 }
    { 打开几个数据 }
    function OpenDatas(QDataOpens: TList<TOneDataOpen>): TOneDataResult;
    // 执行存储过程
    function ExecStored(QDataOpen: TOneDataOpen): TOneDataResult;
    // 保存语句或执行DML语句
    function SaveDatas(QSaveDMLDatas: TList<TOneDataSaveDML>): TOneDataResult;

    { 执行脚本,不返回任何数据集或什么,纯脚本执行 }
    function ExecScript(QDataOpen: TOneDataOpen): TActionResult<string>;
    // 下载文件
    function DownLoadDataFile(fileID: string): TActionResult<string>;
    // 删除文件
    procedure DelDataFile(fileID: string);
    // *********二层事务自由控制***********
    // 1.先获取一个账套连接,标记成事务账套
    function LockTranItem(QTranInfo: TOneTran): TOneDataResult;
    // 2.用完了账套连接,归还账套,如果没归还，很久后，服务端会自动处理归还
    function UnLockTranItem(QTranInfo: TOneTran): TOneDataResult;
    // 3.开启账套连接事务
    function StartTranItem(QTranInfo: TOneTran): TOneDataResult;
    // 4.提交账套连接事务
    function CommitTranItem(QTranInfo: TOneTran): TOneDataResult;
    // 5.回滚账套连接事务
    function RollbackTranItem(QTranInfo: TOneTran): TOneDataResult;

    // 获取数据库表信息相
    function GetDBMetaInfo(QDBMetaInfo: TOneDBMetaInfo): TOneDataResult;
  end;

function CreateNewOneDataController(QRouterItem: TOneRouterWorkItem): TObject;

implementation

uses OneGlobal, OneSQLCrypto;

function CreateNewOneDataController(QRouterItem: TOneRouterWorkItem): TObject;
var
  lController: TOneDataController;
begin
  // 自定义创建控制器类，否则会按 TPersistentclass.create
  // 最好自定义一个好
  lController := TOneDataController.Create;
  // 开启验证Token
  lController.FAutoCheckToken := true;
  // 开启验证签名
  lController.FAutoCheckSign := true;
  // 挂载RTTI信息
  lController.RouterItem := QRouterItem;
  result := lController;
end;

function TOneDataController.OpenDatas(QDataOpens: TList<TOneDataOpen>): TOneDataResult;
var
  lOneGlobal: TOneGlobal;
  i: Integer;
begin
  result := TOneDataResult.Create;
  try
    lOneGlobal := TOneGlobal.GetInstance();
    for i := 0 to QDataOpens.Count - 1 do
    begin
      // 客户端提交的 SQL还原
      QDataOpens[i].OpenSQL := OneSQLCrypto.SwapDecodeCrypto(QDataOpens[i].OpenSQL);
    end;
    // 打开数据
    if not lOneGlobal.ZTManage.OpenDatas(QDataOpens, result) then
    begin
      exit;
    end;
    // 解析相关数据
    if result.ResultOK then
    begin
      result.DoResultitems();
    end;
  except
    on e: Exception do
    begin
      result.ResultMsg := e.Message;
    end;
  end;
end;

function TOneDataController.ExecStored(QDataOpen: TOneDataOpen): TOneDataResult;
var
  lOneGlobal: TOneGlobal;
  i: Integer;
begin
  result := TOneDataResult.Create;
  lOneGlobal := TOneGlobal.GetInstance();
  // 打开数据
  if not lOneGlobal.ZTManage.ExecStored(QDataOpen, result) then
  begin
    exit;
  end;
  // 解析相关数据
  if result.ResultOK then
  begin
    result.DoResultitems();
  end;
end;

function TOneDataController.SaveDatas(QSaveDMLDatas: TList<TOneDataSaveDML>): TOneDataResult;
var
  lOneGlobal: TOneGlobal;
  i: Integer;
begin
  result := TOneDataResult.Create;
  try
    lOneGlobal := TOneGlobal.GetInstance();
    for i := 0 to QSaveDMLDatas.Count - 1 do
    begin
      // 客户端提交的 SQL还原
      QSaveDMLDatas[i].SQL := OneSQLCrypto.SwapDecodeCrypto(QSaveDMLDatas[i].SQL);
    end;
    // 保存数据
    if not lOneGlobal.ZTManage.SaveDatas(QSaveDMLDatas, result) then
    begin
      exit;
    end;
    // 解析相关数据
    if result.ResultOK then
    begin
      result.DoResultitems();
    end;
  except
    on e: Exception do
    begin
      result.ResultMsg := e.Message;
    end;
  end;

end;

// 下载文件
function TOneDataController.DownLoadDataFile(fileID: string): TActionResult<string>;
var
  lFileName: string;
begin
  result := TActionResult<string>.Create(false, false);
  if fileID.Trim = '' then
  begin
    result.ResultMsg := '文件ID为空';
    exit;
  end;
  lFileName := OneFileHelper.CombineExeRunPath('OnePlatform\OneDataTemp\' + fileID + '.zip');
  if not fileExists(lFileName) then
  begin
    result.ResultMsg := '文件已不存在';
    exit;
  end;
  result.ResultData := lFileName;
  // 返回的是文件
  result.SetResultTrueFile();
end;

procedure TOneDataController.DelDataFile(fileID: string);
var
  lFileName: string;
begin
  if fileID.Trim = '' then
  begin
    exit;
  end;
  lFileName := OneFileHelper.CombineExeRunPath('OnePlatform\OneDataTemp\' + fileID + '.data');
  if fileExists(lFileName) then
  begin
    DeleteFile(lFileName);
    exit;
  end;
end;

// 1.先获取一个账套连接,标记成事务账套
function TOneDataController.LockTranItem(QTranInfo: TOneTran): TOneDataResult;
var
  lOneGlobal: TOneGlobal;
  lErrMsg: string;
  lTranID: string;
begin
  result := TOneDataResult.Create;
  lOneGlobal := TOneGlobal.GetInstance();
  lTranID := '';
  if QTranInfo.MaxSpan <= 0 then
    QTranInfo.MaxSpan := -1;
  lTranID := lOneGlobal.ZTManage.LockTranItem(QTranInfo.ZTCode, QTranInfo.MaxSpan, lErrMsg);
  result.ResultMsg := lErrMsg;
  if lTranID <> '' then
  begin
    result.ResultData := lTranID;
    result.ResultOK := true;
  end;
end;

// 2.用完了账套连接,归还账套,如果没归还，很久后，服务端会自动处理归还
function TOneDataController.UnLockTranItem(QTranInfo: TOneTran): TOneDataResult;
var
  lOneGlobal: TOneGlobal;
  lErrMsg: string;
begin
  result := TOneDataResult.Create;
  if QTranInfo.TranID = '' then
  begin
    result.ResultMsg := '事务TrandID不可为空';
    exit;
  end;
  lOneGlobal := TOneGlobal.GetInstance();
  if QTranInfo.MaxSpan <= 0 then
    QTranInfo.MaxSpan := -1;
  if not lOneGlobal.ZTManage.UnLockTranItem(QTranInfo.TranID, lErrMsg) then
  begin
    result.ResultMsg := lErrMsg;
    exit;
  end;
  result.ResultOK := true;
end;

// 3.开启账套连接事务
function TOneDataController.StartTranItem(QTranInfo: TOneTran): TOneDataResult;
var
  lOneGlobal: TOneGlobal;
  lErrMsg: string;
begin
  result := TOneDataResult.Create;
  if QTranInfo.TranID = '' then
  begin
    result.ResultMsg := '事务TrandID不可为空';
    exit;
  end;
  lOneGlobal := TOneGlobal.GetInstance();
  if QTranInfo.MaxSpan <= 0 then
    QTranInfo.MaxSpan := -1;
  if not lOneGlobal.ZTManage.StartTranItem(QTranInfo.TranID, lErrMsg) then
  begin
    result.ResultMsg := lErrMsg;
    exit;
  end;
  result.ResultOK := true;
end;

// 4.提交账套连接事务
function TOneDataController.CommitTranItem(QTranInfo: TOneTran): TOneDataResult;
var
  lOneGlobal: TOneGlobal;
  lErrMsg: string;
begin
  result := TOneDataResult.Create;
  if QTranInfo.TranID = '' then
  begin
    result.ResultMsg := '事务TrandID不可为空';
    exit;
  end;
  lOneGlobal := TOneGlobal.GetInstance();
  if QTranInfo.MaxSpan <= 0 then
    QTranInfo.MaxSpan := -1;
  if not lOneGlobal.ZTManage.CommitTranItem(QTranInfo.TranID, lErrMsg) then
  begin
    result.ResultMsg := lErrMsg;
    exit;
  end;
  result.ResultOK := true;
end;

// 5.回滚账套连接事务
function TOneDataController.RollbackTranItem(QTranInfo: TOneTran): TOneDataResult;
var
  lOneGlobal: TOneGlobal;
  lErrMsg: string;
begin
  result := TOneDataResult.Create;
  if QTranInfo.TranID = '' then
  begin
    result.ResultMsg := '事务TrandID不可为空';
    exit;
  end;
  lOneGlobal := TOneGlobal.GetInstance();
  if QTranInfo.MaxSpan <= 0 then
    QTranInfo.MaxSpan := -1;
  if not lOneGlobal.ZTManage.RollbackTranItem(QTranInfo.TranID, lErrMsg) then
  begin
    result.ResultMsg := lErrMsg;
    exit;
  end;
  result.ResultOK := true;
end;

// 获取数据库表信息相
function TOneDataController.GetDBMetaInfo(QDBMetaInfo: TOneDBMetaInfo): TOneDataResult;
var
  lOneGlobal: TOneGlobal;
  i: Integer;
begin
  result := TOneDataResult.Create;
  lOneGlobal := TOneGlobal.GetInstance();
  // 打开数据
  if not lOneGlobal.ZTManage.GetDBMetaInfo(QDBMetaInfo, result) then
  begin
    exit;
  end;
  // 解析相关数据
  if result.ResultOK then
  begin
    result.DoResultitems();
  end;
end;

function TOneDataController.ExecScript(QDataOpen: TOneDataOpen): TActionResult<string>;
var
  lOneGlobal: TOneGlobal;
  i: Integer;
  lErrMsg: string;
begin
  result := TActionResult<string>.Create(false, false);
  try
    lOneGlobal := TOneGlobal.GetInstance();
    QDataOpen.OpenSQL := OneSQLCrypto.SwapDecodeCrypto(QDataOpen.OpenSQL);
    // 打开数据
    if not lOneGlobal.ZTManage.ExecScript(QDataOpen, lErrMsg) then
    begin
      result.ResultMsg := lErrMsg;
      exit;
    end;
    // 解析相关数据
    result.ResultData := '执行脚本成功';
    result.SetResultTrue;
  except
    on e: Exception do
    begin
      result.ResultMsg := e.Message;
    end;
  end;
end;

initialization

// 单例模式注册
OneHttpRouterManage.GetInitRouterManage().AddHTTPSingleWork('OneServer/Data', TOneDataController, 0, CreateNewOneDataController);

finalization

end.

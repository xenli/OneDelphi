unit UniGoodsController;

interface

uses
  system.StrUtils, system.SysUtils, Math, system.JSON, system.Threading, system.Classes,
  OneHttpController, OneHttpRouterManage, OneHttpCtxtResult, OneTokenManage, OneHttpConst,
  system.Generics.Collections, OneControllerResult, FireDAC.Comp.Client, Data.DB, OneGuID,
  OneMultipart, UniClass, system.IOUtils;

type

  TUniGoodsController = class(TOneControllerBase)
  public
    // 返回一个商品类表
    function GetGoodDemoList(): TActionResult<TList<TGoodsDemo>>;
    // 返回部份商品数据
    // Json上传{"pageIndex":1,"pageSize":10}
    function GetGoodDemoListPage(pageIndex: integer; pageSize: integer): TActionResult<TList<TGoodsDemo>>;
    // 与数据库结合
    // 返回一个商品类表,跟据 goodInfo过滤相关数据,
    function GetGoodsList(pageIndex: integer; pageSize: integer; goodInfo: string): TActionResult<TFDMemtable>;
    // 返回一个商品类表,跟据传上来的Json数据过滤相关数据
    function GetGoodsListByJson(QJson: TJsonObject): TActionResult<TFDMemtable>;
    // 返回一个商品信息, 上传上来的参数 {"QGoodsID":"参数值"}
    function GetGoods(QGoodsID: string): TActionResult<TGoodsDemo>;

    function SaveGoods(QGoods: TGoodsDemo): TActionResult<string>;

    // 文件上传
    function PostGoodsImg(QFormData: TOneMultipartDecode): TActionResult<string>;
    function OneGetGoodsImg(imgid: string): TActionResult<string>;
  end;

function CreateNewGoodsController(QRouterItem: TOneRouterWorkItem): TObject;

implementation

uses OneGlobal, OneZTManage, OneFileHelper;

function CreateNewGoodsController(QRouterItem: TOneRouterWorkItem): TObject;
var
  lController: TUniGoodsController;
begin
  // 自定义创建控制器类，否则会按 TPersistentclass.create
  // 最好自定义一个好
  lController := TUniGoodsController.Create;
  // 挂载RTTI信息
  lController.RouterItem := QRouterItem;
  result := lController;
end;

// 返回一个商品类表
function TUniGoodsController.GetGoodDemoList(): TActionResult<TList<TGoodsDemo>>;
var
  lGoodDemo: TGoodsDemo;
  lList: TList<TGoodsDemo>;
  i: integer;
begin
  // TList<TGoodsDemo>即List里面的TGoodDemo用完多要设定成释放
  result := TActionResult < TList < TGoodsDemo >>.Create(true, true);
  result.resultData := TList<TGoodsDemo>.Create;
  for i := 1 to 50 do
  begin
    lGoodDemo := TGoodsDemo.Create;
    result.resultData.Add(lGoodDemo);
    lGoodDemo.FGoodsCode := 'code' + i.ToString;
    lGoodDemo.FGoodsName := 'name' + i.ToString;
    lGoodDemo.FGoodsPrice := i * 10;
    lGoodDemo.FGoodsRemark := '商品测试';
  end;
  result.SetResultTrue();
end;

function TUniGoodsController.GetGoodDemoListPage(pageIndex: integer; pageSize: integer): TActionResult<TList<TGoodsDemo>>;
var
  lGoodDemo: TGoodsDemo;
  lList: TList<TGoodsDemo>;
  i, iPageTotal: integer;
begin
  // TList<TGoodsDemo>即List里面的TGoodDemo用完多要设定成释放
  result := TActionResult < TList < TGoodsDemo >>.Create(true, true);
  // 假设总共50条
  if pageSize <= 0 then
    pageSize := 10;
  if pageSize >= 50 then
    pageSize := 50;
  if pageIndex <= 0 then
    pageIndex := 1;
  iPageTotal := ceil(50 / pageSize);
  if pageIndex > iPageTotal then
  begin
    result.resultMsg := '最大页数[' + iPageTotal.ToString + ']数据已到底了';
    exit;
  end;
  //
  result.resultData := TList<TGoodsDemo>.Create;
  for i := (pageIndex - 1) * pageSize to pageIndex * pageSize do
  begin
    lGoodDemo := TGoodsDemo.Create;
    result.resultData.Add(lGoodDemo);
    lGoodDemo.FGoodsCode := 'code' + i.ToString;
    lGoodDemo.FGoodsName := 'name' + i.ToString;
    lGoodDemo.FGoodsPrice := i * 10;
    lGoodDemo.FGoodsRemark := '商品测试';
  end;
  result.SetResultTrue();
end;

// 从数据库中去获取相关商品资料信息 ,当然也可以直接返回TFDMemDataSet,只要前后端字段一至就行
function TUniGoodsController.GetGoodsList(pageIndex: integer; pageSize: integer; goodInfo: string): TActionResult<TFDMemtable>;
var
  lZTItem: TOneZTItem;
  lFDQuery: TFDQuery;
  lOneTokenItem: TOneTokenItem;
  lOneZTMange: TOneZTManage;
  lOneTokenManage: TOneTokenManage;
  lGoodDemo: TGoodsDemo;
  lErrMsg: string;
begin
  result := TActionResult<TFDMemtable>.Create(true, false);
  // 获取用户Token信息,跟据当前线程ID,无需通过参数
  lOneTokenItem := self.GetCureentToken(lErrMsg);
  if lOneTokenItem = nil then
  begin
    result.SetTokenFail();
    exit;
  end;
  lOneZTMange := TOneGlobal.GetInstance().ZTManage;
  lZTItem := lOneZTMange.LockZTItem(lOneTokenItem.ZTCode, lErrMsg);
  if lZTItem = nil then
  begin
    result.resultMsg := lErrMsg;
    exit;
  end;

  try
    try
      // 理论查询用orm最好的
      // 从账套获取现成的FDQuery,已绑定好 connetion,也无需释放
      lFDQuery := lZTItem.ADQuery;
      // 查询所有
      if goodInfo = '' then
      begin
        lFDQuery.SQL.Text := 'select FGoodsID,FGoodsCode,FGoodsName,FGoodsPrice,FGoodsRemark,FGoodsImgUrl from demo_goods where 1=1 order by FGoodsCode';
      end
      else
      begin
        // 相拟查询
        lFDQuery.SQL.Text := 'select FGoodsID,FGoodsCode,FGoodsName,FGoodsPrice,FGoodsRemark,FGoodsImgUrl from demo_goods ' +
          ' where FGoodsCode like :goodInfo or FGoodsName like :goodInfo order by FGoodsCode ';
        lFDQuery.Params[0].AsString := '%' + goodInfo + '%';
      end;
      // 分页设置
      if (pageSize > 0) and (pageIndex > 0) then
      begin
        lFDQuery.FetchOptions.RecsSkip := (pageIndex - 1) * pageSize;
        lFDQuery.FetchOptions.RecsMax := pageSize;
      end
      else
      begin
        lFDQuery.FetchOptions.RecsSkip := -1;
        if pageSize > 0 then
          lFDQuery.FetchOptions.RecsMax := pageSize
        else
          lFDQuery.FetchOptions.RecsMax := 50;

      end;
      lFDQuery.Open;
      result.resultData := TFDMemtable.Create(nil);
      // lFDQuery是池中的数据集，不能放出去用。要COPY下数据
      result.resultData.Data := lFDQuery.Data;
      //
      result.SetResultTrue;
    except
      on e: Exception do
      begin
        result.resultMsg := '发生异常,原因:' + e.Message;
      end;
    end;
  finally
    // 解锁,归还池很重要
    lZTItem.UnLockWork;
  end;
end;

// 返回一个商品类表,跟据传上来的Json数据过滤相关数据
function TUniGoodsController.GetGoodsListByJson(QJson: TJsonObject): TActionResult<TFDMemtable>;
var
  lZTItem: TOneZTItem;
  lFDQuery: TFDQuery;
  lOneTokenItem: TOneTokenItem;
  lOneZTMange: TOneZTManage;
  lOneTokenManage: TOneTokenManage;
  lGoodDemo: TGoodsDemo;
  lErrMsg: string;
  pageSize, pageIndex: integer;
  goodInfo: string;
begin
  result := TActionResult<TFDMemtable>.Create(true, false);
  // 获取用户Token信息,跟据当前线程ID,无需通过参数
  lOneTokenItem := self.GetCureentToken(lErrMsg);
  if lOneTokenItem = nil then
  begin
    result.SetTokenFail();
    exit;
  end;
  lOneZTMange := TOneGlobal.GetInstance().ZTManage;
  lZTItem := lOneZTMange.LockZTItem(lOneTokenItem.ZTCode, lErrMsg);
  if lZTItem = nil then
  begin
    result.resultMsg := lErrMsg;
    exit;
  end;
  QJson.TryGetValue<integer>('pageSize', pageSize);
  QJson.TryGetValue<integer>('pageIndex', pageIndex);
  QJson.TryGetValue<string>('goodInfo', goodInfo);
  try
    try
      // 理论查询用orm最好的
      // 从账套获取现成的FDQuery,已绑定好 connetion,也无需释放
      lFDQuery := lZTItem.ADQuery;
      // 查询所有
      if goodInfo = '' then
      begin
        lFDQuery.SQL.Text := 'select  FGoodsID,FGoodsCode,FGoodsName,FGoodsPrice,FGoodsRemark,FGoodsImgUrl  from demo_goods where 1=1 order by FGoodsCode';
      end
      else
      begin
        // 相拟查询
        lFDQuery.SQL.Text := 'select  FGoodsID,FGoodsCode,FGoodsName,FGoodsPrice,FGoodsRemark,FGoodsImgUrl  from demo_goods ' +
          ' where FGoodsCode like :goodInfo or FGoodsName like :goodInfo order by FGoodsCode ';
        lFDQuery.Params[0].AsString := '%' + goodInfo + '%';
      end;
      // 分页设置
      if (pageSize > 0) and (pageIndex > 0) then
      begin
        lFDQuery.FetchOptions.RecsSkip := (pageIndex - 1) * pageSize;
        lFDQuery.FetchOptions.RecsMax := pageSize;
      end
      else
      begin
        lFDQuery.FetchOptions.RecsSkip := -1;
        if pageSize > 0 then
          lFDQuery.FetchOptions.RecsMax := pageSize
        else
          lFDQuery.FetchOptions.RecsMax := -1;

      end;
      lFDQuery.Open;
      result.resultData := TFDMemtable.Create(nil);
      // lFDQuery是池中的数据集，不能放出去用。要COPY下数据
      result.resultData.Data := lFDQuery.Data;
      //
      result.SetResultTrue;
    except
      on e: Exception do
      begin
        result.resultMsg := '发生异常,原因:' + e.Message;
      end;
    end;
  finally
    // 解锁,归还池很重要
    lZTItem.UnLockWork;
  end;
end;

function TUniGoodsController.GetGoods(QGoodsID: string): TActionResult<TGoodsDemo>;
var
  lZTItem: TOneZTItem;
  lFDQuery: TFDQuery;
  lOneTokenItem:TOneTokenItem;
  lOneZTMange: TOneZTManage;
  lOneTokenManage: TOneTokenManage;
  lGoodDemo: TGoodsDemo;
  lErrMsg: string;
begin
  result := TActionResult<TGoodsDemo>.Create(true, false);
  if QGoodsID = '' then
  begin
    result.resultMsg := '请上传参数{"QGoodsID":"值"}';
    exit;
  end;
  // 获取用户Token信息,跟据当前线程ID,无需通过参数
  lOneTokenItem := self.GetCureentToken(lErrMsg);
  if lOneTokenItem = nil then
  begin
    result.SetTokenFail();
    exit;
  end;
  lOneZTMange := TOneGlobal.GetInstance().ZTManage;
  lZTItem := lOneZTMange.LockZTItem(lOneTokenItem.ZTCode, lErrMsg);
  if lZTItem = nil then
  begin
    result.resultMsg := lErrMsg;
    exit;
  end;

  try
    try
      // 理论查询用orm最好的
      // 从账套获取现成的FDQuery,已绑定好 connetion,也无需释放
      lFDQuery := lZTItem.ADQuery;
      // 查询所有
      lFDQuery.SQL.Text := 'select FGoodsID,FGoodsCode,FGoodsName,FGoodsPrice,FGoodsRemark,FGoodsImgUrl from demo_goods where FGoodsID=:FGoodsID';
      lFDQuery.Params[0].AsString := QGoodsID;
      lFDQuery.Open;
      if lFDQuery.RecordCount = 0 then
      begin
        result.resultMsg := '不存在当前ID的商品数据';
        exit;
      end;
      lGoodDemo := TGoodsDemo.Create();
      result.resultData := lGoodDemo;
      lGoodDemo.FGoodsID := lFDQuery.FieldByName('FGoodsID').AsString;
      lGoodDemo.FGoodsCode := lFDQuery.FieldByName('FGoodsCode').AsString;
      lGoodDemo.FGoodsName := lFDQuery.FieldByName('FGoodsName').AsString;
      lGoodDemo.FGoodsPrice := lFDQuery.FieldByName('FGoodsPrice').AsFloat;
      lGoodDemo.FGoodsRemark := lFDQuery.FieldByName('FGoodsRemark').AsString;
      lGoodDemo.FGoodsImgUrl := lFDQuery.FieldByName('FGoodsImgUrl').AsString;
      //
      result.SetResultTrue;
    except
      on e: Exception do
      begin
        result.resultMsg := '发生异常,原因:' + e.Message;
      end;
    end;
  finally
    // 解锁,归还池很重要
    lZTItem.UnLockWork;
  end;
end;

function TUniGoodsController.SaveGoods(QGoods: TGoodsDemo): TActionResult<string>;
var
  lZTItem: TOneZTItem;
  lFDQuery: TFDQuery;
  lOneTokenItem:TOneTokenItem;
  lOneZTMange: TOneZTManage;
  lOneTokenManage: TOneTokenManage;
  lGoodDemo: TGoodsDemo;
  lErrMsg: string;
  pageSize, pageIndex: integer;
  goodInfo: string;
  isCommit: boolean;
  iCommit, iErr: integer;
begin
  // 多不释放,result.data := QGood,由参数自已释放
  result := TActionResult<string>.Create(false, false);
  // 检验数据

  if QGoods.FGoodsCode = '' then
  begin
    result.resultMsg := '商品代码不可为空';
    exit;
  end;

  if QGoods.FGoodsName = '' then
  begin
    result.resultMsg := '商品名称不可为空';
    exit;
  end;

  // 获取用户Token信息,跟据当前线程ID,无需通过参数
  lOneTokenItem := self.GetCureentToken(lErrMsg);
  if lOneTokenItem = nil then
  begin
    result.SetTokenFail();
    exit;
  end;
  lOneZTMange := TOneGlobal.GetInstance().ZTManage;
  lZTItem := lOneZTMange.LockZTItem(lOneTokenItem.ZTCode, lErrMsg);
  if lZTItem = nil then
  begin
    result.resultMsg := lErrMsg;
    exit;
  end;

  try
    isCommit := false;
    lZTItem.ADConnection.StartTransaction;
    try
      // 主键有值说明是编辑,无值说明是新增
      QGoods.SetRowState(QGoods.FGoodsID);
      // 理论查询用orm最好的
      // 从账套获取现成的FDQuery,已绑定好 connetion,也无需释放
      lFDQuery := lZTItem.ADQuery;
      lFDQuery.UpdateOptions.UpdateTableName := 'demo_goods'; // 设置表名
      lFDQuery.UpdateOptions.KeyFields := 'FGoodsID'; // 设置主键
      //
      lFDQuery.UpdateOptions.UpdateMode := TUpdateMode.upWhereKeyOnly; // 设置更新模式
      if QGoods.GetRowState = emRowstate.insertState then
      begin
        // 打开一个空数据集
        lFDQuery.SQL.Text := 'select  *  from demo_goods where 1=2';
      end
      else
      begin
        // 相拟查询
        lFDQuery.SQL.Text := 'select * from demo_goods where FGoodsID=:FGoodsID';
        lFDQuery.Params[0].AsString := QGoods.FGoodsID;
      end;
      lFDQuery.Open;
      if QGoods.GetRowState = emRowstate.insertState then
      begin
        // 新增相关东东赋值下
        QGoods.FGoodsID := OneGuID.GetGUID32;
        lFDQuery.Append;
        lFDQuery.FieldByName('FGoodsID').AsString := QGoods.FGoodsID;
        lFDQuery.FieldByName('FGoodsCode').AsString := QGoods.FGoodsCode;
        lFDQuery.FieldByName('FGoodsName').AsString := QGoods.FGoodsName;
        lFDQuery.FieldByName('FGoodsPrice').AsFloat := QGoods.FGoodsPrice;
        lFDQuery.FieldByName('FGoodsRemark').AsString := QGoods.FGoodsRemark;
        lFDQuery.FieldByName('FGoodsImgUrl').AsString := QGoods.FGoodsImgUrl;
        lFDQuery.post;
      end
      else
      begin
        // 编辑相关东东
        if lFDQuery.RecordCount = 0 then
        begin
          result.resultMsg := '数据不存在,请检查';
          exit;
        end;
        lFDQuery.edit;
        lFDQuery.FieldByName('FGoodsCode').AsString := QGoods.FGoodsCode;
        lFDQuery.FieldByName('FGoodsName').AsString := QGoods.FGoodsName;
        lFDQuery.FieldByName('FGoodsPrice').AsFloat := QGoods.FGoodsPrice;
        lFDQuery.FieldByName('FGoodsRemark').AsString := QGoods.FGoodsRemark;
        if QGoods.FGoodsImgUrl <> '' then
        begin
          lFDQuery.FieldByName('FGoodsImgUrl').AsString := QGoods.FGoodsImgUrl; // 设定此字段不参与任何更新
        end;
        // lFDQuery.FieldByName('FGoodsImgUrl').
        lFDQuery.post;
      end;
      iErr := lFDQuery.ApplyUpdates(-1);
      if iErr <> 0 then
      begin
        result.resultMsg := '更新数据有误,错误行数' + iErr.ToString;
        exit;
      end;
      // iCommit := lFDQuery.RowsAffected;
      // if iCommit <> 1 then
      // begin
      // result.resultMsg := '更新数据有误,影响行数不为1,当前影响行数' + iCommit.ToString;
      // exit;
      // end;
      lZTItem.ADConnection.Commit;
      isCommit := true;
      result.resultData := QGoods.FGoodsID;
      result.SetResultTrue;
    except
      on e: Exception do
      begin
        result.resultMsg := '发生异常,原因:' + e.Message;
      end;
    end;
  finally

    if not isCommit then
    begin
      lZTItem.ADConnection.Rollback;
    end;
    // 解锁,归还池很重要
    lZTItem.UnLockWork;
  end;
end;

function TUniGoodsController.PostGoodsImg(QFormData: TOneMultipartDecode): TActionResult<string>;
var
  i: integer;
  lWebRequestFile: TOneRequestFile;
  tempStream: TCustomMemoryStream;
  tempFileStream: TFileStream;
  lFileName, tempPath: string;
  lFileID: string;
  lExten: string;
  lOldImgUrl: string;
begin
  result := TActionResult<string>.Create(false, false);
  lExten := '';
  lOldImgUrl := '';
  if QFormData.Files.Count = 0 then
  begin
    result.resultMsg := '无任何上传文件';
    exit;
  end;
  for i := 0 to QFormData.ContentFields.Count - 1 do
  begin
    if QFormData.ContentFields.Names[i] = 'oldImgUrl' then
    begin
      lOldImgUrl := QFormData.ContentFields.ValueFromIndex[i];
    end;
    result.resultData := result.resultData + '当前接收到参数[' + QFormData.ContentFields[i] + ']' + #10#13;
  end;

  lWebRequestFile := TOneRequestFile(QFormData.Files.items[0]);
  tempStream := TCustomMemoryStream(lWebRequestFile.Stream);
  lFileName := lWebRequestFile.FileName;
  if TPath.HasExtension(lFileName) then
  begin
    lExten := TPath.GetExtension(lFileName)
  end;
  lFileID := OneGuID.GetGUID32;
  if lExten <> '' then
    lFileID := lFileID + lExten;
  // 创建目录
  tempPath := OneFileHelper.CombinePathC(OneFileHelper.GetExeRunPath, const_OnePlatform, 'UniGoods');
  if not DirectoryExists(tempPath) then
    ForceDirectories(tempPath);
  //
  tempStream.Position := 0;
  lFileName := OneFileHelper.CombinePath(tempPath, lFileID);
  tempFileStream := TFileStream.Create(lFileName, fmcreate);
  try
    tempFileStream.CopyFrom(tempStream, tempStream.Size)
  finally
    tempFileStream.free;
  end;
  // tempStream.Position := 0;
  // tempStream.SaveToFile(lFileName);
  if lOldImgUrl <> '' then
  begin
    // 删除旧文件
    lFileName := OneFileHelper.CombinePath(tempPath, lOldImgUrl);
    if TFile.Exists(lFileName) then
    begin
      TFile.Delete(lFileName);
    end;
  end;
  result.resultData := lFileID;
  // 保存在某个目录
  result.SetResultTrue();
end;

function TUniGoodsController.OneGetGoodsImg(imgid: string): TActionResult<string>;
var
  lFileName, tempPath: string;
begin
  result := TActionResult<string>.Create(false, false);
  tempPath := OneFileHelper.CombinePathC(OneFileHelper.GetExeRunPath, const_OnePlatform, 'UniGoods');
  lFileName := OneFileHelper.CombinePath(tempPath, imgid);
  if not TFile.Exists(lFileName) then
  begin
    result.resultMsg := '文件不存在';
    exit;
  end;
  // 返回的文件物理路径放在这
  result.resultData := lFileName;
  result.SetResultTrueFile();
end;

initialization

// 单例模式注册
OneHttpRouterManage.GetInitRouterManage().AddHTTPSingleWork('/UniDemo/Goods', TUniGoodsController, 0, CreateNewGoodsController);

finalization

end.

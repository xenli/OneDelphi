unit OneClientDataSet;

// 数据集控件,继承TFDMemTable
interface

uses
  System.SysUtils, System.StrUtils, System.Classes, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, FireDAC.Stan.Intf,
  FireDAC.Stan.Param, System.Threading,
  System.Generics.Collections, {$IFDEF MSWINDOWS} Vcl.Dialogs, {$ENDIF}
  OneClientConnect, OneClientDataInfo, OneClientConst;

type
  TOneDataSet = class;
  TOneDataInfo = class;

  TOneDataInfo = class(TPersistent)
  private
    //
    FCreateID: string;
    // 设计时获取相关字段
    FIsDesignGetFields: boolean;
    // 所属数据集
    FOwnerDataSet: TOneDataSet;
    // OneServer连接
    FConnection: TOneConnection;
    // 账套代码
    FZTCode: string;
    // 控件描述
    FDescription: string;
    // 表名,保存时用到
    FTableName: string;
    // 主键,保存时用到
    FPrimaryKey: string;
    // 其它辅助主键,保存时用到
    FOtherKeys: string;
    // 数据集打开数据模式
    FOpenMode: TDataOpenMode;
    //
    FIsPost:boolean;
    // 保存数据集模式
    FSaveMode: TDataSaveMode;
    // 服务端返回数据模式
    FDataReturnMode: TDataReturnMode;
    // 包名
    FPackageName: string;
    // 存储过程名称
    FStoredProcName: string;
    // 分页 每页大小 默认-1 不限制
    FPageSize: Integer;
    // 分页 第几页
    FPageIndex: Integer;
    // 分页 总共页数
    FPageCount: Integer;
    // 分页 总共条数
    FPageTotal: Integer;
    // 执行SQL语句，最多影响行数
    FAffectedMaxCount: Integer;
    // 执行SQL语句，必需有且几条一定受影响
    FAffectedMustCount: Integer;
    // 服务端返回影响行数
    FRowsAffected: Integer;
    // 是否异步
    FAsynMode: boolean;
    // 是否返回数据集
    FIsReturnData: boolean;
    // 执选DML insert 时返回的自增ID
    FReturnAutoID: string;
    // 服务端返回的JSON数据
    FReturnJson: string;
    // SQL最终使用方式采用服务端SQL，客户端SQL只是为了设置方便
    // 后期扩展 ,不填默认采用客户端传SQL模式
    FSQLServerCode: string;
    // 二层模式事务ID
    FTranID: string;
    // 事务锁定时间 <=0,无限。
    FTranSpanSec: Integer;
    // 错误信息
    FErrMsg: string;
  private
    // 获取连接
    function GetConnection: TOneConnection;
    procedure SetConnection(const AValue: TOneConnection);
    // 设计模式下获取相关字段
    procedure SetGetFields(value: boolean);
  public
    constructor Create(QDataSet: TOneDataSet); overload;
    destructor Destroy; override;
  published
    property CreateID: string read FCreateID write FCreateID;
    /// <param name="IsDesignGetFields">设计时获取相关字段,请先设置好连接及SQL</param>
    property IsDesignGetFields: boolean read FIsDesignGetFields write SetGetFields;
    /// <param name="OwnerDataSet">所属数据集</param>
    property OwnerDataSet: TOneDataSet read FOwnerDataSet;
    /// <param name="Connection">连接OneServer服务器的连接</param>
    property Connection: TOneConnection read GetConnection write SetConnection;
    /// <param name="ZTCode">账套代码,有设置优先取此账套代码,否则取Connection公用的账套代码</param>
    property ZTCode: string read FZTCode write FZTCode;
    /// <param name="FDescription">控件描述</param>
    property Description: string read FDescription write FDescription;
    /// <param name="TableName">表名,保存时会用到</param>
    property TableName: string read FTableName write FTableName;
    /// <param name="PrimaryKey">主键,保存时用到</param>
    property PrimaryKey: string read FPrimaryKey write FPrimaryKey;
    /// <param name="OtherKeys">其它辅助主键,多个用;分开</param>
    property OtherKeys: string read FOtherKeys write FOtherKeys;
    /// <param name="OpenMode">数据集打开模式</param>
    property OpenMode: TDataOpenMode read FOpenMode write FOpenMode;
    property IsPost:boolean read FIsPost write FIsPost;
    /// <param name="SaveMode">保存数据集模式,数据集delate和DML操作语句</param>
    property SaveMode: TDataSaveMode read FSaveMode write FSaveMode;
    /// <param name="DataReturnMode">数据集返回模式</param>
    property DataReturnMode: TDataReturnMode read FDataReturnMode write FDataReturnMode;
    /// <param name="PackageName">包名</param>
    property PackageName: string read FPackageName write FPackageName;
    /// <param name="StoredProcName">存储过程名称</param>
    property StoredProcName: string read FStoredProcName write FStoredProcName;
    /// <param name="PageSize">分页 每页大小 默认-1 不限制</param>
    property PageSize: Integer read FPageSize write FPageSize;
    /// <param name="PageIndex">分页 第几页</param>
    property PageIndex: Integer read FPageIndex write FPageIndex;
    /// <param name="PageCount">分页 总共页数</param>
    property PageCount: Integer read FPageCount write FPageCount;
    /// <param name="PageTotal">分页 总共条数</param>
    property PageTotal: Integer read FPageTotal write FPageTotal;
    /// <param name="AffectedMaxCount">执行DML语句，最多影响行数，0代表不控制</param>
    property AffectedMaxCount: Integer read FAffectedMaxCount write FAffectedMaxCount;
    /// <param name="AffectedMustCount">执行DML语句必需有且几条一定受影响，默认1条，0代表不控制</param>
    property AffectedMustCount: Integer read FAffectedMustCount write FAffectedMustCount;
    /// <param name="RowsAffected">执行SQL语句,服务端返回影响行数</param>
    property RowsAffected: Integer read FRowsAffected write FRowsAffected;
    /// <param name="AsynMode">是否异步</param>
    property AsynMode: boolean read FAsynMode write FAsynMode;
    /// <param name="IsReturnData">是否返回数据集,比如执行存储过程是否返回数据</param>
    property IsReturnData: boolean read FIsReturnData write FIsReturnData;
    /// <param name="ReturnAutoID">返回自增ID的值  执选DML insert 时返回的自增ID</param>
    property ReturnAutoID: string read FReturnAutoID write FReturnAutoID;
    /// <param name="ReturnJson">服务端返回的JSON数据</param>
    property ReturnJson: string read FReturnJson write FReturnJson;
    /// <param name="SQLServerCode">服务端SQL板模编码</param>
    property SQLServerCode: string read FSQLServerCode write FSQLServerCode;
    /// <param name="TranID">二层模式事务ID</param>
    property TranID: string read FTranID write FTranID;
    /// <param name="TranSpanSec">默认0，不超时</param>
    property TranSpanSec: Integer read FTranSpanSec write FTranSpanSec;
    /// <param name="ErrMsg">错误信息</param>
    property ErrMsg: string read FErrMsg write FErrMsg;
  end;

  [ComponentPlatformsAttribute(OneAllPlatforms)]
  TOneDataSet = class(TFDMemTable)
  private
    // one扩展属性
    FDataInfo: TOneDataInfo;
    // 多个数据集
    FMultiData: TList<TFDMemTable>;
    // 多个数据集当前索引
    FMultiIndex: Integer;
    // SQL相关
    FCommandText: TStrings;
    // 参数相关
    FParams: TFDParams;
  private
    procedure SetParams(value: TFDParams);
    procedure SetCommandText(const value: TStrings);
    procedure SQLListChanged(Sender: TObject);
    procedure SetMultiIndex(value: Integer);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  public
    /// <summary>
    /// 打开数据集，返回所有数据，如果Pagesize和PageIndex设置，则返回分页数据
    /// </summary>
    /// <returns>失败返回False,错误信息在ErrMsg属性</returns>
    function Open: boolean;
    /// <summary>
    /// 打开数据集，返回所有数据，如果Pagesize和PageIndex设置，则返回分页数据
    /// </summary>
    /// <returns>失败返回False,错误信息在ErrMsg属性</returns>
    function OpenData: boolean;
    /// <summary>
    /// 异步打开数据集，返回所有数据，如果Pagesize和PageIndex设置，则返回分页数据
    /// </summary>
    /// <returns>成功失败多调用 QCallEven</returns>
    procedure OpenDataAsync(QCallEven: EvenOKCallBack);
    /// <summary>
    /// 保存数据
    /// </summary>
    /// <returns>失败返回False,错误信息在ErrMsg属性</returns>
    function Save: boolean;
    /// <summary>
    /// 保存数据,提交数据Delta
    /// </summary>
    /// <returns>失败返回False,错误信息在ErrMsg属性</returns>
    function SaveData: boolean;
    procedure SaveDataAsync(QCallEven: EvenOKCallBack);
    /// <summary>
    /// 执行DML语句,update,insert,delete语句
    /// </summary>
    /// <returns>失败返回False,错误信息在ErrMsg属性</returns>
    function ExecDML: boolean;

    /// <summary>
    /// 执行存储过程，返回数据
    /// </summary>
    /// <returns>失败返回False,错误信息在ErrMsg属性</returns>
    function OpenStored: boolean;
    /// <summary>
    /// 执行存储过程，不返回数据
    /// </summary>
    /// <returns>失败返回False,错误信息在ErrMsg属性</returns>
    function ExecStored: boolean;
    /// <summary>
    /// 事务控制第一步:获取账套连接,标识成事务账套
    /// </summary>
    /// <returns>失败返回False,错误信息在ErrMsg属性</returns>
    function LockTran(): boolean;
    /// <summary>
    /// 事务控制第最后步:用完了账套连接,归还账套,如果没归还，很久后，服务端会自动处理归还
    /// </summary>
    /// <returns>失败返回False,错误信息在ErrMsg属性</returns>
    function UnLockTran(): boolean;
    /// <summary>
    /// 事务控制第二步:开始事务
    /// </summary>
    /// <returns>失败返回False,错误信息在ErrMsg属性</returns>
    function StartTran(): boolean;
    /// <summary>
    /// 事务控制第三步:提交事务
    /// </summary>
    /// <returns>失败返回False,错误信息在ErrMsg属性</returns>
    function CommitTran(): boolean;
    /// <summary>
    /// 事务控制第三步:回滚事务
    /// </summary>
    /// <returns>失败返回False,错误信息在ErrMsg属性</returns>
    function RollbackTran(): boolean;
  published
    { Published declarations }
    /// <param name="SQL">SQL语句，您可以在这里设置您要执行的SQL语句文本，然后通过OpenData方法打开数据集</param>
    property SQL: TStrings read FCommandText write SetCommandText;
    /// <param name="DataInfo">one扩展功能的统一放在一个类</param>
    property DataInfo: TOneDataInfo read FDataInfo write FDataInfo;
    /// <param name="Params">参数设置</param>
    property Params: TFDParams read FParams write SetParams;
    /// <param name="MultiData">返回多个据存储的地方</param>
    property MultiData: TList<TFDMemTable> read FMultiData write FMultiData;
    property MultiIndex: Integer read FMultiIndex write SetMultiIndex;
  end;

implementation

function getID(IsOrder: boolean = False): string;
var
  ii: TGUID;
  lDateTime: TDateTime;
begin
  CreateGUID(ii);
  Result := LowerCase(Copy(AnsiReplaceStr(GUIDToString(ii), '-', ''), 2, 32));
end;

constructor TOneDataSet.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Self.CachedUpdates := True;
  FParams := TFDParams.Create;
  FCommandText := TStringList.Create;
  FCommandText.TrailingLineBreak := False;
  TStringList(FCommandText).OnChange := SQLListChanged;
  FDataInfo := TOneDataInfo.Create(Self);
  FMultiData := nil;
  FMultiIndex := 0;
  Self.UpdateOptions.UpdateMode := TUpdateMode.upWhereKeyOnly;
  { 28->XE10之后才有这属性 }
{$IF CompilerVersion >=31}
  Self.UpdateOptions.AutoCommitUpdates := False;
{$ENDIF}
end;

destructor TOneDataSet.Destroy;
var
  i: Integer;
begin
  FCommandText.Clear;
  FCommandText.Free;
  if FDataInfo <> nil then
  begin
    FDataInfo.Free;
    FDataInfo := nil;
  end;
  if FMultiData <> nil then
  begin
    for i := 0 to FMultiData.Count - 1 do
    begin
      FMultiData[i].Close;
      FMultiData[i].Free;
    end;
    FMultiData.Clear;
    FMultiData.Free;
  end;
  FParams.Free;
  inherited Destroy;
end;

procedure TOneDataSet.SetParams(value: TFDParams);
begin
  if value <> FParams then
    FParams.Assign(value);
end;

procedure TOneDataSet.SetCommandText(const value: TStrings);
var
  SQL: string;
  List: TParams;
begin
  // 分析SQL获取相关信息
  if FCommandText <> value then
    FCommandText.Assign(value);
end;

// SQL改变自动改变参数
procedure TOneDataSet.SQLListChanged(Sender: TObject);
var
  i: Integer;
  LNewParams: TParams;
  LOldFDParams: TFDParams;
  LNewFDParam, LOldFDParam: TFDParam;
  lOldFDPramsDict: TDictionary<string, TFDParam>;
  lNewFDPramsDict: TDictionary<string, TFDParam>;
begin
  if FCommandText.Text <> '' then
  begin
    // 参数
    lOldFDPramsDict := TDictionary<string, TFDParam>.Create;
    lNewFDPramsDict := TDictionary<string, TFDParam>.Create;
    LNewParams := TParams.Create(Self);
    LOldFDParams := TFDParams.Create;
    try
      LNewParams.ParseSQL(FCommandText.Text, True);
      // 值拷贝
      for i := 0 to FParams.Count - 1 do
      begin
        if lOldFDPramsDict.ContainsKey(FParams[i].Name.ToLower) then
          continue;
        LOldFDParam := FParams[i];
        LNewFDParam := LOldFDParams.Add;
        LNewFDParam.Name := LOldFDParam.Name;
        LNewFDParam.value := LOldFDParam.value;
        LNewFDParam.DataTypeName := LOldFDParam.DataTypeName;
        LNewFDParam.IsCaseSensitive := LOldFDParam.IsCaseSensitive;
        LNewFDParam.NumericScale := LOldFDParam.NumericScale;
        LNewFDParam.Precision := LOldFDParam.Precision;
        LNewFDParam.Size := LOldFDParam.Size;
        LNewFDParam.StreamMode := LOldFDParam.StreamMode;
        LNewFDParam.DataType := LOldFDParam.DataType;
        LNewFDParam.ParamType := LOldFDParam.ParamType;
        lOldFDPramsDict.Add(FParams[i].Name.ToLower, LNewFDParam);
      end;
      // 清除自身的
      FParams.Clear;
      for i := 0 to LNewParams.Count - 1 do
      begin
        if lNewFDPramsDict.ContainsKey(LNewParams[i].Name.ToLower) then
          continue;
        LNewFDParam := FParams.Add;
        LNewFDParam.Name := LNewParams[i].Name;
        lNewFDPramsDict.Add(LNewParams[i].Name.ToLower, LNewFDParam);
        if lOldFDPramsDict.TryGetValue(LNewFDParam.Name.ToLower, LOldFDParam) then
        begin
          LNewFDParam.value := LOldFDParam.value;
          LNewFDParam.DataTypeName := LOldFDParam.DataTypeName;
          LNewFDParam.IsCaseSensitive := LOldFDParam.IsCaseSensitive;
          LNewFDParam.NumericScale := LOldFDParam.NumericScale;
          LNewFDParam.Precision := LOldFDParam.Precision;
          LNewFDParam.Size := LOldFDParam.Size;
          LNewFDParam.StreamMode := LOldFDParam.StreamMode;
          LNewFDParam.DataType := LOldFDParam.DataType;
          LNewFDParam.ParamType := LOldFDParam.ParamType;
        end;
      end;
    finally
      LNewParams.Free;
      lOldFDPramsDict.Clear;
      lOldFDPramsDict.Free;
      LOldFDParams.Clear;
      LOldFDParams.Free;
      lNewFDPramsDict.Clear;
      lNewFDPramsDict.Free;
    end;
  end
  else
    FParams.Clear;
end;

procedure TOneDataSet.SetMultiIndex(value: Integer);
var
  iMultiCount: Integer;
begin
  if Self.FMultiData = nil then
  begin
    Self.FMultiIndex := 0;
    exit;
  end;
  iMultiCount := Self.FMultiData.Count;
  if value > Self.FMultiData.Count - 1 then
  begin
    value := Self.FMultiData.Count - 1;
  end;
  if value < 0 then
    value := 0;
  Self.FMultiIndex := value;
  if iMultiCount > 0 then
  begin
    Self.Data := Self.FMultiData[Self.FMultiIndex];
  end;
end;

function TOneDataSet.Open: boolean;
begin
  Result := Self.OpenData;
end;

function TOneDataSet.OpenData: boolean;
begin
  Result := False;
  if Self.FDataInfo.FConnection = nil then
    Self.FDataInfo.FConnection := OneClientConnect.Unit_Connection;
  if Self.FDataInfo.FConnection = nil then
  begin
    Self.FDataInfo.FErrMsg := '数据集Connection=nil';
    exit;
  end;
  if Self.SQL.Text = '' then
  begin
    Self.FDataInfo.FErrMsg := '数据集DataInfo.SQL=空';
    exit;
  end;
  Result := Self.FDataInfo.FConnection.OpenData(Self);
end;

procedure TOneDataSet.OpenDataAsync(QCallEven: EvenOKCallBack);
var
  aTask: ITask;
begin
  aTask := TTask.Create(
    procedure
    var
      lResultOK: boolean;
    begin
      try
        lResultOK := Self.OpenData;
      finally
        if Assigned(QCallEven) then
        begin
          TThread.Synchronize(nil,
            procedure()
            var
              i: Integer;
            begin
              QCallEven(lResultOK, Self.FDataInfo.FErrMsg);
            end);
        end;
      end;
    end);
  aTask.Start;
end;

function TOneDataSet.Save: boolean;
begin
  Result := Self.SaveData;
end;

function TOneDataSet.SaveData: boolean;
begin
  Result := False;
  if Self.FDataInfo.FConnection = nil then
    Self.FDataInfo.FConnection := OneClientConnect.Unit_Connection;
  if Self.FDataInfo.FConnection = nil then
  begin
    Self.FDataInfo.FErrMsg := '数据集Connection=nil';
    exit;
  end;
  Result := Self.FDataInfo.FConnection.SaveData(Self);
end;

procedure TOneDataSet.SaveDataAsync(QCallEven: EvenOKCallBack);
var
  aTask: ITask;
begin
  aTask := TTask.Create(
    procedure
    var
      lResultOK: boolean;
    begin
      try
        lResultOK := Self.SaveData;
      finally
        if Assigned(QCallEven) then
        begin
          TThread.Synchronize(nil,
            procedure()
            var
              i: Integer;
            begin
              QCallEven(lResultOK, Self.FDataInfo.FErrMsg);
            end);
        end;
      end;
    end);
  aTask.Start;
end;

function TOneDataSet.ExecDML: boolean;
var
  lOldSaveMode: TDataSaveMode;
begin
  Result := False;
  if Self.FDataInfo.FConnection = nil then
    Self.FDataInfo.FConnection := OneClientConnect.Unit_Connection;
  if Self.FDataInfo.FConnection = nil then
  begin
    Self.FDataInfo.FErrMsg := '数据集Connection=nil';
    exit;
  end;
  lOldSaveMode := Self.FDataInfo.SaveMode;
  try
    Self.FDataInfo.SaveMode := TDataSaveMode.saveDML;
    Result := Self.FDataInfo.FConnection.SaveData(Self);
  finally
    Self.FDataInfo.SaveMode := lOldSaveMode;
  end;
end;

function TOneDataSet.OpenStored: boolean;
begin
  Result := False;
  if Self.FDataInfo.FConnection = nil then
    Self.FDataInfo.FConnection := OneClientConnect.Unit_Connection;
  if Self.FDataInfo.FConnection = nil then
  begin
    Self.FDataInfo.FErrMsg := '数据集Connection=nil';
    exit;
  end;
  if Self.FDataInfo.FStoredProcName = '' then
  begin
    Self.FDataInfo.FErrMsg := '未设置存储过程名称';
    exit;
  end;
  Self.FDataInfo.IsReturnData := True;
  Result := Self.FDataInfo.FConnection.ExecStored(Self);
end;

function TOneDataSet.ExecStored: boolean;
begin
  //
  Result := False;
  if Self.FDataInfo.FConnection = nil then
    Self.FDataInfo.FConnection := OneClientConnect.Unit_Connection;
  if Self.FDataInfo.FConnection = nil then
  begin
    Self.FDataInfo.FErrMsg := '数据集Connection=nil';
    exit;
  end;
  if Self.FDataInfo.FStoredProcName = '' then
  begin
    Self.FDataInfo.FErrMsg := '未设置存储过程名称';
    exit;
  end;
  Self.FDataInfo.IsReturnData := False;
  Result := Self.FDataInfo.FConnection.ExecStored(Self);
end;

// 1.先获取一个账套连接,标记成事务账套
function TOneDataSet.LockTran(): boolean;
var
  lOneTran: TOneTran;
begin
  Result := False;
  if Self.FDataInfo.FConnection = nil then
    Self.FDataInfo.FConnection := OneClientConnect.Unit_Connection;
  if Self.FDataInfo.FConnection = nil then
  begin
    Self.FDataInfo.FErrMsg := '数据集Connection=nil';
    exit;
  end;
  if Self.DataInfo.TranID <> '' then
  begin
    Self.FDataInfo.FErrMsg := '数据集有一个事务ID，请先把上个事务ID释放';
    exit;
  end;

  lOneTran := TOneTran.Create;
  try
    lOneTran.ZTCode := Self.DataInfo.ZTCode;
    lOneTran.TranID := Self.DataInfo.TranID;
    lOneTran.MaxSpan := Self.DataInfo.TranSpanSec;
    lOneTran.Msg := '';
    Result := Self.FDataInfo.FConnection.LockTran(lOneTran);
    if not Result then
    begin
      Self.FDataInfo.FErrMsg := lOneTran.Msg;
    end
    else
    begin
      if lOneTran.TranID = '' then
      begin
        Self.FDataInfo.FErrMsg := '返回成功,但事务ID为空,请检查服务端是否正确返回tranID';
      end
      else
      begin
        Self.FDataInfo.FTranID := lOneTran.TranID;
      end;
    end;

  finally
    lOneTran.Free;
  end;
end;

// 2.用完了账套连接,归还账套,如果没归还，很久后，服务端会自动处理归还
function TOneDataSet.UnLockTran(): boolean;
var
  lOneTran: TOneTran;
begin
  Result := False;
  if Self.FDataInfo.FConnection = nil then
    Self.FDataInfo.FConnection := OneClientConnect.Unit_Connection;
  if Self.FDataInfo.FConnection = nil then
  begin
    Self.FDataInfo.FErrMsg := '数据集Connection=nil';
    exit;
  end;
  if Self.DataInfo.TranID = '' then
  begin
    Self.FDataInfo.FErrMsg := '数据集无相关事务ID，请先锁定一个事务';
    exit;
  end;
  lOneTran := TOneTran.Create;
  try
    lOneTran.ZTCode := Self.DataInfo.ZTCode;
    lOneTran.TranID := Self.DataInfo.TranID;
    lOneTran.MaxSpan := Self.DataInfo.TranSpanSec;
    lOneTran.Msg := '';
    Result := Self.FDataInfo.FConnection.UnLockTran(lOneTran);
    if not Result then
    begin
      Self.FDataInfo.FErrMsg := lOneTran.Msg;
    end
    else
    begin
      // 清空事务ID
      Self.DataInfo.TranID := '';
    end;
  finally
    lOneTran.Free;
  end;
end;

// 3.开启账套连接事务
function TOneDataSet.StartTran(): boolean;
var
  lOneTran: TOneTran;
begin
  Result := False;
  if Self.FDataInfo.FConnection = nil then
    Self.FDataInfo.FConnection := OneClientConnect.Unit_Connection;
  if Self.FDataInfo.FConnection = nil then
  begin
    Self.FDataInfo.FErrMsg := '数据集Connection=nil';
    exit;
  end;
  if Self.DataInfo.TranID = '' then
  begin
    Self.FDataInfo.FErrMsg := '数据集无相关事务ID，请先锁定一个事务';
    exit;
  end;
  lOneTran := TOneTran.Create;
  try
    lOneTran.ZTCode := Self.DataInfo.ZTCode;
    lOneTran.TranID := Self.DataInfo.TranID;
    lOneTran.MaxSpan := Self.DataInfo.TranSpanSec;
    lOneTran.Msg := '';
    Result := Self.FDataInfo.FConnection.StartTran(lOneTran);
    if not Result then
    begin
      Self.FDataInfo.FErrMsg := lOneTran.Msg;
    end;
  finally
    lOneTran.Free;
  end;
end;

// 4.提交账套连接事务
function TOneDataSet.CommitTran(): boolean;
var
  lOneTran: TOneTran;
begin
  Result := False;
  if Self.FDataInfo.FConnection = nil then
    Self.FDataInfo.FConnection := OneClientConnect.Unit_Connection;
  if Self.FDataInfo.FConnection = nil then
  begin
    Self.FDataInfo.FErrMsg := '数据集Connection=nil';
    exit;
  end;
  if Self.DataInfo.TranID = '' then
  begin
    Self.FDataInfo.FErrMsg := '数据集无相关事务ID，请先锁定一个事务';
    exit;
  end;
  lOneTran := TOneTran.Create;
  try
    lOneTran.ZTCode := Self.DataInfo.ZTCode;
    lOneTran.TranID := Self.DataInfo.TranID;
    lOneTran.MaxSpan := Self.DataInfo.TranSpanSec;
    lOneTran.Msg := '';
    Result := Self.FDataInfo.FConnection.CommitTran(lOneTran);
    if not Result then
    begin
      Self.FDataInfo.FErrMsg := lOneTran.Msg;
    end;
  finally
    lOneTran.Free;
  end;
end;

// 5.回滚账套连接事务
function TOneDataSet.RollbackTran(): boolean;
var
  lOneTran: TOneTran;
begin
  Result := False;
  if Self.FDataInfo.FConnection = nil then
    Self.FDataInfo.FConnection := OneClientConnect.Unit_Connection;
  if Self.FDataInfo.FConnection = nil then
  begin
    Self.FDataInfo.FErrMsg := '数据集Connection=nil';
    exit;
  end;
  if Self.DataInfo.TranID = '' then
  begin
    Self.FDataInfo.FErrMsg := '数据集无相关事务ID，请先锁定一个事务';
    exit;
  end;
  lOneTran := TOneTran.Create;
  try
    lOneTran.ZTCode := Self.DataInfo.ZTCode;
    lOneTran.TranID := Self.DataInfo.TranID;
    lOneTran.MaxSpan := Self.DataInfo.TranSpanSec;
    lOneTran.Msg := '';
    Result := Self.FDataInfo.FConnection.RollbackTran(lOneTran);
    if not Result then
    begin
      Self.FDataInfo.FErrMsg := lOneTran.Msg;
    end;
  finally
    lOneTran.Free;
  end;
end;
// **********

constructor TOneDataInfo.Create(QDataSet: TOneDataSet);
begin
  inherited Create();
  // 设计时获取相关字段
  FIsDesignGetFields := False;
  // 所属数据集
  FOwnerDataSet := QDataSet;
  FOpenMode := TDataOpenMode.OpenData;
  // 保存数据集模式
  FSaveMode := TDataSaveMode.SaveData;
  FDataReturnMode := TDataReturnMode.dataStream;
  // 分页 每页大小 默认-1 不限制
  FPageSize := -1;
  // 分页 第几页
  FPageIndex := 0;
  // 分页 总共页数
  FPageCount := 0;
  // 分页 总共条数
  FPageTotal := 0;
  // 执行SQL语句，最多影响行数
  FAffectedMaxCount := 0;
  // 执行SQL语句，必需有且几条一定受影响,默认一条
  FAffectedMustCount := 1;
  // 服务端返回影响行数
  FRowsAffected := 0;
  // 是否异步
  FAsynMode := False;
  // 是否返回数据集
  FIsReturnData := False;
  FTranID := '';
  FTranSpanSec := 0;
end;

destructor TOneDataInfo.Destroy;
begin
  inherited Destroy;
end;

function TOneDataInfo.GetConnection: TOneConnection;
begin
  Result := Self.FConnection;
end;

{ ------------------------------------------------------------------------------- }
procedure TOneDataInfo.SetConnection(const AValue: TOneConnection);
begin
  Self.FConnection := AValue;
end;

procedure TOneDataInfo.SetGetFields(value: boolean);
var
  lStream: TMemoryStream;
  lTemp: TFDMemTable;
  i: Integer;
  lFieldDef: TFieldDef;
  lField: TField;
  lListField: TList<TField>;
begin
  Self.FIsDesignGetFields := False;
end;

end.

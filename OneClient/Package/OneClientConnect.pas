unit OneClientConnect;

interface

uses
  system.Classes, OneClientConst, system.StrUtils, system.SysUtils,
  system.Variants, system.IOUtils, system.ZLib, system.DateUtils,
  system.Generics.Collections, Data.DB, system.Net.HttpClientComponent,
  system.Net.HttpClient, system.JSON, Rest.JSON, system.Net.URLClient,
  FireDAC.Comp.Client, FireDAC.Stan.Intf, FireDAC.Stan.StorageBin, FireDAC.Phys.Intf,
  FireDAC.Stan.StorageJSON, FireDAC.Stan.StorageXML, system.TypInfo,
  OneClientResult, OneNeonHelper, OneClientDataInfo, OneStreamString,
  OneSQLCrypto, FireDAC.Stan.Param, system.Zip, system.Math, system.NetEncoding;

const
  HTTP_Status_TokenFail = 498;
  HTTP_URL_TokenName = 'token';
  HTTP_URL_TokenTime = 'time';
  HTTP_URL_TokenSign = 'sign';
  // token相关
  URL_HTTP_HTTPServer_TOKEN_ClientConnect = 'OneServer/Token/ClientConnect';
  URL_HTTP_HTTPServer_TOKEN_ClientConnectPing = 'OneServer/Token/ClientConnectPing';

  URL_HTTP_HTTPServer_TOKEN_ClientDisConnect = 'OneServer/Token/ClientDisConnect';
  URL_HTTP_HTTPServer_TOKEN_ClientPing = 'OneServer/Token/ClientPing';
  URL_HTTP_HTTPServer_TOKEN_GetUUID = 'OneServer/Token/GetUUID';
  URL_HTTP_HTTPServer_TOKEN_GetUUIDs = 'OneServer/Token/GetUUIDs';
  // 操作数据相关
  URL_HTTP_HTTPServer_DATA_OpenDatas = 'OneServer/Data/OpenDatas';
  URL_HTTP_HTTPServer_DATA_SaveDatas = 'OneServer/Data/SaveDatas';
  URL_HTTP_HTTPServer_DATA_ExecStored = 'OneServer/Data/ExecStored';
  URL_HTTP_HTTPServer_DATA_ExecScript = 'OneServer/Data/ExecScript';
  URL_HTTP_HTTPServer_DATA_DownLoadDataFile = 'OneServer/Data/DownLoadDataFile';
  URL_HTTP_HTTPServer_DATA_DelDataFile = 'OneServer/Data/DelDataFile';
  URL_HTTP_HTTPServer_DATA_GetDBMetaInfo = 'OneServer/Data/GetDBMetaInfo';
  // 账套相关
  URL_HTTP_HTTPServer_ZTManage_OneGetZTList = 'OneServer/ZTManage/OneGetZTList';
  // 二层事务先关事件
  URL_HTTP_HTTPServer_DATA_LockTranItem = 'OneServer/Data/LockTranItem';
  URL_HTTP_HTTPServer_DATA_UnLockTranItem = 'OneServer/Data/UnLockTranItem';
  URL_HTTP_HTTPServer_DATA_StartTranItem = 'OneServer/Data/StartTranItem';
  URL_HTTP_HTTPServer_DATA_CommitTranItem = 'OneServer/Data/CommitTranItem';
  URL_HTTP_HTTPServer_DATA_RollbackTranItem = 'OneServer/Data/RollbackTranItem';

  // 文件相关上传下载
  URL_HTTP_HTTPServer_DATA_UploadFile = 'OneServer/VirtualFile/UploadFile';
  URL_HTTP_HTTPServer_DATA_DownloadFile = 'OneServer/VirtualFile/DownloadFile';
  URL_HTTP_HTTPServer_DATA_GetTaskID = 'OneServer/VirtualFile/GetTaskID';
  URL_HTTP_HTTPServer_DATA_UploadChunkFile = 'OneServer/VirtualFile/UploadChunkFile';
  URL_HTTP_HTTPServer_DATA_DownloadChunkFile = 'OneServer/VirtualFile/DownloadChunkFile';
  URL_HTTP_HTTPServer_DATA_DeleteFile = 'OneServer/VirtualFile/DeleteFile';

type
  OneContentType = (ContentTypeText, ContentTypeHtml, ContentTypeStream, ContentTypeZip);

  TOneResultBytes = class
  private
    FIsOK: boolean;
    FBytes: TBytes;
    FContentType: string;
    FIsFile: boolean;
    FErrMsg: string;
  public
    constructor Create();
    destructor Destroy; override;
  public
    property IsOK: boolean read FIsOK write FIsOK;
    property Bytes: TBytes read FBytes write FBytes;
    property ContentType: string read FContentType write FContentType;
    property IsFile: boolean read FIsFile write FIsFile;
    property ErrMsg: string read FErrMsg write FErrMsg;
  end;

  [ComponentPlatformsAttribute(OneAllPlatforms)]
  TOneConnection = class(TComponent)
  private
    // 服务端是否正常
    FConnected: boolean;
    // 客户端IP
    FClientIP: string;
    // 客户端MAC地址
    FClientMac: string;
    //
    FIsHttps: boolean;
    FHTTPHost: string;
    FHTTPPort: Integer;
    // 安全密钥
    FConnectSecretkey: string;
    FToKenID: string;
    FPrivateKey: string;
    // HTTP请求超时设
    FConnectionTimeout: Integer;
    FResponseTimeout: Integer;
    // 全局账套代码，如果数据集有取数据集的,没有取全局的
    FZTCode: string;
    FErrMsg: string;
    FTokenFailCallBack: TNotifyEvent;
  private
    // 组装URL
    function MakeUrl(var QUrl: string; var QErrMsg: string): boolean;
    // 获取最终状态
    function GetZTCode(QDataSetZTCode: string): string;
  public
    procedure SetErrTrueResult(var QErrMsg: string);
    function IsErrTrueResult(QErrMsg: string): boolean;
    //
    constructor Create(AOwner: TComponent); override;
    function DoConnect(qForceConnect: boolean = false): boolean;
    function DoConnectPing(): boolean;
    function DoPing(): boolean;
    procedure DisConnect; overload;
    // 提交bytes返回Bytes
    function PostResultBytes(const QUrl: string; QPostDataBtye: TBytes): TOneResultBytes; overload;
    function PostResultBytes(const QUrl: string; QPostData: RawByteString): TOneResultBytes; overload;
    // 提交字符串，返回JSONValue
    function PostResultJsonValue(const QUrl: string; QPostData: RawByteString; var QErrMsg: string): TJsonValue; overload;
    function PostResultJsonValue(const QUrl: string; QObject: TObject; var QErrMsg: string): TJsonValue; overload;
    // 提交Bytes，返回JSONValue
    function PostResultJsonValue(const QUrl: string; QPostData: TBytes; var QErrMsg: string): TJsonValue; overload;
    function PostResultContent(const QUrl: string; QPostData: string; var QResultData: string): boolean;
    // Get相关事件
    function GetResultBytes(const QUrl: string): TOneResultBytes;
    function GetResultJsonValue(const QUrl: string; var QErrMsg: string): TJsonValue;
    function GetResultContent(const QUrl: string; var QResultData: string): boolean;
  public
    procedure DataSetToOpenData(Sender: TObject; QDataOpen: TOneDataOpen);
    // 跟据OneDataSet打开数据集
    function OpenData(Sender: TObject): boolean;
    // 跟据List<OneDataSet>打开数据集
    function OpenDatas(QObjectList: TList<TObject>; var QErrMsg: string): boolean; overload;
    // 以文件流方式打开数据
    function DownLoadDataFile(QFileID: string; var QErrMsg: string): TMemoryStream;
    // 跟据List<TOneDataOpen(数据集信息收集)>打开数据集
    function OpenDatasPost(QDataOpens: TList<TOneDataOpen>): TOneDataResult; overload;
    //
    function ExecStored(Sender: TObject): boolean;
    function ExecScript(Sender: TObject): boolean;
    function GetDBMetaInfo(Sender: TObject): boolean;
    // 执行存储过程
    function ExecStoredPost(QDataOpen: TOneDataOpen): TOneDataResult;
    // 跟据dataSet保存数据
    function SaveData(Sender: TObject): boolean; overload;
    function ExecDML(QSQL: string; QParamValues: array of Variant; Var QErrMsg: string): boolean; overload;
    function ExecDML(QSQL: string; QParamValues: array of Variant; QZTCode: string; Var QErrMsg: string): boolean; overload;
    // 跟据List<OneDataSet>打开数据集
    function SaveDatas(QObjectList: TList<TObject>; var QErrMsg: string): boolean; overload;
    function SaveDatasPost(QSaveDMLDatas: TList<TOneDataSaveDML>): TOneDataResult; overload;
    // 把返回的结构转化成dataset
    function DataResultToDataSets(DataResult: TOneDataResult; QObjectList: TList<TObject>; QIsSave: boolean; Var QErrMsg: string): boolean;
    function DataResultToDataSet(QDataResult: TOneDataResult; QObject: TObject; Var QErrMsg: string): boolean;

    // 文件上传下载
    function UploadFile(QVirtualInfo: TVirtualInfo): boolean;
    function DownloadFile(QVirtualInfo: TVirtualInfo): boolean;
    function DeleteVirtualFile(QVirtualInfo: TVirtualInfo): boolean;
    function GetTaskID(QVirtualTask: TVirtualTask): boolean;
    function UploadChunkFile(QVirtualTask: TVirtualTask; QUpDownChunkCallBack: EvenUpDownChunkCallBack): boolean;
    function DownloadChunkFile(QVirtualTask: TVirtualTask; QUpDownChunkCallBack: EvenUpDownChunkCallBack): boolean;

    //
    function OneGetZTList(Var QErrMsg: string): TList<TZTInfo>;
    function OneGetZTStringList(Var QErrMsg: string): TStringList;
    // *********二层事务自由控制***********
    /// <summary>
    /// 事务控制第一步:获取账套连接,标识成事务账套
    /// </summary>
    /// <returns>失败返回False,错误信息在ErrMsg属性</returns>
    function LockTran(QTranInfo: TOneTran): boolean;
    // 2.用完了账套连接,归还账套,如果没归还，很久后，服务端会自动处理归还
    function UnLockTran(QTranInfo: TOneTran): boolean;
    // 3.开启账套连接事务
    function StartTran(QTranInfo: TOneTran): boolean;
    // 4.提交账套连接事务
    function CommitTran(QTranInfo: TOneTran): boolean;
    // 5.回滚账套连接事务
    function RollbackTran(QTranInfo: TOneTran): boolean;

    // 获取UUID
    function GetUUID(var QErrMsg: string): int64;
    // 申请多少个UUID
    function GetUUIDs(QCount: Integer; var QErrMsg: string): TList<int64>;
  public
    property onTokenFailCallBack: TNotifyEvent read FTokenFailCallBack write FTokenFailCallBack;
  published
    /// <param name="Connected">DoConnect连接成功的标识,就是一开始确定服务端HTTP连接是否正常</param>
    property Connected: boolean read FConnected write FConnected;
    /// <param name="ClientIP">DoConnect连接或代上此参数,请自行赋值在连接前，可以为空</param>
    property ClientIP: string read FClientIP write FClientIP;
    /// <param name="ClientMac">DoConnect连接或代上此参数,请自行赋值在连接前，可以为空</param>
    property ClientMac: string read FClientMac write FClientMac;
    /// <param name="IsHttps">是否HTTP访问</param>
    property IsHttps: boolean read FIsHttps write FIsHttps;
    /// <param name="HTTPHost">服务端地址或域名</param>
    property HTTPHost: string read FHTTPHost write FHTTPHost;
    /// <param name="HTTPPort">服务端端口</param>
    property HTTPPort: Integer read FHTTPPort write FHTTPPort;
    /// <param name="ConnectSecretkey">服务端连接安全秘钥,DoConnect时需要</param>
    property ConnectSecretkey: string read FConnectSecretkey write FConnectSecretkey;
    /// <param name="TokenID">DoConnect连接成功后返回的tokenID</param>
    property TokenID: string read FToKenID write FToKenID;
    /// <param name="PrivateKey">DoConnect连接成功后返回的PrivateKey</param>
    property PrivateKey: string read FPrivateKey write FPrivateKey;
    /// <param name="ConnectionTimeout">连接超时时间</param>
    property ConnectionTimeout: Integer read FConnectionTimeout write FConnectionTimeout;
    /// <param name="ResponseTimeout">请求结果超时时间</param>
    property ResponseTimeout: Integer read FResponseTimeout write FResponseTimeout;
    /// <param name="ZTCode">连接账套,如果数据集有账套优先取数据集的</param>
    property ZTCode: string read FZTCode write FZTCode;
    /// <param name="ErrMsg">错误信息存放</param>
    property ErrMsg: string read FErrMsg write FErrMsg;
  end;

var
  Unit_Connection: TOneConnection = nil;

implementation

uses OneClientDataSet, OneFileHelper, OneCrypto;

constructor TOneResultBytes.Create();
begin
  inherited Create();
  self.FIsOK := false;
  self.FErrMsg := '';
  self.FContentType := '';
end;

destructor TOneResultBytes.Destroy;
begin
  self.FBytes := nil;
  inherited Destroy;
end;

constructor TOneConnection.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

// 连接服务端获取Token
function TOneConnection.DoConnect(qForceConnect: boolean = false): boolean;
var
  lJsonObj: TJsonObject;
  lResultJsonValue: TJsonValue;
  lErrMsg: string;
  lClientConnect: TClientConnect;
  lServerResult: TActionResult<TClientConnect>;
begin
  Result := false;
  if (not qForceConnect) then
  begin
    if self.FConnected then
    begin
      // 如果已经连接过就不在连接，
      // 除非主动断掉
      self.FErrMsg := '已连接,无需在连接,如需重新连接请执行DisConnect或者强制重新连接DoConnect(true)';
      // 这边还是返回true
      Result := true;
      exit;
    end;
  end;
  lResultJsonValue := nil;
  lServerResult := TActionResult<TClientConnect>.Create;
  lJsonObj := TJsonObject.Create;
  try
    lJsonObj.AddPair('ClientIP', self.ClientIP);
    lJsonObj.AddPair('ClientMac', self.ClientMac);
    lJsonObj.AddPair('ConnectSecretkey', self.ConnectSecretkey);
    lResultJsonValue := self.PostResultJsonValue(URL_HTTP_HTTPServer_TOKEN_ClientConnect, lJsonObj.ToJSON(), lErrMsg);
    if not self.IsErrTrueResult(lErrMsg) then
    begin
      self.FErrMsg := lErrMsg;
      exit;
    end;

    if not OneNeonHelper.JsonToObject(lServerResult, lResultJsonValue, lErrMsg) then
    begin
      self.FErrMsg := '返回的数据解析成TResult<TClientConnect>出错,无法知道结果,数据:' + lResultJsonValue.ToJSON;
      exit;
    end;
    if not lServerResult.ResultSuccess then
    begin
      self.FErrMsg := '服务端消息:' + lServerResult.ResultMsg;
      exit;
    end;
    self.TokenID := lServerResult.ResultData.TokenID;
    self.PrivateKey := lServerResult.ResultData.PrivateKey;
    if self.TokenID = '' then
    begin
      self.FErrMsg := '请求成功但返回的TokenID为空,当前返回的数据:' + lResultJsonValue.ToJSON;
      exit;
    end;
    self.FConnected := true;
    Result := true;
  finally
    lJsonObj.Free;
    if lResultJsonValue <> nil then
    begin
      lResultJsonValue.Free;
    end;
    lServerResult.Free;
  end;
end;

function TOneConnection.DoConnectPing(): boolean;
var
  lJsonObj: TJsonObject;
  lResultJsonValue: TJsonValue;
  lErrMsg: string;
  lClientConnect: TClientConnect;
  lServerResult: TActionResult<string>;
begin
  Result := false;
  lResultJsonValue := nil;
  lServerResult := TActionResult<string>.Create;
  lJsonObj := TJsonObject.Create;
  try
    lJsonObj.AddPair('ConnectSecretkey', self.ConnectSecretkey);
    lResultJsonValue := self.PostResultJsonValue(URL_HTTP_HTTPServer_TOKEN_ClientConnectPing, lJsonObj.ToJSON(), lErrMsg);
    if not self.IsErrTrueResult(lErrMsg) then
    begin
      self.FErrMsg := lErrMsg;
      exit;
    end;

    if not OneNeonHelper.JsonToObject(lServerResult, lResultJsonValue, lErrMsg) then
    begin
      self.FErrMsg := '返回的数据解析成TResult<string>出错,无法知道结果,数据:' + lResultJsonValue.ToJSON;
      exit;
    end;
    if not lServerResult.ResultSuccess then
    begin
      self.FErrMsg := '服务端消息:' + lServerResult.ResultMsg;
      exit;
    end;
    self.FConnected := true;
    Result := true;
  finally
    lJsonObj.Free;
    if lResultJsonValue <> nil then
    begin
      lResultJsonValue.Free;
    end;
    lServerResult.Free;
  end;
end;

function TOneConnection.DoPing(): boolean;
var
  lResultJsonValue: TJsonValue;
  lErrMsg: string;
  lClientConnect: TClientConnect;
  lServerResult: TActionResult<string>;
begin
  Result := false;
  lResultJsonValue := nil;
  lServerResult := TActionResult<string>.Create;
  try
    lResultJsonValue := self.PostResultJsonValue(URL_HTTP_HTTPServer_TOKEN_ClientPing, '', lErrMsg);
    if not self.IsErrTrueResult(lErrMsg) then
    begin
      self.FErrMsg := lErrMsg;
      exit;
    end;

    if not OneNeonHelper.JsonToObject(lServerResult, lResultJsonValue, lErrMsg) then
    begin
      self.FErrMsg := '返回的数据解析成TResult<string>出错,无法知道结果,数据:' + lResultJsonValue.ToJSON;
      exit;
    end;
    if not lServerResult.ResultSuccess then
    begin
      self.FErrMsg := '服务端消息:' + lServerResult.ResultMsg;
      exit;
    end;
    Result := true;
  finally
    self.FConnected := Result;
    if lResultJsonValue <> nil then
    begin
      lResultJsonValue.Free;
    end;
    lServerResult.Free;
  end;
end;

// 断开服务端，本质上是踢除Token，HTTP多是基于短连接
procedure TOneConnection.DisConnect;
var
  lTokenID: string;
  lJsonObj: TJsonObject;
  lResultJsonValue: TJsonValue;
  lErrMsg: string;
  lClientConnect: TClientConnect;
begin
  if self.TokenID = '' then
    exit;
  lTokenID := self.TokenID;
  self.TokenID := '';
  self.PrivateKey := '';
  self.FConnected := false;
  lResultJsonValue := nil;
  lJsonObj := TJsonObject.Create;
  try
    lJsonObj.AddPair('TokenID', lTokenID);
    lResultJsonValue := self.PostResultJsonValue(URL_HTTP_HTTPServer_TOKEN_ClientDisConnect, lJsonObj.ToJSON(), lErrMsg);
  finally
    lJsonObj.Free;
    if lResultJsonValue <> nil then
    begin
      lResultJsonValue.Free;
    end;
  end;
end;

// 调整URL
function TOneConnection.MakeUrl(var QUrl: string; var QErrMsg: string): boolean;
var
  tempStr: string;
  lURI: TURI;
  lTimeStr: string;
  lSign: string;
begin
  Result := false;
  QErrMsg := '';
  tempStr := '';
  if not QUrl.StartsWith('http') then
  begin
    if self.FHTTPHost = '' then
    begin
      QErrMsg := '服务端地址未设置';
      exit;
    end;
    if (self.FHTTPHost.StartsWith('https://')) or (self.FHTTPHost.StartsWith('http://')) then
    begin
      tempStr := self.FHTTPHost;
    end
    else
    begin
      if self.FIsHttps then
      begin
        tempStr := tempStr + 'https://'
      end
      else
      begin
        tempStr := tempStr + 'http://'
      end;
      tempStr := tempStr + self.FHTTPHost;
    end;
    //
    if self.FHTTPPort > 0 then
    begin
      tempStr := tempStr + ':' + self.FHTTPPort.ToString();
    end;
    if QUrl.StartsWith('/') then
    begin
      tempStr := tempStr + QUrl;
    end
    else
    begin
      tempStr := tempStr + '/' + QUrl;
    end;
  end
  else
  begin
    tempStr := QUrl;
  end;
  try
    lURI := TURI.Create(tempStr);
    // 加上Token相关参数以及签名
    if self.FToKenID <> '' then
    begin
      lTimeStr := DateTimeToUnix(now).ToString;
      lURI.AddParameter(HTTP_URL_TokenName, self.FToKenID);
      lURI.AddParameter(HTTP_URL_TokenTime, lTimeStr);
      // 签名
      lSign := self.FToKenID + lTimeStr + self.FPrivateKey;
      lSign := OneCrypto.MD5Endcode(lSign);
      lURI.AddParameter(HTTP_URL_TokenSign, lSign);
    end;
    // 转换回来
    QUrl := lURI.ToString;
    Result := true;
  except
    on e: Exception do
    begin
      QErrMsg := 'URL解析异常,最终组装的URL为:' + tempStr;
    end;
  end;

end;

procedure TOneConnection.SetErrTrueResult(var QErrMsg: string);
begin
  QErrMsg := 'true';
end;

function TOneConnection.IsErrTrueResult(QErrMsg: string): boolean;
begin
  Result := QErrMsg = 'true';
end;

// 获取账套 ，如果数据集有取数据集的,没有取全局的
function TOneConnection.GetZTCode(QDataSetZTCode: string): string;
begin
  if QDataSetZTCode.Trim = '' then
    Result := self.ZTCode
  else
    Result := QDataSetZTCode.Trim;
end;

function TOneConnection.PostResultBytes(const QUrl: string; QPostData: RawByteString): TOneResultBytes;
var
  lPostBytes, lResultBytes: TBytes;
begin
  Result := nil;
  lPostBytes := TEncoding.UTF8.GetBytes(QPostData);
  Result := self.PostResultBytes(QUrl, lPostBytes);
end;

// 提交bytes返回Bytes
function TOneConnection.PostResultBytes(const QUrl: string; QPostDataBtye: TBytes): TOneResultBytes;
var
  lUrl: String;
  LNetHttp: TNetHTTPClient;
  LRequestStream, LResponseStream: TMemoryStream;
  LResponse: IHTTPResponse;
  lZlibBytes, lBytes: TBytes;
  tempA: TArray<string>;
  lErrMsg: string;
  lContentType: string;
begin
  Result := TOneResultBytes.Create;
  lErrMsg := '';
  LResponse := nil;
  lUrl := QUrl;
  if not self.MakeUrl(lUrl, lErrMsg) then
  begin
    Result.ErrMsg := lErrMsg;
    exit;
  end;
  LNetHttp := TNetHTTPClient.Create(nil);
  LRequestStream := TMemoryStream.Create;
  LResponseStream := TMemoryStream.Create;
  try
    try
{$IF CompilerVersion >=31}
      // XE10以上才有这两属性
      LNetHttp.ConnectionTimeout := self.ConnectionTimeout;
      LNetHttp.ResponseTimeout := self.ResponseTimeout;
{$ENDIF}
      // LNetHttp.ContentType := 'text/plain; charset=utf-8';
      LNetHttp.AcceptCharSet := 'utf-8';
      LNetHttp.AcceptEncoding := 'zlib'; // 接受zlib压
      if length(QPostDataBtye) > 1024 then
      begin
        LNetHttp.CustomHeaders['Content-Encoding'] := 'zlib';
        ZCompress(QPostDataBtye, lZlibBytes);
        LRequestStream.Write(lZlibBytes, length(lZlibBytes));
      end
      else
      begin
        LRequestStream.Write(QPostDataBtye, length(QPostDataBtye));
      end;
      LRequestStream.Position := 0;
      LResponse := LNetHttp.Post(lUrl, LRequestStream, LResponseStream);
      if LResponse = nil then
      begin
        Result.ErrMsg := '返回结果错误,结果为nil';
        exit;
      end;
      if LResponse.StatusCode = 200 then
      begin
        // LResponse.Headers
        // 'text/plain;charset=UTF-8'
        Result.ContentType := LResponse.MimeType;
        tempA := Result.ContentType.Split([';']);
        if length(tempA) = 2 then
        begin
          if not tempA[0].StartsWith('charset') then
            Result.ContentType := tempA[0]
          else
            Result.ContentType := tempA[1];
        end;
        Result.IsFile := (LResponse.HeaderValue['OneOutMode'] = 'OUTFILE');
        if not Result.IsFile then
        begin
          if (Result.ContentType.ToLower <> 'application/json') and (Result.ContentType.ToLower <> 'text/plain') then
          begin
            Result.IsFile := true;
          end;
        end;
        // 判断是文件还是不是
        LResponseStream.Position := 0;
        setLength(lBytes, LResponseStream.Size);
        LResponseStream.Read(lBytes, LResponseStream.Size);
        if (LResponse.ContentEncoding = 'zlib') and (not Result.IsFile) then
        begin
          setLength(lZlibBytes, 0);
          ZDecompress(lBytes, lZlibBytes);
          Result.Bytes := lZlibBytes;
        end
        else
        begin
          Result.Bytes := lBytes;
        end;
        Result.IsOK := true;
      end
      else if LResponse.StatusCode = HTTP_Status_TokenFail then
      begin
        if Assigned(self.FTokenFailCallBack) then
        begin
          self.FTokenFailCallBack(self);
          abort;
        end
        else
        begin
          Result.ErrMsg := 'Token验证失败,请重新登陆';
        end;
        exit;
      end
      else
      begin
        LResponseStream.Position := 0;
        setLength(lBytes, LResponseStream.Size);
        LResponseStream.Read(lBytes, LResponseStream.Size);
        Result.ErrMsg := '返回结果错误,错误代码:' + LResponse.StatusCode.ToString + ';错误状态:' + LResponse.StatusText + ';服务端错误:' + TEncoding.UTF8.GetString(lBytes);;
      end;
    except
      on e: Exception do
      begin
        Result.ErrMsg := '请求发生异常:' + e.Message;
      end;
    end;
  finally
    LResponse := nil;
    LRequestStream.Clear;
    LRequestStream.Free;
    LResponseStream.Clear;
    LResponseStream.Free;
    LNetHttp.Free;
  end;
end;

// 提交字符串，返回JSONValue
function TOneConnection.PostResultJsonValue(const QUrl: string; QPostData: RawByteString; var QErrMsg: string): TJsonValue;
var
  lPostBytes: TBytes;
  lResultBytes: TOneResultBytes;
  lJsonValue: TJsonValue;
  QContentType: string;
begin
  Result := nil;
  lJsonValue := nil;
  lResultBytes := nil;
  QErrMsg := '';
  // 数据上传压缩
  lPostBytes := TEncoding.UTF8.GetBytes(QPostData);
  lResultBytes := self.PostResultBytes(QUrl, lPostBytes);
  try
    if not lResultBytes.IsOK then
    begin
      QErrMsg := lResultBytes.ErrMsg;
      exit;
    end;
    try
      lJsonValue := TJsonObject.ParseJSONValue(lResultBytes.Bytes, 0, length(lResultBytes.Bytes));
      if lJsonValue = nil then
      begin
        QErrMsg := '结果转化JSON发生异常:结果为nil,返回信息:' + TEncoding.UTF8.GetString(lResultBytes.Bytes);
        exit;
      end;
      self.SetErrTrueResult(QErrMsg);
      Result := lJsonValue;
    except
      on e: Exception do
      begin
        QErrMsg := '结果转化JSON发生异常:' + e.Message;
      end;
    end;
  finally
    if lResultBytes <> nil then
    begin
      lResultBytes.Free;
    end;
  end;
end;

function TOneConnection.PostResultJsonValue(const QUrl: string; QObject: TObject; var QErrMsg: string): TJsonValue;
var
  lTempJson: TJsonValue;
  lTempStr: string;
  lPostBytes: TBytes;
  lResultBytes: TOneResultBytes;
begin
  Result := nil;
  QErrMsg := '';
  lTempJson := OneNeonHelper.ObjectToJson(QObject, QErrMsg);
  if lTempJson = nil then
    exit;
  try
    lTempStr := lTempJson.ToJSON();
  finally
    lTempJson.Free;
    lTempJson := nil;
  end;
  lPostBytes := TEncoding.UTF8.GetBytes(lTempStr);
  lResultBytes := self.PostResultBytes(QUrl, lPostBytes);
  if not lResultBytes.IsOK then
  begin
    QErrMsg := lResultBytes.ErrMsg;
    exit;
  end;
  try
    try
      lTempJson := TJsonObject.ParseJSONValue(lResultBytes.Bytes, 0, length(lResultBytes.Bytes));
      if lTempJson = nil then
      begin
        QErrMsg := '结果转化JSON发生异常:结果为nil,返回信息:' + TEncoding.UTF8.GetString(lResultBytes.Bytes);
        exit;
      end;
      self.SetErrTrueResult(QErrMsg);
      Result := lTempJson;
    except
      on e: Exception do
      begin
        QErrMsg := '结果转化JSON发生异常:' + e.Message;
      end;
    end;
  finally
    if lResultBytes <> nil then
    begin
      lResultBytes.Free;
    end;
  end;
end;

// 提交Bytes，返回JSONValue
function TOneConnection.PostResultJsonValue(const QUrl: string; QPostData: TBytes; var QErrMsg: string): TJsonValue;
var
  lPostBytes: TBytes;
  lResultBytes: TOneResultBytes;
  lJsonValue: TJsonValue;
begin
  Result := nil;
  lJsonValue := nil;
  lResultBytes := nil;
  QErrMsg := '';
  lResultBytes := self.PostResultBytes(QUrl, lPostBytes);
  if not lResultBytes.IsOK then
  begin
    QErrMsg := lResultBytes.ErrMsg;
    exit;
  end;
  try
    try
      lJsonValue := TJsonObject.ParseJSONValue(lResultBytes.Bytes, 0, length(lResultBytes.Bytes));
      if lJsonValue = nil then
      begin
        QErrMsg := '结果转化JSON发生异常:结果为nil,返回信息:' + TEncoding.UTF8.GetString(lResultBytes.Bytes);
        exit;
      end;
      self.SetErrTrueResult(QErrMsg);
      Result := lJsonValue;
    except
      on e: Exception do
      begin
        QErrMsg := '结果转化JSON发生异常:' + e.Message;
      end;
    end;
  finally
    if lResultBytes <> nil then
    begin
      lResultBytes.Free;
    end;
  end;
end;

function TOneConnection.PostResultContent(const QUrl: string; QPostData: string; var QResultData: string): boolean;
var
  lPostBytes: TBytes;
  lResultBytes: TOneResultBytes;
begin
  Result := false;
  lResultBytes := nil;
  QResultData := '';
  lPostBytes := TEncoding.UTF8.GetBytes(QPostData);
  lResultBytes := self.PostResultBytes(QUrl, lPostBytes);
  try
    if not lResultBytes.IsOK then
    begin
      QResultData := lResultBytes.ErrMsg;
      exit;
    end;
    QResultData := TEncoding.UTF8.GetString(lResultBytes.Bytes);
    Result := true;
  finally
    if lResultBytes <> nil then
    begin
      lResultBytes.Free;
    end;
  end;
end;

function TOneConnection.GetResultBytes(const QUrl: string): TOneResultBytes;
var
  lUrl: String;
  LNetHttp: TNetHTTPClient;
  LResponseStream: TMemoryStream;
  LResponse: IHTTPResponse;
  lBytes: TBytes;
  tempA: TArray<string>;
  lErrMsg: string;
  lContentType: string;
begin
  Result := TOneResultBytes.Create;
  lErrMsg := '';
  LResponse := nil;
  lUrl := QUrl;
  if not self.MakeUrl(lUrl, lErrMsg) then
  begin
    Result.ErrMsg := lErrMsg;
    exit;
  end;
  LNetHttp := TNetHTTPClient.Create(nil);
  LResponseStream := TMemoryStream.Create;
  try
    try
{$IF CompilerVersion >=31}
      // XE10以上才有这两属性
      LNetHttp.ConnectionTimeout := self.ConnectionTimeout;
      LNetHttp.ResponseTimeout := self.ResponseTimeout;
{$ENDIF}
      // LNetHttp.ContentType := 'text/plain; charset=utf-8';
      LNetHttp.AcceptCharSet := 'utf-8';
      LResponse := LNetHttp.Get(lUrl, LResponseStream);
      if LResponse = nil then
      begin
        Result.ErrMsg := '返回结果错误,结果为nil';
        exit;
      end;
      if LResponse.StatusCode = 200 then
      begin
        // LResponse.Headers
        // 'text/plain;charset=UTF-8'
        Result.ContentType := LResponse.MimeType;
        tempA := Result.ContentType.Split([';']);
        if length(tempA) = 2 then
        begin
          if not tempA[0].StartsWith('charset') then
            Result.ContentType := tempA[0]
          else
            Result.ContentType := tempA[1];
        end;
        Result.IsFile := (LResponse.HeaderValue['OneOutMode'] = 'OUTFILE');
        if not Result.IsFile then
        begin
          if (Result.ContentType.ToLower <> 'application/json') and (Result.ContentType.ToLower <> 'text/plain') then
          begin
            Result.IsFile := true;
          end;
        end;
        // 判断是文件还是不是
        LResponseStream.Position := 0;
        setLength(lBytes, LResponseStream.Size);
        LResponseStream.Read(lBytes, LResponseStream.Size);
        Result.Bytes := lBytes;
        Result.IsOK := true;
      end
      else if LResponse.StatusCode = HTTP_Status_TokenFail then
      begin
        if Assigned(self.FTokenFailCallBack) then
        begin
          self.FTokenFailCallBack(self);
        end;
        abort;
      end
      else
      begin
        LResponseStream.Position := 0;
        setLength(lBytes, LResponseStream.Size);
        LResponseStream.Read(lBytes, LResponseStream.Size);
        Result.ErrMsg := '返回结果错误,错误代码:' + LResponse.StatusCode.ToString + ';错误状态:' + LResponse.StatusText + ';服务端错误:' + TEncoding.UTF8.GetString(lBytes);;
      end;
    except
      on e: Exception do
      begin
        Result.ErrMsg := '请求发生异常:' + e.Message;
      end;
    end;
  finally
    LResponse := nil;
    LResponseStream.Clear;
    LResponseStream.Free;
    LNetHttp.Free;
  end;
end;

function TOneConnection.GetResultJsonValue(const QUrl: string; var QErrMsg: string): TJsonValue;
var
  lResultBytes: TBytes;
  lJsonValue: TJsonValue;
  QContentType: string;
  lOneResultBytes: TOneResultBytes;
begin
  Result := nil;
  lJsonValue := nil;
  QErrMsg := '';
  lOneResultBytes := self.GetResultBytes(QUrl);
  try
    if not lOneResultBytes.IsOK then
    begin
      QErrMsg := lOneResultBytes.ErrMsg;
      exit;
    end;
    lResultBytes := lOneResultBytes.Bytes;
    try
      lJsonValue := TJsonObject.ParseJSONValue(lResultBytes, 0, length(lResultBytes));
      if lJsonValue = nil then
      begin
        QErrMsg := '结果转化JSON发生异常:结果为nil,返回信息:' + TEncoding.UTF8.GetString(lResultBytes);;
        exit;
      end;
      self.SetErrTrueResult(QErrMsg);
      Result := lJsonValue;
    except
      on e: Exception do
      begin
        QErrMsg := '结果转化JSON发生异常:' + e.Message;
      end;
    end;
  finally
    lOneResultBytes.Free;
    lResultBytes := nil;
  end;
end;

function TOneConnection.GetResultContent(const QUrl: string; var QResultData: string): boolean;
var
  lOneResultBytes: TOneResultBytes;
begin
  Result := false;
  lOneResultBytes := self.GetResultBytes(QUrl);
  try
    if not lOneResultBytes.IsOK then
    begin
      QResultData := lOneResultBytes.ErrMsg;
      exit;
    end;
    QResultData := TEncoding.UTF8.GetString(lOneResultBytes.Bytes);
    Result := true;
  finally
    lOneResultBytes.Free;
  end;

end;

procedure TOneConnection.DataSetToOpenData(Sender: TObject; QDataOpen: TOneDataOpen);
var
  lOneDataSet: TOneDataSet;
  iParam: Integer;
  lFDParam: TFDParam;
  lOneParam: TOneParam;
begin
  //
  lOneDataSet := TOneDataSet(Sender);
  QDataOpen.TranID := lOneDataSet.DataInfo.TranID;
  QDataOpen.ZTCode := self.GetZTCode(lOneDataSet.DataInfo.ZTCode);
  // SQL进行打乱
  QDataOpen.OpenSQL := OneSQLCrypto.SwapCrypto(lOneDataSet.SQL.Text);
  QDataOpen.SPName := lOneDataSet.DataInfo.StoredProcName;
  QDataOpen.SPIsOutData := lOneDataSet.DataInfo.IsReturnData;
  // 增加相关参数
  for iParam := 0 to lOneDataSet.Params.Count - 1 do
  begin
    lFDParam := lOneDataSet.Params[iParam];
    lOneParam := TOneParam.Create;
    QDataOpen.Params.Add(lOneParam);
    lOneParam.ParamName := lFDParam.Name;
    lOneParam.ParamType := GetEnumName(TypeInfo(TParamType), Ord(lFDParam.ParamType));
    lOneParam.ParamDataType := GetEnumName(TypeInfo(TFieldType), Ord(lFDParam.DataType));
    // 参数赋值
    case lFDParam.DataType of
      ftUnknown:
        begin
          if lFDParam.IsNull then
            lOneParam.ParamValue := const_OneParamIsNull_Value
          else
            lOneParam.ParamValue := varToStr(lFDParam.Value);
        end;
      ftStream:
        begin
          // 转化成Base64
          if lFDParam.IsNull then
            lOneParam.ParamValue := const_OneParamIsNull_Value
          else
            lOneParam.ParamValue := OneStreamString.StreamToBase64Str(lFDParam.AsStream);
        end;
    else
      begin
        if lFDParam.IsNull then
          lOneParam.ParamValue := const_OneParamIsNull_Value
        else
          lOneParam.ParamValue := varToStr(lFDParam.Value);
      end;
    end;
  end;
  QDataOpen.PageSize := lOneDataSet.DataInfo.PageSize;
  QDataOpen.PageIndex := lOneDataSet.DataInfo.PageIndex;
  QDataOpen.PageRefresh := false;
  QDataOpen.DataReturnMode := GetEnumName(TypeInfo(TDataReturnMode), Ord(lOneDataSet.DataInfo.DataReturnMode));;
end;

// 跟据OneDataSet打开数据集
function TOneConnection.OpenData(Sender: TObject): boolean;
var
  QObjectList: TList<TObject>;
  lErrMsg: String;
  lDataSet: TOneDataSet;
begin
  Result := false;
  if not(Sender is TOneDataSet) then
    exit;
  lDataSet := TOneDataSet(Sender);
  QObjectList := TList<TObject>.Create;
  try
    QObjectList.Add(lDataSet);
    Result := self.OpenDatas(QObjectList, lErrMsg);
    lDataSet.DataInfo.ErrMsg := lErrMsg;
  finally
    QObjectList.Clear;
    QObjectList.Free;
  end;
end;

// 跟据List<OneDataSet>打开数据集
function TOneConnection.OpenDatas(QObjectList: TList<TObject>; var QErrMsg: string): boolean;
var
  lOneDataSets: TList<TOneDataSet>;
  lOneDataSet: TOneDataSet;
  lFDParam: TFDParam;
  i, iParam: Integer;
  lDataOpens: TList<TOneDataOpen>;
  lDataOpen: TOneDataOpen;
  lOneParam: TOneParam;
  lDataResult: TOneDataResult;
begin
  Result := false;
  QErrMsg := '';
  if not FConnected then
  begin
    QErrMsg := '未连接,请先执行DoConnect事件.';
    exit;
  end;
  lDataResult := nil;
  lDataOpens := TList<TOneDataOpen>.Create;
  lOneDataSets := TList<TOneDataSet>.Create;
  try
    for i := 0 to QObjectList.Count - 1 do
    begin
      if QObjectList[i] is TOneDataSet then
      begin
        lOneDataSets.Add(TOneDataSet(QObjectList[i]));
      end
      else
      begin
        QErrMsg := '非OneDataSet不可使用';
        exit;
      end;
    end;
    // 校验
    for i := 0 to lOneDataSets.Count - 1 do
    begin
      lOneDataSet := lOneDataSets[i];
      if lOneDataSet.SQL.Text.Trim = '' then
      begin
        QErrMsg := '数据集:' + lOneDataSet.Name + 'SQL为空,无法打开数据';
        exit;
      end;
      if lOneDataSet.DataInfo.OpenMode = TDataOpenMode.localSQL then
      begin
        QErrMsg := '[' + lOneDataSet.Name + ']当数据集打开模式为localSQL时,只支持本地查询';
        exit;
      end;
    end;
    // 组装参数
    for i := 0 to lOneDataSets.Count - 1 do
    begin
      lOneDataSet := lOneDataSets[i];
      lDataOpen := TOneDataOpen.Create;
      lDataOpens.Add(lDataOpen);
      self.DataSetToOpenData(lOneDataSet, lDataOpen);
    end;
    for i := 0 to lOneDataSets.Count - 1 do
    begin
      lOneDataSet := lOneDataSets[i];
    end;
    // 打开数据
    lDataResult := self.OpenDatasPost(lDataOpens);
    if not lDataResult.ResultOK then
    begin
      QErrMsg := lDataResult.ResultMsg;
      exit;
    end;
    // 解析数据到dataSet
    if not self.DataResultToDataSets(lDataResult, QObjectList, false, QErrMsg) then
    begin
      exit;
    end;
    Result := true;
  finally
    for i := 0 to lDataOpens.Count - 1 do
    begin
      lDataOpens[i].Free;
    end;
    lDataOpens.Clear;
    lDataOpens.Free;
    lOneDataSets.Clear;
    lOneDataSets.Free;
    if lDataResult <> nil then
      lDataResult.Free;
  end;

end;

function TOneConnection.OpenDatasPost(QDataOpens: TList<TOneDataOpen>): TOneDataResult;
var
  lPostJsonValue, lResultJsonValue: TJsonValue;
  lErrMsg: string;
begin
  Result := TOneDataResult.Create;
  if not self.FConnected then
  begin
    // 如果已经连接过就不在连接，
    // 除非主动断掉
    Result.ResultMsg := '未连接,请先执行DoConnect事件.';
    exit;
  end;
  if QDataOpens = nil then
  begin
    Result.ResultMsg := '传入的请求数据的信息为nil';
    exit;
  end;
  if QDataOpens.Count = 0 then
  begin
    Result.ResultMsg := '传入的请求数据的信息为0个信息';
    exit;
  end;
  lResultJsonValue := nil;
  lPostJsonValue := nil;
  try
    lPostJsonValue := OneNeonHelper.ObjectToJson(QDataOpens, lErrMsg);
    if lErrMsg <> '' then
    begin
      Result.ResultMsg := lErrMsg;
      exit;
    end;
    lResultJsonValue := self.PostResultJsonValue(URL_HTTP_HTTPServer_DATA_OpenDatas, lPostJsonValue.ToJSON(), lErrMsg);
    if not self.IsErrTrueResult(lErrMsg) then
    begin
      Result.ResultMsg := lErrMsg;
      exit;
    end;
    if not OneNeonHelper.JsonToObject(Result, lResultJsonValue, lErrMsg) then
    begin
      Result.ResultMsg := '返回的数据解析成TOneDataResult出错,无法知道结果,数据:' + lResultJsonValue.ToJSON;
      exit;
    end;
  finally
    if lResultJsonValue <> nil then
    begin
      lResultJsonValue.Free;
    end;
    if lPostJsonValue <> nil then
      lPostJsonValue.Free;
  end;
end;

function TOneConnection.ExecStored(Sender: TObject): boolean;
var
  lDataOpen: TOneDataOpen;
  lDataResult: TOneDataResult;
  lErrMsg: string;
begin
  Result := false;
  if not(Sender is TOneDataSet) then
    exit;
  lDataOpen := TOneDataOpen.Create;
  lDataResult := nil;
  try
    self.DataSetToOpenData(Sender, lDataOpen);
    lDataResult := self.ExecStoredPost(lDataOpen);
    if not lDataResult.ResultOK then
    begin
      TOneDataSet(Sender).DataInfo.ErrMsg := '服务端消息:' + lDataResult.ResultMsg;
      exit;
    end;
    if not self.DataResultToDataSet(lDataResult, Sender, lErrMsg) then
    begin
      TOneDataSet(Sender).DataInfo.ErrMsg := lErrMsg;
      exit;
    end;
    Result := true;
  finally
    lDataOpen.Free;
    if lDataResult <> nil then
      lDataResult.Free;
  end;
end;

function TOneConnection.ExecScript(Sender: TObject): boolean;
var
  lDataSet: TOneDataSet;
  lDataOpen: TOneDataOpen;
  lPostJsonValue, lResultJsonValue: TJsonValue;
  lActionResult: TActionResult<string>;
  lErrMsg: string;
begin
  Result := false;
  if not(Sender is TOneDataSet) then
    exit;
  lDataSet := TOneDataSet(Sender);
  lDataOpen := TOneDataOpen.Create;
  lPostJsonValue := nil;
  lResultJsonValue := nil;
  lActionResult := nil;
  try
    self.DataSetToOpenData(Sender, lDataOpen);
    lPostJsonValue := OneNeonHelper.ObjectToJson(lDataOpen, lErrMsg);
    if lErrMsg <> '' then
    begin
      lDataSet.DataInfo.ErrMsg := lErrMsg;
      exit;
    end;
    lResultJsonValue := self.PostResultJsonValue(URL_HTTP_HTTPServer_DATA_ExecScript, lPostJsonValue.ToJSON(), lErrMsg);
    if not self.IsErrTrueResult(lErrMsg) then
    begin
      lDataSet.DataInfo.ErrMsg := lErrMsg;
      exit;
    end;
    //
    lActionResult := TActionResult<string>.Create;
    if not OneNeonHelper.JsonToObject(lActionResult, lResultJsonValue, lErrMsg) then
    begin
      lDataSet.DataInfo.ErrMsg := '返回的数据解析成TResult<string>出错,无法知道结果,数据:' + lResultJsonValue.ToJSON;
      exit;
    end;
    if not lActionResult.ResultSuccess then
    begin
      lDataSet.DataInfo.ErrMsg := '服务端消息:' + lActionResult.ResultMsg;
      exit;
    end;
    Result := true;
  finally
    lDataOpen.Free;
    if lPostJsonValue <> nil then
      lPostJsonValue.Free;
    if lResultJsonValue <> nil then
      lResultJsonValue.Free;
    if lActionResult <> nil then
      lActionResult.Free;
  end;
end;

function TOneConnection.GetDBMetaInfo(Sender: TObject): boolean;
var
  lPostJsonValue, lResultJsonValue: TJsonValue;
  lDataResult: TOneDataResult;
  lDBMetaInfo: TOneDBMetaInfo;
  lOneDataSet: TOneDataSet;
  lErrMsg: string;
begin
  Result := false;
  if not(Sender is TOneDataSet) then
    exit;
  lOneDataSet := TOneDataSet(Sender);
  lResultJsonValue := nil;
  lPostJsonValue := nil;
  lDataResult := nil;
  lDBMetaInfo := TOneDBMetaInfo.Create;
  try
    lDBMetaInfo.ZTCode := self.GetZTCode(lOneDataSet.DataInfo.ZTCode);
    lDBMetaInfo.MetaInfoKind := GetEnumName(TypeInfo(TFDPhysMetaInfoKind), Ord(lOneDataSet.DataInfo.MetaInfoKind));
    lDBMetaInfo.MetaObjName := lOneDataSet.DataInfo.TableName;
    lPostJsonValue := OneNeonHelper.ObjectToJson(lDBMetaInfo, lErrMsg);
    if lErrMsg <> '' then
    begin
      lOneDataSet.DataInfo.ErrMsg := lErrMsg;
      exit;
    end;
    lResultJsonValue := self.PostResultJsonValue(URL_HTTP_HTTPServer_DATA_GetDBMetaInfo, lPostJsonValue.ToJSON(), lErrMsg);
    if not self.IsErrTrueResult(lErrMsg) then
    begin
      lOneDataSet.DataInfo.ErrMsg := lErrMsg;
      exit;
    end;
    lDataResult := TOneDataResult.Create;
    if not OneNeonHelper.JsonToObject(lDataResult, lResultJsonValue, lErrMsg) then
    begin
      lOneDataSet.DataInfo.ErrMsg := '返回的数据解析成TOneDataResult出错,无法知道结果,数据:' + lResultJsonValue.ToJSON;;
      exit;
    end;
    if not self.DataResultToDataSet(lDataResult, Sender, lErrMsg) then
    begin
      lOneDataSet.DataInfo.ErrMsg := lErrMsg;
      exit;
    end;
    Result := true;
  finally
    lDBMetaInfo.Free;
    if lPostJsonValue <> nil then
      lPostJsonValue.Free;
    if lResultJsonValue <> nil then
      lResultJsonValue.Free;
    if lDataResult <> nil then
      lDataResult.Free;
  end;
end;

function TOneConnection.ExecStoredPost(QDataOpen: TOneDataOpen): TOneDataResult;
var
  lPostJsonValue, lResultJsonValue: TJsonValue;
  lErrMsg: string;
begin
  Result := TOneDataResult.Create;
  if not self.FConnected then
  begin
    // 如果已经连接过就不在连接，
    // 除非主动断掉
    Result.ResultMsg := '未连接,请先执行DoConnect事件.';
    exit;
  end;
  if QDataOpen = nil then
  begin
    Result.ResultMsg := '传入的请求数据的信息为nil';
    exit;
  end;
  lResultJsonValue := nil;
  lPostJsonValue := nil;
  try
    lPostJsonValue := OneNeonHelper.ObjectToJson(QDataOpen, lErrMsg);
    if lErrMsg <> '' then
    begin
      Result.ResultMsg := lErrMsg;
      exit;
    end;
    lResultJsonValue := self.PostResultJsonValue(URL_HTTP_HTTPServer_DATA_ExecStored, lPostJsonValue.ToJSON(), lErrMsg);
    if not self.IsErrTrueResult(lErrMsg) then
    begin
      self.FErrMsg := lErrMsg;
      exit;
    end;
    if not OneNeonHelper.JsonToObject(Result, lResultJsonValue, lErrMsg) then
    begin
      Result.ResultMsg := '返回的数据解析成TOneDataResult出错,无法知道结果,数据:' + lResultJsonValue.ToJSON;;
      exit;
    end;
    if Result.ResultMsg <> '' then
    begin
      Result.ResultMsg := '服务端消息:' + Result.ResultMsg;
    end;
  finally
    if lResultJsonValue <> nil then
    begin
      lResultJsonValue.Free;
    end;
    if lPostJsonValue <> nil then
      lPostJsonValue.Free;
  end;
end;

// ***********保存数据*********************//
function TOneConnection.SaveData(Sender: TObject): boolean;
var
  QObjectList: TList<TObject>;
  lErrMsg: String;
  lDataSet: TOneDataSet;
begin
  Result := false;
  if not(Sender is TOneDataSet) then
    exit;
  lDataSet := TOneDataSet(Sender);
  QObjectList := TList<TObject>.Create;
  try
    QObjectList.Add(lDataSet);
    Result := self.SaveDatas(QObjectList, lErrMsg);
    lDataSet.DataInfo.ErrMsg := lErrMsg;
  finally
    QObjectList.Clear;
    QObjectList.Free;
  end;
end;

function TOneConnection.ExecDML(QSQL: string; QParamValues: array of Variant; Var QErrMsg: string): boolean;
begin
  Result := self.ExecDML(QSQL, QParamValues, '', QErrMsg);
end;

function TOneConnection.ExecDML(QSQL: string; QParamValues: array of Variant; QZTCode: string; Var QErrMsg: string): boolean;
var
  lData: TOneDataSet;
  lList: TList<TObject>;
  i: Integer;
begin
  Result := false;
  QErrMsg := '';
  lList := TList<TObject>.Create;
  lData := TOneDataSet.Create(nil);
  try
    lData.DataInfo.SaveMode := TDataSaveMode.saveDML;
    lData.SQL.Text := QSQL;
    if lData.Params.Count <> length(QParamValues) then
    begin
      QErrMsg := 'SQL语句产生的个数与参数的个数不对等,请检查';
      exit;
    end;
    for i := 0 to lData.Params.Count - 1 do
    begin
      lData.Params[i].Value := QParamValues[i];
    end;
    lList.Add(lData);
    Result := self.SaveDatas(lList, QErrMsg);
  finally
    lData.Free;
    lList.Clear;
    lList.Free;
  end;
end;

function TOneConnection.SaveDatas(QObjectList: TList<TObject>; var QErrMsg: string): boolean;
var
  lOneDataSets: TList<TOneDataSet>;
  lOneDataSet: TOneDataSet;
  lFDParam: TFDParam;
  i, iParam: Integer;
  lSaveDMLs: TList<TOneDataSaveDML>;
  lSaveDML: TOneDataSaveDML;
  lOneParam: TOneParam;
  lDataResult: TOneDataResult;
  lTemStream: TMemoryStream;
begin
  Result := false;
  QErrMsg := '';
  if not FConnected then
  begin
    QErrMsg := '未连接,请先执行DoConnect事件.';
    exit;
  end;
  lDataResult := nil;
  lSaveDMLs := TList<TOneDataSaveDML>.Create;
  lOneDataSets := TList<TOneDataSet>.Create;
  try
    for i := 0 to QObjectList.Count - 1 do
    begin
      if QObjectList[i] is TOneDataSet then
      begin
        lOneDataSets.Add(TOneDataSet(QObjectList[i]));
      end
      else
      begin
        QErrMsg := '非OneDataSet不可使用';
        exit;
      end;
    end;
    // 校验
    for i := 0 to lOneDataSets.Count - 1 do
    begin
      lOneDataSet := lOneDataSets[i];
      if lOneDataSet.DataInfo.SaveMode = TDataSaveMode.SaveData then
      begin
        if not lOneDataSet.Active then
        begin
          QErrMsg := '数据集:' + lOneDataSet.Name + '保存数据模式:数据未运行';
          exit;
        end;
        if lOneDataSet.DataInfo.TableName = '' then
        begin
          QErrMsg := '数据集:' + lOneDataSet.Name + '保存数据模式:表名不可为空';
          exit;
        end;
        if lOneDataSet.DataInfo.PrimaryKey = '' then
        begin
          QErrMsg := '数据集:' + lOneDataSet.Name + '保存数据模式:主键不可为空';
          exit;
        end;
        if (lOneDataSet.State in dsEditModes) then
          lOneDataSet.Post;
      end
      else if lOneDataSet.DataInfo.SaveMode = TDataSaveMode.saveDML then
      begin
        if lOneDataSet.SQL.Text.Trim = '' then
        begin
          QErrMsg := '数据集:' + lOneDataSet.Name + 'DML操作:SQL不可为空';
          exit;
        end;
      end
      else
      begin
        QErrMsg := '数据集:' + lOneDataSet.Name + '未设计的操作模式';
        exit;
      end;
    end;
    // 组装参数
    for i := 0 to lOneDataSets.Count - 1 do
    begin
      lOneDataSet := lOneDataSets[i];
      lSaveDML := TOneDataSaveDML.Create;
      lSaveDMLs.Add(lSaveDML);
      lSaveDML.TranID := lOneDataSet.DataInfo.TranID;
      lSaveDML.ZTCode := self.GetZTCode(lOneDataSet.DataInfo.ZTCode);
      lSaveDML.DataSaveMode := GetEnumName(TypeInfo(TDataSaveMode), Ord(lOneDataSet.DataInfo.SaveMode));
      lSaveDML.TableName := lOneDataSet.DataInfo.TableName;
      lSaveDML.PrimaryKey := lOneDataSet.DataInfo.PrimaryKey;
      lSaveDML.OtherKeys := lOneDataSet.DataInfo.OtherKeys;
      if lOneDataSet.DataInfo.SaveMode = TDataSaveMode.SaveData then
      begin
        lTemStream := TMemoryStream.Create;
        try
          lOneDataSet.ResourceOptions.StoreItems := [siMeta, siDelta];
          lOneDataSet.SaveToStream(lTemStream, sfBinary);
          lSaveDML.SaveData := OneStreamString.StreamToBase64Str(lTemStream);
        finally
          lOneDataSet.ResourceOptions.StoreItems := [sidata, siMeta, siDelta];
          lTemStream.Clear;
          lTemStream.Free;
        end;
      end
      else
      begin

      end;
      lSaveDML.UpdateMode := GetEnumName(TypeInfo(TUpdateMode), Ord(lOneDataSet.UpdateOptions.UpdateMode));;
      lSaveDML.AffectedMaxCount := lOneDataSet.DataInfo.AffectedMaxCount;
      lSaveDML.AffectedMustCount := lOneDataSet.DataInfo.AffectedMustCount;;
      lSaveDML.SaveDataInsertSQL := '';
      lSaveDML.SaveDataUpdateSQL := '';
      lSaveDML.SaveDataDelSQL := '';
      lSaveDML.IsReturnData := lOneDataSet.DataInfo.IsReturnData;
      // lSaveDML.IsAutoID := lOneDataSet.DataInfo.IsAutoID;
      // SQL进行打乱
      lSaveDML.SQL := OneSQLCrypto.SwapCrypto(lOneDataSet.SQL.Text);
      // 增加相关参数
      for iParam := 0 to lOneDataSet.Params.Count - 1 do
      begin
        lFDParam := lOneDataSet.Params[iParam];
        lOneParam := TOneParam.Create;
        lSaveDML.Params.Add(lOneParam);
        lOneParam.ParamName := lFDParam.Name;
        lOneParam.ParamType := GetEnumName(TypeInfo(TParamType), Ord(lFDParam.ParamType));
        lOneParam.ParamDataType := GetEnumName(TypeInfo(TFieldType), Ord(lFDParam.DataType));
        // 参数赋值
        case lFDParam.DataType of
          ftUnknown:
            begin
              if lFDParam.IsNull then
                lOneParam.ParamValue := const_OneParamIsNull_Value
              else
                lOneParam.ParamValue := varToStr(lFDParam.Value);
            end;
          ftStream:
            begin
              // 转化成Base64
              if lFDParam.IsNull then
                lOneParam.ParamValue := const_OneParamIsNull_Value
              else
                lOneParam.ParamValue := OneStreamString.StreamToBase64Str(lFDParam.AsStream);
            end;
        else
          begin
            if lFDParam.IsNull then
              lOneParam.ParamValue := const_OneParamIsNull_Value
            else
              lOneParam.ParamValue := varToStr(lFDParam.Value);
          end;
        end;
      end;
    end;
    for i := 0 to lOneDataSets.Count - 1 do
    begin
      lOneDataSet := lOneDataSets[i];
    end;
    // 打开数据
    lDataResult := self.SaveDatasPost(lSaveDMLs);
    if not lDataResult.ResultOK then
    begin
      QErrMsg := '服务端消息:' + lDataResult.ResultMsg;
      exit;
    end;
    // 解析数据到dataSet
    if not self.DataResultToDataSets(lDataResult, QObjectList, true, QErrMsg) then
      exit;
    Result := true;
  finally
    for i := 0 to lSaveDMLs.Count - 1 do
    begin
      lSaveDMLs[i].Free;
    end;
    lSaveDMLs.Clear;
    lSaveDMLs.Free;
    lOneDataSets.Clear;
    lOneDataSets.Free;
    if lDataResult <> nil then
      lDataResult.Free;
  end;

end;

function TOneConnection.SaveDatasPost(QSaveDMLDatas: TList<TOneDataSaveDML>): TOneDataResult;
var
  lPostJsonValue, lResultJsonValue: TJsonValue;
  lErrMsg: string;
begin
  Result := TOneDataResult.Create;
  if not self.FConnected then
  begin
    // 如果已经连接过就不在连接，
    // 除非主动断掉
    Result.ResultMsg := '未连接,请先执行DoConnect事件.';
    exit;
  end;
  if QSaveDMLDatas = nil then
  begin
    Result.ResultMsg := '传入的保存的数据为nil';
    exit;
  end;
  if QSaveDMLDatas.Count = 0 then
  begin
    Result.ResultMsg := '传入的保存的数据的个数为0';
    exit;
  end;
  lResultJsonValue := nil;
  lPostJsonValue := nil;
  try
    lPostJsonValue := OneNeonHelper.ObjectToJson(QSaveDMLDatas, lErrMsg);
    if lErrMsg <> '' then
    begin
      Result.ResultMsg := lErrMsg;
      exit;
    end;
    lResultJsonValue := self.PostResultJsonValue(URL_HTTP_HTTPServer_DATA_SaveDatas, lPostJsonValue.ToJSON(), lErrMsg);
    if not self.IsErrTrueResult(lErrMsg) then
    begin
      self.FErrMsg := lErrMsg;
      exit;
    end;
    if not OneNeonHelper.JsonToObject(Result, lResultJsonValue, lErrMsg) then
    begin
      Result.ResultMsg := '返回的数据解析成TOneDataResult出错,无法知道结果,数据:' + lResultJsonValue.ToJSON;
      exit;
    end;
    if Result.ResultMsg <> '' then
    begin
      Result.ResultMsg := '服务端消息:' + Result.ResultMsg;
    end;
  finally
    if lResultJsonValue <> nil then
    begin
      lResultJsonValue.Free;
    end;
    if lPostJsonValue <> nil then
      lPostJsonValue.Free;
  end;
end;

function TOneConnection.DataResultToDataSets(DataResult: TOneDataResult; QObjectList: TList<TObject>; QIsSave: boolean; Var QErrMsg: string): boolean;
var
  lOneDataSets: TList<TOneDataSet>;
  lOneDataSet: TOneDataSet;
  tempOneDataSet: TFDMemtable;
  lDataResultItem: TOneDataResultItem;
  i, iField: Integer;
  bCacle: boolean;
  lCacleList: TList<boolean>;
  lTemStream: TMemoryStream;
begin
  Result := false;
  QErrMsg := '';
  lTemStream := nil;
  if DataResult.ResultItems.Count <> QObjectList.Count then
  begin
    QErrMsg := '结果返回数据集个数与请求的个数不相等';
    exit;
  end;
  lCacleList := TList<boolean>.Create;
  lOneDataSets := TList<TOneDataSet>.Create;
  try
    for i := 0 to QObjectList.Count - 1 do
    begin
      lOneDataSets.Add(TOneDataSet(QObjectList[i]));
    end;
    // DisableControls
    for i := 0 to lOneDataSets.Count - 1 do
    begin
      lOneDataSet := lOneDataSets[i];
      lOneDataSet.DisableControls;
    end;
    // 关闭
    for i := 0 to lOneDataSets.Count - 1 do
    begin
      lOneDataSet := lOneDataSets[i];
      bCacle := false;
      for iField := 0 to lOneDataSet.Fields.Count - 1 do
      begin
        if lOneDataSet.Fields[iField].FieldKind in [fkInternalCalc] then
        begin
          bCacle := true;
          break;
        end;
      end;
      lCacleList.Add(bCacle);
      if not QIsSave then
      begin
        if lOneDataSet.Active then
          lOneDataSet.Close;
      end;
    end;
    // 处理
    for i := 0 to DataResult.ResultItems.Count - 1 do
    begin
      lDataResultItem := DataResult.ResultItems[i];
      lOneDataSet := lOneDataSets[i];
      if lDataResultItem.ResultPage then
      begin
        // 分页信息
        lOneDataSet.DataInfo.PageTotal := lDataResultItem.ResultTotal;
        lOneDataSet.DataInfo.PageCount := 0;
        if lOneDataSet.DataInfo.PageSize > 0 then
        begin
          lOneDataSet.DataInfo.PageCount := ceil(lDataResultItem.ResultTotal / lOneDataSet.DataInfo.PageSize);
        end;
      end;
      lOneDataSet.DataInfo.RowsAffected := lDataResultItem.RecordCount;
      if lDataResultItem.ResultDataMode = const_DataReturnMode_Stream then
      begin
        //
        lTemStream := TMemoryStream.Create;
        try
          if not OneStreamString.StreamWriteBase64Str(lTemStream, lDataResultItem.ResultContext) then
          begin
            QErrMsg := '数据集[' + lOneDataSet.Name + ']流写入字符串出错';
            exit;
          end;
          if lCacleList[i] then
          begin
            // 有计算字段的比较特殊加载模式
            tempOneDataSet := TFDMemtable.Create(nil);
            try
              tempOneDataSet.LoadFromStream(lTemStream, sfBinary);
              lOneDataSet.MergeDataSet(tempOneDataSet, dmDataSet, mmNone);
            finally
              tempOneDataSet.Free;
            end;
          end
          else
          begin
            // 无计算字段的整个加载
            lOneDataSet.LoadFromStream(lTemStream, sfBinary);
            // lOneDataSet.FieldDefs.Clear;
          end;
        finally
          lTemStream.Clear;
          lTemStream.Free;
        end;
      end
      else if lDataResultItem.ResultDataMode = const_DataReturnMode_File then
      begin
        // 下载文件，比较适合较大数据加载
        lTemStream := self.DownLoadDataFile(lDataResultItem.ResultContext, QErrMsg);
        try
          if not self.IsErrTrueResult(QErrMsg) then
          begin
            exit;
          end;
          lTemStream.Position := 0;
          if lCacleList[i] then
          begin
            // 有计算字段的比较特殊加载模式
            tempOneDataSet := TFDMemtable.Create(nil);
            try
              tempOneDataSet.LoadFromStream(lTemStream, sfBinary);
              lOneDataSet.MergeDataSet(tempOneDataSet, dmDataSet, mmNone);
            finally
              tempOneDataSet.Free;
            end;
          end
          else
          begin
            // 无计算字段的整个加载
            lOneDataSet.LoadFromStream(lTemStream, sfBinary);
          end;
        finally
          if lTemStream <> nil then
          begin
            lTemStream.Clear;
            lTemStream.Free;
          end;
        end;
      end
      else if lDataResultItem.ResultDataMode = const_DataReturnMode_JSON then
      begin
        // JSON序列化
      end
    end;

    Result := true;
  finally
    for i := 0 to lOneDataSets.Count - 1 do
    begin
      lOneDataSet := lOneDataSets[i];
      if lOneDataSet.Active then
        lOneDataSet.MergeChangeLog;
      lOneDataSet.EnableControls;
    end;
    lOneDataSets.Clear;
    lOneDataSets.Free;
    lCacleList.Clear;
    lCacleList.Free;
  end;
end;

function TOneConnection.DataResultToDataSet(QDataResult: TOneDataResult; QObject: TObject; Var QErrMsg: string): boolean;
var
  lOneDataSet: TOneDataSet;
  tempOneDataSet: TFDMemtable;
  lDataResultItem: TOneDataResultItem;
  i, iParam, iField: Integer;
  bCacle: boolean;
  lTemStream: TMemoryStream;
  iDataCount: Integer;
  isMulite: boolean;
  //
  lDictParam: TDictionary<string, TOneParam>;
  lOneParam: TOneParam;
  lParamName: string;
begin
  Result := false;
  QErrMsg := '';
  lTemStream := nil;
  bCacle := false;
  isMulite := false;
  lOneDataSet := TOneDataSet(QObject);
  lOneDataSet.DisableControls;
  lDictParam := TDictionary<string, TOneParam>.Create;
  try
    if lOneDataSet.Active then
      lOneDataSet.Close;
    // 关闭
    for iField := 0 to lOneDataSet.Fields.Count - 1 do
    begin
      if lOneDataSet.Fields[iField].FieldKind in [fkInternalCalc] then
      begin
        bCacle := true;
        break;
      end;
    end;
    // 参数赋值
    iDataCount := 0;
    for i := 0 to QDataResult.ResultItems.Count - 1 do
    begin
      lDataResultItem := QDataResult.ResultItems[i];
      if lDataResultItem.ResultDataMode = const_DataReturnMode_Stream then
      begin
        iDataCount := iDataCount + 1;
      end
      else if lDataResultItem.ResultDataMode = const_DataReturnMode_File then
      begin
        iDataCount := iDataCount + 1;
      end
      else if lDataResultItem.ResultDataMode = const_DataReturnMode_JSON then
      begin
        iDataCount := iDataCount + 1;
      end;
    end;
    isMulite := iDataCount > 1;
    if isMulite then
    begin
      if lOneDataSet.MultiData = nil then
      begin
        lOneDataSet.MultiData := TList<TFDMemtable>.Create;
      end;
    end;
    if lOneDataSet.MultiData <> nil then
    begin
      for i := 0 to lOneDataSet.MultiData.Count - 1 do
      begin
        lOneDataSet.MultiData[i].Free;
      end;
      lOneDataSet.MultiData.Clear;
    end;
    lOneDataSet.MultiIndex := 0;
    // 处理
    for i := 0 to QDataResult.ResultItems.Count - 1 do
    begin
      lDataResultItem := QDataResult.ResultItems[i];
      if (i = 0) then
      begin
        // 分页信息
        if lDataResultItem.ResultPage then
        BEGIN
          lOneDataSet.DataInfo.PageTotal := lDataResultItem.ResultTotal;
          lOneDataSet.DataInfo.PageCount := 0;
          if lOneDataSet.DataInfo.PageSize > 0 then
          begin
            lOneDataSet.DataInfo.PageCount := ceil(lDataResultItem.ResultTotal / lOneDataSet.DataInfo.PageSize);
          end;
        END;
        // 参数赋值
        if lDataResultItem.ResultParams.Count > 0 then
        begin
          for iParam := 0 to lDataResultItem.ResultParams.Count - 1 do
          begin
            //
            lOneParam := lDataResultItem.ResultParams[iParam];
            lDictParam.Add(lOneParam.ParamName.ToLower, lOneParam);
          end;
          for iParam := 0 to lOneDataSet.Params.Count - 1 do
          begin
            //
            lParamName := lOneDataSet.Params[iParam].Name.ToLower;
            if lDictParam.TryGetValue(lParamName, lOneParam) then
            begin
              lOneDataSet.Params[iParam].Value := lOneParam.ParamValue;
            end
          end;
        end;
      end;
      if lDataResultItem.ResultDataMode = const_DataReturnMode_Stream then
      begin
        //
        lTemStream := TMemoryStream.Create;
        try
          if not OneStreamString.StreamWriteBase64Str(lTemStream, lDataResultItem.ResultContext) then
          begin
            QErrMsg := '数据集[' + lOneDataSet.Name + ']流写入字符串出错';
            exit;
          end;
          lTemStream.Position := 0;
          if isMulite then
          begin
            tempOneDataSet := TFDMemtable.Create(nil);
            tempOneDataSet.LoadFromStream(lTemStream, sfBinary);
            lOneDataSet.MultiData.Add(tempOneDataSet);
          end
          else
          begin
            if bCacle then
            begin
              // 有计算字段的比较特殊加载模式
              tempOneDataSet := TFDMemtable.Create(nil);
              try
                tempOneDataSet.LoadFromStream(lTemStream, sfBinary);
                lOneDataSet.MergeDataSet(tempOneDataSet, dmDataSet, mmNone);
              finally
                tempOneDataSet.Free;
              end;
            end
            else
            begin
              // 无计算字段的整个加载
              lOneDataSet.LoadFromStream(lTemStream, sfBinary);
            end;
          end;
        finally
          lTemStream.Clear;
          lTemStream.Free;
        end;
      end
      else if lDataResultItem.ResultDataMode = const_DataReturnMode_File then
      begin
        // 下载文件，比较适合较大数据加载
        lTemStream := self.DownLoadDataFile(lDataResultItem.ResultContext, QErrMsg);
        try
          if not self.IsErrTrueResult(QErrMsg) then
          begin
            exit;
          end;
          lTemStream.Position := 0;
          if isMulite then
          begin
            tempOneDataSet := TFDMemtable.Create(nil);
            tempOneDataSet.LoadFromStream(lTemStream, sfBinary);
            lOneDataSet.MultiData.Add(tempOneDataSet);
          end
          else
          begin
            if bCacle then
            begin
              // 有计算字段的比较特殊加载模式
              tempOneDataSet := TFDMemtable.Create(nil);
              try
                tempOneDataSet.LoadFromStream(lTemStream, sfBinary);
                lOneDataSet.MergeDataSet(tempOneDataSet, dmDataSet, mmNone);
              finally
                tempOneDataSet.Free;
              end;
            end
            else
            begin
              // 无计算字段的整个加载
              lOneDataSet.LoadFromStream(lTemStream, sfBinary);
            end;
          end;
        finally
          if lTemStream <> nil then
          begin
            lTemStream.Clear;
            lTemStream.Free;
          end;
        end;
      end
      else if lDataResultItem.ResultDataMode = const_DataReturnMode_JSON then
      begin
        // JSON序列化
      end
    end;
    if isMulite then
    begin
      lOneDataSet.MultiIndex := 0;
    end;
    Result := true;
  finally
    lOneDataSet.EnableControls;
    lDictParam.Clear;
    lDictParam.Free;
  end;
end;

function TOneConnection.DownLoadDataFile(QFileID: string; var QErrMsg: string): TMemoryStream;
var
  lZipStream: TMemoryStream;
  lJonsObj: TJsonObject;
  lJsonValue: TJsonValue;
  lOutBytes: TBytes;
  lResultBytes: TOneResultBytes;
  lZip: TZipFile;
begin
  Result := nil;
  lResultBytes := nil;
  lOutBytes := nil;
  lJonsObj := TJsonObject.Create;
  try
    lJonsObj.AddPair('fileID', QFileID);
    lResultBytes := self.PostResultBytes(URL_HTTP_HTTPServer_DATA_DownLoadDataFile, lJonsObj.ToJSON());
    if not lResultBytes.IsOK then
    begin
      QErrMsg := lResultBytes.ErrMsg;
      exit;
    end;
    if not lResultBytes.IsFile then
    begin
      lJsonValue := TJsonObject.ParseJSONValue(lResultBytes.Bytes, 0, length(lResultBytes.Bytes));
      if lJsonValue = nil then
      begin
        QErrMsg := '结果转化JSON发生异常:结果为nil,返回信息:' + TEncoding.UTF8.GetString(lResultBytes.Bytes);
        exit;
      end;
      QErrMsg := TJsonObject(lJsonValue).GetValue('ResultMsg').ToString;
      exit;
    end
    else if (lResultBytes.ContentType.ToLower = 'application/zip') or (lResultBytes.ContentType.ToLower = 'application/octet-stream') then
    begin
      Result := TMemoryStream.Create;
      lZipStream := TMemoryStream.Create;
      lZip := TZipFile.Create;
      try
        lZipStream.Write(lResultBytes.Bytes, 0, length(lResultBytes.Bytes));
        lZipStream.Position := 0;
        lZip.Open(lZipStream, TZipMode.zmRead);
        lZip.Read(0, lOutBytes);
        Result.Write(lOutBytes, 0, length(lOutBytes));
        self.SetErrTrueResult(QErrMsg);
      finally
        lZip.Free;
        lZipStream.Free;
        if not self.IsErrTrueResult(QErrMsg) then
        begin
          Result.Free;
          Result := nil;
        end;
      end;
      exit;
    end
    else
    begin
      QErrMsg := '未解析的头部内型[' + lResultBytes.ContentType + ']';
      exit;
    end;
  finally
    lJonsObj.Free;
    if lResultBytes <> nil then
      lResultBytes.Free;
    lOutBytes := nil;
  end;

end;

// *********二层事务自由控制***********
// 1.先获取一个账套连接,标记成事务账套
function TOneConnection.LockTran(QTranInfo: TOneTran): boolean;
var
  lPostJsonValue, lResultJsonValue: TJsonValue;
  lErrMsg: string;
  lDataResult: TOneDataResult;
begin
  Result := false;
  if not self.FConnected then
  begin
    // 如果已经连接过就不在连接，
    // 除非主动断掉
    QTranInfo.Msg := '未连接,请先执行DoConnect事件.';
    exit;
  end;
  QTranInfo.ZTCode := self.GetZTCode(QTranInfo.ZTCode);
  lResultJsonValue := nil;
  lPostJsonValue := nil;
  lDataResult := TOneDataResult.Create;
  try
    lPostJsonValue := OneNeonHelper.ObjectToJson(QTranInfo, lErrMsg);
    if lErrMsg <> '' then
    begin
      QTranInfo.Msg := lErrMsg;
      exit;
    end;
    lResultJsonValue := self.PostResultJsonValue(URL_HTTP_HTTPServer_DATA_LockTranItem, lPostJsonValue.ToJSON(), lErrMsg);
    if not self.IsErrTrueResult(lErrMsg) then
    begin
      self.FErrMsg := lErrMsg;
      exit;
    end;
    if not OneNeonHelper.JsonToObject(lDataResult, lResultJsonValue, lErrMsg) then
    begin
      QTranInfo.Msg := '返回的数据解析成TOneDataResult出错,无法知道结果,数据:' + lResultJsonValue.ToJSON;
      exit;
    end;
    if lDataResult.ResultMsg <> '' then
    begin
      QTranInfo.Msg := '服务端消息:' + lDataResult.ResultMsg;
    end;
    if lDataResult.ResultOK then
    begin
      QTranInfo.TranID := lDataResult.ResultData;
      Result := true;
    end;
  finally
    if lResultJsonValue <> nil then
    begin
      lResultJsonValue.Free;
    end;
    if lPostJsonValue <> nil then
      lPostJsonValue.Free;
  end;
end;

// 2.用完了账套连接,归还账套,如果没归还，很久后，服务端会自动处理归还
function TOneConnection.UnLockTran(QTranInfo: TOneTran): boolean;
var
  lPostJsonValue, lResultJsonValue: TJsonValue;
  lErrMsg: string;
  lDataResult: TOneDataResult;
begin
  Result := false;
  if not self.FConnected then
  begin
    // 如果已经连接过就不在连接，
    // 除非主动断掉
    QTranInfo.Msg := '未连接,请先执行DoConnect事件.';
    exit;
  end;
  if QTranInfo.TranID = '' then
  begin
    QTranInfo.Msg := '事务TranID为空,请检查.';
    exit;
  end;
  lResultJsonValue := nil;
  lPostJsonValue := nil;
  lDataResult := TOneDataResult.Create;
  try
    lPostJsonValue := OneNeonHelper.ObjectToJson(QTranInfo, lErrMsg);
    if lErrMsg <> '' then
    begin
      QTranInfo.Msg := lErrMsg;
      exit;
    end;
    lResultJsonValue := self.PostResultJsonValue(URL_HTTP_HTTPServer_DATA_UnLockTranItem, lPostJsonValue.ToJSON(), lErrMsg);
    if not self.IsErrTrueResult(lErrMsg) then
    begin
      self.FErrMsg := lErrMsg;
      exit;
    end;
    if not OneNeonHelper.JsonToObject(lDataResult, lResultJsonValue, lErrMsg) then
    begin
      QTranInfo.Msg := '返回的数据解析成TOneDataResult出错,无法知道结果,数据:' + lResultJsonValue.ToJSON;
      exit;
    end;
    if lDataResult.ResultMsg <> '' then
    begin
      QTranInfo.Msg := '服务端消息:' + lDataResult.ResultMsg;
    end;
    if lDataResult.ResultOK then
    begin
      QTranInfo.TranID := lDataResult.ResultData;
      Result := true;
    end;
  finally
    if lResultJsonValue <> nil then
    begin
      lResultJsonValue.Free;
    end;
    if lPostJsonValue <> nil then
      lPostJsonValue.Free;
  end;
end;

// 3.开启账套连接事务
function TOneConnection.StartTran(QTranInfo: TOneTran): boolean;
var
  lPostJsonValue, lResultJsonValue: TJsonValue;
  lErrMsg: string;
  lDataResult: TOneDataResult;
begin
  Result := false;
  if not self.FConnected then
  begin
    // 如果已经连接过就不在连接，
    // 除非主动断掉
    QTranInfo.Msg := '未连接,请先执行DoConnect事件.';
    exit;
  end;
  if QTranInfo.TranID = '' then
  begin
    QTranInfo.Msg := '事务TranID为空,请检查.';
    exit;
  end;
  lResultJsonValue := nil;
  lPostJsonValue := nil;
  lDataResult := TOneDataResult.Create;
  try
    lPostJsonValue := OneNeonHelper.ObjectToJson(QTranInfo, lErrMsg);
    if lErrMsg <> '' then
    begin
      QTranInfo.Msg := lErrMsg;
      exit;
    end;
    lResultJsonValue := self.PostResultJsonValue(URL_HTTP_HTTPServer_DATA_StartTranItem, lPostJsonValue.ToJSON(), lErrMsg);
    if not self.IsErrTrueResult(lErrMsg) then
    begin
      self.FErrMsg := lErrMsg;
      exit;
    end;
    if not OneNeonHelper.JsonToObject(lDataResult, lResultJsonValue, lErrMsg) then
    begin
      QTranInfo.Msg := '返回的数据解析成TOneDataResult出错,无法知道结果,数据:' + lResultJsonValue.ToJSON;
      exit;
    end;
    if lDataResult.ResultMsg <> '' then
    begin
      QTranInfo.Msg := '服务端消息:' + lDataResult.ResultMsg;
    end;
    if lDataResult.ResultOK then
    begin
      QTranInfo.TranID := lDataResult.ResultData;
      Result := true;
    end;
  finally
    if lResultJsonValue <> nil then
    begin
      lResultJsonValue.Free;
    end;
    if lPostJsonValue <> nil then
      lPostJsonValue.Free;
  end;
end;

// 4.提交账套连接事务
function TOneConnection.CommitTran(QTranInfo: TOneTran): boolean;
var
  lPostJsonValue, lResultJsonValue: TJsonValue;
  lErrMsg: string;
  lDataResult: TOneDataResult;
begin
  Result := false;
  if not self.FConnected then
  begin
    // 如果已经连接过就不在连接，
    // 除非主动断掉
    QTranInfo.Msg := '未连接,请先执行DoConnect事件.';
    exit;
  end;
  if QTranInfo.TranID = '' then
  begin
    QTranInfo.Msg := '事务TranID为空,请检查.';
    exit;
  end;
  lResultJsonValue := nil;
  lPostJsonValue := nil;
  lDataResult := TOneDataResult.Create;
  try
    lPostJsonValue := OneNeonHelper.ObjectToJson(QTranInfo, lErrMsg);
    if lErrMsg <> '' then
    begin
      QTranInfo.Msg := lErrMsg;
      exit;
    end;
    lResultJsonValue := self.PostResultJsonValue(URL_HTTP_HTTPServer_DATA_CommitTranItem, lPostJsonValue.ToJSON(), lErrMsg);
    if not self.IsErrTrueResult(lErrMsg) then
    begin
      self.FErrMsg := lErrMsg;
      exit;
    end;
    if not OneNeonHelper.JsonToObject(lDataResult, lResultJsonValue, lErrMsg) then
    begin
      QTranInfo.Msg := '返回的数据解析成TOneDataResult出错,无法知道结果,数据:' + lResultJsonValue.ToJSON;
      exit;
    end;
    if lDataResult.ResultMsg <> '' then
    begin
      QTranInfo.Msg := '服务端消息:' + lDataResult.ResultMsg;
    end;
    if lDataResult.ResultOK then
    begin
      QTranInfo.TranID := lDataResult.ResultData;
      Result := true;
    end;
  finally
    if lResultJsonValue <> nil then
    begin
      lResultJsonValue.Free;
    end;
    if lPostJsonValue <> nil then
      lPostJsonValue.Free;
  end;
end;

// 5.回滚账套连接事务
function TOneConnection.RollbackTran(QTranInfo: TOneTran): boolean;
var
  lPostJsonValue, lResultJsonValue: TJsonValue;
  lErrMsg: string;
  lDataResult: TOneDataResult;
begin
  Result := false;
  if not self.FConnected then
  begin
    // 如果已经连接过就不在连接，
    // 除非主动断掉
    QTranInfo.Msg := '未连接,请先执行DoConnect事件.';
    exit;
  end;
  if QTranInfo.TranID = '' then
  begin
    QTranInfo.Msg := '事务TranID为空,请检查.';
    exit;
  end;
  lResultJsonValue := nil;
  lPostJsonValue := nil;
  lDataResult := TOneDataResult.Create;
  try
    lPostJsonValue := OneNeonHelper.ObjectToJson(QTranInfo, lErrMsg);
    if lErrMsg <> '' then
    begin
      QTranInfo.Msg := lErrMsg;
      exit;
    end;
    lResultJsonValue := self.PostResultJsonValue(URL_HTTP_HTTPServer_DATA_RollbackTranItem, lPostJsonValue.ToJSON(), lErrMsg);
    if not self.IsErrTrueResult(lErrMsg) then
    begin
      self.FErrMsg := lErrMsg;
      exit;
    end;
    if not OneNeonHelper.JsonToObject(lDataResult, lResultJsonValue, lErrMsg) then
    begin
      QTranInfo.Msg := '返回的数据解析成TOneDataResult出错,无法知道结果,数据:' + lResultJsonValue.ToJSON;
      exit;
    end;
    if lDataResult.ResultMsg <> '' then
    begin
      QTranInfo.Msg := '服务端消息:' + lDataResult.ResultMsg;
    end;
    if lDataResult.ResultOK then
    begin
      QTranInfo.TranID := lDataResult.ResultData;
      Result := true;
    end;
  finally
    if lResultJsonValue <> nil then
    begin
      lResultJsonValue.Free;
    end;
    if lPostJsonValue <> nil then
      lPostJsonValue.Free;
  end;
end;

function TOneConnection.UploadFile(QVirtualInfo: TVirtualInfo): boolean;
var
  lPostJsonValue, lResultJsonValue: TJsonValue;
  lResult: TActionResult<string>;
  tempMsg, lFileName: string;
  TempStream: TMemoryStream;
begin
  Result := false;
  QVirtualInfo.ErrMsg := '';
  if not self.FConnected then
  begin
    // 如果已经连接过就不在连接，
    // 除非主动断掉
    QVirtualInfo.ErrMsg := '未连接,请先执行DoConnect事件.';
    exit;
  end;
  if QVirtualInfo.VirtualCode = '' then
  begin
    QVirtualInfo.ErrMsg := '虚拟路径代码[VirtualCode]为空,请检查';
    exit;
  end;
  if QVirtualInfo.LocalFile = '' then
  begin
    QVirtualInfo.ErrMsg := '本地路径文件[LocalFile]为空,请检查';
    exit;
  end;
  // 判断有没有要下载的文件
  if not TPath.HasExtension(QVirtualInfo.LocalFile) then
  begin
    QVirtualInfo.ErrMsg := '本地路径文件[LocalFile]文件扩展名为空,无法确定是路径还是文件';
    exit;
  end;
  if not TFile.Exists(QVirtualInfo.LocalFile) then
  begin
    QVirtualInfo.ErrMsg := '本地路径文件[LocalFile]文件不存在';
    exit;
  end;
  if QVirtualInfo.RemoteFile = '' then
  begin
    QVirtualInfo.ErrMsg := '路径文件[RemoteFile]为空,请检查';
    exit;
  end;
  // 统一用liunx格式
  // win默认文件路径用\,liun是/ 但win支持/
  QVirtualInfo.LocalFile := OneFileHelper.FormatPath(QVirtualInfo.LocalFile);
  QVirtualInfo.RemoteFile := OneFileHelper.FormatPath(QVirtualInfo.RemoteFile);
  if not TPath.HasExtension(QVirtualInfo.RemoteFile) then
  begin
    lFileName := TPath.GetFileName(QVirtualInfo.LocalFile);
    QVirtualInfo.RemoteFile := OneFileHelper.CombinePath(QVirtualInfo.RemoteFile, lFileName);
  end;
  // 开始提交
  TempStream := TMemoryStream.Create;
  try
    TempStream.LoadFromFile(QVirtualInfo.LocalFile);
    TempStream.Position := 0;
    QVirtualInfo.StreamBase64 := OneStreamString.StreamToBase64Str(TempStream);
  finally
    TempStream.Clear;
    TempStream.Free;
  end;
  lResultJsonValue := nil;
  lPostJsonValue := nil;
  lResult := TActionResult<string>.Create;
  try
    lPostJsonValue := OneNeonHelper.ObjectToJson(QVirtualInfo, tempMsg);
    if tempMsg <> '' then
    begin
      QVirtualInfo.ErrMsg := tempMsg;
      exit;
    end;
    lResultJsonValue := self.PostResultJsonValue(URL_HTTP_HTTPServer_DATA_UploadFile, lPostJsonValue.ToJSON(), tempMsg);
    if not self.IsErrTrueResult(tempMsg) then
    begin
      QVirtualInfo.ErrMsg := tempMsg;
      exit;
    end;
    if not OneNeonHelper.JsonToObject(lResult, lResultJsonValue, tempMsg) then
    begin
      QVirtualInfo.ErrMsg := '返回的数据解析成TOneDataResult出错,无法知道结果,数据:' + lResultJsonValue.ToJSON;
      exit;
    end;
    if lResult.ResultMsg <> '' then
    begin
      QVirtualInfo.ErrMsg := '服务端消息:' + lResult.ResultMsg;
    end;
    if lResult.ResultSuccess then
    begin
      // 有可能上传文件名称和最后文件名称不一至
      QVirtualInfo.RemoteFileName := lResult.ResultData;
      Result := true;
    end;
  finally
    if lResultJsonValue <> nil then
    begin
      lResultJsonValue.Free;
    end;
    if lPostJsonValue <> nil then
      lPostJsonValue.Free;
    lResult.Free;
  end;
end;

function TOneConnection.DownloadFile(QVirtualInfo: TVirtualInfo): boolean;
var
  lPostJsonValue, lJsonValue: TJsonValue;
  lResultBytes: TOneResultBytes;
  lResult: TActionResult<string>;
  lInStream: TMemoryStream;
  tempMsg, lLocalPath, lAFileName: string;
begin
  Result := false;
  lResultBytes := nil;
  QVirtualInfo.ErrMsg := '';
  if not self.FConnected then
  begin
    // 如果已经连接过就不在连接，
    // 除非主动断掉
    QVirtualInfo.ErrMsg := '未连接,请先执行DoConnect事件.';
    exit;
  end;
  if QVirtualInfo.VirtualCode = '' then
  begin
    QVirtualInfo.ErrMsg := '虚拟路径代码[VirtualCode]为空,请检查';
    exit;
  end;
  if QVirtualInfo.RemoteFile = '' then
  begin
    QVirtualInfo.ErrMsg := '路径文件[RemoteFile]为空,请检查';
    exit;
  end;
  // 判断有没有要下载的文件
  if not TPath.HasExtension(QVirtualInfo.RemoteFile) then
  begin
    QVirtualInfo.ErrMsg := '路径文件[RemoteFile]文件扩展名为空,无法确定是路径还是文件';
    exit;
  end;
  if QVirtualInfo.LocalFile = '' then
  begin
    self.ErrMsg := '本地路径文件[LocalFile]为空,请检查';
    exit;
  end;

  QVirtualInfo.RemoteFile := OneFileHelper.FormatPath(QVirtualInfo.RemoteFile);
  QVirtualInfo.LocalFile := OneFileHelper.FormatPath(QVirtualInfo.LocalFile);
  lAFileName := TPath.GetFileName(QVirtualInfo.RemoteFile);
  if lAFileName = '' then
  begin
    self.ErrMsg := '远程文件名称为空';
    exit;
  end;
  if not TPath.HasExtension(QVirtualInfo.LocalFile) then
  begin
    // 组装本地文件
    QVirtualInfo.LocalFile := OneFileHelper.CombinePath(QVirtualInfo.LocalFile, lAFileName);
  end;

  lJsonValue := nil;
  lPostJsonValue := nil;
  lResultBytes := nil;
  lResult := TActionResult<string>.Create;
  try
    lPostJsonValue := OneNeonHelper.ObjectToJson(QVirtualInfo, tempMsg);
    if tempMsg <> '' then
    begin
      QVirtualInfo.ErrMsg := tempMsg;
      exit;
    end;
    lResultBytes := self.PostResultBytes(URL_HTTP_HTTPServer_DATA_DownloadFile, lPostJsonValue.ToJSON());
    if not lResultBytes.IsOK then
    begin
      QVirtualInfo.ErrMsg := lResultBytes.ErrMsg;
      exit;
    end;
    lJsonValue := TJsonObject.ParseJSONValue(lResultBytes.Bytes, 0, length(lResultBytes.Bytes));
    if lJsonValue = nil then
    begin
      QVirtualInfo.ErrMsg := '结果转化JSON发生异常:结果为nil,返回信息:' + TEncoding.UTF8.GetString(lResultBytes.Bytes);
      exit;
    end;
    if not OneNeonHelper.JsonToObject(lResult, lJsonValue, tempMsg) then
    begin
      QVirtualInfo.ErrMsg := tempMsg;
      exit;
    end;
    if not lResult.ResultSuccess then
    begin
      QVirtualInfo.ErrMsg := '服务端消息:' + lResult.ResultMsg;
      exit;
    end;
    lInStream := TMemoryStream.Create;
    try
      OneStreamString.StreamWriteBase64Str(lInStream, lResult.ResultData);
      lInStream.Position := 0;
      lLocalPath := TPath.GetDirectoryName(QVirtualInfo.LocalFile);
      if not TDirectory.Exists(lLocalPath) then
      begin
        TDirectory.CreateDirectory(lLocalPath)
      end
      else
      begin
        if TFile.Exists(QVirtualInfo.LocalFile) then
        begin
          TFile.Delete(QVirtualInfo.LocalFile);
        end;
      end;
      lInStream.SaveToFile(QVirtualInfo.LocalFile);
      Result := true;
    finally
      lInStream.Free;
    end;
  finally
    if lJsonValue <> nil then
    begin
      lJsonValue.Free;
    end;
    if lPostJsonValue <> nil then
      lPostJsonValue.Free;
    if lResultBytes <> nil then
      lResultBytes.Free;
    lResult.Free;
  end;
end;

function TOneConnection.DeleteVirtualFile(QVirtualInfo: TVirtualInfo): boolean;
var
  lPostJsonValue, lResultJsonValue: TJsonValue;
  lResult: TActionResult<string>;
  tempMsg: string;
begin
  Result := false;
  QVirtualInfo.ErrMsg := '';
  if not self.FConnected then
  begin
    // 如果已经连接过就不在连接，
    // 除非主动断掉
    QVirtualInfo.ErrMsg := '未连接,请先执行DoConnect事件.';
    exit;
  end;
  // 统一用liunx格式
  // win默认文件路径用\,liun是/ 但win支持/
  QVirtualInfo.LocalFile := OneFileHelper.FormatPath(QVirtualInfo.LocalFile);
  QVirtualInfo.RemoteFile := OneFileHelper.FormatPath(QVirtualInfo.RemoteFile);
  if QVirtualInfo.VirtualCode = '' then
  begin
    QVirtualInfo.ErrMsg := '虚拟路径代码[VirtualCode]为空,请检查';
    exit;
  end;
  // 判断有没有要下载的文件
  if not TPath.HasExtension(QVirtualInfo.RemoteFile) then
  begin
    QVirtualInfo.ErrMsg := '要删除的文件[RemoteFile]需指定要删除的文件路径及文件名称';
    exit;
  end;

  lResultJsonValue := nil;
  lPostJsonValue := nil;
  lResult := TActionResult<string>.Create;
  try
    lPostJsonValue := OneNeonHelper.ObjectToJson(QVirtualInfo, tempMsg);
    if tempMsg <> '' then
    begin
      QVirtualInfo.ErrMsg := tempMsg;
      exit;
    end;
    lResultJsonValue := self.PostResultJsonValue(URL_HTTP_HTTPServer_DATA_DeleteFile, lPostJsonValue.ToJSON(), tempMsg);
    if not self.IsErrTrueResult(tempMsg) then
    begin
      QVirtualInfo.ErrMsg := tempMsg;
      exit;
    end;
    if not OneNeonHelper.JsonToObject(lResult, lResultJsonValue, tempMsg) then
    begin
      QVirtualInfo.ErrMsg := '返回的数据解析成TOneDataResult出错,无法知道结果,数据:' + lResultJsonValue.ToJSON;
      exit;
    end;
    if lResult.ResultMsg <> '' then
    begin
      QVirtualInfo.ErrMsg := '服务端消息:' + lResult.ResultMsg;
    end;
    if lResult.ResultSuccess then
    begin
      Result := true;
    end;
  finally
    if lResultJsonValue <> nil then
    begin
      lResultJsonValue.Free;
    end;
    if lPostJsonValue <> nil then
      lPostJsonValue.Free;
    lResult.Free;
  end;
end;

function TOneConnection.GetTaskID(QVirtualTask: TVirtualTask): boolean;
var
  lPostJsonValue, lResultJsonValue: TJsonValue;
  lResult: TActionResult<TVirtualTask>;
  tempMsg: string;
  lFileStream: TFileStream;
  lLocalPath, lFileName: string;
begin
  Result := false;
  QVirtualTask.ErrMsg := '';
  QVirtualTask.TaskID := '';
  if not self.FConnected then
  begin
    // 如果已经连接过就不在连接，
    // 除非主动断掉
    QVirtualTask.ErrMsg := '未连接,请先执行DoConnect事件.';
    exit;
  end;
  if QVirtualTask.FileChunSize <= 0 then
    QVirtualTask.FileChunSize := 1024 * 1024 * 1;
  if (QVirtualTask.UpDownMode <> '上传') and (QVirtualTask.UpDownMode <> '下载') then
  begin
    QVirtualTask.ErrMsg := '文件模式[UpDownMode]只能是上传或下载';
    exit;
  end;
  if QVirtualTask.VirtualCode = '' then
  begin
    QVirtualTask.ErrMsg := '虚拟路径代码[VirtualCode]为空,请检查';
    exit;
  end;
  if QVirtualTask.LocalFile = '' then
  begin
    QVirtualTask.ErrMsg := '本地文件[LocateFile]为空,请检查';
    exit;
  end;
  if (QVirtualTask.UpDownMode = '上传') then
  begin
    if not TPath.HasExtension(QVirtualTask.LocalFile) then
    begin
      QVirtualTask.ErrMsg := '上传本地文件[LocateFile]不能只是路径,无法确定要上传的文件';
      exit;
    end;
    if not TFile.Exists(QVirtualTask.LocalFile) then
    begin
      QVirtualTask.ErrMsg := '不存在本地文件[' + QVirtualTask.LocalFile + '],请检查';
      exit;
    end;
    // 读取文件大小
    lFileStream := TFileStream.Create(QVirtualTask.LocalFile, fmopenRead);
    try
      QVirtualTask.FileTotalSize := lFileStream.Size;
    finally
      lFileStream.Free;
    end;
  end;

  if QVirtualTask.RemoteFile = '' then
  begin
    QVirtualTask.RemoteFile := TPath.GetFileName(QVirtualTask.LocalFile);
  end;
  if TPath.DriveExists(QVirtualTask.RemoteFile) then
  begin
    QVirtualTask.ErrMsg := '路径文件[RemoteFile]不可包含驱动，只能是路径/xxx/xxxx/xx';
    exit;
  end;
  if not TPath.HasExtension(QVirtualTask.RemoteFile) then
  begin
    if (QVirtualTask.UpDownMode = '上传') then
    begin
      // 把RemoteFile组装上文件名称，从本地 LocateFile
      lFileName := TPath.GetFileName(QVirtualTask.LocalFile);
      QVirtualTask.RemoteFile := OneFileHelper.CombinePath(QVirtualTask.RemoteFile, lFileName);
    end
    else if (QVirtualTask.UpDownMode = '下载') then
    begin
      //
      QVirtualTask.ErrMsg := '下载路径文件[RemoteFile]不包括文件名,无法知道要下载的文件';
      exit;
    end;
  end;
  //
  if (QVirtualTask.UpDownMode = '下载') then
  begin
    if not TPath.HasExtension(QVirtualTask.LocalFile) then
    begin
      lFileName := TPath.GetFileName(QVirtualTask.RemoteFile);
      QVirtualTask.LocalFile := OneFileHelper.CombinePath(QVirtualTask.LocalFile, lFileName);
    end;
    lLocalPath := TPath.GetDirectoryName(QVirtualTask.LocalFile);
    if not TDirectory.Exists(lLocalPath) then
    begin
      TDirectory.CreateDirectory(lLocalPath)
    end
    else
    begin
      // 删除老的文件
      if TFile.Exists(QVirtualTask.LocalFile) then
      begin
        TFile.Delete(QVirtualTask.LocalFile);
      end;
    end;
  end;

  lResultJsonValue := nil;
  lPostJsonValue := nil;
  lResult := TActionResult<TVirtualTask>.Create;
  lResult.ResultData := TVirtualTask.Create;
  try
    lPostJsonValue := OneNeonHelper.ObjectToJson(QVirtualTask, tempMsg);
    if tempMsg <> '' then
    begin
      QVirtualTask.ErrMsg := tempMsg;
      exit;
    end;
    lResultJsonValue := self.PostResultJsonValue(URL_HTTP_HTTPServer_DATA_GetTaskID, lPostJsonValue.ToJSON(), tempMsg);
    if not self.IsErrTrueResult(tempMsg) then
    begin
      QVirtualTask.ErrMsg := tempMsg;
      exit;
    end;
    if not OneNeonHelper.JsonToObject(lResult, lResultJsonValue, tempMsg) then
    begin
      QVirtualTask.ErrMsg := '返回的数据解析成TResult<TVirtualTask>出错,无法知道结果,数据:' + lResultJsonValue.ToJSON;
      exit;
    end;
    if lResult.ResultMsg <> '' then
    begin
      QVirtualTask.ErrMsg := '服务端消息:' + lResult.ResultMsg;
    end;
    if lResult.ResultSuccess then
    begin
      // 赋值服务端一些相关属性
      QVirtualTask.TaskID := lResult.ResultData.TaskID;
      QVirtualTask.FileTotalSize := lResult.ResultData.FileTotalSize;
      QVirtualTask.FileName := lResult.ResultData.FileName;
      QVirtualTask.NewFileName := lResult.ResultData.NewFileName;
      Result := true;
    end;
  finally
    if lResultJsonValue <> nil then
    begin
      lResultJsonValue.Free;
    end;
    if lPostJsonValue <> nil then
      lPostJsonValue.Free;
    lResult.ResultData.Free;
    lResult.Free;
  end;
end;

function TOneConnection.UploadChunkFile(QVirtualTask: TVirtualTask; QUpDownChunkCallBack: EvenUpDownChunkCallBack): boolean;
var
  lFileStream: TFileStream;
  tempMsg: string;
  lPostJsonValue, lResultJsonValue: TJsonValue;
  lResult: TActionResult<string>;
  lBytes: TBytes;
  iChunSize: int64;
  isEnd: boolean;
begin
  Result := false;
  QVirtualTask.UpDownMode := '上传';
  if QVirtualTask.TaskID = '' then
  begin
    if not self.GetTaskID(QVirtualTask) then
    begin
      if Assigned(QUpDownChunkCallBack) then
      begin
        QUpDownChunkCallBack(emUpDownMode.UpLoad, emUpDownChunkStatus.upDownErr, 0, 0, QVirtualTask.ErrMsg);
      end;
      exit;
    end;
    QVirtualTask.FilePosition := 0;
  end
  else
  begin
    // 不为空情况下可能是续传
  end;
  // 开始读取文件上传
  lFileStream := TFileStream.Create(QVirtualTask.LocalFile, fmopenRead);
  lResult := TActionResult<string>.Create;
  try
    QVirtualTask.FileTotalSize := lFileStream.Size;
    if Assigned(QUpDownChunkCallBack) then
    begin
      QUpDownChunkCallBack(emUpDownMode.UpLoad, emUpDownChunkStatus.upDownStart, QVirtualTask.FileTotalSize, 0, '开始上传');
    end;
    while QVirtualTask.FilePosition < QVirtualTask.FileTotalSize do
    begin
      lResult.ResultSuccess := false;
      lResult.ResultMsg := '';
      lResult.ResultCode := '';
      lResult.ResultData := '';
      // 读取本次上传的数据
      lFileStream.Position := QVirtualTask.FilePosition;
      iChunSize := QVirtualTask.FileChunSize;
      if lFileStream.Position + iChunSize > QVirtualTask.FileTotalSize then
      begin
        iChunSize := QVirtualTask.FileTotalSize - lFileStream.Position;
      end;
      setLength(lBytes, iChunSize);
      lFileStream.Read(lBytes, iChunSize);
      QVirtualTask.StreamBase64 := TNetEncoding.Base64.EncodeBytesToString(lBytes);
      // 开始上传数据
      lPostJsonValue := nil;
      lResultJsonValue := nil;
      try
        lPostJsonValue := OneNeonHelper.ObjectToJson(QVirtualTask, tempMsg);
        if tempMsg <> '' then
        begin
          QVirtualTask.ErrMsg := tempMsg;
          exit;
        end;
        //
        lResultJsonValue := self.PostResultJsonValue(URL_HTTP_HTTPServer_DATA_UploadChunkFile, lPostJsonValue.ToJSON(), tempMsg);
        if not self.IsErrTrueResult(tempMsg) then
        begin
          QVirtualTask.ErrMsg := tempMsg;
          exit;
        end;

        if not OneNeonHelper.JsonToObject(lResult, lResultJsonValue, tempMsg) then
        begin
          QVirtualTask.ErrMsg := '返回的数据解析成TResult<string>出错,无法知道结果,数据:' + lResultJsonValue.ToJSON;
          exit;
        end;
        if lResult.ResultMsg <> '' then
        begin
          QVirtualTask.ErrMsg := '服务端消息:' + lResult.ResultMsg;
        end;
        if not lResult.ResultSuccess then
        begin
          exit;
        end;
      finally
        if lPostJsonValue <> nil then
          lPostJsonValue.Free;
        if lResultJsonValue <> nil then
          lResultJsonValue.Free;
        QVirtualTask.StreamBase64 := '';
        // 读取位置加上去
        if lResult.ResultSuccess then
          QVirtualTask.FilePosition := QVirtualTask.FilePosition + iChunSize;
        if Assigned(QUpDownChunkCallBack) then
        begin
          if lResult.ResultSuccess then
          begin
            isEnd := QVirtualTask.FilePosition >= QVirtualTask.FileTotalSize;
            if isEnd then
            begin
              QUpDownChunkCallBack(emUpDownMode.UpLoad, emUpDownChunkStatus.upDownEnd, QVirtualTask.FileTotalSize, QVirtualTask.FilePosition, QVirtualTask.ErrMsg);
            end
            else
            begin
              QUpDownChunkCallBack(emUpDownMode.UpLoad, emUpDownChunkStatus.upDownProcess, QVirtualTask.FileTotalSize, QVirtualTask.FilePosition, QVirtualTask.ErrMsg);
            end;
          end
          else
          begin
            QUpDownChunkCallBack(emUpDownMode.UpLoad, emUpDownChunkStatus.upDownErr, QVirtualTask.FileTotalSize, QVirtualTask.FilePosition, QVirtualTask.ErrMsg);
          end;
        end;
      end;

    end;
    Result := true;
  finally
    lFileStream.Free;
    lResult.Free;
  end;
end;

function TOneConnection.DownloadChunkFile(QVirtualTask: TVirtualTask; QUpDownChunkCallBack: EvenUpDownChunkCallBack): boolean;
var
  lFileStream: TFileStream;
  tempMsg: string;
  lPostJsonValue, lResultJsonValue: TJsonValue;
  lResult: TActionResult<string>;
  lBytes: TBytes;
  iChunSize: int64;
  lInStream: TMemoryStream;
  isEnd: boolean;
begin
  Result := false;
  QVirtualTask.UpDownMode := '下载';
  if QVirtualTask.TaskID = '' then
  begin
    if not self.GetTaskID(QVirtualTask) then
    begin
      if Assigned(QUpDownChunkCallBack) then
      begin
        QUpDownChunkCallBack(emUpDownMode.DownLoad, emUpDownChunkStatus.upDownErr, 0, 0, QVirtualTask.ErrMsg);
      end;
      exit;
    end;
    QVirtualTask.FilePosition := 0;
  end
  else
  begin
    // 续下载
  end;
  // 开始读取文件上传
  lFileStream := TFileStream.Create(QVirtualTask.LocalFile, fmCreate or fmOpenReadWrite);
  lResult := TActionResult<string>.Create;
  try
    if Assigned(QUpDownChunkCallBack) then
    begin
      QUpDownChunkCallBack(emUpDownMode.DownLoad, emUpDownChunkStatus.upDownStart, QVirtualTask.FileTotalSize, 0, '开始下载');
    end;
    while QVirtualTask.FilePosition < QVirtualTask.FileTotalSize do
    begin
      lResult.ResultSuccess := false;
      lResult.ResultMsg := '';
      lResult.ResultCode := '';
      lResult.ResultData := '';
      // 开始上传数据
      lPostJsonValue := nil;
      lResultJsonValue := nil;
      lInStream := TMemoryStream.Create;
      try
        lPostJsonValue := OneNeonHelper.ObjectToJson(QVirtualTask, tempMsg);
        if tempMsg <> '' then
        begin
          QVirtualTask.ErrMsg := tempMsg;
          exit;
        end;
        //
        lResultJsonValue := self.PostResultJsonValue(URL_HTTP_HTTPServer_DATA_DownloadChunkFile, lPostJsonValue.ToJSON(), tempMsg);
        if not self.IsErrTrueResult(tempMsg) then
        begin
          QVirtualTask.ErrMsg := tempMsg;
          exit;
        end;

        if not OneNeonHelper.JsonToObject(lResult, lResultJsonValue, tempMsg) then
        begin
          QVirtualTask.ErrMsg := '返回的数据解析成TResult<string>出错,无法知道结果,数据:' + lResultJsonValue.ToJSON;
          exit;
        end;
        if lResult.ResultMsg <> '' then
        begin
          QVirtualTask.ErrMsg := '服务端消息:' + lResult.ResultMsg;
        end;
        if not lResult.ResultSuccess then
        begin
          exit;
        end;
        // 写数据
        OneStreamString.StreamWriteBase64Str(lInStream, lResult.ResultData);
        lInStream.Position := 0;
        setLength(lBytes, lInStream.Size);
        lInStream.Read(lBytes, lInStream.Size);
        lFileStream.Position := QVirtualTask.FilePosition;
        lFileStream.Write(lBytes, lInStream.Size);
      finally
        if lPostJsonValue <> nil then
          lPostJsonValue.Free;
        if lResultJsonValue <> nil then
          lResultJsonValue.Free;
        lInStream.Free;
        if lResult.ResultSuccess then
          QVirtualTask.FilePosition := QVirtualTask.FilePosition + QVirtualTask.FileChunSize;
        if Assigned(QUpDownChunkCallBack) then
        begin
          if lResult.ResultSuccess then
          begin
            isEnd := QVirtualTask.FilePosition >= QVirtualTask.FileTotalSize;
            if isEnd then
              QUpDownChunkCallBack(emUpDownMode.DownLoad, emUpDownChunkStatus.upDownEnd, QVirtualTask.FileTotalSize, QVirtualTask.FilePosition, QVirtualTask.ErrMsg)
            else
              QUpDownChunkCallBack(emUpDownMode.DownLoad, emUpDownChunkStatus.upDownProcess, QVirtualTask.FileTotalSize, QVirtualTask.FilePosition, QVirtualTask.ErrMsg);
          end
          else
          begin
            QUpDownChunkCallBack(emUpDownMode.DownLoad, emUpDownChunkStatus.upDownErr, QVirtualTask.FileTotalSize, QVirtualTask.FilePosition, QVirtualTask.ErrMsg);
          end;
        end;
      end;

    end;
    Result := true;
  finally
    lFileStream.Free;
    lResult.Free;
  end;
end;

function TOneConnection.OneGetZTList(Var QErrMsg: string): TList<TZTInfo>;
var
  lJsonValue: TJsonValue;
  lServerResult: TActionResult<TList<TZTInfo>>;
begin
  Result := nil;
  lJsonValue := nil;
  QErrMsg := '';
  lJsonValue := self.GetResultJsonValue(URL_HTTP_HTTPServer_ZTManage_OneGetZTList, QErrMsg);
  if lJsonValue = nil then
  begin
    exit;
  end;
  lServerResult := TActionResult < TList < TZTInfo >>.Create;
  try
    lServerResult.ResultData := TList<TZTInfo>.Create;
    if not OneNeonHelper.JsonToObject(lServerResult, lJsonValue, QErrMsg) then
    begin
      self.FErrMsg := '返回的数据解析成TActionResult<TList<TZTInfo>>出错,无法知道结果,数据:' + lJsonValue.ToJSON;
      exit;
    end;
    if not lServerResult.ResultSuccess then
    begin
      self.FErrMsg := '服务端消息:' + lServerResult.ResultMsg;
      exit;
    end;
    Result := lServerResult.ResultData;
  finally
    lServerResult.Free;
    if lJsonValue <> nil then
      lJsonValue.Free;
  end;
end;

function TOneConnection.OneGetZTStringList(Var QErrMsg: string): TStringList;
var
  lList: TList<TZTInfo>;
  i: Integer;
begin
  Result := nil;
  lList := nil;
  lList := self.OneGetZTList(QErrMsg);
  try
    if lList = nil then
      exit;
    Result := TStringList.Create;
    for i := 0 to lList.Count - 1 do
    begin
      Result.Add(lList[i].ZTCode + '=' + lList[i].ZTCaption);
    end;
  finally
    if lList <> nil then
    begin
      for i := 0 to lList.Count - 1 do
      begin
        lList[i].Free;
      end;
      lList.Clear;
      lList.Free;
    end;
  end;
end;

function TOneConnection.GetUUID(var QErrMsg: string): int64;
var
  lJsonObj: TJsonObject;
  lResultJsonValue: TJsonValue;
  lErrMsg: string;
  lClientConnect: TClientConnect;
  lServerResult: TActionResult<int64>;
  IsOK: boolean;
begin
  Result := -1;
  IsOK := false;
  QErrMsg := '';
  lResultJsonValue := nil;
  lServerResult := TActionResult<int64>.Create;
  lJsonObj := TJsonObject.Create;
  try
    lResultJsonValue := self.PostResultJsonValue(URL_HTTP_HTTPServer_TOKEN_GetUUID, '', lErrMsg);
    if not self.IsErrTrueResult(lErrMsg) then
    begin
      QErrMsg := lErrMsg;
      exit;
    end;
    lServerResult.ResultData := -1;
    if not OneNeonHelper.JsonToObject(lServerResult, lResultJsonValue, lErrMsg) then
    begin
      QErrMsg := '返回的数据解析成TResult<TClientConnect>出错,无法知道结果,数据:' + lResultJsonValue.ToJSON;
      exit;
    end;
    if not lServerResult.ResultSuccess then
    begin
      QErrMsg := '服务端消息:' + lServerResult.ResultMsg;
      exit;
    end;
    Result := lServerResult.ResultData;
    IsOK := true;
  finally
    if not IsOK then
    begin
      Result := -1;
    end;
    lJsonObj.Free;
    if lResultJsonValue <> nil then
    begin
      lResultJsonValue.Free;
    end;
    lServerResult.Free;
  end;
end;

function TOneConnection.GetUUIDs(QCount: Integer; var QErrMsg: string): TList<int64>;
var
  lJsonObj: TJsonObject;
  lResultJsonValue: TJsonValue;
  lErrMsg: string;
  lServerResult: TActionResult<TList<int64>>;
  IsOK: boolean;
begin
  Result := TList<int64>.Create;
  IsOK := false;
  QErrMsg := '';
  lResultJsonValue := nil;
  lServerResult := TActionResult < TList < int64 >>.Create;
  lJsonObj := TJsonObject.Create;
  try
    if QCount <= 0 then
      QCount := 100;
    lJsonObj.AddPair('QCount', TJSONNumber.Create(QCount));
    lResultJsonValue := self.PostResultJsonValue(URL_HTTP_HTTPServer_TOKEN_GetUUIDs, lJsonObj.ToJSON(), lErrMsg);
    if not self.IsErrTrueResult(lErrMsg) then
    begin
      QErrMsg := lErrMsg;
      exit;
    end;
    lServerResult.ResultData := Result;
    if not OneNeonHelper.JsonToObject(lServerResult, lResultJsonValue, lErrMsg) then
    begin
      QErrMsg := '返回的数据解析成TResult<TClientConnect>出错,无法知道结果,数据:' + lResultJsonValue.ToJSON;
      exit;
    end;
    if not lServerResult.ResultSuccess then
    begin
      QErrMsg := '服务端消息:' + lServerResult.ResultMsg;
      exit;
    end;
    IsOK := true;
  finally
    if not IsOK then
    begin
      Result.Free;
      Result := nil;
    end;
    lJsonObj.Free;
    if lResultJsonValue <> nil then
    begin
      lResultJsonValue.Free;
    end;
    lServerResult.ResultData := nil;
    lServerResult.Free;
  end;
end;

end.

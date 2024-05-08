unit OneClientConnect;

interface

uses
  system.Classes, OneClientConst, system.StrUtils, system.SysUtils,
  system.Variants, system.IOUtils, system.ZLib, system.DateUtils,
  system.Generics.Collections, Data.DB, system.Net.HttpClientComponent,
  system.Net.HttpClient, system.JSON, Rest.JSON, system.Net.URLClient,
  FireDAC.Comp.Client, FireDAC.Stan.Intf, FireDAC.Stan.StorageBin, FireDAC.Phys.Intf,
  FireDAC.Stan.StorageJSON, FireDAC.Stan.StorageXML, system.TypInfo,
  OneClientResult, OneNeonHelper, OneClientDataInfo, OneStreamString, FireDAC.Comp.DataSet,
  OneSQLCrypto, FireDAC.Stan.Param, system.Zip, system.Math, system.NetEncoding;

const
  HTTP_Status_TokenFail = 498;
  HTTP_URL_TokenName = 'token';
  HTTP_URL_TokenTime = 'time';
  HTTP_URL_TokenSign = 'sign';
  // token���
  URL_HTTP_HTTPServer_TOKEN_ClientConnect = 'OneServer/Token/ClientConnect';
  URL_HTTP_HTTPServer_TOKEN_ClientConnectPing = 'OneServer/Token/ClientConnectPing';
  URL_HTTP_HTTPServer_TOKEN_TokenBindUser = 'OneServer/Token/TokenBindUser';

  URL_HTTP_HTTPServer_TOKEN_ClientDisConnect = 'OneServer/Token/ClientDisConnect';
  URL_HTTP_HTTPServer_TOKEN_ClientPing = 'OneServer/Token/ClientPing';
  URL_HTTP_HTTPServer_TOKEN_GetUUID = 'OneServer/Token/GetUUID';
  URL_HTTP_HTTPServer_TOKEN_GetUUIDs = 'OneServer/Token/GetUUIDs';
  // �����������
  URL_HTTP_HTTPServer_DATA_OpenDatas = 'OneServer/Data/OpenDatas';
  URL_HTTP_HTTPServer_DATA_SaveDatas = 'OneServer/Data/SaveDatas';
  URL_HTTP_HTTPServer_DATA_ExecStored = 'OneServer/Data/ExecStored';
  URL_HTTP_HTTPServer_DATA_ExecScript = 'OneServer/Data/ExecScript';
  URL_HTTP_HTTPServer_DATA_DownLoadDataFile = 'OneServer/Data/DownLoadDataFile';
  URL_HTTP_HTTPServer_DATA_DelDataFile = 'OneServer/Data/DelDataFile';
  URL_HTTP_HTTPServer_DATA_GetDBMetaInfo = 'OneServer/Data/GetDBMetaInfo';
  // �������
  URL_HTTP_HTTPServer_ZTManage_OneGetZTList = 'OneServer/ZTManage/OneGetZTList';
  // ���������ȹ��¼�
  URL_HTTP_HTTPServer_DATA_LockTranItem = 'OneServer/Data/LockTranItem';
  URL_HTTP_HTTPServer_DATA_UnLockTranItem = 'OneServer/Data/UnLockTranItem';
  URL_HTTP_HTTPServer_DATA_StartTranItem = 'OneServer/Data/StartTranItem';
  URL_HTTP_HTTPServer_DATA_CommitTranItem = 'OneServer/Data/CommitTranItem';
  URL_HTTP_HTTPServer_DATA_RollbackTranItem = 'OneServer/Data/RollbackTranItem';

  // �ļ�����ϴ�����
  URL_HTTP_HTTPServer_DATA_UploadFile = 'OneServer/VirtualFile/UploadFile';
  URL_HTTP_HTTPServer_DATA_DownloadFile = 'OneServer/VirtualFile/DownloadFile';
  URL_HTTP_HTTPServer_DATA_GetTaskID = 'OneServer/VirtualFile/GetTaskID';
  URL_HTTP_HTTPServer_DATA_UploadChunkFile = 'OneServer/VirtualFile/UploadChunkFile';
  URL_HTTP_HTTPServer_DATA_DownloadChunkFile = 'OneServer/VirtualFile/DownloadChunkFile';
  URL_HTTP_HTTPServer_DATA_DeleteFile = 'OneServer/VirtualFile/DeleteFile';

type
  TOneConnection = class;

  OneContentType = (ContentTypeText, ContentTypeHtml, ContentTypeStream,
    ContentTypeZip);

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
    // ������Ƿ�����
    FConnected: boolean;
    // �ͻ���IP
    FClientIP: string;
    // �ͻ���MAC��ַ
    FClientMac: string;
    //
    FIsHttps: boolean;
    FHTTPHost: string;
    FHTTPPort: Integer;
    // ��ȫ��Կ
    FConnectSecretkey: string;
    FToKenID: string;
    FPrivateKey: string;
    // HTTP����ʱ��
    FConnectionTimeout: Integer;
    FResponseTimeout: Integer;
    // ȫ�����״��룬������ݼ���ȡ���ݼ���,û��ȡȫ�ֵ�
    FZTCode: string;
    FErrMsg: string;
    FTokenFailCallBack: TNotifyEvent;
    // HTTP����ȴ������¼����أ��ο�Demo
    FOnShowWaitHint: TNotifyEvent;
    FOnShowWaitHintProcess: TNotifyEvent;
    FOnShowWaitHintClose: TNotifyEvent;
  private
    // ��װURL
    function MakeUrl(var QUrl: string; var QErrMsg: string): boolean;
    // ��ȡ����״̬
    function GetZTCode(QDataSetZTCode: string): string;
  public
    procedure SetErrTrueResult(var QErrMsg: string);
    function IsErrTrueResult(QErrMsg: string): boolean;
    //
    constructor Create(AOwner: TComponent);
      override;
    function DoConnect(qForceConnect: boolean = false): boolean;
    function DoConnectPing(): boolean;
    function DoPing(): boolean;
    function DoTokenBindUser(qUserID: string; qUserCode: string; qUserName: string): boolean;
    procedure DisConnect;
      overload;
    // �ύbytes����Bytes
    function PostResultBytes(const QUrl: string; QPostDataBtye: TBytes): TOneResultBytes;
      overload;
    function PostResultBytes(const QUrl: string; QPostData: RawByteString): TOneResultBytes;
      overload;
    // �ύ�ַ���������JSONValue
    function PostResultJsonValue(const QUrl: string; QPostData: RawByteString; var QErrMsg: string): TJsonValue;
      overload;
    function PostResultJsonValue(const QUrl: string; QObject: TObject; var QErrMsg: string): TJsonValue;
      overload;
    // �ύBytes������JSONValue
    function PostResultJsonValue(const QUrl: string; QPostData: TBytes; var QErrMsg: string): TJsonValue;
      overload;
    function PostResultContent(const QUrl: string; QPostData: string; var QResultData: string): boolean;
    // Get����¼�
    function GetResultBytes(const QUrl: string): TOneResultBytes;
    function GetResultJsonValue(const QUrl: string; var QErrMsg: string): TJsonValue;
    function GetResultContent(const QUrl: string; var QResultData: string): boolean;
  public
    procedure DataSetToOpenData(Sender: TObject; QDataOpen: TOneDataOpen);
    // ����OneDataSet�����ݼ�
    function OpenData(Sender: TObject): boolean;
    // ����List<OneDataSet>�����ݼ�
    function OpenDatas(QObjectList: TList<TObject>; var QErrMsg: string): boolean;
      overload;
    // ���ļ�����ʽ������
    function DownLoadDataFile(QFileID: string; var QErrMsg: string): TMemoryStream;
    // ����List<TOneDataOpen(���ݼ���Ϣ�ռ�)>�����ݼ�
    function OpenDatasPost(QDataOpens: TList<TOneDataOpen>): TOneDataResult;
      overload;
    //
    function ExecStored(Sender: TObject): boolean;
    function ExecScript(Sender: TObject): boolean;
    function GetDBMetaInfo(Sender: TObject): boolean;
    // ִ�д洢����
    function ExecStoredPost(QDataOpen: TOneDataOpen): TOneDataResult;
    // ����dataSet��������
    function SaveData(Sender: TObject): boolean;
      overload;
    function ExecDML(QSQL: string; QParamValues: array of Variant; Var QErrMsg: string): boolean;
      overload;
    function ExecDML(QSQL: string; QParamValues: array of Variant; QZTCode: string; Var QErrMsg: string): boolean;
      overload;
    // ����List<OneDataSet>�����ݼ�
    function SaveDatas(QObjectList: TList<TObject>; var QErrMsg: string): boolean;
      overload;
    function SaveDatasPost(QSaveDMLDatas: TList<TOneDataSaveDML>): TOneDataResult;
      overload;
    // �ѷ��صĽṹת����dataset
    function DataResultToDataSets(DataResult: TOneDataResult; QObjectList: TList<TObject>; QIsSave: boolean; Var QErrMsg: string): boolean;
    function DataResultToDataSet(QDataResult: TOneDataResult; QObject: TObject; Var QErrMsg: string): boolean;

    // �ļ��ϴ�����
    function UploadFile(QVirtualInfo: TVirtualInfo): boolean;
    function DownloadFile(QVirtualInfo: TVirtualInfo): boolean;
    function DeleteVirtualFile(QVirtualInfo: TVirtualInfo): boolean;
    function GetTaskID(QVirtualTask: TVirtualTask): boolean;
    function UploadChunkFile(QVirtualTask: TVirtualTask; QUpDownChunkCallBack: EvenUpDownChunkCallBack): boolean;
    function DownloadChunkFile(QVirtualTask: TVirtualTask; QUpDownChunkCallBack: EvenUpDownChunkCallBack): boolean;

    //
    function OneGetZTList(Var QErrMsg: string): TList<TZTInfo>;
    function OneGetZTStringList(Var QErrMsg: string): TStringList;
    // *********�����������ɿ���***********
    /// <summary>
    /// ������Ƶ�һ��:��ȡ��������,��ʶ����������
    /// </summary>
    /// <returns>ʧ�ܷ���False,������Ϣ��ErrMsg����</returns>
    function LockTran(QTranInfo: TOneTran): boolean;
    // 2.��������������,�黹����,���û�黹���ܾú󣬷���˻��Զ�����黹
    function UnLockTran(QTranInfo: TOneTran): boolean;
    // 3.����������������
    function StartTran(QTranInfo: TOneTran): boolean;
    // 4.�ύ������������
    function CommitTran(QTranInfo: TOneTran): boolean;
    // 5.�ع�������������
    function RollbackTran(QTranInfo: TOneTran): boolean;

    // ��ȡUUID
    function GetUUID(var QErrMsg: string): int64;
    // ������ٸ�UUID
    function GetUUIDs(QCount: Integer; var QErrMsg: string): TList<int64>;
  public
    property onTokenFailCallBack: TNotifyEvent read FTokenFailCallBack write FTokenFailCallBack;
  published
    /// <param name="Connected">DoConnect���ӳɹ��ı�ʶ,����һ��ʼȷ�������HTTP�����Ƿ�����</param>
    property Connected: boolean read FConnected write FConnected;
    /// <param name="ClientIP">DoConnect���ӻ���ϴ˲���,�����и�ֵ������ǰ������Ϊ��</param>
    property ClientIP: string read FClientIP write FClientIP;
    /// <param name="ClientMac">DoConnect���ӻ���ϴ˲���,�����и�ֵ������ǰ������Ϊ��</param>
    property ClientMac: string read FClientMac write FClientMac;
    /// <param name="IsHttps">�Ƿ�HTTP����</param>
    property IsHttps: boolean read FIsHttps write FIsHttps;
    /// <param name="HTTPHost">����˵�ַ������</param>
    property HTTPHost: string read FHTTPHost write FHTTPHost;
    /// <param name="HTTPPort">����˶˿�</param>
    property HTTPPort: Integer read FHTTPPort write FHTTPPort;
    /// <param name="ConnectSecretkey">��������Ӱ�ȫ��Կ,DoConnectʱ��Ҫ</param>
    property ConnectSecretkey: string read FConnectSecretkey write FConnectSecretkey;
    /// <param name="TokenID">DoConnect���ӳɹ��󷵻ص�tokenID</param>
    property TokenID: string read FToKenID write FToKenID;
    /// <param name="PrivateKey">DoConnect���ӳɹ��󷵻ص�PrivateKey</param>
    property PrivateKey: string read FPrivateKey write FPrivateKey;
    /// <param name="ConnectionTimeout">���ӳ�ʱʱ��</param>
    property ConnectionTimeout: Integer read FConnectionTimeout write FConnectionTimeout;
    /// <param name="ResponseTimeout">��������ʱʱ��</param>
    property ResponseTimeout: Integer read FResponseTimeout write FResponseTimeout;
    /// <param name="ZTCode">��������,������ݼ�����������ȡ���ݼ���</param>
    property ZTCode: string read FZTCode write FZTCode;
    /// <param name="ErrMsg">������Ϣ���</param>
    property ErrMsg: string read FErrMsg write FErrMsg;
    /// <summary>
    /// һ��������������ǰ�ȴ�����
    /// </summary>
    property OnShowWaitHint: TNotifyEvent read FOnShowWaitHint write FOnShowWaitHint;
    /// <summary>
    /// ��Ϣ����
    /// </summary>
    property OnShowWaitHintProcess: TNotifyEvent read FOnShowWaitHintProcess write FOnShowWaitHintProcess;
    /// <summary>
    /// һ��������������ǰ�ȴ�����,�ر�
    /// </summary>
    property OnShowWaitHintClose: TNotifyEvent read FOnShowWaitHintClose write FOnShowWaitHintClose;
  end;

var
  Unit_Connection: TOneConnection = nil;

implementation

uses OneClientDataSet, OneFileHelper, OneCrypto;

function IsMainThread(): boolean;
begin
  result := TThread.CurrentThread.ThreadID = MainThreadID;
end;

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

// ���ӷ���˻�ȡToken
function TOneConnection.DoConnect(qForceConnect: boolean = false): boolean;
var
  lJsonObj: TJsonObject;
  lResultJsonValue: TJsonValue;
  lErrMsg: string;
  lClientConnect: TClientConnect;
  lServerResult: TActionResult<TClientConnect>;
begin
  result := false;
  if (not qForceConnect) then
  begin
    if self.FConnected then
    begin
      // ����Ѿ����ӹ��Ͳ������ӣ�
      // ���������ϵ�
      self.FErrMsg := '������,����������,��������������ִ��DisConnect����ǿ����������DoConnect(true)';
      // ��߻��Ƿ���true
      result := true;
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
      self.FErrMsg := '���ص����ݽ�����TResult<TClientConnect>����,�޷�֪�����,����:' + lResultJsonValue.ToJSON;
      exit;
    end;
    if not lServerResult.ResultSuccess then
    begin
      self.FErrMsg := '�������Ϣ:' + lServerResult.ResultMsg;
      exit;
    end;
    self.TokenID := lServerResult.ResultData.TokenID;
    self.PrivateKey := lServerResult.ResultData.PrivateKey;
    if self.TokenID = '' then
    begin
      self.FErrMsg := '����ɹ������ص�TokenIDΪ��,��ǰ���ص�����:' + lResultJsonValue.ToJSON;
      exit;
    end;
    self.FConnected := true;
    result := true;
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
  result := false;
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
      self.FErrMsg := '���ص����ݽ�����TResult<string>����,�޷�֪�����,����:' + lResultJsonValue.ToJSON;
      exit;
    end;
    if not lServerResult.ResultSuccess then
    begin
      self.FErrMsg := '�������Ϣ:' + lServerResult.ResultMsg;
      exit;
    end;
    self.FConnected := true;
    result := true;
  finally
    lJsonObj.Free;
    if lResultJsonValue <> nil then
    begin
      lResultJsonValue.Free;
    end;
    lServerResult.Free;
  end;
end;

function TOneConnection.DoTokenBindUser(qUserID: string; qUserCode: string; qUserName: string): boolean;
var
  lJsonObj: TJsonObject;
  lResultJsonValue: TJsonValue;
  lErrMsg: string;
  lClientConnect: TClientConnect;
  lServerResult: TActionResult<string>;
begin
  result := false;
  lResultJsonValue := nil;
  lServerResult := TActionResult<string>.Create;
  lJsonObj := TJsonObject.Create;
  try
    lJsonObj.AddPair('TokenID', self.ClientIP);
    lJsonObj.AddPair('UserID', qUserID);
    lJsonObj.AddPair('UserCode', qUserCode);
    lJsonObj.AddPair('UserName', qUserName);
    lResultJsonValue := self.PostResultJsonValue(URL_HTTP_HTTPServer_TOKEN_TokenBindUser, lJsonObj.ToJSON(), lErrMsg);
    if not self.IsErrTrueResult(lErrMsg) then
    begin
      self.FErrMsg := lErrMsg;
      exit;
    end;

    if not OneNeonHelper.JsonToObject(lServerResult, lResultJsonValue, lErrMsg) then
    begin
      self.FErrMsg := '���ص����ݽ�����TResult<TClientConnect>����,�޷�֪�����,����:' + lResultJsonValue.ToJSON;
      exit;
    end;
    if not lServerResult.ResultSuccess then
    begin
      self.FErrMsg := '�������Ϣ:' + lServerResult.ResultMsg;
      exit;
    end;
    self.FConnected := true;
    result := true;
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
  result := false;
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
      self.FErrMsg := '���ص����ݽ�����TResult<string>����,�޷�֪�����,����:' + lResultJsonValue.ToJSON;
      exit;
    end;
    if not lServerResult.ResultSuccess then
    begin
      self.FErrMsg := '�������Ϣ:' + lServerResult.ResultMsg;
      exit;
    end;
    result := true;
  finally
    self.FConnected := result;
    if lResultJsonValue <> nil then
    begin
      lResultJsonValue.Free;
    end;
    lServerResult.Free;
  end;
end;

// �Ͽ�����ˣ����������߳�Token��HTTP���ǻ��ڶ�����
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

// ����URL
function TOneConnection.MakeUrl(var QUrl: string; var QErrMsg: string): boolean;
var
  tempStr: string;
  lURI: TURI;
  lTimeStr: string;
  lSign: string;
begin
  result := false;
  QErrMsg := '';
  tempStr := '';
  if not QUrl.StartsWith('http') then
  begin
    if self.FHTTPHost = '' then
    begin
      QErrMsg := '����˵�ַδ����';
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
    // ����Token��ز����Լ�ǩ��
    if self.FToKenID <> '' then
    begin
      lTimeStr := DateTimeToUnix(now).ToString;
      lURI.AddParameter(HTTP_URL_TokenName, self.FToKenID);
      lURI.AddParameter(HTTP_URL_TokenTime, lTimeStr);
      // ǩ��
      lSign := self.FToKenID + lTimeStr + self.FPrivateKey;
      lSign := OneCrypto.MD5Endcode(lSign);
      lURI.AddParameter(HTTP_URL_TokenSign, lSign);
    end;
    // ת������
    QUrl := lURI.ToString;
    result := true;
  except
    on e: Exception do
    begin
      QErrMsg := 'URL�����쳣,������װ��URLΪ:' + tempStr;
    end;
  end;

end;

procedure TOneConnection.SetErrTrueResult(var QErrMsg: string);
begin
  QErrMsg := 'true';
end;

function TOneConnection.IsErrTrueResult(QErrMsg: string): boolean;
begin
  result := QErrMsg = 'true';
end;

// ��ȡ���� ��������ݼ���ȡ���ݼ���,û��ȡȫ�ֵ�
function TOneConnection.GetZTCode(QDataSetZTCode: string): string;
begin
  if QDataSetZTCode.Trim = '' then
    result := self.ZTCode
  else
    result := QDataSetZTCode.Trim;
end;

function TOneConnection.PostResultBytes(const QUrl: string; QPostData: RawByteString): TOneResultBytes;
var
  lPostBytes, lResultBytes: TBytes;
begin
  result := nil;
  lPostBytes := TEncoding.UTF8.GetBytes(QPostData);
  result := self.PostResultBytes(QUrl, lPostBytes);
end;

// �ύbytes����Bytes
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
  //
  lIsWait: boolean;
  lIsPostEnd: boolean;
begin
  result := TOneResultBytes.Create;
  lErrMsg := '';
  LResponse := nil;
  lUrl := QUrl;
  if not self.MakeUrl(lUrl, lErrMsg) then
  begin
    result.ErrMsg := lErrMsg;
    exit;
  end;
  LNetHttp := TNetHTTPClient.Create(nil);
  LRequestStream := TMemoryStream.Create;
  LResponseStream := TMemoryStream.Create;
  lIsWait := false;
  lIsPostEnd := false;
  if Assigned(self.FOnShowWaitHint) then
  begin
    self.FOnShowWaitHint(self);
    lIsWait := true;
  end;
  try
    try
{$IF CompilerVersion >=31}
      // XE10���ϲ�����������
      LNetHttp.ConnectionTimeout := self.ConnectionTimeout;
      LNetHttp.ResponseTimeout := self.ResponseTimeout;
{$ENDIF}
      // LNetHttp.ContentType := 'text/plain; charset=utf-8';
      LNetHttp.AcceptCharSet := 'utf-8';
      LNetHttp.AcceptEncoding := 'zlib'; // ����zlibѹ
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
      if IsMainThread() then
      begin
        // ���߳��У��ȴ�������Ҫ��Ϣ����
        if Assigned(self.FOnShowWaitHintProcess) then
        begin
          TThread.CreateAnonymousThread(
            procedure()
            begin
              try
                LResponse := LNetHttp.Post(lUrl, LRequestStream, LResponseStream);
              finally
                lIsPostEnd := true;
              end;
            end
            ).Start;
          while not lIsPostEnd do
          begin
            sleep(200);
            // win���� application.ProcessMessages;�黹��Ϣ������ʲô��ɴ���
            // FMX����������ص�Ԫ FMX.Forms Ȼ����� Tapplication.ProcessMessages
            self.FOnShowWaitHintProcess(self);
          end;
        end
        else
        begin
          LResponse := LNetHttp.Post(lUrl, LRequestStream, LResponseStream);
        end;
      end
      else
      begin
        // ������������̣߳�����Ҫ������Ϣ����黹�����߳�
        LResponse := LNetHttp.Post(lUrl, LRequestStream, LResponseStream);
      end;
      if LResponse = nil then
      begin
        result.ErrMsg := '���ؽ������,���Ϊnil';
        exit;
      end;
      if LResponse.StatusCode = 200 then
      begin
        // LResponse.Headers
        // 'text/plain;charset=UTF-8'
        result.ContentType := LResponse.MimeType;
        tempA := result.ContentType.Split([';']);
        if length(tempA) = 2 then
        begin
          if not tempA[0].StartsWith('charset') then
            result.ContentType := tempA[0]
          else
            result.ContentType := tempA[1];
        end;
        result.IsFile := (LResponse.HeaderValue['OneOutMode'] = 'OUTFILE');
        if not result.IsFile then
        begin
          if (result.ContentType.ToLower <> 'application/json') and (result.ContentType.ToLower <> 'text/plain') then
          begin
            result.IsFile := true;
          end;
        end;
        // �ж����ļ����ǲ���
        LResponseStream.Position := 0;
        setLength(lBytes, LResponseStream.Size);
        LResponseStream.Read(lBytes, LResponseStream.Size);
        if (LResponse.ContentEncoding = 'zlib') and (not result.IsFile) then
        begin
          setLength(lZlibBytes, 0);
          ZDecompress(lBytes, lZlibBytes);
          result.Bytes := lZlibBytes;
        end
        else
        begin
          result.Bytes := lBytes;
        end;
        result.IsOK := true;
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
          result.ErrMsg := 'Token��֤ʧ��,�����µ�½';
        end;
        exit;
      end
      else
      begin
        LResponseStream.Position := 0;
        setLength(lBytes, LResponseStream.Size);
        LResponseStream.Read(lBytes, LResponseStream.Size);
        result.ErrMsg := '���ؽ������,�������:' + LResponse.StatusCode.ToString + ';����״̬:' + LResponse.StatusText + ';����˴���:' + TEncoding.UTF8.GetString(lBytes);;
      end;
    except
      on e: Exception do
      begin
        result.ErrMsg := '�������쳣:' + e.Message;
      end;
    end;
  finally
    LResponse := nil;
    LRequestStream.Clear;
    LRequestStream.Free;
    LResponseStream.Clear;
    LResponseStream.Free;
    LNetHttp.Free;
    if lIsWait then
    begin
      if Assigned(self.FOnShowWaitHintClose) then
      begin
        self.FOnShowWaitHintClose(self);
      end;
    end;
  end;
end;

// �ύ�ַ���������JSONValue
function TOneConnection.PostResultJsonValue(const QUrl: string; QPostData: RawByteString; var QErrMsg: string): TJsonValue;
var
  lPostBytes: TBytes;
  lResultBytes: TOneResultBytes;
  lJsonValue: TJsonValue;
  QContentType: string;
begin
  result := nil;
  lJsonValue := nil;
  lResultBytes := nil;
  QErrMsg := '';
  // �����ϴ�ѹ��
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
        QErrMsg := '���ת��JSON�����쳣:���Ϊnil,������Ϣ:' + TEncoding.UTF8.GetString(lResultBytes.Bytes);
        exit;
      end;
      self.SetErrTrueResult(QErrMsg);
      result := lJsonValue;
    except
      on e: Exception do
      begin
        QErrMsg := '���ת��JSON�����쳣:' + e.Message;
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
  result := nil;
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
        QErrMsg := '���ת��JSON�����쳣:���Ϊnil,������Ϣ:' + TEncoding.UTF8.GetString(lResultBytes.Bytes);
        exit;
      end;
      self.SetErrTrueResult(QErrMsg);
      result := lTempJson;
    except
      on e: Exception do
      begin
        QErrMsg := '���ת��JSON�����쳣:' + e.Message;
      end;
    end;
  finally
    if lResultBytes <> nil then
    begin
      lResultBytes.Free;
    end;
  end;
end;

// �ύBytes������JSONValue
function TOneConnection.PostResultJsonValue(const QUrl: string; QPostData: TBytes; var QErrMsg: string): TJsonValue;
var
  lPostBytes: TBytes;
  lResultBytes: TOneResultBytes;
  lJsonValue: TJsonValue;
begin
  result := nil;
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
        QErrMsg := '���ת��JSON�����쳣:���Ϊnil,������Ϣ:' + TEncoding.UTF8.GetString(lResultBytes.Bytes);
        exit;
      end;
      self.SetErrTrueResult(QErrMsg);
      result := lJsonValue;
    except
      on e: Exception do
      begin
        QErrMsg := '���ת��JSON�����쳣:' + e.Message;
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
  result := false;
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
    result := true;
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
  result := TOneResultBytes.Create;
  lErrMsg := '';
  LResponse := nil;
  lUrl := QUrl;
  if not self.MakeUrl(lUrl, lErrMsg) then
  begin
    result.ErrMsg := lErrMsg;
    exit;
  end;
  LNetHttp := TNetHTTPClient.Create(nil);
  LResponseStream := TMemoryStream.Create;
  try
    try
{$IF CompilerVersion >=31}
      // XE10���ϲ�����������
      LNetHttp.ConnectionTimeout := self.ConnectionTimeout;
      LNetHttp.ResponseTimeout := self.ResponseTimeout;
{$ENDIF}
      // LNetHttp.ContentType := 'text/plain; charset=utf-8';
      LNetHttp.AcceptCharSet := 'utf-8';
      LResponse := LNetHttp.Get(lUrl, LResponseStream);
      if LResponse = nil then
      begin
        result.ErrMsg := '���ؽ������,���Ϊnil';
        exit;
      end;
      if LResponse.StatusCode = 200 then
      begin
        // LResponse.Headers
        // 'text/plain;charset=UTF-8'
        result.ContentType := LResponse.MimeType;
        tempA := result.ContentType.Split([';']);
        if length(tempA) = 2 then
        begin
          if not tempA[0].StartsWith('charset') then
            result.ContentType := tempA[0]
          else
            result.ContentType := tempA[1];
        end;
        result.IsFile := (LResponse.HeaderValue['OneOutMode'] = 'OUTFILE');
        if not result.IsFile then
        begin
          if (result.ContentType.ToLower <> 'application/json') and (result.ContentType.ToLower <> 'text/plain') then
          begin
            result.IsFile := true;
          end;
        end;
        // �ж����ļ����ǲ���
        LResponseStream.Position := 0;
        setLength(lBytes, LResponseStream.Size);
        LResponseStream.Read(lBytes, LResponseStream.Size);
        result.Bytes := lBytes;
        result.IsOK := true;
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
        result.ErrMsg := '���ؽ������,�������:' + LResponse.StatusCode.ToString + ';����״̬:' + LResponse.StatusText + ';����˴���:' + TEncoding.UTF8.GetString(lBytes);;
      end;
    except
      on e: Exception do
      begin
        result.ErrMsg := '�������쳣:' + e.Message;
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
  result := nil;
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
        QErrMsg := '���ת��JSON�����쳣:���Ϊnil,������Ϣ:' + TEncoding.UTF8.GetString(lResultBytes);;
        exit;
      end;
      self.SetErrTrueResult(QErrMsg);
      result := lJsonValue;
    except
      on e: Exception do
      begin
        QErrMsg := '���ת��JSON�����쳣:' + e.Message;
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
  result := false;
  lOneResultBytes := self.GetResultBytes(QUrl);
  try
    if not lOneResultBytes.IsOK then
    begin
      QResultData := lOneResultBytes.ErrMsg;
      exit;
    end;
    QResultData := TEncoding.UTF8.GetString(lOneResultBytes.Bytes);
    result := true;
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
  // SQL���д���
  QDataOpen.OpenSQL := OneSQLCrypto.SwapCrypto(lOneDataSet.SQL.Text);
  QDataOpen.SPName := lOneDataSet.DataInfo.StoredProcName;
  QDataOpen.SPIsOutData := lOneDataSet.DataInfo.IsReturnData;
  // ������ز���
  for iParam := 0 to lOneDataSet.Params.Count - 1 do
  begin
    lFDParam := lOneDataSet.Params[iParam];
    lOneParam := TOneParam.Create;
    QDataOpen.Params.Add(lOneParam);
    lOneParam.ParamName := lFDParam.Name;
    lOneParam.ParamType := GetEnumName(TypeInfo(TParamType), Ord(lFDParam.ParamType));
    lOneParam.ParamDataType := GetEnumName(TypeInfo(TFieldType), Ord(lFDParam.DataType));
    // ������ֵ
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
          // ת����Base64
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

// ����OneDataSet�����ݼ�
function TOneConnection.OpenData(Sender: TObject): boolean;
var
  QObjectList: TList<TObject>;
  lErrMsg: String;
  lDataSet: TOneDataSet;
begin
  result := false;
  if not(Sender is TOneDataSet) then
    exit;
  lDataSet := TOneDataSet(Sender);
  QObjectList := TList<TObject>.Create;
  try
    QObjectList.Add(lDataSet);
    result := self.OpenDatas(QObjectList, lErrMsg);
    lDataSet.DataInfo.ErrMsg := lErrMsg;
  finally
    QObjectList.Clear;
    QObjectList.Free;
  end;
end;

// ����List<OneDataSet>�����ݼ�
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
  result := false;
  QErrMsg := '';
  if not FConnected then
  begin
    QErrMsg := 'δ����,����ִ��DoConnect�¼�.';
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
        QErrMsg := '��OneDataSet����ʹ��';
        exit;
      end;
    end;
    // У��
    for i := 0 to lOneDataSets.Count - 1 do
    begin
      lOneDataSet := lOneDataSets[i];
      if lOneDataSet.SQL.Text.Trim = '' then
      begin
        QErrMsg := '���ݼ�:' + lOneDataSet.Name + 'SQLΪ��,�޷�������';
        exit;
      end;
      if lOneDataSet.DataInfo.OpenMode = TDataOpenMode.localSQL then
      begin
        QErrMsg := '[' + lOneDataSet.Name + ']�����ݼ���ģʽΪlocalSQLʱ,ֻ֧�ֱ��ز�ѯ';
        exit;
      end;
    end;
    // ��װ����
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
    // ������
    lDataResult := self.OpenDatasPost(lDataOpens);
    if not lDataResult.ResultOK then
    begin
      QErrMsg := lDataResult.ResultMsg;
      exit;
    end;
    // �������ݵ�dataSet
    if not self.DataResultToDataSets(lDataResult, QObjectList, false, QErrMsg) then
    begin
      exit;
    end;
    result := true;
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
  result := TOneDataResult.Create;
  if not self.FConnected then
  begin
    // ����Ѿ����ӹ��Ͳ������ӣ�
    // ���������ϵ�
    result.ResultMsg := 'δ����,����ִ��DoConnect�¼�.';
    exit;
  end;
  if QDataOpens = nil then
  begin
    result.ResultMsg := '������������ݵ���ϢΪnil';
    exit;
  end;
  if QDataOpens.Count = 0 then
  begin
    result.ResultMsg := '������������ݵ���ϢΪ0����Ϣ';
    exit;
  end;
  lResultJsonValue := nil;
  lPostJsonValue := nil;
  try
    lPostJsonValue := OneNeonHelper.ObjectToJson(QDataOpens, lErrMsg);
    if lErrMsg <> '' then
    begin
      result.ResultMsg := lErrMsg;
      exit;
    end;
    lResultJsonValue := self.PostResultJsonValue(URL_HTTP_HTTPServer_DATA_OpenDatas, lPostJsonValue.ToJSON(), lErrMsg);
    if not self.IsErrTrueResult(lErrMsg) then
    begin
      result.ResultMsg := lErrMsg;
      exit;
    end;
    if not OneNeonHelper.JsonToObject(result, lResultJsonValue, lErrMsg) then
    begin
      result.ResultMsg := '���ص����ݽ�����TOneDataResult����,�޷�֪�����,����:' + lResultJsonValue.ToJSON;
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
  result := false;
  if not(Sender is TOneDataSet) then
    exit;
  lDataOpen := TOneDataOpen.Create;
  lDataResult := nil;
  try
    self.DataSetToOpenData(Sender, lDataOpen);
    lDataResult := self.ExecStoredPost(lDataOpen);
    if not lDataResult.ResultOK then
    begin
      TOneDataSet(Sender).DataInfo.ErrMsg := '�������Ϣ:' + lDataResult.ResultMsg;
      exit;
    end;
    if not self.DataResultToDataSet(lDataResult, Sender, lErrMsg) then
    begin
      TOneDataSet(Sender).DataInfo.ErrMsg := lErrMsg;
      exit;
    end;
    result := true;
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
  result := false;
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
      lDataSet.DataInfo.ErrMsg := '���ص����ݽ�����TResult<string>����,�޷�֪�����,����:' + lResultJsonValue.ToJSON;
      exit;
    end;
    if not lActionResult.ResultSuccess then
    begin
      lDataSet.DataInfo.ErrMsg := '�������Ϣ:' + lActionResult.ResultMsg;
      exit;
    end;
    result := true;
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
  result := false;
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
      lOneDataSet.DataInfo.ErrMsg := '���ص����ݽ�����TOneDataResult����,�޷�֪�����,����:' + lResultJsonValue.ToJSON;;
      exit;
    end;
    if not self.DataResultToDataSet(lDataResult, Sender, lErrMsg) then
    begin
      lOneDataSet.DataInfo.ErrMsg := lErrMsg;
      exit;
    end;
    result := true;
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
  result := TOneDataResult.Create;
  if not self.FConnected then
  begin
    // ����Ѿ����ӹ��Ͳ������ӣ�
    // ���������ϵ�
    result.ResultMsg := 'δ����,����ִ��DoConnect�¼�.';
    exit;
  end;
  if QDataOpen = nil then
  begin
    result.ResultMsg := '������������ݵ���ϢΪnil';
    exit;
  end;
  lResultJsonValue := nil;
  lPostJsonValue := nil;
  try
    lPostJsonValue := OneNeonHelper.ObjectToJson(QDataOpen, lErrMsg);
    if lErrMsg <> '' then
    begin
      result.ResultMsg := lErrMsg;
      exit;
    end;
    lResultJsonValue := self.PostResultJsonValue(URL_HTTP_HTTPServer_DATA_ExecStored, lPostJsonValue.ToJSON(), lErrMsg);
    if not self.IsErrTrueResult(lErrMsg) then
    begin
      self.FErrMsg := lErrMsg;
      exit;
    end;
    if not OneNeonHelper.JsonToObject(result, lResultJsonValue, lErrMsg) then
    begin
      result.ResultMsg := '���ص����ݽ�����TOneDataResult����,�޷�֪�����,����:' + lResultJsonValue.ToJSON;;
      exit;
    end;
    if result.ResultMsg <> '' then
    begin
      result.ResultMsg := '�������Ϣ:' + result.ResultMsg;
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

// ***********��������*********************//
function TOneConnection.SaveData(Sender: TObject): boolean;
var
  QObjectList: TList<TObject>;
  lErrMsg: String;
  lDataSet: TOneDataSet;
begin
  result := false;
  if not(Sender is TOneDataSet) then
    exit;
  lDataSet := TOneDataSet(Sender);
  QObjectList := TList<TObject>.Create;
  try
    QObjectList.Add(lDataSet);
    result := self.SaveDatas(QObjectList, lErrMsg);
    lDataSet.DataInfo.ErrMsg := lErrMsg;
  finally
    QObjectList.Clear;
    QObjectList.Free;
  end;
end;

function TOneConnection.ExecDML(QSQL: string; QParamValues: array of Variant; Var QErrMsg: string): boolean;
begin
  result := self.ExecDML(QSQL, QParamValues, '', QErrMsg);
end;

function TOneConnection.ExecDML(QSQL: string; QParamValues: array of Variant; QZTCode: string; Var QErrMsg: string): boolean;
var
  lData: TOneDataSet;
  lList: TList<TObject>;
  i: Integer;
begin
  result := false;
  QErrMsg := '';
  lList := TList<TObject>.Create;
  lData := TOneDataSet.Create(nil);
  try
    lData.DataInfo.SaveMode := TDataSaveMode.saveDML;
    lData.SQL.Text := QSQL;
    if lData.Params.Count <> length(QParamValues) then
    begin
      QErrMsg := 'SQL�������ĸ���������ĸ������Ե�,����';
      exit;
    end;
    for i := 0 to lData.Params.Count - 1 do
    begin
      lData.Params[i].Value := QParamValues[i];
    end;
    lList.Add(lData);
    result := self.SaveDatas(lList, QErrMsg);
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
  result := false;
  QErrMsg := '';
  if not FConnected then
  begin
    QErrMsg := 'δ����,����ִ��DoConnect�¼�.';
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
        QErrMsg := '��OneDataSet����ʹ��';
        exit;
      end;
    end;
    // У��
    for i := 0 to lOneDataSets.Count - 1 do
    begin
      lOneDataSet := lOneDataSets[i];
      if lOneDataSet.DataInfo.SaveMode = TDataSaveMode.SaveData then
      begin
        if not lOneDataSet.Active then
        begin
          QErrMsg := '���ݼ�:' + lOneDataSet.Name + '��������ģʽ:����δ����';
          exit;
        end;
        if lOneDataSet.DataInfo.TableName = '' then
        begin
          QErrMsg := '���ݼ�:' + lOneDataSet.Name + '��������ģʽ:��������Ϊ��';
          exit;
        end;
        if lOneDataSet.DataInfo.PrimaryKey = '' then
        begin
          QErrMsg := '���ݼ�:' + lOneDataSet.Name + '��������ģʽ:��������Ϊ��';
          exit;
        end;
        if (lOneDataSet.State in dsEditModes) then
          lOneDataSet.Post;
      end
      else if lOneDataSet.DataInfo.SaveMode = TDataSaveMode.saveDML then
      begin
        if lOneDataSet.SQL.Text.Trim = '' then
        begin
          QErrMsg := '���ݼ�:' + lOneDataSet.Name + 'DML����:SQL����Ϊ��';
          exit;
        end;
      end
      else
      begin
        QErrMsg := '���ݼ�:' + lOneDataSet.Name + 'δ��ƵĲ���ģʽ';
        exit;
      end;
    end;
    // ��װ����
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
          if lOneDataSet.DataInfo.IsReturnData then
            // �ύ�������ݼ����ͷ����������ݼ�,��������
            lOneDataSet.ResourceOptions.StoreItems := [sidata, siMeta, siDelta]
          else
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
      // SQL���д���
      lSaveDML.SQL := OneSQLCrypto.SwapCrypto(lOneDataSet.SQL.Text);
      // ������ز���
      for iParam := 0 to lOneDataSet.Params.Count - 1 do
      begin
        lFDParam := lOneDataSet.Params[iParam];
        lOneParam := TOneParam.Create;
        lSaveDML.Params.Add(lOneParam);
        lOneParam.ParamName := lFDParam.Name;
        lOneParam.ParamType := GetEnumName(TypeInfo(TParamType), Ord(lFDParam.ParamType));
        lOneParam.ParamDataType := GetEnumName(TypeInfo(TFieldType), Ord(lFDParam.DataType));
        // ������ֵ
        case lFDParam.DataType of
          ftUnknown:
            begin
              if lFDParam.IsNull then
                lOneParam.ParamValue := const_OneParamIsNull_Value
              else
                lOneParam.ParamValue := varToStr(lFDParam.Value);
            end;
          ftStream, ftBlob:
            begin
              // ת����Base64
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
    // ������
    lDataResult := self.SaveDatasPost(lSaveDMLs);
    if not lDataResult.ResultOK then
    begin
      QErrMsg := '�������Ϣ:' + lDataResult.ResultMsg;
      exit;
    end;
    // �������ݵ�dataSet
    if not self.DataResultToDataSets(lDataResult, QObjectList, true, QErrMsg) then
      exit;
    result := true;
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
  result := TOneDataResult.Create;
  if not self.FConnected then
  begin
    // ����Ѿ����ӹ��Ͳ������ӣ�
    // ���������ϵ�
    result.ResultMsg := 'δ����,����ִ��DoConnect�¼�.';
    exit;
  end;
  if QSaveDMLDatas = nil then
  begin
    result.ResultMsg := '����ı��������Ϊnil';
    exit;
  end;
  if QSaveDMLDatas.Count = 0 then
  begin
    result.ResultMsg := '����ı�������ݵĸ���Ϊ0';
    exit;
  end;
  lResultJsonValue := nil;
  lPostJsonValue := nil;
  try
    lPostJsonValue := OneNeonHelper.ObjectToJson(QSaveDMLDatas, lErrMsg);
    if lErrMsg <> '' then
    begin
      result.ResultMsg := lErrMsg;
      exit;
    end;
    lResultJsonValue := self.PostResultJsonValue(URL_HTTP_HTTPServer_DATA_SaveDatas, lPostJsonValue.ToJSON(), lErrMsg);
    if not self.IsErrTrueResult(lErrMsg) then
    begin
      self.FErrMsg := lErrMsg;
      exit;
    end;
    if not OneNeonHelper.JsonToObject(result, lResultJsonValue, lErrMsg) then
    begin
      result.ResultMsg := '���ص����ݽ�����TOneDataResult����,�޷�֪�����,����:' + lResultJsonValue.ToJSON;
      exit;
    end;
    if result.ResultMsg <> '' then
    begin
      result.ResultMsg := '�������Ϣ:' + result.ResultMsg;
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
  result := false;
  QErrMsg := '';
  lTemStream := nil;
  if DataResult.ResultItems.Count <> QObjectList.Count then
  begin
    QErrMsg := '����������ݼ�����������ĸ��������';
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
    // �ر�
    for i := 0 to lOneDataSets.Count - 1 do
    begin
      lOneDataSet := lOneDataSets[i];
      bCacle := false;
      for iField := 0 to lOneDataSet.Fields.Count - 1 do
      begin
        if lOneDataSet.Fields[iField].FieldKind in [fkInternalCalc] then
        begin
          bCacle := true;
          Break;
        end;
      end;
      lCacleList.Add(bCacle);
      if not QIsSave then
      begin
        if lOneDataSet.Active then
          lOneDataSet.Close;
      end;
    end;
    // ����
    for i := 0 to DataResult.ResultItems.Count - 1 do
    begin
      lDataResultItem := DataResult.ResultItems[i];
      lOneDataSet := lOneDataSets[i];
      if lDataResultItem.ResultPage then
      begin
        // ��ҳ��Ϣ
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
            QErrMsg := '���ݼ�[' + lOneDataSet.Name + ']��д���ַ�������';
            exit;
          end;
          if (lCacleList[i]) or (lOneDataSet.DataInfo.IsReturnData and QIsSave) then
          begin
            // �м����ֶεıȽ��������ģʽ
            tempOneDataSet := TFDMemtable.Create(nil);
            try
              tempOneDataSet.LoadFromStream(lTemStream, sfBinary);
              // lOneDataSet.CopyDataSet(tempOneDataSet);
              lOneDataSet.MergeDataSet(tempOneDataSet, dmDataSet, mmNone);
            finally
              tempOneDataSet.Free;
            end;
          end
          else
          begin
            // �޼����ֶε���������
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
        // �����ļ����Ƚ��ʺϽϴ����ݼ���
        lTemStream := self.DownLoadDataFile(lDataResultItem.ResultContext, QErrMsg);
        try
          if not self.IsErrTrueResult(QErrMsg) then
          begin
            exit;
          end;
          lTemStream.Position := 0;
          if lCacleList[i] then
          begin
            // �м����ֶεıȽ��������ģʽ
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
            // �޼����ֶε���������
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
        // JSON���л�
      end
    end;

    result := true;
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
  result := false;
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
    // �ر�
    for iField := 0 to lOneDataSet.Fields.Count - 1 do
    begin
      if lOneDataSet.Fields[iField].FieldKind in [fkInternalCalc] then
      begin
        bCacle := true;
        Break;
      end;
    end;
    // ������ֵ
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
    // ����
    for i := 0 to QDataResult.ResultItems.Count - 1 do
    begin
      lDataResultItem := QDataResult.ResultItems[i];
      if (i = 0) then
      begin
        // ��ҳ��Ϣ
        if lDataResultItem.ResultPage then
        BEGIN
          lOneDataSet.DataInfo.PageTotal := lDataResultItem.ResultTotal;
          lOneDataSet.DataInfo.PageCount := 0;
          if lOneDataSet.DataInfo.PageSize > 0 then
          begin
            lOneDataSet.DataInfo.PageCount := ceil(lDataResultItem.ResultTotal / lOneDataSet.DataInfo.PageSize);
          end;
        END;
        // ������ֵ
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
            QErrMsg := '���ݼ�[' + lOneDataSet.Name + ']��д���ַ�������';
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
              // �м����ֶεıȽ��������ģʽ
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
              // �޼����ֶε���������
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
        // �����ļ����Ƚ��ʺϽϴ����ݼ���
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
              // �м����ֶεıȽ��������ģʽ
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
              // �޼����ֶε���������
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
        // JSON���л�
      end
    end;
    if isMulite then
    begin
      lOneDataSet.MultiIndex := 0;
    end;
    result := true;
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
  result := nil;
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
        QErrMsg := '���ת��JSON�����쳣:���Ϊnil,������Ϣ:' + TEncoding.UTF8.GetString(lResultBytes.Bytes);
        exit;
      end;
      QErrMsg := TJsonObject(lJsonValue).GetValue('ResultMsg').ToString;
      exit;
    end
    else if (lResultBytes.ContentType.ToLower = 'application/zip') or (lResultBytes.ContentType.ToLower = 'application/octet-stream') then
    begin
      result := TMemoryStream.Create;
      lZipStream := TMemoryStream.Create;
      lZip := TZipFile.Create;
      try
        lZipStream.Write(lResultBytes.Bytes, 0, length(lResultBytes.Bytes));
        lZipStream.Position := 0;
        lZip.Open(lZipStream, TZipMode.zmRead);
        lZip.Read(0, lOutBytes);
        result.Write(lOutBytes, 0, length(lOutBytes));
        self.SetErrTrueResult(QErrMsg);
      finally
        lZip.Free;
        lZipStream.Free;
        if not self.IsErrTrueResult(QErrMsg) then
        begin
          result.Free;
          result := nil;
        end;
      end;
      exit;
    end
    else
    begin
      QErrMsg := 'δ������ͷ������[' + lResultBytes.ContentType + ']';
      exit;
    end;
  finally
    lJonsObj.Free;
    if lResultBytes <> nil then
      lResultBytes.Free;
    lOutBytes := nil;
  end;

end;

// *********�����������ɿ���***********
// 1.�Ȼ�ȡһ����������,��ǳ���������
function TOneConnection.LockTran(QTranInfo: TOneTran): boolean;
var
  lPostJsonValue, lResultJsonValue: TJsonValue;
  lErrMsg: string;
  lDataResult: TOneDataResult;
begin
  result := false;
  if not self.FConnected then
  begin
    // ����Ѿ����ӹ��Ͳ������ӣ�
    // ���������ϵ�
    QTranInfo.Msg := 'δ����,����ִ��DoConnect�¼�.';
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
      QTranInfo.Msg := '���ص����ݽ�����TOneDataResult����,�޷�֪�����,����:' + lResultJsonValue.ToJSON;
      exit;
    end;
    if lDataResult.ResultMsg <> '' then
    begin
      QTranInfo.Msg := '�������Ϣ:' + lDataResult.ResultMsg;
    end;
    if lDataResult.ResultOK then
    begin
      QTranInfo.TranID := lDataResult.ResultData;
      result := true;
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

// 2.��������������,�黹����,���û�黹���ܾú󣬷���˻��Զ�����黹
function TOneConnection.UnLockTran(QTranInfo: TOneTran): boolean;
var
  lPostJsonValue, lResultJsonValue: TJsonValue;
  lErrMsg: string;
  lDataResult: TOneDataResult;
begin
  result := false;
  if not self.FConnected then
  begin
    // ����Ѿ����ӹ��Ͳ������ӣ�
    // ���������ϵ�
    QTranInfo.Msg := 'δ����,����ִ��DoConnect�¼�.';
    exit;
  end;
  if QTranInfo.TranID = '' then
  begin
    QTranInfo.Msg := '����TranIDΪ��,����.';
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
      QTranInfo.Msg := '���ص����ݽ�����TOneDataResult����,�޷�֪�����,����:' + lResultJsonValue.ToJSON;
      exit;
    end;
    if lDataResult.ResultMsg <> '' then
    begin
      QTranInfo.Msg := '�������Ϣ:' + lDataResult.ResultMsg;
    end;
    if lDataResult.ResultOK then
    begin
      QTranInfo.TranID := lDataResult.ResultData;
      result := true;
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

// 3.����������������
function TOneConnection.StartTran(QTranInfo: TOneTran): boolean;
var
  lPostJsonValue, lResultJsonValue: TJsonValue;
  lErrMsg: string;
  lDataResult: TOneDataResult;
begin
  result := false;
  if not self.FConnected then
  begin
    // ����Ѿ����ӹ��Ͳ������ӣ�
    // ���������ϵ�
    QTranInfo.Msg := 'δ����,����ִ��DoConnect�¼�.';
    exit;
  end;
  if QTranInfo.TranID = '' then
  begin
    QTranInfo.Msg := '����TranIDΪ��,����.';
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
      QTranInfo.Msg := '���ص����ݽ�����TOneDataResult����,�޷�֪�����,����:' + lResultJsonValue.ToJSON;
      exit;
    end;
    if lDataResult.ResultMsg <> '' then
    begin
      QTranInfo.Msg := '�������Ϣ:' + lDataResult.ResultMsg;
    end;
    if lDataResult.ResultOK then
    begin
      QTranInfo.TranID := lDataResult.ResultData;
      result := true;
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

// 4.�ύ������������
function TOneConnection.CommitTran(QTranInfo: TOneTran): boolean;
var
  lPostJsonValue, lResultJsonValue: TJsonValue;
  lErrMsg: string;
  lDataResult: TOneDataResult;
begin
  result := false;
  if not self.FConnected then
  begin
    // ����Ѿ����ӹ��Ͳ������ӣ�
    // ���������ϵ�
    QTranInfo.Msg := 'δ����,����ִ��DoConnect�¼�.';
    exit;
  end;
  if QTranInfo.TranID = '' then
  begin
    QTranInfo.Msg := '����TranIDΪ��,����.';
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
      QTranInfo.Msg := '���ص����ݽ�����TOneDataResult����,�޷�֪�����,����:' + lResultJsonValue.ToJSON;
      exit;
    end;
    if lDataResult.ResultMsg <> '' then
    begin
      QTranInfo.Msg := '�������Ϣ:' + lDataResult.ResultMsg;
    end;
    if lDataResult.ResultOK then
    begin
      QTranInfo.TranID := lDataResult.ResultData;
      result := true;
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

// 5.�ع�������������
function TOneConnection.RollbackTran(QTranInfo: TOneTran): boolean;
var
  lPostJsonValue, lResultJsonValue: TJsonValue;
  lErrMsg: string;
  lDataResult: TOneDataResult;
begin
  result := false;
  if not self.FConnected then
  begin
    // ����Ѿ����ӹ��Ͳ������ӣ�
    // ���������ϵ�
    QTranInfo.Msg := 'δ����,����ִ��DoConnect�¼�.';
    exit;
  end;
  if QTranInfo.TranID = '' then
  begin
    QTranInfo.Msg := '����TranIDΪ��,����.';
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
      QTranInfo.Msg := '���ص����ݽ�����TOneDataResult����,�޷�֪�����,����:' + lResultJsonValue.ToJSON;
      exit;
    end;
    if lDataResult.ResultMsg <> '' then
    begin
      QTranInfo.Msg := '�������Ϣ:' + lDataResult.ResultMsg;
    end;
    if lDataResult.ResultOK then
    begin
      QTranInfo.TranID := lDataResult.ResultData;
      result := true;
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
  result := false;
  QVirtualInfo.ErrMsg := '';
  if not self.FConnected then
  begin
    // ����Ѿ����ӹ��Ͳ������ӣ�
    // ���������ϵ�
    QVirtualInfo.ErrMsg := 'δ����,����ִ��DoConnect�¼�.';
    exit;
  end;
  if QVirtualInfo.VirtualCode = '' then
  begin
    QVirtualInfo.ErrMsg := '����·������[VirtualCode]Ϊ��,����';
    exit;
  end;
  if QVirtualInfo.LocalFile = '' then
  begin
    QVirtualInfo.ErrMsg := '����·���ļ�[LocalFile]Ϊ��,����';
    exit;
  end;
  // �ж���û��Ҫ���ص��ļ�
  if not TPath.HasExtension(QVirtualInfo.LocalFile) then
  begin
    QVirtualInfo.ErrMsg := '����·���ļ�[LocalFile]�ļ���չ��Ϊ��,�޷�ȷ����·�������ļ�';
    exit;
  end;
  if not TFile.Exists(QVirtualInfo.LocalFile) then
  begin
    QVirtualInfo.ErrMsg := '����·���ļ�[LocalFile]�ļ�������';
    exit;
  end;
  if QVirtualInfo.RemoteFile = '' then
  begin
    QVirtualInfo.ErrMsg := '·���ļ�[RemoteFile]Ϊ��,����';
    exit;
  end;
  // ͳһ��liunx��ʽ
  // winĬ���ļ�·����\,liun��/ ��win֧��/
  QVirtualInfo.LocalFile := OneFileHelper.FormatPath(QVirtualInfo.LocalFile);
  QVirtualInfo.RemoteFile := OneFileHelper.FormatPath(QVirtualInfo.RemoteFile);
  if not TPath.HasExtension(QVirtualInfo.RemoteFile) then
  begin
    lFileName := TPath.GetFileName(QVirtualInfo.LocalFile);
    QVirtualInfo.RemoteFile := OneFileHelper.CombinePath(QVirtualInfo.RemoteFile, lFileName);
  end;
  // ��ʼ�ύ
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
      QVirtualInfo.ErrMsg := '���ص����ݽ�����TOneDataResult����,�޷�֪�����,����:' + lResultJsonValue.ToJSON;
      exit;
    end;
    if lResult.ResultMsg <> '' then
    begin
      QVirtualInfo.ErrMsg := '�������Ϣ:' + lResult.ResultMsg;
    end;
    if lResult.ResultSuccess then
    begin
      // �п����ϴ��ļ����ƺ�����ļ����Ʋ�һ��
      QVirtualInfo.RemoteFileName := lResult.ResultData;
      result := true;
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
  result := false;
  lResultBytes := nil;
  QVirtualInfo.ErrMsg := '';
  if not self.FConnected then
  begin
    // ����Ѿ����ӹ��Ͳ������ӣ�
    // ���������ϵ�
    QVirtualInfo.ErrMsg := 'δ����,����ִ��DoConnect�¼�.';
    exit;
  end;
  if QVirtualInfo.VirtualCode = '' then
  begin
    QVirtualInfo.ErrMsg := '����·������[VirtualCode]Ϊ��,����';
    exit;
  end;
  if QVirtualInfo.RemoteFile = '' then
  begin
    QVirtualInfo.ErrMsg := '·���ļ�[RemoteFile]Ϊ��,����';
    exit;
  end;
  // �ж���û��Ҫ���ص��ļ�
  if not TPath.HasExtension(QVirtualInfo.RemoteFile) then
  begin
    QVirtualInfo.ErrMsg := '·���ļ�[RemoteFile]�ļ���չ��Ϊ��,�޷�ȷ����·�������ļ�';
    exit;
  end;
  if QVirtualInfo.LocalFile = '' then
  begin
    self.ErrMsg := '����·���ļ�[LocalFile]Ϊ��,����';
    exit;
  end;

  QVirtualInfo.RemoteFile := OneFileHelper.FormatPath(QVirtualInfo.RemoteFile);
  QVirtualInfo.LocalFile := OneFileHelper.FormatPath(QVirtualInfo.LocalFile);
  lAFileName := TPath.GetFileName(QVirtualInfo.RemoteFile);
  if lAFileName = '' then
  begin
    self.ErrMsg := 'Զ���ļ�����Ϊ��';
    exit;
  end;
  if not TPath.HasExtension(QVirtualInfo.LocalFile) then
  begin
    // ��װ�����ļ�
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
      QVirtualInfo.ErrMsg := '���ת��JSON�����쳣:���Ϊnil,������Ϣ:' + TEncoding.UTF8.GetString(lResultBytes.Bytes);
      exit;
    end;
    if not OneNeonHelper.JsonToObject(lResult, lJsonValue, tempMsg) then
    begin
      QVirtualInfo.ErrMsg := tempMsg;
      exit;
    end;
    if not lResult.ResultSuccess then
    begin
      QVirtualInfo.ErrMsg := '�������Ϣ:' + lResult.ResultMsg;
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
      result := true;
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
  result := false;
  QVirtualInfo.ErrMsg := '';
  if not self.FConnected then
  begin
    // ����Ѿ����ӹ��Ͳ������ӣ�
    // ���������ϵ�
    QVirtualInfo.ErrMsg := 'δ����,����ִ��DoConnect�¼�.';
    exit;
  end;
  // ͳһ��liunx��ʽ
  // winĬ���ļ�·����\,liun��/ ��win֧��/
  QVirtualInfo.LocalFile := OneFileHelper.FormatPath(QVirtualInfo.LocalFile);
  QVirtualInfo.RemoteFile := OneFileHelper.FormatPath(QVirtualInfo.RemoteFile);
  if QVirtualInfo.VirtualCode = '' then
  begin
    QVirtualInfo.ErrMsg := '����·������[VirtualCode]Ϊ��,����';
    exit;
  end;
  // �ж���û��Ҫ���ص��ļ�
  if not TPath.HasExtension(QVirtualInfo.RemoteFile) then
  begin
    QVirtualInfo.ErrMsg := 'Ҫɾ�����ļ�[RemoteFile]��ָ��Ҫɾ�����ļ�·�����ļ�����';
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
      QVirtualInfo.ErrMsg := '���ص����ݽ�����TOneDataResult����,�޷�֪�����,����:' + lResultJsonValue.ToJSON;
      exit;
    end;
    if lResult.ResultMsg <> '' then
    begin
      QVirtualInfo.ErrMsg := '�������Ϣ:' + lResult.ResultMsg;
    end;
    if lResult.ResultSuccess then
    begin
      result := true;
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
  result := false;
  QVirtualTask.ErrMsg := '';
  QVirtualTask.TaskID := '';
  if not self.FConnected then
  begin
    // ����Ѿ����ӹ��Ͳ������ӣ�
    // ���������ϵ�
    QVirtualTask.ErrMsg := 'δ����,����ִ��DoConnect�¼�.';
    exit;
  end;
  if QVirtualTask.FileChunSize <= 0 then
    QVirtualTask.FileChunSize := 1024 * 1024 * 1;
  if (QVirtualTask.UpDownMode <> '�ϴ�') and (QVirtualTask.UpDownMode <> '����') then
  begin
    QVirtualTask.ErrMsg := '�ļ�ģʽ[UpDownMode]ֻ�����ϴ�������';
    exit;
  end;
  if QVirtualTask.VirtualCode = '' then
  begin
    QVirtualTask.ErrMsg := '����·������[VirtualCode]Ϊ��,����';
    exit;
  end;
  if QVirtualTask.LocalFile = '' then
  begin
    QVirtualTask.ErrMsg := '�����ļ�[LocateFile]Ϊ��,����';
    exit;
  end;
  if (QVirtualTask.UpDownMode = '�ϴ�') then
  begin
    if not TPath.HasExtension(QVirtualTask.LocalFile) then
    begin
      QVirtualTask.ErrMsg := '�ϴ������ļ�[LocateFile]����ֻ��·��,�޷�ȷ��Ҫ�ϴ����ļ�';
      exit;
    end;
    if not TFile.Exists(QVirtualTask.LocalFile) then
    begin
      QVirtualTask.ErrMsg := '�����ڱ����ļ�[' + QVirtualTask.LocalFile + '],����';
      exit;
    end;
    // ��ȡ�ļ���С
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
    QVirtualTask.ErrMsg := '·���ļ�[RemoteFile]���ɰ���������ֻ����·��/xxx/xxxx/xx';
    exit;
  end;
  if not TPath.HasExtension(QVirtualTask.RemoteFile) then
  begin
    if (QVirtualTask.UpDownMode = '�ϴ�') then
    begin
      // ��RemoteFile��װ���ļ����ƣ��ӱ��� LocateFile
      lFileName := TPath.GetFileName(QVirtualTask.LocalFile);
      QVirtualTask.RemoteFile := OneFileHelper.CombinePath(QVirtualTask.RemoteFile, lFileName);
    end
    else if (QVirtualTask.UpDownMode = '����') then
    begin
      //
      QVirtualTask.ErrMsg := '����·���ļ�[RemoteFile]�������ļ���,�޷�֪��Ҫ���ص��ļ�';
      exit;
    end;
  end;
  //
  if (QVirtualTask.UpDownMode = '����') then
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
      // ɾ���ϵ��ļ�
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
      QVirtualTask.ErrMsg := '���ص����ݽ�����TResult<TVirtualTask>����,�޷�֪�����,����:' + lResultJsonValue.ToJSON;
      exit;
    end;
    if lResult.ResultMsg <> '' then
    begin
      QVirtualTask.ErrMsg := '�������Ϣ:' + lResult.ResultMsg;
    end;
    if lResult.ResultSuccess then
    begin
      // ��ֵ�����һЩ�������
      QVirtualTask.TaskID := lResult.ResultData.TaskID;
      QVirtualTask.FileTotalSize := lResult.ResultData.FileTotalSize;
      QVirtualTask.FileName := lResult.ResultData.FileName;
      QVirtualTask.NewFileName := lResult.ResultData.NewFileName;
      result := true;
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
  result := false;
  QVirtualTask.UpDownMode := '�ϴ�';
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
    QUpDownChunkCallBack(emUpDownMode.UpLoad, emUpDownChunkStatus.upDownGetTask, 0, 0, '');
    QVirtualTask.FilePosition := 0;
  end
  else
  begin
    // ��Ϊ������¿���������
  end;
  // ��ʼ��ȡ�ļ��ϴ�
  lFileStream := TFileStream.Create(QVirtualTask.LocalFile, fmopenRead);
  lResult := TActionResult<string>.Create;
  try
    QVirtualTask.FileTotalSize := lFileStream.Size;
    if Assigned(QUpDownChunkCallBack) then
    begin
      QUpDownChunkCallBack(emUpDownMode.UpLoad, emUpDownChunkStatus.upDownStart, QVirtualTask.FileTotalSize, 0, '��ʼ�ϴ�');
    end;
    while QVirtualTask.FilePosition < QVirtualTask.FileTotalSize do
    begin
      lResult.ResultSuccess := false;
      lResult.ResultMsg := '';
      lResult.ResultCode := '';
      lResult.ResultData := '';
      // ��ȡ�����ϴ�������
      lFileStream.Position := QVirtualTask.FilePosition;
      iChunSize := QVirtualTask.FileChunSize;
      if lFileStream.Position + iChunSize > QVirtualTask.FileTotalSize then
      begin
        iChunSize := QVirtualTask.FileTotalSize - lFileStream.Position;
      end;
      setLength(lBytes, iChunSize);
      lFileStream.Read(lBytes, iChunSize);
      QVirtualTask.StreamBase64 := TNetEncoding.Base64.EncodeBytesToString(lBytes);
      // ��ʼ�ϴ�����
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
          QVirtualTask.ErrMsg := '���ص����ݽ�����TResult<string>����,�޷�֪�����,����:' + lResultJsonValue.ToJSON;
          exit;
        end;
        if lResult.ResultMsg <> '' then
        begin
          QVirtualTask.ErrMsg := '�������Ϣ:' + lResult.ResultMsg;
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
        // ��ȡλ�ü���ȥ
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
    result := true;
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
  result := false;
  isEnd := false;
  QVirtualTask.UpDownMode := '����';
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
    // ������
  end;
  // ��ʼ��ȡ�ļ��ϴ�
  lFileStream := TFileStream.Create(QVirtualTask.LocalFile, fmCreate or fmOpenReadWrite);
  lResult := TActionResult<string>.Create;
  try
    if Assigned(QUpDownChunkCallBack) then
    begin
      QUpDownChunkCallBack(emUpDownMode.DownLoad, emUpDownChunkStatus.upDownStart, QVirtualTask.FileTotalSize, 0, '��ʼ����');
    end;
    while QVirtualTask.FilePosition < QVirtualTask.FileTotalSize do
    begin
      lResult.ResultSuccess := false;
      lResult.ResultMsg := '';
      lResult.ResultCode := '';
      lResult.ResultData := '';
      // ��ʼ�ϴ�����
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
          QVirtualTask.ErrMsg := '���ص����ݽ�����TResult<string>����,�޷�֪�����,����:' + lResultJsonValue.ToJSON;
          exit;
        end;
        if lResult.ResultMsg <> '' then
        begin
          QVirtualTask.ErrMsg := '�������Ϣ:' + lResult.ResultMsg;
        end;
        if not lResult.ResultSuccess then
        begin
          exit;
        end;
        // д����
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
    result := true;
  finally
    lFileStream.Free;
    lResult.Free;

  end;
  if (isEnd) and (result) then
  begin
    //�����ļ��ɹ�
    QUpDownChunkCallBack(emUpDownMode.DownLoad, emUpDownChunkStatus.upDownSaveFileOk, QVirtualTask.FileTotalSize, QVirtualTask.FilePosition, QVirtualTask.ErrMsg)
  end;
end;

function TOneConnection.OneGetZTList(Var QErrMsg: string): TList<TZTInfo>;
var
  lJsonValue: TJsonValue;
  lServerResult: TActionResult<TList<TZTInfo>>;
begin
  result := nil;
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
      self.FErrMsg := '���ص����ݽ�����TActionResult<TList<TZTInfo>>����,�޷�֪�����,����:' + lJsonValue.ToJSON;
      exit;
    end;
    if not lServerResult.ResultSuccess then
    begin
      self.FErrMsg := '�������Ϣ:' + lServerResult.ResultMsg;
      exit;
    end;
    result := lServerResult.ResultData;
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
  result := nil;
  lList := nil;
  lList := self.OneGetZTList(QErrMsg);
  try
    if lList = nil then
      exit;
    result := TStringList.Create;
    for i := 0 to lList.Count - 1 do
    begin
      result.Add(lList[i].ZTCode + '=' + lList[i].ZTCaption);
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
  result := -1;
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
      QErrMsg := '���ص����ݽ�����TResult<TClientConnect>����,�޷�֪�����,����:' + lResultJsonValue.ToJSON;
      exit;
    end;
    if not lServerResult.ResultSuccess then
    begin
      QErrMsg := '�������Ϣ:' + lServerResult.ResultMsg;
      exit;
    end;
    result := lServerResult.ResultData;
    IsOK := true;
  finally
    if not IsOK then
    begin
      result := -1;
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
  result := TList<int64>.Create;
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
    lServerResult.ResultData := result;
    if not OneNeonHelper.JsonToObject(lServerResult, lResultJsonValue, lErrMsg) then
    begin
      QErrMsg := '���ص����ݽ�����TResult<TClientConnect>����,�޷�֪�����,����:' + lResultJsonValue.ToJSON;
      exit;
    end;
    if not lServerResult.ResultSuccess then
    begin
      QErrMsg := '�������Ϣ:' + lServerResult.ResultMsg;
      exit;
    end;
    IsOK := true;
  finally
    if not IsOK then
    begin
      result.Free;
      result := nil;
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

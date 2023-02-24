unit OneClientResult;

// 终端的Data需要自已解析释放
interface

type
  TClientConnect = record
  public
    ConnectSecretkey: string;
    ClientIP: string; // 客户端传上来的客户端IP
    ClientMac: string; // 客户端传上来的客户端Mac地址
    TokenID: string; // 服务端返回的TokenID
    PrivateKey: string; // 服务端返回的私钥
    // public
    // property ConnectSecretkey: string read FConnectSecretkey
    // write FConnectSecretkey;
    // property ClientIP: string read FClientIP write FClientIP;
    // property ClientMac: string read FClientMac write FClientMac;
    // property TokenID: string read FTokenID write FTokenID;
    // property PrivateKey: string read FPrivateKey write FPrivateKey;
  end;

  TActionResult<T> = class
  private
    FResultSuccess: boolean;
    FResultCode: string;
    FResultMsg: string;
    FResultData: T;
    FFreeResultData: boolean;
    FFreeListItem: boolean;
  public
    constructor Create();
  public
    property ResultSuccess: boolean read FResultSuccess write FResultSuccess;
    property ResultCode: string read FResultCode write FResultCode;
    property ResultMsg: string read FResultMsg write FResultMsg;
    property ResultData: T read FResultData write FResultData;
  end;

implementation

constructor TActionResult<T>.Create();
begin
  inherited Create;
  self.FResultSuccess := false;
end;

end.

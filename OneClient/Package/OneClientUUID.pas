unit OneClientUUID;

interface

uses system.Classes, system.SysUtils, OneClientConnect,
  system.Generics.Collections, OneClientConst;

type

  [ComponentPlatformsAttribute(OneAllPlatforms)]
  TOneUUID = class(TComponent)
  private
    FConnection: TOneConnection;
    // 缓存多少个ID
    FCacheCount: Integer;
    FCacheList: TList<int64>;
    //
    FErrMsg: string;
  private
    // 获取连接
    function GetConnection: TOneConnection;
    procedure SetConnection(const AValue: TOneConnection);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    // 预生成的一堆的在里面取其中一个,不然每一次取多要连接一次服务端
    function GetUUID(): int64;
    // 从服务端获取一个新的UUID
    function GetNewUUID(): int64;

  published
    property CacheCount: Integer read FCacheCount write FCacheCount default 100;
    property Connection: TOneConnection read GetConnection write SetConnection;
    /// <param name="ErrMsg">错误信息</param>
    property ErrMsg: string read FErrMsg write FErrMsg;
  end;

implementation

constructor TOneUUID.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCacheList := TList<int64>.Create;
end;

destructor TOneUUID.Destroy;
begin
  FCacheList.Clear;
  FCacheList.Free;
  inherited Destroy;
end;

function TOneUUID.GetConnection: TOneConnection;
begin
  Result := Self.FConnection;
end;

procedure TOneUUID.SetConnection(const AValue: TOneConnection);
begin
  Self.FConnection := AValue;
end;

function TOneUUID.GetUUID(): int64;
var
  tempList: TList<int64>;
  i: Integer;
  lErrMsg: string;
begin
  Result := -1;
  if FCacheList.Count > 0 then
  begin
    // 取最后一个,防止Move移动
    Result := FCacheList.Last;
    FCacheList.Delete(FCacheList.Count - 1);
    exit;
  end;
  if Self.FConnection = nil then
    Self.FConnection := OneClientConnect.Unit_Connection;
  if Self.FConnection = nil then
  begin
    Self.FErrMsg := '数据集Connection=nil';
    exit;
  end;
  tempList := nil;
  tempList := Self.FConnection.GetUUIDs(Self.FCacheCount, lErrMsg);
  try
    Self.FErrMsg := lErrMsg;
    // 倒的插入,从大到小，取时从尾部取出从小到大
    for i := tempList.Count - 1 downto 0 do
    begin
      FCacheList.add(tempList[i]);
    end;
    // 取最后一个,防止Move移动
    Result := FCacheList.Last;
    FCacheList.Delete(FCacheList.Count - 1);
  finally
    if tempList <> nil then
    begin
      tempList.Clear;
      tempList.Free;
    end;
  end;

end;

function TOneUUID.GetNewUUID(): int64;
var
  lErrMsg: string;
begin
  Result := -1;
  if Self.FConnection = nil then
    Self.FConnection := OneClientConnect.Unit_Connection;
  if Self.FConnection = nil then
  begin
    Self.FErrMsg := '数据集Connection=nil';
    exit;
  end;
  Result := Self.FConnection.GetUUID(lErrMsg);
  Self.FErrMsg := lErrMsg;
end;

end.

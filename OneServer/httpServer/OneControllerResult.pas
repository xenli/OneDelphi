unit OneControllerResult;

interface

uses system.Generics.Collections, system.Rtti, OneRttiHelper, OneHttpConst;

type
  emOneResultMode = (resultString, OneGet, OnePost, OneForm, OneUpload, OneDownload);

type
  IActionResult = interface;

  IActionResult = interface
    ['{FBE2DEB1-9319-4DD4-93EC-17FF6E68A2C3}']

  end;

  //

  TActionResult<T> = class
  private
    FResultSuccess: boolean;
    FResultCode: string;
    FResultMsg: string;
    FResultData: T;
    FIsFile: boolean; // 是否文件返回
    FFreeResultData: boolean;
    FFreeListItem: boolean;
  private
    function GetData(): T;
  public
    /// <summary>
    /// 创建一个结果集,QFreeResultData是否释放ResultData数据,
    /// QFreeListItem如果ReslutData是List等容器,是否释放item里面对象
    /// </summary>
    /// <returns></returns>
    constructor Create(QFreeResultData: boolean; QFreeListItem: boolean);
    destructor Destroy; override;
    procedure SetResultTrue();
    // 文件相关
    procedure SetResultTrueFile();
    function IsResultFile(): boolean;
    procedure SetTokenFail();
  public
    // 和前端保持一至小写
    property ResultSuccess: boolean read FResultSuccess write FResultSuccess;
    property ResultCode: string read FResultCode write FResultCode;
    property ResultMsg: string read FResultMsg write FResultMsg;
    property ResultData: T read FResultData write FResultData;
  end;

implementation

constructor TActionResult<T>.Create(QFreeResultData: boolean; QFreeListItem: boolean);
begin
  inherited Create;
  self.FFreeResultData := QFreeResultData;
  self.FFreeListItem := QFreeListItem;
  self.FResultSuccess := false;
  self.ResultCode := HTTP_ResultCode_Fail;
  self.FIsFile := false;
end;

destructor TActionResult<T>.Destroy;
var
  lTValue: TValue;
begin

  if FFreeResultData then
  begin
    // 判断是不是对象
    // 要自动释放类的，需要释放
    TValue.Make(@self.ResultData, system.TypeInfo(T), lTValue);
    OneRttiHelper.FreeTValue(lTValue, self.FFreeListItem);
  end;
  inherited Destroy;
end;

procedure TActionResult<T>.SetResultTrue();
begin
  self.FResultSuccess := true;
  self.ResultCode := HTTP_ResultCode_True;
end;

procedure TActionResult<T>.SetResultTrueFile();
begin
  self.FIsFile := true;
  self.FResultSuccess := true;
  self.ResultCode := HTTP_ResultCode_True;
end;

function TActionResult<T>.GetData(): T;
begin
  Result := self.FResultData
end;

function TActionResult<T>.IsResultFile(): boolean;
begin
  Result := self.FIsFile;
end;

procedure TActionResult<T>.SetTokenFail();
begin
  self.FResultCode := HTTP_ResultCode_TokenFail;
  self.FResultMsg := 'Token验证失败,请重新登陆';
end;

end.

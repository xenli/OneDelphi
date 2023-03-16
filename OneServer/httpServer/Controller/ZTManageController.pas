unit ZTManageController;

interface

uses OneHttpController, OneHttpRouterManage, OneHttpCtxtResult, OneTokenManage,
  system.Generics.Collections, OneControllerResult;

type

  TZTInfo = class
  private
    FZTCode: string;
    FZTCaption: string;
  public
    property ZTCode: string read FZTCode write FZTCode;
    property ZTCaption: string read FZTCaption write FZTCaption;
  end;

  TOneZTController = class(TOneControllerBase)
  public
    function OneGetZTList(): TActionResult<TList<TZTInfo>>;
  end;

function CreateNewOneZTController(QRouterItem: TOneRouterWorkItem): TObject;

implementation

uses OneGlobal, OneZTManage;

function CreateNewOneZTController(QRouterItem: TOneRouterWorkItem): TObject;
var
  lController: TOneZTController;
begin
  // 自定义创建控制器类，否则会按 TPersistentclass.create
  // 最好自定义一个好
  lController := TOneZTController.Create;
  // 挂载RTTI信息
  lController.RouterItem := QRouterItem;
  result := lController;
end;

function TOneZTController.OneGetZTList(): TActionResult<TList<TZTInfo>>;
var
  lOneGlobal: TOneGlobal;
  lZTList: TList<TOneZTSet>;
  lZTInfo: TZTInfo;
  i: integer;
begin
  // 结构体会自动释放,设成true,false多一样
  result := TActionResult < TList < TZTInfo >>.Create(true, true);
  lOneGlobal := TOneGlobal.GetInstance();
  lZTList := lOneGlobal.ZTMangeSet.ZTSetList;
  result.ResultData := TList<TZTInfo>.Create;
  for i := 0 to lZTList.Count - 1 do
  begin
    lZTInfo := TZTInfo.Create;
    result.ResultData.Add(lZTInfo);
    lZTInfo.ZTCode := lZTList[i].ZTCode;
    lZTInfo.ZTCaption := lZTList[i].ZTCaption;
  end;
  result.SetResultTrue();
end;

initialization

// 单例模式注册
OneHttpRouterManage.GetInitRouterManage().AddHTTPSingleWork('/OneServer/ZTManage', TOneZTController, 0, CreateNewOneZTController);

finalization

end.

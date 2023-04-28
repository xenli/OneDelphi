unit DemoWebFileController;

interface

uses OneHttpController, OneHttpCtxtResult, OneHttpRouterManage, System.SysUtils,
  System.Generics.Collections, System.Contnrs, System.Classes, System.IOUtils,
  FireDAC.Comp.Client, Data.DB, System.JSON, OneControllerResult, OneFileHelper, Web.ReqMulti,
  OneMultipart, Web.ReqFiles;

type
  TDemoWebFileController = class(TOneControllerBase)
  public
    // OneGet取url参数。通过web预览图片
    function OneGetFile(fileName: string): TActionResult<string>;
    // 解析 multipart/form-data提交的数据,只需要参数类型是 TOneMultipartDecode就行，其它的交给底程处理解析
    function WebPostFormData(QFormData: TOneMultipartDecode): TActionResult<string>;
  end;

implementation

function CreateNewDemoWebFileController(QRouterItem: TOneRouterWorkItem): TObject;
var
  lController: TDemoWebFileController;
begin
  // 自定义创建控制器类，否则会按 TPersistentclass.create
  // 最好自定义一个好
  lController := TDemoWebFileController.Create;
  // 挂载RTTI信息
  lController.RouterItem := QRouterItem;
  result := lController;
end;

function TDemoWebFileController.OneGetFile(fileName: string): TActionResult<string>;
var
  lFileName: string;
begin
  result := TActionResult<string>.Create(true, false);
  // 比如 D:\test目录下
  lFileName := OneFileHelper.CombinePath('D:\test', fileName);
  if not TFile.Exists(lFileName) then
  begin
    result.ResultMsg := '文件不存在';
    exit;
  end;
  // 返回的文件物理路径放在这
  result.ResultData := lFileName;
  // 代表返回文件
  result.SetResultTrueFile();
end;

function TDemoWebFileController.WebPostFormData(QFormData: TOneMultipartDecode): TActionResult<string>;
var
  i: integer;
  lWebRequestFile: TOneRequestFile;
  tempStream: TCustomMemoryStream;
begin
  result := TActionResult<string>.Create(false, false);
  // 接收到的文件
  for i := 0 to QFormData.Files.count - 1 do
  begin
    lWebRequestFile := TOneRequestFile(QFormData.Files.items[i]);
    result.ResultData := result.ResultData + '当前接收到文件参数[' + lWebRequestFile.FieldName + ']' + '文件名称[' + Utf8Decode(lWebRequestFile.fileName) + ']' + #10#13;
    // 文件流 ,至于要咱样是业务问题
    tempStream := TCustomMemoryStream(lWebRequestFile.Stream);
    tempStream.Position := 0;
    tempStream.SaveToFile(lWebRequestFile.fileName);
  end;
  // 接收到的参数,自已的业务自已分析
  for i := 0 to QFormData.ContentFields.count - 1 do
  begin
    result.ResultData := result.ResultData + '当前接收到参数[' + QFormData.ContentFields[i] + ']' + #10#13;
  end;
  result.SetResultTrue();
end;

// 注册到路由
initialization

// 注意，路由名称 不要一样，否则会判定已注册过，跳过
// 多例模式注册
OneHttpRouterManage.GetInitRouterManage().AddHTTPPoolWork('DemoWebFile', TDemoWebFileController, 10, CreateNewDemoWebFileController);

finalization

end.

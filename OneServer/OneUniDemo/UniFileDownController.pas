unit UniFileDownController;

interface

uses
  system.StrUtils, system.SysUtils, Math, system.JSON, system.Threading, system.Classes,
  OneHttpController, OneHttpRouterManage, OneHttpCtxtResult, OneTokenManage, OneHttpConst,
  system.Generics.Collections, OneControllerResult, FireDAC.Comp.Client, Data.DB, OneGuID,
  OneMultipart, system.Variants;

type

  TUniFileDownController = class(TOneControllerBase)
  public
    // Get方式和  DataToExcel无区别，只是加上OneGet代表只支持Get请求
    // 可以直接在游览器测试效果
    // Get请求参数放在 url?id=xxxx 当然也可以不需要参数，自已业务自已看着办
    function OneGetDataToExcel(id: string): TActionResult<string>;

    // 获取图片测试
    function OneGetImg(): TActionResult<string>;
  end;

function CreateNewUniFileDownController(QRouterItem: TOneRouterWorkItem): TObject;

implementation

uses OneGlobal, OneZTManage, ExcelXP, ComObj, Winapi.Windows, ActiveX;

function CreateNewUniFileDownController(QRouterItem: TOneRouterWorkItem): TObject;
var
  lController: TUniFileDownController;
begin
  // 自定义创建控制器类，否则会按 TPersistentclass.create
  // 最好自定义一个好
  lController := TUniFileDownController.Create;
  // 挂载RTTI信息
  lController.RouterItem := QRouterItem;
  result := lController;
end;

function TUniFileDownController.OneGetDataToExcel(id: string): TActionResult<string>;
var
  lDataSet: TFDMemTable;
  i, iRow, iCol: integer;
  ExcelApp: Variant;
  Workbook: Variant;
  Worksheet: Variant;
  lFileName: string;
  tempStr: string;
begin
  // 这边数据集来源跟据你实际业务来获取数据,我这边只是Demo直接创建一个数据集，
  // 添加数据，导出数据
  tempStr := id;
  result := TActionResult<string>.Create(false, false);
  lDataSet := TFDMemTable.Create(nil);
  try

    lDataSet.FieldDefs.Add('name', ftString, 20, false);
    lDataSet.FieldDefs.Add('age', ftInteger, 0, True);
    lDataSet.CreateDataSet();
    // 动态添加几条数据
    for i := 0 to 9 do
    begin
      lDataSet.Append;
      lDataSet.FieldByName('name').AsString := 'flm' + i.ToString();
      lDataSet.FieldByName('age').AsInteger := i;
      lDataSet.Post;
    end;
    // DataSet转成Excel

    // 1.创建excel
    CoInitialize(nil); // 初始化COM
    try
      ExcelApp := CreateOleObject('Excel.Application');
      ExcelApp.Visible := false;
      ExcelApp.DisplayAlerts := false;
      Workbook := ExcelApp.Workbooks.Add;
      Worksheet := Workbook.Worksheets[1];
      // 2.写入标题
      for iCol := 0 to lDataSet.FieldCount - 1 do
      begin
        Worksheet.Cells[1, iCol + 1].Value := lDataSet.Fields[iCol].FieldName;
      end;
      // 3.写入数据
      iRow := 2;
      lDataSet.First;
      while not lDataSet.Eof do
      begin
        for iCol := 0 to lDataSet.FieldCount - 1 do
        begin
          // 注意这边不可用    lDataSet.Fields[iCol].value;
          // 要写入具体类型，可以按字段类型进行判断,我这边直接全写入字符串
          Worksheet.Cells[iRow, iCol + 1].Value := lDataSet.Fields[iCol].AsString;
        end;
        Inc(iRow);
        lDataSet.Next;
      end;
      // 保存文件到临时地址,获取Exe运行目录指定,名称什么的防冲突加上时间自已写
      // 我这边只是个测试
      lFileName := 'd:\test.xlsx';
      Workbook.SaveAs(lFileName);
      Workbook.Close;
      ExcelApp.Quit;
      // 返回文件物理地址
      result.ResultData := lFileName;
      // 设定返回文件
      result.SetResultTrueFile();
    finally
      Workbook := Unassigned;
      Worksheet := Unassigned;
      ExcelApp := Unassigned;
      CoUninitialize; // 反初始化COM
    end;
  finally
    lDataSet.Free;
  end;
end;

function TUniFileDownController.OneGetImg(): TActionResult<string>;
begin
  result := TActionResult<string>.Create(false, false);
  // 自已改动来自哪
  result.ResultData := 'd:\123.jpg';
  // 设定返回文件
  result.SetResultTrueFile();
end;

initialization

// 单例模式注册
OneHttpRouterManage.GetInitRouterManage().AddHTTPSingleWork('/UniDemo/FileDown', TUniFileDownController, 0, CreateNewUniFileDownController);

finalization

end.

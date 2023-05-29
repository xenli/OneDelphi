unit frmDemoFastApi;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, System.Generics.Collections,
  OneClientHelper, OneClientConnect, dxBar, cxClasses, System.ImageList,
  Vcl.ImgList, cxImageList, cxGraphics, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  OneClientDataSet, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, cxNavigator,
  dxDateRanges, dxScrollbarAnnotations, cxDBData, cxGridLevel,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGridCustomView,
  cxGrid, cxDropDownEdit, cxCheckBox, cxImageComboBox, dxBarBuiltInMenu,
  cxContainer, Vcl.Menus, cxTL, cxMaskEdit, cxTLdxBarBuiltInMenu,
  cxInplaceContainer, cxDBTL, cxTLData, cxGridBandedTableView,
  cxGridDBBandedTableView, cxButtons, cxMemo, cxDBEdit, cxGroupBox, cxTextEdit,
  cxLabel, cxPC, System.StrUtils, System.TypInfo, System.JSON, OneClientResult, OneNeonHelper;

type
  TfrDemoFastApi = class(TForm)
    plSet: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label17: TLabel;
    edHTTPHost: TEdit;
    edHTTPPort: TEdit;
    edConnectSecretkey: TEdit;
    tbClientConnect: TButton;
    tbClientDisConnect: TButton;
    edZTCode: TEdit;
    OneConnection: TOneConnection;
    BarManager: TdxBarManager;
    barMain: TdxBar;
    tbSave: TdxBarLargeButton;
    tbDel: TdxBarLargeButton;
    tbApiEdit: TdxBarLargeButton;
    tbNew: TdxBarLargeButton;
    tbRefsh: TdxBarLargeButton;
    cxImageList1: TcxImageList;
    qryFastApi: TOneDataSet;
    qryFastApiFApiID: TWideStringField;
    qryFastApiFPApiID: TWideStringField;
    qryFastApiFApiCode: TWideStringField;
    qryFastApiFApiCaption: TWideStringField;
    qryFastApiFOrderNumber: TIntegerField;
    qryFastApiFIsMenu: TBooleanField;
    qryFastApiFIsEnabled: TBooleanField;
    dsFastApi: TDataSource;
    grdMain: TcxGrid;
    vwMain: TcxGridDBTableView;
    vwMainFOrderNumber: TcxGridDBColumn;
    vwMainFApiCode: TcxGridDBColumn;
    vwMainFApiCaption: TcxGridDBColumn;
    vwMainFIsEnabled: TcxGridDBColumn;
    lvMain: TcxGridLevel;
    dsData: TDataSource;
    qryData: TOneDataSet;
    qryDataFDataID: TWideStringField;
    qryDataFPDataID: TWideStringField;
    qryDataFApiID: TWideStringField;
    qryDataFTreeCode: TWideStringField;
    qryDataFDataName: TWideStringField;
    qryDataFDataCaption: TWideStringField;
    qryDataFDataJsonName: TWideStringField;
    qryDataFDataJsonType: TWideStringField;
    qryDataFDataZTCode: TWideStringField;
    qryDataFDataTable: TWideStringField;
    qryDataFDataStoreName: TWideStringField;
    qryDataFDataPrimaryKey: TWideStringField;
    qryDataFDataOpenMode: TWideStringField;
    qryDataFDataPageSize: TIntegerField;
    qryDataFDataUpdateMode: TWideStringField;
    qryDataFDataSQL: TMemoField;
    qryDataFMinAffected: TIntegerField;
    qryDataFMaxAffected: TIntegerField;
    dsField: TDataSource;
    qryField: TOneDataSet;
    qryFieldFFieldID: TWideStringField;
    qryFieldFDataID: TWideStringField;
    qryFieldFApiID: TWideStringField;
    qryFieldFOrderNumber: TIntegerField;
    qryFieldFFieldName: TWideStringField;
    qryFieldFFieldCaption: TWideStringField;
    qryFieldFFieldJsonName: TWideStringField;
    qryFieldFFieldKind: TWideStringField;
    qryFieldFFieldDataType: TWideStringField;
    qryFieldFFieldSize: TIntegerField;
    qryFieldFFieldPrecision: TIntegerField;
    qryFieldFFieldProvidFlagKey: TBooleanField;
    qryFieldFFieldProvidFlagUpdate: TBooleanField;
    qryFieldFFieldProvidFlagWhere: TBooleanField;
    qryFieldFFieldDefaultValueType: TWideStringField;
    qryFieldFFieldDefaultValue: TWideStringField;
    qryFieldFFieldShowPass: TBooleanField;
    qryFieldFFieldCheckEmpty: TBooleanField;
    qryFilter: TOneDataSet;
    qryFilterFFilterID: TWideStringField;
    qryFilterFDataID: TWideStringField;
    qryFilterFApiID: TWideStringField;
    qryFilterFOrderNumber: TIntegerField;
    qryFilterFFilterName: TWideStringField;
    qryFilterFFilterCaption: TWideStringField;
    qryFilterFFilterJsonName: TWideStringField;
    qryFilterFFilterFieldMode: TWideStringField;
    qryFilterFFilterField: TWideStringField;
    qryFilterFPFilterField: TWideStringField;
    qryFilterFFilterFieldItems: TWideStringField;
    qryFilterFFilterDataType: TWideStringField;
    qryFilterFFilterFormat: TWideStringField;
    qryFilterFFilterExpression: TWideStringField;
    qryFilterFFilterbMust: TBooleanField;
    qryFilterFFilterbValue: TBooleanField;
    qryFilterFFilterDefaultType: TWideStringField;
    qryFilterFFilterDefaultValue: TWideStringField;
    qryFilterFbOutParam: TBooleanField;
    qryFilterFOutParamTag: TWideStringField;
    dsFilter: TDataSource;
    pgDesign: TcxPageControl;
    tabSheetData: TcxTabSheet;
    pgData: TcxPageControl;
    tabSheetDataInfo: TcxTabSheet;
    Panel10: TPanel;
    cxLabel5: TcxLabel;
    dbFDataName: TcxDBTextEdit;
    cxLabel6: TcxLabel;
    dbFDataCaption: TcxDBTextEdit;
    cxLabel7: TcxLabel;
    dbFDataTag: TcxDBTextEdit;
    cxLabel8: TcxLabel;
    cxLabel9: TcxLabel;
    dbFDataTable: TcxDBTextEdit;
    cxLabel10: TcxLabel;
    dbFDataPrimaryKey: TcxDBTextEdit;
    cxLabel11: TcxLabel;
    cxLabel12: TcxLabel;
    dbFDataPageSize: TcxDBTextEdit;
    cxLabel13: TcxLabel;
    dbFDataUpdateMode: TcxDBComboBox;
    dbFDataZTCode: TcxDBComboBox;
    dbFDataOpenMode: TcxDBImageComboBox;
    cxLabel3: TcxLabel;
    dbFDataJsonType: TcxDBImageComboBox;
    cxLabel4: TcxLabel;
    dbFDataStoreName: TcxDBTextEdit;
    cxLabel14: TcxLabel;
    dbFMinAffected: TcxDBTextEdit;
    dbFMaxAffected: TcxDBTextEdit;
    cxLabel15: TcxLabel;
    cxLabel16: TcxLabel;
    cxGroupBox1: TcxGroupBox;
    dbFDataSQL: TcxDBMemo;
    tabSheetField: TcxTabSheet;
    Panel3: TPanel;
    tbFieldAdd: TcxButton;
    tbFieldDel: TcxButton;
    tbFieldAddAll: TcxButton;
    tbFieldDelAll: TcxButton;
    grdField: TcxGrid;
    vwField: TcxGridDBTableView;
    vwFieldFOrderNumber: TcxGridDBColumn;
    vwFieldFFieldName: TcxGridDBColumn;
    vwFieldFFieldCaption: TcxGridDBColumn;
    vwFieldFFieldJsonName: TcxGridDBColumn;
    vwFieldFFieldKind: TcxGridDBColumn;
    vwFieldFFieldDataType: TcxGridDBColumn;
    vwFieldFFieldSize: TcxGridDBColumn;
    vwFieldFFieldPrecision: TcxGridDBColumn;
    vwFieldFFieldProvidFlagKey: TcxGridDBColumn;
    vwFieldFFieldProvidFlagUpdate: TcxGridDBColumn;
    vwFieldFFieldProvidFlagWhere: TcxGridDBColumn;
    vwFieldFFieldDefaultValueType: TcxGridDBColumn;
    vwFieldFFieldDefaultValue: TcxGridDBColumn;
    vwFieldFFieldShowPassChar: TcxGridDBColumn;
    vwFieldFFieldSaveCheckEmpty: TcxGridDBColumn;
    lvField: TcxGridLevel;
    tabSheetParams: TcxTabSheet;
    Panel11: TPanel;
    tbParamsGet: TcxButton;
    tbParamsAdd: TcxButton;
    tbParamsDel: TcxButton;
    grdParam: TcxGrid;
    vwParam: TcxGridDBBandedTableView;
    vwParamFOrderNumber: TcxGridDBBandedColumn;
    vwParamFFilterName: TcxGridDBBandedColumn;
    vwParamFFilterCaption: TcxGridDBBandedColumn;
    vwParamFFilterJsonName: TcxGridDBBandedColumn;
    vwParamFFilterFieldMode: TcxGridDBBandedColumn;
    vwParamFFilterField: TcxGridDBBandedColumn;
    vwParamFPFilterField: TcxGridDBBandedColumn;
    vwParamFFilterDataType: TcxGridDBBandedColumn;
    vwParamFFilterFormat: TcxGridDBBandedColumn;
    vwParamFFilterExpression: TcxGridDBBandedColumn;
    vwParamFFilterbMust: TcxGridDBBandedColumn;
    vwParamFFilterbValue: TcxGridDBBandedColumn;
    vwParamFFilterDefaultType: TcxGridDBBandedColumn;
    vwParamFFilterDefaultValue: TcxGridDBBandedColumn;
    vwParamFbOutParam: TcxGridDBBandedColumn;
    vwParamFOutParamTag: TcxGridDBBandedColumn;
    lvParam: TcxGridLevel;
    cxGroupBox2: TcxGroupBox;
    dbFFilterFieldItems: TcxDBMemo;
    memoFilterItemRemark: TMemo;
    Panel1: TPanel;
    Panel2: TPanel;
    tbDataAdd: TcxButton;
    tbDataDel: TcxButton;
    tbDataChildAdd: TcxButton;
    DataTree: TcxDBTreeList;
    colFMenuTreeCode: TcxDBTreeListColumn;
    colFMenuCaption: TcxDBTreeListColumn;
    cxTabSheet1: TcxTabSheet;
    edSQL: TMemo;
    tbSaveSet: TdxBarLargeButton;
    qryFieldGet: TOneDataSet;
    tbRefreshApi: TdxBarLargeButton;
    cxTabSheet2: TcxTabSheet;
    Memo1: TMemo;
    Memo2: TMemo;
    qryFastApiFApiAuthor: TWideStringField;
    qryFastApiFApiRole: TWideStringField;
    vwMainFApiAuthor: TcxGridDBColumn;
    vwMainFApiRole: TcxGridDBColumn;
    qryFieldFFieldFormat: TWideStringField;
    vwFieldFFieldFormat: TcxGridDBColumn;
    procedure tbClientConnectClick(Sender: TObject);
    procedure tbClientDisConnectClick(Sender: TObject);
    procedure tbRefshClick(Sender: TObject);
    procedure tbApiEditClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure qryDataAfterScroll(DataSet: TDataSet);
    procedure qryDataNewRecord(DataSet: TDataSet);
    procedure qryFieldNewRecord(DataSet: TDataSet);
    procedure qryFilterNewRecord(DataSet: TDataSet);
    procedure tbDataAddClick(Sender: TObject);
    procedure tbDataChildAddClick(Sender: TObject);
    procedure tbDataDelClick(Sender: TObject);
    procedure tbFieldAddClick(Sender: TObject);
    procedure tbFieldDelClick(Sender: TObject);
    procedure tbFieldAddAllClick(Sender: TObject);
    procedure tbFieldDelAllClick(Sender: TObject);
    procedure tbParamsGetClick(Sender: TObject);
    procedure tbParamsAddClick(Sender: TObject);
    procedure tbParamsDelClick(Sender: TObject);
    procedure qryFastApiNewRecord(DataSet: TDataSet);
    procedure tbNewClick(Sender: TObject);
    procedure tbSaveClick(Sender: TObject);
    procedure tbSaveSetClick(Sender: TObject);
    procedure tbRefreshApiClick(Sender: TObject);
  private
    { Private declarations }
    FDataSetList: TList<TOneDataSet>;
    FApiID: string;
    procedure OpenSet();
    procedure DataTreeSave;
  public
    { Public declarations }
  end;

var
  frDemoFastApi: TfrDemoFastApi;

implementation

{$R *.dfm}


function GetGUID(IsOrder: Boolean = false): string;
var
  ii: TGUID;
  lDateTime: TDateTime;
begin
  CreateGUID(ii);
  Result := LowerCase(Copy(AnsiReplaceStr(GUIDToString(ii), '-', ''), 2, 32));
end;

procedure TfrDemoFastApi.FormCreate(Sender: TObject);
begin
  FDataSetList := TList<TOneDataSet>.create;
  FDataSetList.Add(qryData);
  FDataSetList.Add(qryField);
  FDataSetList.Add(qryFilter);
  pgDesign.ActivePageIndex := 0;
  pgData.ActivePageIndex := 0;
end;

procedure TfrDemoFastApi.FormDestroy(Sender: TObject);
begin
  FDataSetList.Clear;
  FDataSetList.Free;
end;

procedure TfrDemoFastApi.OpenSet();
var
  i: Integer;
  lData: TOneDataSet;
begin

  for i := 0 to self.FDataSetList.count - 1 do
  begin
    lData := self.FDataSetList[i];
    if lData.Active then
      lData.Close;
    lData.Params[0].AsString := qryFastApiFApiID.AsString;
  end;
  if not qryData.OpenDatas(self.FDataSetList) then
  begin
    showMessage(qryData.DataInfo.ErrMsg);
    exit;
  end;
  self.FApiID := qryFastApiFApiID.AsString;
  with DataTree do
  begin
    BeginUpdate;
    FullExpand;
    EndUpdate;
  end;
end;

procedure TfrDemoFastApi.qryDataAfterScroll(DataSet: TDataSet);
begin
  qryField.DisableControls;
  qryFilter.DisableControls;
  try
    qryField.Filtered := false;
    qryField.Filter := 'FDataID=' + qryDataFDataID.AsString.QuotedString;
    qryField.Filtered := True;

    qryFilter.Filtered := false;
    qryFilter.Filter := 'FDataID=' + qryDataFDataID.AsString.QuotedString;
    qryFilter.Filtered := True;
  finally
    qryField.EnableControls;
    qryFilter.EnableControls;
  end;
end;

procedure TfrDemoFastApi.qryDataNewRecord(DataSet: TDataSet);
begin
  qryDataFDataID.AsString := GetGUID();
  qryDataFApiID.AsString := self.FApiID;
  qryDataFDataCaption.AsString := '新建数据集';
  qryDataFDataOpenMode.AsString := 'OpenData';
  qryDataFDataPageSize.AsInteger := -1;
  qryDataFDataUpdateMode.AsString := 'upWhereKeyOnly';
end;

procedure TfrDemoFastApi.qryFastApiNewRecord(DataSet: TDataSet);
begin
  //
  qryFastApiFApiID.AsString := GetGUID();
  qryFastApiFPApiID.AsString := '';
  qryFastApiFApiCaption.AsString := '新的接口';
  qryFastApiFIsMenu.AsBoolean := false;
  qryFastApiFIsEnabled.AsBoolean := false;
  qryFastApiFOrderNumber.AsInteger := qryFastApi.RecordCount + 1;
end;

procedure TfrDemoFastApi.qryFieldNewRecord(DataSet: TDataSet);
begin
  qryFieldFFieldID.AsString := GetGUID();
  qryFieldFDataID.AsString := qryDataFDataID.AsString;
  qryFieldFApiID.AsString := self.FApiID;
  qryFieldFOrderNumber.AsInteger := qryField.RecordCount + 1;
  qryFieldFFieldCaption.AsString := '新建字段';
  qryFieldFFieldProvidFlagUpdate.AsBoolean := True;
end;

procedure TfrDemoFastApi.qryFilterNewRecord(DataSet: TDataSet);
begin
  qryFilterFFilterID.AsString := GetGUID();
  qryFilterFDataID.AsString := qryDataFDataID.AsString;
  qryFilterFApiID.AsString := self.FApiID;
  qryFilterFFilterFieldMode.AsString := '单字段';
  qryFilterFFilterExpression.AsString := '=';
  qryFilterFFilterDataType.AsString := '字符串';
end;

procedure TfrDemoFastApi.tbApiEditClick(Sender: TObject);
begin
  //
  if qryFastApi.IsEmpty then
  begin
    showMessage('请先选中一条配置进行设置');
    exit;
  end;
  tabSheetData.Caption := '数据设计【' + qryFastApiFApiCode.AsString + '】';
  self.OpenSet();
end;

procedure TfrDemoFastApi.tbClientConnectClick(Sender: TObject);
begin
  if OneConnection.Connected then
  begin
    showMessage('已经连接成功,无需在连接');
    exit;
  end;
  OneConnection.HTTPHost := edHTTPHost.Text;
  OneConnection.HTTPPort := strToInt(edHTTPPort.Text);
  OneConnection.ZTCode := edZTCode.Text;
  OneConnection.ConnectSecretkey := edConnectSecretkey.Text;
  if not OneConnection.DoConnect() then
  begin
    showMessage(OneConnection.ErrMsg);
  end
  else
  begin
    // 全局设置，如果控件没挂勾 connetion,默认走的就是全局的
    OneClientConnect.Unit_Connection := OneConnection;
    showMessage('连接成功');
  end;
end;

procedure TfrDemoFastApi.tbClientDisConnectClick(Sender: TObject);
begin
  OneConnection.DisConnect;
end;

procedure TfrDemoFastApi.tbDataAddClick(Sender: TObject);
var
  lNode, lParamNode: TCXTreeListNode;
  lPKeyValue: string;
  li: Integer;
begin
  inherited;
  lPKeyValue := '';
  lNode := DataTree.FocusedNode;
  if lNode <> nil then
  begin
    lNode := lNode.Parent;
    if lNode <> nil then
    begin
      if lNode is TcxDBTreeListNode then
      begin

        lPKeyValue := TcxDBTreeListNode(lNode).KeyValue;
      end;
    end;
  end;
  qryData.Append;
  qryDataFPDataID.AsString := lPKeyValue;
  qryData.Post;
end;

procedure TfrDemoFastApi.tbDataChildAddClick(Sender: TObject);
var
  lNode, lParamNode: TCXTreeListNode;
  lPKeyValue: string;
begin
  inherited;
  lPKeyValue := '';
  lNode := DataTree.FocusedNode;
  if lNode <> nil then
  begin
    if lNode is TcxDBTreeListNode then
    begin

      lPKeyValue := TcxDBTreeListNode(lNode).KeyValue;
    end;
  end;
  qryData.Append;
  qryDataFPDataID.AsString := lPKeyValue;
  qryData.Post;
end;

procedure TfrDemoFastApi.tbDataDelClick(Sender: TObject);
var
  lNode, lParamNode: TCXTreeListNode;
  lKeyValue: string;
begin
  inherited;
  //
  lNode := DataTree.FocusedNode;
  if lNode <> nil then
  begin
    if not(lNode is TcxDBTreeListNode) then
    begin
      exit;
    end;
    lKeyValue := TcxDBTreeListNode(lNode).KeyValue;
    if lNode.HasChildren then
    begin
      showMessage('有相关子节点,不可删除');
      exit;
    end;
    if qryData.Locate('FDataID', lKeyValue, []) then
    begin
      // 删除相关的字段条件
      qryField.DisableControls;
      qryFilter.DisableControls;
      try
        qryField.First;
        while not qryField.Eof do
        begin
          qryField.Delete;
        end;

        qryFilter.First;
        while not qryFilter.Eof do
        begin
          qryFilter.Delete;
        end;
      finally
        qryField.EnableControls;
        qryFilter.EnableControls;
      end;

      qryData.Delete;
    end;
  end;
end;

procedure TfrDemoFastApi.tbFieldAddAllClick(Sender: TObject);
var
  lSQL: string;
  i, iParam: Integer;
  lField: TField;
  lFieldName, lParamName: string;
  lFieldKind: TFieldKind;
  lFieldType: TFieldType;
  isFilter: boolean;
begin
  inherited;
  //
  if qryData.IsEmpty then
    exit;
  lSQL := qryDataFDataSQL.AsString;
  if lSQL = '' then
  begin
    showMessage('数据集SQL未设置,无法获取相关的数据集!');
    exit;
  end;
  if qryFieldGet.Active then
  begin
    qryFieldGet.Close;
    qryFieldGet.Fields.Clear;
  end;
  qryFieldGet.SQL.text := lSQL;
  qryFieldGet.DataInfo.ZTCode := qryDataFDataZTCode.AsString;
  qryFieldGet.DataInfo.PageSize := 1;
  for i := 0 to qryFieldGet.Params.count - 1 do
  begin
    lParamName := qryFieldGet.Params[i].Name;
    isFilter := false;
    qryFilter.First;
    while not qryFilter.Eof do
    begin
      if qryFilterFFilterName.AsString.ToLower = lParamName.ToLower then
      begin
        // 字符串,整型,数字 ,布尔 ,时间
        if qryFilterFFilterDataType.AsString = '时间' then
        begin
          // yyyy-mm-dd hh:nn:ss,yyyy-mm-dd,yyyy,hh:nn:ss
          if qryFilterFFilterFormat.AsString = 'yyyy-mm-dd' then
          begin
            qryFieldGet.Params[i].AsString := '1985-11-22';
          end
          else if qryFilterFFilterFormat.AsString = 'hh:nn:ss' then
          begin
            qryFieldGet.Params[i].AsString := '11:22:22';
          end
          else
          begin
            qryFieldGet.Params[i].AsDateTime := now;
          end;
        end
        else
        begin
          qryFieldGet.Params[i].AsString := '0';
        end;
        isFilter := True;
        break;
      end;
      qryFilter.Next;
    end;
    if not isFilter then
    begin
      showMessage('请先设置SQL参数[' + lParamName + ']的条件,且注意参数数据类型');
      exit;
    end;
  end;
  if not qryFieldGet.OpenData then
  begin
    showMessage(qryFieldGet.DataInfo.ErrMsg + ',如果因为参数的值出错,请先把参数去除写成where 1=2 获取数据');
    exit;
  end;

  qryField.DisableControls;
  qryFieldGet.DisableControls;
  try
    //
    for i := 0 to qryFieldGet.Fields.count - 1 do
    begin
      lField := qryFieldGet.Fields[i];
      lFieldType := lField.DataType;
      lFieldKind := lField.FieldKind;
      lFieldName := lField.FieldName;
      if qryField.Locate('FFieldName', lFieldName, []) then
      begin
        qryField.Edit;
      end
      else
      begin
        qryField.Append;
      end;
      qryFieldFFieldName.AsString := lFieldName;
      if (qryFieldFFieldCaption.AsString = '新建字段') or (qryFieldFFieldCaption.AsString = '') then
        qryFieldFFieldCaption.AsString := qryFieldFFieldName.AsString;

      qryFieldFFieldSize.AsInteger := lField.Size;
      { 以下类型的字段有精度 }
      if lField is TNumericField then
      begin
        case lFieldType of
          TFieldType.ftCurrency:
            qryFieldFFieldPrecision.AsInteger := TCurrencyField(lField).Precision;
          TFieldType.ftFMTBcd:
            qryFieldFFieldPrecision.AsInteger := TFMTBCDField(lField).Precision;
          TFieldType.ftFloat:
            qryFieldFFieldPrecision.AsInteger := TFloatField(lField).Precision;
          TFieldType.ftBCD:
            qryFieldFFieldPrecision.AsInteger := TBCDField(lField).Precision;
          TFieldType.ftSingle:
            qryFieldFFieldPrecision.AsInteger := TSingleField(lField).Precision;
          TFieldType.ftExtended:
            qryFieldFFieldPrecision.AsInteger := TExtendedField(lField).Precision;
        end;
      end;
      qryFieldFFieldDataType.AsString := GetEnumName(TypeInfo(TFieldType), Ord(lFieldType));
      qryFieldFFieldKind.AsString := GetEnumName(TypeInfo(TFieldKind), Ord(lFieldKind));
      qryField.Post;
    end;

    i := 0;
    qryField.First;
    while not qryField.Eof do
    begin
      i := i + 1;
      qryField.Edit;
      qryFieldFOrderNumber.AsInteger := i;
      qryField.Post;
      qryField.Next;
    end;
  finally
    qryFieldGet.EnableControls;
    qryField.EnableControls;
  end;
end;

procedure TfrDemoFastApi.tbFieldAddClick(Sender: TObject);
begin
  qryField.Append;
  qryFieldFFieldCaption.AsString := '新建字段';
  qryField.Post;
end;

procedure TfrDemoFastApi.tbFieldDelAllClick(Sender: TObject);
begin
  inherited;
  qryField.DisableControls;
  try
    qryField.First;
    while not qryField.Eof do
    begin
      qryField.Delete;
    end;
  finally
    qryField.EnableControls;
  end;
end;

procedure TfrDemoFastApi.tbFieldDelClick(Sender: TObject);
var
  i: Integer;
begin
  inherited;
  if qryField.IsEmpty then
    exit;
  i := 0;
  qryField.Delete;
  qryField.DisableControls;
  try
    qryField.First;
    while not qryField.Eof do
    begin
      i := i + 1;
      qryField.Edit;
      qryFieldFOrderNumber.AsInteger := i;
      qryField.Post;
      qryField.next;
    end;
  finally
    qryField.EnableControls;
  end;
end;

procedure TfrDemoFastApi.tbNewClick(Sender: TObject);
begin
  qryFastApi.Append;
  qryFastApi.Post;
end;

procedure TfrDemoFastApi.tbParamsAddClick(Sender: TObject);
begin
  inherited;
  if qryData.IsEmpty then
    exit;
  qryFilter.Append;
  qryFilterFFilterCaption.AsString := '新建条件';
  qryFilter.Post;
end;

procedure TfrDemoFastApi.tbParamsDelClick(Sender: TObject);
var
  i: Integer;
begin
  inherited;
  if qryFilter.IsEmpty then
    exit;
  i := 0;
  qryFilter.Delete;
  qryFilter.First;
  while not qryFilter.Eof do
  begin
    i := i + 1;
    qryFilter.Edit;
    qryFilterFOrderNumber.AsInteger := i;
    qryFilter.Post;
    qryFilter.next;
  end;
end;

procedure TfrDemoFastApi.tbParamsGetClick(Sender: TObject);
var
  tempData: TOneDataSet;
  i, iParam: Integer;
  lParam: TFDParam;
begin
  inherited;
  if qryData.IsEmpty then
    exit;
  if qryDataFDataSQL.AsString = '' then
  begin
    exit;
  end;
  tempData := TOneDataSet.create(nil);
  try
    tempData.SQL.Text := qryDataFDataSQL.AsString;
    for iParam := 0 to tempData.Params.count - 1 do
    begin
      lParam := tempData.Params[iParam];
      if not qryFilter.Locate('FFilterField', lParam.name, []) then
      begin
        qryFilter.Append;
        qryFilterFFilterName.AsString := lParam.name;
        qryFilterFFilterField.AsString := lParam.name;
        qryFilter.Post;
      end;
    end;
  finally
    tempData.Free;
  end;

  i := 0;
  qryFilter.First;
  while not qryFilter.Eof do
  begin
    i := i + 1;
    qryFilter.Edit;
    qryFilterFOrderNumber.AsInteger := i;
    qryFilter.Post;
    qryFilter.next;
  end;
end;

procedure TfrDemoFastApi.tbRefreshApiClick(Sender: TObject);
var
  lLoginPass, lErrMsg: string;
  lJsonData: TJsonValue;
  lPostJsonValue: TJsonObject;
  lActionResult: TActionResult<string>;
  lResultSuccess: Boolean;
  lResultMsg: string;
begin
  lJsonData := nil;
  lPostJsonValue := nil;
  try
    // 否则向服务端请求
    lJsonData := OneConnection.PostResultJsonValue('/OneServer/FastApi/RefreshApiInfoAll', '', lErrMsg);
    if lJsonData = nil then
    begin
      showMessage(lErrMsg);
      exit;
    end;
    if lJsonData.TryGetValue<Boolean>('ResultSuccess', lResultSuccess) then
    begin
      if not lResultSuccess then
      begin
        if lJsonData.TryGetValue<string>('ResultMsg', lResultMsg) then
        begin
          showMessage(lResultMsg);
        end
        else
        begin
          showMessage('反回的结果非标准TActionResult,当前返回:' + lJsonData.ToJSON());
        end;
        exit;
      end;
    end
    else
    begin
      showMessage('反回的结果非标准TActionResult,当前返回:' + lJsonData.ToJSON());
      exit;
    end;

    lActionResult := TActionResult<string>.create;
    try
      lActionResult.ResultData := '';
      if not OneNeonHelper.JsonToObject(lActionResult, lJsonData, lErrMsg) then
      begin
        showMessage(lErrMsg);
        exit;
      end;
      if not lActionResult.ResultSuccess then
      begin
        showMessage(lActionResult.ResultMsg);
      end
      else
      begin
        showMessage('刷新服务端配置成功');
      end;
    finally
      lActionResult.Free;
    end;
  finally
    if lPostJsonValue <> nil then
      lPostJsonValue.Free;
    if lJsonData <> nil then
      lJsonData.Free;
  end;
end;

procedure TfrDemoFastApi.tbRefshClick(Sender: TObject);
begin
  //
  if qryFastApi.Active then
    qryFastApi.Close;
  if qryFastApi.OpenData then
  begin
    showMessage('打开数据成功');
  end
  else
  begin
    showMessage(qryFastApi.DataInfo.ErrMsg);
  end;
end;

procedure TfrDemoFastApi.tbSaveClick(Sender: TObject);
begin
  if qryFastApi.SaveData then
  begin
    showMessage('保存成功');
    if qryFastApi.Active then
      qryFastApi.Close;
    qryFastApi.OpenData;
  end
  else
  begin
    showMessage(qryFastApi.DataInfo.ErrMsg);
  end;
end;

procedure TfrDemoFastApi.tbSaveSetClick(Sender: TObject);
var
  lName, tempTreeCode: string;
  lNames: TDictionary<string, Boolean>;
  i: Integer;
  lFilterstr: string;
  lLocateDataID: string;
begin
  inherited;
  lLocateDataID := '';
  try
    for i := 0 to self.FDataSetList.count - 1 do
    begin
      if self.FDataSetList[i].State in dsEditModes then
        self.FDataSetList[i].Post;
    end;
    if not qryData.IsEmpty then
      lLocateDataID := qryDataFDataID.AsString;
    // 保存校验
    lNames := TDictionary<string, Boolean>.create;
    try
      DataTreeSave;
      qryData.AfterScroll := nil;
      qryData.DisableControls;
      try
        i := 0;
        qryData.First;
        while not qryData.Eof do
        begin
          i := i + 1;
          if qryDataFDataName.AsString = '' then
          begin
            showMessage('数据集名称不可为空,请检查');
            exit;
          end;
          if lNames.ContainsKey(qryDataFDataName.AsString.ToLower) then
          begin
            showMessage('数据集名称' + qryDataFDataName.AsString + '重复,请检查');
            exit;
          end
          else
          begin
            lNames.Add(qryDataFDataName.AsString.ToLower, True);
          end;
          qryData.next;
        end;

        //
      finally
        qryData.EnableControls;
        qryData.AfterScroll := qryDataAfterScroll;
        // 滚动下
        qryDataAfterScroll(qryData);
      end;

      qryData.First;
      while not qryData.Eof do
      begin
        i := 0;
        qryField.First;
        while not qryField.Eof do
        begin
          i := i + 1;
          qryField.Edit;
          qryFieldFOrderNumber.AsInteger := i;
          qryField.Post;
          qryField.next;
        end;

        i := 0;
        qryFilter.First;
        while not qryFilter.Eof do
        begin
          i := i + 1;
          qryFilter.Edit;
          qryFilterFOrderNumber.AsInteger := i;
          qryFilter.Post;
          qryFilter.next;
        end;
        qryData.next;
      end;
    finally
      lNames.Clear;
      lNames.Free;
    end;

    if not qryData.SaveDatas(self.FDataSetList) then
    begin
      showMessage(qryData.DataInfo.ErrMsg);
      exit;
    end
    else
    begin
      showMessage('保存配置成功');
    end;
    // 重新打开数据
    self.OpenSet();
  finally
    if lLocateDataID <> '' then
      qryData.Locate('FDataID', lLocateDataID, []);
  end;
end;

procedure TfrDemoFastApi.DataTreeSave;
var
  iNode: Integer;
  lNode: TcxDBTreeListNode;

  procedure DataNodeEdit(QNode: TcxDBTreeListNode; QIndexNode: Integer; QPNode: TcxDBTreeListNode);
  var
    vkeyValue, vPkeyValue, vzFieldName: string;
    vTreeCode: string;
    iColumn: Integer;
  begin
    vkeyValue := QNode.KeyValue;
    if vkeyValue <> '' then
    begin
      vTreeCode := (QIndexNode + 1).ToString;
      if vTreeCode.length < 2 then
        vTreeCode := '0' + vTreeCode;
      if QPNode <> nil then
      begin
        if qryData.Locate('FDataID', QPNode.KeyValue, []) then
        begin
          vTreeCode := qryDataFTreeCode.AsString + '.' + vTreeCode;
        end;
      end;
      if qryData.Locate('FDataID', vkeyValue, []) then
      begin
        qryData.Edit;
        qryDataFTreeCode.AsString := vTreeCode;
        qryData.Post;
      end;
    end;
  end;
  procedure DataSaveNodeChild(QPNode: TcxDBTreeListNode);
  var
    iTemp: Integer;
    vNodeTemp: TcxDBTreeListNode;
  begin
    if QPNode.HasChildren then
    begin
      for iTemp := 0 to QPNode.count - 1 do
      begin
        vNodeTemp := TcxDBTreeListNode(QPNode.Items[iTemp]);
        DataNodeEdit(vNodeTemp, iTemp, QPNode);
        { 进行递归 }
        DataSaveNodeChild(vNodeTemp);
      end;
    end;
  end;

begin
  inherited;
  qryData.AfterScroll := nil;
  try
    for iNode := 0 to DataTree.count - 1 do
    begin
      lNode := TcxDBTreeListNode(DataTree.Items[iNode]);
      DataNodeEdit(lNode, iNode, nil);
      DataSaveNodeChild(lNode);
    end;
  finally
    qryData.AfterScroll := qryDataAfterScroll;
  end;

end;

end.

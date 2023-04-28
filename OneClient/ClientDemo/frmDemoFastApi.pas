unit frmDemoFastApi;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
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
  cxLabel, cxPC;

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
    procedure tbClientConnectClick(Sender: TObject);
    procedure tbClientDisConnectClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frDemoFastApi: TfrDemoFastApi;

implementation

{$R *.dfm}


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
    showMessage('连接成功');
  end;
end;

procedure TfrDemoFastApi.tbClientDisConnectClick(Sender: TObject);
begin
  OneConnection.DisConnect;
end;

end.

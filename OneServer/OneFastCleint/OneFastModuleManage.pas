unit OneFastModuleManage;

interface

uses system.Generics.Collections, system.Classes, system.StrUtils, system.SysUtils;

type
  TFastModule = class;
  TFastModuleData = class;
  TFastModuleDataParam = class;
  TFastModuleField = class;
  TFastModuleUI = class;
  TFastModuleBand = class;
  TFastModuleControl = class;
  TFastModuleFilter = class;
  TFastModuleButton = class;
  TFastModuleButtonpop = class;

  TFastModule = class
  private
    FModuleID_: string;
    FModuleCode_: string;
    FModuleCaption_: string;
    FNextModuleOpenMode_: string;
    FNextModuleCode_: string;
    FbContextUnion_: boolean;
    FIsShowFilter_: boolean;
    FIsMulti_: boolean;
    FIsStart_: boolean;
    FModuleScript_: string;
    //
    FFileSetCode_: string;
    FFlowCode_: string;
  published
    property FModuleID: string read FModuleID_ write FModuleID_;
    property FModuleCode: string read FModuleCode_ write FModuleCode_;
    property FModuleCaption: string read FModuleCaption_ write FModuleCaption_;
    property FNextModuleOpenMode: string read FNextModuleOpenMode_ write FNextModuleOpenMode_;
    property FNextModuleCode: string read FNextModuleCode_ write FNextModuleCode_;
    property FbContextUnion: boolean read FbContextUnion_ write FbContextUnion_;
    property FIsShowFilter: boolean read FIsShowFilter_ write FIsShowFilter_;
    property FIsMulti: boolean read FIsMulti_ write FIsMulti_;
    property FIsStart: boolean read FIsStart_ write FIsStart_;
    property FModuleScript: string read FModuleScript_ write FModuleScript_;
    property FFileSetCode: string read FFileSetCode_ write FFileSetCode_;
    property FFlowCode: string read FFlowCode_ write FFlowCode_;
  end;

  TFastModuleData = class
  private
    FDataID_: string;
    FModuleID_: string;
    FOrderNumber_: integer;
    FDataName_: string;
    FDataCaption_: string;
    FDataTag_: integer;
    FDataZTCode_: string;
    FDataTable_: string;
    FDataPrimaryKey_: string;
    FDataOpenMode_: string;
    FDataPageSize_: integer;
    FDataIsPost_: boolean;
    FDataUpdateMode_: string;
    FDataSQL_: string;
    FChildParams_: TList<TFastModuleDataParam>;
    FChildFields_: TList<TFastModuleField>;
  public
    constructor Create;
    destructor Destroy; override;
  published
    property FDataID: string read FDataID_ write FDataID_;
    property FModuleID: string read FModuleID_ write FModuleID_;
    property FOrderNumber: integer read FOrderNumber_ write FOrderNumber_;
    property FDataName: string read FDataName_ write FDataName_;
    property FDataCaption: string read FDataCaption_ write FDataCaption_;
    property FDataTag: integer read FDataTag_ write FDataTag_;
    property FDataZTCode: string read FDataZTCode_ write FDataZTCode_;
    property FDataTable: string read FDataTable_ write FDataTable_;
    property FDataPrimaryKey: string read FDataPrimaryKey_ write FDataPrimaryKey_;
    property FDataOpenMode: string read FDataOpenMode_ write FDataOpenMode_;
    property FDataPageSize: integer read FDataPageSize_ write FDataPageSize_;
    property FDataIsPost: boolean read FDataIsPost_ write FDataIsPost_;
    property FDataUpdateMode: string read FDataUpdateMode_ write FDataUpdateMode_;
    property FDataSQL: string read FDataSQL_ write FDataSQL_;
    property ChildParams: TList<TFastModuleDataParam> read FChildParams_ write FChildParams_;
    property ChildFields: TList<TFastModuleField> read FChildFields_ write FChildFields_;
  end;

  TFastModuleDataParam = class
  private
    FParamID_: string;
    FDataID_: string;
    FModuleID_: string;
    FOrderNumber_: integer;
    FParamName_: string;
    FParamCaption_: string;
    FParamValueType_: string;
    FParamValue_: string;
    FPDataIndex_: integer;
    FPDataFieldName_: string;
  published
    property FParamID: string read FParamID_ write FParamID_;
    property FDataID: string read FDataID_ write FDataID_;
    property FModuleID: string read FModuleID_ write FModuleID_;
    property FOrderNumber: integer read FOrderNumber_ write FOrderNumber_;
    property FParamName: string read FParamName_ write FParamName_;
    property FParamCaption: string read FParamCaption_ write FParamCaption_;
    property FParamValueType: string read FParamValueType_ write FParamValueType_;
    property FParamValue: string read FParamValue_ write FParamValue_;
    property FPDataIndex: integer read FPDataIndex_ write FPDataIndex_;
    property FPDataFieldName: string read FPDataFieldName_ write FPDataFieldName_;
  end;

  TFastModuleField = class
  private
    FFieldID_: string;
    FDataID_: string;
    FModuleID_: string;
    FOrderNumber_: integer;
    FFieldName_: string;
    FFieldCaption_: string;
    FFieldTag_: integer;
    FFieldKind_: string;
    FFieldDataType_: string;
    FFieldSize_: integer;
    FFieldPrecision_: integer;
    FFieldProvidFlagKey_: boolean;
    FFieldProvidFlagUpdate_: boolean;
    FFieldProvidFlagWhere_: boolean;
    FFieldDefaultValueType_: string;
    FFieldDefaultValue_: string;
    FFieldShowPassChar_: string;
    FFieldSaveCheckEmpty_: string;
    FFieldSaveCheckRepeat_: string;
  published
    property FFieldID: string read FFieldID_ write FFieldID_;
    property FDataID: string read FDataID_ write FDataID_;
    property FModuleID: string read FModuleID_ write FModuleID_;
    property FOrderNumber: integer read FOrderNumber_ write FOrderNumber_;
    property FFieldName: string read FFieldName_ write FFieldName_;
    property FFieldCaption: string read FFieldCaption_ write FFieldCaption_;
    property FFieldTag: integer read FFieldTag_ write FFieldTag_;
    property FFieldKind: string read FFieldKind_ write FFieldKind_;
    property FFieldDataType: string read FFieldDataType_ write FFieldDataType_;
    property FFieldSize: integer read FFieldSize_ write FFieldSize_;
    property FFieldPrecision: integer read FFieldPrecision_ write FFieldPrecision_;
    property FFieldProvidFlagKey: boolean read FFieldProvidFlagKey_ write FFieldProvidFlagKey_;
    property FFieldProvidFlagUpdate: boolean read FFieldProvidFlagUpdate_ write FFieldProvidFlagUpdate_;
    property FFieldProvidFlagWhere: boolean read FFieldProvidFlagWhere_ write FFieldProvidFlagWhere_;
    property FFieldDefaultValueType: string read FFieldDefaultValueType_ write FFieldDefaultValueType_;
    property FFieldDefaultValue: string read FFieldDefaultValue_ write FFieldDefaultValue_;
    property FFieldShowPassChar: string read FFieldShowPassChar_ write FFieldShowPassChar_;
    property FFieldSaveCheckEmpty: string read FFieldSaveCheckEmpty_ write FFieldSaveCheckEmpty_;
    property FFieldSaveCheckRepeat: string read FFieldSaveCheckRepeat_ write FFieldSaveCheckRepeat_;
  end;

  TFastModuleUI = class(TObject)
  private
    FUIID_: string;
    FModuleID_: string;
    FDataID_: string;
    FOrderNumber_: integer;
    FUIType_: string;
    FUIName_: string;
    FUICaption_: string;
    FUIShowGirdNo_: boolean;
    FUIShowGirdFindPanel_: boolean;
    FUIShowGridFilter_: boolean;
    FUIGridCanEdit_: boolean;
    FUIGridCanAdd_: boolean;
    FUIGridCanDel_: boolean;
    FTreeKeyID_: string;
    FTreePKeyID_: string;
    FUISet_: string;
    //
    FChildBands_: TList<TFastModuleBand>;
    FChildControls_: TList<TFastModuleControl>;
    FChildFilters_: TList<TFastModuleFilter>;
    FChildButtons_: TList<TFastModuleButton>;
    FChildButtonpops_: TList<TFastModuleButtonpop>;

  public
    constructor Create;
    destructor Destroy; override;
  published
    property FUIID: string read FUIID_ write FUIID_;
    property FModuleID: string read FModuleID_ write FModuleID_;
    property FDataID: string read FDataID_ write FDataID_;
    property FOrderNumber: integer read FOrderNumber_ write FOrderNumber_;
    property FUIType: string read FUIType_ write FUIType_;
    property FUIName: string read FUIName_ write FUIName_;
    property FUICaption: string read FUICaption_ write FUICaption_;
    property FUIShowGirdNo: boolean read FUIShowGirdNo_ write FUIShowGirdNo_;
    property FUIShowGirdFindPanel: boolean read FUIShowGirdFindPanel_ write FUIShowGirdFindPanel_;
    property FUIShowGridFilter: boolean read FUIShowGridFilter_ write FUIShowGridFilter_;
    property FUIGridCanEdit: boolean read FUIGridCanEdit_ write FUIGridCanEdit_;
    property FUIGridCanAdd: boolean read FUIGridCanAdd_ write FUIGridCanAdd_;
    property FUIGridCanDel: boolean read FUIGridCanDel_ write FUIGridCanDel_;
    property FTreeKeyID: string read FTreeKeyID_ write FTreeKeyID_;
    property FTreePKeyID: string read FTreePKeyID_ write FTreePKeyID_;
    property FUISet: string read FUISet_ write FUISet_;
    //
    property ChildBands: TList<TFastModuleBand> read FChildBands_ write FChildBands_;
    property ChildControls: TList<TFastModuleControl> read FChildControls_ write FChildControls_;
    property ChildFilters: TList<TFastModuleFilter> read FChildFilters_ write FChildFilters_;
    property ChildButtons: TList<TFastModuleButton> read FChildButtons_ write FChildButtons_;
    property ChildButtonpops: TList<TFastModuleButtonpop> read FChildButtonpops_ write FChildButtonpops_;
  end;

  TFastModuleBand = class
  private
    FBandID_: string;
    FPBandID_: string;
    FUIID_: string;
    FModuleID_: string;
    FCaption_: string;
    FBandIndex_: integer;
    FFixedKind_: integer;
    FTreeCode_: string;
    FChildBands_: TList<TFastModuleBand>;
  public
    constructor Create;
    destructor Destroy; override;
  published
    property FBandID: string read FBandID_ write FBandID_;
    property FPBandID: string read FPBandID_ write FPBandID_;
    property FUIID: string read FUIID_ write FUIID_;
    property FModuleID: string read FModuleID_ write FModuleID_;
    property FBandIndex: integer read FBandIndex_ write FBandIndex_;
    property FCaption: string read FCaption_ write FCaption_;
    property FFixedKind: integer read FFixedKind_ write FFixedKind_;
    property FTreeCode: string read FTreeCode_ write FTreeCode_;
    property ChildBands: TList<TFastModuleBand> read FChildBands_ write FChildBands_;
  end;

  TFastModuleControl = class
  private
    FControlID_: string;
    FUIID_: string;
    FModuleID_: string;
    FOrderNumber_: integer;
    FControlType_: string;
    FControlCaption_: string;
    FGridBandID_: string;
    FControlWidth_: integer;
    FControlField_: string;
    FControlTag_: integer;
    FControlLabelColor_: integer;
    FControlOptionFormat_: string;
    FControlVisible_: boolean;
    FControlReadOnly_: boolean;
    FControlEnabled_: boolean;
    FControlShowPass_: boolean;
    FControlSet_: string;
    FColumnSum_: string;
  published
    property FControlID: string read FControlID_ write FControlID_;
    property FUIID: string read FUIID_ write FUIID_;
    property FModuleID: string read FModuleID_ write FModuleID_;
    property FOrderNumber: integer read FOrderNumber_ write FOrderNumber_;
    property FControlType: string read FControlType_ write FControlType_;
    property FControlCaption: string read FControlCaption_ write FControlCaption_;
    property FGridBandID: string read FGridBandID_ write FGridBandID_;
    property FControlWidth: integer read FControlWidth_ write FControlWidth_;
    property FControlField: string read FControlField_ write FControlField_;
    property FControlTag: integer read FControlTag_ write FControlTag_;
    property FControlLabelColor: integer read FControlLabelColor_ write FControlLabelColor_;
    property FControlOptionFormat: string read FControlOptionFormat_ write FControlOptionFormat_;
    property FControlVisible: boolean read FControlVisible_ write FControlVisible_;
    property FControlReadOnly: boolean read FControlReadOnly_ write FControlReadOnly_;
    property FControlEnabled: boolean read FControlEnabled_ write FControlEnabled_;
    property FControlShowPass: boolean read FControlShowPass_ write FControlShowPass_;
    property FControlSet: string read FControlSet_ write FControlSet_;
    property FColumnSum: string read FColumnSum_ write FColumnSum_;
  end;

  TFastModuleFilter = class
  private
    FFilterID_: string;
    FUIID_: string;
    FModuleID_: string;
    FOrderNumber_: integer;
    FControlType_: string;
    FControlName_: string;
    FControlCaption_: string;
    FControlWidth_: integer;
    FControlField_: string;
    FControlTag_: integer;
    FControlLabelColor_: integer;
    FControlOptionFormat_: string;
    FControlVisible_: boolean;
    FControlReadOnly_: boolean;
    FControlEnabled_: boolean;
    FCompareDefault_: string;
    FControlDefaultValue_: string;
    FIsNotEmpty_: boolean;
    FIsFastFilter_: boolean;
  published
    property FFilterID: string read FFilterID_ write FFilterID_;
    property FUIID: string read FUIID_ write FUIID_;
    property FModuleID: string read FModuleID_ write FModuleID_;
    property FOrderNumber: integer read FOrderNumber_ write FOrderNumber_;
    property FControlType: string read FControlType_ write FControlType_;
    property FControlName: string read FControlName_ write FControlName_;
    property FControlCaption: string read FControlCaption_ write FControlCaption_;
    property FControlWidth: integer read FControlWidth_ write FControlWidth_;
    property FControlField: string read FControlField_ write FControlField_;
    property FControlTag: integer read FControlTag_ write FControlTag_;
    property FControlLabelColor: integer read FControlLabelColor_ write FControlLabelColor_;
    property FControlOptionFormat: string read FControlOptionFormat_ write FControlOptionFormat_;
    property FControlVisible: boolean read FControlVisible_ write FControlVisible_;
    property FControlReadOnly: boolean read FControlReadOnly_ write FControlReadOnly_;
    property FControlEnabled: boolean read FControlEnabled_ write FControlEnabled_;
    property FCompareDefault: string read FCompareDefault_ write FCompareDefault_;
    property FControlDefaultValue: string read FControlDefaultValue_ write FControlDefaultValue_;
    property FIsNotEmpty: boolean read FIsNotEmpty_ write FIsNotEmpty_;
    property FIsFastFilter: boolean read FIsFastFilter_ write FIsFastFilter_;
  end;

  TFastModuleButton = class
  private
    FButtonID_: string;
    FPButtonID_: string;
    FUIID_: string;
    FModuleID_: string;
    FButtonName_: string;
    FButtonCaption_: string;
    FButtonTag_: integer;
    FButtonType_: string;
    FButtonImgIndex_: integer;
    FButtonTreeCode_: string;
    FButtonScript_: string;
    FChildButtons_: TList<TFastModuleButton>;
  public
    constructor Create;
    destructor Destroy; override;
  published
    property FButtonID: string read FButtonID_ write FButtonID_;
    property FPButtonID: string read FPButtonID_ write FPButtonID_;
    property FUIID: string read FUIID_ write FUIID_;
    property FModuleID: string read FModuleID_ write FModuleID_;
    property FButtonName: string read FButtonName_ write FButtonName_;
    property FButtonCaption: string read FButtonCaption_ write FButtonCaption_;
    property FButtonTag: integer read FButtonTag_ write FButtonTag_;
    property FButtonType: string read FButtonType_ write FButtonType_;
    property FButtonImgIndex: integer read FButtonImgIndex_ write FButtonImgIndex_;
    property FButtonTreeCode: string read FButtonTreeCode_ write FButtonTreeCode_;
    property FButtonScript: string read FButtonScript_ write FButtonScript_;
    property ChildButtons: TList<TFastModuleButton> read FChildButtons_ write FChildButtons_;
  end;

  TFastModuleButtonpop = class
  private
    FButtonID_: string;
    FPButtonID_: string;
    FUIID_: string;
    FModuleID_: string;
    FButtonName_: string;
    FButtonCaption_: string;
    FButtonTag_: integer;
    FButtonType_: string;
    FButtonImgIndex_: integer;
    FButtonTreeCode_: string;
    FButtonScript_: string;
  published
    property FButtonID: string read FButtonID_ write FButtonID_;
    property FPButtonID: string read FPButtonID_ write FPButtonID_;
    property FUIID: string read FUIID_ write FUIID_;
    property FModuleID: string read FModuleID_ write FModuleID_;
    property FButtonName: string read FButtonName_ write FButtonName_;
    property FButtonCaption: string read FButtonCaption_ write FButtonCaption_;
    property FButtonTag: integer read FButtonTag_ write FButtonTag_;
    property FButtonType: string read FButtonType_ write FButtonType_;
    property FButtonImgIndex: integer read FButtonImgIndex_ write FButtonImgIndex_;
    property FButtonTreeCode: string read FButtonTreeCode_ write FButtonTreeCode_;
    property FButtonScript: string read FButtonScript_ write FButtonScript_;
  end;

  TFastModuleLayout = class
  private
    FLayoutID_: string;
    FModuleID_: string;
    FButtonLayout_: string;
    FControlLayout_: string;
    FFormWidth_: integer;
    FFormHeight_: integer;
    FFilterFormLayout_: string;
    FFilterFormWidth_: integer;
    FFilterFormHeight_: integer;
  published
    property FLayoutID: string read FLayoutID_ write FLayoutID_;
    property FModuleID: string read FModuleID_ write FModuleID_;
    property FButtonLayout: string read FButtonLayout_ write FButtonLayout_;
    property FControlLayout: string read FControlLayout_ write FControlLayout_;
    property FFormWidth: integer read FFormWidth_ write FFormWidth_;
    property FFormHeight: integer read FFormHeight_ write FFormHeight_;
    property FFilterFormLayout: string read FFilterFormLayout_ write FFilterFormLayout_;
    property FFilterFormWidth: integer read FFilterFormWidth_ write FFilterFormWidth_;
    property FFilterFormHeight: integer read FFilterFormHeight_ write FFilterFormHeight_;
  end;

  TModuleInfo = class
  private
    module_: TFastModule;
    moduleDatas_: TList<TFastModuleData>;
    moduleUIs_: TList<TFastModuleUI>;
    moduleLayout_: TFastModuleLayout;
  public
    constructor Create;
    destructor Destroy; override;
  published
    property module: TFastModule read module_ write module_;
    property moduleDatas: TList<TFastModuleData> read moduleDatas_ write moduleDatas_;
    property moduleUIs: TList<TFastModuleUI> read moduleUIs_ write moduleUIs_;
    property moduleLayout: TFastModuleLayout read moduleLayout_ write moduleLayout_;
  end;

  TOneFastModuleManage = class
  private
    FStop: boolean;
    FLockObj: TObject;
    FZTCode: string;
    FModuleInfos: TDictionary<string, TModuleInfo>;
  public
    constructor Create;
    destructor Destroy; override;
  public
    function GetModuleInfo(QModuleCode: string; var QErrMsg: string): TModuleInfo;
    function RefreshModuleInfo(QModuleCode: string; var QErrMsg: string): boolean;
    function RefreshModuleInfoAll(var QErrMsg: string): boolean;
  published
    property ZTCode: string read FZTCode write FZTCode;
    property ModuleInfos: TDictionary<string, TModuleInfo> read FModuleInfos write FModuleInfos;
  end;

function UnitFastModuleManage(): TOneFastModuleManage;

var
  unit_FastModuleManage: TOneFastModuleManage = nil;

implementation

uses OneOrm;

function UnitFastModuleManage(): TOneFastModuleManage;
begin
  if unit_FastModuleManage = nil then
  begin
    unit_FastModuleManage := TOneFastModuleManage.Create;
  end;
  Result := unit_FastModuleManage;
end;

constructor TFastModuleData.Create;
begin
  inherited Create;
  self.FChildParams_ := TList<TFastModuleDataParam>.Create;
  self.FChildFields_ := TList<TFastModuleField>.Create;
end;

destructor TFastModuleData.Destroy;
var
  i: integer;
begin
  for i := 0 to self.FChildParams_.Count - 1 do
  begin
    self.FChildParams_[i].Free;
  end;
  self.FChildParams_.clear;
  self.FChildParams_.Free;

  for i := 0 to self.FChildFields_.Count - 1 do
  begin
    self.FChildFields_[i].Free;
  end;
  self.FChildFields_.clear;
  self.FChildFields_.Free;
  inherited Destroy;
end;

constructor TFastModuleUI.Create;
begin
  inherited Create;
  self.FChildBands_ := TList<TFastModuleBand>.Create;
  self.FChildControls_ := TList<TFastModuleControl>.Create;
  self.FChildFilters_ := TList<TFastModuleFilter>.Create;
  self.FChildButtons_ := TList<TFastModuleButton>.Create;
  self.FChildButtonpops_ := TList<TFastModuleButtonpop>.Create;
end;

destructor TFastModuleUI.Destroy;
var
  i: integer;
begin
  for i := 0 to self.FChildBands_.Count - 1 do
  begin
    self.FChildBands_[i].Free;
  end;
  self.FChildBands_.clear;
  self.FChildBands_.Free;
  //
  for i := 0 to self.FChildControls_.Count - 1 do
  begin
    self.FChildControls_[i].Free;
  end;
  self.FChildControls_.clear;
  self.FChildControls_.Free;
  for i := 0 to self.FChildFilters_.Count - 1 do
  begin
    self.FChildFilters_[i].Free;
  end;
  self.FChildFilters_.clear;
  self.FChildFilters_.Free;
  for i := 0 to self.FChildButtons_.Count - 1 do
  begin
    self.FChildButtons_[i].Free;
  end;
  self.FChildButtons_.clear;
  self.FChildButtons_.Free;
  for i := 0 to self.FChildButtonpops_.Count - 1 do
  begin
    self.FChildButtonpops_[i].Free;
  end;
  self.FChildButtonpops_.clear;
  self.FChildButtonpops_.Free;
  inherited Destroy;
end;

constructor TFastModuleBand.Create;
begin
  self.FChildBands_ := TList<TFastModuleBand>.Create;
end;

destructor TFastModuleBand.Destroy;
var
  i: integer;
begin
  for i := 0 to self.FChildBands_.Count - 1 do
  begin
    self.FChildBands_[i].Free;
  end;
  self.FChildBands_.clear;
  self.FChildBands_.Free;
end;

constructor TFastModuleButton.Create;
begin
  self.FChildButtons_ := TList<TFastModuleButton>.Create;
end;

destructor TFastModuleButton.Destroy;
var
  i: integer;
begin
  for i := 0 to self.FChildButtons_.Count - 1 do
  begin
    self.FChildButtons_[i].Free;
  end;
  self.FChildButtons_.clear;
  self.FChildButtons_.Free;
end;

constructor TModuleInfo.Create;
begin
  inherited Create;
  module_ := nil;
  moduleLayout_ := nil;
  moduleDatas_ := TList<TFastModuleData>.Create;
  moduleUIs_ := TList<TFastModuleUI>.Create;
end;

destructor TModuleInfo.Destroy;
var
  i: integer;
begin
  if module_ <> nil then
    module_.Free;
  for i := 0 to moduleDatas_.Count - 1 do
  begin
    moduleDatas_[i].Free;
  end;
  moduleDatas_.clear;
  moduleDatas_.Free;

  for i := 0 to moduleUIs_.Count - 1 do
  begin
    moduleUIs_[i].Free;
  end;
  moduleUIs_.clear;
  moduleUIs_.Free;
  if moduleLayout_ <> nil then
    moduleLayout_.Free;
  inherited Destroy;
end;

constructor TOneFastModuleManage.Create;
begin
  inherited Create;
  self.FModuleInfos := TDictionary<string, TModuleInfo>.Create;
  self.FLockObj := TObject.Create;
  self.FZTCode := '';
  self.FStop := false;
end;

destructor TOneFastModuleManage.Destroy;
var
  i: integer;
  lModuleInfo: TModuleInfo;
begin
  for lModuleInfo in self.FModuleInfos.Values do
  begin
    lModuleInfo.Free;
  end;
  self.FModuleInfos.clear;
  self.FModuleInfos.Free;
  inherited Destroy;
end;

function TOneFastModuleManage.GetModuleInfo(QModuleCode: string; var QErrMsg: string): TModuleInfo;
var
  lModuleInfo: TModuleInfo;
  lModuleList: TList<TFastModule>;
  lOrmModule: IOneOrm<TFastModule>;
  //
  lModule: TFastModule;
  lData: TFastModuleData;
  lParam: TFastModuleDataParam;
  lField: TFastModuleField;
  lUI: TFastModuleUI;
  lBand, lPBand: TFastModuleBand;
  lControl: TFastModuleControl;
  lFilter: TFastModuleFilter;
  lButton, lPButton: TFastModuleButton;
  lButtonpop: TFastModuleButtonpop;
  //
  lOrmData: IOneOrm<TFastModuleData>;
  lOrmDataParam: IOneOrm<TFastModuleDataParam>;
  lOrmField: IOneOrm<TFastModuleField>;
  lOrmUI: IOneOrm<TFastModuleUI>;
  lOrmBand: IOneOrm<TFastModuleBand>;
  lOrmControl: IOneOrm<TFastModuleControl>;
  lOrmFilter: IOneOrm<TFastModuleFilter>;
  lOrmButton: IOneOrm<TFastModuleButton>;
  lOrmButtonpop: IOneOrm<TFastModuleButtonpop>;
  lOrmLayout: IOneOrm<TFastModuleLayout>;
  lModuleDatas: TList<TFastModuleData>;
  lModuleDataParams: TList<TFastModuleDataParam>;
  lModuleFields: TList<TFastModuleField>;
  lModuleUIs: TList<TFastModuleUI>;
  lModuleBands: TList<TFastModuleBand>;
  lModuleControls: TList<TFastModuleControl>;
  lModuleFilters: TList<TFastModuleFilter>;
  lModuleButtons: TList<TFastModuleButton>;
  lModuleButtonpops: TList<TFastModuleButtonpop>;
  lModuleLayouts: TList<TFastModuleLayout>;
  isErr, isRepate: boolean;
  i, iData, iParam, iField, iUI, iBand, iControl, iFilter, iButton: integer;
  lDictBands: TDictionary<string, TFastModuleBand>;
  lDictButtons: TDictionary<string, TFastModuleButton>;
  lObjList: TList<TObject>;
  lIntList: TList<integer>;
begin
  Result := nil;
  QErrMsg := '';
  isErr := false;
  isRepate := false;
  if self.FStop then
  begin
    QErrMsg := '模块管理已禁用';
    exit;
  end;
  if self.FModuleInfos.ContainsKey(QModuleCode) then
  begin
    self.FModuleInfos.TryGetValue(QModuleCode, lModuleInfo);
    if not lModuleInfo.module.FIsStart then
    begin
      QErrMsg := '模块[' + QModuleCode + ']未启用';
      exit;
    end;
    Result := lModuleInfo;
    exit;
  end;
  lModuleList := nil;
  lModuleDatas := nil;
  lModuleDataParams := nil;
  lModuleFields := nil;
  lModuleUIs := nil;
  lModuleBands := nil;
  lModuleControls := nil;
  lModuleFilters := nil;
  lModuleButtons := nil;
  lModuleButtonpops := nil;
  lModuleLayouts := nil;
  lModule := nil;
  lDictBands := nil;
  lDictButtons := nil;
  lObjList := TList<TObject>.Create;
  lIntList := TList<integer>.Create;
  try
    // 查询模块信息
    lOrmModule := TOneOrm<TFastModule>.Start();
    try
      lModuleList := lOrmModule.ZTCode(self.FZTCode).Query('select * from onefast_module where FModuleCode=:FModuleCode', [QModuleCode]).ToList();
    except
      on e: Exception do
      begin
        isErr := true;
        QErrMsg := e.Message;
        exit;
      end;
    end;
    if lModuleList.Count = 0 then
    begin
      isErr := true;
      QErrMsg := '不存在此模板代码配置';
      exit;
    end;
    lModule := lModuleList[0];
    for i := lModuleList.Count - 1 downto 0 do
    begin
      lObjList.Add(lModuleList[i]);
      lModuleList.Delete(i);
    end;

    if lModuleList.Count > 1 then
    begin
      isErr := true;
      QErrMsg := '此模板代码配置[' + QModuleCode + ']重复,请联系管理员修正';
      exit;
    end;

    if not lModule.FIsStart then
    begin
      isErr := true;
      QErrMsg := '此模板代码配置[' + QModuleCode + ']未启用';
      exit;
    end;

    // 查询模块相关信息
    lOrmData := TOneOrm<TFastModuleData>.Start();
    lOrmDataParam := TOneOrm<TFastModuleDataParam>.Start();
    lOrmField := TOneOrm<TFastModuleField>.Start();
    lOrmUI := TOneOrm<TFastModuleUI>.Start();
    lOrmBand := TOneOrm<TFastModuleBand>.Start();
    lOrmControl := TOneOrm<TFastModuleControl>.Start();
    lOrmFilter := TOneOrm<TFastModuleFilter>.Start();
    lOrmButton := TOneOrm<TFastModuleButton>.Start();
    lOrmButtonpop := TOneOrm<TFastModuleButtonpop>.Start();
    lOrmLayout := TOneOrm<TFastModuleLayout>.Start();
    lDictBands := TDictionary<string, TFastModuleBand>.Create;
    lDictButtons := TDictionary<string, TFastModuleButton>.Create;
    try
      lModuleDatas := lOrmData.ZTCode(self.FZTCode).Query('select * from onefast_module_data where FModuleID=:FModuleID order by FOrderNumber desc ', [lModule.FModuleID]).ToList();
      lModuleDataParams := lOrmDataParam.ZTCode(self.FZTCode).Query('select * from onefast_module_dataparam where FModuleID=:FModuleID order by FOrderNumber desc ', [lModule.FModuleID]).ToList();
      lModuleFields := lOrmField.ZTCode(self.FZTCode).Query('select * from onefast_module_field where FModuleID=:FModuleID order by FOrderNumber desc ', [lModule.FModuleID]).ToList();
      lModuleUIs := lOrmUI.ZTCode(self.FZTCode).Query('select * from onefast_module_ui where FModuleID=:FModuleID order by FOrderNumber desc ', [lModule.FModuleID]).ToList();
      lModuleBands := lOrmBand.ZTCode(self.FZTCode).Query('select * from onefast_module_uiband where FModuleID=:FModuleID order by FTreeCode desc ', [lModule.FModuleID]).ToList();
      lModuleControls := lOrmControl.ZTCode(self.FZTCode).Query('select * from onefast_module_uicontrol where FModuleID=:FModuleID order by FOrderNumber desc ', [lModule.FModuleID]).ToList();
      lModuleFilters := lOrmFilter.ZTCode(self.FZTCode).Query('select * from onefast_module_uifilter where FModuleID=:FModuleID order by FOrderNumber desc ', [lModule.FModuleID]).ToList();
      lModuleButtons := lOrmButton.ZTCode(self.FZTCode).Query('select * from onefast_module_uibutton where FModuleID=:FModuleID order by FButtonTreeCode asc ', [lModule.FModuleID]).ToList();
      lModuleButtonpops := lOrmButtonpop.ZTCode(self.FZTCode).Query('select * from onefast_module_uibuttonpop where FModuleID=:FModuleID order by FButtonTreeCode desc ', [lModule.FModuleID]).ToList();
      lModuleLayouts := lOrmLayout.ZTCode(self.FZTCode).Query('select * from onefast_module_layout where FModuleID=:FModuleID', [lModule.FModuleID]).ToList();
    except
      on e: Exception do
      begin
        isErr := true;
        QErrMsg := e.Message;
        exit;
      end;
    end;
    // 数据集组装
    Result := TModuleInfo.Create;
    Result.module := lModule;
    for iData := lModuleDatas.Count - 1 downto 0 do
    begin
      lData := lModuleDatas[iData];
      Result.moduleDatas.Add(lData);
      lObjList.Add(lData);
      lModuleDatas.Delete(iData);
      if lData.ChildFields = nil then
        lData.ChildFields := TList<TFastModuleField>.Create;
      for iField := lModuleFields.Count - 1 downto 0 do
      begin
        lField := lModuleFields[iField];
        if lField.FDataID = lData.FDataID then
        begin
          lData.ChildFields.Add(lField);
          lObjList.Add(lField);
          lModuleFields.Delete(iField);
        end;
      end;
      for iParam := lModuleDataParams.Count - 1 downto 0 do
      begin
        lParam := lModuleDataParams[iParam];
        if lParam.FDataID = lData.FDataID then
        begin
          lData.ChildParams.Add(lParam);
          lObjList.Add(lParam);
          lModuleDataParams.Delete(iParam);
        end;
      end;
    end;
    // UI组装
    for iUI := lModuleUIs.Count - 1 downto 0 do
    begin
      lUI := lModuleUIs[iUI];
      Result.moduleUIs.Add(lUI);
      lObjList.Add(lUI);
      lModuleUIs.Delete(iUI);

      for iControl := lModuleControls.Count - 1 downto 0 do
      begin
        lControl := lModuleControls[iControl];
        if lControl.FUIID = lUI.FUIID then
        begin
          lUI.ChildControls.Add(lControl);
          lObjList.Add(lControl);
          lModuleControls.Delete(iControl);
        end;
      end;

      for iFilter := lModuleFilters.Count - 1 downto 0 do
      begin
        lFilter := lModuleFilters[iFilter];
        if lFilter.FUIID = lUI.FUIID then
        begin
          lUI.ChildFilters.Add(lFilter);
          lObjList.Add(lFilter);
          lModuleFilters.Delete(iFilter);
        end;
      end;

      for iBand := lModuleBands.Count - 1 downto 0 do
      begin
        lBand := lModuleBands[iBand];
        if lBand.FUIID = lUI.FUIID then
        begin
          lDictBands.Add(lBand.FBandID, lBand);
          lObjList.Add(lBand);
          lModuleBands.Delete(iBand);
          if lBand.FPBandID <> '' then
          begin
            if lDictBands.TryGetValue(lBand.FPBandID, lPBand) then
            begin
              lPBand.ChildBands.Add(lBand);
              continue;
            end;
          end;
          lUI.ChildBands.Add(lBand);
        end;
      end;

      //
      lIntList.clear;
      for iButton := 0 to lModuleButtons.Count - 1 do
      begin
        lButton := lModuleButtons[iButton];
        if lButton.FUIID = lUI.FUIID then
        begin
          lDictButtons.Add(lButton.FButtonID, lButton);
          lObjList.Add(lButton);
          lIntList.Add(iButton);
          if lButton.FPButtonID <> '' then
          begin
            if lDictButtons.TryGetValue(lButton.FPButtonID, lPButton) then
            begin
              lPButton.ChildButtons.Add(lButton);
              continue;
            end;
          end;
          lUI.ChildButtons.Add(lButton);
        end;
      end;
      for iButton := lIntList.Count - 1 downto 0 do
      begin
        lModuleButtons.Delete(lIntList[iButton]);
      end;

      for iButton := lModuleButtonpops.Count - 1 downto 0 do
      begin
        lButtonpop := lModuleButtonpops[iButton];
        if lButtonpop.FUIID = lUI.FUIID then
        begin
          lUI.ChildButtonpops.Add(lButtonpop);
          lObjList.Add(lButtonpop);
          lModuleButtonpops.Delete(iButton);
        end;
      end;
    end;
    // 布局
    if lModuleLayouts.Count = 0 then
    begin
      Result.moduleLayout_ := TFastModuleLayout.Create;
    end
    else
    begin
      Result.moduleLayout_ := lModuleLayouts[0];
    end;

    for i := lModuleLayouts.Count - 1 downto 0 do
    begin
      lObjList.Add(lModuleLayouts[i]);
      lModuleLayouts.Delete(i);
    end;

    TMonitor.Enter(self.FLockObj);
    try
      if self.FModuleInfos.ContainsKey(QModuleCode) then
      begin
        isRepate := true;
        self.FModuleInfos.TryGetValue(QModuleCode, lModuleInfo);
        Result := lModuleInfo;
        exit;
      end
      else
      begin
        self.FModuleInfos.Add(QModuleCode, Result);
      end;
    finally
      TMonitor.exit(self.FLockObj);
    end;
  finally
    if lDictBands <> nil then
    begin
      lDictBands.clear;
      lDictBands.Free;
    end;

    if lDictButtons <> nil then
    begin
      lDictButtons.clear;
      lDictButtons.Free;
    end;
    if lModuleList <> nil then
    begin
      for i := 0 to lModuleList.Count - 1 do
      begin
        lModuleList[i].Free;
      end;
      lModuleList.clear;
      lModuleList.Free;
    end;
    if lModuleDatas <> nil then
    begin
      for i := 0 to lModuleDatas.Count - 1 do
      begin
        lModuleDatas[i].Free;
      end;
      lModuleDatas.clear;
      lModuleDatas.Free;
    end;
    if lModuleBands <> nil then
    begin
      for i := 0 to lModuleBands.Count - 1 do
      begin
        lModuleBands[i].Free;
      end;
      lModuleBands.clear;
      lModuleBands.Free;
    end;
    if lModuleDataParams <> nil then
    begin
      for i := 0 to lModuleDataParams.Count - 1 do
      begin
        lModuleDataParams[i].Free;
      end;
      lModuleDataParams.clear;
      lModuleDataParams.Free;
    end;
    if lModuleFields <> nil then
    begin
      for i := 0 to lModuleFields.Count - 1 do
      begin
        lModuleFields[i].Free;
      end;
      lModuleFields.clear;
      lModuleFields.Free;
    end;
    if lModuleUIs <> nil then
    begin
      for i := 0 to lModuleUIs.Count - 1 do
      begin
        lModuleUIs[i].Free;
      end;
      lModuleUIs.clear;
      lModuleUIs.Free;
    end;
    if lModuleControls <> nil then
    begin
      for i := 0 to lModuleControls.Count - 1 do
      begin
        lModuleControls[i].Free;
      end;
      lModuleControls.clear;
      lModuleControls.Free;
    end;
    if lModuleFilters <> nil then
    begin
      for i := 0 to lModuleFilters.Count - 1 do
      begin
        lModuleFilters[i].Free;
      end;
      lModuleFilters.clear;
      lModuleFilters.Free;
    end;
    if lModuleButtons <> nil then
    begin
      for i := 0 to lModuleButtons.Count - 1 do
      begin
        lModuleButtons[i].Free;
      end;
      lModuleButtons.clear;
      lModuleButtons.Free;
    end;
    if lModuleButtonpops <> nil then
    begin
      for i := 0 to lModuleButtonpops.Count - 1 do
      begin
        lModuleButtonpops[i].Free;
      end;
      lModuleButtonpops.clear;
      lModuleButtonpops.Free;
    end;
    if lModuleLayouts <> nil then
    begin
      for i := 0 to lModuleLayouts.Count - 1 do
      begin
        lModuleLayouts[i].Free;
      end;
      lModuleLayouts.clear;
      lModuleLayouts.Free;
    end;
    if (isErr) or (isRepate) then
    begin

      for i := 0 to lObjList.Count - 1 do
      begin
        lObjList[i].Free;
      end;
    end;
    lObjList.clear;
    lObjList.Free;
    lIntList.clear;
    lIntList.Free;
  end;

end;

function TOneFastModuleManage.RefreshModuleInfo(QModuleCode: string; var QErrMsg: string): boolean;
begin
  Result := false;
  QErrMsg := '';
  self.FModuleInfos.Remove(QModuleCode);
  self.GetModuleInfo(QModuleCode, QErrMsg);
  Result := (QErrMsg = '');
end;

function TOneFastModuleManage.RefreshModuleInfoAll(var QErrMsg: string): boolean;
var
  lModuleInfo: TModuleInfo;
  lModuleList: TList<TFastModule>;
  lOrmModule: IOneOrm<TFastModule>;
  //
  lModule: TFastModule;
  lData: TFastModuleData;
  lParam: TFastModuleDataParam;
  lField: TFastModuleField;
  lUI: TFastModuleUI;
  lBand, lPBand: TFastModuleBand;
  lControl: TFastModuleControl;
  lFilter: TFastModuleFilter;
  lButton, lPButton: TFastModuleButton;
  lButtonpop: TFastModuleButtonpop;
  lLayout: TFastModuleLayout;
  //
  lOrmData: IOneOrm<TFastModuleData>;
  lOrmDataParam: IOneOrm<TFastModuleDataParam>;
  lOrmField: IOneOrm<TFastModuleField>;
  lOrmUI: IOneOrm<TFastModuleUI>;
  lOrmBand: IOneOrm<TFastModuleBand>;
  lOrmControl: IOneOrm<TFastModuleControl>;
  lOrmFilter: IOneOrm<TFastModuleFilter>;
  lOrmButton: IOneOrm<TFastModuleButton>;
  lOrmButtonpop: IOneOrm<TFastModuleButtonpop>;
  lOrmLayout: IOneOrm<TFastModuleLayout>;
  lModuleDatas: TList<TFastModuleData>;
  lModuleDataParams: TList<TFastModuleDataParam>;
  lModuleFields: TList<TFastModuleField>;
  lModuleUIs: TList<TFastModuleUI>;
  lModuleBands: TList<TFastModuleBand>;
  lModuleControls: TList<TFastModuleControl>;
  lModuleFilters: TList<TFastModuleFilter>;
  lModuleButtons: TList<TFastModuleButton>;
  lModuleButtonpops: TList<TFastModuleButtonpop>;
  lModuleLayouts: TList<TFastModuleLayout>;
  isErr, isRepate: boolean;
  i, iModule, iData, iParam, iField, iUI, iBand, iControl, iFilter, iButton, iLayout: integer;
  iDataStep, iUIStep, iChildStep: integer;
  //
  lDictModuleCodes: TDictionary<string, boolean>;
  lDictBands: TDictionary<string, TFastModuleBand>;
  lDictButtons: TDictionary<string, TFastModuleButton>;

  lObjList: TList<TObject>;
  lIntList: TList<integer>;
begin
  Result := false;

  lModuleList := nil;
  lModuleDatas := nil;
  lModuleDataParams := nil;
  lModuleFields := nil;
  lModuleUIs := nil;
  lModuleBands := nil;
  lModuleControls := nil;
  lModuleFilters := nil;
  lModuleButtons := nil;
  lModuleButtonpops := nil;
  lModuleLayouts := nil;
  lModule := nil;
  lDictModuleCodes := nil;
  lDictBands := nil;
  lDictButtons := nil;
  lObjList := TList<TObject>.Create;
  lIntList := TList<integer>.Create;
  TMonitor.Enter(self.FLockObj);
  try
    for lModuleInfo in self.FModuleInfos.Values do
    begin
      lModuleInfo.Free;
    end;
    self.FModuleInfos.clear;
    //
    lOrmModule := TOneOrm<TFastModule>.Start();
    lModuleList := lOrmModule.ZTCode(self.FZTCode).Query('select * from onefast_module order by FModuleID asc', []).ToList();
    if lModuleList.Count = 0 then
      exit;
    lDictModuleCodes := TDictionary<string, boolean>.Create;
    for iModule := lModuleList.Count - 1 downto 0 do
    begin
      lModule := lModuleList[iModule];
      if lModule.FModuleCode = '' then
      begin
        lModule.Free;
        lModuleList.Delete(iModule);
        continue;
      end;
      if lDictModuleCodes.ContainsKey(lModule.FModuleCode) then
      begin
        isErr := true;
        QErrMsg := '模板代码配置[' + lModule.FModuleCode + ']重复,请联系管理员修正';
        exit;
      end;
      lDictModuleCodes.Add(lModule.FModuleCode, true);
    end;

    // 查询模块相关信息
    lOrmData := TOneOrm<TFastModuleData>.Start();
    lOrmDataParam := TOneOrm<TFastModuleDataParam>.Start();
    lOrmField := TOneOrm<TFastModuleField>.Start();
    lOrmUI := TOneOrm<TFastModuleUI>.Start();
    lOrmBand := TOneOrm<TFastModuleBand>.Start();
    lOrmControl := TOneOrm<TFastModuleControl>.Start();
    lOrmFilter := TOneOrm<TFastModuleFilter>.Start();
    lOrmButton := TOneOrm<TFastModuleButton>.Start();
    lOrmButtonpop := TOneOrm<TFastModuleButtonpop>.Start();
    lOrmLayout := TOneOrm<TFastModuleLayout>.Start();
    lDictBands := TDictionary<string, TFastModuleBand>.Create;
    lDictButtons := TDictionary<string, TFastModuleButton>.Create;
    try
      lModuleDatas := lOrmData.ZTCode(self.FZTCode).Query('select * from onefast_module_data order by FModuleID asc, FOrderNumber desc ', []).ToList();
      lModuleDataParams := lOrmDataParam.ZTCode(self.FZTCode).Query('select * from onefast_module_dataparam order by FModuleID asc,FDataID asc, FOrderNumber desc ', []).ToList();
      lModuleFields := lOrmField.ZTCode(self.FZTCode).Query('select * from onefast_module_field order by FModuleID asc, FDataID asc, FOrderNumber desc ', []).ToList();
      lModuleUIs := lOrmUI.ZTCode(self.FZTCode).Query('select * from onefast_module_ui order by FModuleID asc, FOrderNumber desc ', []).ToList();
      lModuleBands := lOrmBand.ZTCode(self.FZTCode).Query('select * from onefast_module_uiband order by FModuleID asc, FUIID asc , FTreeCode desc ', []).ToList();
      lModuleControls := lOrmControl.ZTCode(self.FZTCode).Query('select * from onefast_module_uicontrol order by FModuleID asc, FUIID asc, FOrderNumber desc ', []).ToList();
      lModuleFilters := lOrmFilter.ZTCode(self.FZTCode).Query('select * from onefast_module_uifilter order by FModuleID asc, FUIID asc, FOrderNumber desc ', []).ToList();
      lModuleButtons := lOrmButton.ZTCode(self.FZTCode).Query('select * from onefast_module_uibutton order by FModuleID asc, FUIID asc,FButtonTreeCode asc ', []).ToList();
      lModuleButtonpops := lOrmButtonpop.ZTCode(self.FZTCode).Query('select * from onefast_module_uibuttonpop  order by FModuleID asc, FUIID asc,FButtonTreeCode desc ', []).ToList();
      lModuleLayouts := lOrmLayout.ZTCode(self.FZTCode).Query('select * from onefast_module_layout  order by FModuleID asc', []).ToList();
      // 处理数据关联
      for iModule := lModuleList.Count - 1 downto 0 do
      begin
        lModule := lModuleList[iModule];
        lModuleInfo := TModuleInfo.Create;
        self.FModuleInfos.Add(lModule.FModuleCode, lModuleInfo);
        lModuleInfo.module := lModule;
        lObjList.Add(lModule);
        lModuleList.Delete(iModule);
        iDataStep := 0;
        iUIStep := 0;
        // 数据集
        for iData := lModuleDatas.Count - 1 downto 0 do
        begin
          lData := lModuleDatas[iData];
          if lData.FModuleID <> lModule.FModuleID then
          begin
            if iDataStep = 1 then
            begin
              // 减少不必要的循环,因为是按FModuleID排序,，一样后有不一样,说明已经完成了本模块的循环
              break;
            end
            else
            begin
              continue;
            end;
          end;
          iDataStep := 1;
          lModuleInfo.moduleDatas.Add(lData);
          lObjList.Add(lData);
          lModuleDatas.Delete(iData);
          iChildStep := 0;
          for iField := lModuleFields.Count - 1 downto 0 do
          begin
            lField := lModuleFields[iField];
            if lField.FDataID = lData.FDataID then
            begin
              iChildStep := 1;
              lData.ChildFields.Add(lField);
              lObjList.Add(lField);
              lModuleFields.Delete(iField);
            end
            else
            begin
              if iChildStep = 1 then
              begin
                break;
              end;
            end;
          end;

          iChildStep := 0;
          for iParam := lModuleDataParams.Count - 1 downto 0 do
          begin
            lParam := lModuleDataParams[iParam];
            if lParam.FDataID = lData.FDataID then
            begin
              iChildStep := 1;
              lData.ChildParams.Add(lParam);
              lObjList.Add(lParam);
              lModuleDataParams.Delete(iParam);
            end
            else
            begin
              if iChildStep = 1 then
              begin
                break;
              end;
            end;
          end;
        end;
        // UI
        for iUI := lModuleUIs.Count - 1 downto 0 do
        begin
          lUI := lModuleUIs[iUI];
          if lUI.FModuleID <> lModule.FModuleID then
          begin
            if iUIStep = 1 then
            begin
              // 减少不必要的循环,因为是按FModuleID排序,，一样后有不一样,说明已经完成了本模块的循环
              break;
            end
            else
            begin
              continue;
            end;
          end;
          iUIStep := 1;
          lModuleInfo.moduleUIs.Add(lUI);
          lObjList.Add(lUI);
          lModuleUIs.Delete(iUI);
          // 控件
          iChildStep := 0;
          for iControl := lModuleControls.Count - 1 downto 0 do
          begin
            lControl := lModuleControls[iControl];
            if lControl.FUIID = lUI.FUIID then
            begin
              iChildStep := 1;
              lUI.ChildControls.Add(lControl);
              lObjList.Add(lControl);
              lModuleControls.Delete(iControl);
            end
            else
            begin
              if iChildStep = 1 then
              begin
                // 减少不必要的循环,因为是按FUIID排序,，一样后有不一样,说明已经完成了本UI的循环
                break;
              end;
            end;
          end;

          iChildStep := 0;
          for iFilter := lModuleFilters.Count - 1 downto 0 do
          begin
            lFilter := lModuleFilters[iFilter];
            if lFilter.FUIID = lUI.FUIID then
            begin
              iChildStep := 1;
              lUI.ChildFilters.Add(lFilter);
              lObjList.Add(lFilter);
              lModuleFilters.Delete(iFilter);
            end
            else
            begin
              if iChildStep = 1 then
              begin
                // 减少不必要的循环,因为是按FUIID排序,，一样后有不一样,说明已经完成了本UI的循环
                break;
              end;
            end;
          end;

          iChildStep := 0;
          for iBand := lModuleBands.Count - 1 downto 0 do
          begin
            lBand := lModuleBands[iBand];
            if lBand.FUIID = lUI.FUIID then
            begin
              iChildStep := 1;
              lDictBands.Add(lBand.FBandID, lBand);
              lObjList.Add(lBand);
              lModuleBands.Delete(iBand);
              if lBand.FPBandID <> '' then
              begin
                if lDictBands.TryGetValue(lBand.FPBandID, lPBand) then
                begin
                  lPBand.ChildBands.Add(lBand);
                  continue;
                end;
              end;
              lUI.ChildBands.Add(lBand);
            end
            else
            begin
              if iChildStep = 1 then
              begin
                // 减少不必要的循环,因为是按FUIID排序,，一样后有不一样,说明已经完成了本UI的循环
                break;
              end;
            end;
          end;

          lIntList.clear;
          iChildStep := 0;
          for iButton := 0 to lModuleButtons.Count - 1 do
          begin
            lButton := lModuleButtons[iButton];
            if lButton.FUIID = lUI.FUIID then
            begin
              iChildStep := 1;
              lDictButtons.Add(lButton.FButtonID, lButton);
              lObjList.Add(lButton);
              lIntList.Add(iButton);
              if lButton.FPButtonID <> '' then
              begin
                if lDictButtons.TryGetValue(lButton.FPButtonID, lPButton) then
                begin
                  lPButton.ChildButtons.Add(lButton);
                  continue;
                end;
              end;
              lUI.ChildButtons.Add(lButton);
            end
            else
            begin
              if iChildStep = 1 then
              begin
                // 减少不必要的循环,因为是按FUIID排序,，一样后有不一样,说明已经完成了本UI的循环
                break;
              end;
            end;
          end;
          for iButton := lIntList.Count - 1 downto 0 do
          begin
            lModuleButtons.Delete(lIntList[iButton]);
          end;

          iChildStep := 0;
          for iButton := lModuleButtonpops.Count - 1 downto 0 do
          begin
            lButtonpop := lModuleButtonpops[iButton];
            if lButtonpop.FUIID = lUI.FUIID then
            begin
              iChildStep := 1;
              lUI.ChildButtonpops.Add(lButtonpop);
              lObjList.Add(lButtonpop);
              lModuleButtonpops.Delete(iButton);
            end
            else
            begin
              if iChildStep = 1 then
              begin
                // 减少不必要的循环,因为是按FUIID排序,，一样后有不一样,说明已经完成了本UI的循环
                break;
              end;
            end;
          end;
        end;

        for iLayout := lModuleLayouts.Count - 1 downto 0 do
        begin
          lLayout := lModuleLayouts[iLayout];
          if lLayout.FModuleID = lModule.FModuleID then
          begin
            lModuleInfo.moduleLayout := lLayout;
            lObjList.Add(lLayout);
            lModuleLayouts.Delete(iLayout);
            break;
          end;
        end;
      end;
      Result := true;
    except
      on e: Exception do
      begin
        isErr := true;
        QErrMsg := e.Message;
        exit;
      end;
    end;
  finally
    TMonitor.exit(self.FLockObj);
    if lDictModuleCodes <> nil then
    begin
      lDictModuleCodes.clear;
      lDictModuleCodes.Free;
    end;
    if lDictBands <> nil then
    begin
      lDictBands.clear;
      lDictBands.Free;
    end;
    if lDictButtons <> nil then
    begin
      lDictButtons.clear;
      lDictButtons.Free;
    end;

    if lModuleList <> nil then
    begin
      for i := 0 to lModuleList.Count - 1 do
      begin
        lModuleList[i].Free;
      end;
      lModuleList.clear;
      lModuleList.Free;
    end;
    if lModuleDatas <> nil then
    begin
      for i := 0 to lModuleDatas.Count - 1 do
      begin
        lModuleDatas[i].Free;
      end;
      lModuleDatas.clear;
      lModuleDatas.Free;
    end;
    if lModuleDataParams <> nil then
    begin
      for i := 0 to lModuleDataParams.Count - 1 do
      begin
        lModuleDataParams[i].Free;
      end;
      lModuleDataParams.clear;
      lModuleDataParams.Free;
    end;
    if lModuleFields <> nil then
    begin
      for i := 0 to lModuleFields.Count - 1 do
      begin
        lModuleFields[i].Free;
      end;
      lModuleFields.clear;
      lModuleFields.Free;
    end;
    if lModuleUIs <> nil then
    begin
      for i := 0 to lModuleUIs.Count - 1 do
      begin
        lModuleUIs[i].Free;
      end;
      lModuleUIs.clear;
      lModuleUIs.Free;
    end;
    if lModuleBands <> nil then
    begin
      for i := 0 to lModuleBands.Count - 1 do
      begin
        lModuleBands[i].Free;
      end;
      lModuleBands.clear;
      lModuleBands.Free;
    end;
    if lModuleControls <> nil then
    begin
      for i := 0 to lModuleControls.Count - 1 do
      begin
        lModuleControls[i].Free;
      end;
      lModuleControls.clear;
      lModuleControls.Free;
    end;
    if lModuleFilters <> nil then
    begin
      for i := 0 to lModuleFilters.Count - 1 do
      begin
        lModuleFilters[i].Free;
      end;
      lModuleFilters.clear;
      lModuleFilters.Free;
    end;
    if lModuleButtons <> nil then
    begin
      for i := 0 to lModuleButtons.Count - 1 do
      begin
        lModuleButtons[i].Free;
      end;
      lModuleButtons.clear;
      lModuleButtons.Free;
    end;
    if lModuleButtonpops <> nil then
    begin
      for i := 0 to lModuleButtonpops.Count - 1 do
      begin
        lModuleButtonpops[i].Free;
      end;
      lModuleButtonpops.clear;
      lModuleButtonpops.Free;
    end;
    if lModuleLayouts <> nil then
    begin
      for i := 0 to lModuleLayouts.Count - 1 do
      begin
        lModuleLayouts[i].Free;
      end;
      lModuleLayouts.clear;
      lModuleLayouts.Free;
    end;

    if (isErr) or (isRepate) then
    begin
      for i := 0 to lObjList.Count - 1 do
      begin
        lObjList[i].Free;
      end;
    end;
    lObjList.clear;
    lObjList.Free;
    lIntList.clear;
    lIntList.Free;
  end;
end;

initialization

finalization

if unit_FastModuleManage <> nil then
  unit_FastModuleManage.Free;

end.

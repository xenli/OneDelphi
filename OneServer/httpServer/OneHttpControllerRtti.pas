unit OneHttpControllerRtti;

// 此单元的作用就是跟据反射解析继承 OneHttpController.TOneHttpController
// 把控制层类的反射信息相保存起来,放在缓存中
interface

uses
  System.TypInfo, System.Generics.Collections, System.Classes,
  System.Rtti, System.SysUtils;

type
  // 标准方法类型一等公民 resultProcedure=TEvenControllerProcedure
  emOneMethodType = (unknow, resultProcedure, sysProcedure, sysFunction);
  emOneMethodResultType = (unknowResult, numberResult, stringResult, boolResult, objResult, listResult, objListResult, genericsListResult, genericsObjListResult, mapResult, arrayResult, recordResult);
  // OneAll代表没有以下面为特殊规则的，不控制什么HTTPMethod可以访问,低版不采用注解
  // 方法头部 OneGetxxxx代表只支持Get方法
  // 方法头部 OnePost代表只支持Post方法
  // 方法头部 OnePath 代表 参数放在ulr路径 xxxx/参数1/参数2
  // 方法头部 OneForm代表只支持Post方法,且数据是表单形式 key1=value1&key2=value2&...
  // 方法头部 OneUpload代表是MulitePart提交包含文件
  emOneHttpMethodMode = (OneAll, OneGet, OnePost, OneForm, OnePath, OneDownload);

type
  TOneMethodRtti = class;
  TOneControllerRtti = class;

  TOneMethodRtti = class
  private
    FMethodName: string;
    FUrlMethod: string;
    FMethodType: emOneMethodType;
    FHttpMethodType: emOneHttpMethodMode;
    FRttiMethod: TRttiMethod;
    //
    FHaveClassParam: boolean;
    FParamCount: integer;
    FParamClassList: TList<TClass>;
    FParamIsArryList: TList<boolean>;
    //
    FResultRtti: TRttiType;
    FResultType: emOneMethodResultType;
    // 容器map key值类型
    FResultCollectionsKeyType: emOneMethodResultType;
    // 容器值类型
    FResultCollectionsValueType: emOneMethodResultType;
    FErrMsg: string;
  public
    constructor Create();
    destructor Destroy; override;
  public
    property MethodName: string read FMethodName;
    property UrlMethod: string read FUrlMethod write FUrlMethod;
    property MethodType: emOneMethodType read FMethodType;
    property HttpMethodType: emOneHttpMethodMode read FHttpMethodType;
    property RttiMethod: TRttiMethod read FRttiMethod;
    property HaveClassParam: boolean read FHaveClassParam;
    property ParamCount: integer read FParamCount;
    property ParamClassList: TList<TClass> read FParamClassList;
    property ParamIsArryList: TList<boolean> read FParamIsArryList;
    property ResultType: emOneMethodResultType read FResultType;
    property ResultRtti: TRttiType read FResultRtti;
    property ResultCollectionsKeyType: emOneMethodResultType read FResultCollectionsKeyType;
    property ResultCollectionsValueType: emOneMethodResultType read FResultCollectionsValueType;
    property ErrMsg: string read FErrMsg;
  end;

  TOneControllerRtti = class
  private
    // 方法反射信息 (方法名称,反射信息)
    FMethodList: TDictionary<string, TOneMethodRtti>;
    // 控制层反射信息
    FRttiContext: TRttiContext;
    FRttiType: TRttiType;
  private
    function IsJsonArr(QType: TRttiType): boolean;
    function ResultTypeIsGenericsCollections(qListType: TRttiType; QOneMethodRtti: TOneMethodRtti): boolean;
    // 判断是不是List容器
    function ResultTypeIsListCollections(qListType: TRttiType; QOneMethodRtti: TOneMethodRtti): boolean;
    // 判断是不是map容器
    function ResultTypeIsMapCollections(QMapType: TRttiType; QOneMethodRtti: TOneMethodRtti): boolean;
  public
    // 判断是不是泛型容器
    class function GetRttiTypeToResultType(qRttiType: TRttiType): emOneMethodResultType; static;
    constructor Create(QPersistentClass: TPersistentClass); overload;
    destructor Destroy; override;

    // 跟据控制层类,获取控制类的方法反射信息
    procedure GetMethodList(QPersistentClass: TPersistentClass);
    // 跟据方法名称获取方法的反射信息
    function GetRttiMethod(QMethodName: string): TOneMethodRtti;

  public
    property MethodList: TDictionary<string, TOneMethodRtti> read FMethodList;
  end;

implementation

constructor TOneMethodRtti.Create();
begin
  inherited Create;
  FParamCount := 0;
  FParamClassList := TList<TClass>.Create;
  FParamIsArryList := TList<boolean>.Create;
end;

destructor TOneMethodRtti.Destroy;
var
  i: integer;
begin
  for i := 0 to FParamClassList.Count - 1 do
  begin

  end;
  FParamClassList.Clear;
  FParamClassList.Free;
  FParamIsArryList.Clear;
  FParamIsArryList.Free;
  inherited Destroy;
end;

constructor TOneControllerRtti.Create(QPersistentClass: TPersistentClass);
begin
  inherited Create;
  FMethodList := TDictionary<string, TOneMethodRtti>.Create;
  self.GetMethodList(QPersistentClass);
end;

function TOneControllerRtti.GetRttiMethod(QMethodName: string): TOneMethodRtti;
var
  lItem: TOneMethodRtti;
begin
  Result := nil;
  if FMethodList.TryGetValue(QMethodName.ToLower, lItem) then
  begin
    Result := lItem;
  end;
end;

destructor TOneControllerRtti.Destroy;
var
  lItem: TOneMethodRtti;
begin
  for lItem in FMethodList.Values do
  begin
    try
      if lItem.FRttiMethod <> nil then
      begin
        // 这边不用释放,底程RTTI会自行管理
        lItem.FRttiMethod := nil;
        // lItem.FRttiMethod.Free;
      end;
    except

    end;
    lItem.FRttiMethod := nil;
    lItem.Free;
  end;
  FMethodList.Clear;
  FMethodList.Free;
  inherited Destroy;
end;

class function TOneControllerRtti.GetRttiTypeToResultType(qRttiType: TRttiType): emOneMethodResultType;
var
  LMethodGetEnumerator, LMethodAdd, LMethodClear: TRttiMethod;
begin
  Result := emOneMethodResultType.unknowResult;
  case qRttiType.TypeKind of
    tkInteger, tkFloat, tkInt64:
      begin
        Result := emOneMethodResultType.numberResult;
      end;
    tkString, tkUString, tkWChar, tkLString, tkWString, tkChar:
      begin
        Result := emOneMethodResultType.stringResult;
      end;
    tkClass:
      begin
        Result := emOneMethodResultType.objResult;
        LMethodGetEnumerator := qRttiType.GetMethod('GetEnumerator');
        if not Assigned(LMethodGetEnumerator) or (LMethodGetEnumerator.MethodKind <> mkFunction) or (LMethodGetEnumerator.ReturnType.Handle.Kind <> tkClass) then
          exit;
        LMethodClear := qRttiType.GetMethod('Clear');
        if not Assigned(LMethodClear) then
          exit;
        LMethodAdd := qRttiType.GetMethod('Add');
        if not Assigned(LMethodAdd) or (Length(LMethodAdd.GetParameters) <> 1) then
          exit;
        if qRttiType.Name.Contains('<') and (qRttiType.Name.Contains('>')) then
        begin
          Result := emOneMethodResultType.genericsListResult;
          // 是否是obj容器
          if qRttiType.GetProperty('OwnsObjects') <> nil then
          begin
            Result := emOneMethodResultType.genericsObjListResult;
          end;
        end
        else
        begin
          Result := emOneMethodResultType.listResult;
          if qRttiType.GetProperty('OwnsObjects') <> nil then
          begin
            Result := emOneMethodResultType.objListResult;
          end;
        end;
      end;
    tkRecord:
      begin
        Result := emOneMethodResultType.recordResult;
      end;
    tkArray, tkDynArray:
      begin
        Result := emOneMethodResultType.arrayResult;
      end;
  end;
end;

function TOneControllerRtti.IsJsonArr(QType: TRttiType): boolean;
var
  LMethodGetEnumerator: TRttiMethod;
begin
  Result := false;
  LMethodGetEnumerator := QType.GetMethod('GetEnumerator');
  if not Assigned(LMethodGetEnumerator) or (LMethodGetEnumerator.MethodKind <> mkFunction) or (LMethodGetEnumerator.ReturnType.Handle.Kind <> tkClass) then
    exit;
  Result := true;
end;

function TOneControllerRtti.ResultTypeIsGenericsCollections(qListType: TRttiType; QOneMethodRtti: TOneMethodRtti): boolean;
var
  LMethodGetEnumerator, LMethodAdd, LMethodClear: TRttiMethod;
  LItemType: TRttiType;
begin
  Result := false;
  if not qListType.Name.Contains('<') then
  begin
    exit;
  end;
  if not qListType.Name.Contains('>') then
  begin
    exit;
  end;
  LMethodGetEnumerator := qListType.GetMethod('GetEnumerator');
  if not Assigned(LMethodGetEnumerator) or (LMethodGetEnumerator.MethodKind <> mkFunction) or (LMethodGetEnumerator.ReturnType.Handle.Kind <> tkClass) then
    exit;

  LMethodClear := qListType.GetMethod('Clear');
  if not Assigned(LMethodClear) then
    exit;
  LMethodAdd := qListType.GetMethod('Add');
  if not Assigned(LMethodAdd) or (Length(LMethodAdd.GetParameters) <> 1) then
    exit;
  LItemType := LMethodAdd.GetParameters[0].ParamType;
  case LItemType.TypeKind of
    tkInteger, tkFloat, tkInt64:
      begin
        QOneMethodRtti.FResultCollectionsValueType := emOneMethodResultType.numberResult;
      end;
    tkString, tkUString, tkWChar, tkLString, tkWString, tkChar:
      begin
        QOneMethodRtti.FResultCollectionsValueType := emOneMethodResultType.stringResult;
      end;
    tkClass:
      begin
        QOneMethodRtti.FResultCollectionsValueType := emOneMethodResultType.objResult;
      end
  end;

  //
  QOneMethodRtti.FResultType := emOneMethodResultType.genericsListResult;
  // 是否是obj容器
  if qListType.GetProperty('OwnsObjects') <> nil then
  begin
    QOneMethodRtti.FResultType := emOneMethodResultType.genericsObjListResult;
  end;
  Result := true;
end;

function TOneControllerRtti.ResultTypeIsListCollections(qListType: TRttiType; QOneMethodRtti: TOneMethodRtti): boolean;
var
  LMethodGetEnumerator, LMethodAdd, LMethodClear: TRttiMethod;
  LItemType: TRttiType;
begin
  Result := false;
  if qListType.Name.Contains('<') then
  begin
    exit;
  end;
  if qListType.Name.Contains('>') then
  begin
    exit;
  end;
  LMethodGetEnumerator := qListType.GetMethod('GetEnumerator');
  if not Assigned(LMethodGetEnumerator) or (LMethodGetEnumerator.MethodKind <> mkFunction) or (LMethodGetEnumerator.ReturnType.Handle.Kind <> tkClass) then
    exit;

  LMethodClear := qListType.GetMethod('Clear');
  if not Assigned(LMethodClear) then
    exit;
  LMethodAdd := qListType.GetMethod('Add');
  if not Assigned(LMethodAdd) or (Length(LMethodAdd.GetParameters) <> 1) then
    exit;
  LItemType := LMethodAdd.GetParameters[0].ParamType;
  case LItemType.TypeKind of
    tkInteger, tkFloat, tkInt64:
      begin
        QOneMethodRtti.FResultCollectionsValueType := emOneMethodResultType.numberResult;
      end;
    tkString, tkUString, tkWChar, tkLString, tkWString, tkChar:
      begin
        QOneMethodRtti.FResultCollectionsValueType := emOneMethodResultType.stringResult;
      end;
    tkClass:
      begin
        QOneMethodRtti.FResultCollectionsValueType := emOneMethodResultType.objResult;
        // 有可以判断是不是泛型，不做这么多层处理
      end
  end;
  // 是否是obj容器
  QOneMethodRtti.FResultType := emOneMethodResultType.listResult;
  // 是否是obj容器
  if qListType.GetProperty('OwnsObjects') <> nil then
  begin
    QOneMethodRtti.FResultType := emOneMethodResultType.objListResult;
  end;
  if (QOneMethodRtti.FResultCollectionsValueType = emOneMethodResultType.objResult) and (QOneMethodRtti.FResultType = emOneMethodResultType.listResult) then
  begin
    // TList没办法走进来
    QOneMethodRtti.FErrMsg := '返回List不能为对象只能为常用类型如字符串,数字等,否则序列化出错';
  end;
  Result := true;
end;

function TOneControllerRtti.ResultTypeIsMapCollections(QMapType: TRttiType; QOneMethodRtti: TOneMethodRtti): boolean;
var
  LKeyType, LValType: TRttiType;
  LKeyProp, LValProp: TRttiProperty;
  LAddMethod: TRttiMethod;
begin
  Result := false;
  if not QMapType.Name.Contains('<') then
  begin
    exit;
  end;
  if not QMapType.Name.Contains('>') then
  begin
    exit;
  end;
  LKeyProp := QMapType.GetProperty('Keys');
  if not Assigned(LKeyProp) then
    exit;

  LValProp := QMapType.GetProperty('Values');
  if not Assigned(LValProp) then
    exit;

  LAddMethod := QMapType.GetMethod('Add');
  if not Assigned(LAddMethod) or (Length(LAddMethod.GetParameters) <> 2) then
    exit;
  // 键类型
  LKeyType := LAddMethod.GetParameters[0].ParamType;
  LValType := LAddMethod.GetParameters[1].ParamType;
  case LKeyType.TypeKind of
    tkInteger, tkFloat, tkInt64:
      begin
        QOneMethodRtti.FResultCollectionsKeyType := emOneMethodResultType.numberResult;
      end;
    tkString, tkUString, tkWChar, tkLString, tkWString, tkChar:
      begin
        QOneMethodRtti.FResultCollectionsKeyType := emOneMethodResultType.stringResult;
      end;
    tkClass:
      begin
        QOneMethodRtti.FResultCollectionsKeyType := emOneMethodResultType.objResult;
        // 有可以判断是不是泛型，不做这么多层处理
      end
  end;
  case LValType.TypeKind of
    tkInteger, tkFloat, tkInt64:
      begin
        QOneMethodRtti.FResultCollectionsValueType := emOneMethodResultType.numberResult;
      end;
    tkString, tkUString, tkWChar, tkLString, tkWString, tkChar:
      begin
        QOneMethodRtti.FResultCollectionsValueType := emOneMethodResultType.stringResult;
      end;
    tkClass:
      begin
        QOneMethodRtti.FResultCollectionsValueType := emOneMethodResultType.objResult;
        // 有可以判断是不是泛型，不做这么多层处理
      end
  end;
  //
  QOneMethodRtti.FResultType := emOneMethodResultType.mapResult;
  Result := true;
end;

procedure TOneControllerRtti.GetMethodList(QPersistentClass: TPersistentClass);
var
  lMethodName: string;
  // vRttiType: TRttiType;
  lRttiMethods: TArray<TRttiMethod>;
  vRttiMethod: TRttiMethod;
  lParameters: TArray<TRttiParameter>;
  lParam: TRttiParameter;
  i, iMethod, iParam: integer;
  lOneMethodRtti: TOneMethodRtti;
begin
  FRttiContext := TRttiContext.Create;
  FRttiType := FRttiContext.GetType(QPersistentClass.ClassInfo);
  lRttiMethods := FRttiType.GetMethods;
  for iMethod := 0 to Length(lRttiMethods) - 1 do
  begin
    vRttiMethod := lRttiMethods[iMethod];
    if vRttiMethod = nil then
      continue;
    lMethodName := vRttiMethod.Name.ToLower;
    if not(vRttiMethod.Visibility = mvPublic) then
    begin
      // 非公共方法
      continue;
    end;
    if not(vRttiMethod.MethodKind in [mkProcedure, mkFunction]) then
    begin
      // 非方法函数
      continue;
    end;
    // vRttiMethod.Package.Name
    // 不把父级方法放出来
    if vRttiMethod.Parent.Name <> QPersistentClass.ClassName then
      continue;
    // 获取参数
    lParameters := vRttiMethod.GetParameters;
    lOneMethodRtti := TOneMethodRtti.Create;
    lOneMethodRtti.FErrMsg := '';
    lOneMethodRtti.FHttpMethodType := emOneHttpMethodMode.OneAll;
    lOneMethodRtti.FRttiMethod := vRttiMethod;
    lOneMethodRtti.FHaveClassParam := false;
    lOneMethodRtti.FResultRtti := vRttiMethod.ReturnType;
    lOneMethodRtti.FParamCount := Length(lParameters);
    // 分析方法名称
    // emOneHttpMethodMode =(OneAll,OneGet,OnePost,OneForm, OneFile);
    if lMethodName.StartsWith('oneget') then
    begin
      lOneMethodRtti.FHttpMethodType := emOneHttpMethodMode.OneGet;
    end
    else if lMethodName.StartsWith('onepost') then
    begin
      lOneMethodRtti.FHttpMethodType := emOneHttpMethodMode.OnePost;
    end
    else if lMethodName.StartsWith('onepath') then
    begin
      lOneMethodRtti.FHttpMethodType := emOneHttpMethodMode.OnePath;
    end
    else if lMethodName.StartsWith('oneform') then
    begin
      lOneMethodRtti.FHttpMethodType := emOneHttpMethodMode.OneForm;
    end
    else if lMethodName.StartsWith('oneupload') then
    begin
      // lOneMethodRtti.FHttpMethodType := emOneHttpMethodMode.OneUpload;
    end
    else if lMethodName.StartsWith('onedownload') then
    begin
      lOneMethodRtti.FHttpMethodType := emOneHttpMethodMode.OneDownload;
    end;
    // 分析方法或函数类型
    case vRttiMethod.MethodKind of
      mkProcedure:
        lOneMethodRtti.FMethodType := emOneMethodType.sysProcedure;
      mkFunction:
        lOneMethodRtti.FMethodType := emOneMethodType.sysFunction;
    else
      lOneMethodRtti.FMethodType := emOneMethodType.unknow;
    end;
    // 分析参数
    if Length(lParameters) = 2 then
    begin
      if (vRttiMethod.GetParameters[0].ParamType.Name.ToLower = 'thttpctxt')
        and (vRttiMethod.GetParameters[1].ParamType.Name.ToLower = 'thttpresult') then
      begin
        lOneMethodRtti.FMethodType := emOneMethodType.resultProcedure;
      end;
    end;
    // 判断参数是不是合法类型
    for iParam := Low(lParameters) to High(lParameters) do
    begin
      lOneMethodRtti.FParamClassList.Add(nil);
      lOneMethodRtti.FParamIsArryList.Add(false);
      lParam := lParameters[iParam];
      case lParam.ParamType.TypeKind of
        tkInteger, tkFloat, tkInt64:
          begin
          end;
        tkString, tkUString, tkWChar, tkLString, tkWString, tkChar:
          begin
          end;
        tkClass:
          begin
            lOneMethodRtti.FParamClassList[iParam] := lParam.ParamType.AsInstance.MetaclassType;
            lOneMethodRtti.FHaveClassParam := true;
            // 判断接收的是不是数组参数
            lOneMethodRtti.FParamIsArryList[iParam] := self.IsJsonArr(lParam.ParamType);
          end;
        tkRecord:
          begin
            lOneMethodRtti.FHaveClassParam := true;
          end;
      end;
    end;
    // 分析返回值类型
    if lOneMethodRtti.FResultRtti <> nil then
    begin
      case lOneMethodRtti.FResultRtti.TypeKind of
        tkInteger, tkFloat, tkInt64:
          begin
            lOneMethodRtti.FResultType := emOneMethodResultType.numberResult;
          end;
        tkString, tkUString, tkWChar, tkLString, tkWString, tkChar:
          begin
            lOneMethodRtti.FResultType := emOneMethodResultType.stringResult;
          end;
        tkClass:
          begin
            lOneMethodRtti.FResultType := emOneMethodResultType.objResult;
            // 判断是否是List<T>泛型
            if self.ResultTypeIsGenericsCollections(lOneMethodRtti.FResultRtti, lOneMethodRtti) then
              // 判断是否是List容器
            else if self.ResultTypeIsListCollections(lOneMethodRtti.FResultRtti, lOneMethodRtti) then
              // 判断是不是字典容器
            else if self.ResultTypeIsMapCollections(lOneMethodRtti.FResultRtti, lOneMethodRtti) then
            else
            begin
            end;
          end;
      else
        begin
          lOneMethodRtti.FResultType := emOneMethodResultType.unknowResult;
        end;
      end;

    end;

    if not FMethodList.ContainsKey(lMethodName) then
    begin
      lOneMethodRtti.FMethodName := lMethodName;
      { 增加RTTI方法,参数,返回值,自定义属性 }
      FMethodList.Add(lMethodName, lOneMethodRtti);
    end
    else
    begin
      // 释放
      lOneMethodRtti.Free;
    end;
  end;
end;

end.

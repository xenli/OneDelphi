unit OneRttiHelper;

interface

uses system.Generics.Collections, system.Rtti, system.Classes, system.StrUtils,
  system.SysUtils, system.TypInfo, system.Contnrs;

type
  emResultType = (unknowResult, numberResult, stringResult, boolResult,
    objResult, listResult, objListResult, genericsListResult,
    genericsObjListResult, mapResult, arrayResult, recordResult);

  // QFreeListItem是否要主动释放 items里面的对象
function FreeTValue(QTValue: TValue; QFreeListItem: boolean = true): boolean;
function IsGenericsCollections(qListType: TRttiType;
  var QResultType: emResultType; var QItemResultType: emResultType): boolean;
function IsListCollections(qListType: TRttiType; var QResultType: emResultType;
  var QItemResultType: emResultType): boolean;
function IsMapCollections(QMapType: TRttiType; Var QResultType: emResultType;
  var QKeyResultType: emResultType; var QValueResultType: emResultType)
  : boolean;

implementation

function FreeTValue(QTValue: TValue; QFreeListItem: boolean = true): boolean;
var
  lObj: TObject;
  lRttiContext: TRttiContext;
  lRttiType: TRttiType;
  lResultType, lItemResultType, lKeyResult, lValueResult: emResultType;
  i: Integer;
  lListT: TList<TObject>;
  lObjListT: TObjectList<TObject>;
  lList: TList;
  lObjList: TObjectList;
begin
  Result := false;
  if not QTValue.IsObject then
  begin
    Result := true;
    exit;
  end;
  lObj := QTValue.AsObject;
  if lObj = nil then
    exit;
  lRttiContext := TRttiContext.Create;
  try
    lRttiType := lRttiContext.GetType(lObj.ClassInfo);
    if IsGenericsCollections(lRttiType, lResultType, lItemResultType) then
    begin
      //
      if lResultType = emResultType.genericsListResult then
      begin
        if (lItemResultType = emResultType.objResult) then
        begin
          lListT := TList<TObject>(lObj);
          if QFreeListItem then
          begin

            for i := 0 to lListT.Count - 1 do
            begin
              if lListT[i] <> nil then
                lListT[i].Free;
            end;
          end;
          lListT.Clear;
          lListT.Free;
        end
        else
        begin
          lObj.Free;
        end;
      end
      else if lResultType = emResultType.genericsObjListResult then
      begin
        lObjListT := TObjectList<TObject>(lObj);
        if not lObjListT.OwnsObjects then
        begin
          if QFreeListItem then
          begin
            for i := 0 to lObjListT.Count - 1 do
            begin
              if lObjListT[i] <> nil then
                lObjListT[i].Free;
            end;
          end
        end;
        lObjListT.Clear;
        lObjListT.Free;
      end;

    end
    else if IsListCollections(lRttiType, lResultType, lItemResultType) then
    begin
      if lResultType = emResultType.listResult then
      begin
        lList := TList(lObj);
        // 里面是不是对象要遍历判断，这边不处理
        // 主要放 string,int 这些常用类型
        // 自已释放
        if QFreeListItem then
        begin
          for i := 0 to lList.Count - 1 do
          begin
            if TObject(lList[i]) <> nil then
              TObject(lList[i]).Free;
          end;
        end;
        lList.Clear;
        lList.Free;
      end
      else if lResultType = emResultType.objListResult then
      begin
        lObjList := TObjectList(lObj);
        if not lObjList.OwnsObjects then
        begin
          if QFreeListItem then
          begin
            for i := 0 to lObjList.Count - 1 do
            begin
              if lObjList[i] <> nil then
                lObjList[i].Free;
            end;
          end;

        end;
        lObjList.Clear;
        lObjList.Free;
      end;
    end
    else if IsMapCollections(lRttiType, lResultType, lKeyResult, lValueResult)
    then
    begin
      lObj.Free;
    end
    else
    begin
      lObj.Free;
    end;
  finally

  end;
end;

function IsGenericsCollections(qListType: TRttiType;
  var QResultType: emResultType; var QItemResultType: emResultType): boolean;
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
  if not Assigned(LMethodGetEnumerator) or
    (LMethodGetEnumerator.MethodKind <> mkFunction) or
    (LMethodGetEnumerator.ReturnType.Handle.Kind <> tkClass) then
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
        QItemResultType := emResultType.numberResult;
      end;
    tkString, tkUString, tkWChar, tkLString, tkWString, tkChar:
      begin
        QItemResultType := emResultType.stringResult;
      end;
    tkClass:
      begin
        QItemResultType := emResultType.objResult;
      end
  end;

  //
  QResultType := emResultType.genericsListResult;
  // 是否是obj容器
  if qListType.GetProperty('OwnsObjects') <> nil then
  begin
    QResultType := emResultType.genericsObjListResult;
  end;
  Result := true;
end;

function IsListCollections(qListType: TRttiType; var QResultType: emResultType;
  var QItemResultType: emResultType): boolean;
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
  if not Assigned(LMethodGetEnumerator) or
    (LMethodGetEnumerator.MethodKind <> mkFunction) or
    (LMethodGetEnumerator.ReturnType.Handle.Kind <> tkClass) then
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
        QItemResultType := emResultType.numberResult;
      end;
    tkString, tkUString, tkWChar, tkLString, tkWString, tkChar:
      begin
        QItemResultType := emResultType.stringResult;
      end;
    tkClass:
      begin
        QItemResultType := emResultType.objResult;
      end
  end;

  //
  QResultType := emResultType.listResult;
  // 是否是obj容器
  if qListType.GetProperty('OwnsObjects') <> nil then
  begin
    QResultType := emResultType.objListResult;
  end;
  Result := true;
end;

function IsMapCollections(QMapType: TRttiType; Var QResultType: emResultType;
  var QKeyResultType: emResultType; var QValueResultType: emResultType)
  : boolean;
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
        QKeyResultType := emResultType.numberResult;
      end;
    tkString, tkUString, tkWChar, tkLString, tkWString, tkChar:
      begin
        QKeyResultType := emResultType.stringResult;
      end;
    tkClass:
      begin
        QKeyResultType := emResultType.objResult;
      end
  end;
  case LValType.TypeKind of
    tkInteger, tkFloat, tkInt64:
      begin
        QValueResultType := emResultType.numberResult;
      end;
    tkString, tkUString, tkWChar, tkLString, tkWString, tkChar:
      begin
        QValueResultType := emResultType.stringResult;
      end;
    tkClass:
      begin
        QValueResultType := emResultType.objResult;
      end
  end;
  QResultType := emResultType.mapResult;
  Result := true;
end;

end.

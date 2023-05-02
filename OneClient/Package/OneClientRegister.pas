unit OneClientRegister;

interface

uses DesignIntf, DesignEditors, System.Classes, FireDAC.Stan.Param;

// type
// TOneParamsProperty = class(TComponentProperty)
// public
// procedure Edit; override;
// end;
//
// type
// TOneParamsEditor = class(TComponentEditor{$IFDEF LINUX},
// IDesignerThreadAffinity{$ENDIF})
// public
// procedure ExecuteVerb(Index: Integer); override;
// end;
type
  TOneUnitSelector = class(TSelectionEditor)
  public
    procedure RequiresUnits(Proc: TGetStrProc); override; // 覆盖此方法来添加所需的单元
  end;

procedure Register;

implementation

uses
  OneClientConnect, OneClientDataSet, OneClientVirtualFile, OneClientUUID, OneClientFastLsh,
  OneClientFastUpdate, OneClientFastFile, OneWebSocketClient;

procedure TOneUnitSelector.RequiresUnits(Proc: TGetStrProc);
begin
  Proc('OneClientHelper');
end;
// procedure TOneParamsProperty.Edit;
// begin
/// /  ShowCollectionEditorClass(Designer, TCollectionEditor,
/// /    TOnePersistent(GetComponent(0)).GetOwner as TComponent,
/// /    TCollection(GetOrdValue), GetName);
// end;
//
// procedure TOneParamsEditor.ExecuteVerb(Index: Integer);
// begin
// // ShowCollectionEditorClass(Designer, TCollectionEditor, Component,
// // (Component as TOneDataSet).Params, 'Params');
// end;

procedure Register;
begin
  RegisterComponents('OneClient', [TOneConnection, TOneDataSet, TOneVirtualFile,
    TOneUUID, TOneWebSocketClient]);
  RegisterComponents('OneClientFast', [TOneFastLsh, TOneFastUpdate, TOneFastFile]);
  RegisterSelectionEditor(TOneConnection, TOneUnitSelector);
  RegisterSelectionEditor(TOneDataSet, TOneUnitSelector);
  // RegisterPropertyEditor(TypeInfo(TFDParams), TOneDataInfo, 'Params',
  // TOneParamsProperty);
  // RegisterComponentEditor(TOneDataSet, TOneParamsEditor);
end;

end.

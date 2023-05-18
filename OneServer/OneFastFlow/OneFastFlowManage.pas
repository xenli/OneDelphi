unit OneFastFlowManage;

interface

uses system.Generics.Collections, system.StrUtils, system.Classes, system.SysUtils;

type
  TFastFlow = class;
  TFlowStep = class;
  TFlowAuthor = class;

  TFastFlow = class
  private
    FFlowID_: string;
    FFlowCode_: string;
    FFlowCaption_: string;
    FFlowChart_: string;
    FFlowMode_: string;
    FStepSaveTable_: string;
    FStepHisTable_: string;
    FCreateTime_: TDateTime;
    FIsEnabled_: boolean;
    FRemark_: string;
  published
    property FFlowID: string read FFlowID_ write FFlowID_;
    property FFlowCode: string read FFlowCode_ write FFlowCode_;
    property FFlowCaption: string read FFlowCaption_ write FFlowCaption_;
    property FFlowChart: string read FFlowChart_ write FFlowChart_;
    property FFlowMode: string read FFlowMode_ write FFlowMode_;
    property FStepSaveTable: string read FStepSaveTable_ write FStepSaveTable_;
    property FStepHisTable: string read FStepHisTable_ write FStepHisTable_;
    property FCreateTime: TDateTime read FCreateTime_ write FCreateTime_;
    property FIsEnabled: boolean read FIsEnabled_ write FIsEnabled_;
    property FRemark: string read FRemark_ write FRemark_;
  end;

  TFlowStep = class
  private
    FStepID_: string;
    FFlowID_: string;
    FOrderNumber_: integer;
    FStepCaption_: string;
    FIsMustStep_: boolean;
    FConfirmMode_: string;
    FConfirmStep_: string;
    FCancleMode_: string;
    FCancleStep_: string;
    FControlEnabled_: string;
    FChildAuthors_: TList<TFlowAuthor>;
  public
    constructor Create;
    destructor Destroy; override;
  published
    property FStepID: string read FStepID_ write FStepID_;
    property FFlowID: string read FFlowID_ write FFlowID_;
    property FOrderNumber: integer read FOrderNumber_ write FOrderNumber_;
    property FStepCaption: string read FStepCaption_ write FStepCaption_;
    property FIsMustStep: boolean read FIsMustStep_ write FIsMustStep_;
    property FConfirmMode: string read FConfirmMode_ write FConfirmMode_;
    property FConfirmStep: string read FConfirmStep_ write FConfirmStep_;
    property FCancleMode: string read FCancleMode_ write FCancleMode_;
    property FCancleStep: string read FCancleStep_ write FCancleStep_;
    property FControlEnabled: string read FControlEnabled_ write FControlEnabled_;
    property ChildAuthors: TList<TFlowAuthor> read FChildAuthors_ write FChildAuthors_;
  end;

  TFlowAuthor = class
  private
    FAuthorID_: string;
    FFlowID_: string;
    FStepID_: string;
    FOrderNumber_: integer;
    FAuthorMode_: string;
    FAuthorName_: string;
    FIsConfirm_: boolean;
    FIsCancle_: boolean;
    FIsEnabled_: boolean;
  published
    property FAuthorID: string read FAuthorID_ write FAuthorID_;
    property FFlowID: string read FFlowID_ write FFlowID_;
    property FStepID: string read FStepID_ write FStepID_;
    property FOrderNumber: integer read FOrderNumber_ write FOrderNumber_;
    property FAuthorMode: string read FAuthorMode_ write FAuthorMode_;
    property FAuthorName: string read FAuthorName_ write FAuthorName_;
    property FIsConfirm: boolean read FIsConfirm_ write FIsConfirm_;
    property FIsCancle: boolean read FIsCancle_ write FIsCancle_;
    property FIsEnabled: boolean read FIsEnabled_ write FIsEnabled_;
  end;

  TFlowInfo = class
  private
    flow_: TFastFlow;
    steps_: TList<TFlowStep>;
  public
    constructor Create;
    destructor Destroy; override;
  public
    property Flow: TFastFlow read flow_ write flow_;
    property FlowSteps: TList<TFlowStep> read steps_ write steps_;
  end;

  TFastFlowManage = class
  private
    FZTCode: string;
    FFlowInfos: TDictionary<string, TFlowInfo>;
  public
    constructor Create;
    destructor Destroy; override;
    // 批量获取流水号
    function RefreshFlowManage(Var QErrMsg: string): boolean;
    function GetFlowInfo(QFlowCode: string; Var QErrMsg: string): TFlowInfo;
  public
    property ZTCode: string read FZTCode write FZTCode;
  end;

function UnitFastFlowManage(): TFastFlowManage;

implementation

uses OneOrm, OneGUID;

var
  Unit_FlowManage: TFastFlowManage = nil;

constructor TFlowStep.Create;
begin
  self.FChildAuthors_ := TList<TFlowAuthor>.Create;
end;

destructor TFlowStep.Destroy;
var
  i: integer;
begin
  for i := 0 to self.FChildAuthors_.Count - 1 do
  begin
    self.FChildAuthors_[i].Free;
  end;
  self.FChildAuthors_.Clear;
  self.FChildAuthors_.Free;
  inherited Destroy;
end;

constructor TFlowInfo.Create;
begin
  self.flow_ := nil;
  self.steps_ := TList<TFlowStep>.Create;
end;

destructor TFlowInfo.Destroy;
var
  i: integer;
begin
  if self.flow_ <> nil then
    self.flow_.Free;
  for i := 0 to self.steps_.Count - 1 do
  begin
    self.steps_[i].Free;
  end;
  self.steps_.Clear;
  self.steps_.Free;
  inherited Destroy;
end;

function UnitFastFlowManage(): TFastFlowManage;
var
  lErrMsg: string;
begin
  if Unit_FlowManage = nil then
  begin
    Unit_FlowManage := TFastFlowManage.Create;
    Unit_FlowManage.RefreshFlowManage(lErrMsg);
  end;
  Result := Unit_FlowManage;
end;

constructor TFastFlowManage.Create;
begin
  FFlowInfos := TDictionary<string, TFlowInfo>.Create;
end;

destructor TFastFlowManage.Destroy;
var
  lFlowInfo: TFlowInfo;
begin
  for lFlowInfo in FFlowInfos.Values do
  begin
    lFlowInfo.Free;
  end;
  inherited;
end;

function TFastFlowManage.GetFlowInfo(QFlowCode: string; Var QErrMsg: string): TFlowInfo;
begin
  Result := nil;
  QErrMsg := '';
  if not self.FFlowInfos.TryGetValue(QFlowCode, Result) then
  begin
    QErrMsg := '流程代码[' + QFlowCode + ']不存在,请注意大小写';
    exit;
  end;
  if not Result.Flow.FIsEnabled then
  begin
    QErrMsg := '流程代码[' + QFlowCode + ']未启用';
    Result := nil;
    exit;
  end;
end;

function TFastFlowManage.RefreshFlowManage(Var QErrMsg: string): boolean;
var
  lOrmFlow: IOneOrm<TFastFlow>;
  lOrmStep: IOneOrm<TFlowStep>;
  lOrmAuthor: IOneOrm<TFlowAuthor>;
  lFlowList: TList<TFastFlow>;
  lFlowSteps: TList<TFlowStep>;
  lFlowAuthors: TList<TFlowAuthor>;
  lFlowInfo: TFlowInfo;
  lFlow: TFastFlow;
  lStep: TFlowStep;
  lAuthor: TFlowAuthor;
  //
  iFlow, iStep, iAuthor: integer;
  lIntStepList, lIntAuthorList: TList<integer>;
  i: integer;
begin
  Result := false;
  QErrMsg := '';
  lFlowList := nil;
  lFlowSteps := nil;
  lFlowAuthors := nil;
  lIntStepList := TList<integer>.Create;
  lIntAuthorList := TList<integer>.Create;
  try
    for lFlowInfo in self.FFlowInfos.Values do
    begin
      lFlowInfo.Free;
    end;
    self.FFlowInfos.Clear;

    lOrmFlow := TOneOrm<TFastFlow>.Start();
    lFlowList := lOrmFlow.ZTCode(self.FZTCode)
      .Query('select * from onefast_flow', []).ToList();
    if lOrmFlow.IsErr then
    begin
      QErrMsg := lOrmFlow.ErrMsg;
      exit;
    end;

    if lFlowList.Count = 0 then
      exit;
    lOrmStep := TOneOrm<TFlowStep>.Start();
    lFlowSteps := lOrmStep.ZTCode(self.FZTCode)
      .Query('select * from onefast_step order by FFlowID asc,FOrderNumber asc ', []).ToList();
    if lOrmStep.IsErr then
    begin
      QErrMsg := lOrmStep.ErrMsg;
      exit;
    end;
    lOrmAuthor := TOneOrm<TFlowAuthor>.Start();
    lFlowAuthors := lOrmAuthor.ZTCode(self.FZTCode)
      .Query('select * from onefast_author order by FStepID asc,FOrderNumber asc ', []).ToList();
    if lOrmAuthor.IsErr then
    begin
      QErrMsg := lOrmAuthor.ErrMsg;
      exit;
    end;

    for iFlow := 0 to lFlowList.Count - 1 do
    begin
      lFlow := lFlowList[iFlow];
      if lFlow.FFlowCode.trim = '' then
      begin
        continue;
      end;
      if self.FFlowInfos.ContainsKey(lFlow.FFlowCode) then
      begin
        continue;
      end;
      //
      lFlowInfo := TFlowInfo.Create;
      lFlowInfo.flow_ := lFlow;

      lIntStepList.Clear;
      for iStep := 0 to lFlowSteps.Count - 1 do
      begin
        lStep := lFlowSteps[iStep];
        if lStep.FFlowID <> lFlow.FFlowID then
        begin
          continue;
        end;
        lFlowInfo.FlowSteps.Add(lStep);
        lIntStepList.Add(iStep);
        //
        lIntAuthorList.Clear;
        for iAuthor := 0 to lFlowAuthors.Count - 1 do
        begin
          lAuthor := lFlowAuthors[iAuthor];
          if lAuthor.FStepID <> lStep.FStepID then
          begin
            continue;
          end;
          lStep.ChildAuthors.Add(lAuthor);
          lIntAuthorList.Add(iAuthor);
        end;
        for iAuthor := lIntAuthorList.Count - 1 downto 0 do
        begin
          lFlowAuthors.Delete(lIntAuthorList[iAuthor]);
        end;
      end;
      for iStep := lIntStepList.Count - 1 downto 0 do
      begin
        lFlowSteps.Delete(lIntStepList[iStep]);
      end;
      self.FFlowInfos.Add(lFlow.FFlowCode, lFlowInfo);
    end;
  finally
    lIntStepList.Clear;
    lIntStepList.Free;
    lIntAuthorList.Clear;
    lIntAuthorList.Free;
    if lFlowList <> nil then
    begin
      for i := 0 to lFlowList.Count - 1 do
      begin
        lFlowList[i].Free;
      end;
      lFlowList.Clear;
      lFlowList.Free;
    end;
    if lFlowSteps <> nil then
    begin
      for i := 0 to lFlowSteps.Count - 1 do
      begin
        lFlowSteps[i].Free;
      end;
      lFlowSteps.Clear;
      lFlowSteps.Free;
    end;
    if lFlowAuthors <> nil then
    begin
      for i := 0 to lFlowAuthors.Count - 1 do
      begin
        lFlowAuthors[i].Free;
      end;
      lFlowAuthors.Clear;
      lFlowAuthors.Free;
    end;
  end;
end;

initialization

finalization

if Unit_FlowManage <> nil then
  Unit_FlowManage.Free;

end.

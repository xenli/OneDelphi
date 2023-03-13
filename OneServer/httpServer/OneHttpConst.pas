unit OneHttpConst;

interface

uses system.StrUtils, system.SysUtils;

const
  HTTP_Status_TokenFail = 498;
  HTTP_ResultCode_True = '0001';
  HTTP_ResultCode_Fail = '0002';
  HTTP_ResultCode_TokenFail = 'TokenFail';
  HTTP_ResultCode_TokenSignFail = 'TokenSignFail';
  HTTP_URL_TokenName = 'token';
  HTTP_URL_TokenTime = 'time';
  HTTP_URL_TokenSign = 'sign';

type
  emRowState = (unknowState, selectState, editState, insertState, delState);

  TOneOrmRowState = class
  private
    FRowState_sys: emRowState;
  public
    function GetRowState(): emRowState;
    procedure SetRowState(QRowState: emRowState); overload;
    procedure SetRowState(QID: string); overload;
  end;

implementation

function TOneOrmRowState.GetRowState(): emRowState;
begin
  result := FRowState_sys;
end;

procedure TOneOrmRowState.SetRowState(QRowState: emRowState);
begin
  FRowState_sys := QRowState;
end;

procedure TOneOrmRowState.SetRowState(QID: string);
begin
  FRowState_sys := emRowState.unknowState;
  QID := Trim(QID);
  if (QID = '-1') or (QID = '') then
  begin
    FRowState_sys := emRowState.insertState;
  end
  else
  begin
    FRowState_sys := emRowState.editState;
  end;
end;

end.

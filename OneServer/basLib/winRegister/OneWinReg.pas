unit OneWinReg;

// win特有单元
interface

uses
  system.Sysutils, system.classes, Variants
{$IFDEF MSWINDOWS}, Winapi.Windows, system.Win.Registry, Winapi.ShellAPI{$ENDIF};

function SetRegStr(SubKey: string; ValueKey: string; Value: string): wordbool;
function GetRegStr(SubKey: string; ValueKey: string; var ResultValue: string; CreateBool: wordbool): wordbool;
function DelRegStr(SubKey: string; ValueKey: string): wordbool;
//
procedure WinTaskStart(QTaskName, QFileName: string; QIsAdd: Boolean);
procedure WinAutoStart(QkeyName, QFileName: string; QIsAdd: Boolean);

implementation

procedure WinTaskStart(QTaskName, QFileName: string; QIsAdd: Boolean);
const
  STasksDelete = '/delete /f /tn "%s"';
  STasksCreate = '/create /tn "%s" /tr "%s" /sc ONSTART /ru "System"';
begin
{$IFDEF MSWINDOWS}
  ShellExecute(0, nil, 'schtasks', PChar(Format(STasksDelete, [QTaskName])), nil, SW_HIDE);
  if QIsAdd then
    ShellExecute(0, nil, 'schtasks', PChar(Format(STasksCreate, [QTaskName, QFileName])), nil, SW_HIDE);
{$ENDIF}
end;

procedure WinAutoStart(QkeyName, QFileName: string; QIsAdd: Boolean);
begin
{$IFDEF MSWINDOWS}
  if QIsAdd then
    SetRegStr('SOFTWARE\Microsoft\Windows\CurrentVersion\Run', QkeyName, QFileName)
  else
    DelRegStr('SOFTWARE\Microsoft\Windows\CurrentVersion\Run', QkeyName);
{$ENDIF}
end;

function SetRegStr(SubKey: string; ValueKey: string; Value: string): wordbool;
// SubKey   ：要操作的根键
// ValueKey ：要操作的主键  如果为空则默认为写入键值到SubKey根键的默认主键
// Value    ：要写入的键值
var
  RegF: Tregistry; // 定义变量RegF
begin
  Result := false;
  SubKey := trim(SubKey);
  ValueKey := trim(ValueKey);
  RegF := Tregistry.Create; // 创建变量
  RegF.RootKey := HKEY_CURRENT_USER; // 指定要操作的根键
  try
    try
      if RegF.Openkey(SubKey, true) then
      begin
        RegF.WriteString(ValueKey, Value);
        Result := true;
      end;
    except

    end;
  finally
    RegF.CloseKey;
    FreeAndNil(RegF);
  end;
end;

// 读注册表信息，初始化登陆窗口
function GetRegStr(SubKey: string; ValueKey: string; var ResultValue: string;
  CreateBool: wordbool): wordbool;
// SubKey         ：要操作的根键
// ValueKey       ：要操作的主键  如果为空则默认为读出SubKey根键的默认键值
// ResultValue    ：要读出的键值
// CreateBool     ：如果没有找z到相应的主键确认是否要创建。
var
  RegF: Tregistry; // 定义变量RegF
begin
  Result := false;
  SubKey := trim(SubKey);
  ValueKey := trim(ValueKey);
  RegF := Tregistry.Create; // 创建变量
  RegF.RootKey := HKEY_CURRENT_USER; // 指定要操作的根键
  try
    Result := RegF.Openkey(SubKey, CreateBool);
    ResultValue := RegF.ReadString(ValueKey);
    Result := true;
  finally
    RegF.CloseKey;
    FreeAndNil(RegF);
  end;
end;

function DelRegStr(SubKey: string; ValueKey: string): wordbool;
var
  RegF: Tregistry; // 定义变量RegF
begin
  Result := false;
  SubKey := trim(SubKey);
  ValueKey := trim(ValueKey);
  RegF := Tregistry.Create; // 创建变量
  RegF.RootKey := HKEY_CURRENT_USER; // 指定要操作的根键
  try
    try
      if RegF.Openkey(SubKey, true) then
      begin
        RegF.DeleteValue(ValueKey);
        Result := true;
      end;
    except

    end;
  finally
    RegF.CloseKey;
    FreeAndNil(RegF);
  end;
end;

end.

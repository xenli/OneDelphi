unit OneFunc;

interface

uses System.SysUtils, System.StrUtils;
function GetGUID32(): string;

implementation

function GetGUID32(): string;
var
  ii: TGUID;
begin
  CreateGUID(ii);
  Result := Copy(AnsiReplaceStr(GUIDToString(ii), '-', ''), 2, 32);
end;

end.

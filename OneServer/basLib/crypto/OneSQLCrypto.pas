unit OneSQLCrypto;

interface

uses System.SysUtils, System.Classes, System.NetEncoding, EncdDecd;
// 交换打乱加密
function SwapCrypto(QStr: string): string;
// 交换打乱解密
function SwapDecodeCrypto(QStr: string): string;
// 判断是不是base64字符串
function IsBase64Str(QStr: string): Boolean;

implementation

function IsBase64Str(QStr: string): Boolean;
// 每隔76个字符，就强制回车换行
const
  Base64Chars: Set of AnsiChar = ['A' .. 'Z', 'a' .. 'z', '0' .. '9', '+', '/',
    '=', #10, #13];
var
  i: integer;
begin
  Result := true;
  for i := Low('') to High(QStr) do
  begin
    if not(QStr[i] in Base64Chars) then
    begin
      Result := false;
      Break;
    end;
  end;
end;

function SwapCrypto(QStr: string): string;
var
  iLen, iMid: integer;
  iHQ, iHM: integer;
  iA: integer;
  iAStart, iBStart: integer;
  tempStr: String;
  iLow: integer;
  iStepMod: integer;
  lBase64Encoding: TBase64Encoding;
begin
  lBase64Encoding := TBase64Encoding.Create(-1);
  try
    QStr := lBase64Encoding.Encode(QStr);
    Result := QStr;
    iLen := Length(QStr);
    if iLen <= 1 then
      exit;
    iHQ := High(QStr);
    iHM := trunc(iLen / 2);
    iLow := Low('');
    iStepMod := 0;
    if iLow = 0 then
    begin
      iStepMod := 1;
    end;
    iAStart := iLow + iStepMod;
    iBStart := 0;
    iHM := iHM - iStepMod;
    // 不要用0 to ...因为要支持跨平台，不同平标下标不一样
    for iA := iLow to iHM do
    begin
      tempStr := QStr[iA];
      // 近远交替
      if ((iA + iStepMod) mod 2 = 1) then
      begin
        QStr[iA] := QStr[iHM + iAStart];
        QStr[iHM + iAStart] := tempStr[iLow];
        iAStart := iAStart + 1;
      end
      else
      begin
        QStr[iA] := QStr[iHQ - iBStart];
        QStr[iHQ - iBStart] := tempStr[iLow];
        iBStart := iBStart + 1;
      end;
    end;
    Result := QStr;
  finally
    lBase64Encoding.Free;
  end;
end;

function SwapDecodeCrypto(QStr: string): string;
var
  iLen, iMid: integer;
  iHQ, iHM: integer;
  iA: integer;
  iAStart, iBStart: integer;
  tempStr: String;
  iLow: integer;
begin
  Result := QStr;
  // 判断是不是Base64加过密的,兼容早前无加密的客户端
  if not(IsBase64Str(QStr)) then
  begin
    exit;
  end;
  iLen := Length(QStr);
  if iLen <= 1 then
    exit;
  iHQ := High(QStr);
  iHM := trunc(iLen / 2);
  iLow := Low('');
  iAStart := iLow;
  iBStart := 0;
  // 不要用0 to ...因为要支持跨平台，不同平标下标不一样
  for iA := iLow to iHM do
  begin
    tempStr := QStr[iA];
    // 近远交替
    if (iA mod 2 = 1) then
    begin
      QStr[iA] := QStr[iHM + iAStart];
      QStr[iHM + iAStart] := tempStr[iLow];
      iAStart := iAStart + 1;
    end
    else
    begin
      QStr[iA] := QStr[iHQ - iBStart];
      QStr[iHQ - iBStart] := tempStr[iLow];
      iBStart := iBStart + 1;
    end;
  end;
  Result := DecodeString(QStr);
end;

end.

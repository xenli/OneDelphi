unit ssl_conver;

interface

uses system.SysUtils, system.Classes,System.NetEncoding;
//二进制转16进制字符串
function BinToHexStr(QInBytes: TBytes): string;
function BinToHexStr2(QInBytes: TBytes): string;
//16进制字符串转Bytes
function HexStrToBin(QHexStr:string):TBytes;
//二进制转base64
function BinToBase64Str(QInBytes: TBytes):string;
//BASE64转bytes
function Base64StrToBin(QBase64Str:string):TBytes;
implementation

function BinToHexStr(QInBytes: TBytes): string;
var
  i, iLen: integer;
  tempStr: string;
begin
  iLen := Length(QInBytes);
  tempStr := '';
  for i := 0 to iLen - 1 do
  begin
    tempStr := tempStr + IntToHex(QInBytes[i], 2);
  end;
  result := tempStr;
end;

function BinToHexStr2(QInBytes: TBytes): string;
var
  i, iLen: integer;
  tempStr: string;
begin
  iLen := Length(QInBytes);
  tempStr := '';
  if iLen = 0 then
  begin
    result := tempStr;
    exit;
  end;
  setLength(tempStr, iLen * 2);
  BinToHex(@QInBytes[0], PWideChar(tempStr), iLen);
  result := tempStr;
end;

function HexStrToBin(QHexStr:string):TBytes;
var lOutBytes:TBytes;
 iLen:integer;
begin
  iLen := Length(QHexStr);
  //预设长度
  setLength(lOutBytes,iLen);
  //返回实际长度
  if iLen>0  then
  begin
    iLen := HexToBin(PWideChar(QHexStr), @lOutBytes[0], iLen);
  end;
  //栽剪长度
  setLength(lOutBytes,iLen);
  Result := lOutBytes;
end;

function BinToBase64Str(QInBytes: TBytes):string;
var lEncoding:TBase64Encoding;
begin
  lEncoding := TBase64Encoding.Create(0);
  try
    Result := lEncoding.EncodeBytesToString(QInBytes);
  finally
    lEncoding.Free;
  end;
end;
function Base64StrToBin(QBase64Str:string):TBytes;
begin
  Result := TNetEncoding.Base64.DecodeStringToBytes(QBase64Str);
end;

end.

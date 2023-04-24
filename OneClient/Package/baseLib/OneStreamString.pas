unit OneStreamString;

interface

uses System.Classes, System.NetEncoding, System.SysUtils;
// 流转base64字符串
function StreamToBase64Str(aStream: TStream): string;
// 流写入base64字符串
function StreamWriteBase64Str(aStream: TStream; QRawByteString: string): Boolean;

// basd64字符串转成流
function Base64ToStream(QRawByteString: string): TStream;
// 字符串转base64
function StringToBase64(QRawByteString: string): string;
// 字节转base64
function BytesToBase64(QBytes: TBytes): string;
// 流转字节
function StreamToBytes(aStream: TStream): TBytes;
// 流写入字节
function StreamWriteBytes(aStream: TStream; QDataBytes: TBytes): Boolean;
// 流转字符串
function StreamToString(var QResult: RawByteString; aStream: TStream)
  : Boolean; overload;
// 流转字行串
function StreamToString(aStream: TStream): String; overload;
// 流写入字符串
function StreamToWriteString(QData: RawByteString; aStream: TStream): Boolean;
function StreamGetFileType(aStream: TStream): String;
function iLow: Integer;

implementation

function iLow: Integer;
begin
  Result := Low('');
end;

function StreamToBase64Str(aStream: TStream): string;
var
  LDataBytes: TBytes;
begin
  Result := '';
  aStream.Position := 0;
  SetLength(LDataBytes, aStream.Size);
  try
    aStream.Read(LDataBytes, 0, aStream.Size);
    Result := TNetEncoding.Base64.EncodeBytesToString(LDataBytes);
  finally
    LDataBytes := nil;
  end;
end;

function StreamWriteBase64Str(aStream: TStream; QRawByteString: string): Boolean;
var
  vDataBytes: TBytes;
  iSize: Integer;
begin
  Result := false;
  vDataBytes := TNetEncoding.Base64.DecodeStringToBytes(QRawByteString);
  iSize := Length(vDataBytes);
  aStream.Position := 0;
  aStream.Write(vDataBytes, 0, iSize);
  aStream.Position := 0;
  Result := true;
end;

function Base64ToStream(QRawByteString: string): TStream;
var
  LDataBytes: TBytes;
  iSize: Integer;
begin
  Result := TMemoryStream.Create;
  LDataBytes := TNetEncoding.Base64.DecodeStringToBytes(QRawByteString);
  iSize := Length(LDataBytes);
  Result.Position := 0;
  Result.Write(LDataBytes[0], iSize);
  Result.Position := 0;
end;

function StringToBase64(QRawByteString: string): string;
var
  lStream: TMemoryStream;
begin
  lStream := TMemoryStream.Create;
  try
    StreamToWriteString(QRawByteString, lStream);
    Result := StreamToBase64Str(lStream);
  finally
    lStream.Free;
  end;
end;

function BytesToBase64(QBytes: TBytes): string;
begin
  Result := TNetEncoding.Base64.EncodeBytesToString(QBytes);
end;

function StreamToBytes(aStream: TStream): TBytes;
begin
  aStream.Position := 0;
  SetLength(Result, aStream.Size);
  aStream.Read(Result[0], aStream.Size);
end;

function StreamWriteBytes(aStream: TStream; QDataBytes: TBytes): Boolean;
var
  iSize: Integer;
begin
  Result := false;
  iSize := Length(QDataBytes);
  aStream.Position := 0;
  aStream.Write(QDataBytes[0], iSize);
  aStream.Position := 0;
  Result := true;
end;

function StreamToString(var QResult: RawByteString; aStream: TStream): Boolean;
begin
  Result := false;
  aStream.Position := 0;
  SetLength(QResult, aStream.Size);
  aStream.Read(QResult[iLow], aStream.Size);
  Result := true;
end;

function StreamToString(aStream: TStream): String;
begin
  Result := '';
  aStream.Position := 0;
  SetLength(Result, aStream.Size);
  aStream.Read(Result[iLow], aStream.Size);
end;

function StreamToWriteString(QData: RawByteString; aStream: TStream): Boolean;
var
  iSize: Integer;
begin
  Result := false;
  iSize := Length(QData);
  if iSize > 0 then
  begin
    aStream.Position := 0;
    aStream.Write(QData[iLow], iSize);
    aStream.Position := 0;
    Result := true;
  end;
end;

function StreamGetFileType(aStream: TStream): String;
var
  Buffer: Word;
begin
  Result := '';
  aStream.Position := 0;
  if aStream.Size = 0 then
    exit;
  aStream.ReadBuffer(Buffer, 2);
  case Buffer of
    $4D42:
      Result := 'bmp';
    $D8FF:
      Result := 'jpeg';
    $4947:
      Result := 'gifp';
    $050A:
      Result := 'pcx';
    $5089:
      Result := 'png';
    $4238:
      Result := 'psd';
    $A659:
      Result := 'ras';
    $DA01:
      Result := 'sgi';
    $4949:
      Result := 'tiff';
  end;
end;

end.

unit OneCrypto;

interface

uses System.Hash, System.Types, System.StrUtils, System.SysUtils,
  System.Classes;

function MD5Endcode(QStr: string): string; overload;
function MD5Endcode(QStr: string; QbUpperCase: Boolean): string; overload;
// 如果不是utf-8需要用codepage转码后在来
function MD5Endcode(QStr: string; QCodePage: Integer): String; overload;
//
function GetFileHashMD5(FileName: WideString): String;
function GetStrHashSHA1(Str: String): String;
function GetStrHashSHA224(Str: String): String;
function GetStrHashSHA256(Str: String): String;
function GetStrHashSHA384(Str: String): String;
function GetStrHashSHA512(Str: String): String;
function GetStrHashSHA512_224(Str: String): String;
function GetStrHashSHA512_256(Str: String): String;
function GetStrHashBobJenkins(Str: String): String;

implementation

function MD5Endcode(QStr: string): string;
var
  HashMD5: THashMD5;
begin
  HashMD5 := THashMD5.Create;
  result := HashMD5.GetHashString(QStr);
end;

function MD5Endcode(QStr: string; QbUpperCase: Boolean): string;
var
  HashMD5: THashMD5;
begin
  HashMD5 := THashMD5.Create;
  result := HashMD5.GetHashString(QStr);
  if QbUpperCase then
    result := result.ToUpper
  else
    result := result.ToLower;
end;

function MD5Endcode(QStr: string; QCodePage: Integer): String;
var
  ss: TStringStream;
  md5: string;
begin
  // gbk 936
  ss := TStringStream.Create(QStr, QCodePage);
  try
    // md5 := THashMD5.GetHashString(ss);
    result := md5;
  finally
    ss.Free;
  end;
end;

function GetStrHashSHA1(Str: String): String;
var
  HashSHA: THashSHA1;
begin
  HashSHA := THashSHA1.Create;
  HashSHA.GetHashString(Str);
  result := HashSHA.GetHashString(Str);
end;

function GetStrHashSHA224(Str: String): String;
var
  HashSHA: THashSHA2;
begin
  HashSHA := THashSHA2.Create;
  HashSHA.GetHashString(Str);
  result := HashSHA.GetHashString(Str, SHA224);
end;

function GetStrHashSHA256(Str: String): String;
var
  HashSHA: THashSHA2;
begin
  HashSHA := THashSHA2.Create;
  HashSHA.GetHashString(Str);
  result := HashSHA.GetHashString(Str, SHA256);
end;

function GetStrHashSHA384(Str: String): String;
var
  HashSHA: THashSHA2;
begin
  HashSHA := THashSHA2.Create;
  HashSHA.GetHashString(Str);
  result := HashSHA.GetHashString(Str, SHA384);
end;

function GetStrHashSHA512(Str: String): String;
var
  HashSHA: THashSHA2;
begin
  HashSHA := THashSHA2.Create;
  HashSHA.GetHashString(Str);
  result := HashSHA.GetHashString(Str, SHA512);
end;

function GetStrHashSHA512_224(Str: String): String;
var
  HashSHA: THashSHA2;
begin
  HashSHA := THashSHA2.Create;
  HashSHA.GetHashString(Str);
  result := HashSHA.GetHashString(Str, SHA512_224);
end;

function GetStrHashSHA512_256(Str: String): String;
var
  HashSHA: THashSHA2;
begin
  HashSHA := THashSHA2.Create;
  HashSHA.GetHashString(Str);
  result := HashSHA.GetHashString(Str, SHA512_256);
end;

function GetStrHashBobJenkins(Str: String): String;
var
  Hash: THashBobJenkins;
begin
  Hash := THashBobJenkins.Create;
  Hash.GetHashString(Str);
  result := Hash.GetHashString(Str);
end;

function GetFileHashMD5(FileName: WideString): String;
var
  HashMD5: THashMD5;
  Stream: TStream;
  Readed: Integer;
  Buffer: PByte;
  BufLen: Integer;
begin
  HashMD5 := THashMD5.Create;
  BufLen := 16 * 1024;
  Buffer := AllocMem(BufLen);
  try
    Stream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
    try
      while Stream.Position < Stream.Size do
      begin
        Readed := Stream.Read(Buffer^, BufLen);
        if Readed > 0 then
        begin
          HashMD5.update(Buffer^, Readed);
        end;
      end;
    finally
      Stream.Free;
    end;
  finally
    FreeMem(Buffer)
  end;
  result := HashMD5.HashAsString;
end;

function GetFileHashSHA1(FileName: WideString): String;
var
  HashSHA: THashSHA1;
  Stream: TStream;
  Readed: Integer;
  Buffer: PByte;
  BufLen: Integer;
begin
  HashSHA := THashSHA1.Create;
  BufLen := 16 * 1024;
  Buffer := AllocMem(BufLen);
  try
    Stream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
    try
      while Stream.Position < Stream.Size do
      begin
        Readed := Stream.Read(Buffer^, BufLen);
        if Readed > 0 then
        begin
          HashSHA.update(Buffer^, Readed);
        end;
      end;
    finally
      Stream.Free;
    end;
  finally
    FreeMem(Buffer)
  end;
  result := HashSHA.HashAsString;
end;

function GetFileHashSHA224(FileName: WideString): String;
var
  HashSHA: THashSHA2;
  Stream: TStream;
  Readed: Integer;
  Buffer: PByte;
  BufLen: Integer;
begin
  HashSHA := THashSHA2.Create(SHA224);
  BufLen := 16 * 1024;
  Buffer := AllocMem(BufLen);
  try
    Stream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
    try
      while Stream.Position < Stream.Size do
      begin
        Readed := Stream.Read(Buffer^, BufLen);
        if Readed > 0 then
        begin
          HashSHA.update(Buffer^, Readed);
        end;
      end;
    finally
      Stream.Free;
    end;
  finally
    FreeMem(Buffer)
  end;
  result := HashSHA.HashAsString;
end;

function GetFileHashSHA256(FileName: WideString): String;
var
  HashSHA: THashSHA2;
  Stream: TStream;
  Readed: Integer;
  Buffer: PByte;
  BufLen: Integer;
begin
  HashSHA := THashSHA2.Create(SHA256);
  BufLen := 16 * 1024;
  Buffer := AllocMem(BufLen);
  try
    Stream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
    try
      while Stream.Position < Stream.Size do
      begin
        Readed := Stream.Read(Buffer^, BufLen);
        if Readed > 0 then
        begin
          HashSHA.update(Buffer^, Readed);
        end;
      end;
    finally
      Stream.Free;
    end;
  finally
    FreeMem(Buffer)
  end;
  result := HashSHA.HashAsString;
end;

function GetFileHashSHA384(FileName: WideString): String;
var
  HashSHA: THashSHA2;
  Stream: TStream;
  Readed: Integer;
  Buffer: PByte;
  BufLen: Integer;
begin
  HashSHA := THashSHA2.Create(SHA384);
  BufLen := 16 * 1024;
  Buffer := AllocMem(BufLen);
  try
    Stream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
    try
      while Stream.Position < Stream.Size do
      begin
        Readed := Stream.Read(Buffer^, BufLen);
        if Readed > 0 then
        begin
          HashSHA.update(Buffer^, Readed);
        end;
      end;
    finally
      Stream.Free;
    end;
  finally
    FreeMem(Buffer)
  end;
  result := HashSHA.HashAsString;
end;

function GetFileHashSHA512(FileName: WideString): String;
var
  HashSHA: THashSHA2;
  Stream: TStream;
  Readed: Integer;
  Buffer: PByte;
  BufLen: Integer;
begin
  HashSHA := THashSHA2.Create(SHA512);
  BufLen := 16 * 1024;
  Buffer := AllocMem(BufLen);
  try
    Stream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
    try
      while Stream.Position < Stream.Size do
      begin
        Readed := Stream.Read(Buffer^, BufLen);
        if Readed > 0 then
        begin
          HashSHA.update(Buffer^, Readed);
        end;
      end;
    finally
      Stream.Free;
    end;
  finally
    FreeMem(Buffer)
  end;
  result := HashSHA.HashAsString;
end;

function GetFileHashSHA512_224(FileName: WideString): String;
var
  HashSHA: THashSHA2;
  Stream: TStream;
  Readed: Integer;
  Buffer: PByte;
  BufLen: Integer;
begin
  HashSHA := THashSHA2.Create(SHA512_224);
  BufLen := 16 * 1024;
  Buffer := AllocMem(BufLen);
  try
    Stream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
    try
      while Stream.Position < Stream.Size do
      begin
        Readed := Stream.Read(Buffer^, BufLen);
        if Readed > 0 then
        begin
          HashSHA.update(Buffer^, Readed);
        end;
      end;
    finally
      Stream.Free;
    end;
  finally
    FreeMem(Buffer)
  end;
  result := HashSHA.HashAsString;
end;

function GetFileHashSHA512_256(FileName: WideString): String;
var
  HashSHA: THashSHA2;
  Stream: TStream;
  Readed: Integer;
  Buffer: PByte;
  BufLen: Integer;
begin
  HashSHA := THashSHA2.Create(SHA512_256);
  BufLen := 16 * 1024;
  Buffer := AllocMem(BufLen);
  try
    Stream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
    try
      while Stream.Position < Stream.Size do
      begin
        Readed := Stream.Read(Buffer^, BufLen);
        if Readed > 0 then
        begin
          HashSHA.update(Buffer^, Readed);
        end;
      end;
    finally
      Stream.Free;
    end;
  finally
    FreeMem(Buffer)
  end;
  result := HashSHA.HashAsString;
end;

function GetFileHashBobJenkins(FileName: WideString): String;
var
  Hash: THashBobJenkins;
  Stream: TStream;
  Readed: Integer;
  Buffer: PByte;
  BufLen: Integer;
begin
  Hash := THashBobJenkins.Create;
  BufLen := 16 * 1024;
  Buffer := AllocMem(BufLen);
  try
    Stream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
    try
      while Stream.Position < Stream.Size do
      begin
        Readed := Stream.Read(Buffer^, BufLen);
        if Readed > 0 then
        begin
          Hash.update(Buffer^, Readed);
        end;
      end;
    finally
      Stream.Free;
    end;
  finally
    FreeMem(Buffer)
  end;
  result := Hash.HashAsString;
end;

end.

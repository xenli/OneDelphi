unit ssl_lib;

interface

uses
{$IFDEF MSWINDOWS}
{$IFDEF FPC}
  windows,
{$ELSE}
  windows,
{$ENDIF}
{$ENDIF}
  sysutils;

var
  CLibCrypto: AnsiString =
{$IFDEF MSWINDOWS}
{$IFDEF CPUX86}'libcrypto-1_1.dll'{$ENDIF}
{$IFDEF CPUX64}'libcrypto-1_1-x64.dll'{$ENDIF}
{$ELSE}
{$IFDEF MACOS}
    libcrypto.dylib
{$ELSE}
{$IFDEF POSIX}
    'libcrypto.so'
{$ELSE}
    'libcrypto'
{$ENDIF};
{$ENDIF};
{$ENDIF};
CLibSSL:
AnsiString =
{$IFDEF MSWINDOWS}
{$IFDEF CPUX86}'libssl-1_1.dll'{$ENDIF}
{$IFDEF CPUX64}'libssl-1_1-x64.dll'{$ENDIF}
{$ELSE}
{$IFDEF MACOS}
  libssl.dylib
{$ELSE}
{$IFDEF POSIX}
  'libssl.so'
{$ELSE}
  'libssl'
{$ENDIF};
{$ENDIF};
{$ENDIF};

function CLibCryptoHandle: THandle;
function LoadCLibCrypto: Boolean;
function LoadFuncCLibCrypto(const FceName: String; const ACritical: Boolean = True): Pointer;

function CLibSSLHandle: THandle;
function LoadCLibSSL: Boolean;
function LoadFuncCLibSSL(const FceName: String; const ACritical: Boolean = True): Pointer;

implementation


var
  hCrypt: THandle = 0;
  hSSL:THandle = 0;

function CLibCryptoHandle: THandle;
begin
  Result := hCrypt;
end;

function LoadCLibCrypto: Boolean;
begin
  hCrypt := SafeLoadLibrary(CLibCrypto);
  Result := hCrypt <> 0;
end;

function LoadFuncCLibCrypto(const FceName: String; const ACritical: Boolean = True): Pointer;
begin
  if CLibCryptoHandle = 0 then
  begin
    if (not LoadCLibCrypto()) then
    begin
      raise Exception.Create('加载['+CLibCrypto+']错误');
    end;
  end;
  Result := {$IFDEF MSWINDOWS}windows.{$ENDIF}GetProcAddress(CLibCryptoHandle, PChar(FceName));
  if ACritical then
  begin
    if Result = nil then
    begin
{$IFDEF fpc}
      raise Exception.CreateFmt('Error loading library. Func %s'#13#10'%s', [FceName, SysErrorMessage(GetLastOSError)]);
{$ELSE}
      raise Exception.CreateFmt('Error loading library. Func %s'#13#10'%s', [FceName, SysErrorMessage(GetLastError)]);
{$ENDIF}
    end;
  end;
end;

function CLibSSLHandle: THandle;
begin
  Result := hSSL;
end;
function LoadCLibSSL: Boolean;
begin
  hSSL := SafeLoadLibrary(CLibSSL);
  Result := hSSL <> 0;
end;
function LoadFuncCLibSSL(const FceName: String; const ACritical: Boolean = True): Pointer;
begin
  if CLibSSLHandle = 0 then
  begin
    if (not LoadCLibSSL()) then
    begin
     raise Exception.Create('加载['+CLibSSL+']错误');
    end;
  end;
  Result := {$IFDEF MSWINDOWS}windows.{$ENDIF}GetProcAddress(CLibSSLHandle, PChar(FceName));
  if ACritical then
  begin
    if Result = nil then
    begin
{$IFDEF fpc}
      raise Exception.CreateFmt('Error loading library. Func %s'#13#10'%s', [FceName, SysErrorMessage(GetLastOSError)]);
{$ELSE}
      raise Exception.CreateFmt('Error loading library. Func %s'#13#10'%s', [FceName, SysErrorMessage(GetLastError)]);
{$ENDIF}
    end;
  end;
end;

initialization

finalization

if hCrypt <> 0 then
begin
{$IFDEF MSWINDOWS}
  FreeLibrary(hCrypt);
  FreeLibrary(hSSL);
{$ENDIF MSWINDOWS}
{$IFDEF POSIX}
  dlclose(hCrypt);
{$ENDIF POSIX}
end;

end.

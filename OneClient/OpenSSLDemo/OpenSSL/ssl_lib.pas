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

function SSLCryptHandle: THandle;
function LoadSSLCrypt: Boolean;
function LoadFunctionCLib(const FceName: String; const ACritical: Boolean = True): Pointer;

implementation


var
  hCrypt: THandle = 0;

function SSLCryptHandle: THandle;
begin
  Result := hCrypt;
end;

function LoadSSLCrypt: Boolean;
begin
  hCrypt := SafeLoadLibrary(CLibCrypto);
  Result := hCrypt <> 0;
end;

function LoadFunctionCLib(const FceName: String; const ACritical: Boolean = True): Pointer;
begin
  if SSLCryptHandle = 0 then
  begin
    if (not LoadSSLCrypt()) then
    begin
      raise Exception.Create('加载OpenSSL包出错,请放在正确的文件目录下或exe运行目录');
    end;
  end;
  Result := {$IFDEF MSWINDOWS}windows.{$ENDIF}GetProcAddress(SSLCryptHandle, PChar(FceName));
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
{$ENDIF MSWINDOWS}
{$IFDEF POSIX}
  dlclose(hCrypt);
{$ENDIF POSIX}
end;

end.

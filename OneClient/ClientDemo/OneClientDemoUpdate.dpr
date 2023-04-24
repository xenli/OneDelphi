program OneClientDemoUpdate;

uses
  Vcl.Forms,
  Winapi.Windows,
  frmDemoUpdate in 'frmDemoUpdate.pas' {frDemoUpdate};

{$R *.res}


var
  lpStartupInfo: TStartupInfo;
  lpProcessInformation: TProcessInformation;

begin
  Application.Initialize;
  if DebugHook <> 0 then
    ReportMemoryLeaksOnShutdown := true;
  Application.MainFormOnTaskbar := true;
  Application.CreateForm(TfrDemoUpdate, frDemoUpdate);
  Application.Run;
  if not Restart_Flag then
    Exit; // 不需要重启
  FillChar(lpStartupInfo, sizeof(lpStartupInfo), 0);
  FillChar(lpProcessInformation, sizeof(lpProcessInformation), 0);
  lpStartupInfo.cb := sizeof(lpStartupInfo);
  if CreateProcess(nil, PChar(Application.ExeName), nil, nil, false, 0, nil, nil, lpStartupInfo, lpProcessInformation) then
  begin
    CloseHandle(lpProcessInformation.hThread);
    CloseHandle(lpProcessInformation.hProcess);
  end;

end.

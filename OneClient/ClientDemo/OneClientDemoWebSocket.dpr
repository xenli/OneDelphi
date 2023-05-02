program OneClientDemoWebSocket;

uses
  Vcl.Forms,
  frmDemoWebSocket in 'frmDemoWebSocket.pas' {frDemoWebSocket};

{$R *.res}


begin
  Application.Initialize;
  if DebugHook <> 0 then
    ReportMemoryLeaksOnShutdown := true;
  Application.MainFormOnTaskbar := true;
  Application.CreateForm(TfrDemoWebSocket, frDemoWebSocket);
  Application.Run;

end.

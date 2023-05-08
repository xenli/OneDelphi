program OneClientDemoWebSocketChat;

uses
  Vcl.Forms,
  frmDemoWebSocketChat in 'frmDemoWebSocketChat.pas' {frDemWsChat};

{$R *.res}


begin
  Application.Initialize;
  if DebugHook <> 0 then
    ReportMemoryLeaksOnShutdown := true;
  Application.MainFormOnTaskbar := true;
  Application.CreateForm(TfrDemWsChat, frDemWsChat);
  Application.Run;

end.

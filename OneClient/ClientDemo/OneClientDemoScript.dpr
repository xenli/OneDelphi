program OneClientDemoScript;

uses
  Vcl.Forms,
  frmDemoScript in 'frmDemoScript.pas' {frDemoScript};

{$R *.res}


begin
  Application.Initialize;
  if DebugHook <> 0 then
    ReportMemoryLeaksOnShutdown := true;
  Application.MainFormOnTaskbar := true;
  Application.CreateForm(TfrDemoScript, frDemoScript);
  Application.Run;

end.

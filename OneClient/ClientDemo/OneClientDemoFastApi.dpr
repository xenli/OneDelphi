program OneClientDemoFastApi;

uses
  Vcl.Forms,
  frmDemoFastApi in 'frmDemoFastApi.pas' {frDemoFastApi},
  frm_fastApiReport in 'frm_fastApiReport.pas' {frmFastApiReport};

{$R *.res}


begin
  Application.Initialize;
  if DebugHook <> 0 then
    ReportMemoryLeaksOnShutdown := true;
  Application.MainFormOnTaskbar := true;
  Application.CreateForm(TfrDemoFastApi, frDemoFastApi);
  Application.Run;

end.

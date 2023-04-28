program OneClientDemoFastFile;

uses
  Vcl.Forms,
  frmDemoFastFile in 'frmDemoFastFile.pas' {frDemoFastFile};

{$R *.res}


begin
  Application.Initialize;
  if DebugHook <> 0 then
    ReportMemoryLeaksOnShutdown := true;
  Application.MainFormOnTaskbar := true;
  Application.CreateForm(TfrDemoFastFile, frDemoFastFile);
  Application.Run;

end.

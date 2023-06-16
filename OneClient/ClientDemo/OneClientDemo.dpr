program OneClientDemo;

uses
  Vcl.Forms,
  frmDemoMain in 'frmDemoMain.pas' {frDemoMain};

{$R *.res}

begin
  Application.Initialize;
  if DebugHook <> 0 then
    ReportMemoryLeaksOnShutdown := true;
  Application.MainFormOnTaskbar := true;
  Application.CreateForm(TfrDemoMain, frDemoMain);
  Application.Run;

end.

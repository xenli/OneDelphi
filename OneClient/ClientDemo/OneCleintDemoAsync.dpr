program OneCleintDemoAsync;

uses
  Vcl.Forms,
  frmDemoAsync in 'frmDemoAsync.pas' {Form5};

{$R *.res}


begin
  Application.Initialize;
  if DebugHook <> 0 then
    ReportMemoryLeaksOnShutdown := true;
  Application.MainFormOnTaskbar := true;
  Application.CreateForm(TForm5, Form5);
  Application.Run;

end.

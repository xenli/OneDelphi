program OneCleintDemoPostGet;

uses
  Vcl.Forms,
  frmDemoPostGet in 'frmDemoPostGet.pas' {Form4};

{$R *.res}


begin
  Application.Initialize;
  if DebugHook <> 0 then
    ReportMemoryLeaksOnShutdown := true;
  Application.MainFormOnTaskbar := true;
  Application.CreateForm(TForm4, Form4);
  Application.Run;

end.

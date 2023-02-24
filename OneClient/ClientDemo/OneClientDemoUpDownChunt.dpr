program OneClientDemoUpDownChunt;

uses
  Vcl.Forms,
  frmDemoUpDownChunk in 'frmDemoUpDownChunk.pas' {Form7};

{$R *.res}


begin
  Application.Initialize;
  if DebugHook <> 0 then
    ReportMemoryLeaksOnShutdown := true;
  Application.MainFormOnTaskbar := true;
  Application.CreateForm(TForm7, Form7);
  Application.Run;

end.

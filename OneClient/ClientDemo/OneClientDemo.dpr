program OneClientDemo;

uses
  Vcl.Forms,
  frmDemoMain in 'frmDemoMain.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  if DebugHook <> 0 then
    ReportMemoryLeaksOnShutdown := true;
  Application.MainFormOnTaskbar := true;
  Application.CreateForm(TForm1, Form1);
  Application.Run;

end.

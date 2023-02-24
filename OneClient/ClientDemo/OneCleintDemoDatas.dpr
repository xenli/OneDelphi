program OneCleintDemoDatas;

uses
  Vcl.Forms,
  frmDemoDatas in 'frmDemoDatas.pas' {Form2};

{$R *.res}


begin
  Application.Initialize;
  if DebugHook <> 0 then
    ReportMemoryLeaksOnShutdown := true;
  Application.MainFormOnTaskbar := true;
  Application.CreateForm(TForm2, Form2);
  Application.Run;

end.

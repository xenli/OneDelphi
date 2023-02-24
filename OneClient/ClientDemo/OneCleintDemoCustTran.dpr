program OneCleintDemoCustTran;

uses
  Vcl.Forms,
  frmDemoCustTran in 'frmDemoCustTran.pas' {Form3};

{$R *.res}


begin
  Application.Initialize;
  if DebugHook <> 0 then
    ReportMemoryLeaksOnShutdown := true;
  Application.MainFormOnTaskbar := true;
  Application.CreateForm(TForm3, Form3);
  Application.Run;

end.

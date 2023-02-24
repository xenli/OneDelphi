program OneClientDemoVirtualFile;

uses
  Vcl.Forms,
  frmDemoVirtualFile in 'frmDemoVirtualFile.pas' {Form6};

{$R *.res}


begin
  Application.Initialize;
  if DebugHook <> 0 then
    ReportMemoryLeaksOnShutdown := true;
  Application.MainFormOnTaskbar := true;
  Application.CreateForm(TForm6, Form6);
  Application.Run;

end.

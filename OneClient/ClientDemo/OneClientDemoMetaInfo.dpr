program OneClientDemoMetaInfo;

uses
  Vcl.Forms,
  frmDemoMetaInfo in 'frmDemoMetaInfo.pas' {frDemoMetaInfo};

{$R *.res}


begin
  Application.Initialize;
  if DebugHook <> 0 then
    ReportMemoryLeaksOnShutdown := true;
  Application.MainFormOnTaskbar := true;
  Application.CreateForm(TfrDemoMetaInfo, frDemoMetaInfo);
  Application.Run;

end.

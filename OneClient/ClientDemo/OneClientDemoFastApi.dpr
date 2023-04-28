program OneClientDemoFastApi;

uses
  Vcl.Forms,
  frmDemoFastApi in 'frmDemoFastApi.pas' {frDemoFastApi};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrDemoFastApi, frDemoFastApi);
  Application.Run;
end.

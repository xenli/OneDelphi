program OneClientDemoLsh;

uses
  Vcl.Forms,
  frmDemoLsh in 'frmDemoLsh.pas' {frDemoLsh};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrDemoLsh, frDemoLsh);
  Application.Run;
end.

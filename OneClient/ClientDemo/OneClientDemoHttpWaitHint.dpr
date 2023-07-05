program OneClientDemoHttpWaitHint;

uses
  Vcl.Forms,
  frmDemoHttpWaitHint in 'frmDemoHttpWaitHint.pas' {frDemoHttpWaitHint},
  frmWait in 'frmWait.pas' {frWaitHint};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrDemoHttpWaitHint, frDemoHttpWaitHint);
  Application.Run;
end.

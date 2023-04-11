program OneClientDemoUUID;

uses
  Vcl.Forms,
  frmDemoUUID in 'frmDemoUUID.pas' {frmUUID};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmUUID, frmUUID);
  Application.Run;
end.

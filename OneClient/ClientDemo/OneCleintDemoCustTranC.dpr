program OneCleintDemoCustTranC;

uses
  Vcl.Forms,
  frmDemoCustTranC in 'frmDemoCustTranC.pas' {Form9};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm9, Form9);
  Application.Run;
end.

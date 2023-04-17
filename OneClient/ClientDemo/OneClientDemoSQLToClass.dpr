program OneClientDemoSQLToClass;

uses
  Vcl.Forms,
  frmDemoSQLToClass in 'frmDemoSQLToClass.pas' {frDemoSQLToClass};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrDemoSQLToClass, frDemoSQLToClass);
  Application.Run;
end.

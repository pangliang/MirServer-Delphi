program FileEnc;

uses
  Forms,
  Main in 'Main.pas' {MainFrm};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TMainFrm, MainFrm);
  Application.Run;
end.

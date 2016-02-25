program LogDataServer;

uses
  Forms,
  LogDataMain in 'LogDataMain.pas' {FrmLogData},
  LDShare in 'LDShare.pas',
  Grobal2 in 'Grobal2.pas',
  HUtil32 in '..\Common\HUtil32.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TFrmLogData, FrmLogData);
  Application.Run;
end.

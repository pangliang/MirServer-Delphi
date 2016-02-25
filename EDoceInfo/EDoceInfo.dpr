program EDoceInfo;

uses
  Forms,
  Main in 'Main.pas' {MainForm},
  EDcodeUnit in '..\Common\EDcodeUnit.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.

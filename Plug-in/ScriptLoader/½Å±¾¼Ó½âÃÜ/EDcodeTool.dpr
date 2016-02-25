program EDcodeTool;

uses
  Forms,
  Main in 'Main.pas' {FrmMain},
  DESTR in '..\DESTR.pas',
  EncryptUnit in '..\..\SystemModule\EncryptUnit.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFrmMain, FrmMain);
  Application.Run;
end.

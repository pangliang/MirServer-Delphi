program MakeKey;

uses
  Forms,
  Main in 'Main.pas' {FrmMakeKey},
  Share in 'Share.pas',
  Common in '..\..\Common\Common.pas',
  EDcodeUnit in '..\..\Common\EDcodeUnit.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFrmMakeKey, FrmMakeKey);
  Application.Run;
end.

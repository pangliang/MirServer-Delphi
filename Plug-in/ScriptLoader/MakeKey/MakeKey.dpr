program MakeKey;

uses
  Forms,
  MakeKeyMain in 'MakeKeyMain.pas' {FrmMakeKey},
  PlugMain in '..\PlugMain.pas',
  Share in '..\Share.pas',
  SDK in '..\SDK.pas',
  MD5EncodeStr in '..\MD5EncodeStr.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFrmMakeKey, FrmMakeKey);
  Application.Run;
end.

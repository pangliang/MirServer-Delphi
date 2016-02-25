program Clear;

uses
  Forms,
  Main in 'Main.pas' {FrmClean},
  SystemManage in '..\SystemManage.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFrmClean, FrmClean);
  Application.Run;
end.

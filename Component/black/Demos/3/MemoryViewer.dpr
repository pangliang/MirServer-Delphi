program MemoryViewer;

uses
  Forms,
  Main in 'Main.pas' {Form2};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Memory Viewer';
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.

program ProcView;

uses
  Forms,
  Main in 'Main.pas' {wnd_Main};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Process Viewer';
  Application.CreateForm(Twnd_Main, wnd_Main);
  Application.Run;
end.

program DiskView;

uses
  Forms,
  Main in 'Main.pas' {wnd_dv_Main};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(Twnd_dv_Main, wnd_dv_Main);
  Application.Run;
end.

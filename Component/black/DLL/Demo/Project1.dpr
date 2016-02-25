program Project1;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  MSIC_Intf in '..\MSIC_Intf.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

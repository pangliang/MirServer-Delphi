unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, EDcodeUnit;

type
  TMainForm = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Button1: TButton;
    Button2: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

procedure TMainForm.Button1Click(Sender: TObject);
var
  sDest:String;
begin
  if Encode(Edit1.Text, sDest) then Edit2.Text:=sDest;
end;

procedure TMainForm.Button2Click(Sender: TObject);
var
  sDest:String;
begin
  if Decode(Edit2.Text, sDest) then Edit1.Text:=sDest;
end;

end.

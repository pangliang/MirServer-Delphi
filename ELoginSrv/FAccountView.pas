unit FAccountView;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls;
type
  TFrmAccountView = class(TForm)
    EdFindId: TEdit;
    EdFindIP: TEdit;
    ListBox1: TListBox;
    ListBox2: TListBox;
    procedure EdFindIdKeyPress(Sender: TObject; var Key: Char);
    procedure EdFindIPKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmAccountView: TFrmAccountView;

implementation

{$R *.DFM}

procedure TFrmAccountView.EdFindIdKeyPress(Sender: TObject; var Key: Char);
var
  I: Integer;
begin
  if Key <> #13 then Exit;
  for I := 0 to ListBox1.Items.Count - 1 do begin
    if EdFindId.Text = ListBox1.Items.Strings[I] then
      ListBox1.ItemIndex := I;
  end;
end;

procedure TFrmAccountView.EdFindIPKeyPress(Sender: TObject; var Key: Char);
var
  I: Integer;
begin
  if Key <> #13 then Exit;
  for I := 0 to ListBox2.Items.Count - 1 do begin
    if EdFindIP.Text = ListBox2.Items.Strings[I] then
      ListBox2.ItemIndex := I;
  end;
end;

end.

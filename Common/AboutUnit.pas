unit AboutUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TFrmAbout = class(TForm)
    ButtonOK: TButton;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    GroupBox2: TGroupBox;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    EditProductName: TEdit;
    EditVersion: TEdit;
    EditUpDateTime: TEdit;
    EditProgram: TEdit;
    EditWebSite: TEdit;
    EditBbsSite: TEdit;
    procedure ButtonOKClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Open();
  end;

var
  FrmAbout: TFrmAbout;

implementation
uses EncryptUnit, M2Share;
{$R *.dfm}
procedure TFrmAbout.Open();
const
{$IF Version = SuperUser}
  nUseKey = SuperUser;
{$ELSEIF Version = UserKey1}
  nUseKey = UserKey1;
{$ELSEIF Version = UserKey2}
  nUseKey = UserKey2;
{$ELSEIF Version = UserKey3}
  nUseKey = UserKey3;
{$ELSEIF Version = UserKey4}
  nUseKey = UserKey4;
{$IFEND}
begin
  EditProductName.Text := DecodeString_3des(g_sProductName, IntToStr(nUseKey));
  EditVersion.Text := Format(DecodeString_3des(g_sVersion, IntToStr(nUseKey)), [0]);
  EditUpDateTime.Text := DecodeString_3des(g_sUpDateTime, IntToStr(nUseKey));
  EditProgram.Text := DecodeString_3des(g_sProgram, IntToStr(nUseKey));
  EditWebSite.Text := DecodeString_3des(g_sWebSite, IntToStr(nUseKey));
  EditBbsSite.Text := DecodeString_3des(g_sBbsSite, IntToStr(nUseKey));
  ShowModal;
end;

procedure TFrmAbout.ButtonOKClick(Sender: TObject);
begin
  Close;
end;

end.


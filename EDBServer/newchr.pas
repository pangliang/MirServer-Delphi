unit newchr;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls;
type
  TFrmNewChr=class(TForm)
    EdName: TEdit;
    Button1: TButton;
    Label1: TLabel;
    procedure Button1Click(Sender : TObject);
    procedure FormShow(Sender : TObject);
    procedure EdNameKeyPress(Sender : TObject);
  private
    { Private declarations }
  public
    function sub_49BD60(var sChrName:String):Boolean;
    { Public declarations }
  end ;

var
  FrmNewChr: TFrmNewChr;

implementation

{$R *.DFM}

procedure TFrmNewChr.Button1Click(Sender : TObject);
begin
(*
0049BDEC   55                     push    ebp
0049BDED   8BEC                   mov     ebp, esp
0049BDEF   83C4F8                 add     esp, -$08
0049BDF2   8955F8                 mov     [ebp-$08], edx
0049BDF5   8945FC                 mov     [ebp-$04], eax

* Reference to FrmNewChr
|
0049BDF8   8B45FC                 mov     eax, [ebp-$04]

* Reference to: forms.TCustomForm.Close(TCustomForm);
|
0049BDFB   E8C40DFBFF             call    0044CBC4
0049BE00   59                     pop     ecx
0049BE01   59                     pop     ecx
0049BE02   5D                     pop     ebp
0049BE03   C3                     ret

*)
end;

procedure TFrmNewChr.FormShow(Sender : TObject);
begin
(*
0049BE2C   55                     push    ebp
0049BE2D   8BEC                   mov     ebp, esp
0049BE2F   83C4F8                 add     esp, -$08
0049BE32   8955F8                 mov     [ebp-$08], edx
0049BE35   8945FC                 mov     [ebp-$04], eax

* Reference to FrmNewChr
|
0049BE38   8B45FC                 mov     eax, [ebp-$04]

* Reference to control TFrmNewChr.EdName : TEdit
|
0049BE3B   8B80D0020000           mov     eax, [eax+$02D0]
0049BE41   8B10                   mov     edx, [eax]

* Reference to method TEdit.SetFocus()
|
0049BE43   FF92B0000000           call    dword ptr [edx+$00B0]
0049BE49   59                     pop     ecx
0049BE4A   59                     pop     ecx
0049BE4B   5D                     pop     ebp
0049BE4C   C3                     ret

*)
end;

procedure TFrmNewChr.EdNameKeyPress(Sender : TObject);
begin
(*
0049BE04   55                     push    ebp
0049BE05   8BEC                   mov     ebp, esp
0049BE07   83C4F4                 add     esp, -$0C
0049BE0A   894DF8                 mov     [ebp-$08], ecx
0049BE0D   8955F4                 mov     [ebp-$0C], edx
0049BE10   8945FC                 mov     [ebp-$04], eax
0049BE13   8B45F8                 mov     eax, [ebp-$08]
0049BE16   80380D                 cmp     byte ptr [eax], $0D
0049BE19   750B                   jnz     0049BE26

* Reference to FrmNewChr
|
0049BE1B   8B55FC                 mov     edx, [ebp-$04]

* Reference to FrmNewChr
|
0049BE1E   8B45FC                 mov     eax, [ebp-$04]

* Reference to : TFrmNewChr.Button1Click()
|
0049BE21   E8C6FFFFFF             call    0049BDEC
0049BE26   8BE5                   mov     esp, ebp
0049BE28   5D                     pop     ebp
0049BE29   C3                     ret

*)
end;


function TFrmNewChr.sub_49BD60(var sChrName:String): Boolean;
//0x0049BD60
begin
  Result:=False;
  EdName.Text:='';
  Self.ShowModal;
  sChrName:=Trim(EdName.Text);
  if sChrName <> '' then Result:=True;    
end;

end.
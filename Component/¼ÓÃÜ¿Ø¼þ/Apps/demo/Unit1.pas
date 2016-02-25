unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DCPcrypt, Blowfish, Haval, Md4, Md5, Rmd160, Sha1,
  Twofish, Rijndael, RC5, RC6, RC4, RC2, Misty1, Mars, IDEA, Ice, Gost,
  DES, Cast256, Cast128, RzSpnEdt, RzLabel;

type
  TForm1 = class(TForm)
    DCP_blowfish1: TDCP_blowfish;
    Button1: TButton;
    DCP_cast1281: TDCP_cast128;
    DCP_cast2561: TDCP_cast256;
    DCP_des1: TDCP_des;
    DCP_3des1: TDCP_3des;
    DCP_gost1: TDCP_gost;
    DCP_ice1: TDCP_ice;
    DCP_ice21: TDCP_ice2;
    DCP_thinice1: TDCP_thinice;
    DCP_idea1: TDCP_idea;
    DCP_mars1: TDCP_mars;
    DCP_misty11: TDCP_misty1;
    DCP_rc21: TDCP_rc2;
    DCP_rc41: TDCP_rc4;
    DCP_rc61: TDCP_rc6;
    DCP_rc51: TDCP_rc5;
    DCP_rijndael1: TDCP_rijndael;
    DCP_twofish1: TDCP_twofish;
    DCP_sha11: TDCP_sha1;
    DCP_ripemd1601: TDCP_ripemd160;
    DCP_md51: TDCP_md5;
    DCP_md41: TDCP_md4;
    DCP_haval1: TDCP_haval;
    GroupBox1: TGroupBox;
    ComboBox1: TComboBox;
    Edit3: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Button2: TButton;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    ComboBox2: TComboBox;
    Button3: TButton;
    Button4: TButton;
    Memo1: TMemo;
    Memo2: TMemo;
    Button5: TButton;
    RzLabel1: TRzLabel;
    RzSpinner1: TRzSpinner;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
 var
 i :integer;
 //    Source, Dest: string;
//    Cipher: TDCP_blowfish;
  begin
  Memo2.Lines.Clear;
  for i:=0 to Memo1.Lines.Count-1 do
  begin

    case ComboBox1.ItemIndex of
      0:
        begin
          DCP_blowfish1.InitStr(edit3.text);
          DCP_blowfish1.Reset;
          Memo2.Lines.Add(DCP_blowfish1.EncryptString(Memo1.Lines.Strings[i]));
          DCP_blowfish1.Reset;
        end;
      1:
        begin
          DCP_cast1281.InitStr(edit3.text);
          DCP_cast1281.Reset;
          Memo2.Lines.Add(DCP_cast1281.EncryptString(Memo1.Lines.Strings[i]));
          DCP_cast1281.Reset;
        end;
      2:
        begin
          DCP_cast2561.InitStr(edit3.text);
          DCP_cast2561.Reset;
          Memo2.Lines.Add(DCP_cast2561.EncryptString(Memo1.Lines.Strings[i]));
          DCP_cast2561.Reset;
        end;
      3:
        begin
          DCP_des1.InitStr(edit3.text);
          DCP_des1.Reset;
          Memo2.Lines.Add(DCP_des1.EncryptString(Memo1.Lines.Strings[i]));
          DCP_des1.Reset;
        end;
      4:
        begin
          DCP_3des1.InitStr(edit3.text);
          DCP_3des1.Reset;
          Memo2.Lines.Add(DCP_3des1.EncryptString(Memo1.Lines.Strings[i]));
          DCP_3des1.Reset;
        end;
      5:
        begin
          DCP_gost1.InitStr(edit3.text);
          DCP_gost1.Reset;
          Memo2.Lines.Add(DCP_gost1.EncryptString(Memo1.Lines.Strings[i]));
          DCP_gost1.Reset;
        end;
      6:
        begin
          DCP_ice1.InitStr(edit3.text);
          DCP_ice1.Reset;
          Memo2.Lines.Add(DCP_ice1.EncryptString(Memo1.Lines.Strings[i]));
          DCP_ice1.Reset;
        end;
      7:
        begin
          DCP_ice21.InitStr(edit3.text);
          DCP_ice21.Reset;
          Memo2.Lines.Add(DCP_ice21.EncryptString(Memo1.Lines.Strings[i]));
          DCP_ice21.Reset;
        end;
      8:
        begin
          DCP_idea1.InitStr(edit3.text);
          DCP_idea1.Reset;
          Memo2.Lines.Add(DCP_idea1.EncryptString(Memo1.Lines.Strings[i]));
          DCP_idea1.Reset;
        end;
      9:
        begin
          DCP_mars1.InitStr(edit3.text);
          DCP_mars1.Reset;
          Memo2.Lines.Add(DCP_mars1.EncryptString(Memo1.Lines.Strings[i]));
          DCP_mars1.Reset;
        end;
      10:
        begin
          DCP_misty11.InitStr(edit3.text);
          DCP_misty11.Reset;
          Memo2.Lines.Add(DCP_misty11.EncryptString(Memo1.Lines.Strings[i]));
          DCP_misty11.Reset;
        end;
      11:
        begin
          DCP_rc21.InitStr(edit3.text);
          DCP_rc21.Reset;
          Memo2.Lines.Add(DCP_rc21.EncryptString(Memo1.Lines.Strings[i]));
          DCP_rc21.Reset;
        end;
      12:
        begin
          DCP_rc41.InitStr(edit3.text);
          DCP_rc41.Reset;
          Memo2.Lines.Add(DCP_rc41.EncryptString(Memo1.Lines.Strings[i]));
          DCP_rc41.Reset;
        end;
      13:
        begin
          DCP_rc51.InitStr(edit3.text);
          DCP_rc51.Reset;
          Memo2.Lines.Add(DCP_rc51.EncryptString(Memo1.Lines.Strings[i]));
          DCP_rc51.Reset;
        end;
      14:
        begin
          DCP_rc61.InitStr(edit3.text);
          DCP_rc61.Reset;
          Memo2.Lines.Add(DCP_rc61.EncryptString(Memo1.Lines.Strings[i]));
          DCP_rc61.Reset;
        end;
      15:
        begin
          DCP_rijndael1.InitStr(edit3.text);
          DCP_rijndael1.Reset;
          Memo2.Lines.Add(DCP_rijndael1.EncryptString(Memo1.Lines.Strings[i]));
          DCP_rijndael1.Reset;
        end;
      16:
        begin
          DCP_thinice1.InitStr(edit3.text);
          DCP_thinice1.Reset;
          Memo2.Lines.Add(DCP_thinice1.EncryptString(Memo1.Lines.Strings[i]));
          DCP_thinice1.Reset;
        end;
      17:
        begin
          DCP_twofish1.InitStr(edit3.text);
          DCP_twofish1.Reset;
          Memo2.Lines.Add(DCP_twofish1.EncryptString(Memo1.Lines.Strings[i]));
          DCP_twofish1.Reset;
          //edit2.text:= DCP_twofish1.DecryptString(edit1.text);
        end;

     end;
    end;
//  end;
//DCP_blowfish1.Burn;
//    DCP_blowfish1.Free;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
close;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  ComboBox1.Items.Add('blowfish');
  ComboBox1.Items.Add('cost128');
  ComboBox1.Items.Add('cost256');
  ComboBox1.Items.Add('des');
  ComboBox1.Items.Add('3des');
  ComboBox1.Items.Add('gost');
  ComboBox1.Items.Add('ice');
  ComboBox1.Items.Add('ice2');
  ComboBox1.Items.Add('idea');
  ComboBox1.Items.Add('mars');
  ComboBox1.Items.Add('misty1');
  ComboBox1.Items.Add('rc2');
  ComboBox1.Items.Add('rc4');
  ComboBox1.Items.Add('rc5');
  ComboBox1.Items.Add('rc6');
  ComboBox1.Items.Add('rijndael');
  ComboBox1.Items.Add('thinice');
  ComboBox1.Items.Add('twofish');
  ComboBox2.Items.Add('HAVAL');
  ComboBox2.Items.Add('MD4');
  ComboBox2.Items.Add('MD5');
  ComboBox2.Items.Add('RMD160');
  ComboBox2.Items.Add('SHA1');
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
{var
  Read,len: integer;
  HashDigest: array[0..31] of byte;
  S: string;
begin
  S:=edit4.Text;
  case ComboBox2.ItemIndex of
    0:
      begin
        DCP_HAVAL1.Init ;
        DCP_HAVAL1.UpdateStr(S);
        DCP_HAVAL1.Final(HashDigest);
        len:=DCP_HAVAL1.HashSize;
      end;
    1:
      begin
        DCP_MD41.Init ;
        DCP_MD41.UpdateStr(S);
        DCP_MD41.Final(HashDigest);
        len:=DCP_MD41.HashSize;
      end;
    2:
      begin
        DCP_MD51.Init ;
        DCP_MD51.UpdateStr(S);
        DCP_MD51.Final(HashDigest);
        len:=DCP_MD51.HashSize;
      end;
    3:
      begin
        DCP_ripemd1601.Init;
        DCP_ripemd1601.UpdateStr(S);
        DCP_ripemd1601.Final(HashDigest);
        len:=DCP_ripemd1601.HashSize;
      end;
    4:
      begin
        DCP_SHA11.Init ;
        DCP_SHA11.UpdateStr(S);
        DCP_SHA11.Final(HashDigest);
        len:=DCP_SHA11.HashSize;
      end;
  end;
  s:='';
  for Read:= 0 to ((len div 8)-1) do
  s:= s + IntToHex(HashDigest[Read],2);
  edit1.Text:= s; }
end;

procedure TForm1.Button4Click(Sender: TObject);
 var
 i :integer;
 //    Source, Dest: string;
//    Cipher: TDCP_blowfish;
  Dest: string;
  begin
  Memo1.Lines.Clear;
  for i:=0 to Memo2.Lines.Count-1 do
  begin

    case ComboBox1.ItemIndex of
      0:
        begin
          DCP_blowfish1.InitStr(edit3.text);
          DCP_blowfish1.Reset;
          Memo1.Lines.Add(DCP_blowfish1.DecryptString(Memo2.Lines.Strings[i]));
          DCP_blowfish1.Reset;
        end;
      1:
        begin
          DCP_cast1281.InitStr(edit3.text);
          DCP_cast1281.Reset;
          Memo1.Lines.Add(DCP_cast1281.DecryptString(Memo2.Lines.Strings[i]));
          DCP_cast1281.Reset;
        end;
      2:
        begin
          DCP_cast2561.InitStr(edit3.text);
          DCP_cast2561.Reset;
          Memo1.Lines.Add(DCP_cast2561.DecryptString(Memo2.Lines.Strings[i]));
          DCP_cast2561.Reset;
        end;
      3:
        begin
          DCP_des1.InitStr(edit3.text);
          DCP_des1.Reset;
          Dest:=DCP_des1.DecryptString(Memo2.Lines.Strings[i]);
          DCP_des1.Reset;
          Memo1.Lines.Add(Dest);

        end;
      4:
        begin
          DCP_3des1.InitStr(edit3.text);
          DCP_3des1.Reset;
          Memo1.Lines.Add(DCP_3des1.DecryptString(Memo2.Lines.Strings[i]));
          DCP_3des1.Reset;
        end;
      5:
        begin
          DCP_gost1.InitStr(edit3.text);
          DCP_gost1.Reset;
          Memo1.Lines.Add(DCP_gost1.DecryptString(Memo2.Lines.Strings[i]));
          DCP_gost1.Reset;
        end;
      6:
        begin
          DCP_ice1.InitStr(edit3.text);
          DCP_ice1.Reset;
          Memo1.Lines.Add(DCP_ice1.DecryptString(Memo2.Lines.Strings[i]));
          DCP_ice1.Reset;
        end;
      7:
        begin
          DCP_ice21.InitStr(edit3.text);
          DCP_ice21.Reset;
          Memo1.Lines.Add(DCP_ice21.DecryptString(Memo2.Lines.Strings[i]));
          DCP_ice21.Reset;
        end;
      8:
        begin
          DCP_idea1.InitStr(edit3.text);
          DCP_idea1.Reset;
          Memo1.Lines.Add(DCP_idea1.DecryptString(Memo2.Lines.Strings[i]));
          DCP_idea1.Reset;
        end;
      9:
        begin
          DCP_mars1.InitStr(edit3.text);
          DCP_mars1.Reset;
          Memo1.Lines.Add(DCP_mars1.DecryptString(Memo2.Lines.Strings[i]));
          DCP_mars1.Reset;
        end;
      10:
        begin
          DCP_misty11.InitStr(edit3.text);
          DCP_misty11.Reset;
          Memo1.Lines.Add(DCP_misty11.DecryptString(Memo2.Lines.Strings[i]));
          DCP_misty11.Reset;
        end;
      11:
        begin
          DCP_rc21.InitStr(edit3.text);
          DCP_rc21.Reset;
          Memo1.Lines.Add(DCP_rc21.DecryptString(Memo2.Lines.Strings[i]));
          DCP_rc21.Reset;
        end;
      12:
        begin
          DCP_rc41.InitStr(edit3.text);
          DCP_rc41.Reset;
          Memo1.Lines.Add(DCP_rc41.DecryptString(Memo2.Lines.Strings[i]));
          DCP_rc41.Reset;
        end;
      13:
        begin
          DCP_rc51.InitStr(edit3.text);
          DCP_rc51.Reset;
          Memo1.Lines.Add(DCP_rc51.DecryptString(Memo2.Lines.Strings[i]));
          DCP_rc51.Reset;
        end;
      14:
        begin
          DCP_rc61.InitStr(edit3.text);
          DCP_rc61.Reset;
          Memo1.Lines.Add(DCP_rc61.DecryptString(Memo2.Lines.Strings[i]));
          DCP_rc61.Reset;
        end;
      15:
        begin
          DCP_rijndael1.InitStr(edit3.text);
          DCP_rijndael1.Reset;
          Memo1.Lines.Add(DCP_rijndael1.DecryptString(Memo2.Lines.Strings[i]));
          DCP_rijndael1.Reset;
        end;
      16:
        begin
          DCP_thinice1.InitStr(edit3.text);
          DCP_thinice1.Reset;
          Memo1.Lines.Add(DCP_thinice1.DecryptString(Memo2.Lines.Strings[i]));
          DCP_thinice1.Reset;
        end;
      17:
        begin
          DCP_twofish1.InitStr(edit3.text);
          DCP_twofish1.Reset;
          Memo1.Lines.Add(DCP_twofish1.DecryptString(Memo2.Lines.Strings[i]));
          DCP_twofish1.Reset;
          //edit2.text:= DCP_twofish1.DecryptString(edit1.text);
        end;

     end;
    end;
//  end;
//DCP_blowfish1.Burn;
//    DCP_blowfish1.Free;
end;
function Sc_PassWord(Ws:integer;fh,sz,dx,xx:boolean):string;
var
  i:integer;
  templist,templist1,templist2,templist3,templist4:tstringlist;
begin
  templist:=tstringlist.Create;
  templist1:=tstringlist.Create;
  templist2:=tstringlist.Create;
  templist3:=tstringlist.Create;
  templist4:=tstringlist.Create;
  for i:=33 to 47 do templist1.Add(chr(i));  //·ûºÅ
  for i:=48 to 57 do templist2.Add(chr(i));  //Êý×Ö
  for i:=58 to 64 do templist1.Add(chr(i));  //·ûºÅ
  for i:=65 to 90 do templist3.Add(chr(i));  //´óÐ´×ÖÄ¸
  for i:=91 to 96 do templist1.Add(chr(i));  //·ûºÅ
  for i:=97 to 122 do templist4.Add(chr(i));  //Ð¡Ð´×ÖÄ¸
  for i:=123 to 126 do templist1.Add(chr(i));  //·ûºÅ
  if fh then templist.Text:=templist.Text+templist1.Text;
  if sz then templist.Text:=templist.Text+templist2.Text;
  if dx then templist.Text:=templist.Text+templist3.Text;
  if xx then templist.Text:=templist.Text+templist4.Text;
  if templist.Count=0 then
    begin
      result:='';
      exit;
    end;
  randomize;
  result:='';
  while length(result)<ws do
    begin
      i:=0;
      i:=random(templist.Count);
      result:=result+templist[i];
    end;
end;
//==============================================================================
//==============================================================================


procedure TForm1.Button5Click(Sender: TObject);
begin
 Edit3.Text:=  sc_password(RzSpinner1.Value,true,true,true,true);
end;

end.

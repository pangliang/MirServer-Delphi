unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Menus;

type
  TFrmMain = class(TForm)
    Memo1: TMemo;
    Memo2: TMemo;
    Button1: TButton;
    Button2: TButton;
    Edit1: TEdit;
    Button3: TButton;
    Button4: TButton;
    OpenDialog1: TOpenDialog;
    PopupMenu1: TPopupMenu;
    PopupMenu2: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    Label1: TLabel;
    EditEncodeStr: TEdit;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmMain: TFrmMain;

implementation
uses DESTR, EncryptUnit;
{$R *.dfm}

procedure TFrmMain.Button1Click(Sender: TObject);
begin
  if OpenDialog1.Execute then begin
    Memo2.Lines.Clear;
    Memo2.Lines.LoadFromFile(OpenDialog1.FileName);
  end;
end;

procedure TFrmMain.Button2Click(Sender: TObject);
begin
  if OpenDialog1.Execute then begin
    Memo1.Lines.Clear;
    Memo1.Lines.LoadFromFile(OpenDialog1.FileName);
  end;
end;

function DeCodeScript(sText, sKey: string): string;
begin
  try
    Result := DecodeString_3des(DecryStrHex(sText, sKey), sKey);
  except
    Result := '';
  end;
end;

function EnCodeScript(sText, sKey: string): string;
begin
  Result := EncryStrHex(EncodeString_3des(sText, sKey), sKey);
end;

procedure TFrmMain.Button3Click(Sender: TObject);
var
  i: integer;
  sLineText, sKey: string;
  FirstStr: string;
begin
  FirstStr := EditEncodeStr.Text;
  if Edit1.Text = '' then begin
    Application.MessageBox('请输入密码！   ', '提示信息', MB_ICONASTERISK);
    Exit;
  end;
  if FirstStr = '' then begin
    Application.MessageBox('请输入加密标识！   ', '提示信息', MB_ICONASTERISK);
    Exit;
  end;
  Memo2.Lines.Clear;
  Memo2.Lines.Add(FirstStr);
  sKey := Edit1.Text;
  for i := 0 to Memo1.Lines.Count - 1 do begin
    Application.ProcessMessages;
    sLineText := Memo1.Lines.Strings[i];
    if sLineText <> '' then begin
      sLineText := EnCodeScript(sLineText, sKey);
      Memo2.Lines.Add(sLineText);
    end else begin
      Memo2.Lines.Add(sLineText);
    end;
  end;
end;

procedure TFrmMain.Button4Click(Sender: TObject);
var
  i: integer;
  sLineText, str: string;
  sKey: string;
begin
  if Edit1.Text = '' then begin
    Application.MessageBox('请输入密码！！！', '提示信息', MB_ICONASTERISK);
    Exit
  end;
  str := Memo2.Lines.Strings[0];
  if str[1] <> ';' then begin
    Application.MessageBox('请选择加密脚本！！！', '提示信息', MB_ICONASTERISK);
    Exit
  end;
  Memo1.Lines.Clear;
  sKey := Edit1.Text;
  try
    for i := 1 to Memo2.Lines.Count - 1 do begin
      Application.ProcessMessages;
      sLineText := Trim(Memo2.Lines.Strings[i]);
      if sLineText <> '' then begin
        sLineText := DeCodeScript(sLineText, sKey);
        Memo1.Lines.Add(sLineText);
      end else begin
        Memo1.Lines.Add(sLineText);
      end;
    end;
  except
    Application.MessageBox('解密失败！   ', '提示信息', MB_ICONHAND);
  end;
end;

procedure TFrmMain.N2Click(Sender: TObject);
begin
  if OpenDialog1.Execute then
    Memo1.Lines.SaveToFile(OpenDialog1.FileName);
end;

procedure TFrmMain.N1Click(Sender: TObject);
begin
  Memo1.Lines.Clear;
end;

procedure TFrmMain.N4Click(Sender: TObject);
begin
  if OpenDialog1.Execute then
    Memo2.Lines.SaveToFile(OpenDialog1.FileName);
end;

procedure TFrmMain.N3Click(Sender: TObject);
begin
  Memo2.Lines.Clear;
end;

end.


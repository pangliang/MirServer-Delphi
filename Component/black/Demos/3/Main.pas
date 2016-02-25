unit Main;

interface

uses
  Windows, Messages, SysUtils, {Variants,} Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, MSI_DMA;

type
  TForm2 = class(TForm)
    bShow: TButton;
    Memo: TMemo;
    Bevel1: TBevel;
    bClose: TButton;
    pTitle: TPanel;
    Image1: TImage;
    LabelAddress: TLabel;
    LabelLength: TLabel;
    EditAddress: TEdit;
    EditLength: TEdit;
    bSave: TButton;
    sd: TSaveDialog;
    procedure bShowClick(Sender: TObject);
    procedure bSaveClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bCloseClick(Sender: TObject);
  private
    DMA: TDMA;
  public
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

procedure TForm2.bShowClick(Sender: TObject);

function GetChar(Value: Char): Char;
begin
  if Value<' ' then
    Result:='.'
  else
    Result:=Value;
end;

var
  Address, Line, Row: DWORD;
  Size, LineCount: Integer;
  LineStr: String;
begin
  with DMA do
    try
      Screen.Cursor:=crHourGlass;
      Memo.Lines.Clear;
      Memo.Lines.BeginUpdate;
      Size:=StrToInt(EditLength.Text);
      Address:=StrToInt(EditAddress.Text);
      MapMemory(Address,Size);
      LineCount:=Size div 16;
      if Size mod 16 > 0 then
        Inc(LineCount);
      for Line:=0 to LineCount-1 do begin
        LineStr:=IntToHex(Address+Line*16,8)+': ';
        for Row:=0 to 15 do
          LineStr:=LineStr+IntToHex(Byte(Memory[Line*16+Row]),2)+' ';
        LineStr:=LineStr+' ';
        for Row:=0 to 15 do
          LineStr:=LineStr+GetChar(Memory[Line*16+Row]);
        Memo.Lines.Add(LineStr);
      end;
      bSave.Enabled:=True;
    finally
      Memo.Lines.EndUpdate;
      Screen.Cursor:=crDefault;
    end;
end;

procedure TForm2.bSaveClick(Sender: TObject);
begin
  sd.FileName:=Format('%8.8x-%8.8x.dmp',[DMA.StartAddress,DMA.StartAddress+DMA.MemorySize-1]);
  if sd.Execute then begin
    DMA.SaveToFile(sd.Filename);
  end;
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  DMA:=TDMA.Create;
end;

procedure TForm2.bCloseClick(Sender: TObject);
begin
  Close;
end;

end.

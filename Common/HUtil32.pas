unit HUtil32;

//============================================
// Latest Update date : 1998 1
// Add/Update Function and procedure :
// 		CaptureString
//       Str_PCopy          	(4/29)
//			Str_PCopyEx			 	(5/2)
//			memset					(6/3)
//       SpliteBitmap         (9/3)
//       ArrestString         (10/27)  {name changed}
//       IsStringNumber       (98'1/1)
//			GetDirList				(98'12/9)
//       GetFileDate          (98'12/9)
//       CatchString          (99'2/4)
//       DivString            (99'2/4)
//       DivTailString        (99'2/4)
//       SPos                 (99'2/9)
//============================================


interface

uses
  Classes, SysUtils, StrUtils, WinTypes, WinProcs, Graphics, Messages, Dialogs;

type
  Str4096 = array[0..4096] of Char;
  Str256 = array[0..256] of Char;
  TyNameTable = record
    Name: string;
    varl: LongInt;
  end;

  TLRect = record
    Left, Top, Right, Bottom: LongInt;
  end;

const
  MAXDEFCOLOR = 16;
  ColorNames: array[1..MAXDEFCOLOR] of TyNameTable = (
    (Name: 'BLACK'; varl: clBlack),
    (Name: 'BROWN'; varl: clMaroon),
    (Name: 'MARGENTA'; varl: clFuchsia),
    (Name: 'GREEN'; varl: clGreen),
    (Name: 'LTGREEN'; varl: clOlive),
    (Name: 'BLUE'; varl: clNavy),
    (Name: 'LTBLUE'; varl: clBlue),
    (Name: 'PURPLE'; varl: clPurple),
    (Name: 'CYAN'; varl: clTeal),
    (Name: 'LTCYAN'; varl: clAqua),
    (Name: 'GRAY'; varl: clGray),
    (Name: 'LTGRAY'; varl: clsilver),
    (Name: 'YELLOW'; varl: clYellow),
    (Name: 'LIME'; varl: clLime),
    (Name: 'WHITE'; varl: clWhite),
    (Name: 'RED'; varl: clRed)
    );

  MAXLISTMARKER = 3;
  LiMarkerNames: array[1..MAXLISTMARKER] of TyNameTable = (
    (Name: 'DISC'; varl: 0),
    (Name: 'CIRCLE'; varl: 1),
    (Name: 'SQUARE'; varl: 2)
    );

  MAXPREDEFINE = 3;
  PreDefineNames: array[1..MAXPREDEFINE] of TyNameTable = (
    (Name: 'LEFT'; varl: 0),
    (Name: 'RIGHT'; varl: 1),
    (Name: 'CENTER'; varl: 2)
    );




function CountGarbage(paper: TCanvas; Src: PChar; TargWidth: LongInt): Integer; {garbage}
{[ArrestString]
      Result = Remain string,
      RsltStr = captured string
}
function ArrestString(Source, SearchAfter, ArrestBefore: string;
  const DropTags: array of string; var RsltStr: string): string;
{*}
function ArrestStringEx(Source, SearchAfter, ArrestBefore: string; var ArrestStr: string): string;
function CaptureString(Source: string; var rdstr: string): string;
procedure ClearWindow(aCanvas: TCanvas; aLeft, aTop, aRight, aBottom: LongInt; aColor: TColor);
function CombineDirFile(SrcDir, TargName: string): string;
{*}
function CompareLStr(Src, targ: string; compn: Integer): Boolean;
function CompareBackLStr(Src, targ: string; compn: Integer): Boolean;
function CompareBuffer(p1, p2: PByte; len: Integer): Boolean;
function CreateMask(Src: PChar; TargPos: Integer): string;
procedure DrawTileImage(Canv: TCanvas; Rect: TRect; TileImage: TBitmap);
procedure DrawingGhost(Rc: TRect);
function ExtractFileNameOnly(const fname: string): string;
function FloatToString(F: real): string;
function FloatToStrFixFmt(fVal: Double; prec, digit: Integer): string;
function FileSize(const fname: string): LongInt;
{*}
function FileCopy(Source, Dest: string): Boolean;
function FileCopyEx(Source, Dest: string): Boolean;
function GetSpaceCount(Str: string): LongInt;
function RemoveSpace(Str: string): string;
function GetFirstWord(Str: string; var sWord: string; var FrontSpace: LongInt): string;
function GetDefColorByName(Str: string): TColor;
function GetULMarkerType(Str: string): LongInt;
{*}
function GetValidStr3(Str: string; var Dest: string; const Divider: array of Char): string;
function GetValidStr4(Str: string; var Dest: string; const Divider: array of Char): string;
function GetValidStrVal(Str: string; var Dest: string; const Divider: array of Char): string;
function GetValidStrCap(Str: string; var Dest: string; const Divider: array of Char): string;
function GetStrToCoords(Str: string): TRect;
function GetDefines(Str: string): LongInt;
function GetValueFromMask(Src: PChar; Mask: string): string;
procedure GetDirList(path: string; fllist: TStringList);
function GetFileDate(FileName: string): Integer; //DOS format file date..
function HexToIntEx(shap_str: string): LongInt;
function HexToInt(Str: string): LongInt;
function IntToStr2(n: Integer): string;
function IntToStrFill(num, len: Integer; fill: Char): string;
function IsInB(Src: string; Pos: Integer; targ: string): Boolean;
function IsInRect(x, y: Integer; Rect: TRect): Boolean;
function IsEnglish(Ch: Char): Boolean;
function IsEngNumeric(Ch: Char): Boolean;
function IsFloatNumeric(Str: string): Boolean;
function IsUniformStr(Src: string; Ch: Char): Boolean;
function IsStringNumber(Str: string): Boolean;
function KillFirstSpace(var Str: string): LongInt;
procedure KillGabageSpace(var Str: string);
function LRect(l, t, r, b: LongInt): TLRect;
procedure MemPCopy(Dest: PChar; Src: string);
procedure MemCpy(Dest, Src: PChar; Count: LongInt); {PChar type}
procedure memcpy2(TargAddr, SrcAddr: LongInt; Count: Integer); {Longint type}
procedure memset(Buffer: PChar; FillChar: Char; Count: Integer);
procedure PCharSet(P: PChar; n: Integer; Ch: Char);
function ReplaceChar(Src: string; srcchr, repchr: Char): string;
function Str_ToDate(Str: string): TDateTime;
function Str_ToTime(Str: string): TDateTime;
function Str_ToInt(Str: string; Def: LongInt): LongInt;
function Str_ToFloat(Str: string): real;
function SkipStr(Src: string; const Skips: array of Char): string;
procedure ShlStr(Source: PChar; Count: Integer);
procedure ShrStr(Source: PChar; Count: Integer);
procedure Str256PCopy(Dest: PChar; const Src: string);
function _StrPas(Dest: PChar): string;
function Str_PCopy(Dest: PChar; Src: string): Integer;
function Str_PCopyEx(Dest: PChar; const Src: string; buflen: LongInt): Integer;
procedure SpliteBitmap(DC: hdc; x, y: Integer; bitmap: TBitmap; transcolor: TColor);
procedure TiledImage(Canv: TCanvas; Rect: TLRect; TileImage: TBitmap);
function Trim_R(const Str: string): string;
function IsEqualFont(SrcFont, TarFont: TFont): Boolean;
function CutHalfCode(Str: string): string;
function ConvertToShortName(Canvas: TCanvas; Source: string; WantWidth: Integer): string;
{*}
function CatchString(Source: string; cap: Char; var catched: string): string;
function DivString(Source: string; cap: Char; var sel: string): string;
function DivTailString(Source: string; cap: Char; var sel: string): string;
function SPos(substr, Str: string): Integer;
function NumCopy(Str: string): Integer;
function GetMonDay: string;
function BoolToStr(boo: Boolean): string;

function TagCount(Source: string; Tag: Char): Integer;

function _MIN(n1, n2: Integer): Integer;
function _MAX(n1, n2: Integer): Integer;
function IsIPaddr(IP: string): Boolean;
function IntToSex(btSex: Byte): string;
function IntToJob(btJob: Byte): string;
function GetCodeMsgSize(x: Double): Integer;
function GetDayCount(MaxDate, MinDate: TDateTime): Integer;
function BoolToIntStr(boBoolean: Boolean): string;
function BoolToCStr(boBoolean: Boolean): string;
function BooleanToStr(boo: Boolean): string;

function MakeHumanFeature(btRaceImg, btDress, btWeapon, btHair: Byte): Integer;
function MakeMonsterFeature(btRaceImg, btWeapon: Byte; wAppr: Word): Integer;

function IsVarNumber(Str: string): Boolean;

procedure DisPoseAndNil(var Obj);
implementation

//var
//	CSUtilLock: TRTLCriticalSection;

{ capture "double quote streams" }
function MakeHumanFeature(btRaceImg, btDress, btWeapon, btHair: Byte): Integer;
begin
  Result := MakeLong(MakeWord(btRaceImg, btWeapon), MakeWord(btHair, btDress));
end;

function MakeMonsterFeature(btRaceImg, btWeapon: Byte; wAppr: Word): Integer;
begin
  Result := MakeLong(MakeWord(btRaceImg, btWeapon), wAppr);
end;

function BoolToIntStr(boBoolean: Boolean): string;
begin
  Result := IntToStr(Integer(boBoolean));
end;

function BoolToCStr(boBoolean: Boolean): string;
begin

end;

function GetDayCount(MaxDate, MinDate: TDateTime): Integer;
var
  Day: LongInt;
begin
  Day := Trunc(MaxDate) - Trunc(MinDate);
  if Day > 0 then Result := Day else Result := 0;
end;

function GetCodeMsgSize(x: Double): Integer;
begin
  if INT(x) < x then Result := Trunc(x) + 1
  else Result := Trunc(x)
end;

function IntToSex(btSex: Byte): string;
begin
  case btSex of
    0: Result := 'ÄÐ';
    1: Result := 'Å®';
    else Result := 'Î´Öª';
  end;
end;

function IntToJob(btJob: Byte): string;
begin
  case btJob of
    0: Result := 'Õ½Ê¿';
    1: Result := '·¨Ê¦';
    2: Result := 'µÀÊ¿';
    else Result := 'Î´Öª';
  end;
end;

function IsIPaddr(IP: string): Boolean;
var
  Node: array[0..3] of Integer;
  tIP: string;
  tNode: string;
  tPos: Integer;
  tLen: Integer;
begin
  Result := False;
  tIP := IP;
  tLen := Length(tIP);
  tPos := Pos('.', tIP);
  tNode := MidStr(tIP, 1, tPos - 1);
  tIP := MidStr(tIP, tPos + 1, tLen - tPos);
  if not TryStrToInt(tNode, Node[0]) then Exit;

  tLen := Length(tIP);
  tPos := Pos('.', tIP);
  tNode := MidStr(tIP, 1, tPos - 1);
  tIP := MidStr(tIP, tPos + 1, tLen - tPos);
  if not TryStrToInt(tNode, Node[1]) then Exit;

  tLen := Length(tIP);
  tPos := Pos('.', tIP);
  tNode := MidStr(tIP, 1, tPos - 1);
  tIP := MidStr(tIP, tPos + 1, tLen - tPos);
  if not TryStrToInt(tNode, Node[2]) then Exit;

  if not TryStrToInt(tIP, Node[3]) then Exit;
  for tLen := Low(Node) to High(Node) do begin
    if (Node[tLen] < 0) or (Node[tLen] > 255) then Exit;
  end;
  Result := True;
end;

function CaptureString(Source: string; var rdstr: string): string;
var
  st, et, c, len, i: Integer;
begin
  if Source = '' then begin
    rdstr := ''; Result := '';
    Exit;
  end;
  c := 1;
  //et := 0;
  len := Length(Source);
  while Source[c] = ' ' do
    if c < len then Inc(c)
    else break;

  if (Source[c] = '"') and (c < len) then begin

    st := c + 1;
    et := len;
    for i := c + 1 to len do
      if Source[i] = '"' then begin
        et := i - 1;
        break;
      end;

  end else begin
    st := c;
    et := len;
    for i := c to len do
      if Source[i] = ' ' then begin
        et := i - 1;
        break;
      end;

  end;

  rdstr := Copy(Source, st, (et - st + 1));
  if len >= (et + 2) then
    Result := Copy(Source, et + 2, len - (et + 1)) else
    Result := '';

end;


function CountUglyWhiteChar(sPtr: PChar): LongInt;
var
  Cnt, Killw: LongInt;
begin
  Killw := 0;
  for Cnt := (StrLen(sPtr) - 1) downto 0 do begin
    if sPtr[Cnt] = ' ' then begin
      Inc(Killw);
      {sPtr[Cnt] := #0;}
    end else break;
  end;
  Result := Killw;
end;


function CountGarbage(paper: TCanvas; Src: PChar; TargWidth: LongInt): Integer; {garbage}
var
  gab, destWidth: Integer;
begin

  gab := CountUglyWhiteChar(Src);
  destWidth := paper.TextWidth(StrPas(Src)) - gab;
  Result := TargWidth - destWidth + (gab * paper.TextWidth(' '));

end;


function GetSpaceCount(Str: string): LongInt;
var
  Cnt, len, SpaceCount: LongInt;
begin
  SpaceCount := 0;
  len := Length(Str);
  for Cnt := 1 to len do
    if Str[Cnt] = ' ' then SpaceCount := SpaceCount + 1;
  Result := SpaceCount;
end;

function RemoveSpace(Str: string): string;
var
  i: Integer;
begin
  Result := '';
  for i := 1 to Length(Str) do
    if Str[i] <> ' ' then
      Result := Result + Str[i];
end;

function KillFirstSpace(var Str: string): LongInt;
var
  Cnt, len: LongInt;
begin
  Result := 0;
  len := Length(Str);
  for Cnt := 1 to len do
    if Str[Cnt] <> ' ' then begin
      Str := Copy(Str, Cnt, len - Cnt + 1);
      Result := Cnt - 1;
      break;
    end;
end;

procedure KillGabageSpace(var Str: string);
var
  Cnt, len: LongInt;
begin
  len := Length(Str);
  for Cnt := len downto 1 do
    if Str[Cnt] <> ' ' then begin
      Str := Copy(Str, 1, Cnt);
      KillFirstSpace(Str);
      break;
    end;
end;

function GetFirstWord(Str: string; var sWord: string; var FrontSpace: LongInt): string;
var
  Cnt, len, n: LongInt;
  DestBuf: Str4096;
begin
  len := Length(Str);
  if len <= 0 then
    Result := ''
  else begin
    FrontSpace := 0;
    for Cnt := 1 to len do begin
      if Str[Cnt] = ' ' then Inc(FrontSpace)
      else break;
    end;
    n := 0;
    for Cnt := Cnt to len do begin
      if Str[Cnt] <> ' ' then
        DestBuf[n] := Str[Cnt]
      else begin
        DestBuf[n] := #0;
        sWord := StrPas(DestBuf);
        Result := Copy(Str, Cnt, len - Cnt + 1);
        Exit;
      end;
      Inc(n);
    end;
    DestBuf[n] := #0;
    sWord := StrPas(DestBuf);
    Result := '';
  end;
end;

function HexToIntEx(shap_str: string): LongInt;
begin
  Result := HexToInt(Copy(shap_str, 2, Length(shap_str) - 1));
end;

function HexToInt(Str: string): LongInt;
var
  digit: Char;
  Count, i: Integer;
  Cur, val: LongInt;
begin
  val := 0;
  Count := Length(Str);
  for i := 1 to Count do begin
    digit := Str[i];
    if (digit >= '0') and (digit <= '9') then Cur := Ord(digit) - Ord('0')
    else if (digit >= 'A') and (digit <= 'F') then Cur := Ord(digit) - Ord('A') + 10
    else if (digit >= 'a') and (digit <= 'f') then Cur := Ord(digit) - Ord('a') + 10
    else Cur := 0;
    val := val + (Cur shl (4 * (Count - i)));
  end;
  Result := val;
  //   Result := (Val and $0000FF00) or ((Val shl 16) and $00FF0000) or ((Val shr 16) and $000000FF);
end;

function Str_ToInt(Str: string; Def: LongInt): LongInt;
begin
  Result := Def;
  if Str <> '' then begin
    if ((Word(Str[1]) >= Word('0')) and (Word(Str[1]) <= Word('9'))) or
      (Str[1] = '+') or (Str[1] = '-') then try
      Result := StrToInt64(Str);
    except
    end;
  end;
end;

function Str_ToDate(Str: string): TDateTime;
begin
  if Trim(Str) = '' then Result := Date
  else
    Result := StrToDate(Str);
end;

function Str_ToTime(Str: string): TDateTime;
begin
  if Trim(Str) = '' then Result := Time
  else
    Result := StrToTime(Str);
end;

function Str_ToFloat(Str: string): real;
begin
  if Str <> '' then try
    Result := StrToFloat(Str);
    Exit;
  except
  end;
  Result := 0;
end;

procedure DrawingGhost(Rc: TRect);
var
  DC: hdc;
begin
  DC := GetDC(0);
  DrawFocusRect(DC, Rc);
  ReleaseDC(0, DC);
end;

function ExtractFileNameOnly(const fname: string): string;
var
  extpos: Integer;
  ext, fn: string;
begin
  ext := ExtractFileExt(fname);
  fn := ExtractFileName(fname);
  if ext <> '' then begin
    extpos := Pos(ext, fn);
    Result := Copy(fn, 1, extpos - 1);
  end else
    Result := fn;
end;

function FloatToString(F: real): string;
begin
  Result := FloatToStrFixFmt(F, 5, 2);
end;

function FloatToStrFixFmt(fVal: Double; prec, digit: Integer): string;
var
  Cnt, Dest, len, i, J: Integer;
  fstr: string;
  Buf: array[0..255] of Char;
label end_conv;
begin
  Cnt := 0; Dest := 0;
  fstr := FloatToStrF(fVal, ffGeneral, 15, 3);
  len := Length(fstr);
  for i := 1 to len do begin
    if fstr[i] = '.' then begin
      Buf[Dest] := '.'; Inc(Dest);
      Cnt := 0;
      for J := i + 1 to len do begin
        if Cnt < digit then begin
          Buf[Dest] := fstr[J]; Inc(Dest);
        end
        else begin
          goto end_conv;
        end;
        Inc(Cnt);
      end;
      goto end_conv;
    end;
    if Cnt < prec then begin
      Buf[Dest] := fstr[i]; Inc(Dest);
    end;
    Inc(Cnt);
  end;
  end_conv:
  Buf[Dest] := Char(0);
  Result := StrPas(Buf);
end;


function FileSize(const fname: string): LongInt;
var
  SearchRec: TSearchRec;
begin
  if FindFirst(ExpandFileName(fname), faAnyFile, SearchRec) = 0 then
    Result := SearchRec.Size
  else Result := -1;
end;


function FileCopy(Source, Dest: string): Boolean;
var
  fSrc, fDst, len: Integer;
  Size: LongInt;
  Buffer: packed array[0..2047] of Byte;
begin
  Result := False; { Assume that it WONT work }
  if Source <> Dest then begin
    fSrc := FileOpen(Source, fmOpenRead);
    if fSrc >= 0 then begin
      Size := FileSeek(fSrc, 0, 2);
      FileSeek(fSrc, 0, 0);
      fDst := FileCreate(Dest);
      if fDst >= 0 then begin
        while Size > 0 do begin
          len := FileRead(fSrc, Buffer, SizeOf(Buffer));
          FileWrite(fDst, Buffer, len);
          Size := Size - len;
        end;
        FileSetDate(fDst, FileGetDate(fSrc));
        FileClose(fDst);
        FileSetAttr(Dest, FileGetAttr(Source));
        Result := True;
      end;
      FileClose(fSrc);
    end;
  end;
end;

function FileCopyEx(Source, Dest: string): Boolean;
var
  fSrc, fDst, len: Integer;
  Size: LongInt;
  Buffer: array[0..512000] of Byte;
begin
  Result := False; { Assume that it WONT work }
  if Source <> Dest then begin
    fSrc := FileOpen(Source, fmOpenRead or fmShareDenyNone);
    if fSrc >= 0 then begin
      Size := FileSeek(fSrc, 0, 2);
      FileSeek(fSrc, 0, 0);
      fDst := FileCreate(Dest);
      if fDst >= 0 then begin
        while Size > 0 do begin
          len := FileRead(fSrc, Buffer, SizeOf(Buffer));
          FileWrite(fDst, Buffer, len);
          Size := Size - len;
        end;
        FileSetDate(fDst, FileGetDate(fSrc));
        FileClose(fDst);
        FileSetAttr(Dest, FileGetAttr(Source));
        Result := True;
      end;
      FileClose(fSrc);
    end;
  end;
end;


function GetDefColorByName(Str: string): TColor;
var
  Cnt: Integer;
  COmpStr: string;
begin
  COmpStr := UpperCase(Str);
  for Cnt := 1 to MAXDEFCOLOR do begin
    if COmpStr = ColorNames[Cnt].Name then begin
      Result := TColor(ColorNames[Cnt].varl);
      Exit;
    end;
  end;
  Result := $0;
end;

function GetULMarkerType(Str: string): LongInt;
var
  Cnt: Integer;
  COmpStr: string;
begin
  COmpStr := UpperCase(Str);
  for Cnt := 1 to MAXLISTMARKER do begin
    if COmpStr = LiMarkerNames[Cnt].Name then begin
      Result := LiMarkerNames[Cnt].varl;
      Exit;
    end;
  end;
  Result := 1;
end;

function GetDefines(Str: string): LongInt;
var
  Cnt: Integer;
  COmpStr: string;
begin
  COmpStr := UpperCase(Str);
  for Cnt := 1 to MAXPREDEFINE do begin
    if COmpStr = PreDefineNames[Cnt].Name then begin
      Result := PreDefineNames[Cnt].varl;
      Exit;
    end;
  end;
  Result := -1;
end;

procedure ClearWindow(aCanvas: TCanvas; aLeft, aTop, aRight, aBottom: LongInt; aColor: TColor);
begin
  with aCanvas do begin
    Brush.Color := aColor;
    Pen.Color := aColor;
    Rectangle(0, 0, aRight - aLeft, aBottom - aTop);
  end;
end;


procedure DrawTileImage(Canv: TCanvas; Rect: TRect; TileImage: TBitmap);
var
  i, J, ICnt, JCnt, BmWidth, BmHeight: Integer;
begin

  BmWidth := TileImage.Width;
  BmHeight := TileImage.Height;
  ICnt := ((Rect.Right - Rect.Left) + BmWidth - 1) div BmWidth;
  JCnt := ((Rect.Bottom - Rect.Top) + BmHeight - 1) div BmHeight;

  UnrealizeObject(Canv.Handle);
  SelectPalette(Canv.Handle, TileImage.Palette, False);
  RealizePalette(Canv.Handle);

  for J := 0 to JCnt do begin
    for i := 0 to ICnt do begin

      { if (I * BmWidth) < (Rect.Right-Rect.Left) then
         BmWidth := TileImage.Width else
          BmWidth := (Rect.Right - Rect.Left) - ((I-1) * BmWidth);

       if (
       BmWidth := TileImage.Width;
       BmHeight := TileImage.Height;  }

      BitBlt(Canv.Handle,
        Rect.Left + i * BmWidth,
        Rect.Top + (J * BmHeight),
        BmWidth,
        BmHeight,
        TileImage.Canvas.Handle,
        0,
        0,
        SRCCOPY);

    end;
  end;

end;


procedure TiledImage(Canv: TCanvas; Rect: TLRect; TileImage: TBitmap);
var
  i, J, ICnt, JCnt, BmWidth, BmHeight: Integer;
  Rleft, RTop, RWidth, RHeight, BLeft, BTop: LongInt;
begin

  if Assigned(TileImage) then
    if TileImage.Handle <> 0 then begin

      BmWidth := TileImage.Width;
      BmHeight := TileImage.Height;
      ICnt := (Rect.Right + BmWidth - 1) div BmWidth - (Rect.Left div BmWidth);
      JCnt := (Rect.Bottom + BmHeight - 1) div BmHeight - (Rect.Top div BmHeight);

      UnrealizeObject(Canv.Handle);
      SelectPalette(Canv.Handle, TileImage.Palette, False);
      RealizePalette(Canv.Handle);

      for J := 0 to JCnt do begin
        for i := 0 to ICnt do begin

          if i = 0 then begin
            BLeft := Rect.Left - ((Rect.Left div BmWidth) * BmWidth);
            Rleft := Rect.Left;
            RWidth := BmWidth;
          end else begin
            if i = ICnt then
              RWidth := Rect.Right - ((Rect.Right div BmWidth) * BmWidth) else
              RWidth := BmWidth;
            BLeft := 0;
            Rleft := (Rect.Left div BmWidth) + (i * BmWidth);
          end;


          if J = 0 then begin
            BTop := Rect.Top - ((Rect.Top div BmHeight) * BmHeight);
            RTop := Rect.Top;
            RHeight := BmHeight;
          end else begin
            if J = JCnt then
              RHeight := Rect.Bottom - ((Rect.Bottom div BmHeight) * BmHeight) else
              RHeight := BmHeight;
            BTop := 0;
            RTop := (Rect.Top div BmHeight) + (J * BmHeight);
          end;

          BitBlt(Canv.Handle,
            Rleft,
            RTop,
            RWidth,
            RHeight,
            TileImage.Canvas.Handle,
            BLeft,
            BTop,
            SRCCOPY);

        end;
      end;

    end;
end;


function GetValidStr3(Str: string; var Dest: string; const Divider: array of Char): string;
const
  BUF_SIZE = 20480; //$7FFF;
var
  Buf: array[0..BUF_SIZE] of Char;
  BufCount, Count, SrcLen, i, ArrCount: LongInt;
  Ch: Char;
label
  CATCH_DIV;
begin
  Ch := #0; //Jacky
  try
    SrcLen := Length(Str);
    BufCount := 0;
    Count := 1;

    if SrcLen >= BUF_SIZE - 1 then begin
      Result := '';
      Dest := '';
      Exit;
    end;

    if Str = '' then begin
      Dest := '';
      Result := Str;
      Exit;
    end;
    ArrCount := SizeOf(Divider) div SizeOf(Char);

    while True do begin
      if Count <= SrcLen then begin
        Ch := Str[Count];
        for i := 0 to ArrCount - 1 do
          if Ch = Divider[i] then
            goto CATCH_DIV;
      end;
      if (Count > SrcLen) then begin
        CATCH_DIV:
        if (BufCount > 0) then begin
          if BufCount < BUF_SIZE - 1 then begin
            Buf[BufCount] := #0;
            Dest := string(Buf);
            Result := Copy(Str, Count + 1, SrcLen - Count);
          end;
          break;
        end else begin
          if (Count > SrcLen) then begin
            Dest := '';
            Result := Copy(Str, Count + 2, SrcLen - 1);
            break;
          end;
        end;
      end else begin
        if BufCount < BUF_SIZE - 1 then begin
          Buf[BufCount] := Ch;
          Inc(BufCount);
        end; // else
        //ShowMessage ('BUF_SIZE overflow !');
      end;
      Inc(Count);
    end;
  except
    Dest := '';
    Result := '';
  end;
end;


// ±¸ºÐ¹®ÀÚ°¡ ³ª¸ÓÁö(Result)¿¡ Æ÷ÇÔ µÈ´Ù.
function GetValidStr4(Str: string; var Dest: string; const Divider: array of Char): string;
const
  BUF_SIZE = 18200; //$7FFF;
var
  Buf: array[0..BUF_SIZE] of Char;
  BufCount, Count, SrcLen, i, ArrCount: LongInt;
  Ch: Char;
label
  CATCH_DIV;
begin
  Ch := #0; //Jacky
  try
    //EnterCriticalSection (CSUtilLock);
    SrcLen := Length(Str);
    BufCount := 0;
    Count := 1;

    if Str = '' then begin
      Dest := '';
      Result := Str;
      Exit;
    end;
    ArrCount := SizeOf(Divider) div SizeOf(Char);

    while True do begin
      if Count <= SrcLen then begin
        Ch := Str[Count];
        for i := 0 to ArrCount - 1 do
          if Ch = Divider[i] then
            goto CATCH_DIV;
      end;
      if (Count > SrcLen) then begin
        CATCH_DIV:
        if (BufCount > 0) or (Ch <> ' ') then begin
          if BufCount <= 0 then begin
            Buf[0] := Ch; Buf[1] := #0; Ch := ' ';
          end else
            Buf[BufCount] := #0;
          Dest := string(Buf);
          if Ch <> ' ' then
            Result := Copy(Str, Count, SrcLen - Count + 1) //remain divider in rest-string,
          else Result := Copy(Str, Count + 1, SrcLen - Count); //exclude whitespace
          break;
        end else begin
          if (Count > SrcLen) then begin
            Dest := '';
            Result := Copy(Str, Count + 2, SrcLen - 1);
            break;
          end;
        end;
      end else begin
        if BufCount < BUF_SIZE - 1 then begin
          Buf[BufCount] := Ch;
          Inc(BufCount);
        end else
          ShowMessage('BUF_SIZE overflow !');
      end;
      Inc(Count);
    end;
  finally
    //LeaveCriticalSection (CSUtilLock);
  end;
end;


function GetValidStrVal(Str: string; var Dest: string; const Divider: array of Char): string;
//¼ýÀÚ¸¦ ºÐ¸®ÇØ³¿ ex) 12.30mV
const
  BUF_SIZE = 15600;
var
  Buf: array[0..BUF_SIZE] of Char;
  BufCount, Count, SrcLen, i, ArrCount: LongInt;
  Ch: Char;
  currentNumeric: Boolean;
  hexmode: Boolean;
label
  CATCH_DIV;
begin
  Ch := #0; //Jacky
  try
    //EnterCriticalSection (CSUtilLock);
    hexmode := False;
    SrcLen := Length(Str);
    BufCount := 0;
    Count := 1;
    currentNumeric := False;

    if Str = '' then begin
      Dest := '';
      Result := Str;
      Exit;
    end;
    ArrCount := SizeOf(Divider) div SizeOf(Char);

    while True do begin
      if Count <= SrcLen then begin
        Ch := Str[Count];
        for i := 0 to ArrCount - 1 do
          if Ch = Divider[i] then
            goto CATCH_DIV;
      end;
      if not currentNumeric then begin
        if (Count + 1) < SrcLen then begin
          if (Str[Count] = '0') and (UpCase(Str[Count + 1]) = 'X') then begin
            Buf[BufCount] := Str[Count];
            Buf[BufCount + 1] := Str[Count + 1];
            Inc(BufCount, 2);
            Inc(Count, 2);
            hexmode := True;
            currentNumeric := True;
            Continue;
          end;
          if (Ch = '-') and (Str[Count + 1] >= '0') and (Str[Count + 1] <= '9') then begin
            currentNumeric := True;
          end;
        end;
        if (Ch >= '0') and (Ch <= '9') then begin
          currentNumeric := True;
        end;
      end else begin
        if hexmode then begin
          if not (((Ch >= '0') and (Ch <= '9')) or
            ((Ch >= 'A') and (Ch <= 'F')) or
            ((Ch >= 'a') and (Ch <= 'f'))) then begin
            Dec(Count);
            goto CATCH_DIV;
          end;
        end else
          if ((Ch < '0') or (Ch > '9')) and (Ch <> '.') then begin
          Dec(Count);
          goto CATCH_DIV;
        end;
      end;
      if (Count > SrcLen) then begin
        CATCH_DIV:
        if (BufCount > 0) then begin
          Buf[BufCount] := #0;
          Dest := string(Buf);
          Result := Copy(Str, Count + 1, SrcLen - Count);
          break;
        end else begin
          if (Count > SrcLen) then begin
            Dest := '';
            Result := Copy(Str, Count + 2, SrcLen - 1);
            break;
          end;
        end;
      end else begin
        if BufCount < BUF_SIZE - 1 then begin
          Buf[BufCount] := Ch;
          Inc(BufCount);
        end else
          ShowMessage('BUF_SIZE overflow !');
      end;
      Inc(Count);
    end;
  finally
    //LeaveCriticalSection (CSUtilLock);
  end;
end;

{" " capture => CaptureString (source: string; var rdstr: string): string;
 ** Ã³À½¿¡ " ´Â Ç×»ó ¸Ç Ã³À½¿¡ ÀÖ´Ù°í °¡Á¤
}
function GetValidStrCap(Str: string; var Dest: string; const Divider: array of Char): string;
begin
  Str := TrimLeft(Str);
  if Str <> '' then begin
    if Str[1] = '"' then
      Result := CaptureString(Str, Dest)
    else begin
      Result := GetValidStr3(Str, Dest, Divider);
    end;
  end else begin
    Result := '';
    Dest := '';
  end;
end;
function IntToStr2(n: Integer): string;
begin
  if n < 10 then Result := '0' + IntToStr(n)
  else Result := IntToStr(n);
end;

function IntToStrFill(num, len: Integer; fill: Char): string;
var
  i: Integer;
  Str: string;
begin
  Result := '';
  Str := IntToStr(num);
  for i := 1 to len - Length(Str) do
    Result := Result + fill;
  Result := Result + Str;
end;

function IsInB(Src: string; Pos: Integer; targ: string): Boolean;
var
  tLen, i: Integer;
begin
  Result := False;
  tLen := Length(targ);
  if Length(Src) < Pos + tLen then Exit;
  for i := 0 to tLen - 1 do
    if UpCase(Src[Pos + i]) <> UpCase(targ[i + 1]) then Exit;

  Result := True;
end;

function IsInRect(x, y: Integer; Rect: TRect): Boolean;
begin
  if (x >= Rect.Left) and (x <= Rect.Right) and (y >= Rect.Top) and (y <= Rect.Bottom) then
    Result := True else
    Result := False;
end;

function IsStringNumber(Str: string): Boolean;
var i: Integer;
begin
  Result := True;
  for i := 1 to Length(Str) do
    if (Byte(Str[i]) < Byte('0')) or (Byte(Str[i]) > Byte('9')) then begin
      Result := False;
      break;
    end;
end;

{function IsVarNumber (str: string): boolean;
var i: integer;
begin
   Result := FALSE;
   if length(str) <= 3 then begin
     if (UpCase(str[1]) = 'P') or (UpCase(str[1]) = 'G') or (UpCase(str[1]) = 'M') or (UpCase(str[1]) = 'I') or (UpCase(str[1]) = 'D') or (UpCase(str[1]) = 'N') or (UpCase(str[1]) = 'A') then begin
       if (length(str) = 3) and IsStringNumber(str[2]) and IsStringNumber(str[3]) then Result := TRUE
       else if (length(str) = 2) and IsStringNumber(str[2]) then Result := TRUE;
     end;
   end;
end; }
function IsVarNumber(Str: string): Boolean;
var i: Integer;
begin
  Result := False;
  if (CompareLStr(Str, 'HUMAN', Length('HUMAN'))) or (CompareLStr(Str, 'GUILD', Length('GUILD'))) or
    (CompareLStr(Str, 'GLOBAL', Length('GLOBAL'))) then Result := True;
end;

{Return : remain string}

function ArrestString(Source, SearchAfter, ArrestBefore: string;
  const DropTags: array of string; var RsltStr: string): string;
const
  BUF_SIZE = $7FFF;
var
  Buf: array[0..BUF_SIZE] of Char;
  BufCount, SrcCount, SrcLen, {AfterLen, BeforeLen,} DropCount, i: Integer;
  ArrestNow: Boolean;
begin
  try
    //EnterCriticalSection (CSUtilLock);
    RsltStr := ''; {result string}
    SrcLen := Length(Source);

    if SrcLen > BUF_SIZE then begin
      Result := '';
      Exit;
    end;

    BufCount := 0;
    SrcCount := 1;
    ArrestNow := False;
    DropCount := SizeOf(DropTags) div SizeOf(string);

    if (SearchAfter = '') then ArrestNow := True;

    //GetMem (Buf, BUF_SIZE);

    while True do begin
      if SrcCount > SrcLen then break;

      if not ArrestNow then begin
        if IsInB(Source, SrcCount, SearchAfter) then ArrestNow := True;
      end else begin
        Buf[BufCount] := Source[SrcCount];
        if IsInB(Source, SrcCount, ArrestBefore) or (BufCount >= BUF_SIZE - 2) then begin
          BufCount := BufCount - Length(ArrestBefore);
          Buf[BufCount + 1] := #0;
          RsltStr := string(Buf);
          BufCount := 0;
          break;
        end;

        for i := 0 to DropCount - 1 do begin
          if IsInB(Source, SrcCount, DropTags[i]) then begin
            BufCount := BufCount - Length(DropTags[i]);
            break;
          end;
        end;

        Inc(BufCount);
      end;
      Inc(SrcCount);
    end;

    if (ArrestNow) and (BufCount <> 0) then begin
      Buf[BufCount] := #0;
      RsltStr := string(Buf);
    end;

    Result := Copy(Source, SrcCount + 1, SrcLen - SrcCount); {result is remain string}
  finally
    //LeaveCriticalSection (CSUtilLock);
  end;
end;


function ArrestStringEx(Source, SearchAfter, ArrestBefore: string; var ArrestStr: string): string;
var
  BufCount, SrcCount, SrcLen: Integer;
  GoodData, Fin: Boolean;
  i, n: Integer;
begin
  ArrestStr := ''; {result string}
  if Source = '' then begin
    Result := '';
    Exit;
  end;

  try
    SrcLen := Length(Source);
    GoodData := False;
    if SrcLen >= 2 then
      if Source[1] = SearchAfter then begin
        Source := Copy(Source, 2, SrcLen - 1);
        SrcLen := Length(Source);
        GoodData := True;
      end else begin
        n := Pos(SearchAfter, Source);
        if n > 0 then begin
          Source := Copy(Source, n + 1, SrcLen - (n));
          SrcLen := Length(Source);
          GoodData := True;
        end;
      end;
    Fin := False;
    if GoodData then begin
      n := Pos(ArrestBefore, Source);
      if n > 0 then begin
        ArrestStr := Copy(Source, 1, n - 1);
        Result := Copy(Source, n + 1, SrcLen - n);
      end else begin
        Result := SearchAfter + Source;
      end;
    end else begin
      for i := 1 to SrcLen do begin
        if Source[i] = SearchAfter then begin
          Result := Copy(Source, i, SrcLen - i + 1);
          break;
        end;
      end;
    end;
  except
    ArrestStr := '';
    Result := '';
  end;
end;

function SkipStr(Src: string; const Skips: array of Char): string;
var
  i, len, c: Integer;
  NowSkip: Boolean;
begin
  len := Length(Src);
  //   Count := sizeof(Skips) div sizeof (Char);

  for i := 1 to len do begin
    NowSkip := False;
    for c := Low(Skips) to High(Skips) do
      if Src[i] = Skips[c] then begin
        NowSkip := True;
        break;
      end;
    if not NowSkip then break;
  end;

  Result := Copy(Src, i, len - i + 1);

end;


function GetStrToCoords(Str: string): TRect;
var
  Temp: string;
begin

  Str := GetValidStr3(Str, Temp, [',', ' ']); Result.Left := Str_ToInt(Temp, 0);
  Str := GetValidStr3(Str, Temp, [',', ' ']); Result.Top := Str_ToInt(Temp, 0);
  Str := GetValidStr3(Str, Temp, [',', ' ']); Result.Right := Str_ToInt(Temp, 0);
  GetValidStr3(Str, Temp, [',', ' ']); Result.Bottom := Str_ToInt(Temp, 0);

end;

function CombineDirFile(SrcDir, TargName: string): string;
begin
  if (SrcDir = '') or (TargName = '') then begin
    Result := SrcDir + TargName;
    Exit;
  end;
  if SrcDir[Length(SrcDir)] = '\' then
    Result := SrcDir + TargName
  else Result := SrcDir + '\' + TargName;
end;

function CompareLStr(Src, targ: string; compn: Integer): Boolean;
var
  i: Integer;
begin
  Result := False;
  if compn <= 0 then Exit;
  if Length(Src) < compn then Exit;
  if Length(targ) < compn then Exit;
  Result := True;
  for i := 1 to compn do
    if UpCase(Src[i]) <> UpCase(targ[i]) then begin
      Result := False;
      break;
    end;
end;

function CompareBuffer(p1, p2: PByte; len: Integer): Boolean;
var
  i: Integer;
begin
  Result := True;
  for i := 0 to len - 1 do
    if PByte(Integer(p1) + i)^ <> PByte(Integer(p2) + i)^ then begin
      Result := False;
      break;
    end;
end;

function CompareBackLStr(Src, targ: string; compn: Integer): Boolean;
var
  i, slen, tLen: Integer;
begin
  Result := False;
  if compn <= 0 then Exit;
  if Length(Src) < compn then Exit;
  if Length(targ) < compn then Exit;
  slen := Length(Src);
  tLen := Length(targ);
  Result := True;
  for i := 0 to compn - 1 do
    if UpCase(Src[slen - i]) <> UpCase(targ[tLen - i]) then begin
      Result := False;
      break;
    end;
end;


function IsEnglish(Ch: Char): Boolean;
begin
  Result := False;
  if ((Ch >= 'A') and (Ch <= 'Z')) or ((Ch >= 'a') and (Ch <= 'z')) then
    Result := True;
end;

function IsEngNumeric(Ch: Char): Boolean;
begin
  Result := False;
  if IsEnglish(Ch) or ((Ch >= '0') and (Ch <= '9')) then
    Result := True;
end;

function IsFloatNumeric(Str: string): Boolean;
begin
  if Trim(Str) = '' then begin
    Result := False;
    Exit;
  end;
  try
    StrToFloat(Str);
    Result := True;
  except
    Result := False;
  end;
end;

procedure PCharSet(P: PChar; n: Integer; Ch: Char);
var
  i: Integer;
begin
  for i := 0 to n - 1 do
    (P + i)^ := Ch;
end;

function ReplaceChar(Src: string; srcchr, repchr: Char): string;
var
  i, len: Integer;
begin
  if Src <> '' then begin
    len := Length(Src);
    for i := 0 to len - 1 do
      if Src[i] = srcchr then Src[i] := repchr;
  end;
  Result := Src;
end;


function IsUniformStr(Src: string; Ch: Char): Boolean;
var
  i, len: Integer;
begin
  Result := True;
  if Src <> '' then begin
    len := Length(Src);
    for i := 0 to len - 1 do
      if Src[i] = Ch then begin
        Result := False;
        break;
      end;
  end;
end;


function CreateMask(Src: PChar; TargPos: Integer): string;
  function IsNumber(Chr: Char): Boolean;
  begin
    if (Chr >= '0') and (Chr <= '9') then
      Result := True
    else Result := False;
  end;
var
  intFlag, Loop: Boolean;
  Cnt, IntCnt, SrcLen: Integer;
  Ch, Ch2: Char;
begin
  intFlag := False;
  Loop := True;
  Cnt := 0;
  IntCnt := 0;
  SrcLen := StrLen(Src);

  while Loop do begin
    Ch := PChar(LongInt(Src) + Cnt)^;
    case Ch of
      #0: begin
          Result := '';
          break;
        end;
      ' ': begin
        end;
      else begin

          if not intFlag then begin { Now Reading char }
            if IsNumber(Ch) then begin
              intFlag := True;
              Inc(IntCnt);
            end;
          end else begin { If, now reading integer }
            if not IsNumber(Ch) then begin { XXE+3 }
              case UpCase(Ch) of
                'E': begin
                    if (Cnt >= 1) and (Cnt + 2 < SrcLen) then begin
                      Ch := PChar(LongInt(Src) + Cnt - 1)^;
                      if IsNumber(Ch) then begin
                        Ch := PChar(LongInt(Src) + Cnt + 1)^;
                        Ch2 := PChar(LongInt(Src) + Cnt + 2)^;
                        if not ((Ch = '+') and (IsNumber(Ch2))) then begin
                          intFlag := False;
                        end;
                      end;
                    end;
                  end;
                '+': begin
                    if (Cnt >= 1) and (Cnt + 1 < SrcLen) then begin
                      Ch := PChar(LongInt(Src) + Cnt - 1)^;
                      Ch2 := PChar(LongInt(Src) + Cnt + 1)^;
                      if not ((UpCase(Ch) = 'E') and (IsNumber(Ch2))) then begin
                        intFlag := False;
                      end;
                    end;
                  end;
                '.': begin
                    if (Cnt >= 1) and (Cnt + 1 < SrcLen) then begin
                      Ch := PChar(LongInt(Src) + Cnt - 1)^;
                      Ch2 := PChar(LongInt(Src) + Cnt + 1)^;
                      if not ((IsNumber(Ch)) and (IsNumber(Ch2))) then begin
                        intFlag := False;
                      end;
                    end;
                  end;

                else
                  intFlag := False;
              end;
            end;
          end; {end of case else}
        end; {end of Case}
    end;
    if (intFlag) and (Cnt >= TargPos) then begin
      Result := '%' + format('%d', [IntCnt]);
      Exit;
    end;
    Inc(Cnt);
  end;
end;

function GetValueFromMask(Src: PChar; Mask: string): string;
  function Positon(Str: string): Integer;
  var
    str2: string;
  begin
    str2 := Copy(Str, 2, Length(Str) - 1);
    Result := StrToIntDef(str2, 0);
    if Result <= 0 then Result := 1;
  end;
  function IsNumber(Ch: Char): Boolean;
  begin
    case Ch of
      '0'..'9': Result := True;
      else Result := False;
    end;
  end;
var
  intFlag, Loop, Sign: Boolean;
  Buf: Str256;
  BufCount, Pos, LocCount, TargLoc, SrcLen: Integer;
  Ch, Ch2: Char;
begin
  SrcLen := StrLen(Src);
  LocCount := 0;
  BufCount := 0;
  Pos := 0;
  intFlag := False;
  Loop := True;
  Sign := False;

  if Mask = '' then Mask := '%1';
  TargLoc := Positon(Mask);

  while Loop do begin
    if Pos >= SrcLen then break;
    Ch := PChar(Src + Pos)^;
    if not intFlag then begin {now reading chars}
      if LocCount < TargLoc then begin
        if IsNumber(Ch) then begin
          intFlag := True;
          BufCount := 0;
          Inc(LocCount);
        end else begin
          if not Sign then begin {default '+'}
            if Ch = '-' then Sign := True;
          end else begin
            if Ch <> ' ' then Sign := False;
          end;
        end;
      end else begin
        break;
      end;
    end;
    if intFlag then begin {now reading numbers}
      Buf[BufCount] := Ch;
      Inc(BufCount);
      if not IsNumber(Ch) then begin
        case Ch of
          'E', 'e': begin
              if (Pos >= 1) and (Pos + 2 < SrcLen) then begin
                Ch := PChar(Src + Pos - 1)^;
                if IsNumber(Ch) then begin
                  Ch := PChar(Src + Pos + 1)^;
                  Ch2 := PChar(Src + Pos + 2)^;
                  if not ((Ch = '+') or (Ch = '-') and (IsNumber(Ch2))) then begin
                    Dec(BufCount);
                    intFlag := False;
                  end;
                end;
              end;
            end;
          '+', '-': begin
              if (Pos >= 1) and (Pos + 1 < SrcLen) then begin
                Ch := PChar(Src + Pos - 1)^;
                Ch2 := PChar(Src + Pos + 1)^;
                if not ((UpCase(Ch) = 'E') and (IsNumber(Ch2))) then begin
                  Dec(BufCount);
                  intFlag := False;
                end;
              end;
            end;
          '.': begin
              if (Pos >= 1) and (Pos + 1 < SrcLen) then begin
                Ch := PChar(Src + Pos - 1)^;
                Ch2 := PChar(Src + Pos + 1)^;
                if not ((IsNumber(Ch)) and (IsNumber(Ch2))) then begin
                  Dec(BufCount);
                  intFlag := False;
                end;
              end;
            end;
          else begin
              intFlag := False;
              Dec(BufCount);
            end;
        end;
      end;
    end;
    Inc(Pos);
  end;
  if LocCount = TargLoc then begin
    Buf[BufCount] := #0;
    if Sign then
      Result := '-' + StrPas(Buf)
    else Result := StrPas(Buf);
  end else Result := '';
end;

procedure GetDirList(path: string; fllist: TStringList);
var
  SearchRec: TSearchRec;
begin
  if FindFirst(path, faAnyFile, SearchRec) = 0 then begin
    fllist.AddObject(SearchRec.Name, TObject(SearchRec.Time));
    while True do begin
      if FindNext(SearchRec) = 0 then begin
        fllist.AddObject(SearchRec.Name, TObject(SearchRec.Time));
      end else begin
        SysUtils.FindClose(SearchRec);
        break;
      end;
    end;
  end;
end;

function GetFileDate(FileName: string): Integer; //DOS format file date..
var
  SearchRec: TSearchRec;
begin
  Result := 0; //jacky
  if FindFirst(FileName, faAnyFile, SearchRec) = 0 then begin
    Result := SearchRec.Time;
    SysUtils.FindClose(SearchRec);
  end;
end;




procedure ShlStr(Source: PChar; Count: Integer);
var
  i, len: Integer;
begin
  len := StrLen(Source);
  while (Count > 0) do begin
    for i := 0 to len - 2 do
      Source[i] := Source[i + 1];
    Source[len - 1] := #0;

    Dec(Count);
  end;
end;

procedure ShrStr(Source: PChar; Count: Integer);
var
  i, len: Integer;
begin
  len := StrLen(Source);
  while (Count > 0) do begin
    for i := len - 1 downto 0 do
      Source[i + 1] := Source[i];
    Source[len + 1] := #0;

    Dec(Count);
  end;
end;

function LRect(l, t, r, b: LongInt): TLRect;
begin
  Result.Left := l;
  Result.Top := t;
  Result.Right := r;
  Result.Bottom := b;
end;

procedure MemPCopy(Dest: PChar; Src: string);
var i: Integer;
begin
  for i := 0 to Length(Src) - 1 do Dest[i] := Src[i + 1];
end;

procedure MemCpy(Dest, Src: PChar; Count: LongInt);
var
  i: LongInt;
begin
  for i := 0 to Count - 1 do begin
    PChar(LongInt(Dest) + i)^ := PChar(LongInt(Src) + i)^;
  end;
end;

procedure memcpy2(TargAddr, SrcAddr: LongInt; Count: Integer);
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
    PChar(TargAddr + i)^ := PChar(SrcAddr + i)^;
end;

procedure memset(Buffer: PChar; FillChar: Char; Count: Integer);
var i: Integer;
begin
  for i := 0 to Count - 1 do
    Buffer[i] := FillChar;
end;

procedure Str256PCopy(Dest: PChar; const Src: string);
begin
  StrPLCopy(Dest, Src, 255);
end;

function _StrPas(Dest: PChar): string;
var
  i: Integer;
begin
  Result := '';
  for i := 0 to Length(Dest) - 1 do
    if Dest[i] <> Chr(0) then
      Result := Result + Dest[i]
    else
      break;
end;

function Str_PCopy(Dest: PChar; Src: string): Integer;
var
  len, i: Integer;
begin
  len := Length(Src);
  for i := 1 to len do Dest[i - 1] := Src[i];
  Dest[len] := #0;
  Result := len;
end;

function Str_PCopyEx(Dest: PChar; const Src: string; buflen: LongInt): Integer;
var
  len, i: Integer;
begin
  len := _MIN(Length(Src), buflen);
  for i := 1 to len do Dest[i - 1] := Src[i];
  Dest[len] := #0;
  Result := len;
end;

function Str_Catch(Src, Dest: string; len: Integer): string; //Result is rests..
begin

end;

function Trim_R(const Str: string): string;
var
  i, len, tr: Integer;
begin
  tr := 0;
  len := Length(Str);
  for i := len downto 1 do
    if Str[i] = ' ' then Inc(tr)
    else break;
  Result := Copy(Str, 1, len - tr);
end;

function IsEqualFont(SrcFont, TarFont: TFont): Boolean;
begin
  Result := True;
  if SrcFont.Name <> TarFont.Name then Result := False;
  if SrcFont.Color <> TarFont.Color then Result := False;
  if SrcFont.Style <> TarFont.Style then Result := False;
  if SrcFont.Size <> TarFont.Size then Result := False;
end;


function CutHalfCode(Str: string): string;
var
  Pos, len: Integer;
begin

  Result := '';
  Pos := 1;
  len := Length(Str);

  while True do begin

    if Pos > len then break;

    if (Str[Pos] > #127) then begin

      if ((Pos + 1) <= len) and (Str[Pos + 1] > #127) then begin
        Result := Result + Str[Pos] + Str[Pos + 1];
        Inc(Pos);
      end;

    end else
      Result := Result + Str[Pos];

    Inc(Pos);

  end;
end;


function ConvertToShortName(Canvas: TCanvas; Source: string; WantWidth: Integer): string;
var
  i, len: Integer;
  Str: string;
begin
  if Length(Source) > 3 then
    if Canvas.TextWidth(Source) > WantWidth then begin

      len := Length(Source);
      for i := 1 to len do begin

        Str := Copy(Source, 1, (len - i));
        Str := Str + '..';

        if Canvas.TextWidth(Str) < (WantWidth - 4) then begin
          Result := CutHalfCode(Str);
          Exit;
        end;

      end;

      Result := CutHalfCode(Copy(Source, 1, 2)) + '..';
      Exit;

    end;

  Result := Source;

end;


function DuplicateBitmap(bitmap: TBitmap): HBitmap;
var
  hbmpOldSrc, hbmpOldDest, hbmpNew: HBitmap;
  hdcSrc, hdcDest: hdc;

begin
  hdcSrc := CreateCompatibleDC(0);
  hdcDest := CreateCompatibleDC(hdcSrc);

  hbmpOldSrc := SelectObject(hdcSrc, bitmap.Handle);

  hbmpNew := CreateCompatibleBitmap(hdcSrc, bitmap.Width, bitmap.Height);

  hbmpOldDest := SelectObject(hdcDest, hbmpNew);

  BitBlt(hdcDest, 0, 0, bitmap.Width, bitmap.Height, hdcSrc, 0, 0,
    SRCCOPY);

  SelectObject(hdcDest, hbmpOldDest);
  SelectObject(hdcSrc, hbmpOldSrc);

  DeleteDC(hdcDest);
  DeleteDC(hdcSrc);

  Result := hbmpNew;
end;


procedure SpliteBitmap(DC: hdc; x, y: Integer; bitmap: TBitmap; transcolor: TColor);
var
  hdcMixBuffer, hdcBackMask, hdcForeMask, hdcCopy: hdc;
  hOld, hbmCopy, hbmMixBuffer, hbmBackMask, hbmForeMask: HBitmap;
  oldColor: TColor;
begin

  {UnrealizeObject (DC);}
(*   SelectPalette (DC, bitmap.Palette, FALSE);
  RealizePalette (DC);
 *)

  hbmCopy := DuplicateBitmap(bitmap);
  hdcCopy := CreateCompatibleDC(DC);
  hOld := SelectObject(hdcCopy, hbmCopy);

  hdcBackMask := CreateCompatibleDC(DC);
  hdcForeMask := CreateCompatibleDC(DC);
  hdcMixBuffer := CreateCompatibleDC(DC);

  hbmBackMask := CreateBitmap(bitmap.Width, bitmap.Height, 1, 1, nil);
  hbmForeMask := CreateBitmap(bitmap.Width, bitmap.Height, 1, 1, nil);
  hbmMixBuffer := CreateCompatibleBitmap(DC, bitmap.Width, bitmap.Height);

  SelectObject(hdcBackMask, hbmBackMask);
  SelectObject(hdcForeMask, hbmForeMask);
  SelectObject(hdcMixBuffer, hbmMixBuffer);

  oldColor := SetBkColor(hdcCopy, transcolor); //clWhite);

  BitBlt(hdcForeMask, 0, 0, bitmap.Width, bitmap.Height, hdcCopy, 0, 0, SRCCOPY);

  SetBkColor(hdcCopy, oldColor);

  BitBlt(hdcBackMask, 0, 0, bitmap.Width, bitmap.Height, hdcForeMask, 0, 0, NOTSRCCOPY);

  BitBlt(hdcMixBuffer, 0, 0, bitmap.Width, bitmap.Height, DC, x, y, SRCCOPY);

  BitBlt(hdcMixBuffer, 0, 0, bitmap.Width, bitmap.Height, hdcForeMask, 0, 0, SRCAND);

  BitBlt(hdcCopy, 0, 0, bitmap.Width, bitmap.Height, hdcBackMask, 0, 0, SRCAND);

  BitBlt(hdcMixBuffer, 0, 0, bitmap.Width, bitmap.Height, hdcCopy, 0, 0, SRCPAINT);

  BitBlt(DC, x, y, bitmap.Width, bitmap.Height, hdcMixBuffer, 0, 0, SRCCOPY);

  {DeleteObject (hbmCopy);}
  DeleteObject(SelectObject(hdcCopy, hOld));
  DeleteObject(SelectObject(hdcForeMask, hOld));
  DeleteObject(SelectObject(hdcBackMask, hOld));
  DeleteObject(SelectObject(hdcMixBuffer, hOld));

  DeleteDC(hdcCopy);
  DeleteDC(hdcForeMask);
  DeleteDC(hdcBackMask);
  DeleteDC(hdcMixBuffer);

end;

function TagCount(Source: string; Tag: Char): Integer;
var
  i, tCount: Integer;
begin
  tCount := 0;
  for i := 1 to Length(Source) do
    if Source[i] = Tag then Inc(tCount);
  Result := tCount;
end;

{ "xxxxxx" => xxxxxx }
function TakeOffTag(Src: string; Tag: Char; var rstr: string): string;
var
  i, n2: Integer;
begin
  n2 := Pos(Tag, Copy(Src, 2, Length(Src)));
  rstr := Copy(Src, 2, n2 - 1);
  Result := Copy(Src, n2 + 2, Length(Src) - n2);
end;

function CatchString(Source: string; cap: Char; var catched: string): string;
var
  n: Integer;
begin
  Result := '';
  catched := '';
  if Source = '' then Exit;
  if Length(Source) < 2 then begin
    Result := Source;
    Exit;
  end;
  if Source[1] = cap then begin
    if Source[2] = cap then //##abc#
      Source := Copy(Source, 2, Length(Source));
    if TagCount(Source, cap) >= 2 then begin
      Result := TakeOffTag(Source, cap, catched);
    end else
      Result := Source;
  end else begin
    if TagCount(Source, cap) >= 2 then begin
      n := Pos(cap, Source);
      Source := Copy(Source, n, Length(Source));
      Result := TakeOffTag(Source, cap, catched);
    end else
      Result := Source;
  end;
end;

{ GetValidStr3¿Í ´Þ¸® ½Äº°ÀÚ°¡ ¿¬¼ÓÀ¸·Î ³ª¿Ã°æ¿ì Ã³¸® ¾ÈµÊ }
{ ½Äº°ÀÚ°¡ ¾øÀ» °æ¿ì, nil ¸®ÅÏ.. }
function DivString(Source: string; cap: Char; var sel: string): string;
var
  n: Integer;
begin
  if Source = '' then begin
    sel := '';
    Result := '';
    Exit;
  end;
  n := Pos(cap, Source);
  if n > 0 then begin
    sel := Copy(Source, 1, n - 1);
    Result := Copy(Source, n + 1, Length(Source));
  end else begin
    sel := Source;
    Result := '';
  end;
end;

function DivTailString(Source: string; cap: Char; var sel: string): string;
var
  i, n: Integer;
begin
  if Source = '' then begin
    sel := '';
    Result := '';
    Exit;
  end;
  n := 0;
  for i := Length(Source) downto 1 do
    if Source[i] = cap then begin
      n := i;
      break;
    end;
  if n > 0 then begin
    sel := Copy(Source, n + 1, Length(Source));
    Result := Copy(Source, 1, n - 1);
  end else begin
    sel := '';
    Result := Source;
  end;
end;


function SPos(substr, Str: string): Integer;
var
  i, J, len, slen: Integer;
  flag: Boolean;
begin
  Result := -1;
  len := Length(Str);
  slen := Length(substr);
  for i := 0 to len - slen do begin
    flag := True;
    for J := 1 to slen do begin
      if Byte(Str[i + J]) >= $B0 then begin
        if (J < slen) and (i + J < len) then begin
          if substr[J] <> Str[i + J] then begin
            flag := False;
            break;
          end;
          if substr[J + 1] <> Str[i + J + 1] then begin
            flag := False;
            break;
          end;
        end else
          flag := False;
      end else
        if substr[J] <> Str[i + J] then begin
        flag := False;
        break;
      end;
    end;
    if flag then begin
      Result := i + 1;
      break;
    end;
  end;
end;

function NumCopy(Str: string): Integer;
var
  i: Integer;
  Data: string;
begin
  Data := '';
  for i := 1 to Length(Str) do begin
    if (Word('0') <= Word(Str[i])) and (Word('9') >= Word(Str[i])) then begin
      Data := Data + Str[i];
    end else
      break;
  end;
  Result := Str_ToInt(Data, 0);
end;

function GetMonDay: string;
var
  Year, mon, Day: Word;
  Str: string;
begin
  DecodeDate(Date, Year, mon, Day);
  Str := IntToStr(Year);
  if mon < 10 then Str := Str + '0' + IntToStr(mon)
  else Str := IntToStr(mon);
  if Day < 10 then Str := Str + '0' + IntToStr(Day)
  else Str := IntToStr(Day);
  Result := Str;
end;

function BoolToStr(boo: Boolean): string;
begin
  if boo then Result := 'TRUE'
  else Result := 'FALSE';
end;

function BooleanToStr(boo: Boolean): string;
begin
  if boo then Result := 'ÊÇ'
  else Result := '·ñ';
end;

function _MIN(n1, n2: Integer): Integer;
begin
  if n1 < n2 then Result := n1
  else Result := n2;
end;

function _MAX(n1, n2: Integer): Integer;
begin
  if n1 > n2 then Result := n1
  else Result := n2;
end;

procedure DisPoseAndNil(var Obj);
var
  Temp: Pointer;
begin
  if Pointer(Obj) <> nil then begin
    Temp := Pointer(Obj);
    Pointer(Obj) := nil;
    DisPose(Temp);
  end;
end;

end.


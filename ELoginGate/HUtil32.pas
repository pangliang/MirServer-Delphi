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
  Str4096 = array[0..4096] of char;
  Str256 = array[0..256] of char;
  TyNameTable = record
    Name: string;
    varl: Longint;
  end;

  TLRect = record
    Left, Top, Right, Bottom: Longint;
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




function CountGarbage(paper: TCanvas; Src: PChar; TargWidth: Longint): Integer; {garbage}
{[ArrestString]
      Result = Remain string,
      RsltStr = captured string
}
function ArrestString(Source, SearchAfter, ArrestBefore: string;
  const DropTags: array of string; var RsltStr: string): string;
{*}
function ArrestStringEx(Source, SearchAfter, ArrestBefore: string; var ArrestStr: string): string;
function CaptureString(Source: string; var rdstr: string): string;
procedure ClearWindow(aCanvas: TCanvas; aLeft, aTop, aRight, aBottom: Longint; aColor: TColor);
function CombineDirFile(SrcDir, TargName: string): string;
{*}
function CompareLStr(Src, targ: string; compn: Integer): Boolean;
function CompareBackLStr(Src, targ: string; compn: Integer): Boolean;
function CompareBuffer(p1, p2: PByte; len: Integer): Boolean;
function CreateMask(Src: PChar; TargPos: Integer): string;
procedure DrawTileImage(Canv: TCanvas; Rect: TRect; TileImage: TBitmap);
procedure DrawingGhost(Rc: TRect);
function ExtractFileNameOnly(const fname: string): string;
function FloatToString(F: Real): string;
function FloatToStrFixFmt(fVal: Double; prec, digit: Integer): string;
function FileSize(const fname: string): Longint;
{*}
function FileCopy(Source, dest: string): Boolean;
function FileCopyEx(Source, dest: string): Boolean;
function GetSpaceCount(Str: string): Longint;
function RemoveSpace(Str: string): string;
function GetFirstWord(Str: string; var sWord: string; var FrontSpace: Longint): string;
function GetDefColorByName(Str: string): TColor;
function GetULMarkerType(Str: string): Longint;
{*}
function GetValidStr3(Str: string; var dest: string; const Divider: array of char): string;
function GetValidStr4(Str: string; var dest: string; const Divider: array of char): string;
function GetValidStrVal(Str: string; var dest: string; const Divider: array of char): string;
function GetValidStrCap(Str: string; var dest: string; const Divider: array of char): string;
function GetStrToCoords(Str: string): TRect;
function GetDefines(Str: string): Longint;
function GetValueFromMask(Src: PChar; Mask: string): string;
procedure GetDirList(path: string; fllist: TStringList);
function GetFileDate(filename: string): Integer; //DOS format file date..
function HexToIntEx(shap_str: string): Longint;
function HexToInt(Str: string): Longint;
function IntToStr2(n: Integer): string;
function IntToStrFill(num, len: Integer; fill: char): string;
function IsInB(Src: string; Pos: Integer; targ: string): Boolean;
function IsInRect(X, Y: Integer; Rect: TRect): Boolean;
function IsEnglish(Ch: char): Boolean;
function IsEngNumeric(Ch: char): Boolean;
function IsFloatNumeric(Str: string): Boolean;
function IsUniformStr(Src: string; Ch: char): Boolean;
function IsStringNumber(Str: string): Boolean;
function KillFirstSpace(var Str: string): Longint;
procedure KillGabageSpace(var Str: string);
function LRect(l, t, r, b: Longint): TLRect;
procedure MemPCopy(dest: PChar; Src: string);
procedure MemCpy(dest, Src: PChar; Count: Longint); {PChar type}
procedure memcpy2(TargAddr, SrcAddr: Longint; Count: Integer); {Longint type}
procedure memset(buffer: PChar; FillChar: char; Count: Integer);
procedure PCharSet(P: PChar; n: Integer; Ch: char);
function ReplaceChar(Src: string; srcchr, repchr: char): string;
function Str_ToDate(Str: string): TDateTime;
function Str_ToTime(Str: string): TDateTime;
function Str_ToInt(Str: string; def: Longint): Longint;
function Str_ToFloat(Str: string): Real;
function SkipStr(Src: string; const Skips: array of char): string;
procedure ShlStr(Source: PChar; Count: Integer);
procedure ShrStr(Source: PChar; Count: Integer);
procedure Str256PCopy(dest: PChar; const Src: string);
function _StrPas(dest: PChar): string;
function Str_PCopy(dest: PChar; Src: string): Integer;
function Str_PCopyEx(dest: PChar; const Src: string; buflen: Longint): Integer;
procedure SpliteBitmap(DC: HDC; X, Y: Integer; bitmap: TBitmap; transcolor: TColor);
procedure TiledImage(Canv: TCanvas; Rect: TLRect; TileImage: TBitmap);
function Trim_R(const Str: string): string;
function IsEqualFont(SrcFont, TarFont: TFont): Boolean;
function CutHalfCode(Str: string): string;
function ConvertToShortName(Canvas: TCanvas; Source: string; WantWidth: Integer): string;
{*}
function CatchString(Source: string; cap: char; var catched: string): string;
function DivString(Source: string; cap: char; var sel: string): string;
function DivTailString(Source: string; cap: char; var sel: string): string;
function SPos(substr, Str: string): Integer;
function NumCopy(Str: string): Integer;
function GetMonDay: string;
function BoolToStr(boo: Boolean): string;

function TagCount(Source: string; tag: char): Integer;

function _MIN(n1, n2: Integer): Integer;
function _MAX(n1, n2: Integer): Integer;
function IsIPaddr(IP: string): Boolean;
implementation

//var
//	CSUtilLock: TRTLCriticalSection;

{ capture "double quote streams" }
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
  if not TryStrToInt(tNode, Node[0]) then exit;

  tLen := Length(tIP);
  tPos := Pos('.', tIP);
  tNode := MidStr(tIP, 1, tPos - 1);
  tIP := MidStr(tIP, tPos + 1, tLen - tPos);
  if not TryStrToInt(tNode, Node[1]) then exit;

  tLen := Length(tIP);
  tPos := Pos('.', tIP);
  tNode := MidStr(tIP, 1, tPos - 1);
  tIP := MidStr(tIP, tPos + 1, tLen - tPos);
  if not TryStrToInt(tNode, Node[2]) then exit;

  if not TryStrToInt(tIP, Node[3]) then exit;
  for tLen := Low(Node) to High(Node) do begin
    if (Node[tLen] < 0) or (Node[tLen] > 255) then exit;
  end;
  Result := True;
end;

function CaptureString(Source: string; var rdstr: string): string;
var
  st, et, c, len, I: Integer;
begin
  if Source = '' then begin
    rdstr := ''; Result := '';
    exit;
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
    for I := c + 1 to len do
      if Source[I] = '"' then begin
        et := I - 1;
        break;
      end;

  end else begin
    st := c;
    et := len;
    for I := c to len do
      if Source[I] = ' ' then begin
        et := I - 1;
        break;
      end;

  end;

  rdstr := Copy(Source, st, (et - st + 1));
  if len >= (et + 2) then
    Result := Copy(Source, et + 2, len - (et + 1)) else
    Result := '';

end;


function CountUglyWhiteChar(sPtr: PChar): Longint;
var
  Cnt, Killw: Longint;
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


function CountGarbage(paper: TCanvas; Src: PChar; TargWidth: Longint): Integer; {garbage}
var
  gab, destWidth: Integer;
begin

  gab := CountUglyWhiteChar(Src);
  destWidth := paper.TextWidth(StrPas(Src)) - gab;
  Result := TargWidth - destWidth + (gab * paper.TextWidth(' '));

end;


function GetSpaceCount(Str: string): Longint;
var
  Cnt, len, SpaceCount: Longint;
begin
  SpaceCount := 0;
  len := Length(Str);
  for Cnt := 1 to len do
    if Str[Cnt] = ' ' then SpaceCount := SpaceCount + 1;
  Result := SpaceCount;
end;

function RemoveSpace(Str: string): string;
var
  I: Integer;
begin
  Result := '';
  for I := 1 to Length(Str) do
    if Str[I] <> ' ' then
      Result := Result + Str[I];
end;

function KillFirstSpace(var Str: string): Longint;
var
  Cnt, len: Longint;
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
  Cnt, len: Longint;
begin
  len := Length(Str);
  for Cnt := len downto 1 do
    if Str[Cnt] <> ' ' then begin
      Str := Copy(Str, 1, Cnt);
      KillFirstSpace(Str);
      break;
    end;
end;

function GetFirstWord(Str: string; var sWord: string; var FrontSpace: Longint): string;
var
  Cnt, len, n: Longint;
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
        exit;
      end;
      Inc(n);
    end;
    DestBuf[n] := #0;
    sWord := StrPas(DestBuf);
    Result := '';
  end;
end;

function HexToIntEx(shap_str: string): Longint;
begin
  Result := HexToInt(Copy(shap_str, 2, Length(shap_str) - 1));
end;

function HexToInt(Str: string): Longint;
var
  digit: char;
  Count, I: Integer;
  Cur, Val: Longint;
begin
  Val := 0;
  Count := Length(Str);
  for I := 1 to Count do begin
    digit := Str[I];
    if (digit >= '0') and (digit <= '9') then Cur := Ord(digit) - Ord('0')
    else if (digit >= 'A') and (digit <= 'F') then Cur := Ord(digit) - Ord('A') + 10
    else if (digit >= 'a') and (digit <= 'f') then Cur := Ord(digit) - Ord('a') + 10
    else Cur := 0;
    Val := Val + (Cur shl (4 * (Count - I)));
  end;
  Result := Val;
  //   Result := (Val and $0000FF00) or ((Val shl 16) and $00FF0000) or ((Val shr 16) and $000000FF);
end;

function Str_ToInt(Str: string; def: Longint): Longint;
begin
  Result := def;
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

function Str_ToFloat(Str: string): Real;
begin
  if Str <> '' then try
    Result := StrToFloat(Str);
    exit;
  except
  end;
  Result := 0;
end;

procedure DrawingGhost(Rc: TRect);
var
  DC: HDC;
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

function FloatToString(F: Real): string;
begin
  Result := FloatToStrFixFmt(F, 5, 2);
end;

function FloatToStrFixFmt(fVal: Double; prec, digit: Integer): string;
var
  Cnt, dest, len, I, j: Integer;
  fstr: string;
  Buf: array[0..255] of char;
label end_conv;
begin
  Cnt := 0; dest := 0;
  fstr := FloatToStrF(fVal, ffGeneral, 15, 3);
  len := Length(fstr);
  for I := 1 to len do begin
    if fstr[I] = '.' then begin
      Buf[dest] := '.'; Inc(dest);
      Cnt := 0;
      for j := I + 1 to len do begin
        if Cnt < digit then begin
          Buf[dest] := fstr[j]; Inc(dest);
        end
        else begin
          goto end_conv;
        end;
        Inc(Cnt);
      end;
      goto end_conv;
    end;
    if Cnt < prec then begin
      Buf[dest] := fstr[I]; Inc(dest);
    end;
    Inc(Cnt);
  end;
  end_conv:
  Buf[dest] := char(0);
  Result := StrPas(Buf);
end;


function FileSize(const fname: string): Longint;
var
  SearchRec: TSearchRec;
begin
  if FindFirst(ExpandFileName(fname), faAnyFile, SearchRec) = 0 then
    Result := SearchRec.Size
  else Result := -1;
end;


function FileCopy(Source, dest: string): Boolean;
var
  fSrc, fDst, len: Integer;
  Size: Longint;
  buffer: packed array[0..2047] of Byte;
begin
  Result := False; { Assume that it WONT work }
  if Source <> dest then begin
    fSrc := FileOpen(Source, fmOpenRead);
    if fSrc >= 0 then begin
      Size := FileSeek(fSrc, 0, 2);
      FileSeek(fSrc, 0, 0);
      fDst := FileCreate(dest);
      if fDst >= 0 then begin
        while Size > 0 do begin
          len := FileRead(fSrc, buffer, SizeOf(buffer));
          FileWrite(fDst, buffer, len);
          Size := Size - len;
        end;
        FileSetDate(fDst, FileGetDate(fSrc));
        FileClose(fDst);
        FileSetAttr(dest, FileGetAttr(Source));
        Result := True;
      end;
      FileClose(fSrc);
    end;
  end;
end;

function FileCopyEx(Source, dest: string): Boolean;
var
  fSrc, fDst, len: Integer;
  Size: Longint;
  buffer: array[0..512000] of Byte;
begin
  Result := False; { Assume that it WONT work }
  if Source <> dest then begin
    fSrc := FileOpen(Source, fmOpenRead or fmShareDenyNone);
    if fSrc >= 0 then begin
      Size := FileSeek(fSrc, 0, 2);
      FileSeek(fSrc, 0, 0);
      fDst := FileCreate(dest);
      if fDst >= 0 then begin
        while Size > 0 do begin
          len := FileRead(fSrc, buffer, SizeOf(buffer));
          FileWrite(fDst, buffer, len);
          Size := Size - len;
        end;
        FileSetDate(fDst, FileGetDate(fSrc));
        FileClose(fDst);
        FileSetAttr(dest, FileGetAttr(Source));
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
      exit;
    end;
  end;
  Result := $0;
end;

function GetULMarkerType(Str: string): Longint;
var
  Cnt: Integer;
  COmpStr: string;
begin
  COmpStr := UpperCase(Str);
  for Cnt := 1 to MAXLISTMARKER do begin
    if COmpStr = LiMarkerNames[Cnt].Name then begin
      Result := LiMarkerNames[Cnt].varl;
      exit;
    end;
  end;
  Result := 1;
end;

function GetDefines(Str: string): Longint;
var
  Cnt: Integer;
  COmpStr: string;
begin
  COmpStr := UpperCase(Str);
  for Cnt := 1 to MAXPREDEFINE do begin
    if COmpStr = PreDefineNames[Cnt].Name then begin
      Result := PreDefineNames[Cnt].varl;
      exit;
    end;
  end;
  Result := -1;
end;

procedure ClearWindow(aCanvas: TCanvas; aLeft, aTop, aRight, aBottom: Longint; aColor: TColor);
begin
  with aCanvas do begin
    Brush.Color := aColor;
    Pen.Color := aColor;
    Rectangle(0, 0, aRight - aLeft, aBottom - aTop);
  end;
end;


procedure DrawTileImage(Canv: TCanvas; Rect: TRect; TileImage: TBitmap);
var
  I, j, ICnt, JCnt, BmWidth, BmHeight: Integer;
begin

  BmWidth := TileImage.Width;
  BmHeight := TileImage.Height;
  ICnt := ((Rect.Right - Rect.Left) + BmWidth - 1) div BmWidth;
  JCnt := ((Rect.Bottom - Rect.Top) + BmHeight - 1) div BmHeight;

  UnrealizeObject(Canv.Handle);
  SelectPalette(Canv.Handle, TileImage.Palette, False);
  RealizePalette(Canv.Handle);

  for j := 0 to JCnt do begin
    for I := 0 to ICnt do begin

      { if (I * BmWidth) < (Rect.Right-Rect.Left) then
         BmWidth := TileImage.Width else
          BmWidth := (Rect.Right - Rect.Left) - ((I-1) * BmWidth);

       if (
       BmWidth := TileImage.Width;
       BmHeight := TileImage.Height;  }

      BitBlt(Canv.Handle,
        Rect.Left + I * BmWidth,
        Rect.Top + (j * BmHeight),
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
  I, j, ICnt, JCnt, BmWidth, BmHeight: Integer;
  Rleft, RTop, RWidth, RHeight, BLeft, BTop: Longint;
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

      for j := 0 to JCnt do begin
        for I := 0 to ICnt do begin

          if I = 0 then begin
            BLeft := Rect.Left - ((Rect.Left div BmWidth) * BmWidth);
            Rleft := Rect.Left;
            RWidth := BmWidth;
          end else begin
            if I = ICnt then
              RWidth := Rect.Right - ((Rect.Right div BmWidth) * BmWidth) else
              RWidth := BmWidth;
            BLeft := 0;
            Rleft := (Rect.Left div BmWidth) + (I * BmWidth);
          end;


          if j = 0 then begin
            BTop := Rect.Top - ((Rect.Top div BmHeight) * BmHeight);
            RTop := Rect.Top;
            RHeight := BmHeight;
          end else begin
            if j = JCnt then
              RHeight := Rect.Bottom - ((Rect.Bottom div BmHeight) * BmHeight) else
              RHeight := BmHeight;
            BTop := 0;
            RTop := (Rect.Top div BmHeight) + (j * BmHeight);
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


function GetValidStr3(Str: string; var dest: string; const Divider: array of char): string;
const
  BUF_SIZE = 20480; //$7FFF;
var
  Buf: array[0..BUF_SIZE] of char;
  BufCount, Count, SrcLen, I, ArrCount: Longint;
  Ch: char;
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
      dest := '';
      exit;
    end;

    if Str = '' then begin
      dest := '';
      Result := Str;
      exit;
    end;
    ArrCount := SizeOf(Divider) div SizeOf(char);

    while True do begin
      if Count <= SrcLen then begin
        Ch := Str[Count];
        for I := 0 to ArrCount - 1 do
          if Ch = Divider[I] then
            goto CATCH_DIV;
      end;
      if (Count > SrcLen) then begin
        CATCH_DIV:
        if (BufCount > 0) then begin
          if BufCount < BUF_SIZE - 1 then begin
            Buf[BufCount] := #0;
            dest := string(Buf);
            Result := Copy(Str, Count + 1, SrcLen - Count);
          end;
          break;
        end else begin
          if (Count > SrcLen) then begin
            dest := '';
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
    dest := '';
    Result := '';
  end;
end;


// 구분문자가 나머지(Result)에 포함 된다.
function GetValidStr4(Str: string; var dest: string; const Divider: array of char): string;
const
  BUF_SIZE = 18200; //$7FFF;
var
  Buf: array[0..BUF_SIZE] of char;
  BufCount, Count, SrcLen, I, ArrCount: Longint;
  Ch: char;
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
      dest := '';
      Result := Str;
      exit;
    end;
    ArrCount := SizeOf(Divider) div SizeOf(char);

    while True do begin
      if Count <= SrcLen then begin
        Ch := Str[Count];
        for I := 0 to ArrCount - 1 do
          if Ch = Divider[I] then
            goto CATCH_DIV;
      end;
      if (Count > SrcLen) then begin
        CATCH_DIV:
        if (BufCount > 0) or (Ch <> ' ') then begin
          if BufCount <= 0 then begin
            Buf[0] := Ch; Buf[1] := #0; Ch := ' ';
          end else
            Buf[BufCount] := #0;
          dest := string(Buf);
          if Ch <> ' ' then
            Result := Copy(Str, Count, SrcLen - Count + 1) //remain divider in rest-string,
          else Result := Copy(Str, Count + 1, SrcLen - Count); //exclude whitespace
          break;
        end else begin
          if (Count > SrcLen) then begin
            dest := '';
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


function GetValidStrVal(Str: string; var dest: string; const Divider: array of char): string;
//숫자를 분리해냄 ex) 12.30mV
const
  BUF_SIZE = 15600;
var
  Buf: array[0..BUF_SIZE] of char;
  BufCount, Count, SrcLen, I, ArrCount: Longint;
  Ch: char;
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
      dest := '';
      Result := Str;
      exit;
    end;
    ArrCount := SizeOf(Divider) div SizeOf(char);

    while True do begin
      if Count <= SrcLen then begin
        Ch := Str[Count];
        for I := 0 to ArrCount - 1 do
          if Ch = Divider[I] then
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
          dest := string(Buf);
          Result := Copy(Str, Count + 1, SrcLen - Count);
          break;
        end else begin
          if (Count > SrcLen) then begin
            dest := '';
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
 ** 처음에 " 는 항상 맨 처음에 있다고 가정
}
function GetValidStrCap(Str: string; var dest: string; const Divider: array of char): string;
begin
  Str := TrimLeft(Str);
  if Str <> '' then begin
    if Str[1] = '"' then
      Result := CaptureString(Str, dest)
    else begin
      Result := GetValidStr3(Str, dest, Divider);
    end;
  end else begin
    Result := '';
    dest := '';
  end;
end;
function IntToStr2(n: Integer): string;
begin
  if n < 10 then Result := '0' + IntToStr(n)
  else Result := IntToStr(n);
end;

function IntToStrFill(num, len: Integer; fill: char): string;
var
  I: Integer;
  Str: string;
begin
  Result := '';
  Str := IntToStr(num);
  for I := 1 to len - Length(Str) do
    Result := Result + fill;
  Result := Result + Str;
end;

function IsInB(Src: string; Pos: Integer; targ: string): Boolean;
var
  tLen, I: Integer;
begin
  Result := False;
  tLen := Length(targ);
  if Length(Src) < Pos + tLen then exit;
  for I := 0 to tLen - 1 do
    if UpCase(Src[Pos + I]) <> UpCase(targ[I + 1]) then exit;

  Result := True;
end;

function IsInRect(X, Y: Integer; Rect: TRect): Boolean;
begin
  if (X >= Rect.Left) and (X <= Rect.Right) and (Y >= Rect.Top) and (Y <= Rect.Bottom) then
    Result := True else
    Result := False;
end;

function IsStringNumber(Str: string): Boolean;
var I: Integer;
begin
  Result := True;
  for I := 1 to Length(Str) do
    if (Byte(Str[I]) < Byte('0')) or (Byte(Str[I]) > Byte('9')) then begin
      Result := False;
      break;
    end;
end;


{Return : remain string}

function ArrestString(Source, SearchAfter, ArrestBefore: string;
  const DropTags: array of string; var RsltStr: string): string;
const
  BUF_SIZE = $7FFF;
var
  Buf: array[0..BUF_SIZE] of char;
  BufCount, SrcCount, SrcLen, {AfterLen, BeforeLen,} DropCount, I: Integer;
  ArrestNow: Boolean;
begin
  try
    //EnterCriticalSection (CSUtilLock);
    RsltStr := ''; {result string}
    SrcLen := Length(Source);

    if SrcLen > BUF_SIZE then begin
      Result := '';
      exit;
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

        for I := 0 to DropCount - 1 do begin
          if IsInB(Source, SrcCount, DropTags[I]) then begin
            BufCount := BufCount - Length(DropTags[I]);
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
  I, n: Integer;
begin
  ArrestStr := ''; {result string}
  if Source = '' then begin
    Result := '';
    exit;
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
      for I := 1 to SrcLen do begin
        if Source[I] = SearchAfter then begin
          Result := Copy(Source, I, SrcLen - I + 1);
          break;
        end;
      end;
    end;
  except
    ArrestStr := '';
    Result := '';
  end;
end;

function SkipStr(Src: string; const Skips: array of char): string;
var
  I, len, c: Integer;
  NowSkip: Boolean;
begin
  len := Length(Src);
  //   Count := sizeof(Skips) div sizeof (Char);

  for I := 1 to len do begin
    NowSkip := False;
    for c := Low(Skips) to High(Skips) do
      if Src[I] = Skips[c] then begin
        NowSkip := True;
        break;
      end;
    if not NowSkip then break;
  end;

  Result := Copy(Src, I, len - I + 1);

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
    exit;
  end;
  if SrcDir[Length(SrcDir)] = '\' then
    Result := SrcDir + TargName
  else Result := SrcDir + '\' + TargName;
end;

function CompareLStr(Src, targ: string; compn: Integer): Boolean;
var
  I: Integer;
begin
  Result := False;
  if compn <= 0 then exit;
  if Length(Src) < compn then exit;
  if Length(targ) < compn then exit;
  Result := True;
  for I := 1 to compn do
    if UpCase(Src[I]) <> UpCase(targ[I]) then begin
      Result := False;
      break;
    end;
end;

function CompareBuffer(p1, p2: PByte; len: Integer): Boolean;
var
  I: Integer;
begin
  Result := True;
  for I := 0 to len - 1 do
    if PByte(Integer(p1) + I)^ <> PByte(Integer(p2) + I)^ then begin
      Result := False;
      break;
    end;
end;

function CompareBackLStr(Src, targ: string; compn: Integer): Boolean;
var
  I, slen, tLen: Integer;
begin
  Result := False;
  if compn <= 0 then exit;
  if Length(Src) < compn then exit;
  if Length(targ) < compn then exit;
  slen := Length(Src);
  tLen := Length(targ);
  Result := True;
  for I := 0 to compn - 1 do
    if UpCase(Src[slen - I]) <> UpCase(targ[tLen - I]) then begin
      Result := False;
      break;
    end;
end;


function IsEnglish(Ch: char): Boolean;
begin
  Result := False;
  if ((Ch >= 'A') and (Ch <= 'Z')) or ((Ch >= 'a') and (Ch <= 'z')) then
    Result := True;
end;

function IsEngNumeric(Ch: char): Boolean;
begin
  Result := False;
  if IsEnglish(Ch) or ((Ch >= '0') and (Ch <= '9')) then
    Result := True;
end;

function IsFloatNumeric(Str: string): Boolean;
begin
  if Trim(Str) = '' then begin
    Result := False;
    exit;
  end;
  try
    StrToFloat(Str);
    Result := True;
  except
    Result := False;
  end;
end;

procedure PCharSet(P: PChar; n: Integer; Ch: char);
var
  I: Integer;
begin
  for I := 0 to n - 1 do
    (P + I)^ := Ch;
end;

function ReplaceChar(Src: string; srcchr, repchr: char): string;
var
  I, len: Integer;
begin
  if Src <> '' then begin
    len := Length(Src);
    for I := 0 to len - 1 do
      if Src[I] = srcchr then Src[I] := repchr;
  end;
  Result := Src;
end;


function IsUniformStr(Src: string; Ch: char): Boolean;
var
  I, len: Integer;
begin
  Result := True;
  if Src <> '' then begin
    len := Length(Src);
    for I := 0 to len - 1 do
      if Src[I] = Ch then begin
        Result := False;
        break;
      end;
  end;
end;


function CreateMask(Src: PChar; TargPos: Integer): string;
  function IsNumber(chr: char): Boolean;
  begin
    if (chr >= '0') and (chr <= '9') then
      Result := True
    else Result := False;
  end;
var
  intFlag, Loop: Boolean;
  Cnt, IntCnt, SrcLen: Integer;
  Ch, Ch2: char;
begin
  intFlag := False;
  Loop := True;
  Cnt := 0;
  IntCnt := 0;
  SrcLen := StrLen(Src);

  while Loop do begin
    Ch := PChar(Longint(Src) + Cnt)^;
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
                      Ch := PChar(Longint(Src) + Cnt - 1)^;
                      if IsNumber(Ch) then begin
                        Ch := PChar(Longint(Src) + Cnt + 1)^;
                        Ch2 := PChar(Longint(Src) + Cnt + 2)^;
                        if not ((Ch = '+') and (IsNumber(Ch2))) then begin
                          intFlag := False;
                        end;
                      end;
                    end;
                  end;
                '+': begin
                    if (Cnt >= 1) and (Cnt + 1 < SrcLen) then begin
                      Ch := PChar(Longint(Src) + Cnt - 1)^;
                      Ch2 := PChar(Longint(Src) + Cnt + 1)^;
                      if not ((UpCase(Ch) = 'E') and (IsNumber(Ch2))) then begin
                        intFlag := False;
                      end;
                    end;
                  end;
                '.': begin
                    if (Cnt >= 1) and (Cnt + 1 < SrcLen) then begin
                      Ch := PChar(Longint(Src) + Cnt - 1)^;
                      Ch2 := PChar(Longint(Src) + Cnt + 1)^;
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
      Result := '%' + Format('%d', [IntCnt]);
      exit;
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
  function IsNumber(Ch: char): Boolean;
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
  Ch, Ch2: char;
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

function GetFileDate(filename: string): Integer; //DOS format file date..
var
  SearchRec: TSearchRec;
begin
  Result := 0; //jacky
  if FindFirst(filename, faAnyFile, SearchRec) = 0 then begin
    Result := SearchRec.Time;
    SysUtils.FindClose(SearchRec);
  end;
end;




procedure ShlStr(Source: PChar; Count: Integer);
var
  I, len: Integer;
begin
  len := StrLen(Source);
  while (Count > 0) do begin
    for I := 0 to len - 2 do
      Source[I] := Source[I + 1];
    Source[len - 1] := #0;

    Dec(Count);
  end;
end;

procedure ShrStr(Source: PChar; Count: Integer);
var
  I, len: Integer;
begin
  len := StrLen(Source);
  while (Count > 0) do begin
    for I := len - 1 downto 0 do
      Source[I + 1] := Source[I];
    Source[len + 1] := #0;

    Dec(Count);
  end;
end;

function LRect(l, t, r, b: Longint): TLRect;
begin
  Result.Left := l;
  Result.Top := t;
  Result.Right := r;
  Result.Bottom := b;
end;

procedure MemPCopy(dest: PChar; Src: string);
var I: Integer;
begin
  for I := 0 to Length(Src) - 1 do dest[I] := Src[I + 1];
end;

procedure MemCpy(dest, Src: PChar; Count: Longint);
var
  I: Longint;
begin
  for I := 0 to Count - 1 do begin
    PChar(Longint(dest) + I)^ := PChar(Longint(Src) + I)^;
  end;
end;

procedure memcpy2(TargAddr, SrcAddr: Longint; Count: Integer);
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    PChar(TargAddr + I)^ := PChar(SrcAddr + I)^;
end;

procedure memset(buffer: PChar; FillChar: char; Count: Integer);
var I: Integer;
begin
  for I := 0 to Count - 1 do
    buffer[I] := FillChar;
end;

procedure Str256PCopy(dest: PChar; const Src: string);
begin
  StrPLCopy(dest, Src, 255);
end;

function _StrPas(dest: PChar): string;
var
  I: Integer;
begin
  Result := '';
  for I := 0 to Length(dest) - 1 do
    if dest[I] <> chr(0) then
      Result := Result + dest[I]
    else
      break;
end;

function Str_PCopy(dest: PChar; Src: string): Integer;
var
  len, I: Integer;
begin
  len := Length(Src);
  for I := 1 to len do dest[I - 1] := Src[I];
  dest[len] := #0;
  Result := len;
end;

function Str_PCopyEx(dest: PChar; const Src: string; buflen: Longint): Integer;
var
  len, I: Integer;
begin
  len := _MIN(Length(Src), buflen);
  for I := 1 to len do dest[I - 1] := Src[I];
  dest[len] := #0;
  Result := len;
end;

function Str_Catch(Src, dest: string; len: Integer): string; //Result is rests..
begin

end;

function Trim_R(const Str: string): string;
var
  I, len, tr: Integer;
begin
  tr := 0;
  len := Length(Str);
  for I := len downto 1 do
    if Str[I] = ' ' then Inc(tr)
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
  I, len: Integer;
  Str: string;
begin
  if Length(Source) > 3 then
    if Canvas.TextWidth(Source) > WantWidth then begin

      len := Length(Source);
      for I := 1 to len do begin

        Str := Copy(Source, 1, (len - I));
        Str := Str + '..';

        if Canvas.TextWidth(Str) < (WantWidth - 4) then begin
          Result := CutHalfCode(Str);
          exit;
        end;

      end;

      Result := CutHalfCode(Copy(Source, 1, 2)) + '..';
      exit;

    end;

  Result := Source;

end;


function DuplicateBitmap(bitmap: TBitmap): HBitmap;
var
  hbmpOldSrc, hbmpOldDest, hbmpNew: HBitmap;
  hdcSrc, hdcDest: HDC;

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


procedure SpliteBitmap(DC: HDC; X, Y: Integer; bitmap: TBitmap; transcolor: TColor);
var
  hdcMixBuffer, hdcBackMask, hdcForeMask, hdcCopy: HDC;
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

  BitBlt(hdcMixBuffer, 0, 0, bitmap.Width, bitmap.Height, DC, X, Y, SRCCOPY);

  BitBlt(hdcMixBuffer, 0, 0, bitmap.Width, bitmap.Height, hdcForeMask, 0, 0, SRCAND);

  BitBlt(hdcCopy, 0, 0, bitmap.Width, bitmap.Height, hdcBackMask, 0, 0, SRCAND);

  BitBlt(hdcMixBuffer, 0, 0, bitmap.Width, bitmap.Height, hdcCopy, 0, 0, SRCPAINT);

  BitBlt(DC, X, Y, bitmap.Width, bitmap.Height, hdcMixBuffer, 0, 0, SRCCOPY);

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

function TagCount(Source: string; tag: char): Integer;
var
  I, tcount: Integer;
begin
  tcount := 0;
  for I := 1 to Length(Source) do
    if Source[I] = tag then Inc(tcount);
  Result := tcount;
end;

{ "xxxxxx" => xxxxxx }
function TakeOffTag(Src: string; tag: char; var rstr: string): string;
var
  I, n2: Integer;
begin
  n2 := Pos(tag, Copy(Src, 2, Length(Src)));
  rstr := Copy(Src, 2, n2 - 1);
  Result := Copy(Src, n2 + 2, Length(Src) - n2);
end;

function CatchString(Source: string; cap: char; var catched: string): string;
var
  n: Integer;
begin
  Result := '';
  catched := '';
  if Source = '' then exit;
  if Length(Source) < 2 then begin
    Result := Source;
    exit;
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

{ GetValidStr3와 달리 식별자가 연속으로 나올경우 처리 안됨 }
{ 식별자가 없을 경우, nil 리턴.. }
function DivString(Source: string; cap: char; var sel: string): string;
var
  n: Integer;
begin
  if Source = '' then begin
    sel := '';
    Result := '';
    exit;
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

function DivTailString(Source: string; cap: char; var sel: string): string;
var
  I, n: Integer;
begin
  if Source = '' then begin
    sel := '';
    Result := '';
    exit;
  end;
  n := 0;
  for I := Length(Source) downto 1 do
    if Source[I] = cap then begin
      n := I;
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
  I, j, len, slen: Integer;
  flag: Boolean;
begin
  Result := -1;
  len := Length(Str);
  slen := Length(substr);
  for I := 0 to len - slen do begin
    flag := True;
    for j := 1 to slen do begin
      if Byte(Str[I + j]) >= $B0 then begin
        if (j < slen) and (I + j < len) then begin
          if substr[j] <> Str[I + j] then begin
            flag := False;
            break;
          end;
          if substr[j + 1] <> Str[I + j + 1] then begin
            flag := False;
            break;
          end;
        end else
          flag := False;
      end else
        if substr[j] <> Str[I + j] then begin
        flag := False;
        break;
      end;
    end;
    if flag then begin
      Result := I + 1;
      break;
    end;
  end;
end;

function NumCopy(Str: string): Integer;
var
  I: Integer;
  data: string;
begin
  data := '';
  for I := 1 to Length(Str) do begin
    if (Word('0') <= Word(Str[I])) and (Word('9') >= Word(Str[I])) then begin
      data := data + Str[I];
    end else
      break;
  end;
  Result := Str_ToInt(data, 0);
end;

function GetMonDay: string;
var
  year, mon, day: Word;
  Str: string;
begin
  DecodeDate(Date, year, mon, day);
  Str := IntToStr(year);
  if mon < 10 then Str := Str + '0' + IntToStr(mon)
  else Str := IntToStr(mon);
  if day < 10 then Str := Str + '0' + IntToStr(day)
  else Str := IntToStr(day);
  Result := Str;
end;

function BoolToStr(boo: Boolean): string;
begin
  if boo then Result := 'TRUE'
  else Result := 'FALSE';
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



end.

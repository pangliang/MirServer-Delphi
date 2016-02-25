{*******************************************************}
{                                                       }
{             MiTeC String Routines                     }
{           version 1.0 for Delphi 5,6                  }
{                                                       }
{       Copyright © 1997,2002 Michal Mutl               }
{                                                       }
{*******************************************************}

{$INCLUDE MITEC_DEF.INC}

unit MiTeC_StrUtils;

interface

uses {$IFDEF D6PLUS} Variants, {$ENDIF} SysUtils, Classes, Windows;

type
  CharSet = set of Char;

function GetStrFromBuf(var Buffer: array of Byte; Len: DWORD): string;
function TrimAll(ASource: string): string;
function BoolToStr(AValue, AVerbose: Boolean): string;
function StrToBool(ASource: string): Boolean;
procedure AddWord(var ADest :string; const AWord,ADelimiter: string);
function GetDelimitedText(AList: TStrings; ADelimiter: string): string;
procedure SetDelimitedText(ASource: string; ADelimiter: string; var AList: TStringList);
function FitStr(const ASource, AEllipsis :string; ALength :integer) :string;
function CenterStr(const ASource: string; ALength :integer; AFillChar: Char = #32) :string;
function LeftPad(const ASource: string; ALength :integer; AFillChar: Char = #32) :string;
function RightPad(const ASource: string; ALength :Integer; AFillChar: Char = #32) :string;
function GetToken(s, adelimiter :string; index :integer) :string;
procedure SetToken(adelimiter, newvalue :string; index :integer; var s :string);
function GetTokenCount(s, adelimiter :string) :integer;
function ExtractWord(N: Byte; S: String; WordDelims: CharSet): string;
function TestByMask(const S, Mask: string; MaskChar: Char): Boolean;

function IsValidNumber(S: string; var V: extended): boolean;
function IsValidDateTime(const S: string; var D: TDateTime): Boolean;
function DequoteStr(Source: string; Quote: Char = '"'): string;
function EncodeBase (I: Int64; Base: Byte): string;

function ListValue(AList: TStrings; AName: string; ASep: string = '='): string;
function NameExists(AList: TStrings; AName: string; ASep: string = '='): integer;
function GetValueFromStr(ASource: string; ASep: string = '='): string;
function GetNameFromStr(ASource: string; ASep: string = '='): string;
function ScanList(AText: string; AList: TStrings): Integer;
procedure AddNameValue(AList: TStrings; AName,AValue: string; ASep: string = '=');

function FormatTimer(ATime: Comp): string;

function IsEmptyString(Source: string): Boolean;

function NormalizeDate(Source: string): string;
function NormalizeNumber(Source: string): string; overload;
function NormalizeNumberEx(Source: string): string; overload;
function NormalizeNumberEx(Source: integer): string; overload;
function NormalizeNumber(Source: Double; APrec: Byte = 2): string; overload;

function QuoteStr(Source: string): string;
function QuoteTrimStr(Source: string): string;
function QuoteTrimStrEx(Source: string): string;

function CustomSort(Value1,Value2: Variant): Integer;

function PosRev(Substring: string; Source: string): integer;

procedure SplitVersion(ASource: string; var Major, Minor: cardinal);

function TrimWideString(Source: WideString): WideString;

{$IFNDEF D6PLUS}
function ReverseString(const AText: string): string;
{$ENDIF}

const
  BooleanEn: array[Boolean] of string = ('No','Yes');
  BooleanCz: array[Boolean] of string = ('Ne','Ano');

resourcestring
  rsTrue = 'True';
  rsFalse = 'False';


implementation

uses Math;

{$IFDEF VER130}

function Sign(const AValue: Integer): Integer; overload;
begin
  Result:=0;
  if AValue<0 then
    Result:=-1
  else
    if AValue>0 then
      Result:=1;
end;

function Sign(const AValue: Double): integer; overload;
begin
  Result:=0;
  if AValue<0 then
    Result:=-1
  else
    if AValue>0 then
      Result:=1;
end;

{$ENDIF}

function TrimAll;
var
  p :integer;
begin
  ASource:=trim(ASource);
  p:=pos(' ',ASource);
  while p>0 do begin
    Delete(ASource,p,1);
    p:=pos(' ',ASource);
  end;
  p:=Pos(#13#10,ASource);
  while p>0 do begin
    Delete(ASource,p,2);
    p:=Pos(#13#10,ASource);
  end;
  result:=ASource;
end;

function booltostr;
begin
  if AValue then begin
    if AVerbose then
      result:=rsTrue
    else
      result:='1';
  end else begin
    if AVerbose then
      result:=rsFalse
    else
      result:='0';
  end;
end;

function StrtoBool;
begin
  Result:=false;
  ASource:=UpperCase(ASource);
  if (ASource='TRUE') or (ASource='1') then
    Result:=true;
end;

procedure AddWord;
begin
  if Length(ADest)>0 then
    ADest:=ADest+ADelimiter+AWord
  else
    ADest:=ADest+AWord;
end;

function GetDelimitedText;
var
  i :integer;
begin
  result:='';
  for i:=0 to AList.Count-1 do
    Result:=Result+AList[i]+ADelimiter;
    if Result<>'' then
      Delete(Result,Length(Result)-Length(ADelimiter)+1,Length(ADelimiter));
end;

procedure SetDelimitedText;
var
  p: integer;
begin
  AList.Clear;
  p:=Pos(ADelimiter,ASource);
  while p>0 do begin
    AList.Add(Copy(ASource,1,p-1));
    Delete(ASource,1,p+Length(Adelimiter)-1);
    p:=Pos(ADelimiter,ASource);
  end;
  AList.Add(ASource);
end;

function CenterStr;
var
  l1,l2: Integer;
begin
  l1:=(ALength-Length(ASource)) div 2;
  l2:=Round((ALength-Length(ASource))/2);
  Result:=StringOfChar(AFillChar,l1)+ASource+StringOfChar(AFillChar,l2);
end;

function LeftPad;
begin
  Result:=ASource+StringOfChar(AFillChar,ALength-Length(ASource));
end;

function RightPad;
begin
  Result:=StringOfChar(AFillChar,ALength-Length(ASource))+ASource;
end;

function FitStr;
var
  lf :integer;
  s :string;
begin
  lf:=Length(ASource);
  if lf>ALength then begin
    result:=Copy(ASource,1,3);
    s:=Copy(ASource,lf-ALength+7,lf);
    result:=Result+AEllipsis+s;
  end else
    result:=ASource;
end;

function GetToken;
var
  i,p :integer;
begin
  p:=pos(adelimiter,s);
  i:=1;
  while (p>0) and (i<index) do begin
    inc(i);
    delete(s,1,p);
    p:=pos(adelimiter,s);
  end;
  result:=copy(s,1,p-1);
end;

procedure SetToken;
var
  i,p,sx,ex :integer;
  s1 :string;
begin
  s1:=s;
  p:=pos(adelimiter,s1);
  sx:=0;
  i:=0;
  while (p>0) and (i<index) do begin
    inc(sx,p);
    inc(i);
    delete(s1,1,p);
    p:=pos(adelimiter,s1);
  end;
  ex:=sx+p;
  s:=copy(s,1,sx)+newvalue+copy(s,ex,255);
end;

function GetTokenCount(s, adelimiter :string) :Integer;
begin
  Result:=0;
  while GetToken(s,adelimiter,Result)<>'' do
    Inc(Result);
end;

function ExtractWord;
Var
  I,J:Word;
  Count:Byte;
  SLen:Integer;
Begin
  Count := 0;
  I := 1;
  Result := '';
  SLen := Length(S);
  While I <= SLen Do Begin
    While (I <= SLen) And (S[I] In WordDelims) Do Inc(I);
    If I <= SLen Then Inc(Count);
    J := I;
    While (J <= SLen) And Not(S[J] In WordDelims) Do Inc(J);
    If Count = N Then Begin
      Result := Copy(S,I,J-I);
      Exit
    End;
    I := J;
  End;
end;

function TestByMask(const S, Mask: string; MaskChar: Char): Boolean;
asm
        TEST    EAX,EAX
        JE      @@qt2
        PUSH    EBX
        TEST    EDX,EDX
        JE      @@qt1
        MOV     EBX,[EAX-4]
        CMP     EBX,[EDX-4]
        JE      @@01
@@qt1:  XOR     EAX,EAX
        POP     EBX
@@qt2:  RET
@@01:   DEC     EBX
        JS      @@07
@@lp:   MOV     CH,BYTE PTR [EDX+EBX]
        CMP     CL,CH
        JNE     @@cm
        DEC     EBX
        JS      @@eq
        MOV     CH,BYTE PTR [EDX+EBX]
        CMP     CL,CH
        JNE     @@cm
        DEC     EBX
        JS      @@eq
        MOV     CH,BYTE PTR [EDX+EBX]
        CMP     CL,CH
        JNE     @@cm
        DEC     EBX
        JS      @@eq
        MOV     CH,BYTE PTR [EDX+EBX]
        CMP     CL,CH
        JNE     @@cm
        DEC     EBX
        JNS     @@lp
        JMP     @@eq
@@cm:   CMP     CH,BYTE PTR [EAX+EBX]
        JNE     @@07
        DEC     EBX
        JNS     @@lp
@@eq:   MOV     EAX,1
        POP     EBX
        RET
@@07:   XOR     EAX,EAX
        POP     EBX
end;

function IsValidNumber(S: string; var V: extended): boolean;
var
  NumCode: integer;
  FirstSpace: integer;
begin
  FirstSpace := Pos(' ', S);
  if FirstSpace > 0 then
    S := Copy(S, 1, FirstSpace - 1);
  Val(S, V, NumCode);
  Result := (NumCode = 0);
  if not Result then
  begin
    // Remove all thousands seperators
    S := StringReplace(S, ThousandSeparator, '', [rfReplaceAll]);
    // change DecimalSeperator to '.' because Val only recognizes that, not
    // the locale specific decimal char.  Stupid Val.
    S := StringReplace(S, DecimalSeparator, '.', [rfReplaceAll]);
    // and try again
    Val(S, V, NumCode);
    Result := (NumCode = 0);
  End;
end;

// date conversion will fail if using long format, e.g. '1 January 1994'
function IsValidDateTime(const S: string; var D: TDateTime): boolean;
var
  i: integer;
  HasDate: boolean;
  HasTime: boolean;
begin
  // Check for two date seperators.  This is because some regions use a "-"
  //  to seperate dates, so if we just checked for one we would flag negative
  //  numbers as being dates.
  i := Pos(DateSeparator, S);
  HasDate := i > 0;
  if HasDate and (i <> Length(S)) then
    HasDate := Pos(DateSeparator, Copy(S, i+1, Length(S)-i)) > 0;
  HasTime := Pos(TimeSeparator, S) > 0;
  Result := HasDate or HasTime;
  if Result then
  begin
    try
      if HasDate and HasTime then
        D := StrToDateTime(S)
      else if HasDate then
        D := StrToDate(S)
      else if HasTime then
        D := StrToTime(S);
    except
      // Something failed to convert...
      D := 0;
      Result := FALSE;
    end;
  end;
end; { IsValidDateTime }

function EncodeBase (I: Int64; Base: Byte): String;
var
  D,J: Int64;
  N: Byte;
const ConversionAlphabeth : String [36] = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
begin
  if I = 0 then begin
     Result := '0';
     exit;
  end;
  D := Round (Power (Base, Trunc (Log10 (I) / Log10 (Base)) + 1));            // +1 to fix occasional real "fuzz"
  J := I;
  Result := '';
  While D > 0 do begin
    N := J div D;
    if (N <> 0) or (Result <> '') then                                      // "fuzz" bug
      Result := Result + ConversionAlphabeth [N + 1];
    J := J mod D;
    D := D div Base;
  end;
end;

function DequoteStr(Source: string; Quote: Char = '"'): string;
begin
  Result:=Source;
  if Length(Source)>1 then
    if (Source[1]=Quote) and (Source[Length(Source)]=Quote) then
      Result:=Copy(Source,2,Length(Source)-2);
end;

{$IFNDEF D6PLUS}
function ReverseString(const AText: string): string;
var
  I: Integer;
  P: PChar;
begin
  SetLength(Result, Length(AText));
  P := PChar(Result);
  for I := Length(AText) downto 1 do
  begin
    P^ := AText[I];
    Inc(P);
  end;
end;
{$ENDIF}

function GetNameFromStr;
var
  p: integer;
begin
  p:=Pos(ASep,ASource);
  if p>0 then
    Result:=Trim(Copy(ASource,1,p-1))
  else
    Result:=ASource;
end;

function ScanList(AText: string; AList: TStrings): Integer;
var
  i: Integer;
begin
  Result:=0;
  AText:=UpperCase(AText);
  for i:=0 to AList.Count-1 do
    if AText=UpperCase(AList[i]) then
      Inc(Result);
end;

procedure AddNameValue;
var
  i: Integer;
begin
  i:=NameExists(AList,AName);
  if i=-1 then
    AList.Add(Format('%s%s%s',[AName,ASep,AValue]))
  else
    AList[i]:=Format('%s%s%s',[AName,ASep,AValue]);
end;

function GetStrFromBuf(var Buffer: array of Byte; Len: DWORD): string;
var
  i,j :integer;
begin
  result:='';
  j:=0;
  i:=0;
  repeat
    if (buffer[i]<>0) then begin
      result:=result+Chr(buffer[i]);
      j:=0;
    end else
      inc(j);
    inc(i);
  until (j>1) or (i=Len);
end;

function ListValue;
var
  i: integer;
begin
  Result:='';
  AName:=UpperCase(AName);
  for i:=0 to Alist.Count-1 do
    if UpperCase(GetNameFromStr(AList[i],ASep))=AName then begin
      Result:=GetValueFromStr(AList[i],ASep);
      Break;
    end;
end;

function NameExists;
var
  i: integer;
begin
  Result:=-1;
  for i:=0 to Alist.Count-1 do
    if SameText(GetNameFromStr(AList[i],ASep),AName) then begin
      Result:=i;
      Break;
    end;
end;

function GetValueFromStr;
var
  p: integer;
begin
  p:=Pos(ASep,ASource);
  if p>0 then
    Result:=Copy(ASource,p+Length(ASep),1024)
  else
    Result:='';
end;

function FormatTimer;
begin
  ATime:=ATime/1000;
  Result:=Format('%2.2d:%2.2d:%2.2d',[Round(ATime) div 3600,
                                      Round(ATime) div 60,
                                      Round(ATime) mod 60]);
end;

function IsEmptyString;
begin
  Result:=Length(Trim(Source))=0;
end;

function NormalizeNumber(Source: string): string;
begin
  if IsEmptyString(Source) then
    Result:='0'
  else
    Result:=StringReplace(Trim(Source),',','.',[rfIgnoreCase]);
end;

function NormalizeNumberEx(Source: string): string;
begin
  if IsEmptyString(Source) then
    Result:='NULL'
  else
    Result:=StringReplace(Trim(Source),',','.',[rfIgnoreCase]);
end;

function NormalizeNumberEx(Source: integer): string;
begin
  if Source=0 then
    Result:='NULL'
  else
    Result:=StringReplace(Trim(IntToStr(Source)),',','.',[rfIgnoreCase]);
end;

function NormalizeNumber(Source: Double; APrec: Byte = 2): string;
begin
  Result:=StringReplace(Trim(Format('%1.'+IntToStr(APrec)+'f',[Source])),',','.',[rfIgnoreCase]);
end;

function NormalizeDate(Source: string): string;
begin
  if IsEmptyString(Source) then
    Result:='NULL'
  else
    Result:=QuoteStr(Source);
end;

function QuoteStr;
begin
  Result:=''''+StringReplace(Source,'''','''''',[rfReplaceAll,rfIgnoreCase])+'''';
end;

function QuoteTrimStr;
begin
  Result:=''''+StringReplace(Trim(Source),'''','''''',[rfReplaceAll,rfIgnoreCase])+'''';
end;

function QuoteTrimStrEx;
begin
  if IsEmptyString(Source) then
    Result:='NULL'
  else
    Result:=''''+StringReplace(Trim(Source),'''','''''',[rfReplaceAll,rfIgnoreCase])+'''';
end;

function CustomSort;
var
  Str1, Str2: string;
  Dbl1,Dbl2: Double;
  Int1,Int2: {$IFDEF D6PLUS} Int64 {$else} Integer {$ENDIF};
begin
  case TVarData(Value1).VType of
    varSmallInt,
    varInteger,

    {$IFDEF D6PLUS}
    varShortInt,
    varWord,
    varLongWord,
    varInt64,
    {$ENDIF}
    varByte


    : begin
      Int1:=Value1;
      Int2:=Value2;
      Result:=Sign(Int1-Int2);
    end;
    varSingle,
    varDouble,
    varCurrency,
    varDate: begin
      Dbl1:=Value1;
      Dbl2:=Value2;
      Result:=Sign(Dbl1-Dbl2);
    end;
    varString
      : begin
      Str1:=VarToStr(Value1);
      Str2:=VarToStr(Value2);
      Result:=AnsiCompareStr(Str1,Str2);
    end;
  end;
end;

function PosRev;
var
  i,l: integer;
  s: string;
begin
  l:=Length(Substring);
  i:=Length(Source)-l;
  repeat
    s:=Copy(Source,i,l);
    Dec(i,l);
  until (CompareText(s,Substring)=0) or (i<1);
  if i>1 then
    Result:=i+l
  else
    Result:=0;
end;

procedure SplitVersion;
var
  p: Integer;
begin
  Major:=0;
  Minor:=0;
  p:=Pos('.',ASource);
  if p>0 then begin
    try
      Major:=StrToInt(Copy(ASource,1,p-1));
      Minor:=StrToInt(Copy(ASource,p+1,255));
    except
    end;
  end;
end;

function TrimWideString;
var
  p: integer;
begin
  p:=Pos(#0,Source);
  if p>0 then
    Result:=Copy(Source,1,p-1)
  else
    Result:=Source;

end;

end.

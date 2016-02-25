unit EDcode;

interface

uses
  Windows, SysUtils, Classes, HUtil32, Grobal2;

function EncodeMessage(sMsg: TDefaultMessage): string;
function DecodeMessage(Str: string): TDefaultMessage;
function EncodeString(Str: string): string;
function DecodeString(Str: string): string;
function EncodeBuffer(Buf: PChar; bufsize: Integer): string;
procedure DecodeBuffer(Src: string; Buf: PChar; bufsize: Integer);
function MakeDefaultMsg(wIdent: Word; nRecog: Integer; wParam, wTag, wSeries: Word): TDefaultMessage;
var
  CSEncode: TRTLCriticalSection;
implementation
var
  EncBuf, TempBuf: PChar;
procedure Encode6BitBuf(Src, dest: PChar; SrcLen, destlen: Integer);
var
  I, restcount, destpos: Integer;
  made, Ch, rest: Byte;
begin
  try
    restcount := 0;
    rest := 0;
    destpos := 0;
    for I := 0 to SrcLen - 1 do begin
      if destpos >= destlen then break;
      Ch := Byte(Src[I]);
      made := Byte((rest or (Ch shr (2 + restcount))) and $3F);
      rest := Byte(((Ch shl (8 - (2 + restcount))) shr 2) and $3F);
      Inc(restcount, 2);

      if restcount < 6 then begin
        dest[destpos] := Char(made + $3C);
        Inc(destpos);
      end else begin
        if destpos < destlen - 1 then begin
          dest[destpos] := Char(made + $3C);
          dest[destpos + 1] := Char(rest + $3C);
          Inc(destpos, 2);
        end else begin
          dest[destpos] := Char(made + $3C);
          Inc(destpos);
        end;
        restcount := 0;
        rest := 0;
      end;

    end;
    if restcount > 0 then begin
      dest[destpos] := Char(rest + $3C);
      Inc(destpos);
    end;
    dest[destpos] := #0;
  except
  end;
end;

procedure Decode6BitBuf(Source: string; Buf: PChar; buflen: Integer);
const
  Masks: array[2..6] of Byte = ($FC, $F8, $F0, $E0, $C0);
  //($FE, $FC, $F8, $F0, $E0, $C0, $80, $00);
var
  I, len, bitpos, madebit, bufpos: Integer;
  Ch, tmp, _byte: Byte;
begin
  Ch := 0; //Jacky
  try
    len := length(Source);
    bitpos := 2;
    madebit := 0;
    bufpos := 0;
    tmp := 0;
    for I := 1 to len do begin
      if Integer(Source[I]) - $3C >= 0 then
        Ch := Byte(Source[I]) - $3C
      else begin
        bufpos := 0;
        break;
      end;
      if bufpos >= buflen then break;
      if (madebit + 6) >= 8 then begin
        _byte := Byte(tmp or ((Ch and $3F) shr (6 - bitpos)));
        Buf[bufpos] := Char(_byte);
        Inc(bufpos);
        madebit := 0;
        if bitpos < 6 then Inc(bitpos, 2)
        else begin
          bitpos := 2;
          Continue;
        end;
      end;
      tmp := Byte(Byte(Ch shl bitpos) and Masks[bitpos]); // #### ##--
      Inc(madebit, 8 - bitpos);
    end;
    Buf[bufpos] := #0;
  except
  end;
end;

function DecodeMessage(Str: string): TDefaultMessage;
var
  msg: TDefaultMessage;
begin
  try
    EnterCriticalSection(CSEncode);
    Decode6BitBuf(Str, EncBuf, 1024);
    Move(EncBuf^, msg, SizeOf(TDefaultMessage));
    Result := msg;
  finally
    LeaveCriticalSection(CSEncode);
  end;
end;

function DecodeString(Str: string): string;
begin
  try
    EnterCriticalSection(CSEncode);
    Decode6BitBuf(Str, EncBuf, BUFFERSIZE);
    Result := StrPas(EncBuf); //error, 1, 2, 3,...
  finally
    LeaveCriticalSection(CSEncode);
  end;
end;

procedure DecodeBuffer(Src: string; Buf: PChar; bufsize: Integer);
begin
  try
    EnterCriticalSection(CSEncode);
    Decode6BitBuf(Src, EncBuf, BUFFERSIZE);
    Move(EncBuf^, Buf^, bufsize);
  finally
    LeaveCriticalSection(CSEncode);
  end;
end;

function EncodeMessage(sMsg: TDefaultMessage): string;
begin
  try
    EnterCriticalSection(CSEncode);
    Move(sMsg, TempBuf^, SizeOf(TDefaultMessage));
    Encode6BitBuf(TempBuf, EncBuf, SizeOf(TDefaultMessage), 1024);
    Result := StrPas(EncBuf); //Error: 1, 2, 3, 4, 5, 6, 7, 8, 9
  finally
    LeaveCriticalSection(CSEncode);
  end;
end;

function EncodeString(Str: string): string;
begin
  try
    EnterCriticalSection(CSEncode);
    Encode6BitBuf(PChar(Str), EncBuf, length(Str), BUFFERSIZE);
    Result := StrPas(EncBuf);
  finally
    LeaveCriticalSection(CSEncode);
  end;
end;

function EncodeBuffer(Buf: PChar; bufsize: Integer): string;
begin
  try
    EnterCriticalSection(CSEncode);
    if bufsize < BUFFERSIZE then begin
      Move(Buf^, TempBuf^, bufsize);
      Encode6BitBuf(TempBuf, EncBuf, bufsize, BUFFERSIZE);
      Result := StrPas(EncBuf);
    end else
      Result := '';
  finally
    LeaveCriticalSection(CSEncode);
  end;
end;

function MakeDefaultMsg(wIdent: Word; nRecog: Integer; wParam, wTag, wSeries: Word): TDefaultMessage;
begin
  Result.Recog := nRecog;
  Result.Ident := wIdent;
  Result.Param := wParam;
  Result.tag := wTag;
  Result.Series := wSeries;
end;
initialization
  begin
    GetMem(EncBuf, 10240 + 100); //BUFFERSIZE + 100);
    GetMem(TempBuf, 10240); //2048);
    InitializeCriticalSection(CSEncode);
  end;
finalization
  begin
    //FreeMem (EncBuf, BUFFERSIZE + 100);
      //FreeMem (TempBuf, 2048);
    DeleteCriticalSection(CSEncode);
  end;

end.

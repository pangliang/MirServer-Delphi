unit EDcode;

interface

uses
  Windows, SysUtils, Classes, Hutil32, EngineType;

function EncodeMessage(smsg: _TDEFAULTMESSAGE): string;
function DecodeMessage(str: string): _TDEFAULTMESSAGE;
function EncodeString(str: string): string;
function DecodeString(str: string): string;
function EncodeBuffer(buf: pChar; bufsize: integer): string;
procedure DecodeBuffer(src: string; buf: pChar; bufsize: integer);
function MakeDefaultMsg(wIdent: Word; nRecog: integer; wParam, wTag, wSeries: Word): _TDEFAULTMESSAGE;
var
  CSEncode: TRTLCriticalSection;

implementation

var
  EncBuf, TempBuf: pChar;
procedure Encode6BitBuf(src, dest: pChar; srclen, destlen: integer);
var
  i, restcount, destpos: integer;
  made, ch, rest: byte;
begin
  try
    restcount := 0;
    rest := 0;
    destpos := 0;
    for i := 0 to srclen - 1 do begin
      if destpos >= destlen then break;
      ch := byte(src[i]);
      made := byte((rest or (ch shr (2 + restcount))) and $3F);
      rest := byte(((ch shl (8 - (2 + restcount))) shr 2) and $3F);
      Inc(restcount, 2);

      if restcount < 6 then begin
        dest[destpos] := char(made + $3C);
        Inc(destpos);
      end else begin
        if destpos < destlen - 1 then begin
          dest[destpos] := char(made + $3C);
          dest[destpos + 1] := char(rest + $3C);
          Inc(destpos, 2);
        end else begin
          dest[destpos] := char(made + $3C);
          Inc(destpos);
        end;
        restcount := 0;
        rest := 0;
      end;

    end;
    if restcount > 0 then begin
      dest[destpos] := char(rest + $3C);
      Inc(destpos);
    end;
    dest[destpos] := #0;
  except
  end;
end;

procedure Decode6BitBuf(source: string; buf: pChar; buflen: integer);
const
  Masks: array[2..6] of byte = ($FC, $F8, $F0, $E0, $C0);
  //($FE, $FC, $F8, $F0, $E0, $C0, $80, $00);
var
  i, len, bitpos, madebit, bufpos: integer;
  ch, tmp, _byte: byte;
begin
  ch := 0; //Jacky
  try
    len := Length(source);
    bitpos := 2;
    madebit := 0;
    bufpos := 0;
    tmp := 0;
    for i := 1 to len do begin
      if integer(source[i]) - $3C >= 0 then
        ch := byte(source[i]) - $3C
      else begin
        bufpos := 0;
        break;
      end;

      if bufpos >= buflen then break;

      if (madebit + 6) >= 8 then begin
        _byte := byte(tmp or ((ch and $3F) shr (6 - bitpos)));
        buf[bufpos] := char(_byte);
        Inc(bufpos);
        madebit := 0;
        if bitpos < 6 then Inc(bitpos, 2)
        else begin
          bitpos := 2;
          continue;
        end;
      end;

      tmp := byte(byte(ch shl bitpos) and Masks[bitpos]); // #### ##--
      Inc(madebit, 8 - bitpos);
    end;
    buf[bufpos] := #0;
  except
  end;
end;


function DecodeMessage(str: string): _TDEFAULTMESSAGE;
var
  msg: _TDEFAULTMESSAGE;
begin
  try
    EnterCriticalSection(CSEncode);
    Decode6BitBuf(str, EncBuf, 1024);
    Move(EncBuf^, msg, sizeof(_TDEFAULTMESSAGE));
    Result := msg;
  finally
    LeaveCriticalSection(CSEncode);
  end;
end;


function DecodeString(str: string): string;
begin
  try
    EnterCriticalSection(CSEncode);
    Decode6BitBuf(str, EncBuf, BUFFERSIZE);
    Result := StrPas(EncBuf); //error, 1, 2, 3,...
  finally
    LeaveCriticalSection(CSEncode);
  end;
end;

procedure DecodeBuffer(src: string; buf: pChar; bufsize: integer);
begin
  try
    EnterCriticalSection(CSEncode);
    Decode6BitBuf(src, EncBuf, BUFFERSIZE);
    Move(EncBuf^, buf^, bufsize);
  finally
    LeaveCriticalSection(CSEncode);
  end;
end;


function EncodeMessage(smsg: _TDEFAULTMESSAGE): string;
begin
  try
    EnterCriticalSection(CSEncode);
    Move(smsg, TempBuf^, sizeof(_TDEFAULTMESSAGE));
    Encode6BitBuf(TempBuf, EncBuf, sizeof(_TDEFAULTMESSAGE), 1024);
    Result := StrPas(EncBuf); //Error: 1, 2, 3, 4, 5, 6, 7, 8, 9
  finally
    LeaveCriticalSection(CSEncode);
  end;
end;


function EncodeString(str: string): string;
begin
  try
    EnterCriticalSection(CSEncode);
    Encode6BitBuf(pChar(str), EncBuf, Length(str), BUFFERSIZE);
    Result := StrPas(EncBuf);
  finally
    LeaveCriticalSection(CSEncode);
  end;
end;


function EncodeBuffer(buf: pChar; bufsize: integer): string;
begin
  try
    EnterCriticalSection(CSEncode);
    if bufsize < BUFFERSIZE then begin
      Move(buf^, TempBuf^, bufsize);
      Encode6BitBuf(TempBuf, EncBuf, bufsize, BUFFERSIZE);
      Result := StrPas(EncBuf);
    end else
      Result := '';
  finally
    LeaveCriticalSection(CSEncode);
  end;
end;
function MakeDefaultMsg(wIdent: Word; nRecog: integer; wParam, wTag, wSeries: Word): _TDEFAULTMESSAGE;
begin
  Result.nRecog := nRecog;
  Result.wIdent := wIdent;
  Result.wParam := wParam;
  Result.wTag := wTag;
  Result.wSeries := wSeries;
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


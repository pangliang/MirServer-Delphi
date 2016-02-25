unit EDcode;

interface

uses
	Windows, SysUtils, Classes, Hutil32, Grobal2;

   function  EncodeMessage (smsg: TDefaultMessage): string;
   function DecodeMessage (str: string): TDefaultMessage;
   function EncodeString (str: string): string;
   function DecodeString (str: string): string;
   function  EncodeBuffer (buf: pChar; bufsize: integer): string;
   procedure DecodeBuffer (src: string; buf: PChar; bufsize: integer);
   function MakeDefaultMsg(wIdent: Word;nRecog: Integer; wParam, wTag, wSeries: Word):TDefaultMessage;
var
	CSEncode: TRTLCriticalSection;

implementation

var
  EncBuf, TempBuf: PChar;
procedure Encode6BitBuf (src, dest: PChar; srclen, destlen: integer);
var
   i, restcount, destpos: integer;
   made, ch, rest: byte;
begin
try
   restcount := 0;
   rest 		 := 0;
   destpos	 := 0;
   for i:=0 to srclen - 1 do begin
      if destpos >= destlen then break;
      ch := byte (src[i]);
      made := byte ((rest or (ch shr (2+restcount))) and $3F);
      rest := byte (((ch shl (8 - (2+restcount))) shr 2) and $3F);
      Inc (restcount, 2);

      if restcount < 6 then begin
      	dest[destpos] := char(made + $3C);
         Inc (destpos);
      end else begin
      	if destpos < destlen-1 then begin
            dest[destpos]   := char(made + $3C);
            dest[destpos+1] := char(rest + $3C);
            Inc (destpos, 2);
         end else begin
            dest[destpos]   := char(made + $3C);
            Inc (destpos);
         end;
         restcount := 0;
         rest := 0;
      end;

   end;
   if restcount > 0 then begin
   	dest[destpos] := char (rest + $3C);
      Inc (destpos);
   end;
   dest[destpos] := #0;
except
end;
end;

procedure Decode6BitBuf (source: string; buf: PChar; buflen: integer);
const
	Masks: array[2..6] of byte = ($FC, $F8, $F0, $E0, $C0);
   //($FE, $FC, $F8, $F0, $E0, $C0, $80, $00);
var
	i, len, bitpos, madebit, bufpos: integer;
   ch, tmp, _byte: Byte;
begin
  ch:=0;//Jacky
try
	len := Length (source);
   bitpos  := 2;
   madebit := 0;
   bufpos  := 0;
   tmp	  := 0;
   for i:=1 to len do begin
   	if Integer(source[i]) - $3C >= 0 then
   		ch := Byte(source[i]) - $3C
      else begin
         bufpos := 0;
      	break;
    	end;

      if bufpos >= buflen then break;

      if (madebit+6) >= 8 then begin
         _byte := Byte(tmp or ((ch and $3F) shr (6-bitpos)));
         buf[bufpos] := Char(_byte);
         Inc (bufpos);
         madebit := 0;
         if bitpos < 6 then Inc (bitpos, 2)
         else begin
         	bitpos := 2;
            continue;
         end;
      end;

      tmp := Byte (Byte(ch shl bitpos) and Masks[bitpos]);   // #### ##--
      Inc (madebit, 8-bitpos);
   end;
   buf [bufpos] := #0;
except
end;
end;


function DecodeMessage (str: string): TDefaultMessage;
var
   msg: TDefaultMessage;
begin
   try
      EnterCriticalSection (CSencode);
      Decode6BitBuf (str, EncBuf, 1024);
      Move (EncBuf^, msg, sizeof(TDefaultMessage));
      Result := msg;
   finally
   	LeaveCriticalSection (CSencode);
   end;
end;


function DecodeString (str: string): string;
begin
   try
      EnterCriticalSection (CSencode);
      Decode6BitBuf (str, EncBuf, BUFFERSIZE);
      Result := StrPas (EncBuf); //error, 1, 2, 3,...
   finally
      LeaveCriticalSection (CSencode);
   end;
end;

procedure DecodeBuffer (src: string; buf: PChar; bufsize: integer);
begin
   try
      EnterCriticalSection (CSencode);
      Decode6BitBuf (src, EncBuf, BUFFERSIZE);
      Move (EncBuf^, buf^, bufsize);
   finally
   	LeaveCriticalSection (CSencode);
   end;
end;


function  EncodeMessage (smsg: TDefaultMessage): string;
begin
   try
   	EnterCriticalSection (CSencode);
      Move (smsg, TempBuf^, sizeof(TDefaultMessage));
      Encode6BitBuf (TempBuf, EncBuf, sizeof(TDefaultMessage), 1024);
      Result := StrPas (EncBuf);  //Error: 1, 2, 3, 4, 5, 6, 7, 8, 9
   finally
   	LeaveCriticalSection (CSencode);
   end;
end;


function EncodeString (str: string): string;
begin
   try
   	EnterCriticalSection (CSencode);
      Encode6BitBuf (PChar(str), EncBuf, Length(str), BUFFERSIZE);
      Result := StrPas (EncBuf);
   finally
   	LeaveCriticalSection (CSencode);
   end;
end;


function  EncodeBuffer (buf: pChar; bufsize: integer): string;
begin
   try
      EnterCriticalSection (CSencode);
      if bufsize < BUFFERSIZE then begin
         Move (buf^, TempBuf^, bufsize);
         Encode6BitBuf (TempBuf, EncBuf, bufsize, BUFFERSIZE);
         Result := StrPas (EncBuf);
      end else
         Result := '';
   finally
   	LeaveCriticalSection (CSencode);
   end;
end;
function MakeDefaultMsg(wIdent: Word;nRecog: Integer; wParam, wTag, wSeries: Word):TDefaultMessage;
begin
  Result.Recog:=nRecog;
  Result.Ident:=wIdent;
  Result.Param:=wParam;
  Result.Tag:=wTag;
  Result.Series:=wSeries;
end;
initialization
begin
	GetMem (EncBuf, 10240 + 100); //BUFFERSIZE + 100);
	GetMem (TempBuf, 10240); //2048);
   InitializeCriticalSection (CSEncode);
end;


finalization
begin
	//FreeMem (EncBuf, BUFFERSIZE + 100);
   //FreeMem (TempBuf, 2048);
   DeleteCriticalSection (CSEncode);
end;


end.

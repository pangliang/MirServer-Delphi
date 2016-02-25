unit HUtil32;

interface

uses
  SysUtils;

function Str_ToInt(Str: string; def: Longint): Longint;
function GetValidStr3(Str: string; var Dest: string; const Divider: array of Char): string;
implementation

function Str_ToInt(Str: string; def: Longint): Longint;
begin
  Result := def;
  if Str <> '' then begin
    if ((word(Str[1]) >= word('0')) and (word(Str[1]) <= word('9'))) or
      (Str[1] = '+') or (Str[1] = '-') then try
      Result := StrToInt64Def(Str, def);
      //Result := StrToInt64 (Str);
      //Result := StrToIntDef (Str,def);
    except
    end;
  end;
end;

function GetValidStr3(Str: string; var Dest: string; const Divider: array of Char): string;
const
  BUF_SIZE = 20480; //$7FFF;
var
  Buf: array[0..BUF_SIZE] of Char;
  nBufCount, nCount, nSrcLen, I, nArrCount: Longint;
  Ch: Char;
label
  CATCH_DIV;
begin
  Ch := #0; //Jacky
  try
    nSrcLen := length(Str);
    nBufCount := 0;
    nCount := 1;

    if nSrcLen >= BUF_SIZE - 1 then begin
      Result := '';
      Dest := '';
      Exit;
    end;

    if Str = '' then begin
      Dest := '';
      Result := Str;
      Exit;
    end;
    nArrCount := SizeOf(Divider) div SizeOf(Char);

    while TRUE do begin
      if nCount <= nSrcLen then begin
        Ch := Str[nCount];
        for I := 0 to nArrCount - 1 do
          if Ch = Divider[I] then
            goto CATCH_DIV;
      end;
      if (nCount > nSrcLen) then begin
        CATCH_DIV:
        if (nBufCount > 0) then begin
          if nBufCount < BUF_SIZE - 1 then begin
            Buf[nBufCount] := #0;
            Dest := string(Buf);
            Result := Copy(Str, nCount + 1, nSrcLen - nCount);
          end;
          break;
        end else begin
          if (nCount > nSrcLen) then begin
            Dest := '';
            Result := Copy(Str, nCount + 2, nSrcLen - 1);
            break;
          end;
        end;
      end else begin
        if nBufCount < BUF_SIZE - 1 then begin
          Buf[nBufCount] := Ch;
          Inc(nBufCount);
        end; // else
        //ShowMessage ('BUF_SIZE overflow !');
      end;
      Inc(nCount);
    end;
  except
    Dest := '';
    Result := '';
  end;
end;
end.

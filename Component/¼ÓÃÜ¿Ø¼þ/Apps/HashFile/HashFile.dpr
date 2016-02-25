{******************************************************************************}
{* DCPcrypt v2.0 written by David Barton (davebarton@bigfoot.com) *************}
{******************************************************************************}
{* HashFile - A sample program which produces hashes of files *****************}
{******************************************************************************}
{* Copyright (c) 1999-2000 David Barton                                       *}
{* Permission is hereby granted, free of charge, to any person obtaining a    *}
{* copy of this software and associated documentation files (the "Software"), *}
{* to deal in the Software without restriction, including without limitation  *}
{* the rights to use, copy, modify, merge, publish, distribute, sublicense,   *}
{* and/or sell copies of the Software, and to permit persons to whom the      *}
{* Software is furnished to do so, subject to the following conditions:       *}
{*                                                                            *}
{* The above copyright notice and this permission notice shall be included in *}
{* all copies or substantial portions of the Software.                        *}
{*                                                                            *}
{* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR *}
{* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,   *}
{* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL    *}
{* THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER *}
{* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING    *}
{* FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER        *}
{* DEALINGS IN THE SOFTWARE.                                                  *}
{******************************************************************************}
{$IFNDEF FPK}
  {$APPTYPE CONSOLE}
{$ENDIF}
program HashFile;

uses
  Classes, Sysutils, DCPcrypt, Haval, MD4, MD5, Rmd160, Sha1;

var
  Hash: TDCP_hash;
  Source: TFileStream;
  Digest: array[0..31] of byte; { Set to the size of the biggest hash digest }
  i, j, Found: integer;
  s: string;
  SRec: TSearchRec;
begin
  if ParamCount= 0 then
  begin
    Writeln('HashFile [-h<hashname>] <filename1> [<filename2> ... ]');
    Exit;
  end;
  if Copy(ParamStr(1),1,2)= '-h' then { Select the type of hash we want to use }
  begin
    i:= 2;
    Hash:= DCPhashfromname(Copy(ParamStr(1),3,Length(ParamStr(1))-2),nil);
  end
  else
  begin
    i:= 1;
    Hash:= TDCP_md5.Create(nil);
  end;
  if Hash= nil then      { Make sure we have the algorithm requested }
  begin
    Writeln('Hash algorithm not implemented');
    Exit;
  end;
  for i:= i to ParamCount do  { Cycle through all the files specified }
  begin
    Found:= FindFirst(ParamStr(i),faReadOnly or faSysFile,SRec); { Use FindFirst so we can specify wild cards in the filename }
    if Found<> 0 then
      Writeln('File not found - ',ParamStr(i));
    while Found= 0 do
    begin
      Hash.Init;   { Initialize the hash }
      try
        Source:= TFileStream.Create(SRec.Name,fmOpenRead); { Open the file for reading }
        Hash.UpdateStream(Source,Source.Size);  { Hash the file }
        Hash.Final(Digest);  { Produce the digest }
        s:= SRec.Name+' ';
        while Length(s)< 30 do
          s:= s+' ';
        for j:= 0 to ((Hash.HashSize shr 3) - 1) do  { Convert the digest to a hex string }
          s:= s + IntToHex(Digest[j],2);
        Writeln(s);
        Source.Free;
        Source:= nil;
      except
        Writeln('Unable to access file - ',SRec.Name);  { Oh no! }
        Hash.Burn;
        Source.Free;
      end;
      Found:= FindNext(SRec);   { Find the next file }
    end;
    FindClose(SRec);
  end;
  Hash.Free;   { We're all done }
end.

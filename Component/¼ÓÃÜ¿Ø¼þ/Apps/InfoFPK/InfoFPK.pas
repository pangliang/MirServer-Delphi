{******************************************************************************}
{* DCPcrypt v2.0 written by David Barton (davebarton@bigfoot.com) *************}
{******************************************************************************}
{* A program to display information about the ciphers and hashes **************}
{* For the Free Pascal Compiler - http://www.freepascal.org/ ******************}
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
program tester;
uses
  Crt, Sysutils, DCPcrypt, Blowfish, Cast128, Cast256, DES, Gost, Ice, Idea,
  Mars, Misty1, RC2, RC4, RC5, RC6, Rijndael, Twofish,
  Haval, MD4, MD5, Rmd160, SHA1;

procedure Main;
var
  Passed, Failed: integer;
  NextCipher: PDCP_cipherinfo;
  NextHash: PDCP_hashinfo;
  s: string;
begin
  Clrscr;
  Passed:= 0; Failed:= 0;
  NextCipher:= DCPcipherlist;
  Writeln('-------------------- Ciphers --------------------');
  while (NextCipher<> nil) do
  begin
    s:= NextCipher^.Cipher.GetAlgorithm;
    while Length(s)< 15 do
      s:= s + ' ';
    Write(s);
    if NextCipher^.Block then
    begin
      s:= IntToStr(TDCP_blockcipherclass(NextCipher^.Cipher).GetBlockSize) + 'bits';
      while Length(s)< 8 do
        s:= ' ' + s;
      Write(s);
    end
    else
      Write('     N/A');
    s:= IntToStr(NextCipher^.Cipher.GetMaxKeySize) + 'bits';
    while Length(s)< 10 do
      s:= ' ' + s;
    Write(s);
    s:= IntToStr(NextCipher^.Id);
    while Length(s)< 5 do
      s:= ' ' + s;
    Write(s);
    if NextCipher^.Cipher.SelfTest then
    begin
      Writeln('   Verified');
      Inc(Passed);
    end
    else
    begin
      Writeln('   Failed');
      Inc(Failed);
    end;
    NextCipher:= NextCipher^.Next;
  end;
  Writeln(Passed:4,' ciphers passed');
  Writeln(Failed:4,' ciphers failed');
  Inc(Passed,Failed);
  Writeln(Passed:4,' ciphers in total');
  Writeln;
  Passed:= 0; Failed:= 0;
  NextHash:= DCPhashlist;
  Writeln('---------------- Hashes -----------------');
  while (NextHash<> nil) do
  begin
    s:= NextHash^.Hash.GetAlgorithm;
    while Length(s)< 15 do
      s:= s + ' ';
    Write(s);
    s:= IntToStr(NextHash^.Hash.GetHashSize) + 'bits';
    while Length(s)< 10 do
      s:= ' ' + s;
    Write(s);
    s:= IntToStr(NextHash^.Id);
    while Length(s)< 5 do
      s:= ' ' + s;
    Write(s);
    if NextHash^.Hash.SelfTest then
    begin
      Writeln('   Verified');
      Inc(Passed);
    end
    else
    begin
      Writeln('   Failed');
      Inc(Failed);
    end;
    NextHash:= NextHash^.Next;
  end;
  Writeln(Passed:4,' hashes passed');
  Writeln(Failed:4,' hashes failed');
  Inc(Passed,Failed);
  Writeln(Passed:4,' hashes in total');
end;

begin
  Main();
end.

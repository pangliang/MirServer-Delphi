{******************************************************************************}
{* DCPcrypt v2.0 written by David Barton (davebarton@bigfoot.com) *************}
{******************************************************************************}
{* Component registration unit ************************************************}
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
unit DCPreg;

interface
uses
  Classes, DCPcrypt, DCPconst,
  { Ciphers }
  Blowfish, Cast128, Cast256, DES, Gost, Ice, IDEA, Mars, Misty1, RC2, RC4, RC5,
  RC6, Rijndael, Twofish,
  { Hashes }
  Haval, Md4, Md5, Rmd160, Sha1;


procedure Register;



{******************************************************************************}
{******************************************************************************}
implementation

{$IFDEF WIN32}
{$R Dcr32\Ciphers.dcr}
{$R Dcr32\Hashes.dcr}
{$ELSE}
{$ENDIF}

procedure Register;
begin
  { Ciphers }
  RegisterComponents(DCPcipherpage,[TDCP_blowfish,TDCP_cast128,TDCP_cast256,
    TDCP_des,TDCP_3des,TDCP_gost,TDCP_ice,TDCP_ice2,TDCP_thinice,TDCP_idea,
    TDCP_mars,TDCP_misty1,TDCP_rc2,TDCP_rc4,TDCP_rc5,TDCP_rc6,TDCP_rijndael,
    TDCP_twofish]);
  { Hashes }
  RegisterComponents(DCPhashpage,[TDCP_haval,TDCP_md4,TDCP_md5,TDCP_ripemd160,
    TDCP_sha1]);
end;

end.

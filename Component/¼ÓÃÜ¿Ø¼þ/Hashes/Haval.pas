{******************************************************************************}
{* DCPcrypt v2.0 written by David Barton (davebarton@bigfoot.com) *************}
{******************************************************************************}
{* A binary compatible implementation of Haval ********************************}
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
unit Haval;

interface
uses
  Classes, Sysutils, DCPcrypt, DCPconst;

type
  TDCP_haval= class(TDCP_hash)
  protected
    LenHi: longint;
    LenLo2, LenLo1: word; { annoying fix for D1-3 users who don't have longword }
    Index: DWord;
    CurrentHash: array[0..7] of DWord;
    HashBuffer: array[0..127] of byte;
    procedure Compress;
  public
    class function GetId: longint; override;
    class function GetAlgorithm: string; override;
    class function GetHashSize: longint; override;
    class function SelfTest: boolean; override;
    procedure Init; override;
    procedure Burn; override;
    procedure Update(const Buffer; Size: longint); override;
    procedure Final(var Digest); override;
  end;



{******************************************************************************}
{******************************************************************************}
implementation
{$R-}{$Q-}

procedure TDCP_haval.Compress;
var
  t7, t6, t5, t4, t3, t2, t1, t0: DWord;
  W: array[0..31] of DWord;
  Temp: dword;
begin
  t0:= CurrentHash[0];
  t1:= CurrentHash[1];
  t2:= CurrentHash[2];
  t3:= CurrentHash[3];
  t4:= CurrentHash[4];
  t5:= CurrentHash[5];
  t6:= CurrentHash[6];
  t7:= CurrentHash[7];
  Move(HashBuffer,W,Sizeof(W));

  Temp:= ((t2) and ((t6) xor (t1)) xor (t5) and (t4) xor (t0) and (t3) xor (t6));
  t7:= ((temp shr 7) or (temp shl 25)) + ((t7 shr 11) or (t7 shl 21)) + w[ 0];
  Temp:= ((t1) and ((t5) xor (t0)) xor (t4) and (t3) xor (t7) and (t2) xor (t5));
  t6:= ((temp shr 7) or (temp shl 25)) + ((t6 shr 11) or (t6 shl 21)) + w[ 1];
  Temp:= ((t0) and ((t4) xor (t7)) xor (t3) and (t2) xor (t6) and (t1) xor (t4));
  t5:= ((temp shr 7) or (temp shl 25)) + ((t5 shr 11) or (t5 shl 21)) + w[ 2];
  Temp:= ((t7) and ((t3) xor (t6)) xor (t2) and (t1) xor (t5) and (t0) xor (t3));
  t4:= ((temp shr 7) or (temp shl 25)) + ((t4 shr 11) or (t4 shl 21)) + w[ 3];
  Temp:= ((t6) and ((t2) xor (t5)) xor (t1) and (t0) xor (t4) and (t7) xor (t2));
  t3:= ((temp shr 7) or (temp shl 25)) + ((t3 shr 11) or (t3 shl 21)) + w[ 4];
  Temp:= ((t5) and ((t1) xor (t4)) xor (t0) and (t7) xor (t3) and (t6) xor (t1));
  t2:= ((temp shr 7) or (temp shl 25)) + ((t2 shr 11) or (t2 shl 21)) + w[ 5];
  Temp:= ((t4) and ((t0) xor (t3)) xor (t7) and (t6) xor (t2) and (t5) xor (t0));
  t1:= ((temp shr 7) or (temp shl 25)) + ((t1 shr 11) or (t1 shl 21)) + w[ 6];
  Temp:= ((t3) and ((t7) xor (t2)) xor (t6) and (t5) xor (t1) and (t4) xor (t7));
  t0:= ((temp shr 7) or (temp shl 25)) + ((t0 shr 11) or (t0 shl 21)) + w[ 7];

  Temp:= ((t2) and ((t6) xor (t1)) xor (t5) and (t4) xor (t0) and (t3) xor (t6));
  t7:= ((temp shr 7) or (temp shl 25)) + ((t7 shr 11) or (t7 shl 21)) + w[ 8];
  Temp:= ((t1) and ((t5) xor (t0)) xor (t4) and (t3) xor (t7) and (t2) xor (t5));
  t6:= ((temp shr 7) or (temp shl 25)) + ((t6 shr 11) or (t6 shl 21)) + w[ 9];
  Temp:= ((t0) and ((t4) xor (t7)) xor (t3) and (t2) xor (t6) and (t1) xor (t4));
  t5:= ((temp shr 7) or (temp shl 25)) + ((t5 shr 11) or (t5 shl 21)) + w[10];
  Temp:= ((t7) and ((t3) xor (t6)) xor (t2) and (t1) xor (t5) and (t0) xor (t3));
  t4:= ((temp shr 7) or (temp shl 25)) + ((t4 shr 11) or (t4 shl 21)) + w[11];
  Temp:= ((t6) and ((t2) xor (t5)) xor (t1) and (t0) xor (t4) and (t7) xor (t2));
  t3:= ((temp shr 7) or (temp shl 25)) + ((t3 shr 11) or (t3 shl 21)) + w[12];
  Temp:= ((t5) and ((t1) xor (t4)) xor (t0) and (t7) xor (t3) and (t6) xor (t1));
  t2:= ((temp shr 7) or (temp shl 25)) + ((t2 shr 11) or (t2 shl 21)) + w[13];
  Temp:= ((t4) and ((t0) xor (t3)) xor (t7) and (t6) xor (t2) and (t5) xor (t0));
  t1:= ((temp shr 7) or (temp shl 25)) + ((t1 shr 11) or (t1 shl 21)) + w[14];
  Temp:= ((t3) and ((t7) xor (t2)) xor (t6) and (t5) xor (t1) and (t4) xor (t7));
  t0:= ((temp shr 7) or (temp shl 25)) + ((t0 shr 11) or (t0 shl 21)) + w[15];

  Temp:= ((t2) and ((t6) xor (t1)) xor (t5) and (t4) xor (t0) and (t3) xor (t6));
  t7:= ((temp shr 7) or (temp shl 25)) + ((t7 shr 11) or (t7 shl 21)) + w[16];
  Temp:= ((t1) and ((t5) xor (t0)) xor (t4) and (t3) xor (t7) and (t2) xor (t5));
  t6:= ((temp shr 7) or (temp shl 25)) + ((t6 shr 11) or (t6 shl 21)) + w[17];
  Temp:= ((t0) and ((t4) xor (t7)) xor (t3) and (t2) xor (t6) and (t1) xor (t4));
  t5:= ((temp shr 7) or (temp shl 25)) + ((t5 shr 11) or (t5 shl 21)) + w[18];
  Temp:= ((t7) and ((t3) xor (t6)) xor (t2) and (t1) xor (t5) and (t0) xor (t3));
  t4:= ((temp shr 7) or (temp shl 25)) + ((t4 shr 11) or (t4 shl 21)) + w[19];
  Temp:= ((t6) and ((t2) xor (t5)) xor (t1) and (t0) xor (t4) and (t7) xor (t2));
  t3:= ((temp shr 7) or (temp shl 25)) + ((t3 shr 11) or (t3 shl 21)) + w[20];
  Temp:= ((t5) and ((t1) xor (t4)) xor (t0) and (t7) xor (t3) and (t6) xor (t1));
  t2:= ((temp shr 7) or (temp shl 25)) + ((t2 shr 11) or (t2 shl 21)) + w[21];
  Temp:= ((t4) and ((t0) xor (t3)) xor (t7) and (t6) xor (t2) and (t5) xor (t0));
  t1:= ((temp shr 7) or (temp shl 25)) + ((t1 shr 11) or (t1 shl 21)) + w[22];
  Temp:= ((t3) and ((t7) xor (t2)) xor (t6) and (t5) xor (t1) and (t4) xor (t7));
  t0:= ((temp shr 7) or (temp shl 25)) + ((t0 shr 11) or (t0 shl 21)) + w[23];

  Temp:= ((t2) and ((t6) xor (t1)) xor (t5) and (t4) xor (t0) and (t3) xor (t6));
  t7:= ((temp shr 7) or (temp shl 25)) + ((t7 shr 11) or (t7 shl 21)) + w[24];
  Temp:= ((t1) and ((t5) xor (t0)) xor (t4) and (t3) xor (t7) and (t2) xor (t5));
  t6:= ((temp shr 7) or (temp shl 25)) + ((t6 shr 11) or (t6 shl 21)) + w[25];
  Temp:= ((t0) and ((t4) xor (t7)) xor (t3) and (t2) xor (t6) and (t1) xor (t4));
  t5:= ((temp shr 7) or (temp shl 25)) + ((t5 shr 11) or (t5 shl 21)) + w[26];
  Temp:= ((t7) and ((t3) xor (t6)) xor (t2) and (t1) xor (t5) and (t0) xor (t3));
  t4:= ((temp shr 7) or (temp shl 25)) + ((t4 shr 11) or (t4 shl 21)) + w[27];
  Temp:= ((t6) and ((t2) xor (t5)) xor (t1) and (t0) xor (t4) and (t7) xor (t2));
  t3:= ((temp shr 7) or (temp shl 25)) + ((t3 shr 11) or (t3 shl 21)) + w[28];
  Temp:= ((t5) and ((t1) xor (t4)) xor (t0) and (t7) xor (t3) and (t6) xor (t1));
  t2:= ((temp shr 7) or (temp shl 25)) + ((t2 shr 11) or (t2 shl 21)) + w[29];
  Temp:= ((t4) and ((t0) xor (t3)) xor (t7) and (t6) xor (t2) and (t5) xor (t0));
  t1:= ((temp shr 7) or (temp shl 25)) + ((t1 shr 11) or (t1 shl 21)) + w[30];
  Temp:= ((t3) and ((t7) xor (t2)) xor (t6) and (t5) xor (t1) and (t4) xor (t7));
  t0:= ((temp shr 7) or (temp shl 25)) + ((t0 shr 11) or (t0 shl 21)) + w[31];

  Temp:= (t3 and (t4 and (not t0) xor t1 and t2 xor t6 xor t5) xor t1 and (t4 xor t2) xor t0 and t2 xor t5);
  t7:= ((temp shr 7) or (temp shl 25)) + ((t7 shr 11) or (t7 shl 21)) + w[ 5] + $452821E6;
  Temp:= (t2 and (t3 and (not t7) xor t0 and t1 xor t5 xor t4) xor t0 and (t3 xor t1) xor t7 and t1 xor t4);
  t6:= ((temp shr 7) or (temp shl 25)) + ((t6 shr 11) or (t6 shl 21)) + w[14] + $38D01377;
  Temp:= (t1 and (t2 and (not t6) xor t7 and t0 xor t4 xor t3) xor t7 and (t2 xor t0) xor t6 and t0 xor t3);
  t5:= ((temp shr 7) or (temp shl 25)) + ((t5 shr 11) or (t5 shl 21)) + w[26] + $BE5466CF;
  Temp:= (t0 and (t1 and (not t5) xor t6 and t7 xor t3 xor t2) xor t6 and (t1 xor t7) xor t5 and t7 xor t2);
  t4:= ((temp shr 7) or (temp shl 25)) + ((t4 shr 11) or (t4 shl 21)) + w[18] + $34E90C6C;
  Temp:= (t7 and (t0 and (not t4) xor t5 and t6 xor t2 xor t1) xor t5 and (t0 xor t6) xor t4 and t6 xor t1);
  t3:= ((temp shr 7) or (temp shl 25)) + ((t3 shr 11) or (t3 shl 21)) + w[11] + $C0AC29B7;
  Temp:= (t6 and (t7 and (not t3) xor t4 and t5 xor t1 xor t0) xor t4 and (t7 xor t5) xor t3 and t5 xor t0);
  t2:= ((temp shr 7) or (temp shl 25)) + ((t2 shr 11) or (t2 shl 21)) + w[28] + $C97C50DD;
  Temp:= (t5 and (t6 and (not t2) xor t3 and t4 xor t0 xor t7) xor t3 and (t6 xor t4) xor t2 and t4 xor t7);
  t1:= ((temp shr 7) or (temp shl 25)) + ((t1 shr 11) or (t1 shl 21)) + w[ 7] + $3F84D5B5;
  Temp:= (t4 and (t5 and (not t1) xor t2 and t3 xor t7 xor t6) xor t2 and (t5 xor t3) xor t1 and t3 xor t6);
  t0:= ((temp shr 7) or (temp shl 25)) + ((t0 shr 11) or (t0 shl 21)) + w[16] + $B5470917;

  Temp:= (t3 and (t4 and (not t0) xor t1 and t2 xor t6 xor t5) xor t1 and (t4 xor t2) xor t0 and t2 xor t5);
  t7:= ((temp shr 7) or (temp shl 25)) + ((t7 shr 11) or (t7 shl 21)) + w[ 0] + $9216D5D9;
  Temp:= (t2 and (t3 and (not t7) xor t0 and t1 xor t5 xor t4) xor t0 and (t3 xor t1) xor t7 and t1 xor t4);
  t6:= ((temp shr 7) or (temp shl 25)) + ((t6 shr 11) or (t6 shl 21)) + w[23] + $8979FB1B;
  Temp:= (t1 and (t2 and (not t6) xor t7 and t0 xor t4 xor t3) xor t7 and (t2 xor t0) xor t6 and t0 xor t3);
  t5:= ((temp shr 7) or (temp shl 25)) + ((t5 shr 11) or (t5 shl 21)) + w[20] + $D1310BA6;
  Temp:= (t0 and (t1 and (not t5) xor t6 and t7 xor t3 xor t2) xor t6 and (t1 xor t7) xor t5 and t7 xor t2);
  t4:= ((temp shr 7) or (temp shl 25)) + ((t4 shr 11) or (t4 shl 21)) + w[22] + $98DFB5AC;
  Temp:= (t7 and (t0 and (not t4) xor t5 and t6 xor t2 xor t1) xor t5 and (t0 xor t6) xor t4 and t6 xor t1);
  t3:= ((temp shr 7) or (temp shl 25)) + ((t3 shr 11) or (t3 shl 21)) + w[ 1] + $2FFD72DB;
  Temp:= (t6 and (t7 and (not t3) xor t4 and t5 xor t1 xor t0) xor t4 and (t7 xor t5) xor t3 and t5 xor t0);
  t2:= ((temp shr 7) or (temp shl 25)) + ((t2 shr 11) or (t2 shl 21)) + w[10] + $D01ADFB7;
  Temp:= (t5 and (t6 and (not t2) xor t3 and t4 xor t0 xor t7) xor t3 and (t6 xor t4) xor t2 and t4 xor t7);
  t1:= ((temp shr 7) or (temp shl 25)) + ((t1 shr 11) or (t1 shl 21)) + w[ 4] + $B8E1AFED;
  Temp:= (t4 and (t5 and (not t1) xor t2 and t3 xor t7 xor t6) xor t2 and (t5 xor t3) xor t1 and t3 xor t6);
  t0:= ((temp shr 7) or (temp shl 25)) + ((t0 shr 11) or (t0 shl 21)) + w[ 8] + $6A267E96;

  Temp:= (t3 and (t4 and (not t0) xor t1 and t2 xor t6 xor t5) xor t1 and (t4 xor t2) xor t0 and t2 xor t5);
  t7:= ((temp shr 7) or (temp shl 25)) + ((t7 shr 11) or (t7 shl 21)) + w[30] + $BA7C9045;
  Temp:= (t2 and (t3 and (not t7) xor t0 and t1 xor t5 xor t4) xor t0 and (t3 xor t1) xor t7 and t1 xor t4);
  t6:= ((temp shr 7) or (temp shl 25)) + ((t6 shr 11) or (t6 shl 21)) + w[ 3] + $F12C7F99;
  Temp:= (t1 and (t2 and (not t6) xor t7 and t0 xor t4 xor t3) xor t7 and (t2 xor t0) xor t6 and t0 xor t3);
  t5:= ((temp shr 7) or (temp shl 25)) + ((t5 shr 11) or (t5 shl 21)) + w[21] + $24A19947;
  Temp:= (t0 and (t1 and (not t5) xor t6 and t7 xor t3 xor t2) xor t6 and (t1 xor t7) xor t5 and t7 xor t2);
  t4:= ((temp shr 7) or (temp shl 25)) + ((t4 shr 11) or (t4 shl 21)) + w[ 9] + $B3916CF7;
  Temp:= (t7 and (t0 and (not t4) xor t5 and t6 xor t2 xor t1) xor t5 and (t0 xor t6) xor t4 and t6 xor t1);
  t3:= ((temp shr 7) or (temp shl 25)) + ((t3 shr 11) or (t3 shl 21)) + w[17] + $0801F2E2;
  Temp:= (t6 and (t7 and (not t3) xor t4 and t5 xor t1 xor t0) xor t4 and (t7 xor t5) xor t3 and t5 xor t0);
  t2:= ((temp shr 7) or (temp shl 25)) + ((t2 shr 11) or (t2 shl 21)) + w[24] + $858EFC16;
  Temp:= (t5 and (t6 and (not t2) xor t3 and t4 xor t0 xor t7) xor t3 and (t6 xor t4) xor t2 and t4 xor t7);
  t1:= ((temp shr 7) or (temp shl 25)) + ((t1 shr 11) or (t1 shl 21)) + w[29] + $636920D8;
  Temp:= (t4 and (t5 and (not t1) xor t2 and t3 xor t7 xor t6) xor t2 and (t5 xor t3) xor t1 and t3 xor t6);
  t0:= ((temp shr 7) or (temp shl 25)) + ((t0 shr 11) or (t0 shl 21)) + w[ 6] + $71574E69;

  Temp:= (t3 and (t4 and (not t0) xor t1 and t2 xor t6 xor t5) xor t1 and (t4 xor t2) xor t0 and t2 xor t5);
  t7:= ((temp shr 7) or (temp shl 25)) + ((t7 shr 11) or (t7 shl 21)) + w[19] + $A458FEA3;
  Temp:= (t2 and (t3 and (not t7) xor t0 and t1 xor t5 xor t4) xor t0 and (t3 xor t1) xor t7 and t1 xor t4);
  t6:= ((temp shr 7) or (temp shl 25)) + ((t6 shr 11) or (t6 shl 21)) + w[12] + $F4933D7E;
  Temp:= (t1 and (t2 and (not t6) xor t7 and t0 xor t4 xor t3) xor t7 and (t2 xor t0) xor t6 and t0 xor t3);
  t5:= ((temp shr 7) or (temp shl 25)) + ((t5 shr 11) or (t5 shl 21)) + w[15] + $0D95748F;
  Temp:= (t0 and (t1 and (not t5) xor t6 and t7 xor t3 xor t2) xor t6 and (t1 xor t7) xor t5 and t7 xor t2);
  t4:= ((temp shr 7) or (temp shl 25)) + ((t4 shr 11) or (t4 shl 21)) + w[13] + $728EB658;
  Temp:= (t7 and (t0 and (not t4) xor t5 and t6 xor t2 xor t1) xor t5 and (t0 xor t6) xor t4 and t6 xor t1);
  t3:= ((temp shr 7) or (temp shl 25)) + ((t3 shr 11) or (t3 shl 21)) + w[ 2] + $718BCD58;
  Temp:= (t6 and (t7 and (not t3) xor t4 and t5 xor t1 xor t0) xor t4 and (t7 xor t5) xor t3 and t5 xor t0);
  t2:= ((temp shr 7) or (temp shl 25)) + ((t2 shr 11) or (t2 shl 21)) + w[25] + $82154AEE;
  Temp:= (t5 and (t6 and (not t2) xor t3 and t4 xor t0 xor t7) xor t3 and (t6 xor t4) xor t2 and t4 xor t7);
  t1:= ((temp shr 7) or (temp shl 25)) + ((t1 shr 11) or (t1 shl 21)) + w[31] + $7B54A41D;
  Temp:= (t4 and (t5 and (not t1) xor t2 and t3 xor t7 xor t6) xor t2 and (t5 xor t3) xor t1 and t3 xor t6);
  t0:= ((temp shr 7) or (temp shl 25)) + ((t0 shr 11) or (t0 shl 21)) + w[27] + $C25A59B5;

  Temp:= ((t4) and ((t1) and (t3) xor (t2) xor (t5)) xor (t1) and (t0) xor (t3) and (t6) xor (t5));
  t7:= ((temp shr 7) or (temp shl 25)) + ((t7 shr 11) or (t7 shl 21)) + w[19] + $9C30D539;
  Temp:= ((t3) and ((t0) and (t2) xor (t1) xor (t4)) xor (t0) and (t7) xor (t2) and (t5) xor (t4));
  t6:= ((temp shr 7) or (temp shl 25)) + ((t6 shr 11) or (t6 shl 21)) + w[ 9] + $2AF26013;
  Temp:= ((t2) and ((t7) and (t1) xor (t0) xor (t3)) xor (t7) and (t6) xor (t1) and (t4) xor (t3));
  t5:= ((temp shr 7) or (temp shl 25)) + ((t5 shr 11) or (t5 shl 21)) + w[ 4] + $C5D1B023;
  Temp:= ((t1) and ((t6) and (t0) xor (t7) xor (t2)) xor (t6) and (t5) xor (t0) and (t3) xor (t2));
  t4:= ((temp shr 7) or (temp shl 25)) + ((t4 shr 11) or (t4 shl 21)) + w[20] + $286085F0;
  Temp:= ((t0) and ((t5) and (t7) xor (t6) xor (t1)) xor (t5) and (t4) xor (t7) and (t2) xor (t1));
  t3:= ((temp shr 7) or (temp shl 25)) + ((t3 shr 11) or (t3 shl 21)) + w[28] + $CA417918;
  Temp:= ((t7) and ((t4) and (t6) xor (t5) xor (t0)) xor (t4) and (t3) xor (t6) and (t1) xor (t0));
  t2:= ((temp shr 7) or (temp shl 25)) + ((t2 shr 11) or (t2 shl 21)) + w[17] + $B8DB38EF;
  Temp:= ((t6) and ((t3) and (t5) xor (t4) xor (t7)) xor (t3) and (t2) xor (t5) and (t0) xor (t7));
  t1:= ((temp shr 7) or (temp shl 25)) + ((t1 shr 11) or (t1 shl 21)) + w[ 8] + $8E79DCB0;
  Temp:= ((t5) and ((t2) and (t4) xor (t3) xor (t6)) xor (t2) and (t1) xor (t4) and (t7) xor (t6));
  t0:= ((temp shr 7) or (temp shl 25)) + ((t0 shr 11) or (t0 shl 21)) + w[22] + $603A180E;

  Temp:= ((t4) and ((t1) and (t3) xor (t2) xor (t5)) xor (t1) and (t0) xor (t3) and (t6) xor (t5));
  t7:= ((temp shr 7) or (temp shl 25)) + ((t7 shr 11) or (t7 shl 21)) + w[29] + $6C9E0E8B;
  Temp:= ((t3) and ((t0) and (t2) xor (t1) xor (t4)) xor (t0) and (t7) xor (t2) and (t5) xor (t4));
  t6:= ((temp shr 7) or (temp shl 25)) + ((t6 shr 11) or (t6 shl 21)) + w[14] + $B01E8A3E;
  Temp:= ((t2) and ((t7) and (t1) xor (t0) xor (t3)) xor (t7) and (t6) xor (t1) and (t4) xor (t3));
  t5:= ((temp shr 7) or (temp shl 25)) + ((t5 shr 11) or (t5 shl 21)) + w[25] + $D71577C1;
  Temp:= ((t1) and ((t6) and (t0) xor (t7) xor (t2)) xor (t6) and (t5) xor (t0) and (t3) xor (t2));
  t4:= ((temp shr 7) or (temp shl 25)) + ((t4 shr 11) or (t4 shl 21)) + w[12] + $BD314B27;
  Temp:= ((t0) and ((t5) and (t7) xor (t6) xor (t1)) xor (t5) and (t4) xor (t7) and (t2) xor (t1));
  t3:= ((temp shr 7) or (temp shl 25)) + ((t3 shr 11) or (t3 shl 21)) + w[24] + $78AF2FDA;
  Temp:= ((t7) and ((t4) and (t6) xor (t5) xor (t0)) xor (t4) and (t3) xor (t6) and (t1) xor (t0));
  t2:= ((temp shr 7) or (temp shl 25)) + ((t2 shr 11) or (t2 shl 21)) + w[30] + $55605C60;
  Temp:= ((t6) and ((t3) and (t5) xor (t4) xor (t7)) xor (t3) and (t2) xor (t5) and (t0) xor (t7));
  t1:= ((temp shr 7) or (temp shl 25)) + ((t1 shr 11) or (t1 shl 21)) + w[16] + $E65525F3;
  Temp:= ((t5) and ((t2) and (t4) xor (t3) xor (t6)) xor (t2) and (t1) xor (t4) and (t7) xor (t6));
  t0:= ((temp shr 7) or (temp shl 25)) + ((t0 shr 11) or (t0 shl 21)) + w[26] + $AA55AB94;

  Temp:= ((t4) and ((t1) and (t3) xor (t2) xor (t5)) xor (t1) and (t0) xor (t3) and (t6) xor (t5));
  t7:= ((temp shr 7) or (temp shl 25)) + ((t7 shr 11) or (t7 shl 21)) + w[31] + $57489862;
  Temp:= ((t3) and ((t0) and (t2) xor (t1) xor (t4)) xor (t0) and (t7) xor (t2) and (t5) xor (t4));
  t6:= ((temp shr 7) or (temp shl 25)) + ((t6 shr 11) or (t6 shl 21)) + w[15] + $63E81440;
  Temp:= ((t2) and ((t7) and (t1) xor (t0) xor (t3)) xor (t7) and (t6) xor (t1) and (t4) xor (t3));
  t5:= ((temp shr 7) or (temp shl 25)) + ((t5 shr 11) or (t5 shl 21)) + w[ 7] + $55CA396A;
  Temp:= ((t1) and ((t6) and (t0) xor (t7) xor (t2)) xor (t6) and (t5) xor (t0) and (t3) xor (t2));
  t4:= ((temp shr 7) or (temp shl 25)) + ((t4 shr 11) or (t4 shl 21)) + w[ 3] + $2AAB10B6;
  Temp:= ((t0) and ((t5) and (t7) xor (t6) xor (t1)) xor (t5) and (t4) xor (t7) and (t2) xor (t1));
  t3:= ((temp shr 7) or (temp shl 25)) + ((t3 shr 11) or (t3 shl 21)) + w[ 1] + $B4CC5C34;
  Temp:= ((t7) and ((t4) and (t6) xor (t5) xor (t0)) xor (t4) and (t3) xor (t6) and (t1) xor (t0));
  t2:= ((temp shr 7) or (temp shl 25)) + ((t2 shr 11) or (t2 shl 21)) + w[ 0] + $1141E8CE;
  Temp:= ((t6) and ((t3) and (t5) xor (t4) xor (t7)) xor (t3) and (t2) xor (t5) and (t0) xor (t7));
  t1:= ((temp shr 7) or (temp shl 25)) + ((t1 shr 11) or (t1 shl 21)) + w[18] + $A15486AF;
  Temp:= ((t5) and ((t2) and (t4) xor (t3) xor (t6)) xor (t2) and (t1) xor (t4) and (t7) xor (t6));
  t0:= ((temp shr 7) or (temp shl 25)) + ((t0 shr 11) or (t0 shl 21)) + w[27] + $7C72E993;

  Temp:= ((t4) and ((t1) and (t3) xor (t2) xor (t5)) xor (t1) and (t0) xor (t3) and (t6) xor (t5));
  t7:= ((temp shr 7) or (temp shl 25)) + ((t7 shr 11) or (t7 shl 21)) + w[13] + $B3EE1411;
  Temp:= ((t3) and ((t0) and (t2) xor (t1) xor (t4)) xor (t0) and (t7) xor (t2) and (t5) xor (t4));
  t6:= ((temp shr 7) or (temp shl 25)) + ((t6 shr 11) or (t6 shl 21)) + w[ 6] + $636FBC2A;
  Temp:= ((t2) and ((t7) and (t1) xor (t0) xor (t3)) xor (t7) and (t6) xor (t1) and (t4) xor (t3));
  t5:= ((temp shr 7) or (temp shl 25)) + ((t5 shr 11) or (t5 shl 21)) + w[21] + $2BA9C55D;
  Temp:= ((t1) and ((t6) and (t0) xor (t7) xor (t2)) xor (t6) and (t5) xor (t0) and (t3) xor (t2));
  t4:= ((temp shr 7) or (temp shl 25)) + ((t4 shr 11) or (t4 shl 21)) + w[10] + $741831F6;
  Temp:= ((t0) and ((t5) and (t7) xor (t6) xor (t1)) xor (t5) and (t4) xor (t7) and (t2) xor (t1));
  t3:= ((temp shr 7) or (temp shl 25)) + ((t3 shr 11) or (t3 shl 21)) + w[23] + $CE5C3E16;
  Temp:= ((t7) and ((t4) and (t6) xor (t5) xor (t0)) xor (t4) and (t3) xor (t6) and (t1) xor (t0));
  t2:= ((temp shr 7) or (temp shl 25)) + ((t2 shr 11) or (t2 shl 21)) + w[11] + $9B87931E;
  Temp:= ((t6) and ((t3) and (t5) xor (t4) xor (t7)) xor (t3) and (t2) xor (t5) and (t0) xor (t7));
  t1:= ((temp shr 7) or (temp shl 25)) + ((t1 shr 11) or (t1 shl 21)) + w[ 5] + $AFD6BA33;
  Temp:= ((t5) and ((t2) and (t4) xor (t3) xor (t6)) xor (t2) and (t1) xor (t4) and (t7) xor (t6));
  t0:= ((temp shr 7) or (temp shl 25)) + ((t0 shr 11) or (t0 shl 21)) + w[ 2] + $6C24CF5C;

  Temp:= (t3 and (t5 and (not t0) xor t2 and (not t1) xor t4 xor t1 xor t6) xor t2 and (t4 and t0 xor t5 xor t1) xor t0
    and t1 xor t6); t7:= ((temp shr 7) or (temp shl 25)) + ((t7 shr 11) or (t7 shl 21)) + w[24] + $7A325381;
  Temp:= (t2 and (t4 and (not t7) xor t1 and (not t0) xor t3 xor t0 xor t5) xor t1 and (t3 and t7 xor t4 xor t0) xor t7
    and t0 xor t5); t6:= ((temp shr 7) or (temp shl 25)) + ((t6 shr 11) or (t6 shl 21)) + w[ 4] + $28958677;
  Temp:= (t1 and (t3 and (not t6) xor t0 and (not t7) xor t2 xor t7 xor t4) xor t0 and (t2 and t6 xor t3 xor t7) xor t6
    and t7 xor t4); t5:= ((temp shr 7) or (temp shl 25)) + ((t5 shr 11) or (t5 shl 21)) + w[ 0] + $3B8F4898;
  Temp:= (t0 and (t2 and (not t5) xor t7 and (not t6) xor t1 xor t6 xor t3) xor t7 and (t1 and t5 xor t2 xor t6) xor t5
    and t6 xor t3); t4:= ((temp shr 7) or (temp shl 25)) + ((t4 shr 11) or (t4 shl 21)) + w[14] + $6B4BB9AF;
  Temp:= (t7 and (t1 and (not t4) xor t6 and (not t5) xor t0 xor t5 xor t2) xor t6 and (t0 and t4 xor t1 xor t5) xor t4
    and t5 xor t2); t3:= ((temp shr 7) or (temp shl 25)) + ((t3 shr 11) or (t3 shl 21)) + w[ 2] + $C4BFE81B;
  Temp:= (t6 and (t0 and (not t3) xor t5 and (not t4) xor t7 xor t4 xor t1) xor t5 and (t7 and t3 xor t0 xor t4) xor t3
    and t4 xor t1); t2:= ((temp shr 7) or (temp shl 25)) + ((t2 shr 11) or (t2 shl 21)) + w[ 7] + $66282193;
  Temp:= (t5 and (t7 and (not t2) xor t4 and (not t3) xor t6 xor t3 xor t0) xor t4 and (t6 and t2 xor t7 xor t3) xor t2
    and t3 xor t0); t1:= ((temp shr 7) or (temp shl 25)) + ((t1 shr 11) or (t1 shl 21)) + w[28] + $61D809CC;
  Temp:= (t4 and (t6 and (not t1) xor t3 and (not t2) xor t5 xor t2 xor t7) xor t3 and (t5 and t1 xor t6 xor t2) xor t1
    and t2 xor t7); t0:= ((temp shr 7) or (temp shl 25)) + ((t0 shr 11) or (t0 shl 21)) + w[23] + $FB21A991;

  Temp:= (t3 and (t5 and (not t0) xor t2 and (not t1) xor t4 xor t1 xor t6) xor t2 and (t4 and t0 xor t5 xor t1) xor t0
    and t1 xor t6); t7:= ((temp shr 7) or (temp shl 25)) + ((t7 shr 11) or (t7 shl 21)) + w[26] + $487CAC60;
  Temp:= (t2 and (t4 and (not t7) xor t1 and (not t0) xor t3 xor t0 xor t5) xor t1 and (t3 and t7 xor t4 xor t0) xor t7
    and t0 xor t5); t6:= ((temp shr 7) or (temp shl 25)) + ((t6 shr 11) or (t6 shl 21)) + w[ 6] + $5DEC8032;
  Temp:= (t1 and (t3 and (not t6) xor t0 and (not t7) xor t2 xor t7 xor t4) xor t0 and (t2 and t6 xor t3 xor t7) xor t6
    and t7 xor t4); t5:= ((temp shr 7) or (temp shl 25)) + ((t5 shr 11) or (t5 shl 21)) + w[30] + $EF845D5D;
  Temp:= (t0 and (t2 and (not t5) xor t7 and (not t6) xor t1 xor t6 xor t3) xor t7 and (t1 and t5 xor t2 xor t6) xor t5
    and t6 xor t3); t4:= ((temp shr 7) or (temp shl 25)) + ((t4 shr 11) or (t4 shl 21)) + w[20] + $E98575B1;
  Temp:= (t7 and (t1 and (not t4) xor t6 and (not t5) xor t0 xor t5 xor t2) xor t6 and (t0 and t4 xor t1 xor t5) xor t4
    and t5 xor t2); t3:= ((temp shr 7) or (temp shl 25)) + ((t3 shr 11) or (t3 shl 21)) + w[18] + $DC262302;
  Temp:= (t6 and (t0 and (not t3) xor t5 and (not t4) xor t7 xor t4 xor t1) xor t5 and (t7 and t3 xor t0 xor t4) xor t3
    and t4 xor t1); t2:= ((temp shr 7) or (temp shl 25)) + ((t2 shr 11) or (t2 shl 21)) + w[25] + $EB651B88;
  Temp:= (t5 and (t7 and (not t2) xor t4 and (not t3) xor t6 xor t3 xor t0) xor t4 and (t6 and t2 xor t7 xor t3) xor t2
    and t3 xor t0); t1:= ((temp shr 7) or (temp shl 25)) + ((t1 shr 11) or (t1 shl 21)) + w[19] + $23893E81;
  Temp:= (t4 and (t6 and (not t1) xor t3 and (not t2) xor t5 xor t2 xor t7) xor t3 and (t5 and t1 xor t6 xor t2) xor t1
    and t2 xor t7); t0:= ((temp shr 7) or (temp shl 25)) + ((t0 shr 11) or (t0 shl 21)) + w[ 3] + $D396ACC5;

  Temp:= (t3 and (t5 and (not t0) xor t2 and (not t1) xor t4 xor t1 xor t6) xor t2 and (t4 and t0 xor t5 xor t1) xor t0
    and t1 xor t6); t7:= ((temp shr 7) or (temp shl 25)) + ((t7 shr 11) or (t7 shl 21)) + w[22] + $0F6D6FF3;
  Temp:= (t2 and (t4 and (not t7) xor t1 and (not t0) xor t3 xor t0 xor t5) xor t1 and (t3 and t7 xor t4 xor t0) xor t7
    and t0 xor t5); t6:= ((temp shr 7) or (temp shl 25)) + ((t6 shr 11) or (t6 shl 21)) + w[11] + $83F44239;
  Temp:= (t1 and (t3 and (not t6) xor t0 and (not t7) xor t2 xor t7 xor t4) xor t0 and (t2 and t6 xor t3 xor t7) xor t6
    and t7 xor t4); t5:= ((temp shr 7) or (temp shl 25)) + ((t5 shr 11) or (t5 shl 21)) + w[31] + $2E0B4482;
  Temp:= (t0 and (t2 and (not t5) xor t7 and (not t6) xor t1 xor t6 xor t3) xor t7 and (t1 and t5 xor t2 xor t6) xor t5
    and t6 xor t3); t4:= ((temp shr 7) or (temp shl 25)) + ((t4 shr 11) or (t4 shl 21)) + w[21] + $A4842004;
  Temp:= (t7 and (t1 and (not t4) xor t6 and (not t5) xor t0 xor t5 xor t2) xor t6 and (t0 and t4 xor t1 xor t5) xor t4
    and t5 xor t2); t3:= ((temp shr 7) or (temp shl 25)) + ((t3 shr 11) or (t3 shl 21)) + w[ 8] + $69C8F04A;
  Temp:= (t6 and (t0 and (not t3) xor t5 and (not t4) xor t7 xor t4 xor t1) xor t5 and (t7 and t3 xor t0 xor t4) xor t3
    and t4 xor t1); t2:= ((temp shr 7) or (temp shl 25)) + ((t2 shr 11) or (t2 shl 21)) + w[27] + $9E1F9B5E;
  Temp:= (t5 and (t7 and (not t2) xor t4 and (not t3) xor t6 xor t3 xor t0) xor t4 and (t6 and t2 xor t7 xor t3) xor t2
    and t3 xor t0); t1:= ((temp shr 7) or (temp shl 25)) + ((t1 shr 11) or (t1 shl 21)) + w[12] + $21C66842;
  Temp:= (t4 and (t6 and (not t1) xor t3 and (not t2) xor t5 xor t2 xor t7) xor t3 and (t5 and t1 xor t6 xor t2) xor t1
    and t2 xor t7); t0:= ((temp shr 7) or (temp shl 25)) + ((t0 shr 11) or (t0 shl 21)) + w[ 9] + $F6E96C9A;

  Temp:= (t3 and (t5 and (not t0) xor t2 and (not t1) xor t4 xor t1 xor t6) xor t2 and (t4 and t0 xor t5 xor t1) xor t0
    and t1 xor t6); t7:= ((temp shr 7) or (temp shl 25)) + ((t7 shr 11) or (t7 shl 21)) + w[ 1] + $670C9C61;
  Temp:= (t2 and (t4 and (not t7) xor t1 and (not t0) xor t3 xor t0 xor t5) xor t1 and (t3 and t7 xor t4 xor t0) xor t7
    and t0 xor t5); t6:= ((temp shr 7) or (temp shl 25)) + ((t6 shr 11) or (t6 shl 21)) + w[29] + $ABD388F0;
  Temp:= (t1 and (t3 and (not t6) xor t0 and (not t7) xor t2 xor t7 xor t4) xor t0 and (t2 and t6 xor t3 xor t7) xor t6
    and t7 xor t4); t5:= ((temp shr 7) or (temp shl 25)) + ((t5 shr 11) or (t5 shl 21)) + w[ 5] + $6A51A0D2;
  Temp:= (t0 and (t2 and (not t5) xor t7 and (not t6) xor t1 xor t6 xor t3) xor t7 and (t1 and t5 xor t2 xor t6) xor t5
    and t6 xor t3); t4:= ((temp shr 7) or (temp shl 25)) + ((t4 shr 11) or (t4 shl 21)) + w[15] + $D8542F68;
  Temp:= (t7 and (t1 and (not t4) xor t6 and (not t5) xor t0 xor t5 xor t2) xor t6 and (t0 and t4 xor t1 xor t5) xor t4
    and t5 xor t2); t3:= ((temp shr 7) or (temp shl 25)) + ((t3 shr 11) or (t3 shl 21)) + w[17] + $960FA728;
  Temp:= (t6 and (t0 and (not t3) xor t5 and (not t4) xor t7 xor t4 xor t1) xor t5 and (t7 and t3 xor t0 xor t4) xor t3
    and t4 xor t1); t2:= ((temp shr 7) or (temp shl 25)) + ((t2 shr 11) or (t2 shl 21)) + w[10] + $AB5133A3;
  Temp:= (t5 and (t7 and (not t2) xor t4 and (not t3) xor t6 xor t3 xor t0) xor t4 and (t6 and t2 xor t7 xor t3) xor t2
    and t3 xor t0); t1:= ((temp shr 7) or (temp shl 25)) + ((t1 shr 11) or (t1 shl 21)) + w[16] + $6EEF0B6C;
  Temp:= (t4 and (t6 and (not t1) xor t3 and (not t2) xor t5 xor t2 xor t7) xor t3 and (t5 and t1 xor t6 xor t2) xor t1
    and t2 xor t7); t0:= ((temp shr 7) or (temp shl 25)) + ((t0 shr 11) or (t0 shl 21)) + w[13] + $137A3BE4;

  Temp:= (t1 and (t3 and t4 and t6 xor (not t5)) xor t3 and t0 xor t4 and t5 xor t6 and t2);
  t7:= ((temp shr 7) or (temp shl 25)) + ((t7 shr 11) or (t7 shl 21)) + w[27] + $BA3BF050;
  Temp:= (t0 and (t2 and t3 and t5 xor (not t4)) xor t2 and t7 xor t3 and t4 xor t5 and t1);
  t6:= ((temp shr 7) or (temp shl 25)) + ((t6 shr 11) or (t6 shl 21)) + w[ 3] + $7EFB2A98;
  Temp:= (t7 and (t1 and t2 and t4 xor (not t3)) xor t1 and t6 xor t2 and t3 xor t4 and t0);
  t5:= ((temp shr 7) or (temp shl 25)) + ((t5 shr 11) or (t5 shl 21)) + w[21] + $A1F1651D;
  Temp:= (t6 and (t0 and t1 and t3 xor (not t2)) xor t0 and t5 xor t1 and t2 xor t3 and t7);
  t4:= ((temp shr 7) or (temp shl 25)) + ((t4 shr 11) or (t4 shl 21)) + w[26] + $39AF0176;
  Temp:= (t5 and (t7 and t0 and t2 xor (not t1)) xor t7 and t4 xor t0 and t1 xor t2 and t6);
  t3:= ((temp shr 7) or (temp shl 25)) + ((t3 shr 11) or (t3 shl 21)) + w[17] + $66CA593E;
  Temp:= (t4 and (t6 and t7 and t1 xor (not t0)) xor t6 and t3 xor t7 and t0 xor t1 and t5);
  t2:= ((temp shr 7) or (temp shl 25)) + ((t2 shr 11) or (t2 shl 21)) + w[11] + $82430E88;
  Temp:= (t3 and (t5 and t6 and t0 xor (not t7)) xor t5 and t2 xor t6 and t7 xor t0 and t4);
  t1:= ((temp shr 7) or (temp shl 25)) + ((t1 shr 11) or (t1 shl 21)) + w[20] + $8CEE8619;
  Temp:= (t2 and (t4 and t5 and t7 xor (not t6)) xor t4 and t1 xor t5 and t6 xor t7 and t3);
  t0:= ((temp shr 7) or (temp shl 25)) + ((t0 shr 11) or (t0 shl 21)) + w[29] + $456F9FB4;

  Temp:= (t1 and (t3 and t4 and t6 xor (not t5)) xor t3 and t0 xor t4 and t5 xor t6 and t2);
  t7:= ((temp shr 7) or (temp shl 25)) + ((t7 shr 11) or (t7 shl 21)) + w[19] + $7D84A5C3;
  Temp:= (t0 and (t2 and t3 and t5 xor (not t4)) xor t2 and t7 xor t3 and t4 xor t5 and t1);
  t6:= ((temp shr 7) or (temp shl 25)) + ((t6 shr 11) or (t6 shl 21)) + w[ 0] + $3B8B5EBE;
  Temp:= (t7 and (t1 and t2 and t4 xor (not t3)) xor t1 and t6 xor t2 and t3 xor t4 and t0);
  t5:= ((temp shr 7) or (temp shl 25)) + ((t5 shr 11) or (t5 shl 21)) + w[12] + $E06F75D8;
  Temp:= (t6 and (t0 and t1 and t3 xor (not t2)) xor t0 and t5 xor t1 and t2 xor t3 and t7);
  t4:= ((temp shr 7) or (temp shl 25)) + ((t4 shr 11) or (t4 shl 21)) + w[ 7] + $85C12073;
  Temp:= (t5 and (t7 and t0 and t2 xor (not t1)) xor t7 and t4 xor t0 and t1 xor t2 and t6);
  t3:= ((temp shr 7) or (temp shl 25)) + ((t3 shr 11) or (t3 shl 21)) + w[13] + $401A449F;
  Temp:= (t4 and (t6 and t7 and t1 xor (not t0)) xor t6 and t3 xor t7 and t0 xor t1 and t5);
  t2:= ((temp shr 7) or (temp shl 25)) + ((t2 shr 11) or (t2 shl 21)) + w[ 8] + $56C16AA6;
  Temp:= (t3 and (t5 and t6 and t0 xor (not t7)) xor t5 and t2 xor t6 and t7 xor t0 and t4);
  t1:= ((temp shr 7) or (temp shl 25)) + ((t1 shr 11) or (t1 shl 21)) + w[31] + $4ED3AA62;
  Temp:= (t2 and (t4 and t5 and t7 xor (not t6)) xor t4 and t1 xor t5 and t6 xor t7 and t3);
  t0:= ((temp shr 7) or (temp shl 25)) + ((t0 shr 11) or (t0 shl 21)) + w[10] + $363F7706;

  Temp:= (t1 and (t3 and t4 and t6 xor (not t5)) xor t3 and t0 xor t4 and t5 xor t6 and t2);
  t7:= ((temp shr 7) or (temp shl 25)) + ((t7 shr 11) or (t7 shl 21)) + w[ 5] + $1BFEDF72;
  Temp:= (t0 and (t2 and t3 and t5 xor (not t4)) xor t2 and t7 xor t3 and t4 xor t5 and t1);
  t6:= ((temp shr 7) or (temp shl 25)) + ((t6 shr 11) or (t6 shl 21)) + w[ 9] + $429B023D;
  Temp:= (t7 and (t1 and t2 and t4 xor (not t3)) xor t1 and t6 xor t2 and t3 xor t4 and t0);
  t5:= ((temp shr 7) or (temp shl 25)) + ((t5 shr 11) or (t5 shl 21)) + w[14] + $37D0D724;
  Temp:= (t6 and (t0 and t1 and t3 xor (not t2)) xor t0 and t5 xor t1 and t2 xor t3 and t7);
  t4:= ((temp shr 7) or (temp shl 25)) + ((t4 shr 11) or (t4 shl 21)) + w[30] + $D00A1248;
  Temp:= (t5 and (t7 and t0 and t2 xor (not t1)) xor t7 and t4 xor t0 and t1 xor t2 and t6);
  t3:= ((temp shr 7) or (temp shl 25)) + ((t3 shr 11) or (t3 shl 21)) + w[18] + $DB0FEAD3;
  Temp:= (t4 and (t6 and t7 and t1 xor (not t0)) xor t6 and t3 xor t7 and t0 xor t1 and t5);
  t2:= ((temp shr 7) or (temp shl 25)) + ((t2 shr 11) or (t2 shl 21)) + w[ 6] + $49F1C09B;
  Temp:= (t3 and (t5 and t6 and t0 xor (not t7)) xor t5 and t2 xor t6 and t7 xor t0 and t4);
  t1:= ((temp shr 7) or (temp shl 25)) + ((t1 shr 11) or (t1 shl 21)) + w[28] + $075372C9;
  Temp:= (t2 and (t4 and t5 and t7 xor (not t6)) xor t4 and t1 xor t5 and t6 xor t7 and t3);
  t0:= ((temp shr 7) or (temp shl 25)) + ((t0 shr 11) or (t0 shl 21)) + w[24] + $80991B7B;

  Temp:= (t1 and (t3 and t4 and t6 xor (not t5)) xor t3 and t0 xor t4 and t5 xor t6 and t2);
  t7:= ((temp shr 7) or (temp shl 25)) + ((t7 shr 11) or (t7 shl 21)) + w[ 2] + $25D479D8;
  Temp:= (t0 and (t2 and t3 and t5 xor (not t4)) xor t2 and t7 xor t3 and t4 xor t5 and t1);
  t6:= ((temp shr 7) or (temp shl 25)) + ((t6 shr 11) or (t6 shl 21)) + w[23] + $F6E8DEF7;
  Temp:= (t7 and (t1 and t2 and t4 xor (not t3)) xor t1 and t6 xor t2 and t3 xor t4 and t0);
  t5:= ((temp shr 7) or (temp shl 25)) + ((t5 shr 11) or (t5 shl 21)) + w[16] + $E3FE501A;
  Temp:= (t6 and (t0 and t1 and t3 xor (not t2)) xor t0 and t5 xor t1 and t2 xor t3 and t7);
  t4:= ((temp shr 7) or (temp shl 25)) + ((t4 shr 11) or (t4 shl 21)) + w[22] + $B6794C3B;
  Temp:= (t5 and (t7 and t0 and t2 xor (not t1)) xor t7 and t4 xor t0 and t1 xor t2 and t6);
  t3:= ((temp shr 7) or (temp shl 25)) + ((t3 shr 11) or (t3 shl 21)) + w[ 4] + $976CE0BD;
  Temp:= (t4 and (t6 and t7 and t1 xor (not t0)) xor t6 and t3 xor t7 and t0 xor t1 and t5);
  t2:= ((temp shr 7) or (temp shl 25)) + ((t2 shr 11) or (t2 shl 21)) + w[ 1] + $04C006BA;
  Temp:= (t3 and (t5 and t6 and t0 xor (not t7)) xor t5 and t2 xor t6 and t7 xor t0 and t4);
  t1:= ((temp shr 7) or (temp shl 25)) + ((t1 shr 11) or (t1 shl 21)) + w[25] + $C1A94FB6;
  Temp:= (t2 and (t4 and t5 and t7 xor (not t6)) xor t4 and t1 xor t5 and t6 xor t7 and t3);
  t0:= ((temp shr 7) or (temp shl 25)) + ((t0 shr 11) or (t0 shl 21)) + w[15] + $409F60C4;

  Inc(CurrentHash[0],t0);
  Inc(CurrentHash[1],t1);
  Inc(CurrentHash[2],t2);
  Inc(CurrentHash[3],t3);
  Inc(CurrentHash[4],t4);
  Inc(CurrentHash[5],t5);
  Inc(CurrentHash[6],t6);
  Inc(CurrentHash[7],t7);
  FillChar(W,Sizeof(W),0);
  Index:= 0;
  FillChar(HashBuffer,Sizeof(HashBuffer),0);
end;

class function TDCP_haval.GetHashSize: longint;
begin
  Result:= 256;
end;

class function TDCP_haval.GetId: longint;
begin
  Result:= DCP_haval;
end;

class function TDCP_haval.GetAlgorithm: string;
begin
  Result:= 'Haval';
end;

class function TDCP_haval.SelfTest: boolean;
const
  Test1Out: array[0..31] of byte=
    ($1A,$1D,$C8,$09,$9B,$DA,$A7,$F3,$5B,$4D,$A4,$E8,$05,$F1,$A2,$8F,
     $EE,$90,$9D,$8D,$EE,$92,$01,$98,$18,$5C,$BC,$AE,$D8,$A1,$0A,$8D);
  Test2Out: array[0..31] of byte=
    ($C5,$64,$7F,$C6,$C1,$87,$7F,$FF,$96,$74,$2F,$27,$E9,$26,$6B,$68,
     $74,$89,$4F,$41,$A0,$8F,$59,$13,$03,$3D,$9D,$53,$2A,$ED,$DB,$39);
var
  TestHash: TDCP_haval;
  TestOut: array[0..31] of byte;
begin
  TestHash:= TDCP_haval.Create(nil);
  TestHash.Init;
  TestHash.UpdateStr('abcdefghijklmnopqrstuvwxyz');
  TestHash.Final(TestOut);
  Result:= CompareMemory(@TestOut,@Test1Out,Sizeof(Test1Out));
  TestHash.Init;
  TestHash.UpdateStr('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789');
  TestHash.Final(TestOut);
  Result:= CompareMemory(@TestOut,@Test2Out,Sizeof(Test2Out)) and Result;
  TestHash.Free;
end;

procedure TDCP_haval.Init;
begin
  Burn;
  CurrentHash[0]:= $243F6A88;
  CurrentHash[1]:= $85A308D3;
  CurrentHash[2]:= $13198A2E;
  CurrentHash[3]:= $03707344;
  CurrentHash[4]:= $A4093822;
  CurrentHash[5]:= $299F31D0;
  CurrentHash[6]:= $082EFA98;
  CurrentHash[7]:= $EC4E6C89;
  fInitialized:= true;
end;

procedure TDCP_haval.Burn;
begin
  LenHi:= 0; LenLo1:= 0; LenLo2:= 0;
  Index:= 0;
  FillChar(HashBuffer,Sizeof(HashBuffer),0);
  FillChar(CurrentHash,Sizeof(CurrentHash),0);
  fInitialized:= false;
end;

procedure TDCP_haval.Update(const Buffer; Size: longint);
var
  PBuf: ^byte;
begin
  if not fInitialized then
    raise EDCP_hash.Create('Hash not initialized');

  { I wish Borland had included an unsigned 32bit from the start }
  Inc(LenLo1,(Size shl 3) and $FFFF);
  if LenLo1< ((Size shl 3) and $FFFF) then
  begin
    Inc(LenLo2);
    if LenLo2= 0 then
      Inc(LenHi);
  end;
  Inc(LenLo2,Size shr 13);
  if LenLo2< ((Size shr 13) and $FFFF) then
    Inc(LenHi);
  Inc(LenHi,Size shr 29);

  PBuf:= @Buffer;
  while Size> 0 do
  begin
    if (Sizeof(HashBuffer)-Index)<= DWord(Size) then
    begin
      Move(PBuf^,HashBuffer[Index],Sizeof(HashBuffer)-Index);
      Dec(Size,Sizeof(HashBuffer)-Index);
      Inc(PBuf,Sizeof(HashBuffer)-Index);
      Compress;
    end
    else
    begin
      Move(PBuf^,HashBuffer[Index],Size);
      Inc(Index,Size);
      Size:= 0;
    end;
  end;
end;

procedure TDCP_haval.Final(var Digest);
begin
  if not fInitialized then
    raise EDCP_hash.Create('Hash not initialized');
  HashBuffer[Index]:= $80;
  if Index> 118 then
    Compress;
  HashBuffer[118]:= ((256 and 3) shl 6) or (5 shl 3) or 1;
  HashBuffer[119]:= (256 shr 2) and $FF;
  PDWord(@HashBuffer[120])^:= LenLo1 or (longint(LenLo2) shl 16);
  Move(LenHi,HashBuffer[124],Sizeof(LenHi));
  Compress;
  Move(CurrentHash,Digest,256 div 8);
  Burn;
end;

initialization
  RegisterClass(TDCP_haval);
  DCPreghash(TDCP_haval);

end.

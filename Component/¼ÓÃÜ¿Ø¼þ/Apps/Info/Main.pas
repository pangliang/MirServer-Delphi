{******************************************************************************}
{* DCPcrypt v2.0 written by David Barton (davebarton@bigfoot.com) *************}
{******************************************************************************}
{* A program to display information about all the ciphers and hashes **********}
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
unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Twofish, Ice, RC4, Cast128, DCPcrypt, Blowfish, ComCtrls, Sha1, Rmd160,
  Md5, Md4, Haval, Cast256, DES, IDEA, Gost, Rijndael, RC2, RC5, RC6, Mars,
  Misty1;

type
  TMainFrm = class(TForm)
    PageControl: TPageControl;
    CipherSht: TTabSheet;
    HashSht: TTabSheet;
    CipherView: TListView;
    HashView: TListView;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainFrm: TMainFrm;

implementation

{$R *.DFM}

procedure TMainFrm.FormCreate(Sender: TObject);
var
  Item: TListItem;
  CipherInfo: PDCP_cipherinfo;
  HashInfo: PDCP_hashinfo;
begin
  CipherInfo:= DCPcipherlist;
  while (CipherInfo<> nil) do
  begin
    Item:= CipherView.Items.Add;
    Item.Caption:= CipherInfo.Cipher.GetAlgorithm;
    if CipherInfo.Block then
      Item.SubItems.Add(Format('%dbits',[TDCP_blockcipherclass(CipherInfo.Cipher).GetBlockSize]))
    else
      Item.SubItems.Add('N/A');
    Item.SubItems.Add(Format('%dbits',[CipherInfo.Cipher.GetMaxKeySize]));
    Item.SubItems.Add(Format('%d',[CipherInfo.Cipher.GetId]));
    if CipherInfo.Cipher.SelfTest then
      Item.SubItems.Add('Verified')
    else
      Item.SubItems.Add('Failed');
    CipherInfo:= CipherInfo.Next;
  end;
  HashInfo:= DCPhashlist;
  while (HashInfo<> nil) do
  begin
    Item:= HashView.Items.Add;
    Item.Caption:= HashInfo.Hash.GetAlgorithm;
    Item.SubItems.Add(Format('%dbits',[HashInfo.Hash.GetHashSize]));
    Item.SubItems.Add(Format('%d',[HashInfo.Hash.GetId]));
    if HashInfo.Hash.SelfTest then
      Item.SubItems.Add('Verified')
    else
      Item.SubItems.Add('Failed');
    HashInfo:= HashInfo.Next;
  end;
end;

end.

{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  10074: kpZTypes.pas 
{
{   Rev 1.3    5/20/2003 10:46:22 PM  Kevin    Version: VCLZip3.00z64c
}
{
{   Rev 1.2    5/19/2003 10:45:04 PM  Supervisor
{ After fixing streams.  VCLZip still uses ErrorRpt.  Also added setting of
{ capacity on the sorted containers to alleviate the memory problem caused by
{ growing array.
}
{
{   Rev 1.1    5/17/2003 7:25:14 AM  Supervisor    Version: Before soFrom to so
{ Save before changing soFrom to so for TStream.Seeks
}
{
{   Rev 1.0    10/15/2002 8:15:22 PM  Supervisor
}
{
{   Rev 1.2    9/7/2002 8:48:52 AM  Supervisor
{ Last modifications for FILE_INT
}
{
{   Rev 1.1    9/3/2002 10:40:44 PM  Supervisor
{ Modified appropriate longint's to FILE_INT's
}
{
{   Rev 1.0    9/3/2002 8:16:54 PM  Supervisor
}
{
{   Rev 1.2    Sat 04 Jul 1998   16:25:30  Supervisor
{ Modified ULONG to U_LONG because of ULONG 
{ definition in C++ Builder.
}
{
{   Rev 1.1    Mon 27 Apr 1998   17:31:48  Supervisor
{ Added new exception that is thrown when output files get 
{ larger than should be.
}

{ ********************************************************************************** }
{                                                                                    }
{   COPYRIGHT 1997 Kevin Boylan                                                    }
{     Source File: UZTypes.pas                                                       }
{     Description: VCLUnZip component - native Delphi unzip component.               }
{     Date:        March 1997                                                        }
{     Author:      Kevin Boylan, CIS: boylank                                        }
{                                Internet: boylank@compuserve.com                    }
{                                                                                    }
{ ********************************************************************************** }
type
 {$I KPDEFS.INC}

{$IFNDEF INT64STREAMS}
  TkpStream = TkpHugeStream;
  TkpFileStream = TkpHugeFileStream;
  TkpMemoryStream = TkpHugeMemoryStream;
{$ELSE}
  TkpStream = TStream;
  TkpFileStream = TFileStream;
  TkpMemoryStream = TMemoryStream;
{$ENDIF}

  FILE_INT = LongWord;

{ UNZIP }
  {$IFDEF HAS_64_BIT_INT}
  BIGINT = INT64;
  {$ELSE}
  BIGINT = LongInt;
  {$ENDIF}
  CharArrayPtr = ^CharArray;
  CharArray = array[0..MaxInt-1] of Char;
  ByteArrayPtr = ^ByteArray;
  ByteArray = array[0..MaxInt-1] of Byte;
  IntegerArrayPtr = ^IntegerArray;
  IntegerArray = array[0..MAX_SHORT-1] of Integer;
  IntPtr = ^Integer;
 BYTEPTR = PByte;
  WORDPTR = ^WORD;
 short_int = smallint;
  shrinktype = packed Record
     Prefix_of: array [0..HSIZE+2] of short_int;
     Suffix_of: array [0..HSIZE+2] of Byte;
     Stack    : array [0..HSIZE+2] of Byte;
  end;
  DataDescriptorType = packed Record
     Sig:     LongInt;
     crc32:   LongInt;
     compressed_size: FILE_INT;
     uncompressed_size: FILE_INT;
  end;

{$IFNDEF INFLATE_ONLY}
{ UNSHRINK }
{ EXPLODE }
{ UNREDUCE }
 f_array = array[0..255,0..63] of Byte;
  f_arrayPtr = ^f_array;      { 5/18/98  2.13 }
{$ENDIF}

{ INFLATE }
 huftptr = ^huft;
  huftptrptr = ^huftptr;
  huftarrayptr = ^huftarray;
  huft = packed Record
   e:  Byte;
     b:  Byte;
  v:  Record
      case Integer of
         0: (  n:  WORD );
         1: (  t:  huftptr );
     end;
  end;
  huftarray = packed array[-1..1000] of huft;
 llarrayptr = ^llarraytype;
 llarraytype = packed array [0..(286+30-1)] of WORD;

{ FILE }

 slidearray = array [0..WSIZE-1] of byte;
  slidearrayptr = ^slidearray;
  work = packed Record
     case Integer of
      0: (  shrink: shrinktype );
      1: ( Slide: slidearray);
   end;
 pString = ^String;
  ppString = ^pString;
  TZipFilename = String; {[FILENAME_LEN]; }
 TZipPathname = String; {[PATH_LEN]; }

 TNewDiskEvent = procedure(Sender: TObject; var S: TkpStream) of Object;


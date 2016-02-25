{*******************************************************}
{                                                       }
{       MiTeC System Information Component              }
{             Direct Memory Access                      }
{           version 8.6 for Delphi 5,6,7                }
{                                                       }
{       Copyright © 1997,2004 Michal Mutl               }
{                                                       }
{*******************************************************}

{$INCLUDE MITEC_DEF.INC}

unit MSI_DMA;

interface

uses Windows, Classes, SysUtils, MSI_Common;


type
  PMemoryBuffer = ^TMemoryBuffer;
  TMemoryBuffer = array[0..65535] of Char;
  TArrayBuffer = array[0..254] of Char;

  TDMA = class(TPersistent)
  private
    FPS: DWORD;
    FMemory: PChar;
    FStartAddress: DWORD;
    FSize: DWORD;
    FModes: TExceptionModes;
    function GetAddressByteValue(Address: DWORD): Byte;
    function GetAddressDwordValue(Address: DWORD): Dword;
    function GetAddressWordValue(Address: DWORD): Word;
    function GetAddressArrayValue(Address: DWORD; Length: Byte): TArrayBuffer;
    function GetAddressCharValue(Address: DWORD): Char;
    procedure SetMode(const Value: TExceptionModes);
  public
    constructor Create;
    function MapMemory(StartAddress: DWORD; Size: DWORD): Boolean;
    destructor Destroy; override;
    procedure SaveToFile(FileName: string);
    procedure SaveToStream(var S: TStream);

    procedure LoadFromStream(S: TStream);
    procedure LoadFromFile(FileName: string);

    property CharValue[Address: DWORD]: Char read GetAddressCharValue;
    property ByteValue[Address: DWORD]: Byte read GetAddressByteValue;
    property WordValue[Address: DWORD]: Word read GetAddressWordValue;
    property DWORDValue[Address: DWORD]: Dword read GetAddressDwordValue;
    property ArrayValue[Address: DWORD; Length: Byte]: TArrayBuffer read GetAddressArrayValue;

    function IsValidAddress(A: DWORD): Boolean;
    function FindSequence(StartAddr: DWORD; Sequence: string): DWORD;

    property Memory: PChar read FMemory;
    property StartAddress: DWORD read FStartAddress;
    property MemorySize: DWORD read FSize;
    property ExceptionModes: TExceptionModes read FModes Write SetMode;
  end;

resourcestring
  rsCannotMap = 'Cannot map physical memory to process memory!';
  rsNotAdmin = 'Cannot access physical memory!'#13#10+
              '(You should be a member of local administrators)';

implementation

uses Math, MiTeC_Routines, MiTeC_Native;

{$INCLUDE MSI_DMA.INC}

{ TDMA }

procedure TDMA.SaveToFile(FileName: string);
var
  fs: TFileStream;
begin
  fs:=TFileStream.Create(Filename,fmCreate or fmShareExclusive);
  try
    fs.WriteBuffer(FMemory[0],FSize);
  finally
    fs.Free;
  end;
end;

procedure TDMA.SaveToStream;
begin
  S.Size:=0;
  S.Position:=0;
  S.WriteBuffer(FMemory[0],FSize);
end;

procedure TDMA.LoadFromStream(S: TStream);
begin
  ReAllocMem(FMemory,S.Size);
  S.ReadBuffer(FMemory[0],S.Size);
  FStartAddress:=0;
  FSize:=S.Size;
end;

procedure TDMA.LoadFromFile(FileName: string);
var
  fs: TStream;
begin
  fs:=TFileStream.Create(Filename,fmOpenRead or fmShareDenyWrite);
  try
    Zeromemory(@FMemory^,Length(FMemory));
    LoadFromStream(fs);
  finally
    fs.Free;
  end;
end;

destructor TDMA.Destroy;
begin
  Reallocmem(FMemory,0);
  inherited;
end;

function TDMA.MapMemory;
const
  ObjPhysMem = '\Device\PhysicalMemory';
  ObjectName: TUnicodeString = (
    Length       : Length(ObjPhysMem) * SizeOf(WChar);
    MaximumLength: Length(ObjPhysMem) * SizeOf(WChar) + SizeOf(WChar);
    Buffer       : ObjPhysMem;
  );
  DesiredAccess: ACCESS_MASK = SECTION_MAP_READ;
  ObjectAttribs: TOBJECTATTRIBUTES =(
    Length                  : SizeOf(TOBJECTATTRIBUTES);
    RootDirectory           : 0;
    ObjectName              : @ObjectName;
    Attributes              : OBJ_CASE_INSENSITIVE;
    SecurityDescriptor      : nil;
    SecurityQualityOfService: nil;
  );


var
  SectionHandle: THandle;
  ViewOfPhysMem: Pointer;
  BlockStart,AddrOfs: DWORD;
  AddrSeg: Byte;
  s: string;
  TmpBuf: TMemoryBuffer;
begin
  {$IFDEF ERROR_INTERCEPT}PushTrace(FModes,Self,'MapMemory'); {$ENDIF}

  FStartAddress:=StartAddress;
  FSize:=Size;
  Result:=False;
  ReallocMem(FMemory,FSize);
  if Win32Platform=VER_PLATFORM_WIN32_NT then begin
    InitNativeAPI;
    if (NtOpenSection(@SectionHandle,DesiredAccess,@ObjectAttribs)=STATUS_SUCCESS) then
      try
        BlockStart:=StartAddress div FPS * FPS;
        ViewOfPhysMem:=MapViewOfFile(SectionHandle,DesiredAccess,0,StartAddress,Size+StartAddress-BlockStart);
        if Assigned(ViewOfPhysMem) then
          try
            ZeroMemory(FMemory,FSize);
            if StartAddress<BlockStart then
              Move(PChar(ViewOfPhysMem)[StartAddress],FMemory[0],FSize)
            else
              Move(PChar(ViewOfPhysMem)[StartAddress-BlockStart],FMemory[0],FSize);
            //Move(ViewOfPhysMem^,FMemory[0],FSize);
            Result:=True;
          finally
            UnmapViewOfFile(ViewOfPhysMem);
          end;
      finally
        NtClose(SectionHandle);
      end;
    if not Result then begin
      s:=IntToHex(StartAddress,8);
      AddrSeg:=StrToInt('$'+Copy(s,4,1)+Copy(s,3,1));
      AddrOfs:=StrToInt('$'+Copy(s,5,4));
      ReadRomBios16(AddrSeg,TmpBuf,INFINITE);
      Move(TmpBuf[AddrOfs],FMemory[0],FSize);
      Result:=True;
    end;
  end else begin
    try
      Move(ptr(StartAddress)^,FMemory[0],Size);
      Result:=True;
    except
    end;
  end;

  {$IFDEF ERROR_INTERCEPT}PopTrace;{$ENDIF}
end;

constructor TDMA.Create;
var
  SI: TSystemInfo;
begin
  inherited;
  ZeroMemory(@SI,SizeOf(SI));
  GetSystemInfo(SI);
  FPS:=SI.dwPageSize;
  ExceptionModes:=[emExceptionStack];
end;

function TDMA.GetAddressArrayValue;
begin
  try
    if Address+Length>FStartAddress+FSize then
      Length:=FStartAddress+FSize-Address;
    if (Address>=FStartAddress) and (Address<=FStartAddress+FSize) then
      Move(FMemory[Address-FStartAddress],Result[0],Length)
    else
      ZeroMemory(@Result,SizeOf(Result));
  except
    ZeroMemory(@Result,SizeOf(Result));
  end;
end;

function TDMA.GetAddressByteValue(Address: DWORD): Byte;
begin
  try
    if (Address>=FStartAddress) and (Address<=FStartAddress+FSize) then
      Result:=Ord(FMemory[Address-FStartAddress])
    else
      Result:=0;
  except
    Result:=0;
  end;
end;

function TDMA.GetAddressDwordValue(Address: DWORD): Dword;
begin
  try
    if (Address>=FStartAddress) and (Address<=(FStartAddress+FSize)-SizeOf(DWORD)) then
      Move(Fmemory[Address-FStartAddress],Result,SizeOf(DWORD))
    else
      Result:=0;
  except
    Result:=0;
  end;
end;

function TDMA.GetAddressWordValue(Address: DWORD): Word;
begin
  try
    if (Address>=FStartAddress) and ((Address+SizeOf(WORD))<=(FStartAddress+FSize)) then
      Move(Fmemory[Address-FStartAddress],Result,SizeOf(WORD))
    else
      Result:=0;
  except
    Result:=0;
  end
end;

function TDMA.FindSequence(StartAddr: DWORD; Sequence: string): DWORD;
var
  i,j,l: Integer;
  Buffer: TArrayBuffer;
  s: string;
  c: Char;
begin
  if not IsValidAddress(StartAddr) then
    StartAddr:=FStartAddress;
  Result:=0;
  Sequence:=UpperCase(Sequence);
  l:=Length(Sequence) div 2;
  c:=Chr(StrToInt('$'+Copy(Sequence,1,2)));
  for i:=StartAddr to FStartAddress+FSize do begin
    if (FMemory[i]=c) then begin
      ZeroMemory(@Buffer,SizeOf(Buffer));
      Buffer:=ArrayValue[i,l];
      s:='';
      for j:=0 to l-1 do
        s:=s+IntToHex(Ord(Buffer[j]),2);
      if s=Sequence then begin
        Result:=i;
        Break;
      end;
    end;
  end;
end;

function TDMA.IsValidAddress(A: DWORD): Boolean;
begin
  Result:=(A>=FStartAddress) and (A<=FStartAddress+FSize);
end;

function TDMA.GetAddressCharValue(Address: DWORD): Char;
begin
  if (Address>=FStartAddress) and (Address<=FStartAddress+FSize) then
    Result:=FMemory[Address-FStartAddress]
  else
    Result:=#0;
end;

procedure TDMA.SetMode(const Value: TExceptionModes);
begin
  FModes := Value;
end;

end.

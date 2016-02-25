unit EncryptUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs;
type
  TBase64 = class(TObject)
  private
    FOStream: TStream;
    FIStream: TStream;
  public
    { 输入流 }
    property IStream: TStream read FIStream write FIStream;
    { 输出流 }
    property OStream: TStream read FOStream write FOStream;
    { 编码 }
    function Encode(Str: string): string;
    { 解码 }
    function Decode(Str: string): string;
  end;
  function GetIdeSerialNumber():String;

implementation

const
  SBase64           : string =
    '23456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz~#%&*+-';
  UnBase64          : array[0..255] of Byte =
    (128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128,
    128,                                //, //0-15
    128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128,
    128,                                //  //16-31
    128, 128, 128, 58, 128, 59, 60, 128, 128, 128, 61, 62, 128, 63, 128, 128,
    //32-47
    128, 128, 0, 1, 2, 3, 4, 5, 6, 7, 128, 128, 128, 128, 128, 128, //48-63
    128, 8, 9, 10, 11, 12, 13, 14, 15, 128, 16, 17, 18, 19, 20, 128, //64-79
    21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 128, 128, 128, 128, 128, //80-95
    128, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 128, 43, 44, 45, //96-111
    46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 128, 128, 128, 57, 128, //112-127
    128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128,
    128,                                //128-143

    128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128,
    128,                                //144-159
    128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128,
    128,                                //160-175
    128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128,
    128,                                //176-191
    128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128,
    128,                                //192-207
    128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128,
    128,                                //208-223
    128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128,
    128,                                //224-239
    128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128,
    128);                               //240-255

  { TBase64 }

function TBase64.Decode(Str: string): string;
var
  j, k, len, Position: Integer;
  B                 : Byte;
  W, Tmp            : Byte;             //用于阅读流的临时变量
begin
  Result := '';
  if (Str <> '') then
  begin
    { 初始化}
    B := 0;
    j := 0;
    k := 2;
    len := Length(Str);
    Tmp := Ord(Str[1]);
    Position := 1;
    while (Position <= len) and (Char(Tmp) <> '.') do
    begin
      if j = 0 then
      begin
        B := UnBase64[Tmp];
        k := 2;
      end
      else
      begin
        W := UnBase64[Tmp] or ((B shl k) and $C0);
        Result := Result + Chr(W);
        Inc(k, 2);
      end;
      Inc(j);
      j := j and 3;
      Inc(Position);
      Tmp := Ord(Str[Position]);
    end;
  end;
end;

function TBase64.Encode(Str: string): string;
var
  SBuffer           : array[1..4] of Byte;
  j, k, len, Position: Integer;
  B                 : Byte;
  Tmp               : Byte;             {### 用于阅读流的临时变量 ###}
begin
  Result := '';
  if (Str <> '') then
  begin
    { 初始化 }
    len := Length(Str);
    Tmp := Ord(Str[1]);
    Position := 1;
    B := 0;
    j := 2;
    k := 2;
    while (Position <= len) do
    begin

      begin
        B := B or ((Tmp and $C0) shr k);
        Inc(k, 2);
        SBuffer[j] := Byte(SBase64[(Tmp and $3F) + 1]);
        Inc(j);
        if j > 4 then
        begin
          SBuffer[1] := Byte(SBase64[B + 1]);
          B := 0;
          j := 2;
          k := 2;
          Result := Result + Chr(SBuffer[1]);
        end;
      end;
    end;

    { 平整数据到 SBuffer }
    if j <> 2 then
    begin
      SBuffer[j] := Ord('.');
      SBuffer[1] := Byte(SBase64[B + 1]);
      for k := 1 to j do
        Result := Result + Chr(SBuffer[k]);
    end
    else
    begin
      SBuffer[1] := Ord('.');
      for k := 1 to j do
        Result := Result + Chr(SBuffer[k]);
    end;

  end;
end;

function GetIdeSerialNumber():String;
const IDENTIFY_BUFFER_SIZE = 512;
type
  TIDERegs = packed record
    bFeaturesReg : BYTE; // Used for specifying SMART "commands".
    bSectorCountReg : BYTE; // IDE sector count register
    bSectorNumberReg : BYTE; // IDE sector number register
    bCylLowReg : BYTE; // IDE low order cylinder value
    bCylHighReg : BYTE; // IDE high order cylinder value
    bDriveHeadReg : BYTE; // IDE drive/head register
    bCommandReg : BYTE; // Actual IDE command.
    bReserved : BYTE; // reserved for future use. Must be zero.
  end;
  TSendCmdInParams = packed record
    // Buffer size in bytes
    cBufferSize : DWORD;
    // Structure with drive register values.
    irDriveRegs : TIDERegs;
    // Physical drive number to send command to (0,1,2,3).
    bDriveNumber : BYTE;
    bReserved : Array[0..2] of Byte;
    dwReserved : Array[0..3] of DWORD;
    bBuffer : Array[0..0] of Byte; // Input buffer.
  end;

  TIdSector = packed record
    wGenConfig : Word;
    wNumCyls : Word;
    wReserved : Word;
    wNumHeads : Word;
    wBytesPerTrack : Word;
    wBytesPerSector : Word;
    wSectorsPerTrack : Word;
    wVendorUnique : Array[0..2] of Word;
    sSerialNumber : Array[0..19] of CHAR;
    wBufferType : Word;
    wBufferSize : Word;
    wECCSize : Word;
    sFirmwareRev : Array[0..7] of Char;
    sModelNumber : Array[0..39] of Char;
    wMoreVendorUnique : Word;
    wDoubleWordIO : Word;
    wCapabilities : Word;
    wReserved1 : Word;
    wPIOTiming : Word;
    wDMATiming : Word;
    wBS : Word;
    wNumCurrentCyls : Word;
    wNumCurrentHeads : Word;
    wNumCurrentSectorsPerTrack : Word;
    ulCurrentSectorCapacity : DWORD;
    wMultSectorStuff : Word;
    ulTotalAddressableSectors : DWORD;
    wSingleWordDMA : Word;
    wMultiWordDMA : Word;
    bReserved : Array[0..127] of BYTE;
  end;
  PIdSector = ^TIdSector;

  TDriverStatus = packed record
    // Error code from driver, or 0 if no error.
    bDriverError : Byte;
    // Contents of IDE Error register. Only valid when bDriverError is SMART_IDE_ERROR.
    bIDEStatus : Byte;
    bReserved : Array[0..1] of Byte;
    dwReserved : Array[0..1] of DWORD;
  end;

  TSendCmdOutParams = packed record
    // Size of bBuffer in bytes
    cBufferSize : DWORD;
    // Driver status structure.
    DriverStatus : TDriverStatus;
    // Buffer of arbitrary length in which to store the data read from the drive.
    bBuffer : Array[0..0] of BYTE;
  end;

var
  hDevice : THandle;
  cbBytesReturned : DWORD;
  ptr : PChar;
  SCIP : TSendCmdInParams;
  aIdOutCmd : Array
  [0..(SizeOf(TSendCmdOutParams)+IDENTIFY_BUFFER_SIZE -1)-1] of Byte;
  IdOutCmd : TSendCmdOutParams absolute aIdOutCmd;

  procedure ChangeByteOrder( var Data; Size : Integer );
  var
    ptr : PChar;
    i : Integer;
    c : Char;
  begin
    ptr := @Data;
    for i := 0 to (Size shr 1)-1 do begin
      c := ptr^;
      ptr^ := (ptr+1)^;
      (ptr+1)^ := c;
      Inc(ptr,2);
    end;
  end;
begin
  Result := ''; // return empty string on error
  if SysUtils.Win32Platform=VER_PLATFORM_WIN32_NT then // Windows NT,Windows 2000
  begin
    // warning! change name for other drives: ex.: second drive '\\.\PhysicalDrive1\'
    hDevice := CreateFile( '\\.\PhysicalDrive0', GENERIC_READ or
    GENERIC_WRITE,
    FILE_SHARE_READ or FILE_SHARE_WRITE, nil, OPEN_EXISTING, 0, 0 );
  end else // Version Windows 95 OSR2, Windows 98
    hDevice := CreateFile( '\\.\SMARTVSD', 0, 0, nil, CREATE_NEW, 0, 0 );
  if hDevice=INVALID_HANDLE_VALUE then Exit;

  try
    FillChar(SCIP,SizeOf(TSendCmdInParams)-1,#0);
    FillChar(aIdOutCmd,SizeOf(aIdOutCmd),#0);
    cbBytesReturned := 0;
    // Set up data structures for IDENTIFY command.
    with SCIP do begin
      cBufferSize := IDENTIFY_BUFFER_SIZE;
      // bDriveNumber := 0;
      with irDriveRegs do begin
        bSectorCountReg := 1;
        bSectorNumberReg := 1;
        // if Win32Platform=VER_PLATFORM_WIN32_NT then bDriveHeadReg := $A0
        // else bDriveHeadReg := $A0 or ((bDriveNum and 1) shl 4);
        bDriveHeadReg := $A0;
        bCommandReg := $EC;
      end;
    end;
    if not DeviceIoControl( hDevice, $0007c088, @SCIP,
    SizeOf(TSendCmdInParams)-1,
    @aIdOutCmd, SizeOf(aIdOutCmd), cbBytesReturned, nil ) then Exit;
  finally
    CloseHandle(hDevice);
  end;

  with PIdSector(@IdOutCmd.bBuffer)^ do begin
    ChangeByteOrder( sSerialNumber, SizeOf(sSerialNumber) );
    (PChar(@sSerialNumber)+SizeOf(sSerialNumber))^ := #0;
    Result := PChar(@sSerialNumber);
  end;
end;

end.


{*******************************************************}
{                                                       }
{       MiTeC System Information Component              }
{               Windows IOCTL                           }
{           version 8.6 for Delphi 5,6,7                }
{                                                       }
{       Copyright © 1997,2004 Michal Mutl               }
{                                                       }
{*******************************************************}

{$INCLUDE MITEC_DEF.INC}

unit MiTeC_WinIOCTL;

interface

uses Windows, SysUtils;

type
  TSrbIoControl = packed record
    HeaderLength : ULONG;
    Signature    : Array[0..7] of Char;
    Timeout      : ULONG;
    ControlCode  : ULONG;
    ReturnCode   : ULONG;
    Length       : ULONG;
  end;
  SRB_IO_CONTROL = TSrbIoControl;
  PSrbIoControl = ^TSrbIoControl;

  TIDERegs = packed record
    bFeaturesReg     : Byte; // Used for specifying SMART "commands".
    bSectorCountReg  : Byte; // IDE sector count register
    bSectorNumberReg : Byte; // IDE sector number register
    bCylLowReg       : Byte; // IDE low order cylinder value
    bCylHighReg      : Byte; // IDE high order cylinder value
    bDriveHeadReg    : Byte; // IDE drive/head register
    bCommandReg      : Byte; // Actual IDE command.
    bReserved        : Byte; // reserved.  Must be zero.
  end;
  IDEREGS   = TIDERegs;
  PIDERegs  = ^TIDERegs;

  TSendCmdInParams = packed record
    cBufferSize  : DWORD;
    irDriveRegs  : TIDERegs;
    bDriveNumber : Byte;
    bReserved    : Array[0..2] of Byte;
    dwReserved   : Array[0..3] of DWORD;
    bBuffer      : Array[0..0] of Byte;
  end;
  SENDCMDINPARAMS   = TSendCmdInParams;
  PSendCmdInParams  = ^TSendCmdInParams;

   // Status returned from driver
  TDriverStatus = record
    bDriverError,  //  Error code from driver, or 0 if no error.
    bIDEStatus: BYTE;    //  Contents of IDE Error register.
                        //  Only valid when bDriverError is SMART_IDE_ERROR.
    bReserved: array[0..1] of BYTE;  //  Reserved for future expansion.
    dwReserved: array[0..1] of DWORD;  //  Reserved for future expansion.
  end;
  DRIVERSTATUS = TDriverStatus;
  PDriverStatus = ^TDriverStatus;

     // Structure returned by PhysicalDrive IOCTL for several commands
  TSendCmdOutParams = record
    cBufferSize: DWORD;   //  Size of bBuffer in bytes
    DriverStatus: TDriverStatus;  //  Driver status structure.
    bBuffer: array[0..0] of BYTE;    //  Buffer of arbitrary length in which to store the data read from the                                                       // drive.
  end;
  SENDCMDOUTPARAMS = TSendCmdOutParams;
  PSendCmdOutParams = ^TSendCmdOutParams;

  TIdSector = packed record
    wGenConfig                 : Word;
    wNumCyls                   : Word;
    wReserved                  : Word;
    wNumHeads                  : Word;
    wUnformattedBytesPerTrack  : Word;
    wUnformattedBytesPerSector : Word;
    wSectorsPerTrack           : Word;
    wVendorUnique              : Array[0..2] of Word;
    sSerialNumber              : Array[0..19] of Char;
    wBufferType                : Word;
    wBufferSize                : Word;
    wECCSize                   : Word;
    sFirmwareRev               : Array[0..7] of Char;
    sModelNumber               : Array[0..39] of Char;
    wMoreVendorUnique          : Word;
    wDoubleWordIO              : Word;
    wCapabilities              : Word;
    wReserved1                 : Word;
    wPIOTiming                 : Word;
    wDMATiming                 : Word;
    wBS                        : Word;
    wNumCurrentCyls            : Word;
    wNumCurrentHeads           : Word;
    wNumCurrentSectorsPerTrack : Word;
    ulCurrentSectorCapacity    : ULONG;
    wMultSectorStuff           : Word;
    ulTotalAddressableSectors  : ULONG;
    wSingleWordDMA             : Word;
    wMultiWordDMA              : Word;
    AdvancedPIOModes,
    Reserved4,
    MinimumMWXferCycleTime,
    RecommendedMWXferCycleTime,
    MinimumPIOCycleTime,
    MinimumPIOCycleTimeIORDY: Word;
    Reserved5: array[0..1] of Word;
    ReleaseTimeOverlapped,
    ReleaseTimeServiceCommand,
    MajorRevision,
    MinorRevision: Word;
    Reserved6: array[0..49] of Word;
    SpecialFunctionsEnabled: Word;
    Reserved7: array[0..127] of Word;
  end;
  PIdSector = ^TIdSector;

  TGetVersionOutParams = record
    bVersion,      // Binary driver version.
    bRevision,     // Binary driver revision.
    bReserved,     // Not used.
    bIDEDeviceMap: BYTE; // Bit map of IDE devices.
    fCapabilities: DWORD; // Bit mask of driver capabilities.
    dwReserved: array[0..3] of DWORD; // For future use.
  end;
  GETVERSIONOUTPARAMS = TGetVersionOutParams;
  PGetVersionOutParams = ^TGetVersionOutParams;

  TMediaType = (
    Unknown,                // Format is unknown
    F5_1Pt2_512,            // 5.25", 1.2MB,  512 bytes/sector
    F3_1Pt44_512,           // 3.5",  1.44MB, 512 bytes/sector
    F3_2Pt88_512,           // 3.5",  2.88MB, 512 bytes/sector
    F3_20Pt8_512,           // 3.5",  20.8MB, 512 bytes/sector
    F3_720_512,             // 3.5",  720KB,  512 bytes/sector
    F5_360_512,             // 5.25", 360KB,  512 bytes/sector
    F5_320_512,             // 5.25", 320KB,  512 bytes/sector
    F5_320_1024,            // 5.25", 320KB,  1024 bytes/sector
    F5_180_512,             // 5.25", 180KB,  512 bytes/sector
    F5_160_512,             // 5.25", 160KB,  512 bytes/sector
    RemovableMedia,         // Removable media other than floppy
    FixedMedia,             // Fixed hard disk media
    F3_120M_512,            // 3.5", 120M Floppy
    F3_640_512,             // 3.5" ,  640KB,  512 bytes/sector
    F5_640_512,             // 5.25",  640KB,  512 bytes/sector
    F5_720_512,             // 5.25",  720KB,  512 bytes/sector
    F3_1Pt2_512,            // 3.5" ,  1.2Mb,  512 bytes/sector
    F3_1Pt23_1024,          // 3.5" ,  1.23Mb, 1024 bytes/sector
    F5_1Pt23_1024,          // 5.25",  1.23MB, 1024 bytes/sector
    F3_128Mb_512,           // 3.5" MO 128Mb   512 bytes/sector
    F3_230Mb_512,           // 3.5" MO 230Mb   512 bytes/sector
    F8_256_128,             // 8",     256KB,  128 bytes/sector
    F3_200Mb_512,           // 3.5",   200M Floppy (HiFD)
    F3_240M_512,            // 3.5",   240Mb Floppy (HiFD)
    F3_32M_512);            // 3.5",   32Mb Floppy
  MEDIA_TYPE = TMediaType;
  PMediaType = ^TMediaType;

  TPartitionInformation = record
    StartingOffset: LARGE_INTEGER;
    PartitionLength: LARGE_INTEGER;
    HiddenSectors: DWORD;
    PartitionNumber: DWORD;
    PartitionType: BYTE;
    BootIndicator: ByteBool;
    RecognizedPartition: ByteBool;
    RewritePartition: ByteBool;
  end;
  PARTITION_INFORMATION = TPartitionInformation;
  PPartitionInformation = ^TPartitionInformation;

  TDriveLayoutInformation = record
    PartitionCount: DWORD;
    Signature: DWORD;
    PartitionEntry: array [0..0] of TPartitionInformation;
  end;
  DRIVE_LAYOUT_INFORMATION = TDriveLayoutInformation;
  PDriveLayoutInformation = ^TDriveLayoutInformation;

  TDiskGeometry = record
    Cylinders: LARGE_INTEGER;
    MediaType: TMediaType;
    TracksPerCylinder: DWORD;
    SectorsPerTrack: DWORD;
    BytesPerSector: DWORD;
  end;
  DISK_GEOMETRY = TDiskGeometry;
  PDiskGeometry = ^TDiskGeometry;

  TDiskControllerNumber = record
    ControllerNumber: DWORD;
    DiskNumber: DWORD;
  end;
  DISK_CONTROLLER_NUMBER = TDiskControllerNumber;
  PDiskControllerNumber = ^TDiskControllerNumber;

  TScsiPassThrough = record
    Length             : Word;
    ScsiStatus         : Byte;
    PathId             : Byte;
    TargetId           : Byte;
    Lun                : Byte;
    CdbLength          : Byte;
    SenseInfoLength    : Byte;
    DataIn             : Byte;
    DataTransferLength : ULONG;
    TimeOutValue       : ULONG;
    DataBufferOffset   : DWORD;
    SenseInfoOffset    : ULONG;
    Cdb                : Array[0..15] of Byte;
  end;

  TScsiPassThroughWithBuffers = record
    spt : TScsiPassThrough;
    bSenseBuf : Array[0..31] of Byte;
    bDataBuf : Array[0..191] of Byte;
  end;

  TCDB6GENERIC = record
    OperationCode: Byte;
    Immediate: Byte;
    CommandUniqueBits: Byte;
    LogicalUnitNumber: Byte;
    CommandUniqueBytes: array[0..2] of Byte;
    Link: Byte;
    Flag: Byte;
    Reserved: Byte;
    VendorUnique: Byte;
  end;


const
   //  Valid values for the bCommandReg member of IDEREGS.
  IDE_ATAPI_IDENTIFY = $A1;  //  Returns ID sector for ATAPI.
  IDE_ATA_IDENTIFY = $EC;  //  Returns ID sector for ATA.

  IDENTIFY_BUFFER_SIZE       = 512;

  DFP_GET_VERSION = $00074080;
  DFP_SEND_DRIVE_COMMAND = $0007c084;
  DFP_RECEIVE_DRIVE_DATA = $0007c088;

  METHOD_BUFFERED   = 0;

  FILE_DEVICE_UNKNOWN = $00000022;
  FILE_DEVICE_SCSI = $0000001B;
  FILE_DEVICE_DISK = $00000007;
  FILE_DEVICE_FILE_SYSTEM = $00000009;
  FILE_DEVICE_CONTROLLER = $00000004;

  FILE_ANY_ACCESS     = 0;
  FILE_SPECIAL_ACCESS = FILE_ANY_ACCESS;
  FILE_READ_ACCESS    = $0001;           // file & pipe
  FILE_WRITE_ACCESS   = $0002;           // file & pipe

  SCSI_IOCTL_DATA_OUT =         0;
  SCSI_IOCTL_DATA_IN  =         1;
  SCSI_IOCTL_DATA_UNSPECIFIED = 2;

  CDB_INQUIRY_EVPD = 1;

  SCSIOP_INQUIRY = $12;

  CDB6GENERIC_LENGTH = 6;

  IOCTL_SCSI_BASE = FILE_DEVICE_CONTROLLER;
  IOCTL_SCSI_MINIPORT_IDENTIFY = ((FILE_DEVICE_SCSI shl 16) + $0501); //$001b0501
  IOCTL_SCSI_MINIPORT = ((IOCTL_SCSI_BASE shl 16) or ($0402 shl 2) or METHOD_BUFFERED or ((FILE_READ_ACCESS or FILE_WRITE_ACCESS) shl 14));
  IOCTL_SCSI_PASS_THROUGH = ((IOCTL_SCSI_BASE shl 16) or ($0401 shl 2) or METHOD_BUFFERED or ((FILE_READ_ACCESS or FILE_WRITE_ACCESS) shl 14));
  IOCTL_SCSI_GET_INQUIRY_DATA = ((IOCTL_SCSI_BASE shl 16) or ($0403 shl 2) or METHOD_BUFFERED or (FILE_ANY_ACCESS shl 14));
  IOCTL_SCSI_GET_CAPABILITIES = ((IOCTL_SCSI_BASE shl 16) or ($0404 shl 2) or METHOD_BUFFERED or (FILE_ANY_ACCESS shl 14));
  IOCTL_SCSI_PASS_THROUGH_DIRECT = ((IOCTL_SCSI_BASE shl 16) or ($0405 shl 2) or METHOD_BUFFERED or ((FILE_READ_ACCESS or FILE_WRITE_ACCESS) shl 14));
  IOCTL_SCSI_GET_ADDRESS = ((IOCTL_SCSI_BASE shl 16) or ($0406 shl 2) or METHOD_BUFFERED or (FILE_ANY_ACCESS shl 14));
  IOCTL_SCSI_RESCAN_BUS = ((IOCTL_SCSI_BASE shl 16) or ($0407 shl 2) or METHOD_BUFFERED or (FILE_ANY_ACCESS shl 14));
  IOCTL_SCSI_GET_DUMP_POINTERS = ((IOCTL_SCSI_BASE shl 16) or ($0408 shl 2) or METHOD_BUFFERED or (FILE_ANY_ACCESS shl 14));

  IOCTL_DISK_BASE = FILE_DEVICE_DISK;
  IOCTL_DISK_GET_DRIVE_GEOMETRY = (
    (IOCTL_DISK_BASE shl 16) or (FILE_ANY_ACCESS shl 14) or
    ($0000 shl 2) or METHOD_BUFFERED);
  IOCTL_DISK_GET_PARTITION_INFO = (
    (IOCTL_DISK_BASE shl 16) or (FILE_READ_ACCESS shl 14) or
    ($0001 shl 2) or METHOD_BUFFERED);
  IOCTL_DISK_GET_DRIVE_LAYOUT = (
    (IOCTL_DISK_BASE shl 16) or (FILE_READ_ACCESS shl 14) or
    ($0003 shl 2) or METHOD_BUFFERED);
  IOCTL_VOLUME_BASE = DWORD('V');
  IOCTL_VOLUME_GET_VOLUME_DISK_EXTENTS = (
    (IOCTL_VOLUME_BASE shl 16) or (FILE_ANY_ACCESS shl 14) or
    (0 shl 2) or METHOD_BUFFERED);
  IOCTL_DISK_CONTROLLER_NUMBER = (
    (IOCTL_DISK_BASE shl 16) or (FILE_ANY_ACCESS shl 14) or
    ($0011 shl 2) or METHOD_BUFFERED);

  FSCTL_LOCK_VOLUME = ((FILE_DEVICE_FILE_SYSTEM shl 16) or (FILE_ANY_ACCESS shl 14) or (6 shl 2) or METHOD_BUFFERED);

  FSCTL_UNLOCK_VOLUME = (
    (FILE_DEVICE_FILE_SYSTEM shl 16) or (FILE_ANY_ACCESS shl 14) or
    (7 shl 2) or METHOD_BUFFERED);


  VWIN32_DIOC_DOS_IOCTL21 = 1; // INT 21h - 4400h, 4411h
  VWIN32_DIOC_DOS_IOCTL25 = 2; // INT 25h - Disk Read
  VWIN32_DIOC_DOS_IOCTL26 = 3; // INT 26h - Disk Write
  VWIN32_DIOC_DOS_IOCTL13 = 4; // INT 13h
  VWIN32_DIOC_DOS_DRIVEINFO = 6; // INT 21h - Function 730X commands

   //  Bits returned in the fCapabilities member of GETVERSIONOUTPARAMS
  CAP_IDE_ID_FUNCTION = 1;  // ATA ID command supported
  CAP_IDE_ATAPI_ID = 2;  // ATAPI ID command supported
  CAP_IDE_EXECUTE_SMART_FUNCTION = 4;  // SMART commannds supported

  DataSize = sizeof(TSendCmdInParams)-1+IDENTIFY_BUFFER_SIZE;
  BufferSize = SizeOf(SRB_IO_CONTROL)+DataSize;
  W9xBufferSize = IDENTIFY_BUFFER_SIZE+16;

  PARTITION_ENTRY_UNUSED    = $00; // Entry unused
  PARTITION_FAT_12          = $01; // 12-bit FAT entries
  PARTITION_XENIX_1         = $02; // Xenix
  PARTITION_XENIX_2         = $03; // Xenix
  PARTITION_FAT_16          = $04; // 16-bit FAT entries
  PARTITION_EXTENDED        = $05; // Extended partition entry
  PARTITION_HUGE            = $06; // Huge partition MS-DOS V4
  PARTITION_IFS             = $07; // IFS Partition
  PARTITION_OS2BOOTMGR      = $0A; // OS/2 Boot Manager/OPUS/Coherent swap
  PARTITION_FAT32           = $0B; // FAT32
  PARTITION_FAT32_XINT13    = $0C; // FAT32 using extended int13 services
  PARTITION_XINT13          = $0E; // Win95 partition using extended int13 services
  PARTITION_XINT13_EXTENDED = $0F; // Same as type 5 but uses extended int13 services
  PARTITION_PREP            = $41; // PowerPC Reference Platform (PReP) Boot Partition
  PARTITION_LDM             = $42; // Logical Disk Manager partition
  PARTITION_UNIX            = $63; // Unix
  VALID_NTFT                = $C0; // NTFT uses high order bits
// The high bit of the partition type code indicates that a partition
// is part of an NTFT mirror or striped array.
  PARTITION_NTFT = $80; // NTFT partition

  bBytesPerSector = 512;

type
  TDiskLayout = array of TPartitionInformation;

  TDriveInfo = record
    SerialNumber,                             
    Model,
    Revision: string;
    Capacity: Int64;
  end;

function IsRecognizedPartition(PartitionType: DWORD): Boolean;
function IsContainerPartition(PartitionType: DWORD): Boolean;
function IsFTPartition(PartitionType: DWORD): Boolean;
function GetPartitionSystem(PartitionType: DWORD): string;
function GetPartitionType(PartitionNumber,PartitionType: DWORD): string;
function GetMediaTypeStr(Value: TMediaType): string;

function GetDeviceHandle(sDeviceName: string): THandle;
function GetSCSIDeviceInfo(DeviceHandle: THandle; out DI: TDriveInfo): integer;
function GetSCSIDiskInfo(DeviceHandle,DeviceNumber: Byte; out DI: TDriveInfo; out DG: TDiskGeometry): Integer;
function GetPhysicalDiskInfo(DeviceHandle: THandle; out DI: TDriveInfo; out DG: TDiskGeometry): Integer;
function GetSMARTDiskInfo(Drive: Byte; out DI: TDriveInfo; out DG: TDiskGeometry): Integer;
function GetDiskGeometry(DeviceHandle: THandle; out DG: TDiskGeometry): Integer;
function GetDiskLayout(DeviceHandle: THandle; out DL: TDiskLayout): Integer;
function GetDiskController(Drive: Byte; out DC: TDiskControllerNumber): Integer;
function ReadPhysicalSector(Drive: Byte; StartSector: DWORD; SectorsToRead: byte; Dump: Pointer): Integer;

implementation

uses Math;

function ByteArrayToStr(Buffer: array of byte): string;
var
  i: Integer;
begin
  Result:='';
  for i:=0 to High(Buffer) do
    Result:=Result+Chr(Buffer[i]);
end;

procedure ChangeByteOrder( var Data; Size : Integer );
var
  ptr: PChar;
  i: Integer;
  c: Char;
begin
  ptr:=@Data;
  for i:=0 to (Size shr 1)-1 do begin
    c:=ptr^;
    ptr^:=(ptr+1)^;
    (ptr+1)^:=c;
    Inc(ptr,2);
  end;
end;

function IsRecognizedPartition(PartitionType: DWORD): Boolean;
begin
  Result :=
    (((PartitionType and PARTITION_NTFT) <> 0) and ((PartitionType and not $C0) = PARTITION_FAT_12)) or
    (((PartitionType and PARTITION_NTFT) <> 0) and ((PartitionType and not $C0) = PARTITION_IFS)) or
    (((PartitionType and PARTITION_NTFT) <> 0) and ((PartitionType and not $C0) = PARTITION_HUGE)) or
    (((PartitionType and PARTITION_NTFT) <> 0) and ((PartitionType and not $C0) = PARTITION_FAT32)) or
    (((PartitionType and PARTITION_NTFT) <> 0) and ((PartitionType and not $C0) = PARTITION_FAT32_XINT13)) or
    (((PartitionType and PARTITION_NTFT) <> 0) and ((PartitionType and not $C0) = PARTITION_XINT13)) or
    ((PartitionType) = PARTITION_FAT_12) or
    ((PartitionType) = PARTITION_FAT_16) or
    ((PartitionType) = PARTITION_IFS) or
    ((PartitionType) = PARTITION_HUGE) or
    ((PartitionType) = PARTITION_FAT32) or
    ((PartitionType) = PARTITION_FAT32_XINT13) or
    ((PartitionType) = PARTITION_XINT13);
end;

function IsContainerPartition(PartitionType: DWORD): Boolean;
begin
  Result :=
    (PartitionType = PARTITION_EXTENDED) or
    (PartitionType = PARTITION_XINT13_EXTENDED);
end;

function IsFTPartition(PartitionType: DWORD): Boolean;
begin
  Result := ((PartitionType and PARTITION_NTFT) = PARTITION_NTFT) and IsRecognizedPartition(PartitionType);
end;

function GetPartitionSystem;
begin
  case PartitionType of
    PARTITION_FAT_12: Result:='FAT12';
    PARTITION_FAT_16,
    PARTITION_HUGE: Result:='FAT16';
    PARTITION_FAT32,
    PARTITION_FAT32_XINT13,
    PARTITION_XINT13,
    PARTITION_XINT13_EXTENDED: Result:='FAT32';
    PARTITION_IFS: Result:='NTFS';
    PARTITION_OS2BOOTMGR: Result:='HPFS';
    PARTITION_XENIX_1,
    PARTITION_XENIX_2: Result:='Xenix';
    PARTITION_UNIX: Result:='Unix';
    else Result:='Unknown';
  end;
end;

function GetPartitionType;
begin
  Result:='Primary';
  if IsContainerPartition(PartitionType) then
    Result:='Extended';
  if IsFTPartition(PartitionType) then
    Result:='FT';
  if not IsContainerPartition(PartitionType) and (PartitionNumber>1) then
    Result:='Logical';
end;

function GetMediaTypeStr;
begin
  case Value of
    Unknown:                Result:='<unknown>';
    F5_1Pt2_512:            Result:='5.25": 1.2MB:  512 bytes/sector';
    F3_1Pt44_512:           Result:='3.5": 1.44MB: 512 bytes/sector';
    F3_2Pt88_512:           Result:='3.5": 2.88MB: 512 bytes/sector';
    F3_20Pt8_512:           Result:='3.5": 20.8MB: 512 bytes/sector';
    F3_720_512:             Result:='3.5": 720KB:  512 bytes/sector';
    F5_360_512:             Result:='5.25": 360KB: 512 bytes/sector';
    F5_320_512:             Result:='5.25": 320KB: 512 bytes/sector';
    F5_320_1024:            Result:='5.25": 320KB: 1024 bytes/sector';
    F5_180_512:             Result:='5.25": 180KB: 512 bytes/sector';
    F5_160_512:             Result:='5.25": 160KB: 512 bytes/sector';
    RemovableMedia:         Result:='Removable media';
    FixedMedia:             Result:='Fixed disk';
    F3_120M_512:            Result:='3.5": 120M Floppy';
    F3_640_512:             Result:='3.5" : 640KB: 512 bytes/sector';
    F5_640_512:             Result:='5.25": 640KB: 512 bytes/sector';
    F5_720_512:             Result:='5.25": 720KB: 512 bytes/sector';
    F3_1Pt2_512:            Result:='3.5" : 1.2Mb: 512 bytes/sector';
    F3_1Pt23_1024:          Result:='3.5" : 1.23Mb: 1024 bytes/sector';
    F5_1Pt23_1024:          Result:='5.25": 1.23MB: 1024 bytes/sector';
    F3_128Mb_512:           Result:='3.5" MO 128Mb 512 bytes/sector';
    F3_230Mb_512:           Result:='3.5" MO 230Mb 512 bytes/sector';
    F8_256_128:             Result:='8": 256KB: 128 bytes/sector';
    F3_200Mb_512:           Result:='3.5": 200M Floppy (HiFD)';
    F3_240M_512:            Result:='3.5": 240Mb Floppy (HiFD)';
    F3_32M_512:             Result:='3.5": 32Mb Floppy';
  end;
end;

function GetDeviceHandle;
begin
  Result:=CreateFile(PChar('\\.\'+sDeviceName),
                     GENERIC_READ or GENERIC_WRITE,
		     FILE_SHARE_READ or FILE_SHARE_WRITE,
                     nil,
                     OPEN_EXISTING,
                     0,
                     0);
end;

function GetScsiDeviceInfo;
var
  dwReturned: DWORD;
  len: DWORD;
  Buffer: array[0..SizeOf(TScsiPassThroughWithBuffers)+SizeOf(TScsiPassThrough)-1] of Byte;
  sptwb: TScsiPassThroughWithBuffers absolute Buffer;
begin
  Result:=0;
  FillChar(Buffer,SizeOf(Buffer),#0);
  with sptwb.spt do begin
    Length:=SizeOf(TScsiPassThrough);
    CdbLength:=CDB6GENERIC_LENGTH;
    SenseInfoLength:=24;
    DataIn:=SCSI_IOCTL_DATA_IN;
    DataTransferLength:=192;
    TimeOutValue:=2;
    DataBufferOffset:=PChar(@sptwb.bDataBuf)-PChar(@sptwb);
    SenseInfoOffset:=PChar(@sptwb.bSenseBuf)-PChar(@sptwb);
    Cdb[0]:=SCSIOP_INQUIRY;
    Cdb[1]:=CDB_INQUIRY_EVPD; //	Vital product data
    Cdb[2]:=$80; //	PageCode            Unit serial number
    Cdb[4]:=192; // AllocationLength
  end;
  len:=sptwb.spt.DataBufferOffset+sptwb.spt.DataTransferLength;
  if DeviceIoControl(DeviceHandle,IOCTL_SCSI_PASS_THROUGH,@sptwb,SizeOf(TScsiPassThrough),@sptwb,len,dwReturned,nil)
     and ((PChar(@sptwb.bDataBuf)+1)^=#$80) then begin
    SetString(DI.Revision,PChar(@sptwb.bDataBuf)+8,Ord((PChar(@sptwb.bDataBuf)+3)^));
    DI.Model:=Trim(Copy(DI.Revision,1,Pos(#32#32,DI.Revision)));
    DI.Revision:=Trim(Copy(DI.Revision,Pos(#32#32,DI.Revision),255));
    DI.SerialNumber:=Trim(Copy(DI.Revision,1,Pos(#32#32,DI.Revision)));
    DI.Revision:=Trim(Copy(DI.Revision,Pos(#32#32,DI.Revision),255));
  end else
    Result:=GetLastError;
end;

function GetSCSIDiskInfo;
var
  cbBytesReturned: DWORD;
  pInData: PSendCmdInParams;
  pOutData: Pointer; // PSendCmdOutParams
  Buffer: array[0..BufferSize-1] of Byte;
  srbControl: TSrbIoControl absolute Buffer;
begin
  Result:=0;
  ZeroMemory(@DI,SizeOf(TDriveInfo));
  ZeroMemory(@DG,SizeOf(TDiskGeometry));
  FillChar(Buffer,BufferSize,#0);
  srbControl.HeaderLength := SizeOf(SRB_IO_CONTROL);
  System.Move('SCSIDISK',srbControl.Signature,8);
  srbControl.Timeout      := 2;
  srbControl.Length       := DataSize;
  srbControl.ControlCode  := IOCTL_SCSI_MINIPORT_IDENTIFY;
  pInData := PSendCmdInParams(PChar(@Buffer)
             +SizeOf(SRB_IO_CONTROL));
  pOutData := pInData;
  with pInData^ do begin
    cBufferSize  := IDENTIFY_BUFFER_SIZE;
    bDriveNumber := DeviceNumber;
    with irDriveRegs do begin
      bFeaturesReg     := 0;
      bSectorCountReg  := 1;
      bSectorNumberReg := 1;
      bCylLowReg       := 0;
      bCylHighReg      := 0;
      bDriveHeadReg    := $A0;
      bCommandReg      := IDE_ATA_IDENTIFY;
    end;
  end;
  if DeviceIoControl(DeviceHandle, IOCTL_SCSI_MINIPORT,
                     @Buffer, BufferSize, @Buffer, BufferSize,
                     cbBytesReturned, nil ) then
    with PIdSector(PChar(pOutData)+16)^ do begin
      ChangeByteOrder(sSerialNumber,SizeOf(sSerialNumber));
      DI.SerialNumber:=Trim(sSerialNumber);
      ChangeByteOrder(sFirmwareRev,SizeOf(sFirmwareRev));
      DI.Revision:=Trim(sFirmwareRev);
      ChangeByteOrder(sModelNumber,SizeOf(sModelNumber));
      DI.Model:=Trim(sModelNumber);
      try
        DG.Cylinders.QuadPart:=Round((ulTotalAddressableSectors/wSectorsPerTrack)/wNumHeads);
      except
        DG.Cylinders.QuadPart:=0;
      end;
      DG.TracksPerCylinder:=wNumHeads;
      DG.SectorsPerTrack:=wSectorsPerTrack;
      DG.BytesPerSector:=wUnformattedBytesPerSector;
      if DG.BytesPerSector=0 then
        DG.BytesPerSector:=bBytesPerSector;
      DI.Capacity:=Int64(ulTotalAddressableSectors)*DG.BytesPerSector;
    end
  else begin
    Result:=GetLastError;
    DI.SerialNumber:=SysErrorMessage(Result);
  end;
end;

function GetPhysicalDiskInfo;
var
  pVP: PGetVersionOutParams;
  cbBytesReturned: DWORD;
  pInData: PSendCmdInParams;
  pOutData : Pointer; // PSendCmdOutParams
  bIDCmd: Byte;
begin
  Result:=0;
  ZeroMemory(@DI,SizeOf(TDriveInfo));
  pVP:=AllocMem(SizeOf(TGetVersionOutParams));
  try
  if DeviceIoControl(DeviceHandle,DFP_GET_VERSION,
                   nil,
                   0,
                   pVP,
                   SizeOf(TGetVersionOutParams),
                   cbBytesReturned,nil) then begin
     if (pVP.bIDEDeviceMap>0) then begin
       {if (pVP.bIDEDeviceMap shr drive and $10)=$10 then
         bIDCmd:=IDE_ATAPI_IDENTIFY
       else}
         bIDCmd:=IDE_ATA_IDENTIFY;
       pInData:=AllocMem(SizeOf(TSendCmdInParams));
       pOutData:=AllocMem(sizeof(TSendCmdOutParams)+IDENTIFY_BUFFER_SIZE-1);
       try
       // Set up data structures for IDENTIFY command.
       pInData^.cBufferSize:=IDENTIFY_BUFFER_SIZE;
       pInData^.irDriveRegs.bFeaturesReg:=0;
       pInData^.irDriveRegs.bSectorCountReg:=1;
       pInData^.irDriveRegs.bSectorNumberReg:=1;
       pInData^.irDriveRegs.bCylLowReg:=0;
       pInData^.irDriveRegs.bCylHighReg:=0;
       // Compute the drive number.
       pInData^.irDriveRegs.bDriveHeadReg:=$A0 { or ((Drive and 1) shl 4)};
       // The command can either be IDE identify or ATAPI identify.
       pInData^.irDriveRegs.bCommandReg:=bIDCmd;
       {pInData^.bDriveNumber:=Drive;
       pInData^.cBufferSize:=IDENTIFY_BUFFER_SIZE;}

       if DeviceIoControl(DeviceHandle,DFP_RECEIVE_DRIVE_DATA,
                          pInData,SizeOf(TSendCmdInParams)-1,pOutData,
                          W9xBufferSize,cbBytesReturned,nil) then
         with PIdSector(PChar(pOutData)+16)^ do begin
           ChangeByteOrder(sSerialNumber,SizeOf(sSerialNumber));
           DI.SerialNumber:=Trim(sSerialNumber);
           ChangeByteOrder(sFirmwareRev,SizeOf(sFirmwareRev));
           DI.Revision:=Trim(sFirmwareRev);
           ChangeByteOrder(sModelNumber,SizeOf(sModelNumber));
           DI.Model:=Trim(sModelNumber);
           try
             DG.Cylinders.QuadPart:=Round((ulTotalAddressableSectors/wSectorsPerTrack)/wNumHeads);
           except
             DG.Cylinders.QuadPart:=0;
           end;
           DG.TracksPerCylinder:=wNumHeads;
           DG.SectorsPerTrack:=wSectorsPerTrack;
           DG.BytesPerSector:=wUnformattedBytesPerSector;
           if DG.BytesPerSector=0 then
             DG.BytesPerSector:=bBytesPerSector;
           DI.Capacity:=Int64(ulTotalAddressableSectors)*DG.BytesPerSector;
         end
       else
         Result:=GetLastError;
       finally
         FreeMem(pInData);
         FreeMem(pOutData);
       end;
     end;
  end else
    Result:=GetLastError;
  finally
    FreeMem(pVP);
  end;
end;

function GetSMARTDiskInfo;
var
  hDevice: THandle;
  cbBytesReturned: DWORD;
  pInData: PSendCmdInParams;
  pOutData: Pointer; // PSendCmdOutParams
  Buffer: Array[0..BufferSize-1] of Byte;
  srbControl: TSrbIoControl absolute Buffer;
begin
  Result:=0;
  ZeroMemory(@DI,SizeOf(TDriveInfo));
  FillChar(Buffer,BufferSize,#0);
  hDevice := CreateFile('\\.\SMARTVSD', 0, 0, nil,
                        CREATE_NEW, 0, 0 );
  if hDevice<>INVALID_HANDLE_VALUE then
    try
      pInData := PSendCmdInParams(@Buffer);
      pOutData := @pInData^.bBuffer;
      with pInData^ do begin
        cBufferSize  := IDENTIFY_BUFFER_SIZE;
        bDriveNumber := Drive;
        with irDriveRegs do begin
          bFeaturesReg     := 0;
          bSectorCountReg  := 1;
          bSectorNumberReg := 1;
          bCylLowReg       := 0;
          bCylHighReg      := 0;
          bDriveHeadReg    := $A0;
          If Win32Platform<>VER_PLATFORM_WIN32_NT then
            bDriveHeadReg:=bDriveHeadReg Or (Drive And 1) * 16;
          bCommandReg      := IDE_ATA_IDENTIFY;
        end;
      end;
      DG.MediaType:=RemovableMedia;
      if DeviceIoControl(hDevice, DFP_RECEIVE_DRIVE_DATA,
                         pInData, SizeOf(TSendCmdInParams)-1, pOutData,
                         W9xBufferSize, cbBytesReturned, nil ) then
        with PIdSector(PChar(pOutData)+16)^ do begin
          ChangeByteOrder(sSerialNumber,SizeOf(sSerialNumber));
          DI.SerialNumber:=Trim(sSerialNumber);
          ChangeByteOrder(sFirmwareRev,SizeOf(sFirmwareRev));
          DI.Revision:=Trim(sFirmwareRev);
          ChangeByteOrder(sModelNumber,SizeOf(sModelNumber));
          DI.Model:=Trim(sModelNumber);
          try
            DG.Cylinders.QuadPart:=Round((ulTotalAddressableSectors/wSectorsPerTrack)/wNumHeads);
          except
            DG.Cylinders.QuadPart:=0;
          end;
          DG.TracksPerCylinder:=wNumHeads;
          DG.SectorsPerTrack:=wSectorsPerTrack;
          DG.BytesPerSector:=wUnformattedBytesPerSector;
          if DG.BytesPerSector=0 then
            DG.BytesPerSector:=bBytesPerSector;
          DI.Capacity:=Int64(ulTotalAddressableSectors)*DG.BytesPerSector;
          if DG.TracksPerCylinder>0 then
            DG.MediaType:=FixedMedia
          else
            DG.MediaType:=RemovableMedia
        end
      else
        Result:=GetLastError;
     finally
       CloseHandle(hDevice);
     end
   else
     Result:=GetLastError;
end;

function GetDiskGeometry;
var
  cbBytesReturned: DWORD;
begin
  Result:=0;
  ZeroMemory(@DG,SizeOf(TDiskGeometry));
  if not DeviceIoControl(DeviceHandle,IOCTL_DISK_GET_DRIVE_GEOMETRY,nil,0,@DG,sizeof(TDISKGEOMETRY),cbBytesReturned,nil) then
    Result:=GetLastError;
end;


function GetDiskLayout(DeviceHandle: THandle; out DL: TDiskLayout): Integer;
var
  Layout: PDriveLayoutInformation;
  Partitions: PPartitionInformation;
  BytesReturned, BufferSize: DWORD;
  i: Integer;
begin
  Result:=0;
  Finalize(DL);
  BufferSize:=SizeOf(TDriveLayoutInformation)*10;
  Layout:=AllocMem(BufferSize);
  try
    if DeviceIoControl(DeviceHandle,
                       IOCTL_DISK_GET_DRIVE_LAYOUT,
                       nil,
                       0,
                       Layout,
                       BufferSize,
                       BytesReturned,
                       nil) then begin
        Partitions:=@Layout^.PartitionEntry[0];
        for i:=0 to (Layout^.PartitionCount)-1 do begin
          if Partitions^.PartitionType<>PARTITION_ENTRY_UNUSED then begin
            SetLength(DL,Length(DL)+1);
            DL[High(DL)]:=Partitions^;
          end;
          Partitions:=PPartitionInformation(PChar(Partitions)+SizeOf(TPartitionInformation));
        end;
      end else
        Result:=GetLastError;
  finally
    FreeMem(Layout);
  end;
end;

function GetDiskController;
var
  hDevice: THandle;
  BytesReturned: DWORD;
  Buffer: PDiskControllerNumber;
begin
  Zeromemory(@DC,SizeOf(TDiskControllerNumber));
  Result:=0;
  hDevice:=CreateFile(PChar(Format('\\.\PhysicalDrive%d',[Drive])),
                    GENERIC_READ or GENERIC_WRITE,
                    FILE_SHARE_READ or FILE_SHARE_WRITE,
                    nil,
                    OPEN_EXISTING,
                    0,
                    0);
  if (hDevice<>INVALID_HANDLE_VALUE) then begin
     Buffer:=AllocMem(SizeOf(TDiskControllerNumber));
     try
       if DeviceIoControl(hDevice,
                IOCTL_DISK_CONTROLLER_NUMBER,
                nil,
                0,
                Buffer,
                SizeOf(TDiskControllerNumber),
                BytesReturned,
                nil) then
          DC:=Buffer^
       else
         Result:=GetLastError;
    finally
       CloseHandle(hDevice);
       FreeMem(Buffer);
     end
  end else
     Result:=GetLastError;
end;

function ReadPhysicalSector;
var
  bytestoread, numread: dword;
  dwpointer: dword;
  hdevice: thandle;
  ldistancelow, ldistancehigh: dword;
begin
  Result:=0;
  hDevice:=CreateFile(PChar(Format('\\.\PhysicalDrive%d',[Drive])),
                      GENERIC_READ,
                      {FILE_SHARE_READ OR} FILE_SHARE_WRITE,
                      nil,
                      OPEN_EXISTING,
                      FILE_FLAG_WRITE_THROUGH,
                      0);
  if hDevice<>INVALID_HANDLE_VALUE then begin
    ldistanceLow:=dword(StartSector shl 9);
    ldistanceHigh:=dword(StartSector shr (32-9));
    dwpointer:=SetFilePointer(hdevice,ldistancelow,@ldistancehigh,FILE_BEGIN);
    if dwPointer<>$FFFFFFFF then begin
      bytestoread:=SectorsToRead*bBytesPerSector;
      if not ReadFile(hDevice,Dump^,bytestoread,numread,nil) then
        Result:=GetLastError;
    end;
    CloseHandle(hDevice);
  end else
    Result:=GetLastError;
end;

end.

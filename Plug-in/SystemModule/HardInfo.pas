{***********************************************
*                                              *
*                                              *
*      这个模块是用来获取CPU、硬盘序列号，CPU的*
*                                              *
*   速率、显示器的刷新率网卡的MAC地址等信息    *
*************************************************}

unit HardInfo;

interface

uses
  Windows, SysUtils, Nb30, MSI_CPU, MSI_Storage;

const
  ID_BIT = $200000; // EFLAGS ID bit

type
  TCPUID = array[1..4] of Longint;
  TVendor = array[0..11] of char;

function IsCPUID_Available: Boolean; register; //判断CPU序列号是否可用函数
function GetCPUID: TCPUID; assembler; register; //获取CPU序列号函数
function GetCPUVendor: TVendor; assembler; register; //获取CPU生产厂家函数
function GetCPUInfo: string; //CPU序列号(格式化成字符串)
function GetCPUSpeed: Double; //获取CPU速度函数
function GetDisplayFrequency: Integer; //获取显示器刷新率
function GetScsisn: string; //获取IDE硬盘序列号函数
function MonthMaxDay(year, month: Integer): Integer; //获取某年某月的最大天数
function GetAdapterMac(ANo: Integer): string;
function GetCPUInfo_: string;
function GetDiskSerialNumber: string;
implementation
function GetDiskSerialNumber: string;
var
  Storage: TStorage;
begin
  Result := '';
  Storage := TStorage.Create;
  Storage.GetInfo;
  if Storage.DeviceCount > 0 then begin
    Result := Storage.Devices[0].SerialNumber;
  end;
  Storage.Free;
end;

function GetCPUInfo_: string;
var
  CPU: TCPU;
begin
  CPU := TCPU.Create;
  CPU.GetInfo();
  Result := CPU.SerialNumber;
  CPU.Free;
end;

function IsCPUID_Available: Boolean; register;
asm
    PUSHFD {direct access to flags no possible, only via stack}
    POP EAX {flags to EAX}
    MOV EDX,EAX {save current flags}
    XOR EAX,ID_BIT {not ID bit}
    PUSH EAX {onto stack}
    POPFD {from stack to flags, with not ID bit}
    PUSHFD {back to stack}
    POP EAX {get back to EAX}
    XOR EAX,EDX {check if ID bit affected}
    JZ @exit {no, CPUID not availavle}
    MOV AL,True {Result=True}
    @exit:
end;



function GetCPUID: TCPUID; assembler; register;
asm
    PUSH    EBX         {Save affected register}
    PUSH    EDI
    MOV     EDI,EAX     {@Resukt}
    MOV     EAX,1
    DW      $A20F       {CPUID Command}
    STOSD                {CPUID[1]}
    MOV     EAX,EBX
    STOSD               {CPUID[2]}
    MOV     EAX,ECX
    STOSD               {CPUID[3]}
    MOV     EAX,EDX
    STOSD               {CPUID[4]}
    POP     EDI         {Restore registers}
    POP     EBX
end;

function GetCPUVendor: TVendor; assembler; register;
//获取CPU生产厂家函数
//调用方法:EDIT.TEXT:='Current CPU Vendor:'+GetCPUVendor;
asm
      PUSH EBX {Save affected register}
      PUSH EDI
      MOV EDI,EAX {@Result (TVendor)}
      MOV EAX,0
      DW $A20F {CPUID Command}
      MOV EAX,EBX
      XCHG EBX,ECX {save ECX result}
      MOV ECX,4
      @1:
      STOSB
      SHR EAX,8
      LOOP @1
      MOV EAX,EDX
      MOV ECX,4
      @2:
      STOSB
      SHR EAX,8
      LOOP @2
      MOV EAX,EBX
      MOV ECX,4
      @3:
      STOSB
      SHR EAX,8
      LOOP @3
      POP EDI {Restore registers}
      POP EBX
end;

function GetCPUInfo: string;
var
  CPUID: TCPUID;
  I: Integer;
  S: TVendor;
begin
  for I := Low(CPUID) to High(CPUID) do CPUID[I] := -1;
  if IsCPUID_Available then begin
    CPUID := GetCPUID;
    S := GetCPUVendor;
    Result := IntToHex(CPUID[1], 8)
      + '-' + IntToHex(CPUID[2], 8)
      + '-' + IntToHex(CPUID[3], 8)
      + '-' + IntToHex(CPUID[4], 8);
  end
  else Result := 'CPUID not available';
end;


function GetCPUSpeed: Double;
//获取CPU速率函数
//调用方法:EDIT.TEXT:='Current CPU Speed:'+floattostr(GetCPUSpeed)+'MHz';
const
  DelayTime = 500; // 时间单位是毫秒
var
  TimerHi, TimerLo: DWORD;
  PriorityClass, Priority: Integer;
begin
  PriorityClass := GetPriorityClass(GetCurrentProcess);
  Priority := GetThreadPriority(GetCurrentThread);
  SetPriorityClass(GetCurrentProcess, REALTIME_PRIORITY_CLASS);
  SetThreadPriority(GetCurrentThread, THREAD_PRIORITY_TIME_CRITICAL);
  Sleep(10);
  asm
        dw 310Fh // rdtsc
        mov TimerLo, eax
        mov TimerHi, edx
  end;
  Sleep(DelayTime);
  asm
        dw 310Fh // rdtsc
        sub eax, TimerLo
        sbb edx, TimerHi
        mov TimerLo, eax
        mov TimerHi, edx
  end;

  SetThreadPriority(GetCurrentThread, Priority);
  SetPriorityClass(GetCurrentProcess, PriorityClass);
  Result := TimerLo / (1000.0 * DelayTime);
end;

function GetDisplayFrequency: Integer;
// 这个函数返回的显示刷新率是以Hz为单位的
//调用方法:EDIT.TEXT:='Current DisplayFrequency:'+inttostr(GetDisplayFrequency)+' Hz';
var
  DeviceMode: TDeviceMode;
begin
  EnumDisplaySettings(nil, Cardinal(-1), DeviceMode);
  Result := DeviceMode.dmDisplayFrequency;
end;


//硬盘序列号的，可以IDE / SCSI的。
//用getscsisn既可得到硬盘序列号

function GetIdeDiskSerialNumber: pchar;
//获取第一个IDE硬盘的序列号
//调用方法：EDIT.TEXT:='HardDriver SerialNumber:'+strpas(GetIdeSerialNumber);
const IDENTIFY_BUFFER_SIZE = 512;
type
  TIDERegs = packed record
    bFeaturesReg: BYTE; // Used for specifying SMART "commands".
    bSectorCountReg: BYTE; // IDE sector count register
    bSectorNumberReg: BYTE; // IDE sector number register
    bCylLowReg: BYTE; // IDE low order cylinder value
    bCylHighReg: BYTE; // IDE high order cylinder value
    bDriveHeadReg: BYTE; // IDE drive/head register
    bCommandReg: BYTE; // Actual IDE command.
    bReserved: BYTE; // reserved for future use.  Must be zero.
  end;
  TSendCmdInParams = packed record
    // Buffer size in bytes
    cBufferSize: DWORD;
    // Structure with drive register values.
    irDriveRegs: TIDERegs;
    // Physical drive number to send command to (0,1,2,3).
    bDriveNumber: BYTE;
    bReserved: array[0..2] of BYTE;
    dwReserved: array[0..3] of DWORD;
    bBuffer: array[0..0] of BYTE; // Input buffer.
  end;
  TIdSector = packed record
    wGenConfig: Word;
    wNumCyls: Word;
    wReserved: Word;
    wNumHeads: Word;
    wBytesPerTrack: Word;
    wBytesPerSector: Word;
    wSectorsPerTrack: Word;
    wVendorUnique: array[0..2] of Word;
    sSerialNumber: array[0..19] of char;
    wBufferType: Word;
    wBufferSize: Word;
    wECCSize: Word;
    sFirmwareRev: array[0..7] of char;
    sModelNumber: array[0..39] of char;
    wMoreVendorUnique: Word;
    wDoubleWordIO: Word;
    wCapabilities: Word;
    wReserved1: Word;
    wPIOTiming: Word;
    wDMATiming: Word;
    wBS: Word;
    wNumCurrentCyls: Word;
    wNumCurrentHeads: Word;
    wNumCurrentSectorsPerTrack: Word;
    ulCurrentSectorCapacity: DWORD;
    wMultSectorStuff: Word;
    ulTotalAddressableSectors: DWORD;
    wSingleWordDMA: Word;
    wMultiWordDMA: Word;
    bReserved: array[0..127] of BYTE;
  end;
  PIdSector = ^TIdSector;
  TDriverStatus = packed record
    // 驱动器返回的错误代码，无错则返回0
    bDriverError: BYTE;
    // IDE出错寄存器的内容，只有当bDriverError 为 SMART_IDE_ERROR 时有效
    bIDEStatus: BYTE;
    bReserved: array[0..1] of BYTE;
    dwReserved: array[0..1] of DWORD;
  end;
  TSendCmdOutParams = packed record
    // bBuffer的大小
    cBufferSize: DWORD;
    // 驱动器状态
    DriverStatus: TDriverStatus;
    // 用于保存从驱动器读出的数据的缓冲区，实际长度由cBufferSize决定
    bBuffer: array[0..0] of BYTE;
  end;
var hDevice: THandle;
  cbBytesReturned: DWORD;
  SCIP: TSendCmdInParams;
  aIdOutCmd: array[0..(SizeOf(TSendCmdOutParams) + IDENTIFY_BUFFER_SIZE - 1) - 1] of BYTE;
  IdOutCmd: TSendCmdOutParams absolute aIdOutCmd;
  procedure ChangeByteOrder(var Data; Size: Integer);
  var ptr: pchar;
    I: Integer;
    c: char;
  begin
    ptr := @Data;
    for I := 0 to (Size shr 1) - 1 do begin
      c := ptr^;
      ptr^ := (ptr + 1)^;
      (ptr + 1)^ := c;
      Inc(ptr, 2);
    end;
  end;
begin
  Result := ''; // 如果出错则返回空串
  if SysUtils.Win32Platform = VER_PLATFORM_WIN32_NT then begin // Windows NT, Windows 2000
    // 提示! 改变名称可适用于其它驱动器，如第二个驱动器： '\\.\PhysicalDrive1\'
    hDevice := CreateFile('\\.\PhysicalDrive0', GENERIC_READ or GENERIC_WRITE,
      FILE_SHARE_READ or FILE_SHARE_WRITE, nil, OPEN_EXISTING, 0, 0);
  end else // Version Windows 95 OSR2, Windows 98
    hDevice := CreateFile('\\.\SMARTVSD', 0, 0, nil, CREATE_NEW, 0, 0);
  if hDevice = INVALID_HANDLE_VALUE then Exit;
  try
    FillChar(SCIP, SizeOf(TSendCmdInParams) - 1, #0);
    FillChar(aIdOutCmd, SizeOf(aIdOutCmd), #0);
    cbBytesReturned := 0;
    // Set up data structures for IDENTIFY command.
    with SCIP do begin
      cBufferSize := IDENTIFY_BUFFER_SIZE;
      //      bDriveNumber := 0;
      with irDriveRegs do begin
        bSectorCountReg := 1;
        bSectorNumberReg := 1;
        //      if Win32Platform=VER_PLATFORM_WIN32_NT then bDriveHeadReg := $A0
        //      else bDriveHeadReg := $A0 or ((bDriveNum and 1) shl 4);
        bDriveHeadReg := $A0;
        bCommandReg := $EC;
      end;
    end;
    if not DeviceIoControl(hDevice, $0007C088, @SCIP, SizeOf(TSendCmdInParams) - 1,
      @aIdOutCmd, SizeOf(aIdOutCmd), cbBytesReturned, nil) then Exit;
  finally
    CloseHandle(hDevice);
  end;
  with PIdSector(@IdOutCmd.bBuffer)^ do begin
    ChangeByteOrder(sSerialNumber, SizeOf(sSerialNumber));
    (pchar(@sSerialNumber) + SizeOf(sSerialNumber))^ := #0;
    Result := pchar(@sSerialNumber);
  end;
  // 更多关于 S.M.A.R.T. ioctl 的信息可查看:
  // http://www.microsoft.com/hwdev/download/respec/iocltapi.rtf
  // MSDN库中也有一些简单的例子
  // Windows Development -> Win32 Device Driver Kit ->
  // SAMPLE: SmartApp.exe Accesses SMART stats in IDE drives
  // 还可以查看 http://www.mtgroup.ru/~alexk
  // IdeInfo.zip - 一个简单的使用了S.M.A.R.T. Ioctl API的Delphi应用程序
  // 注意:
  // WinNT/Win2000 - 你必须拥有对硬盘的读/写访问权限
  // Win98
  // SMARTVSD.VXD 必须安装到 \windows\system\iosubsys
  // (不要忘记在复制后重新启动系统)
end;

function ScsiHddSerialNumber(DeviceHandle: THandle): string;
{$ALIGN ON}
type
  TScsiPassThrough = record
    Length: Word;
    ScsiStatus: BYTE;
    PathId: BYTE;
    TargetId: BYTE;
    Lun: BYTE;
    CdbLength: BYTE;
    SenseInfoLength: BYTE;
    DataIn: BYTE;
    DataTransferLength: ULONG;
    TimeOutValue: ULONG;
    DataBufferOffset: DWORD;
    SenseInfoOffset: ULONG;
    Cdb: array[0..15] of BYTE;
  end;
  TScsiPassThroughWithBuffers = record
    spt: TScsiPassThrough;
    bSenseBuf: array[0..31] of BYTE;
    bDataBuf: array[0..191] of BYTE;
  end;
  {ALIGN OFF}
var dwReturned: DWORD;
  len: DWORD;
  Buffer: array[0..255] of BYTE;
  sptwb: TScsiPassThroughWithBuffers absolute Buffer;
begin
  Result := '';
  FillChar(Buffer, SizeOf(Buffer), #0);
  with sptwb.spt do begin
    Length := SizeOf(TScsiPassThrough);
    CdbLength := 6; // CDB6GENERIC_LENGTH
    SenseInfoLength := 24;
    DataIn := 1; // SCSI_IOCTL_DATA_IN
    DataTransferLength := 192;
    TimeOutValue := 2;
    DataBufferOffset := pchar(@sptwb.bDataBuf) - pchar(@sptwb);
    SenseInfoOffset := pchar(@sptwb.bSenseBuf) - pchar(@sptwb);
    Cdb[0] := $12; // OperationCode := SCSIOP_INQUIRY;
    Cdb[1] := $01; // Flags := CDB_INQUIRY_EVPD;  Vital product data
    Cdb[2] := $80; // PageCode            Unit serial number
    Cdb[4] := 192; // AllocationLength
  end;
  len := sptwb.spt.DataBufferOffset + sptwb.spt.DataTransferLength;
  if DeviceIoControl(DeviceHandle, $0004D004, @sptwb, SizeOf
    (TScsiPassThrough), @sptwb, len, dwReturned, nil)
    and ((pchar(@sptwb.bDataBuf) + 1)^ = #$80)
    then
    SetString(Result, pchar(@sptwb.bDataBuf) + 4,
      Ord((pchar(@sptwb.bDataBuf) + 3)^));
end;

function GetDeviceHandle(sDeviceName: string): THandle;
begin
  Result := CreateFile(pchar('\\.\' + sDeviceName),
    GENERIC_READ or GENERIC_WRITE,
    FILE_SHARE_READ or FILE_SHARE_WRITE,
    nil, OPEN_EXISTING, 0, 0)
end;

//(3)取 第一分区(C:\) 序列号
function GetVolumeSerialNumber: string;
var
  I, j: Integer;
  SerialNum: DWORD;
  a, b: DWORD;
  Buffer1: array[0..255] of char; //缓冲区
begin
  // 取第一分区盘符
  GetSystemDirectory(Buffer1, SizeOf(Buffer1));
  for I := 0 to 255 do
    if Buffer1[I] = ':' then begin
      break;
    end;
  for j := I + 2 to 255 do
    Buffer1[j] := #0;

  //取 第一分区(C:\) 序列号
  if GetVolumeInformation(Buffer1, nil, 0, @SerialNum, b, a, nil, 0) then
    Result := IntToStr(SerialNum)
  else Result := '';
end;

function GetScsisn: string;
var
  sSerNum, sDeviceName: string;
  rc: DWORD;
  hDevice: THandle;
begin
  sDeviceName := 'C:';
  hDevice := GetDeviceHandle(sDeviceName);
  if hDevice <> INVALID_HANDLE_VALUE then try
    sSerNum := Trim(GetIdeDiskSerialNumber);
    if sSerNum = '' then
      sSerNum := Trim(ScsiHddSerialNumber(hDevice));
    Result := sSerNum;
  finally
    CloseHandle(hDevice);
  end;
end;

function MonthMaxDay(year, month: Integer): Integer; //获取某年某月最大天数
begin
  case month of
    1, 3, 5, 7, 8, 10, 12: Result := 31; //如是1、3、5、7、8、10、12则最大为31天
    2: if (year mod 4 = 0) and (year mod 100 <> 0) or (year mod 400 = 0) then Result := 29
      else Result := 28; //如是闰年2月则29天，否则2月最大为28天
    else Result := 30; //其它的4、6、9、11则最大天数为30天
  end;
end;


function GetAdapterMac(ANo: Integer): string;
//获取网卡的MAC地址
var
  Ncb: TNcb;
  Adapter: TAdapterStatus;
  Lanaenum: TLanaenum;
  IntIdx: Integer; //
  cRc: char;
  StrTemp: string;
begin
  Result := '';
  try
    ZeroMemory(@Ncb, SizeOf(Ncb));
    Ncb.ncb_command := Chr(NCbenum);
    NetBios(@Ncb);
    Ncb.ncb_buffer := @Lanaenum; //再处理enum命令
    Ncb.ncb_length := SizeOf(Lanaenum);
    cRc := NetBios(@Ncb);
    if Ord(cRc) <> 0 then Exit;
    ZeroMemory(@Ncb, SizeOf(Ncb)); //适配器清零
    Ncb.ncb_command := Chr(NcbReset);
    Ncb.ncb_lana_num := Lanaenum.lana[ANo];
    cRc := NetBios(@Ncb);
    if Ord(cRc) <> 0 then Exit;
    //得到适配器状态
    ZeroMemory(@Ncb, SizeOf(Ncb));
    Ncb.ncb_command := Chr(NcbAstat);
    Ncb.ncb_lana_num := Lanaenum.lana[ANo];
    StrPcopy(Ncb.ncb_callname, '*');
    Ncb.ncb_buffer := @Adapter;
    Ncb.ncb_length := SizeOf(Adapter);
    NetBios(@Ncb);
    //将mac地址转换成字符串输出
    StrTemp := '';
    for IntIdx := 0 to 5 do
      StrTemp := StrTemp + IntToHex(Integer(Adapter.adapter_address[IntIdx]), 2);
    Result := StrTemp;
  finally
  end;
end;

end.


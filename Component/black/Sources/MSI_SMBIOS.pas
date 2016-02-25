{*******************************************************}
{                                                       }
{       MiTeC System Information Component              }
{             SMBIOS Detection Part                     }
{           version 8.6.4 for Delphi 5,6,7              }
{                                                       }
{       Copyright © 1997,2003 Michal Mutl               }
{                                                       }
{*******************************************************}

{$INCLUDE MITEC_DEF.INC}

unit MSI_SMBIOS;

interface

uses MSI_Common, Windows, Classes, SysUtils, MSI_DMA;

const
  addr_BIOSBegin = $000F0000;
  addr_BIOSEnd = $000FFFFF;

const
  SMB_BIOSINFO = 0	;  // BIOS Information
  SMB_SYSINFO  = 1	;  // System Information
  SMB_BASEINFO = 2	;  // Base Board Information
  SMB_SYSENC   = 3	;  // System Enclosure or Chassis
  SMB_CPU      = 4	;  // Processor Information
  SMB_MEMCTRL  = 5	;  // Memory Controller Information
  SMB_MEMMOD   = 6	;  // Memory Module Information
  SMB_CACHE    = 7	;  // Cache Information
  SMB_PORTCON  = 8	;  // Port Connector Information
  SMB_SLOTS    = 9	;  // System Slots
  SMB_ONBOARD  = 10	;  // On Board Devices Information
  SMB_OEMSTR   = 11	;  // OEM Strings
  SMB_SYSCFG   = 12	;  // System Configuration Options
  SMB_LANG     = 13	;  // BIOS Language Information
  SMB_GRP      = 14	;  // Group Associations
  SMB_EVENT    = 15	;  // System Event Log
  SMB_PHYSMEM  = 16	;  // Physical Memory Array
  SMB_MEMDEV   = 17	;  // Memory Device
  SMB_MEMERR32 = 18	;  // 32-bit Memory Error Information
  SMB_MEMMAP   = 19	;  // Memory Array Mapped Address
  SMB_MEMDEVMAP= 20	;  // Memory Device Mapped Address
  SMB_POINTER  = 21	;  // Built-in Pointing Device
  SMB_BATTERY  = 22	;  // Portable Battery
  SMB_RESET    = 23	;  // System Reset
  SMB_SECURITY = 24	;  // Hardware Security
  SMB_POWER    = 25	;  // System Power Controls
  SMB_VOLTAGE  = 26	;  // Voltage Probe
  SMB_COOL     = 27	;  // Cooling Device
  SMB_TEMP     = 28	;  // Tempature Probe
  SMB_CURRENT  = 29	;  // Electrical Current Probe
  SMB_OOBREM   = 30	;  // Out-of-Band Remote Access
  SMB_BIS      = 31	;  // Boot Integrity Services (BIS) Entry Point
  SMB_SYSBOOT  = 32	;  // System Boot Information
  SMB_MEMERR64 = 33	;  // 64-bit Memory Error Information
  SMB_MGT      = 34	;  // Management Device
  SMB_MGTCMP   = 35	;  // Management Device Component
  SMB_MGTTHR   = 36	;  // Management Device Threshold Data
  SMB_MEMCHAN  = 37	;  // Memory Channel
  SMB_IPMI     = 38	;  // IPMI Device Information
  SMB_SPS      = 39	;  // System Power Supply
  SMB_INACTIVE = 126	;  // Inactive
  SMB_EOT      = 127	;  // End-of-Table

  SMB_TableTypes: array[0..41] of record Typ: Byte; Name: string end = (
    (Typ: SMB_BIOSINFO; Name: 'BIOS Information'),
    (Typ: SMB_SYSINFO; Name: 'System Information'),
    (Typ: SMB_BASEINFO; Name: 'Base Board Information'),
    (Typ: SMB_SYSENC; Name: 'System Enclosure or Chassis'),
    (Typ: SMB_CPU; Name: 'Processor Information'),
    (Typ: SMB_MEMCTRL; Name: 'Memory Controller Information'),
    (Typ: SMB_MEMMOD; Name: 'Memory Module Information'),
    (Typ: SMB_CACHE; Name: 'Cache Information'),
    (Typ: SMB_PORTCON; Name: 'Port Connector Information'),
    (Typ: SMB_SLOTS; Name: 'System Slots'),
    (Typ: SMB_ONBOARD; Name: 'On Board Devices Information'),
    (Typ: SMB_OEMSTR; Name: 'OEM Strings'),
    (Typ: SMB_SYSCFG; Name: 'System Configuration Options'),
    (Typ: SMB_LANG; Name: 'BIOS Language Information'),
    (Typ: SMB_GRP; Name: 'Group Associations'),
    (Typ: SMB_EVENT; Name: 'System Event Log'),
    (Typ: SMB_PHYSMEM; Name: 'Physical Memory Array'),
    (Typ: SMB_MEMDEV; Name: 'Memory Device'),
    (Typ: SMB_MEMERR32; Name: '32-bit Memory Error Information'),
    (Typ: SMB_MEMMAP; Name: 'Memory Array Mapped Address'),
    (Typ: SMB_MEMDEVMAP; Name: 'Memory Device Mapped Address'),
    (Typ: SMB_POINTER; Name: 'Built-in Pointing Device'),
    (Typ: SMB_BATTERY; Name: 'Portable Battery'),
    (Typ: SMB_RESET; Name: 'System Reset'),
    (Typ: SMB_SECURITY; Name: ' Hardware Security'),
    (Typ: SMB_POWER; Name: 'System Power Controls'),
    (Typ: SMB_VOLTAGE; Name: 'Voltage Probe'),
    (Typ: SMB_COOL; Name: ' Cooling Device'),
    (Typ: SMB_TEMP; Name: 'Temperature Probe'),
    (Typ: SMB_CURRENT; Name: 'Electrical Current Probe'),
    (Typ: SMB_OOBREM; Name: 'Out-of-Band Remote Access'),
    (Typ: SMB_BIS; Name: 'Boot Integrity Services (BIS) Entry Point'),
    (Typ: SMB_SYSBOOT; Name: 'System Boot Information'),
    (Typ: SMB_MEMERR64; Name: '64-bit Memory Error Information'),
    (Typ: SMB_MGT; Name: 'Management Device'),
    (Typ: SMB_MGTCMP; Name: 'Management Device Component'),
    (Typ: SMB_MGTTHR; Name: 'Management Device Threshold Data'),
    (Typ: SMB_MEMCHAN; Name: 'Memory Channel'),
    (Typ: SMB_IPMI; Name: 'IPMI Device Information'),
    (Typ: SMB_SPS; Name: 'System Power Supply'),
    (Typ: SMB_INACTIVE; Name: 'Inactive'),
    (Typ: SMB_EOT; Name: 'End-of-Table'));

type
  TStructTable = record
    Address: DWORD;
    Indicator: Byte;
    Length: Byte;
    Handle: Word;
    Name: shortstring;
  end;

  TStructTables = array of TStructTable;

  TChassis = (smchOther, smchUnknown, smchDesktop, smchLowProfileDesktop, smchPizzaBox,
              smchMiniTower, smchTower, smchPortable, smchLapTop, smchNotebook, smchHandHeld,
              smchDockingStation, smchAllInOne, smchSubNotebook, smchSpaceSaving, smchLunchBox,
              smchMainServer, smchExpansion, smchSubChassis, smchBusExpansion, smchPeripheral,
              smchRAID, smchRackMount, smchSealedCasePC, smchMultiSystem);

  TInterleaveSupport = (smisOther, smisUnknown, smisOnewWay, smisTwoWay, smisFourWay, smisEightWay, smisSixteenWay);

  TVoltage = (smv5V, smv33V, smv29V);

  TVoltages = set of TVoltage;

  TMemorySpeed = (smmsOther, smmsUnknown, smms70ns, smms60ns, smms50ns);

  TMemorySpeeds = set of TMemorySpeed;

  TMemoryType = (smmtOther, smmtUnknown, smmtStandard, smmtFastPageMode, smmtEDO,
                 smmtParity, smmtECC, smmtSIMM, smmtDIMM, smmtBurstEDO, smmtSDRAM);

  TMemoryTypes = set of TMemoryType;

  TMemoryFormFactor = (smffOther, smffUnknown, smffSIMM, smffSIP,
                       smffChip, smffDIP, smffZIP, smffPropCard, smffDIMM, smffTSOP,
                       smffRowChip, smffRIMM, smffSODIMM, smffSRIMM);

  TMemoryDeviceType = (smmdOther, smmdUnknown, smmdDRAM, smmdEDRAM, smmdVRAM, smmdSRAM,
                   smmdRAM,smmdROM, smmdFLASH, smmdEEPROM, smmdFEPROM, smmdEPROM,
                   smmdCDRAM, smmd3DRAM, smmdSDRAM, smmdSGRAM, smmdRDRAM, smmdDDR);

  TMemoryTypeDetail = (mtdReserved, mtdOther, mtdUnknown, mtdFastPaged, mtdStaticColumn,
                       mtdPseudoStatic, mtdRAMBUS, mtdSynchronous, mtdCMOS, mtdEDO,
                       mtdWindowDRAM, mtdCacheDRAM, mtdNonVolatile);

  TMemoryTypeDetails = set of TMemoryTypeDetail;

  TUpgrade = (smuOther, smuUnknown, smuDaughterBoard, smuZIFSocket, smuReplaceablePiggyBack,
              smuNone, smuLIFSocket, smuSlot1, smuSlot2, smu370pinSocket, smuSlotA,
              smuSlotM, smuSocket423, smuSocketA, smuSocket478, smuSocket754, smuSocket940);

  TProcessor = record
    Socket,
    Manufacturer,
    Version: shortstring;
    Upgrade: TUpgrade;
    Voltage: double;
    Frequency,
    ExternalClock: WORD;
    SerialNumber,
    AssetTag,
    PartNumber: shortstring;
  end;

  TMemoryModule = record
    Socket: shortstring;
    Speed: Word;
    Size: DWORD;
    Types: TMemoryTypes;
  end;

  TMemoryDevice = record
    TotalWidth,
    DataWidth,
    Size: Word;
    FormFactor: TMemoryFormFactor;
    DeviceLocator,
    BankLocator: ShortString;
    Device: TMemoryDeviceType;
    TypeDetails: TMemoryTypeDetails;
    Speed: Word;
    Manufacturer,
    SerialNumber,
    AssetTag,
    PartNumber: ShortString;
  end;

  TConnectorType = (smctNone, smctCentronics, smctMiniCentronics, smctProprietary,
                    smctDB25PinMale, smctDB25PinFemale, smctDB15PinMale, smctDB15PinFemale,
                    smctDB9PinMale, smctDB9PinFemale, smctRJ11, smctRJ45, smct50PinMiniSCSI,
                    smctMiniDIN, smctMicroDIN, smctPS2, smctInfrared, smctHPHIL,
                    smctAccessBus, smctSSASCSI, smctCircularDIN8Male, smctCircularDIN8Female,
                    smctOnBoardIDE, smctOnBoardFloppy, smct9PinDualInline, smct25PinDualInline,
                    smct50PinDualInline, smct68PinDualInline, smctOnBoardSoundInputFromCDROM,
                    smctMiniCentronicsType14, smctMiniCentronicsType26, smctMiniJack,
                    smctBNC, smct1394, smctPC98, smctPC98Hireso, smctPCH98, smctPC98Note,
                    smctPC98Full, smctOther);

  TPortType = (smptNone, smptParallelXTAT, smptParallelPS2, smptParallelECP,
               smptParallelEPP, smptParallelECPEPP, smptSerialXTAT,
               smptSerial16450, smptSerial16550, smptSerial16550A,
               smptSCSI, smptMIDI, smptJoyStick, smptKeyboard, smptMouse, smptSSASCSI,
               smptUSB, smptFireWire, smptPCMCIA2, smptPCMCIA2A, smptPCMCIA3, smptCardbus,
               smptAccessBus, smptSCSI2, smptSCSIWide, smptPC98, smptPC98Hireso, smptPCH98,
               smptVideo, smptAudio, smptModem, smptNetwork, smpt8251, smpt8251FIFO, smptOther);

  TPort = record
    InternalDesignator,
    ExternalDesignator: shortstring;
    InternalConnector,
    ExternalConnector: TConnectorType;
    Typ: TPortType;
  end;

  TSlotType = (smstOther, smstUnknown, smstISA, smstMCA, smstEISA, smstPCI, smstPCMCIA,
               smstVLVESA, smstProprietary, smstProcessorCard, smstProprietaryMemoryCard,
               smstIORiserCard, smstNuBus, smstPCI66MHz, smstAGP, smstAGP2X, smstAGP4X,
               smstPCIX, smstAGP8X,
               smstPC98C20, smstPC98C24, smstPC98E, smstPC98LocalBus, smstPC98Card);

  TDataBusType = (smdbOther, smdbUnknown, smdb8bit, smdb16bit, smdb32bit, smdb64bit, smdb128bit);

  TSlotUsage = (smsuOther, smsuUnknown, smsuAvailable, smsuInUse);

  TSlotLength = (smslOther, smslUnknown, smslShort, smslLong);

  TSlot = record
    Designation: shortstring;
    Typ: TSlotType;
    DataBus: TDataBusType;
    ID: WORD;
    Usage: TSlotUsage;
    Length: TSlotLength;
  end;

  TSRAMType = (sramOther, sramUnknown, sramNonBurst, sramBurst,
               sramPipelineBurst, sramSync, sramAsync);

  TCacheType = (ctOther, ctUnknown, ctInstruction, ctData, ctUnified);

  TCacheAssociativity = (caOther, caUnknown, caDirectMapped, ca2way, ca4way, caFull, ca8way, ca16way);

  TCache = record
    Designation: shortstring;
    MaxSize, InstalledSize: Word;
    SRAMType: TSRAMType;
    Typ: TCacheType;
    Associativity: TCacheAssociativity;
    Speed: Word;
  end;

  TOnBoardDeviceType = (obdOther, obdUnknown, obdAudio, obdSCSICrl, obdEthernet, obdTokenRing, obdSound);

  TOnBoardDevice = record
    DeviceName: string;
    Typ: TOnBoardDeviceType;
    Status: boolean;
  end;

  TLocationType = (ltOther, ltUnknown, ltProcessor, ltDisk, ltPeripheralBay, ltSMM, ltMB,
                   ltProcessorModule, ltPowerUnit, ltAddInCard, ltFrontPanelBoard, ltBackPanelBoard,
                   ltPowerSystemBoard, ltDriveBackPlane);

  TStatusType = (stOther, stUnknown, stOK, stNonCritical, stCritical, stNonRecoverable);

  TTemperatureProbe = record
    Description: shortstring;
    Location: TLocationType;
    Status: TStatusType;
    Min,Max: Word;
    Resolution,
    Tolerance,
    Accuracy: Word;
    Value: Word;
  end;

const
  ChassisTypes: array[TChassis] of string = ('Other','Unknown','Desktop','Low Profile Desktop','Pizza Box',
              'Mini Tower','Tower','Portable','LapTop','Notebook','Hand Held',
              'Docking Station','All in One','SubNotebook','Space-Saving','Lunch Box',
              'Main Server Chassis','Expansion Chassis','SubChassis','Bus Expansion Chassis','Peripheral Chassis',
              'RAID Chassis','Rack-Mount Chassis','Sealed-case PC','Multi-system Chassis');

  InterleaveSupports: array[TInterleaveSupport] of string = ('Other','Unknown','1-Way','2-Way','4-Way','8-Way','16-Way');

  Voltages: array[TVoltage] of string = ('5V','3.3V','2.9V');

  MemorySpeeds: array[TMemorySpeed] of string = ('Other','Unknown','70ns','60ns','50ns');

  Upgrades: array[TUpgrade] of string = ('Other','Unknown','Daughter Board','ZIF Socket','Replaceable Piggy Back',
              'None','LIF Socket','Slot 1','Slot 2','370-pin Socket','Slot A',
              'Slot M','Socket 423', 'Socket A (Socket 462)','Socket 478','Socket 754','Socket 940');

  MemoryFormFactors: array[TMemoryFormFactor] of string = ('Other','Unknown','SIMM','SIP',
    'Chip','DIP','ZIP','PropCard','DIMM','TSOP','RowChip','RIMM','SODIMM','SRIMM');

  MemoryDeviceTypes: array[TMemoryDeviceType] of string = ('Other','Unknown','DRAM','EDRAM',
    'VRAM','SRAM','RAM','ROM','FLASH','EEPROM','FEPROM','EPROM','CDRAM','3DRAM','SDRAM',
    'SGRAM','RDRAM','DDR');

  MemoryTypes: array[TMemoryType] of string = ('Other','Unknown','Standard','Fast Page Mode','EDO',
                 'Parity','ECC','SIMM','DIMM','Burst EDO','SDRAM');

  MemoryTypeDetails: array[TMemoryTypeDetail] of string = ('Reserved', 'Other', 'Unknown', 'FastPaged',
                               'StaticColumn', 'PseudoStatic', 'RAMBUS', 'Synchronous', 'CMOS', 'EDO',
                               'WindowDRAM', 'CacheDRAM', 'NonVolatile');

  ConnectorTypes: array[TConnectorType] of string = (
    'None','Centronics','Mini Centronics','Proprietary','DB-25 pin male','DB-25 pin female',
    'DB-15 pin male','DB-15 pin female','DB-9 pin male','DB-9 pin female','RJ-11','RJ-45',
    '50 Pin MiniSCSI','Mini-DIN','Micro-DIN','PS/2','Infrared','HP-HIL','Access Bus (USB)',
    'SSA SCSI','Circular DIN-8 male','Circular DIN-8 female','On Board IDE','On Board Floppy',
    '9 Pin Dual Inline (pin 10 cut)','25 Pin Dual Inline (pin 26 cut)','50 Pin Dual Inline',
    '68 Pin Dual Inline','On Board Sound Input from CD-ROM','Mini-Centronics Type-14',
    'Mini-Centronics Type-26','Mini-jack (headphones)','BNC','1394','PC-98','PC-98Hireso',
    'PC-H98','PC-98Note','PC-98Full','Other'
  );

  PortTypes: array[TPortType] of string = (
    'None','Parallel Port XT/AT Compatible','Parallel Port PS/2','Parallel Port ECP',
    'Parallel Port EPP','Parallel Port ECP/EPP','Serial Port XT/AT Compatible',
    'Serial Port 16450 Compatible','Serial Port 16550 Compatible','Serial Port 16550A Compatible',
    'SCSI Port','MIDI Port','Joy Stick Port','Keyboard Port','Mouse Port','SSA SCSI',
    'USB','FireWire (IEEE P1394)','PCMCIA Type II','PCMCIA Type II','PCMCIA Type III',
    'Cardbus','Access Bus Port','SCSI II','SCSI Wide','PC-98','PC-98-Hireso','PC-H98',
    'Video Port','Audio Port','Modem Port','Network Port','8251 Compatible',
    '8251 FIFO Compatible','Other'
  );

  SlotTypes: array[TSlotType] of string = (
    'Other','Unknown','ISA','MCA','EISA','PCI','PC Card (PCMCIA)','VL-VESA','Proprietary',
    'Processor Card Slot','Proprietary Memory Card','I/O Riser Card Slot','NuBus',
    'PCI - 66MHz Capable','AGP','AGP 2X','AGP 4X','PCI-X','AGP 8X', 'PC-98/C20','PC-98/C24','PC-98/E',
    'PC-98/Local Bus','PC-98/Card'
  );

  DataBusTypes: array[TDataBusType] of string = (
    'Other','Unknown','8 bit','16 bit','32 bit','64 bit','128 bit'
  );

  SlotUsages: array[TSlotUsage] of string = ('Other','Unknown','Available','InUse');

  SlotLengths: array[TSlotLength] of string = ('Other','Unknown','Short','Long');

  SRAMTypes: array[TSRAMType] of string = (
    'Other', 'Unknown','Non-Burst','Burst','Pipeline Burst','Synchronous','Asynchronous'
  );

  CacheTypes: array[TCacheType] of string = (
    'Other','Unknown','Instruction','Data','Unified'
  );

  CacheAssociativities: array[TCacheAssociativity] of string = (
    'Other','Unknown','Direct Mapped','2-way Set-Associative','4-way Set-Associative','Fully Associative',
    '8-way Set-Associative','16-way Set-Associative'
  );

  OnBoardDeviceTypes: array[TOnBoardDeviceType] of string = (
    'Other', 'Unknown', 'Audio', 'SCSICrl', 'Ethernet', 'TokenRing', 'Sound');

  LocationTypes: array[TLocationType] of string = ('Other', 'Unknown', 'Processor', 'Disk', 'Peripheral Bay',
    'System Management Module', 'Motherboard', 'Processor Module', 'Power Unit', 'Add-In Card', 'Front Panel Board',
    'Back Panel Board', 'Power System Board', 'Drive Back Plane');

  StatusTypes: array[TStatusType] of string = ('Other', 'Unknown', 'OK', 'Non-Critical', 'Critical', 'Non-Recoverable');

type
  TSMBIOS = class(TPersistent)
  private
    FSMBIOS, FStructure: TDMA;
    FStart,
    FStructStart: DWORD;
    FMBMod: string;
    FSysMan: string;
    FSysMod: string;
    FBIOSdate: string;
    FVersion: string;
    FBIOSVendor: string;
    FBIOSVersion: string;
    FBIOSSize: DWORD;
    FSysVer: string;
    FSysSN: string;
    FMBSN: string;
    FMBMan: string;
    FMBVer: string;
    FCHSN: string;
    FCHVer: string;
    FCHMan: string;
    FCHMod: TChassis;
    FSysUUID: string;
    FProc: array of TProcessor;
    FMemMod: array of TMemoryModule;
    FMemDev: array of TMemoryDevice;
    FPort: array of TPort;
    FSlot: array of TSlot;
    FCache: array of TCache;
    FOBD: array of TOnBoardDevice;
    FTP: array of TTemperatureProbe;
    FTableCount: WORD;
    FLen: WORD;
    FRevision: string;
    {$IFNDEF D6PLUS}
    FDummy: Byte;
    {$ENDIF}
    FMCSC: Byte;
    FMCCI: TInterleaveSupport;
    FMCSI: TInterleaveSupport;
    FMCSS: TMemorySpeeds;
    FMCST: TMemoryTypes;
    FMCSV: TVoltages;
    FMCMS: WORD;
    FCHAT: string;
    FMajorVersion: Byte;
    FMinorVersion: Byte;
    FMBAT: string;
    FMBLIC: string;
    FModes: TExceptionModes;
    procedure ScanTables;
    procedure AddTable(Addr: DWORD; Ind,Len: Byte; Hndl: Word; var ST: TStructTables);
    function GetMemoryModule(Index: Byte): TMemoryModule;
    function GetMemModCount: Byte;
    function GetPort(Index: Byte): TPort;
    function GetPortCount: Byte;
    function GetSlot(Index: Byte): TSlot;
    function GetSlotCount: Byte;
    function GetCache(Index: Byte): TCache;
    function GetCacheCount: Byte;
    function GetProc(Index: Byte): TProcessor;
    function GetProcCount: Byte;
    function GetOBDCount: Byte;
    function GetOBD(Index: Byte): TOnBoardDevice;
    function GetTempProbe(Index: Byte): TTemperatureProbe;
    function GetTempProbeCount: Byte;
    procedure SetMode(const Value: TExceptionModes);
    function GetMemoryDevice(Index: Byte): TMemoryDevice;
    function GetMemDevCount: Byte;
  public
    StructTables: TStructTables;

    constructor Create;
    destructor Destroy; override;

    procedure GetInfo(Local: DWORD = 1);
    procedure Report(var sl: TStringList; Standalone: Boolean = True); virtual;

    function GetMemoryTypeStr(Value: TMemoryTypes): string;
    function GetMemorySpeedStr(Value: TMemorySpeeds): string;
    function GetMemoryVoltageStr(Value: TVoltages): string;
    function GetMemoryTypeDetailsStr(Value: TMemoryTypeDetails): string;

    function FindTableRecord(AType: Byte; ST: TStructTables; From: DWORD = 0): TStructTable;
    function FindTableIndex(AType: Byte; ST: TStructTables; From: DWORD = 0): Integer;

    procedure LoadSMBIOSFromFile(Filename: string);

    property BIOS_DMA: TDMA read FSMBIOS;
    property SMBIOS_DMA: TDMA read FStructure;

    property MajorVersion :Byte read FMajorVersion;
    property MinorVersion :Byte read FMinorVersion;
    property Version: string read FVersion;
    property Revision: string read FRevision;
    property SMBIOSAddress: DWORD read FStart;
    property StructStart: DWORD read FStructStart;
    property StructLength: WORD read FLen;
    property StructCount: WORD read FTableCount;

    property Processor[Index: Byte]: TProcessor read GetProc;

    property MemoryModule[Index: Byte]: TMemoryModule read GetMemoryModule;

    property MemoryDevice[Index: Byte]: TMemoryDevice read GetMemoryDevice;

    property Port[Index: Byte]: TPort read GetPort;

    property SystemSlot[Index: Byte]: TSlot read GetSlot;

    property Cache[Index: Byte]: TCache read GetCache;

    property OnBoardDevice[Index: Byte]: TOnBoardDevice read GetOBD;

    property TemperatureProbe[Index: Byte]: TTemperatureProbe read GetTempProbe;
  published
    property ExceptionModes: TExceptionModes read FModes Write SetMode;
    property SystemModel: string read FSysMod {$IFNDEF D6PLUS} write FSysMod {$ENDIF} stored False;
    property SystemManufacturer: string read FSysMan {$IFNDEF D6PLUS} write FSysMan {$ENDIF} stored False;
    property SystemVersion: string read FSysVer {$IFNDEF D6PLUS} write FSysVer {$ENDIF} stored False;
    property SystemSerial: string read FSysSN {$IFNDEF D6PLUS} write FSysSN {$ENDIF} stored False;
    property SystemUUID: string read FSysUUID {$IFNDEF D6PLUS} write FSysUUID {$ENDIF} stored False;

    property BIOSVendor: string read FBIOSVendor {$IFNDEF D6PLUS} write FBIOSVendor {$ENDIF} stored False;
    property BIOSVersion: string read FBIOSVersion {$IFNDEF D6PLUS} write FBIOSVersion {$ENDIF} stored False;
    property BIOSDate: string read FBIOSdate {$IFNDEF D6PLUS} write FBIOSDate {$ENDIF} stored False;
    property BIOSSize: DWORD read FBIOSSize {$IFNDEF D6PLUS} write FBIOSSize {$ENDIF} stored False;

    property MainBoardModel: string read FMBMod {$IFNDEF D6PLUS} write FMBMod {$ENDIF} stored False;
    property MainBoardManufacturer: string read FMBMan {$IFNDEF D6PLUS} write FMBMan {$ENDIF} stored False;
    property MainBoardVersion: string read FMBVer {$IFNDEF D6PLUS} write FMBVer {$ENDIF} stored False;
    property MainBoardSerial: string read FMBSN {$IFNDEF D6PLUS} write FMBSN {$ENDIF} stored False;
    property MainBoardAssetTag: string read FMBAT {$IFNDEF D6PLUS} write FMBAT {$ENDIF} stored False;
    property MainBoardLocationInChassis: string read FMBLIC {$IFNDEF D6PLUS} write FMBLIC {$ENDIF} stored False;

    property ChassisModel: TChassis read FCHMod {$IFNDEF D6PLUS} write FCHMod {$ENDIF} stored False;
    property ChassisManufacturer: string read FCHMan {$IFNDEF D6PLUS} write FCHMan {$ENDIF} stored False;
    property ChassisVersion: string read FCHVer {$IFNDEF D6PLUS} write FCHVer {$ENDIF} stored False;
    property ChassisSerial: string read FCHSN {$IFNDEF D6PLUS} write FCHSN {$ENDIF} stored False;
    property ChassisAssetTag: string read FCHAT {$IFNDEF D6PLUS} write FCHAT {$ENDIF} stored False;

    property MemCtrlCurrentInterleave: TInterleaveSupport read FMCCI  {$IFNDEF D6PLUS} write FMCCI {$ENDIF} stored False;
    property MemCtrlSupportedInterleave: TInterleaveSupport read FMCSI  {$IFNDEF D6PLUS} write FMCSI {$ENDIF} stored False;
    property MemCtrlSupportedSpeeds: TMemorySpeeds read FMCSS  {$IFNDEF D6PLUS} write FMCSS {$ENDIF} stored False;
    property MemCtrlSupportedTypes: TMemoryTypes read FMCST  {$IFNDEF D6PLUS} write FMCST {$ENDIF} stored False;
    property MemCtrlSupportedVoltages: TVoltages read FMCSV  {$IFNDEF D6PLUS} write FMCSV {$ENDIF} stored False;
    property MemCtrlMaxSize: WORD read FMCMS  {$IFNDEF D6PLUS} write FMCMS {$ENDIF} stored False;
    property MemCtrlSlotCount: Byte read FMCSC  {$IFNDEF D6PLUS} write FMCSC {$ENDIF} stored False;

    property ProcessorCount: Byte read GetProcCount {$IFNDEF D6PLUS} write FDummy {$ENDIF} stored False;

    property MemoryModuleCount: Byte read GetMemModCount {$IFNDEF D6PLUS} write FDummy {$ENDIF} stored False;

    property MemoryDeviceCount: Byte read GetMemDevCount {$IFNDEF D6PLUS} write FDummy {$ENDIF} stored False;

    property PortCount: Byte read GetPortCount {$IFNDEF D6PLUS} write FDummy {$ENDIF} stored False;

    property SystemSlotCount: Byte read GetSlotCount {$IFNDEF D6PLUS} write FDummy {$ENDIF} stored False;

    property CacheCount: Byte read GetCacheCount {$IFNDEF D6PLUS} write FDummy {$ENDIF} stored False;

    property OnBoardDeviceCount: Byte read GetOBDCount {$IFNDEF D6PLUS} write FDummy {$ENDIF} stored False;

    property TemperatureProbeCount: Byte read GetTempProbeCount {$IFNDEF D6PLUS} write FDummy {$ENDIF} stored False;
  end;

implementation

uses Math, MiTeC_Routines, MiTeC_Native;

{ TSMBIOS }

procedure TSMBIOS.AddTable;
var
  i: Integer;
begin
  SetLength(ST,Length(ST)+1);
  with ST[High(ST)] do begin
    Address:=Addr;
    Indicator:=Ind;
    Length:=Len;
    Handle:=Hndl;
    Name:='Unknown';
    for i:=0 to High(SMB_TableTypes) do
      if SMB_TableTypes[i].Typ=Ind then begin
        Name:=SMB_TableTypes[i].Name;
        Break;
      end;
//    MessageBox(0,PChar(Format('%x: Table %d - %s: Length: %d B',[Address,Indicator,Name,Length])),'',MB_OK);
  end;
end;

procedure TSMBIOS.ScanTables;
var
 l,sl: Byte;
 p,i: DWORD;
 Found: Boolean;
begin
  p:=0;
  with FStructure do begin
  if not IsValidAddress(FStructStart) then
    Exit;
  AddTable(FStructStart+p,ByteValue[FStructStart+p],ByteValue[FStructStart+p+1],WordValue[FStructStart+p+2],StructTables);
  Found:=ByteValue[FStructStart+p]=0;
  repeat
    sl:=ByteValue[FStructStart+p+1];
    p:=p+sl+1;
    i:=0;
    l:=ByteValue[FStructStart+p-1];
// Handle Memory Controller Information specially as some BIOSes (Award Modular BIOS v4.51PG, P6BX-A+ Ver 3.2c, 11/28/1998) don't put two zero bytes after it
    if not((StructTables[High(StructTables)].Indicator=5) and (l>5) and (l<>32)) then begin
      while IsvalidAddress(FStructStart+p+i) and ((l+ByteValue[FStructStart+p+i]<>0) or (Found and (ByteValue[FStructStart+p+i+1]=0))) do begin
        l:=ByteValue[FStructStart+p+i];
        Inc(i);
      end;
      p:=p+i+1;
    end else
      p:=p-1;
    if Length(StructTables)<StructCount then
      AddTable(FStructStart+p,ByteValue[FStructStart+p],ByteValue[FStructStart+p+1],WordValue[FStructStart+p+2],StructTables);
    Found:=Found or (ByteValue[FStructStart+p]=0);
  until (ByteValue[FStructStart+p]=SMB_EOT) or (FStructStart+p>=FStructStart+FLen);
  end;
end;

function TSMBIOS.FindTableRecord;
var
  i: integer;
begin
  ZeroMemory(@Result,SizeOf(TStructTable));
  for i:=From to High(ST) do
    if ST[i].Indicator=AType then begin
      Result:=ST[i];
      Break;
    end;
end;

function TSMBIOS.FindTableIndex;
var
  i: integer;
begin
  Result:=-1;
  for i:=From to High(ST) do
    if ST[i].Indicator=AType then begin
      Result:=i;
      Break;
    end;
end;

procedure TSMBIOS.GetInfo;
const
  smbios_as = '_SM_';
  dmi_as = '_DMI_';
var
  Buffer: TArrayBuffer;
  i,idx,j,c: Integer;
  sl,b: Byte;
  p: DWORD;
  s: string;
  ok: Boolean;
  w: Word;
begin
  {$IFDEF ERROR_INTERCEPT}PushTrace(FModes,Self,'GetInfo'); {$ENDIF}

  SetLength(StructTables,0);
  SetLength(FMemMod,0);
  SetLength(FMemdev,0);
  SetLength(FPort,0);
  SetLength(FSlot,0);
  SetLength(FCache,0);
  SetLength(FProc,0);
  SetLength(FOBD,0);
  SetLength(FTP,0);

  FStart:=0;
  FStructStart:=0;
  FMBMod:='';
  FSysMan:='';
  FSysMod:='';
  FBIOSdate:='';
  FVersion:='';
  FBIOSVendor:='';
  FBIOSVersion:='';
  FBIOSSize:=0;
  FSysVer:='';
  FSysSN:='';
  FMBSN:='';
  FMBMan:='';
  FMBVer:='';
  FMBAT:='';
  FMBLIC:='';
  FCHSN:='';
  FCHVer:='';
  FCHMan:='';
  FCHAT:='';
  FCHMod:=smchUnknown;
  FMCCI:=smisUnknown;
  FMCSI:=smisUnknown;
  FMCSS:=[];
  FMCST:=[];
  FMCSV:=[];
  FMCMS:=0;
  FMCSC:=0;
  FSysUUID:='';
  FLen:=0;
  FTableCount:=0;

  if Local=1 then begin
    ok:=FSMBIOS.MapMemory(addr_BIOSBegin,addr_BIOSEnd-addr_BIOSBegin);
    if ok then
      for i:=addr_BIOSBegin to addr_BIOSEnd do begin
        if (FSMBIOS.CharValue[i]=smbios_as[1]) then begin
          ZeroMemory(@Buffer,Sizeof(Buffer));
          Buffer:=FSMBIOS.ArrayValue[i,Length(smbios_as)];
          if Pos(smbios_as,string(Buffer))=1 then begin
            FStart:=i;
            Break;
          end;
        end;
      end;
    if FStart=0 then
      for i:=addr_BIOSBegin to addr_BIOSEnd do begin
        if (FSMBIOS.CharValue[i]=dmi_as[1]) then begin
          ZeroMemory(@Buffer,SizeOf(Buffer));
          Buffer:=FSMBIOS.ArrayValue[i,Length(dmi_as)];
          if Pos(dmi_as,string(Buffer))=1 then begin
            FStart:=i-$10;
            Break;
          end;
        end;
      end;
    if FStart>0 then begin
      FMinorVersion:=FSMBIOS.ByteValue[FStart+$7];
      FMajorVersion:=FSMBIOS.ByteValue[FStart+$6];
      FVersion:=Format('%d.%d',[FMajorVersion,FMinorVersion]);
      FRevision:=Format('%d.%d',[Lo(FSMBIOS.ByteValue[FStart+$1F]),Hi(FSMBIOS.ByteValue[FStart+$1F])]);
      FStructStart:=FSMBIOS.DWORDValue[FStart+$18];
      FTableCount:=FSMBIOS.WORDValue[FStart+$1C];
      FLen:=FSMBIOS.WORDValue[FStart+$16];
      if FStructStart<=0 then
        Exit;
      FStructure.MapMemory(FStructStart,FLen);
    end;
  end else begin
    FStructStart:=0;
    FTableCount:=MaxWord;
    FLen:=FStructure.MemorySize;
    ok:=True;
  end;

  if ok then begin
    ScanTables;

    with FStructure do begin
    // Table 0
    p:=FindTableRecord(SMB_BIOSINFO,StructTables).Address;
    if (p>=FStructStart) and (ByteValue[p]=0) then begin
      sl:=ByteValue[p+1];
      FBIOSSize:=(ByteValue[p+9]+1)*64;
      if ByteValue[p+4]>0 then begin
        FBIOSVendor:=ArrayValue[p+sl,255];
        sl:=sl+Length(FBIOSVendor)+1;
        FBIOSVendor:=Trim(FBIOSVendor);
      end;
      if ByteValue[p+5]>0 then begin
        FBIOSVersion:=ArrayValue[p+sl,255];
        sl:=sl+Length(FBIOSVersion)+1;
        FBIOSVersion:=Trim(FBIOSVersion);
      end;
      if ByteValue[p+8]>0 then begin
        FBIOSDate:=ArrayValue[p+sl,255];
        FBIOSDate:=Trim(FBIOSdate);
      end;
    end;

    // Table 1
    idx:=FindTableIndex(SMB_SYSINFO,StructTables);
    p:=FindTableRecord(SMB_SYSINFO,StructTables).Address;
    if (p>=FStructStart) and (ByteValue[p]=1) then begin
      sl:=ByteValue[p+1];
      FSysUUID:='';
      if StructTables[idx].Length>$8 then
        for i:=0 to 15 do
          FSysUUID:=FSysUUID+Format('%2.2x',[ByteValue[p+8+i]]);
      if ByteValue[p+4]>0 then begin
        FSysMan:=ArrayValue[p+sl,255];
        sl:=sl+Length(FSysMan)+1;
        FSysMan:=Trim(FSysMan);
      end;
      if ByteValue[p+5]>0 then begin
        FSysMod:=ArrayValue[p+sl,255];
        sl:=sl+Length(FSysMod)+1;
        FSysMod:=Trim(FSysMod);
      end;
      if ByteValue[p+6]>0 then begin
        FSysVer:=ArrayValue[p+sl,255];
        sl:=sl+Length(FSysVer)+1;
        FSysVer:=Trim(FSysVer);
      end;
      if ByteValue[p+7]>0 then begin
        FSysSN:=ArrayValue[p+sl,255];
        FSysSN:=Trim(FSysSN);
      end;
    end;

    //Table 2
    p:=FindTableRecord(SMB_BASEINFO,StructTables).Address;
    if (p>=FStructStart) and (ByteValue[p]=2) then begin
      sl:=ByteValue[p+1];
      if ByteValue[p+4]>0 then begin
        FMBMan:=ArrayValue[p+sl,255];
        sl:=sl+Length(FMBMan)+1;
        FMBMan:=Trim(FMBMan);
      end;
      if ByteValue[p+5]>0 then begin
        FMBMod:=ArrayValue[p+sl,255];
        sl:=sl+Length(FMBMod)+1;
        FMBMod:=Trim(FMBMod);
      end;
      if ByteValue[p+6]>0 then begin
        FMBVer:=ArrayValue[p+sl,255];
        sl:=sl+Length(FMBVer)+1;
        FMBVer:=Trim(FMBVer);
      end;
      if ByteValue[p+7]>0 then begin
        FMBSN:=ArrayValue[p+sl,255];
        sl:=sl+Length(FMBSN)+1;
        FMBSN:=Trim(FMBSN);
      end;
      if ByteValue[p+8]>0 then begin
        FMBAT:=ArrayValue[p+sl,255];
        sl:=sl+Length(FMBAT)+1;
        FMBAT:=Trim(FMBAT);
      end;
      if FindTableRecord(SMB_BASEINFO,StructTables).Length>=$A then begin
        if ByteValue[p+$A]>0 then begin
          FMBLIC:=ArrayValue[p+sl,255];
          FMBLIC:=Trim(FMBLIC);
        end;
      end;
    end;

    //Table 3
    p:=FindTableRecord(SMB_SYSENC,StructTables).Address;
    if (p>=FStructStart) and (ByteValue[p]=3) then begin
      sl:=ByteValue[p+1];
      FCHMod:=TChassis((ByteValue[p+5] and $7F)-1);
      if ByteValue[p+4]>0 then begin
        FCHMan:=ArrayValue[p+sl,255];
        sl:=sl+Length(FCHMan)+1;
        FCHMan:=Trim(FCHMan);
      end;
      if ByteValue[p+6]>0 then begin
        FCHVer:=ArrayValue[p+sl,255];
        sl:=sl+Length(FCHVer)+1;
        FCHVer:=Trim(FCHVer);
      end;
      if ByteValue[p+7]>0 then begin
        FCHSN:=ArrayValue[p+sl,255];
        sl:=sl+Length(FCHSN)+1;
        FCHSN:=Trim(FCHSN);
      end;
      if ByteValue[p+8]>0 then begin
        FCHAT:=ArrayValue[p+sl,255];
        FCHAT:=Trim(FCHAT);
      end;
    end;

    //Table 4
    idx:=FindTableIndex(SMB_CPU,StructTables);
    if idx>-1 then
      repeat
        p:=StructTables[idx].Address;
        if (p>=FStructStart) and (ByteValue[p]=4) then begin
          sl:=ByteValue[p+1];
          SetLength(FProc,Length(FProc)+1);
          with FProc[High(FProc)] do begin
            b:=ByteValue[p+$11];
            if IsBitOn(b,7) then begin
              Voltage:=(b-$80)/10
            end else begin
              if IsBitOn(b,0) then
                Voltage:=5
              else
                if IsBitOn(b,1) then
                  Voltage:=3.3
                else
                  if IsBitOn(b,2) then
                    Voltage:=2.9
            end;
            Upgrade:=TUpgrade(ByteValue[p+$19]-1);
            w:=Wordvalue[p+$12];
            ExternalClock:=w;
            w:=Wordvalue[p+$16];
            Frequency:=w;
            if ByteValue[p+4]>0 then begin
              Socket:=ArrayValue[p+sl,255];
              sl:=sl+Length(Socket)+1;
              Socket:=Trim(Socket);
            end;
            if ByteValue[p+7]>0 then begin
              Manufacturer:=ArrayValue[p+sl,255];
              sl:=sl+Length(Manufacturer)+1;
              Manufacturer:=Trim(Manufacturer);
            end;
            if ByteValue[p+$10]>0 then begin
              Version:=ArrayValue[p+sl,255];
              Version:=Trim(Version);
            end;
            SerialNumber:='';
            PartNumber:='';
            AssetTag:='';
            if (FMajorVersion>2) or (FMinorVersion>=3) then begin
              if ByteValue[p+$20]>0 then begin
                SerialNumber:=ArrayValue[p+sl,255];
                sl:=sl+Length(SerialNumber)+1;
                SerialNumber:=Trim(SerialNumber);
              end;
              if ByteValue[p+$21]>0 then begin
                AssetTag:=ArrayValue[p+sl,255];
                sl:=sl+Length(Assettag)+1;
                AssetTag:=Trim(AssetTag);
              end;
              if ByteValue[p+$22]>0 then begin
                PartNumber:=ArrayValue[p+sl,255];
                PartNumber:=Trim(PartNumber);
              end;
            end;
          end;
        end;
        if Trim(FProc[High(FProc)].Version)='' then
          Fproc[High(FProc)].Version:=Format('Processor_%d',[High(FProc)]);
        idx:=FindTableIndex(4,StructTables,idx+1);
      until idx=-1;

    //Table 5
    idx:=FindTableIndex(SMB_MEMCTRL,StructTables);
    if idx>-1 then
      repeat
        p:=StructTables[idx].Address;
        if (p>=FStructStart) and (ByteValue[p]=5) then begin
          FMCSI:=TInterleaveSupport(ByteValue[p+$6]-1);
          FMCCI:=TInterleaveSupport(ByteValue[p+$7]-1);
          try
            FMCMS:=Round(Power(2,ByteValue[p+$8]));
          except
            FMCMS:=0;
          end;
          w:=WordValue[p+$9];
          FMCSS:=[];
          for i:=0 to 4 do
            if IsBitOn(w,i) then
              FMCSS:=FMCSS+[TMemorySpeed(i)];
          w:=WordValue[p+$B];
          FMCST:=[];
          for i:=0 to 10 do
            if IsBitOn(w,i) then
              FMCST:=FMCST+[TMemorytype(i)];
          b:=ByteValue[p+$D];
          FMCSV:=[];
          for i:=0 to 2 do
            if IsBitOn(b,i) then
              FMCSV:=FMCSV+[TVoltage(i)];
          FMCSC:=ByteValue[p+$E];
        end;
        idx:=FindTableIndex(5,StructTables,idx+1);
      until idx=-1;

    //Table 6
    idx:=FindTableIndex(SMB_MEMMOD,StructTables);
    if idx>-1 then
    repeat
      p:=StructTables[idx].Address;
      if (p>=FStructStart) and (ByteValue[p]=6) then begin
        sl:=ByteValue[p+1];
        SetLength(FMemMod,Length(FMemMod)+1);
        j:=High(FMemMod);
        with FMemMod[j] do begin
          if ByteValue[p+4]>0 then
            Socket:=Trim(ArrayValue[p+sl,255]);
          Speed:=ByteValue[p+6];
          w:=WordValue[p+7];
          Types:=[];
          for i:=0 to 10 do
            if IsBitOn(w,i) then
              Types:=Types+[TMemorytype(i)];
          b:=ByteValue[p+$9];
          if b>=128 then
            b:=b xor 128;
          if b in [$7D..$7F] then
            Size:=0
          else
            try
              Size:=Round(Power(2,b));
            except
              Size:=0;
            end;
        end;
      end;
      idx:=FindTableIndex(6,StructTables,idx+1);
    until idx=-1;

    //Table 7
    idx:=FindTableIndex(SMB_CACHE,StructTables);
    if idx>-1 then
    repeat
      p:=StructTables[idx].Address;
      if (p>=FStructStart) and (ByteValue[p]=7) then begin
        sl:=ByteValue[p+1];
        SetLength(FCache,Length(FCache)+1);
        with FCache[High(FCache)] do begin
          if ByteValue[p+4]>0 then
            Designation:=Trim(ArrayValue[p+sl,255]);
          w:=WordValue[p+$7];
          if w>=32768 then
            w:=w xor 32768;
          if IsBitOn(WordValue[p+$7],15) then
            MaxSize:=w*64
          else
            MaxSize:=w;
          w:=WordValue[p+$9];
          if w>=32768 then
            w:=w xor 32768;
          if IsBitOn(WordValue[p+$9],15) then
            InstalledSize:=w*64
          else
            InstalledSize:=w;
          w:=WordValue[p+$D];
          for i:=0 to 6 do
            if IsBitOn(w,i) then
              SRAMType:=TSRAMType(i);
          if StructTables[idx].Length<=$F then begin
            Associativity:=caUnknown;
            Typ:=ctUnknown;
            Speed:=0;
          end else begin
            try
              if ByteValue[p+$12]-1 in [integer(Low(TCacheAssociativity))..integer(High(TCacheAssociativity))] then
                Associativity:=TCacheAssociativity(ByteValue[p+$12]-1)
              else
                Associativity:=caUnknown;
            except
              Associativity:=caUnknown;
            end;
            try
              if ByteValue[p+$11]-1 in [integer(Low(TCacheType))..integer(High(TCacheType))] then
                Typ:=TCacheType(ByteValue[p+$11]-1)
              else
                Typ:=ctUnknown;
            except
              Typ:=ctUnknown;
            end;
            Speed:=ByteValue[p+$F];
          end;
        end;
        if Trim(FCache[High(FCache)].Designation)='' then
          FCache[High(FCache)].Designation:=Format('Cache_%d',[High(FCache)]);
      end;
      idx:=FindTableIndex(7,StructTables,idx+1);
    until idx=-1;

    //Table 8
    idx:=FindTableIndex(SMB_PORTCON,StructTables);
    if idx>-1 then
    repeat
      p:=StructTables[idx].Address;
      if (p>=FStructStart) and (ByteValue[p]=8) then begin
        sl:=ByteValue[p+1];
        SetLength(FPort,Length(FPort)+1);
        with FPort[High(FPort)] do begin
          if ByteValue[p+4]>0 then begin
            InternalDesignator:=ArrayValue[p+sl,255];
            sl:=sl+Length(InternalDesignator)+1;
            InternalDesignator:=Trim(InternalDesignator);
          end;
          b:=Bytevalue[p+5];
          if b<$FF then
            InternalConnector:=TConnectorType(b)
          else
            InternalConnector:=smctOther;
          if ByteValue[p+6]>0 then
            ExternalDesignator:=Trim(ArrayValue[p+sl,255]);
          b:=Bytevalue[p+7];
          if b<$FF then
            ExternalConnector:=TConnectorType(b)
          else
            ExternalConnector:=smctOther;
          b:=Bytevalue[p+8];
          if b<$FF then begin
            if b>$1F then
              b:=b-$80;
            Typ:=TPortType(b);
          end else
            Typ:=smptOther;
        end;
        if Trim(FPort[High(FPort)].ExternalDesignator)='' then
          FPort[High(FPort)].ExternalDesignator:=Format('PortSlot_%d',[High(FPort)]);
      end;
      idx:=FindTableIndex(8,StructTables,idx+1);
    until idx=-1;

    //Table 9
    idx:=FindTableIndex(SMB_SLOTS,StructTables);
    if idx>-1 then
    repeat
      p:=StructTables[idx].Address;
      if (p>=FStructStart) and (ByteValue[p]=9) then begin
        sl:=ByteValue[p+1];
        SetLength(FSlot,Length(FSlot)+1);
        with FSlot[High(FSlot)] do begin
          if ByteValue[p+4]>0 then
            Designation:=Trim(ArrayValue[p+sl,255]);
          b:=Bytevalue[p+5];
          if b>$13 then
            case b of
              $A0: Typ:=TSlotType(19);
              $A1: Typ:=TSlotType(20);
              $A2: Typ:=TSlotType(21);
              $A3: Typ:=TSlotType(22);
              $A4: Typ:=TSlotType(23);
            end
          else
            Typ:=TSlotType(b-1);
          DataBus:=TDataBusType(Bytevalue[p+6]-1);
          Usage:=TSlotUsage(Bytevalue[p+7]-1);
          Length:=TSlotLength(Bytevalue[p+8]-1);
          ID:=WordValue[p+9];
        end;
        if Trim(FSlot[High(FSlot)].Designation)='' then
          FSlot[High(FSlot)].Designation:=Format('Slot_%d',[High(FSlot)]);
      end;
      idx:=FindTableIndex(9,StructTables,idx+1);
    until idx=-1;

    //Table 10
    idx:=FindTableIndex(SMB_ONBOARD,StructTables);
    if idx>-1 then
      repeat
        p:=StructTables[idx].Address;
        if (p>=FStructStart) and (ByteValue[p]=SMB_ONBOARD) then begin
          c:=(StructTables[idx].Length-4) div 2;
          sl:=ByteValue[p+1];
          for i:=0 to c-1 do begin
            SetLength(FOBD,Length(FOBD)+1);
            with FOBD[High(FOBD)] do begin
              b:=ByteValue[p+4+2*((i+1)-1)];
              if (b-1)<=Integer(High(TOnBoardDeviceType)) then
                Typ:=TOnBoardDeviceType(b-1)
              else
                Typ:=obdOther;
              Status:=IsBitOn(b,7);
              if ByteValue[p+5+2*((i+1)-1)]>0 then begin
                DeviceName:=Trim(ArrayValue[p+sl,255]);
                sl:=sl+Length(DeviceName)+1;
              end;
            end;
          end;
        end;
        idx:=FindTableIndex(SMB_ONBOARD,StructTables,idx+1);
      until idx=-1;

    //Table 17
    idx:=FindTableIndex(SMB_MEMDEV,StructTables);
    if idx>-1 then
      repeat
        p:=StructTables[idx].Address;
        if (p>=FStructStart) and (ByteValue[p]=SMB_MEMDEV) then begin
          sl:=ByteValue[p+1];
          SetLength(FMemDev,Length(FMemDev)+1);
          with FMemDev[High(FMemDev)] do begin
            TotalWidth:=WordValue[p+$08];
            DataWidth:=WordValue[p+$0A];
            Size:=WordValue[p+$0C];
            FormFactor:=TMemoryFormFactor(ByteValue[p+$0E]-1);
            if ByteValue[p+$10]>0 then begin
              DeviceLocator:=Trim(ArrayValue[p+sl,255]);
              sl:=sl+Length(DeviceLocator)+1;
            end;
            if ByteValue[p+$11]>0 then begin
              BankLocator:=Trim(ArrayValue[p+sl,255]);
              sl:=sl+Length(BankLocator)+1;
            end;
            Device:=TMemoryDeviceType(ByteValue[p+$12]-1);
            w:=WordValue[p+$13];
            TypeDetails:=[];
            for i:=0 to 12 do
              if IsBitOn(w,i) then
                TypeDetails:=TypeDetails+[TMemoryTypeDetail(i)];
            Speed:=0;
            Manufacturer:='';
            SerialNumber:='';
            PartNumber:='';
            AssetTag:='';
            if (FMajorVersion>2) or (FMinorVersion>=3) then begin
              Speed:=WordValue[p+$15];
              if Speed>0 then
                Speed:=(1000 div WordValue[p+$15]);
              if ByteValue[p+$17]>0 then begin
                Manufacturer:=ArrayValue[p+sl,255];
                sl:=sl+Length(Manufacturer)+1;
                Manufacturer:=Trim(Manufacturer);
              end;
              if ByteValue[p+$18]>0 then begin
                SerialNumber:=ArrayValue[p+sl,255];
                sl:=sl+Length(SerialNumber)+1;
                SerialNumber:=Trim(SerialNumber);
              end;
              if ByteValue[p+$19]>0 then begin
                AssetTag:=ArrayValue[p+sl,255];
                sl:=sl+Length(Assettag)+1;
                AssetTag:=Trim(AssetTag);
              end;
              if ByteValue[p+$1A]>0 then begin
                PartNumber:=ArrayValue[p+sl,255];
                PartNumber:=Trim(PartNumber);
              end;
            end;
          end;
        end;
        idx:=FindTableIndex(SMB_MEMDEV,StructTables,idx+1);
      until idx=-1;


    //Table 28
    idx:=FindTableIndex(SMB_TEMP,StructTables);
    if idx>-1 then
      repeat
        p:=StructTables[idx].Address;
        if (p>=FStructStart) and (ByteValue[p]=SMB_TEMP) then begin
          sl:=ByteValue[p+1];
          SetLength(FTP,Length(FTP)+1);
          with FTP[High(FTP)] do begin
            if ByteValue[p+$4]>0 then begin
              Description:=Trim(ArrayValue[p+sl,255]);
            end;
            b:=Bytevalue[p+$5];
            Status:=TStatusType((b shr 4)-1);
            Location:=TLocationType(swap(b shl 4) shr 12-1);
            Max:=WordValue[p+$6];
            Min:=WordValue[p+$6];
            Resolution:=WordValue[p+$A];
            Tolerance:=WordValue[p+$C];
            Accuracy:=WordValue[p+$E];
            if StructTables[idx].Length>$14 then
              Value:=Wordvalue[p+$14]
            else
              Value:=0;
          end;
        end;
        idx:=FindTableIndex(SMB_TEMP,StructTables,idx+1);
      until idx=-1;
  end;
  end;

  {$IFDEF ERROR_INTERCEPT}PopTrace;{$ENDIF}
end;

function TSMBIOS.GetMemoryModule(Index: Byte): TMemoryModule;
begin
  ZeroMemory(@Result,SizeOf(TMemoryModule));
  try
    Result:=FMemMod[Index];
  except
  end;
end;

function TSMBIOS.GetMemDevCount: Byte;
begin
  Result:=Length(FMemDev);
end;

function TSMBIOS.GetMemoryTypeStr(Value: TMemoryTypes): string;
var
  i: TMemoryType;
begin
  Result:='';
  for i:=Low(TMemoryType) to High(TMemoryType) do
    if i in Value then
      Result:=Result+MemoryTypes[i]+',';
  if Length(Result)>0 then
    SetLength(Result,Length(Result)-1);
end;

procedure TSMBIOS.Report;
var
  i: Integer;
begin
  {$IFDEF ERROR_INTERCEPT}PushTrace(FModes,Self,'Report'); {$ENDIF}
  with FSMBIOS, sl do begin
    if Standalone then ReportHeader(sl);
    Add('<SMBIOS classname="TSMBIOS">');

    Add(Format('<data name="Version" type="string">%s</data>',[CheckXMLValue(Version)]));
    Add(Format('<data name="StartAddress" type="integer">%d</data>',[SMBIOSAddress]));
    Add(Format('<data name="StructureTableStartAddress" type="integer">%d</data>',[DwordValue[StructStart+$18]]));
    Add(Format('<data name="TableCount" type="integer">%d</data>',[High(StructTables)]));
    for i:=0 to High(StructTables) do
      Add(Format('<data name="Table_%d" type="string">%s</data>',[StructTables[i].Indicator,StructTables[i].Name]));
    Add('<section name="BIOS">');
    Add(Format('<data name="Vendor" type="string">%s</data>',[CheckXMLValue(BIOSVendor)]));
    Add(Format('<data name="Version" type="string">%s</data>',[CheckXMLValue(BIOSVersion)]));
    Add(Format('<data name="Date" type="string">%s</data>',[CheckXMLValue(BIOSDate)]));
    Add(Format('<data name="Size" type="integer" unit="KB">%d</data>',[BIOSSize]));
    Add('</section>');
    Add('<section name="System">');
    Add(Format('<data name="Model" type="string">%s</data>',[CheckXMLValue(SystemModel)]));
    Add(Format('<data name="Manufacturer" type="string">%s</data>',[CheckXMLValue(SystemManufacturer)]));
    Add(Format('<data name="Version" type="string">%s</data>',[CheckXMLValue(SystemVersion)]));
    Add(Format('<data name="Serial" type="string">%s</data>',[CheckXMLValue(SystemSerial)]));
    Add(Format('<data name="UUID" type="string">%s</data>',[CheckXMLValue(SystemUUID)]));
    Add('</section>');
    Add('<section name="Mainboard">');
    Add(Format('<data name="Model" type="string">%s</data>',[CheckXMLValue(MainBoardModel)]));
    Add(Format('<data name="Manufacturer" type="string">%s</data>',[CheckXMLValue(MainBoardManufacturer)]));
    Add(Format('<data name="Version" type="string">%s</data>',[CheckXMLValue(MainBoardVersion)]));
    Add(Format('<data name="Serial" type="string">%s</data>',[CheckXMLValue(MainBoardSerial)]));
    Add('</section>');
    Add('<section name="Chassis">');
    Add(Format('<data name="Model" type="string">%s</data>',[CheckXMLValue(ChassisTypes[ChassisModel])]));
    Add(Format('<data name="Manufacturer" type="string">%s</data>',[CheckXMLValue(ChassisManufacturer)]));
    Add(Format('<data name="Version" type="string">%s</data>',[CheckXMLValue(ChassisVersion)]));
    Add(Format('<data name="Serial" type="string">%s</data>',[CheckXMLValue(ChassisSerial)]));
    Add(Format('<data name="AssetTag" type="string">%s</data>',[CheckXMLValue(ChassisAssetTag)]));
    Add('</section>');
    Add('<section name="MemoryController">');
    Add(Format('<data name="SupportedInterleave" type="string">%s</data>',[CheckXMLValue(InterleaveSupports[MemCtrlSupportedInterleave])]));
    Add(Format('<data name="ActiveInterleave" type="string">%s</data>',[CheckXMLValue(InterleaveSupports[MemCtrlCurrentInterleave])]));
    Add(Format('<data name="MaxModuleSize" type="integer" unit="MB">%d</data>',[MemCtrlMaxSize]));
    Add(Format('<data name="SupportedSpeeds" type="string">%s</data>',[CheckXMLValue(GetMemorySpeedStr(MemCtrlSupportedSpeeds))]));
    Add(Format('<data name="SupportedTypes" type="string">%s</data>',[CheckXMLValue(GetMemoryTypeStr(MemCtrlSupportedTypes))]));
    Add(Format('<data name="SupportedVoltages" type="string">%s</data>',[CheckXMLValue(GetMemoryVoltageStr(MemCtrlSupportedVoltages))]));
    Add(Format('<data name="SlotCount" type="integer">%d</data>',[MemCtrlSlotCount]));
    Add('</section>');
    Add('<section name="CPU">');
    Add(Format('<data name="Count" type="integer">%d</data>',[ProcessorCount]));
    for i:=0 to ProcessorCount-1 do begin
      Add(Format('<section name="%s">',[CheckXMLValue(Processor[i].Version)]));
      Add(Format('<data name="Socket" type="string">%s</data>',[CheckXMLValue(Processor[i].Socket)]));
      Add(Format('<data name="UpgradeInterface" type="string">%s</data>',[CheckXMLValue(Upgrades[Processor[i].Upgrade])]));
      Add(Format('<data name="Manufacturer" type="string">%s</data>',[CheckXMLValue(Processor[i].Manufacturer)]));
      Add(Format('<data name="Version" type="string">%s</data>',[CheckXMLValue(Processor[i].Version)]));
      Add(Format('<data name="Voltage" type="float" unit="V">%1.1f</data>',[Processor[i].Voltage]));
      Add(Format('<data name="Frequency" type="integer" unit="MHz">%d</data>',[Processor[i].Frequency]));
      Add(Format('<data name="ExternalFrequency" type="integer" unit="MHz">%d</data>',[Processor[i].ExternalClock]));
      Add(Format('<data name="SerialNumber" type="string">%s</data>',[CheckXMLValue(Processor[i].SerialNumber)]));
      Add(Format('<data name="AssetTag" type="string">%s</data>',[CheckXMLValue(Processor[i].AssetTag)]));
      Add(Format('<data name="PartNumber" type="string">%s</data>',[CheckXMLValue(Processor[i].PartNumber)]));
      Add('</section>');
    end;
    Add('</section>');
    Add('<section name="Cache">');
    Add(Format('<data name="Count" type="integer">%d</data>',[CacheCount]));
    for i:=0 to CacheCount-1 do begin
      Add(Format('<section name="%s">',[CheckXMLValue(Cache[i].Designation)]));
      Add(Format('<data name="Socket" type="string">%s</data>',[CheckXMLValue(Cache[i].Designation)]));
      Add(Format('<data name="InstalledSize" type="integer" unit="KB">%d</data>',[Cache[i].InstalledSize]));
      Add(Format('<data name="MaxSize" type="integer" unit="KB">%d</data>',[Cache[i].MaxSize]));
      Add(Format('<data name="Speed" type="integer" unit="ns">%d</data>',[Cache[i].Speed]));
      Add(Format('<data name="Type" type="string">%s</data>',[CacheTypes[Cache[i].Typ]]));
      Add(Format('<data name="Associativity" type="string">%s</data>',[CacheAssociativities[Cache[i].Associativity]]));
      Add(Format('<data name="SRAMType" type="string">%s</data>',[SRAMTypes[Cache[i].SRAMType]]));
      Add('</section>');
    end;
    Add('</section>');
    Add('<section name="MemoryModule">');
    Add(Format('<data name="Count" type="integer">%d</data>',[MemoryModuleCount]));
    for i:=0 to MemoryModuleCount-1 do begin
      Add(Format('<section name="Module_%d">',[i]));
      Add(Format('<data name="Bank" type="string">%s</data>',[CheckXMLValue(MemoryModule[i].Socket)]));
      Add(Format('<data name="Type" type="string">%s</data>',[GetMemoryTypeStr(MemoryModule[i].Types)]));
      Add(Format('<data name="Size" type="integer" unit="MB">%d</data>',[MemoryModule[i].Size]));
      Add(Format('<data name="Speed" type="integer" unit="ns">%d</data>',[MemoryModule[i].Speed]));
      Add('</section>');
    end;
    Add('</section>');
    Add('<section name="MemoryDevice">');
    Add(Format('<data name="Count" type="integer">%d</data>',[MemoryDeviceCount]));
    for i:=0 to MemoryDeviceCount-1 do begin
      Add(Format('<section name="Device_%d">',[i]));
      Add(Format('<data name="DeviceLocator" type="string">%s</data>',[CheckXMLValue(MemoryDevice[i].DeviceLocator)]));
      Add(Format('<data name="BankLocator" type="string">%s</data>',[CheckXMLValue(MemoryDevice[i].BankLocator)]));
      Add(Format('<data name="Manufacturer" type="string">%s</data>',[CheckXMLValue(MemoryDevice[i].Manufacturer)]));
      Add(Format('<data name="SerialNumber" type="string">%s</data>',[CheckXMLValue(MemoryDevice[i].SerialNumber)]));
      Add(Format('<data name="AssetTag" type="string">%s</data>',[CheckXMLValue(MemoryDevice[i].AssetTag)]));
      Add(Format('<data name="PartNumber" type="string">%s</data>',[CheckXMLValue(MemoryDevice[i].PartNumber)]));
      Add(Format('<data name="Device" type="string">%s</data>',[MemoryDeviceTypes[MemoryDevice[i].Device]]));
      Add(Format('<data name="TypeDetails" type="string">%s</data>',[GetMemoryTypeDetailsStr(MemoryDevice[i].TypeDetails)]));
      Add(Format('<data name="FormFactor" type="string">%s</data>',[MemoryFormFactors[MemoryDevice[i].FormFactor]]));
      Add(Format('<data name="Size" type="integer" unit="MB">%d</data>',[MemoryDevice[i].Size]));
      Add(Format('<data name="Speed" type="integer" unit="MHz">%d</data>',[MemoryDevice[i].Speed]));
      Add(Format('<data name="TotalWidth" type="integer" unit="b">%d</data>',[MemoryDevice[i].TotalWidth]));
      Add(Format('<data name="DataWidth" type="integer" unit="b">%d</data>',[MemoryDevice[i].DataWidth]));
      Add('</section>');
    end;
    Add('</section>');
    Add('<section name="PortSlot">');
    Add(Format('<data name="Count" type="integer">%d</data>',[PortCount]));
    for i:=0 to PortCount-1 do begin
      Add(Format('<section name="%s">',[CheckXMLValue(Port[i].ExternalDesignator)]));
      Add(Format('<data name="Type" type="string">%s</data>',[PortTypes[Port[i].Typ]]));
      Add(Format('<data name="InternalDesignator" type="string">%s</data>',[CheckXMLValue(Port[i].InternalDesignator)]));
      Add(Format('<data name="InternalConnector" type="string">%s</data>',[ConnectorTypes[Port[i].InternalConnector]]));
      Add(Format('<data name="ExternalDesignator" type="string">%s</data>',[CheckXMLValue(Port[i].ExternalDesignator)]));
      Add(Format('<data name="ExternalConnector" type="string">%s</data>',[ConnectorTypes[Port[i].ExternalConnector]]));
      Add('</section>');
    end;
    Add('</section>');
    Add('<section name="SystemSlot">');
    Add(Format('<data name="Count" type="integer">%d</data>',[SystemSlotCount]));
    for i:=0 to SystemSlotCount-1 do begin
      Add(Format('<section name="%s">',[CheckXMLValue(SystemSlot[i].Designation)]));
      Add(Format('<data name="Type" type="string">%s</data>',[SlotTypes[SystemSlot[i].Typ]]));
      Add(Format('<data name="DataBus" type="string">%s</data>',[DataBusTypes[SystemSlot[i].DataBus]]));
      Add(Format('<data name="CurrentUsage" type="string">%s</data>',[SlotUsages[SystemSlot[i].Usage]]));
      Add(Format('<data name="SlotLength" type="string">%s</data>',[SlotLengths[SystemSlot[i].Length]]));
      Add('</section>');
    end;
    Add('</section>');
    Add('<section name="OnBoardDevice">');
    Add(Format('<data name="Count" type="integer">%d</data>',[OnBoardDeviceCount]));
    for i:=0 to OnBoardDeviceCount-1 do begin
      Add(Format('<section name="%s">',[CheckXMLValue(OnBoardDevice[i].DeviceName)]));
      Add(Format('<data name="Type" type="string">%s</data>',[OnBoardDeviceTypes[OnBoardDevice[i].Typ]]));
      Add(Format('<data name="Status" type="Boolean">%d</data>',[Integer(OnBoardDevice[i].Status)]));
      Add('</section>');
    end;
    Add('</section>');
    Add('</SMBIOS>');
    if Standalone then ReportFooter(sl);
  end;
  {$IFDEF ERROR_INTERCEPT}PopTrace;{$ENDIF}
end;

function TSMBIOS.GetPort(Index: Byte): TPort;
begin
  ZeroMemory(@Result,SizeOf(TPort));
  try
    Result:=FPort[Index];
  except
  end;
end;

function TSMBIOS.GetPortCount: Byte;
begin
  Result:=Length(FPort);
end;

function TSMBIOS.GetSlot(Index: Byte): TSlot;
begin
  ZeroMemory(@Result,SizeOf(TSlot));
  try
    Result:=FSlot[Index];
  except
  end;
end;

function TSMBIOS.GetSlotCount: Byte;
begin
  Result:=Length(FSlot);
end;

function TSMBIOS.GetCache(Index: Byte): TCache;
begin
  ZeroMemory(@Result,SizeOf(Tcache));
  try
    Result:=FCache[Index];
  except
  end;
end;

function TSMBIOS.GetCacheCount: Byte;
begin
  Result:=Length(FCache);
end;

destructor TSMBIOS.Destroy;
begin
  SetLength(FProc,0);
  SetLength(FMemMod,0);
  SetLength(FMemDev,0);
  SetLength(FSlot,0);
  SetLength(FPort,0);
  SetLength(FCache,0);
  SetLength(StructTables,0);
  FSMBIOS.Free;
  FStructure.Free;
  inherited;
end;

function TSMBIOS.GetProc(Index: Byte): TProcessor;
begin
  ZeroMemory(@Result,SizeOf(TProcessor));
  try
    Result:=FProc[Index];
  except
  end;
end;

function TSMBIOS.GetProcCount: Byte;
begin
  Result:=Length(FProc);
end;

constructor TSMBIOS.Create;
begin
  inherited;
  FSMBIOS:=TDMA.Create;
  FStructure:=TDMA.Create;
  FSMBIOS.ExceptionModes:=ExceptionModes;
end;

function TSMBIOS.GetMemorySpeedStr(Value: TMemorySpeeds): string;
var
  i: TMemorySpeed;
begin
  Result:='';
  for i:=Low(TMemorySpeed) to High(TMemorySpeed) do
    if i in Value then
      Result:=Result+MemorySpeeds[i]+',';
  if Length(Result)>0 then
    SetLength(Result,Length(Result)-1);
end;

function TSMBIOS.GetMemoryVoltageStr(Value: TVoltages): string;
var
  i: TVoltage;
begin
  Result:='';
  for i:=Low(TVoltage) to High(TVoltage) do
    if i in Value then
      Result:=Result+Voltages[i]+',';
  if Length(Result)>0 then
    SetLength(Result,Length(Result)-1);
end;

procedure TSMBIOS.LoadSMBIOSFromFile(Filename: string);
begin
  FStructure.LoadFromFile(Filename);
  GetInfo(0);
end;

function TSMBIOS.GetOBDCount: Byte;
begin
  Result:=Length(FOBD);
end;

function TSMBIOS.GetOBD(Index: Byte): TOnBoardDevice;
begin
  ZeroMemory(@Result,SizeOf(TOnBoardDevice));
  try
    Result:=FOBD[Index];
  except
  end;
end;

function TSMBIOS.GetTempProbe(Index: Byte): TTemperatureProbe;
begin
  ZeroMemory(@Result,SizeOf(TTemperatureProbe));
  try
    Result:=FTP[Index];
  except
  end;
end;

function TSMBIOS.GetTempProbeCount: Byte;
begin
  Result:=Length(FTP);
end;

procedure TSMBIOS.SetMode(const Value: TExceptionModes);
begin
  FModes := Value;
  if Assigned(FSMBIOS) then
    FSMBIOS.ExceptionModes:=FModes;
  if Assigned(FStructure) then
    FStructure.ExceptionModes:=FModes;
end;

function TSMBIOS.GetMemModCount: Byte;
begin
  Result:=Length(FMemMod);
end;

function TSMBIOS.GetMemoryDevice(Index: Byte): TMemoryDevice;
begin
  ZeroMemory(@Result,SizeOf(TMemoryDevice));
  try
    Result:=FMemDev[Index];
  except
  end;
end;

function TSMBIOS.GetMemoryTypeDetailsStr(
  Value: TMemoryTypeDetails): string;
var
  i: TMemoryTypeDetail;
begin
  Result:='';
  for i:=Low(TMemoryTypeDetail) to High(TMemoryTypeDetail) do
    if i in Value then
      Result:=Result+MemoryTypeDetails[i]+',';
  if Length(Result)>0 then
    SetLength(Result,Length(Result)-1);
end;

end.

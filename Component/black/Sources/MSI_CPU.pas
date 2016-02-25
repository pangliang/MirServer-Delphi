{*******************************************************}
{							}
{	MiTeC System Information Component		}
{		CPU Detection Part			}
{	    version 8.6.5 for Delphi 5,6,7        	}
{							}
{	Copyright © 1997,2004 Michal Mutl		}
{							}
{*******************************************************}

{$INCLUDE MITEC_DEF.INC}

unit MSI_CPU;

interface

uses
  MSI_Common, SysUtils, Windows, Classes;

type
  TCPUType = (ctPrimary, ctOverDrive, ctSecondary, ctUnknown);
  TCPUFamily = (cfUnknown, cf8086, cf286, cf386, cf486, cf586, cf686, cf786, cf8086_64);
  TCPUArchitecture = (IA_32, IA_64);

  TCPUIDResult = packed record
    EAX: Cardinal;
    EBX: Cardinal;
    ECX: Cardinal;
    EDX: Cardinal;
  end;

  TIntelCache = array [0..15] of Byte;

  TAMDCache = record
    L12MDataTLB: array [0..1] of Byte;  //Entries, Associativity
    L12MInstructionTLB: array [0..1] of Byte;
    L14KDataTLB: array [0..1] of Byte;
    L14KInstructionTLB: array [0..1] of Byte;
    L1DataCache: array [0..3] of Byte;  // Line size(B), Lines per tag, Associativity, Size(KB)
    L1ICache: array [0..3] of Byte;
    L22MDataTLB: array [0..1] of Byte;
    L22MInstructionTLB: array [0..1] of Byte;
    L24KDataTLB: array [0..1] of Byte;
    L24KInstructionTLB: array [0..1] of Byte;
    Level2Cache: array [0..3] of Byte;
  end;

  TCyrixCache = record
    L1CacheInfo: array [0..3] of Byte;
    TLBInfo: array [0..3] of Byte;
  end;

  TFreqInfo = record
    RawFreq: Cardinal;
    NormFreq: Cardinal;
    InCycles: Cardinal;
    ExTicks: Cardinal;
  end;

const
{ CPUID EFLAGS Id bit }
  CPUIDID_BIT	=	$200000;

{ CPUID execution levels }
  CPUID_MAXLEVEL	: DWORD = $0;
  CPUID_VENDORSIGNATURE : DWORD = $0;
  CPUID_CPUSIGNATURE	: DWORD = $1;
  CPUID_CPUFEATURESET	: DWORD = $1;
  CPUID_CACHETLB	: DWORD = $2;
  CPUID_CPUSERIALNUMBER : DWORD = $3;
  CPUID_MAXLEVELEX	: DWORD = $80000000;
  CPUID_CPUSIGNATUREEX	: DWORD = $80000001;
  CPUID_CPUMARKETNAME1	: DWORD = $80000002;
  CPUID_CPUMARKETNAME2	: DWORD = $80000003;
  CPUID_CPUMARKETNAME3	: DWORD = $80000004;
  CPUID_LEVEL1CACHETLB	: DWORD = $80000005;
  CPUID_LEVEL2CACHETLB	: DWORD = $80000006;
  CPUID_APMFEATURESET	: DWORD = $80000007;
  CPUID_PHYSADDR	: DWORD = $80000008;

{ CPU vendors }
  VENDOR_UNKNOWN    = 0;
  VENDOR_INTEL	    = 1;
  VENDOR_AMD	    = 2;
  VENDOR_CYRIX	    = 3;
  VENDOR_IDT	    = 4;
  VENDOR_NEXGEN     = 5;
  VENDOR_UMC	    = 6;
  VENDOR_RISE	    = 7;
  VENDOR_TM	    = 8;
  VENDOR_SIS        = 9;
  VENDOR_NSC        = 10;

{ Standard feature set flags }
  SFS_FPU    = 0;
  SFS_VME    = 1;
  SFS_DE     = 2;
  SFS_PSE    = 3;
  SFS_TSC    = 4;
  SFS_MSR    = 5;
  SFS_PAE    = 6;
  SFS_MCE    = 7;
  SFS_CX8    = 8;
  SFS_APIC   = 9;
  SFS_SEP    = 11;
  SFS_MTRR   = 12;
  SFS_PGE    = 13;
  SFS_MCA    = 14;
  SFS_CMOV   = 15;
  SFS_PAT    = 16;
  SFS_PSE36  = 17;
  SFS_PSN    = 18;
  SFS_CLFSH  = 19;
  SFS_DS     = 21;
  SFS_ACPI   = 22;
  SFS_MMX    = 23;
  SFS_FXSR   = 24;
  SFS_SSE    = 25;
  SFS_SSE2   = 26;
  SFS_SS     = 27;
  SFS_HTT    = 28;
  SFS_TM     = 29;


{ Extended feature set flags (duplicates removed) }
  EFS_MP      = 19; { Multiprocessing capable }
  EFS_EXMMXA  = 22; { AMD Specific }
  EFS_EXMMXC  = 24; { Cyrix Specific }
  EFS_3DNOW   = 31;
  EFS_EX3DNOW = 30;


{ AMD Cache Associativity }
  AMDCA_L2OFF        = $0;
  AMDCA_DIRECTMAPPED = $1;
  AMDCA_2WAY         = $2;
  AMDCA_4WAY         = $4;
  AMDCA_8WAY         = $6;
  AMDCA_16WAY        = $8;
  AMDCA_FULL         = $F;

type
  TCPUFeatures = class(TPersistent)
  private
    FSEP: boolean;
    FMTRR: boolean;
    FMSR: boolean;
    FPSE: boolean;
    FTSC: boolean;
    FMCE: boolean;
    FMMX: boolean;
    FPAT: boolean;
    FPAE: boolean;
    FVME: boolean;
    FPGE: boolean;
    FCMOV: boolean;
    FFPU: boolean;
    FCX8: boolean;
    FSIMD: Boolean;
    FMCA: boolean;
    FAPIC: boolean;
    FDE: boolean;
    FPSE36: boolean;
    FSERIAL: Boolean;
    F3DNOW: boolean;
    FEX3DNOW: Boolean;
    FEXMMX: Boolean;
    FCLFSH: Boolean;
    FACPI: Boolean;
    FSS: Boolean;
    FSIMD2: Boolean;
    FTM: Boolean;
    FDS: Boolean;
    FFXSR: Boolean;
    FHTT: Boolean;
    FModes: TExceptionModes;
    procedure SetMode(const Value: TExceptionModes);
  public
    CPUID: TCPUIDResult;
    constructor Create;
    procedure GetInfo;
    procedure Report(var sl: TStringList; Standalone: Boolean = True); virtual;
    procedure GetFeaturesStr(var sl: TStringList);
  published
    property ExceptionModes: TExceptionModes read FModes Write SetMode;
    property _3DNOW :Boolean read F3DNOW {$IFNDEF D6PLUS} write F3DNOW {$ENDIF} stored False;
    property EX_3DNOW :Boolean read FEX3DNOW {$IFNDEF D6PLUS} write FEX3DNOW {$ENDIF} stored False;
    property EX_MMX :Boolean read FEXMMX {$IFNDEF D6PLUS} write FEXMMX {$ENDIF} stored False;
    property TM :Boolean read FTM {$IFNDEF D6PLUS} write FTM {$ENDIF} stored false;
    property HTT :Boolean read FHTT {$IFNDEF D6PLUS} write FHTT {$ENDIF} stored False;
    property SS :Boolean read FSS {$IFNDEF D6PLUS} write FSS {$ENDIF} stored false;
    property SSE2 :Boolean read FSIMD2 {$IFNDEF D6PLUS} write FSIMD2 {$ENDIF} stored False;
    property SSE :Boolean read FSIMD {$IFNDEF D6PLUS} write FSIMD {$ENDIF} stored False;
    property FXSR :Boolean read FFXSR {$IFNDEF D6PLUS} write FFXSR {$ENDIF} stored false;
    property MMX :Boolean read FMMX {$IFNDEF D6PLUS} write FMMX {$ENDIF} stored false;
    property ACPI :Boolean read FACPI {$IFNDEF D6PLUS} write FACPI {$ENDIF} stored false;
    property DS :Boolean read FDS {$IFNDEF D6PLUS} write FDS {$ENDIF} stored false;
    property CLFSH :Boolean read FCLFSH {$IFNDEF D6PLUS} write FCLFSH {$ENDIF} stored false;
    property PSN :Boolean read FSERIAL {$IFNDEF D6PLUS} write FSERIAL {$ENDIF} stored False;
    property PSE36 :Boolean read FPSE36 {$IFNDEF D6PLUS} write FPSE36 {$ENDIF} stored false;
    property PAT :Boolean read FPAT {$IFNDEF D6PLUS} write FPAT {$ENDIF} stored false;
    property CMOV :Boolean read FCMOV {$IFNDEF D6PLUS} write FCMOV {$ENDIF} stored false;
    property MCA :Boolean read FMCA {$IFNDEF D6PLUS} write FMCA {$ENDIF} stored false;
    property PGE :Boolean read FPGE {$IFNDEF D6PLUS} write FPGE {$ENDIF} stored false;
    property MTRR :Boolean read FMTRR {$IFNDEF D6PLUS} write FMTRR {$ENDIF} stored false;
    property SEP :Boolean read FSEP {$IFNDEF D6PLUS} write FSEP {$ENDIF} stored false;
    property APIC :Boolean read FAPIC {$IFNDEF D6PLUS} write FAPIC {$ENDIF} stored false;
    property CX8 :Boolean read FCX8 {$IFNDEF D6PLUS} write FCX8 {$ENDIF} stored false;
    property MCE :Boolean read FMCE {$IFNDEF D6PLUS} write FMCE {$ENDIF} stored false;
    property PAE :Boolean read FPAE {$IFNDEF D6PLUS} write FPAE {$ENDIF} stored false;
    property MSR :Boolean read FMSR {$IFNDEF D6PLUS} write FMSR {$ENDIF} stored false;
    property TSC :Boolean read FTSC {$IFNDEF D6PLUS} write FTSC {$ENDIF} stored false;
    property PSE :Boolean read FPSE {$IFNDEF D6PLUS} write FPSE {$ENDIF} stored false;
    property DE :Boolean read FDE {$IFNDEF D6PLUS} write FDE {$ENDIF} stored false;
    property VME :Boolean read FVME {$IFNDEF D6PLUS} write FVME {$ENDIF} stored false;
    property FPU :Boolean read FFPU {$IFNDEF D6PLUS} write FFPU {$ENDIF} stored false;
  end;

  TCPUCache = class(TPersistent)
  private
    FFamily: integer;
    FStepping: integer;
    FModel: Integer;
    FVendorID: string;

    FLevel2: LongInt;
    FLevel1: LongInt;
    FLevel1Data: LongInt;
    FLevel1Code: LongInt;
    FDesc: TStrings;
    FLevel3: LongInt;
    FModes: TExceptionModes;
    procedure SetMode(const Value: TExceptionModes);
  public
    IntelCache: TIntelCache;
    AMDCache: TAMDCache;
    CyrixCache: TCyrixCache;
    constructor Create;
    destructor Destroy; override;
    procedure GetInfo(AVendor: DWORD);
    procedure Report(var sl :TStringList; Standalone: Boolean = True); virtual;

    property Descriptions: TStrings read FDesc;
    property L1Data: LongInt read FLevel1Data;
    property L1Code: LongInt read FLevel1Code;
  published
    property ExceptionModes: TExceptionModes read FModes Write SetMode;
    property Level1: LongInt read FLevel1 {$IFNDEF D6PLUS} write FLevel1 {$ENDIF} stored FALSE;
    property Level2: LongInt read FLevel2 {$IFNDEF D6PLUS} write FLevel2 {$ENDIF} stored FALSE;
    property Level3: LongInt read FLevel3 {$IFNDEF D6PLUS} write FLevel3 {$ENDIF} stored FALSE;
  end;

  TCPU = class(TPersistent)
  private
    FFreq :integer;
    FFeatures: TCPUFeatures;
    FVendorReg: string;
    FVendorIDReg: string;
    FCount: integer;
    FFamily: integer;
    FStepping: integer;
    FModel: integer;
    FVendorID: string;
    FTyp: DWORD;
    FLevel: DWORD;
    FCache: TCPUCache;
    FSerial: string;
    FDIV: Boolean;
    FVendorCPUID: string;
    FVendorIDCPUID: string;
    FBrand: DWORD;
    FCPUVendor: DWORD;
    FCodeName: string;
    FVendorEx: string;
    FCPUSig: TCPUIDResult;
    FExtModel: integer;
    FExtFamily: integer;
    FCPUFamily: TCPUFamily;
    FCPUType: TCPUType;
    FExtStep: integer;
    FCPUSigEx: TCPUIDResult;
    FExtLevel: DWORD;
    FPNSReg: string;
    FFreqReg: DWORD;
    FArch: TCPUArchitecture;
    FGetCache, FGetFeat: Boolean;
    FModes: TExceptionModes;
    procedure SetMode(const Value: TExceptionModes);
  public
    constructor Create;
    destructor Destroy; override;
    procedure GetInfo(AGetCache: Boolean = True; AGetFeatures: Boolean = True);
    procedure Report(var sl :TStringList; Standalone: Boolean = True); virtual;

    property RegistryVendor :string read FVendorReg {$IFNDEF D6PLUS} write FVendorReg {$ENDIF} stored false;
    property RegistryVendorID :string read FVendorIDReg {$IFNDEF D6PLUS} write FVendorIDReg {$ENDIF} stored False;
    property RegistryNameString :string read FPNSReg {$IFNDEF D6PLUS} write FPNSReg {$ENDIF} stored False;
    property RegistryFrequency :DWORD read FFreqReg {$IFNDEF D6PLUS} write FFreqReg {$ENDIF} stored False;
    property CPUIDVendor :string read FVendorCPUID {$IFNDEF D6PLUS} write FVendorCPUID {$ENDIF} stored false;
    property CPUIDNameString :string read FVendorIDCPUID {$IFNDEF D6PLUS} write FVendorIDCPUID {$ENDIF} stored False;
    property ExtendedFamily :integer read FExtFamily {$IFNDEF D6PLUS} write FExtFamily {$ENDIF} stored false;
    property ExtendedModel :integer read FExtModel {$IFNDEF D6PLUS} write FExtModel {$ENDIF} stored false;
    property ExtendedStepping :integer read FExtStep {$IFNDEF D6PLUS} write FExtStep {$ENDIF} stored false;
    property Brand: DWORD read FBrand {$IFNDEF D6PLUS} write FBrand {$ENDIF} stored False;
    property Typ: DWORD read FTyp {$IFNDEF D6PLUS} write FTyp {$ENDIF} stored False;
    property MaxFunctionLevel: DWORD read FLevel {$IFNDEF D6PLUS} write FLevel {$ENDIF} stored False;
    property MaxExtendedFunctionLevel: DWORD read FExtLevel {$IFNDEF D6PLUS} write FExtLevel {$ENDIF} stored False;
    property VendorType: DWORD read FCPUVendor {$IFNDEF D6PLUS} write FCPUVendor {$ENDIF} stored False;
    property Signature: TCPUIDResult read FCPUSig {$IFNDEF D6PLUS} write FCPUSig {$ENDIF} stored False;
    property ExtendedSignature: TCPUIDResult read FCPUSigEx {$IFNDEF D6PLUS} write FCPUSigEx {$ENDIF} stored False;
  published
    property ExceptionModes: TExceptionModes read FModes Write SetMode;

    property Count :integer read FCount {$IFNDEF D6PLUS} write FCount {$ENDIF} stored false;
    property Vendor :string read FVendorEx {$IFNDEF D6PLUS} write FVendorEx {$ENDIF} stored False;

    property FriendlyName :string read FVendorID {$IFNDEF D6PLUS} write FVendorID {$ENDIF} stored false;
    property CodeName: string read FCodeName {$IFNDEF D6PLUS} write FCodeName {$ENDIF} stored False;
    property Frequency :integer read FFreq {$IFNDEF D6PLUS} write FFreq {$ENDIF} stored false;

    property Family :integer read FFamily {$IFNDEF D6PLUS} write FFamily {$ENDIF} stored false;
    property Model :integer read FModel {$IFNDEF D6PLUS} write FModel {$ENDIF} stored false;
    property Stepping :integer read FStepping {$IFNDEF D6PLUS} write FStepping {$ENDIF} stored false;
    property Features :TCPUFeatures read FFeatures  {$IFNDEF D6PLUS} write FFeatures {$ENDIF} stored false;
    property Cache: TCPUCache read FCache  {$IFNDEF D6PLUS} write FCache {$ENDIF} stored false;
    property SerialNumber: string read FSerial {$IFNDEF D6PLUS} write FSerial {$ENDIF} stored False;
    property FDIVBug: Boolean read FDIV {$IFNDEF D6PLUS} write FDIV {$ENDIF} stored False;

    property CPUType: TCPUType read FCPUType {$IFNDEF D6PLUS} write FCPUType {$ENDIF} stored False;
    property FamilyType :TCPUFamily read FCPUFamily {$IFNDEF D6PLUS} write FCPUFamily {$ENDIF} stored false;
    property Architecture: TCPUArchitecture read FArch {$IFNDEF D6PLUS} write FArch {$ENDIF} stored False;
  end;

function ExecuteCPUID: TCPUIDResult; assembler;
function GetCPUVendor: DWORD;

var
  CPUID_Level: DWORD;

const
  CPUVendorsEx :array[VENDOR_INTEL..VENDOR_NSC] of string =
				      ('Intel Corporation',
				       'Advanced Micro Devices',
				       'Cyrix Corporation',
				       'IDT/Centaur/VIA',
				       'NexGen Inc.',
				       'United Microelectronics Corp',
				       'Rise Technology',
                                       'Transmeta',
                                       'SiS',
                                       'National Semiconductor');

  CPUVendors :array[VENDOR_INTEL..VENDOR_NSC] of string =
				      ('Intel',
				       'AMD',
				       'Cyrix',
				       'IDT',
				       'NexGen',
				       'UMC',
				       'Rise',
                                       'Transmeta',
                                       'SiS',
                                       'NSC');

  CPUTypes: array[TCPUType] of string = ('Primary','OverDrive', 'Secondary', 'Unknown');

function GetCPUSpeed_M1: TFreqInfo;
function GetCPUSpeed_M2(ADelay: DWORD): Single;
function GetCPUSpeed_M3: Double;
function RoundFrequency(const Frequency: Integer): Integer;

implementation

uses
  Registry, INIFiles, MiTeC_Routines;

const
  CPUVendorIDs :array[VENDOR_INTEL..VENDOR_NSC] of string =
					('GenuineIntel',
					 'AuthenticAMD',
					 'CyrixInstead',
					 'CentaurHauls',
					 'NexGenDriven',
					 'UMC UMC UMC',
					 'RiseRiseRise',
                                         'GenuineTMx86',
                                         'SiS SiS SiS',
                                         'Geode by NSC'
					 );

procedure GetIntelCPUName(AFamily, AExtFam, AModel, ABrand, AL2Cache, AL3Cache: integer; var CPUName, Codename: string);
begin
  case AFamily of
    4: case AModel of
         0,1 :begin CPUName:='i80486DX'; CodeName:='P4'; end;
         2 :begin CPUName:='i80486SX'; CodeName:='P23'; end;
         3 :begin CPUName:='i80486DX2'; CodeName:='P24'; end;
         4 :begin CPUName:='i80486SL'; CodeName:='P23'; end;
         5 :begin CPUName:='i80486SX2'; CodeName:='P23'; end;
         7 :begin CPUName:='i80486DX2WB'; CodeName:='P24'; end;
         8 :begin CPUName:='i80486DX4'; CodeName:='P24C'; end;
         9 :begin CPUName:='i80486DX4WB'; CodeName:='P24C'; end;
    end;
    5: case AModel of
         0 :begin CPUName:='Pentium'; CodeName:='P5 A-Step (0,80µm)'; end;
         1 :begin CPUName:='Pentium'; CodeName:='P5 (0,80µm)'; end;
         2 :begin CPUName:='Pentium'; CodeName:='P54C (0,50µm)'; end;
         3 :begin CPUName:='Pentium'; CodeName:='P24T'; end;
         4 :begin CPUName:='Pentium MMX'; CodeName:='P55C (0,28µm)'; end;
         7 :begin CPUName:='Pentium'; CodeName:='P54C (0,35µm)'; end;
         8 :begin CPUName:='Pentium MMX'; CodeName:='P55C (0,25µm)'; end;
         else begin CPUName:='Pentium'; CodeName:='P5'; end;
    end;
    6: case AModel of
         0 :begin CPUName:='Pentium Pro'; CodeName:='P6 A-step (0.50 µm)'; end;
         1 :begin CPUName:='Pentium Pro'; CodeName:='P6 (0.35 µm)'; end;
         3 :begin CPUName:='Pentium II'; CodeName:='Klamath (0.35 µm)'; end;
         5,6 : begin
            if (AL2Cache=0) then begin CPUName:='Celeron'; Codename:='Covington (0,25µm)'; end;
            if (AL2Cache=128) then begin CPUName:='Celeron A'; Codename:='Mendocino (0,25µm)'; end;
            if (AL2Cache=256) then begin CPUName:='Pentium II PE'; Codename:='Dixon (0,25µm)'; end;
            if (AL2Cache=512) then begin CPUName:='Pentium II'; Codename:='Deschutes (0,25µm)'; end;
            if (AL2Cache>512) then begin CPUName:='Pentium II Xeon'; Codename:='Deschutes (0,25µm)'; end
         end;
         7: begin
            CPUName:='Pentium III'; Codename:='Katmai (0.25 µm)';
            if (AL2Cache>512) then begin CPUName:='Pentium III Xeon'; Codename:='Tanner (0.25 µm)';end;
         end;
         8,$A: case ABrand of
              1: begin CPUName:='Celeron'; Codename:='Coppermine (0.18 µm)'; end;
              2: begin CPUName:='Pentium III'; Codename:='Coppermine (0.18 µm)'; end;
              3: begin CPUName:='Pentium III Xeon'; Codename:='Cascades (0.18 µm)'; end;
            end;
         $9, $16: case ABrand of
              7: begin CPUName:='Mbile Celeron'; Codename:='Tualatin (0.13 µm Celeron M)'; end;
              6: begin CPUName:='Mobile Pentium'; Codename:='Tualatin (0.13 µm Pentium M) '; end;
              $12: begin CPUName:='Celeron M'; Codename:='Banias (0.13 µm Celeron M)'; end;
              $16: begin CPUName:='Pentium M'; Codename:='Banias (0.13 µm Pentium M)'; end;
            end;
         $B: case ABrand of
              3: begin CPUName:='Celeron'; Codename:='Tualatin (0.13 µm)'; end;
              4: begin CPUName:='Pentium III'; Codename:='Tualatin (0.13 µm)'; end;
              7: begin CPUName:='Celeron (mobile)'; Codename:='Tualatin (0.13 µm)'; end;
              6: begin CPUName:='Pentium III (mobile)'; Codename:='Tualatin (0.13 µm)'; end;
             end;
       end;
    7: begin CPUName:='Itanium'; Codename:=''; end;
    $A: begin CPUName:='Pentium III Xeon'; Codename:='Cascades';end;
    $F: if AExtFam=1 then
          begin CPUName:='Itanium 2'; Codename:=''; end
        else begin
          case AModel of
            0,1: begin
              case ABrand of
                $A: begin CPUName:='Celeron 4'; Codename:='Willamette (0.18 µm)'; end;
                $8,$9: begin CPUName:='Pentium 4'; Codename:='Willamette (0.18 µm)'; end;
                $E: begin CPUName:='Pentium 4 Xeon'; Codename:='Foster (0.18 µm)'; end;
                $B: begin CPUName:='Pentium 4 Xeon MP'; Codename:='Foster (0.18 µm)'; end;
              end;
              if AL3Cache>0 then
                Codename:='Foster MP (0.18 µm)';
            end;
            2: begin
              case ABrand of
                $8: begin CPUName:='Celeron 4 mobile'; Codename:='Northwood (0.13 µm)'; end;
                $9: begin CPUName:='Pentium 4'; Codename:='Northwood (0.13 µm)'; end;
                $A: begin CPUName:='Celeron 4'; Codename:='Northwood (0.13 µm)'; end;
                $B: begin CPUName:='Pentium 4 Xeon'; Codename:='Prestonia (0.13 µm)'; end;
                $C: begin CPUName:='Pentium 4 Xeon MP'; Codename:='Prestonia (0.13 µm)'; end;
                $E: begin CPUName:='Pentium 4 mobile (production)'; Codename:='Northwood (0.13 µm)'; end;
                $F: begin CPUName:='Pentium 4 mobile (samples)'; Codename:='Northwood (0.13 µm)'; end;
                $12: begin CPUName:='Celeron M'; Codename:='Banias (0.13 µm Celeron M)'; end;
                $16: begin CPUName:='Pentium M'; Codename:='Banias (0.13 µm Pentium M)'; end;
              end;
              if AL3Cache>0 then
                Codename:='Gallatin (0.13 µm)';
            end;
            3: begin
              case ABrand of
                $8: begin CPUName:='Celeron 4 mobile'; Codename:='Prescott (0.09 µm)'; end;
                $9: begin CPUName:='Pentium 4'; Codename:='Prescott (0.09 µm)'; end;
                $C: begin CPUName:='Pentium 4 Xeon MP'; Codename:='Nocona (0.09 µm)'; end;
                $B: begin CPUName:='Pentium 4 Xeon'; Codename:='Nocona (0.09 µm)'; end;
                $E: begin CPUName:='Pentium 4 mobile (production)'; Codename:='Prescott (0.09 µm)'; end;
                $F: begin CPUName:='Pentium 4 mobile (samples)'; Codename:='Prescott (0.09 µm)'; end;
                $12: begin CPUName:='Celeron M'; Codename:='Dothan (0.09 µm Celeron M)'; end;
                $16: begin CPUName:='Pentium M'; Codename:='Dothan (0.09 µm Pentium M)'; end;
              end;
              if AL3Cache>0 then
                Codename:='Potomac (0.09 µm)';
            end;
          end;
        end;
  end;
end;

procedure GetAMDCPUName(AFamily, AModel, ABrand, AL2Cache: integer; var CPUName, Codename: string);
begin
  case AFamily of
    4: case AModel of
         0: begin CPUName:='Am486DX'; Codename:='P4'; end;
         3,7 :begin CPUName:='Am486DX2'; Codename:='P24'; end;
         8,9 :begin CPUName:='Am486DX4'; Codename:='P24C'; end;
         14,15 :begin CPUName:='Am5x86'; Codename:='X5'; end;
       end;
    5: case AModel of
         0: begin CPUName:='K5'; Codename:='SSA5 (0.50-0.35 µm)'; end;
         1,2,3: begin CPUName:='K5-5k86 (PR120, PR133)'; Codename:='5k86 (0.35 µm)'; end;
         6: begin CPUName:='K6'; Codename:='K6 (0.30 µm)'; end;
         7: begin CPUName:='K6'; Codename:='Little Foot (0.25 µm)'; end;
         8: begin CPUName:='K6-II'; Codename:='Chomper (0.25 µm)'; end;
         9: begin CPUName:='K6-III'; Codename:='Sharptooth (0.25 µm)'; end;
         $D: begin CPUName:='K6-II+/K6-III+'; Codename:=''; end;
       end;
    6: case AModel of
         1: begin CPUName:='Athlon'; Codename:='K7 (0.25 µm)'; end;
         2: begin CPUName:='Athlon'; Codename:='K75 (0.18 µm)'; end;
         3: begin CPUName:='Duron'; Codename:='Spitfire (0.18 µm)'; end;
         4: begin CPUName:='Athlon'; Codename:='Thunderbird (0.18 µm)'; end;
         6: begin CPUName:='Athlon XP'; Codename:='Palomino (0.18 µm)'; end;
         7: begin CPUName:='Duron'; Codename:='Morgan (0.18 µm)'; end;
         8: begin CPUName:='Athlon'; Codename:='Thoroughbred (0.13 µm)' end;
         $A: begin CPUName:='Athlon'; Codename:='Barton (0.13 µm)'; end;
       end;
    7: case AModel of
         4,7,8,$B,$C,$F: begin
              CPUName:='Athlon 64'; Codename:='Clawhammer (0.13 µm)';
              case ABrand shr 5 of
                1: begin CPUName:='Athlon 64'; Codename:='Hammer (0.13 µm)'; end;
                9: CPUName:='Athlon 64 FX';
              end;
            end;
         5: begin
              CPUName:='Opteron'; Codename:='Sledgehammer (0.13 µm)';
              case ABrand shr 5 of
                3: CPUName:=CPUName+Format(' UP1%d',[38+2*(swap(ABrand shl 3) shr 11)]);
                4: CPUName:=CPUName+Format(' DP2%d',[38+2*(swap(ABrand shl 3) shr 11)]);
                5: CPUName:=CPUName+Format(' MP8%d',[38+2*(swap(ABrand shl 3) shr 11)]);
              end;
            end;
       end;

  end;
end;

procedure GetCyrixCPUName(AFamily, AModel, AFreq: integer; var CPUName, Codename: string);
begin
  case AFamily of
    4: case AModel of
         0: begin
              if AFreq in [20,66] then begin CPUName:='Cx486SLC/DLC'; Codename:='M0.5'; end;
  	      if AFreq in [33,50] then begin CPUName:='Cx486S'; Codename:='M0.6'; end;
              if AFreq>66 then begin CPUName:='Cx486DX/DX2/DX4'; Codename:='M0.7'; end;
	    end;
	 4: begin CPUName:='Media GX'; Codename:='Gx86'; end;
         9: begin CPUName:='5x86'; Codename:='M0.9 or M1sc (0.65 µm)'; end;
       end;
    5: case AModel of
         2 :begin CPUName:='6x86 and 6x86L'; Codename:='M1 (0.65 µm) and M1L (0.35 µm)'; end;
         4 :begin CPUName:='MediaGXm'; Codename:='GXm'; end;
       end;
    6: case AModel of
         0: if AFreq<225 then begin CPUName:='6x86MX (PR166-266)'; Codename:='M2 (0.35 µm)'; end
            else begin CPUName:='M-II (PR300-433)'; Codename:='M2 (0.35-0.25 µm)'; end;
         5: begin CPUName:='VIA Cyrix III'; Codename:='Joshua'; end;
       end;
  end;
end;

procedure GetIDTCPUName(AFamily, AModel, AStep: integer; var CPUName, Codename: string);
begin
  case AFamily of
    5: case AModel of
         4: begin CPUName:='WinChip'; Codename:='C6 (0.35 µm)'; end;
         8: begin CPUName:='WinChip 2x'; Codename:='W2x (0.35-0.25 µm)'; end;
         9: begin CPUName:='WinChip 3'; Codename:='W3 (0.25 µm)'; end;
       end;
    6: case AModel of
         6: begin CPUName:='VIA C3'; Codename:='C5A Samuel 1 (0.18µm)'; end;
         7: begin CPUName:='VIA C3'; if AStep<8 then Codename:='C5B Samuel 2 (0.13µm)' else Codename:='C5C Ezra (0.13µm)'; end;
         8: begin CPUName:='VIA C3'; Codename:='C5N Ezra-T (0.13µm)'; end;
         9: begin CPUName:='VIA C3'; Codename:='C5XL Nehemiah (0.13µm)'; end;
       end;
  end;
end;

procedure GetNexGenCPUName(AFamily, AModel: integer; var CPUName, Codename: string);
begin
  case AFamily of
    5: case AModel of
         0: begin CPUName:='Nx586'; Codename:='Nx5x86 (0.50-0.44 µm)'; end;
         6: begin CPUName:='Nx686'; Codename:='HA (0,50µm)'; end;
       end;
  end;
end;

procedure GetUMCCPUName(AFamily, AModel: integer; var CPUName, Codename: string);
begin
  case AFamily of
    4: case AModel of
         1: begin CPUName:='U5D'; Codename:=''; end;
         2: begin CPUName:='U5S'; Codename:=''; end;
         3: begin CPUName:='U486DX2'; Codename:=''; end;
         4: begin CPUName:='U486SX2'; Codename:=''; end;
	end;
  end;
end;

procedure GetRiseCPUName(AFamily, AModel: integer; var CPUName, Codename: string);
begin
  case AFamily of
    5: case AModel of
         0: begin CPUName:='mP6'; Codename:='iDragon'; end;
         2: begin CPUName:='mP6'; Codename:='iDragon 0.18µm'; end;
         8: begin CPUName:='mP6'; Codename:='iDragon II 0.25µm'; end;
         9: begin CPUName:='mP6'; Codename:='iDragon II 0.18µm'; end;
       end;
  end;
end;

procedure GetTransmetaCPUName(AFamily, AModel, AL2Cache: integer; var CPUName, Codename: string);
begin
  case AFamily of
    5: begin
      CPUName:='Crusoe';
      case AL2Cache of
        0: Codename:='TM3200';
        256: Codename:='TM5400/TM5500';
        512: Codename:='TM5600/TM5800';
      end;
    end;
    6: begin
      CPUName:='Efficeon';
      case AL2Cache of
        512: Codename:='TM8300/TM8500';
        1024: Codename:='TM8600/TM8800';
      end;
    end;
  end;
end;

procedure GetSiSCPUName(AFamily, AModel: integer; var CPUName, Codename: string);
begin
  case AFamily of
    5: case AModel of
      0: begin CPUName:='SiS 55x'; Codename:=''; end;
    end;
  end;
end;

procedure GetNSCCPUName(AFamily, AModel: integer; var CPUName, Codename: string);
begin
  CPUName:='NSC'; Codename:='';
end;

procedure GetCPUName(AVendor, AFamily, AExtFam, AModel, AStep, ABrand, AL2Cache, AL3Cache, AFreq: integer; OUT CPUName, Codename: string);
begin
  case AVendor of
    VENDOR_INTEL: GetIntelCPUName(AFamily,AExtFam,AModel,ABrand,AL2Cache,AL3Cache,CPUName,Codename);
    VENDOR_AMD: GetAMDCPUName(AFamily,AModel,ABrand,AL2Cache,CPUName,Codename);
    VENDOR_CYRIX: GetCyrixCPUName(AFamily,AModel,AFreq,CPUName,Codename);
    VENDOR_IDT: GetIDTCPUName(AFamily,AModel,AStep,CPUName,Codename);
    VENDOR_NEXGEN: GetNexGenCPUName(AFamily,AModel,CPUName,Codename);
    VENDOR_UMC: GetUMCCPUName(AFamily,AModel,CPUName,Codename);
    VENDOR_RISE: GetRiseCPUName(AFamily,AModel,CPUName,Codename);
    VENDOR_TM: GetTransmetaCPUName(AFamily,AModel,AL2Cache,CPUName,Codename);
    VENDOR_SIS: GetSiSCPUName(AFamily,AModel,CPUName,Codename);
    VENDOR_NSC: GetNSCCPUName(AFamily,AModel,CPUName,Codename);
  end;
end;

function GetCPUIDSupport: Boolean;
asm
    PUSHFD
    POP     EAX
    MOV     EDX, EAX
    XOR     EAX, CPUIDID_BIT
    PUSH    EAX
    POPFD
    PUSHFD
    POP     EAX
    XOR     EAX, EDX
    JZ	    @exit
    MOV     AL, TRUE
  @exit:
end;

function ExecuteCPUID: TCPUIDResult; assembler;
asm
    PUSH    EBX
    PUSH    EDI
    MOV     EDI, EAX
    MOV     EAX, CPUID_LEVEL
    DW	    $A20F
    STOSD
    MOV     EAX, EBX
    STOSD
    MOV     EAX, ECX
    STOSD
    MOV     EAX, EDX
    STOSD
    POP     EDI
    POP     EBX
end;

function ExecuteIntelCache: TIntelCache;
var
  Cache: TIntelCache;
  TimesToExecute, CurrentLoop: Byte;
begin
  asm
    PUSH    EAX
    PUSH    EBP
    PUSH    EBX
    PUSH    ECX
    PUSH    EDI
    PUSH    EDX
    PUSH    ESI

    MOV     CurrentLoop, 0
    PUSH    ECX
  @@RepeatCacheQuery:
    POP     ECX
    MOV     EAX, CPUID_CACHETLB
    DB	    0FH
    DB	    0A2H
    INC     CurrentLoop
    CMP     CurrentLoop, 1
    JNE     @@DoneCacheQuery
    MOV     TimesToExecute, AL
    CMP     AL, 0
    JE	    @@Done
  @@DoneCacheQuery:
    PUSH    ECX
    MOV     CL, CurrentLoop
    SUB     CL, TimesToExecute
    JNZ     @@RepeatCacheQuery
    POP     ECX
    MOV     DWORD PTR [Cache], EAX
    MOV     DWORD PTR [Cache + 4], EBX
    MOV     DWORD PTR [Cache + 8], ECX
    MOV     DWORD PTR [Cache + 12], EDX
    JMP     @@Done
   @@Done:

    POP     ESI
    POP     EDX
    POP     EDI
    POP     ECX
    POP     EBX
    POP     EBP
    POP     EAX
  end;
  Result:=Cache;
end;

function ExecuteAMDCache: TAMDCache;
var
  Cache: TAMDCache;
begin
  asm
    PUSH    EAX
    PUSH    EBP
    PUSH    EBX
    PUSH    ECX
    PUSH    EDI
    PUSH    EDX
    PUSH    ESI

    MOV     EAX, CPUID_LEVEL1CACHETLB
    DB	    0Fh
    DB	    0A2h
    MOV     WORD PTR [Cache.L12MInstructionTLB], AX
    SHR     EAX, 16
    MOV     WORD PTR [Cache.L12MDataTLB], AX
    MOV     WORD PTR [Cache.L14KInstructionTLB], BX
    SHR     EBX, 16
    MOV     WORD PTR [Cache.L14KDataTLB], BX
    MOV     DWORD PTR [Cache.L1DataCache], ECX
    MOV     DWORD PTR [Cache.L1ICache], EDX

    MOV     EAX, CPUID_LEVEL2CACHETLB
    DB	    0Fh
    DB	    0A2h
    MOV     WORD PTR [Cache.L22MInstructionTLB], AX
    SHR     EAX, 16
    MOV     WORD PTR [Cache.L22MDataTLB], AX
    MOV     WORD PTR [Cache.L24KInstructionTLB], BX
    SHR     EBX, 16
    MOV     WORD PTR [Cache.L24KDataTLB], BX
    MOV     DWORD PTR [Cache.Level2Cache], ECX

    POP     ESI
    POP     EDX
    POP     EDI
    POP     ECX
    POP     EBX
    POP     EBP
    POP     EAX
  end;
  Result:=Cache;
end;

function ExecuteCyrixCache: TCyrixCache;
var
  Cache: TCyrixCache;
begin
  asm
    PUSH    EAX
    PUSH    EBP
    PUSH    EBX
    PUSH    ECX
    PUSH    EDI
    PUSH    EDX
    PUSH    ESI

    MOV     EAX, CPUID_LEVEL1CACHETLB
    DB	    0Fh
    DB	    0A2h
    MOV     DWORD PTR [Cache.TLBInfo], EBX
    MOV     DWORD PTR [Cache.L1CacheInfo], ECX

    POP     ESI
    POP     EDX
    POP     EDI
    POP     ECX
    POP     EBX
    POP     EBP
    POP     EAX
  end;
  Result:=Cache;
end;

function GetCPUSerialNumber: String;

  function SplitToNibble(ANumber: String): String;
  begin
    Result:=Copy(ANumber,0,4)+'-'+Copy(ANumber,5,4);
  end;

var
  SerialNumber: TCPUIDResult;
begin
  Result:='';
  CPUID_Level:=CPUID_CPUSIGNATURE;
  SerialNumber:=ExecuteCPUID;
  Result:=SplitToNibble(IntToHex(SerialNumber.EAX,8))+'-';
  CPUID_Level:=CPUID_CPUSIGNATURE;
  SerialNumber:=ExecuteCPUID;
  Result:=Result+SplitToNibble(IntToHex(SerialNumber.EDX,8))+'-';
  Result:=Result+SplitToNibble(IntToHex(SerialNumber.ECX,8));
end;

function RoundFrequency(const Frequency: Integer): Integer;
const
  NF: array [0..9] of Integer = (0, 20, 33, 50, 60, 66, 80, 90, 100, 133);
var
  Freq, RF: Integer;
  i: Byte;
  Hi, Lo: Byte;
begin
  RF:=0;
  Freq:=Frequency mod 100;
  for i:=0 to High(NF) do begin
    if Freq<NF[i] then begin
      Hi:=i;
      Lo:=i-1;
      if (NF[Hi]-Freq)>(Freq-NF[Lo]) then
	RF:=NF[Lo]-Freq
      else
	RF:=NF[Hi]-Freq;
      Break;
    end;
  end;
  Result:=Frequency+RF;
end;

function GetCPUSpeed_M3: Double;
const
  DelayTime = 100;
var
  TimerHi, TimerLo: DWORD;
  PriorityClass, Priority: Integer;
begin
  PriorityClass:=GetPriorityClass(GetCurrentProcess);
  Priority:=GetThreadPriority(GetCurrentThread);
  SetPriorityClass(GetCurrentProcess, REALTIME_PRIORITY_CLASS);
  SetThreadPriority(GetCurrentThread, THREAD_PRIORITY_TIME_CRITICAL);
  Sleep(10);
  asm
    dw 310Fh
    mov TimerLo, eax
    mov TimerHi, edx
  end;
  Sleep(DelayTime);
  asm
    dw 310Fh
    sub eax, TimerLo
    sbb edx, TimerHi
    mov TimerLo, eax
    mov TimerHi, edx
  end;
  SetThreadPriority(GetCurrentThread, Priority);
  SetPriorityClass(GetCurrentProcess, PriorityClass);
  Result:=TimerLo/(1000.0*DelayTime);
end;

function GetCPUSpeed_M2(ADelay: DWORD): Single;
var
  t: DWORD;
  mhi, mlo, nhi, nlo: LongInt;
  t0, t1, chi, clo, shr32: Comp;
  PriorityClass, Priority: Integer;
begin
  shr32 := 65536;
  shr32 := shr32 * 65536;
  PriorityClass := GetPriorityClass(GetCurrentProcess);
  Priority := GetThreadPriority(GetCurrentThread);
  SetPriorityClass(GetCurrentProcess, REALTIME_PRIORITY_CLASS);
  SetThreadPriority(GetCurrentThread, THREAD_PRIORITY_TIME_CRITICAL);
  t := GetTickCount;
  while (t = GetTickCount) do begin end;
      asm
        DB 	  0FH
        DB 	  031H
        mov   mhi, EDX
        mov   mlo, EAX
      end;

  while (GetTickCount < (t + ADelay)) do begin end;
      asm
        DB 	  0FH
        DB 	  031H
        mov   nhi, EDX
        mov   nlo, EAX
      end;

      SetThreadPriority(GetCurrentThread, Priority);
      SetPriorityClass(GetCurrentProcess, PriorityClass);

      chi := mhi; if (mhi < 0) then chi := chi + shr32;
      clo := mlo; if (mlo < 0) then clo := clo + shr32;

      t0 := chi * shr32 + clo;

      chi := nhi; if (nhi < 0) then chi := chi + shr32;
      clo := nlo; if (nlo < 0) then clo := clo + shr32;

      t1 := chi * shr32 + clo;

      Result := ((t1 - t0) / (1E6 / (1000/ADelay)));


  end;

function GetCPUSpeed_M1: TFreqInfo;
var
  T0, T1: TULargeInteger;
  CountFreq: TULargeInteger;
  CpuSpeed: TFreqInfo;
  Freq, Freq2, Freq3, Total: Integer;
  TotalCycles, Cycles: Cardinal;
  Stamp0, Stamp1: Cardinal;
  TotalTicks, Ticks: Cardinal;
  Tries, IPriority: Integer;
  hThread: THandle;
begin
  Freq:=0;
  Freq2:=0;
  Freq3:=0;
  Tries:=0;
  TotalCycles:=0;
  TotalTicks:=0;
  Total:=0;

  hThread:=GetCurrentThread;
  if not QueryPerformanceFrequency(Int64(CountFreq)) then
  begin
    Result:=CpuSpeed;
  end else begin
    while ((Tries<3) or ((Tries<20) and ((Abs(3*Freq-Total)>3) or
	  (Abs(3*Freq2-Total)>3) or (Abs(3*Freq3-Total)>3)))) do begin
      Inc(Tries);
      Freq3:=Freq2;
      Freq2:=Freq;
      QueryPerformanceCounter(Int64(T0));
      T1.LowPart:=T0.LowPart;
      T1.HighPart:=T0.HighPart;

      iPriority:=GetThreadPriority(hThread);
      if iPriority<>THREAD_PRIORITY_ERROR_RETURN then
	SetThreadPriority(hThread, THREAD_PRIORITY_TIME_CRITICAL);
      while (T1.LowPart-T0.LowPart)<50 do begin
	QueryPerformanceCounter(Int64(T1));
	asm
	  PUSH	  EAX
	  PUSH	  EDX
	  DB	  0Fh		  // Read Time
	  DB	  31h		  // Stamp Counter
	  MOV	  Stamp0, EAX
	  POP	  EDX
	  POP	  EAX
	end;
      end;
      T0.LowPart:=T1.LowPart;
      T0.HighPart:=T1.HighPart;

      while (T1.LowPart-T0.LowPart)<1000 do begin
	QueryPerformanceCounter(Int64(T1));
	asm
	  PUSH	  EAX
	  PUSH	  EDX
	  DB	  0Fh		  // Read Time
	  DB	  31h		  // Stamp Counter
	  MOV	  Stamp1, EAX
	  POP	  EDX
	  POP	  EAX
	end;
      end;

      if iPriority<>THREAD_PRIORITY_ERROR_RETURN then
	SetThreadPriority(hThread, iPriority);

      Cycles:=Stamp1-Stamp0;
      Ticks:=T1.LowPart-T0.LowPart;
      Ticks:=Ticks*100000;
      if CountFreq.LowPart>0 then
        Ticks:=Round(Ticks/(CountFreq.LowPart/10))
      else
        Ticks:=0;
      TotalTicks:=TotalTicks+Ticks;
      TotalCycles:=TotalCycles+Cycles;

      if Ticks=0 then
        Freq:=Cycles
      else
        Freq:=Round(Cycles/Ticks);

      Total:=Freq+Freq2+Freq3;
    end;
    if TotalTicks>0 then begin
      Freq3:=Round((TotalCycles*10)/TotalTicks);
      Freq2:=Round((TotalCycles*100)/TotalTicks);
      CpuSpeed.RawFreq:=Round(TotalCycles/TotalTicks);
    end else begin
      Freq3:=0;
      Freq2:=0;
      CpuSpeed.RawFreq:=0;
    end;

    if Freq2-(Freq3*10)>=6 then
      Inc(Freq3);

    CpuSpeed.NormFreq:=CpuSpeed.RawFreq;

    Freq:=CpuSpeed.RawFreq*10;
    if (Freq3-Freq)>=6 then
      Inc(CpuSpeed.NormFreq);

    CpuSpeed.ExTicks:=TotalTicks;
    CpuSpeed.InCycles:=TotalCycles;

    CpuSpeed.NormFreq:=RoundFrequency(CpuSpeed.NormFreq);
    Result:=CpuSpeed;
  end;
end;

function GetVendor: string;
var
  CPUName: array [0..11] of Char;
begin
  try
    asm
	PUSH	EAX
	PUSH	EBP
	PUSH	EBX
	PUSH	ECX
	PUSH	EDI
	PUSH	EDX
	PUSH	ESI

	MOV	EAX, CPUID_VENDORSIGNATURE
	DB	0FH
	DB	0A2H

	MOV	DWORD PTR [CPUName], EBX
	MOV	DWORD PTR [CPUName + 4], EDX
	MOV	DWORD PTR [CPUName + 8], ECX

	POP	ESI
	POP	EDX
	POP	EDI
	POP	ECX
	POP	EBX
	POP	EBP
	POP	EAX

    end;
    Result:=CPUName;
  except
    Result:='';
  end;
end;

function GetVendorID: string;
var
  CPUName: array [0..47] of Char;
begin
  asm
	PUSH	EAX
	PUSH	EBP
	PUSH	EBX
	PUSH	ECX
	PUSH	EDI
	PUSH	EDX
	PUSH	ESI

	MOV	EAX, CPUID_CPUMARKETNAME1
	DW	$A20F

	MOV	DWORD PTR [CPUName], EAX
	MOV	DWORD PTR [CPUName + 4], EBX
	MOV	DWORD PTR [CPUName + 8], ECX
	MOV	DWORD PTR [CPUName + 12], EDX

	MOV	EAX, CPUID_CPUMARKETNAME2
	DW	$A20F

	MOV	DWORD PTR [CPUName + 16], EAX
	MOV	DWORD PTR [CPUName + 20], EBX
	MOV	DWORD PTR [CPUName + 24], ECX
	MOV	DWORD PTR [CPUName + 28], EDX

	MOV	EAX, CPUID_CPUMARKETNAME3
	DW	$A20F

	MOV	DWORD PTR [CPUName + 32], EAX
	MOV	DWORD PTR [CPUName + 36], EBX
	MOV	DWORD PTR [CPUName + 40], ECX
	MOV	DWORD PTR [CPUName + 44], EDX

	POP	ESI
	POP	EDX
	POP	EDI
	POP	ECX
	POP	EBX
	POP	EBP
	POP	EAX

  end;
  Result:=CPUName;
end;

function GetFDIVBugPresent: Boolean;
const
  N1: Real = 4195835.0;
  N2: Real = 3145727.0;
begin
  Result:=((((N1/N2)*N2)-N1)<>0.0);
end;

function GetCPUVendor;
var
  s: string;
  i: DWORD;
begin
  s:=GetVendor;
  Result:=VENDOR_UNKNOWN;
  for i:=VENDOR_INTEL to VENDOR_TM do
    if SameText(CPUVendorIDs[i],s) then begin
      Result:=i;
      Break;
    end;
end;


{ TCPUFeatures }

constructor TCPUFeatures.Create;
begin
  ExceptionModes:=[emExceptionStack];
end;

procedure TCPUFeatures.GetFeaturesStr(var sl: TStringList);
begin
  with sl do begin
    Add(Format('Built-In FPU=%d',[integer(FPU)]));
    Add(Format('Virtual Mode Extension=%d',[integer(VME)]));
    Add(Format('Debugging Extension=%d',[integer(DE)]));
    Add(Format('Page Size Extension=%d',[integer(PSE)]));
    Add(Format('Time Stamp Counter=%d',[integer(TSC)]));
    Add(Format('Model Specific Registers=%d',[integer(MSR)]));
    Add(Format('Physical Address Extension=%d',[integer(PAE)]));
    Add(Format('Machine Check Exception=%d',[integer(MCE)]));
    Add(Format('CMPXCHG8B Instruction Supported=%d',[integer(CX8)]));
    Add(Format('On-chip APIC Hardware Supported=%d',[integer(APIC)]));
    Add(Format('Fast System Call=%d',[integer(SEP)]));
    Add(Format('Memory Type Range Registers=%d',[integer(MTRR)]));
    Add(Format('Page Global Extension=%d',[integer(PGE)]));
    Add(Format('Machine Check Architecture=%d',[integer(MCA)]));
    Add(Format('Conditional Move Instruction Supported=%d',[integer(CMOV)]));
    Add(Format('Page Attribute Table=%d',[integer(PAT)]));
    Add(Format('36bit Page Size Extension=%d',[integer(PSE36)]));
    Add(Format('Processor serial number is present and enabled=%d',[integer(PSN)]));
    Add(Format('CLFLUSH Instruction Supported=%d',[integer(CLFSH)]));
    Add(Format('Debug Store=%d',[integer(DS)]));
    Add(Format('Thermal Monitor and Software Controlled Clock Facilities (ACPI)=%d',[integer(ACPI)]));
    Add(Format('Intel Architecture MMX technology supported=%d',[integer(MMX)]));
    Add(Format('Fast floating point save and restore=%d',[integer(FXSR)]));
    Add(Format('Streaming SIMD Extensions=%d',[integer(SSE)]));
    Add(Format('Streaming SIMD Extensions 2=%d',[integer(SSE2)]));
    Add(Format('Self-Snoop=%d',[integer(SS)]));
    Add(Format('Hyper-Threading Technology=%d',[Integer(HTT)]));
    Add(Format('Thermal Monitor supported=%d',[integer(TM)]));

    Add(Format('3D Now! Extensions=%d',[integer(_3DNOW)]));
    Add(Format('Enhanced 3D Now! Extensions=%d',[integer(EX_3DNOW)]));
    Add(Format('Enhanced MMX Extensions=%d',[integer(EX_MMX)]));
  end;
end;

procedure TCPUFeatures.GetInfo;
begin
  {$IFDEF ERROR_INTERCEPT}PushTrace(FModes,Self,'GetInfo'); {$ENDIF}

  CPUID_Level:=CPUID_CPUSIGNATUREEX;
  CPUID:=ExecuteCPUID;
  FEXMMX:=((CPUID.EDX and (1 shl EFS_EXMMXA))<>0) or ((CPUID.EDX and (1 shl EFS_EXMMXC))<>0);
  FEX3DNOW:=((CPUID.EDX and (1 shl EFS_EX3DNOW))<>0);
  F3DNOW:=((CPUID.EDX and (1 shl EFS_3DNOW))<>0);

  CPUID_Level:=CPUID_CPUFEATURESET;
  CPUID:=ExecuteCPUID;
  FDS:=((CPUID.EDX and (1 shl SFS_DS))<>0);
  FCLFSH:=((CPUID.EDX and (1 shl SFS_CLFSH))<>0);
  FHTT:=((CPUID.EDX and (1 shl SFS_HTT))<>0);
  FSS:=((CPUID.EDX and (1 shl SFS_SS))<>0);
  FTM:=((CPUID.EDX and (1 shl SFS_TM))<>0);
  FACPI:=((CPUID.EDX and (1 shl SFS_ACPI))<>0);
  FSIMD2:=((CPUID.EDX and (1 shl SFS_SSE2))<>0);
  FSIMD:=((CPUID.EDX and (1 shl SFS_SSE))<>0);
  FFXSR:=((CPUID.EDX and (1 shl SFS_FXSR))<>0);
  FMMX:=((CPUID.EDX and (1 shl SFS_MMX))<>0);
  FSERIAL:=((CPUID.EDX and (1 shl SFS_PSN))<>0);
  FPSE36:=((CPUID.EDX and (1 shl SFS_PSE36))<>0);
  FPAT:=((CPUID.EDX and (1 shl SFS_PAT))<>0);
  FCMOV:=((CPUID.EDX and (1 shl SFS_CMOV))<>0);
  FMCA:=((CPUID.EDX and (1 shl SFS_MCA))<>0);
  FPGE:=((CPUID.EDX and (1 shl SFS_PGE))<>0);
  FMTRR:=((CPUID.EDX and (1 shl SFS_MTRR))<>0);
  FSEP:=((CPUID.EDX and (1 shl SFS_SEP))<>0);
  FAPIC:=((CPUID.EDX and (1 shl SFS_APIC))<>0);
  FCX8:=((CPUID.EDX and (1 shl SFS_CX8))<>0);
  FMCE:=((CPUID.EDX and (1 shl SFS_MCE))<>0);
  FPAE:=((CPUID.EDX and (1 shl SFS_PAE))<>0);
  FMSR:=((CPUID.EDX and (1 shl SFS_MSR))<>0);
  FTSC:=((CPUID.EDX and (1 shl SFS_TSC))<>0);
  FPSE:=((CPUID.EDX and (1 shl SFS_PSE))<>0);
  FDE:=((CPUID.EDX and (1 shl SFS_DE))<>0);
  FVME:=((CPUID.EDX and (1 shl SFS_VME))<>0);
  FFPU:=((CPUID.EDX and (1 shl SFS_FPU))<>0);

  {$IFDEF ERROR_INTERCEPT}PopTrace;{$ENDIF}
end;

procedure TCPUFeatures.Report;
begin
  {$IFDEF ERROR_INTERCEPT}PushTrace(FModes,Self,'Report'); {$ENDIF}
  with sl do begin
    if Standalone then ReportHeader(sl);
    Add('<CPUFeatures classname="TCPUFeatures">');

    Add(Format('<data name="BuiltInFPU" type="boolean" source="CPUID">%d</data>',[Integer(FPU)]));
    Add(Format('<data name="VirtualModeExtension" type="boolean" source="CPUID">%d</data>',[Integer(VME)]));
    Add(Format('<data name="DebuggingExtension" type="boolean" source="CPUID">%d</data>',[Integer(DE)]));
    Add(Format('<data name="PageSizeExtension" type="boolean" source="CPUID">%d</data>',[Integer(PSE)]));
    Add(Format('<data name="TimeStampCounter" type="boolean" source="CPUID">%d</data>',[Integer(TSC)]));
    Add(Format('<data name="ModelSpecificRegisters" type="boolean" source="CPUID">%d</data>',[Integer(MSR)]));
    Add(Format('<data name="PhysicalAddressExtension" type="boolean" source="CPUID">%d</data>',[Integer(PAE)]));
    Add(Format('<data name="MachineCheckException" type="boolean" source="CPUID">%d</data>',[Integer(MCE)]));
    Add(Format('<data name="CMPXCHG8BInstruction" type="boolean" source="CPUID">%d</data>',[Integer(CX8)]));
    Add(Format('<data name="OnChipAPICHardware" type="boolean" source="CPUID">%d</data>',[Integer(APIC)]));
    Add(Format('<data name="FastSystemCall" type="boolean" source="CPUID">%d</data>',[Integer(SEP)]));
    Add(Format('<data name="MemoryTypeRangeRegisters" type="boolean" source="CPUID">%d</data>',[Integer(MTRR)]));
    Add(Format('<data name="PageGlobalExtension" type="boolean" source="CPUID">%d</data>',[Integer(PGE)]));
    Add(Format('<data name="MachineCheckArchitecture" type="boolean" source="CPUID">%d</data>',[Integer(MCA)]));
    Add(Format('<data name="ConditionalMoveInstruction" type="boolean" source="CPUID">%d</data>',[Integer(CMOV)]));
    Add(Format('<data name="PageAttributeTable" type="boolean" source="CPUID">%d</data>',[Integer(PAT)]));
    Add(Format('<data name="PageSizeExtension36bit" type="boolean" source="CPUID">%d</data>',[Integer(PSE36)]));
    Add(Format('<data name="SerialNumber" type="boolean" source="CPUID">%d</data>',[Integer(PSN)]));
    Add(Format('<data name="CLFLUSHInstruction" type="boolean" source="CPUID">%d</data>',[Integer(CLFSH)]));
    Add(Format('<data name="DebugStore" type="boolean" source="CPUID">%d</data>',[Integer(DS)]));
    Add(Format('<data name="ACPI" type="boolean" source="CPUID">%d</data>',[Integer(ACPI)]));
    Add(Format('<data name="MMX" type="boolean" source="CPUID">%d</data>',[Integer(MMX)]));
    Add(Format('<data name="FastFloatingPointSaveRestore" type="boolean" source="CPUID">%d</data>',[Integer(FXSR)]));
    Add(Format('<data name="StreamingSIMDExtensions" type="boolean" source="CPUID">%d</data>',[Integer(SSE)]));
    Add(Format('<data name="StreamingSIMDExtensions2" type="boolean" source="CPUID">%d</data>',[Integer(SSE2)]));
    Add(Format('<data name="SelfSnoop" type="boolean" source="CPUID">%d</data>',[Integer(SS)]));
    Add(Format('<data name="HyperThreadingTechnology" type="boolean" source="CPUID">%d</data>',[Integer(HTT)]));
    Add(Format('<data name="ThermalMonitor" type="boolean" source="CPUID">%d</data>',[Integer(TM)]));
    Add(Format('<data name="3DNow" type="boolean" source="CPUID">%d</data>',[Integer(_3DNOW)]));
    Add(Format('<data name="Enhanced3DNow" type="boolean" source="CPUID">%d</data>',[Integer(EX_3DNOW)]));
    Add(Format('<data name="EnhancedMMX" type="boolean" source="CPUID">%d</data>',[Integer(EX_MMX)]));

    Add('</CPUFeatures>');
    if Standalone then ReportFooter(sl);
  end;
  {$IFDEF ERROR_INTERCEPT}PopTrace;{$ENDIF}
end;

procedure TCPUFeatures.SetMode(const Value: TExceptionModes);
begin
  FModes := Value;
end;

{ TCPU }

constructor TCPU.Create;
begin
  inherited;
  FFeatures:=TCPUFeatures.Create;
  FCache:=TCPUCache.Create;
  ExceptionModes:=[emExceptionStack];
end;

destructor TCPU.Destroy;
begin
  FFeatures.Free;
  FCache.Free;
  inherited;
end;

procedure TCPU.GetInfo;
var
  SI :TSystemInfo;
  CPUID: TCPUIDResult;
  i: integer;
  fi: TFreqInfo;
const
  rkCPU = {HKEY_LOCAL_MACHINE}'\HARDWARE\DESCRIPTION\System\CentralProcessor\0';
  rvVendorID = 'VendorIdentifier';
  rvID = 'Identifier';
  rvPNS = 'ProcessorNameString';
  rvFreq = '~MHz';
begin
  {$IFDEF ERROR_INTERCEPT}PushTrace(FModes,Self,'GetInfo'); {$ENDIF}

  FGetCache:=AGetCache;
  FGetFeat:=AGetFeatures;

  FVendorCPUID:=GetVendor;

  FCPUVendor:=VENDOR_UNKNOWN;
  for i:=VENDOR_INTEL to VENDOR_TM do
    if CPUVendorIDs[i]=CPUIDVendor then begin
      FCPUVendor:=i;
      FVendorEx:=CPUVendorsEx[i];
      Break;
    end;

  if AGetCache then
    Cache.GetInfo(VendorType);
  if AGetFeatures then
    Features.GetInfo;

  ZeroMemory(@SI,SizeOf(SI));
  GetSystemInfo(SI);
  FCount:=SI.dwNumberOfProcessors;

  with TRegistry.Create do begin
    Rootkey:=HKEY_LOCAL_MACHINE;
    if OpenKeyReadOnly(rkCPU) then begin
      FVendorReg:=ReadString(rvVendorID);
      FVendorIDReg:=ReadString(rvID);
      try
        FPNSReg:=ReadString(rvPNS);
      except
      end;
      try
        FFreqReg:=ReadInteger(rvFreq);
      except
      end;
      CloseKey;
    end;
    Free;
  end;

  CPUID_Level:=CPUID_MAXLEVELEX;
  CPUID:=ExecuteCPUID;
  FExtLevel:=CPUID.EAX;

  CPUID_Level:=CPUID_MAXLEVEL;
  CPUID:=ExecuteCPUID;
  FLevel:=CPUID.EAX;

  CPUID_Level:=CPUID_CPUSIGNATURE;
  CPUID:=ExecuteCPUID;
  FCPUSig:=CPUID;
  FTyp:=CPUID.EAX shr 12 and 3;
  FFamily:=CPUID.EAX shr 8 and $F;
  FModel:=CPUID.EAX shr 4 and $F;
  FStepping:=CPUID.EAX and $F;
  FBrand:=LoByte(LoWord(CPUID.EBX));

  CPUID_Level:=CPUID_CPUSIGNATUREEX;
  CPUID:=ExecuteCPUID;
  FCPUSigEx:=CPUID;
  FExtFamily:=CPUID.EAX shr 8 and $F;
  FExtModel:=CPUID.EAX shr 4 and $F;
  FExtStep:=CPUID.EAX and $F;

  case FTyp of
    0: FCPUType:=ctPrimary;
    1: FCPUType:=ctOverdrive;
    2: FCPUType:=ctSecondary;
  else
    FCPUType:=ctUnknown;
  end;

  case FFamily of
    0: FCPUFamily:=cf8086;
    2: FCPUFamily:=cf286;
    3: FCPUFamily:=cf386;
    4: FCPUFamily:=cf486;
    5: FCPUFamily:=cf586;
    6: FCPUFamily:=cf686;
    7: FCPUFamily:=cf8086_64;
   $F: case FExtFamily of
         0: FCPUFamily:=cf786;
         1: FCPUFamily:=cf8086_64;
       end;
   else
     FCPUFamily:=cfUnknown;
  end;

  FFreq:=RoundFrequency(Round(GetCPUSpeed_M3));
  fi:=GetCPUSpeed_M1;
  if FFreq<fi.NormFreq then
    FFreq:=fi.NormFreq;
  FVendorIDCPUID:=GetVendorID;
  FDIV:=GetFDIVBugPresent;
  FVendorID:=FVendorIDCPUID;
  GetCPUName(VendorType,Family,ExtendedFamily,Model,Stepping,Brand,Cache.Level2,Cache.Level3,Frequency,FVendorID,FCodeName);
  if FCPUFamily=cf8086_64 then
    FArch:=IA_64
  else
    FArch:=IA_32;
  FSerial:=GetCPUSerialNumber;

  {$IFDEF ERROR_INTERCEPT}PopTrace;{$ENDIF}
end;

procedure TCPU.Report;
begin
  {$IFDEF ERROR_INTERCEPT}PushTrace(FModes,Self,'Report'); {$ENDIF}
  with sl do begin
    if Standalone then ReportHeader(sl);
    Add('<CPU classname="TCPU">');
    Add(Format('<data name="Count" type="string" source="API">%d</data>',[Self.Count]));

    Add(Format('<data name="REG_Vendor" type="string" source="Registry">%s</data>',[CheckXMLValue(RegistryVendor)]));
    Add(Format('<data name="REG_VendorID" type="string" source="Registry">%s</data>',[CheckXMLValue(RegistryVendorID)]));
    Add(Format('<data name="REG_NameString" type="string" source="Registry">%s</data>',[CheckXMLValue(RegistryNameString)]));
    Add(Format('<data name="REG_Frequency" type="integer" source="Registry" unit="MHz">%d</data>',[RegistryFrequency]));

    Add(Format('<data name="Vendor" type="string" source="CPUID">%s</data>',[CheckXMLValue(CPUIDVendor)]));
    Add(Format('<data name="NameString" type="string" source="CPUID">%s</data>',[CheckXMLValue(Trim(CPUIDNameString))]));
    Add(Format('<data name="FriendlyName" type="string" source="CPUID">%s</data>',[CheckXMLValue(Friendlyname)]));
    Add(Format('<data name="CodeName" type="string" source="CPUID">%s</data>',[CheckXMLValue(Codename)]));
    Add(Format('<data name="Family" type="integer" source="CPUID">%d</data>',[Family]));
    Add(Format('<data name="ExtendedFamily" type="integer" source="CPUID">%d</data>',[ExtendedFamily]));
    Add(Format('<data name="Model" type="integer" source="CPUID">%d</data>',[Model]));
    Add(Format('<data name="ExtendedModel" type="integer" source="CPUID">%d</data>',[ExtendedModel]));
    Add(Format('<data name="Stepping" type="integer" source="CPUID">%d</data>',[Stepping]));
    Add(Format('<data name="ExtendedStepping" type="integer" source="CPUID">%d</data>',[ExtendedStepping]));
    Add(Format('<data name="Type" type="integer" source="CPUID">%d</data>',[Typ]));
    Add(Format('<data name="Brand" type="integer" source="CPUID">%d</data>',[Brand]));
    Add(Format('<data name="MaximumFunctionLevel" type="integer" source="CPUID">%d</data>',[MaxFunctionLevel]));
    Add(Format('<data name="MaximumExtendedFunctionLevel" type="integer" source="CPUID">%d</data>',[MaxExtendedFunctionLevel]));
    Add(Format('<data name="Frequency" type="integer" source="CPUID" unit="MHz">%d</data>',[Frequency]));
    Add(Format('<data name="SerialNumber" type="string" source="CPUID">%s</data>',[CheckXMLValue(SerialNumber)]));
    Add(Format('<data name="FDIVBug" type="boolean" source="API">%d</data>',[Integer(FDIVBug)]));

    Add('</CPU>');

    if FGetFeat then
      Features.Report(sl,False);

    if FGetCache then
      Cache.Report(sl,False);

    if Standalone then ReportFooter(sl);
  end;
  {$IFDEF ERROR_INTERCEPT}PopTrace;{$ENDIF}
end;

procedure TCPU.SetMode(const Value: TExceptionModes);
begin
  FModes := Value;
  if Assigned(Cache) then
    Cache.ExceptionModes:=FModes;
  if Assigned(Features) then
    Features.ExceptionModes:=FModes;
end;

{ TCPUCache }

constructor TCPUCache.Create;
begin
  inherited;
  FDesc:=TStringList.Create;
  ExceptionModes:=[emExceptionStack];
end;

destructor TCPUCache.Destroy;
begin
  FDesc.Free;
  inherited;
end;

procedure TCPUCache.GetInfo;

function GetAMDAssociativity(A: Byte): string;
begin
  case A of
    AMDCA_L2OFF        :Result:='Off';
    AMDCA_DIRECTMAPPED :Result:='Direct mapped';
    AMDCA_2WAY         :Result:='2-way associative';
    AMDCA_4WAY         :Result:='4-way associative';
    AMDCA_8WAY         :Result:='8-way associative';
    AMDCA_16WAY        :Result:='16-way associative';
    else Result:='fully associative';
  end;
end;

var
  i: integer;
  CPUID: TCPUIDResult;
begin
  {$IFDEF ERROR_INTERCEPT}PushTrace(FModes,Self,'GetInfo'); {$ENDIF}

  CPUID_Level:=CPUID_CPUSIGNATURE;
  CPUID:=ExecuteCPUID;
  FFamily:=CPUID.EAX shr 8 and $F;
  FModel:=CPUID.EAX shr 4 and $F;
  FStepping:=CPUID.EAX and $F;
  FVendorID:=GetVendorID;

  FDesc.Clear;
  FLevel1Data:=0;
  FLevel1Code:=0;
  FLevel1:=0;
  FLevel2:=0;
  FLevel3:=0;
  case AVendor of
    VENDOR_INTEL: begin
      IntelCache:=ExecuteIntelCache;
      for i:=0 to 15 do begin
        case IntelCache[i] of
          $41,$79: FLevel2:=128;
          $42,$7A,$82: FLevel2:=256;
          $22,$43,$7B,$83: FLevel2:=512;
          $23,$44,$7C,$84: FLevel2:=1024;
          $25,$45,$85: FLevel2:=2048;
          $29: FLevel2:=4096;
        end;
        case IntelCache[i] of
          $6,$70: Inc(FLevel1Code,12);
          $8,$71: Inc(FLevel1Code,16);
          $72: Inc(FLevel1Code,32);
        end;
        case IntelCache[i] of
          $A,$66: Inc(FLevel1Data,8);
          $C,$67: Inc(FLevel1Data,16);
          $68: Inc(FLevel1Data,32);
        end;

        case IntelCache[i] of
          01: FDesc.Add('Instruction TLB, 4K pages, 4-way set associative, 32 entries');
          02: FDesc.Add('Instruction TLB, 4M pages, fully associative, 2 entries');
          03: FDesc.Add('Data TLB, 4K pages, 4-way set associative, 64 entries');
          04: FDesc.Add('Data TLB, 4M pages, 4-way set associative, 8 entries');
          06: FDesc.Add('Instruction cache, 8K, 4-way set associative, 32 byte line size');
          08: FDesc.Add('Instruction cache 16K, 4-way set associative, 32 byte line size');
          $0A: FDesc.Add('Data cache, 8K, 2-way set associative, 32 byte line size');
          $0C: FDesc.Add('Data cache, 16K, 4-way set associative, 32 byte line size');
          $40: FDesc.Add('No L2 cache (P6 family), or No L3 cache (Pentium 4 and Xeon processors)');
          $41: FDesc.Add('Unified cache, 32 byte cache line,4-way set associative, 128K');
          $42: FDesc.Add('Unified cache, 32 byte cache line, 4-way set associative, 256K');
          $43: FDesc.Add('Unified cache, 32 byte cache line, 4-way set associative, 512K');
          $44: FDesc.Add('Unified cache, 32 byte cache line, 4-way set associative, 1M');
          $45: FDesc.Add('Unified cache, 32 byte cache line, 4-way set associative, 2M');
          $50: FDesc.Add('Instruction TLB, 4K, 2M or 4M pages, fully associative, 64 entries');
          $51: FDesc.Add('Instruction TLB, 4K, 2M or 4M pages, fully associative, 128 entries');
          $52: FDesc.Add('Instruction TLB, 4K, 2M or 4M pages, fully associative, 256 entries');
          $5B: FDesc.Add('Data TLB, 4K or 4M pages, fully associative, 64 entries');
          $5C: FDesc.Add('Data TLB, 4K or 4M pages, fully associative, 128 entries');
          $5D: FDesc.Add('Data TLB, 4K or 4M pages, fully associative, 256 entries');
          $66: FDesc.Add('Data cache, sectored, 64 byte cache line, 4 way set associative, 8K');
          $67: FDesc.Add('Data cache, sectored, 64 byte cache line, 4 way set associative, 16K');
          $68: FDesc.Add('Data cache, sectored, 64 byte cache line, 4 way set associative, 32K');
          $70: FDesc.Add('Instruction Trace cache, 8 way set associative, 12K uOps');
          $71: FDesc.Add('Instruction Trace cache, 8 way set associative, 16K uOps');
          $72: FDesc.Add('Instruction Trace cache, 8 way set associative, 32K uOps');
          $79: FDesc.Add('Unified cache, sectored, 64 byte cache line, 8 way set associative, 128K');
          $7A: FDesc.Add('Unified cache, sectored, 64 byte cache line, 8 way set associative, 256K');
          $7B: FDesc.Add('Unified cache, sectored, 64 byte cache line, 8 way set associative, 512K');
          $7C: FDesc.Add('Unified cache, sectored, 64 byte cache line, 8 way set associative, 1M');
          $82: FDesc.Add('Unified cache, 32 byte cache line, 8 way set associative, 256K');
          $84: FDesc.Add('Unified cache, 32 byte cache line, 8 way set associative, 1M');
          $85: FDesc.Add('Unified cache, 32 byte cache line, 8 way set associative, 2M');
        end;
      end;
      FLevel1:=L1Data+L1Code;
    end;
    VENDOR_AMD: begin
      AMDCache:=ExecuteAMDCache;
      FLevel1Data:=AMDCache.L1DataCache[3];
      FLevel1Code:=AMDCache.L1ICache[3];
      FLevel1:=L1Data+L1Code;
      if (FFamily=6) and (FModel in [6,7]) and (AMDCache.Level2Cache[3]>0) then begin
        if Pos('Duron',FVendorID)>0 then
          FLevel2:=64
        else
          FLevel2:=256;
      end;
      FLevel3:=0;
      if (AMDCache.L12MInstructionTLB[0]<>0) and (AMDCache.L12MInstructionTLB[1]<>0) then
        FDesc.Add(Format('Instruction TLB, 2M/4M pages, %s, %d entries',[GetAMDAssociativity(AMDCache.L12MInstructionTLB[1]),AMDCache.L12MInstructionTLB[0]]));
      if (AMDCache.L14KInstructionTLB[0]<>0) and (AMDCache.L14KInstructionTLB[1]<>0) then
        FDesc.Add(Format('Instruction TLB, 4K pages, %s, %d entries',[GetAMDAssociativity(AMDCache.L14KInstructionTLB[1]),AMDCache.L14KInstructionTLB[0]]));
      if (AMDCache.L1ICache[3]<>0) then
        FDesc.Add(Format('Instruction cache %dK, %s, %d byte line size, %d line per tag',[AMDCache.L1ICache[3],GetAMDAssociativity(AMDCache.L1ICache[2]),AMDCache.L1ICache[0],AMDCache.L1ICache[1]]));
      if (AMDCache.L12MDataTLB[0]<>0) and (AMDCache.L12MDataTLB[1]<>0) then
        FDesc.Add(Format('Data TLB, 2M/4M pages, %s, %d entries',[GetAMDAssociativity(AMDCache.L12MDataTLB[1]),AMDCache.L12MDataTLB[0]]));
      if (AMDCache.L14KDataTLB[0]<>0) and (AMDCache.L14KDataTLB[1]<>0) then
        FDesc.Add(Format('Data TLB, 4K pages, %s, %d entries',[GetAMDAssociativity(AMDCache.L14KDataTLB[1]),AMDCache.L14KDataTLB[0]]));
      if (AMDCache.L1DataCache[3]<>0) then
        FDesc.Add(Format('Data cache %dK, %s, %d byte line size, %d line per tag',[AMDCache.L1DataCache[3],GetAMDAssociativity(AMDCache.L1DataCache[2]),AMDCache.L1DataCache[0],AMDCache.L1DataCache[1]]));

      if (AMDCache.L22MInstructionTLB[0]<>0) and (AMDCache.L22MInstructionTLB[1]<>0) then
        FDesc.Add(Format('L2 Instruction TLB, 2M/4M pages, %s, %d entries',[GetAMDAssociativity(AMDCache.L22MInstructionTLB[1]),AMDCache.L22MInstructionTLB[0]]));
      if (AMDCache.L24KInstructionTLB[0]<>0) and (AMDCache.L24KInstructionTLB[1]<>0) then
        FDesc.Add(Format('L2 Instruction TLB, 4K pages, %s, %d entries',[GetAMDAssociativity(AMDCache.L24KInstructionTLB[1]),AMDCache.L24KInstructionTLB[0]]));
      if (AMDCache.L22MDataTLB[0]<>0) and (AMDCache.L22MDataTLB[1]<>0) then
        FDesc.Add(Format('L2 Data TLB, 2M/4M pages, %s, %d entries',[GetAMDAssociativity(AMDCache.L22MDataTLB[1]),AMDCache.L22MDataTLB[0]]));
      if (AMDCache.L24KDataTLB[0]<>0) and (AMDCache.L24KDataTLB[1]<>0) then
        FDesc.Add(Format('L2 Data TLB, 4K pages, %s, %d entries',[GetAMDAssociativity(AMDCache.L24KDataTLB[1]),AMDCache.L24KDataTLB[0]]));
      if (FLevel2<>0) then begin
        FDesc.Add(Format('Unified cache %dK, 16-way associative, %d byte line size, %d line per tag',[FLevel2,AMDCache.Level2Cache[0],AMDCache.Level2Cache[1]]));
      end;
    end;
    VENDOR_CYRIX: begin
      CyrixCache:=ExecuteCyrixCache;
      if $80 in [CyrixCache.L1CacheInfo[0],CyrixCache.L1CacheInfo[1],CyrixCache.L1CacheInfo[2],CyrixCache.L1CacheInfo[3]] then
	FLevel1:=16;
    end;
    VENDOR_IDT: ;
    VENDOR_NEXGEN: ;
    VENDOR_UMC: ;
    VENDOR_RISE: ;
  end;

  {$IFDEF ERROR_INTERCEPT}PopTrace;{$ENDIF}
end;

procedure TCPUCache.Report;
var
  i: Integer;
begin
  {$IFDEF ERROR_INTERCEPT}PushTrace(FModes,Self,'Report'); {$ENDIF}
  with sl do begin
    if Standalone then ReportHeader(sl);
    Add('<CPUCache classname="TCPUCache">');

    Add(Format('<data name="Level1Data" type="integer" source="CPUID" unit="KB">%d</data>',[L1Data]));
    Add(Format('<data name="Level1Code" type="integer" source="CPUID" unit="KB">%d</data>',[L1Code]));
    Add(Format('<data name="Level2" type="integer" source="CPUID" unit="KB">%d</data>',[Level2]));
    Add(Format('<data name="Level3" type="integer" source="CPUID" unit="KB">%d</data>',[Level3]));
    for i:=0 to Descriptions.Count-1 do
      Add(Format('<data name="CacheDescriptions" type="string" source="CPUID">%s</data>',[CheckXMLValue(Descriptions[i])]));

    Add('</CPUCache>');
    if Standalone then ReportFooter(sl);
  end;
  {$IFDEF ERROR_INTERCEPT}PopTrace;{$ENDIF}
end;

procedure TCPUCache.SetMode(const Value: TExceptionModes);
begin
  FModes := Value;
end;

end.

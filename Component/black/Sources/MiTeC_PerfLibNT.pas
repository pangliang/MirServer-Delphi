{*******************************************************}
{                                                       }
{       MiTeC System Information Component              }
{           Performance Library for WinNT               }
{           version 7.73 for Delphi 5,6                  }
{                                                       }
{       Copyright © 1997,2002 Michal Mutl               }
{                                                       }
{*******************************************************}

{$INCLUDE MITEC_DEF.INC}

unit MiTeC_PerfLibNT;

interface

uses Windows, Classes, SysUtils;

//resourcestring
const
  SPERFNUMHEX_BadSize = 'Bad Size (PERF_NUMBER_HEX)';
  SPERFNUMDEC_BadSize = 'Bad Size (PERF_NUMBER_DEC)';
  SPERFNUMDEC1K_BadSize = 'Bad Size (PERF_NUMBER_DEC1000)';
  SPERFCNTR_BadSize = 'Bad Size (PERF_COUNTER)';
  SPERFCNTRRATE_BadSize = 'Bad Size (PERF_COUNTER_RATE)';
  SPERFCNTRBASE_BadSize = 'Bad Size (PERF_COUNTER_BASE)';
  SPERFCNTRELAPS_BadSize = 'Bad Size (PERF_COUNTER_ELAPSED)';
  SUnknownType = 'Cannot display data';
  SPERFTYPETEXT_BadData = 'Bad Data (PERF_TYPE_TEXT)';

  SPerSec = '/sec';
  SPercent = ' %';
  SSecs = ' secs';
  SFrac = 'Frac';
  SElapsed = 'Elapsed';

  SNoname = '<noname>';

const
  Timer100N = 10000000;
  Timer1S = 1000;

  PERF_DETAIL_NOVICE      = $00000000;
  PERF_DETAIL_ADVANCED    = $00000100;
  PERF_DETAIL_EXPERT      = $00000200;
  PERF_DETAIL_WIZARD      = $00000300;

//                      PERF_COUNTER_DEFINITION
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//
//  PERF_COUNTER_DEFINITION.CounterType field values
//
//
//        Counter ID Field Definition:
//
//   3      2        2    2    2        1        1    1
//   1      8        4    2    0        6        2    0    8                0
//  +--------+--------+----+----+--------+--------+----+----+----------------+
//  |Display |Calculation  |Time|Counter |        |Ctr |Size|                |
//  |Flags   |Modifiers    |Base|SubType |Reserved|Type|Fld |   Reserved     |
//  +--------+--------+----+----+--------+--------+----+----+----------------+
//
//
  PERF_SIZE_DWORD         = $00000000;
  PERF_SIZE_LARGE         = $00000100;
  PERF_SIZE_ZERO          = $00000200;  // for Zero Length fields
  PERF_SIZE_VARIABLE_LEN  = $00000300;  // length is in CounterLength field of Counter Definition struct
  //
  //  select one of the following values to indicate the counter field usage
  //
  PERF_TYPE_NUMBER        = $00000000;  // a number (not a counter)
  PERF_TYPE_COUNTER       = $00000400;  // an increasing numeric value
  PERF_TYPE_TEXT          = $00000800;  // a text field
  PERF_TYPE_ZERO          = $00000C00;  // displays a zero
  //
  //  If the PERF_TYPE_NUMBER field was selected, then select one of the
  //  following to describe the Number
  //
  PERF_NUMBER_HEX         = $00000000;  // display as HEX value
  PERF_NUMBER_DECIMAL     = $00010000;  // display as a decimal integer
  PERF_NUMBER_DEC_1000    = $00020000;  // display as a decimal/1000
  //
  //  If the PERF_TYPE_COUNTER value was selected then select one of the
  //  following to indicate the type of counter
  //
  PERF_COUNTER_VALUE      = $00000000;  // display counter value
  PERF_COUNTER_RATE       = $00010000;  // divide ctr / delta time
  PERF_COUNTER_FRACTION   = $00020000;  // divide ctr / base
  PERF_COUNTER_BASE       = $00030000;  // base value used in fractions
  PERF_COUNTER_ELAPSED    = $00040000;  // subtract counter from current time
  PERF_COUNTER_QUEUELEN   = $00050000;  // Use Queuelen processing func.
  PERF_COUNTER_HISTOGRAM  = $00060000;  // Counter begins or ends a histogram
  //
  //  If the PERF_TYPE_TEXT value was selected, then select one of the
  //  following to indicate the type of TEXT data.
  //
  PERF_TEXT_UNICODE       = $00000000;  // type of text in text field
  PERF_TEXT_ASCII         = $00010000;  // ASCII using the CodePage field
  //
  //  Timer SubTypes
  //
  PERF_TIMER_TICK         = $00000000;  // use system perf. freq for base
  PERF_TIMER_100NS        = $00100000;  // use 100 NS timer time base units
  PERF_OBJECT_TIMER       = $00200000;  // use the object timer freq
  //
  //  Any types that have calculations performed can use one or more of
  //  the following calculation modification flags listed here
  //
  PERF_DELTA_COUNTER      = $00400000;  // compute difference first
  PERF_DELTA_BASE         = $00800000;  // compute base diff as well
  PERF_INVERSE_COUNTER    = $01000000;  // show as 1.00-value (assumes:
  PERF_MULTI_COUNTER      = $02000000;  // sum of multiple instances
  //
  //  Select one of the following values to indicate the display suffix (if any)
  //
  PERF_DISPLAY_NO_SUFFIX  = $00000000;  // no suffix
  PERF_DISPLAY_PER_SEC    = $10000000;  // "/sec"
  PERF_DISPLAY_PERCENT    = $20000000;  // "%"
  PERF_DISPLAY_SECONDS    = $30000000;  // "secs"
  PERF_DISPLAY_NOSHOW     = $40000000;  // value is not displayed
  //
  //  Predefined counter types
  //

  // 32-bit Counter.  Divide delta by delta time.  Display suffix: "/sec"
  PERF_COUNTER_COUNTER =
              PERF_SIZE_DWORD or PERF_TYPE_COUNTER or PERF_COUNTER_RATE or
              PERF_TIMER_TICK or PERF_DELTA_COUNTER or PERF_DISPLAY_PER_SEC;


  // 64-bit Timer.  Divide delta by delta time.  Display suffix: "%"
  PERF_COUNTER_TIMER =
              PERF_SIZE_LARGE or PERF_TYPE_COUNTER or PERF_COUNTER_RATE or
              PERF_TIMER_TICK or PERF_DELTA_COUNTER or PERF_DISPLAY_PERCENT;

  // Queue Length Space-Time Product. Divide delta by delta time. No Display Suffix.
  PERF_COUNTER_QUEUELEN_TYPE =
              PERF_SIZE_DWORD or PERF_TYPE_COUNTER or PERF_COUNTER_QUEUELEN or
              PERF_TIMER_TICK or PERF_DELTA_COUNTER or PERF_DISPLAY_NO_SUFFIX;

  // Queue Length Space-Time Product. Divide delta by delta time. No Display Suffix.
  PERF_COUNTER_LARGE_QUEUELEN_TYPE =
              PERF_SIZE_LARGE or PERF_TYPE_COUNTER or PERF_COUNTER_QUEUELEN or
              PERF_TIMER_TICK or PERF_DELTA_COUNTER or PERF_DISPLAY_NO_SUFFIX;

  // 64-bit Counter.  Divide delta by delta time. Display Suffix: "/sec"
  PERF_COUNTER_BULK_COUNT =
              PERF_SIZE_LARGE or PERF_TYPE_COUNTER or PERF_COUNTER_RATE or
              PERF_TIMER_TICK or PERF_DELTA_COUNTER or PERF_DISPLAY_PER_SEC;

  // Indicates the counter is not a  counter but rather Unicode text Display as text.
  PERF_COUNTER_TEXT =
              PERF_SIZE_VARIABLE_LEN or PERF_TYPE_TEXT or PERF_TEXT_UNICODE or
              PERF_DISPLAY_NO_SUFFIX;

  // Indicates the data is a counter  which should not be
  // time averaged on display (such as an error counter on a serial line)
  // Display as is.  No Display Suffix.
  PERF_COUNTER_RAWCOUNT =
              PERF_SIZE_DWORD or PERF_TYPE_NUMBER or PERF_NUMBER_DECIMAL or
              PERF_DISPLAY_NO_SUFFIX;

  // Same as PERF_COUNTER_RAWCOUNT except its size is a large integer
  PERF_COUNTER_LARGE_RAWCOUNT =
              PERF_SIZE_LARGE or PERF_TYPE_NUMBER or PERF_NUMBER_DECIMAL or
              PERF_DISPLAY_NO_SUFFIX;

  // Special case for RAWCOUNT that want to be displayed in hex
  // Indicates the data is a counter  which should not be
  // time averaged on display (such as an error counter on a serial line)
  // Display as is.  No Display Suffix.
  PERF_COUNTER_RAWCOUNT_HEX =
              PERF_SIZE_DWORD or PERF_TYPE_NUMBER or PERF_NUMBER_HEX or
              PERF_DISPLAY_NO_SUFFIX;

  // Same as PERF_COUNTER_RAWCOUNT_HEX except its size is a large integer
  PERF_COUNTER_LARGE_RAWCOUNT_HEX =
              PERF_SIZE_LARGE or PERF_TYPE_NUMBER or PERF_NUMBER_HEX or
              PERF_DISPLAY_NO_SUFFIX;


  // A count which is either 1 or 0 on each sampling interrupt (% busy)
  // Divide delta by delta base. Display Suffix: "%"
  PERF_SAMPLE_FRACTION =
              PERF_SIZE_DWORD or PERF_TYPE_COUNTER or PERF_COUNTER_FRACTION or
              PERF_DELTA_COUNTER or PERF_DELTA_BASE or PERF_DISPLAY_PERCENT;

  // A count which is sampled on each sampling interrupt (queue length)
  // Divide delta by delta time. No Display Suffix.
  PERF_SAMPLE_COUNTER =
              PERF_SIZE_DWORD or PERF_TYPE_COUNTER or PERF_COUNTER_RATE or
              PERF_TIMER_TICK or PERF_DELTA_COUNTER or PERF_DISPLAY_NO_SUFFIX;

  // A label: no data is associated with this counter (it has 0 length)
  // Do not display.
  PERF_COUNTER_NODATA =
              PERF_SIZE_ZERO or PERF_DISPLAY_NOSHOW;

  // 64-bit Timer inverse (e.g., idle is measured, but display busy %)
  // Display 100 - delta divided by delta time.  Display suffix: "%"
  PERF_COUNTER_TIMER_INV =
              PERF_SIZE_LARGE or PERF_TYPE_COUNTER or PERF_COUNTER_RATE or
              PERF_TIMER_TICK or PERF_DELTA_COUNTER or PERF_INVERSE_COUNTER or
              PERF_DISPLAY_PERCENT;

  // The divisor for a sample, used with the previous counter to form a
  // sampled %.  You must check for >0 before dividing by this!  This
  // counter will directly follow the  numerator counter.  It should not
  // be displayed to the user.
  PERF_SAMPLE_BASE =
              PERF_SIZE_DWORD or PERF_TYPE_COUNTER or PERF_COUNTER_BASE or
              PERF_DISPLAY_NOSHOW or
              $00000001;  // for compatibility with pre-beta versions

  // A timer which, when divided by an average base, produces a time
  // in seconds which is the average time of some operation.  This
  // timer times total operations, and  the base is the number of opera-
  // tions.  Display Suffix: "sec"
  PERF_AVERAGE_TIMER =
              PERF_SIZE_DWORD or PERF_TYPE_COUNTER or PERF_COUNTER_FRACTION or
              PERF_DISPLAY_SECONDS;

  // Used as the denominator in the computation of time or count
  // averages.  Must directly follow the numerator counter.  Not dis-
  // played to the user.
  PERF_AVERAGE_BASE =
              PERF_SIZE_DWORD or PERF_TYPE_COUNTER or PERF_COUNTER_BASE or
              PERF_DISPLAY_NOSHOW or
              $00000002;  // for compatibility with pre-beta versions


  // A bulk count which, when divided (typically) by the number of
  // operations, gives (typically) the number of bytes per operation.
  // No Display Suffix.
  PERF_AVERAGE_BULK =
              PERF_SIZE_LARGE or PERF_TYPE_COUNTER or PERF_COUNTER_FRACTION  or
              PERF_DISPLAY_NOSHOW;

  // 64-bit Timer in 100 nsec units. Display delta divided by
  // delta time.  Display suffix: "%"
  PERF_100NSEC_TIMER =
              PERF_SIZE_LARGE or PERF_TYPE_COUNTER or PERF_COUNTER_RATE or
              PERF_TIMER_100NS or PERF_DELTA_COUNTER or PERF_DISPLAY_PERCENT;

  // 64-bit Timer inverse (e.g., idle is measured, but display busy %)
  // Display 100 - delta divided by delta time.  Display suffix: "%"
  PERF_100NSEC_TIMER_INV =
              PERF_SIZE_LARGE or PERF_TYPE_COUNTER or PERF_COUNTER_RATE or
              PERF_TIMER_100NS or PERF_DELTA_COUNTER or PERF_INVERSE_COUNTER  or
              PERF_DISPLAY_PERCENT;

  // 64-bit Timer.  Divide delta by delta time.  Display suffix: "%"
  // Timer for multiple instances, so result can exceed 100%.
  PERF_COUNTER_MULTI_TIMER =
              PERF_SIZE_LARGE or PERF_TYPE_COUNTER or PERF_COUNTER_RATE or
              PERF_DELTA_COUNTER or PERF_TIMER_TICK or PERF_MULTI_COUNTER or
              PERF_DISPLAY_PERCENT;

  // 64-bit Timer inverse (e.g., idle is measured, but display busy %)
  // Display 100 * _MULTI_BASE - delta divided by delta time.
  // Display suffix: "%" Timer for multiple instances, so result
  // can exceed 100%.  Followed by a counter of type _MULTI_BASE.
  PERF_COUNTER_MULTI_TIMER_INV =
              PERF_SIZE_LARGE or PERF_TYPE_COUNTER or PERF_COUNTER_RATE or
              PERF_DELTA_COUNTER or PERF_MULTI_COUNTER or PERF_TIMER_TICK or
              PERF_INVERSE_COUNTER or PERF_DISPLAY_PERCENT;

  // Number of instances to which the preceding _MULTI_..._INV counter
  // applies.  Used as a factor to get the percentage.
  PERF_COUNTER_MULTI_BASE =
              PERF_SIZE_LARGE or PERF_TYPE_COUNTER or PERF_COUNTER_BASE or
              PERF_MULTI_COUNTER or PERF_DISPLAY_NOSHOW;

  // 64-bit Timer in 100 nsec units. Display delta divided by delta time.
  // Display suffix: "%" Timer for multiple instances, so result can exceed 100%.
  PERF_100NSEC_MULTI_TIMER =
              PERF_SIZE_LARGE or PERF_TYPE_COUNTER or PERF_DELTA_COUNTER  or
              PERF_COUNTER_RATE or PERF_TIMER_100NS or PERF_MULTI_COUNTER or
              PERF_DISPLAY_PERCENT;

  // 64-bit Timer inverse (e.g., idle is measured, but display busy %)
  // Display 100 * _MULTI_BASE - delta divided by delta time.
  // Display suffix: "%" Timer for multiple instances, so result
  // can exceed 100%.  Followed by a counter of type _MULTI_BASE.
  PERF_100NSEC_MULTI_TIMER_INV =
              PERF_SIZE_LARGE or PERF_TYPE_COUNTER or PERF_DELTA_COUNTER  or
              PERF_COUNTER_RATE or PERF_TIMER_100NS or PERF_MULTI_COUNTER or
              PERF_INVERSE_COUNTER or PERF_DISPLAY_PERCENT;

  // Indicates the data is a fraction of the following counter  which
  // should not be time averaged on display (such as free space over
  // total space.) Display as is.  Display the quotient as "%".
  PERF_RAW_FRACTION =
              PERF_SIZE_DWORD or PERF_TYPE_COUNTER or PERF_COUNTER_FRACTION or
              PERF_DISPLAY_PERCENT;

  // Indicates the data is a base for the preceding counter which should
  // not be time averaged on display (such as free space over total space.)
  PERF_RAW_BASE =
              PERF_SIZE_DWORD or PERF_TYPE_COUNTER or PERF_COUNTER_BASE or
              PERF_DISPLAY_NOSHOW or
              $00000003;  // for compatibility with pre-beta versions

  // The data collected in this counter is actually the start time of the
  // item being measured. For display, this data is subtracted from the
  // sample time to yield the elapsed time as the difference between the two.
  // In the definition below, the PerfTime field of the Object contains
  // the sample time as indicated by the PERF_OBJECT_TIMER bit and the
  // difference is scaled by the PerfFreq of the Object to convert the time
  // units into seconds.
  PERF_ELAPSED_TIME =
              PERF_SIZE_LARGE or PERF_TYPE_COUNTER or PERF_COUNTER_ELAPSED or
              PERF_OBJECT_TIMER or PERF_DISPLAY_SECONDS;
  //
  //  The following counter type can be used with the preceding types to
  //  define a range of values to be displayed in a histogram.
  //

  PERF_COUNTER_HISTOGRAM_TYPE   = $80000000;
                                          // Counter begins or ends a histogram
  //
  //  This counter is used to display the difference from one sample
  //  to the next. The counter value is a constantly increasing number
  //  and the value displayed is the difference between the current
  //  value and the previous value. Negative numbers are not allowed
  //  which shouldn't be a problem as long as the counter value is
  //  increasing or unchanged.
  //
  PERF_COUNTER_DELTA =
              PERF_SIZE_DWORD or PERF_TYPE_COUNTER or PERF_COUNTER_VALUE or
              PERF_DELTA_COUNTER or PERF_DISPLAY_NO_SUFFIX;

  PERF_COUNTER_LARGE_DELTA =
              PERF_SIZE_LARGE or PERF_TYPE_COUNTER or PERF_COUNTER_VALUE or
              PERF_DELTA_COUNTER or PERF_DISPLAY_NO_SUFFIX;


type
  PLARGE_INTEGER = ^LARGE_INTEGER;

  PPERF_OBJECT_TYPE = ^TPERF_OBJECT_TYPE;
  TPERF_OBJECT_TYPE = packed record
    TotalByteLength,
    DefinitionLength,
    HeaderLength,
    ObjectNameTitleIndex: DWORD;
    ObjectNameTitle: LPWSTR;
    ObjectHelpTitleIndex: DWORD;
    ObjectHelpTitle: LPWSTR;
    DetailLevel,
    NumCounters,
    DefaultCounter,
    NumInstances,
    CodePage: DWORD;
    PerfTime,
    PerfFreq: LARGE_INTEGER;
  end;

  PPERF_COUNTER_DEFINITION = ^TPERF_COUNTER_DEFINITION;
  TPERF_COUNTER_DEFINITION = packed record
    ByteLength,
    CounterNameTitleIndex: DWORD;
    CounterNameTitle: LPWSTR;
    CounterHelpTitleIndex: DWORD;
    CounterHelpTitle: LPWSTR;
    DefaultScale,
    DetailLevel,
    CounterType,
    CounterSize,
    CounterOffset: DWORD;
  end;

  PPERF_INSTANCE_DEFINITION = ^TPERF_INSTANCE_DEFINITION;
  TPERF_INSTANCE_DEFINITION = packed record
    ByteLength,
    ParentObjectTitleIndex,
    ParentObjectInstance,
    UniqueID,
    NameOffset,
    NameLength: DWORD;
  end;

  PPERF_COUNTER_BLOCK = ^TPERF_COUNTER_BLOCK;
  TPERF_COUNTER_BLOCK = packed record
    ByteLength: DWORD;
  end;

  PPERF_DATA_BLOCK = ^TPERF_DATA_BLOCK;
  TPERF_DATA_BLOCK = packed record
    Signature: array [0..3] of WCHAR;
    LittleEndian,
    Version,
    Revision,
    TotalByteLength,
    HeaderLength,
    NumObjectTypes,
    DefaultObject: DWORD;
    SystemTime: SYSTEMTIME;
    PerfTime,
    PerfFreq,
    PerfTime100nSec: LARGE_INTEGER;
    SystemNameLength,
    SystemNameOffset: DWORD;
  end;

  TPerfLibNT = class;

  TPerfObject = class;

  TDetailLevel = (Novice,Advanced,Expert,Wizard);

  TPerfCounter = class(TObject)
  private
    FPerfObject: TPerfObject;

    FName: string;
    FDescription: string;
    FCounterOffset: DWORD;
    FDefaultScale: DWORD;
    FCounterSize: DWORD;
    FDetailLevel: TDetailLevel;
    FCounterType: DWORD;
    FIndex: DWORD;

    function GetData(InstanceIndex: DWORD): PChar;
    function GetDataStr(InstanceIndex: DWORD): string;
    function GetDataStrEx(InstanceIndex: DWORD): string;
  protected
    property CounterOffset: DWORD read FCounterOffset;
    property Index: DWORD read FIndex;
  public
    constructor Create(AIndex: DWORD; APerfObject: TPerfObject; APerfCntr: PPERF_COUNTER_DEFINITION);
    destructor Destroy; override;

    property Name: string read FName;
    property Description: string read FDescription;
    property DefaultScale: DWORD read FDefaultScale;
    property DetailLevel: TDetailLevel read FDetailLevel;
    property CounterType: DWORD read FCounterType;
    property CounterSize: DWORD read FCounterSize;
    property ParentObject: TPerfObject read FPerfObject;

    property Data[InstanceIndex: DWORD]: PChar read GetData;
    property DataStr[InstanceIndex: DWORD]: string read GetDataStr;
    property DataStrEx[InstanceIndex: DWORD]: string read GetDataStrEx;
  end;

  PPerfInstance = ^TPerfInstance;
  TPerfInstance = record
    Name: string;
    ID,
    Index: DWORD;
  end;

  TPerfObject = class(TObject)
  private
    FCounters: TStringList;

    FPerfLib: TPerfLibNT;
    FName: string;
    FDescription: string;
    FCodePage: DWORD;
    FCounterCount: integer;
    FDefaultCounter: integer;
    FDetailLevel: TDetailLevel;
    FPerfObj: PPERF_OBJECT_TYPE;
    FPerfTime: LARGE_INTEGER;
    FPerfFreq: LARGE_INTEGER;
    FIndex: DWORD;
    function GetCounter(Index: integer): TPerfCounter;
    function GetInstance(Index: integer): TPerfInstance;
    function GetInstanceCount: integer;
  protected
    property Index: DWORD read FIndex;
    property PerfLib: TPerfLibNT read FPerfLib;
    property PerfObj: PPERF_OBJECT_TYPE read FPerfObj;
  public
    constructor Create(AIndex: DWORD; APerfLib: TPerfLibNT; APerfObj: PPERF_OBJECT_TYPE);
    destructor Destroy; override;

    function GetCntrIndexByName(AName: string): integer;
    {function GetInstIndexByName(AName: string): integer;
    function GetInstIndexByID(AID: DWORD): integer;}

    property Name: string read FName;
    property Description: string read FDescription;
    property DetailLevel: TDetailLevel read FDetailLevel;
    property CounterCount: integer read FCounterCount;
    property DefaultCounter: integer read FDefaultCounter;
    property InstanceCount: integer read GetInstanceCount;
    property CodePage: DWORD read FCodePage;
    property PerfTime: LARGE_INTEGER read FPerfTime;
    property PerfFreq: LARGE_INTEGER read FPerfFreq;

    property Counters[Index: integer]: TPerfCounter read GetCounter;
    property Instances[Index: integer]: TPerfInstance read GetInstance;
  end;

  TPerfLibNT = class(TPersistent)
  private
    FPerfData: PPERF_DATA_BLOCK;

    FCounters,
    FHelps,
    FObjects: TStringList;
    FPerfTime: LARGE_INTEGER;
    FPerfFreq: LARGE_INTEGER;
    FPerfTime100nsec: LARGE_INTEGER;
    FRevision: DWORD;
    FVersion: DWORD;

    procedure GetNameStrings;
    procedure ReadObjects;
    function GetObject(Index: integer): TPerfObject;
    function GetObjectCount: integer;
  protected
    function GetCounterData(ObjectIndex,InstanceIndex,CounterIndex: DWORD): PChar;
    property Helps: TStringList read FHelps;
  public
    constructor Create;
    destructor Destroy; override;

    procedure TakeSnapshot;
    procedure Refresh;
    function GetIndexByName(AName: string): integer;

    property Names: TStringList read FCounters;
    property PerfTime: LARGE_INTEGER read FPerfTime;
    property PerfFreq: LARGE_INTEGER read FPerfFreq;
    property PerfTime100nsec: LARGE_INTEGER read FPerfTime100nsec;
    property Version: DWORD read FVersion;
    property Revision: DWORD read FRevision;
    property ObjectCount: integer read GetObjectCount;
    property Objects[Index: integer]: TPerfObject read GetObject;
  end;

  function FormatData(AType, ASize: Integer; AVerbose: Boolean; AData: PChar): string;
  function GetCounterTypeStr(AType: DWORD): string;
  function GetDetailLevelStr(ALevel: TDetailLevel): string;

implementation

const
  rkPerfLib = {HKLM\}'SOFTWARE\Microsoft\Windows NT\CurrentVersion\Perflib';
    rvLastCounter = 'LastCounter';
  rkPerfLib009 = {HKLM\}'SOFTWARE\Microsoft\Windows NT\CurrentVersion\Perflib\009';
    rvCounter = 'Counter';
    rvHelp = 'Help';
  rkGlobal = 'Global';

function FirstObject(APerfData: PPERF_DATA_BLOCK): PPERF_OBJECT_TYPE;
begin
  Result:=PPERF_OBJECT_TYPE(PCHAR(APerfData)+APerfData^.HeaderLength);
end;

function NextObject(APerfObj: PPERF_OBJECT_TYPE): PPERF_OBJECT_TYPE;
begin
  Result:=PPERF_OBJECT_TYPE(PCHAR(APerfObj)+APerfObj^.TotalByteLength);
end;

function FirstInstance(APerfObj: PPERF_OBJECT_TYPE): PPERF_INSTANCE_DEFINITION;
begin
  Result:=PPERF_INSTANCE_DEFINITION(PCHAR(APerfObj)+APerfObj^.DefinitionLength);
end;

function NextInstance(APerfInst: PPERF_INSTANCE_DEFINITION): PPERF_INSTANCE_DEFINITION;
var
  PerfCntrBlk: PPERF_COUNTER_BLOCK;
begin
  PerfCntrBlk:=PPERF_COUNTER_BLOCK(PCHAR(APerfInst)+APerfInst^.ByteLength);
  result:=PPERF_INSTANCE_DEFINITION(PCHAR(PerfCntrBlk)+PerfCntrBlk^.ByteLength);
end;

function FirstCounter(APerfObj: PPERF_OBJECT_TYPE): PPERF_COUNTER_DEFINITION;
begin
  Result:=PPERF_COUNTER_DEFINITION(PCHAR(APerfObj)+APerfObj^.HeaderLength);
end;

function NextCounter(APerfCntr: PPERF_COUNTER_DEFINITION): PPERF_COUNTER_DEFINITION;
begin
  Result:=PPERF_COUNTER_DEFINITION(PCHAR(APerfCntr)+APerfCntr^.ByteLength);
end;


//   3      2        2    2    2        1        1    1
//   1      8        4    2    0        6        2    0    8                0
//  +--------+--------+----+----+--------+--------+----+----+----------------+
//  |Display |Calculation  |Time|Counter |        |Ctr |Size|                |
//  |Flags   |Modifiers    |Base|SubType |Reserved|Type|Fld |   Reserved     |
//  +--------+--------+----+----+--------+--------+----+----+----------------+


function FormatData;
var
  SizeFld,
  CtrType,
  CounterSubType,
  //TimeBase,
  //CalculationModifiers,
  DisplayFlags: Integer;
  s: string;
  time: int64;
  n: extended;
  Base: extended;
const
 DeltaTime: Integer = 1;
begin
  base:=1;
  SizeFld:=AType and $300;
  CtrType:=AType and $c00;
  CounterSubType:=AType and $f0000;
//  TimeBase:=AType and $300000;
//  CalculationModifiers:=AType and $fc00000;
  DisplayFlags:=AType and $f0000000;

  s:='';

  case SizeFld of
    PERF_SIZE_DWORD: ASize := 4;
    PERF_SIZE_LARGE: ASize := 8;
    PERF_SIZE_ZERO: ASize := 0;
    PERF_SIZE_VARIABLE_LEN: ; // length is in CounterLength field
  end;

  case CtrType of
    PERF_TYPE_NUMBER :
      case CounterSubType of
        PERF_NUMBER_HEX:
          case ASize of
            4: s:=IntToHex(PInteger(AData)^,8);
            8: s:=IntToHex(PLARGE_INTEGER(AData)^.HighPart,8)+':'+IntToHex(PLARGE_INTEGER(AData)^.LowPart,8);
            else s:=SPERFNUMHEX_BadSize;
          end;
        PERF_NUMBER_DECIMAL:
          case ASize of
            4: s:=IntToStr(PInteger(AData)^);
            8: s:=Format('%d',[PLARGE_INTEGER(AData)^.QuadPart]);
            else s:=SPERFNUMDEC_BadSize;
          end;
        PERF_NUMBER_DEC_1000:
          case ASize of
            4: s:=IntToStr(PInteger(AData)^ div 1000);
            8: s:=Format('%n',[PLARGE_INTEGER(AData)^.QuadPart/1000]);
            else s:=SPERFNUMDEC1K_BadSize;
          end
      end;

    PERF_TYPE_COUNTER:
      case CounterSubType of
        PERF_COUNTER_VALUE :
          case ASize of
            4: s:=IntToStr(PInteger(AData)^);
            8: s:=Format('%d',[PLARGE_INTEGER(AData)^.QuadPart]);
            else s:=SPERFCNTR_BadSize;
          end;
        PERF_COUNTER_RATE :
          case ASize of
            4: s:=IntToStr(PInteger(AData)^ div deltaTime);
            8: s:=Format('%n',[PLARGE_INTEGER(AData)^.QuadPart/deltatime]);
            else s:=SPERFCNTRRATE_BadSize;
          end;

        PERF_COUNTER_FRACTION: begin
          case ASize of
            4: n:=PInteger(AData)^/base;
            8: n:=PLARGE_INTEGER(AData)^.QuadPart/base;
            else
              n:=0;
          end;
          if (ASize=4) or (ASize=8) then  begin
            if DisplayFlags=PERF_DISPLAY_PERCENT then
              n:=n*100;
            s:=Format('%1.3n',[n]);
            if AVerbose then
              s:=SFrac+' '+s;
          end
        end;

        PERF_COUNTER_BASE:
          case ASize of
            4 : base:=PInteger(AData)^;
            8 : base:=PLARGE_INTEGER(AData)^.QuadPart;
            else s:=SPERFCNTRBASE_BadSize;
          end;

        PERF_COUNTER_ELAPSED: begin
          QueryPerformanceFrequency(time);
          case ASize of
            4 : s:=IntToStr(low(time)-PInteger(AData)^);
            8 : s:=Format('%n',[PLARGE_INTEGER(AData)^.QuadPart/time]);
            else s:=SPERFCNTRELAPS_BadSize;
          end;
          if AVerbose then
            s:=SElapsed+' '+s;
        end;

        PERF_COUNTER_QUEUELEN:
          s:='QUEUELEN';

        PERF_COUNTER_HISTOGRAM:
          s:='HISTOGRAM';
        else s:=SUnknownType;
      end;

    PERF_TYPE_TEXT:
      s:=SPERFTYPETEXT_BadData;
    PERF_TYPE_ZERO:
      s:='0';
  end;

  if AVerbose then
    case DisplayFlags of
      PERF_DISPLAY_PER_SEC: s:=s+SPerSec;
      PERF_DISPLAY_PERCENT: s:=s+SPercent;
      PERF_DISPLAY_SECONDS: s:=s+SSecs;
      PERF_DISPLAY_NOSHOW: s:='';
    end;

  result:=s;
end;

function GetCounterTypeStr(AType: DWORD): string;
var
  CtrType,
  CtrSubType: integer;
begin
  CtrType:=AType and $c00;
  CtrSubType:=AType and $f0000;

  Result:='';

  case AType of
    PERF_COUNTER_COUNTER: Result:='PERF_COUNTER_COUNTER';
    PERF_COUNTER_TIMER: Result:='PERF_COUNTER_TIMER';
    PERF_COUNTER_QUEUELEN_TYPE: Result:='PERF_COUNTER_QUEUELEN_TYPE';
    PERF_COUNTER_LARGE_QUEUELEN_TYPE: Result:='PERF_COUNTER_LARGE_QUEUELEN_TYPE';
    PERF_COUNTER_BULK_COUNT: Result:='PERF_COUNTER_BULK_COUNT';
    PERF_COUNTER_TEXT: Result:='PERF_COUNTER_TEXT';
    PERF_COUNTER_RAWCOUNT: Result:='PERF_COUNTER_RAWCOUNT';
    PERF_COUNTER_LARGE_RAWCOUNT: Result:='PERF_COUNTER_LARGE_RAWCOUNT';
    PERF_COUNTER_RAWCOUNT_HEX: Result:='PERF_COUNTER_RAWCOUNT_HEX';
    PERF_COUNTER_LARGE_RAWCOUNT_HEX: Result:='PERF_COUNTER_LARGE_RAWCOUNT_HEX';
    PERF_SAMPLE_FRACTION: Result:='PERF_SAMPLE_FRACTION';
    PERF_SAMPLE_COUNTER: Result:='PERF_SAMPLE_COUNTER';
    PERF_COUNTER_NODATA: Result:='PERF_COUNTER_NODATA';
    PERF_COUNTER_TIMER_INV: Result:='PERF_COUNTER_TIMER_INV';
    PERF_SAMPLE_BASE: Result:='PERF_SAMPLE_BASE';
    PERF_AVERAGE_TIMER: Result:='PERF_AVERAGE_TIMER';
    PERF_AVERAGE_BASE: Result:='PERF_AVERAGE_BASE';
    PERF_AVERAGE_BULK: Result:='PERF_AVERAGE_BULK';
    PERF_100NSEC_TIMER: Result:='PERF_100NSEC_TIMER';
    PERF_100NSEC_TIMER_INV: Result:='PERF_100NSEC_TIMER_INV';
    PERF_COUNTER_MULTI_TIMER: Result:='PERF_COUNTER_MULTI_TIMER';
    PERF_COUNTER_MULTI_TIMER_INV: Result:='PERF_COUNTER_MULTI_TIMER_INV';
    PERF_COUNTER_MULTI_BASE: Result:='PERF_COUNTER_MULTI_BASE';
    PERF_100NSEC_MULTI_TIMER: Result:='PERF_100NSEC_MULTI_TIMER';
    PERF_100NSEC_MULTI_TIMER_INV: Result:='PERF_100NSEC_MULTI_TIMER_INV';
    PERF_RAW_FRACTION: Result:='PERF_RAW_FRACTION';
    PERF_RAW_BASE: Result:='PERF_RAW_BASE';
    PERF_ELAPSED_TIME: Result:='PERF_ELAPSED_TIME';
    PERF_COUNTER_HISTOGRAM_TYPE: Result:='PERF_COUNTER_HISTOGRAM_TYPE';
    PERF_COUNTER_DELTA: Result:='PERF_COUNTER_DELTA';
    PERF_COUNTER_LARGE_DELTA: Result:='PERF_COUNTER_LARGE_DELTA';
  end;

  if Result='' then
    case CtrType of
      PERF_TYPE_NUMBER :
        case CtrSubType of
          PERF_NUMBER_HEX: Result:='PERF_NUMBER_HEX';
          PERF_NUMBER_DECIMAL: Result:='PERF_NUMBER_DEC';
          PERF_NUMBER_DEC_1000: Result:='PERF_NUMBER_DEC1000';
        end;
      PERF_TYPE_COUNTER:
        case CtrSubType of
          PERF_COUNTER_VALUE: Result:='PERF_COUNTER_VALUE';
          PERF_COUNTER_RATE : Result:='PERF_COUNTER_RATE';
          PERF_COUNTER_FRACTION: Result:='PERF_COUNTER_FRACTION';
          PERF_COUNTER_BASE: Result:='PERF_COUNTER_BASE';
          PERF_COUNTER_ELAPSED: Result:='PERF_COUNTER_ELAPSED';
          PERF_COUNTER_QUEUELEN: Result:='PERF_COUNTER_QUEUELEN';
          PERF_COUNTER_HISTOGRAM: Result:='PERF_COUNTER_HISTOGRAM';
        end;
      PERF_TYPE_TEXT:
        case CtrSubType of
          PERF_TEXT_UNICODE: Result:='PERF_TEXT_UNICODE';
          PERF_TEXT_ASCII: Result:='PERF_TEXT_ASCII';
        end;
      PERF_TYPE_ZERO: Result:='PERF_TYPE_ZERO';
    end;
  if Result='' then
    Result:='0x'+IntToHex(AType,8);
end;

function GetDetailLevelStr(ALevel: TDetailLevel): string;
begin
  case ALevel of
    Novice: Result:='Novice';
    Advanced: Result:='Advanced';
    Expert: Result:='Expert';
    Wizard: Result:='Wizard';
  end;
end;

{ TPerfLibNT }

constructor TPerfLibNT.Create;
begin
  FCounters:=TStringList.Create;
  FHelps:=TStringList.Create;
  FObjects:=TStringList.Create;
  FPerfData:=AllocMem(MaxWord);
end;

destructor TPerfLibNT.Destroy;
begin
  while FCounters.Count>0 do begin
//    Freemem(PDWORD(FCounters.Objects[FCounters.Count-1]));
    FCounters.Delete(FCounters.Count-1);
  end;
  while FHelps.Count>0 do begin
//    FHelps.Objects[FHelps.Count-1].Free;
    FHelps.Delete(FHelps.Count-1);
  end;
  while FObjects.Count>0 do begin
    FObjects.Objects[FObjects.Count-1].Free;
    FObjects.Delete(FObjects.Count-1);
  end;
  FCounters.Free;
  FObjects.Free;
  FHelps.Free;
  FreeMem(FPerfData);
  inherited;
end;

function TPerfLibNT.GetIndexByName(AName: string): integer;
begin
  Result:=FObjects.IndexOf(AName);
end;

procedure TPerfLibNT.GetNameStrings;
var
  hkPerfLib,
  hkPerfLib009: HKEY;
  dwBufferSize,
  dwBuffer,
  dwMaxValueLen: DWORD;
  lpNameStrings: PChar;
  p: integer;
  szID,
  szName: string;
begin
  while FCounters.Count>0 do begin
    //FCounters.Objects[FCounters.Count-1].Free;
    FCounters.Delete(FCounters.Count-1);
  end;
  while FHelps.Count>0 do begin
    //FHelps.Objects[FHelps.Count-1].Free;
    FHelps.Delete(FHelps.Count-1);
  end;
  RegOpenKeyEx(HKEY_LOCAL_MACHINE,rkPerfLib,0,KEY_READ,hkPerflib);
  dwBufferSize:=sizeof(dwBuffer);
  RegQueryValueEx(hkPerflib,rvLastCounter,nil,nil,PBYTE(@dwBuffer),@dwBufferSize);
  RegCloseKey(hkPerflib);
  RegOpenKeyEx(HKEY_LOCAL_MACHINE,rkPerfLib009,0,KEY_READ,hkPerflib009);
  RegQueryInfoKey(hkPerflib009,nil,nil,nil,nil,nil,nil,nil,nil,@dwMaxValueLen,nil,nil);
  dwBuffer:=dwMaxValueLen+1;
  lpNameStrings:=AllocMem(dwBuffer*sizeof(char));

  RegQueryValueEx(hkPerflib009,rvCounter,nil,nil,PBYTE(lpNameStrings),@dwBuffer);
  p:=0;
  repeat
    szID:=lpNameStrings+p;
    Inc(p,Length(szID)+1);
    szName:=lpNameStrings+p;
    Inc(p,Length(szName)+1);
    FCounters.AddObject(szName,TObject(StrToInt(szID)));
  until lpNameStrings[p]=#0;

  RegQueryInfoKey(hkPerflib009,nil,nil,nil,nil,nil,nil,nil,nil,@dwMaxValueLen,nil,nil);
  dwBuffer:=dwMaxValueLen+1;
  ReallocMem(lpNameStrings,dwBuffer*sizeof(char));
  RegQueryValueEx(hkPerflib009,rvHelp,nil,nil,PBYTE(lpNameStrings),@dwBuffer);

  p:=0;
  repeat
    szID:=lpNameStrings+p;
    Inc(p,Length(szID)+1);
    szName:=lpNameStrings+p;
    Inc(p,Length(szName)+1);
    FHelps.AddObject(szName,TObject(StrToInt(szID)));
  until lpNameStrings[p]=#0;
  FreeMem(lpNameStrings);
  RegCloseKey(hkPerflib009);
end;

function TPerfLibNT.GetObject(Index: integer): TPerfObject;
begin
  if Index<FObjects.Count then
    Result:=TPerfObject(FObjects.Objects[Index])
  else
    Result:=nil;
end;

function TPerfLibNT.GetObjectCount: integer;
begin
  Result:=FPerfData^.NumObjectTypes;
end;

function TPerfLibNT.GetCounterData(ObjectIndex,
  InstanceIndex, CounterIndex: DWORD): PChar;
var
  po: PPERF_OBJECT_TYPE;
  pc: PPERF_COUNTER_DEFINITION;
  pi: PPERF_INSTANCE_DEFINITION;
  i: DWORD;
begin
  po:=FirstObject(FPerfData);
  if ObjectIndex>0 then
    for i:=0 to ObjectIndex-1 do
      po:=NextObject(po);
  pc:=FirstCounter(po);
  if CounterIndex>0 then
    for i:=0 to CounterIndex-1 do
      pc:=NextCounter(pc);
  if Integer(po^.NumInstances)>0 then begin
    pi:=FirstInstance(po);
    if InstanceIndex>0 then
      for i:=0 to InstanceIndex-1 do
        pi:=NextInstance(pi);
    Result:=PChar(pi)+pi^.ByteLength+pc^.CounterOffset;
  end else begin
    Result:=PChar(po)+po^.DefinitionLength+pc^.CounterOffset;
  end;
end;

procedure TPerfLibNT.ReadObjects;
var
  PerfObj: PPERF_OBJECT_TYPE;
  PO: TPerfObject;
  i: integer;
begin
  while FObjects.Count>0 do begin
    FObjects.Objects[FObjects.Count-1].Free;
    FObjects.Delete(FObjects.Count-1);
  end;
  PerfObj:=FirstObject(FPerfData);
  for i:=0 to FPerfData^.NumObjectTypes-1 do begin
    PO:=TPerfObject.Create(FObjects.Count,Self,PerfObj);
    FObjects.AddObject(PO.Name,PO);
    PerfObj:=NextObject(PerfObj);
  end;
end;

procedure TPerfLibNT.Refresh;
begin
  GetNameStrings;
  TakeSnapShot;
  ReadObjects;
end;

procedure TPerfLibNT.TakeSnapshot;
var
  BufferSize: DWORD;
const
  BYTEINCREMENT = 4096;
begin
  BufferSize:=MaxWord;
  ReallocMem(FPerfData,BufferSize);
  while RegQueryValueEx(HKEY_PERFORMANCE_DATA,rkGlobal,nil,nil,PBYTE(FPerfData),@BufferSize)=ERROR_MORE_DATA do begin
    BufferSize:=BufferSize+BYTEINCREMENT;
    ReallocMem(FPerfData,BufferSize);
  end;
  FPerfTime:=FPerfData^.PerfTime;
  FPerfFreq:=FPerfData^.PerfFreq;
  FPerfTime100nsec:=FPerfData^.PerfTime100nSec;
  FVersion:=FPerfData^.Version;
  FRevision:=FPerfData^.Revision;
end;

{ TPerfObject }

constructor TPerfObject.Create;
var
  PerfCntr: PPERF_COUNTER_DEFINITION;
  //PtrToCntr: PPERF_COUNTER_BLOCK;
  i :DWORD;
  PC: TPerfCounter;
begin
  FPerfLib:=APerfLib;
  FPerfObj:=APerfObj;
  FIndex:=AIndex;
  FName:=FPerfLib.Names[FPerfLib.Names.IndexOfObject(TObject(APerfObj^.ObjectNameTitleIndex))];
  FDescription:=FPerfLib.Helps[FPerfLib.Helps.IndexOfObject(TObject(APerfObj^.ObjectHelpTitleIndex))];
  FCodePage:=APerfObj^.CodePage;
  FCounterCount:=APerfObj^.NumCounters;
  FDefaultCounter:=APerfObj^.DefaultCounter;
  FPerfTime:=APerfObj^.PerfTime;
  FPerfFreq:=APerfObj^.PerfFreq;
  case APerfObj^.DetailLevel of
    PERF_DETAIL_NOVICE: FDetailLevel:=Novice;
    PERF_DETAIL_ADVANCED: FDetailLevel:=Advanced;
    PERF_DETAIL_EXPERT: FDetailLevel:=Expert;
    PERF_DETAIL_WIZARD: FDetailLevel:=Wizard;
  end;
  FCounters:=TStringList.Create;

  PerfCntr:=FirstCounter(APerfObj);
  //PtrToCntr:=PPERF_COUNTER_BLOCK(PChar(APerfObj)+APerfObj^.DefinitionLength);
  if CounterCount>0 then
    for i:=0 to CounterCount-1 do begin
      PC:=TPerfCounter.Create(FCounters.Count,Self,PerfCntr);
      FCounters.AddObject(PC.Name,PC);
      PerfCntr:=NextCounter(PerfCntr);
    end;
end;

destructor TPerfObject.Destroy;
begin
  while FCounters.Count>0 do begin
    FCounters.Objects[FCounters.Count-1].Free;
    FCounters.Delete(FCounters.Count-1);
  end;
  FCounters.Free;
  inherited;
end;

function TPerfObject.GetCounter(Index: integer): TPerfCounter;
begin
  if Index<FCounters.Count then
    Result:=TPerfCounter(FCounters.Objects[Index])
  else
    Result:=nil;
end;

function TPerfObject.GetCntrIndexByName(AName: string): integer;
begin
  Result:=FCounters.IndexOf(AName);
end;

function TPerfObject.GetInstance(Index: integer): TPerfInstance;
var
  pi: PPERF_INSTANCE_DEFINITION;
  i: integer;
begin
  if Index<InstanceCount then begin
    pi:=FirstInstance(FPerfObj);
    if Index>0 then
      for i:=0 to Index-1 do
        pi:=NextInstance(pi);
    Result.Name:='';
    Result.Index:=Index;
    for i:=0 to pi^.NameLength-1 do
      if PChar(pi)[pi^.NameOffset+i]<>#0 then
        Result.Name:=Result.Name+PChar(pi)[pi^.NameOffset+i];
    Result.ID:=pi^.UniqueID;
  end;
end;

{function TPerfObject.GetInstIndexByID(AID: DWORD): integer;
var
  i: integer;
begin
  Result:=-1;
end;

function TPerfObject.GetInstIndexByName(AName: string): integer;
begin
  Result:=-1;
end;}

function TPerfObject.GetInstanceCount: integer;
var
  po: PPERF_OBJECT_TYPE;
  i: integer;
begin
  po:=FirstObject(FPerfLib.FPerfData);
  if Index>0 then
    for i:=0 to Index-1 do
      po:=NextObject(po);
  Result:=po^.NumInstances;
end;

{ TPerfCounter }


constructor TPerfCounter.Create;
var
  idx: integer;
begin
  FPerfObject:=APerfObject;
  FIndex:=AIndex;
  idx:=FPerfObject.PerfLib.Names.IndexOfObject(TObject(APerfCntr^.CounterNameTitleIndex));
  if idx>-1 then
    FName:=FPerfObject.PerfLib.Names[idx]
  else
    FName:=SNoname;
  idx:=FPerfObject.PerfLib.Helps.IndexOfObject(TObject(APerfCntr^.CounterHelpTitleIndex));
  if idx>-1 then
    FDescription:=FPerfObject.PerfLib.Helps[idx]
  else
    FDescription:='';
  FCounterOffset:=APerfCntr^.CounterOffset;
  FDefaultScale:=APerfCntr^.DefaultScale;
  FCounterSize:=APerfCntr^.CounterSize;
  FCounterType:=APerfCntr^.CounterType;
  case APerfCntr^.DetailLevel of
    PERF_DETAIL_NOVICE: FDetailLevel:=Novice;
    PERF_DETAIL_ADVANCED: FDetailLevel:=Advanced;
    PERF_DETAIL_EXPERT: FDetailLevel:=Expert;
    PERF_DETAIL_WIZARD: FDetailLevel:=Wizard;
  end;
end;

destructor TPerfCounter.Destroy;
begin

  inherited;
end;

function TPerfCounter.GetData;
begin
  result:=FPerfObject.PerfLib.GetCounterData(FPerfObject.Index,InstanceIndex,Self.Index);
end;

function TPerfCounter.GetDataStr;
begin
  Result:=FormatData(CounterType,CounterSize,False,Data[InstanceIndex]);
end;

function TPerfCounter.GetDataStrEx;
begin
  Result:=FormatData(CounterType,CounterSize,True,Data[InstanceIndex]);
end;

end.

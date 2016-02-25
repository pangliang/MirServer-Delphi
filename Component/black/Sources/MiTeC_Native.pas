{*******************************************************}
{                                                       }
{         MiTeC System Information Component            }
{               WinNT Native API                        }
{           version 8.6 for Delphi 5,6,7                }
{                                                       }
{           Copyright © 2003,2004 Michal Mutl           }
{                                                       }
{*******************************************************}

{$INCLUDE MITEC_DEF.INC}

unit MiTeC_Native;

interface

uses Windows, SysUtils;

type
  PPointer = ^Pointer;
  PVOID = Pointer;
  USHORT = DWORD;
  LONG = Integer;
  Handle = THandle;
  PWSTR = PWideChar;

  UNICODE_STRING =  packed record
    Length,
    MaximumLength: WORD;
    Buffer: PWideChar;
  end;
  TUnicodeString = UNICODE_STRING;
  PUnicodeString = ^TUnicodeString;

  SYSTEM_INFORMATION_CLASS = (
          SystemBasicInformation,
          SystemProcessorInformation,
          SystemPerformanceInformation,
          SystemTimeOfDayInformation,
          SystemNotImplemented1,
          SystemProcessesAndThreadsInformation,
          SystemCallCounts,
          SystemConfigurationInformation,
          SystemProcessorTimes,
          SystemGlobalFlag,
          SystemNotImplemented2,
          SystemModuleInformation,
          SystemLockInformation,
          SystemNotImplemented3,
          SystemNotImplemented4,
          SystemNotImplemented5,
          SystemHandleInformation,
          SystemObjectInformation,
          SystemPagefileInformation,
          SystemInstructionEmulationCounts,
          SystemInvalidInfoClass1,
          SystemCacheInformation,
          SystemPoolTagInformation,
          SystemProcessorStatistics,
          SystemDpcInformation,
          SystemNotImplemented6,
          SystemLoadImage,
          SystemUnloadImage,
          SystemTimeAdjustment,
          SystemNotImplemented7,
          SystemNotImplemented8,
          SystemNotImplemented9,
          SystemCrashDumpInformation,
          SystemExceptionInformation,
          SystemCrashDumpStateInformation,
          SystemKernelDebuggerInformation,
          SystemContextSwitchInformation,
          SystemRegistryQuotaInformation,
          SystemLoadAndCallImage,
          SystemPrioritySeparation,
          SystemNotImplemented10,
          SystemNotImplemented11,
          SystemInvalidInfoClass2,
          SystemInvalidInfoClass3,
          SystemTimeZoneInformation,
          SystemLookasideInformation,
          SystemSetTimeSlipEvent,
          SystemCreateSession,
          SystemDeleteSession,
          SystemInvalidInfoClass4,
          SystemRangeStartInformation,
          SystemVerifierInformation,
          SystemAddVerifier,
          SystemSessionProcessesInformation);
  TSystemInformationClass = SYSTEM_INFORMATION_CLASS;

  OBJECT_INFORMATION_CLASS = (
    ObjectBasicInformation,
    ObjectNameInformation,
    ObjectTypeInformation,
    ObjectAllTypesInformation,
    ObjectHandleInformation);
  TObjectInformationClass = OBJECT_INFORMATION_CLASS;

  SYSTEM_PROCESSOR_TIMES = packed record
    IdleTime: LARGE_INTEGER;
    KernelTime: LARGE_INTEGER;
    UserTime: LARGE_INTEGER;
    DpcTime: LARGE_INTEGER;
    InterruptTime: LARGE_INTEGER;
    InterruptCount: ULONG;
  end;
  TSystemProcessorTimes = SYSTEM_PROCESSOR_TIMES;
  PSystemProcessorTimes = ^TSystemProcessorTimes;

  CLIENT_ID = record
    UniqueProcess: DWORD;
    UniqueThread: DWORD;
  end;
  TClientID = CLIENT_ID;
  PClientID = ^TClientID;

  KPRIORITY = Longint;

  KWAIT_REASON = (
    Executive,
    FreePage,
    PageIn,
    PoolAllocation,
    DelayExecution,
    Suspended,
    UserRequest,
    WrExecutive,
    WrFreePage,
    WrPageIn,
    WrPoolAllocation,
    WrDelayExecution,
    WrSuspended,
    WrUserRequest,
    WrEventPair,
    WrQueue,
    WrLpcReceive,
    WrLpcReply,
    WrVirtualMemory,
    WrPageOut,
    WrRendezvous,
    Spare2,
    Spare3,
    Spare4,
    Spare5,
    Spare6,
    WrKernel,
    MaximumWaitReason);
  TKWaitReason = KWAIT_REASON;

  THREAD_STATE = (
    StateInitialized,
    StateReady,
    StateRunning,
    StateStandby,
    StateTerminated,
    StateWait,
    StateTransition,
    StateUnknown);
  TThreadState = THREAD_STATE;

  SYSTEM_THREAD_INFORMATION = record
    KernelTime: LARGE_INTEGER;
    UserTime: LARGE_INTEGER;
    CreateTime: LARGE_INTEGER;
    WaitTime: ULONG;
    StartAddress: PVOID;
    ClientId: CLIENT_ID;
    Priority: KPRIORITY;
    BasePriority: KPRIORITY;
    ContextSwitchCount: ULONG;
    State: DWORD;
    WaitReason: DWORD;
  end;
  TSystemThreadInformation = SYSTEM_THREAD_INFORMATION;
  PSystemThreadInformation = ^TSystemThreadInformation;

  VM_COUNTERS = record
    PeakVirtualSize: DWORD;
    VirtualSize: DWORD;
    PageFaultCount: DWORD;
    PeakWorkingSetSize: DWORD;
    WorkingSetSize: DWORD;
    QuotaPeakPagedPoolUsage: DWORD;
    QuotaPagedPoolUsage: DWORD;
    QuotaPeakNonPagedPoolUsage: DWORD;
    QuotaNonPagedPoolUsage: DWORD;
    PagefileUsage: DWORD;
    PeakPagefileUsage: DWORD;
  end;
  TVMCounters = VM_COUNTERS;
  PVMCounters = ^TVMCounters;

  IO_COUNTERSEX  = record
    ReadOperationCount: LARGE_INTEGER;
    WriteOperationCount: LARGE_INTEGER;
    OtherOperationCount: LARGE_INTEGER;
    ReadTransferCount: LARGE_INTEGER;
    WriteTransferCount: LARGE_INTEGER;
    OtherTransferCount: LARGE_INTEGER;
  end;
  TIOCounters = IO_COUNTERSEX;
  PIoCounters = ^TIoCounters;

const
  NonPagedPool = 0;
  PagedPool = 1;
  NonPagedPoolMustSucceed = 2;
  DontUseThisType = 3;
  NonPagedPoolCacheAligned = 4;
  PagedPoolCacheAligned = 5;
  NonPagedPoolCacheAlignedMustS = 6;
  MaxPoolType = 7;
  NonPagedPoolSession = 32;
  PagedPoolSession = NonPagedPoolSession + 1;
  NonPagedPoolMustSucceedSession = PagedPoolSession + 1;
  DontUseThisTypeSession = NonPagedPoolMustSucceedSession + 1;
  NonPagedPoolCacheAlignedSession = DontUseThisTypeSession + 1;
  PagedPoolCacheAlignedSession = NonPagedPoolCacheAlignedSession + 1;
  NonPagedPoolCacheAlignedMustSSession = PagedPoolCacheAlignedSession + 1;

type
  POOL_TYPE = NonPagedPool..NonPagedPoolCacheAlignedMustSSession;

  SYSTEM_PROCESS_INFORMATION = record
    NextEntryDelta: ULONG;
    ThreadCount: ULONG;
    Reserved1: array [0..5] of ULONG;
    CreateTime: LARGE_INTEGER;
    UserTime: LARGE_INTEGER;
    KernelTime: LARGE_INTEGER;
    ProcessName: UNICODE_STRING;
    BasePriority: KPRIORITY;
    ProcessId: ULONG;
    InheritedFromProcessId: ULONG;
    HandleCount: ULONG;
    SessionId: ULONG;
    Reserved2: ULONG;
    VmCounters: VM_COUNTERS;
    IoCounters: IO_COUNTERSEX;  // Windows 2000 only
    Threads: array [0..255] of SYSTEM_THREAD_INFORMATION;
  end;
  TSystemProcessInformation = SYSTEM_PROCESS_INFORMATION;
  PSystemProcessInformation = ^TSystemProcessInformation;

  SYSTEM_MODULE_INFORMATION = record
    Reserved: array [0..1] of ULONG;
    Base: Pointer;
    Size: ULONG;
    Flags: ULONG;
    Index: WORD;
    Unknown: WORD;
    LoadCount: WORD;
    ModuleNameOffset: WORD;
    ImageName: array [0..255] of CHAR;
  end;
  TSystemModuleInformation = SYSTEM_MODULE_INFORMATION;
  PSystemModuleInformation = ^TSystemModuleInformation;

  SYSTEM_HANDLE_TYPE = (OB_TYPE_UNKNOWN,
		OB_TYPE_TYPE,
		OB_TYPE_DIRECTORY,
		OB_TYPE_SYMBOLIC_LINK,
		OB_TYPE_TOKEN,
		OB_TYPE_PROCESS,
		OB_TYPE_THREAD,
		OB_TYPE_UNKNOWN_7,
		OB_TYPE_EVENT,
		OB_TYPE_EVENT_PAIR,
		OB_TYPE_MUTANT,
		OB_TYPE_UNKNOWN_11,
		OB_TYPE_SEMAPHORE,
		OB_TYPE_TIMER,
		OB_TYPE_PROFILE,
		OB_TYPE_WINDOW_STATION,
		OB_TYPE_DESKTOP,
		OB_TYPE_SECTION,
		OB_TYPE_KEY,
		OB_TYPE_PORT,
		OB_TYPE_WAITABLE_PORT,
		OB_TYPE_UNKNOWN_21,
		OB_TYPE_UNKNOWN_22,
		OB_TYPE_UNKNOWN_23,
		OB_TYPE_UNKNOWN_24,
		//OB_TYPE_CONTROLLER,
		//OB_TYPE_DEVICE,
		//OB_TYPE_DRIVER,
		OB_TYPE_IO_COMPLETION,
		OB_TYPE_FILE);
  TSystemHandleType = SYSTEM_HANDLE_TYPE;

  SYSTEM_HANDLE_INFORMATION = record
    {ProcessId: ULONG;
    ObjectTypeNumber: UCHAR;
    Flags: UCHAR;  // 0x01 = PROTECT_FROM_CLOSE, 0x02 = INHERIT
    Handle: WORD;
    Object_: Pointer;
    GrantedAccess: ACCESS_MASK;}
    ProcessID: DWORD;
    HandleType: WORD;
    HandleNumber: WORD;
    KernelAddress: DWORD;
    Flags: DWORD;
  end;
  TSystemHandleInformation = SYSTEM_HANDLE_INFORMATION;
  PSystemHandleInformation = ^TSystemHandleInformation;

  {SYSTEM_OBJECT_TYPE_INFORMATION = record
    NextEntryOffset: ULONG;
    ObjectCount: ULONG;
    HandleCount: ULONG;
    TypeNumber: ULONG;
    InvalidAttributes: ULONG;
    GenericMapping: GENERIC_MAPPING;
    ValidAccessMask: ACCESS_MASK;
    PoolType: POOL_TYPE;
    Unknown: UCHAR;
    Name: UNICODE_STRING;
  end;
  TSystemObjectTypeInformation = SYSTEM_OBJECT_TYPE_INFORMATION;
  PSystemObjectTypeInformation = ^TSystemObjectTypeInformation;

  SYSTEM_OBJECT_INFORMATION = record
    NextEntryOffset: ULONG;
    Object_: PVOID;
    CreatorProcessId: ULONG;
    Unknown: USHORT;
    Flags: USHORT;
    PointerCount: ULONG;
    HandleCount: ULONG;
    PagedPoolUsage: ULONG;
    NonPagedPoolUsage: ULONG;
    ExclusiveProcessId: ULONG;
    SecurityDescriptor: PSECURITY_DESCRIPTOR;
    Name: UNICODE_STRING;
  end;
  TSystemObjectInformation = SYSTEM_OBJECT_INFORMATION;
  PSystemObjectInformation = ^TSystemObjectInformation;}

  OBJECT_BASIC_INFORMATION = record
    Attributes: ULONG;
    GrantedAccess: ACCESS_MASK;
    HandleCount: ULONG;
    PointerCount: ULONG;
    PagedPoolUsage: ULONG;
    NonPagedPoolUsage: ULONG;
    Reserved: array [0..2] of ULONG;
    NameInformationLength: ULONG;
    TypeInformationLength: ULONG;
    SecurityDescriptorLength: ULONG;
    CreateTime: LARGE_INTEGER;
  end;
  TObjectBasicInformation = OBJECT_BASIC_INFORMATION;
  PObjectBasicInformation = ^TObjectBasicInformation;

  OBJECT_TYPE_INFORMATION = record
    Name: UNICODE_STRING;
    ObjectCount: ULONG;
    HandleCount: ULONG;
    Reserved1: array [0..3] of ULONG;
    PeakObjectCount: ULONG;
    PeakHandleCount: ULONG;
    Reserved2: array [0..3] of ULONG;
    InvalidAttributes: ULONG;
    GenericMapping: GENERIC_MAPPING;
    ValidAccess: ULONG;
    Unknown: UCHAR;
    MaintainHandleDatabase: ByteBool;
    Reserved3: array [0..1] of UCHAR;
    PoolType: POOL_TYPE;
    PagedPoolUsage: ULONG;
    NonPagedPoolUsage: ULONG;
  end;
  TObjectTypeInformation = OBJECT_TYPE_INFORMATION;
  PObjectTypeInformation = ^TObjectTypeInformation;

  PROCESSINFOCLASS = (
    ProcessBasicInformation,
    ProcessQuotaLimits,
    ProcessIoCounters,
    ProcessVmCounters,
    ProcessTimes,
    ProcessBasePriority,
    ProcessRaisePriority,
    ProcessDebugPort,
    ProcessExceptionPort,
    ProcessAccessToken,
    ProcessLdtInformation,
    ProcessLdtSize,
    ProcessDefaultHardErrorMode,
    ProcessIoPortHandlers,          // Note: this is kernel mode only
    ProcessPooledUsageAndLimits,
    ProcessWorkingSetWatch,
    ProcessUserModeIOPL,
    ProcessEnableAlignmentFaultFixup,
    ProcessPriorityClass,
    ProcessWx86Information,
    ProcessHandleCount,
    ProcessAffinityMask,
    ProcessPriorityBoost,
    ProcessDeviceMap,
    ProcessSessionInformation,
    ProcessForegroundInformation,
    ProcessWow64Information,
    MaxProcessInfoClass);
  TProcessInfoClass = PROCESSINFOCLASS;

  PROCESS_BASIC_INFORMATION = record
    ExitStatus: DWORD;
    PebBaseAddress: PVOID;
    AffinityMask: DWORD;
    BasePriority: DWORD;
    UniqueProcessId: DWORD;
    InheritedFromUniqueProcessId: DWORD;
  end;
  TProcessBasicInformation = PROCESS_BASIC_INFORMATION;
  PProcessBasicInformation = ^TProcessBasicInformation;

  THREADINFOCLASS = (
    ThreadBasicInformation,
    ThreadTimes,
    ThreadPriority,
    ThreadBasePriority,
    ThreadAffinityMask,
    ThreadImpersonationToken,
    ThreadDescriptorTableEntry,
    ThreadEnableAlignmentFaultFixup,
    ThreadEventPair_Reusable,
    ThreadQuerySetWin32StartAddress,
    ThreadZeroTlsCell,
    ThreadPerformanceCount,
    ThreadAmILastThread,
    ThreadIdealProcessor,
    ThreadPriorityBoost,
    ThreadSetTlsArrayAddress,
    ThreadIsIoPending,
    ThreadHideFromDebugger,
    MaxThreadInfoClass);
  TThreadInfoClass = THREADINFOCLASS;

  THREAD_BASIC_INFORMATION = record
    ExitStatus: DWORD;
    TebBaseAddress: DWORD;
    ClientId: CLIENT_ID;
    AffinityMask: DWORD;
    Priority: DWORD;
    BasePriority: DWORD;
  end;
  TThreadBasicInformation = THREAD_BASIC_INFORMATION;
  PThreadBasicInformation = ^TThreadBasicInformation;

  TTokenUser = packed record
    User: TSIDAndAttributes;
  end;
  PTokenUser = ^TTokenUser;

  TTokenOwner = packed record
    Owner: PSID;
  end;
  PTokenOwner = ^TTokenOwner;

  TTokenPrimaryGroup = packed record
    PrimaryGroup: PSID;
  end;
  PTokenPrimaryGroup = ^TTokenPrimaryGroup;

  TTokenDefaultDACL = packed record
    DefaultDacl: PACL;
  end;
  PTokenDefaultDACL = ^TTokenDefaultDACL;

  {TTokenInformationClass = (TokenPad,TokenUser,TokenGroups,TokenPrivileges,TokenOwner,
                           TokenPrimaryGroup,TokenDefaultDacl,TokenSource,TokenType,
                           TokenImpersonationLevel,TokenStatistics,TokenRestrictedSids,
                           TokenSessionId);}

  TObjectAttributes = packed record
     Length: DWORD;
     RootDirectory: THandle;
     ObjectName: PUnicodeString;
     Attributes: DWORD;
     SecurityDescriptor: Pointer;// Points to type SECURITY_DESCRIPTOR
     SecurityQualityOfService: Pointer;// Points to type SECURITY_QUALITY_OF_SERVICE
  end;
  PObjectAttributes = ^TObjectAttributes;

  PLARGE_INTEGER = ^LARGE_INTEGER;

  IO_STATUS_BLOCK = record
    //union {
    Status: DWORD;
    //    PVOID Pointer;
    //}
    Information: DWORD;
  end;
  TIOStatusBlock = IO_STATUS_BLOCK;
  PIOStatusBlock = ^TIOStatusBlock;
  PIO_STATUS_BLOCK = ^IO_STATUS_BLOCK;

  FILE_INFORMATION_CLASS = (
    FileFiller0,
    FileDirectoryInformation,     // 1
    FileFullDirectoryInformation, // 2
    FileBothDirectoryInformation, // 3
    FileBasicInformation,         // 4  wdm
    FileStandardInformation,      // 5  wdm
    FileInternalInformation,      // 6
    FileEaInformation,            // 7
    FileAccessInformation,        // 8
    FileNameInformation,          // 9
    FileRenameInformation,        // 10
    FileLinkInformation,          // 11
    FileNamesInformation,         // 12
    FileDispositionInformation,   // 13
    FilePositionInformation,      // 14 wdm
    FileFullEaInformation,        // 15
    FileModeInformation,          // 16
    FileAlignmentInformation,     // 17
    FileAllInformation,           // 18
    FileAllocationInformation,    // 19
    FileEndOfFileInformation,     // 20 wdm
    FileAlternateNameInformation, // 21
    FileStreamInformation,        // 22
    FilePipeInformation,          // 23
    FilePipeLocalInformation,     // 24
    FilePipeRemoteInformation,    // 25
    FileMailslotQueryInformation, // 26
    FileMailslotSetInformation,   // 27
    FileCompressionInformation,   // 28
    FileObjectIdInformation,      // 29
    FileCompletionInformation,    // 30
    FileMoveClusterInformation,   // 31
    FileQuotaInformation,         // 32
    FileReparsePointInformation,  // 33
    FileNetworkOpenInformation,   // 34
    FileAttributeTagInformation,  // 35
    FileTrackingInformation,      // 36
    FileMaximumInformation);
  TFileInformationClass = FILE_INFORMATION_CLASS;

const
  ViewShare = 1;
  ViewUnmap = 2;

type
  SECTION_INHERIT = ViewShare..ViewUnmap;

  TNativeQueryInformationToken = function(TokenHandle: THandle;
                                          TokenInformationClass: TTokenInformationClass;
                                          TokenInformation :Pointer;
                                          TokenInformationLength :DWORD;
                                          ReturnLength :PDWORD): DWORD; stdcall;

  TNativeOpenProcessToken = function(ProcessHandle: THandle;
                                     DesiredAccess: DWORD;
                                     TokenHandle: PHandle) :DWORD; stdcall;

  TNativeOpenProcess = function(ProcessHandle: PHandle;
                                DesiredAccess: DWORD;
                                ObjectAttributes: PObjectAttributes;
                                ClientId: PClientID): DWORD; stdcall;

  TNativeOpenSection = function(SectionHandle: PHandle;
                                DesiredAccess: DWORD;
                                ObjectAttributes: PObjectAttributes): DWORD; stdcall;

  TNativeClose = function(Handle: THandle): DWORD; stdcall;

  TNativeQuerySystemInformation = function(SystemInformationClass: TSystemInformationClass;
                                           SystemInformation: Pointer;
                                           SystemInformationLength: DWORD;
                                           ReturnLength: PDWORD): DWORD; stdcall;
  TNativeCreateSection = function(SectionHandle: PHANDLE;
                                  DesiredAccess: ACCESS_MASK;
                                  ObjectAttributes: POBJECTATTRIBUTES;
                                  SectionSize: PLARGE_INTEGER;
                                  Protect: DWORD; Attributes: ULONG;
                                  FileHandle: THANDLE): DWORD; stdcall;
  TNativeMapViewOfSection = function(SectionHandle: THANDLE;
                                     ProcessHandle: THANDLE;
                                     BaseAddress: PPointer;
                                     ZeroBits: DWORD;
                                     CommitSize: DWORD;
                                     SectionOffset: PLARGE_INTEGER;
                                     ViewSize: PDWORD;
                                     InheritDisposition: SECTION_INHERIT;
                                     AllocationType: DWORD;
                                     Protect: DWORD): DWORD; stdcall;
  TNativeUnmapViewOfSection = function(ProcessHandle: THANDLE; BaseAddress: Pointer): DWORD; stdcall;
  TNativeOpenFile = function(FileHandle: PHANDLE;
                             DesiredAccess: ACCESS_MASK;
                             ObjectAttributes: POBJECTATTRIBUTES;
                             IoStatusBlock: PIOSTATUSBLOCK;
                             ShareAccess: DWORD;
                             OpenOptions: DWORD): DWORD; stdcall;
  TNativeCreateFile = function (FileHandle: PHANDLE;
                                DesiredAccess: ACCESS_MASK;
                                ObjectAttributes: POBJECTATTRIBUTES;
                                IoStatusBlock: PIOSTATUSBLOCK;
                                AllocationSize: PLARGE_INTEGER;
                                FileAttributes: DWORD;
                                ShareAccess: DWORD;
                                CreateDisposition: DWORD;
                                CreateOptions: DWORD;
                                EaBuffer: Pointer;
                                EaLength: DWORD): DWORD; stdcall;
  TNativeQueryObject = function (ObjectHandle: THANDLE;
                                 ObjectInformationClass:
                                 OBJECT_INFORMATION_CLASS;
                                 ObjectInformation: PVOID;
                                 ObjectInformationLength: ULONG;
                                 ReturnLength: PULONG): DWORD; stdcall;
  TNativeQueryInformationProcess = function (ProcessHandle: HANDLE;
                                             ProcessInformationClass: PROCESSINFOCLASS;
                                             ProcessInformation: PVOID;
                                             ProcessInformationLength: ULONG;
                                             ReturnLength: PULONG): DWORD; stdcall;
  TNativeQueryInformationThread = function(ThreadHandle: HANDLE;
                                           ThreadInformationClass: THREADINFOCLASS;
                                           ThreadInformation: PVOID;
                                           ThreadInformationLength: ULONG;
                                           ReturnLength: PULONG): DWORD; stdcall;
  TNativeQueryInformationFile = function(FileHandle: HANDLE;
                                         IoStatusBlock: PIO_STATUS_BLOCK;
                                         FileInformation: PVOID;
                                         FileInformationLength: ULONG;
                                         FileInformationClass: FILE_INFORMATION_CLASS): DWORD; stdcall;
  TNativeDuplicateObject = function(SourceProcessHandle: HANDLE;
                                    SourceHandle: HANDLE;
                                    TargetProcessHandle: HANDLE;
                                    TargetHandle: PHANDLE;
                                    DesiredAccess: ACCESS_MASK;
                                    Attributes: ULONG;
                                    Options: ULONG): DWORD; stdcall;

const
  NTDLL_DLL = 'NTDLL.DLL';

  STATUS_SUCCESS = $00000000;
  STATUS_UNSUCCESSFUL = $C0000001;
  STATUS_INFO_LENGTH_MISMATCH = $C0000004;
  STATUS_BUFFER_OVERFLOW = $80000005;
  STATUS_INVALID_HANDLE = $C0000008;
  STATUS_DATATYPE_MISALIGNMENT = $80000002;

  //Valid values for the Attributes field
  OBJ_INHERIT = $00000002;
  OBJ_PERMANENT = $00000010;
  OBJ_EXCLUSIVE = $00000020;
  OBJ_CASE_INSENSITIVE = $00000040;
  OBJ_OPENIF = $00000080;
  OBJ_OPENLINK = $00000100;
  OBJ_VALID_ATTRIBUTES = $000001F2;


var
  NTDLLHandle: THandle = 0;

  NtOpenSection: TNativeOpenSection = nil;
  NtClose: TNativeClose = nil;
  NtQueryInformationToken: TNativeQueryInformationToken = nil;
  NtOpenProcessToken: TNativeOpenProcessToken = nil;
  NtOpenProcess: TNativeOpenProcess = nil;
  NtQuerySystemInformation: TNativeQuerySystemInformation = nil;
  NtCreateSection: TNativeCreateSection = nil;
  NtMapViewOfSection: TNativeMapViewOfSection = nil;
  NtUnmapViewOfSection: TNativeUnmapViewOfSection = nil;
  NtCreateFile: TNativeCreateFile = nil;
  NtOpenFile: TNativeOpenFile = nil;
  NtQueryObject: TNativeQueryObject = nil;
  NtQueryInformationProcess: TNativeQueryInformationProcess = nil;
  NtQueryInformationThread: TNativeQueryInformationThread = nil;
  NtQueryInformationFile: TNativeQueryInformationFile = nil;
  NtDuplicateObject: TNativeDuplicateObject = nil;

function InitNativeAPI: boolean;
procedure FreeNativeAPI;

const
  cKWaitReason: array[TKWaitReason] of string = (
    'Executive',
    'FreePage',
    'PageIn',
    'PoolAllocation',
    'DelayExecution',
    'Suspended',
    'UserRequest',
    'WrExecutive',
    'WrFreePage',
    'WrPageIn',
    'WrPoolAllocation',
    'WrDelayExecution',
    'WrSuspended',
    'WrUserRequest',
    'WrEventPair',
    'WrQueue',
    'WrLpcReceive',
    'WrLpcReply',
    'WrVirtualMemory',
    'WrPageOut',
    'WrRendezvous',
    'Spare2',
    'Spare3',
    'Spare4',
    'Spare5',
    'Spare6',
    'WrKernel',
    'MaximumWaitReason');

  cThreadState: array[TThreadState] of string = (
    'Initialized',
    'Ready',
    'Running',
    'Standby',
    'Terminated',
    'Wait',
    'Transition',
    'Unknown');

  cSystemHandleType: array[TSystemHandleType] of string =
                ('Unknown',
		'Type',
		'Directory',
		'Symbolic Link',
		'Token',
		'Process',
		'Thread',
		'Unknown 7',
		'Event',
		'Event Pair',
		'Mutant',
		'Unknown 11',
		'Semaphore',
		'Timer',
		'Profile',
		'Window Station',
		'Desktop',
		'Section',
		'Key',
		'Port',
		'Waitable Port',
		'Unknown 21',
		'Unknown 22',
		'Unknown 23',
		'Unknown 24',
		//OB_TYPE_CONTROLLER,
		//OB_TYPE_DEVICE,
		//OB_TYPE_DRIVER,
	        'I/O Completion',
		'File');


implementation

function InitNativeAPI;
begin
  if Win32Platform=VER_PLATFORM_WIN32_NT then begin
    NTDLLHandle:=GetModuleHandle(NTDLL_DLL);
    if NTDLLHandle=0 then
      NTDLLHandle:=LoadLibrary(NTDLL_DLL);
    if NTDLLHandle<>0 then begin
      @NtQueryInformationToken:=GetProcAddress(NTDLLHandle,'NtQueryInformationToken');
      @NtOpenProcessToken:=GetProcAddress(NTDLLHandle,'NtOpenProcessToken');
      @NtOpenSection:=GetProcAddress(NTDLLHandle,'NtOpenSection');
      @NtClose:=GetProcAddress(NTDLLHandle,'NtClose');
      @NtOpenProcess:=GetProcAddress(NTDLLHandle,'NtOpenProcess');
      @NtQuerySystemInformation:=GetProcAddress(NTDLLHandle,'NtQuerySystemInformation');
      @NtCreateSection:=GetProcAddress(NTDLLHandle,'NtCreateSection');
      @NtMapViewOfSection:=GetProcAddress(NTDLLHandle,'NtMapViewOfSection');
      @NtUnmapViewOfSection:=GetProcAddress(NTDLLHandle,'NtUnmapViewOfSection');
      @NtOpenFile:=GetProcAddress(NTDLLHandle,'NtOpenFile');
      @NtCreateFile:=GetProcAddress(NTDLLHandle,'NtCreateFile');
      @NtQueryObject:=GetProcAddress(NTDLLHandle,'NtQueryObject');
      @NtQueryInformationProcess:=GetProcAddress(NTDLLHandle,'NtQueryInformationProcess');
      @NtQueryInformationThread:=GetProcAddress(NTDLLHandle,'NtQueryInformationThread');
      @NtQueryInformationFile:=GetProcAddress(NTDLLHandle,'NtQueryInformationFile');
      @NtDuplicateObject:=GetProcAddress(NTDLLHandle,'NtDuplicateObject');
    end;
  end;
  Result:=(NTDLLHandle<>0) and Assigned(NtQueryObject);
end;

procedure FreeNativeAPI;
begin
  if NTDLLHandle<>0 then begin
    if not FreeLibrary(NTDLLHandle) then
      Exception.Create('Unload Error: '+NTDLL_DLL+' ('+inttohex(getmodulehandle(NTDLL_DLL),8)+')')
    else
      NTDLLHandle:=0;
  end;
end;

initialization
finalization
  FreeNativeAPI;
end.

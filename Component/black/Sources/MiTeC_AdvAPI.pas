{*******************************************************}
{                                                       }
{       MiTeC System Information Component              }
{          Windows ADV API Interface Unit               }
{           version 8.6.3 for Delphi 5,6,7                }
{                                                       }
{       Copyright © 1997,2004 Michal Mutl               }
{                                                       }
{*******************************************************}

{$INCLUDE MITEC_DEF.INC}

unit MiTeC_AdvAPI;

{$ALIGN ON}
{$MINENUMSIZE 4}

interface

uses Classes, Windows, SysUtils;

//
// Constants
//

const

//
// Service database names
//
  SERVICES_ACTIVE_DATABASEA     = 'ServicesActive';
  SERVICES_ACTIVE_DATABASEW     = 'ServicesActive';
  SERVICES_ACTIVE_DATABASE = SERVICES_ACTIVE_DATABASEA;
  SERVICES_FAILED_DATABASEA     = 'ServicesFailed';
  SERVICES_FAILED_DATABASEW     = 'ServicesFailed';
  SERVICES_FAILED_DATABASE = SERVICES_FAILED_DATABASEA;

//
// Character to designate that a name is a group
//
  SC_GROUP_IDENTIFIERA          = '+';
  SC_GROUP_IDENTIFIERW          = '+';
  SC_GROUP_IDENTIFIER = SC_GROUP_IDENTIFIERA;

//
// Value to indicate no change to an optional parameter
//
  SERVICE_NO_CHANGE              = $FFFFFFFF;

//
// Service State -- for Enum Requests (Bit Mask)
//
  SERVICE_ACTIVE                 = $00000001;
  SERVICE_INACTIVE               = $00000002;
  SERVICE_STATE_ALL              = (SERVICE_ACTIVE   or
                                    SERVICE_INACTIVE);

//
// Controls
//
  SERVICE_CONTROL_STOP           = $00000001;
  SERVICE_CONTROL_PAUSE          = $00000002;
  SERVICE_CONTROL_CONTINUE       = $00000003;
  SERVICE_CONTROL_INTERROGATE    = $00000004;
  SERVICE_CONTROL_SHUTDOWN       = $00000005;

//
// Service State -- for CurrentState
//
  SERVICE_STOPPED                = $00000001;
  SERVICE_START_PENDING          = $00000002;
  SERVICE_STOP_PENDING           = $00000003;
  SERVICE_RUNNING                = $00000004;
  SERVICE_CONTINUE_PENDING       = $00000005;
  SERVICE_PAUSE_PENDING          = $00000006;
  SERVICE_PAUSED                 = $00000007;

//
// Controls Accepted  (Bit Mask)
//
  SERVICE_ACCEPT_STOP            = $00000001;
  SERVICE_ACCEPT_PAUSE_CONTINUE  = $00000002;
  SERVICE_ACCEPT_SHUTDOWN        = $00000004;

//
// Service Control Manager object specific access types
//
  SC_MANAGER_CONNECT             = $0001;
  SC_MANAGER_CREATE_SERVICE      = $0002;
  SC_MANAGER_ENUMERATE_SERVICE   = $0004;
  SC_MANAGER_LOCK                = $0008;
  SC_MANAGER_QUERY_LOCK_STATUS   = $0010;
  SC_MANAGER_MODIFY_BOOT_CONFIG  = $0020;

  SC_MANAGER_ALL_ACCESS          = (STANDARD_RIGHTS_REQUIRED or
                                    SC_MANAGER_CONNECT or
                                    SC_MANAGER_CREATE_SERVICE or
                                    SC_MANAGER_ENUMERATE_SERVICE or
                                    SC_MANAGER_LOCK or
                                    SC_MANAGER_QUERY_LOCK_STATUS or
                                    SC_MANAGER_MODIFY_BOOT_CONFIG);

//
// Service object specific access type
//
  SERVICE_QUERY_CONFIG           = $0001;
  SERVICE_CHANGE_CONFIG          = $0002;
  SERVICE_QUERY_STATUS           = $0004;
  SERVICE_ENUMERATE_DEPENDENTS   = $0008;
  SERVICE_START                  = $0010;
  SERVICE_STOP                   = $0020;
  SERVICE_PAUSE_CONTINUE         = $0040;
  SERVICE_INTERROGATE            = $0080;
  SERVICE_USER_DEFINED_CONTROL   = $0100;

  SERVICE_ALL_ACCESS             = (STANDARD_RIGHTS_REQUIRED or
                                    SERVICE_QUERY_CONFIG or
                                    SERVICE_CHANGE_CONFIG or
                                    SERVICE_QUERY_STATUS or
                                    SERVICE_ENUMERATE_DEPENDENTS or
                                    SERVICE_START or
                                    SERVICE_STOP or
                                    SERVICE_PAUSE_CONTINUE or
                                    SERVICE_INTERROGATE or
                                    SERVICE_USER_DEFINED_CONTROL);

  SERVICE_KERNEL_DRIVER       = $00000001;
  SERVICE_FILE_SYSTEM_DRIVER  = $00000002;
  SERVICE_ADAPTER             = $00000004;
  SERVICE_RECOGNIZER_DRIVER   = $00000008;

  SERVICE_DRIVER              =
    (SERVICE_KERNEL_DRIVER or
     SERVICE_FILE_SYSTEM_DRIVER or
     SERVICE_RECOGNIZER_DRIVER);

  SERVICE_WIN32_OWN_PROCESS   = $00000010;
  SERVICE_WIN32_SHARE_PROCESS = $00000020;
  SERVICE_WIN32               =
    (SERVICE_WIN32_OWN_PROCESS or
     SERVICE_WIN32_SHARE_PROCESS);

  SERVICE_INTERACTIVE_PROCESS = $00000100;

  SERVICE_TYPE_ALL            =
    (SERVICE_WIN32 or
     SERVICE_ADAPTER or
     SERVICE_DRIVER  or
     SERVICE_INTERACTIVE_PROCESS);

  SERVICE_BOOT_START = 0;
  SERVICE_SYSTEM_START =1;
  SERVICE_AUTO_START = 2;
  SERVICE_DEMAND_START = 3;
  SERVICE_DISABLED = 4;


type

//
// Handle Types
//

  SC_HANDLE = THandle;
  LPSC_HANDLE = ^SC_HANDLE;

  SERVICE_STATUS_HANDLE = DWORD;

//
// pointer to string pointer
//

  PLPSTRA = ^PAnsiChar;
  PLPSTRW = ^PWideChar;
  PLPSTR = PLPSTRA;

//
// Service Status Structure
//

  PServiceStatus = ^TServiceStatus;
  TServiceStatus = record
    dwServiceType: DWORD;
    dwCurrentState: DWORD;
    dwControlsAccepted: DWORD;
    dwWin32ExitCode: DWORD;
    dwServiceSpecificExitCode: DWORD;
    dwCheckPoint: DWORD;
    dwWaitHint: DWORD;
  end;

//
// Service Status Enumeration Structure
//
  PEnumServiceStatusA = ^TEnumServiceStatusA;
  PEnumServiceStatusW = ^TEnumServiceStatusW;
  PEnumServiceStatus = PEnumServiceStatusA;
  TEnumServiceStatusA = record
    lpServiceName: PAnsiChar;
    lpDisplayName: PAnsiChar;
    ServiceStatus: TServiceStatus;
  end;
  TEnumServiceStatusW = record
    lpServiceName: PWideChar;
    lpDisplayName: PWideChar;
    ServiceStatus: TServiceStatus;
  end;
  TEnumServiceStatus = TEnumServiceStatusA;

//
// Structures for the Lock API functions
//
  SC_LOCK = Pointer;
  PQueryServiceLockStatusA = ^TQueryServiceLockStatusA;
  PQueryServiceLockStatusW = ^TQueryServiceLockStatusW;
  PQueryServiceLockStatus = PQueryServiceLockStatusA;
  TQueryServiceLockStatusA = record
    fIsLocked: DWORD;
    lpLockOwner: PAnsiChar;
    dwLockDuration: DWORD;
  end;
  TQueryServiceLockStatusW = record
    fIsLocked: DWORD;
    lpLockOwner: PWideChar;
    dwLockDuration: DWORD;
  end;
  TQueryServiceLockStatus = TQueryServiceLockStatusA;

//
// Query Service Configuration Structure
//
  PQueryServiceConfigA = ^TQueryServiceConfigA;
  PQueryServiceConfigW = ^TQueryServiceConfigW;
  PQueryServiceConfig = PQueryServiceConfigA;
  TQueryServiceConfigA = record
    dwServiceType: DWORD;
    dwStartType: DWORD;
    dwErrorControl: DWORD;
    lpBinaryPathName: PAnsiChar;
    lpLoadOrderGroup: PAnsiChar;
    dwTagId: DWORD;
    lpDependencies: PAnsiChar;
    lpServiceStartName: PAnsiChar;
    lpDisplayName: PAnsiChar;
  end;

  TQueryServiceConfigW = record
    dwServiceType: DWORD;
    dwStartType: DWORD;
    dwErrorControl: DWORD;
    lpBinaryPathName: PWideChar;
    lpLoadOrderGroup: PWideChar;
    dwTagId: DWORD;
    lpDependencies: PWideChar;
    lpServiceStartName: PWideChar;
    lpDisplayName: PWideChar;
  end;
  TQueryServiceConfig = TQueryServiceConfigA;

//
// Function Prototype for the Service Main Function
//

  TServiceMainFunctionA = TFarProc;
  TServiceMainFunctionW = TFarProc;
  TServiceMainFunction = TServiceMainFunctionA;

//
// Service Start Table
//
  PServiceTableEntryA = ^TServiceTableEntryA;
  PServiceTableEntryW = ^TServiceTableEntryW;
  PServiceTableEntry = PServiceTableEntryA;
  TServiceTableEntryA = record
    lpServiceName: PAnsiChar;
    lpServiceProc: TServiceMainFunctionA;
  end;
  TServiceTableEntryW = record
    lpServiceName: PWideChar;
    lpServiceProc: TServiceMainFunctionW;
  end;
  TServiceTableEntry = TServiceTableEntryA;

  THandlerFunction = TFarProc;

  TChangeServiceConfigA = function (hService: SC_HANDLE; dwServiceType, dwStartType,
    dwErrorControl: DWORD; lpBinaryPathName, lpLoadOrderGroup: PAnsiChar;
    lpdwTagId: LPDWORD; lpDependencies, lpServiceStartName, lpPassword,
    lpDisplayName: PAnsiChar): BOOL; stdcall;
  TChangeServiceConfigW = function (hService: SC_HANDLE; dwServiceType, dwStartType,
    dwErrorControl: DWORD; lpBinaryPathName, lpLoadOrderGroup: PWideChar;
    lpdwTagId: LPDWORD; lpDependencies, lpServiceStartName, lpPassword,
    lpDisplayName: PWideChar): BOOL; stdcall;
  TChangeServiceConfig = function (hService: SC_HANDLE; dwServiceType, dwStartType,
    dwErrorControl: DWORD; lpBinaryPathName, lpLoadOrderGroup: PChar;
    lpdwTagId: LPDWORD; lpDependencies, lpServiceStartName, lpPassword,
    lpDisplayName: PChar): BOOL; stdcall;
  TCloseServiceHandle = function (hSCObject: SC_HANDLE): BOOL; stdcall;
  TControlService = function (hService: SC_HANDLE; dwControl: DWORD;
    lpServiceStatus: PServiceStatus): BOOL; stdcall;
  TCreateServiceA = function (hSCManager: SC_HANDLE; lpServiceName, lpDisplayName: PAnsiChar;
    dwDesiredAccess, dwServiceType, dwStartType, dwErrorControl: DWORD;
    lpBinaryPathName, lpLoadOrderGroup: PAnsiChar; lpdwTagId: LPDWORD; lpDependencies,
    lpServiceStartName, lpPassword: PAnsiChar): SC_HANDLE; stdcall;
  TCreateServiceW = function (hSCManager: SC_HANDLE; lpServiceName, lpDisplayName: PWideChar;
    dwDesiredAccess, dwServiceType, dwStartType, dwErrorControl: DWORD;
    lpBinaryPathName, lpLoadOrderGroup: PWideChar; lpdwTagId: LPDWORD; lpDependencies,
    lpServiceStartName, lpPassword: PWideChar): SC_HANDLE; stdcall;
  TCreateService = function (hSCManager: SC_HANDLE; lpServiceName, lpDisplayName: PChar;
    dwDesiredAccess, dwServiceType, dwStartType, dwErrorControl: DWORD;
    lpBinaryPathName, lpLoadOrderGroup: PChar; lpdwTagId: LPDWORD; lpDependencies,
    lpServiceStartName, lpPassword: PChar): SC_HANDLE; stdcall;
  TDeleteService = function (hService: SC_HANDLE): BOOL; stdcall;
  TEnumDependentServicesA = function (hService: SC_HANDLE; dwServiceState: DWORD;
    var lpServices: TEnumServiceStatusA; cbBufSize: DWORD; var pcbBytesNeeded,
    lpServicesReturned : DWORD): BOOL; stdcall;
  TEnumDependentServicesW = function (hService: SC_HANDLE; dwServiceState: DWORD;
    var lpServices: TEnumServiceStatusW; cbBufSize: DWORD; var pcbBytesNeeded,
    lpServicesReturned : DWORD): BOOL; stdcall;
  TEnumDependentServices = function (hService: SC_HANDLE; dwServiceState: DWORD;
    var lpServices: TEnumServiceStatus; cbBufSize: DWORD; var pcbBytesNeeded,
    lpServicesReturned : DWORD): BOOL; stdcall;
  TEnumServicesStatusA = function (hSCManager: SC_HANDLE; dwServiceType,
    dwServiceState: DWORD; var lpServices: TEnumServiceStatusA; cbBufSize: DWORD;
    var pcbBytesNeeded, lpServicesReturned, lpResumeHandle: DWORD): BOOL; stdcall;
  TEnumServicesStatusW = function (hSCManager: SC_HANDLE; dwServiceType,
    dwServiceState: DWORD; var lpServices: TEnumServiceStatusW; cbBufSize: DWORD;
    var pcbBytesNeeded, lpServicesReturned, lpResumeHandle: DWORD): BOOL; stdcall;
  TEnumServicesStatus = function (hSCManager: SC_HANDLE; dwServiceType,
    dwServiceState: DWORD; var lpServices: TEnumServiceStatus; cbBufSize: DWORD;
    var pcbBytesNeeded, lpServicesReturned, lpResumeHandle: DWORD): BOOL; stdcall;
  TGetServiceKeyNameA = function (hSCManager: SC_HANDLE; lpDisplayName,
    lpServiceName: PAnsiChar; var lpcchBuffer: DWORD): BOOL; stdcall;
  TGetServiceKeyNameW = function (hSCManager: SC_HANDLE; lpDisplayName,
    lpServiceName: PWideChar; var lpcchBuffer: DWORD): BOOL; stdcall;
  TGetServiceKeyName = function (hSCManager: SC_HANDLE; lpDisplayName,
    lpServiceName: PChar; var lpcchBuffer: DWORD): BOOL; stdcall;
  TGetServiceDisplayNameA = function (hSCManager: SC_HANDLE; lpServiceName,
    lpDisplayName: PAnsiChar; var lpcchBuffer: DWORD): BOOL; stdcall;
  TGetServiceDisplayNameW = function (hSCManager: SC_HANDLE; lpServiceName,
    lpDisplayName: PWideChar; var lpcchBuffer: DWORD): BOOL; stdcall;
  TGetServiceDisplayName = function (hSCManager: SC_HANDLE; lpServiceName,
    lpDisplayName: PChar; var lpcchBuffer: DWORD): BOOL; stdcall;
  TLockServiceDatabase = function (hSCManager: SC_HANDLE): SC_LOCK; stdcall;
  TNotifyBootConfigStatus = function (BootAcceptable: BOOL): BOOL; stdcall;
  TOpenSCManagerA = function (lpMachineName, lpDatabaseName: PAnsiChar;
    dwDesiredAccess: DWORD): SC_HANDLE; stdcall;
  TOpenSCManagerW = function (lpMachineName, lpDatabaseName: PWideChar;
    dwDesiredAccess: DWORD): SC_HANDLE; stdcall;
  TOpenSCManager = function (lpMachineName, lpDatabaseName: PChar;
    dwDesiredAccess: DWORD): SC_HANDLE; stdcall;
  TOpenServiceA = function (hSCManager: SC_HANDLE; lpServiceName: PAnsiChar;
    dwDesiredAccess: DWORD): SC_HANDLE; stdcall;
  TOpenServiceW = function (hSCManager: SC_HANDLE; lpServiceName: PWideChar;
    dwDesiredAccess: DWORD): SC_HANDLE; stdcall;
  TOpenService = function (hSCManager: SC_HANDLE; lpServiceName: PChar;
    dwDesiredAccess: DWORD): SC_HANDLE; stdcall;
  TfQueryServiceConfigA = function (hService: SC_HANDLE;
    lpServiceConfig: PQueryServiceConfigA; cbBufSize: DWORD;
    pcbBytesNeeded: PDWORD): BOOL; stdcall;
  TfQueryServiceConfigW = function (hService: SC_HANDLE;
    lpServiceConfig: PQueryServiceConfigW; cbBufSize: DWORD;
    pcbBytesNeeded: PDWORD): BOOL; stdcall;
  TfQueryServiceConfig = function (hService: SC_HANDLE;
    lpServiceConfig: PQueryServiceConfig; cbBufSize: DWORD;
    pcbBytesNeeded: PDWORD): BOOL; stdcall;
  TfQueryServiceLockStatusA = function (hSCManager: SC_HANDLE;
    var lpLockStatus: TQueryServiceLockStatusA; cbBufSize: DWORD;
    var pcbBytesNeeded: DWORD): BOOL; stdcall;
  TfQueryServiceLockStatusW = function (hSCManager: SC_HANDLE;
    var lpLockStatus: TQueryServiceLockStatusW; cbBufSize: DWORD;
    var pcbBytesNeeded: DWORD): BOOL; stdcall;
  TfQueryServiceLockStatus = function (hSCManager: SC_HANDLE;
    var lpLockStatus: TQueryServiceLockStatus; cbBufSize: DWORD;
    var pcbBytesNeeded: DWORD): BOOL; stdcall;
  TQueryServiceObjectSecurity = function (hService: SC_HANDLE;
    dwSecurityInformation: SECURITY_INFORMATION;
    lpSecurityDescriptor: PSECURITY_DESCRIPTOR; cbBufSize: DWORD;
    var pcbBytesNeeded: DWORD): BOOL; stdcall;
  TQueryServiceStatus = function (hService: SC_HANDLE; var
    lpServiceStatus: TServiceStatus): BOOL; stdcall;
  TRegisterServiceCtrlHandlerA = function (lpServiceName: PAnsiChar;
    lpHandlerProc: ThandlerFunction): SERVICE_STATUS_HANDLE; stdcall;
  TRegisterServiceCtrlHandlerW = function (lpServiceName: PWideChar;
    lpHandlerProc: ThandlerFunction): SERVICE_STATUS_HANDLE; stdcall;
  TRegisterServiceCtrlHandler = function (lpServiceName: PChar;
    lpHandlerProc: ThandlerFunction): SERVICE_STATUS_HANDLE; stdcall;
  TSetServiceObjectSecurity = function (hService: SC_HANDLE;
    dwSecurityInformation: SECURITY_INFORMATION;
    lpSecurityDescriptor: PSECURITY_DESCRIPTOR): BOOL; stdcall;
  TSetServiceStatus = function (hServiceStatus: SERVICE_STATUS_HANDLE;
    var lpServiceStatus: TServiceStatus): BOOL; stdcall;
  TStartServiceCtrlDispatcherA = function (
    var lpServiceStartTable: TServiceTableEntryA): BOOL; stdcall;
  TStartServiceCtrlDispatcherW = function (
    var lpServiceStartTable: TServiceTableEntryW): BOOL; stdcall;
  TStartServiceCtrlDispatcher = function (
    var lpServiceStartTable: TServiceTableEntry): BOOL; stdcall;
  TStartServiceA = function (hService: SC_HANDLE; dwNumServiceArgs: DWORD;
    var lpServiceArgVectors: PAnsiChar): BOOL; stdcall;
  TStartServiceW = function (hService: SC_HANDLE; dwNumServiceArgs: DWORD;
    var lpServiceArgVectors: PWideChar): BOOL; stdcall;
  TStartService = function (hService: SC_HANDLE; dwNumServiceArgs: DWORD;
    var lpServiceArgVectors: PChar): BOOL; stdcall;
  TUnlockServiceDatabase = function (ScLock: SC_LOCK): BOOL; stdcall;

  TServiceType = (svcKernelDriver, svcFileSystemDriver, svcAdapter,svcRecognizerDriver,
                  svcOwnProcess, svcSharedProcess, svcDesktopInteractiveDriver);

function InitADVAPI :boolean;
procedure FreeADVAPI;

function ServiceGetStatus(sMachine,sService :string ) :DWord;
function ServiceRunning(sMachine,sService :string ) :boolean;
function ServiceStopped(sMachine,sService :string ) :boolean;
function ServiceStart(sMachine,sService,sArgs :string ) :boolean;
function ServiceStop(sMachine,sService :string ) :boolean;
function ServicePause(sMachine,sService :string ) :boolean;
function ServiceContinue(sMachine,sService :string ) :Boolean;
function ServiceGetKeyName(sMachine,sServiceDispName :string ) :string;
function ServiceGetDisplayName(sMachine,sServiceKeyName :string ) :string;

function ServiceGetList(sMachine :string; dwServiceType,dwServiceState :DWord; slServicesList :TStrings ) :boolean;
function ServiceGetConfig(sMachine,sService :string; var QSC: TQueryServiceConfig) :boolean;

var
  ChangeServiceConfigA: TChangeServiceConfigA = nil;
  ChangeServiceConfigW: TChangeServiceConfigW = nil;
  ChangeServiceConfig: TChangeServiceConfig = nil;
  CloseServiceHandle: TCloseServiceHandle = nil;
  ControlService: TControlService = nil;
  CreateServiceA: TCreateServiceA = nil;
  CreateServiceW: TCreateServiceW = nil;
  CreateService: TCreateService = nil;
  DeleteService: TDeleteService = nil;
  EnumDependentServicesA: TEnumDependentServicesA = nil;
  EnumDependentServicesW: TEnumDependentServicesW = nil;
  EnumDependentServices: TEnumDependentServices = nil;
  EnumServicesStatusA: TEnumServicesStatusA = nil;
  EnumServicesStatusW: TEnumServicesStatusW = nil;
  EnumServicesStatus: TEnumServicesStatus = nil;
  GetServiceKeyNameA: TGetServiceKeyNameA = nil;
  GetServiceKeyNameW: TGetServiceKeyNameW = nil;
  GetServiceKeyName: TGetServiceKeyName = nil;
  GetServiceDisplayNameA: TGetServiceDisplayNameA = nil;
  GetServiceDisplayNameW: TGetServiceDisplayNameW = nil;
  GetServiceDisplayName: TGetServiceDisplayName = nil;
  LockServiceDatabase: TLockServiceDatabase = nil;
  NotifyBootConfigStatus: TNotifyBootConfigStatus = nil;
  OpenSCManagerA: TOpenSCManagerA = nil;
  OpenSCManagerW: TOpenSCManagerW = nil;
  OpenSCManager: TOpenSCManager = nil;
  OpenServiceA: TOpenServiceA = nil;
  OpenServiceW: TOpenServiceW = nil;
  OpenService: TOpenService = nil;
  QueryServiceConfigA: TfQueryServiceConfigA = nil;
  QueryServiceConfigW: TfQueryServiceConfigW = nil;
  QueryServiceConfig: TfQueryServiceConfig = nil;
  QueryServiceLockStatusA: TfQueryServiceLockStatusA = nil;
  QueryServiceLockStatusW: TfQueryServiceLockStatusW = nil;
  QueryServiceLockStatus: TfQueryServiceLockStatus = nil;
  QueryServiceObjectSecurity: TQueryServiceObjectSecurity = nil;
  QueryServiceStatus: TQueryServiceStatus = nil;
  RegisterServiceCtrlHandlerA: TRegisterServiceCtrlHandlerA = nil;
  RegisterServiceCtrlHandlerW: TRegisterServiceCtrlHandlerW = nil;
  RegisterServiceCtrlHandler: TRegisterServiceCtrlHandler = nil;
  SetServiceObjectSecurity: TSetServiceObjectSecurity = nil;
  SetServiceStatus: TSetServiceStatus = nil;
  StartServiceCtrlDispatcherA: TStartServiceCtrlDispatcherA = nil;
  StartServiceCtrlDispatcherW: TStartServiceCtrlDispatcherW = nil;
  StartServiceCtrlDispatcher: TStartServiceCtrlDispatcher = nil;
  StartServiceA: TStartServiceA = nil;
  StartServiceW: TStartServiceW = nil;
  StartService: TStartService = nil;
  UnlockServiceDatabase: TUnlockServiceDatabase = nil;

const
  cSvcStartup: array[SERVICE_BOOT_START..SERVICE_DISABLED] of string = (
     'Boot',
     'System',
     'Automatic',
     'Manual',
     'Disabled');

  cSvcStatus: array[SERVICE_STOPPED..SERVICE_PAUSED] of string = (
      'Stopped',
      'Start/Pending',
      'Stop/Pending',
      'Running',
      'Continue/Pending',
      'Pause/Pending',
      'Paused');

  cSvcErrorControl: array[0..1] of string = (
      'Ignore',
      'Normal');

  cSvcType: array[TServiceType] of string = (
      'Kernel Driver',
      'File System Driver',
      'Adapter',
      'Recognizer Driver',
      'Own Process',
      'Shared Process',
      'Desktop Interactive Driver');

implementation

uses MiTeC_StrUtils;

const
  AdvAPI_DLL = 'advapi32.dll';

var
  ADVAPIHandle :THandle;

function InitADVAPI: Boolean;
begin
  ADVAPIHandle:=GetModuleHandle(ADVAPI_DLL);
  if ADVAPIHandle=0 then
    ADVAPIHandle:=LoadLibrary(advapi_dll);
  if ADVAPIHandle<>0 then begin
    ChangeServiceConfigA:=getprocaddress(ADVAPIHandle,pchar('ChangeServiceConfigA'));
    ChangeServiceConfigW:=getprocaddress(ADVAPIHandle,pchar('ChangeServiceConfigW'));
    ChangeServiceConfig:=getprocaddress(ADVAPIHandle,pchar('ChangeServiceConfigA'));
    CloseServiceHandle:=getprocaddress(ADVAPIHandle,pchar('CloseServiceHandle'));
    ControlService:=getprocaddress(ADVAPIHandle,pchar('ControlService'));
    CreateServiceA:=getprocaddress(ADVAPIHandle,pchar('CreateServiceA'));
    CreateServiceW:=getprocaddress(ADVAPIHandle,pchar('CreateServiceW'));
    CreateService:=getprocaddress(ADVAPIHandle,pchar('CreateService'));
    DeleteService:=getprocaddress(ADVAPIHandle,pchar('DeleteService'));
    EnumDependentServicesA:=getprocaddress(ADVAPIHandle,pchar('EnumDependentServicesA'));
    EnumDependentServicesW:=getprocaddress(ADVAPIHandle,pchar('EnumDependentServicesW'));
    EnumDependentServices:=getprocaddress(ADVAPIHandle,pchar('EnumDependentServicesA'));
    EnumServicesStatusA:=getprocaddress(ADVAPIHandle,pchar('EnumServicesStatusA'));
    EnumServicesStatusW:=getprocaddress(ADVAPIHandle,pchar('EnumServicesStatusW'));
    EnumServicesStatus:=getprocaddress(ADVAPIHandle,pchar('EnumServicesStatusA'));
    GetServiceKeyNameA:=getprocaddress(ADVAPIHandle,pchar('GetServiceKeyNameA'));
    GetServiceKeyNameW:=getprocaddress(ADVAPIHandle,pchar('GetServiceKeyNameW'));
    GetServiceKeyName:=getprocaddress(ADVAPIHandle,pchar('GetServiceKeyNameA'));
    GetServiceDisplayNameA:=getprocaddress(ADVAPIHandle,pchar('GetServiceDisplayNameA'));
    GetServiceDisplayNameW:=getprocaddress(ADVAPIHandle,pchar('GetServiceDisplayNameW'));
    GetServiceDisplayName:=getprocaddress(ADVAPIHandle,pchar('GetServiceDisplayNameA'));
    LockServiceDatabase:=getprocaddress(ADVAPIHandle,pchar('LockServiceDatabase'));
    NotifyBootConfigStatus:=getprocaddress(ADVAPIHandle,pchar('NotifyBootConfigStatus'));
    OpenSCManagerA:=getprocaddress(ADVAPIHandle,pchar('OpenSCManagerA'));
    OpenSCManagerW:=getprocaddress(ADVAPIHandle,pchar('OpenSCManagerW'));
    OpenSCManager:=getprocaddress(ADVAPIHandle,pchar('OpenSCManagerA'));
    OpenServiceA:=getprocaddress(ADVAPIHandle,pchar('OpenServiceA'));
    OpenServiceW:=getprocaddress(ADVAPIHandle,pchar('OpenServiceW'));
    OpenService:=getprocaddress(ADVAPIHandle,pchar('OpenServiceA'));
    QueryServiceConfigA:=getprocaddress(ADVAPIHandle,pchar('QueryServiceConfigA'));
    QueryServiceConfigW:=getprocaddress(ADVAPIHandle,pchar('QueryServiceConfigW'));
    QueryServiceConfig:=getprocaddress(ADVAPIHandle,pchar('QueryServiceConfigA'));
    QueryServiceLockStatusA:=getprocaddress(ADVAPIHandle,pchar('QueryServiceLockStatusA'));
    QueryServiceLockStatusW:=getprocaddress(ADVAPIHandle,pchar('QueryServiceLockStatusW'));
    QueryServiceLockStatus:=getprocaddress(ADVAPIHandle,pchar('QueryServiceLockStatusA'));
    QueryServiceObjectSecurity:=getprocaddress(ADVAPIHandle,pchar('QueryServiceObjectSecurity'));
    QueryServiceStatus:=getprocaddress(ADVAPIHandle,pchar('QueryServiceStatus'));
    RegisterServiceCtrlHandlerA:=getprocaddress(ADVAPIHandle,pchar('RegisterServiceCtrlHandlerA'));
    RegisterServiceCtrlHandlerW:=getprocaddress(ADVAPIHandle,pchar('RegisterServiceCtrlHandlerW'));
    RegisterServiceCtrlHandler:=getprocaddress(ADVAPIHandle,pchar('RegisterServiceCtrlHandlerA'));
    SetServiceObjectSecurity:=getprocaddress(ADVAPIHandle,pchar('SetServiceObjectSecurity'));
    SetServiceStatus:=getprocaddress(ADVAPIHandle,pchar('SetServiceStatus'));
    StartServiceCtrlDispatcherA:=getprocaddress(ADVAPIHandle,pchar('StartServiceCtrlDispatcherA'));
    StartServiceCtrlDispatcherW:=getprocaddress(ADVAPIHandle,pchar('StartServiceCtrlDispatcherW'));
    StartServiceCtrlDispatcher:=getprocaddress(ADVAPIHandle,pchar('StartServiceCtrlDispatcherA'));
    StartServiceA:=getprocaddress(ADVAPIHandle,pchar('StartServiceA'));
    StartServiceW:=getprocaddress(ADVAPIHandle,pchar('StartServiceW'));
    StartService:=getprocaddress(ADVAPIHandle,pchar('StartServiceA'));
    UnlockServiceDatabase:=getprocaddress(ADVAPIHandle,pchar('UnlockServiceDatabase'));
  end;
  result:=(ADVAPIHandle<>0) and Assigned(OpenSCManager);
end;

procedure FreeADVAPI;
begin
  if AdvAPIHandle<>0 then begin
    if not FreeLibrary(AdvAPIHandle) then
      Exception.Create('Unload Error: '+AdvAPI_DLL+' ('+inttohex(getmodulehandle(AdvAPI_DLL),8)+')')
    else
      AdvAPIHandle:=0;
  end;
end;


function ServiceGetStatus(sMachine, sService : string ) : DWord;
var
  schm,  schs   : SC_Handle;
  ss     : TServiceStatus;
  dwStat : DWord;
begin
  dwStat := uint(-1);
  schm := OpenSCManager(PChar(sMachine),nil,SC_MANAGER_CONNECT);
  if(schm > 0)then begin
    schs := OpenService(schm,PChar(sService),SERVICE_QUERY_STATUS);
    if(schs > 0)then begin
      if(QueryServiceStatus(schs,ss)) then
        dwStat := ss.dwCurrentState;
      CloseServiceHandle(schs);
    end;
    CloseServiceHandle(schm);
  end;
  Result := dwStat;
end;


function ServiceRunning(sMachine,sService : string ) : boolean;
begin
  Result:=SERVICE_RUNNING=ServiceGetStatus(sMachine, sService );
end;

function ServiceStopped(sMachine,sService : string ) : boolean;
begin
  Result:=SERVICE_STOPPED=ServiceGetStatus(sMachine, sService );
end;

function ServiceStart;
var
  schm, schs   : SC_Handle;
  ss     : TServiceStatus;
  psTemp : PChar;
  dwChkP,NArgs : DWord;
begin
  ss.dwCurrentState := uint(-1);
  schm := OpenSCManager(PChar(sMachine),nil,SC_MANAGER_CONNECT);
  if (schm > 0)then  begin
    schs := OpenService(schm,PChar(sService),SERVICE_START or SERVICE_QUERY_STATUS);
    if (schs > 0)then  begin
      NArgs:=0;
      psTemp:=nil;
      if sArgs<>'' then begin
        psTemp:=allocmem(Length(sArgs)+1);
        strpcopy(psTemp,sArgs);
        NArgs:=Length(sArgs)-Length(TrimAll(sArgs));
        if NArgs=0 then
          nArgs:=1;
      end;
      if (StartService(schs,NArgs,psTemp)) then begin
        if (QueryServiceStatus(schs,ss))then begin
          while (SERVICE_RUNNING<> ss.dwCurrentState) do begin
            dwChkP := ss.dwCheckPoint;
            Sleep(ss.dwWaitHint);
            if (not QueryServiceStatus(schs,ss)) then
              break;
            if (ss.dwCheckPoint<dwChkP) then
              break;
          end;
        end;
      end;
      CloseServiceHandle(schs);
    end;
    CloseServiceHandle(schm);
  end;
  Result:=SERVICE_RUNNING=ss.dwCurrentState;
end;

function ServiceStop(sMachine, sService : string ) : boolean;
var
  schm, schs   : SC_Handle;
  ss     : TServiceStatus;
  dwChkP : DWord;
begin
  schm := OpenSCManager(PChar(sMachine),nil,SC_MANAGER_CONNECT);
  if(schm > 0)then  begin
    schs := OpenService(schm,PChar(sService),SERVICE_STOP or SERVICE_QUERY_STATUS);
    if(schs > 0)then  begin
      if(ControlService(schs,SERVICE_CONTROL_STOP,@ss))then begin
        if(QueryServiceStatus(schs,ss))then begin
          while(SERVICE_STOPPED<>ss.dwCurrentState)do begin
            dwChkP := ss.dwCheckPoint;
            Sleep(ss.dwWaitHint);
            if(not QueryServiceStatus(schs,ss))then
              break;
            if(ss.dwCheckPoint<dwChkP)then
              break;
          end;
        end;
      end;
      CloseServiceHandle(schs);
    end;
    CloseServiceHandle(schm);
  end;
  Result:=SERVICE_STOPPED=ss.dwCurrentState;
end;

function ServicePause(sMachine, sService : string ) : boolean;
var
  schm, schs   : SC_Handle;
  ss     : TServiceStatus;
  dwChkP : DWord;
begin
  schm := OpenSCManager(PChar(sMachine),nil,SC_MANAGER_CONNECT);
  if(schm > 0)then  begin
    schs := OpenService(schm,PChar(sService),SERVICE_CONTROL_PAUSE or SERVICE_QUERY_STATUS);
    if(schs > 0)then  begin
      if(ControlService(schs,SERVICE_CONTROL_PAUSE,@ss))then begin
        if(QueryServiceStatus(schs,ss))then begin
          while(SERVICE_PAUSED<>ss.dwCurrentState)do begin
            dwChkP := ss.dwCheckPoint;
            Sleep(ss.dwWaitHint);
            if(not QueryServiceStatus(schs,ss))then
              break;
            if(ss.dwCheckPoint<dwChkP)then
              break;
          end;
        end;
      end;
      CloseServiceHandle(schs);
    end;
    CloseServiceHandle(schm);
  end;
  Result:=SERVICE_PAUSED=ss.dwCurrentState;
end;

function ServiceContinue(sMachine, sService : string ) : boolean;
var
  schm, schs   : SC_Handle;
  ss     : TServiceStatus;
  dwChkP : DWord;
begin
  schm := OpenSCManager(PChar(sMachine),nil,SC_MANAGER_CONNECT);
  if(schm > 0)then  begin
    schs := OpenService(schm,PChar(sService),SERVICE_CONTROL_CONTINUE or SERVICE_QUERY_STATUS);
    if(schs > 0)then  begin
      if(ControlService(schs,SERVICE_CONTROL_CONTINUE,@ss))then begin
        if(QueryServiceStatus(schs,ss))then begin
          while(SERVICE_RUNNING<>ss.dwCurrentState)do begin
            dwChkP := ss.dwCheckPoint;
            Sleep(ss.dwWaitHint);
            if(not QueryServiceStatus(schs,ss))then
              break;
            if(ss.dwCheckPoint<dwChkP)then
              break;
          end;
        end;
      end;
      CloseServiceHandle(schs);
    end;
    CloseServiceHandle(schm);
  end;
  Result:=SERVICE_RUNNING=ss.dwCurrentState;
end;

function ServiceGetKeyName(sMachine,sServiceDispName : string ) : string;
var
  schm : SC_Handle;
  nMaxNameLen   : cardinal;
  psServiceName : PChar;
begin
  Result := '';
  nMaxNameLen := 255;
  schm := OpenSCManager(PChar(sMachine),nil,SC_MANAGER_CONNECT);
  if(schm > 0)then begin
    psServiceName:=StrAlloc(nMaxNameLen+1);
    if(nil <> psServiceName)then begin
      if( GetServiceKeyName(schm,PChar(sServiceDispName),psServiceName,nMaxNameLen ) )then begin
        psServiceName[nMaxNameLen] := #0;
        Result :=StrPas( psServiceName );
      end;
      StrDispose(psServiceName);
    end;
    CloseServiceHandle(schm);
  end;
end;

function ServiceGetDisplayName(sMachine, sServiceKeyName : string ) : string;
var
  schm : SC_Handle;
  nMaxNameLen   : cardinal;
  psServiceName : PChar;
begin
  Result := '';
  nMaxNameLen := 255;
  schm := OpenSCManager(PChar(sMachine),nil,SC_MANAGER_CONNECT);
  if(schm > 0)then begin
    psServiceName:=StrAlloc(nMaxNameLen+1);
    if(nil <> psServiceName)then begin
      if( GetServiceDisplayName(schm,PChar(sServiceKeyName),psServiceName,nMaxNameLen ) )then begin
        psServiceName[nMaxNameLen] := #0;
        Result :=StrPas( psServiceName );
      end;
      StrDispose(psServiceName);
    end;
    CloseServiceHandle(schm);
  end;
end;

function ServiceGetList(sMachine :string; dwServiceType,dwServiceState :DWord; slServicesList :TStrings ) :boolean;
const
  cnMaxServices = 4096;
type
  PSvcA = ^TSvcA;
  TSvcA = array[0..511] of TEnumServiceStatus;
var
  j : integer;
  schm : SC_Handle;
  nBytesNeeded, nServices, nResumeHandle : DWord;
  ssa : TSvcA;
begin
  Result:=false;
  schm:=OpenSCManager(PChar(sMachine),nil,SC_MANAGER_ALL_ACCESS);
  if(schm>0) then
    try
      nResumeHandle := 0;
      while True do begin
        EnumServicesStatus(schm,dwServiceType,dwServiceState,ssa[0],SizeOf(ssa),nBytesNeeded,nServices,nResumeHandle );
        for j:=0 to nServices-1 do
          slServicesList.Add(string(ssa[j].lpDisplayName));
        if nBytesNeeded = 0 then
          Break;
      end;
      Result:=true;
    finally
      CloseServiceHandle(schm);
    end;
end;

function ServiceGetConfig;
var
  schm,schs :SC_Handle;
  d :dword;
begin
  result:=false;
  schm:=OpenSCManager(pchar(sMachine),nil,SC_MANAGER_CONNECT);
  if (schm>0) then
    try
      schs:=OpenService(schm,pchar(sService),SERVICE_QUERY_CONFIG);
      if (schs>0) then
        try
          result:=QueryServiceConfig(schs,@qsc,1024,@d);
        finally
          CloseServiceHandle(schs);
        end;
    finally
      CloseServiceHandle(schm);
    end;
end;

initialization
finalization
  FreeADVAPI;
end.

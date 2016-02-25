{*******************************************************}
{                                                       }
{       MiTeC System Information Component              }
{         Windows Process Status Helper                 }
{           version 8.6 for Delphi 5,6,7                }
{                                                       }
{       Copyright © 1997,2004 Michal Mutl               }
{                                                       }
{*******************************************************}

{$INCLUDE MITEC_DEF.INC}

unit MiTeC_PSAPI;

interface

uses Classes, Windows, ShellAPI, SysUtils;

type
  PHInst = ^HInst;
  TModuleInfo = record
    lpBaseOfDll : pointer;
    SizeOfImage : Integer;
    EntryPoint : pointer
  end;

  TPSAPIWsWatchInformation = record
    FaultingPc : pointer;
    FaultingVa : pointer
  end;

  TProcessMemoryCounters = record
    cb : Integer;
    PageFaultCount : Integer;
    PeakWorkingSetSize : Integer;
    WorkingSetSize : Integer;
    QuotaPeakPagedPoolUsage : Integer;
    QuotaPagedPoolUsage : Integer;
    QuotaPeakNonPagedPoolUsage : Integer;
    QuotaNonPagedPoolUsage : Integer;
    PagefileUsage : Integer;
    PeakPagefileUsage : Integer
  end;

  TaskEnumProcEx = function(threadID : DWORD; hMod16 : WORD; hTask16 : WORD; modName : PChar; fileName : PChar; param : DWORD) : BOOL; stdcall;

  function InitPSAPI: Boolean;
  procedure FreePSAPI;

  function InitVDM: Boolean;
  procedure FreeVDM;

type
  TVDMEnumTaskWOWEx = function (pid : DWORD; callback : TaskEnumProcEx; param : DWORD) : Integer; stdcall;

  TEnumProcesses = function (pidList : PInteger; cb : Integer; var cbNeeded : DWORD): boolean; stdcall;
  TEnumProcessModules = function (hProcess : THandle; moduleList : PHInst; cb : Integer; var cbNeeded : DWORD) : boolean; stdcall;
  TGetModuleBaseName = function (hProcess : THandle; module : HInst; BaseName : Pchar; size : Integer) : Integer; stdcall;
  TGetModuleFileNameEx = function (hProcess : THandle; module : HInst; FileName : PChar; size : Integer) : Integer; stdcall;
  TGetModuleInformation = function (hProcess : THandle; module : HInst; var info : TModuleInfo; size : Integer) : boolean; stdcall;
  TEmptyWorkingSet = function (hProcess : THandle) : boolean; stdcall;
  TQueryWorkingSet = function (hProcess : THandle; var pv; size : Integer) : boolean; stdcall;
  TInitializeProcessForWsWatch = function (hProcess : THandle) : boolean; stdcall;
  TGetWsChanges = function (hProcess : THandle; var WatchInfo : TPSAPIWsWatchInformation; size : Integer) : boolean; stdcall;
  TGetMappedFileName = function (hProcess : THandle; pv : pointer; FileName : PChar; size : Integer) : Integer; stdcall;
  TEnumDeviceDrivers = function (ImageBase : PInteger; cb : dword; var cbNeeded : dword) : boolean; stdcall;
  TGetDeviceDriverBaseName = function (ImageBase : Integer; BaseName : PChar; size : dword) : Integer; stdcall;
  TGetDeviceDriverFileName = function (ImageBase : Integer; FileName : PChar; size : dword) : Integer; stdcall;
  TGetProcessMemoryInfo = function (hProcess : THandle; var ProcessMemoryCounters : TProcessMemoryCounters; size : Integer) : boolean; stdcall;

var
  modulelist :PHInst;
  PSAPILoaded :Boolean;

  VDMEnumTaskWOWEx :TVDMEnumTaskWOWEx = nil;

  EnumProcesses: TEnumProcesses = nil;
  EnumProcessModules: TEnumProcessModules = nil;
  GetModuleBaseName: TGetModuleBaseName = nil;
  GetModuleFileNameEx: TGetModuleFileNameEx = nil;
  GetModuleInformation: TGetModuleInformation = nil;
  EmptyWorkingSet: TEmptyWorkingSet = nil;
  QueryWorkingSet: TQueryWorkingSet = nil;
  InitializeProcessForWsWatch: TInitializeProcessForWsWatch = nil;
  GetWsChanges: TGetWsChanges = nil;
  GetMappedFileName: TGetMappedFileName = nil;
  EnumDeviceDrivers: TEnumDeviceDrivers = nil;
  GetDeviceDriverBaseName: TGetDeviceDriverBaseName = nil;
  GetDeviceDriverFileName: TGetDeviceDriverFileName = nil;
  GetProcessMemoryInfo: TGetProcessMemoryInfo = nil;


implementation

const
  PSAPI_DLL = 'psapi.dll';
  VDMDBG_DLL = 'vdmdbg.dll';

var
  PSAPIHandle, VDMHandle: THandle;

function InitPSAPI: Boolean;
begin
  PSAPIHandle:=GetModuleHandle(PSAPI_DLL);
  if PSAPIHandle = 0 then
    PSAPIHandle:=loadlibrary(psapi_dll);
  if PSAPIHandle<>0 then begin
    @EnumProcesses:=getprocaddress(PSAPIHandle,pchar('EnumProcesses'));
    @EnumProcessModules:=getprocaddress(PSAPIHandle,pchar('EnumProcessModules'));
    @GetModuleBaseName:=getprocaddress(PSAPIHandle,pchar('GetModuleBaseNameA'));
    @GetModuleFileNameEx:=getprocaddress(PSAPIHandle,pchar('GetModuleFileNameExA'));
    @GetModuleInformation:=getprocaddress(PSAPIHandle,pchar('GetModuleInformation'));
    @EmptyWorkingSet:=getprocaddress(PSAPIHandle,pchar('EmptyWorkingSet'));
    @QueryWorkingSet:=getprocaddress(PSAPIHandle,pchar('QueryWorkingSet'));
    @InitializeProcessForWsWatch:=getprocaddress(PSAPIHandle,pchar('InitializeProcessForWsWatch'));
    @GetWsChanges:=getprocaddress(PSAPIHandle,pchar('GetWsChanges'));
    @GetMappedFileName:=getprocaddress(PSAPIHandle,pchar('GetMappedFileNameA'));
    @EnumDeviceDrivers:=getprocaddress(PSAPIHandle,pchar('EnumDeviceDrivers'));
    @GetDeviceDriverBaseName:=getprocaddress(PSAPIHandle,pchar('GetDeviceDriverBaseNameA'));
    @GetDeviceDriverFileName:=getprocaddress(PSAPIHandle,pchar('GetDeviceDriverFileNameA'));
    @GetProcessMemoryInfo:=getprocaddress(PSAPIHandle,pchar('GetProcessMemoryInfo'));
  end;
  result:=(PSAPIHandle<>0) and Assigned(EnumProcesses);
end;

procedure FreePSAPI;
begin
  if PSAPIHandle<>0 then begin
    if not FreeLibrary(PSAPIHandle) then
      Exception.Create('Unload Error: '+PSAPI_DLL+' ('+inttohex(getmodulehandle(PSAPI_DLL),8)+')')
    else
      PSAPIHandle:=0;
  end;
end;

function InitVDM: Boolean;
begin
  VDMHandle:=GetModuleHandle(VDMDBG_DLL);
  if VDMHandle = 0 then
    VDMHandle:=loadlibrary(vdmdbg_dll);
  if VDMHandle<>0 then begin
    @VDMEnumTaskWOWEx:=getprocaddress(VDMHandle,pchar('VDMEnumTaskWOWEx'));
  end;
  result:=(VDMHandle<>0) and Assigned(VDMEnumTaskWOWEx);
end;

procedure FreeVDM;
begin
  if VDMHandle<>0 then begin
    if not FreeLibrary(VDMHandle) then
      Exception.Create('Unload Error: '+VDMDBG_DLL+' ('+inttohex(getmodulehandle(VDMDBG_DLL),8)+')')
    else
      VDMHandle:=0;
  end;
end;

initialization
finalization
  FreePSAPI;
  FreeVDM;
end.

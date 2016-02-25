{*******************************************************}
{                                                       }
{       MiTeC System Information Component              }
{           version 8.2 for Delphi 5,6,7                }
{      Tool Help Functions, Types, and Definitions      }
{                                                       }
{       Copyright © 1997,2003 Michal Mutl               }
{                                                       }
{*******************************************************}

{$INCLUDE MITEC_DEF.INC}

unit MiTeC_ToolHelp32;

interface

uses Windows;

{$HPPEMIT '#include <tlhelp32.h>'}

const
{$EXTERNALSYM MAX_MODULE_NAME32}
  MAX_MODULE_NAME32 = 255;

(****** Shapshot function **********************************************)

{$EXTERNALSYM CreateToolhelp32Snapshot}
function CreateToolhelp32Snapshot(dwFlags, th32ProcessID: DWORD): THandle;

type
  TCreateToolhelp32Snapshot = function (dwFlags, th32ProcessID: DWORD): THandle stdcall;
const
{$EXTERNALSYM TH32CS_SNAPHEAPLIST}
  TH32CS_SNAPHEAPLIST = $00000001;
{$EXTERNALSYM TH32CS_SNAPPROCESS}
  TH32CS_SNAPPROCESS  = $00000002;
{$EXTERNALSYM TH32CS_SNAPTHREAD}
  TH32CS_SNAPTHREAD   = $00000004;
{$EXTERNALSYM TH32CS_SNAPMODULE}
  TH32CS_SNAPMODULE   = $00000008;
{$EXTERNALSYM TH32CS_SNAPALL}
  TH32CS_SNAPALL      = TH32CS_SNAPHEAPLIST or TH32CS_SNAPPROCESS or
    TH32CS_SNAPTHREAD or TH32CS_SNAPMODULE;
{$EXTERNALSYM TH32CS_INHERIT}
  TH32CS_INHERIT      = $80000000;

type
{$EXTERNALSYM tagHEAPLIST32}
  tagHEAPLIST32 = record
    dwSize: DWORD;
    th32ProcessID: DWORD;
    th32HeapID: DWORD;
    dwFlags: DWORD;
  end;
{$EXTERNALSYM HEAPLIST32}
  HEAPLIST32 = tagHEAPLIST32;
{$EXTERNALSYM PHEAPLIST32}
  PHEAPLIST32 = ^tagHEAPLIST32;
{$EXTERNALSYM LPHEAPLIST32}
  LPHEAPLIST32 = ^tagHEAPLIST32;
  THeapList32 = tagHEAPLIST32;

const
{$EXTERNALSYM HF32_DEFAULT}
  HF32_DEFAULT = 1;
{$EXTERNALSYM HF32_SHARED}
  HF32_SHARED  = 2;

{$EXTERNALSYM Heap32ListFirst}
function Heap32ListFirst(hSnapshot: THandle; var lphl: THeapList32): BOOL;
{$EXTERNALSYM Heap32ListNext}
function Heap32ListNext(hSnapshot: THandle; var lphl: THeapList32): BOOL;

type
  THeap32ListFirst = function (hSnapshot: THandle; var lphl: THeapList32): BOOL stdcall;
  THeap32ListNext = function (hSnapshot: THandle; var lphl: THeapList32): BOOL stdcall;

type
{$EXTERNALSYM tagHEAPENTRY32}
  tagHEAPENTRY32 = record
    dwSize: DWORD;
    hHandle: THandle;
    dwAddress: DWORD;
    dwBlockSize: DWORD;
    dwFlags: DWORD;
    dwLockCount: DWORD;
    dwResvd: DWORD;
    th32ProcessID: DWORD;
    th32HeapID: DWORD;
  end;
{$EXTERNALSYM HEAPENTRY32}
  HEAPENTRY32 = tagHEAPENTRY32;
{$EXTERNALSYM PHEAPENTRY32}
  PHEAPENTRY32 = ^tagHEAPENTRY32;
{$EXTERNALSYM LPHEAPENTRY32}
  LPHEAPENTRY32 = ^tagHEAPENTRY32;
  THeapEntry32 = tagHEAPENTRY32;

const
{$EXTERNALSYM LF32_FIXED}
  LF32_FIXED    = $00000001;
{$EXTERNALSYM LF32_FREE}
  LF32_FREE     = $00000002;
{$EXTERNALSYM LF32_MOVEABLE}
  LF32_MOVEABLE = $00000004;

{$EXTERNALSYM Heap32First}
function Heap32First(var lphe: THeapEntry32; th32ProcessID, th32HeapID: DWORD): BOOL;
{$EXTERNALSYM Heap32Next}
function Heap32Next(var lphe: THeapEntry32): BOOL;
{$EXTERNALSYM Toolhelp32ReadProcessMemory}
function Toolhelp32ReadProcessMemory(th32ProcessID: DWORD; lpBaseAddress: Pointer;
  var lpBuffer; cbRead: DWORD; var lpNumberOfBytesRead: DWORD): BOOL;

type
  THeap32First = function (var lphe: THeapEntry32; th32ProcessID,
    th32HeapID: DWORD): BOOL stdcall;
  THeap32Next = function (var lphe: THeapEntry32): BOOL stdcall;
  TToolhelp32ReadProcessMemory = function (th32ProcessID: DWORD;
    lpBaseAddress: Pointer; var lpBuffer; cbRead: DWORD;
    var lpNumberOfBytesRead: DWORD): BOOL stdcall;

type
{$EXTERNALSYM tagPROCESSENTRY32W}
  tagPROCESSENTRY32W = packed record
    dwSize: DWORD;
    cntUsage: DWORD;
    th32ProcessID: DWORD;
    th32DefaultHeapID: DWORD;
    th32ModuleID: DWORD;
    cntThreads: DWORD;
    th32ParentProcessID: DWORD;
    pcPriClassBase: Longint;
    dwFlags: DWORD;
    szExeFile: array[0..MAX_PATH - 1] of WChar;
  end;
{$EXTERNALSYM PROCESSENTRY32W}
  PROCESSENTRY32W = tagPROCESSENTRY32W;
{$EXTERNALSYM PPROCESSENTRY32W}
  PPROCESSENTRY32W = ^tagPROCESSENTRY32W;
{$EXTERNALSYM LPPROCESSENTRY32W}
  LPPROCESSENTRY32W = ^tagPROCESSENTRY32W;
  TProcessEntry32W = tagPROCESSENTRY32W;

{$EXTERNALSYM Process32FirstW}
function Process32FirstW(hSnapshot: THandle; var lppe: TProcessEntry32W): BOOL;
{$EXTERNALSYM Process32NextW}
function Process32NextW(hSnapshot: THandle; var lppe: TProcessEntry32W): BOOL;

type
  TProcess32FirstW = function (hSnapshot: THandle; var lppe: TProcessEntry32W): BOOL stdcall;
  TProcess32NextW = function (hSnapshot: THandle; var lppe: TProcessEntry32W): BOOL stdcall;

{$EXTERNALSYM tagPROCESSENTRY32}
  tagPROCESSENTRY32 = packed record
    dwSize: DWORD;
    cntUsage: DWORD;
    th32ProcessID: DWORD;
    th32DefaultHeapID: DWORD;
    th32ModuleID: DWORD;
    cntThreads: DWORD;
    th32ParentProcessID: DWORD;
    pcPriClassBase: Longint;
    dwFlags: DWORD;
    szExeFile: array[0..MAX_PATH - 1] of Char;
  end;
{$EXTERNALSYM PROCESSENTRY32}
  PROCESSENTRY32 = tagPROCESSENTRY32;
{$EXTERNALSYM PPROCESSENTRY32}
  PPROCESSENTRY32 = ^tagPROCESSENTRY32;
{$EXTERNALSYM LPPROCESSENTRY32}
  LPPROCESSENTRY32 = ^tagPROCESSENTRY32;
  TProcessEntry32 = tagPROCESSENTRY32;

{$EXTERNALSYM Process32First}
function Process32First(hSnapshot: THandle; var lppe: TProcessEntry32): BOOL;
{$EXTERNALSYM Process32Next}
function Process32Next(hSnapshot: THandle; var lppe: TProcessEntry32): BOOL;

type
  TProcess32First = function (hSnapshot: THandle; var lppe: TProcessEntry32): BOOL stdcall;
  TProcess32Next = function (hSnapshot: THandle; var lppe: TProcessEntry32): BOOL stdcall;

type
{$EXTERNALSYM tagTHREADENTRY32}
  tagTHREADENTRY32 = record
    dwSize: DWORD;
    cntUsage: DWORD;
    th32ThreadID: DWORD;
    th32OwnerProcessID: DWORD;
    tpBasePri: Longint;
    tpDeltaPri: Longint;
    dwFlags: DWORD;
  end;
{$EXTERNALSYM THREADENTRY32}
  THREADENTRY32 = tagTHREADENTRY32;
{$EXTERNALSYM PTHREADENTRY32}
  PTHREADENTRY32 = ^tagTHREADENTRY32;
{$EXTERNALSYM LPTHREADENTRY32}
  LPTHREADENTRY32 = ^tagTHREADENTRY32;
  TThreadEntry32 = tagTHREADENTRY32;

{$EXTERNALSYM Thread32First}
function Thread32First(hSnapshot: THandle; var lpte: TThreadEntry32): BOOL; stdcall;
{$EXTERNALSYM Thread32Next}
function Thread32Next(hSnapshot: THandle; var lpte: TThreadENtry32): BOOL; stdcall;

type
  TThread32First = function (hSnapshot: THandle; var lpte: TThreadEntry32): BOOL stdcall;
  TThread32Next = function (hSnapshot: THandle; var lpte: TThreadENtry32): BOOL stdcall;

type
{$EXTERNALSYM tagMODULEENTRY32}
  tagMODULEENTRY32 = record
    dwSize: DWORD;
    th32ModuleID: DWORD;
    th32ProcessID: DWORD;
    GlblcntUsage: DWORD;
    ProccntUsage: DWORD;
    modBaseAddr: PBYTE;
    modBaseSize: DWORD;
    hModule: HMODULE;
    szModule: array[0..MAX_MODULE_NAME32] of Char;
    szExePath: array[0..MAX_PATH - 1] of Char;
  end;
{$EXTERNALSYM MODULEENTRY32}
  MODULEENTRY32 = tagMODULEENTRY32;
{$EXTERNALSYM PMODULEENTRY32}
  PMODULEENTRY32 = ^tagMODULEENTRY32;
{$EXTERNALSYM LPMODULEENTRY32}
  LPMODULEENTRY32 = ^tagMODULEENTRY32;
  TModuleEntry32 = tagMODULEENTRY32;

{$EXTERNALSYM Module32First}
function Module32First(hSnapshot: THandle; var lpme: TModuleEntry32): BOOL;
{$EXTERNALSYM Module32Next}
function Module32Next(hSnapshot: THandle; var lpme: TModuleEntry32): BOOL;

type
  TModule32First = function (hSnapshot: THandle; var lpme: TModuleEntry32): BOOL stdcall;
  TModule32Next = function (hSnapshot: THandle; var lpme: TModuleEntry32): BOOL stdcall;

{$EXTERNALSYM tagMODULEENTRY32W}
  tagMODULEENTRY32W = record
    dwSize: DWORD;
    th32ModuleID: DWORD;
    th32ProcessID: DWORD;
    GlblcntUsage: DWORD;
    ProccntUsage: DWORD;
    modBaseAddr: PBYTE;
    modBaseSize: DWORD;
    hModule: HMODULE;
    szModule: array[0..MAX_MODULE_NAME32] of WChar;
    szExePath: array[0..MAX_PATH - 1] of WChar;
  end;
{$EXTERNALSYM MODULEENTRY32}
  MODULEENTRY32W = tagMODULEENTRY32W;
{$EXTERNALSYM PMODULEENTRY32}
  PMODULEENTRY32W = ^tagMODULEENTRY32W;
{$EXTERNALSYM LPMODULEENTRY32}
  LPMODULEENTRY32W = ^tagMODULEENTRY32W;
  TModuleEntry32W = tagMODULEENTRY32W;

{$EXTERNALSYM Module32First}
function Module32FirstW(hSnapshot: THandle; var lpme: TModuleEntry32W): BOOL;
{$EXTERNALSYM Module32Next}
function Module32NextW(hSnapshot: THandle; var lpme: TModuleEntry32W): BOOL;

type
  TModule32FirstW = function (hSnapshot: THandle; var lpme: TModuleEntry32W): BOOL stdcall;
  TModule32NextW = function (hSnapshot: THandle; var lpme: TModuleEntry32W): BOOL stdcall;


implementation

const
  kernel32 = 'kernel32.dll';

var
  KernelHandle: THandle;
  _CreateToolhelp32Snapshot: TCreateToolhelp32Snapshot;
  _Heap32ListFirst: THeap32ListFirst;
  _Heap32ListNext: THeap32ListNext;
  _Heap32First: THeap32First;
  _Heap32Next: THeap32Next;
  _Toolhelp32ReadProcessMemory: TToolhelp32ReadProcessMemory;
  _Process32First: TProcess32First;
  _Process32Next: TProcess32Next;
  _Process32FirstW: TProcess32FirstW;
  _Process32NextW: TProcess32NextW;
  _Thread32First: TThread32First;
  _Thread32Next: TThread32Next;
  _Module32First: TModule32First;
  _Module32Next: TModule32Next;
  _Module32FirstW: TModule32FirstW;
  _Module32NextW: TModule32NextW;

function InitToolHelp: Boolean;
begin
  if KernelHandle=0 then begin
    KernelHandle:=GetModuleHandle(kernel32);
    if KernelHandle<>0 then begin
      @_CreateToolhelp32Snapshot := GetProcAddress(KernelHandle, 'CreateToolhelp32Snapshot');
      @_Heap32ListFirst := GetProcAddress(KernelHandle, 'Heap32ListFirst');
      @_Heap32ListNext := GetProcAddress(KernelHandle, 'Heap32ListNext');
      @_Heap32First := GetProcAddress(KernelHandle, 'Heap32First');
      @_Heap32Next := GetProcAddress(KernelHandle, 'Heap32Next');
      @_Toolhelp32ReadProcessMemory := GetProcAddress(KernelHandle, 'Toolhelp32ReadProcessMemory');
      @_Process32First := GetProcAddress(KernelHandle, 'Process32First');
      @_Process32Next := GetProcAddress(KernelHandle, 'Process32Next');
      @_Process32FirstW := GetProcAddress(KernelHandle, 'Process32FirstW');
      @_Process32NextW := GetProcAddress(KernelHandle, 'Process32NextW');
      @_Thread32First := GetProcAddress(KernelHandle, 'Thread32First');
      @_Thread32Next := GetProcAddress(KernelHandle, 'Thread32Next');
      @_Module32First := GetProcAddress(KernelHandle, 'Module32First');
      @_Module32Next := GetProcAddress(KernelHandle, 'Module32Next');
      @_Module32FirstW := GetProcAddress(KernelHandle, 'Module32FirstW');
      @_Module32NextW := GetProcAddress(KernelHandle, 'Module32NextW');
    end;
  end;
  result:=(KernelHandle<>0) and assigned(_CreateToolhelp32Snapshot);
end;

function CreateToolhelp32Snapshot;
begin
  if InitToolHelp then
    Result := _CreateToolhelp32Snapshot(dwFlags, th32ProcessID)
  else Result := 0;
end;

function Heap32ListFirst;
begin
  if InitToolHelp then
    Result := _Heap32ListFirst(hSnapshot, lphl)
  else Result := False;
end;

function Heap32ListNext;
begin
  if InitToolHelp then
    Result := _Heap32ListNext(hSnapshot, lphl)
  else Result := False;
end;

function Heap32First;
begin
  if InitToolHelp then
    Result := _Heap32First(lphe, th32ProcessID, th32HeapID)
  else Result := False;
end;

function Heap32Next;
begin
  if InitToolHelp then
    Result := _Heap32Next(lphe)
  else Result := False;
end;

function Toolhelp32ReadProcessMemory;
begin
  if InitToolHelp then
    Result := _Toolhelp32ReadProcessMemory(th32ProcessID, lpBaseAddress,
      lpBuffer, cbRead, lpNumberOfBytesRead)
  else Result := False;
end;

function Process32First;
begin
  if InitToolHelp then
    Result := _Process32First(hSnapshot, lppe)
  else Result := False;
end;

function Process32Next;
begin
  if InitToolHelp then
    Result := _Process32Next(hSnapshot, lppe)
  else Result := False;
end;

function Process32FirstW;
begin
  if InitToolHelp then
    Result := _Process32FirstW(hSnapshot, lppe)
  else Result := False;
end;

function Process32NextW;
begin
  if InitToolHelp then
    Result := _Process32NextW(hSnapshot, lppe)
  else Result := False;
end;

function Thread32First;
begin
  if InitToolHelp then
    Result := _Thread32First(hSnapshot, lpte)
  else Result := False;
end;

function Thread32Next;
begin
  if InitToolHelp then
    Result := _Thread32Next(hSnapshot, lpte)
  else Result := False;
end;

function Module32First;
begin
  if InitToolHelp then
    Result := _Module32First(hSnapshot, lpme)
  else Result := False;
end;

function Module32Next;
begin
  if InitToolHelp then
    Result := _Module32Next(hSnapshot, lpme)
  else Result := False;
end;

function Module32FirstW;
begin
  if InitToolHelp then
    Result := _Module32FirstW(hSnapshot, lpme)
  else Result := False;
end;

function Module32NextW;
begin
  if InitToolHelp then
    Result := _Module32NextW(hSnapshot, lpme)
  else Result := False;
end;

end.


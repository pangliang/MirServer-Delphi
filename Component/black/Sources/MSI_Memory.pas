{*******************************************************}
{                                                       }
{       MiTeC System Information Component              }
{              Memory Detection Part                    }
{           version 8.6.4 for Delphi 5,6,7              }
{                                                       }
{       Copyright © 1997,2003 Michal Mutl               }
{                                                       }
{*******************************************************}

{$INCLUDE MITEC_DEF.INC}

unit MSI_Memory;

interface

uses
  SysUtils, Windows, Classes, MSI_Common;

type
  TMemoryStatusEx = record
    dwLength,
    dwMemoryLoad: DWORD;
    ullTotalPhys,
    ullAvailPhys,
    ullTotalPageFile,
    ullAvailPageFile,
    ullTotalVirtual,
    ullAvailVirtual,
    ullAvailExtendedVirtual: int64;
  end;

  PMemoryStatusEx = ^TMemoryStatusEx;

  TResources = class(TPersistent)
  private
    {$IFNDEF D6PLUS}
    FDummy: Byte;
    {$ENDIF}
    FGDI: Byte;
    FUser: Byte;
    FSystem: Byte;
    FModes: TExceptionModes;
    procedure SetMode(const Value: TExceptionModes);
  public
    constructor Create;
    procedure GetInfo;
  published
    property ExceptionModes: TExceptionModes read FModes Write SetMode;
    property System: Byte read FSystem {$IFNDEF D6PLUS} Write FDummy {$ENDIF} stored false;
    property GDI: Byte read FGDI {$IFNDEF D6PLUS} write FDummy {$ENDIF} stored false;
    property User: Byte read FUser {$IFNDEF D6PLUS} write FDummy {$ENDIF} stored False;
  end;

  TMemory = class(TPersistent)
  private
    FMaxAppAddress: integer;
    FVirtualTotal: int64;
    FPageFileFree: Int64;
    FVirtualFree: int64;
    FPhysicalFree: int64;
    FAllocGranularity: integer;
    FMinAppAddress: integer;
    FMemoryLoad: integer;
    FPhysicalTotal: int64;
    FPageFileTotal: int64;
    FPageSize: integer;
    FResources: TResources;
    FModes: TExceptionModes;
    procedure SetMode(const Value: TExceptionModes);
  public
    constructor Create;
    destructor Destroy; override;
    procedure GetInfo;
    procedure Report(var sl :TStringList; Standalone: Boolean = True); virtual;
  published
    property ExceptionModes: TExceptionModes read FModes Write SetMode;
    property PhysicalTotal :int64 read FPhysicalTotal {$IFNDEF D6PLUS} write FPhysicalTotal {$ENDIF} stored false;
    property PhysicalFree :int64 read FPhysicalFree {$IFNDEF D6PLUS} write FPhysicalFree {$ENDIF} stored false;
    property VirtualTotal :int64 read FVirtualTotal {$IFNDEF D6PLUS} write FVirtualTotal {$ENDIF} stored false;
    property VirtualFree :int64 read FVirtualFree {$IFNDEF D6PLUS} write FVirtualFree {$ENDIF} stored false;
    property PageFileTotal :int64 read FPageFileTotal {$IFNDEF D6PLUS} write FPageFileTotal {$ENDIF} stored false;
    property PageFileFree :int64 read FPageFileFree {$IFNDEF D6PLUS} write FPageFileFree {$ENDIF} stored false;
    property MemoryLoad :integer read FMemoryLoad {$IFNDEF D6PLUS} write FMemoryLoad {$ENDIF} stored false;
    property AllocGranularity :integer read FAllocGranularity {$IFNDEF D6PLUS} write FAllocGranularity {$ENDIF} stored false;
    property MaxAppAddress :integer read FMaxAppAddress {$IFNDEF D6PLUS} write FMaxAppAddress {$ENDIF} stored false;
    property MinAppAddress :integer read FMinAppAddress {$IFNDEF D6PLUS} write FMinAppAddress {$ENDIF} stored false;
    property PageSize :integer read FPageSize {$IFNDEF D6PLUS} write FPageSize {$ENDIF} stored false;
    property Resources :TResources read FResources {$IFNDEF D6PLUS} write FResources {$ENDIF} stored False;
  end;

type
  TGlobalMemoryStatusEx = function(lpBuffer: PMEMORYSTATUSEX): BOOL; stdcall;
  TQT_Thunk = procedure cdecl;

function GlobalMemoryStatusEx(lpBuffer: PMEMORYSTATUSEX): BOOL; stdcall;
procedure QT_Thunk; cdecl;

implementation

uses MiTeC_Routines;

var
  _GlobalMemoryStatusEx: TGlobalMemoryStatusEx;
  _QT_Thunk: TQT_Thunk;

  hInst16: THandle;
  GFSR: Pointer;

const
  cSystem = 0;
  cGDI = 1;
  cUSER = 2;

function LoadLibrary16(LibraryName: PChar): THandle; stdcall; external kernel32 index 35;
procedure FreeLibrary16(HInstance: THandle); stdcall; external kernel32 index 36;
function GetProcAddress16(Hinstance: THandle; ProcName: PChar): Pointer; stdcall; external kernel32 index 37;

function GetFreeSysRes(SysRes: Word): Word;
var
  Thunks: Array[0..$20] of Word;
begin
  Thunks[0]:=hInst16;
  if not IsNT then begin
    if not Assigned(GFSR) then begin
      hInst16:=LoadLibrary16('user.exe');
      if hInst16<32 then
        raise Exception.Create('Can''t load USER.EXE!');
      FreeLibrary16(hInst16);
      GFSR:=GetProcAddress16(hInst16,'GetFreeSystemResources');
      if not Assigned(GFSR) then
        raise Exception.Create('Can''t get address of GetFreeSystemResources');
    end;
    asm
      push SysRes       // push arguments
      mov edx, GFSR       // load 16-bit procedure pointer
      call _QT_Thunk     // call thunk
      mov Result, ax    // save the result
    end;
  end else
    Result:=90;
end;

{ TMemory }

procedure TMemory.GetInfo;
var
  SI :TSystemInfo;
  MS :TMemoryStatus;
  MSEX :TMemoryStatusEx;
begin
  {$IFDEF ERROR_INTERCEPT}PushTrace(FModes,Self,'GetInfo'); {$ENDIF}

  Resources.GetInfo;
  if OS>=os2K then begin
    ZeroMemory(@MSEX,SizeOf(MSEX));
    MSEX.dwLength:=SizeOf(MSEX);
    GlobalMemoryStatusEx(@MSEX);
    FMemoryLoad:=MSEX.dwMemoryLoad;
    FPhysicalTotal:=MSEX.ullTotalPhys;
    FPhysicalFree:=MSEX.ullAvailPhys;
    FVirtualTotal:=MSEX.ullTotalVirtual;
    FVirtualFree:=MSEX.ullAvailVirtual;
    FPageFileTotal:=MSEX.ullTotalPageFile;
    FPageFileFree:=MSEX.ullAvailPageFile;
  end else begin
    ZeroMemory(@MS,SizeOf(MS));
    MS.dwLength:=SizeOf(MS);
    GlobalMemoryStatus(MS);
    FMemoryLoad:=MS.dwMemoryLoad;
    FPhysicalTotal:=MS.dwTotalPhys;
    FPhysicalFree:=MS.dwAvailPhys;
    FVirtualTotal:=MS.dwTotalVirtual;
    FVirtualFree:=MS.dwAvailVirtual;
    FPageFileTotal:=MS.dwTotalPageFile;
    FPageFileFree:=MS.dwAvailPageFile;
  end;
  ZeroMemory(@SI,SizeOf(SI));
  GetSystemInfo(SI);
  FAllocGranularity:=SI.dwAllocationGranularity;
  FMaxAppAddress:=DWORD(SI.lpMaximumApplicationAddress);
  FMinAppAddress:=DWORD(SI.lpMinimumApplicationAddress);
  FPageSize:=DWORD(SI.dwPageSize);

  {$IFDEF ERROR_INTERCEPT}PopTrace;{$ENDIF}
end;

procedure TMemory.Report;
begin
  {$IFDEF ERROR_INTERCEPT}PushTrace(FModes,Self,'Report'); {$ENDIF}
  with sl do begin
    if Standalone then ReportHeader(sl);
    Add('<Memory classname="TMemory">');

    Add(Format('<data name="PhysicalTotal" type="integer" unit="B">%d</data>',[PhysicalTotal]));
    Add(Format('<data name="PhysicalFree" type="integer" unit="B">%d</data>',[PhysicalFree]));
    Add(Format('<data name="PageFileTotal" type="integer" unit="B">%d</data>',[PageFileTotal]));
    Add(Format('<data name="PageFileFree" type="integer" unit="B">%d</data>',[PageFileFree]));
    Add(Format('<data name="VirtualTotal" type="integer" unit="B">%d</data>',[VirtualTotal]));
    Add(Format('<data name="VirtualFree" type="integer" unit="B">%d</data>',[VirtualFree]));
    Add(Format('<data name="AllocationGranularity" type="integer" unit="B">%d</data>',[AllocGranularity]));
    Add(Format('<data name="MinAppAddress" type="integer">%d</data>',[MinAppAddress]));
    Add(Format('<data name="MaxAppAddress" type="integer">%d</data>',[MaxAppAddress]));
    Add(Format('<data name="PageSize" type="integer" unit="B">%d</data>',[PageSize]));

    Add('</Memory>');
    if Standalone then ReportFooter(sl);
  end;
  {$IFDEF ERROR_INTERCEPT}PopTrace;{$ENDIF}
end;

constructor TMemory.Create;
begin
  @_GlobalMemoryStatusEx:=GetProcAddress(GetModuleHandle('kernel32'),PChar('GlobalMemoryStatusEx'));
  FResources:=TResources.Create;
  ExceptionModes:=[emExceptionStack];
end;

function GlobalMemoryStatusEx;
begin
  if Assigned(_GlobalMemoryStatusEx) then
    Result:=_GlobalMemoryStatusEx(lpBuffer)
  else
    Result:=False;
end;

procedure QT_Thunk;
begin
  if Assigned(_QT_Thunk) then
    _QT_Thunk;
end;

destructor TMemory.Destroy;
begin
  FResources.Free;
  inherited;
end;

procedure TMemory.SetMode(const Value: TExceptionModes);
begin
  FModes := Value;
  if Assigned(Resources) then
    Resources.ExceptionModes:=FModes;
end;

{ TResources }

constructor TResources.Create;
begin
  ExceptionModes:=[emExceptionStack];
  @_QT_Thunk:=GetProcAddress(GetModuleHandle('kernel32'),PChar('QT_Thunk'));
end;

procedure TResources.GetInfo;
begin
  {$IFDEF ERROR_INTERCEPT}PushTrace(FModes,Self,'GetInfo'); {$ENDIF}

  FSystem:=GetFreeSysRes(cSystem);
  FUSer:=GetFreeSysRes(cUser);
  FGDI:=GetFreeSysRes(cGDI);

  {$IFDEF ERROR_INTERCEPT}PopTrace;{$ENDIF}
end;

procedure TResources.SetMode(const Value: TExceptionModes);
begin
  FModes := Value;
end;

end.

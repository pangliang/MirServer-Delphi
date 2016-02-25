{*******************************************************}
{                                                       }
{         MiTeC System Information Components           }
{          CPU Usage Evaluation Component               }
{           version 8.6 for Delphi 5,6,7                }
{                                                       }
{           Copyright © 1997,2004 Michal Mutl           }
{                                                       }
{*******************************************************}

{$INCLUDE MITEC_DEF.INC}

unit MSI_CPUUsage;

interface

uses
  SysUtils, Windows, Classes, ExtCtrls;

type
  TOnIntervalEvent = procedure (Sender: TObject; Value: DWORD) of object;

  TMCPUUsage = class(TComponent)
  private
    Timer: TTimer;
    FOnInterval: TOnIntervalEvent;
    FReady: Boolean;
    FCPUUsage: DWORD;
    function GetActive: Boolean;
    function GetInterval: DWORD;
    procedure SetActive(const Value: Boolean);
    procedure SetInterval(const Value: DWORD);
    procedure OnTimer(Sender: TObject);
    function GetCPUUsage: DWORD;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property CPUUsage: DWORD read GetCPUUsage;
  published
    property Active: Boolean read GetActive write SetActive;
    property Interval: DWORD read GetInterval write SetInterval;
    property OnInterval: TOnIntervalEvent read FOnInterval write FOnInterval;
  end;

function InitNTCPUData: Boolean;
function GetNTCPUData: comp;
procedure ReleaseNTCPUData;

const
  ObjCounter = 'KERNEL\CPUUsage';


implementation

{$R 'MSI_CPUUsage.dcr'}

uses MiTeC_Routines, Registry, MiTeC_Native;

const
  Timer100N = 10000000;
  Timer1S = 1000;

var
  CPUSize: DWORD;
  CPUNTUsage: PSystemProcessorTimes;
  FLastValue, FValue: Comp;

function InitNTCPUData: Boolean;
var
  R: DWORD;
  n: DWORD;
begin
  n:=0;
  CPUNTUsage:=AllocMem(SizeOf(TSystemProcessorTimes));
  R:=NtQuerySystemInformation(SystemProcessorTimes,CPUNTUsage,SizeOf(TSystemProcessorTimes),nil);
  while R=STATUS_INFO_LENGTH_MISMATCH do begin
    Inc(n);
    ReallocMem(CPUNTUsage,n*SizeOf(CPUNTUsage^));
    R:=NtQuerySystemInformation(SystemProcessorTimes,CPUNTUsage,n*SizeOf(TSystemProcessorTimes),nil);
  end;
  CPUSize:=n*SizeOf(CPUNTUsage^);
  Result:=R=STATUS_SUCCESS;
end;

function GetNTCPUData;
begin
  NtQuerySystemInformation(SystemProcessorTimes,CPUNTUsage,CPUSize,nil);
  Result:=CPUNTUsage^.IdleTime.QuadPart;
end;

procedure ReleaseNTCPUData;
begin
  Freemem(CPUNTUsage);
end;

{ TMCPUUsage }

constructor TMCPUUsage.Create(AOwner: TComponent);
begin
  inherited;
  InitNativeAPI;
  Timer:=TTimer.Create(Self);
  Timer.Interval:=1000;
  Timer.Enabled:=False;
  Timer.OnTimer:=OnTimer;
end;

destructor TMCPUUsage.Destroy;
begin
  Timer.Free;
  if FReady then begin
    if IsNT then
      ReleaseNTCPUData
    else
      Release9xPerfData(ObjCounter);
  end;
  inherited;
end;

function TMCPUUsage.GetActive: Boolean;
begin
  Result:=Timer.Enabled;
end;

function TMCPUUsage.GetCPUUsage: DWORD;
begin
  if IsNT then begin
    FLastValue:=FValue;
    FValue:=GetNTCPUData;
    try
      Result:=Round((Timer100n-(FValue-FLastValue)/(Timer.Interval/Timer1s))/Timer100n*100);
    except
      Result:=0;
    end;
  end else begin
    Result:=Get9xPerfData(ObjCounter);
  end;
end;

function TMCPUUsage.GetInterval: DWORD;
begin
  Result:=Timer.Interval;
end;

procedure TMCPUUsage.OnTimer(Sender: TObject);
begin
  FCPUUsage:=GetCPUUsage;
  if Assigned(FOnInterval) then
    FOnInterval(Self,FCPUUsage);
end;

procedure TMCPUUsage.SetActive(const Value: Boolean);
begin
  if Value then begin
    if IsNT then
      FReady:=InitNTCPUData
    else
      FReady:=Init9xPerfData(ObjCounter);
  end else
    if FReady then begin
      if IsNT then
        ReleaseNTCPUData
      else
        Release9xPerfData(ObjCounter);
      FReady:=False;
    end;
  Timer.Enabled:=Value and FReady;
end;

procedure TMCPUUsage.SetInterval(const Value: DWORD);
begin
  Timer.Interval:=Value;
end;


end.

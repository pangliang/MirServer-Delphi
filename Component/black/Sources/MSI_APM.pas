{*******************************************************}
{                                                       }
{       MiTeC System Information Component              }
{               APM Detection Part                      }
{           version 8.6.4 for Delphi 5,6,7              }
{                                                       }
{       Copyright © 1997,2003 Michal Mutl               }
{                                                       }
{*******************************************************}

{$INCLUDE MITEC_DEF.INC}

unit MSI_APM;

interface

uses
  MSI_Common, SysUtils, Windows, Classes;

type
  TPowerStatus = (psUnknown, psOffline, psOnline);

  TBatteryStatus = (bsUnknown, bsHigh, bsLow, bsCritical, bsCharging, bsNoBattery);

  TAPM = class(TPersistent)
  private
    FBatteryLifePercent: Byte;
    FBatteryLifeFullTime: DWORD;
    FBatteryLifeTime: DWORD;
    FACPowerStatus: TPowerStatus;
    FBatteryChargeStatus: TBatteryStatus;
    FModes: TExceptionModes;
    procedure SetMode(const Value: TExceptionModes);
  public
    constructor Create;
    procedure GetInfo;
    procedure Report(var sl :TStringList; Standalone: Boolean = True); virtual;
    function GetACPSStr(ACPS: TPowerStatus): string;
    function GetBSStr(BS: TBatteryStatus): string;
  published
    property ExceptionModes: TExceptionModes read FModes Write SetMode;
    property ACPowerStatus :TPowerStatus read FACPowerStatus {$IFNDEF D6PLUS} write FACPowerStatus {$ENDIF} stored false;
    property BatteryChargeStatus :TBatteryStatus read FBatteryChargeStatus {$IFNDEF D6PLUS} write FBatteryChargeStatus {$ENDIF} stored false;
    property BatteryLifePercent :Byte read FBatteryLifePercent {$IFNDEF D6PLUS} write FBatteryLifePercent {$ENDIF} stored false;
    property BatteryLifeTime :DWORD read FBatteryLifeTime {$IFNDEF D6PLUS} write FBatteryLifeTime {$ENDIF} stored false;
    property BatteryLifeFullTime :DWORD read FBatteryLifeFullTime {$IFNDEF D6PLUS} write FBatteryLifeFullTime {$ENDIF} stored false;
  end;

implementation

uses
  MiTeC_Routines, MiTeC_Datetime;

{ TAPM }

constructor TAPM.Create;
begin
  ExceptionModes:=[emExceptionStack];
end;

function TAPM.GetACPSStr(ACPS: TPowerStatus): string;
begin
  case ACPS of
    psUnknown: Result:='Unknown';
    psOnline: Result:='Online';
    psOffline: Result:='Offline';
  end;
end;

function TAPM.GetBSStr(BS: TBatteryStatus): string;
begin
  case BS of
    bsUnknown: Result:='Unknown';
    bsHigh: Result:='High';
    bsLow: Result:='Low';
    bsCritical: Result:='Critical';
    bsCharging: Result:='Charging';
    bsNoBattery: Result:='No Battery';
  end;
end;

procedure TAPM.GetInfo;
var
  PS :TSystemPowerStatus;
  OK: Boolean;
begin
  {$IFDEF ERROR_INTERCEPT}PushTrace(FModes,Self,'GetInfo'); {$ENDIF}

  FACPowerStatus:=psUnknown;
  FBatteryChargeStatus:=bsUnknown;
  FBatteryLifePercent:=0;
  FBatteryLifeTime:=0;
  FBatteryLifeFullTime:=0;
  ok:=GetSystemPowerStatus(PS);
  if OK then begin
    case PS.ACLineStatus of
      0 : FACPowerStatus:=psOffLine;
      1 : FACPowerStatus:=psOnLine;
      else FACPowerStatus:=psUnknown;
    end;
    if (PS.BatteryFlag or 1)=1 then
      FBatteryChargeStatus:=bsHigh
    else
      if (PS.BatteryFlag or 2)=2 then
        FBatteryChargeStatus:=bsLow
      else
        if (PS.BatteryFlag or 4)=4 then
          FBatteryChargeStatus:=bsCritical
        else
          if (PS.BatteryFlag or 8)=8 then
            FBatteryChargeStatus:=bsCharging
          else
            if (PS.BatteryFlag or 128)=128 then
              FBatteryChargeStatus:=bsNoBattery
            else
              FBatteryChargeStatus:=bsUnknown;
    FBatteryLifePercent:=PS.BatteryLifePercent;
    FBatteryLifeTime:=PS.BatteryLifeTime;
    FBatteryLifeFullTime:=PS.BatteryFullLifeTime;
  end;

  {$IFDEF ERROR_INTERCEPT}PopTrace;{$ENDIF}
end;

procedure TAPM.Report;
begin
  {$IFDEF ERROR_INTERCEPT}PushTrace(FModes,Self,'Report'); {$ENDIF}
  with sl do begin
    if Standalone then ReportHeader(sl);
    Add('<APM classname="TAPM">');

    Add(Format('<data name="ACPowerStatus" type="string">%s</data>',[CheckXMLValue(GetACPSStr(ACPowerStatus))]));
    Add(Format('<data name="BatteryChargeStatus" type="string">%s</data>',[CheckXMLValue(GetBSStr(BatteryChargeStatus))]));
    if BatteryLifePercent<=100 then begin
      Add(Format('<data name="BatteryFullTime" type="string">%s</data>',[CheckXMLValue(FormatSeconds(BatteryLifeFullTime,true,false,false))]));
      Add(Format('<data name="BatteryLifeTime" type="string">%s</data>',[CheckXMLValue(FormatSeconds(BatteryLifeTime,true,false,false))]));
    end;

    Add('</APM>');
    if Standalone then ReportFooter(sl);
  end;
  {$IFDEF ERROR_INTERCEPT}PopTrace;{$ENDIF}
end;


procedure TAPM.SetMode(const Value: TExceptionModes);
begin
  FModes := Value;
end;

end.

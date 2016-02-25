{*******************************************************}
{                                                       }
{       MiTeC System Information Component              }
{               Machine Detection Part                  }
{           version 8.5 for Delphi 5,6,7                }
{                                                       }
{       Copyright © 1997,2003 Michal Mutl               }
{                                                       }
{*******************************************************}

{$INCLUDE MITEC_DEF.INC}

unit MSI_Machine;

interface

uses
  SysUtils, Windows, Classes, MSI_Common, MSI_SMBIOS;

type
  TBIOS = class(TPersistent)
  private
    FBIOSExtendedInfo: string;
    FBIOSCopyright: string;
    FBIOSName: string;
    FBIOSDate: string;
    FModes: TExceptionModes;
    procedure SetMode(const Value: TExceptionModes);
  public
    constructor Create;
    procedure GetInfo;
    procedure Report(var sl :TStringList; Standalone: Boolean = True); virtual;
  published
    property ExceptionModes: TExceptionModes read FModes Write SetMode;
    property Copyright :string read FBIOSCopyright {$IFNDEF D6PLUS} write FBIOSCopyright {$ENDIF} stored false;
    property Date :string read FBIOSDate {$IFNDEF D6PLUS} write FBIOSDate {$ENDIF} stored false;
    property ExtendedInfo :string read FBIOSExtendedInfo {$IFNDEF D6PLUS} write FBIOSExtendedInfo {$ENDIF} stored false;
    property Name :string read FBIOSName {$IFNDEF D6PLUS} write FBIOSName {$ENDIF} stored false;
  end;

  TMachine = class(TPersistent)
  private
    FName: string;
    FLastBoot: TDatetime;
    FUser: string;
    FSystemUpTime: Extended;
    FScrollLock: Boolean;
    FNumLock: Boolean;
    FCapsLock: Boolean;
    FComp: string;
    FSMBIOS: TSMBIOS;
    FBIOS: TBIOS;
    FModes: TExceptionModes;
    function GetSystemUpTime: Extended;
    procedure SetMode(const Value: TExceptionModes);
  public
    constructor Create;
    destructor Destroy; override;
    procedure GetInfo(IncludeSMBIOS: DWORD = 1);
    procedure Report(var sl :TStringList; Standalone: Boolean = True); virtual;
  published
    property ExceptionModes: TExceptionModes read FModes Write SetMode;
    property Name :string read FName {$IFNDEF D6PLUS} write FName {$ENDIF} stored false;
    property User :string read FUser {$IFNDEF D6PLUS} write FUser {$ENDIF} stored false;
    property SystemUpTime :Extended read FSystemUpTime {$IFNDEF D6PLUS} write FSystemUpTime {$ENDIF} stored false;
    property LastBoot :TDatetime read FLastBoot {$IFNDEF D6PLUS} write FLastBoot {$ENDIF} stored false;
    property CapsLock: Boolean read FCapsLock {$IFNDEF D6PLUS} write FCapsLock {$ENDIF} stored false;
    property NumLock: Boolean read FNumLock {$IFNDEF D6PLUS} write FNumLock {$ENDIF} stored false;
    property ScrollLock: Boolean read FScrollLock {$IFNDEF D6PLUS} write FScrollLock {$ENDIF} stored false;
    property Computer: string read FComp {$IFNDEF D6PLUS} write FComp {$ENDIF} stored False;
    property SMBIOS: TSMBIOS read FSMBIOS  {$IFNDEF D6PLUS} write FSMBIOS {$ENDIF} stored False;
    property BIOS: TBIOS read FBIOS  {$IFNDEF D6PLUS} write FBIOS {$ENDIF} stored False;
  end;


implementation

uses
  Registry, MiTeC_Routines, MSI_Devices, MiTeC_StrUtils, MiTeC_Datetime;

{ TMachine }

function TMachine.GetSystemUpTime: Extended;
begin
  try
    FSystemUpTime:=GetTickCount/1000;
  except
    FSystemUpTime:=0;
  end;
  result:=FSystemUpTime;
end;

procedure TMachine.GetInfo;
var
  keyState: TKeyboardState;
begin
  {$IFDEF ERROR_INTERCEPT}PushTrace(FModes,Self,'GetInfo'); {$ENDIF}

  BIOS.GetInfo;
  if IncludeSMBIOS=1 then
    SMBIOS.GetInfo(1);
  try
    FLastBoot:=Now-(GetTickCount/1000)/(24*3600);
  except
    FLastBoot:=0;
  end;
  FSystemUpTime:=GetSystemUpTime;
  FName:=GetMachine;
  FUser:=GetUser;
  GetKeyboardState(KeyState);
  FCapsLock:=KeyState[VK_CAPITAL]=1;
  FNumLock:=KeyState[VK_NUMLOCK]=1;
  FScrollLock:=KeyState[VK_SCROLL]=1;

  {$IFDEF ERROR_INTERCEPT}PopTrace;{$ENDIF}
end;


procedure TMachine.Report;
begin
  {$IFDEF ERROR_INTERCEPT}PushTrace(FModes,Self,'Report'); {$ENDIF}
  with sl do begin
    if Standalone then ReportHeader(sl);
    Add('<Machine classname="TMachine">');
    Add(Format('<data name="Name" type="string">%s</data>',[CheckXMLValue(Name)]));
    Add(Format('<data name="User" type="string">%s</data>',[CheckXMLValue(User)]));
    Add(Format('<data name="LastBoot" type="string">%s</data>',[DateTimeToStr(LastBoot)]));
    Add(Format('<data name="SystemUpTime" type="string">%s</data>',[FormatSeconds(SystemUpTime,true,false,false)]));
    Add(Format('<data name="Computer" type="string">%s</data>',[CheckXMLValue(Computer)]));
    Add('</Machine>');

    SMBIOS.Report(sl,False);
    BIOS.Report(sl,False);

    if Standalone then ReportFooter(sl);
  end;
  {$IFDEF ERROR_INTERCEPT}PopTrace;{$ENDIF}
end;

constructor TMachine.Create;
var
  i: Integer;
begin
  FSMBIOS:=TSMBIOS.Create;
  FBIOS:=TBIOS.Create;
  ExceptionModes:=[emExceptionStack];
  with TDevices.Create do begin
    GetInfo;
    for i:=0 to DeviceCount-1 do
      if Devices[i].DeviceClass=dcComputer then begin
        if Devices[i].FriendlyName='' then
          FComp:=Devices[i].Description
        else
          FComp:=Devices[i].FriendlyName;
        Break;
      end;
    Free;
  end;

end;

destructor TMachine.Destroy;
begin
  FBIOS.Free;
  FSMBIOS.Free;
  inherited;
end;

procedure TMachine.SetMode(const Value: TExceptionModes);
begin
  FModes := Value;
  if Assigned(BIOS) then
    BIOS.ExceptionModes:=FModes;
  if Assigned(SMBIOS) then
    SMBIOS.ExceptionModes:=FModes;
end;

{ TBIOS }

constructor TBIOS.Create;
begin
  ExceptionModes:=[emExceptionStack];
end;

procedure TBIOS.GetInfo;
const
  cBIOSName = $FE061;
  cBIOSDate = $FFFF5;
  cBIOSExtInfo = $FEC71;
  cBIOSCopyright = $FE091;

  rkBIOS = {HKEY_LOCAL_MACHINE}'\HARDWARE\DESCRIPTION\System';
    rvBiosDate = 'SystemBiosDate';
    rvBiosID = 'Identifier';
    rvBiosVersion = 'SystemBiosVersion';
begin
  {$IFDEF ERROR_INTERCEPT}PushTrace(FModes,Self,'GetInfo'); {$ENDIF}

  if isNT then begin
    FBIOSCopyright:=StringReplace(ReadRegistryValueAsString(HKEY_LOCAL_MACHINE,rkBIOS,rvBiosVersion,False),#13#10,' ',[rfIgnoreCase,rfReplaceAll]);
    FBIOSName:=ReadRegistryValueAsString(HKEY_LOCAL_MACHINE,rkBIOS,rvBiosID,False);
    FBIOSDate:=ReadRegistryValueAsString(HKEY_LOCAL_MACHINE,rkBIOS,rvBiosDate,False);
    FBIOSExtendedInfo:='';
  end else begin
    FBIOSName:=string(pchar(ptr(cBIOSName)));
    FBIOSDate:=string(pchar(ptr(cBIOSDate)));
    FBIOSCopyright:=string(pchar(ptr(cBIOSCopyright)));
    FBIOSExtendedInfo:=string(pchar(ptr(cBIOSExtInfo)));
  end;

  {$IFDEF ERROR_INTERCEPT}PopTrace;{$ENDIF}
end;

procedure TBIOS.Report;
begin
  {$IFDEF ERROR_INTERCEPT}PushTrace(FModes,Self,'Report'); {$ENDIF}
  with sl do begin
    if Standalone then ReportHeader(sl);
    Add('<BIOS classname="TBIOS">');

    Add(Format('<data name="Name" type="string">%s</data>',[CheckXMLValue(Name)]));
    Add(Format('<data name="Copyright" type="string">%s</data>',[CheckXMLValue(Copyright)]));
    Add(Format('<data name="Date" type="string">%s</data>',[CheckXMLValue(Date)]));
    Add(Format('<data name="Extended Info" type="string">%s</data>',[CheckXMLValue(ExtendedInfo)]));

    Add('</BIOS>');
    if Standalone then ReportFooter(sl);
  end;
  {$IFDEF ERROR_INTERCEPT}PopTrace;{$ENDIF}
end;

procedure TBIOS.SetMode(const Value: TExceptionModes);
begin
  FModes := Value;
end;

end.

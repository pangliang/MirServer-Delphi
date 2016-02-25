{*******************************************************}
{                                                       }
{       MiTeC System Information Component              }
{               Monitor Detection Part                  }
{           version 8.6.4 for Delphi 5,6,7              }
{                                                       }
{       Copyright © 1997,2004 Michal Mutl               }
{                                                       }
{*******************************************************}

{$INCLUDE MITEC_DEF.INC}

unit MSI_Monitor;

interface

uses MSI_Common, Windows, Classes, SysUtils;

const
  EDID_Header = $00FFFFFFFFFFFF00;

type
  TTimingDescriptor = record
    Flag: array[0..4] of Byte;
    Data: array[0..13] of Byte;
  end;

  TEDID = record
// Header
    Header: array[0..7] of Byte;
// Vender / Product ID / EDID Version
    EISA_ManufacturerCode: Word;
    ProductCode: Word;
    SerialNumber: DWORD;
    WeekOfManufacture: Byte;
    YearOfManufacture: Byte;
    EDID_Version: Byte;
    EDID_Revision: Byte;
// Display Parameter
    VideoInputDefinition: Byte;
    MaxHImageSize: Byte; //cm
    MaxVImageSize: Byte; //cm
    DisplayGamma: Byte; //=(gamma*100)-100
    Features: Byte;
// Panel Color Coordinates
    PanelColorCoordinates: array[0..9] of Byte;
// Established Timings
    EstablishedTimings: array[0..2] of Byte;
// Standard Timing ID
    StandardTimingID: array[0..15] of Byte;
// Timing Descriptor #1
    TD1: array[0..17] of Byte;
// Timing Descriptor #2 (MANUFACTURER SPECIFIED RANGE TIMING Descriptor)
    TD2: TTimingDescriptor;
// Timing Descriptor #3 (Supplier Name)
    TD3: TTimingDescriptor;
// Timing Descriptor #4 (Supplier P/N)
    TD4: TTimingDescriptor;

    ExtensionFlag: Byte; //(# of optional 128-byte EDID extension blocks to follow, typ=0)
    Checksum: Byte; //(the 1-byte sum of all 128 bytes in this EDID block shall equal zero)
  end;

  TMonitorRecord= record
    RegistryKey,
    DeviceDesription,
    Model,
    Manufacturer,
    Name,
    ProductNumber: string;
    Width,
    Height: Byte;
    SerialNumber: DWORD;
    Week,
    Year: WORD;
    ManufacturerCode,
    ProductCode: Word;
    Gamma: Double;
    EDID_Version: string;
  end;

  TMonitor = class(TPersistent)
  private
    FEDID: TEDID;
    FModes: TExceptionModes;
    FMR: array of TMonitorRecord;
    procedure SetMode(const Value: TExceptionModes);
    function GetCount: DWORD;
    function GetMonitor(Index: DWORD): TMonitorRecord;
    procedure SetCount(const Value: DWORD);
  public
    constructor Create;
    destructor Destroy; override;
    procedure GetInfo;
    procedure Report(var sl :TStringList; Standalone: Boolean = True); virtual;

    property Monitors[Index: DWORD]: TMonitorRecord read GetMonitor;
  published
    property ExceptionModes: TExceptionModes read FModes Write SetMode;

    property Count: DWORD read GetCount {$IFNDEF D6PLUS} Write SetCount {$ENDIF} stored False;
  end;

implementation

uses MSI_Devices, Registry, MiTeC_StrUtils;

{ TMonitor }

constructor TMonitor.Create;
begin
  inherited;
end;

destructor TMonitor.Destroy;
begin
  SetLength(FMR,0);
  inherited;
end;

function TMonitor.GetCount: DWORD;
begin
  Result:=Length(FMR);
end;

procedure TMonitor.GetInfo;
const
  rkDeviceParams = 'Device Parameters';
  rvEDID = 'EDID';
var
  i,n: Integer;
  edid: PChar;
  sa: DWORD;
begin
  {$IFDEF ERROR_INTERCEPT}PushTrace(FModes,Self,'GetInfo'); {$ENDIF}

  SetLength(FMR,0);

  with TDevices.Create do
    try
      GetInfo;
      for i:=0 to DeviceCount-1 do
        if Devices[i].DeviceClass=dcMonitor then begin
          SetLength(FMR,Length(FMR)+1);
          with FMR[High(FMR)] do begin
            if Devices[i].FriendlyName='' then
              DeviceDesription:=Devices[i].Description
            else
              DeviceDesription:=Devices[i].FriendlyName;
            RegistryKey:=Devices[i].RegKey;
            Model:=Trim(Copy(Devices[i].HardwareID,Pos('\',Devices[i].HardwareID)+1,255));
            Manufacturer:=Devices[i].Manufacturer;
          end;
        end;
    finally
      Free;
    end;

    with TRegistry.Create do
      try
        RootKey:=HKEY_LOCAL_MACHINE;
        for i:=0 to High(FMR) do 
          if OpenKeyReadOnly(FMR[i].RegistryKey+'\'+rkDeviceParams) then begin
            if ValueExists(rvEDID) then
              if GetDataType(rvEDID)=rdBinary then begin
                ZeroMemory(@FEDID,SizeOf(FEDID));
                n:=GetDataSize(rvEDID);
                edid:=stralloc(n);
                try
                  ReadBinaryData(rvEDID,edid^,n);
                  Move(edid^,FEDID,SizeOf(FEDID));
                  if FEDID.EstablishedTimings[2]=0 then begin
                    sa:=$36;
                    Move(edid[sa],FEDID.TD1,SizeOf(FEDID.TD1));
                    sa:=$48;
                    Move(edid[sa],FEDID.TD2,SizeOf(FEDID.TD2));
                    sa:=$5A;
                    Move(edid[sa],FEDID.TD3,SizeOf(FEDID.TD3));
                    sa:=$6C;
                    Move(edid[sa],FEDID.TD4,SizeOf(FEDID.TD4));
                  end;
                  if FEDID.TD2.Flag[3]=$FC then begin
                    FMR[i].Name:=Trim(GetStrFromBuf(FEDID.TD2.Data,SizeOf(FEDID.TD2.Data)));
                    FMR[i].ProductNumber:=Trim(GetStrFromBuf(FEDID.TD3.Data,SizeOf(FEDID.TD3.Data)));
                  end else begin
                    FMR[i].Name:=Trim(GetStrFromBuf(FEDID.TD3.Data,SizeOf(FEDID.TD3.Data)));
                    FMR[i].ProductNumber:=Trim(GetStrFromBuf(FEDID.TD4.Data,SizeOf(FEDID.TD4.Data)));
                  end;
                  FMR[i].Width:=FEDID.MaxHImageSize;
                  FMR[i].Height:=FEDID.MaxVImageSize;
                  FMR[i].SerialNumber:=FEDID.SerialNumber;
                  FMR[i].Week:=FEDID.WeekOfManufacture;
                  FMR[i].Year:=FEDID.YearOfManufacture+1990;
                  FMR[i].ManufacturerCode:=FEDID.EISA_ManufacturerCode;
                  FMR[i].ProductCode:=FEDID.ProductCode;
                  FMR[i].Gamma:=(FEDID.DisplayGamma+100)/100;
                  FMR[i].EDID_Version:=Format('%d.%d',[FEDID.EDID_Version,FEDID.EDID_Revision]);
                finally
                  strdispose(edid);
                end;
              end;
            CloseKey;
          end;
      finally
        Free;
      end;

  {$IFDEF ERROR_INTERCEPT}PopTrace;{$ENDIF}
end;

function TMonitor.GetMonitor(Index: DWORD): TMonitorRecord;
begin
  ZeroMemory(@Result,SizeOf(Result));
  try
    Result:=FMR[Index];
  except
  end;
end;

procedure TMonitor.Report(var sl: TStringList; Standalone: Boolean);
var
  i: Integer;
begin
  {$IFDEF ERROR_INTERCEPT}PushTrace(FModes,Self,'Report'); {$ENDIF}
  with sl do begin
    if Standalone then ReportHeader(sl);
    Add('<Monitor classname="TMonitor">');
    Add(Format('<data name="Count" type="integer">%d</data>',[Count]));
    if Self.Count>0 then
      for i:=0 to Self.Count-1 do begin
        Add(Format('<section name="%s">',[CheckXMLValue(Monitors[i].DeviceDesription)]));
        Add(Format('<data name="Name" type="string">%s</data>',[CheckXMLValue(Monitors[i].Name)]));
        Add(Format('<data name="ProductNumber" type="string">%s</data>',[CheckXMLValue(Monitors[i].ProductNumber)]));
        Add(Format('<data name="Modul" type="string">%s</data>',[CheckXMLValue(Monitors[i].Model)]));
        Add(Format('<data name="Manufacturer" type="string">%s</data>',[CheckXMLValue(Monitors[i].Manufacturer)]));
        Add(Format('<data name="EDID" type="string">%s</data>',[CheckXMLValue(Monitors[i].EDID_Version)]));
        Add(Format('<data name="Width" type="integer" unit="cm">%d</data>',[Monitors[i].Width]));
        Add(Format('<data name="Height" type="integer" unit="cm">%d</data>',[Monitors[i].Height]));
        Add(Format('<data name="Gamma" type="float">%1.2f</data>',[Monitors[i].Gamma]));
        Add(Format('<data name="SerialNumber" type="string">%8.8x</data>',[Monitors[i].SerialNumber]));
        Add(Format('<data name="Year" type="integer">%d</data>',[Monitors[i].Year]));
        Add(Format('<data name="Week" type="integer">%d</data>',[Monitors[i].Week]));
        Add('</section>');
      end;
    Add('</Monitor>');
    if Standalone then ReportFooter(sl);
  end;
  {$IFDEF ERROR_INTERCEPT}PopTrace;{$ENDIF}
end;

procedure TMonitor.SetCount(const Value: DWORD);
begin

end;

procedure TMonitor.SetMode(const Value: TExceptionModes);
begin
  FModes := Value;
end;

end.

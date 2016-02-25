{*******************************************************}
{                                                       }
{       MiTeC System Information Component              }
{           Storage devices enumeration                 }
{           version 8.6.4 for Delphi 5,6,7              }
{                                                       }
{       Copyright © 1997,2003 Michal Mutl               }
{                                                       }
{*******************************************************}

{$INCLUDE MITEC_DEF.INC}

unit MSI_Storage;

interface

uses
  MSI_Common, Windows, SysUtils, Classes, MiTeC_WinIOCTL;

type
  TDeviceInfo = record
    SerialNumber,
    Model,
    Revision: string;
    Capacity: Int64;
    Geometry: TDiskGeometry;
    Layout: TDiskLayout;
  end;

  TDeviceInfoArray = array of TDeviceInfo;

  TStorage= class(TPersistent)
  private
    FDI: TDeviceInfoArray;
    FCD: Byte;
    FModes: TExceptionModes;
    function GetConnectedDevices: Byte;
    function GetDeviceCount: Integer;
    function GetDeviceInfo(Index: integer): TDeviceInfo;
    procedure SetMode(const Value: TExceptionModes);
    procedure FreeDeviceInfoArray(var AList: TDeviceInfoArray);
  public
    constructor Create;
    destructor Destroy; override;
    procedure GetInfo;
    procedure Report(var sl: TStringList; Standalone: Boolean = True); virtual;
    property DeviceCount: Integer read GetDeviceCount;
    property Devices[Index: Integer]: TDeviceInfo read GetDeviceInfo;
  published
    property ExceptionModes: TExceptionModes read FModes Write SetMode;
    property ConnectedDevices: Byte read GetConnectedDevices {$IFNDEF D6PLUS} Write FCD {$ENDIF} stored False;
  end;

implementation

uses MiTeC_StrUtils;

{ TStorage }

constructor TStorage.Create;
begin
  inherited;
  ExceptionModes:=[emExceptionStack];
end;

destructor TStorage.Destroy;
begin
  inherited;
  FreeDeviceInfoArray(FDI);
end;

procedure TStorage.Report;
var
  i,j: Integer;
  s: string;
begin
  {$IFDEF ERROR_INTERCEPT}PushTrace(FModes,Self,'Report'); {$ENDIF}
  with sl do begin
    if Standalone then ReportHeader(sl);
    Add('<Storage classname="TStorage">');

    for i:=0 to High(FDI) do begin
      s:=Format('%s %s - %d MB',[MiTeC_WinIOCTL.GetMediaTypeStr(FDI[i].Geometry.MediaType),FDI[i].Model,(FDI[i].Capacity div 1024) div 1024]);
      Add(Format('<section name="%s">',[CheckXMLValue(s)]));
      Add(Format('<data name="MediaType" type="string">%s</data>',[CheckXMLValue(MiTeC_WinIOCTL.GetMediaTypeStr(FDI[i].Geometry.MediaType))]));
      Add(Format('<data name="SerialNumber" type="string">%s</data>',[CheckXMLValue(FDI[i].SerialNumber)]));
      Add(Format('<data name="ModelNumber" type="string">%s</data>',[CheckXMLValue(FDI[i].Model)]));
      Add(Format('<data name="RevisionNumber" type="string">%s</data>',[CheckXMLValue(FDI[i].Revision)]));
      Add(Format('<data name="CylinderCount" type="integer">%d</data>',[FDI[i].Geometry.Cylinders.QuadPart]));
      Add(Format('<data name="TracksPerCylinder" type="integer">%d</data>',[FDI[i].Geometry.TracksPerCylinder]));
      Add(Format('<data name="SectorsPerTrack" type="integer">%d</data>',[FDI[i].Geometry.SectorsPerTrack]));
      Add(Format('<data name="BytesPerSector" type="integer">%d</data>',[FDI[i].Geometry.BytesPerSector]));
      Add(Format('<data name="Capacity" type="integer" unit="B">%d</data>',[FDI[i].Capacity]));
      if Length(FDI[i].Layout)>0 then
        for j:=0 to High(FDI[i].Layout) do begin
          s:=Format('%s / %s - %d MB',[
                               GetPartitionType(FDI[i].Layout[j].PartitionNumber,FDI[i].Layout[j].PartitionType),
                               GetPartitionSystem(FDI[i].Layout[j].PartitionType),
                               (FDI[i].Layout[j].PartitionLength.QuadPart div 1024) div 1024]);
          Add(Format('<section name="%s">',[CheckXMLValue(s)]));
          Add(Format('<data name="StartingOffset" type="integer">%d</data>',[FDI[i].Layout[j].StartingOffset.QuadPart]));
          Add(Format('<data name="PartitionLength" type="integer" unit="B">%d</data>',[FDI[i].Layout[j].PartitionLength.QuadPart]));
          Add(Format('<data name="HiddenSectors" type="integer">%d</data>',[FDI[i].Layout[j].HiddenSectors]));
          Add(Format('<data name="PartitionNumber" type="string">%s</data>',[GetPartitionType(FDI[i].Layout[j].PartitionNumber,FDI[i].Layout[j].PartitionType)]));
          Add(Format('<data name="PartitionType" type="integer">%s</data>',[GetPartitionSystem(FDI[i].Layout[j].PartitionType)]));
          Add(Format('<data name="BootIndicator" type="boolean">%d</data>',[Integer(FDI[i].Layout[j].BootIndicator)]));
          Add(Format('<data name="RecognizedPartition" type="boolean">%d</data>',[Integer(FDI[i].Layout[j].RecognizedPartition)]));
          Add(Format('<data name="RewritePartition" type="boolean">%d</data>',[Integer(FDI[i].Layout[j].RewritePartition)]));
          Add('</section>');
        end;
      Add('</section>');
    end;

    Add('</Storage>');
    if Standalone then ReportFooter(sl);
  end;
  {$IFDEF ERROR_INTERCEPT}PopTrace;{$ENDIF}
end;

procedure TStorage.GetInfo;
var
  DI: TDriveInfo;
  DG1,DG2: TDiskGeometry;
  DL: TDiskLayout;
  i,j: Integer;
  dh: THandle;
  res: Integer;
  devinfo: TDeviceInfo;
begin
  {$IFDEF ERROR_INTERCEPT}PushTrace(FModes,Self,'GetInfo'); {$ENDIF}

  FreeDeviceInfoArray(FDI);
  FCD:=0;
  if Win32Platform=VER_PLATFORM_WIN32_NT then begin
    i:=0;
    repeat
      dh:=GetDeviceHandle(Format('PhysicalDrive%d',[i]));
      try
        ZeroMemory(@devinfo,SizeOf(devinfo));
        GetPhysicalDiskInfo(dh,DI,DG1);
        GetDiskGeometry(dh,DG2);
        GetDiskLayout(dh,DL);
        DI.Capacity:=DG2.Cylinders.QuadPart*DG2.TracksPerCylinder*DG2.SectorsPerTrack*DG2.BytesPerSector;
        if (DG2.MediaType<>Unknown) then begin
          devinfo.SerialNumber:=DI.SerialNumber;
          devinfo.Model:=DI.Model;
          devinfo.Revision:=DI.Revision;
          devinfo.Capacity:=DI.Capacity;
          devinfo.Geometry:=DG2;
          devinfo.Layout:=DL;
          SetLength(FDI,Length(FDI)+1);
          FDI[High(FDI)]:=devinfo;
        end;
      finally
        CloseHandle(dh);
      end;
      Inc(i);
    until dh=INVALID_HANDLE_VALUE;

    if Length(FDI)=0 then begin
    i:=0;
    repeat
      dh:=CreateFile(PChar(Format('\\.\Scsi%d:',[i])),
                      GENERIC_READ or GENERIC_WRITE,
                      FILE_SHARE_READ or FILE_SHARE_WRITE,
                      nil, OPEN_EXISTING, 0, 0 );
      try
        for j:=0 to 1 do begin
          ZeroMemory(@devinfo,SizeOf(devinfo));
          GetSCSIDiskInfo(dh,j,DI,DG1);
          devinfo.SerialNumber:=DI.SerialNumber;
          devinfo.Model:=DI.Model;
          devinfo.Revision:=DI.Revision;
          devinfo.Capacity:=DI.Capacity;
          devinfo.Geometry.MediaType:=FixedMedia;
          if GetSCSIDeviceInfo(dh,DI)=0 then begin
            devinfo.Geometry:=DG2;
            devinfo.Layout:=DL;
          end;
          if Trim(devinfo.Model)<>'' then begin
            SetLength(FDI,Length(FDI)+1);
            FDI[High(FDI)]:=devinfo;
          end;
        end;
      finally
        CloseHandle(dh);
      end;
      Inc(i);
    until dh=INVALID_HANDLE_VALUE;
    end;

    i:=0;
    repeat
      dh:=GetDeviceHandle(Format('Cdrom%d',[i]));
      try
        if GetSCSIDeviceInfo(dh,DI)=0 then begin
          ZeroMemory(@devinfo,SizeOf(devinfo));
          devinfo.SerialNumber:=DI.SerialNumber;
          devinfo.Model:=DI.Model;
          devinfo.Revision:=DI.Revision;
          devinfo.Capacity:=DI.Capacity;
          devinfo.Geometry.MediaType:=RemovableMedia;
          SetLength(FDI,Length(FDI)+1);
          FDI[High(FDI)]:=devinfo;
        end;
      finally
        CloseHandle(dh);
      end;
      Inc(i);
    until dh=INVALID_HANDLE_VALUE;
    i:=0;
    repeat
      dh:=GetDeviceHandle(Format('Tape%d',[i]));
      try
        if GetSCSIDeviceInfo(dh,DI)=0 then begin
          ZeroMemory(@devinfo,SizeOf(devinfo));
          devinfo.SerialNumber:=DI.SerialNumber;
          devinfo.Model:=DI.Model;
          devinfo.Revision:=DI.Revision;
          devinfo.Capacity:=DI.Capacity;
          devinfo.Geometry.MediaType:=RemovableMedia;
          SetLength(FDI,Length(FDI)+1);
          FDI[High(FDI)]:=devinfo;
        end;
      finally
        CloseHandle(dh);
      end;
      Inc(i);
    until dh=INVALID_HANDLE_VALUE;
  end else begin
    i:=0;
    repeat
      res:=GetSMARTDiskInfo(i,DI,DG1);
      if res=0 then begin
        ZeroMemory(@devinfo,SizeOf(devinfo));
        devinfo.SerialNumber:=DI.SerialNumber;
        devinfo.Model:=DI.Model;
        devinfo.Revision:=DI.Revision;
        devinfo.Capacity:=DI.Capacity;
        devinfo.Geometry:=DG1;
        SetLength(FDI,Length(FDI)+1);
        FDI[High(FDI)]:=devinfo;
      end;
      Inc(i);
    until res<>0;
  end;

  {$IFDEF ERROR_INTERCEPT}PopTrace;{$ENDIF}
end;

function TStorage.GetConnectedDevices: Byte;
begin
  Result:=Length(FDI);
end;

function TStorage.GetDeviceCount: Integer;
begin
  Result:=Length(FDI);
end;

function TStorage.GetDeviceInfo(Index: integer): TDeviceInfo;
begin
  ZeroMemory(@Result,SizeOf(TDeviceInfo));
  if (Index>=0) and (Index<Length(FDI)) then
    Result:=FDI[Index];
end;

procedure TStorage.SetMode(const Value: TExceptionModes);
begin
  FModes := Value;
end;

procedure TStorage.FreeDeviceInfoArray;
var
  i: Integer;
begin
  for i:=0 to High(AList) do
    Finalize(AList[i].Layout);
  Finalize(Alist);
end;

end.

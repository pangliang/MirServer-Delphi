{*******************************************************}
{                                                       }
{       MiTeC System Information Component              }
{         IDE connected devices enumeration             }
{           version 8.1 for Delphi 5,6,7                }
{                                                       }
{       Copyright © 1997,2003 Michal Mutl               }
{                                                       }
{*******************************************************}

{$INCLUDE MITEC_DEF.INC}

unit MSI_IDE;

interface

uses
  Windows, SysUtils, Classes, MiTeC_WinIOCTL, MiTeC_WnASPI32;

type
  TAccessMethod = (amPhysical, amSCSI, amInt21h, amSMART, amASPI, amRegistry);


  TDeviceInfo = class(TPersistent)
  private
    FC: DWORD;
    FH: DWORD;
    FS: int64;
    FSPT: DWORD;
    FSN: string;
    FMN: string;
    FRN: string;
    FEM: string;
    FEC: Integer;
    FAM: TAccessMethod;
  public
    property ErrorCode: Integer read FEC Write FEC;
  published
    property AccessMethod: TAccessMethod read FAM write FAM stored False;
    property SerialNumber: string read FSN write FSN stored False;
    property ModelNumber: string read FMN write FMN stored False;
    property RevisionNumber: string read FRN write FRN stored False;
    property Cylinders: DWORD read FC write FC stored False;
    property Heads: DWORD read FH write FH stored False;
    property SectorsPerTrack: DWORD read FSPT write FSPT stored False;
    property Capacity: int64 read FS write FS stored False;
    property ErrorMessage: string read FEM Write FEM;
  end;

  TDeviceInfoArray = array[0..3] of TDeviceInfo;

  TIDE= class(TPersistent)
  private
    FDI: TDeviceInfoArray;
    procedure GetDeviceInfo(const Value: TAccessMethod);
  public
    constructor Create;
    destructor Destroy; override;
    procedure GetInfo;
    procedure Report(var sl: TStringList; Standalone: Boolean = True); virtual;
  published
    property PrimaryMaster: TDeviceInfo read FDI[0] {$IFNDEF D6PLUS} write FDI[0] {$ENDIF} stored False;
    property PrimarySlave: TDeviceInfo read FDI[1] {$IFNDEF D6PLUS} write FDI[1] {$ENDIF} stored False;
    property SecondaryMaster: TDeviceInfo read FDI[2] {$IFNDEF D6PLUS} write FDI[2] {$ENDIF} stored False;
    property SecondarySlave: TDeviceInfo read FDI[3] {$IFNDEF D6PLUS} write FDI[3] {$ENDIF} stored False;
  end;

function GetRegistryDiskInfo(Drive: Byte; var DI: TDriveInfo): Integer;
function GetASPIDiskInfo(Drive: Byte; var DI: TDriveInfo): Integer;


implementation

uses Registry, MSI_Common, MiTeC_StrUtils;

{ TMIDE }

function GetRegistryDiskInfo(Drive: Byte; var DI: TDriveInfo): integer;
const
  rvId = 'Identifier';

  rkDrive0 = {HKEY_LOCAL_MACHINE\}'HARDWARE\DEVICEMAP\Scsi\Scsi Port 0\Scsi Bus 0\Target Id 0\Logical Unit Id 0';
  rkDrive1 = {HKEY_LOCAL_MACHINE\}'HARDWARE\DEVICEMAP\Scsi\Scsi Port 0\Scsi Bus 0\Target Id 1\Logical Unit Id 0';
  rkDrive2 = {HKEY_LOCAL_MACHINE\}'HARDWARE\DEVICEMAP\Scsi\Scsi Port 1\Scsi Bus 0\Target Id 0\Logical Unit Id 0';
  rkDrive3 = {HKEY_LOCAL_MACHINE\}'HARDWARE\DEVICEMAP\Scsi\Scsi Port 1\Scsi Bus 0\Target Id 1\Logical Unit Id 0';
var
  ok: Boolean;
  p: Integer;
  s: string;
begin
  Result:=0;
  ZeroMemory(@DI,SizeOf(TDriveInfo));
  with TRegistry.Create do begin
    RootKey:=HKEY_LOCAL_MACHINE;
    try
      case Drive of
        0: ok:=OpenKeyReadOnly(rkDrive0);
        1: ok:=OpenKeyReadOnly(rkDrive1);
        2: ok:=OpenKeyReadOnly(rkDrive2);
        3: ok:=OpenKeyReadOnly(rkDrive3);
      end;
      if ok then begin
        try
          s:=ReadString(rvId);
          p:=Pos('     ',s);
          if p>0 then begin
            DI.Model:=Trim(Copy(s,1,p));
            DI.Revision:=Trim(Copy(s,p,255));
          end else
            DI.Model:=s;
        except
        end;
        CloseKey;
      end;
    finally
      Free;
    end;
  end;
end;

function GetASPIDiskInfo(Drive: Byte; var DI: TDriveInfo): Integer;
var
  ASPIConfig: TASPIConfig;
  i: Integer;
begin
  ASPIConfig.Adapter:=TStringList.Create;
  ASPIConfig.ID:=TStringList.Create;
  ASPIConfig.Vendor:=TStringList.Create;
  ASPIConfig.Product:=TStringList.Create;
  ASPIConfig.Typ:=TStringList.Create;
  ASPIConfig.Status:=TStringList.Create;
  ASPIConfig.Revision:=TStringList.Create;
  ASPIConfig.Spec:=TStringList.Create;
  try
    ZeroMemory(@DI,sizeof(DI));
    Result:=HIBYTE(LOWORD(ExecuteASPI32Test(ASPIConfig)));
    if Result=SS_COMP then begin
      Result:=0;
      for i:=0 to ASPIConfig.Adapter.Count-1 do
        if StrToInt(ASPIConfig.Adapter[i])*2+StrToInt(ASPIConfig.ID[i])=Drive then
          with DI do begin
            Model:=ASPIConfig.Vendor[i]+ASPIConfig.Product[i];
            SerialNumber:='';
            Revision:=ASPIConfig.Revision[i];
            Capacity:=0;
            ZeroMemory(@Geometry, sizeof(Geometry));
            ZeroMemory(@Layout,sizeof(Layout));
          end;
    end;
  finally
    ASPIConfig.Adapter.Free;
    ASPIConfig.ID.Free;
    ASPIConfig.Vendor.Free;
    ASPIConfig.Product.Free;
    ASPIConfig.Typ.Free;
    ASPIConfig.Status.Free;
    ASPIConfig.Revision.Free;
    ASPIConfig.Spec.Free;
  end;
end;

constructor TIDE.Create;
var
  i: Integer;
begin
  inherited;
  for i:=Low(TDeviceInfoArray) to High(TDeviceInfoArray) do
    FDI[i]:=TDeviceInfo.Create;
end;

destructor TIDE.Destroy;
var
  i: Integer;
begin
  inherited;
  for i:=Low(TDeviceInfoArray) to High(TDeviceInfoArray) do
    FDI[i].Free;
end;

procedure TIDE.GetDeviceInfo;
var
  i,j: Integer;
  di: TDriveInfo;
begin
  case Value of
    amPhysical: begin
      for i:=Low(TDeviceInfoArray) to High(TDeviceInfoArray) do begin
        if IsEmptyString(FDI[i].ModelNumber) then begin
          FDI[i].AccessMethod:=Value;
          FDI[i].ErrorCode:=GetSMARTDiskInfo(i,di);;
          FDI[i].SerialNumber:=di.SerialNumber;
          FDI[i].ModelNumber:=di.Model;
          FDI[i].RevisionNumber:=di.Revision;
          FDI[i].Cylinders:=di.Geometry.Cylinders.QuadPart;
          FDI[i].Heads:=di.Geometry.TracksPerCylinder;
          FDI[i].SectorsPerTrack:=di.Geometry.SectorsPerTrack;
          FDI[i].Capacity:=DI.Capacity;
          FDI[i].ErrorMessage:=SysErrorMessage(FDI[i].ErrorCode);
        end;
      end;
    end;
    amSCSI: begin
      for i:=0 to 1 do begin
        for j:=0 to 1 do begin
          if IsEmptyString(FDI[i*2+j].ModelNumber) then begin
            FDI[i*2+j].AccessMethod:=Value;
            FDI[i*2+j].ErrorCode:=GetSCSIDiskInfo(i,j,di);
            FDI[i*2+j].SerialNumber:=di.SerialNumber;
            FDI[i*2+j].ModelNumber:=di.Model;
            FDI[i*2+j].RevisionNumber:=di.Revision;
            FDI[i*2+j].Cylinders:=di.Geometry.Cylinders.QuadPart;
            FDI[i*2+j].Heads:=di.Geometry.TracksPerCylinder;
            FDI[i*2+j].SectorsPerTrack:=di.Geometry.SectorsPerTrack;
            FDI[i*2+j].Capacity:=DI.Capacity;
            FDI[i*2+j].ErrorMessage:=SysErrorMessage(FDI[i*2+j].ErrorCode);
          end;
        end;
      end;
    end;
    amInt21H: begin
      for i:=Low(TDeviceInfoArray) to High(TDeviceInfoArray) do begin
        if IsEmptyString(FDI[i].ModelNumber) then begin
          FDI[i].AccessMethod:=Value;
          FDI[i].ErrorCode:=GetInt21hDiskInfo(i,di);
          FDI[i].SerialNumber:=di.SerialNumber;
          FDI[i].ModelNumber:=di.Model;
          FDI[i].RevisionNumber:=di.Revision;
          FDI[i].Cylinders:=di.Geometry.Cylinders.QuadPart;
          FDI[i].Heads:=di.Geometry.TracksPerCylinder;
          FDI[i].SectorsPerTrack:=di.Geometry.SectorsPerTrack;
          FDI[i].Capacity:=DI.Capacity;
          FDI[i].ErrorMessage:=SysErrorMessage(FDI[i].ErrorCode);
        end;
      end;
    end;
    amSMART: begin
      for i:=Low(TDeviceInfoArray) to High(TDeviceInfoArray) do begin
        if IsEmptyString(FDI[i].ModelNumber) then begin
          FDI[i].AccessMethod:=Value;
          FDI[i].ErrorCode:=GetSMARTDiskInfo(i,di);
          FDI[i].SerialNumber:=di.SerialNumber;
          FDI[i].ModelNumber:=di.Model;
          FDI[i].RevisionNumber:=di.Revision;
          FDI[i].Cylinders:=di.Geometry.Cylinders.QuadPart;
          FDI[i].Heads:=di.Geometry.TracksPerCylinder;
          FDI[i].SectorsPerTrack:=di.Geometry.SectorsPerTrack;
          FDI[i].Capacity:=DI.Capacity;
          FDI[i].ErrorMessage:=SysErrorMessage(FDI[i].ErrorCode);
        end;
      end;
    end;
    amASPI: begin
      for i:=Low(TDeviceInfoArray) to High(TDeviceInfoArray) do begin
        if IsEmptyString(FDI[i].ModelNumber) then begin
          FDI[i].AccessMethod:=Value;
          FDI[i].ErrorCode:=GetASPIDiskInfo(i,di);
          FDI[i].SerialNumber:=di.SerialNumber;
          FDI[i].ModelNumber:=di.Model;
          FDI[i].RevisionNumber:=di.Revision;
          FDI[i].Cylinders:=di.Geometry.Cylinders.QuadPart;
          FDI[i].Heads:=di.Geometry.TracksPerCylinder;
          FDI[i].SectorsPerTrack:=di.Geometry.SectorsPerTrack;
          FDI[i].Capacity:=DI.Capacity;
          FDI[i].ErrorMessage:=SysErrorMessage(FDI[i].ErrorCode);
        end;
      end;
    end;
    amRegistry: begin
      for i:=Low(TDeviceInfoArray) to High(TDeviceInfoArray) do begin
        if IsEmptyString(FDI[i].ModelNumber) then begin
          FDI[i].AccessMethod:=Value;
          FDI[i].ErrorCode:=GetRegistryDiskInfo(i,di);
          FDI[i].SerialNumber:=di.SerialNumber;
          FDI[i].ModelNumber:=di.Model;
          FDI[i].RevisionNumber:=di.Revision;
          FDI[i].Cylinders:=di.Geometry.Cylinders.QuadPart;
          FDI[i].Heads:=di.Geometry.TracksPerCylinder;
          FDI[i].SectorsPerTrack:=di.Geometry.SectorsPerTrack;
          FDI[i].Capacity:=DI.Capacity;
          FDI[i].ErrorMessage:=SysErrorMessage(FDI[i].ErrorCode);
        end;
      end;
    end;
  end;
end;

procedure TIDE.Report;
var
  i: Integer;
  s: string;
begin
  with sl do begin
    if Standalone then ReportHeader(sl);
    Add('<IDE classname="TIDE">');

    for i:=Low(TDeviceInfoArray) to High(TDeviceInfoArray) do begin
      case FDI[i].AccessMethod of
        amPhysical: s:='Physical';
        amSCSI: s:='SCSI';
        amInt21h: s:='Int21';
        amSMART: s:='SMART';
        amRegistry: s:='Registry';
        amASPI: s:='ASPI';
      end;
      case i of
        0: Add('<section name="Primary Master">');
        1: Add('<section name="Primary Slave">');
        2: Add('<section name="Secondary Master">');
        3: Add('<section name="Secondary Slave">');
      end;
      Add(Format('<data name="SerialNumber" type="string" source="%s">%s</data>',[s,CheckXMLValue(FDI[i].SerialNumber)]));
      Add(Format('<data name="ModelNumber" type="string" source="%s">%s</data>',[s,CheckXMLValue(FDI[i].ModelNumber)]));
      Add(Format('<data name="RevisionNumber" type="string" source="%s">%s</data>',[s,CheckXMLValue(FDI[i].RevisionNumber)]));
      Add(Format('<data name="CylinderCount" type="integer" source="%s">%d</data>',[s,FDI[i].Cylinders]));
      Add(Format('<data name="HeadCount" type="integer" source="%s">%d</data>',[s,FDI[i].Heads]));
      Add(Format('<data name="SectorsPerTrack" type="integer" source="%s">%d</data>',[s,FDI[i].SectorsPerTrack]));
      Add(Format('<data name="Capacity" type="integer" source="%s" unit="MB">%d</data>',[s,(FDI[i].Capacity div 1024) div 1024]));
      Add('</section>');
    end;

    Add('</IDE>');
    if Standalone then ReportFooter(sl);
  end;
end;

procedure TIDE.GetInfo;
var
  am: TAccessMethod;
begin
  for am:=Low(TAccessMethod) to High(TAccessMethod) do
    GetDeviceInfo(am);
end;

end.

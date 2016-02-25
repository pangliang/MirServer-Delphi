{*******************************************************}
{                                                       }
{       MiTeC System Information Component              }
{               Device Detection Part                   }
{           version 8.6.4 for Delphi 5,6,7              }
{                                                       }
{       Copyright © 1997,2004 Michal Mutl               }
{                                                       }
{*******************************************************}

{$INCLUDE MITEC_DEF.INC}

unit MSI_Devices;

interface

uses
  MSI_Common, SysUtils, Windows, Classes, MiTeC_NTDDK;

type
  TDeviceClass = (dcBattery, dcComputer, dcDiskDrive, dcDisplay, dcCDROM, dcfdc,
                  dcFloppyDisk, dcGPS, dcHIDClass, dchdc, dc1394, dcImage, dcInfrared,
                  dcKeyboard, dcMediumChanger, dcMTD, dcMouse, dcModem, dcMonitor,
                  dcMultiFunction, dcPortSerial, dcNet, dcLegacyDriver,
                  dcNtApm, dcUnknown, dcPCMCIA, dcPorts, dcPrinter, dcSCSIAdapter,
                  dcSmartCardReader, dcMEDIA, dcVolume, dcSystem, dcTapeDrive,
                  dcTapeController, dcTape, dcUSB, dcProcessor);

  PDevice = ^TDevice;

  TDevice = record
    Name,
    ClassName,
    ClassDesc,
    ClassIcon,
    FriendlyName,
    Description,
    GUID,
    Manufacturer,
    Location: String;
    PCINumber,
    DeviceNumber,
    FunctionNumber: Integer;
    HardwareID,
    DeviceParam,
    Driver,
    DriverDate,
    DriverVersion,
    DriverProvider,
    InfPath,
    Service,
    ServiceName,
    ServiceGroup: string;
    ServiceType: integer;
    RegKey: string;
    ResourceListKey,
    ResourceListValue: string;
    DeviceClass :TDeviceClass;
    VendorID,
    DeviceID,
    SubSysID,
    Revision: DWORD;
  end;

  TDeviceList = TStringList;

  TResourceItem = record
    Resource: shortstring;
    Share: CM_SHARE_DISPOSITION;
    Device: shortstring;
    DeviceClass :TDeviceClass;
  end;

  TResourceList = array of TResourceItem;

  TDevices = class(TPersistent)
  private
    FCount: integer;
    FDeviceList: TDeviceList;
    FModes: TExceptionModes;
    function GetDevice(Index: integer): TDevice;
    function GetDeviceCount: integer;
    procedure ScanDevices(var ADeviceList: TDeviceList);
    function GetDeviceClass(AClassName: string): TDeviceClass;
    procedure GetLocation(ASource: string; var PCI,Device,Func: Integer);

    procedure ClearList;
    procedure SetMode(const Value: TExceptionModes);
  public
    constructor Create;
    destructor Destroy; override;
    procedure GetInfo;
    procedure GetDeviceResources(Adevice: TDevice; var DR: TDeviceResources);
    procedure GetResourceList(var RL: TResourceList);
    procedure Report(var sl :TStringList; Standalone: Boolean = True); virtual;
    procedure GetDevicesByClass(ADeviceClass: TDeviceClass; var ADevices: TStrings);
    property Devices[Index: integer]: TDevice read GetDevice;
  published
    property ExceptionModes: TExceptionModes read FModes Write SetMode;
    property DeviceCount: integer read FCount {$IFNDEF D6PLUS} write FCount {$ENDIF} stored False;
  end;



implementation

uses Registry, MiTeC_Routines, MiTeC_StrUtils;

const
  DeviceClass :array[dcBattery..dcProcessor] of string =
                 ('Battery', 'Computer', 'DiskDrive', 'Display', 'CDROM', 'fdc',
                  'FloppyDisk', 'GPS', 'HID', 'hdc', '1394', 'Image', 'Infrared',
                  'Keyboard', 'MediumChanger', 'MTD', 'Mouse', 'Modem', 'Monitor',
                  'MultiFunction', 'MultiPortSerial', 'Net', 'LegacyDriver',
                  'NtApm', 'Unknown', 'PCMCIA', 'Ports', 'Printer', 'SCSIAdapter',
                  'SmartCardReader', 'MEDIA', 'Volume', 'System', 'TapeDrive',
                  'TapeController', 'Tape', 'USB', 'Processor');

{ TDevices }

constructor TDevices.Create;
begin
  ExceptionModes:=[emExceptionStack];
  FDeviceList:=TDeviceList.Create;
end;

destructor TDevices.Destroy;
begin
  ClearList;
  FDeviceList.Free;
  inherited;
end;

procedure TDevices.GetDevicesByClass;
var
  i,c: integer;
begin
  ADevices.Clear;
  c:=DeviceCount-1;
  for i:=0 to c do
    if Devices[i].DeviceClass=ADeviceClass then
      ADevices.Add(Devices[i].Name);
end;

function TDevices.GetDevice(Index: integer): TDevice;
begin
  try
    Result:=PDevice(FDeviceList.Objects[Index])^;
  except
  end;
end;

function TDevices.GetDeviceClass(AClassName: string): TDeviceClass;
var
  i: TDeviceClass;
begin
  Result:=dcUnknown;
  AClassName:=UpperCase(AClassName);
  for i:=Low(TDeviceClass) to High(TDeviceClass) do
    if Pos(UpperCase(DeviceClass[i]),AClassName)=1 then begin
      Result:=i;
      Break;
    end;
end;

function TDevices.GetDeviceCount: integer;
begin
  Result:=FDeviceList.Count;
end;

procedure TDevices.GetInfo;
begin
  {$IFDEF ERROR_INTERCEPT}PushTrace(FModes,Self,'GetInfo'); {$ENDIF}

  ScanDevices(FDeviceList);
  FDeviceList.Sort;
  FCount:=GetDeviceCount;

  {$IFDEF ERROR_INTERCEPT}PopTrace;{$ENDIF}
end;

procedure TDevices.Report;
var
  i,did,c,j: integer;
  s,sn,ls: string;
  RL: TResourceList;
  tl,vl: TStringList;
  DR: TDeviceResources;
begin
  {$IFDEF ERROR_INTERCEPT}PushTrace(FModes,Self,'Report'); {$ENDIF}
  c:=DeviceCount;
  with sl do begin
    tl:=TStringList.Create;
    vl:=TStringList.Create;
    try
      if Standalone then ReportHeader(sl);
      Add('<Devices classname="TDevices">');

      Add(Format('<data name="Count" type="integer">%d</data>',[c]));

      for i:=0 to c-1 do begin
        if Trim(Devices[i].ClassDesc)<>'' then
          sn:=Devices[i].ClassDesc
        else
          sn:=Devices[i].ClassName;
        tl.Add(Format('%s=%d',[UpperCase(sn),i]));
      end;
      tl.Sort;
      sn:='';
      for i:=0 to tl.Count-1 do begin
        c:=Pos('=',tl[i]);
        did:=StrToIntEx(Trim(Copy(tl[i],c+1,5)));
        ls:=Copy(tl[i],1,c-1);
        if not SameText(ls,sn) then begin
          if sn<>'' then
            Add('</section>');
          if Trim(Devices[did].ClassDesc)<>'' then
            s:=Devices[did].ClassDesc
          else
            s:=Devices[did].ClassName;
          Add(Format('<section name="%s">',[CheckXMLValue(s)]));
          sn:=ls;
        end;
        Add(Format('<section name="%s">',[CheckXMLValue(Devices[did].Name)]));

        Add(Format('<data name="ClassName" type="string">%s</data>',[CheckXMLValue(Devices[did].ClassDesc)]));
        Add(Format('<data name="ClassGUID" type="string">%s</data>',[CheckXMLValue(Devices[did].GUID)]));
        Add(Format('<data name="Manufacturer" type="string">%s</data>',[CheckXMLValue(Devices[did].Manufacturer)]));
        Add(Format('<data name="Location" type="string">%s</data>',[CheckXMLValue(Devices[did].Location)]));
        Add(Format('<data name="HardwareID" type="string">%s</data>',[CheckXMLValue(Devices[did].HardwareID)]));
        Add(Format('<data name="VendorID" type="integer">%d</data>',[Devices[did].VendorID]));
        Add(Format('<data name="DeviceID" type="integer">%d</data>',[Devices[did].DeviceID]));
        Add(Format('<data name="SubSystemID" type="integer">%d</data>',[Devices[did].SubSysID]));
        Add(Format('<data name="Revision" type="integer">%d</data>',[Devices[did].Revision]));
        Add(Format('<data name="RegistryInfo" type="string">%s</data>',[CheckXMLValue(Devices[did].Driver)]));
        Add(Format('<data name="DriverDate" type="string">%s</data>',[CheckXMLValue(Devices[did].DriverDate)]));
        Add(Format('<data name="DriverVersion" type="string">%s</data>',[CheckXMLValue(Devices[did].DriverVersion)]));
        Add(Format('<data name="DriverProvider" type="string">%s</data>',[CheckXMLValue(Devices[did].DriverProvider)]));
        Add(Format('<data name="ServiceName" type="string">%s</data>',[CheckXMLValue(Devices[did].ServiceName)]));
        Add(Format('<data name="ServiceGroup" type="string">%s</data>',[CheckXMLValue(Devices[did].ServiceGroup)]));

        if not IsEmptyString(Devices[did].ResourceListKey) then begin
          GetDeviceResources(Devices[did],DR);
          Add('<section name="Resources">');
          for j:=0 to High(DR.Resources) do
             case DR.Resources[j].Typ of
               CmResourceTypePort:
                  Add(Format('<data name="%s" type="string">%4.4x - %4.4x</data>',[
                              DeviceResourceTypeStr(dr.Resources[j].Typ),
                              dr.Resources[j].Port.Start.QuadPart,
                              dr.Resources[j].Port.Start.QuadPart+dr.Resources[j].Port.Length-1]));
               CmResourceTypeInterrupt:
                  Add(Format('<data name="%s" type="string">%2.2d</data>',[
                              DeviceResourceTypeStr(dr.Resources[j].Typ),
                              dr.Resources[j].Interrupt.Vector]));
               CmResourceTypeMemory:
                  Add(Format('<data name="%s" type="string">%4.4x - %4.4x</data>',[
                              DeviceResourceTypeStr(dr.Resources[j].Typ),
                              dr.Resources[j].Memory.Start.QuadPart,
                              dr.Resources[j].Memory.Start.QuadPart+dr.Resources[j].Memory.Length-1]));
               CmResourceTypeDma:
                  Add(Format('<data name="%s" type="string">%2.2d</data>',[
                             DeviceResourceTypeStr(dr.Resources[j].Typ),
                             dr.Resources[j].DMA.Channel]));
            end;
          Add('</section>');
        end;
        Add('</section>');
      end;
      if tl.Count>0 then
        Add('</section>');

      Add('</Devices>');

      if IsNT then begin

        GetResourceList(RL);

        if Length(RL)>0 then begin
          Add('<DeviceResources classname="TDevices">');

          Add(Format('<data name="Count" type="integer">%d</data>',[Length(RL)]));
          tl.Clear;

          for i:=0 to High(RL) do begin
            tl.Add(Format('<section name="%s">',[RL[i].Resource]));
            tl.Add(Format('<section name="%s">',[RL[i].Resource])+Format('<data name="%s" type="string">%s</data>',[CheckXMLValue(RL[i].Device),ResourceShareStr(RL[i].Share)]));
          end;
          tl.Sort;
          sn:='';
          for i:=0 to tl.Count-1 do begin
            s:=tl[i];
            if Pos('</data>',s)>0 then
              Add(Copy(s,Length(sn)+1,Length(s)))
            else begin
              if not SameText(sn,s) then begin
                if sn<>'' then
                  Add('</section>');
                sn:=s;
                Add(sn);
              end;
            end;
          end;
          if sn<>'' then
            Add('</section>');
          Add('</DeviceResources>');
        end;
      end;

    finally
      tl.Free;
      vl.Free;
    end;
    if Standalone then ReportFooter(sl);
  end;
  {$IFDEF ERROR_INTERCEPT}PopTrace;{$ENDIF}
end;

procedure TDevices.ScanDevices(var ADeviceList: TDeviceList);

procedure GetDeviceClass(AGUID :string; var AClassName, AClassDesc, AClassIcon: string);
var
  i :integer;
  sl :TStringList;
  rkClass, vLink: string;
const
  rvClass = 'Class';
  rvIcon = 'Icon';
  rvLink = 'Link';

  rkClassNT = {HKEY_LOCAL_MACHINE}'\SYSTEM\CurrentControlSet\Control\Class';
  rkClass9x = {HKEY_LOCAL_MACHINE}'\SYSTEM\CurrentControlSet\Services\Class';
begin
  if IsNT then
    rkClass:=rkClassNT
  else
    rkClass:=rkClass9x;
  with TRegistry.Create do begin
    RootKey:=HKEY_LOCAL_MACHINE;
    if OpenKeyReadOnly(rkClass) then begin
      sl:=TStringList.Create;
      GetKeyNames(sl);
      CloseKey;
      i:=sl.IndexOf(AGUID);
      if i>-1 then
        if OpenKeyReadOnly(rkClass+'\'+sl[i]) then begin
          AClassName:=ReadString(rvClass);
          if not IsNT then begin
            vLink:=ReadString(rvLink);
            CloseKey;
            if not OpenKeyReadOnly(rkClass+'\'+vLink) then
              Exit;
          end;
          AClassIcon:=ReadString(rvIcon);
          AClassDesc:=ReadString('');
          CloseKey;
        end;
      sl.Free;
    end;
    free;
  end;
end;

procedure GetDeviceDriver(AGUID :string; var ADate, AVersion, AProvider, AInfPath: string);
var
  rkClass: string;
const
  rvDate = 'DriverDate';
  rvVersion = 'DriverVersion';
  rvProvider = 'ProviderName';
  rvINFPath = 'InfPath';

  rkClassNT = {HKEY_LOCAL_MACHINE}'\SYSTEM\CurrentControlSet\Control\Class';
  rkClass9x = {HKEY_LOCAL_MACHINE}'\SYSTEM\CurrentControlSet\Services\Class';
begin
  if IsNT then
    rkClass:=rkClassNT
  else
    rkClass:=rkClass9x;
  AGUID:=StringReplace(AGUID,'\\','\',[rfReplaceAll,rfIgnoreCase]);
  with TRegistry.Create do begin
    RootKey:=HKEY_LOCAL_MACHINE;
    if OpenKeyReadOnly(rkClass+'\'+AGUID) then begin
      ADate:=ReadString(rvDate);
      AVersion:=ReadString(rvVersion);
      AProvider:=ReadString(rvProvider);
      AInfPath:=ReadString(rvInfPath);
      CloseKey;
    end;
    free;
  end;
end;

procedure GetDeviceService(AGUID :string; var AName, AGroup: string; var AType: integer);
var
  s: string;
  rc: Integer;
const
  rvName = 'DisplayName';
  rvGroup = 'Group';
  rvType = 'Type';

  rkClass = {HKEY_LOCAL_MACHINE}'\SYSTEM\CurrentControlSet\Services';
begin
  AName:=ReadRegistryValueAsString(HKEY_LOCAL_MACHINE,rkClass+'\'+AGUID,rvName,False);
  AGroup:=ReadRegistryValueAsString(HKEY_LOCAL_MACHINE,rkClass+'\'+AGUID,rvGroup,False);
  s:=ReadRegistryValueAsString(HKEY_LOCAL_MACHINE,rkClass+'\'+AGUID,rvType,False);
  Val(s,AType,rc);
end;

procedure GetResourceListLocationNT(AKey: string; var RLKey, RLValue: string);
var
  i,j :integer;
  sl,vl :TStringList;
  DataSize, DataType: Integer;
begin
  RLKey:='';
  RLValue:='';
  with TRegistry.Create do
    try
      RootKey:=HKEY_LOCAL_MACHINE;
      if OpenKeyReadOnly(AKey) then begin
        sl:=TStringList.Create;
        vl:=TStringList.Create;
        try
          GetKeyNames(sl);
          sl.Sort;
          for i:=0 to sl.Count-1 do begin
            if OpenKeyReadOnly(AKey+'\'+sl[i]) then begin
              GetValueNames(vl);
              for j:=0 to vl.Count-1 do begin
                RegQueryValueEx(CurrentKey,PChar(vl[j]),nil,PDWORD(@DataType),nil,PDWORD(@DataSize));
                if DataType=REG_RESOURCE_LIST then begin
                  RLKey:=AKey+'\'+sl[i];
                  RLValue:=vl[j];
                  Break;
                end;
              end;
              CloseKey;
              if not IsEmptyString(RLKey) then
                Break;
            end;
          end;
        finally
          sl.Free;
          vl.Free;
          CloseKey;
        end;
      end;
    finally
      Free;
    end;
end;

procedure GetResourceListLocation9x(AKey: string; var RLKey, RLValue: string);
const
  rk9x = 'LogConfig';
  rv9x = '0000';
begin
  RLKey:='';
  RLValue:='';
end;

procedure ParseHardwareID(HID: string; var VEN,DEV,SUBSYS,REV: DWORD);
var
  p: DWORD;
begin
  VEN:=0;
  DEV:=0;
  SUBSYS:=0;
  REV:=0;
  if Pos('PCI\VEN',HID)=0 then
    Exit;
  p:=Pos('VEN_',HID);
  if p>0 then
    VEN:=DWORD(StrToIntEx('$'+Copy(HID,p+4,4)));
  p:=Pos('DEV_',HID);
  if p>0 then
    DEV:=DWORD(StrToIntEx('$'+Copy(HID,p+4,4)));
  p:=Pos('SUBSYS_',HID);
  if p>0 then
    SUBSYS:=DWORD(StrToIntEx('$'+Copy(HID,p+7,8)));
  p:=Pos('REV_',HID);
  if p>0 then
    REV:=DWORD(StrToIntEx('$'+Copy(HID,p+4,2)));
end;

var
  i,j,k,l :integer;
  sl1,sl2,sl3,sl4 :TStringList;
  dr: PDevice;
  rkEnum: string;
  Data: PChar;
const
  rvClass = 'Class';
  rvGUID = 'ClassGUID';
  rvDesc = 'DeviceDesc';
  rvFriend = 'FriendlyName';
  rvMfg = 'Mfg';
  rvService = 'Service';
  rvLoc = 'LocationInformation';
  rvDriver = 'Driver';
  rvHID = 'HardwareID';
  rvHWKey = 'HardwareKey';

  rkEnumNT = {HKEY_LOCAL_MACHINE}'\SYSTEM\CurrentControlSet\Enum';
  rkEnum9x = {HKEY_LOCAL_MACHINE}'\Enum';
  rkConfigManager = {HKEY_DYN_DATA}'\Config Manager\Enum';

  rkControl = 'Control';
  rkDeviceParams = 'Device Parameters';

begin
  ClearList;
  sl1:=TStringList.Create;
  sl2:=TStringList.Create;
  sl3:=TStringList.Create;
  sl4:=TStringList.Create;
  Data:=StrAlloc(255);

  try

  if IsNT then
    rkEnum:=rkEnumNT
  else
    rkEnum:=rkEnum9x;
  with TRegistry.Create do begin
//********* Win NT
    if IsNT then  begin
      RootKey:=HKEY_LOCAL_MACHINE;
      if OpenKeyReadOnly(rkEnumNT) then begin
        GetKeyNames(sl1);
        CloseKey;
        for i:=0 to sl1.Count-1 do
          if OpenKeyReadOnly(rkEnum+'\'+sl1[i]) then begin
            GetKeyNames(sl2);
            CloseKey;
            for j:=0 to sl2.count-1 do
              if OpenKeyReadOnly(rkEnum+'\'+sl1[i]+'\'+sl2[j]) then begin
                GetKeyNames(sl3);
                CloseKey;
                for k:=0 to sl3.count-1 do
                  if OpenKeyReadOnly(rkEnum+'\'+sl1[i]+'\'+sl2[j]+'\'+sl3[k]) then begin
                    if KeyExists(rkControl) then begin
                      new(dr);
                      with dr^ do begin
                        GUID:=UpperCase(ReadString(rvGUID));
                        FriendlyName:=ReadString(rvFriend);
                        Description:=ReadString(rvDesc);
                        if Trim(FriendlyName)='' then
                          Name:=Description
                        else
                          Name:=FriendlyName;
                        Manufacturer:=ReadString(rvMfg);
                        Service:=ReadString(rvService);
                        Location:=ReadString(rvLoc);
                        GetLocation(Location,PCINumber,DeviceNumber,FunctionNumber);
                        if Location='' then
                          GetDeviceService(sl1[i],Location,ServiceGroup,ServiceType);
                        GetDeviceClass(GUID,Classname,ClassDesc,ClassIcon);
                        if ClassName='' then
                          ClassName:=ReadString(rvClass);
                        Driver:=ReadString(rvDriver);
                        GetDeviceDriver(Driver,DriverDate,DriverVersion,DriverProvider,InfPath);
                        GetDeviceService(Service,ServiceName,ServiceGroup,ServiceType);
                        RegKey:=rkEnum+'\'+sl1[i]+'\'+sl2[j]+'\'+sl3[k];
                        HardwareID:=ReadRegistryValueAsString(HKEY_LOCAL_MACHINE,rkEnum+'\'+sl1[i]+'\'+sl2[j]+'\'+sl3[k],rvHID,False);
                        ParseHardwareID(HardwareID,VendorID,DeviceID,SubSysID,Revision);
                        GetResourceListLocationNT(RegKey,ResourceListKey,ResourceListValue);
                        CloseKey;
                        if OpenKeyReadOnly(rkEnum+'\'+sl1[i]+'\'+sl2[j]+'\'+sl3[k]+'\'+rkDeviceParams) then begin
                          GetValueNames(sl4);
                          for l:=0 to sl4.Count-1 do
                            if (sl4[l]<>'') and (GetDataType(sl4[l])=rdString) then begin
                              Deviceparam:=ReadString(sl4[l]);
                              Break;
                            end;
                          CloseKey;
                        end;
                      end;
                      if Trim(dr.ClassName)<>'' then begin
                        dr.DeviceClass:=Self.GetDeviceClass(dr.ClassName);
                        ADeviceList.AddObject(dr.Classname,TObject(dr));
                      end else
                        Dispose(dr);
                    end;
                  end;
              end;
          end;
      end;
    end else begin
//********* Win9x
      RootKey:=HKEY_DYN_DATA;
      if OpenKeyReadOnly(rkConfigManager) then begin
        GetKeyNames(sl1);
        CloseKey;
        for i:=0 to sl1.Count-1 do
          if OpenKeyReadOnly(rkConfigManager+'\'+sl1[i]) then begin
            sl2.Add(ReadString(rvHWKey));
            CloseKey;
          end;
      end;
      RootKey:=HKEY_LOCAL_MACHINE;
      for i:=0 to sl2.Count-1 do begin
        if (Pos('NETWORK',UpperCase(sl2[i]))=0) and OpenKeyReadOnly(rkEnum+'\'+sl2[i]) then begin
          new(dr);
          with dr^ do begin
            GUID:=UpperCase(ReadString(rvGUID));
            FriendlyName:=ReadString(rvFriend);
            Description:=ReadString(rvDesc);
            if Trim(FriendlyName)='' then
              Name:=Description
            else
              Name:=FriendlyName;
            Manufacturer:=ReadString(rvMfg);
            Service:=ReadString(rvService);
            Location:=ReadString(rvLoc);
            GetLocation(Location,PCINumber,DeviceNumber,FunctionNumber);
            if Location='' then
              GetDeviceService(sl1[i],Location,ServiceGroup,ServiceType);
            GetDeviceClass(GUID,Classname,ClassDesc,ClassIcon);
            if ClassName='' then
              ClassName:=ReadString(rvClass);
            Driver:=ReadString(rvDriver);
            GetDeviceDriver(Driver,DriverDate,DriverVersion,DriverProvider,InfPath);
            GetDeviceService(Service,ServiceName,ServiceGroup,ServiceType);
            RegKey:=rkEnum+'\'+sl2[i];
            HardwareID:=ReadRegistryValueAsString(HKEY_LOCAL_MACHINE,rkEnum+'\'+sl2[i],rvHID,False);
            ParseHardwareID(HardwareID,VendorID,DeviceID,SubSysID,Revision);
            GetResourceListLocation9x(RegKey,ResourceListKey,ResourceListValue);
          end;
          if (Trim(dr.ClassName)<>'') and (sl3.IndexOf(dr.ClassName+'-'+dr.Description)=-1) then begin
            dr.DeviceClass:=Self.GetDeviceClass(dr.ClassName);
            ADeviceList.AddObject(dr.Classname,TObject(dr));
            sl3.Add(dr.ClassName+'-'+dr.Description);
          end else
            Dispose(dr);
          CloseKey;
        end;
      end;
    end;
    Free;
  end;

  finally
  StrDispose(Data);
  sl1.free;
  sl2.Free;
  sl3.Free;
  sl4.Free;
  end;
end;

procedure TDevices.ClearList;
var
  dr: PDevice;
begin
  while FDeviceList.count>0 do begin
   dr:=PDevice(FDeviceList.Objects[FDeviceList.count-1]);
   Dispose(dr);
   FDeviceList.Delete(FDeviceList.count-1);
  end;
end;

procedure TDevices.GetDeviceResources(Adevice: TDevice;
  var DR: TDeviceResources);
begin
  with TRegistry.Create do
    try
      RootKey:=HKEY_LOCAL_MACHINE;
      if OpenKeyReadOnly(Adevice.ResourceListKey) then begin
        ReadDeviceResourcesFromRegistry(CurrentKey,ADevice.ResourceListValue,DR);
        CloseKey;
      end;
    finally
      Free;
    end;
end;

procedure TDevices.GetResourceList(var RL: TResourceList);
var
  i,j: Integer;
  d: TDevice;
  dr: TDeviceResources;
  ri: TResourceItem;
begin
  SetLength(RL,0);
  for i:=0 to DeviceCount-1 do begin
    d:=Devices[i];
    if not IsEmptyString(d.ResourceListKey) then begin
      GetDeviceResources(d,dr);
      for j:=0 to High(dr.Resources) do begin
        ri.Share:=dr.Resources[j].ShareDisposition;
        ri.Device:=d.Name;
        ri.DeviceClass:=d.DeviceClass;
        case dr.Resources[j].Typ of
          CmResourceTypePort:
            ri.Resource:=Format('%s %4.4x - %4.4x',[DeviceResourceTypeStr(dr.Resources[j].Typ),
                                           dr.Resources[j].Port.Start.QuadPart,
                                           dr.Resources[j].Port.Start.QuadPart+dr.Resources[j].Port.Length-1]);
          CmResourceTypeInterrupt:
            ri.Resource:=Format('%s %2.2d',[DeviceResourceTypeStr(dr.Resources[j].Typ),
                                         dr.Resources[j].Interrupt.Vector]);
          CmResourceTypeMemory:
            ri.Resource:=Format('%s %8.8x - %8.8x',[DeviceResourceTypeStr(dr.Resources[j].Typ),
                                           dr.Resources[j].Memory.Start.QuadPart,
                                           dr.Resources[j].Memory.Start.QuadPart+dr.Resources[j].Memory.Length-1]);
          CmResourceTypeDma:
            ri.Resource:=Format('%s %2.2d',[DeviceResourceTypeStr(dr.Resources[j].Typ),
                                         dr.Resources[j].DMA.Channel]);
        end;
        if not IsEmptyString(ri.Resource) then begin
          SetLength(RL,Length(RL)+1);
          RL[High(RL)]:=ri;
        end;
      end;
    end;
  end;
end;

procedure TDevices.GetLocation(ASource: string; var PCI, Device,
  Func: Integer);
var
  p: Integer;
begin
  PCI:=-1;
  Device:=-1;
  Func:=-1;
  p:=Pos(',',ASource);
  if p>0 then begin
    PCI:=StrToIntEx(Trim(Copy(ASource,p-2,2)));
    Delete(ASource,1,p);
    p:=Pos(',',ASource);
    Device:=StrToIntEx(Trim(Copy(ASource,p-2,2)));
    Delete(ASource,1,p);
    Func:=StrToIntEx(Trim(Copy(ASource,Length(ASource)-1,2)));
  end;
end;

procedure TDevices.SetMode(const Value: TExceptionModes);
begin
  FModes := Value;
end;

end.

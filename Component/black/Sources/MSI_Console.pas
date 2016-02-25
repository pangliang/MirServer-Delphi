{*******************************************************}
{                                                       }
{       MiTeC System Information Console Object         }
{           version 8.6 for Delphi 5,6,7                }
{                                                       }
{       Copyright © 1997,2004 Michal Mutl               }
{                                                       }
{*******************************************************}

{$INCLUDE MITEC_DEF.INC}

unit MSI_Console;

interface

uses
  MSI_Common, MSI_CPU, MSI_Machine, MSI_Devices, MSI_Display, MSI_Network, MSI_Media,
  MSI_Memory, MSI_Engines, MSI_APM, MSI_Disk, MSI_OS, MSI_SMBIOS,
  MSI_Printers, MSI_Software, MSI_Startup, MSI_Storage, MSI_USB,
  MSI_Processes, MSI_Monitor,
  Windows, SysUtils, Classes;

type
  TSubObject = (soCPU, soMachine, soDevices, soDisplay, soMonitor, soNetwork, soMedia,
                soMemory, soStorage, soUSB, soEngines, soAPM, soDisk, soOS,
                soPrinters, soSoftware, soStartup, soProcesses);

  TSubObjects = set of TSubObject;

const
  soAll = [soCPU, soMachine, soDevices, soDisplay, soMonitor, soNetwork, soMedia,
           soMemory, soStorage, soUSB, soEngines, soAPM, soDisk, soOS,
           soPrinters, soSoftware, soStartup, soProcesses];

type
  TMSI = class(TPersistent)
  private
    fSubObjects: TSubObjects;
    FCPU: TCPU;
    FMemory: TMemory;
    FOS :TOperatingSystem;
    FDisk :TDisk;
    FMachine: TMachine;
    FNetwork: TNetwork;
    FDisplay: TDisplay;
    FEngines: TEngines;
    FDevices: TDevices;
    FAPM :TAPM;
    FAbout: string;
    FMedia: TMedia;
    FPrinters: TPrinters;
    FSoftware: TSoftware;
    FStartup: TStartup;
    FModes: TExceptionModes;
    FStorage: TStorage;
    FUSB: TUSB;
    FProcessList: TProcessList;
    FMonitor: TMonitor;
    procedure SetMode(const Value: TExceptionModes);
  public
    constructor Create(ASubObjects: TSubObjects = soAll);
    destructor Destroy; override;
    procedure Refresh;
    procedure Report(var sl :TStringList);  virtual;
    procedure ExportOverview(var sl: TStringList);

    property About :string read FAbout;
    property ExceptionModes: TExceptionModes read FModes Write SetMode;
    property CPU :TCPU read FCPU;
    property Memory :TMemory read FMemory;
    property OS :TOperatingSystem read FOS;
    property Disk :TDisk read FDisk;
    property Machine :TMachine read FMachine;
    property Network :TNetwork read FNetwork;
    property Display :TDisplay read FDisplay;
    property Monitor :TMonitor read FMonitor;
    property Media :TMedia read FMedia;
    property Devices :TDevices read FDevices;
    property Storage :TStorage read FStorage;
    property USB :TUSB read FUSB;
    property Engines :TEngines read FEngines;
    property APM :TAPM read FAPM;
    property Printers :TPrinters read FPrinters;
    property Software :TSoftware read FSoftware;
    property Startup: TStartup read FStartup;
    property ProcessList: TProcessList read FProcessList;
  end;

implementation

uses MiTeC_Routines, MiTeC_Datetime;

{ TMSI }

constructor TMSI.Create;
begin
  fSubObjects:=ASubObjects;
  FAbout:=cCompName+' '+cVersion+' - '+cCopyright;

  FCPU:=TCPU.Create;
  FMemory:=TMemory.Create;
  FOS:=TOperatingSystem.Create;

  if soDisk in FSubObjects then
    FDisk:=TDisk.Create;
  if soMachine in FSubObjects then
    FMachine:=TMachine.Create;
  if soNetwork in FSubObjects then
    FNetwork:=TNetwork.Create;
  if soDisplay in FSubObjects then
    FDisplay:=TDisplay.Create;
  if soMonitor in FSubObjects then
    FMonitor:=TMonitor.Create;
  if soMedia in FSubObjects then
    FMedia:=TMedia.Create;
  if soDevices in FSubObjects then
    FDevices:=TDevices.Create;
  if soStorage in FSubObjects then
    FStorage:=TStorage.Create;
  if soUSB in FSubObjects then
    FUSB:=TUSB.Create;
  if soEngines in FSubObjects then
    FEngines:=TEngines.Create;
  if soAPM in FSubObjects then
    FAPM:=TAPM.Create;
  if soPrinters in FSubObjects then
    FPrinters:=TPrinters.Create;
  if soSoftware in FSubObjects then
    FSoftware:=TSoftware.Create;
  if soStartup in FSubObjects then
    FStartup:=TStartup.Create;
  if soProcesses in FSubObjects then
    FProcessList:=TProcessList.Create;

  ExceptionModes:=[emExceptionStack];
end;

destructor TMSI.Destroy;
begin
  if Assigned(FDisk) then
    FDisk.Destroy;
  if Assigned(FMachine) then
    FMachine.Destroy;
  if Assigned(FNetwork) then
    FNetwork.Destroy;
  if Assigned(FDisplay) then
    FDisplay.Destroy;
  if Assigned(FMonitor) then
    FMonitor.Destroy;
  if Assigned(FMedia) then
    FMedia.Destroy;
  if Assigned(FDevices) then
    FDevices.Destroy;
  if Assigned(FStorage) then
    FStorage.Destroy;
  if Assigned(FUSB) then
    FUSB.Destroy;
  if Assigned(FEngines) then
    FEngines.Destroy;
  if Assigned(FAPM) then
    FAPM.Destroy;
  if Assigned(FPrinters) then
    FPrinters.Destroy;
  if Assigned(FSoftware) then
    FSoftware.Destroy;
  if Assigned(FStartup) then
    FStartup.Destroy;
  if Assigned(FProcessList) then
    FProcessList.Destroy;

//  if soOS in fSubObjects {Assigned(FOS)} then
    FOS.Destroy;
//  if soMemory in fSubObjects {Assigned(FMemory)} then
    FMemory.Destroy;
//  if soCPU in fSubObjects {Assigned(FCPU)} then
    FCPU.Destroy;
  inherited;
end;

procedure TMSI.ExportOverview(var sl: TStringList);
var
  i,c,n,p: Integer;
  s: string;
  k: TSlotType;
begin
  with sl do begin
    try
      Add(Format('System: %s',[Machine.Computer]));
      Add(Format('Model: %s %s',[Machine.SMBIOS.SystemManufacturer,
                                  Machine.SMBIOS.SystemModel]));
      Add(Format('System Up Time: %s',[formatseconds(Machine.SystemUpTime,true,false,False)]));
      Add('');
      if Trim(CPU.CPUIDNameString)='' then
        Add(format('%d x %s %s',[CPU.Count,CPUVendors[CPU.VendorType],CPU.FriendlyName]))
      else
        Add(format('%d x %s',[CPU.Count,Trim(CPU.CPUIDNameString)]));
      Add(Format('Frequency: %d Mhz',[CPU.Frequency]));
      if Machine.SMBIOS.ProcessorCount>0 then begin
        Add(Format('Voltage: %1.1fV',[Machine.SMBIOS.Processor[0].Voltage]));
        Add(Format('Package: %s (%s)',[Machine.SMBIOS.Processor[0].Socket,Upgrades[Machine.SMBIOS.Processor[0].Upgrade]]));
      end;
      Add('');
      Add(Format('Mainboard: %s %s',[Machine.SMBIOS.MainboardManufacturer,Machine.SMBIOS.MainboardModel]));
      for i:=0 to Machine.SMBIOS.PortCount-1 do
        Add(Format('%s: %s (%s/%s)',[Machine.SMBIOS.Port[i].InternalDesignator,
                                      PortTypes[Machine.SMBIOS.Port[i].Typ],
                                      ConnectorTypes[Machine.SMBIOS.Port[i].InternalConnector],
                                      ConnectorTypes[Machine.SMBIOS.Port[i].ExternalConnector]]));
      for k:=Low(TSlotType) to High(TSlotType) do begin
        c:=0;
        for i:=0 to Machine.SMBIOS.SystemSlotCount-1 do
          if Machine.SMBIOS.SystemSlot[i].Typ=k then begin
            Inc(c);
            s:=Format('%s (%s)',[SlotTypes[Machine.SMBIOS.SystemSlot[i].Typ],
                                 DataBusTypes[Machine.SMBIOS.SystemSlot[i].DataBus]]);
          end;
        if c>0 then
          Add(Format('%d x %s',[c,s]));
      end;
      c:=0;
      n:=0;
      s:='';
      p:=0;
      if Machine.SMBIOS.MemoryDeviceCount=0 then begin
        for i:=0 to Machine.SMBIOS.MemoryModuleCount-1 do
          if Machine.SMBIOS.MemoryModule[i].Size>0 then begin
            Inc(c);
            n:=Machine.SMBIOS.MemoryModule[i].Size;
            s:=Machine.SMBIOS.GetMemoryTypeStr(Machine.SMBIOS.MemoryModule[i].Types);
            p:=Machine.SMBIOS.MemoryModule[i].Speed;
          end;
      end else
        for i:=0 to Machine.SMBIOS.MemoryDeviceCount-1 do
          if Machine.SMBIOS.MemoryDevice[i].Size>0 then begin
            Inc(c);
            n:=Machine.SMBIOS.MemoryDevice[i].Size;
            if Machine.SMBIOS.MemoryDevice[i].Device>smmdUnknown then
              s:=MemoryDeviceTypes[Machine.SMBIOS.MemoryDevice[i].Device]
            else
              s:=MemoryFormFactors[Machine.SMBIOS.MemoryDevice[i].FormFactor];
            try
              p:=Round(1000/Machine.SMBIOS.MemoryDevice[i].Speed);
            except
              p:=0;
            end;
          end;
      Add('');
      Add(Format('Memory: %d MB (%d KB free)',[Memory.PhysicalTotal div 1024 div 1024,Memory.PhysicalFree div 1024]));
      Add(Format('Type: %d x %d %s',[c,n,s]));
      Add(Format('Speed: %d ns',[p]));
      Add('');
      Add(Format('OS: %s [%d.%d.%d]',[OSVersion,
                                      OS.MajorVersion,
                                      OS.MinorVersion,
                                      OS.BuildNumber]));
      Add(Format('Logged User: %s',[Machine.User]));
      Add('');
      Add(Format('Video: %s',[Display.Adapter]));
      Add(Format('Resolution: %d x %d - %d bit',[Display.HorzRes,
                                                 Display.VertRes,
                                                 Display.ColorDepth]));
      Add('');
      Add(Format('Monitor: %s %s',[Monitor.Monitors[0].Name,Monitor.Monitors[0].ProductNumber]));
      Add('');
      if Media.Devices.Count>0 then begin
        if Media.SoundCardIndex>-1 then
          Add(Format('Sound: %s',[Media.Devices[Media.SoundCardIndex]]))
        else
          Add(Format('Sound Adapter: %s',[Media.Devices[0]]));
        if Media.GamePortIndex>-1 then
          Add(Format('Game Adapter: %s',[Media.Devices[Media.GamePortIndex]]));
      end;
      Add('');
      Add('Network Adapters:');
      if Network.PhysicalAdapters.Count>0 then begin
        for i:=0 to Network.PhysicalAdapters.Count-1 do
          Add(Network.PhysicalAdapters[i]);
      end else
        Add('<no adapters detected>');
      Add(Format('Local Host Name: %s',[Machine.Name]));
      Add(Format('IP Address: %s',[Network.IPAddresses[0]]));
      if Network.MACAddresses.Count>0 then
        Add(Format('MAC Address: %s',[Network.MACAddresses[0]]));
      Add('');

      Add('Drives/Tapes/CDROMs:');
      for i:=0 to Devices.DeviceCount-1 do
        if Devices.Devices[i].DeviceClass in [dcDiskDrive,dcCDROM,dcFloppyDisk,dcTapeDrive] then
          if Trim(Devices.Devices[i].FriendlyName)='' then
            Add(Devices.Devices[i].Description)
          else
            Add(Devices.Devices[i].FriendlyName);

      Add('');
      s:='<none>';
      for i:=0 to Devices.DeviceCount-1 do
        if Devices.Devices[i].DeviceClass=dcModem then begin
          if Trim(Devices.Devices[i].FriendlyName)='' then
            s:=Devices.Devices[i].Description
          else
            s:=Devices.Devices[i].FriendlyName;
          Break;
        end;
      Add(Format('Modem: %s',[s]));

      Add('');
      s:='<none>';
      for i:=0 to Devices.DeviceCount-1 do
        if Devices.Devices[i].DeviceClass=dcMouse then begin
          if Trim(Devices.Devices[i].FriendlyName)='' then
            s:=Devices.Devices[i].Description
          else
            s:=Devices.Devices[i].FriendlyName;
          Break;
        end;
      Add(Format('Mouse: %s',[s]));

      Add('');
      s:='<none>';
      for i:=0 to Devices.DeviceCount-1 do
        if Devices.Devices[i].DeviceClass=dcKeyboard then begin
          if Trim(Devices.Devices[i].FriendlyName)='' then
            s:=Devices.Devices[i].Description
          else
            s:=Devices.Devices[i].FriendlyName;
          Break;
        end;
      Add(Format('Keyboard: %s',[s]));

      Add('');
      if Printers.Names.Count>0 then
        Add(Format('Printer: %s (%s)',[Printers.Names[Printers.DefaultIndex],
                                       Printers.Ports[Printers.DefaultIndex]]));
    except
      on e: exception do begin
        Add(e.message);
      end;
    end;
  end;
end;

procedure TMSI.Refresh;
begin
  {$IFDEF ERROR_INTERCEPT}PushTrace(FModes,Self,'Refresh');{$ENDIF}

  if Assigned(Devices) then
    Devices.GetInfo;
  if Assigned(CPU) then
    CPU.GetInfo(True,True);
  if Assigned(Memory) then
    Memory.GetInfo;
  if Assigned(OS) then
    OS.GetInfo;
  if Assigned(Disk) then begin
    Disk.GetInfo;
    Disk.Drive:=ExtractFileDrive(GetWinDir);
  end;
  if Assigned(Machine) then
    Machine.GetInfo(integer(True));
  if Assigned(Network) then
    Network.GetInfo;
  if Assigned(Display) then
    Display.GetInfo;
  if Assigned(Monitor) then
    Monitor.GetInfo;
  if Assigned(Media) then
    Media.GetInfo;
  if Assigned(Storage) then
    Storage.GetInfo;
  if Assigned(USB) then
    USB.GetInfo;
  if Assigned(Engines) then
    Engines.GetInfo;
  if Assigned(APM) then
    APM.GetInfo;
  if Assigned(Printers) then
    Printers.GetInfo;
  if Assigned(Software) then
    Software.GetInfo;
  if Assigned(Startup) then
    Startup.GetInfo;
  if Assigned(ProcessList) then
    ProcessList.GetInfo;

  {$IFDEF ERROR_INTERCEPT}PopTrace;{$ENDIF};
end;

procedure TMSI.Report(var sl: TStringList);
begin
  ReportHeader(sl);
  if Assigned(FMachine) then
    Machine.Report(sl,False);
  if Assigned(FOS) then
    OS.Report(sl,False);
  if Assigned(FCPU) then
    CPU.Report(sl,False);
  if Assigned(Fmemory) then
    Memory.Report(sl,False);
  if Assigned(FDisplay) then
    Display.Report(sl,False);
  if Assigned(FMonitor) then
    Monitor.Report(sl,False);
  if Assigned(FAPM) then
    APM.Report(sl,False);
  if Assigned(FMedia) then
    Media.Report(sl,False);
  if Assigned(FNetwork) then
    Network.Report(sl,False);
  if Assigned(FDevices) then
    Devices.Report(sl,False);
  if Assigned(FStorage) then
    Storage.Report(sl,False);
  if Assigned(FUSB) then
    USB.Report(sl,False);
  if Assigned(FEngines) then
    Engines.Report(sl,False);
  if Assigned(FDisk) then
    Disk.Report(sl,False);
  if Assigned(FPrinters) then
    Printers.Report(sl,False);
  if Assigned(FSoftware) then
    Software.Report(sl,False);
  if Assigned(FStartup) then
    Startup.Report(sl,False);
  if Assigned(FProcessList) then
    ProcessList.Report(sl,False);
  ReportFooter(sl);
end;


procedure TMSI.SetMode(const Value: TExceptionModes);
begin
  FModes:=Value;
  if Assigned(OS) then
    OS.ExceptionModes:=FModes;
  if Assigned(Network) then
    Network.ExceptionModes:=FModes;
  if Assigned(CPU) then
    CPU.ExceptionModes:=FModes;
  if Assigned(Engines) then
    Engines.ExceptionModes:=FModes;
  if Assigned(Memory) then
    Memory.ExceptionModes:=FModes;
  if Assigned(Disk) then
    Disk.ExceptionModes:=FModes;
  if Assigned(Machine) then
    Machine.ExceptionModes:=FModes;
  if Assigned(Storage) then
    Storage.ExceptionModes:=FModes;
  if Assigned(Display) then
    Display.ExceptionModes:=FModes;
  if Assigned(Monitor) then
    Monitor.ExceptionModes:=FModes;
  if Assigned(Media) then
    Media.ExceptionModes:=FModes;
  if Assigned(Devices) then
    Devices.ExceptionModes:=FModes;
  if Assigned(USB) then
    USB.ExceptionModes:=FModes;
  if Assigned(APM) then
    APM.ExceptionModes:=FModes;
  if Assigned(Printers) then
    Printers.ExceptionModes:=FModes;
  if Assigned(Software) then
    Software.ExceptionModes:=FModes;
  if Assigned(Startup) then
    Startup.ExceptionModes:=FModes;
  if Assigned(ProcessList) then
    ProcessList.ExceptionModes:=FModes;
end;

end.

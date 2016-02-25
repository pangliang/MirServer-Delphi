{$DEFINE SPLASH}

{*******************************************************}
{                                                       }
{       MiTeC System Information Component              }
{           version 8.6.4 for Delphi 5,6,7              }
{                                                       }
{       Copyright © 1997,2004 Michal Mutl               }
{                                                       }
{*******************************************************}

{$INCLUDE MITEC_DEF.INC}

unit MSI_GUI;

interface

uses
  MSI_Common, MSI_CPU, MSI_Machine, MSI_Devices, MSI_Display, MSI_Network, MSI_Media,
  MSI_Memory, MSI_Engines, MSI_APM, MSI_Disk, MSI_OS, MSI_SMBIOS,
  MSI_Printers, MSI_Software, MSI_Startup, MSI_Storage,
  MSI_USB, MSI_Processes, MSI_Monitor,
  SysUtils, Windows, Classes;

type
  TInfoPage = (pgWksta, pgOS, pgCPU, pgMem, pgDisplay, pgMonitor, pgAPM, pgMedia, pgNet, pgDev,
           pgPrn, pgStorage, pgUSB, pgEng, pgDisk, pgTZ, pgStartup, pgSoftware,
           pgProcesses, pgAbout);

  TInfoPages = set of TInfoPage;

const
  pgAll = [pgWksta, pgOS, pgCPU, pgMem, pgDisplay, pgMonitor, pgAPM, pgMedia, pgNet, pgDev,
           pgPrn, pgEng, pgStorage, pgUSB, pgDisk, pgTZ, pgStartup, pgSoftware, pgProcesses];

type
  TMSystemInfo = class(TComponent)
  private
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
    FRefresh: string;
    {$IFNDEF D6PLUS}
    procedure SetAbout(const Value: string);
    procedure SetRefresh(const Value: string);
    {$ENDIF}
    procedure SetMode(const Value: TExceptionModes);
  public
    constructor Create(AOwner :TComponent); override;
    destructor Destroy; override;
    procedure Refresh;
    procedure Report(var sl :TStringList); virtual;
    procedure ShowModalOverview(ReportButton: Boolean = True; ForceRefresh: Boolean = True; APages: TInfoPages = pgAll);
    procedure ShowModalOverviewWithAbout(ReportButton: Boolean = True; ForceRefresh: Boolean = True; APages: TInfoPages = pgAll);
    procedure ShowOverview(ReportButton: Boolean = True; ForceRefresh: Boolean = True; APages: TInfoPages = pgAll);
    procedure ShowOverviewWithAbout(ReportButton: Boolean = True; ForceRefresh: Boolean = True; APages: TInfoPages = pgAll);
    procedure ExportOverview(var sl: TStringList);
  published
    property _About :string read FAbout {$IFNDEF D6PLUS} write SetAbout {$ENDIF} stored False;
    property _Refresh :string read FRefresh {$IFNDEF D6PLUS} write SetRefresh {$ENDIF} stored False;
    property ExceptionModes: TExceptionModes read FModes Write SetMode;

    property CPU :TCPU read FCPU {$IFNDEF D6PLUS} write FCPU {$ENDIF};
    property Memory :TMemory read FMemory {$IFNDEF D6PLUS} write FMemory {$ENDIF};
    property OS :TOperatingSystem read FOS {$IFNDEF D6PLUS} write FOS {$ENDIF};
    property Disk :TDisk read FDisk {$IFNDEF D6PLUS} write FDisk {$ENDIF};
    property Machine :TMachine read FMachine {$IFNDEF D6PLUS} write FMachine {$ENDIF};
    property Network :TNetwork read FNetwork {$IFNDEF D6PLUS} write FNetwork {$ENDIF};
    property Display :TDisplay read FDisplay {$IFNDEF D6PLUS} write FDisplay {$ENDIF};
    property Monitor :TMonitor read FMonitor {$IFNDEF D6PLUS} write FMonitor {$ENDIF};
    property Media :TMedia read FMedia {$IFNDEF D6PLUS} write FMedia {$ENDIF};
    property Devices :TDevices read FDevices {$IFNDEF D6PLUS} write FDevices {$ENDIF};
    property Storage :TStorage read FStorage {$IFNDEF D6PLUS} write FStorage {$ENDIF};
    property USB :TUSB read FUSB {$IFNDEF D6PLUS} write FUSB {$ENDIF};
    property Engines :TEngines read FEngines {$IFNDEF D6PLUS} write FEngines {$ENDIF};
    property APM :TAPM read FAPM {$IFNDEF D6PLUS} write FAPM {$ENDIF};
    property Printers :TPrinters read FPrinters {$IFNDEF D6PLUS} write FPrinters {$ENDIF};
    property Software :TSoftware read FSoftware {$IFNDEF D6PLUS} write FSoftware {$ENDIF};
    property Startup: TStartup read FStartup {$IFNDEF D6PLUS} write FStartup {$ENDIF};
    property ProcessList: TProcessList read FProcessList {$IFNDEF D6PLUS} write FProcessList {$ENDIF};
  end;

implementation

{$R 'MSystemInfo.dcr'}

uses {$IFDEF SPLASH} MSI_Splash, {$ENDIF}
     MSI_Overview, MiTeC_Routines, MiTeC_Datetime;

{ TMSystemInfo }

constructor TMSystemInfo.Create(AOwner: TComponent);
begin
  inherited;
  FAbout:=cCompName+' '+cVersion+' - '+cCopyright;
  FRefresh:='Double-click to refresh';
  FCPU:=TCPU.Create;
  FMemory:=TMemory.Create;
  FOS:=TOperatingSystem.Create;
  FDisk:=TDisk.Create;
  FMachine:=TMachine.Create;
  FStorage:=TStorage.Create;
  FNetwork:=TNetwork.Create;
  FDisplay:=TDisplay.Create;
  FMonitor:=TMonitor.Create;
  FMedia:=TMedia.Create;
  FDevices:=TDevices.Create;
  FUSB:=TUSB.Create;
  FEngines:=TEngines.Create;
  FAPM:=TAPM.Create;
  FPrinters:=TPrinters.Create;
  FSoftware:=TSoftware.Create;
  FStartup:=TStartup.Create;
  FProcessList:=TProcessList.Create;
  ExceptionModes:=[emDefault];
  {if csDesigning in ComponentState then
    Refresh;}
end;

destructor TMSystemInfo.Destroy;
begin
  FCPU.Destroy;
  FMemory.Destroy;
  FOS.Destroy;
  FDisk.Destroy;
  FMachine.Destroy;
  FNetwork.Destroy;
  FDisplay.Destroy;
  FMonitor.Destroy;
  FMedia.Destroy;
  FDevices.Destroy;
  FStorage.Destroy;
  FUSB.Destroy;
  FEngines.Destroy;
  FAPM.Destroy;
  FPrinters.Destroy;
  FSoftware.Destroy;
  FStartup.Destroy;
  FProcessList.Destroy;
  inherited;
end;

procedure TMSystemInfo.ExportOverview(var sl: TStringList);
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
        Add(Format('%d x %s %s',[CPU.Count,CPUVendors[CPU.VendorType],CPU.FriendlyName]))
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
            s:=Format('%s (%s) - %s',[SlotTypes[Machine.SMBIOS.SystemSlot[i].Typ],
                                 DataBusTypes[Machine.SMBIOS.SystemSlot[i].DataBus],
                                 SlotUsages[Machine.SMBIOS.SystemSlot[i].Usage]]);
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

procedure TMSystemInfo.Refresh;
begin
  {$IFDEF SPLASH}
  {if not(csDesigning in ComponentState) then begin}
    scrMSI_Splash:=TscrMSI_Splash.Create(nil);
    scrMSI_Splash.Show;
    scrMSI_Splash.Update;
  {end;}
  {$ENDIF}
  try
    {$IFDEF ERROR_INTERCEPT}PushTrace(FModes,Self,'Refresh');{$ENDIF}

    Devices.GetInfo;
    Storage.GetInfo;
    USB.GetInfo;
    CPU.GetInfo(True,True);
    Memory.GetInfo;
    OS.GetInfo;
    Machine.GetInfo(integer(True));
    Software.GetInfo;
    Network.GetInfo;
    Engines.GetInfo;
    Display.GetInfo;
    Monitor.GetInfo;
    Media.GetInfo;
    APM.GetInfo;
    Printers.GetInfo;
    Startup.GetInfo;
    Disk.GetInfo;
    Disk.Drive:=ExtractFileDrive(GetWinDir);
    //if not(csDesigning in ComponentState) then
      ProcessList.GetInfo;

    {$IFDEF ERROR_INTERCEPT}PopTrace;{$ENDIF};
  finally
    {$IFDEF SPLASH}
    {if not(csDesigning in ComponentState) then}
      scrMSI_Splash.Destroy;
    {$ENDIF}
  end;
end;

procedure TMSystemInfo.Report(var sl: TStringList);
begin
  {$IFDEF ERROR_INTERCEPT}PushTrace(FModes,Self,'Report'); {$ENDIF}
  ReportHeader(sl);

  Machine.Report(sl,False);
  OS.Report(sl,False);
  CPU.Report(sl,False);
  Memory.Report(sl,False);
  Display.Report(sl,False);
  Monitor.Report(sl,False);
  APM.Report(sl,False);
  Media.Report(sl,False);
  Network.Report(sl,False);
  Devices.Report(sl,False);
  Storage.Report(sl,False);
  USB.Report(sl,False);
  Engines.Report(sl,False);
  Disk.Report(sl,False);
  Printers.Report(sl,False);
  Software.Report(sl,False);
  Startup.Report(sl,False);
  ProcessList.report(sl,False);

  ReportFooter(sl);
  {$IFDEF ERROR_INTERCEPT}PopTrace;{$ENDIF};
end;

{$IFNDEF D6PLUS}
procedure TMSystemInfo.SetAbout(const Value: string);
begin
end;

procedure TMSystemInfo.SetRefresh(const Value: string);
begin
end;

{$ENDIF}

procedure TMSystemInfo.SetMode(const Value: TExceptionModes);
begin
  FModes:=Value;
  OS.ExceptionModes:=FModes;
  Network.ExceptionModes:=FModes;
  CPU.ExceptionModes:=FModes;
  Engines.ExceptionModes:=FModes;
  Memory.ExceptionModes:=FModes;
  Disk.ExceptionModes:=FModes;
  Machine.ExceptionModes:=FModes;
  Storage.ExceptionModes:=FModes;
  Display.ExceptionModes:=FModes;
  Monitor.ExceptionModes:=FModes;
  Media.ExceptionModes:=FModes;
  Devices.ExceptionModes:=FModes;
  USB.ExceptionModes:=FModes;
  APM.ExceptionModes:=FModes;
  Printers.ExceptionModes:=FModes;
  Software.ExceptionModes:=FModes;
  Startup.ExceptionModes:=FModes;
  ProcessList.ExceptionModes:=FModes;
end;

procedure TMSystemInfo.ShowModalOverview;
begin
  with TfrmMSI_Overview.Create(nil) do begin
    SysInfo:=Self;
    DisplayedPages:=APages;
    ShowReportButton:=ReportButton;
    RefreshOverview(ForceRefresh);
    ShowModal;
    Free;
  end;
end;

procedure TMSystemInfo.ShowModalOverviewWithAbout;
begin
  with TfrmMSI_Overview.Create(nil) do begin
    SysInfo:=Self;
    DisplayedPages:=APages+[pgAbout];
    ShowReportButton:=ReportButton;
    RefreshOverview(ForceRefresh);
    ShowModal;
    Free;
  end;
end;

procedure TMSystemInfo.ShowOverview;
begin
  try
    frmMSI_Overview.Show;
  except
    frmMSI_Overview:=TfrmMSI_Overview.Create(nil);
    with frmMSI_Overview do begin
      SysInfo:=Self;
      DisplayedPages:=APages;
      ShowReportButton:=ReportButton;
      RefreshOverview(ForceRefresh);
      Show;
    end;
  end;
end;

procedure TMSystemInfo.ShowOverviewWithAbout;
begin
  try
    frmMSI_Overview.Show;
  except
    frmMSI_Overview:=TfrmMSI_Overview.Create(nil);
    with frmMSI_Overview do begin
      SysInfo:=Self;
      DisplayedPages:=APages+[pgAbout];
      ShowReportButton:=ReportButton;
      RefreshOverview(ForceRefresh);
      Show;
    end;
  end;
end;

end.

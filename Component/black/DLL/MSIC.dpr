{*******************************************************}
{                                                       }
{       MiTeC System Information Component              }
{                   MSIC DLL                            }
{           version 8.5 for Delphi 5,6,7                }
{                                                       }
{       Copyright © 1997,2003 Michal Mutl               }
{                                                       }
{*******************************************************}

library MSIC;

uses
  Windows,
  SysUtils,
  Classes,
  MSI_Console,
  MSI_GUI,
  MSIC_Intf in 'MSIC_Intf.pas';

const
  SO_CPU      = $0001;
  SO_Machine  = $0002;
  SO_Devices  = $0004;
  SO_Display  = $0008;
  SO_Network  = $0010;
  SO_Media    = $0020;
  SO_Memory   = $0040;
  SO_Storage  = $0080;
  SO_USB      = $0100;
  SO_Engines  = $0200;
  SO_APM      = $0400;
  SO_Disk     = $0800;
  SO_OS       = $1000;
  SO_Printers = $2000;
  SO_Software = $4000;
  SO_Startup  = $8000;
  SO_Processes= $10000;
  SO_Monitor  = $20000;

{$R *.res}

procedure GenerateXMLReport(ATopics: DWORD; Filename: PChar); stdcall;
var
  sl: TStringList;
  t: TSubObjects;
begin
  t:=[];
  if SO_CPU and ATopics = SO_CPU then
    t:=t+[soCPU];
  if SO_Machine and ATopics = SO_Machine then
    t:=t+[soMachine];
  if SO_Devices and ATopics = SO_Devices then
    t:=t+[soDevices];
  if SO_Display and ATopics = SO_Display then
    t:=t+[soDisplay];
  if SO_Monitor and ATopics = SO_Monitor then
    t:=t+[soMonitor];
  if SO_Network and ATopics = SO_Network then
    t:=t+[soNetwork];
  if SO_Media and ATopics = SO_Media then
    t:=t+[soMedia];
  if SO_Memory and ATopics = SO_Memory then
    t:=t+[soMemory];
  if SO_STORAGE and ATopics = SO_STORAGE then
    t:=t+[soStorage];
  if SO_USB and ATopics = SO_USB then
    t:=t+[soUSB];
  if SO_Engines and ATopics = SO_Engines then
    t:=t+[soEngines];
  if SO_APM and ATopics = SO_APM then
    t:=t+[soAPM];
  if SO_Disk and ATopics = SO_Disk then
    t:=t+[soDisk];
  if SO_OS and ATopics = SO_OS then
    t:=t+[soOS];
  if SO_Printers and ATopics = SO_Printers then
    t:=t+[soPrinters];
  if SO_Software and ATopics = SO_Software then
    t:=t+[soSoftware];
  if SO_Startup and ATopics = SO_Startup then
    t:=t+[soStartup];
  if SO_Processes and ATopics = SO_Processes then
    t:=t+[soProcesses];
  with TMSI.Create(t) do begin
    sl:=TStringList.Create;
    try
      Refresh;
      Report(sl);
      sl.SaveToFile(Filename);
    finally
      sl.Free;
      Free;
    end;
  end;
end;

procedure ShowSystemOverviewModal; stdcall;
begin
  with TMSystemInfo.Create(nil) do
    try
      ShowModalOverview;
    finally
      Free;
    end;
end;

exports
  GenerateXMLReport,
  ShowSystemOverviewModal;
begin
end.

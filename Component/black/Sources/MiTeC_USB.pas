{*******************************************************}
{                                                       }
{         MiTeC System Information Component            }
{                USB Interface                          }
{           version 8.5 for Delphi 5,6,7                }
{                                                       }
{       Copyright © 1997,2003 Michal Mutl               }
{                                                       }
{*******************************************************}


{$INCLUDE MITEC_DEF.INC}

unit MiTeC_USB;

interface

uses SysUtils, Windows, MiTeC_WinIOCTL;

const
  FILE_DEVICE_USB = FILE_DEVICE_UNKNOWN;
  USB_IOCTL_INTERNAL_INDEX = $0000;
  USB_IOCTL_INDEX = $00ff;

  IOCTL_USB_GET_NODE_INFORMATION   = ((FILE_DEVICE_USB shl 16) or
                                               ((USB_IOCTL_INDEX+3) shl 2) or
                                               METHOD_BUFFERED or
                                               (FILE_ANY_ACCESS shl 14));

  IOCTL_USB_GET_NODE_CONNECTION_INFORMATION       = ((FILE_DEVICE_USB shl 16) or
                                                ((USB_IOCTL_INDEX+4) shl 2) or
                                                METHOD_BUFFERED or
                                                (FILE_ANY_ACCESS shl 14));

  IOCTL_USB_GET_DESCRIPTOR_FROM_NODE_CONNECTION   = ((FILE_DEVICE_USB shl 16) or
                                                ((USB_IOCTL_INDEX+5) shl 2) or
                                                METHOD_BUFFERED or
                                                (FILE_ANY_ACCESS shl 14));

  IOCTL_USB_GET_NODE_CONNECTION_NAME     = ((FILE_DEVICE_USB shl 16) or
                                                ((USB_IOCTL_INDEX+6) shl 2) or
                                                METHOD_BUFFERED or
                                                (FILE_ANY_ACCESS shl 14));

  IOCTL_USB_DIAG_IGNORE_HUBS_ON   = ((FILE_DEVICE_USB shl 16) or
                                                ((USB_IOCTL_INDEX+7) shl 2) or
                                                METHOD_BUFFERED or
                                                (FILE_ANY_ACCESS shl 14));

  IOCTL_USB_DIAG_IGNORE_HUBS_OFF  = ((FILE_DEVICE_USB shl 16) or
                                                ((USB_IOCTL_INDEX+8) shl 2) or
                                                METHOD_BUFFERED or
                                                (FILE_ANY_ACCESS shl 14));

  IOCTL_USB_GET_NODE_CONNECTION_DRIVERKEY_NAME  = ((FILE_DEVICE_USB shl 16) or
                                                ((USB_IOCTL_INDEX+9) shl 2) or
                                                METHOD_BUFFERED or
                                                (FILE_ANY_ACCESS shl 14));

  IOCTL_USB_HCD_GET_STATS_1          = ((FILE_DEVICE_USB shl 16) or
                                                ((USB_IOCTL_INDEX) shl 2) or
                                                METHOD_BUFFERED or
                                                (FILE_ANY_ACCESS shl 14));

  IOCTL_USB_HCD_GET_STATS_2          = ((FILE_DEVICE_USB shl 16) or
                                                ((USB_IOCTL_INDEX+11) shl 2) or
                                                METHOD_BUFFERED or
                                                (FILE_ANY_ACCESS shl 14));

  IOCTL_USB_DIAGNOSTIC_MODE_ON   = ((FILE_DEVICE_USB shl 16) or
                                                ((USB_IOCTL_INDEX+1) shl 2) or
                                                METHOD_BUFFERED or
                                                (FILE_ANY_ACCESS shl 14));

  IOCTL_USB_DIAGNOSTIC_MODE_OFF  = ((FILE_DEVICE_USB shl 16) or
                                                ((USB_IOCTL_INDEX+2) shl 2) or
                                                METHOD_BUFFERED or
                                                (FILE_ANY_ACCESS shl 14));

  IOCTL_USB_GET_ROOT_HUB_NAME  = ((FILE_DEVICE_USB shl 16) or
                                                ((USB_IOCTL_INDEX+3) shl 2) or
                                                METHOD_BUFFERED or
                                                (FILE_ANY_ACCESS shl 14));

  IOCTL_GET_HCD_DRIVERKEY_NAME = ((FILE_DEVICE_USB shl 16) or
                                                ((USB_IOCTL_INDEX+10) shl 2) or
                                                METHOD_BUFFERED or
                                                (FILE_ANY_ACCESS shl 14));

  USB_DEVICE_DESCRIPTOR_TYPE                = $01;
  USB_CONFIGURATION_DESCRIPTOR_TYPE         = $02;
  USB_STRING_DESCRIPTOR_TYPE                = $03;
  USB_INTERFACE_DESCRIPTOR_TYPE             = $04;
  USB_ENDPOINT_DESCRIPTOR_TYPE              = $05;

  USB_REQUEST_GET_STATUS                    = $00;
  USB_REQUEST_CLEAR_FEATURE                 = $01;

  USB_REQUEST_SET_FEATURE                   = $03;

  USB_REQUEST_SET_ADDRESS                   = $05;
  USB_REQUEST_GET_DESCRIPTOR                = $06;
  USB_REQUEST_SET_DESCRIPTOR                = $07;
  USB_REQUEST_GET_CONFIGURATION             = $08;
  USB_REQUEST_SET_CONFIGURATION             = $09;
  USB_REQUEST_GET_INTERFACE                 = $0A;
  USB_REQUEST_SET_INTERFACE                 = $0B;
  USB_REQUEST_SYNC_FRAME                    = $0C;



type
  TUSBHubNode = (usbhnHub,usbhnMIParent);

  TUnicodeName = record
    Length: DWORD;
    UnicodeName: array[0..255] of Byte;
  end;

  TNodeType = record
    ConnectionIndex: DWORD;
    Length: DWORD;
    UnicodeName: array[0..255] of byte
  end;

  TSetupPacket = record
    bmRequest: Byte;
    bRequest: Byte;
    wValue: array[0..1] of Byte;
    wIndex: array[0..1] of Byte;
    wLength: array[0..1] of Byte;
  end;

  TDescriptorRequest = record
    ConnectionIndex: DWORD;
    SetupPacket: TSetupPacket;
    ConfigurationDescriptor: array[0..2047] of Byte;
  end;

  TDeviceDescriptor = record
    Length: Byte;
    DescriptorType: Byte;
    USBSpec: array[0..1] of Byte;
    DeviceClass: Byte;
    DeviceSubClass: Byte;
    DeviceProtocol: Byte;
    MaxPacketSize0: Byte;
    VendorID: Word;//array[0..1] of Byte;
    ProductID: Word; //array[0..1] of Byte;
    DeviceRevision: array[0..1] of byte;
    ManufacturerStringIndex: byte;
    ProductStringIndex: Byte;
    SerialNumberStringIndex: Byte;
    ConfigurationCount: Byte;
  end;

  THubDescriptor = record
    Length: Byte;
    HubType: Byte;
    PortCount: Byte;
    Characteristics: array[0..1] of Byte;
    PowerOnToPowerGood: Byte;
    HubControlCurrent: Byte;
    RemoveAndPowerMask: array[0..63] of Byte;
  end;

  TEndPointDescriptor = record
    Length: Byte;
    DescriptorType: Byte;
    EndpointAddress: Byte;
    Attributes: Byte;
    MaxPacketSize: WORD;
    PollingInterval: Byte;
  end;

  TNodeInformation = record
    NodeType: DWORD;
    NodeDescriptor: THubDescriptor;
    HubIsBusPowered: Byte;
  end;

  TUSBPipeInfo = record
    EndPointDescriptor: TEndpointDescriptor;
    ScheduleOffset: DWORD;
  end;

  TNodeConnectionInformation = record
    ConnectionIndex: DWORD;
    ThisDevice: TDeviceDescriptor;
    CurrentConfiguration: Byte;
    LowSpeed: Byte;
    DeviceIsHub: Byte;
    DeviceAddress: array[0..1] of Byte;
    NumberOfOpenEndPoints: array[0..3] of Byte;
    ThisConnectionStatus: array[0..3] of Byte;
    PipeList: array[0..31] of TUSBPipeInfo;
  end;

  TCollectedDeviceData = record
    DeviceType: DWORD;
    DeviceHandle: DWORD;
    ConnectionData: TNodeConnectionInformation;
    NodeData: TNodeInformation;
  end;

  TUSBClass = 	(usbReserved, usbAudio, usbCommunications, usbHID, usbMonitor,
                 usbPhysicalIntf, usbPower, usbPrinter, usbStorage, usbHub, usbVendorSpec,
                 // illegal values
                 usbExternalHub, usbHostController, usbUnknown, usbError);

  TUSBDevice = record
    Port: DWORD;
    DeviceAddress: DWORD;
    Manufacturer,
    Product,
    Serial: shortstring;
    ConnectionStatus: Byte;
    MaxPower: WORD;
    MajorVersion,
    MinorVersion: Byte;
    ProductID,
    VendorID: Word;
  end;

  TUSBNode = record
    ConnectionName: shortstring;
    Keyname: ShortString;
    USBClass: TUSBClass;
    ParentIndex: Integer;
    Level: Integer;
    USBDevice: TUSBDevice;
  end;

  TUSBNodes = array of TUSBNode;

const
  ClassNames: array[0..14] of string = (
	'Reserved',
        'Audio',
        'Communications',
        'Human interface',
        'Monitor',
        'Physical interface',
        'Power',
        'Printer',
        'Storage',
        'Root Hub',
        'Vendor Specific',
        'External Hub',
        'Host Controller',
        '<error>',
        '<unknown>'
        );

  ConnectionStates: array[0..5] of string = (
	'No device connected',
        'Device connected',
        'Device FAILED enumeration',
        'Device general FAILURE',
        'Device caused overcurrent',
        'Not enough power for device');

function GetDeviceName1(hDevice: THandle; IOCTL_Code: DWORD): string;
function GetDeviceName2(hDevice: THandle; PortIndex: DWORD; IOCTL_Code: DWORD): string;
function GetNodeInformation(hDevice: THandle; var Information: TNodeInformation): Integer;
function GetNodeConnection(hDevice: THandle; PortIndex: DWORD; var Connection: TNodeConnectionInformation): Integer;
function GetStringDescriptor(HubHandle: THandle; PortIndex: DWORD; var LanguageID: Word; Index: Byte; var Str: shortstring): integer;
function GetConfigurationDescriptor(HubHandle: THandle; PortIndex: DWORD; var MaxPower: WORD; var ClassID: integer): Integer;
function GetPortData(hRootHub: THandle; SA: TSecurityAttributes; PortCount: Byte; ParentIndex: integer; Level: Integer; var USBNodes: TUSBNodes): Integer;
procedure EnumUSBDevices(var USBNodes: TUSBNodes);

implementation

function GetDeviceName1(hDevice: THandle; IOCTL_Code: DWORD): string;
var
  i: Integer;
  NameBuffer: TUnicodeName;
  BytesReturned: DWORD;
begin
  Result:='';
  if DeviceIoControl(hDevice,IOCTL_Code,@NameBuffer,SizeOf(NameBuffer),@NameBuffer,SizeOf(NameBuffer),BytesReturned,nil) then begin
//    WideCharToMultiByte(CP_ACP,0,&ConnectedHub.Name[0], (ConnectedHub.ActualLength)/2, &ConnectedHubName[4], 252, NULL, NULL);
    i:=0;
    while NameBuffer.UnicodeName[i]<>0 do begin
      Result:=Result+Chr(NameBuffer.UnicodeName[i]);
      Inc(i,2);
    end;
  end else
    Result:=Format('Error: %s (%d)',[SysErrorMessage(GetLastError),GetLastError]);
end;

function GetDeviceName2(hDevice: THandle; PortIndex: DWORD; IOCTL_Code: DWORD): string;
var
  i: Integer;
  NameBuffer: TNodeType;
  BytesReturned: DWORD;
begin
  Result:='';
  NameBuffer.ConnectionIndex:=PortIndex;
  if DeviceIoControl(hDevice,IOCTL_Code,@NameBuffer,SizeOf(NameBuffer),@NameBuffer,SizeOf(NameBuffer),BytesReturned,nil) then begin
//    WideCharToMultiByte(CP_ACP,0,&ConnectedHub.Name[0], (ConnectedHub.ActualLength)/2, &ConnectedHubName[4], 252, NULL, NULL);
    i:=0;
    while NameBuffer.UnicodeName[i]<>0 do begin
      Result:=Result+Chr(NameBuffer.UnicodeName[i]);
      Inc(i,2);
    end;
  end else
    Result:=Format('Error: %s (%d)',[SysErrorMessage(GetLastError),GetLastError]);
end;

function GetNodeInformation;
var
  BytesReturned: DWORD;
begin
  if DeviceIoControl(hDevice,IOCTL_USB_GET_NODE_INFORMATION,nil,0,@Information,SizeOf(Information),BytesReturned,nil) and (BytesReturned<=256) then
    Result:=0
  else
    Result:=GetLastError;
end;

function GetNodeConnection;
var
  BytesReturned: DWORD;
begin
  Zeromemory(@Connection,SizeOf(Connection));
  Connection.ConnectionIndex:=PortIndex;
  if not DeviceIoControl(hDevice,IOCTL_USB_GET_NODE_CONNECTION_INFORMATION,@Connection,SizeOf(Connection),@Connection,SizeOf(Connection),BytesReturned,nil) and (BytesReturned<=256) then
    Result:=GetLastError
  else
    Result:=0;
end;

function GetStringDescriptor;
var
  Packet: TDescriptorRequest;
  BytesReturned: DWORD;
  Success: boolean;
begin
  Str:='';
  Result:=0;
  if (LanguageID=0) then begin
    Packet.ConnectionIndex:=PortIndex;
    Packet.SetupPacket.bmRequest:=$80;
    Packet.SetupPacket.bRequest:=USB_REQUEST_GET_DESCRIPTOR;
    Packet.SetupPacket.wValue[1]:=USB_STRING_DESCRIPTOR_TYPE;
    Packet.SetupPacket.wLength[0]:=8;
    {Success:=}DeviceIoControl(HubHandle,IOCTL_USB_GET_DESCRIPTOR_FROM_NODE_CONNECTION,@Packet,
			sizeof(Packet),@Packet,sizeof(Packet),BytesReturned,nil);
    {if not Success then
      Result:=GetLastError;}
    LanguageID:=Packet.ConfigurationDescriptor[2]+(Packet.ConfigurationDescriptor[3] shl 8);
  end;
  Packet.ConnectionIndex:=PortIndex;
  Packet.SetupPacket.bmRequest:=$80;
  Packet.SetupPacket.bRequest:=USB_REQUEST_GET_DESCRIPTOR;
  Packet.SetupPacket.wValue[1]:=USB_STRING_DESCRIPTOR_TYPE;
  Packet.SetupPacket.wValue[0]:=Index;
  Packet.SetupPacket.wIndex[0]:=LanguageID and $FF;
  Packet.SetupPacket.wIndex[1]:=(LanguageID shr 8) and $FF;
  Packet.SetupPacket.wLength[0]:=255;
  Success:=DeviceIoControl(HubHandle,IOCTL_USB_GET_DESCRIPTOR_FROM_NODE_CONNECTION,@Packet,
		sizeof(Packet),@Packet,sizeof(Packet),BytesReturned,nil);
  if not Success then
    Result:=GetLastError
  else begin
    ZeroMemory(@Packet.ConfigurationDescriptor[2],255);
    Packet.ConnectionIndex:=PortIndex;
    Packet.SetupPacket.bmRequest:=$80;
    Packet.SetupPacket.bRequest:=USB_REQUEST_GET_DESCRIPTOR;
    Packet.SetupPacket.wValue[1]:=USB_STRING_DESCRIPTOR_TYPE;
    Packet.SetupPacket.wValue[0]:=Index;
    Packet.SetupPacket.wIndex[0]:=LanguageID and $FF;
    Packet.SetupPacket.wIndex[1]:=(LanguageID shr 8) and $FF;
    Packet.SetupPacket.wLength[0]:=255;
    Success:=DeviceIoControl(HubHandle,IOCTL_USB_GET_DESCRIPTOR_FROM_NODE_CONNECTION,@Packet,
   		sizeof(Packet),@Packet,sizeof(Packet),BytesReturned,nil);
    if not Success then
      Result:=GetLastError
    else
      Str:=WideCharToString(PWideChar(@Packet.ConfigurationDescriptor[2]));
  end;
end;

function GetConfigurationDescriptor;
var
  Packet: TDescriptorRequest;
  BytesReturned: DWORD;
  Success: boolean;
  LowByte: Byte;
  BufferPtr: Byte;
begin
  Result:=0;
  ClassID:=-1;
  MaxPower:=0;
  with Packet do begin
    ConnectionIndex:=PortIndex;
    SetupPacket.bmRequest:=$80;
    SetupPacket.bRequest:=USB_REQUEST_GET_DESCRIPTOR;
    SetupPacket.wValue[0]:=0;
    SetupPacket.wValue[1]:=USB_CONFIGURATION_DESCRIPTOR_TYPE;
    SetupPacket.wIndex[0]:=0;
    SetupPacket.wIndex[1]:=0;
    SetupPacket.wLength[0]:=18;
  end;
  Success:=DeviceIoControl(HubHandle,IOCTL_USB_GET_DESCRIPTOR_FROM_NODE_CONNECTION,
                          @Packet,SizeOf(TDescriptorRequest),@Packet,SizeOf(TDescriptorRequest),BytesReturned,nil);
  if not Success then begin
    Result:=GetLastError;
    Exit;
  end;
  with Packet do begin
    ConnectionIndex:=PortIndex;
    SetupPacket.bmRequest:=$80;
    SetupPacket.bRequest:=USB_REQUEST_GET_DESCRIPTOR;
    SetupPacket.wValue[0]:=0;
    SetupPacket.wValue[1]:=USB_CONFIGURATION_DESCRIPTOR_TYPE;
    SetupPacket.wIndex[0]:=0;
    SetupPacket.wIndex[1]:=0;
    SetupPacket.wLength[0]:=Packet.ConfigurationDescriptor[2];
    SetupPacket.wLength[1]:=Packet.ConfigurationDescriptor[3];
  end;
  Success:=DeviceIoControl(HubHandle,IOCTL_USB_GET_DESCRIPTOR_FROM_NODE_CONNECTION,
                          @Packet,SizeOf(TDescriptorRequest),@Packet,SizeOf(TDescriptorRequest),BytesReturned,nil);
  if not Success then begin
    Result:=GetLastError;
    Exit;
  end;

  MaxPower:=Packet.ConfigurationDescriptor[8]*2;
  BufferPtr:=9;
  while (Packet.ConfigurationDescriptor[BufferPtr]<>0) do begin
    if Packet.ConfigurationDescriptor[BufferPtr+1]=4 then begin
      LowByte:=Packet.ConfigurationDescriptor[BufferPtr+5];
      if ((LowByte>9) and (LowByte<255)) then
        LowByte:=11;
      if (LowByte=255) then
        LowByte:=10;
      ClassID:=LowByte;
      Break;
    end;
    Inc(BufferPtr,9);
  end;
end;

function GetPortData;
var
  i,j: Integer;
  NodeConnection: TNodeConnectionInformation;
  hERH: THandle;
  Node: TNodeInformation;
  RootHubName: string;
  LanguageID: Word;
  usb: TUSBNode;
const
  AMachine = '.';
begin
  LanguageID:=0;
  for i:=1 to PortCount do begin
    if GetNodeConnection(hRootHub,i,NodeConnection)=ERROR_SUCCESS then begin
      if NodeConnection.ThisConnectionStatus[0]=1 then begin
        if Boolean(NodeConnection.DeviceIsHub) then begin
          RootHubName:=GetDeviceName2(hRootHub,i,IOCTL_USB_GET_NODE_CONNECTION_NAME);
          hERH:=CreateFile(PChar(Format('\\%s\%s',[AMachine,RootHubName])),
                      GENERIC_WRITE,
                      FILE_SHARE_WRITE,
                      @SA,
                      OPEN_EXISTING,
                      0,
                      0);
          if (hERH<>INVALID_HANDLE_VALUE) then begin
            if GetNodeInformation(hERH,Node)=ERROR_SUCCESS then begin
              ZeroMemory(@usb,SizeOf(usb));
              usb.ConnectionName:=RootHubName;
              usb.KeyName:='';
              usb.USBClass:=usbExternalHub;
              usb.ParentIndex:=ParentIndex;
              usb.Level:=Level;
              usb.USBDevice.Port:=i;
              usb.USBDevice.DeviceAddress:=NodeConnection.DeviceAddress[0];
              usb.USBDevice.ConnectionStatus:=NodeConnection.ThisConnectionStatus[0];
              SetLength(USBNodes,Length(USBNodes)+1);
              USBNodes[High(USBNodes)]:=usb;
              GetPortData(hERH,SA,Node.NodeDescriptor.PortCount,High(USBNodes),Level+1,USBNodes);
              CloseHandle(hERH);
            end;
          end;
        end else begin
          j:=Integer(usbError);
          ZeroMemory(@usb,SizeOf(usb));
          usb.ConnectionName:='';
          usb.KeyName:=GetDeviceName2(hRootHub,i,IOCTL_USB_GET_NODE_CONNECTION_DRIVERKEY_NAME);
          usb.ParentIndex:=ParentIndex;
          usb.Level:=Level;
          usb.USBDevice.Port:=i;
          usb.USBDevice.DeviceAddress:=NodeConnection.DeviceAddress[0];
          usb.USBDevice.ConnectionStatus:=NodeConnection.ThisConnectionStatus[0];
          usb.USBDevice.MajorVersion:=NodeConnection.ThisDevice.USBSpec[1];
          usb.USBDevice.MinorVersion:=NodeConnection.ThisDevice.USBSpec[0];
          usb.USBDevice.ProductID:=NodeConnection.ThisDevice.ProductID;
          usb.USBDevice.VendorID:=NodeConnection.ThisDevice.VendorID;
          if GetStringDescriptor(hRootHub,i,LanguageID,NodeConnection.ThisDevice.ProductStringIndex,usb.USBDevice.Product)=0 then
            if GetStringDescriptor(hRootHub,i,LanguageID,NodeConnection.ThisDevice.ManufacturerStringIndex,usb.USBDevice.Manufacturer)=0 then
              if GetStringDescriptor(hRootHub,i,LanguageID,NodeConnection.ThisDevice.SerialNumberStringIndex,usb.USBDevice.Serial)=0 then
                GetConfigurationDescriptor(hRootHub,i,usb.USBDevice.MaxPower,j);
          if j in [Integer(usbReserved)..Integer(usbVendorSpec)] then
            usb.USBClass:=TUSBClass(j)
          else
            usb.USBClass:=usbError;
          SetLength(USBNodes,Length(USBNodes)+1);
          USBNodes[High(USBNodes)]:=usb;
        end;
      end else begin
        ZeroMemory(@usb,SizeOf(usb));
        usb.ConnectionName:='';
        usb.Keyname:='';
        usb.ParentIndex:=ParentIndex;
        usb.Level:=Level;
        usb.USBDevice.Port:=i;
        usb.USBDevice.DeviceAddress:=NodeConnection.DeviceAddress[0];
        usb.USBDevice.ConnectionStatus:=NodeConnection.ThisConnectionStatus[0];
        SetLength(USBNodes,Length(USBNodes)+1);
        USBNodes[High(USBNodes)]:=usb;
      end;
    end;
  end;
  Result:=Level-1;
end;

procedure EnumUSBDevices;
var
  i: Integer;
  hHCD, hRH: THandle;
  Node: TNodeInformation;
  RootHubName, HCDName: string;
  SA: TSecurityAttributes;
  usb: TUSBNode;
const
  AMachine = '.';
begin
  SetLength(USBNodes,0);
  SA.nLength:=sizeof(SECURITY_ATTRIBUTES);
  SA.lpSecurityDescriptor:=nil;
  SA.bInheritHandle:=false;
  for i:=0 to 9 do begin
    HCDName:=Format('HCD%d',[i]);
    hHCD:=CreateFile(PChar(Format('\\%s\%s',[AMachine,HCDName])),
                      GENERIC_WRITE,
                      FILE_SHARE_WRITE,
                      @SA,
                      OPEN_EXISTING,
                      0,
                      0);
    if (hHCD<>INVALID_HANDLE_VALUE) then begin
      ZeroMemory(@usb,SizeOf(usb));
      usb.ConnectionName:=HCDName;
      usb.Keyname:=GetDeviceName1(hHCD,IOCTL_GET_HCD_DRIVERKEY_NAME);
      usb.USBClass:=usbHostController;
      usb.ParentIndex:=-1;
      usb.Level:=0;
      usb.USBDevice.Port:=i;
      usb.USBDevice.ConnectionStatus:=1;
      SetLength(USBNodes,Length(USBNodes)+1);
      USBNodes[High(USBNodes)]:=usb;
      RootHubName:=GetDeviceName1(hHCD,IOCTL_USB_GET_NODE_INFORMATION);
      hRH:=CreateFile(PChar(Format('\\%s\%s',[AMachine,RootHubName])),
                      GENERIC_WRITE,
                      FILE_SHARE_WRITE,
                      @SA,
                      OPEN_EXISTING,
                      0,
                      0);
      if (hRH<>INVALID_HANDLE_VALUE) then begin
        if GetNodeInformation(hRH,Node)=ERROR_SUCCESS then begin
          ZeroMemory(@usb,SizeOf(usb));
          usb.ConnectionName:=RootHubName;
          usb.Keyname:='';
          usb.USBClass:=usbHub;
          usb.ParentIndex:=High(USBNodes);
          usb.Level:=1;
          usb.USBDevice.ConnectionStatus:=1;
          usb.USBDevice.Port:=i;
          SetLength(USBNodes,Length(USBNodes)+1);
          USBNodes[High(USBNodes)]:=usb;
          GetPortData(hRH,SA,Node.NodeDescriptor.PortCount,High(USBNodes),2,USBNodes);
          CloseHandle(hRH);
        end;
      end;
      CloseHandle(hHCD);
    end;
  end;
end;

end.

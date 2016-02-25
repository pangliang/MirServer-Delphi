{*******************************************************}
{                                                       }
{       MiTeC System Information Component              }
{               Network Detection Part                  }
{           version 8.6.4 for Delphi 5,6,7              }
{                                                       }
{       Copyright © 1997,2004 Michal Mutl               }
{                                                       }
{*******************************************************}

{$INCLUDE MITEC_DEF.INC}

unit MSI_Network;

interface

uses
  SysUtils, Windows, Classes, WinSock, MSI_Common, MiTeC_IpHlpAPI, MiTeC_NetBIOS;

type
  TWinsock = class(TPersistent)
  private
    FDesc: string;
    FStat: string;
    FMajVer: word;
    FMinVer: word;
    FModes: TExceptionModes;
    procedure SetMode(const Value: TExceptionModes);
  public
    constructor Create;
    procedure GetInfo;
  published
    property ExceptionModes: TExceptionModes read FModes Write SetMode;
    property Description: string read FDesc {$IFNDEF D6PLUS} write FDesc {$ENDIF} stored False;
    property MajorVersion: word read FMajVer {$IFNDEF D6PLUS} write FMajVer {$ENDIF} stored False;
    property MinorVersion: word read FMinVer {$IFNDEF D6PLUS} write FMinVer {$ENDIF} stored False;
    property Status: string read FStat {$IFNDEF D6PLUS} write FStat {$ENDIF} stored False;
  end;

  TAdapterType = (atOther, atEthernet, atTokenRing, atFDDI, atPPP, atLoopback, atSlip);

  PAdapter = ^TAdapter;
  TAdapter = record
    Name,
    Address: string;
    Typ: TAdapterType;
    EnableDHCP,
    HaveWINS: boolean;
    IPAddress,
    IPAddressMask,
    Gateway_IPAddress,
    Gateway_IPAddressMask,
    DHCP_IPAddress,
    DHCP_IPAddressMask,
    PrimaryWINS_IPAddress,
    PrimaryWINS_IPAddressMask,
    SecondaryWINS_IPAddress,
    SecondaryWINS_IPAddressMask: TStringList;
  end;

  TNodeType = (ntUnknown, ntBroadcast, ntPeerToPeer, ntMixed, ntHybrid);

  TTCPIP = class(TPersistent)
  private
    FAdapters: TStringList;
    FProxy: boolean;
    FRouting: boolean;
    FDNS: boolean;
    FHost: string;
    FDomain: string;
    FDNSPrefix: string;
    FDNSList: TStrings;
    FDNSSuffix: TStrings;
    FNode: TNodeType;
    FDHCPScope: string;
    {$IFNDEF D6PLUS}
    FCount: Word;
    {$ENDIF}
    FModes: TExceptionModes;

    procedure ClearList;
    function GetAdapter(Index: Word): TAdapter;
    function GetAdapterCount: Word;
    procedure SetMode(const Value: TExceptionModes);
  public
    constructor Create;
    destructor Destroy; override;
    procedure GetInfo;
    procedure Report(var sl :TStringList; Standalone: Boolean = True); virtual;
    function FindAdapter(AName: string): Integer;

    property Adapter[Index: Word]: TAdapter read GetAdapter;
  published
    property ExceptionModes: TExceptionModes read FModes Write SetMode;
    property AdapterCount: Word read GetAdapterCount {$IFNDEF D6PLUS} write FCount {$ENDIF} stored False;
    property HostName: string read FHost {$IFNDEF D6PLUS} write FHost {$ENDIF} stored False;
    property DomainName: string read FDomain {$IFNDEF D6PLUS} write FDomain {$ENDIF} stored False;
    property EnableProxy: boolean read FProxy {$IFNDEF D6PLUS} write FProxy {$ENDIF} stored False;
    property EnableRouting: boolean read FRouting {$IFNDEF D6PLUS} write FRouting {$ENDIF} stored False;
    property EnableDNS: boolean read FDNS {$IFNDEF D6PLUS} write FDNS {$ENDIF} stored False;
    property PrimaryDNSSuffix: string read FDNSPrefix {$IFNDEF D6PLUS} write FDNSPrefix {$ENDIF} stored False;
    property DHCPScopeName: string read FDHCPScope {$IFNDEF D6PLUS} write FDHCPScope {$ENDIF} stored False;
    property DNSServers: TStrings read FDNSList {$IFNDEF D6PLUS} write FDNSList {$ENDIF} stored False;
    property DNSSuffixes: TStrings read FDNSSuffix {$IFNDEF D6PLUS} write FDNSSuffix {$ENDIF} stored False;
    property NodeType: TNodeType read FNode {$IFNDEF D6PLUS} write FNode {$ENDIF} stored False;
  end;

  TNetwork = class(TPersistent)
  private
    FVirtAdapter,FPhysAdapter: TStrings;
    FWinsock: TWinsock;
    FIPAddress: TStrings;
    FMACAddress: TStrings;
    FCli: TStrings;
    FServ: TStrings;
    FProto: TStrings;
    FModes: TExceptionModes;
    FTCPIP: TTCPIP;
    function GetLocalIP :string;
    procedure SetMode(const Value: TExceptionModes);
  public
    constructor Create;
    destructor Destroy; override;
    procedure GetInfo;
    procedure Report(var sl :TStringList; Standalone: Boolean = True); virtual;
  published
    property ExceptionModes: TExceptionModes read FModes Write SetMode;
    property IPAddresses: TStrings read FIPAddress {$IFNDEF D6PLUS} write FIPAddress {$ENDIF} stored false;
    property MACAddresses: TStrings read FMACAddress {$IFNDEF D6PLUS} write FMACAddress {$ENDIF} stored False;
    property PhysicalAdapters :TStrings read FPhysAdapter {$IFNDEF D6PLUS} write FPhysAdapter {$ENDIF} stored False;
    property VirtualAdapters :TStrings read FVirtAdapter {$IFNDEF D6PLUS} write FVirtAdapter {$ENDIF} stored false;
    property Protocols :TStrings read FProto {$IFNDEF D6PLUS} write FProto {$ENDIF} stored False;
    property Services :TStrings read FServ {$IFNDEF D6PLUS} write FServ {$ENDIF} stored False;
    property Clients :TStrings read FCli {$IFNDEF D6PLUS} write FCli {$ENDIF} stored False;
    property WinSock: TWinsock read FWinsock {$IFNDEF D6PLUS} write FWinsock {$ENDIF} stored false;
    property TCPIP: TTCPIP read FTCPIP {$IFNDEF D6PLUS} write FTCPIP {$ENDIF} stored False;
  end;

const
  NodeTypes: array[TNodeType] of string = ('Unknown','Broadcast','Peer-To-Peer','Mixed','Hybrid');

  AdapterTypes: array[TAdapterType] of string = ('Other', 'Ethernet', 'Token Ring', 'FDDI', 'PPP', 'Loopback', 'Slip');

implementation

uses Registry, MiTeC_Routines, MSI_Devices;

{ TWinsock }

constructor TWinsock.Create;
begin
  ExceptionModes:=[emExceptionStack];
end;

procedure TWinsock.GetInfo;
var
  GInitData :TWSADATA;
begin
  {$IFDEF ERROR_INTERCEPT}PushTrace(FModes,Self,'GetInfo'); {$ENDIF}

  if wsastartup($101,GInitData)=0 then begin
    FDesc:=GInitData.szDescription;
    FStat:=GInitData.szSystemStatus;
    FMajVer:=Hi(GInitData.wHighVersion);
    FMinVer:=Lo(GInitData.wHighVersion);
    wsacleanup;
  end else
    FStat:='Winsock cannot be initialized.';

  {$IFDEF ERROR_INTERCEPT}PopTrace;{$ENDIF}
end;

procedure TWinsock.SetMode(const Value: TExceptionModes);
begin
  FModes := Value;
end;

{ TNetwork }

function TNetwork.GetLocalIP: string;
type
  TaPInAddr = array [0..255] of PInAddr;
  PaPInAddr = ^TaPInAddr;
var
  phe  :PHostEnt;
  pptr :PaPInAddr;
  Buffer :array [0..63] of char;
  i :integer;
  GInitData :TWSADATA;
begin
  wsastartup($101,GInitData);
  result:='';
  GetHostName(Buffer,SizeOf(Buffer));
  phe:=GetHostByName(buffer);
  if not assigned(phe) then
    exit;
  pptr:=PaPInAddr(Phe^.h_addr_list);
  i:=0;
  while pptr^[I]<>nil do begin
    result:=Result+inet_ntoa(pptr^[I]^)+',';
    inc(i);
  end;
  Delete(Result,Length(Result),1);
  wsacleanup;
end;

procedure TNetwork.GetInfo;
var
  i: integer;
  s,ck,dv: string;
  sl: TStringList;
const
  rkNetworkNT = {HKEY_LOCAL_MACHINE}'\SOFTWARE\Microsoft\Windows NT\CurrentVersion\NetworkCards';
  rkNetwork2K = {HKEY_LOCAL_MACHINE}'\SYSTEM\CurrentControlSet\Control\Network';

  rvNetworkNT = 'Description';

  rvProtoClass = 'NetTrans';
  rvServClass = 'NetService';
  rvCliClass = 'NetClient';
begin
  {$IFDEF ERROR_INTERCEPT}PushTrace(FModes,Self,'GetInfo'); {$ENDIF}

  Winsock.GetInfo;
  TCPIP.GetInfo;

  if IsNT{4 or (IsNT5 and (FPhysAdapter.Count+FVirtAdapter.Count=0))} then
    with TRegistry.Create do begin
      sl:=TStringList.Create;
      try
        RootKey:=HKEY_LOCAL_MACHINE;
        if OpenKeyReadOnly(rkNetworkNT) then begin
          GetKeyNames(sl);
          CloseKey;
          for i:=0 to sl.Count-1 do
            if OpenKeyReadOnly(rkNetworkNT+'\'+sl[i]) then begin
              s:=ReadString(rvNetworkNT);
              if FPhysAdapter.IndexOf(s)=-1 then
                FPhysAdapter.Add(s);
              Closekey;
            end;
        end;
      finally
        sl.Free;
        Free;
      end;
    end;

  FIPAddress.CommaText:=GetLocalIP;

  if IsNT5 then begin
    ck:=rkNetwork2K;
    dv:=rvNetworkNT;
  end else begin
    ck:=ClassKey;
    dv:=DescValue;
  end;
  GetClassDevices(ck,rvProtoClass,dv,FProto);
  GetClassDevices(ck,rvServClass,dv,FServ);
  GetClassDevices(ck,rvCliClass,dv,FCli);

  NB_GetMACAddresses(Machinename,FMACAddress);

  {$IFDEF ERROR_INTERCEPT}PopTrace;{$ENDIF}
end;

constructor TNetwork.Create;
var
  i: Integer;
  s: string;
begin
  inherited;
  FWinsock:=TWinsock.Create;
  FTCPIP:=TTCPIP.Create;
  ExceptionModes:=[emExceptionStack];

  FVirtAdapter:=TStringList.Create;
  FPhysAdapter:=TStringList.Create;
  FIPAddress:=TStringList.Create;
  FMACAddress:=TStringList.Create;
  FProto:=TStringList.Create;
  FServ:=TStringList.Create;
  FCli:=TStringList.Create;

  s:='';
  with TDevices.Create do begin
    GetInfo;
    for i:=0 to DeviceCount-1 do begin
      if Devices[i].FriendlyName='' then
        s:=Devices[i].Description
      else
        s:=Devices[i].FriendlyName;
      if Devices[i].DeviceClass=dcNet then begin
        if (Devices[i].ResourceListKey<>'') and (Devices[i].Location<>'') then
          FPhysAdapter.Add(s)
        else
          FVirtAdapter.Add(s)
      end;
    end;
    Free;
  end;
end;

destructor TNetwork.Destroy;
begin
  FWinsock.Destroy;
  FTCPIP.Destroy;
  FVirtAdapter.Destroy;
  FPhysAdapter.Destroy;
  FMACAddress.Destroy;
  FIPAddress.Destroy;
  FProto.Destroy;
  FCli.Destroy;
  FServ.Destroy;
  inherited;
end;

procedure TNetwork.Report;
begin
  {$IFDEF ERROR_INTERCEPT}PushTrace(FModes,Self,'Report'); {$ENDIF}
  with sl do begin
    if Standalone then ReportHeader(sl);

    Add('<Network classname="TNetwork">');
    Add('<section name="Physical Adapters">');
    StringsToRep(PhysicalAdapters,'Count','Adapter',sl);
    Add('</section>');
    Add('<section name="Virtual Adapters">');
    StringsToRep(VirtualAdapters,'Count','Adapter',sl);
    Add('</section>');
    Add('<section name="Protocols">');
    StringsToRep(Protocols,'Count','Protocol',sl);
    Add('</section>');
    Add('<section name="Services">');
    StringsToRep(Services,'Count','Service',sl);
    Add('</section>');
    Add('<section name="Clients">');
    StringsToRep(Clients,'Count','Client',sl);
    Add('</section>');
    Add('<section name="IPAddresses">');
    StringsToRep(IPAddresses,'Count','IPAddress',sl);
    Add('</section>');
    Add('<section name="MACAdresses">');
    StringsToRep(MACAddresses,'Count','MACAddress',sl);
    Add('</section>');
    Add('</Network>');

    Add('<Winsock classname="TWinsock">');
    Add(Format('<data name="Description" type="string">%s</data>',[CheckXMLValue(Winsock.Description)]));
    Add(Format('<data name="Version" type="string">%d.%d</data>',[Winsock.MajorVersion,Winsock.MinorVersion]));
    Add(Format('<data name="Status" type="string">%s</data>',[CheckXMLValue(Winsock.Status)]));
    Add('</Winsock>');

    TCPIP.Report(sl,False);

    if Standalone then ReportFooter(sl);
  end;
  {$IFDEF ERROR_INTERCEPT}PopTrace;{$ENDIF}
end;

procedure TNetwork.SetMode(const Value: TExceptionModes);
begin
  FModes := Value;
  if Assigned(TCPIP) then
    TCPIP.ExceptionModes:=FModes;
  if Assigned(Winsock) then
    Winsock.ExceptionModes:=FModes;
end;

{ TTCPIP }

procedure TTCPIP.ClearList;
var
  i: Integer;
  p: PAdapter;
begin
  for i:=0 to FAdapters.Count-1 do begin
    p:=PAdapter(FAdapters.Objects[i]);
    p^.IPAddress.Free;
    p^.IPAddressMask.Free;
    p^.Gateway_IPAddress.Free;
    p^.Gateway_IPAddressMask.Free;
    p^.DHCP_IPAddress.Free;
    p^.DHCP_IPAddressMask.Free;
    p^.PrimaryWINS_IPAddress.Free;
    p^.PrimaryWINS_IPAddressMask.Free;
    p^.SecondaryWINS_IPAddress.Free;
    p^.SecondaryWINS_IPAddressMask.Free;
    Dispose(p);
  end;
  FAdapters.Clear;
end;

constructor TTCPIP.Create;
begin
  inherited;
  FAdapters:=TStringList.Create;
  FDNSList:=TStringList.Create;
  FDNSSuffix:=TStringList.Create;
  ExceptionModes:=[emExceptionStack];
end;

destructor TTCPIP.Destroy;
begin
  ClearList;
  FDNSList.Destroy;
  FAdapters.Destroy;
  FDNSSuffix.Destroy;
  inherited;
end;

function TTCPIP.FindAdapter(AName: string): Integer;
begin
  Result:=FAdapters.IndexOf(AName);
end;

function TTCPIP.GetAdapter(Index: Word): TAdapter;
begin
  Result:=PAdapter(FAdapters.Objects[Index])^;
end;

function TTCPIP.GetAdapterCount: Word;
begin
  Result:=FAdapters.Count;
end;

procedure TTCPIP.GetInfo;
var
  ai, aiInitPtr: PIP_ADAPTER_INFO;
  lastip,ip: PIP_ADDR_STRING;
  np: PFixedInfo;
  r,j: dword;
  Size: ulong;
  A: PAdapter;
  s: string;
  Temp: string;
  Suffix: string;
const
  rkTCPIP = {HKEY_LOCAL_MACHINE\}'SYSTEM\CurrentControlSet\Services\Tcpip\Parameters';
  rvSL = 'SearchList';
begin
  {$IFDEF ERROR_INTERCEPT}PushTrace(FModes,Self,'GetInfo'); {$ENDIF}

  try
  try
  ClearList;
  if InitIpHlpAPI then begin
    size:=SizeOf(IP_ADAPTER_INFO);
    aiInitPtr:=AllocMem(size);
    try
      r:=GetAdaptersInfo(aiInitPtr,size);
      while(r=ERROR_BUFFER_OVERFLOW) do begin
        size:=Size+SizeOf(IP_ADAPTER_INFO);
        ReallocMem(aiInitPtr,size);
        r:=GetAdaptersInfo(aiInitPtr,size);
      end;
      ai:=aiInitPtr;
      if(r=ERROR_SUCCESS) then begin
        while assigned(ai) do begin
          New(A);
          A^.IPAddress:=TStringList.Create;
          A^.IPAddressMask:=TStringList.Create;
          A^.Gateway_IPAddress:=TStringList.Create;
          A^.Gateway_IPAddressMask:=TStringList.Create;
          A^.DHCP_IPAddress:=TStringList.Create;
          A^.DHCP_IPAddressMask:=TStringList.Create;
          A^.PrimaryWINS_IPAddress:=TStringList.Create;
          A^.PrimaryWINS_IPAddressMask:=TStringList.Create;
          A^.SecondaryWINS_IPAddress:=TStringList.Create;
          A^.SecondaryWINS_IPAddressMask:=TStringList.Create;

          A^.Name:=Trim(string(ai^.Description));
          case ai^.Type_ of
            MIB_IF_OTHER_ADAPTERTYPE: A^.Typ:=atOther;
            MIB_IF_ETHERNET_ADAPTERTYPE: A^.Typ:=atEthernet;
            MIB_IF_TOKEN_RING_ADAPTERTYPE: A^.Typ:=atTokenRing;
            MIB_IF_FDDI_ADAPTERTYPE: A^.Typ:=atFDDI;
            MIB_IF_PPP_ADAPTERTYPE: A^.Typ:=atPPP;
            MIB_IF_LOOPBACK_ADAPTERTYPE: A^.Typ:=atLoopback;
            MIB_IF_SLIP_ADAPTERTYPE: A^.Typ:=atSlip;
          end;
          s:='';
          if ai^.AddressLength>0 then begin
            for j:=0 to ai^.AddressLength-1 do
              s:=s+Format('%2.2x:',[ai^.Address[j]]);
            SetLength(s,Length(s)-1);
          end;
          A^.Address:=s;
          A^.EnableDHCP:=Boolean(ai^.DhcpEnabled);
          A^.HaveWINS:=Boolean(ai^.HaveWins);

          ip:=@(ai^.IpAddressList);
          repeat
            lastip:=ip;
            A^.IPAddress.Add(string(ip^.IpAddress.s));
            A^.IPAddressMask.Add(string(ip^.IpMask.s));
            ip:=ip.Next;
          until not Assigned(ip) or (lastip=ip);

          ip:=@(ai^.GatewayList);
          repeat
            lastip:=ip;
            A^.Gateway_IPAddress.Add(string(ip^.IpAddress.s));
            A^.Gateway_IPAddressMask.Add(string(ip^.IpMask.s));
            ip:=ip.Next;
          until not Assigned(ip) or (lastip=ip);

          ip:=@(ai^.DhcpServer);
          repeat
            lastip:=ip;
            A^.DHCP_IPAddress.Add(string(ip^.IpAddress.s));
            A^.DHCP_IPAddressMask.Add(string(ip^.IpMask.s));
            ip:=ip.Next;
          until not Assigned(ip) or (lastip=ip);

          ip:=@(ai^.PrimaryWinsServer);
          repeat
            lastip:=ip;
            A^.PrimaryWINS_IPAddress.Add(string(ip^.IpAddress.s));
            A^.PrimaryWINS_IPAddressMask.Add(string(ip^.IpMask.s));
            ip:=ip.Next;
          until not Assigned(ip) or (lastip=ip);

          ip:=@(ai^.SecondaryWinsServer);
          repeat
            lastip:=ip;
            A^.SecondaryWINS_IPAddress.Add(string(ip^.IpAddress.s));
            A^.SecondaryWINS_IPAddressMask.Add(string(ip^.IpMask.s));
            ip:=ip.Next;
          until not Assigned(ip) or (lastip=ip);

          FAdapters.AddObject(A^.Name,TObject(@A^));
          ai:=ai.Next;
        end;
      end;
    finally
      if Assigned(aiInitPtr) then
        FreeMem(aiInitPtr);
    end;

    Size:=SizeOf(TFixedInfo);
    np:=Allocmem(size);
    try
      r:=GetNetworkparams(np,Size);
      while r=ERROR_BUFFER_OVERFLOW do begin
        Reallocmem(np,size);
        r:=GetNetworkparams(np,Size);
      end;

      if r=ERROR_SUCCESS then begin
        case np^.NodeType of
          BROADCAST_NODETYPE: FNode:=ntBroadcast;
          PEER_TO_PEER_NODETYPE: FNode:=ntPeerToPeer;
          MIXED_NODETYPE: FNode:=ntMixed;
          HYBRID_NODETYPE: FNode:=ntHybrid;
          else FNode:=ntUnknown;
        end;
        FDHCPScope:=string(np^.ScopeId);
        if Assigned(np^.CurrentDnsServer) then
          FDNSPrefix:=string(np^.CurrentDnsServer.IpAddress.S)
        else
          FDNSPrefix:='';

        ip:=@(np^.DnsServerList);
        FDNSList.Clear;
        repeat
          Temp:=string(ip^.IpAddress.s);
          FDNSList.Add(Temp);
          ip:=ip.Next;
        until (not Assigned(ip)) or (Temp=string(ip^.IpAddress.s));
        FDNSSuffix.Clear;
        Suffix:=ReadRegistryString(HKEY_LOCAL_MACHINE,rkTCPIP,rvSL);
        while Pos(',',Suffix) <> 0 do begin
         FDNSSuffix.Add(Copy(Suffix,1,Pos(',',Suffix)-1));
         Delete(Suffix,1,Pos(',',Suffix));
        end;
        FDNSSuffix.Add(Suffix);

        FHost:=np^.HostName;
        FDomain:=np^.DomainName;
        FProxy:=Boolean(np^.EnableProxy);
        FRouting:=Boolean(np^.EnableRouting);
        FDNS:=Boolean(np^.EnableDns);
      end;
    finally
      if Assigned(np) then
        FreeMem(np);
    end;
  end;
  except
  end;
  finally

  end;

  {$IFDEF ERROR_INTERCEPT}PopTrace;{$ENDIF}
end;

procedure TTCPIP.Report;
var
  j: Integer;
begin
  {$IFDEF ERROR_INTERCEPT}PushTrace(FModes,Self,'Report'); {$ENDIF}
  with sl do begin
    if Standalone then ReportHeader(sl);
    Add('<TCPIP classname="TTCPIP">');

    Add(Format('<data name="HostName" type="string">%s</data>',[CheckXMLValue(HostName)]));
    Add(Format('<data name="DomainName" type="string">%s</data>',[CheckXMLValue(DomainName)]));
    Add(Format('<data name="NodeType" type="string">%s</data>',[NodeTypes[NodeType]]));
    Add(Format('<data name="PrimaryDNSSuffix" type="string">%s</data>',[CheckXMLValue(PrimaryDNSSuffix)]));
    Add(Format('<data name="DNSServers" type="string">%s</data>',[CheckXMLValue(DNSServers.CommaText)]));
    for j:=0 to AdapterCount-1 do begin
      Add(Format('<section name="Adapter_%d">',[j]));
      with Adapter[j] do begin
        Add(Format('<data name="Name" type="string">%s</data>',[CheckXMLValue(Adapter[j].Name)]));
        Add(Format('<data name="PhysicalAddress" type="string">%s</data>',[Adapter[j].Address]));
        Add(Format('<data name="Type" type="string">%s</data>',[AdapterTypes[Adapter[j].Typ]]));
        Add(Format('<data name="IPAddress" type="string">%s</data>',[Adapter[j].IPAddress.CommaText]));
        Add(Format('<data name="IPMask" type="string">%s</data>',[Adapter[j].IPAddressMask.CommaText]));
        Add(Format('<data name="Gateway_IPAddress" type="string">%s</data>',[Adapter[j].Gateway_IPAddress.CommaText]));
        Add(Format('<data name="Gateway_IPMask" type="string">%s</data>',[Adapter[j].Gateway_IPAddressMask.CommaText]));
        Add(Format('<data name="DHCP_IPAddress" type="string">%s</data>',[Adapter[j].DHCP_IPAddress.CommaText]));
        Add(Format('<data name="DHCP_IPMask" type="string">%s</data>',[Adapter[j].DHCP_IPAddressMask.CommaText]));
        Add(Format('<data name="PrimaryWINS_IPAddress" type="string">%s</data>',[Adapter[j].PrimaryWINS_IPAddress.CommaText]));
        Add(Format('<data name="PrimaryWINS_IPMask" type="string">%s</data>',[Adapter[j].PrimaryWINS_IPAddressMask.CommaText]));
        Add(Format('<data name="SecondaryWINS_IPAddress" type="string">%s</data>',[Adapter[j].SecondaryWINS_IPAddress.CommaText]));
        Add(Format('<data name="SecondaryWINS_IPMask" type="string">%s</data>',[Adapter[j].SecondaryWINS_IPAddressMask.CommaText]));
      end;
      Add('</section>');
    end;

    Add('</TCPIP>');
    if Standalone then ReportFooter(sl);
  end;
  {$IFDEF ERROR_INTERCEPT}PopTrace;{$ENDIF}
end;

procedure TTCPIP.SetMode(const Value: TExceptionModes);
begin
  FModes := Value;
end;

end.

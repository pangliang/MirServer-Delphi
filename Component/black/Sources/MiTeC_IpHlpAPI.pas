{*******************************************************}
{                                                       }
{       MiTeC System Information Component              }
{                IP Helper API                          }
{           version 8.6 for Delphi 5,6                  }
{                                                       }
{          Copyright © 2002,2004 Michal Mutl            }
{                                                       }
{*******************************************************}

unit MiTeC_IpHlpAPI;

interface

uses Windows, SysUtils;

type
  time_t = Longint;

const
  MAX_ADAPTER_DESCRIPTION_LENGTH = 128;
  MAX_ADAPTER_NAME_LENGTH        = 256;
  MAX_ADAPTER_ADDRESS_LENGTH     = 8;
  DEFAULT_MINIMUM_ENTITIES       = 32;
  MAX_HOSTNAME_LEN               = 128;
  MAX_DOMAIN_NAME_LEN            = 128;
  MAX_SCOPE_ID_LEN               = 256;

  BROADCAST_NODETYPE    = 1;
  PEER_TO_PEER_NODETYPE = 2;
  MIXED_NODETYPE        = 4;
  HYBRID_NODETYPE       = 8;

  MIB_IF_OTHER_ADAPTERTYPE      = 1;
  MIB_IF_ETHERNET_ADAPTERTYPE   = 6;
  MIB_IF_TOKEN_RING_ADAPTERTYPE = 9;
  MIB_IF_FDDI_ADAPTERTYPE       = 15;
  MIB_IF_PPP_ADAPTERTYPE        = 23;
  MIB_IF_LOOPBACK_ADAPTERTYPE   = 24;
  MIB_IF_SLIP_ADAPTERTYPE       = 28;

type
  PIP_MASK_STRING = ^IP_MASK_STRING;
  IP_ADDRESS_STRING = record
    S: array [0..15] of Char;
  end;
  PIP_ADDRESS_STRING = ^IP_ADDRESS_STRING;
  IP_MASK_STRING = IP_ADDRESS_STRING;
  TIpAddressString = IP_ADDRESS_STRING;
  PIpAddressString = PIP_MASK_STRING;


  PIP_ADDR_STRING = ^IP_ADDR_STRING;
  _IP_ADDR_STRING = record
    Next: PIP_ADDR_STRING;
    IpAddress: IP_ADDRESS_STRING;
    IpMask: IP_MASK_STRING;
    Context: DWORD;
  end;
  IP_ADDR_STRING = _IP_ADDR_STRING;
  TIpAddrString = IP_ADDR_STRING;
  PIpAddrString = PIP_ADDR_STRING;

  PIP_ADAPTER_INFO = ^IP_ADAPTER_INFO;
  _IP_ADAPTER_INFO = record
    Next: PIP_ADAPTER_INFO;
    ComboIndex: DWORD;
    AdapterName: array [0..MAX_ADAPTER_NAME_LENGTH + 3] of Char;
    Description: array [0..MAX_ADAPTER_DESCRIPTION_LENGTH + 3] of Char;
    AddressLength: UINT;
    Address: array [0..MAX_ADAPTER_ADDRESS_LENGTH - 1] of BYTE;
    Index: DWORD;
    Type_: UINT;
    DhcpEnabled: UINT;
    CurrentIpAddress: PIP_ADDR_STRING;
    IpAddressList: IP_ADDR_STRING;
    GatewayList: IP_ADDR_STRING;
    DhcpServer: IP_ADDR_STRING;
    HaveWins: BOOL;
    PrimaryWinsServer: IP_ADDR_STRING;
    SecondaryWinsServer: IP_ADDR_STRING;
    LeaseObtained: time_t;
    LeaseExpires: time_t;
  end;
  IP_ADAPTER_INFO = _IP_ADAPTER_INFO;
  TIpAdapterInfo = IP_ADAPTER_INFO;
  PIpAdapterInfo = PIP_ADAPTER_INFO;

  PIP_PER_ADAPTER_INFO = ^IP_PER_ADAPTER_INFO;
  _IP_PER_ADAPTER_INFO = record
    AutoconfigEnabled: UINT;
    AutoconfigActive: UINT;
    CurrentDnsServer: PIP_ADDR_STRING;
    DnsServerList: IP_ADDR_STRING;
  end;
  IP_PER_ADAPTER_INFO = _IP_PER_ADAPTER_INFO;
  TIpPerAdapterInfo = IP_PER_ADAPTER_INFO;
  PIpPerAdapterInfo = PIP_PER_ADAPTER_INFO;

  PFIXED_INFO = ^FIXED_INFO;
  FIXED_INFO = record
    HostName: array [0..MAX_HOSTNAME_LEN + 3] of Char;
    DomainName: array[0..MAX_DOMAIN_NAME_LEN + 3] of Char;
    CurrentDnsServer: PIP_ADDR_STRING;
    DnsServerList: IP_ADDR_STRING;
    NodeType: UINT;
    ScopeId: array [0..MAX_SCOPE_ID_LEN + 3] of Char;
    EnableRouting: UINT;
    EnableProxy: UINT;
    EnableDns: UINT;
  end;
  TFixedInfo = FIXED_INFO;
  PFixedInfo = PFIXED_INFO;

var
  IpHlpAPIHandle: THandle = 0;

  GetAdaptersInfo: function (pAdapterInfo: PIP_ADAPTER_INFO; var pOutBufLen: ULONG): DWORD; stdcall;
  GetNetworkParams: function (pFixedInfo: PFIXED_INFO; var pOutBufLen: ULONG): DWORD; stdcall;

function InitIpHlpAPI: Boolean;
procedure FreeIpHlpAPI;

implementation

const
  IpHlpAPI_DLL = 'iphlpapi.dll';

function InitIpHlpAPI: Boolean;
begin
  IpHlpAPIHandle:=GetModuleHandle(IpHlpAPI_DLL);
  if IpHlpAPIHandle=0 then
    IpHlpAPIHandle:=LoadLibrary(IpHlpAPI_DLL);
  if IpHlpAPIHandle<>0 then begin
    @GetAdaptersInfo:=GetProcAddress(IpHlpAPIHandle,'GetAdaptersInfo');
    @GetNetworkParams:=GetProcAddress(IpHlpAPIHandle,'GetNetworkParams');
  end;
  Result:=(IpHlpAPIHandle<>0) and Assigned(GetAdaptersInfo);
end;

procedure FreeIpHlpAPI;
begin
  if IpHlpAPIHandle<>0 then begin
    if not FreeLibrary(IpHlpAPIHandle) then
      Exception.Create('Unload Error: '+IpHlpAPI_DLL+' ('+inttohex(getmodulehandle(IpHlpAPI_DLL),8)+')')
    else
      IpHlpAPIHandle:=0;
  end;
end;

initialization
finalization
  FreeIpHlpAPI;
end.

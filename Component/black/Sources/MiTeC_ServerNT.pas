{*******************************************************}
{                                                       }
{       MiTeC System Information Component              }
{             Windows NT Server Info                    }
{           version 8.3 for Delphi 5,6,7                }
{                                                       }
{       Copyright © 1997,2003 Michal Mutl               }
{                                                       }
{*******************************************************}

{$INCLUDE MITEC_DEF.INC}



unit MiTeC_ServerNT;

interface

uses Windows, Classes, SysUtils;

type
  PServer = ^TServer;
  TServer = record
    Name: string;
    Comment: string;
    PlatformID: DWORD;
    VersionMajor,
    VersionMinor: DWORD;
    ServerType: DWORD;
  end;

  PNTServerTransRecord = ^TNTServerTransRecord;
  TNTServerTransRecord = record
    Name: string;
    Address: Byte;
    AddrLength: DWORD;
    NetAddress: string;
    Domain: string;
    VCSCount: DWORD;
  end;

  TNTServer = class(TPersistent)
  private
    FTrans: TStringList;
    FMachine: string;
    procedure RetrieveTrans(AMachine: string);
    function GetTrans(Index: DWORD): PNTServerTransRecord;
    function GetTransCount: DWORD;
    procedure FreeTransList(var AList: TStringList);
  public
    constructor Create;
    destructor Destroy; override;

    procedure RefreshTrans;

    property Machine: string read FMachine write FMachine;
    property TransportCount: DWORD read GetTransCount;
    property Transports[Index: DWORD]: PNTServerTransRecord read GetTrans;
  end;

procedure FreeServerList(var AList: TStringList);
procedure GetServerList(AServerType: DWORD; ADomain: string; var AList: TStringList);
function GetServerTypeStr(AType: DWORD): string;

implementation

uses MiTeC_Routines, MiTeC_NetAPI32;

procedure FreeServerList;
var
  pr: PServer;
begin
  while AList.count>0 do begin
    pr:=pServer(AList.Objects[AList.count-1]);
    dispose(pr);
    AList.Delete(AList.count-1);
  end;
end;

procedure GetServerList;
var
  pTmpBuf, pBuf: PSERVER_INFO_100;
  nStatus: NET_API_STATUS;
  i: DWORD;
  dwPrefMaxLen: DWORD;
  dwEntriesRead: DWORD;
  dwTotalEntries: DWORD;
  dwResumeHandle: DWORD;
  Loop: Boolean;
  pr: PServer;
begin
  FreeServerList(AList);
  pBuf:=nil;
  Loop:=True;
  dwPrefMaxLen:=$FFFFFFFF;
  dwEntriesRead:=0;
  dwTotalEntries:=0;
  dwResumeHandle:=0;
  while Loop do begin
    nStatus:=NetServerEnum(nil,100,Pointer(pBuf),
                               dwPrefMaxLen, dwEntriesRead, dwTotalEntries,
                               AServerType,nil{StringToWideChar(ADomain,Buf,256)},
                               dwResumeHandle);
    if ((nStatus=ERROR_SUCCESS) or (nStatus=ERROR_MORE_DATA)) and (dwEntriesRead>0) then begin
      pTmpBuf:=pBuf;
      for i:=0 to dwEntriesRead-1 do begin
        new(pr);
        pr^.Name:=WideCharToString(pTmpBuf^.sv100_name);
//        pr^.Comment:=WideCharToString(pTmpBuf^.sv101_comment);
        pr^.PlatformID:=pTmpBuf^.sv100_platform_id;
//        pr^.VersionMajor:=pTmpBuf^.sv101_version_major;
//        pr^.VersionMinor:=pTmpBuf^.sv101_version_minor;
//        pr^.ServerType:=pTmpBuf^.sv101_type;
        AList.AddObject(pr^.Name,TObject(pr));
        pTmpBuf:=PSERVER_INFO_100(PChar(pTmpBuf)+SizeOf(SERVER_INFO_100));
      end;
      if Assigned(pBuf) then
        NetApiBufferFree(pBuf);
      if nStatus=ERROR_SUCCESS then
        Loop:=False;
      dwResumeHandle:=dwEntriesRead+1;
    end else
      Loop:=False;
  end;
end;

function GetServerTypeStr(AType: DWORD): string;
begin
  case AType of
    SV_TYPE_WORKSTATION: Result:='LAN Manager workstation';
    SV_TYPE_SERVER: Result:='LAN Manager server';
    SV_TYPE_SQLSERVER: Result:='Microsoft SQL Server';
    SV_TYPE_DOMAIN_CTRL: Result:='Primary domain controller';
    SV_TYPE_DOMAIN_BAKCTRL: Result:='Backup domain controller';
    SV_TYPE_TIMESOURCE: Result:='Server running the Timesource service';
    SV_TYPE_AFP: Result:='Apple File Protocol server';
    SV_TYPE_NOVELL: Result:='Novell server';
    SV_TYPE_DOMAIN_MEMBER: Result:='LAN Manager 2.x Domain Member';
    SV_TYPE_LOCAL_LIST_ONLY: Result:='Server maintained by the browser';
    SV_TYPE_PRINT: Result:='Server sharing print queue';
    SV_TYPE_DIALIN: Result:='Server running dial-in service';
    SV_TYPE_XENIX_SERVER: Result:='Xenix server';
    SV_TYPE_MFPN: Result:='Microsoft File and Print for Netware';
    SV_TYPE_NT: Result:='Windows NT (either Workstation or Server)';
    SV_TYPE_WFW: Result:='Server running Windows for Workgroups';
    SV_TYPE_SERVER_NT: Result:='Windows NT non-DC server';
    SV_TYPE_POTENTIAL_BROWSER: Result:='Server that can run the Browser service';
    SV_TYPE_BACKUP_BROWSER: Result:='Server running a Browser service as backup';
    SV_TYPE_MASTER_BROWSER: Result:='Server running the master Browser service';
    SV_TYPE_DOMAIN_MASTER: Result:='Server running the domain master Browser';
    SV_TYPE_DOMAIN_ENUM: Result:='Primary Domain';
    SV_TYPE_WINDOWS: Result:='Windows 95 or later';
  end;
end;

{ TNTServer }

constructor TNTServer.Create;
begin
  FTrans:=TStringList.Create;
end;

destructor TNTServer.Destroy;
begin
  FreeTransList(FTrans);
  FTrans.Free;
  inherited;
end;

procedure TNTServer.FreeTransList(var AList: TStringList);
begin
  while AList.Count>0 do begin
    dispose(PNTServerTransRecord(AList.Objects[AList.Count-1]));
    AList.Delete(AList.Count-1);
  end;
end;

function TNTServer.GetTrans(Index: DWORD): PNTServerTransRecord;
begin
  if Index<DWORD(FTrans.Count) then
    Result:=PNTServerTransRecord(FTrans.Objects[Index])
  else
    Result:=nil;
end;

function TNTServer.GetTransCount: DWORD;
begin
  Result:=FTrans.Count;
end;

procedure TNTServer.RefreshTrans;
begin
  RetrieveTrans(Machine);
end;

procedure TNTServer.RetrieveTrans(AMachine: string);
var
  pTmpBuf, pBuf: PSERVER_TRANSPORT_INFO_1;
  nStatus: NET_API_STATUS;
  i: DWORD;
  dwPrefMaxLen: DWORD;
  dwEntriesRead: DWORD;
  dwTotalEntries: DWORD;
  dwResumeHandle: DWORD;
  Loop: Boolean;
  Buf: array[0..256] of WideChar;
  pr: PNTServerTransRecord;
begin
  FreeTransList(FTrans);
  pBuf:=nil;
  Loop:=True;
  dwPrefMaxLen:=$FFFFFFFF;
  dwEntriesRead:=0;
  dwTotalEntries:=0;
  dwResumeHandle:=0;
  while Loop do begin
    nStatus:=NetServerTransportEnum(StringToWideChar(AMachine,Buf,256),0,
                               Pointer(pBuf),
                               dwPrefMaxLen, dwEntriesRead, dwTotalEntries, dwResumeHandle);
    if ((nStatus=ERROR_SUCCESS) or (nStatus=ERROR_MORE_DATA)) and (dwEntriesRead>0) then begin
      pTmpBuf:=pBuf;
      for i:=0 to dwEntriesRead-1 do begin
        new(pr);
        pr^.Name:=pTmpBuf^.svti1_transportname;
        pr^.Address:=pTmpBuf^.svti1_transportaddress^;
        pr^.AddrLength:=pTmpBuf^.svti1_transportaddresslength;
        pr^.VCSCount:=pTmpBuf^.svti1_numberofvcs;
        pr^.Domain:=pTmpBuf^.svti1_domain;
        pr^.NetAddress:=pTmpBuf^.svti1_networkaddress;

        FTrans.AddObject(pr^.Name,TObject(pr));
        pTmpBuf:=PSERVER_TRANSPORT_INFO_1(PChar(pTmpBuf)+SizeOf(SERVER_TRANSPORT_INFO_1));
      end;
      if Assigned(pBuf) then
        NetApiBufferFree(pBuf);
      if nStatus=ERROR_SUCCESS then
        Loop:=False;
      dwResumeHandle:=dwEntriesRead+1;
    end else
      Loop:=False;
  end;
end;

end.

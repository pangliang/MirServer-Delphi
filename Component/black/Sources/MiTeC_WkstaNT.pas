{*******************************************************}
{                                                       }
{       MiTeC System Information Component              }
{           Windows NT Workstation Info                 }
{           version 8.3 for Delphi 5,6,7                }
{                                                       }
{       Copyright © 1997,2003 Michal Mutl               }
{                                                       }
{*******************************************************}

{$INCLUDE MITEC_DEF.INC}

unit MiTeC_WkstaNT;

interface

uses Windows, Classes, SysUtils;

type
  PNTWkstaTransRecord = ^TNTWkstaTransRecord;
  TNTWkstaTransRecord = record
    Name: string;
    Address: string;
    Quality: DWORD;
    VCSCount: DWORD;
    IsWAN: Boolean;
  end;

  PNTWkstaUserRecord = ^TNTWkstaUserRecord;
  TNTWkstaUserRecord = record
    Name: string;
    Domain: string;
    Domains: string;
    Server: string;
  end;

  TNTWksta = class(TPersistent)
  private
    FTrans, FUsers: TStringList;
    FMachine: string;
    FMajor: DWORD;
    FMinor: DWORD;
    FPlatformId: DWORD;
    FDomain: string;
    FName: string;
    procedure RetrieveTrans(AMachine: string);
    procedure RetrieveUsers(AMachine: string);
    procedure RetrieveInfo(AMachine: string);
    function GetTrans(Index: DWORD): PNTWkstaTransRecord;
    function GetTransCount: DWORD;
    procedure FreeTransList(var AList: TStringList);
    procedure FreeUserList(var AList: TStringList);
    function GetUser(Index: DWORD): PNTWkstaUserRecord;
    function GetUserCount: DWORD;
  public
    constructor Create;
    destructor Destroy; override;

    procedure RefreshTrans;
    procedure RefreshUsers;
    procedure RefreshInfo;

    property Machine: string read FMachine write FMachine;
    property TransportCount: DWORD read GetTransCount;
    property Transports[Index: DWORD]: PNTWkstaTransRecord read GetTrans;
    property UserCount: DWORD read GetUserCount;
    property Users[Index: DWORD]: PNTWkstaUserRecord read GetUser;
    property MajorVersion: DWORD read FMajor;
    property MinorVersion: DWORD read FMinor;
    property PlatformId: DWORD read FPlatformId;
    property ComputerName: string read FName;
    property DomainName: string read FDomain;
  end;

implementation

uses MiTeC_Routines, MiTeC_NetAPI32;


{ TNTWksta }

constructor TNTWksta.Create;
begin
  FTrans:=TStringList.Create;
  FUsers:=TStringList.Create;
end;

destructor TNTWksta.Destroy;
begin
  FreeTransList(FTrans);
  FTrans.Free;
  FreeUserList(FUsers);
  FUsers.Free;
  inherited;
end;

procedure TNTWksta.FreeTransList(var AList: TStringList);
begin
  while AList.Count>0 do begin
    dispose(PNTWkstaTransRecord(AList.Objects[AList.Count-1]));
    AList.Delete(AList.Count-1);
  end;
end;

procedure TNTWksta.FreeUserList(var AList: TStringList);
begin
  while AList.Count>0 do begin
    dispose(PNTWkstaUserRecord(AList.Objects[AList.Count-1]));
    AList.Delete(AList.Count-1);
  end;
end;

function TNTWksta.GetTrans(Index: DWORD): PNTWkstaTransRecord;
begin
  if Index<DWORD(FTrans.Count) then
    Result:=PNTWkstaTransRecord(FTrans.Objects[Index])
  else
    Result:=nil;
end;

function TNTWksta.GetTransCount: DWORD;
begin
  Result:=FTrans.Count;
end;

function TNTWksta.GetUser(Index: DWORD): PNTWkstaUserRecord;
begin
  if Index<DWORD(FUsers.Count) then
    Result:=PNTWkstaUserRecord(FUsers.Objects[Index])
  else
    Result:=nil;
end;

function TNTWksta.GetUserCount: DWORD;
begin
  Result:=FUsers.Count;
end;

procedure TNTWksta.RefreshInfo;
begin
  RetrieveInfo(Machine);
end;

procedure TNTWksta.RefreshTrans;
begin
  RetrieveTrans(Machine);
end;

procedure TNTWksta.RefreshUsers;
begin
  RetrieveUsers(Machine);
end;

procedure TNTWksta.RetrieveInfo(AMachine: string);
var
  pBuf: PWKSTA_INFO_100;
  nStatus: NET_API_STATUS;
  Buf: array[0..256] of WideChar;
begin
  pBuf:=nil;
  nStatus:=NetWkstaGetInfo(StringToWideChar(AMachine,Buf,256),101,Pointer(pBuf));
  if (nStatus=ERROR_SUCCESS) then begin
    FName:=WideCharToString(pBuf^.wksi100_computername);
    FDomain:=WideCharToString(pBuf^.wksi100_langroup);
    FMajor:=pBuf^.wksi100_ver_major;
    FMinor:=pBuf^.wksi100_ver_minor;
    FPlatformId:=pBuf^.wksi100_platform_id;
  end;
  if Assigned(pBuf) then
    NetApiBufferFree(pBuf);
end;

procedure TNTWksta.RetrieveTrans(AMachine: string);
var
  pTmpBuf, pBuf: PWKSTA_TRANSPORT_INFO_0;
  nStatus: NET_API_STATUS;
  i: DWORD;
  dwPrefMaxLen: DWORD;
  dwEntriesRead: DWORD;
  dwTotalEntries: DWORD;
  dwResumeHandle: DWORD;
  Loop: Boolean;
  Buf: array[0..256] of WideChar;
  pr: PNTWkstaTransRecord;
begin
  FreeTransList(FTrans);
  pBuf:=nil;
  Loop:=True;
  dwPrefMaxLen:=$FFFFFFFF;
  dwEntriesRead:=0;
  dwTotalEntries:=0;
  dwResumeHandle:=0;
  while Loop do begin
    nStatus:=NetWkstaTransportEnum(StringToWideChar(AMachine,Buf,256),0,
                               Pointer(pBuf),
                               dwPrefMaxLen, dwEntriesRead, dwTotalEntries, dwResumeHandle);
    if ((nStatus=ERROR_SUCCESS) or (nStatus=ERROR_MORE_DATA)) and (dwEntriesRead>0) then begin
      pTmpBuf:=pBuf;
      for i:=0 to dwEntriesRead-1 do begin
        new(pr);
        pr^.Name:=WideCharToString(pTmpBuf^.wkti0_transport_name);
        pr^.Address:=WideCharToString(pTmpBuf^.wkti0_transport_address);
        pr^.Quality:=pTmpBuf^.wkti0_quality_of_service;
        pr^.VCSCount:=pTmpBuf^.wkti0_number_of_vcs;
        pr^.IsWAN:=pTmpBuf^.wkti0_wan_ish;

        FTrans.AddObject(pr^.Name,TObject(pr));
        pTmpBuf:=PWKSTA_TRANSPORT_INFO_0(PChar(pTmpBuf)+SizeOf(WKSTA_TRANSPORT_INFO_0));
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

procedure TNTWksta.RetrieveUsers(AMachine: string);
var
  pTmpBuf, pBuf: PWKSTA_USER_INFO_1;
  nStatus: NET_API_STATUS;
  i: DWORD;
  dwPrefMaxLen: DWORD;
  dwEntriesRead: DWORD;
  dwTotalEntries: DWORD;
  dwResumeHandle: DWORD;
  Loop: Boolean;
  Buf: array[0..256] of WideChar;
  pr: PNTWkstaUserRecord;
begin
  FreeUserList(FUsers);
  pBuf:=nil;
  Loop:=True;
  dwPrefMaxLen:=$FFFFFFFF;
  dwEntriesRead:=0;
  dwTotalEntries:=0;
  dwResumeHandle:=0;
  while Loop do begin
    nStatus:=NetWkstaUserEnum(StringToWideChar(AMachine,Buf,256),1,
                               Pointer(pBuf),
                               dwPrefMaxLen, dwEntriesRead, dwTotalEntries, dwResumeHandle);
    if ((nStatus=ERROR_SUCCESS) or (nStatus=ERROR_MORE_DATA)) and (dwEntriesRead>0) then begin
      pTmpBuf:=pBuf;
      for i:=0 to dwEntriesRead-1 do begin
        new(pr);
        pr^.Name:=WideCharToString(pTmpBuf^.wkui1_username);
        try
          pr^.Domain:=WideCharToString(pTmpBuf^.wkui1_logon_domain);
          pr^.Server:=WideCharToString(pTmpBuf^.wkui1_logon_server);
          pr^.Domains:=WideCharToString(pTmpBuf^.wkui1_oth_domains);
        except
        end;
        FUsers.AddObject(pr^.Name,TObject(pr));
        pTmpBuf:=PWKSTA_USER_INFO_1(PChar(pTmpBuf)+SizeOf(WKSTA_USER_INFO_1));
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

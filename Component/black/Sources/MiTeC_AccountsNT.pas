{*******************************************************}
{                                                       }
{       MiTeC System Information Component              }
{         Windows NT User and Group Enumeration         }
{           version 8.6 for Delphi 5,6,7                }
{                                                       }
{       Copyright © 1997,2004 Michal Mutl               }
{                                                       }
{*******************************************************}

{$INCLUDE MITEC_DEF.INC}

unit MiTeC_AccountsNT;

interface

uses Windows, Classes, SysUtils;

type
  PUserInfo = ^TUserInfo;
  TUserInfo = record
    Name: string;
    Comment: string;
    Sid: string;
    NumberOfSubAuths: DWORD;
    SidLength: DWORD;
    Domain: string;
    SidType: DWORD;
    FullName: string;
    LastLogon: TDateTime;
    LastLogoff: TDateTime;
    LogonCount: DWORD;
  end;

  PGroupInfo = ^TGroupInfo;
  TGroupInfo = record
    Name: string;
    Comment: string;

    Sid: string;
    NumberOfSubAuths: DWORD;
    SidLength: DWORD;
    Domain: string;
    SidType: DWORD;
  end;

  TAccounts = class(TPersistent)
  private
    FUsers, FLocalGroups, FGlobalGroups: TStringList;
    FMachine: string;

    procedure FreeUserList(var AList: TStringList);
    procedure FreeGroupList(var AList: TStringList);

    function GetLocalGroup(Index: DWORD): PGroupInfo;
    function GetUser(Index: DWORD): PUserInfo;
    function GetUserCount: DWORD;
    function GetLocalGroupCount: DWORD;
    function GetGlobalGroup(Index: DWORD): PGroupInfo;
    function GetGlobalGroupCount: DWORD;

    procedure RetrieveUsers(AMachine: string);
    procedure RetrieveLocalGroups(AMachine: string);
    procedure RetrieveGlobalGroups(AMachine: string);

    function GetSIDFromAccount(AMachine, AName: string; var Domain: string; var SidLen,SubAuthCount,NameUse: DWORD): string;

  public
    constructor Create;
    destructor Destroy; override;

    procedure RefreshUsers;
    procedure RefreshLocalGroups;
    procedure RefreshGlobalGroups;

    procedure GetUserLocalGroups(AMachine, AUsername: string; var AList: TStringList);
    procedure GetLocalGroupUsers(AMachine, AGroupname: string; var AList: TStringList);
    procedure GetUserGlobalGroups(AMachine, AUsername: string; var AList: TStringList);
    procedure GetGlobalGroupUsers(AMachine, AGroupname: string; var AList: TStringList);

    property Machine: string read FMachine write FMachine;

    property UserCount: DWORD read GetUserCount;
    property Users[Index: DWORD]: PUserInfo read GetUser;

    property LocalGroupCount: DWORD read GetLocalGroupCount;
    property LocalGroups[Index: DWORD]: PGroupInfo read GetLocalGroup;

    property GlobalGroupCount: DWORD read GetGlobalGroupCount;
    property GlobalGroups[Index: DWORD]: PGroupInfo read GetGlobalGroup;
  end;

function GetNameUseStr(Value: DWORD): string;
function ConvertSIDToStringSID(ASID: PChar): string;

implementation

uses MiTeC_NetAPI32, MiTeC_Routines, MiTeC_Datetime;

function ConvertSIDToStringSID(ASID: PChar): string;
var
  i: integer;
  SIDAuth: PSIDIdentifierAuthority;
  SIDSubAuth: DWORD;
  SIDSubAuthCount: Byte;
begin
  Result:='S-1-';
  SIDAuth:=GetSidIdentifierAuthority(ASID);
  for i:=0 to 5 do
    if SIDAuth.Value[i]<>0 then
      Result:=Result+Format('%d%',[SIDAuth.Value[i]]);
  SIDSubAuthCount:=GetSidSubAuthorityCount(ASID)^;
  for i:=0 to SIDSubAuthCount-1 do begin
    SIDSubAuth:=GetSidSubAuthority(ASID,i)^;
    Result:=Result+'-'+Format('%d',[SIDSubAuth]);
  end;
end;

function GetNameUseStr(Value: DWORD): string;
begin
  case Value of
    SidTypeUser: Result:='SidTypeUser';
    SidTypeGroup: Result:='SidTypeGroup';
    SidTypeDomain: Result:='SidTypeDomain';
    SidTypeAlias: Result:='SidTypeAlias';
    SidTypeWellKnownGroup: Result:='SidTypeWellKnownGroup';
    SidTypeDeletedAccount: Result:='SidTypeDeletedAccount';
    SidTypeInvalid: Result:='SidTypeInvalid';
    SidTypeUnknown: Result:='SidTypeUnknown';
    9: Result:='SidTypeComputer';
  end;
end;

{ TAccounts }

constructor TAccounts.Create;
begin
  FUsers:=TStringList.Create;
  FLocalGroups:=TStringList.Create;
  FGlobalGroups:=TStringList.Create;
  InitNETAPI;
end;

destructor TAccounts.Destroy;
begin
  FreeUserList(FUsers);
  FUsers.Free;
  FreeGroupList(FLocalGroups);
  FLocalGroups.Free;
  FreeGroupList(FGlobalGroups);
  FGlobalGroups.Free;
  inherited;
end;

procedure TAccounts.FreeGroupList(var AList: TStringList);
begin
  while AList.Count>0 do begin
    dispose(PGroupInfo(AList.Objects[AList.Count-1]));
    AList.Delete(AList.Count-1);
  end;
end;

procedure TAccounts.FreeUserList(var AList: TStringList);
begin
  while AList.Count>0 do begin
    dispose(PUserInfo(AList.Objects[AList.Count-1]));
    AList.Delete(AList.Count-1);
  end;
end;

function TAccounts.GetGlobalGroup(Index: DWORD): PGroupInfo;
begin
  if Index<DWORD(FGlobalGroups.Count) then
    Result:=PGroupInfo(FGlobalGroups.Objects[Index])
  else
    Result:=nil;
end;

function TAccounts.GetGlobalGroupCount: DWORD;
begin
  Result:=FGlobalGroups.Count;
end;

procedure TAccounts.GetGlobalGroupUsers(AMachine, AGroupname: string;
  var AList: TStringList);
var
  i: DWORD;
  nStatus: NET_API_STATUS;
  Buf1,Buf2: array[0..256] of WideChar;
  pTmpBuf,pBuf: PGROUP_USERS_INFO_0;
  Loop: Boolean;
  dwLevel: DWORD;
  dwPrefMaxLen: DWORD;
  dwEntriesRead: DWORD;
  dwTotalEntries: DWORD;
  dwResumeHandle: DWORD;
begin
  AList.Clear;
  pBuf:=nil;
  Loop:=True;
  dwLevel:=0;
  dwPrefMaxLen:=$FFFFFFFF;
  dwEntriesRead:=0;
  dwTotalEntries:=0;
  dwResumeHandle:=0;
  while Loop do begin
    nStatus:=NetGroupGetUsers(StringToWideChar(AMachine,Buf1,256),
                              StringToWideChar(AGroupname,Buf2,256),
                              dwLevel, Pointer(pBuf),
                              dwPrefMaxLen, dwEntriesRead, dwTotalEntries,
                              dwResumeHandle);
    if ((nStatus=ERROR_SUCCESS) or (nStatus=ERROR_MORE_DATA)) and (dwEntriesRead>0) then begin
      pTmpBuf:=pBuf;
      for i:=0 to dwEntriesRead-1 do begin
        AList.Add(WideCharToString(pTmpBuf.grui0_name));
        pTmpBuf:=PGROUP_USERS_INFO_0(PChar(pTmpBuf)+SizeOf(GROUP_USERS_INFO_0));
      end;
      if Assigned(pBuf) then begin
        NetApiBufferFree(pBuf);
        pBuf:=nil;
      end;
      if nStatus=ERROR_SUCCESS then
        Loop:=False;
      dwResumeHandle:=dwEntriesRead+1;
    end else
      Loop:=False;
  end;
  if Assigned(pBuf) then
    NetApiBufferFree(pBuf);
end;

function TAccounts.GetLocalGroup(Index: DWORD): PGroupInfo;
begin
  if Index<DWORD(FLocalGroups.Count) then
    Result:=PGroupInfo(FLocalGroups.Objects[Index])
  else
    Result:=nil;
end;

function TAccounts.GetLocalGroupCount: DWORD;
begin
  Result:=FLocalGroups.Count;
end;

procedure TAccounts.GetLocalGroupUsers;
var
  i: DWORD;
  nStatus: NET_API_STATUS;
  Buf1,Buf2: array[0..256] of WideChar;
  pTmpBuf,pBuf: PLOCALGROUP_MEMBERS_INFO_3;
  Loop: Boolean;
  dwLevel: DWORD;
  dwPrefMaxLen: DWORD;
  dwEntriesRead: DWORD;
  dwTotalEntries: DWORD;
  dwResumeHandle: DWORD;
begin
  AList.Clear;
  pBuf:=nil;
  Loop:=True;
  dwLevel:=3;
  dwPrefMaxLen:=$FFFFFFFF;
  dwEntriesRead:=0;
  dwTotalEntries:=0;
  dwResumeHandle:=0;
  while Loop do begin
    nStatus:=NetLocalGroupGetMembers(StringToWideChar(AMachine,Buf1,256),
                              StringToWideChar(AGroupname,Buf2,256),
                              dwLevel, Pointer(pBuf),
                              dwPrefMaxLen, dwEntriesRead, dwTotalEntries,
                              dwResumeHandle);
    if ((nStatus=ERROR_SUCCESS) or (nStatus=ERROR_MORE_DATA)) and (dwEntriesRead>0) then begin
      pTmpBuf:=pBuf;
      for i:=0 to dwEntriesRead-1 do begin
        AList.Add(WideCharToString(pTmpBuf.lgrmi3_domainandname));
        pTmpBuf:=PLOCALGROUP_MEMBERS_INFO_3(PChar(pTmpBuf)+SizeOf(LOCALGROUP_MEMBERS_INFO_3));
      end;
      if Assigned(pBuf) then begin
        NetApiBufferFree(pBuf);
        pBuf:=nil;
      end;
      if nStatus=ERROR_SUCCESS then
        Loop:=False;
      dwResumeHandle:=dwEntriesRead+1;
    end else
      Loop:=False;
  end;
  if Assigned(pBuf) then
    NetApiBufferFree(pBuf);
end;

function TAccounts.GetSIDFromAccount(AMachine,AName: string; var Domain: string;
  var SidLen, SubAuthCount, NameUse: DWORD): string;
var
  SID: PChar;
  szDomain: PChar;
  cbDomain, cbSID: DWORD;
begin
  cbDomain:=1;
  szDomain:=AllocMem(cbDomain);
  cbSID:=1;
  SID:=AllocMem(cbSID);
  LookupAccountName(PChar(AMachine),PChar(AName),SID,cbSID,szDomain,cbDomain,NameUse);
  ReAllocMem(szDomain,cbDomain);
  ReAllocMem(SID,cbSID);
  if LookupAccountName(PChar(AMachine),PChar(AName),SID,cbSID,szDomain,cbDomain,NameUse) then begin
    Result:=ConvertSIDToStringSID(SID);
    SubAuthCount:=GetSidSubAuthorityCount(SID)^;
    SidLen:=GetLengthSid(SID);
    Domain:=StrPas(szDomain);
  end else
    Result:=GetErrorMessage(GetLastError);
  FreeMem(szDomain);
  FreeMem(SID);
end;

function TAccounts.GetUser(Index: DWORD): PUserInfo;
begin
  if Index<DWORD(FUsers.Count) then
    Result:=PUserInfo(FUsers.Objects[Index])
  else
    Result:=nil;
end;

function TAccounts.GetUserCount: DWORD;
begin
  Result:=FUsers.Count;
end;

procedure TAccounts.GetUserGlobalGroups(AMachine, AUsername: string;
  var AList: TStringList);
var
  i: DWORD;
  nStatus: NET_API_STATUS;
  Buf1,Buf2: array[0..256] of WideChar;
  pTmpBuf,pBuf: PGROUP_USERS_INFO_0;
  dwLevel: DWORD;
  dwPrefMaxLen: DWORD;
  dwEntriesRead: DWORD;
  dwTotalEntries: DWORD;
begin
  AList.Clear;
  pBuf:=nil;
  dwLevel:=0;
  dwPrefMaxLen:=$FFFFFFFF;
  dwEntriesRead:=0;
  dwTotalEntries:=0;
  nStatus:=NetUserGetGroups(StringToWideChar(AMachine,Buf1,256),
                          StringToWideChar(AUsername,Buf2,256),
                         dwLevel, Pointer(pBuf),
                         dwPrefMaxLen, dwEntriesRead, dwTotalEntries);
  if ((nStatus=ERROR_SUCCESS) or (nStatus=ERROR_MORE_DATA)) and (dwEntriesRead>0) then begin
    pTmpBuf:=pBuf;
    for i:=0 to dwEntriesRead-1 do begin
      AList.Add(WideCharToString(pTmpBuf.grui0_name));
      pTmpBuf:=PGROUP_USERS_INFO_0(PChar(pTmpBuf)+SizeOf(GROUP_USERS_INFO_0));
    end;
  end;
  if Assigned(pBuf) then
      NetApiBufferFree(pBuf);
end;

procedure TAccounts.GetUserLocalGroups;
var
  i: DWORD;
  nStatus: NET_API_STATUS;
  Buf1,Buf2: array[0..256] of WideChar;
  pTmpBuf,pBuf: PLOCALGROUP_USERS_INFO_0;
  dwLevel: DWORD;
  dwPrefMaxLen: DWORD;
  dwEntriesRead: DWORD;
  dwTotalEntries: DWORD;
begin
  AList.Clear;
  pBuf:=nil;
  dwLevel:=0;
  dwPrefMaxLen:=$FFFFFFFF;
  dwEntriesRead:=0;
  dwTotalEntries:=0;
  nStatus:=NetUserGetLocalGroups(StringToWideChar(AMachine,Buf1,256),
                          StringToWideChar(AUsername,Buf2,256),
                         dwLevel, LG_INCLUDE_INDIRECT, Pointer(pBuf),
                         dwPrefMaxLen, dwEntriesRead, dwTotalEntries);
  if ((nStatus=ERROR_SUCCESS) or (nStatus=ERROR_MORE_DATA)) and (dwEntriesRead>0) then begin
    pTmpBuf:=pBuf;
    for i:=0 to dwEntriesRead-1 do begin
      AList.Add(WideCharToString(pTmpBuf.lgrui0_name));
      pTmpBuf:=PLOCALGROUP_USERS_INFO_0(PChar(pTmpBuf)+SizeOf(LOCALGROUP_USERS_INFO_0));
    end;
  end;
  if Assigned(pBuf) then
      NetApiBufferFree(pBuf);
end;

procedure TAccounts.RefreshGlobalGroups;
begin
  RetrieveGlobalGroups(Machine);
end;

procedure TAccounts.RefreshLocalGroups;
begin
  RetrieveLocalGroups(Machine);
end;

procedure TAccounts.RefreshUsers;
begin
  RetrieveUsers(Machine);
end;

procedure TAccounts.RetrieveGlobalGroups(AMachine: string);
var
  i: DWORD;
  nStatus: NET_API_STATUS;
  pgi: PGroupInfo;
  pTmpBuf,pBuf: PGROUP_INFO_2;
  Loop: Boolean;
  dwLevel: DWORD;
  dwPrefMaxLen: DWORD;
  dwEntriesRead: DWORD;
  dwTotalEntries: DWORD;
  dwResumeHandle: DWORD;
begin
  FreeGroupList(FGlobalGroups);
  pBuf:=nil;
  Loop:=True;
  dwLevel:=2;
  dwPrefMaxLen:=$FFFFFFFF;
  dwEntriesRead:=0;
  dwTotalEntries:=0;
  dwResumeHandle:=0;
  while Loop do begin
    nStatus:=NetGroupEnum(nil{StringToWideChar(AMachine,Buffer,256)},
                         dwLevel, Pointer(pBuf),
                         dwPrefMaxLen, dwEntriesRead, dwTotalEntries, dwResumeHandle);
    if (nStatus=ERROR_SUCCESS) or (nStatus=ERROR_MORE_DATA) then begin
      pTmpBuf:=pBuf;
      for i:=0 to dwEntriesRead-1 do begin
        new(pgi);
        with pTmpBuf^ do begin
          pgi^.Name:=WideCharToString(grpi2_name);
          pgi^.Comment:=WideCharToString(grpi2_comment);
          pgi^.Sid:=GetSIDFromAccount(AMachine,pgi^.Name,pgi^.Domain,pgi^.SidLength,pgi^.NumberOfSubAuths,pgi^.SidType);
          FGlobalGroups.AddObject(pgi^.Name,TObject(pgi));
          pTmpBuf:=PGROUP_INFO_2(PChar(pTmpBuf)+SizeOf(GROUP_INFO_2));
        end;
      end;
      if Assigned(pBuf) then begin
        NetApiBufferFree(pBuf);
        pBuf:=nil;
      end;
      if nStatus=ERROR_SUCCESS then
        Loop:=False;
      dwResumeHandle:=dwEntriesRead+1;
    end else
      Loop:=False;
  end;
  if Assigned(pBuf) then
    NetApiBufferFree(pBuf);
end;

procedure TAccounts.RetrieveLocalGroups;
var
  i: DWORD;
  nStatus: NET_API_STATUS;
  pgi: PGroupInfo;
  pTmpBuf,pBuf: PLOCALGROUP_INFO_1;
  Loop: Boolean;
  dwLevel: DWORD;
  dwPrefMaxLen: DWORD;
  dwEntriesRead: DWORD;
  dwTotalEntries: DWORD;
  dwResumeHandle: DWORD;
begin
  FreeGroupList(FLocalGroups);
  pBuf:=nil;
  Loop:=True;
  dwLevel:=1;
  dwPrefMaxLen:=$FFFFFFFF;
  dwEntriesRead:=0;
  dwTotalEntries:=0;
  dwResumeHandle:=0;
  while Loop do begin
    nStatus:=NetLocalGroupEnum(nil{StringToWideChar(AMachine,Buffer,256)},
                         dwLevel, Pointer(pBuf),
                         dwPrefMaxLen, dwEntriesRead, dwTotalEntries, dwResumeHandle);
    if (nStatus=ERROR_SUCCESS) or (nStatus=ERROR_MORE_DATA) then begin
      pTmpBuf:=pBuf;
      for i:=0 to dwEntriesRead-1 do begin
        new(pgi);
        with pTmpBuf^ do begin
          pgi^.Name:=WideCharToString(lgrpi1_name);
          pgi^.Comment:=WideCharToString(lgrpi1_comment);
          pgi^.Sid:=GetSIDFromAccount(AMachine,pgi^.Name,pgi^.Domain,pgi^.SidLength,pgi^.NumberOfSubAuths,pgi^.SidType);
          FLocalGroups.AddObject(pgi^.Name,TObject(pgi));
          pTmpBuf:=PLOCALGROUP_INFO_1(PChar(pTmpBuf)+SizeOf(LOCALGROUP_INFO_1));
        end;
      end;
      if Assigned(pBuf) then begin
        NetApiBufferFree(pBuf);
        pBuf:=nil;
      end;
      if nStatus=ERROR_SUCCESS then
        Loop:=False;
      dwResumeHandle:=dwEntriesRead+1;
    end else
      Loop:=False;
  end;
  if Assigned(pBuf) then
    NetApiBufferFree(pBuf);
end;

procedure TAccounts.RetrieveUsers;
var
  i: DWORD;
  nStatus: NET_API_STATUS;
  pui: PUserInfo;
  pTmpBuf,pBuf: PUSER_INFO_11;
  Loop: Boolean;
  dwLevel: DWORD;
  dwPrefMaxLen: DWORD;
  dwEntriesRead: DWORD;
  dwTotalEntries: DWORD;
  dwResumeHandle: DWORD;
begin
  FreeUserList(FUsers);
  pBuf:=nil;
  Loop:=True;
  dwLevel:=11;
  dwPrefMaxLen:=$FFFFFFFF;
  dwEntriesRead:=0;
  dwTotalEntries:=0;
  dwResumeHandle:=0;
  while Loop do begin
    nStatus:=NetUserEnum(nil{StringToWideChar(AMachine,Buffer,256)},
                         dwLevel, FILTER_NORMAL_ACCOUNT, Pointer(pBuf),
                         dwPrefMaxLen, dwEntriesRead, dwTotalEntries, dwResumeHandle);
    if (nStatus=ERROR_SUCCESS) or (nStatus=ERROR_MORE_DATA) then begin
      pTmpBuf:=pBuf;
      for i:=0 to dwEntriesRead-1 do begin
        new(pui);
        with pTmpBuf^ do begin
          pui^.Name:=WideCharToString(usri11_name);
          pui^.FullName:=WideCharToString(usri11_full_name);
          pui^.Comment:=WideCharToString(usri11_comment);
          pui^.LastLogon:=UTCToDateTime(pTmpBuf^.usri11_last_logon);
          pui^.LastLogoff:=UTCToDateTime(pTmpBuf^.usri11_last_logoff);
          pui^.LogonCount:=pTmpBuf^.usri11_num_logons;
          pui^.Sid:=GetSIDFromAccount(AMachine,pui^.Name,pui^.Domain,pui^.SidLength,pui^.NumberOfSubAuths,pui^.SidType);
          FUsers.AddObject(pui^.Name,TObject(pui));
          pTmpBuf:=PUSER_INFO_11(PChar(pTmpBuf)+SizeOf(USER_INFO_11));
        end;
      end;
      if Assigned(pBuf) then begin
        NetApiBufferFree(pBuf);
        pBuf:=nil;
      end;
      if nStatus=ERROR_SUCCESS then
        Loop:=False;
      dwResumeHandle:=dwEntriesRead+1;
    end else
      Loop:=False;
  end;
  if Assigned(pBuf) then
    NetApiBufferFree(pBuf);
end;

end.

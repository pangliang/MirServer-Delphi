{*******************************************************}
{                                                       }
{       MiTeC System Information Component              }
{             Sharepoints Enumeration                   }
{           version 8.6.4 for Delphi 5,6                }
{                                                       }
{       Copyright © 1997,2003 Michal Mutl               }
{                                                       }
{*******************************************************}

{$INCLUDE MITEC_DEF.INC}


unit MiTeC_Shares;

interface

uses Windows, Classes, SysUtils;

const
  MAX_ENTRIES = 20;

type
  TShareType = (stDisk, stPrnQue, stCommDev, stIPC, stSpecial);

  TPermission = (pmRead, pmWrite, pmCreate, pmExec, pmDelete, pmAttrib, pmPerm);
  TPermissions = set of TPermission;

  POpenFileRecord = ^TOpenFileRecord;
  TOpenFileRecord = record
    Name,
    UserName,
    Sharename: string;
    Locks: DWORD;
    Mode: TPermission;
    ID: DWORD;
  end;

  PConnectionRecord = ^TConnectionRecord;
  TConnectionRecord = record
    Name: string;
    UserName: string;
    ID: DWORD;
    ConnType: TShareType;
    Time: DWORD;
    OpenFiles: DWORD;
    Users: DWORD;
  end;

  TConnections = class(TPersistent)
  private
    FConns: TStringList;
    FMachine: string;
    FQualifier: string;
    procedure RetrieveNT(AMachine, AQualifier: string);
    procedure Retrieve9x(AMachine, AQualifier: string);
    function GetConn(Index: DWORD): PConnectionRecord;
    function GetConnCount: DWORD;
    procedure FreeList(var AList: TStringList);
    procedure SetMachine(const Value: string);
  public
    constructor Create;
    destructor Destroy; override;

    procedure Refresh;

    property Machine: string read FMachine Write SetMachine;
    property Qualifier: string read FQualifier write FQualifier;
    property ConnectionCount: DWORD read GetConnCount;
    property Connections[Index: DWORD]: PConnectionRecord read GetConn;
  end;

  PNTShareRecord = ^TNTShareRecord;
  TNTShareRecord = record
    Name: string;
    ShareType: TShareType;
    Comment: string;
    Permissions: TPermissions;
    MaxUserCount: DWORD;
    CurUserCount: DWORD;
    Path: string;
    Password: string;
    SecurityDesc: Boolean;
  end;

  PNTSessionRecord = ^TNTSessionRecord;
  TNTSessionRecord = record
    Name: string;
    UserName: string;
    SesiType: string;
    OpenFiles: DWORD;
    ConnectedTime: DWORD;
    IdleTime: DWORD;
    Guest: Boolean;
    Transport: string;
  end;

  TNTShares = class(TPersistent)
  private
    FShares, FSessions, FOpenFiles: TStringList;
    FMachine: string;
    function GetShareCount: DWORD;
    function GetShare(Index: DWORD): PNTShareRecord;
    function GetOpenFile(Index: DWORD): POpenFileRecord;
    function GetOpenFileCount: DWORD;
    function GetSession(Index: DWORD): PNTSessionRecord;
    function GetSessionCount: DWORD;

    procedure RetrieveShares(AMachine: string);
    procedure RetrieveSessions(AMachine: string);
    procedure RetrieveOpenFiles(AMachine: string);

    procedure FreeShareList(var AList: TStringList);
    procedure FreeSessionList(var AList: TStringList);
    procedure FreeOpenFileList(var AList: TStringList);
    procedure SetMachine(const Value: string);
  public
    constructor Create;
    destructor Destroy; override;

    procedure RefreshShares;
    procedure RefreshSessions;
    procedure RefreshOpenFiles;

    property Machine: string read FMachine Write SetMachine;
    property ShareCount: DWORD read GetShareCount;
    property Shares[Index: DWORD]: PNTShareRecord read GetShare;

    property SessionCount: DWORD read GetSessionCount;
    property Sessions[Index: DWORD]: PNTSessionRecord read GetSession;

    property OpenFileCount: DWORD read GetOpenFileCount;
    property OpenFiles[Index: DWORD]: POpenFileRecord read GetOpenFile;
  end;

type
  P9xShareRecord = ^T9xShareRecord;
  T9xShareRecord = record
    Name: string;
    ShareType: TShareType;
    Path: string;
    Comment: string;
  end;

  T9xShares = class(TPersistent)
  private
    FShares, FSessions, FOpenFiles: TStringList;
    FMachine: string;
    function GetShareCount: DWORD;
    function GetShare(Index: DWORD): P9xShareRecord;
    procedure RetrieveShares(AScope: DWORD; ANetResource: PNetResource; AMachine: string; var AList: TStringList);
    procedure RetrieveOpenFiles(AMachine: string);
    procedure FreeShareList(var AList: TStringList);
    procedure FreeOpenFileList(var AList: TStringList);
    function GetSession(Index: DWORD): P9xShareRecord;
    function GetSessionCount: DWORD;
    function GetOpenFile(Index: DWORD): POpenFileRecord;
    function GetOpenFileCount: DWORD;
    procedure SetMachine(const Value: string);
  public
    constructor Create;
    destructor Destroy; override;

    procedure RefreshShares;
    procedure RefreshSessions;
    procedure RefreshOpenFiles;

    property Machine: string read FMachine Write SetMachine;
    property ShareCount: DWORD read GetShareCount;
    property Shares[Index: DWORD]: P9xShareRecord read GetShare;

    property SessionCount: DWORD read GetSessionCount;
    property Sessions[Index: DWORD]: P9xShareRecord read GetSession;

    property OpenFileCount: DWORD read GetOpenFileCount;
    property OpenFiles[Index: DWORD]: POpenFileRecord read GetOpenFile;
  end;

function GetPermissionStr(AValue: TPermissions): string;

const
  ShareTypes : array[TShareType] of string =
    ('Folder','Print','Comm','IPC','Special');

implementation

uses MiTeC_Routines, MiTeC_NetAPI32, MiTeC_SvrAPI;

function GetPermissionStr(AValue: TPermissions): string;
begin
  Result:='-------';
  if pmRead in AValue then
    Result[1]:='R';
  if pmWrite in AValue then
    Result[2]:='W';
  if pmCreate in AValue then
    Result[3]:='C';
  if pmExec in AValue then
    Result[4]:='X';
  if pmDelete in AValue then
    Result[5]:='D';
  if pmAttrib in AValue then
    Result[6]:='A';
  if pmPerm in AValue then
    Result[7]:='P';
end;

{ TNTShares }

constructor TNTShares.Create;
begin
  FShares:=TStringList.Create;
  FSessions:=TStringList.Create;
  FOpenFiles:=TStringList.Create;
  Machine:=Machinename;
end;

destructor TNTShares.Destroy;
begin
  FreeShareList(FShares);
  FShares.Free;
  FreeSessionList(FSessions);
  FSessions.Free;
  FreeOpenFileList(FOpenFiles);
  FOpenFiles.Free;
  inherited;
end;

procedure TNTShares.FreeShareList(var AList: TStringList);
begin
  while AList.Count>0 do begin
    dispose(PNTShareRecord(AList.Objects[AList.Count-1]));
    AList.Delete(AList.Count-1);
  end;
end;

function TNTShares.GetShareCount: DWORD;
begin
  Result:=FShares.Count;
end;

function TNTShares.GetShare(Index: DWORD): PNTShareRecord;
begin
  if Index<DWORD(FShares.Count) then
    Result:=PNTShareRecord(FShares.Objects[Index])
  else
    Result:=nil;
end;

procedure TNTShares.RefreshShares;
begin
  RetrieveShares(Machine)
end;

procedure TNTShares.RetrieveShares(AMachine: string);
var
  pTmpBuf, pBuf: PSHARE_INFO_502;
  nStatus: NET_API_STATUS;
  i: DWORD;
  dwPrefMaxLen: DWORD;
  dwEntriesRead: DWORD;
  dwTotalEntries: DWORD;
  dwResumeHandle: DWORD;
  psr: PNTShareRecord;
  Loop: Boolean;
  Buffer: array[0..256] of WideChar;
begin
  FreeShareList(FShares);
  pBuf:=nil;
  Loop:=True;
  dwPrefMaxLen:=$FFFFFFFF;
  dwEntriesRead:=0;
  dwTotalEntries:=0;
  dwResumeHandle:=0;
  while Loop do begin
    nStatus:=MiTeC_NetAPI32.NetShareEnum(StringToWideChar(AMachine,Buffer,256),502,
                          Pointer(pBuf),
                          dwPrefMaxLen, dwEntriesRead, dwTotalEntries, dwResumeHandle);
    if (nStatus=ERROR_SUCCESS) or (nStatus=ERROR_MORE_DATA) then begin
      pTmpBuf:=pBuf;
      for i:=0 to dwEntriesRead-1 do begin
        new(psr);
        with pTmpBuf^ do begin
          psr^.Name:=WideCharToString(shi502_netname);
          psr^.Path:=WideCharToString(shi502_path);
          psr^.Comment:=WideCharToString(shi502_remark);
          psr^.CurUserCount:=shi502_current_uses;
          psr^.MaxUserCount:=shi502_max_uses;
          psr^.SecurityDesc:=(IsValidSecurityDescriptor(shi502_security_descriptor));
          if Assigned(shi502_passwd) then
            psr^.Password:=WideCharToString(shi502_passwd);
          case shi502_type and $0000000f of
            STYPE_DISKTREE: psr^.ShareType:=stDisk;
            STYPE_PRINTQ: psr^.ShareType:=stPrnQue;
            STYPE_DEVICE: psr^.ShareType:=stCommDev;
            STYPE_IPC: psr^.ShareType:=stIPC;
            STYPE_SPECIAL: psr^.ShareType:=stSpecial;
          end;
          psr^.Permissions:=[];
          if shi502_permissions and ACCESS_READ = ACCESS_READ then
            psr^.Permissions:=psr^.Permissions+[pmRead];
          if shi502_permissions and ACCESS_WRITE = ACCESS_WRITE then
            psr^.Permissions:=psr^.Permissions+[pmWrite];
          if shi502_permissions and ACCESS_CREATE = ACCESS_CREATE then
            psr^.Permissions:=psr^.Permissions+[pmCreate];
          if shi502_permissions and ACCESS_EXEC = ACCESS_EXEC then
            psr^.Permissions:=psr^.Permissions+[pmExec];
          if shi502_permissions and ACCESS_DELETE = ACCESS_DELETE then
            psr^.Permissions:=psr^.Permissions+[pmDelete];
          if shi502_permissions and ACCESS_ATRIB = ACCESS_ATRIB then
            psr^.Permissions:=psr^.Permissions+[pmAttrib];
          if shi502_permissions and ACCESS_PERM = ACCESS_PERM then
            psr^.Permissions:=psr^.Permissions+[pmPerm];
        end;
        FShares.AddObject(psr^.Name,TObject(psr));
        pTmpBuf:=PSHARE_INFO_502(PChar(pTmpBuf)+SizeOf(SHARE_INFO_502));
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

procedure TNTShares.FreeOpenFileList(var AList: TStringList);
begin
  while AList.Count>0 do begin
    dispose(POpenFileRecord(AList.Objects[AList.Count-1]));
    AList.Delete(AList.Count-1);
  end;
end;

procedure TNTShares.FreeSessionList(var AList: TStringList);
begin
  while AList.Count>0 do begin
    dispose(PNTSessionRecord(AList.Objects[AList.Count-1]));
    AList.Delete(AList.Count-1);
  end;
end;

function TNTShares.GetOpenFile(Index: DWORD): POpenFileRecord;
begin
  if Index<DWORD(FOpenFiles.Count) then
    Result:=POpenFileRecord(FOpenFiles.Objects[Index])
  else
    Result:=nil;
end;

function TNTShares.GetOpenFileCount: DWORD;
begin
  Result:=FOpenFiles.Count;
end;

function TNTShares.GetSession(Index: DWORD): PNTSessionRecord;
begin
  if Index<DWORD(FSessions.Count) then
    Result:=PNTSessionRecord(FSessions.Objects[Index])
  else
    Result:=nil;
end;

function TNTShares.GetSessionCount: DWORD;
begin
  Result:=FSessions.Count;
end;

procedure TNTShares.RefreshOpenFiles;
begin
  RetrieveOpenFiles(Machine)
end;

procedure TNTShares.RefreshSessions;
begin
  RetrieveSessions(Machine)
end;

procedure TNTShares.RetrieveOpenFiles(AMachine: string);
var
  pTmpBuf, pBuf: PFILE_INFO_3;
  nStatus: NET_API_STATUS;
  i: DWORD;
  dwPrefMaxLen: DWORD;
  dwEntriesRead: DWORD;
  dwTotalEntries: DWORD;
  dwResumeHandle: DWORD;
  Loop: Boolean;
  Buffer: array[0..256] of WideChar;
  pofr: POpenFileRecord;
begin
  FreeOpenFileList(FOpenFiles);
  pBuf:=nil;
  Loop:=True;
  dwPrefMaxLen:=$FFFFFFFF;
  dwEntriesRead:=0;
  dwTotalEntries:=0;
  dwResumeHandle:=0;
  while Loop do begin
    nStatus:=MiTeC_NetAPI32.NetFileEnum(StringToWideChar(AMachine,Buffer,256),nil,nil,3,
                          Pointer(pBuf),
                          dwPrefMaxLen, dwEntriesRead, dwTotalEntries, dwResumeHandle);
    if ((nStatus=ERROR_SUCCESS) or (nStatus=ERROR_MORE_DATA)) and (dwEntriesRead>0) then begin
      pTmpBuf:=pBuf;
      for i:=0 to dwEntriesRead-1 do begin
        new(pofr);
        pofr^.Name:=WideCharToString(pTmpBuf^.fi3_pathname);
        pofr^.UserName:=WideCharToString(pTmpBuf^.fi3_username);
        pofr^.Locks:=pTmpBuf^.fi3_num_locks;
        case pTmpBuf^.fi3_permissions of
          PERM_FILE_READ: pofr^.Mode:=pmRead;
          PERM_FILE_WRITE: pofr^.Mode:=pmWrite;
          PERM_FILE_CREATE: pofr^.Mode:=pmCreate;
        end;
        pofr^.ID:=pTmpBuf^.fi3_id;
        FOpenFiles.AddObject(IntToStr(pofr^.ID),TObject(pofr));
        pTmpBuf:=PFILE_INFO_3(PChar(pTmpBuf)+SizeOf(FILE_INFO_3));
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

procedure TNTShares.RetrieveSessions(AMachine: string);
var
  pTmpBuf, pBuf: PSESSION_INFO_502;
  nStatus: NET_API_STATUS;
  i: DWORD;
  dwPrefMaxLen: DWORD;
  dwEntriesRead: DWORD;
  dwTotalEntries: DWORD;
  dwResumeHandle: DWORD;
  Loop: Boolean;
  Buffer: array[0..256] of WideChar;
  psr: PNTSessionRecord;
begin
  FreeSessionList(FSessions);
  pBuf:=nil;
  Loop:=True;
  dwPrefMaxLen:=$FFFFFFFF;
  dwEntriesRead:=0;
  dwTotalEntries:=0;
  dwResumeHandle:=0;
  while Loop do begin
    nStatus:=MiTeC_NetAPI32.NetSessionEnum(StringToWideChar(AMachine,Buffer,256),nil,nil,502,
                          Pointer(pBuf),
                          dwPrefMaxLen, dwEntriesRead, dwTotalEntries, dwResumeHandle);
    if ((nStatus=ERROR_SUCCESS) or (nStatus=ERROR_MORE_DATA)) and (dwEntriesRead>0) then begin
      pTmpBuf:=pBuf;
      for i:=0 to dwEntriesRead-1 do begin
        new(psr);
        psr^.Name:=WideCharToString(pTmpBuf^.sesi502_cname);
        psr^.UserName:=WideCharToString(pTmpBuf^.sesi502_username);
        psr^.OpenFiles:=pTmpBuf^.sesi502_num_opens;
        psr^.SesiType:=WideCharToString(pTmpBuf^.sesi502_cltype_name);
        psr^.ConnectedTime:=pTmpBuf^.sesi502_time;
        psr^.IdleTime:=pTmpBuf^.sesi502_idle_time;
        psr^.Guest:=pTmpBuf^.sesi502_user_flags=SESS_GUEST;
        psr^.Transport:=WideCharToString(pTmpBuf^.sesi502_transport);
        FSessions.AddObject(psr^.Name,TObject(psr));
        pTmpBuf:=PSESSION_INFO_502(PChar(pTmpBuf)+SizeOf(SESSION_INFO_502));
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

procedure TNTShares.SetMachine(const Value: string);
begin
  FMachine:=Value;
  if FMachine='' then
    FMachine:='.';
  if FMachine[1]<>'\' then
    FMachine:='\\'+FMachine;
end;

{ TConnections }

constructor TConnections.Create;
begin
  FConns:=TStringList.Create;
  Machine:=Machinename;
  if IsNT then
    InitNetAPI
  else
    InitSvrAPI;
end;

destructor TConnections.Destroy;
begin
  FreeList(FConns);
  FConns.Free;
  inherited;
end;

procedure TConnections.FreeList(var AList: TStringList);
begin
  while AList.Count>0 do begin
    dispose(PConnectionRecord(AList.Objects[AList.Count-1]));
    AList.Delete(AList.Count-1);
  end;
end;

function TConnections.GetConn(Index: DWORD): PConnectionRecord;
begin
  if Index<DWORD(FConns.Count) then
    Result:=PConnectionRecord(FConns.Objects[Index])
  else
    Result:=nil;
end;

function TConnections.GetConnCount: DWORD;
begin
  Result:=FConns.Count;
end;

procedure TConnections.Refresh;
begin
  if IsNT then
    RetrieveNT(Machine,Qualifier)
  else
    Retrieve9x(Machine,Qualifier);
end;

procedure TConnections.Retrieve9x(AMachine, AQualifier: string);
var
  pTmpBuf, pBuf: MiTeC_SvrAPI.PCONNECTION_INFO_50;
  nStatus: DWORD;
  i: DWORD;
  dwPrefMaxLen: WORD;
  dwEntriesRead: WORD;
  dwTotalEntries: WORD;
  Loop: Boolean;
  pcr: PConnectionRecord;
begin
  FreeList(FConns);
  Loop:=True;
  dwEntriesRead:=0;
  dwTotalEntries:=0;
  dwPrefMaxLen:=MAX_ENTRIES*SizeOf(MiTeC_SvrAPI.connection_info_50);
  pBuf:=AllocMem(dwPrefMaxLen);
  while Loop do begin
    nStatus:=MiTeC_SvrAPI.NetConnectionEnum(PChar(AMachine),
                               PChar(AQualifier),
                               50,
                               PChar(pBuf),
                               dwPrefMaxLen, dwEntriesRead, dwTotalEntries);
    if Assigned(pBuf) and ((nStatus=ERROR_SUCCESS) or (nStatus=ERROR_MORE_DATA)) and (dwEntriesRead>0) then begin
      pTmpBuf:=pBuf;
      for i:=0 to dwEntriesRead-1 do begin
        new(pcr);
        pcr^.Name:=pTmpBuf^.coni50_netname;
        pcr^.UserName:=pTmpBuf^.coni50_username;
        pcr^.ID:=0;
        case pTmpBuf^.coni50_type of
          STYPE_DISKTREE: pcr^.ConnType:=stDisk;
          STYPE_PRINTQ: pcr^.ConnType:=stPrnQue;
          STYPE_DEVICE: pcr^.ConnType:=stCommDev;
          STYPE_IPC: pcr^.ConnType:=stIPC;
        else
          pcr^.ConnType:=stSpecial;
        end;
        pcr^.Time:=pTmpBuf^.coni50_time;
        pcr^.OpenFiles:=pTmpBuf^.coni50_num_opens;
        pcr^.Users:=0;
        FConns.AddObject(IntToStr(pcr^.ID),TObject(pcr));
        pTmpBuf:=MiTeC_SvrAPI.PCONNECTION_INFO_50(PChar(pTmpBuf)+SizeOf(MiTeC_SvrAPI.CONNECTION_INFO_50));
      end;
      if Assigned(pBuf) then
        FreeMem(pBuf);
      if nStatus=ERROR_SUCCESS then
        Loop:=False;
    end else
      Loop:=False;
  end;
end;

procedure TConnections.RetrieveNT;
var
  pTmpBuf, pBuf: MiTeC_NetAPI32.PCONNECTION_INFO_1;
  nStatus: NET_API_STATUS;
  i: DWORD;
  dwPrefMaxLen: DWORD;
  dwEntriesRead: DWORD;
  dwTotalEntries: DWORD;
  dwResumeHandle: DWORD;
  Loop: Boolean;
  Buf1,Buf2: array[0..256] of WideChar;
  pcr: PConnectionRecord;
begin
  FreeList(FConns);
  pBuf:=nil;
  Loop:=True;
  dwPrefMaxLen:=$FFFFFFFF;
  dwEntriesRead:=0;
  dwTotalEntries:=0;
  dwResumeHandle:=0;
  while Loop do begin
    nStatus:=MiTeC_NetAPI32.NetConnectionEnum(StringToWideChar(AMachine,Buf1,256),
                               StringToWideChar(AQualifier,Buf2,256),
                               1,
                               Pointer(pBuf),
                               dwPrefMaxLen, dwEntriesRead, dwTotalEntries, dwResumeHandle);
    if ((nStatus=ERROR_SUCCESS) or (nStatus=ERROR_MORE_DATA)) and (dwEntriesRead>0) then begin
      pTmpBuf:=pBuf;
      for i:=0 to dwEntriesRead-1 do begin
        new(pcr);
        pcr^.Name:=WideCharToString(pTmpBuf^.coni1_netname);
        pcr^.UserName:=WideCharToString(pTmpBuf^.coni1_username);
        pcr^.ID:=pTmpBuf^.coni1_id;
        case pTmpBuf^.coni1_type of
          STYPE_DISKTREE: pcr^.ConnType:=stDisk;
          STYPE_PRINTQ: pcr^.ConnType:=stPrnQue;
          STYPE_DEVICE: pcr^.ConnType:=stCommDev;
          STYPE_IPC: pcr^.ConnType:=stIPC;
          STYPE_SPECIAL: pcr^.ConnType:=stSpecial;
        end;
        pcr^.Time:=pTmpBuf^.coni1_time;
        pcr^.OpenFiles:=pTmpBuf^.coni1_num_opens;
        pcr^.Users:=pTmpBuf^.coni1_num_users;
        FConns.AddObject(IntToStr(pcr^.ID),TObject(pcr));
        pTmpBuf:=MiTeC_NetAPI32.PCONNECTION_INFO_1(PChar(pTmpBuf)+SizeOf(MiTeC_NetAPI32.CONNECTION_INFO_1));
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

procedure TConnections.SetMachine(const Value: string);
begin
  FMachine:=Value;
  if FMachine='' then
    FMachine:='.';
  if FMachine[1]<>'\' then
    FMachine:='\\'+FMachine;
end;

{ T9xShares }

constructor T9xShares.Create;
begin
  FShares:=TStringList.Create;
  FSessions:=TStringList.Create;
  FOpenFiles:=TStringList.Create;
  Machine:=Machinename;
end;

destructor T9xShares.Destroy;
begin
  FreeShareList(FShares);
  FShares.Free;
  FreeShareList(FSessions);
  FSessions.Free;
  FreeOpenFileList(FOpenFiles);
  FOpenFiles.Free;
  inherited;
end;

procedure T9xShares.FreeShareList(var AList: TStringList);
begin
  while AList.Count>0 do begin
    dispose(P9xShareRecord(AList.Objects[AList.Count-1]));
    AList.Delete(AList.Count-1);
  end;
end;

procedure T9xShares.FreeOpenFileList(var AList: TStringList);
begin
  while AList.Count>0 do begin
    dispose(POpenFileRecord(AList.Objects[AList.Count-1]));
    AList.Delete(AList.Count-1);
  end;
end;

function T9xShares.GetShareCount: DWORD;
begin
  Result:=FShares.Count;
end;

function T9xShares.GetSession(Index: DWORD): P9xShareRecord;
begin
  if Index<DWORD(FSessions.Count) then
    Result:=P9xShareRecord(FSessions.Objects[Index])
  else
    Result:=nil;
end;

function T9xShares.GetShare(Index: DWORD): P9xShareRecord;
begin
  if Index<DWORD(FShares.Count) then
    Result:=P9xShareRecord(FShares.Objects[Index])
  else
    Result:=nil;
end;

procedure T9xShares.RefreshSessions;
begin
  RetrieveShares(RESOURCE_CONNECTED,nil,Machine,FSessions);
end;

procedure T9xShares.RefreshShares;
begin
  RetrieveShares(RESOURCE_GLOBALNET,nil,Machine,FShares);
end;

procedure T9xShares.RetrieveShares;
var
  phEnum :THandle;
  pcCount, Size: Cardinal;
  i, NetError :integer;
  NR :array[0..100] of TNetResource;
  nri: TNetResource;
  psr: P9xShareRecord;
  rn,n: string;
  cont: Boolean;
begin
  if wnetopenenum(AScope,RESOURCETYPE_ANY,0,ANetResource,phEnum)=NO_ERROR then begin
    repeat
      pccount:=Cardinal(-1);
      size:=sizeof(nr);
      neterror:=wnetenumresource(phEnum,pccount,@nr[0],size);
      if neterror=0 then begin
        for i:=0 to pccount-1 do  begin
          nri:=nr[i];
          rn:=UpperCase(nri.lpRemoteName);
          n:=nri.lpLocalName;
          if n='' then
            n:=rn;
          if (AList.IndexOf(n)=-1) and
             ((AScope<>RESOURCE_GLOBALNET) or ((AScope=RESOURCE_GLOBALNET) and (Pos(AMachine,rn)>0))) then begin
            new(psr);
            psr^.Path:=nri.lpRemoteName;
            psr^.Name:=n;
            case nri.dwType of
              RESOURCETYPE_ANY: psr^.ShareType:=stSpecial;
              RESOURCETYPE_DISK: psr^.ShareType:=stDisk;
              RESOURCETYPE_PRINT: psr^.ShareType:=stPrnQue;
              else
                psr^.ShareType:=stSpecial;
            end;
            psr^.Comment:=nri.lpComment;
            AList.AddObject(psr^.Name,TObject(psr));
            cont:=(nri.dwDisplayType>=RESOURCEDISPLAYTYPE_DOMAIN);
          end else
            cont:=(AScope=RESOURCE_GLOBALNET) and
                  (nri.dwDisplayType in [RESOURCEDISPLAYTYPE_DOMAIN,RESOURCEDISPLAYTYPE_GROUP,RESOURCEDISPLAYTYPE_NETWORK,RESOURCEDISPLAYTYPE_ROOT]);
          if cont then
            RetrieveShares(AScope,@nri,AMachine,AList);
        end;
      end;
    until neterror=ERROR_NO_MORE_ITEMS;
    wnetcloseenum(phEnum);
  end;
end;

function T9xShares.GetSessionCount: DWORD;
begin
  Result:=FSessions.Count;
end;

procedure T9xShares.RetrieveOpenFiles(AMachine: string);
var
  pTmpBuf, pBuf: pfile_info_50;
  nStatus: DWORD;
  i: DWORD;
  cbBuffer: WORD;
  nEntriesRead: WORD;
  nTotalEntries: WORD;
  pofr: POpenFileRecord;
begin
  FreeOpenFileList(FOpenFiles);
  pBuf:=nil;
  cbBuffer:=MAX_ENTRIES*SizeOf(file_info_50);
  nEntriesRead:=0;
  nTotalEntries:=0;
  pBuf:=AllocMem(cbBuffer);
  nStatus:=MiTeC_SvrAPI.NetFileEnum(PChar(AMachine),nil,50,
                       PChar(pBuf),
                       cbBuffer, nEntriesRead, nTotalEntries);
  if ((nStatus=ERROR_SUCCESS) or (nStatus=ERROR_MORE_DATA)) and (nEntriesRead>0) then begin
    pTmpBuf:=pBuf;
    for i:=0 to nEntriesRead-1 do begin
      new(pofr);
      pofr^.Name:=pTmpBuf^.fi50_pathname;
      FOpenFiles.AddObject(pofr^.Name,TObject(pofr));
      pTmpBuf:=pfile_info_50(PChar(pTmpBuf)+SizeOf(file_info_50));
    end;
  end;
  if Assigned(pBuf) then
    FreeMem(pBuf);
end;

function T9xShares.GetOpenFile(Index: DWORD): POpenFileRecord;
begin
  if Index<DWORD(FOpenFiles.Count) then
    Result:=POpenFileRecord(FOpenFiles.Objects[Index])
  else
    Result:=nil;
end;

function T9xShares.GetOpenFileCount: DWORD;
begin
  Result:=FOpenFiles.Count;
end;

procedure T9xShares.RefreshOpenFiles;
begin
  RetrieveOpenFiles(Machine);
end;

procedure T9xShares.SetMachine(const Value: string);
begin
  FMachine:=Value;
  if FMachine='' then
    FMachine:='.';
  if FMachine[1]<>'\' then
    FMachine:='\\'+FMachine;
end;

end.

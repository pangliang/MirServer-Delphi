{*******************************************************}
{                                                       }
{             MiTeC Common Routines                     }
{           version 8.6.4 for Delphi 5,6,7              }
{                                                       }
{       Copyright © 1997,2004 Michal Mutl               }
{                                                       }
{*******************************************************}

{$INCLUDE MITEC_DEF.INC}

unit MiTeC_Routines;

interface

uses {$IFDEF D6PLUS} Variants, {$ENDIF}Windows, Classes, SysUtils, ShlObj, Registry;

type
  TTerminateStatus = (tsError,tsClose,tsTerminate);

  TConnectionType = (ctNone, ctLAN, ctDialup);

  TOSVersion = (osUnknown, osNT3, os95, osNT4, os95OSR1, os95OSR2, os95OSR25, os98, os98SE, osME, os2K, osXP, osNET);

  TVersionInfo = record
    FileName,
    Version,
    ProductName,
    CompanyName,
    Description,
    Comments,
    Copyright,
    InternalName,
    ProductVersion: string;
    Major,
    Minor,
    Release,
    Build: DWORD;
    ProductMajor,
    ProductMinor,
    ProductRelease,
    ProductBuild: DWORD;
    SpecialBuild: string;
  end;

  TMediaType = (dtUnknown, dtNotExists, dtRemovable, dtFixed, dtRemote, dtCDROM, dtRAMDisk);

  TFileFlag = (fsCaseIsPreserved, fsCaseSensitive, fsUnicodeStoredOnDisk,
               fsPersistentAcls, fsFileCompression, fsVolumeIsCompressed,
               fsLongFileNames,
               // following flags are valid only for Windows2000
               fsEncryptedFileSystemSupport, fsObjectIDsSupport, fsReparsePointsSupport,
               fsSparseFilesSupport, fsDiskQuotasSupport);
  TFileFlags = set of TFileFlag;

  TDiskSign = string[2];

  TDiskInfo = record
    Sign: TDiskSign;
    MediaType: TMediaType;
    FileFlags: TFileFlags;
    SectorsPerCluster,
    BytesPerSector,
    FreeClusters,
    TotalClusters,
    Serial: DWORD;
    Capacity,
    FreeSpace: Int64;
    VolumeLabel,
    SerialNumber,
    FileSystem: string;
  end;

  PWindowInfo = ^TWindowInfo;
  TWindowInfo = record
    ClassName,
    Text :string;
    Handle,
    Process,
    Thread :longword;
    ParentWin,
    WndProc,
    Instance,
    ID,
    UserData,
    Style,
    ExStyle :longint;
    Rect,
    ClientRect :TRect;
    Atom,
    ClassBytes,
    WinBytes,
    ClassWndProc,
    ClassInstance,
    Background,
    Cursor,
    Icon,
    ClassStyle :longword;
    Styles,
    ExStyles,
    ClassStyles :tstringlist;
    Visible :boolean;
  end;

  TFileInfo = record
    Name: string;
    FileType: string;
    Size :DWORD;
    Created,
    Accessed,
    Modified :TDateTime;
    Attributes :DWORD;
    BinaryType: string;
    IconHandle: THandle;
  end;

  TPrivilegeInfo = record
    Name,
    DisplayName: ShortString;
    Flags: DWORD;
  end;
  TPrivilegeList = array of TPrivilegeInfo;

  TTokenGroupInfo = record
    SID,
    Domain,
    Name: ShortString;
    Flags: DWORD;
  end;
  TTokenGroupList = array of TTokenGroupInfo;

{$IFNDEF D6PLUS}
function ReverseString(const AText: string): string;
function DirectoryExists(const Directory: string): Boolean;
procedure ForceDirectories(APath: string);
{$ENDIF}

function BuildFileList(const Path: string; const Attr: Integer; const List: TStrings): Boolean;
function DeleteDirectory(Path: String): Boolean;

function ExpandEnvVars(ASource: string): string; overload;
function ExpandEnvVars(AEnvironment: TStrings; ASource: string): string; overload;
function GetEnvVarValue(Name: string): string;
function GetErrorMessage(ErrorCode: integer): string;
function GetUser :string;
function GetMachine :string;
function GetOS(var CSD: string) :TOSVersion;
function ReadRegInfo(ARoot :hkey; AKey, AValue :string) :string;
function GetFileVerInfo(const fn :string; var VI:TVersionInfo): boolean;
function GetFileVersion(const fn: string): string;
function GetFileCopyright(const fn: string): string;
function GetFileProduct(const fn: string): string;
function GetFileDesc(const fn: string): string;
function GetClassDevices(AStartKey,AClassName,AValueName :string; var AResult :TStrings) :string;
procedure GetEnvironment(var EnvList :tstrings);
function GetWinDir :string;
function GetSysDir :string;
function GetTempDir :string;
function GetWinSysDir: string;
function GetProfilePath: string;
function GetWindowInfo(wh: hwnd): TWindowInfo;
function GetUniqueFilename(Prefix: string; Unique: DWORD; Temp: Boolean = False): string;
function ResolveLink(const LinkFile: TFileName; var FileName, Arguments: string): HRESULT;
function GetSpecialFolder(Handle: Hwnd; nFolder: Integer): widestring;
function KillProcess(ProcessID: DWORD; Timeout: Integer = MAXINT): TTerminateStatus;
function IsProcessActive(APID: integer): Boolean;
function GetFontRes: DWORD;
function CreateDOSProcessRedirected(const CommandLine, InputFile, OutputFile,ErrMsg :string): Boolean;
function FileExistsEx(const FileName: string): Boolean;
function FileTimeToDateTimeStr(FileTime: TFileTime): string;
function FiletimeToDateTime(FT: FILETIME): TDateTime;
procedure GetFileInfo(const AFilename: string; var AFileInfo: TFileInfo);
function GetFileIconCount(const Filename: string): Integer;
function GetFileIcon(const Filename: string; IconIndex: Word = 0): HICON;
function GetFileSize(const AFilename: string): integer;
function HasAttr(const AFileName: string; AAttr: Word): Boolean;
function GetBinType(const AFilename :string) :string;
function ExtractUNCFilename(ASource :string) :string;
function DequoteStr(Source: string; Quote: Char = '"'): string;
function ExtractFilenameFromStr(Source: string): string;
function ExtractName(const AFilename: string): string;
function FileCopy(const AFileName, ADestName: string): boolean;
function FileMove(const AFileName, ADestName: string): boolean;
function FileNameMove(const AFileName, ADestName: string): Integer;
function FileNameCopy(const AFileName,AExtSpec, ADestName: string): Integer;
function GetMediaTypeStr(MT: TMediaType): string;
function GetMediaPresent(Value: TDiskSign) :Boolean;
function GetDiskInfo(Value: TDiskSign): TDiskInfo;
function GetAvailDisks :string;
procedure GetCDs(cds :tstrings);
function OpenMailSlot(Const Server, Slot : String): THandle;
function SendToMailSlot(Const Server, Slot, Mail : String) : Boolean;
function SendToWinpopup(Server, Reciever, Sender, Msg : String) : Boolean;
function IsBitOn(Value: Integer; Bit: Byte): Boolean;
procedure RunAtStartup(AKey: HKEY; Flag: Boolean; Name,Cmdline: string);
function CheckRunAtStartup(Akey: HKEY; Name,CmdLine: string): Boolean;
function GetDefaultMailClient: string;
function GetDefaultBrowser: string;
function GetConnectionType: TConnectionType;
function GetProxyServer: string;
function Init9xPerfData(ObjCounter: string): Boolean;
function Get9xPerfData(ObjCounter: string): integer;
function Release9xPerfData(ObjCounter: string): Boolean;
function WinExecAndWait32(FileName,Parameters: String; Visibility: integer): DWORD;
procedure ModifyRegValue(ARootKey: HKEY; AKey, AName: string; AValue: Variant; AType: TRegDataType);

function PortIn(IOAddr : WORD) : Byte;
procedure PortOut(IOAddr : WORD; Data : BYTE);
function AppIsResponding(AHandle: THandle): Boolean;
function EnablePrivilege(Privilege: string): Boolean;
function DisablePrivileges: Boolean;
function ConvertSIDToString(ASID: Pointer): string;
function ConvertStringToSID(ASID: string): PSID;
function IsAdmin: Boolean;
function GetProcessUserName(hProcess :THandle; var UserName, DomainName :string) :Boolean;
function GetProcessPrivileges(Processhandle: THandle; var AList: TPrivilegeList): boolean;
function GetProcessGroups(Processhandle: THandle; var AList: TTokenGroupList): Boolean;

function ReadRegistryString(Root: HKEY; Key,Value: string): string;
function ReadRegistryValueAsString(Root: HKEY; Key,Value: string; BinaryAsHex: Boolean = True): string;
procedure GetRegistryKeyNames(Root: HKEY; Key: string; var KeyList: TStringList);
procedure MultiWideStrFromBuf(Buffer: array of Byte; Len: DWORD; var List: TStringList);
procedure MultiStrFromBuf(Buffer: array of Byte; Len: DWORD; var List: TStringList);

function AssignHotkey(Handle: HWND; HotKey: TShortCut; KeyIdx: Word): Boolean;
function ValidHotkey(Handle: HWND; HotKey: TShortCut; KeyIdx: Word): Boolean;

function GetLastFilename(AFilename: string): string;

function VarToFloat(Source: Variant): Double;
function VarToInt(Source: Variant): integer;
function VarToBool(Source: Variant): boolean;
function StrToIntEx(Source: string): Integer;

function GetObjectFullName(Sender: TObject): string;
function ConvertAddr(Address: Pointer): Pointer; assembler;
procedure ErrorInfo(var LogicalAddress: Pointer; var ModuleName: shortstring);
function CorrectFilename(fn: string): string;

procedure StartTimer;
function StopTimer: comp;

const
  DescValue = 'DriverDesc';

  CSIDL_COMMON_ALTSTARTUP         = $001e;
  CSIDL_COMMON_FAVORITES          = $001f;
  CSIDL_INTERNET_CACHE            = $0020;
  CSIDL_COOKIES                   = $0021;
  CSIDL_HISTORY                   = $0022;
  CSIDL_INTERNET                  = $0001;

  FILE_SUPPORTS_ENCRYPTION = 32;
  FILE_SUPPORTS_OBJECT_IDS = 64;
  FILE_SUPPORTS_REPARSE_POINTS = 128;
  FILE_SUPPORTS_SPARSE_FILES = 256;
  FILE_VOLUME_QUOTAS = 512;

  StartStat = 'PerfStats\StartStat';
  StatData = 'PerfStats\StatData';
  StopStat = 'PerfStats\StopStat';

// NT defined privileges

  SE_CREATE_TOKEN_NAME        = 'SeCreateTokenPrivilege';
  SE_ASSIGNPRIMARYTOKEN_NAME  = 'SeAssignPrimaryTokenPrivilege';
  SE_LOCK_MEMORY_NAME         = 'SeLockMemoryPrivilege';
  SE_INCREASE_QUOTA_NAME      = 'SeIncreaseQuotaPrivilege';
  SE_UNSOLICITED_INPUT_NAME   = 'SeUnsolicitedInputPrivilege';
  SE_MACHINE_ACCOUNT_NAME     = 'SeMachineAccountPrivilege';
  SE_TCB_NAME                 = 'SeTcbPrivilege';
  SE_SECURITY_NAME            = 'SeSecurityPrivilege';
  SE_TAKE_OWNERSHIP_NAME      = 'SeTakeOwnershipPrivilege';
  SE_LOAD_DRIVER_NAME         = 'SeLoadDriverPrivilege';
  SE_SYSTEM_PROFILE_NAME      = 'SeSystemProfilePrivilege';
  SE_SYSTEMTIME_NAME          = 'SeSystemtimePrivilege';
  SE_PROF_SINGLE_PROCESS_NAME = 'SeProfileSingleProcessPrivilege';
  SE_INC_BASE_PRIORITY_NAME   = 'SeIncreaseBasePriorityPrivilege';
  SE_CREATE_PAGEFILE_NAME     = 'SeCreatePagefilePrivilege';
  SE_CREATE_PERMANENT_NAME    = 'SeCreatePermanentPrivilege';
  SE_BACKUP_NAME              = 'SeBackupPrivilege';
  SE_RESTORE_NAME             = 'SeRestorePrivilege';
  SE_SHUTDOWN_NAME            = 'SeShutdownPrivilege';
  SE_DEBUG_NAME               = 'SeDebugPrivilege';
  SE_AUDIT_NAME               = 'SeAuditPrivilege';
  SE_SYSTEM_ENVIRONMENT_NAME  = 'SeSystemEnvironmentPrivilege';
  SE_CHANGE_NOTIFY_NAME       = 'SeChangeNotifyPrivilege';
  SE_REMOTE_SHUTDOWN_NAME     = 'SeRemoteShutdownPrivilege';
  SE_UNDOCK_NAME              = 'SeUndockPrivilege';
  SE_SYNC_AGENT_NAME          = 'SeSyncAgentPrivilege';
  SE_ENABLE_DELEGATION_NAME   = 'SeEnableDelegationPrivilege';
  SE_MANAGE_VOLUME_NAME       = 'SeManageVolumePrivilege';

  // Group attributes
  SE_GROUP_MANDATORY          = ($00000001);
  SE_GROUP_ENABLED_BY_DEFAULT = ($00000002);
  SE_GROUP_ENABLED            = ($00000004);
  SE_GROUP_OWNER              = ($00000008);
  SE_GROUP_USE_FOR_DENY_ONLY  = ($00000010);
  SE_GROUP_LOGON_ID           = ($C0000000);
  SE_GROUP_RESOURCE           = ($20000000);


var
  CSD, OSVersion, OSVersionEx, ClassKey: string;
  IsNT,IsNT4,IsNT5,Is95,Is98,Is2K,IsOSR2,IsSE,IsME,IsXP,IsNET: Boolean;
  Profilepath, WindowsUser, MachineName: string;
  OS: TOSVersion;
  OSMajorVersion, OSMinorVersion, OSBuild, Memory: Integer;
  EXEVersionInfo: TVersionInfo;

implementation

uses
  ShellAPI, ActiveX, Messages, Math, CommDlg, MiTeC_Native
  {$IFDEF D6PLUS} ,StrUtils, DateUtils {$ENDIF};

var
  MS: TMemoryStatus;
  InternalTimer: comp;

const
  wpSlot = 'messngr';

{$IFNDEF D6PLUS}
function ReverseString(const AText: string): string;
var
  I: Integer;
  P: PChar;
begin
  SetLength(Result, Length(AText));
  P := PChar(Result);
  for I := Length(AText) downto 1 do
  begin
    P^ := AText[I];
    Inc(P);
  end;
end;

function DirectoryExists(const Directory: string): Boolean;
var
  Code: Integer;
begin
  Code:=GetFileAttributes(PChar(Directory));
  Result:=(Code<>-1) and (FILE_ATTRIBUTE_DIRECTORY and Code <> 0);
end;

procedure ForceDirectories;
var
  drive,path,dp: string;
  p: Integer;
begin
  {$IFDEF D6PLUS}
  APath:=IncludeTrailingPathDelimiter(APath);
  {$ELSE}
  APath:=IncludeTrailingBackslash(APath);
  {$ENDIF}
  drive:=ExtractFileDrive(APath);
  if drive='' then
    drive:=ExtractFileDrive(GetCurrentDir);
  drive:=drive;
  path:=Copy(APath,Length(drive)+2,255);
  p:=Pos('\',path);
  dp:='';
  while p<>0 do begin
    dp:=dp+'\'+Copy(path,1,p-1);
    Delete(path,1,p);
    if not DirectoryExists(drive+dp) then
      CreateDir(drive+dp);
    p:=Pos('\',path);
  end;
end;

{$ENDIF}

function BuildFileList(const Path: string; const Attr: Integer; const List: TStrings): Boolean;
var
  SearchRec: TSearchRec;
  R: Integer;
begin
  Assert(List <> nil);
  R := FindFirst(Path, Attr, SearchRec);
  Result := R = 0;
  try
    if Result then begin
      while R = 0 do begin
        if (SearchRec.Name <> '.') and (SearchRec.Name <> '..') then
          List.Add(SearchRec.Name);
        R := FindNext(SearchRec);
      end;
      Result := R = ERROR_NO_MORE_FILES;
    end;
  finally
    SysUtils.FindClose(SearchRec);
  end;
end;

function DeleteDirectory;
var
  Files: TStringList;
  LPath: string; // writable copy of Path
  FileName: string;
  I: Integer;
  PartialResult: Boolean;
  Attr: DWORD;
begin
  Result := True;
  Files := TStringList.Create;
  try
    {$IFDEF D6PLUS}
    LPath:=ExcludeTrailingPathDelimiter(Path);
    {$ELSE}
    LPath:=ExcludeTrailingBackslash(Path);
    {$ENDIF}
    BuildFileList(LPath + '\*.*', faAnyFile, Files);
    for I := 0 to Files.Count - 1 do
    begin
      FileName := LPath + '\' + Files[I];
      PartialResult := True;
      // If the current file is itself a directory then recursively delete it
      Attr := GetFileAttributes(PChar(FileName));
      if (Attr <> DWORD(-1)) and ((Attr and FILE_ATTRIBUTE_DIRECTORY) <> 0) then
        PartialResult := DeleteDirectory(FileName)
      else
      begin
        {if Assigned(Progress) then
          PartialResult := Progress(FileName, Attr);}
        if PartialResult then
        begin
          // Set attributes to normal in case it's a readonly file
          PartialResult := SetFileAttributes(PChar(FileName), FILE_ATTRIBUTE_NORMAL);
          if PartialResult then
            PartialResult := DeleteFile(FileName);
        end;
      end;
      if not PartialResult then
      begin
        Result := False;
        {if AbortOnFailure then
          Break;}
      end;
    end;
  finally
    FreeAndNil(Files);
  end;
  if Result then
  begin
    // Finally remove the directory itself
    Result := SetFileAttributes(PChar(LPath), FILE_ATTRIBUTE_NORMAL);
    if Result then
    begin
      {$IOCHECKS OFF}
      RmDir(LPath);
      {$IFDEF IOCHECKS_ON}
      {$IOCHECKS ON}
      {$ENDIF IOCHECKS_ON}
      Result := IOResult = 0;
    end;
  end;
end;

function GetErrorMessage(ErrorCode: integer): string;
const
  BUFFER_SIZE = 1024;
var
  lpMsgBuf: Pchar;
  LangID: DWORD;
begin
  lpMsgBuf:=AllocMem(BUFFER_SIZE);
  LangID:=$409;//GetUserDefaultLangID;
  FormatMessage(FORMAT_MESSAGE_FROM_SYSTEM or FORMAT_MESSAGE_IGNORE_INSERTS,
                nil,ErrorCode,LangID,lpMsgBuf,BUFFER_SIZE,nil);
  Result:=lpMsgBuf;
  FreeMem(lpMsgBuf);
end;

function GetOS;
var
  OS :TOSVersionInfo;
const
  rkSP6a = {HKEY_LOCAL_MACHINE}'\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Hotfix\Q246009';
  rvInstalled = 'Installed';
begin
  ZeroMemory(@OS,SizeOf(OS));
  OS.dwOSVersionInfoSize:=SizeOf(OS);
  GetVersionEx(OS);
  CSD:=OS.szCSDVersion;
  OSMajorVersion:=OS.dwMajorVersion;
  OSMinorVersion:=OS.dwMinorVersion;
  OSBuild:=OS.dwBuildNumber;
  Result:=osUnknown;
  if OS.dwPlatformId=VER_PLATFORM_WIN32_NT then begin
    case OS.dwMajorVersion of
      3: Result:=osNT3;
      4: Result:=osNT4;
      5: Result:=os2K;
    end;
    if (OS.dwMajorVersion=5) and (OS.dwMinorVersion=1) then
      Result:=osXP;
    if (OS.dwMajorVersion=5) and (OS.dwMinorVersion=2) then
      Result:=osNET;
    if CSD='Service Pack 6' then
      with TRegistry.Create do begin
        RootKey:=HKEY_LOCAL_MACHINE;
        if OpenKeyReadOnly(rkSP6a) then begin
          if ValueExists(rvInstalled) then
            if ReadInteger(rvInstalled)=1 then
              CSD:='Service Pack 6a';
          CloseKey;
        end;
        Free;
      end;
  end else begin
    if (OS.dwMajorVersion=4) and (OS.dwMinorVersion=0) then begin
      Result:=os95;
      if (Trim(OS.szCSDVersion)='A') then
        Result:=os95OSR1;
      if (Trim(OS.szCSDVersion)='B') then
        Result:=os95OSR2;
      if (Trim(OS.szCSDVersion)='C') then
        Result:=os95OSR25;
    end else
      if (OS.dwMajorVersion=4) and (OS.dwMinorVersion=10) then begin
        Result:=os98;
        if LoWord(OS.dwBuildNumber)=2222 then
          Result:=os98SE;
      end else
        if (OS.dwMajorVersion=4) and (OS.dwMinorVersion=90) then
          Result:=osME;
  end;
end;

function ReadRegInfo(ARoot :hkey; AKey, AValue :string) :string;
begin
  with TRegistry.create do begin
    result:='';
    rootkey:=aroot;
    if keyexists(akey) then begin
      OpenKeyReadOnly(akey);
      if ValueExists(avalue) then begin
        case getdatatype(avalue) of
          rdstring: result:=ReadString(avalue);
          rdinteger: result:=inttostr(readinteger(avalue));
        end;
      end;
      closekey;
    end;
    free;
  end;
end;

function GetFileVerInfo;
var
  VersionHandle,VersionSize :dword;
  PItem,PVersionInfo :pointer;
  FixedFileInfo :PVSFixedFileInfo;
  il :uint;
  p :array [0..MAX_PATH - 1] of char;
  translation: string;
begin
  Result:=False;
  if fn<>'' then begin
    VI.FileName:=fn;
    strpcopy(p,fn);
    versionsize:=getfileversioninfosize(p,versionhandle);
    if versionsize=0 then
      exit;
    getMem(pversioninfo,versionsize);
    try
      if getfileversioninfo(p,versionhandle,versionsize,pversioninfo) then begin
        Result:=True;
        if verqueryvalue(pversioninfo,'\',pointer(fixedfileinfo),il) then begin
          VI.Major:=hiword(fixedfileinfo^.dwfileversionms);
          VI.Minor:=loword(fixedfileinfo^.dwfileversionms);
          VI.Release:=hiword(fixedfileinfo^.dwfileversionls);
          VI.Build:=loword(fixedfileinfo^.dwfileversionls);

          VI.ProductMajor:=hiword(fixedfileinfo^.dwProductVersionMS);
          VI.ProductMinor:=loword(fixedfileinfo^.dwProductVersionMS);
          VI.ProductRelease:=hiword(fixedfileinfo^.dwProductVersionLS);
          VI.ProductBuild:=loword(fixedfileinfo^.dwProductVersionLS);

          if verqueryvalue(pversioninfo,pchar('\VarFileInfo\Translation'),pitem,il) then begin
            translation:=IntToHex(PDWORD(pitem)^,8);
            translation:=Copy(translation,5,4)+Copy(translation,1,4);
          end;
          if verqueryvalue(pversioninfo,pchar('\StringFileInfo\'+translation+'\ProductVersion'),pitem,il) then
            VI.ProductVersion:=pchar(pitem);

          if verqueryvalue(pversioninfo,pchar('\StringFileInfo\'+translation+'\FileVersion'),pitem,il) then
            VI.Version:=pchar(pitem);

          if verqueryvalue(pversioninfo,pchar('\StringFileInfo\'+translation+'\FileDescription'),pitem,il) then
            VI.description:=pchar(pitem);

          if verqueryvalue(pversioninfo,pchar('\StringFileInfo\'+translation+'\LegalCopyright'),pitem,il) then
            VI.Copyright:=pchar(pitem);

          if verqueryvalue(pversioninfo,pchar('\StringFileInfo\'+translation+'\Comments'),pitem,il) then
            VI.Comments:=pchar(pitem);

          if verqueryvalue(pversioninfo,pchar('\StringFileInfo\'+translation+'\SpecialBuild'),pitem,il) then
            VI.SpecialBuild:=pchar(pitem);

          if verqueryvalue(pversioninfo,pchar('\StringFileInfo\'+translation+'\ProductName'),pitem,il) then
            VI.ProductName:=pchar(pitem);

          if verqueryvalue(pversioninfo,pchar('\StringFileInfo\'+translation+'\CompanyName'),pitem,il) then
            VI.CompanyName:=pchar(pitem);

          if verqueryvalue(pversioninfo,pchar('\StringFileInfo\'+translation+'\InternalName'),pitem,il) then
            VI.InternalName:=pchar(pitem);

        end;
      end;
    finally
      freeMem(pversioninfo,versionsize);
    end;
  end;
end;

function GetFileVersion;
var
  VIR: TVersionInfo;
begin
  if GetFileVerInfo(fn,VIR) then
    Result:=VIR.Version
  else
    Result:='';
end;

function GetFileCopyright;
var
  VIR: TVersionInfo;
begin
  if GetFileVerInfo(fn,VIR) then
    Result:=VIR.Copyright
  else
    Result:='';
end;

function GetFileProduct;
var
  VIR: TVersionInfo;
begin
  if GetFileVerInfo(fn,VIR) then
    Result:=VIR.ProductName
  else
    Result:='';
end;

function GetFileDesc;
var
  VIR: TVersionInfo;
begin
  if GetFileVerInfo(fn,VIR) then
    Result:=VIR.Description
  else
    Result:='';
end;

function GetMachine :string;
var
  n :dword;
  buf :pchar;
const
  rkMachine = {HKEY_LOCAL_MACHINE}'\SYSTEM\CurrentControlSet\Control\ComputerName\ComputerName';
    rvMachine = 'ComputerName';
begin
  n:=255;
  buf:=stralloc(n);
  GetComputerName(buf,n);
  result:=buf;
  strdispose(buf);
  with TRegistry.Create do begin
    rootkey:=HKEY_LOCAL_MACHINE;
    if OpenKeyReadOnly(rkMachine) then begin
      if ValueExists(rvMachine) then
        result:=ReadString(rvMachine);
      closekey;
    end;
    free;
  end;
end;

function GetUser :string;
var
  n :dword;
  buf :pchar;
begin
  n:=255;
  buf:=stralloc(n);
  If GetUserName(buf,n) Then
    result:=strpas(buf)
  else
    Result:='';
  result:=buf;
  strdispose(buf);
end;

function GetClassDevices(AStartKey,AClassName,AValueName :string; var AResult :TStrings) :string;
var
  i,j :integer;
  sl :TStringList;
  s,v,rclass :string;
const
  rvGUID = 'ClassGUID';
  rvClass = 'Class';
  rvLink = 'Link';
begin
  Result:='';
  AResult.Clear;
  with TRegistry.Create do begin
    RootKey:=HKEY_LOCAL_MACHINE;
    if IsNT then begin
      if OpenKeyReadOnly(AStartKey) then begin
        sl:=TStringList.Create;
        GetKeyNames(sl);
        CloseKey;
        for i:=0 to sl.Count-1 do
          if OpenKeyReadOnly(AStartKey+'\'+sl[i]) then begin
            if ValueExists(rvClass) then begin
              rclass:=UpperCase(ReadString(rvClass));
              if rclass=UpperCase(AClassName) then begin
                if not IsNT then begin
                  s:=UpperCase(ReadString(rvLink));
                  CloseKey;
                  if not OpenKeyReadOnly(AStartKey+'\'+s) then
                    Exit;
                end else
                  s:=sl[i];
                Result:=s;
                GetKeyNames(sl);
                CloseKey;
                for j:=0 to sl.count-1 do
                  if OpenKeyReadOnly(AStartKey+'\'+s+'\'+sl[j]) then begin
                    if ValueExists(AValueName) then begin
                      v:=ReadString(AValueName);
                      if AResult.IndexOf(v)=-1 then
                        AResult.Add(v);
                    end;
                    CloseKey;
                  end;
                  Break;
              end;
            end;
            CloseKey;
          end;
        sl.free;
      end;
    end else begin
      if OpenKey(AStartKey+'\'+AClassName,false) then begin
        sl:=TStringList.Create;
        GetKeyNames(sl);
        CloseKey;
        for i:=0 to sl.Count-1 do
          if OpenKey(AStartKey+'\'+AClassName+'\'+sl[i],false) then begin
            if ValueExists(AValueName) then begin
              v:=ReadString(AValueName);
              if AResult.IndexOf(v)=-1 then
                AResult.Add(v);
            end;
            CloseKey;
          end;
        sl.free;
      end;
    end;
    free;
  end;
end;


procedure GetEnvironment(var EnvList :tstrings);
var
  c,i :dword;
  b :pchar;
  s :string;
begin
  EnvList.Clear;
  c:=4096;
  b:=GetEnvironmentStrings;
  i:=0;
  s:='';
  while i<c do begin
    if b[i]<>#0 then                             
      s:=s+b[i]
    else begin
      if s='' then
        break;
      EnvList.Add(s);
      s:='';
    end;
    inc(i);
  end;
  FreeEnvironmentStrings(b);
end;

function GetWinSysDir: string;
var
  n: integer;
  p: PChar;
begin
  n:=MAX_PATH;
  p:=stralloc(n);
  getwindowsdirectory(p,n);
  result:=p+';';
  getsystemdirectory(p,n);
  Result:=Result+p+';';
  StrDispose(p);
end;

function GetWindowInfo(wh: hwnd): TWindowInfo;
var
  cn,wn :pchar;
  n, wpid,tid :longword;
begin
  n:=255;
  wn:=allocmem(n);
  cn:=allocmem(n);
  try
  tid:=GetWindowThreadProcessId(wh,@wpid);
  getclassname(wh,cn,n);
  getwindowtext(wh,wn,n);
  Result.ClassName:=cn;
  Result.Text:=wn;
  Result.Handle:=wh;
  Result.Process:=wpid;
  Result.Thread:=tid;
  Result.ParentWin:=getwindowlong(wh,GWL_HWNDPARENT);
  Result.WndProc:=getwindowlong(wh,GWL_WNDPROC);
  Result.Instance:=getwindowlong(wh,GWL_HINSTANCE);
  Result.ID:=getwindowlong(wh,GWL_ID);
  Result.UserData:=getwindowlong(wh,GWL_USERDATA);
  Result.Style:=getwindowlong(wh,GWL_STYLE);
  Result.ExStyle:=getwindowlong(wh,GWL_EXSTYLE);
  getwindowrect(wh,Result.Rect);
  getclientrect(wh,Result.ClientRect);
  Result.Atom:=getclasslong(wh,GCW_ATOM);
  Result.ClassBytes:=getclasslong(wh,GCL_CBCLSEXTRA);
  Result.WinBytes:=getclasslong(wh,GCL_CBWNDEXTRA);
  Result.ClassWndProc:=getclasslong(wh,GCL_WNDPROC);
  Result.ClassInstance:=getclasslong(wh,GCL_HMODULE);
  Result.Background:=getclasslong(wh,GCL_HBRBACKGROUND);
  Result.Cursor:=getclasslong(wh,GCL_HCURSOR);
  Result.Icon:=getclasslong(wh,GCL_HICON);
  Result.ClassStyle:=getclasslong(wh,GCL_STYLE);
  Result.Styles:=tstringlist.create;
  Result.visible:=iswindowvisible(wh);
  if not(Result.Style and WS_BORDER=0) then
    Result.Styles.add('WS_BORDER');
  if not(Result.Style and WS_CHILD=0) then
    Result.Styles.add('WS_CHILD');
  if not(Result.Style and WS_CLIPCHILDREN=0) then
    Result.Styles.add('WS_CLIPCHILDREN');
  if not(Result.Style and WS_CLIPSIBLINGS=0) then
    Result.Styles.add('WS_CLIPSIBLINGS');
  if not(Result.Style and WS_DISABLED=0) then
    Result.Styles.add('WS_DISABLED');
  if not(Result.Style and WS_DLGFRAME=0) then
    Result.Styles.add('WS_DLGFRAME');
  if not(Result.Style and WS_GROUP=0) then
    Result.Styles.add('WS_GROUP');
  if not(Result.Style and WS_HSCROLL=0) then
    Result.Styles.add('WS_HSCROLL');
  if not(Result.Style and WS_MAXIMIZE=0) then
    Result.Styles.add('WS_MAXIMIZE');
  if not(Result.Style and WS_MAXIMIZEBOX=0) then
    Result.Styles.add('WS_MAXIMIZEBOX');
  if not(Result.Style and WS_MINIMIZE=0) then
    Result.Styles.add('WS_MINIMIZE');
  if not(Result.Style and WS_MINIMIZEBOX=0) then
    Result.Styles.add('WS_MINIMIZEBOX');
  if not(Result.Style and WS_OVERLAPPED=0) then
    Result.Styles.add('WS_OVERLAPPED');
  if not(Result.Style and WS_POPUP=0) then
    Result.Styles.add('WS_POPUP');
  if not(Result.Style and WS_SYSMENU=0) then
    Result.Styles.add('WS_SYSMENU');
  if not(Result.Style and WS_TABSTOP=0) then
    Result.Styles.add('WS_TABSTOP');
  if not(Result.Style and WS_THICKFRAME=0) then
    Result.Styles.add('WS_THICKFRAME');
  if not(Result.Style and WS_VISIBLE=0) then
    Result.Styles.add('WS_VISIBLE');
  if not(Result.Style and WS_VSCROLL=0) then
    Result.Styles.add('WS_VSCROLL');
  Result.ExStyles:=tstringlist.create;
  if Result.ExStyle>0 then begin
  if not(Result.ExStyle and WS_EX_ACCEPTFILES=0) then
    Result.ExStyles.add('WS_EX_ACCEPTFILES');
  if not(Result.ExStyle and WS_EX_DLGMODALFRAME=0) then
    Result.ExStyles.add('WS_EX_DLGMODALFRAME');
  if not(Result.ExStyle and WS_EX_NOPARENTNOTIFY=0) then
    Result.ExStyles.add('WS_EX_NOPARENTNOTIFY');
  if not(Result.ExStyle and WS_EX_TOPMOST=0) then
    Result.ExStyles.add('WS_EX_TOPMOST');
  if not(Result.ExStyle and WS_EX_TRANSPARENT=0) then
    Result.ExStyles.add('WS_EX_TRANSPARENT');
  if not(Result.ExStyle and WS_EX_MDICHILD=0) then
    Result.ExStyles.add('WS_EX_MDICHILD');
  if not(Result.ExStyle and WS_EX_TOOLWINDOW=0) then
    Result.ExStyles.add('WS_EX_TOOLWINDOW');
  if not(Result.ExStyle and WS_EX_WINDOWEDGE=0) then
    Result.ExStyles.add('WS_EX_WINDOWEDGE');
  if not(Result.ExStyle and WS_EX_CLIENTEDGE =0) then
    Result.ExStyles.add('WS_EX_CLIENTEDGE');
  if not(Result.ExStyle and WS_EX_CONTEXTHELP=0) then
    Result.ExStyles.add('WS_EX_CONTEXTHELP');
  if not(Result.ExStyle and WS_EX_RIGHT=0) then
    Result.ExStyles.add('WS_EX_RIGHT')
  else
    Result.ExStyles.add('WS_EX_LEFT');
  if not(Result.ExStyle and WS_EX_RTLREADING=0) then
    Result.ExStyles.add('WS_EX_RTLREADING')
  else
    Result.ExStyles.add('WS_EX_LTRREADING');
  if not(Result.ExStyle and WS_EX_LEFTSCROLLBAR=0) then
    Result.ExStyles.add('WS_EX_LEFTSCROLLBAR')
  else
    Result.ExStyles.add('WS_EX_RIGHTSCROLLBAR');
  if not(Result.ExStyle and WS_EX_CONTROLPARENT=0) then
    Result.ExStyles.add('WS_EX_CONTROLPARENT');
  if not(Result.ExStyle and WS_EX_STATICEDGE =0) then
    Result.ExStyles.add('WS_EX_STATICEDGE');
  if not(Result.ExStyle and WS_EX_APPWINDOW=0) then
    Result.ExStyles.add('WS_EX_APPWINDOW');
  end;
  Result.ClassStyles:=tstringlist.create;
  if not(Result.ClassStyle and CS_BYTEALIGNCLIENT=0) then
    Result.ClassStyles.add('CS_BYTEALIGNCLIENT');
  if not(Result.ClassStyle and CS_VREDRAW=0) then
    Result.ClassStyles.add('CS_VREDRAW');
  if not(Result.ClassStyle and CS_HREDRAW=0) then
    Result.ClassStyles.add('CS_HREDRAW');
  if not(Result.ClassStyle and CS_KEYCVTWINDOW=0) then
    Result.ClassStyles.add('CS_KEYCVTWINDOW');
  if not(Result.ClassStyle and CS_DBLCLKS=0) then
    Result.ClassStyles.add('CS_DBLCLKS');
  if not(Result.ClassStyle and CS_OWNDC=0) then
    Result.ClassStyles.add('CS_OWNDC');
  if not(Result.ClassStyle and CS_CLASSDC=0) then
    Result.ClassStyles.add('CS_CLASSDC');
  if not(Result.ClassStyle and CS_PARENTDC=0) then
    Result.ClassStyles.add('CS_PARENTDC');
  if not(Result.ClassStyle and CS_NOKEYCVT=0) then
    Result.ClassStyles.add('CS_NOKEYCVT');
  if not(Result.ClassStyle and CS_NOCLOSE=0) then
    Result.ClassStyles.add('CS_NOCLOSE');
  if not(Result.ClassStyle and CS_SAVEBITS=0) then
    Result.ClassStyles.add('CS_SAVEBITS');
  if not(Result.ClassStyle and CS_BYTEALIGNWINDOW=0) then
    Result.ClassStyles.add('CS_BYTEALIGNWINDOW');
  if not(Result.ClassStyle and CS_GLOBALCLASS=0) then
    Result.ClassStyles.add('CS_GLOBALCLASS');
  finally
    Freemem(wn);
    FreeMem(cn);
  end;
end;

function ResolveLink(const LinkFile: TFileName; var FileName,Arguments: string): HRESULT;
var
  psl: IShellLink;
  WLinkFile: array [0..MAX_PATH] of WideChar;
  wfd: TWIN32FINDDATA;
  ppf: IPersistFile;
begin
  pointer(psl):=nil;
  pointer(ppf):=nil;
  Result:=CoInitialize(nil);
  if Succeeded(Result) then begin
    Result:=CoCreateInstance(CLSID_ShellLink,nil,CLSCTX_INPROC_SERVER,IShellLink,psl);
    if Succeeded(Result) then begin
      Result:=psl.QueryInterface(IPersistFile,ppf);
      if Succeeded(Result) then begin
        StringToWideChar(LinkFile,WLinkFile,SizeOf(WLinkFile)-1);
        Result:=ppf.Load(WLinkFile,STGM_READ);
        if Succeeded(Result) then begin
          Result:=psl.Resolve(0,SLR_NO_UI);
          if Succeeded(Result) then begin
            SetLength(FileName,MAX_PATH);
            SetLength(Arguments,255);
            Result:=psl.GetPath(PChar(FileName),MAX_PATH,wfd,SLGP_UNCPRIORITY);
            if Succeeded(Result) then begin
              SetLength(FileName,Length(PChar(FileName)));
              Result:=psl.GetArguments(PChar(Arguments),255);
              if Succeeded(Result) then
                SetLength(Arguments,Length(PChar(Arguments)));
            end;
          end;
        end;
        ppf._Release;
      end;
      psl._Release;
    end;
    CoUnInitialize;
  end;
  pointer(psl):=nil;
  pointer(ppf):=nil;
end;

function GetSpecialFolder(Handle: Hwnd; nFolder: Integer): widestring;
var
  PIDL: PItemIDList;
  Path: LPSTR;
  Malloc: IMalloc;
begin
  Result:='';
  Path:=StrAlloc(MAX_PATH);
  SHGetSpecialFolderLocation(Handle, nFolder, PIDL);

  if SHGetPathFromIDList(PIDL, Path) then Result:=Path;

  StrDispose(Path);

  if Succeeded(SHGetMalloc(Malloc)) then
    Malloc.Free( PIDL );
end;

function GetMediaTypeStr(MT: TMediaType): string;
begin
  case MT of
    dtUnknown     :result:='<unknown>';
    dtNotExists   :result:='<not exists>';
    dtRemovable   :result:='Removable';
    dtFixed       :result:='Fixed';
    dtRemote      :result:='Remote';
    dtCDROM       :result:='CDROM';
    dtRAMDisk     :result:='RAM';
  end;
end;

function GetMediaPresent(Value: TDiskSign) :Boolean;
var
  ErrorMode: Word;
  bufRoot :pchar;
  a,b,c,d :dword;
begin
  bufRoot:=stralloc(255);
  strpcopy(bufRoot,Value+'\');
  ErrorMode:=SetErrorMode(SEM_FailCriticalErrors or SEM_NoOpenFileErrorBox); 
  try
    try
      result:=GetDiskFreeSpace(bufRoot,a,b,c,d);
    except
      result:=False;
    end;
  finally
    strdispose(bufroot);
    SetErrorMode(ErrorMode);
  end;
end;

function GetDiskInfo(Value: TDiskSign): TDiskInfo;
var
  BPS,TC,FC,SPC :integer;
  T,F :TLargeInteger;
  TF :PLargeInteger;
  bufRoot, bufVolumeLabel, bufFileSystem :pchar;
  MCL,Size,Flags :DWORD;
  s :string;
begin
  with Result do begin
    Sign:=Value;
    Size:=255;
    bufRoot:=AllocMem(Size);
    bufVolumeLabel:=AllocMem(Size);
    bufFileSystem:=AllocMem(Size);
    strpcopy(bufRoot,Value+'\');
    try
    case GetDriveType(bufRoot) of
      DRIVE_UNKNOWN     :MediaType:=dtUnknown;
      DRIVE_NO_ROOT_DIR :MediaType:=dtNotExists;
      DRIVE_REMOVABLE   :MediaType:=dtRemovable;
      DRIVE_FIXED       :MediaType:=dtFixed;
      DRIVE_REMOTE      :MediaType:=dtRemote;
      DRIVE_CDROM       :MediaType:=dtCDROM;
      DRIVE_RAMDISK     :MediaType:=dtRAMDisk;
    end;
    FileFlags:=[];
    if GetMediaPresent(Value) then begin
      GetDiskFreeSpace(bufRoot,SectorsPerCluster,BytesPerSector,FreeClusters,TotalClusters);
      try
        new(TF);
        SysUtils.GetDiskFreeSpaceEx(bufRoot,F,T,TF);
        Capacity:=T;
        FreeSpace:=F;
        dispose(TF);
      except
        BPS:=BytesPerSector;
        TC:=TotalClusters;
        FC:=FreeClusters;
        SPC:=SectorsPerCluster;
        Capacity:=TC*SPC*BPS;
        FreeSpace:=FC*SPC*BPS;
      end;
      if GetVolumeInformation(bufRoot,bufVolumeLabel,Size,@Serial,MCL,Flags,bufFileSystem,Size) then begin;
        VolumeLabel:=bufVolumeLabel;
        FileSystem:=bufFileSystem;
        s:=IntToHex(Serial,8);
        SerialNumber:=copy(s,1,4)+'-'+copy(s,5,4);
        if Flags and FS_CASE_SENSITIVE=FS_CASE_SENSITIVE then
          FileFlags:=FileFlags+[fsCaseSensitive];
        if Flags and FS_CASE_IS_PRESERVED=FS_CASE_IS_PRESERVED then
          FileFlags:=FileFlags+[fsCaseIsPreserved];
        if Flags and FS_UNICODE_STORED_ON_DISK=FS_UNICODE_STORED_ON_DISK then
          FileFlags:=FileFlags+[fsUnicodeStoredOnDisk];
        if Flags and FS_PERSISTENT_ACLS=FS_PERSISTENT_ACLS then
          FileFlags:=FileFlags+[fsPersistentAcls];
        if Flags and FS_VOL_IS_COMPRESSED=FS_VOL_IS_COMPRESSED then
          FileFlags:=FileFlags+[fsVolumeIsCompressed];
        if Flags and FS_FILE_COMPRESSION=FS_FILE_COMPRESSION then
          FileFlags:=FileFlags+[fsFileCompression];
        if MCL=255 then
          FileFlags:=FileFlags+[fsLongFileNames];
        if Flags and FILE_SUPPORTS_ENCRYPTION=FILE_SUPPORTS_ENCRYPTION then
          FileFlags:=FileFlags+[fsEncryptedFileSystemSupport];
        if Flags and FILE_SUPPORTS_OBJECT_IDS=FILE_SUPPORTS_OBJECT_IDS then
          FileFlags:=FileFlags+[fsObjectIDsSupport];
        if Flags and FILE_SUPPORTS_REPARSE_POINTS=FILE_SUPPORTS_REPARSE_POINTS then
          FileFlags:=FileFlags+[fsReparsePointsSupport];
        if Flags and FILE_SUPPORTS_SPARSE_FILES=FILE_SUPPORTS_SPARSE_FILES then
          FileFlags:=FileFlags+[fsSparseFilesSupport];
        if Flags and FILE_VOLUME_QUOTAS=FILE_VOLUME_QUOTAS then
          FileFlags:=FileFlags+[fsDiskQuotasSupport];
      end;
    end else begin
      SectorsPerCluster:=0;
      BytesPerSector:=0;
      FreeClusters:=0;
      TotalClusters:=0;
      Capacity:=0;
      FreeSpace:=0;
      VolumeLabel:='';
      SerialNumber:='';
      FileSystem:='';
      Serial:=0;
    end;
    finally
      FreeMem(bufVolumeLabel);
      FreeMem(bufFileSystem);
      FreeMem(bufRoot);
    end;
  end;
end;

function GetWinDir :string;
var
  n :dword;
  p :pchar;
begin
  n:=MAX_PATH;
  p:=stralloc(n);
  getwindowsdirectory(p,n);
  result:=p;
  strdispose(p);
end;

function GetSysDir :string;
var
  n :dword;
  p :pchar;
begin
  n:=MAX_PATH;
  p:=stralloc(n);
  getsystemdirectory(p,n);
  result:=p;
  strdispose(p);
end;

function GetTempDir :string;
var
  n :dword;
  p :pchar;
begin
  n:=MAX_PATH;
  p:=stralloc(n);
  gettemppath(n,p);
  result:=p;
  strdispose(p);
end;

function ExpandEnvVars(AEnvironment: TStrings; ASource: string): string; overload;
var
  i,p: integer;
  s: string;
begin
  for i:=0 to AEnvironment.Count-1 do begin
    if Trim(AEnvironment.Names[i])<>'' then begin
      s:='%'+AEnvironment.Names[i]+'%';
      p:=Pos(s,ASource);
      if p>0 then
        ASource:=Copy(ASource,1,p-1)+AEnvironment.Values[AEnvironment.names[i]]+Copy(ASource,p+Length(s),1024)
      else begin
        s:='\'+AEnvironment.Names[i];
        p:=Pos(s,ASource);
        if p>0 then
          ASource:=Copy(ASource,1,p-1)+AEnvironment.Values[AEnvironment.names[i]]+Copy(ASource,p+Length(s),1024);
      end;
    end;
  end;
  Result:=ASource;
end;

function GetEnvVarValue(Name: string): string;
var
  sl: TStrings;
begin
  sl:=TStringList.Create;
  GetEnvironment(sl);
  Result:=sl.Values[Name];
  sl.Free;
end;

function ExpandEnvVars(ASource: string): string; overload;
var
  i,p: integer;
  sl: TStrings;
  s: string;
begin
  sl:=TStringList.Create;
  GetEnvironment(sl);
  for i:=0 to sl.Count-1 do begin
    if Trim(sl.Names[i])<>'' then begin
      s:='%'+sl.Names[i]+'%';
      p:=Pos(s,ASource);
      if p>0 then
        ASource:=Copy(ASource,1,p-1)+sl.Values[sl.names[i]]+Copy(ASource,p+Length(s),1024)
      else begin
        s:='\'+sl.Names[i];
        p:=Pos(s,ASource);
        if p>0 then
          ASource:=Copy(ASource,1,p-1)+sl.Values[sl.names[i]]+Copy(ASource,p+Length(s),1024);
      end;
    end;
  end;
  Result:=ASource;
  sl.Free;
end;

function GetProfilePath;
var
  s: string;
begin
  s:=GetSpecialFolder(GetDesktopWindow,CSIDL_DESKTOP);
  s:=ReverseString(s);
  Result:=ReverseString(Copy(s,Pos('\',s)+1,255));
end;

function GetAvailDisks :string;
var
  i,n :integer;
  buf :pchar;
begin
  buf:=stralloc(255);
  n:=GetLogicalDriveStrings(255,buf);
  result:='';
  for i:=0 to n do
    if buf[i]<>#0 then begin
      if (ord(buf[i]) in [$41..$5a]) or (ord(buf[i]) in [$61..$7a]) then
        result:=result+upcase(buf[i])
    end else
      if buf[i+1]=#0 then
        break;
  strdispose(buf);
end;

procedure GetCDs(cds :tstrings);
var
  i :integer;
  root :pchar;
  s :string;
begin
  root:=stralloc(255);
  s:=getavaildisks;
  cds.clear;
  for i:=1 to length(s) do begin
    strpcopy(root,copy(s,i,1)+':\');
    if getdrivetype(root)=drive_cdrom then
      cds.add(copy(root,1,length(root)-1));
  end;
  strdispose(root);
end;

function KillProcess;
var
  ProcessHandle: THandle;

  function EnumWindowsProc(Wnd: HWND; ProcessID: DWORD): Boolean; stdcall;
  var
    PID: DWORD;
  begin
    GetWindowThreadProcessId(Wnd, @PID);
    if ProcessID=PID then
      PostMessage(Wnd,WM_CLOSE,0,0);
    Result:=True;
  end;

begin
  Result:=tsError;
  if ProcessID<>GetCurrentProcessId then begin
    ProcessHandle:=OpenProcess(SYNCHRONIZE or PROCESS_TERMINATE, False, ProcessID);
    try
      if ProcessHandle<>0 then begin
        if Timeout>=0 then begin
          EnumWindows(@EnumWindowsProc,LPARAM(ProcessID));
          if WaitForSingleObject(ProcessHandle,Timeout)=WAIT_OBJECT_0 then
            Result:=tsClose
          else
            if TerminateProcess(ProcessHandle,0) then
              Result:=tsTerminate;
        end else
          if TerminateProcess(ProcessHandle,0) then
            Result:=tsTerminate;
      end;
    finally
      CloseHandle(ProcessHandle);
    end;
  end;
end;


function IsProcessActive;
var
  ph: THandle;
begin
  ph:=OpenProcess(PROCESS_QUERY_INFORMATION,False,APID);
  Result:=ph<>0;
  Closehandle(ph);
end;

procedure GetFileInfo;
var
  FI :TBYHANDLEFILEINFORMATION;
  shinfo :TSHFileInfo;
  h :THandle;
  ii :word;
  q :array [0..MAX_PATH - 1] of char;
begin
  h:=FileOpen(AFilename,fmOpenRead or fmShareDenyNone);
  if h<>UINT(-1) then
    with AFileInfo do begin
      ii:=0;
      strpcopy(q,AFilename);
      if extracticon(hinstance,q,word(-1))>0 then
        iconhandle:=extracticon(hinstance,PChar(AFilename),ii)
      else
        iconhandle:=ExtractAssociatedIcon(hInstance,q,ii);
      if ShGetFileInfo(q,0,ShInfo,SizeOf(ShInfo),SHGFI_TYPENAME)<>0 then
        FileType:=ShInfo.szTypeName
      else
        FileType:='';
      GetFileInformationByHandle(h,FI);
      FileClose(h);
      Size:=FI.nFileSizelow+256*FI.nFileSizehigh;
      Attributes:=FI.dwFileAttributes;
      Created:=FileTimeToDateTime(FI.ftCreationTime);
      Accessed:=FileTimeToDateTime(FI.ftLastAccessTime);
      Modified:=FileTimeToDateTime(FI.ftLastWriteTime);
      BinaryType:=GetBinType(Afilename);
    end;
end;

function GetFileIconCount;
begin
  Result:=ExtractIcon(HInstance,PChar(Filename),uint(-1));
end;

function GetFileIcon;
begin
  if extracticon(HInstance,PChar(Filename),word(-1))>0 then
    result:=extracticon(hinstance,PChar(Filename),IconIndex)
  else
    result:=ExtractAssociatedIcon(HInstance,PChar(Filename),IconIndex);
end;

function GetFileSize;
var
  FI :TBYHANDLEFILEINFORMATION;
  h :THandle;
begin
  Result:=-1;
  h:=FileOpen(AFilename,fmOpenRead or fmShareDenyNone);
  if h<>UINT(-1) then begin
    GetFileInformationByHandle(h,FI);
    FileClose(h);
    Result:=FI.nFileSizelow+256*FI.nFileSizehigh;
  end;
end;

function HasAttr;
begin
  Result:=(FileGetAttr(AFileName) and AAttr)=AAttr;
end;

function GetBinType;
var
  BinaryType: DWORD;
  fi :TSHFileInfo;
const
  IMAGE_DOS_SIGNATURE    = $5A4D; // MZ
  IMAGE_OS2_SIGNATURE    = $454E; // NE
  IMAGE_VXD_SIGNATURE    = $454C; // LE
  IMAGE_NT_SIGNATURE     = $0000; // PE
  IMAGE_32_SIGNATURE     = $4550;
begin
  binarytype:=SHGetFileInfo(PChar(AFilename),0,fi,sizeof(fi),SHGFI_EXETYPE);
  result:='';
  if binarytype<>0 then
    case loword(binarytype) of
      IMAGE_DOS_SIGNATURE: result:='DOS Executable';
      IMAGE_VXD_SIGNATURE: result:='Virtual Device Driver';
      IMAGE_OS2_SIGNATURE,IMAGE_NT_SIGNATURE, IMAGE_32_SIGNATURE:
      case hiword(binarytype) of
        $400: result:='Win32 Executable';
        $30A,$300: result:='Win16 Executable';
        $0 :result:='Win32 Console Executable';
      end;
    end;
  if Result='' then
    if GetBinaryType(Pchar(AFilename),Binarytype) then
      case BinaryType of
        SCS_32BIT_BINARY: result:= 'Win32 Executable';
        SCS_DOS_BINARY  : result:= 'DOS Executable';
        SCS_WOW_BINARY  : result:= 'Win16 Executable';
        SCS_PIF_BINARY  : result:= 'PIF File';
        SCS_POSIX_BINARY: result:= 'POSIX Executable';
        SCS_OS216_BINARY: result:= 'OS/2 16 bit Executable'
      end;
end;

function ExtractUNCFilename;
var
  p,l :integer;
begin
  p:=pos(':',ASource);
  if p>0 then begin
    l:=Length(ASource);
    result:=Copy(ASource,p-1,l-p+2);
  end else
    result:=ASource;
end;

function DequoteStr(Source: string; Quote: Char = '"'): string;
begin
  Result:=Source;
  if Length(Source)>1 then
    if (Source[1]=Quote) and (Source[Length(Source)]=Quote) then
      Result:=Copy(Source,2,Length(Source)-2);
end;

function ExtractFilenameFromStr(Source: string): string;
var
  s: string;
begin
  s:=ExpandEnvVars(Source);
  while not FileExists(s) and (Length(s)>0) do begin
    Delete(s,Length(s),1);
    s:=DequoteStr(s);
  end;
  if Length(s)<>0 then
    Result:=s
  else
    Result:='';
end;

function ExtractName;
var
  p :integer;
begin
  result:=extractfilename(AFilename);
  p:=pos('.',result);
  if p>0 then
    result:=copy(result,1,p-1);
end;



function FileCopy;
var
  CopyBuffer: Pointer;
  BytesCopied: Longint;
  Source, Dest: Integer;
  Destination: TFileName;
const
  ChunkSize: Longint = 8192;
begin
  Result:=False;
  Destination := ExpandFileName(ADestName);
{  if HasAttr(Destination, faDirectory) then
    Destination := UniPath(Destination,true) + ExtractFileName(AFileName);}
  GetMem(CopyBuffer, ChunkSize);
  try
    Source:=FileOpen(AFileName, fmShareDenyNone);
    if not(Source<0) then
      try
        Dest:=FileCreate(Destination);
        if not(Dest<0) then
          try
            repeat
              BytesCopied:=FileRead(Source, CopyBuffer^, ChunkSize);
              if BytesCopied>0 then
                 FileWrite(Dest, CopyBuffer^, BytesCopied);
             until BytesCopied<ChunkSize;
             Result:=True;
          finally
            FileClose(Dest);
          end;
        finally
          FileClose(Source);
        end;
  finally
    FreeMem(CopyBuffer, ChunkSize);
  end;
end;

function FileMove;
var
  Destination: string;
begin
  Result:=True;
  Destination := ExpandFileName(ADestName);
  if not RenameFile(AFileName, Destination) then begin
    if HasAttr(AFileName, faReadOnly) then begin
      Result:=False;
      Exit;
    end;
    Result:=FileCopy(AFileName, Destination);
    if Result then
      DeleteFile(AFilename);
  end;
end;

function FileNameMove;
var
  SR: TSearchRec;
  s,t: string;
begin
  Result:=0;
  s:=ExtractFilePath(AFileName);
  t:=ExtractFilePath(ADestName);
  if FindFirst(ChangeFileExt(AFileName,'.*'),faArchive,SR)=0 then begin
    if FileMove(s+SR.Name,t+SR.Name) then
      Inc(Result);
    while FindNext(SR)=0 do begin
      if FileMove(s+SR.Name,t+SR.Name) then
        Inc(Result);
    end;
  end;
  FindClose(SR);
end;

function FileNameCopy;
var
  SR: TSearchRec;
  s,t: string;
begin
  Result:=0;
  s:=ExtractFilePath(AFileName);
  t:=ExtractFilePath(ADestName);
  if FindFirst(ChangeFileExt(AFileName,AExtSpec),faArchive,SR)=0 then begin
    if FileCopy(s+SR.Name,t+SR.Name) then
      Inc(Result);
    while FindNext(SR)=0 do
      if FileCopy(s+SR.Name,t+SR.Name) then
        Inc(Result);
  end;
  FindClose(SR);
end;

function IsBitOn (Value: Integer; Bit: Byte): Boolean;
begin
  Result:=(Value and (1 shl Bit))<>0;
end;


function CreateDOSProcessRedirected(const CommandLine, InputFile, OutputFile,
   ErrMsg :string): boolean;
const
  ROUTINE_ID = '[function: CreateDOSProcessRedirected]';
var
  pCommandLine: array[0..MAX_PATH] of char;
  pInputFile,
  pOutPutFile: array[0..MAX_PATH] of char;
  StartupInfo: TStartupInfo;
  ProcessInfo: TProcessInformation;
  SecAtrrs: TSecurityAttributes;
  hAppProcess,
  hAppThread,
  hInputFile,
  hOutputFile   : THandle;
begin
  Result := FALSE;
  if (InputFile<>'') and (not FileExists(InputFile)) then
    raise Exception.CreateFmt(ROUTINE_ID + #10 + #10 +
       'Input file * %s *' + #10 +
       'does not exist' + #10 + #10 +
       ErrMsg, [InputFile]);
  hAppProcess:=0;
  hAppThread:=0;
  hInputFile:=0;
  hOutputFile:=0;
  try
    StrPCopy(pCommandLine, CommandLine);
    StrPCopy(pInputFile, InputFile);
    StrPCopy(pOutPutFile, OutputFile);
    { prepare SecAtrrs structure for the CreateFile calls.  This SecAttrs
      structure is needed in this case because we want the returned handle to
      be inherited by child process. This is true when running under WinNT.
      As for Win95, the parameter is ignored. }
    FillChar(SecAtrrs,SizeOf(SecAtrrs),#0);
    SecAtrrs.nLength:=SizeOf(SecAtrrs);
    SecAtrrs.lpSecurityDescriptor:=nil;
    SecAtrrs.bInheritHandle:=TRUE;
    if InputFile<>'' then begin
      hInputFile:=CreateFile(
         pInputFile,                          { pointer to name of the file }
         GENERIC_READ or GENERIC_WRITE,       { access (read-write) mode }
         FILE_SHARE_READ or FILE_SHARE_WRITE, { share mode }
         @SecAtrrs,                           { pointer to security attributes }
         OPEN_ALWAYS,                         { how to create }
         FILE_ATTRIBUTE_NORMAL
         or FILE_FLAG_WRITE_THROUGH,          { file attributes }
         0);                                 { handle to file with attrs to copy }
      if hInputFile = INVALID_HANDLE_VALUE then
        raise Exception.CreateFmt(ROUTINE_ID + #10 +  #10 +
           'WinApi function CreateFile returned an invalid handle value' + #10 +
           'for the input file * %s *' + #10 + #10 +
            ErrMsg, [InputFile]);
    end else
      hInputFile:=0;

    hOutputFile:=CreateFile(
       pOutPutFile,                         { pointer to name of the file }
       GENERIC_READ or GENERIC_WRITE,       { access (read-write) mode }
       FILE_SHARE_READ or FILE_SHARE_WRITE, { share mode }
       @SecAtrrs,                           { pointer to security attributes }
       CREATE_ALWAYS,                       { how to create }
       FILE_ATTRIBUTE_NORMAL
       or FILE_FLAG_WRITE_THROUGH,          { file attributes }
       0 );                                 { handle to file with attrs to copy }
    if hOutputFile=INVALID_HANDLE_VALUE then
      raise Exception.CreateFmt(ROUTINE_ID + #10 +  #10 +
         'WinApi function CreateFile returned an invalid handle value'  + #10 +
         'for the output file * %s *' + #10 + #10 +
         ErrMsg, [OutputFile]);

    FillChar(StartupInfo, SizeOf(StartupInfo), #0);
    StartupInfo.cb:=SizeOf(StartupInfo);
    StartupInfo.dwFlags:=STARTF_USESHOWWINDOW or STARTF_USESTDHANDLES;
    StartupInfo.wShowWindow:=SW_HIDE;
    StartupInfo.hStdOutput:=hOutputFile;
    StartupInfo.hStdInput:=hInputFile;

    Result:=CreateProcess(
       NIL,                           { pointer to name of executable module }
       pCommandLine,                  { pointer to command line string }
       NIL,                           { pointer to process security attributes }
       NIL,                           { pointer to thread security attributes }
       TRUE,                          { handle inheritance flag }
       HIGH_PRIORITY_CLASS,           { creation flags }
       NIL,                           { pointer to new environment block }
       NIL,                           { pointer to current directory name }
       StartupInfo,                   { pointer to STARTUPINFO }
       ProcessInfo);                  { pointer to PROCESS_INF }

    if Result then begin
      WaitforSingleObject(ProcessInfo.hProcess,INFINITE);
      hAppProcess:=ProcessInfo.hProcess;
      hAppThread:=ProcessInfo.hThread;
    end else
      raise Exception.Create(ROUTINE_ID + #10 +  #10 +
         'Function failure'  + #10 +  #10 + ErrMsg);
  finally
    if hOutputFile <> 0 then
      CloseHandle(hOutputFile);
    if hInputFile <> 0 then
      CloseHandle(hInputFile);
    if hAppThread <> 0 then
      CloseHandle(hAppThread);
    if hAppProcess <> 0 then
      CloseHandle(hAppProcess);
  end;
end;

function OpenMailSlot(Const Server, Slot : String): THandle;
var
  FullSlot : String;
begin
  FullSlot := '\\'+Server+'\mailslot\'+Slot;
  Result := CreateFile(
    PChar(FullSlot),
    GENERIC_WRITE,
    FILE_SHARE_READ,
    NIL,
    OPEN_EXISTING,
    FILE_ATTRIBUTE_NORMAL,
    0                    );
end;

function SendToMailSlot(Const Server, Slot, Mail : String) : Boolean;
var
  hToSlot : THandle;
  BytesWritten : DWord;
begin
  Result := False;
  hToSlot := OpenMailSlot(Server,Slot);
  If hToSlot = INVALID_HANDLE_VALUE Then
    Exit;
  try
    BytesWritten := 0;
    if (NOT WriteFile(hToSlot,
                      Pointer(Mail)^,
                      Length(Mail),
                      BytesWritten,
                      NIL))         OR
        (INTEGER(BytesWritten) <> Length(Mail)) Then
      Exit;
    Result := True;
  finally
    CloseHandle(hToSlot);
  end;
end;

function SendToWinpopup(Server, Reciever, Sender, Msg : String) : Boolean;
var
  szserver,szsender,szreciever,szmsg :pchar;
begin
  szserver:=stralloc(255);
  szsender:=stralloc(255);
  szreciever:=stralloc(255);
  szmsg:=stralloc(255);
  CharToOEM(PChar(Server),szServer);
  CharToOEM(PChar(Sender),szSender);
  CharToOEM(PChar(Reciever),szReciever);
  CharToOEM(PChar(Msg),szMsg);
  Result := SendToMailSlot(Server, wpslot, szSender+#0+szReciever+#0+szMsg);
  strdispose(szserver);
  strdispose(szsender);
  strdispose(szreciever);
  strdispose(szmsg);
end;

function GetFontRes: DWORD;
var
  tm: TTextMetric;
  hwnd,hdc: THandle;
  MapMode: DWORD;
begin
  Result:=0;
  hwnd:=GetDesktopWindow;
  hdc:=GetWindowDC(hwnd);
  if hdc>0 then begin
    MapMode:=SetMapMode(hdc,MM_TEXT);
    GetTextMetrics(hdc,tm);
    SetMapMode(hdc,MapMode);
    ReleaseDC(hwnd,hdc);
    Result:=tm.tmHeight;
  end;
end;

procedure RunAtStartup;
begin
  with TRegistry.Create do begin
    RootKey:=AKey;
    if OpenKey('\Software\Microsoft\Windows\CurrentVersion\Run',False) then begin
      if Flag then
        WriteString(Name,CmdLine)
      else
        DeleteValue(Name);
      CloseKey;
    end;
    Free;
  end;
end;

function CheckRunAtStartup;
begin
  Result:=False;
  with TRegistry.Create do begin
    RootKey:=AKey;
    if OpenKeyReadOnly('\Software\Microsoft\Windows\CurrentVersion\Run') then begin
      if ValueExists(Name) then
        Result:=UpperCase(ReadString(Name))=UpperCase(CmdLine);
      CloseKey;
    end;
    Free;
  end;
end;

function GetDefaultMailClient: string;
const
  rk = {HKEY_CLASSES_ROOT}'\mailto\shell\open\command';
begin
  Result:='';
  with TRegistry.Create do begin
    Rootkey:=HKEY_CLASSES_ROOT;
    if OpenKeyReadOnly(rk) then begin
      Result:=ExtractFilenameFromStr(ReadString(''));
      CloseKey;
    end;
    Free;
  end;
end;

function GetDefaultBrowser: string;
const
  rk = {HKEY_CLASSES_ROOT}'\htmlfile\shell\open\command';
begin
  Result:='';
  with TRegistry.Create do begin
    Rootkey:=HKEY_CLASSES_ROOT;
    if OpenKeyReadOnly(rk) then begin
      Result:=ExtractFilenameFromStr(ReadString(''));
      CloseKey;
    end;
    Free;
  end;
end;

const
  cERROR_BUFFER_TOO_SMALL =  603;
  cRAS_MaxEntryName       =  256;
  cRAS_MaxDeviceName      =  128;
  cRAS_MaxDeviceType      =  16;

type
  HRASConn = DWord;
  PRASConn = ^TRASConn;
  TRASConn = record
    dwSize: DWORD;
    rasConn: HRASConn;
    szEntryName: Array[0..cRAS_MaxEntryName] Of Char;
    szDeviceType : Array[0..cRAS_MaxDeviceType] Of Char;
    szDeviceName : Array [0..cRAS_MaxDeviceName] of char;
  end;

  TRasEnumConnections =  function (RASConn: PrasConn;     { buffer to receive Connections data }
                                   var BufSize: DWord;    { size in bytes of buffer }
                                   var Connections: DWord { number of Connections written to buffer }
                                   ): LongInt; stdcall;


function RasConnectionCount: Integer;
var
  RasDLL: HInst;
  Conns: Array[1..4] of TRasConn;
  RasEnums: TRasEnumConnections;
  BufSize: DWord;
  NumConns: DWord;
  RasResult: Longint;
begin
  Result:=0;
  RasDLL:=LoadLibrary('rasapi32.dll');
  if RasDLL<>0 then
    try
      RasEnums:=GetProcAddress(RasDLL,'RasEnumConnectionsA');
      if @RasEnums<>nil then begin
        Conns[1].dwSize:=Sizeof(Conns[1]);
        BufSize:=SizeOf(Conns);
        RasResult:=RasEnums(PRASConn(@Conns),BufSize,NumConns);
        if (RasResult=0) or (Result=cERROR_BUFFER_TOO_SMALL) then
          Result:=NumConns;
      end;
  finally
    FreeLibrary(RasDLL);
  end;
end;

function GetConnectionType: TConnectionType;
const
  rkIS = {HKEY_CURRENT_USER}'\Software\Microsoft\Windows\CurrentVersion\Internet settings';
  rvProxy = 'ProxyEnable';
  rvProxyServer = 'ProxyServer';
var
  i: DWORD;
begin
  Result:=ctNone;
  with TRegistry.Create do
  try
    try
      RootKey:=HKEY_CURRENT_USER;
      if OpenKeyReadOnly(rkIS) then begin
        if GetDataType(rvProxy) = rdBinary then
          ReadBinaryData(rvProxy,i,SizeOf(DWORD))
        else
          i:=Integer(ReadBool(rvProxy));
        if (i<>0) and (ReadString(rvProxyServer)<>'') then
          Result:=ctLAN;
        CloseKey;
      end;
    except

    end;
  finally
    Free;
  end;

  if Result=ctNone then begin
    if RasConnectionCount>0 then
      Result:=ctDialup;
  end;
end;

function GetProxyServer: string;
const
  rkIS = {HKEY_CURRENT_USER}'\Software\Microsoft\Windows\CurrentVersion\Internet settings';
  rvProxyServer = 'ProxyServer';
begin
  Result:='';
  with TRegistry.Create do begin
    RootKey:=HKEY_CURRENT_USER;
    if OpenKeyReadOnly(rkIS) then BEGIN
      Result:=ReadString(rvProxyserver);
      CloseKey;
    end;
    Free;
  end;
end;

function GetUniqueFilename;
var
  p: PChar;
begin
  p:=AllocMem(MAX_PATH+1);
  GetTempFileName(PChar(GetTempDir),PChar(Prefix),Unique,p);
  if Temp then
    Result:=p
  else
    Result:=ExtractFilename(p);
  Freemem(p);
end;

function FileExistsEx;
var
  shinfo :TSHFileInfo;
begin
  if FileName='' then
    Result:=False
  else
    Result:=ShGetFileInfo(PChar(FileName),0,ShInfo,SizeOf(ShInfo),SHGFI_TYPENAME)<>0;
end;

function Init9xPerfData;
var
  rc, dwType, cbData: DWORD;
  hOpen: HKEY;
  pB: PByte;
begin
  rc:=RegOpenKeyEx(HKEY_DYN_DATA,StartStat,0,KEY_READ,hOpen);
  if (rc=ERROR_SUCCESS) then begin
    rc:=RegQueryValueEx(hOpen,PChar(ObjCounter),nil,@dwType,nil,@cbData);
    if (rc=ERROR_SUCCESS) then begin
      pB:=AllocMem(cbData);
      rc:=RegQueryValueEx(hOpen,PChar(ObjCounter),nil,@dwType,pB,@cbData);
      FreeMem(pB);
    end else
      raise Exception.Create('Unable to read performance data');
    RegCloseKey(hOpen);
  end else
    raise Exception.Create('Unable to start performance monitoring');
  Result:=rc=ERROR_SUCCESS;
end;

function Get9xPerfData;
var
  rc, dwType, cbData: DWORD;
  hOpen: HKEY;
  Buffer: DWORD;
begin
  rc:=RegOpenKeyEx(HKEY_DYN_DATA,StatData,0,KEY_READ,hOpen);
  if (rc=ERROR_SUCCESS) then begin
    cbData:=sizeof(DWORD);
    rc:=RegQueryValueEx(hOpen,PChar(ObjCounter),nil,@dwType,PBYTE(@Buffer),@cbData);
    RegCloseKey(hOpen);
    if (rc=ERROR_SUCCESS) then
      Result:=Buffer
    else
      Result:=-1;
  end else
    Result:=-1;
end;

function Release9xPerfData;
var
  rc, dwType, cbData: DWORD;
  hOpen: HKEY;
  pB: PByte;
begin
  rc:=RegOpenKeyEx(HKEY_DYN_DATA,StopStat,0,KEY_READ,hOpen);
  if (rc=ERROR_SUCCESS) then begin
    rc:=RegQueryValueEx(hOpen,PChar(ObjCounter),nil,@dwType,nil,@cbData);
    if (rc=ERROR_SUCCESS) then begin
      pB:=AllocMem(cbData);
      rc:=RegQueryValueEx(hOpen,PChar(ObjCounter),nil,@dwType,pB,@cbData);
      FreeMem(pB);
    end;
    RegCloseKey(hOpen);
  end;
  Result:=rc=ERROR_SUCCESS;
end;

function WinExecAndWait32;
var
  zParams,zAppName: array[0..512] of char;
  StartupInfo: TStartupInfo;
  ProcessInfo: TProcessInformation;
begin
  StrPCopy(zAppName, FileName+' '+Parameters);
  StrPCopy(zParams, Parameters);
  FillChar(StartupInfo, Sizeof(StartupInfo), #0);
  StartupInfo.cb := Sizeof(StartupInfo);
  StartupInfo.dwFlags := STARTF_USESHOWWINDOW;
  StartupInfo.wShowWindow := Visibility;
  if not CreateProcess(nil, zAppName, nil, nil, false, CREATE_NEW_CONSOLE or
                                          NORMAL_PRIORITY_CLASS, nil, nil, StartupInfo, ProcessInfo) then
    Result := uint(-1)
  else begin
    WaitforSingleObject(ProcessInfo.hProcess, INFINITE);
    GetExitCodeProcess(ProcessInfo.hProcess, Result);
    CloseHandle( ProcessInfo.hProcess );
    CloseHandle( ProcessInfo.hThread );
  end;
end;

function FileTimeToDateTimeStr(FileTime: TFileTime): string;
var
  LocFTime: TFileTime;
  SysFTime: TSystemTime;
  DateStr: string;
  TimeStr: string;
  FDateTimeStr: string;
  Dt, Tm: TDateTime;
begin
  FileTimeToLocalFileTime(FileTime, LocFTime);
  FileTimeToSystemTime(LocFTime, SysFTime);
  try
    with SysFTime do begin
      Dt := EncodeDate(wYear, wMonth, wDay);
      DateStr := DateToStr(Dt);
      Tm := EncodeTime(wHour, wMinute, wSecond, wMilliseconds);
      Timestr := TimeToStr(Tm);
      FDateTimeStr := DateStr + '   ' + TimeStr;
    end;
    Result := DateTimeToStr(StrToDateTime(FDateTimeStr));
  except
    Result := '';
  end;
end;

function FiletimeToDateTime(FT: FILETIME): TDateTime;
var
  st: SYSTEMTIME;
  dt1,dt2: TDateTime;
begin
  FileTimeToSystemTime(FT,st);
  try
    dt1:=EncodeTime(st.whour,st.wminute,st.wsecond,st.wMilliseconds);
  except
    dt1:=0;
  end;
  try
    dt2:=EncodeDate(st.wyear,st.wmonth,st.wday);
  except
    dt2:=0;
  end;
  Result:=dt1+dt2;
end;

function IsAdmin: Boolean;
const
  SECURITY_NT_AUTHORITY: TSIDIdentifierAuthority =
    (Value: (0, 0, 0, 0, 0, 5));
  SECURITY_BUILTIN_DOMAIN_RID = $00000020;
  DOMAIN_ALIAS_RID_ADMINS     = $00000220;
var
  hAccessToken: THandle;
  ptgGroups: PTokenGroups;
  dwInfoBufferSize: DWORD;
  psidAdministrators: PSID;
  x: Integer;
  bSuccess: BOOL;
begin
  Result := False;
  bSuccess := OpenThreadToken(GetCurrentThread, TOKEN_QUERY, True,
    hAccessToken);
  if not bSuccess then
  begin
    if GetLastError = ERROR_NO_TOKEN then
    bSuccess := OpenProcessToken(GetCurrentProcess, TOKEN_QUERY,
      hAccessToken);
  end;
  if bSuccess then
  begin
    GetMem(ptgGroups, 1024);
    bSuccess := GetTokenInformation(hAccessToken, TokenGroups,
      ptgGroups, 1024, dwInfoBufferSize);
    CloseHandle(hAccessToken);
    if bSuccess then
    begin
      AllocateAndInitializeSid(SECURITY_NT_AUTHORITY, 2,
        SECURITY_BUILTIN_DOMAIN_RID, DOMAIN_ALIAS_RID_ADMINS,
        0, 0, 0, 0, 0, 0, psidAdministrators);
      {$R-}
      for x := 0 to ptgGroups.GroupCount - 1 do
        if EqualSid(psidAdministrators, ptgGroups.Groups[x].Sid) then
        begin
          Result := True;
          Break;
        end;
      {$R+}
      FreeSid(psidAdministrators);
    end;
    FreeMem(ptgGroups);
  end;
end;

function GetProcessPrivileges;
const
  TokenSize = $1000; //  (SizeOf(Pointer)=4 *200)
var
  hToken: THandle;
  pTokenInfo: PTokenPrivileges;
  ReturnLen: Cardinal;
  i,j: Integer;
  PrivName,
  DisplayName: array[0..255] of Char;
  NameSize: Cardinal;
  DisplSize: Cardinal;
  LangId: Cardinal;
  priv: PLUIDAndAttributes;
  ok: Boolean;
begin
  Result:=False;
  SetLength(AList,0);
  if OpenProcessToken(ProcessHandle,TOKEN_QUERY,hToken) then begin
    GetMem(pTokenInfo,TokenSize);
    try
      if GetTokenInformation(hToken,TokenPrivileges,pTokenInfo,TokenSize,ReturnLen) then begin
        priv:=PLUIDAndAttributes(PChar(pTokenInfo)+SizeOf(DWORD));
        for i:=0 to pTokenInfo.PrivilegeCount-1 do begin
          j:=0;
          ok:=LookupPrivilegeName(nil,priv.Luid,PChar(@PrivName),Namesize);
          while not ok do begin
            Inc(j);
            if j>10 then
              Break;
            ok:=LookupPrivilegeName(nil,priv.Luid,PChar(@PrivName),Namesize);
          end;
          LookupPrivilegeDisplayName(nil,PChar(@PrivName),PChar(@DisplayName),DisplSize,LangId);
          SetLength(AList,Length(AList)+1);
          with AList[High(AList)] do begin
            Name:=string(PrivName);
            DisplayName:=string(DisplayName);
            Flags:=priv.Attributes;
          end;
          priv:=PLUIDAndAttributes(PChar(priv)+SizeOf(TLUIDAndAttributes));
        end;
        CloseHandle(hToken);
      end;
    finally
      Finalize(pTokenInfo);
      FreeMem(pTokenInfo);
    end;
  end;
end;

function GetProcessGroups;
const
  TokenSize = $1000; //  (SizeOf(Pointer)=4 *200)
var
  hToken: THandle;
  pTokenInfo: PTokenGroups;
  i,j: Integer;
  pName,
  pDomain: array[0..255] of Char;
  n, SIDType: DWORD;
  group: PSIDAndAttributes;
begin
  Result:=False;
  SetLength(AList,0);
  if OpenProcessToken(ProcessHandle,TOKEN_QUERY,hToken) then begin
    GetMem(pTokenInfo,TokenSize);
    try
      if GetTokenInformation(hToken,TokenGroups,pTokenInfo,TokenSize,n) then begin
        group:=PSIDAndAttributes(PChar(pTokenInfo)+SizeOf(DWORD));
        for i:=0 to pTokenInfo.GroupCount-1 do begin
          Zeromemory(@pname,SizeOf(pName));
          Zeromemory(@pDomain,SizeOf(pDomain));
          j:=0;
          repeat
            LookupAccountSID(nil,group.Sid,PChar(@pName),n,PChar(@pDomain),n,SIDType);
            n:=GetLastError;
            Inc(j);
          until (string(pName)<>'') or (n=ERROR_NONE_MAPPED) or (j>10);
          SetLength(AList,Length(AList)+1);
          with AList[High(AList)] do begin
            Name:=string(pName);
            Domain:=string(pDomain);
            SID:=ConvertSIDToString(group.Sid);
            Flags:=group.Attributes;
          end;
          group:=PSIDAndAttributes(PChar(group)+SizeOf(TSIDAndAttributes));
        end;
        CloseHandle(hToken);
      end;
    finally
      Finalize(pTokenInfo);
      FreeMem(pTokenInfo);
    end;
  end;
end;

function GetProcessUserName(hProcess :THandle; var UserName, DomainName :string) :boolean;
const
  TokenSize = $1000; //  (SizeOf(Pointer)=4 *200)
var
  hToken :THandle;
  pTokenInfo: PSIDAndAttributes;
  pName, pDomain :array[0..255] of Char;
  SIDType: DWORD;
  n,j: DWORD;
begin
  Result:=False;
  UserName:='';
  DomainName:='';
  if OpenProcessToken(hProcess,TOKEN_QUERY,hToken) then begin
    GetMem(pTokenInfo,TokenSize);
    try
      if GetTokenInformation(hToken,TokenUser,pTokenInfo,TokenSize,n) then begin
        j:=0;
        repeat
          LookupAccountSID(nil,pTokenInfo.Sid,PChar(@pName),n,PChar(@pDomain),n,SIDType);
          n:=GetLastError;
          Inc(j);
        until (string(pName)<>'') or (n=ERROR_NONE_MAPPED) or (j>10);
        if string(pName)='' then
          UserName:=ConvertSIDToString(pTokenInfo.Sid)
        else begin
          UserName:=string(pName);
          DomainName:=string(pDomain);
        end;
        Result:=True;
        CloseHandle(hToken);
      end;
    finally
      Freemem(pTokenInfo);
    end;
  end;
end;

function EnablePrivilege(Privilege: string): Boolean;
var
  tp: TOKEN_PRIVILEGES;
  th: THandle;
  n: DWORD;
begin
  n:=0;
  tp.PrivilegeCount:=1;
  tp.Privileges[0].Luid:=0;
  tp.Privileges[0].Attributes:=SE_PRIVILEGE_ENABLED;
  if OpenProcessToken(GetCurrentProcess,TOKEN_ADJUST_PRIVILEGES,th) then begin
    if LookupPrivilegeValue(nil,PChar(Privilege),tp.Privileges[0].Luid) then
      AdjustTokenPrivileges(th,False,tp,sizeof(TOKEN_PRIVILEGES),nil,n);
    Closehandle(th);
  end;
  Result:=GetLastError=ERROR_SUCCESS;
end;

function DisablePrivileges: Boolean;
var
  tp: TOKEN_PRIVILEGES;
  th: THandle;
  n: DWORD;
begin
  n:=0;
  tp.PrivilegeCount:=1;
  tp.Privileges[0].Luid:=0;
  tp.Privileges[0].Attributes:=0;
  if OpenProcessToken(GetCurrentProcess,TOKEN_ADJUST_PRIVILEGES,th) then begin
    AdjustTokenPrivileges(th,True,tp,sizeof(TOKEN_PRIVILEGES),nil,n);
    Closehandle(th);
  end;
  Result:=GetLastError=ERROR_SUCCESS;
end;

function AppIsResponding(AHandle: THandle): Boolean;
const
  TIMEOUT = 50;
var
  Res: DWORD;
begin
  if AHandle<>0 then
    Result:=SendMessageTimeout(AHandle,WM_NULL,0,0,SMTO_NORMAL or SMTO_ABORTIFHUNG,TIMEOUT,Res)<>0
  else
    Result:=False;
end;

function ConvertSIDToString;
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

function ConvertStringToSID;
var
  sa: TSIDIdentifierAuthority;
  s: string;
begin
  s:=Copy(ASID,5,Length(ASID));
  sa.Value[0]:=0;
  sa.Value[1]:=0;
  sa.Value[2]:=0;
  sa.Value[3]:=0;
  sa.Value[4]:=0;
  sa.Value[5]:=5;
  AllocateAndInitializeSid(sa,2,{SECURITY_BUILTIN_DOMAIN_RID}0,{DOMAIN_ALIAS_RID_ADMINS}0,
        0, 0, 0, 0, 0, 0, Result);

end;

function PortIn(IOAddr : WORD) : BYTE;
begin
 asm
  mov dx,IOAddr
  in  al,dx
  mov result,al
 end;
end;

procedure PortOut(IOAddr : WORD; Data : BYTE);
begin
 asm
  mov  dx,IOAddr
  mov  al,Data
  out  dx,al
 end;
end;

function ReadRegistryString(Root: HKEY; Key,Value: string): string;
begin
 Result:='';
 with TRegistry.Create do
   try
     RootKey:=Root;
     Access:=KEY_READ;
     if OpenKey(Key,False) then begin
       Result:=ReadString(Value);
       CloseKey;
     end;
   finally
     Free;
   end;
end;

function ReadRegistryValueAsString;
var
  Data: array[0..1024] of Byte;
  i: Integer;
  DataSize, DataType: Integer;
  sl: TStringList;
begin
 Result:='';
 with TRegistry.Create do
   try
     RootKey:=Root;
     Access:=KEY_READ;
     if OpenKey(Key,False) and ValueExists(Value) then begin
       RegQueryValueEx(CurrentKey, PChar(Value), nil, PDWORD(@DataType), nil, PDWORD(@DataSize));
       case DataType of
         REG_SZ: Result:=ReadString(Value);
         REG_EXPAND_SZ: begin
           Result:=ReadString(Value);
           DataSize:=ExpandEnvironmentStrings(PChar(Result),nil,DataSize);
           if DataSize>0 then begin
             DataSize:=ExpandEnvironmentStrings(PChar(Result),PChar(@Data),DataSize);
             Result:=string(PChar(@Data));
           end;
         end;
         REG_DWORD,REG_DWORD_BIG_ENDIAN: Result:=IntToStr(ReadInteger(Value));
         REG_MULTI_SZ: begin
           Result:='';
           if DataSize>-1 then begin
             ReadBinaryData(Value,Data,DataSize);
             sl:=TStringList.Create;
             MultiStrFromBuf(Data,dataSize,sl);
             Result:=sl.Text;
             sl.Free;
           end;
         end;
         else{REG_RESOURCE_LIST,
         REG_FULL_RESOURCE_DESCRIPTOR,
         REG_RESOURCE_REQUIREMENTS_LIST:} begin
           Result:='';
           if DataSize>-1 then begin
             ReadBinaryData(Value,Data,DataSize);
             if BinaryAsHex then begin
               i:=0;
               if Data[i]<>0 then
                 Result:=Result+Format('%2.2x',[Data[i]])
               else
                 if Copy(Result,Length(Result),1)<>#10 then
                   Result:=Result+#13#10;
               SetLength(Result,Length(Result)-2);
             end else begin
               for i:=0 to DataSize-1 do
                 Result:=Result+Format('%2.2x ',[Ord(Data[i])]);
               SetLength(Result,Length(Result)-1);
             end;
           end;
         end;
       end;
       CloseKey;
     end;
   finally
     Free;
   end;
end;

procedure GetRegistryKeyNames;
begin
 with TRegistry.Create do
   try
     RootKey:=Root;
     Access:=KEY_READ;
     if OpenKey(Key,False) then begin
       GetKeyNames(KeyList);
       CloseKey;
     end;
   finally
     Free;
   end;
end;

procedure SeparateHotKey(HotKey: Word; var Modifiers, Key: Word);
const
  VK2_SHIFT   =  32;
  VK2_CONTROL =  64;
  VK2_ALT     = 128;
var
  Virtuals: Integer;
  V: Word;
  x: Byte;
begin
  Key := Byte(HotKey);

  x := HotKey shr 8;
  V := 0;
  Virtuals := x;

  if Virtuals >= VK2_ALT then
  begin
    Virtuals := Virtuals - VK2_ALT;
    V := V + MOD_ALT;
  end;

  if Virtuals >= VK2_CONTROL then
  begin
    Virtuals := Virtuals - VK2_CONTROL;
    V := V + MOD_CONTROL;
  end;

  if Virtuals >= VK2_SHIFT then
  begin
    V := V + MOD_SHIFT;
  end;
  Modifiers := V;
end;


function AssignHotkey(Handle: HWND; HotKey: TShortCut; KeyIdx: Word): Boolean;
var
  Modifiers, Key: Word;
begin
  SeparateHotKey(HotKey, Modifiers, Key);
  Result := RegisterHotkey(Handle, KeyIdx, Modifiers, Key);
end;


function ValidHotkey(Handle: HWND; HotKey: TShortCut; KeyIdx: Word): Boolean;
var
  V1, V2: Word;
begin
  SeparateHotKey(HotKey, V1, V2);
  Result := RegisterHotkey(Handle, KeyIdx, V1, V2);
  UnregisterHotkey(Handle, KeyIdx);
end;

function GetLastFilename(AFilename: string): string;
var
  i: Integer;
  s,e: string;
  fi: TSearchrec;
begin
  i:=0;
  e:=ExtractFileExt(AFilename);
  s:=ExtractFilename(AFilename);
  s:=Copy(s,1,Pos('.',s)-1);
  while FindFirst(ExtractFilePath(AFilename)+Format('%s%2.2d%s',[s,i,e]),faArchive,fi)=0 do
    Inc(i);
  Result:=ExtractFilePath(AFilename)+Format('%s%2.2d%s',[s,i,e]);
  FindClose(fi);
end;

function VarToFloat;
begin
  try
    Result:=Source;
  except
    Result:=0;
  end;
end;

function VarToInt;
begin
  try
    Result:=Source;
  except
    Result:=0;
  end;
end;

function VarToBool;
begin
  try
    Result:=VarAsType(Source, varBoolean);
  except
    Result:=False;
  end;
end;

function StrToIntEx(Source: string): Integer;
begin
  try
    Result:=StrToInt(Source);
  except
    Result:=0;
  end;
end;

procedure ModifyRegValue;
begin
  with TRegistry.Create do
    try
      RootKey:=ARootKey;
      if OpenKey(AKey,True) then begin
        case AType of
          rdString, rdExpandString: WriteString(AName,AValue);
          rdInteger: WriteInteger(AName,AValue);
        end;
        CloseKey;
      end;
    finally
      Free;
    end;
end;

procedure MultiWideStrFromBuf;
var
  s: string;
  l: Integer;
begin
  List.Clear;
  s:=WideCharToString(PWideChar(@Buffer));
  List.Add(s);
  l:=Length(s)*2+2;
  while (l<Len) and (s<>'') do begin
    Move(Buffer[Length(s)*2+2],Buffer,Len-Length(s)*2+2);
    s:=WideCharToString(PWideChar(@Buffer));
    l:=l+Length(s)*2+2;
    if s<>'' then
      List.Add(s);
  end;
end;

procedure MultiStrFromBuf;
var
  s: string;
  l: Integer;
begin
  List.Clear;
  s:=PChar(@Buffer);
  List.Add(s);
  l:=Length(s)*2+2;
  while (l<Len) and (s<>'') do begin
    Move(Buffer[Length(s)*2+2],Buffer,Len-Length(s)*2+2);
    s:=Pchar(@Buffer);
    l:=l+Length(s)*2+2;
    if s<>'' then
      List.Add(s);
  end;
end;

function GetObjectFullName(Sender: TObject): string;
var
  s: string;
begin
  Result:='';
  while Sender<>nil do begin
    s:='';
    if Sender is TComponent then
      s:=TComponent(Sender).Name;
    s:=Format('(%s: %s).',[s,Sender.ClassName]);
    if Sender is TComponent then
      Sender:=TComponent(Sender).Owner
    else
      Sender:=nil;
    Result:=s+Result;
  end;
  if Result<>'' then
    SetLength(Result,Length(Result)-1);
end;

function ConvertAddr(Address: Pointer): Pointer; assembler;
asm
        TEST    EAX,EAX
        JE      @@1
        SUB     EAX, $1000
@@1:
end;

procedure ErrorInfo;
var
  Info :TMemoryBasicInformation;
  Temp,ModName :array[0..MAX_PATH] of Char;
begin
  VirtualQuery(ExceptAddr,Info,SizeOf(Info));
  if (Info.State<>MEM_COMMIT) or (GetModuleFilename(THandle(Info.AllocationBase),Temp,SizeOf(Temp))=0) then begin
    GetModuleFileName(HInstance, Temp, SizeOf(Temp));
    LogicalAddress:=ConvertAddr(LogicalAddress);
  end else
    Integer(LogicalAddress):=Integer(LogicalAddress)-Integer(Info.AllocationBase);
  StrLCopy(ModName,AnsiStrRScan(Temp,'\')+1,SizeOf(ModName)-1);
  ModuleName:=StrPas(ModName);
end;

function CorrectFilename;
var
  i,l: DWORD;
begin
  Result:=fn;
  l:=Length(Result);
  for i:=1 to l-1 do
    if Result[i] in [#33, #34, #37, #39, #42, #46, #47, #58, #63, #92] then
      Result[i]:=#32;
end;

procedure StartTimer;
begin
  InternalTimer:=GetTickCount;
end;

function StopTimer: comp;
begin
  Result:=GetTickCount-InternalTimer;
end;


initialization
  Os:=GetOS(CSD);
  IsNT:=OS in [osNT3,osNT4,os2K,osXP,osNET];
  IsNT4:=OS=osNT4;
  IsNT5:=OS in [os2K,osXP,osNET];
  IS95:=OS=os95;
  Is98:=OS=os98;
  Is2K:=OS=os2K;
  IsOSR2:=OS=os95OSR2;
  IsSE:=OS=os98SE;
  IsME:=OS=osME;
  IsXP:=OS=osXP;
  IsNET:=OS=osNET;
  WindowsUser:=GetUser;
  MachineName:=Uppercase(GetMachine);
  ProfilePath:=GetProfilePath;
  case OS of
    os95, os95OSR2: OSVersion:='Windows 95';
    os98,os98SE: OSVersion:='Windows 98';
    osME: OSVersion:='Windows Millenium Edition';
    osNT3, osNT4: OSVersion:='Windows NT';
    os2K: OSVersion:='Windows 2000';
    osXP: OSVersion:='Windows XP';
    osNET: OSVersion:='Windows 2003 Server';
  end;
  case OS of
    os95: OSVersionEx:='Windows 95';
    os95OSR1: OSVersionEx:='Windows 95 OSR 1';
    os95OSR2: OSVersionEx:='Windows 95 OSR 2';
    os95OSR25: OSVersionEx:='Windows 95 OSR 2.5';
    os98: OSVersionEx:='Windows 98';
    os98SE: OSVersionEx:='Windows 98 Second Edition';
    osME: OSVersionEx:='Windows Millenium Edition';
    osNT3: OSVersionEx:='Windows NT 3.x '+CSD;
    osNT4: OSVersionEx:='Windows NT 4.x '+CSD;
    os2K: OSVersionEx:='Windows 2000 '+CSD;
    osXP: OSVersionEx:='Windows XP '+CSD;
    osNET: OSVersionEx:='Windows Server 2003 '+CSD;
  end;
  if IsNT then
    ClassKey:='SYSTEM\CurrentControlSet\Control\Class'
  else
    ClassKey:='SYSTEM\CurrentControlSet\Services\Class';
  ZeroMemory(@MS,SizeOf(MS));
  MS.dwLength:=SizeOf(MS);
  GlobalMemoryStatus(MS);
  Memory:=MS.dwTotalPhys;
  GetFileVerInfo(ParamStr(0),ExeVersionInfo);
end.

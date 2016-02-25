{*******************************************************}
{                                                       }
{       MiTeC System Information Component              }
{           Startup Runs Detection Part                 }
{           version 8.6.4 for Delphi 5,6,7              }
{                                                       }
{       Copyright © 1997,2003 Michal Mutl               }
{                                                       }
{*******************************************************}

{$INCLUDE MITEC_DEF.INC}

unit MSI_Startup;

interface

uses
  MSI_Common, SysUtils, Windows, Classes;

type
  TRunType = (rtHKCU, rtHKLM, rtHKLMOnce, rtHKCUOnce, rtHKLMOnceEx, rtHKCUOnceEx,
              rtHKLMServices, rtHKLMServicesOnce, rtHKCUServices, rtHKCUServicesOnce,
              rtHKLMSessionManager, rtHKLMWinLogon, rtHKCULoad,
              rtUser, rtCommon, rtWinINI, rtSystemINI);

  TStartup = class(TPersistent)
  private
    FHKCU_Runs: TStringList;
    FHKLM_Runs: TStringList;
    FHKCUOnce_Runs: TStringList;
    FHKLMOnce_Runs: TStringList;
    FHKCUOnceEx_Runs: TStringList;
    FHKLMOnceEx_Runs: TStringList;
    FHKLMServices_Runs: TStringList;
    FHKLMServicesOnce_Runs: TStringList;
    FHKCUServices_Runs: TStringList;
    FHKCUServicesOnce_Runs: TStringList;
    FHKLMSessionManager_Runs: TStringList;
    FHKLMWinLogon_Runs: TStringList;
    FHKCULoad_Runs: TStringList;
    FUser_Runs: TStringList;
    FCommon_Runs: TStringList;
    FWININI_Runs: TStringList;
    FSYSTEMINI_Runs: TStringList;
    FModes: TExceptionModes;

    procedure ClearList(var L: TStringList);

    function GetCommonRun(Index: integer): string;
    function GetHKCU(Index: integer): string;
    function GetHKLM(Index: integer): string;
    function GetRunHKCUOnce(Index: integer): string;
    function GetUserRun(Index: integer): string;
    function GetCount: integer;
    {$IFNDEF D6PLUS}
    procedure SetCount(const Value: integer);
    {$ENDIF}
    function GetCommonCount: integer;
    function GetHKCUCount: integer;
    function GetHKLMCount: integer;
    function GetHKCUOnceCount: integer;
    function GetUserCount: integer;
    function GetWININICount: integer;
    function GetWININIRun(Index: integer): string;
    function GetSYSTEMINICount: integer;
    function GetSYSTEMINIRun(Index: integer): string;
    function GetHKCUOnceExCount: integer;
    function GetHKLMOnceCount: integer;
    function GetHKLMOnceExCount: integer;
    function GetHKLMServicesCount: integer;
    function GetRunHKCUOnceEx(Index: integer): string;
    function GetRunHKLMOnce(Index: integer): string;
    function GetRunHKLMOnceEx(Index: integer): string;
    function GetRunHKLMServices(Index: integer): string;
    function GetHKLMServicesOnceCount: integer;
    function GetRunHKLMServicesOnce(Index: integer): string;
    function GetHKCUServicesCount: integer;
    function GetHKCUServicesOnceCount: integer;
    function GetRunHKCUServices(Index: integer): string;
    function GetRunHKCUServicesOnce(Index: integer): string;
    function GetHKLMSessionManagerCount: integer;
    function GetHKCULoadCount: integer;
    function GetHKLMWinLogonCount: integer;
    function GetRunHKLMSessionManager(Index: integer): string;
    function GetRunHKCULoad(Index: integer): string;
    function GetRunHKLMWinLogon(Index: integer): string;
    procedure SetMode(const Value: TExceptionModes);
  public
    constructor Create;
    destructor Destroy; override;
    procedure GetInfo;
    procedure Report(var sl :TStringList; Standalone: Boolean = True); virtual;

    property HKCU_Runs[Index: integer]: string read GetHKCU;
    property HKCU_Count: integer read GetHKCUCount;
    property HKLM_Runs[Index: integer]: string read GetHKLM;
    property HKLM_Count: integer read GetHKLMCount;
    property HKLMOnce_Runs[Index: integer]: string read GetRunHKLMOnce;
    property HKLMOnce_Count: integer read GetHKLMOnceCount;
    property HKCUOnce_Runs[Index: integer]: string read GetRunHKCUOnce;
    property HKCUOnce_Count: integer read GetHKCUOnceCount;
    property HKLMOnceEx_Runs[Index: integer]: string read GetRunHKLMOnceEx;
    property HKLMOnceEx_Count: integer read GetHKLMOnceExCount;
    property HKCUOnceEx_Runs[Index: integer]: string read GetRunHKCUOnceEx;
    property HKCUOnceEx_Count: integer read GetHKCUOnceExCount;
    property HKLMServices_Runs[Index: integer]: string read GetRunHKLMServices;
    property HKLMServices_Count: integer read GetHKLMServicesCount;
    property HKLMServicesOnce_Runs[Index: integer]: string read GetRunHKLMServicesOnce;
    property HKLMServicesOnce_Count: integer read GetHKLMServicesOnceCount;
    property HKCUServices_Runs[Index: integer]: string read GetRunHKCUServices;
    property HKCUServices_Count: integer read GetHKCUServicesCount;
    property HKCUServicesOnce_Runs[Index: integer]: string read GetRunHKCUServicesOnce;
    property HKCUServicesOnce_Count: integer read GetHKCUServicesOnceCount;
    property HKLMSessionManager_Runs[Index: integer]: string read GetRunHKLMSessionManager;
    property HKLMSessionManager_Count: integer read GetHKLMSessionManagerCount;
    property HKLMWinLogon_Runs[Index: integer]: string read GetRunHKLMWinLogon;
    property HKLMWinLogon_Count: integer read GetHKLMWinLogonCount;
    property HKCULoad_Runs[Index: integer]: string read GetRunHKCULoad;
    property HKCULoad_Count: integer read GetHKCULoadCount;
    property User_Runs[Index: integer]: string read GetUserRun;
    property User_Count: integer read GetUserCount;
    property Common_Runs[Index: integer]: string read GetCommonRun;
    property Common_Count: integer read GetCommonCount;
    property WinINI_Runs[Index: integer]: string read GetWININIRun;
    property WinINI_Count: integer read GetWININICount;
    property SystemINI_Runs[Index: integer]: string read GetSYSTEMINIRun;
    property SystemINI_Count: integer read GetSYSTEMINICount;

    function GetRunCommand(AType: TRunType; Index: integer): string;
  published
    property ExceptionModes: TExceptionModes read FModes Write SetMode;
    property RunsCount: integer read GetCount {$IFNDEF D6PLUS} write SetCount {$ENDIF} stored False;
  end;


implementation

uses Registry, MiTeC_Routines, ShlObj, INIFiles, MiTeC_StrUtils;

{ TStartup }

procedure TStartup.ClearList(var L: TStringList);
var
  p :PChar;
begin
  while L.count>0 do begin
   p:=PChar(L.Objects[L.count-1]);
   Freemem(p);
   L.Delete(L.count-1);
  end;
end;

constructor TStartup.Create;
begin
  ExceptionModes:=[emExceptionStack];
  FHKCU_Runs:=TStringList.Create;
  FHKLM_Runs:=TStringList.Create;
  FHKLMOnce_Runs:=TStringList.Create;
  FHKCUOnce_Runs:=TStringList.Create;
  FHKLMOnceEx_Runs:=TStringList.Create;
  FHKCUOnceEx_Runs:=TStringList.Create;
  FHKLMServices_Runs:=TStringList.Create;
  FHKLMServicesOnce_Runs:=TStringList.Create;
  FHKCUServices_Runs:=TStringList.Create;
  FHKCUServicesOnce_Runs:=TStringList.Create;
  FHKLMSessionManager_Runs:=TStringList.Create;
  FHKLMWinLogon_Runs:=TStringList.Create;
  FHKCULoad_Runs:=TStringList.Create;
  FUser_Runs:=TStringList.Create;
  FCommon_Runs:=TStringList.Create;
  FWININI_Runs:=TStringList.Create;
  FSYSTEMINI_Runs:=TStringList.Create;
end;

destructor TStartup.Destroy;
begin
  ClearList(FHKCU_Runs);
  ClearList(FHKLM_Runs);
  ClearList(FHKCUOnce_Runs);
  ClearList(FHKLMOnce_Runs);
  ClearList(FHKLMOnceEx_Runs);
  ClearList(FHKCUOnceEx_Runs);
  ClearList(FHKLMServices_Runs);
  ClearList(FHKLMServicesOnce_Runs);
  ClearList(FHKCUServices_Runs);
  ClearList(FHKCUServicesOnce_Runs);
  ClearList(FHKLMSessionManager_Runs);
  ClearList(FHKLMWinLogon_Runs);
  ClearList(FHKCULoad_Runs);
  ClearList(FUser_Runs);
  ClearList(FCommon_Runs);
  ClearList(FWININI_Runs);
  ClearList(FSYSTEMINI_Runs);

  FHKCU_Runs.Free;
  FHKLM_Runs.Free;
  FHKCUOnce_Runs.Free;
  FHKLMOnce_Runs.Free;
  FHKLMOnceEx_Runs.Free;
  FHKCUOnceEx_Runs.Free;
  FHKLMServices_Runs.Free;
  FHKLMServicesOnce_Runs.Free;
  FHKCUServices_Runs.Free;
  FHKCUServicesOnce_Runs.Free;
  FHKLMSessionManager_Runs.Free;
  FHKLMWinLogon_Runs.Free;
  FHKCULoad_Runs.Free;
  FUser_Runs.Free;
  FCommon_Runs.Free;
  FWININI_Runs.Free;
  FSYSTEMINI_Runs.Free;
  inherited;
end;

function TStartup.GetCommonCount: integer;
begin
  Result:=FCommon_Runs.Count;
end;

function TStartup.GetCommonRun(Index: integer): string;
begin
  try
    Result:=FCommon_Runs[Index];
  except
    Result:='';
  end;
end;

function TStartup.GetCount: integer;
begin
  Result:=FHKCU_Runs.Count+
          FHKLM_Runs.Count+
          FHKCUOnce_Runs.Count+
          FHKLMOnce_Runs.Count+
          FHKCUOnceEx_Runs.Count+
          FHKLMOnceEx_Runs.Count+
          FHKLMServices_Runs.Count+
          FHKLMServicesOnce_Runs.Count+
          FHKCUServices_Runs.Count+
          FHKCUServicesOnce_Runs.Count+
          FHKLMSessionManager_Runs.Count+
          FHKLMWinLogon_Runs.Count+
          FHKCULoad_Runs.Count+
          FUser_Runs.Count+
          FCommon_Runs.Count+
          FWININI_Runs.Count+
          FSYSTEMINI_Runs.Count;
end;

function TStartup.GetHKCU(Index: integer): string;
begin
  try
    Result:=FHKCU_Runs[Index];
  except
    Result:='';
  end;
end;

function TStartup.GetHKCUCount: integer;
begin
  Result:=FHKCU_Runs.Count;
end;

function TStartup.GetHKLM(Index: integer): string;
begin
  try
    Result:=FHKLM_Runs[Index];
  except
    Result:='';
  end;
end;

function TStartup.GetHKLMCount: integer;
begin
  Result:=FHKLM_Runs.Count;
end;

procedure TStartup.GetInfo;
const
  rk_Run = '\Software\Microsoft\Windows\CurrentVersion\Run';
  rk_Once = '\Software\Microsoft\Windows\CurrentVersion\RunOnce';
  rk_OnceEx = '\Software\Microsoft\Windows\CurrentVersion\RunOnceEx';
  rk_Services = '\Software\Microsoft\Windows\CurrentVersion\RunServices';
  rk_ServicesOnce = '\Software\Microsoft\Windows\CurrentVersion\RunServicesOnce';
  rk_SessionManager = '\SYSTEM\CurrentControlSet\Control\Session Manager';
    rv_BootExecute = 'BootExecute';
  rk_WinLogon = '\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon';
    rv_UserInit = 'UserInit';
    rv_Shell = 'Shell';
  rk_WindowsNT = '\Software\Microsoft\Windows NT\CurrentVersion\Windows';
    rv_Load = 'Load';


var
  i,j: integer;
  kl,sl: TStringList;
  s,f,a: string;
  p: PChar;
  WinH: HWND;
  fi: TSearchRec;
  data: PChar;
  rdt: TRegDataInfo;
begin
  {$IFDEF ERROR_INTERCEPT}PushTrace(FModes,Self,'GetInfo'); {$ENDIF}

  Data := nil;

  ClearList(FHKCU_Runs);
  ClearList(FHKLM_Runs);
  ClearList(FHKCUOnce_Runs);
  ClearList(FHKLMOnce_Runs);
  ClearList(FHKLMOnceEx_Runs);
  ClearList(FHKCUOnceEx_Runs);
  ClearList(FHKLMServices_Runs);
  ClearList(FHKLMServicesOnce_Runs);
  ClearList(FHKCUServices_Runs);
  ClearList(FHKCUServicesOnce_Runs);
  ClearList(FHKLMSessionManager_Runs);
  ClearList(FHKLMWinLogon_Runs);
  ClearList(FHKCULoad_Runs);
  ClearList(FUser_Runs);
  ClearList(FCommon_Runs);
  ClearList(FWININI_Runs);
  ClearList(FSYSTEMINI_Runs);

  sl:=TStringList.Create;
  kl:=TStringList.Create;

  with TRegistry.Create do
    try
      sl.Clear;
      RootKey:=HKEY_CURRENT_USER;
      if OpenKeyReadOnly(rk_Run) then begin
        GetValueNames(sl);
        for i:=0 to sl.Count-1 do begin
          s:=ReadString(sl[i]);
          p:=AllocMem(Length(s)+1);
          StrPCopy(p,s);
          FHKCU_Runs.AddObject(sl[i],@p^);
        end;
        CloseKey;
      end;

      sl.Clear;
      RootKey:=HKEY_LOCAL_MACHINE;
      if OpenKeyReadOnly(rk_Run) then begin
        GetValueNames(sl);
        for i:=0 to sl.Count-1 do begin
          s:=ReadString(sl[i]);
          p:=AllocMem(Length(s)+1);
          StrPCopy(p,s);
          FHKLM_Runs.AddObject(sl[i],@p^);
        end;
        CloseKey;
      end;

      sl.Clear;
      RootKey:=HKEY_CURRENT_USER;
      if OpenKeyReadOnly(rk_Once) then begin
        GetValueNames(sl);
        for i:=0 to sl.Count-1 do begin
          s:=ReadString(sl[i]);
          p:=AllocMem(Length(s)+1);
          StrPCopy(p,s);
          FHKCUOnce_Runs.AddObject(sl[i],@p^);
        end;
        CloseKey;
      end;

      sl.Clear;
      RootKey:=HKEY_LOCAL_MACHINE;
      if OpenKeyReadOnly(rk_Once) then begin
        GetValueNames(sl);
        for i:=0 to sl.Count-1 do begin
          s:=ReadString(sl[i]);
          p:=AllocMem(Length(s)+1);
          StrPCopy(p,s);
          FHKLMOnce_Runs.AddObject(sl[i],@p^);
        end;
        CloseKey;
      end;

      sl.Clear;
      RootKey:=HKEY_CURRENT_USER;
      if OpenKeyReadOnly(rk_OnceEx) then begin
        GetKeyNames(kl);
        CloseKey;
        for j:=0 to kl.Count-1 do
          if not SameText(kl[j],'Depend') and OpenKeyReadOnly(rk_OnceEx+'\'+kl[j]) then begin
            GetValueNames(sl);
            for i:=0 to sl.Count-1 do begin
              s:=ReadString(sl[i]);
              s:=StringReplace(s,'||','',[rfIgnoreCase]);
              s:=StringReplace(s,'|',' ',[rfIgnoreCase]);
              p:=AllocMem(Length(s)+1);
              StrPCopy(p,s);
              FHKCUOnceEx_Runs.AddObject(sl[i],@p^);
            end;
            CloseKey;
          end;
      end;

      sl.Clear;
      RootKey:=HKEY_LOCAL_MACHINE;
      if OpenKeyReadOnly(rk_OnceEx) then begin
        GetKeyNames(kl);
        CloseKey;
        for j:=0 to kl.Count-1 do
          if not SameText(kl[j],'Depend') and OpenKeyReadOnly(rk_OnceEx+'\'+kl[j]) then begin
            GetValueNames(sl);
            for i:=0 to sl.Count-1 do begin
              s:=ReadString(sl[i]);
              s:=StringReplace(s,'||','',[rfIgnoreCase]);
              s:=StringReplace(s,'|',' ',[rfIgnoreCase]);
              p:=AllocMem(Length(s)+1);
              StrPCopy(p,s);
              FHKLMOnceEx_Runs.AddObject(sl[i],@p^);
            end;
            CloseKey;
          end;
      end;

      sl.Clear;
      RootKey:=HKEY_LOCAL_MACHINE;
      if OpenKeyReadOnly(rk_Services) then begin
        GetValueNames(sl);
        for i:=0 to sl.Count-1 do begin
          s:=ReadString(sl[i]);
          p:=AllocMem(Length(s)+1);
          StrPCopy(p,s);
          FHKLMServices_Runs.AddObject(sl[i],@p^);
        end;
        CloseKey;
      end;

      sl.Clear;
      RootKey:=HKEY_LOCAL_MACHINE;
      if OpenKeyReadOnly(rk_ServicesOnce) then begin
        GetValueNames(sl);
        for i:=0 to sl.Count-1 do begin
          s:=ReadString(sl[i]);
          p:=AllocMem(Length(s)+1);
          StrPCopy(p,s);
          FHKLMServicesOnce_Runs.AddObject(sl[i],@p^);
        end;
        CloseKey;
      end;

      sl.Clear;
      RootKey:=HKEY_CURRENT_USER;
      if OpenKeyReadOnly(rk_Services) then begin
        GetValueNames(sl);
        for i:=0 to sl.Count-1 do begin
          s:=ReadString(sl[i]);
          p:=AllocMem(Length(s)+1);
          StrPCopy(p,s);
          FHKCUServices_Runs.AddObject(sl[i],@p^);
        end;
        CloseKey;
      end;

      sl.Clear;
      RootKey:=HKEY_CURRENT_USER;
      if OpenKeyReadOnly(rk_ServicesOnce) then begin
        GetValueNames(sl);
        for i:=0 to sl.Count-1 do begin
          s:=ReadString(sl[i]);
          p:=AllocMem(Length(s)+1);
          StrPCopy(p,s);
          FHKCUServicesOnce_Runs.AddObject(sl[i],@p^);
        end;
        CloseKey;
      end;

      sl.Clear;
      RootKey:=HKEY_LOCAL_MACHINE;
      if OpenKeyReadOnly(rk_SessionManager) then begin
        if ValueExists(rv_BootExecute) then begin
          GetDataInfo(rv_BootExecute,rdt);
          if rdt.RegData in [rdUnknown,rdBinary] then begin
            try
              Data:=StrAlloc(rdt.DataSize);
              ReadBinaryData(rv_BootExecute,Data^,rdt.DataSize);
              s:=string(data);
            finally
              if Assigned(Data) then //_W_
                StrDispose(Data);
            end;
          end else
            s:=ReadString(rv_BootExecute);
          if not IsEmptyString(s) then begin
            p:=AllocMem(Length(s)+1);
            StrPCopy(p,s);
            FHKLMSessionManager_Runs.AddObject(rv_BootExecute,@p^);
          end;
          CloseKey;
        end;
      end;

      sl.Clear;
      RootKey:=HKEY_LOCAL_MACHINE;
      if OpenKeyReadOnly(rk_WinLogon) then begin
        if ValueExists(rv_UserInit) then begin
          s:=ReadString(rv_UserInit);
          p:=AllocMem(Length(s)+1);
          StrPCopy(p,s);
          FHKLMWinLogon_Runs.AddObject(rv_UserInit,@p^);
        end;
        if ValueExists(rv_Shell) then begin
          s:=ReadString(rv_Shell);
          p:=AllocMem(Length(s)+1);
          StrPCopy(p,s);
          FHKLMWinLogon_Runs.AddObject(rv_Shell,@p^);
        end;
        CloseKey;
      end;

      sl.Clear;
      RootKey:=HKEY_CURRENT_USER;
      if OpenKeyReadOnly(rk_WindowsNT) then begin
        if ValueExists(rv_Load) then begin
          s:=ReadString(rv_Load);
          if not IsEmptyString(s) then begin
            p:=AllocMem(Length(s)+1);
            StrPCopy(p,s);
            FHKCULoad_Runs.AddObject(rv_Load,@p^);
          end;
          CloseKey;
        end;
      end;

      WinH:=GetDesktopWindow;

      s:=GetSpecialFolder(WinH,CSIDL_COMMON_STARTUP);
      if (s<>'') and (s[Length(s)]='\') then
        SetLength(s,Length(s)-1);
      if FindFirst(s+'\*.lnk',faArchive,fi)=0 then begin
        ResolveLink(s+'\'+fi.Name,f,a);
        f:=f+' '+a;
        p:=AllocMem(Length(f)+1);
        StrPCopy(p,f);
        FCommon_Runs.AddObject(Copy(fi.Name,1,Length(fi.Name)-4),@p^);
        while FindNext(fi)=0 do begin
          ResolveLink(s+'\'+fi.Name,f,a);
          f:=f+' '+a;
          p:=AllocMem(Length(f)+1);
          StrPCopy(p,f);
          FCommon_Runs.AddObject(Copy(fi.Name,1,Length(fi.Name)-4),@p^);
        end;
        SysUtils.FindClose(fi);
      end;

      s:=GetSpecialFolder(WinH,CSIDL_STARTUP);
      if (s<>'') and (s[Length(s)]='\') then
        SetLength(s,Length(s)-1);
      if FindFirst(s+'\*.lnk',faArchive,fi)=0 then begin
        ResolveLink(s+'\'+fi.Name,f,a);
        f:=f+' '+a;
        p:=AllocMem(Length(f)+1);
        StrPCopy(p,f);
        FUser_Runs.AddObject(Copy(fi.Name,1,Length(fi.Name)-4),@p^);
        while FindNext(fi)=0 do begin
          ResolveLink(s+'\'+fi.Name,f,a);
          f:=f+' '+a;
          p:=AllocMem(Length(f)+1);
          StrPCopy(p,f);
          FUser_Runs.AddObject(Copy(fi.Name,1,Length(fi.Name)-4),@p^);
        end;
      end;

      with TINIFile.Create('WIN.INI') do begin
        ReadSectionValues('windows',sl);
        for i:=0 to sl.Count-1 do
          if (LowerCase(sl.Names[i])='run') or (LowerCase(sl.Names[i])='load') then begin
            f:=TrimAll(ReadString('windows',sl.Names[i],''));
            if f<>'' then begin
              p:=AllocMem(Length(f)+1);
              StrPCopy(p,f);
              FWININI_Runs.AddObject(sl.Names[i],@p^);
            end;
          end;
        Free;
      end;

      with TINIFile.Create('SYSTEM.INI') do begin
        ReadSectionValues('boot',sl);
        for i:=0 to sl.Count-1 do
          if (LowerCase(sl.Names[i])='run') or (LowerCase(sl.Names[i])='load') or (LowerCase(sl.Names[i])='shell') then begin
            f:=TrimAll(ReadString('boot',sl.Names[i],''));
            if f<>'' then begin
              p:=AllocMem(Length(f)+1);
              StrPCopy(p,f);
              FSYSTEMINI_Runs.AddObject(sl.Names[i],@p^);
            end;
          end;
        Free;
      end;

    finally
      SysUtils.FindClose(fi);
      if Assigned(sl) then
        sl.Free;
      if Assigned(kl) then
        kl.Free;
      Free;
    end;

  {$IFDEF ERROR_INTERCEPT}PopTrace;{$ENDIF}
end;

function TStartup.GetHKCUOnceCount: integer;
begin
  Result:=FHKCUOnce_Runs.Count;
end;

function TStartup.GetRunCommand(AType: TRunType; Index: integer): string;
begin
  try
    case AType of
      rtHKCU: Result:=PChar(FHKCU_Runs.Objects[Index]);
      rtHKLM: Result:=PChar(FHKLM_Runs.Objects[Index]);
      rtHKCUOnce: Result:=PChar(FHKCUOnce_Runs.Objects[Index]);
      rtHKLMOnce: Result:=PChar(FHKLMOnce_Runs.Objects[Index]);
      rtHKCUOnceEx: Result:=PChar(FHKCUOnceEx_Runs.Objects[Index]);
      rtHKLMOnceEx: Result:=PChar(FHKLMOnceEx_Runs.Objects[Index]);
      rtHKLMServices: Result:=PChar(FHKLMServices_Runs.Objects[Index]);
      rtHKLMServicesOnce: Result:=PChar(FHKLMServicesOnce_Runs.Objects[Index]);
      rtHKCUServices: Result:=PChar(FHKCUServices_Runs.Objects[Index]);
      rtHKCUServicesOnce: Result:=PChar(FHKCUServicesOnce_Runs.Objects[Index]);
      rtHKLMSessionManager: Result:=PChar(FHKLMSessionManager_Runs.Objects[Index]);
      rtHKLMWinLogon: Result:=PChar(FHKLMWinLogon_Runs.Objects[Index]);
      rtHKCULoad: Result:=PChar(FHKCULoad_Runs.Objects[Index]);
      rtUser: Result:=PChar(FUser_Runs.Objects[Index]);
      rtCommon: Result:=PChar(FCommon_Runs.Objects[Index]);
      rtWININI: Result:=PChar(FWININI_Runs.Objects[Index]);
      rtSYSTEMINI: Result:=PChar(FSYSTEMINI_Runs.Objects[Index]);
    end;
  except
    Result:='';
  end;
end;

function TStartup.GetRunHKCUOnce(Index: integer): string;
begin
  try
    Result:=FHKCUOnce_Runs[Index];
  except
    Result:='';
  end;
end;

function TStartup.GetSYSTEMINICount: integer;
begin
  Result:=FSYSTEMINI_Runs.Count;
end;

function TStartup.GetSYSTEMINIRun(Index: integer): string;
begin
  try
    Result:=FSYSTEMINI_Runs[Index];
  except
    Result:='';
  end;
end;

function TStartup.GetUserCount: integer;
begin
  Result:=FUser_Runs.Count;
end;

function TStartup.GetUserRun(Index: integer): string;
begin
  try
    Result:=FUser_Runs[Index];
  except
    Result:='';
  end;
end;

function TStartup.GetWININICount: integer;
begin
  Result:=FWININI_Runs.Count;
end;

function TStartup.GetWININIRun(Index: integer): string;
begin
  try
    Result:=FWININI_Runs[Index];
  except
    Result:='';
  end;
end;

procedure TStartup.Report;
var
  i,n: integer;
begin
  {$IFDEF ERROR_INTERCEPT}PushTrace(FModes,Self,'Report'); {$ENDIF}
  with sl do begin
    if Standalone then ReportHeader(sl);
    Add('<Startup classname="TStartup">');

    Add('<section name="UserStartup">');
    n:=User_Count;
    Add(Format('<data name="Count" type="integer">%d</data>',[n]));
    for i:=0 to n-1 do
      Add(Format('<data name="%s" type="string">%s</data>',[CheckXMLValue(User_Runs[i]),CheckXMLValue(GetRunCommand(rtUser,i))]));
    Add('</section>');

    Add('<section name="CommonStartup">');
    n:=Common_Count;
    Add(Format('<data name="Count" type="integer">%d</data>',[n]));
    for i:=0 to n-1 do
      Add(Format('<data name="%s" type="string">%s</data>',[CheckXMLValue(Common_Runs[i]),CheckXMLValue(GetRunCommand(rtCommon,i))]));
    Add('</section>');

    Add('<section name="HKLM_Run">');
    n:=HKLM_Count;
    Add(Format('<data name="Count" type="integer">%d</data>',[n]));
    for i:=0 to n-1 do
      Add(Format('<data name="%s" type="string">%s</data>',[CheckXMLValue(HKLM_Runs[i]),CheckXMLValue(GetRunCommand(rtHKLM,i))]));
    Add('</section>');

    Add('<section name="HKLM_Once">');
    n:=HKLMOnce_Count;
    Add(Format('<data name="Count" type="integer">%d</data>',[n]));
    for i:=0 to n-1 do
      Add(Format('<data name="%s" type="string">%s</data>',[CheckXMLValue(HKLMOnce_Runs[i]),CheckXMLValue(GetRunCommand(rtHKLMOnce,i))]));
    Add('</section>');

    Add('<section name="HKLM_OnceEx">');
    n:=HKLMOnceEx_Count;
    Add(Format('<data name="Count" type="integer">%d</data>',[n]));
    for i:=0 to n-1 do
      Add(Format('<data name="%s" type="string">%s</data>',[CheckXMLValue(HKLMOnceEx_Runs[i]),CheckXMLValue(GetRunCommand(rtHKLMOnceEx,i))]));
    Add('</section>');

    Add('<section name="HKLM_Services">');
    n:=HKLMServices_Count;
    Add(Format('<data name="Count" type="integer">%d</data>',[n]));
    for i:=0 to n-1 do
      Add(Format('<data name="%s" type="string">%s</data>',[CheckXMLValue(HKLMServices_Runs[i]),CheckXMLValue(GetRunCommand(rtHKLMServices,i))]));
    Add('</section>');

    Add('<section name="HKLM_ServicesOnce">');
    n:=HKLMServicesOnce_Count;
    Add(Format('<data name="Count" type="integer">%d</data>',[n]));
    for i:=0 to n-1 do
      Add(Format('<data name="%s" type="string">%s</data>',[CheckXMLValue(HKLMServicesOnce_Runs[i]),CheckXMLValue(GetRunCommand(rtHKLMServicesOnce,i))]));
    Add('</section>');

    Add('<section name="HKLM_SessionManager">');
    n:=HKLMSessionManager_Count;
    Add(Format('<data name="Count" type="integer">%d</data>',[n]));
    for i:=0 to n-1 do
      Add(Format('<data name="%s" type="string">%s</data>',[CheckXMLValue(HKLMSessionManager_Runs[i]),CheckXMLValue(GetRunCommand(rtHKLMSessionManager,i))]));
    Add('</section>');

    Add('<section name="HKLM_WinLogon">');
    n:=HKLMWinLogon_Count;
    Add(Format('<data name="Count" type="integer">%d</data>',[n]));
    for i:=0 to n-1 do
      Add(Format('<data name="%s" type="string">%s</data>',[CheckXMLValue(HKLMWinLogon_Runs[i]),CheckXMLValue(GetRunCommand(rtHKLMWinLogon,i))]));
    Add('</section>');

    Add('<section name="HKCU_Run">');
    n:=HKCU_Count;
    Add(Format('<data name="Count" type="integer">%d</data>',[n]));
    for i:=0 to n-1 do
      Add(Format('<data name="%s" type="string">%s</data>',[CheckXMLValue(HKCU_Runs[i]),CheckXMLValue(GetRunCommand(rtHKCU,i))]));
    Add('</section>');

    Add('<section name="HKCU_Once">');
    n:=HKCUOnce_Count;
    Add(Format('<data name="Count" type="integer">%d</data>',[n]));
    for i:=0 to n-1 do
      Add(Format('<data name="%s" type="string">%s</data>',[CheckXMLValue(HKCUOnce_Runs[i]),CheckXMLValue(GetRunCommand(rtHKCUOnce,i))]));
    Add('</section>');

    Add('<section name="HKCU_OnceEx">');
    n:=HKCUOnceEx_Count;
    Add(Format('<data name="Count" type="integer">%d</data>',[n]));
    for i:=0 to n-1 do
      Add(Format('<data name="%s" type="string">%s</data>',[CheckXMLValue(HKCUOnceEx_Runs[i]),CheckXMLValue(GetRunCommand(rtHKCUOnceEx,i))]));
    Add('</section>');

    Add('<section name="HKCU_Services">');
    n:=HKCUServices_Count;
    Add(Format('<data name="Count" type="integer">%d</data>',[n]));
    for i:=0 to n-1 do
      Add(Format('<data name="%s" type="string">%s</data>',[CheckXMLValue(HKCUServices_Runs[i]),CheckXMLValue(GetRunCommand(rtHKCUServices,i))]));
    Add('</section>');

    Add('<section name="HKCU_ServicesOnce">');
    n:=HKCUServicesOnce_Count;
    Add(Format('<data name="Count" type="integer">%d</data>',[n]));
    for i:=0 to n-1 do
      Add(Format('<data name="%s" type="string">%s</data>',[CheckXMLValue(HKCUServicesOnce_Runs[i]),CheckXMLValue(GetRunCommand(rtHKCUServicesOnce,i))]));
    Add('</section>');

    Add('<section name="HKCU_Load">');
    n:=HKCULoad_Count;
    Add(Format('<data name="Count" type="integer">%d</data>',[n]));
    for i:=0 to n-1 do
      Add(Format('<data name="%s" type="string">%s</data>',[CheckXMLValue(HKCULoad_Runs[i]),CheckXMLValue(GetRunCommand(rtHKCULoad,i))]));
    Add('</section>');

    Add('<section name="WIN_INI">');
    n:=WININI_Count;
    Add(Format('<data name="Count" type="integer">%d</data>',[n]));
    for i:=0 to n-1 do
      Add(Format('<data name="%s" type="string">%s</data>',[CheckXMLValue(WININI_Runs[i]),CheckXMLValue(GetRunCommand(rtWinINI,i))]));
    Add('</section>');

    Add('<section name="SYSTEM_INI">');
    n:=SYSTEMINI_Count;
    Add(Format('<data name="Count" type="integer">%d</data>',[n]));
    for i:=0 to n-1 do
      Add(Format('<data name="%s" type="string">%s</data>',[CheckXMLValue(SYSTEMINI_Runs[i]),CheckXMLValue(GetRunCommand(rtSystemINI,i))]));
    Add('</section>');

    Add('</Startup>');
    if Standalone then ReportFooter(sl);
  end;
  {$IFDEF ERROR_INTERCEPT}PopTrace;{$ENDIF}
end;

{$IFNDEF D6PLUS}
procedure TStartup.SetCount(const Value: integer);
begin

end;
{$ENDIF}

function TStartup.GetHKCUOnceExCount: integer;
begin
  Result:=FHKCUOnceEx_Runs.Count;
end;

function TStartup.GetHKLMOnceCount: integer;
begin
  Result:=FHKLMOnce_Runs.Count;
end;

function TStartup.GetHKLMOnceExCount: integer;
begin
  Result:=FHKLMOnceEx_Runs.Count;
end;

function TStartup.GetHKLMServicesCount: integer;
begin
  Result:=FHKLMServices_Runs.Count;
end;

function TStartup.GetRunHKCUOnceEx(Index: integer): string;
begin
  try
    Result:=FHKCUOnce_Runs[Index];
  except
    Result:='';
  end;
end;

function TStartup.GetRunHKLMOnce(Index: integer): string;
begin
  try
    Result:=FHKLMOnce_Runs[Index];
  except
    Result:='';
  end;
end;

function TStartup.GetRunHKLMOnceEx(Index: integer): string;
begin
  try
    Result:=FHKLMOnceEx_Runs[Index];
  except
    Result:='';
  end;
end;

function TStartup.GetRunHKLMServices(Index: integer): string;
begin
  try
    Result:=FHKLMServices_Runs[Index];
  except
    Result:='';
  end;
end;

function TStartup.GetHKLMServicesOnceCount: integer;
begin
  Result:=FHKLMServicesOnce_Runs.Count;
end;

function TStartup.GetRunHKLMServicesOnce(Index: integer): string;
begin
  try
    Result:=FHKLMServicesOnce_Runs[Index];
  except
    Result:='';
  end;
end;

function TStartup.GetHKCUServicesCount: integer;
begin
  Result:=FHKCUServices_Runs.Count;
end;

function TStartup.GetHKCUServicesOnceCount: integer;
begin
  Result:=FHKCUServicesOnce_Runs.Count;
end;

function TStartup.GetRunHKCUServices(Index: integer): string;
begin
  try
    Result:=FHKCUServices_Runs[Index];
  except
    Result:='';
  end;
end;

function TStartup.GetRunHKCUServicesOnce(Index: integer): string;
begin
  try
    Result:=FHKCUServicesOnce_Runs[Index];
  except
    Result:='';
  end;
end;

function TStartup.GetHKLMSessionManagerCount: integer;
begin
  Result:=FHKLMSessionManager_Runs.Count;
end;

function TStartup.GetHKCULoadCount: integer;
begin
  Result:=FHKCULoad_Runs.Count;
end;

function TStartup.GetHKLMWinLogonCount: integer;
begin
  Result:=FHKLMWinLogon_Runs.Count;
end;

function TStartup.GetRunHKLMSessionManager(Index: integer): string;
begin
  try
    Result:=FHKLMSessionManager_Runs[Index];
  except
    Result:='';
  end;
end;

function TStartup.GetRunHKCULoad(Index: integer): string;
begin
  try
    Result:=FHKCULoad_Runs[Index];
  except
    Result:='';
  end;
end;

function TStartup.GetRunHKLMWinLogon(Index: integer): string;
begin
  try
    Result:=FHKLMWinLogon_Runs[Index];
  except
    Result:='';
  end;
end;

procedure TStartup.SetMode(const Value: TExceptionModes);
begin
  FModes := Value;
end;

end.

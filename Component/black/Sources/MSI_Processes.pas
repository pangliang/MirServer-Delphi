
{*******************************************************}
{                                                       }
{         MiTeC System Information Component            }
{               Process Enumeration Part                }
{           version 8.6.4 for Delphi 5,6,7              }
{                                                       }
{       Copyright © 1997,2004 Michal Mutl               }
{                                                       }
{*******************************************************}

{$INCLUDE MITEC_DEF.INC}


unit MSI_Processes;

interface

uses
  MSI_Common, SysUtils, Windows, Classes, MiTeC_Native, MiTeC_AdvAPI, MiTeC_Routines;

type
  TThreadInfo = TSystemThreadInformation;

  TThreadList = array of TThreadInfo;

  TModuleInfo = record
    Name,
    ImageName: ShortString;
    ImageSize: DWORD;
    EntryPoint: DWORD;
    BaseAddress: DWORD;
  end;

  TModuleList = array of TModuleInfo;

  TDriverInfo = record
    Name: shortstring;
    LoadCount: DWORD;
    Flags: DWORD;
    Base: DWORD;
    Size: int64;
  end;

  TDriverList = array of TDriverInfo;

  TServiceInfo = record
    DependOnService,
    DisplayName,
    Name,
    ImageName,
    ObjectName,
    Group,
    Description: shortstring;
    StartUp,
    Status,
    Tag,
    ErrCtrl :Integer;
    Typ: TServiceType;
  end;

  TServiceList = array of TServiceInfo;

  TWindowList = array of TWindowInfo;

  THandleInfo = record
    PID: DWORD;
    Handle: WORD;
    Typ: Word;
    Access: DWORD;
    Address: DWORD;
    Name: shortstring;
    TypeName: ShortString;
  end;

  THandleList = array of THandleInfo;

  THeapBlockInfo = record
  end;

  THeapBlockList = array of THeapBlockInfo;

  THeapListInfo = record
    HeapBlocks: THeapBlockList;
  end;

  THeapListList = array of THeapListInfo;

  PGetFilenameThreadParam = ^TGetFilenameThreadParam;
  TGetFilenameThreadParam = record
    Handle: DWORD;
    Buffer: array[0..255] of Char;
    Status: DWORD;
  end;

  TProcessInfo = record
    PID :DWORD;
    Name,
    ImageName,
    UserName: shortstring;
    Priority,
    Usage,
    ParentPID,
    HandleCount,
    ThreadCount,
    HeapID,
    ModuleID: DWORD;
    CreateTime: LARGE_INTEGER;
    LastUserTime,UserTime: LARGE_INTEGER;
    LastKernelTime,KernelTime: LARGE_INTEGER;
    VMCounters: TVMCounters;
    IOCounters: TIOCounters;
//    HeapLists: THeapListList;
    Modules: TModuleList;
    Threads :TThreadList;
    Privileges: TPrivilegeList;
    Groups: TTokenGroupList;
  end;

  TProcList = array of TProcessInfo;

  TProcessList = class(TPersistent)
  private
    FPL: TProcList;
    FDL: TDriverList;
    FHL: THandleList;
    FSL: TServiceList;
    FWL: TWindowList;
    FModes: TExceptionModes;
    function GetProcessCount: integer;
    function GetProcess(Index: DWORD): TProcessInfo;
    function GetHandleCount: Integer;
    function GetDriverCount: Integer;
    function GetDriver(Index: DWORD): TDriverInfo;
    function GetThreadCount: Integer;
    function GetHandle(Index: DWORD): THandleInfo;
    function GetService(Index: DWORD): TServiceInfo;
    function GetWin(Index: DWORD): TWindowInfo;

    procedure FreeProcessList(var AList: TProcList);
    procedure ClearProcessInfo(var ARecord: TProcessInfo);
    procedure FreeWinList(var AList: TWindowList);
    procedure SetMode(const Value: TExceptionModes);
    function GetServiceCount: integer;
    function GetWindowCount: integer;
  protected
    procedure GetHandles(var AList: THandleList);
    procedure GetDrivers(var AList: TDriverList);
    procedure GetWindows(var AList: TWindowList);
    procedure GetServices(var AList: TServiceList);
  public
    constructor Create;
    destructor Destroy; override;
    procedure GetInfo;
    procedure Report(var sl: TStringList; Standalone: Boolean = True); virtual;

    function FindProcess(APID: DWORD): Integer;
    function FindDriver(ALoadCnt: DWORD): Integer;
    function FindHandle(AHandle: DWORD): Integer;
    function FindService(AName: string): Integer;
    function FindWindow(AHandle: DWORD): Integer;
    procedure FindServiceDependants(AName: string; var AList: TStringList);
    function LookupServiceDisplayName(AName: string): string;

    property Processes[Index: DWORD]: TProcessInfo read GetProcess;
    property Drivers[Index: DWORD]: TDriverInfo read GetDriver;
    property Handles[Index: DWORD]: THandleInfo read GetHandle;
    property Services[Index: DWORD]: TServiceInfo read GetService;
    property Windows[Index: DWORD]: TWindowInfo read GetWin;
  published
    property ExceptionModes: TExceptionModes read FModes Write SetMode;

    property ProcessCount: integer read GetProcessCount stored False;
    property HandleCount: integer read GetHandleCount stored False;
    property DriverCount: integer read GetDriverCount stored False;
    property ThreadCount: integer read GetThreadCount stored False;
    property ServiceCount: integer read GetServiceCount stored False;
    property WindowCount: integer read GetWindowCount stored False;
  end;

resourcestring
  rsSystemIdle = '[System Idle Process]';

implementation

uses Math, TlHelp32, MiTeC_Datetime, MiTeC_PSAPI;

function GetFileNameThreadExecute(Parameter: Pointer): integer;
var
  iob: array[0..1] of DWORD;
  n: DWORD;
  p: Pointer;
  status: DWORD;
begin
  Zeromemory(@PGetFilenameThreadParam(Parameter).Buffer,SizeOf(255));
  n:=$100;
  p:=AllocMem(n);
  try
    PGetFilenameThreadParam(Parameter)^.Status:=NtQueryInformationFile(PGetFilenameThreadParam(Parameter).Handle,pio_status_block(@iob),p,n,FileNameInformation);
    if status=STATUS_SUCCESS then
      StrPCopy(PChar(@PGetFilenameThreadParam(Parameter).Buffer),Copy(WideCharToString(PWideChar(p)+2),1,PWORD(p)^ div 2));
  finally
    Freemem(p);
  end;
  Result:=0;
end;

{ TProcessList }

procedure CopyPE32ToPI(Source: TPROCESSENTRY32; var Target: TProcessInfo);
var
  ms,ph,ts: THandle;
  mh: array[0..1023] of THandle;
  me32: TMODULEENTRY32;
  th32: TTHREADENTRY32;
  sz: array[0..255] of Char;
  i,n: dword;
  mi: MiTeC_PSAPI.TModuleInfo;
  s1,s2: string;
begin
  Target.PID:=Source.th32ProcessID;
  Target.ParentPID:=Source.th32ParentProcessID;
  if (Win32Platform=VER_PLATFORM_WIN32_NT) then begin
    ph:=OpenProcess(PROCESS_QUERY_INFORMATION or PROCESS_VM_READ,false,Source.th32ProcessID);
    if (ph<>INVALID_HANDLE_VALUE) then
      try
        if EnumProcessModules(ph,PHinst(@mh),SizeOf(mh),n) then begin
          for i:=0 to n div SizeOf(THandle)-1 do begin
            if Boolean(GetModuleFileNameEx(ph,mh[i],PChar(@sz),MAX_PATH)) then begin
              if i=0 then
                Target.ImageName:=string(sz);
              SetLength(Target.Modules,Length(Target.Modules)+1);
              with Target.Modules[High(Target.Modules)] do begin
                Name:=ExtractFilename(string(sz));
                ImageName:=string(sz);
                if GetModuleInformation(ph,mh[i],mi,SizeOf(mi)) then begin
                  ImageSize:=mi.SizeOfImage;
                  BaseAddress:=PDWORD(@(mi.lpBaseOfDll))^;
                  EntryPoint:=PDWORD(@(mi.EntryPoint))^;
                end;
              end;
            end;
          end;
        end;
        GetProcessUserName(ph,s1,s2);
        if s2='' then
          Target.UserName:=s1
        else
          Target.UserName:=Format('%s/%s',[s2,s1]);
        GetProcessPrivileges(ph,Target.Privileges);
        GetProcessGroups(ph,Target.Groups);
      finally
        Closehandle(ph);
      end;
  end;
  if not FileExists(Target.ImageName) then
    Target.ImageName:=ExpandFilename(FileSearch(Source.szExeFile,ExtractFilePath(Source.szExeFile)+';'+GetWinSysDir));
  Target.Name:=ExtractFilename(Target.ImageName);
  if (Target.Name='') and (Target.PID=0) then
    Target.Name:=rsSystemIdle;
  Target.Priority:=Source.pcPriClassBase;
  Target.Usage:=Source.cntUsage;
  Target.HeapID:=Source.th32DefaultHeapID;
  Target.ModuleID:=Source.th32ModuleID;
  Target.ThreadCount:=Source.cntThreads;
  if (Target.PID<>0) and (Length(Target.Modules)<2) then begin
    ms:=CreateToolhelp32Snapshot(TH32CS_SNAPMODULE,Source.th32ProcessID);
    try
      if (ms<>INVALID_HANDLE_VALUE) then begin
        me32.dwSize:=sizeof(TMODULEENTRY32);
        if Module32First(ms,me32) then begin
          SetLength(Target.Modules,Length(Target.Modules)+1);
          with Target.Modules[High(Target.Modules)] do begin
            Name:=string(me32.szModule);
            ImageName:=string(me32.szExePath);
            BaseAddress:=PDWORD(@(me32.modBaseAddr))^;
            EntryPoint:=0;
            ImageSize:=me32.modBaseSize;
          end;
          while Module32Next(ms,me32) do begin
            SetLength(Target.Modules,Length(Target.Modules)+1);
            with Target.Modules[High(Target.Modules)] do begin
              Name:=string(me32.szModule);
              ImageName:=string(me32.szExePath);
              BaseAddress:=PDWORD(@(me32.modBaseAddr))^;
              EntryPoint:=0;
              ImageSize:=me32.modBaseSize;
            end;
          end;
        end;
      end;
    finally
      CloseHandle(ms);
    end;
  end;
  if (Win32Platform<>VER_PLATFORM_WIN32_NT) and (Length(Target.Threads)=0) then begin
    ts:=CreateToolhelp32Snapshot(TH32CS_SNAPTHREAD,Source.th32ProcessID);
    try
      if (ts<>INVALID_HANDLE_VALUE) then begin
        th32.dwSize:=sizeof(TTHREADENTRY32);
        if Thread32First(ts,th32) then begin
          if th32.th32OwnerProcessID=Source.th32ProcessID then begin
            SetLength(Target.Threads,Length(Target.Threads)+1);
            ZeroMemory(@Target.Threads[High(Target.Threads)],SizeOf(Target.Threads[High(Target.Threads)]));
            with Target.Threads[High(Target.Threads)] do begin
              ClientID.UniqueProcess:=th32.th32OwnerProcessID;
              ClientID.UniqueThread:=th32.th32ThreadID;
              BasePriority:=th32.tpBasePri;
              Priority:=th32.tpBasePri+th32.tpDeltaPri;
            end;
          end;
          while Thread32Next(ts,th32) do begin
            if th32.th32OwnerProcessID=Source.th32ProcessID then begin
              SetLength(Target.Threads,Length(Target.Threads)+1);
              ZeroMemory(@Target.Threads[High(Target.Threads)],SizeOf(Target.Threads[High(Target.Threads)]));
              with Target.Threads[High(Target.Threads)] do begin
                ClientID.UniqueProcess:=th32.th32OwnerProcessID;
                ClientID.UniqueThread:=th32.th32ThreadID;
                StartAddress:=nil;
                BasePriority:=th32.tpBasePri;
                Priority:=th32.tpBasePri+th32.tpDeltaPri;
              end;
            end;
          end;
        end;
      end;
    finally
      CloseHandle(ts);
    end;
  end;
end;

procedure CopySPIToPI(Source: TSystemProcessInformation; var Target: TProcessInfo);
var
  i: Integer;
begin
  Target.PID:=Source.ProcessId;
  if Source.ProcessName.Buffer=nil then
    Target.Name:=''
  else
    Target.Name:=Trim(WideCharToString(Source.ProcessName.Buffer));
  if (Target.Name='') and (Target.PID=0) then
    Target.Name:=rsSystemIdle;
  Target.Priority:=Source.BasePriority;
  Target.ParentPID:=Source.InheritedFromProcessId;
  Target.ThreadCount:=Source.ThreadCount;
  Target.HandleCount:=Source.HandleCount;
  Target.CreateTime:=Source.CreateTime;
  Target.LastUserTime:=Target.UserTime;
  Target.LastKernelTime:=Target.KernelTime;
  Target.UserTime:=Source.UserTime;
  Target.KernelTime:=Source.KernelTime;
  Target.VMCounters:=Source.VmCounters;
  Target.IOCounters:=Source.IoCounters;

  if (Length(Target.Threads)=0) then begin
    //psti:=@Source.Threads[0];
    for i:=0 to Source.ThreadCount-1 do begin
      SetLength(Target.Threads,Length(Target.Threads)+1);
      Target.Threads[High(Target.Threads)]:=Source.Threads[i];
      //psti:=PSystemThreadInformation(PChar(psti)+SizeOf(TSystemThreadInformation)*i);
    end;
  end;
end;

procedure TProcessList.ClearProcessInfo(var ARecord: TProcessInfo);
begin
  Finalize(ARecord.Modules);
  Finalize(ARecord.Threads);
  Finalize(ARecord.Privileges);
  Finalize(ARecord.Groups);
  {for j:=0 to High(ARecord.HeapLists) do
    Finalize(ARecord.HeapLists[j].HeapBlocks);
  Finalize(ARecord.HeapLists);}
  ZeroMemory(@ARecord,SizeOf(ARecord));
end;

constructor TProcessList.Create;
begin
  ExceptionModes:=[emExceptionStack];
  if Win32Platform=VER_PLATFORM_WIN32_NT then begin
    EnablePrivilege(SE_DEBUG_NAME);
    EnablePrivilege(SE_SECURITY_NAME);
    InitPSAPI;
    InitNativeAPI;
    InitAdvAPI;
  end;
end;

destructor TProcessList.Destroy;
begin
  FreeProcessList(FPL);
  Finalize(FDL);
  Finalize(FHL);
  FreeWinList(FWL);
  Finalize(FSL);
  inherited;
end;

function TProcessList.FindProcess(APID: DWORD): integer;
var
  i: Integer;
begin
  Result:=-1;
  for i:=0 to High(FPL) do
    if APID=FPL[i].PID then begin
      Result:=i;
      Break;
    end;
end;

function TProcessList.FindDriver;
var
  i: Integer;
begin
  Result:=-1;
  for i:=0 to High(FDL) do
    if ALoadCnt=FDL[i].LoadCount then begin
      Result:=i;
      Break;
    end;
end;

procedure TProcessList.FreeProcessList;
var
  i: Integer;
begin
  for i:=0 to High(AList) do
    ClearProcessInfo(AList[i]);
  Finalize(AList);
end;

procedure TProcessList.GetHandles;
var
  Buffer, p: Pointer;
  status,c,ap: DWORD;
  pshi: PSystemHandleInformation;
  i: TSystemHandleType;

  n,br :DWORD;

  ph,oh,th: THandle;

  param: TGetFilenameThreadParam;
begin
  {$IFDEF ERROR_INTERCEPT}PushTrace(FModes,Self,'GetHandles'); {$ENDIF}

  Finalize(AList);

  SetLength(AList,ARRAY_PRE_SIZE);
  ap:=0;

  if (Win32Platform<>VER_PLATFORM_WIN32_NT) then
    Exit;

  Buffer:=nil;
  n:=$100;
  Buffer:=AllocMem(n*SizeOf(TSystemHandleInformation));
  try
    status:=NtQuerySystemInformation(SystemHandleInformation,Buffer,n,@br);
    while (status=STATUS_BUFFER_OVERFLOW) or (status=STATUS_INFO_LENGTH_MISMATCH) do begin
      n:=Max(br,n*2);
      ReallocMem(Buffer,n*SizeOf(TSystemHandleInformation));
      status:=NtQuerySystemInformation(SystemHandleInformation,Buffer,n*SizeOf(TSystemHandleInformation),@br);
    end;
    if status=STATUS_SUCCESS then begin
      c:=0;
      //pshi:=PSystemHandleInformation(Buffer);
      pshi:=PSystemHandleInformation(PChar(Buffer)+SizeOf(DWORD));
      p:=AllocMem(n);
      try
        repeat
          status:=0;
          if not(IsNT4 and (pshi^.ProcessID=2) and (pshi^.HandleType=16)) and (pshi^.HandleNumber>0) then begin
            if ap=Length(AList) then
              SetLength(AList,Length(AList)+ARRAY_PRE_SIZE);
            with AList[ap] do begin
              PID:=pshi^.ProcessId;
              Handle:=pshi^.HandleNumber;
              Access:=pshi^.Flags;
              Typ:=pshi^.HandleType;
              Address:=pshi^.KernelAddress;
              try
                if pshi^.HandleType>27 then
                  TypeName:=Format('Unknown type %d',[pshi^.HandleType])
                else
                  TypeName:=cSystemhandleType[TSystemHandleType(pshi^.HandleType)];
              except
              end;
              if pshi^.ProcessId<>GetCurrentProcessID then begin
                ph:=OpenProcess(PROCESS_DUP_HANDLE,False,pshi^.ProcessId);
                status:=NtDuplicateObject(ph,pshi^.HandleNumber,GetCurrentProcess,@oh,0,0,DUPLICATE_SAME_ACCESS);
              end else
                oh:=pshi^.HandleNumber;

              if status=STATUS_SUCCESS then begin
                NtQueryObject(oh,ObjectTypeInformation,nil,0,@n);
                ReallocMem(p,n);
                status:=NtQueryObject(oh,ObjectTypeInformation,p,n,nil);
                if status=STATUS_SUCCESS then
                  TypeName:=string(PObjectTypeInformation(p).Name.Buffer);
                for i:=Low(TSystemHandleType) to High(TSystemHandleType) do
                  if SameText(TypeName,cSystemHandleType[i]) then begin
                    Typ:=DWORD(i);
                  end;

                Name:='';
                case TSystemHandleType(Typ) of
                  OB_TYPE_PROCESS: begin
                    n:=SizeOf(TProcessBasicInformation);
                    ReAllocMem(p,n);
                    status:=NtQueryInformationProcess(oh,ProcessBasicInformation,p,n,nil);
                    if status=STATUS_SUCCESS then
                      Name:=Format('PID: %d',[PProcessBasicInformation(p)^.UniqueProcessID]);
                  end;
                  OB_TYPE_THREAD: begin
                    n:=SizeOf(TThreadBasicInformation);
                    ReAllocMem(p,n);
                    status:=NtQueryInformationThread(oh,ThreadBasicInformation,p,n,nil);
                    if status=STATUS_SUCCESS then
                      Name:=Format('TID: %d (PID: %d)',[PThreadBasicInformation(p)^.ClientID.UniqueThread,PThreadBasicInformation(p)^.ClientID.UniqueProcess]);
                  end;
                  OB_TYPE_FILE: begin
                    {param.Handle:=oh;
                    th:=BeginThread(nil,0,GetFileNameThreadExecute,@param,0,n);
                    if (WaitForSingleObject(th,100)=WAIT_TIMEOUT) then
                      TerminateThread(th,0);
                    Name:=string(param.Buffer);}
                    Name:='';
                  end;
                  else begin
                    NtQueryObject(oh,ObjectNameInformation,nil,0,@n);
                    ReAllocMem(p,n);
                    status:=NtQueryObject(oh,ObjectNameInformation,p,n,nil);
                    if (status=STATUS_SUCCESS) and (PDWORD(p)^>0) then
                      Name:=WideCharToString(PWideChar(p)+4);
                  end;
                end;
                if pshi^.ProcessId<>GetCurrentProcessID then begin
                  CloseHandle(ph);
                  NtClose(oh);
                end;
              end;
            end;
            Inc(ap);
          end;
          Inc(c);
          if c>PDWORD(Buffer)^ then
            Break;
          pshi:=PSystemHandleInformation(PChar(pshi)+SizeOf(pshi^));
        until pshi=nil;
      finally
        Freemem(p);
        SetLength(AList,ap);
      end;
    end;
  finally
    Freemem(Buffer);
  end;

  {$IFDEF ERROR_INTERCEPT}PopTrace;{$ENDIF}
end;

procedure TProcessList.GetDrivers;
var
  Buffer: Pointer;
  status,c: DWORD;
  psmi: PSystemModuleInformation;

  n,br :DWORD;
begin
  {$IFDEF ERROR_INTERCEPT}PushTrace(FModes,Self,'GetDrivers'); {$ENDIF}

  Finalize(AList);

  if (Win32Platform<>VER_PLATFORM_WIN32_NT) then
    Exit;

  Buffer:=nil;
  n:=32768;
  Buffer:=AllocMem(n);
  try
    status:=NtQuerySystemInformation(SystemModuleInformation,Buffer,n,@br);
    while (status=STATUS_BUFFER_OVERFLOW) or (status=STATUS_INFO_LENGTH_MISMATCH) do begin
      n:=Max(br,n+1024);
      ReallocMem(Buffer,n);
      status:=NtQuerySystemInformation(SystemModuleInformation,Buffer,n,@br);
    end;
    if status=STATUS_SUCCESS then begin
      c:=0;
      psmi:=PSystemModuleInformation(Buffer);
      repeat
        SetLength(AList,Length(AList)+1);
        with AList[High(AList)] do begin
          Name:=PChar(@psmi^.ImageName)+4;
          Size:=psmi^.Size;
          Flags:=psmi^.Flags;
          Base:=PDWORD(@(psmi^.Base))^;
          LoadCount:=psmi^.LoadCount;
        end;
        Inc(c,SizeOf(TSystemModuleInformation));
        if c>=br-SizeOf(TSystemModuleInformation) then
          Break;
        psmi:=PSystemModuleInformation(PChar(psmi)+SizeOf(psmi^));
      until psmi=nil;
    end;
  finally
    Freemem(Buffer);
  end;
  {$IFDEF ERROR_INTERCEPT}PopTrace;{$ENDIF}
end;

procedure TProcessList.GetInfo;
var
  ps :THandle;
  pe32 :TPROCESSENTRY32;
  pi: TProcessInfo;

  Buffer: Pointer;
  status: DWORD;
  pspi: PSystemProcessInformation;

  idx: Integer;
  n,br :DWORD;
begin
  {$IFDEF ERROR_INTERCEPT}PushTrace(FModes,Self,'GetInfo'); {$ENDIF}

  FreeWinList(FWL);
  GetWindows(FWL);

  Buffer:=nil;
  FreeProcessList(FPL);
  if OS<>osNT4 then begin
    ps:=CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS,0);
    try
      if (ps<>INVALID_HANDLE_VALUE) then begin
        pe32.dwSize:=sizeof(TPROCESSENTRY32);
        if Process32First(ps,pe32) then begin
          idx:=FindProcess(pe32.th32ProcessID);
          if idx=-1 then begin
            SetLength(FPL,Length(FPL)+1);
            idx:=High(FPL);
            ClearProcessInfo(pi);
          end else
            pi:=FPL[idx];
          CopyPE32ToPI(pe32,pi);
          FPL[idx]:=pi;
          while Process32Next(ps,pe32) do begin
            ClearProcessInfo(pi);
            CopyPE32ToPI(pe32,pi);
            SetLength(FPL,Length(FPL)+1);
            FPL[High(FPL)]:=pi;
          end;
        end;
      end;
    finally
      CloseHandle(ps);
    end;
  end;
  if IsNT then begin
    try
      n:=$100;
      Buffer:=AllocMem(n*SizeOf(TSystemProcessInformation));
      status:=NtQuerySystemInformation(SystemProcessesAndThreadsInformation,Buffer,n*SizeOf(TSystemProcessInformation),@br);
      while (status=STATUS_BUFFER_OVERFLOW) or (status=STATUS_INFO_LENGTH_MISMATCH) do begin
        n:=Max(br,n*2);
        ReallocMem(Buffer,n*SizeOf(TSystemProcessInformation));
        status:=NtQuerySystemInformation(SystemProcessesAndThreadsInformation,Buffer,n*SizeOf(TSystemProcessInformation),@br);
      end;
      if status=STATUS_SUCCESS then begin
        pspi:=PSystemProcessInformation(Buffer);
        repeat
        //while pspi^.NextEntryDelta<>0 do begin
          idx:=FindProcess(pspi^.ProcessId);
          if idx=-1 then begin
            SetLength(FPL,Length(FPL)+1);
            idx:=High(FPL);
            ClearProcessInfo(pi);
          end else
            pi:=FPL[idx];
          CopySPIToPI(pspi^,pi);

          FPL[idx]:=pi;
          if pspi^.NextEntryDelta=0 then
            Break;
          pspi:=PSystemProcessInformation(PChar(pspi)+pspi^.NextEntryDelta);
        //end;
        until False;
      end;
    finally
      Reallocmem(Buffer,0);
    end;
    GetDrivers(FDL);
    GetHandles(FHL);
    GetServices(FSL);
  end;
  {$IFDEF ERROR_INTERCEPT}PopTrace;{$ENDIF}
end;

function TProcessList.GetProcess;
begin
  ZeroMemory(@Result,SizeOf(TProcessInfo));
  if (Index<Length(FPL)) then
    Result:=FPL[Index];
end;

function TProcessList.GetDriver;
begin
  ZeroMemory(@Result,SizeOf(TDriverInfo));
  if (Index<Length(FDL)) then
    Result:=FDL[Index];
end;

function TProcessList.GetProcessCount: integer;
begin
  Result:=Length(FPL);
end;

function TProcessList.GetHandleCount: integer;
begin
  Result:=Length(FHL);
end;

function TProcessList.GetThreadCount: integer;
var
  i: Integer;
begin
  Result:=0;
  for i:=0 to High(FPL) do
    Result:=Result+FPL[i].ThreadCount;
end;

function TProcessList.GetDriverCount: integer;
begin
  Result:=Length(FDL);
end;

procedure TProcessList.Report;
var
  i: Integer;
begin
  {$IFDEF ERROR_INTERCEPT}PushTrace(FModes,Self,'Report'); {$ENDIF}
  with sl do begin
    if Standalone then ReportHeader(sl);
    Add('<ProcessList classname="TProcessList">');

    for i:=0 to ProcessCount-1 do begin
      Add(Format('<section name="%s">',[CheckXMLValue(Processes[i].Name)]));
      Add(Format('<data name="PID" type="integer">%x</data>',[Processes[i].PID]));
      Add(Format('<data name="ParentPID" type="integer">%x</data>',[Processes[i].ParentPID]));
      Add(Format('<data name="Name" type="string">%s</data>',[CheckXMLValue(Processes[i].Name)]));
      Add(Format('<data name="ImageName" type="string">%s</data>',[CheckXMLValue(Processes[i].ImageName)]));
      Add(Format('<data name="Priority" type="integer">%d</data>',[Processes[i].Priority]));
      Add(Format('<data name="ThreadCount" type="integer">%d</data>',[Processes[i].ThreadCount]));
      if Win32Platform=VER_PLATFORM_WIN32_NT then begin
        Add(Format('<data name="CreateTime" type="string">%s</data>',[FormatSeconds(Processes[i].CreateTime.QuadPart/10000000,True,False,True)]));
        Add(Format('<data name="KernelTime" type="string">%s</data>',[FormatSeconds(Processes[i].KernelTime.QuadPart/10000000,True,False,True)]));
        Add(Format('<data name="UserTime" type="string">%s</data>',[FormatSeconds(Processes[i].UserTime.QuadPart/10000000,True,False,True)]));
        Add(Format('<section name="%s">',['VMCounters']));
          Add(Format('<data name="PeakVirtualSize" type="integer" unit="B">%d</data>',[Processes[i].VMCounters.PeakVirtualSize]));
          Add(Format('<data name="VirtualSize" type="integer" unit="B">%d</data>',[Processes[i].VMCounters.VirtualSize]));
          Add(Format('<data name="PageFaultCount" type="integer">%d</data>',[Processes[i].VMCounters.PageFaultCount]));
          Add(Format('<data name="PeakWorkingSetSize" type="integer" unit="B">%d</data>',[Processes[i].VMCounters.PeakWorkingSetSize]));
          Add(Format('<data name="WorkingSetSize" type="integer" unit="B">%d</data>',[Processes[i].VMCounters.WorkingSetSize]));
          Add(Format('<data name="QuotaPeakPagedPoolUsage" type="integer" unit="B">%d</data>',[Processes[i].VMCounters.QuotaPeakPagedPoolUsage]));
          Add(Format('<data name="QuotaPagedPoolUsage" type="integer" unit="B">%d</data>',[Processes[i].VMCounters.QuotaPagedPoolUsage]));
          Add(Format('<data name="QuotaPeakNonPagedPoolUsage" type="integer" unit="B">%d</data>',[Processes[i].VMCounters.QuotaPeakNonPagedPoolUsage]));
          Add(Format('<data name="QuotaNonPagedPoolUsage" type="integer" unit="B">%d</data>',[Processes[i].VMCounters.QuotaNonPagedPoolUsage]));
          Add(Format('<data name="PagefileUsage" type="integer" unit="B">%d</data>',[Processes[i].VMCounters.PageFileUsage]));
          Add(Format('<data name="PeakPagefileUsage" type="integer" unit="B">%d</data>',[Processes[i].VMCounters.PeakPageFileUsage]));
        Add('</section>');
        Add(Format('<section name="%s">',['IOCounters']));
          Add(Format('<data name="ReadOperationCount" type="integer">%d</data>',[Processes[i].IOCounters.ReadOperationCount.QuadPart]));
          Add(Format('<data name="WriteOperationCount" type="integer">%d</data>',[Processes[i].IOCounters.WriteOperationCount.QuadPart]));
          Add(Format('<data name="OtherOperationCount" type="integer">%d</data>',[Processes[i].IOCounters.OtherOperationCount.QuadPart]));
          Add(Format('<data name="ReadTransferCount" type="integer">%d</data>',[Processes[i].IOCounters.ReadTransferCount.QuadPart]));
          Add(Format('<data name="WriteTransferCount" type="integer">%d</data>',[Processes[i].IOCounters.WriteTransferCount.QuadPart]));
          Add(Format('<data name="OtherTransferCount" type="integer">%d</data>',[Processes[i].IOCounters.OtherTransferCount.QuadPart]));
        Add('</section>');
      end else begin
        Add(Format('<data name="Usage" type="integer">%d</data>',[Processes[i].Usage]));
      end;
      Add('</section>');
    end;

    Add('</ProcessList>');
    if Standalone then ReportFooter(sl);
  end;
  {$IFDEF ERROR_INTERCEPT}PopTrace;{$ENDIF}
end;

procedure TProcessList.SetMode(const Value: TExceptionModes);
begin
  FModes := Value;
end;

function TProcessList.GetHandle(Index: DWORD): THandleInfo;
begin
  ZeroMemory(@Result,SizeOf(THandleInfo));
  if (Index<Length(FHL)) then
    Result:=FHL[Index];
end;

function TProcessList.FindHandle(AHandle: DWORD): Integer;
var
  i: Integer;
begin
  Result:=-1;
  for i:=0 to High(FHL) do
    if AHandle=FHL[i].Handle then begin
      Result:=i;
      Break;
    end;
end;

function TProcessList.FindService;
var
  i: Integer;
begin
  Result:=-1;
  for i:=0 to High(FSL) do
    if SameText(AName,FSL[i].Name) or SameText(AName,FSL[i].DisplayName) then begin
      Result:=i;
      Break;
    end;
end;

function TProcessList.GetService(Index: DWORD): TServiceInfo;
begin
  ZeroMemory(@Result,SizeOf(TServiceInfo));
  if (Index<Length(FSL)) then
    Result:=FSL[Index];
end;

function TProcessList.FindWindow(AHandle: DWORD): Integer;
var
  i: Integer;
begin
  Result:=-1;
  for i:=0 to High(FWL) do
    if AHandle=FWL[i].Handle then begin
      Result:=i;
      Break;
    end;
end;

function TProcessList.GetWin(Index: DWORD): TWindowInfo;
begin
  ZeroMemory(@Result,SizeOf(TWindowInfo));
  if (Index<Length(FWL)) then
    Result:=FWL[Index];
end;

procedure TProcessList.GetServices(var AList: TServiceList);
var
  sl: TStringList;
  i,j: Integer;
  qsp :PQueryServiceConfig;
  s: string;
begin
  {$IFDEF ERROR_INTERCEPT}PushTrace(FModes,Self,'GetServices'); {$ENDIF}

  Finalize(AList);
  s:='';
  sl:=TStringList.Create;
  qsp:=Allocmem(1024);
  try
    ServiceGetList('',SERVICE_WIN32,SERVICE_STATE_ALL,sl);
    for i:=0 to sl.Count-1 do begin
      SetLength(Alist,Length(AList)+1);
      with AList[High(Alist)] do begin
        DisplayName:=sl[i];
        Name:=ServiceGetKeyName('',sl[i]);
        Status:=ServiceGetStatus('',Name);
        ZeroMemory(qsp,1024);
        if ServiceGetConfig('',Name,qsp^) then begin
          ImageName:=StringReplace(string(qsp.lpBinaryPathName),'"','',[rfReplaceAll,rfIgnoreCase]);
          ObjectName:=string(qsp.lpServiceStartName);
          Group:=string(qsp.lpLoadOrderGroup);
          case qsp.dwServiceType of
            SERVICE_KERNEL_DRIVER       :Typ:=svcKernelDriver;
            SERVICE_FILE_SYSTEM_DRIVER  :Typ:=svcFileSystemDriver;
            SERVICE_ADAPTER             :Typ:=svcAdapter;
            SERVICE_RECOGNIZER_DRIVER   :Typ:=svcRecognizerDriver;
            SERVICE_WIN32_OWN_PROCESS   :Typ:=svcOwnProcess;
            SERVICE_WIN32_SHARE_PROCESS :Typ:=svcSharedProcess;
            SERVICE_INTERACTIVE_PROCESS :Typ:=svcDesktopInteractiveDriver;
          end;
          StartUp:=qsp.dwStartType;
          Tag:=qsp.dwTagId;
          ErrCtrl:=qsp.dwErrorControl;
          s:='';
          for j:=0 to 1024 do begin
            if (s='') and (qsp.lpDependencies[j]=#0) then
              break;
            if not (qsp.lpDependencies[j] in [#0,#32]) then
              s:=s+qsp.lpDependencies[j]
            else begin
              if s<>'' then
                DependOnService:=DependOnService+s+' ';
              s:='';
            end;
          end;
          DependOnService:=Trim(DependOnService);
        end;
      end;
    end;
  finally
    Freemem(qsp);
    sl.Free;
  end;

  {$IFDEF ERROR_INTERCEPT}PopTrace;{$ENDIF}
end;

procedure TProcessList.GetWindows(var AList: TWindowList);
var
  ap: DWORD;

  procedure EnumChildWins(AHandle: THandle; var AList: TWindowList);
  begin
    while AHandle<>0 do begin
      if ap=Length(AList) then
        SetLength(AList,Length(AList)+ARRAY_PRE_SIZE);
      AList[ap]:=GetWindowInfo(AHandle);
      Inc(ap);
      EnumChildWins(GetWindow(AHandle,GW_CHILD),AList);
      AHandle:=GetWindow(Ahandle,GW_HWNDNEXT);
    end;
  end;

begin
  {$IFDEF ERROR_INTERCEPT}PushTrace(FModes,Self,'GetWindows'); {$ENDIF}

  Finalize(AList);
  SetLength(Alist,ARRAY_PRE_SIZE);
  ap:=0;
  AList[ap]:=GetWindowInfo(GetDesktopWindow);
  Inc(ap);
  EnumChildWins(GetWindow(GetDesktopWindow,GW_CHILD),AList);
  SetLength(AList,ap);

  {$IFDEF ERROR_INTERCEPT}PopTrace;{$ENDIF}
end;

function TProcessList.GetServiceCount: integer;
begin
  Result:=Length(FSL);
end;

function TProcessList.GetWindowCount: integer;
begin
  Result:=Length(FWL);
end;

procedure TProcessList.FindServiceDependants(AName: string;
  var AList: TStringList);
var
  i: Integer;
begin
  AName:=UpperCase(AName);
  AList.Clear;
  for i:=0 to High(FSL) do
    if Pos(AName,UpperCase(FSL[i].DependOnService))>0 then
      AList.Add(FSL[i].Name);
end;

function TProcessList.LookupServiceDisplayName(AName: string): string;
var
  i: Integer;
begin
  Result:='';
  for i:=0 to High(FSL) do
    if SameText(AName,FSL[i].Name) then begin
      Result:=FSL[i].DisplayName;
      Break;
    end;
end;

procedure TProcessList.FreeWinList;
var
  i: Integer;
begin
  for i:=0 to High(AList) do begin
    AList[i].Styles.Free;
    AList[i].ExStyles.Free;
    AList[i].ClassStyles.Free;
  end;
  Finalize(AList);
end;

end.

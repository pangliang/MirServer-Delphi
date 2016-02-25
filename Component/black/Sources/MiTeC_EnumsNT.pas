{*******************************************************}
{                                                       }
{       MiTeC System Information Component              }
{         Windows NT Process Enumeration                }
{           version 8.1 for Delphi 5,6                  }
{                                                       }
{       Copyright © 1997,2003 Michal Mutl               }
{                                                       }
{*******************************************************}

{$INCLUDE MITEC_DEF.INC}

unit MiTeC_EnumsNT;

interface

uses Windows, Classes, SysUtils, ShellAPI, MiTeC_PerfLibNT;

type
  PNTProcess = ^TNTProcess;
  TNTProcess = record
    PID :longword;
    Name,
    ImageName,
    Domain,
    User :string;
    CPUTime,
    KernelTime,
    UserTime,
    ElapsedTime :int64;
    PriorityBase :integer;
    HandleCount,
    HeapID,
    ThreadCount :longword;
    PageFaultCount,
    PrivateSpace,
    PeakWorkingSetSize,
    WorkingSetSize,
    PagedPoolSize,
    NonPagedPoolSize,
    VirtualAddressSpaceSize,
    PeakVirtualAddressSpaceSize,
    PageFileUsage,
    PeakPageFileUsage,
    ParentPID,
    IOReadOps,
    IOWriteOps,
    IODataOps,
    IOOtherOps,
    IOReadB,
    IOWriteB,
    IODataB,
    IOOtherB :integer;
    Modules,
    Threads,
    HeapLists :tstringlist;
  end;

  PNTModule = ^TNTModule;
  TNTModule = record
    Name,
    ImageName: string;
    ID,
    EntryPoint,
    LoadAddress,
    GlobalUsage,
    ProcessUsage,
    BaseSize,
    Handle,
    ImageSize :longword;
  end;

  PNTThread = ^TNTThread;
  TNTThread = record
    ID,
    Status,
    WaitReason,
    PriorityBase,
    PriorityDelta,
    StartAddr,
    CntxtSwtcs :longword;
    CPUTime :int64;
    szStatus,
    szWaitReason :string;
  end;

  PNTDriver = ^TNTDriver;
  TNTDriver = record
    Group,
    Name,
    ImageName,
    Description,
    szStartUp,
    szTyp,
    szStatus,
    szErrCtrl: string;
    StartUp,
    Typ,
    Tag,
    Status,
    ErrCtrl :integer;
    AcceptPause,
    AcceptStop: Boolean;
  end;

  PNTService = ^TNTService;
  TNTService = record
    DependOnGroup,
    DependOnService,
    DisplayName,
    Name,
    ImageName,
    ObjectName,
    Group,
    Description,
    szStatus,
    szStartUp,
    szTyp,
    szErrCtrl: string;
    StartUp,
    Status,
    Typ,
    Tag,
    ErrCtrl :integer;
  end;

  procedure FreeNTProcessList(var NTProcessList: TStringList);
  procedure GetNTProcessList(APL: TPerfLibNT; var NTProcesslist :tstringlist);
  procedure GetNTProcessInfo(var Process: TNTProcess; APL: TPerfLibNT; APID :integer; ExtInfo :Boolean);

  procedure FreeNTDriverList(var NTDriverList: TStringList);
  procedure GetNTDriverList(var NTDriverlist :tstringlist);

  procedure FreeNTServiceList(var NTServiceList: TStringList);
  procedure GetNTServiceList(AMachine: string; var NTServicelist :tstringlist);

const
  SProcsPO = 'Process';
    SProcsIDPC = 'ID Process';
    SProcsPTPC = '% Processor Time';
    SProcsKTPC = '% Privileged Time';
    SProcsUTPC = '% User Time';
    SProcsWSPC = 'Working Set';
    SProcsWSPPC = 'Working Set Peak';
    SProcsPRPC = 'Priority Base';
    SProcsTCPC = 'Thread Count';
    SProcsPFPC = 'Page Faults/sec';
    SProcsPBPC = 'Private Bytes';
    SProcsPBPPC = 'Private Bytes Peak';
    SProcsPFBPC = 'Page File Bytes';
    SProcsPFBPPC = 'Page File Bytes Peak';
    SProcsETPC = 'Elapsed Time';
    SProcsPPBPC = 'Pool Paged Bytes';
    SProcsPNBPC = 'Pool NonPaged Bytes';
    SProcsHCPC = 'Handle Count';
    SProcsVBPC = 'Virtual Bytes';
    SProcsVBPPC = 'Virtual Bytes Peak';
//Win 2K
    SProcsCIDPC = 'Creating Process ID';
    SProcsIOROPC = 'IO Read Operations/sec';
    SProcsIOWOPC = 'IO Write Operations/sec';
    SProcsIODOPC = 'IO Data Operations/sec';
    SProcsIOOOPC = 'IO Other Operations/sec';
    SProcsIORBPC = 'IO Read Bytes/sec';
    SProcsIOWBPC = 'IO Write Bytes/sec';
    SProcsIODBPC = 'IO Data Bytes/sec';
    SProcsIOOBPC = 'IO Other Bytes/sec';

  SThrdsPO = 'Thread';
    SThrdsPIDPC = 'ID Process';
    SThrdsIDPC = 'ID Thread';
    SThrdsPTPC = '% Processor Time';
    SThrdsKTPC = '% Privileged Time';
    SThrdsUTPC = '% User Time';
    SThrdsCSPC = 'Context Switches/sec';
    SThrdsETPC = 'Elapsed Time';
    SThrdsPCPC = 'Priority Current';
    SThrdsPBPC = 'Priority Base';
    SThrdsSAPC = 'Start Address';
    SThrdsTSPC = 'Thread State';
    SThrdsTWPC = 'Thread Wait Reason';

implementation

uses MiTeC_PSAPI, MiTeC_ToolHelp32, MiTeC_AdvAPI, MiTeC_Routines, Registry,
  MiTeC_Enums9x, MiTeC_NetAPI32, MiTec_Native;

procedure FreeNTProcessList;
var
  ntp :pntprocess;
begin
  while ntprocesslist.count>0 do begin
    ntp:=pntprocess(ntprocesslist.objects[ntprocesslist.count-1]);
    if assigned(ntp^.Modules) then begin
      while ntp^.Modules.count>0 do begin
        dispose(pntmodule(ntp^.Modules.objects[ntp^.Modules.count-1]));
        ntp^.Modules.delete(ntp^.Modules.count-1);
      end;
      ntp^.Modules.Free;
    end;
    if assigned(ntp^.Threads) then begin
      while ntp^.Threads.count>0 do begin
        dispose(pntthread(ntp^.Threads.objects[ntp^.Threads.count-1]));
        ntp^.Threads.delete(ntp^.Threads.count-1);
      end;
      ntp^.Threads.Free;
    end;
    if assigned(ntp^.Heaplists) then begin
      while ntp^.Heaplists.count>0 do begin
        dispose(pheaplist(ntp^.heaplists.objects[ntp^.heaplists.count-1]));
        ntp^.heaplists.delete(ntp^.heaplists.count-1);
      end;
      ntp^.Heaplists.Free;
    end;
    dispose(ntp);
    ntprocesslist.delete(ntprocesslist.count-1);
  end;
end;

procedure GetNTProcessList;
var
  pc: TPerfCounter;
  po: TPerfObject;
  i :integer;
  ntp :pntprocess;
begin
  FreeNTProcessList(NTProcessList);
  with APL do begin
    po:=Objects[GetIndexByName(SProcsPO)];
    for i:=0 to po.InstanceCount-2 do begin
      new(ntp);
      try
        ntp^.modules:=tstringlist.Create;
        ntp^.HeapLists:=TStringList.Create;
        ntp^.Threads:=tstringlist.Create;
        with ntp^ do begin
          pc:=po.Counters[po.GetCntrIndexByName(SProcsIDPC)];
          PID:=PInteger(pc.Data[i])^;
        end;
        getntprocessinfo(ntp^,APL,ntp^.PID,False);
        ntprocesslist.addobject(inttostr(ntp^.PID),@ntp^);
      except
        dispose(ntp);
      end;
    end;
  end;
end;

procedure GetNTProcessInfo;
var
  mi :tmoduleinfo;
  pc: TPerfCounter;
  po: TPerfObject;
  ds,PID,p :DWORD;
  ntpi,k,i,j: integer;
  ntm :pntmodule;
  ntt :pntthread;
  ph :thandle;
  sz :pchar;
  n :longword;
  p95: T95Process;
begin
  with APL do begin
    n:=255;
    sz:=stralloc(n);
    if ExtInfo then
      TakeSnapshot;
    ntpi:=-1;
    po:=Objects[GetIndexByName(SProcsPO)];
    pc:=nil;
    for i:=0 to po.InstanceCount-2 do begin
      pc:=po.Counters[po.GetCntrIndexByName(SProcsIDPC)];
      PID:=PInteger(pc.Data[i])^;
      if APID=PID then begin
        ntpi:=i;
        break;
      end;
    end;
    if Assigned(pc) and (ntpi>-1) then
      with Process do begin
        if not Assigned(Modules) then
          Modules:=tstringlist.Create;
        if not Assigned(HeapLists) then
          HeapLists:=TStringList.Create;
        if not Assigned(Threads) then
          Threads:=tstringlist.Create;
        PID:=PInteger(pc.Data[ntpi])^;
        Name:=po.Instances[ntpi].Name;
        if pid>10 then
          Name:=Name+'.exe';
        pc:=po.Counters[po.GetCntrIndexByName(SProcsPTPC)];
        CPUTime:=PLARGE_INTEGER(pc.Data[ntpi])^.QuadPart div Timer100n;
        pc:=po.Counters[po.GetCntrIndexByName(SProcsWSPC)];
        WorkingSetSize:=PInteger(pc.Data[ntpi])^;
        pc:=po.Counters[po.GetCntrIndexByName(SProcsPRPC)];
        PriorityBase:=PInteger(pc.Data[ntpi])^;
        pc:=po.Counters[po.GetCntrIndexByName(SProcsTCPC)];
        ThreadCount:=PInteger(pc.Data[ntpi])^;
        if extinfo then begin
          if Is2K or IsXP then
            p95:=Get95ProcessInfo(PID,extinfo);
          {if Win32Platform=VER_PLATFORM_WIN32_NT then
            ZwOpenProcess(@ph,PROCESS_QUERY_INFORMATION or PROCESS_VM_READ,nil,PID)
          else}
            ph:=OpenProcess(PROCESS_QUERY_INFORMATION or PROCESS_VM_READ,false,PID);
          getuseranddomainname(ph,User,Domain);
          if (ph<>0) and (pid>10) and PSAPILoaded then
            GetModuleFilenameEx(ph,0,sz,n)
          else
            strpcopy(sz,ExpandFilename(filesearch(Name,GetWinSysDir)));
          ImageName:=strpas(sz);
          if not PSAPILoaded and (Is2K or IsXP) then
            ImageName:=p95.ImageName;
          if not FileExists(ImageName) then begin
            p:=Pos('\??\',ImageName);
            if p>0 then
              Delete(ImageName,1,4)
            else
              ImageName:=ExpandEnvVars(ImageName);
          end;
          pc:=po.Counters[po.GetCntrIndexByName(SProcsKTPC)];
          KernelTime:=PLARGE_INTEGER(pc.Data[ntpi])^.QuadPart div timer100n;
          pc:=po.Counters[po.GetCntrIndexByName(SProcsUTPC)];
          UserTime:=PLARGE_INTEGER(pc.Data[ntpi])^.QuadPart div timer100n;
          pc:=po.Counters[po.GetCntrIndexByName(SProcsPFPC)];
          PageFaultCount:=PInteger(pc.Data[ntpi])^;
          pc:=po.Counters[po.GetCntrIndexByName(SProcsPBPC)];
          PrivateSpace:=PInteger(pc.Data[ntpi])^;
          pc:=po.Counters[po.GetCntrIndexByName(SProcsWSPPC)];
          PeakWorkingSetSize:=PInteger(pc.Data[ntpi])^;
          pc:=po.Counters[po.GetCntrIndexByName(SProcsPPBPC)];
          PagedPoolSize:=PInteger(pc.Data[ntpi])^;
          pc:=po.Counters[po.GetCntrIndexByName(SProcsPNBPC)];
          NonPagedPoolSize:=PInteger(pc.Data[ntpi])^;
          pc:=po.Counters[po.GetCntrIndexByName(SProcsVBPC)];
          VirtualAddressSpaceSize:=PInteger(pc.Data[ntpi])^;
          pc:=po.Counters[po.GetCntrIndexByName(SProcsVBPPC)];
          PeakVirtualAddressSpaceSize:=PInteger(pc.Data[ntpi])^;
          pc:=po.Counters[po.GetCntrIndexByName(SProcsPFBPC)];
          PageFileUsage:=PInteger(pc.Data[ntpi])^;
          pc:=po.Counters[po.GetCntrIndexByName(SProcsPFBPPC)];
          PeakPageFileUsage:=PInteger(pc.Data[ntpi])^;
          pc:=po.Counters[po.GetCntrIndexByName(SProcsHCPC)];
          HandleCount:=PInteger(pc.Data[ntpi])^;
          pc:=po.Counters[po.GetCntrIndexByName(SProcsETPC)];
          ElapsedTime:=abs(APL.PerfTime.QuadPart-PLARGE_INTEGER(pc.Data[ntpi])^.quadpart) div APL.PerfFreq.QuadPart;
          if Is2K or IsXP then begin
            pc:=po.Counters[po.GetCntrIndexByName(SProcsCIDPC)];
            ParentPID:=PInteger(pc.Data[ntpi])^;
            pc:=po.Counters[po.GetCntrIndexByName(SProcsIOROPC)];
            IOReadOps:=PInteger(pc.Data[ntpi])^;
            pc:=po.Counters[po.GetCntrIndexByName(SProcsIOWOPC)];
            IOWriteOps:=PInteger(pc.Data[ntpi])^;
            pc:=po.Counters[po.GetCntrIndexByName(SProcsIODOPC)];
            IODataOps:=PInteger(pc.Data[ntpi])^;
            pc:=po.Counters[po.GetCntrIndexByName(SProcsIOOOPC)];
            IOOtherOps:=PInteger(pc.Data[ntpi])^;
            pc:=po.Counters[po.GetCntrIndexByName(SProcsIORBPC)];
            IOReadB:=PInteger(pc.Data[ntpi])^;
            pc:=po.Counters[po.GetCntrIndexByName(SProcsIOWBPC)];
            IOWriteB:=PInteger(pc.Data[ntpi])^;
            pc:=po.Counters[po.GetCntrIndexByName(SProcsIODBPC)];
            IODataB:=PInteger(pc.Data[ntpi])^;
            pc:=po.Counters[po.GetCntrIndexByName(SProcsIOOBPC)];
            IOOtherB:=PInteger(pc.Data[ntpi])^;
          end;
          if PSAPILoaded then begin
            ReallocMem(ModuleList,0);
            if ph<>0 then begin
              ReallocMem (ModuleList,65536);
              if not EnumProcessModules(ph,ModuleList,65536,ds) then
                ds:=0;
              ReallocMem(ModuleList,ds);
            end else
              ReallocMem(ModuleList,0);
            if (ph<>0) then begin
              for j:=0 to ds div sizeof(hInst)-1 do begin
                new(ntm);
                with ntm^ do begin
                  k:=PHInst(pchar(ModuleList)+j*sizeof(HInst))^;
                  GetModuleInformation(ph,k,mi,sizeof(mi));
                  GetModuleFileNameEx(ph,k,sz,n);
                  ImageName:=strpas(sz);
                  if not FileExists(ImageName) then begin
                    p:=Pos('\??\',ImageName);
                    if p>0 then
                      Delete(ImageName,1,4)
                    else
                      ImageName:=ExpandEnvVars(ImageName);
                  end;
                  Name:=ExtractFilename(ImageName);
                  LoadAddress:=longword(mi.lpBaseOfDll);
                  ImageSize:=mi.SizeOfImage;
                  EntryPoint:=longword(mi.entrypoint);
                  modules.addobject(name,@ntm^);
                end;
              end;
            end;
          end;

          if Is2K or IsXP then begin
            for i:=0 to p95.Modules.Count-1 do begin
              k:=Modules.IndexOf(p95.Modules[i]);
              if (k>-1) then
                ntm:=PNTModule(Modules.Objects[k])
              else
                new(ntm);
              with ntm^ do begin
                ID:=P95Module(p95.Modules.Objects[i])^.ID;
                Name:=P95Module(p95.Modules.Objects[i])^.Name;
                ImageName:=P95Module(p95.Modules.Objects[i])^.ImageName;
                if not FileExists(ImageName) then begin
                  p:=Pos('\??\',ImageName);
                  if p>0 then
                    Delete(ImageName,1,4)
                  else
                    ImageName:=ExpandEnvVars(ImageName);
                end;
                GlobalUsage:=P95Module(p95.Modules.Objects[i])^.GlobalUsage;
                ProcessUsage:=P95Module(p95.Modules.Objects[i])^.ProcessUsage;
                BaseSize:=P95Module(p95.Modules.Objects[i])^.BaseSize;
                Handle:=P95Module(p95.Modules.Objects[i])^.Handle;
                EntryPoint:=P95Module(p95.Modules.Objects[i])^.EntryPoint;
                if k=-1 then
                  modules.addobject(Name,@ntm^);
              end;
            end;
            HeapID:=p95.HeapID;
            HeapLists:=p95.HeapLists;
          end;
          po:=Objects[GetIndexByName(SThrdsPO)];
          for j:=0 to po.InstanceCount-2 do begin
            pc:=po.Counters[po.GetCntrIndexByName(SThrdsPIDPC)];
            k:=PInteger(pc.Data[j])^;
            if k=Process.pid then begin
              new(ntt);
              pc:=po.Counters[po.GetCntrIndexByName(SThrdsIDPC)];
              ntt^.ID:=PInteger(pc.Data[j])^;
              pc:=po.Counters[po.GetCntrIndexByName(SThrdsTSPC)];
              ntt^.Status:=PInteger(pc.Data[j])^;
              case ntt^.Status of
                0: ntt^.szStatus:='Init';
                1: ntt^.szStatus:='Ready';
                2: ntt^.szStatus:='Running';
                3: ntt^.szStatus:='StandBy';
                4: ntt^.szStatus:='Terminate';
                5: ntt^.szStatus:='Wait';
                6: ntt^.szStatus:='Transition';
              else
                ntt^.szStatus:='Unknown';
              end;
              pc:=po.Counters[po.GetCntrIndexByName(SThrdsTWPC)];
              ntt^.WaitReason:=PInteger(pc.Data[j])^;
              case ntt^.WaitReason of
                0,7: ntt^.szWaitReason:='Executive';
                1,8: ntt^.szWaitReason:='Free Page';
                2,9: ntt^.szWaitReason:='Page In';
                3,10: ntt^.szWaitReason:='Pool Alloc';
                4,11: ntt^.szWaitReason:='Exec Delay';
                5,12: ntt^.szWaitReason:='Suspend';
                6,13: ntt^.szWaitReason:='User Request';
                14: ntt^.szWaitReason:='Event Pair High';
                15: ntt^.szWaitReason:='Event Pair Low';
                16: ntt^.szWaitReason:='LPC Receive';
                17: ntt^.szWaitReason:='LPT Reply';
                18: ntt^.szWaitReason:='Virtual Memory';
                19: ntt^.szWaitReason:='Page Out';
              else
                ntt^.szWaitReason:='Unknown';
              end;
              pc:=po.Counters[po.GetCntrIndexByName(SThrdsPBPC)];
              ntt^.PriorityBase:=PInteger(pc.Data[j])^;
              pc:=po.Counters[po.GetCntrIndexByName(SThrdsPCPC)];
              ntt^.PriorityDelta:=PInteger(pc.Data[j])^;
              pc:=po.Counters[po.GetCntrIndexByName(SThrdsSAPC)];
              ntt^.StartAddr:=PInteger(pc.Data[j])^;
              pc:=po.Counters[po.GetCntrIndexByName(SThrdsCSPC)];
              ntt^.CntxtSwtcs:=PInteger(pc.Data[j])^;
              pc:=po.Counters[po.GetCntrIndexByName(SThrdsPTPC)];
              ntt^.CPUTime:=PLARGE_INTEGER(pc.Data[j])^.QuadPart div timer100n;
              Process.threads.addobject(inttostr(ntt^.ID),@ntt^);
            end else
              if Process.threads.count>0 then
                break;
          end;
          CloseHandle(ph);
        end;
      end;
    strdispose(sz);
  end;
end;

procedure FreeNTDriverList;
var
  ntd :pNTDriver;
begin
  while NTDriverlist.count>0 do begin
    ntd:=pNTDriver(NTDriverlist.objects[NTDriverlist.count-1]);
    dispose(ntd);
    NTDriverlist.delete(NTDriverlist.count-1);
  end;
end;

procedure GetNTDriverList;
var
  i,k :integer;
  kl :tstringlist;
  ntd :pNTDriver;
const
  crkServices = 'SYSTEM\CurrentControlSet\Services';
  crvType = 'Type';
  crvDisplay = 'DisplayName';
  crvGroup = 'Group';
  crvImage = 'ImagePath';
  crvStartup = 'Start';
  crvErrCtrl = 'ErrorControl';
  crvTag = 'Tag';
begin
  FreeNTDriverList(NTDriverList);
  with tregistry.create do begin
    rootkey:=HKEY_LOCAL_MACHINE;
    if openkeyreadonly(crkServices) then begin
      kl:=tstringlist.create;
      getkeynames(kl);
      for i:=0 to kl.count-1 do begin
        closekey;
        if openkeyreadonly(crkServices+'\'+kl[i]) then begin
          if valueexists(crvType) then begin
            k:=readinteger(crvType);
            if k<3 then begin
              new(ntd);
              ntd^.name:=kl[i];
              try
                ntd^.typ:=k;
                ntd^.Description:=ReadRegistryValueAsString(HKEY_LOCAL_MACHINE,crkServices+'\'+kl[i],crvDisplay);
                {if valueexists(crvDisplay) then
                  ntd^.Description:=readstring(crvDisplay);}
                if valueexists(crvGroup) then
                  ntd^.Group:=readstring(crvGroup);
                if valueexists(crvImage) then
                  ntd^.ImageName:=readstring(crvImage);
                if valueexists(crvErrCtrl) then
                  ntd^.ErrCtrl:=readinteger(crvErrCtrl);
                if valueexists(crvStartup) then
                  ntd^.Startup:=readinteger(crvStartup);
                if valueexists(crvTag) then
                  ntd^.Tag:=readinteger(crvTag);
                ntd^.szStartup:=ServiceGetStartStr(ntd^.Startup);
                ntd^.szTyp:=ServiceGetTypeStr(ntd^.Typ);
                ntd^.szErrCtrl:=ServiceGetErrCtrlStr(ntd^.ErrCtrl);
                if ADVAPILoaded then begin
                  ntd^.Status:=ServiceGetStatus(MachineName,ntd^.Name);
                  ntd^.szStatus:=ServiceGetStatStr(ntd^.Status);
                end;
              except
              end;
              NTDriverlist.addobject(ntd^.name,@ntd^);
            end;
          end;
          closekey;
        end;
      end;
      kl.free;
    end;
    free;
  end;
end;

procedure FreeNTServiceList;
var
  nts :pNTService;
begin
  while NTServicelist.count>0 do begin
    nts:=pNTService(NTServicelist.objects[NTServicelist.count-1]);
    dispose(nts);
    NTServicelist.delete(NTServicelist.count-1);
  end;
end;

procedure GetNTServiceList;
var
  i,j,k :integer;
  kl :tstringlist;
  nts :pNTService;
  sl: TStringList;
  qsp :pQueryServiceConfig;
  s: string;
const
  crkServices = 'SYSTEM\CurrentControlSet\Services';
  crvType = 'Type';
  crvDisplay = 'DisplayName';
  crvDepGroup = 'DependOnGroup';
  crvGroup = 'Group';
  crvDepSvc = 'DependOnService';
  crvImage = 'ImagePath';
  crvStartup = 'Start';
  crvErrCtrl = 'ErrorControl';
  crvObjName = 'ObjectName';
  crvDesc = 'Description';
begin
  FreeNTServiceList(NTServiceList);
  with TRegistry.Create do begin
    RootKey:=HKEY_LOCAL_MACHINE;
    if ADVAPILoaded then begin
      sl:=TStringList.Create;
      ServiceGetList(AMachine,SERVICE_WIN32,SERVICE_STATE_ALL,sl);
      qsp:=AllocMem(1024);
      for i:=0 to sl.count-1 do begin
        new(nts);
        nts^.DisplayName:=sl[i];
        nts^.Name:=ServiceGetKeyName(AMachine,sl[i]);
        nts^.Status:=ServiceGetStatus(AMachine,nts^.Name);
        if ServiceGetConfig(AMachine,nts^.Name,qsp^) then begin
          nts^.ImageName:=StringReplace(StrPas(qsp.lpBinaryPathName),'"','',[rfReplaceAll,rfIgnoreCase]);
          nts^.ObjectName:=StrPas(qsp.lpServiceStartName);
          nts^.Group:=StrPas(qsp.lpLoadOrderGroup);
          if nts^.Group='' then
            nts^.Group:='<none>';
          nts^.Typ:=qsp.dwServiceType;
          nts^.StartUp:=qsp.dwStartType;
          nts^.Tag:=qsp.dwTagId;
          nts^.ErrCtrl:=qsp.dwErrorControl;
          nts^.szStartup:=ServiceGetStartStr(nts^.Startup);
          nts^.szTyp:=ServiceGetTypeStr(nts^.Typ);
          nts^.szErrCtrl:=ServiceGetErrCtrlStr(nts^.ErrCtrl);
          nts^.szStatus:=ServiceGetStatStr(nts^.Status);
          nts^.DependOnService:='';
          s:='';
          for j:=0 to 1024 do begin
            if (s='') and (qsp.lpDependencies[j]=#0) then
              break;
            if not (qsp.lpDependencies[j] in [#0,#32]) then
              s:=s+qsp.lpDependencies[j]
            else begin
              if s<>'' then
                nts^.DependOnService:=nts^.DependOnService+s+' ';
              s:='';
            end;
          end;
          nts^.DependOnService:=Trim(nts^.DependOnService);
        end;
        if (Pos(MachineName,AMachine)>0) and OpenKeyReadOnly(crkServices+'\'+nts^.Name) then begin
          if valueexists(crvDesc) then
            nts^.Description:=readstring(crvDesc);
          CloseKey;
        end;
        NTServicelist.addobject(nts^.name,@nts^);
      end;
      FreeMem(qsp);
      sl.Free;
    end else
      if (Pos(MachineName,AMachine)>0) and openkeyreadonly(crkServices) then begin
        kl:=tstringlist.create;
        getkeynames(kl);
        for i:=0 to kl.count-1 do begin
          closekey;
          if openkeyreadonly(crkServices+'\'+kl[i]) then begin
            if valueexists(crvType) then begin
              k:=readinteger(crvType);
              if k>2 then begin
                new(nts);
                nts^.name:=kl[i];
                try
                  nts^.typ:=k;
                  if valueexists(crvDisplay) then
                    nts^.DisplayName:=readstring(crvDisplay);
                  if valueexists(crvDesc) then
                    nts^.Description:=readstring(crvDesc);
                  if valueexists(crvGroup) then
                    nts^.Group:=readstring(crvGroup);
                  if valueexists(crvImage) then
                    nts^.ImageName:=readstring(crvImage);
                  if valueexists(crvErrCtrl) then
                    nts^.ErrCtrl:=readinteger(crvErrCtrl);
                  if valueexists(crvStartup) then
                    nts^.Startup:=readinteger(crvStartup);
                  if valueexists(crvDepGroup) then
                    nts^.DependOnGroup:=readstring(crvDepSvc);
                  if valueexists(crvDepGroup) then
                    nts^.DependOnService:=readstring(crvDepSvc);
                  if valueexists(crvObjName) then
                    nts^.ObjectName:=readstring(crvObjName);
                  nts^.szStartup:=ServiceGetStartStr(nts^.Startup);
                  nts^.szTyp:=ServiceGetTypeStr(nts^.Typ);
                  nts^.szErrCtrl:=ServiceGetErrCtrlStr(nts^.ErrCtrl);
                except

                end;
                NTServicelist.addobject(nts^.name,@nts^);
              end;
            end;
            closekey;
          end;
        end;
        kl.free;
      end;
    Free;
  end;
end;

end.

{*******************************************************}
{                                                       }
{       MiTeC System Information Component              }
{         Windows 9x Process Enumeration                }
{           version 8.0 for Delphi 5,6                  }
{                                                       }
{       Copyright © 1997,2003 Michal Mutl               }
{                                                       }
{*******************************************************}

{$INCLUDE MITEC_DEF.INC}

unit MiTeC_Enums9x;

interface

uses Windows, SysUtils, Classes;

type
  P95Process = ^T95Process;
  T95Process = record
    PID :longword;
    Name,
    ImageName: string;
    Priority,
    Usage,
    ParentPID,
    HeapID,
    ThreadCount :longword;
    HeapLists,
    Modules,
    Threads :tstringlist;
  end;

  PHeapList = ^THeapList;
  THeapList = record
    ID,
    Flags :longword;
    szFlags :string;
    HeapBlocks :TStringList;
  end;

  PHeapBlock = ^THeapBlock;
  THeapBlock = record
    szFlags :string;
    Handle,
    Address,
    BlockSize,
    Flags,
    LockCount,
    HID :longword;
  end;

  P95Module = ^T95Module;
  T95Module = record
    ID :longword;
    Name,
    ImageName: string;
    GlobalUsage,
    ProcessUsage,
    BaseSize,
    Handle,
    EntryPoint :longword;
  end;

  P95Thread = ^T95Thread;
  T95Thread = record
    Usage,
    ID :longword;
    PriorityBase,
    PriorityDelta: Longint;
  end;

  function GetPriority(p :integer) :string;

  procedure Free95ProcessList(var pl: TStringList);
  procedure Get95ProcessList(var pl :tstringlist);
  function Get95ProcessInfo(APID :longword; ExtInfo :boolean) :T95Process;

implementation

uses MiTeC_ToolHelp32, MiTeC_Routines;

function GetPriority;
begin
  result := '';
  case p of
    4 : result := 'Idle';
    8 : result := 'Normal';
    13: result := 'High';
    24: result := 'RealTime';
  else
    result := 'Unknown';
  end;
end;

procedure Free95ProcessList;
var
  p95: p95process;
  hl: PHeapList;
begin
  while pl.count>0 do begin
    p95:=p95process(pl.objects[pl.count-1]);
    if assigned(p95^.Modules) then begin
      while p95^.Modules.count>0 do begin
        dispose(p95module(p95^.Modules.objects[p95^.Modules.count-1]));
        p95^.Modules.delete(p95^.Modules.count-1);
      end;
      p95^.Modules.Free;
    end;
    if assigned(p95^.Threads) then begin
      while p95^.Threads.count>0 do begin
        dispose(p95thread(p95^.Threads.objects[p95^.Threads.count-1]));
        p95^.Threads.delete(p95^.Threads.count-1);
      end;
      p95^.Threads.Free;
    end;
    if assigned(p95^.Heaplists) then begin
      while p95^.Heaplists.count>0 do begin
        hl:=pheaplist(p95^.heaplists.Objects[p95^.heaplists.count-1]);
        if assigned(hl^.heapblocks) then begin
          while hl^.heapblocks.Count>0 do begin
            dispose(PHeapBlock(hl^.heapblocks.Objects[hl^.HeapBlocks.count-1]));
            hl^.heapblocks.Delete(hl^.HeapBlocks.count-1);
          end;
          hl^.heapblocks.Free;
        end;
        dispose(hl);
        p95^.heaplists.delete(p95^.heaplists.count-1);
      end;
      p95^.Heaplists.Free;
    end;
    dispose(p95);
    pl.delete(pl.count-1);
  end;
end;

procedure Get95ProcessList;

 procedure AddProcess(var Process: T95Process; pe32:TPROCESSENTRY32);

   procedure AddModule(var Module: T95Module; me32 :TMODULEENTRY32);
   begin
     Module.ID:=me32.th32ModuleID;
     Module.Name:=me32.szModule;
     Module.ImageName:=ExpandFilename(FileSearch(me32.szExePath,ExtractFilePath(me32.szExePath)+';'+GetWinSysDir));
     Module.GlobalUsage:=me32.GlblcntUsage;
     Module.ProcessUsage:=me32.ProccntUsage;
     Module.BaseSize:=me32.modBaseSize;
     Module.EntryPoint:=longword(me32.modBaseAddr);
     Module.Handle:=me32.hModule;
   end;

 var
   modulesnap :THandle;
   me32 :TMODULEENTRY32;
   m95 :p95module;

 begin
   Process.Name:=extractfilename(pe32.szExeFile);
   Process.ImageName:=ExpandFilename(FileSearch(pe32.szExeFile,ExtractFilePath(pe32.szExeFile)+';'+GetWinSysDir));
   Process.PID:=pe32.th32ProcessID;
   Process.Priority:=pe32.pcPriClassBase;
   Process.Usage:=pe32.cntUsage;
   Process.ThreadCount:=pe32.cntThreads;
   modulesnap:=0;
   try
     modulesnap:=CreateToolhelp32Snapshot(TH32CS_SNAPMODULE,Process.PID);
     if modulesnap<>0 then begin
       me32.dwSize:=sizeof(TMODULEENTRY32);
       if Module32First(modulesnap,me32) then begin
         new(m95);
         AddModule(m95^,me32);
         Process.modules.addobject(m95^.Name,@m95^);
         while Module32Next(modulesnap, me32) do begin
           new(m95);
           AddModule(m95^,me32);
           Process.modules.addobject(m95^.Name,@m95^);
         end;
       end;
     end;
   finally
     CloseHandle(modulesnap);
   end;
 end;

var
 processsnap :THandle;
 pe32 :TPROCESSENTRY32;
 p95 :p95process;
 hl: PHeapList;

begin
  processsnap:=0;
  Free95ProcessList(pl);
  try
    processsnap:=CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS,0);
    if processsnap<>0 then begin
      pe32.dwSize:=sizeof(TPROCESSENTRY32);
      if Process32First(processsnap,pe32) then begin
        new(p95);
        p95^.Modules:=tstringlist.create;
        p95^.Threads:=TStringlist.Create;
        p95^.HeapLists:=TStringlist.Create;
        AddProcess(p95^,pe32);
        pl.addobject(inttohex(p95^.PID,8),@p95^);
        while Process32Next(processsnap, pe32) do begin
          new(p95);
          p95^.Modules:=tstringlist.create;
          p95^.Threads:=TStringlist.Create;
          p95^.HeapLists:=TStringlist.Create;
          AddProcess(p95^,pe32);
          pl.addobject(inttohex(p95^.PID,8),@p95^);
        end;
      end;
    end;
  finally
    CloseHandle(processsnap);
  end;
end;

function Get95ProcessInfo;

 procedure AddProcess(var Process: T95Process; pe32:TPROCESSENTRY32);
 var
   modulesnap :THandle;
   me32 :TMODULEENTRY32;
   m95 :p95module;

   Threadsnap :THandle;
   te32 :TTHREADENTRY32;
   t95 :p95thread;

   Heapsnap :THandle;
   he32 :THEAPENTRY32;
   h95 :pheapblock;
   hl32 :THEAPLIST32;
   hl95 :PHeapList;

   procedure AddModule(var Module: T95Module; me32 :TMODULEENTRY32);
   begin
     Module.ID:=me32.th32ModuleID;
     Module.Name:=me32.szModule;
     Module.ImageName:=ExpandFilename(FileSearch(me32.szExePath,ExtractFilePath(me32.szExePath)+';'+GetWinSysDir));
     Module.GlobalUsage:=me32.GlblcntUsage;
     Module.ProcessUsage:=me32.ProccntUsage;
     Module.BaseSize:=me32.modBaseSize;
     Module.EntryPoint:=longword(me32.modBaseAddr);
     Module.Handle:=me32.hModule;
   end;

   procedure AddThread(var Thread: T95Thread; te32 :TTHREADENTRY32);
   begin
     Thread.Usage:=te32.cntUsage;
     Thread.ID:=te32.th32ThreadID;
     Thread.PriorityBase:=te32.tpBasePri;
     Thread.PriorityDelta:=te32.tpDeltaPri;
   end;

   procedure AddHeapList(var HeapList: THeapList; hl32 :THeapList32);

     procedure AddHeap(var HeapBlock: THeapBlock; hl :THeapList; he32 :THEAPENTRY32);
     begin
       HeapBlock.szFlags:='Unknown';
       HeapBlock.Handle:=he32.hHandle;
       HeapBlock.HID:=he32.th32HeapID;
       HeapBlock.Address:=he32.dwAddress;
       HeapBlock.BlockSize:=he32.dwBlockSize;
       HeapBlock.Flags:=he32.dwFlags;
       HeapBlock.LockCount:=he32.dwLockCount;
       if he32.dwFlags=LF32_FIXED then
         HeapBlock.szFlags:='Fixed'
       else
         if he32.dwFlags=LF32_FREE then
           HeapBlock.szFlags:='Free'
         else
           HeapBlock.szFlags:='Moveable';
     end;

   begin
     HeapList.ID:=hl32.th32HeapID;
     HeapList.Flags:=hl32.dwFlags;
     HeapList.szFlags:='Normal';
     if hl32.dwFlags=HF32_DEFAULT then
       HeapList.szFlags:='Default'
     else
       if hl32.dwFlags=HF32_SHARED then
         HeapList.szFlags:='Shared';
     HeapList.HeapBlocks:=tstringlist.create;
     he32.dwSize:=sizeof(theapentry32);
     if not IsNT5 then
       try
         if heap32first(he32,hl32.th32ProcessID,hl32.th32HeapID) then begin
           new(h95);
           addheap(h95^,HeapList,he32);
           HeapList.HeapBlocks.addobject(inttohex(h95^.Handle,8),@h95^);
           if heap32next(he32) then
             while heap32next(he32) do begin
               new(h95);
               addheap(h95^,HeapList,he32);
               HeapList.HeapBlocks.addobject(inttohex(h95^.Handle,8),@h95^);
             end;
         end;
       except

       end;
   end;

 begin
   Result.Name:=extractfilename(pe32.szExeFile);
   Result.ImageName:=ExpandFilename(FileSearch(pe32.szExeFile,ExtractFilePath(pe32.szExeFile)+';'+GetWinSysDir));
   Result.PID:=pe32.th32ProcessID;
   Result.Priority:=pe32.pcPriClassBase;
   Result.Usage:=pe32.cntUsage;
   Result.ThreadCount:=pe32.cntThreads;
   if extinfo then begin
     Result.ParentPID:=pe32.th32ParentProcessID;
     Result.HeapID:=pe32.th32DefaultHeapID;
     modulesnap:=0;
     try
       modulesnap:=CreateToolhelp32Snapshot(TH32CS_SNAPMODULE,Result.PID);
       if modulesnap<>0 then begin
         me32.dwSize:=sizeof(TMODULEENTRY32);
         if Module32First(modulesnap,me32) then begin
           new(m95);
           AddModule(m95^,me32);
           Result.modules.addobject(m95^.Name,@m95^);
           while Module32Next(modulesnap, me32) do begin
             new(m95);
             AddModule(m95^,me32);
             Result.modules.addobject(m95^.Name,@m95^);
           end;
         end;
       end;
     finally
       CloseHandle(modulesnap);
     end;
     threadsnap:=0;
     try
       threadsnap:=CreateToolhelp32Snapshot(TH32CS_SNAPTHREAD,0);
       if threadsnap<>0 then begin
         te32.dwSize:=sizeof(tthreadentry32);
         if thread32First(threadsnap,te32) then
           if te32.th32OwnerProcessID=Result.PID then begin
             new(t95);
             AddThread(t95^,te32);
             Result.threads.addobject(inttohex(t95^.ID,8),@t95^);
           end;
           while thread32Next(threadsnap,te32) do
             if te32.th32OwnerProcessID=Result.PID then begin
               new(t95);
               AddThread(t95^,te32);
               Result.threads.addobject(inttohex(t95^.ID,8),@t95^);
             end;
       end;
     finally
       CloseHandle(threadsnap);
     end;
     Heapsnap:=0;
     try
       heapsnap:=CreateToolhelp32Snapshot(TH32CS_SNAPHEAPLIST,Result.PID);
       if heapsnap<>0 then begin
         hl32.dwSize:=sizeof(theaplist32);
         if heap32listFirst(heapsnap,hl32) then begin
           if hl32.th32ProcessID=Result.PID then begin
             new(hl95);
             addheaplist(hl95^,hl32);
             Result.HeapLists.addobject(inttohex(hl32.th32HeapID,8),@hl95^);
           end;
           while heap32listNext(heapsnap,hl32) do
             if hl32.th32ProcessID=Result.PID then begin
               new(hl95);
               addheaplist(hl95^,hl32);
               Result.HeapLists.addobject(inttohex(hl32.th32HeapID,8),@hl95^);
             end;
         end;
       end;
     finally
       CloseHandle(heapsnap);
     end;
   end;
 end;

var
 processsnap :THandle;
 pe32 :TPROCESSENTRY32;

begin
  processsnap:=0;
  try
    if not Assigned(Result.Modules) then
      Result.Modules:=TStringList.Create;
    if not Assigned(Result.Threads) then
      Result.Threads:=TStringList.Create;
    if not Assigned(Result.HeapLists) then
      Result.HeapLists:=TStringList.Create;
    processsnap:=CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS,0);
    if processsnap<>0 then begin
      pe32.dwSize:=sizeof(TPROCESSENTRY32);
      if Process32First(processsnap,pe32) then begin
        if (pe32.th32ProcessID=APID) then
          AddProcess(Result,pe32)
        else
          while Process32Next(processsnap, pe32) do
           if (pe32.th32ProcessID=APID) then begin
             AddProcess(Result,pe32);
             break;
           end;
      end;
    end;
  finally
    CloseHandle(processsnap);
  end;
end;

end.

{*******************************************************}
{                                                       }
{       MiTeC System Information Component              }
{           Windows NT Job Enumeration                  }
{           version 8.3 for Delphi 5,6,7                }
{                                                       }
{       Copyright © 1997,2003 Michal Mutl               }
{                                                       }
{*******************************************************}

{$INCLUDE MITEC_DEF.INC}

unit MiTeC_JobsNT;

interface

uses Windows, Classes, SysUtils;

type
  TJobFlag = (jfRunPeriodically,jfAddCurrentDate, jfExecError, jfRunsToday);
  TJobFlags = set of TJobFlag;

  PNTJobRecord = ^TNTJobRecord;
  TNTJobRecord = record
    ID: DWord;
    JobTime: TDateTime;
    DaysOfMonth: TStrings;
    DaysOfWeek: TStrings;
    Flags: TJobFlags;
    Command: String;
  end;

  TNTJobs = class(TPersistent)
  private
    FJobs: TStringList;
    FMachine: string;
    procedure Retrieve(AMachine: string);
    function GetJob(Index: DWORD): PNTJobRecord;
    function GetJobCount: DWORD;
    procedure FreeList(var AList: TStringList);
    function DecodeDays(AMaxDays, ATotalDays: Byte): TStrings;
    function DecodeFlags(AFlags: Byte): TJobFlags;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Refresh;

    property Machine: string read FMachine write FMachine;
    property JobCount: DWORD read GetJobCount;
    property Jobs[Index: DWORD]: PNTJobRecord read GetJob;
  end;

function GetJobFlagsStr(AFlags: TJobFlags): string;

implementation

uses MiTeC_Routines, MiTeC_NetAPI32;

function GetJobFlagsStr(AFlags: TJobFlags): string;
begin
  Result:='';
  if jfRunPeriodically in AFlags then
    Result:=Result+'Run periodically,';
  if jfExecError in AFlags then
    Result:=Result+'Failed,';
  if jfRunsToday in AFlags then
    Result:=Result+'Runs today,';
  Result:=Copy(Result,1,Length(Result)-1);
end;

function GetJobTime(ATime: DWORD): TDateTime;
var
  jt,
  Hour,MSec,
  Min,Sec: DWORD;
begin
  jt:=Round(ATime/60000);
  Hour:=jt div 60;
  Min:=jt-(Hour*60);
  Sec:=0;
  MSec:=0;
  Result:=EncodeTime(Hour,Min,Sec,MSec);
end;

{ TNTJobs }

constructor TNTJobs.Create;
begin
  FJobs:=TStringList.Create;
end;

function TNTJobs.DecodeDays;
var
  i: integer;
  AList: TStringList;
begin
  AList:=TStringList.Create;
  for i:=0 to AMaxDays-1 do
    if IsBitOn(ATotalDays,i) then
      AList.Add(inttostr(i+1));
  Result:=AList;
end;

function TNTJobs.DecodeFlags(AFlags: Byte): TJobFlags;
var
  i: integer;
begin
  Result:=[];
  for i:=0 to 3 do begin
    if IsBitOn (AFlags,i) then begin
      if i+1=1 then
        Result:=Result+[jfRunPeriodically];
      if i+1=2 then
        Result:=Result+[jfExecError];
      if i+1=3 then
        Result:=Result+[jfRunsToday];
      if i+1=4 then
        Result:=Result+[jfAddCurrentDate];
    end;
  end;
end;

destructor TNTJobs.Destroy;
begin
  FreeList(FJobs);
  FJobs.Free;
  inherited;
end;

procedure TNTJobs.FreeList(var AList: TStringList);
begin
  while AList.Count>0 do begin
    dispose(PNTJobRecord(AList.Objects[AList.Count-1]));
    AList.Delete(AList.Count-1);
  end;
end;

function TNTJobs.GetJob(Index: DWORD): PNTJobRecord;
begin
  if Index<DWORD(FJobs.Count) then
    Result:=PNTJobRecord(FJobs.Objects[Index])
  else
    Result:=nil;
end;

function TNTJobs.GetJobCount: DWORD;
begin
  Result:=FJobs.Count;
end;

procedure TNTJobs.Refresh;
begin
  Retrieve(Machine);
end;

procedure TNTJobs.Retrieve(AMachine: string);
var
  pTmpBuf, pBuf: PAT_ENUM;
  nStatus: NET_API_STATUS;
  i: DWORD;
  dwPrefMaxLen: DWORD;
  dwEntriesRead: DWORD;
  dwTotalEntries: DWORD;
  dwResumeHandle: DWORD;
  Loop: Boolean;
  Buf: array[0..256] of WideChar;
  pjr: PNTJobRecord;
begin
  FreeList(FJobs);
  pBuf:=nil;
  Loop:=True;
  dwPrefMaxLen:=$FFFFFFFF;
  dwEntriesRead:=0;
  dwTotalEntries:=0;
  dwResumeHandle:=0;
  while Loop do begin
    nStatus:=NetScheduleJobEnum(StringToWideChar(AMachine,Buf,256),
                               Pointer(pBuf),
                               dwPrefMaxLen, dwEntriesRead, dwTotalEntries, dwResumeHandle);
    if ((nStatus=ERROR_SUCCESS) or (nStatus=ERROR_MORE_DATA)) and (dwEntriesRead>0) then begin
      pTmpBuf:=pBuf;
      for i:=0 to dwEntriesRead-1 do begin
        new(pjr);
        pjr^.ID:=pTmpBuf^.JobId;
        pjr^.JobTime:=GetJobTime(pTmpBuf^.JobTime);
        pjr^.DaysOfMonth:=DecodeDays(31,pTmpBuf^.DaysOfMonth);
        pjr^.DaysOfWeek:=DecodeDays(7,pTmpBuf^.DaysOfWeek);
        pjr^.Flags:=DecodeFlags(pTmpBuf^.flags);
        pjr^.Command:=pTmpBuf^.Command;

        FJobs.AddObject(IntToStr(pjr^.ID),TObject(pjr));
        pTmpBuf:=PAT_ENUM(PChar(pTmpBuf)+SizeOf(AT_ENUM));
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

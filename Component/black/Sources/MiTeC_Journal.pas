{*******************************************************}
{                                                       }
{         MiTeC System Information Component            }
{                Journal Object                         }
{           version 8.4 for Delphi 5,6,7                }
{                                                       }
{       Copyright © 1997,2003 Michal Mutl               }
{                                                       }
{*******************************************************}

{$INCLUDE MITEC_DEF.INC}

unit MiTeC_Journal;

interface

uses Windows, Classes, SysUtils;

type
  TEventLevel = (elStart, elSystem, elBegin, elEnd, elInformation, elWarning,
                 elError, elData, elAction);

  TJournalRecord = record
    Level: TEventLevel;
    Timestamp: TDateTime;
    TimestampStr: string;
    Message: string;
  end;

  TJournalBuffer = array of TJournalRecord;

  TJournal = class
  private
    FProcessHandle: THandle;
    FFile: TFileStream;
    FBuffer: TJournalBuffer;
    FInternalSave: Boolean;
    FFilename, FMachine, FUser: string;
    FOverwrite: Boolean;
    FStartTime,FStopTime: comp;
    FInternalTime: array of Comp;
    FModuleName: string;
    FModuleVersion: string;
    function GetRecord(Index: DWORD): TJournalRecord;
    function GetRecordCount: DWORD;
    procedure SetRecord(Index: DWORD; const Value: TJournalRecord);
    procedure AddRecord(ATimestamp: TDateTime; AMessage: string; ALevel: TEventLevel); overload;
    procedure AddRecord(ATimestamp: string; AMessage: string; ALevel: TEventLevel); overload;
    procedure AddRecord(ARecord: TJournalRecord); overload;
    procedure CreateFile;
    procedure PushTime(Time: comp);
    function PopTime: comp;
  public
    constructor Create(ADir,AFileNamePrefix: string; AInternalSave,AOverwrite,AReadOnly: boolean);
    destructor Destroy; override;

    procedure WriteEvent(AMessage: string; ALevel: TEventLevel);
    procedure WriteSpace;
    procedure WriteEventFmt(const AFormat: string; const AArgs: array of const; ALevel: TEventLevel);
    procedure LoadFromFile(AFilename: string);
    procedure SaveToFile(AFilename: string);
    procedure Clear;
    procedure StartTimer;
    function StopTimer: Comp;

    property FileName: string read FFilename;
    property InternalSave: Boolean read FInternalSave write FInternalSave;
    property Overwrite: Boolean read FOverwrite write FOverwrite;
    property Records[Index: DWORD]: TJournalRecord read GetRecord write SetRecord;
    property RecordCount: DWORD read GetRecordCount;

    property ModuleName: string read FModuleName;
    property ModuleVersion: string read FModuleVersion;
  end;

function FormatTimer(ATime: Comp): string;

const
  EventLevels: array[TEventLevel] of string = ('Start  ',
                                               'System ',
                                               'Begin  ',
                                               'End    ',
                                               'Info   ',
                                               'Warning',
                                               'Error  ',
                                               'Data   ',
                                               'Action ');
  extMJF = '.mjf';

resourcestring
  rsJournalStartedInEXE = 'Process "%s" version "%s" running on "%s\%s"';
  rsJournalFinishedInEXE = 'Process terminated with exit code %d';
  rsJournalStartedInModule = 'Module "%s" version "%s" was called from "%s" version "%s" running on "%s\%s"';
  rsJournalFinishedInModule = 'Module removed from memory';

implementation

uses MiTeC_StrUtils, Registry;

type
  TVersionInfo = record
    FileName,
    Version,
    ProductName,
    CompanyName,
    Description,
    Comments,
    Copyright: string;
    Major,
    Minor,
    Release,
    Build: DWORD;
  end;

function FormatTimer;
begin
  ATime:=ATime/1000;
  Result:=Format('%2.2d:%2.2d:%2.2d',[Round(ATime) div 3600,
                                      Round(ATime) div 60,
                                      Round(ATime) mod 60]);
end;

function GetFileVerInfo(const fn :string; var VI:TVersionInfo): Boolean;
var
  VersionHandle,VersionSize :dword;
  PItem,PVersionInfo :pointer;
  FixedFileInfo :PVSFixedFileInfo;
  il :uint;
  p :array [0..MAX_PATH - 1] of char;
  translation: string;
begin
  if fn<>'' then begin
    VI.FileName:=fn;
    strpcopy(p,fn);
    versionsize:=getfileversioninfosize(p,versionhandle);
    Result:=False;
    if versionsize=0 then
      exit;
    getMem(pversioninfo,versionsize);
    try
      if getfileversioninfo(p,versionhandle,versionsize,pversioninfo) then begin
        Result:=True;
        if verqueryvalue(pversioninfo,'\',pointer(fixedfileinfo),il) then begin
          VI.version:=inttostr(hiword(fixedfileinfo^.dwfileversionms))+
                   '.'+inttostr(loword(fixedfileinfo^.dwfileversionms))+
                   '.'+inttostr(hiword(fixedfileinfo^.dwfileversionls))+
                   '.'+inttostr(loword(fixedfileinfo^.dwfileversionls));
          VI.Major:=hiword(fixedfileinfo^.dwfileversionms);
          VI.Minor:=loword(fixedfileinfo^.dwfileversionms);
          VI.Release:=hiword(fixedfileinfo^.dwfileversionls);
          VI.Build:=loword(fixedfileinfo^.dwfileversionls);

          if verqueryvalue(pversioninfo,pchar('\VarFileInfo\Translation'),pitem,il) then begin
            translation:=IntToHex(PDWORD(pitem)^,8);
            translation:=Copy(translation,5,4)+Copy(translation,1,4);
          end;
          if verqueryvalue(pversioninfo,pchar('\StringFileInfo\'+translation+'\FileDescription'),pitem,il) then
            VI.description:=pchar(pitem);

          if verqueryvalue(pversioninfo,pchar('\StringFileInfo\'+translation+'\LegalCopyright'),pitem,il) then
            VI.Copyright:=pchar(pitem);

          if verqueryvalue(pversioninfo,pchar('\StringFileInfo\'+translation+'\Comments'),pitem,il) then
            VI.Comments:=pchar(pitem);

          if verqueryvalue(pversioninfo,pchar('\StringFileInfo\'+translation+'\ProductName'),pitem,il) then
            VI.ProductName:=pchar(pitem);

          if verqueryvalue(pversioninfo,pchar('\StringFileInfo\'+translation+'\CompanyName'),pitem,il) then
            VI.CompanyName:=pchar(pitem);

        end;
      end;
    finally
      freeMem(pversioninfo,versionsize);
    end;
  end;
end;

function GetUserAndDomainName(hProcess :THandle; var UserName, DomainName :string) :boolean;
const
  RTN_OK = 0;
  RTN_ERROR = 13;
  MY_BUFSIZE = 512;
var
  hToken :THandle;
  InfoBuffer :array[0..MY_BUFSIZE] of byte;
  snu :SID_NAME_USE;
  cchUserName,cchDomainName :dword;
  cbInfoBuffer :DWORD;
begin
  cbInfoBuffer:=MY_BUFSIZE;
  result:=false;
  if OpenProcessToken(hProcess,TOKEN_QUERY,hToken) then begin
    if GetTokenInformation(hToken,TokenUser,@InfoBuffer,cbInfoBuffer,cbInfoBuffer) then
      result:=LookupAccountSid(nil,PSID(@InfoBuffer),PChar(@UserName),
                          cchUserName,PChar(@DomainName),cchDomainName,snu);
    CloseHandle(hToken);
  end;
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
  GetUserName(buf,n);
  result:=buf;
  strdispose(buf);
end;

{ TJournal }

procedure TJournal.AddRecord(ATimestamp: TDateTime; AMessage: string;
  ALevel: TEventLevel);
begin
  SetLength(FBuffer,Length(FBuffer)+1);
  with FBuffer[High(FBuffer)] do begin
    Level:=ALevel;
    Timestamp:=ATimestamp;
    TimestampStr:=FormatDateTime('yyy-mm-dd hh:mm:ss',ATimestamp);
    Message:=AMessage;
  end;
end;

procedure TJournal.AddRecord(ATimestamp: string; AMessage: string;
  ALevel: TEventLevel);
begin
  SetLength(FBuffer,Length(FBuffer)+1);
  with FBuffer[High(FBuffer)] do begin
    Level:=ALevel;
    Timestamp:=0;
    TimeStampStr:=ATimestamp;
    Message:=AMessage;
  end;
end;

procedure TJournal.AddRecord(ARecord: TJournalRecord); 
begin
  SetLength(FBuffer,Length(FBuffer)+1);
  FBuffer[High(FBuffer)]:=ARecord;
end;

procedure TJournal.Clear;
begin
  SetLength(FBuffer,0);
  if Assigned(FFile) then begin
    FlushFileBuffers(FFile.Handle);
    FFile.Free;
  end;
  DeleteFile(FFilename);
  CreateFile;
end;

constructor TJournal.Create;
var
  p: PChar;
  VIM: TVersionInfo;
begin
  FMachine:=GetMachine;
  FUser:=GetUser;
  GetUserAndDomainName(GetCurrentProcess,FUser,FMachine);
  p:=Allocmem(256);
  GetModuleFileName(hInstance,p,255);
  FModulename:=p;
  GetFileVerInfo(p,VIM);
  FModuleVersion:=VIM.Version;
  FreeMem(p);
  FInternalSave:=AInternalSave;
  FOverwrite:=AOverwrite;
  SetLength(FBuffer,0);
  if not AReadOnly then begin
    AFileNamePrefix:=Trim(ChangeFileExt(ExtractFilename(AFileNamePrefix),''));
    if AFileNamePrefix<>'' then
      AFileNamePrefix:=AFilenamePrefix+'_';
    FFilename:=IncludeTrailingBackslash(ADir)+AFilenamePrefix+FormatDateTime('yyyy-mm-dd',Date)+extMJF;
    CreateFile;
  end;
end;

procedure TJournal.CreateFile;
var
  VIM,VIP: TVersionInfo;
  p: PChar;
begin
  if Assigned(FFile) then begin
    FlushFileBuffers(FFile.Handle);
    FFile.Free;
  end;
  try
    if FOverwrite or not FileExists(FFilename) then begin
      FFile:=TFileStream.Create(FFileName,fmCreate or fmShareDenyWrite);
      FFile.Free;
    end;
    FFile:=TFileStream.Create(FFileName,fmOpenWrite or fmShareDenyWrite);
    if FFile.Size>0 then begin
      FFile.Position:=FFile.Size;
      WriteSpace;
    end;
    FProcessHandle:=GetModuleHandle(nil);
    GetFileVerInfo(ParamStr(0),VIP);
    if FProcessHandle<>hInstance then begin
      p:=Allocmem(256);
      GetModuleFileName(hInstance,p,255);
      GetFileVerInfo(p,VIM);
      WriteEvent(Format(rsJournalStartedInModule,[string(p),VIM.Version,ParamStr(0),VIP.Version,FMachine,FUser]),elStart);
      Freemem(p);
    end else
      WriteEvent(Format(rsJournalStartedInEXE,[ParamStr(0),VIP.Version,FMachine,FUser]),elStart);
  except
    on e: Exception do begin
      FFile:=nil;
      FFilename:='';
    end;
  end;
end;

destructor TJournal.Destroy;
var
  i: Integer;
begin
  for i:=0 to High(FInternalTime) do
    WriteEvent('Freeing internal timer leak',elEnd);
  if FProcessHandle<>hInstance then
    WriteEvent(rsJournalFinishedInModule,elSystem)
  else
    WriteEventFmt(rsJournalFinishedInEXE,[ExitCode],elSystem);
  SetLength(FBuffer,0);
  if Assigned(FFile) then begin
    FlushFileBuffers(FFile.Handle);
    FFile.Free;
  end;
  inherited;
end;

function TJournal.GetRecord(Index: DWORD): TJournalRecord;
begin
  try
    Result:=FBuffer[Index];
  except
    ZeroMemory(@Result,SizeOf(TJournalRecord));
  end;
end;

function TJournal.GetRecordCount: DWORD;
begin
  Result:=Length(FBuffer);
end;

procedure TJournal.LoadFromFile(AFilename: string);
var
  fs: TFileStream;
  sl: TStringList;
  i,p: Integer;
  j: TEventLevel;
  s,v: string;
  r: TJournalRecord;
begin

    Clear;
    sl:=TStringList.Create;
    try
      fs:=TFileStream.Create(AFileName,fmOpenRead or fmShareDenyNone);
      sl.LoadFromStream(fs);
      for i:=0 to sl.Count-1 do begin
        s:=sl[i];
        if Pos('[',s)=1 then begin
          p:=Pos(']',s);
          r.TimestampStr:=Copy(s,2,p-2);
          Delete(s,1,p);
          p:=Pos(']',s);
          v:=Trim(Copy(s,2,p-2));
          r.Level:=elError;
          for j:=Low(EventLevels) to High(EventLevels) do
            if CompareText(v,Trim(EventLevels[j]))=0 then begin
              r.Level:=j;
              Break;
            end;
          Delete(s,1,p+1);
          r.Message:=s;
          AddRecord(r);
        end;
      end;
    finally
      fs.Free;
      sl.Free;
    end;
end;

function TJournal.PopTime: comp;
begin
  Result:=FInternalTime[High(FInternalTime)];
  SetLength(FInternalTime,High(FInternalTime));
end;

procedure TJournal.PushTime(Time: comp);
begin
  SetLength(FInternalTime,Length(FInternalTime)+1);
  FInternalTime[High(FInternalTime)]:=Time;
end;

procedure TJournal.SaveToFile(AFilename: string);
var
  i: Integer;
  sl: TStringList;
begin
  sl:=TStringList.Create;
  try
    for i:=0 to High(FBuffer) do
      with FBuffer[i] do
        sl.Add(Format('[%s][%s] %s',[TimestampStr,EventLevels[Level],Message]));
    sl.SaveToFile(AFilename);
  finally
    sl.Free;
  end;
end;

procedure TJournal.SetRecord(Index: DWORD; const Value: TJournalRecord);
begin
  FBuffer[Index]:=Value;
end;

procedure TJournal.StartTimer;
begin
  FStartTime:=GetTickCount;
  FStopTime:=FStartTime;
end;

function TJournal.StopTimer: Comp;
begin
  FStopTime:=GetTickCount;
  Result:=FStopTime-FStartTime;
end;

procedure TJournal.WriteEvent(AMessage: string; ALevel: TEventLevel);
var
  s: string;
  dt: TDateTime;
  t: comp;
begin
  AMessage:=StringReplace(AMessage,#10#13,' ',[rfReplaceAll,rfIgnoreCase]);
  AMessage:=StringReplace(AMessage,#13#10,' ',[rfReplaceAll,rfIgnoreCase]);
  AMessage:=StringReplace(AMessage,#10,' ',[rfReplaceAll,rfIgnoreCase]);
  AMessage:=StringReplace(AMessage,#13,' ',[rfReplaceAll,rfIgnoreCase]);
  if ALevel=elBegin then
    PushTime(GetTickCount);
  if ALevel=elEnd then begin
    t:=GetTickCount-PopTime;
    if AMessage='' then
      AMessage:=AMessage+'Elapsed time: '+FormatTimer(t)
    else
      AMessage:=AMessage+' - Elapsed time: '+FormatTimer(t);
  end;
  dt:=Now;
  if Assigned(FFile) then begin
    s:=Format('[%s][%s] %s',[FormatDateTime('yyyy-mm-dd hh:mm:ss',dt),EventLevels[ALevel],AMessage])+#13#10;
    FFile.WriteBuffer(PChar(s)^,Length(s));
    FlushFileBuffers(FFile.Handle);
  end;
  if FInternalSave then
    AddRecord(dt,AMessage,ALevel);
end;

procedure TJournal.WriteEventFmt(const AFormat: string;
  const AArgs: array of const; ALevel: TEventLevel);
var
  s: string;
begin
  s:=Format(AFormat,AArgs);
  WriteEvent(s,ALevel);
end;

procedure TJournal.WriteSpace;
var
  s: string;
begin
  if Assigned(FFile) then begin
    s:=#13#10;
    FFile.WriteBuffer(PChar(s)^,Length(s));
    FlushFileBuffers(FFile.Handle);
  end;
end;

end.

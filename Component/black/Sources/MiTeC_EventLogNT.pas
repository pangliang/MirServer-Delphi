{*******************************************************}
{                                                       }
{       MiTeC System Information Component              }
{        Windows NT Event Log Enumeration               }
{           version 8.3 for Delphi 5,6,7                }
{                                                       }
{       Copyright © 1997,2003 Michal Mutl               }
{                                                       }
{*******************************************************}

{$INCLUDE MITEC_DEF.INC}


unit MiTeC_EventLogNT;

interface

uses Windows, Classes, SysUtils;

const
  BUFFER_SIZE = 4096;

// Defines for the READ flags for Eventlogging
  EVENTLOG_SEQUENTIAL_READ =  $0001;
  EVENTLOG_SEEK_READ       =  $0002;
  EVENTLOG_FORWARDS_READ   =  $0004;
  EVENTLOG_BACKWARDS_READ  =  $0008;

// The types of events that can be logged.

  EVENTLOG_SUCCESS          = $0000;
  EVENTLOG_ERROR_TYPE       = $0001;
  EVENTLOG_WARNING_TYPE     = $0002;
  EVENTLOG_INFORMATION_TYPE = $0004;
  EVENTLOG_AUDIT_SUCCESS    = $0008;
  EVENTLOG_AUDIT_FAILURE    = $0010;


// Defines for the WRITE flags used by Auditing for paired events
// These are not implemented in Product 1

  EVENTLOG_START_PAIRED_EVENT    = $0001;
  EVENTLOG_END_PAIRED_EVENT      = $0002;
  EVENTLOG_END_ALL_PAIRED_EVENTS = $0004;
  EVENTLOG_PAIRED_EVENT_ACTIVE   = $0008;
  EVENTLOG_PAIRED_EVENT_INACTIVE = $0010;

type
  PSID = Pointer;

  _EVENTLOGRECORD = record
    Length: DWORD;
    Reserved: DWORD;
    RecordNumber: DWORD;
    TimeGenerated: DWORD;
    TimeWritten: DWORD;
    EventID: DWORD;
    EventType: WORD;
    NumStrings: WORD;
    EventCategory: WORD;
    ReservedFlags: WORD;
    ClosingRecordNumber: DWORD;
    StringOffset: DWORD;
    UserSidLength: DWORD;
    UserSidOffset: DWORD;
    DataLength: DWORD;
    DataOffset: DWORD;
    {SourceName: PChar;
    Computername: PChar;
    UserSid: PSID;
    Strings: PChar;
    Data: PChar;
    Pad: PChar;
    Length: DWORD;}
  end;

  PEVENTLOGRECORD = ^EVENTLOGRECORD;
  EVENTLOGRECORD = _EVENTLOGRECORD;

  TEventLogType = (elApplication, elSystem, elSecurity);

  TEventType = (etError, etWarning, etInformation, etAuditSuccess, etAuditFailure);

  PLogRecord = ^TLogRecord;
  TLogRecord = record
    EventType: TEventType;
    DateTime: TDateTime;
    Source: string;
    Category: string;
    EventID: Cardinal;
    Username: string;
    Domain: string;
    Computer: string;
    Description: string;
    BinaryData: string;
    CharData: string;
  end;

  TEventLog = class(TPersistent)
  private
    FType: TEventLogType;
    FRecords: TStringList;
    FMachine: string;

    procedure RetrieveLog(AMachine: string; AType: TEventLogType);
    procedure FreeList(var AList: TStringList);

    function GetRecCount: DWORD;
    function GetRecord(Index: DWORD): PLogRecord;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Refresh;

    property Machine: string read FMachine write FMachine;
    property LogType: TEventLogType read FType write FType;
    property RecordCount: DWORD read GetRecCount;
    property LogRecords[Index: DWORD]: PLogRecord read GetRecord;
  end;

const
  EventLogTypes: array[elApplication..elSecurity] of string = ('Application', 'System', 'Security');
  EventTypes: array[etError..etAuditFailure] of string = ('Error', 'Warning', 'Information', 'AuditSuccess', 'AuditFailure');

  rkEventLog = {HKEY_LOCAL_MACHINE\}'SYSTEM\CurrentControlSet\Services\EventLog';

  rvEventMessageFile = 'EventMessageFile'; // Path to the message resource file that contains the event format strings.
  rvTypesSupported = 'TypesSupported'; //The types of events this source can generate.
  rvCategoryMessageFile = 'CategoryMessageFile'; //Path to the message resource file that has the descriptive strings for the source categories.
  rvCategoryCount = 'CategoryCount'; // The number of categories described in the CategoryMessageFile.
  rvParameterMessageFile = 'ParameterMessageFile'; //Insert parameter descriptive strings.


implementation

uses Registry, MiTeC_Routines, MiTeC_StrUtils, MiTeC_Datetime;

function GetMessageInfo(AFilename: string; AID: DWORD): string;
var
  hLib: THandle;
  lpMsgBuf: Pchar;
  LangID: DWORD;
begin
  lpMsgBuf:=AllocMem(BUFFER_SIZE);
  LangID:=$409;//GetUserDefaultLangID;
  if FileExists(AFilename) then begin
    hLib:=LoadLibrary(PChar(AFilename));
    if hLib<>0 then begin
      FormatMessage(FORMAT_MESSAGE_FROM_HMODULE or FORMAT_MESSAGE_IGNORE_INSERTS,
                    Pointer(hLib),AID,LangID,lpMsgBuf,BUFFER_SIZE,nil);
      FreeLibrary(hLib);
    end;
  end;
  Result:=StrPas(lpMsgBuf);
  FreeMem(lpMsgBuf);
end;

function ExpandMessage(AMessage, AParams: string): string;
var
  sl: TStringList;
  i,p: integer;
  s: string;
begin
  if AMessage='' then
    Result:=AParams
  else begin
    sl:=TStringList.Create;
    SetDelimitedText(AParams,#13,sl);
    for i:=0 to sl.Count-1 do begin
      s:='%'+IntToStr(i+1);
      p:=Pos(s,AMessage);
      if p>0 then
        AMessage:=Copy(AMessage,1,p-1)+sl[i]+Copy(AMessage,p+Length(s),1024);
    end;
    Result:=StringReplace(AMessage,#13#10#13#10,#13#10,[rfReplaceAll,rfIgnoreCase]);
    sl.Free;
  end;
end;

{ TEventLog }

constructor TEventLog.Create;
begin
  FRecords:=TStringList.Create;
end;

destructor TEventLog.Destroy;
begin
  FreeList(FRecords);
  FRecords.Free;
  inherited;
end;

procedure TEventLog.FreeList(var AList: TStringList);
begin
  while AList.Count>0 do begin
    dispose(PEventLogRecord(AList.Objects[AList.Count-1]));
    AList.Delete(AList.Count-1);
  end;
end;

function TEventLog.GetRecCount: DWORD;
begin
  Result:=Frecords.Count;
end;

function TEventLog.GetRecord(Index: DWORD): PLogRecord;
begin
  if Index<DWORD(FRecords.Count) then
    Result:=PLogRecord(FRecords.Objects[Index])
  else
    Result:=nil;
end;

procedure TEventLog.Refresh;
begin
  RetrieveLog(Machine,LogType);
end;

procedure TEventLog.RetrieveLog;
var
  h: THANDLE;
  PEvLR: PEVENTLOGRECORD;
  bBuffer: array [0..BUFFER_SIZE-1] of Byte;
  dwRead, dwNeeded, dwNameSize, dwDomainSize, dwSIDType,
  i{,TypesSupported, CategoryCount}: DWORD;
  SID: PSID;
  s, Strings, EventMessageFile, CategoryMessageFile, ParameterMessageFile: string;
  szNameBuf, szDomainBuf: array[0..BUFFER_SIZE-1] of char;
  pelr: PLogRecord;
//  p: PChar;
  b: Byte;
begin
  FreeList(FRecords);
  h:=OpenEventLog(PChar(AMachine),PChar(EventLogTypes[AType]));
  if h<>0 then begin
    pevlr:=PEVENTLOGRECORD(@bBuffer);
    with TRegistry.Create do begin
      RootKey:=HKEY_LOCAL_MACHINE;
      while ReadEventLog(h,EVENTLOG_BACKWARDS_READ or EVENTLOG_SEQUENTIAL_READ,0,
                          pevlr,BUFFER_SIZE,dwRead,dwNeeded) do begin

        while (dwRead>0) do begin
          new(pelr);
          pelr^.Source:=StrPas(PChar(PChar(pevlr)+sizeof(_EVENTLOGRECORD)));
          pelr^.Computer:=StrPas(PChar(PChar(pevlr)+sizeof(_EVENTLOGRECORD)+Length(pelr^.Source)+1));
          SID:=PByte(PChar(pevlr)+pevlr^.UserSidOffset);
          dwNameSize:=BUFFER_SIZE;
          dwDomainSize:=BUFFER_SIZE;
          if LookupAccountSID(PChar(pelr^.Computer),SID,szNameBuf,dwNameSize,szDomainBuf,dwDomainSize,dwSIDType) then begin
            pelr^.UserName:=StrPas(sznameBuf);
            pelr^.Domain:=StrPas(szDomainBuf);
          end else begin
            pelr^.UserName:='';
            pelr^.Domain:='';
          end;
          pelr^.BinaryData:='';
          pelr^.CharData:='';
          i:=0;
          while i<pevlr^.DataLength do begin
            b:=PByte(PChar(PChar(pevlr)+pevlr^.DataOffset+i))^;
            s:=Format('%0.2x',[b]);
            pelr^.BinaryData:=pelr^.BinaryData+s+',';
            if not(b in [0..31,44]) then
              s:=char(b)
            else
              s:='.';
            pelr^.CharData:=pelr^.CharData+s+',';
            Inc(i);
          end;
          pelr^.BinaryData:=Copy(pelr^.BinaryData,1,Length(pelr^.BinaryData)-1);
          pelr^.CharData:=Copy(pelr^.CharData,1,Length(pelr^.CharData)-1);
          i:=0;
          Strings:='';
          while i<pevlr^.NumStrings do begin
            s:=StrPas(PChar(PChar(pevlr)+pevlr^.StringOffset+Length(Strings)));
            Strings:=Strings+s+#13;
            Inc(i);
          end;
          Strings:=Copy(Strings,1,Length(Strings)-1);
          pelr^.EventID:=pevlr^.EventID;
          if (pelr^.EventID>MAXINT-1) then
            pelr^.EventID:=MAXINT-Abs(pelr^.EventID)+1;
          case pevlr^.EventType of
            EVENTLOG_ERROR_TYPE       :pelr^.EventType:=etError;
            EVENTLOG_WARNING_TYPE     :pelr^.EventType:=etWarning;
            EVENTLOG_INFORMATION_TYPE :pelr^.EventType:=etInformation;
            EVENTLOG_AUDIT_SUCCESS    :pelr^.EventType:=etAuditSuccess;
            EVENTLOG_AUDIT_FAILURE    :pelr^.EventType:=etAuditFailure;
          end;
          pelr^.DateTime:=UTCToDateTime(pevlr^.TimeGenerated);

          if OpenKeyReadOnly(rkEventLog+'\'+EventLogTypes[AType]+'\'+pelr^.Source) then begin
            if ValueExists(rvEventMessageFile) then
              EventMessageFile:=ExpandEnvVars(ReadString(rvEventMessageFile))
            else
              EventMessageFile:='';
            if ValueExists(rvCategoryMessageFile) then
              CategoryMessageFile:=ExpandEnvVars(ReadString(rvCategoryMessageFile))
            else
              CategoryMessageFile:='';
            if ValueExists(rvParameterMessageFile) then
              ParameterMessageFile:=ExpandEnvVars(ReadString(rvParameterMessageFile))
            else
              ParameterMessageFile:='';
            {if ValueExists(rvTypesSupported) then begin
              if GetDataType(rvTypesSupported)=rdInteger then
                TypesSupported:=ReadInteger(rvTypesSupported)
              else
                if GetDataType(rvTypesSupported)=rdBinary then begin
                  p:=AllocMem(4);
                  ReadBinaryData(rvTypesSupported,p^,4);
                  TypesSupported:=PInteger(p)^;
                  FreeMem(p);
                end;
            end else
              TypesSupported:=0;
            {if ValueExists(rvCategoryCount) then
              CategoryCount:=ReadInteger(rvCategoryCount)
            else
              CategoryCount:=0;}
            CloseKey;
          end;

          pelr^.Category:=Trim(GetMessageInfo(CategoryMessageFile,pevlr^.EventCategory));
          pelr^.Description:=ExpandMessage(GetMessageInfo(EventMessageFile,pevlr^.EventID),Strings);
          FRecords.AddObject(Format('%x',[pelr^.EventID]),TObject(pelr));
          dwRead:=dwRead-pevlr^.Length;
          pevlr:=PEVENTLOGRECORD(PChar(pevlr)+pevlr^.Length);
        end;
        pevlr:=PEVENTLOGRECORD(@bBuffer);
      end;
      CloseEventLog(h);
      Free;
    end;
  end;
end;

end.

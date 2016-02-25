{*******************************************************}
{                                                       }
{       MiTeC System Information Component              }
{     Common Routines, Definitions & Types              }
{           version 8.6.4 for Delphi 5,6,7              }
{                                                       }
{       Copyright © 1997,2004 Michal Mutl               }
{                                                       }
{*******************************************************}

{$INCLUDE MITEC_DEF.INC}

unit MSI_Common;

interface

uses SysUtils, Windows, Classes
  {$IFDEF ERROR_INTERCEPT}
  ,MiTeC_Journal, MSI_ExceptionStack
  {$ENDIF}
  ;

type
  EMSIC_Error = class(Exception);

  TExceptionMode = (emDefault, emExceptionStack, emJournal);
  TExceptionModes = set of TExceptionMode;

  {$IFDEF ERROR_INTERCEPT}
  TMSIC_TraceRecord = record
    ExceptionModes: TExceptionModes;
    ObjectName,
    FunctionName: ShortString;
  end;
  TMSIC_TraceStack = array of TMSIC_TraceRecord;
  {$ENDIF}


const
  cMajorVersion = '8';
  cMinorVersion = '6';
  cFixVersion = '5';
  cVersion = cMajorVersion+'.'+cMinorVersion+'.'+cFixVersion;
  cCompName = 'MiTeC System Information Component';
  cCopyright = 'Copyright '#169' 1997,2004 Michal Mutl';
  cWWW = 'http://www.mitec.cz/';
  cEmail = 'mailto:michal.mutl@mitec.cz';

  ARRAY_PRE_SIZE = 100;

procedure StringsToRep(sl: TStrings; CountKwd,ItemKwd: string; var Report: TStringlist);

procedure ReportHeader(var sl: TStringList);
procedure ReportFooter(var sl: TStringList);
function CheckXMLValue(AValue: string): string;

{$IFDEF ERROR_INTERCEPT}
procedure InitializeJournal(JournalPath: string = '');
procedure ShutdownJournal;

procedure PushTrace(AExceptionModes: TExceptionModes; AObjectName,AClassName,AFunctionName: ShortString); overload;
procedure PushTrace(AExceptionModes: TExceptionModes; AObject: TObject; AFunctionName: ShortString); overload;
procedure PopTrace;
function GetTrace: TMSIC_TraceRecord;

procedure ShowExceptionStack;
{$ENDIF}


{$IFDEF ERROR_INTERCEPT}
var
  Journal: TJournal;
  TraceStack: TMSIC_TraceStack;
{$ENDIF}

implementation

uses MiTeC_Routines;

{$IFDEF ERROR_INTERCEPT}
procedure ShowExceptionStack;
begin
  if dlgExceptionStack<>nil then
    dlgExceptionStack.ShowModal;
end;

procedure InitializeJournal;
begin
  if JournalPath='' then
    JournalPath:=ExtractFilePath(ParamStr(0));
  Journal:=TJournal.Create(JournalPath,Format('MSIC_%s_%s_%s',[cMajorVersion,cMinorVersion,MachineName]),False,False,False);
end;

procedure ShutdownJournal;
begin
  try
    FreeAndNil(Journal);
  except
  end;
end;

procedure PushTrace(AExceptionModes: TExceptionModes; AObjectName,AClassname,AFunctionName: ShortString);
begin
  SetLength(TraceStack,Length(TraceStack)+1);
  with TraceStack[High(TraceStack)] do begin
    ExceptionModes:=AExceptionModes;
    ObjectName:=Format('(%s.%s)',[AObjectName,AClassName]);
    FunctionName:=AFunctionName;
  end;
end;

procedure PushTrace(AExceptionModes: TExceptionModes; AObject: TObject; AFunctionName: ShortString);
begin
  SetLength(TraceStack,Length(TraceStack)+1);
  with TraceStack[High(TraceStack)] do begin
    ExceptionModes:=AExceptionModes;
    ObjectName:=GetObjectFullName(AObject);
    FunctionName:=AFunctionName;
  end;
end;

procedure PopTrace;
begin
  SetLength(TraceStack,Length(TraceStack)-1);
end;

function GetTrace;
begin
  try
    Result:=TraceStack[High(TraceStack)];
  except
    ZeroMemory(@Result,SizeOf(Result));
    Result.ExceptionModes:=[emExceptionStack];
  end;
end;

{$ENDIF}

procedure ReportHeader;
var
  lngID: LANGID;
  s: string;
begin
  s:='iso-8859-1';
  lngID:=GetSystemDefaultLangID;
  case lngID of
    $0405: s:='windows-1250'; //Czech
    $0804: s:='GB2312';  //Simple chinese
    $0404: s:='Big5';  // Traditional chinese
    $0419: s:='KOI8-R';  //Russian
    $0411: s:='Shift_JIS'; //Japanese
    $0412: s:='korean'; //Korean
    $040D: s:='hebrew'; //Hebrew
  end;
  sl.Add(Format('<?xml version="1.0" encoding="%s" standalone="yes"?>',[s]));
  sl.Add(Format('<classes componentname="%s" version="%s" copyright="%s" os="%s (%d.%d.%d)" machine="%s">',[CheckXMLValue(cCompName),cVersion,CheckXMLValue(cCopyright),OSVersionEx,OSMajorversion,OSMinorVersion,OSBuild,CheckXMLValue(MachineName)]));
end;

procedure ReportFooter;
begin
  sl.Add('</classes>');
end;

function CheckXMLValue;
var
  i: Integer;
  c: Char;
begin
  Result:=StringReplace(AValue,'&','&amp;',[rfIgnoreCase,rfReplaceAll]);
  Result:=StringReplace(Result,'"','&quot;',[rfIgnoreCase,rfReplaceAll]);
  Result:=StringReplace(Result,'''','&apos;',[rfIgnoreCase,rfReplaceAll]);
  Result:=StringReplace(Result,'>','&gt;',[rfIgnoreCase,rfReplaceAll]);
  Result:=StringReplace(Result,'<','&lt;',[rfIgnoreCase,rfReplaceAll]);
  Result:=StringReplace(Result,#13,'',[rfIgnoreCase,rfReplaceAll]);
  Result:=StringReplace(Result,#10,'',[rfIgnoreCase,rfReplaceAll]);
  for i:=1 to Length(Result) do begin
    c:=Result[i];
    if not(c in [#32..#127]) then begin
      Delete(Result,i,1);
      if (c in [#0..#31]) then
        Insert('_',Result,i)
      else
        Insert(Format('&#%d;',[Ord(c)]),Result,i);
    end;
  end;
end;


procedure StringsToRep(sl: TStrings; CountKwd,ItemKwd: string; var Report: TStringlist);
var
  i: integer;
begin
  with Report do begin
    if CountKwd<>'' then
      Add(Format('<data name="%s" type="integer">%d</data>',[CountKwd,sl.Count]));
    for i:=0 to sl.Count-1 do
      Add(Format('<data name="%s[%d]" type="string">%s</data>',[CheckXMLValue(ItemKwd),i,CheckXMLValue(sl[i])]));
  end;
end;

{$IFDEF ERROR_INTERCEPT}
initialization
  Journal:=nil;
  SetLength(TraceStack,0);
  ErrorIntercept;
finalization
  ErrorRelease;
  SetLength(TraceStack,0);
  ShutdownJournal;
{$ENDIF}
end.

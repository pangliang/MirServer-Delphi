{*******************************************************}
{                                                       }
{         MiTeC System Information Component            }
{                Exception Stack                        }
{           version 8.6.4 for Delphi 5,6,7              }
{                                                       }
{       Copyright © 1997,2004 Michal Mutl               }
{                                                       }
{*******************************************************}


{$INCLUDE MITEC_DEF.INC}


unit MSI_ExceptionStack;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls;

type
  TMSIC_ErrorRecord = record
    Classname,
    Text,
    Module,
    Sender: ShortString;
    Address: Pointer;
    Code: Integer;
  end;
  TMSIC_ErrorStack = array of TMSIC_ErrorRecord;

  TdlgExceptionStack = class(TForm)
    Panel7: TPanel;
    Panel10: TPanel;
    bOK: TButton;
    ClientPanel: TPanel;
    List: TListView;
    Panel1: TPanel;
    AppIcon: TImage;
    Image1: TImage;
    Bevel1: TBevel;
    lApplication: TLabel;
    lMSIC: TLabel;
    Memo: TMemo;
    Splitter1: TSplitter;
    Button1: TButton;
    LogPanel: TPanel;
    eLog: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ListSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure Button1Click(Sender: TObject);
  private
    FErrorStack: TMSIC_ErrorStack;
    FExceptObj: Exception;
    FPrevOnException: TExceptionEvent;
  public
    procedure ExceptionHandler(Sender: TObject; E: Exception);
  end;

procedure ErrorIntercept;
procedure ErrorRelease;
procedure ShowExceptionStack;

var
  dlgExceptionStack: TdlgExceptionStack;

resourcestring
  rsErrorMessage = '%s'#13#10#13#10+
                   'Code: 0x%x'#13#10+
                   'Class: %s'#13#10+
                   'Module: %s'#13#10+
                   'Address: 0x%p'#13#10+
                   'Sender: %s'#13#10#13#10+
                   'Call Stack:'#13#10'%s';


implementation

uses {$IFDEF ERROR_INTERCEPT} MiTeC_Journal, {$ENDIF} MiTeC_Routines, MSI_Common;

{$R *.dfm}

procedure ErrorIntercept;
begin
  ErrorRelease;
  dlgExceptionStack:=TdlgExceptionStack.Create(Application);
end;

procedure ErrorRelease;
begin
  try
    dlgExceptionStack.Free;
  except
    dlgExceptionStack:=nil;
  end;
end;

procedure ShowExceptionStack;
begin
  if dlgExceptionStack<>nil then
    dlgExceptionStack.ShowModal;
end;

{ TdlgExceptionStack }

procedure TdlgExceptionStack.ExceptionHandler(Sender: TObject;
  E: Exception);
{$IFDEF ERROR_INTERCEPT}
var
  i: Integer;
  s,cs: string;
  er: TMSIC_ErrorRecord;
  tr: TMSIC_TraceRecord;
{$ENDIF}
begin
{$IFDEF ERROR_INTERCEPT}
  if (FExceptObj=nil) and not Application.Terminated then begin
    FExceptObj:=E;
    tr:=GetTrace;
    er.Sender:=GetObjectFullName(Sender);
    er.Classname:=E.ClassName;
    er.Text:=E.message;
    er.Address:=ExceptAddr;
    ErrorInfo(er.Address,er.Module);
    er.Code:=0;
    if E is EInOutError then
      er.Code:=EInOutError(E).ErrorCode
    else
      {if E is EOleException then
        er.Code:=EOleException(E).ErrorCode;
      else
        if E is EOleSysError then
          er.Code:=EOleSysError(E).ErrorCode
        else}
          if E is EExternalException then
            er.Code:=EExternalException(E).ExceptionRecord^.ExceptionCode
          else
            {$IFDEF D6PLUS}
            if E is EOSError then
              er.Code:=EOSError(E).ErrorCode;
            {$ELSE}
            if E is EWin32Error then
              er.Code:=EWin32Error(E).ErrorCode;
            {$ENDIF}

    SetLength(FErrorStack,Length(FErrorStack)+1);
    FErrorStack[High(FErrorStack)]:=er;
    cs:='';
    for i:=High(TraceStack) downto 0 do
      cs:=cs+Format('%s.%s'#13#10,[TraceStack[i].ObjectName,TraceStack[i].FunctionName]);
    s:=Format(rsErrorMessage,[er.Text,
                              er.Code,
                              er.Classname,
                              er.Module,
                              er.Address,
                              er.Sender,
                              cs]);
    if emJournal in tr.ExceptionModes then begin
      if not Assigned(Journal) then
        InitializeJournal;
      with Journal do begin
        WriteEventFmt('%s',[er.Text],elError);
        WriteEvent('ERROR DATA',elBegin);
        WriteEventFmt('Class: %s',[er.Classname],elData);
        WriteEventFmt('Code: 0x%x',[er.Code],elData);
        WriteEventFmt('Module: %s',[er.Module],elData);
        WriteEventFmt('Address: 0x%p',[er.Address],elData);
        WriteEventFmt('Sender: %s',[er.Sender],elData);
        WriteEvent('Call Stack',elBegin);
        for i:=High(TraceStack) downto 0 do
          WriteEventFmt('%s.%s',[TraceStack[i].ObjectName,TraceStack[i].FunctionName],elData);
        WriteEvent('',elEnd);
        WriteEvent('',elEnd);
      end;
    end;
    if emDefault in tr.ExceptionModes then begin
      if Assigned(FPrevOnException) then
        FPrevOnException(Sender,E)
      else
        if NewStyleControls then
          Application.ShowException(E)
        else
          MessageBox(Handle,PChar(E.Message),'',MB_ICONERROR or MB_OK);
    end;
    if emExceptionStack in tr.ExceptionModes then begin
      if not IsConsole then begin
        Application.NormalizeTopMosts;
        try
          with List.Items.Insert(0) do begin
            Caption:=Datetimetostr(now);
            SubItems.Add(er.Classname);
            SubItems.Add(Format('0x%x',[er.Code]));
            SubItems.Add(er.Text);
            SubItems.Add(s);
          end;
          List.Selected:=List.Items[0];
          List.Selected.MakeVisible(False);
          LogPanel.Visible:=emJournal in tr.ExceptionModes;
          if Journal<>nil then
            eLog.Text:=Journal.FileName;
          ShowModal;
        finally
          FExceptObj:=nil;
          Application.RestoreTopMosts;
        end;
      end else
        Writeln(s);
    end;
  end else
    if NewStyleControls then
      Application.ShowException(E)
    else
      MessageBox(Handle,PChar(E.Message),'',MB_ICONERROR or MB_OK);
  SetLength(TraceStack,0);
{$ELSE}
  FPrevOnException(Sender,E);
{$ENDIF}
end;


procedure TdlgExceptionStack.FormCreate(Sender: TObject);
var
  s: string;
begin
  FPrevOnException:=nil;
  SetLength(FErrorStack,0);
  FPrevOnException:=Application.OnException;
  Application.OnException:=ExceptionHandler;
  AppIcon.Picture.Icon.Handle:=Application.Icon.Handle;
  s:=EXEversionInfo.Description;
  if Trim(s)='' then
    s:=ExtractFilename(ParamStr(0));
  lApplication.Caption:=Format('%s %s',[s,EXEversionInfo.Version]);
  lMSIC.Caption:=Format('%s %s',[cCompName,cVersion]);
end;

procedure TdlgExceptionStack.FormDestroy(Sender: TObject);
begin
  SetLength(FErrorStack,0);
  Application.OnException:=FPrevOnException;
end;

procedure TdlgExceptionStack.ListSelectItem(Sender: TObject;
  Item: TListItem; Selected: Boolean);
begin
  if Assigned(Item) then
    Memo.Lines.Text:=Item.SubItems[Item.SubItems.Count-1]
  else
    Memo.Lines.Clear;
end;

procedure TdlgExceptionStack.Button1Click(Sender: TObject);
begin
  List.Items.Clear;
  Memo.Lines.Clear;
end;

initialization
  dlgExceptionStack:=nil;
finalization
  ErrorRelease;
end.

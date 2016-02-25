{*******************************************************}
{                                                       }
{               MiTeC Dialogs                           }
{           version 1.1 for Delphi 5,6,7                }
{                                                       }
{       Copyright © 1997,2002 Michal Mutl               }
{                                                       }
{*******************************************************}

{$INCLUDE MITEC_DEF.INC}


unit MiTeC_Dialogs;

interface

uses Windows, Classes, SysUtils, ShlObj;

type
  TOpenFileNameEx = packed record
   // Size of the structure in bytes.
  lStructSize: DWORD;
   // Handle that is the parent of the dialog.
  hWndOwner: HWND;
   // Application instance handle.
  hInstance: HINST;
   // String containing filter information.
  lpstrFilter: PAnsiChar;
   // Will hold the filter chosen by the user.
  lpstrCustomFilter: PAnsiChar;
   // Size of lpstrCustomFilter, in bytes.
  nMaxCustFilter: DWORD;
   // Index of the filter to be shown.
  nFilterIndex: DWORD;
   // File name to start with (and retrieve).
  lpstrFile: PAnsiChar;
   // Size of lpstrFile, in bytes.
  nMaxFile: DWORD;
   // File name without path will be returned.
  lpstrFileTitle: PAnsiChar;
   // Size of lpstrFileTitle, in bytes.
  nMaxFileTitle: DWORD;
   // Starting directory.
  lpstrInitialDir: PansiChar;
   // Title of the open dialog.
  lpstrTitle: PAnsiChar;
   // Controls user selection options.
  Flags: DWORD;
   // Offset of file name in filepath=lpstrFile.
  nFileOffset: Word;
   // Offset of extension in filepath=lpstrFile.
  nFileExtension: Word;
   // Default extension if no extension typed.
  lpstrDefExt: PAnsiChar;
   // Custom data to be passed to hook.
  lCustData: LPARAM;
  lpfnHook: function(Wnd: HWND; Msg: UINT; wParam: WPARAM;
    lParam: LPARAM): UINT stdcall;  // Hook.
   // Template dialog, if applicable.
  lpTemplateName: PAnsiChar;
   // Extended structure starts here.
  pvReserved: Pointer;   // Reserved, use nil.
  dwReserved: DWORD;     // Reserved, use 0.
  FlagsEx: DWORD;        // Extended Flags.
  end;

  TControlApplet = (cplAll, cplAppWiz, cplTimeDate, cplDisplay, cplMultimedia,
                    cplNetwork, cplIntl, cplSystem, cplHwWiz);

  TFormatType = (ftFull, ftQuick);

function YesNo(Text :string) :boolean;
function YesNoCancel(Text :string) :integer;
procedure Warn(Text :string);
function WarnYesNo(Text :string) :Boolean;
function WarnOKCancel(Text :string) :Boolean;
procedure Error(Text :string);
procedure Info(Text :string);

{$IFNDEF BCB}

function GetFileOpenDlg(AHandle: THandle;
                        var ADir: string;
                        var FileName: string;
                        AFilter: string;
                        ATitle: string = ''): Boolean;
function GetFileSaveDlg(AHandle: THandle;
                        var ADir: string;
                        var FileName: string;
                        AFilter: string;
                        ATitle: string = ''): Boolean;
function ConcatFilters(const Filters: array of string): string;
function BrowseFolderDlg(Handle: HWND; var FolderName: string; Caption: string): Boolean;
function ComputerNameDlg(Handle: HWND; var ComputerName: string; Caption: string): Boolean;
function RunDlg(Handle, IconHandle: HWND; Caption, Description: string): Integer;
function FormatDlg(Handle: HWND; FormatType: TFormatType; DriveChar: char): integer;
function FindFilesDlg: Boolean;
function FindComputerDlg: Boolean;
function ShutdownDlg(Option: Integer): DWORD;
procedure ControlApplet(AHandle: THandle; Applet: TControlApplet = cplAll); overload;
procedure ControlApplet(AHandle: THandle; Applet: string = ''); overload;
function ShellPropDlg(const Handle: HWND; const FileName: string): Boolean;

procedure FreePIDL(PIDL: PItemIDList); stdcall;
function  SHFormatDrive(wnd: HWND; drive : UINT; fmtID : UINT; options : UINT): DWORD; stdcall;
function  SHShutDownDialog(YourGuess : integer) : DWORD; stdcall;
function  SHRunDialog(wnd : HWND; Unknown1:integer; Unknown2 : Pointer; szTitle : PChar; szPrompt : PChar; uiFlages : integer) : DWORD; stdcall;
function  SHChangeIcon(wnd : HWND; szFileName : PChar; reserved : integer; var lpIconIndex : integer) : DWORD; stdcall;
function  SHFindFiles(Root: PItemIDList; SavedSearchFile: PItemIDList): LongBool; stdcall;
function  SHFindComputer(Reserved1: PItemIDList; Reserved2: PItemIDList): LongBool; stdcall;
function  SHObjectProperties(Owner: HWND; Flags: UINT; ObjectName: Pointer; InitialTabName: Pointer): LongBool; stdcall;
function  SHNetConnectionDialog(Owner: HWND; ResourceName: Pointer; ResourceType: DWORD): DWORD; stdcall;
function  SHStartNetConnectionDialog(Owner: HWND; ResourceName: PWideChar; ResourceType: DWORD): DWORD; stdcall;
function  SHOutOfMemoryMessageBox(Owner: HWND; Caption: Pointer; Style: UINT): Integer; stdcall;
procedure SHHandleDiskFull(Owner: HWND; uDrive: UINT); stdcall;
function  ShellMessageBox(Instance: THandle; Owner: HWND; Text: PChar; Caption: PChar; Style: UINT; Parameters: Array of Pointer):Integer; cdecl;
function  GetOpenFileNameEx(var OpenFile: TOpenFilenameEx): Bool; stdcall;
function  GetSaveFileNameEx(var SaveFile: TOpenFileNameEx): bool; stdcall;
procedure NewLinkHere(HWND : THandle; HInstance : THandle; CmdLine : Pchar; cmdShow : integer); stdcall;

{$ENDIF}

var
  LastDir: string;
  SelectedFilename: string;
  IsNT: Boolean;

  rsConfirmation: string = 'Confirmation';
  rsWarning: string = 'Warning';
  rsInformation: string = 'Information';
  rsError: string = 'Error';

const
  allFilter = 'All Files'#0'*.*'#0#0;
  bdeFilter = 'dBase/FoxPro/Paradox Files'#0'*.dbf;*.db'#0#0;
  dbfFilter = 'dBase/FoxPro Files'#0'*.dbf'#0#0;
  pdxFilter = 'Paradox Files'#0'*.db'#0#0;
  gdbFilter = 'Interbase Files'#0'*.gdb'#0#0;
  txtFilter = 'Text Files'#0'*.txt'#0#0;
  sqlFilter = 'SQL Script Files'#0'*.sql'#0#0;
  xlsFilter = 'Excel Files'#0'*.xls'#0#0;
  csvFilter = 'CSV Files'#0'*.csv'#0#0;
  logFilter = 'Log Files'#0'*.log'#0#0;

  ofnTitle = 'Select file';

  SHFMT_ID_DEFAULT = $FFFF;
  SHFMT_OPT_FULL   = $0001;
  SHFMT_OPT_SYSONLY= $0002;
 // Special return values. PLEASE NOTE that these are DWORD values.
  SHFMT_ERROR = $FFFFFFFF;  // Error on last format
 // drive may be formatable
  SHFMT_CANCEL = $FFFFFFFE;  // Last format wascanceled
  SHFMT_NOFORMAT = $FFFFFFFD;  // Drive is not formatable

implementation

uses ShellAPI, CommDlg;

const
  MAXSIZE = 10240;

var
  ofn: TOpenFilename;
  buffer: array [0..MAXSIZE - 1] of Char;

function YesNo;
begin
  Result:=MessageBox(0,PChar(Text),PChar(rsConfirmation),MB_YESNO or MB_ICONQUESTION)=IDYES;
end;

function YesNoCancel;
begin
  Result:=MessageBox(0,PChar(Text),PChar(rsConfirmation),MB_YESNOCANCEL or MB_ICONQUESTION);
end;

procedure Warn;
begin
  MessageBox(0,PChar(Text),PChar(rsWarning),MB_OK or MB_ICONWARNING);
end;

function WarnYesNo;
begin
  Result:=MessageBox(0,PChar(Text),PChar(rsWarning),MB_YESNO or MB_ICONWARNING)=IDYES;
end;

function WarnOKCancel;
begin
  Result:=MessageBox(0,PChar(Text),PChar(rsWarning),MB_OKCANCEL or MB_ICONWARNING)=IDOK;
end;

procedure Error;
begin
  MessageBox(0,PChar(Text),PChar(rsError),MB_OK or MB_ICONERROR);
end;


procedure Info;
begin
  MessageBox(0,PChar(Text),PChar(rsInformation),MB_OK or MB_ICONINFORMATION);
end;

{$IFNDEF BCB}
function GetFileOpenDlg;
var
  e: DWORD;
begin
  if ADir='' then
    ADir:=ExtractFilePath(ParamStr(0));
  StrPCopy(PChar(@buffer),FileName);
  ofn.lStructSize:=SizeOf(TOpenFilename);
  ofn.hWndOwner:=AHandle;
  ofn.hInstance:=HInstance;
  ofn.lpstrFilter:=PChar(AFilter);
  ofn.lpstrFile:=buffer;
  ofn.nMaxFile:=MAXSIZE;
  ofn.lpstrTitle:=PChar(ATitle);
  ofn.lpstrInitialDir:=PChar(ADir);
  ofn.Flags:=OFN_FILEMUSTEXIST or OFN_PATHMUSTEXIST or
             OFN_LONGNAMES or OFN_EXPLORER or OFN_HIDEREADONLY;
  Result:=GetOpenFileName(ofn);
  e:=CommDlgExtendedError;
  if e=1 then begin
    ofn.Flags:=OFN_FILEMUSTEXIST or OFN_PATHMUSTEXIST or
               OFN_LONGNAMES or OFN_HIDEREADONLY;
    Result:=GetOpenFileName(ofn);
    e:=CommDlgExtendedError;
  end;
  if e>0 then
    raise Exception.Create(Format('GetFileOpenDlg.CommDlgExtendedError = %x',[e]));
  Filename:=buffer;
  ADir:=ExtractFilepath(FileName);
end;

function GetFileSaveDlg;
var
 e: DWORD;
begin
  if ADir='' then
    ADir:=ExtractFilePath(ParamStr(0));
  StrPCopy(PChar(@buffer),FileName);
  ofn.lStructSize:=SizeOf(TOpenFilename);
  ofn.hWndOwner:=AHandle;
  ofn.hInstance:=HInstance;
  ofn.lpstrFilter:=PChar(AFilter);
  ofn.lpstrFile:=buffer;
  ofn.nMaxFile:=MAXSIZE;
  ofn.lpstrTitle:=PChar(ATitle);
  ofn.lpstrInitialDir:=PChar(ADir);
  ofn.Flags:=OFN_PATHMUSTEXIST or OFN_OVERWRITEPROMPT or
               OFN_LONGNAMES or OFN_EXPLORER or OFN_HIDEREADONLY;
  Result:=GetSaveFileName(ofn);
  e:=CommDlgExtendedError;
  if e=1 then begin
    ofn.Flags:=OFN_PATHMUSTEXIST or OFN_OVERWRITEPROMPT or
               OFN_LONGNAMES or OFN_HIDEREADONLY;
    Result:=GetSaveFileName(ofn);
    e:=CommDlgExtendedError;
  end;
  if e>0 then
    raise Exception.Create(Format('GetFileSaveDlg.CommDlgExtendedError = %x',[e]));
  Filename:=buffer;
  ADir:=ExtractFilepath(FileName);
end;

function ConcatFilters;
var
  i: Integer;
begin
  Result:='';
  for i:=0 to High(Filters) do
    Result:=Result+Copy(Filters[i],1,Length(Filters[i])-1);
end;


function ExecuteShellMessageBox(MethodPtr: Pointer; Instance: THandle; Owner: HWND; Text: Pointer; Caption: Pointer; Style: UINT; Parameters: Array of Pointer): Integer;

type
  PPointer = ^Pointer;
var
  ParamCount:  Integer;
  ParamBuffer: PChar;
  BufferIndex: Integer;
begin
  ParamCount := (High(Parameters) + 1);
  GetMem(ParamBuffer, ParamCount * SizeOf(Pointer));
  try
    for BufferIndex := 0 to High(Parameters) do begin
      PPointer(@ParamBuffer[BufferIndex * SizeOf(Pointer)])^ := Parameters[High(Parameters) - BufferIndex];
    end;
    asm
      mov ECX, ParamCount
      cmp ECX, 0
      je  @MethodCall
      mov EDX, ParamBuffer
      @StartLoop:
      push DWORD PTR[EDX]
      add  EDX, 4
      loop @StartLoop
      @MethodCall:
      push Style
      push Caption
      push Text
      push Owner
      push Instance

      call MethodPtr
      mov  Result, EAX
    end;
  finally
    FreeMem(ParamBuffer);
  end;
end;


function  ShellMessageBox(Instance: THandle; Owner: HWND; Text: PChar; Caption: PChar;
                           Style: UINT; Parameters: Array of Pointer):
          Integer; cdecl;
var
  MethodPtr:   Pointer;
  ShellDLL:    HMODULE;
begin
  ShellDLL := LoadLibrary(PChar(shell32));
  MethodPtr := GetProcAddress(ShellDLL, PChar(183));
  if (MethodPtr <> nil) then begin
    Result := ExecuteShellMessageBox(MethodPtr, Instance, Owner, Text, Caption, Style, Parameters);
  end
  else begin
    Result := ID_CANCEL;
  end;
end;

function  SHFormatDrive;           external 'shell32.dll' name 'SHFormatDrive';
procedure FreePIDL;                external 'shell32.dll' index 155;
function  SHShutDownDialog;        external 'shell32.dll' index 60;
function  SHRunDialog;             external 'shell32.dll' index 61;
function  SHChangeIcon;            external 'shell32.dll' index 62;
function  SHFindFiles;             external 'shell32.dll' index 90;
function  SHFindComputer;          external 'shell32.dll' index 91;
function  SHObjectProperties;      external 'shell32.dll' index 178;
function  SHNetConnectionDialog;   external 'shell32.dll' index 160;
function  SHOutOfMemoryMessageBox; external 'shell32.dll' index 126;
procedure SHHandleDiskFull;        external 'shell32.dll' index 185;
function  SHStartNetConnectionDialog; external 'shell32.dll' index 215 ;
function  GetOpenFileNameEx;       external 'comdlg32.dll' name 'GetOpenFileNameA';
function  GetSaveFileNameEx;       external 'comdlg32.dll' name 'GetSaveFileNameA';
procedure NewLinkHere(HWND : THandle; HInstance : THandle; CmdLine : Pchar; cmdShow : integer); stdcall; external 'appwiz.cpl' name 'NewLinkHereA';

function BrowseFolderDlg(Handle: HWND; var FolderName: string; Caption: string): boolean;
var
  BrowseInfo: TBrowseInfo;
  ItemIDList: PItemIDList;
  ItemSelected : PItemIDList;
  NameBuffer: array[0..MAX_PATH] of Char;
//  WindowList: Pointer;
begin
  StrPCopy(NameBuffer,FolderName);
  itemIDList:=nil;
  FillChar(BrowseInfo,SizeOf(BrowseInfo), 0);
  BrowseInfo.hwndOwner:=Handle;
  BrowseInfo.pidlRoot:=ItemIDList;
  BrowseInfo.pszDisplayName:=NameBuffer;
  BrowseInfo.lpszTitle:=PChar(Caption);
  BrowseInfo.ulFlags:=BIF_RETURNONLYFSDIRS;
  //WindowList:=DisableTaskWindows(0);
  try
    ItemSelected:=SHBrowseForFolder(BrowseInfo);
    Result:=ItemSelected<>nil;
  finally
    //EnableTaskWindows(WindowList);
  end;

  if Result then begin
    SHGetPathFromIDList(ItemSelected,NameBuffer);
    FolderName:=NameBuffer;
   end;
  Freepidl(BrowseInfo.pidlRoot);
end;

function ComputerNameDlg(Handle: HWND; var ComputerName: string; Caption: string): boolean;
var
  BrowseInfo: TBrowseInfo;
  ItemIDList: PItemIDList;
  NameBuffer: array[0..MAX_PATH] of Char;
//  WindowList: Pointer;
begin
  Result:=False;
  if Failed(SHGetSpecialFolderLocation(Handle,CSIDL_NETWORK,ItemIDList)) then
     Exit;
  FillChar(BrowseInfo,SizeOf(BrowseInfo), 0);
  BrowseInfo.hwndOwner:=Handle;
  BrowseInfo.pidlRoot:=ItemIDList;
  BrowseInfo.pszDisplayName:=NameBuffer;
  BrowseInfo.lpszTitle:=PChar(Caption);
  BrowseInfo.ulFlags:=BIF_BROWSEFORCOMPUTER;
  //WindowList:=DisableTaskWindows(0);
  try
    Result:=SHBrowseForFolder(BrowseInfo)<>nil;
  finally
    //EnableTaskWindows(WindowList);
    FreePidl(BrowseInfo.pidlRoot);
  end;
  if Result then
    ComputerName:=NameBuffer;
end;

procedure ControlApplet(AHandle: THandle; Applet: TControlApplet = cplAll); overload;
var
  s: string;
begin
  s:='';
  case Applet of
    cplAppWiz: s:='appwiz.cpl';
    cplTimeDate: s:='timedate.cpl';
    cplDisplay: s:='desk.cpl';
    cplMultimedia: s:='mmsys.cpl';
    cplNetwork:
      if IsNT then
        s:='ncpa.cpl'
      else
        s:='netcpl.cpl';
    cplIntl: s:='intl.cpl';
    cplSystem: s:='sysdm.cpl';
    cplHWWiz: s:='hdwwiz.cpl';
  end;
  ShellExecute(AHandle,'open','rundll32.exe',PChar('shell32.dll,Control_RunDLL '+s),nil,SW_NORMAL);
end;

procedure ControlApplet(AHandle: THandle; Applet: string = ''); overload;
begin
  ShellExecute(AHandle,'open','rundll32.exe',PChar('shell32.dll,Control_RunDLL '+ExtractShortPathName(Applet)),nil,SW_NORMAL);
end;

function ShellPropDlg(const Handle: HWND; const FileName: string): Boolean;
var
  Info: TShellExecuteInfo;
begin
  FillChar(Info,SizeOf(Info),#0);
  with Info do begin
    cbSize:=SizeOf(Info);
    lpFile:=PChar(FileName);
    nShow:=SW_SHOW;
    fMask:=SEE_MASK_INVOKEIDLIST;
    Wnd:=Handle;
    lpVerb:=PChar('properties');
  end;
  Result:=ShellExecuteEx(@Info);
end;

function RunDlg;
var
  CaptionBuffer: Pointer;
  DescriptionBuffer: Pointer;
begin
  CaptionBuffer:= nil;
  DescriptionBuffer:= nil;
  if (Caption<>'') then
    GetMem(CaptionBuffer,(Length(Caption)+1)*SizeOf(WideChar));
 if (Description<>'') then
   GetMem(DescriptionBuffer,(Length(Description)+1)*SizeOf(WideChar));
 if IsNT then begin
   if Assigned(CaptionBuffer) then
     StringToWideChar(Caption,PWideChar(CaptionBuffer),(Length(Caption)+1));
   if Assigned(DescriptionBuffer) then
     StringToWideChar(Description,PWideChar(DescriptionBuffer),(Length(Description)+1));
 end else begin
   if Assigned(CaptionBuffer) then
     StrPCopy(PChar(CaptionBuffer),Caption);
   if Assigned(DescriptionBuffer) then
     StrPCopy(PChar(DescriptionBuffer),Description);
 end;
 Result:=SHRunDialog(Handle,IconHandle,nil,CaptionBuffer,DescriptionBuffer,0)
end;

function FormatDlg;
var
  options: UINT;
  Drive: DWORD;
begin
  if (DriveChar in ['a'..'z']) then
    DriveChar:=Char(ord(DriveChar)-$20);
  if (not (DriveChar in ['A'..'Z']))then
   raise Exception.Create('Wrong drive char');
  Drive:=Ord(DriveChar)-ord('A');
  if IsNT then begin
    case FormatType of
      ftFull: options:=0;
      ftQuick: options:=SHFMT_OPT_FULL;
      else options:=0;
    end;
  end else begin
    case FormatType of
      ftFull: options:=SHFMT_OPT_FULL;
      ftQuick: options:=0;
      else options:=0;
    end;
  end;
  Result:=SHFormatDrive(Handle,Drive,SHFMT_ID_DEFAULT,Options);
end;

function FindFilesDlg: Boolean;
begin
  Result:=SHFindFiles(nil,nil);
end;

function FindComputerDlg: Boolean;
begin
  Result:=SHFindComputer(nil,nil);
end;

function ShutdownDlg;
begin
  Result:=SHShutDownDialog(Option);
end;

{$ENDIF}

end.















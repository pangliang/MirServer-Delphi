//
//           2006-11-12 多任务数据备份单元
//           叶随风飘 QQ：240621028
//


unit DataBackUp;

interface
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, INIFiles, ExtCtrls, VCLUnZip, VCLZip, ShellApi, StrUtils;
type
  TBackUpObject = class
    m_nIndex: Integer;
    m_sSourceDir: string;
    m_sDestDir: string;
    m_btBackUpMode: Byte;
    m_boBackUp: Boolean;
    m_wHour: Word;
    m_wMin: Word;
    m_boZip: Boolean;
    m_wStatus: Word;
    m_nBackUpCount: Integer;
    m_nErrorCount: Integer;
    m_dwBackUpTick: LongWord;
    m_dwBackUpTime: LongWord;
    m_dwStartBackUpTick: LongWord;
    m_TodayDate: TDateTime;
    m_BackUpFileList: TStringList;
    m_boStopSearch: Boolean;
    m_Zip: TVCLZip;
  private
    procedure DoSearchFile(path: string);
    procedure CopyFile(sSourceFile, sDestFile: string);
    function ZipFile(sDest: string): Boolean;
  public
    constructor Create();
    destructor Destroy; override;
    procedure Initialize;
    procedure Run();
  end;

  TBackUpManager = class
    m_CriticalSection: TRTLCriticalSection;
    m_BackUpList: TList;
    m_TimerStart: TTimer;
  private
    procedure TimerStartTimer(Sender: TObject);
    procedure ClearStartTick();
  public
    constructor Create();
    destructor Destroy; override;
    procedure AddObjectToList(Obj: TObject);
    function FindObject(sSource: string): TObject;
    function DeleteObject(sSource: string): Boolean;
    procedure Clear();
    procedure Run();
    procedure Start();
    procedure Stop();
    procedure Pause();
  end;
implementation
{TBackUpObject}

constructor TBackUpObject.Create();
begin
  inherited;
  m_nIndex := -1;
  m_sSourceDir := '';
  m_sDestDir := '';
  m_btBackUpMode := 0;
  m_boBackUp := True;
  m_wHour := 0;
  m_wMin := 0;
  m_boZip := True;
  m_wStatus := 0;
  m_nBackUpCount := 0; ;
  m_nErrorCount := 0;
  m_dwBackUpTick := GetTickCount;
  m_dwBackUpTime := 0;
  m_dwStartBackUpTick := GetTickCount;
  m_TodayDate := Now;
  m_BackUpFileList := TStringList.Create;
  m_boStopSearch := False;
  m_Zip := TVCLZip.Create(nil);
  m_Zip.ZipAction := zaUpdate;
  m_Zip.StorePaths := True;
  m_Zip.ZipName := '';
end;

destructor TBackUpObject.Destroy;
begin
  m_boStopSearch := True;
  Sleep(10);
  m_Zip.ClearZip;
  m_Zip.Free;
  m_BackUpFileList.Free;
  inherited;
end;

procedure TBackUpObject.Initialize;
begin

end;

procedure TBackUpObject.Run;
  function IsToday(): Boolean;
  var
    wYear1, wMonth1, wDay1: Word;
    wYear2, wMonth2, wDay2: Word;
  begin
    DecodeDate(m_TodayDate, wYear1, wMonth1, wDay1);
    DecodeDate(Now, wYear2, wMonth2, wDay2);
    Result := (wYear1 = wYear2) and (wMonth1 = wMonth2) and (wDay1 = wDay2);
  end;

  function IsBackUp(): Boolean;
  var
    wHour, wMin, wSec, wMSec: Word;
  begin
    DecodeTime(Time, wHour, wMin, wSec, wMSec);
    Result := (m_wHour = wHour) and (m_wMin = wMin);
  end;

  function DateTime_ToStr: string;
  var
    wYear, wMonth, wDay: Word;
    wHour, wMin, wSec, wMSec: Word;
  begin
    DecodeDate(Now, wYear, wMonth, wDay);
    DecodeTime(Time, wHour, wMin, wSec, wMSec);
    Result := format('%d-%d-%d.%d-%d', [wYear, wMonth, wDay, wHour, wMin]);
  end;

  function GetLastDirName: string;
  var
    TempList: TStringList;
  begin
    TempList := TStringList.Create;
    ExtractStrings(['\', '/'], [], PChar(m_sSourceDir), TempList);
    if TempList.Count > 0 then Result := TempList.Strings[TempList.Count - 1] else Result := DateTime_ToStr;
    TempList.Free;
  end;

  function GetDirName(sFileName: string): string;
  var
    s01: string;
    I: Integer;
    n01: Integer;
  begin
    Result := '';
    s01 := sFileName;
    n01 := 0;
    I := length(s01);
    while True do begin
      if I < 1 then break;
      Inc(n01);
      if s01[I] = '\' then begin
        break;
      end;
      Dec(I);
    end;
    if n01 > 0 then
      Result := Copy(s01, 1, length(s01) - n01 + 1);
  end;
var
  sDest: string;
  sLineText: string;
  sNewDir: string;
  I: Integer;
  boStartBackUp: Boolean;
begin
  try
    if not m_boBackUp then Exit;
    boStartBackUp := False;
    case m_btBackUpMode of
      0: begin
          case m_wStatus of
            0: if IsBackUp then begin
                m_wStatus := 1;
                if m_sSourceDir[length(m_sSourceDir)] <> '\' then m_sSourceDir := m_sSourceDir + '\';
                if m_sDestDir[length(m_sDestDir)] <> '\' then m_sDestDir := m_sDestDir + '\';
                m_BackUpFileList.Clear;
                DoSearchFile(m_sSourceDir);
                if m_boZip then begin
                  if m_nErrorCount < 2 then begin
                    sDest := m_sDestDir + DateTime_ToStr + '\';
                    if not DirectoryExists(sDest) then ForceDirectories(sDest); //创建目录
                    sDest := sDest + GetLastDirName + '.ZIP';
                    if not ZipFile(sDest) then Inc(m_nErrorCount);
                  end;
                end else begin
                  sDest := m_sDestDir + DateTime_ToStr + '\';
                  for I := 0 to m_BackUpFileList.Count - 1 do begin
                    if m_boStopSearch then break;
                    sLineText := m_BackUpFileList.Strings[I];
                    sLineText := AnsiReplaceText(sLineText, m_sSourceDir, sDest); //新的文件路径
                    sNewDir := GetDirName(sLineText);
                    if not DirectoryExists(sNewDir) then ForceDirectories(sNewDir); //创建目录
                    CopyFile(m_BackUpFileList.Strings[I], sLineText);
                  end;
                end;
                m_wStatus := 2;
              end;
            2: begin
                if not IsToday() then m_wStatus := 0;
                m_nErrorCount := 0;
              end;
          end;
        end;
      1: begin
          case m_wStatus of
            0: begin
                if (GetTickCount - m_dwStartBackUpTick) > (m_wHour * 60 * 60 * 1000 + m_wMin * 1000) then begin
                  m_dwStartBackUpTick := GetTickCount;
                  m_wStatus := 1;
                  if m_sSourceDir[length(m_sSourceDir)] <> '\' then m_sSourceDir := m_sSourceDir + '\';
                  if m_sDestDir[length(m_sDestDir)] <> '\' then m_sDestDir := m_sDestDir + '\';
                  m_BackUpFileList.Clear;
                  DoSearchFile(m_sSourceDir);
                  if m_boZip then begin
                    if m_nErrorCount < 2 then begin
                      sDest := m_sDestDir + DateTime_ToStr + '\';
                      if not DirectoryExists(sDest) then ForceDirectories(sDest); //创建目录
                      sDest := sDest + GetLastDirName + '.ZIP';
                      if not ZipFile(sDest) then Inc(m_nErrorCount);
                    end;
                  end else begin
                    sDest := m_sDestDir + DateTime_ToStr + '\' + GetLastDirName + '\';
                    for I := 0 to m_BackUpFileList.Count - 1 do begin
                      if m_boStopSearch then break;
                      sLineText := m_BackUpFileList.Strings[I];
                      sLineText := AnsiReplaceText(sLineText, m_sSourceDir, sDest); //新的文件路径
                      sNewDir := GetDirName(sLineText);
                      if not DirectoryExists(sNewDir) then ForceDirectories(sNewDir); //创建目录
                      CopyFile(m_BackUpFileList.Strings[I], sLineText);
                    end;
                  end;
                end;
                m_wStatus := 2;
              end;
            2: begin
                m_wStatus := 0;
                m_nErrorCount := 0;
              end;
          end;
        end;
    end;
  except

  end;
end;

procedure TBackUpObject.DoSearchFile(path: string);
var
  Info: TSearchRec;
  procedure ProcessAFile(filename: string);
  begin
    m_BackUpFileList.Add(filename);
  end;

  function IsDir: Boolean;
  begin
    with Info do
      Result := (Name <> '.') and (Name <> '..') and ((attr and fadirectory) = fadirectory);
  end;

  function IsFile: Boolean;
  begin
    Result := not ((Info.attr and fadirectory) = fadirectory);
  end;

begin
  path := IncludeTrailingBackslash(path);
  try
    if FindFirst(path + '*.*', faAnyFile, Info) = 0 then
      if IsFile then
        ProcessAFile(path + Info.Name)
      else if IsDir then DoSearchFile(path + Info.Name);
    while FindNext(Info) = 0 do begin
      if IsDir then
        DoSearchFile(path + Info.Name)
      else if IsFile then
        ProcessAFile(path + Info.Name);
      Application.ProcessMessages;
      if m_boStopSearch then break;
    end;
  finally
    FindClose(Info);
  end;
end;

procedure TBackUpObject.CopyFile(sSourceFile, sDestFile: string);
var
  ShFileOpStruct: TShFileOpStruct;
begin
  with ShFileOpStruct do begin
    wFunc := FO_COPY; {复制FO_COPY 删除FO_DELETE 移动FO_MOVE 重命名FO_RENAME}
    pFrom := PChar(sSourceFile + chr(0));
    pTo := PChar(sDestFile + chr(0));
    fFlags := FOF_NOCONFIRMATION or FOF_NOERRORUI;
  end;
  ShFileOperation(ShFileOpStruct);
end;

function TBackUpObject.ZipFile(sDest: string): Boolean;
begin
  try
    with m_Zip do begin
      ClearZip;
      ZipName := sDest;
      FilesList.Clear;
      FilesList.AddStrings(m_BackUpFileList);
      Recurse := True;
      Zip;
    end;
    Result := True;
  except
    Result := False;
  end;
end;

{TBackUpManager}

constructor TBackUpManager.Create();
begin
  inherited;
  InitializeCriticalSection(m_CriticalSection);
  m_BackUpList := TList.Create;
  m_TimerStart := TTimer.Create(nil);
  m_TimerStart.Enabled := False;
  m_TimerStart.Interval := 100;
  m_TimerStart.OnTimer := TimerStartTimer;
end;

destructor TBackUpManager.Destroy;
var
  I: Integer;
begin
  inherited;
  m_TimerStart.Enabled := False;
  for I := 0 to m_BackUpList.Count - 1 do begin
    try
      TBackUpObject(m_BackUpList.Items[I]).Free;
    except

    end;
  end;
  m_TimerStart.Free;
  m_BackUpList.Free;
  DeleteCriticalSection(m_CriticalSection);
end;

procedure TBackUpManager.AddObjectToList(Obj: TObject);
begin
  EnterCriticalSection(m_CriticalSection);
  try
    m_BackUpList.Add(Obj);
  finally
    LeaveCriticalSection(m_CriticalSection);
  end;
end;

procedure TBackUpManager.Clear;
var
  I: Integer;
begin
  EnterCriticalSection(m_CriticalSection);
  try
    for I := 0 to m_BackUpList.Count - 1 do begin
      TBackUpObject(m_BackUpList.Items[I]).Free;
    end;
    m_BackUpList.Clear;
  finally
    LeaveCriticalSection(m_CriticalSection);
  end;
end;

procedure TBackUpManager.ClearStartTick();
var
  I: Integer;
begin
  EnterCriticalSection(m_CriticalSection);
  try
    for I := 0 to m_BackUpList.Count - 1 do begin
      TBackUpObject(m_BackUpList.Items[I]).m_dwBackUpTick := GetTickCount;
    end;
  finally
    LeaveCriticalSection(m_CriticalSection);
  end;
end;

function TBackUpManager.FindObject(sSource: string): TObject;
var
  I: Integer;
begin
  Result := nil;
  EnterCriticalSection(m_CriticalSection);
  try
    for I := 0 to m_BackUpList.Count - 1 do begin
      if CompareText(TBackUpObject(m_BackUpList.Items[I]).m_sSourceDir, sSource) = 0 then begin
        Result := TBackUpObject(m_BackUpList.Items[I]);
        break;
      end;
    end;
  finally
    LeaveCriticalSection(m_CriticalSection);
  end;
end;

function TBackUpManager.DeleteObject(sSource: string): Boolean;
var
  I: Integer;
begin
  Result := False;
  EnterCriticalSection(m_CriticalSection);
  try
    for I := m_BackUpList.Count - 1 downto 0 do begin
      if CompareText(TBackUpObject(m_BackUpList.Items[I]).m_sSourceDir, sSource) = 0 then begin
        TBackUpObject(m_BackUpList.Items[I]).Free;
        m_BackUpList.Delete(I);
        Result := True;
        break;
      end;
    end;
  finally
    LeaveCriticalSection(m_CriticalSection);
  end;
end;

procedure TBackUpManager.Run;
var
  I: Integer;
begin
  EnterCriticalSection(m_CriticalSection);
  try
    for I := 0 to m_BackUpList.Count - 1 do begin
      TBackUpObject(m_BackUpList.Items[I]).Run;
    end;
  finally
    LeaveCriticalSection(m_CriticalSection);
  end;
end;

procedure TBackUpManager.TimerStartTimer(Sender: TObject);
begin
  Run;
end;

procedure TBackUpManager.Start;
begin
  ClearStartTick();
  m_TimerStart.Enabled := True;
end;

procedure TBackUpManager.Stop;
begin
  m_TimerStart.Enabled := False;
end;

procedure TBackUpManager.Pause();
begin
  if m_TimerStart.Enabled then m_TimerStart.Enabled := False
  else m_TimerStart.Enabled := True;
end;

end.

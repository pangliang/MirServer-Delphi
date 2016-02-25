unit FrnEngn;

interface

uses
  Windows, Classes, SysUtils, Grobal2, SDK;
type
  TFrontEngine = class(TThread)
    m_UserCriticalSection: TRTLCriticalSection;
    m_LoadRcdList: TList; //0x30
    m_SaveRcdList: TList; //0x34
    m_ChangeGoldList: TList; //0x38
  private
    m_LoadRcdTempList: TList;
    m_SaveRcdTempList: TList;
    procedure GetGameTime();
    procedure ProcessGameDate();
    function LoadHumFromDB(LoadUser: pTLoadDBInfo; var boReTry: Boolean): Boolean;
    function ChangeUserGoldInDB(GoldChangeInfo: pTGoldChangeInfo): Boolean;
    procedure Run();
    { Private declarations }
  protected
    procedure Execute; override;
  public
    constructor Create(CreateSuspended: Boolean);
    destructor Destroy; override;
    function SaveListCount(): Integer;
    function IsIdle(): Boolean;
    function IsFull(): Boolean;
    procedure DeleteHuman(nGateIndex, nSocket: Integer);
    function InSaveRcdList(sAccount, sChrName: string): Boolean;
    procedure AddChangeGoldList(sGameMasterName, sGetGoldUserName: string; nGold: Integer);
    procedure AddToLoadRcdList(sAccount, sChrName, sIPaddr: string; boFlag: Boolean; nSessionID: Integer; nPayMent, nPayMode, nSoftVersionDate, nSocket, nGSocketIdx, nGateIdx: Integer);
    procedure AddToSaveRcdList(SaveRcd: pTSaveRcd);
    procedure UpDataSaveRcdList(SaveRcd: pTSaveRcd);
  end;

implementation
uses
  M2Share, RunDB, ObjBase;
{ TFrontEngine }

constructor TFrontEngine.Create(CreateSuspended: Boolean);
begin
  inherited;
  InitializeCriticalSection(m_UserCriticalSection);
  m_LoadRcdList := TList.Create;
  m_SaveRcdList := TList.Create;
  m_ChangeGoldList := TList.Create;
  m_LoadRcdTempList := TList.Create;
  m_SaveRcdTempList := TList.Create;
  //  FreeOnTerminate:=True;
  //AddToProcTable(@TFrontEngine.ProcessGameDate, 'TFrontEngine.ProcessGameDatea');
end;

destructor TFrontEngine.Destroy;
begin
  m_LoadRcdList.Free;
  m_SaveRcdList.Free;
  m_ChangeGoldList.Free;
  m_LoadRcdTempList.Free;
  m_SaveRcdTempList.Free;
  DeleteCriticalSection(m_UserCriticalSection);
  inherited;
end;
//004B5148
procedure TFrontEngine.Execute;
resourcestring
  sExceptionMsg = '[Exception] TFrontEngine::Execute';
begin
  while not Terminated do begin
    try
      Run();
    except
      MainOutMessage(sExceptionMsg);
    end;
    Sleep(1);
  end;
end;

procedure TFrontEngine.GetGameTime; //004B50AC
var
  Hour, Min, Sec, MSec: Word;
begin
  DecodeTime(Time, Hour, Min, Sec, MSec);
  case Hour of
    5, 6, 7, 8, 9, 10, 16, 17, 18, 19, 20, 21, 22: g_nGameTime := 1;
    11, 23: g_nGameTime := 2;
    4, 15: g_nGameTime := 0;
    0, 1, 2, 3, 12, 13, 14: g_nGameTime := 3;
  end;
end;

function TFrontEngine.IsIdle: Boolean;
begin
  Result := False;
  EnterCriticalSection(m_UserCriticalSection);
  try
    if m_SaveRcdList.Count = 0 then Result := True;
  finally
    LeaveCriticalSection(m_UserCriticalSection);
  end;
end;

function TFrontEngine.SaveListCount: Integer;
begin
  Result := 0;
  EnterCriticalSection(m_UserCriticalSection);
  try
    Result := m_SaveRcdList.Count;
  finally
    LeaveCriticalSection(m_UserCriticalSection);
  end;
end;

procedure TFrontEngine.ProcessGameDate;
var
  I: Integer;
  II: Integer;
  TempList: TList;
  ChangeGoldList: TList;
  LoadDBInfo: pTLoadDBInfo;
  SaveRcd: pTSaveRcd;
  GoldChangeInfo: pTGoldChangeInfo;
  boReTryLoadDB: Boolean;
  boSaveRcd: Boolean;
begin
  ChangeGoldList := nil;
  EnterCriticalSection(m_UserCriticalSection);
  try
    for I := 0 to m_SaveRcdList.Count - 1 do begin
      m_SaveRcdTempList.Add(m_SaveRcdList.Items[I]);
    end;

    TempList := m_LoadRcdTempList;
    m_LoadRcdTempList := m_LoadRcdList;
    m_LoadRcdList := TempList;

    if m_ChangeGoldList.Count > 0 then begin
      ChangeGoldList := TList.Create;
      for I := 0 to m_ChangeGoldList.Count - 1 do begin
        ChangeGoldList.Add(m_ChangeGoldList.Items[I]);
      end;
    end;
    m_ChangeGoldList.Clear;
  finally
    LeaveCriticalSection(m_UserCriticalSection);
  end;

  for I := 0 to m_SaveRcdTempList.Count - 1 do begin
    SaveRcd := m_SaveRcdTempList.Items[I];
    if SaveRcd = nil then Continue;

    if not DBSocketConnected then begin //DBS关闭 不保存
      if SaveRcd.PlayObject <> nil then begin
        TPlayObject(SaveRcd.PlayObject).m_boRcdSaved := True;
      end;
      EnterCriticalSection(m_UserCriticalSection);
      try
        for II := 0 to m_SaveRcdList.Count - 1 do begin
          if m_SaveRcdList.Items[II] = SaveRcd then begin
            m_SaveRcdList.Delete(II);
            Dispose(SaveRcd);
            break;
          end;
        end;
      finally
        LeaveCriticalSection(m_UserCriticalSection);
      end;
    end else begin
      boSaveRcd := False;
      if SaveRcd.nReTryCount = 0 then begin
        boSaveRcd := True;
      end else
      if (SaveRcd.nReTryCount < 50) and (GetTickCount - SaveRcd.dwSaveTick > 5000) then begin //保存错误等待5秒后在保存
        boSaveRcd := True;
      end else
      if SaveRcd.nReTryCount >= 50 then begin //失败50次后不在保存
        if SaveRcd.PlayObject <> nil then begin
          TPlayObject(SaveRcd.PlayObject).m_boRcdSaved := True;
        end;
        EnterCriticalSection(m_UserCriticalSection);
        try
          for II := 0 to m_SaveRcdList.Count - 1 do begin
            if m_SaveRcdList.Items[II] = SaveRcd then begin
              m_SaveRcdList.Delete(II);
              Dispose(SaveRcd);
              break;
            end;
          end;
        finally
          LeaveCriticalSection(m_UserCriticalSection);
        end;
      end;

      if boSaveRcd then begin
        if SaveHumRcdToDB(SaveRcd.sAccount, SaveRcd.sChrName, SaveRcd.nSessionID, SaveRcd.HumanRcd) then begin
          if SaveRcd.PlayObject <> nil then begin
            TPlayObject(SaveRcd.PlayObject).m_boRcdSaved := True;
          end;
          EnterCriticalSection(m_UserCriticalSection);
          try
            for II := 0 to m_SaveRcdList.Count - 1 do begin
              if m_SaveRcdList.Items[II] = SaveRcd then begin
                m_SaveRcdList.Delete(II);
                Dispose(SaveRcd);
                break;
              end;
            end;
          finally
            LeaveCriticalSection(m_UserCriticalSection);
          end;
        end else begin //保存失败
          Inc(SaveRcd.nReTryCount);
          SaveRcd.dwSaveTick := GetTickCount;
        end;
      end;
    end;
  end;
  m_SaveRcdTempList.Clear;

  for I := 0 to m_LoadRcdTempList.Count - 1 do begin
    LoadDBInfo := m_LoadRcdTempList.Items[I];
    if not LoadHumFromDB(LoadDBInfo, boReTryLoadDB) then
      RunSocket.CloseUser(LoadDBInfo.nGateIdx, LoadDBInfo.nSocket);
    if not boReTryLoadDB then begin
      Dispose(LoadDBInfo);
    end else begin //如果读取人物数据失败(数据还没有保存),则重新加入队列
      EnterCriticalSection(m_UserCriticalSection);
      try
        m_LoadRcdList.Add(LoadDBInfo);
      finally
        LeaveCriticalSection(m_UserCriticalSection);
      end;
    end;
  end;
  m_LoadRcdTempList.Clear;

  if ChangeGoldList <> nil then begin
    for I := 0 to ChangeGoldList.Count - 1 do begin
      GoldChangeInfo := ChangeGoldList.Items[I];
      ChangeUserGoldInDB(GoldChangeInfo);
      Dispose(GoldChangeInfo);
    end;
    ChangeGoldList.Free;
  end;
end;

function TFrontEngine.IsFull: Boolean;
begin
  Result := False;
  EnterCriticalSection(m_UserCriticalSection);
  try
    if m_SaveRcdList.Count >= 2000 then begin
      Result := True;
    end;
  finally
    LeaveCriticalSection(m_UserCriticalSection);
  end;
end;

procedure TFrontEngine.AddToLoadRcdList(sAccount, sChrName, sIPaddr: string;
  boFlag: Boolean; nSessionID, nPayMent, nPayMode, nSoftVersionDate, nSocket, nGSocketIdx, nGateIdx: Integer);
var
  LoadRcdInfo: pTLoadDBInfo;
begin
  New(LoadRcdInfo);
  LoadRcdInfo.sAccount := sAccount;
  LoadRcdInfo.sCharName := sChrName;
  LoadRcdInfo.sIPaddr := sIPaddr;
  //LoadRcdInfo.boClinetFlag     := boFlag;
  LoadRcdInfo.nSessionID := nSessionID;
  LoadRcdInfo.nSoftVersionDate := nSoftVersionDate;
  LoadRcdInfo.nPayMent := nPayMent;
  LoadRcdInfo.nPayMode := nPayMode;
  LoadRcdInfo.nSocket := nSocket;
  LoadRcdInfo.nGSocketIdx := nGSocketIdx;
  LoadRcdInfo.nGateIdx := nGateIdx;
  LoadRcdInfo.dwNewUserTick := GetTickCount();
  LoadRcdInfo.PlayObject := nil;
  LoadRcdInfo.nReLoadCount := 0;

  EnterCriticalSection(m_UserCriticalSection);
  try
    m_LoadRcdList.Add(LoadRcdInfo);
  finally
    LeaveCriticalSection(m_UserCriticalSection);
  end;
end;

function TFrontEngine.LoadHumFromDB(LoadUser: pTLoadDBInfo; var boReTry: Boolean): Boolean; //004B4B10
var
  HumanRcd: THumDataInfo;
  UserOpenInfo: pTUserOpenInfo;
  PlayObject: TPlayObject;
resourcestring
  sReLoginFailMsg = '[非法登录] 全局会话验证失败(%s/%s/%s/%d)';
begin
  Result := False;
  boReTry := False;
  if InSaveRcdList(LoadUser.sAccount, LoadUser.sCharName) then begin
    boReTry := True; //反回TRUE,则重新加入队列
    Exit;
  end;
  if (UserEngine.GetPlayObjectEx(LoadUser.sAccount, LoadUser.sCharName) <> nil) then begin
    UserEngine.KickPlayObjectEx(LoadUser.sAccount, LoadUser.sCharName);
    boReTry := True; //反回TRUE,则重新加入队列
    Exit;
  end;
  if not LoadHumRcdFromDB(LoadUser.sAccount, LoadUser.sCharName, LoadUser.sIPaddr, HumanRcd, LoadUser.nSessionID) then begin
    RunSocket.SendOutConnectMsg(LoadUser.nGateIdx, LoadUser.nSocket, LoadUser.nGSocketIdx);
  end else begin
    New(UserOpenInfo);
    UserOpenInfo.sAccount := LoadUser.sAccount;
    UserOpenInfo.sChrName := LoadUser.sCharName;
    UserOpenInfo.LoadUser := LoadUser^;
    UserOpenInfo.HumanRcd := HumanRcd;
    UserEngine.AddUserOpenInfo(UserOpenInfo);
    Result := True;
  end;
end;

function TFrontEngine.InSaveRcdList(sAccount, sChrName: string): Boolean;
var
  I: Integer;
begin
  Result := False;
  EnterCriticalSection(m_UserCriticalSection);
  try
    for I := 0 to m_SaveRcdList.Count - 1 do begin
      if (pTSaveRcd(m_SaveRcdList.Items[I]).sAccount = sAccount) and
        (pTSaveRcd(m_SaveRcdList.Items[I]).sChrName = sChrName) then begin
        Result := True;
        break;
      end;
    end;
  finally
    LeaveCriticalSection(m_UserCriticalSection);
  end;
end;

procedure TFrontEngine.AddChangeGoldList(sGameMasterName, sGetGoldUserName: string;
  nGold: Integer);
var
  GoldInfo: pTGoldChangeInfo;
begin
  New(GoldInfo);
  GoldInfo.sGameMasterName := sGameMasterName;
  GoldInfo.sGetGoldUser := sGetGoldUserName;
  GoldInfo.nGold := nGold;
  m_ChangeGoldList.Add(GoldInfo);
end;

procedure TFrontEngine.AddToSaveRcdList(SaveRcd: pTSaveRcd);
begin
  EnterCriticalSection(m_UserCriticalSection);
  try
    m_SaveRcdList.Add(SaveRcd);
  finally
    LeaveCriticalSection(m_UserCriticalSection);
  end;
end;

procedure TFrontEngine.UpDataSaveRcdList(SaveRcd: pTSaveRcd); //2005-11-12 增加
var
  I: Integer;
  pSaveRcd: pTSaveRcd;
begin
  EnterCriticalSection(m_UserCriticalSection);
  try
    for I := m_SaveRcdList.Count - 1 downto 0 do begin
      pSaveRcd := pTSaveRcd(m_SaveRcdList.Items[I]);
      if (pSaveRcd.sAccount = SaveRcd.sAccount) and
        (pSaveRcd.sChrName = SaveRcd.sChrName) then begin
        SaveRcd.nReTryCount := pSaveRcd.nReTryCount;
        SaveRcd.dwSaveTick := pSaveRcd.dwSaveTick;
        m_SaveRcdList.Delete(I);
        Dispose(pSaveRcd);
        break;
      end;
    end;
    m_SaveRcdList.Add(SaveRcd);
  finally
    LeaveCriticalSection(m_UserCriticalSection);
  end;
end;

procedure TFrontEngine.DeleteHuman(nGateIndex, nSocket: Integer);
var
  I: Integer;
  LoadRcdInfo: pTLoadDBInfo;
begin
  EnterCriticalSection(m_UserCriticalSection);
  try
    for I := m_LoadRcdList.Count - 1 downto 0 do begin
      if m_LoadRcdList.Count <= 0 then break;
      LoadRcdInfo := m_LoadRcdList.Items[I];
      if LoadRcdInfo = nil then Continue;
      if (LoadRcdInfo.nGateIdx = nGateIndex) and (LoadRcdInfo.nSocket = nSocket) then begin
        m_LoadRcdList.Delete(I);
        Dispose(LoadRcdInfo);
        break;
      end;
    end;
  finally
    LeaveCriticalSection(m_UserCriticalSection);
  end;
end;

function TFrontEngine.ChangeUserGoldInDB(GoldChangeInfo: pTGoldChangeInfo): Boolean;
var
  HumanRcd: THumDataInfo;
begin
  Result := False;
  if LoadHumRcdFromDB('1', GoldChangeInfo.sGetGoldUser, '1', HumanRcd, 1) then begin
    if ((HumanRcd.Data.nGold + GoldChangeInfo.nGold) > 0) and ((HumanRcd.Data.nGold + GoldChangeInfo.nGold) < 2000000000) then begin
      Inc(HumanRcd.Data.nGold, GoldChangeInfo.nGold);
      if SaveHumRcdToDB('1', GoldChangeInfo.sGetGoldUser, 1, HumanRcd) then begin
        UserEngine.sub_4AE514(GoldChangeInfo);
        Result := True;
      end;
    end;
  end;
end;

procedure TFrontEngine.Run;
begin
  ProcessGameDate();
  GetGameTime();
end;

end.


unit UsrSoc;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, WinSock, Common,
  Controls, Forms, Dialogs, StdCtrls, ExtCtrls, JSocket, SyncObjs, IniFiles, Grobal2, DBShare;
type
  TFrmUserSoc = class(TForm)
    UserSocket: TServerSocket;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure UserSocketClientConnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure UserSocketClientDisconnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure UserSocketClientError(Sender: TObject;
      Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
      var ErrorCode: Integer);
    procedure UserSocketClientRead(Sender: TObject;
      Socket: TCustomWinSocket);
  private
    CS_GateSession: TCriticalSection;
    n2DC: Integer;
    n2E0: Integer;
    n2E4: Integer;
    GateList: TList;
    CurGate: pTGateInfo;
    MapList: TStringList;

    function LoadChrNameList(sFileName: string): Boolean;
    function LoadClearMakeIndexList(sFileName: string): Boolean;
    procedure ProcessGateMsg(var GateInfo: pTGateInfo);
    procedure SendKeepAlivePacket(Socket: TCustomWinSocket);
    procedure ProcessUserMsg(var UserInfo: pTUserInfo);
    procedure CloseUser(sID: string; var GateInfo: pTGateInfo);
    procedure OpenUser(sID, sIP: string; var GateInfo: pTGateInfo);
    procedure DeCodeUserMsg(sData: string; var UserInfo: pTUserInfo);
    function QueryChr(sData: string; var UserInfo: pTUserInfo): Boolean;
    procedure DelChr(sData: string; var UserInfo: pTUserInfo);
    procedure OutOfConnect(const UserInfo: pTUserInfo);
    procedure NewChr(sData: string; var UserInfo: pTUserInfo);
    function SelectChr(sData: string; var UserInfo: pTUserInfo): Boolean;
    procedure SendUserSocket(Socket: TCustomWinSocket; sSessionID,
      sSendMsg: string);
    function GetMapIndex(sMap: string): Integer;

    function GateRoutePort(sGateIP: string): Integer;
    function CheckDenyChrName(sChrName: string): Boolean;

    { Private declarations }
  public
    function GateRouteIP(sGateIP: string; var nPort: Integer): string;
    procedure LoadServerInfo();
    function NewChrData(sChrName: string; nSex, nJob, nHair: Integer): Boolean;
    function GetUserCount(): Integer;
    procedure SendKickUser(Socket: TCustomWinSocket; SocketHandle: string; nKickType: Integer);
    { Public declarations }
  end;

var
  FrmUserSoc: TFrmUserSoc;

implementation

uses HumDB, HUtil32, IDSocCli, EDcode, MudUtil, DBSMain;

{$R *.DFM}

procedure TFrmUserSoc.UserSocketClientConnect(Sender: TObject;
  Socket: TCustomWinSocket);
var
  GateInfo: pTGateInfo;
  sIPaddr: string;
begin
  sIPaddr := Socket.RemoteAddress;
  if not CheckServerIP(sIPaddr) then begin
    MainOutMessage('非法网关连接: ' + sIPaddr);
    Socket.Close;
    Exit;
  end;
  UserSocketClientConnected := True;
  User_sRemoteAddress := sIPaddr;
  User_nRemotePort := Socket.RemotePort;
  if not boOpenDBBusy then begin
    New(GateInfo);
    GateInfo.Socket := Socket;
    GateInfo.sGateaddr := sIPaddr;
    GateInfo.sText := '';
    GateInfo.UserList := TList.Create;
    GateInfo.dwTick10 := GetTickCount();
    //GateInfo.nGateID   := GetGateID(sIPaddr);
    CS_GateSession.Enter;
    try
      GateList.Add(GateInfo);
    finally
      CS_GateSession.Leave;
    end;
  end else begin
    Socket.Close;
  end;
end;

procedure TFrmUserSoc.UserSocketClientDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
var
  i, ii: Integer;
  GateInfo: pTGateInfo;
  UserInfo: pTUserInfo;
begin
  CS_GateSession.Enter;
  try
    {User_sRemoteAddress:='';
    User_nRemotePort:=0;
    UserSocketClientConnected:=FALSE;}
    for i := 0 to GateList.Count - 1 do begin
      GateInfo := GateList.Items[i];
      if GateInfo <> nil then begin
        for ii := 0 to GateInfo.UserList.Count - 1 do begin
          UserInfo := GateInfo.UserList.Items[ii];
          Dispose(UserInfo);
        end;
        GateInfo.UserList.Free;
      end;
      GateList.Delete(i);
      break;
    end;
  finally
    CS_GateSession.Leave;
  end;
end;

procedure TFrmUserSoc.UserSocketClientError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
  ErrorCode := 0;
  Socket.Close;
  User_sRemoteAddress := '';
  User_nRemotePort := 0;
  UserSocketClientConnected := False;
end;

procedure TFrmUserSoc.UserSocketClientRead(Sender: TObject;
  Socket: TCustomWinSocket);
var
  i: Integer;
  sReviceMsg: string;
  GateInfo: pTGateInfo;
begin
  CS_GateSession.Enter;
  try
    for i := 0 to GateList.Count - 1 do begin
      GateInfo := GateList.Items[i];
      if GateInfo.Socket = Socket then begin
        CurGate := GateInfo;
        sReviceMsg := Socket.ReceiveText;
        GateInfo.sText := GateInfo.sText + sReviceMsg;
        if Length(GateInfo.sText) < 81920 then begin
          if Pos('$', GateInfo.sText) >= 1 then begin
            ProcessGateMsg(GateInfo);
          end;
        end else begin
          GateInfo.sText := '';
        end;
      end;
    end;
  finally
    CS_GateSession.Leave;
  end;
end;

procedure TFrmUserSoc.FormCreate(Sender: TObject);
begin
  CS_GateSession := TCriticalSection.Create;
  GateList := TList.Create;
  MapList := TStringList.Create;
  UserSocket.Port := g_nGatePort;
  UserSocket.Address := g_sGateAddr;
  UserSocket.Active := True;
  LoadServerInfo();
  LoadChrNameList('DenyChrName.txt');
  LoadClearMakeIndexList('ClearMakeIndex.txt');
end;

procedure TFrmUserSoc.FormDestroy(Sender: TObject);
var
  i, ii: Integer;
  GateInfo: pTGateInfo;
  UserInfo: pTUserInfo;
begin
  for i := 0 to GateList.Count - 1 do begin
    GateInfo := GateList.Items[i];
    if GateInfo <> nil then begin
      for ii := 0 to GateInfo.UserList.Count - 1 do begin
        UserInfo := GateInfo.UserList.Items[ii];
        Dispose(UserInfo);
      end;
      GateInfo.UserList.Free;
    end;
    GateList.Delete(i);
    break;
  end;
  GateList.Free;
  MapList.Free;
  CS_GateSession.Free;
end;

procedure TFrmUserSoc.Timer1Timer(Sender: TObject);
var
  n8: Integer;
begin
  n8 := g_nQueryChrCount + nHackerNewChrCount + nHackerDelChrCount + nHackerSelChrCount + n4ADC1C + n4ADC20 + n4ADC24 + n4ADC28;
  if n4ADBB8 <> n8 then begin
    n4ADBB8 := n8;
    MainOutMessage('H-QyChr=' + IntToStr(g_nQueryChrCount) + ' ' +
      'H-NwChr=' + IntToStr(nHackerNewChrCount) + ' ' +
      'H-DlChr=' + IntToStr(nHackerDelChrCount) + ' ' +
      'Dubl-Sl=' + IntToStr(nHackerSelChrCount) + ' ' +
      'H-Er-P1=' + IntToStr(n4ADC1C) + ' ' +
      'Dubl-P2=' + IntToStr(n4ADC20) + ' ' +
      'Dubl-P3=' + IntToStr(n4ADC24) + ' ' +
      'Dubl-P4=' + IntToStr(n4ADC28));
  end;
end;

function TFrmUserSoc.GetUserCount(): Integer;
var
  i: Integer;
  GateInfo: pTGateInfo;
  nUserCount: Integer;
begin
  nUserCount := 0;
  CS_GateSession.Enter;
  try
    for i := 0 to GateList.Count - 1 do begin
      GateInfo := GateList.Items[i];
      Inc(nUserCount, GateInfo.UserList.Count);
    end;
  finally
    CS_GateSession.Leave;
  end;
  Result := nUserCount;
end;

function TFrmUserSoc.NewChrData(sChrName: string; nSex, nJob, nHair: Integer): Boolean;
var
  ChrRecord: THumDataInfo;
begin
  Result := False;
  try
    if HumDataDB.Open and (HumDataDB.Index(sChrName) = -1) then begin
      FillChar(ChrRecord, SizeOf(THumDataInfo), #0);
      ChrRecord.Header.sName := sChrName;
      ChrRecord.Data.sChrName := sChrName;
      ChrRecord.Data.btSex := nSex;
      ChrRecord.Data.btJob := nJob;
      ChrRecord.Data.btHair := nHair;
      HumDataDB.Add(ChrRecord);
      Result := True;
    end;
  finally
    HumDataDB.Close;
  end;
end;

procedure TFrmUserSoc.LoadServerInfo;
var
  i: Integer;
  LoadList: TStringList;
  nRouteIdx, nGateIdx, nServerIndex: Integer;
  sLineText, sSelGateIPaddr, sGameGateIPaddr, sGameGate, sGameGatePort, sMapName, sMapInfo, sServerIndex: string;
  Conf: TIniFile;
begin
  try
    LoadList := TStringList.Create;
    FillChar(g_RouteInfo, SizeOf(g_RouteInfo), #0);
    LoadList.LoadFromFile(sGateConfFileName);
    nRouteIdx := 0;
    nGateIdx := 0;
    for i := 0 to LoadList.Count - 1 do begin
      sLineText := Trim(LoadList.Strings[i]);
      if (sLineText <> '') and (sLineText[1] <> ';') then begin
        sGameGate := GetValidStr3(sLineText, sSelGateIPaddr, [' ', #9]);
        if (sGameGate = '') or (sSelGateIPaddr = '') then Continue;
        g_RouteInfo[nRouteIdx].sSelGateIP := Trim(sSelGateIPaddr);
        g_RouteInfo[nRouteIdx].nGateCount := 0;
        nGateIdx := 0;
        while (sGameGate <> '') do begin
          sGameGate := GetValidStr3(sGameGate, sGameGateIPaddr, [' ', #9]);
          sGameGate := GetValidStr3(sGameGate, sGameGatePort, [' ', #9]);
          g_RouteInfo[nRouteIdx].sGameGateIP[nGateIdx] := Trim(sGameGateIPaddr);
          g_RouteInfo[nRouteIdx].nGameGatePort[nGateIdx] := Str_ToInt(sGameGatePort, 0);
          Inc(nGateIdx);
        end;
        g_RouteInfo[nRouteIdx].nGateCount := nGateIdx;
        Inc(nRouteIdx);
      end;
    end;
    Conf := TIniFile.Create(sConfFileName);
    sMapFile := Conf.ReadString('Setup', 'MapFile', sMapFile);
    Conf.Free;
    MapList.Clear;
    if FileExists(sMapFile) then begin
      LoadList.Clear;
      LoadList.LoadFromFile(sMapFile);
      for i := 0 to LoadList.Count - 1 do begin
        sLineText := LoadList.Strings[i];
        if (sLineText <> '') and (sLineText[1] = '[') then begin
          sLineText := ArrestStringEx(sLineText, '[', ']', sMapName);
          sMapInfo := GetValidStr3(sMapName, sMapName, [#32, #9]);
          sServerIndex := Trim(GetValidStr3(sMapInfo, sMapInfo, [#32, #9]));
          nServerIndex := Str_ToInt(sServerIndex, 0);
          MapList.AddObject(sMapName, TObject(nServerIndex));
        end;
      end;
    end;
    LoadList.Free;
  finally
  end;
end;

function TFrmUserSoc.LoadChrNameList(sFileName: string): Boolean;
var
  i: Integer;
begin
  Result := False;
  if FileExists(sFileName) then begin
    DenyChrNameList.LoadFromFile(sFileName);
    i := 0;
    while (True) do begin
      if DenyChrNameList.Count <= i then break;
      if Trim(DenyChrNameList.Strings[i]) = '' then begin
        DenyChrNameList.Delete(i);
        Continue;
      end;
      Inc(i);
    end;
    Result := True;
  end;
end;

function TFrmUserSoc.LoadClearMakeIndexList(sFileName: string): Boolean;
var
  i: Integer;
  nIndex: Integer;
  sLineText: string;
begin
  Result := False;
  if FileExists(sFileName) then begin
    g_ClearMakeIndex.LoadFromFile(sFileName);
    i := 0;
    while (True) do begin
      if g_ClearMakeIndex.Count <= i then break;
      sLineText := g_ClearMakeIndex.Strings[i];
      nIndex := Str_ToInt(sLineText, -1);
      if nIndex < 0 then begin
        g_ClearMakeIndex.Delete(i);
        Continue;
      end;
      g_ClearMakeIndex.Objects[i] := TObject(nIndex);
      Inc(i);
    end;
    Result := True;
  end;
end;

procedure TFrmUserSoc.ProcessGateMsg(var GateInfo: pTGateInfo);
var
  s0C: string;
  s10: string;
  s19: Char;
  i: Integer;
  UserInfo: pTUserInfo;
  nCount: Integer;
begin
  nCount := 0;
  while True do begin
    if Pos('$', GateInfo.sText) <= 0 then break;
    GateInfo.sText := ArrestStringEx(GateInfo.sText, '%', '$', s10);
    //%O308/127.0.0.1/127.0.0.1$
    //%A308/#2<<<<<BL<<<<<<<<<H?<lH>xq!$
    if s10 <> '' then begin
      s19 := s10[1];
      s10 := Copy(s10, 2, Length(s10) - 1);
      //s19:=UpperCase(s19);
      case s19 of
        '-': begin
            SendKeepAlivePacket(GateInfo.Socket);
            dwKeepAliveTick := GetTickCount();
          end;
        'D': begin
            s10 := GetValidStr3(s10, s0C, ['/']);
            for i := 0 to GateInfo.UserList.Count - 1 do begin
              UserInfo := GateInfo.UserList.Items[i];
              if UserInfo <> nil then begin
                if UserInfo.sConnID = s0C then begin
                  UserInfo.s2C := UserInfo.s2C + s10;
                  if Pos('!', s10) < 1 then Continue;
                  ProcessUserMsg(UserInfo);
                  break;
                end;
              end;
            end;
          end;
        'N': begin
            s10 := GetValidStr3(s10, s0C, ['/']);
            OpenUser(s0C, s10, GateInfo);
          end;
        'C': begin
            CloseUser(s10, GateInfo);
          end;
        else begin
            if nCount >= 1 then begin //2006-10-12 防止DBS溢出攻击
              GateInfo.sText := '';
              break;
            end;
            Inc(nCount);
          end;
      end;
    end;
  end;
end;

procedure TFrmUserSoc.SendKeepAlivePacket(Socket: TCustomWinSocket);
begin
  if Socket.Connected then
    Socket.SendText('%++$');
end;

procedure TFrmUserSoc.SendKickUser(Socket: TCustomWinSocket; SocketHandle: string; nKickType: Integer);
begin
  if (Socket <> nil) and Socket.Connected then begin
    case nKickType of
      0: Socket.SendText('%+-' + SocketHandle + '$');
      1: Socket.SendText('%+T' + SocketHandle + '$');
      2: Socket.SendText('%+B' + SocketHandle + '$');
    end;
  end;
end;

procedure TFrmUserSoc.ProcessUserMsg(var UserInfo: pTUserInfo);
var
  s10: string;
  nC: Integer;
  nLoopCount: Integer;
begin
  nC := 0;
  nLoopCount := 0;
  while (True) do begin
    if nLoopCount > 10 then break;
    if TagCount(UserInfo.s2C, '!') <= 0 then break;
    UserInfo.s2C := ArrestStringEx(UserInfo.s2C, '#', '!', s10);
    if s10 <> '' then begin
      s10 := Copy(s10, 2, Length(s10) - 1);
      if Length(s10) >= DEFBLOCKSIZE then begin
        DeCodeUserMsg(s10, UserInfo);
      end else Inc(n4ADC20);
    end else begin
      Inc(n4ADC1C);
      if nC >= 1 then begin
        UserInfo.s2C := '';
      end;
      Inc(nC);
    end;
    Inc(nLoopCount);
  end;
end;

procedure TFrmUserSoc.OpenUser(sID, sIP: string; var GateInfo: pTGateInfo);
var
  i: Integer;
  UserInfo: pTUserInfo;
  sUserIPaddr: string;
  sGateIPaddr: string;
begin
  sGateIPaddr := GetValidStr3(sIP, sUserIPaddr, ['/']);
  for i := 0 to GateInfo.UserList.Count - 1 do begin
    UserInfo := GateInfo.UserList.Items[i];
    if (UserInfo <> nil) and (UserInfo.sConnID = sID) then begin
      Exit;
    end;
  end;
  New(UserInfo);
  UserInfo.sAccount := '';
  UserInfo.sUserIPaddr := sUserIPaddr;
  UserInfo.sGateIPaddr := sGateIPaddr;
  UserInfo.sConnID := sID;
  UserInfo.nSessionID := 0;
  UserInfo.Socket := GateInfo.Socket;
  UserInfo.s2C := '';
  UserInfo.dwTick34 := GetTickCount();
  UserInfo.dwChrTick := GetTickCount();
  UserInfo.boChrSelected := False;
  UserInfo.boChrQueryed := False;
  UserInfo.nSelGateID := GateInfo.nGateID;
  UserInfo.nDataCount := 0;
  GateInfo.UserList.Add(UserInfo);
end;

procedure TFrmUserSoc.CloseUser(sID: string; var GateInfo: pTGateInfo);
var
  i: Integer;
  UserInfo: pTUserInfo;
begin
  for i := 0 to GateInfo.UserList.Count - 1 do begin
    UserInfo := GateInfo.UserList.Items[i];
    if (UserInfo <> nil) and (UserInfo.sConnID = sID) then begin
      if not FrmIDSoc.GetGlobaSessionStatus(UserInfo.nSessionID) then begin
        FrmIDSoc.SendSocketMsg(SS_SOFTOUTSESSION, UserInfo.sAccount + '/' + IntToStr(UserInfo.nSessionID));
        FrmIDSoc.CloseSession(UserInfo.sAccount, UserInfo.nSessionID);
      end;
      Dispose(UserInfo);
      GateInfo.UserList.Delete(i);
      break;
    end;
  end;
end;

procedure TFrmUserSoc.DeCodeUserMsg(sData: string;
  var UserInfo: pTUserInfo);
var
  sDefMsg, s18: string;
  Msg: TDefaultMessage;
begin
  sDefMsg := Copy(sData, 1, DEFBLOCKSIZE);
  s18 := Copy(sData, DEFBLOCKSIZE + 1, Length(sData) - DEFBLOCKSIZE);
  Msg := DecodeMessage(sDefMsg);
  case Msg.Ident of
    CM_QUERYCHR: begin
        if not UserInfo.boChrQueryed or ((GetTickCount - UserInfo.dwChrTick) > 200) then begin
          UserInfo.dwChrTick := GetTickCount();
          if QueryChr(s18, UserInfo) then begin
            UserInfo.boChrQueryed := True;
          end;
        end else begin
          if boAttack and AddAttackIP(UserInfo.sUserIPaddr) then SendKickUser(UserInfo.Socket, UserInfo.sConnID, 0);
          Inc(g_nQueryChrCount);
          MainOutMessage('[超速操作] 查询人物 ' + UserInfo.sUserIPaddr);
        end;
      end;
    CM_NEWCHR: begin
        if (GetTickCount - UserInfo.dwChrTick) > 1000 then begin
          UserInfo.dwChrTick := GetTickCount();
          if (UserInfo.sAccount <> '')
            and FrmIDSoc.CheckSession(UserInfo.sAccount, UserInfo.sUserIPaddr, UserInfo.nSessionID) then begin
            NewChr(s18, UserInfo);
            UserInfo.boChrQueryed := False;
          end else begin
            OutOfConnect(UserInfo);
          end;
        end else begin
          if boAttack and AddAttackIP(UserInfo.sUserIPaddr) then SendKickUser(UserInfo.Socket, UserInfo.sConnID, 1);
          Inc(nHackerNewChrCount);
          MainOutMessage('[超速操作] 创建人物 ' + UserInfo.sAccount + '/' + UserInfo.sUserIPaddr);
        end;
      end;
    CM_DELCHR: begin
        if (GetTickCount - UserInfo.dwChrTick) > 1000 then begin
          UserInfo.dwChrTick := GetTickCount();
          if (UserInfo.sAccount <> '')
            and FrmIDSoc.CheckSession(UserInfo.sAccount, UserInfo.sUserIPaddr, UserInfo.nSessionID) then begin
            DelChr(s18, UserInfo);
            UserInfo.boChrQueryed := False;
          end else begin
            OutOfConnect(UserInfo);
          end;
        end else begin
          if boAttack and AddAttackIP(UserInfo.sUserIPaddr) then SendKickUser(UserInfo.Socket, UserInfo.sConnID, 0);
          Inc(nHackerDelChrCount);
          MainOutMessage('[超速操作] 删除人物' + UserInfo.sAccount + '/' + UserInfo.sUserIPaddr);
        end;
      end;
    CM_SELCHR: begin
        if not UserInfo.boChrQueryed then begin
          if (UserInfo.sAccount <> '')
            and FrmIDSoc.CheckSession(UserInfo.sAccount, UserInfo.sUserIPaddr, UserInfo.nSessionID) then begin
            if SelectChr(s18, UserInfo) then begin
              UserInfo.boChrSelected := True;
            end;
          end else begin
            OutOfConnect(UserInfo);
          end;
        end else begin
          if boAttack and AddAttackIP(UserInfo.sUserIPaddr) then SendKickUser(UserInfo.Socket, UserInfo.sConnID, 1);
          Inc(nHackerSelChrCount);
          MainOutMessage('[端口攻击]' + UserInfo.sAccount + '/' + UserInfo.sUserIPaddr);
        end;
      end;
    else begin
        Inc(n4ADC24);
      end;
  end;
end;

function TFrmUserSoc.QueryChr(sData: string; var UserInfo: pTUserInfo): Boolean;
var
  sAccount: string;
  sSessionID: string;
  nSessionID: Integer;
  nChrCount: Integer;
  ChrList: TStringList;
  i: Integer;
  nIndex: Integer;
  ChrRecord: THumDataInfo;
  HumRecord: THumInfo;
  QuickID: pTQuickID;
  btSex: Byte;
  sChrName: string;
  sJob: string;
  sHair: string;
  sLevel: string;
  s40: string;
begin
  Result := False;
  sSessionID := GetValidStr3(DecodeString(sData), sAccount, ['/']);
  nSessionID := Str_ToInt(sSessionID, -2);
  UserInfo.nSessionID := nSessionID;
  nChrCount := 0;
  if FrmIDSoc.CheckSession(sAccount, UserInfo.sUserIPaddr, nSessionID) then begin
    FrmIDSoc.SetGlobaSessionNoPlay(nSessionID);
    UserInfo.sAccount := sAccount;
    ChrList := TStringList.Create;
    try
      if HumChrDB.Open and (HumChrDB.FindByAccount(sAccount, ChrList) >= 0) then begin
        try
          if HumDataDB.OpenEx then begin
            for i := 0 to ChrList.Count - 1 do begin
              QuickID := pTQuickID(ChrList.Objects[i]);
              //FrmDBSrv.MemoLog.Lines.Add('UserInfo.nSelGateID: '+IntToStr(UserInfo.nSelGateID)+' QuickID.nIndex: '+IntToStr(QuickID.nIndex));
              //如果选择ID不对,则跳过
              //if QuickID.nIndex <> UserInfo.nSelGateID then Continue;

              if HumChrDB.GetBy(QuickID.nIndex, HumRecord) and not HumRecord.boDeleted then begin
                sChrName := QuickID.sChrName;
                nIndex := HumDataDB.Index(sChrName);
                if (nIndex < 0) or (nChrCount >= 2) then Continue;
                if HumDataDB.Get(nIndex, ChrRecord) >= 0 then begin
                  btSex := ChrRecord.Data.btSex;
                  sJob := IntToStr(ChrRecord.Data.btJob);
                  sHair := IntToStr(ChrRecord.Data.btHair);
                  sLevel := IntToStr(ChrRecord.Data.Abil.Level);
                  if HumRecord.boSelected then s40 := s40 + '*';
                  s40 := s40 + sChrName + '/' + sJob + '/' + sHair + '/' + sLevel + '/' + IntToStr(btSex) + '/';
                  Inc(nChrCount);
                end;
              end;
            end;
          end;
        finally
          HumDataDB.Close;
        end;
      end;
    finally
      HumChrDB.Close;
    end;
    ChrList.Free;
    SendUserSocket(UserInfo.Socket,
      UserInfo.sConnID,
      EncodeMessage(MakeDefaultMsg(SM_QUERYCHR, nChrCount, 0, 1, 0)) + EncodeString(s40));
    //*ChrName/sJob/sHair/sLevel/sSex/
  end else begin
    SendUserSocket(UserInfo.Socket,
      UserInfo.sConnID,
      EncodeMessage(MakeDefaultMsg(SM_QUERYCHR_FAIL, nChrCount, 0, 1, 0)));
    CloseUser(UserInfo.sConnID, CurGate);
  end;
end;

procedure TFrmUserSoc.OutOfConnect(const UserInfo: pTUserInfo);
var
  Msg: TDefaultMessage;
  sMsg: string;
begin
  Msg := MakeDefaultMsg(SM_OUTOFCONNECTION, 0, 0, 0, 0);
  sMsg := EncodeMessage(Msg);
  SendUserSocket(UserInfo.Socket, sMsg, UserInfo.sConnID);
end;

procedure TFrmUserSoc.DelChr(sData: string;
  var UserInfo: pTUserInfo);
var
  sChrName: string;
  boCheck: Boolean;
  Msg: TDefaultMessage;
  sMsg: string;
  n10: Integer;
  HumRecord: THumInfo;
begin
  g_CheckCode.dwThread0 := 1000300;
  sChrName := DecodeString(sData);
  boCheck := False;
  g_CheckCode.dwThread0 := 1000301;
  try
    if HumChrDB.Open then begin
      n10 := HumChrDB.Index(sChrName);
      if n10 >= 0 then begin
        HumChrDB.Get(n10, HumRecord);
        if HumRecord.sAccount = UserInfo.sAccount then begin
          HumRecord.boDeleted := True;
          HumRecord.dModDate := Now();
          HumChrDB.Update(n10, HumRecord);
          boCheck := True;
        end;
      end;
    end;
  finally
    HumChrDB.Close;
  end;
  g_CheckCode.dwThread0 := 1000302;
  if boCheck then
    Msg := MakeDefaultMsg(SM_DELCHR_SUCCESS, 0, 0, 0, 0)
  else
    Msg := MakeDefaultMsg(SM_DELCHR_FAIL, 0, 0, 0, 0);

  sMsg := EncodeMessage(Msg);
  SendUserSocket(UserInfo.Socket, UserInfo.sConnID, sMsg);
  g_CheckCode.dwThread0 := 1000303;
end;

procedure TFrmUserSoc.NewChr(sData: string; var UserInfo: pTUserInfo);
var
  Data, sAccount, sChrName, sHair, sJob, sSex: string;
  nCode: Integer;
  Msg: TDefaultMessage;
  sMsg: string;
  HumRecord: THumInfo;
  i: Integer;
begin
  nCode := -1;
  Data := DecodeString(sData);
  Data := GetValidStr3(Data, sAccount, ['/']);
  Data := GetValidStr3(Data, sChrName, ['/']);
  Data := GetValidStr3(Data, sHair, ['/']);
  Data := GetValidStr3(Data, sJob, ['/']);
  Data := GetValidStr3(Data, sSex, ['/']);
  if Trim(Data) <> '' then nCode := 0;
  sChrName := Trim(sChrName);
  if Length(sChrName) < 3 then nCode := 0;
  if not CheckDenyChrName(sChrName) then nCode := 2;
  if not CheckChrName(sChrName) then nCode := 0;
  if not boDenyChrName then begin
    for i := 1 to Length(sChrName) do begin
      if (sChrName[i] = #$A1) or
        (sChrName[i] = ' ') or
        (sChrName[i] = '/') or
        (sChrName[i] = '@') or
        (sChrName[i] = '?') or
        (sChrName[i] = '''') or
        (sChrName[i] = '"') or
        (sChrName[i] = '\') or
        (sChrName[i] = '.') or
        (sChrName[i] = ',') or
        (sChrName[i] = ':') or
        (sChrName[i] = ';') or
        (sChrName[i] = '`') or
        (sChrName[i] = '~') or
        (sChrName[i] = '!') or
        (sChrName[i] = '#') or
        (sChrName[i] = '$') or
        (sChrName[i] = '%') or
        (sChrName[i] = '^') or
        (sChrName[i] = '&') or
        (sChrName[i] = '*') or
        (sChrName[i] = '(') or
        (sChrName[i] = ')') or
        (sChrName[i] = '-') or
        (sChrName[i] = '_') or
        (sChrName[i] = '+') or
        (sChrName[i] = '=') or
        (sChrName[i] = '|') or
        (sChrName[i] = '[') or
        (sChrName[i] = '{') or
        (sChrName[i] = ']') or
        (sChrName[i] = '}') then nCode := 0;
    end;
  end;
  if nCode = -1 then begin
    try
      HumDataDB.Lock;
      if HumDataDB.Index(sChrName) >= 0 then nCode := 2;
    finally
      HumDataDB.UnLock;
    end;
  end;
  if nCode = -1 then begin
    try
      if HumChrDB.Open then begin
        //        if HumChrDB.ChrCountOfAccount(sAccount) < 2 then begin
        FillChar(HumRecord, SizeOf(THumInfo), #0);
        HumRecord.sChrName := sChrName;
        HumRecord.sAccount := sAccount;
        HumRecord.boDeleted := False;
        HumRecord.btCount := 0;
        HumRecord.Header.sName := sChrName;
        HumRecord.Header.nSelectID := UserInfo.nSelGateID;
        if HumRecord.Header.sName <> '' then
          if not HumChrDB.Add(HumRecord) then nCode := 2;
        //        end else nCode:= 3;
      end;
    finally
      HumChrDB.Close;
    end;
    if nCode = -1 then begin
      if NewChrData(sChrName, Str_ToInt(sSex, 0), Str_ToInt(sJob, 0), Str_ToInt(sHair, 0)) then
        nCode := 1;
    end else begin
      FrmDBSrv.DelHum(sChrName);
      nCode := 4;
    end;
  end;
  if nCode = 1 then begin
    Msg := MakeDefaultMsg(SM_NEWCHR_SUCCESS, 0, 0, 0, 0);
  end else begin
    Msg := MakeDefaultMsg(SM_NEWCHR_FAIL, nCode, 0, 0, 0);
  end;
  sMsg := EncodeMessage(Msg);
  SendUserSocket(UserInfo.Socket, UserInfo.sConnID, sMsg);
end;

function TFrmUserSoc.SelectChr(sData: string;
  var UserInfo: pTUserInfo): Boolean;
var
  sAccount: string;
  sChrName: string;
  ChrList: TStringList;
  HumRecord: THumInfo;
  i: Integer;
  nIndex: Integer;
  nMapIndex: Integer;
  QuickID: pTQuickID;
  ChrRecord: THumDataInfo;
  sCurMap: string;
  boDataOK: Boolean;
  sDefMsg: string;
  sRouteMsg: string;
  sRouteIP: string;
  nRoutePort: Integer;
begin
  Result := False;
  sChrName := GetValidStr3(DecodeString(sData), sAccount, ['/']);
  boDataOK := False;
  if UserInfo.sAccount = sAccount then begin
    try
      if HumChrDB.Open then begin
        ChrList := TStringList.Create;
        if HumChrDB.FindByAccount(sAccount, ChrList) >= 0 then begin
          for i := 0 to ChrList.Count - 1 do begin
            QuickID := pTQuickID(ChrList.Objects[i]);
            nIndex := QuickID.nIndex;
            if HumChrDB.GetBy(nIndex, HumRecord) then begin
              if HumRecord.sChrName = sChrName then begin
                HumRecord.boSelected := True;
                HumChrDB.UpdateBy(nIndex, HumRecord);
              end else begin
                if HumRecord.boSelected then begin
                  HumRecord.boSelected := False;
                  HumChrDB.UpdateBy(nIndex, HumRecord);
                end;
              end;
            end;
          end;
        end;
        ChrList.Free;
      end;
    finally
      HumChrDB.Close;
    end;
    try
      if HumDataDB.OpenEx then begin
        nIndex := HumDataDB.Index(sChrName);
        if nIndex >= 0 then begin
          HumDataDB.Get(nIndex, ChrRecord);
          sCurMap := ChrRecord.Data.sCurMap;
          boDataOK := True;
        end;
      end;
    finally
      HumDataDB.Close;
    end;
  end;
  if boDataOK then begin
    nMapIndex := GetMapIndex(sCurMap);
    sDefMsg := EncodeMessage(MakeDefaultMsg(SM_STARTPLAY, 0, 0, 0, 0));
    sRouteIP := GateRouteIP(CurGate.sGateaddr, nRoutePort);
    if g_boDynamicIPMode then sRouteIP := UserInfo.sGateIPaddr; //使用动态IP
    //MainOutMessage('sRouteIP+nMapIndex+UserInfo.nSessionID:'+sRouteIP+IntToStr(nMapIndex)+IntToStr(UserInfo.nSessionID));
    sRouteMsg := EncodeString(sRouteIP + '/' + IntToStr(nRoutePort + nMapIndex));
    SendUserSocket(UserInfo.Socket,
      UserInfo.sConnID,
      sDefMsg + sRouteMsg);
    FrmIDSoc.SetGlobaSessionPlay(UserInfo.nSessionID);
    Result := True;
  end else begin
    SendUserSocket(UserInfo.Socket,
      UserInfo.sConnID,
      EncodeMessage(MakeDefaultMsg(SM_STARTFAIL, 0, 0, 0, 0)));
  end;
end;

function TFrmUserSoc.GateRoutePort(sGateIP: string): Integer;
begin
  Result := 7200;
end;

function TFrmUserSoc.GateRouteIP(sGateIP: string; var nPort: Integer): string;
  function GetRoute(RouteInfo: pTRouteInfo; var nGatePort: Integer): string;
  var
    nGateIndex: Integer;
  begin
    nGateIndex := Random(RouteInfo.nGateCount);
    Result := RouteInfo.sGameGateIP[nGateIndex];
    nGatePort := RouteInfo.nGameGatePort[nGateIndex];
  end;
var
  i: Integer;
  RouteInfo: pTRouteInfo;
begin
  nPort := 0;
  Result := '';
  for i := Low(g_RouteInfo) to High(g_RouteInfo) do begin
    RouteInfo := @g_RouteInfo[i];
    if RouteInfo.sSelGateIP = sGateIP then begin
      Result := GetRoute(RouteInfo, nPort);
      break;
    end;
  end;
end;

function TFrmUserSoc.GetMapIndex(sMap: string): Integer;
var
  i: Integer;
begin
  Result := 0;
  for i := 0 to MapList.Count - 1 do begin
    if MapList.Strings[i] = sMap then begin
      Result := Integer(MapList.Objects[i]);
      break;
    end;
  end;
end;

procedure TFrmUserSoc.SendUserSocket(Socket: TCustomWinSocket; sSessionID,
  sSendMsg: string);
begin
  Socket.SendText('%' + sSessionID + '/#' + sSendMsg + '!$');
end;

function TFrmUserSoc.CheckDenyChrName(sChrName: string): Boolean;
var
  i: Integer;
begin
  Result := True;
  g_CheckCode.dwThread0 := 1000700;
  for i := 0 to DenyChrNameList.Count - 1 do begin
    g_CheckCode.dwThread0 := 1000701;
    if CompareText(sChrName, DenyChrNameList.Strings[i]) = 0 then begin
      g_CheckCode.dwThread0 := 1000702;
      Result := False;
      break;
    end;
  end;
  g_CheckCode.dwThread0 := 1000703;
end;

end.

unit MasSock;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls, JSocket, Common, LSShare;
type
  TMsgServerInfo = record
    sReceiveMsg: string;
    Socket: TCustomWinSocket;
    sServerName: string; //0x08
    nServerIndex: Integer; //0x0C
    nOnlineCount: Integer; //0x10
    dwKeepAliveTick: LongWord; //0x14
    sIPaddr: string;
  end;
  pTMsgServerInfo = ^TMsgServerInfo;
  TLimitServerUserInfo = record
    sServerName: string;
    sName: string;
    nLimitCountMin: Integer;
    nLimitCountMax: Integer;
  end;
  pTLimitServerUserInfo = ^TLimitServerUserInfo;
  TFrmMasSoc = class(TForm)
    MSocket: TServerSocket;

    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure MSocketClientConnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure MSocketClientDisconnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure MSocketClientError(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure MSocketClientRead(Sender: TObject; Socket: TCustomWinSocket);
  private
    procedure SortServerList(nIndex: Integer);
    procedure RefServerLimit(sServerName: string);
    function LimitName(sServerName: string): string;
    { Private declarations }
  public
    m_ServerList: TList;
    procedure LoadServerAddr();
    procedure LoadUserLimit;
    function CheckReadyServers(): Boolean;
    procedure SendServerMsg(wIdent: Word; sServerName, sMsg: string);
    procedure SendServerMsgA(wIdent: Word; sMsg: string);
    function IsNotUserFull(sServerName: string): Boolean;
    function ServerStatus(sServerName: string): Integer;
    function GetOnlineHumCount(): Integer;
    { Public declarations }
  end;

var
  FrmMasSoc: TFrmMasSoc;
  nUserLimit: Integer;
  UserLimit: array[0..MAXGATEROUTE - 1] of TLimitServerUserInfo;

implementation

uses LMain, HUtil32, Grobal2;

{$R *.DFM}

procedure TFrmMasSoc.FormCreate(Sender: TObject);
var
  Config: pTConfig;
begin
  Config := @g_Config;
  m_ServerList := TList.Create;
  MSocket.Address := Config.sServerAddr;
  MSocket.Port := Config.nServerPort;
  MSocket.Active := true;
  LoadServerAddr();
  LoadUserLimit();
end;

procedure TFrmMasSoc.MSocketClientConnect(Sender: TObject;
  Socket: TCustomWinSocket);
var
  I: Integer;
  sRemoteAddr: string;
  boAllowed: Boolean;
  MsgServer: pTMsgServerInfo;
begin
  sRemoteAddr := Socket.RemoteAddress;
  boAllowed := False;
  for I := Low(ServerAddr) to High(ServerAddr) do
    if sRemoteAddr = ServerAddr[I] then begin
      boAllowed := true;
      break;
    end;
  if boAllowed then begin
    New(MsgServer);
    FillChar(MsgServer^, SizeOf(TMsgServerInfo), #0);
    MsgServer.sReceiveMsg := '';
    MsgServer.Socket := Socket;
    m_ServerList.Add(MsgServer);
  end else begin
    MainOutMessage('非法地址连接:' + sRemoteAddr);
    Socket.Close;
  end;
end;

procedure TFrmMasSoc.MSocketClientDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
var
  I: Integer;
  MsgServer: pTMsgServerInfo;
begin
  for I := 0 to m_ServerList.Count - 1 do begin
    MsgServer := m_ServerList.Items[I];
    if MsgServer.Socket = Socket then begin
      Dispose(MsgServer);
      m_ServerList.Delete(I);
      break;
    end;
  end;
end;

procedure TFrmMasSoc.MSocketClientError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
  ErrorCode := 0;
  Socket.Close;
end;

procedure TFrmMasSoc.MSocketClientRead(Sender: TObject;
  Socket: TCustomWinSocket);
var
  I: Integer;
  MsgServer: pTMsgServerInfo;
  sReviceMsg: string;
  sMsg: string;
  sCode: string;
  sAccount: string;
  sServerName: string;
  sIndex: string;
  sOnlineCount: string;
  nCode: Integer;
  Config: pTConfig;
begin
  Config := @g_Config;
  for I := 0 to m_ServerList.Count - 1 do begin
    MsgServer := m_ServerList.Items[I];
    if MsgServer.Socket = Socket then begin
      sReviceMsg := MsgServer.sReceiveMsg + Socket.ReceiveText;
      while (Pos(')', sReviceMsg) > 0) do begin
        //(103/叶随风飘/99/0)
        //MainOutMessage(sReviceMsg);
        sReviceMsg := ArrestStringEx(sReviceMsg, '(', ')', sMsg);
        if sMsg = '' then break;
        sMsg := GetValidStr3(sMsg, sCode, ['/']);
        nCode := Str_ToInt(sCode, -1);
        case nCode of
          SS_SOFTOUTSESSION: begin
              sMsg := GetValidStr3(sMsg, sAccount, ['/']);
              CloseUser(Config, sAccount, Str_ToInt(sMsg, 0));
            end;
          SS_SERVERINFO: begin
              sMsg := GetValidStr3(sMsg, sServerName, ['/']);
              sMsg := GetValidStr3(sMsg, sIndex, ['/']);
              sMsg := GetValidStr3(sMsg, sOnlineCount, ['/']);
              MsgServer.sServerName := sServerName;
              MsgServer.nServerIndex := Str_ToInt(sIndex, 0);
              MsgServer.nOnlineCount := Str_ToInt(sOnlineCount, 0);
              MsgServer.dwKeepAliveTick := GetTickCount();
              SortServerList(I);
              nOnlineCountMin := GetOnlineHumCount();
              if nOnlineCountMin > nOnlineCountMax then nOnlineCountMax := nOnlineCountMin;
              SendServerMsgA(SS_KEEPALIVE, IntToStr(nOnlineCountMin));
              RefServerLimit(sServerName);
            end;
          UNKNOWMSG: SendServerMsgA(UNKNOWMSG, sMsg);
        end;
      end;
    end;
    MsgServer.sReceiveMsg := sReviceMsg;
  end;
end;

procedure TFrmMasSoc.FormDestroy(Sender: TObject);
begin
  m_ServerList.Free;
end;

procedure TFrmMasSoc.RefServerLimit(sServerName: string);
var
  I: Integer;
  nCount: Integer;
  MsgServer: pTMsgServerInfo;
begin
  try
    nCount := 0;
    for I := 0 to m_ServerList.Count - 1 do begin
      MsgServer := m_ServerList.Items[I];
      if (MsgServer.nServerIndex <> 99) and (MsgServer.sServerName = sServerName) then
        Inc(nCount, MsgServer.nOnlineCount);
    end;
    for I := Low(UserLimit) to High(UserLimit) do begin
      if CompareText(UserLimit[I].sServerName, sServerName) = 0 then begin
        UserLimit[I].nLimitCountMin := nCount;
        break;
      end;
    end;
  except
    MainOutMessage('TFrmMasSoc.RefServerLimit');
  end;
end;

function TFrmMasSoc.IsNotUserFull(sServerName: string): Boolean;
var
  I: Integer;
begin
  Result := true;
  for I := Low(UserLimit) to High(UserLimit) do begin
    if CompareText(UserLimit[I].sServerName, sServerName) = 0 then begin
      if UserLimit[I].nLimitCountMin > UserLimit[I].nLimitCountMax then
        Result := False;
      break;
    end;
  end;
end;

procedure TFrmMasSoc.SortServerList(nIndex: Integer);
var
  nC, n10, n14: Integer;
  MsgServerSort: pTMsgServerInfo;
  MsgServer: pTMsgServerInfo;
  nNewIndex: Integer;
begin
  try
    if m_ServerList.Count <= nIndex then Exit;
    MsgServerSort := m_ServerList.Items[nIndex];
    m_ServerList.Delete(nIndex);
    for nC := 0 to m_ServerList.Count - 1 do begin
      MsgServer := m_ServerList.Items[nC];
      if MsgServer.sServerName = MsgServerSort.sServerName then begin
        if MsgServer.nServerIndex < MsgServerSort.nServerIndex then begin
          m_ServerList.Insert(nC, MsgServerSort);
          Exit;
        end else begin
          nNewIndex := nC + 1;
          if nNewIndex < m_ServerList.Count then begin //Jacky 增加
            for n10 := nNewIndex to m_ServerList.Count - 1 do begin
              MsgServer := m_ServerList.Items[n10];
              if MsgServer.sServerName = MsgServerSort.sServerName then begin
                if MsgServer.nServerIndex < MsgServerSort.nServerIndex then begin
                  m_ServerList.Insert(n10, MsgServerSort);
                  for n14 := n10 + 1 to m_ServerList.Count - 1 do begin
                    MsgServer := m_ServerList.Items[n14];
                    if (MsgServer.sServerName = MsgServerSort.sServerName) and (MsgServer.nServerIndex = MsgServerSort.nServerIndex) then begin
                      m_ServerList.Delete(n14);
                      Exit;
                    end;
                  end;
                  Exit;
                end else begin
                  nNewIndex := n10 + 1;
                end;
              end;
            end;
            m_ServerList.Insert(nNewIndex, MsgServerSort);
            Exit;
          end;
        end;
      end;
    end;
    m_ServerList.Add(MsgServerSort);
  except
    MainOutMessage('TFrmMasSoc.SortServerList');
  end;
end;

procedure TFrmMasSoc.SendServerMsg(wIdent: Word; sServerName, sMsg: string);
var
  I: Integer;
  MsgServer: pTMsgServerInfo;
  sSendMsg: string;
  s18: string;
resourcestring
  sFormatMsg = '(%d/%s)';
begin
  try
    s18 := LimitName(sServerName);
    sSendMsg := format(sFormatMsg, [wIdent, sMsg]);
    for I := 0 to m_ServerList.Count - 1 do begin
      MsgServer := pTMsgServerInfo(m_ServerList.Items[I]);
      if MsgServer.Socket.Connected then begin
        if (s18 = '') or (MsgServer.sServerName = '') or (CompareText(MsgServer.sServerName, s18) = 0) or (MsgServer.nServerIndex = 99) then begin
          MsgServer.Socket.SendText(sSendMsg);
        end;
      end;
    end;
  except
    MainOutMessage('TFrmMasSoc.SendServerMsg');
  end;
end;

procedure TFrmMasSoc.LoadServerAddr();
var
  sFileName: string;
  LoadList: TStringList;
  I, nServerIdx: Integer;
  sLineText: string;
begin
  sFileName := '.\!ServerAddr.txt';
  nServerIdx := 0;
  FillChar(ServerAddr, SizeOf(ServerAddr), #0);
  if FileExists(sFileName) then begin
    LoadList := TStringList.Create;
    LoadList.LoadFromFile(sFileName);
    for I := 0 to LoadList.Count - 1 do begin
      sLineText := Trim(LoadList.Strings[I]);
      if (sLineText <> '') and (sLineText[I] <> ';') then begin
        if TagCount(sLineText, '.') = 3 then begin
          ServerAddr[nServerIdx] := sLineText;
          Inc(nServerIdx);
          if nServerIdx >= MAXGATEROUTE - 1 then break;
        end;
      end;
    end;
    LoadList.Free;
  end;
end;

function TFrmMasSoc.GetOnlineHumCount(): Integer;
var
  I, nCount: Integer;
  MsgServer: pTMsgServerInfo;
begin
  try
    nCount := 0;
    for I := 0 to m_ServerList.Count - 1 do begin
      MsgServer := m_ServerList.Items[I];
      if MsgServer.nServerIndex <> 99 then
        Inc(nCount, MsgServer.nOnlineCount);
    end;
    Result := nCount;
  except
    MainOutMessage('TFrmMasSoc.GetOnlineHumCount');
  end;
end;

function TFrmMasSoc.CheckReadyServers: Boolean;
var
  Config: pTConfig;
begin
  Config := @g_Config;
  Result := False;
  if m_ServerList.Count >= Config.nReadyServers then
    Result := true;
end;

procedure TFrmMasSoc.SendServerMsgA(wIdent: Word; sMsg: string);
var
  I: Integer;
  sSendMsg: string;
  MsgServer: pTMsgServerInfo;
resourcestring
  sFormatMsg = '(%d/%s/%s)';
begin
  try
    sSendMsg := format(sFormatMsg, [wIdent, sMsg, '游戏中心']);
    for I := 0 to m_ServerList.Count - 1 do begin
      MsgServer := pTMsgServerInfo(m_ServerList.Items[I]);
      if MsgServer.Socket.Connected then MsgServer.Socket.SendText(sSendMsg);
    end;
  except
    on e: Exception do begin
      MainOutMessage('TFrmMasSoc.SendServerMsgA');
      MainOutMessage(e.Message);
    end;
  end;
end;

function TFrmMasSoc.LimitName(sServerName: string): string;
var
  I: Integer;
begin
  try
    Result := '';
    for I := Low(UserLimit) to High(UserLimit) do begin
      if CompareText(UserLimit[I].sServerName, sServerName) = 0 then begin
        Result := UserLimit[I].sName;
        break;
      end;
    end;
  except
    MainOutMessage('TFrmMasSoc.LimitName');
  end;
end;

procedure TFrmMasSoc.LoadUserLimit();
var
  LoadList: TStringList;
  sFileName: string;
  I, nC: Integer;
  sLineText, sServerName, s10, s14: string;
begin
  nC := 0;
  sFileName := '.\!UserLimit.txt';
  if FileExists(sFileName) then begin
    LoadList := TStringList.Create;
    LoadList.LoadFromFile(sFileName);
    for I := 0 to LoadList.Count - 1 do begin
      sLineText := LoadList.Strings[I];
      sLineText := GetValidStr3(sLineText, sServerName, [' ', #9]);
      sLineText := GetValidStr3(sLineText, s10, [' ', #9]);
      sLineText := GetValidStr3(sLineText, s14, [' ', #9]);
      if sServerName <> '' then begin
        UserLimit[nC].sServerName := sServerName;
        UserLimit[nC].sName := s10;
        UserLimit[nC].nLimitCountMax := Str_ToInt(s14, 3000);
        UserLimit[nC].nLimitCountMin := 0;
        Inc(nC);
      end;
    end;
    nUserLimit := nC;
    LoadList.Free;
  end else ShowMessage('[Critical Failure] file not found. .\!UserLimit.txt');
end;

function TFrmMasSoc.ServerStatus(sServerName: string): Integer;
var
  I: Integer;
  nStatus: Integer;
  MsgServer: pTMsgServerInfo;
  boServerOnLine: Boolean;
begin
  try
    Result := 0;
    boServerOnLine := False;
    for I := 0 to m_ServerList.Count - 1 do begin
      MsgServer := m_ServerList.Items[I];
      if (MsgServer.nServerIndex <> 99) and (MsgServer.sServerName = sServerName) then begin
        boServerOnLine := true;
      end;
    end;
    if not boServerOnLine then Exit;

    for I := Low(UserLimit) to High(UserLimit) do begin
      if UserLimit[I].sServerName = sServerName then begin
        if UserLimit[I].nLimitCountMin <= UserLimit[I].nLimitCountMax div 2 then begin
          nStatus := 1; //空闲
          break;
        end;

        if UserLimit[I].nLimitCountMin <= UserLimit[I].nLimitCountMax - (UserLimit[I].nLimitCountMax div 5) then begin
          nStatus := 2; //良好
          break;
        end;
        if UserLimit[I].nLimitCountMin < UserLimit[I].nLimitCountMax then begin
          nStatus := 3; //繁忙
          break;
        end;
        if UserLimit[I].nLimitCountMin >= UserLimit[I].nLimitCountMax then begin
          nStatus := 4; //满员
          break;
        end;
      end;
    end;
    Result := nStatus;
  except
    MainOutMessage('TFrmMasSoc.ServerStatus');
  end;
end;

end.

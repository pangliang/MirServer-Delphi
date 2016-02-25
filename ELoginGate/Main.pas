unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls, JSocket, WinSock, ExtCtrls, ComCtrls, Menus, IniFiles, GateShare;
const
  GATEMAXSESSION = 10000;
type
  TUserSession = record
    Socket: TCustomWinSocket; //0x00
    sRemoteIPaddr: string; //0x04
    nSendMsgLen: Integer; //0x08
    nReviceMsgLen: Integer;
    bo0C: Boolean; //0x0C
    dw10Tick: LongWord; //0x10
    nCheckSendLength: Integer; //0x14
    boSendAvailable: Boolean; //0x18
    boSendCheck: Boolean; //0x19
    dwSendLockTimeOut: LongWord; //0x1C
    n20: Integer; //0x20
    dwUserTimeOutTick: LongWord; //0x24
    SocketHandle: Integer; //0x28
    sIP: string; //0x2C
    MsgList: TStringList; //0x30
    dwConnctCheckTick: LongWord; //连接数据传输空闲超时检测
    dwReceiveTick: LongWord;
    dwReceiveTimeTick: LongWord;
  end;
  pTUserSession = ^TUserSession;
  TSessionArray = array[0..GATEMAXSESSION - 1] of TUserSession;
  TFrmMain = class(TForm)
    ServerSocket: TServerSocket;
    MemoLog: TMemo;
    SendTimer: TTimer;
    ClientSocket: TClientSocket;
    Panel: TPanel;
    Timer: TTimer;
    DecodeTimer: TTimer;
    LbHold: TLabel;
    LbLack: TLabel;
    Label2: TLabel;
    StatusBar: TStatusBar;
    MainMenu: TMainMenu;
    MENU_CONTROL: TMenuItem;
    StartTimer: TTimer;
    MENU_CONTROL_START: TMenuItem;
    MENU_CONTROL_STOP: TMenuItem;
    MENU_CONTROL_RECONNECT: TMenuItem;
    MENU_CONTROL_CLEAELOG: TMenuItem;
    MENU_CONTROL_EXIT: TMenuItem;
    MENU_VIEW: TMenuItem;
    MENU_VIEW_LOGMSG: TMenuItem;
    MENU_OPTION: TMenuItem;
    MENU_OPTION_GENERAL: TMenuItem;
    MENU_OPTION_IPFILTER: TMenuItem;
    H1: TMenuItem;
    S1: TMenuItem;

    procedure MemoLogChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure SendTimerTimer(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure DecodeTimerTimer(Sender: TObject);


    procedure ClientSocketConnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ClientSocketDisconnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ClientSocketError(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure ClientSocketRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure ServerSocketClientConnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ServerSocketClientDisconnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ServerSocketClientError(Sender: TObject;
      Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
      var ErrorCode: Integer);
    procedure ServerSocketClientRead(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure StartTimerTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure MENU_CONTROL_STARTClick(Sender: TObject);
    procedure MENU_CONTROL_STOPClick(Sender: TObject);
    procedure MENU_CONTROL_RECONNECTClick(Sender: TObject);
    procedure MENU_CONTROL_CLEAELOGClick(Sender: TObject);
    procedure MENU_CONTROL_EXITClick(Sender: TObject);
    procedure MENU_VIEW_LOGMSGClick(Sender: TObject);
    procedure MENU_OPTION_GENERALClick(Sender: TObject);
    procedure MENU_OPTION_IPFILTERClick(Sender: TObject);
    procedure S1Click(Sender: TObject);
  private
    dwShowMainLogTick: LongWord;
    boShowLocked: Boolean;
    TempLogList: TStringList;
    nSessionCount: Integer;
    StringList30C: TStringList;
    dwSendKeepAliveTick: LongWord;
    boServerReady: Boolean;
    StringList318: TStringList;

    dwDecodeMsgTime: LongWord;
    dwReConnectServerTick: LongWord;
    procedure ResUserSessionArray();
    procedure StartService();
    procedure StopService();
    procedure LoadConfig();
    procedure ShowLogMsg(boFlag: Boolean);
    function IsBlockIP(sIPaddr: string): Boolean;
    function IsConnLimited(sIPaddr: string): Boolean;
    function AddAttackIP(sIPaddr: string): Boolean;
    procedure CloseSocket(nSocketHandle: Integer);
    function SendUserMsg(UserSession: pTUserSession; sSendMsg: string): Integer;
    procedure ShowMainLogMsg;
    procedure IniUserSessionArray;
    function CloseSocketAndGetIPAddr(nSocketHandle: Integer): string;
    { Private declarations }
  public
    procedure CloseConnect(sIPaddr: string);
    function AddBlockIP(sIPaddr: string): Integer;
    function AddTempBlockIP(sIPaddr: string): Integer;
    procedure MyMessage(var MsgData: TWmCopyData); message WM_COPYDATA;
    { Public declarations }
  end;
procedure MainOutMessage(sMsg: string; nMsgLevel: Integer);
var
  FrmMain: TFrmMain;
  g_SessionArray: TSessionArray;
  ClientSockeMsgList: TStringList;
  sProcMsg: string;
implementation

uses HUtil32, GeneralConfig, IPaddrFilter, Grobal2;

{$R *.DFM}
procedure MainOutMessage(sMsg: string; nMsgLevel: Integer);
var
  tMsg: string;
begin
  try
    CS_MainLog.Enter;
    if nMsgLevel <= nShowLogLevel then begin
      tMsg := '[' + TimeToStr(Now) + '] ' + sMsg;
      MainLogMsgList.Add(tMsg);
    end;
  finally
    CS_MainLog.Leave;
  end;
end;

procedure TFrmMain.ServerSocketClientConnect(Sender: TObject;
  Socket: TCustomWinSocket);
var
  UserSession: pTUserSession;
  sRemoteIPaddr, sLocalIPaddr: string;
  nSockIndex: Integer;
begin
  Socket.nIndex := -1;
  sRemoteIPaddr := Socket.RemoteAddress;

  if g_boDynamicIPDisMode then begin
    sLocalIPaddr := ClientSocket.Socket.RemoteAddress;
  end else begin
    sLocalIPaddr := Socket.LocalAddress;
  end;

  if IsBlockIP(sRemoteIPaddr) then begin
    MainOutMessage('过滤连接: ' + sRemoteIPaddr, 1);
    Socket.Close;
    Exit;
  end;

  if IsConnLimited(sRemoteIPaddr) then begin
    case BlockMethod of
      mDisconnect: begin
          Socket.Close;
        end;
      mBlock: begin
          AddTempBlockIP(sRemoteIPaddr);
          CloseConnect(sRemoteIPaddr);
        end;
      mBlockList: begin
          AddBlockIP(sRemoteIPaddr);
          CloseConnect(sRemoteIPaddr);
        end;
    end;
    MainOutMessage('端口攻击: ' + sRemoteIPaddr, 1);
    Exit;
  end;

  if boGateReady then begin
    for nSockIndex := 0 to GATEMAXSESSION - 1 do begin
      UserSession := @g_SessionArray[nSockIndex];
      if UserSession.Socket = nil then begin
        UserSession.Socket := Socket;
        UserSession.sRemoteIPaddr := sRemoteIPaddr;
        UserSession.nSendMsgLen := 0;
        UserSession.nReviceMsgLen := 0;
        UserSession.bo0C := False;
        UserSession.dw10Tick := GetTickCount();
        UserSession.dwConnctCheckTick := GetTickCount();
        UserSession.boSendAvailable := True;
        UserSession.boSendCheck := False;
        UserSession.nCheckSendLength := 0;
        UserSession.n20 := 0;
        UserSession.dwUserTimeOutTick := GetTickCount();
        UserSession.SocketHandle := Socket.SocketHandle;
        UserSession.sIP := sRemoteIPaddr;
        UserSession.dwReceiveTick := GetTickCount();
        UserSession.MsgList.Clear;
        Socket.nIndex := nSockIndex;
        Inc(nSessionCount);
        break;
      end;
    end;
    if Socket.nIndex >= 0 then begin
      ClientSocket.Socket.SendText('%N' +
        IntToStr(Socket.SocketHandle) +
        '/' +
        sRemoteIPaddr +
        '/' +
        sLocalIPaddr +
        '$');
      MainOutMessage('Connect: ' + sRemoteIPaddr, 5);
    end else begin
      Socket.Close;
      MainOutMessage('Kick Off: ' + sRemoteIPaddr, 1);
    end;
  end else begin //0x004529EF
    Socket.Close;
    MainOutMessage('Kick Off: ' + sRemoteIPaddr, 1);
  end;
end;

procedure TFrmMain.ServerSocketClientDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
var
  I, II: Integer;
  UserSession: pTUserSession;
  nSockIndex: Integer;
  sRemoteIPaddr: string;
  IPaddr: pTSockaddr;
  nIPaddr: Integer;
  IPList: TList;
begin
  sRemoteIPaddr := Socket.RemoteAddress;
  nSockIndex := Socket.nIndex;
  nIPaddr := inet_addr(PChar(sRemoteIPaddr));
  CurrIPaddrList.Lock;
  try
    for I := CurrIPaddrList.Count - 1 downto 0 do begin
      IPList := TList(CurrIPaddrList.Items[I]);
      if IPList <> nil then begin
        if pTSockaddr(IPList.Items[0]) <> nil then begin
          if pTSockaddr(IPList.Items[0]).nIPaddr = nIPaddr then begin
            Dispose(pTSockaddr(IPList.Items[0]));
            IPList.Delete(0);
            if IPList.Count <= 0 then begin
              IPList.Free;
              CurrIPaddrList.Delete(I);
            end;
            break;
          end;
        end;
      end;
    end;
  finally
    CurrIPaddrList.UnLock;
  end;

  if (nSockIndex >= 0) and (nSockIndex < GATEMAXSESSION) then begin
    UserSession := @g_SessionArray[nSockIndex];
    UserSession.Socket := nil;
    UserSession.sRemoteIPaddr := '';
    UserSession.SocketHandle := -1;
    UserSession.MsgList.Clear;
    Dec(nSessionCount);
    if boGateReady then begin
      ClientSocket.Socket.SendText('%C' +
        IntToStr(Socket.SocketHandle) +
        '$');
      MainOutMessage('DisConnect: ' + sRemoteIPaddr, 5);
    end;
  end;
end;

procedure TFrmMain.ServerSocketClientError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
  StringList30C.Add('Error ' + IntToStr(ErrorCode) + ': ' + Socket.RemoteAddress);
  Socket.Close;
  ErrorCode := 0;
end;

procedure TFrmMain.ServerSocketClientRead(Sender: TObject;
  Socket: TCustomWinSocket);
var
  UserSession: pTUserSession;
  nSockIndex: Integer;
  sRemoteAddress, sReviceMsg, s10, s1C: string;
  nPos: Integer;
  nMsgLen: Integer;
  nIPaddr: Integer;
  nMsgCount: Integer;
  bo01: Boolean;
  bo02: Boolean;
begin
  bo01 := False;
  bo02 := False;
  nSockIndex := Socket.nIndex;
  sRemoteAddress := Socket.RemoteAddress;
  if (nSockIndex >= 0) and (nSockIndex < GATEMAXSESSION) then begin
    UserSession := @g_SessionArray[nSockIndex];
    sReviceMsg := Socket.ReceiveText;
    if (sReviceMsg <> '') and (boServerReady) then begin
      nPos := Pos('*', sReviceMsg);
      if nPos > 0 then begin
        UserSession.boSendAvailable := True;
        UserSession.boSendCheck := False;
        UserSession.nCheckSendLength := 0;
        UserSession.dwReceiveTick := GetTickCount();
        s10 := Copy(sReviceMsg, 1, nPos - 1);
        s1C := Copy(sReviceMsg, nPos + 1, Length(sReviceMsg) - nPos);
        sReviceMsg := s10 + s1C;
      end;
      nMsgLen := Length(sReviceMsg);
      if nAttackLevel > 0 then begin
        Inc(UserSession.nReviceMsgLen, nMsgLen);
        nMsgCount := TagCount(sReviceMsg, '!');
        if nMsgCount > nMaxClientMsgCount * nAttackLevel then bo02 := True;
        if (GetTickCount - UserSession.dwReceiveTick) >= dwReviceTick * nAttackLevel then begin //100
          UserSession.dwReceiveTick := GetTickCount;
          if UserSession.nReviceMsgLen > nReviceMsgLength * nAttackLevel then begin //100
            bo01 := True;
          end else begin
            UserSession.nReviceMsgLen := 0;
          end;
        end;
        if bo01 or bo02 then begin
          case BlockMethod of
            mDisconnect: begin
                //Socket.Close;
              end;
            mBlock: begin
                AddTempBlockIP(sRemoteAddress);
                CloseConnect(sRemoteAddress);
              end;
            mBlockList: begin
                AddBlockIP(sRemoteAddress);
                CloseConnect(sRemoteAddress);
              end;
          end;
          if bo01 then
            MainOutMessage('端口攻击: ' + sRemoteAddress + ' 数据包长度: ' + IntToStr(UserSession.nReviceMsgLen), 1);
          if bo02 then
            MainOutMessage('端口攻击: ' + sRemoteAddress + '信息数量：' + IntToStr(nMsgCount), 1);
          Socket.Close;
          Exit;
        end;
      end;
      if (sReviceMsg <> '') and (boGateReady) and (not boKeepAliveTimcOut) then begin
        UserSession.dwConnctCheckTick := GetTickCount();
        if (GetTickCount - UserSession.dwUserTimeOutTick) < 1000 then begin
          Inc(UserSession.n20, nMsgLen);
        end else UserSession.n20 := nMsgLen;
        ClientSocket.Socket.SendText('%D' +
          IntToStr(Socket.SocketHandle) +
          '/' +
          sReviceMsg +
          '$');
      end;
    end;
  end;
end;

procedure TFrmMain.MemoLogChange(Sender: TObject);
begin
  if MemoLog.Lines.Count > 200 then MemoLog.Clear;
end;

procedure TFrmMain.FormDestroy(Sender: TObject);
var
  nIndex: Integer;
begin
  StringList30C.Free;
  TempLogList.Free;
  for nIndex := 0 to GATEMAXSESSION - 1 do begin
    g_SessionArray[nIndex].MsgList.Free;
  end;
end;

procedure TFrmMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if boClose then Exit;
  if Application.MessageBox('是否确认退出服务器？',
    '提示信息',
    MB_YESNO + MB_ICONQUESTION) = IDYES then begin
    if boServiceStart then begin
      StartTimer.Enabled := True;
      CanClose := False;
    end;
  end else CanClose := False;
end;

procedure TFrmMain.ClientSocketConnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  boGateReady := True;
  nSessionCount := 0;
  dwKeepAliveTick := GetTickCount();
  ResUserSessionArray();
  boServerReady := True;
end;

procedure TFrmMain.ClientSocketDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
var
  UserSession: pTUserSession;
  nIndex: Integer;
begin
  for nIndex := 0 to GATEMAXSESSION - 1 do begin
    UserSession := @g_SessionArray[nIndex];
    if UserSession.Socket <> nil then
      UserSession.Socket.Close;
    UserSession.Socket := nil;
    UserSession.sRemoteIPaddr := '';
    UserSession.SocketHandle := -1;
  end;
  ResUserSessionArray();
  ClientSockeMsgList.Clear;
  boGateReady := False;
  nSessionCount := 0;
end;

procedure TFrmMain.ClientSocketError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
  Socket.Close;
  ErrorCode := 0;
  boServerReady := False;
end;

procedure TFrmMain.ClientSocketRead(Sender: TObject;
  Socket: TCustomWinSocket);
var
  sRecvMsg: string;
begin
  sRecvMsg := Socket.ReceiveText;
  ClientSockeMsgList.Add(sRecvMsg);
end;

procedure TFrmMain.SendTimerTimer(Sender: TObject);
var
  nIndex: Integer;
  UserSession: pTUserSession;
begin
  if ServerSocket.Active then begin
    n456A30 := ServerSocket.Socket.ActiveConnections;
  end;
  if boSendHoldTimeOut then begin
    LbHold.Caption := IntToStr(n456A30) + '#';
    if (GetTickCount - dwSendHoldTick) > 3 * 1000 then boSendHoldTimeOut := False;
  end else begin
    LbHold.Caption := IntToStr(n456A30);
  end;
  if boGateReady and (not boKeepAliveTimcOut) then begin
    for nIndex := 0 to GATEMAXSESSION - 1 do begin
      UserSession := @g_SessionArray[nIndex];
      if UserSession.Socket <> nil then begin
        if (GetTickCount - UserSession.dwUserTimeOutTick) > 60 * 60 * 1000 then begin
          UserSession.Socket.Close;
          UserSession.Socket := nil;
          UserSession.SocketHandle := -1;
          UserSession.MsgList.Clear;
          UserSession.sRemoteIPaddr := '';
        end;
      end;
    end;
  end;
  if not boGateReady and (boServiceStart) then begin
    if (GetTickCount - dwReConnectServerTick) > 1000 {30 * 1000} then begin
      dwReConnectServerTick := GetTickCount();
      ClientSocket.Active := False;
      ClientSocket.Port := ServerPort;
      ClientSocket.Host := ServerAddr;
      ClientSocket.Active := True;
    end;
  end;
end;

procedure TFrmMain.TimerTimer(Sender: TObject);
begin
  if ServerSocket.Active then begin
    StatusBar.Panels[0].Text := IntToStr(ServerSocket.Port);
    if boSendHoldTimeOut then
      StatusBar.Panels[2].Text := IntToStr(nSessionCount) + '/#' + IntToStr(ServerSocket.Socket.ActiveConnections)
    else
      StatusBar.Panels[2].Text := IntToStr(nSessionCount) + '/' + IntToStr(ServerSocket.Socket.ActiveConnections);
  end else begin
    StatusBar.Panels[0].Text := '????';
    StatusBar.Panels[2].Text := '????';
  end;
  Label2.Caption := IntToStr(dwDecodeMsgTime);
  if not boGateReady then begin
    StatusBar.Panels[1].Text := '---]    [---';
    //StatusBar.Panels[1].Text := '未连接';
  end else begin
    if boKeepAliveTimcOut then begin
      StatusBar.Panels[1].Text := '---]$$$$[---';
      //StatusBar.Panels[1].Text := '超时';
    end else begin
      StatusBar.Panels[1].Text := '-----][-----';
      //StatusBar.Panels[1].Text := '已连接';
      LbLack.Caption := IntToStr(n456A2C) + '/' + IntToStr(nSendMsgCount);
    end;
  end;
end;

procedure TFrmMain.DecodeTimerTimer(Sender: TObject);
var
  sProcessMsg: string;
  sSocketMsg: string;
  sSocketHandle: string;
  nSocketIndex: Integer;
  nMsgCount: Integer;
  nSendRetCode: Integer;
  nSocketHandle: Integer;
  dwDecodeTick: LongWord;
  dwDecodeTime: LongWord;
  sRemoteIPaddr: string;
  UserSession: pTUserSession;
begin
  ShowMainLogMsg();
  if boDecodeLock or (not boGateReady) then Exit;

  try
    dwDecodeTick := GetTickCount();
    boDecodeLock := True;
    sProcessMsg := '';
    while (True) do begin
      if ClientSockeMsgList.Count <= 0 then break;
      sProcessMsg := sProcMsg + ClientSockeMsgList.Strings[0];
      sProcMsg := '';
      ClientSockeMsgList.Delete(0);
      while (True) do begin
        if TagCount(sProcessMsg, '$') < 1 then break;
        sProcessMsg := ArrestStringEx(sProcessMsg, '%', '$', sSocketMsg);
        if sSocketMsg = '' then break;
        if sSocketMsg[1] = '+' then begin
          case sSocketMsg[2] of
            '-': begin
                CloseSocket(Str_ToInt(Copy(sSocketMsg, 3, Length(sSocketMsg) - 2), 0));
                Continue;
              end;
            'B': begin
                sRemoteIPaddr := CloseSocketAndGetIPAddr(Str_ToInt(Copy(sSocketMsg, 3, Length(sSocketMsg) - 2), 0));
                AddTempBlockIP(sRemoteIPaddr);
                Continue;
              end;
            'T': begin
                sRemoteIPaddr := CloseSocketAndGetIPAddr(Str_ToInt(Copy(sSocketMsg, 3, Length(sSocketMsg) - 2), 0));
                AddBlockIP(sRemoteIPaddr);
                Continue;
              end;
            else begin
                dwKeepAliveTick := GetTickCount();
                boKeepAliveTimcOut := False;
                Continue;
              end;
          end;
        end;
        sSocketMsg := GetValidStr3(sSocketMsg, sSocketHandle, ['/']);
        nSocketHandle := Str_ToInt(sSocketHandle, -1);
        if nSocketHandle < 0 then Continue;
        for nSocketIndex := 0 to GATEMAXSESSION - 1 do begin
          if g_SessionArray[nSocketIndex].SocketHandle = nSocketHandle then begin
            g_SessionArray[nSocketIndex].MsgList.Add(sSocketMsg);
            break;
          end;
        end;
      end; //0x00452246
    end; //0x452252
    //if sProcessMsg <> '' then ClientSockeMsgList.Add(sProcessMsg);
    if sProcessMsg <> '' then sProcMsg := sProcessMsg;

    nSendMsgCount := 0;
    n456A2C := 0;
    StringList318.Clear;
    for nSocketIndex := 0 to GATEMAXSESSION - 1 do begin
      if g_SessionArray[nSocketIndex].SocketHandle <= -1 then Continue;

      //踢除超时无数据传输连接
      if (nAttackLevel > 0) and ((GetTickCount - g_SessionArray[nSocketIndex].dwConnctCheckTick) > dwKeepConnectTimeOut * nAttackLevel) then begin
        sRemoteIPaddr := g_SessionArray[nSocketIndex].sRemoteIPaddr;
        {case BlockMethod of //
          mDisconnect: begin
              g_SessionArray[nSocketIndex].Socket.Close;
            end;
          mBlock: begin
              AddTempBlockIP(sRemoteIPaddr);
              CloseConnect(sRemoteIPaddr);
            end;
          mBlockList: begin
              AddBlockIP(sRemoteIPaddr);
              CloseConnect(sRemoteIPaddr);
            end;
        end;}
        g_SessionArray[nSocketIndex].Socket.Close;
        CloseConnect(sRemoteIPaddr);
        MainOutMessage('端口空连接攻击: ' + sRemoteIPaddr, 1);
        Continue;
      end;

      while (True) do begin
        if g_SessionArray[nSocketIndex].MsgList.Count <= 0 then break;
        UserSession := @g_SessionArray[nSocketIndex];
        nSendRetCode := SendUserMsg(UserSession, UserSession.MsgList.Strings[0]);
        if (nSendRetCode >= 0) then begin
          if nSendRetCode = 1 then begin
            UserSession.dwConnctCheckTick := GetTickCount();
            UserSession.MsgList.Delete(0);
            Continue;
          end;
          if UserSession.MsgList.Count > 100 then begin
            nMsgCount := 0;
            while nMsgCount <> 51 do begin
              UserSession.MsgList.Delete(0);
              Inc(nMsgCount);
            end;
          end;
          Inc(n456A2C, UserSession.MsgList.Count);
          MainOutMessage(UserSession.sIP +
            ' : ' +
            IntToStr(UserSession.MsgList.Count), 5);
          Inc(nSendMsgCount);
        end else begin //0x004523A4
          UserSession.SocketHandle := -1;
          UserSession.Socket := nil;
          UserSession.MsgList.Clear;
        end;
      end;
    end;
    if (GetTickCount - dwSendKeepAliveTick) > 2 * 1000 then begin
      dwSendKeepAliveTick := GetTickCount();
      if boGateReady then
        ClientSocket.Socket.SendText('%--$');
    end;
    if (GetTickCount - dwKeepAliveTick) > 10 * 1000 then begin
      boKeepAliveTimcOut := True;
      ClientSocket.Close;
    end;
  finally
    boDecodeLock := False;
  end;
  dwDecodeTime := GetTickCount - dwDecodeTick;
  if dwDecodeMsgTime < dwDecodeTime then dwDecodeMsgTime := dwDecodeTime;
  if dwDecodeMsgTime > 50 then Dec(dwDecodeMsgTime, 50);
end;

procedure TFrmMain.CloseSocket(nSocketHandle: Integer);
var
  nIndex: Integer;
  UserSession: pTUserSession;
begin
  for nIndex := 0 to GATEMAXSESSION - 1 do begin
    UserSession := @g_SessionArray[nIndex];
    if (UserSession.Socket <> nil) and (UserSession.SocketHandle = nSocketHandle) then begin
      UserSession.Socket.Close;
      break;
    end;
  end;
end;

function TFrmMain.CloseSocketAndGetIPAddr(nSocketHandle: Integer): string;
var
  nIndex: Integer;
  UserSession: pTUserSession;
begin
  Result := '';
  for nIndex := 0 to GATEMAXSESSION - 1 do begin
    UserSession := @g_SessionArray[nIndex];
    if (UserSession.Socket <> nil) and (UserSession.SocketHandle = nSocketHandle) then begin
      Result := UserSession.sRemoteIPaddr;
      UserSession.Socket.Close;
      break;
    end;
  end;
end;

function TFrmMain.SendUserMsg(UserSession: pTUserSession; sSendMsg: string): Integer;
begin
  Result := -1;
  if UserSession.Socket <> nil then begin
    if not UserSession.bo0C then begin
      if not UserSession.boSendAvailable and (GetTickCount > UserSession.dwSendLockTimeOut) then begin
        UserSession.boSendAvailable := True;
        UserSession.nCheckSendLength := 0;
        boSendHoldTimeOut := True;
        dwSendHoldTick := GetTickCount();
      end; //004525DD
      if UserSession.boSendAvailable then begin
        if UserSession.nCheckSendLength >= 250 then begin
          if not UserSession.boSendCheck then begin
            UserSession.boSendCheck := True;
            sSendMsg := '*' + sSendMsg;
          end;
          if UserSession.nCheckSendLength >= 512 then begin
            UserSession.boSendAvailable := False;
            UserSession.dwSendLockTimeOut := GetTickCount + 3 * 1000;
          end;
        end; //00452620
        UserSession.Socket.SendText(sSendMsg);
        Inc(UserSession.nSendMsgLen, Length(sSendMsg));
        Inc(UserSession.nCheckSendLength, Length(sSendMsg));
        Result := 1;
      end else begin //0x0045264A
        Result := 0;
      end;
    end else begin //0x00452651
      Result := 0;
    end;
  end;
end;

procedure TFrmMain.LoadConfig;
var
  Conf: TIniFile;
  sConfigFileName: string;
begin
  sConfigFileName := '.\Config.ini';
  Conf := TIniFile.Create(sConfigFileName);
  TitleName := Conf.ReadString(GateClass, 'Title', TitleName);
  ServerPort := Conf.ReadInteger(GateClass, 'ServerPort', ServerPort);
  ServerAddr := Conf.ReadString(GateClass, 'ServerAddr', ServerAddr);
  GatePort := Conf.ReadInteger(GateClass, 'GatePort', GatePort);
  GateAddr := Conf.ReadString(GateClass, 'GateAddr', GateAddr);
  nShowLogLevel := Conf.ReadInteger(GateClass, 'ShowLogLevel', nShowLogLevel);
  BlockMethod := TBlockIPMethod(Conf.ReadInteger(GateClass, 'BlockMethod', Integer(BlockMethod)));
  if Conf.ReadInteger(GateClass, 'KeepConnectTimeOut', -1) <= 0 then
    Conf.WriteInteger(GateClass, 'KeepConnectTimeOut', dwKeepConnectTimeOut);

  if Conf.ReadInteger(GateClass, 'AttackLevel', -1) <= 0 then
    Conf.WriteInteger(GateClass, 'AttackLevel', nAttackLevel);

  nAttackLevel := Conf.ReadInteger(GateClass, 'AttackLevel', nAttackLevel);

  nMaxConnOfIPaddr := Conf.ReadInteger(GateClass, 'MaxConnOfIPaddr', nMaxConnOfIPaddr);
  dwKeepConnectTimeOut := Conf.ReadInteger(GateClass, 'KeepConnectTimeOut', dwKeepConnectTimeOut);
  g_boDynamicIPDisMode := Conf.ReadBool(GateClass, 'DynamicIPDisMode', g_boDynamicIPDisMode);
  Conf.Free;
  LoadBlockIPFile();
end;

procedure TFrmMain.StartService;
begin
  try
    MainOutMessage(g_sProductName, 0);
    MainOutMessage(g_sUpDateTime, 0);
    MainOutMessage(g_sWebSite, 0);
    MainOutMessage('正在启动服务...', 3);
    SendGameCenterMsg(SG_STARTNOW, g_sNowStartGate);
    //StatusBar.Panels[3].Text:=sVersion;
    boServiceStart := True;
    boGateReady := False;
    boServerReady := False;
    nSessionCount := 0;
    MENU_CONTROL_START.Enabled := False;
    MENU_CONTROL_STOP.Enabled := True;

    dwReConnectServerTick := GetTickCount - 25 * 1000;
    boKeepAliveTimcOut := False;
    nSendMsgCount := 0;
    n456A2C := 0;
    dwSendKeepAliveTick := GetTickCount();
    boSendHoldTimeOut := False;
    dwSendHoldTick := GetTickCount();

    CurrIPaddrList := TGList.Create;
    BlockIPList := TGList.Create;
    TempBlockIPList := TGList.Create;
    AttackIPaddrList := TGList.Create;
    ClientSockeMsgList := TStringList.Create;

    ResUserSessionArray();
    LoadConfig();
    Caption := GateName + ' - ' + TitleName;
    ClientSocket.Active := False;
    ClientSocket.Host := ServerAddr;
    ClientSocket.Port := ServerPort;
    ClientSocket.Active := True;

    ServerSocket.Active := False;
    ServerSocket.Address := GateAddr;
    ServerSocket.Port := GatePort;
    ServerSocket.Active := True;

    SendTimer.Enabled := True;
    MainOutMessage('启动服务完成...', 3);
    SendGameCenterMsg(SG_STARTOK, g_sNowStartOK);
  except
    on E: Exception do begin
      MENU_CONTROL_START.Enabled := True;
      MENU_CONTROL_STOP.Enabled := False;
      MainOutMessage(E.Message, 0);
    end;
  end;
end;

procedure TFrmMain.StopService;
var
  I, II: Integer;
  nSockIdx: Integer;
  IPaddr: pTSockaddr;
  IPList: TList;
begin
  MainOutMessage('正在停止服务...', 3);
  boServiceStart := False;
  boGateReady := False;
  MENU_CONTROL_START.Enabled := True;
  MENU_CONTROL_STOP.Enabled := False;
  SendTimer.Enabled := False;
  for nSockIdx := 0 to GATEMAXSESSION - 1 do begin
    if g_SessionArray[nSockIdx].Socket <> nil then
      g_SessionArray[nSockIdx].Socket.Close;
  end;
  SaveBlockIPList();
  ServerSocket.Close;
  ClientSocket.Close;
  ClientSockeMsgList.Free;

  CurrIPaddrList.Lock;
  try
    for I := 0 to CurrIPaddrList.Count - 1 do begin
      IPList := TList(CurrIPaddrList.Items[I]);
      if IPList <> nil then begin
        for II := 0 to IPList.Count - 1 do begin
          if pTSockaddr(IPList.Items[II]) <> nil then
            Dispose(pTSockaddr(IPList.Items[II]));
        end;
        IPList.Free;
      end;
    end;
  finally
    CurrIPaddrList.UnLock;
    CurrIPaddrList.Free;
  end;

  BlockIPList.Lock;
  try
    for I := 0 to BlockIPList.Count - 1 do begin
      IPaddr := pTSockaddr(BlockIPList.Items[I]);
      Dispose(IPaddr);
    end;
  finally
    BlockIPList.UnLock;
    BlockIPList.Free;
  end;

  TempBlockIPList.Lock;
  try
    for I := 0 to TempBlockIPList.Count - 1 do begin
      IPaddr := pTSockaddr(TempBlockIPList.Items[I]);
      Dispose(IPaddr);
    end;
  finally
    TempBlockIPList.UnLock;
    TempBlockIPList.Free;
  end;

  AttackIPaddrList.Lock;
  try
    for I := 0 to AttackIPaddrList.Count - 1 do begin
      IPaddr := pTSockaddr(AttackIPaddrList.Items[I]);
      Dispose(IPaddr);
    end;
  finally
    AttackIPaddrList.UnLock;
    AttackIPaddrList.Free;
  end;

  MainOutMessage('停止服务完成...', 3);
end;

procedure TFrmMain.ResUserSessionArray;
var
  UserSession: pTUserSession;
  nIndex: Integer;
begin
  for nIndex := 0 to GATEMAXSESSION - 1 do begin
    UserSession := @g_SessionArray[nIndex];
    UserSession.Socket := nil;
    UserSession.sRemoteIPaddr := '';
    UserSession.SocketHandle := -1;
    UserSession.MsgList.Clear;
  end;
end;
procedure TFrmMain.IniUserSessionArray();
var
  UserSession: pTUserSession;
  nIndex: Integer;
begin
  for nIndex := 0 to GATEMAXSESSION - 1 do begin
    UserSession := @g_SessionArray[nIndex];
    UserSession.Socket := nil;
    UserSession.sRemoteIPaddr := '';
    UserSession.nSendMsgLen := 0;
    UserSession.bo0C := False;
    UserSession.dw10Tick := GetTickCount();
    UserSession.boSendAvailable := True;
    UserSession.boSendCheck := False;
    UserSession.nCheckSendLength := 0;
    UserSession.n20 := 0;
    UserSession.dwUserTimeOutTick := GetTickCount();
    UserSession.SocketHandle := -1;
    UserSession.dwReceiveTick := GetTickCount();
    UserSession.MsgList := TStringList.Create;
  end;
end;

procedure TFrmMain.StartTimerTimer(Sender: TObject);
begin
  if boStarted then begin
    StartTimer.Enabled := False;
    StopService();
    boClose := True;
    Close;
  end else begin
    MENU_VIEW_LOGMSGClick(Sender);
    boStarted := True;
    StartTimer.Enabled := False;
    StartService();
  end;
end;

procedure TFrmMain.FormCreate(Sender: TObject);
var
  nX, nY: Integer;
begin
  g_dwGameCenterHandle := Str_ToInt(ParamStr(1), 0);
  nX := Str_ToInt(ParamStr(2), -1);
  nY := Str_ToInt(ParamStr(3), -1);
  if (nX >= 0) or (nY >= 0) then begin
    Left := nX;
    Top := nY;
  end;
  TempLogList := TStringList.Create;
  StringList30C := TStringList.Create;
  StringList318 := TStringList.Create;
  dwDecodeMsgTime := 0;
  SendGameCenterMsg(SG_FORMHANDLE, IntToStr(Self.Handle));
  IniUserSessionArray();
end;

procedure TFrmMain.MENU_CONTROL_STARTClick(Sender: TObject);
begin
  StartService();
end;

procedure TFrmMain.MENU_CONTROL_STOPClick(Sender: TObject);
begin
  if Application.MessageBox('是否确认停止服务？',
    '确认信息',
    MB_YESNO + MB_ICONQUESTION) = IDYES then
    StopService();
end;

procedure TFrmMain.MENU_CONTROL_RECONNECTClick(Sender: TObject);
begin
  dwReConnectServerTick := 0;
end;

procedure TFrmMain.MENU_CONTROL_CLEAELOGClick(Sender: TObject);
begin
  if Application.MessageBox('是否确认清除显示的日志信息？',
    '确认信息',
    MB_OKCANCEL + MB_ICONQUESTION
    ) <> IDOK then Exit;
  MemoLog.Clear;
end;

procedure TFrmMain.MENU_CONTROL_EXITClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmMain.MENU_VIEW_LOGMSGClick(Sender: TObject);
begin
  MENU_VIEW_LOGMSG.Checked := not MENU_VIEW_LOGMSG.Checked;
  ShowLogMsg(MENU_VIEW_LOGMSG.Checked);
end;

procedure TFrmMain.ShowLogMsg(boFlag: Boolean);
var
  nHeight: Integer;
begin
  case boFlag of
    True: begin
        nHeight := Panel.Height;
        Panel.Height := 0;
        MemoLog.Height := nHeight;
        MemoLog.Top := Panel.Top;
      end;
    False: begin
        nHeight := MemoLog.Height;
        MemoLog.Height := 0;
        Panel.Height := nHeight;
      end;
  end;
end;

procedure TFrmMain.MENU_OPTION_GENERALClick(Sender: TObject);
begin
  frmGeneralConfig.Top := Self.Top + 20;
  frmGeneralConfig.Left := Self.Left;
  with frmGeneralConfig do begin
    EditGateIPaddr.Text := GateAddr;
    EditGatePort.Text := IntToStr(GatePort);
    EditServerIPaddr.Text := ServerAddr;
    EditServerPort.Text := IntToStr(ServerPort);
    EditTitle.Text := TitleName;
    TrackBarLogLevel.Position := nShowLogLevel;
  end;
  frmGeneralConfig.ShowModal;
end;

procedure TFrmMain.CloseConnect(sIPaddr: string);
var
  I: Integer;
  boCheck: Boolean;
begin
  if ServerSocket.Active then
    while (True) do begin
      boCheck := False;
      for I := 0 to ServerSocket.Socket.ActiveConnections - 1 do begin
        if sIPaddr = ServerSocket.Socket.Connections[I].RemoteAddress then begin
          ServerSocket.Socket.Connections[I].Close;
          boCheck := True;
          break;
        end;
      end;
      if not boCheck then break;
    end;
end;

procedure TFrmMain.MENU_OPTION_IPFILTERClick(Sender: TObject);
var
  I: Integer;
  sIPaddr: string;
begin
  frmIPaddrFilter.Top := Self.Top + 20;
  frmIPaddrFilter.Left := Self.Left;
  frmIPaddrFilter.ListBoxActiveList.Clear;
  frmIPaddrFilter.ListBoxTempList.Clear;
  frmIPaddrFilter.ListBoxBlockList.Clear;
  if ServerSocket.Active then
    for I := 0 to ServerSocket.Socket.ActiveConnections - 1 do begin
      sIPaddr := ServerSocket.Socket.Connections[I].RemoteAddress;
      if sIPaddr <> '' then
        frmIPaddrFilter.ListBoxActiveList.Items.AddObject(sIPaddr, TObject(ServerSocket.Socket.Connections[I]));
    end;

  for I := 0 to TempBlockIPList.Count - 1 do begin
    frmIPaddrFilter.ListBoxTempList.Items.Add(StrPas(inet_ntoa(TInAddr(pTSockaddr(TempBlockIPList.Items[I]).nIPaddr))));
  end;
  for I := 0 to BlockIPList.Count - 1 do begin
    frmIPaddrFilter.ListBoxBlockList.Items.Add(StrPas(inet_ntoa(TInAddr(pTSockaddr(BlockIPList.Items[I]).nIPaddr))));
  end;
  frmIPaddrFilter.TrackBarAttack.Position := nAttackLevel;
  frmIPaddrFilter.EditMaxConnect.Value := nMaxConnOfIPaddr;
  case BlockMethod of
    mDisconnect: frmIPaddrFilter.RadioDisConnect.Checked := True;
    mBlock: frmIPaddrFilter.RadioAddTempList.Checked := True;
    mBlockList: frmIPaddrFilter.RadioAddBlockList.Checked := True;
  end;
  frmIPaddrFilter.ShowModal;
end;

function TFrmMain.IsBlockIP(sIPaddr: string): Boolean;
var
  I: Integer;
  IPaddr: pTSockaddr;
  nIPaddr: Integer;
begin
  Result := False;
  TempBlockIPList.Lock;
  try
    nIPaddr := inet_addr(PChar(sIPaddr));
    for I := 0 to TempBlockIPList.Count - 1 do begin
      IPaddr := pTSockaddr(TempBlockIPList.Items[I]);
      if IPaddr.nIPaddr = nIPaddr then begin
        Result := True;
        break;
      end;
    end;
  finally
    TempBlockIPList.UnLock;
  end;
  //-------------------------------
  if not Result then begin
    BlockIPList.Lock;
    try
      for I := 0 to BlockIPList.Count - 1 do begin
        IPaddr := pTSockaddr(BlockIPList.Items[I]);
        if IPaddr.nIPaddr = nIPaddr then begin
          Result := True;
          break;
        end;
      end;
    finally
      BlockIPList.UnLock;
    end;
  end;
end;

function TFrmMain.AddBlockIP(sIPaddr: string): Integer;
var
  I: Integer;
  IPaddr: pTSockaddr;
  nIPaddr: Integer;
begin
  BlockIPList.Lock;
  try
    Result := 0;
    nIPaddr := inet_addr(PChar(sIPaddr));
    for I := 0 to BlockIPList.Count - 1 do begin
      IPaddr := pTSockaddr(BlockIPList.Items[I]);
      if IPaddr.nIPaddr = nIPaddr then begin
        Result := BlockIPList.Count;
        break;
      end;
    end;
    if Result <= 0 then begin
      New(IPaddr);
      IPaddr^.nIPaddr := nIPaddr;
      BlockIPList.Add(IPaddr);
      Result := BlockIPList.Count;
    end;
  finally
    BlockIPList.UnLock;
  end;
end;

function TFrmMain.AddTempBlockIP(sIPaddr: string): Integer;
var
  I: Integer;
  IPaddr: pTSockaddr;
  nIPaddr: Integer;
begin
  TempBlockIPList.Lock;
  try
    Result := 0;
    nIPaddr := inet_addr(PChar(sIPaddr));
    for I := 0 to TempBlockIPList.Count - 1 do begin
      IPaddr := pTSockaddr(TempBlockIPList.Items[I]);
      if IPaddr.nIPaddr = nIPaddr then begin
        Result := TempBlockIPList.Count;
        break;
      end;
    end;
    if Result <= 0 then begin
      New(IPaddr);
      IPaddr^.nIPaddr := nIPaddr;
      TempBlockIPList.Add(IPaddr);
      Result := TempBlockIPList.Count;
    end;
  finally
    TempBlockIPList.UnLock;
  end;
end;

function TFrmMain.AddAttackIP(sIPaddr: string): Boolean;
var
  I: Integer;
  IPaddr, AddIPaddr: pTSockaddr;
  nIPaddr: Integer;
  bo01: Boolean;
begin
  AttackIPaddrList.Lock;
  try
    Result := False;
    if nAttackLevel > 0 then begin
      bo01 := False;
      nIPaddr := inet_addr(PChar(sIPaddr));
      for I := AttackIPaddrList.Count - 1 downto 0 do begin
        IPaddr := pTSockaddr(AttackIPaddrList.Items[I]);
        if IPaddr.nIPaddr = nIPaddr then begin
          if (GetTickCount - IPaddr.dwStartAttackTick) <= dwAttackTick * nAttackLevel then begin
            IPaddr.dwStartAttackTick := GetTickCount;
            Inc(IPaddr.nAttackCount);
            //MainOutMessage('IPaddr.nAttackCount: '+IntToStr(IPaddr.nAttackCount), 0);
            if IPaddr.nAttackCount >= nAttackCount * nAttackLevel then begin
              Dispose(IPaddr);
              AttackIPaddrList.Delete(I);
              Result := True;
            end;
          end else begin
            if IPaddr.nAttackCount > nAttackCount * nAttackLevel then begin
              Result := True;
            end;
            Dispose(IPaddr);
            AttackIPaddrList.Delete(I);
          end;
          bo01 := True;
          break;
        end;
      end;
      if not bo01 then begin
        New(AddIPaddr);
        FillChar(AddIPaddr^, SizeOf(TSockaddr), 0);
        AddIPaddr^.nIPaddr := nIPaddr;
        AddIPaddr^.dwStartAttackTick := GetTickCount;
        AddIPaddr^.nAttackCount := 0;
        AttackIPaddrList.Add(AddIPaddr);
      end;
    end;
  finally
    AttackIPaddrList.UnLock;
  end;
end;

function TFrmMain.IsConnLimited(sIPaddr: string): Boolean;
var
  I: Integer;
  IPaddr, AttackIPaddr: pTSockaddr;
  nIPaddr: Integer;
  bo01: Boolean;
  IPList: TList;
begin
  CurrIPaddrList.Lock;
  try
    Result := False;
    if nAttackLevel > 0 then begin
      bo01 := False;
      nIPaddr := inet_addr(PChar(sIPaddr));
      for I := 0 to CurrIPaddrList.Count - 1 do begin
        IPList := TList(CurrIPaddrList.Items[I]);
        if IPList <> nil then begin
          IPaddr := pTSockaddr(IPList.Items[0]);
          if IPaddr <> nil then begin
            if IPaddr.nIPaddr = nIPaddr then begin
              bo01 := True;
              Result := AddAttackIP(sIPaddr);
              New(AttackIPaddr);
              FillChar(AttackIPaddr^, SizeOf(TSockaddr), 0);
              AttackIPaddr^.nIPaddr := nIPaddr;
              IPList.Add(AttackIPaddr);
              if IPList.Count > nMaxConnOfIPaddr * nAttackLevel then Result := True;
              break;
            end;
          end;
        end;
      end;
      if not bo01 then begin
        IPList := nil;
        New(IPaddr);
        FillChar(IPaddr^, SizeOf(TSockaddr), 0);
        IPaddr^.nIPaddr := nIPaddr;
        IPList := TList.Create;
        IPList.Add(IPaddr);
        CurrIPaddrList.Add(IPList);
      end;
    end;
  finally
    CurrIPaddrList.UnLock;
  end;
end;

procedure TFrmMain.ShowMainLogMsg;
var
  I: Integer;
begin
  if (GetTickCount - dwShowMainLogTick) < 200 then Exit;
  dwShowMainLogTick := GetTickCount();
  try
    boShowLocked := True;
    try
      CS_MainLog.Enter;
      for I := 0 to MainLogMsgList.Count - 1 do begin
        TempLogList.Add(MainLogMsgList.Strings[I]);
      end;
      MainLogMsgList.Clear;
    finally
      CS_MainLog.Leave;
    end;
    for I := 0 to TempLogList.Count - 1 do begin
      MemoLog.Lines.Add(TempLogList.Strings[I]);
    end;
    TempLogList.Clear;
  finally
    boShowLocked := False;
  end;
end;

procedure TFrmMain.MyMessage(var MsgData: TWmCopyData);
var
  sData: string;
  wIdent: Word;
begin
  wIdent := HiWord(MsgData.From);
  sData := StrPas(MsgData.CopyDataStruct^.lpData);
  case wIdent of
    GS_QUIT: begin
        if boServiceStart then begin
          StartTimer.Enabled := True;
        end else begin
          boClose := True;
          Close();
        end;
      end;
    1: ;
    2: ;
    3: ;
  end;
end;

procedure TFrmMain.S1Click(Sender: TObject);
begin
  MainOutMessage(g_sProductName, 0);
  MainOutMessage(g_sUpDateTime, 0);
  MainOutMessage(g_sWebSite, 0);
end;

end.


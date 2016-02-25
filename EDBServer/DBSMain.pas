unit DBSMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls, ExtCtrls, JSocket, Buttons, IniFiles,
  Menus, Grobal2, HumDB, DBShare, ComCtrls, ActnList, AppEvnts, DB,
  DBTables, Common;
type
  TServerInfo = record
    nSckHandle: Integer; //0x00
    sStr: string; //0x04
    bo08: Boolean; //0x08
    Socket: TCustomWinSocket; //0x0C
  end;
  pTServerInfo = ^TServerInfo;
  THumSession = record
    sChrName: string[14];
    nIndex: Integer;
    Socket: TCustomWinSocket; //0x20
    bo24: Boolean;
    bo2C: Boolean;
    dwTick30: LongWord;
  end;
  pTHumSession = ^THumSession;
  TLoadHuman = record
    sAccount: string[12];
    sChrName: string[14];
    sUserAddr: string[15];
    nSessionID: Integer;
  end;
  TFrmDBSrv = class(TForm)
    ServerSocket: TServerSocket;
    Timer1: TTimer;
    AniTimer: TTimer;
    StartTimer: TTimer;
    Timer2: TTimer;
    MemoLog: TMemo;
    Panel1: TPanel;
    Label1: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    LbAutoClean: TLabel;
    Panel2: TPanel;
    LbTransCount: TLabel;
    Label2: TLabel;
    Label6: TLabel;
    LbUserCount: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    CkViewHackMsg: TCheckBox;
    MainMenu: TMainMenu;
    MENU_CONTROL: TMenuItem;
    MENU_OPTION: TMenuItem;
    MENU_MANAGE: TMenuItem;
    MENU_OPTION_GENERAL: TMenuItem;
    MENU_OPTION_GAMEGATE: TMenuItem;
    MENU_CONTROL_START: TMenuItem;
    T1: TMenuItem;
    N1: TMenuItem;
    G1: TMenuItem;
    MENU_MANAGE_DATA: TMenuItem;
    MENU_MANAGE_TOOL: TMenuItem;
    MENU_TEST: TMenuItem;
    MENU_TEST_SELGATE: TMenuItem;
    ApplicationEvents1: TApplicationEvents;
    N2: TMenuItem;
    N3: TMenuItem;
    X1: TMenuItem;
    Query: TQuery;
    DataSource: TDataSource;
    BtnUserDBTool: TSpeedButton;
    BtnReloadAddr: TButton;
    BtnEditAddrs: TButton;
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure AniTimerTimer(Sender: TObject);
    procedure StartTimerTimer(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure BtnUserDBToolClick(Sender: TObject);
    procedure CkViewHackMsgClick(Sender: TObject);
    procedure ServerSocketClientConnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ServerSocketClientDisconnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ServerSocketClientError(Sender: TObject;
      Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
      var ErrorCode: Integer);
    procedure ServerSocketClientRead(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure MENU_MANAGE_DATAClick(Sender: TObject);
    procedure MENU_MANAGE_TOOLClick(Sender: TObject);
    procedure MENU_TEST_SELGATEClick(Sender: TObject);
    procedure MENU_CONTROL_STARTClick(Sender: TObject);
    procedure G1Click(Sender: TObject);
    procedure ApplicationEvents1Exception(Sender: TObject; E: Exception);
    procedure X1Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure MENU_OPTION_GENERALClick(Sender: TObject);
    procedure BtnReloadAddrClick(Sender: TObject);
    procedure BtnEditAddrsClick(Sender: TObject);
  private
    n334: Integer;
    m_DefMsg: TDefaultMessage;
    n344: Integer;
    n348: Integer;
    s34C: string;
    ServerList: TList; //0x354
    HumSessionList: TList; //0x358
    m_boRemoteClose: Boolean;
    procedure ProcessServerPacket(ServerInfo: pTServerInfo);
    procedure ProcessServerMsg(sMsg: string; nLen: Integer;
      Socket: TCustomWinSocket);
    procedure SendSocket(Socket: TCustomWinSocket; sMsg: string);
    procedure LoadHumanRcd(sMsg: string; Socket: TCustomWinSocket);
    procedure SaveHumanRcd(nRecog: Integer; sMsg: string;
      Socket: TCustomWinSocket);
    procedure SaveHumanRcdEx(sMsg: string; nRecog: Integer;
      Socket: TCustomWinSocket);
    procedure ClearSocket(Socket: TCustomWinSocket);

    function LoadItemsDB(): Integer;
    function LoadMagicDB(): Integer;
    { Private declarations }
  public
    function CopyHumData(sSrcChrName, sDestChrName, sUserId: string): Boolean;
    procedure DelHum(sChrName: string);
    procedure MyMessage(var MsgData: TWmCopyData); message WM_COPYDATA;
    { Public declarations }
  end;

var
  FrmDBSrv: TFrmDBSrv;
implementation
uses FIDHum, UsrSoc, AddrEdit, HUtil32, EDcode,
  IDSocCli, DBTools, TestSelGate, RouteManage, Setting;

{$R *.DFM}
procedure TFrmDBSrv.ServerSocketClientConnect(Sender: TObject;
  Socket: TCustomWinSocket);
var
  ServerInfo: pTServerInfo;
  sIPaddr: string;
begin
  sIPaddr := Socket.RemoteAddress;
  if not CheckServerIP(sIPaddr) then begin
    MainOutMessage('非法服务器连接: ' + sIPaddr);
    Socket.Close;
    Exit;
  end;
  Server_sRemoteAddress := sIPaddr;
  Server_nRemotePort := Socket.RemotePort;
  ServerSocketClientConnected := True;
  //MainOutMessage('ServerSocketClientConnect' + sIPaddr);
  if not boOpenDBBusy then begin
    New(ServerInfo);
    ServerInfo.bo08 := True;
    ServerInfo.nSckHandle := Socket.SocketHandle;
    ServerInfo.sStr := '';
    ServerInfo.Socket := Socket;
    ServerList.Add(ServerInfo);
  end else begin
    Socket.Close;
  end;
end;

procedure TFrmDBSrv.ServerSocketClientDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
var
  i: Integer;
  ServerInfo: pTServerInfo;
begin
  for i := 0 to ServerList.Count - 1 do begin
    ServerInfo := ServerList.Items[i];
    if ServerInfo.nSckHandle = Socket.SocketHandle then begin
      Dispose(ServerInfo);
      ServerList.Delete(i);
      ClearSocket(Socket);
      break;
    end;
  end;
end;

procedure TFrmDBSrv.ServerSocketClientError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
  ErrorCode := 0;
  Socket.Close;
  ServerSocketClientConnected := False;
end;

procedure TFrmDBSrv.ServerSocketClientRead(Sender: TObject;
  Socket: TCustomWinSocket);
var
  i: Integer;
  ServerInfo: pTServerInfo;
  s10: string;
begin
  dwKeepServerAliveTick := GetTickCount;
  g_CheckCode.dwThread0 := 1001000;
  for i := 0 to ServerList.Count - 1 do begin
    g_CheckCode.dwThread0 := 1001001;
    ServerInfo := ServerList.Items[i];
    g_CheckCode.dwThread0 := 1001002;
    if ServerInfo.nSckHandle = Socket.SocketHandle then begin
      g_CheckCode.dwThread0 := 1001003;
      s10 := Socket.ReceiveText;
      Inc(n4ADBF4);
      if s10 <> '' then begin
        g_CheckCode.dwThread0 := 1001004;
        ServerInfo.sStr := ServerInfo.sStr + s10;
        g_CheckCode.dwThread0 := 1001005;
        if Pos('!', s10) > 0 then begin
          g_CheckCode.dwThread0 := 1001006;
          ProcessServerPacket(ServerInfo);
          g_CheckCode.dwThread0 := 1001007;
          Inc(n4ADBF8);
          Inc(n348);
          break;
        end else begin //004A7DC7
          if Length(ServerInfo.sStr) > 81920 then begin
            ServerInfo.sStr := '';
            Inc(n4ADC2C);
          end;
        end;
      end;
      break;
    end;
  end;
  g_CheckCode.dwThread0 := 1001008;
end;

procedure TFrmDBSrv.ProcessServerPacket(ServerInfo: pTServerInfo);
var
  bo25: Boolean;
  SC, s1C, s20, s24: string;
  n14, n18: Integer;
  wE, w10: Word;
  DefMsg: TDefaultMessage;
begin
  g_CheckCode.dwThread0 := 1001100;
  if boOpenDBBusy then Exit;
  try
    bo25 := False;
    s1C := ServerInfo.sStr;
    ServerInfo.sStr := '';
    s20 := '';
    g_CheckCode.dwThread0 := 1001101;
    s1C := ArrestStringEx(s1C, '#', '!', s20);
    g_CheckCode.dwThread0 := 1001102;
    if s20 <> '' then begin
      g_CheckCode.dwThread0 := 1001103;
      s20 := GetValidStr3(s20, s24, ['/']);
      n14 := Length(s20);
      if (n14 >= DEFBLOCKSIZE) and (s24 <> '') then begin
        wE := Str_ToInt(s24, 0) xor 170;
        w10 := n14;
        n18 := MakeLong(wE, w10);
        SC := EncodeBuffer(@n18, SizeOf(Integer));
        s34C := s24;
        if CompareBackLStr(s20, SC, Length(SC)) then begin
          g_CheckCode.dwThread0 := 1001104;
          ProcessServerMsg(s20, n14, ServerInfo.Socket);
          g_CheckCode.dwThread0 := 1001105;
          bo25 := True;
        end;
      end; //0x004A7F7B
    end; //0x004A7F7B
    if s1C <> '' then begin
      Inc(n4ADC00);
      Label4.Caption := 'Error ' + IntToStr(n4ADC00);
    end; //0x004A7FB5
    if not bo25 then begin
      m_DefMsg := MakeDefaultMsg(DBR_FAIL, 0, 0, 0, 0);
      {
      DefMsg:=MakeDefaultMsg(DBR_FAIL,0,0,0,0);
      n338:=DefMsg.Recog;
      n33C:=DefMsg.Ident;
      n340:=DefMsg.Tag;
      }
      SendSocket(ServerInfo.Socket, EncodeMessage(m_DefMsg));
      Inc(n4ADC00);
      Label4.Caption := 'Error ' + IntToStr(n4ADC00);
    end;
  finally
  end;
  g_CheckCode.dwThread0 := 1001106;
end;

procedure TFrmDBSrv.SendSocket(Socket: TCustomWinSocket; sMsg: string); //0x004A8764
var
  n10: Integer;
  s18: string;
begin
  Inc(n4ADBFC);
  n10 := MakeLong(Str_ToInt(s34C, 0) xor 170, Length(sMsg) + 6);
  s18 := EncodeBuffer(@n10, SizeOf(Integer));
  Socket.SendText('#' + s34C + '/' + sMsg + s18 + '!')
end;

procedure TFrmDBSrv.ProcessServerMsg(sMsg: string; nLen: Integer; Socket: TCustomWinSocket); //0x004A9278
var
  sDefMsg, sData: string;
  DefMsg: TDefaultMessage;
begin
  if nLen = DEFBLOCKSIZE then begin
    sDefMsg := sMsg;
    sData := '';
  end else begin
    sDefMsg := Copy(sMsg, 1, DEFBLOCKSIZE);
    sData := Copy(sMsg, DEFBLOCKSIZE + 1, Length(sMsg) - DEFBLOCKSIZE - 6);
  end; //0x004A9304
  DefMsg := DecodeMessage(sDefMsg);
  //MemoLog.Lines.Add('DefMsg.Ident ' + IntToStr(DefMsg.Ident));
  case DefMsg.Ident of
    DB_LOADHUMANRCD: begin
        LoadHumanRcd(sData, Socket);
      end;
    DB_SAVEHUMANRCD: begin
        SaveHumanRcd(DefMsg.Recog, sData, Socket);
      end;
    DB_SAVEHUMANRCDEX: begin
        SaveHumanRcdEx(sData, DefMsg.Recog, Socket);
      end;
    else begin
        m_DefMsg := MakeDefaultMsg(DBR_FAIL, 0, 0, 0, 0);
        SendSocket(Socket, EncodeMessage(m_DefMsg));
        Inc(n4ADC04);
        MemoLog.Lines.Add('Fail ' + IntToStr(n4ADC04));
      end;
  end;
  g_CheckCode.dwThread0 := 1001216;
end;

procedure TFrmDBSrv.LoadHumanRcd(sMsg: string; Socket: TCustomWinSocket);
var
  sHumName: string;
  sAccount: string;
  sIPaddr: string;
  nIndex: Integer;
  nSessionID: Integer;
  nCheckCode: Integer;
  DefMsg: TDefaultMessage;
  HumanRCD: THumDataInfo;
  LoadHuman: TLoadHuman;
  boFoundSession: Boolean;
begin
  DecodeBuffer(sMsg, @LoadHuman, SizeOf(TLoadHuman));
  sAccount := LoadHuman.sAccount;
  sHumName := LoadHuman.sChrName;
  sIPaddr := LoadHuman.sUserAddr;
  nSessionID := LoadHuman.nSessionID;
  nCheckCode := -1;
  if (sAccount <> '') and (sHumName <> '') then begin
    if (FrmIDSoc.CheckSessionLoadRcd(sAccount, sIPaddr, nSessionID, boFoundSession)) then begin
      nCheckCode := 1;
    end else begin
      if boFoundSession then begin
        MainOutMessage('[非法重复请求] ' + '帐号: ' + sAccount + ' IP: ' + sIPaddr + ' 标识: ' + IntToStr(nSessionID));
      end else begin
        MainOutMessage('[非法请求] ' + '帐号: ' + sAccount + ' IP: ' + sIPaddr + ' 标识: ' + IntToStr(nSessionID));
      end;
      //nCheckCode:= 1; //测试用，正常去掉
    end;
  end;
  if nCheckCode = 1 then begin
    try
      if HumDataDB.OpenEx then begin
        nIndex := HumDataDB.Index(sHumName);
        if nIndex >= 0 then begin
          if HumDataDB.Get(nIndex, HumanRCD) < 0 then nCheckCode := -2;
        end else nCheckCode := -3;
      end else nCheckCode := -4;
    finally
      HumDataDB.Close();
    end;
  end;
  if nCheckCode = 1 then begin
    m_DefMsg := MakeDefaultMsg(DBR_LOADHUMANRCD, 1, 0, 0, 1);
    SendSocket(Socket, EncodeMessage(m_DefMsg) + EncodeString(sHumName) + '/' + EncodeBuffer(@HumanRCD, SizeOf(THumDataInfo)));
  end else begin
    m_DefMsg := MakeDefaultMsg(DBR_LOADHUMANRCD, nCheckCode, 0, 0, 0);
    SendSocket(Socket, EncodeMessage(m_DefMsg));
  end;
end;

procedure TFrmDBSrv.SaveHumanRcd(nRecog: Integer; sMsg: string; Socket: TCustomWinSocket);
var
  sChrName: string;
  sUserId: string;
  sHumanRCD: string;
  i: Integer;
  nIndex: Integer;
  bo21: Boolean;
  DefMsg: TDefaultMessage;
  HumanRCD: THumDataInfo;
  HumSession: pTHumSession;
begin
  sHumanRCD := GetValidStr3(sMsg, sUserId, ['/']);
  sHumanRCD := GetValidStr3(sHumanRCD, sChrName, ['/']);
  sUserId := DecodeString(sUserId);
  sChrName := DecodeString(sChrName);
  bo21 := False;
  FillChar(HumanRCD.Data, SizeOf(THumData), #0);
  if Length(sHumanRCD) = GetCodeMsgSize(SizeOf(THumDataInfo) * 4 / 3) then
    DecodeBuffer(sHumanRCD, @HumanRCD, SizeOf(THumDataInfo))
  else bo21 := True;
  if not bo21 then begin
    bo21 := True;
    try
      if HumDataDB.Open then begin
        nIndex := HumDataDB.Index(sChrName);
        if nIndex < 0 then begin
          HumanRCD.Header.sName := sChrName;
          HumDataDB.Add(HumanRCD);
          nIndex := HumDataDB.Index(sChrName);
        end;
        if nIndex >= 0 then begin
          HumanRCD.Header.sName := sChrName;
          HumDataDB.Update(nIndex, HumanRCD);
          bo21 := False;
        end;
      end;
    finally
      HumDataDB.Close;
    end;
    FrmIDSoc.SetSessionSaveRcd(sUserId);
  end;
  if not bo21 then begin
    for i := 0 to HumSessionList.Count - 1 do begin
      HumSession := HumSessionList.Items[i];
      if (HumSession.sChrName = sChrName) and (HumSession.nIndex = nRecog) then begin
        HumSession.dwTick30 := GetTickCount();
        break;
      end;
    end;
    m_DefMsg := MakeDefaultMsg(DBR_SAVEHUMANRCD, 1, 0, 0, 0);
    SendSocket(Socket, EncodeMessage(m_DefMsg));
  end else begin
    m_DefMsg := MakeDefaultMsg(DBR_LOADHUMANRCD, 0, 0, 0, 0);
    SendSocket(Socket, EncodeMessage(m_DefMsg));
  end;
end;

procedure TFrmDBSrv.SaveHumanRcdEx(sMsg: string; nRecog: Integer; Socket: TCustomWinSocket);
var
  sChrName: string;
  sUserId: string;
  sHumanRCD: string;
  i: Integer;
  bo21: Boolean;
  DefMsg: TDefaultMessage;
  HumanRCD: THumDataInfo;
  HumSession: pTHumSession;
begin
  sHumanRCD := GetValidStr3(sMsg, sUserId, ['/']);
  sHumanRCD := GetValidStr3(sHumanRCD, sChrName, ['/']);
  sUserId := DecodeString(sUserId);
  sChrName := DecodeString(sChrName);
  for i := 0 to HumSessionList.Count - 1 do begin
    HumSession := HumSessionList.Items[i];
    if (HumSession.sChrName = sChrName) and (HumSession.nIndex = nRecog) then begin
      HumSession.bo24 := False;
      HumSession.Socket := Socket;
      HumSession.bo2C := True;
      HumSession.dwTick30 := GetTickCount();
      break;
    end;
  end;
  SaveHumanRcd(nRecog, sMsg, Socket);
end;

procedure TFrmDBSrv.Timer1Timer(Sender: TObject);
var
  i: Integer;
begin
  LbTransCount.Caption := IntToStr(n348);
  n348 := 0;
  if ServerList.Count > 0 then
    Label1.Caption := '已连接...'
  else Label1.Caption := '未连接 !!';
  Label2.Caption := '连接数: ' + IntToStr(ServerList.Count);
  LbUserCount.Caption := IntToStr(FrmUserSoc.GetUserCount);
  if boOpenDBBusy then begin
    if n4ADB18 > 0 then begin
      if not bo4ADB1C then begin
        Label4.Caption := '[1/4] ' + IntToStr(ROUND((n4ADB10 / n4ADB18) * 1.0E2)) + '% ' +
          IntToStr(n4ADB14) + '/' +
          IntToStr(n4ADB18);
      end;
    end;
    if n4ADB04 > 0 then begin
      if not boHumDBReady then begin
        Label4.Caption := '[3/4] ' + IntToStr(ROUND((n4ADAFC / n4ADB04) * 1.0E2)) + '% ' +
          IntToStr(n4ADB00) + '/' +
          IntToStr(n4ADB04);
      end;
    end;
    if n4ADAF0 > 0 then begin
      if not boDataDBReady then begin
        Label4.Caption := '[4/4] ' + IntToStr(ROUND((n4ADAE4 / n4ADAF0) * 1.0E2)) + '% ' +
          IntToStr(n4ADAE8) + '/' +
          IntToStr(n4ADAEC) + '/' +
          IntToStr(n4ADAF0);
      end;
    end;
  end;

  LbAutoClean.Caption := IntToStr(g_nClearIndex) + '/(' + IntToStr(g_nClearCount) + '/' + IntToStr(g_nClearItemIndexCount) + ')/' + IntToStr(g_nClearRecordCount);
  Label8.Caption := 'H-QyChr=' + IntToStr(g_nQueryChrCount);
  Label9.Caption := 'H-NwChr=' + IntToStr(nHackerNewChrCount);
  Label10.Caption := 'H-DlChr=' + IntToStr(nHackerDelChrCount);
  Label11.Caption := 'Dubb-Sl=' + IntToStr(nHackerSelChrCount);
  EnterCriticalSection(g_OutMessageCS);
  try

    for i := 0 to g_MainMsgList.Count - 1 do begin
      MemoLog.Lines.Add('[' + DateTimeToStr(Now) + '] ' + g_MainMsgList.Strings[i]);
    end;
    g_MainMsgList.Clear;
  finally
    LeaveCriticalSection(g_OutMessageCS);
  end;
  if MemoLog.Lines.Count > 200 then MemoLog.Lines.Clear;
end;


procedure TFrmDBSrv.FormCreate(Sender: TObject);
var
  Conf: TIniFile;
  nX, nY: Integer;
begin
  g_dwGameCenterHandle := Str_ToInt(ParamStr(1), 0);
  nX := Str_ToInt(ParamStr(2), -1);
  nY := Str_ToInt(ParamStr(3), -1);
  if (nX >= 0) or (nY >= 0) then begin
    Left := nX;
    Top := nY;
  end;
  m_boRemoteClose := False;
  SendGameCenterMsg(SG_FORMHANDLE, IntToStr(Self.Handle));
  MainOutMessage('正在启动数据库服务器...');
  boOpenDBBusy := True;
  Label4.Caption := '';
  LbAutoClean.Caption := '-/-';
  HumChrDB := nil;
  HumDataDB := nil;
  {
  Conf:=TIniFile.Create('sConfFileName');
  if Conf <> nil then begin
    sDataDBFilePath:=Conf.ReadString('DB','Dir',sDataDBFilePath);
    sHumDBFilePath:=Conf.ReadString('DB','HumDir',sHumDBFilePath);
    sFeedPath:=Conf.ReadString('DB','FeeDir',sFeedPath);
    sBackupPath:=Conf.ReadString('DB','Backup',sBackupPath);
    sConnectPath:=Conf.ReadString('DB','ConnectDir',sConnectPath);
    sLogPath:=Conf.ReadString('DB','LogDir',sLogPath);
    nServerPort:=Conf.ReadInteger('Setup','ServerPort',nServerPort);
    sServerAddr:=Conf.ReadString('Setup','ServerAddr',sServerAddr);
    boViewHackMsg:=Conf.ReadBool('Setup','ViewHackMsg',boViewHackMsg);
    sServerName:=Conf.ReadString('Setup','ServerName',sServerName);
    Conf.Free;
  end;
  }
  LoadConfig();
  ServerList := TList.Create;
  HumSessionList := TList.Create;
  AttackIPaddrList := TGList.Create; //攻击IP临时列表
  //Label5.Caption:='FDB: ' + sDataDBFilePath + 'Mir.DB  ' + 'Backup: ' + sBackupPath;
  n334 := 0;
  n4ADBF4 := 0;
  n4ADBF8 := 0;
  n4ADBFC := 0;
  n4ADC00 := 0;
  n4ADC04 := 0;
  n344 := 2;
  n348 := 0;
  nHackerNewChrCount := 0;
  nHackerDelChrCount := 0;
  nHackerSelChrCount := 0;
  n4ADC1C := 0;
  n4ADC20 := 0;
  n4ADC24 := 0;
  n4ADC28 := 0;
  SendGameCenterMsg(SG_STARTNOW, '正在启动数据库服务器...');
  StartTimer.Enabled := True;
end;

procedure TFrmDBSrv.StartTimerTimer(Sender: TObject);
begin
  StartTimer.Enabled := False;
  if SizeOf(THumDataInfo) <> 3164 then begin
    ShowMessage('sizeof(THuman) ' + IntToStr(SizeOf(THumDataInfo)) + ' <> SIZEOFTHUMAN ' + '3164');
    Close;
    Exit;
  end;

  boOpenDBBusy := True;
  HumChrDB := TFileHumDB.Create(sHumDBFilePath + 'Hum.DB');
  HumDataDB := TFileDB.Create(sDataDBFilePath + 'Mir.DB');
  boOpenDBBusy := False;
  boAutoClearDB := True;
  Label4.Caption := '';
  LoadItemsDB();
  LoadMagicDB();
  ServerSocket.Address := sServerAddr;
  ServerSocket.Port := nServerPort;
  ServerSocket.Active := True;
  FrmIDSoc.OpenConnect();
  MainOutMessage('服务器已启动...');
  SendGameCenterMsg(SG_STARTOK, '数据库服务器启动完成...');
  SendGameCenterMsg(SG_CHECKCODEADDR, IntToStr(Integer(@g_CheckCode)));
end;

procedure TFrmDBSrv.FormDestroy(Sender: TObject);
var
  i, ii: Integer;
  ServerInfo: pTServerInfo;
  HumSession: pTHumSession;
  IPList: TList;
begin
  if HumDataDB <> nil then HumDataDB.Free;
  if HumChrDB <> nil then HumChrDB.Free;
  for i := 0 to ServerList.Count - 1 do begin
    ServerInfo := ServerList.Items[i];
    Dispose(ServerInfo);
  end;
  ServerList.Free;
  for i := 0 to HumSessionList.Count - 1 do begin
    HumSession := HumSessionList.Items[i];
    Dispose(HumSession);
  end;
  HumSessionList.Free;

  AttackIPaddrList.Lock;
  try
    for i := 0 to AttackIPaddrList.Count - 1 do begin
      Dispose(pTSockaddr(AttackIPaddrList.Items[i]));
    end;
  finally
    AttackIPaddrList.UnLock;
    AttackIPaddrList.Free;
  end;
end;

procedure TFrmDBSrv.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if m_boRemoteClose then Exit;
  if Application.MessageBox('是否确定退出数据库服务器 ?', '确认信息', MB_YESNO + MB_ICONQUESTION) = mrYes then begin
    CanClose := True;
    ServerSocket.Active := False;
    MainOutMessage('正在关闭服务器...');
  end else begin
    CanClose := False;
  end;
end;

function TFrmDBSrv.LoadItemsDB(): Integer;
var
  i, Idx: Integer;
  StdItem: pTStdItem;
  nRecordCount: Integer;
resourcestring
  sSQLString = 'select * from StdItems';
begin
  MainOutMessage('正在加载物品数据...');
  try
    Result := -1;
    Query.SQL.Clear;
    Query.DatabaseName := sHeroDB;
    Query.SQL.Add(sSQLString);
    try
      Query.Open;
    finally
      Result := -2;
    end;
    nRecordCount := Query.RecordCount;
    for i := 0 to nRecordCount - 1 do begin
      New(StdItem);
      Idx := Query.FieldByName('Idx').AsInteger;
      StdItem.Name := Query.FieldByName('Name').AsString;
      StdItem.StdMode := Query.FieldByName('StdMode').AsInteger;
      StdItem.Shape := Query.FieldByName('Shape').AsInteger;
      StdItem.Weight := Query.FieldByName('Weight').AsInteger;
      StdItem.AniCount := Query.FieldByName('AniCount').AsInteger;
      StdItem.Source := Query.FieldByName('Source').AsInteger;
      StdItem.Reserved := Query.FieldByName('Reserved').AsInteger;
      StdItem.Looks := Query.FieldByName('Looks').AsInteger;
      StdItem.DuraMax := Word(Query.FieldByName('DuraMax').AsInteger);
      StdItem.AC := MakeLong(ROUND(Query.FieldByName('Ac').AsInteger), ROUND(Query.FieldByName('Ac2').AsInteger));
      StdItem.MAC := MakeLong(ROUND(Query.FieldByName('Mac').AsInteger), ROUND(Query.FieldByName('MAc2').AsInteger));
      StdItem.DC := MakeLong(ROUND(Query.FieldByName('Dc').AsInteger), ROUND(Query.FieldByName('Dc2').AsInteger));
      StdItem.MC := MakeLong(ROUND(Query.FieldByName('Mc').AsInteger), ROUND(Query.FieldByName('Mc2').AsInteger));
      StdItem.SC := MakeLong(ROUND(Query.FieldByName('Sc').AsInteger), ROUND(Query.FieldByName('Sc2').AsInteger));
      StdItem.Need := Query.FieldByName('Need').AsInteger;
      StdItem.NeedLevel := Query.FieldByName('NeedLevel').AsInteger;
      StdItem.Price := Query.FieldByName('Price').AsInteger;
      if StdItemList.Count = Idx then begin
        StdItemList.Add(StdItem);
        Result := 1;
      end else begin
        MainOutMessage(format('加载物品(Idx:%d Name:%s)数据失败！！！', [Idx, StdItem.Name]));
        Result := -100;
        Exit;
      end;
      Query.Next;
    end;
    Result := nRecordCount;
    MainOutMessage(format('物品数据库加载完成(%d)...', [nRecordCount]));
  finally
    Query.Close;
  end;
end;

function TFrmDBSrv.LoadMagicDB(): Integer;
var
  i, nRecordCount: Integer;
  Magic: pTMagic;
resourcestring
  sSQLString = 'select * from Magic';
begin
  Result := -1;
  MainOutMessage('正在加载技能数据库...');
  Query.SQL.Clear;
  Query.DatabaseName := sHeroDB;
  Query.SQL.Add(sSQLString);
  try
    Query.Open;
  finally
    Result := -2;
  end;
  nRecordCount := Query.RecordCount;
  for i := 0 to nRecordCount - 1 do begin
    New(Magic);
    Magic.wMagicId := Query.FieldByName('MagId').AsInteger;
    Magic.sMagicName := Query.FieldByName('MagName').AsString;
    Magic.btEffectType := Query.FieldByName('EffectType').AsInteger;
    Magic.btEffect := Query.FieldByName('Effect').AsInteger;
    Magic.wSpell := Query.FieldByName('Spell').AsInteger;
    Magic.wPower := Query.FieldByName('Power').AsInteger;
    Magic.wMaxPower := Query.FieldByName('MaxPower').AsInteger;
    Magic.btJob := Query.FieldByName('Job').AsInteger;
    Magic.TrainLevel[0] := Query.FieldByName('NeedL1').AsInteger;
    Magic.TrainLevel[1] := Query.FieldByName('NeedL2').AsInteger;
    Magic.TrainLevel[2] := Query.FieldByName('NeedL3').AsInteger;
    Magic.TrainLevel[3] := Query.FieldByName('NeedL3').AsInteger;
    Magic.MaxTrain[0] := Query.FieldByName('L1Train').AsInteger;
    Magic.MaxTrain[1] := Query.FieldByName('L2Train').AsInteger;
    Magic.MaxTrain[2] := Query.FieldByName('L3Train').AsInteger;
    Magic.MaxTrain[3] := Magic.MaxTrain[2];
    Magic.btTrainLv := 3;
    Magic.dwDelayTime := Query.FieldByName('Delay').AsInteger;
    Magic.btDefSpell := Query.FieldByName('DefSpell').AsInteger;
    Magic.btDefPower := Query.FieldByName('DefPower').AsInteger;
    Magic.btDefMaxPower := Query.FieldByName('DefMaxPower').AsInteger;
    Magic.sDescr := Query.FieldByName('Descr').AsString;
    if Magic.wMagicId > 0 then begin
      MagicList.Add(Magic);
    end else begin
      Dispose(Magic);
    end;
    Result := 1;
    Query.Next;
  end;
  MainOutMessage(format('技能数据库加载完成(%d)...', [nRecordCount]));
  Query.Close;
end;

procedure TFrmDBSrv.AniTimerTimer(Sender: TObject);
begin
  if n334 > 7 then
    n334 := 0
  else
    Inc(n334);
  case n334 of
    0: Label3.Caption := '|';
    1: Label3.Caption := '/';
    2: Label3.Caption := '--';
    3: Label3.Caption := '\';
    4: Label3.Caption := '|';
    5: Label3.Caption := '/';
    6: Label3.Caption := '--';
    7: Label3.Caption := '\';
  end;
end;

procedure TFrmDBSrv.Timer2Timer(Sender: TObject);
var
  i: Integer;
  HumSession: pTHumSession;
begin
  i := 0;
  while (True) do begin
    if HumSessionList.Count <= i then break;
    HumSession := HumSessionList.Items[i];
    if not HumSession.bo24 then begin
      if HumSession.bo2C then begin
        if (GetTickCount - HumSession.dwTick30) > 20 * 1000 then begin
          Dispose(HumSession);
          HumSessionList.Delete(i);
          Continue;
        end;
      end else begin
        if (GetTickCount - HumSession.dwTick30) > 2 * 60 * 1000 then begin
          Dispose(HumSession);
          HumSessionList.Delete(i);
          Continue;
        end;
      end;
    end;
    if (GetTickCount - HumSession.dwTick30) > 40 * 60 * 1000 then begin
      Dispose(HumSession);
      HumSessionList.Delete(i);
      Continue;
    end;
    Inc(i);
  end;
end;

procedure TFrmDBSrv.BtnUserDBToolClick(Sender: TObject);
begin
  if boHumDBReady and boDataDBReady then
    FrmIDHum.Show;
end;

procedure TFrmDBSrv.CkViewHackMsgClick(Sender: TObject);
var
  Conf: TIniFile;
begin
  Conf := TIniFile.Create(sConfFileName);
  if Conf <> nil then begin
    Conf.WriteBool('Setup', 'ViewHackMsg', CkViewHackMsg.Checked);
    Conf.Free;
  end;
end;

procedure TFrmDBSrv.ClearSocket(Socket: TCustomWinSocket);
var
  nIndex: Integer;
  HumSession: pTHumSession;
begin
  nIndex := 0;
  while (True) do begin
    if HumSessionList.Count <= nIndex then break;
    HumSession := HumSessionList.Items[nIndex];
    if HumSession.Socket = Socket then begin
      Dispose(HumSession);
      HumSessionList.Delete(nIndex);
      Continue;
    end;
    Inc(nIndex);
  end;
end;

function TFrmDBSrv.CopyHumData(sSrcChrName, sDestChrName,
  sUserId: string): Boolean;
var
  n14: Integer;
  bo15: Boolean;
  HumanRCD: THumDataInfo;
begin
  Result := False;
  bo15 := False;
  try
    if HumDataDB.Open then begin
      n14 := HumDataDB.Index(sSrcChrName);
      if (n14 >= 0) and (HumDataDB.Get(n14, HumanRCD) >= 0) then bo15 := True;
      if bo15 then begin
        n14 := HumDataDB.Index(sDestChrName);
        if (n14 >= 0) then begin
          HumanRCD.Header.sName := sDestChrName;
          HumanRCD.Data.sChrName := sDestChrName;
          HumanRCD.Data.sAccount := sUserId;
          HumDataDB.Update(n14, HumanRCD);
          Result := True;
        end;
      end;
    end;
  finally
    HumDataDB.Close;
  end;
end;

procedure TFrmDBSrv.DelHum(sChrName: string);
begin
  try
    if HumChrDB.Open then HumChrDB.Delete(sChrName);
  finally
    HumChrDB.Close;
  end;
end;

procedure TFrmDBSrv.MENU_MANAGE_DATAClick(Sender: TObject);
begin
  if boHumDBReady and boDataDBReady then
    FrmIDHum.Show;
end;

procedure TFrmDBSrv.MENU_MANAGE_TOOLClick(Sender: TObject);
begin
  frmDBTool.Top := Self.Top + 20;
  frmDBTool.Left := Self.Left;
  frmDBTool.Open();
end;

procedure TFrmDBSrv.MyMessage(var MsgData: TWmCopyData);
var
  sData: string;
  wIdent: Word;
begin
  wIdent := HiWord(MsgData.From);
  sData := StrPas(MsgData.CopyDataStruct^.lpData);
  case wIdent of
    GS_QUIT: begin
        ServerSocket.Active := False;
        m_boRemoteClose := True;
        Close();
      end;
    1: ;
    2: ;
    3: ;
  end;
end;

procedure TFrmDBSrv.MENU_TEST_SELGATEClick(Sender: TObject);
begin
  frmTestSelGate := TfrmTestSelGate.Create(Owner);
  frmTestSelGate.ShowModal;
  frmTestSelGate.Free;
end;

procedure TFrmDBSrv.MENU_CONTROL_STARTClick(Sender: TObject);
begin
  if Sender = MENU_CONTROL_START then begin

  end else
    if Sender = MENU_OPTION_GAMEGATE then begin
    frmRouteManage.Open;
  end;
end;

procedure TFrmDBSrv.G1Click(Sender: TObject);
begin
  try
    FrmUserSoc.LoadServerInfo();
    LoadIPTable();
    LoadGateID();
    MainOutMessage('加载网关设置完成...');
  except
    MainOutMessage('加载网关设置失败...');
  end;
end;

procedure TFrmDBSrv.ApplicationEvents1Exception(Sender: TObject;
  E: Exception);
begin
  MemoLog.Lines.Add(E.Message);
end;

procedure TFrmDBSrv.X1Click(Sender: TObject);
begin
  Close;
end;

procedure TFrmDBSrv.N3Click(Sender: TObject);
begin
  MainOutMessage(g_sVersion);
  MainOutMessage(g_sUpDateTime);
  MainOutMessage(g_sWebSite);
end;

procedure TFrmDBSrv.MENU_OPTION_GENERALClick(Sender: TObject);
begin
  FrmSetting := TFrmSetting.Create(Owner);
  FrmSetting.Open;
  FrmSetting.Free;
end;

procedure TFrmDBSrv.BtnReloadAddrClick(Sender: TObject);
begin
  FrmUserSoc.LoadServerInfo();
  LoadIPTable();
  LoadGateID();
end;

procedure TFrmDBSrv.BtnEditAddrsClick(Sender: TObject);
begin
FrmEditAddr.Open();
end;

end.


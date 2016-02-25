unit GShare;

interface
uses
  Windows, Messages, Classes, SysUtils, INIFiles, DataBackUp, Common;
const
  MAXRUNGATECOUNT = 8;
type
  TProgram = record
    boGetStart: Boolean;
    boReStart: Boolean; //程序异常停止，是否重新启动
    btStartStatus: Byte; //0,1,2,3 未启动，正在启动，已启动,正在关闭
    sProgramFile: string[50];
    sDirectory: string[100];
    ProcessInfo: TProcessInformation;
    ProcessHandle: THandle;
    MainFormHandle: THandle;
    nMainFormX: Integer;
    nMainFormY: Integer;
  end;

  pTProgram = ^TProgram;

  TRunGateInfo = record
    boGetStart: Boolean;
    sGateAddr: string[15];
    nGatePort: Integer;
  end;

  TCheckCode = record
    dwThread0: LongWord;
    sThread0: string;
  end;

procedure LoadConfig();
function RunProgram(var ProgramInfo: TProgram; sHandle: string; dwWaitTime: LongWord): LongWord;
function StopProgram(var ProgramInfo: TProgram; dwWaitTime: LongWord): Integer;
procedure SendProgramMsg(DesForm: THandle; wIdent: Word; sSendMsg: string);
var




  g_sServerAddr: string = '0.0.0.0';
  g_nServerPort: Integer = 6350;
  g_SessionList: TStringList;

  g_sGameFile: string = '.\GameList.txt';
  g_nClientForm: Integer = -1;

  g_nFormIdx: Integer;
  g_IniConf: Tinifile;
  g_sButtonStartGame: string = '启动游戏服务器(&S)';
  g_sButtonStopGame: string = '停止游戏服务器(&T)';
  g_sButtonStopStartGame: string = '中止启动游戏服务器(&T)';
  g_sButtonStopStopGame: string = '中止停止游戏服务器(&T)';

  g_sConfFile: string = '.\Config.ini';
  g_sGameDirectory: string = 'D:\MirServer\';
  g_sHeroDBName: string = 'HeroDB';
  g_sGameName: string = '传奇测试';
  g_sGameName1: string = '传奇测试一';
  g_sAllIPaddr: string = '0.0.0.0';
  g_sLocalIPaddr: string = '127.0.0.1';
  g_sExtIPaddr: string = '192.168.0.1';
  g_boDynamicIPMode: Boolean = False;
  g_nLimitOnlineUser: Integer = 2000; //服务器最高上线人数

  g_sDBServer_ProgramFile: string = 'DBServer.exe';
  g_sDBServer_Directory: string = 'DBServer\';
  g_boDBServer_GetStart: Boolean = True;
  g_sDBServer_ConfigFile: string = 'dbsrc.ini';
  g_sDBServer_Config_ServerAddr: string = '127.0.0.1';
  g_nDBServer_Config_ServerPort: Integer = 6000;
  g_sDBServer_Config_GateAddr: string = '127.0.0.1';
  g_nDBServer_Config_GatePort: Integer = 5100;
  g_sDBServer_Config_IDSAddr: string = '127.0.0.1';
  g_nDBServer_Config_IDSPort: Integer = 5600;

  g_nDBServer_Config_Interval: Integer = 1000;
  g_nDBServer_Config_Level1: Integer = 1;
  g_nDBServer_Config_Level2: Integer = 7;
  g_nDBServer_Config_Level3: Integer = 14;
  g_nDBServer_Config_Day1: Integer = 7;
  g_nDBServer_Config_Day2: Integer = 62;
  g_nDBServer_Config_Day3: Integer = 124;
  g_nDBServer_Config_Month1: Integer = 0;
  g_nDBServer_Config_Month2: Integer = 0;
  g_nDBServer_Config_Month3: Integer = 0;

  g_sDBServer_Config_Dir: string = 'FDB\';
  g_sDBServer_Config_IdDir: string = 'FDB\';
  g_sDBServer_Config_HumDir: string = 'FDB\';
  g_sDBServer_Config_FeeDir: string = 'FDB\';
  g_sDBServer_Config_BackupDir: string = 'Backup\';
  g_sDBServer_Config_ConnectDir: string = 'Connection\';
  g_sDBServer_Config_LogDir: string = 'Log\';

  g_sDBServer_Config_MapFile: string = 'Mir200\Envir\MapInfo.txt';
  g_boDBServer_Config_ViewHackMsg: Boolean = False;
  g_sDBServer_AddrTableFile: string = '!addrtable.txt';
  g_sDBServer_ServerinfoFile: string = '!serverinfo.txt';
  g_nDBServer_MainFormX: Integer = 0;
  g_nDBServer_MainFormY: Integer = 326;
  g_boDBServer_DisableAutoGame: Boolean = False;

  g_sLoginServer_ProgramFile: string = 'LoginSrv.exe';
  g_sLoginServer_Directory: string = 'LoginSrv\';
  g_sLoginServer_ConfigFile: string = 'Logsrv.ini';
  g_boLoginServer_GetStart: Boolean = True;
  g_sLoginServer_GateAddr: string = '127.0.0.1';
  g_nLoginServer_GatePort: Integer = 5500;
  g_sLoginServer_ServerAddr: string = '127.0.0.1';
  g_nLoginServer_ServerPort: Integer = 5600;

  g_sLoginServer_ReadyServers: Integer = 0;
  g_sLoginServer_EnableMakingID: Boolean = True;
  g_sLoginServer_EnableTrial: Boolean = False;
  g_sLoginServer_TestServer: Boolean = True;

  g_sLoginServer_IdDir: string = 'IDDB\';
  g_sLoginServer_FeedIDList: string = 'FeedIDList.txt';
  g_sLoginServer_FeedIPList: string = 'FeedIPList.txt';
  g_sLoginServer_CountLogDir: string = 'CountLog\';
  g_sLoginServer_WebLogDir: string = 'GameWFolder\';

  g_sLoginServer_AddrTableFile: string = '!addrtable.txt';
  g_sLoginServer_ServeraddrFile: string = '!serveraddr.txt';
  g_sLoginServerUserLimitFile: string = '!UserLimit.txt';
  g_sLoginServerFeedIDListFile: string = 'FeedIDList.txt';
  g_sLoginServerFeedIPListFile: string = 'FeedIPList.txt';
  g_nLoginServer_MainFormX: Integer = 251;
  g_nLoginServer_MainFormY: Integer = 0;
  g_nLoginServer_RouteList: TList;


  g_sLogServer_ProgramFile: string = 'LogDataServer.exe';
  g_sLogServer_Directory: string = 'LogServer\';
  g_boLogServer_GetStart: Boolean = True;
  g_sLogServer_ConfigFile: string = 'LogData.ini';
  g_sLogServer_BaseDir: string = 'BaseDir\';
  g_sLogServer_ServerAddr: string = '127.0.0.1';
  g_nLogServer_Port: Integer = 10000;
  g_nLogServer_MainFormX: Integer = 251;
  g_nLogServer_MainFormY: Integer = 239;

  g_sM2Server_ProgramFile: string = 'M2Server.exe';
  g_sM2Server_Directory: string = 'Mir200\';
  g_boM2Server_GetStart: Boolean = True;
  g_sM2Server_ConfigFile: string = '!setup.txt';
  g_sM2Server_AbuseFile: string = '!abuse.txt';
  g_sM2Server_RunAddrFile: string = '!runaddr.txt';
  g_sM2Server_ServerTableFile: string = '!servertable.txt';

  g_nM2Server_ServerNumber: Integer = 0;
  g_nM2Server_ServerIndex: Integer = 0;
  g_boM2Server_VentureServer: Boolean = False;
  g_boM2Server_TestServer: Boolean = True;
  g_nM2Server_TestLevel: Integer = 1;
  g_nM2Server_TestGold: Integer = 0;
  g_boM2Server_ServiceMode: Boolean = False;
  g_boM2Server_NonPKServer: Boolean = False;
  g_sM2Server_MsgSrvAddr: string = '127.0.0.1';
  g_nM2Server_MsgSrvPort: Integer = 4900;
  g_sM2Server_GateAddr: string = '127.0.0.1';
  g_nM2Server_GatePort: Integer = 5000;

  g_sM2Server_BaseDir: string = 'Share\';
  g_sM2Server_GuildDir: string = 'GuildBase\Guilds\';
  g_sM2Server_GuildFile: string = 'GuildBase\Guildlist.txt';
  g_sM2Server_VentureDir: string = 'ShareV\';
  g_sM2Server_ConLogDir: string = 'ConLog\';
  g_sM2Server_LogDir: string = 'Log\';
  g_sM2Server_CastleDir: string = 'Castle\';
  g_sM2Server_EnvirDir: string = 'Envir\';
  g_sM2Server_MapDir: string = 'Map\';
  g_sM2Server_NoticeDir: string = 'Notice\';
  g_nM2Server_MainFormX: Integer = 560;
  g_nM2Server_MainFormY: Integer = 0;

  g_sLoginGate_ProgramFile: string = 'LoginGate.exe';
  g_sLoginGate_Directory: string = 'LoginGate\';
  g_boLoginGate_GetStart: Boolean = True;
  g_sLoginGate_ConfigFile: string = 'Config.ini';
  g_sLoginGate_ServerAddr: string = '127.0.0.1';
  g_nLoginGate_ServerPort: Integer = 5500;
  g_sLoginGate_GateAddr: string = '0.0.0.0';
  g_nLoginGate_GatePort: Integer = 7000;
  g_nLoginGate_ShowLogLevel: Integer = 3;
  g_nLoginGate_MaxConnOfIPaddr: Integer = 20;
  g_nLoginGate_BlockMethod: Integer = 0;
  g_nLoginGate_KeepConnectTimeOut: Integer = 60000;
  g_nLoginGate_MainFormX: Integer = 0;
  g_nLoginGate_MainFormY: Integer = 0;

  g_sSelGate_ProgramFile: string = 'SelGate.exe';
  g_sSelGate_Directory: string = 'SelGate\';
  g_boSelGate_GetStart: Boolean = True;
  g_sSelGate_ConfigFile: string = 'Config.ini';
  g_sSelGate_ServerAddr: string = '127.0.0.1';
  g_nSelGate_ServerPort: Integer = 5100;
  g_sSelGate_GateAddr: string = '0.0.0.0';
  g_nSeLGate_GatePort: Integer = 7100;
  g_sSelGate_GateAddr1: string = '0.0.0.0';
  g_nSeLGate_GatePort1: Integer = 7101;
  g_nSelGate_ShowLogLevel: Integer = 3;
  g_nSelGate_MaxConnOfIPaddr: Integer = 20;
  g_nSelGate_BlockMethod: Integer = 0;
  g_nSelGate_KeepConnectTimeOut: Integer = 60000;
  g_nSelGate_MainFormX: Integer = 0;
  g_nSelGate_MainFormY: Integer = 163;

  g_sRunGate_ProgramFile: string = 'RunGate.exe';
  g_sRunGate_RegKey: string = 'ABCDEFGHIJKL';
  //  g_sRunGate_RegKey               :String = '0123456789';
  g_sRunGate_Directory: string = 'RunGate\';
  g_boRunGate_GetStart: Boolean = True;
  g_boRunGate1_GetStart: Boolean = True;
  g_boRunGate2_GetStart: Boolean = True;
  g_boRunGate3_GetStart: Boolean = True;
  g_boRunGate4_GetStart: Boolean = True;
  g_boRunGate5_GetStart: Boolean = True;
  g_boRunGate6_GetStart: Boolean = True;
  g_boRunGate7_GetStart: Boolean = True;
  g_sRunGate_ConfigFile: string = 'RunGate.ini';
  g_nRunGate_Count: Integer = 3;
  g_sRunGate_ServerAddr: string = '127.0.0.1';
  g_nRunGate_ServerPort: Integer = 5000;
  g_sRunGate_GateAddr: string = '0.0.0.0';
  g_nRunGate_GatePort: Integer = 7200;
  g_sRunGate1_GateAddr: string = '0.0.0.0';
  g_nRunGate1_GatePort: Integer = 7300;
  g_sRunGate2_GateAddr: string = '0.0.0.0';
  g_nRunGate2_GatePort: Integer = 7400;
  g_sRunGate3_GateAddr: string = '0.0.0.0';
  g_nRunGate3_GatePort: Integer = 7500;
  g_sRunGate4_GateAddr: string = '0.0.0.0';
  g_nRunGate4_GatePort: Integer = 7600;
  g_sRunGate5_GateAddr: string = '0.0.0.0';
  g_nRunGate5_GatePort: Integer = 7700;
  g_sRunGate6_GateAddr: string = '0.0.0.0';
  g_nRunGate6_GatePort: Integer = 7800;
  g_sRunGate7_GateAddr: string = '0.0.0.0';
  g_nRunGate7_GatePort: Integer = 7900;

  g_RunGateInfo: array[0..MAXRUNGATECOUNT - 1] of TRunGateInfo; //2006-11-12 增加

  DBServer: TProgram;
  LoginServer: TProgram;
  LogServer: TProgram;
  M2Server: TProgram;
  RunGate: array[0..MAXRUNGATECOUNT - 1] of TProgram; //2006-11-12 增加
  {RunGate1       :TProgram;
  RunGate2       :TProgram;
  RunGate3       :TProgram;
  RunGate4       :TProgram;
  RunGate5       :TProgram;
  RunGate6       :TProgram;
  RunGate7       :TProgram; }

  SelGate: TProgram;
  SelGate1: TProgram;
  LoginGate: TProgram;
  LoginGate1: TProgram;

  g_dwStopTick: LongWord;
  g_dwStopTimeOut: LongWord = 10000;
  g_boShowDebugTab: Boolean = False;
  g_dwM2CheckCodeAddr: LongWord;
  g_dwDBCheckCodeAddr: LongWord;

  g_BackUpManager: TBackUpManager; //文件备份
  m_nBackStartStatus: Integer = 0;

const
  tDBServer = 0;
  tLoginSrv = 1;
  tLogServer = 2;
  tM2Server = 3;
  tLoginGate = 4;
  tLoginGate1 = 5;
  tSelGate = 6;
  tSelGate1 = 7;
  tRunGate = 8;
implementation
procedure LoadConfig();
var
  I: Integer;
begin
  g_dwStopTimeOut := g_IniConf.ReadInteger('GameConf', 'dwStopTimeOut', g_dwStopTimeOut);
  g_boShowDebugTab := g_IniConf.ReadBool('GameConf', 'ShowDebugTab', g_boShowDebugTab);
  g_sGameDirectory := g_IniConf.ReadString('GameConf', 'GameDirectory', g_sGameDirectory);
  g_sHeroDBName := g_IniConf.ReadString('GameConf', 'HeroDBName', g_sHeroDBName);
  g_sGameName := g_IniConf.ReadString('GameConf', 'GameName', g_sGameName);
  g_sExtIPaddr := g_IniConf.ReadString('GameConf', 'ExtIPaddr', g_sExtIPaddr);
  g_boDynamicIPMode := g_IniConf.ReadBool('GameConf', 'DynamicIPMode', g_boDynamicIPMode);

  g_nDBServer_MainFormX := g_IniConf.ReadInteger('DBServer', 'MainFormX', g_nDBServer_MainFormX);
  g_nDBServer_MainFormY := g_IniConf.ReadInteger('DBServer', 'MainFormY', g_nDBServer_MainFormY);
  g_nDBServer_Config_GatePort := g_IniConf.ReadInteger('DBServer', 'GatePort', g_nDBServer_Config_GatePort);
  g_nDBServer_Config_ServerPort := g_IniConf.ReadInteger('DBServer', 'ServerPort', g_nDBServer_Config_ServerPort);
  g_boDBServer_GetStart := g_IniConf.ReadBool('DBServer', 'GetStart', g_boDBServer_GetStart);

  g_nM2Server_MainFormX := g_IniConf.ReadInteger('M2Server', 'MainFormX', g_nM2Server_MainFormX);
  g_nM2Server_MainFormY := g_IniConf.ReadInteger('M2Server', 'MainFormY', g_nM2Server_MainFormY);
  g_nM2Server_TestLevel := g_IniConf.ReadInteger('M2Server', 'TestLevel', g_nM2Server_TestLevel);
  g_nM2Server_TestGold := g_IniConf.ReadInteger('M2Server', 'TestGold', g_nM2Server_TestGold);

  g_nM2Server_GatePort := g_IniConf.ReadInteger('M2Server', 'GatePort', g_nM2Server_GatePort);
  g_nM2Server_MsgSrvPort := g_IniConf.ReadInteger('M2Server', 'MsgSrvPort', g_nM2Server_MsgSrvPort);
  g_boM2Server_GetStart := g_IniConf.ReadBool('M2Server', 'GetStart', g_boM2Server_GetStart);

  g_nLoginGate_MainFormX := g_IniConf.ReadInteger('LoginGate', 'MainFormX', g_nLoginGate_MainFormX);
  g_nLoginGate_MainFormY := g_IniConf.ReadInteger('LoginGate', 'MainFormY', g_nLoginGate_MainFormY);
  g_boLoginGate_GetStart := g_IniConf.ReadBool('LoginGate', 'GetStart', g_boLoginGate_GetStart);
  g_nLoginGate_GatePort := g_IniConf.ReadInteger('LoginGate', 'GatePort', g_nLoginGate_GatePort);

  g_nSelGate_MainFormX := g_IniConf.ReadInteger('SelGate', 'MainFormX', g_nSelGate_MainFormX);
  g_nSelGate_MainFormY := g_IniConf.ReadInteger('SelGate', 'MainFormY', g_nSelGate_MainFormY);
  g_nSeLGate_GatePort := g_IniConf.ReadInteger('SelGate', 'GatePort', g_nSeLGate_GatePort);
  g_nSeLGate_GatePort1 := g_IniConf.ReadInteger('SelGate', 'GatePort1', g_nSeLGate_GatePort1);
  g_boSelGate_GetStart := g_IniConf.ReadBool('SelGate', 'GetStart', g_boSelGate_GetStart);

  g_nRunGate_Count := g_IniConf.ReadInteger('RunGate', 'Count', g_nRunGate_Count);

  for I := Low(g_RunGateInfo) to High(g_RunGateInfo) do g_RunGateInfo[I].sGateAddr := '0.0.0.0';

  g_RunGateInfo[0].nGatePort := g_IniConf.ReadInteger('RunGate', 'GatePort1', g_nRunGate_GatePort);
  g_RunGateInfo[1].nGatePort := g_IniConf.ReadInteger('RunGate', 'GatePort2', g_nRunGate1_GatePort);
  g_RunGateInfo[2].nGatePort := g_IniConf.ReadInteger('RunGate', 'GatePort3', g_nRunGate2_GatePort);
  g_RunGateInfo[3].nGatePort := g_IniConf.ReadInteger('RunGate', 'GatePort4', g_nRunGate3_GatePort);
  g_RunGateInfo[4].nGatePort := g_IniConf.ReadInteger('RunGate', 'GatePort5', g_nRunGate4_GatePort);
  g_RunGateInfo[5].nGatePort := g_IniConf.ReadInteger('RunGate', 'GatePort6', g_nRunGate5_GatePort);
  g_RunGateInfo[6].nGatePort := g_IniConf.ReadInteger('RunGate', 'GatePort7', g_nRunGate6_GatePort);
  g_RunGateInfo[7].nGatePort := g_IniConf.ReadInteger('RunGate', 'GatePort8', g_nRunGate7_GatePort);

  g_RunGateInfo[0].boGetStart := g_nRunGate_Count >= 1;
  g_RunGateInfo[1].boGetStart := g_nRunGate_Count >= 2;
  g_RunGateInfo[2].boGetStart := g_nRunGate_Count >= 3;
  g_RunGateInfo[3].boGetStart := g_nRunGate_Count >= 4;
  g_RunGateInfo[4].boGetStart := g_nRunGate_Count >= 5;
  g_RunGateInfo[5].boGetStart := g_nRunGate_Count >= 6;
  g_RunGateInfo[6].boGetStart := g_nRunGate_Count >= 7;
  g_RunGateInfo[7].boGetStart := g_nRunGate_Count >= 8;
  if g_RunGateInfo[4].boGetStart then begin
    g_sDBServer_Config_GateAddr := g_sAllIPaddr;
  end else begin
    g_sDBServer_Config_GateAddr := g_sLocalIPaddr;
  end;

  g_nLoginServer_MainFormX := g_IniConf.ReadInteger('LoginServer', 'MainFormX', g_nLoginServer_MainFormX);
  g_nLoginServer_MainFormY := g_IniConf.ReadInteger('LoginServer', 'MainFormY', g_nLoginServer_MainFormY);

  g_nLoginServer_GatePort := g_IniConf.ReadInteger('LoginServer', 'GatePort', g_nLoginServer_GatePort);
  g_nLoginServer_ServerPort := g_IniConf.ReadInteger('LoginServer', 'ServerPort', g_nLoginServer_ServerPort);
  g_boLoginServer_GetStart := g_IniConf.ReadBool('LoginServer', 'GetStart', g_boLoginServer_GetStart);

  g_nLogServer_MainFormX := g_IniConf.ReadInteger('LogServer', 'MainFormX', g_nLogServer_MainFormX);
  g_nLogServer_MainFormY := g_IniConf.ReadInteger('LogServer', 'MainFormY', g_nLogServer_MainFormY);
  g_boLogServer_GetStart := g_IniConf.ReadBool('LogServer', 'GetStart', g_boLogServer_GetStart);
  g_nLogServer_Port := g_IniConf.ReadInteger('LogServer', 'Port', g_nLogServer_Port);
end;
function RunProgram(var ProgramInfo: TProgram; sHandle: string; dwWaitTime: LongWord): LongWord;
var
  StartupInfo: TStartupInfo;
  sCommandLine: string;
  sCurDirectory: string;
begin
  Result := 0;
  FillChar(StartupInfo, SizeOf(TStartupInfo), #0);
  {
  StartupInfo.cb:=SizeOf(TStartupInfo);
  StartupInfo.lpReserved:=nil;
  StartupInfo.lpDesktop:=nil;
  StartupInfo.lpTitle:=nil;
  StartupInfo.dwFillAttribute:=0;
  StartupInfo.cbReserved2:=0;
  StartupInfo.lpReserved2:=nil;
  }
  GetStartupInfo(StartupInfo);
  sCommandLine := format('%s%s %s %d %d', [ProgramInfo.sDirectory, ProgramInfo.sProgramFile, sHandle, ProgramInfo.nMainFormX, ProgramInfo.nMainFormY]);
  sCurDirectory := ProgramInfo.sDirectory;
  if not CreateProcess(nil, //lpApplicationName,
    PChar(sCommandLine), //lpCommandLine,
    nil, //lpProcessAttributes,
    nil, //lpThreadAttributes,
    True, //bInheritHandles,
    0, //dwCreationFlags,
    nil, //lpEnvironment,
    PChar(sCurDirectory), //lpCurrentDirectory,
    StartupInfo, //lpStartupInfo,
    ProgramInfo.ProcessInfo) then begin //lpProcessInformation

    Result := GetLastError();
  end;
  Sleep(dwWaitTime);
end;
function StopProgram(var ProgramInfo: TProgram; dwWaitTime: LongWord): Integer;
var
  dwExitCode: LongWord;
begin
  Result := 0;
  if TerminateProcess(ProgramInfo.ProcessHandle, dwExitCode) then begin
    Result := GetLastError();
  end;
  Sleep(dwWaitTime);
end;

procedure SendProgramMsg(DesForm: THandle; wIdent: Word; sSendMsg: string);
var
  SendData: TCopyDataStruct;
  nParam: Integer;
begin
  nParam := MakeLong(0, wIdent);
  SendData.cbData := length(sSendMsg) + 1;
  GetMem(SendData.lpData, SendData.cbData);
  StrCopy(SendData.lpData, PChar(sSendMsg));
  SendMessage(DesForm, WM_COPYDATA, nParam, Cardinal(@SendData));
  FreeMem(SendData.lpData);
end;

initialization
  begin
    g_IniConf := Tinifile.Create(g_sConfFile);
  end;

finalization
  begin
    g_IniConf.Free;
  end;

end.

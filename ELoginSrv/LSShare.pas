unit LSShare;

interface
uses
  Windows, Messages, Classes, SysUtils, WinSock, SyncObjs, MudUtil, IniFiles, Grobal2, SDK, Common;
const
  g_sVersion = '程序名称:HAPPYM2.NET 人物帐号登录服务器';
  g_sUpDateTime = '更新日期: 2014.09.09';
  g_sWebSite = '官方网站: http://WWW.HAPPYM2.NET';


  IDFILEMODE = 0; //文件模式
  IDDBMODE = 1; //数据库模式

  IDMODE = IDFILEMODE;
  tLoginSrv = 1;
  MAXGATEROUTE = 60;
type
  TSockaddr = record
    nIPaddr: Integer;
    dwStartAttackTick: LongWord;
    nAttackCount: Integer;
  end;
  pTSockaddr = ^TSockaddr;

  TGateNet = record
    sIPaddr: string;
    nPort: Integer;
    boEnable: Boolean;
  end;
  TGateRoute = record
    sServerName: string;
    sTitle: string;
    sRemoteAddr: string;
    sPublicAddr: string;
    nSelIdx: Integer;
    Gate: array[0..9] of TGateNet;
  end;
  TConfig = record
    IniConf: TIniFile;
    boRemoteClose: Boolean;
    sDBServer: string[30]; //0x00475368
    nDBSPort: Integer; //0x00475374
    sFeeServer: string[30]; //0x0047536C
    nFeePort: Integer; //0x00475378
    sLogServer: string[30]; //0x00475370
    nLogPort: Integer; //0x0047537C
    sGateAddr: string[30];
    nGatePort: Integer;
    sServerAddr: string[30];
    nServerPort: Integer;
    sMonAddr: string[30];
    nMonPort: Integer;
    sGateIPaddr: string[30]; //当前处理的网关连接IP地址
    sIdDir: string[50];
    sWebLogDir: string[50];
    sFeedIDList: string[50];
    sFeedIPList: string[50];
    sCountLogDir: string[50];
    sChrLogDir: string[50];
    boTestServer: Boolean;
    boEnableMakingID: Boolean;
    boEnableGetbackPassword: Boolean;
    boAutoClearID: Boolean;
    dwAutoClearTime: LongWord;
    boUnLockAccount: Boolean;
    dwUnLockAccountTime: LongWord;
    boDynamicIPMode: Boolean;
    nReadyServers: Integer;

    GateCriticalSection: TRTLCriticalSection;
    GateList: TList;
    SessionList: TGList;
    ServerNameList: TStringList;
    AccountCostList: TQuickList;
    IPaddrCostList: TQuickList;
    boShowDetailMsg: Boolean;
    dwProcessGateTick: LongWord; //0x00475380
    dwProcessGateTime: LongWord; //0x00475384
    nRouteCount: Integer; //0x47328C
    GateRoute: array[0..MAXGATEROUTE - 1] of TGateRoute;
  end;
  pTConfig = ^TConfig;
function GetCodeMsgSize(X: Double): Integer;
function CheckAccountName(sName: string): Boolean;
function GetSessionID(): Integer;
procedure SaveGateConfig(Config: pTConfig);
function GetGatePublicAddr(Config: pTConfig; sGateIP: string): string;
function GenSpaceString(sStr: string; nSpaceCOunt: Integer): string;
procedure MainOutMessage(sMsg: string);
procedure SendGameCenterMsg(wIdent: Word; sSendMsg: string);
var
  g_Config: TConfig = (boRemoteClose: False;
    sDBServer: '127.0.0.1';
    nDBSPort: 16300;
    sFeeServer: '127.0.0.1';
    nFeePort: 16301;
    sLogServer: '127.0.0.1';
    nLogPort: 16301;
    sGateAddr: '0.0.0.0';
    nGatePort: 5500;
    sServerAddr: '0.0.0.0';
    nServerPort: 5600;
    sMonAddr: '0.0.0.0';
    nMonPort: 3000;
    sIdDir: '.\DB\'; //0x00470D04
    sWebLogDir: '.\Share\'; //0x00470D08
    sFeedIDList: '.\FeedIDList.txt'; //0x00470D0C
    sFeedIPList: '.\FeedIPList.txt'; //0x00470D10
    sCountLogDir: '.\CountLog\'; //0x00470D14
    sChrLogDir: '.\ChrLog\';
    boTestServer: true;
    boEnableMakingID: true;
    boEnableGetbackPassword: true;
    boAutoClearID: true;
    dwAutoClearTime: 1000;
    boUnLockAccount: False;
    dwUnLockAccountTime: 10;
    boDynamicIPMode: False;
    nReadyServers: 0;
    boShowDetailMsg: False
    );

  StringList_0: TStringList; //0x0047538C
  nOnlineCountMin: Integer; //0x00475390
  nOnlineCountMax: Integer; //0x00475394
  nMemoHeigh: Integer; //0x00475398
  g_OutMessageCS: TRTLCriticalSection;
  g_MainMsgList: TStringList; //0x0047539C
  CS_DB: TCriticalSection; //0x004753A0
  n4753A4: Integer; //0x004753A4
  n4753A8: Integer; //0x004753A8
  n4753B0: Integer; //0x004753B0

  n47328C: Integer;

  nSessionIdx: Integer; //0x00473294

  g_n472A6C: Integer;
  g_n472A70: Integer;
  g_n472A74: Integer;
  g_boDataDBReady: Boolean; //0x00472A78
  bo470D20: Boolean;

  nVersionDate: Integer = 20011006;

  ServerAddr: array[0..MAXGATEROUTE - 1] of string[15];
  g_dwGameCenterHandle: THandle;
implementation

function GetCodeMsgSize(X: Double): Integer;
begin
  if INT(X) < X then Result := TRUNC(X) + 1
  else Result := TRUNC(X)
end;

function CheckAccountName(sName: string): Boolean;
var
  I: Integer;
  nLen: Integer;
begin
  Result := False;
  if sName = '' then Exit;
  Result := true;
  nLen := length(sName);
  I := 1;
  while (true) do begin
    if I > nLen then break;
    if (sName[I] < '0') or (sName[I] > 'z') then begin
      Result := False;
      if (sName[I] >= #$B0) and (sName[I] <= #$C8) then begin
        Inc(I);
        if I <= nLen then
          if (sName[I] >= #$A1) and (sName[I] <= #$FE) then Result := true;
      end;
      if not Result then break;
    end;
    Inc(I);
  end;
end;

function GetSessionID(): Integer;
begin
  Inc(nSessionIdx);
  if nSessionIdx >= High(Integer) then begin
    nSessionIdx := 2;
  end;
  Result := nSessionIdx;
end;
//0046D4F4
procedure SaveGateConfig(Config: pTConfig);
var
  SaveList: TStringList;
  I, n8: Integer;
  s10, sC: string;
begin
  SaveList := TStringList.Create;
  SaveList.Add(';No space allowed');
  SaveList.Add(GenSpaceString(';Server', 15) + GenSpaceString('Title', 15) + GenSpaceString('Remote', 17) + GenSpaceString('Public', 17) + 'Gate...');
  for I := 0 to Config.nRouteCount - 1 do begin
    sC := GenSpaceString(Config.GateRoute[I].sServerName, 15) + GenSpaceString(Config.GateRoute[I].sTitle, 15) + GenSpaceString(Config.GateRoute[I].sRemoteAddr, 17) + GenSpaceString(Config.GateRoute[I].sPublicAddr, 17);
    n8 := 0;
    while (true) do begin
      s10 := Config.GateRoute[I].Gate[n8].sIPaddr;
      if s10 = '' then break;
      if not Config.GateRoute[I].Gate[n8].boEnable then
        s10 := '*' + s10;
      s10 := s10 + ':' + IntToStr(Config.GateRoute[I].Gate[n8].nPort);
      sC := sC + GenSpaceString(s10, 17);
      Inc(n8);
      if n8 >= 10 then break;
    end;
    SaveList.Add(sC);
  end;
  SaveList.SaveToFile('.\!addrtable.txt');
  SaveList.Free;
end;

function GetGatePublicAddr(Config: pTConfig; sGateIP: string): string;
var
  I: Integer;
begin
  Result := sGateIP;
  for I := 0 to Config.nRouteCount - 1 do begin
    if Config.GateRoute[I].sRemoteAddr = sGateIP then begin
      Result := Config.GateRoute[I].sPublicAddr;
      break;
    end;
  end;
end;

function GenSpaceString(sStr: string; nSpaceCOunt: Integer): string;
var
  I: Integer;
begin
  Result := sStr + ' ';
  for I := 1 to nSpaceCOunt - length(sStr) do begin
    Result := Result + ' ';
  end;
end;

procedure MainOutMessage(sMsg: string);
begin
  EnterCriticalSection(g_OutMessageCS);
  try
    g_MainMsgList.Add(sMsg)
  finally
    LeaveCriticalSection(g_OutMessageCS);
  end;
end;

procedure SendGameCenterMsg(wIdent: Word; sSendMsg: string);
var
  SendData: TCopyDataStruct;
  nParam: Integer;
begin
  nParam := MakeLong(Word(tLoginSrv), wIdent);
  SendData.cbData := length(sSendMsg) + 1;
  GetMem(SendData.lpData, SendData.cbData);
  StrCopy(SendData.lpData, PChar(sSendMsg));
  SendMessage(g_dwGameCenterHandle, WM_COPYDATA, nParam, Cardinal(@SendData));
  FreeMem(SendData.lpData);
end;

initialization
  begin
    InitializeCriticalSection(g_OutMessageCS);
    //InitializeCriticalSection(g_Config.GateCriticalSection);
    g_MainMsgList := TStringList.Create;
  end;
finalization
  begin
    g_MainMsgList.Free;
    //DeleteCriticalSection(g_Config.GateCriticalSection);
    DeleteCriticalSection(g_OutMessageCS);
  end;
end.

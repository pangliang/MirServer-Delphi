unit UsrEngn;

interface
uses
  Windows, Classes, SysUtils, StrUtils, Forms, ObjBase, ObjNpc, Envir, Grobal2, SDK;
type
  TMonGenInfo = record
    sMapName: string[14];
    nRace: Integer;
    nRange: Integer;
    nMissionGenRate: Integer;
    dwStartTick: LongWord;
    nX: Integer;
    nY: Integer;
    sMonName: string[14];
    nAreaX: Integer;
    nAreaY: Integer;
    nCount: Integer;
    dwZenTime: LongWord;
    dwStartTime: LongWord;
    CertList: TList;
    Envir: TEnvirnoment;
    TList_3C: TList;
  end;
  pTMonGenInfo = ^TMonGenInfo;

  TMapMonGenCount = record
    sMapName: string[14];
    nMonGenCount: Integer;
    dwNotHumTimeTick: LongWord;
    nClearCount: Integer;
    boNotHum: Boolean;
    dwMakeMonGenTimeTick: LongWord;
    nMonGenRate: Integer; //刷怪倍数  10
    dwRegenMonstersTime: LongWord; //刷怪速度    200
  end;
  pTMapMonGenCount = ^TMapMonGenCount;

  TUserEngine = class
    m_LoadPlaySection: TRTLCriticalSection;
    m_LoadPlayList: TStringList; //从DB读取人物数据
    m_PlayObjectList: TStringList; //0x8
    m_StringList_0C: TStringList;
    m_PlayObjectFreeList: TList; //0x10
    m_ChangeHumanDBGoldList: TList; //0x14
    dwShowOnlineTick: LongWord; //0x18
    dwSendOnlineHumTime: LongWord; //0x1C
    dwProcessMapDoorTick: LongWord; //0x20
    dwProcessMissionsTime: LongWord; //0x24
    dwRegenMonstersTick: LongWord; //0x28
    CalceTime: LongWord; //0x2C
    m_dwProcessLoadPlayTick: LongWord; //0x30
    dwTime_34: LongWord; //0x34
    m_nCurrMonGen: Integer; //0x38
    m_nMonGenListPosition: Integer; //0x3C
    m_nMonGenCertListPosition: Integer; //0x40
    m_nProcHumIDx: Integer; //0x44 处理人物开始索引（每次处理人物数限制）
    nProcessHumanLoopTime: Integer;
    nMerchantPosition: Integer; //0x4C
    nNpcPosition: Integer; //0x50
    StdItemList: TList; //List_54
    MonsterList: TList; //List_58
    m_MonGenList: TList; //List_5C
    m_MonFreeList: TList;
    m_MagicList: TList; //List_60
    m_MapMonGenCountList: TList;
    m_AdminList: TGList; //List_64
    m_MerchantList: TGList; //List_68
    QuestNPCList: TList; //0x6C
    List_70: TList;
    m_ChangeServerList: TList;
    m_MagicEventList: TList;
    m_PlayObjectLevelList: TList; //人物排行 等级

    nMonsterCount: Integer; //怪物总数
    nMonsterProcessPostion: Integer; //0x80处理怪物总数位置，用于计算怪物总数
    n84: Integer;
    nMonsterProcessCount: Integer; //0x88处理怪物数，用于统计处理怪物个数
    boItemEvent: Boolean; //ItemEvent
    n90: Integer;
    dwProcessMonstersTick: LongWord;
    dwProcessMerchantTimeMin: Integer;
    dwProcessMerchantTimeMax: Integer;
    dwProcessNpcTimeMin: LongWord;
    dwProcessNpcTimeMax: LongWord;
    m_NewHumanList: TList;
    m_ListOfGateIdx: TList;
    m_ListOfSocket: TList;
    OldMagicList: TList;
    m_nLimitUserCount: Integer; //限制用户数
    m_nLimitNumber: Integer; //限制使用天数或次数
    m_boStartLoadMagic: Boolean;
    dwSaveDataTick: LongWord;
    m_dwSearchTick: LongWord;
    m_dwGetTodyDayDateTick: LongWord;
    m_TodayDate: TDateTime;
  private
    procedure ProcessHumans();
    procedure ProcessMonsters();
    procedure ProcessMerchants();
    procedure ProcessNpcs();
    procedure ProcessMissions();
    procedure Process4AECFC();
    procedure ProcessEvents();
    procedure ProcessMapDoor();
    procedure NPCinitialize;
    procedure MerchantInitialize;
    function MonGetRandomItems(mon: TBaseObject): Integer;
    function RegenMonsters(MonGen: pTMonGenInfo; nCount: Integer): Boolean;
    procedure WriteShiftUserData;
    function GetGenMonCount(MonGen: pTMonGenInfo): Integer;
    function AddBaseObject(sMapName: string; nX, nY: Integer; nMonRace: Integer; sMonName: string): TBaseObject;
    function AddPlayObject(PlayObject: TPlayObject; nX, nY: Integer; sMonName: string): TBaseObject; //创建分身

    procedure GenShiftUserData();
    procedure KickOnlineUser(sChrName: string);
    function SendSwitchData(PlayObject: TPlayObject; nServerIndex: Integer): Boolean;
    procedure SendChangeServer(PlayObject: TPlayObject; nServerIndex: Integer);
    procedure SaveHumanRcd(PlayObject: TPlayObject);
    procedure AddToHumanFreeList(PlayObject: TPlayObject);

    procedure GetHumData(PlayObject: TPlayObject; var HumanRcd: THumDataInfo);
    function GetHomeInfo(var nX: Integer; var nY: Integer): string;
    function GetRandHomeX(PlayObject: TPlayObject): Integer;
    function GetRandHomeY(PlayObject: TPlayObject): Integer;
    function GetSwitchData(sChrName: string; nCode: Integer): pTSwitchDataInfo;
    procedure LoadSwitchData(SwitchData: pTSwitchDataInfo; var PlayObject: TPlayObject);
    procedure DelSwitchData(SwitchData: pTSwitchDataInfo);
    procedure MonInitialize(BaseObject: TBaseObject; sMonName: string);
    function MapRageHuman(sMapName: string; nMapX, nMapY, nRage: Integer): Boolean;
    function GetOnlineHumCount(): Integer;
    function GetUserCount(): Integer;
    function GetLoadPlayCount(): Integer;
    function GetAutoAddExpPlayCount: Integer;

  public
    constructor Create();
    destructor Destroy; override;
    procedure Initialize();
    procedure ClearItemList(); virtual;
    procedure SwitchMagicList();

    procedure Run();
    procedure PrcocessData();
    procedure Execute;
    function RegenMonsterByName(sMAP: string; nX, nY: Integer; sMonName: string): TBaseObject;
    function RegenPlayByName(PlayObject: TPlayObject; nX, nY: Integer; sMonName: string): TBaseObject;

    function GetStdItem(nItemIdx: Integer): pTStdItem; overload;
    function GetStdItem(sItemName: string): pTStdItem; overload;
    function GetStdItemWeight(nItemIdx: Integer): Integer;
    function GetStdItemName(nItemIdx: Integer): string;
    function GetStdItemIdx(sItemName: string): Integer;
    function FindOtherServerUser(sName: string; var nServerIndex): Boolean;
    procedure CryCry(wIdent: Word; pMap: TEnvirnoment; nX, nY, nWide: Integer; btFColor, btBColor: Byte; sMsg: string);
    procedure ProcessUserMessage(PlayObject: TPlayObject; DefMsg: pTDefaultMessage; Buff: PChar);
    procedure SendServerGroupMsg(nCode, nServerIdx: Integer; sMsg: string);
    function GetMonRace(sMonName: string): Integer;
    function InsMonstersList(MonGen: pTMonGenInfo; Monster: TAnimalObject): Boolean;
    function GetPlayObject(sName: string): TPlayObject;
    function GetPlayObjectEx(sAccount, sName: string): TPlayObject;
    function GetPlayObjectExOfAutoGetExp(sAccount: string): TPlayObject;
    function InPlayObjectList(PlayObject: TPlayObject): Boolean;
    procedure KickPlayObjectEx(sAccount, sName: string);
    function FindMerchant(Merchant: TObject): TMerchant;
    function FindNPC(GuildOfficial: TObject): TGuildOfficial;
    function InMerchantList(Merchant: TMerchant): Boolean;
    function InQuestNPCList(NPC: TNormNpc): Boolean;
    function CopyToUserItemFromName(sItemName: string; Item: pTUserItem): Boolean;
    function GetMapOfRangeHumanCount(Envir: TEnvirnoment; nX, nY, nRange: Integer): Integer;
    function GetHumPermission(sUserName: string; var sIPaddr: string; var btPermission: Byte): Boolean;
    procedure AddUserOpenInfo(UserOpenInfo: pTUserOpenInfo);
    procedure RandomUpgradeItem(Item: pTUserItem);
    procedure GetUnknowItemValue(Item: pTUserItem);
    function OpenDoor(Envir: TEnvirnoment; nX, nY: Integer): Boolean;
    function CloseDoor(Envir: TEnvirnoment; Door: pTDoorInfo): Boolean;
    procedure SendDoorStatus(Envir: TEnvirnoment; nX, nY: Integer; wIdent, wX: Word; nDoorX, nDoorY, nA: Integer; sStr: string);
    function FindMagic(sMagicName: string): pTMagic; overload;
    function FindMagic(nMagIdx: Integer): pTMagic; overload;
    function AddMagic(Magic: pTMagic): Boolean;
    function DelMagic(wMagicId: Word): Boolean;
    procedure AddMerchant(Merchant: TMerchant);
    function GetMerchantList(Envir: TEnvirnoment; nX, nY, nRange: Integer; TmpList: TList): Integer;
    function GetNpcList(Envir: TEnvirnoment; nX, nY, nRange: Integer; TmpList: TList): Integer;
    procedure ReloadMerchantList();
    procedure ReloadNpcList();
    procedure HumanExpire(sAccount: string);
    function GetMapMonster(Envir: TEnvirnoment; List: TList): Integer;
    function GetMapRangeMonster(Envir: TEnvirnoment; nX, nY, nRange: Integer; List: TList): Integer;
    function GetMapHuman(sMapName: string): Integer;
    function GetMapRageHuman(Envir: TEnvirnoment; nRageX, nRageY, nRage: Integer; List: TList): Integer;
    procedure SendBroadCastMsg(sMsg: string; MsgType: TMsgType);
    procedure SendBroadCastMsgExt(sMsg: string; MsgType: TMsgType);
    procedure sub_4AE514(GoldChangeInfo: pTGoldChangeInfo);
    procedure ClearMonSayMsg();
    procedure SendQuestMsg(sQuestName: string);
    procedure ClearMerchantData();
    function GetMapMonGenCount(sMapName: string): pTMapMonGenCount;
    function AddMapMonGenCount(sMapName: string; nMonGenCount: Integer): Integer;
    function ClearMonsters(sMapName: string): Boolean;

    property MonsterCount: Integer read nMonsterCount;
    property OnlinePlayObject: Integer read GetOnlineHumCount;
    property PlayObjectCount: Integer read GetUserCount;
    property AutoAddExpPlayCount: Integer read GetAutoAddExpPlayCount;
    property LoadPlayCount: Integer read GetLoadPlayCount;
  end;
var
  g_dwEngineTick: LongWord;
  g_dwEngineRunTime: LongWord;

implementation

uses IdSrvClient, Guild, ObjMon, EDcode, ObjGuard, ObjAxeMon, M2Share,
  ObjMon2, ObjPlayMon, Event, InterMsgClient, InterServerMsg, ObjRobot, HUtil32, svMain,
  Castle, PlugOfEngine, EDcodeUnit, Common;
{ TUserEngine }

constructor TUserEngine.Create();
begin
  InitializeCriticalSection(m_LoadPlaySection);
  m_LoadPlayList := TStringList.Create;
  m_PlayObjectList := TStringList.Create;
  m_StringList_0C := TStringList.Create;
  m_PlayObjectFreeList := TList.Create;
  m_ChangeHumanDBGoldList := TList.Create;
  dwShowOnlineTick := GetTickCount;
  dwSendOnlineHumTime := GetTickCount;
  dwProcessMapDoorTick := GetTickCount;
  dwProcessMissionsTime := GetTickCount;
  dwProcessMonstersTick := GetTickCount;
  dwRegenMonstersTick := GetTickCount;
  m_dwProcessLoadPlayTick := GetTickCount;
  dwSaveDataTick := GetTickCount;
  dwTime_34 := GetTickCount;
  m_nCurrMonGen := 0;
  m_nMonGenListPosition := 0;
  m_nMonGenCertListPosition := 0;
  m_nProcHumIDx := 0;
  nProcessHumanLoopTime := 0;
  nMerchantPosition := 0;
  nNpcPosition := 0;

 // m_nLimitNumber := 0;
 // m_nLimitUserCount := 0;
  m_nLimitNumber := 1000000;//20080630(注册)
  m_nLimitUserCount := 1000000;//20080630(注册)

  StdItemList := TList.Create; //List_54
  MonsterList := TList.Create;
  m_MonGenList := TList.Create;
  m_MonFreeList := TList.Create;
  m_MagicList := TList.Create;
  m_AdminList := TGList.Create;
  m_MerchantList := TGList.Create;
  QuestNPCList := TList.Create;
  List_70 := TList.Create;
  m_ChangeServerList := TList.Create;
  m_MagicEventList := TList.Create;
  m_MapMonGenCountList := TList.Create;
  boItemEvent := False;
  n90 := 1800000;
  dwProcessMerchantTimeMin := 0;
  dwProcessMerchantTimeMax := 0;
  dwProcessNpcTimeMin := 0;
  dwProcessNpcTimeMax := 0;
  m_NewHumanList := TList.Create;
  m_ListOfGateIdx := TList.Create;
  m_ListOfSocket := TList.Create;
  OldMagicList := TList.Create;
  m_boStartLoadMagic := False;
  m_dwSearchTick := GetTickCount;
  m_dwGetTodyDayDateTick := GetTickCount;
  m_TodayDate := 0;
  m_PlayObjectLevelList := TList.Create; //人物排行 等级
end;

destructor TUserEngine.Destroy;
var
  i: Integer;
  ii: Integer;
  MonInfo: pTMonInfo;
  MonGenInfo: pTMonGenInfo;
  MagicEvent: pTMagicEvent;
  TmpList: TList;
begin
  for i := 0 to m_LoadPlayList.Count - 1 do begin
    DisPose(pTUserOpenInfo(m_LoadPlayList.Objects[i]));
  end;
  m_LoadPlayList.Free;
  for i := 0 to m_PlayObjectList.Count - 1 do begin
    TPlayObject(m_PlayObjectList.Objects[i]).Free;
  end;
  m_PlayObjectList.Free;
  m_StringList_0C.Free;

  for i := 0 to m_PlayObjectFreeList.Count - 1 do begin
    TPlayObject(m_PlayObjectFreeList.Items[i]).Free;
  end;
  m_PlayObjectFreeList.Free;

  for i := 0 to m_ChangeHumanDBGoldList.Count - 1 do begin
    DisPose(pTGoldChangeInfo(m_ChangeHumanDBGoldList.Items[i]));
  end;
  m_ChangeHumanDBGoldList.Free;

  for i := 0 to StdItemList.Count - 1 do begin
    DisPose(pTStdItem(StdItemList.Items[i]));
  end;
  StdItemList.Free;

  for i := 0 to MonsterList.Count - 1 do begin
    MonInfo := MonsterList.Items[i];
    if MonInfo.ItemList <> nil then begin
      for ii := 0 to MonInfo.ItemList.Count - 1 do begin
        DisPose(pTMonItem(MonInfo.ItemList.Items[ii]));
      end;
      MonInfo.ItemList.Free;
    end;
    DisPose(MonInfo);
  end;
  MonsterList.Free;

  for i := 0 to m_MonGenList.Count - 1 do begin
    MonGenInfo := m_MonGenList.Items[i];
    for ii := 0 to MonGenInfo.CertList.Count - 1 do begin
      TBaseObject(MonGenInfo.CertList.Items[ii]).Free;
    end;
    DisPose(pTMonGenInfo(m_MonGenList.Items[i]));
  end;
  m_MonGenList.Free;

  for i := 0 to m_MonFreeList.Count - 1 do begin
    TBaseObject(m_MonFreeList.Items[i]).Free;
  end;
  m_MonFreeList.Free;

  for i := 0 to m_MagicList.Count - 1 do begin
    DisPose(pTMagic(m_MagicList.Items[i]));
  end;
  m_MagicList.Free;
  m_AdminList.Free;
  for i := 0 to m_MerchantList.Count - 1 do begin
    TMerchant(m_MerchantList.Items[i]).Free;
  end;
  m_MerchantList.Free;
  for i := 0 to QuestNPCList.Count - 1 do begin
    TNormNpc(QuestNPCList.Items[i]).Free;
  end;
  QuestNPCList.Free;
  List_70.Free;
  for i := 0 to m_ChangeServerList.Count - 1 do begin
    DisPose(pTSwitchDataInfo(m_ChangeServerList.Items[i]));
  end;
  m_ChangeServerList.Free;
  for i := 0 to m_MagicEventList.Count - 1 do begin
    MagicEvent := m_MagicEventList.Items[i];
    if MagicEvent.BaseObjectList <> nil then MagicEvent.BaseObjectList.Free;

    DisPose(MagicEvent);
  end;
  m_MagicEventList.Free;
  m_NewHumanList.Free;
  m_ListOfGateIdx.Free;
  m_ListOfSocket.Free;
  for i := 0 to OldMagicList.Count - 1 do begin
    TmpList := TList(OldMagicList.Items[i]);
    for ii := 0 to TmpList.Count - 1 do begin
      DisPose(pTMagic(TmpList.Items[ii]));
    end;
    TmpList.Free;
  end;
  for i := 0 to m_MapMonGenCountList.Count - 1 do begin
    DisPose(pTMapMonGenCount(m_MapMonGenCountList.Items[i]));
  end;
  m_MapMonGenCountList.Free;
  OldMagicList.Free;
  m_PlayObjectLevelList.Free; //人物排行 等级

  DeleteCriticalSection(m_LoadPlaySection);
  inherited;
end;

procedure TUserEngine.Initialize;
var
  i: Integer;
  MonGen: pTMonGenInfo;
begin
  MerchantInitialize();
  NPCinitialize();
  for i := 0 to m_MonGenList.Count - 1 do begin
    MonGen := m_MonGenList.Items[i];
    if MonGen <> nil then begin
      MonGen.nRace := GetMonRace(MonGen.sMonName);
    end;
  end;
end;

function TUserEngine.AddMapMonGenCount(sMapName: string; nMonGenCount: Integer): Integer;
var
  i: Integer;
  MapMonGenCount: pTMapMonGenCount;
  boFound: Boolean;
begin
  Result := -1;
  boFound := False;
  for i := 0 to m_MapMonGenCountList.Count - 1 do begin
    MapMonGenCount := m_MapMonGenCountList.Items[i];
    if MapMonGenCount <> nil then begin
      if CompareText(MapMonGenCount.sMapName, sMapName) = 0 then begin
        Inc(MapMonGenCount.nMonGenCount, nMonGenCount);
        Result := MapMonGenCount.nMonGenCount;
        boFound := True;
      end;
    end;
  end;
  if not boFound then begin
    New(MapMonGenCount);
    MapMonGenCount.sMapName := sMapName;
    MapMonGenCount.nMonGenCount := nMonGenCount;
    MapMonGenCount.dwNotHumTimeTick := GetTickCount;
    MapMonGenCount.dwMakeMonGenTimeTick := GetTickCount;
    MapMonGenCount.nClearCount := 0;
    MapMonGenCount.boNotHum := True;
    m_MapMonGenCountList.Add(MapMonGenCount);
    Result := MapMonGenCount.nMonGenCount;
  end;
end;

function TUserEngine.GetMapMonGenCount(sMapName: string): pTMapMonGenCount;
var
  i: Integer;
  MapMonGenCount: pTMapMonGenCount;
begin
  Result := nil;
  for i := 0 to m_MapMonGenCountList.Count - 1 do begin
    MapMonGenCount := m_MapMonGenCountList.Items[i];
    if MapMonGenCount <> nil then begin
      if CompareText(MapMonGenCount.sMapName, sMapName) = 0 then begin
        Result := MapMonGenCount;
        break;
      end;
    end;
  end;
end;

function TUserEngine.GetMonRace(sMonName: string): Integer;
var
  i: Integer;
  MonInfo: pTMonInfo;
begin
  Result := -1;
  for i := 0 to MonsterList.Count - 1 do begin
    MonInfo := MonsterList.Items[i];
    if MonInfo <> nil then begin
      if CompareText(MonInfo.sName, sMonName) = 0 then begin
        Result := MonInfo.btRace;
        break;
      end;
    end;
  end;
end;

procedure TUserEngine.MerchantInitialize;
var
  i: Integer;
  Merchant: TMerchant;
  sCaption: string;
begin
  sCaption := FrmMain.Caption;
  m_MerchantList.Lock;
  try
    for i := m_MerchantList.Count - 1 downto 0 do begin
      Merchant := TMerchant(m_MerchantList.Items[i]);
      if Merchant <> nil then begin
        Merchant.m_PEnvir := g_MapManager.FindMap(Merchant.m_sMapName);
        if Merchant.m_PEnvir <> nil then begin
          Merchant.Initialize; //FFFE
          if Merchant.m_boAddtoMapSuccess and (not Merchant.m_boIsHide) then begin
            MainOutMessage('Merchant Initalize fail...' + Merchant.m_sCharName + ' ' + Merchant.m_sMapName + '(' + IntToStr(Merchant.m_nCurrX) + ':' + IntToStr(Merchant.m_nCurrY) + ')');
            m_MerchantList.Delete(i);
            Merchant.Free;
          end else begin
            Merchant.LoadNpcScript();
            Merchant.LoadNPCData();
          end;
        end else begin
          MainOutMessage(Merchant.m_sCharName + 'Merchant Initalize fail... (m.PEnvir=nil)');
          m_MerchantList.Delete(i);
          Merchant.Free;
        end;
        FrmMain.Caption := sCaption + '[正在初始交易NPC(' + IntToStr(m_MerchantList.Count) + '/' + IntToStr(m_MerchantList.Count - i) + ')]';
        //Application.ProcessMessages;
      end;
    end;
  finally
    m_MerchantList.UnLock;
  end;
end;

procedure TUserEngine.NPCinitialize;
var
  i: Integer;
  NormNpc: TNormNpc;
begin
  for i := QuestNPCList.Count - 1 downto 0 do begin
    NormNpc := TNormNpc(QuestNPCList.Items[i]);
    if NormNpc <> nil then begin
      NormNpc.m_PEnvir := g_MapManager.FindMap(NormNpc.m_sMapName);
      if NormNpc.m_PEnvir <> nil then begin
        NormNpc.Initialize;
        if NormNpc.m_boAddtoMapSuccess and (not NormNpc.m_boIsHide) then begin
          MainOutMessage(NormNpc.m_sCharName + ' Npc Initalize fail... ');
          QuestNPCList.Delete(i);
          NormNpc.Free;
        end else begin
          NormNpc.LoadNpcScript();
        end;
      end else begin
        MainOutMessage(NormNpc.m_sCharName + ' Npc Initalize fail... (npc.PEnvir=nil) ');
        QuestNPCList.Delete(i);
        NormNpc.Free;
      end;
    end;
  end;
end;

function TUserEngine.GetLoadPlayCount: Integer;
begin
  Result := m_LoadPlayList.Count;
end;

function TUserEngine.GetOnlineHumCount: Integer;
begin
  Result := m_PlayObjectList.Count;
end;

function TUserEngine.GetUserCount: Integer;
begin
  Result := m_PlayObjectList.Count + m_StringList_0C.Count;
end;

function TUserEngine.GetAutoAddExpPlayCount: Integer;
var
  i: Integer;
  PlayObject: TPlayObject;
begin
  Result := 0;
  EnterCriticalSection(ProcessHumanCriticalSection);
  try
  for i := 0 to m_PlayObjectList.Count - 1 do begin
    PlayObject := TPlayObject(m_PlayObjectList.Objects[i]);
    if PlayObject <> nil then begin
      if PlayObject.m_boNotOnlineAddExp then Inc(Result);
    end;
  end;
  finally
    LeaveCriticalSection(ProcessHumanCriticalSection);
  end;
end;

procedure TUserEngine.ProcessHumans;
  function IsLogined(sAccount, sChrName: string): Boolean;
  var
    i: Integer;
  begin
    Result := False;
    if FrontEngine.InSaveRcdList(sAccount, sChrName) then begin
      Result := True;
    end else begin
      for i := 0 to m_PlayObjectList.Count - 1 do begin
        if (CompareText(pTUserOpenInfo(m_PlayObjectList.Objects[i]).sAccount, sAccount) = 0) and
          (CompareText(m_PlayObjectList.Strings[i], sChrName) = 0) then begin
          Result := True;
          break;
        end;
      end;
    end;
  end;

  function MakeNewHuman(UserOpenInfo: pTUserOpenInfo): TPlayObject;
  var
    PlayObject: TPlayObject;
    Abil: pTAbility;
    Envir: TEnvirnoment;
    nC: Integer;
    SwitchDataInfo: pTSwitchDataInfo;
    Castle: TUserCastle;
  resourcestring
    sExceptionMsg = '[Exception] TUserEngine::MakeNewHuman';
    sChangeServerFail1 = 'chg-server-fail-1 [%d] -> [%d] [%s]';
    sChangeServerFail2 = 'chg-server-fail-2 [%d] -> [%d] [%s]';
    sChangeServerFail3 = 'chg-server-fail-3 [%d] -> [%d] [%s]';
    sChangeServerFail4 = 'chg-server-fail-4 [%d] -> [%d] [%s]';
    sErrorEnvirIsNil = '[Error] PlayObject.PEnvir = nil';
  label
    ReGetMap;
  begin
    Result := nil;
    try
      PlayObject := TPlayObject.Create;
      if not g_Config.boVentureServer then begin
        UserOpenInfo.sChrName := '';
        UserOpenInfo.LoadUser.nSessionID := 0;
        SwitchDataInfo := GetSwitchData(UserOpenInfo.sChrName, UserOpenInfo.LoadUser.nSessionID);
      end else SwitchDataInfo := nil;

      SwitchDataInfo := nil;

      if SwitchDataInfo = nil then begin
        GetHumData(PlayObject, UserOpenInfo.HumanRcd);
        PlayObject.m_btRaceServer := RC_PLAYOBJECT;
        if PlayObject.m_sHomeMap = '' then begin
          ReGetMap:
          PlayObject.m_sHomeMap := GetHomeInfo(PlayObject.m_nHomeX, PlayObject.m_nHomeY);
          PlayObject.m_sMapName := PlayObject.m_sHomeMap;
          PlayObject.m_nCurrX := GetRandHomeX(PlayObject);
          PlayObject.m_nCurrY := GetRandHomeY(PlayObject);
          if PlayObject.m_Abil.Level >= 0 then begin
            Abil := @PlayObject.m_Abil;
            Abil.Level := 1;
            Abil.AC := 0;
            Abil.MAC := 0;
            Abil.DC := MakeLong(1, 2);
            Abil.MC := MakeLong(1, 2);
            Abil.SC := MakeLong(1, 2);
            Abil.MP := 15;
            Abil.HP := 15;
            Abil.MaxHP := 15;
            Abil.MaxMP := 15;
            Abil.Exp := 10;
            Abil.MaxExp := 100;
            Abil.Weight := 100;
            Abil.MaxWeight := 100;
            PlayObject.m_boNewHuman := True;
          end;
        end;
        Envir := g_MapManager.GetMapInfo(nServerIndex, PlayObject.m_sMapName);
        if Envir <> nil then begin
          if Envir.m_boFight3Zone then begin //是否在行会战争地图死亡
            if (PlayObject.m_Abil.HP <= 0) and (PlayObject.m_nFightZoneDieCount < 3) then begin
              PlayObject.m_Abil.HP := PlayObject.m_Abil.MaxHP;
              PlayObject.m_Abil.MP := PlayObject.m_Abil.MaxMP;
              PlayObject.m_boDieInFight3Zone := True;
            end else PlayObject.m_nFightZoneDieCount := 0;
          end;
        end;

        PlayObject.m_MyGuild := g_GuildManager.MemberOfGuild(PlayObject.m_sCharName);
        Castle := g_CastleManager.InCastleWarArea(Envir, PlayObject.m_nCurrX, PlayObject.m_nCurrY);
        {
        if (Envir <> nil) and ((UserCastle.m_MapPalace = Envir) or
          (UserCastle.m_boUnderWar and UserCastle.InCastleWarArea(PlayObject.m_PEnvir,PlayObject.m_nCurrX,PlayObject.m_nCurrY))) then begin
        }
        if (Envir <> nil) and (Castle <> nil) and ((Castle.m_MapPalace = Envir) or Castle.m_boUnderWar) then begin
          Castle := g_CastleManager.IsCastleMember(PlayObject);

          //if not UserCastle.IsMember(PlayObject) then begin
          if Castle = nil then begin
            PlayObject.m_sMapName := PlayObject.m_sHomeMap;
            PlayObject.m_nCurrX := PlayObject.m_nHomeX - 2 + Random(5);
            PlayObject.m_nCurrY := PlayObject.m_nHomeY - 2 + Random(5);
          end else begin
            {
            if UserCastle.m_MapPalace = Envir then begin
              PlayObject.m_sMapName:=UserCastle.GetMapName();
              PlayObject.m_nCurrX:=UserCastle.GetHomeX;
              PlayObject.m_nCurrY:=UserCastle.GetHomeY;
            end;
            }
            if Castle.m_MapPalace = Envir then begin
              PlayObject.m_sMapName := Castle.GetMapName();
              PlayObject.m_nCurrX := Castle.GetHomeX;
              PlayObject.m_nCurrY := Castle.GetHomeY;
            end;
          end;
        end;

        if (PlayObject.nC4 <= 1) and (PlayObject.m_Abil.Level >= 1) then
          PlayObject.nC4 := 2;
        if g_MapManager.FindMap(PlayObject.m_sMapName) = nil then
          PlayObject.m_Abil.HP := 0;
        if PlayObject.m_Abil.HP <= 0 then begin
          PlayObject.ClearStatusTime();
          if PlayObject.PKLevel < 2 then begin
            Castle := g_CastleManager.IsCastleMember(PlayObject);
            //            if UserCastle.m_boUnderWar and (UserCastle.IsMember(PlayObject)) then begin
            if (Castle <> nil) and Castle.m_boUnderWar then begin
              PlayObject.m_sMapName := Castle.m_sHomeMap;
              PlayObject.m_nCurrX := Castle.GetHomeX;
              PlayObject.m_nCurrY := Castle.GetHomeY;
            end else begin
              PlayObject.m_sMapName := PlayObject.m_sHomeMap;
              PlayObject.m_nCurrX := PlayObject.m_nHomeX - 2 + Random(5);
              PlayObject.m_nCurrY := PlayObject.m_nHomeY - 2 + Random(5);
            end;
          end else begin
            PlayObject.m_sMapName := g_Config.sRedDieHomeMap {'3'};
            PlayObject.m_nCurrX := Random(13) + g_Config.nRedDieHomeX {839};
            PlayObject.m_nCurrY := Random(13) + g_Config.nRedDieHomeY {668};
          end;
          PlayObject.m_Abil.HP := 14;
        end;

        PlayObject.AbilCopyToWAbil();
        Envir := g_MapManager.GetMapInfo(nServerIndex, PlayObject.m_sMapName);
        if Envir = nil then begin
          PlayObject.m_nSessionID := UserOpenInfo.LoadUser.nSessionID;
          PlayObject.m_nSocket := UserOpenInfo.LoadUser.nSocket;
          PlayObject.m_nGateIdx := UserOpenInfo.LoadUser.nGateIdx;
          PlayObject.m_nGSocketIdx := UserOpenInfo.LoadUser.nGSocketIdx;
          PlayObject.m_WAbil := PlayObject.m_Abil;
          PlayObject.m_nServerIndex := g_MapManager.GetMapOfServerIndex(PlayObject.m_sMapName);
          if PlayObject.m_Abil.HP <> 14 then begin
            MainOutMessage(format(sChangeServerFail1, [nServerIndex, PlayObject.m_nServerIndex, PlayObject.m_sMapName]));
            {MainOutMessage('chg-server-fail-1 [' +
                           IntToStr(nServerIndex) +
                           '] -> [' +
                           IntToStr(PlayObject.m_nServerIndex) +
                           '] [' +
                           PlayObject.m_sMapName +
                           ']');}
          end;
          SendSwitchData(PlayObject, PlayObject.m_nServerIndex);
          SendChangeServer(PlayObject, PlayObject.m_nServerIndex);
          //PlayObject.Free;
          FreeAndNil(PlayObject);
          Exit;
        end;
        nC := 0;
        while (True) do begin
          if Envir.CanWalk(PlayObject.m_nCurrX, PlayObject.m_nCurrY, True) then break;
          PlayObject.m_nCurrX := PlayObject.m_nCurrX - 3 + Random(6);
          PlayObject.m_nCurrY := PlayObject.m_nCurrY - 3 + Random(6);
          Inc(nC);
          if nC >= 5 then break;
        end;

        if not Envir.CanWalk(PlayObject.m_nCurrX, PlayObject.m_nCurrY, True) then begin
          MainOutMessage(format(sChangeServerFail2, [nServerIndex, PlayObject.m_nServerIndex, PlayObject.m_sMapName]));
          {  MainOutMessage('chg-server-fail-2 [' +
                           IntToStr(nServerIndex) +
                           '] -> [' +
                           IntToStr(PlayObject.m_nServerIndex) +
                           '] [' +
                           PlayObject.m_sMapName +
                           ']');}
          PlayObject.m_sMapName := g_Config.sHomeMap;
          Envir := g_MapManager.FindMap(g_Config.sHomeMap);
          PlayObject.m_nCurrX := g_Config.nHomeX;
          PlayObject.m_nCurrY := g_Config.nHomeY;
        end;

        PlayObject.m_PEnvir := Envir;
        if PlayObject.m_PEnvir = nil then begin
          MainOutMessage(sErrorEnvirIsNil);
          goto ReGetMap;
        end else begin
          PlayObject.m_boReadyRun := False;
        end;
      end else begin
        GetHumData(PlayObject, UserOpenInfo.HumanRcd);
        PlayObject.m_sMapName := SwitchDataInfo.sMAP;
        PlayObject.m_nCurrX := SwitchDataInfo.wX;
        PlayObject.m_nCurrY := SwitchDataInfo.wY;
        PlayObject.m_Abil := SwitchDataInfo.Abil;
        PlayObject.m_WAbil := SwitchDataInfo.Abil;
        LoadSwitchData(SwitchDataInfo, PlayObject);
        DelSwitchData(SwitchDataInfo);
        Envir := g_MapManager.GetMapInfo(nServerIndex, PlayObject.m_sMapName);
        if Envir <> nil then begin
          MainOutMessage(format(sChangeServerFail3, [nServerIndex, PlayObject.m_nServerIndex, PlayObject.m_sMapName]));
          {MainOutMessage('chg-server-fail-3 [' +
                         IntToStr(nServerIndex) +
                         '] -> [' +
                         IntToStr(PlayObject.m_nServerIndex) +
                         '] [' +
                         PlayObject.m_sMapName +
                         ']');}
          PlayObject.m_sMapName := g_Config.sHomeMap;
          Envir := g_MapManager.FindMap(g_Config.sHomeMap);
          PlayObject.m_nCurrX := g_Config.nHomeX;
          PlayObject.m_nCurrY := g_Config.nHomeY;
        end else begin
          if not Envir.CanWalk(PlayObject.m_nCurrX, PlayObject.m_nCurrY, True) then begin
            MainOutMessage(format(sChangeServerFail4, [nServerIndex, PlayObject.m_nServerIndex, PlayObject.m_sMapName]));
            {MainOutMessage('chg-server-fail-4 [' +
                           IntToStr(nServerIndex) +
                           '] -> [' +
                           IntToStr(PlayObject.m_nServerIndex) +
                           '] [' +
                           PlayObject.m_sMapName +
                           ']');}
            PlayObject.m_sMapName := g_Config.sHomeMap;
            Envir := g_MapManager.FindMap(g_Config.sHomeMap);
            PlayObject.m_nCurrX := g_Config.nHomeX;
            PlayObject.m_nCurrY := g_Config.nHomeY;
          end;
          PlayObject.AbilCopyToWAbil();
          PlayObject.m_PEnvir := Envir;
          if PlayObject.m_PEnvir = nil then begin
            MainOutMessage(sErrorEnvirIsNil);
            goto ReGetMap;
          end else begin
            PlayObject.m_boReadyRun := False;
            PlayObject.m_boLoginNoticeOK := True;
            PlayObject.bo6AB := True;
          end;
        end;
      end;
      PlayObject.m_sUserID := UserOpenInfo.LoadUser.sAccount;
      PlayObject.m_sIPaddr := UserOpenInfo.LoadUser.sIPaddr;
      PlayObject.m_sIPLocal := GetIPLocal(PlayObject.m_sIPaddr);
      PlayObject.m_nSocket := UserOpenInfo.LoadUser.nSocket;
      PlayObject.m_nGSocketIdx := UserOpenInfo.LoadUser.nGSocketIdx;
      PlayObject.m_nGateIdx := UserOpenInfo.LoadUser.nGateIdx;
      PlayObject.m_nSessionID := UserOpenInfo.LoadUser.nSessionID;
      PlayObject.m_nPayMent := UserOpenInfo.LoadUser.nPayMent;
      PlayObject.m_nPayMode := UserOpenInfo.LoadUser.nPayMode;
      PlayObject.m_dwLoadTick := UserOpenInfo.LoadUser.dwNewUserTick;
      PlayObject.m_nSoftVersionDateEx := GetExVersionNO(UserOpenInfo.LoadUser.nSoftVersionDate, PlayObject.m_nSoftVersionDate);
      Result := PlayObject;
    except
      MainOutMessage(sExceptionMsg);
    end;
  end;
  function GetToDayDate: Boolean;
  var
    wYear, wMonth, wDay: Word;
    wYear1, wMonth1, wDay1: Word;
  begin
    DecodeDate(m_TodayDate, wYear, wMonth, wDay);
    DecodeDate(Now, wYear1, wMonth1, wDay1);
    if (wYear = wYear1) and (wMonth = wMonth1) and (wDay = wDay1) then Result := True else Result := False;
  end;
type
  TGetLicense = function(var nUserLicense: Integer; var wErrorCode: Word): Integer; stdcall;
var
  dwUsrRotTime: LongWord;
  dwCheckTime: LongWord;
  dwCurTick: LongWord;
  nCheck30: Integer;
  boCheckTimeLimit: Boolean;
  nIdx: Integer;
  PlayObject: TPlayObject;
  i: Integer;
  UserOpenInfo: pTUserOpenInfo;
  GoldChangeInfo: pTGoldChangeInfo;
  LineNoticeMsg: string;

  nM2Crc: Integer;
  {m_nDay: Word;
  m_nUserCount: Word; }
  m_nUserLicense: Integer;
  m_nCheckServerCode: Integer;
  m_nErrorCode: Word;
  sUserKey: string;
  sCheckCode: string;
  boToDayDate: Boolean;
resourcestring
  sExceptionMsg1 = '[Exception] TUserEngine::ProcessHumans -> Ready, Save, Load... Code:=%d';
  sExceptionMsg2 = '[Exception] TUserEngine::ProcessHumans ClosePlayer.Delete - Free';
  sExceptionMsg3 = '[Exception] TUserEngine::ProcessHumans ClosePlayer.Delete';
  sExceptionMsg4 = '[Exception] TUserEngine::ProcessHumans RunNotice';
  sExceptionMsg5 = '[Exception] TUserEngine::ProcessHumans Human.Operate Code: %d';
  sExceptionMsg6 = '[Exception] TUserEngine::ProcessHumans Human.Finalize Code: %d';
  sExceptionMsg7 = '[Exception] TUserEngine::ProcessHumans RunSocket.CloseUser Code: %d';
  sExceptionMsg8 = '[Exception] TUserEngine::ProcessHumans';
begin
  nCheck30 := 0;
  dwCheckTime := GetTickCount();
  boToDayDate := True;
  if (GetTickCount - m_dwProcessLoadPlayTick) > 200 then begin
    m_dwProcessLoadPlayTick := GetTickCount();
    try
      EnterCriticalSection(m_LoadPlaySection);
      try
        for i := 0 to m_LoadPlayList.Count - 1 do begin
          UserOpenInfo := pTUserOpenInfo(m_LoadPlayList.Objects[i]);
          if UserOpenInfo = nil then Continue;
          if not FrontEngine.IsFull and not IsLogined(UserOpenInfo.sAccount, m_LoadPlayList.Strings[i]) then begin
            PlayObject := MakeNewHuman(UserOpenInfo);
            if PlayObject <> nil then begin
              //PlayObject.m_boClientFlag:=UserOpenInfo.LoadUser.boClinetFlag; //将客户端标志传到人物数据中
              m_PlayObjectList.AddObject(m_LoadPlayList.Strings[i], PlayObject);
              SendServerGroupMsg(SS_201, nServerIndex, PlayObject.m_sCharName);
              m_NewHumanList.Add(PlayObject);
            end;
          end else begin
            KickOnlineUser(m_LoadPlayList.Strings[i]);
            m_ListOfGateIdx.Add(Pointer(UserOpenInfo.LoadUser.nGateIdx));
            m_ListOfSocket.Add(Pointer(UserOpenInfo.LoadUser.nSocket));
          end;
          DisPose(pTUserOpenInfo(m_LoadPlayList.Objects[i]));
        end;
        m_LoadPlayList.Clear;
        for i := 0 to m_ChangeHumanDBGoldList.Count - 1 do begin
          GoldChangeInfo := m_ChangeHumanDBGoldList.Items[i];
          if GoldChangeInfo = nil then Continue;
          PlayObject := GetPlayObject(GoldChangeInfo.sGameMasterName);
          if PlayObject <> nil then begin
            PlayObject.GoldChange(GoldChangeInfo.sGetGoldUser, GoldChangeInfo.nGold);
          end;
          DisPose(GoldChangeInfo);
        end;
        m_ChangeHumanDBGoldList.Clear;
      finally
        LeaveCriticalSection(m_LoadPlaySection);
      end;

      for i := 0 to m_NewHumanList.Count - 1 do begin
        PlayObject := TPlayObject(m_NewHumanList.Items[i]);
        if PlayObject = nil then Continue;
        RunSocket.SetGateUserList(PlayObject.m_nGateIdx, PlayObject.m_nSocket, PlayObject);
      end;
      m_NewHumanList.Clear;

      for i := 0 to m_ListOfGateIdx.Count - 1 do begin
        RunSocket.CloseUser(Integer(m_ListOfGateIdx.Items[i]), Integer(m_ListOfSocket.Items[i])); //GateIdx,nSocket
      end;
      m_ListOfGateIdx.Clear;
      m_ListOfSocket.Clear;
    except
      on E: Exception do begin
        MainOutMessage(format(sExceptionMsg1, [0]));
        MainOutMessage(E.Message);
      end;
    end;
  end;
  try
    for i := 0 to m_PlayObjectFreeList.Count - 1 do begin //for i := 0 to m_PlayObjectFreeList.Count - 1 do begin
      PlayObject := TPlayObject(m_PlayObjectFreeList.Items[i]);
      if PlayObject = nil then Continue;
      if (GetTickCount - PlayObject.m_dwGhostTick) > g_Config.dwHumanFreeDelayTime {5 * 60 * 1000} then begin
        try
          TPlayObject(m_PlayObjectFreeList.Items[i]).Free;
        except
          MainOutMessage(sExceptionMsg2);
        end;
        m_PlayObjectFreeList.Delete(i);
        break;
      end else begin
        if PlayObject.m_boSwitchData and (PlayObject.m_boRcdSaved) then begin
          if SendSwitchData(PlayObject, PlayObject.m_nServerIndex) or (PlayObject.m_nWriteChgDataErrCount > 20) then begin
            PlayObject.m_boSwitchData := False;
            PlayObject.m_boSwitchDataSended := True;
            PlayObject.m_dwChgDataWritedTick := GetTickCount();
          end else Inc(PlayObject.m_nWriteChgDataErrCount);
        end;
        if PlayObject.m_boSwitchDataSended and ((GetTickCount - PlayObject.m_dwChgDataWritedTick) > 100) then begin
          PlayObject.m_boSwitchDataSended := False;
          SendChangeServer(PlayObject, PlayObject.m_nServerIndex);
        end;
      end;
    end;
  except
    MainOutMessage(sExceptionMsg3);
  end;
  {===================================重新获取授权===============================}
 (* if (GetTickCount - m_dwGetTodyDayDateTick) > 1000 * 60 then begin
    m_dwGetTodyDayDateTick := GetTickCount;
    boToDayDate := GetToDayDate;
  end;
  if ((GetTickCount - m_dwSearchTick) > 1000 * 60 * 60) or (not boToDayDate) then begin
    m_TodayDate := Now;
    m_dwSearchTick := GetTickCount;
    m_nCheckServerCode := 1000;
    m_nUserLicense := 0;
    nM2Crc := 0;
    Inc(nCrackedLevel, 5);
    if (g_nGetLicenseInfo >= 0) and Assigned(PlugProcArray[g_nGetLicenseInfo].nProcAddr) and (PlugProcArray[g_nGetLicenseInfo].nCheckCode = 20) then begin
      if Decode(PlugProcArray[g_nGetLicenseInfo].sCheckCode, sCheckCode) then begin
        if Str_ToInt(sCheckCode, 0) = 20 then begin
{$IF TESTMODE = 1}
          MainOutMessage('nCrackedLevel_1 ' + IntToStr(nCrackedLevel));
{$IFEND}
          Dec(nCrackedLevel);
          m_nCheckServerCode := 1001;
          nM2Crc := TGetLicense(PlugProcArray[g_nGetLicenseInfo].nProcAddr)(m_nUserLicense, m_nErrorCode);
          Inc(nErrorLevel, m_nErrorCode);
          m_nCheckServerCode := 1002;
          m_nLimitNumber := LoWord(m_nUserLicense);
          m_nLimitUserCount := HiWord(m_nUserLicense);
          if nM2Crc = nVersion then Dec(nCrackedLevel);
          m_nCheckServerCode := 1003;
          if Decode(sVersion, sUserKey) then Dec(nCrackedLevel);
          m_nCheckServerCode := 1004;
          if Str_ToInt(sUserKey, 0) = nVersion then Dec(nCrackedLevel);
          m_nCheckServerCode := 1005;
          if m_nCheckServerCode = 1005 then Dec(nCrackedLevel);
{$IF TESTMODE = 1}
          MainOutMessage('nM2Crc ' + IntToStr(nM2Crc));
          MainOutMessage('sUserKey ' + sUserKey);
          MainOutMessage('nCrackedLevel_2 ' + IntToStr(nCrackedLevel));
          MainOutMessage('m_nLimitNumber  ' + IntToStr(m_nLimitNumber));
          MainOutMessage('m_nLimitUserCount  ' + IntToStr(m_nLimitUserCount));
{$IFEND}
        end else begin
{$IF TESTMODE = 1}
          MainOutMessage('Str_ToInt(sCheckCode, 0) <> 20');
{$IFEND}
          m_nLimitNumber := 0;
          m_nLimitUserCount := 0;
        end;
      end else begin
{$IF TESTMODE = 1}
        MainOutMessage('not Decode');
{$IFEND}
        m_nLimitNumber := 0;
        m_nLimitUserCount := 0;
      end;
    end else begin
{$IF TESTMODE = 1}
      MainOutMessage('g_nGetLicenseInfo < 0');
{$IFEND}
      m_nLimitNumber := 0;
      m_nLimitUserCount := 0;
    end;
  end;
{$IF TESTMODE = 1}
  MainOutMessage('nCrackedLevel_3 ' + IntToStr(nCrackedLevel));
{$IFEND}   *)
 if ((GetTickCount - m_dwSearchTick) > 3600000{1000 * 60 * 60}) or (m_TodayDate <> Date) then begin
      m_TodayDate := Date;
      
      m_dwSearchTick := GetTickCount;//GetTickCount()用于获取自windows启动以来经历的时间长度（毫秒）
            m_nLimitNumber := 1000000; //20080210 实现免费版
        m_nLimitUserCount := 1000000; //20080210 实现免费版
    end;

  boCheckTimeLimit := False;
  try
    dwCurTick := GetTickCount();
    nIdx := m_nProcHumIDx;
    while True do begin
      if m_PlayObjectList.Count <= nIdx then break;
      PlayObject := TPlayObject(m_PlayObjectList.Objects[nIdx]);
      if PlayObject <> nil then begin
        if Integer(dwCurTick - PlayObject.m_dwRunTick) > PlayObject.m_nRunTime then begin
          PlayObject.m_dwRunTick := dwCurTick;
          if not PlayObject.m_boGhost then begin
            if not PlayObject.m_boLoginNoticeOK then begin
              try
                PlayObject.RunNotice();
              except
                MainOutMessage(sExceptionMsg4);
              end;
            end else begin
              try
                if not PlayObject.m_boReadyRun then begin
                  PlayObject.m_boNotOnlineAddExp := False;
                  PlayObject.m_boReadyRun := True;
                  PlayObject.UserLogon;
                end else begin
                  if (GetTickCount() - PlayObject.m_dwSearchTick) > PlayObject.m_dwSearchTime then begin
                    PlayObject.m_dwSearchTick := GetTickCount();
                    nCheck30 := 10;
                    PlayObject.SearchViewRange;
                    nCheck30 := 11;
                    PlayObject.GameTimeChanged;
                    nCheck30 := 12;
                  end;
                end;
                if (GetTickCount() - PlayObject.m_dwShowLineNoticeTick) > g_Config.dwShowLineNoticeTime then begin
                  PlayObject.m_dwShowLineNoticeTick := GetTickCount();
                  if LineNoticeList.Count > PlayObject.m_nShowLineNoticeIdx then begin

                    LineNoticeMsg := g_ManageNPC.GetLineVariableText(PlayObject, LineNoticeList.Strings[PlayObject.m_nShowLineNoticeIdx]);

                    //PlayObject.SysMsg(g_Config.sLineNoticePreFix + ' '+ LineNoticeList.Strings[PlayObject.m_nShowLineNoticeIdx],g_nLineNoticeColor);
                    nCheck30 := 13;
                    case LineNoticeMsg[1] of
                      'R': PlayObject.SysMsg(Copy(LineNoticeMsg, 2, Length(LineNoticeMsg) - 1), c_Red, t_Notice);
                      'G': PlayObject.SysMsg(Copy(LineNoticeMsg, 2, Length(LineNoticeMsg) - 1), c_Green, t_Notice);
                      'B': PlayObject.SysMsg(Copy(LineNoticeMsg, 2, Length(LineNoticeMsg) - 1), c_Blue, t_Notice);
                      else begin
                          PlayObject.SysMsg(LineNoticeMsg, TMsgColor(g_Config.nLineNoticeColor) {c_Blue}, t_Notice);
                        end;
                    end;
                  end;
                  Inc(PlayObject.m_nShowLineNoticeIdx);
                  if (LineNoticeList.Count <= PlayObject.m_nShowLineNoticeIdx) then
                    PlayObject.m_nShowLineNoticeIdx := 0;
                end;
                nCheck30 := 14;
                PlayObject.Run();
                nCheck30 := 15;
                if not FrontEngine.IsFull and ((GetTickCount() - PlayObject.m_dwSaveRcdTick) > g_Config.dwSaveHumanRcdTime) then begin
                  nCheck30 := 16;
                  PlayObject.m_dwSaveRcdTick := GetTickCount();
                  nCheck30 := 17;
                  PlayObject.DealCancelA();
                  nCheck30 := 18;
                  SaveHumanRcd(PlayObject);
                  nCheck30 := 19;
                end;
              except
                on E: Exception do begin
                  MainOutMessage(format(sExceptionMsg5, [nCheck30]));
                  MainOutMessage(E.Message);
                end;
              end;
            end;
          end else begin //if not PlayObject.boIsGhost then begin
            try
              m_PlayObjectList.Delete(nIdx);
              nCheck30 := 2;
              PlayObject.Disappear();
              nCheck30 := 3;
            except
              on E: Exception do begin
                MainOutMessage(format(sExceptionMsg6, [nCheck30]));
                MainOutMessage(E.Message);
              end;
            end;
            try
              AddToHumanFreeList(PlayObject);
              nCheck30 := 4;
              PlayObject.DealCancelA();
              SaveHumanRcd(PlayObject);
              RunSocket.CloseUser(PlayObject.m_nGateIdx, PlayObject.m_nSocket);
            except
              MainOutMessage(format(sExceptionMsg7, [nCheck30]));
            end;
            SendServerGroupMsg(SS_202, nServerIndex, PlayObject.m_sCharName);
            Continue;
          end;
        end; //if (dwTime14 - PlayObject.dw368) > PlayObject.dw36C then begin
        Inc(nIdx);
        if (GetTickCount - dwCheckTime) > g_dwHumLimit then begin
          boCheckTimeLimit := True;
          m_nProcHumIDx := nIdx;
          break;
        end;
      end; //while True do begin
    end;
    if not boCheckTimeLimit then m_nProcHumIDx := 0;
  except
    MainOutMessage(sExceptionMsg8);
  end;
  Inc(nProcessHumanLoopTime);
  g_nProcessHumanLoopTime := nProcessHumanLoopTime;
  if m_nProcHumIDx = 0 then begin
    nProcessHumanLoopTime := 0;
    g_nProcessHumanLoopTime := nProcessHumanLoopTime;
    dwUsrRotTime := GetTickCount - g_dwUsrRotCountTick;
    dwUsrRotCountMin := dwUsrRotTime;
    g_dwUsrRotCountTick := GetTickCount();
    if dwUsrRotCountMax < dwUsrRotTime then dwUsrRotCountMax := dwUsrRotTime;
  end;
  g_nHumCountMin := GetTickCount - dwCheckTime;
  if g_nHumCountMax < g_nHumCountMin then g_nHumCountMax := g_nHumCountMin;
end;

function TUserEngine.InMerchantList(Merchant: TMerchant): Boolean;
var
  i: Integer;
begin
  Result := False;
  for i := 0 to m_MerchantList.Count - 1 do begin
    if (Merchant <> nil) and (TMerchant(m_MerchantList.Items[i]) = Merchant) then begin
      Result := True;
      break;
    end;
  end;
end;

procedure TUserEngine.ProcessMerchants;
var
  dwRunTick, dwCurrTick: LongWord;
  i: Integer;
  MerchantNPC: TMerchant;
  boProcessLimit: Boolean;
resourcestring
  sExceptionMsg = '[Exception] TUserEngine::ProcessMerchants';
begin
  dwRunTick := GetTickCount();
  boProcessLimit := False;
  try
    dwCurrTick := GetTickCount();
    m_MerchantList.Lock;
    try
      i := nMerchantPosition;
      while True do begin // for i := nMerchantPosition to m_MerchantList.Count - 1 do begin
        if m_MerchantList.Count <= i then break;
        MerchantNPC := m_MerchantList.Items[i];
        if MerchantNPC <> nil then begin
          if not MerchantNPC.m_boGhost then begin
            if Integer(dwCurrTick - MerchantNPC.m_dwRunTick) > MerchantNPC.m_nRunTime then begin
              if (GetTickCount - MerchantNPC.m_dwSearchTick) > MerchantNPC.m_dwSearchTime then begin
                MerchantNPC.m_dwSearchTick := GetTickCount();
                MerchantNPC.SearchObjectViewRange();
              end;
              if Integer(dwCurrTick - MerchantNPC.m_dwRunTick) > MerchantNPC.m_nRunTime then begin
                MerchantNPC.m_dwRunTick := dwCurrTick;
                MerchantNPC.Run;
              end;
            end;
          end else begin
            if (GetTickCount - MerchantNPC.m_dwGhostTick) > 60 * 1000 then begin
              MerchantNPC.Free;
              m_MerchantList.Delete(i);
              break;
            end;
          end;
        end;
        if (GetTickCount - dwRunTick) > g_dwNpcLimit then begin
          nMerchantPosition := i;
          boProcessLimit := True;
          break;
        end;
        Inc(i);
      end;
    finally
      m_MerchantList.UnLock;
    end;
    if not boProcessLimit then begin
      nMerchantPosition := 0;
    end;
  except
    MainOutMessage(sExceptionMsg);
  end;
  dwProcessMerchantTimeMin := GetTickCount - dwRunTick;
  if dwProcessMerchantTimeMin > dwProcessMerchantTimeMax then dwProcessMerchantTimeMax := dwProcessMerchantTimeMin;
  if dwProcessNpcTimeMin > dwProcessNpcTimeMax then dwProcessNpcTimeMax := dwProcessNpcTimeMin;
end;

procedure TUserEngine.ProcessMissions;
begin

end;

function TUserEngine.InsMonstersList(MonGen: pTMonGenInfo; Monster: TAnimalObject): Boolean;
var
  i, ii: Integer;
  MonGenInfo: pTMonGenInfo;
begin
  Result := False;
  for i := 0 to m_MonGenList.Count - 1 do begin
    MonGenInfo := m_MonGenList.Items[i];
    if (MonGenInfo <> nil) and (MonGenInfo.CertList <> nil) and (MonGen <> nil) and (MonGen = MonGenInfo) then begin
      for ii := 0 to MonGenInfo.CertList.Count - 1 do begin
        if (Monster <> nil) and (TBaseObject(MonGenInfo.CertList.Items[ii]) = Monster) then begin
          Result := True;
          break;
        end;
      end;
    end;
  end;
end;

function TUserEngine.ClearMonsters(sMapName: string): Boolean;
var
  i, ii: Integer;
  {MonGenInfo: pTMonGenInfo;
  Monster: TAnimalObject; }
  MonList: TList;
  Envir: TEnvirnoment;
  BaseObject: TBaseObject;
begin
  Result := False;
  MonList := TList.Create;
  for i := 0 to g_MapManager.Count - 1 do begin
    Envir := TEnvirnoment(g_MapManager.Items[i]);
    if (Envir <> nil) and ((CompareText(Envir.sMapName, sMapName) = 0)) then begin
      UserEngine.GetMapMonster(Envir, MonList);
      for ii := 0 to MonList.Count - 1 do begin
        BaseObject := TBaseObject(MonList.Items[ii]);
        if BaseObject <> nil then begin
          if (BaseObject.m_btRaceServer <> 110) and (BaseObject.m_btRaceServer <> 111) and
            (BaseObject.m_btRaceServer <> 111) and (BaseObject.m_btRaceServer <> RC_GUARD) and
            (BaseObject.m_btRaceServer <> RC_ARCHERGUARD) and (BaseObject.m_btRaceServer <> 55) then begin
            BaseObject.m_boNoItem := True;
            BaseObject.m_WAbil.HP := 0;
          end;
        end;
      end;
    end;
  end;
  MonList.Free;

  {for i := 0 to m_MonGenList.Count - 1 do begin
    MonGenInfo := m_MonGenList.Items[i];
    if MonGenInfo = nil then Continue;
    if CompareText(MonGenInfo.sMapName, sMapName) = 0 then begin
      if (MonGenInfo.CertList <> nil) and (MonGenInfo.CertList.Count > 0) then begin
        for ii := 0 to MonGenInfo.CertList.Count - 1 do begin
          Monster := TAnimalObject(MonGenInfo.CertList.Items[ii]);
          if Monster <> nil then begin
            if (Monster.m_btRaceServer <> 110) and (Monster.m_btRaceServer <> 111) and
              (Monster.m_btRaceServer <> 111) and (Monster.m_btRaceServer <> RC_GUARD) and
              (Monster.m_btRaceServer <> RC_ARCHERGUARD) and (Monster.m_btRaceServer <> 55) then begin
              Monster.Free;
              if nMonsterCount > 0 then Dec(nMonsterCount);
              //DisPose();
            end;
          end;
          if MonGenInfo.CertList.Count <= 0 then begin
            MonGenInfo.CertList.Clear;
          end;
        end;
      end;
    end;
  end;}
  Result := True;
end;

procedure TUserEngine.ProcessMonsters;
  function GetZenTime(dwTime: LongWord): LongWord;
  var
    d10: Double;
  begin
    if dwTime < 30 * 60 * 1000 then begin
      d10 := (GetUserCount - g_Config.nUserFull {1000}) / g_Config.nZenFastStep {300};
      if d10 > 0 then begin
        if d10 > 6 then d10 := 6;
        Result := dwTime - ROUND((dwTime / 10) * d10)
      end else begin
        Result := dwTime;
      end;
    end else begin
      Result := dwTime;
    end;
  end;
var
  dwCurrentTick: LongWord;
  dwRunTick: LongWord;
  dwMonProcTick: LongWord;
  MonGen: pTMonGenInfo;
  nGenCount: Integer;
  nGenModCount: Integer;
  boProcessLimit: Boolean;
  boRegened: Boolean;
  i: Integer;
  nProcessPosition: Integer;
  Monster: TAnimalObject;
  tCode: Integer;
  nMakeMonsterCount: Integer;
  nActiveMonsterCount: Integer;
  nActiveHumCount: Integer;
  nNeedMakeMonsterCount: Integer;
  MapMonGenCount: pTMapMonGenCount;
  n10: Integer;
resourcestring
  sExceptionMsg = '[Exception] TUserEngine::ProcessMonsters %d %s';
begin
  tCode := 0;
  dwRunTick := GetTickCount();
  try
    tCode := 0;
    boProcessLimit := False;
    dwCurrentTick := GetTickCount();
    MonGen := nil;
    //刷新怪物开始
    if ((GetTickCount - dwRegenMonstersTick) > g_Config.dwRegenMonstersTime) then begin
      dwRegenMonstersTick := GetTickCount();
      if m_nCurrMonGen < m_MonGenList.Count then begin
        MonGen := m_MonGenList.Items[m_nCurrMonGen];
      end;
      if m_nCurrMonGen < m_MonGenList.Count - 1 then begin
        Inc(m_nCurrMonGen);
      end else begin
        m_nCurrMonGen := 0;
      end;
      if (MonGen <> nil) and (MonGen.sMonName <> '') and not g_Config.boVentureServer then begin
        if (MonGen.dwStartTick = 0) or ((GetTickCount - MonGen.dwStartTick) > GetZenTime(MonGen.dwZenTime)) then begin
          nGenCount := GetGenMonCount(MonGen);
          boRegened := True;
          if g_Config.nMonGenRate <= 0 then g_Config.nMonGenRate := 10; //防止除法错误
          nGenModCount := _MAX(1, ROUND(_MAX(1, MonGen.nCount) / (g_Config.nMonGenRate / 10)));
          nMakeMonsterCount := nGenModCount - nGenCount;
          if nMakeMonsterCount < 0 then nMakeMonsterCount := 0;
          {===============================智能刷怪========================================}
          {nGenModCount 需要刷怪数}
          {nGenCount 已经刷怪数}
          (*if (MonGen.Envir <> nil) and MonGen.Envir.m_boAutoMakeMonster then begin
            if (MonGen.nRace <> 110) or (MonGen.nRace <> 111) and
              (MonGen.nRace <> 111) or (MonGen.nRace <> RC_GUARD) and
              (MonGen.nRace <> RC_ARCHERGUARD) or (MonGen.nRace <> 55) then begin

              nActiveMonsterCount := GetMapMonster(MonGen.Envir, nil);
              MapMonGenCount := GetMapMonGenCount(MonGen.sMapName);
              nActiveHumCount := GetMapHuman(MonGen.sMapName);
              //n10 := GetMakeMonsterCount(nNeedMakeMonsterCount, nActiveMonsterCount);
              if MapMonGenCount <> nil then begin
                if (nActiveHumCount > 0) and (not MapMonGenCount.boNotHum) then begin
                  MapMonGenCount.boNotHum := True;
                end else
                  if (nActiveHumCount <= 0) and (MapMonGenCount.boNotHum) then begin
                  MapMonGenCount.boNotHum := False;
                  MapMonGenCount.dwNotHumTimeTick := GetTickCount;
                end;
                {清怪}
                if (GetTickCount - MapMonGenCount.dwNotHumTimeTick > 1000 * 60 * 5) and not MapMonGenCount.boNotHum then begin
                  MapMonGenCount.dwNotHumTimeTick := GetTickCount;
                  if nActiveMonsterCount > 0 then begin
                    if ClearMonsters(MonGen.sMapName) then begin
                      Inc(MapMonGenCount.nClearCount);
                    end;
                  end;
                  nMakeMonsterCount := 0;
                end;
                {刷怪}
                if MapMonGenCount.boNotHum then begin

                end;
              end;
            end;
          end;*)

          if nMakeMonsterCount > 0 then begin //0806 增加 控制刷怪数量比例
            if (nErrorLevel = 0) and (nCrackedLevel = 0) then begin
              boRegened := RegenMonsters(MonGen, nMakeMonsterCount);
            end else
              if dwStartTime < 60 * 60 * 10 then begin //破解后在10小时以内正常刷怪
              boRegened := RegenMonsters(MonGen, nMakeMonsterCount);
            end else begin

            end;
          end;
          if boRegened then begin
            MonGen.dwStartTick := GetTickCount();
          end;
        end;
        g_sMonGenInfo1 := MonGen.sMonName + ',' + IntToStr(m_nCurrMonGen) + '/' + IntToStr(m_MonGenList.Count);
      end;
    end;
    g_nMonGenTime := GetTickCount - dwCurrentTick;
    if g_nMonGenTime > g_nMonGenTimeMin then g_nMonGenTimeMin := g_nMonGenTime;
    if g_nMonGenTime > g_nMonGenTimeMax then g_nMonGenTimeMax := g_nMonGenTime;
    //刷新怪物结束
    dwMonProcTick := GetTickCount();
    nMonsterProcessCount := 0;
    tCode := 1;
    for i := m_nMonGenListPosition to m_MonGenList.Count - 1 do begin
      MonGen := m_MonGenList.Items[i];
      tCode := 11;
      if m_nMonGenCertListPosition < MonGen.CertList.Count then begin
        nProcessPosition := m_nMonGenCertListPosition;
      end else begin
        nProcessPosition := 0;
      end;
      m_nMonGenCertListPosition := 0;
      while (True) do begin
        if nProcessPosition >= MonGen.CertList.Count then break;
        Monster := MonGen.CertList.Items[nProcessPosition];
        tCode := 12;
        if Monster <> nil then begin
          if not Monster.m_boGhost then begin
            if Integer(dwCurrentTick - Monster.m_dwRunTick) > Monster.m_nRunTime then begin
              Monster.m_dwRunTick := dwRunTick;
              if (dwCurrentTick - Monster.m_dwSearchTick) > Monster.m_dwSearchTime then begin
                Monster.m_dwSearchTick := GetTickCount();
                tCode := 13;
                Monster.SearchObjectViewRange();
              end;
              tCode := 14;
              if not Monster.m_boIsVisibleActive and (Monster.m_nProcessRunCount < g_Config.nProcessMonsterInterval) then begin
                Inc(Monster.m_nProcessRunCount);
              end else begin
                Monster.m_nProcessRunCount := 0;
                Monster.Run;
              end;
              Inc(nMonsterProcessCount);
            end;
            Inc(nMonsterProcessPostion);
          end else begin
            if (GetTickCount - Monster.m_dwGhostTick) > 5 * 60 * 1000 then begin
              MonGen.CertList.Delete(nProcessPosition);
              Monster.Free;
              Continue;
            end;
          end;
        end;
        Inc(nProcessPosition);
        if (GetTickCount - dwMonProcTick) > g_dwMonLimit then begin
          g_sMonGenInfo2 := Monster.m_sCharName + '/' + IntToStr(i) + '/' + IntToStr(nProcessPosition);
          boProcessLimit := True;
          m_nMonGenCertListPosition := nProcessPosition;
          break;
        end;
      end; //while (True) do begin
      if boProcessLimit then break;
    end; //for I:= m_nMonGenListPosition to MonGenList.Count -1 do begin
    tCode := 2;
    if m_MonGenList.Count <= i then begin
      m_nMonGenListPosition := 0;
      nMonsterCount := nMonsterProcessPostion;
      nMonsterProcessPostion := 0;
      n84 := (n84 + nMonsterProcessCount) div 2;
    end;
    if not boProcessLimit then begin
      m_nMonGenListPosition := 0;
    end else begin
      m_nMonGenListPosition := i;
    end;
    g_nMonProcTime := GetTickCount - dwMonProcTick;
    if g_nMonProcTime > g_nMonProcTimeMin then g_nMonProcTimeMin := g_nMonProcTime;
    if g_nMonProcTime > g_nMonProcTimeMax then g_nMonProcTimeMax := g_nMonProcTime;
  except
    on E: Exception do begin
      if Monster <> nil then begin
        MainOutMessage(format(sExceptionMsg, [tCode, Monster.m_sCharName]));
        MainOutMessage(E.Message);
      end else begin
        MainOutMessage(format(sExceptionMsg, [tCode, '']));
        MainOutMessage(E.Message);
      end;
    end;
  end;
  g_nMonTimeMin := GetTickCount - dwRunTick;
  if g_nMonTimeMax < g_nMonTimeMin then g_nMonTimeMax := g_nMonTimeMin;
end;

function TUserEngine.GetGenMonCount(MonGen: pTMonGenInfo): Integer;
var
  i: Integer;
  nCount: Integer;
  BaseObject: TBaseObject;
begin
  nCount := 0;
  for i := 0 to MonGen.CertList.Count - 1 do begin
    BaseObject := TBaseObject(MonGen.CertList.Items[i]);
    if BaseObject <> nil then begin
      if not BaseObject.m_boDeath and not BaseObject.m_boGhost then Inc(nCount);
    end;
  end;
  Result := nCount;
end;

function TUserEngine.InQuestNPCList(NPC: TNormNpc): Boolean;
var
  i: Integer;
begin
  Result := False;
  for i := 0 to QuestNPCList.Count - 1 do begin
    if (NPC <> nil) and (TNormNpc(QuestNPCList.Items[i]) = NPC) then begin
      Result := True;
      break;
    end;
  end;
end;

procedure TUserEngine.ProcessNpcs;
var
  dwRunTick, dwCurrTick: LongWord;
  i: Integer;
  NPC: TNormNpc;
  boProcessLimit: Boolean;
begin
  dwRunTick := GetTickCount();
  boProcessLimit := False;
  try
    dwCurrTick := GetTickCount();
    for i := nNpcPosition to QuestNPCList.Count - 1 do begin
      NPC := QuestNPCList.Items[i];
      if NPC <> nil then begin
        if not NPC.m_boGhost then begin
          if Integer(dwCurrTick - NPC.m_dwRunTick) > NPC.m_nRunTime then begin
            if (GetTickCount - NPC.m_dwSearchTick) > NPC.m_dwSearchTime then begin
              NPC.m_dwSearchTick := GetTickCount();
              NPC.SearchObjectViewRange();
            end;
            if Integer(dwCurrTick - NPC.m_dwRunTick) > NPC.m_nRunTime then begin
              NPC.m_dwRunTick := dwCurrTick;
              NPC.Run;
            end;
          end;
        end else begin
          if (GetTickCount - NPC.m_dwGhostTick) > 60 * 1000 then begin
            NPC.Free;
            QuestNPCList.Delete(i);
            break;
          end;
        end;
      end;
      if (GetTickCount - dwRunTick) > g_dwNpcLimit then begin
        nNpcPosition := i;
        boProcessLimit := True;
        break;
      end;
    end;
    if not boProcessLimit then begin
      nNpcPosition := 0;
    end;
  except
    MainOutMessage('[Exceptioin] TUserEngine.ProcessNpcs');
  end;
  dwProcessNpcTimeMin := GetTickCount - dwRunTick;
  if dwProcessNpcTimeMin > dwProcessNpcTimeMax then dwProcessNpcTimeMax := dwProcessNpcTimeMin;
end;

function TUserEngine.RegenMonsterByName(sMAP: string; nX, nY: Integer;
  sMonName: string): TBaseObject;
var
  nRace: Integer;
  BaseObject: TBaseObject;
  n18: Integer;
  MonGen: pTMonGenInfo;
begin
  nRace := GetMonRace(sMonName);
  BaseObject := AddBaseObject(sMAP, nX, nY, nRace, sMonName);
  if BaseObject <> nil then begin
    n18 := m_MonGenList.Count - 1;
    if n18 < 0 then n18 := 0;
    MonGen := m_MonGenList.Items[n18];
    if MonGen <> nil then begin
      MonGen.CertList.Add(BaseObject);
      BaseObject.m_PEnvir.AddObject(1);
      BaseObject.m_boAddToMaped := True;
    end;
    //    MainOutMessage(format('MonGet Count:%d',[MonGen.CertList.Count]));
  end;
  Result := BaseObject;
end;

function TUserEngine.RegenPlayByName(PlayObject: TPlayObject; nX, nY: Integer;
  sMonName: string): TBaseObject;
var
  nRace: Integer;
  BaseObject: TBaseObject;
  n18: Integer;
  MonGen: pTMonGenInfo;
begin
  BaseObject := AddPlayObject(PlayObject, nX, nY, sMonName);
  if BaseObject <> nil then begin
    n18 := m_MonGenList.Count - 1;
    if n18 < 0 then n18 := 0;
    MonGen := m_MonGenList.Items[n18];
    MonGen.CertList.Add(BaseObject);
    BaseObject.m_PEnvir.AddObject(1);
    BaseObject.m_boAddToMaped := True;
    //    MainOutMessage(format('MonGet Count:%d',[MonGen.CertList.Count]));
  end;
  Result := BaseObject;
end;


procedure TUserEngine.Run;
//var
//  i:integer;
//  dwProcessTick:LongWord;
  procedure ShowOnlineCount();
  var
    nOnlineCount: Integer;
    nOnlineCount2: Integer;
    nAutoAddExpPlayCount: Integer;
  begin
    nOnlineCount := GetUserCount;
    nAutoAddExpPlayCount := GetAutoAddExpPlayCount;
    nOnlineCount2 := nOnlineCount - nAutoAddExpPlayCount;
    MainOutMessage(format('在线数: (%d/%d) %d', [nOnlineCount2, nAutoAddExpPlayCount, nOnlineCount]));
  end;
resourcestring
  sExceptionMsg = '[Exception] TUserEngine::Run';
begin
  CalceTime := GetTickCount;
  try
    if (GetTickCount() - dwShowOnlineTick) > g_Config.dwConsoleShowUserCountTime then begin
      dwShowOnlineTick := GetTickCount();
      NoticeManager.LoadingNotice;
      ShowOnlineCount();
      //MainOutMessage('在线数: ' + IntToStr(GetUserCount));
      g_CastleManager.Save;
    end;
    if (GetTickCount() - dwSendOnlineHumTime) > 10000 then begin
      dwSendOnlineHumTime := GetTickCount();
      FrmIDSoc.SendOnlineHumCountMsg(GetOnlineHumCount);
    end;
    if Assigned(zPlugOfEngine.UserEngineRun) then begin
      try
        zPlugOfEngine.UserEngineRun(Self);
      except
      end;
    end;
  except
    on E: Exception do begin
      MainOutMessage(sExceptionMsg);
      MainOutMessage(E.Message);
    end;
  end;
end;

function TUserEngine.GetStdItem(nItemIdx: Integer): pTStdItem;
begin
  Result := nil;
  Dec(nItemIdx);
  if (nItemIdx >= 0) and (StdItemList.Count > nItemIdx) then begin
    Result := StdItemList.Items[nItemIdx];
    if Result.Name = '' then Result := nil;
  end;
end;

function TUserEngine.GetStdItem(sItemName: string): pTStdItem;
var
  i: Integer;
  StdItem: pTStdItem;
begin
  Result := nil;
  if sItemName = '' then Exit;
  for i := 0 to StdItemList.Count - 1 do begin
    StdItem := StdItemList.Items[i];
    if CompareText(StdItem.Name, sItemName) = 0 then begin
      Result := StdItem;
      break;
    end;
  end;
end;

function TUserEngine.GetStdItemWeight(nItemIdx: Integer): Integer;
var
  StdItem: pTStdItem;
begin
  Dec(nItemIdx);
  if (nItemIdx >= 0) and (StdItemList.Count > nItemIdx) then begin
    StdItem := StdItemList.Items[nItemIdx];
    Result := StdItem.Weight;
  end else begin
    Result := 0;
  end;
end;

function TUserEngine.GetStdItemName(nItemIdx: Integer): string;
begin
  Result := '';
  Dec(nItemIdx);
  if (nItemIdx >= 0) and (StdItemList.Count > nItemIdx) then begin
    Result := pTStdItem(StdItemList.Items[nItemIdx]).Name;
  end else Result := '';
end;

function TUserEngine.FindOtherServerUser(sName: string;
  var nServerIndex): Boolean;
begin
  Result := False;
end;

procedure TUserEngine.CryCry(wIdent: Word; pMap: TEnvirnoment; nX, nY,
  nWide: Integer; btFColor, btBColor: Byte; sMsg: string); //黄字喊话
var
  i: Integer;
  PlayObject: TPlayObject;
begin
  for i := 0 to m_PlayObjectList.Count - 1 do begin
    PlayObject := TPlayObject(m_PlayObjectList.Objects[i]);
    if not PlayObject.m_boGhost and
      (PlayObject.m_PEnvir = pMap) and
      (PlayObject.m_boBanShout) and
      (abs(PlayObject.m_nCurrX - nX) < nWide) and
      (abs(PlayObject.m_nCurrY - nY) < nWide) then begin
      //PlayObject.SendMsg(nil,wIdent,0,0,$FFFF,0,sMsg);
      PlayObject.SendMsg(nil, wIdent, 0, btFColor, btBColor, 0, sMsg);
    end;
  end;
end;

function TUserEngine.MonGetRandomItems(mon: TBaseObject): Integer; //获取怪物爆物品
var
  i: Integer;
  ItemList: TList;
  iname: string;
  MonItem: pTMonItemInfo;
  UserItem: pTUserItem;
  StdItem: pTStdItem;
  Monster: pTMonInfo;
begin
  ItemList := nil;
  for i := 0 to MonsterList.Count - 1 do begin
    Monster := MonsterList.Items[i];
    if CompareText(Monster.sName, mon.m_sCharName) = 0 then begin
      ItemList := Monster.ItemList;
      break;
    end;
  end;
  if ItemList <> nil then begin
    for i := 0 to ItemList.Count - 1 do begin
      MonItem := pTMonItemInfo(ItemList[i]);
      if Random(MonItem.MaxPoint) <= MonItem.SelPoint then begin
        if CompareText(MonItem.ItemName, sSTRING_GOLDNAME) = 0 then begin
          mon.m_nGold := mon.m_nGold + (MonItem.Count div 2) + Random(MonItem.Count);
        end else begin
          //蜡聪农 酒捞袍 捞亥飘....
          iname := '';
          ////if (BoUniqueItemEvent) and (not mon.BoAnimal) then begin
          ////   if GetUniqueEvnetItemName (iname, numb) then begin
                //numb; //iname
          ////   end;
          ////end;
          if iname = '' then
            iname := MonItem.ItemName;

          New(UserItem);
          if CopyToUserItemFromName(iname, UserItem) then begin
            UserItem.Dura := ROUND((UserItem.DuraMax / 100) * (20 + Random(80)));

            StdItem := GetStdItem(UserItem.wIndex);
            ////if pstd <> nil then
            ////   if pstd.StdMode = 50 then begin  //惑前鼻
            ////      pu.Dura := numb;
            ////   end;
            if Random(g_Config.nMonRandomAddValue {10}) = 0 then
              RandomUpgradeItem(UserItem);
            if StdItem.StdMode in [15, 19, 20, 21, 22, 23, 24, 26] then begin
              if (StdItem.Shape = 130) or (StdItem.Shape = 131) or (StdItem.Shape = 132) then begin
                GetUnknowItemValue(UserItem);
              end;
            end;
            mon.m_ItemList.Add(UserItem)
          end else
            DisPose(UserItem);
        end;
      end;
    end;
  end;
  Result := 1;
end;

procedure TUserEngine.RandomUpgradeItem(Item: pTUserItem);
var
  StdItem: pTStdItem;
begin
  StdItem := GetStdItem(Item.wIndex);
  if StdItem = nil then Exit;
  case StdItem.StdMode of
    5, 6: ItemUnit.RandomUpgradeWeapon(Item); //004AD14A
    10, 11: ItemUnit.RandomUpgradeDress(Item);
    19: ItemUnit.RandomUpgrade19(Item);
    20, 21, 24: ItemUnit.RandomUpgrade202124(Item);
    26: ItemUnit.RandomUpgrade26(Item);
    22: ItemUnit.RandomUpgrade22(Item);
    23: ItemUnit.RandomUpgrade23(Item);
    15: ItemUnit.RandomUpgradeHelMet(Item);
  end;
end;

procedure TUserEngine.GetUnknowItemValue(Item: pTUserItem); //004AD1D4
var
  StdItem: pTStdItem;
begin
  StdItem := GetStdItem(Item.wIndex);
  if StdItem = nil then Exit;
  case StdItem.StdMode of
    15: ItemUnit.UnknowHelmet(Item);
    22, 23: ItemUnit.UnknowRing(Item);
    24, 26: ItemUnit.UnknowNecklace(Item);
  end;
end;

function TUserEngine.CopyToUserItemFromName(sItemName: string; Item: pTUserItem): Boolean;
var
  i: Integer;
  StdItem: pTStdItem;
begin
  Result := False;
  if sItemName <> '' then begin
    for i := 0 to StdItemList.Count - 1 do begin
      StdItem := StdItemList.Items[i];
      if CompareText(StdItem.Name, sItemName) = 0 then begin
        FillChar(Item^, SizeOf(TUserItem), #0);
        Item.wIndex := i + 1;
        Item.MakeIndex := GetItemNumber();
        Item.Dura := StdItem.DuraMax;
        Item.DuraMax := StdItem.DuraMax;
        Result := True;
        break;
      end;
    end;
  end;
end;

procedure TUserEngine.ProcessUserMessage(PlayObject: TPlayObject; DefMsg: pTDefaultMessage; Buff: PChar);
var
  sMsg: string;
  NewBuff: array[0..DATA_BUFSIZE - 1] of Char;
  sDefMsg: string;
resourcestring
  sExceptionMsg = '[Exception] TUserEngine::ProcessUserMessage..';
begin
  if (DefMsg = nil) or (PlayObject = nil) then Exit;
  try
    if Buff = nil then sMsg := ''
    else sMsg := StrPas(Buff);
    case DefMsg.Ident of
      CM_SPELL: begin //3017
          //MainOutMessage('TUserEngine.CM_SPELL');
          //if PlayObject.GetSpellMsgCount <=2 then  //如果队排里有超过二个魔法操作，则不加入队排
          if g_Config.boSpellSendUpdateMsg then begin //使用UpdateMsg 可以防止消息队列里有多个操作
            PlayObject.SendUpdateMsg(PlayObject,
              DefMsg.Ident,
              DefMsg.Tag,
              LoWord(DefMsg.Recog),
              HiWord(DefMsg.Recog),
              MakeLong(DefMsg.Param,
              DefMsg.Series),
              '');
          end else begin
            PlayObject.SendMsg(PlayObject,
              DefMsg.Ident,
              DefMsg.Tag,
              LoWord(DefMsg.Recog),
              HiWord(DefMsg.Recog),
              MakeLong(DefMsg.Param,
              DefMsg.Series),
              '');
          end;
        end;

      CM_QUERYUSERNAME: begin //80
          PlayObject.SendMsg(PlayObject, DefMsg.Ident, 0, DefMsg.Recog, DefMsg.Param {x}, DefMsg.Tag {y}, '');
        end;
      CM_DROPITEM,
        CM_TAKEONITEM,
        CM_TAKEOFFITEM,
        CM_1005,

      CM_MERCHANTDLGSELECT,
        CM_MERCHANTQUERYSELLPRICE,
        CM_USERSELLITEM,
        CM_USERBUYITEM,
        CM_USERGETDETAILITEM,

      CM_SENDSELLOFFITEM,
        CM_SENDSELLOFFITEMLIST, //拍卖
      CM_SENDQUERYSELLOFFITEM, //拍卖
      CM_SENDBUYSELLOFFITEM, //拍卖

      CM_CREATEGROUP,
        CM_ADDGROUPMEMBER,
        CM_DELGROUPMEMBER,
        CM_USERREPAIRITEM,
        CM_MERCHANTQUERYREPAIRCOST,
        CM_DEALTRY,
        CM_DEALADDITEM,
        CM_DEALDELITEM,

      CM_USERSTORAGEITEM,
        CM_USERTAKEBACKSTORAGEITEM,
        //      CM_WANTMINIMAP,
      CM_USERMAKEDRUGITEM,

      //      CM_GUILDHOME,
      CM_GUILDADDMEMBER,
        CM_GUILDDELMEMBER,
        CM_GUILDUPDATENOTICE,
        CM_GUILDUPDATERANKINFO: begin
          PlayObject.SendMsg(PlayObject,
            DefMsg.Ident,
            DefMsg.Series,
            DefMsg.Recog,
            DefMsg.Param,
            DefMsg.Tag,
            DeCodeString(sMsg));
        end;
      CM_PASSWORD,
        CM_CHGPASSWORD,
        CM_SETPASSWORD: begin
          PlayObject.SendMsg(PlayObject,
            DefMsg.Ident,
            DefMsg.Param,
            DefMsg.Recog,
            DefMsg.Series,
            DefMsg.Tag,
            DeCodeString(sMsg));
        end;
      CM_ADJUST_BONUS: begin //1043
          PlayObject.SendMsg(PlayObject,
            DefMsg.Ident,
            DefMsg.Series,
            DefMsg.Recog,
            DefMsg.Param,
            DefMsg.Tag,
            sMsg);
        end;
      CM_HORSERUN,
        CM_TURN,
        CM_WALK,
        CM_SITDOWN,
        CM_RUN,
        CM_HIT,
        CM_HEAVYHIT,
        CM_BIGHIT,

      CM_POWERHIT,
        CM_LONGHIT,
        CM_CRSHIT,
        CM_TWNHIT,
        CM_WIDEHIT,
        CM_FIREHIT: begin
          if g_Config.boActionSendActionMsg then begin //使用UpdateMsg 可以防止消息队列里有多个操作

            PlayObject.SendActionMsg(PlayObject,
              DefMsg.Ident,
              DefMsg.Tag,
              LoWord(DefMsg.Recog), {x}
              HiWord(DefMsg.Recog), {y}
              0,
              '');
          end else begin
            PlayObject.SendMsg(PlayObject,
              DefMsg.Ident,
              DefMsg.Tag,
              LoWord(DefMsg.Recog), {x}
              HiWord(DefMsg.Recog), {y}
              0,
              '');
          end;
        end;
      CM_SAY: begin
          PlayObject.SendMsg(PlayObject, CM_SAY, 0, 0, 0, 0, DeCodeString(sMsg));
        end;
         CM_OPENSHOP: begin    //商铺
          PlayObject.SendMsg(PlayObject,
            DefMsg.Ident,
            DefMsg.Series,
            DefMsg.Recog,
            DefMsg.Param,
            DefMsg.Tag,
            '');
        end;
      CM_BUYSHOPITEM: begin  //商铺
          PlayObject.SendUpdateMsg(PlayObject,
            DefMsg.Ident,
            DefMsg.Series,
            DefMsg.Recog,
            DefMsg.Param,
            DefMsg.Tag,
            DeCodeString(sMsg));
        end;
      else begin
          if Assigned(zPlugOfEngine.ObjectClientMsg) then begin
            try
              zPlugOfEngine.ObjectClientMsg(PlayObject, DefMsg, Buff, @NewBuff);
            except
            end;
            if @NewBuff = nil then sMsg := ''
            else sMsg := StrPas(@NewBuff);
          end else begin
            PlayObject.SendMsg(PlayObject,
              DefMsg.Ident,
              DefMsg.Series,
              DefMsg.Recog,
              DefMsg.Param,
              DefMsg.Tag,
              sMsg);
          end;
        end;
    end;
    if PlayObject.m_boReadyRun then begin
      case DefMsg.Ident of
        CM_TURN, CM_WALK, CM_SITDOWN, CM_RUN, CM_HIT, CM_HEAVYHIT, CM_BIGHIT,
          CM_POWERHIT, CM_LONGHIT,
          CM_WIDEHIT, CM_FIREHIT, CM_CRSHIT, CM_TWNHIT: begin
            Dec(PlayObject.m_dwRunTick, 100);
          end;
      end;
    end;
  except
    MainOutMessage(sExceptionMsg);
  end;
end;

procedure TUserEngine.SendServerGroupMsg(nCode, nServerIdx: Integer;
  sMsg: string);
begin
  if nServerIndex = 0 then begin
    FrmSrvMsg.SendSocketMsg(IntToStr(nCode) + '/' + EncodeString(IntToStr(nServerIdx)) + '/' + EncodeString(sMsg));
  end else begin
    FrmMsgClient.SendSocket(IntToStr(nCode) + '/' + EncodeString(IntToStr(nServerIdx)) + '/' + EncodeString(sMsg));
  end;
end;

function TUserEngine.AddPlayObject(PlayObject: TPlayObject; nX, nY: Integer; sMonName: string): TBaseObject; //004AD56C
var
  Map: TEnvirnoment;
  Cert: TBaseObject;
  n1C, n20, n24: Integer;
  p28: Pointer;
  sItemsName: string;
  UserItem: pTUserItem;
  UserMagic: pTUserMagic;
  MonsterMagic: pTUserMagic;
  MagicInfo: pTMagic;
  i: Integer;
  StdItem: pTStdItem;
begin
  Result := nil;
  Cert := nil;
  Map := g_MapManager.FindMap(PlayObject.m_sMapName);
  if Map = nil then Exit;
  Cert := TPlayMonster.Create;
  if Cert <> nil then begin
    //MonInitialize(Cert, sMonName);
    Cert.m_PEnvir := Map;
    Cert.m_sMapName := PlayObject.m_sMapName;
    Cert.m_nCurrX := nX;
    Cert.m_nCurrY := nY;
    Cert.m_btDirection := Random(8);
    Cert.m_sCharName := sMonName;
    Cert.m_Abil := PlayObject.m_Abil;
    Cert.m_Abil.HP := Cert.m_Abil.MaxHP;
    Cert.m_Abil.MP := Cert.m_Abil.MaxMP;
    //TPlayMonster(Cert).GetAbility(PlayObject.m_Abil);
    Cert.m_WAbil := Cert.m_Abil;
    Cert.m_btJob := PlayObject.m_btJob;
    Cert.m_btGender := PlayObject.m_btGender;
    Cert.m_btHair := PlayObject.m_btHair;
    Cert.m_btRaceImg := PlayObject.m_btRaceImg;
    for i := Low(THumanUseItems) to High(THumanUseItems) do begin
      if PlayObject.m_UseItems[i].wIndex > 0 then begin
        StdItem := UserEngine.GetStdItem(PlayObject.m_UseItems[i].wIndex);
        if StdItem <> nil then begin
          New(UserItem);
          if UserEngine.CopyToUserItemFromName(StdItem.Name, UserItem) then begin
            TPlayMonster(Cert).AddItems(UserItem, i);
          end;
          DisPose(UserItem);
        end;
      end;
    end;

    for i := 0 to PlayObject.m_MagicList.Count - 1 do begin //添加魔法
      UserMagic := PlayObject.m_MagicList.Items[i];
      if UserMagic <> nil then begin
        New(MonsterMagic);
        MonsterMagic.MagicInfo := UserMagic.MagicInfo;
        MonsterMagic.wMagIdx := UserMagic.wMagIdx;
        MonsterMagic.btLevel := UserMagic.btLevel;
        MonsterMagic.btKey := UserMagic.btKey;
        MonsterMagic.nTranPoint := UserMagic.nTranPoint;
        Cert.m_MagicList.Add(MonsterMagic);
      end;
    end;

    TPlayMonster(Cert).InitializeMonster; {初始化}

    Cert.RecalcAbilitys;

    if Random(100) < Cert.m_btCoolEye then Cert.m_boCoolEye := True;
    Cert.Initialize();
    if Cert.m_boAddtoMapSuccess then begin
      p28 := nil;
      if Cert.m_PEnvir.m_nWidth < 50 then n20 := 2
      else n20 := 3;
      if (Cert.m_PEnvir.m_nHeight < 250) then begin
        if (Cert.m_PEnvir.m_nHeight < 30) then n24 := 2
        else n24 := 20;
      end else n24 := 50;
      n1C := 0;
      while (True) do begin
        if not Cert.m_PEnvir.CanWalk(Cert.m_nCurrX, Cert.m_nCurrY, False) then begin
          if (Cert.m_PEnvir.m_nWidth - n24 - 1) > Cert.m_nCurrX then begin
            Inc(Cert.m_nCurrX, n20);
          end else begin
            Cert.m_nCurrX := Random(Cert.m_PEnvir.m_nWidth div 2) + n24;
            if Cert.m_PEnvir.m_nHeight - n24 - 1 > Cert.m_nCurrY then begin
              Inc(Cert.m_nCurrY, n20);
            end else begin
              Cert.m_nCurrY := Random(Cert.m_PEnvir.m_nHeight div 2) + n24;
            end;
          end;
        end else begin
          p28 := Cert.m_PEnvir.AddToMap(Cert.m_nCurrX, Cert.m_nCurrY, OS_MOVINGOBJECT, Cert);
          break;
        end;
        Inc(n1C);
        if n1C >= 31 then break;
      end;
      if p28 = nil then begin
        Cert.Free;
        Cert := nil;
      end;
    end;
  end;
  Result := Cert;
end;

function TUserEngine.AddBaseObject(sMapName: string; nX, nY: Integer; nMonRace: Integer; sMonName: string): TBaseObject; //004AD56C
var
  Map: TEnvirnoment;
  Cert: TBaseObject;
  n1C, n20, n24: Integer;
  p28: Pointer;
begin
  Result := nil;
  Cert := nil;
  Map := g_MapManager.FindMap(sMapName);
  if Map = nil then Exit;
  case nMonRace of
    11: Cert := TSuperGuard.Create;
    20: Cert := TArcherPolice.Create;
    51: begin
        Cert := TMonster.Create;
        Cert.m_boAnimal := True;
        Cert.m_nMeatQuality := Random(3500) + 3000;
        Cert.m_nBodyLeathery := 50;
      end;
    52: begin
        if Random(30) = 0 then begin
          Cert := TChickenDeer.Create;
          Cert.m_boAnimal := True;
          Cert.m_nMeatQuality := Random(20000) + 10000;
          Cert.m_nBodyLeathery := 150;
        end else begin
          Cert := TMonster.Create;
          Cert.m_boAnimal := True;
          Cert.m_nMeatQuality := Random(8000) + 8000;
          Cert.m_nBodyLeathery := 150;
        end;
      end;
    53: begin
        Cert := TATMonster.Create;
        Cert.m_boAnimal := True;
        Cert.m_nMeatQuality := Random(8000) + 8000;
        Cert.m_nBodyLeathery := 150;
      end;
    55: begin
        Cert := TTrainer.Create;
        Cert.m_btRaceServer := 55;
      end;
    80: Cert := TMonster.Create;
    81: Cert := TATMonster.Create;
    82: Cert := TSpitSpider.Create;
    83: Cert := TSlowATMonster.Create;
    84: Cert := TScorpion.Create;
    85: Cert := TStickMonster.Create;
    86: Cert := TATMonster.Create;
    87: Cert := TDualAxeMonster.Create;
    88: Cert := TATMonster.Create;
    89: Cert := TATMonster.Create;
    90: Cert := TGasAttackMonster.Create;
    91: Cert := TMagCowMonster.Create;
    92: Cert := TCowKingMonster.Create;
    93: Cert := TThornDarkMonster.Create;
    94: Cert := TLightingZombi.Create;
    95: begin
        Cert := TDigOutZombi.Create;
        if Random(2) = 0 then Cert.bo2BA := True;
      end;
    96: begin
        Cert := TZilKinZombi.Create;
        if Random(4) = 0 then Cert.bo2BA := True;
      end;
    97: begin
        Cert := TCowMonster.Create;
        if Random(2) = 0 then Cert.bo2BA := True;
      end;

    100: Cert := TWhiteSkeleton.Create;
    101: begin
        Cert := TScultureMonster.Create;
        Cert.bo2BA := True;
      end;
    102: Cert := TScultureKingMonster.Create;
    103: Cert := TBeeQueen.Create;
    104: Cert := TArcherMonster.Create;
    105: Cert := TGasMothMonster.Create; //楔蛾
    106: Cert := TGasDungMonster.Create;
    107: Cert := TCentipedeKingMonster.Create;
    110: Cert := TCastleDoor.Create;
    111: Cert := TWallStructure.Create;
    112: Cert := TArcherGuard.Create;
    113: Cert := TElfMonster.Create;
    114: Cert := TElfWarriorMonster.Create;
    115: Cert := TBigHeartMonster.Create;
    116: Cert := TSpiderHouseMonster.Create;
    117: Cert := TExplosionSpider.Create;
    118: Cert := THighRiskSpider.Create;
    119: Cert := TBigPoisionSpider.Create;
    120: Cert := TSoccerBall.Create;
    200: Cert := TElectronicScolpionMon.Create;
    150: Cert := TPlayMonster.Create;
  end;

  if Cert <> nil then begin
    MonInitialize(Cert, sMonName);
    Cert.m_PEnvir := Map;
    Cert.m_sMapName := sMapName;
    Cert.m_nCurrX := nX;
    Cert.m_nCurrY := nY;
    Cert.m_btDirection := Random(8);
    Cert.m_sCharName := sMonName;
    Cert.m_WAbil := Cert.m_Abil;
    if Random(100) < Cert.m_btCoolEye then Cert.m_boCoolEye := True;
    MonGetRandomItems(Cert); //取得怪物爆物品内容
    Cert.Initialize();

    if nMonRace = 150 then begin
      Cert.m_nCopyHumanLevel := 0;
      Cert.m_Abil.MP := Cert.m_Abil.MaxMP;
      Cert.m_Abil.HP := Cert.m_Abil.MaxHP;
      Cert.m_WAbil := Cert.m_Abil;
      TPlayMonster(Cert).InitializeMonster; {初始化人形怪物}
      Cert.RecalcAbilitys;
      //MainOutMessage('Cert.m_WAbil.HP:' + IntToStr(Cert.m_WAbil.HP));
    end;

    if Cert.m_boAddtoMapSuccess then begin
      p28 := nil;
      if Cert.m_PEnvir.m_nWidth < 50 then n20 := 2
      else n20 := 3;
      if (Cert.m_PEnvir.m_nHeight < 250) then begin
        if (Cert.m_PEnvir.m_nHeight < 30) then n24 := 2
        else n24 := 20;
      end else n24 := 50;
      n1C := 0;
      while (True) do begin
        if not Cert.m_PEnvir.CanWalk(Cert.m_nCurrX, Cert.m_nCurrY, False) then begin
          if (Cert.m_PEnvir.m_nWidth - n24 - 1) > Cert.m_nCurrX then begin
            Inc(Cert.m_nCurrX, n20);
          end else begin
            Cert.m_nCurrX := Random(Cert.m_PEnvir.m_nWidth div 2) + n24;
            if Cert.m_PEnvir.m_nHeight - n24 - 1 > Cert.m_nCurrY then begin
              Inc(Cert.m_nCurrY, n20);
            end else begin
              Cert.m_nCurrY := Random(Cert.m_PEnvir.m_nHeight div 2) + n24;
            end;
          end;
        end else begin
          p28 := Cert.m_PEnvir.AddToMap(Cert.m_nCurrX, Cert.m_nCurrY, OS_MOVINGOBJECT, Cert);
          break;
        end;
        Inc(n1C);
        if n1C >= 31 then break;
      end;
      if p28 = nil then begin
        Cert.Free;
        Cert := nil;
      end;
    end;
  end;
  Result := Cert;
end;
//====================================================
//功能:创建怪物对象
//返回值：在指定时间内创建完对象，则返加TRUE，如果超过指定时间则返回FALSE
//====================================================
function TUserEngine.RegenMonsters(MonGen: pTMonGenInfo; nCount: Integer): Boolean;
var
  dwStartTick: LongWord;

  nX: Integer;
  nY: Integer;
  i: Integer;
  Cert: TBaseObject;
resourcestring
  sExceptionMsg = '[Exception] TUserEngine::RegenMonsters';
begin
  Result := True;
  dwStartTick := GetTickCount();
  try
    if MonGen <> nil then begin
      if MonGen.nRace > 0 then begin
        if Random(100) < MonGen.nMissionGenRate then begin
          nX := (MonGen.nX - MonGen.nRange) + Random(MonGen.nRange * 2 + 1);
          nY := (MonGen.nY - MonGen.nRange) + Random(MonGen.nRange * 2 + 1);
          for i := 0 to nCount - 1 do begin
            Cert := AddBaseObject(MonGen.sMapName, ((nX - 10) + Random(20)), ((nY - 10) + Random(20)), MonGen.nRace, MonGen.sMonName);
            if Cert <> nil then MonGen.CertList.Add(Cert);
            if (GetTickCount - dwStartTick) > g_dwZenLimit then begin
              Result := False;
              break;
            end;
          end;
        end else begin
          for i := 0 to nCount - 1 do begin
            nX := (MonGen.nX - MonGen.nRange) + Random(MonGen.nRange * 2 + 1);
            nY := (MonGen.nY - MonGen.nRange) + Random(MonGen.nRange * 2 + 1);
            Cert := AddBaseObject(MonGen.sMapName, nX, nY, MonGen.nRace, MonGen.sMonName);
            if Cert <> nil then MonGen.CertList.Add(Cert);
            if (GetTickCount - dwStartTick) > g_dwZenLimit then begin
              Result := False;
              break;
            end;
          end;
        end;
      end;
    end;
  except
    MainOutMessage(sExceptionMsg);
  end;
end;

procedure TUserEngine.WriteShiftUserData();
begin

end;

function TUserEngine.GetPlayObject(sName: string): TPlayObject;
var
  i: Integer;
  PlayObject: TPlayObject;
begin
  Result := nil;
  for i := 0 to m_PlayObjectList.Count - 1 do begin
    if CompareText(m_PlayObjectList.Strings[i], sName) = 0 then begin
      PlayObject := TPlayObject(m_PlayObjectList.Objects[i]);
      if PlayObject <> nil then begin
        if (not PlayObject.m_boGhost) then begin
          if not (PlayObject.m_boPasswordLocked and PlayObject.m_boObMode and PlayObject.m_boAdminMode) then
            Result := PlayObject;
        end;
        break;
      end;
    end;
  end;
end;

function TUserEngine.InPlayObjectList(PlayObject: TPlayObject): Boolean;
var
  i: Integer;
begin
  Result := False;
  for i := 0 to m_PlayObjectList.Count - 1 do begin
    if (PlayObject <> nil) and (PlayObject = TPlayObject(m_PlayObjectList.Objects[i])) then begin
      Result := True;
      break;
    end;
  end;
end;

procedure TUserEngine.KickPlayObjectEx(sAccount, sName: string);
var
  i: Integer;
  PlayObject: TPlayObject;
begin
  EnterCriticalSection(ProcessHumanCriticalSection);
  try
    for i := 0 to m_PlayObjectList.Count - 1 do begin
      PlayObject := TPlayObject(m_PlayObjectList.Objects[i]);
      if PlayObject <> nil then begin
        if (CompareText(PlayObject.m_sUserID, sAccount) = 0) and
          (CompareText(m_PlayObjectList.Strings[i], sName) = 0) then begin
          PlayObject.m_boEmergencyClose := True;
          PlayObject.m_boPlayOffLine := False;
          break;
        end;
      end;
    end;
  finally
    LeaveCriticalSection(ProcessHumanCriticalSection);
  end;
end;

function TUserEngine.GetPlayObjectEx(sAccount, sName: string): TPlayObject;
var
  i: Integer;
  PlayObject: TPlayObject;
begin
  Result := nil;
  EnterCriticalSection(ProcessHumanCriticalSection);
  try
    for i := 0 to m_PlayObjectList.Count - 1 do begin
      PlayObject := TPlayObject(m_PlayObjectList.Objects[i]);
      if PlayObject <> nil then begin
        if (CompareText(PlayObject.m_sUserID, sAccount) = 0) and
          (CompareText(m_PlayObjectList.Strings[i], sName) = 0) then begin
          Result := PlayObject;
          break;
        end;
      end;
    end;
  finally
    LeaveCriticalSection(ProcessHumanCriticalSection);
  end;
end;

function TUserEngine.GetPlayObjectExOfAutoGetExp(sAccount: string): TPlayObject; //获取离线挂人物
var
  i: Integer;
  PlayObject: TPlayObject;
begin
  Result := nil;
  EnterCriticalSection(ProcessHumanCriticalSection);
  try
    for i := 0 to m_PlayObjectList.Count - 1 do begin
      PlayObject := TPlayObject(m_PlayObjectList.Objects[i]);
      if PlayObject <> nil then begin
        if (CompareText(PlayObject.m_sUserID, sAccount) = 0) and PlayObject.m_boNotOnlineAddExp then begin
          Result := PlayObject;
          break;
        end;
      end;
    end;
  finally
    LeaveCriticalSection(ProcessHumanCriticalSection);
  end;
end;

function TUserEngine.FindMerchant(Merchant: TObject): TMerchant;
var
  i: Integer;
begin
  Result := nil;
  m_MerchantList.Lock;
  try
    for i := 0 to m_MerchantList.Count - 1 do begin
      if (TObject(m_MerchantList.Items[i]) <> nil) and (TObject(m_MerchantList.Items[i]) = Merchant) then begin
        Result := TMerchant(m_MerchantList.Items[i]);
        break;
      end;
    end;
  finally
    m_MerchantList.UnLock;
  end;
end;

function TUserEngine.FindNPC(GuildOfficial: TObject): TGuildOfficial;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to QuestNPCList.Count - 1 do begin
    if (TObject(QuestNPCList.Items[i]) <> nil) and (TObject(QuestNPCList.Items[i]) = GuildOfficial) then begin
      Result := TGuildOfficial(QuestNPCList.Items[i]);
      break;
    end;
  end;
end;

function TUserEngine.GetMapOfRangeHumanCount(Envir: TEnvirnoment; nX, nY,
  nRange: Integer): Integer;
var
  i: Integer;
  PlayObject: TPlayObject;
begin
  Result := 0;
  for i := 0 to m_PlayObjectList.Count - 1 do begin
    PlayObject := TPlayObject(m_PlayObjectList.Objects[i]);
    if PlayObject <> nil then begin
      if not PlayObject.m_boGhost and (PlayObject.m_PEnvir = Envir) then begin
        if (abs(PlayObject.m_nCurrX - nX) < nRange) and (abs(PlayObject.m_nCurrY - nY) < nRange) then Inc(Result);
      end;
    end;
  end;
end;

function TUserEngine.GetHumPermission(sUserName: string; var sIPaddr: string; var btPermission: Byte): Boolean; //4AE590
var
  i: Integer;
  AdminInfo: pTAdminInfo;
begin
  Result := False;
  btPermission := g_Config.nStartPermission;
  m_AdminList.Lock;
  try
    for i := 0 to m_AdminList.Count - 1 do begin
      AdminInfo := m_AdminList.Items[i];
      if AdminInfo <> nil then begin
        if CompareText(AdminInfo.sChrName, sUserName) = 0 then begin
          btPermission := AdminInfo.nLv;
          sIPaddr := AdminInfo.sIPaddr;
          Result := True;
          break;
        end;
      end;
    end;
  finally
    m_AdminList.UnLock;
  end;
end;

procedure TUserEngine.GenShiftUserData;
begin

end;

procedure TUserEngine.AddUserOpenInfo(UserOpenInfo: pTUserOpenInfo);
begin
  EnterCriticalSection(m_LoadPlaySection);
  try
    m_LoadPlayList.AddObject(UserOpenInfo.sChrName, TObject(UserOpenInfo));
  finally
    LeaveCriticalSection(m_LoadPlaySection);
  end;
end;

procedure TUserEngine.KickOnlineUser(sChrName: string);
var
  i: Integer;
  PlayObject: TPlayObject;
begin
  for i := 0 to m_PlayObjectList.Count - 1 do begin
    PlayObject := TPlayObject(m_PlayObjectList.Objects[i]);
    if PlayObject <> nil then begin
      if CompareText(PlayObject.m_sCharName, sChrName) = 0 then begin
        PlayObject.m_boKickFlag := True;
        break;
      end;
    end;
  end;
end;

function TUserEngine.SendSwitchData(PlayObject: TPlayObject; nServerIndex: Integer): Boolean;
begin
  Result := True;
end;

procedure TUserEngine.SendChangeServer(PlayObject: TPlayObject; nServerIndex: Integer);
var
  sIPaddr: string;
  nPort: Integer;
resourcestring
  sMsg = '%s/%d';
begin
  if GetMultiServerAddrPort(nServerIndex, sIPaddr, nPort) then begin
    PlayObject.SendDefMessage(SM_RECONNECT, 0, 0, 0, 0, format(sMsg, [sIPaddr, nPort]));
  end;
end;

procedure TUserEngine.SaveHumanRcd(PlayObject: TPlayObject);
var
  SaveRcd: pTSaveRcd;
begin
  New(SaveRcd);
  FillChar(SaveRcd^, SizeOf(TSaveRcd), #0);
  SaveRcd.sAccount := PlayObject.m_sUserID;
  SaveRcd.sChrName := PlayObject.m_sCharName;
  SaveRcd.nSessionID := PlayObject.m_nSessionID;
  SaveRcd.PlayObject := PlayObject;
  SaveRcd.nReTryCount := 0;
  SaveRcd.dwSaveTick := GetTickCount;
  PlayObject.MakeSaveRcd(SaveRcd.HumanRcd);
  //FrontEngine.AddToSaveRcdList(SaveRcd);
  FrontEngine.UpDataSaveRcdList(SaveRcd); //2006-11-12修改
end;

procedure TUserEngine.AddToHumanFreeList(PlayObject: TPlayObject);
begin
  PlayObject.m_dwGhostTick := GetTickCount();
  m_PlayObjectFreeList.Add(PlayObject);
end;

function TUserEngine.GetSwitchData(sChrName: string; nCode: Integer): pTSwitchDataInfo;
var
  i: Integer;
  SwitchData: pTSwitchDataInfo;
begin
  Result := nil;
  for i := 0 to m_ChangeServerList.Count - 1 do begin
    SwitchData := m_ChangeServerList.Items[i];
    if SwitchData <> nil then begin
      if (CompareText(SwitchData.sChrName, sChrName) = 0) and (SwitchData.nCode = nCode) then begin
        Result := SwitchData;
        break;
      end;
    end;
  end;
end;

procedure TUserEngine.GetHumData(PlayObject: TPlayObject;
  var HumanRcd: THumDataInfo);
var
  HumData: pTHumData;
  HumItems: pTHumItems;
  HumAddItems: pTHumAddItems;
  BagItems: pTBagItems;
  UserItem: pTUserItem;
  HumMagics: pTHumMagics;
  UserMagic: pTUserMagic;
  MagicInfo: pTMagic;
  StorageItems: pTStorageItems;
  i: Integer;
begin
  HumData := @HumanRcd.Data;
  PlayObject.m_sCharName := HumData.sChrName;
  PlayObject.m_sMapName := HumData.sCurMap;
  PlayObject.m_nCurrX := HumData.wCurX;
  PlayObject.m_nCurrY := HumData.wCurY;
  PlayObject.m_btDirection := HumData.btDir;
  PlayObject.m_btHair := HumData.btHair;
  PlayObject.m_btGender := HumData.btSex;
  PlayObject.m_btJob := HumData.btJob;
  PlayObject.m_nGold := HumData.nGold;

  PlayObject.m_Abil.Level := HumData.Abil.Level;

  PlayObject.m_Abil.HP := HumData.Abil.HP;
  PlayObject.m_Abil.MP := HumData.Abil.MP;
  PlayObject.m_Abil.MaxHP := HumData.Abil.MaxHP;
  PlayObject.m_Abil.MaxMP := HumData.Abil.MaxMP;
  PlayObject.m_Abil.Exp := HumData.Abil.Exp;
  PlayObject.m_Abil.MaxExp := HumData.Abil.MaxExp;
  PlayObject.m_Abil.Weight := HumData.Abil.Weight;
  PlayObject.m_Abil.MaxWeight := HumData.Abil.MaxWeight;
  PlayObject.m_Abil.WearWeight := HumData.Abil.WearWeight;
  PlayObject.m_Abil.MaxWearWeight := HumData.Abil.MaxWearWeight;
  PlayObject.m_Abil.HandWeight := HumData.Abil.HandWeight;
  PlayObject.m_Abil.MaxHandWeight := HumData.Abil.MaxHandWeight;
  if PlayObject.m_Abil.Exp <= 0 then PlayObject.m_Abil.Exp := 1;
  if PlayObject.m_Abil.MaxExp <= 0 then begin
    PlayObject.m_Abil.MaxExp := PlayObject.GetLevelExp(PlayObject.m_Abil.Level);
  end;
  //PlayObject.m_Abil:=HumData.Abil;

  PlayObject.m_wStatusTimeArr := HumData.wStatusTimeArr;
  PlayObject.m_sHomeMap := HumData.sHomeMap;
  PlayObject.m_nHomeX := HumData.wHomeX;
  PlayObject.m_nHomeY := HumData.wHomeY;
  PlayObject.m_BonusAbil := HumData.BonusAbil; // 08/09
  PlayObject.m_nBonusPoint := HumData.nBonusPoint; // 08/09
  PlayObject.m_btCreditPoint := HumData.btCreditPoint;
  PlayObject.m_btReLevel := HumData.btReLevel;

  PlayObject.m_sMasterName := HumData.sMasterName;
  PlayObject.m_boMaster := HumData.boMaster;
  PlayObject.m_sDearName := HumData.sDearName;

  PlayObject.m_sStoragePwd := HumData.sStoragePwd;
  if PlayObject.m_sStoragePwd <> '' then
    PlayObject.m_boPasswordLocked := True;

  PlayObject.m_nGameGold := HumData.nGameGold;
  PlayObject.m_nGamePoint := HumData.nGamePoint;
  PlayObject.m_nPayMentPoint := HumData.nPayMentPoint;

  PlayObject.m_nPkPoint := HumData.nPKPOINT;
  if HumData.btAllowGroup > 0 then PlayObject.m_boAllowGroup := True
  else PlayObject.m_boAllowGroup := False;
  PlayObject.btB2 := HumData.btF9;
  PlayObject.m_btAttatckMode := HumData.btAttatckMode;
  PlayObject.m_nIncHealth := HumData.btIncHealth;
  PlayObject.m_nIncSpell := HumData.btIncSpell;
  PlayObject.m_nIncHealing := HumData.btIncHealing;
  PlayObject.m_nFightZoneDieCount := HumData.btFightZoneDieCount;
  PlayObject.m_sUserID := HumData.sAccount;
  PlayObject.nC4 := HumData.btEE;
  PlayObject.m_boLockLogon := HumData.boLockLogon;

  PlayObject.m_wContribution := HumData.wContribution;
  PlayObject.btC8 := HumData.btEF;
  PlayObject.m_nHungerStatus := HumData.nHungerStatus;
  PlayObject.m_boAllowGuildReCall := HumData.boAllowGuildReCall;
  PlayObject.m_wGroupRcallTime := HumData.wGroupRcallTime;
  PlayObject.m_dBodyLuck := HumData.dBodyLuck;
  PlayObject.m_boAllowGroupReCall := HumData.boAllowGroupReCall;
  {PlayObject.m_QuestUnitOpen := HumData.QuestUnitOpen;
  PlayObject.m_QuestUnit := HumData.QuestUnit; }
  PlayObject.m_QuestFlag := HumData.QuestFlag;
  HumItems := @HumanRcd.Data.HumItems;
  PlayObject.m_UseItems[U_DRESS] := HumItems[U_DRESS];
  PlayObject.m_UseItems[U_WEAPON] := HumItems[U_WEAPON];
  PlayObject.m_UseItems[U_RIGHTHAND] := HumItems[U_RIGHTHAND];
  PlayObject.m_UseItems[U_NECKLACE] := HumItems[U_HELMET];
  PlayObject.m_UseItems[U_HELMET] := HumItems[U_NECKLACE];
  PlayObject.m_UseItems[U_ARMRINGL] := HumItems[U_ARMRINGL];
  PlayObject.m_UseItems[U_ARMRINGR] := HumItems[U_ARMRINGR];
  PlayObject.m_UseItems[U_RINGL] := HumItems[U_RINGL];
  PlayObject.m_UseItems[U_RINGR] := HumItems[U_RINGR];

  HumAddItems := @HumanRcd.Data.HumAddItems;
  PlayObject.m_UseItems[U_BUJUK] := HumAddItems[U_BUJUK];
  PlayObject.m_UseItems[U_BELT] := HumAddItems[U_BELT];
  PlayObject.m_UseItems[U_BOOTS] := HumAddItems[U_BOOTS];
  PlayObject.m_UseItems[U_CHARM] := HumAddItems[U_CHARM];

  BagItems := @HumanRcd.Data.BagItems;
  for i := Low(TBagItems) to High(TBagItems) do begin
    if BagItems[i].wIndex > 0 then begin
      New(UserItem);
      UserItem^ := BagItems[i];
      PlayObject.m_ItemList.Add(UserItem);
    end;
  end;
  HumMagics := @HumanRcd.Data.HumMagics;
  for i := Low(THumMagics) to High(THumMagics) do begin
    MagicInfo := UserEngine.FindMagic(HumMagics[i].wMagIdx);
    if MagicInfo <> nil then begin
      New(UserMagic);
      UserMagic.MagicInfo := MagicInfo;
      UserMagic.wMagIdx := HumMagics[i].wMagIdx;
      UserMagic.btLevel := HumMagics[i].btLevel;
      UserMagic.btKey := HumMagics[i].btKey;
      UserMagic.nTranPoint := HumMagics[i].nTranPoint;
      PlayObject.m_MagicList.Add(UserMagic);
    end;
  end;
  StorageItems := @HumanRcd.Data.StorageItems;
  for i := Low(TStorageItems) to High(TStorageItems) do begin
    if StorageItems[i].wIndex > 0 then begin
      New(UserItem);
      UserItem^ := StorageItems[i];
      PlayObject.m_StorageItemList.Add(UserItem);
    end;
  end;
end;

function TUserEngine.GetHomeInfo(var nX, nY: Integer): string;
var
  i: Integer;
  nXY: Integer;
begin
  g_StartPointList.Lock;
  try
    if g_StartPointList.Count > 0 then begin
      if g_StartPointList.Count > g_Config.nStartPointSize {1} then i := Random(g_Config.nStartPointSize {2})
      else i := 0;
      Result := GetStartPointInfo(i, nX, nY); //g_StartPointList.Strings[i];
    end else begin
      Result := g_Config.sHomeMap;
      nX := g_Config.nHomeX;
      nX := g_Config.nHomeY;
    end;
  finally
    g_StartPointList.UnLock;
  end;
end;

function TUserEngine.GetRandHomeX(PlayObject: TPlayObject): Integer;
begin
  Result := Random(3) + (PlayObject.m_nHomeX - 2);
end;

function TUserEngine.GetRandHomeY(PlayObject: TPlayObject): Integer;
begin
  Result := Random(3) + (PlayObject.m_nHomeY - 2);
end;

procedure TUserEngine.LoadSwitchData(SwitchData: pTSwitchDataInfo; var
  PlayObject: TPlayObject);
var
  nCount: Integer;
  SlaveInfo: pTSlaveInfo;
begin
  if SwitchData.boC70 then begin

  end;
  PlayObject.m_boBanShout := SwitchData.boBanShout;
  PlayObject.m_boHearWhisper := SwitchData.boHearWhisper;
  PlayObject.m_boBanGuildChat := SwitchData.boBanGuildChat;
  PlayObject.m_boBanGuildChat := SwitchData.boBanGuildChat;
  PlayObject.m_boAdminMode := SwitchData.boAdminMode;
  PlayObject.m_boObMode := SwitchData.boObMode;
  nCount := 0;
  while (True) do begin
    if SwitchData.BlockWhisperArr[nCount] = '' then break;
    PlayObject.m_BlockWhisperList.Add(SwitchData.BlockWhisperArr[nCount]);
    Inc(nCount);
    if nCount >= High(SwitchData.BlockWhisperArr) then break;
  end;
  nCount := 0;
  while (True) do begin
    if SwitchData.SlaveArr[nCount].sSalveName = '' then break;
    New(SlaveInfo);
    SlaveInfo^ := SwitchData.SlaveArr[nCount];
    PlayObject.SendDelayMsg(PlayObject, RM_10401, 0, Integer(SlaveInfo), 0, 0, '', 500);
    Inc(nCount);
    if nCount >= 5 then break;
  end;

  nCount := 0;
  PlayObject.m_boDC := True;
  PlayObject.m_boMC := True;
  PlayObject.m_boSC := True;
  PlayObject.m_boHitSpeed := True;
  PlayObject.m_boMaxHP := True;
  PlayObject.m_boMaxMP := True;
  while (True) do begin
    PlayObject.m_wStatusArrValue[nCount] := SwitchData.StatusValue[nCount];
    PlayObject.m_dwStatusArrTimeOutTick[nCount] := SwitchData.StatusTimeOut[nCount];
    Inc(nCount);
    if nCount >= 6 then break;
  end;
end;

procedure TUserEngine.DelSwitchData(SwitchData: pTSwitchDataInfo);
var
  i: Integer;
  SwitchDataInfo: pTSwitchDataInfo;
begin
  i := 0;
  while True do begin //for i := 0 to m_ChangeServerList.Count - 1 do begin
    if i >= m_ChangeServerList.Count then break;
    if m_ChangeServerList.Count <= 0 then break;
    SwitchDataInfo := m_ChangeServerList.Items[i];
    if (SwitchDataInfo <> nil) and (SwitchDataInfo = SwitchData) then begin
      DisPose(SwitchDataInfo);
      m_ChangeServerList.Delete(i);
      break;
    end;
    Inc(i);
  end; // for
end;

function TUserEngine.FindMagic(nMagIdx: Integer): pTMagic;
var
  i: Integer;
  Magic: pTMagic;
  MagicList: TList;
begin
  Result := nil;
  if (m_boStartLoadMagic) and (OldMagicList.Count > 0) then begin
    MagicList := TList(OldMagicList.Items[OldMagicList.Count - 1]);
    if MagicList <> nil then begin
      for i := 0 to MagicList.Count - 1 do begin
        Magic := MagicList.Items[i];
        if Magic <> nil then begin
          if Magic.wMagicId = nMagIdx then begin
            Result := Magic;
            break;
          end;
        end;
      end;
    end;
  end else begin
    for i := 0 to m_MagicList.Count - 1 do begin
      Magic := m_MagicList.Items[i];
      if Magic <> nil then begin
        if Magic.wMagicId = nMagIdx then begin
          Result := Magic;
          break;
        end;
      end;
    end;
  end;
end;

procedure TUserEngine.MonInitialize(BaseObject: TBaseObject; sMonName: string);
var
  i: Integer;
  Monster: pTMonInfo;
begin
  for i := 0 to MonsterList.Count - 1 do begin
    Monster := MonsterList.Items[i];
    if Monster <> nil then begin
      if (CompareText(Monster.sName, sMonName) = 0) and (BaseObject <> nil) then begin
        BaseObject.m_btRaceServer := Monster.btRace;
        BaseObject.m_btRaceImg := Monster.btRaceImg;
        BaseObject.m_wAppr := Monster.wAppr;
        BaseObject.m_Abil.Level := Monster.wLevel;
        BaseObject.m_btLifeAttrib := Monster.btLifeAttrib;
        BaseObject.m_btCoolEye := Monster.wCoolEye;
        BaseObject.m_dwFightExp := Monster.dwExp;
        BaseObject.m_Abil.HP := Monster.wHP;
        BaseObject.m_Abil.MaxHP := Monster.wHP;
        BaseObject.m_btMonsterWeapon := LoByte(Monster.wMP);
        //BaseObject.m_Abil.MP:=Monster.wMP;
        BaseObject.m_Abil.MP := 0;
        BaseObject.m_Abil.MaxMP := Monster.wMP;
        BaseObject.m_Abil.AC := MakeLong(Monster.wAC, Monster.wAC);
        BaseObject.m_Abil.MAC := MakeLong(Monster.wMAC, Monster.wMAC);
        BaseObject.m_Abil.DC := MakeLong(Monster.wDC, Monster.wMaxDC);
        BaseObject.m_Abil.MC := MakeLong(Monster.wMC, Monster.wMC);
        BaseObject.m_Abil.SC := MakeLong(Monster.wSC, Monster.wSC);
        BaseObject.m_btSpeedPoint := Monster.wSpeed;
        BaseObject.m_btHitPoint := Monster.wHitPoint;
        BaseObject.m_nWalkSpeed := Monster.wWalkSpeed;
        BaseObject.m_nWalkStep := Monster.wWalkStep;
        BaseObject.m_dwWalkWait := Monster.wWalkWait;
        BaseObject.m_nNextHitTime := Monster.wAttackSpeed;
        break;
      end;
    end;
  end;
end;

function TUserEngine.OpenDoor(Envir: TEnvirnoment; nX,
  nY: Integer): Boolean;
var
  Door: pTDoorInfo;
begin
  Result := False;
  Door := Envir.GetDoor(nX, nY);
  if (Door <> nil) and not Door.Status.boOpened and not Door.Status.bo01 then begin
    Door.Status.boOpened := True;
    Door.Status.dwOpenTick := GetTickCount();
    SendDoorStatus(Envir, nX, nY, RM_DOOROPEN, 0, nX, nY, 0, '');
    Result := True;
  end;
end;

function TUserEngine.CloseDoor(Envir: TEnvirnoment; Door: pTDoorInfo): Boolean;
begin
  Result := False;
  if (Door <> nil) and (Door.Status.boOpened) then begin
    Door.Status.boOpened := False;
    SendDoorStatus(Envir, Door.nX, Door.nY, RM_DOORCLOSE, 0, Door.nX, Door.nY, 0, '');
    Result := True;
  end;
end;

procedure TUserEngine.SendDoorStatus(Envir: TEnvirnoment; nX, nY: Integer;
  wIdent, wX: Word; nDoorX, nDoorY, nA: Integer; sStr: string);
var
  i: Integer;
  n10, n14: Integer;
  n1C, n20, n24, n28: Integer;
  MapCellInfo: pTMapCellinfo;
  OSObject: pTOSObject;
  BaseObject: TBaseObject;
begin
  n1C := nX - 12;
  n24 := nX + 12;
  n20 := nY - 12;
  n28 := nY + 12;
  if Envir <> nil then begin
    for n10 := n1C to n24 do begin
      for n14 := n20 to n28 do begin
        if Envir.GetMapCellInfo(n10, n14, MapCellInfo) and (MapCellInfo.ObjList <> nil) then begin
          for i := 0 to MapCellInfo.ObjList.Count - 1 do begin
            OSObject := pTOSObject(MapCellInfo.ObjList.Items[i]);
            if (OSObject <> nil) and (OSObject.btType = OS_MOVINGOBJECT) then begin
              BaseObject := TBaseObject(OSObject.CellObj);
              if (BaseObject <> nil) and
                (not BaseObject.m_boGhost) and
                (BaseObject.m_btRaceServer = RC_PLAYOBJECT) then begin
                BaseObject.SendMsg(BaseObject, wIdent, wX, nDoorX, nDoorY, nA, sStr);
              end;
            end;
          end;
        end;
      end;
    end;
  end;
end;

procedure TUserEngine.ProcessMapDoor;
var
  i: Integer;
  ii: Integer;
  Envir: TEnvirnoment;
  Door: pTDoorInfo;
begin
  for i := 0 to g_MapManager.Count - 1 do begin
    Envir := TEnvirnoment(g_MapManager.Items[i]);
    if Envir <> nil then begin
      for ii := 0 to Envir.m_DoorList.Count - 1 do begin
        Door := Envir.m_DoorList.Items[ii];
        if Door <> nil then begin
          if Door.Status.boOpened then begin
            if (GetTickCount - Door.Status.dwOpenTick) > 5 * 1000 then
              CloseDoor(Envir, Door);
          end;
        end;
      end;
    end;
  end;
end;

procedure TUserEngine.ProcessEvents;
var
  i, ii, III: Integer;
  MagicEvent: pTMagicEvent;
  BaseObject: TBaseObject;
begin
  for i := m_MagicEventList.Count - 1 downto 0 do begin
    if m_MagicEventList.Count <= 0 then break;
    MagicEvent := m_MagicEventList.Items[i];
    if (MagicEvent <> nil) and (MagicEvent.BaseObjectList <> nil) then begin
      for ii := MagicEvent.BaseObjectList.Count - 1 downto 0 do begin
        BaseObject := TBaseObject(MagicEvent.BaseObjectList.Items[ii]);
        if BaseObject <> nil then begin
          if BaseObject.m_boDeath or (BaseObject.m_boGhost) or (not BaseObject.m_boHolySeize) then begin
            MagicEvent.BaseObjectList.Delete(ii);
          end;
        end;
      end;
      if (MagicEvent.BaseObjectList.Count <= 0) or
        ((GetTickCount - MagicEvent.dwStartTick) > MagicEvent.dwTime) or
        ((GetTickCount - MagicEvent.dwStartTick) > 180000) then begin
        MagicEvent.BaseObjectList.Free;
        III := 0;
        while (True) do begin
          if MagicEvent.Events[III] <> nil then begin
            TEvent(MagicEvent.Events[III]).Close();
          end;
          Inc(III);
          if III >= 8 then break;
        end;
        DisPose(MagicEvent);
        m_MagicEventList.Delete(i);
      end;
    end;
  end;
end;

procedure TUserEngine.Process4AECFC;
begin

end;

function TUserEngine.AddMagic(Magic: pTMagic): Boolean;
var
  UserMagic: pTMagic;
begin
  Result := False;
  New(UserMagic);
  UserMagic.wMagicId := Magic.wMagicId;
  UserMagic.sMagicName := Magic.sMagicName;
  UserMagic.btEffectType := Magic.btEffectType;
  UserMagic.btEffect := Magic.btEffect;
  //UserMagic.bt11 := Magic.bt11;
  UserMagic.wSpell := Magic.wSpell;
  UserMagic.wPower := Magic.wPower;
  UserMagic.TrainLevel := Magic.TrainLevel;
  //UserMagic.w02 := Magic.w02;
  UserMagic.MaxTrain := Magic.MaxTrain;
  UserMagic.btTrainLv := Magic.btTrainLv;
  UserMagic.btJob := Magic.btJob;
  //UserMagic.wMagicIdx := Magic.wMagicIdx;
  UserMagic.dwDelayTime := Magic.dwDelayTime;
  UserMagic.btDefSpell := Magic.btDefSpell;
  UserMagic.btDefPower := Magic.btDefPower;
  UserMagic.wMaxPower := Magic.wMaxPower;
  UserMagic.btDefMaxPower := Magic.btDefMaxPower;
  UserMagic.sDescr := Magic.sDescr;
  m_MagicList.Add(UserMagic);
  Result := True;
end;

function TUserEngine.DelMagic(wMagicId: Word): Boolean;
var
  i: Integer;
  Magic: pTMagic;
begin
  Result := False;
  for i := m_MagicList.Count - 1 downto 0 do begin
    if m_MagicList.Count <= 0 then break;
    Magic := pTMagic(m_MagicList.Items[i]);
    if Magic <> nil then begin
      if Magic.wMagicId = wMagicId then begin
        DisPose(Magic);
        m_MagicList.Delete(i);
        Result := True;
        break;
      end;
    end;
  end;
end;

function TUserEngine.FindMagic(sMagicName: string): pTMagic;
var
  i: Integer;
  Magic: pTMagic;
  MagicList: TList;
begin
  Result := nil;
  if (m_boStartLoadMagic) and (OldMagicList.Count > 0) then begin
    MagicList := TList(OldMagicList.Items[OldMagicList.Count - 1]);
    if MagicList <> nil then begin
      for i := 0 to MagicList.Count - 1 do begin
        Magic := MagicList.Items[i];
        if Magic <> nil then begin
          if CompareText(Magic.sMagicName, sMagicName) = 0 then begin
            Result := Magic;
            break;
          end;
        end;
      end;
    end;
  end else begin
    for i := 0 to m_MagicList.Count - 1 do begin
      Magic := m_MagicList.Items[i];
      if Magic <> nil then begin
        if CompareText(Magic.sMagicName, sMagicName) = 0 then begin
          Result := Magic;
          break;
        end;
      end;
    end;
  end;
end;

function TUserEngine.GetMapRangeMonster(Envir: TEnvirnoment; nX, nY, nRange: Integer; List: TList): Integer;
var
  i, ii: Integer;
  MonGen: pTMonGenInfo;
  BaseObject: TBaseObject;
begin
  Result := 0;
  if Envir = nil then Exit;
  for i := 0 to m_MonGenList.Count - 1 do begin
    MonGen := m_MonGenList.Items[i];
    if (MonGen = nil) then Continue;
    if (MonGen.Envir <> nil) and (MonGen.Envir <> Envir) then Continue;

    for ii := 0 to MonGen.CertList.Count - 1 do begin
      BaseObject := TBaseObject(MonGen.CertList.Items[ii]);
      if BaseObject <> nil then begin
        if not BaseObject.m_boDeath and not BaseObject.m_boGhost and (BaseObject.m_PEnvir = Envir) and (abs(BaseObject.m_nCurrX - nX) <= nRange) and (abs(BaseObject.m_nCurrY - nY) <= nRange) then begin
          if List <> nil then List.Add(BaseObject);
          Inc(Result);
        end;
      end;
    end;
  end;
end;

procedure TUserEngine.AddMerchant(Merchant: TMerchant);
begin
  UserEngine.m_MerchantList.Lock;
  try
    UserEngine.m_MerchantList.Add(Merchant);
  finally
    UserEngine.m_MerchantList.UnLock;
  end;
end;

function TUserEngine.GetMerchantList(Envir: TEnvirnoment; nX, nY,
  nRange: Integer; TmpList: TList): Integer;
var
  i: Integer;
  Merchant: TMerchant;
begin
  m_MerchantList.Lock;
  try
    for i := 0 to m_MerchantList.Count - 1 do begin
      Merchant := TMerchant(m_MerchantList.Items[i]);
      if Merchant <> nil then begin
        if (Merchant.m_PEnvir = Envir) and
          (abs(Merchant.m_nCurrX - nX) <= nRange) and
          (abs(Merchant.m_nCurrY - nY) <= nRange) then begin
          TmpList.Add(Merchant);
        end;
      end;
    end; // for
  finally
    m_MerchantList.UnLock;
  end;
  Result := TmpList.Count
end;

function TUserEngine.GetNpcList(Envir: TEnvirnoment; nX, nY,
  nRange: Integer; TmpList: TList): Integer;
var
  i: Integer;
  NPC: TNormNpc;
begin
  for i := 0 to QuestNPCList.Count - 1 do begin
    NPC := TNormNpc(QuestNPCList.Items[i]);
    if NPC <> nil then begin
      if (NPC.m_PEnvir = Envir) and
        (abs(NPC.m_nCurrX - nX) <= nRange) and
        (abs(NPC.m_nCurrY - nY) <= nRange) then begin
        TmpList.Add(NPC);
      end;
    end;
  end; // for
  Result := TmpList.Count
end;

procedure TUserEngine.ReloadMerchantList();
var
  i: Integer;
  Merchant: TMerchant;
begin
  m_MerchantList.Lock;
  try
    for i := 0 to m_MerchantList.Count - 1 do begin
      Merchant := TMerchant(m_MerchantList.Items[i]);
      if Merchant <> nil then begin
        if not Merchant.m_boGhost then begin
          Merchant.ClearScript;
          Merchant.LoadNpcScript;
        end;
      end;
    end; // for
  finally
    m_MerchantList.UnLock;
  end;
end;

procedure TUserEngine.ReloadNpcList();
var
  i: Integer;
  NPC: TNormNpc;
begin
  for i := 0 to QuestNPCList.Count - 1 do begin
    NPC := TNormNpc(QuestNPCList.Items[i]);
    if NPC <> nil then begin
      NPC.ClearScript;
      NPC.LoadNpcScript;
    end;
  end;
end;

function TUserEngine.GetMapMonster(Envir: TEnvirnoment; List: TList): Integer;
var
  i, ii: Integer;
  MonGen: pTMonGenInfo;
  BaseObject: TBaseObject;
begin
  Result := 0;
  if Envir = nil then Exit;
  for i := 0 to m_MonGenList.Count - 1 do begin
    MonGen := m_MonGenList.Items[i];
    if MonGen = nil then Continue;
    for ii := 0 to MonGen.CertList.Count - 1 do begin
      BaseObject := TBaseObject(MonGen.CertList.Items[ii]);
      if BaseObject <> nil then begin
        if not BaseObject.m_boDeath and not BaseObject.m_boGhost and (BaseObject.m_PEnvir = Envir) then begin
          if List <> nil then List.Add(BaseObject);
          Inc(Result);
        end;
      end;
    end;
  end;
end;

procedure TUserEngine.HumanExpire(sAccount: string);
var
  i: Integer;
  PlayObject: TPlayObject;
begin
  if not g_Config.boKickExpireHuman then Exit;
  for i := 0 to m_PlayObjectList.Count - 1 do begin
    PlayObject := TPlayObject(m_PlayObjectList.Objects[i]);
    if PlayObject <> nil then begin
      if CompareText(PlayObject.m_sUserID, sAccount) = 0 then begin
        PlayObject.m_boExpire := True;
        break;
      end;
    end;
  end;
end;

function TUserEngine.GetMapHuman(sMapName: string): Integer;
var
  i: Integer;
  Envir: TEnvirnoment;
  PlayObject: TPlayObject;
begin
  Result := 0;
  Envir := g_MapManager.FindMap(sMapName);
  if Envir = nil then Exit;
  for i := 0 to m_PlayObjectList.Count - 1 do begin
    PlayObject := TPlayObject(m_PlayObjectList.Objects[i]);
    if PlayObject <> nil then begin
      if not PlayObject.m_boDeath and not PlayObject.m_boGhost and
        (PlayObject.m_PEnvir = Envir) then
        Inc(Result);
    end;
  end;
end;

function TUserEngine.GetMapRageHuman(Envir: TEnvirnoment; nRageX,
  nRageY, nRage: Integer; List: TList): Integer;
var
  i: Integer;
  PlayObject: TPlayObject;
begin
  Result := 0;
  for i := 0 to m_PlayObjectList.Count - 1 do begin
    PlayObject := TPlayObject(m_PlayObjectList.Objects[i]);
    if PlayObject <> nil then begin
      if not PlayObject.m_boDeath and
        not PlayObject.m_boGhost and
        (PlayObject.m_PEnvir = Envir) and
        (abs(PlayObject.m_nCurrX - nRageX) <= nRage) and
        (abs(PlayObject.m_nCurrY - nRageY) <= nRage) then begin
        List.Add(PlayObject);
        Inc(Result);
      end;
    end;
  end;
end;

function TUserEngine.GetStdItemIdx(sItemName: string): Integer;
var
  i: Integer;
  StdItem: pTStdItem;
begin
  Result := -1;
  if sItemName = '' then Exit;
  for i := 0 to StdItemList.Count - 1 do begin
    StdItem := StdItemList.Items[i];
    if StdItem <> nil then begin
      if CompareText(StdItem.Name, sItemName) = 0 then begin
        Result := i + 1;
        break;
      end;
    end;
  end;
end;
//==========================================
//向每个人物发送消息
//线程安全
//==========================================
procedure TUserEngine.SendBroadCastMsgExt(sMsg: string; MsgType: TMsgType);
var
  i: Integer;
  PlayObject: TPlayObject;
begin
  try
    EnterCriticalSection(ProcessHumanCriticalSection);
    for i := 0 to m_PlayObjectList.Count - 1 do begin
      PlayObject := TPlayObject(m_PlayObjectList.Objects[i]);
      if PlayObject <> nil then begin
        if not PlayObject.m_boGhost then
          PlayObject.SysMsg(sMsg, c_Red, MsgType);
      end;
    end;
  finally
    LeaveCriticalSection(ProcessHumanCriticalSection);
  end;
end;

procedure TUserEngine.SendBroadCastMsg(sMsg: string; MsgType: TMsgType);
var
  i: Integer;
  PlayObject: TPlayObject;
begin
  for i := 0 to m_PlayObjectList.Count - 1 do begin
    PlayObject := TPlayObject(m_PlayObjectList.Objects[i]);
    if PlayObject <> nil then begin
      if not PlayObject.m_boGhost then
        PlayObject.SysMsg(sMsg, c_Red, MsgType);
    end;
  end;
end;

procedure TUserEngine.Execute;
begin
  Run;
end;

procedure TUserEngine.sub_4AE514(GoldChangeInfo: pTGoldChangeInfo);
var
  GoldChange: pTGoldChangeInfo;
begin
  New(GoldChange);
  GoldChange^ := GoldChangeInfo^;
  EnterCriticalSection(m_LoadPlaySection);
  try
    m_ChangeHumanDBGoldList.Add(GoldChange);
  finally
    LeaveCriticalSection(m_LoadPlaySection);
  end;
end;

procedure TUserEngine.ClearMonSayMsg;
var
  i, ii: Integer;
  MonGen: pTMonGenInfo;
  MonBaseObject: TBaseObject;
begin
  for i := 0 to m_MonGenList.Count - 1 do begin
    MonGen := m_MonGenList.Items[i];
    if (MonGen <> nil) and (MonGen.CertList <> nil) then begin
      for ii := 0 to MonGen.CertList.Count - 1 do begin
        MonBaseObject := TBaseObject(MonGen.CertList.Items[ii]);
        if MonBaseObject <> nil then
          MonBaseObject.m_SayMsgList := nil;
      end;
    end;
  end;
end;

procedure TUserEngine.PrcocessData;
var
  dwUsrTimeTick: LongWord;
  sMsg: string;
resourcestring
  sExceptionMsg = '[Exception] TUserEngine::ProcessData';
begin
  try
    dwUsrTimeTick := GetTickCount();

    ProcessHumans();
    if g_Config.boSendOnlineCount and (GetTickCount - g_dwSendOnlineTick > g_Config.dwSendOnlineTime) then begin
      g_dwSendOnlineTick := GetTickCount();
      sMsg := AnsiReplaceText(g_sSendOnlineCountMsg, '%c', IntToStr(ROUND(GetOnlineHumCount * (g_Config.nSendOnlineCountRate / 10))));
      SendBroadCastMsg(sMsg, t_System)
    end;

    ProcessMonsters();

    ProcessMerchants();

    ProcessNpcs();

    if (GetTickCount() - dwProcessMissionsTime) > 1000 then begin
      dwProcessMissionsTime := GetTickCount();
      ProcessMissions();
      Process4AECFC();
      ProcessEvents();
    end;

    if (GetTickCount() - dwProcessMapDoorTick) > 500 then begin
      dwProcessMapDoorTick := GetTickCount();
      ProcessMapDoor();
    end;

    g_nUsrTimeMin := GetTickCount() - dwUsrTimeTick;
    if g_nUsrTimeMax < g_nUsrTimeMin then g_nUsrTimeMax := g_nUsrTimeMin;

    {if GetTickCount() - dwSaveDataTick > 1000 * 5 then begin
      dwSaveDataTick := GetTickCount();
      g_SellOffGoodList.SaveSellOffGoodList();
      g_SellOffGoldList.SaveSellOffGoldList();
      g_BigStorageList.SaveStorageList();
    end;}
  except
    MainOutMessage(sExceptionMsg);
  end;
end;

function TUserEngine.MapRageHuman(sMapName: string; nMapX, nMapY,
  nRage: Integer): Boolean;
var
  nX, nY: Integer;
  Envir: TEnvirnoment;
begin
  Result := False;
  Envir := g_MapManager.FindMap(sMapName);
  if Envir <> nil then begin
    for nX := nMapX - nRage to nMapX + nRage do begin
      for nY := nMapY - nRage to nMapY + nRage do begin
        if Envir.GetXYHuman(nMapX, nMapY) then begin
          Result := True;
          Exit;
        end;
      end;
    end;
  end;
end;

procedure TUserEngine.SendQuestMsg(sQuestName: string);
var
  i: Integer;
  PlayObject: TPlayObject;
begin
  for i := 0 to m_PlayObjectList.Count - 1 do begin
    PlayObject := TPlayObject(m_PlayObjectList.Objects[i]);
    if PlayObject <> nil then begin
      if not PlayObject.m_boDeath and not PlayObject.m_boGhost then
        g_ManageNPC.GotoLable(PlayObject, sQuestName, False);
    end;
  end;
end;

procedure TUserEngine.ClearItemList();
var
  i: Integer;
begin
  i := 0;
  while (True) do begin
    StdItemList.Exchange(Random(StdItemList.Count), StdItemList.Count - 1);
    Inc(i);
    if i >= StdItemList.Count then break;
  end;
  ClearMerchantData();
end;

procedure TUserEngine.SwitchMagicList();
var
  i: Integer;
  MagicList: TList;
begin
  if m_MagicList.Count > 0 then begin
    OldMagicList.Add(m_MagicList);
    m_MagicList := TList.Create;
  end;
  m_boStartLoadMagic := True;
end;

procedure TUserEngine.ClearMerchantData();
var
  i: Integer;
  Merchant: TMerchant;
begin
  m_MerchantList.Lock;
  try
    for i := 0 to m_MerchantList.Count - 1 do begin
      Merchant := TMerchant(m_MerchantList.Items[i]);
      if Merchant <> nil then
        Merchant.ClearData();
    end;
  finally
    m_MerchantList.UnLock;
  end;
end;

end.


{
    引擎输出函数  2006- 8-18 叶随风飘


}

unit PlugOfEngine;

interface
uses
  Windows, Classes, SysUtils, Forms, Grobal2, SDK, ObjBase, Envir, Guild, ObjNpc,
  Castle, UsrEngn, Magic, LocalDB, EDcode, Common, PlugIn, RunSock;

type
  TShortString = packed record
    btLen: Byte;
    Strings: array[0..High(Byte) - 1] of Char;
  end;
  PTShortString = ^TShortString;
  _TBANKPWD = string[6];
  _LPTBANKPWD = ^_TBANKPWD;
  _TMAPNAME = string[MAPNAMELEN];
  _LPTMAPNAME = ^_TMAPNAME;
  _TACTORNAME = string[ACTORNAMELEN];
  _LPTACTORNAME = ^_TACTORNAME;
  _TPATHNAME = string[MAXPATHLEN];
  _LPTPATHNAME = ^_TPATHNAME;
  _TDIRNAME = string[DIRPATHLEN];
  _LPTDIRNAME = ^_TDIRNAME;

  TObjectAction = procedure(PlayObject: TObject); stdcall;
  TObjectActionEx = function(PlayObject: TObject): BOOL; stdcall;
  TObjectActionXY = procedure(AObject, BObject: TObject; nX, nY: Integer); stdcall;
  TObjectActionXYD = procedure(AObject, BObject: TObject; nX, nY: Integer; btDir: Byte); stdcall;
  TObjectActionXYDM = procedure(AObject, BObject: TObject; nX, nY: Integer; btDir: Byte; nMode: Integer); stdcall;
  TObjectActionXYDWS = procedure(AObject, BObject: TObject; wIdent: Word; nX, nY: Integer; btDir: Byte; pszMsg: PChar); stdcall;
  TObjectActionObject = procedure(AObject, BObject, CObject: TObject; nInt: Integer); stdcall;
  TObjectActionDetailGoods = procedure(Merchant: TObject; PlayObject: TObject; pszItemName: PChar; nInt: Integer); stdcall;
  TObjectActionUserSelect = procedure(Merchant: TMerchant; PlayObject: TPlayObject; pszLabel, pszData: PChar); stdcall;
  TObjectUserCmd = function(AObject: TObject; pszCmd, pszParam1, pszParam2, pszParam3, pszParam4, pszParam5, pszParam6, pszParam7: PChar): Boolean; stdcall;
  TPlaySendSocket = function(AObject: TObject; DefMsg: pTDefaultMessage; pszMsg: PChar): Boolean; stdcall;
  TObjectActionItem = function(AObject: TObject; pszItemName: PChar): Boolean; stdcall;
  TObjectClientMsg = function(PlayObject: TObject; DefMsg: pTDefaultMessage; Buff: PChar; NewBuff: PChar): Integer; stdcall;
  TObjectActionFeature = function(AObject, BObject: TObject): Integer; stdcall;
  TObjectActionSendGoods = procedure(AObject: TObject; nNpcRecog, nCount, nPostion: Integer; pszData: PChar); stdcall;
  TObjectActionCheckUserItem = function(nIdx: Integer; StdItem: pTStdItem): Boolean; stdcall;
  TObjectActionEnterMap = function(AObject: TObject; Envir: TObject; nX, nY: Integer): Boolean; stdcall;
  TObjectFilterMsg = procedure(PlayObject: TObject; pszSrcMsg: PChar; pszDestMsg: PChar; nDestLen: Integer); stdcall;
  TObjectUserRunMsg = procedure(PlayObject: TPlayObject; var UseItems: THumanUseItems; var WAbil: TAbility); stdcall;
  TEDCode = procedure(pszSource: PChar; pszDest: PChar; nSrcLen, nDestLen: Integer); stdcall;
  TDoSpell = function(MagicManager: TMagicManager; PlayObject: TPlayObject; UserMagic: pTUserMagic; nTargetX, nTargetY: Integer; TargeTBaseObject: TBaseObject; var boSpellFail, boSpellFire: Boolean): Boolean; stdcall;

  TScriptCmd = function(pszCmd: PChar): Integer; stdcall;

  TRunSocketObject_Open = procedure(GateIdx, nSocket: Integer; sIPaddr: PChar); stdcall;
  TRunSocketObject_Close = procedure(GateIdx, nSocket: Integer); stdcall;
  TRunSocketObject_Eeceive_OK = procedure(); stdcall;
  TRunSocketObject_Data = procedure(GateIdx, nSocket: Integer; MsgBuff: PChar); stdcall;

  TScriptAction = procedure(Npc: TObject;
    PlayObject: TObject;
    nCmdCode: Integer;
    pszParam1: PChar;
    nParam1: Integer;
    pszParam2: PChar;
    nParam2: Integer;
    pszParam3: PChar;
    nParam3: Integer;
    pszParam4: PChar;
    nParam4: Integer;
    pszParam5: PChar;
    nParam5: Integer;
    pszParam6: PChar;
    nParam6: Integer); stdcall;

  TScriptCondition = function(Npc: TObject;
    PlayObject: TObject;
    nCmdCode: Integer;
    pszParam1: PChar;
    nParam1: Integer;
    pszParam2: PChar;
    nParam2: Integer;
    pszParam3: PChar;
    nParam3: Integer;
    pszParam4: PChar;
    nParam4: Integer;
    pszParam5: PChar;
    nParam5: Integer;
    pszParam6: PChar;
    nParam6: Integer): Boolean; stdcall;

  TObjectOperateMessage = function(BaseObject: TObject;
    wIdent: Word;
    wParam: Word;
    nParam1: Integer;
    nParam2: Integer;
    nParam3: Integer;
    MsgObject: TObject;
    dwDeliveryTime: LongWord;
    pszMsg: PChar;
    var boReturn: Boolean): Boolean; stdcall;

  TPlugOfEngine = class(TObject)
    GetFeature: TObjectActionFeature;
    ObjectEnterAnotherMap: TObjectActionEnterMap;
    ObjectDie: TObjectActionEx;
    ChangeCurrMap: TObjectActionEx;
    ClientQueryBagItems: TObjectAction;
    ClientQueryUserState: TObjectActionXY;
    SendActionGood: TObjectAction;
    SendActionFail: TObjectAction;
    SendWalkMsg: TObjectActionXYD;
    SendHorseRunMsg: TObjectActionXYD;
    SendRunMsg: TObjectActionXYD;
    SendDeathMsg: TObjectActionXYDM;
    SendSkeletonMsg: TObjectActionXYD;
    SendAliveMsg: TObjectActionXYD;
    SendSpaceMoveMsg: TObjectActionXYDWS;
    SendChangeFaceMsg: TObjectActionObject;
    SendUseitemsMsg: TObjectAction;
    SendUseMagicMsg: TObjectAction;
    SendUserLevelUpMsg: TObjectAction;
    SendUserAbilieyMsg: TObjectAction;
    SendUserStruckMsg: TObjectActionObject;
    SendSocket: TPlaySendSocket;
    SendGoodsList: TObjectActionSendGoods;
    SendUserStatusMsg: TObjectActionXYDWS;
    CheckCanDropItem: TObjectActionItem;
    CheckCanDealItem: TObjectActionItem;
    CheckCanStorageItem: TObjectActionItem;
    CheckCanRepairItem: TObjectActionItem;
    CheckUserItems: TObjectActionCheckUserItem;
    PlayObjectRun: TObjectAction;
    PlayObjectFilterMsg: TObjectFilterMsg;
    MerchantClientGetDetailGoodsList: TObjectActionDetailGoods;
    UserEngineRun: TObjectAction;
    ObjectClientMsg: TObjectClientMsg;
    ObjectUserRunMsg: TObjectUserRunMsg;
    SetHookDoSpell: TDoSpell;
    PlayObjectUserLogin1: TObjectAction;
    PlayObjectUserLogin2: TObjectAction;
    PlayObjectUserLogin3: TObjectAction;
    PlayObjectUserLogin4: TObjectAction;

    RunSocketExecGateMsg_Open: TRunSocketObject_Open;
    RunSocketExecGateMsg_Close: TRunSocketObject_Close;
    RunSocketExecGateMsg_Eeceive_OK: TRunSocketObject_Eeceive_OK;
    RunSocketExecGateMsg_Data: TRunSocketObject_Data;

    PlayObjectCreate: TObjectAction;
    PlayObjectDestroy: TObjectAction;
    PlayObjectUserCmd: TObjectUserCmd;
    ObjectOperateMessage: TObjectOperateMessage;
    QuestActionScriptCmd: TScriptCmd;
    QuestConditionScriptCmd: TScriptCmd;
    ActionScriptProcess: TScriptAction;
    ConditionScriptProcess: TScriptCondition;
    PlayObjectUserSelect: TObjectActionUserSelect;

    PlayObjectCreateArray: array[0..MAXPULGCOUNT - 1] of TObjectAction;
    PlayObjectDestroyArray: array[0..MAXPULGCOUNT - 1] of TObjectAction;
    PlayObjectUserCmdArray: array[0..MAXPULGCOUNT - 1] of TObjectUserCmd;
    ObjectOperateMessageArray: array[0..MAXPULGCOUNT - 1] of TObjectOperateMessage;
    QuestActionScriptCmdArray: array[0..MAXPULGCOUNT - 1] of TScriptCmd;
    QuestConditionScriptCmdArray: array[0..MAXPULGCOUNT - 1] of TScriptCmd;
    ActionScriptProcessArray: array[0..MAXPULGCOUNT - 1] of TScriptAction;
    ConditionScriptProcessArray: array[0..MAXPULGCOUNT - 1] of TScriptCondition;
    PlayObjectUserSelectArray: array[0..MAXPULGCOUNT - 1] of TObjectActionUserSelect;
    UserEngineRunArray: array[0..MAXPULGCOUNT - 1] of TObjectAction;

    nPlayObjectCreate: Integer;
    nPlayObjectDestroy: Integer;
    nPlayObjectUserCmd: Integer;
    nObjectOperateMessage: Integer;
    nQuestActionScriptCmd: Integer;
    nQuestConditionScriptCmd: Integer;
    nActionScriptProcess: Integer;
    nConditionScriptProcess: Integer;
    nPlayObjectUserSelect: Integer;
    nUserEngineRun: Integer;
  private
  public
    constructor Create();
    destructor Destroy; override;
    procedure InitPlugOfEngine;
    function GetPlugByHandle(PlugHandle: THandle): Integer;
    procedure SetHookPlayObjectCreate(PlugHandle: THandle; ObjectAction: TObjectAction);
    procedure SetHookPlayObjectDestroy(PlugHandle: THandle; ObjectAction: TObjectAction);
    procedure SetHookPlayObjectUserCmd(PlugHandle: THandle; ObjectUserCmd: TObjectUserCmd);
    procedure SetHookObjectOperateMessage(PlugHandle: THandle; PlayObjectOperateMessage: TObjectOperateMessage);
    procedure SetHookQuestActionScriptCmd(PlugHandle: THandle; ScriptCmd: TScriptCmd);
    procedure SetHookQuestConditionScriptCmd(PlugHandle: THandle; ScriptCmd: TScriptCmd);
    procedure SetHookActionScriptProcess(PlugHandle: THandle; ScriptAction: TScriptAction);
    procedure SetHookConditionScriptProcess(PlugHandle: THandle; ScriptCondition: TScriptCondition);
    procedure SetHookPlayObjectUserSelect(PlugHandle: THandle; ObjectActionUserSelect: TObjectActionUserSelect);
    procedure SetHookUserEngineRun(PlugHandle: THandle; ObjectAction: TObjectAction);

    function GetHookPlayObjectCreate(PlugHandle: THandle): TObjectAction;
    function GetHookPlayObjectDestroy(PlugHandle: THandle): TObjectAction;
    function GetHookPlayObjectUserCmd(PlugHandle: THandle): TObjectUserCmd;
    function GetHookObjectOperateMessage(PlugHandle: THandle): TObjectOperateMessage;
    function GetHookQuestActionScriptCmd(PlugHandle: THandle): TScriptCmd;
    function GetHookQuestConditionScriptCmd(PlugHandle: THandle): TScriptCmd;
    function GetHookActionScriptProcess(PlugHandle: THandle): TScriptAction;
    function GetHookConditionScriptProcess(PlugHandle: THandle): TScriptCondition;
    function GetHookPlayObjectUserSelect(PlugHandle: THandle): TObjectActionUserSelect;
  end;
var
  zPlugOfEngine: TPlugOfEngine;

function TList_Create(): TList; stdcall;
procedure TList_Free(List: TList); stdcall;
function TList_Count(List: TList): Integer; stdcall;
function TList_Add(List: TList; Item: Pointer): Integer; stdcall;
procedure TList_Insert(List: TList; nIndex: Integer; Item: Pointer); stdcall;
function TList_Get(List: TList; nIndex: Integer): Pointer; stdcall;
procedure TList_Put(List: TList; nIndex: Integer; Item: Pointer); stdcall;
procedure TList_Delete(List: TList; nIndex: Integer); stdcall;
procedure TList_Clear(List: TList); stdcall;
procedure TList_Exchange(List: TList; nIndex1, nIndex2: Integer); stdcall;

function TStringList_Create(): TStringList; stdcall;
procedure TStringList_Free(List: TStringList); stdcall;
function TStringList_Count(List: TStringList): Integer; stdcall;
function TStringList_Add(List: TStringList; S: PChar): Integer; stdcall;
function TStringList_AddObject(List: TStringList; S: PChar; AObject: TObject): Integer; stdcall;
procedure TStringList_Insert(List: TStringList; nIndex: Integer; S: PChar); stdcall;
function TStringList_Get(List: TStringList; nIndex: Integer): PChar; stdcall;
function TStringList_GetObject(List: TStringList; nIndex: Integer): TObject; stdcall;
procedure TStringList_Put(List: TStringList; nIndex: Integer; S: PChar); stdcall;
procedure TStringList_PutObject(List: TStringList; nIndex: Integer; AObject: TObject); stdcall;
procedure TStringList_Delete(List: TStringList; nIndex: Integer); stdcall;
procedure TStringList_Clear(List: TStringList); stdcall;
procedure TStringList_Exchange(List: TStringList; nIndex1, nIndex2: Integer); stdcall;
procedure TStringList_LoadFormFile(List: TStringList; pszFileName: PChar); stdcall;
procedure TStringList_SaveToFile(List: TStringList; pszFileName: PChar); stdcall;
procedure MainOutMessageAPI(pszMsg: PChar); stdcall;
procedure AddGameDataLogAPI(pszMsg: PChar); stdcall;
function GetGameGoldName(): PTShortString; stdcall;
procedure EDcode_Decode6BitBuf(pszSource: PChar; pszDest: PChar; nSrcLen, nDestLen: Integer); stdcall;
procedure EDcode_Encode6BitBuf(pszSource: PChar; pszDest: PChar; nSrcLen, nDestLen: Integer); stdcall;
procedure EDcode_SetDecode(Decode: TEDCode); stdcall;
procedure EDcode_SetEncode(Encode: TEDCode); stdcall;
procedure EDcode_DeCodeString(pszSource: PChar; var pszDest: array of Char); stdcall;
procedure EDcode_EncodeString(pszSource: PChar; var pszDest: array of Char); stdcall;
procedure EDcode_EncodeBuffer(Buf: PChar; bufsize: Integer; var pszDest: array of Char); stdcall;
procedure EDcode_DecodeBuffer(pszSource: PChar; pszDest: PChar; bufsize: Integer); stdcall;

function TConfig_sEnvirDir(): _LPTDIRNAME; stdcall;
function TConfig_AmyOunsulPoint: PInteger; stdcall;

function TBaseObject_Create(): TBaseObject; stdcall;
procedure TBaseObject_Free(BaseObject: TBaseObject); stdcall;
function TBaseObject_sMapFileName(BaseObject: TBaseObject): PTShortString; stdcall;
function TBaseObject_sMapName(BaseObject: TBaseObject): PTShortString; stdcall;
function TBaseObject_sMapNameA(BaseObject: TBaseObject): _LPTMAPNAME; stdcall;
function TBaseObject_sCharName(BaseObject: TBaseObject): PTShortString; stdcall;
function TBaseObject_sCharNameA(BaseObject: TBaseObject): _LPTACTORNAME; stdcall;

function TBaseObject_nCurrX(BaseObject: TBaseObject): PInteger; stdcall;
function TBaseObject_nCurrY(BaseObject: TBaseObject): PInteger; stdcall;
function TBaseObject_btDirection(BaseObject: TBaseObject): PByte; stdcall;
function TBaseObject_btGender(BaseObject: TBaseObject): PByte; stdcall;
function TBaseObject_btHair(BaseObject: TBaseObject): PByte; stdcall;
function TBaseObject_btJob(BaseObject: TBaseObject): PByte; stdcall;
function TBaseObject_nGold(BaseObject: TBaseObject): PInteger; stdcall;
function TBaseObject_Ability(BaseObject: TBaseObject): PTABILITY; stdcall;

function TBaseObject_WAbility(BaseObject: TBaseObject): PTABILITY; stdcall;
function TBaseObject_nCharStatus(BaseObject: TBaseObject): PInteger; stdcall;
function TBaseObject_sHomeMap(BaseObject: TBaseObject): PTShortString; stdcall;
function TBaseObject_nHomeX(BaseObject: TBaseObject): PInteger; stdcall;
function TBaseObject_nHomeY(BaseObject: TBaseObject): PInteger; stdcall;
function TBaseObject_boOnHorse(BaseObject: TBaseObject): PBoolean; stdcall;
function TBaseObject_btHorseType(BaseObject: TBaseObject): PByte; stdcall;
function TBaseObject_btDressEffType(BaseObject: TBaseObject): PByte; stdcall;
function TBaseObject_nPkPoint(BaseObject: TBaseObject): PInteger; stdcall;
function TBaseObject_boAllowGroup(BaseObject: TBaseObject): PBoolean; stdcall;
function TBaseObject_boAllowGuild(BaseObject: TBaseObject): PBoolean; stdcall;
function TBaseObject_nFightZoneDieCount(BaseObject: TBaseObject): PInteger; stdcall;
function TBaseObject_nBonusPoint(BaseObject: TBaseObject): PInteger; stdcall;
function TBaseObject_nHungerStatus(BaseObject: TBaseObject): PInteger; stdcall;
function TBaseObject_boAllowGuildReCall(BaseObject: TBaseObject): PBoolean; stdcall;
function TBaseObject_duBodyLuck(BaseObject: TBaseObject): PDouble; stdcall;
function TBaseObject_nBodyLuckLevel(BaseObject: TBaseObject): PInteger; stdcall;
function TBaseObject_wGroupRcallTime(BaseObject: TBaseObject): PWord; stdcall;
function TBaseObject_boAllowGroupReCall(BaseObject: TBaseObject): PBoolean; stdcall;
function TBaseObject_nCharStatusEx(BaseObject: TBaseObject): PInteger; stdcall;
function TBaseObject_dwFightExp(BaseObject: TBaseObject): PLongWord; stdcall;
function TBaseObject_nViewRange(BaseObject: TBaseObject): PInteger; stdcall;
function TBaseObject_wAppr(BaseObject: TBaseObject): PWord; stdcall;
function TBaseObject_btRaceServer(BaseObject: TBaseObject): PByte; stdcall;
function TBaseObject_btRaceImg(BaseObject: TBaseObject): PByte; stdcall;
function TBaseObject_btHitPoint(BaseObject: TBaseObject): PByte; stdcall;
function TBaseObject_nHitPlus(BaseObject: TBaseObject): PShortInt; stdcall;
function TBaseObject_nHitDouble(BaseObject: TBaseObject): PShortInt; stdcall;
function TBaseObject_boRecallSuite(BaseObject: TBaseObject): PBoolean; stdcall;
function TBaseObject_nHealthRecover(BaseObject: TBaseObject): PShortInt; stdcall;
function TBaseObject_nSpellRecover(BaseObject: TBaseObject): PShortInt; stdcall;
function TBaseObject_btAntiPoison(BaseObject: TBaseObject): PByte; stdcall;
function TBaseObject_nPoisonRecover(BaseObject: TBaseObject): PShortInt; stdcall;
function TBaseObject_nAntiMagic(BaseObject: TBaseObject): PShortInt; stdcall;
function TBaseObject_nLuck(BaseObject: TBaseObject): PInteger; stdcall;
function TBaseObject_nPerHealth(BaseObject: TBaseObject): PInteger; stdcall;
function TBaseObject_nPerHealing(BaseObject: TBaseObject): PInteger; stdcall;
function TBaseObject_nPerSpell(BaseObject: TBaseObject): PInteger; stdcall;
function TBaseObject_btGreenPoisoningPoint(BaseObject: TBaseObject): PByte; stdcall;
function TBaseObject_nGoldMax(BaseObject: TBaseObject): PInteger; stdcall;
function TBaseObject_btSpeedPoint(BaseObject: TBaseObject): PByte; stdcall;
function TBaseObject_btPermission(BaseObject: TBaseObject): PByte; stdcall;
function TBaseObject_nHitSpeed(BaseObject: TBaseObject): PShortInt; stdcall;
function TBaseObject_TargetCret(BaseObject: TBaseObject): PTBaseObject; stdcall;
function TBaseObject_LastHiter(BaseObject: TBaseObject): PTBaseObject; stdcall;
function TBaseObject_ExpHiter(BaseObject: TBaseObject): PTBaseObject; stdcall;
function TBaseObject_btLifeAttrib(BaseObject: TBaseObject): PByte; stdcall;
function TBaseObject_GroupOwner(BaseObject: TBaseObject): TBaseObject; stdcall;
function TBaseObject_GroupMembersList(BaseObject: TBaseObject): TStringList; stdcall;
function TBaseObject_boHearWhisper(BaseObject: TBaseObject): PBoolean; stdcall;
function TBaseObject_boBanShout(BaseObject: TBaseObject): PBoolean; stdcall;
function TBaseObject_boBanGuildChat(BaseObject: TBaseObject): PBoolean; stdcall;
function TBaseObject_boAllowDeal(BaseObject: TBaseObject): PBoolean; stdcall;
function TBaseObject_nSlaveType(BaseObject: TBaseObject): PInteger; stdcall;
function TBaseObject_Master(BaseObject: TBaseObject): PTBaseObject; stdcall;
function TBaseObject_btAttatckMode(BaseObject: TBaseObject): PByte; stdcall;
function TBaseObject_btNameColor(BaseObject: TBaseObject): PByte; stdcall;
function TBaseObject_nLight(BaseObject: TBaseObject): PInteger; stdcall;
function TBaseObject_ItemList(BaseObject: TBaseObject): TList; stdcall;
function TBaseObject_MagicList(BaseObject: TBaseObject): TList; stdcall;
function TBaseObject_MyGuild(BaseObject: TBaseObject): TGuild; stdcall;
function TBaseObject_UseItems(BaseObject: TBaseObject): PTPLAYUSEITEMS; stdcall;
function TBaseObject_btMonsterWeapon(BaseObject: TBaseObject): PByte; stdcall;
function TBaseObject_PEnvir(BaseObject: TBaseObject): PTEnvirnoment; stdcall;
function TBaseObject_boGhost(BaseObject: TBaseObject): PBoolean; stdcall;
function TBaseObject_boDeath(BaseObject: TBaseObject): PBoolean; stdcall;

function TBaseObject_DeleteBagItem(BaseObject: TBaseObject; UserItem: pTUserItem): BOOL; stdcall;

function TBaseObject_AddCustomData(BaseObject: TBaseObject; Data: Pointer): Integer; stdcall;
function TBaseObject_GetCustomData(BaseObject: TBaseObject; nIndex: Integer): Pointer; stdcall;

procedure TBaseObject_SendMsg(SelfObject, BaseObject: TBaseObject; wIdent, wParam: Word; nParam1, nParam2, nParam3: Integer; pszMsg: PChar); stdcall;
procedure TBaseObject_SendRefMsg(BaseObject: TBaseObject; wIdent, wParam: Word; nParam1, nParam2, nParam3: Integer; pszMsg: PChar); stdcall;
procedure TBaseObject_SendDelayMsg(SelfObject, BaseObject: TBaseObject; wIdent, wParam: Word; nParam1, nParam2, nParam3: Integer; pszMsg: PChar; dwDelayTime: LongWord); stdcall;

procedure TBaseObject_SysMsg(BaseObject: TBaseObject; pszMsg: PChar; MsgColor: TMsgColor; MsgType: TMsgType); stdcall;
function TBaseObject_GetFrontPosition(BaseObject: TBaseObject; var nX: Integer; var nY: Integer): Boolean; stdcall;
function TBaseObject_GetRecallXY(BaseObject: TBaseObject; nX, nY: Integer; nRange: Integer; var nDX: Integer; var nDY: Integer): Boolean; stdcall;
procedure TBaseObject_SpaceMove(BaseObject: TBaseObject; pszMap: PChar; nX, nY: Integer; nInt: Integer); stdcall;
procedure TBaseObject_FeatureChanged(BaseObject: TBaseObject); stdcall;
procedure TBaseObject_StatusChanged(BaseObject: TBaseObject); stdcall;
function TBaseObject_GetFeatureToLong(BaseObject: TBaseObject): Integer; stdcall;
function TBaseObject_GetFeature(SelfObject, BaseObject: TBaseObject): Integer; stdcall;
function TBaseObject_GetCharColor(SelfObject, BaseObject: TBaseObject): Byte; stdcall;
function TBaseObject_GetNamecolor(BaseObject: TBaseObject): Byte; stdcall;
procedure TBaseObject_GoldChanged(BaseObject: TBaseObject); stdcall;
procedure TBaseObject_GameGoldChanged(BaseObject: TBaseObject); stdcall;
function TBaseObject_MagCanHitTarget(BaseObject: TBaseObject; nX, nY: Integer; TargeTBaseObject: TBaseObject): Boolean; stdcall;

procedure TBaseObject_SetTargetCreat(AObject, BObject: TBaseObject); stdcall;
function TBaseObject_IsProtectTarget(AObject, BObject: TBaseObject): Boolean; stdcall;
function TBaseObject_IsAttackTarget(AObject, BObject: TBaseObject): Boolean; stdcall;
function TBaseObject_IsProperTarget(AObject, BObject: TBaseObject): Boolean; stdcall;
function TBaseObject_IsProperFriend(AObject, BObject: TBaseObject): Boolean; stdcall;
procedure TBaseObject_TrainSkillPoint(BaseObject: TBaseObject; UserMagic: pTUserMagic; nTranPoint: Integer); stdcall;
function TBaseObject_GetAttackPower(BaseObject: TBaseObject; nBasePower, nPower: Integer): Integer; stdcall;
function TBaseObject_MakeSlave(BaseObject: TBaseObject; pszMonName: PChar; nMakeLevel, nExpLevel, nMaxMob, nType: Integer; dwRoyaltySec: LongWord): TBaseObject; stdcall;
procedure TBaseObject_MakeGhost(BaseObject: TBaseObject); stdcall;
procedure TBaseObject_RefNameColor(BaseObject: TBaseObject); stdcall;
//AddItem 占用内存由自己处理，API内部会自动申请内存
function TBaseObject_AddItemToBag(BaseObject: TBaseObject; AddItem: pTUserItem): BOOL; stdcall;
function TBaseObject_AddItemToStorage(BaseObject: TBaseObject; AddItem: pTUserItem): BOOL; stdcall;
procedure TBaseObject_ClearBagItem(BaseObject: TBaseObject); stdcall;
procedure TBaseObject_ClearStorageItem(BaseObject: TBaseObject); stdcall;

procedure TBaseObject_SetHookGetFeature(ObjectActionFeature: TObjectActionFeature); stdcall;
procedure TBaseObject_SetHookEnterAnotherMap(EnterAnotherMap: TObjectActionEnterMap); stdcall;
procedure TBaseObject_SetHookObjectDie(ObjectDie: TObjectActionEx); stdcall;
procedure TBaseObject_SetHookChangeCurrMap(ChangeCurrMap: TObjectActionEx); stdcall;
function TBaseObject_GetPoseCreate(BaseObject: TBaseObject): TBaseObject; stdcall;
function TBaseObject_MagMakeDefenceArea(BaseObject: TBaseObject; nX, nY, nRange, nSec: Integer; btState: Byte; boState: Boolean): Integer; stdcall;
function TBaseObject_MagBubbleDefenceUp(BaseObject: TBaseObject; nLevel, nSec: Integer): Boolean; stdcall;

function TPlayObject_IsEnoughBag(PlayObject: TPlayObject): Boolean; stdcall;
function TPlayObject_nSoftVersionDate(PlayObject: TPlayObject): PInteger; stdcall;
function TPlayObject_nSoftVersionDateEx(PlayObject: TPlayObject): PInteger; stdcall;
function TPlayObject_dLogonTime(PlayObject: TPlayObject): PDateTime; stdcall;
function TPlayObject_dwLogonTick(PlayObject: TPlayObject): PLongWord; stdcall;
function TPlayObject_nMemberType(PlayObject: TPlayObject): PInteger; stdcall;
function TPlayObject_nMemberLevel(PlayObject: TPlayObject): PInteger; stdcall;
function TPlayObject_nGameGold(PlayObject: TPlayObject): PInteger; stdcall;
function TPlayObject_nGamePoint(PlayObject: TPlayObject): PInteger; stdcall;
function TPlayObject_nPayMentPoint(PlayObject: TPlayObject): PInteger; stdcall;
function TPlayObject_nClientFlag(PlayObject: TPlayObject): PInteger; stdcall;
function TPlayObject_nSelectID(PlayObject: TPlayObject): PInteger; stdcall;
function TPlayObject_nClientFlagMode(PlayObject: TPlayObject): PInteger; stdcall;
function TPlayObject_dwClientTick(PlayObject: TPlayObject): PLongWord; stdcall;
function TPlayObject_wClientType(PlayObject: TPlayObject): PWord; stdcall;
function TPlayObject_sBankPassword(PlayObject: TPlayObject): _LPTBANKPWD; stdcall;
function TPlayObject_nBankGold(PlayObject: TPlayObject): PInteger; stdcall;
function TPlayObject_Create(): TPlayObject; stdcall;
procedure TPlayObject_Free(PlayObject: TPlayObject); stdcall;
procedure TPlayObject_SendSocket(PlayObject: TPlayObject; DefMsg: pTDefaultMessage; pszMsg: PChar); stdcall;
procedure TPlayObject_SendDefMessage(PlayObject: TPlayObject; wIdent: Word; nRecog: Integer; nParam, nTag, nSeries: Word; pszMsg: PChar); stdcall;
procedure TPlayObject_SendAddItem(PlayObject: TPlayObject; AddItem: pTUserItem); stdcall;
procedure TPlayObject_SendDelItem(PlayObject: TPlayObject; AddItem: pTUserItem); stdcall;
function TPlayObject_TargetInNearXY(PlayObject: TPlayObject; Target: TBaseObject; nX, nY: Integer): Boolean; stdcall;
procedure TPlayObject_SetBankPassword(PlayObject: TPlayObject; pszPassword: PChar); stdcall;

function TPlayObject_GetPlayObjectTick(PlayObject: TPlayObject; nCount: Integer): PLongWord; stdcall;
procedure TPlayObject_SetPlayObjectTick(PlayObject: TPlayObject; nCount: Integer); stdcall;

procedure TPlayObject_SetHookCreate(PlugHandle: THandle; PlayObjectCreate: TObjectAction); stdcall;
function TPlayObject_GetHookCreate(): TObjectAction; stdcall;
procedure TPlayObject_SetHookDestroy(PlugHandle: THandle; PlayObjectDestroy: TObjectAction); stdcall;
function TPlayObject_GetHookDestroy(): TObjectAction; stdcall;
procedure TPlayObject_SetHookUserLogin1(PlayObjectUserLogin: TObjectAction); stdcall;
procedure TPlayObject_SetHookUserLogin2(PlayObjectUserLogin: TObjectAction); stdcall;
procedure TPlayObject_SetHookUserLogin3(PlayObjectUserLogin: TObjectAction); stdcall;
procedure TPlayObject_SetHookUserLogin4(PlayObjectUserLogin: TObjectAction); stdcall;

procedure TPlayObject_SetHookUserCmd(PlugHandle: THandle; PlayObjectUserCmd: TObjectUserCmd); stdcall;
function TPlayObject_GetHookUserCmd(): TObjectUserCmd; stdcall;

procedure TPlayObject_SetHookPlayOperateMessage(PlugHandle: THandle; PlayObjectOperateMessage: TObjectOperateMessage); stdcall;
function TPlayObject_GetHookPlayOperateMessage(): TObjectOperateMessage; stdcall;
procedure TPlayObject_SetHookClientQueryBagItems(ClientQueryBagItems: TObjectAction); stdcall;
procedure TPlayObject_SetHookClientQueryUserState(ClientQueryUserState: TObjectActionXY); stdcall;
procedure TPlayObject_SetHookSendActionGood(SendActionGood: TObjectAction); stdcall;
procedure TPlayObject_SetHookSendActionFail(SendActionFail: TObjectAction); stdcall;

procedure TPlayObject_SetHookSendWalkMsg(ObjectActioinXYD: TObjectActionXYD); stdcall;
procedure TPlayObject_SetHookSendHorseRunMsg(ObjectActioinXYD: TObjectActionXYD); stdcall;
procedure TPlayObject_SetHookSendRunMsg(ObjectActioinXYD: TObjectActionXYD); stdcall;
procedure TPlayObject_SetHookSendDeathMsg(ObjectActioinXYDM: TObjectActionXYDM); stdcall;
procedure TPlayObject_SetHookSendSkeletonMsg(ObjectActioinXYD: TObjectActionXYD); stdcall;
procedure TPlayObject_SetHookSendAliveMsg(ObjectActioinXYD: TObjectActionXYD); stdcall;
procedure TPlayObject_SetHookSendSpaceMoveMsg(ObjectActioinXYDWS: TObjectActionXYDWS); stdcall;
procedure TPlayObject_SetHookSendChangeFaceMsg(ObjectActioinObject: TObjectActionObject); stdcall;
procedure TPlayObject_SetHookSendUseitemsMsg(ObjectActioin: TObjectAction); stdcall;
procedure TPlayObject_SetHookSendUserLevelUpMsg(ObjectActioinObject: TObjectAction); stdcall;
procedure TPlayObject_SetHookSendUserAbilieyMsg(ObjectActioinObject: TObjectAction); stdcall;
procedure TPlayObject_SetHookSendUserStatusMsg(ObjectActioinXYDWS: TObjectActionXYDWS); stdcall;
procedure TPlayObject_SetHookSendUserStruckMsg(ObjectActioinObject: TObjectActionObject); stdcall;
procedure TPlayObject_SetHookSendUseMagicMsg(ObjectActioin: TObjectAction); stdcall;
procedure TPlayObject_SetHookSendSocket(SendSocket: TPlaySendSocket); stdcall;
procedure TPlayObject_SetHookSendGoodsList(SendGoodsList: TObjectActionSendGoods); stdcall;
procedure TPlayObject_SetCheckClientDropItem(ActionDropItem: TObjectActionItem); stdcall;
procedure TPlayObject_SetCheckClientDealItem(ActionItem: TObjectActionItem); stdcall;
procedure TPlayObject_SetCheckClientStorageItem(ActionItem: TObjectActionItem); stdcall;
procedure TPlayObject_SetCheckClientRepairItem(ActionItem: TObjectActionItem); stdcall;
procedure TPlayObject_SetHookCheckUserItems(ObjectActioin: TObjectActionCheckUserItem); stdcall;
procedure TPlayObject_SetHookRun(PlayRun: TObjectAction); stdcall;
procedure TPlayObject_SetHookFilterMsg(FilterMsg: TObjectFilterMsg); stdcall;
procedure TPlayObject_SetHookUserRunMsg(ObjectUserRunMsg: TObjectUserRunMsg); stdcall;

function TPlayObject_IncGold(PlayObject: TPlayObject; nAddGold: Integer): Boolean; stdcall;
procedure TPlayObject_IncGameGold(PlayObject: TPlayObject; nAddGameGold: Integer); stdcall;
procedure TPlayObject_IncGamePoint(PlayObject: TPlayObject; nAddGamePoint: Integer); stdcall;
function TPlayObject_DecGold(PlayObject: TPlayObject; nDecGold: Integer): Boolean; stdcall;
procedure TPlayObject_DecGameGold(PlayObject: TPlayObject; nDecGameGold: Integer); stdcall;
procedure TPlayObject_DecGamePoint(PlayObject: TPlayObject; nDecGamePoint: Integer); stdcall;
procedure TPlayObject_SetUserInPutInteger(PlayObject: TPlayObject; nData: Integer); stdcall;
procedure TPlayObject_SetUserInPutString(PlayObject: TPlayObject; pszData: PChar); stdcall;
function TPlayObject_PlayUseItems(PlayObject: TPlayObject): PTPLAYUSEITEMS; stdcall;


function TNormNpc_sFilePath(NormNpc: TNormNpc): _LPTPATHNAME; stdcall;
function TNormNpc_sPath(NormNpc: TNormNpc): _LPTPATHNAME; stdcall;
procedure TNormNpc_GetLineVariableText(NormNpc: TNormNpc; BaseObject: TBaseObject; pszMsg: PChar; pszOutMsg: PChar; nOutMsgLen: Integer); stdcall;
procedure TNormNpc_SetScriptActionCmd(PlugHandle: THandle; ActionCmd: TScriptCmd); stdcall;
function TNormNpc_GetScriptActionCmd(): TScriptCmd; stdcall;

procedure TNormNpc_SetScriptConditionCmd(PlugHandle: THandle; ConditionCmd: TScriptCmd); stdcall;
function TNormNpc_GetScriptConditionCmd(): TScriptCmd; stdcall;

function TNormNpc_GetManageNpc(): TNormNpc; stdcall;
function TNormNpc_GetFunctionNpc(): TNormNpc; stdcall;
procedure TNormNpc_GotoLable(NormNpc: TNormNpc; PlayObject: TPlayObject; pszLabel: PChar); stdcall;

procedure TNormNpc_SetScriptAction(PlugHandle: THandle; ScriptAction: TScriptAction); stdcall;
function TNormNpc_GetScriptAction(): TScriptAction; stdcall;

procedure TNormNpc_SetScriptCondition(PlugHandle: THandle; ScriptAction: TScriptCondition); stdcall;
function TNormNpc_GetScriptCondition(): TScriptCondition; stdcall;
function TMerchant_GoodsList(Merchant: TMerchant): TList; stdcall;

function TMerchant_GetItemPrice(Merchant: TMerchant; nIndex: Integer): Integer; stdcall;
function TMerchant_GetUserPrice(Merchant: TMerchant; PlayObject: TPlayObject; nPrice: Integer): Integer; stdcall;
function TMerchant_GetUserItemPrice(Merchant: TMerchant; UserItem: pTUserItem): Integer; stdcall;

procedure TMerchant_SetHookClientGetDetailGoodsList(GetDetailGoods: TObjectActionDetailGoods); stdcall;

procedure TMerchant_SetCheckUserSelect(PlugHandle: THandle; ObjectActionUserSelect: TObjectActionUserSelect); stdcall;
function TMerchant_GetCheckUserSelect(): TObjectActionUserSelect; stdcall;

function TUserEngine_Create(): TUserEngine; stdcall;
procedure TUserEngine_Free(UserEngine: TUserEngine); stdcall;
function TUserEngine_GetUserEngine(): TUserEngine; stdcall;

function TUserEngine_GetPlayObject(szPlayName: PChar; boGetHide: Boolean): TPlayObject; stdcall;

function TUserEngine_GetLoadPlayList(): TStringList; stdcall;
function TUserEngine_GetPlayObjectList(): TStringList; stdcall;
function TUserEngine_GetLoadPlayCount(): Integer; stdcall;
function TUserEngine_GetPlayObjectCount(): Integer; stdcall;
function TUserEngine_GetStdItemByName(pszItemName: PChar): pTStdItem; stdcall;
function TUserEngine_GetStdItemByIndex(nIndex: Integer): pTStdItem; stdcall;
function TUserEngine_CopyToUserItemFromName(const pszItemName: PChar; UserItem: pTUserItem): BOOL; stdcall;
function TUserEngine_GetStdItemList(): TObject; stdcall;
function TUserEngine_GetMagicList(): TObject; stdcall;

function TUserEngine_FindMagic(nMagIdx: Integer): pTMagic; stdcall;
function TUserEngine_AddMagic(Magic: pTMagic): Boolean; stdcall;
function TUserEngine_DelMagic(wMagicId: Word): Boolean; stdcall;


function TMapManager_FindMap(pszMapName: PChar): TEnvirnoment; stdcall;
function TEnvirnoment_GetRangeBaseObject(Envir: TEnvirnoment; nX, nY, nRage: Integer; boFlag: Boolean; BaseObjectList: TList): Integer; stdcall;
function TEnvirnoment_boCANRIDE(Envir: TEnvirnoment): PBoolean; stdcall;
function TEnvirnoment_boCANBAT(Envir: TEnvirnoment): PBoolean; stdcall;

procedure TUserEngine_SetHookRun(PlugHandle: THandle; UserEngineRun: TObjectAction); stdcall;
function TUserEngine_GetHookRun(): TObjectAction; stdcall;
procedure TUserEngine_SetHookClientUserMessage(ClientMsg: TObjectClientMsg); stdcall;

function TGuild_RankList(Guild: TGuild): TList; stdcall;

procedure TItemUnit_GetItemAddValue(UserItem: pTUserItem; var StdItem: TStdItem); stdcall;

function TMagicManager_GetMagicManager(): TMagicManager; stdcall;
function TMagicManager_DoSpell(MagicManager: TMagicManager; PlayObject: TPlayObject; UserMagic: pTUserMagic; nTargetX, nTargetY: Integer; TargeTBaseObject: TBaseObject): Boolean; stdcall;

function TMagicManager_MPow(UserMagic: pTUserMagic): Integer; stdcall;
function TMagicManager_GetPower(nPower: Integer; UserMagic: pTUserMagic): Integer; stdcall;
function TMagicManager_GetPower13(nInt: Integer; UserMagic: pTUserMagic): Integer; stdcall;
function TMagicManager_GetRPow(wInt: Integer): Word; stdcall;
function TMagicManager_IsWarrSkill(MagicManager: TMagicManager; wMagIdx: Integer): Boolean; stdcall;

function TMagicManager_MagBigHealing(MagicManager: TMagicManager; PlayObject: TBaseObject; nPower, nX, nY: Integer): Boolean; stdcall;
function TMagicManager_MagPushArround(MagicManager: TMagicManager; PlayObject: TBaseObject; nPushLevel: Integer): Integer; stdcall;
function TMagicManager_MagPushArroundTaos(MagicManager: TMagicManager; PlayObject: TBaseObject; nPushLevel: Integer): Integer; stdcall;
function TMagicManager_MagTurnUndead(MagicManager: TMagicManager; BaseObject, TargeTBaseObject: TBaseObject; nTargetX, nTargetY: Integer; nLevel: Integer): Boolean; stdcall;
function TMagicManager_MagMakeHolyCurtain(MagicManager: TMagicManager; BaseObject: TBaseObject; nPower: Integer; nX, nY: Integer): Integer; stdcall;
function TMagicManager_MagMakeGroupTransparent(MagicManager: TMagicManager; BaseObject: TBaseObject; nX, nY: Integer; nHTime: Integer): Boolean; stdcall;
function TMagicManager_MagTamming(MagicManager: TMagicManager; BaseObject, TargeTBaseObject: TBaseObject; nTargetX, nTargetY: Integer; nMagicLevel: Integer): Boolean; stdcall;
function TMagicManager_MagSaceMove(MagicManager: TMagicManager; BaseObject: TBaseObject; nLevel: Integer): Boolean; stdcall;
function TMagicManager_MagMakeFireCross(MagicManager: TMagicManager; PlayObject: TPlayObject; nDamage, nHTime, nX, nY: Integer): Integer; stdcall;
function TMagicManager_MagBigExplosion(MagicManager: TMagicManager; BaseObject: TBaseObject; nPower, nX, nY: Integer; nRage: Integer): Boolean; stdcall;
function TMagicManager_MagElecBlizzard(MagicManager: TMagicManager; BaseObject: TBaseObject; nPower: Integer): Boolean; stdcall;
function TMagicManager_MabMabe(MagicManager: TMagicManager; BaseObject, TargeTBaseObject: TBaseObject; nPower, nLevel, nTargetX, nTargetY: Integer): Boolean; stdcall;
function TMagicManager_MagMakeSlave(MagicManager: TMagicManager; PlayObject: TPlayObject; UserMagic: pTUserMagic): Boolean; stdcall;
function TMagicManager_MagMakeSinSuSlave(MagicManager: TMagicManager; PlayObject: TPlayObject; UserMagic: pTUserMagic): Boolean; stdcall;
function TMagicManager_MagWindTebo(MagicManager: TMagicManager; PlayObject: TPlayObject; UserMagic: pTUserMagic): Boolean; stdcall;
function TMagicManager_MagGroupLightening(MagicManager: TMagicManager; PlayObject: TPlayObject; UserMagic: pTUserMagic; nTargetX, nTargetY: Integer; TargeTBaseObject: TBaseObject; var boSpellFire: Boolean): Boolean; stdcall;
function TMagicManager_MagGroupAmyounsul(MagicManager: TMagicManager; PlayObject: TPlayObject; UserMagic: pTUserMagic; nTargetX, nTargetY: Integer; TargeTBaseObject: TBaseObject): Boolean; stdcall;
function TMagicManager_MagGroupDeDing(MagicManager: TMagicManager; PlayObject: TPlayObject; UserMagic: pTUserMagic; nTargetX, nTargetY: Integer; TargeTBaseObject: TBaseObject): Boolean; stdcall;
function TMagicManager_MagGroupMb(MagicManager: TMagicManager; PlayObject: TPlayObject; UserMagic: pTUserMagic; nTargetX, nTargetY: Integer; TargeTBaseObject: TBaseObject): Boolean; stdcall;
function TMagicManager_MagHbFireBall(MagicManager: TMagicManager; PlayObject: TPlayObject; UserMagic: pTUserMagic; nTargetX, nTargetY: Integer; var TargeTBaseObject: TBaseObject): Boolean; stdcall;
function TMagicManager_MagLightening(MagicManager: TMagicManager; PlayObject: TPlayObject; UserMagic: pTUserMagic; nTargetX, nTargetY: Integer; TargeTBaseObject: TBaseObject; var boSpellFire: Boolean): Boolean; stdcall;
procedure TMagicManager_SetHookDoSpell(DoSpell: TDoSpell); stdcall;
function TMagicManager_MagMakeSlave_(MagicManager: TMagicManager; PlayObject: TPlayObject; UserMagic: pTUserMagic; sMonName: PChar; nCount, nHumLevel, nMonLevel: Integer): Boolean; stdcall;
function TMagicManager_CheckAmulet(PlayObject: TPlayObject; nCount: Integer; nType: Integer; var Idx: Integer): Boolean; stdcall;
procedure TMagicManager_UseAmulet(PlayObject: TPlayObject; nCount: Integer; nType: Integer; var Idx: Integer); stdcall;
function TMagicManager_MagMakeSuperFireCross(MagicManager: TMagicManager; PlayObject: TPlayObject; nDamage, nHTime, nX, nY: Integer; nCount: Integer): Integer; stdcall;
function TMagicManager_MagMakePrivateTransparent(MagicManager: TMagicManager; PlayObject: TPlayObject; nDamage: Integer): Boolean; stdcall;

function TMagicManager_MagMakeFireball(MagicManager: TMagicManager; PlayObject: TPlayObject; UserMagic: pTUserMagic; nTargetX, nTargetY: Integer; var TargeTBaseObject: TBaseObject): Boolean; stdcall;
function TMagicManager_MagTreatment(MagicManager: TMagicManager; PlayObject: TPlayObject; UserMagic: pTUserMagic; var nTargetX, nTargetY: Integer; var TargeTBaseObject: TBaseObject): Boolean; stdcall;
function TMagicManager_MagMakeHellFire(MagicManager: TMagicManager; PlayObject: TPlayObject; UserMagic: pTUserMagic; nTargetX, nTargetY: Integer; TargeTBaseObject: TBaseObject): Boolean; stdcall;
function TMagicManager_MagMakeQuickLighting(MagicManager: TMagicManager; PlayObject: TPlayObject; UserMagic: pTUserMagic; var nTargetX, nTargetY: Integer; TargeTBaseObject: TBaseObject): Boolean; stdcall;
function TMagicManager_MagMakeLighting(MagicManager: TMagicManager; PlayObject: TPlayObject; UserMagic: pTUserMagic; nTargetX, nTargetY: Integer; var TargeTBaseObject: TBaseObject): Boolean; stdcall;
function TMagicManager_MagMakeFireCharm(MagicManager: TMagicManager; PlayObject: TPlayObject; UserMagic: pTUserMagic; nTargetX, nTargetY: Integer; var TargeTBaseObject: TBaseObject): Boolean; stdcall;
function TMagicManager_MagMakeUnTreatment(MagicManager: TMagicManager; PlayObject: TPlayObject; UserMagic: pTUserMagic; nTargetX, nTargetY: Integer; var TargeTBaseObject: TBaseObject): Boolean; stdcall;

function TMagicManager_MagMakeLivePlayObject(MagicManager: TMagicManager; PlayObject: TPlayObject; UserMagic: pTUserMagic; TargeTBaseObject: TBaseObject): Boolean; stdcall;
function TMagicManager_MagMakeArrestObject(MagicManager: TMagicManager; PlayObject: TPlayObject; UserMagic: pTUserMagic; TargeTBaseObject: TBaseObject): Boolean; stdcall;
function TMagicManager_MagChangePosition(MagicManager: TMagicManager; PlayObject: TPlayObject; nTargetX, nTargetY: Integer; TargeTBaseObject: TBaseObject): Boolean; stdcall;
function TMagicManager_MagMakeFireDay(MagicManager: TMagicManager; PlayObject: TPlayObject; UserMagic: pTUserMagic; nTargetX, nTargetY: Integer; var TargeTBaseObject: TBaseObject): Boolean; stdcall;

procedure TRunSocket_CloseUser(GateIdx, nSocket: Integer); stdcall;
procedure TRunSocket_SetHookExecGateMsgOpen(RunSocketExecGateMsg: TRunSocketObject_Open); stdcall;
procedure TRunSocket_SetHookExecGateMsgClose(RunSocketExecGateMsg: TRunSocketObject_Close); stdcall;
procedure TRunSocket_SetHookExecGateMsgEeceive_OK(RunSocketExecGateMsg: TRunSocketObject_Eeceive_OK); stdcall;
procedure TRunSocket_SetHookExecGateMsgData(RunSocketExecGateMsg: TRunSocketObject_Data); stdcall;

function TPlugOfEngine_GetProductVersion(): Integer; stdcall;
function TPlugOfEngine_GetUserVersion(): Integer; stdcall;
procedure TPlugOfEngine_SetUserLicense(nLimitNumber, nLimitUserCount: Integer); stdcall;
implementation
uses M2Share, HUtil32;
procedure TPlugOfEngine.InitPlugOfEngine;
var
  I: Integer;
begin
  GetFeature := nil;
  ObjectEnterAnotherMap := nil;
  ObjectDie := nil;
  ChangeCurrMap := nil;
  ClientQueryBagItems := nil;
  ClientQueryUserState := nil;
  SendActionGood := nil;
  SendActionFail := nil;
  SendWalkMsg := nil;
  SendHorseRunMsg := nil;
  SendRunMsg := nil;
  SendDeathMsg := nil;
  SendSkeletonMsg := nil;
  SendAliveMsg := nil;
  SendSpaceMoveMsg := nil;
  SendChangeFaceMsg := nil;
  SendUseitemsMsg := nil;
  SendUseMagicMsg := nil;
  SendUserLevelUpMsg := nil;
  SendUserAbilieyMsg := nil;
  SendUserStruckMsg := nil;
  SendSocket := nil;
  SendGoodsList := nil;
  SendUserStatusMsg := nil;
  CheckCanDropItem := nil;
  CheckCanDealItem := nil;
  CheckCanStorageItem := nil;
  CheckCanRepairItem := nil;
  CheckUserItems := nil;
  PlayObjectRun := nil;
  PlayObjectFilterMsg := nil;
  MerchantClientGetDetailGoodsList := nil;
  UserEngineRun := nil;
  ObjectClientMsg := nil;
  ObjectUserRunMsg := nil;
  SetHookDoSpell := nil;
  PlayObjectCreate := nil;
  PlayObjectDestroy := nil;
  PlayObjectUserCmd := nil;
  ObjectOperateMessage := nil;
  QuestActionScriptCmd := nil;
  QuestConditionScriptCmd := nil;
  ActionScriptProcess := nil;
  ConditionScriptProcess := nil;
  PlayObjectUserSelect := nil;
  PlayObjectUserLogin1 := nil;
  PlayObjectUserLogin2 := nil;
  PlayObjectUserLogin3 := nil;
  PlayObjectUserLogin4 := nil;
  RunSocketExecGateMsg_Open := nil;
  RunSocketExecGateMsg_Close := nil;
  RunSocketExecGateMsg_Eeceive_OK := nil;
  RunSocketExecGateMsg_Data := nil;

  for I := Low(PlayObjectCreateArray) to High(PlayObjectCreateArray) do begin
    PlayObjectCreateArray[I] := nil;
  end;
  for I := Low(PlayObjectDestroyArray) to High(PlayObjectDestroyArray) do begin
    PlayObjectDestroyArray[I] := nil;
  end;
  for I := Low(PlayObjectUserCmdArray) to High(PlayObjectUserCmdArray) do begin
    PlayObjectUserCmdArray[I] := nil;
  end;
  for I := Low(ObjectOperateMessageArray) to High(ObjectOperateMessageArray) do begin
    ObjectOperateMessageArray[I] := nil;
  end;
  for I := Low(QuestActionScriptCmdArray) to High(QuestActionScriptCmdArray) do begin
    QuestActionScriptCmdArray[I] := nil;
  end;
  for I := Low(QuestConditionScriptCmdArray) to High(QuestConditionScriptCmdArray) do begin
    QuestConditionScriptCmdArray[I] := nil;
  end;
  for I := Low(ActionScriptProcessArray) to High(ActionScriptProcessArray) do begin
    ActionScriptProcessArray[I] := nil;
  end;
  for I := Low(ConditionScriptProcessArray) to High(ConditionScriptProcessArray) do begin
    ConditionScriptProcessArray[I] := nil;
  end;
  for I := Low(PlayObjectUserSelectArray) to High(PlayObjectUserSelectArray) do begin
    PlayObjectUserSelectArray[I] := nil;
  end;
  for I := Low(UserEngineRunArray) to High(UserEngineRunArray) do begin
    UserEngineRunArray[I] := nil;
  end;
  nUserEngineRun := -1;
  nPlayObjectCreate := -1;
  nPlayObjectDestroy := -1;
  nPlayObjectUserCmd := -1;
  nObjectOperateMessage := -1;
  nQuestActionScriptCmd := -1;
  nQuestConditionScriptCmd := -1;
  nActionScriptProcess := -1;
  nConditionScriptProcess := -1;
  nPlayObjectUserSelect := -1;
end;
constructor TPlugOfEngine.Create();
begin
  inherited;
  PlugHandList := TStringList.Create;
  InitPlugOfEngine;
end;

destructor TPlugOfEngine.Destroy;
begin
  InitPlugOfEngine;
  PlugHandList.Free;
  inherited;
end;

function TPlugOfEngine.GetPlugByHandle(PlugHandle: THandle): Integer;
var
  I: Integer;
  Module: THandle;
begin
  Result := -1;
  for I := 0 to PlugHandList.Count - 1 do begin
    Module := THandle(PlugHandList.Objects[I]);
    if Module = PlugHandle then begin
      Result := I;
      break;
    end;
  end;
end;

procedure TPlugOfEngine.SetHookPlayObjectCreate(PlugHandle: THandle; ObjectAction: TObjectAction);
var
  nPlugNo: Integer;
begin
  nPlugNo := GetPlugByHandle(PlugHandle);
  if (nPlugNo >= 0) and (nPlugNo < MAXPULGCOUNT) then begin
    PlayObjectCreateArray[nPlugNo] := ObjectAction;
    if nPlugNo > nPlayObjectCreate then begin
      PlayObjectCreate := ObjectAction;
      nPlayObjectCreate := nPlugNo;
    end;
  end;
end;
procedure TPlugOfEngine.SetHookPlayObjectDestroy(PlugHandle: THandle; ObjectAction: TObjectAction);
var
  nPlugNo: Integer;
begin
  nPlugNo := GetPlugByHandle(PlugHandle);
  if (nPlugNo >= 0) and (nPlugNo < MAXPULGCOUNT) then begin
    PlayObjectDestroyArray[nPlugNo] := ObjectAction;
    if nPlugNo > nPlayObjectDestroy then begin
      PlayObjectDestroy := ObjectAction;
      nPlayObjectDestroy := nPlugNo;
    end;
  end;
end;
procedure TPlugOfEngine.SetHookPlayObjectUserCmd(PlugHandle: THandle; ObjectUserCmd: TObjectUserCmd);
var
  nPlugNo: Integer;
begin
  nPlugNo := GetPlugByHandle(PlugHandle);
  if (nPlugNo >= 0) and (nPlugNo < MAXPULGCOUNT) then begin
    PlayObjectUserCmdArray[nPlugNo] := ObjectUserCmd;
    if nPlugNo > nPlayObjectUserCmd then begin
      PlayObjectUserCmd := ObjectUserCmd;
      nPlayObjectUserCmd := nPlugNo;
    end;
  end;
end;
procedure TPlugOfEngine.SetHookObjectOperateMessage(PlugHandle: THandle; PlayObjectOperateMessage: TObjectOperateMessage);
var
  nPlugNo: Integer;
begin
  nPlugNo := GetPlugByHandle(PlugHandle);
  if (nPlugNo >= 0) and (nPlugNo < MAXPULGCOUNT) then begin
    ObjectOperateMessageArray[nPlugNo] := ObjectOperateMessage;
    if nPlugNo > nObjectOperateMessage then begin
      ObjectOperateMessage := PlayObjectOperateMessage;
      nObjectOperateMessage := nPlugNo;
    end;
  end;
end;
procedure TPlugOfEngine.SetHookQuestActionScriptCmd(PlugHandle: THandle; ScriptCmd: TScriptCmd);
var
  nPlugNo: Integer;
begin
  nPlugNo := GetPlugByHandle(PlugHandle);
  if (nPlugNo >= 0) and (nPlugNo < MAXPULGCOUNT) then begin
    QuestActionScriptCmdArray[nPlugNo] := ScriptCmd;
    if nPlugNo > nQuestActionScriptCmd then begin
      QuestActionScriptCmd := ScriptCmd;
      nQuestActionScriptCmd := nPlugNo;
    end;
  end;
end;
procedure TPlugOfEngine.SetHookQuestConditionScriptCmd(PlugHandle: THandle; ScriptCmd: TScriptCmd);
var
  nPlugNo: Integer;
begin
  nPlugNo := GetPlugByHandle(PlugHandle);
  if (nPlugNo >= 0) and (nPlugNo < MAXPULGCOUNT) then begin
    QuestConditionScriptCmdArray[nPlugNo] := ScriptCmd;
    if nPlugNo > nQuestConditionScriptCmd then begin
      QuestConditionScriptCmd := ScriptCmd;
      nQuestConditionScriptCmd := nPlugNo;
    end;
  end;
end;
procedure TPlugOfEngine.SetHookActionScriptProcess(PlugHandle: THandle; ScriptAction: TScriptAction);
var
  nPlugNo: Integer;
begin
  nPlugNo := GetPlugByHandle(PlugHandle);
  if (nPlugNo >= 0) and (nPlugNo < MAXPULGCOUNT) then begin
    ActionScriptProcessArray[nPlugNo] := ScriptAction;
    if nPlugNo > nActionScriptProcess then begin
      ActionScriptProcess := ScriptAction;
      nActionScriptProcess := nPlugNo;
    end;
  end;
end;
procedure TPlugOfEngine.SetHookConditionScriptProcess(PlugHandle: THandle; ScriptCondition: TScriptCondition);
var
  nPlugNo: Integer;
begin
  nPlugNo := GetPlugByHandle(PlugHandle);
  if (nPlugNo >= 0) and (nPlugNo < MAXPULGCOUNT) then begin
    ConditionScriptProcessArray[nPlugNo] := ScriptCondition;
    if nPlugNo > nConditionScriptProcess then begin
      ConditionScriptProcess := ScriptCondition;
      nConditionScriptProcess := nPlugNo;
    end;
  end;
end;
procedure TPlugOfEngine.SetHookUserEngineRun(PlugHandle: THandle; ObjectAction: TObjectAction);
var
  nPlugNo: Integer;
begin
  nPlugNo := GetPlugByHandle(PlugHandle);
  if (nPlugNo >= 0) and (nPlugNo < MAXPULGCOUNT) then begin
    UserEngineRunArray[nPlugNo] := ObjectAction;
    if nPlugNo > nUserEngineRun then begin
      UserEngineRun := ObjectAction;
      nUserEngineRun := nPlugNo;
    end;
  end;
end;

procedure TPlugOfEngine.SetHookPlayObjectUserSelect(PlugHandle: THandle; ObjectActionUserSelect: TObjectActionUserSelect);
var
  nPlugNo: Integer;
begin
  nPlugNo := GetPlugByHandle(PlugHandle);
  if (nPlugNo >= 0) and (nPlugNo < MAXPULGCOUNT) then begin
    PlayObjectUserSelectArray[nPlugNo] := ObjectActionUserSelect;
    if nPlugNo > nPlayObjectUserSelect then begin
      PlayObjectUserSelect := ObjectActionUserSelect;
      nPlayObjectUserSelect := nPlugNo;
    end;
  end;
end;
function TPlugOfEngine.GetHookPlayObjectCreate(PlugHandle: THandle): TObjectAction;
begin

end;
function TPlugOfEngine.GetHookPlayObjectDestroy(PlugHandle: THandle): TObjectAction;
begin

end;
function TPlugOfEngine.GetHookPlayObjectUserCmd(PlugHandle: THandle): TObjectUserCmd;
begin

end;
function TPlugOfEngine.GetHookObjectOperateMessage(PlugHandle: THandle): TObjectOperateMessage;
begin

end;
function TPlugOfEngine.GetHookQuestActionScriptCmd(PlugHandle: THandle): TScriptCmd;
begin

end;
function TPlugOfEngine.GetHookQuestConditionScriptCmd(PlugHandle: THandle): TScriptCmd;
begin

end;
function TPlugOfEngine.GetHookActionScriptProcess(PlugHandle: THandle): TScriptAction;
begin

end;
function TPlugOfEngine.GetHookConditionScriptProcess(PlugHandle: THandle): TScriptCondition;
begin

end;
function TPlugOfEngine.GetHookPlayObjectUserSelect(PlugHandle: THandle): TObjectActionUserSelect;
begin

end;
{===============================引擎插件共享函数===============================}
function TList_Create(): TList;
begin
  Result := TList.Create;
end;
procedure TList_Free(List: TList);
begin
  List.Free;
end;
function TList_Count(List: TList): Integer;
begin
  Result := List.Count;
end;
function TList_Add(List: TList; Item: Pointer): Integer;
begin
  Result := List.Add(Item);
end;
procedure TList_Insert(List: TList; nIndex: Integer; Item: Pointer);
begin
  List.Insert(nIndex, Item);
end;
function TList_Get(List: TList; nIndex: Integer): Pointer;
begin
  Result := List.Items[nIndex];
end;
procedure TList_Put(List: TList; nIndex: Integer; Item: Pointer);
begin
  //
end;
procedure TList_Delete(List: TList; nIndex: Integer);
begin
  List.Delete(nIndex);
end;
procedure TList_Clear(List: TList);
begin
  List.Clear;
end;
procedure TList_Exchange(List: TList; nIndex1, nIndex2: Integer);
begin
  List.Exchange(nIndex1, nIndex2);
end;
function TStringList_Create(): TStringList;
begin
  Result := TStringList.Create;
end;
procedure TStringList_Free(List: TStringList);
begin
  List.Free;
end;
function TStringList_Count(List: TStringList): Integer;
begin
  Result := List.Count;
end;
function TStringList_Add(List: TStringList; S: PChar): Integer;
begin
  List.Add(S);
end;
function TStringList_AddObject(List: TStringList; S: PChar; AObject: TObject): Integer;
begin
  List.AddObject(S, AObject);
end;
procedure TStringList_Insert(List: TStringList; nIndex: Integer; S: PChar);
begin
  List.Insert(nIndex, S);
end;
function TStringList_Get(List: TStringList; nIndex: Integer): PChar;
begin
  Result := PChar(List.Strings[nIndex]);
end;
function TStringList_GetObject(List: TStringList; nIndex: Integer): TObject;
begin
  Result := List.Objects[nIndex];
end;
procedure TStringList_Put(List: TStringList; nIndex: Integer; S: PChar);
begin

end;
procedure TStringList_PutObject(List: TStringList; nIndex: Integer; AObject: TObject);
begin

end;
procedure TStringList_Delete(List: TStringList; nIndex: Integer);
begin
  List.Delete(nIndex);
end;
procedure TStringList_Clear(List: TStringList);
begin
  List.Clear;
end;
procedure TStringList_Exchange(List: TStringList; nIndex1, nIndex2: Integer);
begin
  List.Exchange(nIndex1, nIndex2);
end;
procedure TStringList_LoadFormFile(List: TStringList; pszFileName: PChar);
begin
  List.LoadFromFile(StrPas(pszFileName));
end;
procedure TStringList_SaveToFile(List: TStringList; pszFileName: PChar);
begin
  List.SaveToFile(StrPas(pszFileName));
end;
procedure MainOutMessageAPI(pszMsg: PChar);
begin
  MainOutMessage(StrPas(pszMsg));
end;
procedure AddGameDataLogAPI(pszMsg: PChar);
begin
  AddGameDataLog(StrPas(pszMsg));
end;
function GetGameGoldName(): PTShortString;
var
  ShortString: TShortString;
begin
  ShortString.btLen := Length(g_Config.sGameGoldName);
  Move(g_Config.sGameGoldName[1], ShortString.Strings, ShortString.btLen);
  Result := @ShortString;
end;
procedure EDcode_Decode6BitBuf(pszSource: PChar; pszDest: PChar; nSrcLen, nDestLen: Integer);
begin
  Decode6BitBuf(pszSource, pszDest, nSrcLen, nDestLen);
end;
procedure EDcode_Encode6BitBuf(pszSource: PChar; pszDest: PChar; nSrcLen, nDestLen: Integer);
begin
  Encode6BitBuf(pszSource, pszDest, nSrcLen, nDestLen);
end;

procedure EDcode_DecodeBuffer(pszSource: PChar; pszDest: PChar; bufsize: Integer);
begin
  DecodeBuffer(StrPas(pszSource), pszDest, bufsize);
end;

procedure EDcode_EncodeBuffer(Buf: PChar; bufsize: Integer; var pszDest: array of Char);
var
  sDest: string;
begin
  FillChar(pszDest, SizeOf(pszDest), 0);
  sDest := EncodeBuffer(Buf, bufsize);
  Move(sDest[1], pszDest, Length(sDest));
end;

procedure EDcode_EncodeString(pszSource: PChar; var pszDest: array of Char);
var
  sDest: string;
begin
  FillChar(pszDest, SizeOf(pszDest), 0);
  sDest := EncodeString(StrPas(pszSource));
  Move(sDest[1], pszDest, Length(sDest));
end;

procedure EDcode_DeCodeString(pszSource: PChar; var pszDest: array of Char);
var
  sDest: string;
begin
  FillChar(pszDest, SizeOf(pszDest), 0);
  sDest := DeCodeString(StrPas(pszSource));
  Move(sDest[1], pszDest, Length(sDest));
end;



procedure EDcode_SetDecode(Decode: TEDCode);
begin

end;
procedure EDcode_SetEncode(Encode: TEDCode);
begin

end;
function TConfig_AmyOunsulPoint: PInteger;
begin
  Result := @g_Config.nAmyOunsulPoint;
end;

function TConfig_sEnvirDir(): _LPTDIRNAME;
var
  sEnvirDir: _TDIRNAME;
begin
  sEnvirDir := g_Config.sEnvirDir;
  Result := @sEnvirDir;
end;
function TBaseObject_Create(): TBaseObject;
begin
  Result := TBaseObject.Create;
end;
procedure TBaseObject_Free(BaseObject: TBaseObject);
begin
  BaseObject.Free;
end;
function TBaseObject_sMapFileName(BaseObject: TBaseObject): PTShortString;
var
  ShortString: TShortString;
begin
  ShortString.btLen := Length(BaseObject.m_sMapName);
  Move(BaseObject.m_sMapName[1], ShortString.Strings, ShortString.btLen);
  Result := @ShortString;
end;
function TBaseObject_sMapName(BaseObject: TBaseObject): PTShortString;
var
  ShortString: TShortString;
begin
  ShortString.btLen := Length(BaseObject.m_sMapName);
  Move(BaseObject.m_sMapName[1], ShortString.Strings, ShortString.btLen);
  Result := @ShortString;
end;
function TBaseObject_sMapNameA(BaseObject: TBaseObject): _LPTMAPNAME;
var
  sMapName: _TMAPNAME;
begin
  sMapName := BaseObject.m_sMapName;
  Result := @sMapName;
end;
function TBaseObject_sCharName(BaseObject: TBaseObject): PTShortString;
var
  ShortString: TShortString;
begin
  ShortString.btLen := Length(BaseObject.m_sCharName);
  Move(BaseObject.m_sCharName[1], ShortString.Strings, ShortString.btLen);
  Result := @ShortString;
end;
function TBaseObject_sCharNameA(BaseObject: TBaseObject): _LPTACTORNAME;
var
  sCharName: _TACTORNAME;
begin
  sCharName := BaseObject.m_sCharName;
  Result := @sCharName;
end;

function TBaseObject_nCurrX(BaseObject: TBaseObject): PInteger;
begin
  Result := @BaseObject.m_nCurrX;
end;
function TBaseObject_nCurrY(BaseObject: TBaseObject): PInteger;
begin
  Result := @BaseObject.m_nCurrY;
end;
function TBaseObject_btDirection(BaseObject: TBaseObject): PByte;
begin
  Result := @BaseObject.m_btDirection;
end;
function TBaseObject_btGender(BaseObject: TBaseObject): PByte;
begin
  Result := @BaseObject.m_btGender;
end;
function TBaseObject_btHair(BaseObject: TBaseObject): PByte;
begin
  Result := @BaseObject.m_btHair;
end;
function TBaseObject_btJob(BaseObject: TBaseObject): PByte;
begin
  Result := @BaseObject.m_btJob;
end;
function TBaseObject_nGold(BaseObject: TBaseObject): PInteger;
begin
  Result := @BaseObject.m_nGold;
end;
function TBaseObject_Ability(BaseObject: TBaseObject): PTABILITY;
begin
  Result := @BaseObject.m_Abil;
end;
function TBaseObject_WAbility(BaseObject: TBaseObject): PTABILITY;
begin
  Result := @BaseObject.m_WAbil;
end;
function TBaseObject_nCharStatus(BaseObject: TBaseObject): PInteger;
begin
  Result := @BaseObject.m_nCharStatus;
end;
function TBaseObject_sHomeMap(BaseObject: TBaseObject): PTShortString;
var
  ShortString: TShortString;
begin
  ShortString.btLen := Length(BaseObject.m_sHomeMap);
  Move(BaseObject.m_sHomeMap[1], ShortString.Strings, ShortString.btLen);
  Result := @ShortString;
end;
function TBaseObject_nHomeX(BaseObject: TBaseObject): PInteger;
begin
  Result := @BaseObject.m_nHomeX;
end;
function TBaseObject_nHomeY(BaseObject: TBaseObject): PInteger;
begin
  Result := @BaseObject.m_nHomeY;
end;
function TBaseObject_boOnHorse(BaseObject: TBaseObject): PBoolean;
begin
  Result := @BaseObject.m_boOnHorse;
end;
function TBaseObject_btHorseType(BaseObject: TBaseObject): PByte;
begin
  Result := @BaseObject.m_btHorseType;
end;

function TBaseObject_btDressEffType(BaseObject: TBaseObject): PByte;
begin
  Result := @BaseObject.m_btDressEffType;
end;
function TBaseObject_nPkPoint(BaseObject: TBaseObject): PInteger;
begin
  Result := @BaseObject.m_nPkPoint;
end;
function TBaseObject_boAllowGroup(BaseObject: TBaseObject): PBoolean;
begin
  Result := @BaseObject.m_boAllowGroup;
end;
function TBaseObject_boAllowGuild(BaseObject: TBaseObject): PBoolean;
begin
  Result := @BaseObject.m_boAllowGuild;
end;
function TBaseObject_nFightZoneDieCount(BaseObject: TBaseObject): PInteger;
begin
  Result := @BaseObject.m_nFightZoneDieCount;
end;
function TBaseObject_nBonusPoint(BaseObject: TBaseObject): PInteger;
begin
  Result := @BaseObject.m_nBonusPoint;
end;
function TBaseObject_nHungerStatus(BaseObject: TBaseObject): PInteger;
begin
  Result := @BaseObject.m_nHungerStatus;
end;
function TBaseObject_boAllowGuildReCall(BaseObject: TBaseObject): PBoolean;
begin
  Result := @BaseObject.m_boAllowGuildReCall;
end;
function TBaseObject_duBodyLuck(BaseObject: TBaseObject): PDouble;
begin
  Result := @BaseObject.m_dBodyLuck;
end;
function TBaseObject_nBodyLuckLevel(BaseObject: TBaseObject): PInteger;
begin
  Result := @BaseObject.m_nBodyLuckLevel;
end;
function TBaseObject_wGroupRcallTime(BaseObject: TBaseObject): PWord;
begin
  Result := @BaseObject.m_wGroupRcallTime;
end;
function TBaseObject_boAllowGroupReCall(BaseObject: TBaseObject): PBoolean;
begin
  Result := @BaseObject.m_boAllowGroupReCall;
end;
function TBaseObject_nCharStatusEx(BaseObject: TBaseObject): PInteger;
begin
  Result := @BaseObject.m_nCharStatusEx;
end;
function TBaseObject_dwFightExp(BaseObject: TBaseObject): PLongWord;
begin
  Result := @BaseObject.m_dwFightExp;
end;
function TBaseObject_nViewRange(BaseObject: TBaseObject): PInteger;
begin
  Result := @BaseObject.m_nViewRange;
end;
function TBaseObject_wAppr(BaseObject: TBaseObject): PWord;
begin
  Result := @BaseObject.m_wAppr;
end;
function TBaseObject_btRaceServer(BaseObject: TBaseObject): PByte;
begin
  Result := @BaseObject.m_btRaceServer;
end;
function TBaseObject_btRaceImg(BaseObject: TBaseObject): PByte;
begin
  Result := @BaseObject.m_btRaceImg;
end;
function TBaseObject_btHitPoint(BaseObject: TBaseObject): PByte;
begin
  Result := @BaseObject.m_btHitPoint;
end;
function TBaseObject_nHitPlus(BaseObject: TBaseObject): PShortInt;
begin
  Result := @BaseObject.m_nHitPlus;
end;
function TBaseObject_nHitDouble(BaseObject: TBaseObject): PShortInt;
begin
  Result := @BaseObject.m_nHitDouble;
end;
function TBaseObject_boRecallSuite(BaseObject: TBaseObject): PBoolean;
begin
  Result := @BaseObject.m_boRecallSuite;
end;
function TBaseObject_nHealthRecover(BaseObject: TBaseObject): PShortInt;
begin
  Result := @BaseObject.m_nHealthRecover;
end;
function TBaseObject_nSpellRecover(BaseObject: TBaseObject): PShortInt;
begin
  Result := @BaseObject.m_nSpellRecover;
end;
function TBaseObject_btAntiPoison(BaseObject: TBaseObject): PByte;
begin
  Result := @BaseObject.m_btAntiPoison;
end;
function TBaseObject_nPoisonRecover(BaseObject: TBaseObject): PShortInt;
begin
  Result := @BaseObject.m_nPoisonRecover;
end;
function TBaseObject_nAntiMagic(BaseObject: TBaseObject): PShortInt;
begin
  Result := @BaseObject.m_nAntiMagic;
end;
function TBaseObject_nLuck(BaseObject: TBaseObject): PInteger;
begin
  Result := @BaseObject.m_nLuck;
end;
function TBaseObject_nPerHealth(BaseObject: TBaseObject): PInteger;
begin
  Result := @BaseObject.m_nPerHealth;
end;
function TBaseObject_nPerHealing(BaseObject: TBaseObject): PInteger;
begin
  Result := @BaseObject.m_nPerHealing;
end;
function TBaseObject_nPerSpell(BaseObject: TBaseObject): PInteger;
begin
  Result := @BaseObject.m_nPerSpell;
end;
function TBaseObject_btGreenPoisoningPoint(BaseObject: TBaseObject): PByte;
begin
  Result := @BaseObject.m_btGreenPoisoningPoint;
end;
function TBaseObject_nGoldMax(BaseObject: TBaseObject): PInteger;
begin
  Result := @BaseObject.m_nGoldMax;
end;
function TBaseObject_btSpeedPoint(BaseObject: TBaseObject): PByte;
begin
  Result := @BaseObject.m_btSpeedPoint;
end;
function TBaseObject_btPermission(BaseObject: TBaseObject): PByte;
begin
  Result := @BaseObject.m_btPermission;
end;
function TBaseObject_nHitSpeed(BaseObject: TBaseObject): PShortInt;
begin
  Result := @BaseObject.m_nHitSpeed;
end;
function TBaseObject_TargetCret(BaseObject: TBaseObject): PTBaseObject;
begin
  Result := @BaseObject.m_TargetCret;
end;
function TBaseObject_LastHiter(BaseObject: TBaseObject): PTBaseObject;
begin
  Result := @BaseObject.m_LastHiter;
end;
function TBaseObject_ExpHiter(BaseObject: TBaseObject): PTBaseObject;
begin
  Result := @BaseObject.m_ExpHitter;
end;
function TBaseObject_btLifeAttrib(BaseObject: TBaseObject): PByte;
begin
  Result := @BaseObject.m_btLifeAttrib;
end;
function TBaseObject_GroupOwner(BaseObject: TBaseObject): TBaseObject;
begin
  Result := BaseObject.m_GroupOwner;
end;
function TBaseObject_GroupMembersList(BaseObject: TBaseObject): TStringList;
begin
  Result := @BaseObject.m_GroupMembers;
end;
function TBaseObject_boHearWhisper(BaseObject: TBaseObject): PBoolean;
begin
  Result := @BaseObject.m_boHearWhisper;
end;
function TBaseObject_boBanShout(BaseObject: TBaseObject): PBoolean;
begin
  Result := @BaseObject.m_boBanShout;
end;
function TBaseObject_boBanGuildChat(BaseObject: TBaseObject): PBoolean;
begin
  Result := @BaseObject.m_boBanGuildChat;
end;
function TBaseObject_boAllowDeal(BaseObject: TBaseObject): PBoolean;
begin
  Result := @BaseObject.m_boAllowDeal;
end;
function TBaseObject_nSlaveType(BaseObject: TBaseObject): PInteger;
begin

end;
function TBaseObject_Master(BaseObject: TBaseObject): PTBaseObject;
begin
  Result := @BaseObject.m_Master;
end;
function TBaseObject_btAttatckMode(BaseObject: TBaseObject): PByte;
begin
  Result := @BaseObject.m_btAttatckMode;
end;
function TBaseObject_btNameColor(BaseObject: TBaseObject): PByte;
begin
  Result := @BaseObject.m_btNameColor;
end;
function TBaseObject_nLight(BaseObject: TBaseObject): PInteger;
begin
  Result := @BaseObject.m_nLight;
end;
function TBaseObject_ItemList(BaseObject: TBaseObject): TList;
begin
  Result := BaseObject.m_ItemList;
end;
function TBaseObject_MagicList(BaseObject: TBaseObject): TList;
begin
  Result := BaseObject.m_MagicList;
end;
function TBaseObject_MyGuild(BaseObject: TBaseObject): TGuild;
begin
  Result := TGuild(BaseObject.m_MyGuild);
end;
function TBaseObject_UseItems(BaseObject: TBaseObject): PTPLAYUSEITEMS;
begin
  Result := @BaseObject.m_UseItems;
end;
function TBaseObject_btMonsterWeapon(BaseObject: TBaseObject): PByte;
begin
  Result := @BaseObject.m_btMonsterWeapon;
end;
function TBaseObject_PEnvir(BaseObject: TBaseObject): PTEnvirnoment;
begin
  Result := @BaseObject.m_PEnvir;
end;
function TBaseObject_boGhost(BaseObject: TBaseObject): PBoolean;
begin
  Result := @BaseObject.m_boGhost;
end;
function TBaseObject_boDeath(BaseObject: TBaseObject): PBoolean;
begin
  Result := @BaseObject.m_boDeath;
end;
function TBaseObject_DeleteBagItem(BaseObject: TBaseObject; UserItem: pTUserItem): BOOL;
begin
  Result := BaseObject.DelBagItem(UserItem);
end;
function TBaseObject_AddCustomData(BaseObject: TBaseObject; Data: Pointer): Integer;
begin

end;
function TBaseObject_GetCustomData(BaseObject: TBaseObject; nIndex: Integer): Pointer;
begin

end;
procedure TBaseObject_SendMsg(SelfObject, BaseObject: TBaseObject; wIdent, wParam: Word; nParam1, nParam2, nParam3: Integer; pszMsg: PChar);
begin
  SelfObject.SendMsg(BaseObject, wIdent, wParam, nParam1, nParam2, nParam3, StrPas(pszMsg));
end;
procedure TBaseObject_SendRefMsg(BaseObject: TBaseObject; wIdent, wParam: Word; nParam1, nParam2, nParam3: Integer; pszMsg: PChar);
begin
  BaseObject.SendRefMsg(wIdent, wParam, nParam1, nParam2, nParam3, StrPas(pszMsg));
end;
procedure TBaseObject_SendDelayMsg(SelfObject, BaseObject: TBaseObject; wIdent, wParam: Word; nParam1, nParam2, nParam3: Integer; pszMsg: PChar; dwDelayTime: LongWord);
begin
  SelfObject.SendDelayMsg(BaseObject, wIdent, wParam, nParam1, nParam2, nParam3, StrPas(pszMsg), dwDelayTime);
end;
procedure TBaseObject_SysMsg(BaseObject: TBaseObject; pszMsg: PChar; MsgColor: TMsgColor; MsgType: TMsgType);
begin
  BaseObject.SysMsg(StrPas(pszMsg), MsgColor, MsgType);
end;
function TBaseObject_GetFrontPosition(BaseObject: TBaseObject; var nX: Integer; var nY: Integer): Boolean;
begin
  Result := BaseObject.GetFrontPosition(nX, nY);
end;
function TBaseObject_GetRecallXY(BaseObject: TBaseObject; nX, nY: Integer; nRange: Integer; var nDX: Integer; var nDY: Integer): Boolean;
begin
  Result := BaseObject.sub_4C5370(nX, nY, nRange, nDX, nDY);
end;
procedure TBaseObject_SpaceMove(BaseObject: TBaseObject; pszMap: PChar; nX, nY: Integer; nInt: Integer);
begin
  BaseObject.SpaceMove(StrPas(pszMap), nX, nY, nInt);
end;
procedure TBaseObject_FeatureChanged(BaseObject: TBaseObject);
begin
  BaseObject.FeatureChanged;
end;
procedure TBaseObject_StatusChanged(BaseObject: TBaseObject);
begin
  BaseObject.StatusChanged;
end;
function TBaseObject_GetFeatureToLong(BaseObject: TBaseObject): Integer;
begin
  Result := BaseObject.GetFeatureToLong;
end;
function TBaseObject_GetFeature(SelfObject, BaseObject: TBaseObject): Integer;
begin
  Result := SelfObject.GetFeature(BaseObject);
end;
function TBaseObject_GetCharColor(SelfObject, BaseObject: TBaseObject): Byte;
begin
  Result := BaseObject.GetCharColor(BaseObject);
end;
function TBaseObject_GetNamecolor(BaseObject: TBaseObject): Byte;
begin
  Result := BaseObject.GetNamecolor;
end;
procedure TBaseObject_GoldChanged(BaseObject: TBaseObject);
begin
  BaseObject.GoldChanged;
end;
procedure TBaseObject_GameGoldChanged(BaseObject: TBaseObject);
begin
  BaseObject.GameGoldChanged;
end;
procedure TBaseObject_SetTargetCreat(AObject, BObject: TBaseObject);
begin
  AObject.SetTargetCreat(BObject);
end;
function TBaseObject_MagCanHitTarget(BaseObject: TBaseObject; nX, nY: Integer; TargeTBaseObject: TBaseObject): Boolean;
begin
  BaseObject.MagCanHitTarget(nX, nY, TargeTBaseObject);
end;
function TBaseObject_IsProtectTarget(AObject, BObject: TBaseObject): Boolean;
begin
  Result := AObject.IsProtectTarget(BObject);
end;
function TBaseObject_IsAttackTarget(AObject, BObject: TBaseObject): Boolean;
begin
  Result := AObject.IsAttackTarget(BObject);
end;
function TBaseObject_IsProperTarget(AObject, BObject: TBaseObject): Boolean;
begin
  Result := AObject.IsProperTarget(BObject);
end;
function TBaseObject_IsProperFriend(AObject, BObject: TBaseObject): Boolean;
begin
  Result := AObject.IsProperFriend(BObject);
end;
procedure TBaseObject_TrainSkillPoint(BaseObject: TBaseObject; UserMagic: pTUserMagic; nTranPoint: Integer);
begin
  BaseObject.TrainSkill(UserMagic, nTranPoint);
end;
function TBaseObject_GetAttackPower(BaseObject: TBaseObject; nBasePower, nPower: Integer): Integer;
begin
  Result := BaseObject.GetAttackPower(nBasePower, nPower);
end;
function TBaseObject_MakeSlave(BaseObject: TBaseObject; pszMonName: PChar; nMakeLevel, nExpLevel, nMaxMob, nType: Integer; dwRoyaltySec: LongWord): TBaseObject;
begin
  Result := BaseObject.MakeSlave(StrPas(pszMonName), nMakeLevel, nExpLevel, nMaxMob, dwRoyaltySec);
end;
procedure TBaseObject_MakeGhost(BaseObject: TBaseObject);
begin
  BaseObject.MakeGhost;
end;
procedure TBaseObject_RefNameColor(BaseObject: TBaseObject);
begin
  BaseObject.RefNameColor;
end;
//AddItem 占用内存由自己处理，API内部会自动申请内存
function TBaseObject_AddItemToBag(BaseObject: TBaseObject; AddItem: pTUserItem): BOOL;
var
  UserItem: pTUserItem;
begin
  New(UserItem);
  UserItem.MakeIndex := AddItem.MakeIndex;
  UserItem.wIndex := AddItem.wIndex;
  UserItem.Dura := AddItem.Dura;
  UserItem.DuraMax := AddItem.DuraMax;
  UserItem.btValue := AddItem.btValue;
  Result := BaseObject.AddItemToBag(UserItem);
  if not Result then DisPose(UserItem);
end;
function TBaseObject_AddItemToStorage(BaseObject: TBaseObject; AddItem: pTUserItem): BOOL;
var
  UserItem: pTUserItem;
begin
  Result := False;
  if BaseObject.m_StorageItemList.Count < 46 then begin
    New(UserItem);
    UserItem.MakeIndex := AddItem.MakeIndex;
    UserItem.wIndex := AddItem.wIndex;
    UserItem.Dura := AddItem.Dura;
    UserItem.DuraMax := AddItem.DuraMax;
    UserItem.btValue := AddItem.btValue;
    BaseObject.m_StorageItemList.Add(UserItem);
    Result := True;
    //DisPose(UserItem);
  end;
end;
procedure TBaseObject_ClearBagItem(BaseObject: TBaseObject);
begin
  //BaseObject.ClearBagItem;
end;
procedure TBaseObject_ClearStorageItem(BaseObject: TBaseObject);
begin

end;
procedure TBaseObject_SetHookGetFeature(ObjectActionFeature: TObjectActionFeature);
begin
  zPlugOfEngine.GetFeature := ObjectActionFeature;
end;

procedure TBaseObject_SetHookEnterAnotherMap(EnterAnotherMap: TObjectActionEnterMap);
begin
  zPlugOfEngine.ObjectEnterAnotherMap := EnterAnotherMap;
end;

procedure TBaseObject_SetHookObjectDie(ObjectDie: TObjectActionEx);
begin
  zPlugOfEngine.ObjectDie := ObjectDie;
end;
procedure TBaseObject_SetHookChangeCurrMap(ChangeCurrMap: TObjectActionEx);
begin
  zPlugOfEngine.ChangeCurrMap := ChangeCurrMap;
end;

function TBaseObject_MagMakeDefenceArea(BaseObject: TBaseObject; nX, nY, nRange, nSec: Integer; btState: Byte; boState: Boolean): Integer;
begin
  BaseObject.MagMakeDefenceArea(nX, nY, nRange, nSec, btState, boState);
end;

function TBaseObject_MagBubbleDefenceUp(BaseObject: TBaseObject; nLevel, nSec: Integer): Boolean;
begin
  BaseObject.MagBubbleDefenceUp(nLevel, nSec);
end;









function TPlayObject_IsEnoughBag(PlayObject: TPlayObject): Boolean;
begin
  Result := PlayObject.IsEnoughBag;
end;

function TPlayObject_nSoftVersionDate(PlayObject: TPlayObject): PInteger;
begin
  Result := @PlayObject.m_nSoftVersionDate;
end;
function TPlayObject_nSoftVersionDateEx(PlayObject: TPlayObject): PInteger;
begin
  Result := @PlayObject.m_nSoftVersionDateEx;
end;
function TPlayObject_dLogonTime(PlayObject: TPlayObject): PDateTime;
begin
  Result := @PlayObject.m_dLogonTime;
end;
function TPlayObject_dwLogonTick(PlayObject: TPlayObject): PLongWord;
begin
  Result := @PlayObject.m_dwLogonTick;
end;
function TPlayObject_nMemberType(PlayObject: TPlayObject): PInteger;
begin
  Result := @PlayObject.m_nMemberType;
end;
function TPlayObject_nMemberLevel(PlayObject: TPlayObject): PInteger;
begin
  Result := @PlayObject.m_nMemberLevel;
end;
function TPlayObject_nGameGold(PlayObject: TPlayObject): PInteger;
begin
  Result := @PlayObject.m_nGameGold;
end;
function TPlayObject_nGamePoint(PlayObject: TPlayObject): PInteger;
begin
  Result := @PlayObject.m_nGamePoint;
end;
function TPlayObject_nPayMentPoint(PlayObject: TPlayObject): PInteger;
begin
  Result := @PlayObject.m_nPayMentPoint;
end;
function TPlayObject_nClientFlag(PlayObject: TPlayObject): PInteger;
begin
  Result := @PlayObject.m_nClientFlagMode;
end;
function TPlayObject_nSelectID(PlayObject: TPlayObject): PInteger;
begin
  Result := @PlayObject.m_nSessionID;
end;
function TPlayObject_nClientFlagMode(PlayObject: TPlayObject): PInteger;
begin
  Result := @PlayObject.m_nClientFlagMode;
end;
function TPlayObject_dwClientTick(PlayObject: TPlayObject): PLongWord;
begin
  Result := @PlayObject.m_dwClientTick;
end;
function TPlayObject_wClientType(PlayObject: TPlayObject): PWord;
begin

end;
function TPlayObject_sBankPassword(PlayObject: TPlayObject): _LPTBANKPWD;
var
  sStoragePwd: _TBANKPWD;
begin
  sStoragePwd := PlayObject.m_sStoragePwd;
  Result := @sStoragePwd;
end;
function TPlayObject_nBankGold(PlayObject: TPlayObject): PInteger;
begin

end;
function TPlayObject_Create(): TPlayObject;
begin
  Result := TPlayObject.Create;
end;
procedure TPlayObject_Free(PlayObject: TPlayObject);
begin
  PlayObject.Free;
end;
procedure TPlayObject_SendSocket(PlayObject: TPlayObject; DefMsg: pTDefaultMessage; pszMsg: PChar);
begin
  PlayObject.SendSocket(DefMsg, StrPas(pszMsg));
end;
procedure TPlayObject_SendDefMessage(PlayObject: TPlayObject; wIdent: Word; nRecog: Integer; nParam, nTag, nSeries: Word; pszMsg: PChar);
begin
  PlayObject.SendDefMessage(wIdent, nRecog, nParam, nTag, nSeries, StrPas(pszMsg));
end;
procedure TPlayObject_SendAddItem(PlayObject: TPlayObject; AddItem: pTUserItem);
begin
  PlayObject.SendAddItem(AddItem);
end;
procedure TPlayObject_SendDelItem(PlayObject: TPlayObject; AddItem: pTUserItem);
begin
  PlayObject.SendDelItems(AddItem);
end;
function TPlayObject_TargetInNearXY(PlayObject: TPlayObject; Target: TBaseObject; nX, nY: Integer): Boolean;
begin
  Result := PlayObject.CretInNearXY(Target, nX, nY);
end;
procedure TPlayObject_SetBankPassword(PlayObject: TPlayObject; pszPassword: PChar);
begin
  PlayObject.m_sStoragePwd := StrPas(pszPassword);
end;
procedure TPlayObject_SetHookCreate(PlugHandle: THandle; PlayObjectCreate: TObjectAction);
begin
  zPlugOfEngine.SetHookPlayObjectCreate(PlugHandle, PlayObjectCreate);
end;

function TPlayObject_GetPlayObjectTick(PlayObject: TPlayObject; nCount: Integer): PLongWord; stdcall;
begin
  if (nCount >= 0) and (nCount < 100) then begin
    Result := @PlayObject.m_dwUserTick[nCount];
  end else Result := 0;
end;
procedure TPlayObject_SetPlayObjectTick(PlayObject: TPlayObject; nCount: Integer); stdcall;
begin
  if (nCount >= 0) and (nCount < 100) then begin
    PlayObject.m_dwUserTick[nCount] := GetTickCount;
  end;
end;

function TPlayObject_GetHookCreate(): TObjectAction;
begin
  Result := zPlugOfEngine.PlayObjectCreate;
end;

procedure TPlayObject_SetHookDestroy(PlugHandle: THandle; PlayObjectDestroy: TObjectAction);
begin
  zPlugOfEngine.SetHookPlayObjectDestroy(PlugHandle, PlayObjectDestroy);
end;

function TPlayObject_GetHookDestroy(): TObjectAction;
begin
  Result := zPlugOfEngine.PlayObjectDestroy;
end;
procedure TPlayObject_SetHookUserLogin1(PlayObjectUserLogin: TObjectAction);
begin
  zPlugOfEngine.PlayObjectUserLogin1 := PlayObjectUserLogin;
end;
procedure TPlayObject_SetHookUserLogin2(PlayObjectUserLogin: TObjectAction);
begin
  zPlugOfEngine.PlayObjectUserLogin2 := PlayObjectUserLogin;
end;
procedure TPlayObject_SetHookUserLogin3(PlayObjectUserLogin: TObjectAction);
begin
  zPlugOfEngine.PlayObjectUserLogin3 := PlayObjectUserLogin;
end;
procedure TPlayObject_SetHookUserLogin4(PlayObjectUserLogin: TObjectAction);
begin
  zPlugOfEngine.PlayObjectUserLogin4 := PlayObjectUserLogin;
end;
procedure TPlayObject_SetHookUserCmd(PlugHandle: THandle; PlayObjectUserCmd: TObjectUserCmd);
begin
  zPlugOfEngine.SetHookPlayObjectUserCmd(PlugHandle, PlayObjectUserCmd);
end;

function TPlayObject_GetHookUserCmd(): TObjectUserCmd;
begin
  Result := zPlugOfEngine.PlayObjectUserCmd;
end;

procedure TPlayObject_SetHookPlayOperateMessage(PlugHandle: THandle; PlayObjectOperateMessage: TObjectOperateMessage);
begin
  zPlugOfEngine.SetHookObjectOperateMessage(PlugHandle, PlayObjectOperateMessage);
end;

function TPlayObject_GetHookPlayOperateMessage(): TObjectOperateMessage;
begin
  Result := zPlugOfEngine.ObjectOperateMessage;
end;

procedure TPlayObject_SetHookClientQueryBagItems(ClientQueryBagItems: TObjectAction);
begin
  zPlugOfEngine.ClientQueryBagItems := ClientQueryBagItems;
end;

procedure TPlayObject_SetHookClientQueryUserState(ClientQueryUserState: TObjectActionXY);
begin
  zPlugOfEngine.ClientQueryUserState := ClientQueryUserState;
end;

procedure TPlayObject_SetHookSendActionGood(SendActionGood: TObjectAction);
begin
  zPlugOfEngine.SendActionGood := SendActionGood;
end;

procedure TPlayObject_SetHookSendActionFail(SendActionFail: TObjectAction);
begin
  zPlugOfEngine.SendActionFail := SendActionFail;
end;

procedure TPlayObject_SetHookSendWalkMsg(ObjectActioinXYD: TObjectActionXYD);
begin
  zPlugOfEngine.SendWalkMsg := ObjectActioinXYD;
end;

procedure TPlayObject_SetHookSendHorseRunMsg(ObjectActioinXYD: TObjectActionXYD);
begin
  zPlugOfEngine.SendHorseRunMsg := ObjectActioinXYD;
end;

procedure TPlayObject_SetHookSendRunMsg(ObjectActioinXYD: TObjectActionXYD);
begin
  zPlugOfEngine.SendRunMsg := ObjectActioinXYD;
end;

procedure TPlayObject_SetHookSendDeathMsg(ObjectActioinXYDM: TObjectActionXYDM);
begin
  zPlugOfEngine.SendDeathMsg := ObjectActioinXYDM;
end;

procedure TPlayObject_SetHookSendSkeletonMsg(ObjectActioinXYD: TObjectActionXYD);
begin
  zPlugOfEngine.SendSkeletonMsg := ObjectActioinXYD;
end;

procedure TPlayObject_SetHookSendAliveMsg(ObjectActioinXYD: TObjectActionXYD);
begin
  zPlugOfEngine.SendAliveMsg := ObjectActioinXYD;
end;

procedure TPlayObject_SetHookSendSpaceMoveMsg(ObjectActioinXYDWS: TObjectActionXYDWS);
begin
  zPlugOfEngine.SendSpaceMoveMsg := ObjectActioinXYDWS;
end;

procedure TPlayObject_SetHookSendChangeFaceMsg(ObjectActioinObject: TObjectActionObject);
begin
  zPlugOfEngine.SendChangeFaceMsg := ObjectActioinObject;
end;

procedure TPlayObject_SetHookSendUseitemsMsg(ObjectActioin: TObjectAction);
begin
  zPlugOfEngine.SendUseitemsMsg := ObjectActioin;
end;

procedure TPlayObject_SetHookSendUserLevelUpMsg(ObjectActioinObject: TObjectAction);
begin
  zPlugOfEngine.SendUserLevelUpMsg := ObjectActioinObject;
end;

procedure TPlayObject_SetHookSendUserAbilieyMsg(ObjectActioinObject: TObjectAction);
begin
  zPlugOfEngine.SendUserAbilieyMsg := ObjectActioinObject;
end;

procedure TPlayObject_SetHookSendUserStatusMsg(ObjectActioinXYDWS: TObjectActionXYDWS);
begin

end;

procedure TPlayObject_SetHookSendUserStruckMsg(ObjectActioinObject: TObjectActionObject);
begin
  zPlugOfEngine.SendUserStruckMsg := ObjectActioinObject;
end;

procedure TPlayObject_SetHookSendUseMagicMsg(ObjectActioin: TObjectAction);
begin
  zPlugOfEngine.SendUseMagicMsg := ObjectActioin;
end;

procedure TPlayObject_SetHookSendSocket(SendSocket: TPlaySendSocket);
begin
  zPlugOfEngine.SendSocket := SendSocket;
end;

procedure TPlayObject_SetHookSendGoodsList(SendGoodsList: TObjectActionSendGoods);
begin
  zPlugOfEngine.SendGoodsList := SendGoodsList;
end;

procedure TPlayObject_SetCheckClientDropItem(ActionDropItem: TObjectActionItem);
begin
  zPlugOfEngine.CheckCanDropItem := ActionDropItem;
end;

procedure TPlayObject_SetCheckClientDealItem(ActionItem: TObjectActionItem);
begin
  zPlugOfEngine.CheckCanDealItem := ActionItem;
end;

procedure TPlayObject_SetCheckClientStorageItem(ActionItem: TObjectActionItem);
begin
  zPlugOfEngine.CheckCanStorageItem := ActionItem;
end;

procedure TPlayObject_SetCheckClientRepairItem(ActionItem: TObjectActionItem);
begin
  zPlugOfEngine.CheckCanRepairItem := ActionItem;
end;

procedure TPlayObject_SetHookCheckUserItems(ObjectActioin: TObjectActionCheckUserItem);
begin
  zPlugOfEngine.CheckUserItems := ObjectActioin;
end;

procedure TPlayObject_SetHookRun(PlayRun: TObjectAction);
begin
  zPlugOfEngine.PlayObjectRun := PlayRun;
end;

procedure TPlayObject_SetHookFilterMsg(FilterMsg: TObjectFilterMsg);
begin
  zPlugOfEngine.PlayObjectFilterMsg := FilterMsg;
end;

function TPlayObject_PlayUseItems(PlayObject: TPlayObject): PTPLAYUSEITEMS;
begin
  Result := @PlayObject.m_UseItems;
end;

function TNormNpc_sFilePath(NormNpc: TNormNpc): _LPTPATHNAME;
var
  sFilePath: _TPATHNAME;
begin
  sFilePath := NormNpc.m_sFilePath;
  Result := @sFilePath;
end;
function TNormNpc_sPath(NormNpc: TNormNpc): _LPTPATHNAME;
var
  sPath: _TPATHNAME;
begin
  sPath := NormNpc.m_sPath;
  Result := @sPath;
end;
procedure TNormNpc_GetLineVariableText(NormNpc: TNormNpc; BaseObject: TBaseObject; pszMsg: PChar; pszOutMsg: PChar; nOutMsgLen: Integer);
var
  s10, sMsg, sOutMsg: string;
  nC: Integer;
begin
  sMsg := StrPas(pszMsg);
  SetLength(sOutMsg, nOutMsgLen);
  Move(pszOutMsg^, sOutMsg[1], nOutMsgLen);
  nC := 0;
  while True do begin
    if TagCount(sMsg, '>') < 1 then break;
    ArrestStringEx(sMsg, '<', '>', s10);
    NormNpc.GetVariableText(TPlayObject(BaseObject), sOutMsg, s10);
    Inc(nC);
    if nC >= 101 then break;
  end;
end;

procedure TNormNpc_SetScriptActionCmd(PlugHandle: THandle; ActionCmd: TScriptCmd);
begin
  zPlugOfEngine.SetHookQuestActionScriptCmd(PlugHandle, ActionCmd);
end;

function TNormNpc_GetScriptActionCmd(): TScriptCmd;
begin
  Result := zPlugOfEngine.QuestActionScriptCmd;
end;

procedure TNormNpc_SetScriptConditionCmd(PlugHandle: THandle; ConditionCmd: TScriptCmd);
begin
  zPlugOfEngine.SetHookQuestConditionScriptCmd(PlugHandle, ConditionCmd);
end;

function TNormNpc_GetScriptConditionCmd(): TScriptCmd;
begin
  Result := zPlugOfEngine.QuestConditionScriptCmd;
end;

function TNormNpc_GetManageNpc(): TNormNpc;
begin
  Result := g_ManageNPC;
end;
function TNormNpc_GetFunctionNpc(): TNormNpc;
begin
  Result := g_FunctionNPC;
end;
procedure TNormNpc_GotoLable(NormNpc: TNormNpc; PlayObject: TPlayObject; pszLabel: PChar);
begin
  NormNpc.GotoLable(PlayObject, StrPas(pszLabel), False);
end;
procedure TNormNpc_SetScriptAction(PlugHandle: THandle; ScriptAction: TScriptAction);
begin
  zPlugOfEngine.SetHookActionScriptProcess(PlugHandle, ScriptAction);
end;
function TNormNpc_GetScriptAction(): TScriptAction;
begin
  Result := zPlugOfEngine.ActionScriptProcess;
end;
procedure TNormNpc_SetScriptCondition(PlugHandle: THandle; ScriptAction: TScriptCondition);
begin
  zPlugOfEngine.SetHookConditionScriptProcess(PlugHandle, ScriptAction);
end;

function TNormNpc_GetScriptCondition(): TScriptCondition;
begin
  Result := zPlugOfEngine.ConditionScriptProcess;
end;

function TMerchant_GoodsList(Merchant: TMerchant): TList;
begin
  Result := Merchant.m_GoodsList;
end;
function TMerchant_GetItemPrice(Merchant: TMerchant; nIndex: Integer): Integer;
begin
  if (nIndex < Merchant.m_ItemPriceList.Count) and (nIndex >= 0) and (Merchant.m_ItemPriceList.Count > 0) then
    Result := pTItemPrice(Merchant.m_ItemPriceList.Items[nIndex]).nPrice else Result := -1;
end;
function TMerchant_GetUserPrice(Merchant: TMerchant; PlayObject: TPlayObject; nPrice: Integer): Integer;
begin
  Result := Merchant.GetUserPrice(PlayObject, nPrice);
end;
function TMerchant_GetUserItemPrice(Merchant: TMerchant; UserItem: pTUserItem): Integer;
begin
  Result := Merchant.GetUserItemPrice(UserItem);
end;
procedure TMerchant_SetHookClientGetDetailGoodsList(GetDetailGoods: TObjectActionDetailGoods);
begin
  zPlugOfEngine.MerchantClientGetDetailGoodsList := GetDetailGoods;
end;
function TUserEngine_Create(): TUserEngine;
begin
  Result := TUserEngine.Create;
end;
procedure TUserEngine_Free(UserEngine: TUserEngine);
begin
  UserEngine.Free;
end;
function TUserEngine_GetUserEngine(): TUserEngine;
begin
  Result := UserEngine;
end;
function TUserEngine_GetPlayObject(szPlayName: PChar; boGetHide: Boolean): TPlayObject;
begin
  Result := UserEngine.GetPlayObject(StrPas(szPlayName));
end;
function TUserEngine_GetLoadPlayList(): TStringList;
begin
  Result := UserEngine.m_LoadPlayList;
end;
function TUserEngine_GetPlayObjectList(): TStringList;
begin
  Result := UserEngine.m_PlayObjectList;
end;
function TUserEngine_GetLoadPlayCount(): Integer;
begin
  Result := UserEngine.LoadPlayCount;
end;
function TUserEngine_GetPlayObjectCount(): Integer;
begin
  Result := UserEngine.PlayObjectCount;
end;
function TUserEngine_GetStdItemByName(pszItemName: PChar): pTStdItem;
begin
  Result := UserEngine.GetStdItem(StrPas(pszItemName));
end;
function TUserEngine_GetStdItemByIndex(nIndex: Integer): pTStdItem;
begin
  Result := UserEngine.GetStdItem(nIndex);
end;
function TUserEngine_CopyToUserItemFromName(const pszItemName: PChar; UserItem: pTUserItem): BOOL;
begin
  Result := UserEngine.CopyToUserItemFromName(StrPas(pszItemName), UserItem);
end;
function TMapManager_FindMap(pszMapName: PChar): TEnvirnoment;
begin
  Result := g_MapManager.FindMap(StrPas(pszMapName));
end;
function TEnvirnoment_GetRangeBaseObject(Envir: TEnvirnoment; nX, nY, nRage: Integer; boFlag: Boolean; BaseObjectList: TList): Integer;
begin
  Result := Envir.GetRangeBaseObject(nX, nY, nRage, boFlag, BaseObjectList);
end;
function TEnvirnoment_boCANRIDE(Envir: TEnvirnoment): PBoolean;
begin

end;
function TEnvirnoment_boCANBAT(Envir: TEnvirnoment): PBoolean;
begin

end;
procedure TUserEngine_SetHookRun(PlugHandle: THandle; UserEngineRun: TObjectAction);
begin
  zPlugOfEngine.SetHookUserEngineRun(PlugHandle, UserEngineRun);
end;
function TUserEngine_GetHookRun(): TObjectAction;
begin
  Result := zPlugOfEngine.UserEngineRun;
end;
procedure TUserEngine_SetHookClientUserMessage(ClientMsg: TObjectClientMsg);
begin
  zPlugOfEngine.ObjectClientMsg := ClientMsg;
end;
function TGuild_RankList(Guild: TGuild): TList;
begin
  Result := Guild.m_RankList;
end;
procedure TItemUnit_GetItemAddValue(UserItem: pTUserItem; var StdItem: TStdItem);
begin
  ItemUnit.GetItemAddValue(UserItem, StdItem);
end;
function TMagicManager_GetMagicManager(): TMagicManager;
begin
  Result := MagicManager;
end;
function TMagicManager_DoSpell(MagicManager: TMagicManager; PlayObject: TPlayObject; UserMagic: pTUserMagic; nTargetX, nTargetY: Integer; TargeTBaseObject: TBaseObject): Boolean;
begin
  Result := MagicManager.DoSpell(PlayObject, UserMagic, nTargetX, nTargetY, TargeTBaseObject);
end;
function TMagicManager_MPow(UserMagic: pTUserMagic): Integer;
begin
  Result := MPow(UserMagic);
end;
function TMagicManager_GetPower(nPower: Integer; UserMagic: pTUserMagic): Integer;
begin
  Result := GetPower(nPower, UserMagic);
end;
function TMagicManager_GetPower13(nInt: Integer; UserMagic: pTUserMagic): Integer;
begin
  Result := GetPower13(nInt, UserMagic);
end;
function TMagicManager_GetRPow(wInt: Integer): Word;
begin
  Result := GetRPow(wInt);
end;
function TMagicManager_IsWarrSkill(MagicManager: TMagicManager; wMagIdx: Integer): Boolean;
begin
  Result := MagicManager.IsWarrSkill(wMagIdx);
end;
function TMagicManager_MagBigHealing(MagicManager: TMagicManager; PlayObject: TBaseObject; nPower, nX, nY: Integer): Boolean;
begin
  Result := MagicManager.MagBigHealing(PlayObject, nPower, nX, nY);
end;
function TMagicManager_MagPushArround(MagicManager: TMagicManager; PlayObject: TBaseObject; nPushLevel: Integer): Integer;
begin
  Result := MagicManager.MagPushArround(PlayObject, nPushLevel);
end;
function TMagicManager_MagPushArroundTaos(MagicManager: TMagicManager; PlayObject: TBaseObject; nPushLevel: Integer): Integer;
begin
  Result := MagicManager.MagPushArround(PlayObject, nPushLevel);
end;
function TMagicManager_MagTurnUndead(MagicManager: TMagicManager; BaseObject, TargeTBaseObject: TBaseObject; nTargetX, nTargetY: Integer; nLevel: Integer): Boolean;
begin
  Result := MagicManager.MagTurnUndead(BaseObject, TargeTBaseObject, nTargetX, nTargetY, nLevel);
end;
function TMagicManager_MagMakeHolyCurtain(MagicManager: TMagicManager; BaseObject: TBaseObject; nPower: Integer; nX, nY: Integer): Integer;
begin
  Result := MagicManager.MagMakeHolyCurtain(BaseObject, nPower, nX, nY);
end;
function TMagicManager_MagMakeGroupTransparent(MagicManager: TMagicManager; BaseObject: TBaseObject; nX, nY: Integer; nHTime: Integer): Boolean;
begin
  Result := MagicManager.MagMakeGroupTransparent(BaseObject, nX, nY, nHTime);
end;
function TMagicManager_MagTamming(MagicManager: TMagicManager; BaseObject, TargeTBaseObject: TBaseObject; nTargetX, nTargetY: Integer; nMagicLevel: Integer): Boolean;
begin
  Result := MagicManager.MagTamming(BaseObject, TargeTBaseObject, nTargetX, nTargetY, nMagicLevel);
end;
function TMagicManager_MagSaceMove(MagicManager: TMagicManager; BaseObject: TBaseObject; nLevel: Integer): Boolean;
begin
  Result := MagicManager.MagSaceMove(BaseObject, nLevel);
end;
function TMagicManager_MagMakeFireCross(MagicManager: TMagicManager; PlayObject: TPlayObject; nDamage, nHTime, nX, nY: Integer): Integer;
begin
  Result := MagicManager.MagMakeFireCross(PlayObject, nDamage, nHTime, nX, nY);
end;
function TMagicManager_MagBigExplosion(MagicManager: TMagicManager; BaseObject: TBaseObject; nPower, nX, nY: Integer; nRage: Integer): Boolean;
begin
  Result := MagicManager.MagBigExplosion(BaseObject, nPower, nX, nY, nRage);
end;
function TMagicManager_MagElecBlizzard(MagicManager: TMagicManager; BaseObject: TBaseObject; nPower: Integer): Boolean;
begin
  Result := MagicManager.MagElecBlizzard(BaseObject, nPower);
end;
function TMagicManager_MabMabe(MagicManager: TMagicManager; BaseObject, TargeTBaseObject: TBaseObject; nPower, nLevel, nTargetX, nTargetY: Integer): Boolean;
begin
  Result := MagicManager.MabMabe(BaseObject, TargeTBaseObject, nPower, nLevel, nTargetX, nTargetY);
end;
function TMagicManager_MagMakeSlave(MagicManager: TMagicManager; PlayObject: TPlayObject; UserMagic: pTUserMagic): Boolean;
begin
  Result := MagicManager.MagMakeSlave(PlayObject, UserMagic);
end;
function TMagicManager_MagMakeSinSuSlave(MagicManager: TMagicManager; PlayObject: TPlayObject; UserMagic: pTUserMagic): Boolean;
begin
  Result := MagicManager.MagMakeSinSuSlave(PlayObject, UserMagic);
end;
function TMagicManager_MagWindTebo(MagicManager: TMagicManager; PlayObject: TPlayObject; UserMagic: pTUserMagic): Boolean;
begin
  Result := MagicManager.MagWindTebo(PlayObject, UserMagic);
end;
function TMagicManager_MagGroupLightening(MagicManager: TMagicManager; PlayObject: TPlayObject; UserMagic: pTUserMagic; nTargetX, nTargetY: Integer; TargeTBaseObject: TBaseObject; var boSpellFire: Boolean): Boolean;
begin
  Result := MagicManager.MagGroupLightening(PlayObject, UserMagic, nTargetX, nTargetY, TargeTBaseObject, boSpellFire);
end;
function TMagicManager_MagGroupAmyounsul(MagicManager: TMagicManager; PlayObject: TPlayObject; UserMagic: pTUserMagic; nTargetX, nTargetY: Integer; TargeTBaseObject: TBaseObject): Boolean;
begin
  Result := MagicManager.MagGroupAmyounsul(PlayObject, UserMagic, nTargetX, nTargetY, TargeTBaseObject);
end;
function TMagicManager_MagGroupDeDing(MagicManager: TMagicManager; PlayObject: TPlayObject; UserMagic: pTUserMagic; nTargetX, nTargetY: Integer; TargeTBaseObject: TBaseObject): Boolean;
begin
  Result := MagicManager.MagGroupDeDing(PlayObject, UserMagic, nTargetX, nTargetY, TargeTBaseObject);
end;
function TMagicManager_MagGroupMb(MagicManager: TMagicManager; PlayObject: TPlayObject; UserMagic: pTUserMagic; nTargetX, nTargetY: Integer; TargeTBaseObject: TBaseObject): Boolean;
begin
  Result := MagicManager.MagGroupMb(PlayObject, UserMagic, nTargetX, nTargetY, TargeTBaseObject);
end;
function TMagicManager_MagHbFireBall(MagicManager: TMagicManager; PlayObject: TPlayObject; UserMagic: pTUserMagic; nTargetX, nTargetY: Integer; var TargeTBaseObject: TBaseObject): Boolean;
begin
  Result := MagicManager.MagHbFireBall(PlayObject, UserMagic, nTargetX, nTargetY, TargeTBaseObject);
end;
function TMagicManager_MagLightening(MagicManager: TMagicManager; PlayObject: TPlayObject; UserMagic: pTUserMagic; nTargetX, nTargetY: Integer; TargeTBaseObject: TBaseObject; var boSpellFire: Boolean): Boolean;
begin
  Result := MagicManager.MagLightening(PlayObject, UserMagic, nTargetX, nTargetY, TargeTBaseObject, boSpellFire);
end;
function TMagicManager_MagMakeSlave_(MagicManager: TMagicManager; PlayObject: TPlayObject; UserMagic: pTUserMagic; sMonName: PChar; nCount, nHumLevel, nMonLevel: Integer): Boolean;
begin
  MagicManager.MagMakeSlave_(PlayObject, UserMagic, StrPas(sMonName), nCount, nHumLevel, nMonLevel);
end;

function TMagicManager_CheckAmulet(PlayObject: TPlayObject; nCount: Integer; nType: Integer; var Idx: Integer): Boolean;
begin
  Result := CheckAmulet(PlayObject, nCount, nType, Idx);
end;
procedure TMagicManager_UseAmulet(PlayObject: TPlayObject; nCount: Integer; nType: Integer; var Idx: Integer); stdcall;
begin
  UseAmulet(PlayObject, nCount, nType, Idx);
end;
function TMagicManager_MagMakeSuperFireCross(MagicManager: TMagicManager; PlayObject: TPlayObject; nDamage, nHTime, nX, nY: Integer; nCount: Integer): Integer;
begin
  Result := MagicManager.MagMakeSuperFireCross(PlayObject, nDamage, nHTime, nX, nY, nCount);
end;
function TMagicManager_MagMakeFireball(MagicManager: TMagicManager; PlayObject: TPlayObject; UserMagic: pTUserMagic; nTargetX, nTargetY: Integer; var TargeTBaseObject: TBaseObject): Boolean;
begin
  Result := MagicManager.MagMakeFireball(PlayObject, UserMagic, nTargetX, nTargetY, TargeTBaseObject);
end;
function TMagicManager_MagTreatment(MagicManager: TMagicManager; PlayObject: TPlayObject; UserMagic: pTUserMagic; var nTargetX, nTargetY: Integer; var TargeTBaseObject: TBaseObject): Boolean;
begin
  Result := MagicManager.MagTreatment(PlayObject, UserMagic, nTargetX, nTargetY, TargeTBaseObject);
end;
function TMagicManager_MagMakeHellFire(MagicManager: TMagicManager; PlayObject: TPlayObject; UserMagic: pTUserMagic; nTargetX, nTargetY: Integer; TargeTBaseObject: TBaseObject): Boolean;
begin
  Result := MagicManager.MagMakeHellFire(PlayObject, UserMagic, nTargetX, nTargetY, TargeTBaseObject);
end;
function TMagicManager_MagMakeQuickLighting(MagicManager: TMagicManager; PlayObject: TPlayObject; UserMagic: pTUserMagic; var nTargetX, nTargetY: Integer; TargeTBaseObject: TBaseObject): Boolean;
begin
  Result := MagicManager.MagMakeQuickLighting(PlayObject, UserMagic, nTargetX, nTargetY, TargeTBaseObject);
end;
function TMagicManager_MagMakeLighting(MagicManager: TMagicManager; PlayObject: TPlayObject; UserMagic: pTUserMagic; nTargetX, nTargetY: Integer; var TargeTBaseObject: TBaseObject): Boolean;
begin
  Result := MagicManager.MagMakeLighting(PlayObject, UserMagic, nTargetX, nTargetY, TargeTBaseObject);
end;
function TMagicManager_MagMakeFireCharm(MagicManager: TMagicManager; PlayObject: TPlayObject; UserMagic: pTUserMagic; nTargetX, nTargetY: Integer; var TargeTBaseObject: TBaseObject): Boolean;
begin
  Result := MagicManager.MagMakeFireCharm(PlayObject, UserMagic, nTargetX, nTargetY, TargeTBaseObject);
end;
function TMagicManager_MagMakeUnTreatment(MagicManager: TMagicManager; PlayObject: TPlayObject; UserMagic: pTUserMagic; nTargetX, nTargetY: Integer; var TargeTBaseObject: TBaseObject): Boolean;
begin
  Result := MagicManager.MagMakeUnTreatment(PlayObject, UserMagic, nTargetX, nTargetY, TargeTBaseObject);
end;
function TMagicManager_MagMakePrivateTransparent(MagicManager: TMagicManager; PlayObject: TPlayObject; nDamage: Integer): Boolean;
begin
  Result := MagicManager.MagMakePrivateTransparent(PlayObject, nDamage);
end;
function TMagicManager_MagMakeLivePlayObject(MagicManager: TMagicManager; PlayObject: TPlayObject; UserMagic: pTUserMagic; TargeTBaseObject: TBaseObject): Boolean;
begin
  Result := MagicManager.MagMakeLivePlayObject(PlayObject, UserMagic, TargeTBaseObject);
end;
function TMagicManager_MagMakeArrestObject(MagicManager: TMagicManager; PlayObject: TPlayObject; UserMagic: pTUserMagic; TargeTBaseObject: TBaseObject): Boolean;
begin
  Result := MagicManager.MagMakeArrestObject(PlayObject, UserMagic, TargeTBaseObject);
end;
function TMagicManager_MagChangePosition(MagicManager: TMagicManager; PlayObject: TPlayObject; nTargetX, nTargetY: Integer; TargeTBaseObject: TBaseObject): Boolean;
begin
  Result := MagicManager.MagChangePosition(PlayObject, nTargetX, nTargetY, TargeTBaseObject);
end;
function TMagicManager_MagMakeFireDay(MagicManager: TMagicManager; PlayObject: TPlayObject; UserMagic: pTUserMagic; nTargetX, nTargetY: Integer; var TargeTBaseObject: TBaseObject): Boolean;
begin
  Result := MagicManager.MagMakeFireDay(PlayObject, UserMagic, nTargetX, nTargetY, TargeTBaseObject);
end;

procedure TMagicManager_SetHookDoSpell(DoSpell: TDoSpell);
begin
  zPlugOfEngine.SetHookDoSpell := DoSpell;
end;

procedure TMerchant_SetCheckUserSelect(PlugHandle: THandle; ObjectActionUserSelect: TObjectActionUserSelect);
begin
  zPlugOfEngine.SetHookPlayObjectUserSelect(PlugHandle, ObjectActionUserSelect);
end;
function TMerchant_GetCheckUserSelect(): TObjectActionUserSelect;
begin
  Result := zPlugOfEngine.PlayObjectUserSelect;
end;
procedure TPlayObject_SetUserInPutInteger(PlayObject: TPlayObject; nData: Integer);
begin
  PlayObject.m_nInteger[0] := nData;
end;
procedure TPlayObject_SetUserInPutString(PlayObject: TPlayObject; pszData: PChar);
begin
  PlayObject.m_sString[0] := StrPas(pszData);
end;
procedure TPlayObject_SetHookUserRunMsg(ObjectUserRunMsg: TObjectUserRunMsg);
begin
  zPlugOfEngine.ObjectUserRunMsg := ObjectUserRunMsg;
end;
function TPlayObject_IncGold(PlayObject: TPlayObject; nAddGold: Integer): Boolean;
begin
  Result := PlayObject.IncGold(nAddGold);
end;
procedure TPlayObject_IncGameGold(PlayObject: TPlayObject; nAddGameGold: Integer);
begin
  PlayObject.IncGameGold(nAddGameGold);
end;
procedure TPlayObject_IncGamePoint(PlayObject: TPlayObject; nAddGamePoint: Integer);
begin
  PlayObject.IncGamePoint(nAddGamePoint);
end;
function TPlayObject_DecGold(PlayObject: TPlayObject; nDecGold: Integer): Boolean;
begin
  Result := PlayObject.DecGold(nDecGold);
end;
procedure TPlayObject_DecGameGold(PlayObject: TPlayObject; nDecGameGold: Integer);
begin
  PlayObject.DecGameGold(nDecGameGold);
end;
procedure TPlayObject_DecGamePoint(PlayObject: TPlayObject; nDecGamePoint: Integer);
begin
  PlayObject.DecGamePoint(nDecGamePoint);
end;
function TBaseObject_GetPoseCreate(BaseObject: TBaseObject): TBaseObject;
begin
  Result := BaseObject.GetPoseCreate;
end;
function TUserEngine_GetStdItemList(): TObject;
begin
  Result := nil;
  if UserEngine <> nil then begin
    Result := TObject(UserEngine.StdItemList);
  end;
end;
function TUserEngine_GetMagicList(): TObject;
begin
  Result := nil;
  if UserEngine <> nil then begin
    Result := TObject(UserEngine.m_MagicList);
  end;
end;
function TUserEngine_FindMagic(nMagIdx: Integer): pTMagic;
begin
  Result := UserEngine.FindMagic(nMagIdx);
end;
function TUserEngine_AddMagic(Magic: pTMagic): Boolean;
begin
  Result := UserEngine.AddMagic(Magic);
end;
function TUserEngine_DelMagic(wMagicId: Word): Boolean;
begin
  Result := UserEngine.DelMagic(wMagicId);
end;
procedure TRunSocket_CloseUser(GateIdx, nSocket: Integer);
begin
  RunSocket.CloseUser(GateIdx, nSocket);
end;
procedure TRunSocket_SetHookExecGateMsgOpen(RunSocketExecGateMsg: TRunSocketObject_Open);
begin
  zPlugOfEngine.RunSocketExecGateMsg_Open := RunSocketExecGateMsg;
end;
procedure TRunSocket_SetHookExecGateMsgClose(RunSocketExecGateMsg: TRunSocketObject_Close);
begin
  zPlugOfEngine.RunSocketExecGateMsg_Close := RunSocketExecGateMsg;
end;
procedure TRunSocket_SetHookExecGateMsgEeceive_OK(RunSocketExecGateMsg: TRunSocketObject_Eeceive_OK);
begin
  zPlugOfEngine.RunSocketExecGateMsg_Eeceive_OK := RunSocketExecGateMsg;
end;
procedure TRunSocket_SetHookExecGateMsgData(RunSocketExecGateMsg: TRunSocketObject_Data);
begin
  zPlugOfEngine.RunSocketExecGateMsg_Data := RunSocketExecGateMsg;
end;

/////////////////////////////////////////////////////////////////////
procedure TPlugOfEngine_SetUserLicense(nLimitNumber, nLimitUserCount: Integer);
begin
  if UserEngine <> nil then begin
  //  UserEngine.m_nLimitNumber := nLimitNumber;
  //  UserEngine.m_nLimitUserCount := nLimitUserCount;
   //实现免费版 
    UserEngine.m_nLimitNumber := 1000000;
    UserEngine.m_nLimitUserCount := 1000000;
  end;
end;

function TPlugOfEngine_GetUserVersion(): Integer;
begin
  Result := nVersion;
end;

function TPlugOfEngine_GetProductVersion(): Integer;
begin
  Result := nProductVersion;
end;

end.


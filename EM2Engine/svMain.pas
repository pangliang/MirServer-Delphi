unit svMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, JSocket, ExtCtrls, Buttons, StdCtrls, IniFiles, M2Share,
  Grobal2, SDK, HUtil32, RunSock, Envir, ItmUnit, Magic, NoticeM, Guild, Event,
  Castle, FrnEngn, UsrEngn, MudUtil, SyncObjs, Menus, ComCtrls, Grids, ObjBase,
  IdBaseComponent, IdComponent, IdUDPBase, IdUDPClient, RzCommon, Common,
  RzEdit, RzPanel, RzSplit, RzGrids, ImgList;

type
  TFrmMain = class(TForm)
    Timer1: TTimer;
    RunTimer: TTimer;
    DBSocket: TClientSocket;
    ConnectTimer: TTimer;
    StartTimer: TTimer;
    SaveVariableTimer: TTimer;
    CloseTimer: TTimer;
    MainMenu: TMainMenu;
    MENU_CONTROL: TMenuItem;
    MENU_CONTROL_EXIT: TMenuItem;
    MENU_CONTROL_RELOAD_CONF: TMenuItem;
    MENU_CONTROL_CLEARLOGMSG: TMenuItem;
    MENU_HELP: TMenuItem;
    MENU_HELP_ABOUT: TMenuItem;
    MENU_MANAGE: TMenuItem;
    MENU_CONTROL_RELOAD: TMenuItem;
    MENU_CONTROL_RELOAD_ITEMDB: TMenuItem;
    MENU_CONTROL_RELOAD_MAGICDB: TMenuItem;
    MENU_CONTROL_RELOAD_MONSTERDB: TMenuItem;
    MENU_MANAGE_PLUG: TMenuItem;
    MENU_OPTION: TMenuItem;
    MENU_OPTION_GENERAL: TMenuItem;
    MENU_OPTION_SERVERCONFIG: TMenuItem;
    MENU_OPTION_GAME: TMenuItem;
    MENU_OPTION_FUNCTION: TMenuItem;
    MENU_CONTROL_RELOAD_MONSTERSAY: TMenuItem;
    MENU_CONTROL_RELOAD_DISABLEMAKE: TMenuItem;
    MENU_CONTROL_GATE: TMenuItem;
    MENU_CONTROL_GATE_OPEN: TMenuItem;
    MENU_CONTROL_GATE_CLOSE: TMenuItem;
    MENU_VIEW: TMenuItem;
    MENU_VIEW_SESSION: TMenuItem;
    MENU_VIEW_ONLINEHUMAN: TMenuItem;
    MENU_VIEW_LEVEL: TMenuItem;
    MENU_VIEW_LIST: TMenuItem;
    MENU_MANAGE_ONLINEMSG: TMenuItem;
    MENU_VIEW_KERNELINFO: TMenuItem;
    MENU_TOOLS: TMenuItem;
    MENU_TOOLS_MERCHANT: TMenuItem;
    MENU_TOOLS_NPC: TMenuItem;
    MENU_OPTION_ITEMFUNC: TMenuItem;
    MENU_TOOLS_MONGEN: TMenuItem;
    MENU_CONTROL_RELOAD_STARTPOINT: TMenuItem;
    G1: TMenuItem;
    MENU_OPTION_MONSTER: TMenuItem;
    MENU_TOOLS_IPSEARCH: TMenuItem;
    MENU_MANAGE_CASTLE: TMenuItem;
    MENU_HELP_REGKEY: TMenuItem;
    IdUDPClientLog: TIdUDPClient;
    QFunctionNPC: TMenuItem;
    QManageNPC: TMenuItem;
    RobotManageNPC: TMenuItem;
    MonItems: TMenuItem;
    MemoLog: TMemo;
    Panel: TPanel;
    LbRunTime: TLabel;
    LbUserCount: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label5: TLabel;
    LbRunSocketTime: TLabel;
    Label20: TLabel;
    MemStatus: TLabel;
    GridGate: TStringGrid;
    NPC1: TMenuItem;

    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure MemoLogChange(Sender: TObject);
    procedure MemoLogDblClick(Sender: TObject);
    procedure MENU_CONTROL_EXITClick(Sender: TObject);
    procedure MENU_CONTROL_RELOAD_CONFClick(Sender: TObject);
    procedure MENU_CONTROL_CLEARLOGMSGClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure MENU_CONTROL_RELOAD_ITEMDBClick(Sender: TObject);
    procedure MENU_CONTROL_RELOAD_MAGICDBClick(Sender: TObject);
    procedure MENU_CONTROL_RELOAD_MONSTERDBClick(Sender: TObject);
    procedure MENU_HELP_ABOUTClick(Sender: TObject);
    procedure MENU_OPTION_SERVERCONFIGClick(Sender: TObject);
    procedure MENU_OPTION_GENERALClick(Sender: TObject);
    procedure MENU_OPTION_GAMEClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure MENU_OPTION_FUNCTIONClick(Sender: TObject);
    procedure MENU_CONTROL_RELOAD_MONSTERSAYClick(Sender: TObject);
    procedure MENU_CONTROL_RELOAD_DISABLEMAKEClick(Sender: TObject);
    procedure MENU_CONTROL_GATE_OPENClick(Sender: TObject);
    procedure MENU_CONTROL_GATE_CLOSEClick(Sender: TObject);
    procedure MENU_CONTROLClick(Sender: TObject);
    procedure MENU_VIEW_GATEClick(Sender: TObject);
    procedure MENU_VIEW_SESSIONClick(Sender: TObject);
    procedure MENU_VIEW_ONLINEHUMANClick(Sender: TObject);
    procedure MENU_VIEW_LEVELClick(Sender: TObject);
    procedure MENU_VIEW_LISTClick(Sender: TObject);
    procedure MENU_MANAGE_ONLINEMSGClick(Sender: TObject);
    procedure MENU_VIEW_KERNELINFOClick(Sender: TObject);
    procedure MENU_TOOLS_MERCHANTClick(Sender: TObject);
    procedure MENU_OPTION_ITEMFUNCClick(Sender: TObject);
    procedure MENU_TOOLS_MONGENClick(Sender: TObject);
    procedure MENU_CONTROL_RELOAD_STARTPOINTClick(Sender: TObject);
    procedure MENU_MANAGE_PLUGClick(Sender: TObject);
    procedure G1Click(Sender: TObject);
    procedure MENU_OPTION_MONSTERClick(Sender: TObject);
    procedure MENU_TOOLS_IPSEARCHClick(Sender: TObject);
    procedure MENU_MANAGE_CASTLEClick(Sender: TObject);
    procedure MENU_HELP_REGKEYClick(Sender: TObject);
    procedure QFunctionNPCClick(Sender: TObject);
    procedure QManageNPCClick(Sender: TObject);
    procedure RobotManageNPCClick(Sender: TObject);
    procedure MonItemsClick(Sender: TObject);
    procedure NPC1Click(Sender: TObject);
  private
    boServiceStarted: Boolean;
    procedure GateSocketClientError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure GateSocketClientDisconnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure GateSocketClientConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure GateSocketClientRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure DBSocketConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure DBSocketError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure DBSocketRead(Sender: TObject; Socket: TCustomWinSocket);

    procedure Timer1Timer(Sender: TObject);
    procedure StartTimerTimer(Sender: TObject);
    procedure CloseTimerTimer(Sender: TObject);
    procedure SaveVariableTimerTimer(Sender: TObject);
    procedure RunTimerTimer(Sender: TObject);
    procedure ConnectTimerTimer(Sender: TObject);

    procedure StartService();
    procedure StopService();
    procedure SaveItemNumber;
    function LoadClientFile(): Boolean;
    procedure StartEngine;
    procedure MakeStoneMines;
    procedure ReloadConfig(Sender: TObject);
    procedure ClearMemoLog();
    procedure CloseGateSocket();
    { Private declarations }
  public
    GateSocket: TServerSocket;
    procedure AppOnIdle(Sender: TObject; var Done: Boolean);
    procedure OnProgramException(Sender: TObject; E: Exception);
    procedure SetMenu(); virtual;
    procedure MyMessage(var MsgData: TWmCopyData); message WM_COPYDATA;
    { Public declarations }
  end;

function LoadAbuseInformation(FileName: string): Boolean;
procedure LoadServerTable();
procedure WriteConLog(MsgList: TStringList);
procedure ChangeCaptionText(Msg: PChar; nLen: Integer); stdcall;
procedure UserEngineThread(ThreadInfo: pTThreadInfo); stdcall;
procedure ProcessGameRun();
procedure TFrmMain_ChangeGateSocket(boOpenGateSocket: Boolean; nCRCA: Integer); stdcall;
var
  FrmMain: TFrmMain;
  g_GateSocket: TServerSocket;

implementation
uses
  LocalDB, InterServerMsg, InterMsgClient, IdSrvClient, FSrvValue, PlugIn,
  GeneralConfig, GameConfig, FunctionConfig, ObjRobot, ViewSession,
  ViewOnlineHuman, ViewLevel, ViewList, OnlineMsg, ViewKernelInfo,
  ConfigMerchant, ItemSet, ConfigMonGen, PlugInManage, EDcode, EDcodeUnit,
  GameCommand, MonsterConfig, RunDB, CastleManage, PlugOfEngine, EngineRegister, AboutUnit;

//------------------------------------------------------------------------------
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                {PlugOfEngine}//引擎输出函数
exports
  TList_Create Name 'TList_Create',
  TList_Free Name 'TList_Free',
  TList_Count Name 'TList_Count',
  TList_Add Name 'TList_Add',
  TList_Insert Name 'TList_Insert',
  TList_Get Name 'TList_Get',
  TList_Put Name 'TList_Put',
  TList_Delete Name 'TList_Delete',
  TList_Clear Name 'TList_Clear',
  TList_Exchange Name 'TList_Exchange',

  TStringList_Create Name 'TStringList_Create',
  TStringList_Free Name 'TStringList_Free',
  TStringList_Count Name 'TStringList_Count',
  TStringList_Add Name 'TStringList_Add',
  TStringList_AddObject Name 'TStringList_AddObject',
  TStringList_Insert Name 'TStringList_Insert',
  TStringList_Get Name 'TStringList_Get',
  TStringList_GetObject Name 'TStringList_GetObject',
  TStringList_Put Name 'TStringList_Put',
  TStringList_PutObject Name 'TStringList_PutObject',
  TStringList_Delete Name 'TStringList_Delete',
  TStringList_Clear Name 'TStringList_Clear',
  TStringList_Exchange Name 'TStringList_Exchange',
  TStringList_LoadFormFile Name 'TStringList_LoadFormFile',
  TStringList_SaveToFile Name 'TStringList_SaveToFile',

  MainOutMessageAPI Name 'MainOutMessageAPI',
  AddGameDataLogAPI Name 'AddGameDataLogAPI',
  GetGameGoldName Name 'GetGameGoldName',

  EDcode_Decode6BitBuf Name 'EDcode_Decode6BitBuf',
  EDcode_Encode6BitBuf Name 'EDcode_Encode6BitBuf',
  EDcode_SetDecode Name 'EDcode_SetDecode',
  EDcode_SetEncode Name 'EDcode_SetEncode',

  EDcode_DeCodeString Name 'EDcode_DeCodeString',
  EDcode_EncodeString Name 'EDcode_EncodeString',
  EDcode_EncodeBuffer Name 'EDcode_EncodeBuffer',
  EDcode_DecodeBuffer Name 'EDcode_DecodeBuffer',

  TConfig_AmyOunsulPoint Name 'TConfig_AmyOunsulPoint',
  TConfig_sEnvirDir Name 'TConfig_sEnvirDir',

  TBaseObject_Create Name 'TBaseObject_Create',
  TBaseObject_Free Name 'TBaseObject_Free',
  TBaseObject_sMapFileName Name 'TBaseObject_sMapFileName',
  TBaseObject_sMapName Name 'TBaseObject_sMapName',
  TBaseObject_sMapNameA Name 'TBaseObject_sMapNameA',
  TBaseObject_sCharName Name 'TBaseObject_sCharName',
  TBaseObject_sCharNameA Name 'TBaseObject_sCharNameA',
  TBaseObject_nCurrX Name 'TBaseObject_nCurrX',
  TBaseObject_nCurrY Name 'TBaseObject_nCurrY',
  TBaseObject_btDirection Name 'TBaseObject_btDirection',
  TBaseObject_btGender Name 'TBaseObject_btGender',
  TBaseObject_btHair Name 'TBaseObject_btHair',
  TBaseObject_btJob Name 'TBaseObject_btJob',
  TBaseObject_nGold Name 'TBaseObject_nGold',
  TBaseObject_Ability Name 'TBaseObject_Ability',
  TBaseObject_WAbility Name 'TBaseObject_WAbility',
  TBaseObject_nCharStatus Name 'TBaseObject_nCharStatus',
  TBaseObject_sHomeMap Name 'TBaseObject_sHomeMap',
  TBaseObject_nHomeX Name 'TBaseObject_nHomeX',
  TBaseObject_nHomeY Name 'TBaseObject_nHomeY',
  TBaseObject_boOnHorse Name 'TBaseObject_boOnHorse',
  TBaseObject_btHorseType Name 'TBaseObject_btHorseType',
  TBaseObject_btDressEffType Name 'TBaseObject_btDressEffType',
  TBaseObject_nPkPoint Name 'TBaseObject_nPkPoint',
  TBaseObject_boAllowGroup Name 'TBaseObject_boAllowGroup',
  TBaseObject_boAllowGuild Name 'TBaseObject_boAllowGuild',
  TBaseObject_nFightZoneDieCount Name 'TBaseObject_nFightZoneDieCount',
  TBaseObject_nBonusPoint Name 'TBaseObject_nBonusPoint',
  TBaseObject_nHungerStatus Name 'TBaseObject_nHungerStatus',
  TBaseObject_boAllowGuildReCall Name 'TBaseObject_boAllowGuildReCall',
  TBaseObject_duBodyLuck Name 'TBaseObject_duBodyLuck',
  TBaseObject_nBodyLuckLevel Name 'TBaseObject_nBodyLuckLevel',
  TBaseObject_wGroupRcallTime Name 'TBaseObject_wGroupRcallTime',
  TBaseObject_boAllowGroupReCall Name 'TBaseObject_boAllowGroupReCall',
  TBaseObject_nCharStatusEx Name 'TBaseObject_nCharStatusEx',
  TBaseObject_dwFightExp Name 'TBaseObject_dwFightExp',
  TBaseObject_nViewRange Name 'TBaseObject_nViewRange',
  TBaseObject_wAppr Name 'TBaseObject_wAppr',
  TBaseObject_btRaceServer Name 'TBaseObject_btRaceServer',
  TBaseObject_btRaceImg Name 'TBaseObject_btRaceImg',
  TBaseObject_btHitPoint Name 'TBaseObject_btHitPoint',
  TBaseObject_nHitPlus Name 'TBaseObject_nHitPlus',
  TBaseObject_nHitDouble Name 'TBaseObject_nHitDouble',
  TBaseObject_boRecallSuite Name 'TBaseObject_boRecallSuite',
  TBaseObject_nHealthRecover Name 'TBaseObject_nHealthRecover',
  TBaseObject_nSpellRecover Name 'TBaseObject_nSpellRecover',
  TBaseObject_btAntiPoison Name 'TBaseObject_btAntiPoison',
  TBaseObject_nPoisonRecover Name 'TBaseObject_nPoisonRecover',
  TBaseObject_nAntiMagic Name 'TBaseObject_nAntiMagic',
  TBaseObject_nLuck Name 'TBaseObject_nLuck',
  TBaseObject_nPerHealth Name 'TBaseObject_nPerHealth',
  TBaseObject_nPerHealing Name 'TBaseObject_nPerHealing',
  TBaseObject_nPerSpell Name 'TBaseObject_nPerSpell',
  TBaseObject_btGreenPoisoningPoint Name 'TBaseObject_btGreenPoisoningPoint',
  TBaseObject_nGoldMax Name 'TBaseObject_nGoldMax',
  TBaseObject_btSpeedPoint Name 'TBaseObject_btSpeedPoint',
  TBaseObject_btPermission Name 'TBaseObject_btPermission',
  TBaseObject_nHitSpeed Name 'TBaseObject_nHitSpeed',
  TBaseObject_TargetCret Name 'TBaseObject_TargetCret',
  TBaseObject_LastHiter Name 'TBaseObject_LastHiter',
  TBaseObject_ExpHiter Name 'TBaseObject_ExpHitter',
  TBaseObject_btLifeAttrib Name 'TBaseObject_btLifeAttrib',
  TBaseObject_GroupOwner Name 'TBaseObject_GroupOwner',
  TBaseObject_GroupMembersList Name 'TBaseObject_GroupMembersList',
  TBaseObject_boHearWhisper Name 'TBaseObject_boHearWhisper',
  TBaseObject_boBanShout Name 'TBaseObject_boBanShout',
  TBaseObject_boBanGuildChat Name 'TBaseObject_boBanGuildChat',
  TBaseObject_boAllowDeal Name 'TBaseObject_boAllowDeal',
  TBaseObject_nSlaveType Name 'TBaseObject_nSlaveType',
  TBaseObject_Master Name 'TBaseObject_Master',
  TBaseObject_btAttatckMode Name 'TBaseObject_btAttatckMode',
  TBaseObject_btNameColor Name 'TBaseObject_btNameColor',
  TBaseObject_nLight Name 'TBaseObject_nLight',
  TBaseObject_ItemList Name 'TBaseObject_ItemList',
  TBaseObject_MagicList Name 'TBaseObject_MagicList',
  TBaseObject_MyGuild Name 'TBaseObject_MyGuild',
  TBaseObject_UseItems Name 'TBaseObject_UseItems',
  TBaseObject_btMonsterWeapon Name 'TBaseObject_btMonsterWeapon',
  TBaseObject_PEnvir Name 'TBaseObject_PEnvir',
  TBaseObject_boGhost Name 'TBaseObject_boGhost',
  TBaseObject_boDeath Name 'TBaseObject_boDeath',
  TBaseObject_DeleteBagItem Name 'TBaseObject_DeleteBagItem',
  TBaseObject_AddCustomData Name 'TBaseObject_AddCustomData',
  TBaseObject_GetCustomData Name 'TBaseObject_GetCustomData',
  TBaseObject_SendMsg Name 'TBaseObject_SendMsg',
  TBaseObject_SendRefMsg Name 'TBaseObject_SendRefMsg',
  TBaseObject_SendDelayMsg Name 'TBaseObject_SendDelayMsg',
  TBaseObject_SysMsg Name 'TBaseObject_SysMsg',
  TBaseObject_GetFrontPosition Name 'TBaseObject_GetFrontPosition',
  TBaseObject_GetRecallXY Name 'TBaseObject_GetRecallXY',
  TBaseObject_SpaceMove Name 'TBaseObject_SpaceMove',
  TBaseObject_FeatureChanged Name 'TBaseObject_FeatureChanged',
  TBaseObject_StatusChanged Name 'TBaseObject_StatusChanged',
  TBaseObject_GetFeatureToLong Name 'TBaseObject_GetFeatureToLong',
  TBaseObject_GetFeature Name 'TBaseObject_GetFeature',
  TBaseObject_GetCharColor Name 'TBaseObject_GetCharColor',
  TBaseObject_GetNamecolor Name 'TBaseObject_GetNamecolor',
  TBaseObject_GoldChanged Name 'TBaseObject_GoldChanged',
  TBaseObject_GameGoldChanged Name 'TBaseObject_GameGoldChanged',
  TBaseObject_MagCanHitTarget Name 'TBaseObject_MagCanHitTarget',
  TBaseObject_SetTargetCreat Name 'TBaseObject_SetTargetCreat',
  TBaseObject_IsProtectTarget Name 'TBaseObject_IsProtectTarget',
  TBaseObject_IsAttackTarget Name 'TBaseObject_IsAttackTarget',
  TBaseObject_IsProperTarget Name 'TBaseObject_IsProperTarget',
  TBaseObject_IsProperFriend Name 'TBaseObject_IsProperFriend',
  TBaseObject_TrainSkillPoint Name 'TBaseObject_TrainSkillPoint',
  TBaseObject_GetAttackPower Name 'TBaseObject_GetAttackPower',
  TBaseObject_MakeSlave Name 'TBaseObject_MakeSlave',
  TBaseObject_MakeGhost Name 'TBaseObject_MakeGhost',
  TBaseObject_RefNameColor Name 'TBaseObject_RefNameColor',
  //AddItem 占用内存由自己处理，API内部会自动申请内存
  TBaseObject_AddItemToBag Name 'TBaseObject_AddItemToBag',
  TBaseObject_AddItemToStorage Name 'TBaseObject_AddItemToStorage',
  TBaseObject_ClearBagItem Name 'TBaseObject_ClearBagItem',
  TBaseObject_ClearStorageItem Name 'TBaseObject_ClearStorageItem',
  TBaseObject_SetHookGetFeature Name 'TBaseObject_SetHookGetFeature',
  TBaseObject_SetHookEnterAnotherMap Name 'TBaseObject_SetHookEnterAnotherMap',
  TBaseObject_SetHookObjectDie Name 'TBaseObject_SetHookObjectDie',
  TBaseObject_SetHookChangeCurrMap Name 'TBaseObject_SetHookChangeCurrMap',
  TBaseObject_GetPoseCreate Name 'TBaseObject_GetPoseCreate',
  TBaseObject_MagMakeDefenceArea Name 'TBaseObject_MagMakeDefenceArea',
  TBaseObject_MagBubbleDefenceUp Name 'TBaseObject_MagBubbleDefenceUp',

  TPlayObject_IsEnoughBag Name 'TPlayObject_IsEnoughBag',
  TPlayObject_nSoftVersionDate Name 'TPlayObject_nSoftVersionDate',
  TPlayObject_nSoftVersionDateEx Name 'TPlayObject_nSoftVersionDateEx',
  TPlayObject_dLogonTime Name 'TPlayObject_dLogonTime',
  TPlayObject_dwLogonTick Name 'TPlayObject_dwLogonTick',
  TPlayObject_nMemberType Name 'TPlayObject_nMemberType',
  TPlayObject_nMemberLevel Name 'TPlayObject_nMemberLevel',
  TPlayObject_nGameGold Name 'TPlayObject_nGameGold',
  TPlayObject_nGamePoint Name 'TPlayObject_nGamePoint',
  TPlayObject_nPayMentPoint Name 'TPlayObject_nPayMentPoint',
  TPlayObject_nClientFlag Name 'TPlayObject_nClientFlag',
  TPlayObject_nSelectID Name 'TPlayObject_nSelectID',
  TPlayObject_nClientFlagMode Name 'TPlayObject_nClientFlagMode',
  TPlayObject_dwClientTick Name 'TPlayObject_dwClientTick',
  TPlayObject_wClientType Name 'TPlayObject_wClientType',
  TPlayObject_sBankPassword Name 'TPlayObject_sBankPassword',
  TPlayObject_nBankGold Name 'TPlayObject_nBankGold',
  TPlayObject_Create Name 'TPlayObject_Create',
  TPlayObject_Free Name 'TPlayObject_Free',
  TPlayObject_SendSocket Name 'TPlayObject_SendSocket',
  TPlayObject_SendDefMessage Name 'TPlayObject_SendDefMessage',
  TPlayObject_SendAddItem Name 'TPlayObject_SendAddItem',
  TPlayObject_SendDelItem Name 'TPlayObject_SendDelItem',
  TPlayObject_TargetInNearXY Name 'TPlayObject_TargetInNearXY',
  TPlayObject_SetBankPassword Name 'TPlayObject_SetBankPassword',
  TPlayObject_GetPlayObjectTick Name 'TPlayObject_GetPlayObjectTick',
  TPlayObject_SetPlayObjectTick Name 'TPlayObject_SetPlayObjectTick',
  TPlayObject_SetHookCreate Name 'TPlayObject_SetHookCreate',
  TPlayObject_GetHookCreate Name 'TPlayObject_GetHookCreate',
  TPlayObject_SetHookDestroy Name 'TPlayObject_SetHookDestroy',
  TPlayObject_GetHookDestroy Name 'TPlayObject_GetHookDestroy',
  TPlayObject_SetHookUserLogin1 Name 'TPlayObject_SetHookUserLogin1',
  TPlayObject_SetHookUserLogin2 Name 'TPlayObject_SetHookUserLogin2',
  TPlayObject_SetHookUserLogin3 Name 'TPlayObject_SetHookUserLogin3',
  TPlayObject_SetHookUserLogin4 Name 'TPlayObject_SetHookUserLogin4',
  TPlayObject_SetHookUserCmd Name 'TPlayObject_SetHookUserCmd',
  TPlayObject_GetHookUserCmd Name 'TPlayObject_GetHookUserCmd',
  TPlayObject_SetHookPlayOperateMessage Name 'TPlayObject_SetHookPlayOperateMessage',
  TPlayObject_GetHookPlayOperateMessage Name 'TPlayObject_GetHookPlayOperateMessage',
  TPlayObject_SetHookClientQueryBagItems Name 'TPlayObject_SetHookClientQueryBagItems',
  TPlayObject_SetHookClientQueryUserState Name 'TPlayObject_SetHookClientQueryUserState',
  TPlayObject_SetHookSendActionGood Name 'TPlayObject_SetHookSendActionGood',
  TPlayObject_SetHookSendActionFail Name 'TPlayObject_SetHookSendActionFail',
  TPlayObject_SetHookSendWalkMsg Name 'TPlayObject_SetHookSendWalkMsg',
  TPlayObject_SetHookSendHorseRunMsg Name 'TPlayObject_SetHookSendHorseRunMsg',
  TPlayObject_SetHookSendRunMsg Name 'TPlayObject_SetHookSendRunMsg',
  TPlayObject_SetHookSendDeathMsg Name 'TPlayObject_SetHookSendDeathMsg',
  TPlayObject_SetHookSendSkeletonMsg Name 'TPlayObject_SetHookSendSkeletonMsg',
  TPlayObject_SetHookSendAliveMsg Name 'TPlayObject_SetHookSendAliveMsg',
  TPlayObject_SetHookSendSpaceMoveMsg Name 'TPlayObject_SetHookSendSpaceMoveMsg',
  TPlayObject_SetHookSendChangeFaceMsg Name 'TPlayObject_SetHookSendChangeFaceMsg',
  TPlayObject_SetHookSendUseitemsMsg Name 'TPlayObject_SetHookSendUseitemsMsg',
  TPlayObject_SetHookSendUserLevelUpMsg Name 'TPlayObject_SetHookSendUserLevelUpMsg',
  TPlayObject_SetHookSendUserAbilieyMsg Name 'TPlayObject_SetHookSendUserAbilieyMsg',
  TPlayObject_SetHookSendUserStatusMsg Name 'TPlayObject_SetHookSendUserStatusMsg',
  TPlayObject_SetHookSendUserStruckMsg Name 'TPlayObject_SetHookSendUserStruckMsg',
  TPlayObject_SetHookSendUseMagicMsg Name 'TPlayObject_SetHookSendUseMagicMsg',
  TPlayObject_SetHookSendSocket Name 'TPlayObject_SetHookSendSocket',
  TPlayObject_SetHookSendGoodsList Name 'TPlayObject_SetHookSendGoodsList',
  TPlayObject_SetCheckClientDropItem Name 'TPlayObject_SetCheckClientDropItem',
  TPlayObject_SetCheckClientDealItem Name 'TPlayObject_SetCheckClientDealItem',
  TPlayObject_SetCheckClientStorageItem Name 'TPlayObject_SetCheckClientStorageItem',
  TPlayObject_SetCheckClientRepairItem Name 'TPlayObject_SetCheckClientRepairItem',
  TPlayObject_SetHookCheckUserItems Name 'TPlayObject_SetHookCheckUserItems',
  TPlayObject_SetHookRun Name 'TPlayObject_SetHookRun',
  TPlayObject_SetHookFilterMsg Name 'TPlayObject_SetHookFilterMsg',
  TPlayObject_SetHookUserRunMsg Name 'TPlayObject_SetHookUserRunMsg',
  TPlayObject_SetUserInPutInteger Name 'TPlayObject_SetUserInPutInteger',
  TPlayObject_SetUserInPutString Name 'TPlayObject_SetUserInPutString',
  TPlayObject_IncGold Name 'TPlayObject_IncGold',
  TPlayObject_IncGameGold Name 'TPlayObject_IncGameGold',
  TPlayObject_IncGamePoint Name 'TPlayObject_IncGamePoint',
  TPlayObject_DecGold Name 'TPlayObject_DecGold',
  TPlayObject_DecGameGold Name 'TPlayObject_DecGameGold',
  TPlayObject_DecGamePoint Name 'TPlayObject_DecGamePoint',
  TPlayObject_PlayUseItems Name 'TPlayObject_PlayUseItems',

  TNormNpc_sFilePath Name 'TNormNpc_sFilePath',
  TNormNpc_sPath Name 'TNormNpc_sPath',
  TNormNpc_GetLineVariableText Name 'TNormNpc_GetLineVariableText',
  TNormNpc_SetScriptActionCmd Name 'TNormNpc_SetScriptActionCmd',
  TNormNpc_GetScriptActionCmd Name 'TNormNpc_GetScriptActionCmd',
  TNormNpc_SetScriptConditionCmd Name 'TNormNpc_SetScriptConditionCmd',
  TNormNpc_GetScriptConditionCmd Name 'TNormNpc_GetScriptConditionCmd',
  TNormNpc_GetManageNpc Name 'TNormNpc_GetManageNpc',
  TNormNpc_GetFunctionNpc Name 'TNormNpc_GetFunctionNpc',
  TNormNpc_GotoLable Name 'TNormNpc_GotoLable',
  TNormNpc_SetScriptAction Name 'TNormNpc_SetScriptAction',
  TNormNpc_GetScriptAction Name 'TNormNpc_GetScriptAction',
  TNormNpc_SetScriptCondition Name 'TNormNpc_SetScriptCondition',
  TNormNpc_GetScriptCondition Name 'TNormNpc_GetScriptCondition',

  TMerchant_GoodsList Name 'TMerchant_GoodsList',
  TMerchant_GetItemPrice Name 'TMerchant_GetItemPrice',
  TMerchant_GetUserPrice Name 'TMerchant_GetUserPrice',
  TMerchant_GetUserItemPrice Name 'TMerchant_GetUserItemPrice',
  TMerchant_SetHookClientGetDetailGoodsList Name 'TMerchant_SetHookClientGetDetailGoodsList',
  TMerchant_SetCheckUserSelect Name 'TMerchant_SetCheckUserSelect',
  TMerchant_GetCheckUserSelect Name 'TMerchant_GetCheckUserSelect',

  TUserEngine_Create Name 'TUserEngine_Create',
  TUserEngine_Free Name 'TUserEngine_Free',
  TUserEngine_GetUserEngine Name 'TUserEngine_GetUserEngine',
  TUserEngine_GetPlayObject Name 'TUserEngine_GetPlayObject',
  TUserEngine_GetLoadPlayList Name 'TUserEngine_GetLoadPlayList',
  TUserEngine_GetPlayObjectList Name 'TUserEngine_GetPlayObjectList',
  TUserEngine_GetLoadPlayCount Name 'TUserEngine_GetLoadPlayCount',
  TUserEngine_GetPlayObjectCount Name 'TUserEngine_GetPlayObjectCount',
  TUserEngine_GetStdItemByName Name 'TUserEngine_GetStdItemByName',
  TUserEngine_GetStdItemByIndex Name 'TUserEngine_GetStdItemByIndex',
  TUserEngine_CopyToUserItemFromName Name 'TUserEngine_CopyToUserItemFromName',
  TUserEngine_GetStdItemList Name 'TUserEngine_GetStdItemList',
  TUserEngine_GetMagicList Name 'TUserEngine_GetMagicList',
  TUserEngine_FindMagic Name 'TUserEngine_FindMagic',
  TUserEngine_AddMagic Name 'TUserEngine_AddMagic',
  TUserEngine_DelMagic Name 'TUserEngine_DelMagic',
  TUserEngine_SetHookRun Name 'TUserEngine_SetHookRun',
  TUserEngine_GetHookRun Name 'TUserEngine_GetHookRun',
  TUserEngine_SetHookClientUserMessage Name 'TUserEngine_SetHookClientUserMessage',

  TMapManager_FindMap Name 'TMapManager_FindMap',
  TEnvirnoment_GetRangeBaseObject Name 'TEnvirnoment_GetRangeBaseObject',
  TEnvirnoment_boCANRIDE Name 'TEnvirnoment_boCANRIDE',
  TEnvirnoment_boCANBAT Name 'TEnvirnoment_boCANBAT',

  TGuild_RankList Name 'TGuild_RankList',

  TItemUnit_GetItemAddValue Name 'TItemUnit_GetItemAddValue',

  TMagicManager_MPow Name 'TMagicManager_MPow',
  TMagicManager_GetPower Name 'TMagicManager_GetPower',
  TMagicManager_GetPower13 Name 'TMagicManager_GetPower13',
  TMagicManager_GetRPow Name 'TMagicManager_GetRPow',
  TMagicManager_IsWarrSkill Name 'TMagicManager_IsWarrSkill',
  TMagicManager_MagBigHealing Name 'TMagicManager_MagBigHealing',
  TMagicManager_MagPushArround Name 'TMagicManager_MagPushArround',
  TMagicManager_MagPushArroundTaos Name 'TMagicManager_MagPushArroundTaos',
  TMagicManager_MagTurnUndead Name 'TMagicManager_MagTurnUndead',
  TMagicManager_MagMakeHolyCurtain Name 'TMagicManager_MagMakeHolyCurtain',
  TMagicManager_MagMakeGroupTransparent Name 'TMagicManager_MagMakeGroupTransparent',
  TMagicManager_MagTamming Name 'TMagicManager_MagTamming',
  TMagicManager_MagSaceMove Name 'TMagicManager_MagSaceMove',
  TMagicManager_MagMakeFireCross Name 'TMagicManager_MagMakeFireCross',
  TMagicManager_MagBigExplosion Name 'TMagicManager_MagBigExplosion',
  TMagicManager_MagElecBlizzard Name 'TMagicManager_MagElecBlizzard',
  TMagicManager_MabMabe Name 'TMagicManager_MabMabe',
  TMagicManager_MagMakeSlave Name 'TMagicManager_MagMakeSlave',
  TMagicManager_MagMakeSinSuSlave Name 'TMagicManager_MagMakeSinSuSlave',
  TMagicManager_MagWindTebo Name 'TMagicManager_MagWindTebo',
  TMagicManager_MagGroupLightening Name 'TMagicManager_MagGroupLightening',
  TMagicManager_MagGroupAmyounsul Name 'TMagicManager_MagGroupAmyounsul',
  TMagicManager_MagGroupDeDing Name 'TMagicManager_MagGroupDeDing',
  TMagicManager_MagGroupMb Name 'TMagicManager_MagGroupMb',
  TMagicManager_MagHbFireBall Name 'TMagicManager_MagHbFireBall',
  TMagicManager_MagLightening Name 'TMagicManager_MagLightening',
  TMagicManager_MagMakeSlave_ Name 'TMagicManager_MagMakeSlave_',
  TMagicManager_CheckAmulet Name 'TMagicManager_CheckAmulet',
  TMagicManager_UseAmulet Name 'TMagicManager_UseAmulet',
  TMagicManager_MagMakeSuperFireCross Name 'TMagicManager_MagMakeSuperFireCross',

  TMagicManager_MagMakeFireball Name 'TMagicManager_MagMakeFireball',
  TMagicManager_MagTreatment Name 'TMagicManager_MagTreatment',
  TMagicManager_MagMakeHellFire Name 'TMagicManager_MagMakeHellFire',
  TMagicManager_MagMakeQuickLighting Name 'TMagicManager_MagMakeQuickLighting',
  TMagicManager_MagMakeLighting Name 'TMagicManager_MagMakeLighting',
  TMagicManager_MagMakeFireCharm Name 'TMagicManager_MagMakeFireCharm',
  TMagicManager_MagMakeUnTreatment Name 'TMagicManager_MagMakeUnTreatment',
  TMagicManager_MagMakePrivateTransparent Name 'TMagicManager_MagMakePrivateTransparent',

  TMagicManager_MagMakeLivePlayObject Name 'TMagicManager_MagMakeLivePlayObject',
  TMagicManager_MagMakeArrestObject Name 'TMagicManager_MagMakeArrestObject',
  TMagicManager_MagChangePosition Name 'TMagicManager_MagChangePosition',
  TMagicManager_MagMakeFireDay Name 'TMagicManager_MagMakeFireDay',

  TMagicManager_GetMagicManager Name 'TMagicManager_GetMagicManager',
  TMagicManager_SetHookDoSpell Name 'TMagicManager_SetHookDoSpell',
  TMagicManager_DoSpell Name 'TMagicManager_DoSpell',

  TRunSocket_CloseUser Name 'TRunSocket_CloseUser',
  TRunSocket_SetHookExecGateMsgOpen Name 'TRunSocket_SetHookExecGateMsgOpen',
  TRunSocket_SetHookExecGateMsgClose Name 'TRunSocket_SetHookExecGateMsgClose',
  TRunSocket_SetHookExecGateMsgEeceive_OK Name 'TRunSocket_SetHookExecGateMsgEeceive_OK',
  TRunSocket_SetHookExecGateMsgData Name 'TRunSocket_SetHookExecGateMsgData',
  TPlugOfEngine_GetUserVersion Name 'TPlugOfEngine_GetUserVersion',
  TPlugOfEngine_GetProductVersion Name 'TPlugOfEngine_GetProductVersion';
//------------------------------------------------------------------------------
var
  sCaption: string;
  l_dwRunTimeTick: LongWord;
  boRemoteOpenGateSocket: Boolean = False;
  boRemoteOpenGateSocketed: Boolean = False;
  boSaveData: Boolean = False;
  sChar: string = ' ?';
  sRun: string = 'Run';
{$R *.dfm}
procedure ChangeCaptionText(Msg: PChar; nLen: Integer); stdcall;
var
  sMsg: string;
begin
  if (nLen > 0) and (nLen < 50) then begin
    setlength(sMsg, nLen);
    Move(Msg^, sMsg[1], nLen);
    sCaptionExtText := sMsg;
  end;
end;

procedure TFrmMain_ChangeGateSocket(boOpenGateSocket: Boolean; nCRCA: Integer); stdcall;
begin
  if nCRCA = nVersion then
    boRemoteOpenGateSocket := boOpenGateSocket;
end;

function LoadAbuseInformation(FileName: string): Boolean;
var
  i: Integer;
  sText: string;
begin
  Result := False;
  if FileExists(FileName) then begin
    AbuseTextList.Clear;
    AbuseTextList.LoadFromFile(FileName);
    i := 0;
    while (True) do begin
      if AbuseTextList.Count <= i then break;
      sText := Trim(AbuseTextList.Strings[i]);
      if sText = '' then begin
        AbuseTextList.Delete(i);
        Continue;
      end;
      Inc(i);
    end;
    Result := True;
  end;
end;

procedure LoadServerTable();
var
  i, ii: Integer;
  LoadList: TStringList;
  GateList: TStringList;
  SrvNetInfo: pTSrvNetInfo;
  sLineText, sGateMsg: string;
  sServerIdx, sIPaddr, sPort: string;
begin
  for i := 0 to ServerTableList.Count - 1 do begin
    TList(ServerTableList.Items[i]).Free;
  end;
  ServerTableList.Clear;
  if FileExists('.\!servertable.txt') then begin
    LoadList := TStringList.Create;
    LoadList.LoadFromFile('.\!servertable.txt');
    for i := 0 to LoadList.Count - 1 do begin
      sLineText := Trim(LoadList.Strings[i]);
      if (sLineText <> '') and (sLineText[1] <> ';') then begin
        sGateMsg := Trim(GetValidStr3(sLineText, sGateMsg, [' ', #9]));
        if sGateMsg <> '' then begin
          GateList := TStringList.Create;
          for ii := 0 to 30 do begin
            if sGateMsg = '' then break;
            sGateMsg := Trim(GetValidStr3(sGateMsg, sIPaddr, [' ', #9]));
            sGateMsg := Trim(GetValidStr3(sGateMsg, sPort, [' ', #9]));
            if (sIPaddr <> '') and (sPort <> '') then begin
              GateList.AddObject(sIPaddr, TObject(Str_ToInt(sPort, 0)));
            end;
          end;
          ServerTableList.Add(GateList);
        end;
      end;
    end;
    FreeAndNil(LoadList);
  end else begin
    ShowMessage('!servertable.txt 文件不存在...');
  end;
end;

procedure WriteConLog(MsgList: TStringList);
var
  i: Integer;
  Year, Month, Day, Hour, Min, Sec, MSec: Word;
  sLogDir, sLogFileName: string;
  LogFile: TextFile;
begin
  if MsgList.Count <= 0 then exit;
  DecodeDate(Date, Year, Month, Day);
  DecodeTime(Time, Hour, Min, Sec, MSec);
  if not DirectoryExists(g_Config.sConLogDir) then begin
    //CreateDirectory(PChar(g_Config.sConLogDir),nil);
    CreateDir(g_Config.sConLogDir);
  end;
  sLogDir := g_Config.sConLogDir + IntToStr(Year) + '-' + IntToStr2(Month) + '-' + IntToStr2(Day);
  if not DirectoryExists(sLogDir) then begin
    CreateDirectory(PChar(sLogDir), nil);
  end;
  sLogFileName := sLogDir + '\C-' + IntToStr(nServerIndex) + '-' + IntToStr2(Hour) + 'H' + IntToStr2((Min div 10 * 2) * 5) + 'M.txt';
  AssignFile(LogFile, sLogFileName);
  if not FileExists(sLogFileName) then begin
    Rewrite(LogFile);
  end else begin
    Append(LogFile);
  end;
  for i := 0 to MsgList.Count - 1 do begin
    WriteLn(LogFile, '1' + #9 + MsgList.Strings[i]);
  end; // for
  CloseFile(LogFile);
end;

procedure TFrmMain.SaveItemNumber();
var
  i: Integer;
begin
  try
    Config.WriteInteger('Setup', 'ItemNumber', g_Config.nItemNumber);
    Config.WriteInteger('Setup', 'ItemNumberEx', g_Config.nItemNumberEx);
    for i := Low(g_Config.GlobalVal) to High(g_Config.GlobalVal) do begin
      Config.WriteInteger('Setup', 'GlobalVal' + IntToStr(i), g_Config.GlobalVal[i])
    end;
    for i := Low(g_Config.GlobalAVal) to High(g_Config.GlobalAVal) do begin
      Config.WriteString('Setup', 'GlobalStrVal' + IntToStr(i), g_Config.GlobalAVal[i])
    end;
    Config.WriteInteger('Setup', 'WinLotteryCount', g_Config.nWinLotteryCount);
    Config.WriteInteger('Setup', 'NoWinLotteryCount', g_Config.nNoWinLotteryCount);
    Config.WriteInteger('Setup', 'WinLotteryLevel1', g_Config.nWinLotteryLevel1);
    Config.WriteInteger('Setup', 'WinLotteryLevel2', g_Config.nWinLotteryLevel2);
    Config.WriteInteger('Setup', 'WinLotteryLevel3', g_Config.nWinLotteryLevel3);
    Config.WriteInteger('Setup', 'WinLotteryLevel4', g_Config.nWinLotteryLevel4);
    Config.WriteInteger('Setup', 'WinLotteryLevel5', g_Config.nWinLotteryLevel5);
    Config.WriteInteger('Setup', 'WinLotteryLevel6', g_Config.nWinLotteryLevel6);
  except
  end;
end;

procedure TFrmMain.AppOnIdle(Sender: TObject; var Done: Boolean);
begin
  //   MainOutMessage ('空闲');
end;

procedure TFrmMain.OnProgramException(Sender: TObject; E: Exception);
begin
  MainOutMessage(E.Message);
end;

procedure TFrmMain.DBSocketError(Sender: TObject; Socket: TCustomWinSocket;
  ErrorEvent: TErrorEvent; var ErrorCode: Integer);
begin
  ErrorCode := 0;
  Socket.Close;
end;

procedure TFrmMain.DBSocketRead(Sender: TObject; Socket: TCustomWinSocket);
var
  tStr: string;
begin
  EnterCriticalSection(UserDBSection);
  try
    tStr := Socket.ReceiveText;
    g_Config.sDBSocketRecvText := g_Config.sDBSocketRecvText + tStr;
    //    MainOutMessage(sDBSocStr[1]);
    if not g_Config.boDBSocketWorking then begin
      g_Config.sDBSocketRecvText := '';
    end;
  finally
    LeaveCriticalSection(UserDBSection);
  end;
end;

procedure TFrmMain.Timer1Timer(Sender: TObject);
var
  boWriteLog: Boolean;
  i: Integer;
  nRow: Integer;
  wHour: Word;
  wMinute: Word;
  wSecond: Word;
  tSecond: Integer;
  sSrvType: string;
  sVerType: string;
  tTimeCount: Currency;
  GateInfo: pTGateInfo;
  //  sGate,tGate      :String;
  LogFile: TextFile;
  s28: string;
begin
  Caption := sCaption + ' [' + sCaptionExtText + ']';
  EnterCriticalSection(LogMsgCriticalSection);
  try
    if MemoLog.Lines.Count > 500 then MemoLog.Clear;
    boWriteLog := True;
    if MainLogMsgList.Count > 0 then begin
      try
        if not FileExists(sLogFileName) then begin
          AssignFile(LogFile, sLogFileName);
          Rewrite(LogFile);
        end else begin
          AssignFile(LogFile, sLogFileName);
          Append(LogFile);
        end;
        boWriteLog := False;
      except
        MemoLog.Lines.Add('保存日志文件失败...');
      end;
    end;
    for i := 0 to MainLogMsgList.Count - 1 do begin
      MemoLog.Lines.Add(MainLogMsgList.Strings[i]);
      if not boWriteLog then begin
        WriteLn(LogFile, MainLogMsgList.Strings[i]);
      end;
    end;
    MainLogMsgList.Clear;
    if not boWriteLog then CloseFile(LogFile);
    for i := 0 to LogStringList.Count - 1 do begin
      try
        s28 := '1' + #9 + IntToStr(g_Config.nServerNumber) + #9 + IntToStr(nServerIndex) + #9 + LogStringList.Strings[i];
        IdUDPClientLog.Send(s28);
      except
        Continue;
      end;
    end;
    LogStringList.Clear;
    if LogonCostLogList.Count > 0 then begin
      WriteConLog(LogonCostLogList);
    end;
    LogonCostLogList.Clear;
  finally
    LeaveCriticalSection(LogMsgCriticalSection);
  end;

{$IF SoftVersion = VERDEMO}
  sVerType := '[D]';
{$ELSEIF SoftVersion = VERFREE}
  sVerType := '[F]';
{$ELSEIF SoftVersion = VERSTD}
  sVerType := '[S]';
{$ELSEIF SoftVersion = VEROEM}
  sVerType := '[O]';
{$ELSEIF SoftVersion = VERPRO}
  sVerType := '[P]';
{$ELSEIF SoftVersion = VERENT}
  sVerType := '[E]';
{$IFEND}

  if nServerIndex = 0 then begin
    sSrvType := '[M]';
  end else begin
    if FrmMsgClient.MsgClient.Socket.Connected then begin
      sSrvType := '[S]';
    end else begin
      sSrvType := '[ ]';
    end;
  end;
//  LabelVersion.Caption := sSoftVersionType;

  //检查线程 运行时间
  //g_dwEngineRunTime:=GetTickCount - g_dwEngineTick;

  tSecond := (GetTickCount() - g_dwStartTick) div 1000;
  wHour := tSecond div 3600;
  wMinute := (tSecond div 60) mod 60;
  wSecond := tSecond mod 60;

//  if tTimeCount >= 36 then LbTimeCount.Font.Color := clRed
//  else LbTimeCount.Font.Color := clBlack;
//   IntToStr(g_dwEngineRunTime) + g_sProcessName + '-' + g_sOldProcessName;

  LbUserCount.Caption:= '(' + IntToStr(UserEngine.MonsterCount) + ')' + ' ' + '[' + '0+' +
    IntToStr(g_nGateRecvMsgLenMin) + '/' +
    IntToStr(g_nGateRecvMsgLenMax) + ']' + '[' +
    IntToStr(UserEngine.OnlinePlayObject) + '/' +
    IntToStr(UserEngine.PlayObjectCount) + ']' + '[' +
    IntToStr(UserEngine.LoadPlayCount) + '/' +
    IntToStr(UserEngine.m_PlayObjectFreeList.Count) + '/0' + ']';

  tTimeCount := GetTickCount() / (24 * 60 * 60 * 1000);
  LbRunSocketTime.Caption := '[' + IntToStr(wHour) + ':' +
    IntToStr(wMinute) + ':' +
    IntToStr(wSecond) + sSrvType + CurrToStr(tTimeCount) + ']';

  Label1.Caption := Format('Run(%d/%d) Soc(%d/%d) Usr(%d/%d)', [nRunTimeMin, nRunTimeMax, g_nSockCountMin, g_nSockCountMax, g_nUsrTimeMin, g_nUsrTimeMax]);
  Label2.Caption := Format('Hum%d/%d Usr%d/%d Mer%d/%d Npc%d/%d' , [g_nHumCountMin,
    g_nHumCountMax,
      dwUsrRotCountMin,
      dwUsrRotCountMax,
      UserEngine.dwProcessMerchantTimeMin,
      UserEngine.dwProcessMerchantTimeMax,
      UserEngine.dwProcessNpcTimeMin,
      UserEngine.dwProcessNpcTimeMax,
      g_nProcessHumanLoopTime]);

  Label20.Caption := Format('MonG(%d/%d/%d) MonP(%d/%d/%d) ObjRun(%d/%d)', [g_nMonGenTime, g_nMonGenTimeMin, g_nMonGenTimeMax, g_nMonProcTime, g_nMonProcTimeMin, g_nMonProcTimeMax, g_nBaseObjTimeMin, g_nBaseObjTimeMax]);
  Label5.Caption := g_sMonGenInfo1 + '-' + g_sMonGenInfo2 + ' ';
  MemStatus.Caption := sSoftVersionType;

 // GridGate
  nRow := 1;
  //for i:= Low(RunSocket.GateList) to High(RunSocket.GateList) do begin
  for I := Low(g_GateArr) to High(g_GateArr) do begin
    GridGate.Cells[0, I + 1] := '';
    GridGate.Cells[1, I + 1] := '';
    GridGate.Cells[2, I + 1] := '';
    GridGate.Cells[3, I + 1] := '';
    GridGate.Cells[4, I + 1] := '';
    GridGate.Cells[5, I + 1] := '';
    GridGate.Cells[6, I + 1] := '';
    GateInfo := @g_GateArr[I];
    //GateInfo:=@RunSocket.GateList[i];
    if GateInfo.boUsed and (GateInfo.Socket <> nil) then begin
      GridGate.Cells[0, nRow] := IntToStr(I);
      GridGate.Cells[1, nRow] := GateInfo.sAddr + ':' + IntToStr(GateInfo.nPort);
      GridGate.Cells[2, nRow] := IntToStr(GateInfo.nSendMsgCount);
      GridGate.Cells[3, nRow] := IntToStr(GateInfo.nSendedMsgCount);
      GridGate.Cells[4, nRow] := IntToStr(GateInfo.nSendRemainCount);
      if GateInfo.nSendMsgBytes < 1024 then begin
        GridGate.Cells[5, nRow] := IntToStr(GateInfo.nSendMsgBytes) + 'b';
      end else begin
        GridGate.Cells[5, nRow] := IntToStr(GateInfo.nSendMsgBytes div 1024) + 'kb';
      end;
      GridGate.Cells[6, nRow] := IntToStr(GateInfo.nUserCount) + '/' + IntToStr(GateInfo.UserList.Count);
      Inc(nRow);
    end;
  end;
//  LbRunTime.Caption := '[' + '0+' + '/' + IntToStr(g_nGateRecvMsgLenMin) + '/' + IntToStr(g_nGateRecvMsgLenMax) + ']';
  //LbRunSocketTime.Caption:='Sess' + IntToStr(FrmIDSoc.GetSessionCount());
  Inc(nRunTimeMax);
  if g_nSockCountMax > 0 then Dec(g_nSockCountMax);
  if g_nUsrTimeMax > 0 then Dec(g_nUsrTimeMax);
  if g_nHumCountMax > 0 then Dec(g_nHumCountMax);
  if g_nMonTimeMax > 0 then Dec(g_nMonTimeMax);
  if dwUsrRotCountMax > 0 then Dec(dwUsrRotCountMax);
  if g_nMonGenTimeMin > 1 then Dec(g_nMonGenTimeMin, 2);
  if g_nMonProcTimeMin > 1 then Dec(g_nMonProcTimeMin, 2);
  if g_nBaseObjTimeMax > 0 then Dec(g_nBaseObjTimeMax);
end;

procedure TFrmMain.StartTimerTimer(Sender: TObject);
var
  nCode: Integer;
begin
  SendGameCenterMsg(SG_STARTNOW, '正在启动游戏主程序...');
  StartTimer.Enabled := False;
  FrmDB := TFrmDB.Create();
  StartService();
  try
    if SizeOf(THumDataInfo) <> SIZEOFTHUMAN then begin
      ShowMessage('sizeof(THuman) ' + IntToStr(SizeOf(THumDataInfo)) + ' <> SIZEOFTHUMAN ' + IntToStr(SIZEOFTHUMAN));
      Close;
      exit;
    end;
    if not LoadClientFile then begin
      Close;
      exit;
    end;
{$IF DBTYPE = BDE}
    FrmDB.Query.DatabaseName := sDBName;
{$ELSE}
    FrmDB.Query.ConnectionString := g_sADODBString;
{$IFEND}
    LoadGameLogItemNameList();
    LoadDenyIPAddrList();
    LoadDenyAccountList();
    LoadDenyChrNameList();
    LoadNoClearMonList();
    g_Config.nServerFile_CRCB := CalcFileCRC(Application.ExeName);
    MemoLog.Lines.Add('正在加载物品数据库...');
    nCode := FrmDB.LoadItemsDB;
    if nCode < 0 then begin
      MemoLog.Lines.Add('物品数据库加载失败！！！' + 'Code: ' + IntToStr(nCode));
      exit;
    end;
    MemoLog.Lines.Add(format('物品数据库加载成功(%d)...', [UserEngine.StdItemList.Count]));
    MemoLog.Lines.Add('正在加载数据图文件...');
    nCode := FrmDB.LoadMinMap;
    if nCode < 0 then begin
      MemoLog.Lines.Add('小地图数据加载失败！！！' + 'Code: ' + IntToStr(nCode));
      exit;
    end;
    MemoLog.Lines.Add('小地图数据加载成功...');

    MemoLog.Lines.Add('正在加载地图数据...');
    nCode := FrmDB.LoadMapInfo;
    if nCode < 0 then begin
      MemoLog.Lines.Add('地图数据加载失败！！！' + 'Code: ' + IntToStr(nCode));
      exit;
    end;
    MemoLog.Lines.Add(format('地图数据加载成功(%d)...', [g_MapManager.Count]));

    MemoLog.Lines.Add('正在加载怪物数据库...');
    nCode := FrmDB.LoadMonsterDB;
    if nCode < 0 then begin
      MemoLog.Lines.Add('加载怪物数据库失败！！！' + 'Code: ' + IntToStr(nCode));
      exit;
    end;
    MemoLog.Lines.Add(format('加载怪物数据库成功(%d)...', [UserEngine.MonsterList.Count]));

    MemoLog.Lines.Add('正在加载技能数据库...');
    nCode := FrmDB.LoadMagicDB;
    if nCode < 0 then begin
      MemoLog.Lines.Add('加载技能数据库失败！！！' + 'Code: ' + IntToStr(nCode));
      exit;
    end;
    MemoLog.Lines.Add(format('加载技能数据库成功(%d)...', [UserEngine.m_MagicList.Count]));

    MemoLog.Lines.Add('正在加载怪物刷新配置信息...');
    nCode := FrmDB.LoadMonGen;
    if nCode < 0 then begin
      MemoLog.Lines.Add('加载怪物刷新配置信息失败！！！' + 'Code: ' + IntToStr(nCode));
      exit;
    end;
    MemoLog.Lines.Add(format('加载怪物刷新配置信息成功(%d)...', [UserEngine.m_MonGenList.Count]));

    MemoLog.Lines.Add('正加载怪物说话配置信息...');
    LoadMonSayMsg();
    MemoLog.Lines.Add(format('加载怪物说话配置信息成功(%d)...', [g_MonSayMsgList.Count]));

    LoadDisableTakeOffList();
    LoadMonDropLimitList();
    LoadDisableMakeItem();
    LoadEnableMakeItem();
    LoadDisableMoveMap;
    ItemUnit.LoadCustomItemName();
    LoadDisableSendMsgList();
    LoadItemBindIPaddr();
    LoadItemBindAccount();
    LoadItemBindCharName();
    LoadUnMasterList();
    LoadUnForceMasterList();
    
    LoadAllowPickUpItemList();   //加载允许捡取物品

    LoadAllowSellOffItemList();

    MemoLog.Lines.Add('正在加载寄售物品数据库...');
    g_SellOffGoldList.LoadSellOffGoldList();
    g_SellOffGoodList.LoadSellOffGoodList();
    MemoLog.Lines.Add(format('加载寄售物品数据库成功(%d)...', [g_SellOffGoodList.RecCount]));

    MemoLog.Lines.Add('正在加载无限仓库数据库...');
    g_BigStorageList.LoadBigStorageList();
    MemoLog.Lines.Add(format('加载无限仓库数据库成功(%d/%d)...', [g_BigStorageList.HumManCount,g_BigStorageList.RecordCount]));

    MemoLog.Lines.Add('正在加载捆装物品信息...');

    nCode := FrmDB.LoadUnbindList;
    if nCode < 0 then begin
      MemoLog.Lines.Add('加载捆装物品信息失败！！！' + 'Code: ' + IntToStr(nCode));
      exit;
    end;
    MemoLog.Lines.Add('加载捆装物品信息成功...');

    LoadBindItemTypeFromUnbindList(); {加载捆装物品类型}

    MemoLog.Lines.Add('正在加载任务地图信息...');
    nCode := FrmDB.LoadMapQuest;
    if nCode < 0 then begin
      MemoLog.Lines.Add('加载任务地图信息失败！！！');
      exit;
    end;
    MemoLog.Lines.Add('加载任务地图信息成功...');

    MemoLog.Lines.Add('正在加载地图触发事件信息...');
    nCode := FrmDB.LoadMapEvent;
    if nCode < 0 then begin
      MemoLog.Lines.Add('加载地图触发事件信息失败！！！');
      exit;
    end;
    MemoLog.Lines.Add('加载地图触发事件信息成功...');

    MemoLog.Lines.Add('正在加载任务说明信息...');
    nCode := FrmDB.LoadQuestDiary;
    if nCode < 0 then begin
      MemoLog.Lines.Add('加载任务说明信息失败！！！');
      exit;
    end;
    MemoLog.Lines.Add('加载任务说明信息成功...');

    if LoadAbuseInformation('.\!abuse.txt') then begin
      MemoLog.Lines.Add('加载文字过滤信息成功...');
    end;

    MemoLog.Lines.Add('正在加载公告提示信息...');
    if not LoadLineNotice(g_Config.sNoticeDir + 'LineNotice.txt') then begin
      MemoLog.Lines.Add('加载公告提示信息失败！！！');
    end;
    MemoLog.Lines.Add('加载公告提示信息成功...');

    FrmDB.LoadAdminList();
    MemoLog.Lines.Add('管理员列表加载成功...');
    g_GuildManager.LoadGuildInfo();
    MemoLog.Lines.Add('行会列表加载成功...');

    g_CastleManager.LoadCastleList();
    MemoLog.Lines.Add('城堡列表加载成功...');

    //UserCastle.Initialize;
    g_CastleManager.Initialize;
    MemoLog.Lines.Add('城堡城初始完成...');
    if (nServerIndex = 0) then FrmSrvMsg.StartMsgServer
    else FrmMsgClient.ConnectMsgServer;
    StartEngine();
    boStartReady := True;
    Sleep(500);

    ConnectTimer.Enabled := True;

    g_dwRunTick := GetTickCount();

    n4EBD1C := 0;
    g_dwUsrRotCountTick := GetTickCount();

    RunTimer.Enabled := True;
    SendGameCenterMsg(SG_STARTOK, '游戏主程序启动完成...');
    GateSocket.Address := g_Config.sGateAddr;
    GateSocket.Port := g_Config.nGatePort;
    g_GateSocket := GateSocket;
    SendGameCenterMsg(SG_CHECKCODEADDR, IntToStr(Integer(@g_CheckCode)));
    boRemoteOpenGateSocket := True;  //开启网关套接字
  except
    on E: Exception do
      MainOutMessage('服务器启动异常！！！' + E.Message);
  end;
end;

procedure TFrmMain.StartEngine();
var
  nCode: Integer;
  sProductInfo:String;
  sWebSite:String;
  sBbsSite:String;
  sSellInfo1:String;
  sSellInfo2:String;
begin         
  try
{$IF IDSOCKETMODE = TIMERENGINE}
    FrmIDSoc.Initialize;
    MemoLog.Lines.Add('登录服务器连接初始化完成...');
{$IFEND}
    g_MapManager.LoadMapDoor;
    MemoLog.Lines.Add('地图环境加载成功...');

    MakeStoneMines();
    MemoLog.Lines.Add('矿物数据初始成功...');
    nCode := FrmDB.LoadMerchant;
    if nCode < 0 then begin
      MemoLog.Lines.Add('Load Merchant Error ！！！' + 'Code: ' + IntToStr(nCode));
      exit;
    end;
    MemoLog.Lines.Add('交易NPC列表加载成功...');

    if not g_Config.boVentureServer then begin
      nCode := FrmDB.LoadGuardList;
      if nCode < 0 then begin
        MemoLog.Lines.Add('Load GuardList Error ！！！' + 'Code: ' + IntToStr(nCode));
      end;
      MemoLog.Lines.Add('守卫列表加载成功...');
    end;

    nCode := FrmDB.LoadNpcs;
    if nCode < 0 then begin
      MemoLog.Lines.Add('Load NpcList Error ！！！' + 'Code: ' + IntToStr(nCode));
      exit;
    end;
    MemoLog.Lines.Add('管理NPC列表加载成功...');

    nCode := FrmDB.LoadMakeItem;
    if nCode < 0 then begin
      MemoLog.Lines.Add('Load MakeItem Error ！！！' + 'Code: ' + IntToStr(nCode));
      exit;
    end;
    MemoLog.Lines.Add('炼制物品信息加载成功...');

    nCode := FrmDB.LoadStartPoint;
    if nCode < 0 then begin
      MemoLog.Lines.Add('加载回城点配置时出现错误 ！！！(错误码: ' + IntToStr(nCode) + ')');
      Close;
    end;
    MemoLog.Lines.Add('回城点配置加载成功...');

    FrontEngine.Resume;
    MemoLog.Lines.Add('人物数据引擎启动成功...');

    UserEngine.Initialize;
    MemoLog.Lines.Add('游戏处理引擎初始化成功...');
    g_MapManager.MakeSafePkZone;   //安全区光圈

    sCaptionExtText:='正在初始化引擎插件...';
    Caption := sCaption + ' [' + sCaptionExtText + ']';

{$IF nVersion = nSuperUser}
    Decode(g_sProductInfo, sProductInfo);
    Decode(g_sWebSite, sWebSite);
    Decode(g_sBbsSite, sBbsSite);
    Decode(g_sSellInfo1, sSellInfo1);
    Decode(g_sSellInfo2, sSellInfo2);
    MainOutMessage(sProductInfo);
    MainOutMessage(sWebSite);
    MainOutMessage(sBbsSite);
    MainOutMessage(sSellInfo1);
    MainOutMessage(sSellInfo2);
{$IFEND}

    if (nStartModule >= 0) and Assigned(PlugProcArray[nStartModule].nProcAddr) then begin
      if PlugProcArray[nStartModule].nCheckCode = 1 then begin
        TStartProc(PlugProcArray[nStartModule].nProcAddr);
      end;
    end;
    PlugInEngine.StartPlugMoudle;
    MemoLog.Lines.Add('引擎插件初始化成功...');
    sCaptionExtText:=g_Config.sServerName;  //窗口标题显示
    boSaveData:=True;
    Sleep(1000);//如果加了这句 插件就不能用了。

  except
    MainOutMessage('服务启动时出现异常错误 ！！！');
  end;
end;

procedure TFrmMain.MakeStoneMines();
var
  i, nW, nH: Integer;
  Envir: TEnvirnoment;
begin
  for i := 0 to g_MapManager.Count - 1 do begin
    Envir := TEnvirnoment(g_MapManager.Items[i]);
    if Envir.m_boMINE then begin
      for nW := 0 to Envir.m_nWidth - 1 do begin
        for nH := 0 to Envir.m_nHeight - 1 do begin
          //if (nW mod 2 = 0) and (nH mod 2 = 0) then
          TStoneMineEvent.Create(Envir, nW, nH, ET_STONEMINE);
        end;
      end;
    end;
  end;
end;

function TFrmMain.LoadClientFile(): Boolean;
begin
  MemoLog.Lines.Add('正在加载客户端版本信息...');
  if not (g_Config.sClientFile1 = '') then g_Config.nClientFile1_CRC := CalcFileCRC(g_Config.sClientFile1);
  if not (g_Config.sClientFile2 = '') then g_Config.nClientFile2_CRC := CalcFileCRC(g_Config.sClientFile2);
  if not (g_Config.sClientFile3 = '') then g_Config.nClientFile3_CRC := CalcFileCRC(g_Config.sClientFile3);
  if (g_Config.nClientFile1_CRC <> 0) or (g_Config.nClientFile2_CRC <> 0) or (g_Config.nClientFile3_CRC <> 0) then begin
    MemoLog.Lines.Add('加载客户端版本信息成功...');
    Result := True;
  end else begin
    MemoLog.Lines.Add('加载客户端版本信息失败！！！');
    Result := False;
  end;
  Result := True;
end;

procedure TFrmMain.FormCreate(Sender: TObject);
var
  nX, nY: Integer;
  Year, Month, Day: Word;
  MemoryStream: TMemoryStream;
resourcestring
  //sDemoVersion = '演示版';
  sGateIdx = '网关';
  sGateIPaddr = '网关地址';
  sGateListMsg = '队列数据';
  sGateSendCount = '发送数据';
  sGateMsgCount = '剩余数据';
  sGateSendKB = '平均流量';
  sGateUserCount = '最高人数';
begin
  Randomize;
  g_dwGameCenterHandle := Str_ToInt(ParamStr(1), 0);
  nX := Str_ToInt(ParamStr(2), -1);
  nY := Str_ToInt(ParamStr(3), -1);
  if (nX >= 0) or (nY >= 0) then begin
    Left := nX;
    Top := nY;
  end;
  SendGameCenterMsg(SG_FORMHANDLE, IntToStr(Self.Handle));
  GridGate.RowCount := 21;
  GridGate.Cells[0, 0] := sGateIdx;
  GridGate.Cells[1, 0] := sGateIPaddr;
  GridGate.Cells[2, 0] := sGateListMsg;
  GridGate.Cells[3, 0] := sGateSendCount;
  GridGate.Cells[4, 0] := sGateMsgCount;
  GridGate.Cells[5, 0] := sGateSendKB;
  GridGate.Cells[6, 0] := sGateUserCount;

  GateSocket := TServerSocket.Create(Owner);
  GateSocket.OnClientConnect := GateSocketClientConnect;
  GateSocket.OnClientDisconnect := GateSocketClientDisconnect;
  GateSocket.OnClientError := GateSocketClientError;
  GateSocket.OnClientRead := GateSocketClientRead;

  DBSocket.OnConnect := DBSocketConnect;
  DBSocket.OnError := DBSocketError;
  DBSocket.OnRead := DBSocketRead;

  Timer1.OnTimer := Timer1Timer;
  RunTimer.OnTimer := RunTimerTimer;
  StartTimer.OnTimer := StartTimerTimer;
  SaveVariableTimer.OnTimer := SaveVariableTimerTimer;
  ConnectTimer.OnTimer := ConnectTimerTimer;
  CloseTimer.OnTimer := CloseTimerTimer;
  MemoLog.OnChange := MemoLogChange;
  StartTimer.Enabled := True;
end;

procedure TFrmMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
resourcestring
  sCloseServerYesNo = '是否确认关闭游戏服务器？';
  sCloseServerTitle = '确认信息';
begin
  if not boServiceStarted then begin
    //    Application.Terminate;
    exit;
  end;
  if g_boExitServer then begin
    boStartReady := False;
    exit;
  end;
  CanClose := False;
  if Application.MessageBox(PChar(sCloseServerYesNo), PChar(sCloseServerTitle), MB_YESNO + MB_ICONQUESTION) = mrYes then begin
    g_boExitServer := True;
    CloseGateSocket();
    g_Config.boKickAllUser := True;
    // RunSocket.CloseAllGate;
    //    GateSocket.Close;
    CloseTimer.Enabled := True;
  end;
end;

procedure TFrmMain.CloseTimerTimer(Sender: TObject);

resourcestring
  sCloseServer = '%s [正在关闭服务器(%s %d/%s %d)...]';
  sCloseServer1 = '%s [服务器已关闭]';
begin
  Caption := Format(sCloseServer, [g_Config.sServerName,'人物', UserEngine.OnlinePlayObject,'数据', FrontEngine.SaveListCount]);
  if UserEngine.OnlinePlayObject = 0 then begin
    if FrontEngine.IsIdle then begin
      CloseTimer.Enabled := False;
      Caption := Format(sCloseServer1, [g_Config.sServerName]);
      StopService;
      Close;
    end;
  end;
end;

procedure TFrmMain.SaveVariableTimerTimer(Sender: TObject);
begin
  SaveItemNumber();
  if boSaveData then begin
    if g_SellOffGoodList <> nil then g_SellOffGoodList.SaveSellOffGoodList();
    if g_SellOffGoldList <> nil then g_SellOffGoldList.SaveSellOffGoldList();
    if g_BigStorageList <> nil then g_BigStorageList.SaveStorageList();
  end;
end;

procedure TFrmMain.GateSocketClientError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
  RunSocket.CloseErrGate(Socket, ErrorCode);
end;

procedure TFrmMain.GateSocketClientDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  RunSocket.CloseGate(Socket);
end;

procedure TFrmMain.GateSocketClientConnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  RunSocket.AddGate(Socket);
end;

procedure TFrmMain.GateSocketClientRead(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  RunSocket.SocketRead(Socket);
end;

procedure TFrmMain.RunTimerTimer(Sender: TObject);
begin
  if boStartReady then begin
    RunSocket.Execute;

    FrmIDSoc.Run;

    UserEngine.Execute;

    ProcessGameRun();

    if nServerIndex = 0 then
      FrmSrvMsg.Run
    else FrmMsgClient.Run;
  end;
  Inc(n4EBD1C);
  if (GetTickCount - g_dwRunTick) > 250 then begin
    g_dwRunTick := GetTickCount();
    nRunTimeMin := n4EBD1C;
    if nRunTimeMax > nRunTimeMin then nRunTimeMax := nRunTimeMin;
    n4EBD1C := 0;
  end;
  if boRemoteOpenGateSocket then begin
    if not boRemoteOpenGateSocketed then begin
      boRemoteOpenGateSocketed := True;
      try
        if Assigned(g_GateSocket) then begin
          g_GateSocket.Active := True;
        end;
      except
        on E: Exception do begin
          MainOutMessage(E.Message);
        end;
      end;
    end;
  end else begin
    if Assigned(g_GateSocket) then begin
      if g_GateSocket.Socket.Connected then
        g_GateSocket.Active := False;
    end;
  end;
end;

procedure TFrmMain.ConnectTimerTimer(Sender: TObject);
begin
  if DBSocket.Active then exit;
  DBSocket.Active := True;
end;

procedure TFrmMain.ReloadConfig(Sender: TObject);
begin
  try
    LoadConfig();
    FrmIDSoc.Timer1Timer(Sender);
    if not (nServerIndex = 0) then begin
      if not FrmMsgClient.MsgClient.Active then begin
        FrmMsgClient.MsgClient.Active := True;
      end;
    end;
    IdUDPClientLog.Host := g_Config.sLogServerAddr;
    IdUDPClientLog.Port := g_Config.nLogServerPort;
    LoadServerTable();
    LoadClientFile();
  finally

  end;
end;



procedure TFrmMain.MemoLogChange(Sender: TObject);
begin
  if MemoLog.Lines.Count > 500 then MemoLog.Clear;
end;

procedure TFrmMain.MemoLogDblClick(Sender: TObject);
begin
  ClearMemoLog();
end;

procedure TFrmMain.MENU_CONTROL_EXITClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmMain.MENU_CONTROL_RELOAD_CONFClick(Sender: TObject);
begin
  ReloadConfig(Sender);
end;

procedure TFrmMain.MENU_CONTROL_CLEARLOGMSGClick(Sender: TObject);
begin
  ClearMemoLog();
end;

procedure TFrmMain.SpeedButton1Click(Sender: TObject);
begin
  ReloadConfig(Sender);
end;

procedure TFrmMain.MENU_CONTROL_RELOAD_ITEMDBClick(Sender: TObject);
begin
  FrmDB.LoadItemsDB();
  MainOutMessage('重新加载物品数据库完成...');
end;

procedure TFrmMain.MENU_CONTROL_RELOAD_MAGICDBClick(Sender: TObject);
begin
  FrmDB.LoadMagicDB();
  MainOutMessage('重新加载技能数据库完成...');
end;

procedure TFrmMain.MENU_CONTROL_RELOAD_MONSTERDBClick(Sender: TObject);
begin
  FrmDB.LoadMonsterDB();
  MainOutMessage('重新加载怪物数据库完成...');
end;

procedure TFrmMain.StartService;
var
  TimeNow: TDateTime;
  Year, Month, Day, Hour, Min, Sec, MSec: Word;
  F: TextFile;
  Config: pTConfig;
  s:String;
  sAppFilesSize:String;
  nStartFilesSize,nEndFilesSize:Integer;
begin
  Config := @g_Config;
  nRunTimeMax := 99999;
  g_nSockCountMax := 0;
  g_nUsrTimeMax := 0;
  g_nHumCountMax := 0;
  g_nMonTimeMax := 0;
  g_nMonGenTimeMax := 0;
  g_nMonProcTime := 0;
  g_nMonProcTimeMin := 0;
  g_nMonProcTimeMax := 0;
  dwUsrRotCountMin := 0;
  dwUsrRotCountMax := 0;
  g_nProcessHumanLoopTime := 0;
  g_dwHumLimit := 30;
  g_dwMonLimit := 30;
  g_dwZenLimit := 5;
  g_dwNpcLimit := 5;
  g_dwSocLimit := 10;
  nDecLimit := 20;
  Config.sDBSocketRecvText := '';
  Config.boDBSocketWorking := False;
  Config.nLoadDBErrorCount := 0;
  Config.nLoadDBCount := 0;
  Config.nSaveDBCount := 0;
  Config.nDBQueryID := 0;
  Config.nItemNumber := 0;
  Config.nItemNumberEx := High(Integer) div 2;
  boStartReady := False;
  g_boExitServer := False;
  boFilterWord := True;
  Config.nWinLotteryCount := 0;
  Config.nNoWinLotteryCount := 0;
  Config.nWinLotteryLevel1 := 0;
  Config.nWinLotteryLevel2 := 0;
  Config.nWinLotteryLevel3 := 0;
  Config.nWinLotteryLevel4 := 0;
  Config.nWinLotteryLevel5 := 0;
  Config.nWinLotteryLevel6 := 0;
  FillChar(g_Config.GlobalVal, SizeOf(g_Config.GlobalVal), #0);
  FillChar(g_Config.GlobaDyMval, SizeOf(g_Config.GlobaDyMval), #0);
  FillChar(g_Config.GlobalAVal, SizeOf(g_Config.GlobalAVal), #0);
{$IF USECODE = USEREMOTECODE}
  New(Config.Encode6BitBuf);
  Config.Encode6BitBuf^ := g_Encode6BitBuf;

  New(Config.Decode6BitBuf);
  Config.Decode6BitBuf^ := g_Decode6BitBuf;
{$IFEND}
  LoadConfig();
  Memo := MemoLog;
  nServerIndex := 0;
  zPlugOfEngine := TPlugOfEngine.Create;
  PlugInEngine := TPlugInManage.Create;
  RunSocket := TRunSocket.Create();
  MainLogMsgList := TStringList.Create;
  LogStringList := TStringList.Create;
  LogonCostLogList := TStringList.Create;
  g_MapManager := TMapManager.Create;
  ItemUnit := TItemUnit.Create;
  MagicManager := TMagicManager.Create;
  NoticeManager := TNoticeManager.Create;
  g_GuildManager := TGuildManager.Create;
  g_EventManager := TEventManager.Create;
  g_CastleManager := TCastleManager.Create;
  {
  g_UserCastle        := TUserCastle.Create;

  CastleManager.Add(g_UserCastle);
  }

  FrontEngine := TFrontEngine.Create(True);
  UserEngine := TUserEngine.Create();
  RobotManage := TRobotManage.Create;
  g_MakeItemList := TStringList.Create;
  g_StartPointList := TGStringList.Create;
  ServerTableList := TList.Create;
  g_DenySayMsgList := TQuickList.Create;
  MiniMapList := TStringList.Create;
  g_UnbindList := TStringList.Create;
  LineNoticeList := TStringList.Create;
  QuestDiaryList := TList.Create;
  ItemEventList := TStringList.Create;
  AbuseTextList := TStringList.Create;
  g_MonSayMsgList := TStringList.Create;
  g_DisableMakeItemList := TGStringList.Create;
  g_EnableMakeItemList := TGStringList.Create;
  g_DisableMoveMapList := TGStringList.Create;
  g_ItemNameList := TGList.Create;
  g_DisableSendMsgList := TGStringList.Create;
  g_MonDropLimitLIst := TGStringList.Create;
  g_DisableTakeOffList := TGStringList.Create;
  g_UnMasterList := TGStringList.Create;
  g_UnForceMasterList := TGStringList.Create;
  g_GameLogItemNameList := TGStringList.Create;
  g_DenyIPAddrList := TGStringList.Create;
  g_DenyChrNameList := TGStringList.Create;
  g_DenyAccountList := TGStringList.Create;
  g_NoClearMonList := TGStringList.Create;

  g_ItemBindIPaddr := TGList.Create;
  g_ItemBindAccount := TGList.Create;
  g_ItemBindCharName := TGList.Create;

  g_AllowSellOffItemList := TGStringList.Create;
  g_SellOffGoodList := TSellOffGoodList.Create;
  g_SellOffGoldList := TSellOffGoldList.Create;
  g_BigStorageList := TBigStorageList.Create;

  g_MapEventListOfDropItem := TGList.Create;
  g_MapEventListOfPickUpItem := TGList.Create;
  g_MapEventListOfMine := TGList.Create;
  g_MapEventListOfWalk := TGList.Create;
  g_MapEventListOfRun := TGList.Create;

  InitializeCriticalSection(LogMsgCriticalSection);
  InitializeCriticalSection(ProcessMsgCriticalSection);
  InitializeCriticalSection(ProcessHumanCriticalSection);

  InitializeCriticalSection(Config.UserIDSection);
  InitializeCriticalSection(UserDBSection);
  CS_6 := TCriticalSection.Create;
  g_DynamicVarList := TList.Create;

 // AddToProcTable(@TPlugOfEngine_SetUserLicense, PChar(Base64DecodeStr('U2V0VXNlckxpY2Vuc2U=')), 5); //  SetUserLicense
  //AddToProcTable(@TFrmMain_ChangeGateSocket, PChar(Base64DecodeStr('Q2hhbmdlR2F0ZVNvY2tldA==')), 6); //ChangeGateSocket

  TimeNow := Now();
  DecodeDate(TimeNow, Year, Month, Day);
  DecodeTime(TimeNow, Hour, Min, Sec, MSec);
  if not DirectoryExists(g_Config.sLogDir) then begin
    CreateDir(Config.sLogDir);
  end;

  sLogFileName := g_Config.sLogDir {'.\Log\'} + IntToStr(Year) + '-' + IntToStr2(Month) + '-' + IntToStr2(Day) + '.' + IntToStr2(Hour) + '-' + IntToStr2(Min) + '.txt';
  AssignFile(F, sLogFileName);
  Rewrite(F);
  CloseFile(F);
  Caption := '';
  PlugInEngine.LoadPlugIn();
  MemoLog.Lines.Add('正在读取配置信息...');
  nShiftUsrDataNameNo := 1;

  DBSocket.Address := g_Config.sDBAddr;
  DBSocket.Port := g_Config.nDBPort;
  Caption := g_Config.sServerName;
  sCaption := g_Config.sServerName;
  LoadServerTable();

{  if Decode(sBUYHINTINFO, s) then Dec(nCrackedLevel, 5);
  nAppFilesSize := GetFilesSize(Application.ExeName);        //检测自身大小如果不正确，为脱壳破解
  if Decode(sFilesSize,sAppFilesSize) then begin
    nStartFilesSize:=Str_ToInt(sAppFilesSize,0)-10000;
    nEndFilesSize:=Str_ToInt(sAppFilesSize,0)+10000;
    if (nAppFilesSize >=nStartFilesSize) and (nAppFilesSize <=nEndFilesSize) then Dec(nErrorLevel,1000) else Inc(nErrorLevel,888);
  end; }

{$IF SoftVersion = VERPRO}
  Decode(sSoftVersion_VERPRO,sSoftVersionType); //企业版
{$ELSEIF SoftVersion = VERENT}
  Decode(sSoftVersion_VERENT,sSoftVersionType);//'专业版'
{$IFEND}

  IdUDPClientLog.Host := g_Config.sLogServerAddr;
  IdUDPClientLog.Port := g_Config.nLogServerPort;

  Application.OnIdle := AppOnIdle;
  Application.OnException := OnProgramException;
  dwRunDBTimeMax := GetTickCount();
  g_dwStartTick := GetTickCount();
  Timer1.Enabled := True;

  boServiceStarted := True;
end;

procedure TFrmMain.StopService;
var
  i: Integer;
  Config: pTConfig;
  ThreadInfo: pTThreadInfo;
begin
 try
   Config := @g_Config;
    PlugInEngine.Free;
    zPlugOfEngine.Free;

    Timer1.Enabled := False;
    RunTimer.Enabled := False;
    FrmIDSoc.Close;
    GateSocket.Close;
    Memo := nil;
    SaveItemNumber();
    g_CastleManager.Free;

    FrontEngine.Terminate();
    FrontEngine.Free;
    MagicManager.Free;

    UserEngine.Free;

    RobotManage.Free;

    RunSocket.Free;

    ConnectTimer.Enabled := False;
    DBSocket.Close;

    FreeAndNil(MainLogMsgList);
    FreeAndNil(LogStringList);
    FreeAndNil(LogonCostLogList);
    g_MapManager.Free;
    ItemUnit.Free;

    NoticeManager.Free;
    g_GuildManager.Free;

    for i := 0 to g_MakeItemList.Count - 1 do begin
      TStringList(g_MakeItemList.Objects[i]).Free;
    end;
    for i := 0 to g_StartPointList.Count - 1 do begin
      DisPose(pTStartPoint(g_StartPointList.Objects[i]));
    end;
    FreeAndNil(g_StartPointList);

    FreeAndNil(g_MakeItemList);
    FreeAndNil(ServerTableList);
    FreeAndNil(g_DenySayMsgList);
    FreeAndNil(MiniMapList);
    FreeAndNil(g_UnbindList);
    FreeAndNil(LineNoticeList);
    FreeAndNil(QuestDiaryList);
    FreeAndNil(ItemEventList);
    FreeAndNil(AbuseTextList);
    FreeAndNil(g_MonSayMsgList);
    FreeAndNil(g_DisableMakeItemList);
    FreeAndNil(g_EnableMakeItemList);
    FreeAndNil(g_DisableMoveMapList);
    FreeAndNil(g_ItemNameList);
    FreeAndNil(g_DisableSendMsgList);
    FreeAndNil(g_MonDropLimitLIst);
    FreeAndNil(g_DisableTakeOffList);
    FreeAndNil(g_UnMasterList);
    FreeAndNil(g_UnForceMasterList);
    FreeAndNil(g_GameLogItemNameList);
    FreeAndNil(g_DenyIPAddrList);
    FreeAndNil(g_DenyChrNameList);
    FreeAndNil(g_DenyAccountList);
    FreeAndNil(g_NoClearMonList);
    FreeAndNil(g_AllowSellOffItemList);
    //g_SellOffGoldList.UnLoadSellOffGoldList();
    //g_SellOffGoodList.UnLoadSellOffGoodList();
    FreeAndNil(g_SellOffGoodList);
    FreeAndNil(g_SellOffGoldList);
    FreeAndNil(g_BigStorageList);
    for i := 0 to g_ItemBindIPaddr.Count - 1 do begin
      DisPose(pTItemBind(g_ItemBindIPaddr.Items[i]));
    end;
    for i := 0 to g_ItemBindAccount.Count - 1 do begin
      DisPose(pTItemBind(g_ItemBindAccount.Items[i]));
    end;
    for i := 0 to g_ItemBindCharName.Count - 1 do begin
      DisPose(pTItemBind(g_ItemBindCharName.Items[i]));
    end;
    FreeAndNil(g_ItemBindIPaddr);
    FreeAndNil(g_ItemBindAccount);
    FreeAndNil(g_ItemBindCharName);

    for i := 0 to g_MapEventListOfDropItem.Count - 1 do begin
      DisPose(pTMapEvent(g_MapEventListOfDropItem.Items[i]));
    end;
    FreeAndNil(g_MapEventListOfDropItem);

    for i := 0 to g_MapEventListOfPickUpItem.Count - 1 do begin
      DisPose(pTMapEvent(g_MapEventListOfPickUpItem.Items[i]));
    end;
    FreeAndNil(g_MapEventListOfPickUpItem);

    for i := 0 to g_MapEventListOfMine.Count - 1 do begin
      DisPose(pTMapEvent(g_MapEventListOfMine.Items[i]));
    end;
    FreeAndNil(g_MapEventListOfMine);

    for i := 0 to g_MapEventListOfWalk.Count - 1 do begin
      DisPose(pTMapEvent(g_MapEventListOfWalk.Items[i]));
    end;
    FreeAndNil(g_MapEventListOfWalk);

    for i := 0 to g_MapEventListOfRun.Count - 1 do begin
      DisPose(pTMapEvent(g_MapEventListOfRun.Items[i]));
    end;
    FreeAndNil(g_MapEventListOfRun);

    DeleteCriticalSection(LogMsgCriticalSection);
    DeleteCriticalSection(ProcessMsgCriticalSection);
    DeleteCriticalSection(ProcessHumanCriticalSection);

    DeleteCriticalSection(Config.UserIDSection);
    DeleteCriticalSection(UserDBSection);

    CS_6.Free;
    for i := 0 to g_DynamicVarList.Count - 1 do begin
      DisPose(pTDynamicVar(g_DynamicVarList.Items[i]));
    end;
    FreeAndNil(g_DynamicVarList);

    if g_BindItemTypeList <> nil then begin
      for i := 0 to g_BindItemTypeList.Count - 1 do begin
        DisPose(pTBindItem(g_BindItemTypeList.Items[i]));
      end;
      FreeAndNil(g_BindItemTypeList);
    end;
    
    FreeAndNil(g_AllowPickUpItemList);

    boServiceStarted := False;
  except
    {on E: Exception do begin
      ShowMessage('错误信息:' + E.Message);
      Exit;
      raise;
    end; }
  end;
end;

procedure TFrmMain.MENU_HELP_ABOUTClick(Sender: TObject);
begin
  FrmAbout := TFrmAbout.Create(Owner);
  FrmAbout.Open();
  FrmAbout.Free;
end;

procedure TFrmMain.DBSocketConnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  MainOutMessage('数据库服务器(' + Socket.RemoteAddress + ':' + IntToStr(Socket.RemotePort) + ')连接成功...');
end;

procedure TFrmMain.MENU_OPTION_SERVERCONFIGClick(Sender: TObject);
begin
  FrmServerValue := TFrmServerValue.Create(Owner);
  FrmServerValue.Top := Self.Top + 20;
  FrmServerValue.Left := Self.Left;
  FrmServerValue.AdjuestServerConfig();
  FrmServerValue.Free;
end;

procedure TFrmMain.MENU_OPTION_GENERALClick(Sender: TObject);
begin
  frmGeneralConfig := TfrmGeneralConfig.Create(Owner);
  frmGeneralConfig.Top := Self.Top + 20;
  frmGeneralConfig.Left := Self.Left;
  frmGeneralConfig.Open();
  frmGeneralConfig.Free;
  Caption := g_Config.sServerName;
end;

procedure TFrmMain.MENU_OPTION_GAMEClick(Sender: TObject);
begin
  frmGameConfig := TfrmGameConfig.Create(Owner);
  frmGameConfig.Top := Self.Top + 20;
  frmGameConfig.Left := Self.Left;
  frmGameConfig.Open;
  frmGameConfig.Free;
end;

procedure TFrmMain.MENU_OPTION_FUNCTIONClick(Sender: TObject);
begin
  frmFunctionConfig := TfrmFunctionConfig.Create(Owner);
  frmFunctionConfig.Top := Self.Top + 20;
  frmFunctionConfig.Left := Self.Left;
  frmFunctionConfig.Open;
  frmFunctionConfig.Free;
end;

procedure TFrmMain.G1Click(Sender: TObject);
begin
  frmGameCmd := TfrmGameCmd.Create(Owner);
  frmGameCmd.Top := Self.Top + 20;
  frmGameCmd.Left := Self.Left;
  frmGameCmd.Open;
  frmGameCmd.Free;
end;

procedure TFrmMain.MENU_OPTION_MONSTERClick(Sender: TObject);
begin
  frmMonsterConfig := TfrmMonsterConfig.Create(Owner);
  frmMonsterConfig.Top := Self.Top + 20;
  frmMonsterConfig.Left := Self.Left;
  frmMonsterConfig.Open;
  frmMonsterConfig.Free;
end;

procedure TFrmMain.MENU_CONTROL_RELOAD_MONSTERSAYClick(Sender: TObject);
begin
  UserEngine.ClearMonSayMsg();
  LoadMonSayMsg();
  MainOutMessage('重新加载怪物说话配置完成...');
end;

procedure TFrmMain.MENU_CONTROL_RELOAD_DISABLEMAKEClick(Sender: TObject);
begin
  LoadDisableTakeOffList();
  LoadDisableMakeItem();
  LoadEnableMakeItem();
  LoadDisableMoveMap();
  ItemUnit.LoadCustomItemName();
  LoadDisableSendMsgList();
  LoadGameLogItemNameList();
  LoadItemBindIPaddr();
  LoadItemBindAccount();
  LoadItemBindCharName();
  LoadUnMasterList();
  LoadUnForceMasterList();
  LoadDenyIPAddrList();
  LoadDenyAccountList();
  LoadDenyChrNameList();
  LoadNoClearMonList();
  LoadAllowSellOffItemList();
  FrmDB.LoadAdminList();
  MainOutMessage('重新加载列表配置完成...');
end;

procedure TFrmMain.MENU_CONTROL_RELOAD_STARTPOINTClick(Sender: TObject);
begin
  FrmDB.LoadStartPoint();
  MainOutMessage('重新地图安全区列表完成...');
end;

procedure TFrmMain.MENU_CONTROL_GATE_OPENClick(Sender: TObject);
resourcestring
  sGatePortOpen = '游戏网关端口(%s:%d)已打开...';
begin
  if not GateSocket.Active then begin
    GateSocket.Active := True;
    MainOutMessage(format(sGatePortOpen, [GateSocket.Address, GateSocket.Port]));
  end;
end;

procedure TFrmMain.MENU_CONTROL_GATE_CLOSEClick(Sender: TObject);
begin
  CloseGateSocket();
end;

procedure TFrmMain.CloseGateSocket;
var
  i: Integer;
resourcestring
  sGatePortClose = '游戏网关端口(%s:%d)已关闭...';
begin
  if GateSocket.Active then begin
    for i := 0 to GateSocket.Socket.ActiveConnections - 1 do begin
      GateSocket.Socket.Connections[i].Close;
    end;
    GateSocket.Active := False;
    MainOutMessage(format(sGatePortClose, [GateSocket.Address, GateSocket.Port]));
  end;
end;

procedure TFrmMain.MENU_CONTROLClick(Sender: TObject);
begin
  if GateSocket.Active then begin
    MENU_CONTROL_GATE_OPEN.Enabled := False;
    MENU_CONTROL_GATE_CLOSE.Enabled := True;
  end else begin
    MENU_CONTROL_GATE_OPEN.Enabled := True;
    MENU_CONTROL_GATE_CLOSE.Enabled := False;
  end;
end;

procedure UserEngineProcess(Config: pTConfig; ThreadInfo: pTThreadInfo);
var
  nRunTime: Integer;
  dwRunTick: LongWord;
begin
  l_dwRunTimeTick := 0;
  dwRunTick := GetTickCount();
  ThreadInfo.dwRunTick := dwRunTick;
  while not ThreadInfo.boTerminaled do begin
    nRunTime := GetTickCount - ThreadInfo.dwRunTick;
    if ThreadInfo.nRunTime < nRunTime then ThreadInfo.nRunTime := nRunTime;
    if ThreadInfo.nMaxRunTime < nRunTime then ThreadInfo.nMaxRunTime := nRunTime;
    if GetTickCount - dwRunTick >= 1000 then begin
      dwRunTick := GetTickCount();
      if ThreadInfo.nRunTime > 0 then Dec(ThreadInfo.nRunTime);
    end;

    ThreadInfo.dwRunTick := GetTickCount();
    ThreadInfo.boActived := True;
    ThreadInfo.nRunFlag := 125;
    if Config.boThreadRun then
      ProcessGameRun();
    Sleep(1);
  end;
end;

procedure UserEngineThread(ThreadInfo: pTThreadInfo); stdcall;
var
  nErrorCount: Integer;
resourcestring
  sExceptionMsg = '[Exception] UserEngineThread ErrorCount = %d';
begin
  nErrorCount := 0;
  while True do begin
    try
      UserEngineProcess(ThreadInfo.Config, ThreadInfo);
      break;
    except
      Inc(nErrorCount);
      if nErrorCount > 10 then break;
      MainOutMessage(format(sExceptionMsg, [nErrorCount]));
    end;
  end;
  ExitThread(0);
end;

procedure ProcessGameRun();
var
  i: Integer;
begin
  EnterCriticalSection(ProcessHumanCriticalSection);
  try
    UserEngine.PrcocessData;
    g_EventManager.Run;
    RobotManage.Run;
    if GetTickCount - l_dwRunTimeTick > 10000 then begin
      l_dwRunTimeTick := GetTickCount();
      g_GuildManager.Run;
      g_CastleManager.Run;
      g_DenySayMsgList.Lock;
      try
        for i := g_DenySayMsgList.Count - 1 downto 0 do begin
          if GetTickCount > LongWord(g_DenySayMsgList.Objects[i]) then begin
            g_DenySayMsgList.Delete(i);
          end;
        end;
      finally
        g_DenySayMsgList.UnLock;
      end;
    end;
  finally
    LeaveCriticalSection(ProcessHumanCriticalSection);
  end;
end;

procedure TFrmMain.MENU_VIEW_GATEClick(Sender: TObject);
begin
  {MENU_VIEW_GATE.Checked := not MENU_VIEW_GATE.Checked;
  GridGate.Visible := MENU_VIEW_GATE.Checked; }
end;

procedure TFrmMain.MENU_VIEW_SESSIONClick(Sender: TObject);
begin
  frmViewSession := TfrmViewSession.Create(Owner);
  frmViewSession.Top := Top + 20;
  frmViewSession.Left := Left;
  frmViewSession.Open();
  frmViewSession.Free;
end;

procedure TFrmMain.MENU_VIEW_ONLINEHUMANClick(Sender: TObject);
begin
  frmViewOnlineHuman := TfrmViewOnlineHuman.Create(Owner);
  frmViewOnlineHuman.Top := Top + 20;
  frmViewOnlineHuman.Left := Left;
  frmViewOnlineHuman.Open();
  frmViewOnlineHuman.Free;
end;

procedure TFrmMain.MENU_VIEW_LEVELClick(Sender: TObject);
begin
  frmViewLevel := TfrmViewLevel.Create(Owner);
  frmViewLevel.Top := Top + 20;
  frmViewLevel.Left := Left;
  frmViewLevel.Open();
  frmViewLevel.Free;
end;

procedure TFrmMain.MENU_VIEW_LISTClick(Sender: TObject);
begin
  frmViewList := TfrmViewList.Create(Owner);
  frmViewList.Top := Top + 20;
  frmViewList.Left := Left;
  frmViewList.Open();
  frmViewList.Free;
end;

procedure TFrmMain.MENU_MANAGE_ONLINEMSGClick(Sender: TObject);
begin
  frmOnlineMsg := TfrmOnlineMsg.Create(Owner);
  frmOnlineMsg.Top := Top + 20;
  frmOnlineMsg.Left := Left;
  frmOnlineMsg.Open();
  frmOnlineMsg.Free;
end;

procedure TFrmMain.MENU_MANAGE_PLUGClick(Sender: TObject);
begin
  ftmPlugInManage := TftmPlugInManage.Create(Owner);
  ftmPlugInManage.Top := Top + 20;
  ftmPlugInManage.Left := Left;
  ftmPlugInManage.Open();
  ftmPlugInManage.Free;
end;

procedure TFrmMain.SetMenu;
begin
  FrmMain.Menu := MainMenu;
end;

procedure TFrmMain.MENU_VIEW_KERNELINFOClick(Sender: TObject);
begin
  frmViewKernelInfo := TfrmViewKernelInfo.Create(Owner);
  frmViewKernelInfo.Top := Top + 20;
  frmViewKernelInfo.Left := Left;
  frmViewKernelInfo.Open();
  frmViewKernelInfo.Free;
end;

procedure TFrmMain.MENU_TOOLS_MERCHANTClick(Sender: TObject);
begin
  frmConfigMerchant := TfrmConfigMerchant.Create(Owner);
  frmConfigMerchant.Top := Top + 20;
  frmConfigMerchant.Left := Left;
  frmConfigMerchant.Open();
  frmConfigMerchant.Free;
end;

procedure TFrmMain.MENU_OPTION_ITEMFUNCClick(Sender: TObject);
begin
  frmItemSet := TfrmItemSet.Create(Owner);
  frmItemSet.Top := Top + 20;
  frmItemSet.Left := Left;
  frmItemSet.Open();
  frmItemSet.Free;
end;

procedure TFrmMain.ClearMemoLog;
begin
  if Application.MessageBox('是否确定清除日志信息！！！', '提示信息', MB_YESNO + MB_ICONQUESTION) = mrYes then begin
    MemoLog.Clear;
  end;
end;

procedure TFrmMain.MENU_TOOLS_MONGENClick(Sender: TObject);
begin
  frmConfigMonGen := TfrmConfigMonGen.Create(Owner);
  frmConfigMonGen.Top := Top + 20;
  frmConfigMonGen.Left := Left;
  frmConfigMonGen.Open();
  frmConfigMonGen.Free;
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
        g_boExitServer := True;
        CloseGateSocket();
        g_Config.boKickAllUser := True;
        CloseTimer.Enabled := True;
      end;
    1: ;
    2: ;
    3: ;
  end;
end;

procedure TFrmMain.MENU_TOOLS_IPSEARCHClick(Sender: TObject);
var
  sIPaddr: string;
begin
  try
    sIPaddr:='192.168.0.1';
    //sIPaddr := InputBox('IP所在地区查询', '输入IP地址:', '192.168.0.1');
    if not InputQuery('IP所在地区查询','输入IP地址:',sIPaddr) then Exit;
    if not IsIPaddr(sIPaddr) then begin
      Application.MessageBox('输入的IP地址格式不正确！！！', '错误信息', MB_OK + MB_ICONERROR);
      Exit;
    end;
    if not IsIPaddr(sIPaddr) then begin
      Application.MessageBox('输入的IP地址格式不正确！！！', '错误信息', MB_OK + MB_ICONERROR);
      Exit;
    end;
    MemoLog.Lines.Add(format('%s:%s', [sIPaddr, GetIPLocal(sIPaddr)]));
  except
    MemoLog.Lines.Add(format('%s:%s', [sIPaddr, GetIPLocal(sIPaddr)]));
  end;
end;

procedure TFrmMain.MENU_MANAGE_CASTLEClick(Sender: TObject);
begin
  frmCastleManage := TfrmCastleManage.Create(Owner);
  frmCastleManage.Top := Top + 20;
  frmCastleManage.Left := Left;
  frmCastleManage.Open();
  frmCastleManage.Free;
end;

procedure TFrmMain.MENU_HELP_REGKEYClick(Sender: TObject);
begin
  FrmRegister := TFrmRegister.Create(Owner);
  FrmRegister.Top := Top + 30;
  FrmRegister.Left := Left;
  FrmRegister.Open();
  FrmRegister.Free;
end;

procedure TFrmMain.QFunctionNPCClick(Sender: TObject);
begin
  if g_FunctionNPC<> nil then begin
    g_FunctionNPC.ClearScript;
    g_FunctionNPC.LoadNpcScript;
    MainOutMessage('QFunction 脚本加载完成...');
  end;
end;

procedure TFrmMain.QManageNPCClick(Sender: TObject);
begin
  if g_ManageNPC <> nil then begin
    g_ManageNPC.ClearScript();
    g_ManageNPC.LoadNpcScript();
    MainOutMessage('重新加载登陆脚本完成...');
  end;
end;

procedure TFrmMain.RobotManageNPCClick(Sender: TObject);
begin
  if g_RobotNPC <> nil then begin
    RobotManage.RELOADROBOT();
    g_RobotNPC.ClearScript();
    g_RobotNPC.LoadNpcScript();
    MainOutMessage('重新加载机器人脚本完成...');
  end;
end;

procedure TFrmMain.MonItemsClick(Sender: TObject);
var
  i: Integer;
  Monster: pTMonInfo;
begin
  try
    for i := 0 to UserEngine.MonsterList.Count - 1 do begin
      Monster := UserEngine.MonsterList.Items[i];
      FrmDB.LoadMonitems(Monster.sName, Monster.ItemList);
    end;
    MainOutMessage('怪物爆物品列表重加载完成...');
  except
    MainOutMessage('怪物爆物品列表重加载失败！！！');
  end;
end;

procedure TFrmMain.NPC1Click(Sender: TObject);
begin
  FrmDB.ReLoadMerchants();
  UserEngine.ReloadMerchantList();
  MainOutMessage('重新加载交易NPC配置信息完成...');
  FrmDB.ReLoadNpc;
  UserEngine.ReloadNpcList();
  MainOutMessage('重新加载管理NPC配置信息完成...');
end;

initialization
  begin
    AddToProcTable(@ChangeCaptionText, Base64DecodeStr('Q2hhbmdlQ2FwdGlvblRleHQ='), 0 {} {'ChangeCaptionText'}); //加入函数列表
    nStartModule := AddToPulgProcTable(Base64DecodeStr('U3RhcnRNb2R1bGU='), 1); //StartModule
    nGetRegisterName := AddToPulgProcTable(Base64DecodeStr('R2V0UmVnaXN0ZXJOYW1l'), 3); //GetRegisterName
    nStartRegister := AddToPulgProcTable(Base64DecodeStr('UmVnaXN0ZXJMaWNlbnNl'), 4); //StartRegister
  end;
finalization
end.


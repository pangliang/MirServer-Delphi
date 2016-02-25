unit SDK;

interface

uses
  Graphics,Windows,Grobal2;

const
  SLAVEMAXLEVEL = 9;

  MAXLEVEL = 500;

  PN_SENDBROADCASTMSG  = 'SendBroadcastMsg'; //

  PN_GETRGB            = 'GetRGB';

  PN_GAMEDATALOG       = 'GameDataLog'; //游戏数据日志

type
  TLevelNeedExp=array[$1..$1F4] of Longword;

  TProcInfo=record 
    nProcAddr: Pointer;
    sProcName: String[30];
  end;

  pTProcInfo=^TProcInfo;

  TObjectInfo=record 
    Obj: TObject;
    sObjcName: String[30];
  end;

  TMsgType=(t_Notice, t_Hint, t_System, t_Say, t_Mon, t_GM, t_Cust, t_Castle);

  TProcArray=array[0..999] of TProcInfo;

  TObjectArray=array[0..999] of TObjectInfo;

  pTProcArray=^TProcArray;

  TMsgProc=procedure(Msg: PChar; nMsgLen: Integer;nMode: Integer);stdcall;
  TFindProc=function(sProcName: PChar; nNameLen: Integer):Pointer;stdcall;
  TFindObj=function(sObjName: PChar; nNameLen: Integer):TObject;stdcall;
  TSetProc=function(ProcAddr: Pointer; ProcName: PChar;nNameLen: Integer): Boolean;stdcall;
  TSendMsg=procedure(Msg: PChar; nLen: Integer);stdcall;
  TPlugInit=function(AppHandle: HWND; MsgProc: TMsgProc;FindProcTable: TFindProc; SetProc: TSetProc; FindObj: TFindObj):PChar;stdcall;
  TClassProc=procedure(Sender: TObject);
  TCheckVersion=function(nVersion: Integer): Boolean;stdcall;
  TIPLocal=procedure(sIPaddr: PChar; sLocal: PChar;nLength: Integer);stdcall;
  TDeCryptString=procedure(Src: PChar; Dest: PChar;nSrc: Integer; var nDest: Integer);stdcall;
  TSendBroadCastMsg=procedure(Msg: PChar; MsgType: TMsgType);stdcall;
  TGetRGB=function(c256: Byte): TColor;stdcall;
  TGameDataLog=function(LogMsg: PChar; nLen: Integer):Boolean;stdcall;
  TGetVersion=function: Single;stdcall;

  TRecallMigic=record 
    nHumLevel: Integer;
    sMonName: String[15];
    nCount: Integer;
    nLevel: Integer;
  end;

  pTRecallMigic=^TRecallMigic;

  TNakedAbility=record 
    DC: Word;
    MC: Word;
    SC: Word;
    AC: Word;
    MAC: Word;
    HP: Word;
    MP: Word;
    Hit: Word;
    Speed: Word;
    X2: Word;
  end;

  pTNakedAbility=^TNakedAbility;

  TGameCmd=record 
    sCmd: String[31];
    nPermissionMin: Word;
    nPermissionMax: Word;
  end;

  pTGameCmd=^TGameCmd;

  TGameCommand=record
    DATA: TGameCmd;
    PRVMSG: TGameCmd;
    ALLOWMSG: TGameCmd;
    LETSHOUT: TGameCmd;
    LETTRADE: TGameCmd;
    LETGUILD: TGameCmd;
    ENDGUILD: TGameCmd;
    BANGUILDCHAT: TGameCmd;
    AUTHALLY: TGameCmd;
    AUTH: TGameCmd;
    AUTHCANCEL: TGameCmd;
    DIARY: TGameCmd;
    USERMOVE: TGameCmd;
    SEARCHING: TGameCmd;
    ALLOWGROUPCALL: TGameCmd;
    GROUPRECALLL: TGameCmd;
    ALLOWGUILDRECALL: TGameCmd;
    GUILDRECALLL: TGameCmd;
    UNLOCKSTORAGE: TGameCmd;
    UNLOCK: TGameCmd;
    LOCK: TGameCmd;
    PASSWORDLOCK: TGameCmd;
    SETPASSWORD: TGameCmd;
    CHGPASSWORD: TGameCmd;
    CLRPASSWORD: TGameCmd;
    UNPASSWORD: TGameCmd;
    MEMBERFUNCTION: TGameCmd;
    MEMBERFUNCTIONEX: TGameCmd;
    DEAR: TGameCmd;
    ALLOWDEARRCALL: TGameCmd;
    DEARRECALL: TGameCmd;
    MASTER: TGameCmd;
    ALLOWMASTERRECALL: TGameCmd;
    MASTERECALL: TGameCmd;
    ATTACKMODE: TGameCmd;
    REST: TGameCmd;
    TAKEONHORSE: TGameCmd;
    TAKEOFHORSE: TGameCmd;
    TAKEREALIVE: TGameCmd;
    HUMANLOCAL: TGameCmd;
    MOVE: TGameCmd;
    POSITIONMOVE: TGameCmd;
    INFO: TGameCmd;
    MOBLEVEL: TGameCmd;
    MOBCOUNT: TGameCmd;
    HUMANCOUNT: TGameCmd;
    MAP: TGameCmd;
    KICK: TGameCmd;
    TING: TGameCmd;
    SUPERTING: TGameCmd;
    MAPMOVE: TGameCmd;
    SHUTUP: TGameCmd;
    RELEASESHUTUP: TGameCmd;
    SHUTUPLIST: TGameCmd;
    GAMEMASTER: TGameCmd;
    OBSERVER: TGameCmd;
    SUEPRMAN: TGameCmd;
    LEVEL: TGameCmd;
    SABUKWALLGOLD: TGameCmd;
    RECALL: TGameCmd;
    REGOTO: TGameCmd;
    SHOWFLAG: TGameCmd;
    SHOWOPEN: TGameCmd;
    SHOWUNIT: TGameCmd;
    ATTACK: TGameCmd;
    MOB: TGameCmd;
    MOBNPC: TGameCmd;
    DELNPC: TGameCmd;
    NPCSCRIPT: TGameCmd;
    RECALLMOB: TGameCmd;
    LUCKYPOINT: TGameCmd;
    LOTTERYTICKET: TGameCmd;
    RELOADGUILD: TGameCmd;
    RELOADLINENOTICE: TGameCmd;
    RELOADABUSE: TGameCmd;
    BACKSTEP: TGameCmd;
    BALL: TGameCmd;
    FREEPENALTY: TGameCmd;
    PKPOINT: TGameCmd;
    INCPKPOINT: TGameCmd;
    CHANGELUCK: TGameCmd;
    HUNGER: TGameCmd;
    HAIR: TGameCmd;
    TRAINING: TGameCmd;
    DELETESKILL: TGameCmd;
    CHANGEJOB: TGameCmd;
    CHANGEGENDER: TGameCmd;
    NAMECOLOR: TGameCmd;
    MISSION: TGameCmd;
    MOBPLACE: TGameCmd;
    TRANSPARECY: TGameCmd;
    DELETEITEM: TGameCmd;
    TAKEUSERITEM: TGameCmd;
    LEVEL0: TGameCmd;
    CLEARMISSION: TGameCmd;
    SETFLAG: TGameCmd;
    SETOPEN: TGameCmd;
    SETUNIT: TGameCmd;
    RECONNECTION: TGameCmd;
    DISABLEFILTER: TGameCmd;
    CHGUSERFULL: TGameCmd;
    CHGZENFASTSTEP: TGameCmd;
    CONTESTPOINT: TGameCmd;
    STARTCONTEST: TGameCmd;
    ENDCONTEST: TGameCmd;
    ANNOUNCEMENT: TGameCmd;
    OXQUIZROOM: TGameCmd;
    GSA: TGameCmd;
    CHANGEITEMNAME: TGameCmd;
    DISABLESENDMSG: TGameCmd;
    ENABLESENDMSG: TGameCmd;
    DISABLESENDMSGLIST: TGameCmd;
    KILL: TGameCmd;
    MAKE: TGameCmd;
    SMAKE: TGameCmd;
    BONUSPOINT: TGameCmd;
    DELBONUSPOINT: TGameCmd;
    RESTBONUSPOINT: TGameCmd;
    FIREBURN: TGameCmd;
    TESTFIRE: TGameCmd;
    TESTSTATUS: TGameCmd;
    DELGOLD: TGameCmd;
    ADDGOLD: TGameCmd;
    DELGAMEGOLD: TGameCmd;
    ADDGAMEGOLD: TGameCmd;
    GAMEGOLD: TGameCmd;
    GAMEPOINT: TGameCmd;
    CREDITPOINT: TGameCmd;
    TESTGOLDCHANGE: TGameCmd;
    REFINEWEAPON: TGameCmd;
    RELOADADMIN: TGameCmd;
    RELOADUSERCMD: TGameCmd;
    RELOADNPC: TGameCmd;
    RELOADMANAGE: TGameCmd;
    RELOADROBOTMANAGE: TGameCmd;
    RELOADROBOT: TGameCmd;
    RELOADMONITEMS: TGameCmd;
    RELOADDIARY: TGameCmd;
    RELOADITEMDB: TGameCmd;
    RELOADMAGICDB: TGameCmd;
    RELOADMONSTERDB: TGameCmd;
    RELOADMINMAP: TGameCmd;
    REALIVE: TGameCmd;
    ADJUESTLEVEL: TGameCmd;
    ADJUESTEXP: TGameCmd;
    ADDGUILD: TGameCmd;
    DELGUILD: TGameCmd;
    CHANGESABUKLORD: TGameCmd;
    FORCEDWALLCONQUESTWAR: TGameCmd;
    ADDTOITEMEVENT: TGameCmd;
    ADDTOITEMEVENTASPIECES: TGameCmd;
    ITEMEVENTLIST: TGameCmd;
    STARTINGGIFTNO: TGameCmd;
    DELETEALLITEMEVENT: TGameCmd;
    STARTITEMEVENT: TGameCmd;
    ITEMEVENTTERM: TGameCmd;
    ADJUESTTESTLEVEL: TGameCmd;
    TRAININGSKILL: TGameCmd;
    OPDELETESKILL: TGameCmd;
    CHANGEWEAPONDURA: TGameCmd;
    RELOADGUILDALL: TGameCmd;
    WHO: TGameCmd;
    TOTAL: TGameCmd;
    TESTGA: TGameCmd;
    MAPINFO: TGameCmd;
    SBKDOOR: TGameCmd;
    CHANGEDEARNAME: TGameCmd;
    CHANGEMASTERNAME: TGameCmd;
    STARTQUEST: TGameCmd;
    SETPERMISSION: TGameCmd;
    CLEARMON: TGameCmd;
    RENEWLEVEL: TGameCmd;
    DENYIPLOGON: TGameCmd;
    DENYACCOUNTLOGON: TGameCmd;
    DENYCHARNAMELOGON: TGameCmd;
    DELDENYIPLOGON: TGameCmd;
    DELDENYACCOUNTLOGON: TGameCmd;
    DELDENYCHARNAMELOGON: TGameCmd;
    SHOWDENYIPLOGON: TGameCmd;
    SHOWDENYACCOUNTLOGON: TGameCmd;
    SHOWDENYCHARNAMELOGON: TGameCmd;
    VIEWWHISPER: TGameCmd;
    SPIRIT: TGameCmd;
    SPIRITSTOP: TGameCmd;
    SETMAPMODE: TGameCmd;
    SHOWMAPMODE: TGameCmd;
    TESTSERVERCONFIG: TGameCmd;
    SERVERSTATUS: TGameCmd;
    TESTGETBAGITEM: TGameCmd;
    CLEARBAG: TGameCmd;
    SHOWUSEITEMINFO: TGameCmd;
    BINDUSEITEM: TGameCmd;
    MOBFIREBURN: TGameCmd;
    TESTSPEEDMODE: TGameCmd;
    LOCKLOGON: TGameCmd;
  end; 
  pTConfig=^TConfig;
  pTThreadInfo=^TThreadInfo;
  TThreadInfo=Record
    dwRunTick       :dword;
    boTerminaled    :boolean;
    nRunTime        :integer;
    nMaxRunTime     :integer;
    boActived       :boolean;
    nRunFlag        :integer;
    Config          :pTConfig;
    hThreadHandle   :THandle;
    dwThreadID      :dword;
  end;

  TConfig=record 
    nConfigSize: Integer;
    sServerName: String[50];
    sServerIPaddr: String[50];
    sRegServerAddr: String[50];
    nRegServerPort: Integer;
    sRegKey: String[50];
    sWebSite: String[100];
    sBbsSite: String[100];
    sClientDownload: String[100];
    sQQ: String[100];
    sPhone: String[100];
    sBankAccount0: String[100];
    sBankAccount1: String[100];
    sBankAccount2: String[100];
    sBankAccount3: String[100];
    sBankAccount4: String[100];
    sBankAccount5: String[100];
    sBankAccount6: String[100];
    sBankAccount7: String[100];
    sBankAccount8: String[100];
    sBankAccount9: String[100];
    nServerNumber           :integer;
    boVentureServer         :boolean;
    boTestServer            :boolean;
    boServiceMode           :boolean;
    boNonPKServer           :boolean;
    boSafeOffline           :boolean;
    boKickOffline           :boolean;
    nTestLevel              :integer;
    nTestGold               :integer;
    nTestUserLimit          :integer;
    nSendBlock              :integer;
    nCheckBlock             :integer;
    boDropLargeBlock        :Boolean;
    nAvailableBlock         :integer;
    nGateLoad               :integer;
    nUserFull               :integer;
    nZenFastStep            :integer;
    sDBName                 :integer;
    sGateAddr               :String[50];
    nGatePort               :integer;
    sDBAddr                 :String[50];
    nDBPort                 :integer;
    sIDSAddr                :String[50];
    nIDSPort                :integer;
    sMsgSrvAddr             :String[50];
    nMsgSrvPort             :integer;
    sLogServerAddr          :String[50];
    nLogServerPort          :integer;
    boDiscountForNightTime  :boolean;
    nHalfFeeStart           :integer;
    nHalfFeeEnd             :integer;
    boViewHackMessage       :Boolean;
    boViewAdmissionFailure  :Boolean;
    sBaseDir                :String[80];
    sGuildDir               :String[80];
    sGuildFile              :String[80];
    sVentureDir             :String[80];
    sConLogDir              :String[80];
    sCastleDir              :String[80];
    sCastleFile             :String[80];
    sEnvirDir               :String[80];
    sMapDir                 :String[80];
    sNoticeDir              :String[80];
    sLogDir                 :String[80];
    sPlugDir                :String[80];
    sClientFile1            :String[8];
    sClientFile2            :String[8];
    sClientFile3            :String[8];
    sClothsMan              :String[14];
    sClothsWoman            :String[14];
    sWoodenSword            :String[14];
    sCandle                 :String[14];
    sBasicDrug              :String[14];
    sGoldStone              :String[14];
    sSilverStone            :String[14];
    sSteelStone             :String[14];
    sCopperStone            :String[14];
    sBlackStone             :String[14];
    sGemStone1              :String[14];
    sGemStone2              :String[14];
    sGemStone3              :String[14];
    sGemStone4              :String[14];
    sZuma                   :Array[0..3] of String[14];
    sBee                    :String[14];
    sSpider                 :String[14];
    sWomaHorn               :String[14];
    sZumaPiece              :String[14];
    sGameGoldName           :String[14];
    sGamePointName          :String[14];
    sPayMentPointName       :String;
    DBSocket                :integer;
    nHealthFillTime         :integer;
    nSpellFillTime          :integer;
    nMonUpLvNeedKillBase    :integer;
    nMonUpLvRate            :integer;
    MonUpLvNeedKillCount    :Array[0..7] of integer;
    SlaveColor              :Array[0..8] of Byte;
    dwNeedExps              :TLevelNeedExp;
    WideAttack              :Array[0..2] of Byte;
    CrsAttack               :Array [0..6] of Byte;
    SpitMap                 :array[0..7] of array[0..4] of array[0..4] of Byte;
    sHomeMap                :String[20];
    nHomeX                  :integer;
    nHomeY                  :integer;
    sRedHomeMap             :String[20];
    nRedHomeX               :integer;
    nRedHomeY               :integer;
    sRedDieHomeMap          :String[20];
    nRedDieHomeX            :integer;
    nRedDieHomeY            :integer;
    boJobHomePoint          :Boolean;
    sWarriorHomeMap         :String;
    nWarriorHomeX           :integer;
    nWarriorHomeY           :integer;
    sWizardHomeMap          :String;
    nWizardHomeX            :integer;
    nWizardHomeY            :integer;
    sTaoistHomeMap          :String;
    nTaoistHomeX            :integer;
    nTaoistHomeY            :integer;
    dwDecPkPointTime        :dword;
    nDecPkPointCount        :integer;
    dwPKFlagTime            :dword;
    nKillHumanAddPKPoint    :integer;
    nKillHumanDecLuckPoint  :integer;
    dwDecLightItemDrugTime  :dword;
    nSafeZoneSize           :integer;
    nStartPointSize         :integer;
    dwHumanGetMsgTime       :dword;
    nGroupMembersMax        :integer;
    sFireBallSkill          :String[15];
    sHealSkill              :String[15];
//    sRingSkill              :Array[0..10] of String[12];
    ReNewNameColor          :Array[0..9] of byte;
    dwReNewNameColorTime    :dword;
    boReNewChangeColor      :boolean;
    boReNewLevelClearExp    :boolean;
    BonusAbilofWarr         :TNakedAbility;
    BonusAbilofWizard       :TNakedAbility;
    BonusAbilofTaos         :TNakedAbility;
    NakedAbilofWarr         :TNakedAbility;
    NakedAbilofWizard       :TNakedAbility;
    NakedAbilofTaos         :TNakedAbility;
    nUpgradeWeaponMaxPoint  :integer;
    nUpgradeWeaponPrice     :integer;
    dwUPgradeWeaponGetBackTime     :dword;
    nClearExpireUpgradeWeaponDays  :integer;
    nUpgradeWeaponDCRate           :integer;
    nUpgradeWeaponDCTwoPointRate   :integer;
    nUpgradeWeaponDCThreePointRate :integer;
    nUpgradeWeaponSCRate           :integer;
    nUpgradeWeaponSCTwoPointRate   :integer;
    nUpgradeWeaponSCThreePointRate :integer;
    nUpgradeWeaponMCRate           :integer;
    nUpgradeWeaponMCTwoPointRate   :integer;
    nUpgradeWeaponMCThreePointRate :integer;
    dwProcessMonstersTime          :dword;
    dwRegenMonstersTime            :dword;
    nMonGenRate                    :integer;
    nProcessMonRandRate            :integer;
    nProcessMonLimitCount          :integer;
    nSoftVersionDate               :integer;
    boCanOldClientLogon            :boolean;
    dwConsoleShowUserCountTime     :dword;
    dwShowLineNoticeTime           :dword;
    nLineNoticeColor               :integer;
    nStartCastleWarDays            :integer;
    nStartCastlewarTime            :integer;
    dwShowCastleWarEndMsgTime      :dword;
    dwCastleWarTime                :dword;
    dwGetCastleTime                :dword;
    dwGuildWarTime                 :dword;
    nBuildGuildPrice               :integer;
    nGuildWarPrice                 :integer;
    nMakeDurgPrice                 :integer;
    nHumanMaxGold                  :integer;
    nHumanTryModeMaxGold           :integer;
    nTryModeLevel                  :integer;
    boTryModeUseStorage            :boolean;
    nCanShoutMsgLevel              :integer;
    boShowMakeItemMsg              :boolean;
    boShutRedMsgShowGMName         :boolean;
    nSayMsgMaxLen                  :integer;
    dwSayMsgTime                   :dword;
    nSayMsgCount                   :integer;
    dwDisableSayMsgTime            :dword;
    nSayRedMsgMaxLen               :integer;
    boShowGuildName                :boolean;
    boShowRankLevelName            :boolean;
    boMonSayMsg                    :boolean;
    nStartPermission               :integer;
    boKillHumanWinLevel            :boolean;
    boKilledLostLevel              :boolean;
    boKillHumanWinExp              :boolean;
    boKilledLostExp                :boolean;
    nKillHumanWinLevel             :integer;
    nKilledLostLevel               :integer;
    nKillHumanWinExp               :integer;
    nKillHumanLostExp              :integer;
    nHumanLevelDiffer              :integer;
    nMonsterPowerRate              :integer;
    nItemsPowerRate                :integer;
    nItemsACPowerRate              :integer;
    boSendOnlineCount              :boolean;
    nSendOnlineCountRate           :integer;
    dwSendOnlineTime               :dword;
    dwSaveHumanRcdTime             :dword;
    dwHumanFreeDelayTime           :dword;
    dwMakeGhostTime                :dword;
    dwClearDropOnFloorItemTime     :dword;
    dwFloorItemCanPickUpTime       :dword;
    boPasswordLockSystem           :boolean;  //是否启用密码保护系统
    boLockDealAction               :boolean;  //是否锁定交易操作
    boLockDropAction               :boolean;  //是否锁定扔物品操作
    boLockGetBackItemAction        :boolean;  //是否锁定取仓库操作
    boLockHumanLogin               :boolean;  //是否锁定走操作
    boLockWalkAction               :boolean;  //是否锁定走操作
    boLockRunAction                :boolean;  //是否锁定跑操作
    boLockHitAction                :boolean;  //是否锁定攻击操作
    boLockSpellAction              :boolean;  //是否锁定魔法操作
    boLockSendMsgAction            :boolean;  //是否锁定发信息操作
    boLockUserItemAction           :boolean;  //是否锁定使用物品操作
    boLockInObModeAction           :boolean;  //锁定时进入隐身状态
    nPasswordErrorCountLock        :integer;  //输入密码错误超过 指定次数则锁定密码
    boPasswordErrorKick            :boolean;  //输入密码错误超过限制则踢下线
    nSendRefMsgRange               :integer;
    boDecLampDura                  :boolean;
    boHungerSystem                 :boolean;
    boHungerDecHP                  :boolean;
    boHungerDecPower               :boolean;
    boDiableHumanRun               :boolean;
    boRunHuman                     :boolean;
    boRunMon                       :boolean;
    boRunNpc                       :boolean;
    boRunGuard                     :boolean;
    boWarDisHumRun                 :boolean;
    boGMRunAll                     :boolean;
    boSafeZoneRunAll               :Boolean;
    boMoveCanDupObj                :Boolean;
    dwTryDealTime                  :dword;
    dwDealOKTime                   :dword;
    boCanNotGetBackDeal            :boolean;
    boDisableDeal                  :boolean;
    nMasterOKLevel                 :integer;
    nMasterOKCreditPoint           :integer;
    nMasterOKBonusPoint            :integer;
    boPKLevelProtect               :boolean;
    nPKProtectLevel                :integer;
    nRedPKProtectLevel             :integer;
    nItemPowerRate                 :integer;
    nItemExpRate                   :integer;
    nItemAcRate                    :integer;
    nItemMacRate                   :integer;
    nScriptGotoCountLimit          :integer;
    btHearMsgFColor                :byte; //前景
    btHearMsgBColor                :byte; //背景
    btWhisperMsgFColor             :byte; //前景
    btWhisperMsgBColor             :byte; //背景
    btGMWhisperMsgFColor           :byte; //前景
    btGMWhisperMsgBColor           :byte; //背景
    btCryMsgFColor                 :byte; //前景
    btCryMsgBColor                 :byte; //背景
    btGreenMsgFColor               :byte; //前景
    btGreenMsgBColor               :byte; //背景
    btBlueMsgFColor                :byte; //前景
    btBlueMsgBColor                :byte; //背景
    btRedMsgFColor                 :byte; //前景
    btRedMsgBColor                 :byte; //背景
    btGuildMsgFColor               :byte; //前景
    btGuildMsgBColor               :byte; //背景
    btGroupMsgFColor               :byte; //前景
    btGroupMsgBColor               :byte; //背景
    btCustMsgFColor                :byte; //前景
    btCustMsgBColor                :byte; //背景
    nMonRandomAddValue             :integer;
    nMakeRandomAddValue            :integer;
    nWeaponDCAddValueMaxLimit      :integer;
    nWeaponDCAddValueRate          :integer;
    nWeaponMCAddValueMaxLimit      :integer;
    nWeaponMCAddValueRate          :integer;
    nWeaponSCAddValueMaxLimit      :integer;
    nWeaponSCAddValueRate          :integer;
    nDressDCAddRate                :integer;
    nDressDCAddValueMaxLimit       :integer;
    nDressDCAddValueRate           :integer;
    nDressMCAddRate                :integer;
    nDressMCAddValueMaxLimit       :integer;
    nDressMCAddValueRate           :integer;
    nDressSCAddRate                :integer;
    nDressSCAddValueMaxLimit       :integer;
    nDressSCAddValueRate           :integer;
    nNeckLace202124DCAddRate                    :integer;
    nNeckLace202124DCAddValueMaxLimit           :integer;
    nNeckLace202124DCAddValueRate               :integer;
    nNeckLace202124MCAddRate                    :integer;
    nNeckLace202124MCAddValueMaxLimit           :integer;
    nNeckLace202124MCAddValueRate               :integer;
    nNeckLace202124SCAddRate                    :integer;
    nNeckLace202124SCAddValueMaxLimit           :integer;
    nNeckLace202124SCAddValueRate               :integer;
    nNeckLace19DCAddRate                    :integer;
    nNeckLace19DCAddValueMaxLimit           :integer;
    nNeckLace19DCAddValueRate               :integer;
    nNeckLace19MCAddRate                    :integer;
    nNeckLace19MCAddValueMaxLimit           :integer;
    nNeckLace19MCAddValueRate               :integer;
    nNeckLace19SCAddRate                    :integer;
    nNeckLace19SCAddValueMaxLimit           :integer;
    nNeckLace19SCAddValueRate               :integer;
    nArmRing26DCAddRate                    :integer;
    nArmRing26DCAddValueMaxLimit           :integer;
    nArmRing26DCAddValueRate               :integer;
    nArmRing26MCAddRate                    :integer;
    nArmRing26MCAddValueMaxLimit           :integer;
    nArmRing26MCAddValueRate               :integer;
    nArmRing26SCAddRate                    :integer;
    nArmRing26SCAddValueMaxLimit           :integer;
    nArmRing26SCAddValueRate               :integer;
    nRing22DCAddRate                    :integer;
    nRing22DCAddValueMaxLimit           :integer;
    nRing22DCAddValueRate               :integer;
    nRing22MCAddRate                    :integer;
    nRing22MCAddValueMaxLimit           :integer;
    nRing22MCAddValueRate               :integer;
    nRing22SCAddRate                    :integer;
    nRing22SCAddValueMaxLimit           :integer;
    nRing22SCAddValueRate               :integer;
    nRing23DCAddRate                    :integer;
    nRing23DCAddValueMaxLimit           :integer;
    nRing23DCAddValueRate               :integer;
    nRing23MCAddRate                    :integer;
    nRing23MCAddValueMaxLimit           :integer;
    nRing23MCAddValueRate               :integer;
    nRing23SCAddRate                    :integer;
    nRing23SCAddValueMaxLimit           :integer;
    nRing23SCAddValueRate               :integer;
    nHelMetDCAddRate                    :integer;
    nHelMetDCAddValueMaxLimit           :integer;
    nHelMetDCAddValueRate               :integer;
    nHelMetMCAddRate                    :integer;
    nHelMetMCAddValueMaxLimit           :integer;
    nHelMetMCAddValueRate               :integer;
    nHelMetSCAddRate                    :integer;
    nHelMetSCAddValueMaxLimit           :integer;
    nHelMetSCAddValueRate               :integer;
    nUnknowHelMetACAddRate              :integer;
    nUnknowHelMetACAddValueMaxLimit     :integer;
    nUnknowHelMetMACAddRate             :integer;
    nUnknowHelMetMACAddValueMaxLimit    :integer;
    nUnknowHelMetDCAddRate              :integer;
    nUnknowHelMetDCAddValueMaxLimit     :integer;
    nUnknowHelMetMCAddRate              :integer;
    nUnknowHelMetMCAddValueMaxLimit     :integer;
    nUnknowHelMetSCAddRate              :integer;
    nUnknowHelMetSCAddValueMaxLimit     :integer;
    nUnknowRingACAddRate                :integer;
    nUnknowRingACAddValueMaxLimit       :integer;
    nUnknowRingMACAddRate               :integer;
    nUnknowRingMACAddValueMaxLimit      :integer;
    nUnknowRingDCAddRate                :integer;
    nUnknowRingDCAddValueMaxLimit       :integer;
    nUnknowRingMCAddRate                :integer;
    nUnknowRingMCAddValueMaxLimit       :integer;
    nUnknowRingSCAddRate                :integer;
    nUnknowRingSCAddValueMaxLimit       :integer;
    nUnknowNecklaceACAddRate            :integer;
    nUnknowNecklaceACAddValueMaxLimit   :integer;
    nUnknowNecklaceMACAddRate           :integer;
    nUnknowNecklaceMACAddValueMaxLimit  :integer;
    nUnknowNecklaceDCAddRate            :integer;
    nUnknowNecklaceDCAddValueMaxLimit   :integer;
    nUnknowNecklaceMCAddRate            :integer;
    nUnknowNecklaceMCAddValueMaxLimit   :integer;
    nUnknowNecklaceSCAddRate            :integer;
    nUnknowNecklaceSCAddValueMaxLimit   :integer;
    nMonOneDropGoldCount                :integer;
    boDropGoldToPlayBag                 :boolean;
    nMakeMineHitRate                    :integer; //挖矿命中率
    nMakeMineRate                       :integer; //挖矿率
    nStoneTypeRate                      :integer;
    nStoneTypeRateMin                   :integer;
    nGoldStoneMin                       :integer;
    nGoldStoneMax                       :integer;
    nSilverStoneMin                     :integer;
    nSilverStoneMax                     :integer;
    nSteelStoneMin                      :integer;
    nSteelStoneMax                      :integer;
    nBlackStoneMin                      :integer;
    nBlackStoneMax                      :integer;
    nStoneMinDura                       :integer;
    nStoneGeneralDuraRate               :integer;
    nStoneAddDuraRate                   :integer;
    nStoneAddDuraMax                    :integer;
    nWinLottery6Min                     :integer;
    nWinLottery6Max                     :integer;
    nWinLottery5Min                     :integer;
    nWinLottery5Max                     :integer;
    nWinLottery4Min                     :integer;
    nWinLottery4Max                     :integer;
    nWinLottery3Min                     :integer;
    nWinLottery3Max                     :integer;
    nWinLottery2Min                     :integer;
    nWinLottery2Max                     :integer;
    nWinLottery1Min                     :integer;
    nWinLottery1Max                     :integer;//16180 + 1820;
    nWinLottery1Gold                    :integer;
    nWinLottery2Gold                    :integer;
    nWinLottery3Gold                    :integer;
    nWinLottery4Gold                    :integer;
    nWinLottery5Gold                    :integer;
    nWinLottery6Gold                    :integer;
    nWinLotteryRate                     :integer;
    nWinLotteryCount                    :integer;
    nNoWinLotteryCount                  :integer;
    nWinLotteryLevel1                   :integer;
    nWinLotteryLevel2                   :integer;
    nWinLotteryLevel3                   :integer;
    nWinLotteryLevel4                   :integer;
    nWinLotteryLevel5                   :integer;
    nWinLotteryLevel6                   :integer;
    GlobalVal                           :Array[0..19] of integer;
    nItemNumber                         :integer;
    nItemNumberEx                       :integer;
    nGuildRecallTime                    :integer;
    nGroupRecallTime                    :integer;
    boControlDropItem                   :boolean;
    boInSafeDisableDrop                 :boolean;
    nCanDropGold                        :integer;
    nCanDropPrice                       :integer;
    boSendCustemMsg                     :boolean;
    boSubkMasterSendMsg                 :boolean;
    nSuperRepairPriceRate               :integer; //特修价格倍数
    nRepairItemDecDura                  :integer; //普通修理掉持久数(特持久上限减下限再除以此数为减的数值)
    boDieScatterBag                     :boolean;
    nDieScatterBagRate                  :integer;
    boDieRedScatterBagAll               :boolean;
    nDieDropUseItemRate                 :integer;
    nDieRedDropUseItemRate              :integer;
    boDieDropGold                       :boolean;
    boKillByHumanDropUseItem            :boolean;
    boKillByMonstDropUseItem            :boolean;
    boKickExpireHuman                   :boolean;
    nGuildRankNameLen                   :integer;
    nGuildMemberMaxLimit                :integer;
    nGuildNameLen                       :integer;
    nCastleNameLen                      :Integer;
    nAttackPosionRate                   :integer;
    nAttackPosionTime                   :integer;
    dwRevivalTime                       :dword; //复活间隔时间
    boUserMoveCanDupObj                 :boolean;
    boUserMoveCanOnItem                 :boolean;
    dwUserMoveTime                      :integer;
    dwPKDieLostExpRate                  :integer;
    nPKDieLostLevelRate                 :integer;
    btPKFlagNameColor                   :Byte;
    btPKLevel1NameColor                 :Byte;
    btPKLevel2NameColor                 :Byte;
    btAllyAndGuildNameColor             :Byte;
    btWarGuildNameColor                 :Byte;
    btInFreePKAreaNameColor             :Byte;
    boSpiritMutiny                      :boolean;
    dwSpiritMutinyTime                  :dword;
    nSpiritPowerRate                    :integer;
    boMasterDieMutiny                   :boolean;
    nMasterDieMutinyRate                :integer;
    nMasterDieMutinyPower               :integer;
    nMasterDieMutinySpeed               :integer;
    boBBMonAutoChangeColor              :boolean;
    dwBBMonAutoChangeColorTime          :integer;
    boOldClientShowHiLevel              :boolean;
    boShowScriptActionMsg               :boolean;
    nRunSocketDieLoopLimit              :integer;
    boThreadRun                         :boolean;
    boShowExceptionMsg                  :boolean;
    boShowPreFixMsg                     :boolean;
    nMagicAttackRage                    :integer; //魔法锁定范围
    sBoneFamm                           :String[14];
    nBoneFammCount                      :integer;
    BoneFammArray                       :array[0..9] of TRecallMigic;
    sDogz                               :String[14];
    nDogzCount                          :integer;
    DogzArray                           :array[0..9] of TRecallMigic;
    sAngel                              :String[14];
    nAmyOunsulPoint                     :integer;
    boDisableInSafeZoneFireCross        :boolean;
    boGroupMbAttackPlayObject           :boolean;
    dwPosionDecHealthTime               :dword;
    nPosionDamagarmor                   :integer;//中红毒着持久及减防量（实际大小为 12 / 10）
    boLimitSwordLong                    :boolean;
    nSwordLongPowerRate                 :integer;
    nFireBoomRage                       :integer;
    nSnowWindRange                      :integer;
    nEditFireRage                       :integer;
    nElecBlizzardRange                  :integer;
    nMagTurnUndeadLevel                 :integer; //圣言怪物等级限制
    nMagTammingLevel                    :integer; //诱惑之光怪物等级限制
    nMagTammingTargetLevel              :integer; //诱惑怪物相差等级机率，此数字越小机率越大；
    nMagTammingHPRate                   :integer; //成功机率=怪物最高HP 除以 此倍率，此倍率越大诱惑机率越高
    nMagTammingCount                    :integer;
    nMabMabeHitRandRate                 :integer;
    nMabMabeHitMinLvLimit               :integer;
    nMabMabeHitSucessRate               :integer;
    nMabMabeHitMabeTimeRate             :integer;
    sCastleName                         :String[20];
    sCastleHomeMap                      :String[16];
    nCastleHomeX                        :integer;
    nCastleHomeY                        :integer;
    nCastleWarRangeX                    :integer;
    nCastleWarRangeY                    :integer;
    nCastleTaxRate                      :integer;
    boGetAllNpcTax                      :boolean;
    nHireGuardPrice                     :integer;
    nHireArcherPrice                    :integer;
    nCastleGoldMax                      :integer;
    nCastleOneDayGold                   :integer;
    nRepairDoorPrice                    :integer;
    nRepairWallPrice                    :integer;
    nCastleMemberPriceRate              :integer;
    nMaxHitMsgCount                     :integer;
    nMaxSpellMsgCount                   :integer;
    nMaxRunMsgCount                     :integer;
    nMaxWalkMsgCount                    :integer;
    nMaxTurnMsgCount                    :integer;
    nMaxSitDonwMsgCount                 :integer;
    nMaxDigUpMsgCount                   :integer;
    boSpellSendUpdateMsg                :boolean;
    boActionSendActionMsg               :boolean;
    boKickOverSpeed                     :boolean;
    btSpeedControlMode                  :integer;
    nOverSpeedKickCount                 :integer;
    dwDropOverSpeed                     :dword;
    dwHitIntervalTime                   :dword; //攻击间隔
    dwMagicHitIntervalTime              :dword; //魔法间隔
    dwRunIntervalTime                   :dword; //跑步间隔
    dwWalkIntervalTime                  :dword; //走路间隔
    dwTurnIntervalTime                  :dword; //换方向间隔
    boControlActionInterval             :boolean;
    boControlWalkHit                    :boolean;
    boControlRunLongHit                 :boolean;
    boControlRunHit                     :boolean;
    boControlRunMagic                   :boolean;
    dwActionIntervalTime                :dword; //组合操作间隔
    dwRunLongHitIntervalTime            :dword; //跑位刺杀间隔
    dwRunHitIntervalTime                :dword; //跑位攻击间隔
    dwWalkHitIntervalTime               :dword; //走位攻击间隔
    dwRunMagicIntervalTime              :dword; //跑位魔法间隔
    boDisableStruck                     :boolean; //不显示人物弯腰动作
    boDisableSelfStruck                 :boolean; //自己不显示人物弯腰动作
    dwStruckTime                        :dword; //人物弯腰停留时间
    dwKillMonExpMultiple                :dword; //杀怪经验倍数
    dwRequestVersion                    :dword;
    boHighLevelKillMonFixExp            :boolean;
    boHighLevelGroupFixExp              :Boolean;
    boAddUserItemNewValue               :boolean;
    sLineNoticePreFix                   :String[20];
    sSysMsgPreFix                       :String[20];
    sGuildMsgPreFix                     :String[20];
    sGroupMsgPreFix                     :String[20];
    sHintMsgPreFix                      :String[20];
    sGMRedMsgpreFix                     :String[20];
    sMonSayMsgpreFix                    :String[20];
    sCustMsgpreFix                      :String[20];
    sCastleMsgpreFix                    :String[20];
    sGuildNotice                        :String[20];
    sGuildWar                           :String[20];
    sGuildAll                           :String[20];
    sGuildMember                        :String[20];
    sGuildMemberRank                    :String[20];
    sGuildChief                         :String[20];
    boKickAllUser                       :boolean;
    boTestSpeedMode                     :boolean;
    ClientConf                          :TClientConf;
    nWeaponMakeUnLuckRate               :integer;
    nWeaponMakeLuckPoint1               :integer;
    nWeaponMakeLuckPoint2               :integer;
    nWeaponMakeLuckPoint3               :integer;
    nWeaponMakeLuckPoint2Rate           :integer;
    nWeaponMakeLuckPoint3Rate           :integer;
    boCheckUserItemPlace                :boolean;
    nClientKey                          :integer;
    nLevelValueOfTaosHP                 :integer;
    nLevelValueOfTaosHPRate             :double;
    nLevelValueOfTaosMP                 :integer;
    nLevelValueOfWizardHP               :integer;
    nLevelValueOfWizardHPRate           :double;
    nLevelValueOfWarrHP                 :integer;
    nLevelValueOfWarrHPRate             :double;
    nProcessMonsterInterval             :integer;
    boCheckFail                         :Boolean;
    nAppIconCrc                         :integer;
    boIDSocketConnected                 :Boolean;
    UserIDSection                       :TRTLCriticalSection;
    sIDSocketRecvText                   :String;
    IDSocket                            :integer;
    nIDSocketRecvIncLen                 :integer;
    nIDSocketRecvMaxLen                 :integer;
    nIDSocketRecvCount                  :integer;
    nIDReceiveMaxTime                   :integer;
    nIDSocketWSAErrCode                 :integer;
    nIDSocketErrorCount                 :integer;
    nLoadDBCount                        :integer;
    nLoadDBErrorCount                   :integer;
    nSaveDBCount                        :integer;
    nDBQueryID                          :integer;
    UserEngineThread                    :TThreadInfo;
    IDSocketThread                      :TThreadInfo;
    DBSocketThread                      :TThreadInfo;
    boDBSocketConnected                 :boolean;
    nDBSocketRecvIncLen                 :integer;
    nDBSocketRecvMaxLen                 :integer;
    sDBSocketRecvText                   :String;
    boDBSocketWorking                   :boolean;
    nDBSocketRecvCount                  :integer;
    nDBReceiveMaxTime                   :integer;
    nDBSocketWSAErrCode                 :integer;
    nDBSocketErrorCount                 :integer;
    nServerFile_CRCB                    :integer;
    nClientFile1_CRC                    :integer;
    nClientFile2_CRC                    :integer;
    nClientFile3_CRC                    :integer;
    GlobaDyMval                         :array[0..99] of Integer;
    nM2Crc                              :integer;
    nCheckLicenseFail                   :integer;
    dwCheckTick                         :LongWord;
    nCheckFail                          :Integer;
    boSendCurTickCount                  :Boolean;
    dwSendWhisperTime                   :LongWord;
    nSendWhisperPlayCount               :Integer;
    nProcessTick                        :integer;
    nProcessTime                        :integer;
    nDBSocketSendLen                    :Integer;
    boMagicFireDamageSpell              :Boolean;
    boMagCapturePlayer                  :Boolean;
  end;


implementation

end.
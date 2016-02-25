unit ObjBase;

interface
uses
  Windows, Classes, SysUtils, Forms, StrUtils, Math, Grobal2, Envir, Common;

type
  TClientAction = (cHit, cMagHit, cRun, cWalk, cDigUp, cTurn);
  //  TSayMsgType = (s_NoneMsg,s_GroupMsg,s_GuildMsg,s_SystemMsg,s_NoticeMsg);
  TGender = (gMan, gWoMan);
  TJob = (jWarr, jWizard, jTaos);
  PTBaseObject = ^TBaseObject;
  TBaseObject = class
    m_sMapName: string[16]; //0x04
    m_sCharName: string[14]; //0x15
    m_nCurrX: Integer; //0x24  人物所在座标X(4字节)
    m_nCurrY: Integer; //0x28  人物所在座标Y(4字节)
    m_btDirection: Byte; //    人物所在方向(1字节)
    m_btGender: Byte; //0x2D  人物的性别(1字节)
    m_btHair: Byte; //0x2E  人物的头发(1字节)
    m_btJob: Byte; //0x2F  人物的职业(1字节)
    m_nGold: Integer; //0x30  人物金币数(4字节)
    m_Abil: TAbility; //0x34 -> 0x5B
    m_nCharStatus: Integer; //0x5C
    m_sHomeMap: string[16]; //0x78  //回城地图
    m_nHomeX: Integer; //0x8C  //回城座标X
    m_nHomeY: Integer; //0x90  //回城座标Y
    bo94: Boolean; //0x94
    m_boOnHorse: Boolean; //0x95
    m_btHorseType: Byte;
    m_btDressEffType: Byte;
    n98: Integer; //0x98
    n9C: Integer; //0x9C
    nA0: Integer; //0xA0
    nA4: Integer; //0xA4
    nA8: Integer; //0xA8
    m_nPkPoint: Integer; //0xAC  人物的PK值(4字节)
    m_boAllowGroup: Boolean; //0xB0  允许组队
    m_boAllowGuild: Boolean; //0xB1  允许加入行会
    btB2: Byte; //0xB2
    btB3: Byte; //0xB3
    m_nIncHealth: Integer; //0x0B4
    m_nIncSpell: Integer; //0x0B8
    m_nIncHealing: Integer; //0x0BC
    m_nFightZoneDieCount: Integer; //0x0C0  //在行会占争地图中死亡次数
    nC4: Integer;
    btC8: Byte; //0xC8
    btC9: Byte; //0xC9
    m_BonusAbil: TNakedAbility; //0x0CA TNakedAbility
    m_CurBonusAbil: TNakedAbility; //0x0DE
    m_nBonusPoint: Integer; //0x0F4
    m_nHungerStatus: Integer; //0x0F8
    m_boAllowGuildReCall: Boolean; //0xFC
    //      btFC               :Byte;
    m_btFD: Byte;
    m_btFE: Byte;
    m_btFF: Byte;
    m_dBodyLuck: Double; //0x100
    m_nBodyLuckLevel: Integer; //0x108
    m_wGroupRcallTime: Word; //0x10C
    m_boAllowGroupReCall: Boolean; //0x10E

    m_QuestUnitOpen: TQuestUnit; //0x10F
    m_QuestUnit: TQuestUnit; //0x11C
    m_QuestFlag: TQuestFlag; //0x128 129

    m_nCharStatusEx: Integer;
    m_dwFightExp: LongWord; //0x194   //怪物经验值
    m_WAbil: TAbility; //0x198
    m_AddAbil: TAddAbility; //0x1C0
    m_nViewRange: Integer; //0x1E4   //可视范围大小
    m_wStatusTimeArr: TStatusTime; //0x60
    m_dwStatusArrTick: array[0..MAX_STATUS_ATTRIBUTE - 1] of LongWord; //0x1E8
    //m_boStatus: Boolean; //人物属性TRUE =上升 FALSE =下降
    m_boAC: Boolean;
    m_boMAC: Boolean;
    m_boDC: Boolean;
    m_boMC: Boolean;
    m_boSC: Boolean;
    m_boHitSpeed: Boolean;
    m_boMaxHP: Boolean;
    m_boMaxMP: Boolean;
    m_wStatusArrValue: array[0..5] of Word; //0x218
    m_dwStatusArrTimeOutTick: array[0..5] of LongWord; // :Tarry220;           //0x220
    m_wAppr: Word; //0x238
    m_btRaceServer: Byte; //0x23A   //角色类型
    m_btRaceImg: Byte; //0x23B   //角色外形
    m_btHitPoint: Byte; //0x23C   人物攻击准确度(Byte)
    m_nHitPlus: ShortInt; //0x23D
    m_nHitDouble: ShortInt; //0x23E
    m_dwGroupRcallTick: LongWord; //0x240  记忆使用间隔(Dword)
    m_boRecallSuite: Boolean; //0x244  记忆全套
    bo245: Boolean; //0x245
    m_boTestGa: Boolean; //0x246  //是否输入Testga 命令
    m_boGsa: Boolean; //0x247  //是否输入gsa 命令
    m_nHealthRecover: ShortInt; //0x248
    m_nSpellRecover: ShortInt; //0x249
    m_btAntiPoison: Byte; //0x24A
    m_nPoisonRecover: ShortInt; //0x24B
    m_nAntiMagic: ShortInt; //0x24C
    m_nLuck: Integer; //0x250  人物的幸运值Luck
    m_nPerHealth: Integer; //0x254
    m_nPerHealing: Integer; //0x258
    m_nPerSpell: Integer; //0x25C
    m_dwIncHealthSpellTick: LongWord; //0x260
    m_btGreenPoisoningPoint: Byte; //0x264  中绿毒降HP点数
    m_nGoldMax: Integer; //0x268  人物身上最多可带金币数(Dword)
    m_btSpeedPoint: Byte; //0x26C  人物敏捷度(Byte)
    m_btPermission: Byte; //0x26D  人物权限等级
    m_nHitSpeed: ShortInt; //0x26E  //1-18 更改数据类型
    m_btLifeAttrib: Byte; //0x26F
    m_btCoolEye: Byte; //0x270
    m_GroupOwner: TBaseObject; //0x274
    m_GroupMembers: TStringList; //0x278  组成员
    m_boHearWhisper: Boolean; //0x27C  允许私聊
    m_boBanShout: Boolean; //0x27D  允许群聊
    m_boBanGuildChat: Boolean; //0x27E  拒绝行会聊天
    m_boAllowDeal: Boolean; //0x27F  是不允许交易
    m_BlockWhisperList: TStringList; //0x280  禁止私聊人员列表
    m_dwShoutMsgTick: LongWord; //0x284
    m_Master: TBaseObject; //0x288  是否被召唤(主人)
    m_dwMasterRoyaltyTick: LongWord; //0x28C  怪物叛变时间
    m_dwMasterTick: LongWord; //0x290
    n294: Integer; //0x294  杀怪计数
    m_btSlaveExpLevel: Byte; //0x298  宝宝等级 1-7
    m_btSlaveMakeLevel: Byte; //0x299  召唤等级
    m_SlaveList: TList; //0x29C  下属列表
    bt2A0: Byte; //0x2A0
    m_boSlaveRelax: Boolean; //0x2A0  宝宝攻击状态(休息/攻击)(Byte)
    m_btAttatckMode: Byte; //0x2A1  下属攻击状态
    m_btNameColor: Byte; //0x2A2  人物名字的颜色(Byte)
    m_nLight: Integer; //0x2A4  亮度
    m_boGuildWarArea: Boolean; //0x2A8  行会占争范围
    m_Castle: TObject; //0x2AC //所属城堡
    bo2B0: Boolean; //0x2B0
    m_dw2B4Tick: LongWord; //0x2B4
    m_boSuperMan: Boolean; //0x2B8  无敌模式
    bo2B9: Boolean; //0x2B9
    bo2BA: Boolean; //0x2BA
    m_boAnimal: Boolean; //0x2BB
    m_boNoItem: Boolean; //0x2BC
    m_boFixedHideMode: Boolean; //0x2BD
    m_boStickMode: Boolean; //0x2BE
    bo2BF: Boolean; //0x2BF
    m_boNoAttackMode: Boolean; //0x2C0
    bo2C1: Boolean; //0x2C1
    m_boSkeleton: Boolean; //0x2C2
    m_nMeatQuality: Integer; //0x2C4
    m_nBodyLeathery: Integer; //0x2C8
    m_boHolySeize: Boolean; //0x2CC
    m_dwHolySeizeTick: LongWord; //0x2D0
    m_dwHolySeizeInterval: LongWord; //0x2D4
    m_boCrazyMode: Boolean; //0x2D8
    m_dwCrazyModeTick: LongWord; //0x2DC
    m_dwCrazyModeInterval: LongWord; //0x2E0
    m_boShowHP: Boolean; //0x2E4
    //      nC2E6                   :Integer;      //0x2E6
    m_dwShowHPTick: LongWord; //0x2E8  心灵启示检查时间(Dword)
    m_dwShowHPInterval: LongWord; //0x2EC  心灵启示有效时长(Dword)
    bo2F0: Boolean; //0x2F0
    m_dwDupObjTick: LongWord; //0x2F4
    m_PEnvir: TEnvirnoment; //0x2F8
    m_boGhost: Boolean; //0x2FC
    m_dwGhostTick: LongWord; //0x300
    m_boDeath: Boolean; //0x304
    m_dwDeathTick: LongWord; //0x308
    m_btMonsterWeapon: Byte; //0x30C 怪物所拿的武器
    m_dwStruckTick: LongWord; //0x310
    m_boWantRefMsg: Boolean; //0x314
    m_boAddtoMapSuccess: Boolean; //0x315
    m_bo316: Boolean; //0x316
    m_boDealing: Boolean; //0x317
    m_DealLastTick: LongWord; //0x318 交易最后操作时间
    m_DealCreat: TBaseObject; //0x31C
    m_MyGuild: TObject; //0x320
    m_nGuildRankNo: Integer; //0x324
    m_sGuildRankName: string; //0x328
    m_sScriptLable: string; //0x32C
    m_btAttackSkillCount: Byte; //0x330
    bt331: Byte;
    bt332: Byte;
    bt333: Byte;
    m_btAttackSkillPointCount: Byte; //0x334
    bo335: Boolean; //0x335
    bo336: Boolean; //0x336
    bo337: Boolean; //0x337
    m_boMission: Boolean; //0x338
    m_nMissionX: Integer; //0x33C
    m_nMissionY: Integer; //0x340
    m_boHideMode: Boolean; //0x344  隐身戒指(Byte)
    m_boStoneMode: Boolean; //0x345
    m_boCoolEye: Boolean; //0x346  //是否可以看到隐身人物
    m_boUserUnLockDurg: Boolean; //0x347  //是否用了神水
    m_boTransparent: Boolean; //0x348  //魔法隐身了
    m_boAdminMode: Boolean; //0x349  管理模式(Byte)
    m_boObMode: Boolean; //0x34A  隐身模式(Byte)
    m_boTeleport: Boolean; //0x34B  传送戒指(Byte)
    m_boParalysis: Boolean; //0x34C  麻痹戒指(Byte)
    m_boUnParalysis: Boolean;
    m_boRevival: Boolean; //0x34D  复活戒指(Byte)
    m_boUnRevival: Boolean; //防复活
    bo34E: Boolean;
    bo34F: Boolean;
    m_dwRevivalTick: LongWord; //0x350  复活戒指使用间隔计数(Dword)
    m_boFlameRing: Boolean; //0x354  火焰戒指(Byte)
    m_boRecoveryRing: Boolean; //0x355  治愈戒指(Byte)
    m_boAngryRing: Boolean; //0x356  未知戒指(Byte)
    m_boMagicShield: Boolean; //0x357  护身戒指(Byte)
    m_boUnMagicShield: Boolean; //防护身
    m_boMuscleRing: Boolean; //0x358  活力戒指(Byte)
    m_boFastTrain: Boolean; //0x359  技巧项链(Byte)
    m_boProbeNecklace: Boolean; //0x35A  探测项链(Byte)
    m_boGuildMove: Boolean; //行会传送
    m_boSupermanItem: Boolean;
    m_bopirit: Boolean; //祈祷

    m_boNoDropItem: Boolean;
    m_boNoDropUseItem: Boolean;
    m_boExpItem: Boolean;
    m_boPowerItem: Boolean;

    m_rExpItem: real;
    m_rPowerItem: real;
    m_dwPKDieLostExp: LongWord; //PK 死亡掉经验，不够经验就掉等级
    m_nPKDieLostLevel: Integer; //PK 死亡掉等级

    m_boAbilSeeHealGauge: Boolean; //0x35B  //心灵启示
    m_boAbilMagBubbleDefence: Boolean; //0x35C  //魔法盾
    m_btMagBubbleDefenceLevel: Byte; //0x35D
    m_dwSearchTime: LongWord; //0x360
    m_dwSearchTick: LongWord; //0x364
    m_dwRunTick: LongWord; //0x368
    m_nRunTime: Integer; //0x36C
    m_nHealthTick: Integer; //0x370    //特别指定为 此类型  此处用到 004C7CF8
    m_nSpellTick: Integer; //0x374
    m_TargetCret: TBaseObject; //0x378
    m_dwTargetFocusTick: LongWord; //0x37C
    m_LastHiter: TBaseObject; //0x380  人物被对方杀害时对方指针(Dword)
    m_LastHiterTick: LongWord; //0x384
    m_ExpHitter: TBaseObject; //0x388
    m_ExpHitterTick: LongWord; //0x38C
    m_dwTeleportTick: LongWord; //0x390  传送戒指使用间隔(Dword)
    m_dwProbeTick: LongWord; //0x394  探测项链使用间隔(Dword)
    m_dwMapMoveTick: LongWord; //0x398
    m_boPKFlag: Boolean; //0x39C  人物攻击变色标志(Byte)
    m_dwPKTick: LongWord; //0x3A0  人物攻击变色时间长度(Dword)
    m_nMoXieSuite: Integer; //0x3A4  魔血一套(Dword)
    m_nHongMoSuite: Integer; //0x3A8 虹魔一套(Dword)
    m_n3AC: Integer; //0x3AC
    m_db3B0: Double; //0x3B0
    m_dwPoisoningTick: LongWord; //0x3B8 中毒处理间隔时间(Dword)
    m_dwDecPkPointTick: LongWord; //0x3BC  减PK值时间(Dword)
    m_DecLightItemDrugTick: LongWord; //0x3C0
    m_dwVerifyTick: LongWord; //0x3C4
    m_dwCheckRoyaltyTick: LongWord; //0x3C8
    m_dwDecHungerPointTick: LongWord; //0x3CC
    m_dwHPMPTick: LongWord; //0x3D0
    m_MsgList: TList; //0x3D4
    m_VisibleHumanList: TList; //0x3D8
    m_VisibleItems: TList; //0x3DC
    m_VisibleEvents: TList; //0x3E0
    m_SendRefMsgTick: LongWord; //0x3E4
    m_boInFreePKArea: Boolean; //0x3E8  是否在开行会战(Byte)
    LIst_3EC: TList; //0x3EC
    dwTick3F0: LongWord; //0x3F0
    dwTick3F4: LongWord; //0x3F4
    m_dwHitTick: LongWord; //0x3F8
    m_dwWalkTick: LongWord; //0x3FC
    m_dwSearchEnemyTick: LongWord; //0x400
    m_boNameColorChanged: Boolean; //0x404
    m_boIsVisibleActive: Boolean; //是否在可视范围内有人物,及宝宝
    m_nProcessRunCount: ShortInt;
    m_VisibleActors: TList; //0x408
    m_ItemList: TList; //0x40C  人物背包(Dword)数量
    m_DealItemList: TList; //0x410
    m_nDealGolds: Integer; //0x414  交易的金币数量(Dword)
    m_boDealOK: Boolean; //0x418  确认交易标志(Byte
    m_MagicList: TList; //0x41C  技能表
    m_UseItems: THumanUseItems; //这个是身上装备的定义
    m_SayMsgList: TList;
    m_StorageItemList: TList; //0x4F8
    m_nWalkSpeed: Integer; //0x4FC
    m_nWalkStep: Integer; //0x500
    m_nWalkCount: Integer; //0x504
    m_dwWalkWait: LongWord; //0x508
    m_dwWalkWaitTick: LongWord; //0x50C
    m_boWalkWaitLocked: Boolean; //0x510
    m_nNextHitTime: Integer; //0x514
    m_MagicOneSwordSkill: pTUserMagic; //0x518
    m_MagicPowerHitSkill: pTUserMagic; //0x51C
    m_MagicErgumSkill: pTUserMagic; //0x520 刺杀剑法
    m_MagicBanwolSkill: pTUserMagic; //0x524 半月弯刀
    m_MagicFireSwordSkill: pTUserMagic; //0x528
    m_MagicCrsSkill: pTUserMagic; //0x528
    m_Magic41Skill: pTUserMagic; //0x528
    m_Magic42Skill: pTUserMagic; //0x528
    m_Magic43Skill: pTUserMagic; //0x528
    m_boPowerHit: Boolean; //0x52C
    m_boUseThrusting: Boolean; //0x52D
    m_boUseHalfMoon: Boolean; //0x52E
    m_boFireHitSkill: Boolean; //0x52F
    m_boCrsHitkill: Boolean; //0x52F
    m_bo41kill: Boolean; //0x52F
    m_bo42kill: Boolean; //0x52F
    m_bo43kill: Boolean; //0x52F
    m_dwLatestFireHitTick: LongWord; //0x530
    m_dwDoMotaeboTick: LongWord; //0x534
    m_boDenyRefStatus: Boolean; //是否刷新在地图上信息；
    m_boAddToMaped: Boolean; //是否增加地图计数
    m_boDelFormMaped: Boolean; //是否从地图中删除计数
    m_boAutoChangeColor: Boolean;
    m_dwAutoChangeColorTick: LongWord;
    m_nAutoChangeIdx: Integer;

    m_boFixColor: Boolean; //固定颜色
    m_nFixColorIdx: Integer;
    m_nFixStatus: Integer;
    m_boFastParalysis: Boolean; //快速麻痹，受攻击后麻痹立即消失

    m_DefMsg: TDefaultMessage; //0x550
    m_nSocket: Integer; //0x59C nSocket
    m_nGSocketIdx: Integer; //0x5A0 wGateIndex 人物连接到游戏网关SOCKET ID
    m_nGateIdx: Integer; //0x5A8 nGateIdx   人物所在网关号
    m_nSoftVersionDate: Integer; //0x5AC

    m_nCopyHumanLevel: Integer; //复制人辈分等级
    m_dwStationTick: LongWord; //增加检测人物站立不动时间
    m_dwSayMyInfoTick: LongWord;
  private
    function InSafeArea: Boolean;
    procedure UpdateVisibleGay(BaseObject: TBaseObject);
    function Walk(nIdent: Integer): Boolean;
    function AddToMap(): Boolean;
    procedure UseLamp();
    procedure CheckPKStatus();
    procedure UpdateVisibleItem(wX, wY: Integer; MapItem: PTMapItem);
    procedure UpdateVisibleEvent(wX, wY: Integer; MapEvent: TObject);
    procedure GetAccessory(Item: TUserItem; var AddAbility: TAddAbility);
    procedure RecalcHitSpeed();
    procedure AddItemSkill(nIndex: Integer);
    procedure DelItemSkill(nIndex: Integer);
    procedure DecPKPoint(nPoint: Integer);
    procedure SendUpdateDelayMsg(BaseObject: TBaseObject; wIdent, wParam: Word;
      lParam1, lParam2, lParam3: Integer; sMsg: string; dwDelay: LongWord);
    procedure LeaveGroup();
    procedure DelMember(BaseObject: TBaseObject);
    procedure SendGroupText(sMsg: string);
    procedure HearMsg(sMsg: string);
    procedure DoDamageWeapon(nWeaponDamage: Integer);
    function GetFeatureEx: Word;
  public
    procedure AttackDir(TargeTBaseObject: TBaseObject; wHitMode: Word; nDir: Integer); virtual;
    function IsAddWeightAvailable(nWeight: Integer): Boolean;
    procedure DamageSpell(nSpellPoint: Integer);
    function GetCharColor(BaseObject: TBaseObject): Byte;
    function GetNamecolor: Byte;
    function RecalcBagWeight(): Integer;
    constructor Create(); virtual;
    destructor Destroy; override;
    function GetLevelExp(nLevel: Integer): LongWord;
    procedure SendMsg(BaseObject: TBaseObject; wIdent, wParam: Word; nParam1, nParam2, nParam3: Integer; sMsg: string);
    procedure SendFirstMsg(BaseObject: TBaseObject; wIdent, wParam: Word; lParam1, lParam2, lParam3: Integer; sMsg: string);
    procedure SendDelayMsg(BaseObject: TBaseObject; wIdent, wParam: Word; lParam1, lParam2, lParam3: Integer; sMsg: string; dwDelay: LongWord);
    procedure SendRefMsg(wIdent, wParam: Word; nParam1, nParam2, nParam3: Integer; sMsg: string);
    procedure SendUpdateMsg(BaseObject: TBaseObject; wIdent, wParam: Word; lParam1, lParam2, lParam3: Integer; sMsg: string);
    procedure SendActionMsg(BaseObject: TBaseObject; wIdent, wParam: Word;
      lParam1, lParam2, lParam3: Integer; sMsg: string);
    procedure SendAttackMsg(wIdent: Word; btDir: Byte; nX, nY: Integer);
    procedure SysMsg(sMsg: string; MsgColor: TMsgColor; MsgType: TMsgType);
    procedure MonsterSayMsg(AttackBaseObject: TBaseObject; MonStatus: TMonStatus);
    function IsVisibleHuman(): Boolean;
    procedure RecalcLevelAbilitys;
    function PKLevel(): Integer;
    function InSafeZone(): Boolean; overload;
    function InSafeZone(Envir: TEnvirnoment; nX, nY: Integer): Boolean; overload;
    procedure OpenHolySeizeMode(dwInterval: LongWord);
    procedure BreakHolySeizeMode;
    procedure OpenCrazyMode(nTime: Integer);
    procedure BreakCrazyMode();
    procedure HealthSpellChanged();
    function _Attack(var wHitMode: Word; AttackTarget: TBaseObject): Boolean;
    function GetHitStruckDamage(Target: TBaseObject; nDamage: Integer): Integer;
    procedure HasLevelUp(nLevel: Integer);
    procedure sub_4BC87C();
    procedure GoldChanged();
    procedure GameGoldChanged;
    function GetPoseCreate(): TBaseObject;
    function GetGuildRelation(cert1: TBaseObject; cert2: TBaseObject): Integer;
    function IsGoodKilling(Cert: TBaseObject): Boolean;
    procedure IncPkPoint(nPoint: Integer);
    procedure AddBodyLuck(dLuck: Double);
    procedure MakeWeaponUnlock();
    procedure ScatterGolds(GoldOfCreat: TBaseObject);
    function DropGoldDown(nGold: Integer; boFalg: Boolean; GoldOfCreat, DropGoldCreat: TBaseObject): Boolean;
    function DropItemDown(UserItem: pTUserItem; nScatterRange: Integer; boDieDrop: Boolean; ItemOfCreat, DropCreat: TBaseObject): Boolean;
    procedure DamageHealth(nDamage: Integer);
    function GetAttackPower(nBasePower, nPower: Integer): Integer;
    function CharPushed(nDir, nPushCount: Integer): Integer;
    function GetDropPosition(nOrgX, nOrgY, nRange: Integer; var nDX: Integer; var nDY: Integer): Boolean;
    function GetBackDir(nDir: Integer): Integer;
    function GetMapBaseObjects(tEnvir: TEnvirnoment; nX, nY: Integer; nRage: Integer; rList: TList): Boolean;
    function MagPassThroughMagic(sX, sY, tx, ty, nDir, magpwr: Integer;
      undeadattack: Boolean): Integer;
    procedure KickException;
    function GetMagStruckDamage(BaseObject: TBaseObject; nDamage: Integer): Integer;
    procedure DamageBubbleDefence(nInt: Integer);
    procedure BreakOpenHealth;
    function GetCharStatus: Integer;
    procedure MakeOpenHealth;
    procedure IncHealthSpell(nHP, nMP: Integer);
    procedure ItemDamageRevivalRing;
    function CalcGetExp(nLevel: Integer; nExp: Integer): Integer;
    procedure GainSlaveExp(nLevel: Integer);
    procedure MapRandomMove(sMapName: string; nInt: Integer);
    procedure TurnTo(nDir: Integer);
    procedure FeatureChanged();
    function GetFeatureToLong(): Integer;
    function GetFeature(BaseObject: TBaseObject): Integer;
    function IsGroupMember(Target: TBaseObject): Boolean;
    procedure AbilCopyToWAbil();
    procedure ChangePKStatus(boWarFlag: Boolean);
    procedure StruckDamage(nDamage: Integer);
    function sub_4C4CD4(sItemName: string; var nCount: Integer): pTUserItem;
    procedure StatusChanged;
    function GeTBaseObjectInfo(): string;
    procedure TrainSkill(UserMagic: pTUserMagic; nTranPoint: Integer);
    function CheckMagicLevelup(UserMagic: pTUserMagic): Boolean;
    function MagCanHitTarget(nX, nY: Integer; TargeTBaseObject: TBaseObject): Boolean;
    procedure sub_4C713C(Magic: pTUserMagic);
    function MagBubbleDefenceUp(nLevel, nSec: Integer): Boolean;
    procedure ApplyMeatQuality();
    function TakeBagItems(BaseObject: TBaseObject): Boolean;
    function AddItemToBag(UserItem: pTUserItem): Boolean;
    function DelBagItem(nIndex: Integer): Boolean; overload;
    function DelBagItem(nItemIndex: Integer; sItemName: string): Boolean; overload;
    function DelBagItem(UserItem: pTUserItem): Boolean; overload;
    procedure WeightChanged();
    function IsTrainingSkill(nIndex: Integer): Boolean;
    procedure SetQuestFlagStatus(nFlag: Integer; nValue: Integer);
    function GetQuestFalgStatus(nFlag: Integer): Integer;
    procedure SetQuestUnitOpenStatus(nFlag: Integer; nValue: Integer);
    function GetQuestUnitOpenStatus(nFlag: Integer): Integer;
    procedure SetQuestUnitStatus(nFlag: Integer; nValue: Integer);
    function GetQuestUnitStatus(nFlag: Integer): Integer;
    function GetAttackDir(BaseObject: TBaseObject; var btDir: Byte): Boolean;
    function TargetInSpitRange(BaseObject: TBaseObject; var btDir: Byte): Boolean;
    procedure MonsterRecalcAbilitys();
    procedure RefNameColor;
    procedure SetPKFlag(BaseObject: TBaseObject);
    procedure SetLastHiter(BaseObject: TBaseObject);
    function EnterAnotherMap(Envir: TEnvirnoment; nDMapX, nDMapY: Integer): Boolean;
    function sub_4DD704(): Boolean;
    function DefenceUp(nSec: Integer): Boolean;
    function MagDefenceUp(nSec: Integer): Boolean;
    procedure RefShowName;
    function MakeSlave(sMonName: string; nMakeLevel, nExpLevel, nMaxMob: Integer; dwRoyaltySec: LongWord): TBaseObject;
    function MakeSelf(BaseObject: TBaseObject; sMonName: string; nMaxMob: Integer; dwRoyaltySec: LongWord): TBaseObject; //004C37C0

    function MakePosion(nType, nTime, nPoint: Integer): Boolean;
    function GetFrontPosition(var nX: Integer; var nY: Integer): Boolean;
    function GetBackPosition(var nX: Integer; var nY: Integer): Boolean;
    function WalkTo(btDir: Byte; boFlag: Boolean): Boolean;
    procedure SpaceMove(sMAP: string; nX, nY: Integer; nInt: Integer);
    function sub_4C5370(nX, nY: Integer; nRange: Integer; var nDX, nDY: Integer): Boolean;
    function CheckItems(sItemName: string): pTUserItem;
    function MagMakeDefenceArea(nX, nY, nRange, nSec: Integer; btState: Byte; boState: Boolean): Integer;
    function MagChangeAbility(nSec: Integer; btState: Byte): Boolean;
    function MagMakeAbilityArea(nX, nY, nRange, nSec: Integer; btState: Byte; boState: Boolean): Integer; //004C6F04

    function sub_4C3538(): Integer;
    function IsGuildMaster(): Boolean;
    procedure LoadSayMsg();
    procedure DisappearA();
    function GetShowName(): string; virtual;
    procedure DropUseItems(BaseObject: TBaseObject); virtual;
    procedure ScatterBagItems(ItemOfCreat: TBaseObject); virtual;
    function GetMessage(Msg: pTProcessMessage): Boolean; virtual; //FFFF
    procedure Initialize(); virtual; //FFFE
    procedure Disappear(); virtual; //FFFD
    function Operate(ProcessMsg: pTProcessMessage): Boolean; virtual; //FFFC
    procedure SearchObjectViewRange(); // virtual; //dynamic;
    procedure Run(); virtual; //dynamic;//FFFB
    procedure ProcessMonSayMsg(sMsg: string);
    procedure MakeGhost; virtual;
    procedure Die(); virtual;
    procedure ReAlive(); virtual; //FFF8;
    procedure RecalcAbilitys(); virtual; //FFF7
    function IsProtectTarget(BaseObject: TBaseObject): Boolean; virtual; //FFF6
    function IsAttackTarget(BaseObject: TBaseObject): Boolean; virtual; //FFF5
    function IsProperTarget(BaseObject: TBaseObject): Boolean; virtual; //FFF4
    function IsProperFriend(BaseObject: TBaseObject): Boolean; virtual; //FFF3
    procedure SetTargetCreat(BaseObject: TBaseObject); virtual; //FFF2
    procedure DelTargetCreat(); virtual; //FFF1

    function IsProperTargetSKILL_54(BaseObject: TBaseObject): Boolean;
    function IsProperTargetSKILL_55(nLevel: Integer; BaseObject: TBaseObject): Boolean; virtual;
    function IsProperTargetSKILL_56(BaseObject: TBaseObject; nTargetX, nTargetY: Integer): Boolean; virtual;
    function IsProperTargetSKILL_57(BaseObject: TBaseObject): Boolean; virtual;
    function IsProperTargetSKILL_70(PlayObject: TBaseObject): Boolean; virtual;

    function RunTo(btDir: Byte; boFlag: Boolean; nDestX, nDestY: Integer): Boolean;
    procedure ThrustingOnOff(boSwitch: Boolean);
    procedure HalfMoonOnOff(boSwitch: Boolean);
    procedure SkillCrsOnOff(boSwitch: Boolean);
    procedure Skill42OnOff(boSwitch: Boolean);
    procedure Skill43OnOff(boSwitch: Boolean);
    function AllowFireHitSkill(): Boolean;
    function CretInNearXY(TargeTBaseObject: TBaseObject; nX, nY: Integer): Boolean;
  end;
  TAnimalObject = class(TBaseObject)
    m_nNotProcessCount: Integer; //未被处理次数，用于怪物处理循环
    m_nTargetX: Integer;
    m_nTargetY: Integer;
    m_boRunAwayMode: Boolean;
    m_dwRunAwayStart: LongWord;
    m_dwRunAwayTime: LongWord;
  private

  public
    constructor Create(); override;
    procedure SearchTarget();
    procedure sub_4C959C;
    function Operate(ProcessMsg: pTProcessMessage): Boolean; override;
    procedure Run; override;
    procedure DelTargetCreat(); override;
    procedure SetTargetXY(nX, nY: Integer); virtual;
    procedure GotoTargetXY(); virtual;
    procedure Wondering(); virtual;
    procedure Attack(TargeTBaseObject: TBaseObject; nDir: Integer); virtual;
    procedure Struck(hiter: TBaseObject); virtual;
    procedure HitMagAttackTarget(TargeTBaseObject: TBaseObject; nHitPower: Integer; nMagPower: Integer; boFlag: Boolean);

  end;
  PTPlayObject = ^TPlayObject;
  TPlayObject = class(TAnimalObject)
    TList55C: TList;
    m_sOldSayMsg: string; //0x560
    m_nSayMsgCount: Integer; //0x560
    m_dwSayMsgTick: LongWord; //0x568
    m_boDisableSayMsg: Boolean; //0x56C
    m_dwDisableSayMsgTick: LongWord; //0x570
    m_dwCheckDupObjTick: LongWord; //0x574
    dwTick578: LongWord; //0x578
    dwTick57C: LongWord; //0x57C
    m_boInSafeArea: Boolean; //0x580
    n584: Integer; //0x584
    n588: Integer; //0x584
    m_sUserID: string[11]; //0x58C    登录帐号名
    m_sIPaddr: string[15]; //0x598    人物IP地址
    m_sIPLocal: string;

    m_dLogonTime: TDateTime; //0x5B0  //登录时间
    m_dwLogonTick: LongWord; //0x5B8  战领沙城时间(Dword)
    m_boReadyRun: Boolean; //0x5BC  //是否进入游戏完成
    m_nSessionID: Integer; //0x5C0
    m_nPayMent: Integer; //0x5C4  人物当前模式(测试/付费模式)(Dword)
    m_nPayMode: Integer; //0x5C8
    m_SessInfo: pTSessInfo; //全局会话信息
    m_dwLoadTick: LongWord; //0x5CC
    m_nServerIndex: Integer; //0x5D0  人物当前所在服务器序号
    m_boEmergencyClose: Boolean; //0x5D4  掉线标志
    m_boSoftClose: Boolean; //0x5D5
    m_boKickFlag: Boolean; //0x5D6  断线标志(Byte)(@kick 命令)
    m_boReconnection: Boolean; //0x5D7
    m_boRcdSaved: Boolean; //0x5D8
    m_boSwitchData: Boolean; //0x5D9
    m_nWriteChgDataErrCount: Integer; //0x5DC
    m_sSwitchMapName: string; //0x5E0
    m_nSwitchMapX: Integer; //0x5E4
    m_nSwitchMapY: Integer; //0x5E8
    m_boSwitchDataSended: Boolean; //0x5EC
    m_dwChgDataWritedTick: LongWord; //0x5F0
    m_dw5D4: LongWord; //0x5F4
    n5F8: Integer; //0x5F8
    n5FC: Integer; //0x5FC
    m_dwHitIntervalTime: LongWord; //攻击间隔
    m_dwMagicHitIntervalTime: LongWord; //魔法间隔
    m_dwRunIntervalTime: LongWord; //走路间隔
    m_dwWalkIntervalTime: LongWord; //走路间隔
    m_dwTurnIntervalTime: LongWord; //换方向间隔
    m_dwActionIntervalTime: LongWord; //组合操作间隔
    m_dwRunLongHitIntervalTime: LongWord; //移动刺杀间隔
    m_dwRunHitIntervalTime: LongWord; //跑位攻击间隔
    m_dwWalkHitIntervalTime: LongWord; //走位攻击间隔
    m_dwRunMagicIntervalTime: LongWord; //跑位魔法间隔

    m_dwMagicAttackTick: LongWord; //0x600  魔法攻击时间(Dword)
    m_dwMagicAttackInterval: LongWord; //0x604  魔法攻击间隔时间(Dword)
    m_dwAttackTick: LongWord; //0x608  攻击时间(Dword)
    m_dwMoveTick: LongWord; //0x60C  人物跑动时间(Dword)
    m_dwAttackCount: LongWord; //0x610  人物攻击计数(Dword)
    m_dwAttackCountA: LongWord; //0x614  人物攻击计数(Dword)
    m_dwMagicAttackCount: LongWord; //0x618  魔法攻击计数(Dword)
    m_dwMoveCount: LongWord; //0x61C  人物跑计数(Dword)
    m_dwMoveCountA: LongWord; //0x620  人物跑计数(Dword)
    m_nOverSpeedCount: Integer; //0x624  超速计数(Dword)
    m_boDieInFight3Zone: Boolean; //0x628
    m_Script: pTScript; //0x62C
    m_NPC: TBaseObject; //0x630
    m_nVal: array[0..9] of Integer; //0x634 - 658
    m_nMval: array[0..99] of Integer;
    m_DyVal: array[0..9] of Integer; //0x65C - 680
    m_sPlayDiceLabel: string;
    m_boTimeRecall: Boolean; //0x684
    m_dwTimeRecallTick: LongWord;
    m_sMoveMap: string; //0x68C
    m_nMoveX: Integer; //0x690
    m_nMoveY: Integer; //0x694
    bo698: Boolean; //0x698
    n69C: Integer; //0x69C
    m_dwSaveRcdTick: LongWord; //0x6A0 保存人物数据时间间隔
    m_nBright: Integer; //0x6A4
    m_boNewHuman: Boolean; //0x6A8
    m_boSendNotice: Boolean; //0x6A9
    m_dwWaitLoginNoticeOKTick: LongWord;
    m_boLoginNoticeOK: Boolean; //0x6AA
    bo6AB: Boolean; //0x6AB
    m_boExpire: Boolean; //0x6AC  帐号过期
    m_dwShowLineNoticeTick: LongWord; //0x6B0
    m_nShowLineNoticeIdx: Integer; //0x6B4

    //m_AddUseItems             :array[9..12] of TUserItem;
    m_nSoftVersionDateEx: Integer;
    m_CanJmpScriptLableList: TStringList;
    m_nScriptGotoCount: Integer;
    m_sScriptCurrLable: string; //用于处理 @back 脚本命令
    m_sScriptGoBackLable: string; //用于处理 @back 脚本命令
    m_dwTurnTick: LongWord;
    m_wOldIdent: Word;
    m_btOldDir: Byte;

    m_boFirstAction: Boolean; //第一个操作
    m_dwActionTick: LongWord; //二次操作之间间隔时间
    m_sDearName: string[14]; //配偶名称
    m_DearHuman: TPlayObject;
    m_boCanDearRecall: Boolean; //是否允许夫妻传送
    m_boCanMasterRecall: Boolean;
    m_dwDearRecallTick: LongWord; //夫妻传送时间
    m_dwMasterRecallTick: LongWord;
    m_sMasterName: string[14]; //师徒名称
    m_MasterHuman: TPlayObject;
    m_MasterList: TList;
    m_boMaster: Boolean;
    m_btCreditPoint: Byte; //声望点
    m_btMarryCount: Byte; //离婚次数
    m_btReLevel: Byte; //转生等级
    m_btReColorIdx: Byte;
    m_dwReColorTick: LongWord;
    m_nKillMonExpMultiple: Integer; //杀怪经验倍数
    m_dwGetMsgTick: LongWord; //处理消息循环时间控制

    m_boSetStoragePwd: Boolean;
    m_boReConfigPwd: Boolean;
    m_boCheckOldPwd: Boolean;
    m_boUnLockPwd: Boolean;
    m_boUnLockStoragePwd: Boolean;
    m_boPasswordLocked: Boolean; //锁密码
    m_btPwdFailCount: Byte;
    m_boLockLogon: Boolean; //是否启用锁登录功能
    m_boLockLogoned: Boolean; //是否打开登录锁
    m_sTempPwd: string[7];
    m_sStoragePwd: string[7];
    m_PoseBaseObject: TBaseObject;
    m_boStartMarry: Boolean;
    m_boStartMaster: Boolean;
    m_boStartUnMarry: Boolean;
    m_boStartUnMaster: Boolean;
    m_boFilterSendMsg: Boolean; //禁止发方字(发的文字只能自己看到)
    m_nKillMonExpRate: Integer; //杀怪经验倍数(此数除以 100 为真正倍数)
    m_nPowerRate: Integer; //人物攻击力倍数(此数除以 100 为真正倍数)
    m_dwKillMonExpRateTime: LongWord;
    m_dwPowerRateTime: LongWord;
    m_dwRateTick: LongWord;

    m_boCanUseItem: Boolean; //是否允许使用物品
    m_boCanDeal: Boolean;
    m_boCanDrop: Boolean;
    m_boCanGetBackItem: Boolean;
    m_boCanWalk: Boolean;
    m_boCanRun: Boolean;
    m_boCanHit: Boolean;
    m_boCanSpell: Boolean;
    m_boCanSendMsg: Boolean;

    m_nMemberType: Integer; //会员类型
    m_nMemberLevel: Integer; //会员等级
    m_boSendMsgFlag: Boolean; //发祝福语标志
    m_boChangeItemNameFlag: Boolean;

    m_nGameGold: Integer; //游戏币
    m_boDecGameGold: Boolean; //是否自动减游戏币
    m_dwDecGameGoldTime: LongWord;
    m_dwDecGameGoldTick: LongWord;
    m_nDecGameGold: Integer; //一次减点数

    m_boIncGameGold: Boolean; //是否自动加游戏币
    m_dwIncGameGoldTime: LongWord;
    m_dwIncGameGoldTick: LongWord;
    m_nIncGameGold: Integer; //一次减点数

    m_nGamePoint: Integer; //游戏点数
    m_dwIncGamePointTick: LongWord;

    m_nPayMentPoint: Integer;
    m_dwPayMentPointTick: LongWord;

    m_dwDecHPTick: LongWord;
    m_dwIncHPTick: LongWord;

    m_GetWhisperHuman: TPlayObject;
    m_dwClearObjTick: LongWord;
    m_wContribution: Word; //贡献度
    m_sRankLevelName: string; //显示名称格式串
    m_boFilterAction: Boolean;
    m_boClientFlag: Boolean;
    m_nStep: Byte;
    m_nClientFlagMode: Integer;
    m_dwAutoGetExpTick: LongWord;
    m_nAutoGetExpTime: Integer;
    m_nAutoGetExpPoint: Integer;
    m_AutoGetExpEnvir: TEnvirnoment;
    m_boAutoGetExpInSafeZone: Boolean;
    m_DynamicVarList: TList;
    m_dwClientTick: LongWord;
    m_boTestSpeedMode: Boolean; //进入速度测试模式

    nRunCount: Integer;
    dwRunTimeCount: LongWord;
    m_dwDelayTime: LongWord;

    m_boRemoteMsg: Boolean; //是否允许接受消息
    m_boNotOnlineAddExp: Boolean; //是否是离线挂机人物
    m_boAllowReAlive: Boolean; //是否允许复活

    m_dwStartNotOnlineAddExpTime: LongWord; //离线挂机开始时间
    m_dwNotOnlineAddExpTime: LongWord; //离线挂机时长
    m_nNotOnlineAddExpPoint: Integer; //离线挂机每分钟增加经验值
    m_boKickAutoAddExpUser: Boolean;
    m_dwAutoAddExpPointTick: LongWord;
    m_dwAutoAddExpPointTimeTick: LongWord;

    m_boStartAutoAddExpPoint: Boolean;
    m_sAutoSendMsg: string; //自动回复信息

    m_boTimeGoto: Boolean;
    m_dwTimeGotoTick: LongWord;
    m_sTimeGotoLable: string;
    m_TimeGotoNPC: TObject;
    m_boAddSaveList: Boolean;

    m_nDealGoldPose: Integer;
    m_nBigStoragePage: Integer;
    m_dwDedingUseTick: LongWord;

    m_boPlayOffLine: Boolean; //是否下线触发
    m_dwUserTick: array[0..99] of LongWord; //由功能插件调用
    m_nInteger: array[0..99] of Integer; //人物变量
    m_sString: array[0..99] of string; //人物变量
  private
    function ClientDropGold(nGold: Integer): Boolean;
    procedure ClientQueryBagItems();
    procedure ClientQueryUserState(PlayObject: TPlayObject; nX, nY: Integer);
    procedure ClientQueryUserSet(ProcessMsg: pTProcessMessage);
    function ClientDropItem(sItemName: string; nItemIdx: Integer): Boolean;
    function ClientPickUpItem: Boolean;
    procedure ClientOpenDoor(nX, nY: Integer);
    procedure ClientTakeOnItems(btWhere: Byte; nItemIdx: Integer; sItemName: string);
    procedure ClientTakeOffItems(btWhere: Byte; nItemIdx: Integer; sItemName: string);
    procedure ClientUseItems(nItemIdx: Integer; sItemName: string);
    function UseStdmodeFunItem(StdItem: pTStdItem): Boolean;
    function ClientGetButchItem(BaseObject: TBaseObject; nX, nY: Integer; btDir: Byte; var dwDelayTime: LongWord): Boolean;
    procedure ClientChangeMagicKey(nSkillIdx, nKey: Integer);
    procedure ClientClickNPC(NPC: Integer);
    procedure ClientMerchantDlgSelect(nParam1: Integer; sMsg: string);
    procedure ClientMerchantQuerySellPrice(nParam1, nMakeIndex: Integer; sMsg: string);
    procedure ClientUserSellItem(nParam1, nMakeIndex: Integer; sMsg: string);
    procedure ClientUserBuyItem(nIdent, nParam1, nInt, nZz: Integer; sMsg: string);
    procedure ClientQueryRepairCost(nParam1, nInt: Integer; sMsg: string);
    procedure ClientRepairItem(nParam1, nInt: Integer; sMsg: string);

    procedure ClientUserSellOffItem(nParam1, nMakeIndex: Integer; sMsg: string); //拍卖
    procedure ClientUserBuySellOffItem(nIdent, nParam1, nInt, nZz: Integer; sMsg: string); //拍卖

    procedure ClientGropuClose();
    procedure ClientCreateGroup(sHumName: string);
    procedure ClientAddGroupMember(sHumName: string);
    procedure ClientDelGroupMember(sHumName: string);
    procedure ClientDealTry(sHumName: string);
    procedure ClientAddDealItem(nItemIdx: Integer; sItemName: string);
    procedure ClientDelDealItem(nItemIdx: Integer; sItemName: string);
    procedure ClientCancelDeal();
    procedure ClientChangeDealGold(nGold: Integer);
    procedure ClientDealEnd();
    procedure ClientStorageItem(NPC: TObject; nItemIdx: Integer; sMsg: string);
    procedure ClientTakeBackStorageItem(NPC: TObject; nItemIdx: Integer; sMsg: string);
    procedure ClientGetMinMap();
    procedure ClientMakeDrugItem(NPC: TObject; nItemName: string);
    procedure ClientOpenGuildDlg();
    procedure ClientGuildHome();
    procedure ClientGuildMemberList();
    procedure ClientGuildAddMember(sHumName: string);
    procedure ClientGuildDelMember(sHumName: string);
    procedure ClientGuildUpdateNotice(sNotict: string);
    procedure ClientGuildUpdateRankInfo(sRankInfo: string);
    procedure ClientGuildAlly();
    procedure ClientGuildBreakAlly(sGuildName: string);
    procedure ClientAdjustBonus(nPoint: Integer; sMsg: string);
    function ClientChangeDir(wIdent: Word; nX, nY, nDir: Integer; var dwDelayTime: LongWord): Boolean;
    function ClientWalkXY(wIdent: Word; nX, nY: Integer; boLateDelivery: Boolean; var dwDelayTime: LongWord): Boolean;

    function ClientHorseRunXY(wIdent: Word; nX, nY: Integer; boLateDelivery: Boolean; var dwDelayTime: LongWord): Boolean;
    function ClientRunXY(wIdent: Word; nX, nY: Integer; nFlag: Integer; var dwDelayTime: LongWord): Boolean;
    function ClientHitXY(wIdent: Word; nX, nY, nDir: Integer; boLateDelivery: Boolean; var dwDelayTime: LongWord): Boolean;
    function ClientSitDownHit(nX, nY, nDir: Integer; var dwDelayTime: LongWord): Boolean;
    function ClientSpellXY(wIdent: Word; nKey: Integer; nTargetX, nTargetY: Integer; TargeTBaseObject: TBaseObject; boLateDelivery: Boolean; var dwDelayTime: LongWord): Boolean;

    function CheckTakeOnItems(nWhere: Integer; var StdItem: TStdItem): Boolean;
    function GetUserItemWeitht(nWhere: Integer): Integer;

    procedure SendDelDealItem(UserItem: pTUserItem);
    procedure SendAddDealItem(UserItem: pTUserItem);

    procedure OpenDealDlg(BaseObject: TBaseObject);
    function EatItems(StdItem: pTStdItem): Boolean;
    function EatUseItems(nShape: Integer): Boolean;
    function ReadBook(StdItem: pTStdItem): Boolean;
    function DayBright(): Byte;
    procedure BaseObjectMove(sMAP, sX, sY: string);
    procedure MoveToHome();
    function RepairWeapon(): Boolean;
    function SuperRepairWeapon(): Boolean;
    function WinLottery(): Boolean;
    procedure ChangeServerMakeSlave(SalveInfo: pTSlaveInfo);
    function WeaptonMakeLuck(): Boolean;
    function PileStones(nX, nY: Integer): Boolean;

    procedure MakeMine();

    function GetRangeHumanCount(): Integer;
    procedure GetStartPoint();

    procedure MobPlace(sX, sY, sMonName, sCount: string);

    procedure LogonTimcCost;
    procedure SendNotice();
    procedure SendLogon();
    procedure SendServerConfig();
    procedure SendServerStatus();
    //    procedure SendUserName(PlayObject:TPlayObject;nX,nY:Integer);

    procedure ClientQueryUserName(Target: TBaseObject; x, y: Integer);
    procedure SendUseitems();
    procedure SendUseMagic();
    procedure SendSaveItemList(nBaseObject: Integer);
    procedure SendSaveBigStorageItemList(nBaseObject: Integer; nPage: Integer);
    procedure SendDelItemList(ItemList: TStringList);
    procedure SendAdjustBonus();
    procedure SendChangeGuildName();
    procedure SendMapDescription();
    procedure SendGoldInfo(boSendName: Boolean);

    procedure ShowMapInfo(sMAP, sX, sY: string);

    function CancelGroup(): Boolean;

    function DoMotaebo(nDir: Byte; nMagicLevel: Integer): Boolean;
    function DoSpell(UserMagic: pTUserMagic; nTargetX, nTargetY: Integer; BaseObject: TBaseObject): Boolean;
    procedure GetOldAbil(var OAbility: TOAbility);
    procedure ReadAllBook;
    function CheckItemsNeed(StdItem: pTStdItem): Boolean;
    function CheckItemBindUse(UserItem: pTUserItem): Boolean;
    function CheckActionStatus(wIdent: Word; var dwDelayTime: LongWord): Boolean;
    procedure RecalcAdjusBonus;
    procedure CheckMarry();
    procedure CheckMaster();
    procedure RefMyStatus;
    procedure ProcessClientPassword(ProcessMsg: pTProcessMessage);
    function CheckDenyLogon: Boolean;
    procedure ProcessSpiritSuite;
    function HorseRunTo(btDir: Byte; boFlag: Boolean): Boolean;
    function GetSpellPoint(UserMagic: pTUserMagic): Integer;
  public
    constructor Create(); override;
    destructor Destroy; override;
    function GetMagicInfo(sMagicName: string): pTUserMagic; overload;
    function GetMagicInfo(nMagicID: Integer): pTUserMagic; overload;
    procedure ClearViewRange;

    function AbilityUp(UserMagic: pTUserMagic): Boolean;
    procedure SearchViewRange();
    procedure PKDie(PlayObject: TPlayObject);
    procedure GameTimeChanged();
    procedure RunNotice();
    function GetMyStatus(): Integer;
    function IncGold(tGold: Integer): Boolean;
    procedure IncGamePoint(nGamePoint: Integer);
    procedure IncGameGold(nGameGold: Integer);
    procedure SendSocket(DefMsg: pTDefaultMessage; sMsg: string); virtual;
    procedure SendDefMessage(wIdent: Word; nRecog: Integer; nParam, nTag, nSeries: Word; sMsg: string);
    function IsEnoughBag(): Boolean;
    procedure SendAddItem(UserItem: pTUserItem);
    procedure SendDelItems(UserItem: pTUserItem);
    procedure Whisper(whostr, saystr: string);
    function IsBlockWhisper(sName: string): Boolean;
    function QuestCheckItem(sItemName: string; var nCount: Integer; var nParam: Integer; var nDura: Integer): pTUserItem;
    function QuestTakeCheckItem(CheckItem: pTUserItem): Boolean;
    procedure GainExp(dwExp: LongWord);
    procedure GetExp(dwExp: LongWord);
    procedure WinExp(dwExp: LongWord);
    function DecGold(nGold: Integer): Boolean;
    procedure DecGamePoint(nGamePoint: Integer);
    procedure DecGameGold(nGameGold: Integer);
    procedure Run(); override;
    function Operate(ProcessMsg: pTProcessMessage): Boolean; override;
    procedure RecalcAbilitys(); override;
    procedure MakeSaveRcd(var HumanRcd: THumDataInfo);
    procedure DealCancel();
    procedure DealCancelA();
    function GetShowName(): string; override;
    procedure GetBackDealItems();
    procedure Disappear(); override;
    procedure GoldChange(sChrName: string; nGold: Integer);
    procedure ProcessUserLineMsg(sData: string);
    procedure ProcessSayMsg(sData: string);
    procedure ClearStatusTime();
    procedure UserLogon(); virtual;
    procedure RefRankInfo(nRankNo: Integer; sRankName: string);
    procedure RefUserState;
    procedure SendGroupMembers();
    procedure JoinGroup(PlayObject: TPlayObject);
    function GeTBaseObjectInfo(): string;
    function GetHitMsgCount(): Integer;
    function GetSpellMsgCount(): Integer;
    function GetWalkMsgCount(): Integer;
    function GetRunMsgCount(): Integer;
    function GetTurnMsgCount(): Integer;
    function GetSiteDownMsgCount(): Integer;
    function GetDigUpMsgCount(): Integer;
    procedure SetScriptLabel(sLabel: string);
    procedure GetScriptLabel(sMsg: string);
    function LableIsCanJmp(sLabel: string): Boolean;
    function GetMyInfo(): string;
    procedure MakeGhost; override;
    procedure ScatterBagItems(ItemOfCreat: TBaseObject); override;
    procedure DropUseItems(BaseObject: TBaseObject); override;
    procedure RecallHuman(sHumName: string);
    procedure SendAddMagic(UserMagic: pTUserMagic);
    procedure SendDelMagic(UserMagic: pTUserMagic);
    procedure ReQuestGuildWar(sGuildName: string);
    procedure SendUpdateItem(UserItem: pTUserItem);
    procedure GetBagUseItems(var btDc: Byte; var btSc: Byte; var btMc: Byte; var btDura: Byte);



    procedure CmdGetUserItem(Cmd: pTGameCmd; sHumanName: string);//还要改一下  需要检测人物权限

    procedure CmdUserCmd(sLable: string);
    procedure CmdEndGuild();
    procedure CmdMemberFunction(sCmd, sParam: string);
    procedure CmdMemberFunctionEx(sCmd, sParam: string);

    procedure CmdSearchDear(sCmd, sParam: string);
    procedure CmdSearchMaster(sCmd, sParam: string);
    procedure CmdDearRecall(sCmd, sParam: string);
    procedure CmdMasterRecall(sCmd, sParam: string);
    procedure CmdSbkDoorControl(sCmd, sParam: string);

    procedure CmdClearBagItem(Cmd: pTGameCmd; sHumanName: string);
    procedure CmdShowUseItemInfo(Cmd: pTGameCmd; sHumanName: string);

    procedure CmdBindUseItem(Cmd: pTGameCmd; sHumanName, sItem, sType: string);
    procedure CmdUnBindUseItem(Cmd: pTGameCmd; sHumanName, sItem, sType: string);
    procedure CmdLockLogin(Cmd: pTGameCmd);
    procedure CmdViewDiary(sCmd: string; nFlag: Integer);
    procedure CmdUserMoveXY(sCmd, sX, sY: string);
    procedure CmdSearchHuman(sCmd, sHumanName: string);
    procedure CmdGroupRecall(sCmd: string);
    procedure CmdAllowGroupReCall(sCmd, sParam: string);

    procedure CmdGuildRecall(sCmd, sParam: string);

    procedure CmdChangeAttackMode(nMode: Integer; sParam1, sParam2, sParam3, sParam4, sParam5, sParam6, sParam7: string);
    procedure CmdChangeSalveStatus();
    procedure CmdTakeOnHorse(sCmd, sParam: string);
    procedure CmdTakeOffHorse(sCmd, sParam: string);

    procedure CmdPrvMsg(sCmd: string; nPermission: Integer; sHumanName: string);
    procedure CmdHumanLocal(Cmd: pTGameCmd; sHumanName: string);
    procedure CmdMapMove(Cmd: pTGameCmd; sMapName: string);

    procedure CmdPositionMove(Cmd: pTGameCmd; sMapName, sX, sY: string);

    procedure CmdHumanInfo(Cmd: pTGameCmd; sHumanName: string);
    procedure CmdReLoadAdmin(sCmd: string);
    procedure CmdReloadNpc(sParam: string);
    procedure CmdReloadManage(Cmd: pTGameCmd; sParam: string);
    procedure CmdReloadRobotManage;
    procedure CmdReloadRobot;
    procedure CmdReloadMonItems();
    procedure CmdAdjustExp(Human: TPlayObject; nExp: Integer);
    procedure CmdAddGuild(Cmd: pTGameCmd; sGuildName, sGuildChief: string);
    procedure CmdDelGuild(Cmd: pTGameCmd; sGuildName: string);
    procedure CmdGuildWar(sCmd, sGuildName: string);
    procedure CmdChangeSabukLord(Cmd: pTGameCmd; sCASTLENAME, sGuildName: string; boFlag: Boolean);
    procedure CmdForcedWallconquestWar(Cmd: pTGameCmd; sCASTLENAME: string);
    procedure CmdOPTraining(sHumanName, sSkillName: string; nLevel: Integer);
    procedure CmdOPDeleteSkill(sHumanName, sSkillName: string);
    procedure CmdReloadGuildAll();
    procedure CmdReAlive(Cmd: pTGameCmd; sHumanName: string);
    procedure CmdAdjuestLevel(Cmd: pTGameCmd; sHumanName: string; nLevel: Integer);
    procedure CmdAdjuestExp(Cmd: pTGameCmd; sHumanName, sExp: string);

    procedure CmdBackStep(sCmd: string; nType, nCount: Integer);
    procedure CmdFreePenalty(Cmd: pTGameCmd; sHumanName: string);
    procedure CmdPKpoint(Cmd: pTGameCmd; sHumanName: string);
    procedure CmdIncPkPoint(Cmd: pTGameCmd; sHumanName: string; nPoint: Integer);
    procedure CmdHunger(sCmd, sHumanName: string; nHungerPoint: Integer);
    procedure CmdHair(Cmd: pTGameCmd; sHumanName: string; nHair: Integer);
    procedure CmdTrainingSkill(Cmd: pTGameCmd; sHumanName, sSkillName: string; nLevel: Integer);
    procedure CmdTrainingMagic(Cmd: pTGameCmd; sHumanName, sSkillName: string; nLevel: Integer);

    procedure CmdDelSkill(Cmd: pTGameCmd; sHumanName, sSkillName: string);
    procedure CmdDeleteItem(Cmd: pTGameCmd; sHumanName, sItemName: string; nCount: Integer);
    procedure CmdClearMission(Cmd: pTGameCmd; sHumanName: string);

    procedure CmdTraining(sSkillName: string; nLevel: Integer);
    procedure CmdChangeJob(Cmd: pTGameCmd; sHumanName, sJobName: string);
    procedure CmdChangeGender(Cmd: pTGameCmd; sHumanName, sSex: string);
    procedure CmdMission(Cmd: pTGameCmd; sX, sY: string);
    procedure CmdMobPlace(Cmd: pTGameCmd; sX, sY, sMonName, sCount: string);
    procedure CmdMobLevel(Cmd: pTGameCmd; Param: string);
    procedure CmdMobCount(Cmd: pTGameCmd; sMapName: string);
    procedure CmdHumanCount(Cmd: pTGameCmd; sMapName: string);

    procedure CmdDisableFilter(sCmd, sParam1: string);
    procedure CmdChangeUserFull(sCmd, sUserCount: string);
    procedure CmdChangeZenFastStep(sCmd, sFastStep: string);

    procedure CmdReconnection(sCmd, sIPaddr, sPort: string);
    procedure CmdContestPoint(Cmd: pTGameCmd; sGuildName: string);
    procedure CmdStartContest(Cmd: pTGameCmd; sParam1: string);
    procedure CmdEndContest(Cmd: pTGameCmd; sParam1: string);

    procedure CmdAnnouncement(Cmd: pTGameCmd; sGuildName: string);
    procedure CmdKill(Cmd: pTGameCmd; sHumanName: string);
    procedure CmdMakeItem(Cmd: pTGameCmd; sItemName: string; nCount: Integer);
    procedure CmdSmakeItem(Cmd: pTGameCmd; nWhere, nValueType, nValue: Integer);
    procedure CmdBonuPoint(Cmd: pTGameCmd; sHumName: string; nCount: Integer);
    procedure CmdDelBonuPoint(Cmd: pTGameCmd; sHumName: string);
    procedure CmdRestBonuPoint(Cmd: pTGameCmd; sHumName: string);

    procedure CmdFireBurn(nInt, nTime, nN: Integer);
    procedure CmdTestFire(sCmd: string; nRange, nType, nTime, nPoint: Integer);

    procedure CmdTestStatus(sCmd: string; nType, nTime: Integer);

    procedure CmdDelGold(Cmd: pTGameCmd; sHumName: string; nCount: Integer);
    procedure CmdAddGold(Cmd: pTGameCmd; sHumName: string; nCount: Integer);
    procedure CmdDelGameGold(sCmd, sHumName: string; nPoint: Integer);
    procedure CmdAddGameGold(sCmd, sHumName: string; nPoint: Integer);
    procedure CmdGameGold(Cmd: pTGameCmd; sHumanName: string; sCtr: string; nGold: Integer);
    procedure CmdGamePoint(Cmd: pTGameCmd; sHumanName: string; sCtr: string; nPoint: Integer);
    procedure CmdCreditPoint(Cmd: pTGameCmd; sHumanName: string; sCtr: string; nPoint: Integer);

    procedure CmdMob(Cmd: pTGameCmd; sMonName: string; nCount, nLevel: Integer);

    procedure CmdRefineWeapon(Cmd: pTGameCmd; nDc, nMc, nSc, nHit: Integer);
    procedure CmdRecallMob(Cmd: pTGameCmd; sMonName: string; nCount, nLevel, nAutoChangeColor, nFixColor: Integer);
    procedure CmdLuckPoint(sCmd: string; nPermission: Integer; sHumanName, sCtr, sPoint: string);
    procedure CmdLotteryTicket(sCmd: string; nPermission: Integer; sParam1: string);
    procedure CmdReloadGuild(sCmd: string; nPermission: Integer; sParam1: string);
    procedure CmdReloadLineNotice(sCmd: string; nPermission: Integer; sParam1: string);
    procedure CmdReloadAbuse(sCmd: string; nPermission: Integer; sParam1: string);

    procedure CmdMobNpc(sCmd: string; nPermission: Integer; sParam1, sParam2, sParam3, sParam4: string);
    procedure CmdNpcScript(sCmd: string; nPermission: Integer; sParam1, sParam2, sParam3: string);
    procedure CmdDelNpc(sCmd: string; nPermission: Integer; sParam1: string);
    procedure CmdKickHuman(Cmd: pTGameCmd; sHumName: string);
    procedure CmdTing(Cmd: pTGameCmd; sHumanName: string);
    procedure CmdSuperTing(Cmd: pTGameCmd; sHumanName, sRange: string);
    procedure CmdMapMoveHuman(Cmd: pTGameCmd; sSrcMap, sDenMap: string);
    procedure CmdShutup(Cmd: pTGameCmd; sHumanName, sTime: string);
    procedure CmdShowMapInfo(Cmd: pTGameCmd; sParam1: string);

    procedure CmdShutupRelease(Cmd: pTGameCmd; sHumanName: string; boAll: Boolean);
    procedure CmdShutupList(Cmd: pTGameCmd; sParam1: string);
    procedure CmdShowSbkGold(Cmd: pTGameCmd; sCASTLENAME, sCtr, sGold: string);
    procedure CmdRecallHuman(Cmd: pTGameCmd; sHumanName: string);
    procedure CmdReGotoHuman(Cmd: pTGameCmd; sHumanName: string);
    procedure CmdShowHumanFlag(sCmd: string; nPermission: Integer; sHumanName, sFlag: string);
    procedure CmdShowHumanUnitOpen(sCmd: string; nPermission: Integer; sHumanName, sUnit: string);
    procedure CmdShowHumanUnit(sCmd: string; nPermission: Integer; sHumanName, sUnit: string);

    procedure CmdChangeAdminMode(sCmd: string; nPermission: Integer; sParam1: string; boFlag: Boolean);
    procedure CmdChangeObMode(sCmd: string; nPermission: Integer; sParam1: string; boFlag: Boolean);
    procedure CmdChangeSuperManMode(sCmd: string; nPermission: Integer; sParam1: string; boFlag: Boolean);
    procedure CmdChangeLevel(Cmd: pTGameCmd; sParam1: string);
    procedure CmdChangeDearName(Cmd: pTGameCmd; sHumanName: string; sDearName: string);
    procedure CmdChangeMasterName(Cmd: pTGameCmd; sHumanName: string; sMasterName, sIsMaster: string);
    procedure CmdStartQuest(Cmd: pTGameCmd; sQuestName: string);
    procedure CmdSetPermission(Cmd: pTGameCmd; sHumanName, sPermission: string);
    procedure CmdClearMapMonster(Cmd: pTGameCmd; sMapName, sMonName, sItems: string);
    procedure CmdReNewLevel(Cmd: pTGameCmd; sHumanName, sLevel: string);

    procedure CmdDenyIPaddrLogon(Cmd: pTGameCmd; sIPaddr, sFixDeny: string);
    procedure CmdDelDenyIPaddrLogon(Cmd: pTGameCmd; sIPaddr, sFixDeny: string);
    procedure CmdShowDenyIPaddrLogon(Cmd: pTGameCmd; sIPaddr, sFixDeny: string);

    procedure CmdDenyAccountLogon(Cmd: pTGameCmd; sAccount, sFixDeny: string);
    procedure CmdDelDenyAccountLogon(Cmd: pTGameCmd; sAccount, sFixDeny: string);
    procedure CmdShowDenyAccountLogon(Cmd: pTGameCmd; sAccount, sFixDeny: string);

    procedure CmdDenyCharNameLogon(Cmd: pTGameCmd; sCharName, sFixDeny: string);
    procedure CmdDelDenyCharNameLogon(Cmd: pTGameCmd; sCharName, sFixDeny: string);
    procedure CmdShowDenyCharNameLogon(Cmd: pTGameCmd; sCharName, sFixDeny: string);
    procedure CmdViewWhisper(Cmd: pTGameCmd; sCharName, sParam2: string);
    procedure CmdSpirtStart(sCmd: string; sParam1: string);
    procedure CmdSpirtStop(sCmd: string; sParam1: string);
    procedure CmdSetMapMode(sCmd: string; sMapName, sMapMode, sParam1, sParam2: string);
    procedure CmdShowMapMode(sCmd: string; sMapName: string);
    procedure CmdClearHumanPassword(sCmd: string; nPermission: Integer; sHumanName: string);

    procedure CmdChangeItemName(sCmd, sMakeIndex, sItemIndex, sItemName: string);
    procedure CmdDisableSendMsg(Cmd: pTGameCmd; sHumanName: string);
    procedure CmdEnableSendMsg(Cmd: pTGameCmd; sHumanName: string);
    procedure CmdDisableSendMsgList(Cmd: pTGameCmd);
    procedure CmdTestGetBagItems(Cmd: pTGameCmd; sParam: string);
    procedure CmdMobFireBurn(Cmd: pTGameCmd; sMAP, sX, sY, sType, sTime, sPoint: string);
    procedure CmdTestSpeedMode(Cmd: pTGameCmd);

    procedure ProcessUserCmd(sParam1, sParam2, sParam3, sParam4, sParam5, sParam6, sParam7: string);

    function DieFunc: Boolean;
    function LevelUpFunc: Boolean;
    function KillPlayFunc: Boolean;
    function KillMonsterFunc: Boolean;
    function DieGotoLable(): Boolean;

    function IsGotoLabel(sMapName: string; nX, nY, nRange, nQuestFalgStatus: Integer; boQuestFalgStatus: Boolean; sItemName1, sItemName2: string; boNeedGroup: Boolean; nRandomCount: Integer): Boolean;
    procedure StartMapEventOfDropItem(sItemName: string);
    procedure StartMapEventOfPickUpItem(sItemName: string);
    procedure StartMapEventOfMine();
    procedure StartMapEventOfWalk();
    procedure StartMapEventOfRun();
  end;

procedure AddUserLog(sMsg: string);

implementation

uses M2Share, Guild, HUtil32, EDcode, ObjNpc, IdSrvClient, ItmUnit, Event,
  ObjMon, LocalDB, Castle, EDcodeUnit, svMain, PlugOfEngine, ObjPlayMon;
{ TBaseObject }

constructor TBaseObject.Create;
begin
  m_boGhost := False;
  m_dwGhostTick := 0;
  m_boDeath := False;
  m_dwDeathTick := 0;
  m_SendRefMsgTick := GetTickCount();
  m_btDirection := 4;
  m_btRaceServer := RC_ANIMAL;
  m_btRaceImg := 0;
  m_btHair := 0;
  m_btJob := 0;
  m_nGold := 0;
  m_wAppr := 0;
  bo2B9 := True;
  m_nViewRange := 5;
  m_sHomeMap := '0';
  bo94 := False;
  m_btPermission := 0;
  m_nLight := 0;
  m_btNameColor := 255;
  m_nHitPlus := 0;
  m_nHitDouble := 0;
  m_dBodyLuck := 0;
  m_wGroupRcallTime := 0;
  m_dwGroupRcallTick := GetTickCount();
  m_boRecallSuite := False;
  bo245 := False;
  m_boTestGa := False;
  m_boGsa := False;
  bo2BA := False;
  m_boAbilSeeHealGauge := False;
  m_boPowerHit := False;
  m_boUseThrusting := False;
  m_boUseHalfMoon := False;
  m_boFireHitSkill := False;
  m_btHitPoint := 5;
  m_btSpeedPoint := 15;
  m_nHitSpeed := 0;
  m_btLifeAttrib := 0;
  m_btAntiPoison := 0;
  m_nPoisonRecover := 0;
  m_nHealthRecover := 0;
  m_nSpellRecover := 0;
  m_nAntiMagic := 0;
  m_nLuck := 0;
  m_nIncSpell := 0;
  m_nIncHealth := 0;
  m_nIncHealing := 0;
  m_nPerHealth := 5;
  m_nPerHealing := 5;
  m_nPerSpell := 5;
  m_dwIncHealthSpellTick := GetTickCount();
  m_btGreenPoisoningPoint := 0;
  m_nFightZoneDieCount := 0;
  //  m_nGoldMax       := 5000000;
  m_nGoldMax := g_Config.nHumanMaxGold;
  m_nCharStatus := 0;
  m_nCharStatusEx := 0;
  FillChar(m_wStatusTimeArr, SizeOf(TStatusTime), #0); //004B7A83
  FillChar(m_BonusAbil, SizeOf(TNakedAbility), #0);
  FillChar(m_CurBonusAbil, SizeOf(TNakedAbility), #0);

  FillChar(m_wStatusArrValue, SizeOf(m_wStatusArrValue), 0);
  FillChar(m_dwStatusArrTimeOutTick, SizeOf(m_dwStatusArrTimeOutTick), #0);
  m_boAllowGroup := False;
  m_boAllowGuild := False;
  btB2 := 0;
  m_btAttatckMode := 0;
  m_boInFreePKArea := False;
  m_boGuildWarArea := False;
  bo2B0 := False;
  m_boSuperMan := False;
  m_boSkeleton := False;
  bo2BF := False;
  m_boHolySeize := False;
  m_boCrazyMode := False;
  m_boShowHP := False;
  bo2F0 := False;
  m_boAnimal := False;
  m_boNoItem := False;
  m_nBodyLeathery := 50;
  m_boFixedHideMode := False;
  m_boStickMode := False;
  m_boNoAttackMode := False;
  bo2C1 := False;
  m_boPKFlag := False;
  m_nMoXieSuite := 0;
  m_nHongMoSuite := 0;
  m_db3B0 := 0;
  FillChar(m_AddAbil, SizeOf(TAddAbility), #0);
  m_MsgList := TList.Create;
  m_VisibleHumanList := TList.Create;
  LIst_3EC := TList.Create;
  m_VisibleActors := TList.Create;
  m_VisibleItems := TList.Create;
  m_VisibleEvents := TList.Create;
  m_ItemList := TList.Create;
  m_DealItemList := TList.Create;
  m_boIsVisibleActive := False;
  m_nProcessRunCount := 0;
  m_nDealGolds := 0;
  m_MagicList := TList.Create;
  m_StorageItemList := TList.Create;
  FillChar(m_UseItems, SizeOf(THumanUseItems), 0);
  m_MagicOneSwordSkill := nil;
  m_MagicPowerHitSkill := nil;
  m_MagicErgumSkill := nil;
  m_MagicBanwolSkill := nil;
  m_MagicFireSwordSkill := nil;
  m_MagicCrsSkill := nil;
  m_Magic41Skill := nil;
  m_Magic42Skill := nil;
  m_Magic43Skill := nil;
  m_GroupOwner := nil;
  m_Castle := nil;
  m_Master := nil;
  n294 := 0;
  m_btSlaveExpLevel := 0;
  bt2A0 := 0;
  m_GroupMembers := TStringList.Create;
  m_boHearWhisper := True;
  m_boBanShout := True;
  m_boBanGuildChat := True;
  m_boAllowDeal := True;
  m_boAllowGroupReCall := False;
  m_BlockWhisperList := TStringList.Create;
  m_SlaveList := TList.Create;
  FillChar(m_WAbil, SizeOf(TAbility), #0);
  FillChar(m_QuestUnitOpen, SizeOf(TQuestUnit), #0);
  FillChar(m_QuestUnit, SizeOf(TQuestUnit), #0);
  m_Abil.Level := 1;
  m_Abil.AC := 0;
  m_Abil.MAC := 0;
  m_Abil.DC := MakeLong(1, 4);
  m_Abil.MC := MakeLong(1, 2);
  m_Abil.SC := MakeLong(1, 2);
  m_Abil.HP := 15;
  m_Abil.MP := 15;
  m_Abil.MaxHP := 15;
  m_Abil.MaxMP := 15;
  m_Abil.Exp := 0;
  m_Abil.MaxExp := 50;
  m_Abil.Weight := 0;
  m_Abil.MaxWeight := 100;
  m_boWantRefMsg := False;
  m_boDealing := False;
  m_DealCreat := nil;
  m_MyGuild := nil;
  m_nGuildRankNo := 0;
  m_sGuildRankName := '';
  m_sScriptLable := '';
  m_boMission := False;
  m_boHideMode := False;
  m_boStoneMode := False;
  m_boCoolEye := False;
  m_boUserUnLockDurg := False;
  m_boTransparent := False;
  m_boAdminMode := False;
  m_boObMode := False;
  m_dwRunTick := GetTickCount + LongWord(Random(1500));
  m_nRunTime := 250;
  m_dwSearchTime := Random(2000) + 2000;
  m_dwSearchTick := GetTickCount;
  m_dwDecPkPointTick := GetTickCount;
  m_DecLightItemDrugTick := GetTickCount();
  m_dwPoisoningTick := GetTickCount;
  m_dwVerifyTick := GetTickCount();
  m_dwCheckRoyaltyTick := GetTickCount();
  m_dwDecHungerPointTick := GetTickCount();
  m_dwHPMPTick := GetTickCount();
  m_dwShoutMsgTick := 0;
  m_dwTeleportTick := 0;
  m_dwProbeTick := 0;
  m_dwMapMoveTick := GetTickCount();
  m_dwMasterTick := 0;
  m_nWalkSpeed := 1400;
  m_nNextHitTime := 2000;
  m_nWalkCount := 0;
  m_dwWalkWaitTick := GetTickCount();
  m_boWalkWaitLocked := False;
  m_nHealthTick := 0;
  m_nSpellTick := 0;
  m_TargetCret := nil;
  m_LastHiter := nil;
  m_ExpHitter := nil;
  m_SayMsgList := nil;
  m_boDenyRefStatus := False;
  m_btHorseType := 0;
  m_btDressEffType := 0;
  m_dwPKDieLostExp := 0;
  m_nPKDieLostLevel := 0;
  m_boAddToMaped := True;
  m_boAutoChangeColor := False;
  m_dwAutoChangeColorTick := GetTickCount();
  m_nAutoChangeIdx := 0;

  m_boFixColor := False;
  m_nFixColorIdx := 0;
  m_nFixStatus := -1;
  m_boFastParalysis := False;

  m_boAC := True;
  m_boMAC := True;
  m_boDC := True;
  m_boMC := True;
  m_boSC := True;
  m_boHitSpeed := True;
  m_boMaxHP := True;
  m_boMaxMP := True;
  m_nCopyHumanLevel := 0; //复制人状态
  m_dwSayMyInfoTick := GetTickCount;
  m_dwStationTick := GetTickCount; //站的时间
end;


destructor TBaseObject.Destroy;
var
  i: Integer;
  SendMessage: pTSendMessage;
  nCheckCode: Integer;
resourcestring
  sExceptionMsg = '[Exception] TBaseObject::Destroy Code: %d';
begin
  nCheckCode := 0;
  try
    nCheckCode := 1;
    if m_MsgList <> nil then begin
      if m_MsgList.Count > 0 then begin
        for i := 0 to m_MsgList.Count - 1 do begin
          nCheckCode := 2;
          SendMessage := m_MsgList.Items[i];
          if (SendMessage.wIdent = RM_SENDDELITEMLIST) and (SendMessage.nParam1 <> 0) then begin
            nCheckCode := 3;
            if TStringList(SendMessage.nParam1) <> nil then begin
              TStringList(SendMessage.nParam1).Free;
              nCheckCode := 4;
            end;
          end;
          if (SendMessage.wIdent = RM_10401) and (SendMessage.nParam1 <> 0) then begin
            nCheckCode := 5;
            DisPose(pTSlaveInfo(SendMessage.nParam1));
          end;
          nCheckCode := 6;
          if (SendMessage.Buff <> nil) then begin
            nCheckCode := 7;
            FreeMem(SendMessage.Buff);
          end;
          DisPose(SendMessage);
          nCheckCode := 8;
        end;
      end;
      nCheckCode := 9;
      FreeAndNil(m_MsgList);
    end;

    nCheckCode := 10;
    if m_VisibleHumanList <> nil then
      FreeAndNil(m_VisibleHumanList);
    nCheckCode := 11;
    for i := 0 to LIst_3EC.Count - 1 do begin

    end;
    FreeAndNil(LIst_3EC);
    nCheckCode := 12;
    if m_VisibleActors <> nil then begin
      if m_VisibleActors.Count > 0 then begin
        for i := 0 to m_VisibleActors.Count - 1 do begin
          if pTVisibleBaseObject(m_VisibleActors.Items[i]) <> nil then
            DisPose(pTVisibleBaseObject(m_VisibleActors.Items[i]));
        end;
      end;
      nCheckCode := 13;
      FreeAndNil(m_VisibleActors);
    end;
    nCheckCode := 14;
    if m_VisibleItems <> nil then begin
      if m_VisibleItems.Count > 0 then begin
        for i := 0 to m_VisibleItems.Count - 1 do begin
          if pTVisibleMapItem(m_VisibleItems.Items[i]) <> nil then
            DisPose(pTVisibleMapItem(m_VisibleItems.Items[i]));
        end;
      end;
      nCheckCode := 15;
      FreeAndNil(m_VisibleItems);
    end;
    nCheckCode := 16;
    if m_VisibleEvents <> nil then
      FreeAndNil(m_VisibleEvents);
    nCheckCode := 17;
    if m_ItemList <> nil then begin
      if m_ItemList.Count > 0 then begin
        for i := 0 to m_ItemList.Count - 1 do begin
          if pTUserItem(m_ItemList.Items[i]) <> nil then
            DisPose(pTUserItem(m_ItemList.Items[i]));
        end;
      end;
      nCheckCode := 18;
      FreeAndNil(m_ItemList);
    end;
    nCheckCode := 19;
    if m_DealItemList <> nil then begin
      if m_DealItemList.Count > 0 then begin
        for i := 0 to m_DealItemList.Count - 1 do begin
          if pTUserItem(m_DealItemList.Items[i]) <> nil then
            DisPose(pTUserItem(m_DealItemList.Items[i]));
        end;
      end;
      FreeAndNil(m_DealItemList);
      nCheckCode := 20;
    end;
    if m_MagicList <> nil then begin
      if m_MagicList.Count > 0 then begin
        for i := 0 to m_MagicList.Count - 1 do begin
          if pTUserMagic(m_MagicList.Items[i]) <> nil then
            DisPose(pTUserMagic(m_MagicList.Items[i]));
        end;
      end;
      FreeAndNil(m_MagicList);
      nCheckCode := 21;
    end;
    if m_StorageItemList <> nil then begin
      if m_StorageItemList.Count > 0 then begin
        for i := 0 to m_StorageItemList.Count - 1 do begin
          if pTUserItem(m_StorageItemList.Items[i]) <> nil then
            DisPose(pTUserItem(m_StorageItemList.Items[i]));
        end;
      end;
      FreeAndNil(m_StorageItemList);
      nCheckCode := 22;
    end;
    if m_GroupMembers <> nil then
      FreeAndNil(m_GroupMembers);
    nCheckCode := 23;
    if m_BlockWhisperList <> nil then
      FreeAndNil(m_BlockWhisperList);
    nCheckCode := 24;
    if m_SlaveList <> nil then
      FreeAndNil(m_SlaveList);
    nCheckCode := 25;
  except
    on E: Exception do begin
      MainOutMessage(format(sExceptionMsg, [nCheckCode]));
      MainOutMessage(E.Message);
    end;
  end;
  {
  for I := 0 to CertCheck.Count - 1 do begin
    if CertCheck.Items[I] = Self then begin
      CertCheck.Delete(I);
      break;
    end;
  end;
  }
  inherited;
end;

procedure TBaseObject.ChangePKStatus(boWarFlag: Boolean);
begin
  if m_boInFreePKArea <> boWarFlag then begin
    m_boInFreePKArea := boWarFlag;
    m_boNameColorChanged := True;
  end;
end;

function TBaseObject.GetDropPosition(nOrgX, nOrgY, nRange: Integer; var nDX: Integer; var nDY: Integer): Boolean; //004C5238
var
  i, ii, III: Integer;
  nItemCount, n24, n28, n2C: Integer;
begin
  n24 := 999;
  Result := False;
  n28 := 0; //09/10
  n2C := 0; //09/10
  for i := 1 to nRange do begin
    for ii := -i to i do begin
      for III := -i to i do begin
        nDX := nOrgX + III;
        nDY := nOrgY + ii;
        if m_PEnvir.GetItemEx(nDX, nDY, nItemCount) = nil then begin
          if m_PEnvir.bo2C then begin
            Result := True;
            break;
          end;
        end else begin
          if m_PEnvir.bo2C and (n24 > nItemCount) then begin
            n24 := nItemCount;
            n28 := nDX;
            n2C := nDY;
          end;
        end;
      end;
      if Result then break;
    end;
    if Result then break;
  end;
  if not Result then begin
    if n24 < 8 then begin
      nDX := n28;
      nDY := n2C;
    end else begin
      nDX := nOrgX;
      nDY := nOrgY;
    end;
  end;
end;

function TBaseObject.DropItemDown(UserItem: pTUserItem; nScatterRange: Integer; boDieDrop: Boolean; ItemOfCreat, DropCreat: TBaseObject): Boolean;
var
  dx, dy, idura: Integer;
  MapItem, pr: PTMapItem;
  StdItem: pTStdItem;
  logcap: string;
  sUserItemName: string;
begin
  Result := False;
  StdItem := UserEngine.GetStdItem(UserItem.wIndex);
  if StdItem <> nil then begin
    if StdItem.StdMode = 40 then begin
      idura := UserItem.Dura;
      idura := idura - 2000;
      if idura < 0 then idura := 0;
      UserItem.Dura := idura;
    end;
    New(MapItem);
    MapItem.UserItem := UserItem^;
    MapItem.Name := StdItem.Name;

    //取自定义物品名称
    sUserItemName := '';
    if UserItem.btValue[13] = 1 then begin
      sUserItemName := ItemUnit.GetCustomItemName(UserItem.MakeIndex, UserItem.wIndex);
      if sUserItemName <> '' then
        MapItem.Name := sUserItemName;
    end;
    MapItem.Looks := StdItem.Looks;
    if StdItem.StdMode = 45 then begin //林荤困, 格犁
      MapItem.Looks := GetRandomLook(MapItem.Looks, StdItem.Shape);
    end;
    MapItem.AniCount := StdItem.AniCount;
    MapItem.Reserved := 0;
    MapItem.Count := 1;
    MapItem.OfBaseObject := ItemOfCreat;
    MapItem.dwCanPickUpTick := GetTickCount();
    MapItem.DropBaseObject := DropCreat;
    GetDropPosition(m_nCurrX, m_nCurrY, nScatterRange, dx, dy);
    pr := m_PEnvir.AddToMap(dx, dy, OS_ITEMOBJECT, TObject(MapItem));
    if pr = MapItem then begin
      SendRefMsg(RM_ITEMSHOW, MapItem.Looks, Integer(MapItem), dx, dy, MapItem.Name);
      if boDieDrop then logcap := '15'
      else logcap := '7';
      if not IsCheapStuff(StdItem.StdMode) then
        if StdItem.NeedIdentify = 1 then
          AddGameDataLog(logcap + #9 +
            m_sMapName + #9 +
            IntToStr(m_nCurrX) + #9 +
            IntToStr(m_nCurrY) + #9 +
            m_sCharName + #9 +
            //UserEngine.GetStdItemName(ui.wIndex) + #9 +
            StdItem.Name + #9 +
            IntToStr(UserItem.MakeIndex) + #9 +
            BoolToIntStr(m_btRaceServer = RC_PLAYOBJECT) + #9 +
            '0');
      Result := True;
    end else begin
      DisPose(MapItem);
    end;
  end;
end;

procedure TBaseObject.GoldChanged();
begin
  if m_btRaceServer = RC_PLAYOBJECT then begin
    SendUpdateMsg(Self, RM_GOLDCHANGED, 0, 0, 0, 0, '');
  end;
end;

procedure TBaseObject.GameGoldChanged();
begin
  if m_btRaceServer = RC_PLAYOBJECT then begin
    SendUpdateMsg(Self, RM_GAMEGOLDCHANGED, 0, 0, 0, 0, '');
  end;
end;

function TPlayObject.ClientPickUpItem: Boolean;
  function IsSelf(BaseObject: TBaseObject): Boolean;
  begin
    if (BaseObject = nil) or (Self = BaseObject) then Result := True
    else Result := False;
  end;
  function IsOfGroup(BaseObject: TBaseObject): Boolean;
  var
    i: Integer;
    GroupMember: TBaseObject;
  begin
    Result := False;
    if m_GroupOwner = nil then Exit;
    for i := 0 to m_GroupOwner.m_GroupMembers.Count - 1 do begin
      GroupMember := TBaseObject(m_GroupOwner.m_GroupMembers.Objects[i]);
      if GroupMember = BaseObject then begin
        Result := True;
        break;
      end;
    end;
  end;
var
  UserItem: pTUserItem;
  MapItem: PTMapItem;
  StdItem: pTStdItem;
  PlayObject: TPlayObject;
begin
  Result := False;
  if m_boDealing then Exit;
  MapItem := m_PEnvir.GetItem(m_nCurrX, m_nCurrY);
  if MapItem = nil then Exit;

  if (GetTickCount - MapItem.dwCanPickUpTick) > g_Config.dwFloorItemCanPickUpTime {2 * 60 * 1000} then begin
    MapItem.OfBaseObject := nil;
  end;
  if not IsSelf(TBaseObject(MapItem.OfBaseObject)) and not IsOfGroup(TBaseObject(MapItem.OfBaseObject)) then begin
    SysMsg(g_sCanotPickUpItem {'在一定时间以内无法捡起此物品！！！'}, c_Red, t_Hint);
    Exit;
  end;
  if CompareText(MapItem.Name, sSTRING_GOLDNAME) = 0 then begin
    if m_PEnvir.DeleteFromMap(m_nCurrX, m_nCurrY, OS_ITEMOBJECT, TObject(MapItem)) = 1 then begin
      if IncGold(MapItem.Count) then begin
        SendRefMsg(RM_ITEMHIDE, 0, Integer(MapItem), m_nCurrX, m_nCurrY, '');
        if g_boGameLogGold then //004C5E8C
          AddGameDataLog('4' + #9 +
            m_sMapName + #9 +
            IntToStr(m_nCurrX) + #9 +
            IntToStr(m_nCurrY) + #9 +
            m_sCharName + #9 +
            sSTRING_GOLDNAME + #9 +
            IntToStr(MapItem.Count) + #9 +
            '1' + #9 +
            '0');
        GoldChanged;
        DisPose(MapItem);
      end else
        m_PEnvir.AddToMap(m_nCurrX, m_nCurrY, OS_ITEMOBJECT, TObject(MapItem));
    end;
    Exit;
  end;

  if IsEnoughBag then begin
    if m_PEnvir.DeleteFromMap(m_nCurrX, m_nCurrY, OS_ITEMOBJECT, TObject(MapItem)) = 1 then begin
      New(UserItem);
      UserItem^ := MapItem.UserItem;
      StdItem := UserEngine.GetStdItem(UserItem.wIndex);
      if (StdItem <> nil) and IsAddWeightAvailable(UserEngine.GetStdItemWeight(UserItem.wIndex)) then begin
        SendMsg(Self, RM_ITEMHIDE, 0, Integer(MapItem), m_nCurrX, m_nCurrY, '');
        AddItemToBag(UserItem);
        if not IsCheapStuff(StdItem.StdMode) then
          if StdItem.NeedIdentify = 1 then
            AddGameDataLog('4' + #9 +
              m_sMapName + #9 +
              IntToStr(m_nCurrX) + #9 +
              IntToStr(m_nCurrY) + #9 +
              m_sCharName + #9 +
              //UserEngine.GetStdItemName(pu.wIndex) + #9 +
              StdItem.Name + #9 +
              IntToStr(UserItem.MakeIndex) + #9 +
              '1' + #9 +
              '0');
        DisPose(MapItem);
        if m_btRaceServer = RC_PLAYOBJECT then begin
          PlayObject := TPlayObject(Self);
          PlayObject.SendAddItem(UserItem);
        end;
        Result := True;
      end else begin
        DisPose(UserItem);
        m_PEnvir.AddToMap(m_nCurrX, m_nCurrY, OS_ITEMOBJECT, TObject(MapItem));
      end;
    end;
  end;
end;

procedure TPlayObject.RunNotice;
var
  Msg: TProcessMessage;
resourcestring
  sExceptionMsg = '[Exception] TPlayObject::RunNotice';
begin
  if m_boEmergencyClose or m_boKickFlag or m_boSoftClose then begin
    if m_boKickFlag then SendDefMessage(SM_OUTOFCONNECTION, 0, 0, 0, 0, '');
    MakeGhost();
  end else begin
    try
      if not m_boSendNotice then begin
        SendNotice();
        m_boSendNotice := True;
        m_dwWaitLoginNoticeOKTick := GetTickCount();
      end else begin
        if GetTickCount - m_dwWaitLoginNoticeOKTick > 30 * 1000 then begin
          m_boEmergencyClose := True;
        end;
        while GetMessage(@Msg) do begin
          if Msg.wIdent = CM_LOGINNOTICEOK then begin
            m_boLoginNoticeOK := True;
            m_dwClientTick := Msg.nParam1;
            SysMsg(IntToStr(m_dwClientTick), c_Red, t_Notice);
          end;
        end;
      end;
    except
      MainOutMessage(sExceptionMsg);
    end;
  end;
end;

procedure TPlayObject.WinExp(dwExp: LongWord);
begin
  if m_Abil.Level > g_Config.nLimitExpLevel then begin
    dwExp := g_Config.nLimitExpValue;
    GetExp(dwExp);
  end else
    if dwExp > 0 then begin
    dwExp := g_Config.dwKillMonExpMultiple * dwExp; //系统指定杀怪经验倍数
    dwExp := LongWord(m_nKillMonExpMultiple) * dwExp; //人物指定的杀怪经验倍数
    dwExp := ROUND((m_nKillMonExpRate / 100) * dwExp); //人物指定的杀怪经验倍数
    if m_PEnvir.m_boEXPRATE then
      dwExp := ROUND((m_PEnvir.m_nEXPRATE / 100) * dwExp); //地图上指定杀怪经验倍数
    if m_boExpItem then begin //物品经验倍数
      dwExp := ROUND(m_rExpItem * dwExp);
    end;
    GetExp(dwExp);
  end;
end;

procedure TPlayObject.GetExp(dwExp: LongWord);
begin
  Inc(m_Abil.Exp, dwExp);
  AddBodyLuck(dwExp * 0.002);
  if not m_boNotOnlineAddExp then //只发送给非离线挂机人物
    SendMsg(Self, RM_WINEXP, 0, dwExp, 0, 0, '');
  if m_Abil.Exp >= m_Abil.MaxExp then begin
    Dec(m_Abil.Exp, m_Abil.MaxExp);
    if m_Abil.Level < MAXUPLEVEL then begin
      Inc(m_Abil.Level);
    end;
    HasLevelUp(m_Abil.Level - 1);
    AddBodyLuck(100);
    AddGameDataLog('12' + #9 +
      m_sMapName + #9 +
      IntToStr(m_Abil.Level) + #9 +
      IntToStr(m_Abil.Exp) + #9 +
      m_sCharName + #9 +
      '0' + #9 +
      '0' + #9 +
      '1' + #9 +
      '0');
    IncHealthSpell(2000, 2000);
  end;
end;

procedure TBaseObject.RecalcLevelAbilitys();
var
  nLevel, n: Integer;
begin
  nLevel := m_Abil.Level;
  case m_btJob of
    2: begin
        //m_Abil.MaxHP:=_MIN(High(Word),14 + ROUND((nLevel / 6 + 2.5) * nLevel));
        m_Abil.MaxHP := _MIN(High(Word), 14 + ROUND(((nLevel / g_Config.nLevelValueOfTaosHP + g_Config.nLevelValueOfTaosHPRate) * nLevel)));

        //m_Abil.MaxMP:=_MIN(High(Word),13 + ROUND((nLevel / 8)* 2.2 * nLevel));
        m_Abil.MaxMP := _MIN(High(Word), 13 + ROUND(((nLevel / g_Config.nLevelValueOfTaosMP) * 2.2 * nLevel)));

        m_Abil.MaxWeight := 50 + ROUND((nLevel / 4) * nLevel);
        m_Abil.MaxWearWeight := 15 + ROUND((nLevel / 50) * nLevel);
        m_Abil.MaxHandWeight := 12 + ROUND((nLevel / 42) * nLevel);

        n := nLevel div 7;
        m_Abil.DC := MakeLong(_MAX(n - 1, 0), _MAX(1, n));
        m_Abil.MC := 0;
        m_Abil.SC := MakeLong(_MAX(n - 1, 0), _MAX(1, n));
        m_Abil.AC := 0;

        n := ROUND(nLevel / 6);
        m_Abil.MAC := MakeLong(n div 2, n + 1);
      end;
    1: begin
        //m_Abil.MaxHP:=_MIN(High(Word),14 + ROUND((nLevel / 15 + 1.8) * nLevel));
        m_Abil.MaxHP := _MIN(High(Word), 14 + ROUND(((nLevel / g_Config.nLevelValueOfWizardHP + g_Config.nLevelValueOfWizardHPRate) * nLevel)));

        m_Abil.MaxMP := _MIN(High(Word), 13 + ROUND((nLevel / 5 + 2) * 2.2 * nLevel));
        m_Abil.MaxWeight := 50 + ROUND((nLevel / 5) * nLevel);
        m_Abil.MaxWearWeight := 15 + ROUND((nLevel / 100) * nLevel);
        m_Abil.MaxHandWeight := 12 + ROUND((nLevel / 90) * nLevel);

        n := nLevel div 7;
        m_Abil.DC := MakeLong(_MAX(n - 1, 0), _MAX(1, n));
        m_Abil.MC := MakeLong(_MAX(n - 1, 0), _MAX(1, n));
        m_Abil.SC := 0;
        m_Abil.AC := 0;
        m_Abil.MAC := 0;
      end;
    0: begin
        //m_Abil.MaxHP:=_MIN(High(Word),14 + ROUND((nLevel / 4.0 + 4.5 + nLevel / 20) * nLevel));
        m_Abil.MaxHP := _MIN(High(Word), 14 + ROUND(((nLevel / g_Config.nLevelValueOfWarrHP + g_Config.nLevelValueOfWarrHPRate + nLevel / 20) * nLevel)));

        m_Abil.MaxMP := _MIN(High(Word), 11 + ROUND(nLevel * 3.5));
        m_Abil.MaxWeight := 50 + ROUND((nLevel / 3) * nLevel);
        m_Abil.MaxWearWeight := 15 + ROUND((nLevel / 20) * nLevel);
        m_Abil.MaxHandWeight := 12 + ROUND((nLevel / 13) * nLevel);

        m_Abil.DC := MakeLong(_MAX((nLevel div 5) - 1, 1), _MAX(1, (nLevel div 5)));
        m_Abil.SC := 0;
        m_Abil.MC := 0;
        m_Abil.AC := MakeLong(0, (nLevel div 7));
        m_Abil.MAC := 0;
      end;
  end;
  if m_Abil.HP > m_Abil.MaxHP then m_Abil.HP := m_Abil.MaxHP;
  if m_Abil.MP > m_Abil.MaxMP then m_Abil.MP := m_Abil.MaxMP;
end;

procedure TBaseObject.HasLevelUp(nLevel: Integer);
begin
  m_Abil.MaxExp := GetLevelExp(m_Abil.Level);
  RecalcLevelAbilitys();
  RecalcAbilitys();
  if m_btRaceServer = RC_PLAYOBJECT then begin
    if not TPlayObject(Self).m_boNotOnlineAddExp then begin //发送给非离线挂机人物
      SendMsg(Self, RM_LEVELUP, 0, m_Abil.Exp, 0, 0, '');
      TPlayObject(Self).LevelUpFunc();
    end;
  end else begin
    SendMsg(Self, RM_LEVELUP, 0, m_Abil.Exp, 0, 0, '');
  end;
{$IFDEF FOR_ABIL_POINT}
  //4/16老 何磐 利侩
  if prevlevel + 1 = Abil.Level then begin
    BonusPoint := BonusPoint + GetBonusPoint(Job, Abil.Level);
    SendMsg(Self, RM_ADJUST_BONUS, 0, 0, 0, 0, '');
  end else begin
    if prevlevel <> Abil.Level then begin
      //焊呈胶 器牢飘甫 贸澜何磐 促矫 拌魂茄促.
      BonusPoint := GetLevelBonusSum(Job, Abil.Level);
      FillChar(BonusAbil, SizeOf(TNakedAbility), #0);
      FillChar(CurBonusAbil, SizeOf(TNakedAbility), #0);
      //if prevlevel <> 0 then begin
      RecalcLevelAbilitys; //饭骇俊 蝶弗 瓷仿摹甫 拌魂茄促.
      //end else begin
      //   RecalcLevelAbilitys_old;
      //   BonusPoint := 0;
      //end;
      SendMsg(Self, RM_ADJUST_BONUS, 0, 0, 0, 0, '');
    end;
  end;
{$ENDIF}
end;

function TPlayObject.IncGold(tGold: Integer): Boolean;
begin
  Result := False;
  //  if m_nGold + tGold <= BAGGOLD then begin
  if m_nGold + tGold <= g_Config.nHumanMaxGold then begin
    Inc(m_nGold, tGold);
    Result := True;
  end;
end;

procedure TPlayObject.IncGameGold(nGameGold: Integer);
begin
  Inc(m_nGameGold, nGameGold);
end;
procedure TPlayObject.IncGamePoint(nGamePoint: Integer);
begin
  Inc(m_nGamePoint, nGamePoint);
end;

procedure AddUserLog(sMsg: string); //004E42F8
begin
  MainOutMessage(sMsg);
end;

function TBaseObject.WalkTo(btDir: Byte; boFlag: Boolean): Boolean; //004C3F64
var
  nOX, nOY, nNX, nNY, n20, n24: Integer;
  //Envir:TEnvirnoment;
  bo29: Boolean;
resourcestring
  sExceptionMsg = '[Exception] TBaseObject::WalkTo';
begin
  Result := False;
  if m_boHolySeize then Exit;
  try
    nOX := m_nCurrX;
    nOY := m_nCurrY;
    //    Envir:=m_PEnvir;
    m_btDirection := btDir;
    nNX := 0;
    nNY := 0;
    case btDir of
      DR_UP: begin
          nNX := m_nCurrX; nNY := m_nCurrY - 1; end;
      DR_UPRIGHT: begin
          nNX := m_nCurrX + 1; nNY := m_nCurrY - 1; end;
      DR_RIGHT: begin
          nNX := m_nCurrX + 1; nNY := m_nCurrY; end;
      DR_DOWNRIGHT: begin
          nNX := m_nCurrX + 1; nNY := m_nCurrY + 1; end;
      DR_DOWN: begin
          nNX := m_nCurrX; nNY := m_nCurrY + 1; end;
      DR_DOWNLEFT: begin
          nNX := m_nCurrX - 1; nNY := m_nCurrY + 1; end;
      DR_LEFT: begin
          nNX := m_nCurrX - 1; nNY := m_nCurrY; end;
      DR_UPLEFT: begin
          nNX := m_nCurrX - 1; nNY := m_nCurrY - 1; end;
    end;
    if (nNX >= 0) and ((m_PEnvir.m_nWidth - 1) >= nNX) and
      (nNY >= 0) and ((m_PEnvir.m_nHeight - 1) >= nNY) then begin
      bo29 := True;
      if bo2BA and not m_PEnvir.CanSafeWalk(nNX, nNY) then bo29 := False;
      if m_Master <> nil then begin
        m_Master.m_PEnvir.GetNextPosition(m_Master.m_nCurrX, m_Master.m_nCurrY, m_Master.m_btDirection, 1, n20, n24);
        if (nNX = n20) and (nNY = n24) then bo29 := False;
      end;
      if bo29 then begin
        if m_PEnvir.MoveToMovingObject(m_nCurrX, m_nCurrY, Self, nNX, nNY, boFlag) > 0 then begin
          m_nCurrX := nNX;
          m_nCurrY := nNY;
        end;
      end;
    end;
    if (m_nCurrX <> nOX) or (m_nCurrY <> nOY) then begin
      if Walk(RM_WALK) then begin
        if m_boTransparent and m_boHideMode then m_wStatusTimeArr[STATE_TRANSPARENT {0x70}] := 1;
        Result := True;
      end else begin
        m_PEnvir.DeleteFromMap(m_nCurrX, m_nCurrY, OS_MOVINGOBJECT, Self);
        m_nCurrX := nOX;
        m_nCurrY := nOY;
        m_PEnvir.AddToMap(m_nCurrX, m_nCurrY, OS_MOVINGOBJECT, Self);
      end;
    end;
  except
    MainOutMessage(sExceptionMsg);
  end;
end;

function TPlayObject.IsEnoughBag: Boolean;
begin
  Result := False;
  if m_ItemList.Count < MAXBAGITEM then
    Result := True;
end;

function TBaseObject.IsAddWeightAvailable(nWeight: Integer): Boolean;
begin
  Result := False;
  if (m_WAbil.Weight + nWeight) <= m_WAbil.MaxWeight then
    Result := True;
end;

procedure TPlayObject.SendAddItem(UserItem: pTUserItem);
var
  pStdItem: pTStdItem;
  StdItem: TStdItem;
  ClientItem: TClientItem;
  OClientItem: TOClientItem;
  sUserItemName: string;
begin
  if m_nSoftVersionDateEx = 0 then begin
    pStdItem := UserEngine.GetStdItem(UserItem.wIndex);
    if pStdItem = nil then Exit;
    StdItem := pStdItem^;
    ItemUnit.GetItemAddValue(UserItem, StdItem);
    //Move(StdItem,ClientItem.S,SizeOf(TStdItem));
    CopyStdItemToOStdItem(@StdItem, @OClientItem.s);
    //取自定义物品名称
    sUserItemName := '';
    if UserItem.btValue[13] = 1 then
      sUserItemName := ItemUnit.GetCustomItemName(UserItem.MakeIndex, UserItem.wIndex);
    if sUserItemName <> '' then
      OClientItem.s.Name := sUserItemName;

    OClientItem.MakeIndex := UserItem.MakeIndex;
    OClientItem.Dura := UserItem.Dura;
    OClientItem.DuraMax := UserItem.DuraMax;
    if StdItem.StdMode = 50 then begin
      OClientItem.s.Name := OClientItem.s.Name + ' #' + IntToStr(UserItem.Dura);
    end;
    if StdItem.StdMode in [15, 19, 20, 21, 22, 23, 24, 26] then begin
      if UserItem.btValue[8] = 0 then OClientItem.s.Shape := 0
      else OClientItem.s.Shape := 130;
    end;
    m_DefMsg := MakeDefaultMsg(SM_ADDITEM, Integer(Self), 0, 0, 1);
    SendSocket(@m_DefMsg, EncodeBuffer(@OClientItem, SizeOf(TOClientItem)));
  end else begin
    pStdItem := UserEngine.GetStdItem(UserItem.wIndex);
    if pStdItem = nil then Exit;
    StdItem := pStdItem^;
    ItemUnit.GetItemAddValue(UserItem, StdItem);
    Move(StdItem, ClientItem.s, SizeOf(TStdItem));
    //取自定义物品名称
    sUserItemName := '';
    if UserItem.btValue[13] = 1 then
      sUserItemName := ItemUnit.GetCustomItemName(UserItem.MakeIndex, UserItem.wIndex);
    if sUserItemName <> '' then
      ClientItem.s.Name := sUserItemName;

    ClientItem.MakeIndex := UserItem.MakeIndex;
    ClientItem.Dura := UserItem.Dura;
    ClientItem.DuraMax := UserItem.DuraMax;
    if StdItem.StdMode = 50 then begin
      ClientItem.s.Name := ClientItem.s.Name + ' #' + IntToStr(UserItem.Dura);
    end;
    if StdItem.StdMode in [15, 19, 20, 21, 22, 23, 24, 26] then begin
      if UserItem.btValue[8] = 0 then ClientItem.s.Shape := 0
      else ClientItem.s.Shape := 130;
    end;
    m_DefMsg := MakeDefaultMsg(SM_ADDITEM, Integer(Self), 0, 0, 1);
    SendSocket(@m_DefMsg, EncodeBuffer(@ClientItem, SizeOf(TClientItem)));
  end;
end;

function TBaseObject.IsGroupMember(Target: TBaseObject): Boolean;
var
  i: Integer;
begin
  Result := False;
  if m_GroupOwner = nil then Exit;
  for i := 0 to m_GroupOwner.m_GroupMembers.Count - 1 do begin
    if m_GroupOwner.m_GroupMembers.Objects[i] = Target then begin
      Result := True;
      break;
    end;
  end;
end;

procedure TPlayObject.Whisper(whostr, saystr: string);
var
  PlayObject: TPlayObject;
  svidx: Integer;
begin
  PlayObject := UserEngine.GetPlayObject(whostr);
  if PlayObject <> nil then begin
    if not PlayObject.m_boReadyRun then begin
      SysMsg(whostr + g_sCanotSendmsg {'无法发送信息.'}, c_Red, t_Hint);
      Exit;
    end;
    if not PlayObject.m_boHearWhisper or PlayObject.IsBlockWhisper(m_sCharName) then begin
      SysMsg(whostr + g_sUserDenyWhisperMsg {' 拒绝私聊！！！'}, c_Red, t_Hint);
      Exit;
    end;
    if (PlayObject.m_boNotOnlineAddExp) and (PlayObject.m_sAutoSendMsg <> '') then begin //离线挂机人物自动回复
      if m_btPermission >= 10 then begin
        SendMsg(Self, RM_WHISPER, 0, g_Config.btGMWhisperMsgFColor, g_Config.btGMWhisperMsgBColor, 0, PlayObject.m_sCharName + '=>' + ' ' + PlayObject.m_sAutoSendMsg);
      end else begin
        SendMsg(Self, RM_WHISPER, 0, g_Config.btWhisperMsgFColor, g_Config.btWhisperMsgBColor, 0, PlayObject.m_sCharName + '=>' + ' ' + PlayObject.m_sAutoSendMsg);
      end;
      Exit;
    end;
    if m_btPermission > 0 then begin
      PlayObject.SendMsg(PlayObject, RM_WHISPER, 0, g_Config.btGMWhisperMsgFColor, g_Config.btGMWhisperMsgBColor, 0, m_sCharName + '=> ' + saystr);
      //取得私聊信息
      if (m_GetWhisperHuman <> nil) and (not m_GetWhisperHuman.m_boGhost) then
        m_GetWhisperHuman.SendMsg(m_GetWhisperHuman, RM_WHISPER, 0, g_Config.btGMWhisperMsgFColor, g_Config.btGMWhisperMsgBColor, 0, m_sCharName + '=>' + PlayObject.m_sCharName + ' ' + saystr);
      if (PlayObject.m_GetWhisperHuman <> nil) and (not PlayObject.m_GetWhisperHuman.m_boGhost) then
        PlayObject.m_GetWhisperHuman.SendMsg(PlayObject.m_GetWhisperHuman, RM_WHISPER, 0, g_Config.btGMWhisperMsgFColor, g_Config.btGMWhisperMsgBColor, 0, m_sCharName + '=>' + PlayObject.m_sCharName + ' ' + saystr);
    end else begin
      PlayObject.SendMsg(PlayObject, RM_WHISPER, 0, g_Config.btWhisperMsgFColor, g_Config.btWhisperMsgBColor, 0, m_sCharName + '=> ' + saystr);
      if (m_GetWhisperHuman <> nil) and (not m_GetWhisperHuman.m_boGhost) then
        m_GetWhisperHuman.SendMsg(m_GetWhisperHuman, RM_WHISPER, 0, g_Config.btWhisperMsgFColor, g_Config.btWhisperMsgBColor, 0, m_sCharName + '=>' + PlayObject.m_sCharName + ' ' + saystr);

      if (PlayObject.m_GetWhisperHuman <> nil) and (not PlayObject.m_GetWhisperHuman.m_boGhost) then
        PlayObject.m_GetWhisperHuman.SendMsg(PlayObject.m_GetWhisperHuman, RM_WHISPER, 0, g_Config.btWhisperMsgFColor, g_Config.btWhisperMsgBColor, 0, m_sCharName + '=>' + PlayObject.m_sCharName + ' ' + saystr);
    end;
  end else begin
    if UserEngine.FindOtherServerUser(whostr, svidx) then begin
      UserEngine.SendServerGroupMsg(SS_WHISPER, svidx, whostr + '/' + m_sCharName + '=> ' + saystr);
    end else begin
      SysMsg(whostr + g_sUserNotOnLine {'  没有在线！！！'}, c_Red, t_Hint);
    end;
  end;
end;

function TPlayObject.IsBlockWhisper(sName: string): Boolean;
var
  i: Integer;
begin
  Result := False;
  for i := 0 to m_BlockWhisperList.Count - 1 do begin
    if CompareText(sName, m_BlockWhisperList.Strings[i]) = 0 then begin
      Result := True;
      break;
    end;
  end;
end;

function TBaseObject.PKLevel(): Integer;
begin
  Result := m_nPkPoint div 100;
end;

procedure TBaseObject.HealthSpellChanged;
begin
  if m_btRaceServer = RC_PLAYOBJECT then begin
    if not TPlayObject(Self).m_boNotOnlineAddExp then //只发送给非离线挂机人物
      SendUpdateMsg(Self, RM_HEALTHSPELLCHANGED, 0, 0, 0, 0, '');
  end;
  if m_boShowHP then begin
    SendRefMsg(RM_HEALTHSPELLCHANGED, 0, 0, 0, 0, '');
  end;
end;

function TBaseObject.CalcGetExp(nLevel: Integer; nExp: Integer): Integer;
begin
  if g_Config.boHighLevelKillMonFixExp or (m_Abil.Level < (nLevel + 10)) then begin
    Result := nExp;
  end else begin
    Result := nExp - ROUND((nExp / 15) * (m_Abil.Level - (nLevel + 10)));
  end;
  if Result <= 0 then Result := 1;
end;

procedure TBaseObject.RefNameColor();
begin
  SendRefMsg(RM_CHANGENAMECOLOR, 0, 0, 0, 0, '');
end;

procedure TBaseObject.GainSlaveExp(nLevel: Integer);
  function GetUpKillCount(): Integer;
  var
    tCount: Integer;
  begin
    if m_btSlaveExpLevel < SLAVEMAXLEVEL - 2 then begin
      tCount := g_Config.MonUpLvNeedKillCount[m_btSlaveExpLevel];
    end else begin
      tCount := 0;
    end;
    //    Result:= ((m_Abil.Level shl 4) - m_Abil.Level) + 100 + tCount
    Result := ((m_Abil.Level * g_Config.nMonUpLvRate {16}) - m_Abil.Level) + g_Config.nMonUpLvNeedKillBase {100} + tCount
  end;
  {
  var
    nNeedCount:Integer;
  }
begin
  Inc(n294, nLevel);
  if GetUpKillCount() < n294 then begin
    Dec(n294, GetUpKillCount);
    if m_btSlaveExpLevel < (m_btSlaveMakeLevel * 2 + 1) then begin
      Inc(m_btSlaveExpLevel);
      RecalcAbilitys();
      RefNameColor();
    end;
  end;
end;

function TBaseObject.DropGoldDown(nGold: Integer; boFalg: Boolean; GoldOfCreat, DropGoldCreat: TBaseObject): Boolean; //004C5794
var
  MapItem, MapItemA: PTMapItem;
  nX, nY: Integer;
  s20: string;
begin
  Result := False;
  New(MapItem);
  FillChar(MapItem^, SizeOf(TMapItem), #0);
  MapItem.Name := sSTRING_GOLDNAME;
  MapItem.Count := nGold;
  MapItem.Looks := GetGoldShape(nGold);
  MapItem.OfBaseObject := GoldOfCreat;
  MapItem.dwCanPickUpTick := GetTickCount();
  MapItem.DropBaseObject := DropGoldCreat;
  GetDropPosition(m_nCurrX, m_nCurrY, 3, nX, nY);
  MapItemA := m_PEnvir.AddToMap(nX, nY, OS_ITEMOBJECT, TObject(MapItem));
  if MapItemA <> nil then begin
    if MapItemA <> MapItem then begin
      DisPose(MapItem);
      MapItem := MapItemA;
    end;
    SendRefMsg(RM_ITEMSHOW, MapItem.Looks, Integer(MapItem), nX, nY, MapItem.Name);
    if m_btRaceServer = RC_PLAYOBJECT then begin
      if boFalg then s20 := '15'
      else s20 := '7';
      if g_boGameLogGold then
        AddGameDataLog(s20 + #9 +
          m_sMapName + #9 +
          IntToStr(m_nCurrX) + #9 +
          IntToStr(m_nCurrY) + #9 +
          m_sCharName + #9 +
          sSTRING_GOLDNAME + #9 +
          IntToStr(nGold) + #9 +
          BoolToIntStr(m_btRaceServer = RC_PLAYOBJECT) + #9 +
          '0');
    end;
    Result := True;
  end else DisPose(MapItem);
end;

function TBaseObject.GetGuildRelation(cert1, cert2: TBaseObject): Integer;
begin
  Result := 0;
  m_boGuildWarArea := False;
  if (cert1.m_MyGuild = nil) or (cert2.m_MyGuild = nil) then Exit;
  if cert1.InSafeArea or (cert2.InSafeArea) then Exit;
  if TGUild(cert1.m_MyGuild).GuildWarList.Count <= 0 then Exit;
  m_boGuildWarArea := True;
  if TGUild(cert1.m_MyGuild).IsWarGuild(TGUild(cert2.m_MyGuild)) and
    TGUild(cert2.m_MyGuild).IsWarGuild(TGUild(cert1.m_MyGuild)) then Result := 2;
  if cert1.m_MyGuild = cert2.m_MyGuild then Result := 1;
  if TGUild(cert1.m_MyGuild).IsAllyGuild(TGUild(cert2.m_MyGuild)) and
    TGUild(cert2.m_MyGuild).IsAllyGuild(TGUild(cert1.m_MyGuild)) then Result := 3;
end;

procedure TBaseObject.IncPkPoint(nPoint: Integer);
var
  nOldPKLevel: Integer;
begin
  nOldPKLevel := PKLevel;
  Inc(m_nPkPoint, nPoint);
  if PKLevel <> nOldPKLevel then begin
    if PKLevel <= 2 then RefNameColor;
  end;
end;

procedure TBaseObject.AddBodyLuck(dLuck: Double);
var
  n: Integer;
begin
  if (dLuck > 0) and (m_dBodyLuck < 5 * BODYLUCKUNIT) then begin
    m_dBodyLuck := m_dBodyLuck + dLuck;
  end;
  if (dLuck < 0) and (m_dBodyLuck > -(5 * BODYLUCKUNIT)) then begin
    m_dBodyLuck := m_dBodyLuck + dLuck;
  end;
  n := Trunc(m_dBodyLuck / BODYLUCKUNIT);
  if n > 5 then n := 5;
  if n < -10 then n := -10;
  m_nBodyLuckLevel := n;
end;

procedure TBaseObject.MakeWeaponUnlock;
begin
  if m_UseItems[U_WEAPON].wIndex <= 0 then Exit;
  if m_UseItems[U_WEAPON].btValue[3] > 0 then begin
    Dec(m_UseItems[U_WEAPON].btValue[3]);
    SysMsg(g_sTheWeaponIsCursed, c_Red, t_Hint);
  end else begin
    if m_UseItems[U_WEAPON].btValue[4] < 10 then begin
      Inc(m_UseItems[U_WEAPON].btValue[4]);
      SysMsg(g_sTheWeaponIsCursed, c_Red, t_Hint);
    end;
  end;
  if m_btRaceServer = RC_PLAYOBJECT then begin
    RecalcAbilitys();
    SendMsg(Self, RM_ABILITY, 0, 0, 0, 0, '');
    SendMsg(Self, RM_SUBABILITY, 0, 0, 0, 0, '');
  end;
end;

function TBaseObject.GetAttackPower(nBasePower, nPower: Integer): Integer;
var
  PlayObject: TPlayObject;
begin
  if nPower < 0 then nPower := 0;
  if m_nLuck > 0 then begin
    if Random(10 - _MIN(9, m_nLuck)) = 0 then Result := nBasePower + nPower
    else Result := nBasePower + Random(nPower + 1);
  end else begin
    Result := nBasePower + Random(nPower + 1);
    if m_nLuck < 0 then begin
      if Random(10 - _MAX(0, -m_nLuck)) = 0 then Result := nBasePower;
    end;
  end;
  if m_btRaceServer = RC_PLAYOBJECT then begin
    PlayObject := TPlayObject(Self);
    //Result:=Result * PlayObject.m_nPowerMult + ROUND(Result * (PlayObject.m_nPowerMultPoint / 100));
    Result := ROUND(Result * (PlayObject.m_nPowerRate / 100));
    if PlayObject.m_boPowerItem then
      Result := ROUND(m_rPowerItem * Result);
  end;
  if m_boAutoChangeColor then begin
    Result := Result * m_nAutoChangeIdx + 1;
  end;
  if m_boFixColor then begin
    Result := Result * m_nFixColorIdx + 1;
  end;
end;

procedure TBaseObject.DamageHealth(nDamage: Integer); //减血
var
  nSpdam: Integer;
begin
  if ((m_LastHiter = nil) or not m_LastHiter.m_boUnMagicShield) and m_boMagicShield and (nDamage > 0) and (m_WAbil.MP > 0) then begin
    nSpdam := ROUND(nDamage * 1.5);
    if Integer(m_WAbil.MP) >= nSpdam then begin
      m_WAbil.MP := m_WAbil.MP - nSpdam;
      nSpdam := 0;
    end else begin
      nSpdam := nSpdam - m_WAbil.MP;
      m_WAbil.MP := 0;
    end;
    nDamage := ROUND(nSpdam / 1.5);
    HealthSpellChanged();
  end;
  if nDamage > 0 then begin
    if (m_WAbil.HP - nDamage) > 0 then begin
      m_WAbil.HP := m_WAbil.HP - nDamage;
    end else begin
      m_WAbil.HP := 0;
    end;
  end else begin
    if (m_WAbil.HP - nDamage) < m_WAbil.MaxHP then begin
      m_WAbil.HP := m_WAbil.HP - nDamage;
    end else begin
      m_WAbil.HP := m_WAbil.MaxHP;
    end;
  end;
end;

function TBaseObject.GetBackDir(nDir: Integer): Integer;
begin
  Result := 0;
  case nDir of
    DR_UP: Result := DR_DOWN;
    DR_DOWN: Result := DR_UP;
    DR_LEFT: Result := DR_RIGHT;
    DR_RIGHT: Result := DR_LEFT;
    DR_UPLEFT: Result := DR_DOWNRIGHT;
    DR_UPRIGHT: Result := DR_DOWNLEFT;
    DR_DOWNLEFT: Result := DR_UPRIGHT;
    DR_DOWNRIGHT: Result := DR_UPLEFT;
  end;
end;

function TBaseObject.CharPushed(nDir, nPushCount: Integer): Integer; //冲撞人
var
  i, nX, nY, olddir, oldx, oldy, nBackDir: Integer;
begin
  Result := 0;
  olddir := m_btDirection;
  oldx := m_nCurrX;
  oldy := m_nCurrY;
  m_btDirection := nDir;
  nBackDir := GetBackDir(nDir);
  for i := 0 to nPushCount - 1 do begin
    GetFrontPosition(nX, nY);
    if m_PEnvir.CanWalk(nX, nY, False) then begin
      if m_PEnvir.MoveToMovingObject(m_nCurrX, m_nCurrY, Self, nX, nY, False) > 0 then begin
        m_nCurrX := nX;
        m_nCurrY := nY;
        //SendRefMsg(RM_PUSH, GetBackDir(ndir), m_nCurrX, m_nCurrY, 0, '');
        SendRefMsg(RM_PUSH, nBackDir, m_nCurrX, m_nCurrY, 0, '');
        Inc(Result);
        if m_btRaceServer >= RC_ANIMAL then
          m_dwWalkTick := m_dwWalkTick + 800;
      end else break;
    end else break;
  end;
  //m_btDirection:=GetBackDir(ndir);
  //m_btDirection:=GetBackDir(nBackDir);
  m_btDirection := nBackDir;
  if Result = 0 then m_btDirection := olddir;
end;

function TBaseObject.MagPassThroughMagic(sX, sY, tx, ty, nDir, magpwr: Integer; undeadattack: Boolean): Integer; //004C69F4
var
  i, tCount, acpwr: Integer;
  BaseObject: TBaseObject;
  //   n14,n18:integer;
begin
  tCount := 0;
  for i := 0 to 12 do begin
    BaseObject := TBaseObject(m_PEnvir.GetMovingObject(sX, sY, True));
    if BaseObject <> nil then begin
      if IsProperTarget(BaseObject) then begin
        if Random(10) >= BaseObject.m_nAntiMagic then begin
          if undeadattack then
            acpwr := ROUND(magpwr * 1.5)
          else
            acpwr := magpwr;
          BaseObject.SendDelayMsg(Self, RM_MAGSTRUCK, 0, acpwr, 0, 0, '', 600);
          //BaseObject.SendMsg(Self, RM_MAGSTRUCK, 0, acpwr, 0, 0, '');
          Inc(tCount);
        end;
      end;
    end;
    if not ((abs(sX - tx) <= 0) and (abs(sY - ty) <= 0)) then begin
      nDir := GetNextDirection(sX, sY, tx, ty);
      if not m_PEnvir.GetNextPosition(sX, sY, nDir, 1, sX, sY) then
        break;
    end else
      break;
  end;
  Result := tCount;
end;

procedure TPlayObject.SendSocket(DefMsg: pTDefaultMessage; sMsg: string);
var
  MsgHdr: TMsgHeader;
  nSendBytes: Integer;
  tBuff: PChar;
resourcestring
  sExceptionMsg = '[Exception] TPlayObject::SendSocket..';
begin
  if Assigned(zPlugOfEngine.SendSocket) then begin
    try
      zPlugOfEngine.SendSocket(Self, DefMsg, PChar(sMsg));
    except
    end;
  end else begin
    tBuff := nil;
    try
      MsgHdr.dwCode := RUNGATECODE;
      MsgHdr.nSocket := m_nSocket;
      MsgHdr.wGSocketIdx := m_nGSocketIdx;
      MsgHdr.wIdent := GM_DATA;
      if DefMsg <> nil then begin
        if sMsg <> '' then begin
          MsgHdr.nLength := Length(sMsg) + SizeOf(TDefaultMessage) + 1;
          nSendBytes := MsgHdr.nLength + SizeOf(TMsgHeader);
          GetMem(tBuff, nSendBytes + SizeOf(Integer));
          Move(nSendBytes, tBuff^, SizeOf(Integer));
          Move(MsgHdr, tBuff[SizeOf(Integer)], SizeOf(TMsgHeader));
          Move(DefMsg^, tBuff[SizeOf(TMsgHeader) + SizeOf(Integer)], SizeOf(TDefaultMessage));
          Move(sMsg[1], tBuff[SizeOf(TDefaultMessage) + SizeOf(TMsgHeader) + SizeOf(Integer)], Length(sMsg) + 1);
        end else begin
          MsgHdr.nLength := SizeOf(TDefaultMessage);
          nSendBytes := MsgHdr.nLength + SizeOf(TMsgHeader);
          GetMem(tBuff, nSendBytes + SizeOf(Integer));
          Move(nSendBytes, tBuff^, SizeOf(Integer));
          Move(MsgHdr, tBuff[SizeOf(Integer)], SizeOf(TMsgHeader));
          Move(DefMsg^, tBuff[SizeOf(TMsgHeader) + SizeOf(Integer)], SizeOf(TDefaultMessage));
        end;
      end else begin
        if sMsg <> '' then begin
          MsgHdr.nLength := -(Length(sMsg) + 1);
          nSendBytes := abs(MsgHdr.nLength) + SizeOf(TMsgHeader);
          GetMem(tBuff, nSendBytes + SizeOf(Integer));
          Move(nSendBytes, tBuff^, SizeOf(Integer));
          Move(MsgHdr, tBuff[SizeOf(Integer)], SizeOf(TMsgHeader));
          Move(sMsg[1], tBuff[SizeOf(TMsgHeader) + SizeOf(Integer)], Length(sMsg) + 1);
        end;
      end;
      if not RunSocket.AddGateBuffer(m_nGateIdx, tBuff) then begin
        FreeMem(tBuff);
        //MainOutMessage('SendSocket Buffer Fail ' + IntToStr(m_nGateIdx));
      end;
    except
      MainOutMessage(sExceptionMsg);
    end;
  end;
end;

procedure TPlayObject.SendDefMessage(wIdent: Word; nRecog: Integer; nParam, nTag, nSeries: Word; sMsg: string); //004CAD6C
begin
  m_DefMsg := MakeDefaultMsg(wIdent, nRecog, nParam, nTag, nSeries);
  if sMsg <> '' then SendSocket(@m_DefMsg, EncodeString(sMsg))
  else SendSocket(@m_DefMsg, '');
end;

procedure TPlayObject.ClientQueryUserName(Target: TBaseObject; x, y: Integer);
var
  uname: string;
  TagColor: Integer;
  Def: TDefaultMessage;
begin
  if CretInNearXY(Target, x, y) then begin
    TagColor := GetCharColor(Target);
    Def := MakeDefaultMsg(SM_USERNAME, Integer(Target), TagColor, 0, 0);
    uname := Target.GetShowName;
    SendSocket(@Def, EncodeString(uname));
  end else
    SendDefMessage(SM_GHOST, Integer(Target), x, y, 0, '');
end;

function TBaseObject.GetShowName: string;
var
  sShowName: string;
begin
  sShowName := m_sCharName;
  Result := FilterShowName(sShowName);
  if m_nCopyHumanLevel in [0, 1] then begin
    if (m_Master <> nil) and not m_Master.m_boObMode then begin
      Result := Result + '(' + m_Master.m_sCharName + ')';
    end;
  end else begin
    if (m_nCopyHumanLevel = 2) and (m_Master <> nil) and not m_Master.m_boObMode then begin
      if g_Config.boAddMasterName then begin
        Result := m_Master.m_sCharName + g_Config.sCopyHumName;
      end else begin
        Result := g_Config.sCopyHumName;
      end;
    end;
  end;
  {
  if m_btRaceServer <> RC_PLAYOBJECT then begin
    sShowName:=m_sCharName;
    Result:=FilterShowName(sShowName);
    if (m_Master <> nil) and not m_Master.m_boObMode then begin
      Result:=Result + '(' + m_Master.m_sCharName + ')';
    end;
  end else begin//004C1340
    Result:=m_sCharName;
    if m_MyGuild <> nil then begin
      if UserCastle.IsMasterGuild(TGuild(m_MyGuild)) then begin
        Result:=Result + '\' + TGuild(m_MyGuild).sGuildName + '(' + UserCastle.sName + ')';
      end else begin
        if g_boShowGuildName or (UserCastle.boUnderWar and (m_boInFreePKArea or UserCastle.IsCastleWarArea(m_PEnvir,m_nCurrX,m_nCurrY))) then begin
          Result:=Result + '\' + TGuild(m_MyGuild).sGuildName + '[' + m_sGuildRankName + ']';
        end;
      end;
    end;
  end;
  }
end;

procedure TAnimalObject.Attack(TargeTBaseObject: TBaseObject; nDir: Integer);
begin
  inherited AttackDir(TargeTBaseObject, 0, nDir);
end;

constructor TAnimalObject.Create;
begin
  inherited;
  m_nNotProcessCount := 0;
  m_nTargetX := -1;
  dwTick3F0 := Random(4) * 500 + 1000;
  dwTick3F4 := GetTickCount();
  m_btRaceServer := RC_ANIMAL;
  m_dwHitTick := GetTickCount - LongWord(Random(3000));
  m_dwWalkTick := GetTickCount - LongWord(Random(3000));
  m_dwSearchEnemyTick := GetTickCount();
  m_boRunAwayMode := False;
  m_dwRunAwayStart := GetTickCount();
  m_dwRunAwayTime := 0;
  m_nCopyHumanLevel := 0;
end;

procedure TAnimalObject.GotoTargetXY;
var
  i: Integer;
  nDir: Integer;
  n10: Integer;
  n14: Integer;
  n20: Integer;
  nOldX: Integer;
  nOldY: Integer;
begin
  if ((m_nCurrX <> m_nTargetX) or (m_nCurrY <> m_nTargetY)) then begin
    n10 := m_nTargetX;
    n14 := m_nTargetY;
    dwTick3F4 := GetTickCount();
    nDir := DR_DOWN;
    if n10 > m_nCurrX then begin
      nDir := DR_RIGHT;
      if n14 > m_nCurrY then nDir := DR_DOWNRIGHT;
      if n14 < m_nCurrY then nDir := DR_UPRIGHT;
    end else begin
      if n10 < m_nCurrX then begin
        nDir := DR_LEFT;
        if n14 > m_nCurrY then nDir := DR_DOWNLEFT;
        if n14 < m_nCurrY then nDir := DR_UPLEFT;
      end else begin
        if n14 > m_nCurrY then nDir := DR_DOWN
        else if n14 < m_nCurrY then nDir := DR_UP;
      end;
    end;
    nOldX := m_nCurrX;
    nOldY := m_nCurrY;
    WalkTo(nDir, False);
    n20 := Random(3);
    for i := DR_UP to DR_UPLEFT do begin
      if (nOldX = m_nCurrX) and (nOldY = m_nCurrY) then begin
        if n20 <> 0 then Inc(nDir)
        else if nDir > 0 then Dec(nDir)
        else nDir := DR_UPLEFT;
        if (nDir > DR_UPLEFT) then nDir := DR_UP;
        WalkTo(nDir, False);
      end;
    end;
  end;
end;

function TAnimalObject.Operate(ProcessMsg: pTProcessMessage): Boolean;
begin
  //  Result:=False;
  if ProcessMsg.wIdent = RM_STRUCK then begin
    if (ProcessMsg.BaseObject = Self) and (TBaseObject(ProcessMsg.nParam3 {AttackBaseObject}) <> nil) then begin
      SetLastHiter(TBaseObject(ProcessMsg.nParam3 {AttackBaseObject}));
      Struck(TBaseObject(ProcessMsg.nParam3 {AttackBaseObject})); {0FFEC}
      BreakHolySeizeMode();
      if (m_Master <> nil) and
        (TBaseObject(ProcessMsg.nParam3) <> m_Master) and
        (TBaseObject(ProcessMsg.nParam3).m_btRaceServer = RC_PLAYOBJECT) then begin
        m_Master.SetPKFlag(TBaseObject(ProcessMsg.nParam3));
      end;
      if g_Config.boMonSayMsg then MonsterSayMsg(TBaseObject(ProcessMsg.nParam3), s_UnderFire);
    end;
    Result := True;
  end else begin
    Result := inherited Operate(ProcessMsg);
  end;
end;

procedure TAnimalObject.Run;
begin
  inherited;

end;

procedure TAnimalObject.Struck(hiter: TBaseObject);
var
  btDir: Byte;
begin
  m_dwStruckTick := GetTickCount;
  if hiter <> nil then begin
    if (m_TargetCret = nil) or GetAttackDir(m_TargetCret, btDir) or (Random(6) = 0) then begin
      if IsProperTarget(hiter) then
        SetTargetCreat(hiter);
    end;
  end;
  if m_boAnimal then begin
    m_nMeatQuality := m_nMeatQuality - Random(300);
    if m_nMeatQuality < 0 then m_nMeatQuality := 0;
  end;
  //if m_Abil.Level < 50 then
  m_dwHitTick := m_dwHitTick + LongWord(150 - _MIN(130, m_Abil.Level * 4));
  //WalkTime := WalkTime + (300 - _MIN(200, (Abil.Level div 5) * 20));
end;

procedure TBaseObject.RecalcAbilitys;
var
  Abil: TAbility;
  boOldHideMode: Boolean;
  nOldLight: Integer;
  i: Integer;
  StdItem: pTStdItem;
  boRecallSuite1: Boolean;
  boRecallSuite2: Boolean;
  boRecallSuite3: Boolean;
  boRecallSuite4: Boolean;
  boMoXieSuite1: Boolean;
  boMoXieSuite2: Boolean;
  boMoXieSuite3: Boolean;
  boHongMoSuite1: Boolean;
  boHongMoSuite2: Boolean;
  boHongMoSuite3: Boolean;
  boSpirit1: Boolean;
  boSpirit2: Boolean;
  boSpirit3: Boolean;
  boSpirit4: Boolean;
  n01, n02, n03, n04: Integer;
  //  PlayObject:TPlayObject;
begin
  FillChar(m_AddAbil, SizeOf(TAddAbility), #0);
  Abil := m_WAbil;
  m_WAbil := m_Abil;
  m_WAbil.HP := Abil.HP;
  m_WAbil.MP := Abil.MP;
  m_WAbil.Weight := 0;
  m_WAbil.WearWeight := 0;
  m_WAbil.HandWeight := 0;
  m_btAntiPoison := 0;
  m_nPoisonRecover := 0;
  m_nHealthRecover := 0;
  m_nSpellRecover := 0;
  m_nAntiMagic := 1;
  m_nLuck := 0;
  m_nHitSpeed := 0;
  m_boExpItem := False;
  m_rExpItem := 0;
  m_boPowerItem := False;
  m_rPowerItem := 0;
  boOldHideMode := m_boHideMode;
  m_boHideMode := False;
  m_boTeleport := False;
  m_boParalysis := False;
  m_boRevival := False;
  m_boUnRevival := False;
  m_boFlameRing := False;
  m_boRecoveryRing := False;
  m_boAngryRing := False;
  m_boMagicShield := False;
  m_boUnMagicShield := False;
  m_boMuscleRing := False;
  m_boFastTrain := False;
  m_boProbeNecklace := False;
  m_boSupermanItem := False;
  m_boGuildMove := False;
  m_boUnParalysis := False;
  m_boExpItem := False;
  m_boPowerItem := False;
  m_boNoDropItem := False;
  m_boNoDropUseItem := False;
  m_bopirit := False;
  m_btHorseType := 0;
  m_btDressEffType := 0;

  m_nMoXieSuite := 0;
  boMoXieSuite1 := False;
  boMoXieSuite2 := False;
  boMoXieSuite3 := False;
  m_db3B0 := 0;
  m_nHongMoSuite := 0;
  boHongMoSuite1 := False;
  boHongMoSuite2 := False;
  boHongMoSuite3 := False;

  boSpirit1 := False;
  boSpirit2 := False;
  boSpirit3 := False;
  boSpirit4 := False;

  m_boRecallSuite := False;
  boRecallSuite1 := False;
  boRecallSuite2 := False;
  boRecallSuite3 := False;
  boRecallSuite4 := False;

  m_dwPKDieLostExp := 0;
  m_nPKDieLostLevel := 0;

  for i := Low(THumanUseItems) to High(THumanUseItems) do begin
    if (m_UseItems[i].wIndex <= 0) or (m_UseItems[i].Dura <= 0) then Continue;
    GetAccessory(m_UseItems[i], m_AddAbil);
    StdItem := UserEngine.GetStdItem(m_UseItems[i].wIndex);
    if StdItem = nil then Continue;
    if (i = U_WEAPON) or (i = U_RIGHTHAND) or (i = U_DRESS) then begin
      if i = U_DRESS then begin
        Inc(m_WAbil.WearWeight, StdItem.Weight);
      end else begin
        Inc(m_WAbil.HandWeight, StdItem.Weight);
      end;
      //新增开始
      if StdItem.AniCount = 120 then m_boFastTrain := True;
      if StdItem.AniCount = 121 then m_boProbeNecklace := True;
      if StdItem.AniCount = 145 then m_boGuildMove := True;
      if StdItem.AniCount = 111 then begin
        m_wStatusTimeArr[STATE_TRANSPARENT {8 0x70}] := 6 * 10 * 1000;
        m_boHideMode := True;
      end;
      if StdItem.AniCount = 112 then m_boTeleport := True;
      if StdItem.AniCount = 113 then m_boParalysis := True;
      if StdItem.AniCount = 114 then m_boRevival := True;
      if StdItem.AniCount = 115 then m_boFlameRing := True;
      if StdItem.AniCount = 116 then m_boRecoveryRing := True;
      if StdItem.AniCount = 117 then m_boAngryRing := True;
      if StdItem.AniCount = 118 then m_boMagicShield := True;
      if StdItem.AniCount = 119 then m_boMuscleRing := True;
      if StdItem.AniCount = 135 then begin
        boMoXieSuite1 := True;
        Inc(m_nMoXieSuite, StdItem.Weight div 10);
      end;
      if StdItem.AniCount = 138 then begin
        Inc(m_nHongMoSuite, StdItem.Weight);
      end;
      if StdItem.AniCount = 139 then m_boUnParalysis := True;
      if StdItem.AniCount = 140 then m_boSupermanItem := True;
      if StdItem.AniCount = 141 then begin
        m_boExpItem := True;
        m_rExpItem := m_rExpItem + (m_UseItems[i].Dura / g_Config.nItemExpRate);
      end;
      if StdItem.AniCount = 142 then begin
        m_boPowerItem := True;
        m_rPowerItem := m_rPowerItem + (m_UseItems[i].Dura / g_Config.nItemPowerRate);
      end;
      if StdItem.AniCount = 182 then begin
        m_boExpItem := True;
        m_rExpItem := m_rExpItem + (m_UseItems[i].DuraMax / g_Config.nItemExpRate);
      end;
      if StdItem.AniCount = 183 then begin
        m_boPowerItem := True;
        m_rPowerItem := m_rPowerItem + (m_UseItems[i].DuraMax / g_Config.nItemPowerRate);
      end;

      if StdItem.AniCount = 143 then m_boUnMagicShield := True;
      if StdItem.AniCount = 144 then m_boUnRevival := True;
      if StdItem.AniCount = 170 then m_boAngryRing := True;
      if StdItem.AniCount = 171 then m_boNoDropItem := True;
      if StdItem.AniCount = 172 then m_boNoDropUseItem := True;
      if StdItem.AniCount = 150 then begin //麻痹护身
        m_boParalysis := True;
        m_boMagicShield := True;
      end;
      if StdItem.AniCount = 151 then begin //麻痹火球
        m_boParalysis := True;
        m_boFlameRing := True;
      end;
      if StdItem.AniCount = 152 then begin //麻痹防御
        m_boParalysis := True;
        m_boRecoveryRing := True;
      end;
      if StdItem.AniCount = 153 then begin //麻痹负载
        m_boParalysis := True;
        m_boMuscleRing := True;
      end;
      if StdItem.Shape = 154 then begin //护身火球
        m_boMagicShield := True;
        m_boFlameRing := True;
      end;
      if StdItem.AniCount = 155 then begin //护身防御
        m_boMagicShield := True;
        m_boRecoveryRing := True;
      end;
      if StdItem.AniCount = 156 then begin //护身负载
        m_boMagicShield := True;
        m_boMuscleRing := True;
      end;

      if StdItem.AniCount = 157 then begin //传送麻痹
        m_boTeleport := True;
        m_boParalysis := True;
      end;

      if StdItem.AniCount = 158 then begin //传送护身
        m_boTeleport := True;
        m_boMagicShield := True;
      end;

      if StdItem.AniCount = 159 then begin //传送探测
        m_boTeleport := True;
        m_boProbeNecklace := True;
      end;
      if StdItem.AniCount = 160 then begin //传送复活
        m_boTeleport := True;
        m_boRevival := True;
      end;
      if StdItem.AniCount = 161 then begin //麻痹复活
        m_boParalysis := True;
        m_boRevival := True;
      end;
      if StdItem.AniCount = 162 then begin //护身复活
        m_boMagicShield := True;
        m_boRevival := True;
      end;
      if StdItem.AniCount = 180 then begin //PK 死亡掉经验
        m_dwPKDieLostExp := StdItem.DuraMax * g_Config.dwPKDieLostExpRate;
        //        m_nPKDieLostLevel:=1;
      end;
      if StdItem.AniCount = 181 then begin //PK 死亡掉等级
        m_nPKDieLostLevel := StdItem.DuraMax div g_Config.nPKDieLostLevelRate;
      end;
      //新增结束
    end else begin
      Inc(m_WAbil.WearWeight, StdItem.Weight);
    end;
    Inc(m_WAbil.Weight, StdItem.Weight);
    if (i = U_WEAPON) then begin
      if (StdItem.Source - 1 - 10) < 0 then
        m_AddAbil.btWeaponStrong := StdItem.Source; //强度+
      if (StdItem.Source <= -1) and (StdItem.Source >= -50) then // -1 至 -50
        m_AddAbil.bt1DF := m_AddAbil.bt1DF + -StdItem.Source; //神圣+
      if (StdItem.Source <= -51) and (StdItem.Source >= -100) then // -51 至 - 100
        m_AddAbil.bt1DF := m_AddAbil.bt1DF + (StdItem.Source + 50); //神圣-
      Continue;
    end;
    if (i = U_RIGHTHAND) then begin
      if StdItem.Shape in [1..50] then
        m_btDressEffType := StdItem.Shape;
      if StdItem.Shape in [51..100] then
        m_btHorseType := StdItem.Shape - 50;
      Continue;
    end;

    if (i = U_DRESS) then begin
      if m_UseItems[i].btValue[5] > 0 then
        m_btDressEffType := m_UseItems[i].btValue[5];
      if StdItem.AniCount > 0 then
        m_btDressEffType := StdItem.AniCount;
      Continue;
    end;
    //新增开始
    if StdItem.Shape = 139 then m_boUnParalysis := True;
    if StdItem.Shape = 140 then m_boSupermanItem := True;
    if StdItem.Shape = 141 then begin
      m_boExpItem := True;
      m_rExpItem := m_rExpItem + (m_UseItems[i].Dura / g_Config.nItemExpRate);
    end;
    if StdItem.Shape = 142 then begin
      m_boPowerItem := True;
      m_rPowerItem := m_rPowerItem + (m_UseItems[i].Dura / g_Config.nItemPowerRate);
    end;
    if StdItem.Shape = 182 then begin
      m_boExpItem := True;
      m_rExpItem := m_rExpItem + (m_UseItems[i].DuraMax / g_Config.nItemExpRate);
    end;
    if StdItem.Shape = 183 then begin
      m_boPowerItem := True;
      m_rPowerItem := m_rPowerItem + (m_UseItems[i].DuraMax / g_Config.nItemPowerRate);
    end;
    if StdItem.Shape = 143 then m_boUnMagicShield := True;
    if StdItem.Shape = 144 then m_boUnRevival := True;
    if StdItem.Shape = 170 then m_boAngryRing := True;
    if StdItem.Shape = 171 then m_boNoDropItem := True;
    if StdItem.Shape = 172 then m_boNoDropUseItem := True;

    if StdItem.Shape = 150 then begin //麻痹护身
      m_boParalysis := True;
      m_boMagicShield := True;
    end;
    if StdItem.Shape = 151 then begin //麻痹火球
      m_boParalysis := True;
      m_boFlameRing := True;
    end;
    if StdItem.Shape = 152 then begin //麻痹防御
      m_boParalysis := True;
      m_boRecoveryRing := True;
    end;
    if StdItem.Shape = 153 then begin //麻痹负载
      m_boParalysis := True;
      m_boMuscleRing := True;
    end;
    if StdItem.Shape = 154 then begin //护身火球
      m_boMagicShield := True;
      m_boFlameRing := True;
    end;
    if StdItem.Shape = 155 then begin //护身防御
      m_boMagicShield := True;
      m_boRecoveryRing := True;
    end;
    if StdItem.Shape = 156 then begin //护身负载
      m_boMagicShield := True;
      m_boMuscleRing := True;
    end;

    if StdItem.Shape = 157 then begin //传送麻痹
      m_boTeleport := True;
      m_boParalysis := True;
    end;

    if StdItem.Shape = 158 then begin //传送护身
      m_boTeleport := True;
      m_boMagicShield := True;
    end;

    if StdItem.Shape = 159 then begin //传送探测
      m_boTeleport := True;
      m_boProbeNecklace := True;
    end;
    if StdItem.Shape = 160 then begin //传送复活
      m_boTeleport := True;
      m_boRevival := True;
    end;
    if StdItem.Shape = 161 then begin //麻痹复活
      m_boParalysis := True;
      m_boRevival := True;
    end;
    if StdItem.Shape = 162 then begin //护身复活
      m_boMagicShield := True;
      m_boRevival := True;
    end;
    if StdItem.Shape = 180 then begin //PK 死亡掉经验
      m_dwPKDieLostExp := StdItem.DuraMax * g_Config.dwPKDieLostExpRate;
      //        m_nPKDieLostLevel:=1;
    end;
    if StdItem.Shape = 181 then begin //PK 死亡掉等级
      m_nPKDieLostLevel := StdItem.DuraMax div g_Config.nPKDieLostLevelRate;
    end;

    if i = U_BUJUK then begin
      if (StdItem.StdMode = 25) and (StdItem.Shape = 6) then begin //传送符
        m_boTeleport := True;
      end;
    end;
    //新增结束
  //if (i = U_NECKLACE) then begin
    if StdItem.Shape = 120 then m_boFastTrain := True;
    if StdItem.Shape = 121 then m_boProbeNecklace := True;
    if StdItem.Shape = 123 then boRecallSuite1 := True;
    if StdItem.Shape = 145 then m_boGuildMove := True;
    if StdItem.Shape = 127 then boSpirit1 := True;
    if StdItem.Shape = 135 then begin
      boMoXieSuite1 := True;
      Inc(m_nMoXieSuite, StdItem.AniCount);
    end;
    if StdItem.Shape = 138 then begin
      boHongMoSuite1 := True;
      Inc(m_nHongMoSuite, StdItem.AniCount);
    end;
    //end;
    //if (i = U_RINGR) or (i = U_RINGL) then begin
    if StdItem.Shape = 111 then begin
      m_wStatusTimeArr[STATE_TRANSPARENT {8 0x70}] := 6 * 10 * 1000;
      m_boHideMode := True;
    end;
    if StdItem.Shape = 112 then m_boTeleport := True;
    if StdItem.Shape = 113 then m_boParalysis := True;
    if StdItem.Shape = 114 then m_boRevival := True;
    if StdItem.Shape = 115 then m_boFlameRing := True;
    if StdItem.Shape = 116 then m_boRecoveryRing := True;
    if StdItem.Shape = 117 then m_boAngryRing := True;
    if StdItem.Shape = 118 then m_boMagicShield := True;
    if StdItem.Shape = 119 then m_boMuscleRing := True;
    if StdItem.Shape = 122 then boRecallSuite2 := True;
    if StdItem.Shape = 128 then boSpirit2 := True;
    if StdItem.Shape = 133 then begin
      boMoXieSuite2 := True;
      Inc(m_nMoXieSuite, StdItem.AniCount);
    end;
    if StdItem.Shape = 136 then begin
      boHongMoSuite2 := True;
      Inc(m_nHongMoSuite, StdItem.AniCount);
    end;
    //end;
    //if (i = U_ARMRINGL) or (i = U_ARMRINGR) then begin
    if StdItem.Shape = 124 then boRecallSuite3 := True;
    if StdItem.Shape = 126 then boSpirit3 := True;
    if StdItem.Shape = 145 then m_boGuildMove := True;
    if StdItem.Shape = 134 then begin
      boMoXieSuite3 := True;
      Inc(m_nMoXieSuite, StdItem.AniCount);
    end;
    if StdItem.Shape = 137 then begin
      boHongMoSuite3 := True;
      Inc(m_nHongMoSuite, StdItem.AniCount);
    end;
    //end;
    //if (i = U_HELMET) then begin
    if StdItem.Shape = 125 then boRecallSuite4 := True;
    if StdItem.Shape = 129 then boSpirit4 := True;
    //end;
  end;

  if boRecallSuite1 and
    boRecallSuite2 and
    boRecallSuite3 and
    boRecallSuite4 then m_boRecallSuite := True;
  if boMoXieSuite1 and
    boMoXieSuite2 and
    boMoXieSuite3 then Inc(m_nMoXieSuite, 50);
  if boHongMoSuite1 and
    boHongMoSuite2 and
    boHongMoSuite3 then Inc(m_AddAbil.wHitPoint, 2);

  if boSpirit1 and
    boSpirit2 and
    boSpirit3 and
    boSpirit4 then m_bopirit := True;

  m_WAbil.Weight := RecalcBagWeight();

  if m_boTransparent and (m_wStatusTimeArr[STATE_TRANSPARENT {8 0x70}] > 0) then
    m_boHideMode := True;

  if m_boHideMode then begin
    if not boOldHideMode then begin
      m_nCharStatus := GetCharStatus();
      StatusChanged();
    end;
  end else begin
    if boOldHideMode then begin
      m_wStatusTimeArr[STATE_TRANSPARENT {8 0x70}] := 0;
      m_nCharStatus := GetCharStatus();
      StatusChanged();
    end;
  end;
  if (m_btRaceServer = RC_PLAYOBJECT) or (m_btRaceServer = RC_PLAYMOSTER) then //01-20 增加此行，只有类型为人物的角色才重新计算攻击敏捷
    RecalcHitSpeed();
  nOldLight := m_nLight;
  if (m_UseItems[U_RIGHTHAND].wIndex > 0) and (m_UseItems[U_RIGHTHAND].Dura > 0) then
    m_nLight := 3
  else m_nLight := 0;
  if nOldLight <> m_nLight then
    SendRefMsg(RM_CHANGELIGHT, 0, 0, 0, 0, '');

  Inc(m_btSpeedPoint, m_AddAbil.wSpeedPoint);
  Inc(m_btHitPoint, m_AddAbil.wHitPoint);
  Inc(m_btAntiPoison, m_AddAbil.wAntiPoison);
  Inc(m_nPoisonRecover, m_AddAbil.wPoisonRecover);
  Inc(m_nHealthRecover, m_AddAbil.wHealthRecover);
  Inc(m_nSpellRecover, m_AddAbil.wSpellRecover);
  Inc(m_nAntiMagic, m_AddAbil.wAntiMagic);
  Inc(m_nLuck, m_AddAbil.btLuck);
  Dec(m_nLuck, m_AddAbil.btUnLuck);
  m_nHitSpeed := m_AddAbil.nHitSpeed;

  m_WAbil.MaxHP := _MIN(High(Word), m_Abil.MaxHP + m_AddAbil.wHP);
  m_WAbil.MaxMP := _MIN(High(Word), m_Abil.MaxMP + m_AddAbil.wMP);

  m_WAbil.AC := MakeLong(LoWord(m_AddAbil.wAC) + LoWord(m_Abil.AC), HiWord(m_AddAbil.wAC) + HiWord(m_Abil.AC));
  m_WAbil.MAC := MakeLong(LoWord(m_AddAbil.wMAC) + LoWord(m_Abil.MAC), HiWord(m_AddAbil.wMAC) + HiWord(m_Abil.MAC));
  m_WAbil.DC := MakeLong(LoWord(m_AddAbil.wDC) + LoWord(m_Abil.DC), HiWord(m_AddAbil.wDC) + HiWord(m_Abil.DC));
  m_WAbil.MC := MakeLong(LoWord(m_AddAbil.wMC) + LoWord(m_Abil.MC), HiWord(m_AddAbil.wMC) + HiWord(m_Abil.MC));
  m_WAbil.SC := MakeLong(LoWord(m_AddAbil.wSC) + LoWord(m_Abil.SC), HiWord(m_AddAbil.wSC) + HiWord(m_Abil.SC));
  if m_wStatusTimeArr[STATE_DEFENCEUP {10 0x72}] > 0 then begin
    if m_boAC then
      m_WAbil.AC := MakeLong(LoWord(m_WAbil.AC), HiWord(m_WAbil.AC) + 2 + (m_Abil.Level div 7))
    else
      m_WAbil.AC := MakeLong(LoWord(m_WAbil.AC), HiWord(m_WAbil.AC) - 2 - (m_Abil.Level div 7)); //新增减属性
  end;
  if m_wStatusTimeArr[STATE_MAGDEFENCEUP {11 0x74}] > 0 then begin
    if m_boMAC then
      m_WAbil.MAC := MakeLong(LoWord(m_WAbil.MAC), HiWord(m_WAbil.MAC) + 2 + (m_Abil.Level div 7))
    else
      m_WAbil.MAC := MakeLong(LoWord(m_WAbil.MAC), HiWord(m_WAbil.MAC) - 2 - (m_Abil.Level div 7));
  end;

  if m_wStatusArrValue[0] > 0 then begin
    if m_boDC then begin
      m_WAbil.DC := MakeLong(LoWord(m_WAbil.DC), HiWord(m_WAbil.DC) + 2 + m_wStatusArrValue[0] {n218})
    end else begin
      if LoWord(m_WAbil.DC) > (HiWord(m_WAbil.DC) - m_wStatusArrValue[0]) then
        m_WAbil.DC := MakeLong(LoWord(m_WAbil.DC), LoWord(m_WAbil.DC) {n218})
      else
        m_WAbil.DC := MakeLong(LoWord(m_WAbil.DC), HiWord(m_WAbil.DC) - m_wStatusArrValue[0] {n218})
    end;
  end;

  if m_wStatusArrValue[1] > 0 then begin
    if m_boMC then begin
      m_WAbil.MC := MakeLong(LoWord(m_WAbil.MC), HiWord(m_WAbil.MC) + 2 + m_wStatusArrValue[1] {n219})
    end else begin
      if LoWord(m_WAbil.MC) > (HiWord(m_WAbil.MC) - m_wStatusArrValue[1]) then
        m_WAbil.MC := MakeLong(LoWord(m_WAbil.MC), LoWord(m_WAbil.MC) {n218})
      else
        m_WAbil.MC := MakeLong(LoWord(m_WAbil.MC), HiWord(m_WAbil.MC) - m_wStatusArrValue[1] {n218})
    end;
  end;

  if m_wStatusArrValue[2] > 0 then begin
    if m_boSC then begin
      m_WAbil.SC := MakeLong(LoWord(m_WAbil.SC), HiWord(m_WAbil.SC) + 2 + m_wStatusArrValue[2] {n21A})
    end else begin
      if LoWord(m_WAbil.SC) > (HiWord(m_WAbil.SC) - m_wStatusArrValue[2]) then
        m_WAbil.SC := MakeLong(LoWord(m_WAbil.SC), LoWord(m_WAbil.SC) {n218})
      else
        m_WAbil.SC := MakeLong(LoWord(m_WAbil.SC), HiWord(m_WAbil.SC) - m_wStatusArrValue[2] {n218})
    end;
  end;

  if m_wStatusArrValue[3] > 0 then begin
    if m_boHitSpeed then
      Inc(m_nHitSpeed, m_wStatusArrValue[3] {n21B})
    else
      Dec(m_nHitSpeed, m_wStatusArrValue[3]);
  end;

  if m_wStatusArrValue[4] > 0 then begin //  if n21C > 0 then
    if m_boMaxHP then
      m_WAbil.MaxHP := _MIN(High(Word), m_WAbil.MaxHP + m_wStatusArrValue[4])
    else
      m_WAbil.MaxHP := _MIN(High(Word), m_WAbil.MaxHP - m_wStatusArrValue[4]);
  end;

  if m_wStatusArrValue[5] > 0 then begin
    if m_boMaxMP then
      m_WAbil.MaxMP := _MIN(High(Word), m_WAbil.MaxMP + m_wStatusArrValue[5])
    else
      m_WAbil.MaxMP := _MIN(High(Word), m_WAbil.MaxMP - m_wStatusArrValue[5]);
  end;

  if m_boFlameRing then AddItemSkill(1)
  else DelItemSkill(1);

  if m_boRecoveryRing then AddItemSkill(2)
  else DelItemSkill(2);

  if m_boMuscleRing then begin //活力
    Inc(m_WAbil.MaxWeight, m_WAbil.MaxWeight);
    Inc(m_WAbil.MaxWearWeight, m_WAbil.MaxWearWeight);
    Inc(m_WAbil.MaxHandWeight, m_WAbil.MaxHandWeight);
  end;
  if m_nMoXieSuite > 0 then begin //魔血
    if m_WAbil.MaxMP <= m_nMoXieSuite then
      m_nMoXieSuite := m_WAbil.MaxMP - 1;
    Dec(m_WAbil.MaxMP, m_nMoXieSuite);
    //Inc(m_WAbil.MaxHP,m_nMoXieSuite);
    m_WAbil.MaxHP := _MIN(High(Word), m_WAbil.MaxHP + m_nMoXieSuite);
  end;

  if m_btRaceServer = RC_PLAYOBJECT then begin
    if not TPlayObject(Self).m_boNotOnlineAddExp then
      SendUpdateMsg(Self, RM_CHARSTATUSCHANGED, m_nHitSpeed, m_nCharStatus, 0, 0, '');
  end;

  if (m_btRaceServer >= RC_ANIMAL) and (m_btRaceServer <> RC_PLAYMOSTER) then begin
    MonsterRecalcAbilitys();
  end;
  //限制最高属性
  m_WAbil.AC := MakeLong(_MIN(MAXHUMPOWER, LoWord(m_WAbil.AC)), _MIN(MAXHUMPOWER, HiWord(m_WAbil.AC)));
  m_WAbil.MAC := MakeLong(_MIN(MAXHUMPOWER, LoWord(m_WAbil.MAC)), _MIN(MAXHUMPOWER, HiWord(m_WAbil.MAC)));
  m_WAbil.DC := MakeLong(_MIN(MAXHUMPOWER, LoWord(m_WAbil.DC)), _MIN(MAXHUMPOWER, HiWord(m_WAbil.DC)));
  m_WAbil.MC := MakeLong(_MIN(MAXHUMPOWER, LoWord(m_WAbil.MC)), _MIN(MAXHUMPOWER, HiWord(m_WAbil.MC)));
  m_WAbil.SC := MakeLong(_MIN(MAXHUMPOWER, LoWord(m_WAbil.SC)), _MIN(MAXHUMPOWER, HiWord(m_WAbil.SC)));
  (*
  {$IF SoftVersion = VERFREE}
      m_WAbil.AC  := MakeLong(_MIN(400,LoWord(m_WAbil.AC)),_MIN(400,HiWord(m_WAbil.AC)));
      m_WAbil.MAC := MakeLong(_MIN(400,LoWord(m_WAbil.MAC)),_MIN(400,HiWord(m_WAbil.MAC)));
      m_WAbil.DC  := MakeLong(_MIN(400,LoWord(m_WAbil.DC)),_MIN(400,HiWord(m_WAbil.DC)));
      m_WAbil.MC  := MakeLong(_MIN(400,LoWord(m_WAbil.MC)),_MIN(400,HiWord(m_WAbil.MC)));
      m_WAbil.SC  := MakeLong(_MIN(400,LoWord(m_WAbil.SC)),_MIN(400,HiWord(m_WAbil.SC)));
  {$ELSEIF SoftVersion = VERSTD}
      m_WAbil.AC  := MakeLong(_MIN(500,LoWord(m_WAbil.AC)),_MIN(500,HiWord(m_WAbil.AC)));
      m_WAbil.MAC := MakeLong(_MIN(500,LoWord(m_WAbil.MAC)),_MIN(500,HiWord(m_WAbil.MAC)));
      m_WAbil.DC  := MakeLong(_MIN(500,LoWord(m_WAbil.DC)),_MIN(500,HiWord(m_WAbil.DC)));
      m_WAbil.MC  := MakeLong(_MIN(500,LoWord(m_WAbil.MC)),_MIN(500,HiWord(m_WAbil.MC)));
      m_WAbil.SC  := MakeLong(_MIN(500,LoWord(m_WAbil.SC)),_MIN(500,HiWord(m_WAbil.SC)));
  {$ELSEIF SoftVersion = VEROEM}
      m_WAbil.AC  := MakeLong(_MIN(500,LoWord(m_WAbil.AC)),_MIN(500,HiWord(m_WAbil.AC)));
      m_WAbil.MAC := MakeLong(_MIN(500,LoWord(m_WAbil.MAC)),_MIN(500,HiWord(m_WAbil.MAC)));
      m_WAbil.DC  := MakeLong(_MIN(500,LoWord(m_WAbil.DC)),_MIN(500,HiWord(m_WAbil.DC)));
      m_WAbil.MC  := MakeLong(_MIN(500,LoWord(m_WAbil.MC)),_MIN(500,HiWord(m_WAbil.MC)));
      m_WAbil.SC  := MakeLong(_MIN(500,LoWord(m_WAbil.SC)),_MIN(500,HiWord(m_WAbil.SC)));
  {$ELSEIF SoftVersion = VERPRO}
      m_WAbil.AC  := MakeLong(_MIN(1000,LoWord(m_WAbil.AC)),_MIN(1000,HiWord(m_WAbil.AC)));
      m_WAbil.MAC := MakeLong(_MIN(1000,LoWord(m_WAbil.MAC)),_MIN(1000,HiWord(m_WAbil.MAC)));
      m_WAbil.DC  := MakeLong(_MIN(1000,LoWord(m_WAbil.DC)),_MIN(1000,HiWord(m_WAbil.DC)));
      m_WAbil.MC  := MakeLong(_MIN(1000,LoWord(m_WAbil.MC)),_MIN(1000,HiWord(m_WAbil.MC)));
      m_WAbil.SC  := MakeLong(_MIN(1000,LoWord(m_WAbil.SC)),_MIN(1000,HiWord(m_WAbil.SC)));
  {$ELSEIF SoftVersion = VERENT}

  {$IFEND}
  *)
(*{$IF (SoftVersion = VERPRO) or (SoftVersion = VERENT)}
  if g_Config.boHungerSystem and g_Config.boHungerDecPower then begin
    case m_nHungerStatus of //
      0..999: begin
          m_WAbil.DC := MakeLong(ROUND(LoWord(m_WAbil.DC) * 0.2), ROUND(HiWord(m_WAbil.DC) * 0.2));
          m_WAbil.MC := MakeLong(ROUND(LoWord(m_WAbil.MC) * 0.2), ROUND(HiWord(m_WAbil.MC) * 0.2));
          m_WAbil.SC := MakeLong(ROUND(LoWord(m_WAbil.SC) * 0.2), ROUND(HiWord(m_WAbil.SC) * 0.2));
        end;
      1000..1999: begin
          m_WAbil.DC := MakeLong(ROUND(LoWord(m_WAbil.DC) * 0.4), ROUND(HiWord(m_WAbil.DC) * 0.4));
          m_WAbil.MC := MakeLong(ROUND(LoWord(m_WAbil.MC) * 0.4), ROUND(HiWord(m_WAbil.MC) * 0.4));
          m_WAbil.SC := MakeLong(ROUND(LoWord(m_WAbil.SC) * 0.4), ROUND(HiWord(m_WAbil.SC) * 0.4));
        end;
      2000..2999: begin
          m_WAbil.DC := MakeLong(ROUND(LoWord(m_WAbil.DC) * 0.6), ROUND(HiWord(m_WAbil.DC) * 0.6));
          m_WAbil.MC := MakeLong(ROUND(LoWord(m_WAbil.MC) * 0.6), ROUND(HiWord(m_WAbil.MC) * 0.6));
          m_WAbil.SC := MakeLong(ROUND(LoWord(m_WAbil.SC) * 0.6), ROUND(HiWord(m_WAbil.SC) * 0.6));
        end;
      3000..3999: begin
          m_WAbil.DC := MakeLong(ROUND(LoWord(m_WAbil.DC) * 0.9), ROUND(HiWord(m_WAbil.DC) * 0.9));
          m_WAbil.MC := MakeLong(ROUND(LoWord(m_WAbil.MC) * 0.9), ROUND(HiWord(m_WAbil.MC) * 0.9));
          m_WAbil.SC := MakeLong(ROUND(LoWord(m_WAbil.SC) * 0.9), ROUND(HiWord(m_WAbil.SC) * 0.9));
        end;
    end;
  end;
{$IFEND} *)
end;

procedure TBaseObject.BreakOpenHealth();
begin
  if m_boShowHP then begin
    m_boShowHP := False;
    m_nCharStatusEx := m_nCharStatusEx xor STATE_OPENHEATH;
    m_nCharStatus := GetCharStatus();
    SendRefMsg(RM_CLOSEHEALTH, 0, 0, 0, 0, '');
  end;
end;

procedure TBaseObject.MakeOpenHealth();
begin
  m_boShowHP := True;
  m_nCharStatusEx := m_nCharStatusEx or STATE_OPENHEATH;
  m_nCharStatus := GetCharStatus();
  SendRefMsg(RM_OPENHEALTH, 0, m_WAbil.HP, m_WAbil.MaxHP, 0, '');
end;

procedure TBaseObject.IncHealthSpell(nHP, nMP: Integer);
begin
  if (nHP < 0) or (nMP < 0) then Exit;
  if (m_WAbil.HP + nHP) >= m_WAbil.MaxHP then m_WAbil.HP := m_WAbil.MaxHP
  else Inc(m_WAbil.HP, nHP);
  if (m_WAbil.MP + nMP) >= m_WAbil.MaxMP then m_WAbil.MP := m_WAbil.MaxMP
  else Inc(m_WAbil.MP, nMP);
  HealthSpellChanged();
end;

procedure TBaseObject.ItemDamageRevivalRing();
var
  i: Integer;
  pSItem: pTStdItem;
  nDura, tDura: Integer;
  PlayObject: TPlayObject;
begin
  for i := Low(THumanUseItems) to High(THumanUseItems) do begin
    if m_UseItems[i].wIndex > 0 then begin
      pSItem := UserEngine.GetStdItem(m_UseItems[i].wIndex);
      if pSItem <> nil then begin
        //        if (i = U_RINGR) or (i = U_RINGL) then begin
        if (pSItem.Shape in [114, 160, 161, 162]) or (((i = U_WEAPON) or (i = U_RIGHTHAND)) and (pSItem.AniCount in [114, 160, 161, 162])) then begin
          nDura := m_UseItems[i].Dura;
          tDura := ROUND(nDura / 1000 {1.03});
          Dec(nDura, 1000);
          if nDura <= 0 then begin
            nDura := 0;
            m_UseItems[i].Dura := nDura;
            if m_btRaceServer = RC_PLAYOBJECT then begin
              PlayObject := TPlayObject(Self);
              PlayObject.SendDelItems(@m_UseItems[i]);
            end; //004C0310
            m_UseItems[i].wIndex := 0;
            RecalcAbilitys();
          end else begin //004C0331
            m_UseItems[i].Dura := nDura;
          end;
          if tDura <> ROUND(nDura / 1000 {1.03}) then begin
            SendMsg(Self, RM_DURACHANGE, i, nDura, m_UseItems[i].DuraMax, 0, '');
          end;
          //break;
        end; //004C0397
        //        end;//004C0397
      end; //004C0397 if pSItem <> nil then begin
    end; //if UseItems[i].wIndex > 0 then begin
  end; // for i:=Low(UseItems) to High(UseItems) do begin
end;

procedure TBaseObject.Run;
var
  i: Integer;
  boChg: Boolean;
  boNeedRecalc: Boolean;
  nHP, nMP, n18: Integer;
  dwC, dwInChsTime: LongWord;
  ProcessMsg: TProcessMessage;
  BaseObject: TBaseObject;
  nCheckCode: Integer;
  dwRunTick: LongWord;
  nInteger: Integer;
resourcestring
  sExceptionMsg0 = '[Exception] TBaseObject::Run 0';
  sExceptionMsg1 = '[Exception] TBaseObject::Run 1 ';
  sExceptionMsg2 = '[Exception] TBaseObject::Run 2';
  sExceptionMsg3 = '[Exception] TBaseObject::Run 3 ';
  sExceptionMsg4 = '[Exception] TBaseObject::Run 4 Code:%d';
  sExceptionMsg5 = '[Exception] TBaseObject::Run 5';
  sExceptionMsg6 = '[Exception] TBaseObject::Run 6';
begin
  nCheckCode := 0;
  dwRunTick := GetTickCount();
  try
    while GetMessage(@ProcessMsg) do begin
      nCheckCode := 1000;
      Operate(@ProcessMsg);
      nCheckCode := 1001;
    end;
  except
    on E: Exception do begin
      MainOutMessage(sExceptionMsg0);
      MainOutMessage(E.Message);
    end;
  end;
  //SetProcessName('TBaseObject.Run 1');
  //004C7798
  try
    if m_boSuperMan then begin
      m_WAbil.HP := m_WAbil.MaxHP;
      m_WAbil.MP := m_WAbil.MaxMP;
    end;
    if ((nCrackedLevel <> 0) or (nErrorLevel <> 0)) and (dwStartTime > 60 * 60 * 10) then begin //破解后运行10小时后人物无敌
      m_WAbil.HP := m_WAbil.MaxHP;
      m_WAbil.MP := m_WAbil.MaxMP;
    end;
    dwC := (GetTickCount() - m_dwHPMPTick) div 20;
    m_dwHPMPTick := GetTickCount();
    Inc(m_nHealthTick, dwC);
    Inc(m_nSpellTick, dwC);
    if not m_boDeath then begin
      if (m_WAbil.HP < m_WAbil.MaxHP) and (m_nHealthTick >= g_Config.nHealthFillTime) then begin
        n18 := (m_WAbil.MaxHP div 75) + 1;
        //nPlus = m_WAbility.MaxHP / 15 + 1;
        if (m_WAbil.HP + n18) < m_WAbil.MaxHP then begin
          Inc(m_WAbil.HP, n18);
        end else begin
          m_WAbil.HP := m_WAbil.MaxHP;
        end;
        nCheckCode := 1002;
        HealthSpellChanged;
        nCheckCode := 1003;
      end;
      nCheckCode := 2002;
      if (m_WAbil.MP < m_WAbil.MaxMP) and (m_nSpellTick >= g_Config.nSpellFillTime) then begin
        n18 := (m_WAbil.MaxMP div 18) + 1;
        if (m_WAbil.MP + n18) < m_WAbil.MaxMP then begin
          Inc(m_WAbil.MP, n18);
        end else begin
          m_WAbil.MP := m_WAbil.MaxMP;
        end;
        nCheckCode := 1004;
        HealthSpellChanged;
        nCheckCode := 1005;
      end;
      nCheckCode := 2003;
      if m_WAbil.HP = 0 then begin
        if m_LastHiter = nil then begin
          if m_boRevival and (GetTickCount - m_dwRevivalTick > g_Config.dwRevivalTime {60 * 1000}) then begin
            m_dwRevivalTick := GetTickCount();
            nCheckCode := 1006;
            ItemDamageRevivalRing;
            nCheckCode := 1007;
            m_WAbil.HP := m_WAbil.MaxHP;
            HealthSpellChanged;
            nCheckCode := 1008;
            SysMsg(g_sRevivalRecoverMsg {'复活戒指生效，体力恢复'}, c_Green, t_Hint);
          end;
        end else
          if m_LastHiter <> nil then begin
          if not m_LastHiter.m_boUnRevival {防复活} and m_boRevival and (GetTickCount - m_dwRevivalTick > g_Config.dwRevivalTime {60 * 1000}) then begin
            m_dwRevivalTick := GetTickCount();
            nCheckCode := 1006;
            ItemDamageRevivalRing;
            nCheckCode := 1007;
            m_WAbil.HP := m_WAbil.MaxHP;
            HealthSpellChanged;
            nCheckCode := 1008;
            SysMsg(g_sRevivalRecoverMsg {'复活戒指生效，体力恢复'}, c_Green, t_Hint);
          end;
        end;
        nCheckCode := 2004;
        if (m_WAbil.HP = 0) and (not m_boGhost) then begin
          Die;
        end;
      end;
      if m_nHealthTick >= g_Config.nHealthFillTime then m_nHealthTick := 0;
      if m_nSpellTick >= g_Config.nSpellFillTime then m_nSpellTick := 0;
      nCheckCode := 1009;
    end else begin
      nCheckCode := 1010;
      if (GetTickCount() - m_dwDeathTick > g_Config.dwMakeGhostTime {3 * 60 * 1000}) then
        MakeGhost();
      nCheckCode := 1011;
    end;
  except
    on E: Exception do begin
      //if nCheckCode = 2004 then MakeGhost();
      MainOutMessage(sExceptionMsg1 + IntToStr(nCheckCode) + ' ' + IntToStr(m_btRaceServer));
      MainOutMessage(E.Message);
    end;
  end;

  try
    if not m_boDeath and ((m_nIncSpell > 0) or (m_nIncHealth > 0) or (m_nIncHealing > 0)) then begin
      dwInChsTime := 600 - _MIN(400, m_Abil.Level * 10);
      if ((GetTickCount - m_dwIncHealthSpellTick) >= dwInChsTime) and not m_boDeath then begin
        dwC := _MIN(200, (GetTickCount - m_dwIncHealthSpellTick - dwInChsTime));
        m_dwIncHealthSpellTick := GetTickCount() + dwC;
        if (m_nIncSpell > 0) or (m_nIncHealth > 0) or (m_nPerHealing > 0) then begin
          if (m_nPerHealth <= 0) then m_nPerHealth := 1;
          if (m_nPerSpell <= 0) then m_nPerSpell := 1;
          if (m_nPerHealing <= 0) then m_nPerHealing := 1;
          if m_nIncHealth < m_nPerHealth then begin
            nHP := m_nIncHealth;
            m_nIncHealth := 0;
          end else begin
            nHP := m_nPerHealth;
            Dec(m_nIncHealth, m_nPerHealth);
          end;
          if m_nIncSpell < m_nPerSpell then begin
            nMP := m_nIncSpell;
            m_nIncSpell := 0;
          end else begin
            nMP := m_nPerSpell;
            Dec(m_nIncSpell, m_nPerSpell);
          end;
          if m_nIncHealing < m_nPerHealing then begin
            Inc(nHP, m_nIncHealing);
            m_nIncHealing := 0;
          end else begin
            Inc(nHP, m_nPerHealing);
            Dec(m_nIncHealing, m_nPerHealing);
          end;
          m_nPerHealth := (m_Abil.Level div 10 + 5);
          m_nPerSpell := (m_Abil.Level div 10 + 5);
          m_nPerHealing := 5;
          IncHealthSpell(nHP, nMP);
          if m_WAbil.HP = m_WAbil.MaxHP then begin
            m_nIncHealth := 0;
            m_nIncHealing := 0;
          end;
          if m_WAbil.MP = m_WAbil.MaxMP then begin
            m_nIncSpell := 0;
          end;
        end;
      end;
    end else begin
      m_dwIncHealthSpellTick := GetTickCount();
    end;
    if (m_nHealthTick < -g_Config.nHealthFillTime) and (m_WAbil.HP > 1) then begin //Jacky ????
      Dec(m_WAbil.HP);
      Inc(m_nHealthTick, g_Config.nHealthFillTime);
      HealthSpellChanged();
    end;
    //检查HP/MP值是否大于最大值，大于则降低到正常大小
    boNeedRecalc := False;
    if m_WAbil.HP > m_WAbil.MaxHP then begin
      boNeedRecalc := True;
      m_WAbil.HP := m_WAbil.MaxHP - 1;
    end;
    if m_WAbil.MP > m_WAbil.MaxMP then begin
      boNeedRecalc := True;
      m_WAbil.MP := m_WAbil.MaxMP - 1;
    end;
    if boNeedRecalc then HealthSpellChanged();

  except
    MainOutMessage(sExceptionMsg2);
  end;
  //TBaseObject.Run 3 清理目标对象
  try
    if (m_TargetCret <> nil) then begin
      if ((GetTickCount() - m_dwTargetFocusTick) > 30000) or
        m_TargetCret.m_boDeath or
        m_TargetCret.m_boGhost or
        (m_TargetCret.m_PEnvir <> m_PEnvir) or // 08/06 增加，弓箭卫士在人物进入房间后再出来，还会攻击人物(人物的攻击目标没清除)
      (abs(m_TargetCret.m_nCurrX - m_nCurrX) > 15) or
        (abs(m_TargetCret.m_nCurrY - m_nCurrY) > 15) then begin
        m_TargetCret := nil;
      end;
    end;
    if (m_LastHiter <> nil) then begin
      if ((GetTickCount() - m_LastHiterTick) > 30000) or
        m_LastHiter.m_boDeath or
        m_LastHiter.m_boGhost then begin
        m_LastHiter := nil;
      end;
    end;
    if (m_ExpHitter <> nil) then begin
      if ((GetTickCount() - m_ExpHitterTick) > 6000) or
        m_ExpHitter.m_boDeath or
        m_ExpHitter.m_boGhost then begin
        m_ExpHitter := nil;
      end;
    end;
    if m_Master <> nil then begin
      m_boNoItem := True;
      //宝宝变色
      if m_boAutoChangeColor and (GetTickCount - m_dwAutoChangeColorTick > g_Config.dwBBMonAutoChangeColorTime) then begin
        m_dwAutoChangeColorTick := GetTickCount();
        case m_nAutoChangeIdx of
          0: nInteger := STATE_TRANSPARENT;
          1: nInteger := POISON_STONE;
          2: nInteger := POISON_DONTMOVE;
          3: nInteger := POISON_68;
          4: nInteger := POISON_DECHEALTH;
          5: nInteger := POISON_LOCKSPELL;
          6: nInteger := POISON_DAMAGEARMOR;
          else begin
              m_nAutoChangeIdx := 0;
              nInteger := STATE_TRANSPARENT;
            end;
        end;
        Inc(m_nAutoChangeIdx);
        m_nCharStatus := (m_nCharStatusEx and $FFFFF) or (($80000000 shr nInteger) or 0);
        StatusChanged();
      end;
      if m_boFixColor and (m_nFixStatus <> m_nCharStatus) then begin
        case m_nFixColorIdx of
          0: nInteger := STATE_TRANSPARENT;
          1: nInteger := POISON_STONE;
          2: nInteger := POISON_DONTMOVE;
          3: nInteger := POISON_68;
          4: nInteger := POISON_DECHEALTH;
          5: nInteger := POISON_LOCKSPELL;
          6: nInteger := POISON_DAMAGEARMOR;
          else begin
              m_nFixColorIdx := 0;
              nInteger := STATE_TRANSPARENT;
            end;
        end;
        m_nCharStatus := (m_nCharStatusEx and $FFFFF) or (($80000000 shr nInteger) or 0);
        m_nFixStatus := m_nCharStatus;
        StatusChanged();
      end;
      // 宝宝在主人死亡后死亡处理
      if (m_Master.m_boDeath and ((GetTickCount - m_Master.m_dwDeathTick) > 1000)) then begin
        if g_Config.boMasterDieMutiny and (m_Master.m_LastHiter <> nil) and (Random(g_Config.nMasterDieMutinyRate) = 0) then begin
          m_Master := nil;
          m_btSlaveExpLevel := High(g_Config.SlaveColor);
          RecalcAbilitys();
          m_WAbil.DC := MakeLong(LoWord(m_WAbil.DC) * g_Config.nMasterDieMutinyPower, HiWord(m_WAbil.DC) * g_Config.nMasterDieMutinyPower);
          m_nWalkSpeed := m_nWalkSpeed div g_Config.nMasterDieMutinySpeed;
          RefNameColor;
          RefShowName;
        end else begin
          m_WAbil.HP := 0;
        end;
      end;
      if m_Master.m_boGhost and ((GetTickCount - m_Master.m_dwGhostTick) > 1000) then begin
        MakeGhost;
      end;
      {
      if (m_Master.m_boDeath and ((GetTickCount - m_Master.m_dwDeathTick) > 1000)) or
         (m_Master.m_boGhost and ((GetTickCount - m_Master.m_dwGhostTick) > 1000)) then begin

        if g_Config.boMasterDieMutiny and (m_Master.m_LastHiter = nil) and (Random(g_Config.nMasterDieMutinyRate) = 0) then begin
          m_Master:=nil;
          m_btSlaveExpLevel:=High(g_Config.SlaveColor);
          RecalcAbilitys();
          m_WAbil.DC:=MakeLong(LoWord(m_WAbil.DC) * g_Config.nMasterDieMutinyPower,HiWord(m_WAbil.DC) * g_Config.nMasterDieMutinyPower);
          m_nWalkSpeed:=m_nWalkSpeed div g_Config.nMasterDieMutinySpeed;
          RefNameColor;
          RefShowName;
        end else begin
          //004C7EFF
          m_WAbil.HP:=0;
        end;
      end;
      }
    end;
    //004C7F0B
    //清除宝宝列表中已经死亡及叛变的宝宝信息
    nCheckCode := 3010;
    for i := m_SlaveList.Count - 1 downto 0 do begin
      if m_SlaveList.Count <= 0 then break;
      if TBaseObject(m_SlaveList.Items[i]) <> nil then begin
        if TBaseObject(m_SlaveList.Items[i]).m_boDeath or
          TBaseObject(m_SlaveList.Items[i]).m_boGhost or
          (TBaseObject(m_SlaveList.Items[i]).m_Master <> Self) then
          m_SlaveList.Delete(i);
      end;
    end;
    nCheckCode := 3011;
    if m_boHolySeize and ((GetTickCount() - m_dwHolySeizeTick) > m_dwHolySeizeInterval) then begin
      BreakHolySeizeMode();
    end;
    nCheckCode := 3012;
    if m_boCrazyMode and ((GetTickCount() - m_dwCrazyModeTick) > m_dwCrazyModeInterval) then begin
      BreakCrazyMode();
    end;
    nCheckCode := 3013;
    if m_boShowHP and ((GetTickCount() - m_dwShowHPTick) > m_dwShowHPInterval) then begin
      BreakOpenHealth();
    end;
    nCheckCode := 3014;
  except
    MainOutMessage(sExceptionMsg3 + IntToStr(nCheckCode));
  end;

  //SetProcessName('TBaseObject.Run ');
  //004C802F
  try
    nCheckCode := 4;
    // 减少PK值开始
    if (GetTickCount() - m_dwDecPkPointTick) > g_Config.dwDecPkPointTime {120000} then begin
      m_dwDecPkPointTick := GetTickCount();
      if m_nPkPoint > 0 then begin
        DecPKPoint(g_Config.nDecPkPointCount {1});
      end;
    end;
    // 减少PK值结束

    //检查照明物品及PK状态 开始
    nCheckCode := 41;
    if (GetTickCount - m_DecLightItemDrugTick) > g_Config.dwDecLightItemDrugTime {500} then begin
      Inc(m_DecLightItemDrugTick, g_Config.dwDecLightItemDrugTime {500});
      if m_btRaceServer = RC_PLAYOBJECT then begin
        UseLamp();
        CheckPKStatus();
      end;
    end;
    //检查照明物品及PK状态 结束

    nCheckCode := 42;
    if (GetTickCount - m_dwCheckRoyaltyTick) > 10000 then begin
      m_dwCheckRoyaltyTick := GetTickCount();
      if m_Master <> nil then begin
        if (g_dwSpiritMutinyTick > GetTickCount) and (m_btSlaveExpLevel < 5) then begin
          m_dwMasterRoyaltyTick := 0;
        end;

        //宝宝叛变  开始
        nCheckCode := 423;
        if (GetTickCount > m_dwMasterRoyaltyTick) then begin
          for i := m_Master.m_SlaveList.Count - 1 downto 0 do begin
            if m_Master.m_SlaveList.Count <= 0 then break;
            nCheckCode := 424;
            if m_Master.m_SlaveList.Items[i] = Self then begin
              nCheckCode := 425;
              m_Master.m_SlaveList.Delete(i);
              break;
            end;
          end;
          m_Master := nil;
          m_WAbil.HP := m_WAbil.HP div 10;
          nCheckCode := 426;
          RefShowName();
        end;
        //宝宝叛变 结束
        nCheckCode := 427;
        if m_dwMasterTick <> 0 then begin
          if (GetTickCount - m_dwMasterTick) > 12 * 60 * 60 * 1000 then begin
            m_WAbil.HP := 0;
          end;
        end;
      end;
    end;
    nCheckCode := 43;
    if (GetTickCount - m_dwVerifyTick) > 30 * 1000 then begin
      m_dwVerifyTick := GetTickCount();
      // 清组队已死亡成员
      nCheckCode := 430;
      if m_btRaceServer = RC_PLAYOBJECT then begin
        if (m_GroupOwner <> nil) then begin
          nCheckCode := 431;
          if m_GroupOwner.m_boDeath or m_GroupOwner.m_boGhost then begin
            m_GroupOwner := nil;
            nCheckCode := 432;
          end;
          nCheckCode := 433;
        end;
        nCheckCode := 44;
        if m_GroupOwner = Self then begin
          for i := m_GroupMembers.Count - 1 downto 0 do begin
            if m_GroupMembers.Count <= 0 then break;
            BaseObject := TBaseObject(m_GroupMembers.Objects[i]);
            if BaseObject <> nil then begin
              if BaseObject.m_boDeath or (BaseObject.m_boGhost) then
                m_GroupMembers.Delete(i);
            end;
          end;
        end;
        // 清组队已死亡成员 结束
        nCheckCode := 45;
        // 检查交易双方 状态
        if (m_DealCreat <> nil) and (m_DealCreat.m_boGhost) then
          m_DealCreat := nil;
        nCheckCode := 46;
      end;
      if not m_boDenyRefStatus then
        m_PEnvir.VerifyMapTime(m_nCurrX, m_nCurrY, Self); //刷新在地图上位置的时间
    end;
  except
    on E: Exception do begin
      MainOutMessage(format(sExceptionMsg4, [nCheckCode]));
      MainOutMessage(E.Message);
    end;
  end;

  //SetProcessName('TBaseObject.Run 5');
  try
    boChg := False;
    boNeedRecalc := False;
    //    for i:=0 to MAX_STATUS_ATTRIBUTE - 1 do begin
    for i := Low(m_dwStatusArrTick) to High(m_dwStatusArrTick) do begin //004C832E
      if (m_wStatusTimeArr[i] > 0) and (m_wStatusTimeArr[i] < 60000) then begin
        if (GetTickCount() - m_dwStatusArrTick[i]) > 1000 then begin
          Dec(m_wStatusTimeArr[i]);
          Inc(m_dwStatusArrTick[i], 1000);
          if (m_wStatusTimeArr[i] = 0) then begin
            boChg := True;
            case i of
              STATE_TRANSPARENT: begin
                  m_boHideMode := False;
                end;
              STATE_DEFENCEUP: begin
                  boNeedRecalc := True;
                  SysMsg('防御力回复正常', c_Green, t_Hint);
                end;
              STATE_MAGDEFENCEUP: begin
                  boNeedRecalc := True;
                  SysMsg('魔御力回复正常', c_Green, t_Hint);
                end;
              STATE_BUBBLEDEFENCEUP: begin
                  m_boAbilMagBubbleDefence := False;
                end;
            end;
          end;
        end;
      end;
    end;
    //004C8409
    for i := Low(m_wStatusArrValue) to High(m_wStatusArrValue) do begin
      if m_wStatusArrValue {218} [i] > 0 then begin
        if GetTickCount() > m_dwStatusArrTimeOutTick {220} [i] then begin
          m_wStatusArrValue[i] := 0;
          boNeedRecalc := True;
          case i of
            0: begin
                SysMsg('攻击力回复正常', c_Green, t_Hint);
              end;
            1: begin
                SysMsg('魔法力回复正常', c_Green, t_Hint);
              end;
            2: begin
                SysMsg('道术回复正常', c_Green, t_Hint);
              end;
            3: begin
                SysMsg('攻击速度回复正常', c_Green, t_Hint);
              end;
            4: begin
                SysMsg('体力回复正常', c_Green, t_Hint);
              end;
            5: begin
                SysMsg('魔法值回复正常', c_Green, t_Hint);
              end;
          end;
        end;
      end;
    end;
    //004C84F5
    if boChg then begin
      m_nCharStatus := GetCharStatus();
      StatusChanged();
    end;
    //004C8511
    if boNeedRecalc then begin
      RecalcAbilitys();
      SendMsg(Self, RM_ABILITY, 0, 0, 0, 0, '');
    end;
  except
    MainOutMessage(sExceptionMsg5);
  end;

  //SetProcessName('TBaseObject.Run 6');
  //004C855A
  try
    if (GetTickCount - m_dwPoisoningTick) > g_Config.dwPosionDecHealthTime {2500} then begin
      m_dwPoisoningTick := GetTickCount();
      if m_wStatusTimeArr[POISON_DECHEALTH {0 0x60}] > 0 then begin
        if m_boAnimal then Dec(m_nMeatQuality, 1000);
        DamageHealth(m_btGreenPoisoningPoint + 1);
        m_nHealthTick := 0;
        m_nSpellTick := 0;
        HealthSpellChanged();
      end;
    end;
  except
    MainOutMessage(sExceptionMsg6);
  end;
  {
  if boOpenHealth then begin
    if (GetTickCount() - dwOpenHealthStart) > dwOpenHealthTime then begin
      BreakOpenHealth();
    end;
  end;
  }
  g_nBaseObjTimeMin := GetTickCount - dwRunTick;
  if g_nBaseObjTimeMax < g_nBaseObjTimeMin then g_nBaseObjTimeMax := g_nBaseObjTimeMin;
end;

function TPlayObject.DayBright: Byte;
begin
  Result := 0;
  if m_PEnvir <> nil then begin
    if m_PEnvir.m_boDarkness then
      Result := 1
    else if m_PEnvir.m_boDayLight then Result := 0;
  end;
end;

function TBaseObject.GetFrontPosition(var nX: Integer; var nY: Integer): Boolean;
var
  Envir: TEnvirnoment;
begin
  Envir := m_PEnvir;
  nX := m_nCurrX;
  nY := m_nCurrY;
  case m_btDirection of
    DR_UP: begin
        if nY > 0 then Dec(nY);
      end;
    DR_UPRIGHT: begin
        if (nX < (Envir.m_nWidth - 1)) and (nY > 0) then begin
          Inc(nX);
          Dec(nY);
        end;
      end;
    DR_RIGHT: begin
        if nX < (Envir.m_nWidth - 1) then Inc(nX);
      end;
    DR_DOWNRIGHT: begin
        if (nX < (Envir.m_nWidth - 1)) and (nY < (Envir.m_nHeight - 1)) then begin
          Inc(nX);
          Inc(nY);
        end;
      end;
    DR_DOWN: begin
        if nY < (Envir.m_nHeight - 1) then Inc(nY);
      end;
    DR_DOWNLEFT: begin
        if (nX > 0) and (nY < (Envir.m_nHeight - 1)) then begin
          Dec(nX);
          Inc(nY);
        end;
      end;
    DR_LEFT: begin
        if nX > 0 then Dec(nX);
      end;
    DR_UPLEFT: begin
        if (nX > 0) and (nY > 0) then begin
          Dec(nX);
          Dec(nY);
        end;
      end;
  end;
  Result := True;
end;

procedure TBaseObject.SpaceMove(sMAP: string; nX, nY: Integer; nInt: Integer);
  function GetRandXY(Envir: TEnvirnoment; var nX: Integer; var nY: Integer): Boolean;
  var
    n14, n18, n1C: Integer;
  begin
    Result := False;
    if Envir.m_nWidth < 80 then n18 := 3
    else n18 := 10;
    if Envir.m_nHeight < 150 then begin
      if Envir.m_nHeight < 50 then n1C := 2
      else n1C := 15;
    end else n1C := 50;
    n14 := 0;
    while (True) do begin
      if Envir.CanWalk(nX, nY, True) then begin
        Result := True;
        break;
      end;
      if nX < (Envir.m_nWidth - n1C - 1) then Inc(nX, n18)
      else begin
        nX := Random(Envir.m_nWidth);
        if nY < (Envir.m_nHeight - n1C - 1) then Inc(nY, n18)
        else nY := Random(Envir.m_nHeight);
      end;
      Inc(n14);
      if n14 >= 201 then break;
    end;
  end;
var
  i: Integer;
  Envir, OldEnvir: TEnvirnoment;
  nOldX, nOldY: Integer;
  bo21: Boolean;
  PlayObject: TPlayObject;
begin
  Envir := g_MapManager.FindMap(sMAP);
  if Envir <> nil then begin
    if nServerIndex = Envir.nServerIndex then begin
      OldEnvir := m_PEnvir;
      nOldX := m_nCurrX;
      nOldY := m_nCurrY;
      bo21 := False;
      m_PEnvir.DeleteFromMap(m_nCurrX, m_nCurrY, OS_MOVINGOBJECT, Self);
      m_VisibleHumanList.Clear;
      for i := 0 to m_VisibleItems.Count - 1 do begin
        DisPose(pTVisibleMapItem(m_VisibleItems.Items[i]));
      end;
      m_VisibleItems.Clear;
      for i := 0 to m_VisibleActors.Count - 1 do begin
        DisPose(pTVisibleBaseObject(m_VisibleActors.Items[i]));
      end;
      m_VisibleActors.Clear;
      m_VisibleEvents.Clear; //01/21 移动时清除列表
      m_PEnvir := Envir;
      m_sMapName := Envir.sMapName;
      m_nCurrX := nX;
      m_nCurrY := nY;
      if GetRandXY(m_PEnvir, m_nCurrX, m_nCurrY) then begin
        m_PEnvir.AddToMap(m_nCurrX, m_nCurrY, OS_MOVINGOBJECT, Self);
        SendMsg(Self, RM_CLEAROBJECTS, 0, 0, 0, 0, '');
        SendMsg(Self, RM_CHANGEMAP, 0, 0, 0, 0, g_MapManager.GetMainMap(Envir)); //获取重复利用地图名称
        if nInt = 1 then begin
          SendRefMsg(RM_SPACEMOVE_SHOW2, m_btDirection, m_nCurrX, m_nCurrY, 0, '');
        end else SendRefMsg(RM_SPACEMOVE_SHOW, m_btDirection, m_nCurrX, m_nCurrY, 0, '');
        m_dwMapMoveTick := GetTickCount();
        m_bo316 := True;
        bo21 := True;
      end;
      if not bo21 then begin
        m_PEnvir := OldEnvir;
        m_nCurrX := nOldX;
        m_nCurrY := nOldY;
        m_PEnvir.AddToMap(m_nCurrX, m_nCurrY, OS_MOVINGOBJECT, Self);
      end;
    end else begin
      if GetRandXY(Envir, nX, nY) then begin
        if m_btRaceServer = RC_PLAYOBJECT then begin
          DisappearA();
          m_bo316 := True;
          PlayObject := TPlayObject(Self);
          PlayObject.m_sSwitchMapName := Envir.sMapName;
          PlayObject.m_nSwitchMapX := nX;
          PlayObject.m_nSwitchMapY := nY;
          PlayObject.m_boSwitchData := True;
          PlayObject.m_nServerIndex := Envir.nServerIndex;
          PlayObject.m_boEmergencyClose := True;
          PlayObject.m_boReconnection := True;
          PlayObject.m_boPlayOffLine := False;
        end else KickException();
      end;
    end;
  end;
end;

procedure TPlayObject.RefUserState();
var
  n8: Integer;
begin
  n8 := 0;
  if m_PEnvir.m_boFightZone then n8 := n8 or 1;
  if m_PEnvir.m_boSAFE then n8 := n8 or 2;
  if m_boInFreePKArea then n8 := n8 or 4;
  SendDefMessage(SM_AREASTATE, n8, 0, 0, 0, '');
end;

procedure TBaseObject.RefShowName();
begin
  SendRefMsg(RM_USERNAME, 0, 0, 0, 0, GetShowName);
end;

procedure TPlayObject.RefMyStatus();
begin
  RecalcAbilitys();
  SendMsg(Self, RM_MYSTATUS, 0, 0, 0, 0, '');
end;

function TBaseObject.Operate(ProcessMsg: pTProcessMessage): Boolean;
var
  nDamage: Integer;
  nTargetX: Integer;
  nTargetY: Integer;
  nPower: Integer;
  nRage: Integer;
  TargeTBaseObject: TBaseObject;
resourcestring
  sExceptionMsg = '[Exception] TBaseObject::Operate ';
begin
  Result := False;
  if ProcessMsg = nil then Exit;
  try
    case ProcessMsg.wIdent of
      RM_MAGSTRUCK,
        RM_MAGSTRUCK_MINE: begin //10025
          if (ProcessMsg.wIdent = RM_MAGSTRUCK) and
            (m_btRaceServer >= RC_ANIMAL) and
            (not bo2BF) and (m_Abil.Level < 50) then begin
            m_dwWalkTick := m_dwWalkTick + 800 + LongWord(Random(1000));
          end;
          nDamage := GetMagStruckDamage(nil, ProcessMsg.nParam1);
          if nDamage > 0 then begin
            StruckDamage(nDamage);
            HealthSpellChanged();
            SendRefMsg(RM_STRUCK_MAG, nDamage, m_WAbil.HP, m_WAbil.MaxHP, Integer(ProcessMsg.BaseObject), '');
            if m_btRaceServer <> RC_PLAYOBJECT then begin
              if m_boAnimal then Dec(m_nMeatQuality, nDamage * 1000);
              SendMsg(Self, RM_STRUCK, nDamage, m_WAbil.HP, m_WAbil.MaxHP, Integer(ProcessMsg.BaseObject) {AttackBaseObject}, '');
            end;
          end;
          if m_boFastParalysis then begin
            m_wStatusTimeArr[POISON_STONE] := 1;
            m_boFastParalysis := False;
          end;
        end;
      RM_MAGHEALING: begin //10026
          if (m_nIncHealing + ProcessMsg.nParam1) < 300 then begin
            if m_btRaceServer = RC_PLAYOBJECT then begin
              Inc(m_nIncHealing, ProcessMsg.nParam1);
              m_nPerHealing := 5;
            end else begin
              Inc(m_nIncHealing, ProcessMsg.nParam1);
              m_nPerHealing := 5;
            end;
          end else m_nIncHealing := 300;
        end;
      RM_10101: begin //10101
          SendRefMsg(Integer(ProcessMsg.BaseObject),
            ProcessMsg.wParam {nPower},
            ProcessMsg.nParam1 {HP},
            ProcessMsg.nParam2 {MaxHP},
            ProcessMsg.nParam3 {AttackSrc},
            ProcessMsg.sMsg);
          if (Integer(ProcessMsg.BaseObject) = RM_STRUCK) and (m_btRaceServer <> RC_PLAYOBJECT) then begin
            SendMsg(Self, Integer(ProcessMsg.BaseObject),
              ProcessMsg.wParam,
              ProcessMsg.nParam1,
              ProcessMsg.nParam2,
              ProcessMsg.nParam3 {AttackBaseObject},
              ProcessMsg.sMsg);
          end;
          if m_boFastParalysis then begin
            m_wStatusTimeArr[POISON_STONE] := 1;
            m_boFastParalysis := False;
          end;
        end;
      RM_DELAYMAGIC: begin
          nPower := ProcessMsg.wParam;
          nTargetX := LoWord(ProcessMsg.nParam1);
          nTargetY := HiWord(ProcessMsg.nParam1);
          nRage := ProcessMsg.nParam2;
          TargeTBaseObject := TBaseObject(ProcessMsg.nParam3);
          if (TargeTBaseObject <> nil) and
            (TargeTBaseObject.GetMagStruckDamage(Self, nPower) > 0) then begin

            SetTargetCreat {0FFF2}(TargeTBaseObject);
            if TargeTBaseObject.m_btRaceServer >= RC_ANIMAL then
              nPower := ROUND(nPower / 1.2);
            if (abs(nTargetX - TargeTBaseObject.m_nCurrX) <= nRage) and (abs(nTargetY - TargeTBaseObject.m_nCurrY) <= nRage) then
              TargeTBaseObject.SendMsg(Self, RM_MAGSTRUCK, 0, nPower, 0, 0, '');
          end;
        end;
      RM_10155: begin
          MapRandomMove(ProcessMsg.sMsg, ProcessMsg.wParam);
        end;
      RM_DELAYPUSHED: begin
          nPower := ProcessMsg.wParam;
          nTargetX := LoWord(ProcessMsg.nParam1);
          nTargetY := HiWord(ProcessMsg.nParam1);
          nRage := ProcessMsg.nParam2;
          TargeTBaseObject := TBaseObject(ProcessMsg.nParam3);
          if (TargeTBaseObject <> nil) then begin
            TargeTBaseObject.CharPushed(nPower, nRage);
          end;
        end;
      RM_POISON: begin
          TargeTBaseObject := TBaseObject(ProcessMsg.nParam2);
          if TargeTBaseObject <> nil then begin
            if IsProperTarget {FFF4}(TargeTBaseObject) then begin
              SetTargetCreat {0FFF2}(TargeTBaseObject);
              if (m_btRaceServer = RC_PLAYOBJECT) and (TargeTBaseObject.m_btRaceServer = RC_PLAYOBJECT) then begin
                SetPKFlag(TargeTBaseObject);
              end;
              SetLastHiter(TargeTBaseObject);
            end;
            MakePosion(ProcessMsg.wParam {中毒类型}, ProcessMsg.nParam1 {nPower}, ProcessMsg.nParam3 {});
          end else MakePosion(ProcessMsg.wParam {中毒类型}, ProcessMsg.nParam1 {nPower}, ProcessMsg.nParam3);

        end;
      RM_TRANSPARENT: begin //10308
          MagicManager.MagMakePrivateTransparent(Self, ProcessMsg.nParam1);
        end;
      RM_DOOPENHEALTH: begin //10412
          MakeOpenHealth();
        end;

{$IF CHECKNEWMSG = 1}
      else begin
          MainOutMessage(format('人物: %s 消息: Ident %d Param %d P1 %d P2 %d P3 %d Msg %s',
            [m_sCharName,
            ProcessMsg.wIdent,
              ProcessMsg.wParam,
              ProcessMsg.nParam1,
              ProcessMsg.nParam2,
              ProcessMsg.nParam3,
              ProcessMsg.sMsg]));
        end;
{$IFEND}
    end;
  except
    on E: Exception do begin
      MainOutMessage(sExceptionMsg);
      MainOutMessage(E.Message);
    end;
  end;
end;

function TPlayObject.Operate(ProcessMsg: pTProcessMessage): Boolean;
var
  CharDesc: TCharDesc;
  nObjCount: Integer;
  s1C: string;
  MessageBodyWL: TMessageBodyWL;
  MessageBodyW: TMessageBodyW;
  ShortMessage: TShortMessage;
  OAbility: TOAbility;
  dwDelayTime: LongWord;
  nMsgCount: Integer;
  boReturn: Boolean;
begin
  Result := True;
  if ProcessMsg = nil then begin
    Result := False;
    Exit;
  end;
  boReturn := False;
  case ProcessMsg.wIdent of
    CM_QUERYUSERNAME: begin //80
        ClientQueryUserName(TPlayObject(ProcessMsg.nParam1), ProcessMsg.nParam2, ProcessMsg.nParam3);
      end;
    CM_QUERYBAGITEMS: begin //0x81
        ClientQueryBagItems();
      end;
    CM_QUERYUSERSTATE: begin //82
        ClientQueryUserState(TPlayObject(ProcessMsg.nParam1), ProcessMsg.nParam2, ProcessMsg.nParam3);
      end;
    CM_QUERYUSERSET: begin
        ClientQueryUserSet(ProcessMsg);
      end;
    CM_DROPITEM: begin //1000
        if ClientDropItem(ProcessMsg.sMsg, ProcessMsg.nParam1) then
          SendDefMessage(SM_DROPITEM_SUCCESS, ProcessMsg.nParam1, 0, 0, 0, ProcessMsg.sMsg)
        else SendDefMessage(SM_DROPITEM_FAIL, ProcessMsg.nParam1, 0, 0, 0, ProcessMsg.sMsg);
      end;
    CM_PICKUP: begin //1001  004D78F9
        if (m_nCurrX = ProcessMsg.nParam2) and (m_nCurrY = ProcessMsg.nParam3) then
          ClientPickUpItem();
      end;
    CM_OPENDOOR: begin //1002
        ClientOpenDoor(ProcessMsg.nParam2, ProcessMsg.nParam3);
      end;
    CM_TAKEONITEM: begin //1003
        ClientTakeOnItems(ProcessMsg.nParam2, ProcessMsg.nParam1, ProcessMsg.sMsg);
      end;
    CM_TAKEOFFITEM: begin //1004
        ClientTakeOffItems(ProcessMsg.nParam2, ProcessMsg.nParam1, ProcessMsg.sMsg);
      end;
    CM_EAT: begin //1006
        ClientUseItems(ProcessMsg.nParam1, ProcessMsg.sMsg);
      end;
    CM_BUTCH: begin //1007
        if not ClientGetButchItem(TBaseObject(ProcessMsg.nParam1), ProcessMsg.nParam2, ProcessMsg.nParam3, ProcessMsg.wParam, dwDelayTime) then begin
          if dwDelayTime <> 0 then begin
            nMsgCount := GetDigUpMsgCount();
            if nMsgCount >= g_Config.nMaxDigUpMsgCount then begin
              Inc(m_nOverSpeedCount);
              if m_nOverSpeedCount > g_Config.nOverSpeedKickCount then begin
                if g_Config.boKickOverSpeed then begin
                  SysMsg(g_sKickClientUserMsg {'请勿使用非法软件！！！'}, c_Red, t_Hint);
                  m_boEmergencyClose := True;
                  m_boPlayOffLine := False;
                end;
                if g_Config.boViewHackMessage then begin
                  //MainOutMessage('[游戏超速] ' + m_sCharName + ' Time: ' + IntToStr(dwDelayTime) + ' Count: '+ IntToStr(nMsgCount));
                  MainOutMessage(format(g_sBunOverSpeed, [m_sCharName, dwDelayTime, nMsgCount]));
                end;
              end;
              //如果超速则发送攻击失败信息
              if Assigned(zPlugOfEngine.SendActionFail) then begin
                zPlugOfEngine.SendActionFail(Self);
              end else begin
                SendSocket(nil, sSTATUS_FAIL + IntToStr(GetTickCount));
              end;
            end else begin
              if dwDelayTime < g_Config.dwDropOverSpeed then begin
                if m_boTestSpeedMode then
                  SysMsg(format('速度异常 Ident: %d Time: %d', [ProcessMsg.wIdent, dwDelayTime]), c_Red, t_Hint);
                if Assigned(zPlugOfEngine.SendActionGood) then begin
                  zPlugOfEngine.SendActionGood(Self);
                end else begin
                  SendSocket(nil, sSTATUS_GOOD + IntToStr(GetTickCount));
                end;
              end else begin
                SendDelayMsg(Self, ProcessMsg.wIdent, ProcessMsg.wParam, ProcessMsg.nParam1, ProcessMsg.nParam2, ProcessMsg.nParam3, '', dwDelayTime);
                Result := False;
              end;
            end;
          end;
        end;
      end;
    CM_MAGICKEYCHANGE: begin //1008
        ClientChangeMagicKey(ProcessMsg.nParam1, ProcessMsg.nParam2);
      end;
    CM_SOFTCLOSE: begin
        m_boReconnection := True;
        m_boSoftClose := True;
      end;
    CM_CLICKNPC: //1010  004D79E4
      ClientClickNPC(ProcessMsg.nParam1);
    CM_MERCHANTDLGSELECT: //1011
      ClientMerchantDlgSelect(ProcessMsg.nParam1, ProcessMsg.sMsg);
    CM_MERCHANTQUERYSELLPRICE: //1012
      ClientMerchantQuerySellPrice(ProcessMsg.nParam1, MakeLong(ProcessMsg.nParam2, ProcessMsg.nParam3), ProcessMsg.sMsg);
    CM_USERSELLITEM: //1013
      ClientUserSellItem(ProcessMsg.nParam1, MakeLong(ProcessMsg.nParam2, ProcessMsg.nParam3), ProcessMsg.sMsg);

    CM_USERBUYITEM: //1014  004D7AD4
      ClientUserBuyItem(ProcessMsg.wIdent, ProcessMsg.nParam1, MakeLong(ProcessMsg.nParam2, ProcessMsg.nParam3), 0, ProcessMsg.sMsg);
    //////////////////////////////增加拍卖////////////////////////////////////////////////////
    CM_SENDSELLOFFITEM:
      ClientUserSellOffItem(ProcessMsg.nParam1, MakeLong(ProcessMsg.nParam2, ProcessMsg.nParam3), ProcessMsg.sMsg);

    CM_SENDQUERYSELLOFFITEM:
      ClientUserBuySellOffItem(ProcessMsg.wIdent, ProcessMsg.nParam1, ProcessMsg.nParam2, ProcessMsg.nParam3, ProcessMsg.sMsg);

    CM_SENDBUYSELLOFFITEM:
      ClientUserBuySellOffItem(ProcessMsg.wIdent, ProcessMsg.nParam1, MakeLong(ProcessMsg.nParam2, ProcessMsg.nParam3), 0, ProcessMsg.sMsg);

    /////////////////////////增加拍卖////////////////////////////////////////////////////////
    CM_USERGETDETAILITEM:
      ClientUserBuyItem(ProcessMsg.wIdent, ProcessMsg.nParam1, 0, ProcessMsg.nParam2, ProcessMsg.sMsg);

    CM_DROPGOLD:
      if ProcessMsg.nParam1 > 0 then ClientDropGold(ProcessMsg.nParam1);

    CM_1017:
      SendDefMessage(1, 0, 0, 0, 0, '');

    CM_GROUPMODE: begin
        if ProcessMsg.nParam2 = 0 then ClientGropuClose()
        else m_boAllowGroup := True;
        if m_boAllowGroup then SendDefMessage(SM_GROUPMODECHANGED, 0, 1, 0, 0, '')
        else SendDefMessage(SM_GROUPMODECHANGED, 0, 0, 0, 0, '');
      end;
    CM_CREATEGROUP: begin //1020
        ClientCreateGroup(Trim(ProcessMsg.sMsg));
      end;
    CM_ADDGROUPMEMBER: begin //1021
        ClientAddGroupMember(Trim(ProcessMsg.sMsg));
      end;
    CM_DELGROUPMEMBER: begin //1022
        ClientDelGroupMember(Trim(ProcessMsg.sMsg));
      end;
    CM_USERREPAIRITEM: begin //1023 004D7A70
        ClientRepairItem(ProcessMsg.nParam1, MakeLong(ProcessMsg.nParam2, ProcessMsg.nParam3), ProcessMsg.sMsg);
      end;
    CM_MERCHANTQUERYREPAIRCOST: begin //1024 004D7A2A
        ClientQueryRepairCost(ProcessMsg.nParam1, MakeLong(ProcessMsg.nParam2, ProcessMsg.nParam3), ProcessMsg.sMsg);
      end;
    CM_DEALTRY: begin //1025
        ClientDealTry(Trim(ProcessMsg.sMsg));
      end;
    CM_DEALADDITEM: begin //1026
        ClientAddDealItem(ProcessMsg.nParam1, ProcessMsg.sMsg);
      end;
    CM_DEALDELITEM: begin //1027
        ClientDelDealItem(ProcessMsg.nParam1, ProcessMsg.sMsg);
      end;
    CM_DEALCANCEL: begin //1028
        ClientCancelDeal();
      end;
    CM_DEALCHGGOLD: begin //1029
        ClientChangeDealGold(ProcessMsg.nParam1);
      end;
    CM_DEALEND: begin //1030
        ClientDealEnd();
      end;
    CM_USERSTORAGEITEM: begin //1031
        ClientStorageItem(TObject(ProcessMsg.nParam1), MakeLong(ProcessMsg.nParam2, ProcessMsg.nParam3), ProcessMsg.sMsg);
      end;
    CM_USERTAKEBACKSTORAGEITEM: begin //1032
        ClientTakeBackStorageItem(TObject(ProcessMsg.nParam1), MakeLong(ProcessMsg.nParam2, ProcessMsg.nParam3), ProcessMsg.sMsg);
      end;
    CM_WANTMINIMAP: begin //1033
        ClientGetMinMap();
      end;
    CM_USERMAKEDRUGITEM: begin //1034
        ClientMakeDrugItem(TObject(ProcessMsg.nParam1), ProcessMsg.sMsg);
      end;
    CM_OPENGUILDDLG: begin //1035
        ClientOpenGuildDlg();
      end;
    CM_GUILDHOME: begin //1036
        ClientGuildHome();
      end;
    CM_GUILDMEMBERLIST: begin
        ClientGuildMemberList();
      end;
    CM_GUILDADDMEMBER: begin
        ClientGuildAddMember(ProcessMsg.sMsg);
      end;
    CM_GUILDDELMEMBER: begin
        ClientGuildDelMember(ProcessMsg.sMsg);
      end;
    CM_GUILDUPDATENOTICE: begin
        ClientGuildUpdateNotice(ProcessMsg.sMsg);
      end;
    CM_GUILDUPDATERANKINFO: begin //1041
        ClientGuildUpdateRankInfo(ProcessMsg.sMsg);
      end;
    CM_1042: begin
        MainOutMessage('[非法数据] ' + m_sCharName);
      end;
    CM_ADJUST_BONUS: begin
        ClientAdjustBonus(ProcessMsg.nParam1, ProcessMsg.sMsg);
      end;
    CM_GUILDALLY: begin //1044
        ClientGuildAlly();
      end;
    CM_GUILDBREAKALLY: begin //1045
        ClientGuildBreakAlly(ProcessMsg.sMsg);
      end;
{$IF CHECKNEWMSG = 1}
    CM_1046: begin
        MainOutMessage(format('%s/%d/%d/%d/%d/%d/%s',
          [m_sCharName,
          ProcessMsg.wIdent,
            ProcessMsg.wParam,
            ProcessMsg.nParam1,
            ProcessMsg.nParam2,
            ProcessMsg.nParam3,
            DeCodeString(ProcessMsg.sMsg)]));
      end;
    CM_1056: begin
        MainOutMessage(format('%s/%d/%d/%d/%d/%d/%s',
          [m_sCharName,
          ProcessMsg.wIdent,
            ProcessMsg.wParam,
            ProcessMsg.nParam1,
            ProcessMsg.nParam2,
            ProcessMsg.nParam3,
            DeCodeString(ProcessMsg.sMsg)]));
      end;
{$IFEND}
    CM_TURN: begin //3010    004D73DD
        if ClientChangeDir(ProcessMsg.wIdent, ProcessMsg.nParam1 {x}, ProcessMsg.nParam2 {y}, ProcessMsg.wParam {dir}, dwDelayTime) then begin
          m_dwActionTick := GetTickCount;
          if Assigned(zPlugOfEngine.SendActionGood) then begin
            zPlugOfEngine.SendActionGood(Self);
          end else begin
            SendSocket(nil, sSTATUS_GOOD + IntToStr(GetTickCount));
          end;
        end else begin
          if dwDelayTime = 0 then begin
            if Assigned(zPlugOfEngine.SendActionFail) then begin
              zPlugOfEngine.SendActionFail(Self);
            end else begin
              SendSocket(nil, sSTATUS_FAIL + IntToStr(GetTickCount));
            end;
          end else begin
            nMsgCount := GetTurnMsgCount();
            if nMsgCount >= g_Config.nMaxTurnMsgCount then begin
              Inc(m_nOverSpeedCount);
              if m_nOverSpeedCount > g_Config.nOverSpeedKickCount then begin
                if g_Config.boKickOverSpeed then begin
                  SysMsg(g_sKickClientUserMsg {'请勿使用非法软件！！！'}, c_Red, t_Hint);
                  m_boEmergencyClose := True;
                  m_boPlayOffLine := False;
                end;
                if g_Config.boViewHackMessage then begin
                  //MainOutMessage('[游戏超速] ' + m_sCharName + ' Time: ' + IntToStr(dwDelayTime) + ' Count: '+ IntToStr(nMsgCount));
                  MainOutMessage(format(g_sBunOverSpeed, [m_sCharName, dwDelayTime, nMsgCount]));
                end;
              end;
              //如果超速则发送攻击失败信息
              if Assigned(zPlugOfEngine.SendActionFail) then begin
                zPlugOfEngine.SendActionFail(Self);
              end else begin
                SendSocket(nil, sSTATUS_FAIL + IntToStr(GetTickCount));
              end;
            end else begin
              if dwDelayTime < g_Config.dwDropOverSpeed then begin
                if Assigned(zPlugOfEngine.SendActionGood) then begin
                  zPlugOfEngine.SendActionGood(Self);
                end else begin
                  SendSocket(nil, sSTATUS_GOOD + IntToStr(GetTickCount));
                end;
                if m_boTestSpeedMode then
                  SysMsg(format('速度异常 Ident: %d Time: %d', [ProcessMsg.wIdent, dwDelayTime]), c_Red, t_Hint);
              end else begin
                SendDelayMsg(Self, ProcessMsg.wIdent, ProcessMsg.wParam, ProcessMsg.nParam1, ProcessMsg.nParam2, ProcessMsg.nParam3, '', dwDelayTime);
                Result := False;
              end;
            end;
          end;
        end;
      end;
    CM_WALK: begin
        if ClientWalkXY(ProcessMsg.wIdent, ProcessMsg.nParam1 {x}, ProcessMsg.nParam2 {y}, ProcessMsg.boLateDelivery, dwDelayTime) then begin
          m_dwActionTick := GetTickCount;
          if g_Config.boStartMapEvent then begin
            if m_btRaceServer = RC_PLAYOBJECT then StartMapEventOfWalk(); //走路事件触发}
          end;
          if Assigned(zPlugOfEngine.SendActionGood) then begin
            zPlugOfEngine.SendActionGood(Self);
          end else begin
            SendSocket(nil, sSTATUS_GOOD + IntToStr(GetTickCount));
          end;
          Inc(n5F8);
        end else begin
          if dwDelayTime = 0 then begin
            if Assigned(zPlugOfEngine.SendActionFail) then begin
              zPlugOfEngine.SendActionFail(Self);
            end else begin
              SendSocket(nil, sSTATUS_FAIL + IntToStr(GetTickCount));
            end;
          end else begin
            nMsgCount := GetWalkMsgCount();
            if nMsgCount >= g_Config.nMaxWalkMsgCount then begin
              Inc(m_nOverSpeedCount);
              if m_nOverSpeedCount > g_Config.nOverSpeedKickCount then begin
                if g_Config.boKickOverSpeed then begin
                  SysMsg(g_sKickClientUserMsg {'请勿使用非法软件！！！'}, c_Red, t_Hint);
                  m_boEmergencyClose := True;
                  m_boPlayOffLine := False;
                end;
                if g_Config.boViewHackMessage then begin
                  //MainOutMessage('[行走超速] ' + m_sCharName + ' Time: ' + IntToStr(dwDelayTime) + ' Count: '+ IntToStr(nMsgCount));
                  MainOutMessage(format(g_sWalkOverSpeed, [m_sCharName, dwDelayTime, nMsgCount]));
                end;
              end;
              //如果超速则发送攻击失败信息
              if Assigned(zPlugOfEngine.SendActionFail) then begin
                zPlugOfEngine.SendActionFail(Self);
              end else begin
                SendSocket(nil, sSTATUS_FAIL + IntToStr(GetTickCount));
              end;
              if m_boTestSpeedMode then
                SysMsg(format('速度异常 Ident: %d Time: %d', [ProcessMsg.wIdent, dwDelayTime]), c_Red, t_Hint);
            end else begin
              if (dwDelayTime > g_Config.dwDropOverSpeed) and (g_Config.btSpeedControlMode = 1) and m_boFilterAction then begin
                if Assigned(zPlugOfEngine.SendActionFail) then begin
                  zPlugOfEngine.SendActionFail(Self);
                end else begin
                  SendSocket(nil, sSTATUS_FAIL + IntToStr(GetTickCount));
                end;
                if m_boTestSpeedMode then
                  SysMsg(format('速度异常 Ident: %d Time: %d', [ProcessMsg.wIdent, dwDelayTime]), c_Red, t_Hint);
              end else begin

                if m_boTestSpeedMode then
                  SysMsg(format('操作延迟 Ident: %d Time: %d', [ProcessMsg.wIdent, dwDelayTime]), c_Red, t_Hint);
                SendDelayMsg(Self, ProcessMsg.wIdent, ProcessMsg.wParam, ProcessMsg.nParam1, ProcessMsg.nParam2, ProcessMsg.nParam3, '', dwDelayTime);
                Result := False;
              end;
            end;
          end;
        end;
      end;

    CM_HORSERUN: begin
        if ClientHorseRunXY(ProcessMsg.wIdent, ProcessMsg.nParam1 {x}, ProcessMsg.nParam2 {y}, ProcessMsg.boLateDelivery, dwDelayTime) then begin
          m_dwActionTick := GetTickCount;
          if Assigned(zPlugOfEngine.SendActionGood) then begin
            zPlugOfEngine.SendActionGood(Self);
          end else begin
            SendSocket(nil, sSTATUS_GOOD + IntToStr(GetTickCount));
          end;
          Inc(n5F8);
        end else begin

          if dwDelayTime = 0 then begin
            if Assigned(zPlugOfEngine.SendActionFail) then begin
              zPlugOfEngine.SendActionFail(Self);
            end else begin
              SendSocket(nil, sSTATUS_FAIL + IntToStr(GetTickCount));
            end;
          end else begin
            nMsgCount := GetRunMsgCount();
            if nMsgCount >= g_Config.nMaxRunMsgCount then begin
              Inc(m_nOverSpeedCount);
              if m_nOverSpeedCount > g_Config.nOverSpeedKickCount then begin
                if g_Config.boKickOverSpeed then begin
                  SysMsg(g_sKickClientUserMsg {'请勿使用非法软件！！！'}, c_Red, t_Hint);
                  m_boEmergencyClose := True;
                  m_boPlayOffLine := False;
                end;
                if g_Config.boViewHackMessage then begin
                  //MainOutMessage('[跑步超速] ' + m_sCharName + ' Time: ' + IntToStr(dwDelayTime) + ' Count: '+ IntToStr(nMsgCount));
                  MainOutMessage(format(g_sRunOverSpeed, [m_sCharName, dwDelayTime, nMsgCount]));
                end;
              end;
              //如果超速则发送攻击失败信息
              if Assigned(zPlugOfEngine.SendActionFail) then begin
                zPlugOfEngine.SendActionFail(Self);
              end else begin
                SendSocket(nil, sSTATUS_FAIL + IntToStr(GetTickCount));
              end;
              if m_boTestSpeedMode then
                SysMsg(format('速度异常 Ident: %d Time: %d', [ProcessMsg.wIdent, dwDelayTime]), c_Red, t_Hint);
            end else begin
              if m_boTestSpeedMode then
                SysMsg(format('操作延迟 Ident: %d Time: %d', [ProcessMsg.wIdent, dwDelayTime]), c_Red, t_Hint);
              SendDelayMsg(Self, ProcessMsg.wIdent, ProcessMsg.wParam, ProcessMsg.nParam1, ProcessMsg.nParam2, ProcessMsg.nParam3, '', dwDelayTime);
              Result := False;
            end;
          end;
        end;
      end;
    CM_RUN: begin
        if ClientRunXY(ProcessMsg.wIdent, ProcessMsg.nParam1 {x}, ProcessMsg.nParam2 {y}, ProcessMsg.nParam3, dwDelayTime) then begin
          m_dwActionTick := GetTickCount;
          if g_Config.boStartMapEvent then begin
            if m_btRaceServer = RC_PLAYOBJECT then StartMapEventOfRun(); //跑步事件触发
          end;
          if Assigned(zPlugOfEngine.SendActionGood) then begin
            zPlugOfEngine.SendActionGood(Self);
          end else begin
            SendSocket(nil, sSTATUS_GOOD + IntToStr(GetTickCount));
          end;
          Inc(n5F8);
        end else begin
          if dwDelayTime = 0 then begin
            if Assigned(zPlugOfEngine.SendActionFail) then begin
              zPlugOfEngine.SendActionFail(Self);
            end else begin
              SendSocket(nil, sSTATUS_FAIL + IntToStr(GetTickCount));
            end;
          end else begin
            nMsgCount := GetRunMsgCount();
            if nMsgCount >= g_Config.nMaxRunMsgCount then begin
              Inc(m_nOverSpeedCount);
              if m_nOverSpeedCount > g_Config.nOverSpeedKickCount then begin
                if g_Config.boKickOverSpeed then begin
                  SysMsg(g_sKickClientUserMsg {'请勿使用非法软件！！！'}, c_Red, t_Hint);
                  m_boEmergencyClose := True;
                  m_boPlayOffLine := False;
                end;
                if g_Config.boViewHackMessage then begin
                  //MainOutMessage('[跑步超速] ' + m_sCharName + ' Time: ' + IntToStr(dwDelayTime) + ' Count: '+ IntToStr(nMsgCount));
                  MainOutMessage(format(g_sRunOverSpeed, [m_sCharName, dwDelayTime, nMsgCount]));
                end;
              end;
              //如果超速则发送攻击失败信息
              if Assigned(zPlugOfEngine.SendActionFail) then begin
                zPlugOfEngine.SendActionFail(Self);
              end else begin
                SendSocket(nil, sSTATUS_FAIL + IntToStr(GetTickCount));
              end;
            end else begin
              if (dwDelayTime > g_Config.dwDropOverSpeed) and (g_Config.btSpeedControlMode = 1) and m_boFilterAction then begin
                if Assigned(zPlugOfEngine.SendActionFail) then begin
                  zPlugOfEngine.SendActionFail(Self);
                end else begin
                  SendSocket(nil, sSTATUS_FAIL + IntToStr(GetTickCount));
                end;
                if m_boTestSpeedMode then
                  SysMsg(format('速度异常 Ident: %d Time: %d', [ProcessMsg.wIdent, dwDelayTime]), c_Red, t_Hint);
              end else begin
                if m_boTestSpeedMode then
                  SysMsg(format('操作延迟 Ident: %d Time: %d', [ProcessMsg.wIdent, dwDelayTime]), c_Red, t_Hint);
                SendDelayMsg(Self, ProcessMsg.wIdent, ProcessMsg.wParam, ProcessMsg.nParam1, ProcessMsg.nParam2, CM_RUN, '', dwDelayTime);
                Result := False;
              end;
            end;
          end;
        end;
      end;
    CM_HIT, //3014
    CM_HEAVYHIT, //3015
    CM_BIGHIT, //3016
    CM_POWERHIT, //3018
    CM_LONGHIT, //3019
    CM_WIDEHIT, //3024
    CM_CRSHIT,
      CM_TWNHIT,
      CM_FIREHIT: begin //3025  :004D75BC
        if ClientHitXY(ProcessMsg.wIdent {ident}, ProcessMsg.nParam1 {x}, ProcessMsg.nParam2 {y}, ProcessMsg.wParam {dir}, ProcessMsg.boLateDelivery, dwDelayTime) then begin
          m_dwActionTick := GetTickCount;
          SendSocket(nil, sSTATUS_GOOD + IntToStr(GetTickCount));
          Inc(n5F8);
        end else begin
          if dwDelayTime = 0 then begin
            SendSocket(nil, sSTATUS_FAIL + IntToStr(GetTickCount));
          end else begin
            nMsgCount := GetHitMsgCount();
            if nMsgCount >= g_Config.nMaxHitMsgCount then begin
              Inc(m_nOverSpeedCount);
              if m_nOverSpeedCount > g_Config.nOverSpeedKickCount then begin
                if g_Config.boKickOverSpeed then begin
                  SysMsg(g_sKickClientUserMsg {'请勿使用非法软件！！！'}, c_Red, t_Hint);
                  m_boEmergencyClose := True;
                  m_boPlayOffLine := False;
                end;
                if g_Config.boViewHackMessage then begin
                  //MainOutMessage('[攻击超速] ' + m_sCharName + ' Time: ' + IntToStr(dwDelayTime) + ' Count: '+ IntToStr(nMsgCount));
                  MainOutMessage(format(g_sHitOverSpeed, [m_sCharName, dwDelayTime, nMsgCount]));
                end;
              end;
              //如果超速则发送攻击失败信息
              SendSocket(nil, sSTATUS_FAIL + IntToStr(GetTickCount));
            end else begin
              if (dwDelayTime > g_Config.dwDropOverSpeed) and (g_Config.btSpeedControlMode = 1) and m_boFilterAction then begin
                if Assigned(zPlugOfEngine.SendActionGood) then begin
                  zPlugOfEngine.SendActionGood(Self);
                end else begin
                  SendSocket(nil, sSTATUS_GOOD + IntToStr(GetTickCount));
                end;
                if m_boTestSpeedMode then
                  SysMsg(format('速度异常 Ident: %d Time: %d', [ProcessMsg.wIdent, dwDelayTime]), c_Red, t_Hint);
              end else begin
                if m_boTestSpeedMode then begin
                  //SysMsg(format('操作延迟 Ident: %d Time: %d',[ProcessMsg.wIdent,dwDelayTime]),c_Red,t_Hint);
                  SysMsg('操作延迟 Ident: ' + IntToStr(ProcessMsg.wIdent) + ' Time: ' + IntToStr(dwDelayTime), c_Red, t_Hint);
                end;
                SendDelayMsg(Self, ProcessMsg.wIdent, ProcessMsg.wParam, ProcessMsg.nParam1, ProcessMsg.nParam2, ProcessMsg.nParam3, '', dwDelayTime);
                Result := False;
              end;
            end;
          end;
        end;
      end;
    CM_SITDOWN: begin //3012
        if ClientSitDownHit(ProcessMsg.nParam1, ProcessMsg.nParam2, ProcessMsg.wParam, dwDelayTime) then begin
          m_dwActionTick := GetTickCount();
          if Assigned(zPlugOfEngine.SendActionGood) then begin
            zPlugOfEngine.SendActionGood(Self);
          end else begin
            SendSocket(nil, sSTATUS_GOOD + IntToStr(GetTickCount));
          end;
        end else begin
          if dwDelayTime = 0 then begin
            if Assigned(zPlugOfEngine.SendActionFail) then begin
              zPlugOfEngine.SendActionFail(Self);
            end else begin
              SendSocket(nil, sSTATUS_FAIL + IntToStr(GetTickCount));
            end;
          end else begin
            nMsgCount := GetSiteDownMsgCount();
            if nMsgCount >= g_Config.nMaxSitDonwMsgCount then begin
              Inc(m_nOverSpeedCount);
              if m_nOverSpeedCount > g_Config.nOverSpeedKickCount then begin
                if g_Config.boKickOverSpeed then begin
                  SysMsg(g_sKickClientUserMsg {'请勿使用非法软件！！！'}, c_Red, t_Hint);
                  m_boEmergencyClose := True;
                  m_boPlayOffLine := False;
                end;
                if g_Config.boViewHackMessage then begin
                  //MainOutMessage('[游戏超速] ' + m_sCharName + ' Time: ' + IntToStr(dwDelayTime) + ' Count: '+ IntToStr(nMsgCount));
                  MainOutMessage(format(g_sBunOverSpeed, [m_sCharName, dwDelayTime, nMsgCount]));
                end;
              end;
              //如果超速则发送攻击失败信息
              if Assigned(zPlugOfEngine.SendActionFail) then begin
                zPlugOfEngine.SendActionFail(Self);
              end else begin
                SendSocket(nil, sSTATUS_FAIL + IntToStr(GetTickCount));
              end;
            end else begin
              if dwDelayTime < g_Config.dwDropOverSpeed then begin
                if Assigned(zPlugOfEngine.SendActionGood) then begin
                  zPlugOfEngine.SendActionGood(Self);
                end else begin
                  SendSocket(nil, sSTATUS_GOOD + IntToStr(GetTickCount));
                end;
                if m_boTestSpeedMode then
                  SysMsg(format('速度异常 Ident: %d Time: %d', [ProcessMsg.wIdent, dwDelayTime]), c_Red, t_Hint);
              end else begin
                if m_boTestSpeedMode then
                  SysMsg(format('操作延迟 Ident: %d Time: %d', [ProcessMsg.wIdent, dwDelayTime]), c_Red, t_Hint);
                SendDelayMsg(Self, ProcessMsg.wIdent, ProcessMsg.wParam, ProcessMsg.nParam1, ProcessMsg.nParam2, ProcessMsg.nParam3, '', dwDelayTime);
                Result := False;
              end;
            end;
          end;
        end;
      end;
    CM_SPELL: begin
        if ClientSpellXY(ProcessMsg.wIdent, ProcessMsg.wParam, ProcessMsg.nParam1, ProcessMsg.nParam2, TBaseObject(ProcessMsg.nParam3), ProcessMsg.boLateDelivery, dwDelayTime) then begin
          m_dwActionTick := GetTickCount;
          if Assigned(zPlugOfEngine.SendActionGood) then begin
            zPlugOfEngine.SendActionGood(Self);
          end else begin
            SendSocket(nil, sSTATUS_GOOD + IntToStr(GetTickCount));
          end;
          Inc(n5F8);
        end else begin
          if dwDelayTime = 0 then begin
            if Assigned(zPlugOfEngine.SendActionFail) then begin
              zPlugOfEngine.SendActionFail(Self);
            end else begin
              SendSocket(nil, sSTATUS_FAIL + IntToStr(GetTickCount));
            end;
          end else begin
            nMsgCount := GetSpellMsgCount();
            if nMsgCount >= g_Config.nMaxSpellMsgCount then begin
              Inc(m_nOverSpeedCount);
              if m_nOverSpeedCount > g_Config.nOverSpeedKickCount then begin
                if g_Config.boKickOverSpeed then begin
                  SysMsg(g_sKickClientUserMsg {'请勿使用非法软件！！！'}, c_Red, t_Hint);
                  m_boEmergencyClose := True;
                  m_boPlayOffLine := False;
                end;
                if g_Config.boViewHackMessage then begin
                  //MainOutMessage('[魔法超速] ' + m_sCharName + ' Time: ' + IntToStr(dwDelayTime) + ' Count: '+ IntToStr(nMsgCount));
                  MainOutMessage(format(g_sSpellOverSpeed, [m_sCharName, dwDelayTime, nMsgCount]));
                end;
              end;
              //如果超速则发送攻击失败信息
              if Assigned(zPlugOfEngine.SendActionFail) then begin
                zPlugOfEngine.SendActionFail(Self);
              end else begin
                SendSocket(nil, sSTATUS_FAIL + IntToStr(GetTickCount));
              end;
            end else begin
              if (dwDelayTime > g_Config.dwDropOverSpeed) and (g_Config.btSpeedControlMode = 1) and m_boFilterAction then begin
                if Assigned(zPlugOfEngine.SendActionFail) then begin
                  zPlugOfEngine.SendActionFail(Self);
                end else begin
                  SendSocket(nil, sSTATUS_FAIL + IntToStr(GetTickCount));
                end;
                if m_boTestSpeedMode then
                  SysMsg(format('速度异常 Ident: %d Time: %d', [ProcessMsg.wIdent, dwDelayTime]), c_Red, t_Hint);
              end else begin
                if m_boTestSpeedMode then
                  SysMsg(format('操作延迟 Ident: %d Time: %d', [ProcessMsg.wIdent, dwDelayTime]), c_Red, t_Hint);
                SendDelayMsg(Self, ProcessMsg.wIdent, ProcessMsg.wParam, ProcessMsg.nParam1, ProcessMsg.nParam2, ProcessMsg.nParam3, '', dwDelayTime);
                Result := False;
              end;
            end;
          end;
        end;
      end;
    CM_SAY: begin
        if ProcessMsg.sMsg <> '' then begin
          ProcessUserLineMsg(ProcessMsg.sMsg);
        end;
      end;
    CM_PASSWORD: begin
        ProcessClientPassword(ProcessMsg);
      end;
    RM_WALK: begin //10002
        if Assigned(zPlugOfEngine.SendWalkMsg) then begin
          zPlugOfEngine.SendWalkMsg(Self, ProcessMsg.BaseObject, ProcessMsg.nParam1, ProcessMsg.nParam2, ProcessMsg.wParam);
        end else begin
          if TBaseObject(ProcessMsg.BaseObject) <> Self then begin
            m_DefMsg := MakeDefaultMsg(SM_WALK, Integer(ProcessMsg.BaseObject), ProcessMsg.nParam1, ProcessMsg.nParam2, MakeWord(ProcessMsg.wParam, TBaseObject(ProcessMsg.BaseObject).m_nLight));
            CharDesc.feature := TBaseObject(ProcessMsg.BaseObject).GetFeature(TBaseObject(ProcessMsg.BaseObject));
            CharDesc.Status := TBaseObject(ProcessMsg.BaseObject).m_nCharStatus;
            SendSocket(@m_DefMsg, EncodeBuffer(@CharDesc, SizeOf(TCharDesc)));
          end;
        end;
      end;
    RM_HORSERUN: begin //10003 004D860A
        if Assigned(zPlugOfEngine.SendHorseRunMsg) then begin
          zPlugOfEngine.SendHorseRunMsg(Self, ProcessMsg.BaseObject, ProcessMsg.nParam1, ProcessMsg.nParam2, ProcessMsg.wParam);
        end else begin
          if TBaseObject(ProcessMsg.BaseObject) <> Self then begin
            m_DefMsg := MakeDefaultMsg(SM_HORSERUN, Integer(ProcessMsg.BaseObject), ProcessMsg.nParam1, ProcessMsg.nParam2, MakeWord(ProcessMsg.wParam, TBaseObject(ProcessMsg.BaseObject).m_nLight));
            CharDesc.feature := TBaseObject(ProcessMsg.BaseObject).GetFeature(TBaseObject(ProcessMsg.BaseObject));
            CharDesc.Status := TBaseObject(ProcessMsg.BaseObject).m_nCharStatus;
            SendSocket(@m_DefMsg, EncodeBuffer(@CharDesc, SizeOf(TCharDesc)));
          end;
        end;
      end;
    RM_RUN: begin
        if Assigned(zPlugOfEngine.SendRunMsg) then begin
          zPlugOfEngine.SendRunMsg(Self, ProcessMsg.BaseObject, ProcessMsg.nParam1, ProcessMsg.nParam2, ProcessMsg.wParam);
        end else begin
          if TBaseObject(ProcessMsg.BaseObject) <> Self then begin
            m_DefMsg := MakeDefaultMsg(SM_RUN, Integer(ProcessMsg.BaseObject), ProcessMsg.nParam1, ProcessMsg.nParam2, MakeWord(ProcessMsg.wParam, TBaseObject(ProcessMsg.BaseObject).m_nLight));
            CharDesc.feature := TBaseObject(ProcessMsg.BaseObject).GetFeature(TBaseObject(ProcessMsg.BaseObject));
            CharDesc.Status := TBaseObject(ProcessMsg.BaseObject).m_nCharStatus;
            SendSocket(@m_DefMsg, EncodeBuffer(@CharDesc, SizeOf(TCharDesc)));
          end;
        end;
      end;
    RM_HIT: begin //10004 004D871D
        if TBaseObject(ProcessMsg.BaseObject) <> Self then begin
          m_DefMsg := MakeDefaultMsg(SM_HIT, Integer(ProcessMsg.BaseObject), ProcessMsg.nParam1, ProcessMsg.nParam2, ProcessMsg.wParam);
          SendSocket(@m_DefMsg, '');
        end;
      end;
    RM_HEAVYHIT: begin //004D88CD
        if TBaseObject(ProcessMsg.BaseObject) <> Self then begin
          m_DefMsg := MakeDefaultMsg(SM_HEAVYHIT, Integer(ProcessMsg.BaseObject), ProcessMsg.nParam1, ProcessMsg.nParam2, ProcessMsg.wParam);
          SendSocket(@m_DefMsg, ProcessMsg.sMsg);
        end;
      end;
    RM_BIGHIT: begin //004D893A
        if TBaseObject(ProcessMsg.BaseObject) <> Self then begin
          m_DefMsg := MakeDefaultMsg(SM_BIGHIT, Integer(ProcessMsg.BaseObject), ProcessMsg.nParam1, ProcessMsg.nParam2, ProcessMsg.wParam);
          SendSocket(@m_DefMsg, '');
        end;
      end;
    RM_SPELL: begin // 10007 004D8A12
        if TBaseObject(ProcessMsg.BaseObject) <> Self then begin
          m_DefMsg := MakeDefaultMsg(SM_SPELL, Integer(ProcessMsg.BaseObject), ProcessMsg.nParam1, ProcessMsg.nParam2, ProcessMsg.wParam);
          //m_DefMsg := MakeDefaultMsg(SM_SPELL, Integer(ProcessMsg.BaseObject), ProcessMsg.wParam, ProcessMsg.nParam1, ProcessMsg.nParam2);
          SendSocket(@m_DefMsg, IntToStr(ProcessMsg.nParam3));
        end;
      end;
    RM_SPELL2: begin //10008 004D8789
        if TBaseObject(ProcessMsg.BaseObject) <> Self then begin
          m_DefMsg := MakeDefaultMsg(SM_POWERHIT, Integer(ProcessMsg.BaseObject), ProcessMsg.nParam1, ProcessMsg.nParam2, ProcessMsg.wParam);
          SendSocket(@m_DefMsg, '');
        end;
      end;
    {
    RM_POWERHIT: begin

    end;
    }
    RM_MOVEFAIL: begin //10010 004D8289
        m_DefMsg := MakeDefaultMsg(SM_MOVEFAIL, Integer(Self), m_nCurrX, m_nCurrY, m_btDirection);
        CharDesc.feature := TBaseObject(ProcessMsg.BaseObject).GetFeatureToLong;
        CharDesc.Status := TBaseObject(ProcessMsg.BaseObject).m_nCharStatus;
        SendSocket(@m_DefMsg, EncodeBuffer(@CharDesc, SizeOf(CharDesc)));
      end;
    RM_LONGHIT: begin //10011 004D87F5
        if TBaseObject(ProcessMsg.BaseObject) <> Self then begin
          m_DefMsg := MakeDefaultMsg(SM_LONGHIT, Integer(ProcessMsg.BaseObject), ProcessMsg.nParam1, ProcessMsg.nParam2, ProcessMsg.wParam);
          SendSocket(@m_DefMsg, '');
        end;
      end;
    RM_WIDEHIT: begin //10012 004D8861
        if TBaseObject(ProcessMsg.BaseObject) <> Self then begin
          m_DefMsg := MakeDefaultMsg(SM_WIDEHIT, Integer(ProcessMsg.BaseObject), ProcessMsg.nParam1, ProcessMsg.nParam2, ProcessMsg.wParam);
          SendSocket(@m_DefMsg, '');
        end;
      end;
    RM_FIREHIT: begin //10014 004D89A6
        if TBaseObject(ProcessMsg.BaseObject) <> Self then begin
          m_DefMsg := MakeDefaultMsg(SM_FIREHIT, Integer(ProcessMsg.BaseObject), ProcessMsg.nParam1, ProcessMsg.nParam2, ProcessMsg.wParam);
          SendSocket(@m_DefMsg, '');
        end;
      end;
    RM_CRSHIT: begin //10014 004D89A6
        if TBaseObject(ProcessMsg.BaseObject) <> Self then begin
          m_DefMsg := MakeDefaultMsg(SM_CRSHIT, Integer(ProcessMsg.BaseObject), ProcessMsg.nParam1, ProcessMsg.nParam2, ProcessMsg.wParam);
          SendSocket(@m_DefMsg, '');
        end;
      end;
    RM_41: begin //10014 004D89A6
        if TBaseObject(ProcessMsg.BaseObject) <> Self then begin
          m_DefMsg := MakeDefaultMsg(SM_41, Integer(ProcessMsg.BaseObject), ProcessMsg.nParam1, ProcessMsg.nParam2, ProcessMsg.wParam);
          SendSocket(@m_DefMsg, '');
        end;
      end;
    RM_42: begin //10014 004D89A6
        if TBaseObject(ProcessMsg.BaseObject) <> Self then begin
          m_DefMsg := MakeDefaultMsg(SM_42, Integer(ProcessMsg.BaseObject), ProcessMsg.nParam1, ProcessMsg.nParam2, ProcessMsg.wParam);
          SendSocket(@m_DefMsg, '');
        end;
      end;
    RM_43: begin //10014 004D89A6
        if TBaseObject(ProcessMsg.BaseObject) <> Self then begin
          m_DefMsg := MakeDefaultMsg(SM_43, Integer(ProcessMsg.BaseObject), ProcessMsg.nParam1, ProcessMsg.nParam2, ProcessMsg.wParam);
          SendSocket(@m_DefMsg, '');
        end;
      end;
    RM_MONMOVE: begin //擒拿手
        if TBaseObject(ProcessMsg.BaseObject) <> Self then begin
          m_DefMsg := MakeDefaultMsg(SM_SITDOWN, Integer(ProcessMsg.BaseObject), ProcessMsg.nParam1, ProcessMsg.nParam2, ProcessMsg.wParam);
          SendSocket(@m_DefMsg, '');
        end;
      end;

    RM_TURN,
      RM_PUSH,
      RM_RUSH,
      RM_RUSHKUNG: begin //004D831D
        if (TBaseObject(ProcessMsg.BaseObject) <> Self) or (ProcessMsg.wIdent = RM_PUSH) or (ProcessMsg.wIdent = RM_RUSH) or (ProcessMsg.wIdent = RM_RUSHKUNG) then begin
          case ProcessMsg.wIdent of
            RM_PUSH: //004D835F
              m_DefMsg := MakeDefaultMsg(SM_BACKSTEP, Integer(ProcessMsg.BaseObject), ProcessMsg.nParam1 {x}, ProcessMsg.nParam2 {y}, MakeWord(ProcessMsg.wParam {dir}, TBaseObject(ProcessMsg.BaseObject).m_nLight {light}));
            RM_RUSH: //004D83B9
              m_DefMsg := MakeDefaultMsg(SM_RUSH, Integer(ProcessMsg.BaseObject), ProcessMsg.nParam1, ProcessMsg.nParam2, MakeWord(ProcessMsg.wParam, TBaseObject(ProcessMsg.BaseObject).m_nLight));
            RM_RUSHKUNG: //004D8413
              m_DefMsg := MakeDefaultMsg(SM_RUSHKUNG, Integer(ProcessMsg.BaseObject), ProcessMsg.nParam1, ProcessMsg.nParam2, MakeWord(ProcessMsg.wParam, TBaseObject(ProcessMsg.BaseObject).m_nLight));
            else begin //004D846A
                m_DefMsg := MakeDefaultMsg(SM_TURN, Integer(ProcessMsg.BaseObject), ProcessMsg.nParam1, ProcessMsg.nParam2, MakeWord(ProcessMsg.wParam, TBaseObject(ProcessMsg.BaseObject).m_nLight));
              end;
          end;
          CharDesc.feature := TBaseObject(ProcessMsg.BaseObject).GetFeature(TBaseObject(ProcessMsg.BaseObject));
          CharDesc.Status := TBaseObject(ProcessMsg.BaseObject).m_nCharStatus;
          s1C := EncodeBuffer(@CharDesc, SizeOf(CharDesc));
          nObjCount := GetCharColor(TBaseObject(ProcessMsg.BaseObject));
          if ProcessMsg.sMsg <> '' then
            s1C := s1C + (EncodeString(ProcessMsg.sMsg + '/' + IntToStr(nObjCount)));
          SendSocket(@m_DefMsg, s1C);
          if ProcessMsg.wIdent = RM_TURN then begin
            nObjCount := TBaseObject(ProcessMsg.BaseObject).GetFeatureToLong();
            SendDefMessage(SM_FEATURECHANGED,
              Integer(ProcessMsg.BaseObject),
              LoWord(nObjCount),
              HiWord(nObjCount),
              TBaseObject(ProcessMsg.BaseObject).GetFeatureEx,
              '');
          end;
        end;
      end;
    RM_STRUCK,
      RM_STRUCK_MAG: begin //10020 004D8B28
        if ProcessMsg.wParam {nPower} > 0 then begin
          if Assigned(zPlugOfEngine.SendUserStruckMsg) then begin
            try
              zPlugOfEngine.SendUserStruckMsg(Self,
                ProcessMsg.BaseObject,
                TBaseObject(ProcessMsg.nParam3),
                ProcessMsg.wIdent);
            except
            end;
          end else begin
            if TBaseObject(ProcessMsg.BaseObject) = Self then begin
              if TBaseObject(ProcessMsg.nParam3) {AttackBaseObject} <> nil then begin
                if TBaseObject(ProcessMsg.nParam3).m_btRaceServer = RC_PLAYOBJECT then begin
                  SetPKFlag(TBaseObject(ProcessMsg.nParam3) {AttackBaseObject});
                end;
                SetLastHiter(TBaseObject(ProcessMsg.nParam3) {AttackBaseObject});
                {
                //反复活
                if TBaseObject(ProcessMsg.nParam3).m_boUnRevival then
                  m_boRevival:=False;
                }
              end; //004D8B67
              if PKLevel >= 2 then m_dw5D4 := GetTickCount();
              //if UserCastle.IsMasterGuild(TGuild(m_MyGuild)) and (TBaseObject(ProcessMsg.nParam3) <> nil) then begin
              if (g_CastleManager.IsCastleMember(Self) <> nil) and (TBaseObject(ProcessMsg.nParam3) <> nil) then begin
                TBaseObject(ProcessMsg.nParam3).bo2B0 := True;
                TBaseObject(ProcessMsg.nParam3).m_dw2B4Tick := GetTickCount();
              end;
              m_nHealthTick := 0;
              m_nSpellTick := 0;
              Dec(m_nPerHealth);
              Dec(m_nPerSpell);
              m_dwStruckTick := GetTickCount(); //09/10
            end; //4D8BE1
            if TBaseObject(ProcessMsg.BaseObject) <> nil then begin
              if ((TBaseObject(ProcessMsg.BaseObject) = Self) and (g_Config.boDisableSelfStruck)) or ((TBaseObject(ProcessMsg.BaseObject).m_btRaceServer = RC_PLAYOBJECT) and g_Config.boDisableStruck) then begin
                TBaseObject(ProcessMsg.BaseObject).SendRefMsg(RM_HEALTHSPELLCHANGED, 0, 0, 0, 0, '');
              end else begin
                m_DefMsg := MakeDefaultMsg(SM_STRUCK,
                  Integer(ProcessMsg.BaseObject),
                  TBaseObject(ProcessMsg.BaseObject).m_WAbil.HP,
                  TBaseObject(ProcessMsg.BaseObject).m_WAbil.MaxHP,
                  ProcessMsg.wParam);
                MessageBodyWL.lParam1 := TBaseObject(ProcessMsg.BaseObject).GetFeature(Self);
                MessageBodyWL.lParam2 := TBaseObject(ProcessMsg.BaseObject).m_nCharStatus;
                MessageBodyWL.lTag1 := ProcessMsg.nParam3;
                if ProcessMsg.wIdent = RM_STRUCK_MAG then MessageBodyWL.lTag2 := 1
                else MessageBodyWL.lTag2 := 0;
                SendSocket(@m_DefMsg, EncodeBuffer(@MessageBodyWL, SizeOf(TMessageBodyWL)));
              end;
            end;
          end;
        end;
      end;
    RM_DEATH: begin
        if Assigned(zPlugOfEngine.SendDeathMsg) then begin
          try
            zPlugOfEngine.SendDeathMsg(Self,
              ProcessMsg.BaseObject,
              ProcessMsg.nParam1,
              ProcessMsg.nParam2,
              ProcessMsg.wParam,
              ProcessMsg.nParam3);
          except
          end;
        end else begin
          if ProcessMsg.nParam3 = 1 then begin
            m_DefMsg := MakeDefaultMsg(SM_NOWDEATH,
              Integer(ProcessMsg.BaseObject),
              ProcessMsg.nParam1,
              ProcessMsg.nParam2,
              ProcessMsg.wParam);
          end else begin
            m_DefMsg := MakeDefaultMsg(SM_DEATH,
              Integer(ProcessMsg.BaseObject),
              ProcessMsg.nParam1,
              ProcessMsg.nParam2,
              ProcessMsg.wParam);
          end;
          CharDesc.feature := TBaseObject(ProcessMsg.BaseObject).GetFeature(Self);
          CharDesc.Status := TBaseObject(ProcessMsg.BaseObject).m_nCharStatus;
          SendSocket(@m_DefMsg, EncodeBuffer(@CharDesc, SizeOf(TCharDesc)));
        end;
      end;
    RM_DISAPPEAR: begin //10022 004D915C
        m_DefMsg := MakeDefaultMsg(SM_DISAPPEAR,
          Integer(ProcessMsg.BaseObject),
          0, 0, 0);
        SendSocket(@m_DefMsg, '');
      end;
    RM_SKELETON: begin //10024 004D8D7B
        if Assigned(zPlugOfEngine.SendSkeletonMsg) then begin
          try
            zPlugOfEngine.SendSkeletonMsg(Self,
              ProcessMsg.BaseObject,
              ProcessMsg.nParam1,
              ProcessMsg.nParam2,
              ProcessMsg.wParam);
          except
          end;
        end else begin
          m_DefMsg := MakeDefaultMsg(SM_SKELETON,
            Integer(ProcessMsg.BaseObject),
            ProcessMsg.nParam1,
            ProcessMsg.nParam2,
            ProcessMsg.wParam);
          CharDesc.feature := TBaseObject(ProcessMsg.BaseObject).GetFeature(Self);
          CharDesc.Status := TBaseObject(ProcessMsg.BaseObject).m_nCharStatus;
          SendSocket(@m_DefMsg, EncodeBuffer(@CharDesc, SizeOf(TCharDesc)));
        end;
      end;
    RM_USERNAME: begin
        m_DefMsg := MakeDefaultMsg(SM_USERNAME,
          Integer(ProcessMsg.BaseObject),
          GetCharColor(TBaseObject(ProcessMsg.BaseObject)), 0, 0);
        SendSocket(@m_DefMsg, EncodeString(ProcessMsg.sMsg));
      end;
    RM_WINEXP: begin
        m_DefMsg := MakeDefaultMsg(SM_WINEXP, m_Abil.Exp, LoWord(ProcessMsg.nParam1), HiWord(ProcessMsg.nParam1), 0);
        SendSocket(@m_DefMsg, '');
      end;
    RM_LEVELUP: begin
        if Assigned(zPlugOfEngine.SendUserLevelUpMsg) then begin
          zPlugOfEngine.SendUserLevelUpMsg(Self);
        end else begin
          m_DefMsg := MakeDefaultMsg(SM_LEVELUP, m_Abil.Exp, m_Abil.Level, 0, 0);
          SendSocket(@m_DefMsg, '');
          m_DefMsg := MakeDefaultMsg(SM_ABILITY, m_nGold, MakeWord(m_btJob, 99), LoWord(m_nGameGold), HiWord(m_nGameGold));
          //0806 增加
          if (m_nSoftVersionDateEx = 0) and (m_dwClientTick = 0) then begin
            GetOldAbil(OAbility);
            SendSocket(@m_DefMsg, EncodeBuffer(@OAbility, SizeOf(TOAbility)));
          end else begin
            SendSocket(@m_DefMsg, EncodeBuffer(@m_WAbil, SizeOf(TAbility)));
          end;
          //SendSocket(@m_DefMsg,EncodeBuffer(@m_WAbil,SizeOf(TAbility)));
          SendDefMessage(SM_SUBABILITY,
            MakeLong(MakeWord(m_nAntiMagic, 0), 0),
            MakeWord(m_btHitPoint, m_btSpeedPoint),
            MakeWord(m_btAntiPoison, m_nPoisonRecover),
            MakeWord(m_nHealthRecover, m_nSpellRecover),
            '');
        end;
      end;
    RM_CHANGENAMECOLOR: begin //10046 004D9555
        SendDefMessage(SM_CHANGENAMECOLOR,
          Integer(ProcessMsg.BaseObject),
          GetCharColor(TBaseObject(ProcessMsg.BaseObject)),
          0,
          0,
          '');
      end;
    RM_LOGON: begin //10050
        if m_PEnvir.m_boDARK then nObjCount := 1
        else begin
          case m_nBright of
            1: nObjCount := 0;
            3: nObjCount := 1;
            else nObjCount := 1;
          end;
        end;
        if m_PEnvir.m_boDAY then nObjCount := 0;
        m_DefMsg := MakeDefaultMsg(SM_NEWMAP, Integer(Self), m_nCurrX, m_nCurrY, nObjCount);
        SendSocket(@m_DefMsg, EncodeString(g_MapManager.GetMainMap(m_PEnvir)));
        SendMsg(Self, RM_CHANGELIGHT, 0, 0, 0, 0, '');
        SendLogon();
        //SendServerConfig();
        ClientQueryUserName(Self, m_nCurrX, m_nCurrY);
        RefUserState();
        SendMapDescription();
        SendGoldInfo(True);
        SendDefMessage(SM_GAMEGOLDNAME, m_nGameGold, LoWord(m_nGamePoint), HiWord(m_nGamePoint), 0, g_Config.sGameGoldName + #13 + g_Config.sGamePointName);
        m_DefMsg := MakeDefaultMsg(SM_VERSION_FAIL, g_Config.nClientFile1_CRC, LoWord(g_Config.nClientFile2_CRC), HiWord(g_Config.nClientFile2_CRC), 0);
        SendSocket(@m_DefMsg, EncodeBuffer(@g_Config.nClientFile3_CRC, SizeOf(Integer)));
      end;
    RM_HEAR,
      RM_WHISPER,
      RM_CRY,
      RM_SYSMESSAGE,
      RM_GROUPMESSAGE,
      RM_SYSMESSAGE2,
      RM_GUILDMESSAGE,
      RM_SYSMESSAGE3,
      RM_MERCHANTSAY: begin
        {
        case ProcessMsg.wIdent of    //004D97B3
          RM_HEAR: m_DefMsg:=MakeDefaultMsg(SM_HEAR,Integer(ProcessMsg.BaseObject),MakeWord($0,$FF),0,1);//10030
//            RM_WHISPER: m_DefMsg:=MakeDefaultMsg(SM_WHISPER,Integer(ProcessMsg.BaseObject),MakeWord($FC,$FF),0,1);//10031
          RM_WHISPER: m_DefMsg:=MakeDefaultMsg(SM_WHISPER,Integer(ProcessMsg.BaseObject),MakeWord($FF,$38),0,1);//10031
          RM_CRY: m_DefMsg:=MakeDefaultMsg(SM_HEAR,Integer(ProcessMsg.BaseObject),MakeWord($0,$97),0,1);//10032
          RM_SYSMESSAGE: m_DefMsg:=MakeDefaultMsg(SM_SYSMESSAGE,Integer(ProcessMsg.BaseObject),MakeWord($FF,$38),0,1);//10100 红色
          RM_GROUPMESSAGE: m_DefMsg:=MakeDefaultMsg(SM_SYSMESSAGE,Integer(ProcessMsg.BaseObject),MakeWord($C4,$FF),0,1);//10102
          RM_SYSMESSAGE2: m_DefMsg:=MakeDefaultMsg(SM_SYSMESSAGE,Integer(ProcessMsg.BaseObject),MakeWord($DB,$FF),0,1);//10103
          RM_GUILDMESSAGE: m_DefMsg:=MakeDefaultMsg(SM_GUILDMESSAGE,Integer(ProcessMsg.BaseObject),MakeWord($DB,$FF),0,1); //10104
          RM_SYSMESSAGE3: m_DefMsg:=MakeDefaultMsg(SM_GUILDMESSAGE,Integer(ProcessMsg.BaseObject),MakeWord($FF,$FC),0,1);//10105
          RM_MERCHANTSAY: m_DefMsg:=MakeDefaultMsg(SM_MERCHANTSAY,Integer(ProcessMsg.BaseObject),0,0,1);//10126
        end;
        }
        case ProcessMsg.wIdent of //004D97B3
          RM_HEAR: m_DefMsg := MakeDefaultMsg(SM_HEAR, Integer(ProcessMsg.BaseObject), MakeWord(ProcessMsg.nParam1, ProcessMsg.nParam2), 0, 1); //10030
          RM_WHISPER: m_DefMsg := MakeDefaultMsg(SM_WHISPER, Integer(ProcessMsg.BaseObject), MakeWord(ProcessMsg.nParam1, ProcessMsg.nParam2), 0, 1); //10031
          RM_CRY: m_DefMsg := MakeDefaultMsg(SM_HEAR, Integer(ProcessMsg.BaseObject), MakeWord(ProcessMsg.nParam1, ProcessMsg.nParam2), 0, 1); //10032
          RM_SYSMESSAGE: m_DefMsg := MakeDefaultMsg(SM_SYSMESSAGE, Integer(ProcessMsg.BaseObject), MakeWord(ProcessMsg.nParam1, ProcessMsg.nParam2), 0, 1); //10100 红色

          //RM_SYSMESSAGE2: m_DefMsg:=MakeDefaultMsg(SM_SYSMESSAGE,Integer(ProcessMsg.BaseObject),MakeWord($DB,$FF),0,1);//10103
          //RM_SYSMESSAGE3: m_DefMsg:=MakeDefaultMsg(SM_GUILDMESSAGE,Integer(ProcessMsg.BaseObject),MakeWord($FF,$FC),0,1);//10105

          RM_GROUPMESSAGE: m_DefMsg := MakeDefaultMsg(SM_SYSMESSAGE, Integer(ProcessMsg.BaseObject), MakeWord(ProcessMsg.nParam1, ProcessMsg.nParam2), 0, 1); //10102
          RM_GUILDMESSAGE: m_DefMsg := MakeDefaultMsg(SM_GUILDMESSAGE, Integer(ProcessMsg.BaseObject), MakeWord(ProcessMsg.nParam1, ProcessMsg.nParam2), 0, 1); //10104
          RM_MERCHANTSAY: m_DefMsg := MakeDefaultMsg(SM_MERCHANTSAY, Integer(ProcessMsg.BaseObject), MakeWord(ProcessMsg.nParam1, ProcessMsg.nParam2), 0, 1); //10126
        end;
        SendSocket(@m_DefMsg, EncodeString(ProcessMsg.sMsg));
      end;
    {
    RM_ABILITY: begin //10051
      m_DefMsg:=MakeDefaultMsg(SM_ABILITY,
                             m_nGold,
                             m_btJob,
                             0,
                             0);
      SendSocket(@m_DefMsg,EncodeBuffer(@m_WAbil,SizeOf(TAbility)));
    end;
    }
    RM_ABILITY: begin
        if Assigned(zPlugOfEngine.SendUserAbilieyMsg) then begin
          zPlugOfEngine.SendUserAbilieyMsg(Self);
        end else begin
          m_DefMsg := MakeDefaultMsg(SM_ABILITY,
            m_nGold,
            MakeWord(m_btJob, 99),
            LoWord(m_nGameGold),
            HiWord(m_nGameGold));
          if (m_nSoftVersionDateEx = 0) and (m_dwClientTick = 0) then begin
            GetOldAbil(OAbility);
            SendSocket(@m_DefMsg, EncodeBuffer(@OAbility, SizeOf(TOAbility)));
            if g_Config.boOldClientShowHiLevel and (m_Abil.Level > 255) then begin
              SysMsg(g_sClientVersionTooOld {'由于您使用的客户端版本太老了，无法正确显示人物信息！！！'}, c_Red, t_Hint);
              SysMsg('当前等级: ' + IntToStr(m_Abil.Level), c_Green, t_Hint);
              SysMsg('当前生命值: ' + IntToStr(m_WAbil.HP) + '-' + IntToStr(m_WAbil.MaxHP), c_Blue, t_Hint);
              SysMsg('当前魔法值: ' + IntToStr(m_WAbil.MP) + '-' + IntToStr(m_WAbil.MaxMP), c_Red, t_Hint);
              SysMsg('当前防御力: ' + IntToStr(LoWord(m_WAbil.AC)) + '-' + IntToStr(HiWord(m_WAbil.AC)), c_Green, t_Hint);
              SysMsg('当前魔防力: ' + IntToStr(LoWord(m_WAbil.MAC)) + '-' + IntToStr(HiWord(m_WAbil.MAC)), c_Blue, t_Hint);
              SysMsg('当前攻击力: ' + IntToStr(LoWord(m_WAbil.DC)) + '-' + IntToStr(HiWord(m_WAbil.DC)), c_Red, t_Hint);
              SysMsg('当前魔法力: ' + IntToStr(LoWord(m_WAbil.MC)) + '-' + IntToStr(HiWord(m_WAbil.MC)), c_Green, t_Hint);
              SysMsg('当前道术值: ' + IntToStr(LoWord(m_WAbil.SC)) + '-' + IntToStr(HiWord(m_WAbil.SC)), c_Blue, t_Hint);
            end;
          end else begin
            SendSocket(@m_DefMsg, EncodeBuffer(@m_WAbil, SizeOf(TAbility)));
          end;
        end;
      end;
    RM_HEALTHSPELLCHANGED: begin //10052
        m_DefMsg := MakeDefaultMsg(SM_HEALTHSPELLCHANGED,
          Integer(ProcessMsg.BaseObject),
          TBaseObject(ProcessMsg.BaseObject).m_WAbil.HP,
          TBaseObject(ProcessMsg.BaseObject).m_WAbil.MP,
          TBaseObject(ProcessMsg.BaseObject).m_WAbil.MaxHP);
        SendSocket(@m_DefMsg, '');
      end;
    RM_DAYCHANGING: begin //10053
        if m_PEnvir.m_boDARK then nObjCount := 1
        else begin
          case m_nBright of
            1: nObjCount := 0;
            3: nObjCount := 1;
            else nObjCount := 1;
          end;
        end;
        if m_PEnvir.m_boDAY then nObjCount := 0;
        m_DefMsg := MakeDefaultMsg(SM_DAYCHANGING, 0, m_nBright, nObjCount, 0);
        SendSocket(@m_DefMsg, '');
      end;
    RM_ITEMSHOW: begin //10110 004D9D01
        SendDefMessage(SM_ITEMSHOW,
          ProcessMsg.nParam1,
          ProcessMsg.nParam2,
          ProcessMsg.nParam3,
          ProcessMsg.wParam,
          ProcessMsg.sMsg);
      end;
    RM_ITEMHIDE: begin //10111 004D9D27
        SendDefMessage(SM_ITEMHIDE,
          ProcessMsg.nParam1,
          ProcessMsg.nParam2,
          ProcessMsg.nParam3,
          0,
          '');
      end;
    RM_DOOROPEN: begin //10112 004D9D6A
        SendDefMessage(SM_OPENDOOR_OK,
          0,
          ProcessMsg.nParam1, {x}
          ProcessMsg.nParam2, {y}
          0,
          '');
      end;
    RM_DOORCLOSE: begin //10113 004D9D8A
        SendDefMessage(SM_CLOSEDOOR,
          0,
          ProcessMsg.nParam1,
          ProcessMsg.nParam2,
          0,
          '');
      end;
    RM_SENDUSEITEMS: SendUseitems();
    RM_WEIGHTCHANGED: begin //10115 004D9DC4
        SendDefMessage(SM_WEIGHTCHANGED,
          m_WAbil.Weight,
          m_WAbil.WearWeight,
          m_WAbil.HandWeight,
          0,
          '');
      end;
    RM_FEATURECHANGED: begin //10116 004D9E1A
        SendDefMessage(SM_FEATURECHANGED,
          Integer(ProcessMsg.BaseObject),
          LoWord(ProcessMsg.nParam1),
          HiWord(ProcessMsg.nParam1),
          ProcessMsg.wParam,
          '');
      end;
    RM_CLEAROBJECTS: begin //10117 004D9E71
        SendDefMessage(SM_CLEAROBJECTS,
          0,
          0,
          0,
          0,
          '');
      end;

    RM_CHANGEMAP: begin
        if m_PEnvir.m_boDARK then nObjCount := 1
        else begin
          case m_nBright of
            1: nObjCount := 0;
            3: nObjCount := 1;
            else nObjCount := 1;
          end;
        end;
        if m_PEnvir.m_boDAY then nObjCount := 0;
        SendDefMessage(SM_CHANGEMAP, Integer(Self), m_nCurrX, m_nCurrY, nObjCount, ProcessMsg.sMsg);
        RefUserState();
        SendMapDescription();
        //SendServerConfig();
      end;
    RM_BUTCH: begin //10119 004D86B1
        if ProcessMsg.BaseObject <> nil then begin
          m_DefMsg := MakeDefaultMsg(SM_BUTCH,
            Integer(ProcessMsg.BaseObject),
            ProcessMsg.nParam1,
            ProcessMsg.nParam2,
            ProcessMsg.wParam);
          SendSocket(@m_DefMsg, '');
        end;
      end;
    RM_MAGICFIRE: begin //10120 004D8A90
        m_DefMsg := MakeDefaultMsg(SM_MAGICFIRE,
          Integer(ProcessMsg.BaseObject),
          LoWord(ProcessMsg.nParam2),
          HiWord(ProcessMsg.nParam2),
          ProcessMsg.nParam1);
        SendSocket(@m_DefMsg, EncodeBuffer(@ProcessMsg.nParam3, SizeOf(Integer)));
      end;
    RM_MAGICFIREFAIL: begin //10121
        SendDefMessage(SM_MAGICFIRE_FAIL, Integer(ProcessMsg.BaseObject), 0, 0, 0, '');
      end;
    RM_SENDMYMAGIC: SendUseMagic; //10122
    RM_MAGIC_LVEXP: begin //10123 004D9E8D
        SendDefMessage(SM_MAGIC_LVEXP,
          ProcessMsg.nParam1,
          ProcessMsg.nParam2,
          LoWord(ProcessMsg.nParam3),
          HiWord(ProcessMsg.nParam3),
          '');
      end;
    RM_DURACHANGE: begin //10125 004D9EB9
        SendDefMessage(SM_DURACHANGE,
          ProcessMsg.nParam1,
          ProcessMsg.wParam,
          LoWord(ProcessMsg.nParam2),
          HiWord(ProcessMsg.nParam2),
          '');
      end;
    RM_MERCHANTDLGCLOSE: begin //10127 004D9ADF
        SendDefMessage(SM_MERCHANTDLGCLOSE,
          ProcessMsg.nParam1,
          0,
          0,
          0,
          '');
      end;
    RM_SENDGOODSLIST: begin
        if Assigned(zPlugOfEngine.SendGoodsList) then begin
          zPlugOfEngine.SendGoodsList(Self,
            ProcessMsg.nParam1,
            ProcessMsg.nParam2,
            ProcessMsg.nParam3,
            PChar(ProcessMsg.sMsg));
        end else begin
          SendDefMessage(SM_SENDGOODSLIST,
            ProcessMsg.nParam1,
            ProcessMsg.nParam2,
            0,
            0,
            ProcessMsg.sMsg);
        end;
      end;
    RM_SENDUSERSELL: begin //10129 004D9B1D
        SendDefMessage(SM_SENDUSERSELL,
          ProcessMsg.nParam1,
          ProcessMsg.nParam2,
          0,
          0,
          ProcessMsg.sMsg);
      end;
    RM_SENDBUYPRICE: begin //10130  004D9BAB
        SendDefMessage(SM_SENDBUYPRICE,
          ProcessMsg.nParam1,
          0,
          0,
          0,
          '');
      end;
    RM_USERSELLITEM_OK: begin //10131  004D9BC8
        SendDefMessage(SM_USERSELLITEM_OK,
          ProcessMsg.nParam1,
          0,
          0,
          0,
          '');
      end;
    RM_USERSELLITEM_FAIL: begin //10132  004D9BC8
        SendDefMessage(SM_USERSELLITEM_FAIL,
          ProcessMsg.nParam1,
          0,
          0,
          0,
          '');
      end;
    RM_BUYITEM_SUCCESS: begin //10133  004D9C02
        SendDefMessage(SM_BUYITEM_SUCCESS,
          ProcessMsg.nParam1,
          LoWord(ProcessMsg.nParam2),
          HiWord(ProcessMsg.nParam2),
          0,
          '');
      end;
    RM_BUYITEM_FAIL: begin //10134  004D9C2C
        SendDefMessage(SM_BUYITEM_FAIL,
          ProcessMsg.nParam1,
          0,
          0,
          0,
          '');
      end;
    RM_SENDDETAILGOODSLIST: begin //10135  004D9C83
        SendDefMessage(SM_SENDDETAILGOODSLIST,
          ProcessMsg.nParam1,
          ProcessMsg.nParam2,
          ProcessMsg.nParam3,
          0,
          ProcessMsg.sMsg);
      end;
    //////////////////////////////////////拍卖//////////////////////////////////////
    RM_SENDSELLOFFGOODSLIST: begin //  拍卖
        SendDefMessage(SM_SENDSELLOFFGOODSLIST,
          ProcessMsg.nParam1,
          ProcessMsg.nParam2,
          ProcessMsg.nParam3,
          0,
          ProcessMsg.sMsg);
      end;

    RM_SENDUSERSELLOFFITEM: begin
        SendDefMessage(SM_SENDUSERSELLOFFITEM,
          ProcessMsg.nParam1,
          ProcessMsg.nParam2,
          0,
          0,
          ProcessMsg.sMsg);
      end;

    RM_SENDUSERSELLOFFITEM_OK: begin
        SendDefMessage(SM_SENDUSERSELLOFFITEM_OK,
          ProcessMsg.nParam1,
          ProcessMsg.nParam2,
          ProcessMsg.nParam3,
          0,
          '');
      end;
    RM_SENDUSERSELLOFFITEM_FAIL: begin
        SendDefMessage(SM_SENDUSERSELLOFFITEM_FAIL,
          ProcessMsg.nParam1,
          ProcessMsg.nParam2,
          ProcessMsg.nParam3,
          0,
          '');
      end;
    RM_SENDSELLOFFITEMLIST: begin
        SendDefMessage(CM_SENDSELLOFFITEMLIST,
          ProcessMsg.nParam1,
          ProcessMsg.nParam2,
          ProcessMsg.nParam3,
          0,
          ProcessMsg.sMsg);
      end;

    RM_SENDBUYSELLOFFITEM_OK: begin //购买拍卖物品成功
        SendDefMessage(SM_SENDBUYSELLOFFITEM_OK,
          ProcessMsg.nParam1,
          LoWord(ProcessMsg.nParam2),
          HiWord(ProcessMsg.nParam2),
          0,
          '');
      end;
    RM_SENDBUYSELLOFFITEM_FAIL: begin //购买拍卖物品失败
        SendDefMessage(SM_SENDBUYSELLOFFITEM_FAIL,
          ProcessMsg.nParam1,
          0,
          0,
          0,
          '');
      end;
    //////////////////////////////////////拍卖//////////////////////////////////////
    RM_GOLDCHANGED: begin //10136  004D9DFA
        SendDefMessage(SM_GOLDCHANGED,
          m_nGold,
          LoWord(m_nGameGold),
          HiWord(m_nGameGold),
          0,
          '');
      end;
    RM_GAMEGOLDCHANGED: begin
        SendGoldInfo(False);
        {
        SendDefMessage(SM_GAMEGOLDNAME,
                       m_nGameGold,
                       LoWord(m_nGamePoint),
                       HiWord(m_nGamePoint),
                       0,
                       '');
        }
      end;
    RM_CHANGELIGHT: begin //10137  004D9EE6
        SendDefMessage(SM_CHANGELIGHT,
          Integer(ProcessMsg.BaseObject),
          TBaseObject(ProcessMsg.BaseObject).m_nLight,
          g_Config.nClientKey,
          0,
          '');
      end;
    RM_LAMPCHANGEDURA: begin //10138 004D9F0B
        SendDefMessage(SM_LAMPCHANGEDURA,
          ProcessMsg.nParam1,
          0,
          0,
          0,
          '');
      end;
    RM_CHARSTATUSCHANGED: begin //10139 004D9E44
        SendDefMessage(SM_CHARSTATUSCHANGED,
          Integer(ProcessMsg.BaseObject),
          LoWord(ProcessMsg.nParam1),
          HiWord(ProcessMsg.nParam1),
          ProcessMsg.wParam,
          '');
      end;
    RM_GROUPCANCEL: begin //10140 004D9F28
        SendDefMessage(SM_GROUPCANCEL,
          ProcessMsg.nParam1,
          0,
          0,
          0,
          '');
      end;
    RM_SENDUSERREPAIR,
      RM_SENDUSERSREPAIR: begin //10141 004D9B3C
        SendDefMessage(SM_SENDUSERREPAIR,
          ProcessMsg.nParam1,
          ProcessMsg.nParam2,
          0,
          0,
          '');
      end;
    RM_USERREPAIRITEM_OK: begin //10143  004D9CA6
        SendDefMessage(SM_USERREPAIRITEM_OK,
          ProcessMsg.nParam1,
          ProcessMsg.nParam2,
          ProcessMsg.nParam3,
          0,
          '');
      end;
    RM_SENDREPAIRCOST: begin //10142  004D9CE4
        SendDefMessage(SM_SENDREPAIRCOST,
          ProcessMsg.nParam1,
          0,
          0,
          0,
          '');
      end;
    RM_USERREPAIRITEM_FAIL: begin //10144  004D9CC7
        SendDefMessage(SM_USERREPAIRITEM_FAIL,
          ProcessMsg.nParam1,
          0,
          0,
          0,
          '');
      end;
    RM_USERSTORAGEITEM: begin //10146  004D9B5B
        SendDefMessage(SM_SENDUSERSTORAGEITEM,
          ProcessMsg.nParam1,
          ProcessMsg.nParam2,
          0,
          0,
          '');
      end;
    RM_USERGETBACKITEM: begin //10147  004D9B7A  SM_SAVEITEMLIST
        SendSaveItemList(ProcessMsg.nParam1);
      end;
    RM_USERBIGGETBACKITEM: begin
        SendSaveBigStorageItemList(ProcessMsg.nParam1, ProcessMsg.wParam);
      end;
    RM_SENDDELITEMLIST: begin //10148  004D9D48  //SM_DELITEMS
        SendDelItemList(TStringList(ProcessMsg.nParam1));
        TStringList(ProcessMsg.nParam1).Free;
      end;
    RM_USERMAKEDRUGITEMLIST: begin //10149  004D9B8A
        SendDefMessage(SM_SENDUSERMAKEDRUGITEMLIST,
          ProcessMsg.nParam1,
          ProcessMsg.nParam2,
          0,
          0,
          ProcessMsg.sMsg);
      end;
    RM_MAKEDRUG_SUCCESS: begin //10150 004D9C49
        SendDefMessage(SM_MAKEDRUG_SUCCESS,
          ProcessMsg.nParam1,
          0,
          0,
          0,
          '');
      end;
    RM_MAKEDRUG_FAIL: begin //10151 004D9C66
        SendDefMessage(SM_MAKEDRUG_FAIL,
          ProcessMsg.nParam1,
          0,
          0,
          0,
          '');
      end;
    RM_ALIVE: begin
        if Assigned(zPlugOfEngine.SendAliveMsg) then begin
          zPlugOfEngine.SendAliveMsg(Self,
            ProcessMsg.BaseObject,
            ProcessMsg.nParam1,
            ProcessMsg.nParam2,
            ProcessMsg.wParam);
        end else begin
          m_DefMsg := MakeDefaultMsg(SM_ALIVE,
            Integer(ProcessMsg.BaseObject),
            ProcessMsg.nParam1,
            ProcessMsg.nParam2,
            ProcessMsg.wParam);
          CharDesc.feature := TBaseObject(ProcessMsg.BaseObject).GetFeature(Self);
          CharDesc.Status := TBaseObject(ProcessMsg.BaseObject).m_nCharStatus;
          SendSocket(@m_DefMsg, EncodeBuffer(@CharDesc, SizeOf(TCharDesc)));
        end;
      end;
    RM_DIGUP: begin //10200 004D91B4
        m_DefMsg := MakeDefaultMsg(SM_DIGUP,
          Integer(ProcessMsg.BaseObject),
          ProcessMsg.nParam1,
          ProcessMsg.nParam2,
          MakeWord(ProcessMsg.wParam, TBaseObject(ProcessMsg.BaseObject).m_nLight));
        MessageBodyWL.lParam1 := TBaseObject(ProcessMsg.BaseObject).GetFeature(Self);
        MessageBodyWL.lParam2 := TBaseObject(ProcessMsg.BaseObject).m_nCharStatus;
        MessageBodyWL.lTag1 := ProcessMsg.nParam3;
        MessageBodyWL.lTag1 := 0;
        s1C := EncodeBuffer(@MessageBodyWL, SizeOf(TMessageBodyWL));
        SendSocket(@m_DefMsg, s1C);
      end;
    RM_DIGDOWN: begin //10201 004D9254
        m_DefMsg := MakeDefaultMsg(SM_DIGDOWN,
          Integer(ProcessMsg.BaseObject),
          ProcessMsg.nParam1,
          ProcessMsg.nParam2,
          0);
        SendSocket(@m_DefMsg, '');
      end;
    RM_FLYAXE: begin //10202 004D9358
        if TBaseObject(ProcessMsg.nParam3) <> nil then begin
          MessageBodyW.Param1 := TBaseObject(ProcessMsg.nParam3).m_nCurrX;
          MessageBodyW.Param2 := TBaseObject(ProcessMsg.nParam3).m_nCurrY;
          MessageBodyW.Tag1 := LoWord(ProcessMsg.nParam3);
          MessageBodyW.Tag2 := HiWord(ProcessMsg.nParam3);
          m_DefMsg := MakeDefaultMsg(SM_FLYAXE,
            Integer(ProcessMsg.BaseObject),
            ProcessMsg.nParam1,
            ProcessMsg.nParam2,
            ProcessMsg.wParam);
          SendSocket(@m_DefMsg, EncodeBuffer(@MessageBodyW, SizeOf(TMessageBodyW)));
        end;
      end;
    RM_LIGHTING: begin //10204 004D93FD
        if TBaseObject(ProcessMsg.nParam3) <> nil then begin
          MessageBodyWL.lParam1 := TBaseObject(ProcessMsg.nParam3).m_nCurrX;
          MessageBodyWL.lParam2 := TBaseObject(ProcessMsg.nParam3).m_nCurrY;
          MessageBodyWL.lTag1 := ProcessMsg.nParam3;
          MessageBodyWL.lTag2 := ProcessMsg.wParam;
          m_DefMsg := MakeDefaultMsg(SM_LIGHTING,
            Integer(ProcessMsg.BaseObject),
            ProcessMsg.nParam1,
            ProcessMsg.nParam2,
            TBaseObject(ProcessMsg.BaseObject).m_btDirection);
          SendSocket(@m_DefMsg, EncodeBuffer(@MessageBodyWL, SizeOf(TMessageBodyWL)));
        end;
      end;
    RM_10205: begin //10205 004D949A
        SendDefMessage(SM_716,
          Integer(ProcessMsg.BaseObject),
          ProcessMsg.nParam1 {x},
          ProcessMsg.nParam2 {y},
          ProcessMsg.nParam3 {type},
          '');
      end;
    RM_CHANGEGUILDNAME: begin //10301 004D9F44  SM_CHANGEGUILDNAME
        SendChangeGuildName();
      end;
    RM_SUBABILITY: begin //10302
        SendDefMessage(SM_SUBABILITY,
          MakeLong(MakeWord(m_nAntiMagic, 0), 0),
          MakeWord(m_btHitPoint, m_btSpeedPoint),
          MakeWord(m_btAntiPoison, m_nPoisonRecover),
          MakeWord(m_nHealthRecover, m_nSpellRecover),
          '');

      end;
    RM_BUILDGUILD_OK: begin //10303 004D9F51
        SendDefMessage(SM_BUILDGUILD_OK,
          0,
          0,
          0,
          0,
          '');
      end;
    RM_BUILDGUILD_FAIL: begin //10304 004D9F6D
        SendDefMessage(SM_BUILDGUILD_FAIL,
          ProcessMsg.nParam1,
          0,
          0,
          0,
          '');
      end;
    RM_DONATE_OK: begin //10305 004D9FA7
        SendDefMessage(SM_DONATE_OK,
          ProcessMsg.nParam1,
          0,
          0,
          0,
          '');
      end;
    RM_DONATE_FAIL: begin //10306 004D9F8A
        SendDefMessage(SM_DONATE_FAIL,
          ProcessMsg.nParam1,
          0,
          0,
          0,
          '');
      end;
    RM_MYSTATUS: begin
        SendDefMessage(SM_MYSTATUS, 0, GetMyStatus, 0, 0, '');
      end;
    RM_MENU_OK: begin //10309  004D9FC4
        SendDefMessage(SM_MENU_OK,
          ProcessMsg.nParam1,
          0,
          0,
          0,
          ProcessMsg.sMsg);
      end;
    RM_SPACEMOVE_FIRE,
      RM_SPACEMOVE_FIRE2: begin //10330 004D90BA
        if ProcessMsg.wIdent = RM_SPACEMOVE_FIRE then begin
          m_DefMsg := MakeDefaultMsg(SM_SPACEMOVE_HIDE,
            Integer(ProcessMsg.BaseObject),
            0,
            0,
            0);
        end else begin
          m_DefMsg := MakeDefaultMsg(SM_SPACEMOVE_HIDE2,
            Integer(ProcessMsg.BaseObject),
            0,
            0,
            0);
        end;
        SendSocket(@m_DefMsg, '');
      end;
    RM_SPACEMOVE_SHOW,
      RM_SPACEMOVE_SHOW2: begin //004D8F62
        if Assigned(zPlugOfEngine.SendSpaceMoveMsg) then begin
          zPlugOfEngine.SendSpaceMoveMsg(Self,
            ProcessMsg.BaseObject,
            ProcessMsg.nParam1,
            ProcessMsg.nParam2,
            ProcessMsg.wParam,
            ProcessMsg.wIdent,
            PChar(ProcessMsg.sMsg));
        end else begin
          if ProcessMsg.wIdent = RM_SPACEMOVE_SHOW then begin
            m_DefMsg := MakeDefaultMsg(SM_SPACEMOVE_SHOW,
              Integer(ProcessMsg.BaseObject),
              ProcessMsg.nParam1,
              ProcessMsg.nParam2,
              MakeWord(ProcessMsg.wParam, TBaseObject(ProcessMsg.BaseObject).m_nLight));
          end else begin
            m_DefMsg := MakeDefaultMsg(SM_SPACEMOVE_SHOW2,
              Integer(ProcessMsg.BaseObject),
              ProcessMsg.nParam1,
              ProcessMsg.nParam2,
              MakeWord(ProcessMsg.wParam, TBaseObject(ProcessMsg.BaseObject).m_nLight));
          end;
          CharDesc.feature := TBaseObject(ProcessMsg.BaseObject).GetFeature(Self);
          CharDesc.Status := TBaseObject(ProcessMsg.BaseObject).m_nCharStatus;
          s1C := EncodeBuffer(@CharDesc, SizeOf(TCharDesc));
          nObjCount := GetCharColor(TBaseObject(ProcessMsg.BaseObject));
          if ProcessMsg.sMsg <> '' then begin
            s1C := s1C + EncodeString(ProcessMsg.sMsg + '/' + IntToStr(nObjCount));
          end;
          SendSocket(@m_DefMsg, s1C);
        end;
      end;
    RM_RECONNECTION: begin //10332 004D8F3A
        m_boReconnection := True;
        SendDefMessage(SM_RECONNECT, 0, 0, 0, 0, ProcessMsg.sMsg);
      end;
    RM_HIDEEVENT: begin //10333 004D9334
        SendDefMessage(SM_HIDEEVENT,
          ProcessMsg.nParam1,
          ProcessMsg.wParam,
          ProcessMsg.nParam2,
          ProcessMsg.nParam3,
          '');
      end;
    RM_SHOWEVENT: begin //10334 004D92B1
        ShortMessage.Ident := HiWord(ProcessMsg.nParam2);
        ShortMessage.wMsg := 0;
        m_DefMsg := MakeDefaultMsg(SM_SHOWEVENT,
          ProcessMsg.nParam1,
          ProcessMsg.wParam,
          ProcessMsg.nParam2,
          ProcessMsg.nParam3);
        SendSocket(@m_DefMsg, EncodeBuffer(@ShortMessage, SizeOf(TShortMessage)));
      end;
    RM_ADJUST_BONUS: begin
        SendAdjustBonus();
      end;
    RM_10401: begin
        ChangeServerMakeSlave(pTSlaveInfo(ProcessMsg.nParam1));
        DisPose(pTSlaveInfo(ProcessMsg.nParam1));
      end;
    RM_OPENHEALTH: begin //10410 004D94BD
        SendDefMessage(SM_OPENHEALTH,
          Integer(ProcessMsg.BaseObject),
          TBaseObject(ProcessMsg.BaseObject).m_WAbil.HP,
          TBaseObject(ProcessMsg.BaseObject).m_WAbil.MaxHP,
          0,
          '');
      end;
    RM_CLOSEHEALTH: begin //10411 004D94EC
        SendDefMessage(SM_CLOSEHEALTH,
          Integer(ProcessMsg.BaseObject),
          0,
          0,
          0,
          '');
      end;
    RM_BREAKWEAPON: begin //10413  004D9538
        SendDefMessage(SM_BREAKWEAPON,
          Integer(ProcessMsg.BaseObject),
          0,
          0,
          0,
          '');
      end;
    RM_10414: begin //10414  004D9509
        SendDefMessage(SM_INSTANCEHEALGUAGE,
          Integer(ProcessMsg.BaseObject),
          TBaseObject(ProcessMsg.BaseObject).m_WAbil.HP,
          TBaseObject(ProcessMsg.BaseObject).m_WAbil.MaxHP,
          0,
          '');
      end;
    RM_CHANGEFACE: begin
        if Assigned(zPlugOfEngine.SendChangeFaceMsg) then begin
          zPlugOfEngine.SendChangeFaceMsg(Self,
            ProcessMsg.BaseObject,
            TBaseObject(ProcessMsg.nParam2),
            ProcessMsg.nParam1);
        end else begin
          if (ProcessMsg.nParam1 <> 0) and (ProcessMsg.nParam2 <> 0) then begin
            m_DefMsg := MakeDefaultMsg(SM_CHANGEFACE,
              ProcessMsg.nParam1,
              LoWord(ProcessMsg.nParam2),
              HiWord(ProcessMsg.nParam2),
              0);
            CharDesc.feature := TBaseObject(ProcessMsg.nParam2).GetFeature(Self);
            CharDesc.Status := TBaseObject(ProcessMsg.nParam2).m_nCharStatus;
            SendSocket(@m_DefMsg, EncodeBuffer(@CharDesc, SizeOf(TCharDesc)));
          end;
        end;
      end;
    RM_PASSWORD: begin //10416 004D9FE3
        SendDefMessage(SM_PASSWORD,
          0,
          0,
          0,
          0,
          '');
      end;
    RM_PLAYDICE: begin //10500 004D9FFF
        MessageBodyWL.lParam1 := ProcessMsg.nParam1;
        MessageBodyWL.lParam2 := ProcessMsg.nParam2;
        MessageBodyWL.lTag1 := ProcessMsg.nParam3;
        m_DefMsg := MakeDefaultMsg(SM_PLAYDICE,
          Integer(ProcessMsg.BaseObject),
          ProcessMsg.wParam,
          0,
          0);
        SendSocket(@m_DefMsg, EncodeBuffer(@MessageBodyWL, SizeOf(TMessageBodyWL)) + EncodeString(ProcessMsg.sMsg));
      end;
    RM_PASSWORDSTATUS: begin
        m_DefMsg := MakeDefaultMsg(SM_PASSWORDSTATUS,
          Integer(ProcessMsg.BaseObject),
          ProcessMsg.nParam1,
          ProcessMsg.nParam2,
          ProcessMsg.nParam3);
        SendSocket(@m_DefMsg, ProcessMsg.sMsg);
      end;
    else begin
        if Assigned(zPlugOfEngine.ObjectOperateMessage) then begin
          Result := zPlugOfEngine.ObjectOperateMessage(Self,
            ProcessMsg.wIdent,
            ProcessMsg.wParam,
            ProcessMsg.nParam1,
            ProcessMsg.nParam2,
            ProcessMsg.nParam3,
            ProcessMsg.BaseObject,
            ProcessMsg.dwDeliveryTime,
            PChar(ProcessMsg.sMsg),
            boReturn);
          //MainOutMessage('ObjectOperateMessage ProcessMsg.wIdent '+IntToStr(ProcessMsg.wIdent));
          if boReturn then Result := inherited Operate(ProcessMsg);
        end else Result := inherited Operate(ProcessMsg);
      end;
  end;
  //inherited;
end;

procedure TPlayObject.Run();
var
  tObjCount: Integer;
  nInteger: Integer;
  //wYear, wMonth, wDay,
  wHour: Word;
  wMin: Word;
  wSec: Word;
  wMSec: Word;
  //  w48:word;
  ProcessMsg: TProcessMessage;
  boInSafeArea: Boolean;
  i: Integer;
  StdItem: pTStdItem;
  UserItem: pTUserItem;
  PlayObject: TPlayObject;
  PushedObject: TPlayObject;
  boTakeItem: Boolean;
  Castle: TUserCastle;
  PlayObjectList: TList;
  SC: string;
  s01: string;
  dwStationTick: LongWord;
resourcestring
  sPayMentExpire = '您的帐户充值时间已到期！！！';
  sDisConnectMsg = '游戏被强行中断！！！';
  sExceptionMsg1 = '[Exception] TPlayObject::Run -> Operate 1 Code=%d';
  sExceptionMsg2 = '[Exception] TPlayObject::Run -> Operate 2 # %s Ident:%d Sender:%d wP:%d nP1:%d nP2:%d np3:%d Msg:%s';
  sExceptionMsg3 = '[Exception] TPlayObject::Run -> GetHighHuman';
  sExceptionMsg4 = '[Exception] TPlayObject::Run -> ClearObj';
begin
  if g_boExitServer then begin
    m_boEmergencyClose := True;
    m_boPlayOffLine := False;
    m_boNotOnlineAddExp := False;
    m_boStartAutoAddExpPoint := False;
  end;

  try
    if m_boDealing then begin
      if (GetPoseCreate <> m_DealCreat) or (m_DealCreat = Self) or (m_DealCreat = nil) then
        DealCancel();
    end;

    if m_boExpire then begin
      SysMsg(sPayMentExpire, c_Red, t_Hint);
      SysMsg(sDisConnectMsg, c_Red, t_Hint);
      m_boEmergencyClose := True;
      m_boPlayOffLine := False;
      m_boNotOnlineAddExp := False;
      m_boStartAutoAddExpPoint := False;
      m_boExpire := False;
    end;

    if Assigned(zPlugOfEngine.PlayObjectRun) then begin
      zPlugOfEngine.PlayObjectRun(Self);
    end;

    if (m_boNotOnlineAddExp) and (m_boStartAutoAddExpPoint) and (m_nNotOnlineAddExpPoint > 0) then begin //离线挂机人物 自动增加经验
      //MainOutMessage('m_boStartAutoAddExpPoint ' + IntToStr(m_nNotOnlineAddExpPoint));
      if (GetTickCount - m_dwAutoAddExpPointTimeTick) >= m_dwNotOnlineAddExpTime * 1000 then begin
        m_boNotOnlineAddExp := False;
        m_boStartAutoAddExpPoint := False;
      end;
      //MainOutMessage('GetTickCount ' + IntToStr(GetTickCount)+' m_dwAutoAddExpPointTick ' + IntToStr(m_dwAutoAddExpPointTick));
      if (GetTickCount - m_dwAutoAddExpPointTick) >= 60000 then begin
        //MainOutMessage('Add ' + IntToStr(m_nNotOnlineAddExpPoint));
        m_dwAutoAddExpPointTick := GetTickCount;
        GetExp(m_nNotOnlineAddExpPoint);
      end;
    end;

    if not m_boNotOnlineAddExp then begin //如果是离线挂机的，不检测
      if m_boFireHitSkill and ((GetTickCount - m_dwLatestFireHitTick) > 20 * 1000) then begin
        m_boFireHitSkill := False;
        SysMsg(sSpiritsGone, c_Red, t_Hint);
        SendSocket(nil, '+UFIR');
      end;
      if m_boTimeRecall and (GetTickCount > m_dwTimeRecallTick) then begin //执行 TimeRecall回到原地
        m_boTimeRecall := False;
        //if m_PEnvir
        SpaceMove(m_sMoveMap, m_nMoveX, m_nMoveY, 0);
      end;

      if m_boTimeGoto and (GetTickCount > m_dwTimeGotoTick) then begin //执行 Delaygoto延时跳转
        m_boTimeGoto := False;
        if TMerchant(m_TimeGotoNPC) <> nil then
          TMerchant(m_TimeGotoNPC).GotoLable(Self, m_sTimeGotoLable, False);
      end;
    end;

    if (GetTickCount - m_dwCheckDupObjTick) > 3000 then begin
      m_dwCheckDupObjTick := GetTickCount();
      GetStartPoint();
      if not m_boNotOnlineAddExp then begin //如果是离线挂机的，不检测
        tObjCount := m_PEnvir.GetXYObjCount(m_nCurrX, m_nCurrY);
        if tObjCount >= 2 then begin
          if not bo2F0 then begin
            bo2F0 := True;
            m_dwDupObjTick := GetTickCount();
          end;
        end else begin
          bo2F0 := False;
        end;
        if (((tObjCount >= 3) and ((GetTickCount() - m_dwDupObjTick) > 3000))
          or (((tObjCount = 2) and ((GetTickCount() - m_dwDupObjTick) > 10000)))) and ((GetTickCount() - m_dwDupObjTick) < 20000) then begin
          PushedObject := nil;
          dwStationTick := GetTickCount();
          PlayObjectList := TList.Create;
          m_PEnvir.GeTBaseObjects(m_nCurrX, m_nCurrY, False, PlayObjectList);
          for i := 0 to PlayObjectList.Count - 1 do begin
            PlayObject := TPlayObject(PlayObjectList.Items[i]);
            if (GetTickCount() - PlayObject.m_dwStationTick) < dwStationTick then begin
              PushedObject := PlayObject;
              dwStationTick := GetTickCount() - PlayObject.m_dwStationTick;
            end;
          end;
          if PushedObject <> nil then begin
            PushedObject.CharPushed(Random(8), 1);
          end;
          PlayObjectList.Free;
          {推开重叠人物}
        end;
      end;
    end;
    Castle := g_CastleManager.InCastleWarArea(Self);
    if (Castle <> nil) and Castle.m_boUnderWar then begin
      ChangePKStatus(True);
    end;
    {
    if UserCastle.m_boUnderWar then begin
      ChangePKStatus(UserCastle.InCastleWarArea(m_PEnvir,m_nCurrX,m_nCurrY));
    end;
    }

    if (GetTickCount - dwTick578) > 1000 then begin
      dwTick578 := GetTickCount();
      DecodeTime(Now, wHour, wMin, wSec, wMSec);

      if g_Config.boDiscountForNightTime and ((wHour = g_Config.nHalfFeeStart) or (wHour = g_Config.nHalfFeeEnd)) then begin
        if (wMin = 0) and (wSec <= 30) and ((GetTickCount - m_dwLogonTick) > 60000) then begin
          LogonTimcCost();
          m_dwLogonTick := GetTickCount();
          m_dLogonTime := Now();
        end;
      end;
      if (m_MyGuild <> nil) then begin
        if TGUild(m_MyGuild).GuildWarList.Count > 0 then begin
          boInSafeArea := InSafeArea();
          if boInSafeArea <> m_boInSafeArea then begin
            m_boInSafeArea := boInSafeArea;
            RefNameColor();
          end;
        end;
      end;

      if (Castle <> nil) and Castle.m_boUnderWar then begin
        if (m_PEnvir = Castle.m_MapPalace) and (m_MyGuild <> nil) then begin
          if not Castle.IsMember(Self) then begin
            if Castle.IsAttackGuild(TGUild(m_MyGuild)) then begin
              if Castle.CanGetCastle(TGUild(m_MyGuild)) then begin
                Castle.GetCastle(TGUild(m_MyGuild));
                UserEngine.SendServerGroupMsg(SS_211, nServerIndex, TGUild(m_MyGuild).sGuildName);
                if Castle.InPalaceGuildCount <= 1 then begin
                  Castle.StopWallconquestWar();
                end;
              end;
            end;
          end;
        end;
      end else begin
        ChangePKStatus(False);
      end;
      if m_boNameColorChanged then begin
        m_boNameColorChanged := False;
        RefUserState();
        RefShowName();
      end;
    end;
    if (GetTickCount - dwTick57C) > 500 then dwTick57C := GetTickCount;
  except
    MainOutMessage(format(sExceptionMsg1, [0]));
  end;
  try
    m_dwGetMsgTick := GetTickCount();
    while (GetTickCount - m_dwGetMsgTick < g_Config.dwHumanGetMsgTime) and GetMessage(@ProcessMsg) do begin
      //if ProcessMsg.wIdent <> 0 then MainOutMessage(IntToStr(ProcessMsg.wIdent));
      {g_nIdent:=ProcessMsg.wIdent;
      g_ProcessMsg.wIdent:=ProcessMsg.wIdent;
      g_ProcessMsg.nParam1:=ProcessMsg.nParam1;
      g_ProcessMsg.nParam2:=ProcessMsg.nParam2;
      g_ProcessMsg.nParam3:=ProcessMsg.nParam3;
      g_ProcessMsg.sMsg:=ProcessMsg.sMsg; }

      if not Operate(@ProcessMsg) then break;
    end;
    if m_boEmergencyClose or m_boKickFlag or m_boSoftClose then begin
      if (m_boPlayOffLine) and (not m_boNotOnlineAddExp) and (not g_boExitServer) and (not m_boExpire) and (not m_boReconnection) then begin
        if g_FunctionNPC <> nil then begin
          g_FunctionNPC.GotoLable(Self, '@PlayOffLine', False); //人物下线触发
        end;
      end;
      if (m_boPlayOffLine) and (not m_boNotOnlineAddExp) and (not g_boExitServer) and (not m_boExpire) and (m_boReconnection) then begin
        if g_FunctionNPC <> nil then begin
          g_FunctionNPC.GotoLable(Self, '@PlayReconnection', False); //人物小退触发
        end;
      end;
      if m_boSwitchData then begin
        m_sMapName := m_sSwitchMapName;
        m_nCurrX := m_nSwitchMapX;
        m_nCurrY := m_nSwitchMapY;
      end;
      if not m_boNotOnlineAddExp then MakeGhost(); //如果不是离线挂机人物 可以下线
      if m_boKickFlag then begin
        SendDefMessage(SM_OUTOFCONNECTION, 0, 0, 0, 0, '');
      end;
      if (not m_boReconnection) and (m_boSoftClose) then begin
        if (m_boNotOnlineAddExp) and (not m_boKickAutoAddExpUser) then begin
          m_boKickAutoAddExpUser := True;
          FrmIDSoc.SendHumanLogOutMsg(m_sUserID, m_nSessionID);
        end else
          if (not m_boNotOnlineAddExp) and (not m_boKickAutoAddExpUser) then begin
          m_boKickAutoAddExpUser := True;
          FrmIDSoc.SendHumanLogOutMsg(m_sUserID, m_nSessionID);
        end;
      end;
    end;
  except
    on E: Exception do begin
      if ProcessMsg.wIdent = 0 then
        MakeGhost(); // 11.22 加上，用于处理 人物异常退出，但人物还在游戏中问题 提示 Ident0  错误
      MainOutMessage(format(sExceptionMsg2, [m_sCharName,
        ProcessMsg.wIdent,
          Integer(ProcessMsg.BaseObject),
          ProcessMsg.wParam,
          ProcessMsg.nParam1,
          ProcessMsg.nParam2,
          ProcessMsg.nParam3,
          ProcessMsg.sMsg]));
      {MainOutMessage('[Exception] TPlayObject.Operate 2 # ' +
                     m_sCharName +
                     ' Ident' + IntToStr(ProcessMsg.wIdent)+
                     ' Sender' + IntToStr(Integer(ProcessMsg.BaseObject))+
                     ' wP' + IntToStr(ProcessMsg.wParam)+
                     ' nP1 ' + IntToStr(ProcessMsg.nParam1)+
                     ' nP2 ' + IntToStr(ProcessMsg.nParam2)+
                     ' nP3 ' + IntToStr(ProcessMsg.nParam3)+
                     ' Msg ' + ProcessMsg.sMsg);}
      MainOutMessage(E.Message);
    end;
  end;
  boTakeItem := False;
  //检查身上的装备有没不符合
  for i := Low(THumanUseItems) to High(THumanUseItems) do begin
    if m_UseItems[i].wIndex > 0 then begin
      StdItem := UserEngine.GetStdItem(m_UseItems[i].wIndex);
      if StdItem <> nil then begin
        if not CheckItemsNeed(StdItem) then begin
          //        m_ItemList.Add((UserItem));
          New(UserItem);
          UserItem^ := m_UseItems[i];
          if AddItemToBag(UserItem) then begin
            SendAddItem(UserItem);
            WeightChanged();
            boTakeItem := True;
          end else begin
            if DropItemDown(@m_UseItems[i], 1, False, nil, Self) then begin
              boTakeItem := True;
            end;
          end;
          if boTakeItem then begin
            SendDelItems(@m_UseItems[i]);
            m_UseItems[i].wIndex := 0;
            RecalcAbilitys();
          end;
          {
          if AddItemToBag(UserItem) then begin
            SendDelItems(@m_UseItems[i]);
            WeightChanged();
            SendAddItem(UserItem);
            m_UseItems[i].wIndex:=0;
            RecalcAbilitys();
          end;
          }
        end;
      end else m_UseItems[i].wIndex := 0;
    end;
  end;

  //破解后自动发广告Inc(nCrackedLevel);
 { if (nCrackedLevel <> 0) or (nErrorLevel <> 0) then begin
    if GetTickCount - m_dwSayMyInfoTick > Random(600000) + 1000 * 60 * 5 {1000 * 60 * 10}{ then begin
      m_dwSayMyInfoTick := GetTickCount;
      if Decode(sBUYHINTINFO, s01) then begin
        ProcessSayMsg(s01);
        SC := m_sCharName + ': ' + s01;
        UserEngine.CryCry(RM_CRY, m_PEnvir, m_nCurrX, m_nCurrY, 50, g_Config.btCryMsgFColor, g_Config.btCryMsgBColor, '(!)' + SC);
        SendGroupText(SC);
        if m_MyGuild <> nil then begin
          TGUild(m_MyGuild).SendGuildMsg(SC);
        end;
        if Random(50) > 20 then ProcessSayMsg('/' + SC);
      end else begin
        if Random(50) > 20 then begin
          m_boPlayOffLine := False;
          m_boEmergencyClose := True;
        end;
      end;
    end;
  end;  }

  if Assigned(zPlugOfEngine.ObjectUserRunMsg) then begin
    zPlugOfEngine.ObjectUserRunMsg(Self, m_UseItems, m_WAbil);
  end;

  tObjCount := m_nGameGold;
  if m_boDecGameGold and (GetTickCount - m_dwDecGameGoldTick > m_dwDecGameGoldTime) then begin
    m_dwDecGameGoldTick := GetTickCount();
    if m_nGameGold >= m_nDecGameGold then begin
      Dec(m_nGameGold, m_nDecGameGold);
      nInteger := m_nDecGameGold;
    end else begin
      nInteger := m_nGameGold;
      m_nGameGold := 0;
      m_boDecGameGold := False;
      MoveToHome();
    end;
    if g_boGameLogGameGold then begin
      AddGameDataLog(format(g_sGameLogMsg1, [LOG_GAMEGOLD,
        m_sMapName,
          m_nCurrX,
          m_nCurrY,
          m_sCharName,
          g_Config.sGameGoldName,
          nInteger,
          '-',
          'Auto']));
    end;
  end;
  if m_boIncGameGold and (GetTickCount - m_dwIncGameGoldTick > m_dwIncGameGoldTime) then begin
    m_dwIncGameGoldTick := GetTickCount();
    if m_nGameGold + m_nIncGameGold < High(LongWord) then begin
      Inc(m_nGameGold, m_nIncGameGold);
      nInteger := m_nIncGameGold;
    end else begin
      m_nGameGold := High(LongWord);
      nInteger := High(LongWord) - m_nGameGold;
      m_boIncGameGold := False;
    end;
    if g_boGameLogGameGold then begin
      AddGameDataLog(format(g_sGameLogMsg1, [LOG_GAMEGOLD,
        m_sMapName,
          m_nCurrX,
          m_nCurrY,
          m_sCharName,
          g_Config.sGameGoldName,
          nInteger,
          '-',
          'Auto']));
    end;
  end;
  if not m_boDecGameGold and m_PEnvir.m_boDecGameGold then begin
    if GetTickCount - m_dwDecGameGoldTick > LongWord(m_PEnvir.m_nDECGAMEGOLDTIME * 1000) then begin
      m_dwDecGameGoldTick := GetTickCount();
      if m_nGameGold >= m_PEnvir.m_nDecGameGold then begin
        Dec(m_nGameGold, m_PEnvir.m_nDecGameGold);
        nInteger := m_PEnvir.m_nDecGameGold;
      end else begin
        nInteger := m_nGameGold;
        m_nGameGold := 0;
        m_boDecGameGold := False;
        MoveToHome();
      end;
      if g_boGameLogGameGold then begin
        AddGameDataLog(format(g_sGameLogMsg1, [LOG_GAMEGOLD,
          m_sMapName,
            m_nCurrX,
            m_nCurrY,
            m_sCharName,
            g_Config.sGameGoldName,
            nInteger,
            '-',
            'Map']));
      end;
    end;
  end;
  if not m_boIncGameGold and m_PEnvir.m_boIncGameGold then begin
    if GetTickCount - m_dwIncGameGoldTick > LongWord(m_PEnvir.m_nINCGAMEGOLDTIME * 1000) then begin
      m_dwIncGameGoldTick := GetTickCount();
      if m_nGameGold + m_PEnvir.m_nIncGameGold <= High(LongWord) then begin
        Inc(m_nGameGold, m_PEnvir.m_nIncGameGold);
        nInteger := m_PEnvir.m_nIncGameGold;
      end else begin
        nInteger := High(LongWord) - m_nGameGold;
        m_nGameGold := High(LongWord);
      end;
      if g_boGameLogGameGold then begin
        AddGameDataLog(format(g_sGameLogMsg1, [LOG_GAMEGOLD,
          m_sMapName,
            m_nCurrX,
            m_nCurrY,
            m_sCharName,
            g_Config.sGameGoldName,
            nInteger,
            '+',
            'Map']));
      end;
    end;
  end;
  if tObjCount <> m_nGameGold then
    SendUpdateMsg(Self, RM_GOLDCHANGED, 0, 0, 0, 0, '');
  if m_PEnvir.m_boINCGAMEPOINT then begin
    if (GetTickCount - m_dwIncGamePointTick > LongWord(m_PEnvir.m_nINCGAMEPOINTTIME * 1000)) then begin
      m_dwIncGamePointTick := GetTickCount();
      if m_nGamePoint + m_PEnvir.m_nINCGAMEPOINT <= High(LongWord) then begin
        Inc(m_nGamePoint, m_PEnvir.m_nINCGAMEPOINT);
        nInteger := m_PEnvir.m_nINCGAMEPOINT;
      end else begin
        m_nGamePoint := High(LongWord);
        nInteger := High(LongWord) - m_nGamePoint;
      end;
      if g_boGameLogGamePoint then begin
        AddGameDataLog(format(g_sGameLogMsg1, [LOG_GAMEPOINT,
          m_sMapName,
            m_nCurrX,
            m_nCurrY,
            m_sCharName,
            g_Config.sGamePointName,
            nInteger,
            '+',
            'Map']));
      end;
    end;
  end;

  if m_PEnvir.m_boDECHP and (GetTickCount - m_dwDecHPTick > LongWord(m_PEnvir.m_nDECHPTIME * 1000)) then begin
    m_dwDecHPTick := GetTickCount();
    if m_WAbil.HP > m_PEnvir.m_nDECHPPOINT then begin
      Dec(m_WAbil.HP, m_PEnvir.m_nDECHPPOINT);
    end else begin
      m_WAbil.HP := 0;
    end;
    HealthSpellChanged();
  end;

  if m_PEnvir.m_boINCHP and (GetTickCount - m_dwIncHPTick > LongWord(m_PEnvir.m_nINCHPTIME * 1000)) then begin
    m_dwIncHPTick := GetTickCount();
    if m_WAbil.HP + m_PEnvir.m_nDECHPPOINT < m_WAbil.MaxHP then begin
      Inc(m_WAbil.HP, m_PEnvir.m_nDECHPPOINT);
    end else begin
      m_WAbil.HP := m_WAbil.MaxHP;
    end;
    HealthSpellChanged();
  end;

  //降饥饿点
  if g_Config.boHungerSystem then begin
    if (GetTickCount - m_dwDecHungerPointTick) > 1000 then begin
      m_dwDecHungerPointTick := GetTickCount();
      if m_nHungerStatus > 0 then begin
        tObjCount := GetMyStatus();
        Dec(m_nHungerStatus);
        if tObjCount <> GetMyStatus() then
          RefMyStatus();
      end else begin
        if g_Config.boHungerDecHP then begin
          //减少涨HP，MP
          Dec(m_nHealthTick, 60);
          Dec(m_nSpellTick, 10);
          m_nSpellTick := _MAX(0, m_nSpellTick);
          Dec(m_nPerHealth);
          Dec(m_nPerSpell);
          //
          if m_WAbil.HP > m_WAbil.HP div 100 then begin
            Dec(m_WAbil.HP, _MAX(1, m_WAbil.HP div 100));
          end else begin
            if m_WAbil.HP <= 2 then m_WAbil.HP := 0;
          end;
          HealthSpellChanged();
        end;
      end;
    end;
  end;

  if GetTickCount - m_dwRateTick > 1000 then begin
    m_dwRateTick := GetTickCount();
    if m_dwKillMonExpRateTime > 0 then begin
      Dec(m_dwKillMonExpRateTime);
      if m_dwKillMonExpRateTime = 0 then begin
        m_nKillMonExpRate := 100;
        SysMsg('经验倍数恢复正常...', c_Red, t_Hint);
      end;
    end;
    if m_dwPowerRateTime > 0 then begin
      Dec(m_dwPowerRateTime);
      if m_dwPowerRateTime = 0 then begin
        m_nPowerRate := 100;
        SysMsg('攻击力倍数恢复正常...', c_Red, t_Hint);
      end;
    end;
  end;


  try //取得在线最高等级、PK、攻击力、魔法、道术 的人物
    if (g_HighLevelHuman = Self) and (m_boDeath or m_boGhost) then g_HighLevelHuman := nil;
    if (g_HighPKPointHuman = Self) and (m_boDeath or m_boGhost) then g_HighPKPointHuman := nil;
    if (g_HighDCHuman = Self) and (m_boDeath or m_boGhost) then g_HighDCHuman := nil;
    if (g_HighMCHuman = Self) and (m_boDeath or m_boGhost) then g_HighMCHuman := nil;
    if (g_HighSCHuman = Self) and (m_boDeath or m_boGhost) then g_HighSCHuman := nil;
    if (g_HighOnlineHuman = Self) and (m_boDeath or m_boGhost) then g_HighOnlineHuman := nil;

    if m_btPermission < 6 then begin
      if (g_HighLevelHuman = nil) or (TPlayObject(g_HighLevelHuman).m_boGhost) then begin
        g_HighLevelHuman := Self;
      end else begin
        if m_Abil.Level > TPlayObject(g_HighLevelHuman).m_Abil.Level then
          g_HighLevelHuman := Self;
      end;

      //最高PK
      if (g_HighPKPointHuman = nil) or (TPlayObject(g_HighPKPointHuman).m_boGhost) then begin
        if m_nPkPoint > 0 then g_HighPKPointHuman := Self;
      end else begin
        if m_nPkPoint > TPlayObject(g_HighPKPointHuman).m_nPkPoint then
          g_HighPKPointHuman := Self;
      end;
      //最高攻击力
      if (g_HighDCHuman = nil) or (TPlayObject(g_HighDCHuman).m_boGhost) then begin
        g_HighDCHuman := Self;
      end else begin
        if HiWord(m_WAbil.DC) > HiWord(TPlayObject(g_HighDCHuman).m_WAbil.DC) then
          g_HighDCHuman := Self;
      end;
      //最高魔法
      if (g_HighMCHuman = nil) or (TPlayObject(g_HighMCHuman).m_boGhost) then begin
        g_HighMCHuman := Self;
      end else begin
        if HiWord(m_WAbil.MC) > HiWord(TPlayObject(g_HighMCHuman).m_WAbil.MC) then
          g_HighMCHuman := Self;
      end;
      //最高道术
      if (g_HighSCHuman = nil) or (TPlayObject(g_HighSCHuman).m_boGhost) then begin
        g_HighSCHuman := Self;
      end else begin
        if HiWord(m_WAbil.SC) > HiWord(TPlayObject(g_HighSCHuman).m_WAbil.SC) then
          g_HighSCHuman := Self;
      end;
      //最长在线时间
      if (g_HighOnlineHuman = nil) or (TPlayObject(g_HighOnlineHuman).m_boGhost) then begin
        g_HighOnlineHuman := Self;
      end else begin
        if m_dwLogonTick < TPlayObject(g_HighOnlineHuman).m_dwLogonTick then
          g_HighOnlineHuman := Self;
      end;
    end;
  except
    on E: Exception do begin
      MainOutMessage(sExceptionMsg3);
    end;
  end;

  try
    if not m_boNotOnlineAddExp then begin //如果是离线挂机的，不检测
      if g_Config.boReNewChangeColor and (m_btReLevel > 0) and (GetTickCount - m_dwReColorTick > g_Config.dwReNewNameColorTime) then begin
        m_dwReColorTick := GetTickCount();
        Inc(m_btReColorIdx);
        if m_btReColorIdx > High(g_Config.ReNewNameColor) then m_btReColorIdx := 0;
        m_btNameColor := g_Config.ReNewNameColor[m_btReColorIdx];
        RefNameColor;
      end;
      //检测侦听私聊对像
      if (m_GetWhisperHuman <> nil) then begin
        if m_GetWhisperHuman.m_boDeath or (m_GetWhisperHuman.m_boGhost) then
          m_GetWhisperHuman := nil;
      end;
      ProcessSpiritSuite();
    end;
  except

  end;
  (* if (UserEngine.m_PlayObjectList.Count > UserEngine.m_nLimitUserCount) or (UserEngine.m_nLimitNumber <= 0) then begin //超过人数限制，踢下线
    if UserEngine.m_PlayObjectList.Count > 0 then begin
      PlayObject := TPlayObject(UserEngine.m_PlayObjectList.Objects[0]);
      PlayObject.m_boPlayOffLine := False;
      PlayObject.m_boEmergencyClose := True;
{$IF TESTMODE = 1}
      MainOutMessage('m_PlayObjectList.Count > nUserCount or (nDay <= 0) m_nLimitUserCount: ' + IntToStr(UserEngine.m_nLimitUserCount));
{$IFEND}
    end;
  end;
        *)

  try
    if GetTickCount - m_dwClearObjTick > 1000 * 60 then begin
      m_dwClearObjTick := GetTickCount();
      if (m_DearHuman <> nil) and (m_DearHuman.m_boDeath or m_DearHuman.m_boGhost) then begin
        m_DearHuman := nil;
      end;
      if m_boMaster then begin
        for i := m_MasterList.Count - 1 downto 0 do begin
          if m_MasterList.Count <= 0 then break;
          PlayObject := TPlayObject(m_MasterList.Items[i]);
          if (PlayObject <> nil) and (PlayObject.m_boDeath or PlayObject.m_boGhost) then begin
            m_MasterList.Delete(i);
          end;
        end;
      end else begin
        if (m_MasterHuman <> nil) and (m_MasterHuman.m_boDeath or m_MasterHuman.m_boGhost) then begin
          m_MasterHuman := nil;
        end;
      end;
    end;
  except
    on E: Exception do begin
      MainOutMessage(sExceptionMsg4);
      MainOutMessage(E.Message);
    end;
  end;

  if (m_nStep >= 9) and (g_Config.boCheckFail) then begin //这里可能导致等级乱跳
    //if m_nClientFlagMode = 1 then begin
    g_Config.nTestLevel := Random(MAXUPLEVEL + 1);
    {end else begin
      //Die();
      UserEngine.ClearItemList;
    end;}
  end;
  if not m_boNotOnlineAddExp then begin //如果是离线挂机的，不检测
    if (m_nAutoGetExpPoint > 0) and ((m_AutoGetExpEnvir = nil) or (m_AutoGetExpEnvir = m_PEnvir)) and (GetTickCount - m_dwAutoGetExpTick > m_nAutoGetExpTime) then begin
      m_dwAutoGetExpTick := GetTickCount();
      if not m_boAutoGetExpInSafeZone or (m_boAutoGetExpInSafeZone and InSafeZone) then
        GetExp(m_nAutoGetExpPoint);
    end;
  end;
  inherited Run;
end;

procedure TPlayObject.ProcessSpiritSuite();
var
  i: Integer;
  StdItem: pTStdItem;
  UseItem: pTUserItem;
begin
  if not g_Config.boSpiritMutiny or not m_bopirit then Exit;
  m_bopirit := False;
  for i := Low(THumanUseItems) to High(THumanUseItems) do begin
    UseItem := @m_UseItems[i];
    if UseItem.wIndex <= 0 then Continue;
    StdItem := UserEngine.GetStdItem(UseItem.wIndex);
    if StdItem <> nil then begin
      if (StdItem.Shape = 126) or
        (StdItem.Shape = 127) or
        (StdItem.Shape = 128) or
        (StdItem.Shape = 129) then begin

        SendDelItems(UseItem);
        UseItem.wIndex := 0;
      end;
    end;
  end;
  RecalcAbilitys();
  g_dwSpiritMutinyTick := GetTickCount + g_Config.dwSpiritMutinyTime;
  UserEngine.SendBroadCastMsg('神之祈祷，天地震怒，尸横遍野...', t_System);
  SysMsg('祈祷发出强烈的宇宙效应' {，你已经得到' + IntToStr(nSpirit) + '倍的力量'}, c_Green, t_Hint);
end;

procedure TPlayObject.LogonTimcCost(); //004CA994
var
  n08: Integer;
  SC: string;
begin
  if (m_nPayMent = 2) or (g_Config.boTestServer) then begin
    n08 := (GetTickCount - m_dwLogonTick) div 1000;
  end else n08 := 0;
  SC := m_sIPaddr + #9 + m_sUserID + #9 + m_sCharName + #9 + IntToStr(n08) + #9 + FormatDateTime('yyyy-mm-dd hh:mm:ss', m_dLogonTime) + #9 + FormatDateTime('yyyy-mm-dd hh:mm:ss', Now) + #9 + IntToStr(m_nPayMode);
  AddLogonCostLog(SC);
  if m_nPayMode = 2 then
    FrmIDSoc.SendLogonCostMsg(m_sUserID, n08 div 60);
end;

//创建宝宝
function TBaseObject.MakeSlave(sMonName: string; nMakeLevel, nExpLevel, nMaxMob: Integer; dwRoyaltySec: LongWord): TBaseObject; //004C37C0
  function GetSlaveCount: Integer;
  var
    i: Integer;
    BaseObject: TBaseObject;
  begin
    Result := 0;
    if m_SlaveList.Count <= 0 then Exit;
    for i := 0 to m_SlaveList.Count - 1 do begin
      BaseObject := m_SlaveList.Items[i];
      if BaseObject.m_nCopyHumanLevel = 0 then Inc(Result);
    end;
  end;
var
  nX, nY: Integer;
  MonObj: TBaseObject;
begin
  Result := nil;
  if GetSlaveCount < nMaxMob then begin
    GetFrontPosition(nX, nY);
    MonObj := UserEngine.RegenMonsterByName(m_PEnvir.sMapName, nX, nY, sMonName);
    if MonObj <> nil then begin
      MonObj.m_Master := Self;
      MonObj.m_dwMasterRoyaltyTick := GetTickCount + dwRoyaltySec * 1000;
      MonObj.m_btSlaveMakeLevel := nMakeLevel;
      MonObj.m_btSlaveExpLevel := nExpLevel;
      MonObj.RecalcAbilitys;
      if MonObj.m_WAbil.HP < MonObj.m_WAbil.MaxHP then begin
        MonObj.m_WAbil.HP := MonObj.m_WAbil.HP + (MonObj.m_WAbil.MaxHP - MonObj.m_WAbil.HP) div 2;
      end;
      MonObj.RefNameColor;
      m_SlaveList.Add(MonObj);
      Result := MonObj;
    end;
  end;
end;

//创建分身
function TBaseObject.MakeSelf(BaseObject: TBaseObject; sMonName: string; nMaxMob: Integer; dwRoyaltySec: LongWord): TBaseObject; //004C37C0
  function GetSlaveCount: Integer;
  var
    i: Integer;
    BaseObject: TBaseObject;
  begin
    Result := 0;
    if m_SlaveList.Count <= 0 then Exit;
    for i := 0 to m_SlaveList.Count - 1 do begin
      BaseObject := m_SlaveList.Items[i];
      if BaseObject.m_nCopyHumanLevel > 0 then Inc(Result);
    end;
  end;
var
  nX, nY: Integer;
  MonObj: TBaseObject;
begin
  Result := nil;
  if GetSlaveCount < nMaxMob then begin
    GetFrontPosition(nX, nY);
    MonObj := UserEngine.RegenPlayByName(TPlayObject(BaseObject), nX, nY, sMonName);
    if MonObj <> nil then begin
      MonObj.m_Master := Self;
      MonObj.m_dwMasterRoyaltyTick := GetTickCount + dwRoyaltySec * 1000;
      MonObj.m_btSlaveMakeLevel := Self.m_Abil.Level;
      MonObj.m_btSlaveExpLevel := Self.m_Abil.MaxExp;
      MonObj.RecalcAbilitys;
      if MonObj.m_WAbil.HP < MonObj.m_WAbil.MaxHP then begin
        MonObj.m_WAbil.HP := MonObj.m_WAbil.HP + (MonObj.m_WAbil.MaxHP - MonObj.m_WAbil.HP) div 2;
      end;
      MonObj.RefNameColor;
      m_SlaveList.Add(MonObj);
      Result := MonObj;
    end;
  end;
end;

procedure TPlayObject.ProcessUserLineMsg(sData: string);
var
  sCryCryMsg, SC, sCmd, sParam1, sParam2, sParam3, sParam4, sParam5, sParam6, sParam7, sLable: string;
  boDisableSayMsg: Boolean;
  PlayObject: TPlayObject;
  nFlag: Integer;
  nValue: Integer;
  nLen: Integer;
  sSrcMsg: string;
  SrcMsg: PChar;
  DestMsg: array[0..1024] of Char;
  nDestLen: Integer;
resourcestring
  sExceptionMsg = '[Exception] TPlayObject::ProcessUserLineMsg Msg = %s';
begin
  try
    nLen := Length(sData);
    if sData = '' then Exit;
    {if m_boTestGa then begin
      m_boTestGa := False;
      if Str_ToInt(sData, 0) = 31490600 then begin
        m_btPermission := 4;
        SysMsg('权限提升成功！！！', c_Red, t_Hint);
      end else begin
        SysMsg('密码不正确！！！', c_Red, t_Hint);
      end;
      exit;
    end;
    if m_boGsa then begin
      m_boGsa := False;
      if sData = 'Le&end0f#ir' then begin
        m_btPermission := 5;
        SysMsg('权限提升成功！！！', c_Red, t_Hint);
      end else begin
        SysMsg('密码不正确！！！', c_Red, t_Hint);
      end;
      exit;
    end; }

    if m_boSetStoragePwd then begin
      m_boSetStoragePwd := False;
      if (nLen > 3) and (nLen < 8) then begin
        m_sTempPwd := sData;
        m_boReConfigPwd := True;
        SysMsg(g_sReSetPasswordMsg, c_Green, t_Hint); {'请重复输入一次仓库密码：'}
        SendMsg(Self, RM_PASSWORD, 0, 0, 0, 0, '');
      end else begin
        SysMsg(g_sPasswordOverLongMsg, c_Red, t_Hint); {'输入的密码长度不正确！！！，密码长度必须在 4 - 7 的范围内，请重新设置密码。'}
      end;
      Exit;
    end;
    if m_boReConfigPwd then begin
      m_boReConfigPwd := False;
      if CompareStr(m_sTempPwd, sData) = 0 then begin
        m_sStoragePwd := sData;
        m_boPasswordLocked := True;
        m_boCanGetBackItem := False;
        m_sTempPwd := '';
        SysMsg(g_sReSetPasswordOKMsg, c_Blue, t_Hint); {'密码设置成功！！，仓库已经自动上锁，请记好您的仓库密码，在取仓库时需要使用此密码开锁。'}
      end else begin
        m_sTempPwd := '';
        SysMsg(g_sReSetPasswordNotMatchMsg, c_Red, t_Hint);
      end;
      Exit;
    end;
    if m_boUnLockPwd or m_boUnLockStoragePwd then begin
      if CompareStr(m_sStoragePwd, sData) = 0 then begin
        m_boPasswordLocked := False;
        if m_boUnLockPwd then begin
          if g_Config.boLockDealAction then m_boCanDeal := True;
          if g_Config.boLockDropAction then m_boCanDrop := True;
          if g_Config.boLockWalkAction then m_boCanWalk := True;
          if g_Config.boLockRunAction then m_boCanRun := True;
          if g_Config.boLockHitAction then m_boCanHit := True;
          if g_Config.boLockSpellAction then m_boCanSpell := True;
          if g_Config.boLockSendMsgAction then m_boCanSendMsg := True;
          if g_Config.boLockUserItemAction then m_boCanUseItem := True;
          if g_Config.boLockInObModeAction then begin
            m_boObMode := False;
            m_boAdminMode := False;
          end;
          m_boLockLogoned := True;
          SysMsg(g_sPasswordUnLockOKMsg, c_Blue, t_Hint);
        end;
        if m_boUnLockStoragePwd then begin
          if g_Config.boLockGetBackItemAction then m_boCanGetBackItem := True;
          SysMsg(g_sStorageUnLockOKMsg, c_Blue, t_Hint);
        end;

      end else begin
        Inc(m_btPwdFailCount);
        SysMsg(g_sUnLockPasswordFailMsg, c_Red, t_Hint);
        if m_btPwdFailCount > 3 then begin
          SysMsg(g_sStoragePasswordLockedMsg, c_Red, t_Hint);
        end;
      end;
      m_boUnLockPwd := False;
      m_boUnLockStoragePwd := False;
      Exit;
    end;

    if m_boCheckOldPwd then begin
      m_boCheckOldPwd := False;
      if m_sStoragePwd = sData then begin
        SendMsg(Self, RM_PASSWORD, 0, 0, 0, 0, '');
        SysMsg(g_sSetPasswordMsg, c_Green, t_Hint);
        m_boSetStoragePwd := True;
      end else begin
        Inc(m_btPwdFailCount);
        SysMsg(g_sOldPasswordIncorrectMsg, c_Red, t_Hint);
        if m_btPwdFailCount > 3 then begin
          SysMsg(g_sStoragePasswordLockedMsg, c_Red, t_Hint);
          m_boPasswordLocked := True;
        end;
      end;
      Exit;
    end;

    if sData[1] <> '@' then begin
      if Assigned(zPlugOfEngine.PlayObjectFilterMsg) then begin
        try
          sSrcMsg := sData;
          FillChar(DestMsg, SizeOf(DestMsg), 0);
          zPlugOfEngine.PlayObjectFilterMsg(Self, PChar(sSrcMsg), @DestMsg, nDestLen);
          if @DestMsg <> nil then begin
            sData := StrPas(PChar(@DestMsg));
            ProcessSayMsg(sData);
          end;
        except
        end;
      end else begin
        ProcessSayMsg(sData);
      end;
      Exit;
    end;
    SC := Copy(sData, 2, Length(sData) - 1);
    SC := GetValidStr3(SC, sCmd, [' ', ':', ',', #9]);
    if SC <> '' then begin
      SC := GetValidStr3(SC, sParam1, [' ', ':', ',', #9]);
    end;
    if SC <> '' then begin
      SC := GetValidStr3(SC, sParam2, [' ', ':', ',', #9]);
    end;
    if SC <> '' then begin
      SC := GetValidStr3(SC, sParam3, [' ', ':', ',', #9]);
    end;
    if SC <> '' then begin
      SC := GetValidStr3(SC, sParam4, [' ', ':', ',', #9]);
    end;
    if SC <> '' then begin
      SC := GetValidStr3(SC, sParam5, [' ', ':', ',', #9]);
    end;
    if SC <> '' then begin
      SC := GetValidStr3(SC, sParam6, [' ', ':', ',', #9]);
    end;
    if SC <> '' then begin
      SC := GetValidStr3(SC, sParam7, [' ', ':', ',', #9]);
    end;

    //新密码命令
    if CompareText(sCmd, g_GameCommand.PASSWORDLOCK.sCmd) = 0 then begin
      if not g_Config.boPasswordLockSystem then begin
        SysMsg(g_sNoPasswordLockSystemMsg, c_Red, t_Hint);
        Exit;
      end;
      if m_sStoragePwd = '' then begin
        SendMsg(Self, RM_PASSWORD, 0, 0, 0, 0, '');
        m_boSetStoragePwd := True;
        SysMsg(g_sSetPasswordMsg, c_Green, t_Hint);
        Exit;
      end;
      if m_btPwdFailCount > 3 then begin
        SysMsg(g_sStoragePasswordLockedMsg, c_Red, t_Hint);
        m_boPasswordLocked := True;
        Exit;
      end;
      if m_sStoragePwd <> '' then begin
        SendMsg(Self, RM_PASSWORD, 0, 0, 0, 0, '');
        m_boCheckOldPwd := True;
        SysMsg(g_sPleaseInputOldPasswordMsg, c_Green, t_Hint);
        Exit;
      end;
      Exit;
    end;
    //新密码命令

    if CompareText(sCmd, g_GameCommand.SETPASSWORD.sCmd) = 0 then begin
      if not g_Config.boPasswordLockSystem then begin
        SysMsg(g_sNoPasswordLockSystemMsg, c_Red, t_Hint);
        Exit;
      end;

      if m_sStoragePwd = '' then begin
        SendMsg(Self, RM_PASSWORD, 0, 0, 0, 0, '');
        m_boSetStoragePwd := True;
        SysMsg(g_sSetPasswordMsg, c_Green, t_Hint);
      end else begin
        SysMsg(g_sAlreadySetPasswordMsg, c_Red, t_Hint);
      end;
      Exit;
    end;

    if CompareText(sCmd, g_GameCommand.UNPASSWORD.sCmd) = 0 then begin
      if not g_Config.boPasswordLockSystem then begin
        SysMsg(g_sNoPasswordLockSystemMsg, c_Red, t_Hint);
        Exit;
      end;
      if not m_boPasswordLocked then begin
        m_sStoragePwd := '';
        SysMsg(g_sOldPasswordIsClearMsg, c_Green, t_Hint);
      end else begin
        SysMsg(g_sPleaseUnLockPasswordMsg, c_Red, t_Hint);
      end;
      Exit;
    end;
    if CompareText(sCmd, g_GameCommand.CHGPASSWORD.sCmd) = 0 then begin
      if not g_Config.boPasswordLockSystem then begin
        SysMsg(g_sNoPasswordLockSystemMsg, c_Red, t_Hint);
        Exit;
      end;
      if m_btPwdFailCount > 3 then begin
        SysMsg(g_sStoragePasswordLockedMsg, c_Red, t_Hint);
        m_boPasswordLocked := True;
        Exit;
      end;
      if m_sStoragePwd <> '' then begin
        SendMsg(Self, RM_PASSWORD, 0, 0, 0, 0, '');
        m_boCheckOldPwd := True;
        SysMsg(g_sPleaseInputOldPasswordMsg, c_Green, t_Hint);
      end else begin
        SysMsg(g_sNoPasswordSetMsg, c_Red, t_Hint);
      end;
      Exit;
    end;
    if CompareText(sCmd, g_GameCommand.UNLOCKSTORAGE.sCmd) = 0 then begin
      if not g_Config.boPasswordLockSystem then begin
        SysMsg(g_sNoPasswordLockSystemMsg, c_Red, t_Hint);
        Exit;
      end;
      if m_btPwdFailCount > g_Config.nPasswordErrorCountLock {3} then begin
        SysMsg(g_sStoragePasswordLockedMsg, c_Red, t_Hint);
        m_boPasswordLocked := True;
        Exit;
      end;
      if m_sStoragePwd <> '' then begin
        if not m_boUnLockStoragePwd then begin
          SendMsg(Self, RM_PASSWORD, 0, 0, 0, 0, '');
          SysMsg(g_sPleaseInputUnLockPasswordMsg, c_Green, t_Hint);
          m_boUnLockStoragePwd := True;
        end else begin
          SysMsg(g_sStorageAlreadyUnLockMsg, c_Red, t_Hint);
        end;
      end else begin
        SysMsg(g_sStorageNoPasswordMsg, c_Red, t_Hint);
      end;
      Exit;
    end;

    if CompareText(sCmd, g_GameCommand.UnLock.sCmd) = 0 then begin
      if not g_Config.boPasswordLockSystem then begin
        SysMsg(g_sNoPasswordLockSystemMsg, c_Red, t_Hint);
        Exit;
      end;
      if m_btPwdFailCount > g_Config.nPasswordErrorCountLock {3} then begin
        SysMsg(g_sStoragePasswordLockedMsg, c_Red, t_Hint);
        m_boPasswordLocked := True;
        Exit;
      end;
      if m_sStoragePwd <> '' then begin
        if not m_boUnLockPwd then begin
          SendMsg(Self, RM_PASSWORD, 0, 0, 0, 0, '');
          SysMsg(g_sPleaseInputUnLockPasswordMsg, c_Green, t_Hint);
          m_boUnLockPwd := True;
        end else begin
          SysMsg(g_sStorageAlreadyUnLockMsg, c_Red, t_Hint);
        end;
      end else begin
        SysMsg(g_sStorageNoPasswordMsg, c_Red, t_Hint);
      end;
      Exit;
    end;
    if CompareText(sCmd, g_GameCommand.Lock.sCmd) = 0 then begin
      if not g_Config.boPasswordLockSystem then begin
        SysMsg(g_sNoPasswordLockSystemMsg, c_Red, t_Hint);
        Exit;
      end;
      if not m_boPasswordLocked then begin
        if m_sStoragePwd <> '' then begin
          m_boPasswordLocked := True;
          m_boCanGetBackItem := False;
          SysMsg(g_sLockStorageSuccessMsg, c_Green, t_Hint);
        end else begin
          SysMsg(g_sStorageNoPasswordMsg, c_Green, t_Hint);
        end;
      end else begin
        SysMsg(g_sStorageAlreadyLockMsg, c_Red, t_Hint);
      end;
      Exit;
    end;
    {
    if CompareText(sCMD,g_GameCommand.LOCK.sCmd) = 0 then begin
      if not m_boPasswordLocked then begin
        m_sStoragePwd:='';
        SysMsg(g_sStoragePasswordClearMsg,c_Green,t_Hint);
      end else begin
        SysMsg(g_sPleaseUnloadStoragePasswordMsg,c_Red,t_Hint);
      end;
      exit;
    end;
    }
    try
      if Assigned(zPlugOfEngine.PlayObjectUserCmd) then begin
        if zPlugOfEngine.PlayObjectUserCmd(Self,
          PChar(sCmd),
          PChar(sParam1),
          PChar(sParam2),
          PChar(sParam3),
          PChar(sParam4),
          PChar(sParam5),
          PChar(sParam6),
          PChar(sParam7)) then Exit;
      end;
    except
    end;
    if CompareText(sCmd, g_GameCommand.MEMBERFUNCTION.sCmd) = 0 then begin
      CmdMemberFunction(g_GameCommand.MEMBERFUNCTION.sCmd, sParam1);
      Exit;
    end;
    if CompareText(sCmd, g_GameCommand.MEMBERFUNCTIONEX.sCmd) = 0 then begin
      CmdMemberFunctionEx(g_GameCommand.MEMBERFUNCTIONEX.sCmd, sParam1);
      Exit;
    end;
    if CompareText(sCmd, g_GameCommand.REMTEMSG.sCmd) = 0 then begin
      m_boRemoteMsg := True;
      SysMsg('允许接受消息。', c_Green, t_Hint);
      Exit;
    end;
    if CompareText(sCmd, g_GameCommand.DEAR.sCmd) = 0 then begin
      CmdSearchDear(g_GameCommand.DEAR.sCmd, sParam1);
      Exit;
    end;
    if CompareText(sCmd, g_GameCommand.MASTER.sCmd) = 0 then begin
      CmdSearchMaster(g_GameCommand.MASTER.sCmd, sParam1);
      Exit;
    end;
    if CompareText(sCmd, g_GameCommand.MASTERECALL.sCmd) = 0 then begin
      CmdMasterRecall(g_GameCommand.MASTERECALL.sCmd, sParam1);
      Exit;
    end;
    if CompareText(sCmd, g_GameCommand.DEARRECALL.sCmd) = 0 then begin
      CmdDearRecall(g_GameCommand.DEARRECALL.sCmd, sParam1);
      Exit;
    end;
    if CompareText(sCmd, g_GameCommand.ALLOWDEARRCALL.sCmd) = 0 then begin
      m_boCanDearRecall := not m_boCanDearRecall;
      if m_boCanDearRecall then begin
        SysMsg(g_sEnableDearRecall {'允许夫妻传送！！！'}, c_Blue, t_Hint);
      end else begin
        SysMsg(g_sDisableDearRecall {'禁止夫妻传送！！！'}, c_Blue, t_Hint);
      end;
      Exit;
    end;
    if CompareText(sCmd, g_GameCommand.ALLOWMASTERRECALL.sCmd) = 0 then begin
      m_boCanMasterRecall := not m_boCanMasterRecall;
      if m_boCanMasterRecall then begin
        SysMsg(g_sEnableMasterRecall {'允许师徒传送！！！'}, c_Blue, t_Hint);
      end else begin
        SysMsg(g_sDisableMasterRecall {'禁止师徒传送！！！'}, c_Blue, t_Hint);
      end;
      Exit;
    end;

    if CompareText(sCmd, g_GameCommand.Data.sCmd) = 0 then begin
      SysMsg(g_sNowCurrDateTime {'当前日期时间: '} + FormatDateTime('dddddd,dddd,hh:mm:nn', Now), c_Blue, t_Hint);
      Exit;
    end;
    if CompareText(sCmd, g_GameCommand.PRVMSG.sCmd) = 0 then begin
      CmdPrvMsg(g_GameCommand.PRVMSG.sCmd, g_GameCommand.PRVMSG.nPermissionMin, sParam1);
      Exit;
    end;

    if CompareText(sCmd, g_GameCommand.AllowReAlive.sCmd) = 0 then begin
      m_boAllowReAlive := not m_boAllowReAlive;
      if m_boAllowReAlive then SysMsg(g_sEnableAllowRebirth {'[允许复活]'}, c_Green, t_Hint)
      else SysMsg(g_sDisableAllowRebirth {'[禁止复活]'}, c_Green, t_Hint);
      Exit;
    end;


    //这里就是实现命令的部分看到没有这里全部是命令   随便找个地方加上
    if CompareText(sCmd, g_GameCommand.ALLOWMSG.sCmd) = 0 then begin
      m_boHearWhisper := not m_boHearWhisper;
      if m_boHearWhisper then SysMsg(g_sEnableHearWhisper {'[允许私聊]'}, c_Green, t_Hint)
      else SysMsg(g_sDisableHearWhisper {'[禁止私聊]'}, c_Green, t_Hint);
      Exit;
    end;

    if CompareText(sCmd, g_GameCommand.USERITEM.sCmd) = 0 then begin
      //这里定义一个过程来实现这个命令，这个命令比较复杂一点
      CmdGetUserItem(@g_GameCommand.USERITEM, sParam1);
      Exit;
    end;


    if CompareText(sCmd, g_GameCommand.LETSHOUT.sCmd) = 0 then begin
      m_boBanShout := not m_boBanShout;
      if m_boBanShout then SysMsg(g_sEnableShoutMsg {'[允许群聊]'}, c_Green, t_Hint)
      else SysMsg(g_sDisableShoutMsg {'[禁止群聊]'}, c_Green, t_Hint);
      Exit;
    end;
    if CompareText(sCmd, g_GameCommand.LETTRADE.sCmd) = 0 then begin
      m_boAllowDeal := not m_boAllowDeal;
      if m_boAllowDeal then SysMsg(g_sEnableDealMsg {'[允许交易]'}, c_Green, t_Hint)
      else SysMsg(g_sDisableDealMsg {'[禁止交易]'}, c_Green, t_Hint);
      Exit;
    end;
    if CompareText(sCmd, g_GameCommand.BANGUILDCHAT.sCmd) = 0 then begin
      m_boBanGuildChat := not m_boBanGuildChat;
      if m_boBanGuildChat then SysMsg(g_sEnableGuildChat {'[允许行会聊天]'}, c_Green, t_Hint)
      else SysMsg(g_sDisableGuildChat {'[禁止行会聊天]'}, c_Green, t_Hint);
      Exit;
    end;

    if CompareText(sCmd, g_GameCommand.LETGUILD.sCmd) = 0 then begin
      m_boAllowGuild := not m_boAllowGuild;
      if m_boAllowGuild then SysMsg(g_sEnableJoinGuild {'[允许加入行会]'}, c_Green, t_Hint)
      else SysMsg(g_sDisableJoinGuild {'[禁止加入行会]'}, c_Green, t_Hint);
      Exit;
    end;
    if CompareText(sCmd, g_GameCommand.ENDGUILD.sCmd) = 0 then begin
      CmdEndGuild();
      Exit;
    end;

    if CompareText(sCmd, g_GameCommand.AUTHALLY.sCmd) = 0 then begin
      if IsGuildMaster then begin
        TGUild(m_MyGuild).m_boEnableAuthAlly := not TGUild(m_MyGuild).m_boEnableAuthAlly;
        if TGUild(m_MyGuild).m_boEnableAuthAlly then SysMsg(g_sEnableAuthAllyGuild {'[允许行会联盟]'}, c_Green, t_Hint)
        else SysMsg(g_sDisableAuthAllyGuild {'[禁止行会联盟]'}, c_Green, t_Hint);
      end;
      Exit;
    end;
    if CompareText(sCmd, g_GameCommand.ALLOWGROUPCALL.sCmd) = 0 then begin
      CmdAllowGroupReCall(sCmd, sParam1);
      Exit;
    end;
    if CompareText(sCmd, g_GameCommand.GROUPRECALLL.sCmd) = 0 then begin
      CmdGroupRecall(g_GameCommand.GROUPRECALLL.sCmd);
      Exit;
    end;
    if CompareText(sCmd, g_GameCommand.ALLOWGUILDRECALL.sCmd) = 0 then begin
      m_boAllowGuildReCall := not m_boAllowGuildReCall;
      if m_boAllowGuildReCall then SysMsg(g_sEnableGuildRecall {'[允许行会合一]'}, c_Green, t_Hint)
      else SysMsg(g_sDisableGuildRecall {'[禁止行会合一]'}, c_Green, t_Hint);
      Exit;
    end;
    if CompareText(sCmd, g_GameCommand.GUILDRECALLL.sCmd) = 0 then begin
      CmdGuildRecall(g_GameCommand.GUILDRECALLL.sCmd, sParam1);
      Exit;
    end;
    if CompareText(sCmd, g_GameCommand.AUTH.sCmd) = 0 then begin
      if IsGuildMaster then ClientGuildAlly();
      Exit;
    end;
    if CompareText(sCmd, g_GameCommand.AUTHCANCEL.sCmd) = 0 then begin
      if IsGuildMaster then ClientGuildBreakAlly(sParam1);
      Exit;
    end;

    if CompareText(sCmd, g_GameCommand.DIARY.sCmd) = 0 then begin
      CmdViewDiary(g_GameCommand.DIARY.sCmd, Str_ToInt(sParam1, 0));
      Exit;
    end;

    if CompareText(sCmd, g_GameCommand.ATTACKMODE.sCmd) = 0 then begin
      CmdChangeAttackMode(Str_ToInt(sParam1, -1), sParam1, sParam2, sParam3, sParam4, sParam5, sParam6, sParam7);
      Exit;
    end;
    if CompareText(sCmd, g_GameCommand.REST.sCmd) = 0 then begin
      CmdChangeSalveStatus();
      Exit;
    end;
    if CompareText(sCmd, g_GameCommand.TAKEONHORSE.sCmd) = 0 then begin
      CmdTakeOnHorse(sCmd, sParam1);
      Exit;
    end;
    if CompareText(sCmd, g_GameCommand.TAKEOFHORSE.sCmd) = 0 then begin
      CmdTakeOffHorse(sCmd, sParam1);
      Exit;
    end;

    if CompareText(sCmd, g_GameCommand.TESTGA.sCmd) = 0 then begin //004D25C5
      Exit;
      SendMsg(Self, RM_PASSWORD, 0, 0, 0, 0, '');
      m_boTestGa := True;
      SysMsg(g_sPleaseInputPassword {'请输入密码:'}, c_Green, t_Hint);
      Exit;
    end;
    if CompareText(sCmd, g_GameCommand.MAPINFO.sCmd) = 0 then begin
      ShowMapInfo(sParam1, sParam2, sParam3);
      Exit;
    end;
    if CompareText(sCmd, g_GameCommand.CLEARBAG.sCmd) = 0 then begin
      CmdClearBagItem(@g_GameCommand.CLEARBAG, sParam1);
      Exit;
    end;
    if CompareText(sCmd, g_GameCommand.SHOWUSEITEMINFO.sCmd) = 0 then begin
      CmdShowUseItemInfo(@g_GameCommand.SHOWUSEITEMINFO, sParam1);
      Exit;
    end;
    if CompareText(sCmd, g_GameCommand.BINDUSEITEM.sCmd) = 0 then begin
      CmdBindUseItem(@g_GameCommand.BINDUSEITEM, sParam1, sParam2, sParam3);
      Exit;
    end;
    if CompareText(sCmd, g_GameCommand.SBKDOOR.sCmd) = 0 then begin //004D2610
      CmdSbkDoorControl(g_GameCommand.SBKDOOR.sCmd, sParam1);
      Exit;
    end;
    if CompareText(sCmd, g_GameCommand.USERMOVE.sCmd) = 0 then begin
      CmdUserMoveXY(g_GameCommand.USERMOVE.sCmd, sParam1, sParam2);
      Exit;
    end;
    if CompareText(sCmd, g_GameCommand.SEARCHING.sCmd) = 0 then begin
      CmdSearchHuman(g_GameCommand.SEARCHING.sCmd, sParam1);
      Exit;
    end;
    if CompareText(sCmd, g_GameCommand.LOCKLOGON.sCmd) = 0 then begin
      CmdLockLogin(@g_GameCommand.LOCKLOGON);
      Exit;
    end;
    if (m_btPermission >= 2) and (Length(sData) > 2) then begin
      //if sData[2] = '!' then begin
      if (m_btPermission >= 6) and (sData[2] = g_GMRedMsgCmd) then begin

        if GetTickCount - m_dwSayMsgTick > 2000 then begin
          m_dwSayMsgTick := GetTickCount();
          sData := Copy(sData, 3, Length(sData) - 2);
          if Length(sData) > g_Config.nSayRedMsgMaxLen then begin
            sData := Copy(sData, 1, g_Config.nSayRedMsgMaxLen);
          end;

          if g_Config.boShutRedMsgShowGMName then
            SC := m_sCharName + ': ' + sData
          else SC := sData;
          UserEngine.SendBroadCastMsg(SC, t_GM);
        end;
        Exit;
      end;
    end;
    //004D2C70
    if CompareText(sCmd, g_GameCommand.HUMANLOCAL.sCmd) = 0 then begin
      CmdHumanLocal(@g_GameCommand.HUMANLOCAL, sParam1);
      Exit;
    end;
    if CompareText(sCmd, g_GameCommand.Move.sCmd) = 0 then begin
      CmdMapMove(@g_GameCommand.Move, sParam1);
      Exit;
    end; //004D2CD0
    if CompareText(sCmd, g_GameCommand.POSITIONMOVE.sCmd) = 0 then begin
      CmdPositionMove(@g_GameCommand.POSITIONMOVE, sParam1, sParam2, sParam3);
      Exit;
    end;
    if CompareText(sCmd, g_GameCommand.INFO.sCmd) = 0 then begin
      CmdHumanInfo(@g_GameCommand.INFO, sParam1);
      Exit;
    end;
    if CompareText(sCmd, g_GameCommand.MOBLEVEL.sCmd) = 0 then begin
      CmdMobLevel(@g_GameCommand.MOBLEVEL, sParam1);
      Exit;
    end;
    if CompareText(sCmd, g_GameCommand.MOBCOUNT.sCmd) = 0 then begin
      CmdMobCount(@g_GameCommand.MOBCOUNT, sParam1);
      Exit;
    end;
    if CompareText(sCmd, g_GameCommand.HUMANCOUNT.sCmd) = 0 then begin
      CmdHumanCount(@g_GameCommand.HUMANCOUNT, sParam1);
      Exit;
    end;
    if CompareText(sCmd, g_GameCommand.KICK.sCmd) = 0 then begin
      CmdKickHuman(@g_GameCommand.KICK, sParam1);
      Exit;
    end;
    if CompareText(sCmd, g_GameCommand.TING.sCmd) = 0 then begin
      CmdTing(@g_GameCommand.TING, sParam1);
      Exit;
    end;
    if CompareText(sCmd, g_GameCommand.SUPERTING.sCmd) = 0 then begin
      CmdSuperTing(@g_GameCommand.SUPERTING, sParam1, sParam2);
      Exit;
    end;
    if CompareText(sCmd, g_GameCommand.MAPMOVE.sCmd) = 0 then begin
      CmdMapMoveHuman(@g_GameCommand.MAPMOVE, sParam1, sParam2);
      Exit;
    end;
    if CompareText(sCmd, g_GameCommand.SHUTUP.sCmd) = 0 then begin
      CmdShutup(@g_GameCommand.SHUTUP, sParam1, sParam2);
      Exit;
    end;
    if CompareText(sCmd, g_GameCommand.Map.sCmd) = 0 then begin
      CmdShowMapInfo(@g_GameCommand.Map, sParam1);
      Exit;
    end;
    if CompareText(sCmd, g_GameCommand.RELEASESHUTUP.sCmd) = 0 then begin
      CmdShutupRelease(@g_GameCommand.RELEASESHUTUP, sParam1, True);
      Exit;
    end;
    if CompareText(sCmd, g_GameCommand.SHUTUPLIST.sCmd) = 0 then begin
      CmdShutupList(@g_GameCommand.SHUTUPLIST, sParam1);
      Exit;
    end;
    if CompareText(sCmd, g_GameCommand.GAMEMASTER.sCmd) = 0 then begin
      CmdChangeAdminMode(g_GameCommand.GAMEMASTER.sCmd, g_GameCommand.GAMEMASTER.nPermissionMin, sParam1, not m_boAdminMode);
      Exit;
    end;
    if CompareText(sCmd, g_GameCommand.OBSERVER.sCmd) = 0 then begin
      CmdChangeObMode(g_GameCommand.OBSERVER.sCmd, g_GameCommand.OBSERVER.nPermissionMin, sParam1, not m_boObMode);
      Exit;
    end;
    if CompareText(sCmd, g_GameCommand.SUEPRMAN.sCmd) = 0 then begin
      CmdChangeSuperManMode(g_GameCommand.OBSERVER.sCmd, g_GameCommand.OBSERVER.nPermissionMin, sParam1, not m_boSuperMan);
      Exit;
    end;
    if CompareText(sCmd, g_GameCommand.Level.sCmd) = 0 then begin
      CmdChangeLevel(@g_GameCommand.Level, sParam1);
      Exit;
    end;
    if CompareText(sCmd, g_GameCommand.SABUKWALLGOLD.sCmd) = 0 then begin
      CmdShowSbkGold(@g_GameCommand.SABUKWALLGOLD, sParam1, sParam2, sParam3);
      Exit;
    end;
    if CompareText(sCmd, g_GameCommand.RECALL.sCmd) = 0 then begin
      CmdRecallHuman(@g_GameCommand.RECALL, sParam1);
      Exit;
    end;
    if CompareText(sCmd, g_GameCommand.REGOTO.sCmd) = 0 then begin
      CmdReGotoHuman(@g_GameCommand.REGOTO, sParam1);
      Exit;
    end;
    if CompareText(sCmd, g_GameCommand.SHOWFLAG.sCmd) = 0 then begin
      CmdShowHumanFlag(g_GameCommand.SHOWFLAG.sCmd, g_GameCommand.SHOWFLAG.nPermissionMin, sParam1, sParam2);
      Exit;
    end;
    if CompareText(sCmd, g_GameCommand.SHOWOPEN.sCmd) = 0 then begin
      CmdShowHumanUnitOpen(g_GameCommand.SHOWOPEN.sCmd, g_GameCommand.SHOWOPEN.nPermissionMin, sParam1, sParam2);
      Exit;
    end;
    if CompareText(sCmd, g_GameCommand.SHOWUNIT.sCmd) = 0 then begin
      CmdShowHumanUnit(g_GameCommand.SHOWUNIT.sCmd, g_GameCommand.SHOWUNIT.nPermissionMin, sParam1, sParam2);
      Exit;
    end;
    if CompareText(sCmd, g_GameCommand.Attack.sCmd) = 0 then begin
      Exit;
    end;
    if CompareText(sCmd, g_GameCommand.MOB.sCmd) = 0 then begin
      CmdMob(@g_GameCommand.MOB, sParam1, Str_ToInt(sParam2, 0), Str_ToInt(sParam3, 0));
      Exit;
    end;
    if CompareText(sCmd, g_GameCommand.MOBNPC.sCmd) = 0 then begin
      CmdMobNpc(g_GameCommand.MOBNPC.sCmd, g_GameCommand.MOBNPC.nPermissionMin, sParam1, sParam2, sParam3, sParam4);
      Exit;
    end;
    if CompareText(sCmd, g_GameCommand.NPCSCRIPT.sCmd) = 0 then begin
      CmdNpcScript(g_GameCommand.NPCSCRIPT.sCmd, g_GameCommand.NPCSCRIPT.nPermissionMin, sParam1, sParam2, sParam3);
      Exit;
    end;
    if CompareText(sCmd, g_GameCommand.DELNPC.sCmd) = 0 then begin
      CmdDelNpc(g_GameCommand.DELNPC.sCmd, g_GameCommand.DELNPC.nPermissionMin, sParam1);
      Exit;
    end;
    if CompareText(sCmd, g_GameCommand.RECALLMOB.sCmd) = 0 then begin
      CmdRecallMob(@g_GameCommand.RECALLMOB, sParam1, Str_ToInt(sParam2, 0), Str_ToInt(sParam3, 0), Str_ToInt(sParam4, 0), Str_ToInt(sParam5, 0));
      Exit;
    end;
    if CompareText(sCmd, g_GameCommand.LUCKYPOINT.sCmd) = 0 then begin
      CmdLuckPoint(g_GameCommand.LUCKYPOINT.sCmd, g_GameCommand.LUCKYPOINT.nPermissionMin, sParam1, sParam2, sParam3);
      Exit;
    end;
    if CompareText(sCmd, g_GameCommand.LOTTERYTICKET.sCmd) = 0 then begin
      CmdLotteryTicket(g_GameCommand.LOTTERYTICKET.sCmd, g_GameCommand.LOTTERYTICKET.nPermissionMin, sParam1);
      Exit;
    end;
    if CompareText(sCmd, g_GameCommand.RELOADGUILD.sCmd) = 0 then begin
      CmdReloadGuild(g_GameCommand.RELOADGUILD.sCmd, g_GameCommand.RELOADGUILD.nPermissionMin, sParam1);
      Exit;
    end;
    if CompareText(sCmd, g_GameCommand.RELOADLINENOTICE.sCmd) = 0 then begin
      CmdReloadLineNotice(g_GameCommand.RELOADLINENOTICE.sCmd, g_GameCommand.RELOADLINENOTICE.nPermissionMin, sParam1);
      Exit;
    end;
    if CompareText(sCmd, g_GameCommand.RELOADABUSE.sCmd) = 0 then begin
      CmdReloadAbuse(g_GameCommand.RELOADABUSE.sCmd, g_GameCommand.RELOADABUSE.nPermissionMin, sParam1);
      Exit;
    end;
    if CompareText(sCmd, g_GameCommand.FREEPENALTY.sCmd) = 0 then begin
      CmdFreePenalty(@g_GameCommand.FREEPENALTY, sParam1);
      Exit;
    end;
    if CompareText(sCmd, g_GameCommand.PKPOINT.sCmd) = 0 then begin
      CmdPKpoint(@g_GameCommand.PKPOINT, sParam1);
      Exit;
    end;
    if CompareText(sCmd, g_GameCommand.IncPkPoint.sCmd) = 0 then begin
      CmdIncPkPoint(@g_GameCommand.IncPkPoint, sParam1, Str_ToInt(sParam2, 0));
      Exit;
    end;
    if CompareText(sCmd, g_GameCommand.MAKE.sCmd) = 0 then begin
      CmdMakeItem(@g_GameCommand.MAKE, sParam1, Str_ToInt(sParam2, 0));
      Exit;
    end;
    if CompareText(sCmd, g_GameCommand.VIEWWHISPER.sCmd) = 0 then begin
      CmdViewWhisper(@g_GameCommand.VIEWWHISPER, sParam1, sParam2);
      Exit;
    end;
    if CompareText(sCmd, g_GameCommand.ReAlive.sCmd) = 0 then begin
      CmdReAlive(@g_GameCommand.ReAlive, sParam1);
      Exit;
    end;
    if CompareText(sCmd, g_GameCommand.KILL.sCmd) = 0 then begin
      CmdKill(@g_GameCommand.KILL, sParam1);
      Exit;
    end;
    if CompareText(sCmd, g_GameCommand.SMAKE.sCmd) = 0 then begin
      CmdSmakeItem(@g_GameCommand.SMAKE, Str_ToInt(sParam1, 0), Str_ToInt(sParam2, 0), Str_ToInt(sParam3, 0));
      Exit;
    end;
    if CompareText(sCmd, g_GameCommand.CHANGEJOB.sCmd) = 0 then begin
      CmdChangeJob(@g_GameCommand.CHANGEJOB, sParam1, sParam2);
      Exit;
    end;
    if CompareText(sCmd, g_GameCommand.CHANGEGENDER.sCmd) = 0 then begin
      CmdChangeGender(@g_GameCommand.CHANGEGENDER, sParam1, sParam2);
      Exit;
    end;
    if CompareText(sCmd, g_GameCommand.HAIR.sCmd) = 0 then begin
      CmdHair(@g_GameCommand.HAIR, sParam1, Str_ToInt(sParam2, 0));
      Exit;
    end;
    if CompareText(sCmd, g_GameCommand.BonusPoint.sCmd) = 0 then begin
      CmdBonuPoint(@g_GameCommand.BonusPoint, sParam1, Str_ToInt(sParam2, 0));
      Exit;
    end;
    if CompareText(sCmd, g_GameCommand.DELBONUSPOINT.sCmd) = 0 then begin
      CmdDelBonuPoint(@g_GameCommand.DELBONUSPOINT, sParam1);
      Exit;
    end;
    if CompareText(sCmd, g_GameCommand.RESTBONUSPOINT.sCmd) = 0 then begin
      CmdRestBonuPoint(@g_GameCommand.RESTBONUSPOINT, sParam1);
      Exit;
    end;
    if CompareText(sCmd, g_GameCommand.SETPERMISSION.sCmd) = 0 then begin
      CmdSetPermission(@g_GameCommand.SETPERMISSION, sParam1, sParam2);
      Exit;
    end;
    if CompareText(sCmd, g_GameCommand.RENEWLEVEL.sCmd) = 0 then begin
      CmdReNewLevel(@g_GameCommand.RENEWLEVEL, sParam1, sParam2);
      Exit;
    end;
    if CompareText(sCmd, g_GameCommand.DELGOLD.sCmd) = 0 then begin
      CmdDelGold(@g_GameCommand.DELGOLD, sParam1, Str_ToInt(sParam2, 0));
      Exit;
    end;
    if CompareText(sCmd, g_GameCommand.ADDGOLD.sCmd) = 0 then begin
      CmdAddGold(@g_GameCommand.ADDGOLD, sParam1, Str_ToInt(sParam2, 0));
      Exit;
    end;
    if CompareText(sCmd, g_GameCommand.GAMEGOLD.sCmd) = 0 then begin
      CmdGameGold(@g_GameCommand.GAMEGOLD, sParam1, sParam2, Str_ToInt(sParam3, 0));
      Exit;
    end;
    if CompareText(sCmd, g_GameCommand.GAMEPOINT.sCmd) = 0 then begin
      CmdGamePoint(@g_GameCommand.GAMEPOINT, sParam1, sParam2, Str_ToInt(sParam3, 0));
      Exit;
    end;
    if CompareText(sCmd, g_GameCommand.CREDITPOINT.sCmd) = 0 then begin
      CmdCreditPoint(@g_GameCommand.CREDITPOINT, sParam1, sParam2, Str_ToInt(sParam3, 0));
      Exit;
    end;
    if CompareText(sCmd, g_GameCommand.TRAINING.sCmd) = 0 then begin
      CmdTrainingSkill(@g_GameCommand.TRAINING, sParam1, sParam2, Str_ToInt(sParam3, 0));
      Exit;
    end;
    if CompareText(sCmd, g_GameCommand.DELETEITEM.sCmd) = 0 then begin
      CmdDeleteItem(@g_GameCommand.DELETEITEM, sParam1, sParam2, Str_ToInt(sParam3, 1));
      Exit;
    end;
    if CompareText(sCmd, g_GameCommand.DELETESKILL.sCmd) = 0 then begin
      CmdDelSkill(@g_GameCommand.DELETESKILL, sParam1, sParam2);
      Exit;
    end;
    if CompareText(sCmd, g_GameCommand.TRAININGSKILL.sCmd) = 0 then begin
      CmdTrainingMagic(@g_GameCommand.TRAININGSKILL, sParam1, sParam2, Str_ToInt(sParam3, 0));
      Exit;
    end;
    if CompareText(sCmd, g_GameCommand.CLEARMISSION.sCmd) = 0 then begin
      CmdClearMission(@g_GameCommand.CLEARMISSION, sParam1);
      Exit;
    end;
    if CompareText(sCmd, g_GameCommand.STARTQUEST.sCmd) = 0 then begin
      CmdStartQuest(@g_GameCommand.STARTQUEST, sParam1);
      Exit;
    end;
    if CompareText(sCmd, g_GameCommand.DENYIPLOGON.sCmd) = 0 then begin
      CmdDenyIPaddrLogon(@g_GameCommand.DENYIPLOGON, sParam1, sParam2);
      Exit;
    end;
    if CompareText(sCmd, g_GameCommand.CHANGEDEARNAME.sCmd) = 0 then begin
      CmdChangeDearName(@g_GameCommand.CHANGEDEARNAME, sParam1, sParam2);
      Exit;
    end;
    if CompareText(sCmd, g_GameCommand.CHANGEMASTERNAME.sCmd) = 0 then begin
      CmdChangeMasterName(@g_GameCommand.CHANGEMASTERNAME, sParam1, sParam2, sParam3);
      Exit;
    end;
    if CompareText(sCmd, g_GameCommand.CLEARMON.sCmd) = 0 then begin
      CmdClearMapMonster(@g_GameCommand.CLEARMON, sParam1, sParam2, sParam3);
      Exit;
    end;
    if CompareText(sCmd, g_GameCommand.DENYACCOUNTLOGON.sCmd) = 0 then begin
      CmdDenyAccountLogon(@g_GameCommand.DENYACCOUNTLOGON, sParam1, sParam2);
      Exit;
    end;
    if CompareText(sCmd, g_GameCommand.DENYCHARNAMELOGON.sCmd) = 0 then begin
      CmdDenyCharNameLogon(@g_GameCommand.DENYCHARNAMELOGON, sParam1, sParam2);
      Exit;
    end;
    if CompareText(sCmd, g_GameCommand.DELDENYIPLOGON.sCmd) = 0 then begin
      CmdDelDenyIPaddrLogon(@g_GameCommand.DELDENYIPLOGON, sParam1, sParam2);
      Exit;
    end;
    if CompareText(sCmd, g_GameCommand.DELDENYACCOUNTLOGON.sCmd) = 0 then begin
      CmdDelDenyAccountLogon(@g_GameCommand.DELDENYACCOUNTLOGON, sParam1, sParam2);
      Exit;
    end;
    if CompareText(sCmd, g_GameCommand.DELDENYCHARNAMELOGON.sCmd) = 0 then begin
      CmdDelDenyCharNameLogon(@g_GameCommand.DELDENYCHARNAMELOGON, sParam1, sParam2);
      Exit;
    end;
    if CompareText(sCmd, g_GameCommand.SHOWDENYIPLOGON.sCmd) = 0 then begin
      CmdShowDenyIPaddrLogon(@g_GameCommand.SHOWDENYIPLOGON, sParam1, sParam2);
      Exit;
    end;
    if CompareText(sCmd, g_GameCommand.SHOWDENYACCOUNTLOGON.sCmd) = 0 then begin
      CmdShowDenyAccountLogon(@g_GameCommand.SHOWDENYACCOUNTLOGON, sParam1, sParam2);
      Exit;
    end;
    if CompareText(sCmd, g_GameCommand.SHOWDENYCHARNAMELOGON.sCmd) = 0 then begin
      CmdShowDenyCharNameLogon(@g_GameCommand.SHOWDENYCHARNAMELOGON, sParam1, sParam2);
      Exit;
    end;
    if CompareText(sCmd, g_GameCommand.Mission.sCmd) = 0 then begin
      CmdMission(@g_GameCommand.Mission, sParam1, sParam2);
      Exit;
    end;
    if CompareText(sCmd, g_GameCommand.MobPlace.sCmd) = 0 then begin
      CmdMobPlace(@g_GameCommand.MobPlace, sParam1, sParam2, sParam3, sParam4);
      Exit;
    end;
    if CompareText(sCmd, g_GameCommand.SETMAPMODE.sCmd) = 0 then begin
      CmdSetMapMode(g_GameCommand.SETMAPMODE.sCmd, sParam1, sParam2, sParam3, sParam4);
      Exit;
    end;
    if CompareText(sCmd, g_GameCommand.SHOWMAPMODE.sCmd) = 0 then begin
      CmdShowMapMode(g_GameCommand.SHOWMAPMODE.sCmd, sParam1);
      Exit;
    end;
    if CompareText(sCmd, g_GameCommand.CLRPASSWORD.sCmd) = 0 then begin
      CmdClearHumanPassword(g_GameCommand.CLRPASSWORD.sCmd, g_GameCommand.CLRPASSWORD.nPermissionMin, sParam1);
      Exit;
    end;
    if CompareText(sCmd, g_GameCommand.CONTESTPOINT.sCmd) = 0 then begin
      CmdContestPoint(@g_GameCommand.CONTESTPOINT, sParam1);
      Exit;
    end;
    if CompareText(sCmd, g_GameCommand.STARTCONTEST.sCmd) = 0 then begin
      CmdStartContest(@g_GameCommand.STARTCONTEST, sParam1);
      Exit;
    end;
    if CompareText(sCmd, g_GameCommand.ENDCONTEST.sCmd) = 0 then begin
      CmdEndContest(@g_GameCommand.ENDCONTEST, sParam1);
      Exit;
    end;
    if CompareText(sCmd, g_GameCommand.ANNOUNCEMENT.sCmd) = 0 then begin
      CmdAnnouncement(@g_GameCommand.ANNOUNCEMENT, sParam1);
      Exit;
    end;
    if CompareText(sCmd, g_GameCommand.DISABLESENDMSG.sCmd) = 0 then begin
      CmdDisableSendMsg(@g_GameCommand.DISABLESENDMSG, sParam1);
      Exit;
    end;
    if CompareText(sCmd, g_GameCommand.ENABLESENDMSG.sCmd) = 0 then begin
      CmdEnableSendMsg(@g_GameCommand.ENABLESENDMSG, sParam1);
      Exit;
    end;
    if CompareText(sCmd, g_GameCommand.REFINEWEAPON.sCmd) = 0 then begin
      CmdRefineWeapon(@g_GameCommand.REFINEWEAPON, Str_ToInt(sParam1, 0), Str_ToInt(sParam2, 0), Str_ToInt(sParam3, 0), Str_ToInt(sParam4, 0));
      Exit;
    end;
    if CompareText(sCmd, g_GameCommand.DISABLESENDMSGLIST.sCmd) = 0 then begin
      CmdDisableSendMsgList(@g_GameCommand.DISABLESENDMSGLIST);
      Exit;
    end;
    if m_btPermission > 4 then begin
      if CompareText(sCmd, g_GameCommand.BACKSTEP.sCmd) = 0 then begin
        CmdBackStep(sCmd, Str_ToInt(sParam1, 0), Str_ToInt(sParam2, 1));
        Exit;
      end;
      if CompareText(sCmd, g_GameCommand.BALL.sCmd) = 0 then begin //精神波
        Exit;
      end;

      if CompareText(sCmd, g_GameCommand.CHANGELUCK.sCmd) = 0 then begin
        Exit;
      end;
      if CompareText(sCmd, g_GameCommand.HUNGER.sCmd) = 0 then begin
        CmdHunger(g_GameCommand.HUNGER.sCmd, sParam1, Str_ToInt(sParam2, 0));
        Exit;
      end;

      if CompareText(sCmd, g_GameCommand.NAMECOLOR.sCmd) = 0 then begin
        Exit;
      end;

      if CompareText(sCmd, g_GameCommand.TRANSPARECY.sCmd) = 0 then begin
        Exit;
      end;
      if CompareText(sCmd, g_GameCommand.LEVEL0.sCmd) = 0 then begin
        Exit;
      end;

      if CompareText(sCmd, g_GameCommand.SETFLAG.sCmd) = 0 then begin //004D3BDD
        PlayObject := UserEngine.GetPlayObject(sParam1);
        if PlayObject <> nil then begin
          nFlag := Str_ToInt(sParam2, 0);
          nValue := Str_ToInt(sParam3, 0);
          PlayObject.SetQuestFlagStatus(nFlag, nValue);
          if PlayObject.GetQuestFalgStatus(nFlag) = 1 then begin
            SysMsg(PlayObject.m_sCharName + ': [' + IntToStr(nFlag) + '] = ON', c_Green, t_Hint);
          end else begin
            SysMsg(PlayObject.m_sCharName + ': [' + IntToStr(nFlag) + '] = OFF', c_Green, t_Hint);
          end;
        end else begin
          SysMsg('@' + g_GameCommand.SETFLAG.sCmd + ' 人物名称 标志号 数字(0 - 1)', c_Red, t_Hint);
        end;
        Exit;
      end;
      if CompareText(sCmd, g_GameCommand.SETOPEN.sCmd) = 0 then begin
        PlayObject := UserEngine.GetPlayObject(sParam1);
        if PlayObject <> nil then begin
          nFlag := Str_ToInt(sParam2, 0);
          nValue := Str_ToInt(sParam3, 0);
          PlayObject.SetQuestUnitOpenStatus(nFlag, nValue);
          if PlayObject.GetQuestUnitOpenStatus(nFlag) = 1 then begin
            SysMsg(PlayObject.m_sCharName + ': [' + IntToStr(nFlag) + '] = ON', c_Green, t_Hint);
          end else begin
            SysMsg(PlayObject.m_sCharName + ': [' + IntToStr(nFlag) + '] = OFF', c_Green, t_Hint);
          end;
        end else begin
          SysMsg('@' + g_GameCommand.SETOPEN.sCmd + ' 人物名称 标志号 数字(0 - 1)', c_Red, t_Hint);
        end;
        Exit;
      end;
      if CompareText(sCmd, g_GameCommand.SETUNIT.sCmd) = 0 then begin
        PlayObject := UserEngine.GetPlayObject(sParam1);
        if PlayObject <> nil then begin
          nFlag := Str_ToInt(sParam2, 0);
          nValue := Str_ToInt(sParam3, 0);
          PlayObject.SetQuestUnitStatus(nFlag, nValue);
          if PlayObject.GetQuestUnitStatus(nFlag) = 1 then begin
            SysMsg(PlayObject.m_sCharName + ': [' + IntToStr(nFlag) + '] = ON', c_Green, t_Hint);
          end else begin
            SysMsg(PlayObject.m_sCharName + ': [' + IntToStr(nFlag) + '] = OFF', c_Green, t_Hint);
          end;
        end else begin
          SysMsg('@' + g_GameCommand.SETUNIT.sCmd + ' 人物名称 标志号 数字(0 - 1)', c_Red, t_Hint);
        end;
        Exit;
      end;
      if CompareText(sCmd, g_GameCommand.RECONNECTION.sCmd) = 0 then begin
        CmdReconnection(sCmd, sParam1, sParam2);
        Exit;
      end;
      if CompareText(sCmd, g_GameCommand.DISABLEFILTER.sCmd) = 0 then begin
        CmdDisableFilter(sCmd, sParam1);
        Exit;
      end;
      if CompareText(sCmd, g_GameCommand.CHGUSERFULL.sCmd) = 0 then begin
        CmdChangeUserFull(sCmd, sParam1);
        Exit;
      end;
      if CompareText(sCmd, g_GameCommand.CHGZENFASTSTEP.sCmd) = 0 then begin
        CmdChangeZenFastStep(sCmd, sParam1);
        Exit;
      end;

      if CompareText(sCmd, g_GameCommand.OXQUIZROOM.sCmd) = 0 then begin
        Exit;
      end;
      if CompareText(sCmd, g_GameCommand.GSA.sCmd) = 0 then begin
        Exit;
      end;
      if CompareText(sCmd, g_GameCommand.CHANGEITEMNAME.sCmd) = 0 then begin
        CmdChangeItemName(g_GameCommand.CHANGEITEMNAME.sCmd, sParam1, sParam2, sParam3);
        Exit;
      end;
      if (m_btPermission >= 5) or (g_Config.boTestServer) then begin

        if CompareText(sCmd, g_GameCommand.FIREBURN.sCmd) = 0 then begin
          CmdFireBurn(Str_ToInt(sParam1, 0), Str_ToInt(sParam2, 0), Str_ToInt(sParam3, 0));
          Exit;
        end;
        if CompareText(sCmd, g_GameCommand.TESTFIRE.sCmd) = 0 then begin
          CmdTestFire(sCmd, Str_ToInt(sParam1, 0), Str_ToInt(sParam2, 0), Str_ToInt(sParam3, 0), Str_ToInt(sParam4, 0));
          Exit;
        end;
        if CompareText(sCmd, g_GameCommand.TESTSTATUS.sCmd) = 0 then begin
          CmdTestStatus(sCmd, Str_ToInt(sParam1, -1), Str_ToInt(sParam2, 0));
          Exit;
        end;
        if CompareText(sCmd, g_GameCommand.DELGAMEGOLD.sCmd) = 0 then begin
          CmdDelGameGold(g_GameCommand.DELGAMEGOLD.sCmd, sParam1, Str_ToInt(sParam2, 0));
          Exit;
        end;
        if CompareText(sCmd, g_GameCommand.ADDGAMEGOLD.sCmd) = 0 then begin
          CmdAddGameGold(g_GameCommand.ADDGAMEGOLD.sCmd, sParam1, Str_ToInt(sParam2, 0));
          Exit;
        end;
        if CompareText(sCmd, g_GameCommand.TESTGOLDCHANGE.sCmd) = 0 then begin
          Exit;
        end;

        if CompareText(sCmd, g_GameCommand.RELOADADMIN.sCmd) = 0 then begin
          CmdReLoadAdmin(g_GameCommand.RELOADADMIN.sCmd);
          Exit;
        end;
        if CompareText(sCmd, g_GameCommand.ReLoadNpc.sCmd) = 0 then begin
          CmdReloadNpc(sParam1);
          Exit;
        end;
        if CompareText(sCmd, g_GameCommand.RELOADMANAGE.sCmd) = 0 then begin
          CmdReloadManage(@g_GameCommand.RELOADMANAGE, sParam1);
          Exit;
        end;
        if CompareText(sCmd, g_GameCommand.RELOADROBOTMANAGE.sCmd) = 0 then begin
          CmdReloadRobotManage();
          Exit;
        end;
        if CompareText(sCmd, g_GameCommand.RELOADROBOT.sCmd) = 0 then begin
          CmdReloadRobot();
          Exit;
        end;
        if CompareText(sCmd, g_GameCommand.RELOADMONITEMS.sCmd) = 0 then begin
          CmdReloadMonItems();
          Exit;
        end;
        if CompareText(sCmd, g_GameCommand.RELOADDIARY.sCmd) = 0 then begin
          Exit;
        end;
        if CompareText(sCmd, g_GameCommand.RELOADITEMDB.sCmd) = 0 then begin
          FrmDB.LoadItemsDB();
          SysMsg('物品数据库重新加载完成。', c_Green, t_Hint);
          Exit;
        end;
        if CompareText(sCmd, g_GameCommand.RELOADMAGICDB.sCmd) = 0 then begin
          FrmDB.LoadMagicDB();
          SysMsg('魔法数据库重新加载完成。', c_Green, t_Hint);
          Exit;
        end;
        if CompareText(sCmd, g_GameCommand.RELOADMONSTERDB.sCmd) = 0 then begin
          FrmDB.LoadMonsterDB();
          SysMsg('怪物数据库重新加载完成。', c_Green, t_Hint);
          Exit;
        end;
        if CompareText(sCmd, g_GameCommand.RELOADMINMAP.sCmd) = 0 then begin
          FrmDB.LoadMinMap();
          g_MapManager.ReSetMinMap();
          SysMsg('小地图配置重新加载完成。', c_Green, t_Hint);
          Exit;
        end;

        if CompareText(sCmd, g_GameCommand.ADJUESTLEVEL.sCmd) = 0 then begin
          CmdAdjuestLevel(@g_GameCommand.ADJUESTLEVEL, sParam1, Str_ToInt(sParam2, 1));
          Exit;
        end;
        if CompareText(sCmd, g_GameCommand.ADJUESTEXP.sCmd) = 0 then begin
          CmdAdjuestExp(@g_GameCommand.ADJUESTEXP, sParam1, sParam2);
          Exit;
        end;
        if CompareText(sCmd, g_GameCommand.AddGuild.sCmd) = 0 then begin
          CmdAddGuild(@g_GameCommand.AddGuild, sParam1, sParam2);
          Exit;
        end;
        if CompareText(sCmd, g_GameCommand.DELGUILD.sCmd) = 0 then begin
          CmdDelGuild(@g_GameCommand.DELGUILD, sParam1);
          Exit;
        end;
        if (CompareText(sCmd, g_GameCommand.CHANGESABUKLORD.sCmd) = 0) then begin
          CmdChangeSabukLord(@g_GameCommand.CHANGESABUKLORD, sParam1, sParam2, True);
          Exit;
        end;
        if CompareText(sCmd, g_GameCommand.FORCEDWALLCONQUESTWAR.sCmd) = 0 then begin
          CmdForcedWallconquestWar(@g_GameCommand.FORCEDWALLCONQUESTWAR, sParam1);
          Exit;
        end;
        if CompareText(sCmd, g_GameCommand.ADDTOITEMEVENT.sCmd) = 0 then begin
          Exit;
        end;
        if CompareText(sCmd, g_GameCommand.ADDTOITEMEVENTASPIECES.sCmd) = 0 then begin
          Exit;
        end;
        if CompareText(sCmd, g_GameCommand.ItemEventList.sCmd) = 0 then begin
          Exit;
        end;
        if CompareText(sCmd, g_GameCommand.STARTINGGIFTNO.sCmd) = 0 then begin
          Exit;
        end;
        if CompareText(sCmd, g_GameCommand.DELETEALLITEMEVENT.sCmd) = 0 then begin
          Exit;
        end else
          if CompareText(sCmd, g_GameCommand.STARTITEMEVENT.sCmd) = 0 then begin
          Exit;
        end else
          if CompareText(sCmd, g_GameCommand.ITEMEVENTTERM.sCmd) = 0 then begin
          Exit;
        end else
          if CompareText(sCmd, g_GameCommand.ADJUESTTESTLEVEL.sCmd) = 0 then begin
          Exit;
        end else
          if CompareText(sCmd, g_GameCommand.OPDELETESKILL.sCmd) = 0 then begin
          Exit;
        end else
          if CompareText(sCmd, g_GameCommand.CHANGEWEAPONDURA.sCmd) = 0 then begin
          Exit;
        end else
          if CompareText(sCmd, g_GameCommand.RELOADGUILDALL.sCmd) = 0 then begin
          Exit;
        end else
          if CompareText(sCmd, g_GameCommand.SPIRIT.sCmd) = 0 then begin
          CmdSpirtStart(g_GameCommand.SPIRIT.sCmd, sParam1);
          Exit;
        end else
          if CompareText(sCmd, g_GameCommand.SPIRITSTOP.sCmd) = 0 then begin
          CmdSpirtStop(g_GameCommand.SPIRITSTOP.sCmd, sParam1);
          Exit;
        end else
          if CompareText(sCmd, g_GameCommand.TESTSERVERCONFIG.sCmd) = 0 then begin
          SendServerConfig();
          Exit;
        end else
          if CompareText(sCmd, g_GameCommand.SERVERSTATUS.sCmd) = 0 then begin
          SendServerStatus();
          Exit;
        end else
          if CompareText(sCmd, g_GameCommand.TESTGETBAGITEM.sCmd) = 0 then begin
          CmdTestGetBagItems(@g_GameCommand.TESTGETBAGITEM, sParam1);
          Exit;
        end else
          if CompareText(sCmd, g_GameCommand.MOBFIREBURN.sCmd) = 0 then begin
          CmdMobFireBurn(@g_GameCommand.MOBFIREBURN, sParam1, sParam2, sParam3, sParam4, sParam5, sParam6);
          Exit;
        end else
          if CompareText(sCmd, g_GameCommand.TESTSPEEDMODE.sCmd) = 0 then begin
          CmdTestSpeedMode(@g_GameCommand.TESTSPEEDMODE);
          Exit;
        end

      end;
    end; //004D52B5
    SysMsg('@' + sCmd + ' 此命令不正确，或没有足够的权限！！！', c_Red, t_Hint);
  except
    on E: Exception do begin
      MainOutMessage(format(sExceptionMsg, [sData]));
      MainOutMessage(E.Message);
    end;
  end;
end;

procedure TPlayObject.ProcessSayMsg(sData: string);
var
  boDisableSayMsg: Boolean;
  SC, sCryCryMsg, sParam1, sCharName: string;
const
  s01 = '%d %d';
  S02 = '%s %d';
resourcestring
  sExceptionMsg = '[Exception] TPlayObject.ProcessSayMsg Msg = %s';
begin
  try
    if sData = '' then Exit;
    if (Length(sData) > 1) and (sData[1] = '|') then begin
      SC := Copy(sData, 2, Length(sData) - 1);
      if (SC[1] = 'C') and (SC[3] = 'U') and (SC[5] = 'T') then begin
        SysMsg(format(s01, [UserEngine.m_nLimitUserCount, UserEngine.m_nLimitNumber]), c_Red, t_Hint);
        Exit;
      end;
      if (SC[1] = 'O') and (SC[6] = 'E') and (SC[11] = 'T') then begin
        SysMsg(format(S02, [g_Config.sServerName, UserEngine.PlayObjectCount]), c_Red, t_Hint);
        Exit;
      end;
      if (SC[1] = 'V') and (SC[4] = 'S') and (SC[7] = 'N') then begin
        SysMsg(format(s01, [nVersion, nProductVersion]), c_Red, t_Hint);
        Exit;
      end;
      if (SC[1] = 'S') and (SC[5] = 'T') and (SC[9] = 'E') then begin
        SysMsg(GetStartTime(dwStartTime), c_Red, t_Hint);
        Exit;
      end;
    end;
    if Length(sData) > g_Config.nSayMsgMaxLen then begin
      sData := Copy(sData, 1, g_Config.nSayMsgMaxLen);
    end;

    if {(sData = m_sOldSayMsg) and}((GetTickCount - m_dwSayMsgTick) < g_Config.dwSayMsgTime {3 * 1000}) then begin
      Inc(m_nSayMsgCount);
      if m_nSayMsgCount >= g_Config.nSayMsgCount {2} then begin
        m_boDisableSayMsg := True;
        m_dwDisableSayMsgTick := GetTickCount + g_Config.dwDisableSayMsgTime {60 * 1000};
        SysMsg(format(g_sDisableSayMsg, [g_Config.dwDisableSayMsgTime div (60 * 1000)]), c_Red, t_Hint);
        //'[由于你重复发相同的内容，%d分钟内你将被禁止发言...]'
      end;
    end else begin
      m_dwSayMsgTick := GetTickCount();
      m_nSayMsgCount := 0;
    end;

    if GetTickCount >= m_dwDisableSayMsgTick then m_boDisableSayMsg := False;
    boDisableSayMsg := m_boDisableSayMsg;
    g_DenySayMsgList.Lock;
    try
      if g_DenySayMsgList.GetIndex(m_sCharName) >= 0 then boDisableSayMsg := True;
    finally
      g_DenySayMsgList.UnLock;
    end;
    if not boDisableSayMsg then begin
      m_sOldSayMsg := sData;
      if sData[1] = '/' then begin
        SC := Copy(sData, 2, Length(sData) - 1);
        if CompareText(Trim(SC), Trim(g_GameCommand.WHO.sCmd)) = 0 then begin
          if (m_btPermission < g_GameCommand.WHO.nPermissionMin) then begin
            SysMsg(g_sGameCommandPermissionTooLow, c_Red, t_Hint);
            Exit;
          end;
          HearMsg(format(g_sOnlineCountMsg, [UserEngine.PlayObjectCount]));
          Exit;
        end;
        if CompareText(Trim(SC), Trim(g_GameCommand.TOTAL.sCmd)) = 0 then begin
          if (m_btPermission < g_GameCommand.TOTAL.nPermissionMin) then begin
            SysMsg(g_sGameCommandPermissionTooLow, c_Red, t_Hint);
            Exit;
          end;
          HearMsg(format(g_sTotalOnlineCountMsg, [g_nTotalHumCount]));
          Exit;
        end;
        SC := GetValidStr3(SC, sParam1, [' ']);
        if not m_boFilterSendMsg then
          Whisper(sParam1, SC);
        Exit;
      end;
      if sData[1] = '!' then begin
        if Length(sData) >= 2 then begin
          if sData[2] = '!' then begin
            SC := Copy(sData, 3, Length(sData) - 2);
            SendGroupText(m_sCharName + ': ' + SC);
            Exit;
          end;
          if sData[2] = '~' then begin
            if m_MyGuild <> nil then begin
              SC := Copy(sData, 3, Length(sData) - 2);
              TGUild(m_MyGuild).SendGuildMsg(m_sCharName + ': ' + SC);
              UserEngine.SendServerGroupMsg(SS_208, nServerIndex, TGUild(m_MyGuild).sGuildName + '/' + m_sCharName + '/' + SC);
            end;
            Exit;
          end;
        end;
        if not m_PEnvir.m_boQUIZ then begin
          if (GetTickCount - m_dwShoutMsgTick) > 10 * 1000 then begin
            if m_Abil.Level <= g_Config.nCanShoutMsgLevel then begin
              //SysMsg('你的等级要在' + IntToStr(g_nCanShoutMsgLevel + 1) + '级以上才能用此功能！！！',c_Red,t_Hint);
              SysMsg(format(g_sYouNeedLevelMsg, [g_Config.nCanShoutMsgLevel + 1]), c_Red, t_Hint);
              Exit;
            end;
            m_dwShoutMsgTick := GetTickCount();
            SC := Copy(sData, 2, Length(sData) - 1);
            sCryCryMsg := '(!)' + m_sCharName + ': ' + SC;
            if m_boFilterSendMsg then begin
              SendMsg(nil, RM_CRY, 0, 0, $FFFF, 0, sCryCryMsg);
            end else begin
              UserEngine.CryCry(RM_CRY, m_PEnvir, m_nCurrX, m_nCurrY, 50, g_Config.btCryMsgFColor, g_Config.btCryMsgBColor, sCryCryMsg);
            end;
            Exit;
          end;
          //SysMsg(IntToStr(10 - (GetTickCount - m_dwShoutMsgTick) div 1000) + '  Seconds爐ill爕ou燾an爏hout.',c_Red,t_Hint);
          SysMsg(format(g_sYouCanSendCyCyLaterMsg, [10 - (GetTickCount - m_dwShoutMsgTick) div 1000]), c_Red, t_Hint);
          Exit;
        end;
        SysMsg(g_sThisMapDisableSendCyCyMsg {'本地图不允许喊话！！！'}, c_Red, t_Hint);
        Exit;
      end;
      if m_boFilterSendMsg then begin //如果禁止发信息，则只向自己发信息
        SendMsg(Self, RM_HEAR, 0, g_Config.btHearMsgFColor, g_Config.btHearMsgBColor, 0, m_sCharName + ':' + sData);
      end else begin
        SendRefMsg(RM_HEAR, 0, g_Config.btHearMsgFColor, g_Config.btHearMsgBColor, 0, m_sCharName + ':' + sData);
        //inherited;
      end;
      Exit;
    end;
    SysMsg(g_sYouIsDisableSendMsg {'禁止聊天'}, c_Red, t_Hint);
  except
    on E: Exception do begin
      MainOutMessage(format(sExceptionMsg, [sData]));
      MainOutMessage(E.Message);
    end;
  end;
end;

function TPlayObject.ClientHitXY(wIdent: Word; nX, nY, nDir: Integer; boLateDelivery: Boolean; var dwDelayTime: LongWord): Boolean; //004CB7F8
var
  n14, n18: Integer;
  StdItem: pTStdItem;
  dwAttackTime, dwCheckTime: LongWord;
resourcestring
  sExceptionMsg = '[Exception] TPlayObject::ClientHitXY';
begin
  Result := False;
  dwDelayTime := 0;
  try
    if not m_boCanHit then Exit;
    if m_boDeath or ((m_wStatusTimeArr[POISON_STONE {5}] {0x6A} <> 0) and not g_Config.ClientConf.boParalyCanHit) then Exit; //防麻
    if not boLateDelivery then begin
      if not CheckActionStatus(wIdent, dwDelayTime) then begin
        m_boFilterAction := False;
        Exit;
      end;
      m_boFilterAction := True;
      dwAttackTime := _MAX(0, Integer(g_Config.dwHitIntervalTime) - m_nHitSpeed * g_Config.ClientConf.btItemSpeed); //防止负数出错
      dwCheckTime := GetTickCount - m_dwAttackTick;
      if dwCheckTime < dwAttackTime then begin
        Inc(m_dwAttackCount);
        dwDelayTime := dwAttackTime - dwCheckTime;
        if dwDelayTime > g_Config.dwDropOverSpeed then begin
          if m_dwAttackCount >= 4 then begin
            m_dwAttackTick := GetTickCount();
            m_dwAttackCount := 0;
            dwDelayTime := g_Config.dwDropOverSpeed;
            if m_boTestSpeedMode then
              SysMsg('攻击忙复位！！！' + IntToStr(dwDelayTime), c_Red, t_Hint);
          end else m_dwAttackCount := 0;
          Exit;
        end else begin
          if m_boTestSpeedMode then
            SysMsg('攻击步忙！！！' + IntToStr(dwDelayTime), c_Red, t_Hint);
          Exit;
        end;
      end;
    end;
    if (nX = m_nCurrX) and (nY = m_nCurrY) then begin
      Result := True;
      m_dwAttackTick := GetTickCount();
      if (wIdent = CM_HEAVYHIT) and (m_UseItems[U_WEAPON].Dura > 0) then begin //挖矿
        if g_Config.boStartMapEvent then begin
          if m_btRaceServer = RC_PLAYOBJECT then StartMapEventOfMine(); //挖矿事件触发
        end;
        if GetFrontPosition(n14, n18) and not m_PEnvir.CanWalk(n14, n18, False) then begin //sub_004B2790
          StdItem := UserEngine.GetStdItem(m_UseItems[U_WEAPON].wIndex);
          if (StdItem <> nil) and (StdItem.Shape = 19) then begin
            if PileStones(n14, n18) then SendSocket(nil, '=DIG');
            Dec(m_nHealthTick, 30);
            Dec(m_nSpellTick, 50);
            m_nSpellTick := _MAX(0, m_nSpellTick);
            Dec(m_nPerHealth, 2);
            Dec(m_nPerSpell, 2);
            Exit;
          end;
        end;
      end;
      if wIdent = CM_HIT then AttackDir(nil, 0, nDir);
      if wIdent = CM_HEAVYHIT then AttackDir(nil, 1, nDir);
      if wIdent = CM_BIGHIT then AttackDir(nil, 2, nDir);
      if wIdent = CM_POWERHIT then AttackDir(nil, 3, nDir);
      if wIdent = CM_LONGHIT then AttackDir(nil, 4, nDir);
      if wIdent = CM_WIDEHIT then AttackDir(nil, 5, nDir);
      if wIdent = CM_FIREHIT then AttackDir(nil, 7, nDir);
      if wIdent = CM_CRSHIT then AttackDir(nil, 8, nDir);
      if wIdent = CM_TWNHIT then AttackDir(nil, 9, nDir);
      if wIdent = CM_42HIT then AttackDir(nil, 10, nDir);
      if wIdent = CM_42HIT then AttackDir(nil, 11, nDir);
      if (m_MagicPowerHitSkill <> nil) and (m_UseItems[U_WEAPON].Dura > 0) then begin
        Dec(m_btAttackSkillCount);
        if m_btAttackSkillPointCount = m_btAttackSkillCount then begin
          m_boPowerHit := True;
          SendSocket(nil, '+PWR');
        end;
        if m_btAttackSkillCount <= 0 then begin
          m_btAttackSkillCount := 7 - m_MagicPowerHitSkill.btLevel;
          m_btAttackSkillPointCount := Random(m_btAttackSkillCount);
        end;
      end;
      Dec(m_nHealthTick, 30);
      Dec(m_nSpellTick, 100);
      m_nSpellTick := _MAX(0, m_nSpellTick);
      Dec(m_nPerHealth, 2);
      Dec(m_nPerSpell, 2);
    end;
  except
    on E: Exception do begin
      MainOutMessage(sExceptionMsg);
      MainOutMessage(E.Message);
    end;
  end;
end;

function TPlayObject.ClientHorseRunXY(wIdent: Word; nX, nY: Integer; boLateDelivery: Boolean;
  var dwDelayTime: LongWord): Boolean;
var
  n14: Integer;
  dwCheckTime: LongWord;
begin
  Result := False;
  dwDelayTime := 0;
  if not m_boCanRun then Exit;
  if m_boDeath or ((m_wStatusTimeArr[POISON_STONE {5}] {0x6A} <> 0) and not g_Config.ClientConf.boParalyCanRun) then Exit; //防麻
  if not boLateDelivery then begin

    if not CheckActionStatus(wIdent, dwDelayTime) then begin
      m_boFilterAction := False;
      Exit;
    end;
    m_boFilterAction := True;
    dwCheckTime := GetTickCount - m_dwMoveTick;
    if dwCheckTime < g_Config.dwRunIntervalTime then begin
      Inc(m_dwMoveCount);
      dwDelayTime := g_Config.dwRunIntervalTime - dwCheckTime;
      if dwDelayTime > g_Config.dwDropOverSpeed then begin
        if m_dwMoveCount >= 4 then begin
          m_dwMoveTick := GetTickCount();
          m_dwMoveCount := 0;
          dwDelayTime := g_Config.dwDropOverSpeed;
          if m_boTestSpeedMode then
            SysMsg('马跑步忙复位！！！' + IntToStr(dwDelayTime), c_Red, t_Hint);
        end else m_dwMoveCount := 0;
        Exit;
      end else begin
        if m_boTestSpeedMode then
          SysMsg('马跑步忙！！！' + IntToStr(dwDelayTime), c_Red, t_Hint);
        Exit;
      end;
    end;
  end;

  m_dwMoveTick := GetTickCount();
  m_bo316 := False;
{$IF DEBUG = 1}
  SysMsg(format('当前X:%d 当前Y:%d 目标X:%d 目标Y:%d', [m_nCurrX, m_nCurrY, nX, nY]), c_Green, t_Hint);
{$IFEND}
  n14 := GetNextDirection(m_nCurrX, m_nCurrY, nX, nY);
  if HorseRunTo(n14, False) then begin
    m_dwStationTick := GetTickCount; //增加检测人物站立不动时间
    if m_boTransparent and (m_boHideMode) then m_wStatusTimeArr[STATE_TRANSPARENT {0 0x70}] := 1; //004CB212
    if m_bo316 or ((m_nCurrX = nX) and (m_nCurrY = nY)) then
      Result := True;
    Dec(m_nHealthTick, 60);
    Dec(m_nSpellTick, 10);
    m_nSpellTick := _MAX(0, m_nSpellTick);
    Dec(m_nPerHealth);
    Dec(m_nPerSpell);
  end else begin
    m_dwMoveCount := 0;
    m_dwMoveCountA := 0;
  end;
end;

function TPlayObject.ClientSpellXY(wIdent: Word; nKey: Integer; nTargetX, nTargetY: Integer; TargeTBaseObject: TBaseObject; boLateDelivery: Boolean; var dwDelayTime: LongWord): Boolean; //004CBCEC
var
  UserMagic: pTUserMagic;
  nSpellPoint: Integer;
  n14: Integer;
  BaseObject: TBaseObject;
  dwCheckTime: LongWord;
  boIsWarrSkill: Boolean;
begin
  Result := False;
  dwDelayTime := 0;
  if not m_boCanSpell then Exit;
  if m_boDeath or ((m_wStatusTimeArr[POISON_STONE {5}] {0x6A} <> 0) and not g_Config.ClientConf.boParalyCanSpell) then Exit; //防麻

  UserMagic := GetMagicInfo(nKey);

  if UserMagic = nil then Exit;

  boIsWarrSkill := MagicManager.IsWarrSkill(UserMagic.wMagIdx);

  if not boLateDelivery and not boIsWarrSkill then begin
    if not CheckActionStatus(wIdent, dwDelayTime) then begin
      m_boFilterAction := False;
      Exit;
    end;
    m_boFilterAction := True;
    dwCheckTime := GetTickCount - m_dwMagicAttackTick;
    if dwCheckTime < m_dwMagicAttackInterval then begin
      Inc(m_dwMagicAttackCount);
      dwDelayTime := m_dwMagicAttackInterval - dwCheckTime;
      if dwDelayTime > g_Config.dwMagicHitIntervalTime div 3 then begin
        if m_dwMagicAttackCount >= 4 then begin
          m_dwMagicAttackTick := GetTickCount();
          m_dwMagicAttackCount := 0;
          dwDelayTime := g_Config.dwMagicHitIntervalTime div 3;
          if m_boTestSpeedMode then
            SysMsg('魔法忙复位！！！' + IntToStr(dwDelayTime), c_Red, t_Hint);
        end else m_dwMagicAttackCount := 0;
        Exit;
      end else begin
        if m_boTestSpeedMode then
          SysMsg('魔法忙！！！' + IntToStr(dwDelayTime), c_Red, t_Hint);
        Exit;
      end;
    end;
  end;

  Dec(m_nSpellTick, 450);
  m_nSpellTick := _MAX(0, m_nSpellTick);

  if boIsWarrSkill then begin
    //m_dwMagicAttackInterval:=0;
    //m_dwMagicAttackInterval:=g_Config.dwMagicHitIntervalTime;
  end else begin
    m_dwMagicAttackInterval := UserMagic.MagicInfo.dwDelayTime + g_Config.dwMagicHitIntervalTime;
  end;
  m_dwMagicAttackTick := GetTickCount();
  case UserMagic.wMagIdx of //
    SKILL_ERGUM {12}: begin //刺杀剑法
        if m_MagicErgumSkill <> nil then begin
          if not m_boUseThrusting then begin
            ThrustingOnOff(True);
            SendSocket(nil, '+LNG');
          end else begin
            ThrustingOnOff(False);
            SendSocket(nil, '+ULNG');
          end;
        end;
        Result := True;
      end;
    SKILL_BANWOL {25}: begin //半月弯刀
        if m_MagicBanwolSkill <> nil then begin
          if not m_boUseHalfMoon then begin
            HalfMoonOnOff(True);
            SendSocket(nil, '+WID');
          end else begin
            HalfMoonOnOff(False);
            SendSocket(nil, '+UWID');
          end;
        end;
        Result := True;
      end;
    SKILL_FIRESWORD {26}: begin //烈火剑法
        if m_MagicFireSwordSkill <> nil then begin
          if AllowFireHitSkill then begin
            nSpellPoint := GetSpellPoint(UserMagic);
            if m_WAbil.MP >= nSpellPoint then begin
              if nSpellPoint > 0 then begin
                DamageSpell(nSpellPoint);
                HealthSpellChanged();
              end;
              SendSocket(nil, '+FIR');
            end;
          end;
        end;
        Result := True;
      end;
    SKILL_MOOTEBO {27}: begin //野蛮冲撞
        Result := True;
        if (GetTickCount - m_dwDoMotaeboTick) > 3 * 1000 then begin
          m_dwDoMotaeboTick := GetTickCount();
          m_btDirection := nTargetX;
          nSpellPoint := GetSpellPoint(UserMagic);
          if m_WAbil.MP >= nSpellPoint then begin
            if nSpellPoint > 0 then begin
              DamageSpell(nSpellPoint);
              HealthSpellChanged();
            end;
            if DoMotaebo(m_btDirection, UserMagic.btLevel) then begin
              if UserMagic.btLevel < 3 then begin
                if UserMagic.MagicInfo.TrainLevel[UserMagic.btLevel] < m_Abil.Level then begin
                  TrainSkill(UserMagic, Random(3) + 1);
                  if not CheckMagicLevelup(UserMagic) then begin

                    SendDelayMsg(Self,
                      RM_MAGIC_LVEXP,
                      0,
                      UserMagic.MagicInfo.wMagicId,
                      UserMagic.btLevel,
                      UserMagic.nTranPoint,
                      '', 1000);
                  end;
                end;
              end;
            end;
          end;
        end;
      end;
    SKILL_40: begin //双龙斩 抱月刀法
        if m_MagicCrsSkill <> nil then begin
          if not m_boCrsHitkill then begin
            SkillCrsOnOff(True);
            SendSocket(nil, '+CRS');
          end else begin
            SkillCrsOnOff(False);
            SendSocket(nil, '+UCRS');
          end;
        end;
        Result := True;
      end;
    42: begin //狂风斩
        if m_Magic42Skill <> nil then begin
          if not m_bo42kill then begin
            Skill42OnOff(True);
            SendSocket(nil, '+TWN');
          end else begin
            Skill42OnOff(False);
            SendSocket(nil, '+UTWN');
          end;
        end;
        Result := True;
      end;
    43: begin //破空剑
        if m_Magic43Skill <> nil then begin
          if not m_bo43kill then begin
            Skill43OnOff(True);
            SendSocket(nil, '+CID');
          end else begin
            Skill43OnOff(False);
            SendSocket(nil, '+UCID');
          end;
        end;
        Result := True;
      end;
    else begin
        n14 := GetNextDirection(m_nCurrX, m_nCurrY, nTargetX, nTargetY);
        m_btDirection := n14;
        BaseObject := nil;
        //检查目标角色，与目标座标误差范围，如果在误差范围内则修正目标座标
        if CretInNearXY(TargeTBaseObject, nTargetX, nTargetY) then begin
          BaseObject := TargeTBaseObject;
          nTargetX := BaseObject.m_nCurrX;
          nTargetY := BaseObject.m_nCurrY;
        end;
        if not DoSpell(UserMagic, nTargetX, nTargetY, BaseObject) then begin
          SendRefMsg(RM_MAGICFIREFAIL, 0, 0, 0, 0, '');
        end;
        Result := True;
      end;
  end;
end;

function TBaseObject.RunTo(btDir: Byte; boFlag: Boolean; nDestX, nDestY: Integer): Boolean;
var
  nOldX, nOldY: Integer;
resourcestring
  sExceptionMsg = '[Exception] TBaseObject::RunTo';
begin
  Result := False;
  try
    nOldX := m_nCurrX;
    nOldY := m_nCurrY;
    m_btDirection := btDir;
    case btDir of
      DR_UP {0}: begin
          if (m_nCurrY > 1) and
            (m_PEnvir.CanWalkEx(m_nCurrX, m_nCurrY - 1, g_Config.boDiableHumanRun or ((m_btPermission > 9) and g_Config.boGMRunAll)) or (g_Config.boSafeAreaLimited and InSafeZone)) and
            (m_PEnvir.CanWalkEx(m_nCurrX, m_nCurrY - 2, g_Config.boDiableHumanRun or ((m_btPermission > 9) and g_Config.boGMRunAll)) or (g_Config.boSafeAreaLimited and InSafeZone)) and
            (m_PEnvir.MoveToMovingObject(m_nCurrX, m_nCurrY, Self, m_nCurrX, m_nCurrY - 2, True) > 0) then begin
            Dec(m_nCurrY, 2);
          end;
        end;
      DR_UPRIGHT {1}: begin
          if (m_nCurrX < m_PEnvir.m_nWidth - 2) and
            (m_nCurrY > 1) and
            (m_PEnvir.CanWalkEx(m_nCurrX + 1, m_nCurrY - 1, g_Config.boDiableHumanRun or ((m_btPermission > 9) and g_Config.boGMRunAll)) or (g_Config.boSafeAreaLimited and InSafeZone)) and
            (m_PEnvir.CanWalkEx(m_nCurrX + 2, m_nCurrY - 2, g_Config.boDiableHumanRun or ((m_btPermission > 9) and g_Config.boGMRunAll)) or (g_Config.boSafeAreaLimited and InSafeZone)) and
            (m_PEnvir.MoveToMovingObject(m_nCurrX, m_nCurrY, Self, m_nCurrX + 2, m_nCurrY - 2, True) > 0) then begin
            Inc(m_nCurrX, 2);
            Dec(m_nCurrY, 2);
          end;
        end;
      DR_RIGHT {2}: begin
          if (m_nCurrX < m_PEnvir.m_nWidth - 2) and
            (m_PEnvir.CanWalkEx(m_nCurrX + 1, m_nCurrY, g_Config.boDiableHumanRun or ((m_btPermission > 9) and g_Config.boGMRunAll)) or (g_Config.boSafeAreaLimited and InSafeZone)) and
            (m_PEnvir.CanWalkEx(m_nCurrX + 2, m_nCurrY, g_Config.boDiableHumanRun or ((m_btPermission > 9) and g_Config.boGMRunAll)) or (g_Config.boSafeAreaLimited and InSafeZone)) and
            (m_PEnvir.MoveToMovingObject(m_nCurrX, m_nCurrY, Self, m_nCurrX + 2, m_nCurrY, True) > 0) then begin
            Inc(m_nCurrX, 2);
          end;
        end;
      DR_DOWNRIGHT {3}: begin
          if (m_nCurrX < m_PEnvir.m_nWidth - 2) and
            (m_nCurrY < m_PEnvir.m_nHeight - 2) and
            (m_PEnvir.CanWalkEx(m_nCurrX + 1, m_nCurrY + 1, g_Config.boDiableHumanRun or ((m_btPermission > 9) and g_Config.boGMRunAll)) or (g_Config.boSafeAreaLimited and InSafeZone)) and
            (m_PEnvir.CanWalkEx(m_nCurrX + 2, m_nCurrY + 2, g_Config.boDiableHumanRun or ((m_btPermission > 9) and g_Config.boGMRunAll)) or (g_Config.boSafeAreaLimited and InSafeZone)) and
            (m_PEnvir.MoveToMovingObject(m_nCurrX, m_nCurrY, Self, m_nCurrX + 2, m_nCurrY + 2, True) > 0) then begin
            Inc(m_nCurrX, 2);
            Inc(m_nCurrY, 2);
          end;
        end;
      DR_DOWN {4}: begin
          if (m_nCurrY < m_PEnvir.m_nHeight - 2) and
            (m_PEnvir.CanWalkEx(m_nCurrX, m_nCurrY + 1, g_Config.boDiableHumanRun or ((m_btPermission > 9) and g_Config.boGMRunAll)) or (g_Config.boSafeAreaLimited and InSafeZone)) and
            (m_PEnvir.CanWalkEx(m_nCurrX, m_nCurrY + 2, g_Config.boDiableHumanRun or ((m_btPermission > 9) and g_Config.boGMRunAll)) or (g_Config.boSafeAreaLimited and InSafeZone)) and
            (m_PEnvir.MoveToMovingObject(m_nCurrX, m_nCurrY, Self, m_nCurrX, m_nCurrY + 2, True) > 0) then begin
            Inc(m_nCurrY, 2);
          end;
        end;
      DR_DOWNLEFT {5}: begin
          if (m_nCurrX > 1) and
            (m_nCurrY < m_PEnvir.m_nHeight - 2) and
            (m_PEnvir.CanWalkEx(m_nCurrX - 1, m_nCurrY + 1, g_Config.boDiableHumanRun or ((m_btPermission > 9) and g_Config.boGMRunAll)) or (g_Config.boSafeAreaLimited and InSafeZone)) and
            (m_PEnvir.CanWalkEx(m_nCurrX - 2, m_nCurrY + 2, g_Config.boDiableHumanRun or ((m_btPermission > 9) and g_Config.boGMRunAll)) or (g_Config.boSafeAreaLimited and InSafeZone)) and
            (m_PEnvir.MoveToMovingObject(m_nCurrX, m_nCurrY, Self, m_nCurrX - 2, m_nCurrY + 2, True) > 0) then begin
            Dec(m_nCurrX, 2);
            Inc(m_nCurrY, 2);
          end;
        end;
      DR_LEFT {6}: begin
          if (m_nCurrX > 1) and
            (m_PEnvir.CanWalkEx(m_nCurrX - 1, m_nCurrY, g_Config.boDiableHumanRun or ((m_btPermission > 9) and g_Config.boGMRunAll)) or (g_Config.boSafeAreaLimited and InSafeZone)) and
            (m_PEnvir.CanWalkEx(m_nCurrX - 2, m_nCurrY, g_Config.boDiableHumanRun or ((m_btPermission > 9) and g_Config.boGMRunAll)) or (g_Config.boSafeAreaLimited and InSafeZone)) and
            (m_PEnvir.MoveToMovingObject(m_nCurrX, m_nCurrY, Self, m_nCurrX - 2, m_nCurrY, True) > 0) then begin
            Dec(m_nCurrX, 2);
          end;
        end;
      DR_UPLEFT {7}: begin
          if (m_nCurrX > 1) and
            (m_nCurrY > 1) and
            (m_PEnvir.CanWalkEx(m_nCurrX - 1, m_nCurrY - 1, g_Config.boDiableHumanRun or ((m_btPermission > 9) and g_Config.boGMRunAll)) or (g_Config.boSafeAreaLimited and InSafeZone)) and
            (m_PEnvir.CanWalkEx(m_nCurrX - 2, m_nCurrY - 2, g_Config.boDiableHumanRun or ((m_btPermission > 9) and g_Config.boGMRunAll)) or (g_Config.boSafeAreaLimited and InSafeZone)) and
            (m_PEnvir.MoveToMovingObject(m_nCurrX, m_nCurrY, Self, m_nCurrX - 2, m_nCurrY - 2, True) > 0) then begin
            Dec(m_nCurrX, 2);
            Dec(m_nCurrY, 2);
          end;
        end;
    end;
    if ((m_nCurrX <> nOldX) or (m_nCurrY <> nOldY)) {and ((m_nCurrX = nDestX) and (m_nCurrY = nDestY))} then begin
      if Walk(RM_RUN) then Result := True
      else begin
        m_nCurrX := nOldX;
        m_nCurrY := nOldY;
        m_PEnvir.MoveToMovingObject(nOldX, nOldY, Self, m_nCurrX, m_nCurrX, True);
      end;
    end;
  except
    MainOutMessage(sExceptionMsg);
  end;
end;

function TPlayObject.HorseRunTo(btDir: Byte; boFlag: Boolean): Boolean;
var
  n10, n14: Integer;
resourcestring
  sExceptionMsg = '[Exception] TPlayObject::HorseRunTo';
begin
  Result := False;
  try
    n10 := m_nCurrX;
    n14 := m_nCurrY;
    m_btDirection := btDir;
    case btDir of
      DR_UP {0}: begin
          if (m_nCurrY > 2) and
            (m_PEnvir.CanWalkEx(m_nCurrX, m_nCurrY - 1, g_Config.boDiableHumanRun or ((m_btPermission > 9) and g_Config.boGMRunAll)) or (g_Config.boSafeAreaLimited and InSafeZone)) and
            (m_PEnvir.CanWalkEx(m_nCurrX, m_nCurrY - 2, g_Config.boDiableHumanRun or ((m_btPermission > 9) and g_Config.boGMRunAll)) or (g_Config.boSafeAreaLimited and InSafeZone)) and
            (m_PEnvir.CanWalkEx(m_nCurrX, m_nCurrY - 3, g_Config.boDiableHumanRun or ((m_btPermission > 9) and g_Config.boGMRunAll)) or (g_Config.boSafeAreaLimited and InSafeZone)) and
            (m_PEnvir.MoveToMovingObject(m_nCurrX, m_nCurrY, Self, m_nCurrX, m_nCurrY - 3, True) > 0) then begin

            Dec(m_nCurrY, 3);
          end;
        end;
      DR_UPRIGHT {1}: begin
          if (m_nCurrX < m_PEnvir.m_nWidth - 3) and
            (m_nCurrY > 2) and
            (m_PEnvir.CanWalkEx(m_nCurrX + 1, m_nCurrY - 1, g_Config.boDiableHumanRun or ((m_btPermission > 9) and g_Config.boGMRunAll)) or (g_Config.boSafeAreaLimited and InSafeZone)) and
            (m_PEnvir.CanWalkEx(m_nCurrX + 2, m_nCurrY - 2, g_Config.boDiableHumanRun or ((m_btPermission > 9) and g_Config.boGMRunAll)) or (g_Config.boSafeAreaLimited and InSafeZone)) and
            (m_PEnvir.CanWalkEx(m_nCurrX + 3, m_nCurrY - 3, g_Config.boDiableHumanRun or ((m_btPermission > 9) and g_Config.boGMRunAll)) or (g_Config.boSafeAreaLimited and InSafeZone)) and
            (m_PEnvir.MoveToMovingObject(m_nCurrX, m_nCurrY, Self, m_nCurrX + 3, m_nCurrY - 3, True) > 0) then begin

            Inc(m_nCurrX, 3);
            Dec(m_nCurrY, 3);
          end;
        end;
      DR_RIGHT {2}: begin
          if (m_nCurrX < m_PEnvir.m_nWidth - 3) and
            (m_PEnvir.CanWalkEx(m_nCurrX + 1, m_nCurrY, g_Config.boDiableHumanRun or ((m_btPermission > 9) and g_Config.boGMRunAll)) or (g_Config.boSafeAreaLimited and InSafeZone)) and
            (m_PEnvir.CanWalkEx(m_nCurrX + 2, m_nCurrY, g_Config.boDiableHumanRun or ((m_btPermission > 9) and g_Config.boGMRunAll)) or (g_Config.boSafeAreaLimited and InSafeZone)) and
            (m_PEnvir.CanWalkEx(m_nCurrX + 3, m_nCurrY, g_Config.boDiableHumanRun or ((m_btPermission > 9) and g_Config.boGMRunAll)) or (g_Config.boSafeAreaLimited and InSafeZone)) and
            (m_PEnvir.MoveToMovingObject(m_nCurrX, m_nCurrY, Self, m_nCurrX + 3, m_nCurrY, True) > 0) then begin

            Inc(m_nCurrX, 3);
          end;
        end;
      DR_DOWNRIGHT {3}: begin
          if (m_nCurrX < m_PEnvir.m_nWidth - 3) and
            (m_nCurrY < m_PEnvir.m_nHeight - 3) and
            (m_PEnvir.CanWalkEx(m_nCurrX + 1, m_nCurrY + 1, g_Config.boDiableHumanRun or ((m_btPermission > 9) and g_Config.boGMRunAll)) or (g_Config.boSafeAreaLimited and InSafeZone)) and
            (m_PEnvir.CanWalkEx(m_nCurrX + 2, m_nCurrY + 2, g_Config.boDiableHumanRun or ((m_btPermission > 9) and g_Config.boGMRunAll)) or (g_Config.boSafeAreaLimited and InSafeZone)) and
            (m_PEnvir.CanWalkEx(m_nCurrX + 3, m_nCurrY + 3, g_Config.boDiableHumanRun or ((m_btPermission > 9) and g_Config.boGMRunAll)) or (g_Config.boSafeAreaLimited and InSafeZone)) and
            (m_PEnvir.MoveToMovingObject(m_nCurrX, m_nCurrY, Self, m_nCurrX + 3, m_nCurrY + 3, True) > 0) then begin

            Inc(m_nCurrX, 3);
            Inc(m_nCurrY, 3);
          end;
        end;
      DR_DOWN {4}: begin
          if (m_nCurrY < m_PEnvir.m_nHeight - 3) and
            (m_PEnvir.CanWalkEx(m_nCurrX, m_nCurrY + 1, g_Config.boDiableHumanRun or ((m_btPermission > 9) and g_Config.boGMRunAll)) or (g_Config.boSafeAreaLimited and InSafeZone)) and
            (m_PEnvir.CanWalkEx(m_nCurrX, m_nCurrY + 2, g_Config.boDiableHumanRun or ((m_btPermission > 9) and g_Config.boGMRunAll)) or (g_Config.boSafeAreaLimited and InSafeZone)) and
            (m_PEnvir.CanWalkEx(m_nCurrX, m_nCurrY + 3, g_Config.boDiableHumanRun or ((m_btPermission > 9) and g_Config.boGMRunAll)) or (g_Config.boSafeAreaLimited and InSafeZone)) and
            (m_PEnvir.MoveToMovingObject(m_nCurrX, m_nCurrY, Self, m_nCurrX, m_nCurrY + 3, True) > 0) then begin

            Inc(m_nCurrY, 3);
          end;
        end;
      DR_DOWNLEFT {5}: begin
          if (m_nCurrX > 2) and
            (m_nCurrY < m_PEnvir.m_nHeight - 3) and
            (m_PEnvir.CanWalkEx(m_nCurrX - 1, m_nCurrY + 1, g_Config.boDiableHumanRun or ((m_btPermission > 9) and g_Config.boGMRunAll)) or (g_Config.boSafeAreaLimited and InSafeZone)) and
            (m_PEnvir.CanWalkEx(m_nCurrX - 2, m_nCurrY + 2, g_Config.boDiableHumanRun or ((m_btPermission > 9) and g_Config.boGMRunAll)) or (g_Config.boSafeAreaLimited and InSafeZone)) and
            (m_PEnvir.CanWalkEx(m_nCurrX - 3, m_nCurrY + 3, g_Config.boDiableHumanRun or ((m_btPermission > 9) and g_Config.boGMRunAll)) or (g_Config.boSafeAreaLimited and InSafeZone)) and
            (m_PEnvir.MoveToMovingObject(m_nCurrX, m_nCurrY, Self, m_nCurrX - 3, m_nCurrY + 3, True) > 0) then begin

            Dec(m_nCurrX, 3);
            Inc(m_nCurrY, 3);
          end;
        end;
      DR_LEFT {6}: begin
          if (m_nCurrX > 2) and
            (m_PEnvir.CanWalkEx(m_nCurrX - 1, m_nCurrY, g_Config.boDiableHumanRun or ((m_btPermission > 9) and g_Config.boGMRunAll)) or (g_Config.boSafeAreaLimited and InSafeZone)) and
            (m_PEnvir.CanWalkEx(m_nCurrX - 2, m_nCurrY, g_Config.boDiableHumanRun or ((m_btPermission > 9) and g_Config.boGMRunAll)) or (g_Config.boSafeAreaLimited and InSafeZone)) and
            (m_PEnvir.CanWalkEx(m_nCurrX - 3, m_nCurrY, g_Config.boDiableHumanRun or ((m_btPermission > 9) and g_Config.boGMRunAll)) or (g_Config.boSafeAreaLimited and InSafeZone)) and
            (m_PEnvir.MoveToMovingObject(m_nCurrX, m_nCurrY, Self, m_nCurrX - 3, m_nCurrY, True) > 0) then begin

            Dec(m_nCurrX, 3);
          end;
        end;
      DR_UPLEFT {7}: begin
          if (m_nCurrX > 2) and
            (m_nCurrY > 2) and
            (m_PEnvir.CanWalkEx(m_nCurrX - 1, m_nCurrY - 1, g_Config.boDiableHumanRun or ((m_btPermission > 9) and g_Config.boGMRunAll)) or (g_Config.boSafeAreaLimited and InSafeZone)) and
            (m_PEnvir.CanWalkEx(m_nCurrX - 2, m_nCurrY - 2, g_Config.boDiableHumanRun or ((m_btPermission > 9) and g_Config.boGMRunAll)) or (g_Config.boSafeAreaLimited and InSafeZone)) and
            (m_PEnvir.CanWalkEx(m_nCurrX - 3, m_nCurrY - 3, g_Config.boDiableHumanRun or ((m_btPermission > 9) and g_Config.boGMRunAll)) or (g_Config.boSafeAreaLimited and InSafeZone)) and
            (m_PEnvir.MoveToMovingObject(m_nCurrX, m_nCurrY, Self, m_nCurrX - 3, m_nCurrY - 3, True) > 0) then begin

            Dec(m_nCurrX, 3);
            Dec(m_nCurrY, 3);
          end;
        end;
    end;
    //    SysMsg(format('原X:%d 原Y:%d 新X:%d 新Y:%d',[n10,n14,m_nCurrX,m_nCurrY]),c_Green,t_Hint);
    if (m_nCurrX <> n10) or (m_nCurrY <> n14) then begin
      if Walk(RM_HORSERUN) then Result := True
      else begin
        m_nCurrX := n10;
        m_nCurrY := n14;
        m_PEnvir.MoveToMovingObject(n10, n14, Self, m_nCurrX, m_nCurrX, True)
      end;
    end;
  except
    MainOutMessage(sExceptionMsg);
  end;
end;

function TPlayObject.ClientRunXY(wIdent: Word; nX, nY: Integer; nFlag: Integer; var dwDelayTime: LongWord): Boolean; //004CB11C
var
  nDir: Integer;
  dwCheckTime: LongWord;
begin
  Result := False;
  dwDelayTime := 0;
  if not m_boCanRun then Exit;
  if m_boDeath or ((m_wStatusTimeArr[POISON_STONE {5}] {0x6A} <> 0) and not g_Config.ClientConf.boParalyCanRun) then Exit; //防麻

  if nFlag <> wIdent then begin

    if not CheckActionStatus(wIdent, dwDelayTime) then begin
      m_boFilterAction := False;
      Exit;
    end;
    m_boFilterAction := True;
    dwCheckTime := GetTickCount - m_dwMoveTick;
    if dwCheckTime < g_Config.dwRunIntervalTime then begin
      Inc(m_dwMoveCount);
      dwDelayTime := g_Config.dwRunIntervalTime - dwCheckTime;
      if dwDelayTime > g_Config.dwRunIntervalTime div 3 then begin
        if m_dwMoveCount >= 4 then begin
          m_dwMoveTick := GetTickCount();
          m_dwMoveCount := 0;
          dwDelayTime := g_Config.dwRunIntervalTime div 3;
          if m_boTestSpeedMode then
            SysMsg('跑步忙复位！！！' + IntToStr(dwDelayTime), c_Red, t_Hint);
        end else m_dwMoveCount := 0;
        Exit;
      end else begin
        if m_boTestSpeedMode then
          SysMsg('跑步忙！！！' + IntToStr(dwDelayTime), c_Red, t_Hint);
        Exit;
      end;
    end;
  end;
  {
  if (GetTickCount - m_dwMoveTick) < 600 then begin
    Inc(m_dwMoveCount);
    Inc(m_dwMoveCountA);
  end else begin
    m_dwMoveCount:=0;
    if m_dwMoveCountA > 0 then Dec(m_dwMoveCountA);
  end;
  }
  m_dwMoveTick := GetTickCount();
  //  if (m_dwMoveCount < 4) and (m_dwMoveCountA < 6) then begin
  m_bo316 := False;
  nDir := GetNextDirection(m_nCurrX, m_nCurrY, nX, nY);
  if RunTo(nDir, False, nX, nY) then begin
    m_dwStationTick := GetTickCount; //增加检测人物站立不动时间
    if m_boTransparent and (m_boHideMode) then m_wStatusTimeArr[STATE_TRANSPARENT {0 0x70}] := 1;
    if m_bo316 or ((m_nCurrX = nX) and (m_nCurrY = nY)) then
      Result := True;
    Dec(m_nHealthTick, 60);
    Dec(m_nSpellTick, 10);
    m_nSpellTick := _MAX(0, m_nSpellTick);
    Dec(m_nPerHealth);
    Dec(m_nPerSpell);
  end else begin
    m_dwMoveCount := 0;
    m_dwMoveCountA := 0;
  end;
  {
    end else begin
      Inc(m_dwOverSpeedCount);
      //if m_dwOverSpeedCount > 8 then m_boEmergencyClose:=True;
      SysMsg('跑步超速！！！',c_Red,t_Hint);
      if boViewHackMessage then begin
        MainOutMessage('[11002-Run] ' + m_sCharName + ' ' + DateToStr(Now));
      end;
    end;
  }
end;

function TPlayObject.ClientWalkXY(wIdent: Word; nX, nY: Integer; boLateDelivery: Boolean; var dwDelayTime: LongWord): Boolean; //004CAF08
var
  n14, n18, n1C: Integer;
  dwCheckTime: LongWord;
begin
  Result := False;
  dwDelayTime := 0;
  if not m_boCanWalk then Exit;
  if m_boDeath or ((m_wStatusTimeArr[POISON_STONE {5}] {0x6A} <> 0) and not g_Config.ClientConf.boParalyCanWalk) then Exit; //防麻

  if not boLateDelivery then begin
    if not CheckActionStatus(wIdent, dwDelayTime) then begin
      m_boFilterAction := False;
      Exit;
    end;
    m_boFilterAction := True;
    dwCheckTime := GetTickCount - m_dwMoveTick;
    if dwCheckTime < g_Config.dwWalkIntervalTime then begin
      Inc(m_dwMoveCount);
      dwDelayTime := g_Config.dwWalkIntervalTime - dwCheckTime;
      if dwDelayTime > g_Config.dwWalkIntervalTime div 3 then begin
        if m_dwMoveCount >= 4 then begin
          m_dwMoveTick := GetTickCount();
          m_dwMoveCount := 0;
          dwDelayTime := g_Config.dwWalkIntervalTime div 3;
          if m_boTestSpeedMode then
            SysMsg('走路忙复位！！！' + IntToStr(dwDelayTime), c_Red, t_Hint);
        end else m_dwMoveCount := 0;
        Exit;
      end else begin
        if m_boTestSpeedMode then
          SysMsg('走路忙！！！' + IntToStr(dwDelayTime), c_Red, t_Hint);
        Exit;
      end;
    end;
  end;
  {
  if (GetTickCount - m_dwMoveTick) < 600 then begin
    Inc(m_dwMoveCount);
    Inc(m_dwMoveCountA);
  end else begin
    m_dwMoveCount:=0;
    if m_dwMoveCountA > 0 then Dec(m_dwMoveCountA);
  end;
  }
  m_dwMoveTick := GetTickCount();
  m_bo316 := False;
  n18 := m_nCurrX;
  n1C := m_nCurrY;
  n14 := GetNextDirection(m_nCurrX, m_nCurrY, nX, nY);
  if not m_boClientFlag then begin
    if (n14 = 0) and (m_nStep = 0) then Inc(m_nStep)
    else
      if (n14 = 4) and (m_nStep = 1) then Inc(m_nStep)
    else
      if (n14 = 6) and (m_nStep = 2) then Inc(m_nStep)
    else
      if (n14 = 2) and (m_nStep = 3) then Inc(m_nStep)
    else
      if (n14 = 1) and (m_nStep = 4) then Inc(m_nStep)
    else
      if (n14 = 5) and (m_nStep = 5) then Inc(m_nStep)
    else
      //      if (n14 = 3) and (m_nStep = 6) then Inc(m_nStep)
      if (n14 = 7) and (m_nStep = 6) then Inc(m_nStep)
    else
      //      if (n14 = 7) and (m_nStep = 7) then Inc(m_nStep)
      if (n14 = 3) and (m_nStep = 7) then Inc(m_nStep)
    else begin
      m_nStep := 0;
    end;
  end;

  if WalkTo(n14, False) then begin
    m_dwStationTick := GetTickCount; //增加检测人物站立不动时间
    if m_bo316 or ((m_nCurrX = nX) and (m_nCurrY = nY)) then
      Result := True;
    Dec(m_nHealthTick, 10);
  end else begin
    m_dwMoveCount := 0;
    m_dwMoveCountA := 0;
  end;
  {
  end else begin
    Inc(m_dwOverSpeedCount);
    //if m_dwOverSpeedCount > 8 then m_boEmergencyClose:=True;
    SysMsg('走步超速！！！',c_Red,t_Hint);
    if boViewHackMessage then begin
      MainOutMessage('[11002-Walk] ' + m_sCharName + ' ' + DateToStr(Now));
    end;
  end;
  }
end;

procedure TBaseObject.ThrustingOnOff(boSwitch: Boolean);
begin
  m_boUseThrusting := boSwitch;
  if m_boUseThrusting then begin
    SysMsg(sThrustingOn, c_Green, t_Hint);
  end else begin
    SysMsg(sThrustingOff, c_Green, t_Hint);
  end;
end;

procedure TBaseObject.HalfMoonOnOff(boSwitch: Boolean);
begin
  m_boUseHalfMoon := boSwitch;
  if m_boUseHalfMoon then begin
    SysMsg(sHalfMoonOn, c_Green, t_Hint);
  end else begin
    SysMsg(sHalfMoonOff, c_Green, t_Hint);
  end;
end;

procedure TBaseObject.SkillCrsOnOff(boSwitch: Boolean);
begin
  m_boCrsHitkill := boSwitch;
  if m_boCrsHitkill then begin
    SysMsg(sCrsHitOn, c_Green, t_Hint);
  end else begin
    SysMsg(sCrsHitOff, c_Green, t_Hint);
  end;
end;
procedure TBaseObject.Skill42OnOff(boSwitch: Boolean);
begin
  m_bo42kill := boSwitch;
  if m_bo42kill then begin
    SysMsg('开启狂风斩', c_Green, t_Hint);
  end else begin
    SysMsg('关闭狂风斩', c_Green, t_Hint);
  end;
end;

procedure TBaseObject.Skill43OnOff(boSwitch: Boolean);
begin
  m_bo43kill := boSwitch;
  if m_bo43kill then begin
    SysMsg('开启破空剑', c_Green, t_Hint);
  end else begin
    SysMsg('关闭破空剑', c_Green, t_Hint);
  end;
end;

function TBaseObject.AllowFireHitSkill(): Boolean;
begin
  Result := False;
  if (GetTickCount - m_dwLatestFireHitTick) > 10 * 1000 then begin
    m_dwLatestFireHitTick := GetTickCount();
    m_boFireHitSkill := True;
    SysMsg(sFireSpiritsSummoned, c_Green, t_Hint);
    Result := True;
  end else begin
    SysMsg(sFireSpiritsFail, c_Red, t_Hint);
  end;
end;

procedure TBaseObject.MapRandomMove(sMapName: string; nInt: Integer);
var
  oEnvir, Envir: TEnvirnoment;
  n10, n14, n18: Integer;
begin
  oEnvir := m_PEnvir;
  Envir := g_MapManager.FindMap(sMapName);
  if Envir <> nil then begin
    if Envir.m_nHeight < 150 then begin
      if Envir.m_nHeight < 30 then begin
        n18 := 2;
      end else n18 := 20;
    end else n18 := 50;
    n10 := Random(Envir.m_nWidth - n18 - 1) + n18;
    n14 := Random(Envir.m_nHeight - n18 - 1) + n18;
    SpaceMove(sMapName, n10, n14, nInt);
  end;
end;

procedure TPlayObject.ClientClickNPC(NPC: Integer);
var
  NormNpc: TNormNpc;
begin
  if not m_boCanDeal then begin
    SendMsg(g_ManageNPC, RM_MENU_OK, 0, Integer(Self), 0, 0, g_sCanotTryDealMsg);
    Exit;
  end;
  if m_boDeath or m_boGhost then Exit;

  NormNpc := UserEngine.FindMerchant(TObject(NPC));
  if NormNpc = nil then
    NormNpc := UserEngine.FindNPC(TObject(NPC));

  if NormNpc <> nil then begin
    if (NormNpc.m_PEnvir = m_PEnvir) and (abs(NormNpc.m_nCurrX - m_nCurrX) <= 15) and (abs(NormNpc.m_nCurrY - m_nCurrY) <= 15) then begin
      NormNpc.Click(Self);
    end;
  end;
end;

function TBaseObject.AddItemToBag(UserItem: pTUserItem): Boolean;
begin
  Result := False;
  if m_ItemList.Count < MAXBAGITEM then begin
    m_ItemList.Add(UserItem);
    WeightChanged();
    Result := True;
  end;
end;

function TPlayObject.GetRangeHumanCount: Integer;
begin
  Result := UserEngine.GetMapOfRangeHumanCount(m_PEnvir, m_nCurrX, m_nCurrY, 10);
end;

procedure TBaseObject.sub_4C713C(Magic: pTUserMagic);
begin
  if Magic <> nil then begin
    if Magic.MagicInfo.wMagicId = 28 then
      if Magic.btLevel >= 2 then m_boAbilSeeHealGauge := True;
  end;
end;

procedure TPlayObject.GetStartPoint;
var
  i: Integer;
  StartPoint: pTStartPoint;
begin
  try
    g_StartPointList.Lock;
    for i := 0 to g_StartPointList.Count - 1 do begin
      if g_StartPointList.Strings[i] = m_PEnvir.sMapName then begin
        StartPoint := pTStartPoint(g_StartPointList.Objects[i]);
        if StartPoint <> nil then begin
          //nXY := Integer(g_StartPointList.Objects[i]);
          if (abs(m_nCurrX - StartPoint.m_nCurrX) < 50) and (abs(m_nCurrY - StartPoint.m_nCurrY) < 50) then begin
            m_sHomeMap := g_StartPointList.Strings[i];
            m_nHomeX := StartPoint.m_nCurrX;
            m_nHomeY := StartPoint.m_nCurrY;
            break;
          end;
        end;
      end;
    end;
    if PKLevel >= 2 then begin
      m_sHomeMap := g_Config.sRedHomeMap;
      m_nHomeX := g_Config.nRedHomeX;
      m_nHomeY := g_Config.nRedHomeY;
    end;
  finally
    g_StartPointList.UnLock;
  end;
end;
{procedure TPlayObject.GetStartPoint;
var
  i: Integer;
  StartPoint: pTStartPoint;
  nStartX,nStartY:Integer;
  nEndX,nEndY:Integer;
begin
  try
    g_StartPointList.Lock;
    for i := 0 to g_StartPointList.Count - 1 do begin
      if g_StartPointList.Strings[i] = m_PEnvir.sMapName then begin
        StartPoint := pTStartPoint(g_StartPointList.Objects[i]);
        if StartPoint <> nil then begin
          //nXY := Integer(g_StartPointList.Objects[i]);
          nStartX:=StartPoint.m_nCurrX - StartPoint.m_nRange;
          nEndX:=StartPoint.m_nCurrX + StartPoint.m_nRange;
          nStartY:=StartPoint.m_nCurrY - StartPoint.m_nRange;
          nEndY:=StartPoint.m_nCurrY - StartPoint.m_nRange;
          if (m_nCurrX in [nStartX..nEndX]) and (m_nCurrY in [nStartY..nEndY]) then begin
            m_sHomeMap := g_StartPointList.Strings[i];
            m_nHomeX := StartPoint.m_nCurrX;
            m_nHomeY := StartPoint.m_nCurrY;
            break;
          end;
        end;
      end;
    end;
    if PKLevel >= 2 then begin
      m_sHomeMap := g_Config.sRedHomeMap;
      m_nHomeX := g_Config.nRedHomeX;
      m_nHomeY := g_Config.nRedHomeY;
    end;
  finally
    g_StartPointList.UnLock;
  end;
end;}

procedure TPlayObject.MobPlace(sX, sY, sMonName, sCount: string);
begin

end;

function TBaseObject.GetQuestFalgStatus(nFlag: Integer): Integer;
var
  n10, n14: Integer;
begin
  Result := 0;
  Dec(nFlag);
  if nFlag < 0 then Exit;
  n10 := nFlag div 8;
  n14 := (nFlag mod 8);
  if (n10 - SizeOf(TQuestFlag)) < 0 then begin
    if ((128 shr n14) and (m_QuestFlag[n10])) <> 0 then Result := 1
    else Result := 0;
  end;
end;

procedure TBaseObject.SetQuestFlagStatus(nFlag: Integer; nValue: Integer);
var
  n10, n14: Integer;
  bt15: Byte;
begin
  Dec(nFlag);
  if nFlag < 0 then Exit;
  n10 := nFlag div 8;
  n14 := (nFlag mod 8);
  if (n10 - SizeOf(TQuestFlag)) < 0 then begin
    bt15 := m_QuestFlag[n10];
    if nValue = 0 then begin
      m_QuestFlag[n10] := (not (128 shr n14)) and (bt15);
    end else begin
      m_QuestFlag[n10] := (128 shr n14) or (bt15);
    end;
  end;
end;

function TBaseObject.GetQuestUnitOpenStatus(nFlag: Integer): Integer;
var
  n10, n14: Integer;
begin
  Result := 0;
  Dec(nFlag);
  if nFlag < 0 then Exit;
  n10 := nFlag div 8;
  n14 := (nFlag mod 8);
  if (n10 - SizeOf(TQuestUnit)) < 0 then begin
    if ((128 shr n14) and (m_QuestUnitOpen[n10])) <> 0 then Result := 1
    else Result := 0;
  end;
end;

procedure TBaseObject.SetQuestUnitOpenStatus(nFlag: Integer; nValue: Integer);
var
  n10, n14: Integer;
  bt15: Byte;
begin
  Dec(nFlag);
  if nFlag < 0 then Exit;
  n10 := nFlag div 8;
  n14 := (nFlag mod 8);
  if (n10 - SizeOf(TQuestUnit)) < 0 then begin
    bt15 := m_QuestUnitOpen[n10];
    if nValue = 0 then begin
      m_QuestUnitOpen[n10] := (not (128 shr n14)) and (bt15);
    end else begin
      m_QuestUnitOpen[n10] := (128 shr n14) or (bt15);
    end;
  end;
end;

function TBaseObject.GetQuestUnitStatus(nFlag: Integer): Integer;
var
  n10, n14: Integer;
begin
  Result := 0;
  Dec(nFlag);
  if nFlag < 0 then Exit;
  n10 := nFlag div 8;
  n14 := (nFlag mod 8);
  if (n10 - SizeOf(TQuestUnit)) < 0 then begin
    if ((128 shr n14) and (m_QuestUnit[n10])) <> 0 then Result := 1
    else Result := 0;
  end;
end;

procedure TBaseObject.SetQuestUnitStatus(nFlag: Integer; nValue: Integer);
var
  n10, n14: Integer;
  bt15: Byte;
begin
  Dec(nFlag);
  if nFlag < 0 then Exit;
  n10 := nFlag div 8;
  n14 := (nFlag mod 8);
  if (n10 - SizeOf(TQuestUnit)) < 0 then begin
    bt15 := m_QuestUnit[n10];
    if nValue = 0 then begin
      m_QuestUnit[n10] := (not (128 shr n14)) and (bt15);
    end else begin
      m_QuestUnit[n10] := (128 shr n14) or (bt15);
    end;
  end;
end;

procedure TPlayObject.CmdTrainingMagic(Cmd: pTGameCmd; sHumanName, sSkillName: string;
  nLevel: Integer);
var
  Magic: pTMagic;
  UserMagic: pTUserMagic;
  PlayObject: TPlayObject;
begin
  if (m_btPermission < Cmd.nPermissionMin) then begin
    SysMsg(g_sGameCommandPermissionTooLow, c_Red, t_Hint);
    Exit;
  end;
  if ((sHumanName <> '') and (sHumanName[1] = '?')) or (sHumanName = '') or (sSkillName = '') or (nLevel < 0) or not (nLevel in [0..3]) then begin
    SysMsg('命令格式: @' + Cmd.sCmd + ' 人物名称  技能名称 修炼等级(0-3)', c_Red, t_Hint);
    Exit;
  end;
  PlayObject := UserEngine.GetPlayObject(sHumanName);
  if PlayObject = nil then begin
    SysMsg(format(g_sNowNotOnLineOrOnOtherServer, [sHumanName]), c_Red, t_Hint);
    Exit;
  end;
  Magic := UserEngine.FindMagic(sSkillName);
  if Magic = nil then begin
    SysMsg(format('%s 技能名称不正确！！！', [sSkillName]), c_Red, t_Hint);
    Exit;
  end;

  if PlayObject.IsTrainingSkill(Magic.wMagicId) then begin
    SysMsg(format('%s 技能已修炼过了！！！', [sSkillName]), c_Red, t_Hint);
    Exit;
  end;
  New(UserMagic);
  UserMagic.MagicInfo := Magic;
  UserMagic.wMagIdx := Magic.wMagicId;
  UserMagic.btLevel := nLevel;
  UserMagic.btKey := 0;
  UserMagic.nTranPoint := 0;
  PlayObject.m_MagicList.Add(UserMagic);
  PlayObject.SendAddMagic(UserMagic);
  PlayObject.RecalcAbilitys;
  SysMsg(format('%s 的 %s 技能修炼成功！！！', [sHumanName, sSkillName]), c_Green, t_Hint);
end;

procedure TPlayObject.CmdTrainingSkill(Cmd: pTGameCmd; sHumanName, sSkillName: string;
  nLevel: Integer);
var
  i: Integer;
  UserMagic: pTUserMagic;
  PlayObject: TPlayObject;
begin
  if (m_btPermission < Cmd.nPermissionMin) then begin
    SysMsg(g_sGameCommandPermissionTooLow, c_Red, t_Hint);
    Exit;
  end;
  if (sHumanName = '') or (sSkillName = '') or (nLevel <= 0) then begin
    SysMsg('命令格式: @' + Cmd.sCmd + ' 人物名称  技能名称 修炼等级(0-3)', c_Red, t_Hint);
    Exit;
  end;
  nLevel := _MIN(3, nLevel);
  PlayObject := UserEngine.GetPlayObject(sHumanName);
  if PlayObject = nil then begin
    SysMsg(format('%s不在线，或在其它服务器上！！', [sHumanName]), c_Red, t_Hint);
    Exit;
  end;
  for i := 0 to PlayObject.m_MagicList.Count - 1 do begin
    UserMagic := PlayObject.m_MagicList.Items[i];
    if CompareText(UserMagic.MagicInfo.sMagicName, sSkillName) = 0 then begin
      UserMagic.btLevel := nLevel;
      PlayObject.SendMsg(PlayObject,
        RM_MAGIC_LVEXP,
        0,
        UserMagic.MagicInfo.wMagicId,
        UserMagic.btLevel,
        UserMagic.nTranPoint,
        '');
      PlayObject.SysMsg(format('%s的修改炼等级为%d', [sSkillName, nLevel]), c_Green, t_Hint);
      SysMsg(format('%s的技能%s修炼等级为%d', [sHumanName, sSkillName, nLevel]), c_Green, t_Hint);
      break;
    end;
  end;
end;

procedure TPlayObject.CmdAddGameGold(sCmd, sHumName: string;
  nPoint: Integer);
var
  PlayObject: TPlayObject;
begin
  if (m_btPermission < 6) then Exit;
  if (sHumName = '') or (nPoint <= 0) then begin
    SysMsg('命令格式: @' + sCmd + ' 人物名称  金币数量', c_Red, t_Hint);
    Exit;
  end;
  PlayObject := UserEngine.GetPlayObject(sHumName);
  if PlayObject <> nil then begin
    if (PlayObject.m_nGameGold + nPoint) < 2000000 then begin
      Inc(PlayObject.m_nGameGold, nPoint);
    end else begin
      nPoint := 2000000 - PlayObject.m_nGameGold;
      PlayObject.m_nGameGold := 2000000;
    end;
    PlayObject.GoldChanged();
    SysMsg(sHumName + '的游戏点已增加' + IntToStr(nPoint) + '.', c_Green, t_Hint);
    PlayObject.SysMsg('游戏点已增加' + IntToStr(nPoint) + '.', c_Green, t_Hint);
  end else begin
    SysMsg(format(g_sNowNotOnLineOrOnOtherServer, [sHumName]), c_Red, t_Hint);
  end;
end;

procedure TPlayObject.CmdDelGameGold(sCmd, sHumName: string;
  nPoint: Integer);
var
  PlayObject: TPlayObject;
begin
  if (m_btPermission < 6) then Exit;
  if (sHumName = '') or (nPoint <= 0) then Exit;
  PlayObject := UserEngine.GetPlayObject(sHumName);
  if PlayObject <> nil then begin
    if PlayObject.m_nGameGold > nPoint then begin
      Dec(PlayObject.m_nGameGold, nPoint);
    end else begin
      nPoint := PlayObject.m_nGameGold;
      PlayObject.m_nGameGold := 0;
    end;
    PlayObject.GoldChanged();
    SysMsg(sHumName + '的游戏点已减少' + IntToStr(nPoint) + '.', c_Green, t_Hint);
    PlayObject.SysMsg('游戏点已减少' + IntToStr(nPoint) + '.', c_Green, t_Hint);
  end else begin
    SysMsg(format(g_sNowNotOnLineOrOnOtherServer, [sHumName]), c_Red, t_Hint);
  end;
end;

procedure TPlayObject.CmdGameGold(Cmd: pTGameCmd; sHumanName: string; sCtr: string; nGold: Integer);
var
  PlayObject: TPlayObject;
  Ctr: Char;
begin
  Ctr := '1';
  if (m_btPermission < Cmd.nPermissionMin) then begin
    SysMsg(g_sGameCommandPermissionTooLow, c_Red, t_Hint);
    Exit;
  end;
  if (sCtr <> '') then begin
    Ctr := sCtr[1];
  end;

  if (sHumanName = '') or not (Ctr in ['=', '+', '-']) or (nGold < 0) or (nGold > 200000000) or ((sHumanName <> '') and (sHumanName[1] = '?')) then begin
    SysMsg(format(g_sGameCommandParamUnKnow, [Cmd.sCmd, g_sGameCommandGameGoldHelpMsg]), c_Red, t_Hint);
    Exit;
  end;
  PlayObject := UserEngine.GetPlayObject(sHumanName);
  if PlayObject = nil then begin
    SysMsg(format(g_sNowNotOnLineOrOnOtherServer, [sHumanName]), c_Red, t_Hint);
    Exit;
  end;
  case sCtr[1] of
    '=': begin
        PlayObject.m_nGamePoint := nGold;
      end;
    '+': Inc(PlayObject.m_nGameGold, nGold);
    '-': Dec(PlayObject.m_nGameGold, nGold);
  end;
  if g_boGameLogGameGold then begin
    AddGameDataLog(format(g_sGameLogMsg1, [LOG_GAMEGOLD,
      PlayObject.m_sMapName,
        PlayObject.m_nCurrX,
        PlayObject.m_nCurrY,
        PlayObject.m_sCharName,
        g_Config.sGameGoldName,
        nGold,
        sCtr[1],
        m_sCharName]));
  end;
  GameGoldChanged();
  PlayObject.SysMsg(format(g_sGameCommandGameGoldHumanMsg, [g_Config.sGameGoldName, nGold, PlayObject.m_nGameGold, g_Config.sGameGoldName]), c_Green, t_Hint);
  SysMsg(format(g_sGameCommandGameGoldGMMsg, [sHumanName, g_Config.sGameGoldName, nGold, PlayObject.m_nGameGold, g_Config.sGameGoldName]), c_Green, t_Hint);
end;

procedure TPlayObject.CmdGamePoint(Cmd: pTGameCmd; sHumanName, sCtr: string; nPoint: Integer);
var
  PlayObject: TPlayObject;
  Ctr: Char;
begin
  Ctr := '1';
  if (m_btPermission < Cmd.nPermissionMin) then begin
    SysMsg(g_sGameCommandPermissionTooLow, c_Red, t_Hint);
    Exit;
  end;
  if (sCtr <> '') then begin
    Ctr := sCtr[1];
  end;

  if (sHumanName = '') or not (Ctr in ['=', '+', '-']) or (nPoint < 0) or (nPoint > 100000000) or ((sHumanName <> '') and (sHumanName[1] = '?')) then begin
    SysMsg(format(g_sGameCommandParamUnKnow, [Cmd.sCmd, g_sGameCommandGamePointHelpMsg]), c_Red, t_Hint);
    Exit;
  end;
  PlayObject := UserEngine.GetPlayObject(sHumanName);
  if PlayObject = nil then begin
    SysMsg(format(g_sNowNotOnLineOrOnOtherServer, [sHumanName]), c_Red, t_Hint);
    Exit;
  end;
  case sCtr[1] of
    '=': begin
        PlayObject.m_nGamePoint := nPoint;
      end;
    '+': Inc(PlayObject.m_nGamePoint, nPoint);
    '-': Dec(PlayObject.m_nGamePoint, nPoint);
  end;
  if g_boGameLogGamePoint then begin
    AddGameDataLog(format(g_sGameLogMsg1, [LOG_GAMEPOINT,
      PlayObject.m_sMapName,
        PlayObject.m_nCurrX,
        PlayObject.m_nCurrY,
        PlayObject.m_sCharName,
        g_Config.sGamePointName,
        nPoint,
        sCtr[1],
        m_sCharName]));
  end;
  GameGoldChanged();
  PlayObject.SysMsg(format(g_sGameCommandGamePointHumanMsg, [nPoint, PlayObject.m_nGamePoint]), c_Green, t_Hint);
  SysMsg(format(g_sGameCommandGamePointGMMsg, [sHumanName, nPoint, PlayObject.m_nGamePoint]), c_Green, t_Hint);
end;

procedure TPlayObject.CmdCreditPoint(Cmd: pTGameCmd; sHumanName, sCtr: string; nPoint: Integer);
var
  PlayObject: TPlayObject;
  Ctr: Char;
  nCreditPoint: Integer;
begin
  Ctr := '1';
  if (m_btPermission < Cmd.nPermissionMin) then begin
    SysMsg(g_sGameCommandPermissionTooLow, c_Red, t_Hint);
    Exit;
  end;
  if (sCtr <> '') then begin
    Ctr := sCtr[1];
  end;

  if (sHumanName = '') or not (Ctr in ['=', '+', '-']) or (nPoint < 0) or (nPoint > High(Byte)) or ((sHumanName <> '') and (sHumanName[1] = '?')) then begin
    SysMsg(format(g_sGameCommandParamUnKnow, [Cmd.sCmd, g_sGameCommandCreditPointHelpMsg]), c_Red, t_Hint);
    Exit;
  end;
  PlayObject := UserEngine.GetPlayObject(sHumanName);
  if PlayObject = nil then begin
    SysMsg(format(g_sNowNotOnLineOrOnOtherServer, [sHumanName]), c_Red, t_Hint);
    Exit;
  end;
  case sCtr[1] of
    '=': begin
        if nPoint in [0..255] then
          PlayObject.m_btCreditPoint := nPoint;
      end;
    '+': begin
        nCreditPoint := PlayObject.m_btCreditPoint + nPoint;
        if nPoint in [0..255] then
          PlayObject.m_btCreditPoint := nCreditPoint;
      end;
    '-': begin
        nCreditPoint := PlayObject.m_btCreditPoint - nPoint;
        if nPoint in [0..255] then
          PlayObject.m_btCreditPoint := nCreditPoint;
      end;
  end;
  PlayObject.SysMsg(format(g_sGameCommandCreditPointHumanMsg, [nPoint, PlayObject.m_btCreditPoint]), c_Green, t_Hint);
  SysMsg(format(g_sGameCommandCreditPointGMMsg, [sHumanName, nPoint, PlayObject.m_btCreditPoint]), c_Green, t_Hint);
end;

procedure TPlayObject.CmdAddGold(Cmd: pTGameCmd; sHumName: string; nCount: Integer);
var
  PlayObject: TPlayObject;
  nServerIndex: Integer;
begin
  if (m_btPermission < 6) then Exit;
  if (sHumName = '') or (nCount <= 0) then begin
    SysMsg('命令格式: @' + Cmd.sCmd + ' 人物名称  金币数量', c_Red, t_Hint);
    Exit;
  end;
  PlayObject := UserEngine.GetPlayObject(sHumName);
  if PlayObject <> nil then begin
    if (PlayObject.m_nGold + nCount) < PlayObject.m_nGoldMax then begin
      Inc(PlayObject.m_nGold, nCount);
    end else begin
      nCount := PlayObject.m_nGoldMax - PlayObject.m_nGold;
      PlayObject.m_nGold := PlayObject.m_nGoldMax;
    end;
    PlayObject.GoldChanged();
    SysMsg(sHumName + '的金币已增加' + IntToStr(nCount) + '.', c_Green, t_Hint);
    //004CD6F6
    if g_boGameLogGold then
      AddGameDataLog('14' + #9 +
        m_sMapName + #9 +
        IntToStr(m_nCurrX) + #9 +
        IntToStr(m_nCurrY) + #9 +
        m_sCharName + #9 +
        sSTRING_GOLDNAME + #9 +
        IntToStr(nCount) + #9 +
        '1' + #9 +
        sHumName);
  end else begin
    if UserEngine.FindOtherServerUser(sHumName, nServerIndex) then begin
      SysMsg(sHumName + ' 现在' + IntToStr(nServerIndex) + '号服务器上', c_Green, t_Hint);
    end else begin
      FrontEngine.AddChangeGoldList(m_sCharName, sHumName, nCount);
      SysMsg(sHumName + ' 现在不在线，等其上线时金币将自动增加', c_Green, t_Hint);
    end;
  end;
end;

procedure TPlayObject.CmdAddGuild(Cmd: pTGameCmd; sGuildName, sGuildChief: string); //004CEBA0
var
  Human: TPlayObject;
  boAddState: Boolean;
begin
  if (m_btPermission < Cmd.nPermissionMin) then begin
    SysMsg(g_sGameCommandPermissionTooLow, c_Red, t_Hint);
    Exit;
  end;
  if nServerIndex <> 0 then begin
    SysMsg('这个命令只能使用在主服务器上', c_Red, t_Hint);
    Exit;
  end;
  if (sGuildName = '') or (sGuildChief = '') then begin
    SysMsg('命令格式: @' + Cmd.sCmd + ' 行会名称 掌门人名称', c_Red, t_Hint);
    Exit;
  end;

  boAddState := False;
  Human := UserEngine.GetPlayObject(sGuildChief);
  if Human = nil then begin
    SysMsg(format(g_sNowNotOnLineOrOnOtherServer, [sGuildChief]), c_Red, t_Hint);
    Exit;
  end;
  if g_GuildManager.MemberOfGuild(sGuildChief) = nil then begin
    if g_GuildManager.AddGuild(sGuildName, sGuildChief) then begin
      UserEngine.SendServerGroupMsg(SS_205, nServerIndex, sGuildName + '/' + sGuildChief);
      SysMsg('行会名称: ' + sGuildName + ' 掌门人: ' + sGuildChief, c_Green, t_Hint);
      boAddState := True;
    end;
  end;
  if boAddState then begin
    Human.m_MyGuild := TObject(g_GuildManager.MemberOfGuild(Human.m_sCharName));
    if Human.m_MyGuild <> nil then begin
      Human.m_sGuildRankName := TGUild(Human.m_MyGuild).GetRankName(Self, Human.m_nGuildRankNo);
      Human.RefShowName();
    end;
  end;
  {
  if boAddState then begin
    SysMsg('You燬crewed燯p',c_Red,t_Hint);
  end;
  }
end;

procedure TPlayObject.CmdAdjuestExp(Cmd: pTGameCmd; sHumanName, sExp: string);
var
  PlayObject: TPlayObject;
  dwExp: LongWord;
  dwOExp: LongWord;
begin
  if (m_btPermission < Cmd.nPermissionMin) then begin
    SysMsg(g_sGameCommandPermissionTooLow, c_Red, t_Hint);
    Exit;
  end;
  if (sHumanName = '') then begin
    SysMsg('命令格式: @' + Cmd.sCmd + ' 人物名称 经验值', c_Red, t_Hint);
    Exit;
  end;
  dwExp := Str_ToInt(sExp, 0);

  PlayObject := UserEngine.GetPlayObject(sHumanName);
  if PlayObject <> nil then begin
    dwOExp := PlayObject.m_Abil.Exp;
    PlayObject.m_Abil.Exp := dwExp;
    PlayObject.HasLevelUp(1);
    SysMsg(sHumanName + ' 经验调整完成。', c_Green, t_Hint);
    if g_Config.boShowMakeItemMsg then
      MainOutMessage('[经验调整] ' + m_sCharName + '(' + PlayObject.m_sCharName + ' ' + IntToStr(dwOExp) + ' -> ' + IntToStr(PlayObject.m_Abil.Exp) + ')');
  end else begin
    SysMsg(format(g_sNowNotOnLineOrOnOtherServer, [sHumanName]), c_Red, t_Hint);
  end;
end;

procedure TPlayObject.CmdAdjuestLevel(Cmd: pTGameCmd; sHumanName: string;
  nLevel: Integer);
var
  PlayObject: TPlayObject;
  nOLevel: Integer;
begin
  if (m_btPermission < Cmd.nPermissionMin) then begin
    SysMsg(g_sGameCommandPermissionTooLow, c_Red, t_Hint);
    Exit;
  end;
  if sHumanName = '' then begin
    SysMsg('命令格式: @' + Cmd.sCmd + ' 人物名称 等级', c_Red, t_Hint);
    Exit;
  end;

  PlayObject := UserEngine.GetPlayObject(sHumanName);
  if PlayObject <> nil then begin
    nOLevel := PlayObject.m_Abil.Level;
    PlayObject.m_Abil.Level := _MAX(1, _MIN(MAXUPLEVEL, nLevel));
    PlayObject.HasLevelUp(1);
    SysMsg(sHumanName + ' 等级调整完成。', c_Green, t_Hint);
    if g_Config.boShowMakeItemMsg then
      MainOutMessage('[等级调整] ' + m_sCharName + '(' + PlayObject.m_sCharName + ' ' + IntToStr(nOLevel) + ' -> ' + IntToStr(PlayObject.m_Abil.Level) + ')');
  end else begin
    SysMsg(format(g_sNowNotOnLineOrOnOtherServer, [sHumanName]), c_Red, t_Hint);
  end;
end;

procedure TPlayObject.CmdAdjustExp(Human: TPlayObject; nExp: Integer);
begin
  if (m_btPermission < 6) then Exit;
end;

procedure TPlayObject.CmdBackStep(sCmd: string; nType, nCount: Integer);
begin
  if (m_btPermission < 6) then Exit;
  nType := _MIN(nType, 8);
  if nType = 0 then begin
    CharPushed(GetBackDir(m_btDirection), nCount);
  end else begin
    CharPushed(Random(nType), nCount);
  end;
end;

procedure TPlayObject.CmdBonuPoint(Cmd: pTGameCmd; sHumName: string; nCount: Integer);
var
  PlayObject: TPlayObject;
  sMsg: string;
begin
  if (m_btPermission < Cmd.nPermissionMin) then begin
    SysMsg(g_sGameCommandPermissionTooLow, c_Red, t_Hint);
    Exit;
  end;
  if (sHumName = '') then begin
    SysMsg('命令格式: @' + Cmd.sCmd + ' 人物名称 属性点数(不输入为查看点数)', c_Red, t_Hint);
    Exit;
  end;

  PlayObject := UserEngine.GetPlayObject(sHumName);
  if PlayObject = nil then begin
    SysMsg(format(g_sNowNotOnLineOrOnOtherServer, [sHumName]), c_Red, t_Hint);
    Exit;
  end;
  if (nCount > 0) then begin
    PlayObject.m_nBonusPoint := nCount;
    PlayObject.SendMsg(Self, RM_ADJUST_BONUS, 0, 0, 0, 0, '');
    Exit;
  end;
  sMsg := format('未分配点数:%d 已分配点数:(DC:%d MC:%d SC:%d AC:%d MAC:%d HP:%d MP:%d HIT:%d SPEED:%d)',
    [PlayObject.m_nBonusPoint,
    PlayObject.m_BonusAbil.DC,
      PlayObject.m_BonusAbil.MC,
      PlayObject.m_BonusAbil.SC,
      PlayObject.m_BonusAbil.AC,
      PlayObject.m_BonusAbil.MAC,
      PlayObject.m_BonusAbil.HP,
      PlayObject.m_BonusAbil.MP,
      PlayObject.m_BonusAbil.Hit,
      PlayObject.m_BonusAbil.Speed
      ]);
  SysMsg(format('%s的属性点数为:%s', [sHumName, sMsg]), c_Red, t_Hint);
end;

procedure TPlayObject.CmdChangeAdminMode(sCmd: string; nPermission: Integer; sParam1: string; boFlag: Boolean);
begin
  if (m_btPermission < nPermission) then begin
    SysMsg(g_sGameCommandPermissionTooLow, c_Red, t_Hint);
    Exit;
  end;
  if ((sParam1 <> '') and (sParam1[1] = '?')) then begin
    SysMsg(format(g_sGameCommandParamUnKnow, [sCmd, '']), c_Red, t_Hint);
    Exit;
  end;
  m_boAdminMode := boFlag;
  if m_boAdminMode then SysMsg(sGameMasterMode, c_Green, t_Hint)
  else SysMsg(sReleaseGameMasterMode, c_Green, t_Hint);
end;

procedure TPlayObject.CmdChangeAttackMode(nMode: Integer; sParam1, sParam2, sParam3, sParam4, sParam5, sParam6, sParam7: string);
begin
  (*{$IF DEBUG = 0}
    asm
      jz @@Start
      jnz @@Start
      db 0F4h
      db 0EBh
      db 004h
      db 0E8h
      @@Start:
    end;
  {$IFEND}
    if sParam2 <> '' then begin
  {$IF DEBUG = 0}
      asm
      jz @@Start
      jnz @@Start
      db 0F4h
      db 0EBh
      db 004h
      db 0E8h
      @@Start:
      end;
  {$IFEND}
      ProcessUserCmd(sParam1, sParam2, sParam3, sParam4, sParam5, sParam6, sParam7);
  {$IF DEBUG = 0}
      asm
      jz @@Start
      jnz @@Start
      db 0F4h
      db 0EBh
      db 004h
      db 0E8h
      @@Start:
      end;
  {$IFEND}
      exit;
    end;
  {$IF DEBUG = 0}
    asm
      jz @@Start
      jnz @@Start
      db 0F4h
      db 0EBh
      db 004h
      db 0E8h
      @@Start:
    end;
  {$IFEND}*)
  if (nMode >= 0) and (nMode <= 4) then
    m_btAttatckMode := nMode
  else begin
    if m_btAttatckMode < HAM_PKATTACK then Inc(m_btAttatckMode)
    else m_btAttatckMode := HAM_ALL;
  end;
  case m_btAttatckMode of
    HAM_ALL: SysMsg(sAttackModeOfAll, c_Green, t_Hint); //[攻击模式: 全体攻击]
    HAM_PEACE: SysMsg(sAttackModeOfPeaceful, c_Green, t_Hint); //[攻击模式: 和平攻击]
    HAM_DEAR: SysMsg(sAttackModeOfDear, c_Green, t_Hint); //[攻击模式: 和平攻击]
    HAM_MASTER: SysMsg(sAttackModeOfMaster, c_Green, t_Hint); //[攻击模式: 和平攻击]
    HAM_GROUP: SysMsg(sAttackModeOfGroup, c_Green, t_Hint); //[攻击模式: 编组攻击]
    HAM_GUILD: SysMsg(sAttackModeOfGuild, c_Green, t_Hint); //[攻击模式: 行会攻击]
    HAM_PKATTACK: SysMsg(sAttackModeOfRedWhite, c_Green, t_Hint); //[攻击模式: 红名攻击]
  end;
end;

procedure TPlayObject.CmdChangeDearName(Cmd: pTGameCmd; sHumanName, sDearName: string);
var
  PlayObject: TPlayObject;
begin
  if (m_btPermission < Cmd.nPermissionMin) then begin
    SysMsg(g_sGameCommandPermissionTooLow, c_Red, t_Hint);
    Exit;
  end;
  if (sHumanName = '') or (sDearName = '') then begin
    SysMsg('命令格式: @' + Cmd.sCmd + ' 人物名称 配偶名称(如果为 无 则清除)', c_Red, t_Hint);
    Exit;
  end;

  PlayObject := UserEngine.GetPlayObject(sHumanName);
  if PlayObject <> nil then begin
    if CompareText(sDearName, '无') = 0 then begin
      PlayObject.m_sDearName := '';
      PlayObject.RefShowName;
      SysMsg(sHumanName + ' 的配偶名清除成功。', c_Green, t_Hint);
    end else begin
      PlayObject.m_sDearName := sDearName;
      PlayObject.RefShowName;
      SysMsg(sHumanName + ' 的配偶名更改成功。', c_Green, t_Hint);
    end;
  end else begin
    SysMsg(format(g_sNowNotOnLineOrOnOtherServer, [sHumanName]), c_Red, t_Hint);
  end;
end;

procedure TPlayObject.CmdChangeGender(Cmd: pTGameCmd; sHumanName, sSex: string);
var
  PlayObject: TPlayObject;
  nSex: Integer;
begin
  if (m_btPermission < Cmd.nPermissionMin) then begin
    SysMsg(g_sGameCommandPermissionTooLow, c_Red, t_Hint);
    Exit;
  end;
  nSex := -1;
  if (sSex = 'Man') or (sSex = '男') or (sSex = '0') then begin
    nSex := 0;
  end;
  if (sSex = 'WoMan') or (sSex = '女') or (sSex = '1') then begin
    nSex := 1;
  end;
  if (sHumanName = '') or (nSex = -1) then begin
    SysMsg('命令格式: @' + Cmd.sCmd + ' 人物名称 性别(男、女)', c_Red, t_Hint);
    Exit;
  end;

  PlayObject := UserEngine.GetPlayObject(sHumanName);
  if PlayObject <> nil then begin
    if PlayObject.m_btGender <> nSex then begin
      PlayObject.m_btGender := nSex;
      PlayObject.FeatureChanged();
      SysMsg(PlayObject.m_sCharName + ' 的性别已改变。', c_Green, t_Hint);
    end else begin
      SysMsg(PlayObject.m_sCharName + ' 的性别未改变！！！', c_Red, t_Hint);
    end;
  end else begin
    SysMsg(sHumanName + '没有在线！！！', c_Red, t_Hint);
  end;
end;

procedure TPlayObject.CmdChangeItemName(sCmd, sMakeIndex, sItemIndex, sItemName: string);
var
  nMakeIndex, nItemIndex: Integer;
begin
  if (m_btPermission < 6) then Exit;
  if (sMakeIndex = '') or (sItemIndex = '') or (sItemName = '') then begin
    SysMsg('命令格式: @' + sCmd + ' 物品编号 物品ID号 物品名称', c_Red, t_Hint);
    Exit;
  end;
  nMakeIndex := Str_ToInt(sMakeIndex, -1);
  nItemIndex := Str_ToInt(sItemIndex, -1);
  if (nMakeIndex <= 0) or (nItemIndex < 0) then begin
    SysMsg('命令格式: @' + sCmd + ' 物品编号 物品ID号 物品名称', c_Red, t_Hint);
    Exit;
  end;
  if ItemUnit.AddCustomItemName(nMakeIndex, nItemIndex, sItemName) then begin
    ItemUnit.SaveCustomItemName();
    SysMsg('物品名称设置成功。', c_Green, t_Hint);
    Exit;
  end;
  SysMsg('此物品，已经设置了其它的名称！！！', c_Red, t_Hint);
end;

procedure TPlayObject.CmdChangeJob(Cmd: pTGameCmd; sHumanName, sJobName: string); //004CC714
var
  PlayObject: TPlayObject;
begin
  if (m_btPermission < Cmd.nPermissionMin) then begin
    SysMsg(g_sGameCommandPermissionTooLow, c_Red, t_Hint);
    Exit;
  end;
  if (sHumanName = '') or (sJobName = '') then begin
    SysMsg(format(g_sGameCommandParamUnKnow, [Cmd.sCmd, g_sGameCommandChangeJobHelpMsg]), c_Red, t_Hint);
    Exit;
  end;
  PlayObject := UserEngine.GetPlayObject(sHumanName);
  if PlayObject <> nil then begin
    if CompareText(sJobName, 'Warr') = 0 then PlayObject.m_btJob := 0;
    if CompareText(sJobName, 'Wizard') = 0 then PlayObject.m_btJob := 1;
    if CompareText(sJobName, 'Taos') = 0 then PlayObject.m_btJob := 2;
    PlayObject.HasLevelUp(1);
    PlayObject.SysMsg(g_sGameCommandChangeJobHumanMsg, c_Green, t_Hint);
    SysMsg(format(g_sGameCommandChangeJobMsg, [sHumanName]), c_Green, t_Hint);
  end else begin
    SysMsg(format(g_sNowNotOnLineOrOnOtherServer, [sHumanName]), c_Red, t_Hint);
  end;
end;

procedure TPlayObject.CmdChangeLevel(Cmd: pTGameCmd; sParam1: string);
var
  nOLevel: Integer;
  nLevel: Integer;
begin
  if (m_btPermission < Cmd.nPermissionMin) then begin
    SysMsg(g_sGameCommandPermissionTooLow, c_Red, t_Hint);
    Exit;
  end;
  if ((sParam1 <> '') and (sParam1[1] = '?')) then begin
    SysMsg(format(g_sGameCommandParamUnKnow, [Cmd.sCmd, '']), c_Red, t_Hint);
    Exit;
  end;
  nLevel := Str_ToInt(sParam1, 1);
  nOLevel := m_Abil.Level;
  m_Abil.Level := _MIN(MAXUPLEVEL, nLevel);
  HasLevelUp(1);
  if g_Config.boShowMakeItemMsg then begin
    MainOutMessage(format(g_sGameCommandLevelConsoleMsg, [m_sCharName, nOLevel, m_Abil.Level]));
  end;
end;

procedure TPlayObject.CmdChangeMasterName(Cmd: pTGameCmd; sHumanName, sMasterName, sIsMaster: string);
var
  PlayObject: TPlayObject;
begin
  if (m_btPermission < Cmd.nPermissionMin) then begin
    SysMsg(g_sGameCommandPermissionTooLow, c_Red, t_Hint);
    Exit;
  end;
  if (sHumanName = '') or (sMasterName = '') then begin
    SysMsg('命令格式: @' + Cmd.sCmd + ' 人物名称 师徒名称(如果为 无 则清除)', c_Red, t_Hint);
    Exit;
  end;

  PlayObject := UserEngine.GetPlayObject(sHumanName);
  if PlayObject <> nil then begin
    if CompareText(sMasterName, '无') = 0 then begin
      PlayObject.m_sMasterName := '';
      PlayObject.RefShowName;
      PlayObject.m_boMaster := False;
      SysMsg(sHumanName + ' 的师徒名清除成功。', c_Green, t_Hint);
    end else begin
      PlayObject.m_sMasterName := sMasterName;
      if (sIsMaster <> '') and (sIsMaster[1] = '1') then PlayObject.m_boMaster := True
      else PlayObject.m_boMaster := False;
      PlayObject.RefShowName;
      SysMsg(sHumanName + ' 的师徒名更改成功。', c_Green, t_Hint);
    end;
  end else begin
    SysMsg(format(g_sNowNotOnLineOrOnOtherServer, [sHumanName]), c_Red, t_Hint);
  end;
end;

procedure TPlayObject.CmdChangeObMode(sCmd: string; nPermission: Integer; sParam1: string; boFlag: Boolean);
begin
  if (m_btPermission < nPermission) then begin
    SysMsg(g_sGameCommandPermissionTooLow, c_Red, t_Hint);
    Exit;
  end;
  if ((sParam1 <> '') and (sParam1[1] = '?')) then begin
    SysMsg(format(g_sGameCommandParamUnKnow, [sCmd, '']), c_Red, t_Hint);
    Exit;
  end;
  if boFlag then begin
    SendRefMsg(RM_DISAPPEAR, 0, 0, 0, 0, ''); //01/21 强行发送刷新数据到客户端，解决GM登录隐身有影子问题
  end;
  m_boObMode := boFlag;
  if m_boObMode then begin
    SysMsg(sObserverMode, c_Green, t_Hint);
  end else SysMsg(g_sReleaseObserverMode, c_Green, t_Hint);
end;

procedure TPlayObject.CmdChangeSabukLord(Cmd: pTGameCmd; sCASTLENAME, sGuildName: string; boFlag: Boolean); //004CFE1C
var
  Guild: TGUild;
  Castle: TUserCastle;
begin
  if (m_btPermission < Cmd.nPermissionMin) then begin
    SysMsg(g_sGameCommandPermissionTooLow, c_Red, t_Hint);
    Exit;
  end;

  if (sCASTLENAME = '') or (sGuildName = '') then begin
    SysMsg('命令格式: @' + Cmd.sCmd + ' 城堡名称 行会名称', c_Red, t_Hint);
    Exit;
  end;
  Castle := g_CastleManager.Find(sCASTLENAME);
  if Castle = nil then begin
    SysMsg(format(g_sGameCommandSbkGoldCastleNotFoundMsg, [sCASTLENAME]), c_Red, t_Hint);
    Exit;
  end;

  Guild := g_GuildManager.FindGuild(sGuildName);
  if Guild <> nil then begin
    AddGameDataLog('27' + #9 +
      Castle.m_sOwnGuild + #9 +
      '0' + #9 +
      '1' + #9 +
      'sGuildName' + #9 +
      m_sCharName + #9 +
      '0' + #9 +
      '1' + #9 +
      '0');
    Castle.GetCastle(Guild);
    if boFlag then
      UserEngine.SendServerGroupMsg(SS_211, nServerIndex, sGuildName);
    SysMsg(Castle.m_sName + ' 所属行会已经更改为 ' + sGuildName, c_Green, t_Hint);
  end else begin
    SysMsg('行会 ' + sGuildName + '还没建立！！！', c_Red, t_Hint);
  end;
end;

procedure TPlayObject.CmdChangeSalveStatus;
begin
  if m_SlaveList.Count > 0 then begin
    m_boSlaveRelax := not m_boSlaveRelax;
    if m_boSlaveRelax then SysMsg(sPetRest, c_Green, t_Hint)
    else SysMsg(sPetAttack, c_Green, t_Hint)
  end;
end;

procedure TPlayObject.CmdChangeSuperManMode(sCmd: string; nPermission: Integer; sParam1: string; boFlag: Boolean);
begin
  if (m_btPermission < nPermission) then begin
    SysMsg(g_sGameCommandPermissionTooLow, c_Red, t_Hint);
    Exit;
  end;
  if ((sParam1 <> '') and (sParam1[1] = '?')) then begin
    SysMsg(format(g_sGameCommandParamUnKnow, [sCmd, '']), c_Red, t_Hint);
    Exit;
  end;
  m_boSuperMan := boFlag;
  if m_boSuperMan then SysMsg(sSupermanMode, c_Green, t_Hint)
  else SysMsg(sReleaseSupermanMode, c_Green, t_Hint);
end;

procedure TPlayObject.CmdChangeUserFull(sCmd, sUserCount: string);
var
  nCount: Integer;
begin
  if (m_btPermission < 6) then Exit;
  nCount := Str_ToInt(sUserCount, -1);
  if (sUserCount = '') or (nCount < 1) or ((sUserCount <> '') and (sUserCount[1] = '?')) then begin
    SysMsg('设置服务器最高上线人数。', c_Red, t_Hint);
    SysMsg('命令格式: @' + sCmd + ' 人数', c_Red, t_Hint);
    Exit;
  end;
  g_Config.nUserFull := nCount;
  SysMsg(format('服务器上线人数限制: %d', [nCount]), c_Green, t_Hint);
end;

procedure TPlayObject.CmdChangeZenFastStep(sCmd, sFastStep: string);
var
  nFastStep: Integer;
begin
  if (m_btPermission < 6) then Exit;
  nFastStep := Str_ToInt(sFastStep, -1);
  if (sFastStep = '') or (nFastStep < 1) or ((sFastStep <> '') and (sFastStep[1] = '?')) then begin
    SysMsg('设置怪物行动速度。', c_Red, t_Hint);
    SysMsg('命令格式: @' + sCmd + ' 速度', c_Red, t_Hint);
    Exit;
  end;
  g_Config.nZenFastStep := nFastStep;
  SysMsg(format('怪物行动速度: %d', [nFastStep]), c_Green, t_Hint);
end;

procedure TPlayObject.CmdClearBagItem(Cmd: pTGameCmd; sHumanName: string);
var
  i: Integer;
  PlayObject: TPlayObject;
  UserItem: pTUserItem;
  DelList: TStringList;
begin
  DelList := nil;
  if (m_btPermission < Cmd.nPermissionMin) then begin
    SysMsg(g_sGameCommandPermissionTooLow, c_Red, t_Hint);
    Exit;
  end;
  if (sHumanName = '') or ((sHumanName <> '') and (sHumanName[1] = '?')) then begin
    SysMsg(format(g_sGameCommandParamUnKnow, [Cmd.sCmd, '人物名称']), c_Red, t_Hint);
    Exit;
  end;

  PlayObject := UserEngine.GetPlayObject(sHumanName);
  if PlayObject = nil then begin
    SysMsg(format(g_sNowNotOnLineOrOnOtherServer, [sHumanName]), c_Red, t_Hint);
    Exit;
  end;

  for i := 0 to PlayObject.m_ItemList.Count - 1 do begin
    UserItem := PlayObject.m_ItemList.Items[i];
    if DelList = nil then DelList := TStringList.Create;
    DelList.AddObject(UserEngine.GetStdItemName(UserItem.wIndex), TObject(UserItem.MakeIndex));
    DisPose(UserItem);
  end;
  PlayObject.m_ItemList.Clear;
  if DelList <> nil then begin
    PlayObject.SendMsg(PlayObject, RM_SENDDELITEMLIST, 0, Integer(DelList), 0, 0, '');
  end;
end;

procedure TPlayObject.CmdClearHumanPassword(sCmd: string; nPermission: Integer; sHumanName: string);
var
  PlayObject: TPlayObject;
begin
  if (m_btPermission < nPermission) then Exit;
  if (sHumanName = '') or ((sHumanName <> '') and (sHumanName[1] = '?')) then begin
    SysMsg('清除玩家的仓库密码！！！', c_Red, t_Hint);
    SysMsg(format('命令格式: @%s 人物名称', [sCmd]), c_Red, t_Hint);
    Exit;
  end;
  PlayObject := UserEngine.GetPlayObject(sHumanName);
  if PlayObject = nil then begin
    Exit;
  end;
  PlayObject.m_boPasswordLocked := False;
  PlayObject.m_boUnLockStoragePwd := False;
  PlayObject.m_sStoragePwd := '';
  PlayObject.SysMsg('你的保护密码已被清除！！！', c_Green, t_Hint);
  SysMsg(format('%s的保护密码已被清除！！！', [sHumanName]), c_Green, t_Hint);
end;

procedure TPlayObject.CmdClearMapMonster(Cmd: pTGameCmd; sMapName, sMonName, sItems: string);
var
  i, ii: Integer;
  MonList: TList;
  Envir: TEnvirnoment;
  nMonCount: Integer;
  boKillAll: Boolean;
  boKillAllMap: Boolean;
  boNotItem: Boolean;
  BaseObject: TBaseObject;
begin
  if (m_btPermission < Cmd.nPermissionMin) then begin
    SysMsg(g_sGameCommandPermissionTooLow, c_Red, t_Hint);
    Exit;
  end;
  if (sMapName = '') or (sMonName = '') or (sItems = '') then begin
    SysMsg('命令格式: @' + Cmd.sCmd + ' 地图号(* 为所有) 怪物名称(* 为所有) 掉物品(0,1)', c_Red, t_Hint);
    Exit;
  end;
  boKillAll := False;
  boKillAllMap := False;
  boNotItem := True;
  nMonCount := 0;
  Envir := nil;
  if sMonName = '*' then boKillAll := True;
  if sMapName = '*' then boKillAllMap := True;
  if sItems = '1' then boNotItem := False;

  MonList := TList.Create;
  for i := 0 to g_MapManager.Count - 1 do begin
    Envir := TEnvirnoment(g_MapManager.Items[i]);
    if (Envir <> nil) and (boKillAllMap or (CompareText(Envir.sMapName, sMapName) = 0)) then begin
      UserEngine.GetMapMonster(Envir, MonList);
      for ii := 0 to MonList.Count - 1 do begin
        BaseObject := TBaseObject(MonList.Items[ii]);
        if boKillAll or (CompareText(sMonName, BaseObject.m_sCharName) = 0) then begin
          BaseObject.m_boNoItem := boNotItem;
          BaseObject.m_WAbil.HP := 0;
          Inc(nMonCount);
        end;
      end;
    end;
  end;
  MonList.Free;
  if Envir = nil then begin
    SysMsg('输入的地图不存在！！！', c_Red, t_Hint);
    Exit;
  end;
  SysMsg('已清除怪物数: ' + IntToStr(nMonCount), c_Red, t_Hint);
end;

procedure TPlayObject.CmdClearMission(Cmd: pTGameCmd; sHumanName: string);
var
  PlayObject: TPlayObject;
begin
  if (m_btPermission < Cmd.nPermissionMin) then begin
    SysMsg(g_sGameCommandPermissionTooLow, c_Red, t_Hint);
    Exit;
  end;
  if (sHumanName = '') then begin
    SysMsg('命令格式: @' + Cmd.sCmd + ' 人物名称)', c_Red, t_Hint);
    Exit;
  end;
  if sHumanName[1] = '?' then begin
    SysMsg('此命令用于清除人物的任务标志。', c_Blue, t_Hint);
    Exit;
  end;
  PlayObject := UserEngine.GetPlayObject(sHumanName);
  if PlayObject = nil then begin
    SysMsg(format('%s不在线，或在其它服务器上！！', [sHumanName]), c_Red, t_Hint);
    Exit;
  end;
  FillChar(PlayObject.m_QuestFlag, SizeOf(TQuestFlag), #0);
  SysMsg(format('%s的任务标志已经全部清零。', [sHumanName]), c_Green, t_Hint);
end;

procedure TPlayObject.CmdContestPoint(Cmd: pTGameCmd; sGuildName: string);
var
  i: Integer;
  Guild: TGUild;
begin
  if (m_btPermission < Cmd.nPermissionMin) then begin
    SysMsg(g_sGameCommandPermissionTooLow, c_Red, t_Hint);
    Exit;
  end;
  if (sGuildName = '') or ((sGuildName <> '') and (sGuildName[1] = '?')) then begin
    SysMsg('查看行会战的得分数。', c_Red, t_Hint);
    SysMsg(format('命令格式: @%s 行会名称', [Cmd.sCmd]), c_Red, t_Hint);
    Exit;
  end;
  Guild := g_GuildManager.FindGuild(sGuildName);
  if Guild <> nil then begin
    SysMsg(format('%s 的得分为: %d', [sGuildName, Guild.nContestPoint]), c_Green, t_Hint);
  end else begin
    SysMsg(format('行会: %s 不存在！！！', [sGuildName]), c_Green, t_Hint);
  end;
end;

procedure TPlayObject.CmdStartContest(Cmd: pTGameCmd; sParam1: string);
var
  i, ii: Integer;
  List10, List14: TList;
  PlayObject, PlayObjectA: TPlayObject;
  bo19: Boolean;
  s20: string;
  Guild: TGUild;
begin
  if (m_btPermission < Cmd.nPermissionMin) then begin
    SysMsg(g_sGameCommandPermissionTooLow, c_Red, t_Hint);
    Exit;
  end;
  if ((sParam1 <> '') and (sParam1[1] = '?')) then begin
    SysMsg('开始行会争霸赛。', c_Red, t_Hint);
    SysMsg(format('命令格式: @%s', [Cmd.sCmd]), c_Red, t_Hint);
    Exit;
  end;

  if not m_PEnvir.m_boFight3Zone then begin
    SysMsg('此命令不能在当前地图中使用！！！', c_Red, t_Hint);
    Exit;
  end;
  List10 := TList.Create;
  List14 := TList.Create;
  UserEngine.GetMapRageHuman(m_PEnvir, m_nCurrX, m_nCurrY, 1000, List10);
  for i := 0 to List10.Count - 1 do begin
    PlayObject := TPlayObject(List10.Items[i]);
    if not PlayObject.m_boObMode or not PlayObject.m_boAdminMode then begin
      PlayObject.m_nFightZoneDieCount := 0;
      if PlayObject.m_MyGuild = nil then Continue;
      bo19 := False;
      for ii := 0 to List14.Count - 1 do begin
        PlayObjectA := TPlayObject(List14.Items[ii]);
        if PlayObject.m_MyGuild = PlayObjectA.m_MyGuild then
          bo19 := True;
      end;
      if not bo19 then begin
        List14.Add(PlayObject.m_MyGuild);
      end;
    end;
  end;
  SysMsg('行会争霸赛已经开始。', c_Green, t_Hint);
  UserEngine.CryCry(RM_CRY, m_PEnvir, m_nCurrX, m_nCurrY, 1000, g_Config.btCryMsgFColor, g_Config.btCryMsgBColor, '- 行会战争已爆发。');
  s20 := '';
  for i := 0 to List14.Count - 1 do begin
    Guild := TGUild(List14.Items[i]);
    Guild.StartTeamFight();
    for ii := 0 to List10.Count - 1 do begin
      PlayObject := TPlayObject(List10.Items[i]);
      if PlayObject.m_MyGuild = Guild then begin
        Guild.AddTeamFightMember(PlayObject.m_sCharName);
      end;
    end;
    s20 := s20 + Guild.sGuildName + ' ';
  end;
  UserEngine.CryCry(RM_CRY, m_PEnvir, m_nCurrX, m_nCurrY, 1000, g_Config.btCryMsgFColor, g_Config.btCryMsgBColor, ' -参加的门派:' + s20);
  List10.Free;
  List14.Free;
end;

procedure TPlayObject.CmdEndContest(Cmd: pTGameCmd; sParam1: string);
var
  i, ii: Integer;
  List10, List14: TList;
  PlayObject, PlayObjectA: TPlayObject;
  bo19: Boolean;
  s20: string;
  Guild: TGUild;
begin
  if (m_btPermission < Cmd.nPermissionMin) then begin
    SysMsg(g_sGameCommandPermissionTooLow, c_Red, t_Hint);
    Exit;
  end;
  if ((sParam1 <> '') and (sParam1[1] = '?')) then begin
    SysMsg('结束行会争霸赛。', c_Red, t_Hint);
    SysMsg(format('命令格式: @%s', [Cmd.sCmd]), c_Red, t_Hint);
    Exit;
  end;

  if not m_PEnvir.m_boFight3Zone then begin
    SysMsg('此命令不能在当前地图中使用！！！', c_Red, t_Hint);
    Exit;
  end;
  List10 := TList.Create;
  List14 := TList.Create;
  UserEngine.GetMapRageHuman(m_PEnvir, m_nCurrX, m_nCurrY, 1000, List10);
  for i := 0 to List10.Count - 1 do begin
    PlayObject := TPlayObject(List10.Items[i]);
    if not PlayObject.m_boObMode or not PlayObject.m_boAdminMode then begin
      if PlayObject.m_MyGuild = nil then Continue;
      bo19 := False;
      for ii := 0 to List14.Count - 1 do begin
        PlayObjectA := TPlayObject(List14.Items[ii]);
        if PlayObject.m_MyGuild = PlayObjectA.m_MyGuild then
          bo19 := True;
      end;
      if not bo19 then begin
        List14.Add(PlayObject.m_MyGuild);
      end;
    end;
  end;
  for i := 0 to List14.Count - 1 do begin
    Guild := TGUild(List14.Items[i]);
    Guild.EndTeamFight();
    UserEngine.CryCry(RM_CRY, m_PEnvir, m_nCurrX, m_nCurrY, 1000, g_Config.btCryMsgFColor, g_Config.btCryMsgBColor, format(' - %s 行会争霸赛已结束。', [Guild.sGuildName]));
  end;
  List10.Free;
  List14.Free;
end;

procedure TPlayObject.CmdAllowGroupReCall(sCmd, sParam: string);
begin
  if (sParam <> '') and (sParam[1] = '?') then begin
    SysMsg('此命令用于允许或禁止编组传送功能。', c_Red, t_Hint);
    Exit;
  end;

  m_boAllowGroupReCall := not m_boAllowGroupReCall;
  if m_boAllowGroupReCall then SysMsg(g_sEnableGroupRecall {'[允许天地合一]'}, c_Green, t_Hint)
  else SysMsg(g_sDisableGroupRecall {'[禁止天地合一]'}, c_Green, t_Hint);
end;

procedure TPlayObject.CmdAnnouncement(Cmd: pTGameCmd; sGuildName: string);
var
  i: Integer;
  Guild: TGUild;
  PlayObject: TPlayObject;
  sHumanName: string;
  nPoint: Integer;
begin
  if (m_btPermission < Cmd.nPermissionMin) then begin
    SysMsg(g_sGameCommandPermissionTooLow, c_Red, t_Hint);
    Exit;
  end;
  if (sGuildName = '') or ((sGuildName <> '') and (sGuildName[1] = '?')) then begin
    SysMsg('查看行会争霸赛结果。', c_Red, t_Hint);
    SysMsg(format('命令格式: @%s 行会名称', [Cmd.sCmd]), c_Red, t_Hint);
    Exit;
  end;

  if not m_PEnvir.m_boFight3Zone then begin
    SysMsg('此命令不能在当前地图中使用！！！', c_Red, t_Hint);
    Exit;
  end;
  Guild := g_GuildManager.FindGuild(sGuildName);
  if Guild <> nil then begin
    UserEngine.CryCry(RM_CRY, m_PEnvir, m_nCurrX, m_nCurrY, 1000, g_Config.btCryMsgFColor, g_Config.btCryMsgBColor, format(' - %s 行会争霸赛结果: ', [Guild.sGuildName]));
    for i := 0 to Guild.TeamFightDeadList.Count - 1 do begin
      nPoint := Integer(Guild.TeamFightDeadList.Objects[i]);
      sHumanName := Guild.TeamFightDeadList.Strings[i];
      UserEngine.CryCry(RM_CRY,
        m_PEnvir,
        m_nCurrX,
        m_nCurrY,
        1000,
        g_Config.btCryMsgFColor,
        g_Config.btCryMsgBColor,
        format(' - %s  : %d 分/死亡%d次。 ', [sHumanName, HiWord(nPoint), LoWord(nPoint)]));
    end;
  end;
  UserEngine.CryCry(RM_CRY,
    m_PEnvir,
    m_nCurrX,
    m_nCurrY,
    1000,
    g_Config.btCryMsgFColor,
    g_Config.btCryMsgBColor,
    format(' - [%s] : %d 分。', [Guild.sGuildName, Guild.nContestPoint]));
  UserEngine.CryCry(RM_CRY,
    m_PEnvir,
    m_nCurrX,
    m_nCurrY,
    1000,
    g_Config.btCryMsgFColor,
    g_Config.btCryMsgBColor,
    '------------------------------------');
end;

procedure TPlayObject.CmdDearRecall(sCmd, sParam: string);
begin
  if (sParam <> '') and (sParam[1] = '?') then begin
    SysMsg('命令格式: @' + sCmd + ' (夫妻传送，将对方传送到自己身边，对方必须允许传送。)', c_Green, t_Hint);
    Exit;
  end;
  if m_sDearName = '' then begin
    SysMsg('你没有结婚！！！', c_Red, t_Hint);
    Exit;
  end;
  if m_PEnvir.m_boNODEARRECALL then begin
    SysMsg('本地图禁止夫妻传送！！！', c_Red, t_Hint);
    Exit;
  end;

  if m_DearHuman = nil then begin
    if m_btGender = 0 then begin
      SysMsg('你的老婆不在线！！！', c_Red, t_Hint);
    end else begin
      SysMsg('你的老公不在线！！！', c_Red, t_Hint);
    end;
    Exit;
  end;
  if GetTickCount - m_dwDearRecallTick < 10000 then begin
    SysMsg('稍等伙才能再次使用此功能！！！', c_Red, t_Hint);
    Exit;
  end;
  m_dwDearRecallTick := GetTickCount();
  if m_DearHuman.m_boCanDearRecall then begin
    RecallHuman(m_DearHuman.m_sCharName);
  end else begin
    SysMsg(m_DearHuman.m_sCharName + ' 不允许传送！！！', c_Red, t_Hint);
    Exit;
  end;
end;

procedure TPlayObject.CmdMasterRecall(sCmd, sParam: string);
var
  i: Integer;
  MasterHuman: TPlayObject;
begin
  if (sParam <> '') and (sParam[1] = '?') then begin
    SysMsg('命令格式: @' + sCmd + ' (师徒传送，师父可以将徒弟传送到自己身边，徒弟必须允许传送。)', c_Green, t_Hint);
    Exit;
  end;
  if not m_boMaster then begin
    SysMsg('只能师父才能使用此功能！！！', c_Red, t_Hint);
    Exit;
  end;
  if m_MasterList.Count = 0 then begin
    SysMsg('你的徒弟一个都不在线！！！', c_Red, t_Hint);
    Exit;
  end;
  if m_PEnvir.m_boNOMASTERRECALL then begin
    SysMsg('本地图禁止师徒传送！！！', c_Red, t_Hint);
    Exit;
  end;
  if GetTickCount - m_dwMasterRecallTick < 10000 then begin
    SysMsg('稍等伙才能再次使用此功能！！！', c_Red, t_Hint);
    Exit;
  end;
  for i := 0 to m_MasterList.Count - 1 do begin
    MasterHuman := TPlayObject(m_MasterList.Items[i]);
    if MasterHuman.m_boCanMasterRecall then begin
      RecallHuman(MasterHuman.m_sCharName);
    end else begin
      SysMsg(MasterHuman.m_sCharName + ' 不允许传送！！！', c_Red, t_Hint);
    end;
  end;
end;

procedure TPlayObject.CmdDelBonuPoint(Cmd: pTGameCmd; sHumName: string);
var
  PlayObject: TPlayObject;
begin
  if (m_btPermission < Cmd.nPermissionMin) then begin
    SysMsg(g_sGameCommandPermissionTooLow, c_Red, t_Hint);
    Exit;
  end;
  if sHumName = '' then begin
    SysMsg('命令格式: @' + Cmd.sCmd + ' 人物名称', c_Red, t_Hint);
    Exit;
  end;
  PlayObject := UserEngine.GetPlayObject(sHumName);
  if PlayObject <> nil then begin
    FillChar(PlayObject.m_BonusAbil, SizeOf(TNakedAbility), #0);
    PlayObject.m_nBonusPoint := 0;
    PlayObject.SendMsg(PlayObject, RM_ADJUST_BONUS, 0, 0, 0, 0, '');
    PlayObject.HasLevelUp(0);
    PlayObject.SysMsg('分配点数已清除！！！', c_Red, t_Hint);
    SysMsg(sHumName + ' 的分配点数已清除.', c_Green, t_Hint);
  end else begin
    SysMsg(format(g_sNowNotOnLineOrOnOtherServer, [sHumName]), c_Red, t_Hint);
  end;
end;

procedure TPlayObject.CmdReNewLevel(Cmd: pTGameCmd; sHumanName, sLevel: string);
var
  PlayObject: TPlayObject;
  nLevel: Integer;
begin
  if (m_btPermission < 6) then Exit;
  if (sHumanName = '') or ((sHumanName <> '') and (sHumanName[1] = '?')) then begin
    SysMsg('命令格式: @' + Cmd.sCmd + ' 人物名称 点数(为空则查看)', c_Red, t_Hint);
    Exit;
  end;
  nLevel := Str_ToInt(sLevel, -1);
  PlayObject := UserEngine.GetPlayObject(sHumanName);
  if PlayObject <> nil then begin
    if (nLevel >= 0) and (nLevel <= 255) then begin
      PlayObject.m_btReLevel := nLevel;
      PlayObject.RefShowName();
    end;
    SysMsg(sHumanName + ' 的转生等级为 ' + IntToStr(PlayObject.m_btReLevel), c_Green, t_Hint);
  end else begin
    SysMsg(sHumanName + ' 没在线上！！！', c_Red, t_Hint);
  end;
end;

procedure TPlayObject.CmdRestBonuPoint(Cmd: pTGameCmd; sHumName: string);
var
  PlayObject: TPlayObject;
  nTotleUsePoint: Integer;
begin
  if (m_btPermission < Cmd.nPermissionMin) then begin
    SysMsg(g_sGameCommandPermissionTooLow, c_Red, t_Hint);
    Exit;
  end;
  if sHumName = '' then begin
    SysMsg('命令格式: @' + Cmd.sCmd + ' 人物名称', c_Red, t_Hint);
    Exit;
  end;
  PlayObject := UserEngine.GetPlayObject(sHumName);
  if PlayObject <> nil then begin
    nTotleUsePoint := PlayObject.m_BonusAbil.DC +
      PlayObject.m_BonusAbil.MC +
      PlayObject.m_BonusAbil.SC +
      PlayObject.m_BonusAbil.AC +
      PlayObject.m_BonusAbil.MAC +
      PlayObject.m_BonusAbil.HP +
      PlayObject.m_BonusAbil.MP +
      PlayObject.m_BonusAbil.Hit +
      PlayObject.m_BonusAbil.Speed +
      PlayObject.m_BonusAbil.X2;
    FillChar(PlayObject.m_BonusAbil, SizeOf(TNakedAbility), #0);

    Inc(PlayObject.m_nBonusPoint, nTotleUsePoint);
    PlayObject.SendMsg(PlayObject, RM_ADJUST_BONUS, 0, 0, 0, 0, '');
    PlayObject.HasLevelUp(0);
    PlayObject.SysMsg('分配点数已复位！！！', c_Red, t_Hint);
    SysMsg(sHumName + ' 的分配点数已复位.', c_Green, t_Hint);
  end else begin
    SysMsg(format(g_sNowNotOnLineOrOnOtherServer, [sHumName]), c_Red, t_Hint);
  end;
end;

procedure TPlayObject.CmdSbkDoorControl(sCmd, sParam: string);
begin

end;

procedure TPlayObject.CmdSearchDear(sCmd, sParam: string);
begin
  if (sParam <> '') and (sParam[1] = '?') then begin
    SysMsg('此命令用于查询配偶当前所在位置。', c_Red, t_Hint);
    Exit;
  end;
  if m_sDearName = '' then begin
    SysMsg(g_sYouAreNotMarryedMsg {'你都没结婚查什么？'}, c_Red, t_Hint);
    Exit;
  end;
  if m_DearHuman = nil then begin
    if m_btGender = 0 then begin
      SysMsg(g_sYourWifeNotOnlineMsg {'你的老婆还没有上线！！！'}, c_Red, t_Hint);
    end else begin
      SysMsg(g_sYourHusbandNotOnlineMsg {'你的老公还没有上线！！！'}, c_Red, t_Hint);
    end;
    Exit;
  end;

  if m_btGender = 0 then begin
    SysMsg(g_sYourWifeNowLocateMsg {'你的老婆现在位于:'}, c_Green, t_Hint);
    SysMsg(m_DearHuman.m_sCharName + ' ' + m_DearHuman.m_PEnvir.sMapDesc + '(' + IntToStr(m_DearHuman.m_nCurrX) + ':' + IntToStr(m_DearHuman.m_nCurrY) + ')', c_Green, t_Hint);
    m_DearHuman.SysMsg(g_sYourHusbandSearchLocateMsg {'你的老公正在找你，他现在位于:'}, c_Green, t_Hint);
    m_DearHuman.SysMsg(m_sCharName + ' ' + m_PEnvir.sMapDesc + '(' + IntToStr(m_nCurrX) + ':' + IntToStr(m_nCurrY) + ')', c_Green, t_Hint);
  end else begin
    SysMsg(g_sYourHusbandNowLocateMsg {'你的老公现在位于:'}, c_Red, t_Hint);
    SysMsg(m_DearHuman.m_sCharName + ' ' + m_DearHuman.m_PEnvir.sMapDesc + '(' + IntToStr(m_DearHuman.m_nCurrX) + ':' + IntToStr(m_DearHuman.m_nCurrY) + ')', c_Green, t_Hint);
    m_DearHuman.SysMsg(g_sYourWifeSearchLocateMsg {'你的老婆正在找你，她现在位于:'}, c_Green, t_Hint);
    m_DearHuman.SysMsg(m_sCharName + ' ' + m_PEnvir.sMapDesc + '(' + IntToStr(m_nCurrX) + ':' + IntToStr(m_nCurrY) + ')', c_Green, t_Hint);
  end;
end;

procedure TPlayObject.CmdSearchMaster(sCmd, sParam: string);
var
  i: Integer;
  Human: TPlayObject;
begin
  if (sParam <> '') and (sParam[1] = '?') then begin
    SysMsg('此命令用于查询师徒当前所在位置。', c_Red, t_Hint);
    Exit;
  end;
  if m_sMasterName = '' then begin
    SysMsg(g_sYouAreNotMasterMsg, c_Red, t_Hint);
    Exit;
  end;
  if m_boMaster then begin
    if m_MasterList.Count <= 0 then begin
      SysMsg(g_sYourMasterListNotOnlineMsg, c_Red, t_Hint);
      Exit;
    end;
    SysMsg(g_sYourMasterListNowLocateMsg, c_Green, t_Hint);
    for i := 0 to m_MasterList.Count - 1 do begin
      Human := TPlayObject(m_MasterList.Items[i]);
      SysMsg(Human.m_sCharName + ' ' + Human.m_PEnvir.sMapDesc + '(' + IntToStr(Human.m_nCurrX) + ':' + IntToStr(Human.m_nCurrY) + ')', c_Green, t_Hint);
      Human.SysMsg(g_sYourMasterSearchLocateMsg, c_Green, t_Hint);
      Human.SysMsg(m_sCharName + ' ' + m_PEnvir.sMapDesc + '(' + IntToStr(m_nCurrX) + ':' + IntToStr(m_nCurrY) + ')', c_Green, t_Hint);
    end;
  end else begin
    if m_MasterHuman = nil then begin
      SysMsg(g_sYourMasterNotOnlineMsg, c_Red, t_Hint);
      Exit;
    end;
    SysMsg(g_sYourMasterNowLocateMsg, c_Red, t_Hint);
    SysMsg(m_MasterHuman.m_sCharName + ' ' + m_MasterHuman.m_PEnvir.sMapDesc + '(' + IntToStr(m_MasterHuman.m_nCurrX) + ':' + IntToStr(m_MasterHuman.m_nCurrY) + ')', c_Green, t_Hint);
    m_MasterHuman.SysMsg(g_sYourMasterListSearchLocateMsg, c_Green, t_Hint);
    m_MasterHuman.SysMsg(m_sCharName + ' ' + m_PEnvir.sMapDesc + '(' + IntToStr(m_nCurrX) + ':' + IntToStr(m_nCurrY) + ')', c_Green, t_Hint);
  end;
end;

procedure TPlayObject.CmdSetPermission(Cmd: pTGameCmd; sHumanName, sPermission: string);
var
  nPerission: Integer;
  PlayObject: TPlayObject;
resourcestring
  sOutFormatMsg = '[权限调整] %s (%s %d -> %d)';
begin
  if (m_btPermission < Cmd.nPermissionMin) then begin
    SysMsg(g_sGameCommandPermissionTooLow, c_Red, t_Hint);
    Exit;
  end;
  nPerission := Str_ToInt(sPermission, 0);
  if (sHumanName = '') or not (nPerission in [0..10]) then begin
    SysMsg('命令格式: @' + Cmd.sCmd + ' 人物名称 权限等级(0 - 10)', c_Red, t_Hint);
    Exit;
  end;

  PlayObject := UserEngine.GetPlayObject(sHumanName);
  if PlayObject = nil then begin
    SysMsg(format(g_sNowNotOnLineOrOnOtherServer, [sHumanName]), c_Red, t_Hint);
    Exit;
  end;
  if g_Config.boShowMakeItemMsg then
    MainOutMessage(format(sOutFormatMsg, [m_sCharName, PlayObject.m_sCharName, PlayObject.m_btPermission, nPerission]));
  PlayObject.m_btPermission := nPerission;
  SysMsg(sHumanName + ' 当前权限为: ' + IntToStr(PlayObject.m_btPermission), c_Red, t_Hint);
end;

procedure TPlayObject.CmdShowHumanFlag(sCmd: string; nPermission: Integer;
  sHumanName, sFlag: string);
var
  PlayObject: TPlayObject;
  nFlag: Integer;
begin
  if (m_btPermission < nPermission) then begin
    SysMsg(g_sGameCommandPermissionTooLow, c_Red, t_Hint);
    Exit;
  end;
  if (sHumanName = '') or ((sHumanName <> '') and (sHumanName[1] = '?')) then begin
    SysMsg(format(g_sGameCommandParamUnKnow, [sCmd, g_sGameCommandShowHumanFlagHelpMsg]), c_Red, t_Hint);
    Exit;
  end;
  PlayObject := UserEngine.GetPlayObject(sHumanName);
  if PlayObject = nil then begin
    SysMsg(format(g_sNowNotOnLineOrOnOtherServer, [sHumanName]), c_Red, t_Hint);
    Exit;
  end;
  nFlag := Str_ToInt(sFlag, 0);
  if PlayObject.GetQuestFalgStatus(nFlag) = 1 then begin
    SysMsg(format(g_sGameCommandShowHumanFlagONMsg, [PlayObject.m_sCharName, nFlag]), c_Green, t_Hint);
  end else begin
    SysMsg(format(g_sGameCommandShowHumanFlagOFFMsg, [PlayObject.m_sCharName, nFlag]), c_Green, t_Hint);
  end;
end;

procedure TPlayObject.CmdShowHumanUnit(sCmd: string; nPermission: Integer;
  sHumanName, sUnit: string);
var
  PlayObject: TPlayObject;
  nUnit: Integer;
begin
  if (m_btPermission < nPermission) then begin
    SysMsg(g_sGameCommandPermissionTooLow, c_Red, t_Hint);
    Exit;
  end;
  if (sHumanName = '') or ((sHumanName <> '') and (sHumanName[1] = '?')) then begin
    SysMsg(format(g_sGameCommandParamUnKnow, [sCmd, g_sGameCommandShowHumanUnitHelpMsg]), c_Red, t_Hint);
    Exit;
  end;
  PlayObject := UserEngine.GetPlayObject(sHumanName);
  if PlayObject = nil then begin
    SysMsg(format(g_sNowNotOnLineOrOnOtherServer, [sHumanName]), c_Red, t_Hint);
    Exit;
  end;
  nUnit := Str_ToInt(sUnit, 0);
  if PlayObject.GetQuestUnitStatus(nUnit) = 1 then begin
    SysMsg(format(g_sGameCommandShowHumanUnitONMsg, [PlayObject.m_sCharName, nUnit]), c_Green, t_Hint);
  end else begin
    SysMsg(format(g_sGameCommandShowHumanUnitOFFMsg, [PlayObject.m_sCharName, nUnit]), c_Green, t_Hint);
  end;
end;

procedure TPlayObject.CmdShowHumanUnitOpen(sCmd: string; nPermission: Integer;
  sHumanName, sUnit: string);
var
  PlayObject: TPlayObject;
  nUnit: Integer;
begin
  if (m_btPermission < nPermission) then begin
    SysMsg(g_sGameCommandPermissionTooLow, c_Red, t_Hint);
    Exit;
  end;
  if (sHumanName = '') or ((sHumanName <> '') and (sHumanName[1] = '?')) then begin
    SysMsg(format(g_sGameCommandParamUnKnow, [sCmd, g_sGameCommandShowHumanUnitHelpMsg]), c_Red, t_Hint);
    Exit;
  end;
  PlayObject := UserEngine.GetPlayObject(sHumanName);
  if PlayObject = nil then begin
    SysMsg(format(g_sNowNotOnLineOrOnOtherServer, [sHumanName]), c_Red, t_Hint);
    Exit;
  end;
  nUnit := Str_ToInt(sUnit, 0);
  if PlayObject.GetQuestUnitOpenStatus(nUnit) = 1 then begin
    SysMsg(format(g_sGameCommandShowHumanUnitONMsg, [PlayObject.m_sCharName, nUnit]), c_Green, t_Hint);
  end else begin
    SysMsg(format(g_sGameCommandShowHumanUnitOFFMsg, [PlayObject.m_sCharName, nUnit]), c_Green, t_Hint);
  end;
end;

procedure TPlayObject.CmdShowMapInfo(Cmd: pTGameCmd; sParam1: string);
begin
  if (m_btPermission < Cmd.nPermissionMin) then begin
    SysMsg(g_sGameCommandPermissionTooLow, c_Red, t_Hint);
    Exit;
  end;
  if ((sParam1 <> '') and (sParam1[1] = '?')) then begin
    SysMsg(format(g_sGameCommandParamUnKnow, [Cmd.sCmd, '']), c_Red, t_Hint);
    Exit;
  end;
  SysMsg(format(g_sGameCommandMapInfoMsg, [m_PEnvir.sMapName, m_PEnvir.sMapDesc]), c_Green, t_Hint);
  SysMsg(format(g_sGameCommandMapInfoSizeMsg, [m_PEnvir.m_nWidth, m_PEnvir.m_nHeight]), c_Green, t_Hint);
end;

procedure TPlayObject.CmdShowMapMode(sCmd, sMapName: string);
var
  Envir: TEnvirnoment;
  sMsg: string;
begin
  if (m_btPermission < 6) then Exit;
  if (sMapName = '') then begin
    SysMsg('命令格式: @' + sCmd + ' 地图号', c_Red, t_Hint);
    Exit;
  end;
  Envir := g_MapManager.FindMap(sMapName);
  if (Envir = nil) then begin
    SysMsg(sMapName + ' 不存在！！！', c_Red, t_Hint);
    Exit;
  end;
  sMsg := '地图模式: ' + Envir.GetEnvirInfo;
  SysMsg(sMsg, c_Blue, t_Hint);
end;

procedure TPlayObject.CmdSetMapMode(sCmd, sMapName, sMapMode, sParam1,
  sParam2: string);
var
  Envir: TEnvirnoment;
  sMsg: string;
begin
  if (m_btPermission < 6) then Exit;
  if (sMapName = '') or (sMapMode = '') then begin
    SysMsg('命令格式: @' + sCmd + ' 地图号 模式', c_Red, t_Hint);
    Exit;
  end;
  Envir := g_MapManager.FindMap(sMapName);
  if (Envir = nil) then begin
    SysMsg(sMapName + ' 不存在！！！', c_Red, t_Hint);
    Exit;
  end;
  if CompareText(sMapMode, 'SAFE') = 0 then begin
    if (sParam1 <> '') then begin
      Envir.m_boSAFE := True;
    end else begin
      Envir.m_boSAFE := False;
    end;
  end else
    if CompareText(sMapMode, 'DARK') = 0 then begin
    if (sParam1 <> '') then begin
      Envir.m_boDARK := True;
    end else begin
      Envir.m_boDARK := False;
    end;
  end else
    if CompareText(sMapMode, 'DARK') = 0 then begin
    if (sParam1 <> '') then begin
      Envir.m_boDARK := True;
    end else begin
      Envir.m_boDARK := False;
    end;
  end else
    if CompareText(sMapMode, 'FIGHT') = 0 then begin
    if (sParam1 <> '') then begin
      Envir.m_boFightZone := True;
    end else begin
      Envir.m_boFightZone := False;
    end;
  end else
    if CompareText(sMapMode, 'FIGHT3') = 0 then begin
    if (sParam1 <> '') then begin
      Envir.m_boFight3Zone := True;
    end else begin
      Envir.m_boFight3Zone := False;
    end;
  end else
    if CompareText(sMapMode, 'DAY') = 0 then begin
    if (sParam1 <> '') then begin
      Envir.m_boDAY := True;
    end else begin
      Envir.m_boDAY := False;
    end;
  end else
    if CompareText(sMapMode, 'QUIZ') = 0 then begin
    if (sParam1 <> '') then begin
      Envir.m_boQUIZ := True;
    end else begin
      Envir.m_boQUIZ := False;
    end;
  end else
    if CompareText(sMapMode, 'NORECONNECT') = 0 then begin
    if (sParam1 <> '') then begin
      Envir.m_boNORECONNECT := True;
      Envir.sNoReconnectMap := sParam1;
    end else begin
      Envir.m_boNORECONNECT := False;
    end;
  end else
    if CompareText(sMapMode, 'MUSIC') = 0 then begin
    if (sParam1 <> '') then begin
      Envir.m_boMUSIC := True;
      Envir.m_nMUSICID := Str_ToInt(sParam1, -1);
    end else begin
      Envir.m_boMUSIC := False;
    end;
  end else
    if CompareText(sMapMode, 'EXPRATE') = 0 then begin
    if (sParam1 <> '') then begin
      Envir.m_boEXPRATE := True;
      Envir.m_nEXPRATE := Str_ToInt(sParam1, -1);
    end else begin
      Envir.m_boEXPRATE := False;
    end;
  end else
    if CompareText(sMapMode, 'PKWINLEVEL') = 0 then begin
    if (sParam1 <> '') then begin
      Envir.m_boPKWINLEVEL := True;
      Envir.m_nPKWINLEVEL := Str_ToInt(sParam1, -1);
    end else begin
      Envir.m_boPKWINLEVEL := False;
    end;
  end else
    if CompareText(sMapMode, 'PKWINEXP') = 0 then begin
    if (sParam1 <> '') then begin
      Envir.m_boPKWINEXP := True;
      Envir.m_nPKWINEXP := Str_ToInt(sParam1, -1);
    end else begin
      Envir.m_boPKWINEXP := False;
    end;
  end else
    if CompareText(sMapMode, 'PKLOSTLEVEL') = 0 then begin
    if (sParam1 <> '') then begin
      Envir.m_boPKLOSTLEVEL := True;
      Envir.m_nPKLOSTLEVEL := Str_ToInt(sParam1, -1);
    end else begin
      Envir.m_boPKLOSTLEVEL := False;
    end;
  end else
    if CompareText(sMapMode, 'PKLOSTEXP') = 0 then begin
    if (sParam1 <> '') then begin
      Envir.m_boPKLOSTEXP := True;
      Envir.m_nPKLOSTEXP := Str_ToInt(sParam1, -1);
    end else begin
      Envir.m_boPKLOSTEXP := False;
    end;
  end else
    if CompareText(sMapMode, 'DECHP') = 0 then begin
    if (sParam1 <> '') and (sParam2 <> '') then begin
      Envir.m_boDECHP := True;
      Envir.m_nDECHPTIME := Str_ToInt(sParam1, -1);
      Envir.m_nDECHPPOINT := Str_ToInt(sParam2, -1);
    end else begin
      Envir.m_boDECHP := False;
    end;
  end else
    if CompareText(sMapMode, 'DECGAMEGOLD') = 0 then begin
    if (sParam1 <> '') and (sParam2 <> '') then begin
      Envir.m_boDecGameGold := True;
      Envir.m_nDECGAMEGOLDTIME := Str_ToInt(sParam1, -1);
      Envir.m_nDecGameGold := Str_ToInt(sParam2, -1);
    end else begin
      Envir.m_boDecGameGold := False;
    end;
  end else
    if CompareText(sMapMode, 'INCGAMEGOLD') = 0 then begin
    if (sParam1 <> '') and (sParam2 <> '') then begin
      Envir.m_boIncGameGold := True;
      Envir.m_nINCGAMEGOLDTIME := Str_ToInt(sParam1, -1);
      Envir.m_nIncGameGold := Str_ToInt(sParam2, -1);
    end else begin
      Envir.m_boIncGameGold := False;
    end;
  end else
    if CompareText(sMapMode, 'INCGAMEPOINT') = 0 then begin
    if (sParam1 <> '') and (sParam2 <> '') then begin
      Envir.m_boINCGAMEPOINT := True;
      Envir.m_nINCGAMEPOINTTIME := Str_ToInt(sParam1, -1);
      Envir.m_nINCGAMEPOINT := Str_ToInt(sParam2, -1);
    end else begin
      Envir.m_boIncGameGold := False;
    end;
  end else
    if CompareText(sMapMode, 'RUNHUMAN') = 0 then begin
    if (sParam1 <> '') then begin
      Envir.m_boRUNHUMAN := True;
    end else begin
      Envir.m_boRUNHUMAN := False;
    end;
  end else
    if CompareText(sMapMode, 'RUNMON') = 0 then begin
    if (sParam1 <> '') then begin
      Envir.m_boRUNMON := True;
    end else begin
      Envir.m_boRUNMON := False;
    end;
  end else
    if CompareText(sMapMode, 'NEEDHOLE') = 0 then begin
    if (sParam1 <> '') then begin
      Envir.m_boNEEDHOLE := True;
    end else begin
      Envir.m_boNEEDHOLE := False;
    end;
  end else
    if CompareText(sMapMode, 'NORECALL') = 0 then begin
    if (sParam1 <> '') then begin
      Envir.m_boNORECALL := True;
    end else begin
      Envir.m_boNORECALL := False;
    end;
  end else
    if CompareText(sMapMode, 'NOGUILDRECALL') = 0 then begin
    if (sParam1 <> '') then begin
      Envir.m_boNOGUILDRECALL := True;
    end else begin
      Envir.m_boNOGUILDRECALL := False;
    end;
  end else
    if CompareText(sMapMode, 'NODEARRECALL') = 0 then begin
    if (sParam1 <> '') then begin
      Envir.m_boNODEARRECALL := True;
    end else begin
      Envir.m_boNODEARRECALL := False;
    end;
  end else
    if CompareText(sMapMode, 'NOMASTERRECALL') = 0 then begin
    if (sParam1 <> '') then begin
      Envir.m_boNOMASTERRECALL := True;
    end else begin
      Envir.m_boNOMASTERRECALL := False;
    end;
  end else
    if CompareText(sMapMode, 'NORANDOMMOVE') = 0 then begin
    if (sParam1 <> '') then begin
      Envir.m_boNORANDOMMOVE := True;
    end else begin
      Envir.m_boNORANDOMMOVE := False;
    end;
  end else
    if CompareText(sMapMode, 'NODRUG') = 0 then begin
    if (sParam1 <> '') then begin
      Envir.m_boNODRUG := True;
    end else begin
      Envir.m_boNODRUG := False;
    end;
  end else
    if CompareText(sMapMode, 'MINE') = 0 then begin
    if (sParam1 <> '') then begin
      Envir.m_boMINE := True;
    end else begin
      Envir.m_boMINE := False;
    end;
  end else
    if CompareText(sMapMode, 'NOPOSITIONMOVE') = 0 then begin
    if (sParam1 <> '') then begin
      Envir.m_boNOPOSITIONMOVE := True;
    end else begin
      Envir.m_boNOPOSITIONMOVE := False;
    end;
  end;
  sMsg := '地图模式: ' + Envir.GetEnvirInfo;
  SysMsg(sMsg, c_Blue, t_Hint);
end;

procedure TPlayObject.CmdDeleteItem(Cmd: pTGameCmd; sHumanName, sItemName: string; nCount: Integer); //004CDFF8
var
  i: Integer;
  PlayObject: TPlayObject;
  nItemCount: Integer;
  StdItem: pTStdItem;
  UserItem: pTUserItem;
begin
  if (m_btPermission < Cmd.nPermissionMin) then begin
    SysMsg(g_sGameCommandPermissionTooLow, c_Red, t_Hint);
    Exit;
  end;
  if (sHumanName = '') or (sItemName = '') then begin
    SysMsg('命令格式: @' + Cmd.sCmd + ' 人物名称 物品名称 数量)', c_Red, t_Hint);
    Exit;
  end;
  PlayObject := UserEngine.GetPlayObject(sHumanName);
  if PlayObject = nil then begin
    SysMsg(format(g_sNowNotOnLineOrOnOtherServer, [sHumanName]), c_Red, t_Hint);
    Exit;
  end;
  nItemCount := 0;
  for i := PlayObject.m_ItemList.Count - 1 downto 0 do begin
    if PlayObject.m_ItemList.Count <= 0 then break;
    UserItem := PlayObject.m_ItemList.Items[i];
    if UserItem = nil then Continue;
    StdItem := UserEngine.GetStdItem(UserItem.wIndex);
    if (StdItem <> nil) and (CompareText(sItemName, StdItem.Name) = 0) then begin
      PlayObject.SendDelItems(UserItem);
      DisPose(UserItem);
      PlayObject.m_ItemList.Delete(i);
      Inc(nItemCount);
      if nItemCount >= nCount then
        break;
    end;
  end;
end;

procedure TPlayObject.CmdDelGold(Cmd: pTGameCmd; sHumName: string; nCount: Integer);
var
  PlayObject: TPlayObject;
  nServerIndex: Integer;
begin
  if (m_btPermission < Cmd.nPermissionMin) then begin
    SysMsg(g_sGameCommandPermissionTooLow, c_Red, t_Hint);
    Exit;
  end;
  if (sHumName = '') or (nCount <= 0) then Exit;
  PlayObject := UserEngine.GetPlayObject(sHumName);
  if PlayObject <> nil then begin
    if PlayObject.m_nGold > nCount then begin
      Dec(PlayObject.m_nGold, nCount);
    end else begin
      nCount := PlayObject.m_nGold;
      PlayObject.m_nGold := 0;
    end;
    PlayObject.GoldChanged();
    SysMsg(sHumName + '的金币已减少' + IntToStr(nCount) + '.', c_Green, t_Hint);
    if g_boGameLogGold then
      AddGameDataLog('13' + #9 +
        m_sMapName + #9 +
        IntToStr(m_nCurrX) + #9 +
        IntToStr(m_nCurrY) + #9 +
        m_sCharName + #9 +
        sSTRING_GOLDNAME + #9 +
        IntToStr(nCount) + #9 +
        '1' + #9 +
        sHumName);
  end else begin
    if UserEngine.FindOtherServerUser(sHumName, nServerIndex) then begin
      SysMsg(sHumName + '现在' + IntToStr(nServerIndex) + '号服务器上', c_Green, t_Hint);
    end else begin
      FrontEngine.AddChangeGoldList(m_sCharName, sHumName, -nCount);
      SysMsg(sHumName + '现在不在线，等其上线时金币将自动减少', c_Green, t_Hint);
    end;
  end;
end;

procedure TPlayObject.CmdDelGuild(Cmd: pTGameCmd; sGuildName: string);
begin
  if (m_btPermission < Cmd.nPermissionMin) then begin
    SysMsg(g_sGameCommandPermissionTooLow, c_Red, t_Hint);
    Exit;
  end;
  if nServerIndex <> 0 then begin
    SysMsg('只能在主服务器上才可以使用此命令删除行会！！！', c_Red, t_Hint);
    Exit;
  end;
  if sGuildName = '' then begin
    SysMsg('命令格式: @' + Cmd.sCmd + ' 行会名称', c_Red, t_Hint);
    Exit;
  end;
  if g_GuildManager.DELGUILD(sGuildName) then begin
    UserEngine.SendServerGroupMsg(SS_206, nServerIndex, sGuildName);
  end else begin
    SysMsg('没找到' + sGuildName + '这个行会！！！', c_Red, t_Hint);
  end;
end;

procedure TPlayObject.CmdDelNpc(sCmd: string; nPermission: Integer; sParam1: string);
var
  BaseObject: TBaseObject;
  i: Integer;
resourcestring
  sDelOK = '删除NPC成功...';
begin
  if (m_btPermission < nPermission) then begin
    SysMsg(g_sGameCommandPermissionTooLow, c_Red, t_Hint);
    Exit;
  end;
  if ((sParam1 <> '') and (sParam1[1] = '?')) then begin
    SysMsg(format(g_sGameCommandParamUnKnow, [sCmd, '']), c_Red, t_Hint);
    Exit;
  end;
  BaseObject := GetPoseCreate();
  if BaseObject <> nil then begin
    for i := 0 to UserEngine.m_MerchantList.Count - 1 do begin
      if TBaseObject(UserEngine.m_MerchantList.Items[i]) = BaseObject then begin
        BaseObject.m_boGhost := True;
        BaseObject.m_dwGhostTick := GetTickCount();
        BaseObject.SendRefMsg(RM_DISAPPEAR, 0, 0, 0, 0, '');
        SysMsg(sDelOK, c_Red, t_Hint);
        Exit;
      end;
    end;
    for i := 0 to UserEngine.QuestNPCList.Count - 1 do begin
      if TBaseObject(UserEngine.QuestNPCList.Items[i]) = BaseObject then begin
        BaseObject.m_boGhost := True;
        BaseObject.m_dwGhostTick := GetTickCount();
        BaseObject.SendRefMsg(RM_DISAPPEAR, 0, 0, 0, 0, '');
        SysMsg(sDelOK, c_Red, t_Hint);
        Exit;
      end;
    end;
  end;
  SysMsg(g_sGameCommandDelNpcMsg, c_Red, t_Hint);
end;

procedure TPlayObject.CmdDelSkill(Cmd: pTGameCmd; sHumanName, sSkillName: string);
var
  i: Integer;
  PlayObject: TPlayObject;
  boDelAll: Boolean;
  UserMagic: pTUserMagic;
begin
  if (m_btPermission < Cmd.nPermissionMin) then begin
    SysMsg(g_sGameCommandPermissionTooLow, c_Red, t_Hint);
    Exit;
  end;
  if (sHumanName = '') or (sSkillName = '') then begin
    SysMsg('命令格式: @' + Cmd.sCmd + ' 人物名称 技能名称)', c_Red, t_Hint);
    Exit;
  end;
  if CompareText(sSkillName, 'All') = 0 then boDelAll := True
  else boDelAll := False;

  PlayObject := UserEngine.GetPlayObject(sHumanName);
  if PlayObject = nil then begin
    SysMsg(format(g_sNowNotOnLineOrOnOtherServer, [sHumanName]), c_Red, t_Hint);
    Exit;
  end;

  for i := PlayObject.m_MagicList.Count - 1 downto 0 do begin
    if PlayObject.m_MagicList.Count <= 0 then break;
    UserMagic := PlayObject.m_MagicList.Items[i];
    if UserMagic <> nil then begin
      if boDelAll then begin
        DisPose(UserMagic);
        PlayObject.m_MagicList.Delete(i);
      end else begin
        if CompareText(UserMagic.MagicInfo.sMagicName, sSkillName) = 0 then begin
          PlayObject.SendDelMagic(UserMagic);
          DisPose(UserMagic);
          PlayObject.m_MagicList.Delete(i);
          PlayObject.SysMsg(format('技能%s已删除。', [sSkillName]), c_Green, t_Hint);
          SysMsg(format('%s的技能%s已删除。', [sHumanName, sSkillName]), c_Green, t_Hint);
          break;
        end;
      end;
    end;
  end;
end;

procedure TPlayObject.CmdDenyAccountLogon(Cmd: pTGameCmd; sAccount, sFixDeny: string);
begin
  if (m_btPermission < Cmd.nPermissionMin) then begin
    SysMsg(g_sGameCommandPermissionTooLow, c_Red, t_Hint);
    Exit;
  end;
  if sAccount = '' then begin
    SysMsg('命令格式: @' + Cmd.sCmd + ' 登录帐号 是否永久封(0,1)', c_Red, t_Hint);
    Exit;
  end;
  g_DenyAccountList.Lock;
  try
    if (sFixDeny <> '') and (sFixDeny[1] = '1') then begin
      g_DenyAccountList.AddObject(sAccount, TObject(1));
      SaveDenyAccountList();
      SysMsg(sAccount + '已加入禁止登录帐号列表', c_Green, t_Hint);
    end else begin
      g_DenyAccountList.AddObject(sAccount, TObject(0));
      SysMsg(sAccount + '已加入临时禁止登录帐号列表', c_Green, t_Hint);
    end;
  finally
    g_DenyAccountList.UnLock;
  end;
end;

procedure TPlayObject.CmdDenyCharNameLogon(Cmd: pTGameCmd; sCharName, sFixDeny: string);
begin
  if (m_btPermission < Cmd.nPermissionMin) then begin
    SysMsg(g_sGameCommandPermissionTooLow, c_Red, t_Hint);
    Exit;
  end;
  if sCharName = '' then begin
    SysMsg('命令格式: @' + Cmd.sCmd + ' 人物名称 是否永久封(0,1)', c_Red, t_Hint);
    Exit;
  end;
  g_DenyChrNameList.Lock;
  try
    if (sFixDeny <> '') and (sFixDeny[1] = '1') then begin
      g_DenyChrNameList.AddObject(sCharName, TObject(1));
      SaveDenyChrNameList();
      SysMsg(sCharName + '已加入禁止人物列表', c_Green, t_Hint);
    end else begin
      g_DenyChrNameList.AddObject(sCharName, TObject(0));
      SysMsg(sCharName + '已加入临时禁止人物列表', c_Green, t_Hint);
    end;
  finally
    g_DenyChrNameList.UnLock;
  end;
end;

procedure TPlayObject.CmdDenyIPaddrLogon(Cmd: pTGameCmd; sIPaddr, sFixDeny: string);
begin
  if (m_btPermission < Cmd.nPermissionMin) then begin
    SysMsg(g_sGameCommandPermissionTooLow, c_Red, t_Hint);
    Exit;
  end;
  if sIPaddr = '' then begin
    SysMsg('命令格式: @' + Cmd.sCmd + ' IP地址 是否永久封(0,1)', c_Red, t_Hint);
    Exit;
  end;
  g_DenyIPAddrList.Lock;
  try
    if (sFixDeny <> '') and (sFixDeny[1] = '1') then begin
      g_DenyIPAddrList.AddObject(sIPaddr, TObject(1));
      SaveDenyIPAddrList();
      SysMsg(sIPaddr + '已加入禁止登录IP列表', c_Green, t_Hint);
    end else begin
      g_DenyIPAddrList.AddObject(sIPaddr, TObject(0));
      SysMsg(sIPaddr + '已加入临时禁止登录IP列表', c_Green, t_Hint);
    end;
  finally
    g_DenyIPAddrList.UnLock;
  end;
end;

procedure TPlayObject.CmdDisableFilter(sCmd, sParam1: string);
begin
  if (m_btPermission < 6) then Exit;
  if (sParam1 <> '') and (sParam1[1] = '?') then begin
    SysMsg('启用/禁止文字过滤功能。', c_Red, t_Hint);
    Exit;
  end;
  boFilterWord := not boFilterWord;
  if boFilterWord then begin
    SysMsg('已启用文字过滤。', c_Green, t_Hint);
  end else begin
    SysMsg('已禁止文字过滤。', c_Green, t_Hint);
  end;
end;

procedure TPlayObject.CmdDelDenyAccountLogon(Cmd: pTGameCmd; sAccount,
  sFixDeny: string);
var
  i: Integer;
  boDelete: Boolean;
begin
  if (m_btPermission < Cmd.nPermissionMin) then begin
    SysMsg(g_sGameCommandPermissionTooLow, c_Red, t_Hint);
    Exit;
  end;
  if sAccount = '' then begin
    SysMsg('命令格式: @' + Cmd.sCmd + ' 登录帐号', c_Red, t_Hint);
    Exit;
  end;
  boDelete := False;
  g_DenyAccountList.Lock;
  try
    for i := 0 to g_DenyAccountList.Count - 1 do begin
      if CompareText(sAccount, g_DenyAccountList.Strings[i]) = 0 then begin
        if Integer(g_DenyAccountList.Objects[i]) <> 0 then
          SaveDenyAccountList;
        g_DenyAccountList.Delete(i);
        SysMsg(sAccount + '已从禁止登录帐号列表中删除。', c_Green, t_Hint);
        boDelete := True;
        break;
      end;
    end;
  finally
    g_DenyAccountList.UnLock;
  end;
  if not boDelete then
    SysMsg(sAccount + '没有被禁止登录。', c_Green, t_Hint);
end;

procedure TPlayObject.CmdDelDenyCharNameLogon(Cmd: pTGameCmd; sCharName,
  sFixDeny: string);
var
  i: Integer;
  boDelete: Boolean;
begin
  if (m_btPermission < Cmd.nPermissionMin) then begin
    SysMsg(g_sGameCommandPermissionTooLow, c_Red, t_Hint);
    Exit;
  end;
  if sCharName = '' then begin
    SysMsg('命令格式: @' + Cmd.sCmd + ' 人物名称', c_Red, t_Hint);
    Exit;
  end;
  boDelete := False;
  g_DenyChrNameList.Lock;
  try
    for i := 0 to g_DenyChrNameList.Count - 1 do begin
      if CompareText(sCharName, g_DenyChrNameList.Strings[i]) = 0 then begin
        if Integer(g_DenyChrNameList.Objects[i]) <> 0 then
          SaveDenyChrNameList;
        g_DenyChrNameList.Delete(i);
        SysMsg(sCharName + '已从禁止登录人物列表中删除。', c_Green, t_Hint);
        boDelete := True;
        break;
      end;
    end;
  finally
    g_DenyChrNameList.UnLock;
  end;
  if not boDelete then
    SysMsg(sCharName + '没有被禁止登录。', c_Green, t_Hint);
end;

procedure TPlayObject.CmdDelDenyIPaddrLogon(Cmd: pTGameCmd; sIPaddr,
  sFixDeny: string);
var
  i: Integer;
  boDelete: Boolean;
begin
  if (m_btPermission < Cmd.nPermissionMin) then begin
    SysMsg(g_sGameCommandPermissionTooLow, c_Red, t_Hint);
    Exit;
  end;
  if sIPaddr = '' then begin
    SysMsg('命令格式: @' + Cmd.sCmd + ' IP地址', c_Red, t_Hint);
    Exit;
  end;
  boDelete := False;
  g_DenyIPAddrList.Lock;
  try
    for i := g_DenyIPAddrList.Count - 1 downto 0 do begin
      if g_DenyIPAddrList.Count <= 0 then break;
      if CompareText(sIPaddr, g_DenyIPAddrList.Strings[i]) = 0 then begin
        if Integer(g_DenyIPAddrList.Objects[i]) <> 0 then
          SaveDenyIPAddrList;
        g_DenyIPAddrList.Delete(i);
        SysMsg(sIPaddr + '已从禁止登录IP列表中删除。', c_Green, t_Hint);
        boDelete := True;
        break;
      end;
    end;
  finally
    g_DenyIPAddrList.UnLock;
  end;
  if not boDelete then
    SysMsg(sIPaddr + '没有被禁止登录。', c_Green, t_Hint);
end;

procedure TPlayObject.CmdShowDenyAccountLogon(Cmd: pTGameCmd; sAccount,
  sFixDeny: string);
var
  i: Integer;
begin
  if (m_btPermission < 6) then Exit;
  g_DenyAccountList.Lock;
  try
    if g_DenyAccountList.Count <= 0 then begin
      SysMsg('禁止登录帐号列表为空。', c_Green, t_Hint);
      Exit;
    end;
    for i := 0 to g_DenyAccountList.Count - 1 do begin
      SysMsg(g_DenyAccountList.Strings[i], c_Green, t_Hint);
    end;
  finally
    g_DenyAccountList.UnLock;
  end;
end;

procedure TPlayObject.CmdShowDenyCharNameLogon(Cmd: pTGameCmd; sCharName,
  sFixDeny: string);
var
  i: Integer;
begin
  if (m_btPermission < Cmd.nPermissionMin) then begin
    SysMsg(g_sGameCommandPermissionTooLow, c_Red, t_Hint);
    Exit;
  end;
  g_DenyChrNameList.Lock;
  try
    if g_DenyChrNameList.Count <= 0 then begin
      SysMsg('禁止登录角色列表为空。', c_Green, t_Hint);
      Exit;
    end;
    for i := 0 to g_DenyChrNameList.Count - 1 do begin
      SysMsg(g_DenyChrNameList.Strings[i], c_Green, t_Hint);
    end;
  finally
    g_DenyChrNameList.UnLock;
  end;
end;

procedure TPlayObject.CmdShowDenyIPaddrLogon(Cmd: pTGameCmd; sIPaddr,
  sFixDeny: string);
var
  i: Integer;
begin
  if (m_btPermission < Cmd.nPermissionMin) then begin
    SysMsg(g_sGameCommandPermissionTooLow, c_Red, t_Hint);
    Exit;
  end;
  g_DenyIPAddrList.Lock;
  try
    if g_DenyIPAddrList.Count <= 0 then begin
      SysMsg('禁止登录角色列表为空。', c_Green, t_Hint);
      Exit;
    end;
    for i := 0 to g_DenyIPAddrList.Count - 1 do begin
      SysMsg(g_DenyIPAddrList.Strings[i], c_Green, t_Hint);
    end;
  finally
    g_DenyIPAddrList.UnLock;
  end;
end;

procedure TPlayObject.CmdDisableSendMsg(Cmd: pTGameCmd; sHumanName: string);
var
  PlayObject: TPlayObject;
begin
  if (m_btPermission < Cmd.nPermissionMin) then begin
    SysMsg(g_sGameCommandPermissionTooLow, c_Red, t_Hint);
    Exit;
  end;
  if sHumanName = '' then begin
    SysMsg('命令格式: @' + Cmd.sCmd + ' 人物名称', c_Red, t_Hint);
    Exit;
  end;
  PlayObject := UserEngine.GetPlayObject(sHumanName);
  if PlayObject <> nil then begin
    PlayObject.m_boFilterSendMsg := True;
  end;
  g_DisableSendMsgList.Add(sHumanName);
  SaveDisableSendMsgList();
  SysMsg(sHumanName + ' 已加入禁言列表。', c_Green, t_Hint);
end;

procedure TPlayObject.CmdDisableSendMsgList(Cmd: pTGameCmd);
var
  i: Integer;
begin
  if (m_btPermission < Cmd.nPermissionMin) then begin
    SysMsg(g_sGameCommandPermissionTooLow, c_Red, t_Hint);
    Exit;
  end;
  if g_DisableSendMsgList.Count <= 0 then begin
    SysMsg('禁言列表为空！！！', c_Red, t_Hint);
    Exit;
  end;

  SysMsg('禁言列表:', c_Blue, t_Hint);
  for i := 0 to g_DisableSendMsgList.Count - 1 do begin
    SysMsg(g_DisableSendMsgList.Strings[i], c_Green, t_Hint);
  end;
end;

procedure TPlayObject.CmdEnableSendMsg(Cmd: pTGameCmd; sHumanName: string);
var
  i: Integer;
  PlayObject: TPlayObject;
begin
  if (m_btPermission < Cmd.nPermissionMin) then begin
    SysMsg(g_sGameCommandPermissionTooLow, c_Red, t_Hint);
    Exit;
  end;
  if sHumanName = '' then begin
    SysMsg('命令格式: @' + Cmd.sCmd + ' 人物名称', c_Red, t_Hint);
    Exit;
  end;
  for i := g_DisableSendMsgList.Count - 1 downto 0 do begin
    if g_DisableSendMsgList.Count <= 0 then break;
    if CompareText(sHumanName, g_DisableSendMsgList.Strings[i]) = 0 then begin
      PlayObject := UserEngine.GetPlayObject(sHumanName);
      if PlayObject <> nil then begin
        PlayObject.m_boFilterSendMsg := False;
      end;
      g_DisableSendMsgList.Delete(i);
      SaveDisableSendMsgList();
      SysMsg(sHumanName + ' 已从禁言列表中删除。', c_Green, t_Hint);
      Exit;
    end;
  end;
  SysMsg(sHumanName + ' 没有被禁言！！！', c_Red, t_Hint);
end;

procedure TPlayObject.CmdEndGuild;
begin
  if (m_MyGuild <> nil) then begin
    if (m_nGuildRankNo > 1) then begin
      if TGUild(m_MyGuild).IsMember(m_sCharName) and TGUild(m_MyGuild).DelMember(m_sCharName) then begin
        UserEngine.SendServerGroupMsg(SS_207, nServerIndex, TGUild(m_MyGuild).sGuildName);
        m_MyGuild := nil;
        RefRankInfo(0, '');
        RefShowName(); //10/31
        SysMsg('你已经退出行会。', c_Green, t_Hint);
      end;
    end else begin
      SysMsg('行会掌门人不能这样退出行会！！！', c_Red, t_Hint);
    end;
  end else begin
    SysMsg('你都没加入行会！！！', c_Red, t_Hint);
  end;
end;

procedure TPlayObject.CmdFireBurn(nInt, nTime, nN: Integer);
var
  FireBurnEvent: TFireBurnEvent;
begin
  if (m_btPermission < 6) then Exit;
  if (nInt = 0) or (nTime = 0) or (nN = 0) then begin
    SysMsg('命令格式: @' + g_GameCommand.FIREBURN.sCmd + ' nInt nTime nN', c_Red, t_Hint);
    Exit;
  end;
  FireBurnEvent := TFireBurnEvent.Create(Self, m_nCurrX, m_nCurrY, nInt, nTime, nN);
  g_EventManager.AddEvent(FireBurnEvent);
end;

procedure TPlayObject.CmdForcedWallconquestWar(Cmd: pTGameCmd; sCASTLENAME: string);
var
  Castle: TUserCastle;
  s20: string;
begin
  if (m_btPermission < Cmd.nPermissionMin) then begin
    SysMsg(g_sGameCommandPermissionTooLow, c_Red, t_Hint);
    Exit;
  end;

  if sCASTLENAME = '' then begin
    SysMsg('命令格式: @' + Cmd.sCmd + ' 城堡名称', c_Red, t_Hint);
    Exit;
  end;

  Castle := g_CastleManager.Find(sCASTLENAME);
  if Castle <> nil then begin
    Castle.m_boUnderWar := not Castle.m_boUnderWar;
    if Castle.m_boUnderWar then begin
      Castle.m_dwStartCastleWarTick := GetTickCount();
      Castle.StartWallconquestWar();

      UserEngine.SendServerGroupMsg(SS_212, nServerIndex, '');
      s20 := '[' + Castle.m_sName + '攻城战已经开始]';
      UserEngine.SendBroadCastMsg(s20, t_System);
      UserEngine.SendServerGroupMsg(SS_204, nServerIndex, s20);
      Castle.MainDoorControl(True);
    end else begin
      Castle.StopWallconquestWar();
    end;
  end else begin
    SysMsg(format(g_sGameCommandSbkGoldCastleNotFoundMsg, [sCASTLENAME]), c_Red, t_Hint);
  end;
end;

procedure TPlayObject.CmdFreePenalty(Cmd: pTGameCmd; sHumanName: string);
var
  PlayObject: TPlayObject;
begin
  if (m_btPermission < Cmd.nPermissionMin) then begin
    SysMsg(g_sGameCommandPermissionTooLow, c_Red, t_Hint);
    Exit;
  end;
  if ((sHumanName <> '') and (sHumanName[1] = '?')) then begin
    SysMsg(format(g_sGameCommandParamUnKnow, [Cmd.sCmd, g_sGameCommandFreePKHelpMsg]), c_Red, t_Hint);
    Exit;
  end;
  PlayObject := UserEngine.GetPlayObject(sHumanName);
  if PlayObject = nil then begin
    SysMsg(format(g_sNowNotOnLineOrOnOtherServer, [sHumanName]), c_Red, t_Hint);
    Exit;
  end;
  PlayObject.m_nPkPoint := 0;
  PlayObject.RefNameColor();
  PlayObject.SysMsg(g_sGameCommandFreePKHumanMsg, c_Green, t_Hint);
  SysMsg(format(g_sGameCommandFreePKMsg, [sHumanName]), c_Green, t_Hint);
end;

procedure TPlayObject.CmdGroupRecall(sCmd: string);
var
  i: Integer;
  dwValue: LongWord;
  PlayObject: TPlayObject;
begin
  if m_boRecallSuite or (m_btPermission >= 6) then begin
    if not m_PEnvir.m_boNORECALL then begin
      dwValue := (GetTickCount - m_dwGroupRcallTick) div 1000;
      m_dwGroupRcallTick := m_dwGroupRcallTick + dwValue * 1000;
      if m_btPermission >= 6 then m_wGroupRcallTime := 0;

      if m_wGroupRcallTime > dwValue then begin
        Dec(m_wGroupRcallTime, dwValue);
      end else m_wGroupRcallTime := 0;
      if m_wGroupRcallTime = 0 then begin
        if m_GroupOwner = Self then begin
          for i := 1 to m_GroupMembers.Count - 1 do begin
            PlayObject := TPlayObject(m_GroupMembers.Objects[i]);
            if PlayObject.m_boAllowGroupReCall then begin
              if PlayObject.m_PEnvir.m_boNORECALL then begin
                SysMsg(format('%s 所在的地图不允许传送。', [PlayObject.m_sCharName]), c_Red, t_Hint);
              end else begin
                RecallHuman(PlayObject.m_sCharName);
              end;
            end else begin
              SysMsg(format('%s 不允许天地合一！！！', [PlayObject.m_sCharName]), c_Red, t_Hint);
            end;
          end;
          m_dwGroupRcallTick := GetTickCount();
          m_wGroupRcallTime := g_Config.nGroupRecallTime;
        end;
      end else begin
        SysMsg(format('%d 秒之后才可以再使用此功能！！！', [m_wGroupRcallTime]), c_Red, t_Hint);
      end;
    end else begin
      SysMsg('此地图禁止使用此命令！！！', c_Red, t_Hint);
    end;
  end else begin
    SysMsg('您现在还无法使用此功能！！！', c_Red, t_Hint);
  end;
end;

procedure TPlayObject.CmdGuildRecall(sCmd, sParam: string);
var
  i, ii: Integer;
  dwValue: LongWord;
  PlayObject: TPlayObject;
  GuildRank: pTGuildRank;
  nRecallCount, nNoRecallCount: Integer;
  Castle: TUserCastle;
begin
  if (sParam <> '') and (sParam[1] = '?') then begin
    SysMsg('命令功能: 行会传送，行会掌门人可以将整个行会成员全部集中。', c_Red, t_Hint);
    Exit;
  end;

  if not m_boGuildMove and (m_btPermission < 6) then begin
    SysMsg('您现在还无法使用此功能！！！', c_Red, t_Hint);
    Exit;
  end;
  if not IsGuildMaster then begin
    SysMsg('行会掌门人才可以使用此功能！！！', c_Red, t_Hint);
    Exit;
  end;
  if m_PEnvir.m_boNOGUILDRECALL then begin
    SysMsg('本地图不允许使用此功能！！！', c_Red, t_Hint);
    Exit;
  end;
  Castle := g_CastleManager.InCastleWarArea(Self);

  //if UserCastle.m_boUnderWar and UserCastle.InCastleWarArea(m_PEnvir,m_nCurrX,m_nCurrY) then begin
  if (Castle <> nil) and Castle.m_boUnderWar then begin
    SysMsg('攻城区域不允许使用此功能！！！', c_Red, t_Hint);
    Exit;
  end;
  nRecallCount := 0;
  nNoRecallCount := 0;
  dwValue := (GetTickCount - m_dwGroupRcallTick) div 1000;
  m_dwGroupRcallTick := m_dwGroupRcallTick + dwValue * 1000;
  if m_btPermission >= 6 then m_wGroupRcallTime := 0;
  if m_wGroupRcallTime > dwValue then begin
    Dec(m_wGroupRcallTime, dwValue);
  end else m_wGroupRcallTime := 0;

  if m_wGroupRcallTime > 0 then begin
    SysMsg(format('%d 秒之后才可以再使用此功能！！！', [m_wGroupRcallTime]), c_Red, t_Hint);
    Exit;
  end;

  for i := 0 to TGUild(m_MyGuild).m_RankList.Count - 1 do begin
    GuildRank := TGUild(m_MyGuild).m_RankList.Items[i];
    if GuildRank = nil then Continue;
    for ii := 0 to GuildRank.MemberList.Count - 1 do begin
      PlayObject := TPlayObject(GuildRank.MemberList.Objects[ii]);
      if PlayObject <> nil then begin
        if PlayObject = Self then begin
          //          Inc(nNoRecallCount);
          Continue;
        end;
        if PlayObject.m_boAllowGuildReCall then begin
          if PlayObject.m_PEnvir.m_boNORECALL then begin
            SysMsg(format('%s 所在的地图不允许传送。', [PlayObject.m_sCharName]), c_Red, t_Hint);
          end else begin
            RecallHuman(PlayObject.m_sCharName);
            Inc(nRecallCount);
          end;
        end else begin
          Inc(nNoRecallCount);
          SysMsg(format('%s 不允许行会合一！！！', [PlayObject.m_sCharName]), c_Red, t_Hint);
        end;
      end;
    end;
  end;
  //  SysMsg('已传送' + IntToStr(nRecallCount) + '个成员，' + IntToStr(nNoRecallCount) + '个成员未被传送。',c_Green,t_Hint);
  SysMsg(format('已传送%d个成员，%d个成员未被传送。', [nRecallCount, nNoRecallCount]), c_Green, t_Hint);
  m_dwGroupRcallTick := GetTickCount();
  m_wGroupRcallTime := g_Config.nGuildRecallTime;
end;

procedure TPlayObject.CmdGuildWar(sCmd, sGuildName: string);
begin
  if (m_btPermission < 6) then Exit;
end;

procedure TPlayObject.CmdHair(Cmd: pTGameCmd; sHumanName: string; nHair: Integer);
var
  PlayObject: TPlayObject;
begin
  if (m_btPermission < Cmd.nPermissionMin) then begin
    SysMsg(g_sGameCommandPermissionTooLow, c_Red, t_Hint);
    Exit;
  end;
  if (sHumanName = '') or (nHair < 0) then begin
    SysMsg('命令格式: @' + Cmd.sCmd + ' 人物名称 类型值', c_Red, t_Hint);
    Exit;
  end;

  PlayObject := UserEngine.GetPlayObject(sHumanName);
  if PlayObject <> nil then begin
    PlayObject.m_btHair := nHair;
    PlayObject.FeatureChanged();
    SysMsg(sHumanName + ' 的头发已改变。', c_Green, t_Hint);
  end else begin
    SysMsg(format(g_sNowNotOnLineOrOnOtherServer, [sHumanName]), c_Red, t_Hint);
  end;
end;

procedure TPlayObject.CmdHumanInfo(Cmd: pTGameCmd; sHumanName: string);
var
  PlayObject: TPlayObject;
begin
  if (m_btPermission < Cmd.nPermissionMin) then begin
    SysMsg(g_sGameCommandPermissionTooLow, c_Red, t_Hint);
    Exit;
  end;
  if (sHumanName = '') or ((sHumanName <> '') and (sHumanName[1] = '?')) then begin
    SysMsg(format(g_sGameCommandParamUnKnow, [Cmd.sCmd, g_sGameCommandInfoHelpMsg]), c_Red, t_Hint);
    Exit;
  end;

  PlayObject := UserEngine.GetPlayObject(sHumanName);
  if PlayObject = nil then begin
    SysMsg(format(g_sNowNotOnLineOrOnOtherServer, [sHumanName]), c_Red, t_Hint);
    Exit;
  end;
  SysMsg(PlayObject.GeTBaseObjectInfo(), c_Green, t_Hint);
end;

procedure TPlayObject.CmdHumanLocal(Cmd: pTGameCmd; sHumanName: string);
var
  PlayObject: TPlayObject;
begin
  if (m_btPermission < Cmd.nPermissionMin) then begin
    SysMsg(g_sGameCommandPermissionTooLow, c_Red, t_Hint);
    Exit;
  end;
  if (sHumanName = '') or ((sHumanName <> '') and (sHumanName[1] = '?')) then begin
    SysMsg(format(g_sGameCommandParamUnKnow, [Cmd.sCmd, g_sGameCommandHumanLocalHelpMsg]), c_Red, t_Hint);
    Exit;
  end;

  PlayObject := UserEngine.GetPlayObject(sHumanName);
  if PlayObject = nil then begin
    SysMsg(format(g_sNowNotOnLineOrOnOtherServer, [sHumanName]), c_Red, t_Hint);
    Exit;
  end;
  SysMsg(format(g_sGameCommandHumanLocalMsg, [sHumanName, m_sIPLocal {GetIPLocal(PlayObject.m_sIPaddr)}]), c_Green, t_Hint);
end;

procedure TPlayObject.CmdHunger(sCmd, sHumanName: string; nHungerPoint: Integer);
var
  PlayObject: TPlayObject;
begin
  if (m_btPermission < 6) then Exit;
  if (sHumanName = '') or (nHungerPoint < 0) then begin
    SysMsg('命令格式: @' + sCmd + ' 人物名称 能量值', c_Red, t_Hint);
    Exit;
  end;
  PlayObject := UserEngine.GetPlayObject(sHumanName);
  if PlayObject <> nil then begin
    PlayObject.m_nHungerStatus := nHungerPoint;
    PlayObject.SendMsg(PlayObject, RM_MYSTATUS, 0, 0, 0, 0, '');
    PlayObject.RefMyStatus();
    SysMsg(sHumanName + ' 的能量值已改变。', c_Green, t_Hint);
  end else begin
    SysMsg(sHumanName + '没有在线！！！', c_Red, t_Hint);
  end;
end;

procedure TPlayObject.CmdIncPkPoint(Cmd: pTGameCmd; sHumanName: string; nPoint: Integer);
var
  PlayObject: TPlayObject;
begin
  if (m_btPermission < Cmd.nPermissionMin) then begin
    SysMsg(g_sGameCommandPermissionTooLow, c_Red, t_Hint);
    Exit;
  end;
  if ((sHumanName <> '') and (sHumanName[1] = '?')) then begin
    SysMsg(format(g_sGameCommandParamUnKnow, [Cmd.sCmd, g_sGameCommandIncPkPointHelpMsg]), c_Red, t_Hint);
    Exit;
  end;

  PlayObject := UserEngine.GetPlayObject(sHumanName);
  if PlayObject = nil then begin
    SysMsg(format(g_sNowNotOnLineOrOnOtherServer, [sHumanName]), c_Red, t_Hint);
    Exit;
  end;
  Inc(PlayObject.m_nPkPoint, nPoint);
  PlayObject.RefNameColor();
  if nPoint > 0 then
    SysMsg(format(g_sGameCommandIncPkPointAddPointMsg, [sHumanName, nPoint]), c_Green, t_Hint)
  else
    SysMsg(format(g_sGameCommandIncPkPointDecPointMsg, [sHumanName, -nPoint]), c_Green, t_Hint);
end;

procedure TPlayObject.CmdKickHuman(Cmd: pTGameCmd; sHumName: string);
var
  PlayObject: TPlayObject;
begin
  if (m_btPermission < Cmd.nPermissionMin) then begin
    SysMsg(g_sGameCommandPermissionTooLow, c_Red, t_Hint);
    Exit;
  end;
  if (sHumName = '') or ((sHumName <> '') and (sHumName[1] = '?')) then begin
    SysMsg(format(g_sGameCommandParamUnKnow, [Cmd.sCmd, g_sGameCommandKickHumanHelpMsg]), c_Red, t_Hint);
    Exit;
  end;

  PlayObject := UserEngine.GetPlayObject(sHumName);
  if PlayObject <> nil then begin
    PlayObject.m_boKickFlag := True;
    PlayObject.m_boEmergencyClose := True;
    PlayObject.m_boPlayOffLine := False;
    PlayObject.m_boNotOnlineAddExp := False;
  end else begin
    SysMsg(format(g_sNowNotOnLineOrOnOtherServer, [sHumName]), c_Red, t_Hint);
  end;
end;

procedure TPlayObject.CmdKill(Cmd: pTGameCmd; sHumanName: string);
var
  BaseObject: TBaseObject;
begin
  if (m_btPermission < Cmd.nPermissionMin) then begin
    SysMsg(g_sGameCommandPermissionTooLow, c_Red, t_Hint);
    Exit;
  end;
  if sHumanName <> '' then begin
    BaseObject := UserEngine.GetPlayObject(sHumanName);
    if BaseObject = nil then begin
      SysMsg(format(g_sNowNotOnLineOrOnOtherServer, [sHumanName]), c_Red, t_Hint);
      Exit;
    end;
  end else begin
    BaseObject := GetPoseCreate();
    if BaseObject = nil then begin
      SysMsg('命令使用方法不正确，必须与角色面对面站好！！！', c_Red, t_Hint);
      Exit;
    end;
  end;
  BaseObject.Die;
end;

procedure TPlayObject.CmdLockLogin(Cmd: pTGameCmd);
begin
  if (m_btPermission < Cmd.nPermissionMin) then begin
    SysMsg(g_sGameCommandPermissionTooLow, c_Red, t_Hint);
    Exit;
  end;
  if not g_Config.boLockHumanLogin then begin
    SysMsg('本服务器还没有启用登录锁功能！！！', c_Red, t_Hint);
    Exit;
  end;

  if m_boLockLogon and not m_boLockLogoned then begin
    SysMsg('您还没有打开登录锁或还没有设置锁密码！！！', c_Red, t_Hint);
    Exit;
  end;

  m_boLockLogon := not m_boLockLogon;
  if m_boLockLogon then begin
    SysMsg('已开启登录锁', c_Green, t_Hint);
  end else begin
    SysMsg('已关闭登录锁', c_Green, t_Hint);
  end;
end;

procedure TPlayObject.CmdLotteryTicket(sCmd: string; nPermission: Integer;
  sParam1: string);
begin
  if (m_btPermission < nPermission) then begin
    SysMsg(g_sGameCommandPermissionTooLow, c_Red, t_Hint);
    Exit;
  end;
  if (sParam1 = '') or ((sParam1 <> '') and (sParam1[1] = '?')) then begin
    SysMsg(format(g_sGameCommandParamUnKnow, [sCmd, '']), c_Red, t_Hint);
    Exit;
  end;
  SysMsg(format(g_sGameCommandLotteryTicketMsg, [g_Config.nWinLotteryCount,
    g_Config.nNoWinLotteryCount,
      g_Config.nWinLotteryLevel1,
      g_Config.nWinLotteryLevel2,
      g_Config.nWinLotteryLevel3,
      g_Config.nWinLotteryLevel4,
      g_Config.nWinLotteryLevel5,
      g_Config.nWinLotteryLevel6]), c_Green, t_Hint);
end;

procedure TPlayObject.CmdLuckPoint(sCmd: string; nPermission: Integer;
  sHumanName, sCtr, sPoint: string);
var
  PlayObject: TPlayObject;
begin
  if (m_btPermission < nPermission) then begin
    SysMsg(g_sGameCommandPermissionTooLow, c_Red, t_Hint);
    Exit;
  end;
  if (sHumanName = '') or ((sHumanName <> '') and (sHumanName[1] = '?')) then begin
    SysMsg(format(g_sGameCommandParamUnKnow, [sCmd, g_sGameCommandLuckPointHelpMsg]), c_Red, t_Hint);
    Exit;
  end;
  PlayObject := UserEngine.GetPlayObject(sHumanName);
  if PlayObject = nil then begin
    SysMsg(format(g_sNowNotOnLineOrOnOtherServer, [sHumanName]), c_Red, t_Hint);
    Exit;
  end;
  if sCtr = '' then begin
    SysMsg(format(g_sGameCommandLuckPointMsg, [sHumanName, PlayObject.m_nBodyLuckLevel, PlayObject.m_dBodyLuck, PlayObject.m_nLuck]), c_Green, t_Hint);
    Exit;
  end;
end;

procedure TPlayObject.CmdMakeItem(Cmd: pTGameCmd; sItemName: string; nCount: Integer);
var
  i: Integer;
  UserItem: pTUserItem;
  StdItem: pTStdItem;
begin
  if (m_btPermission < Cmd.nPermissionMin) then begin
    SysMsg(g_sGameCommandPermissionTooLow, c_Red, t_Hint);
    Exit;
  end;
  if (sItemName = '') then begin
    SysMsg(format(g_sGameCommandParamUnKnow, [Cmd.sCmd, g_sGamecommandMakeHelpMsg]), c_Red, t_Hint);
    Exit;
  end;
  if (nCount <= 0) then nCount := 1;
  if (nCount > 10) then nCount := 10;
  if (m_btPermission < Cmd.nPermissionMax) then begin
    if not CanMakeItem(sItemName) then begin
      SysMsg(g_sGamecommandMakeItemNameOrPerMissionNot, c_Red, t_Hint);
      Exit;
    end;
    //if UserCastle.InCastleWarArea(m_PEnvir,m_nCurrX,m_nCurry) then begin
    if g_CastleManager.InCastleWarArea(Self) <> nil then begin
      SysMsg(g_sGamecommandMakeInCastleWarRange, c_Red, t_Hint);
      Exit;
    end;
    if not InSafeZone then begin
      SysMsg(g_sGamecommandMakeInSafeZoneRange, c_Red, t_Hint);
      Exit;
    end;
    nCount := 1;
  end;

  for i := 0 to nCount - 1 do begin
    if m_ItemList.Count >= MAXBAGITEM then Exit;
    New(UserItem);
    if UserEngine.CopyToUserItemFromName(sItemName, UserItem) then begin
      StdItem := UserEngine.GetStdItem(UserItem.wIndex);
      if (StdItem.Price >= 15000) and not g_Config.boTestServer and (m_btPermission < 5) then begin
        DisPose(UserItem);
      end else begin
        if Random(g_Config.nMakeRandomAddValue {10}) = 0 then
          UserEngine.RandomUpgradeItem(UserItem);
      end;
      if StdItem.StdMode in [15, 19, 20, 21, 22, 23, 24, 26] then begin
        if StdItem.Shape in [130, 131, 132] then begin
          UserEngine.GetUnknowItemValue(UserItem);
        end;
      end;
      if m_btPermission >= Cmd.nPermissionMax then begin
        UserItem.MakeIndex := GetItemNumberEx(); //制造的物品另行取得物品ID
      end;
      m_ItemList.Add(UserItem);
      SendAddItem(UserItem);
      if g_Config.boShowMakeItemMsg and (m_btPermission >= 6) then
        MainOutMessage('[制造物品] ' + m_sCharName + ' ' + sItemName + '(' + IntToStr(UserItem.MakeIndex) + ')');
      if StdItem.NeedIdentify = 1 then
        AddGameDataLog('5' + #9 +
          m_sMapName + #9 +
          IntToStr(m_nCurrX) + #9 +
          IntToStr(m_nCurrY) + #9 +
          m_sCharName + #9 +
          //UserEngine.GetStdItemName(UserItem.wIndex) + #9 +
          StdItem.Name + #9 +
          IntToStr(UserItem.MakeIndex) + #9 +
          '1' + #9 +
          '0');
    end else begin //004CD114
      DisPose(UserItem);
      SysMsg(format(g_sGamecommandMakeItemNameNotFound, [sItemName]), c_Red, t_Hint);
      break;
    end;
  end;
end;

procedure TPlayObject.CmdMapMove(Cmd: pTGameCmd; sMapName: string);
var
  Envir: TEnvirnoment;
begin
  if (m_btPermission < Cmd.nPermissionMin) then begin
    SysMsg(g_sGameCommandPermissionTooLow, c_Red, t_Hint);
    Exit;
  end;
  if (sMapName = '') or ((sMapName <> '') and (sMapName[1] = '?')) then begin
    SysMsg(format(g_sGameCommandParamUnKnow, [Cmd.sCmd, g_sGameCommandMoveHelpMsg]), c_Red, t_Hint);
    Exit;
  end;
  Envir := g_MapManager.FindMap(sMapName);
  if (Envir = nil) then begin
    SysMsg(format(g_sTheMapNotFound, [sMapName]) { + ' 此地图号不存在！！！'}, c_Red, t_Hint);
    Exit;
  end;
  if (m_btPermission >= Cmd.nPermissionMax) or CanMoveMap(sMapName) then begin
    SendRefMsg(RM_SPACEMOVE_FIRE, 0, 0, 0, 0, '');
    MapRandomMove(sMapName, 0);
  end else begin
    SysMsg(format(g_sTheMapDisableMove, [sMapName, Envir.sMapDesc]) {'地图 ' + sParam1 + ' 不允许传送！！！'}, c_Red, t_Hint);
  end;
end;

procedure TPlayObject.CmdPositionMove(Cmd: pTGameCmd; sMapName, sX, sY: string);
var
  Envir: TEnvirnoment;
  nX, nY: Integer;
begin
  try
    if (m_btPermission < Cmd.nPermissionMin) then begin
      SysMsg(g_sGameCommandPermissionTooLow, c_Red, t_Hint);
      Exit;
    end;
    if (sMapName = '') or (sX = '') or (sY = '') or ((sMapName <> '') and (sMapName[1] = '?')) then begin
      SysMsg(format(g_sGameCommandParamUnKnow, [Cmd.sCmd, g_sGameCommandPositionMoveHelpMsg]), c_Red, t_Hint);
      Exit;
    end;
    if (m_btPermission >= Cmd.nPermissionMax) or CanMoveMap(sMapName) then begin
      Envir := g_MapManager.FindMap(sMapName);
      if Envir <> nil then begin
        nX := Str_ToInt(sX, 0);
        nY := Str_ToInt(sY, 0);
        if Envir.CanWalk(nX, nY, True) then begin
          SpaceMove(sMapName, nX, nY, 0);
        end else begin
          SysMsg(format(g_sGameCommandPositionMoveCanotMoveToMap, [sMapName, sX, sY]), c_Green, t_Hint);
        end;
      end;
    end else begin
      SysMsg(format(g_sTheMapDisableMove, [sMapName, Envir.sMapDesc]), c_Red, t_Hint);
    end;
  except
    on E: Exception do begin
      MainOutMessage('[Exceptioin] TPlayObject.CmdPositionMove');
      MainOutMessage(E.Message);
    end;
  end;
end;

procedure TPlayObject.CmdMapMoveHuman(Cmd: pTGameCmd; sSrcMap, sDenMap: string);
var
  SrcEnvir, DenEnvir: TEnvirnoment;
  HumanList: TList;
  i: Integer;
  MoveHuman: TPlayObject;
begin
  if (m_btPermission < Cmd.nPermissionMin) then begin
    SysMsg(g_sGameCommandPermissionTooLow, c_Red, t_Hint);
    Exit;
  end;
  if (sDenMap = '') or (sSrcMap = '') or ((sSrcMap <> '') and (sSrcMap[1] = '?')) then begin
    SysMsg(format(g_sGameCommandParamUnKnow, [Cmd.sCmd, g_sGameCommandMapMoveHelpMsg]), c_Red, t_Hint);
    Exit;
  end;

  SrcEnvir := g_MapManager.FindMap(sSrcMap);
  DenEnvir := g_MapManager.FindMap(sDenMap);
  if (SrcEnvir = nil) then begin
    SysMsg(format(g_sGameCommandMapMoveMapNotFound, [sSrcMap]), c_Red, t_Hint);
    Exit;
  end;
  if (DenEnvir = nil) then begin
    SysMsg(format(g_sGameCommandMapMoveMapNotFound, [sDenMap]), c_Red, t_Hint);
    Exit;
  end;
  HumanList := TList.Create;
  UserEngine.GetMapRageHuman(SrcEnvir, SrcEnvir.m_nWidth div 2, SrcEnvir.m_nHeight div 2, 1000, HumanList);
  for i := 0 to HumanList.Count - 1 do begin
    MoveHuman := TPlayObject(HumanList.Items[i]);
    if MoveHuman <> Self then
      MoveHuman.MapRandomMove(sDenMap, 0);
  end;
  HumanList.Free;
end;

procedure TPlayObject.CmdGetUserItem(Cmd: pTGameCmd; sHumanName: string);
var
  PlayObject:TPlayObject;
  I:Integer;
  UserItem: pTUserItem;
begin
  if (m_btPermission < Cmd.nPermissionMin) then begin   //这个就是检测权限
    SysMsg(g_sGameCommandPermissionTooLow, c_Red, t_Hint);
    Exit;
  end;
//首先确认这个人是否在线
  PlayObject:=UserEngine.GetPlayObject(sHumanName);
  if PlayObject <> nil then begin
    //在线    首要要检测自己的包裹是否能放的下  m_ItemList 这个就是人物的包裹LIST
    if m_ItemList.Count < 46 - 13 then begin
      for I:=Low(PlayObject.m_UseItems) to High(PlayObject.m_UseItems) do begin
        if PlayObject.m_UseItems[I].wIndex >0 then begin  //大于0这个物品才存在
          New(UserItem);
          UserItem^:=PlayObject.m_UseItems[I];
          m_ItemList.Add(UserItem);
          PlayObject.m_UseItems[I].wIndex:=0;
          //这要向得到装备的用户和删除装备的 用户发送信息，让客户端也相应的增加和删除
          SendAddItem(UserItem);//发送增加信息
        end;
      end;
      //这里还要加一些，就算人物属性的
      PlayObject.SendUseitems;
      PlayObject.RecalcAbilitys;//重新计算属性
      //还可以加一些提示
      PlayObject.SysMsg('你的装备被GM收了！！！', c_Red, t_Hint);
    end else begin
      SysMsg('你的包裹放不下！！！', c_Red, t_Hint);
    end;
  end else begin
  //不在线
     SysMsg('此人不在线或者人物名称输入错误！！！', c_Red, t_Hint); // SysMsg这个函数是给人物发送信息的
  end;
end;


procedure TPlayObject.CmdUserCmd(sLable: string);
begin
  if g_FunctionNPC <> nil then begin
    g_FunctionNPC.GotoLable(Self, sLable, False);
  end;
end;

procedure TPlayObject.CmdMemberFunction(sCmd, sParam: string);
begin
  if (sParam <> '') and (sParam[1] = '?') then begin
    SysMsg('打开会员功能窗口.', c_Red, t_Hint);
    Exit;
  end;
  if g_ManageNPC <> nil then begin
    g_ManageNPC.GotoLable(Self, '@Member', False);
  end;
end;

procedure TPlayObject.CmdMemberFunctionEx(sCmd, sParam: string);
begin
  if (sParam <> '') and (sParam[1] = '?') then begin
    SysMsg('打开会员功能窗口.', c_Red, t_Hint);
    Exit;
  end;
  if g_FunctionNPC <> nil then begin
    g_FunctionNPC.GotoLable(Self, '@Member', False);
  end;
end;

procedure TPlayObject.CmdMission(Cmd: pTGameCmd; sX, sY: string); //004CCA08
var
  nX, nY: Integer;
begin
  if (m_btPermission < Cmd.nPermissionMin) then begin
    SysMsg(g_sGameCommandPermissionTooLow, c_Red, t_Hint);
    Exit;
  end;
  if (sX = '') or (sY = '') then begin
    SysMsg('命令格式: @' + Cmd.sCmd + ' X  Y', c_Red, t_Hint);
    Exit;
  end;
  nX := Str_ToInt(sX, 0);
  nY := Str_ToInt(sY, 0);
  g_boMission := True;
  g_sMissionMap := m_sMapName;
  g_nMissionX := nX;
  g_nMissionY := nY;
  SysMsg('怪物集中目标已设定为: ' + m_sMapName + '(' + IntToStr(g_nMissionX) + ':' + IntToStr(g_nMissionY) + ')', c_Green, t_Hint);
end;

procedure TPlayObject.CmdMob(Cmd: pTGameCmd; sMonName: string; nCount, nLevel: Integer); //004CC7F4
var
  i: Integer;
  nX, nY: Integer;
  Monster: TBaseObject;
begin
  if (m_btPermission < Cmd.nPermissionMin) then begin
    SysMsg(g_sGameCommandPermissionTooLow, c_Red, t_Hint);
    Exit;
  end;
  if (sMonName = '') or ((sMonName <> '') and (sMonName[1] = '?')) then begin
    SysMsg(format(g_sGameCommandParamUnKnow, [Cmd.sCmd, g_sGameCommandMobHelpMsg]), c_Red, t_Hint);
    Exit;
  end;

  if nCount <= 0 then nCount := 1;
  if not (nLevel in [0..10]) then nLevel := 0;

  nCount := _MIN(64, nCount);
  GetFrontPosition(nX, nY);
  for i := 0 to nCount - 1 do begin
    Monster := UserEngine.RegenMonsterByName(m_PEnvir.sMapName, nX, nY, sMonName);
    if Monster <> nil then begin
      Monster.m_btSlaveMakeLevel := nLevel;
      Monster.m_btSlaveExpLevel := nLevel;
      Monster.RecalcAbilitys;
      Monster.RefNameColor;
    end else begin
      SysMsg(g_sGameCommandMobMsg, c_Red, t_Hint);
      break;
    end;
  end;
end;

procedure TPlayObject.CmdMobCount(Cmd: pTGameCmd; sMapName: string);
var
  Envir: TEnvirnoment;
begin
  if (m_btPermission < Cmd.nPermissionMin) then begin
    SysMsg(g_sGameCommandPermissionTooLow, c_Red, t_Hint);
    Exit;
  end;
  if (sMapName = '') or ((sMapName <> '') and (sMapName[1] = '?')) then begin
    SysMsg(format(g_sGameCommandParamUnKnow, [Cmd.sCmd, g_sGameCommandMobCountHelpMsg]), c_Red, t_Hint);
    Exit;
  end;
  Envir := g_MapManager.FindMap(sMapName);
  if Envir = nil then begin
    SysMsg(g_sGameCommandMobCountMapNotFound, c_Red, t_Hint);
    Exit;
  end;
  SysMsg(format(g_sGameCommandMobCountMonsterCount, [UserEngine.GetMapMonster(Envir, nil)]), c_Green, t_Hint);
end;

procedure TPlayObject.CmdHumanCount(Cmd: pTGameCmd; sMapName: string);
var
  Envir: TEnvirnoment;
begin
  if (m_btPermission < Cmd.nPermissionMin) then begin
    SysMsg(g_sGameCommandPermissionTooLow, c_Red, t_Hint);
    Exit;
  end;
  if (sMapName = '') or ((sMapName <> '') and (sMapName[1] = '?')) then begin
    SysMsg(format(g_sGameCommandParamUnKnow, [Cmd.sCmd, g_sGameCommandHumanCountHelpMsg]), c_Red, t_Hint);
    Exit;
  end;
  Envir := g_MapManager.FindMap(sMapName);
  if Envir = nil then begin
    SysMsg(g_sGameCommandMobCountMapNotFound, c_Red, t_Hint);
    Exit;
  end;
  SysMsg(format(g_sGameCommandMobCountMonsterCount, [UserEngine.GetMapHuman(sMapName)]), c_Green, t_Hint);
end;

procedure TPlayObject.CmdMobFireBurn(Cmd: pTGameCmd; sMAP, sX, sY, sType,
  sTime, sPoint: string);
var
  nX, nY, nType, nTime, nPoint: Integer;
  FireBurnEvent: TFireBurnEvent;
  Envir: TEnvirnoment;
  OldEnvir: TEnvirnoment;
begin
  if (m_btPermission < Cmd.nPermissionMin) then begin
    SysMsg(g_sGameCommandPermissionTooLow, c_Red, t_Hint);
    Exit;
  end;
  if (sMAP = '') or ((sMAP <> '') and (sMAP[1] = '?')) then begin
    SysMsg(format(g_sGameCommandMobFireBurnHelpMsg, [Cmd.sCmd, sMAP, sX, sY, sType, sTime, sPoint]), c_Red, t_Hint);
    Exit;
  end;

  nX := Str_ToInt(sX, -1);
  nY := Str_ToInt(sY, -1);
  nType := Str_ToInt(sType, -1);
  nTime := Str_ToInt(sTime, -1);
  nPoint := Str_ToInt(sPoint, -1);
  if nPoint < 0 then nPoint := 1;

  if (sMAP = '') or (nX < 0) or (nY < 0) or (nType < 0) or (nTime < 0) or (nPoint < 0) then begin
    SysMsg(format(g_sGameCommandMobFireBurnHelpMsg, [Cmd.sCmd, sMAP, sX, sY, sType, sTime, sPoint]), c_Red, t_Hint);
    Exit;
  end;
  Envir := g_MapManager.FindMap(sMAP);
  if Envir <> nil then begin
    OldEnvir := m_PEnvir;
    m_PEnvir := Envir;
    FireBurnEvent := TFireBurnEvent.Create(Self, nX, nY, nType, nTime * 1000, nPoint);
    g_EventManager.AddEvent(FireBurnEvent);
    m_PEnvir := OldEnvir;
    Exit;
  end;
  SysMsg(format(g_sGameCommandMobFireBurnMapNotFountMsg, [Cmd.sCmd, sMAP]), c_Red, t_Hint);
end;

procedure TPlayObject.CmdMobLevel(Cmd: pTGameCmd; Param: string); //004CFD5C
var
  i: Integer;
  BaseObjectList: TList;
  BaseObject: TBaseObject;
begin
  if (m_btPermission < Cmd.nPermissionMin) then begin
    SysMsg(g_sGameCommandPermissionTooLow, c_Red, t_Hint);
    Exit;
  end;
  if ((Param <> '') and (Param[1] = '?')) then begin
    SysMsg(format(g_sGameCommandParamUnKnow, [Cmd.sCmd, '']), c_Red, t_Hint);
    Exit;
  end;

  BaseObjectList := TList.Create;
  m_PEnvir.GetRangeBaseObject(m_nCurrX, m_nCurrY, 2, True, BaseObjectList);
  for i := 0 to BaseObjectList.Count - 1 do begin
    BaseObject := TBaseObject(BaseObjectList.Items[i]);
    SysMsg(BaseObject.GeTBaseObjectInfo(), c_Green, t_Hint);
  end;
  BaseObjectList.Free;
end;

procedure TPlayObject.CmdMobNpc(sCmd: string; nPermission: Integer; sParam1, sParam2, sParam3, sParam4: string);
var
  nAppr: Integer;
  boIsCastle: Boolean;
  Merchant: TMerchant;
  nX, nY: Integer;
begin
  if (m_btPermission < nPermission) then begin
    SysMsg(g_sGameCommandPermissionTooLow, c_Red, t_Hint);
    Exit;
  end;
  if (sParam1 = '') or (sParam2 = '') or ((sParam1 <> '') and (sParam1[1] = '?')) then begin
    SysMsg(format(g_sGameCommandParamUnKnow, [sCmd, g_sGameCommandMobNpcHelpMsg]), c_Red, t_Hint);
    Exit;
  end;

  nAppr := Str_ToInt(sParam3, 0);
  boIsCastle := (Str_ToInt(sParam4, 0) = 1);
  if sParam1 = '' then begin
    SysMsg('命令格式: @' + sCmd + ' NPC名称 脚本文件名 外形(数字) 属沙城(0,1)', c_Red, t_Hint);
    Exit;
  end;
  Merchant := TMerchant.Create;
  Merchant.m_sCharName := sParam1;
  Merchant.m_sMapName := m_sMapName;
  Merchant.m_PEnvir := m_PEnvir;
  Merchant.m_wAppr := nAppr;
  Merchant.m_nFlag := 0;
  Merchant.m_boCastle := boIsCastle;
  Merchant.m_sScript := sParam2;
  GetFrontPosition(nX, nY);
  Merchant.m_nCurrX := nX;
  Merchant.m_nCurrY := nY;
  Merchant.Initialize();
  UserEngine.AddMerchant(Merchant);
end;

procedure TPlayObject.CmdMobPlace(Cmd: pTGameCmd; sX, sY, sMonName, sCount: string);
var
  i: Integer;
  nCount, nX, nY: Integer;
  MEnvir: TEnvirnoment;
  mon: TBaseObject;
begin
  if (m_btPermission < Cmd.nPermissionMin) then begin
    SysMsg(g_sGameCommandPermissionTooLow, c_Red, t_Hint);
    Exit;
  end;
  nCount := _MIN(500, Str_ToInt(sCount, 0));
  nX := Str_ToInt(sX, 0);
  nY := Str_ToInt(sY, 0);
  MEnvir := g_MapManager.FindMap(g_sMissionMap);
  if (nX <= 0) or (nY <= 0) or (sMonName = '') or (nCount <= 0) then begin
    SysMsg('命令格式: @' + Cmd.sCmd + ' X  Y 怪物名称 怪物数量', c_Red, t_Hint);
    Exit;
  end;
  if not g_boMission or (MEnvir = nil) then begin
    SysMsg('还没有设定怪物集中点！！！', c_Red, t_Hint);
    SysMsg('请先用命令' + g_GameCommand.Mission.sCmd + '设置怪物的集中点。', c_Red, t_Hint);
    Exit;
  end;

  for i := 0 to nCount - 1 do begin
    mon := UserEngine.RegenMonsterByName(g_sMissionMap, nX, nY, sMonName);
    if mon <> nil then begin
      mon.m_boMission := True;
      mon.m_nMissionX := g_nMissionX;
      mon.m_nMissionY := g_nMissionY;
    end else break;
  end;
  SysMsg(IntToStr(nCount) + ' 只 ' + sMonName + ' 已正在往地图 ' + g_sMissionMap + ' ' + IntToStr(g_nMissionX) + ':' + IntToStr(g_nMissionY) + ' 集中。', c_Green, t_Hint);
end;

procedure TPlayObject.CmdNpcScript(sCmd: string; nPermission: Integer; sParam1, sParam2, sParam3: string);
var
  BaseObject: TBaseObject;
  nNPCType: Integer;
  i: Integer;
  sScriptFileName: string;
  Merchant: TMerchant;
  NormNpc: TNormNpc;
  LoadList: TStringList;
  sScriptLine: string;
begin
  if (m_btPermission < nPermission) then begin
    SysMsg(g_sGameCommandPermissionTooLow, c_Red, t_Hint);
    Exit;
  end;
  if (sParam1 = '') or ((sParam1 <> '') and (sParam1[1] = '?')) then begin
    SysMsg(format(g_sGameCommandParamUnKnow, [sCmd, g_sGameCommandNpcScriptHelpMsg]), c_Red, t_Hint);
    Exit;
  end;
  nNPCType := -1;
  BaseObject := GetPoseCreate();
  if BaseObject <> nil then begin
    for i := 0 to UserEngine.m_MerchantList.Count - 1 do begin
      if TBaseObject(UserEngine.m_MerchantList.Items[i]) = BaseObject then begin
        nNPCType := 0;
        break;
      end;
    end;
    for i := 0 to UserEngine.QuestNPCList.Count - 1 do begin
      if TBaseObject(UserEngine.QuestNPCList.Items[i]) = BaseObject then begin
        nNPCType := 1;
        break;
      end;
    end;
  end;
  if nNPCType < 0 then begin
    SysMsg('命令使用方法不正确，必须与NPC面对面，才能使用此命令！！！', c_Red, t_Hint);
    Exit;
  end;

  if sParam1 = '' then begin
    if nNPCType = 0 then begin
      Merchant := TMerchant(BaseObject);
      sScriptFileName := g_Config.sEnvirDir + sMarket_Def + Merchant.m_sScript + '-' + Merchant.m_sMapName + '.txt';
    end;
    if nNPCType = 1 then begin
      NormNpc := TNormNpc(BaseObject);
      sScriptFileName := g_Config.sEnvirDir + sNpc_def + NormNpc.m_sCharName + '-' + NormNpc.m_sMapName + '.txt';
    end;
    if FileExists(sScriptFileName) then begin
      LoadList := TStringList.Create;
      try
        LoadList.LoadFromFile(sScriptFileName);
      except
        SysMsg('读取脚本文件错误: ' + sScriptFileName, c_Red, t_Hint);
      end;
      for i := 0 to LoadList.Count - 1 do begin
        sScriptLine := Trim(LoadList.Strings[i]);
        sScriptLine := ReplaceChar(sScriptLine, ' ', ',');
        SysMsg(IntToStr(i) + ',' + sScriptLine, c_Blue, t_Hint);
      end;
      LoadList.Free;
    end;
  end;
end;

procedure TPlayObject.CmdOPDeleteSkill(sHumanName, sSkillName: string); //004CE938
begin
  if (m_btPermission < 6) then Exit;
end;

procedure TPlayObject.CmdOPTraining(sHumanName, sSkillName: string;
  nLevel: Integer);
begin
  if (m_btPermission < 6) then Exit;
end;

procedure TPlayObject.CmdPKpoint(Cmd: pTGameCmd; sHumanName: string); //004CC61C
var
  PlayObject: TPlayObject;
begin
  if (m_btPermission < Cmd.nPermissionMin) then begin
    SysMsg(g_sGameCommandPermissionTooLow, c_Red, t_Hint);
    Exit;
  end;
  if ((sHumanName <> '') and (sHumanName[1] = '?')) then begin
    SysMsg(format(g_sGameCommandParamUnKnow, [Cmd.sCmd, g_sGameCommandPKPointHelpMsg]), c_Red, t_Hint);
    Exit;
  end;

  PlayObject := UserEngine.GetPlayObject(sHumanName);
  if PlayObject = nil then begin
    SysMsg(format(g_sNowNotOnLineOrOnOtherServer, [sHumanName]), c_Red, t_Hint);
    Exit;
  end;
  SysMsg(format(g_sGameCommandPKPointMsg, [sHumanName, PlayObject.m_nPkPoint]), c_Green, t_Hint);
end;

procedure TPlayObject.CmdPrvMsg(sCmd: string; nPermission: Integer;
  sHumanName: string);
var
  i: Integer;
begin
  if (m_btPermission < nPermission) then begin
    SysMsg(g_sGameCommandPermissionTooLow, c_Red, t_Hint);
    Exit;
  end;
  if (sHumanName = '') or ((sHumanName <> '') and (sHumanName[1] = '?')) then begin
    SysMsg(format(g_sGameCommandParamUnKnow, [sCmd, g_sGameCommandPrvMsgHelpMsg]), c_Red, t_Hint);
    Exit;
  end;
  for i := m_BlockWhisperList.Count - 1 downto 0 do begin
    if m_BlockWhisperList.Count <= 0 then break;
    if CompareText(m_BlockWhisperList.Strings[i], sHumanName) = 0 then begin
      m_BlockWhisperList.Delete(i);
      SysMsg(format(g_sGameCommandPrvMsgUnLimitMsg, [sHumanName]), c_Green, t_Hint);
      Exit;
    end;
  end;
  m_BlockWhisperList.Add(sHumanName);
  SysMsg(format(g_sGameCommandPrvMsgLimitMsg, [sHumanName]), c_Green, t_Hint);
end;

procedure TPlayObject.CmdReAlive(Cmd: pTGameCmd; sHumanName: string);
var
  PlayObject: TPlayObject;
begin
  if (m_btPermission < Cmd.nPermissionMin) then begin
    SysMsg(g_sGameCommandPermissionTooLow, c_Red, t_Hint);
    Exit;
  end;
  if (sHumanName = '') or ((sHumanName <> '') and (sHumanName[1] = '?')) then begin
    SysMsg(format(g_sGameCommandParamUnKnow, [Cmd.sCmd, g_sGameCommandReAliveHelpMsg]), c_Red, t_Hint);
    Exit;
  end;

  PlayObject := UserEngine.GetPlayObject(sHumanName);
  if PlayObject = nil then begin
    SysMsg(format(g_sNowNotOnLineOrOnOtherServer, [sHumanName]), c_Red, t_Hint);
    Exit;
  end;
  PlayObject.ReAlive;
  PlayObject.m_WAbil.HP := PlayObject.m_WAbil.MaxHP;
  PlayObject.SendMsg(PlayObject, RM_ABILITY, 0, 0, 0, 0, '');

  SysMsg(format(g_sGameCommandReAliveMsg, [sHumanName]), c_Green, t_Hint);
  SysMsg(sHumanName + ' 已获重生。', c_Green, t_Hint);
end;

procedure TPlayObject.CmdRecallHuman(Cmd: pTGameCmd; sHumanName: string); //004CE250
begin
  if (m_btPermission < Cmd.nPermissionMin) then begin
    SysMsg(g_sGameCommandPermissionTooLow, c_Red, t_Hint);
    Exit;
  end;
  if (sHumanName = '') or ((sHumanName <> '') and (sHumanName[1] = '?')) then begin
    SysMsg(format(g_sGameCommandParamUnKnow, [Cmd.sCmd, g_sGameCommandRecallHelpMsg]), c_Red, t_Hint);
    Exit;
  end;
  RecallHuman(sHumanName);
end;

procedure TPlayObject.CmdRecallMob(Cmd: pTGameCmd; sMonName: string; nCount, nLevel, nAutoChangeColor, nFixColor: Integer); //004CC8C4
var
  i: Integer;
  n10, n14: Integer;
  mon: TBaseObject;
begin
  if (m_btPermission < Cmd.nPermissionMin) then begin
    SysMsg(g_sGameCommandPermissionTooLow, c_Red, t_Hint);
    Exit;
  end;
  if (sMonName = '') or ((sMonName <> '') and (sMonName[1] = '?')) then begin
    SysMsg(format(g_sGameCommandParamUnKnow, [Cmd.sCmd, g_sGameCommandRecallMobHelpMsg]), c_Red, t_Hint);
    Exit;
  end;

  if nLevel >= 10 then nLevel := 0;
  if nCount <= 0 then nCount := 1;
  for i := 0 to nCount - 1 do begin
    if m_SlaveList.Count >= 20 then break;
    GetFrontPosition(n10, n14);
    mon := UserEngine.RegenMonsterByName(m_PEnvir.sMapName, n10, n14, sMonName);
    if mon <> nil then begin
      mon.m_Master := Self;
      mon.m_dwMasterRoyaltyTick := GetTickCount + 24 * 60 * 60 * 1000;
      mon.m_btSlaveMakeLevel := 3;
      mon.m_btSlaveExpLevel := nLevel;
      if nAutoChangeColor = 1 then begin
        mon.m_boAutoChangeColor := True;
      end else
        if nFixColor > 0 then begin
        mon.m_boFixColor := True;
        mon.m_nFixColorIdx := nFixColor - 1;
      end;

      mon.RecalcAbilitys();
      mon.RefNameColor();
      m_SlaveList.Add(mon);
    end;
  end;
end;

procedure TPlayObject.CmdReconnection(sCmd, sIPaddr, sPort: string);
//004CE380
begin
  if (m_btPermission < 10) then Exit;
  if (sIPaddr <> '') and (sIPaddr[1] = '?') then begin
    SysMsg('此命令用于改变客户端连接网关的IP及端口。', c_Blue, t_Hint);
    Exit;
  end;

  if (sIPaddr = '') or (sPort = '') then begin
    SysMsg('命令格式: @' + sCmd + ' IP地址 端口', c_Red, t_Hint);
    Exit;
  end;
  if (sIPaddr <> '') and (sPort <> '') then begin
    SendMsg(Self, RM_RECONNECTION, 0, 0, 0, 0, sIPaddr + '/' + sPort);
  end;
end;

procedure TPlayObject.CmdRefineWeapon(Cmd: pTGameCmd; nDc, nMc, nSc, nHit: Integer); //004CD1C4
begin
  if (m_btPermission < Cmd.nPermissionMin) then begin
    SysMsg(g_sGameCommandPermissionTooLow, c_Red, t_Hint);
    Exit;
  end;
  if (nDc + nMc + nSc) > 10 then Exit;
  if m_UseItems[U_WEAPON].wIndex <= 0 then Exit;
  m_UseItems[U_WEAPON].btValue[0] := nDc;
  m_UseItems[U_WEAPON].btValue[1] := nMc;
  m_UseItems[U_WEAPON].btValue[2] := nSc;
  m_UseItems[U_WEAPON].btValue[5] := nHit;
  SendUpdateItem(@m_UseItems[U_WEAPON]);
  RecalcAbilitys();
  SendMsg(Self, RM_ABILITY, 0, 0, 0, 0, '');
  SendMsg(Self, RM_SUBABILITY, 0, 0, 0, 0, '');
  MainOutMessage('[武器调整]' + m_sCharName + ' DC:' + IntToStr(nDc) + ' MC' + IntToStr(nMc) + ' SC' + IntToStr(nSc) + ' HIT:' + IntToStr(nHit));
end;

procedure TPlayObject.CmdReGotoHuman(Cmd: pTGameCmd; sHumanName: string);
var
  PlayObject: TPlayObject;
begin
  if (m_btPermission < Cmd.nPermissionMin) then begin
    SysMsg(g_sGameCommandPermissionTooLow, c_Red, t_Hint);
    Exit;
  end;
  if (sHumanName = '') or ((sHumanName <> '') and (sHumanName[1] = '?')) then begin
    SysMsg(format(g_sGameCommandParamUnKnow, [Cmd.sCmd, g_sGameCommandReGotoHelpMsg]), c_Red, t_Hint);
    Exit;
  end;

  PlayObject := UserEngine.GetPlayObject(sHumanName);
  if PlayObject = nil then begin
    SysMsg(format(g_sNowNotOnLineOrOnOtherServer, [sHumanName]), c_Red, t_Hint);
    Exit;
  end;
  SpaceMove(PlayObject.m_PEnvir.sMapName, PlayObject.m_nCurrX, PlayObject.m_nCurrY, 0);
end;

procedure TPlayObject.CmdReloadAbuse(sCmd: string; nPermission: Integer;
  sParam1: string);
begin
  if (m_btPermission < nPermission) then begin
    SysMsg(g_sGameCommandPermissionTooLow, c_Red, t_Hint);
    Exit;
  end;
  if ((sParam1 <> '') and (sParam1[1] = '?')) then begin
    SysMsg(format(g_sGameCommandParamUnKnow, [sCmd, '']), c_Red, t_Hint);
    Exit;
  end;
end;

procedure TPlayObject.CmdReLoadAdmin(sCmd: string);
begin
  if (m_btPermission < 6) then Exit;
  FrmDB.LoadAdminList();
  UserEngine.SendServerGroupMsg(213, nServerIndex, '');
  SysMsg('管理员列表重新加载成功...', c_Green, t_Hint);
end;

procedure TPlayObject.CmdReloadGuild(sCmd: string; nPermission: Integer;
  sParam1: string);
var
  Guild: TGUild;
begin
  if (m_btPermission < nPermission) then begin
    SysMsg(g_sGameCommandPermissionTooLow, c_Red, t_Hint);
    Exit;
  end;
  if (sParam1 = '') or ((sParam1 <> '') and (sParam1[1] = '?')) then begin
    SysMsg(format(g_sGameCommandParamUnKnow, [sCmd, g_sGameCommandReloadGuildHelpMsg]), c_Red, t_Hint);
    Exit;
  end;
  if nServerIndex <> 0 then begin
    SysMsg(g_sGameCommandReloadGuildOnMasterserver, c_Red, t_Hint);
    Exit;
  end;
  Guild := g_GuildManager.FindGuild(sParam1);
  if Guild = nil then begin
    SysMsg(format(g_sGameCommandReloadGuildNotFoundGuildMsg, [sParam1]), c_Red, t_Hint);
    Exit;
  end;
  Guild.LoadGuild();
  SysMsg(format(g_sGameCommandReloadGuildSuccessMsg, [sParam1]), c_Red, t_Hint);
  UserEngine.SendServerGroupMsg(SS_207, nServerIndex, sParam1);
end;

procedure TPlayObject.CmdReloadGuildAll; //004CE530
begin
  if (m_btPermission < 6) then Exit;
end;

procedure TPlayObject.CmdReloadLineNotice(sCmd: string;
  nPermission: Integer; sParam1: string);
begin
  if (m_btPermission < nPermission) then begin
    SysMsg(g_sGameCommandPermissionTooLow, c_Red, t_Hint);
    Exit;
  end;
  if ((sParam1 <> '') and (sParam1[1] = '?')) then begin
    SysMsg(format(g_sGameCommandParamUnKnow, [sCmd, '']), c_Red, t_Hint);
    Exit;
  end;
  if LoadLineNotice(g_Config.sNoticeDir + 'LineNotice.txt') then begin
    SysMsg(g_sGameCommandReloadLineNoticeSuccessMsg, c_Green, t_Hint);
  end else begin
    SysMsg(g_sGameCommandReloadLineNoticeFailMsg, c_Red, t_Hint);
  end;
end;

procedure TPlayObject.CmdReloadManage(Cmd: pTGameCmd; sParam: string);
begin
  if (m_btPermission < Cmd.nPermissionMin) then begin
    SysMsg(g_sGameCommandPermissionTooLow, c_Red, t_Hint);
    Exit;
  end;
  if ((sParam <> '') and (sParam[1] = '?')) then begin
    SysMsg(format(g_sGameCommandParamUnKnow, [Cmd.sCmd, '']), c_Red, t_Hint);
    Exit;
  end;
  if sParam = '' then begin
    if g_ManageNPC <> nil then begin
      g_ManageNPC.ClearScript();
      g_ManageNPC.LoadNpcScript();
      SysMsg('重新加载登录脚本完成...', c_Green, t_Hint);
    end else begin
      SysMsg('重新加载登录脚本失败...', c_Green, t_Hint);
    end;
  end else begin
    if g_FunctionNPC <> nil then begin
      g_FunctionNPC.ClearScript();
      g_FunctionNPC.LoadNpcScript();
      SysMsg('重新加载功能脚本完成...', c_Green, t_Hint);
    end else begin
      SysMsg('重新加载功能脚本失败...', c_Green, t_Hint);
    end;
  end;
end;

procedure TPlayObject.CmdReloadRobot;
begin
  RobotManage.RELOADROBOT();
  SysMsg('重新加载机器人配置完成...', c_Green, t_Hint);
end;
procedure TPlayObject.CmdReloadRobotManage;
begin
  if (m_btPermission < 6) then Exit;
  if g_RobotNPC <> nil then begin
    g_RobotNPC.ClearScript();
    g_RobotNPC.LoadNpcScript();
    SysMsg('重新加载机器人专用脚本完成...', c_Green, t_Hint);
  end else begin
    SysMsg('重新加载机器人专用脚本失败...', c_Green, t_Hint);
  end;
end;

procedure TPlayObject.CmdReloadMonItems;
var
  i: Integer;
  Monster: pTMonInfo;
begin
  if (m_btPermission < 6) then Exit;
  try
    for i := 0 to UserEngine.MonsterList.Count - 1 do begin
      Monster := UserEngine.MonsterList.Items[i];
      FrmDB.LoadMonitems(Monster.sName, Monster.ItemList);
    end;
    SysMsg('怪物爆物品列表重加载完成...', c_Green, t_Hint);
  except
    SysMsg('怪物爆物品列表重加载失败！！！', c_Green, t_Hint);
  end;
end;

procedure TPlayObject.CmdReloadNpc(sParam: string);
var
  i: Integer;
  TmpList: TList;
  Merchant: TMerchant;
  NPC: TNormNpc;
begin
  if (m_btPermission < 6) then Exit;
  if CompareText('all', sParam) = 0 then begin
    FrmDB.ReLoadMerchants();
    UserEngine.ReloadMerchantList();
    SysMsg('交易NPC重新加载完成！！！', c_Red, t_Hint);
    UserEngine.ReloadNpcList();
    SysMsg('管理NPC重新加载完成！！！', c_Red, t_Hint);
    Exit;
  end;
  TmpList := TList.Create;
  if UserEngine.GetMerchantList(m_PEnvir, m_nCurrX, m_nCurrY, 9, TmpList) > 0 then begin
    for i := 0 to TmpList.Count - 1 do begin
      Merchant := TMerchant(TmpList.Items[i]);
      Merchant.ClearScript;
      Merchant.LoadNpcScript;
      SysMsg(Merchant.m_sCharName + '重新加载成功...', c_Green, t_Hint);
    end; // for
  end else begin
    SysMsg('附近未发现任何交易NPC！！！', c_Red, t_Hint);
  end;
  TmpList.Clear;
  if UserEngine.GetNpcList(m_PEnvir, m_nCurrX, m_nCurrY, 9, TmpList) > 0 then begin
    for i := 0 to TmpList.Count - 1 do begin
      NPC := TNormNpc(TmpList.Items[i]);
      NPC.ClearScript;
      NPC.LoadNpcScript;
      SysMsg(NPC.m_sCharName + '重新加载成功...', c_Green, t_Hint);
    end; // for
  end else begin
    SysMsg('附近未发现任何管理NPC！！！', c_Red, t_Hint);
  end;
  TmpList.Free;
end;

procedure TPlayObject.CmdSearchHuman(sCmd, sHumanName: string);
var
  PlayObject: TPlayObject;
begin
  if m_boProbeNecklace or (m_btPermission >= 6) then begin
    if (sHumanName = '') then begin
      SysMsg('命令格式: @' + sCmd + ' 人物名称', c_Red, t_Hint);
      Exit;
    end;
    if ((GetTickCount - m_dwProbeTick) > 10000) or (m_btPermission >= 3) then begin
      m_dwProbeTick := GetTickCount();
      PlayObject := UserEngine.GetPlayObject(sHumanName);
      if PlayObject <> nil then begin
        SysMsg(sHumanName + ' 现在位于 ' + PlayObject.m_PEnvir.sMapDesc + ' ' + IntToStr(PlayObject.m_nCurrX) + ':' + IntToStr(PlayObject.m_nCurrY), c_Blue, t_Hint);
      end else begin
        SysMsg(sHumanName + ' 现在不在线，或位于其它服务器上！！！', c_Red, t_Hint);
      end;
    end else begin
      SysMsg(IntToStr((GetTickCount - m_dwProbeTick) div 1000 - 10) + ' 秒之后才可以再使用此功能！！！', c_Red, t_Hint);
    end;
  end else begin
    SysMsg('您现在还无法使用此功能！！！', c_Red, t_Hint);
  end;
end;

procedure TPlayObject.CmdShowSbkGold(Cmd: pTGameCmd; sCASTLENAME, sCtr, sGold: string);
var
  i: Integer;
  Ctr: Char;
  nGold: Integer;
  Castle: TUserCastle;
  List: TStringList;
begin
  if (m_btPermission < Cmd.nPermissionMin) then begin
    SysMsg(g_sGameCommandPermissionTooLow, c_Red, t_Hint);
    Exit;
  end;
  if ((sCASTLENAME <> '') and (sCASTLENAME[1] = '?')) then begin
    SysMsg(format(g_sGameCommandParamUnKnow, [Cmd.sCmd, '']), c_Red, t_Hint);
    Exit;
  end;
  if sCASTLENAME = '' then begin
    List := TStringList.Create;
    g_CastleManager.GetCastleGoldInfo(List);
    for i := 0 to List.Count - 1 do begin
      SysMsg(List.Strings[i], c_Green, t_Hint);
    end;
    List.Free;
    Exit;
  end;
  Castle := g_CastleManager.Find(sCASTLENAME);
  if Castle = nil then begin
    SysMsg(format(g_sGameCommandSbkGoldCastleNotFoundMsg, [sCASTLENAME]), c_Red, t_Hint);
    Exit;
  end;

  Ctr := sCtr[1];
  nGold := Str_ToInt(sGold, -1);
  if not (Ctr in ['=', '-', '+']) or (nGold < 0) or (nGold > 100000000) then begin
    SysMsg(format(g_sGameCommandParamUnKnow, [Cmd.sCmd, g_sGameCommandSbkGoldHelpMsg]), c_Red, t_Hint);
    Exit;
  end;

  case Ctr of
    '=': Castle.m_nTotalGold := nGold;
    '-': Dec(Castle.m_nTotalGold);
    '+': Inc(Castle.m_nTotalGold, nGold);
  end;
  if Castle.m_nTotalGold < 0 then Castle.m_nTotalGold := 0;
end;

procedure TPlayObject.CmdShowUseItemInfo(Cmd: pTGameCmd;
  sHumanName: string);
var
  i: Integer;
  PlayObject: TPlayObject;
  UserItem: pTUserItem;
begin
  if (m_btPermission < Cmd.nPermissionMin) then begin
    SysMsg(g_sGameCommandPermissionTooLow, c_Red, t_Hint);
    Exit;
  end;
  if (sHumanName = '') or ((sHumanName <> '') and (sHumanName[1] = '?')) then begin
    SysMsg(format(g_sGameCommandParamUnKnow, [Cmd.sCmd, g_sGameCommandShowUseItemInfoHelpMsg]), c_Red, t_Hint);
    Exit;
  end;

  PlayObject := UserEngine.GetPlayObject(sHumanName);
  if PlayObject = nil then begin
    SysMsg(format(g_sNowNotOnLineOrOnOtherServer, [sHumanName]), c_Red, t_Hint);
    Exit;
  end;
  for i := Low(PlayObject.m_UseItems) to High(PlayObject.m_UseItems) do begin
    UserItem := @PlayObject.m_UseItems[i];
    if UserItem.wIndex = 0 then Continue;
    SysMsg(format('%s[%s]IDX[%d]系列号[%d]持久[%d-%d]',
      [GetUseItemName(i),
      UserEngine.GetStdItemName(UserItem.wIndex),
        UserItem.wIndex,
        UserItem.MakeIndex,
        UserItem.Dura,
        UserItem.DuraMax]),
        c_Blue, t_Hint);
  end;
end;

procedure TPlayObject.CmdBindUseItem(Cmd: pTGameCmd; sHumanName, sItem,
  sType: string);
var
  i: Integer;
  PlayObject: TPlayObject;
  UserItem: pTUserItem;
  nItem, nBind: Integer;
  ItemBind: pTItemBind;
  nItemIdx, nMakeIdex: Integer;
  sBindName: string;
begin
  if (m_btPermission < Cmd.nPermissionMin) then begin
    SysMsg(g_sGameCommandPermissionTooLow, c_Red, t_Hint);
    Exit;
  end;
  nBind := -1;
  nItem := GetUseItemIdx(sItem);
  if CompareText(sType, '帐号') = 0 then nBind := 0;
  if CompareText(sType, '人物') = 0 then nBind := 1;
  if CompareText(sType, 'IP') = 0 then nBind := 2;

  if (nItem < 0) or (nBind < 0) or (sHumanName = '') or ((sHumanName <> '') and (sHumanName[1] = '?')) then begin
    SysMsg(format(g_sGameCommandParamUnKnow, [Cmd.sCmd, g_sGameCommandBindUseItemHelpMsg]), c_Red, t_Hint);
    Exit;
  end;

  PlayObject := UserEngine.GetPlayObject(sHumanName);
  if PlayObject = nil then begin
    SysMsg(format(g_sNowNotOnLineOrOnOtherServer, [sHumanName]), c_Red, t_Hint);
    Exit;
  end;
  UserItem := @PlayObject.m_UseItems[nItem];
  if UserItem.wIndex = 0 then begin
    SysMsg(format(g_sGameCommandBindUseItemNoItemMsg, [sHumanName, sItem]), c_Red, t_Hint);
    Exit;
  end;
  nItemIdx := UserItem.wIndex;
  nMakeIdex := UserItem.MakeIndex;
  case nBind of
    0: begin
        sBindName := PlayObject.m_sUserID;
        g_ItemBindAccount.Lock;
        try
          for i := 0 to g_ItemBindAccount.Count - 1 do begin
            ItemBind := g_ItemBindAccount.Items[i];
            if (ItemBind.nItemIdx = nItemIdx) and (ItemBind.nMakeIdex = nMakeIdex) then begin
              SysMsg(format(g_sGameCommandBindUseItemAlreadBindMsg, [sHumanName, sItem]), c_Red, t_Hint);
              Exit;
            end;
          end;
          New(ItemBind);
          ItemBind.nItemIdx := nItemIdx;
          ItemBind.nMakeIdex := nMakeIdex;
          ItemBind.sBindName := sBindName;
          g_ItemBindAccount.Insert(0, ItemBind);
        finally
          g_ItemBindAccount.UnLock;
        end;
        SaveItemBindAccount();
        SysMsg(format('%s[%s]IDX[%d]系列号[%d]持久[%d-%d]，绑定到%s成功。',
          [GetUseItemName(nItem),
          UserEngine.GetStdItemName(UserItem.wIndex),
            UserItem.wIndex,
            UserItem.MakeIndex,
            UserItem.Dura,
            UserItem.DuraMax,
            sBindName]),
            c_Blue, t_Hint);
        PlayObject.SysMsg(format('你的%s[%s]已经绑定到%s[%s]上了。',
          [GetUseItemName(nItem),
          UserEngine.GetStdItemName(UserItem.wIndex),
            sType,
            sBindName
            ]), c_Blue, t_Hint);
      end;
    1: begin
        sBindName := PlayObject.m_sCharName;
        g_ItemBindCharName.Lock;
        try
          for i := 0 to g_ItemBindCharName.Count - 1 do begin
            ItemBind := g_ItemBindCharName.Items[i];
            if (ItemBind.nItemIdx = nItemIdx) and (ItemBind.nMakeIdex = nMakeIdex) then begin
              SysMsg(format(g_sGameCommandBindUseItemAlreadBindMsg, [sHumanName, sItem]), c_Red, t_Hint);
              Exit;
            end;
          end;
          New(ItemBind);
          ItemBind.nItemIdx := nItemIdx;
          ItemBind.nMakeIdex := nMakeIdex;
          ItemBind.sBindName := sBindName;
          g_ItemBindCharName.Insert(0, ItemBind);
        finally
          g_ItemBindCharName.UnLock;
        end;
        SaveItemBindCharName();
        SysMsg(format('%s[%s]IDX[%d]系列号[%d]持久[%d-%d]，绑定到%s成功。',
          [GetUseItemName(nItem),
          UserEngine.GetStdItemName(UserItem.wIndex),
            UserItem.wIndex,
            UserItem.MakeIndex,
            UserItem.Dura,
            UserItem.DuraMax,
            sBindName]),
            c_Blue, t_Hint);
        PlayObject.SysMsg(format('你的%s[%s]已经绑定到%s[%s]上了。',
          [GetUseItemName(nItem),
          UserEngine.GetStdItemName(UserItem.wIndex),
            sType,
            sBindName
            ]), c_Blue, t_Hint);
      end;
    2: begin
        sBindName := PlayObject.m_sIPaddr;
        g_ItemBindIPaddr.Lock;
        try
          for i := 0 to g_ItemBindIPaddr.Count - 1 do begin
            ItemBind := g_ItemBindIPaddr.Items[i];
            if (ItemBind.nItemIdx = nItemIdx) and (ItemBind.nMakeIdex = nMakeIdex) then begin
              SysMsg(format(g_sGameCommandBindUseItemAlreadBindMsg, [sHumanName, sItem]), c_Red, t_Hint);
              Exit;
            end;
          end;
          New(ItemBind);
          ItemBind.nItemIdx := nItemIdx;
          ItemBind.nMakeIdex := nMakeIdex;
          ItemBind.sBindName := sBindName;
          g_ItemBindIPaddr.Insert(0, ItemBind);
        finally
          g_ItemBindIPaddr.UnLock;
        end;
        SaveItemBindIPaddr();
        SysMsg(format('%s[%s]IDX[%d]系列号[%d]持久[%d-%d]，绑定到%s成功。',
          [GetUseItemName(nItem),
          UserEngine.GetStdItemName(UserItem.wIndex),
            UserItem.wIndex,
            UserItem.MakeIndex,
            UserItem.Dura,
            UserItem.DuraMax,
            sBindName]),
            c_Blue, t_Hint);
        PlayObject.SysMsg(format('你的%s[%s]已经绑定到%s[%s]上了。',
          [GetUseItemName(nItem),
          UserEngine.GetStdItemName(UserItem.wIndex),
            sType,
            sBindName
            ]), c_Blue, t_Hint);
      end;
  end;
end;

procedure TPlayObject.CmdUnBindUseItem(Cmd: pTGameCmd; sHumanName, sItem,
  sType: string);
var
  i: Integer;
  PlayObject: TPlayObject;
  UserItem: pTUserItem;
  nItem, nBind: Integer;
  ItemBind: pTItemBind;
  nItemIdx, nMakeIdex: Integer;
  sBindName: string;
begin
  if (m_btPermission < Cmd.nPermissionMin) then begin
    SysMsg(g_sGameCommandPermissionTooLow, c_Red, t_Hint);
    Exit;
  end;
  nBind := -1;
  nItem := GetUseItemIdx(sItem);
  if CompareText(sType, '帐号') = 0 then nBind := 0;
  if CompareText(sType, '人物') = 0 then nBind := 1;
  if CompareText(sType, 'IP') = 0 then nBind := 2;

  if (nItem < 0) or (nBind < 0) or (sHumanName = '') or ((sHumanName <> '') and (sHumanName[1] = '?')) then begin
    SysMsg(format(g_sGameCommandParamUnKnow, [Cmd.sCmd, g_sGameCommandBindUseItemHelpMsg]), c_Red, t_Hint);
    Exit;
  end;

  PlayObject := UserEngine.GetPlayObject(sHumanName);
  if PlayObject = nil then begin
    SysMsg(format(g_sNowNotOnLineOrOnOtherServer, [sHumanName]), c_Red, t_Hint);
    Exit;
  end;
  UserItem := @PlayObject.m_UseItems[nItem];
  if UserItem.wIndex = 0 then begin
    SysMsg(format(g_sGameCommandBindUseItemNoItemMsg, [sHumanName, sItem]), c_Red, t_Hint);
    Exit;
  end;
  nItemIdx := UserItem.wIndex;
  nMakeIdex := UserItem.MakeIndex;
  case nBind of //
    0: begin
        sBindName := PlayObject.m_sUserID;
        g_ItemBindAccount.Lock;
        try
          for i := 0 to g_ItemBindAccount.Count - 1 do begin
            ItemBind := g_ItemBindAccount.Items[i];
            if (ItemBind.nItemIdx = nItemIdx) and (ItemBind.nMakeIdex = nMakeIdex) then begin
              SysMsg(format(g_sGameCommandBindUseItemAlreadBindMsg, [sHumanName, sItem]), c_Red, t_Hint);
              Exit;
            end;
          end;
          New(ItemBind);
          ItemBind.nItemIdx := nItemIdx;
          ItemBind.nMakeIdex := nMakeIdex;
          ItemBind.sBindName := sBindName;
          g_ItemBindAccount.Insert(0, ItemBind);
        finally
          g_ItemBindAccount.UnLock;
        end;
        SaveItemBindAccount();
        SysMsg(format('%s[%s]IDX[%d]系列号[%d]持久[%d-%d]，绑定到%s成功。',
          [GetUseItemName(nItem),
          UserEngine.GetStdItemName(UserItem.wIndex),
            UserItem.wIndex,
            UserItem.MakeIndex,
            UserItem.Dura,
            UserItem.DuraMax,
            sBindName]),
            c_Blue, t_Hint);
        PlayObject.SysMsg(format('你的%s[%s]已经绑定到%s[%s]上了。',
          [GetUseItemName(nItem),
          UserEngine.GetStdItemName(UserItem.wIndex),
            sType,
            sBindName
            ]), c_Blue, t_Hint);
      end;
    1: begin
        sBindName := PlayObject.m_sCharName;
        g_ItemBindCharName.Lock;
        try
          for i := 0 to g_ItemBindCharName.Count - 1 do begin
            ItemBind := g_ItemBindCharName.Items[i];
            if (ItemBind.nItemIdx = nItemIdx) and (ItemBind.nMakeIdex = nMakeIdex) then begin
              SysMsg(format(g_sGameCommandBindUseItemAlreadBindMsg, [sHumanName, sItem]), c_Red, t_Hint);
              Exit;
            end;
          end;
          New(ItemBind);
          ItemBind.nItemIdx := nItemIdx;
          ItemBind.nMakeIdex := nMakeIdex;
          ItemBind.sBindName := sBindName;
          g_ItemBindCharName.Insert(0, ItemBind);
        finally
          g_ItemBindCharName.UnLock;
        end;
        SaveItemBindCharName();
        SysMsg(format('%s[%s]IDX[%d]系列号[%d]持久[%d-%d]，绑定到%s成功。',
          [GetUseItemName(nItem),
          UserEngine.GetStdItemName(UserItem.wIndex),
            UserItem.wIndex,
            UserItem.MakeIndex,
            UserItem.Dura,
            UserItem.DuraMax,
            sBindName]),
            c_Blue, t_Hint);
        PlayObject.SysMsg(format('你的%s[%s]已经绑定到%s[%s]上了。',
          [GetUseItemName(nItem),
          UserEngine.GetStdItemName(UserItem.wIndex),
            sType,
            sBindName
            ]), c_Blue, t_Hint);
      end;
    2: begin
        sBindName := PlayObject.m_sIPaddr;
        g_ItemBindIPaddr.Lock;
        try
          for i := 0 to g_ItemBindIPaddr.Count - 1 do begin
            ItemBind := g_ItemBindIPaddr.Items[i];
            if (ItemBind.nItemIdx = nItemIdx) and (ItemBind.nMakeIdex = nMakeIdex) then begin
              SysMsg(format(g_sGameCommandBindUseItemAlreadBindMsg, [sHumanName, sItem]), c_Red, t_Hint);
              Exit;
            end;
          end;
          New(ItemBind);
          ItemBind.nItemIdx := nItemIdx;
          ItemBind.nMakeIdex := nMakeIdex;
          ItemBind.sBindName := sBindName;
          g_ItemBindIPaddr.Insert(0, ItemBind);
        finally
          g_ItemBindIPaddr.UnLock;
        end;
        SaveItemBindIPaddr();
        SysMsg(format('%s[%s]IDX[%d]系列号[%d]持久[%d-%d]，绑定到%s成功。',
          [GetUseItemName(nItem),
          UserEngine.GetStdItemName(UserItem.wIndex),
            UserItem.wIndex,
            UserItem.MakeIndex,
            UserItem.Dura,
            UserItem.DuraMax,
            sBindName]),
            c_Blue, t_Hint);
        PlayObject.SysMsg(format('你的%s[%s]已经绑定到%s[%s]上了。',
          [GetUseItemName(nItem),
          UserEngine.GetStdItemName(UserItem.wIndex),
            sType,
            sBindName
            ]), c_Blue, t_Hint);
      end;
  end;
end;

procedure TPlayObject.CmdShutup(Cmd: pTGameCmd; sHumanName, sTime: string);
var
  dwTime: LongWord;
  nIndex: Integer;
begin
  if (m_btPermission < Cmd.nPermissionMin) then begin
    SysMsg(g_sGameCommandPermissionTooLow, c_Red, t_Hint);
    Exit;
  end;
  if (sTime = '') or (sHumanName = '') or ((sHumanName <> '') and (sHumanName[1] = '?')) then begin
    SysMsg(format(g_sGameCommandParamUnKnow, [Cmd.sCmd, g_sGameCommandShutupHelpMsg]), c_Red, t_Hint);
    Exit;
  end;
  dwTime := Str_ToInt(sTime, 5);
  g_DenySayMsgList.Lock;
  try
    nIndex := g_DenySayMsgList.GetIndex(sHumanName);
    if nIndex >= 0 then begin
      g_DenySayMsgList.Objects[nIndex] := TObject(GetTickCount + dwTime * 60 * 1000);
    end else begin
      g_DenySayMsgList.AddRecord(sHumanName, GetTickCount + dwTime * 60 * 1000);
    end;
  finally
    g_DenySayMsgList.UnLock;
  end;
  SysMsg(format(g_sGameCommandShutupHumanMsg, [sHumanName, dwTime]), c_Red, t_Hint);
end;

procedure TPlayObject.CmdShutupList(Cmd: pTGameCmd; sParam1: string);
var
  i: Integer;
begin
  if (m_btPermission < Cmd.nPermissionMin) then begin
    SysMsg(g_sGameCommandPermissionTooLow, c_Red, t_Hint);
    Exit;
  end;
  if ((sParam1 <> '') and (sParam1[1] = '?')) then begin
    SysMsg(format(g_sGameCommandParamUnKnow, [Cmd.sCmd, '']), c_Red, t_Hint);
    Exit;
  end;

  if (m_btPermission < 6) then Exit;
  g_DenySayMsgList.Lock;
  try
    if g_DenySayMsgList.Count <= 0 then begin
      SysMsg(g_sGameCommandShutupListIsNullMsg, c_Green, t_Hint);
      Exit;
    end;
    for i := 0 to g_DenySayMsgList.Count - 1 do begin
      SysMsg(g_DenySayMsgList.Strings[i] + ' ' + IntToStr((LongWord(g_DenySayMsgList.Objects[i]) - GetTickCount) div 60000), c_Green, t_Hint);
    end;
  finally
    g_DenySayMsgList.UnLock;
  end;
end;

procedure TPlayObject.CmdShutupRelease(Cmd: pTGameCmd; sHumanName: string; boAll: Boolean);
var
  i: Integer;
  PlayObject: TPlayObject;
begin
  if (m_btPermission < Cmd.nPermissionMin) then begin
    SysMsg(g_sGameCommandPermissionTooLow, c_Red, t_Hint);
    Exit;
  end;
  if (sHumanName = '') or ((sHumanName <> '') and (sHumanName[1] = '?')) then begin
    SysMsg(format(g_sGameCommandParamUnKnow, [Cmd.sCmd, g_sGameCommandShutupReleaseHelpMsg]), c_Red, t_Hint);
    Exit;
  end;
  g_DenySayMsgList.Lock;
  try
    i := g_DenySayMsgList.GetIndex(sHumanName);
    if i >= 0 then begin
      g_DenySayMsgList.Delete(i);
      PlayObject := UserEngine.GetPlayObject(sHumanName);
      if PlayObject <> nil then begin
        PlayObject.SysMsg(g_sGameCommandShutupReleaseCanSendMsg, c_Red, t_Hint);
      end;
      if boAll then begin
        UserEngine.SendServerGroupMsg(SS_210, nServerIndex, sHumanName);
      end;
      SysMsg(format(g_sGameCommandShutupReleaseHumanCanSendMsg, [sHumanName]), c_Green, t_Hint);
    end;
  finally
    g_DenySayMsgList.UnLock;
  end;
end;

procedure TPlayObject.CmdSmakeItem(Cmd: pTGameCmd; nWhere, nValueType, nValue: Integer);
var
  sShowMsg: string;
  StdItem: pTStdItem;
begin
  if (m_btPermission < Cmd.nPermissionMin) then begin
    SysMsg(g_sGameCommandPermissionTooLow, c_Red, t_Hint);
    Exit;
  end;

  if (nWhere in [0..12]) and (nValueType in [0..15]) and (nValue in [0..255]) then begin
    if m_UseItems[nWhere].wIndex > 0 then begin
      StdItem := UserEngine.GetStdItem(m_UseItems[nWhere].wIndex);
      if StdItem = nil then Exit;

      if nValueType > 13 then begin
        nValue := _MIN(65, nValue);
        if nValueType = 14 then m_UseItems[nWhere].Dura := nValue * 1000;
        if nValueType = 15 then m_UseItems[nWhere].DuraMax := nValue * 1000;
      end else begin
        m_UseItems[nWhere].btValue[nValueType] := nValue;
      end;
      RecalcAbilitys();
      SendUpdateItem(@m_UseItems[nWhere]);
      sShowMsg := IntToStr(m_UseItems[nWhere].wIndex) + '-' + IntToStr(m_UseItems[nWhere].MakeIndex) + ' ' +
        IntToStr(m_UseItems[nWhere].Dura) + '/' + IntToStr(m_UseItems[nWhere].DuraMax) + ' ' +
        IntToStr(m_UseItems[nWhere].btValue[0]) + '/' +
        IntToStr(m_UseItems[nWhere].btValue[1]) + '/' +
        IntToStr(m_UseItems[nWhere].btValue[2]) + '/' +
        IntToStr(m_UseItems[nWhere].btValue[3]) + '/' +
        IntToStr(m_UseItems[nWhere].btValue[4]) + '/' +
        IntToStr(m_UseItems[nWhere].btValue[5]) + '/' +
        IntToStr(m_UseItems[nWhere].btValue[6]) + '/' +
        IntToStr(m_UseItems[nWhere].btValue[7]) + '/' +
        IntToStr(m_UseItems[nWhere].btValue[8]) + '/' +
        IntToStr(m_UseItems[nWhere].btValue[9]) + '/' +
        IntToStr(m_UseItems[nWhere].btValue[10]) + '/' +
        IntToStr(m_UseItems[nWhere].btValue[11]) + '/' +
        IntToStr(m_UseItems[nWhere].btValue[12]) + '/' +
        IntToStr(m_UseItems[nWhere].btValue[13]);
      SysMsg(sShowMsg, c_Blue, t_Hint);
      if g_Config.boShowMakeItemMsg then
        MainOutMessage('[物品调整] ' + m_sCharName + '(' + StdItem.Name + ' -> ' + sShowMsg + ')');
    end else begin
      SysMsg(g_sGamecommandSuperMakeHelpMsg, c_Red, t_Hint);
    end;
  end;
end;

procedure TPlayObject.CmdSpirtStart(sCmd, sParam1: string);
var
  nTime: Integer;
  dwTime: LongWord;
begin
  if (m_btPermission < 6) then Exit;
  if (sParam1 <> '') and (sParam1[1] = '?') then begin
    SysMsg('此命令用于开始祈祷生效宝宝叛变。', c_Red, t_Hint);
    Exit;
  end;
  nTime := Str_ToInt(sParam1, -1);
  if nTime > 0 then begin
    dwTime := LongWord(nTime) * 1000;
  end else begin
    dwTime := g_Config.dwSpiritMutinyTime;
  end;
  g_dwSpiritMutinyTick := GetTickCount + dwTime;
  SysMsg('祈祷叛变已开始。持续时长 ' + IntToStr(dwTime div 1000) + ' 秒。', c_Green, t_Hint);
end;

procedure TPlayObject.CmdSpirtStop(sCmd, sParam1: string);
begin
  if (m_btPermission < 6) then Exit;
  if (sParam1 <> '') and (sParam1[1] = '?') then begin
    SysMsg('此命令用于停止祈祷生效导致宝宝叛变。', c_Red, t_Hint);
    Exit;
  end;
  g_dwSpiritMutinyTick := 0;
  SysMsg('祈祷叛变已停止。', c_Green, t_Hint);
end;

procedure TPlayObject.CmdStartQuest(Cmd: pTGameCmd; sQuestName: string);
begin
  if (m_btPermission < Cmd.nPermissionMin) then begin
    SysMsg(g_sGameCommandPermissionTooLow, c_Red, t_Hint);
    Exit;
  end;
  if (sQuestName = '') then begin
    SysMsg('命令格式: @' + Cmd.sCmd + ' 问答名称', c_Red, t_Hint);
    Exit;
  end;
  UserEngine.SendQuestMsg(sQuestName);
end;

procedure TPlayObject.CmdSuperTing(Cmd: pTGameCmd; sHumanName, sRange: string);
var
  i: Integer;
  PlayObject: TPlayObject;
  MoveHuman: TPlayObject;
  nRange: Integer;
  HumanList: TList;
begin
  if (m_btPermission < Cmd.nPermissionMin) then begin
    SysMsg(g_sGameCommandPermissionTooLow, c_Red, t_Hint);
    Exit;
  end;
  if (sRange = '') or (sHumanName = '') or ((sHumanName <> '') and (sHumanName[1] = '?')) then begin
    SysMsg(format(g_sGameCommandParamUnKnow, [Cmd.sCmd, g_sGameCommandSuperTingHelpMsg]), c_Red, t_Hint);
    Exit;
  end;
  nRange := _MAX(10, Str_ToInt(sRange, 2));
  PlayObject := UserEngine.GetPlayObject(sHumanName);
  if PlayObject <> nil then begin
    HumanList := TList.Create;
    UserEngine.GetMapRageHuman(PlayObject.m_PEnvir, PlayObject.m_nCurrX, PlayObject.m_nCurrY, nRange, HumanList);
    for i := 0 to HumanList.Count - 1 do begin
      MoveHuman := TPlayObject(HumanList.Items[i]);
      if MoveHuman <> Self then
        MoveHuman.MapRandomMove(MoveHuman.m_sHomeMap, 0);
    end;
    HumanList.Free;
  end else begin
    SysMsg(format(g_sNowNotOnLineOrOnOtherServer, [sHumanName]), c_Red, t_Hint);
  end;
end;

procedure TPlayObject.CmdTakeOffHorse(sCmd, sParam: string);
begin
  if (sParam <> '') and (sParam[1] = '?') then begin
    SysMsg('下马命令，在骑马状态输入此命令下马。', c_Red, t_Hint);
    SysMsg(format('命令格式: @%s', [sCmd]), c_Red, t_Hint);
    Exit;
  end;
  if not m_boOnHorse then Exit;
  m_boOnHorse := False;
  FeatureChanged();
end;

procedure TPlayObject.CmdTakeOnHorse(sCmd, sParam: string);
begin
  if (sParam <> '') and (sParam[1] = '?') then begin
    SysMsg('上马命令，在戴好马牌后输入此命令就可以骑上马。', c_Red, t_Hint);
    SysMsg(format('命令格式: @%s', [sCmd]), c_Red, t_Hint);
    Exit;
  end;
  if m_boOnHorse then Exit;
  if (m_btHorseType = 0) then begin
    SysMsg('骑马必须先戴上马牌！！！', c_Red, t_Hint);
    Exit;
  end;
  m_boOnHorse := True;
  FeatureChanged();
end;

procedure TPlayObject.CmdTestFire(sCmd: string; nRange, nType, nTime, nPoint: Integer);
var
  nX, nY: Integer;
  FireBurnEvent: TFireBurnEvent;
  nMinX, nMaxX, nMinY, nMaxY: Integer;
begin
  nMinX := m_nCurrX - nRange;
  nMaxX := m_nCurrX + nRange;
  nMinY := m_nCurrY - nRange;
  nMaxY := m_nCurrY + nRange;
  for nX := nMinX to nMaxX do begin
    for nY := nMinY to nMaxY do begin
      if ((nX < nMaxX) and (nY = nMinY)) or
        ((nY < nMaxY) and (nX = nMinX)) or
        (nX = nMaxX) or (nY = nMaxY) then begin
        FireBurnEvent := TFireBurnEvent.Create(Self, nX, nY, nType, nTime * 1000, nPoint);
        g_EventManager.AddEvent(FireBurnEvent);
      end;
    end;
  end;
end;

procedure TPlayObject.CmdTestGetBagItems(Cmd: pTGameCmd; sParam: string);
var
  btDc, btSc, btMc, btDura: Byte;
begin
  if (m_btPermission < Cmd.nPermissionMin) then begin
    SysMsg(g_sGameCommandPermissionTooLow, c_Red, t_Hint);
    Exit;
  end;
  if (sParam <> '') and (sParam[1] = '?') then begin
    SysMsg(format(g_sGameCommandParamUnKnow, [Cmd.sCmd, g_sGameCommandTestGetBagItemsHelpMsg]), c_Red, t_Hint);
    Exit;
  end;
  btDc := 0;
  btSc := 0;
  btMc := 0;
  btDura := 0;
  GetBagUseItems(btDc, btSc, btMc, btDura);
  SysMsg(format('DC:%d SC:%d MC:%d DURA:%d', [btDc, btSc, btMc, btDura]), c_Blue, t_Hint);
end;

procedure TPlayObject.CmdTestSpeedMode(Cmd: pTGameCmd);
begin
  if (m_btPermission < Cmd.nPermissionMin) then begin
    SysMsg(g_sGameCommandPermissionTooLow, c_Red, t_Hint);
    Exit;
  end;
  m_boTestSpeedMode := not m_boTestSpeedMode;
  if m_boTestSpeedMode then begin
    SysMsg('开启速度测试模式', c_Red, t_Hint);
  end else begin
    SysMsg('关闭速度测试模式', c_Red, t_Hint);
  end;
end;

procedure TPlayObject.CmdTestStatus(sCmd: string; nType, nTime: Integer);
begin
  if (m_btPermission < 6) then Exit;
  if (not (nType in [Low(TStatusTime)..High(TStatusTime)])) or (nTime < 0) then begin
    SysMsg('命令格式: @' + sCmd + ' 类型(0..11) 时长', c_Red, t_Hint);
    Exit;
  end;
  m_wStatusTimeArr[nType] := nTime * 1000;
  m_dwStatusArrTick[nType] := GetTickCount();
  m_nCharStatus := GetCharStatus();
  StatusChanged();
  SysMsg(format('状态编号:%d 时间长度: %d 秒', [nType, nTime]), c_Green, t_Hint);
end;

procedure TPlayObject.CmdTing(Cmd: pTGameCmd; sHumanName: string);
var
  PlayObject: TPlayObject;
begin
  if (m_btPermission < Cmd.nPermissionMin) then begin
    SysMsg(g_sGameCommandPermissionTooLow, c_Red, t_Hint);
    Exit;
  end;
  if (sHumanName = '') or ((sHumanName <> '') and (sHumanName[1] = '?')) then begin
    SysMsg(format(g_sGameCommandParamUnKnow, [Cmd.sCmd, g_sGameCommandTingHelpMsg]), c_Red, t_Hint);
    Exit;
  end;
  PlayObject := UserEngine.GetPlayObject(sHumanName);
  if PlayObject <> nil then begin
    PlayObject.MapRandomMove(m_sHomeMap, 0);
  end else begin
    SysMsg(format(g_sNowNotOnLineOrOnOtherServer, [sHumanName]), c_Red, t_Hint);
  end;
end;

procedure TPlayObject.CmdTraining(sSkillName: string; nLevel: Integer); //004CC414
begin
  if (m_btPermission < 6) then Exit;
end;

procedure TPlayObject.CmdUserMoveXY(sCmd, sX, sY: string);
var
  Envir: TEnvirnoment;
  nX, nY: Integer;
begin
  if m_boTeleport then begin
    nX := Str_ToInt(sX, -1);
    nY := Str_ToInt(sY, -1);
    {
    if (nX < 0) or (nY < 0) then begin
      SysMsg('命令格式: @' + sCMD + ' 座标X 座标Y',c_Red,t_Hint);
      exit;
    end;
    }
    if not m_PEnvir.m_boNOPOSITIONMOVE then begin
      if m_PEnvir.CanWalkOfItem(nX, nY, g_Config.boUserMoveCanDupObj, g_Config.boUserMoveCanOnItem) then begin
        if (GetTickCount - m_dwTeleportTick) > g_Config.dwUserMoveTime * 1000 {10000} then begin
          m_dwTeleportTick := GetTickCount();
          if (m_UseItems[U_BUJUK].wIndex > 0) and (m_UseItems[U_BUJUK].Dura > 0) then begin //增加传送符功能
            if m_UseItems[U_BUJUK].Dura > 100 then begin
              Dec(m_UseItems[U_BUJUK].Dura, 100);
            end else begin
              m_UseItems[U_BUJUK].Dura := 0;
            end;
            SendMsg(Self, RM_DURACHANGE, U_BUJUK, m_UseItems[U_BUJUK].Dura, m_UseItems[U_BUJUK].DuraMax, 0, '');
            SendRefMsg(RM_SPACEMOVE_FIRE, 0, 0, 0, 0, '');
            SpaceMove(m_sMapName, nX, nY, 0);
            Exit;
          end;
          SendRefMsg(RM_SPACEMOVE_FIRE, 0, 0, 0, 0, '');
          //BaseObjectMove('',sX,sY);
          SpaceMove(m_sMapName, nX, nY, 0);
        end else begin
          SysMsg(IntToStr(g_Config.dwUserMoveTime - (GetTickCount - m_dwTeleportTick) div 1000) + '秒之后才可以再使用此功能！！！', c_Red, t_Hint);
        end;
      end else begin
        SysMsg(format(g_sGameCommandPositionMoveCanotMoveToMap, [m_sMapName, sX, sY]), c_Green, t_Hint);
      end;
    end else begin
      SysMsg('此地图禁止使用此命令！！！', c_Red, t_Hint);
    end;
  end else begin
    SysMsg('您现在还无法使用此功能！！！', c_Red, t_Hint);
  end;
end;

procedure TPlayObject.CmdViewDiary(sCmd: string; nFlag: Integer);
begin

end;

procedure TPlayObject.CmdViewWhisper(Cmd: pTGameCmd; sCharName, sParam2: string);
var
  PlayObject: TPlayObject;
begin
  if (m_btPermission < Cmd.nPermissionMin) then begin
    SysMsg(g_sGameCommandPermissionTooLow, c_Red, t_Hint);
    Exit;
  end;
  if (sCharName = '') or ((sCharName <> '') and (sCharName[1] = '?')) then begin
    SysMsg(format(g_sGameCommandParamUnKnow, [Cmd.sCmd, g_sGameCommandViewWhisperHelpMsg]), c_Red, t_Hint);
    Exit;
  end;
  PlayObject := UserEngine.GetPlayObject(sCharName);
  if PlayObject <> nil then begin
    if PlayObject.m_GetWhisperHuman = Self then begin
      PlayObject.m_GetWhisperHuman := nil;
      SysMsg(format(g_sGameCommandViewWhisperMsg1, [sCharName]), c_Green, t_Hint);
    end else begin
      PlayObject.m_GetWhisperHuman := Self;
      SysMsg(format(g_sGameCommandViewWhisperMsg2, [sCharName]), c_Green, t_Hint);
    end;
  end else begin
    SysMsg(format(g_sNowNotOnLineOrOnOtherServer, [sCharName]), c_Red, t_Hint);
  end;
end;

constructor TPlayObject.Create;
begin
  inherited;
  m_btRaceServer := RC_PLAYOBJECT;
  m_boEmergencyClose := False;
  m_boSwitchData := False;
  m_boReconnection := False;
  m_boKickFlag := False;
  m_boSoftClose := False;
  m_boReadyRun := False;
  bo698 := False;
  n69C := 0;
  m_dwSaveRcdTick := GetTickCount();
  m_boWantRefMsg := True;
  m_boRcdSaved := False;
  m_boDieInFight3Zone := False;
  m_Script := nil;
  m_boTimeRecall := False;
  m_sMoveMap := '';
  m_nMoveX := 0;
  m_nMoveY := 0;
  m_dwRunTick := GetTickCount();
  m_nRunTime := 250;
  m_dwSearchTime := 1000;
  m_dwSearchTick := GetTickCount();
  m_nViewRange := 12;
  m_boNewHuman := False;
  m_boLoginNoticeOK := False;
  bo6AB := False;
  m_boExpire := False;
  m_boSendNotice := False;
  m_dwCheckDupObjTick := GetTickCount();
  dwTick578 := GetTickCount();
  dwTick57C := GetTickCount();
  m_boInSafeArea := False;
  n5F8 := 0;
  n5FC := 0;
  m_dwMagicAttackTick := GetTickCount();
  m_dwMagicAttackInterval := 0;
  m_dwAttackTick := GetTickCount();
  m_dwMoveTick := GetTickCount();
  m_dwTurnTick := GetTickCount();
  m_dwActionTick := GetTickCount();
  m_dwAttackCount := 0;
  m_dwAttackCountA := 0;
  m_dwMagicAttackCount := 0;
  m_dwMoveCount := 0;
  m_dwMoveCountA := 0;
  m_nOverSpeedCount := 0;
  TList55C := TList.Create;
  m_sOldSayMsg := '';
  m_dwSayMsgTick := GetTickCount();
  m_boDisableSayMsg := False;
  m_dwDisableSayMsgTick := GetTickCount();
  m_dLogonTime := Now();
  m_dwLogonTick := GetTickCount();
  n584 := 0;
  n588 := 0;
  m_boSwitchData := False;
  m_boSwitchDataSended := False;
  m_nWriteChgDataErrCount := 0;
  m_dwShowLineNoticeTick := GetTickCount();
  m_nShowLineNoticeIdx := 0;
  m_nSoftVersionDateEx := 0;
  m_CanJmpScriptLableList := TStringList.Create;
  m_nKillMonExpMultiple := 1;
  m_nKillMonExpRate := 100;
  m_dwRateTick := GetTickCount();
  m_nPowerRate := 100;
  m_boSetStoragePwd := False;
  m_boReConfigPwd := False;
  m_boCheckOldPwd := False;
  m_boUnLockPwd := False;
  m_boUnLockStoragePwd := False;
  m_boPasswordLocked := False; //锁仓库
  m_btPwdFailCount := 0;
  m_sTempPwd := '';
  m_sStoragePwd := ''; ;
  m_boFilterSendMsg := False;
  m_boCanDeal := True;
  m_boCanDrop := True;
  m_boCanGetBackItem := True;
  m_boCanWalk := True;
  m_boCanRun := True;
  m_boCanHit := True;
  m_boCanSpell := True;
  m_boCanUseItem := True;
  m_nMemberType := 0;
  m_nMemberLevel := 0;

  m_nGameGold := 0;
  m_boDecGameGold := False;
  m_nDecGameGold := 1;
  m_dwDecGameGoldTick := GetTickCount();
  m_dwDecGameGoldTime := 60 * 1000;

  m_boIncGameGold := False;
  m_nIncGameGold := 1;
  m_dwIncGameGoldTick := GetTickCount();
  m_dwIncGameGoldTime := 60 * 1000;

  m_nGamePoint := 0;
  m_dwIncGamePointTick := GetTickCount();

  m_nPayMentPoint := 0;

  m_DearHuman := nil;
  m_MasterHuman := nil;
  m_MasterList := TList.Create;
  m_boSendMsgFlag := False;
  m_boChangeItemNameFlag := False;

  m_boCanMasterRecall := False;
  m_boCanDearRecall := False;
  m_dwDearRecallTick := GetTickCount();
  m_dwMasterRecallTick := GetTickCount();
  m_btReColorIdx := 0;
  m_GetWhisperHuman := nil;
  m_boOnHorse := False;
  m_wContribution := 0;
  m_sRankLevelName := g_sRankLevelName;
  m_boFixedHideMode := True;
  m_nStep := 0;
  FillChar(m_nMval, SizeOf(m_nMval), #0);
  m_nClientFlagMode := -1;
  m_dwAutoGetExpTick := GetTickCount;
  m_nAutoGetExpPoint := 0;
  m_AutoGetExpEnvir := nil;
  m_dwHitIntervalTime := g_Config.dwHitIntervalTime; //攻击间隔
  m_dwMagicHitIntervalTime := g_Config.dwMagicHitIntervalTime; //魔法间隔
  m_dwRunIntervalTime := g_Config.dwRunIntervalTime; //走路间隔
  m_dwWalkIntervalTime := g_Config.dwWalkIntervalTime; //走路间隔
  m_dwTurnIntervalTime := g_Config.dwTurnIntervalTime; //换方向间隔
  m_dwActionIntervalTime := g_Config.dwActionIntervalTime; //组合操作间隔
  m_dwRunLongHitIntervalTime := g_Config.dwRunLongHitIntervalTime; //组合操作间隔
  m_dwRunHitIntervalTime := g_Config.dwRunHitIntervalTime; //组合操作间隔
  m_dwWalkHitIntervalTime := g_Config.dwWalkHitIntervalTime; //组合操作间隔
  m_dwRunMagicIntervalTime := g_Config.dwRunMagicIntervalTime; //跑位魔法间隔
  m_DynamicVarList := TList.Create;
  m_SessInfo := nil;
  m_boTestSpeedMode := False;
  m_boLockLogon := True;
  m_boLockLogoned := False;

  m_boRemoteMsg := False; //是否允许接受消息

  m_boNotOnlineAddExp := False; //是否是离线挂机人物
  m_boStartAutoAddExpPoint := False; //是否开始增加经验
  m_dwStartNotOnlineAddExpTime := 0; //离线挂机开始时间
  m_dwNotOnlineAddExpTime := 0; //离线挂机时长
  m_nNotOnlineAddExpPoint := 0; //离线挂机每分钟增加经验值
  m_dwAutoAddExpPointTick := GetTickCount;
  m_dwAutoAddExpPointTimeTick := GetTickCount;
  m_sAutoSendMsg := ''; //自动回复信息
  m_boKickAutoAddExpUser := False;
  m_boTimeGoto := False;
  m_dwTimeGotoTick := GetTickCount;
  m_sTimeGotoLable := '';
  m_TimeGotoNPC := nil;
  m_nBigStoragePage := 0; //无限仓库的当前页数
  m_nDealGoldPose := 0;
  m_boPlayOffLine := True; //是否允许下线触发
  m_dwDedingUseTick := 0;
  m_nCopyHumanLevel := 0;
  m_boAllowReAlive := False; //是否允许复活

  FillChar(m_nInteger, SizeOf(m_nInteger), #0);
  FillChar(m_sString, SizeOf(m_sString), #0);
  FillChar(m_dwUserTick, SizeOf(m_dwUserTick), #0);
  if Assigned(zPlugOfEngine.PlayObjectCreate) then begin
    zPlugOfEngine.PlayObjectCreate(Self);
  end;
end;

procedure TPlayObject.DealCancel;
begin
  if not m_boDealing then Exit;
  m_boDealing := False;
  SendDefMessage(SM_DEALCANCEL, 0, 0, 0, 0, '');
  if m_DealCreat <> nil then begin
    TPlayObject(m_DealCreat).DealCancel;
  end;
  m_DealCreat := nil;
  GetBackDealItems();
  SysMsg(g_sDealActionCancelMsg {'交易取消'}, c_Green, t_Hint);
  m_DealLastTick := GetTickCount();
end;

procedure TPlayObject.DealCancelA;
begin
  m_Abil.HP := m_WAbil.HP;
  DealCancel();
end;

function TPlayObject.DecGold(nGold: Integer): Boolean;
begin
  Result := False;
  if m_nGold >= nGold then begin
    Dec(m_nGold, nGold);
    Result := True;
  end;
end;

procedure TPlayObject.DecGameGold(nGameGold: Integer);
begin
  if m_nGameGold >= nGameGold then begin
    Dec(m_nGameGold, nGameGold);
  end else m_nGameGold := 0;
end;
procedure TPlayObject.DecGamePoint(nGamePoint: Integer);
begin
  if m_nGamePoint >= nGamePoint then begin
    Dec(m_nGamePoint, nGamePoint);
  end else m_nGamePoint := 0;
end;

destructor TPlayObject.Destroy;
var
  i: Integer;
begin
  if m_MasterList <> nil then
    FreeAndNil(m_MasterList);
  for i := 0 to TList55C.Count - 1 do begin

  end;
  FreeAndNil(TList55C);
  if m_DynamicVarList <> nil then begin
    if m_DynamicVarList.Count > 0 then begin
      for i := 0 to m_DynamicVarList.Count - 1 do begin
        if pTDynamicVar(m_DynamicVarList.Items[i]) <> nil then
          DisPose(pTDynamicVar(m_DynamicVarList.Items[i]));
      end;
    end;
    FreeAndNil(m_DynamicVarList);
  end;
  if m_CanJmpScriptLableList <> nil then
    FreeAndNil(m_CanJmpScriptLableList);
  if Assigned(zPlugOfEngine.PlayObjectDestroy) then begin
    try
      zPlugOfEngine.PlayObjectDestroy(Self);
    except
    end;
  end;
  inherited;
end;

procedure TPlayObject.Disappear;
begin
  if m_boReadyRun then DisappearA;
  if m_boTransparent and m_boHideMode then m_wStatusTimeArr[STATE_TRANSPARENT {0x70}] := 0;

  if m_GroupOwner <> nil then begin
    m_GroupOwner.DelMember(Self);
  end;
  if m_MyGuild <> nil then begin
    TGUild(m_MyGuild).DelHumanObj(Self);
  end;
  LogonTimcCost();
  inherited;
end;

procedure TPlayObject.DropUseItems(BaseObject: TBaseObject);
var
  i: Integer;
  nRate: Integer;
  StdItem: pTStdItem;
  DelList: TStringList;
resourcestring
  sExceptionMsg = '[Exception] TPlayObject::DropUseItems';
begin
  DelList := nil;
  try
    if m_boAngryRing or m_boNoDropUseItem or (m_btRaceServer <> RC_PLAYOBJECT) then Exit;
    for i := Low(THumanUseItems) to High(THumanUseItems) do begin
      StdItem := UserEngine.GetStdItem(m_UseItems[i].wIndex);
      if StdItem <> nil then begin
        if StdItem.Reserved and 8 <> 0 then begin
          if DelList = nil then DelList := TStringList.Create;
          DelList.AddObject('', TObject(m_UseItems[i].MakeIndex));
          //004BB885
          if StdItem.NeedIdentify = 1 then
            AddGameDataLog('16' + #9 +
              m_sMapName + #9 +
              IntToStr(m_nCurrX) + #9 +
              IntToStr(m_nCurrY) + #9 +
              m_sCharName + #9 +
              //UserEngine.GetStdItemName(m_UseItems[I].wIndex) + #9 +
              StdItem.Name + #9 +
              IntToStr(m_UseItems[i].MakeIndex) + #9 +
              BoolToIntStr(m_btRaceServer = RC_PLAYOBJECT) + #9 +
              '0');
          m_UseItems[i].wIndex := 0;
        end;
      end;
    end;

    if PKLevel > 2 then nRate := g_Config.nDieRedDropUseItemRate {15}
    else nRate := g_Config.nDieDropUseItemRate {30};

    for i := Low(THumanUseItems) to High(THumanUseItems) do begin
      if Random(nRate) <> 0 then Continue;
      StdItem := UserEngine.GetStdItem(m_UseItems[i].wIndex);
      if InDisableTakeOffList(m_UseItems[i].wIndex) then Continue; //检查是否在禁止取下列表,如果在列表中则不掉此物品
      if DropItemDown(@m_UseItems[i], 2, True, BaseObject, Self) then begin
        StdItem := UserEngine.GetStdItem(m_UseItems[i].wIndex);
        if StdItem <> nil then begin
          if StdItem.Reserved and 10 = 0 then begin
            if m_btRaceServer = RC_PLAYOBJECT then begin
              if StdItem.Reserved = 10 then Continue; //增加不允许掉落装备
              if DelList = nil then DelList := TStringList.Create;
              DelList.AddObject(UserEngine.GetStdItemName(m_UseItems[i].wIndex), TObject(m_UseItems[i].MakeIndex));
            end;
            m_UseItems[i].wIndex := 0;
          end;
        end;
      end;
    end;
    if DelList <> nil then
      SendMsg(Self, RM_SENDDELITEMLIST, 0, Integer(DelList), 0, 0, '');
  except
    MainOutMessage(sExceptionMsg);
  end;
end;

procedure TPlayObject.GainExp(dwExp: LongWord);
var
  i, n, sumlv, nExp, nHighLevel, nLowLevel: Integer;
  PlayObject: TPlayObject;
  nCheckCode: Integer;
resourcestring
  sExceptionMsg = '[Exception] TPlayObject::GainExp';
const
  bonus: array[0..GROUPMAX] of real = (1, 1.2, 1.3, 1.4, 1.5, 1.6, 1.7, 1.8, 1.9, 2, 2.1, 2.2);
begin
  try
    nCheckCode := 0;
    nHighLevel := 0;
    nLowLevel := High(Word);
    if dwExp > 0 then begin
      if (m_GroupOwner <> nil) and (m_GroupOwner.m_GroupMembers <> nil) and (m_GroupOwner.m_GroupMembers.Count > 0) then begin
        sumlv := 0;
        n := 0;
        nCheckCode := 1;
        for i := 0 to m_GroupOwner.m_GroupMembers.Count - 1 do begin
          PlayObject := TPlayObject(m_GroupOwner.m_GroupMembers.Objects[i]);
          if PlayObject <> nil then begin
            if not PlayObject.m_boDeath and (m_PEnvir = PlayObject.m_PEnvir) and (abs(m_nCurrX - PlayObject.m_nCurrX) <= 12) and (abs(m_nCurrX - PlayObject.m_nCurrX) <= 12) then begin
              sumlv := sumlv + PlayObject.m_Abil.Level;
              if PlayObject.m_Abil.Level > nHighLevel then nHighLevel := PlayObject.m_Abil.Level;
              if PlayObject.m_Abil.Level < nLowLevel then nLowLevel := PlayObject.m_Abil.Level;
              Inc(n);
            end;
          end;
        end;
        nCheckCode := 2;
        if (sumlv > 0) and (n > 1) then begin
          if n in [0..GROUPMAX] then
            dwExp := ROUND(dwExp * bonus[n]);
          nCheckCode := 3;
          for i := 0 to m_GroupOwner.m_GroupMembers.Count - 1 do begin
            PlayObject := TPlayObject(m_GroupOwner.m_GroupMembers.Objects[i]);
            if PlayObject <> nil then begin
              if not PlayObject.m_boDeath and (m_PEnvir = PlayObject.m_PEnvir) and (abs(m_nCurrX - PlayObject.m_nCurrX) <= 12) and (abs(m_nCurrX - PlayObject.m_nCurrX) <= 12) then begin
                if g_Config.boHighLevelKillMonFixExp and g_Config.boHighLevelGroupFixExp then begin //02/08 增加，在高等级经验不变时，把组队的经验平均分配
                  nCheckCode := 4;
                  PlayObject.WinExp(ROUND(dwExp / n));
                  nCheckCode := 5;
                end else
                  if g_Config.boHighLevelGroupFixExp then begin
                  nCheckCode := 6;
                  PlayObject.WinExp(ROUND(dwExp / sumlv * PlayObject.m_Abil.Level));
                  nCheckCode := 7;
                end else
                  if m_Abil.Level > (nLowLevel + 10) then begin //大号杀怪组里人经验不变
                  PlayObject.WinExp(ROUND(dwExp / sumlv * PlayObject.m_Abil.Level));
                  //PlayObject.WinExp(dwExp);
                end else
                  if m_Abil.Level <= (nLowLevel + 10) then begin
                  if PlayObject.m_Abil.Level > (nLowLevel + 10) then begin //小号杀怪经验组里人大号经验改变
                    nExp := ROUND(dwExp / PlayObject.m_Abil.Level);
                    if nExp <= 0 then nExp := 1;
                    PlayObject.WinExp(nExp);
                  end else begin
                    PlayObject.WinExp(ROUND(dwExp / sumlv * PlayObject.m_Abil.Level)); //小号杀怪经验组里人小号经验不变
                  end;
                end;
              end;
            end;
          end;
        end else WinExp(dwExp);
      end else WinExp(dwExp);
    end;
  except
    MainOutMessage(sExceptionMsg + ' ' + IntToStr(nCheckCode));
  end;
end;

procedure TPlayObject.GameTimeChanged;
begin
  if m_nBright <> g_nGameTime then begin
    m_nBright := g_nGameTime;
    SendMsg(Self, RM_DAYCHANGING, 0, 0, 0, 0, '');
  end;
end;

procedure TPlayObject.GetBackDealItems;
var
  i: Integer;
begin
  if m_DealItemList.Count > 0 then begin
    for i := 0 to m_DealItemList.Count - 1 do begin
      m_ItemList.Add(m_DealItemList.Items[i]);
    end;
  end;
  m_DealItemList.Clear;
  Inc(m_nGold, m_nDealGolds);
  m_nDealGolds := 0;
  m_boDealOK := False;
end;

procedure TPlayObject.GetBagUseItems(var btDc, btSc, btMc, btDura: Byte);
var
  i, ii: Integer;
  DuraList: TList;
  UserItem: pTUserItem;
  StdItem: pTStdItem;
  StdItem80: TStdItem;
  DelItemList: TStringList;
  nDc, nSc, nMc, nDcMin, nDcMax, nScMin, nScMax, nMcMin, nMcMax, nDura, nItemCount: Integer;
begin
  nDcMin := 0;
  nDcMax := 0;
  nScMin := 0;
  nScMax := 0;
  nMcMin := 0;
  nMcMax := 0;
  nDura := 0;
  nItemCount := 0;
  DelItemList := nil;
  DuraList := TList.Create;
  for i := m_ItemList.Count - 1 downto 0 do begin
    if m_ItemList.Count <= 0 then break;
    UserItem := m_ItemList.Items[i];
    if UserItem = nil then Continue;
    if UserEngine.GetStdItemName(UserItem.wIndex) = g_Config.sBlackStone then begin
      DuraList.Add(Pointer(ROUND(UserItem.Dura / 1.0E3)));
      if DelItemList = nil then DelItemList := TStringList.Create;
      DelItemList.AddObject(g_Config.sBlackStone, TObject(UserItem.MakeIndex));
      DisPose(UserItem);
      m_ItemList.Delete(i);
    end else begin
      if IsUseItem(UserItem.wIndex) then begin
        StdItem := UserEngine.GetStdItem(UserItem.wIndex);
        if StdItem <> nil then begin
          StdItem80 := StdItem^;
          ItemUnit.GetItemAddValue(UserItem, StdItem80);
          nDc := 0;
          nSc := 0;
          nMc := 0;
          case StdItem80.StdMode of
            19, 20, 21: begin //004A0421
                nDc := HiWord(StdItem80.DC) + LoWord(StdItem80.DC);
                nSc := HiWord(StdItem80.SC) + LoWord(StdItem80.SC);
                nMc := HiWord(StdItem80.MC) + LoWord(StdItem80.MC);
              end;
            22, 23: begin //004A046E
                nDc := HiWord(StdItem80.DC) + LoWord(StdItem80.DC);
                nSc := HiWord(StdItem80.SC) + LoWord(StdItem80.SC);
                nMc := HiWord(StdItem80.MC) + LoWord(StdItem80.MC);
              end;
            24, 26: begin
                nDc := HiWord(StdItem80.DC) + LoWord(StdItem80.DC) + 1;
                nSc := HiWord(StdItem80.SC) + LoWord(StdItem80.SC) + 1;
                nMc := HiWord(StdItem80.MC) + LoWord(StdItem80.MC) + 1;
              end;
          end;
          if nDcMin < nDc then begin
            nDcMax := nDcMin;
            nDcMin := nDc;
          end else begin
            if nDcMax < nDc then nDcMax := nDc;
          end;
          if nScMin < nSc then begin
            nScMax := nScMin;
            nScMin := nSc;
          end else begin
            if nScMax < nSc then nScMax := nSc;
          end;
          if nMcMin < nMc then begin
            nMcMax := nMcMin;
            nMcMin := nMc;
          end else begin
            if nMcMax < nMc then nMcMax := nMc;
          end;
          if DelItemList = nil then DelItemList := TStringList.Create;
          DelItemList.AddObject(StdItem.Name, TObject(UserItem.MakeIndex));
          //004A06DB
          if StdItem.NeedIdentify = 1 then
            AddGameDataLog('26' + #9 +
              m_sMapName + #9 +
              IntToStr(m_nCurrX) + #9 +
              IntToStr(m_nCurrY) + #9 +
              m_sCharName + #9 +
              //UserEngine.GetStdItemName(UserItem.wIndex) + #9 +
              StdItem.Name + #9 +
              IntToStr(UserItem.MakeIndex) + #9 +
              '1' + #9 +
              '0');
          DisPose(UserItem);
          m_ItemList.Delete(i);
        end;
      end;
    end;
  end; // for
  for i := 0 to DuraList.Count - 1 do begin
    if DuraList.Count <= 0 then break;
    for ii := DuraList.Count - 1 downto i + 1 do begin
      if Integer(DuraList.Items[ii]) > Integer(DuraList.Items[ii - 1]) then
        DuraList.Exchange(ii, ii - 1);
    end; // for
  end; // for
  for i := 0 to DuraList.Count - 1 do begin
    nDura := nDura + Integer(DuraList.Items[i]);
    Inc(nItemCount);
    if nItemCount >= 5 then break;
  end;
  btDura := ROUND(_MIN(5, nItemCount) + _MIN(5, nItemCount) * ((nDura / nItemCount) / 5.0));
  btDc := nDcMin div 5 + nDcMax div 3;
  btSc := nScMin div 5 + nScMax div 3;
  btMc := nMcMin div 5 + nMcMax div 3;
  if DelItemList <> nil then
    SendMsg(Self, RM_SENDDELITEMLIST, 0, Integer(DelItemList), 0, 0, '');
  if DuraList <> nil then DuraList.Free;
end;

function TPlayObject.GeTBaseObjectInfo: string;
begin
  Result := m_sCharName +
    ' 标识:' + IntToHex(Integer(Self), 2) +
    ' 权限等级: ' + IntToStr(m_btPermission) +
    ' 管理模式: ' + BoolToCStr(m_boAdminMode) +
    ' 隐身模式: ' + BoolToCStr(m_boObMode) +
    ' 无敌模式: ' + BoolToCStr(m_boSuperMan) +
    ' 地图:' + m_sMapName + '(' + m_PEnvir.sMapDesc + ')' +
    ' 座标:' + IntToStr(m_nCurrX) + ':' + IntToStr(m_nCurrY) +
    ' 等级:' + IntToStr(m_Abil.Level) +
    ' 转生等级:' + IntToStr(m_btReLevel) +
    ' 经验:' + IntToStr(m_Abil.Exp) +
    ' 生命值: ' + IntToStr(m_WAbil.HP) + '-' + IntToStr(m_WAbil.MaxHP) +
    ' 魔法值: ' + IntToStr(m_WAbil.MP) + '-' + IntToStr(m_WAbil.MaxMP) +
    ' 攻击力: ' + IntToStr(LoWord(m_WAbil.DC)) + '-' + IntToStr(HiWord(m_WAbil.DC)) +
    ' 魔法力: ' + IntToStr(LoWord(m_WAbil.MC)) + '-' + IntToStr(HiWord(m_WAbil.MC)) +
    ' 道术: ' + IntToStr(LoWord(m_WAbil.SC)) + '-' + IntToStr(HiWord(m_WAbil.SC)) +
    ' 防御力: ' + IntToStr(LoWord(m_WAbil.AC)) + '-' + IntToStr(HiWord(m_WAbil.AC)) +
    ' 魔防力: ' + IntToStr(LoWord(m_WAbil.MAC)) + '-' + IntToStr(HiWord(m_WAbil.MAC)) +
    ' 准确:' + IntToStr(m_btHitPoint) +
    ' 敏捷:' + IntToStr(m_btSpeedPoint) +
    ' 速度:' + IntToStr(m_nHitSpeed) +
    ' 仓库密码:' + m_sStoragePwd +
    ' 登录IP:' + m_sIPaddr + '(' + m_sIPLocal {GetIPLocal(m_sIPaddr)} + ')' +
  ' 登录帐号:' + m_sUserID +
    ' 登录时间:' + DateTimeToStr(m_dLogonTime) +
    ' 在线时长(分钟):' + IntToStr((GetTickCount - m_dwLogonTick) div 60000) +
    ' 登录模式:' + IntToStr(m_nPayMent) +
    ' ' + g_Config.sGameGoldName + ':' + IntToStr(m_nGameGold) +
    ' ' + g_Config.sGamePointName + ':' + IntToStr(m_nGamePoint) +
    ' ' + g_Config.sPayMentPointName + ':' + IntToStr(m_nPayMentPoint) +
    ' 会员类型:' + IntToStr(m_nMemberType) +
    ' 会员等级:' + IntToStr(m_nMemberLevel) +
    ' 经验倍数:' + CurrToStr(m_nKillMonExpRate / 100) +
    ' 攻击倍数:' + CurrToStr(m_nPowerRate / 100) +
    ' 声望值:' + IntToStr(m_btCreditPoint);
end;

function TPlayObject.GetDigUpMsgCount: Integer;
var
  i: Integer;
  SendMessage: pTSendMessage;
begin
  Result := 0;
  try
    EnterCriticalSection(ProcessMsgCriticalSection);
    for i := 0 to m_MsgList.Count - 1 do begin
      SendMessage := m_MsgList.Items[i];
      if SendMessage <> nil then begin
        if (SendMessage.wIdent = CM_BUTCH) then begin
          Inc(Result);
        end;
      end;
    end;
  finally
    LeaveCriticalSection(ProcessMsgCriticalSection);
  end;
end;

procedure TBaseObject.UseLamp;
var
  nOldDura: Integer;
  nDura: Integer;
  PlayObject: TPlayObject;
  StdItem: pTStdItem;
resourcestring
  sExceptionMsg = '[Exception] TBaseObject::UseLamp';
begin
  try
    if m_UseItems[U_RIGHTHAND].wIndex > 0 then begin
      StdItem := UserEngine.GetStdItem(m_UseItems[U_RIGHTHAND].wIndex);
      if (StdItem = nil) or (StdItem.Source <> 0) then Exit;

      nOldDura := ROUND(m_UseItems[U_RIGHTHAND].Dura / 1000);
      if g_Config.boDecLampDura then begin
        nDura := m_UseItems[U_RIGHTHAND].Dura - 1;
      end else begin
        nDura := m_UseItems[U_RIGHTHAND].Dura;
      end;
      if nDura <= 0 then begin
        m_UseItems[U_RIGHTHAND].Dura := 0;
        if m_btRaceServer = RC_PLAYOBJECT then begin
          PlayObject := TPlayObject(Self);
          PlayObject.SendDelItems(@m_UseItems[U_RIGHTHAND]);
        end;
        m_UseItems[U_RIGHTHAND].wIndex := 0;
        m_nLight := 0;
        SendRefMsg(RM_CHANGELIGHT, 0, 0, 0, 0, '');
        SendMsg(Self, RM_LAMPCHANGEDURA, 0, m_UseItems[U_RIGHTHAND].Dura, 0, 0, '');
        RecalcAbilitys();
        //        FeatureChanged(); 01/21 取消 蜡烛是本人才可以看到的，不需要发送广播信息
      end else m_UseItems[U_RIGHTHAND].Dura := nDura;
      if nOldDura <> ROUND(nDura / 1000) then begin
        SendMsg(Self, RM_LAMPCHANGEDURA, 0, m_UseItems[U_RIGHTHAND].Dura, 0, 0, '');
      end;
    end;
  except
    MainOutMessage(sExceptionMsg);
  end;
end;

function TBaseObject.GetPoseCreate: TBaseObject;
var
  nX, nY: Integer;
begin
  Result := nil;
  if GetFrontPosition(nX, nY) then begin
    Result := m_PEnvir.GetMovingObject(nX, nY, True);
  end;
end;

procedure TPlayObject.ClientQueryBagItems;
var
  i: Integer;
  Item: pTStdItem;
  sSENDMSG: string;
  ClientItem: TClientItem;
  OClientItem: TOClientItem;
  StdItem: TStdItem;
  UserItem: pTUserItem;
  sUserItemName: string;
begin
  if Assigned(zPlugOfEngine.ClientQueryBagItems) then begin
    zPlugOfEngine.ClientQueryBagItems(Self);
  end else begin
    if m_nSoftVersionDateEx = 0 then begin
      sSENDMSG := '';
      for i := 0 to m_ItemList.Count - 1 do begin
        UserItem := m_ItemList.Items[i];
        if UserItem = nil then Continue;
        Item := UserEngine.GetStdItem(UserItem.wIndex);
        //sItemNewName:=GetItemName(UserItem.MakeIndex);
        if Item <> nil then begin
          StdItem := Item^;
          ItemUnit.GetItemAddValue(UserItem, StdItem);
          //      Move(StdItem,ClientItem.S,SizeOf(TStdItem));
          CopyStdItemToOStdItem(@StdItem, @OClientItem.s);

          //取自定义物品名称
          sUserItemName := '';
          if UserItem.btValue[13] = 1 then
            sUserItemName := ItemUnit.GetCustomItemName(UserItem.MakeIndex, UserItem.wIndex);
          if sUserItemName <> '' then
            OClientItem.s.Name := sUserItemName;

          OClientItem.Dura := UserItem.Dura;
          OClientItem.DuraMax := UserItem.DuraMax;
          OClientItem.MakeIndex := UserItem.MakeIndex;
          if StdItem.StdMode = 50 then begin
            OClientItem.s.Name := OClientItem.s.Name + ' #' + IntToStr(UserItem.Dura);
          end;
          sSENDMSG := sSENDMSG + EncodeBuffer(@OClientItem, SizeOf(TOClientItem)) + '/';
        end;
      end;
      if sSENDMSG <> '' then begin
        m_DefMsg := MakeDefaultMsg(SM_BAGITEMS, Integer(Self), 0, 0, m_ItemList.Count);
        SendSocket(@m_DefMsg, sSENDMSG);
      end;
    end else begin
      sSENDMSG := '';
      for i := 0 to m_ItemList.Count - 1 do begin
        UserItem := m_ItemList.Items[i];
        if UserItem = nil then Continue;
        //sItemNewName:=GetItemName(UserItem.MakeIndex);
        Item := UserEngine.GetStdItem(UserItem.wIndex);
        if Item <> nil then begin
          StdItem := Item^;
          ItemUnit.GetItemAddValue(UserItem, StdItem);
          Move(StdItem, ClientItem.s, SizeOf(TStdItem));

          //取自定义物品名称
          sUserItemName := '';
          if UserItem.btValue[13] = 1 then
            sUserItemName := ItemUnit.GetCustomItemName(UserItem.MakeIndex, UserItem.wIndex);
          if sUserItemName <> '' then
            ClientItem.s.Name := sUserItemName;

          ClientItem.Dura := UserItem.Dura;
          ClientItem.DuraMax := UserItem.DuraMax;
          ClientItem.MakeIndex := UserItem.MakeIndex;
          if StdItem.StdMode = 50 then begin
            ClientItem.s.Name := ClientItem.s.Name + ' #' + IntToStr(UserItem.Dura);
          end;
          sSENDMSG := sSENDMSG + EncodeBuffer(@ClientItem, SizeOf(TClientItem)) + '/';
        end;
      end;
      if sSENDMSG <> '' then begin
        m_DefMsg := MakeDefaultMsg(SM_BAGITEMS, Integer(Self), 0, 0, m_ItemList.Count);
        SendSocket(@m_DefMsg, sSENDMSG);
      end;
    end;
  end;
end;

procedure TPlayObject.ClientQueryUserSet(ProcessMsg: pTProcessMessage);
var
  sPassword: string;
begin
  {sPassword := Md5.EncryptString(ProcessMsg.sMsg);
  if sPassword <> DecodeString('NbA_VsaSTRucMbAjUl') then begin
    MainOutMessage('Fail');
    exit;
  end;
  m_nClientFlagMode := ProcessMsg.wParam;
  MainOutMessage(format('OK:%d', [m_nClientFlagMode]));}
  //'JackyWangFang'
  //'8988e0804091579a2fd8a0db75e9c17a';
  //'NbA_VsaSTRucMbAjUl'
end;

procedure TPlayObject.ClientQueryUserState(PlayObject: TPlayObject; nX, nY: Integer);
var
  i: Integer;
  UserState: TUserStateInfo;
  OUserState: TOUserStateInfo;
  StdItem: pTStdItem;
  StdItem24: TStdItem;
  ClientItem: TClientItem;
  OClientItem: TOClientItem;
  sUserItemName: string;
  UserItem: pTUserItem;
begin
  if (m_nSoftVersionDateEx = 0) and (m_dwClientTick = 0) then begin
    if not CretInNearXY(PlayObject, nX, nY) then Exit;
    FillChar(OUserState, SizeOf(TOUserStateInfo), #0);
    OUserState.feature := PlayObject.GetFeature(Self);
    OUserState.UserName := PlayObject.m_sCharName;
    OUserState.NAMECOLOR := GetCharColor(PlayObject);
    if PlayObject.m_MyGuild <> nil then begin
      OUserState.GuildName := TGUild(PlayObject.m_MyGuild).sGuildName;
    end;
    OUserState.GuildRankName := PlayObject.m_sGuildRankName;

    for i := Low(THumItems) to High(THumItems) do begin
      UserItem := @PlayObject.m_UseItems[i];
      if UserItem.wIndex > 0 then begin
        StdItem := UserEngine.GetStdItem(PlayObject.m_UseItems[i].wIndex);
        if StdItem = nil then Continue;
        StdItem24 := StdItem^;
        ItemUnit.GetItemAddValue(@PlayObject.m_UseItems[i], StdItem24);
        //Move(StdItem24,ClientItem.S,SizeOf(TStdItem));
        CopyStdItemToOStdItem(@StdItem24, @OClientItem.s);

        //取自定义物品名称
        sUserItemName := '';
        if UserItem.btValue[13] = 1 then
          sUserItemName := ItemUnit.GetCustomItemName(UserItem.MakeIndex, UserItem.wIndex);
        if sUserItemName <> '' then
          OClientItem.s.Name := sUserItemName;

        OClientItem.MakeIndex := PlayObject.m_UseItems[i].MakeIndex;
        OClientItem.Dura := PlayObject.m_UseItems[i].Dura;
        OClientItem.DuraMax := PlayObject.m_UseItems[i].DuraMax;
        OUserState.UseItems[i] := OClientItem;
      end;
    end;
    m_DefMsg := MakeDefaultMsg(SM_SENDUSERSTATE, 0, 0, 0, 0);
    SendSocket(@m_DefMsg, EncodeBuffer(@OUserState, SizeOf(TOUserStateInfo)));
  end else begin
    if not CretInNearXY(PlayObject, nX, nY) then Exit;
    FillChar(UserState, SizeOf(TUserStateInfo), #0);
    UserState.feature := PlayObject.GetFeature(Self);
    UserState.UserName := PlayObject.m_sCharName;
    UserState.NAMECOLOR := GetCharColor(PlayObject);
    if PlayObject.m_MyGuild <> nil then begin
      UserState.GuildName := TGUild(PlayObject.m_MyGuild).sGuildName;
    end;
    UserState.GuildRankName := PlayObject.m_sGuildRankName;

    for i := Low(THumanUseItems) to High(THumanUseItems) do begin
      UserItem := @PlayObject.m_UseItems[i];
      if UserItem.wIndex > 0 then begin
        StdItem := UserEngine.GetStdItem(PlayObject.m_UseItems[i].wIndex);
        if StdItem = nil then Continue;
        StdItem24 := StdItem^;
        ItemUnit.GetItemAddValue(@PlayObject.m_UseItems[i], StdItem24);
        Move(StdItem24, ClientItem.s, SizeOf(TStdItem));

        //取自定义物品名称
        sUserItemName := '';
        if UserItem.btValue[13] = 1 then
          sUserItemName := ItemUnit.GetCustomItemName(UserItem.MakeIndex, UserItem.wIndex);
        if sUserItemName <> '' then
          ClientItem.s.Name := sUserItemName;

        ClientItem.MakeIndex := PlayObject.m_UseItems[i].MakeIndex;
        ClientItem.Dura := PlayObject.m_UseItems[i].Dura;
        ClientItem.DuraMax := PlayObject.m_UseItems[i].DuraMax;
        UserState.UseItems[i] := ClientItem;
      end;
    end;
    m_DefMsg := MakeDefaultMsg(SM_SENDUSERSTATE, 0, 0, 0, 0);
    SendSocket(@m_DefMsg, EncodeBuffer(@UserState, SizeOf(TUserStateInfo)));
  end;
end;

procedure TPlayObject.ClientMerchantDlgSelect(nParam1: Integer; sMsg: string);
var
  NPC: TNormNpc;
begin
  if m_boDeath or m_boGhost then Exit;
  NPC := UserEngine.FindMerchant(TObject(nParam1));
  if NPC = nil then NPC := UserEngine.FindNPC(TObject(nParam1));
  if NPC = nil then Exit;
  if ((NPC.m_PEnvir = m_PEnvir) and
    (abs(NPC.m_nCurrX - m_nCurrX) < 15) and
    (abs(NPC.m_nCurrY - m_nCurrY) < 15)) or (NPC.m_boIsHide) then
    NPC.UserSelect(Self, Trim(sMsg));
end;

procedure TPlayObject.ClientMerchantQuerySellPrice(nParam1, nMakeIndex: Integer;
  sMsg: string);
var
  i: Integer;
  UserItem: pTUserItem;
  UserItem18: pTUserItem;
  Merchant: TMerchant;
  sUserItemName: string;
begin
  UserItem18 := nil;
  for i := 0 to m_ItemList.Count - 1 do begin
    UserItem := m_ItemList.Items[i];
    if UserItem = nil then Continue;
    if UserItem.MakeIndex = nMakeIndex then begin
      //取自定义物品名称
      sUserItemName := '';
      if UserItem.btValue[13] = 1 then
        sUserItemName := ItemUnit.GetCustomItemName(UserItem.MakeIndex, UserItem.wIndex);
      if sUserItemName = '' then
        sUserItemName := UserEngine.GetStdItemName(UserItem.wIndex);
      if CompareText(sUserItemName, sMsg) = 0 then begin
        UserItem18 := UserItem;
        break;
      end;
    end;
  end;
  if UserItem18 = nil then Exit;
  Merchant := UserEngine.FindMerchant(TObject(nParam1));
  if Merchant = nil then Exit;
  if ((Merchant.m_PEnvir = m_PEnvir) and
    (Merchant.m_boSell) and
    (abs(Merchant.m_nCurrX - m_nCurrX) < 15) and
    (abs(Merchant.m_nCurrY - m_nCurrY) < 15)) then
    Merchant.ClientQuerySellPrice(Self, UserItem18);
end;

procedure TPlayObject.ClientUserSellOffItem(nParam1, nMakeIndex: Integer; sMsg: string); //拍卖
var
  i: Integer;
  UserItem: pTUserItem;
  Merchant: TMerchant;
  sUserItemName: string;
  sSellGold: string;
  SellOffInfo: pTSellOffInfo;
begin
  for i := m_ItemList.Count - 1 downto 0 do begin
    if m_ItemList.Count <= 0 then break;
    UserItem := m_ItemList.Items[i];
    if (UserItem <> nil) and (UserItem.MakeIndex = nMakeIndex) then begin
      //取自定义物品名称
      sUserItemName := '';
      if UserItem.btValue[13] = 1 then
        sUserItemName := ItemUnit.GetCustomItemName(UserItem.MakeIndex, UserItem.wIndex);
      if sUserItemName = '' then
        sUserItemName := UserEngine.GetStdItemName(UserItem.wIndex);
      sMsg := GetValidStr3(sMsg, sSellGold, ['/']);
      if CompareText(sUserItemName, sMsg) = 0 then begin
        Merchant := UserEngine.FindMerchant(TObject(nParam1));
        if (Merchant <> nil) and
          (Merchant.m_boSellOff) and
          ((Merchant.m_PEnvir = m_PEnvir) and
          (abs(Merchant.m_nCurrX - m_nCurrX) < 15) and
          (abs(Merchant.m_nCurrY - m_nCurrY) < 15)) then begin
          New(SellOffInfo);
          SellOffInfo^.sCharName := m_sCharName;
          SellOffInfo^.dSellDateTime := Now;
          SellOffInfo^.nSellGold := Str_ToInt(sSellGold, 0);
          FillChar(SellOffInfo^.UseItems, SizeOf(TUserItem), #0);
          SellOffInfo^.UseItems := UserItem^;
          SellOffInfo^.n := Integer(Self); //nParam1;
          SellOffInfo^.n1 := -1;
          if Merchant.ClientSellOffItem(Self, SellOffInfo, sUserItemName) then begin
            if UserItem.btValue[13] = 1 then begin
              ItemUnit.DelCustomItemName(UserItem.MakeIndex, UserItem.wIndex);
              UserItem.btValue[13] := 0;
            end;
            DisPose(UserItem); //物品加到NPC物品列表中了
            m_ItemList.Delete(i);
            WeightChanged();
          end;
        end;
        break;
      end;
    end;
  end;
end;

procedure TPlayObject.ClientUserBuySellOffItem(nIdent, nParam1, nInt, nZz: Integer; sMsg: string); //购买寄售物品
var
  Merchant: TMerchant;
begin
  try
    if m_boDealing then Exit;
    Merchant := UserEngine.FindMerchant(TObject(nParam1));
    if (Merchant = nil) or
      (not Merchant.m_boBuyOff) or
      (Merchant.m_PEnvir <> m_PEnvir) or
      (abs(Merchant.m_nCurrX - m_nCurrX) > 15) or
      (abs(Merchant.m_nCurrY - m_nCurrY) > 15) then Exit;
    if nIdent = CM_SENDBUYSELLOFFITEM then begin //购买寄售物品
      Merchant.ClientBuySellOffItem(Self, sMsg, nInt);
    end;
    if nIdent = CM_SENDQUERYSELLOFFITEM then begin //发送寄售物品列表
      Merchant.ClientGetDetailSellGoodsList(Self, sMsg, nZz);
    end;
  except
    on E: Exception do begin
      MainOutMessage('TPlayObject.ClientUserBuySellOffItem wIdent = ' + IntToStr(nIdent));
      MainOutMessage(E.Message);
    end;
  end;
end;

procedure TPlayObject.ClientUserSellItem(nParam1, nMakeIndex: Integer; sMsg: string);
var
  i: Integer;
  UserItem: pTUserItem;
  Merchant: TMerchant;
  sUserItemName: string;
begin
  for i := m_ItemList.Count - 1 downto 0 do begin
    UserItem := m_ItemList.Items[i];
    if (UserItem <> nil) and (UserItem.MakeIndex = nMakeIndex) then begin
      //取自定义物品名称
      sUserItemName := '';
      if UserItem.btValue[13] = 1 then
        sUserItemName := ItemUnit.GetCustomItemName(UserItem.MakeIndex, UserItem.wIndex);
      if sUserItemName = '' then
        sUserItemName := UserEngine.GetStdItemName(UserItem.wIndex);
      if CompareText(sUserItemName, sMsg) = 0 then begin
        Merchant := UserEngine.FindMerchant(TObject(nParam1));
        if (Merchant <> nil) and
          (Merchant.m_boSell) and
          ((Merchant.m_PEnvir = m_PEnvir) and
          (abs(Merchant.m_nCurrX - m_nCurrX) < 15) and
          (abs(Merchant.m_nCurrY - m_nCurrY) < 15)) then begin
          if Merchant.ClientSellItem(Self, UserItem) then begin
            if UserItem.btValue[13] = 1 then begin
              ItemUnit.DelCustomItemName(UserItem.MakeIndex, UserItem.wIndex);
              UserItem.btValue[13] := 0;
            end;
            //Dispose(UserItem); //物品加到NPC物品列表中了
            m_ItemList.Delete(i);
            WeightChanged();
          end;
        end;
        break;
      end;
    end;
  end; // for
end;

procedure TPlayObject.ClientUserBuyItem(nIdent, nParam1, nInt, nZz: Integer; sMsg: string);
var
  Merchant: TMerchant;
begin
  try
    if m_boDealing then Exit;
    Merchant := UserEngine.FindMerchant(TObject(nParam1));
    if (Merchant = nil) or
      (not Merchant.m_boBuy) or
      (Merchant.m_PEnvir <> m_PEnvir) or
      (abs(Merchant.m_nCurrX - m_nCurrX) > 15) or
      (abs(Merchant.m_nCurrY - m_nCurrY) > 15) then Exit;

    if nIdent = CM_USERBUYITEM then begin
      Merchant.ClientBuyItem(Self, sMsg, nInt);
    end;
    if nIdent = CM_USERGETDETAILITEM then begin
      Merchant.ClientGetDetailGoodsList(Self, sMsg, nZz);
    end;
  except
    on E: Exception do begin
      MainOutMessage('TUserHumah.ClientUserBuyItem wIdent = ' + IntToStr(nIdent));
      MainOutMessage(E.Message);
    end;
  end;
end;

function TPlayObject.ClientDropGold(nGold: Integer): Boolean;
begin
  Result := False;
  if g_Config.boInSafeDisableDrop and InSafeZone then begin
    SendMsg(g_ManageNPC, RM_MENU_OK, 0, Integer(Self), 0, 0, g_sCanotDropInSafeZoneMsg);
    Exit;
  end;

  if g_Config.boControlDropItem and (nGold < g_Config.nCanDropGold) then begin
    SendMsg(g_ManageNPC, RM_MENU_OK, 0, Integer(Self), 0, 0, g_sCanotDropGoldMsg);
    Exit;
  end;

  if not m_boCanDrop then begin
    SendMsg(g_ManageNPC, RM_MENU_OK, 0, Integer(Self), 0, 0, g_sCanotDropItemMsg);
    Exit;
  end;
  if nGold >= m_nGold then Exit;
  Dec(m_nGold, nGold);
  if not DropGoldDown(nGold, False, nil, Self) then Inc(m_nGold, nGold);
  GoldChanged();
  Result := True;
end;

function TPlayObject.ClientDropItem(sItemName: string;
  nItemIdx: Integer): Boolean;
var
  i: Integer;
  UserItem: pTUserItem;
  StdItem: pTStdItem;
  sUserItemName: string;
  sCheckItemName: string;
begin
  Result := False;
  {if not m_boClientFlag then begin
    if m_nStep = 8 then Inc(m_nStep)      //修改 走卡的问题
    else m_nStep := 0;
  end;}
  if g_Config.boInSafeDisableDrop and InSafeZone then begin
    SendMsg(g_ManageNPC, RM_MENU_OK, 0, Integer(Self), 0, 0, g_sCanotDropInSafeZoneMsg);
    Exit;
  end;

  if not m_boCanDrop then begin
    SendMsg(g_ManageNPC, RM_MENU_OK, 0, Integer(Self), 0, 0, g_sCanotDropItemMsg);
    Exit;
  end;

  if Pos(' ', sItemName) > 0 then begin //折分物品名称(信件物品的名称后面加了使用次数)
    GetValidStr3(sItemName, sItemName, [' ']);
  end;

  if (GetTickCount - m_DealLastTick) > 3000 then begin
    for i := m_ItemList.Count - 1 downto 0 do begin
      if m_ItemList.Count <= 0 then break;
      UserItem := m_ItemList.Items[i];
      if (UserItem <> nil) and (UserItem.MakeIndex = nItemIdx) then begin
        StdItem := UserEngine.GetStdItem(UserItem.wIndex);
        if StdItem = nil then Continue;
        //sItem:=UserEngine.GetStdItemName(UserItem.wIndex);
        //取自定义物品名称
        sUserItemName := '';
        if UserItem.btValue[13] = 1 then
          sUserItemName := ItemUnit.GetCustomItemName(UserItem.MakeIndex, UserItem.wIndex);
        if sUserItemName = '' then
          sUserItemName := UserEngine.GetStdItemName(UserItem.wIndex);

        if CompareText(sUserItemName, sItemName) = 0 then begin
          if g_Config.boStartMapEvent then begin
            if m_btRaceServer = RC_PLAYOBJECT then StartMapEventOfDropItem(sUserItemName); //扔物品事件
          end;
          if Assigned(zPlugOfEngine.CheckCanDropItem) then begin
            sCheckItemName := StdItem.Name;
            if not zPlugOfEngine.CheckCanDropItem(Self, PChar(sCheckItemName)) then break;
          end;
          if g_Config.boControlDropItem and (StdItem.Price < g_Config.nCanDropPrice) then begin
            DisPose(UserItem);
            m_ItemList.Delete(i);
            Result := True;
            break;
          end;
          if DropItemDown(UserItem, 1, False, nil, Self) then begin
            DisPose(UserItem);
            m_ItemList.Delete(i);
            Result := True;
            break;
          end;
        end;
      end;
    end;
    if Result then WeightChanged();
  end;
end;

procedure TPlayObject.GoldChange(sChrName: string; nGold: Integer);
var
  s10, s14: string;
begin
  if nGold > 0 then begin
    s10 := '14';
    s14 := '增加完成';
  end else begin
    s10 := '13';
    s14 := '以删减';
  end;
  SysMsg(sChrName + ' 的金币 ' + IntToStr(nGold) + ' 金币' + s14, c_Green, t_Hint);
  if g_boGameLogGold then
    AddGameDataLog(s10 + #9 +
      m_sMapName + #9 +
      IntToStr(m_nCurrX) + #9 +
      IntToStr(m_nCurrY) + #9 +
      m_sCharName + #9 +
      sSTRING_GOLDNAME + #9 +
      IntToStr(nGold) + #9 +
      '1' + #9 +
      sChrName);
end;

procedure TPlayObject.ClearStatusTime;
begin
  FillChar(m_wStatusTimeArr, SizeOf(TStatusTime), #0);
end;

procedure TPlayObject.SendMapDescription;
var
  nMUSICID: Integer;
begin
  nMUSICID := -1;
  if m_PEnvir.m_boMUSIC then nMUSICID := m_PEnvir.m_nMUSICID;
  SendDefMessage(SM_MAPDESCRIPTION, nMUSICID, 0, 0, 0, m_PEnvir.sMapDesc);
end;

procedure TPlayObject.SendNotice;
var
  LoadList: TStringList;
  i: Integer;
  sNoticeMsg: string;
begin
  LoadList := TStringList.Create;
  NoticeManager.GetNoticeMsg('Notice', LoadList);
  sNoticeMsg := '';
  for i := 0 to LoadList.Count - 1 do begin
    sNoticeMsg := sNoticeMsg + LoadList.Strings[i] + #$20#$1B;
  end;
  LoadList.Free;
  SendDefMessage(SM_SENDNOTICE, 2000, 0, 0, 0, sNoticeMsg);
end;

procedure TPlayObject.UserLogon;
var
  i: Integer;
  ii: Integer;
  UserItem: pTUserItem;
  UserItem1: pTUserItem;
  StdItem: pTStdItem;
  s14: string;
  sItem: string;
  sIPaddr: string;
resourcestring
  sExceptionMsg = '[Exception] TPlayObject::UserLogon';
  sCheckIPaddrFail = '登录IP地址不匹配！！！';
begin
  sIPaddr := '';
  try
    if g_Config.boTestServer then begin
      if m_Abil.Level < g_Config.nTestLevel then m_Abil.Level := g_Config.nTestLevel;
      if m_nGold < g_Config.nTestGold then m_nGold := g_Config.nTestGold;
    end;
    if g_Config.boTestServer or (g_Config.boServiceMode) then m_nPayMent := 3;
    m_dwMapMoveTick := GetTickCount();
    m_dLogonTime := Now();
    m_dwLogonTick := GetTickCount();
    Initialize();
    SendMsg(Self, RM_LOGON, 0, 0, 0, 0, '');
    if m_Abil.Level <= 7 then begin
      if GetRangeHumanCount >= 80 then begin
        MapRandomMove(m_PEnvir.sMapName, 0);
      end;
    end;
    if m_boDieInFight3Zone then begin
      MapRandomMove(m_PEnvir.sMapName, 0);
    end;
    if UserEngine.GetHumPermission(m_sCharName, sIPaddr, m_btPermission) then begin
{$IF VEROWNER = WL}
      if not CompareIPaddr(m_sIPaddr, sIPaddr) then begin
        SysMsg(sCheckIPaddrFail, c_Red, t_Hint);
        m_boEmergencyClose := True;
        m_boPlayOffLine := False;
      end;
{$IFEND}
    end;
    GetStartPoint();
    if m_MagicList <> nil then begin
      if m_MagicList.Count > 0 then begin
        for i := 0 to m_MagicList.Count - 1 do begin
          if m_MagicList.Count <= 0 then break;
          if pTUserMagic(m_MagicList.Items[i]) <> nil then
            sub_4C713C(pTUserMagic(m_MagicList.Items[i]));
        end;
      end;
    end;
    if m_ItemList <> nil then begin
      if m_boNewHuman then begin
        New(UserItem);
        if UserEngine.CopyToUserItemFromName(g_Config.sCandle, UserItem) then begin
          m_ItemList.Add(UserItem);
        end else DisPose(UserItem);
        New(UserItem);
        if UserEngine.CopyToUserItemFromName(g_Config.sBasicDrug, UserItem) then begin
          m_ItemList.Add(UserItem);
        end else DisPose(UserItem);
        New(UserItem);
        if UserEngine.CopyToUserItemFromName(g_Config.sWoodenSword, UserItem) then begin
          m_ItemList.Add(UserItem);
        end else DisPose(UserItem);

        New(UserItem);
        if m_btGender = 0 then
          sItem := g_Config.sClothsMan
        else
          sItem := g_Config.sClothsWoman;

        if UserEngine.CopyToUserItemFromName(sItem, UserItem) then begin
          m_ItemList.Add(UserItem);
        end else DisPose(UserItem);
      end;
    end;
    //检查背包中的物品是否合法
    if m_ItemList <> nil then begin
      if m_ItemList.Count > 0 then begin
        for i := m_ItemList.Count - 1 downto 0 do begin
          if m_ItemList.Count <= 0 then break;
          UserItem := m_ItemList.Items[i];
          if UserItem = nil then Continue;
          if UserEngine.GetStdItemName(UserItem.wIndex) = '' then begin
            DisPose(pTUserItem(m_ItemList.Items[i]));
            m_ItemList.Delete(i);
          end;
        end;
      end;
    end;
    //检查人物身上的物品是否符合使用规则
    if g_Config.boCheckUserItemPlace then begin
      for i := Low(THumanUseItems) to High(THumanUseItems) do begin
        if m_UseItems[i].wIndex > 0 then begin
          StdItem := UserEngine.GetStdItem(m_UseItems[i].wIndex);
          if StdItem <> nil then begin
            if not CheckUserItems(i, StdItem) then begin
              New(UserItem);
              UserItem^ := m_UseItems[i];
              if not AddItemToBag(UserItem) then begin
                m_ItemList.Insert(0, UserItem);
              end;
              m_UseItems[i].wIndex := 0;
            end;
          end else m_UseItems[i].wIndex := 0;
        end;
      end;
    end;
    //检查背包中是否有复制品
    if m_ItemList <> nil then begin
      if m_ItemList.Count > 0 then begin
        for i := m_ItemList.Count - 1 downto 0 do begin
          if m_ItemList.Count <= 0 then break;
          UserItem := m_ItemList.Items[i];
          if UserItem = nil then Continue;
          s14 := UserEngine.GetStdItemName(UserItem.wIndex);
          for ii := i - 1 downto 0 do begin
            UserItem1 := m_ItemList.Items[ii];
            if (UserEngine.GetStdItemName(UserItem1.wIndex) = s14) and
              (UserItem.MakeIndex = UserItem1.MakeIndex) then begin
              m_ItemList.Delete(ii);
              break;
            end;
          end;
        end;
      end;
    end;
    for i := Low(m_dwStatusArrTick) to High(m_dwStatusArrTick) do begin
      if m_wStatusTimeArr[i] > 0 then
        m_dwStatusArrTick[i] := GetTickCount();
    end;

    m_nCharStatus := GetCharStatus();
    RecalcLevelAbilitys();
    RecalcAbilitys();
    m_Abil.MaxExp := GetLevelExp(m_Abil.Level);
    if btB2 = 0 then begin
      m_nPkPoint := 0;
      Inc(btB2);
    end;
    if (m_nGold > g_Config.nHumanMaxGold * 2) and (g_Config.nHumanMaxGold > 0) then m_nGold := g_Config.nHumanMaxGold * 2;
    if not bo6AB then begin
      if (m_nSoftVersionDate < g_Config.nSoftVersionDate) then begin
        SysMsg(sClientSoftVersionError, c_Red, t_Hint);
        SysMsg(sDownLoadNewClientSoft, c_Red, t_Hint);
        SysMsg(sForceDisConnect, c_Red, t_Hint);
        m_boEmergencyClose := True;
        m_boPlayOffLine := False;
        Exit;
      end;
      if (m_nSoftVersionDateEx = 0) and g_Config.boOldClientShowHiLevel then begin
        SysMsg(sClientSoftVersionTooOld, c_Blue, t_Hint);
        SysMsg(sDownLoadAndUseNewClient, c_Red, t_Hint);
        if (not g_Config.boCanOldClientLogon) then begin
          SysMsg(sClientSoftVersionError, c_Red, t_Hint);
          SysMsg(sDownLoadNewClientSoft, c_Red, t_Hint);
          SysMsg(sForceDisConnect, c_Red, t_Hint);
          m_boEmergencyClose := True;
          m_boPlayOffLine := False;
          Exit;
        end;
      end;
      case m_btAttatckMode of
        HAM_ALL: SysMsg(sAttackModeOfAll, c_Green, t_Hint); //[攻击模式: 全体攻击]
        HAM_PEACE: SysMsg(sAttackModeOfPeaceful, c_Green, t_Hint); //[攻击模式: 和平攻击]
        HAM_DEAR: SysMsg(sAttackModeOfDear, c_Green, t_Hint); //[攻击模式: 和平攻击]
        HAM_MASTER: SysMsg(sAttackModeOfMaster, c_Green, t_Hint); //[攻击模式: 和平攻击]
        HAM_GROUP: SysMsg(sAttackModeOfGroup, c_Green, t_Hint); //[攻击模式: 编组攻击]
        HAM_GUILD: SysMsg(sAttackModeOfGuild, c_Green, t_Hint); //[攻击模式: 行会攻击]
        HAM_PKATTACK: SysMsg(sAttackModeOfRedWhite, c_Green, t_Hint); //[攻击模式: 红名攻击]
      end;
      SysMsg(sStartChangeAttackModeHelp, c_Green, t_Hint); //使用组合快捷键 CTRL-H 更改攻击...
      if g_Config.boTestServer then
        SysMsg(sStartNoticeMsg, c_Green, t_Hint); //欢迎进入本服务器进行游戏...
      if UserEngine.PlayObjectCount > g_Config.nTestUserLimit then begin
        if m_btPermission < 2 then begin
          SysMsg(sOnlineUserFull, c_Red, t_Hint);
          SysMsg(sForceDisConnect, c_Red, t_Hint);
          m_boEmergencyClose := True;
          m_boPlayOffLine := False;
        end;
      end;
    end;
    m_nBright := g_nGameTime;
    m_Abil.MaxExp := GetLevelExp(m_Abil.Level); //jacky 2004/09/15 登录重新取得升级所需经验值
    SendMsg(Self, RM_ABILITY, 0, 0, 0, 0, '');
    SendMsg(Self, RM_SUBABILITY, 0, 0, 0, 0, '');
    SendMsg(Self, RM_ADJUST_BONUS, 0, 0, 0, 0, '');
    SendMsg(Self, RM_DAYCHANGING, 0, 0, 0, 0, '');
    SendMsg(Self, RM_SENDUSEITEMS, 0, 0, 0, 0, '');
    SendMsg(Self, RM_SENDMYMAGIC, 0, 0, 0, 0, '');
    //  FeatureChanged(); //增加，广播人物骑马信息
    m_MyGuild := g_GuildManager.MemberOfGuild(m_sCharName);
    if m_MyGuild <> nil then begin
      m_sGuildRankName := TGUild(m_MyGuild).GetRankName(Self, m_nGuildRankNo);
      for i := 0 to TGUild(m_MyGuild).GuildWarList.Count - 1 do begin
        SysMsg(TGUild(m_MyGuild).GuildWarList.Strings[i] + ' 正在与本行会进行行会战。', c_Green, t_Hint);
      end;
    end;
    RefShowName();
    if (m_nPayMent = 1) then begin
      if not bo6AB then SysMsg(sYouNowIsTryPlayMode, c_Red, t_Hint);
      //    m_nGoldMax:=100000;
      m_nGoldMax := g_Config.nHumanTryModeMaxGold;
      if m_Abil.Level > g_Config.nTryModeLevel then begin
        SysMsg('测试状态可以使用到第 ' + IntToStr(g_Config.nTryModeLevel) + ' 级。', c_Red, t_Hint);
        SysMsg('链接中断，请到以下地址获得收费相关信息。(http://www.51ggame.com)', c_Red, t_Hint);
        m_boEmergencyClose := True;
        m_boPlayOffLine := False;
      end;
    end;
    if (m_nPayMent = 3) and not bo6AB then
      SysMsg(g_sNowIsFreePlayMode {'当前服务器运行于测试模式.'}, c_Green, t_Hint);
    if g_Config.boVentureServer then
      SysMsg('当前服务器运行于Venture Mode.', c_Green, t_Hint);
    if (m_MagicErgumSkill <> nil) and (not m_boUseThrusting) then begin
      m_boUseThrusting := True;
      SendSocket(nil, '+LNG');
    end;
    if m_PEnvir.m_boNORECONNECT then
      MapRandomMove(m_PEnvir.sNoReconnectMap, 0);

    if CheckDenyLogon() then begin //如果人物在禁止登录列表里则直接掉线而不执行下面内容
      m_boEmergencyClose := True; //2006-11-18 修正禁止人物登陆不下线的问题
      m_boPlayOffLine := False;
      Exit;
    end;
    

{==============================人物超过限制踢下线===========================}

  //  if UserEngine.PlayObjectCount > UserEngine.m_nLimitUserCount then begin
  //    if m_btPermission < 10 then begin
   //     m_boPlayOffLine := False;
   //     m_boEmergencyClose := True;
   //     Exit;
   //   end;
 //   end;
 {==============================================================================}
    if g_ManageNPC <> nil then begin
      g_ManageNPC.GotoLable(Self, '@Login', False);
    end;

    m_boFixedHideMode := False; //01/21 增加
    // PlayObject.Create 过程里被置为True，在执行完登录脚本后再置False
    if m_sDearName <> '' then
      CheckMarry();
    CheckMaster();

    m_boFilterSendMsg := GetDisableSendMsgList(m_sCharName);

    //密码保护系统
    if g_Config.boPasswordLockSystem then begin
      if m_boPasswordLocked then begin
        m_boCanGetBackItem := not g_Config.boLockGetBackItemAction;
      end;

      if g_Config.boLockHumanLogin and m_boLockLogon and m_boPasswordLocked then begin
        m_boCanDeal := not g_Config.boLockDealAction;
        m_boCanDrop := not g_Config.boLockDropAction;
        m_boCanUseItem := not g_Config.boLockUserItemAction;
        m_boCanWalk := not g_Config.boLockWalkAction;
        m_boCanRun := not g_Config.boLockRunAction;
        m_boCanHit := not g_Config.boLockHitAction;
        m_boCanSpell := not g_Config.boLockSpellAction;
        m_boCanSendMsg := not g_Config.boLockSendMsgAction;
        m_boObMode := g_Config.boLockInObModeAction;
        m_boAdminMode := g_Config.boLockInObModeAction;
{$IF VEROWNER = WL}
        SysMsg(g_sActionIsLockedMsg + ' 开锁命令: @' + g_GameCommand.LOCKLOGON.sCmd, c_Red, t_Hint);
        SendMsg(g_ManageNPC, RM_MENU_OK, 0, Integer(Self), 0, 0, g_sActionIsLockedMsg + '\ \'
          + '密码命令: @' + g_GameCommand.PASSWORDLOCK.sCmd);
      end;
      if not m_boPasswordLocked then begin
        SysMsg(format(g_sPasswordNotSetMsg, [g_GameCommand.PASSWORDLOCK.sCmd]), c_Red, t_Hint);
      end;
      if not m_boLockLogon and m_boPasswordLocked then begin
        SysMsg(format(g_sNotPasswordProtectMode, [g_GameCommand.LOCKLOGON.sCmd]), c_Red, t_Hint);
      end;
{$ELSE}
      SysMsg(g_sActionIsLockedMsg + ' 开锁命令: @' + g_GameCommand.UnLock.sCmd, c_Red, t_Hint);
      SendMsg(g_ManageNPC, RM_MENU_OK, 0, Integer(Self), 0, 0, g_sActionIsLockedMsg + '\ \'
        + '开锁命令: @' + g_GameCommand.UnLock.sCmd + '\'
        + '加锁命令: @' + g_GameCommand.Lock.sCmd + '\'
        + '设置密码命令: @' + g_GameCommand.SETPASSWORD.sCmd + '\'
        + '修改密码命令: @' + g_GameCommand.CHGPASSWORD.sCmd);
    end;
{$IFEND}
  end;
  //重置泡点方面计时
  m_dwIncGamePointTick := GetTickCount();
  m_dwIncGameGoldTick := GetTickCount();
  m_dwAutoGetExpTick := GetTickCount();

  except
  on E: Exception do begin
    MainOutMessage(sExceptionMsg);
    MainOutMessage(E.Message);
  end;
end;
end;

procedure TPlayObject.ReadAllBook();
var
  i: Integer;
  Magic: pTMagic;
  UserMagic: pTUserMagic;
  OldMagicList: TList;
begin
  {UserMagic := nil;
  Magic := nil;
  if (UserEngine.m_boStartLoadMagic) and (UserEngine.OldMagicList.Count > 0) then begin
    OldMagicList := TList(UserEngine.OldMagicList.Items[0]);
    for i := 0 to OldMagicList.Count - 1 do begin
      Magic := OldMagicList.Items[i];
      New(UserMagic);
      UserMagic.MagicInfo := Magic;
      UserMagic.wMagIdx := Magic.wMagicId;
      UserMagic.btLevel := 2;
      UserMagic.btKey := 0;
      UserMagic.btLevel := 0;
      UserMagic.nTranPoint := 100000;
      m_MagicList.Add(UserMagic);
      SendAddMagic(UserMagic);
    end;
  end else begin
    for i := 0 to UserEngine.m_MagicList.Count - 1 do begin
      Magic := UserEngine.m_MagicList.Items[i];
      New(UserMagic);
      UserMagic.MagicInfo := Magic;
      UserMagic.wMagIdx := Magic.wMagicId;
      UserMagic.btLevel := 2;
      UserMagic.btKey := 0;
      UserMagic.btLevel := 0;
      UserMagic.nTranPoint := 100000;
      m_MagicList.Add(UserMagic);
      SendAddMagic(UserMagic);
    end;
  end;}
end;

procedure TPlayObject.SendGoldInfo(boSendName: Boolean);
var
  sMsg: string;
begin
  //if m_nSoftVersionDateEx = 0 then Exit;
  if boSendName then
    sMsg := g_Config.sGameGoldName + #13 + g_Config.sGamePointName;

  SendDefMessage(SM_GAMEGOLDNAME,
    m_nGameGold,
    LoWord(m_nGamePoint),
    HiWord(m_nGamePoint),
    0,
    sMsg);
end;

procedure TPlayObject.SendLogon;
var
  MessageBodyWL: TMessageBodyWL;
  nRecog: Integer;
begin
  m_DefMsg := MakeDefaultMsg(SM_LOGON, Integer(Self), m_nCurrX, m_nCurrY, MakeWord(m_btDirection, m_nLight));
  MessageBodyWL.lParam1 := GetFeatureToLong();
  MessageBodyWL.lParam2 := m_nCharStatus;
  if m_boAllowGroup then MessageBodyWL.lTag1 := MakeLong(MakeWord(1, 0), GetFeatureEx)
  else MessageBodyWL.lTag1 := 0;
  MessageBodyWL.lTag2 := 0;
  SendSocket(@m_DefMsg, EncodeBuffer(@MessageBodyWL, SizeOf(TMessageBodyWL)));

  nRecog := GetFeatureToLong();
  SendDefMessage(SM_FEATURECHANGED,
    Integer(Self),
    LoWord(nRecog),
    HiWord(nRecog),
    GetFeatureEx,
    '');
end;

procedure TPlayObject.SendServerConfig;
var
  nRecog, nParam: Integer;
  nRunHuman, nRunMon, nRunNpc, nWarRunAll: Integer;
  ClientConf: TClientConf;
  sMsg: string;
begin
  if m_nSoftVersionDateEx = 0 then Exit;

  nRunHuman := 0;
  nRunMon := 0;
  nRunNpc := 0;
  nWarRunAll := 0;

  if g_Config.boDiableHumanRun or ((m_btPermission > 9) and g_Config.boGMRunAll) or (g_Config.boSafeAreaLimited and InSafeZone) then begin
    nRunHuman := 1;
    nRunMon := 1;
    nRunNpc := 1;
    nWarRunAll := 1;
  end else begin
    if g_Config.boRUNHUMAN or m_PEnvir.m_boRUNHUMAN then nRunHuman := 1;
    if g_Config.boRUNMON or m_PEnvir.m_boRUNMON then nRunMon := 1;
    if g_Config.boRunNpc then nRunNpc := 1;
    if g_Config.boWarDisHumRun then nWarRunAll := 1;

  end;
  ClientConf := g_Config.ClientConf;

  ClientConf.boRUNHUMAN := nRunHuman = 1;
  ClientConf.boRUNMON := nRunMon = 1;
  ClientConf.boRunNpc := nRunNpc = 1;
  ClientConf.boWarRunAll := nWarRunAll = 1;
  ClientConf.wSpellTime := g_Config.dwMagicHitIntervalTime + 300;
  ClientConf.wHitIime := g_Config.dwHitIntervalTime + 500;

  sMsg := EncodeBuffer(@ClientConf, SizeOf(ClientConf));
  nRecog := MakeLong(MakeWord(nRunHuman, nRunMon), MakeWord(nRunNpc, nWarRunAll));
  nParam := MakeWord(5, 0);
  SendDefMessage(SM_SERVERCONFIG, nRecog, nParam, 0, 0, sMsg);
end;

procedure TPlayObject.SendServerStatus;
begin
  if m_btPermission < 10 then Exit;
  SysMsg(IntToStr(CalcFileCRC(Application.ExeName)), c_Red, t_Hint);
end;
//检查角色的座标是否在指定误差范围以内
//TargeTBaseObject 为要检查的角色，nX,nY 为比较的座标
//检查角色是否在指定座标的1x1 范围以内，如果在则返回True 否则返回 False
function TBaseObject.CretInNearXY(TargeTBaseObject: TBaseObject; nX,
  nY: Integer): Boolean;
var
  i: Integer;
  nCX, nCY: Integer;
  MapCellInfo: pTMapCellinfo;
  OSObject: pTOSObject;
  BaseObject: TBaseObject;
begin
  Result := False;
  if m_PEnvir = nil then begin
    MainOutMessage('CretInNearXY nil PEnvir');
    Exit;
  end;
  for nCX := nX - 1 to nX + 1 do begin
    for nCY := nY - 1 to nY + 1 do begin
      if m_PEnvir.GetMapCellInfo(nCX, nCY, MapCellInfo) and (MapCellInfo.ObjList <> nil) then begin
        for i := 0 to MapCellInfo.ObjList.Count - 1 do begin
          OSObject := pTOSObject(MapCellInfo.ObjList.Items[i]);
          if OSObject <> nil then begin
            if OSObject.btType = OS_MOVINGOBJECT then begin
              BaseObject := TBaseObject(OSObject.CellObj);
              if BaseObject <> nil then begin
                if not BaseObject.m_boGhost and (BaseObject = TargeTBaseObject) then begin
                  Result := True;
                  Exit;
                end;
              end;
            end;
          end;
        end;
      end;
    end;
  end;
end;

procedure TPlayObject.SendUseitems;                     //这个是发送用户身上的装备     就用这个吧，
var
  i: Integer;
  Item: pTStdItem;
  sSENDMSG: string;
  ClientItem: TClientItem;
  OClientItem: TOClientItem;
  StdItem: TStdItem;
  sUserItemName: string;
begin
  if Assigned(zPlugOfEngine.SendUseitemsMsg) then begin
    zPlugOfEngine.SendUseitemsMsg(Self);
  end else begin
    if (m_nSoftVersionDateEx = 0) and (m_dwClientTick = 0) then begin
      sSENDMSG := '';
      for i := Low(THumItems) to High(THumItems) do begin
        if m_UseItems[i].wIndex > 0 then begin
          Item := UserEngine.GetStdItem(m_UseItems[i].wIndex);
          if Item <> nil then begin
            StdItem := Item^;
            ItemUnit.GetItemAddValue(@m_UseItems[i], StdItem);
            CopyStdItemToOStdItem(@StdItem, @OClientItem.s);

            //取自定义物品名称
            sUserItemName := '';
            if m_UseItems[i].btValue[13] = 1 then
              sUserItemName := ItemUnit.GetCustomItemName(m_UseItems[i].MakeIndex, m_UseItems[i].wIndex);
            if sUserItemName <> '' then
              OClientItem.s.Name := sUserItemName;

            OClientItem.Dura := m_UseItems[i].Dura;
            OClientItem.DuraMax := m_UseItems[i].DuraMax;
            OClientItem.MakeIndex := m_UseItems[i].MakeIndex;
            sSENDMSG := sSENDMSG + IntToStr(i) + '/' + EncodeBuffer(@OClientItem, SizeOf(TOClientItem)) + '/';
          end;
        end;
      end;
      if sSENDMSG <> '' then begin
        m_DefMsg := MakeDefaultMsg(SM_SENDUSEITEMS, 0, 0, 0, 0);
        SendSocket(@m_DefMsg, sSENDMSG);
      end;
    end else begin
      sSENDMSG := '';
      for i := Low(THumanUseItems) to High(THumanUseItems) do begin
        if m_UseItems[i].wIndex > 0 then begin
          //sItemNewName:=GetItemName(m_UseItems[i].MakeIndex);
          Item := UserEngine.GetStdItem(m_UseItems[i].wIndex);
          if Item <> nil then begin
            StdItem := Item^;
            ItemUnit.GetItemAddValue(@m_UseItems[i], StdItem);
            Move(StdItem, ClientItem.s, SizeOf(TStdItem));

            //取自定义物品名称
            sUserItemName := '';
            if m_UseItems[i].btValue[13] = 1 then
              sUserItemName := ItemUnit.GetCustomItemName(m_UseItems[i].MakeIndex, m_UseItems[i].wIndex);
            if sUserItemName <> '' then
              ClientItem.s.Name := sUserItemName;

            ClientItem.Dura := m_UseItems[i].Dura;
            ClientItem.DuraMax := m_UseItems[i].DuraMax;
            ClientItem.MakeIndex := m_UseItems[i].MakeIndex;
            sSENDMSG := sSENDMSG + IntToStr(i) + '/' + EncodeBuffer(@ClientItem, SizeOf(TClientItem)) + '/';
          end;
        end;
      end;
      if sSENDMSG <> '' then begin
        m_DefMsg := MakeDefaultMsg(SM_SENDUSEITEMS, 0, 0, 0, 0);
        SendSocket(@m_DefMsg, sSENDMSG);
      end;
    end;
  end;
end;

procedure TPlayObject.SendUseMagic;
var
  i: Integer;
  sSENDMSG: string;
  UserMagic: pTUserMagic;
  ClientMagic: TClientMagic;
begin
  if Assigned(zPlugOfEngine.SendUseMagicMsg) then begin
    zPlugOfEngine.SendUseMagicMsg(Self);
  end else begin
    sSENDMSG := '';
    for i := 0 to m_MagicList.Count - 1 do begin
      UserMagic := m_MagicList.Items[i];
      if UserMagic <> nil then begin
        ClientMagic.Key := Chr(UserMagic.btKey);
        ClientMagic.Level := UserMagic.btLevel;
        ClientMagic.CurTrain := UserMagic.nTranPoint;
        ClientMagic.Def := UserMagic.MagicInfo^;
        sSENDMSG := sSENDMSG + EncodeBuffer(@ClientMagic, SizeOf(TClientMagic)) + '/';
      end;
    end;
    if sSENDMSG <> '' then begin
      m_DefMsg := MakeDefaultMsg(SM_SENDMYMAGIC, 0, 0, 0, m_MagicList.Count);
      SendSocket(@m_DefMsg, sSENDMSG);
    end;
  end;
end;

function TPlayObject.ClientChangeDir(wIdent: Word; nX, nY, nDir: Integer; var dwDelayTime: LongWord): Boolean; //4CAEB8
var
  dwCheckTime: LongWord;
begin
  Result := False;
  if m_boDeath or (m_wStatusTimeArr[POISON_STONE {5}] {0x6A} <> 0) then Exit; //防麻
  if not CheckActionStatus(wIdent, dwDelayTime) then begin
    m_boFilterAction := False;
    Exit;
  end;
  m_boFilterAction := True;
  dwCheckTime := GetTickCount - m_dwTurnTick;
  if dwCheckTime < g_Config.dwTurnIntervalTime then begin
    dwDelayTime := g_Config.dwTurnIntervalTime - dwCheckTime;
    {
    if dwCheckTime <= g_Config.dwTurnIntervalTime div 2 then begin
      SysMsg('ClientChangeDir ' + IntToStr(dwCheckTime);
      m_boEmergencyClose:=True;
      Result:=True;
    end;
    }
    Exit;
  end;

  if (nX = m_nCurrX) and (nY = m_nCurrY) then begin
    m_btDirection := nDir;
    if Walk(RM_TURN) then begin
      m_dwTurnTick := GetTickCount();
      Result := True;
    end;
  end;
end;

function TPlayObject.ClientSitDownHit(nX, nY, nDir: Integer; var dwDelayTime: LongWord): Boolean; //004CC248
var
  dwCheckTime: LongWord;
begin
  //SetProcessName('TPlayObject.ClientSitDownHit');
  Result := False;
  if m_boDeath or (m_wStatusTimeArr[POISON_STONE {5}] {0x6A} <> 0) then Exit; //防麻

  dwCheckTime := GetTickCount - m_dwTurnTick;

  if dwCheckTime < g_Config.dwTurnIntervalTime then begin
    dwDelayTime := g_Config.dwTurnIntervalTime - dwCheckTime;
    Exit;
  end;
  m_dwTurnTick := GetTickCount;
  SendRefMsg(RM_POWERHIT, 0, 0, 0, 0, '');
  Result := True;
end;

procedure TPlayObject.ClientOpenDoor(nX, nY: Integer);
var
  Door: pTDoorInfo;
  Castle: TUserCastle;
begin
  Door := m_PEnvir.GetDoor(nX, nY);
  if Door = nil then Exit;
  Castle := g_CastleManager.IsCastleEnvir(m_PEnvir);
  if (Castle = nil) or
    (Castle.m_DoorStatus <> Door.Status) or
    (m_btRaceServer <> RC_PLAYOBJECT) or
    Castle.CheckInPalace(m_nCurrX, m_nCurrY, Self) then begin
    UserEngine.OpenDoor(m_PEnvir, nX, nY);
  end;
  {
  if (UserCastle.m_MapCastle <> m_PEnvir) or
     (UserCastle.m_DoorStatus <> Door.Status) or
     (m_btRaceServer <> RC_PLAYOBJECT) or
     UserCastle.CheckInPalace(m_nCurrX,m_nCurrY,Self) then begin

    UserEngine.OpenDoor(m_PEnvir,nX,nY);
  end;
  }
end;

procedure TPlayObject.ClientTakeOnItems(btWhere: Byte; nItemIdx: Integer; sItemName: string);
var
  i, n14, n18: Integer;
  UserItem, TakeOffItem: pTUserItem;
  StdItem, StdItem20: pTStdItem;
  StdItem58: TStdItem;
  sUserItemName: string;
label FailExit;
begin
  StdItem := nil;
  UserItem := nil;
  n14 := -1;
  for i := 0 to m_ItemList.Count - 1 do begin
    UserItem := m_ItemList.Items[i];
    if (UserItem <> nil) and (UserItem.MakeIndex = nItemIdx) then begin
      //取自定义物品名称
      sUserItemName := '';
      if UserItem.btValue[13] = 1 then
        sUserItemName := ItemUnit.GetCustomItemName(UserItem.MakeIndex, UserItem.wIndex);
      if sUserItemName = '' then
        sUserItemName := UserEngine.GetStdItemName(UserItem.wIndex);
      StdItem := UserEngine.GetStdItem(UserItem.wIndex);
      if StdItem <> nil then begin
        if CompareText(sUserItemName, sItemName) = 0 then begin
          n14 := i;
          break;
        end;
      end;
    end;
    UserItem := nil;
  end;
  n18 := 0;
  if (StdItem <> nil) and (UserItem <> nil) then begin
    if CheckUserItems(btWhere, StdItem) then begin
      StdItem58 := StdItem^;
      ItemUnit.GetItemAddValue(UserItem, StdItem58);
      if CheckTakeOnItems(btWhere, StdItem58) and CheckItemBindUse(UserItem) then begin
        TakeOffItem := nil;
        if btWhere in [0..12] then begin
          if m_UseItems[btWhere].wIndex > 0 then begin
            StdItem20 := UserEngine.GetStdItem(m_UseItems[btWhere].wIndex);
            if (StdItem20 <> nil) and
              (StdItem20.StdMode in [15, 19, 20, 21, 22, 23, 24, 26]) then begin
              if (not m_boUserUnLockDurg) and (m_UseItems[btWhere].btValue[7] <> 0) then begin
                SysMsg(g_sCanotTakeOffItem {'无法取下物品！！！'}, c_Red, t_Hint);
                n18 := -4;
                goto FailExit;
              end;
            end;
            if not m_boUserUnLockDurg and ((StdItem20.Reserved and 2) <> 0) then begin
              SysMsg(g_sCanotTakeOffItem {'无法取下物品！！！'}, c_Red, t_Hint);
              n18 := -4;
              goto FailExit;
            end;
            if (StdItem20.Reserved and 4) <> 0 then begin
              SysMsg(g_sCanotTakeOffItem {'无法取下物品！！！'}, c_Red, t_Hint);
              n18 := -4;
              goto FailExit;
            end;
            if InDisableTakeOffList(m_UseItems[btWhere].wIndex) then begin
              SysMsg(g_sCanotTakeOffItem {'无法取下物品！！！'}, c_Red, t_Hint);
              goto FailExit;
            end;
            New(TakeOffItem);
            TakeOffItem^ := m_UseItems[btWhere];
          end; //004DAEC7 if m_UseItems[btWhere].wIndex > 0 then begin

          if (StdItem.StdMode in [15, 19, 20, 21, 22, 23, 24, 26]) and
            (UserItem.btValue[8] <> 0) then
            UserItem.btValue[8] := 0;

          m_UseItems[btWhere] := UserItem^;
          DelBagItem(n14);
          if TakeOffItem <> nil then begin
            AddItemToBag(TakeOffItem);
            SendAddItem(TakeOffItem);
          end;
          RecalcAbilitys();
          SendMsg(Self, RM_ABILITY, 0, 0, 0, 0, '');             //这是穿装备
          SendMsg(Self, RM_SUBABILITY, 0, 0, 0, 0, '');
          SendDefMessage(SM_TAKEON_OK, GetFeatureToLong, GetFeatureEx, 0, 0, '');
          FeatureChanged();
          n18 := 1;
        end; { else begin
        if m_AddUseItems[btWhere].wIndex > 0 then begin
          StdItem20:=UserEngine.GetStdItem(m_AddUseItems[btWhere].wIndex);
          if (StdItem20 <> nil) and
             (StdItem20.StdMode in [15,19,20,21,22,23,24,26]) then begin
            if (not m_boUserUnLockDurg) and (m_AddUseItems[btWhere].btValue[7] <> 0)then begin
              SysMsg('无法取下物品！！！',c_Red,t_Hint);
              n18:=-4;
              goto FailExit;
            end;
          end;
          if not m_boUserUnLockDurg and ((StdItem20.Reserved and 2) <> 0)then begin
            SysMsg('无法取下物品！！！',c_Red,t_Hint);
            n18:=-4;
            goto FailExit;
          end; //004DAE78
          if (StdItem20.Reserved and 4) <> 0 then begin
            SysMsg('无法取下物品！！！',c_Red,t_Hint);
            n18:=-4;
            goto FailExit;
          end;
          New(TakeOffItem);
          TakeOffItem^:=m_AddUseItems[btWhere];
        end; //004DAEC7 if m_UseItems[btWhere].wIndex > 0 then begin

        if (StdItem.StdMode in [15,19,20,21,22,23,24,26]) and   //004DAEC7
           (UserItem.btValue[8] <> 0) then
          UserItem.btValue[8]:=0;

        m_AddUseItems[btWhere]:=UserItem^;
        if TakeOffItem <> nil then begin
          AddItemToBag(TakeOffItem);
          SendAddItem(TakeOffItem);
        end;
        RecalcAbilitys();
        SendMsg(Self,RM_ABILITY,0,0,0,0,'');
        SendMsg(Self,RM_SUBABILITY,0,0,0,0,'');
        SendDefMessage(SM_TAKEON_OK,GetFeatureToLong,0,0,0,'');
        FeatureChanged();
        n18:=1;
      end;
      }
      end else n18 := -1;
    end else n18 := -1;
  end;
  FailExit:
  if n18 <= 0 then
    SendDefMessage(SM_TAKEON_FAIL, n18, 0, 0, 0, '');
end;

procedure TPlayObject.ClientTakeOffItems(btWhere: Byte; nItemIdx: Integer; sItemName: string);
var
  n10: Integer;
  StdItem: pTStdItem;
  UserItem: pTUserItem;
  sUserItemName: string;
label FailExit;
begin
  n10 := 0;
  if not m_boDealing and (btWhere < 13) then begin
    if m_UseItems[btWhere].wIndex > 0 then begin
      if m_UseItems[btWhere].MakeIndex = nItemIdx then begin
        StdItem := UserEngine.GetStdItem(m_UseItems[btWhere].wIndex);
        if (StdItem <> nil) and
          (StdItem.StdMode in [15, 19, 20, 21, 22, 23, 24, 26]) then begin
          if (not m_boUserUnLockDurg) and (m_UseItems[btWhere].btValue[7] <> 0) then begin
            SysMsg(g_sCanotTakeOffItem {'无法取下物品！！！'}, c_Red, t_Hint);
            n10 := -4;
            goto FailExit;
          end;
        end;
        if not m_boUserUnLockDurg and ((StdItem.Reserved and 2) <> 0) then begin
          SysMsg(g_sCanotTakeOffItem {'无法取下物品！！！'}, c_Red, t_Hint);
          n10 := -4;
          goto FailExit;
        end;
        if (StdItem.Reserved and 4) <> 0 then begin
          SysMsg(g_sCanotTakeOffItem {'无法取下物品！！！'}, c_Red, t_Hint);
          n10 := -4;
          goto FailExit;
        end;
        if InDisableTakeOffList(m_UseItems[btWhere].wIndex) then begin
          SysMsg(g_sCanotTakeOffItem {'无法取下物品！！！'}, c_Red, t_Hint);
          goto FailExit;
        end;
        //取自定义物品名称
        sUserItemName := '';
        if m_UseItems[btWhere].btValue[13] = 1 then
          sUserItemName := ItemUnit.GetCustomItemName(m_UseItems[btWhere].MakeIndex, m_UseItems[btWhere].wIndex);
        if sUserItemName = '' then
          sUserItemName := UserEngine.GetStdItemName(m_UseItems[btWhere].wIndex);

        if CompareText(sUserItemName, sItemName) = 0 then begin
          New(UserItem);
          UserItem^ := m_UseItems[btWhere];
          if AddItemToBag(UserItem) then begin
            m_UseItems[btWhere].wIndex := 0;

            SendAddItem(UserItem);
            RecalcAbilitys();
            SendMsg(Self, RM_ABILITY, 0, 0, 0, 0, '');
            SendMsg(Self, RM_SUBABILITY, 0, 0, 0, 0, '');
            SendDefMessage(SM_TAKEOFF_OK, GetFeatureToLong, GetFeatureEx, 0, 0, ''); //发送脱装备用这个也可以
            FeatureChanged();
          end else begin
            DisPose(UserItem);
            n10 := -3;
          end;
        end;
      end;
    end else n10 := -2;
  end else n10 := -1;
  FailExit:
  if n10 <= 0 then
    SendDefMessage(SM_TAKEOFF_FAIL, n10, 0, 0, 0, '');
end;

procedure TPlayObject.ClientUseItems(nItemIdx: Integer; sItemName: string);
  function GetUnbindItemName(nShape: Integer): string;
  var
    i: Integer;
  begin
    Result := '';
    for i := 0 to g_UnbindList.Count - 1 do begin
      if Integer(g_UnbindList.Objects[i]) = nShape then begin
        Result := g_UnbindList.Strings[i];
        break;
      end;
    end;
  end;
  function GetUnBindItems(sItemName: string; nCount: Integer): Boolean;
  var
    i: Integer;
    UserItem: pTUserItem;
  begin
    Result := False;
    for i := 0 to nCount - 1 do begin
      New(UserItem);
      if UserEngine.CopyToUserItemFromName(sItemName, UserItem) then begin
        m_ItemList.Add(UserItem);
        if m_btRaceServer = RC_PLAYOBJECT then
          SendAddItem(UserItem);
        Result := True;
      end else begin
        DisPose(UserItem);
        break;
      end;
    end;
  end;
  function FoundUserItem(Item: pTUserItem): Boolean;
  var
    i: Integer;
    UserItem: pTUserItem;
  begin
    Result := False;
    for i := 0 to m_ItemList.Count - 1 do begin
      UserItem := m_ItemList.Items[i];
      if UserItem = Item then begin
        Result := True;
        break;
      end;
    end;
  end;
var
  i: Integer;
  boEatOK: Boolean;
  UserItem: pTUserItem;
  StdItem: pTStdItem;
  UserItem34: TUserItem;
begin
  boEatOK := False;
  StdItem := nil;
  if m_boCanUseItem then begin
    if not m_boDeath then begin
      for i := m_ItemList.Count - 1 downto 0 do begin
        if m_ItemList.Count <= 0 then break;
        UserItem := m_ItemList.Items[i];
        if UserItem = nil then Continue;
        if (UserItem <> nil) and (UserItem.MakeIndex = nItemIdx) then begin
          UserItem34 := UserItem^;
          StdItem := UserEngine.GetStdItem(UserItem.wIndex);
          if StdItem <> nil then begin
            if not m_PEnvir.AllowStdItems(UserItem.wIndex) then begin
              SysMsg(format(g_sCanotMapUseItemMsg, [StdItem.Name]), c_Red, t_Hint);
              break;
            end;
            case StdItem.StdMode of
              0, 1, 2, 3: begin //药
                  if EatItems(StdItem) then begin
                    m_ItemList.Delete(i);
                    DisPoseAndNil(UserItem);
                    boEatOK := True;
                  end;
                  break;
                end;
              4: begin //书
                  if ReadBook(StdItem) then begin
                    m_ItemList.Delete(i);
                    DisPoseAndNil(UserItem);
                    boEatOK := True;
                    if (m_MagicErgumSkill <> nil) and (not m_boUseThrusting) then begin
                      ThrustingOnOff(True);
                      SendSocket(nil, '+LNG');
                    end;
                    if (m_MagicBanwolSkill <> nil) and (not m_boUseHalfMoon) then begin
                      HalfMoonOnOff(True);
                      SendSocket(nil, '+WID');
                    end;
                  end;
                end;
              31: begin //解包物品
                  if StdItem.AniCount = 0 then begin
                    if (m_ItemList.Count + 6 - 1) <= MAXBAGITEM then begin
                      m_ItemList.Delete(i);
                      DisPoseAndNil(UserItem);
                      GetUnBindItems(GetUnbindItemName(StdItem.Shape), 6);
                      boEatOK := True;
                    end;
                  end else begin
                    if UseStdmodeFunItem(StdItem) then begin
                      if FoundUserItem(UserItem) then begin
                        m_ItemList.Delete(i);
                        DisPoseAndNil(UserItem);
                      end;
                      boEatOK := True;
                    end;
                  end;
                end;
            end;
            break;
          end;
        end;
      end;
    end;
  end else begin
    SendMsg(g_ManageNPC, RM_MENU_OK, 0, Integer(Self), 0, 0, g_sCanotUseItemMsg);
  end;
  if boEatOK then begin
    WeightChanged();
    SendDefMessage(SM_EAT_OK, 0, 0, 0, 0, '');
    if StdItem.NeedIdentify = 1 then
      AddGameDataLog('11' + #9 +
        m_sMapName + #9 +
        IntToStr(m_nCurrX) + #9 +
        IntToStr(m_nCurrY) + #9 +
        m_sCharName + #9 +
        //UserEngine.GetStdItemName(UserItem34.wIndex) + #9 +
        StdItem.Name + #9 +
        IntToStr(UserItem34.MakeIndex) + #9 +
        '1' + #9 +
        '0');
  end else begin
    SendDefMessage(SM_EAT_FAIL, 0, 0, 0, 0, '');
  end;
end;

function TPlayObject.UseStdmodeFunItem(StdItem: pTStdItem): Boolean;
begin
  Result := False;
  if g_FunctionNPC <> nil then begin
    g_FunctionNPC.GotoLable(Self, '@StdModeFunc' + IntToStr(StdItem.AniCount), False);
    Result := True;
  end;
end;
//人物死亡触发
function TPlayObject.DieFunc: Boolean;
begin
  Result := False;
  if g_FunctionNPC <> nil then begin
    g_FunctionNPC.GotoLable(Self, '@PlayDie', False);
    Result := True;
  end;
end;
//人物升级触发
function TPlayObject.LevelUpFunc: Boolean;
begin
  Result := False;
  if g_FunctionNPC <> nil then begin
    g_FunctionNPC.GotoLable(Self, '@PlayLevelUp', False);
    Result := True;
  end;
end;
//杀人触发
function TPlayObject.KillPlayFunc: Boolean;
begin
  Result := False;
  if g_FunctionNPC <> nil then begin
    g_FunctionNPC.GotoLable(Self, '@KillPlay', False);
    Result := True;
  end;
end;

function TPlayObject.ClientGetButchItem(BaseObject: TBaseObject; nX, nY: Integer; btDir: Byte; var dwDelayTime: LongWord): Boolean; //004DB7E0
var
  n10, n14: Integer;
  dwCheckTime: LongWord;
begin
  Result := False;
  dwDelayTime := 0;
  dwCheckTime := GetTickCount - m_dwTurnTick;
  if dwCheckTime < g_Config.dwTurnIntervalTime then begin
    dwDelayTime := g_Config.dwTurnIntervalTime - dwCheckTime;
    Exit;
  end;
  m_dwTurnTick := GetTickCount;
  if (abs(nX - m_nCurrX) <= 2) and (abs(nY - m_nCurrY) <= 2) then begin
    if m_PEnvir.IsValidObject(nX, nY, 2, BaseObject) then begin
      if BaseObject.m_boDeath and (not BaseObject.m_boSkeleton) and (BaseObject.m_boAnimal) then begin
        n10 := Random(16) + 5;
        n14 := Random(201) + 100;
        Dec(BaseObject.m_nBodyLeathery, n10);
        Dec(BaseObject.m_nMeatQuality, n14);
        if BaseObject.m_nMeatQuality < 0 then BaseObject.m_nMeatQuality := 0;
        if BaseObject.m_nBodyLeathery <= 0 then begin
          if (BaseObject.m_btRaceServer >= RC_ANIMAL) and (BaseObject.m_btRaceServer < RC_MONSTER) then begin
            BaseObject.m_boSkeleton := True;
            ApplyMeatQuality();
            BaseObject.SendRefMsg(RM_SKELETON, BaseObject.m_btDirection, BaseObject.m_nCurrX, BaseObject.m_nCurrY, 0, '');
          end;
          if not TakeBagItems(BaseObject) then begin
            SysMsg(sYouFoundNothing {未发现任何物品！！！}, c_Red, t_Hint);
          end;
          BaseObject.m_nBodyLeathery := 50;
        end;
        m_dwDeathTick := GetTickCount();
      end;
    end;
    m_btDirection := btDir;
  end;
  SendRefMsg(RM_BUTCH, m_btDirection, m_nCurrX, m_nCurrY, 0, '');
end;

procedure TPlayObject.ClientChangeMagicKey(nSkillIdx, nKey: Integer);
var
  i: Integer;
  UserMagic: pTUserMagic;
begin
  for i := 0 to m_MagicList.Count - 1 do begin
    UserMagic := m_MagicList.Items[i];
    if UserMagic = nil then Continue;
    if UserMagic.MagicInfo.wMagicId = nSkillIdx then begin
      UserMagic.btKey := nKey;
      break;
    end;
  end;
end;

procedure TPlayObject.ClientGropuClose;
begin
  if m_GroupOwner = nil then begin
    m_boAllowGroup := False;
    Exit;
  end;
  if m_GroupOwner <> Self then begin
    m_GroupOwner.DelMember(Self);
    m_boAllowGroup := False;
  end else begin
    SysMsg('如果你想退出，使用编组功能（删除按钮）', c_Red, t_Hint);
  end;
end;

procedure TPlayObject.ClientCreateGroup(sHumName: string);
var
  PlayObject: TPlayObject;
begin
  PlayObject := UserEngine.GetPlayObject(sHumName);
  if m_GroupOwner <> nil then begin
    SendDefMessage(SM_CREATEGROUP_FAIL, -1, 0, 0, 0, '');
    Exit;
  end;
  if (PlayObject = nil) or (PlayObject = Self) or PlayObject.m_boDeath or PlayObject.m_boGhost then begin
    SendDefMessage(SM_CREATEGROUP_FAIL, -2, 0, 0, 0, '');
    Exit;
  end;
  if (PlayObject.m_GroupOwner <> nil) then begin
    SendDefMessage(SM_CREATEGROUP_FAIL, -3, 0, 0, 0, '');
    Exit;
  end;
  if (not PlayObject.m_boAllowGroup) then begin
    SendDefMessage(SM_CREATEGROUP_FAIL, -4, 0, 0, 0, '');
    Exit;
  end;
  m_GroupMembers.Clear;
  m_GroupMembers.AddObject(m_sCharName, Self);
  m_GroupMembers.AddObject(sHumName, PlayObject);
  JoinGroup(Self);
  PlayObject.JoinGroup(Self);
  m_boAllowGroup := True;
  SendDefMessage(SM_CREATEGROUP_OK, 0, 0, 0, 0, '');
  SendGroupMembers();
end;

procedure TPlayObject.ClientAddGroupMember(sHumName: string);
var
  PlayObject: TPlayObject;
begin
  PlayObject := UserEngine.GetPlayObject(sHumName);

  if m_GroupOwner <> Self then begin
    SendDefMessage(SM_GROUPADDMEM_FAIL, -1, 0, 0, 0, '');
    Exit;
  end;
  if m_GroupMembers.Count > g_Config.nGroupMembersMax then begin
    SendDefMessage(SM_GROUPADDMEM_FAIL, -5, 0, 0, 0, '');
    Exit;
  end;
  if (PlayObject = nil) or (PlayObject = Self) or PlayObject.m_boDeath or PlayObject.m_boGhost then begin
    SendDefMessage(SM_GROUPADDMEM_FAIL, -2, 0, 0, 0, '');
    Exit;
  end;
  if (PlayObject.m_GroupOwner <> nil) then begin
    SendDefMessage(SM_GROUPADDMEM_FAIL, -3, 0, 0, 0, '');
    Exit;
  end;
  if (not PlayObject.m_boAllowGroup) then begin
    SendDefMessage(SM_GROUPADDMEM_FAIL, -4, 0, 0, 0, '');
    Exit;
  end;
  m_GroupMembers.AddObject(sHumName, PlayObject);
  PlayObject.JoinGroup(Self);
  SendDefMessage(SM_GROUPADDMEM_OK, 0, 0, 0, 0, '');
  SendGroupMembers();
end;

procedure TPlayObject.ClientDelGroupMember(sHumName: string);
var
  PlayObject: TPlayObject;
begin
  PlayObject := UserEngine.GetPlayObject(sHumName);
  if m_GroupOwner <> Self then begin
    SendDefMessage(SM_GROUPDELMEM_FAIL, -1, 0, 0, 0, '');
    Exit;
  end;
  if PlayObject = nil then begin
    SendDefMessage(SM_GROUPDELMEM_FAIL, -2, 0, 0, 0, '');
    Exit;
  end;
  if not IsGroupMember(PlayObject) then begin
    SendDefMessage(SM_GROUPDELMEM_FAIL, -3, 0, 0, 0, '');
    Exit;
  end;
  DelMember(PlayObject);
  SendDefMessage(SM_GROUPDELMEM_OK, 0, 0, 0, 0, sHumName);
end;

procedure TPlayObject.ClientDealTry(sHumName: string);
var
  BaseObject: TBaseObject;
begin
  if g_Config.boDisableDeal then begin
    SendMsg(g_ManageNPC, RM_MENU_OK, 0, Integer(Self), 0, 0, g_sDisableDealItemsMsg);
    Exit;
  end;
  if m_boDealing then Exit;
  if GetTickCount - m_DealLastTick < g_Config.dwTryDealTime {3000} then begin
    SendMsg(g_ManageNPC, RM_MENU_OK, 0, Integer(Self), 0, 0, g_sPleaseTryDealLaterMsg);
    Exit;
  end;
  if not m_boCanDeal then begin
    SendMsg(g_ManageNPC, RM_MENU_OK, 0, Integer(Self), 0, 0, g_sCanotTryDealMsg);
    Exit;
  end;
  BaseObject := GetPoseCreate();
  if (BaseObject <> nil) and (BaseObject <> Self) then begin
    if (BaseObject.GetPoseCreate = Self) and (not BaseObject.m_boDealing) then begin
      if (BaseObject.m_btRaceServer = RC_PLAYOBJECT) then begin
        if (BaseObject.m_boAllowDeal and TPlayObject(BaseObject).m_boCanDeal) then begin
          BaseObject.SysMsg(m_sCharName + g_sOpenedDealMsg, c_Green, t_Hint);
          SysMsg(BaseObject.m_sCharName + g_sOpenedDealMsg, c_Green, t_Hint);
          TPlayObject(Self).OpenDealDlg(BaseObject);
          TPlayObject(BaseObject).OpenDealDlg(Self);
        end else begin
          SysMsg(g_sPoseDisableDealMsg {'对方禁止进入交易'}, c_Red, t_Hint);
        end;
      end;
    end else begin
      SendDefMessage(SM_DEALTRY_FAIL, 0, 0, 0, 0, '');
    end;
  end else begin
    SendDefMessage(SM_DEALTRY_FAIL, 0, 0, 0, 0, '');
  end;
end;

procedure TPlayObject.ClientAddDealItem(nItemIdx: Integer; sItemName: string);
var
  i: Integer;
  bo11: Boolean;
  UserItem: pTUserItem;
  sUserItemName: string;
begin
  if (m_DealCreat = nil) or (not m_boDealing) then Exit;
  if Pos(' ', sItemName) >= 0 then begin //折分物品名称(信件物品的名称后面加了使用次数)
    GetValidStr3(sItemName, sItemName, [' ']);
  end;
  bo11 := False;
  if not m_DealCreat.m_boDealOK then begin
    for i := m_ItemList.Count - 1 downto 0 do begin
      if m_ItemList.Count <= 0 then break;
      UserItem := m_ItemList.Items[i];
      if UserItem = nil then Continue;
      if UserItem.MakeIndex = nItemIdx then begin
        //取自定义物品名称
        sUserItemName := '';
        if UserItem.btValue[13] = 1 then
          sUserItemName := ItemUnit.GetCustomItemName(UserItem.MakeIndex, UserItem.wIndex);
        if sUserItemName = '' then
          sUserItemName := UserEngine.GetStdItemName(UserItem.wIndex);

        if (CompareText(sUserItemName, sItemName) = 0) and
          (m_DealItemList.Count < 12) then begin
          m_DealItemList.Add(UserItem);
          TPlayObject(Self).SendAddDealItem(UserItem);
          m_ItemList.Delete(i);
          bo11 := True;
          break;
        end;
      end;
    end;
  end;
  if not bo11 then
    SendDefMessage(SM_DEALADDITEM_FAIL, 0, 0, 0, 0, '');
end;

procedure TPlayObject.ClientDelDealItem(nItemIdx: Integer; sItemName: string);
var
  i: Integer;
  bo11: Boolean;
  UserItem: pTUserItem;
  sUserItemName: string;
begin
  if g_Config.boCanNotGetBackDeal then begin
    SendMsg(g_ManageNPC, RM_MENU_OK, 0, Integer(Self), 0, 0, g_sDealItemsDenyGetBackMsg);
    SendDefMessage(SM_DEALDELITEM_FAIL, 0, 0, 0, 0, '');
    Exit;
  end;
  if (m_DealCreat = nil) or (not m_boDealing) then Exit;
  if Pos(' ', sItemName) >= 0 then begin //折分物品名称(信件物品的名称后面加了使用次数)
    GetValidStr3(sItemName, sItemName, [' ']);
  end;
  bo11 := False;
  if not m_DealCreat.m_boDealOK then begin
    for i := m_DealItemList.Count - 1 downto 0 do begin
      if m_DealItemList.Count <= 0 then break;
      UserItem := m_DealItemList.Items[i];
      if UserItem = nil then Continue;
      if UserItem.MakeIndex = nItemIdx then begin
        //取自定义物品名称
        sUserItemName := '';
        if UserItem.btValue[13] = 1 then
          sUserItemName := ItemUnit.GetCustomItemName(UserItem.MakeIndex, UserItem.wIndex);
        if sUserItemName = '' then
          sUserItemName := UserEngine.GetStdItemName(UserItem.wIndex);

        if CompareText(sUserItemName, sItemName) = 0 then begin
          m_ItemList.Add(UserItem);
          TPlayObject(Self).SendDelDealItem(UserItem);
          m_DealItemList.Delete(i);
          bo11 := True;
          break;
        end;
      end;
    end;
  end;
  if not bo11 then
    SendDefMessage(SM_DEALDELITEM_FAIL, 0, 0, 0, 0, '');
end;

procedure TPlayObject.ClientCancelDeal;
begin
  DealCancel();
end;

procedure TPlayObject.ClientChangeDealGold(nGold: Integer);
var
  bo09: Boolean;
begin
  //禁止取回放入交易栏内的金币
  if (m_nDealGolds > 0) and g_Config.boCanNotGetBackDeal then begin
    SendMsg(g_ManageNPC, RM_MENU_OK, 0, Integer(Self), 0, 0, g_sDealItemsDenyGetBackMsg);
    SendDefMessage(SM_DEALDELITEM_FAIL, 0, 0, 0, 0, '');
    Exit;
  end;
  if nGold < 0 then begin
    SendDefMessage(SM_DEALCHGGOLD_FAIL, m_nDealGolds, LoWord(m_nGold), HiWord(m_nGold), 0, '');
    Exit;
  end;
  bo09 := False;
  if (m_DealCreat <> nil) and (GetPoseCreate = m_DealCreat) then begin
    if not m_DealCreat.m_boDealOK then begin
      if (m_nGold + m_nDealGolds) >= nGold then begin
        m_nGold := (m_nGold + m_nDealGolds) - nGold;
        m_nDealGolds := nGold;
        SendDefMessage(SM_DEALCHGGOLD_OK, m_nDealGolds, LoWord(m_nGold), HiWord(m_nGold), 0, '');
        TPlayObject(m_DealCreat).SendDefMessage(SM_DEALREMOTECHGGOLD, m_nDealGolds, 0, 0, 0, '');
        m_DealCreat.m_DealLastTick := GetTickCount();
        bo09 := True;
        m_DealLastTick := GetTickCount();
      end;
    end;
  end;
  if not bo09 then begin
    SendDefMessage(SM_DEALCHGGOLD_FAIL, m_nDealGolds, LoWord(m_nGold), HiWord(m_nGold), 0, '');
  end;
end;

procedure TPlayObject.ClientDealEnd;
var
  i: Integer;
  bo11: Boolean;
  UserItem: pTUserItem;
  StdItem: pTStdItem;
  PlayObject: TPlayObject;
begin
  m_boDealOK := True;
  if m_DealCreat = nil then Exit;
  if ((GetTickCount - m_DealLastTick) < g_Config.dwDealOKTime {1000}) or ((GetTickCount - m_DealCreat.m_DealLastTick) < g_Config.dwDealOKTime {1000}) then begin
    SysMsg(g_sDealOKTooFast, c_Red, t_Hint);
    DealCancel();
    Exit;
  end;
  if m_DealCreat.m_boDealOK then begin
    bo11 := True;
    if (MAXBAGITEM - m_ItemList.Count) < m_DealCreat.m_DealItemList.Count then begin
      bo11 := False;
      SysMsg(g_sYourBagSizeTooSmall, c_Red, t_Hint);
    end;
    if (m_nGoldMax - m_nGold) < m_DealCreat.m_nDealGolds then begin
      SysMsg(g_sYourGoldLargeThenLimit, c_Red, t_Hint);
      bo11 := False;
    end;
    if (MAXBAGITEM - m_DealCreat.m_ItemList.Count) < m_DealItemList.Count then begin
      SysMsg(g_sDealHumanBagSizeTooSmall, c_Red, t_Hint);
      bo11 := False;
    end;
    if (m_DealCreat.m_nGoldMax - m_DealCreat.m_nGold) < m_nDealGolds then begin
      SysMsg(g_sDealHumanGoldLargeThenLimit, c_Red, t_Hint);
      bo11 := False;
    end;
    if bo11 then begin
      for i := 0 to m_DealItemList.Count - 1 do begin
        UserItem := m_DealItemList.Items[i];
        if UserItem = nil then Continue;
        m_DealCreat.AddItemToBag(UserItem);
        TPlayObject(m_DealCreat).SendAddItem(UserItem);
        StdItem := UserEngine.GetStdItem(UserItem.wIndex);
        if StdItem <> nil then begin
          if not IsCheapStuff(StdItem.StdMode) then begin
            //004DDF49
            if StdItem.NeedIdentify = 1 then
              AddGameDataLog('8' + #9 +
                m_sMapName + #9 +
                IntToStr(m_nCurrX) + #9 +
                IntToStr(m_nCurrY) + #9 +
                m_sCharName + #9 +
                //UserEngine.GetStdItemName(UserItem.wIndex) + #9 +
                StdItem.Name + #9 +
                IntToStr(UserItem.MakeIndex) + #9 +
                '1' + #9 +
                m_DealCreat.m_sCharName);
          end;
        end;
      end; //004DDF5A
      if m_nDealGolds > 0 then begin
        Inc(m_DealCreat.m_nGold, m_nDealGolds);
        m_DealCreat.GoldChanged();
        //004DE05E
        if g_boGameLogGold then
          AddGameDataLog('8' + #9 +
            m_sMapName + #9 +
            IntToStr(m_nCurrX) + #9 +
            IntToStr(m_nCurrY) + #9 +
            m_sCharName + #9 +
            sSTRING_GOLDNAME + #9 +
            IntToStr(m_nGold) + #9 +
            '1' + #9 +
            m_DealCreat.m_sCharName);
      end;
      for i := 0 to m_DealCreat.m_DealItemList.Count - 1 do begin
        UserItem := m_DealCreat.m_DealItemList.Items[i];
        if UserItem = nil then Continue;
        AddItemToBag(UserItem);
        TPlayObject(Self).SendAddItem(UserItem);
        StdItem := UserEngine.GetStdItem(UserItem.wIndex);
        if StdItem <> nil then begin
          if not IsCheapStuff(StdItem.StdMode) then begin
            //004DE217
            if StdItem.NeedIdentify = 1 then
              AddGameDataLog('8' + #9 +
                m_DealCreat.m_sMapName + #9 +
                IntToStr(m_DealCreat.m_nCurrX) + #9 +
                IntToStr(m_DealCreat.m_nCurrY) + #9 +
                m_DealCreat.m_sCharName + #9 +
                //UserEngine.GetStdItemName(UserItem.wIndex) + #9 +
                StdItem.Name + #9 +
                IntToStr(UserItem.MakeIndex) + #9 +
                '1' + #9 +
                m_sCharName);
          end;
        end;
      end; //004DDF5A
      if m_DealCreat.m_nDealGolds > 0 then begin
        Inc(m_nGold, m_DealCreat.m_nDealGolds);
        GoldChanged();
        //004DE36E
        if g_boGameLogGold then
          AddGameDataLog('8' + #9 +
            m_DealCreat.m_sMapName + #9 +
            IntToStr(m_DealCreat.m_nCurrX) + #9 +
            IntToStr(m_DealCreat.m_nCurrY) + #9 +
            m_DealCreat.m_sCharName + #9 +
            sSTRING_GOLDNAME + #9 +
            IntToStr(m_DealCreat.m_nGold) + #9 +
            '1' + #9 +
            m_sCharName);
      end;
      //004DE37
      PlayObject := TPlayObject(m_DealCreat);
      PlayObject.SendDefMessage(SM_DEALSUCCESS, 0, 0, 0, 0, '');
      PlayObject.SysMsg(g_sDealSuccessMsg {'交易成功...'}, c_Green, t_Hint);
      PlayObject.m_DealCreat := nil;
      PlayObject.m_boDealing := False;
      PlayObject.m_DealItemList.Clear;
      PlayObject.m_nDealGolds := 0;
      PlayObject.m_boDealOK := False; //Jacky 增加
      SendDefMessage(SM_DEALSUCCESS, 0, 0, 0, 0, '');
      SysMsg(g_sDealSuccessMsg {'交易成功...'}, c_Green, t_Hint);
      m_DealCreat := nil;
      m_boDealing := False;
      m_DealItemList.Clear;
      m_nDealGolds := 0;
      m_boDealOK := False; //Jacky 增加
    end else begin //004DE42F
      DealCancel();
    end;
  end else begin //004DE439
    SysMsg(g_sYouDealOKMsg {'你已经确认交易了'}, c_Green, t_Hint);
    m_DealCreat.SysMsg(g_sPoseDealOKMsg {'对方已经确认交易了'}, c_Green, t_Hint);
  end;
end;

procedure TPlayObject.ClientGetMinMap;
var
  nMinMap: Integer;
begin
  nMinMap := m_PEnvir.nMinMap;
  if nMinMap > 0 then begin
    SendDefMessage(SM_READMINIMAP_OK, 0, nMinMap, 0, 0, '');
  end else begin
    SendDefMessage(SM_READMINIMAP_FAIL, 0, 0, 0, 0, '');
  end;
end;

procedure TPlayObject.ClientMakeDrugItem(NPC: TObject; nItemName: string);
var
  Merchant: TMerchant;
begin
  Merchant := UserEngine.FindMerchant(NPC);
  if (Merchant = nil) or (not Merchant.m_boMakeDrug) then Exit;
  if ((Merchant.m_PEnvir = m_PEnvir) and
    (abs(Merchant.m_nCurrX - m_nCurrX) < 15) and
    (abs(Merchant.m_nCurrY - m_nCurrY) < 15)) then
    Merchant.ClientMakeDrugItem(Self, nItemName);
end;

procedure TPlayObject.ClientOpenGuildDlg;
var
  i: Integer;
  SC: string;
begin
  if m_MyGuild <> nil then begin
    SC := TGUild(m_MyGuild).sGuildName + #13 + ' ' + #13;
    if m_nGuildRankNo = 1 then begin
      SC := SC + '1' + #13;
    end else begin
      SC := SC + '0' + #13;
    end;
    SC := SC + '<Notice>' + #13;
    for i := 0 to TGUild(m_MyGuild).NoticeList.Count - 1 do begin
      if Length(SC) > 5000 then break;
      SC := SC + TGUild(m_MyGuild).NoticeList.Strings[i] + #13;
    end; // for
    SC := SC + '<KillGuilds>' + #13;
    for i := 0 to TGUild(m_MyGuild).GuildWarList.Count - 1 do begin
      if Length(SC) > 5000 then break;
      SC := SC + TGUild(m_MyGuild).GuildWarList.Strings[i] + #13;
    end; // for
    SC := SC + '<AllyGuilds>' + #13;
    for i := 0 to TGUild(m_MyGuild).GuildAllList.Count - 1 do begin
      if Length(SC) > 5000 then break;
      SC := SC + TGUild(m_MyGuild).GuildAllList.Strings[i] + #13;
    end; // for
    m_DefMsg := MakeDefaultMsg(SM_OPENGUILDDLG, 0, 0, 0, 1);
    SendSocket(@m_DefMsg, EncodeString(SC));
  end else begin
    SendDefMessage(SM_OPENGUILDDLG_FAIL, 0, 0, 0, 0, '');
  end;
end;

procedure TPlayObject.ClientGuildHome;
begin
  ClientOpenGuildDlg();
end;

procedure TPlayObject.ClientGuildMemberList;
var
  GuildRank: pTGuildRank;
  i, ii: Integer;
  sSENDMSG: string;
begin
  if m_MyGuild = nil then Exit;
  for i := 0 to TGUild(m_MyGuild).m_RankList.Count - 1 do begin
    GuildRank := TGUild(m_MyGuild).m_RankList.Items[i];
    if GuildRank = nil then Continue;
    sSENDMSG := sSENDMSG + '#' + IntToStr(GuildRank.nRankNo) + '/*' + GuildRank.sRankName + '/';
    for ii := 0 to GuildRank.MemberList.Count - 1 do begin
      if Length(sSENDMSG) > 5000 then break;
      sSENDMSG := sSENDMSG + GuildRank.MemberList.Strings[ii] + '/';
    end;
  end;
  m_DefMsg := MakeDefaultMsg(SM_SENDGUILDMEMBERLIST, 0, 0, 0, 1);
  SendSocket(@m_DefMsg, EncodeString(sSENDMSG));
end;

procedure TPlayObject.ClientGuildAddMember(sHumName: string);
var
  nC: Integer;
  PlayObject: TPlayObject;
begin
  nC := 1; //'你没有权利使用这个命令。'
  if IsGuildMaster then begin
    PlayObject := UserEngine.GetPlayObject(sHumName);
    if (PlayObject <> nil) and (not PlayObject.m_boNotOnlineAddExp) then begin //2006-10-30增加检测不是离线挂机人物
      if (PlayObject.GetPoseCreate = Self) and (PlayObject.GetPoseCreate <> nil) then begin
        if PlayObject.m_boAllowGuild then begin
          if not TGUild(m_MyGuild).IsMember(sHumName) then begin
            if (PlayObject.m_MyGuild = nil) and (TGUild(m_MyGuild).m_RankList.Count < 400) then begin
              TGUild(m_MyGuild).AddMember(PlayObject);
              UserEngine.SendServerGroupMsg(SS_207, nServerIndex, TGUild(m_MyGuild).sGuildName);
              PlayObject.m_MyGuild := m_MyGuild;
              PlayObject.m_sGuildRankName := TGUild(m_MyGuild).GetRankName(PlayObject, PlayObject.m_nGuildRankNo);
              PlayObject.RefShowName();
              PlayObject.SysMsg('你已加入行会: ' + TGUild(m_MyGuild).sGuildName + ' 当前封号为: ' + PlayObject.m_sGuildRankName, c_Green, t_Hint);
              nC := 0;
            end else nC := 4; //'对方已经加入其他行会。'
          end else nC := 3; //004DEEF4 '对方已经加入我们的行会。'
        end else begin //004DEEFD
          nC := 5; //'对方不允许加入行会。'
          PlayObject.SysMsg('你拒绝加入行会。 [允许命令为 @' + g_GameCommand.LETGUILD.sCmd + ']', c_Red, t_Hint);
        end;
      end else nC := 2; //004DEF15 '想加入进来的成员应该来面对掌门人。'
    end else nC := 2;
  end;
  if nC = 0 then begin
    SendDefMessage(SM_GUILDADDMEMBER_OK, 0, 0, 0, 0, '');
  end else begin
    SendDefMessage(SM_GUILDADDMEMBER_FAIL, nC, 0, 0, 0, '');
  end;
end;

procedure TPlayObject.ClientGuildDelMember(sHumName: string);
var
  nC: Integer;
  s14: string;
  PlayObject: TPlayObject;
begin
  nC := 1;
  if IsGuildMaster then begin
    if TGUild(m_MyGuild).IsMember(sHumName) then begin
      if m_sCharName <> sHumName then begin
        if TGUild(m_MyGuild).DelMember(sHumName) then begin
          PlayObject := UserEngine.GetPlayObject(sHumName);
          if PlayObject <> nil then begin
            PlayObject.m_MyGuild := nil;
            PlayObject.RefRankInfo(0, '');
            PlayObject.RefShowName(); //10/31
          end;
          UserEngine.SendServerGroupMsg(SS_207, nServerIndex, TGUild(m_MyGuild).sGuildName);
          nC := 0;
        end else nC := 4;
      end else begin
        nC := 3;
        s14 := TGUild(m_MyGuild).sGuildName;
        if TGUild(m_MyGuild).CancelGuld(sHumName) then begin
          g_GuildManager.DELGUILD(s14);
          UserEngine.SendServerGroupMsg(SS_206, nServerIndex, s14);
          m_MyGuild := nil;
          RefRankInfo(0, '');
          RefShowName(); //10/31
          SysMsg('行会' + s14 + '已被取消！！！', c_Red, t_Hint);
          nC := 0;
        end
      end;
    end else nC := 2;
  end;
  if nC = 0 then begin
    SendDefMessage(SM_GUILDDELMEMBER_OK, 0, 0, 0, 0, '');
  end else begin
    SendDefMessage(SM_GUILDDELMEMBER_FAIL, nC, 0, 0, 0, '');
  end;
end;

procedure TPlayObject.ClientGuildUpdateNotice(sNotict: string);
var
  SC: string;
begin
  if (m_MyGuild = nil) or (m_nGuildRankNo <> 1) then Exit;
  TGUild(m_MyGuild).NoticeList.Clear;
  while (sNotict <> '') do begin
    sNotict := GetValidStr3(sNotict, SC, [#$D]);
    TGUild(m_MyGuild).NoticeList.Add(SC);
  end; // while
  TGUild(m_MyGuild).SaveGuildInfoFile();
  UserEngine.SendServerGroupMsg(SS_207, nServerIndex, TGUild(m_MyGuild).sGuildName);
  ClientOpenGuildDlg();
end;

procedure TPlayObject.ClientGuildUpdateRankInfo(sRankInfo: string);
var
  nC: Integer;
begin
  if (m_MyGuild = nil) or (m_nGuildRankNo <> 1) then Exit;
  nC := TGUild(m_MyGuild).UpdateRank(sRankInfo);
  if nC = 0 then begin
    UserEngine.SendServerGroupMsg(SS_207, nServerIndex, TGUild(m_MyGuild).sGuildName);
    ClientGuildMemberList();
  end else begin
    if nC <= -2 then begin
      SendDefMessage(SM_GUILDRANKUPDATE_FAIL, nC, 0, 0, 0, '');
    end;
  end;
end;

procedure TPlayObject.ClientGuildAlly;
var
  n8: Integer;
  BaseObjectC: TBaseObject;
resourcestring
  sExceptionMsg = '[Exception] TPlayObject::ClientGuildAlly';
begin
  try
    n8 := -1;
    BaseObjectC := GetPoseCreate();
    if (BaseObjectC <> nil) and
      (BaseObjectC.m_MyGuild <> nil) and
      (BaseObjectC.m_btRaceServer = RC_PLAYOBJECT) and
      (BaseObjectC.GetPoseCreate = Self) then begin
      if (TGUild(BaseObjectC.m_MyGuild) <> nil) and (TGUild(BaseObjectC.m_MyGuild).m_boEnableAuthAlly) then begin
        if BaseObjectC.IsGuildMaster and IsGuildMaster then begin
          if (TGUild(m_MyGuild) <> nil) and TGUild(m_MyGuild).IsNotWarGuild(TGUild(BaseObjectC.m_MyGuild)) and
            TGUild(BaseObjectC.m_MyGuild).IsNotWarGuild(TGUild(m_MyGuild)) then begin
            TGUild(m_MyGuild).AllyGuild(TGUild(BaseObjectC.m_MyGuild));
            TGUild(BaseObjectC.m_MyGuild).AllyGuild(TGUild(m_MyGuild));
            TGUild(m_MyGuild).SendGuildMsg(TGUild(BaseObjectC.m_MyGuild).sGuildName + '行会已经和您的行会联盟成功。');
            TGUild(BaseObjectC.m_MyGuild).SendGuildMsg(TGUild(m_MyGuild).sGuildName + '行会已经和您的行会联盟成功。');
            TGUild(m_MyGuild).RefMemberName;
            TGUild(BaseObjectC.m_MyGuild).RefMemberName;
            UserEngine.SendServerGroupMsg(SS_207, nServerIndex, TGUild(m_MyGuild).sGuildName);
            UserEngine.SendServerGroupMsg(SS_207, nServerIndex, TGUild(BaseObjectC.m_MyGuild).sGuildName);
            n8 := 0;
          end else n8 := -2;
        end else n8 := -3;
      end else n8 := -4;
    end;
    if n8 = 0 then begin
      SendDefMessage(SM_GUILDMAKEALLY_OK, 0, 0, 0, 0, '');
    end else begin
      SendDefMessage(SM_GUILDMAKEALLY_FAIL, n8, 0, 0, 0, '');
    end;
  except
    on E: Exception do begin
      MainOutMessage(sExceptionMsg);
      MainOutMessage(E.Message);
    end;
  end;
end;

procedure TPlayObject.ClientGuildBreakAlly(sGuildName: string);
var
  n10: Integer;
  Guild: TGUild;
begin
  n10 := -1;
  if not IsGuildMaster() then Exit;
  Guild := g_GuildManager.FindGuild(sGuildName);
  if (Guild <> nil) and (m_MyGuild <> nil) then begin
    if TGUild(m_MyGuild).IsAllyGuild(Guild) then begin
      TGUild(m_MyGuild).DelAllyGuild(Guild);
      Guild.DelAllyGuild(TGUild(m_MyGuild));
      TGUild(m_MyGuild).SendGuildMsg(Guild.sGuildName + ' 行会与您的行会解除联盟成功！！！');
      Guild.SendGuildMsg(TGUild(m_MyGuild).sGuildName + ' 行会解除了与您行会的联盟！！！');
      TGUild(m_MyGuild).RefMemberName();
      Guild.RefMemberName();
      UserEngine.SendServerGroupMsg(SS_207, nServerIndex, TGUild(m_MyGuild).sGuildName);
      UserEngine.SendServerGroupMsg(SS_207, nServerIndex, Guild.sGuildName);
      n10 := 0;
    end else n10 := -2;
  end else n10 := -3;
  if n10 = 0 then begin
    SendDefMessage(SM_GUILDBREAKALLY_OK, 0, 0, 0, 0, '');
  end else begin
    SendDefMessage(SM_GUILDMAKEALLY_FAIL, 0, 0, 0, 0, '');
  end;
end;

procedure TPlayObject.RecalcAdjusBonus();
  procedure AdjustAb(Abil: Byte; val: Word; var lov, hiv: Word);
  var
    lo, hi: Byte;
    i: Integer;
  begin
    lo := LoByte(Abil);
    hi := Hibyte(Abil);
    lov := 0; hiv := 0;
    for i := 1 to val do begin
      if lo + 1 < hi then begin
        Inc(lo);
        Inc(lov);
      end else begin
        Inc(hi);
        Inc(hiv);
      end;
    end;
  end;
var
  BonusTick: pTNakedAbility;
  NakedAbil: pTNakedAbility;
  l, m, adc, amc, asc, aac, amac: Integer;
  ldc, lmc, lsc, lac, lmac, hdc, hmc, hsc, hac, hmac: Word;
begin
  BonusTick := nil;
  NakedAbil := nil;
  case m_btJob of
    0: begin
        BonusTick := @g_Config.BonusAbilofWarr;
        NakedAbil := @g_Config.NakedAbilofWarr;
      end;
    1: begin
        BonusTick := @g_Config.BonusAbilofWizard;
        NakedAbil := @g_Config.NakedAbilofWizard;
      end;
    2: begin
        BonusTick := @g_Config.BonusAbilofTaos;
        NakedAbil := @g_Config.NakedAbilofTaos;
      end;
  end;

  adc := m_BonusAbil.DC div BonusTick.DC;
  amc := m_BonusAbil.MC div BonusTick.MC;
  asc := m_BonusAbil.SC div BonusTick.SC;
  aac := m_BonusAbil.AC div BonusTick.AC;
  amac := m_BonusAbil.MAC div BonusTick.MAC;

  AdjustAb(NakedAbil.DC, adc, ldc, hdc);
  AdjustAb(NakedAbil.MC, amc, lmc, hmc);
  AdjustAb(NakedAbil.SC, asc, lsc, hsc);
  AdjustAb(NakedAbil.AC, aac, lac, hac);
  AdjustAb(NakedAbil.MAC, amac, lmac, hmac);
  //lac  := 0;  hac := aac;
  //lmac := 0;  hmac := amac;

  m_WAbil.DC := MakeLong(LoWord(m_WAbil.DC) + ldc, HiWord(m_WAbil.DC) + hdc);
  m_WAbil.MC := MakeLong(LoWord(m_WAbil.MC) + lmc, HiWord(m_WAbil.MC) + hmc);
  m_WAbil.SC := MakeLong(LoWord(m_WAbil.SC) + lsc, HiWord(m_WAbil.SC) + hsc);
  m_WAbil.AC := MakeLong(LoWord(m_WAbil.AC) + lac, HiWord(m_WAbil.AC) + hac);
  m_WAbil.MAC := MakeLong(LoWord(m_WAbil.MAC) + lmac, HiWord(m_WAbil.MAC) + hmac);

  m_WAbil.MaxHP := _MIN(High(Word), m_WAbil.MaxHP + m_BonusAbil.HP div BonusTick.HP);
  m_WAbil.MaxMP := _MIN(High(Word), m_WAbil.MaxMP + m_BonusAbil.MP div BonusTick.MP);
  //      m_btSpeedPoint:=m_btSpeedPoint + m_BonusAbil.Speed div BonusTick.Speed;
  //      m_btHitPoint:=m_btHitPoint + m_BonusAbil.Hit div BonusTick.Hit;
end;

procedure TPlayObject.ClientAdjustBonus(nPoint: Integer; sMsg: string);
var
  BonusAbil: TNakedAbility;
  nTotleUsePoint: Integer;
  //m_nTotleUsePoint: Integer;
begin
  FillChar(BonusAbil, SizeOf(TNakedAbility), #0);
  DecodeBuffer(sMsg, @BonusAbil, SizeOf(TNakedAbility));
  nTotleUsePoint := BonusAbil.DC +
    BonusAbil.MC +
    BonusAbil.SC +
    BonusAbil.AC +
    BonusAbil.MAC +
    BonusAbil.HP +
    BonusAbil.MP +
    BonusAbil.Hit +
    BonusAbil.Speed +
    BonusAbil.X2;
  if ((nPoint + nTotleUsePoint) = m_nBonusPoint) and (m_nBonusPoint > 0) and (nPoint >= 0) and (m_nBonusPoint >= nPoint) then begin
    if nTotleUsePoint > 0 then begin
      m_nBonusPoint := nPoint;
      Inc(m_BonusAbil.DC, BonusAbil.DC);
      Inc(m_BonusAbil.MC, BonusAbil.MC);
      Inc(m_BonusAbil.SC, BonusAbil.SC);
      Inc(m_BonusAbil.AC, BonusAbil.AC);
      Inc(m_BonusAbil.MAC, BonusAbil.MAC);
      Inc(m_BonusAbil.HP, BonusAbil.HP);
      Inc(m_BonusAbil.MP, BonusAbil.MP);
      Inc(m_BonusAbil.Hit, BonusAbil.Hit);
      Inc(m_BonusAbil.Speed, BonusAbil.Speed);
      Inc(m_BonusAbil.X2, BonusAbil.X2);
      RecalcAbilitys();
      SendMsg(Self, RM_ABILITY, 0, 0, 0, 0, '');
      SendMsg(Self, RM_SUBABILITY, 0, 0, 0, 0, '');
    end;
  end else begin
    SysMsg('非法数据调整！！！', c_Red, t_Hint);
  end;
end;

function TPlayObject.GetMyStatus: Integer;
begin
  Result := m_nHungerStatus div 1000;
  if Result > 4 then Result := 4;
end;

procedure TPlayObject.SendAdjustBonus;
var
  sSENDMSG: string;
  //NakedAbil:TNakedAbility;
begin
  m_DefMsg := MakeDefaultMsg(SM_ADJUST_BONUS, m_nBonusPoint, 0, 0, 0);
  sSENDMSG := '';
  //NakedAbil:=m_BonusAbil;
  //FillChar(NakedAbil,SizeOf(TNakedAbility),#0);
  case m_btJob of //
    0: sSENDMSG := EncodeBuffer(@g_Config.BonusAbilofWarr, SizeOf(TNakedAbility)) + '/' +
      EncodeBuffer(@m_BonusAbil, SizeOf(TNakedAbility)) + '/' +
        EncodeBuffer(@g_Config.NakedAbilofWarr, SizeOf(TNakedAbility));
    1: sSENDMSG := EncodeBuffer(@g_Config.BonusAbilofWizard, SizeOf(TNakedAbility)) + '/' +
      EncodeBuffer(@m_BonusAbil, SizeOf(TNakedAbility)) + '/' +
        EncodeBuffer(@g_Config.NakedAbilofWizard, SizeOf(TNakedAbility));
    2: sSENDMSG := EncodeBuffer(@g_Config.BonusAbilofTaos, SizeOf(TNakedAbility)) + '/' +
      EncodeBuffer(@m_BonusAbil, SizeOf(TNakedAbility)) + '/' +
        EncodeBuffer(@g_Config.NakedAbilofTaos, SizeOf(TNakedAbility));
  end; // case
  SendSocket(@m_DefMsg, sSENDMSG);
end;

function TBaseObject.GetAttackDir(BaseObject: TBaseObject; var btDir: Byte): Boolean;
begin
  Result := False;
  if (m_nCurrX - 1 <= BaseObject.m_nCurrX) and
    (m_nCurrX + 1 >= BaseObject.m_nCurrX) and
    (m_nCurrY - 1 <= BaseObject.m_nCurrY) and
    (m_nCurrY + 1 >= BaseObject.m_nCurrY) and
    ((m_nCurrX <> BaseObject.m_nCurrX) or
    (m_nCurrY <> BaseObject.m_nCurrY)) then begin
    Result := True;
    if ((m_nCurrX - 1) = BaseObject.m_nCurrX) and (m_nCurrY = BaseObject.m_nCurrY) then begin
      btDir := DR_LEFT;
      Exit;
    end;
    if ((m_nCurrX + 1) = BaseObject.m_nCurrX) and (m_nCurrY = BaseObject.m_nCurrY) then begin
      btDir := DR_RIGHT;
      Exit;
    end;
    if (m_nCurrX = BaseObject.m_nCurrX) and ((m_nCurrY - 1) = BaseObject.m_nCurrY) then begin
      btDir := DR_UP;
      Exit;
    end;
    if (m_nCurrX = BaseObject.m_nCurrX) and ((m_nCurrY + 1) = BaseObject.m_nCurrY) then begin
      btDir := DR_DOWN;
      Exit;
    end;
    if ((m_nCurrX - 1) = BaseObject.m_nCurrX) and ((m_nCurrY - 1) = BaseObject.m_nCurrY) then begin
      btDir := DR_UPLEFT;
      Exit;
    end;
    if ((m_nCurrX + 1) = BaseObject.m_nCurrX) and ((m_nCurrY - 1) = BaseObject.m_nCurrY) then begin
      btDir := DR_UPRIGHT;
      Exit;
    end;
    if ((m_nCurrX - 1) = BaseObject.m_nCurrX) and ((m_nCurrY + 1) = BaseObject.m_nCurrY) then begin
      btDir := DR_DOWNLEFT;
      Exit;
    end;
    if ((m_nCurrX + 1) = BaseObject.m_nCurrX) and ((m_nCurrY + 1) = BaseObject.m_nCurrY) then begin
      btDir := DR_DOWNRIGHT;
      Exit;
    end;
    btDir := 0;
  end;
end;

function TBaseObject.TargetInSpitRange(BaseObject: TBaseObject; var btDir: Byte): Boolean; //004C3E68
var
  n14, n18: Integer;
begin
  Result := False;
  if (abs(BaseObject.m_nCurrX - m_nCurrX) <= 2) and (abs(BaseObject.m_nCurrY - m_nCurrY) <= 2) then begin
    n14 := BaseObject.m_nCurrX - m_nCurrX;
    n18 := BaseObject.m_nCurrY - m_nCurrY;
    if (abs(n14) <= 1) and (abs(n18) <= 1) then begin
      GetAttackDir(BaseObject, btDir);
      Result := True;
      Exit;
    end;
    Inc(n14, 2);
    Inc(n18, 2);
    if ((n14 >= 0) and (n14 <= 4)) and ((n18 >= 0) and (n18 <= 4)) then begin
      btDir := GetNextDirection(m_nCurrX, m_nCurrY, BaseObject.m_nCurrX, BaseObject.m_nCurrY);
      if g_Config.SpitMap[btDir, n18, n14] = 1 then
        Result := True;
    end;
  end;
end;

function TBaseObject.RecalcBagWeight: Integer;
var
  i: Integer;
  UserItem: pTUserItem;
  StdItem: pTStdItem;
begin
  Result := 0;
  for i := 0 to m_ItemList.Count - 1 do begin
    UserItem := m_ItemList.Items[i];
    if UserItem = nil then Continue;
    StdItem := UserEngine.GetStdItem(UserItem.wIndex);
    if StdItem <> nil then begin
      Inc(Result, StdItem.Weight);
    end;
  end;
end;

procedure TBaseObject.RecalcHitSpeed;
var
  i: Integer;
  UserMagic: pTUserMagic;
  BonusTick: pTNakedAbility;
begin
  BonusTick := nil;
  case m_btJob of
    0: BonusTick := @g_Config.BonusAbilofWarr;
    1: BonusTick := @g_Config.BonusAbilofWizard;
    2: BonusTick := @g_Config.BonusAbilofTaos;
  end;
  m_btHitPoint := DEFHIT + m_BonusAbil.Hit div BonusTick.Hit;

  case m_btJob of
    TAOS: m_btSpeedPoint := DEFSPEED + m_BonusAbil.Speed div BonusTick.Speed + 3; //档荤绰 扁夯 刮酶捞 臭促.
    else m_btSpeedPoint := DEFSPEED + m_BonusAbil.Speed div BonusTick.Speed;
  end;

  m_nHitPlus := 0;
  m_nHitDouble := 0;

  m_MagicOneSwordSkill := nil;
  m_MagicPowerHitSkill := nil;
  m_MagicErgumSkill := nil;
  m_MagicBanwolSkill := nil;
  m_MagicFireSwordSkill := nil;
  m_MagicCrsSkill := nil;
  m_Magic41Skill := nil;
  m_Magic42Skill := nil;
  m_Magic43Skill := nil;
  for i := 0 to m_MagicList.Count - 1 do begin
    UserMagic := m_MagicList.Items[i];
    if UserMagic = nil then Continue;
    case UserMagic.wMagIdx of
      SKILL_ONESWORD: begin //内功心法
          m_MagicOneSwordSkill := UserMagic;
          if UserMagic.btLevel > 0 then begin
            m_btHitPoint := m_btHitPoint + ROUND(9 / 3 * UserMagic.btLevel);
          end;
        end;
      SKILL_YEDO: begin //攻杀剑法
          m_MagicPowerHitSkill := UserMagic;
          if UserMagic.btLevel > 0 then begin
            m_btHitPoint := m_btHitPoint + ROUND(3 / 3 * UserMagic.btLevel);
          end;
          m_nHitPlus := DEFHIT + UserMagic.btLevel;
          m_btAttackSkillCount := 7 - UserMagic.btLevel;
          m_btAttackSkillPointCount := Random(m_btAttackSkillCount);
        end;
      SKILL_ERGUM: begin //刺杀剑法
          m_MagicErgumSkill := UserMagic;
        end;
      SKILL_BANWOL: begin //半月弯刀
          m_MagicBanwolSkill := UserMagic;
        end;
      SKILL_FIRESWORD: begin //烈火剑法
          m_MagicFireSwordSkill := UserMagic;
          m_nHitDouble := 4 + UserMagic.btLevel * 4;
        end;
      SKILL_ILKWANG: begin //基本剑法
          m_MagicOneSwordSkill := UserMagic;
          if UserMagic.btLevel > 0 then begin
            m_btHitPoint := m_btHitPoint + ROUND(8 / 3 * UserMagic.btLevel);
          end;
        end;
      40: begin //抱月弯刀
          m_MagicCrsSkill := UserMagic;
        end;
      41: begin
          m_Magic41Skill := UserMagic;
        end;
      42: begin
          m_Magic42Skill := UserMagic;
        end;
      43: begin
          m_Magic43Skill := UserMagic;
        end;
    end;
  end;
end;

procedure TBaseObject.AddItemSkill(nIndex: Integer);
var
  Magic: pTMagic;
  UserMagic: pTUserMagic;
begin
  Magic := nil;
  case nIndex of
    1: Magic := UserEngine.FindMagic(g_Config.sFireBallSkill);
    2: Magic := UserEngine.FindMagic(g_Config.sHealSkill);
  end;
  if Magic <> nil then begin
    if not IsTrainingSkill(Magic.wMagicId) then begin
      New(UserMagic);
      UserMagic.MagicInfo := Magic;
      UserMagic.wMagIdx := Magic.wMagicId;
      UserMagic.btKey := 0;
      UserMagic.btLevel := 1;
      UserMagic.nTranPoint := 0;
      m_MagicList.Add(UserMagic);
      if m_btRaceServer = RC_PLAYOBJECT then begin
        TPlayObject(Self).SendAddMagic(UserMagic);
      end;
    end;
  end;
end;

function TBaseObject.AddToMap: Boolean;
var
  Point: Pointer;
begin
  Result := False;
  Point := m_PEnvir.AddToMap(m_nCurrX, m_nCurrY, OS_MOVINGOBJECT, Self);
  if Point <> nil then Result := True
  else Result := False;
  if not m_boFixedHideMode then
    SendRefMsg(RM_TURN, m_btDirection, m_nCurrX, m_nCurrY, 0, '');
end;

procedure TBaseObject.AttackDir(TargeTBaseObject: TBaseObject; wHitMode: Word;
  nDir: Integer);
  function GetMagicSpell(UserMagic: pTUserMagic): Integer;
  begin
    Result := ROUND(UserMagic.MagicInfo.wSpell / (UserMagic.MagicInfo.btTrainLv + 1) * (UserMagic.btLevel + 1));
  end;
  //武器升级设置
  procedure CheckWeaponUpgradeStatus(UserItem: pTUserItem); //004C27C0
  begin
    //if (UserItem.btValue[0] + UserItem.btValue[1] + UserItem.btValue[2]) < 20 then begin
    if (UserItem.btValue[0] + UserItem.btValue[1] + UserItem.btValue[2]) < g_Config.nUpgradeWeaponMaxPoint then begin
      case UserItem.btValue[10] of
        1: UserItem.wIndex := 0;
        10..13: UserItem.btValue[0] := UserItem.btValue[0] + UserItem.btValue[10] - 9;
        20..23: UserItem.btValue[1] := UserItem.btValue[1] + UserItem.btValue[10] - 19;
        30..33: UserItem.btValue[2] := UserItem.btValue[2] + UserItem.btValue[10] - 29;
      end;
    end else UserItem.wIndex := 0;
    UserItem.btValue[10] := 0;
  end;
  procedure CheckWeaponUpgrade();
  var
    UseItems: TUserItem;
    PlayObject: TPlayObject;
    StdItem: pTStdItem;
  begin
    if m_UseItems[U_WEAPON].btValue[10] > 0 then begin
      UseItems := m_UseItems[U_WEAPON];
      CheckWeaponUpgradeStatus(@m_UseItems[U_WEAPON]);
      if m_UseItems[U_WEAPON].wIndex = 0 then begin
        SysMsg(g_sTheWeaponBroke, c_Red, t_Hint);
        PlayObject := TPlayObject(Self);
        PlayObject.SendDelItems(@UseItems);
        //PlayObject.StatusChanged;
        SendRefMsg(RM_BREAKWEAPON, 0, 0, 0, 0, '');
        StdItem := UserEngine.GetStdItem(UseItems.wIndex);
        //004C29E0
        if StdItem.NeedIdentify = 1 then
          AddGameDataLog('21' + #9 +
            m_sMapName + #9 +
            IntToStr(m_nCurrX) + #9 +
            IntToStr(m_nCurrY) + #9 +
            m_sCharName + #9 +
            //UserEngine.GetStdItemName(UseItems.wIndex) + #9 +
            StdItem.Name + #9 +
            IntToStr(UseItems.MakeIndex) + #9 +
            '1' + #9 +
            '0');
        FeatureChanged();
      end else begin
        SysMsg(sTheWeaponRefineSuccessfull, c_Red, t_Hint);
        PlayObject := TPlayObject(Self);
        PlayObject.SendUpdateItem(@m_UseItems[U_WEAPON]);
        StdItem := UserEngine.GetStdItem(UseItems.wIndex);
        //004C2B14
        if StdItem.NeedIdentify = 1 then
          AddGameDataLog('20' + #9 +
            m_sMapName + #9 +
            IntToStr(m_nCurrX) + #9 +
            IntToStr(m_nCurrY) + #9 +
            m_sCharName + #9 +
            //UserEngine.GetStdItemName(UseItems.wIndex) + #9 +
            StdItem.Name + #9 +
            IntToStr(UseItems.MakeIndex) + #9 +
            '1' + #9 +
            '0');
        RecalcAbilitys();
        SendMsg(Self, RM_ABILITY, 0, 0, 0, 0, '');
        SendMsg(Self, RM_SUBABILITY, 0, 0, 0, 0, '');
      end;
    end;
  end;
var
  AttackTarget: TBaseObject;
  boPowerHit: Boolean;
  boFireHit: Boolean;
  boCrsHit: Boolean;
  bo41: Boolean;
  bo42: Boolean;
  bo43: Boolean;
  wIdent: Word;
  nCheckCode: Integer;
resourcestring
  sExceptionMsg = '[Exception] TBaseObject::AttackDir Code: %d';
begin
  nCheckCode := 0;
  try
    if (wHitMode = 5) and (m_MagicBanwolSkill <> nil) then begin //半月
      if m_WAbil.MP > 0 then begin
        nCheckCode := 1;
        DamageSpell(m_MagicBanwolSkill.MagicInfo.btDefSpell + GetMagicSpell(m_MagicBanwolSkill));
        nCheckCode := 2;
        HealthSpellChanged();
        nCheckCode := 3;
      end else wHitMode := RM_HIT;
    end;
    nCheckCode := 4;
    m_btDirection := nDir;
    if TargeTBaseObject = nil then begin
      nCheckCode := 41;
      AttackTarget := GetPoseCreate();
    end else AttackTarget := TargeTBaseObject;
    if (AttackTarget <> nil) and (m_UseItems[U_WEAPON].wIndex > 0) then begin
      nCheckCode := 42;
      if m_btRaceServer = RC_PLAYOBJECT then
        CheckWeaponUpgrade();
    end;
    nCheckCode := 5;
    boPowerHit := m_boPowerHit;
    boFireHit := m_boFireHitSkill;
    boCrsHit := m_boCrsHitkill;
    bo41 := m_bo41kill;
    bo42 := m_bo42kill;
    bo43 := m_bo43kill;
    if _Attack(wHitMode, AttackTarget) then begin
      nCheckCode := 6;
      SetTargetCreat(AttackTarget);
      nCheckCode := 7;
    end;
    wIdent := RM_HIT;
    if (m_btRaceServer = RC_PLAYOBJECT) or (m_btRaceServer = RC_PLAYMOSTER) then begin {增加分身魔法攻击}
      case wHitMode of
        0: wIdent := RM_HIT;
        1: wIdent := RM_HEAVYHIT;
        2: wIdent := RM_BIGHIT;
        3: if boPowerHit then wIdent := RM_SPELL2;
        4: if m_MagicErgumSkill <> nil then wIdent := RM_LONGHIT;
        5: if m_MagicBanwolSkill <> nil then wIdent := RM_WIDEHIT;
        7: if boFireHit then wIdent := RM_FIREHIT;
        8: if m_MagicCrsSkill <> nil then wIdent := RM_CRSHIT;
        9: if m_Magic42Skill <> nil then wIdent := RM_41;
        10: if bo42 then wIdent := RM_42;
        11: if bo43 then wIdent := RM_43;
      end;
    end;
    nCheckCode := 8;
    SendAttackMsg(wIdent, m_btDirection, m_nCurrX, m_nCurrY);
    nCheckCode := 9;
  except
    on E: Exception do begin
      MainOutMessage(format(sExceptionMsg, [nCheckCode]));
      MainOutMessage(E.Message);
    end;
  end;
end;

procedure TBaseObject.CheckPKStatus;
begin
  if m_boPKFlag and ((GetTickCount - m_dwPKTick) > g_Config.dwPKFlagTime {60 * 1000}) then begin
    m_boPKFlag := False;
    RefNameColor();
  end;
end;

procedure TBaseObject.DamageSpell(nSpellPoint: Integer);
begin
  if nSpellPoint > 0 then begin
    if (m_WAbil.MP - nSpellPoint) > 0 then
      Dec(m_WAbil.MP, nSpellPoint)
    else m_WAbil.MP := 0;
  end else begin
    if (m_WAbil.MP - nSpellPoint) < m_WAbil.MaxMP then
      Dec(m_WAbil.MP, nSpellPoint)
    else m_WAbil.MP := m_WAbil.MaxMP;
  end;
end;

procedure TBaseObject.DecPKPoint(nPoint: Integer);
var
  nC: Integer;
begin
  nC := PKLevel();
  Dec(m_nPkPoint, nPoint);
  if m_nPkPoint < 0 then m_nPkPoint := 0;
  if (PKLevel <> nC) and (nC > 0) and (nC <= 2) then begin
    RefNameColor();
  end;
end;

procedure TBaseObject.DelItemSkill(nIndex: Integer);
  procedure DELETESKILL(sSkillName: string);
  var
    i: Integer;
    UserMagic: pTUserMagic;
    PlayObject: TPlayObject;
  begin
    for i := 0 to m_MagicList.Count - 1 do begin
      UserMagic := m_MagicList.Items[i];
      if UserMagic.MagicInfo.sMagicName = sSkillName then begin
        PlayObject := TPlayObject(Self);
        PlayObject.SendDelMagic(UserMagic);
        DisPose(UserMagic);
        m_MagicList.Delete(i);
        break;
      end;
    end;
  end;
begin
  if m_btRaceServer <> RC_PLAYOBJECT then Exit;
  case nIndex of
    1: if m_btJob <> 1 then DELETESKILL(g_Config.sFireBallSkill);
    2: if m_btJob <> 2 then DELETESKILL(g_Config.sHealSkill)
  end;
end;

procedure TBaseObject.DelMember(BaseObject: TBaseObject);
var
  i: Integer;
  PlayObject: TPlayObject;
begin
  if m_GroupOwner <> BaseObject then begin
    for i := m_GroupMembers.Count - 1 downto 0 do begin
      if m_GroupMembers.Count <= 0 then break;
      if (m_GroupMembers.Objects[i] <> nil) and (m_GroupMembers.Objects[i] = BaseObject) then begin
        BaseObject.LeaveGroup();
        m_GroupMembers.Delete(i);
        break;
      end;
    end;
  end else begin
    for i := m_GroupMembers.Count - 1 downto 0 do begin
      if m_GroupMembers.Count <= 0 then break;
      if TBaseObject(m_GroupMembers.Objects[i]) <> nil then begin
        TBaseObject(m_GroupMembers.Objects[i]).LeaveGroup;
        m_GroupMembers.Delete(i);
      end;
    end;
  end;
  PlayObject := TPlayObject(Self);
  if not PlayObject.CancelGroup then begin
    PlayObject.SendDefMessage(SM_GROUPCANCEL, 0, 0, 0, 0, '');
  end else PlayObject.SendGroupMembers();
end;

procedure TBaseObject.DoDamageWeapon(nWeaponDamage: Integer);
var
  nDura, nDuraPoint: Integer;
  PlayObject: TPlayObject;
  StdItem: pTStdItem;
begin
  if m_UseItems[U_WEAPON].wIndex <= 0 then Exit;
  nDura := m_UseItems[U_WEAPON].Dura;
  nDuraPoint := ROUND(nDura / 1.03);
  Dec(nDura, nWeaponDamage);
  if nDura <= 0 then begin
    nDura := 0;
    m_UseItems[U_WEAPON].Dura := nDura;
    if m_btRaceServer = RC_PLAYOBJECT then begin
      PlayObject := TPlayObject(Self);
      PlayObject.SendDelItems(@m_UseItems[U_WEAPON]);
      StdItem := UserEngine.GetStdItem(m_UseItems[U_WEAPON].wIndex);
      //004C195A
      if StdItem.NeedIdentify = 1 then
        AddGameDataLog('3' + #9 +
          m_sMapName + #9 +
          IntToStr(m_nCurrX) + #9 +
          IntToStr(m_nCurrY) + #9 +
          m_sCharName + #9 +
          //UserEngine.GetStdItemName(m_UseItems[U_WEAPON].wIndex) + #9 +
          StdItem.Name + #9 +
          IntToStr(m_UseItems[U_WEAPON].MakeIndex) + #9 +
          BoolToIntStr(m_btRaceServer = RC_PLAYOBJECT) + #9 +
          '0');
    end;
    m_UseItems[U_WEAPON].wIndex := 0;
    SendMsg(Self, RM_DURACHANGE, U_WEAPON, nDura, m_UseItems[U_WEAPON].DuraMax, 0, '');
  end else begin //004C199D
    m_UseItems[U_WEAPON].Dura := nDura;
  end;
  if (nDura / 1.03) <> nDuraPoint then begin
    SendMsg(Self, RM_DURACHANGE, U_WEAPON, m_UseItems[U_WEAPON].Dura, m_UseItems[U_WEAPON].DuraMax, 0, '');
  end;
end;

procedure TBaseObject.GetAccessory(Item: TUserItem; var AddAbility: TAddAbility); //004C0EBC
var
  StdItem: pTStdItem;
  StdItemA: TStdItem;
begin
  StdItem := UserEngine.GetStdItem(Item.wIndex);
  if StdItem = nil then Exit;
  StdItemA := StdItem^;
  ItemUnit.GetItemAddValue(@Item, StdItemA);
  case StdItem.StdMode of
    5, 6: begin //004C0F63
        Inc(AddAbility.wHitPoint, HiWord(StdItemA.AC));
        if HiWord(StdItemA.MAC) > 10 then begin
          Inc(AddAbility.nHitSpeed, HiWord(StdItemA.MAC) - 10);
        end else begin
          Dec(AddAbility.nHitSpeed, HiWord(StdItemA.MAC));
        end;
        Inc(AddAbility.btLuck, LoWord(StdItemA.AC));
        Inc(AddAbility.btUnLuck, LoWord(StdItemA.MAC));
      end;
    19: begin //004C0FBE
        Inc(AddAbility.wAntiMagic, HiWord(StdItemA.AC));
        Inc(AddAbility.btUnLuck, LoWord(StdItemA.MAC));
        Inc(AddAbility.btLuck, HiWord(StdItemA.MAC));
      end;
    53: begin //新加物品属性
        if not g_Config.boAddUserItemNewValue then begin
          Inc(AddAbility.wAntiMagic, HiWord(StdItemA.AC));
          Inc(AddAbility.btUnLuck, LoWord(StdItemA.MAC));
          Inc(AddAbility.btLuck, HiWord(StdItemA.MAC));
        end else begin
          AddAbility.wAC := MakeLong(LoWord(AddAbility.wAC) + LoWord(StdItemA.AC), HiWord(AddAbility.wAC) + HiWord(StdItemA.AC));
          AddAbility.wMAC := MakeLong(LoWord(AddAbility.wMAC) + LoWord(StdItemA.MAC), HiWord(AddAbility.wMAC) + HiWord(StdItemA.MAC));
        end;
      end;
    20, 24: begin //004C0FF0
        Inc(AddAbility.wHitPoint, HiWord(StdItemA.AC));
        Inc(AddAbility.wSpeedPoint, HiWord(StdItemA.MAC));
      end;
    52: begin //原本与 20,24 一个属性，现在分开单独进行设置
        if not g_Config.boAddUserItemNewValue then begin
          Inc(AddAbility.wHitPoint, HiWord(StdItemA.AC));
          Inc(AddAbility.wSpeedPoint, HiWord(StdItemA.MAC));
        end else begin
          AddAbility.wAC := MakeLong(LoWord(AddAbility.wAC) + LoWord(StdItemA.AC), HiWord(AddAbility.wAC) + HiWord(StdItemA.AC));
          AddAbility.wMAC := MakeLong(LoWord(AddAbility.wMAC) + LoWord(StdItemA.MAC), HiWord(AddAbility.wMAC) + HiWord(StdItemA.MAC));
        end;
      end;
    21: begin
        Inc(AddAbility.wHealthRecover, HiWord(StdItemA.AC));
        Inc(AddAbility.wSpellRecover, HiWord(StdItemA.MAC));
        Inc(AddAbility.nHitSpeed, LoWord(StdItemA.AC));
        Dec(AddAbility.nHitSpeed, LoWord(StdItemA.MAC));
      end;
    54: begin
        if not g_Config.boAddUserItemNewValue then begin
          Inc(AddAbility.wHealthRecover, HiWord(StdItemA.AC));
          Inc(AddAbility.wSpellRecover, HiWord(StdItemA.MAC));
          Inc(AddAbility.nHitSpeed, LoWord(StdItemA.AC));
          Dec(AddAbility.nHitSpeed, LoWord(StdItemA.MAC));
        end else begin
          AddAbility.wAC := MakeLong(LoWord(AddAbility.wAC) + LoWord(StdItemA.AC), HiWord(AddAbility.wAC) + HiWord(StdItemA.AC));
          AddAbility.wMAC := MakeLong(LoWord(AddAbility.wMAC) + LoWord(StdItemA.MAC), HiWord(AddAbility.wMAC) + HiWord(StdItemA.MAC));
        end;
      end;
    23: begin
        Inc(AddAbility.wAntiPoison, HiWord(StdItemA.AC));
        Inc(AddAbility.wPoisonRecover, HiWord(StdItemA.MAC));
        Inc(AddAbility.nHitSpeed, LoWord(StdItemA.AC));
        Dec(AddAbility.nHitSpeed, LoWord(StdItemA.MAC));
      end;
    else begin
        AddAbility.wAC := MakeLong(LoWord(AddAbility.wAC) + LoWord(StdItemA.AC), HiWord(AddAbility.wAC) + HiWord(StdItemA.AC));
        AddAbility.wMAC := MakeLong(LoWord(AddAbility.wMAC) + LoWord(StdItemA.MAC), HiWord(AddAbility.wMAC) + HiWord(StdItemA.MAC));
      end;
  end;
  AddAbility.wDC := MakeLong(LoWord(AddAbility.wDC) + LoWord(StdItemA.DC), HiWord(AddAbility.wDC) + HiWord(StdItemA.DC));
  AddAbility.wMC := MakeLong(LoWord(AddAbility.wMC) + LoWord(StdItemA.MC), HiWord(AddAbility.wMC) + HiWord(StdItemA.MC));
  AddAbility.wSC := MakeLong(LoWord(AddAbility.wSC) + LoWord(StdItemA.SC), HiWord(AddAbility.wSC) + HiWord(StdItemA.SC));
end;

//004BF180
{
function TBaseObject.GetCharColor(BaseObject:TBaseObject): Byte;
var
  n10:Integer;
  nCheckCode:Integer;
begin
  nCheckCode:=0;
try
  Result:=BaseObject.GetNamecolor();
  nCheckCode:=1;
  if BaseObject.m_btRaceServer = RC_PLAYOBJECT then begin
    if BaseObject.PKLevel < 2 then begin
      if BaseObject.m_boPKFlag then Result:=g_Config.btPKFlagNameColor;//$2F
      nCheckCode:=2;
      n10:=GetGuildRelation(Self,BaseObject);
      nCheckCode:=3;
      case n10 of
        1,3: Result:=g_Config.btAllyAndGuildNameColor;//$B4;
        2: Result:=g_Config.btWarGuildNameColor;//$45;
      end;
      if BaseObject.m_PEnvir.m_boFight3Zone then begin
        if m_MyGuild = BaseObject.m_MyGuild then Result:=g_Config.btAllyAndGuildNameColor//$B4
        else Result:=g_Config.btWarGuildNameColor//$45;
      end;
    end; //004BF218
    nCheckCode:=4;
    if UserCastle.m_boUnderWar and m_boInFreePKArea and BaseObject.m_boInFreePKArea then begin
      nCheckCode:=5;
      Result:=g_Config.btInFreePKAreaNameColor;//$DD;
      m_boGuildWarArea:=True;
      nCheckCode:=6;
      if (m_MyGuild = nil) then exit;
      if UserCastle.IsMasterGuild(TGuild(m_MyGuild)) then begin
        nCheckCode:=7;
        if (m_MyGuild = BaseObject.m_MyGuild) or
           (TGuild(m_MyGuild).IsAllyGuild(TGuild(BaseObject.m_MyGuild))) then begin
          nCheckCode:=8;
          Result:=g_Config.btAllyAndGuildNameColor//$B4;
        end else begin //004BF2A8
          nCheckCode:=9;
          if UserCastle.IsAttackGuild(TGuild(BaseObject.m_MyGuild)) then begin
            nCheckCode:=10;
            Result:=g_Config.btWarGuildNameColor//$45;
          end;
        end;
      end else begin //004BF2CE
        nCheckCode:=11;
        if UserCastle.IsAttackGuild(TGuild(m_MyGuild)) then begin
          nCheckCode:=12;
          if (m_MyGuild = BaseObject.m_MyGuild) or
             (TGuild(m_MyGuild).IsAllyGuild(TGuild(BaseObject.m_MyGuild))) then begin
            nCheckCode:=13;
            Result:=g_Config.btAllyAndGuildNameColor//$B4;
          end else begin
            nCheckCode:=14;
            if UserCastle.IsMember(BaseObject) then begin
              nCheckCode:=15;
              Result:=g_Config.btWarGuildNameColor//$45;
            end;
          end;
        end; //004BF379
      end;
    end;
  end else begin //004BF339
    //if (BaseObject.m_btSlaveExpLevel - 8) < 0 then begin
    if (BaseObject.m_btSlaveExpLevel < SLAVEMAXLEVEL) then begin
      Result:=g_Config.SlaveColor[BaseObject.m_btSlaveExpLevel];
    end;
    if BaseObject.m_boCrazyMode then Result:=$F9;
    if BaseObject.m_boHolySeize then Result:=$7D;
  end;
except
  on e: Exception do begin
    MainOutMessage('[Exception] TBaseObject.GetCharColor Code: ' + IntToStr(nCheckCode));
    MainOutMessage(E.Message);
  end;
end;
end;
}
function TBaseObject.GetCharColor(BaseObject: TBaseObject): Byte;
var
  n10: Integer;
  nCheckCode: Integer;
  Castle: TUserCastle;
begin
  nCheckCode := 0;
  Result := BaseObject.GetNamecolor();
  nCheckCode := 1;
  if BaseObject.m_btRaceServer = RC_PLAYOBJECT then begin
    if BaseObject.PKLevel < 2 then begin
      if BaseObject.m_boPKFlag then Result := g_Config.btPKFlagNameColor; //$2F
      nCheckCode := 2;
      n10 := GetGuildRelation(Self, BaseObject);
      nCheckCode := 3;
      case n10 of
        1, 3: Result := g_Config.btAllyAndGuildNameColor; //$B4;
        2: Result := g_Config.btWarGuildNameColor; //$45;
      end;
      if BaseObject.m_PEnvir.m_boFight3Zone then begin
        if m_MyGuild = BaseObject.m_MyGuild then Result := g_Config.btAllyAndGuildNameColor //$B4
        else Result := g_Config.btWarGuildNameColor //$45;
      end;
    end; //004BF218
    nCheckCode := 4;
    Castle := g_CastleManager.InCastleWarArea(BaseObject);
    //    if  UserCastle.m_boUnderWar and m_boInFreePKArea and BaseObject.m_boInFreePKArea then begin
    if (Castle <> nil) and Castle.m_boUnderWar and m_boInFreePKArea and BaseObject.m_boInFreePKArea then begin
      nCheckCode := 5;
      Result := g_Config.btInFreePKAreaNameColor; //$DD;
      m_boGuildWarArea := True;
      nCheckCode := 6;
      if (m_MyGuild = nil) then Exit;
      //      if UserCastle.IsMasterGuild(TGuild(m_MyGuild)) then begin
      if Castle.IsMasterGuild(TGUild(m_MyGuild)) then begin
        nCheckCode := 7;
        if (m_MyGuild = BaseObject.m_MyGuild) or
          (TGUild(m_MyGuild).IsAllyGuild(TGUild(BaseObject.m_MyGuild))) then begin
          nCheckCode := 8;
          Result := g_Config.btAllyAndGuildNameColor //$B4;
        end else begin //004BF2A8
          nCheckCode := 9;
          //if UserCastle.IsAttackGuild(TGuild(BaseObject.m_MyGuild)) then begin
          if Castle.IsAttackGuild(TGUild(BaseObject.m_MyGuild)) then begin
            nCheckCode := 10;
            Result := g_Config.btWarGuildNameColor //$45;
          end;
        end;
      end else begin //004BF2CE
        nCheckCode := 11;
        //        if UserCastle.IsAttackGuild(TGuild(m_MyGuild)) then begin
        if Castle.IsAttackGuild(TGUild(m_MyGuild)) then begin
          nCheckCode := 12;
          if (m_MyGuild = BaseObject.m_MyGuild) or
            (TGUild(m_MyGuild).IsAllyGuild(TGUild(BaseObject.m_MyGuild))) then begin
            nCheckCode := 13;
            Result := g_Config.btAllyAndGuildNameColor //$B4;
          end else begin
            nCheckCode := 14;
            //            if UserCastle.IsMember(BaseObject) then begin
            if Castle.IsMember(BaseObject) then begin
              nCheckCode := 15;
              Result := g_Config.btWarGuildNameColor //$45;
            end;
          end;
        end; //004BF379
      end;
    end;
  end else begin //004BF339
    //if (BaseObject.m_btSlaveExpLevel - 8) < 0 then begin
    if (BaseObject.m_btSlaveExpLevel < SLAVEMAXLEVEL) then begin
      Result := g_Config.SlaveColor[BaseObject.m_btSlaveExpLevel];
    end;
    if BaseObject.m_boCrazyMode then Result := $F9;
    if BaseObject.m_boHolySeize then Result := $7D;
  end;
end;

function TBaseObject.GetLevelExp(nLevel: Integer): LongWord;
  function GetBaseExp(): Integer;
  var
    nInt64: Int64;
  begin
    nInt64 := (nLevel - 1000) * g_Config.nAddExp + g_Config.nBaseExp;
    if nInt64 > High(LongWord) then Result := High(LongWord) else Result := nInt64;
  end;
begin
  if nLevel <= MAXCHANGELEVEL {1000} then begin
    Result := g_Config.dwNeedExps[nLevel];
    Exit;
  end;
  if g_Config.boUseFixExp then begin
    if nLevel <= MAXLEVEL then begin
      Result := 2000000000 + nLevel * 1500;
    end else begin
      Result := High(LongWord); //g_Config.dwNeedExps[High(g_Config.dwNeedExps)];
    end;
  end else begin
    if nLevel <= MAXLEVEL then begin
      Result := GetBaseExp();
    end else begin
      Result := High(LongWord);
    end;
  end;
end;

function TBaseObject.GetNamecolor(): Byte;
begin
  Result := m_btNameColor;
  if PKLevel = 1 then Result := g_Config.btPKLevel1NameColor; //$FB;
  if PKLevel >= 2 then Result := g_Config.btPKLevel2NameColor; //$F9;
end;

procedure TBaseObject.HearMsg(sMsg: string);
begin
  if sMsg <> '' then SendMsg(nil, RM_HEAR, 0, g_Config.btHearMsgFColor, g_Config.btHearMsgBColor, 0, sMsg);
end;

{function TBaseObject.InSafeArea(): Boolean;
var
  i: Integer;
  SC: string;
  nStartX,nStartY:Integer;
  nEndX,nEndY:Integer;
  StartPoint: pTStartPoint;
begin
  Result := m_PEnvir.m_boSAFE;
  if Result then Exit;
  try
    g_StartPointList.Lock;
    for i := 0 to g_StartPointList.Count - 1 do begin
      SC := g_StartPointList.Strings[i];
      if SC = m_PEnvir.sMapName then begin
        StartPoint := pTStartPoint(g_StartPointList.Objects[i]);
        if StartPoint <> nil then begin
          nStartX:=StartPoint.m_nCurrX - StartPoint.m_nRange;
          nEndX:=StartPoint.m_nCurrX + StartPoint.m_nRange;
          nStartY:=StartPoint.m_nCurrY - StartPoint.m_nRange;
          nEndY:=StartPoint.m_nCurrY - StartPoint.m_nRange;
          if (m_nCurrX in [nStartX..nEndX]) and (m_nCurrY in [nStartY..nEndY]) then begin
            Result := True;
            break;
          end;
        end;
      end;
    end;
  finally
    g_StartPointList.UnLock;
  end;
end; }
function TBaseObject.InSafeArea(): Boolean;
var
  i: Integer;
  SC: string;
  n14, n18: Integer;
  StartPoint: pTStartPoint;
begin
  Result := m_PEnvir.m_boSAFE;
  if Result then Exit;
  try
    g_StartPointList.Lock;
    for i := 0 to g_StartPointList.Count - 1 do begin
      SC := g_StartPointList.Strings[i];
      if SC = m_PEnvir.sMapName then begin
        StartPoint := pTStartPoint(g_StartPointList.Objects[i]);
        if StartPoint <> nil then begin
          //n1C := Integer(g_StartPointList.Objects[i]);
          n14 := StartPoint.m_nCurrX;
          n18 := StartPoint.m_nCurrY;
          if (abs(m_nCurrX - n14) <= 60) and (abs(m_nCurrY - n18) <= 60) then begin
            Result := True;
            break;
          end;
        end;
      end;
    end;
  finally
    g_StartPointList.UnLock;
  end;
end;

procedure TBaseObject.MonsterRecalcAbilitys;
var
  n8: Integer;
begin
  m_WAbil.DC := MakeLong(LoWord(m_WAbil.DC), HiWord(m_Abil.DC));
  n8 := 0;
  if (m_btRaceServer = 100) or
    (m_btRaceServer = 113) or
    (m_btRaceServer = 114) then begin

    m_WAbil.DC := MakeLong(LoWord(m_WAbil.DC), ROUND((m_btSlaveExpLevel * {1.0e-1} 0.1 + {3.0000000000000000001e-1} 0.3) * {3.0} 3.0 * m_btSlaveExpLevel + HiWord(m_WAbil.DC)));
    n8 := n8 + ROUND((m_btSlaveExpLevel * {1.0e-1} 0.1 + {3.0000000000000000001e-1} 0.3) * m_Abil.MaxHP) * m_btSlaveExpLevel;
    n8 := n8 + m_Abil.MaxHP;
    if m_btSlaveExpLevel > 0 then m_WAbil.MaxHP := n8
    else m_WAbil.MaxHP := m_Abil.MaxHP;
  end else begin //004BEA85
    n8 := m_Abil.MaxHP;
    m_WAbil.DC := MakeLong(LoWord(m_WAbil.DC), ROUND(m_btSlaveExpLevel * 2 + HiWord(m_WAbil.DC)));
    n8 := n8 + ROUND(m_Abil.MaxHP * {1.5000000000000000001e-1} 0.15) * m_btSlaveExpLevel;
    m_WAbil.MaxHP := _MIN(ROUND(m_Abil.MaxHP + m_btSlaveExpLevel * 60), n8);
    //m_WAbil.MAC:=0; 01/20 取消此行，防止怪物升级后魔防变0
  end;
  //m_btHitPoint:=15; 01/20 取消此行，防止怪物升级后准确率变15
end;

procedure TPlayObject.ShowMapInfo(sMAP, sX, sY: string);
var
  Map: TEnvirnoment;
  nX, nY: Integer;
  MapCellInfo: pTMapCellinfo;
begin
  nX := Str_ToInt(sX, 0);
  nY := Str_ToInt(sY, 0);
  if (sMAP <> '') and (nX >= 0) and (nY >= 0) then begin
    Map := g_MapManager.FindMap(sMAP);
    if Map <> nil then begin
      if Map.GetMapCellInfo(nX, nY, MapCellInfo) then begin
        SysMsg('标志: ' + IntToStr(MapCellInfo.chFlag), c_Green, t_Hint);
        if MapCellInfo.ObjList <> nil then begin
          SysMsg('对象数: ' + IntToStr(MapCellInfo.ObjList.Count), c_Green, t_Hint);
        end;
      end else begin
        SysMsg('取地图单元信息失败: ' + sMAP, c_Red, t_Hint);
      end;
    end;
  end else begin
    SysMsg('请按正确格式输入: ' + g_GameCommand.MAPINFO.sCmd + ' 地图号 X Y', c_Green, t_Hint);
  end;
end;

procedure TBaseObject.SendFirstMsg(BaseObject: TBaseObject; wIdent, wParam: Word;
  lParam1, lParam2, lParam3: Integer; sMsg: string);
var
  SendMessage: pTSendMessage;
begin
  try
    EnterCriticalSection(ProcessMsgCriticalSection);
    if not m_boGhost then begin
      New(SendMessage);
      SendMessage.wIdent := wIdent;
      SendMessage.wParam := wParam;
      SendMessage.nParam1 := lParam1;
      SendMessage.nParam2 := lParam2;
      SendMessage.nParam3 := lParam3;
      SendMessage.dwDeliveryTime := 0;
      SendMessage.BaseObject := BaseObject;
      if sMsg <> '' then begin
        try
          GetMem(SendMessage.Buff, Length(sMsg) + 1);
          Move(sMsg[1], SendMessage.Buff^, Length(sMsg) + 1);
        except
          SendMessage.Buff := nil;
        end;
      end else begin
        SendMessage.Buff := nil;
      end;
      m_MsgList.Insert(0, SendMessage);
    end;
  finally
    LeaveCriticalSection(ProcessMsgCriticalSection);
  end;
end;

procedure TBaseObject.SendMsg(BaseObject: TBaseObject; wIdent, wParam: Word; nParam1, nParam2, nParam3: Integer; sMsg: string); //004B865C
var
  SendMessage: pTSendMessage;
begin
  try
    EnterCriticalSection(ProcessMsgCriticalSection);
    if not m_boGhost then begin
      New(SendMessage);
      SendMessage.wIdent := wIdent;
      SendMessage.wParam := wParam;
      SendMessage.nParam1 := nParam1;
      SendMessage.nParam2 := nParam2;
      SendMessage.nParam3 := nParam3;
      SendMessage.dwDeliveryTime := 0;
      SendMessage.BaseObject := BaseObject;
      SendMessage.boLateDelivery := False;
      if sMsg <> '' then begin
        try
          GetMem(SendMessage.Buff, Length(sMsg) + 1);
          Move(sMsg[1], SendMessage.Buff^, Length(sMsg) + 1);
        except
          SendMessage.Buff := nil;
        end;
      end else begin
        SendMessage.Buff := nil;
      end;
      m_MsgList.Add(SendMessage);
    end;
  finally
    LeaveCriticalSection(ProcessMsgCriticalSection);
  end;
end;

procedure TBaseObject.SendDelayMsg(BaseObject: TBaseObject; wIdent,
  wParam: Word; lParam1, lParam2, lParam3: Integer; sMsg: string;
  dwDelay: LongWord);
var
  SendMessage: pTSendMessage;
begin
  try
    EnterCriticalSection(ProcessMsgCriticalSection);
    if not m_boGhost then begin
      New(SendMessage);
      SendMessage.wIdent := wIdent;
      SendMessage.wParam := wParam;
      SendMessage.nParam1 := lParam1;
      SendMessage.nParam2 := lParam2;
      SendMessage.nParam3 := lParam3;
      SendMessage.dwDeliveryTime := GetTickCount + dwDelay;
      SendMessage.BaseObject := BaseObject;
      SendMessage.boLateDelivery := True;
      if sMsg <> '' then begin
        try
          GetMem(SendMessage.Buff, Length(sMsg) + 1);
          Move(sMsg[1], SendMessage.Buff^, Length(sMsg) + 1);
        except
          SendMessage.Buff := nil;
        end;
      end else begin
        SendMessage.Buff := nil;
      end;
      m_MsgList.Add(SendMessage);
    end;
  finally
    LeaveCriticalSection(ProcessMsgCriticalSection);
  end;
end;

procedure TBaseObject.SendUpdateDelayMsg(BaseObject: TBaseObject; wIdent,
  wParam: Word; lParam1, lParam2, lParam3: Integer; sMsg: string;
  dwDelay: LongWord);
var
  SendMessage: pTSendMessage;
  i: Integer;
begin
  EnterCriticalSection(ProcessMsgCriticalSection);
  try
    i := 0;
    while (True) do begin
      if m_MsgList.Count <= i then break;
      SendMessage := m_MsgList.Items[i];
      if (SendMessage.wIdent = wIdent) and (SendMessage.nParam1 = lParam1) then begin
        m_MsgList.Delete(i);
        if SendMessage.Buff <> nil then FreeMem(SendMessage.Buff);
        DisPose(SendMessage);
        Continue;
      end;
      Inc(i);
    end;
  finally
    LeaveCriticalSection(ProcessMsgCriticalSection);
  end;
  SendDelayMsg(BaseObject, wIdent, wParam, lParam1, lParam2, lParam3, sMsg, dwDelay);
end;

procedure TBaseObject.SendUpdateMsg(BaseObject: TBaseObject; wIdent, wParam: Word;
  lParam1, lParam2, lParam3: Integer; sMsg: string);
var
  SendMessage: pTSendMessage;
  i: Integer;
begin
  try
    EnterCriticalSection(ProcessMsgCriticalSection);
    i := 0;
    while (True) do begin
      if m_MsgList.Count <= i then break;
      SendMessage := m_MsgList.Items[i];
      if SendMessage.wIdent = wIdent then begin
        m_MsgList.Delete(i);
        if SendMessage.Buff <> nil then FreeMem(SendMessage.Buff);
        DisPose(SendMessage);
        Continue;
      end;
      Inc(i);
    end;
  finally
    LeaveCriticalSection(ProcessMsgCriticalSection);
  end;
  SendMsg(BaseObject, wIdent, wParam, lParam1, lParam2, lParam3, sMsg);
end;

procedure TBaseObject.SendActionMsg(BaseObject: TBaseObject; wIdent, wParam: Word;
  lParam1, lParam2, lParam3: Integer; sMsg: string);
var
  SendMessage: pTSendMessage;
  i: Integer;
begin
  EnterCriticalSection(ProcessMsgCriticalSection);
  try
    i := 0;
    while (True) do begin
      if m_MsgList.Count <= i then break;
      SendMessage := m_MsgList.Items[i];
      if (SendMessage.wIdent = CM_TURN) or
        (SendMessage.wIdent = CM_WALK) or
        (SendMessage.wIdent = CM_SITDOWN) or
        (SendMessage.wIdent = CM_HORSERUN) or
        (SendMessage.wIdent = CM_RUN) or
        (SendMessage.wIdent = CM_HIT) or
        (SendMessage.wIdent = CM_HEAVYHIT) or
        (SendMessage.wIdent = CM_BIGHIT) or
        (SendMessage.wIdent = CM_POWERHIT) or
        (SendMessage.wIdent = CM_LONGHIT) or
        (SendMessage.wIdent = CM_WIDEHIT) or
        (SendMessage.wIdent = CM_CRSHIT) or
        (SendMessage.wIdent = CM_FIREHIT) then begin
        m_MsgList.Delete(i);
        if SendMessage.Buff <> nil then FreeMem(SendMessage.Buff);
        DisPose(SendMessage);
        Continue;
      end;
      Inc(i);
    end;
  finally
    LeaveCriticalSection(ProcessMsgCriticalSection);
  end;
  SendMsg(BaseObject, wIdent, wParam, lParam1, lParam2, lParam3, sMsg);
end;

function TBaseObject.GetMessage(Msg: pTProcessMessage): Boolean;
var
  i: Integer;
  SendMessage: pTSendMessage;
begin
  Result := False;
  EnterCriticalSection(ProcessMsgCriticalSection);
  try
    i := 0;
    Msg.wIdent := 0;
    while m_MsgList.Count > i do begin
      SendMessage := m_MsgList.Items[i];
      if (SendMessage.dwDeliveryTime <> 0) and (GetTickCount < SendMessage.dwDeliveryTime) then begin
        Inc(i);
        Continue;
      end;
      m_MsgList.Delete(i);
      Msg.wIdent := SendMessage.wIdent;
      Msg.wParam := SendMessage.wParam;
      Msg.nParam1 := SendMessage.nParam1;
      Msg.nParam2 := SendMessage.nParam2;
      Msg.nParam3 := SendMessage.nParam3;
      Msg.BaseObject := SendMessage.BaseObject;
      Msg.dwDeliveryTime := SendMessage.dwDeliveryTime;
      Msg.boLateDelivery := SendMessage.boLateDelivery;
      if SendMessage.Buff <> nil then begin
        Msg.sMsg := StrPas(SendMessage.Buff);
        FreeMem(SendMessage.Buff);
      end else begin
        Msg.sMsg := '';
      end;
      DisPose(SendMessage);
      Result := True;
      break;
    end;
  finally
    LeaveCriticalSection(ProcessMsgCriticalSection);
  end;
end;

function TBaseObject.GetMapBaseObjects(tEnvir: TEnvirnoment; nX, nY, nRage: Integer; rList: TList): Boolean; //004B8D2C
var
  III: Integer;
  x, y: Integer;
  nStartX, nStartY, nEndX, nEndY: Integer;
  MapCellInfo: pTMapCellinfo;
  OSObject: pTOSObject;
  BaseObject: TBaseObject;
resourcestring
  sExceptionMsg = '[Exception] TBaseObject::GetMapBaseObjects';
begin
  Result := False;
  if rList = nil then Exit;
  try
    nStartX := nX - nRage;
    nEndX := nX + nRage;
    nStartY := nY - nRage;
    nEndY := nY + nRage;
    for x := nStartX to nEndX do begin
      for y := nStartY to nEndY do begin
        if tEnvir.GetMapCellInfo(x, y, MapCellInfo) and (MapCellInfo.ObjList <> nil) then begin
          for III := 0 to MapCellInfo.ObjList.Count - 1 do begin
            OSObject := pTOSObject(MapCellInfo.ObjList.Items[III]);
            if (OSObject <> nil) and (OSObject.btType = OS_MOVINGOBJECT) then begin
              BaseObject := TBaseObject(OSObject.CellObj);
              if (BaseObject <> nil) and (not BaseObject.m_boDeath) and (not BaseObject.m_boGhost) then begin
                rList.Add(BaseObject);
              end;
            end;
          end;
        end;
      end;
    end;
  except
    MainOutMessage(sExceptionMsg);
  end;
  Result := True;
end;

procedure TBaseObject.SendRefMsg(wIdent, wParam: Word; nParam1, nParam2, nParam3: Integer; sMsg: string);
var
  ii, nC: Integer;
  nCX, nCY, nLX, nLY, nHX, nHY: Integer;
  MapCellInfo: pTMapCellinfo;
  OSObject: pTOSObject;
  BaseObject: TBaseObject;
  btType: Byte;
resourcestring
  sExceptionMsg = '[Exception] TBaseObject::SendRefMsg Name = %s';
begin
  if (m_btRaceServer = RC_PLAYOBJECT) and (TPlayObject(Self).m_boNotOnlineAddExp) then //10-28 修改 离线挂机人物不刷新
    if m_PEnvir = nil then begin
      MainOutMessage(m_sCharName + ' SendRefMsg nil PEnvir ');
      Exit;
    end;
  //if m_boObMode or m_boFixedHideMode then exit;
  //01/21 增加，原来直接不发信息，如果隐身模式则只发送信息给自己
  if m_boObMode or m_boFixedHideMode then begin
    SendMsg(Self, wIdent, wParam, nParam1, nParam2, nParam3, sMsg);
    Exit;
  end;

  EnterCriticalSection(ProcessMsgCriticalSection);
  try
    if ((GetTickCount - m_SendRefMsgTick) >= 500) or (m_VisibleHumanList.Count = 0) then begin
      m_SendRefMsgTick := GetTickCount();
      m_VisibleHumanList.Clear;
      nLX := m_nCurrX - g_Config.nSendRefMsgRange {12};
      nHX := m_nCurrX + g_Config.nSendRefMsgRange {12};
      nLY := m_nCurrY - g_Config.nSendRefMsgRange {12};
      nHY := m_nCurrY + g_Config.nSendRefMsgRange {12};
      for nCX := nLX to nHX do begin
        for nCY := nLY to nHY do begin
          if m_PEnvir.GetMapCellInfo(nCX, nCY, MapCellInfo) then begin
            if MapCellInfo.ObjList <> nil then begin
              for ii := MapCellInfo.ObjList.Count - 1 downto 0 do begin
                OSObject := MapCellInfo.ObjList.Items[ii];
                if OSObject <> nil then begin
                  if OSObject.btType = OS_MOVINGOBJECT then begin
                    if (GetTickCount - OSObject.dwAddTime) >= 60 * 1000 then begin
                      MapCellInfo.ObjList.Delete(ii);
                      DisPoseAndNil(OSObject);
                      if MapCellInfo.ObjList.Count <= 0 then begin
                        FreeAndNil(MapCellInfo.ObjList);
                        break;
                      end;
                    end else begin
                      try
                        BaseObject := TBaseObject(OSObject.CellObj);
                        if (BaseObject <> nil) and not BaseObject.m_boGhost then begin
                          if BaseObject.m_btRaceServer = RC_PLAYOBJECT then begin
                            BaseObject.SendMsg(Self, wIdent, wParam, nParam1, nParam2, nParam3, sMsg);
                            m_VisibleHumanList.Add(BaseObject);
                          end else
                            if BaseObject.m_boWantRefMsg then begin {增加分身的魔法盾效果}
                            if (wIdent = RM_STRUCK) or (wIdent = RM_HEAR) or (wIdent = RM_DEATH) or (wIdent = RM_CHARSTATUSCHANGED) then begin
                              BaseObject.SendMsg(Self, wIdent, wParam, nParam1, nParam2, nParam3, sMsg);
                              m_VisibleHumanList.Add(BaseObject);
                            end;
                          end;
                        end;
                      except
                        on E: Exception do begin
                          MapCellInfo.ObjList.Delete(ii);
                          if MapCellInfo.ObjList.Count <= 0 then begin
                            FreeAndNil(MapCellInfo.ObjList);
                          end;
                          MainOutMessage(format(sExceptionMsg, [m_sCharName]));
                          MainOutMessage(E.Message);
                        end;
                      end;
                    end;
                  end;
                end;
              end; //for I := 0 to MapCellInfo.ObjList.Count - 1 do begin
            end; //if MapCellInfo.ObjList <> nil then begin
          end; //if PEnvir.GetMapCellInfo(nC,n10,MapCellInfo) then begin
        end;
      end;
      Exit;
    end;
    for nC := 0 to m_VisibleHumanList.Count - 1 do begin
      BaseObject := TBaseObject(m_VisibleHumanList.Items[nC]);
      if (BaseObject = nil) or (BaseObject.m_boGhost) then Continue;
      if (BaseObject.m_PEnvir = m_PEnvir) and
        (abs(BaseObject.m_nCurrX - m_nCurrX) < 11) and
        (abs(BaseObject.m_nCurrY - m_nCurrY) < 11) then begin
        if BaseObject.m_btRaceServer = RC_PLAYOBJECT then begin
          BaseObject.SendMsg(Self, wIdent, wParam, nParam1, nParam2, nParam3, sMsg);
        end else
          if BaseObject.m_boWantRefMsg then begin
          if (wIdent = RM_STRUCK) or (wIdent = RM_HEAR) or (wIdent = RM_DEATH) or (wIdent = RM_CHARSTATUSCHANGED) then begin
            BaseObject.SendMsg(Self, wIdent, wParam, nParam1, nParam2, nParam3, sMsg);
          end;
        end; //if BaseObject.m_boWantRefMsg then begin
      end; //if (BaseObject.m_PEnvir = m_PEnvir) and
    end; //for nC:= 0 to m_VisibleHumanList.Count - 1 do begin
  finally
    LeaveCriticalSection(ProcessMsgCriticalSection);
  end;
end;

procedure TBaseObject.UpdateVisibleGay(BaseObject: TBaseObject);
var
  i: Integer;
  boIsVisible: Boolean;
  VisibleBaseObject: pTVisibleBaseObject;
begin
  boIsVisible := False;
  if (BaseObject.m_btRaceServer = RC_PLAYOBJECT) or (BaseObject.m_Master <> nil) {or (BaseObject.m_btRaceServer = RC_PLAYMOSTER)} then
    m_boIsVisibleActive := True; //如果是人物或宝宝则置TRUE
  for i := 0 to m_VisibleActors.Count - 1 do begin
    VisibleBaseObject := m_VisibleActors.Items[i];
    if VisibleBaseObject <> nil then begin
      if VisibleBaseObject.BaseObject = BaseObject then begin
        VisibleBaseObject.nVisibleFlag := 1;
        boIsVisible := True;
        break;
      end;
    end;
  end;
  if boIsVisible then Exit;
  New(VisibleBaseObject);
  VisibleBaseObject.nVisibleFlag := 2;
  VisibleBaseObject.BaseObject := BaseObject;
  m_VisibleActors.Add(VisibleBaseObject);
end;

procedure TBaseObject.UpdateVisibleItem(wX, wY: Integer; MapItem: PTMapItem);
var
  i: Integer;
  boIsVisible: Boolean;
  VisibleMapItem: pTVisibleMapItem;
begin
  boIsVisible := False;
  for i := 0 to m_VisibleItems.Count - 1 do begin
    VisibleMapItem := m_VisibleItems.Items[i];
    if VisibleMapItem <> nil then begin
      if (VisibleMapItem.MapItem <> nil) and (VisibleMapItem.MapItem = MapItem) then begin
        VisibleMapItem.nVisibleFlag := 1;
        boIsVisible := True;
        break;
      end;
    end;
  end;
  if boIsVisible then Exit;
  New(VisibleMapItem);
  VisibleMapItem.nVisibleFlag := 2;
  VisibleMapItem.nX := wX;
  VisibleMapItem.nY := wY;
  VisibleMapItem.MapItem := MapItem;
  VisibleMapItem.sName := MapItem.Name;
  VisibleMapItem.wLooks := MapItem.Looks;
  m_VisibleItems.Add(VisibleMapItem);
end;

procedure TBaseObject.UpdateVisibleEvent(wX, wY: Integer; MapEvent: TObject);
var
  i: Integer;
  boIsVisible: Boolean;
  Event: TEvent;
begin
  boIsVisible := False;
  for i := 0 to m_VisibleEvents.Count - 1 do begin
    Event := m_VisibleEvents.Items[i];
    if Event <> nil then begin
      if Event = MapEvent then begin
        Event.nVisibleFlag := 1;
        boIsVisible := True;
        break;
      end;
    end;
  end;
  if boIsVisible then Exit;
  TEvent(MapEvent).nVisibleFlag := 2;
  TEvent(MapEvent).m_nX := wX;
  TEvent(MapEvent).m_nY := wY;
  m_VisibleEvents.Add(MapEvent);
end;

function TBaseObject.IsVisibleHuman: Boolean;
var
  i: Integer;
  VisibleBaseObject: pTVisibleBaseObject;
begin
  Result := False;
  for i := 0 to m_VisibleActors.Count - 1 do begin
    VisibleBaseObject := m_VisibleActors.Items[i];
    if VisibleBaseObject <> nil then begin
      if (TBaseObject(VisibleBaseObject.BaseObject).m_btRaceServer = RC_PLAYOBJECT) or (TBaseObject(VisibleBaseObject.BaseObject).m_Master <> nil) then begin
        Result := True;
        break;
      end;
    end;
  end;
end;

procedure TBaseObject.SearchObjectViewRange;
var
  i: Integer;
  nStartX: Integer;
  nEndX: Integer;
  nStartY: Integer;
  nEndY: Integer;
  n18: Integer;
  n1C: Integer;
  nIdx: Integer;
  n24: Integer;
  MapCellInfo: pTMapCellinfo;
  OSObject: pTOSObject;
  BaseObject: TBaseObject;
  MapItem: PTMapItem;
  MapEvent: TEvent;
  VisibleBaseObject: pTVisibleBaseObject;
  VisibleMapItem: pTVisibleMapItem;
  nCheckCode: Integer;
  btType: Byte;
  nVisibleFlag: Integer;
resourcestring
  sExceptionMsg1 = '[Exception] TBaseObject::SearchViewRange Code:%d';
  sExceptionMsg2 = '[Exception] TBaseObject::SearchViewRange 1-%d %s %s %d %d %d';
begin
  nCheckCode := 0;
  if m_PEnvir = nil then begin
    MainOutMessage('SearchViewRange nil PEnvir');
    Exit;
  end;
  nCheckCode := 1;
  n24 := 0;
  m_boIsVisibleActive := False; //先置为FALSE
  try
    for i := 0 to m_VisibleItems.Count - 1 do begin
      pTVisibleMapItem(m_VisibleItems.Items[i]).nVisibleFlag := 0;
    end;
  except
    MainOutMessage(format(sExceptionMsg1, [nCheckCode]));
    KickException();
  end;
  try
    nCheckCode := 4;
    for i := 0 to m_VisibleActors.Count - 1 do begin
      pTVisibleBaseObject(m_VisibleActors.Items[i]).nVisibleFlag := 0;
    end;
    nCheckCode := 5;
  except
    MainOutMessage(format(sExceptionMsg1, [nCheckCode]));
    KickException();
  end;
  nCheckCode := 6;
  nStartX := m_nCurrX - m_nViewRange;
  nEndX := m_nCurrX + m_nViewRange;
  nStartY := m_nCurrY - m_nViewRange;
  nEndY := m_nCurrY + m_nViewRange;
  try
    nCheckCode := 7;
    for n18 := nStartX to nEndX do begin
      nCheckCode := 8;
      for n1C := nStartY to nEndY do begin
        nCheckCode := 9;
        if m_PEnvir.GetMapCellInfo(n18, n1C, MapCellInfo) and (MapCellInfo.ObjList <> nil) then begin
          nCheckCode := 10;
          n24 := 1;
          nIdx := 0;
          while (True) do begin
            nCheckCode := 11;
            if (MapCellInfo.ObjList <> nil) and (MapCellInfo.ObjList.Count <= 0) then begin //200-11-1 增加
              FreeAndNil(MapCellInfo.ObjList);
              break;
            end;
            if MapCellInfo.ObjList.Count <= nIdx then break;
            OSObject := MapCellInfo.ObjList.Items[nIdx];
            nCheckCode := 12;
            if OSObject <> nil then begin
              nCheckCode := 13;
              try
                btType := OSObject.btType; //2006-10-14 防止内存出错
              except
                MapCellInfo.ObjList.Delete(nIdx);
                Continue;
              end;
              if OSObject.btType = OS_MOVINGOBJECT then begin
                nCheckCode := 14;
                if (GetTickCount - OSObject.dwAddTime) >= 60 * 1000 then begin
                  DisPoseAndNil(OSObject);
                  MapCellInfo.ObjList.Delete(nIdx);
                  if MapCellInfo.ObjList.Count <= 0 then begin
                    FreeAndNil(MapCellInfo.ObjList);
                    break;
                  end;
                  Continue;
                end;
                nCheckCode := 15;
                BaseObject := TBaseObject(OSObject.CellObj);
                if BaseObject <> nil then begin
                  nCheckCode := 16;
                  if not BaseObject.m_boGhost and not BaseObject.m_boFixedHideMode and not BaseObject.m_boObMode then begin
                    nCheckCode := 17;
                    if (m_btRaceServer < RC_ANIMAL) or
                      (m_Master <> nil) or
                      m_boCrazyMode or
                      m_boWantRefMsg or
                      ((BaseObject.m_Master <> nil) and (abs(BaseObject.m_nCurrX - m_nCurrX) <= 3) and (abs(BaseObject.m_nCurrY - m_nCurrY) <= 3)) or
                      (BaseObject.m_btRaceServer = RC_PLAYOBJECT) then begin
                      nCheckCode := 18;
                      UpdateVisibleGay(BaseObject);
                      nCheckCode := 19;
                    end;
                  end;
                end;
              end; {if OSObject.btType = OS_MOVINGOBJECT then begin}

              {增加分身人搜索地面物品}
              nCheckCode := 20;
              if (m_btRaceServer = RC_PLAYMOSTER) and (m_Master <> nil) and (m_nCopyHumanLevel > 0) then begin
                if (OSObject <> nil) and (OSObject.btType = OS_ITEMOBJECT) then begin
                  nCheckCode := 21;
                  if (GetTickCount - OSObject.dwAddTime) > g_Config.dwClearDropOnFloorItemTime {60 * 60 * 1000} then begin
                    DisPoseAndNil(PTMapItem(OSObject.CellObj)); //防止占用内存不释放现象
                    DisPoseAndNil(OSObject);
                    MapCellInfo.ObjList.Delete(nIdx);
                    if MapCellInfo.ObjList.Count <= 0 then begin
                      FreeAndNil(MapCellInfo.ObjList);
                      break;
                    end;
                    Continue;
                  end;
                  MapItem := PTMapItem(OSObject.CellObj);
                  nCheckCode := 28;
                  UpdateVisibleItem(n18, n1C, MapItem);
                  if (MapItem.OfBaseObject <> nil) or (MapItem.DropBaseObject <> nil) then begin
                    nCheckCode := 29;
                    if (GetTickCount - MapItem.dwCanPickUpTick) > g_Config.dwFloorItemCanPickUpTime {2 * 60 * 1000} then begin
                      nCheckCode := 30;
                      MapItem.OfBaseObject := nil;
                      MapItem.DropBaseObject := nil;
                    end else begin
                      nCheckCode := 31;
                      if TBaseObject(MapItem.OfBaseObject) <> nil then begin
                        nCheckCode := 32;
                        if TBaseObject(MapItem.OfBaseObject).m_boGhost then MapItem.OfBaseObject := nil;
                      end;
                      nCheckCode := 33;
                      if TBaseObject(MapItem.DropBaseObject) <> nil then begin
                        nCheckCode := 34;
                        if TBaseObject(MapItem.DropBaseObject).m_boGhost then MapItem.DropBaseObject := nil;
                      end;
                      nCheckCode := 35;
                    end;
                  end;
                end; //004B9B38 if OSObject.btType = OS_ITEMOBJECT then begin
                nCheckCode := 36;
                {增加分身人搜索地面物品}
              end;
            end;
            Inc(nIdx);
          end;
        end;
      end;
    end;
  except
    on E: Exception do begin
      MainOutMessage(format(sExceptionMsg2, [n24, m_sCharName, m_sMapName, m_nCurrX, m_nCurrY, nCheckCode]));
      {
      MainOutMessage(m_sCharName + ',' +
                     m_sMapName + ',' +
                     IntToStr(m_nCurrX) + ',' +
                     IntToStr(m_nCurrY) + ',' +
                     ' SearchViewRange 1-' +
                     IntToStr(n24));
      }
      MainOutMessage(E.Message);
      KickException();
    end;
  end;
  nCheckCode := 40;
  n24 := 2;
  try
    {增加分身人物搜索物品}
    n18 := 0;
    while (True) do begin
      if m_VisibleItems.Count <= n18 then break;
      VisibleMapItem := m_VisibleItems.Items[n18];
      try
        nVisibleFlag := VisibleMapItem.nVisibleFlag; //2006-10-14防止内存出错
      except
        m_VisibleItems.Delete(n18);
        Continue;
      end;
      if VisibleMapItem.nVisibleFlag = 0 then begin
        m_VisibleItems.Delete(n18);
        DisPoseAndNil(VisibleMapItem);
        Continue;
      end;
      Inc(n18);
    end;
    {增加分身人物的物品}

    n18 := 0;
    while (True) do begin
      if m_VisibleActors.Count <= n18 then break;
      nCheckCode := 41;
      VisibleBaseObject := m_VisibleActors.Items[n18];
      nCheckCode := 42;
      try
        nVisibleFlag := VisibleBaseObject.nVisibleFlag; //2006-10-14防止内存出错
      except
        m_VisibleActors.Delete(n18);
        Continue;
      end;
      if VisibleBaseObject.nVisibleFlag = 0 then begin
        nCheckCode := 43;
        m_VisibleActors.Delete(n18);
        nCheckCode := 48;
        DisPoseAndNil(VisibleBaseObject);
        nCheckCode := 49;
        Continue;
      end;
      Inc(n18);
    end;
  except
    on E: Exception do begin
      MainOutMessage(format(sExceptionMsg2, [n24, m_sCharName, m_sMapName, m_nCurrX, m_nCurrY, nCheckCode]));
      {MainOutMessage(m_sCharName + ',' +
                     m_sMapName + ',' +
                     IntToStr(m_nCurrX) + ',' +
                     IntToStr(m_nCurrY) + ',' +
                     ' SearchViewRange 2');}
      KickException();
    end;
  end;
end;

function TBaseObject.GetFeatureToLong: Integer;
begin
  Result := GetFeature(nil);
end;

function TBaseObject.GetFeatureEx(): Word;
begin
  if m_boOnHorse then begin
    Result := MakeWord(m_btHorseType, m_btDressEffType);
  end else begin
    Result := MakeWord(0, m_btDressEffType);
  end;
end;

function TBaseObject.GetFeature(BaseObject: TBaseObject): Integer;
var
  nDress, nWeapon, nHair, nRaceImg, nAppr: Integer;
  StdItem: pTStdItem;
  bo25: Boolean;
begin
  if Assigned(zPlugOfEngine.GetFeature) then begin
    Result := zPlugOfEngine.GetFeature(Self, BaseObject);
  end else begin
    if (m_btRaceServer = RC_PLAYOBJECT) or (m_btRaceServer = RC_PLAYMOSTER) then begin
      nDress := 0;
      //衣服
      if m_UseItems[U_DRESS].wIndex > 0 then begin
        StdItem := UserEngine.GetStdItem(m_UseItems[U_DRESS].wIndex);
        if StdItem <> nil then begin
          nDress := StdItem.Shape * 2;
        end;
      end;
      Inc(nDress, m_btGender);
      nWeapon := 0;
      //武器
      if m_UseItems[U_WEAPON].wIndex > 0 then begin
        StdItem := UserEngine.GetStdItem(m_UseItems[U_WEAPON].wIndex);
        if StdItem <> nil then begin
          nWeapon := StdItem.Shape * 2;
        end;
      end;
      Inc(nWeapon, m_btGender);
      nHair := m_btHair * 2 + m_btGender;
      Result := MakeHumanFeature(0, nDress, nWeapon, nHair);
      Exit;
    end;
    bo25 := False;
    if (BaseObject <> nil) and (BaseObject.bo245) then
      bo25 := True;
    if bo25 then begin
      nRaceImg := m_btRaceImg;
      nAppr := m_wAppr;
      case nAppr of
        0: begin
            nRaceImg := 12;
            nAppr := 5;
          end;
        1: begin
            nRaceImg := 11;
            nAppr := 9;
          end;
        160: begin
            nRaceImg := 10;
            nAppr := 0;
          end;
        161: begin
            nRaceImg := 10;
            nAppr := 1;
          end;
        162: begin
            nRaceImg := 11;
            nAppr := 6;
          end;
        163: begin
            nRaceImg := 11;
            nAppr := 3;
          end;
      end;
      Result := MakeMonsterFeature(nRaceImg, m_btMonsterWeapon, nAppr);
      Exit;
    end;
    Result := MakeMonsterFeature(m_btRaceImg, m_btMonsterWeapon, m_wAppr);
  end;
end;

function TBaseObject.GetCharStatus(): Integer;
var
  i: Integer;
  nStatus: Integer;
begin
  nStatus := 0;
  for i := Low(TStatusTime) to High(TStatusTime) do begin
    if m_wStatusTimeArr[i] > 0 then begin
      nStatus := ($80000000 shr i) or nStatus;
    end;
  end;
  Result := (m_nCharStatusEx and $FFFFF) or nStatus;
end;

procedure TBaseObject.AbilCopyToWAbil;
begin
  m_WAbil := m_Abil;
end;

procedure TBaseObject.Initialize;
var
  i: Integer;
  UserMagic: pTUserMagic;
begin
  AbilCopyToWAbil();
  if (m_btRaceServer = RC_PLAYOBJECT) or (m_btRaceServer = RC_PLAYMOSTER) then begin
    for i := 0 to m_MagicList.Count - 1 do begin
      UserMagic := m_MagicList.Items[i];
      if UserMagic.btLevel >= 4 then UserMagic.btLevel := 0;
    end;
  end;
  m_boAddtoMapSuccess := True;
  if m_PEnvir.CanWalk(m_nCurrX, m_nCurrY, True) and AddToMap() then
    m_boAddtoMapSuccess := False;
  m_nCharStatus := GetCharStatus();
  AddBodyLuck(0);
  LoadSayMsg();
  if g_Config.boMonSayMsg then MonsterSayMsg(nil, s_MonGen);
end;
//==============================
//取得怪物说话信息列表
procedure TBaseObject.LoadSayMsg();
var
  i: Integer;
begin
  for i := 0 to g_MonSayMsgList.Count - 1 do begin
    if CompareText(g_MonSayMsgList.Strings[i], m_sCharName) = 0 then begin
      m_SayMsgList := TList(g_MonSayMsgList.Objects[i]);
      break;
    end;
  end;
end;

procedure TBaseObject.Disappear();
begin

end;

procedure TBaseObject.FeatureChanged;
begin
  SendRefMsg(RM_FEATURECHANGED, GetFeatureEx, GetFeatureToLong, 0, 0, '')
end;

procedure TBaseObject.StatusChanged();
begin
  SendRefMsg(RM_CHARSTATUSCHANGED, m_nHitSpeed, m_nCharStatus, 0, 0, '')
end;

procedure TBaseObject.DisappearA();
begin
  m_PEnvir.DeleteFromMap(m_nCurrX, m_nCurrY, OS_MOVINGOBJECT, Self);
  SendRefMsg(RM_DISAPPEAR, 0, 0, 0, 0, '');
end;

procedure TBaseObject.KickException;
var
  PlayObject: TPlayObject;
begin
  if m_btRaceServer = RC_PLAYOBJECT then begin
    m_sMapName := g_Config.sHomeMap;
    m_nCurrX := g_Config.nHomeX;
    m_nCurrY := g_Config.nHomeY;
    PlayObject := TPlayObject(Self);
    PlayObject.m_boEmergencyClose := True;
    PlayObject.m_boNotOnlineAddExp := False;
    PlayObject.m_boPlayOffLine := False; //关闭下线触发
  end else begin
    m_boDeath := True;
    m_dwDeathTick := GetTickCount;
    MakeGhost;
  end;
end;

function TBaseObject.Walk(nIdent: Integer): Boolean;
var
  i: Integer;
  MapCellInfo: pTMapCellinfo;
  OSObject: pTOSObject;
  GateObj: pTGateObj;
  bo1D: Boolean;
  Event: TEvent;
  PlayObject: TPlayObject;
  nCheckCode: Integer;
resourcestring
  sExceptionMsg = '[Exception] TBaseObject::Walk  CheckCode:%d %s %s %d:%d';
begin
  Result := True;
  nCheckCode := -1;
  if m_PEnvir = nil then begin
    MainOutMessage('Walk nil PEnvir');
    Exit;
  end;
  try
    nCheckCode := 1;
    bo1D := m_PEnvir.GetMapCellInfo(m_nCurrX, m_nCurrY, MapCellInfo);
    GateObj := nil;
    Event := nil;
    nCheckCode := 2;
    if bo1D and (MapCellInfo.ObjList <> nil) then begin
      for i := 0 to MapCellInfo.ObjList.Count - 1 do begin
        OSObject := MapCellInfo.ObjList.Items[i];
        if OSObject <> nil then begin
          if OSObject.btType = OS_GATEOBJECT then begin
            GateObj := pTGateObj(OSObject.CellObj);
          end;
          if OSObject.btType = OS_EVENTOBJECT then begin
            if TEvent(OSObject.CellObj).m_OwnBaseObject <> nil then
              Event := TEvent(OSObject.CellObj);
          end;
          if OSObject.btType = OS_MAPEVENT then begin

          end;
          if OSObject.btType = OS_DOOR then begin

          end;
          if OSObject.btType = OS_ROON then begin

          end;
        end;
      end;
    end;
    nCheckCode := 3;
    if Event <> nil then begin
      if Event.m_OwnBaseObject <> nil then begin
        if Event.m_OwnBaseObject.IsProperTarget(Self) then
          SendMsg(Event.m_OwnBaseObject, RM_MAGSTRUCK_MINE, 0, Event.m_nDamage, 0, 0, '');
      end;
    end;
    nCheckCode := 4;
    if Result and (GateObj <> nil) then begin
      if m_btRaceServer = RC_PLAYOBJECT then begin
        if m_PEnvir.ArroundDoorOpened(m_nCurrX, m_nCurrY) then begin
          if (not TEnvirnoment(GateObj.DEnvir).m_boNEEDHOLE) or (g_EventManager.GetEvent(m_PEnvir, m_nCurrX, m_nCurrY, ET_DIGOUTZOMBI) <> nil) then begin
            if nServerIndex = TEnvirnoment(GateObj.DEnvir).nServerIndex then begin
              if not EnterAnotherMap(TEnvirnoment(GateObj.DEnvir), GateObj.nDMapX, GateObj.nDMapY) then begin
                Result := False;
              end;
            end else begin
              DisappearA();
              m_bo316 := True;
              PlayObject := TPlayObject(Self);
              PlayObject.m_sSwitchMapName := TEnvirnoment(GateObj.DEnvir).sMapName;
              PlayObject.m_nSwitchMapX := GateObj.nDMapX;
              PlayObject.m_nSwitchMapY := GateObj.nDMapY;
              PlayObject.m_boSwitchData := True;
              PlayObject.m_nServerIndex := TEnvirnoment(GateObj.DEnvir).nServerIndex;
              PlayObject.m_boEmergencyClose := True;
              PlayObject.m_boReconnection := True;
              PlayObject.m_boPlayOffLine := False;
            end;
          end;
        end;
      end else Result := False;
    end else begin
      nCheckCode := 5;
      if Result then begin
        nCheckCode := 6;
        SendRefMsg(nIdent, m_btDirection, m_nCurrX, m_nCurrY, 0, '');
      end;
    end;
  except
    on E: Exception do begin
      MainOutMessage(format(sExceptionMsg, [nCheckCode, m_sCharName, m_sMapName, m_nCurrX, m_nCurrY]));
      {MainOutMessage('[Exception] TBaseObject.Walk  CheckCode: ' + IntToStr(nCheckCode) + ' ' +
                    m_sCharname + ' ' +
                    m_sMapName + ' ' +
                    IntToStr(m_nCurrX) + ':' +
                    IntToStr(m_nCurrY));}
      MainOutMessage(E.Message);
    end;
  end;
end;

function TBaseObject.EnterAnotherMap(Envir: TEnvirnoment; nDMapX,
  nDMapY: Integer): Boolean;
var
  i: Integer;
  MapCellInfo: pTMapCellinfo;
  OldEnvir: TEnvirnoment;
  nOldX: Integer;
  nOldY: Integer;
  Castle: TUserCastle;
resourcestring
  sExceptionMsg1 = '[Exception] TBaseObject::EnterAnotherMap -> MsgTargetList Clear';
  sExceptionMsg2 = '[Exception] TBaseObject::EnterAnotherMap -> VisbleItems Dispose';
  sExceptionMsg3 = '[Exception] TBaseObject::EnterAnotherMap -> VisbleItems Clear';
  sExceptionMsg4 = '[Exception] TBaseObject::EnterAnotherMap -> VisbleEvents Clear';
  sExceptionMsg5 = '[Exception] TBaseObject::EnterAnotherMap -> VisbleActors Dispose';
  sExceptionMsg6 = '[Exception] TBaseObject::EnterAnotherMap -> VisbleActors Clear';
  sExceptionMsg7 = '[Exception] TBaseObject::EnterAnotherMap';
begin
  if Assigned(zPlugOfEngine.ObjectEnterAnotherMap) then begin
    try
      Result := zPlugOfEngine.ObjectEnterAnotherMap(Self, Envir, nDMapX, nDMapY);
    except
    end;
  end else begin
    Result := False;
    try
      if m_Abil.Level < Envir.nRequestLevel then Exit;
      if Envir.QuestNPC <> nil then TMerchant(Envir.QuestNPC).Click(TPlayObject(Self));
      if Envir.nNEEDSETONFlag >= 0 then begin
        if GetQuestFalgStatus(Envir.nNEEDSETONFlag) <> Envir.nNeedONOFF then Exit;
      end;
      if not Envir.GetMapCellInfo(nDMapX, nDMapY, MapCellInfo) then Exit;
      Castle := g_CastleManager.IsCastlePalaceEnvir(Envir);
      if (Castle <> nil) and (m_btRaceServer = RC_PLAYOBJECT) then begin
        if not Castle.CheckInPalace(m_nCurrX, m_nCurrY, Self) then Exit;
      end;
      {
      if (UserCastle.m_MapPalace = Envir) and (m_btRaceServer = RC_PLAYOBJECT) then begin
        if not UserCastle.CheckInPalace(m_nCurrX,m_nCurrY,Self) then exit;
      end;
      }
      OldEnvir := m_PEnvir;
      nOldX := m_nCurrX;
      nOldY := m_nCurrY;
      DisappearA();
      try
        m_VisibleHumanList.Clear;
      except
        MainOutMessage(sExceptionMsg1);
      end;
      try
        for i := 0 to m_VisibleItems.Count - 1 do begin
          DisPose(pTVisibleMapItem(m_VisibleItems.Items[i]));
        end;
      except
        MainOutMessage(sExceptionMsg2);
      end;
      try
        m_VisibleItems.Clear;
      except
        MainOutMessage(sExceptionMsg3);
      end;

      try
        m_VisibleEvents.Clear;
      except
        MainOutMessage(sExceptionMsg4);
      end;
      try
        for i := 0 to m_VisibleActors.Count - 1 do begin
          if pTVisibleBaseObject(m_VisibleActors.Items[i]) <> nil then
            DisPose(pTVisibleBaseObject(m_VisibleActors.Items[i]));
        end;
      except
        MainOutMessage(sExceptionMsg5);
      end;
      try
        m_VisibleActors.Clear;
      except
        MainOutMessage(sExceptionMsg6);
      end;
      SendMsg(Self, RM_CLEAROBJECTS, 0, 0, 0, 0, '');
      m_PEnvir := Envir;
      m_sMapName := Envir.sMapName;
      m_nCurrX := nDMapX;
      m_nCurrY := nDMapY;
      SendMsg(Self, RM_CHANGEMAP, 0, 0, 0, 0, g_MapManager.GetMainMap(Envir));
      if AddToMap() then begin
        m_dwMapMoveTick := GetTickCount();
        m_bo316 := True;
        Result := True;
      end else begin
        m_PEnvir := OldEnvir;
        m_nCurrX := nOldX;
        m_nCurrY := nOldY;
        m_PEnvir.AddToMap(m_nCurrX, m_nCurrY, OS_MOVINGOBJECT, Self);
      end;
      if m_btRaceServer = RC_PLAYOBJECT then begin //复位泡点，及金币，时间
        TPlayObject(Self).m_dwIncGamePointTick := GetTickCount();
        TPlayObject(Self).m_dwIncGameGoldTick := GetTickCount();
        TPlayObject(Self).m_dwAutoGetExpTick := GetTickCount();
      end;
      if m_PEnvir.m_boFight3Zone and (m_PEnvir.m_boFight3Zone <> OldEnvir.m_boFight3Zone) then
        RefShowName();
    except
      MainOutMessage(sExceptionMsg7);
    end;
  end;
end;

procedure TBaseObject.TurnTo(nDir: Integer);
begin
  m_btDirection := nDir;
  SendRefMsg(RM_TURN, nDir, m_nCurrX, m_nCurrY, 0, '');
end;

procedure TBaseObject.ProcessMonSayMsg(sMsg: string);
var
  sCharName: string;
begin
  if m_btRaceServer = RC_PLAYOBJECT then Exit; //修改
  sCharName := FilterShowName(m_sCharName);
  SendRefMsg(RM_HEAR, 0, g_Config.btHearMsgFColor, g_Config.btHearMsgBColor, 0, sCharName + ':' + sMsg);
end;

procedure TBaseObject.SysMsg(sMsg: string; MsgColor: TMsgColor; MsgType: TMsgType);
begin
  if (m_btRaceServer = RC_PLAYOBJECT) and (TPlayObject(Self).m_boNotOnlineAddExp) then Exit; //修改离线人物不发送

  if g_Config.boShowPreFixMsg then begin
    case MsgType of
      t_Mon: sMsg := g_Config.sMonSayMsgpreFix + sMsg;
      t_Hint: sMsg := g_Config.sHintMsgPreFix + sMsg;
      {
      s_GroupMsg: sMsg:=g_Config.sGroupMsgPreFix + sMsg;
      s_GuildMsg: sMsg:=g_Config.sGuildMsgPreFix + sMsg;
      }
      t_GM: sMsg := g_Config.sGMRedMsgpreFix + sMsg;
      t_System: sMsg := g_Config.sSysMsgPreFix + sMsg;
      t_Notice: sMsg := g_Config.sLineNoticePreFix + sMsg;
      t_Cust: sMsg := g_Config.sCustMsgpreFix + sMsg;
      t_Castle: sMsg := g_Config.sCastleMsgpreFix + sMsg;
    end;
  end;
  {
  case MsgColor of
    c_Green: SendMsg(Self,RM_SYSMESSAGE2,0,0,0,0,sMsg);
    c_Blue: SendMsg(Self,RM_SYSMESSAGE3,0,0,0,0,sMsg);
    else SendMsg(Self,RM_SYSMESSAGE,0,0,0,0,sMsg);
  end;
  }
  case MsgColor of
    c_Green: SendMsg(Self, RM_SYSMESSAGE, 0, g_Config.btGreenMsgFColor, g_Config.btGreenMsgBColor, 0, sMsg);
    c_Blue: SendMsg(Self, RM_SYSMESSAGE, 0, g_Config.btBlueMsgFColor, g_Config.btBlueMsgBColor, 0, sMsg);
    else begin
        if MsgType = t_Cust then begin
          SendMsg(Self, RM_SYSMESSAGE, 0, g_Config.btCustMsgFColor, g_Config.btCustMsgBColor, 0, sMsg);
        end else begin
          SendMsg(Self, RM_SYSMESSAGE, 0, g_Config.btRedMsgFColor, g_Config.btRedMsgBColor, 0, sMsg);
        end;
      end;
  end;
end;

procedure TBaseObject.MonsterSayMsg(AttackBaseObject: TBaseObject; MonStatus: TMonStatus);
var
  i: Integer;
  nMsgColor: Integer;
  sMsg: string;
  MonSayMsg: pTMonSayMsg;
  sAttackName: string;
begin
  if m_SayMsgList = nil then Exit;
  if (m_btRaceServer = RC_PLAYOBJECT) then Exit;
  if (AttackBaseObject <> nil) then begin
    if (AttackBaseObject.m_btRaceServer <> RC_PLAYOBJECT) and (AttackBaseObject.m_Master = nil) then begin
      Exit;
    end;
    if AttackBaseObject.m_Master <> nil then sAttackName := AttackBaseObject.m_Master.m_sCharName
    else sAttackName := AttackBaseObject.m_sCharName;
  end;
  for i := 0 to m_SayMsgList.Count - 1 do begin
    MonSayMsg := m_SayMsgList.Items[i];
    if MonSayMsg = nil then Continue;
    sMsg := AnsiReplaceText(MonSayMsg.sSayMsg, '%s', FilterShowName(m_sCharName));
    sMsg := AnsiReplaceText(sMsg, '%d', sAttackName);
    if (MonSayMsg.State = MonStatus) and (Random(MonSayMsg.nRate) = 0) then begin
      if MonStatus = s_MonGen then begin
        UserEngine.SendBroadCastMsg(sMsg, t_Mon);
        break;
      end;
      if MonSayMsg.Color = c_White then begin
        ProcessMonSayMsg(sMsg);
      end else begin
        AttackBaseObject.SysMsg(sMsg, MonSayMsg.Color, t_Mon);
      end;
      break;
    end;
  end;
end;

procedure TBaseObject.SendGroupText(sMsg: string);
var
  i: Integer;
  PlayObject: TPlayObject;
begin
  sMsg := g_Config.sGroupMsgPreFix + sMsg;
  if m_GroupOwner <> nil then begin
    for i := 0 to m_GroupOwner.m_GroupMembers.Count - 1 do begin
      PlayObject := TPlayObject(m_GroupOwner.m_GroupMembers.Objects[i]);
      if PlayObject = nil then Continue;
      PlayObject.SendMsg(Self, RM_GROUPMESSAGE, 0, g_Config.btGroupMsgFColor, g_Config.btGroupMsgBColor, 0, sMsg);
    end;
  end;
end;

procedure TBaseObject.MakeGhost();
begin
  m_boGhost := True;
  m_dwGhostTick := GetTickCount();
  DisappearA();
end;

procedure TBaseObject.ApplyMeatQuality;
var
  i: Integer;
  StdItem: pTStdItem;
  UserItem: pTUserItem;
begin
  for i := 0 to m_ItemList.Count - 1 do begin
    UserItem := m_ItemList.Items[i];
    if UserItem = nil then Continue;
    StdItem := UserEngine.GetStdItem(UserItem.wIndex);
    if StdItem <> nil then begin
      if StdItem.StdMode = 40 then begin
        UserItem.Dura := m_nMeatQuality;
      end;
    end;
  end;
end;

function TBaseObject.TakeBagItems(BaseObject: TBaseObject): Boolean;
var
  UserItem: pTUserItem;
  PlayObject: TPlayObject;
begin
  Result := False;
  while (True) do begin
    if BaseObject.m_ItemList.Count <= 0 then break;
    UserItem := BaseObject.m_ItemList.Items[0];
    if (UserItem = nil) or (not AddItemToBag(UserItem)) then break;
    if Self is TPlayObject then begin
      PlayObject := TPlayObject(Self);
      PlayObject.SendAddItem(UserItem);
      Result := True;
    end;
    BaseObject.m_ItemList.Delete(0);
  end;
end;
{
procedure TBaseObject.ScatterBagItems(ItemOfCreat:TBaseObject); //004BB44C
var
   i, dropwide: integer;
   pu: PTUserItem;
   dellist: TStringList;
   boDropall: Boolean;
begin
   dellist := nil;
   if m_boAngryRing or m_boNoDropItem then exit; //不死戒指

   boDropall := TRUE;
   if m_btRaceServer = RC_PLAYOBJECT then begin
      dropwide := 2;
      if PKLevel < 2 then boDropall := FALSE; //荤恩篮 1/3犬伏肺 冻焙促.
      //弧盎捞绰 促 冻焙促.
   end else
      dropwide := 3;

   try
      for i:=m_ItemList.Count-1 downto 0 do begin
         if (Random(3) = 0) or boDropall then begin
            if DropItemDown (pTUserItem(m_ItemList[i]), dropwide, TRUE,ItemOfCreat,Self) then begin
               pu := PTUserItem(m_ItemList[i]);
               if m_btRaceServer = RC_PLAYOBJECT then begin
                  if dellist = nil then dellist := TStringList.Create;
                  dellist.AddObject(UserEngine.GetStdItemName (pu.wIndex), TObject(pu.MakeIndex));
               end;
               Dispose(PTUserItem(m_ItemList[i]));
               m_ItemList.Delete (i);
            end;
         end;
      end;
      if dellist <> nil then begin
         SendMsg (self, RM_SENDDELITEMLIST, 0, integer(dellist), 0, 0, '');
      end;
   except
      MainOutMessage ('[Exception] TBaseObject.ScatterBagItems');
   end;
end;
}

procedure TBaseObject.ScatterBagItems(ItemOfCreat: TBaseObject);
var
  i, ii, DropWide: Integer;
  UserItem: pTUserItem;
  StdItem: pTStdItem;
  boCanNotDrop: Boolean;
  MonDrop: pTMonDrop;
resourcestring
  sExceptionMsg = '[Exception] TBaseObject::ScatterBagItems';
begin
  DropWide := 3;
  try
    g_MonDropLimitLIst.Lock;
    try
      if m_ItemList <> nil then begin
        for i := m_ItemList.Count - 1 downto 0 do begin
          if m_ItemList.Count <= 0 then break;
          UserItem := m_ItemList.Items[i];
          if UserItem = nil then Continue;
          StdItem := UserEngine.GetStdItem(UserItem.wIndex);
          boCanNotDrop := False;
          if (StdItem <> nil) and (g_MonDropLimitLIst.Count > 0) then begin
            for ii := 0 to g_MonDropLimitLIst.Count - 1 do begin
              if CompareText(StdItem.Name, g_MonDropLimitLIst.Strings[ii]) = 0 then begin
                MonDrop := pTMonDrop(g_MonDropLimitLIst.Objects[ii]);
                if MonDrop <> nil then begin
                  if MonDrop.nDropCount < MonDrop.nCountLimit then begin
                    Inc(MonDrop.nDropCount);
                    g_MonDropLimitLIst.Objects[ii] := TObject(MonDrop);
                  end else begin
                    Inc(MonDrop.nNoDropCount);
                    boCanNotDrop := True;
                  end;
                end;
                break;
              end;
            end;
          end;
          if boCanNotDrop then Continue;
          if DropItemDown(UserItem, DropWide, True, ItemOfCreat, Self) then begin
            DisPose(UserItem);
            m_ItemList.Delete(i);
          end;
        end;
      end;
    finally
      g_MonDropLimitLIst.UnLock;
    end;
  except
    MainOutMessage(sExceptionMsg + ' ' + m_sCharName);
  end;
end;

procedure TBaseObject.ScatterGolds(GoldOfCreat: TBaseObject);
var
  i, nGold: Integer;
begin
  if m_nGold > 0 then begin
    i := 0;
    while (True) do begin
      //      for i:=0 to 18 do begin
      if m_nGold > g_Config.nMonOneDropGoldCount then begin
        nGold := g_Config.nMonOneDropGoldCount;
        m_nGold := m_nGold - g_Config.nMonOneDropGoldCount;
      end else begin
        nGold := m_nGold;
        m_nGold := 0;
      end;
      if nGold > 0 then begin
        if not DropGoldDown(nGold, True, GoldOfCreat, Self) then begin
          m_nGold := m_nGold + nGold;
          break;
        end;
      end else break;
      Inc(i);
      if i >= 17 then break;
    end;
    GoldChanged;
  end;
end;

procedure TBaseObject.DropUseItems(BaseObject: TBaseObject);
var
  nC, nRate: Integer;
  StdItem: pTStdItem;
  DropItemList: TStringList;
resourcestring
  sExceptionMsg = '[Exception] TBaseObject::DropUseItems';
begin
  DropItemList := nil;
  try
    if m_boNoDropUseItem or (m_Master <> nil) then Exit;
    if (m_btRaceServer = RC_PLAYOBJECT) or ((m_btRaceServer = RC_PLAYMOSTER) and (m_Master = nil)) then begin
      nC := 0;
      while (True) do begin
        StdItem := UserEngine.GetStdItem(m_UseItems[nC].wIndex);
        if StdItem <> nil then begin
          if StdItem.Reserved and 8 <> 0 then begin
            if DropItemList = nil then DropItemList := TStringList.Create;
            DropItemList.AddObject('', TObject(m_UseItems[nC].MakeIndex));
            if StdItem.NeedIdentify = 1 then
              AddGameDataLog('16' + #9 +
                m_sMapName + #9 +
                IntToStr(m_nCurrX) + #9 +
                IntToStr(m_nCurrY) + #9 +
                m_sCharName + #9 +
                //UserEngine.GetStdItemName(m_UseItems[nC].wIndex) + #9 +
                StdItem.Name + #9 +
                IntToStr(m_UseItems[nC].MakeIndex) + #9 +
                BoolToIntStr(m_btRaceServer = RC_PLAYOBJECT) + #9 +
                '0');
            m_UseItems[nC].wIndex := 0;
          end;
        end;
        Inc(nC);
        if nC >= 9 then break;
      end;
    end;

    if m_btRaceServer = RC_PLAYOBJECT then begin
      if PKLevel > 2 then nRate := 15
      else nRate := 30;
    end else
      if m_btRaceServer = RC_PLAYMOSTER then begin
      nRate := TPlayMonster(Self).m_nDieDropUseItemRate;
    end;

    nC := 0;
    while (True) do begin
      if Random(nRate) = 0 then begin
        if DropItemDown(@m_UseItems[nC], 2, True, BaseObject, Self) then begin
          StdItem := UserEngine.GetStdItem(m_UseItems[nC].wIndex);
          if StdItem <> nil then begin
            if StdItem.Reserved and 10 = 0 then begin
              if (m_btRaceServer = RC_PLAYOBJECT) or (m_btRaceServer = RC_PLAYMOSTER) then begin
                if DropItemList = nil then DropItemList := TStringList.Create;
                DropItemList.AddObject(UserEngine.GetStdItemName(m_UseItems[nC].wIndex), TObject(m_UseItems[nC].MakeIndex));
              end;
              m_UseItems[nC].wIndex := 0;
            end;
          end;
        end;
      end;
      Inc(nC);
      if nC >= 9 then break;
    end;
    if DropItemList <> nil then
      SendMsg(Self, RM_SENDDELITEMLIST, 0, Integer(DropItemList), 0, 0, '');
  except
    MainOutMessage(sExceptionMsg);
  end;
end;

{执行杀怪触发}
function TPlayObject.KillMonsterFunc(): Boolean;
  function GotoKillMonsterFunc(): Boolean;
  begin
    Result := False;
    if g_FunctionNPC <> nil then begin
      g_FunctionNPC.GotoLable(Self, '@KillMonster', False);
      Result := True;
    end;
  end;
begin
  Result := False;
  if m_ExpHitter <> nil then begin
    if m_ExpHitter.m_btRaceServer >= RC_ANIMAL then begin
      m_sString[0] := m_ExpHitter.m_sCharName;
      m_nInteger[0] := m_ExpHitter.m_Abil.Level;
      Result := GotoKillMonsterFunc;
    end;
  end;
end;

procedure TBaseObject.Die;
var
  boPK, guildwarkill: Boolean;
  tStr: string;
  tExp: LongWord;
  i: Integer;
  GroupHuman: TPlayObject;
  QuestNPC: TMerchant;
  tCheck: Boolean;
  AttackBaseObject: TBaseObject;
  Castle: TUserCastle;
  nCheckCode: Integer;
  n10: Integer;
resourcestring
  sExceptionMsg1 = '[Exception] TBaseObject::Die 1';
  sExceptionMsg2 = '[Exception] TBaseObject::Die 2';
  sExceptionMsg3 = '[Exception] TBaseObject::Die 3 CheckCode:';
begin
  if m_boSuperMan then Exit;
  if m_boSupermanItem then Exit;
  m_boDeath := True;
  m_dwDeathTick := GetTickCount();
  sub_4BC87C();
  if m_Master <> nil then begin
    m_ExpHitter := nil;
    m_LastHiter := nil;
  end;
  m_nIncSpell := 0;
  m_nIncHealth := 0;
  m_nIncHealing := 0;

  try
    if Assigned(zPlugOfEngine.ObjectDie) then begin
      try
        if zPlugOfEngine.ObjectDie(Self) then Exit;
      except
      end;
    end;
    if (m_btRaceServer <> RC_PLAYOBJECT) and (m_LastHiter <> nil) then begin
      if g_Config.boMonSayMsg then MonsterSayMsg(m_LastHiter, s_Die);
      if (m_ExpHitter <> nil) then begin
        if m_ExpHitter.m_btRaceServer = RC_PLAYOBJECT then begin
          tExp := m_ExpHitter.CalcGetExp(m_Abil.Level, m_dwFightExp);
          if not g_Config.boVentureServer then begin
            TPlayObject(m_ExpHitter).GainExp(tExp);
          end;
          //是否执行任务脚本
          if m_PEnvir.IsCheapStuff then begin
            if (m_ExpHitter.m_GroupOwner <> nil) and (m_ExpHitter.m_GroupOwner.m_GroupMembers <> nil) and (m_ExpHitter.m_GroupOwner.m_GroupMembers.Count > 0) then begin
              for i := 0 to m_ExpHitter.m_GroupOwner.m_GroupMembers.Count - 1 do begin
                GroupHuman := TPlayObject(m_ExpHitter.m_GroupOwner.m_GroupMembers.Objects[i]);
                if GroupHuman <> nil then begin
                  if not GroupHuman.m_boDeath and (m_ExpHitter.m_PEnvir = GroupHuman.m_PEnvir) and (abs(m_ExpHitter.m_nCurrX - GroupHuman.m_nCurrX) <= 12) and (abs(m_ExpHitter.m_nCurrX - GroupHuman.m_nCurrX) <= 12) and (m_ExpHitter = GroupHuman) then begin
                    tCheck := False;
                  end else begin
                    tCheck := True;
                  end;
                  QuestNPC := TMerchant(m_PEnvir.GetQuestNPC(GroupHuman, m_sCharName, '', tCheck));
                  if QuestNPC <> nil then begin
                    QuestNPC.Click(GroupHuman);
                  end;
                end;
              end;
            end;
            QuestNPC := TMerchant(m_PEnvir.GetQuestNPC(m_ExpHitter, m_sCharName, '', False));
            if QuestNPC <> nil then begin
              QuestNPC.Click(TPlayObject(m_ExpHitter));
            end;
          end;
        end else begin
          if m_ExpHitter.m_Master <> nil then begin
            m_ExpHitter.GainSlaveExp(m_Abil.Level);
            tExp := m_ExpHitter.m_Master.CalcGetExp(m_Abil.Level, m_dwFightExp);
            if not g_Config.boVentureServer then begin
              TPlayObject(m_ExpHitter.m_Master).GainExp(tExp);
            end;
          end;
        end;
      end else begin
        if m_LastHiter.m_btRaceServer = RC_PLAYOBJECT then begin
          tExp := m_LastHiter.CalcGetExp(m_Abil.Level, m_dwFightExp);
          if not g_Config.boVentureServer then begin
            TPlayObject(m_LastHiter).GainExp(tExp);
          end;
        end;
      end;
    end;
    if (g_Config.boMonSayMsg) and (m_btRaceServer = RC_PLAYOBJECT) and (m_LastHiter <> nil) then begin
      m_LastHiter.MonsterSayMsg(Self, s_KillHuman);
    end;
    {执行杀怪触发}
    if (m_LastHiter <> nil) and (m_LastHiter.m_btRaceServer = RC_PLAYOBJECT) then TPlayObject(m_LastHiter).KillMonsterFunc;
    m_Master := nil;
  except
    on E: Exception do begin
      MainOutMessage(sExceptionMsg1);
      MainOutMessage(E.Message);
    end;
  end;
  {执行杀人和死亡触发}
  if (m_LastHiter <> nil) and (m_btRaceServer = RC_PLAYOBJECT) then TPlayObject(Self).DieGotoLable();

  try
    boPK := False;
    if (not g_Config.boVentureServer) and (not m_PEnvir.m_boFightZone) and (not m_PEnvir.m_boFight3Zone) then begin
      if (m_btRaceServer = RC_PLAYOBJECT) and (m_LastHiter <> nil) and (PKLevel < 2) then begin
        //            if (m_LastHiter.m_btRaceServer = RC_PLAYOBJECT) then
        if (m_LastHiter.m_btRaceServer = RC_PLAYOBJECT) or (m_LastHiter.m_btRaceServer = RC_NPC) then begin
          {修改日期2004/07/21，允许NPC杀死人物}
          boPK := True;
        end;
        if m_LastHiter.m_Master <> nil then
          if m_LastHiter.m_Master.m_btRaceServer = RC_PLAYOBJECT then begin
            m_LastHiter := m_LastHiter.m_Master;
            boPK := True;
          end;
      end;
    end;

    if boPK and (m_LastHiter <> nil) then begin
      guildwarkill := False;
      if (m_MyGuild <> nil) and (m_LastHiter.m_MyGuild <> nil) then begin
        if GetGuildRelation(Self, m_LastHiter) = 2 then
          guildwarkill := True;
      end;
      Castle := g_CastleManager.InCastleWarArea(Self);
      if ((Castle <> nil) and Castle.m_boUnderWar) or (m_boInFreePKArea) then
        guildwarkill := True;
      {
      if UserCastle.m_boUnderWar then
         if (m_boInFreePKArea) or (UserCastle.InCastleWarArea(m_PEnvir, m_nCurrX, m_nCurrY)) then
            guildwarkill := TRUE;
      }
      (*
      if not guildwarkill then begin
         if not m_LastHiter.IsGoodKilling(self) then begin
            m_LastHiter.IncPkPoint (nKillHumanAddPKPoint{100});
            m_LastHiter.SysMsg ('你犯了谋杀罪！！！', c_Red,t_Hint);
            SysMsg('你被 ' + m_LastHiter.m_sCharName + '杀害了！！！',c_Red,t_Hint);
            m_LastHiter.AddBodyLuck (-nKillHumanDecLuckPoint{500});
            if PkLevel < 1 then
               if Random(5) = 0 then
                  m_LastHiter.MakeWeaponUnlock;
         end else
            m_LastHiter.SysMsg ('[你受到正当规则保护。]', c_Green,t_Hint);
      end;
      *)
      //=================================================================
      //
      if not guildwarkill then begin
        if (g_Config.boKillHumanWinLevel or g_Config.boKillHumanWinExp or m_PEnvir.m_boPKWINLEVEL or m_PEnvir.m_boPKWINEXP) and (m_LastHiter.m_btRaceServer = RC_PLAYOBJECT) then begin
          TPlayObject(Self).PKDie(TPlayObject(m_LastHiter));
        end else begin
          if not m_LastHiter.IsGoodKilling(Self) then begin
            m_LastHiter.IncPkPoint(g_Config.nKillHumanAddPKPoint {100});
            m_LastHiter.SysMsg(g_sYouMurderedMsg {'你犯了谋杀罪！！！'}, c_Red, t_Hint);
            SysMsg(format(g_sYouKilledByMsg, [m_LastHiter.m_sCharName]), c_Red, t_Hint);
            m_LastHiter.AddBodyLuck(-g_Config.nKillHumanDecLuckPoint {500});
            if PKLevel < 1 then
              if Random(5) = 0 then
                m_LastHiter.MakeWeaponUnlock;
          end else
            m_LastHiter.SysMsg(g_sYouProtectedByLawOfDefense {'[你受到正当规则保护。]'}, c_Green, t_Hint);
        end;
        //检查攻击人是否用了着经验或等级装备
        if m_LastHiter.m_btRaceServer = RC_PLAYOBJECT then begin
          if m_LastHiter.m_dwPKDieLostExp > 0 then begin
            if m_Abil.Exp >= m_LastHiter.m_dwPKDieLostExp then begin
              Dec(m_Abil.Exp, m_LastHiter.m_dwPKDieLostExp);
            end else m_Abil.Exp := 0;
          end;
          if m_LastHiter.m_nPKDieLostLevel > 0 then begin
            if m_Abil.Level >= m_LastHiter.m_nPKDieLostLevel then begin
              Dec(m_Abil.Level, m_LastHiter.m_nPKDieLostLevel);
            end else m_Abil.Level := 0;
          end;
        end;
      end;
      //=================================================================
    end;
  except
    MainOutMessage(sExceptionMsg2);
  end;

  try
    if (not m_PEnvir.m_boFightZone) and
      (not m_PEnvir.m_boFight3Zone) and
      (not m_boAnimal) then begin
      AttackBaseObject := m_ExpHitter;
      if (m_ExpHitter <> nil) and (m_ExpHitter.m_Master <> nil) then begin
        AttackBaseObject := m_ExpHitter.m_Master;
      end;
      if m_btRaceServer <> RC_PLAYOBJECT then begin
        nCheckCode := 1000;
        if AttackBaseObject <> nil then
          DropUseItems(AttackBaseObject);
        nCheckCode := 1001;
        if (m_Master = nil) and (not m_boNoItem) and (AttackBaseObject <> nil) then
          ScatterBagItems(AttackBaseObject);
        nCheckCode := 1002;
        if (m_btRaceServer >= RC_ANIMAL) and (m_Master = nil) and (not m_boNoItem) then begin
          if (AttackBaseObject <> nil) and (AttackBaseObject.m_btRaceServer = RC_PLAYOBJECT) and (g_Config.boDropGoldToPlayBag) then begin
            if TPlayObject(AttackBaseObject).IncGold(m_nGold) then begin
              nCheckCode := 1003;
              TPlayObject(AttackBaseObject).GoldChanged();
              nCheckCode := 1004;
            end else begin
              ScatterGolds(AttackBaseObject);
              nCheckCode := 1005;
            end;
          end else begin
            ScatterGolds(AttackBaseObject);
            nCheckCode := 1006;
          end;
        end;
      end else begin
        if not m_boNoItem then begin {修改日期2004/07/21，增加此行，允许设置 m_boNoItem 后人物死亡不掉物品}
          if AttackBaseObject <> nil then begin
            if (g_Config.boKillByHumanDropUseItem and (AttackBaseObject.m_btRaceServer = RC_PLAYOBJECT)) or (g_Config.boKillByMonstDropUseItem and (AttackBaseObject.m_btRaceServer <> RC_PLAYOBJECT)) then
              nCheckCode := 1007;
            DropUseItems(nil);
            nCheckCode := 1008;
          end else begin
            nCheckCode := 1009;
            DropUseItems(nil);
            nCheckCode := 1010;
          end;
          nCheckCode := 1011;
          if g_Config.boDieScatterBag then ScatterBagItems(nil);
          if g_Config.boDieDropGold then ScatterGolds(nil);
          nCheckCode := 1012;
        end;
        AddBodyLuck(-(50 - (50 - m_Abil.Level * 5)));
        nCheckCode := 1013;
      end;
    end;
    if m_PEnvir.m_boFight3Zone then begin
      Inc(m_nFightZoneDieCount);
      if m_MyGuild <> nil then begin
        nCheckCode := 1014;
        TGUild(m_MyGuild).TeamFightWhoDead(m_sCharName);
        nCheckCode := 1015;
      end;
      if (m_LastHiter <> nil) then begin
        if (m_LastHiter.m_MyGuild <> nil) and (m_MyGuild <> nil) then begin
          TGUild(m_LastHiter.m_MyGuild).TeamFightWhoWinPoint(m_LastHiter.m_sCharName, 100); //matchpoint 刘啊, 俺牢己利 扁废
          tStr := TGUild(m_LastHiter.m_MyGuild).sGuildName + ':' +
            IntToStr(TGUild(m_LastHiter.m_MyGuild).nContestPoint) + '  ' +
            TGUild(m_MyGuild).sGuildName + ':' +
            IntToStr(TGUild(m_MyGuild).nContestPoint);
          UserEngine.CryCry(RM_CRY, m_PEnvir, m_nCurrX, m_nCurrY, 1000, g_Config.btCryMsgFColor, g_Config.btCryMsgBColor, '- ' + tStr);
        end;
      end;
    end;

    if m_btRaceServer = RC_PLAYOBJECT then begin
      //Jacky 2004/09/05
      //人物死亡立即退组，以防止组队刷经验
      if m_GroupOwner <> nil then m_GroupOwner.DelMember(Self);
      if m_LastHiter <> nil then begin
        if m_LastHiter.m_btRaceServer = RC_PLAYOBJECT then tStr := m_LastHiter.m_sCharName
        else tStr := '#' + m_LastHiter.m_sCharName;
      end else tStr := '####';
      AddGameDataLog('19' + #9 +
        m_sMapName + #9 +
        IntToStr(m_nCurrX) + #9 +
        IntToStr(m_nCurrY) + #9 +
        m_sCharName + #9 +
        'FZ-' + BoolToIntStr(m_PEnvir.m_boFightZone) +
        '_F3-' + BoolToIntStr(m_PEnvir.m_boFight3Zone) + #9 +
        '0' + #9 +
        '1' + #9 +
        tStr);
    end;
    //减少地图上怪物计数
    if (m_Master = nil) and (not m_boDelFormMaped) then begin
      nCheckCode := 1016;
      m_PEnvir.DelObjectCount(Self);
      m_boDelFormMaped := True;
      nCheckCode := 1017;
    end;
    SendRefMsg(RM_DEATH, m_btDirection, m_nCurrX, m_nCurrY, 1, '');
  except
    MainOutMessage(sExceptionMsg3 + IntToStr(nCheckCode));
  end;
end;

procedure TPlayObject.PKDie(PlayObject: TPlayObject);
var
  nWinLevel, nLostLevel, nWinExp, nLostExp: Integer;
  boWinLEvel, boLostLevel, boWinExp, boLostExp: Boolean;
begin
  nWinLevel := g_Config.nKillHumanWinLevel;
  nLostLevel := g_Config.nKilledLostLevel;
  nWinExp := g_Config.nKillHumanWinExp;
  nLostExp := g_Config.nKillHumanLostExp;

  boWinLEvel := g_Config.boKillHumanWinLevel;
  boLostLevel := g_Config.boKilledLostLevel;
  boWinExp := g_Config.boKillHumanWinExp;
  boLostExp := g_Config.boKilledLostExp;

  if m_PEnvir.m_boPKWINLEVEL then begin
    boWinLEvel := True;
    nWinLevel := m_PEnvir.m_nPKWINLEVEL;
  end;
  if m_PEnvir.m_boPKLOSTLEVEL then begin
    boLostLevel := True;
    nLostLevel := m_PEnvir.m_nPKLOSTLEVEL;
  end;
  if m_PEnvir.m_boPKWINEXP then begin
    boWinExp := True;
    nWinExp := m_PEnvir.m_nPKWINEXP;
  end;
  if m_PEnvir.m_boPKLOSTEXP then begin
    boLostExp := True;
    nLostExp := m_PEnvir.m_nPKLOSTEXP;
  end;

  if PlayObject.m_Abil.Level - m_Abil.Level > g_Config.nHumanLevelDiffer then begin
    if not PlayObject.IsGoodKilling(Self) then begin
      PlayObject.IncPkPoint(g_Config.nKillHumanAddPKPoint {100});
      PlayObject.SysMsg(g_sYouMurderedMsg {'你犯了谋杀罪！！！'}, c_Red, t_Hint);
      SysMsg(format(g_sYouKilledByMsg, [m_LastHiter.m_sCharName]), c_Red, t_Hint);
      PlayObject.AddBodyLuck(-g_Config.nKillHumanDecLuckPoint {500});
      if PKLevel < 1 then
        if Random(5) = 0 then
          PlayObject.MakeWeaponUnlock;
    end else begin
      PlayObject.SysMsg(g_sYouProtectedByLawOfDefense {'[你受到正当规则保护。]'}, c_Green, t_Hint);
    end;
    Exit;
  end;
  if boWinLEvel then begin
    //Inc(PlayObject.m_Abil.Level,nWinLevel);
    if PlayObject.m_Abil.Level + nWinLevel <= MAXUPLEVEL then begin
      Inc(PlayObject.m_Abil.Level, nWinLevel);
    end else begin
      PlayObject.m_Abil.Level := MAXUPLEVEL;
    end;
    PlayObject.HasLevelUp(PlayObject.m_Abil.Level - nWinLevel);

    if boLostLevel then begin
      if PKLevel >= 2 then begin
        if m_Abil.Level >= nLostLevel * 2 then
          Dec(m_Abil.Level, nLostLevel * 2);
      end else begin
        if m_Abil.Level >= nLostLevel then
          Dec(m_Abil.Level, nLostLevel);
      end;
    end;
  end;

  if boWinExp then begin
    PlayObject.WinExp(nWinExp);
    if boLostExp then begin
      if m_Abil.Exp >= LongWord(nLostExp) then begin
        if m_Abil.Exp >= LongWord(nLostExp) then begin
          Dec(m_Abil.Exp, LongWord(nLostExp));
        end else begin
          m_Abil.Exp := 0;
        end;
      end else begin
        if m_Abil.Level >= 1 then begin
          Dec(m_Abil.Level);
          Inc(m_Abil.Exp, GetLevelExp(m_Abil.Level));
          if m_Abil.Exp >= LongWord(nLostExp) then begin
            Dec(m_Abil.Exp, LongWord(nLostExp));
          end else begin
            m_Abil.Exp := 0;
          end;
        end else begin
          m_Abil.Level := 0;
          m_Abil.Exp := 0;
        end;
        //HasLevelUp(m_Abil.Level + 1);
      end;
    end;
  end;
end;

procedure TBaseObject.ReAlive;
begin
  m_boDeath := False;
  SendRefMsg(RM_ALIVE, m_btDirection, m_nCurrX, m_nCurrY, 0, '');
end;

procedure TBaseObject.SetLastHiter(BaseObject: TBaseObject);
begin
  m_LastHiter := BaseObject;
  m_LastHiterTick := GetTickCount();
  if m_ExpHitter = nil then begin
    m_ExpHitter := BaseObject;
    m_ExpHitterTick := GetTickCount();
  end else begin
    if m_ExpHitter = BaseObject then
      m_ExpHitterTick := GetTickCount();
  end;
end;

procedure TBaseObject.SetPKFlag(BaseObject: TBaseObject);
begin
  if (PKLevel < 2) and
    (BaseObject.PKLevel < 2) and
    (not m_PEnvir.m_boFightZone) and
    (not m_PEnvir.m_boFight3Zone) and
    (not m_boPKFlag) then begin

    BaseObject.m_dwPKTick := GetTickCount();
    if not BaseObject.m_boPKFlag then begin
      BaseObject.m_boPKFlag := True;
      BaseObject.RefNameColor();
    end;
  end;
end;

procedure TBaseObject.sub_4BC87C;
var
  i: Integer;
begin
  for i := 0 to LIst_3EC.Count - 1 do begin

  end;
  LIst_3EC.Clear;
end;

function TBaseObject.IsGoodKilling(Cert: TBaseObject): Boolean;
begin
  Result := False;
  if Cert.m_boPKFlag then Result := True;
end;

function TBaseObject.IsProtectTarget(BaseObject: TBaseObject): Boolean;
begin
  Result := True;
  if BaseObject = nil then Exit;
  if (InSafeZone) or (BaseObject.InSafeZone) then Result := False;
  if not BaseObject.m_boInFreePKArea then begin
    //新人保护
    if g_Config.boPKLevelProtect then begin
      if (m_Abil.Level > g_Config.nPKProtectLevel) then begin //如果大于指定等级
        if not BaseObject.m_boPKFlag and (BaseObject.m_Abil.Level <= g_Config.nPKProtectLevel) and (BaseObject.PKLevel < 2) then begin
          //被攻击的人物小指定等级没有红名，则不可以攻击。
          Result := False;
          Exit;
        end;
      end;
      if (m_Abil.Level <= g_Config.nPKProtectLevel) then begin //如果小于指定等级
        if not BaseObject.m_boPKFlag and (BaseObject.m_Abil.Level > g_Config.nPKProtectLevel) and (BaseObject.PKLevel < 2) then begin
          Result := False;
          Exit;
        end;
      end;
    end;

    {
    //大于指定级别的红名人物不可以杀指定级别未红名的人物。
    if (PKLevel >= 2) and (m_Abil.Level > 10) then begin
      if (BaseObject.m_Abil.Level <= 10) and (BaseObject.PKLevel < 2) then begin
        Result:=False;
        exit;
      end;
    end;

    //小于指定级别的非红名人物不可以杀指定级别红名人物。
    if (m_Abil.Level <= 10) and (PKLevel < 2) then begin
      if (BaseObject.PKLevel >= 2) and (BaseObject.m_Abil.Level > 10) then begin
        Result:=False;
        exit;
      end;
    end;
    }
    //大于指定级别的红名人物不可以杀指定级别未红名的人物。
    if (PKLevel >= 2) and (m_Abil.Level > g_Config.nRedPKProtectLevel) then begin
      if (BaseObject.m_Abil.Level <= g_Config.nRedPKProtectLevel) and (BaseObject.PKLevel < 2) then begin
        Result := False;
        Exit;
      end;
    end;

    //小于指定级别的非红名人物不可以杀指定级别红名人物。
    if (m_Abil.Level <= g_Config.nRedPKProtectLevel) and (PKLevel < 2) then begin
      if (BaseObject.PKLevel >= 2) and (BaseObject.m_Abil.Level > g_Config.nRedPKProtectLevel) then begin
        Result := False;
        Exit;
      end;
    end;

    if (GetTickCount - m_dwMapMoveTick < 3000) or (GetTickCount - BaseObject.m_dwMapMoveTick < 3000) then
      Result := False;
  end;
end;

function TBaseObject.IsAttackTarget(BaseObject: TBaseObject): Boolean;
  function sub_4C88E4(): Boolean;
  begin
    Result := True;
  end;
var
  i: Integer;
begin
  Result := False;
  if (BaseObject = nil) or (BaseObject = Self) then Exit;
  if m_btRaceServer >= RC_ANIMAL {50} then begin
    if m_Master <> nil then begin
      if (m_Master.m_LastHiter = BaseObject) or
        (m_Master.m_ExpHitter = BaseObject) or
        (m_Master.m_TargetCret = BaseObject) then Result := True; {宝宝攻击}

      if BaseObject.m_TargetCret <> nil then begin
        if (BaseObject.m_TargetCret = m_Master) or
          (BaseObject.m_TargetCret.m_Master = m_Master) and
          (BaseObject.m_btRaceServer <> RC_PLAYOBJECT) then
          Result := True;
      end;

      if (BaseObject.m_TargetCret = Self) and (BaseObject.m_btRaceServer >= RC_ANIMAL) then
        Result := True;

      if BaseObject.m_Master <> nil then begin
        if (BaseObject.m_Master = m_Master.m_LastHiter) or (BaseObject.m_Master = m_Master.m_TargetCret) then
          Result := True;
      end;

      if BaseObject.m_Master = m_Master then Result := False; {检测是自己的宝宝}

      if BaseObject.m_boHolySeize then Result := False;

      if m_Master.m_boSlaveRelax then Result := False;

      if BaseObject.m_btRaceServer = RC_PLAYOBJECT then begin {检测目标是人物}
        //if (m_Master.InSafeZone) or (BaseObject.InSafeZone) then begin
        if BaseObject.InSafeZone then
          Result := False;
      end;
      BreakCrazyMode();
    end else begin
      if BaseObject.m_btRaceServer = RC_PLAYOBJECT then
        Result := True;
      if (m_btRaceServer > RC_PEACENPC {15}) and (m_btRaceServer < RC_ANIMAL {50}) then
        Result := True;
      if BaseObject.m_Master <> nil then
        Result := True;
    end;
    if m_boCrazyMode then
      Result := True;
  end else begin
    if m_btRaceServer = RC_PLAYOBJECT then begin {增加分身检测}
      case m_btAttatckMode of
        HAM_ALL {0}: begin
            if (BaseObject.m_btRaceServer < RC_NPC {10}) or (BaseObject.m_btRaceServer > RC_PEACENPC {15}) then
              Result := True;
            if g_Config.boNonPKServer then
              Result := sub_4C88E4();
          end;
        HAM_PEACE {1}: begin
            if BaseObject.m_btRaceServer >= RC_ANIMAL then
              Result := True;
          end;
        HAM_DEAR: begin
            if BaseObject <> TPlayObject(Self).m_DearHuman then begin
              Result := True;
            end;
          end;
        HAM_MASTER: begin
            if BaseObject.m_btRaceServer = RC_PLAYOBJECT then begin
              Result := True;
              if TPlayObject(Self).m_boMaster then begin
                for i := 0 to TPlayObject(Self).m_MasterList.Count - 1 do begin
                  if TPlayObject(Self).m_MasterList.Items[i] = BaseObject then begin
                    Result := False;
                    break;
                  end;
                end;
              end;
              if TPlayObject(BaseObject).m_boMaster then begin
                for i := 0 to TPlayObject(BaseObject).m_MasterList.Count - 1 do begin
                  if TPlayObject(BaseObject).m_MasterList.Items[i] = Self then begin
                    Result := False;
                    break;
                  end;
                end;
              end;
            end else Result := True;
          end;
        HAM_GROUP {2}: begin
            if (BaseObject.m_btRaceServer < RC_NPC) or (BaseObject.m_btRaceServer > RC_PEACENPC) then
              Result := True;
            if BaseObject.m_btRaceServer = RC_PLAYOBJECT then
              if IsGroupMember(BaseObject) then
                Result := False;
            if g_Config.boNonPKServer then
              Result := sub_4C88E4();
          end;
        HAM_GUILD {3}: begin
            if (BaseObject.m_btRaceServer < RC_NPC) or (BaseObject.m_btRaceServer > RC_PEACENPC) then
              Result := True;
            if BaseObject.m_btRaceServer = RC_PLAYOBJECT then
              if m_MyGuild <> nil then begin
                if TGUild(m_MyGuild).IsMember(BaseObject.m_sCharName) then
                  Result := False;
                if m_boGuildWarArea and (BaseObject.m_MyGuild <> nil) then begin
                  if TGUild(m_MyGuild).IsAllyGuild(TGUild(BaseObject.m_MyGuild)) then
                    Result := False;
                end;
              end;
            if g_Config.boNonPKServer then
              Result := sub_4C88E4();
          end;
        HAM_PKATTACK {4}: begin
            if (BaseObject.m_btRaceServer < RC_NPC) or (BaseObject.m_btRaceServer > RC_PEACENPC) then
              Result := True;
            if BaseObject.m_btRaceServer = RC_PLAYOBJECT then
              if PKLevel >= 2 then begin
                if BaseObject.PKLevel < 2 then
                  Result := True
                else Result := False;
              end else begin
                if BaseObject.PKLevel >= 2 then
                  Result := True
                else Result := False;
              end;
            if g_Config.boNonPKServer then
              Result := sub_4C88E4();
          end;
      end;
    end else Result := True;
  end;
  if BaseObject.m_boAdminMode or BaseObject.m_boStoneMode then
    Result := False;
end;

function TBaseObject.IsProperTarget(BaseObject: TBaseObject): Boolean;
begin
  Result := IsAttackTarget(BaseObject);
  if Result then begin
    if (m_btRaceServer = RC_PLAYOBJECT) and (BaseObject.m_btRaceServer = RC_PLAYOBJECT) then begin
      Result := IsProtectTarget(BaseObject); {检测人物是否符合攻击要求}
    end;
  end;
  if (BaseObject <> nil) and
    (m_btRaceServer = RC_PLAYOBJECT) and
    (BaseObject.m_Master <> nil) and
    (BaseObject.m_btRaceServer <> RC_PLAYOBJECT) then begin
    if BaseObject.m_Master = Self then begin
      if m_btAttatckMode <> HAM_ALL {0} then Result := False; {检测是否是自己的宝宝}
    end else begin
      Result := IsAttackTarget(BaseObject.m_Master);
      if InSafeZone or BaseObject.InSafeZone then Result := False; {检测是否是在安全区}
    end;
  end;
end;

//擒龙手目标检测
function TBaseObject.IsProperTargetSKILL_55(nLevel: Integer; BaseObject: TBaseObject): Boolean;
begin
  Result := False;
  if (BaseObject = nil) or (BaseObject = Self) then Exit;
  if (BaseObject.m_btRaceServer < RC_NPC) or (BaseObject.m_btRaceServer > RC_PEACENPC) then begin
    if (BaseObject.m_btRaceServer <> RC_GUARD) and
      (BaseObject.m_btRaceServer <> RC_ARCHERGUARD) and
      (BaseObject.m_btRaceServer <> 110) and
      (BaseObject.m_btRaceServer <> 111) and
      (nLevel >= BaseObject.m_Abil.Level) and
      (not BaseObject.m_boGhost) and
      (not BaseObject.m_boDeath) then begin
      if ((not g_Config.boPullPlayObject) or (nLevel < BaseObject.m_Abil.Level)) and (BaseObject.m_btRaceServer = RC_PLAYOBJECT) then Exit;
      if g_Config.boPullCrossInSafeZone and (BaseObject.m_btRaceServer = RC_PLAYOBJECT) and BaseObject.InSafeZone then Exit;
      Result := True;
    end;
  end;
end;

//移行换位
function TBaseObject.IsProperTargetSKILL_56(BaseObject: TBaseObject; nTargetX, nTargetY: Integer): Boolean;
begin
  Result := False;
  if (BaseObject <> nil) or (m_PEnvir = nil) then Exit;
  if m_PEnvir.CanWalk(nTargetX, nTargetY, True) then begin
    Result := True;
  end;
end;

//骷髅咒
function TBaseObject.IsProperTargetSKILL_54(BaseObject: TBaseObject): Boolean;
begin
  Result := False;
  if (BaseObject = nil) or (BaseObject = Self) then Exit;
  if BaseObject.m_boDeath and (BaseObject.m_btRaceServer = RC_PLAYOBJECT) then begin
    if (BaseObject.m_btRaceServer < RC_NPC) or (BaseObject.m_btRaceServer > RC_PEACENPC) then begin
      if (BaseObject.m_btRaceServer <> RC_GUARD) and
        (BaseObject.m_btRaceServer <> RC_ARCHERGUARD) and
        (BaseObject.m_btRaceServer <> 110) and
        (BaseObject.m_btRaceServer <> 111) then Result := True;
    end;
  end;
end;

//复活术
function TBaseObject.IsProperTargetSKILL_57(BaseObject: TBaseObject): Boolean;
begin
  Result := False;
  if (BaseObject = nil) or (BaseObject = Self) then Exit;
  if BaseObject.m_boDeath and (BaseObject.m_btRaceServer = RC_PLAYOBJECT) then begin
    if TPlayObject(BaseObject).m_boAllowReAlive then Result := True
    else SysMsg('对方禁止复活！！！', c_Green, t_Hint);
  end;
end;

//召唤NPC
function TBaseObject.IsProperTargetSKILL_70(PlayObject: TBaseObject): Boolean;
begin
  Result := False;
  if (g_FunctionNPC <> nil) and (PlayObject <> nil) then begin
    if PlayObject.m_btRaceServer = RC_PLAYOBJECT then begin
      g_FunctionNPC.GotoLable(TPlayObject(PlayObject), '@Magic', False);
      Result := True;
    end;
  end;
end;

//触发函数
function TPlayObject.DieGotoLable(): Boolean;
begin
  Result := False;
  if (m_LastHiter <> nil) and (m_btRaceServer = RC_PLAYOBJECT) then begin
    if m_LastHiter.m_Master <> nil then begin
      if m_LastHiter.m_Master.m_btRaceServer = RC_PLAYOBJECT then begin
        m_sString[0] := TPlayObject(m_LastHiter.m_Master).m_sCharName;
        m_nInteger[0] := TPlayObject(m_LastHiter.m_Master).m_WAbil.Level;
        TPlayObject(m_LastHiter.m_Master).m_sString[0] := m_sCharName;
        TPlayObject(m_LastHiter.m_Master).m_nInteger[0] := m_WAbil.Level;
        TPlayObject(m_LastHiter.m_Master).KillPlayFunc;
      end;
    end else
      if m_LastHiter.m_btRaceServer = RC_PLAYOBJECT then begin
      m_sString[0] := TPlayObject(m_LastHiter).m_sCharName;
      m_nInteger[0] := TPlayObject(m_LastHiter).m_WAbil.Level;
      TPlayObject(m_LastHiter).m_sString[0] := m_sCharName;
      TPlayObject(m_LastHiter).m_nInteger[0] := m_WAbil.Level;
      TPlayObject(m_LastHiter).KillPlayFunc;
    end;
    if m_LastHiter.m_btRaceServer <> RC_PLAYOBJECT then begin
      m_sString[0] := m_LastHiter.m_sCharName;
      m_nInteger[0] := m_LastHiter.m_WAbil.Level;
    end;
    Result := DieFunc(); //死亡触发
  end;
end;

procedure TBaseObject.WeightChanged;
begin
  m_WAbil.Weight := RecalcBagWeight();
  SendUpdateMsg(Self, RM_WEIGHTCHANGED, 0, 0, 0, 0, '');
end;

function TBaseObject.InSafeZone: Boolean;
var
  i, nSafePoint, nSafeX, nSafeY: Integer;
  sMapName: string;
  StartPoint: pTStartPoint;
begin
  if m_PEnvir = nil then begin //修正机器人刷火墙的错误 叶随风飘
    Result := True;
    Exit;
  end;
  Result := m_PEnvir.m_boSAFE;
  if Result then Exit;
  if (m_PEnvir.sMapName <> g_Config.sRedHomeMap) or
    (abs(m_nCurrX - g_Config.nRedHomeX) > g_Config.nSafeZoneSize) or
    (abs(m_nCurrY - g_Config.nRedHomeY) > g_Config.nSafeZoneSize) then begin
    Result := False;
  end else begin
    Result := True;
  end;
  if Result then Exit;
  try
    g_StartPointList.Lock;
    for i := 0 to g_StartPointList.Count - 1 do begin
      sMapName := g_StartPointList.Strings[i];
      {nSafePoint := Integer(g_StartPointList.Objects[i]);
      nSafeX := LoWord(nSafePoint);
      nSafeY := HiWord(nSafePoint); }
      if (sMapName = m_PEnvir.sMapName) then begin
        StartPoint := pTStartPoint(g_StartPointList.Objects[i]);
        if StartPoint <> nil then begin
          nSafeX := StartPoint.m_nCurrX;
          nSafeY := StartPoint.m_nCurrY;
          if (abs(m_nCurrX - nSafeX) <= g_Config.nSafeZoneSize) and
            (abs(m_nCurrY - nSafeY) <= g_Config.nSafeZoneSize) then begin
            Result := True;
            break;
          end;
        end;
      end;
    end;
  finally
    g_StartPointList.UnLock;
  end;
end;

function TBaseObject.InSafeZone(Envir: TEnvirnoment; nX,
  nY: Integer): Boolean;
var
  i, nSafePoint, nSafeX, nSafeY: Integer;
  sMapName: string;
  StartPoint: pTStartPoint;
begin
  if m_PEnvir = nil then begin //修正机器人刷火墙的错误 叶随风飘
    Result := True;
    Exit;
  end;
  Result := Envir.m_boSAFE;
  if Result then Exit;
  if (Envir.sMapName <> g_Config.sRedHomeMap) or
    (abs(nX - g_Config.nRedHomeX) > g_Config.nSafeZoneSize) or
    (abs(nY - g_Config.nRedHomeY) > g_Config.nSafeZoneSize) then begin
    Result := False;
  end else begin
    Result := True;
  end;
  if Result then Exit;
  try
    g_StartPointList.Lock;
    for i := 0 to g_StartPointList.Count - 1 do begin
      sMapName := g_StartPointList.Strings[i];
      if (sMapName = Envir.sMapName) then begin
        StartPoint := pTStartPoint(g_StartPointList.Objects[i]);
        if StartPoint <> nil then begin
          nSafeX := StartPoint.m_nCurrX;
          nSafeY := StartPoint.m_nCurrY;
          if (abs(nX - nSafeX) <= g_Config.nSafeZoneSize) and
            (abs(nY - nSafeY) <= g_Config.nSafeZoneSize) then begin
            Result := True;
            break;
          end;
        end;
      end;
    end;
  finally
    g_StartPointList.UnLock;
  end;
end;

{function TBaseObject.InSafeZone: Boolean;
var
  i, nSafePoint, nSafeX, nSafeY: Integer;
  sMapName: string;
  StartPoint: pTStartPoint;
  nStartX,nStartY:Integer;
  nEndX,nEndY:Integer;
begin
  Result := m_PEnvir.m_boSAFE;
  if Result then Exit;
  if (m_PEnvir.sMapName <> g_Config.sRedHomeMap) or
    (abs(m_nCurrX - g_Config.nRedHomeX) > g_Config.nSafeZoneSize) or
    (abs(m_nCurrY - g_Config.nRedHomeY) > g_Config.nSafeZoneSize) then begin
    Result := False;
  end else begin
    Result := True;
  end;
  if Result then Exit;
  try
    g_StartPointList.Lock;
    for i := 0 to g_StartPointList.Count - 1 do begin
      sMapName := g_StartPointList.Strings[i];
      if (sMapName = m_PEnvir.sMapName) then begin
        StartPoint := pTStartPoint(g_StartPointList.Objects[i]);
        if StartPoint <> nil then begin
          nStartX:=StartPoint.m_nCurrX - StartPoint.m_nRange;
          nEndX:=StartPoint.m_nCurrX + StartPoint.m_nRange;
          nStartY:=StartPoint.m_nCurrY - StartPoint.m_nRange;
          nEndY:=StartPoint.m_nCurrY - StartPoint.m_nRange;
          if (m_nCurrX in [nStartX..nEndX]) and (m_nCurrY in [nStartY..nEndY]) then begin
            Result := True;
            break;
          end;
        end;
      end;
    end;
  finally
    g_StartPointList.UnLock;
  end;
end;

function TBaseObject.InSafeZone(Envir: TEnvirnoment; nX,
  nY: Integer): Boolean;
var
  i, nSafePoint, nSafeX, nSafeY: Integer;
  sMapName: string;
  StartPoint: pTStartPoint;
begin
  Result := Envir.m_boSAFE;
  if Result then Exit;
  if (Envir.sMapName <> g_Config.sRedHomeMap) or
    (abs(nX - g_Config.nRedHomeX) > g_Config.nSafeZoneSize) or
    (abs(nY - g_Config.nRedHomeY) > g_Config.nSafeZoneSize) then begin
    Result := False;
  end else begin
    Result := True;
  end;
  if Result then Exit;
  try
    g_StartPointList.Lock;
    for i := 0 to g_StartPointList.Count - 1 do begin
      sMapName := g_StartPointList.Strings[i];
      if (sMapName = Envir.sMapName) then begin
        StartPoint := pTStartPoint(g_StartPointList.Objects[i]);
        if StartPoint <> nil then begin
          nSafeX := StartPoint.m_nCurrX;
          nSafeY := StartPoint.m_nCurrY;
          if (abs(nX - nSafeX) <= g_Config.nSafeZoneSize) and
            (abs(nY - nSafeY) <= g_Config.nSafeZoneSize) then begin
            Result := True;
            break;
          end;
        end;
      end;
    end;
  finally
    g_StartPointList.UnLock;
  end;
end; }

procedure TBaseObject.OpenHolySeizeMode(dwInterval: LongWord);
begin
  m_boHolySeize := True;
  m_dwHolySeizeTick := GetTickCount();
  m_dwHolySeizeInterval := dwInterval;
  RefNameColor();
end;

procedure TBaseObject.BreakHolySeizeMode;
begin
  m_boHolySeize := False;
  RefNameColor();
end;

procedure TBaseObject.OpenCrazyMode(nTime: Integer);
begin
  m_boCrazyMode := True;
  m_dwCrazyModeTick := GetTickCount();
  m_dwCrazyModeInterval := nTime * 1000;
  RefNameColor();
end;

procedure TBaseObject.BreakCrazyMode;
begin
  if m_boCrazyMode then begin
    m_boCrazyMode := False;
    RefNameColor();
  end;
end;

procedure TBaseObject.LeaveGroup;
resourcestring
  sExitGropMsg = '%s 已经退出了本组....';
begin
  SendGroupText(format(sExitGropMsg, [m_sCharName]));
  m_GroupOwner := nil;
  SendMsg(Self, RM_GROUPCANCEL, 0, 0, 0, 0, '');
end;

function TPlayObject.CancelGroup: Boolean;
resourcestring
  sCanceGrop = '你的小组被解散了...';
begin
  Result := True;
  if m_GroupMembers.Count <= 1 then begin
    SendGroupText(sCanceGrop);
    m_GroupMembers.Clear;
    m_GroupOwner := nil;
    Result := False;
  end;
end;

procedure TPlayObject.SendGroupMembers;
var
  i: Integer;
  PlayObject: TPlayObject;
  sSENDMSG: string;
begin
  sSENDMSG := '';
  for i := 0 to m_GroupMembers.Count - 1 do begin
    PlayObject := TPlayObject(m_GroupMembers.Objects[i]);
    if PlayObject <> nil then
      sSENDMSG := sSENDMSG + PlayObject.m_sCharName + '/';
  end;
  for i := 0 to m_GroupMembers.Count - 1 do begin
    PlayObject := TPlayObject(m_GroupMembers.Objects[i]);
    if PlayObject <> nil then
      PlayObject.SendDefMessage(SM_GROUPMEMBERS, 0, 0, 0, 0, sSENDMSG);
  end;
end;

function TPlayObject.GetMagicInfo(nMagicID: Integer): pTUserMagic;
var
  i: Integer;
  UserMagic: pTUserMagic;
begin
  Result := nil;
  for i := 0 to m_MagicList.Count - 1 do begin
    UserMagic := m_MagicList.Items[i];
    if UserMagic = nil then Continue;
    if UserMagic.MagicInfo.wMagicId = nMagicID then begin
      Result := UserMagic;
      break;
    end;
  end;
end;

function TPlayObject.GetMagicInfo(sMagicName: string): pTUserMagic;
var
  i: Integer;
  UserMagic: pTUserMagic;
begin
  Result := nil;
  for i := 0 to m_MagicList.Count - 1 do begin
    UserMagic := m_MagicList.Items[i];
    if UserMagic = nil then Continue;
    if CompareText(UserMagic.MagicInfo.sMagicName, sMagicName) = 0 then begin
      Result := UserMagic;
      break;
    end;
  end;
end;

function TPlayObject.GetSpellPoint(UserMagic: pTUserMagic): Integer;
begin
  Result := ROUND(UserMagic.MagicInfo.wSpell / (UserMagic.MagicInfo.btTrainLv + 1) * (UserMagic.btLevel + 1)) + UserMagic.MagicInfo.btDefSpell;
end;

function TPlayObject.DoMotaebo(nDir: Byte; nMagicLevel: Integer): Boolean;
  function CanMotaebo(BaseObject: TBaseObject): Boolean;
  var
    nC: Integer;
  begin
    Result := False;
    if (m_Abil.Level > BaseObject.m_Abil.Level) and (not BaseObject.m_boStickMode) then begin
      nC := m_Abil.Level - BaseObject.m_Abil.Level;
      if Random(20) < ((nMagicLevel * 4) + 6 + nC) then begin
        if IsProperTarget(BaseObject) then Result := True;
      end;
    end;
  end;
var
  bo35: Boolean;
  i, n20, n24, n28: Integer;
  PoseCreate: TBaseObject;
  BaseObject_30: TBaseObject;
  BaseObject_34: TBaseObject;
  nX, nY: Integer;
begin
  Result := False;
  bo35 := True;
  m_btDirection := nDir;
  BaseObject_34 := nil;
  n24 := nMagicLevel + 1;
  n28 := n24;
  PoseCreate := GetPoseCreate();
  if PoseCreate <> nil then begin
    for i := 0 to _MAX(2, nMagicLevel + 1) do begin
      PoseCreate := GetPoseCreate();
      if PoseCreate <> nil then begin
        n28 := 0;
        if not CanMotaebo(PoseCreate) then break;
        if nMagicLevel >= 3 then begin
          if m_PEnvir.GetNextPosition(m_nCurrX, m_nCurrY, m_btDirection, 2, nX, nY) then begin
            BaseObject_30 := m_PEnvir.GetMovingObject(nX, nY, True);
            if (BaseObject_30 <> nil) and CanMotaebo(BaseObject_30) then
              BaseObject_30.CharPushed(m_btDirection, 1);
          end;
        end;
        BaseObject_34 := PoseCreate;
        if PoseCreate.CharPushed(m_btDirection, 1) <> 1 then break;
        GetFrontPosition(nX, nY);
        if m_PEnvir.MoveToMovingObject(m_nCurrX, m_nCurrY, Self, nX, nY, False) > 0 then begin
          m_nCurrX := nX;
          m_nCurrY := nY;
          SendRefMsg(RM_RUSH, nDir, m_nCurrX, m_nCurrY, 0, '');
          bo35 := False;
          Result := True;
        end;
        Dec(n24);
      end; //004C32D7  if PoseCreate <> nil  then begin
    end; //004C32DD for i:=0 to _MAX(2,nMagicLevel + 1) do begin
  end else begin //004C32E8 if PoseCreate <> nil  then begin
    bo35 := False;
    for i := 0 to _MAX(2, nMagicLevel + 1) do begin
      GetFrontPosition(nX, nY); //sub_004B2790
      if m_PEnvir.MoveToMovingObject(m_nCurrX, m_nCurrY, Self, nX, nY, False) > 0 then begin
        m_nCurrX := nX;
        m_nCurrY := nY;
        SendRefMsg(RM_RUSH, nDir, m_nCurrX, m_nCurrY, 0, '');
        Dec(n28);
      end else begin
        if m_PEnvir.CanWalk(nX, nY, True) then n28 := 0
        else begin
          bo35 := True;
          break;
        end;
      end;
    end;
  end;
  if (BaseObject_34 <> nil) then begin
    if n24 < 0 then n24 := 0;
    n20 := Random((n24 + 1) * 10) + ((n24 + 1) * 10);
    n20 := BaseObject_34.GetHitStruckDamage(Self, n20);
    BaseObject_34.StruckDamage(n20);
    BaseObject_34.SendRefMsg(RM_STRUCK, n20, BaseObject_34.m_WAbil.HP, BaseObject_34.m_WAbil.MaxHP, Integer(Self), '');
    if BaseObject_34.m_btRaceServer <> RC_PLAYOBJECT then begin
      BaseObject_34.SendMsg(BaseObject_34, RM_STRUCK, n20, BaseObject_34.m_WAbil.HP, BaseObject_34.m_WAbil.MaxHP, Integer(Self), '');
    end;
  end;
  if bo35 then begin
    GetFrontPosition(nX, nY);
    SendRefMsg(RM_RUSHKUNG, m_btDirection, nX, nY, 0, '');
    SysMsg(sMateDoTooweak {冲撞力不够！！！}, c_Red, t_Hint);
  end;
  if n28 > 0 then begin
    if n24 < 0 then n24 := 0;
    n20 := Random(n24 * 10) + ((n24 + 1) * 3);
    n20 := GetHitStruckDamage(Self, n20);
    StruckDamage(n20);
    SendRefMsg(RM_STRUCK, n20, m_WAbil.HP, m_WAbil.MaxHP, 0, '');
  end;
end;

procedure TBaseObject.TrainSkill(UserMagic: pTUserMagic;
  nTranPoint: Integer);
begin
  if m_boFastTrain then
    nTranPoint := nTranPoint * 3;
  Inc(UserMagic.nTranPoint, nTranPoint);
end;

function TBaseObject.CheckMagicLevelup(UserMagic: pTUserMagic): Boolean; //004C7054
var
  n10: Integer;
begin
  Result := False;
  if (UserMagic.btLevel < 4) and (UserMagic.MagicInfo.btTrainLv >= UserMagic.btLevel) then
    n10 := UserMagic.btLevel
  else n10 := 0;

  if (UserMagic.MagicInfo.btTrainLv > UserMagic.btLevel) and
    (UserMagic.MagicInfo.MaxTrain[n10] <= UserMagic.nTranPoint) then begin

    if (UserMagic.MagicInfo.btTrainLv > UserMagic.btLevel) then begin
      Dec(UserMagic.nTranPoint, UserMagic.MagicInfo.MaxTrain[n10]);
      Inc(UserMagic.btLevel);
      SendUpdateDelayMsg(Self, RM_MAGIC_LVEXP, 0, UserMagic.MagicInfo.wMagicId, UserMagic.btLevel, UserMagic.nTranPoint, '', 800);
      sub_4C713C(UserMagic);
    end else begin
      UserMagic.nTranPoint := UserMagic.MagicInfo.MaxTrain[n10];
    end;
    Result := True;
  end;
end;

function TPlayObject.DoSpell(UserMagic: pTUserMagic; nTargetX,
  nTargetY: Integer; BaseObject: TBaseObject): Boolean;
var
  nSpellPoint: Integer;
begin
  Result := False;
  try
    if not MagicManager.IsWarrSkill(UserMagic.wMagIdx) then begin
      nSpellPoint := GetSpellPoint(UserMagic);
      if nSpellPoint > 0 then begin
        if m_WAbil.MP < nSpellPoint then Exit;
        DamageSpell(nSpellPoint);
        HealthSpellChanged();
      end;
      Result := MagicManager.DoSpell(Self, UserMagic, nTargetX, nTargetY, BaseObject);
    end;
  except
    on E: Exception do begin
      MainOutMessage(format('[Exception] TPlayObject.DoSpell MagID:%d X:%d Y:%d', [UserMagic.wMagIdx, nTargetX, nTargetY]));
      MainOutMessage(E.Message);
    end;
  end;
end;

function TPlayObject.PileStones(nX, nY: Integer): Boolean;
var
  Event: TEvent;
  PileEvent: TEvent;
  s1C: string;
begin
  Result := False;
  s1C := '';
  Event := TEvent(m_PEnvir.GetEvent(nX, nY));
  if (Event <> nil) and (Event.m_nEventType = ET_STONEMINE) then begin
    if TStoneMineEvent(Event).m_nMineCount > 0 then begin
      Dec(TStoneMineEvent(Event).m_nMineCount);
      if Random(g_Config.nMakeMineHitRate {4}) = 0 then begin
        PileEvent := TEvent(m_PEnvir.GetEvent(m_nCurrX, m_nCurrY));
        if PileEvent = nil then begin
          PileEvent := TPileStones.Create(m_PEnvir, m_nCurrX, m_nCurrY, ET_PILESTONES, 5 * 60 * 1000);
          g_EventManager.AddEvent(PileEvent);
        end else begin
          if PileEvent.m_nEventType = ET_PILESTONES then
            TPileStones(PileEvent).AddEventParam;
        end;
        if Random(g_Config.nMakeMineRate {12}) = 0 then begin
          MakeMine();
        end;
        s1C := '1';
        DoDamageWeapon(Random(15) + 5);
        Result := True;
      end;
    end else begin
      if (GetTickCount - TStoneMineEvent(Event).m_dwAddStoneMineTick) > 10 * 60 * 1000 then
        TStoneMineEvent(Event).AddStoneMine();
    end;
  end;
  SendRefMsg(RM_HEAVYHIT, m_btDirection, m_nCurrX, m_nCurrY, 0, s1C);
end;

procedure TBaseObject.SetTargetCreat(BaseObject: TBaseObject);
begin
  m_TargetCret := BaseObject;
  m_dwTargetFocusTick := GetTickCount();
end;

procedure TBaseObject.DelTargetCreat();
begin
  m_TargetCret := nil;
end;

function TBaseObject._Attack(var wHitMode: Word; AttackTarget: TBaseObject): Boolean;
//攻击角色
  function DirectAttack(BaseObject: TBaseObject; nSecPwr: Integer): Boolean;
  begin
    Result := False;
    if (m_btRaceServer = RC_PLAYOBJECT) or
      (BaseObject.m_btRaceServer = RC_PLAYOBJECT) or
      not (InSafeZone and BaseObject.InSafeZone) then begin
      if IsProperTarget(BaseObject) then begin
        if Random(BaseObject.m_btSpeedPoint) < m_btHitPoint then begin
          BaseObject.StruckDamage(nSecPwr);
          BaseObject.SendDelayMsg(TBaseObject(RM_STRUCK),
            RM_10101,
            nSecPwr,
            BaseObject.m_WAbil.HP,
            BaseObject.m_WAbil.MaxHP,
            Integer(Self),
            '', 500);
          if BaseObject.m_btRaceServer <> RC_PLAYOBJECT then begin
            BaseObject.SendMsg(BaseObject,
              RM_STRUCK,
              nSecPwr,
              BaseObject.m_WAbil.HP,
              BaseObject.m_WAbil.MaxHP,
              Integer(Self),
              '');
          end;
          Result := True;
        end;
      end;
    end;
  end;
  //刺杀前面一个位置的攻击
  function SwordLongAttack(nSecPwr: Integer): Boolean;
  var
    nX, nY: Integer;
    BaseObject: TBaseObject;
  begin
    Result := False;
    //Result:=g_boNotLimitSwordLong;
    nSecPwr := ROUND(nSecPwr * g_Config.nSwordLongPowerRate / 100);
    if m_PEnvir.GetNextPosition(m_nCurrX, m_nCurrY, m_btDirection, 2, nX, nY) then begin
      BaseObject := m_PEnvir.GetMovingObject(nX, nY, True);
      if BaseObject <> nil then begin
        if (nSecPwr > 0) and IsProperTarget(BaseObject) then begin
          Result := DirectAttack(BaseObject, nSecPwr);
          SetTargetCreat(BaseObject);
        end;
        Result := True;
      end;
    end;
  end;
  //半月攻击
  function SwordWideAttack(nSecPwr: Integer): Boolean;
  var
    nC, n10: Integer;
    nX, nY: Integer;
    BaseObject: TBaseObject;
  begin
    Result := False;
    nC := 0;
    while (True) do begin
      n10 := (m_btDirection + g_Config.WideAttack[nC]) mod 8;
      if m_PEnvir.GetNextPosition(m_nCurrX, m_nCurrY, n10, 1, nX, nY) then begin
        BaseObject := m_PEnvir.GetMovingObject(nX, nY, True);
        if (nSecPwr > 0) and (BaseObject <> nil) and IsProperTarget(BaseObject) then begin
          Result := DirectAttack(BaseObject, nSecPwr);
          SetTargetCreat(BaseObject);
        end;
      end;
      Inc(nC);
      if nC >= 3 then break;
    end;
  end;
  //抱月弯刀
  function CrsWideAttack(nSecPwr: Integer): Boolean;
  var
    nC, n10: Integer;
    nX, nY: Integer;
    BaseObject: TBaseObject;
  begin
    Result := False;
    nC := 0;
    while (True) do begin
      n10 := (m_btDirection + g_Config.CrsAttack[nC]) mod 8;
      if m_PEnvir.GetNextPosition(m_nCurrX, m_nCurrY, n10, 1, nX, nY) then begin
        BaseObject := m_PEnvir.GetMovingObject(nX, nY, True);
        if (nSecPwr > 0) and (BaseObject <> nil) and IsProperTarget(BaseObject) then begin
          Result := DirectAttack(BaseObject, nSecPwr);
          SetTargetCreat(BaseObject);
        end;
      end;
      Inc(nC);
      if nC >= 7 then break;
    end;
  end;

  procedure sub_4C1E5C(nSecPwr: Integer);
  var
    btDir: Byte;
    nX, nY: Integer;
    BaseObject: TBaseObject;
    procedure sub_4C1DC0();
    begin
      if m_PEnvir.GetNextPosition(m_nCurrX, m_nCurrY, btDir, 1, nX, nY) then begin
        BaseObject := m_PEnvir.GetMovingObject(nX, nY, True);
        if (nSecPwr > 0) and (BaseObject <> nil) then begin
          Result := DirectAttack(BaseObject, nSecPwr);
        end;
      end;
    end;
  begin
    Result := False;
    btDir := m_btDirection;
    m_PEnvir.GetNextPosition(m_nCurrX, m_nCurrY, btDir, 1, nX, nY);
    sub_4C1DC0();
    btDir := sub_4B2F80(m_btDirection, 2);
    sub_4C1DC0();
    btDir := sub_4B2F80(m_btDirection, 6);
    sub_4C1DC0();
  end;
var
  nPower, nSecPwr, nWeaponDamage: Integer;
  bo21: Boolean;
  n20: Integer;
  nCheckCode: Integer;
resourcestring
  sExceptionMsg = '[Exception] TBaseObject::_Attack Name:= %s Code:=%d';
begin
  Result := False;
  nCheckCode := 0;
  try
    bo21 := False;
    nWeaponDamage := 0;
    nPower := 0;
    nSecPwr := 0;
    if AttackTarget <> nil then begin
      nPower := GetAttackPower(LoWord(m_WAbil.DC), SmallInt((HiWord(m_WAbil.DC) - LoWord(m_WAbil.DC))));
      if (wHitMode = 3) and m_boPowerHit then begin
        m_boPowerHit := False;
        Inc(nPower, m_nHitPlus);
        bo21 := True;
      end;
      if (wHitMode = 7) and m_boFireHitSkill then begin //烈火剑法
        m_boFireHitSkill := False;
        m_dwLatestFireHitTick := GetTickCount(); //Jacky 禁止双烈火
        nPower := nPower + ROUND(nPower / 100 * (m_nHitDouble * 10));
        bo21 := True;
      end;
    end else begin
      nPower := GetAttackPower(LoWord(m_WAbil.DC), SmallInt((HiWord(m_WAbil.DC) - LoWord(m_WAbil.DC))));
      if (wHitMode = 3) and m_boPowerHit then begin
        m_boPowerHit := False;
        Inc(nPower, m_nHitPlus);
        bo21 := True;
      end;
      //防止砍空刀刀烈火
      if (wHitMode = 7) and m_boFireHitSkill then begin
        m_boFireHitSkill := False;
        m_dwLatestFireHitTick := GetTickCount(); //禁止双烈火
      end;
    end;
    nCheckCode := 1;
    if (wHitMode = 4) then begin // 刺杀
      nSecPwr := 0;
      if (m_btRaceServer = RC_PLAYOBJECT) or (m_btRaceServer = RC_PLAYMOSTER) then begin {增加分身魔法攻击}
        nCheckCode := 11;
        if m_MagicErgumSkill <> nil then begin
          nCheckCode := 12;
          nSecPwr := ROUND(nPower / (m_MagicErgumSkill.MagicInfo.btTrainLv + 2) * (m_MagicErgumSkill.btLevel + 2));
          nCheckCode := 13;
        end;
      end else nSecPwr := nSecPwr;
      if nSecPwr > 0 then begin
        nCheckCode := 110;
        if not SwordLongAttack(nSecPwr) and g_Config.boLimitSwordLong then wHitMode := 0;
        nCheckCode := 111;
      end;
    end;
    nCheckCode := 2;
    if (wHitMode = 5) then begin
      nSecPwr := 0;
      if (m_btRaceServer = RC_PLAYOBJECT) or (m_btRaceServer = RC_PLAYMOSTER) then begin {增加分身魔法攻击}
        if m_MagicBanwolSkill <> nil then begin
          nSecPwr := ROUND(nPower / (m_MagicBanwolSkill.MagicInfo.btTrainLv + 10) * (m_MagicBanwolSkill.btLevel + 2));
        end;
      end else nSecPwr := nSecPwr;
      if nSecPwr > 0 then SwordWideAttack(nSecPwr);
    end;
    nCheckCode := 3;
    if (wHitMode = 6) then begin
      nSecPwr := 0;
      if (m_btRaceServer = RC_PLAYOBJECT) or (m_btRaceServer = RC_PLAYMOSTER) then begin {增加分身魔法攻击}
      end else nSecPwr := nSecPwr;
      if nSecPwr > 0 then sub_4C1E5C(nSecPwr);
    end;
    if (wHitMode = 8) then begin
      nSecPwr := 0;
      if (m_btRaceServer = RC_PLAYOBJECT) or (m_btRaceServer = RC_PLAYMOSTER) then begin {增加分身魔法攻击}
        if m_MagicCrsSkill <> nil then begin
          nSecPwr := ROUND(nPower / (m_MagicCrsSkill.MagicInfo.btTrainLv + 10) * (m_MagicCrsSkill.btLevel + 2));
        end;
      end else nSecPwr := nSecPwr;
      if nSecPwr > 0 then CrsWideAttack(nSecPwr);
    end;

    if AttackTarget = nil then begin
      Exit;
    end;
    nCheckCode := 4;
    if IsProperTarget(AttackTarget) then begin
      nCheckCode := 41;
      if (Random(AttackTarget.m_btSpeedPoint) >= m_btHitPoint) then begin
        nCheckCode := 42;
        nPower := 0;
      end;
      nCheckCode := 43;
    end else nPower := 0;
    nCheckCode := 5;
    if nPower > 0 then begin
      nPower := AttackTarget.GetHitStruckDamage(Self, nPower);
      nWeaponDamage := (Random(5) + 2) - m_AddAbil.btWeaponStrong;
    end;
    nCheckCode := 600;
    if nPower > 0 then begin
      nCheckCode := 601;
      AttackTarget.StruckDamage(nPower);
      nCheckCode := 602;
      AttackTarget.SendDelayMsg(TBaseObject(RM_STRUCK), RM_10101, nPower, AttackTarget.m_WAbil.HP, AttackTarget.m_WAbil.MaxHP, Integer(Self), '', 200);
      nCheckCode := 603;
      if not AttackTarget.m_boUnParalysis and m_boParalysis and (Random(AttackTarget.m_btAntiPoison + g_Config.nAttackPosionRate {5}) = 0) then begin
        nCheckCode := 604;
        AttackTarget.MakePosion(POISON_STONE, g_Config.nAttackPosionTime {5}, 0);
      end;
      nCheckCode := 605;
      //虹魔，吸血
      if m_nHongMoSuite > 0 then begin
        m_db3B0 := nPower / 1.E2 * m_nHongMoSuite;
        if m_db3B0 >= 2.0 then begin
          n20 := Trunc(m_db3B0);
          m_db3B0 := n20;
          DamageHealth(-n20);
        end;
      end;
      nCheckCode := 606;
      if (m_MagicOneSwordSkill <> nil) and
        (m_btRaceServer = RC_PLAYOBJECT) and
        (m_MagicOneSwordSkill.btLevel < 3) and
        (m_MagicOneSwordSkill.MagicInfo.TrainLevel[m_MagicOneSwordSkill.btLevel] <= m_Abil.Level) then begin
        nCheckCode := 607;
        TPlayObject(Self).TrainSkill(m_MagicOneSwordSkill, Random(3) + 1);
        nCheckCode := 608;
        if not TPlayObject(Self).CheckMagicLevelup(m_MagicOneSwordSkill) then begin
          nCheckCode := 609;
          SendDelayMsg(Self, RM_MAGIC_LVEXP, 0, m_MagicOneSwordSkill.MagicInfo.wMagicId, m_MagicOneSwordSkill.btLevel, m_MagicOneSwordSkill.nTranPoint, '', 3000);
        end;
        nCheckCode := 610;
      end;

      if bo21 and (m_MagicPowerHitSkill <> nil) and
        (m_btRaceServer = RC_PLAYOBJECT) and
        (m_MagicPowerHitSkill.btLevel < 3) and
        (m_MagicPowerHitSkill.MagicInfo.TrainLevel[m_MagicPowerHitSkill.btLevel] <= m_Abil.Level) then begin
        nCheckCode := 611;
        TPlayObject(Self).TrainSkill(m_MagicPowerHitSkill, Random(3) + 1);
        nCheckCode := 612;
        if not TPlayObject(Self).CheckMagicLevelup(m_MagicPowerHitSkill) then begin
          nCheckCode := 613;
          SendDelayMsg(Self, RM_MAGIC_LVEXP, 0, m_MagicPowerHitSkill.MagicInfo.wMagicId, m_MagicPowerHitSkill.btLevel, m_MagicPowerHitSkill.nTranPoint, '', 3000);
        end;
        nCheckCode := 614;
      end;
      nCheckCode := 6;
      if (wHitMode = 4) and (m_MagicErgumSkill <> nil) and
        (m_btRaceServer = RC_PLAYOBJECT) and
        (m_MagicErgumSkill.btLevel < 3) and
        (m_MagicErgumSkill.MagicInfo.TrainLevel[m_MagicErgumSkill.btLevel] <= m_Abil.Level) then begin
        nCheckCode := 61;
        TPlayObject(Self).TrainSkill(m_MagicErgumSkill, 1);
        nCheckCode := 62;
        if not TPlayObject(Self).CheckMagicLevelup(m_MagicErgumSkill) then begin
          nCheckCode := 63;
          SendDelayMsg(Self, RM_MAGIC_LVEXP, 0, m_MagicErgumSkill.MagicInfo.wMagicId, m_MagicErgumSkill.btLevel, m_MagicErgumSkill.nTranPoint, '', 3000);
        end;
      end;
      nCheckCode := 7;
      if (wHitMode = 5) and (m_MagicBanwolSkill <> nil) and
        (m_btRaceServer = RC_PLAYOBJECT) and
        (m_MagicBanwolSkill.btLevel < 3) and
        (m_MagicBanwolSkill.MagicInfo.TrainLevel[m_MagicBanwolSkill.btLevel] <= m_Abil.Level) then begin

        TPlayObject(Self).TrainSkill(m_MagicBanwolSkill, 1);
        if not TPlayObject(Self).CheckMagicLevelup(m_MagicBanwolSkill) then begin
          SendDelayMsg(Self, RM_MAGIC_LVEXP, 0, m_MagicBanwolSkill.MagicInfo.wMagicId, m_MagicBanwolSkill.btLevel, m_MagicBanwolSkill.nTranPoint, '', 3000);
        end;
      end;
      nCheckCode := 8;
      if (wHitMode = 7) and (m_MagicFireSwordSkill <> nil) and
        (m_btRaceServer = RC_PLAYOBJECT) and
        (m_MagicFireSwordSkill.btLevel < 3) and
        (m_MagicFireSwordSkill.MagicInfo.TrainLevel[m_MagicFireSwordSkill.btLevel] <= m_Abil.Level) then begin

        TPlayObject(Self).TrainSkill(m_MagicFireSwordSkill, 1);
        if not TPlayObject(Self).CheckMagicLevelup(m_MagicFireSwordSkill) then begin
          SendDelayMsg(Self, RM_MAGIC_LVEXP, 0, m_MagicFireSwordSkill.MagicInfo.wMagicId, m_MagicFireSwordSkill.btLevel, m_MagicFireSwordSkill.nTranPoint, '', 3000);
        end;
      end;
      Result := True;
    end;
    nCheckCode := 9;
    if (nWeaponDamage > 0) and (m_UseItems[U_WEAPON].wIndex > 0) then
      DoDamageWeapon(nWeaponDamage);

    if (AttackTarget <> nil) and (AttackTarget.m_btRaceServer <> RC_PLAYOBJECT) then
      AttackTarget.SendMsg(AttackTarget, RM_STRUCK, nPower, AttackTarget.m_WAbil.HP, AttackTarget.m_WAbil.MaxHP, Integer(Self), '');
  except
    on E: Exception do begin
      MainOutMessage(format(sExceptionMsg, [m_sCharName, nCheckCode]));
      MainOutMessage(E.Message)
    end;
  end;
end;

procedure TBaseObject.SendAttackMsg(wIdent: Word; btDir: Byte; nX, nY: Integer);
begin
  SendRefMsg(wIdent, btDir, nX, nY, 0, '');
end;

function TBaseObject.GetHitStruckDamage(Target: TBaseObject; nDamage: Integer): Integer;
var
  n14: Integer;
begin
  n14 := LoWord(m_WAbil.AC) + Random(SmallInt(HiWord(m_WAbil.AC) - LoWord(m_WAbil.AC)) + 1);
  nDamage := _MAX(0, nDamage - n14);
  if (m_btLifeAttrib = LA_UNDEAD) and (Target <> nil) then begin
    Inc(nDamage, Target.m_AddAbil.bt1DF);
  end;
  if (nDamage > 0) and m_boAbilMagBubbleDefence then begin
    nDamage := ROUND((nDamage / 1.0E2) * (m_btMagBubbleDefenceLevel + 2) * 8.0);
    DamageBubbleDefence(nDamage);
  end;
  Result := nDamage;
end;

function TBaseObject.GetMagStruckDamage(BaseObject: TBaseObject; nDamage: Integer): Integer;
var
  n14: Integer;
begin
  n14 := LoWord(m_WAbil.MAC) + Random(SmallInt(HiWord(m_WAbil.MAC) - LoWord(m_WAbil.MAC)) + 1);
  nDamage := _MAX(0, nDamage - n14);
  if (m_btLifeAttrib = LA_UNDEAD) and (BaseObject <> nil) then begin
    Inc(nDamage, m_AddAbil.bt1DF);
  end;
  if (nDamage > 0) and m_boAbilMagBubbleDefence then begin
    nDamage := ROUND((nDamage / 1.0E2) * (m_btMagBubbleDefenceLevel + 2) * 8.0);
    DamageBubbleDefence(nDamage);
  end;
  Result := nDamage;
end;

procedure TBaseObject.StruckDamage(nDamage: Integer);
var
  i: Integer;
  nDam: Integer;
  nDura, nOldDura: Integer;
  PlayObject: TPlayObject;
  StdItem: pTStdItem;
  bo19: Boolean;
begin
  if nDamage <= 0 then Exit;
  nDam := Random(10) + 5;
  if m_wStatusTimeArr[POISON_DAMAGEARMOR {1 0x62}] > 0 then begin
    nDam := ROUND(nDam * (g_Config.nPosionDamagarmor / 10) {1.2});
    nDamage := ROUND(nDamage * (g_Config.nPosionDamagarmor / 10) {1.2});
  end;
  bo19 := False;
  if m_UseItems[U_DRESS].wIndex > 0 then begin
    nDura := m_UseItems[U_DRESS].Dura;
    nOldDura := ROUND(nDura / 1000);
    Dec(nDura, nDam);
    if nDura <= 0 then begin
      if m_btRaceServer = RC_PLAYOBJECT then begin
        PlayObject := TPlayObject(Self);
        PlayObject.SendDelItems(@m_UseItems[U_DRESS]);
        StdItem := UserEngine.GetStdItem(m_UseItems[U_DRESS].wIndex);
        if StdItem.NeedIdentify = 1 then
          AddGameDataLog('3' + #9 +
            m_sMapName + #9 +
            IntToStr(m_nCurrX) + #9 +
            IntToStr(m_nCurrY) + #9 +
            m_sCharName + #9 +
            //UserEngine.GetStdItemName(m_UseItems[U_DRESS].wIndex) + #9 +
            StdItem.Name + #9 +
            IntToStr(m_UseItems[U_DRESS].MakeIndex) + #9 +
            BoolToIntStr(m_btRaceServer = RC_PLAYOBJECT) + #9 +
            '0');
        m_UseItems[U_DRESS].wIndex := 0;
        FeatureChanged();
      end;
      m_UseItems[U_DRESS].wIndex := 0;
      m_UseItems[U_DRESS].Dura := 0;
      bo19 := True;
    end else begin
      m_UseItems[U_DRESS].Dura := nDura;
    end;
    if nOldDura <> ROUND(nDura / 1000) then begin
      SendMsg(Self, RM_DURACHANGE, U_DRESS, nDura, m_UseItems[U_DRESS].DuraMax, 0, '');
    end;
  end;
  for i := Low(THumanUseItems) to High(THumanUseItems) do begin
    if (m_UseItems[i].wIndex > 0) and (Random(8) = 0) then begin
      nDura := m_UseItems[i].Dura;
      nOldDura := ROUND(nDura / 1000);
      Dec(nDura, nDam);
      if nDura <= 0 then begin
        if m_btRaceServer = RC_PLAYOBJECT then begin
          PlayObject := TPlayObject(Self);
          PlayObject.SendDelItems(@m_UseItems[i]);
          StdItem := UserEngine.GetStdItem(m_UseItems[i].wIndex);
          if StdItem.NeedIdentify = 1 then
            AddGameDataLog('3' + #9 +
              m_sMapName + #9 +
              IntToStr(m_nCurrX) + #9 +
              IntToStr(m_nCurrY) + #9 +
              m_sCharName + #9 +
              //UserEngine.GetStdItemName(m_UseItems[i].wIndex) + #9 +
              StdItem.Name + #9 +
              IntToStr(m_UseItems[i].MakeIndex) + #9 +
              BoolToIntStr(m_btRaceServer = RC_PLAYOBJECT) + #9 +
              '0');
          m_UseItems[i].wIndex := 0;
          FeatureChanged();
        end;
        m_UseItems[i].wIndex := 0;
        m_UseItems[i].Dura := 0;
        bo19 := True;
      end else begin
        m_UseItems[i].Dura := nDura;
      end;
      if nOldDura <> ROUND(nDura / 1000) then begin
        SendMsg(Self, RM_DURACHANGE, i, nDura, m_UseItems[i].DuraMax, 0, '');
      end;
    end;
  end;
  if bo19 then RecalcAbilitys();
  DamageHealth(nDamage);
end;

function TBaseObject.GeTBaseObjectInfo(): string;
begin
  Result := m_sCharName + ' ' +
    '地图:' + m_sMapName + '(' + m_PEnvir.sMapDesc + ') ' +
    '座标:' + IntToStr(m_nCurrX) + '/' + IntToStr(m_nCurrY) + ' ' +
    '等级:' + IntToStr(m_Abil.Level) + ' ' +
    '经验:' + IntToStr(m_Abil.Exp) + ' ' +
    '生命值: ' + IntToStr(m_WAbil.HP) + '-' + IntToStr(m_WAbil.MaxHP) + ' ' +
    '魔法值: ' + IntToStr(m_WAbil.MP) + '-' + IntToStr(m_WAbil.MaxMP) + ' ' +
    '攻击力: ' + IntToStr(LoWord(m_WAbil.DC)) + '-' + IntToStr(HiWord(m_WAbil.DC)) + ' ' +
    '魔法力: ' + IntToStr(LoWord(m_WAbil.MC)) + '-' + IntToStr(HiWord(m_WAbil.MC)) + ' ' +
    '道术: ' + IntToStr(LoWord(m_WAbil.SC)) + '-' + IntToStr(HiWord(m_WAbil.SC)) + ' ' +
    '防御力: ' + IntToStr(LoWord(m_WAbil.AC)) + '-' + IntToStr(HiWord(m_WAbil.AC)) + ' ' +
    '魔防力: ' + IntToStr(LoWord(m_WAbil.MAC)) + '-' + IntToStr(HiWord(m_WAbil.MAC)) + ' ' +
    '准确:' + IntToStr(m_btHitPoint) + ' ' +
    '敏捷:' + IntToStr(m_btSpeedPoint);
end;

function TBaseObject.GetBackPosition(var nX, nY: Integer): Boolean;
var
  Envir: TEnvirnoment;
begin
  Envir := m_PEnvir;
  nX := m_nCurrX;
  nY := m_nCurrY;
  case m_btDirection of
    DR_UP: if nY < (Envir.m_nHeight - 1) then Inc(nY);
    DR_DOWN: if nY > 0 then Dec(nY);
    DR_LEFT: if nX < (Envir.m_nWidth - 1) then Inc(nX);
    DR_RIGHT: if nX > 0 then Dec(nX);
    DR_UPLEFT: begin
        if (nX < (Envir.m_nWidth - 1)) and (nY < (Envir.m_nHeight - 1)) then begin
          Inc(nX);
          Inc(nY);
        end;
      end;
    DR_UPRIGHT: begin
        if (nX < (Envir.m_nWidth - 1)) and (nY > 0) then begin
          Dec(nX);
          Inc(nY);
        end
      end;
    DR_DOWNLEFT: begin
        if (nX > 0) and (nY < (Envir.m_nHeight - 1)) then begin
          Inc(nX);
          Dec(nY);
        end;
      end;
    DR_DOWNRIGHT: begin
        if (nX > 0) and (nY > 0) then begin
          Dec(nX);
          Dec(nY);
        end;
      end;
  end;
  Result := True;
end;

procedure TAnimalObject.HitMagAttackTarget(TargeTBaseObject: TBaseObject; nHitPower,
  nMagPower: Integer; boFlag: Boolean);
var
  i: Integer;
  nDamage: Integer;
  BaseObjectList: TList;
  BaseObject: TBaseObject;
begin
  m_btDirection := GetNextDirection(m_nCurrX, m_nCurrY, TargeTBaseObject.m_nCurrX, TargeTBaseObject.m_nCurrY);
  BaseObjectList := TList.Create;
  m_PEnvir.GeTBaseObjects(TargeTBaseObject.m_nCurrX, TargeTBaseObject.m_nCurrY, False, BaseObjectList);
  for i := 0 to BaseObjectList.Count - 1 do begin
    BaseObject := TBaseObject(BaseObjectList.Items[i]);
    if BaseObject = nil then Continue;
    if IsProperTarget(BaseObject) then begin
      nDamage := 0;
      Inc(nDamage, BaseObject.GetHitStruckDamage(Self, nHitPower));
      Inc(nDamage, BaseObject.GetMagStruckDamage(Self, nMagPower));
      if nDamage > 0 then begin
        BaseObject.StruckDamage(nDamage);
        BaseObject.SendDelayMsg(TBaseObject(RM_STRUCK), RM_10101, nDamage, BaseObject.m_WAbil.HP, BaseObject.m_WAbil.MaxHP, Integer(Self), '', 200);
      end;
    end;
  end;
  BaseObjectList.Free;
  SendRefMsg(RM_HIT, m_btDirection, m_nCurrX, m_nCurrY, 0, '');
end;

procedure TAnimalObject.DelTargetCreat;
begin
  inherited;
  m_nTargetX := -1;
  m_nTargetY := -1;
end;

procedure TAnimalObject.SearchTarget;
var
  BaseObject, BaseObject18: TBaseObject;
  i, nC, n10: Integer;
begin
  BaseObject18 := nil;
  n10 := 999;
  for i := 0 to m_VisibleActors.Count - 1 do begin
    BaseObject := TBaseObject(pTVisibleBaseObject(m_VisibleActors.Items[i]).BaseObject);
    if BaseObject <> nil then begin
      if not BaseObject.m_boDeath then begin
        if IsProperTarget(BaseObject) and
          (not BaseObject.m_boHideMode or m_boCoolEye) then begin
          nC := abs(m_nCurrX - BaseObject.m_nCurrX) + abs(m_nCurrY - BaseObject.m_nCurrY);
          if nC < n10 then begin
            n10 := nC;
            BaseObject18 := BaseObject;
          end;
        end;
      end;
    end;
  end;
  if BaseObject18 <> nil then SetTargetCreat(BaseObject18);
end;

procedure TAnimalObject.sub_4C959C;
var
  i, nC, n10: Integer;
  Creat, BaseObject: TBaseObject;
begin
  Creat := nil;
  n10 := 999;
  for i := 0 to m_VisibleActors.Count - 1 do begin
    BaseObject := TBaseObject(pTVisibleBaseObject(m_VisibleActors.Items[i]).BaseObject);
    if BaseObject <> nil then begin
      if BaseObject.m_boDeath then Continue;
      if IsProperTarget(BaseObject) then begin
        nC := abs(m_nCurrX - BaseObject.m_nCurrX) + abs(m_nCurrY - BaseObject.m_nCurrY);
        if nC < n10 then begin
          n10 := nC;
          Creat := BaseObject;
        end;
      end;
    end;
  end; // for
  if Creat <> nil then
    SetTargetCreat(Creat);
end;

procedure TAnimalObject.SetTargetXY(nX, nY: Integer);
begin
  m_nTargetX := nX;
  m_nTargetY := nY;
end;

procedure TAnimalObject.Wondering;
begin
  if (Random(20) = 0) then
    if (Random(4) = 1) then TurnTo(Random(8))
    else WalkTo(m_btDirection, False);
end;

function TBaseObject.MakePosion(nType, nTime, nPoint: Integer): Boolean;
var
  nOldCharStatus: Integer;
begin
  Result := False;
  if nType < MAX_STATUS_ATTRIBUTE then begin
    nOldCharStatus := m_nCharStatus;
    if m_wStatusTimeArr[nType] > 0 then begin
      if m_wStatusTimeArr[nType] < nTime then begin
        m_wStatusTimeArr[nType] := nTime;
      end;
    end else begin //004C35FF
      m_wStatusTimeArr[nType] := nTime;
    end;
    m_dwStatusArrTick[nType] := GetTickCount();
    m_nCharStatus := GetCharStatus();
    m_btGreenPoisoningPoint := nPoint;
    if nOldCharStatus <> m_nCharStatus then StatusChanged();
    if m_btRaceServer = RC_PLAYOBJECT then begin
{$IF DEBUG = 1}
      SysMsg(format('中毒了！！！%d秒 %d点', [nTime, nPoint]), c_Red, t_Hint);
{$ELSE}
      SysMsg(sYouPoisoned {中毒了！！！}, c_Red, t_Hint);
{$IFEND}
    end;
    Result := True;
  end;
end;

function TBaseObject.sub_4DD704: Boolean;
var
  i: Integer;
  SendMessage: pTSendMessage;
begin
  Result := False;
  EnterCriticalSection(ProcessMsgCriticalSection);
  try
    for i := 0 to m_MsgList.Count - 1 do begin
      SendMessage := m_MsgList.Items[i];
      if (SendMessage <> nil) and (SendMessage.wIdent = RM_10401) then begin
        Result := True;
        break;
      end;
    end;
  finally
    LeaveCriticalSection(ProcessMsgCriticalSection);
  end;
end;

procedure TPlayObject.SendSaveItemList(nBaseObject: Integer);
var
  i: Integer;
  Item: pTStdItem;
  sSENDMSG: string;
  ClientItem: TClientItem;
  OClientItem: TOClientItem;
  StdItem: TStdItem;
  UserItem: pTUserItem;
  sUserItemName: string;
begin
  if m_nSoftVersionDateEx = 0 then begin
    sSENDMSG := '';
    for i := 0 to m_StorageItemList.Count - 1 do begin
      UserItem := m_StorageItemList.Items[i];
      if UserItem = nil then Continue;
      Item := UserEngine.GetStdItem(UserItem.wIndex);
      if Item <> nil then begin
        StdItem := Item^;
        ItemUnit.GetItemAddValue(UserItem, StdItem);
        //Move(StdItem,ClientItem.S,SizeOf(TStdItem));
        CopyStdItemToOStdItem(@StdItem, @OClientItem.s);
        //取自定义物品名称
        sUserItemName := '';
        if UserItem.btValue[13] = 1 then
          sUserItemName := ItemUnit.GetCustomItemName(UserItem.MakeIndex, UserItem.wIndex);
        if sUserItemName <> '' then
          OClientItem.s.Name := sUserItemName;
        OClientItem.Dura := UserItem.Dura;
        OClientItem.DuraMax := UserItem.DuraMax;
        OClientItem.MakeIndex := UserItem.MakeIndex;
        sSENDMSG := sSENDMSG + EncodeBuffer(@OClientItem, SizeOf(TOClientItem)) + '/';
      end;
    end;
    m_DefMsg := MakeDefaultMsg(SM_SAVEITEMLIST, nBaseObject, 0, 0, m_StorageItemList.Count);
    SendSocket(@m_DefMsg, sSENDMSG);
  end else begin
    sSENDMSG := '';
    for i := 0 to m_StorageItemList.Count - 1 do begin
      UserItem := m_StorageItemList.Items[i];
      if UserItem = nil then Continue;
      Item := UserEngine.GetStdItem(UserItem.wIndex);
      if Item <> nil then begin
        StdItem := Item^;
        ItemUnit.GetItemAddValue(UserItem, StdItem);
        Move(StdItem, ClientItem.s, SizeOf(TStdItem));
        //取自定义物品名称
        sUserItemName := '';
        if UserItem.btValue[13] = 1 then
          sUserItemName := ItemUnit.GetCustomItemName(UserItem.MakeIndex, UserItem.wIndex);
        if sUserItemName <> '' then
          ClientItem.s.Name := sUserItemName;
        ClientItem.Dura := UserItem.Dura;
        ClientItem.DuraMax := UserItem.DuraMax;
        ClientItem.MakeIndex := UserItem.MakeIndex;
        sSENDMSG := sSENDMSG + EncodeBuffer(@ClientItem, SizeOf(TClientItem)) + '/';
      end;
    end;
    m_DefMsg := MakeDefaultMsg(SM_SAVEITEMLIST, nBaseObject, 0, 0, m_StorageItemList.Count);
    SendSocket(@m_DefMsg, sSENDMSG);
  end;
end;

procedure TPlayObject.SendSaveBigStorageItemList(nBaseObject: Integer; nPage: Integer);
var
  i: Integer;
  Item: pTStdItem;
  sSENDMSG: string;
  ClientItem: TClientItem;
  OClientItem: TOClientItem;
  StdItem: TStdItem;
  //UserItem: pTUserItem;
  sUserItemName: string;
  List: TList;
  BigStorage: pTBigStorage;
  nCount: Integer;
  nPageCount: Integer;
  nIndex: Integer;
  function GetPageCount(nListCount: Integer): Integer;
  begin
    Result := 0;
    if nListCount > 0 then begin
      Result := nListCount div 50;
      if (nListCount mod 50) > 0 then Inc(Result);
    end;
  end;
begin
  if m_nSoftVersionDateEx = 0 then begin
    sSENDMSG := '';
    nCount := 0;
    if g_BigStorageList.GetUserStorageListByChrName(m_sCharName, List) then begin
      if nPage = 0 then nIndex := 0;
      if nPage > 0 then nIndex := nPage * 50;
      if nIndex > List.Count - 1 then begin
        m_nBigStoragePage := GetPageCount(List.Count);
        Exit;
      end;
      for i := nIndex to List.Count - 1 do begin
        BigStorage := List.Items[i];
        if BigStorage = nil then Continue;
        Item := UserEngine.GetStdItem(BigStorage.UseItems.wIndex);
        if Item <> nil then begin
          Inc(nCount);
          StdItem := Item^;
          ItemUnit.GetItemAddValue(@BigStorage.UseItems, StdItem);
          //Move(StdItem,ClientItem.S,SizeOf(TStdItem));
          CopyStdItemToOStdItem(@StdItem, @OClientItem.s);
          //取自定义物品名称
          sUserItemName := '';
          if BigStorage.UseItems.btValue[13] = 1 then
            sUserItemName := ItemUnit.GetCustomItemName(BigStorage.UseItems.MakeIndex, BigStorage.UseItems.wIndex);
          if sUserItemName <> '' then
            OClientItem.s.Name := sUserItemName;
          OClientItem.Dura := BigStorage.UseItems.Dura;
          OClientItem.DuraMax := BigStorage.UseItems.DuraMax;
          OClientItem.MakeIndex := BigStorage.UseItems.MakeIndex;
          sSENDMSG := sSENDMSG + EncodeBuffer(@OClientItem, SizeOf(TOClientItem)) + '/';
          if nCount >= 50 then break;
        end;
      end;
    end;
    m_DefMsg := MakeDefaultMsg(SM_SAVEITEMLIST, nBaseObject, 0, 0, nCount);
    SendSocket(@m_DefMsg, sSENDMSG);
  end else begin
    sSENDMSG := '';
    nCount := 0;
    if g_BigStorageList.GetUserStorageListByChrName(m_sCharName, List) then begin
      if nPage = 0 then nIndex := 0;
      if nPage > 0 then nIndex := nPage * 50;
      if nIndex > List.Count - 1 then begin
        m_nBigStoragePage := GetPageCount(List.Count);
        Exit;
      end;
      for i := nIndex to List.Count - 1 do begin
        BigStorage := List.Items[i];
        if BigStorage = nil then Continue;
        Item := UserEngine.GetStdItem(BigStorage.UseItems.wIndex);
        //sItemNewName:=GetItemName(UserItem.MakeIndex);
        Item := UserEngine.GetStdItem(BigStorage.UseItems.wIndex);
        if Item <> nil then begin
          Inc(nCount);
          StdItem := Item^;
          ItemUnit.GetItemAddValue(@BigStorage.UseItems, StdItem);
          Move(StdItem, ClientItem.s, SizeOf(TStdItem));
          //取自定义物品名称
          sUserItemName := '';
          if BigStorage.UseItems.btValue[13] = 1 then
            sUserItemName := ItemUnit.GetCustomItemName(BigStorage.UseItems.MakeIndex, BigStorage.UseItems.wIndex);
          if sUserItemName <> '' then
            ClientItem.s.Name := sUserItemName;
          ClientItem.Dura := BigStorage.UseItems.Dura;
          ClientItem.DuraMax := BigStorage.UseItems.DuraMax;
          ClientItem.MakeIndex := BigStorage.UseItems.MakeIndex;
          sSENDMSG := sSENDMSG + EncodeBuffer(@ClientItem, SizeOf(TClientItem)) + '/';
          if nCount >= 50 then break;
        end;
      end;
    end;
    m_DefMsg := MakeDefaultMsg(SM_SAVEITEMLIST, nBaseObject, 0, 0, nCount);
    SendSocket(@m_DefMsg, sSENDMSG);
  end;
end;

procedure TPlayObject.SendChangeGuildName;
begin
  if m_MyGuild <> nil then begin
    SendDefMessage(SM_CHANGEGUILDNAME, 0, 0, 0, 0, TGUild(m_MyGuild).sGuildName + '/' + m_sGuildRankName);
  end else begin
    SendDefMessage(SM_CHANGEGUILDNAME, 0, 0, 0, 0, '');
  end;
end;

procedure TPlayObject.SendDelItemList(ItemList: TStringList);
var
  i: Integer;
  s10: string;
begin
  s10 := '';
  for i := 0 to ItemList.Count - 1 do begin
    s10 := s10 + ItemList.Strings[i] + '/' + IntToStr(Integer(ItemList.Objects[i])) + '/';
  end;
  m_DefMsg := MakeDefaultMsg(SM_DELITEMS, 0, 0, 0, ItemList.Count);
  SendSocket(@m_DefMsg, EncodeString(s10));
end;

procedure TPlayObject.SendDelItems(UserItem: pTUserItem);
var
  StdItem: pTStdItem;
  StdItem80: TStdItem;
  ClientItem: TClientItem;
  OClientItem: TOClientItem;
  sUserItemName: string;
begin
  //sItemNewName:=GetItemName(UserItem.MakeIndex);
  if (m_nSoftVersionDateEx = 0) and (m_dwClientTick = 0) then begin
    StdItem := UserEngine.GetStdItem(UserItem.wIndex);
    if StdItem <> nil then begin
      StdItem80 := StdItem^;
      ItemUnit.GetItemAddValue(@UserItem, StdItem80);
      //Move(StdItem80,ClientItem.S,SizeOf(TStdItem));
      CopyStdItemToOStdItem(@StdItem80, @OClientItem.s);

      //取自定义物品名称
      sUserItemName := '';
      if UserItem.btValue[13] = 1 then
        sUserItemName := ItemUnit.GetCustomItemName(UserItem.MakeIndex, UserItem.wIndex);
      if sUserItemName <> '' then
        OClientItem.s.Name := sUserItemName;

      OClientItem.MakeIndex := UserItem.MakeIndex;
      OClientItem.Dura := UserItem.Dura;
      OClientItem.DuraMax := UserItem.DuraMax;
      if StdItem.StdMode = 50 then begin
        OClientItem.s.Name := OClientItem.s.Name + ' #' + IntToStr(UserItem.Dura);
      end;
      m_DefMsg := MakeDefaultMsg(SM_DELITEM, Integer(Self), 0, 0, 1);
      SendSocket(@m_DefMsg, EncodeBuffer(@OClientItem, SizeOf(TOClientItem)));
    end;
  end else begin
    StdItem := UserEngine.GetStdItem(UserItem.wIndex);
    if StdItem <> nil then begin
      StdItem80 := StdItem^;
      ItemUnit.GetItemAddValue(@UserItem, StdItem80);
      Move(StdItem80, ClientItem.s, SizeOf(TStdItem));
      //取自定义物品名称
      sUserItemName := '';
      if UserItem.btValue[13] = 1 then
        sUserItemName := ItemUnit.GetCustomItemName(UserItem.MakeIndex, UserItem.wIndex);
      if sUserItemName <> '' then
        ClientItem.s.Name := sUserItemName;
      ClientItem.MakeIndex := UserItem.MakeIndex;
      ClientItem.Dura := UserItem.Dura;
      ClientItem.DuraMax := UserItem.DuraMax;
      if StdItem.StdMode = 50 then begin
        ClientItem.s.Name := ClientItem.s.Name + ' #' + IntToStr(UserItem.Dura);
      end;
      m_DefMsg := MakeDefaultMsg(SM_DELITEM, Integer(Self), 0, 0, 1);
      SendSocket(@m_DefMsg, EncodeBuffer(@ClientItem, SizeOf(TClientItem)));
    end;
  end;
end;

procedure TPlayObject.SendUpdateItem(UserItem: pTUserItem);
var
  StdItem: pTStdItem;
  StdItem80: TStdItem;
  ClientItem: TClientItem;
  OClientItem: TOClientItem;
  sUserItemName: string;
begin
  if (m_nSoftVersionDateEx = 0) and (m_dwClientTick = 0) then begin
    StdItem := UserEngine.GetStdItem(UserItem.wIndex);
    if StdItem <> nil then begin
      StdItem80 := StdItem^;
      ItemUnit.GetItemAddValue(UserItem, StdItem80);
      //Move(StdItem80,ClientItem.S,SizeOf(TStdItem));
      CopyStdItemToOStdItem(@StdItem80, @OClientItem.s);

      //取自定义物品名称
      sUserItemName := '';
      if UserItem.btValue[13] = 1 then
        sUserItemName := ItemUnit.GetCustomItemName(UserItem.MakeIndex, UserItem.wIndex);
      if sUserItemName <> '' then
        OClientItem.s.Name := sUserItemName;

      OClientItem.MakeIndex := UserItem.MakeIndex;
      OClientItem.Dura := UserItem.Dura;
      OClientItem.DuraMax := UserItem.DuraMax;
      if StdItem.StdMode = 50 then begin
        OClientItem.s.Name := ClientItem.s.Name + ' #' + IntToStr(UserItem.Dura);
      end;
      m_DefMsg := MakeDefaultMsg(SM_UPDATEITEM, Integer(Self), 0, 0, 1);
      SendSocket(@m_DefMsg, EncodeBuffer(@OClientItem, SizeOf(TOClientItem)));
    end;
  end else begin
    StdItem := UserEngine.GetStdItem(UserItem.wIndex);
    if StdItem <> nil then begin
      StdItem80 := StdItem^;
      ItemUnit.GetItemAddValue(UserItem, StdItem80);
      ClientItem.s := StdItem80;

      //取自定义物品名称
      sUserItemName := '';
      if UserItem.btValue[13] = 1 then
        sUserItemName := ItemUnit.GetCustomItemName(UserItem.MakeIndex, UserItem.wIndex);
      if sUserItemName <> '' then
        ClientItem.s.Name := sUserItemName;

      ClientItem.MakeIndex := UserItem.MakeIndex;
      ClientItem.Dura := UserItem.Dura;
      ClientItem.DuraMax := UserItem.DuraMax;
      if StdItem.StdMode = 50 then begin
        ClientItem.s.Name := ClientItem.s.Name + ' #' + IntToStr(UserItem.Dura);
      end;
      m_DefMsg := MakeDefaultMsg(SM_UPDATEITEM, Integer(Self), 0, 0, 1);
      SendSocket(@m_DefMsg, EncodeBuffer(@ClientItem, SizeOf(TClientItem)));
    end;
  end;
end;

function TPlayObject.CheckTakeOnItems(nWhere: Integer; var StdItem: TStdItem): Boolean; //004C5084
var
  Castle: TUserCastle;
begin
  Result := False;
  if (StdItem.StdMode = 10) and (m_btGender <> 0) then begin
    SysMsg(sWearNotOfWoMan, c_Red, t_Hint);
    Exit;
  end;
  if (StdItem.StdMode = 11) and (m_btGender <> 1) then begin
    SysMsg(sWearNotOfMan, c_Red, t_Hint);
    Exit;
  end;
  if (nWhere = 1) or (nWhere = 2) then begin
    if StdItem.Weight > m_WAbil.MaxHandWeight then begin
      SysMsg(sHandWeightNot, c_Red, t_Hint);
      Exit;
    end;
  end else begin
    if (StdItem.Weight + GetUserItemWeitht(nWhere)) > m_WAbil.MaxWearWeight then begin
      SysMsg(sWearWeightNot, c_Red, t_Hint);
      Exit;
    end;
  end;
  Castle := g_CastleManager.IsCastleMember(Self);
  case StdItem.Need of //
    0: begin
        if m_Abil.Level >= StdItem.NeedLevel then begin
          Result := True;
        end else begin
          SysMsg(g_sLevelNot, c_Red, t_Hint);
        end;
      end;
    1: begin
        if HiWord(m_WAbil.DC) >= StdItem.NeedLevel then begin
          Result := True;
        end else begin
          SysMsg(g_sDCNot, c_Red, t_Hint);
        end;
      end;
    10: begin
        if (m_btJob = LoWord(StdItem.NeedLevel)) and (m_Abil.Level >= HiWord(StdItem.NeedLevel)) then begin
          Result := True;
        end else begin
          SysMsg(g_sJobOrLevelNot, c_Red, t_Hint);
        end;
      end;
    11: begin
        if (m_btJob = LoWord(StdItem.NeedLevel)) and (HiWord(m_WAbil.DC) >= HiWord(StdItem.NeedLevel)) then begin
          Result := True;
        end else begin
          SysMsg(g_sJobOrDCNot, c_Red, t_Hint);
        end;
      end;
    12: begin
        if (m_btJob = LoWord(StdItem.NeedLevel)) and (HiWord(m_WAbil.MC) >= HiWord(StdItem.NeedLevel)) then begin
          Result := True;
        end else begin
          SysMsg(g_sJobOrMCNot, c_Red, t_Hint);
        end;
      end;
    13: begin
        if (m_btJob = LoWord(StdItem.NeedLevel)) and (HiWord(m_WAbil.SC) >= HiWord(StdItem.NeedLevel)) then begin
          Result := True;
        end else begin
          SysMsg(g_sJobOrSCNot, c_Red, t_Hint);
        end;
      end;
    2: begin
        if HiWord(m_WAbil.MC) >= StdItem.NeedLevel then begin
          Result := True;
        end else begin
          SysMsg(g_sMCNot, c_Red, t_Hint);
        end;
      end;
    3: begin
        if HiWord(m_WAbil.SC) >= StdItem.NeedLevel then begin
          Result := True;
        end else begin
          SysMsg(g_sSCNot, c_Red, t_Hint);
        end;
      end;
    4: begin
        if m_btReLevel >= StdItem.NeedLevel then begin
          Result := True;
        end else begin
          SysMsg(g_sReNewLevelNot, c_Red, t_Hint);
        end;
      end;
    40: begin
        if m_btReLevel >= LoWord(StdItem.NeedLevel) then begin
          if m_Abil.Level >= HiWord(StdItem.NeedLevel) then begin
            Result := True;
          end else begin
            SysMsg(g_sLevelNot, c_Red, t_Hint);
          end;
        end else begin
          SysMsg(g_sReNewLevelNot, c_Red, t_Hint);
        end;
      end;
    41: begin
        if m_btReLevel >= LoWord(StdItem.NeedLevel) then begin
          if HiWord(m_WAbil.DC) >= HiWord(StdItem.NeedLevel) then begin
            Result := True;
          end else begin
            SysMsg(g_sDCNot, c_Red, t_Hint);
          end;
        end else begin
          SysMsg(g_sReNewLevelNot, c_Red, t_Hint);
        end;
      end;
    42: begin
        if m_btReLevel >= LoWord(StdItem.NeedLevel) then begin
          if HiWord(m_WAbil.MC) >= HiWord(StdItem.NeedLevel) then begin
            Result := True;
          end else begin
            SysMsg(g_sMCNot, c_Red, t_Hint);
          end;
        end else begin
          SysMsg(g_sReNewLevelNot, c_Red, t_Hint);
        end;
      end;
    43: begin
        if m_btReLevel >= LoWord(StdItem.NeedLevel) then begin
          if HiWord(m_WAbil.SC) >= HiWord(StdItem.NeedLevel) then begin
            Result := True;
          end else begin
            SysMsg(g_sSCNot, c_Red, t_Hint);
          end;
        end else begin
          SysMsg(g_sReNewLevelNot, c_Red, t_Hint);
        end;
      end;
    44: begin
        if m_btReLevel >= LoWord(StdItem.NeedLevel) then begin
          if m_btCreditPoint >= HiWord(StdItem.NeedLevel) then begin
            Result := True;
          end else begin
            SysMsg(g_sCreditPointNot, c_Red, t_Hint);
          end;
        end else begin
          SysMsg(g_sReNewLevelNot, c_Red, t_Hint);
        end;
      end;
    5: begin
        if m_btCreditPoint >= StdItem.NeedLevel then begin
          Result := True;
        end else begin
          SysMsg(g_sCreditPointNot, c_Red, t_Hint);
        end;
      end;
    6: begin
        if (m_MyGuild <> nil) then begin
          Result := True;
        end else begin
          SysMsg(g_sGuildNot, c_Red, t_Hint);
        end;
      end;
    60: begin
        if (m_MyGuild <> nil) and (m_nGuildRankNo = 1) then begin
          Result := True;
        end else begin
          SysMsg(g_sGuildMasterNot, c_Red, t_Hint);
        end;
      end;
    7: begin
        //      if (m_MyGuild <> nil) and (UserCastle.m_MasterGuild = m_MyGuild) then begin
        if (m_MyGuild <> nil) and (Castle <> nil) then begin
          Result := True;
        end else begin
          SysMsg(g_sSabukHumanNot, c_Red, t_Hint);
        end;
      end;
    70: begin
        //      if (m_MyGuild <> nil) and (UserCastle.m_MasterGuild = m_MyGuild) and (m_nGuildRankNo = 1) then begin
        if (m_MyGuild <> nil) and (Castle <> nil) and (m_nGuildRankNo = 1) then begin
          if m_Abil.Level >= StdItem.NeedLevel then begin
            Result := True;
          end else begin
            SysMsg(g_sLevelNot, c_Red, t_Hint);
          end;
        end else begin
          SysMsg(g_sSabukMasterManNot, c_Red, t_Hint);
        end;
      end;
    8: begin
        if m_nMemberType <> 0 then begin
          Result := True;
        end else begin
          SysMsg(g_sMemberNot, c_Red, t_Hint);
        end;
      end;
    81: begin
        if (m_nMemberType = LoWord(StdItem.NeedLevel)) and (m_nMemberLevel >= HiWord(StdItem.NeedLevel)) then begin
          Result := True;
        end else begin
          SysMsg(g_sMemberTypeNot, c_Red, t_Hint);
        end;
      end;
    82: begin
        if (m_nMemberType >= LoWord(StdItem.NeedLevel)) and (m_nMemberLevel >= HiWord(StdItem.NeedLevel)) then begin
          Result := True;
        end else begin
          SysMsg(g_sMemberTypeNot, c_Red, t_Hint);
        end;
      end;
  end;
  //if not Result then SysMsg(g_sCanottWearIt,c_Red,t_Hint);
end;

function TBaseObject.sub_4C5370(nX, nY: Integer; nRange: Integer; var nDX, nDY: Integer): Boolean; //004C5370
var
  i: Integer;
  ii: Integer;
  III: Integer;
begin
  Result := False;
  if m_PEnvir.GetMovingObject(nX, nY, True) = nil then begin
    Result := True;
    nDX := nX;
    nDY := nY;
  end;
  if not Result then begin
    for i := 1 to nRange do begin
      for ii := -i to i do begin
        for III := -i to i do begin
          nDX := nX + III;
          nDY := nY + ii;
          if m_PEnvir.GetMovingObject(nDX, nDY, True) = nil then begin
            Result := True;
            break;
          end;
        end;
        if Result then break;
      end;
      if Result then break;
    end;
  end;
  if not Result then begin
    nDX := nX;
    nDY := nY;
  end;
end;

function TPlayObject.GetUserItemWeitht(nWhere: Integer): Integer;
var
  i: Integer;
  n14: Integer;
  StdItem: pTStdItem;
begin
  n14 := 0;
  for i := Low(THumanUseItems) to High(THumanUseItems) do begin
    if (nWhere = -1) or (not (i = nWhere) and not (i = 1) and not (i = 2)) then begin
      StdItem := UserEngine.GetStdItem(m_UseItems[i].wIndex);
      if StdItem <> nil then Inc(n14, StdItem.Weight);
    end;
  end;
  Result := n14;
end;

function TPlayObject.EatItems(StdItem: pTStdItem): Boolean;
var
  bo06: Boolean;
  nOldStatus: Integer;
begin
  Result := False;
  if m_PEnvir.m_boNODRUG then begin
    SysMsg(sCanotUseDrugOnThisMap, c_Red, t_Hint);
    Exit;
  end;
  case StdItem.StdMode of
    0: begin
        case StdItem.Shape of
          1: begin
              IncHealthSpell(StdItem.AC, StdItem.MAC);
              Result := True;
            end;
          2: begin
              m_boUserUnLockDurg := True;
              Result := True;
            end;
          else begin
              {
              if ((StdItem.AC + m_nIncHealth) < 500) and (StdItem.AC > 0) then begin
                Inc(m_nIncHealth,StdItem.AC);
              end;
              if ((StdItem.MAC + m_nIncSpell) < 500) and (StdItem.MAC > 0) then begin
                Inc(m_nIncSpell,StdItem.MAC);
              end;
              }
              if (StdItem.AC > 0) then begin
                Inc(m_nIncHealth, StdItem.AC);
              end;
              if (StdItem.MAC > 0) then begin
                Inc(m_nIncSpell, StdItem.MAC);
              end;
              Result := True;
            end;
        end;
      end;
    1: begin
        nOldStatus := GetMyStatus();
        Inc(m_nHungerStatus, StdItem.DuraMax div 10);
        m_nHungerStatus := _MIN(5000, m_nHungerStatus);
        if nOldStatus <> GetMyStatus() then
          RefMyStatus();
        Result := True;
      end;
    2: Result := True;
    3: begin
        if StdItem.Shape = 12 then begin
          bo06 := False;
          if LoWord(StdItem.DC) > 0 then begin
            m_boDC := True;
            m_wStatusArrValue[0 {0x218}] := LoWord(StdItem.DC);
            m_dwStatusArrTimeOutTick[0 {0x220}] := GetTickCount + HiWord(StdItem.MAC) * 1000;
            SysMsg('攻击力增加' + IntToStr(HiWord(StdItem.MAC)) + '秒', c_Green, t_Hint);
            bo06 := True;
          end;
          if LoWord(StdItem.MC) > 0 then begin
            m_boMC := True;
            m_wStatusArrValue[1 {0x219}] := LoWord(StdItem.MC);
            m_dwStatusArrTimeOutTick[1 {0x224}] := GetTickCount + HiWord(StdItem.MAC) * 1000;
            SysMsg('魔法力增加' + IntToStr(HiWord(StdItem.MAC)) + '秒', c_Green, t_Hint);
            bo06 := True;
          end;
          if LoByte(StdItem.SC) > 0 then begin
            m_boSC := True;
            m_wStatusArrValue[2 {0x21A}] := LoWord(StdItem.SC);
            m_dwStatusArrTimeOutTick[2 {0x228}] := GetTickCount + HiWord(StdItem.MAC) * 1000;
            SysMsg('道术增加' + IntToStr(HiWord(StdItem.MAC)) + '秒', c_Green, t_Hint);
            bo06 := True;
          end;
          if HiWord(StdItem.AC) > 0 then begin
            m_boHitSpeed := True;
            m_wStatusArrValue[3 {0x21B}] := HiWord(StdItem.AC);
            m_dwStatusArrTimeOutTick[3 {0x22C}] := GetTickCount + HiWord(StdItem.MAC) * 1000;
            SysMsg('攻击速度增加' + IntToStr(HiWord(StdItem.MAC)) + '秒', c_Green, t_Hint);
            bo06 := True;
          end;
          if LoWord(StdItem.AC) > 0 then begin
            m_boAC := True;
            m_wStatusArrValue[4 {0x21C}] := LoWord(StdItem.AC);
            m_dwStatusArrTimeOutTick[4 {0x230}] := GetTickCount + HiWord(StdItem.MAC) * 1000;
            SysMsg('生命值增加' + IntToStr(HiWord(StdItem.MAC)) + '秒', c_Green, t_Hint);
            bo06 := True;
          end;
          if LoWord(StdItem.MAC) > 0 then begin
            m_boMAC := True;
            m_wStatusArrValue[5 {0x21D}] := LoWord(StdItem.MAC);
            m_dwStatusArrTimeOutTick[5 {0x234}] := GetTickCount + HiWord(StdItem.MAC) * 1000;
            SysMsg('魔法值增加' + IntToStr(HiWord(StdItem.MAC)) + '秒', c_Green, t_Hint);
            bo06 := True;
          end;
          if bo06 then begin
            RecalcAbilitys();
            SendMsg(Self, RM_ABILITY, 0, 0, 0, 0, '');
            Result := True;
          end;
        end else begin
          Result := EatUseItems(StdItem.Shape);
        end;
      end;
  end;
end;

function TPlayObject.ReadBook(StdItem: pTStdItem): Boolean;
var
  Magic: pTMagic;
  UserMagic: pTUserMagic;
  PlayObject: TPlayObject;
begin
  Result := False;
  Magic := UserEngine.FindMagic(StdItem.Name);
  if Magic <> nil then begin
    if not IsTrainingSkill(Magic.wMagicId) then begin
      if (Magic.btJob = 99) or (Magic.btJob = m_btJob) then begin
        if m_Abil.Level >= Magic.TrainLevel[0] then begin
          New(UserMagic);
          UserMagic.MagicInfo := Magic;
          UserMagic.wMagIdx := Magic.wMagicId;
          UserMagic.btKey := 0;
          UserMagic.btLevel := 0;
          UserMagic.nTranPoint := 0;
          m_MagicList.Add(UserMagic);
          RecalcAbilitys();
          if m_btRaceServer = RC_PLAYOBJECT then begin
            PlayObject := TPlayObject(Self);
            PlayObject.SendAddMagic(UserMagic);
          end;
          Result := True;
        end;
      end;
    end;
  end;
end;

function TBaseObject.IsTrainingSkill(nIndex: Integer): Boolean;
var
  i: Integer;
  UserMagic: pTUserMagic;
begin
  Result := False;
  for i := 0 to m_MagicList.Count - 1 do begin
    UserMagic := m_MagicList.Items[i];
    if (UserMagic <> nil) and (UserMagic.wMagIdx = nIndex) then begin
      Result := True;
      break;
    end;
  end;
end;

procedure TPlayObject.SendAddMagic(UserMagic: pTUserMagic);
var
  ClientMagic: TClientMagic;
begin
  ClientMagic.Key := Char(UserMagic.btKey);
  ClientMagic.Level := UserMagic.btLevel;
  ClientMagic.CurTrain := UserMagic.nTranPoint;
  ClientMagic.Def := UserMagic.MagicInfo^;
  m_DefMsg := MakeDefaultMsg(SM_ADDMAGIC, 0, 0, 0, 1);
  SendSocket(@m_DefMsg, EncodeBuffer(@ClientMagic, SizeOf(TClientMagic)));
end;

procedure TPlayObject.SendDelMagic(UserMagic: pTUserMagic);
begin
  m_DefMsg := MakeDefaultMsg(SM_DELMAGIC, UserMagic.wMagIdx, 0, 0, 1);
  SendSocket(@m_DefMsg, '');
end;

function TPlayObject.EatUseItems(nShape: Integer): Boolean;
var
  Castle: TUserCastle;
begin
  Result := False;
  case nShape of //
    1: begin
        SendRefMsg(RM_SPACEMOVE_FIRE, 0, 0, 0, 0, '');
        BaseObjectMove(m_sHomeMap, '', '');
        Result := True;
      end;
    2: begin
        if not m_PEnvir.m_boNORANDOMMOVE then begin
          SendRefMsg(RM_SPACEMOVE_FIRE, 0, 0, 0, 0, '');
          BaseObjectMove(m_sMapName, '', '');
          Result := True;
        end;
      end;
    3: begin
        SendRefMsg(RM_SPACEMOVE_FIRE, 0, 0, 0, 0, '');
        if PKLevel < 2 then begin
          BaseObjectMove(m_sHomeMap, IntToStr(m_nHomeX), IntToStr(m_nHomeY));
        end else begin
          BaseObjectMove(g_Config.sRedHomeMap, IntToStr(g_Config.nRedHomeX), IntToStr(g_Config.nRedHomeY));
        end;
        Result := True;
      end;
    4: begin
        if WeaptonMakeLuck() then Result := True;
      end;
    5: begin
        if m_MyGuild <> nil then begin
          if not m_boInFreePKArea then begin
            Castle := g_CastleManager.IsCastleMember(Self);
            {
            if UserCastle.IsMasterGuild(TGuild(m_MyGuild)) then begin
              BaseObjectMove(UserCastle.m_sHomeMap,IntToStr(UserCastle.GetHomeX),IntToStr(UserCastle.GetHomeY));
            }
            if (Castle <> nil) and Castle.IsMasterGuild(TGUild(m_MyGuild)) then begin
              BaseObjectMove(Castle.m_sHomeMap, IntToStr(Castle.GetHomeX), IntToStr(Castle.GetHomeY));
            end else begin
              SysMsg('无效', c_Red, t_Hint);
            end;
            Result := True;
          end else begin
            SysMsg('此处无法使用', c_Red, t_Hint);
          end;
        end;
      end;
    9: begin
        if RepairWeapon() then Result := True;
      end;
    10: begin
        if SuperRepairWeapon() then Result := True;
      end;
    11: begin
        if WinLottery() then Result := True;
      end;
  end;
end;

procedure TPlayObject.MoveToHome;
begin
  SendRefMsg(RM_SPACEMOVE_FIRE, 0, 0, 0, 0, '');
  BaseObjectMove(m_sHomeMap, IntToStr(m_nHomeX), IntToStr(m_nHomeY));
end;

procedure TPlayObject.BaseObjectMove(sMAP, sX, sY: string);
var
  Envir: TEnvirnoment;
  nX, nY: Integer;
begin
  Envir := m_PEnvir;
  if sMAP = '' then sMAP := m_sMapName;
  if (sX <> '') and (sY <> '') then begin
    nX := Str_ToInt(sX, 0);
    nY := Str_ToInt(sY, 0);
    SpaceMove(sMAP, nX, nY, 0);
  end else begin
    MapRandomMove(sMAP, 0);
  end;
  if (Envir <> m_PEnvir) and (m_btRaceServer = RC_PLAYOBJECT) then begin
    m_boTimeRecall := False;
  end;
end;
//使用祝福油
function TPlayObject.WeaptonMakeLuck: Boolean;
var
  StdItem: pTStdItem;
  nRand: Integer;
  boMakeLuck: Boolean;
begin
  Result := False;
  if m_UseItems[U_WEAPON].wIndex <= 0 then Exit;
  nRand := 0;
  StdItem := UserEngine.GetStdItem(m_UseItems[U_WEAPON].wIndex);
  if StdItem <> nil then begin
    nRand := abs((HiWord(StdItem.DC) - LoWord(StdItem.DC))) div 5;
  end;
  if Random(g_Config.nWeaponMakeUnLuckRate {20}) = 1 then begin
    MakeWeaponUnlock();
  end else begin
    boMakeLuck := False;
    if m_UseItems[U_WEAPON].btValue[4] > 0 then begin
      Dec(m_UseItems[U_WEAPON].btValue[4]);
      SysMsg(g_sWeaptonMakeLuck {'武器被加幸运了...'}, c_Green, t_Hint);
      boMakeLuck := True;
    end else if m_UseItems[U_WEAPON].btValue[3] < g_Config.nWeaponMakeLuckPoint1 {1} then begin
      Inc(m_UseItems[U_WEAPON].btValue[3]);
      SysMsg(g_sWeaptonMakeLuck {'武器被加幸运了...'}, c_Green, t_Hint);
      boMakeLuck := True;
    end else if (m_UseItems[U_WEAPON].btValue[3] < g_Config.nWeaponMakeLuckPoint2 {3}) and (Random(nRand + g_Config.nWeaponMakeLuckPoint2Rate {6}) = 1) then begin
      Inc(m_UseItems[U_WEAPON].btValue[3]);
      SysMsg(g_sWeaptonMakeLuck {'武器被加幸运了...'}, c_Green, t_Hint);
      boMakeLuck := True;
    end else if (m_UseItems[U_WEAPON].btValue[3] < g_Config.nWeaponMakeLuckPoint3 {7}) and (Random(nRand * g_Config.nWeaponMakeLuckPoint3Rate {10 + 30}) = 1) then begin
      Inc(m_UseItems[U_WEAPON].btValue[3]);
      SysMsg(g_sWeaptonMakeLuck {'武器被加幸运了...'}, c_Green, t_Hint);
      boMakeLuck := True;
    end;
    if m_btRaceServer = RC_PLAYOBJECT then begin
      RecalcAbilitys();
      SendMsg(Self, RM_ABILITY, 0, 0, 0, 0, '');
      SendMsg(Self, RM_SUBABILITY, 0, 0, 0, 0, '');
    end;
    if not boMakeLuck then SysMsg(g_sWeaptonNotMakeLuck {'无效'}, c_Green, t_Hint);
  end;
  Result := True;
end;

function TPlayObject.RepairWeapon: Boolean;
var
  nDura: Integer;
  UserItem: pTUserItem;
begin
  Result := False;
  UserItem := @m_UseItems[U_WEAPON];
  if (UserItem.wIndex <= 0) or (UserItem.DuraMax <= UserItem.Dura) then Exit;
  Dec(UserItem.DuraMax, (UserItem.DuraMax - UserItem.Dura) div g_Config.nRepairItemDecDura {30});
  nDura := _MIN(5000, UserItem.DuraMax - UserItem.Dura);
  if nDura > 0 then begin
    Inc(UserItem.Dura, nDura);
    SendMsg(Self, RM_DURACHANGE, 1, UserItem.Dura, UserItem.DuraMax, 0, '');
    SysMsg(g_sWeaponRepairSuccess {'武器修复成功...'}, c_Green, t_Hint);
    Result := True;
  end;
end;

function TPlayObject.SuperRepairWeapon: Boolean;
begin
  Result := False;
  if m_UseItems[U_WEAPON].wIndex <= 0 then Exit;
  m_UseItems[U_WEAPON].Dura := m_UseItems[U_WEAPON].DuraMax;
  SendMsg(Self, RM_DURACHANGE, 1, m_UseItems[U_WEAPON].Dura, m_UseItems[U_WEAPON].DuraMax, 0, '');
  SysMsg(g_sWeaponRepairSuccess {'武器修复成功...'}, c_Green, t_Hint);
  Result := True;
end;

function TPlayObject.WinLottery: Boolean;
var
  nGold, nWinLevel, nRate: Integer;
begin
  nGold := 0;
  nWinLevel := 0;
  {
  case Random(30000) of
    0..4999: begin //004BD866
     if nWinLotteryCount < nNoWinLotteryCount then begin
       nGold:=500;
       nWinLevel:=6;
       Inc(nWinLotteryLevel6);
     end;
    end;
    14000..15999: begin //004BD895
     if nWinLotteryCount < nNoWinLotteryCount then begin
       nGold:=1000;
       nWinLevel:=5;
       Inc(nWinLotteryLevel5);
     end;
    end;
    16000..16149: begin //004BD8C4
     if nWinLotteryCount < nNoWinLotteryCount then begin
       nGold:=10000;
       nWinLevel:=4;
       Inc(nWinLotteryLevel4);
     end;
    end;
    16150..16169: begin //004BD8F0
     if nWinLotteryCount < nNoWinLotteryCount then begin
       nGold:=100000;
       nWinLevel:=3;
       Inc(nWinLotteryLevel3);
     end;
    end;
    16170..16179: begin //004BD918
     if nWinLotteryCount < nNoWinLotteryCount then begin
       nGold:=200000;
       nWinLevel:=2;
       Inc(nWinLotteryLevel2);
     end;
    end;
    16180 + 1820: begin //004BD940
     if nWinLotteryCount < nNoWinLotteryCount then begin
       nGold:=1000000;
       nWinLevel:=1;
       Inc(nWinLotteryLevel1);
     end;
    end;
  end;
  }
  nRate := Random(g_Config.nWinLotteryRate);
  if nRate in [g_Config.nWinLottery6Min..g_Config.nWinLottery6Max] then begin
    if g_Config.nWinLotteryCount < g_Config.nNoWinLotteryCount then begin
      nGold := g_Config.nWinLottery6Gold;
      nWinLevel := 6;
      Inc(g_Config.nWinLotteryLevel6);
    end;
  end else
    if nRate in [g_Config.nWinLottery5Min..g_Config.nWinLottery5Max] then begin
    if g_Config.nWinLotteryCount < g_Config.nNoWinLotteryCount then begin
      nGold := g_Config.nWinLottery5Gold;
      nWinLevel := 5;
      Inc(g_Config.nWinLotteryLevel5);
    end;
  end else
    if nRate in [g_Config.nWinLottery4Min..g_Config.nWinLottery4Max] then begin
    if g_Config.nWinLotteryCount < g_Config.nNoWinLotteryCount then begin
      nGold := g_Config.nWinLottery4Gold;
      nWinLevel := 4;
      Inc(g_Config.nWinLotteryLevel4);
    end;
  end else
    if nRate in [g_Config.nWinLottery3Min..g_Config.nWinLottery3Max] then begin
    if g_Config.nWinLotteryCount < g_Config.nNoWinLotteryCount then begin
      nGold := g_Config.nWinLottery3Gold;
      nWinLevel := 3;
      Inc(g_Config.nWinLotteryLevel3);
    end;
  end else
    if nRate in [g_Config.nWinLottery2Min..g_Config.nWinLottery2Max] then begin
    if g_Config.nWinLotteryCount < g_Config.nNoWinLotteryCount then begin
      nGold := g_Config.nWinLottery2Gold;
      nWinLevel := 2;
      Inc(g_Config.nWinLotteryLevel2);
    end;
  end else
    if nRate in [g_Config.nWinLottery1Min + g_Config.nWinLottery1Max] then begin
    if g_Config.nWinLotteryCount < g_Config.nNoWinLotteryCount then begin
      nGold := g_Config.nWinLottery1Gold;
      nWinLevel := 1;
      Inc(g_Config.nWinLotteryLevel1);
    end;
  end;
  if nGold > 0 then begin
    case nWinLevel of //
      1: SysMsg(g_sWinLottery1Msg {'祝贺您，中了一等奖。'}, c_Green, t_Hint);
      2: SysMsg(g_sWinLottery2Msg {'祝贺您，中了二等奖。'}, c_Green, t_Hint);
      3: SysMsg(g_sWinLottery3Msg {'祝贺您，中了三等奖。'}, c_Green, t_Hint);
      4: SysMsg(g_sWinLottery4Msg {'祝贺您，中了四等奖。'}, c_Green, t_Hint);
      5: SysMsg(g_sWinLottery5Msg {'祝贺您，中了五等奖。'}, c_Green, t_Hint);
      6: SysMsg(g_sWinLottery6Msg {'祝贺您，中了六等奖。'}, c_Green, t_Hint);
    end;
    if IncGold(nGold) then begin
      GoldChanged();
    end else begin
      DropGoldDown(nGold, True, nil, nil);
    end;

  end else begin
    Inc(g_Config.nNoWinLotteryCount, 500);
    SysMsg(g_sNotWinLotteryMsg {'等下次机会吧！！！'}, c_Red, t_Hint);
  end;
  Result := True;
end;

procedure TBaseObject.DamageBubbleDefence(nInt: Integer);
begin
  if m_wStatusTimeArr[STATE_BUBBLEDEFENCEUP {0x76}] > 0 then begin
    if m_wStatusTimeArr[STATE_BUBBLEDEFENCEUP {0x76}] > 3 then
      Dec(m_wStatusTimeArr[STATE_BUBBLEDEFENCEUP {0x76}], 3)
    else m_wStatusTimeArr[STATE_BUBBLEDEFENCEUP {0x76}] := 1;
  end;
end;

function TBaseObject.IsGuildMaster: Boolean;
begin
  Result := False;
  if (m_MyGuild <> nil) and (m_nGuildRankNo = 1) then
    Result := True;
end;

procedure TPlayObject.ChangeServerMakeSlave(SalveInfo: pTSlaveInfo);
var
  nSlavecount: Integer;
  BaseObject: TBaseObject;
begin
  if m_btJob = 2 then begin
    nSlavecount := 1;
  end else begin
    nSlavecount := 5;
  end;
  BaseObject := MakeSlave(SalveInfo.sSalveName, 3, SalveInfo.btSalveLevel, nSlavecount, SalveInfo.dwRoyaltySec);
  if BaseObject <> nil then begin
    BaseObject.n294 := SalveInfo.nKillCount;
    BaseObject.m_btSlaveExpLevel := SalveInfo.btSlaveExpLevel;
    BaseObject.m_WAbil.HP := SalveInfo.nHP;
    BaseObject.m_WAbil.MP := SalveInfo.nMP;
    if (1500 - SalveInfo.btSalveLevel * 200) < BaseObject.m_nWalkSpeed then begin
      BaseObject.m_nWalkSpeed := 1500 - SalveInfo.btSalveLevel * 200;
    end;
    if Integer(2000 - SalveInfo.btSalveLevel * 200) < BaseObject.m_nNextHitTime then begin
      BaseObject.m_nWalkSpeed := 2000 - SalveInfo.btSalveLevel * 200;
    end;
    RecalcAbilitys();
  end;
end;

procedure TPlayObject.SendDelDealItem(UserItem: pTUserItem);
var
  StdItem: pTStdItem;
  ClientItem: TClientItem;
  OClientItem: TOClientItem;
  sUserItemName: string;
begin
  SendDefMessage(SM_DEALDELITEM_OK, 0, 0, 0, 0, '');
  if m_DealCreat <> nil then begin
    if TPlayObject(m_DealCreat).m_nSoftVersionDateEx = 0 then begin
      StdItem := UserEngine.GetStdItem(UserItem.wIndex);
      if StdItem <> nil then begin
        //ClientItem.S:=StdItem^;
        CopyStdItemToOStdItem(StdItem, @OClientItem.s);
        //取自定义物品名称
        sUserItemName := '';
        if UserItem.btValue[13] = 1 then
          sUserItemName := ItemUnit.GetCustomItemName(UserItem.MakeIndex, UserItem.wIndex);
        if sUserItemName <> '' then
          OClientItem.s.Name := sUserItemName;

        OClientItem.MakeIndex := UserItem.MakeIndex;
        OClientItem.Dura := UserItem.Dura;
        OClientItem.DuraMax := UserItem.DuraMax;
      end;
      m_DefMsg := MakeDefaultMsg(SM_DEALREMOTEDELITEM, Integer(Self), 0, 0, 1);
      TPlayObject(m_DealCreat).SendSocket(@m_DefMsg, EncodeBuffer(@OClientItem, SizeOf(TOClientItem)));
    end else begin
      StdItem := UserEngine.GetStdItem(UserItem.wIndex);
      if StdItem <> nil then begin
        ClientItem.s := StdItem^;
        //取自定义物品名称
        sUserItemName := '';
        if UserItem.btValue[13] = 1 then
          sUserItemName := ItemUnit.GetCustomItemName(UserItem.MakeIndex, UserItem.wIndex);
        if sUserItemName <> '' then
          ClientItem.s.Name := sUserItemName;
        ClientItem.MakeIndex := UserItem.MakeIndex;
        ClientItem.Dura := UserItem.Dura;
        ClientItem.DuraMax := UserItem.DuraMax;
      end;
      m_DefMsg := MakeDefaultMsg(SM_DEALREMOTEDELITEM, Integer(Self), 0, 0, 1);
      TPlayObject(m_DealCreat).SendSocket(@m_DefMsg, EncodeBuffer(@ClientItem, SizeOf(TClientItem)));
    end;
    m_DealCreat.m_DealLastTick := GetTickCount();
    m_DealLastTick := GetTickCount();
  end;
end;
{
procedure TPlayObject.SendAddDealItem(UserItem: pTUserItem); //004DD464
var
  StdItem:pTStdItem;
  StdItem80:TStdItem;
  ClientItem:TClientItem;
  OClientItem:TOClientItem;
  //sItemNewName:String;
begin

  //sItemNewName:=GetItemName(UserItem.MakeIndex);
if m_nSoftVersionDateEx = 0 then begin
  SendDefMessage(SM_DEALADDITEM_OK,0,0,0,0,'');
  if m_DealCreat <> nil then begin
    StdItem:=UserEngine.GetStdItem(UserItem.wIndex);
    if StdItem <> nil then begin
      StdItem80:=StdItem^;
      ItemUnit.GetItemAddValue(UserItem,StdItem80);
      //OClientItem.S:=StdItem80;
      CopyStdItemToOStdItem(@StdItem80,@OClientItem.S);
      //if sItemNewName <> '' then
      //  OClientItem.S.Name:=sItemNewName;
      OClientItem.MakeIndex:=UserItem.MakeIndex;
      OClientItem.Dura:=UserItem.Dura;
      OClientItem.DuraMax:=UserItem.DuraMax;
    end;
    m_DefMsg:=MakeDefaultMsg(SM_DEALREMOTEADDITEM,Integer(Self),0,0,1);
    TPlayObject(m_DealCreat).SendSocket(@m_DefMsg,EncodeBuffer(@OClientItem,SizeOf(TOClientItem)));
    m_DealCreat.m_DealLastTick:=GetTickCount();
    m_DealLastTick:=GetTickCount();
  end;
end else begin
  SendDefMessage(SM_DEALADDITEM_OK,0,0,0,0,'');
  if m_DealCreat <> nil then begin
    StdItem:=UserEngine.GetStdItem(UserItem.wIndex);
    if StdItem <> nil then begin
      StdItem80:=StdItem^;
      ItemUnit.GetItemAddValue(UserItem,StdItem80);
      ClientItem.S:=StdItem80;
      //if sItemNewName <> '' then
      //  ClientItem.S.Name:=sItemNewName;
      ClientItem.MakeIndex:=UserItem.MakeIndex;
      ClientItem.Dura:=UserItem.Dura;
      ClientItem.DuraMax:=UserItem.DuraMax;
    end;
    m_DefMsg:=MakeDefaultMsg(SM_DEALREMOTEADDITEM,Integer(Self),0,0,1);
    TPlayObject(m_DealCreat).SendSocket(@m_DefMsg,EncodeBuffer(@ClientItem,SizeOf(TClientItem)));
    m_DealCreat.m_DealLastTick:=GetTickCount();
    m_DealLastTick:=GetTickCount();
  end;
end;
end;
}
procedure TPlayObject.SendAddDealItem(UserItem: pTUserItem); //004DD464
var
  StdItem: pTStdItem;
  StdItem80: TStdItem;
  ClientItem: TClientItem;
  OClientItem: TOClientItem;
  sUserItemName: string;
  sCheckItemName: string;
begin
  SendDefMessage(SM_DEALADDITEM_OK, 0, 0, 0, 0, '');
  if Assigned(zPlugOfEngine.CheckCanDealItem) then begin
    sCheckItemName := UserEngine.GetStdItem(UserItem.wIndex).Name;
    if not zPlugOfEngine.CheckCanDealItem(Self, PChar(sCheckItemName)) then Exit;
  end;
  if m_DealCreat <> nil then begin
    if TPlayObject(m_DealCreat).m_nSoftVersionDateEx = 0 then begin
      StdItem := UserEngine.GetStdItem(UserItem.wIndex);
      if StdItem <> nil then begin
        StdItem80 := StdItem^;
        //取自定义物品名称
        sUserItemName := '';
        if UserItem.btValue[13] = 1 then
          sUserItemName := ItemUnit.GetCustomItemName(UserItem.MakeIndex, UserItem.wIndex);
        if sUserItemName <> '' then
          StdItem80.Name := sUserItemName;

        ItemUnit.GetItemAddValue(UserItem, StdItem80);
        //OClientItem.S:=StdItem80;
        CopyStdItemToOStdItem(@StdItem80, @OClientItem.s);
        //if sItemNewName <> '' then
        //  OClientItem.S.Name:=sItemNewName;
        OClientItem.MakeIndex := UserItem.MakeIndex;
        OClientItem.Dura := UserItem.Dura;
        OClientItem.DuraMax := UserItem.DuraMax;
        m_DefMsg := MakeDefaultMsg(SM_DEALREMOTEADDITEM, Integer(Self), 0, 0, 1);
        TPlayObject(m_DealCreat).SendSocket(@m_DefMsg, EncodeBuffer(@OClientItem, SizeOf(TOClientItem)));
        m_DealCreat.m_DealLastTick := GetTickCount();
        m_DealLastTick := GetTickCount();
      end;
    end else begin
      StdItem := UserEngine.GetStdItem(UserItem.wIndex);
      if StdItem <> nil then begin
        StdItem80 := StdItem^;
        ItemUnit.GetItemAddValue(UserItem, StdItem80);

        //取自定义物品名称
        sUserItemName := '';
        if UserItem.btValue[13] = 1 then
          sUserItemName := ItemUnit.GetCustomItemName(UserItem.MakeIndex, UserItem.wIndex);
        if sUserItemName <> '' then
          StdItem80.Name := sUserItemName;

        ClientItem.s := StdItem80;
        ClientItem.MakeIndex := UserItem.MakeIndex;
        ClientItem.Dura := UserItem.Dura;
        ClientItem.DuraMax := UserItem.DuraMax;
        m_DefMsg := MakeDefaultMsg(SM_DEALREMOTEADDITEM, Integer(Self), 0, 0, 1);
        TPlayObject(m_DealCreat).SendSocket(@m_DefMsg, EncodeBuffer(@ClientItem, SizeOf(TClientItem)));
        m_DealCreat.m_DealLastTick := GetTickCount();
        m_DealLastTick := GetTickCount();
      end;
    end;
  end;
end;

procedure TPlayObject.OpenDealDlg(BaseObject: TBaseObject);
begin
  m_boDealing := True;
  m_DealCreat := BaseObject;
  GetBackDealItems();
  SendDefMessage(SM_DEALMENU, 0, 0, 0, 0, m_DealCreat.m_sCharName);
  m_DealLastTick := GetTickCount();
end;

procedure TPlayObject.JoinGroup(PlayObject: TPlayObject);
begin
  m_GroupOwner := PlayObject;
  //SendGroupText(m_sCharName + ' 已加入小组.');
  SendGroupText(format(g_sJoinGroup, [m_sCharName]));
end;

function TBaseObject.MagCanHitTarget(nX, nY: Integer;
  TargeTBaseObject: TBaseObject): Boolean;
var
  n14, n18, n1C, n20: Integer;
begin
  Result := False;
  if TargeTBaseObject = nil then Exit;
  n20 := abs(nX - TargeTBaseObject.m_nCurrX) + abs(nY - TargeTBaseObject.m_nCurrY);
  n14 := 0;
  while (n14 < 13) do begin
    n18 := GetNextDirection(nX, nY, TargeTBaseObject.m_nCurrX, TargeTBaseObject.m_nCurrY);
    if m_PEnvir.GetNextPosition(nX, nY, n18, 1, nX, nY) and m_PEnvir.sub_4B5FC8(nX, nY) then begin
      if (nX = TargeTBaseObject.m_nCurrX) and (nY = TargeTBaseObject.m_nCurrY) then begin
        Result := True;
        break;
      end else begin
        n1C := abs(nX - TargeTBaseObject.m_nCurrX) + abs(nY - TargeTBaseObject.m_nCurrY);
        if n1C > n20 then begin
          Result := True;
          break;
        end;
        n1C := n20;
      end;
    end else begin
      break;
    end;
    Inc(n14);
  end;
end;

function TBaseObject.IsProperFriend(BaseObject: TBaseObject): Boolean;
  function IsFriend(cret: TBaseObject): Boolean;
  var
    i: Integer;
  begin
    Result := False;
    if cret.m_btRaceServer = RC_PLAYOBJECT then begin //措惑捞 荤恩牢 版快父
      case m_btAttatckMode of
        HAM_ALL: Result := True;
        HAM_PEACE: Result := True;
        HAM_DEAR: begin
            if (Self = cret) or (cret = TPlayObject(Self).m_DearHuman) then begin
              Result := True;
            end;
          end;
        HAM_MASTER: begin
            if (Self = cret) then begin
              Result := True;
            end else
              if TPlayObject(Self).m_boMaster then begin
              for i := 0 to TPlayObject(Self).m_MasterList.Count - 1 do begin
                if TPlayObject(Self).m_MasterList.Items[i] = cret then begin
                  Result := True;
                  break;
                end;
              end;
            end else
              if TPlayObject(cret).m_boMaster then begin
              for i := 0 to TPlayObject(cret).m_MasterList.Count - 1 do begin
                if TPlayObject(cret).m_MasterList.Items[i] = Self then begin
                  Result := True;
                  break;
                end;
              end;
            end;
          end;
        HAM_GROUP: begin
            if cret = Self then
              Result := True;
            if IsGroupMember(cret) then
              Result := True;
          end;
        HAM_GUILD: begin
            if cret = Self then
              Result := True;
            if m_MyGuild <> nil then begin
              if TGUild(m_MyGuild).IsMember(cret.m_sCharName) then
                Result := True;
              if m_boGuildWarArea and (cret.m_MyGuild <> nil) then begin
                if TGUild(m_MyGuild).IsAllyGuild(TGUild(cret.m_MyGuild)) then
                  Result := True;
              end;
            end;
          end;
        HAM_PKATTACK: begin
            if cret = Self then Result := True;
            if PKLevel >= 2 then begin
              if cret.PKLevel < 2 then Result := True;
            end else begin
              if cret.PKLevel >= 2 then Result := True;
            end;
          end;
      end;
    end;
  end;
begin
  Result := False;
  if BaseObject = nil then Exit;

  if m_btRaceServer = RC_PLAYMOSTER then begin //分身检测
    if m_Master = nil then begin
      if (BaseObject.m_btRaceServer >= RC_ANIMAL) then
        Result := True;
      if (BaseObject.m_Master <> nil) or (BaseObject.m_btRaceServer = RC_PLAYOBJECT) then
        Result := False;
    end else begin
      if (BaseObject.m_btRaceServer >= RC_ANIMAL) then
        Result := False;
      if BaseObject.m_Master <> nil then
        Result := IsFriend(BaseObject.m_Master);
      if BaseObject.m_btRaceServer = RC_PLAYOBJECT then
        Result := IsFriend(BaseObject);
      if BaseObject = m_Master then
        Result := True;
    end;
    Exit;
  end;

  if (m_btRaceServer >= RC_ANIMAL) then begin
    if (BaseObject.m_btRaceServer >= RC_ANIMAL) then
      Result := True;
    if BaseObject.m_Master <> nil then
      Result := False;
    Exit;
  end;

  if m_btRaceServer = RC_PLAYOBJECT then begin
    Result := IsFriend(BaseObject);
    if BaseObject.m_btRaceServer < RC_ANIMAL then Exit;
    if BaseObject.m_Master = Self then begin
      Result := True;
      Exit;
    end;
    if BaseObject.m_Master <> nil then begin
      Result := IsFriend(BaseObject.m_Master);
      Exit;
    end;
  end else Result := True;
end;

function TBaseObject.MagMakeDefenceArea(nX, nY, nRange, nSec: Integer;
  btState: Byte; boState: Boolean): Integer;
var
  III: Integer;
  i, ii: Integer;
  nStartX, nStartY, nEndX, nEndY: Integer;
  MapCellInfo: pTMapCellinfo;
  OSObject: pTOSObject;
  BaseObject: TBaseObject;
begin
  Result := 0;
  nStartX := nX - nRange;
  nEndX := nX + nRange;
  nStartY := nY - nRange;
  nEndY := nY + nRange;
  for i := nStartX to nEndX do begin
    for ii := nStartY to nEndY do begin
      if m_PEnvir.GetMapCellInfo(i, ii, MapCellInfo) and (MapCellInfo.ObjList <> nil) then begin
        for III := 0 to MapCellInfo.ObjList.Count - 1 do begin
          OSObject := MapCellInfo.ObjList.Items[III];
          if (OSObject <> nil) and (OSObject.btType = OS_MOVINGOBJECT) then begin
            BaseObject := TBaseObject(OSObject.CellObj);
            if (BaseObject <> nil) and (not BaseObject.m_boGhost) then begin
              if IsProperFriend(BaseObject) then begin
                if btState = 0 then begin
                  BaseObject.m_boAC := boState;
                  BaseObject.DefenceUp(nSec);
                end else begin
                  BaseObject.m_boMC := boState;
                  BaseObject.MagDefenceUp(nSec);
                end;
                Inc(Result);
              end
            end;
          end;
        end;
      end;
    end;
  end;
end;

function TBaseObject.MagMakeAbilityArea(nX, nY, nRange, nSec: Integer;
  btState: Byte; boState: Boolean): Integer;
var
  III: Integer;
  i, ii: Integer;
  nStartX, nStartY, nEndX, nEndY: Integer;
  MapCellInfo: pTMapCellinfo;
  OSObject: pTOSObject;
  BaseObject: TBaseObject;
begin
  Result := 0;
  nStartX := nX - nRange;
  nEndX := nX + nRange;
  nStartY := nY - nRange;
  nEndY := nY + nRange;
  for i := nStartX to nEndX do begin
    for ii := nStartY to nEndY do begin
      if m_PEnvir.GetMapCellInfo(i, ii, MapCellInfo) and (MapCellInfo.ObjList <> nil) then begin
        for III := 0 to MapCellInfo.ObjList.Count - 1 do begin
          OSObject := MapCellInfo.ObjList.Items[III];
          if (OSObject <> nil) and (OSObject.btType = OS_MOVINGOBJECT) then begin
            BaseObject := TBaseObject(OSObject.CellObj);
            if (BaseObject <> nil) and (not BaseObject.m_boGhost) then begin
              if boState then begin
                if IsProperFriend(BaseObject) then begin
                  case btState of
                    0: begin
                        case BaseObject.m_btJob of
                          0: begin
                              if BaseObject.m_wStatusArrValue[0 {0x218}] = 0 then
                                BaseObject.m_wStatusArrValue[0 {0x218}] := (HiWord(BaseObject.m_WAbil.DC) - 1 - (BaseObject.m_Abil.Level div 7)) div 3 + 1;
                              BaseObject.m_boDC := boState;
                            end;
                          1: begin
                              if BaseObject.m_wStatusArrValue[1 {0x218}] = 0 then
                                BaseObject.m_wStatusArrValue[1 {0x218}] := (HiWord(BaseObject.m_WAbil.MC) - 1 - (BaseObject.m_Abil.Level div 7)) div 3 + 1;
                              BaseObject.m_boMC := boState;
                            end;
                          2: begin
                              if BaseObject.m_wStatusArrValue[2 {0x218}] = 0 then
                                BaseObject.m_wStatusArrValue[2 {0x218}] := (HiWord(BaseObject.m_WAbil.SC) - 1 - (BaseObject.m_Abil.Level div 7)) div 3 + 1;
                              BaseObject.m_boSC := boState;
                            end;
                        end;
                      end;
                    1: begin
                        if BaseObject.m_wStatusArrValue[3 {0x21B}] = 0 then
                          BaseObject.m_wStatusArrValue[2 {0x218}] := _MAX(m_nHitSpeed div 10, 1);
                        BaseObject.m_boHitSpeed := boState;
                      end;
                    2: begin
                        if BaseObject.m_wStatusArrValue[4 {0x21B}] = 0 then
                          BaseObject.m_wStatusArrValue[2 {0x218}] := _MAX(HiWord(BaseObject.m_WAbil.MaxHP) div 10, 1);
                        BaseObject.m_boMaxHP := boState;
                      end;
                    3: begin
                        if BaseObject.m_wStatusArrValue[5 {0x21B}] = 0 then
                          BaseObject.m_wStatusArrValue[2 {0x218}] := _MAX(HiWord(BaseObject.m_WAbil.MaxMP) div 10, 1);
                        BaseObject.m_boMaxMP := boState;
                      end;
                  end;
                  BaseObject.MagChangeAbility(nSec, btState);
                  Inc(Result);
                end;
              end else begin
                if IsProperTarget(BaseObject) then begin
                  case btState of
                    0: begin
                        case BaseObject.m_btJob of
                          0: begin
                              if BaseObject.m_wStatusArrValue[0 {0x218}] = 0 then
                                BaseObject.m_wStatusArrValue[0 {0x218}] := MakeLong(LoWord(BaseObject.m_WAbil.DC), HiWord(BaseObject.m_WAbil.DC) - 2 - (BaseObject.m_Abil.Level div 7));
                              BaseObject.m_boDC := boState;
                            end;
                          1: begin
                              if BaseObject.m_wStatusArrValue[1 {0x218}] = 0 then
                                BaseObject.m_wStatusArrValue[1 {0x218}] := MakeLong(LoWord(BaseObject.m_WAbil.MC), HiWord(BaseObject.m_WAbil.MC) - 2 - (BaseObject.m_Abil.Level div 7));
                              BaseObject.m_boMC := boState;
                            end;
                          2: begin
                              if BaseObject.m_wStatusArrValue[2 {0x218}] = 0 then
                                BaseObject.m_wStatusArrValue[2 {0x218}] := MakeLong(LoWord(BaseObject.m_WAbil.SC), HiWord(BaseObject.m_WAbil.SC) - 2 - (BaseObject.m_Abil.Level div 7));
                              BaseObject.m_boSC := boState;
                            end;
                        end;
                      end;
                    (* 0: begin
                         case BaseObject.m_btJob of
                           0: begin
                               if BaseObject.m_wStatusArrValue[0 {0x218}] = 0 then
                                 BaseObject.m_wStatusArrValue[0 {0x218}] := MakeLong(LoWord(BaseObject.m_WAbil.DC), HiWord(BaseObject.m_WAbil.DC) - 2 - (BaseObject.m_Abil.Level div 7));
                               BaseObject.m_boDC := boState;
                             end;
                           1: begin
                               if BaseObject.m_wStatusArrValue[1 {0x218}] = 0 then
                                 BaseObject.m_wStatusArrValue[1 {0x218}] := MakeLong(LoWord(BaseObject.m_WAbil.MC), HiWord(BaseObject.m_WAbil.MC) - 2 - (BaseObject.m_Abil.Level div 7));
                               BaseObject.m_boMC := boState;
                             end;
                           2: begin
                               if BaseObject.m_wStatusArrValue[2 {0x218}] = 0 then
                                 BaseObject.m_wStatusArrValue[2 {0x218}] := MakeLong(LoWord(BaseObject.m_WAbil.SC), HiWord(BaseObject.m_WAbil.SC) - 2 - (BaseObject.m_Abil.Level div 7));
                               BaseObject.m_boSC := boState;
                             end;
                         end;
                       end; *)
                    1: begin
                        if BaseObject.m_wStatusArrValue[3 {0x21B}] = 0 then
                          BaseObject.m_wStatusArrValue[2 {0x218}] := _MAX(m_nHitSpeed div 10, 1);
                        BaseObject.m_boHitSpeed := boState;
                      end;
                    2: begin
                        if BaseObject.m_wStatusArrValue[4 {0x21B}] = 0 then
                          BaseObject.m_wStatusArrValue[2 {0x218}] := _MAX(HiWord(BaseObject.m_WAbil.MaxHP) div 10, 1);
                        BaseObject.m_boMaxHP := boState;
                      end;
                    3: begin
                        if BaseObject.m_wStatusArrValue[5 {0x21B}] = 0 then
                          BaseObject.m_wStatusArrValue[2 {0x218}] := _MAX(HiWord(BaseObject.m_WAbil.MaxMP) div 10, 1);
                        BaseObject.m_boMaxMP := boState;
                      end;
                  end;
                  BaseObject.MagChangeAbility(nSec, btState);
                  Inc(Result);
                end;
              end;
            end;
          end;
        end;
      end;
    end;
  end;
end;

function TBaseObject.MagChangeAbility(nSec: Integer; btState: Byte): Boolean;
var
  bo06: Boolean;
begin
  bo06 := False;
  case btState of
    0: begin
        if m_wStatusArrValue[0 {0x218}] > 0 then begin
          m_dwStatusArrTimeOutTick[0 {0x220}] := GetTickCount + nSec * 1000;
          if m_boDC then
            SysMsg('攻击力增加' + IntToStr(nSec) + '秒', c_Green, t_Hint)
          else
            SysMsg('攻击力减少' + IntToStr(nSec) + '秒', c_Green, t_Hint);
          bo06 := True;
        end;
        if m_wStatusArrValue[1 {0x219}] > 0 then begin
          m_dwStatusArrTimeOutTick[1 {0x224}] := GetTickCount + nSec * 1000;
          if m_boMC then
            SysMsg('魔法力增加' + IntToStr(nSec) + '秒', c_Green, t_Hint)
          else
            SysMsg('魔法力减少' + IntToStr(nSec) + '秒', c_Green, t_Hint);
          bo06 := True;
        end;
        if m_wStatusArrValue[2 {0x21A}] > 0 then begin
          m_dwStatusArrTimeOutTick[2 {0x228}] := GetTickCount + nSec * 1000;
          if m_boSC then
            SysMsg('道术增加' + IntToStr(nSec) + '秒', c_Green, t_Hint)
          else
            SysMsg('道术减少' + IntToStr(nSec) + '秒', c_Green, t_Hint);
          bo06 := True;
        end;
      end;
    1: begin
        if m_wStatusArrValue[3 {0x21B}] > 0 then begin
          m_dwStatusArrTimeOutTick[3 {0x22C}] := GetTickCount + nSec * 1000;
          if m_boHitSpeed then
            SysMsg('攻击速度增加' + IntToStr(nSec) + '秒', c_Green, t_Hint)
          else
            SysMsg('攻击速度减少' + IntToStr(nSec) + '秒', c_Green, t_Hint);
          bo06 := True;
        end;
      end;
    2: begin
        if m_wStatusArrValue[4 {0x21C}] > 0 then begin
          m_dwStatusArrTimeOutTick[4 {0x230}] := GetTickCount + nSec * 1000;
          if m_boMaxHP then
            SysMsg('生命值增加' + IntToStr(nSec) + '秒', c_Green, t_Hint)
          else
            SysMsg('生命值减少' + IntToStr(nSec) + '秒', c_Green, t_Hint);
          bo06 := True;
        end;
      end;
    3: begin
        if m_wStatusArrValue[5 {0x21D}] > 0 then begin
          m_dwStatusArrTimeOutTick[5 {0x234}] := GetTickCount + nSec * 1000;
          if m_boMaxMP then
            SysMsg('魔法值增加' + IntToStr(nSec) + '秒', c_Green, t_Hint)
          else
            SysMsg('魔法值减少' + IntToStr(nSec) + '秒', c_Green, t_Hint);
          bo06 := True;
        end;
      end;
  end;
  if bo06 then begin
    RecalcAbilitys();
    SendMsg(Self, RM_ABILITY, 0, 0, 0, 0, '');
    Result := True;
  end;
end;

function TPlayObject.AbilityUp(UserMagic: pTUserMagic): Boolean;
var
  nSpellPoint, n14: Integer;
begin
  Result := False;
  nSpellPoint := GetSpellPoint(UserMagic);
  if nSpellPoint > 0 then begin
    if m_WAbil.MP < nSpellPoint then Exit;
    n14 := Random(10 + UserMagic.btLevel) + UserMagic.btLevel;
    m_dwStatusArrTimeOutTick[2 {0x228}] := GetTickCount + n14 * 1000;
    m_boSC := True;
    m_wStatusArrValue[2 {0x218}] := MakeLong(LoWord(m_WAbil.SC), HiWord(m_WAbil.SC) - 2 - (m_Abil.Level div 7));
    SysMsg('道术增加' + IntToStr(m_wStatusArrValue[2 {0x218}]) + '点 ' + IntToStr(n14) + '秒', c_Green, t_Hint);
    RecalcAbilitys();
    SendMsg(Self, RM_ABILITY, 0, 0, 0, 0, '');
    Result := True;
  end;
end;

function TBaseObject.DefenceUp(nSec: Integer): Boolean;
begin
  Result := False;
  if m_wStatusTimeArr[STATE_DEFENCEUP {0x72}] > 0 then begin
    if m_wStatusTimeArr[STATE_DEFENCEUP {0x72}] < nSec then begin
      m_wStatusTimeArr[STATE_DEFENCEUP {0x72}] := nSec;
      Result := True;
    end;
  end else begin
    m_wStatusTimeArr[STATE_DEFENCEUP {0x72}] := nSec;
    Result := True;
  end;
  m_dwStatusArrTick[STATE_DEFENCEUP {0x20C}] := GetTickCount;
  if m_boAC then
    SysMsg(format(g_sDefenceUpTime, [nSec]), c_Green, t_Hint)
  else
    SysMsg(format(g_sDefenceDownTime, [nSec]), c_Green, t_Hint);
  //SysMsg('防御力增加' + IntToStr(nSec) + '秒',c_Green,t_Hint);
  RecalcAbilitys();
  SendMsg(Self, RM_ABILITY, 0, 0, 0, 0, '');
end;

function TBaseObject.MagDefenceUp(nSec: Integer): Boolean;
begin
  Result := False;
  if m_wStatusTimeArr[STATE_MAGDEFENCEUP {0x74}] > 0 then begin
    if m_wStatusTimeArr[STATE_MAGDEFENCEUP {0x74}] < nSec then begin
      m_wStatusTimeArr[STATE_MAGDEFENCEUP {0x74}] := nSec;
      Result := True;
    end;
  end else begin
    m_wStatusTimeArr[STATE_MAGDEFENCEUP {0x74}] := nSec;
    Result := True;
  end;
  m_dwStatusArrTick[STATE_MAGDEFENCEUP {0x210}] := GetTickCount;
  if m_boMAC then
    SysMsg(format(g_sMagDefenceUpTime, [nSec]), c_Green, t_Hint)
  else
    SysMsg(format(g_sMagDefenceDownTime, [nSec]), c_Green, t_Hint);
  //  SysMsg('抗魔法力增加' + IntToStr(nSec) + '秒',c_Green,t_Hint);
  RecalcAbilitys();
  SendMsg(Self, RM_ABILITY, 0, 0, 0, 0, '');
end;

//魔法盾
function TBaseObject.MagBubbleDefenceUp(nLevel, nSec: Integer): Boolean;
var
  nOldStatus: Integer;
begin
  Result := False;
  if m_wStatusTimeArr[STATE_BUBBLEDEFENCEUP {0x76}] <> 0 then Exit;
  nOldStatus := m_nCharStatus;
  m_wStatusTimeArr[STATE_BUBBLEDEFENCEUP {0x76}] := nSec;
  m_dwStatusArrTick[STATE_BUBBLEDEFENCEUP {0x214}] := GetTickCount();
  m_nCharStatus := GetCharStatus();
  if nOldStatus <> m_nCharStatus then begin
    StatusChanged();
  end;
  m_boAbilMagBubbleDefence := True;
  m_btMagBubbleDefenceLevel := nLevel;
  Result := True;
end;

procedure TPlayObject.MakeMine;
  function RandomDrua(): Integer;
  begin
    Result := Random(g_Config.nStoneGeneralDuraRate {13000}) + g_Config.nStoneMinDura {3000};
    if Random(g_Config.nStoneAddDuraRate {20}) = 0 then begin
      Result := Result + Random(g_Config.nStoneAddDuraMax {10000});
    end;
  end;
var
  UserItem: pTUserItem;
  nRANDOM: Integer;
begin
  if m_ItemList.Count >= MAXBAGITEM then Exit;
  nRANDOM := Random(g_Config.nStoneTypeRate {120});
  if nRANDOM in [g_Config.nGoldStoneMin {1}..g_Config.nGoldStoneMax {2}] then begin
    New(UserItem);
    if UserEngine.CopyToUserItemFromName(g_Config.sGoldStone, UserItem) then begin
      UserItem.Dura := RandomDrua();
      m_ItemList.Add(UserItem);
      WeightChanged();
      SendAddItem(UserItem);
    end else DisPose(UserItem);
    Exit;
  end;
  if nRANDOM in [g_Config.nSilverStoneMin {3}..g_Config.nSilverStoneMax {20}] then begin
    New(UserItem);
    if UserEngine.CopyToUserItemFromName(g_Config.sSilverStone, UserItem) then begin
      UserItem.Dura := RandomDrua();
      m_ItemList.Add(UserItem);
      WeightChanged();
      SendAddItem(UserItem);
    end else DisPose(UserItem);
    Exit;
  end;
  if nRANDOM in [g_Config.nSteelStoneMin {21}..g_Config.nSteelStoneMax {45}] then begin
    New(UserItem);
    if UserEngine.CopyToUserItemFromName(g_Config.sSteelStone, UserItem) then begin
      UserItem.Dura := RandomDrua();
      m_ItemList.Add(UserItem);
      WeightChanged();
      SendAddItem(UserItem);
    end else DisPose(UserItem);
    Exit;
  end;
  if nRANDOM in [g_Config.nBlackStoneMin {46}..g_Config.nBlackStoneMax {56}] then begin
    New(UserItem);
    if UserEngine.CopyToUserItemFromName(g_Config.sBlackStone, UserItem) then begin
      UserItem.Dura := RandomDrua();
      m_ItemList.Add(UserItem);
      WeightChanged();
      SendAddItem(UserItem);
    end else DisPose(UserItem);
    Exit;
  end;
  New(UserItem);
  if UserEngine.CopyToUserItemFromName(g_Config.sCopperStone, UserItem) then begin
    UserItem.Dura := RandomDrua();
    m_ItemList.Add(UserItem);
    WeightChanged();
    SendAddItem(UserItem);
  end else DisPose(UserItem);


  {
  case Random(120) of    //
    1..2: begin
      New(UserItem);
      if UserEngine.CopyToUserItemFromName(sGoldStone,UserItem) then begin
        UserItem.Dura:=RandomDrua();
        m_ItemList.Add(UserItem);
        WeightChanged();
        SendAddItem(UserItem);
      end else Dispose(UserItem);
    end;
    3..20: begin
      New(UserItem);
      if UserEngine.CopyToUserItemFromName(sSilverStone,UserItem) then begin
        UserItem.Dura:=RandomDrua();
        m_ItemList.Add(UserItem);
        WeightChanged();
        SendAddItem(UserItem);
      end else Dispose(UserItem);
    end;
    21..45: begin
      New(UserItem);
      if UserEngine.CopyToUserItemFromName(sSteelStone,UserItem) then begin
        UserItem.Dura:=RandomDrua();
        m_ItemList.Add(UserItem);
        WeightChanged();
        SendAddItem(UserItem);
      end else Dispose(UserItem);
    end;
    46..56: begin
      New(UserItem);
      if UserEngine.CopyToUserItemFromName(sBlackStone,UserItem) then begin
        UserItem.Dura:=RandomDrua();
        m_ItemList.Add(UserItem);
        WeightChanged();
        SendAddItem(UserItem);
      end else Dispose(UserItem);
    end;
    else begin
      New(UserItem);
      if UserEngine.CopyToUserItemFromName(sCopperStone,UserItem) then begin
        UserItem.Dura:=RandomDrua();
        m_ItemList.Add(UserItem);
        WeightChanged();
        SendAddItem(UserItem);
      end else Dispose(UserItem);
    end;
  end;
  }
end;

function TPlayObject.QuestCheckItem(sItemName: string; var nCount,
  nParam: Integer; var nDura: Integer): pTUserItem;
var
  i: Integer;
  UserItem: pTUserItem;
  s1C: string;
begin
  Result := nil;
  nParam := 0;
  nDura := 0;
  nCount := 0;
  for i := 0 to m_ItemList.Count - 1 do begin
    UserItem := m_ItemList.Items[i];
    if UserItem = nil then Continue;
    s1C := UserEngine.GetStdItemName(UserItem.wIndex);
    if CompareText(s1C, sItemName) = 0 then begin
      if UserItem.Dura > nDura then begin
        nDura := UserItem.Dura;
        Result := UserItem;
      end;
      Inc(nParam, UserItem.Dura);
      if Result = nil then
        Result := UserItem;
      Inc(nCount);
    end;
  end;
end;

function TBaseObject.sub_4C4CD4(sItemName: string;
  var nCount: Integer): pTUserItem;
var
  i: Integer;
  sName: string;
begin
  Result := nil;
  nCount := 0;
  for i := Low(THumanUseItems) to High(THumanUseItems) do begin
    sName := UserEngine.GetStdItemName(m_UseItems[i].wIndex);
    if CompareText(sName, sItemName) = 0 then begin
      Result := @m_UseItems[i];
      Inc(nCount);
    end;
  end;
end;

function TPlayObject.QuestTakeCheckItem(CheckItem: pTUserItem): Boolean;
var
  i: Integer;
  UserItem: pTUserItem;
begin
  Result := False;
  for i := m_ItemList.Count - 1 downto 0 do begin
    if m_ItemList.Count <= 0 then break;
    UserItem := m_ItemList.Items[i];
    if UserItem = nil then Continue;
    if UserItem = CheckItem then begin
      SendDelItems(UserItem);
      DisPose(UserItem);
      m_ItemList.Delete(i);
      Result := True;
      break;
    end;
  end;
  for i := Low(m_UseItems) to High(m_UseItems) do begin
    if @m_UseItems[i] = CheckItem then begin
      SendDelItems(@m_UseItems[i]);
      m_UseItems[i].wIndex := 0;
      Result := True;
      break;
    end;
  end;
end;

procedure TPlayObject.ClientQueryRepairCost(nParam1, nInt: Integer;
  sMsg: string);
var
  i: Integer;
  UserItem: pTUserItem;
  UserItemA: pTUserItem;
  Merchant: TMerchant;
  sUserItemName: string;
begin
  UserItemA := nil;
  for i := 0 to m_ItemList.Count - 1 do begin
    UserItem := m_ItemList.Items[i];
    if UserItem = nil then Continue;
    if (UserItem.MakeIndex = nInt) then begin
      //取自定义物品名称
      sUserItemName := '';
      if UserItem.btValue[13] = 1 then
        sUserItemName := ItemUnit.GetCustomItemName(UserItem.MakeIndex, UserItem.wIndex);
      if sUserItemName = '' then
        sUserItemName := UserEngine.GetStdItemName(UserItem.wIndex);

      if (CompareText(sUserItemName, sMsg) = 0) then begin
        UserItemA := UserItem;
        break;
      end;
    end;
  end;
  if UserItemA = nil then Exit;
  Merchant := UserEngine.FindMerchant(TObject(nParam1));
  if (Merchant <> nil) and
    ((Merchant.m_PEnvir = m_PEnvir) and
    (abs(Merchant.m_nCurrX - m_nCurrX) < 15) and
    (abs(Merchant.m_nCurrY - m_nCurrY) < 15)) then
    Merchant.ClientQueryRepairCost(Self, UserItemA);
end;

procedure TPlayObject.ClientRepairItem(nParam1, nInt: Integer;
  sMsg: string);
var
  i: Integer;
  UserItem: pTUserItem;
  Merchant: TMerchant;
  sUserItemName: string;
  sCheckItemName: string;
  bo19: Boolean;
begin
  UserItem := nil;
  bo19 := False;
  for i := 0 to m_ItemList.Count - 1 do begin
    UserItem := m_ItemList.Items[i];
    if UserItem.MakeIndex = nInt then begin
      if Assigned(zPlugOfEngine.CheckCanRepairItem) then begin
        sCheckItemName := UserEngine.GetStdItemName(UserItem.wIndex);
        if not zPlugOfEngine.CheckCanRepairItem(Self, PChar(sCheckItemName)) then break;
      end;
    end;
    //取自定义物品名称
    sUserItemName := '';
    if UserItem.btValue[13] = 1 then
      sUserItemName := ItemUnit.GetCustomItemName(UserItem.MakeIndex, UserItem.wIndex);
    if sUserItemName = '' then
      sUserItemName := UserEngine.GetStdItemName(UserItem.wIndex);
    if (UserItem.MakeIndex = nInt) and
      (CompareText(sUserItemName, sMsg) = 0) then begin
      bo19 := True;
      break;
    end;
  end; // for
  if (UserItem = nil) or (not bo19) then Exit;

  Merchant := UserEngine.FindMerchant(TObject(nParam1));
  if (Merchant <> nil) and
    ((Merchant.m_PEnvir = m_PEnvir) and
    (abs(Merchant.m_nCurrX - m_nCurrX) < 15) and
    (abs(Merchant.m_nCurrY - m_nCurrY) < 15)) then
    Merchant.ClientRepairItem(Self, UserItem);
end;

procedure TPlayObject.ClientStorageItem(NPC: TObject;
  nItemIdx: Integer; sMsg: string);
var
  Merchant: TMerchant;
  i: Integer;
  UserItem: pTUserItem;
  bo19: Boolean;
  StdItem: pTStdItem;
  sUserItemName: string;
  sCheckItemName: string;
begin
  Merchant := UserEngine.FindMerchant(NPC);
  if (Merchant <> nil) and (Merchant.m_boBigStorage) then begin
    bo19 := False;
    UserItem := nil;
    if Pos(' ', sMsg) >= 0 then //折分物品名称(信件物品的名称后面加了使用次数)
      GetValidStr3(sMsg, sMsg, [' ']);
    if (m_nPayMent = 1) and not g_Config.boTryModeUseStorage then begin
      SysMsg(g_sTryModeCanotUseStorage {'试玩模式不可以使用仓库功能！！！'}, c_Red, t_Hint);
      SendDefMessage(SM_STORAGE_FAIL, 0, 0, 0, 0, '');
      Exit;
    end;
    if g_BigStorageList.GetUserStorageCount(m_sCharName) > g_Config.nBigStorageLimitCount then begin
      SysMsg(format(g_sBigStorageCountIsNul, [g_Config.nBigStorageLimitCount]), c_Red, t_Hint);
      SendDefMessage(SM_STORAGE_FAIL, 0, 0, 0, 0, '');
      Exit;
    end;
    for i := m_ItemList.Count - 1 downto 0 do begin
      if m_ItemList.Count <= 0 then break;
      UserItem := m_ItemList.Items[i];
      if UserItem = nil then Continue;
      if UserItem.MakeIndex = nItemIdx then begin
        if Assigned(zPlugOfEngine.CheckCanStorageItem) then begin
          sCheckItemName := UserEngine.GetStdItemName(UserItem.wIndex);
          try
            if not zPlugOfEngine.CheckCanStorageItem(Self, PChar(sCheckItemName)) then begin
              break;
            end;
          except
          end;
        end;
      end;
      //取自定义物品名称
      sUserItemName := '';
      if UserItem.btValue[13] = 1 then
        sUserItemName := ItemUnit.GetCustomItemName(UserItem.MakeIndex, UserItem.wIndex);
      if sUserItemName = '' then
        sUserItemName := UserEngine.GetStdItemName(UserItem.wIndex);
      if (UserItem.MakeIndex = nItemIdx) and (CompareText(sUserItemName, sMsg) = 0) then begin
        if (Merchant.m_boBigStorage) and //检查NPC是否允许存物品
        (((Merchant.m_PEnvir = m_PEnvir) and
          (abs(Merchant.m_nCurrX - m_nCurrX) < 15) and
          (abs(Merchant.m_nCurrY - m_nCurrY) < 15)) or (Merchant = g_FunctionNPC)) then begin
          if g_BigStorageList.AddItemToUserBigStorageList(m_sCharName, UserItem) then begin
            //DisPose(UserItem);
            m_ItemList.Delete(i);
            WeightChanged();
            SendDefMessage(SM_STORAGE_OK, 0, 0, 0, 0, '');
            //g_BigStorageList.SaveStorageList;
            StdItem := UserEngine.GetStdItem(UserItem.wIndex);
            //004DC55E
            if StdItem.NeedIdentify = 1 then
              AddGameDataLog('1' + #9 +
                m_sMapName + #9 +
                IntToStr(m_nCurrX) + #9 +
                IntToStr(m_nCurrY) + #9 +
                m_sCharName + #9 +
                //UserEngine.GetStdItemName(UserItem.wIndex) + #9 +
                StdItem.Name + #9 +
                IntToStr(UserItem.MakeIndex) + #9 +
                '1' + #9 +
                '0');
          end else begin
            SendDefMessage(SM_STORAGE_FULL, 0, 0, 0, 0, '');
          end;
          bo19 := True;
        end;
        break;
      end;
    end;
  end else begin
    bo19 := False;
    UserItem := nil;
    if Pos(' ', sMsg) >= 0 then //折分物品名称(信件物品的名称后面加了使用次数)
      GetValidStr3(sMsg, sMsg, [' ']);
    if (m_nPayMent = 1) and not g_Config.boTryModeUseStorage then begin
      SysMsg(g_sTryModeCanotUseStorage {'试玩模式不可以使用仓库功能！！！'}, c_Red, t_Hint);
      Exit;
    end;
    for i := m_ItemList.Count - 1 downto 0 do begin
      if m_ItemList.Count <= 0 then break;
      UserItem := m_ItemList.Items[i];
      if UserItem = nil then Continue;
      if UserItem.MakeIndex = nItemIdx then begin
        if Assigned(zPlugOfEngine.CheckCanStorageItem) then begin
          sCheckItemName := UserEngine.GetStdItemName(UserItem.wIndex);
          try
            if not zPlugOfEngine.CheckCanStorageItem(Self, PChar(sCheckItemName)) then begin
              break;
            end;
          except
          end;
        end;
      end;
      //取自定义物品名称
      sUserItemName := '';
      if UserItem.btValue[13] = 1 then
        sUserItemName := ItemUnit.GetCustomItemName(UserItem.MakeIndex, UserItem.wIndex);
      if sUserItemName = '' then
        sUserItemName := UserEngine.GetStdItemName(UserItem.wIndex);

      if (UserItem.MakeIndex = nItemIdx) and (CompareText(sUserItemName, sMsg) = 0) then begin
        Merchant := UserEngine.FindMerchant(NPC);
        if (Merchant <> nil) and
          (Merchant.m_boStorage) and //检查NPC是否允许存物品
        (((Merchant.m_PEnvir = m_PEnvir) and
          (abs(Merchant.m_nCurrX - m_nCurrX) < 15) and
          (abs(Merchant.m_nCurrY - m_nCurrY) < 15)) or (Merchant = g_FunctionNPC)) then begin
          if m_StorageItemList.Count < MAXBAGITEM then begin
            m_StorageItemList.Add(UserItem);
            m_ItemList.Delete(i);
            WeightChanged();
            SendDefMessage(SM_STORAGE_OK, 0, 0, 0, 0, '');
            StdItem := UserEngine.GetStdItem(UserItem.wIndex);
            //004DC55E
            if StdItem.NeedIdentify = 1 then
              AddGameDataLog('1' + #9 +
                m_sMapName + #9 +
                IntToStr(m_nCurrX) + #9 +
                IntToStr(m_nCurrY) + #9 +
                m_sCharName + #9 +
                //UserEngine.GetStdItemName(UserItem.wIndex) + #9 +
                StdItem.Name + #9 +
                IntToStr(UserItem.MakeIndex) + #9 +
                '1' + #9 +
                '0');
          end else begin
            SendDefMessage(SM_STORAGE_FULL, 0, 0, 0, 0, '');
          end;
          bo19 := True;
        end;
        break;
      end;
    end;
  end;
  if not bo19 then SendDefMessage(SM_STORAGE_FAIL, 0, 0, 0, 0, '');
end;

procedure TPlayObject.ClientTakeBackStorageItem(NPC: TObject;
  nItemIdx: Integer; sMsg: string);
var
  Merchant: TMerchant;
  i: Integer;
  UserItem: pTUserItem;
  AddItem: pTUserItem;
  bo19: Boolean;
  StdItem: pTStdItem;
  sUserItemName: string;
begin
  Merchant := UserEngine.FindMerchant(NPC);
  if (Merchant <> nil) and (Merchant.m_boBigGetback) then begin
    bo19 := False;
    UserItem := nil;
    if (m_nPayMent = 1) and not g_Config.boTryModeUseStorage then begin
      SysMsg(g_sTryModeCanotUseStorage {'试玩模式不可以使用仓库功能！！！'}, c_Red, t_Hint);
      Exit;
    end;
    if g_BigStorageList.GetUserStorageListByMakeIndex(m_sCharName, sMsg, nItemIdx, UserItem) then begin
      if (IsAddWeightAvailable(UserEngine.GetStdItemWeight(UserItem.wIndex))) then begin
        if (Merchant <> nil) and
          (Merchant.m_boBigGetback) and //检查NPC是否允许取物品
        (((Merchant.m_PEnvir = m_PEnvir) and
          (abs(Merchant.m_nCurrX - m_nCurrX) < 15) and
          (abs(Merchant.m_nCurrY - m_nCurrY) < 15)) or (Merchant = g_FunctionNPC)) then begin
          if AddItemToBag(UserItem) then begin
            SendAddItem(UserItem);
            g_BigStorageList.DelBigStorageItem(m_sCharName, sMsg, nItemIdx);
            SendDefMessage(SM_TAKEBACKSTORAGEITEM_OK, nItemIdx, 0, 0, 0, '');
            StdItem := UserEngine.GetStdItem(UserItem.wIndex);
            if StdItem.NeedIdentify = 1 then
              AddGameDataLog('0' + #9 +
                m_sMapName + #9 +
                IntToStr(m_nCurrX) + #9 +
                IntToStr(m_nCurrY) + #9 +
                m_sCharName + #9 +
                //UserEngine.GetStdItemName(UserItem.wIndex) + #9 +
                StdItem.Name + #9 +
                IntToStr(UserItem.MakeIndex) + #9 +
                '1' + #9 +
                '0');
          end else begin
            if UserItem <> nil then DisPose(UserItem);
            SendDefMessage(SM_TAKEBACKSTORAGEITEM_FULLBAG, 0, 0, 0, 0, '');
          end;
          bo19 := True;
        end;
      end else begin
        SysMsg(g_sCanotGetItems {'无法携带更多的东西！！！'}, c_Red, t_Hint);
      end;
    end;
  end else begin
    bo19 := False;
    UserItem := nil;
    Merchant := UserEngine.FindMerchant(NPC);
    if Merchant = nil then Exit;
    if (m_nPayMent = 1) and not g_Config.boTryModeUseStorage then begin
      SysMsg(g_sTryModeCanotUseStorage {'试玩模式不可以使用仓库功能！！！'}, c_Red, t_Hint);
      Exit;
    end;
    if not m_boCanGetBackItem then begin
      SendMsg(Merchant, RM_MENU_OK, 0, Integer(Self), 0, 0, g_sStorageIsLockedMsg + '\ \'
        + '仓库开锁命令: @' + g_GameCommand.UNLOCKSTORAGE.sCmd + '\'
        + '仓库加锁命令: @' + g_GameCommand.Lock.sCmd + '\'
        + '设置密码命令: @' + g_GameCommand.SETPASSWORD.sCmd + '\'
        + '修改密码命令: @' + g_GameCommand.CHGPASSWORD.sCmd);
      Exit;
    end;
    i := 0;
    while True do begin
      if i >= m_StorageItemList.Count then break;
      if m_StorageItemList.Count <= 0 then break;
      UserItem := m_StorageItemList.Items[i];
      //取自定义物品名称
      sUserItemName := '';
      if UserItem.btValue[13] = 1 then
        sUserItemName := ItemUnit.GetCustomItemName(UserItem.MakeIndex, UserItem.wIndex);
      if sUserItemName = '' then
        sUserItemName := UserEngine.GetStdItemName(UserItem.wIndex);

      if (UserItem.MakeIndex = nItemIdx) and
        (CompareText(sUserItemName, sMsg) = 0) then begin

        if (IsAddWeightAvailable(UserEngine.GetStdItemWeight(UserItem.wIndex))) then begin
          if (Merchant <> nil) and
            (Merchant.m_boGetback) and //检查NPC是否允许取物品
          (((Merchant.m_PEnvir = m_PEnvir) and
            (abs(Merchant.m_nCurrX - m_nCurrX) < 15) and
            (abs(Merchant.m_nCurrY - m_nCurrY) < 15)) or (Merchant = g_FunctionNPC)) then begin

            if AddItemToBag(UserItem) then begin
              SendAddItem(UserItem);
              m_StorageItemList.Delete(i);
              SendDefMessage(SM_TAKEBACKSTORAGEITEM_OK, nItemIdx, 0, 0, 0, '');
              StdItem := UserEngine.GetStdItem(UserItem.wIndex);
              if StdItem.NeedIdentify = 1 then
                AddGameDataLog('0' + #9 +
                  m_sMapName + #9 +
                  IntToStr(m_nCurrX) + #9 +
                  IntToStr(m_nCurrY) + #9 +
                  m_sCharName + #9 +
                  //UserEngine.GetStdItemName(UserItem.wIndex) + #9 +
                  StdItem.Name + #9 +
                  IntToStr(UserItem.MakeIndex) + #9 +
                  '1' + #9 +
                  '0');
            end else begin
              SendDefMessage(SM_TAKEBACKSTORAGEITEM_FULLBAG, 0, 0, 0, 0, '');
            end;
            bo19 := True;
          end;
        end else begin
          SysMsg(g_sCanotGetItems {'无法携带更多的东西！！！'}, c_Red, t_Hint);
        end;
        break;
      end;
      Inc(i);
    end;
  end;
  if Merchant = nil then Exit;
  if not bo19 then SendDefMessage(SM_TAKEBACKSTORAGEITEM_FAIL, 0, 0, 0, 0, '');
end;

function TBaseObject.CheckItems(sItemName: string): pTUserItem; //004C4AB0
var
  i: Integer;
  UserItem: pTUserItem;
begin
  Result := nil;
  for i := 0 to m_ItemList.Count - 1 do begin
    UserItem := m_ItemList.Items[i];
    if CompareText(UserEngine.GetStdItemName(UserItem.wIndex), sItemName) = 0 then begin
      Result := UserItem;
      break;
    end;
  end; // for
end;

procedure TPlayObject.MakeSaveRcd(var HumanRcd: THumDataInfo);
var
  i: Integer;
  HumData: pTHumData;
  HumItems: pTHumItems;
  HumAddItems: pTHumAddItems;
  BagItems: pTBagItems;
  HumMagics: pTHumMagics;
  UserMagic: pTUserMagic;
  StorageItems: pTStorageItems;
begin
  HumData := @HumanRcd.Data;
  HumData.sChrName := m_sCharName;
  HumData.sCurMap := m_sMapName;
  HumData.wCurX := m_nCurrX;
  HumData.wCurY := m_nCurrY;
  HumData.btDir := m_btDirection;
  HumData.btHair := m_btHair;
  HumData.btSex := m_btGender;
  HumData.btJob := m_btJob;
  HumData.nGold := m_nGold;

  HumData.Abil.Level := m_Abil.Level;
  HumData.Abil.HP := m_Abil.HP;
  HumData.Abil.MP := m_Abil.MP;
  HumData.Abil.MaxHP := m_Abil.MaxHP;
  HumData.Abil.MaxMP := m_Abil.MaxMP;
  HumData.Abil.Exp := m_Abil.Exp;
  HumData.Abil.MaxExp := m_Abil.MaxExp;
  HumData.Abil.Weight := m_Abil.Weight;
  HumData.Abil.MaxWeight := m_Abil.MaxWeight;
  HumData.Abil.WearWeight := m_Abil.WearWeight;
  HumData.Abil.MaxWearWeight := m_Abil.MaxWearWeight;
  HumData.Abil.HandWeight := m_Abil.HandWeight;
  HumData.Abil.MaxHandWeight := m_Abil.MaxHandWeight;

  //HumData.Abil:=m_Abil;
  HumData.Abil.HP := m_WAbil.HP;
  HumData.Abil.MP := m_WAbil.MP;

  HumData.wStatusTimeArr := m_wStatusTimeArr;
  HumData.sHomeMap := m_sHomeMap;
  HumData.wHomeX := m_nHomeX;
  HumData.wHomeY := m_nHomeY;
  HumData.nPKPOINT := m_nPkPoint;
  HumData.BonusAbil := m_BonusAbil; // 08/09
  HumData.nBonusPoint := m_nBonusPoint; // 08/09
  HumData.sStoragePwd := m_sStoragePwd;
  HumData.btCreditPoint := m_btCreditPoint;
  HumData.btReLevel := m_btReLevel;

  HumData.sMasterName := m_sMasterName;
  HumData.boMaster := m_boMaster;
  HumData.sDearName := m_sDearName;

  HumData.nGameGold := m_nGameGold;
  HumData.nGamePoint := m_nGamePoint;

  if m_boAllowGroup then HumData.btAllowGroup := 1
  else HumData.btAllowGroup := 0;
  HumData.btF9 := btB2;
  HumData.btAttatckMode := m_btAttatckMode;
  HumData.btIncHealth := m_nIncHealth;
  HumData.btIncSpell := m_nIncSpell;
  HumData.btIncHealing := m_nIncHealing;
  HumData.btFightZoneDieCount := m_nFightZoneDieCount;
  HumData.sAccount := m_sUserID;
  HumData.btEE := nC4;
  HumData.boLockLogon := m_boLockLogon;
  HumData.wContribution := m_wContribution;
  HumData.btEF := btC8;
  HumData.nHungerStatus := m_nHungerStatus;
  HumData.boAllowGuildReCall := m_boAllowGuildReCall;
  HumData.wGroupRcallTime := m_wGroupRcallTime;
  HumData.dBodyLuck := m_dBodyLuck;
  HumData.boAllowGroupReCall := m_boAllowGroupReCall;
  //HumData.QuestUnitOpen := m_QuestUnitOpen;
  //HumData.QuestUnit := m_QuestUnit;
  HumData.QuestFlag := m_QuestFlag;

  HumItems := @HumanRcd.Data.HumItems;
  HumItems[U_DRESS] := m_UseItems[U_DRESS];
  HumItems[U_WEAPON] := m_UseItems[U_WEAPON];
  HumItems[U_RIGHTHAND] := m_UseItems[U_RIGHTHAND];


  HumItems[U_HELMET] := m_UseItems[U_NECKLACE];
  HumItems[U_NECKLACE] := m_UseItems[U_HELMET];

  HumItems[U_ARMRINGL] := m_UseItems[U_ARMRINGL];
  HumItems[U_ARMRINGR] := m_UseItems[U_ARMRINGR];
  HumItems[U_RINGL] := m_UseItems[U_RINGL];
  HumItems[U_RINGR] := m_UseItems[U_RINGR];

  HumAddItems := @HumanRcd.Data.HumAddItems;
  HumAddItems[U_BUJUK] := m_UseItems[U_BUJUK];
  HumAddItems[U_BELT] := m_UseItems[U_BELT];
  HumAddItems[U_BOOTS] := m_UseItems[U_BOOTS];
  HumAddItems[U_CHARM] := m_UseItems[U_CHARM];

  BagItems := @HumanRcd.Data.BagItems;
  for i := 0 to m_ItemList.Count - 1 do begin
    if i >= MAXBAGITEM then break;
    BagItems[i] := pTUserItem(m_ItemList.Items[i])^;
  end;
  HumMagics := @HumanRcd.Data.HumMagics;
  for i := 0 to m_MagicList.Count - 1 do begin
    if i >= MAXMAGIC then break;
    UserMagic := m_MagicList.Items[i];
    HumMagics[i].wMagIdx := UserMagic.wMagIdx;
    HumMagics[i].btLevel := UserMagic.btLevel;
    HumMagics[i].btKey := UserMagic.btKey;
    HumMagics[i].nTranPoint := UserMagic.nTranPoint;
  end;
  StorageItems := @HumanRcd.Data.StorageItems;
  for i := 0 to m_StorageItemList.Count - 1 do begin
    if i >= MAXBAGITEM then break;
    StorageItems[i] := pTUserItem(m_StorageItemList.Items[i])^;
  end;
end;

function TBaseObject.sub_4C3538: Integer;
var
  nC, n10: Integer;
begin
  Result := 0;
  nC := -1;
  while (nC <> 2) do begin
    n10 := -1;
    while (n10 <> 2) do begin
      if not m_PEnvir.CanWalk(m_nCurrX + nC, m_nCurrY + n10, False) then begin
        if (nC <> 0) or (n10 <> 0) then
          Inc(Result);
      end;
      Inc(n10);
    end;
    Inc(nC);
  end;
end;

procedure TPlayObject.RefRankInfo(nRankNo: Integer; sRankName: string);
begin
  m_nGuildRankNo := nRankNo;
  m_sGuildRankName := sRankName;
  SendMsg(Self, RM_CHANGEGUILDNAME, 0, 0, 0, 0, '');
end;

function TBaseObject.DelBagItem(nIndex: Integer): Boolean;
begin
  Result := False;
  if (nIndex < 0) or (nIndex >= m_ItemList.Count) then Exit;
  if pTUserItem(m_ItemList.Items[nIndex]) <> nil then begin
    DisPose(pTUserItem(m_ItemList.Items[nIndex]));
    m_ItemList.Delete(nIndex);
    Result := True;
  end;
end;

function TBaseObject.DelBagItem(nItemIndex: Integer;
  sItemName: string): Boolean;
var
  i: Integer;
  UserItem: pTUserItem;
begin
  Result := False;
  for i := m_ItemList.Count - 1 downto 0 do begin
    if m_ItemList.Count <= 0 then break;
    UserItem := m_ItemList.Items[i];
    if (UserItem.MakeIndex = nItemIndex) and
      (CompareText(UserEngine.GetStdItemName(UserItem.wIndex), sItemName) = 0) then begin
      DisPose(UserItem);
      m_ItemList.Delete(i);
      Result := True;
      break;
    end;
  end;
  if Result then WeightChanged();
end;

function TBaseObject.DelBagItem(UserItem: pTUserItem): Boolean;
var
  i: Integer;
  Item: pTUserItem;
begin
  Result := False;
  for i := m_ItemList.Count - 1 downto 0 do begin
    if m_ItemList.Count <= 0 then break;
    Item := m_ItemList.Items[i];
    if Item = nil then Continue;
    if UserItem.wIndex = Item.wIndex then begin
      DisPose(Item);
      m_ItemList.Delete(i);
      Result := True;
      break;
    end;
  end;
  if Result then WeightChanged();
end;

procedure TPlayObject.GetOldAbil(var OAbility: TOAbility);
begin
  {
  FillChar(OAbility, SizeOf(TOAbility), #0);
  OAbility.Level:=m_WAbil.Level;
  OAbility.AC:=MakeWord(LoWord(m_WAbil.AC),HiWord(m_WAbil.AC));
  OAbility.MAC:=MakeWord(LoWord(m_WAbil.MAC),HiWord(m_WAbil.MAC));
  OAbility.DC:=MakeWord(LoWord(m_WAbil.DC),HiWord(m_WAbil.DC));
  OAbility.MC:=MakeWord(LoWord(m_WAbil.MC),HiWord(m_WAbil.MC));
  OAbility.SC:=MakeWord(LoWord(m_WAbil.SC),HiWord(m_WAbil.SC));
  OAbility.HP:=m_WAbil.HP;
  OAbility.MP:=m_WAbil.MP;
  OAbility.MaxHP:=m_WAbil.MaxHP;
  OAbility.MaxMP:=m_WAbil.MaxMP;
  OAbility.Exp:=m_WAbil.Exp;
  OAbility.MaxExp:=m_WAbil.MaxExp;
  OAbility.Weight:=m_WAbil.Weight;
  OAbility.MaxWeight:=m_WAbil.MaxWeight;
  OAbility.WearWeight:=m_WAbil.WearWeight;
  OAbility.MaxWearWeight:=_MAX(High(Byte),m_WAbil.MaxWearWeight);
  OAbility.HandWeight:=m_WAbil.HandWeight;
  OAbility.MaxHandWeight:=_MAX(High(Byte),m_WAbil.MaxHandWeight);
  }
  FillChar(OAbility, SizeOf(TOAbility), #0);
  OAbility.Level := m_WAbil.Level;
  OAbility.AC := MakeWord(_MIN(High(Byte), LoWord(m_WAbil.AC)), _MIN(High(Byte), HiWord(m_WAbil.AC)));
  OAbility.MAC := MakeWord(_MIN(High(Byte), LoWord(m_WAbil.MAC)), _MIN(High(Byte), HiWord(m_WAbil.MAC)));
  OAbility.DC := MakeWord(_MIN(High(Byte), LoWord(m_WAbil.DC)), _MIN(High(Byte), HiWord(m_WAbil.DC)));
  OAbility.MC := MakeWord(_MIN(High(Byte), LoWord(m_WAbil.MC)), _MIN(High(Byte), HiWord(m_WAbil.MC)));
  OAbility.SC := MakeWord(_MIN(High(Byte), LoWord(m_WAbil.SC)), _MIN(High(Byte), HiWord(m_WAbil.SC)));
  OAbility.HP := m_WAbil.HP;
  OAbility.MP := m_WAbil.MP;
  OAbility.MaxHP := m_WAbil.MaxHP;
  OAbility.MaxMP := m_WAbil.MaxMP;
  OAbility.Exp := m_WAbil.Exp;
  OAbility.MaxExp := m_WAbil.MaxExp;
  OAbility.Weight := m_WAbil.Weight;
  OAbility.MaxWeight := m_WAbil.MaxWeight;
  OAbility.WearWeight := _MIN(High(Byte), m_WAbil.WearWeight);
  OAbility.MaxWearWeight := _MIN(High(Byte), m_WAbil.MaxWearWeight);
  OAbility.HandWeight := _MIN(High(Byte), m_WAbil.HandWeight);
  OAbility.MaxHandWeight := _MIN(High(Byte), m_WAbil.MaxHandWeight);
end;

function TPlayObject.GetHitMsgCount: Integer;
var
  i: Integer;
  SendMessage: pTSendMessage;
begin
  Result := 0;
  try
    EnterCriticalSection(ProcessMsgCriticalSection);
    for i := 0 to m_MsgList.Count - 1 do begin
      SendMessage := m_MsgList.Items[i];
      if (SendMessage.wIdent = CM_HIT) or
        (SendMessage.wIdent = CM_HEAVYHIT) or
        (SendMessage.wIdent = CM_BIGHIT) or
        (SendMessage.wIdent = CM_POWERHIT) or
        (SendMessage.wIdent = CM_LONGHIT) or
        (SendMessage.wIdent = CM_WIDEHIT) or
        (SendMessage.wIdent = CM_CRSHIT) or
        (SendMessage.wIdent = CM_FIREHIT) then begin
        Inc(Result);
      end;
    end;
  finally
    LeaveCriticalSection(ProcessMsgCriticalSection);
  end;
end;

function TPlayObject.GetSpellMsgCount: Integer;
var
  i: Integer;
  SendMessage: pTSendMessage;
begin
  Result := 0;
  try
    EnterCriticalSection(ProcessMsgCriticalSection);
    for i := 0 to m_MsgList.Count - 1 do begin
      SendMessage := m_MsgList.Items[i];
      if (SendMessage.wIdent = CM_SPELL) then begin
        Inc(Result);
      end;
    end;
  finally
    LeaveCriticalSection(ProcessMsgCriticalSection);
  end;
end;

function TPlayObject.GetRunMsgCount: Integer;
var
  i: Integer;
  SendMessage: pTSendMessage;
begin
  Result := 0;
  try
    EnterCriticalSection(ProcessMsgCriticalSection);
    for i := 0 to m_MsgList.Count - 1 do begin
      SendMessage := m_MsgList.Items[i];
      if (SendMessage.wIdent = CM_RUN) then begin
        Inc(Result);
      end;
    end;
  finally
    LeaveCriticalSection(ProcessMsgCriticalSection);
  end;
end;

function TPlayObject.GetWalkMsgCount: Integer;
var
  i: Integer;
  SendMessage: pTSendMessage;
begin
  Result := 0;
  try
    EnterCriticalSection(ProcessMsgCriticalSection);
    for i := 0 to m_MsgList.Count - 1 do begin
      SendMessage := m_MsgList.Items[i];
      if (SendMessage.wIdent = CM_WALK) then begin
        Inc(Result);
      end;
    end;
  finally
    LeaveCriticalSection(ProcessMsgCriticalSection);
  end;
end;

function TPlayObject.GetTurnMsgCount: Integer;
var
  i: Integer;
  SendMessage: pTSendMessage;
begin
  Result := 0;
  try
    EnterCriticalSection(ProcessMsgCriticalSection);
    for i := 0 to m_MsgList.Count - 1 do begin
      SendMessage := m_MsgList.Items[i];
      if (SendMessage.wIdent = CM_TURN) then begin
        Inc(Result);
      end;
    end;
  finally
    LeaveCriticalSection(ProcessMsgCriticalSection);
  end;
end;

function TPlayObject.GetSiteDownMsgCount: Integer;
var
  i: Integer;
  SendMessage: pTSendMessage;
begin
  Result := 0;
  EnterCriticalSection(ProcessMsgCriticalSection);
  try
    for i := 0 to m_MsgList.Count - 1 do begin
      SendMessage := m_MsgList.Items[i];
      if (SendMessage.wIdent = CM_SITDOWN) then begin
        Inc(Result);
      end;
    end;
  finally
    LeaveCriticalSection(ProcessMsgCriticalSection);
  end;
end;

function TPlayObject.CheckActionStatus(wIdent: Word; var dwDelayTime: LongWord): Boolean;
var
  dwCheckTime: LongWord;
  dwCurrTick: LongWord;
  dwActionIntervalTime: LongWord;
begin
  Result := False;
  dwDelayTime := 0;
  //检查人物弯腰停留时间
  if not g_Config.boDisableStruck then begin
    dwCheckTime := GetTickCount - m_dwStruckTick;
    if g_Config.dwStruckTime > dwCheckTime then begin
      dwDelayTime := g_Config.dwStruckTime - dwCheckTime;
      m_btOldDir := m_btDirection;
      Exit;
    end;
  end;

  //检查二个不同操作之间所需间隔时间
  dwCheckTime := GetTickCount - m_dwActionTick;

  if m_boTestSpeedMode then begin
    SysMsg('间隔: ' + IntToStr(dwCheckTime), c_Blue, t_Notice);
  end;

  if m_wOldIdent = wIdent then begin //当二次操作一样时，则将 boFirst 设置为 真 ，退出由调用函数本身检查二个相同操作之间的间隔时间
    Result := True;
    Exit;
  end;
  if not g_Config.boControlActionInterval then begin
    Result := True;
    Exit;
  end;

  dwActionIntervalTime := m_dwActionIntervalTime;
  case wIdent of
    CM_LONGHIT: begin
        //跑位刺杀
        if g_Config.boControlRunLongHit and (m_wOldIdent = CM_RUN) and (m_btOldDir <> m_btDirection) then begin
          dwActionIntervalTime := m_dwRunLongHitIntervalTime;
        end;
      end;
    CM_HIT: begin
        //走位攻击
        if g_Config.boControlWalkHit and (m_wOldIdent = CM_WALK) and (m_btOldDir <> m_btDirection) then begin
          dwActionIntervalTime := m_dwWalkHitIntervalTime;
        end;
        //跑位攻击
        if g_Config.boControlRunHit and (m_wOldIdent = CM_RUN) and (m_btOldDir <> m_btDirection) then begin
          dwActionIntervalTime := m_dwRunHitIntervalTime;
        end;
      end;
    CM_RUN: begin
        //跑位刺杀
        if g_Config.boControlRunLongHit and (m_wOldIdent = CM_LONGHIT) and (m_btOldDir <> m_btDirection) then begin
          dwActionIntervalTime := m_dwRunLongHitIntervalTime;
        end;
        //跑位攻击
        if g_Config.boControlRunHit and (m_wOldIdent = CM_HIT) and (m_btOldDir <> m_btDirection) then begin
          dwActionIntervalTime := m_dwRunHitIntervalTime;
        end;
        //跑位魔法
        if g_Config.boControlRunMagic and (m_wOldIdent = CM_SPELL) and (m_btOldDir <> m_btDirection) then begin
          dwActionIntervalTime := m_dwRunMagicIntervalTime;
        end;
      end;
    CM_WALK: begin
        //走位攻击
        if g_Config.boControlWalkHit and (m_wOldIdent = CM_HIT) and (m_btOldDir <> m_btDirection) then begin
          dwActionIntervalTime := m_dwWalkHitIntervalTime;
        end;
        //跑位刺杀
        if g_Config.boControlRunLongHit and (m_wOldIdent = CM_LONGHIT) and (m_btOldDir <> m_btDirection) then begin
          dwActionIntervalTime := m_dwRunLongHitIntervalTime;
        end;
      end;
    CM_SPELL: begin
        //跑位魔法
        if g_Config.boControlRunMagic and (m_wOldIdent = CM_RUN) and (m_btOldDir <> m_btDirection) then begin
          dwActionIntervalTime := m_dwRunMagicIntervalTime;
        end;
      end;
  end;

  //将几个攻击操作合并成一个攻击操作代码
  if (wIdent = CM_HIT) or
    (wIdent = CM_HEAVYHIT) or
    (wIdent = CM_BIGHIT) or
    (wIdent = CM_POWERHIT) or
    //     (wIdent = CM_LONGHIT) or

  (wIdent = CM_WIDEHIT) or
    (wIdent = CM_CRSHIT) or
    (wIdent = CM_FIREHIT) then begin

    wIdent := CM_HIT;
  end;

  if dwCheckTime >= dwActionIntervalTime then begin
    m_dwActionTick := GetTickCount();
    Result := True;
  end else begin
    dwDelayTime := dwActionIntervalTime - dwCheckTime;
  end;
  m_wOldIdent := wIdent;
  m_btOldDir := m_btDirection;
  {
  dwCheckTime:=GetTickCount - m_dwActionTick;
  if dwCheckTime >= m_dwActionTime then begin
    m_dwActionTick:=GetTickCount();
    m_wOldIdent:=wIdent;
    Result:=True;
  end else begin
    dwDelayTime:=m_dwActionTime - dwCheckTime;
//    m_dwActionTime:=m_dwActionTime + 20;
  end;
  }
end;

procedure TPlayObject.SetScriptLabel(sLabel: string);
begin
  m_CanJmpScriptLableList.Clear;
  m_CanJmpScriptLableList.Add(sLabel);
end;
//取得当前脚本可以跳转的标签
procedure TPlayObject.GetScriptLabel(sMsg: string);
var
  sText: string;
  sData: string;
  sCmdStr, sLabel: string;
begin
  m_CanJmpScriptLableList.Clear;
  while (True) do begin
    if sMsg = '' then break;
    sMsg := GetValidStr3(sMsg, sText, ['\']);
    if sText <> '' then begin
      sData := '';
      while (Pos('<', sText) > 0) and (Pos('>', sText) > 0) and (sText <> '') do begin
        if sText[1] <> '<' then begin
          sText := '<' + GetValidStr3(sText, sData, ['<']);
        end;
        sText := ArrestStringEx(sText, '<', '>', sCmdStr);
        sLabel := GetValidStr3(sCmdStr, sCmdStr, ['/']);
        if sLabel <> '' then
          m_CanJmpScriptLableList.Add(sLabel);
      end;
    end;
  end;
end;

function TPlayObject.LableIsCanJmp(sLabel: string): Boolean;
var
  i: Integer;
begin
  Result := False;
  if CompareText(sLabel, '@main') = 0 then begin
    Result := True;
    Exit;
  end;
  for i := 0 to m_CanJmpScriptLableList.Count - 1 do begin
    if CompareText(sLabel, m_CanJmpScriptLableList.Strings[i]) = 0 then begin
      Result := True;
      break;
    end;
  end;
  if CompareText(sLabel, m_sPlayDiceLabel) = 0 then begin
    m_sPlayDiceLabel := '';
    Result := True;
    Exit;
  end;
end;

procedure TPlayObject.RecalcAbilitys;
begin
  inherited;
  RecalcAdjusBonus();
end;

procedure TPlayObject.ClearViewRange;
var
  i: Integer;
begin
  try
    m_VisibleHumanList.Clear;
    for i := 0 to m_VisibleItems.Count - 1 do begin
      if pTVisibleMapItem(m_VisibleItems.Items[i]) <> nil then
        DisPose(pTVisibleMapItem(m_VisibleItems.Items[i]));
    end;
    m_VisibleItems.Clear;
    for i := 0 to m_VisibleActors.Count - 1 do begin
      if pTVisibleBaseObject(m_VisibleActors.Items[i]) <> nil then
        DisPose(pTVisibleBaseObject(m_VisibleActors.Items[i]));
    end;
    m_VisibleActors.Clear; //清除人物列表
    m_VisibleEvents.Clear;
  except
    KickException();
  end;
end;

procedure TPlayObject.SearchViewRange;
var
  i: Integer;
  nStartX: Integer;
  nEndX: Integer;
  nStartY: Integer;
  nEndY: Integer;
  n18: Integer;
  n1C: Integer;
  nIdx: Integer;
  n24: Integer;
  MapCellInfo: pTMapCellinfo;
  OSObject: pTOSObject;
  BaseObject: TBaseObject;
  MapItem: PTMapItem;
  MapEvent: TEvent;
  VisibleBaseObject: pTVisibleBaseObject;
  VisibleMapItem: pTVisibleMapItem;
  nCheckCode: Integer;
  btType: Byte;
  nVisibleFlag: Integer;
resourcestring
  sExceptionMsg1 = '[Exception] TPlayObject::SearchViewRange Code:%d';
  sExceptionMsg2 = '[Exception] TPlayObject::SearchViewRange 1-%d %s %s %d %d %d';
begin
  if m_boNotOnlineAddExp then Exit; //2006-10-22 叶随风飘 修改 离线挂机不搜索
  n24 := 0;
  try
    nCheckCode := 2;
    for i := 0 to m_VisibleItems.Count - 1 do begin
      pTVisibleMapItem(m_VisibleItems.Items[i]).nVisibleFlag := 0;
    end;
    nCheckCode := 3;
    for i := 0 to m_VisibleEvents.Count - 1 do begin
      TEvent(m_VisibleEvents.Items[i]).nVisibleFlag := 0;
    end;
    nCheckCode := 4;
    for i := 0 to m_VisibleActors.Count - 1 do begin
      pTVisibleBaseObject(m_VisibleActors.Items[i]).nVisibleFlag := 0;
    end;
    nCheckCode := 5;
  except
    MainOutMessage(format(sExceptionMsg1, [nCheckCode]));
    KickException();
  end;
  nCheckCode := 6;

  nStartX := m_nCurrX - m_nViewRange;
  nEndX := m_nCurrX + m_nViewRange;
  nStartY := m_nCurrY - m_nViewRange;
  nEndY := m_nCurrY + m_nViewRange;
  try
    nCheckCode := 7;
    for n18 := nStartX to nEndX do begin
      nCheckCode := 8;
      for n1C := nStartY to nEndY do begin
        nCheckCode := 9;
        if m_PEnvir.GetMapCellInfo(n18, n1C, MapCellInfo) and (MapCellInfo.ObjList <> nil) then begin
          nCheckCode := 10;
          n24 := 1;
          nIdx := 0;
          while (True) do begin
            nCheckCode := 11;
            if (MapCellInfo.ObjList <> nil) and (MapCellInfo.ObjList.Count <= 0) then begin //200-11-1 增加
              FreeAndNil(MapCellInfo.ObjList);
              break;
            end;
            if MapCellInfo.ObjList.Count <= nIdx then break;
            OSObject := MapCellInfo.ObjList.Items[nIdx];
            nCheckCode := 12;
            if OSObject <> nil then begin
              nCheckCode := 13;
              try
                btType := OSObject.btType; //2006-10-14 防止内存出错
              except
                MapCellInfo.ObjList.Delete(nIdx);
                Continue;
              end;
              if OSObject.btType = OS_MOVINGOBJECT then begin
                nCheckCode := 14;
                if (GetTickCount - OSObject.dwAddTime) >= 60 * 1000 then begin
                  DisPoseAndNil(OSObject);
                  MapCellInfo.ObjList.Delete(nIdx);
                  if MapCellInfo.ObjList.Count <= 0 then begin
                    FreeAndNil(MapCellInfo.ObjList);
                    break;
                  end;
                  Continue;
                end;
                nCheckCode := 15;
                BaseObject := TBaseObject(OSObject.CellObj);
                if BaseObject <> nil then begin
                  nCheckCode := 16;
                  if not BaseObject.m_boGhost and not BaseObject.m_boFixedHideMode and not BaseObject.m_boObMode then begin
                    nCheckCode := 17;
                    if (m_btRaceServer < RC_ANIMAL) or
                      (m_Master <> nil) or
                      m_boCrazyMode or
                      m_boWantRefMsg or
                      ((BaseObject.m_Master <> nil) and (abs(BaseObject.m_nCurrX - m_nCurrX) <= 3) and (abs(BaseObject.m_nCurrY - m_nCurrY) <= 3)) or
                      (BaseObject.m_btRaceServer = RC_PLAYOBJECT) then begin
                      nCheckCode := 18;
                      UpdateVisibleGay(BaseObject);
                      nCheckCode := 19;
                    end;
                  end;
                end; //if BaseObject <> nil then begin
              end; //if OSObject.btType = OS_MOVINGOBJECT then begin
              nCheckCode := 20;
              if m_btRaceServer = RC_PLAYOBJECT then begin
                if (OSObject <> nil) and (OSObject.btType = OS_ITEMOBJECT) then begin
                  nCheckCode := 21;
                  if (GetTickCount - OSObject.dwAddTime) > g_Config.dwClearDropOnFloorItemTime {60 * 60 * 1000} then begin
                    DisPoseAndNil(pTMapItem(OSObject.CellObj)); //防止占用内存不释放现象
                    DisPoseAndNil(OSObject);
                    MapCellInfo.ObjList.Delete(nIdx);
                    if MapCellInfo.ObjList.Count <= 0 then begin
                      FreeAndNil(MapCellInfo.ObjList);
                      break;
                    end;
                    Continue;
                  end;
                  MapItem := pTMapItem(OSObject.CellObj);
                  nCheckCode := 28;
                  UpdateVisibleItem(n18, n1C, MapItem);
                  if (MapItem.OfBaseObject <> nil) or (MapItem.DropBaseObject <> nil) then begin
                    nCheckCode := 29;
                    if (GetTickCount - MapItem.dwCanPickUpTick) > g_Config.dwFloorItemCanPickUpTime {2 * 60 * 1000} then begin
                      nCheckCode := 30;
                      MapItem.OfBaseObject := nil;
                      MapItem.DropBaseObject := nil;
                    end else begin
                      nCheckCode := 31;
                      if TBaseObject(MapItem.OfBaseObject) <> nil then begin
                        nCheckCode := 32;
                        if TBaseObject(MapItem.OfBaseObject).m_boGhost then MapItem.OfBaseObject := nil;
                      end;
                      nCheckCode := 33;
                      if TBaseObject(MapItem.DropBaseObject) <> nil then begin
                        nCheckCode := 34;
                        if TBaseObject(MapItem.DropBaseObject).m_boGhost then MapItem.DropBaseObject := nil;
                      end;
                      nCheckCode := 35;
                    end;
                  end;
                end; //if OSObject.btType = OS_ITEMOBJECT then begin
                nCheckCode := 36;
                if (OSObject <> nil) and (OSObject.btType = OS_EVENTOBJECT) then begin
                  nCheckCode := 37;
                  MapEvent := TEvent(OSObject.CellObj);
                  if MapEvent.m_boVisible then begin
                    nCheckCode := 38;
                    UpdateVisibleEvent(n18, n1C, MapEvent);
                  end;
                  nCheckCode := 39;
                end;
              end
            end; //if OSObject <> nil then begin
            Inc(nIdx);
          end; //while (True) do begin
        end;
      end; //for n1C:= n10 to n14  do begin
    end; //for n18:= n8 to nC do begin
  except
    on E: Exception do begin
      MainOutMessage(format(sExceptionMsg2, [n24, m_sCharName, m_sMapName, m_nCurrX, m_nCurrY, nCheckCode]));
      {
      MainOutMessage(m_sCharName + ',' +
                     m_sMapName + ',' +
                     IntToStr(m_nCurrX) + ',' +
                     IntToStr(m_nCurrY) + ',' +
                     ' SearchViewRange 1-' +
                     IntToStr(n24));
      }
      MainOutMessage(E.Message);
      KickException();
    end;
  end;
  nCheckCode := 40;
  n24 := 2;
  try
    n18 := 0;
    while (True) do begin
      if m_VisibleActors.Count <= n18 then break;
      nCheckCode := 41;
      VisibleBaseObject := m_VisibleActors.Items[n18];
      nCheckCode := 42;
      nCheckCode := 43;
      try
        nVisibleFlag := VisibleBaseObject.nVisibleFlag; //2006-10-14 防止内存出错
      except
        m_VisibleActors.Delete(n18);
        Continue;
      end;
      if VisibleBaseObject.nVisibleFlag = 0 then begin
        if m_btRaceServer = RC_PLAYOBJECT then begin
          nCheckCode := 44;
          BaseObject := TBaseObject(VisibleBaseObject.BaseObject);
          nCheckCode := 45;
          if not BaseObject.m_boFixedHideMode and (not BaseObject.m_boGhost) then begin //01/21 修改防止人物退出时发送重复的消息占用带宽，人物进入隐身模式时人物不消失问题
            nCheckCode := 46;
            SendMsg(BaseObject, RM_DISAPPEAR, 0, 0, 0, 0, '');
          end;
          nCheckCode := 47;
        end;
        m_VisibleActors.Delete(n18);
        nCheckCode := 48;
        DisPoseAndNil(VisibleBaseObject);
        nCheckCode := 49;
        Continue;
      end;
      nCheckCode := 50;
      if (m_btRaceServer = RC_PLAYOBJECT) and (VisibleBaseObject.nVisibleFlag = 2) then begin
        nCheckCode := 51;
        BaseObject := TBaseObject(VisibleBaseObject.BaseObject);
        nCheckCode := 52;
        if (BaseObject <> nil) and (BaseObject <> Self) then begin
          nCheckCode := 53;
          if BaseObject.m_boDeath then begin
            nCheckCode := 54;
            if BaseObject.m_boSkeleton then begin
              nCheckCode := 55;
              SendMsg(BaseObject, RM_SKELETON, BaseObject.m_btDirection, BaseObject.m_nCurrX, BaseObject.m_nCurrY, 0, '');
              nCheckCode := 56;
            end else begin
              nCheckCode := 57;
              SendMsg(BaseObject, RM_DEATH, BaseObject.m_btDirection, BaseObject.m_nCurrX, BaseObject.m_nCurrY, 0, '');
              nCheckCode := 58;
            end;
          end else begin
            nCheckCode := 59;
            SendMsg(BaseObject, RM_TURN, BaseObject.m_btDirection, BaseObject.m_nCurrX, BaseObject.m_nCurrY, 0, BaseObject.GetShowName);
            nCheckCode := 60;
          end;
        end;
      end;
      Inc(n18);
    end;
  except
    on E: Exception do begin
      MainOutMessage(format(sExceptionMsg2, [n24, m_sCharName, m_sMapName, m_nCurrX, m_nCurrY, nCheckCode]));
      {MainOutMessage(m_sCharName + ',' +
                     m_sMapName + ',' +
                     IntToStr(m_nCurrX) + ',' +
                     IntToStr(m_nCurrY) + ',' +
                     ' SearchViewRange 2');}
      KickException();
    end;
  end;
  try
    //    if (m_btRaceServer = RC_PLAYOBJECT) then begin
    i := 0;
    while (True) do begin
      if m_VisibleItems.Count <= i then break;
      VisibleMapItem := m_VisibleItems.Items[i];
      nCheckCode := 100;
      try
        nVisibleFlag := VisibleMapItem.nVisibleFlag; //2006-10-14 防止内存出错
      except
        m_VisibleItems.Delete(i);
        Continue;
      end;
      nCheckCode := 101;
      if VisibleMapItem.nVisibleFlag = 0 then begin
        SendMsg(Self, RM_ITEMHIDE, 0, Integer(VisibleMapItem.MapItem), VisibleMapItem.nX, VisibleMapItem.nY, '');
        m_VisibleItems.Delete(i);
        try
          DisPoseAndNil(VisibleMapItem);
        except
          VisibleMapItem := nil;
        end;
        Continue;
      end;
      nCheckCode := 102;
      if VisibleMapItem.nVisibleFlag = 2 then begin
        SendMsg(Self, RM_ITEMSHOW, VisibleMapItem.wLooks, Integer(VisibleMapItem.MapItem), VisibleMapItem.nX, VisibleMapItem.nY, VisibleMapItem.sName);
      end;
      Inc(i);
    end;
    i := 0;
    while (True) do begin
      if m_VisibleEvents.Count <= i then break;
      nCheckCode := 103;
      MapEvent := m_VisibleEvents.Items[i];
      nCheckCode := 104;
      try
        nVisibleFlag := MapEvent.nVisibleFlag; //2006-10-14 防止内存出错
      except
        m_VisibleEvents.Delete(i);
        Continue;
      end;
      nCheckCode := 105;
      if MapEvent.nVisibleFlag = 0 then begin
        SendMsg(Self, RM_HIDEEVENT, 0, Integer(MapEvent), MapEvent.m_nX, MapEvent.m_nY, '');
        m_VisibleEvents.Delete(i);
        Continue;
      end;
      nCheckCode := 106;
      if MapEvent.nVisibleFlag = 2 then begin
        SendMsg(Self, RM_SHOWEVENT, MapEvent.m_nEventType, Integer(MapEvent), MakeLong(MapEvent.m_nX, MapEvent.m_nEventParam), MapEvent.m_nY, '');
      end;
      nCheckCode := 107;
      Inc(i);
    end;
  except
    MainOutMessage(m_sCharName + ',' +
      m_sMapName + ',' +
      IntToStr(m_nCurrX) + ',' +
      IntToStr(m_nCurrY) + ',' +
      ' SearchViewRange 3 CheckCode:' + IntToStr(nCheckCode));
    KickException();
  end;
end;



{
function TPlayObject.GetShowName: String;
var
  sShowName:String;
  sGuildName:String;
  sDearName:String;
  sMasterName:String;
begin
try
  //sShowName:=m_sCharName;
  if m_MyGuild <> nil then begin
    if UserCastle.IsMasterGuild(TGuild(m_MyGuild)) then begin
      sGuildName:='(' + UserCastle.sName + ')' + TGuild(m_MyGuild).sGuildName + '[' + m_sGuildRankName + ']';
    end else begin
      if g_boShowGuildName or (UserCastle.boUnderWar and (m_boInFreePKArea or UserCastle.IsCastleWarArea(m_PEnvir,m_nCurrX,m_nCurrY))) then begin
        sGuildName:= TGuild(m_MyGuild).sGuildName + '[' + m_sGuildRankName + ']';
      end;
    end;
  end;
  if m_sMasterName <> '' then begin
    if m_boMaster then begin
      sMasterName:= m_sMasterName + '的师傅';
    end else begin
      sMasterName:= m_sMasterName + '的徒弟';
    end;
  end;
  if m_sDearName <> '' then begin
    if m_btGender = 0 then begin
      sDearName:= m_sDearName + '的老公';
    end else begin
      sDearName:= m_sDearName + '的老婆';
    end;
  end;
  sShowName:=sGuildName;
  sShowName:= sShowName + '\' + m_sCharName;
  if sDearName <> '' then begin
    sShowName:= sShowName + '\' + sDearName;
  end;
  if sMasterName <> '' then begin
    sShowName:= sShowName + '\' + sMasterName;
  end;

  Result:=sShowName;
except
  on e: Exception do begin
    MainOutMessage('[Exception] TPlayObject.GetShowName');
    MainOutMessage(E.Message);
  end;
end;
end;
}
function TPlayObject.GetShowName: string;
var
  sShowName: string;
  sCharName: string;
  sGuildName: string;
  sDearName: string;
  sMasterName: string;
  Castle: TUserCastle;
resourcestring
  sExceptionMsg = '[Exception] TPlayObject::GetShowName';
begin
  try
    //sShowName:=m_sCharName;
    sCharName := '';
    sGuildName := '';
    sDearName := '';
    sMasterName := '';
    if m_MyGuild <> nil then begin
      Castle := g_CastleManager.IsCastleMember(Self);
      {
      if UserCastle.IsMasterGuild(TGuild(m_MyGuild)) then begin
        sGuildName:=AnsiReplaceText(g_sCastleGuildName,'%castlename',UserCastle.m_sName);
        sGuildName:=AnsiReplaceText(sGuildName,'%guildname',TGuild(m_MyGuild).sGuildName);
        sGuildName:=AnsiReplaceText(sGuildName,'%rankname',m_sGuildRankName);
        }
      if Castle <> nil then begin
        sGuildName := AnsiReplaceText(g_sCastleGuildName, '%castlename', Castle.m_sName);
        sGuildName := AnsiReplaceText(sGuildName, '%guildname', TGUild(m_MyGuild).sGuildName);
        sGuildName := AnsiReplaceText(sGuildName, '%rankname', m_sGuildRankName);
      end else begin
        Castle := g_CastleManager.InCastleWarArea(Self);
        //01/25 多城堡
        //if g_Config.boShowGuildName or (UserCastle.m_boUnderWar and (m_boInFreePKArea or UserCastle.InCastleWarArea(m_PEnvir,m_nCurrX,m_nCurrY))) then begin
        if g_Config.boShowGuildName or (((Castle <> nil) and Castle.m_boUnderWar) or m_boInFreePKArea) then begin
          sGuildName := AnsiReplaceText(g_sNoCastleGuildName, '%guildname', TGUild(m_MyGuild).sGuildName);
          sGuildName := AnsiReplaceText(sGuildName, '%rankname', m_sGuildRankName);
        end;
      end;
    end;
    if not g_Config.boShowRankLevelName then begin
      if m_btReLevel > 0 then begin
        case m_btJob of
          0: sCharName := AnsiReplaceText(g_sWarrReNewName, '%chrname', m_sCharName);
          1: sCharName := AnsiReplaceText(g_sWizardReNewName, '%chrname', m_sCharName);
          2: sCharName := AnsiReplaceText(g_sTaosReNewName, '%chrname', m_sCharName);
        end;
      end else begin
        sCharName := m_sCharName;
      end;
    end else begin
      sCharName := format(m_sRankLevelName, [m_sCharName]);
    end;

    if m_sMasterName <> '' then begin
      if m_boMaster then begin
        //sMasterName:= m_sMasterName + '的师傅';
        sMasterName := format(g_sMasterName, [m_sMasterName]);
      end else begin
        //sMasterName:= m_sMasterName + '的徒弟';
        sMasterName := format(g_sNoMasterName, [m_sMasterName]);
      end;
    end;
    if m_sDearName <> '' then begin
      if m_btGender = 0 then begin
        //sDearName:= m_sDearName + '的老公';
        sDearName := format(g_sManDearName, [m_sDearName]);
      end else begin
        sDearName := format(g_sWoManDearName, [m_sDearName]); // + '的老婆';
      end;
    end;
    sShowName := AnsiReplaceText(g_sHumanShowName, '%chrname', sCharName);
    sShowName := AnsiReplaceText(sShowName, '%guildname', sGuildName);
    sShowName := AnsiReplaceText(sShowName, '%dearname', sDearName);
    sShowName := AnsiReplaceText(sShowName, '%mastername', sMasterName);
    Result := sShowName;
  except
    on E: Exception do begin
      MainOutMessage(sExceptionMsg);
      MainOutMessage(E.Message);
    end;
  end;
end;

function TPlayObject.CheckItemsNeed(StdItem: pTStdItem): Boolean;
var
  Castle: TUserCastle;
begin
  Result := True;
  Castle := g_CastleManager.IsCastleMember(Self);
  case StdItem.Need of
    6: begin
        if (m_MyGuild = nil) then begin
          Result := False;
        end;
      end;
    60: begin
        if (m_MyGuild = nil) or (m_nGuildRankNo <> 1) then begin
          Result := False;
        end;
      end;
    7: begin
        //if (m_MyGuild = nil) or (UserCastle.m_MasterGuild <> m_MyGuild) then begin
        if Castle = nil then begin
          Result := False;
        end;
      end;
    70: begin
        //if (m_MyGuild = nil) or (UserCastle.m_MasterGuild <> m_MyGuild) or (m_nGuildRankNo <> 1) then begin
        if (Castle = nil) or (m_nGuildRankNo <> 1) then begin
          Result := False;
        end;
      end;
    8: begin
        if m_nMemberType = 0 then Result := False;
      end;
    81: begin
        if (m_nMemberType <> LoWord(StdItem.NeedLevel)) or (m_nMemberLevel < HiWord(StdItem.NeedLevel)) then
          Result := False;
      end;
    82: begin
        if (m_nMemberType < LoWord(StdItem.NeedLevel)) or (m_nMemberLevel < HiWord(StdItem.NeedLevel)) then
          Result := False;
      end;
  end;
end;

procedure TPlayObject.CheckMarry;
var
  boIsfound: Boolean;
  sUnMarryFileName: string;
  LoadList: TStringList;
  i: Integer;
  sSayMsg: string;
begin
  boIsfound := False;
  sUnMarryFileName := g_Config.sEnvirDir + 'UnMarry.txt';
  if FileExists(sUnMarryFileName) then begin
    LoadList := TStringList.Create;
    LoadList.LoadFromFile(sUnMarryFileName);
    if LoadList.Count > 0 then begin
      for i := LoadList.Count - 1 downto 0 do begin
        if LoadList.Count <= 0 then break;
        if CompareText(LoadList.Strings[i], m_sCharName) = 0 then begin
          LoadList.Delete(i);
          boIsfound := True;
          break;
        end;
      end;
    end;
    LoadList.SaveToFile(sUnMarryFileName);
    LoadList.Free;
  end;
  if boIsfound then begin
    if m_btGender = 0 then begin
      sSayMsg := AnsiReplaceText(g_sfUnMarryManLoginMsg, '%d', m_sDearName);
      sSayMsg := AnsiReplaceText(sSayMsg, '%s', m_sDearName);
    end else begin
      sSayMsg := AnsiReplaceText(g_sfUnMarryWoManLoginMsg, '%d', m_sCharName);
      sSayMsg := AnsiReplaceText(sSayMsg, '%s', m_sCharName);
    end;
    SysMsg(sSayMsg, c_Red, t_Hint);
    m_sDearName := '';
    RefShowName;
  end;
  m_DearHuman := UserEngine.GetPlayObject(m_sDearName);
  if m_DearHuman <> nil then begin
    m_DearHuman.m_DearHuman := Self;
    if m_btGender = 0 then begin
      sSayMsg := AnsiReplaceText(g_sManLoginDearOnlineSelfMsg, '%d', m_sDearName);
      sSayMsg := AnsiReplaceText(sSayMsg, '%s', m_sCharName);
      sSayMsg := AnsiReplaceText(sSayMsg, '%m', m_DearHuman.m_PEnvir.sMapDesc);
      sSayMsg := AnsiReplaceText(sSayMsg, '%x', IntToStr(m_DearHuman.m_nCurrX));
      sSayMsg := AnsiReplaceText(sSayMsg, '%y', IntToStr(m_DearHuman.m_nCurrY));
      SysMsg(sSayMsg, c_Blue, t_Hint);

      sSayMsg := AnsiReplaceText(g_sManLoginDearOnlineDearMsg, '%d', m_sDearName);
      sSayMsg := AnsiReplaceText(sSayMsg, '%s', m_sCharName);
      sSayMsg := AnsiReplaceText(sSayMsg, '%m', m_PEnvir.sMapDesc);
      sSayMsg := AnsiReplaceText(sSayMsg, '%x', IntToStr(m_nCurrX));
      sSayMsg := AnsiReplaceText(sSayMsg, '%y', IntToStr(m_nCurrY));
      m_DearHuman.SysMsg(sSayMsg, c_Blue, t_Hint);
    end else begin
      sSayMsg := AnsiReplaceText(g_sWoManLoginDearOnlineSelfMsg, '%d', m_sDearName);
      sSayMsg := AnsiReplaceText(sSayMsg, '%s', m_sCharName);
      sSayMsg := AnsiReplaceText(sSayMsg, '%m', m_DearHuman.m_PEnvir.sMapDesc);
      sSayMsg := AnsiReplaceText(sSayMsg, '%x', IntToStr(m_DearHuman.m_nCurrX));
      sSayMsg := AnsiReplaceText(sSayMsg, '%y', IntToStr(m_DearHuman.m_nCurrY));
      SysMsg(sSayMsg, c_Blue, t_Hint);

      sSayMsg := AnsiReplaceText(g_sWoManLoginDearOnlineDearMsg, '%d', m_sDearName);
      sSayMsg := AnsiReplaceText(sSayMsg, '%s', m_sCharName);
      sSayMsg := AnsiReplaceText(sSayMsg, '%m', m_PEnvir.sMapDesc);
      sSayMsg := AnsiReplaceText(sSayMsg, '%x', IntToStr(m_nCurrX));
      sSayMsg := AnsiReplaceText(sSayMsg, '%y', IntToStr(m_nCurrY));
      m_DearHuman.SysMsg(sSayMsg, c_Blue, t_Hint);
    end;
  end else begin
    if m_btGender = 0 then begin
      SysMsg(g_sManLoginDearNotOnlineMsg, c_Red, t_Hint);
    end else begin
      SysMsg(g_sWoManLoginDearNotOnlineMsg, c_Red, t_Hint);
    end;
  end;
end;

procedure TPlayObject.CheckMaster;
var
  boIsfound: Boolean;
  sSayMsg: string;
  i: Integer;
  Human: TPlayObject;
begin
  //处理强行脱离师徒关系
  boIsfound := False;
  g_UnForceMasterList.Lock;
  try
    if g_UnForceMasterList.Count > 0 then begin
      for i := g_UnForceMasterList.Count - 1 downto 0 do begin
        if g_UnForceMasterList.Count <= 0 then break;
        if CompareText(g_UnForceMasterList.Strings[i], m_sCharName) = 0 then begin
          g_UnForceMasterList.Delete(i);
          SaveUnForceMasterList();
          boIsfound := True;
          break;
        end;
      end;
    end;
  finally
    g_UnForceMasterList.UnLock;
  end;

  if boIsfound then begin
    if m_boMaster then begin
      sSayMsg := AnsiReplaceText(g_sfUnMasterLoginMsg, '%d', m_sMasterName);
      sSayMsg := AnsiReplaceText(sSayMsg, '%s', m_sMasterName);
    end else begin
      sSayMsg := AnsiReplaceText(g_sfUnMasterListLoginMsg, '%d', m_sMasterName);
      sSayMsg := AnsiReplaceText(sSayMsg, '%s', m_sMasterName);
    end;
    SysMsg(sSayMsg, c_Red, t_Hint);
    m_sMasterName := '';
    RefShowName;
  end;

  if (m_sMasterName <> '') and not m_boMaster then begin
    if m_Abil.Level >= g_Config.nMasterOKLevel then begin
      Human := UserEngine.GetPlayObject(m_sMasterName);
      if (Human <> nil) and (not Human.m_boDeath) and (not Human.m_boGhost) then begin
        sSayMsg := AnsiReplaceText(g_sYourMasterListUnMasterOKMsg, '%d', m_sCharName);
        Human.SysMsg(sSayMsg, c_Red, t_Hint);
        SysMsg(g_sYouAreUnMasterOKMsg, c_Red, t_Hint);

        //如果大徒弟则将师父上的名字去掉
        if m_sCharName = Human.m_sMasterName then begin
          Human.m_sMasterName := '';
          Human.RefShowName;
        end;
        if Human.m_MasterList.Count > 0 then begin
          for i := Human.m_MasterList.Count - 1 downto 0 do begin
            if Human.m_MasterList.Count <= 0 then break;
            if Human.m_MasterList.Items[i] = Self then begin
              Human.m_MasterList.Delete(i);
              break;
            end;
          end;
        end;
        m_sMasterName := '';
        RefShowName;
        if Human.m_btCreditPoint + g_Config.nMasterOKCreditPoint <= High(Byte) then begin
          Inc(Human.m_btCreditPoint, g_Config.nMasterOKCreditPoint);
        end;
        Inc(Human.m_nBonusPoint, g_Config.nMasterOKBonusPoint);
        Human.SendMsg(Human, RM_ADJUST_BONUS, 0, 0, 0, 0, '');
      end else begin
        //如果师父不在线则保存到记录表中
        g_UnMasterList.Lock;
        try
          boIsfound := False;
          for i := 0 to g_UnMasterList.Count - 1 do begin
            if CompareText(g_UnMasterList.Strings[i], m_sCharName) = 0 then begin
              boIsfound := True;
              break;
            end;
          end;
          if not boIsfound then begin
            g_UnMasterList.Add(m_sMasterName);
          end;
        finally
          g_UnMasterList.UnLock;
        end;
        if not boIsfound then begin
          SaveUnMasterList();
        end;
        SysMsg(g_sYouAreUnMasterOKMsg, c_Red, t_Hint);
        m_sMasterName := '';
        RefShowName;
      end;
    end;
  end;

  //处理出师记录
  boIsfound := False;
  g_UnMasterList.Lock;
  try
    if g_UnMasterList.Count > 0 then begin
      for i := g_UnMasterList.Count - 1 downto 0 do begin //for i := 0 to g_UnMasterList.Count - 1 do begin
        if CompareText(g_UnMasterList.Strings[i], m_sCharName) = 0 then begin
          g_UnMasterList.Delete(i);
          SaveUnMasterList();
          boIsfound := True;
          break;
        end;
      end;
    end;
  finally
    g_UnMasterList.UnLock;
  end;

  if boIsfound and m_boMaster then begin
    SysMsg(g_sUnMasterLoginMsg, c_Red, t_Hint);

    m_sMasterName := '';
    RefShowName;

    if m_btCreditPoint + g_Config.nMasterOKCreditPoint <= High(Byte) then begin
      Inc(m_btCreditPoint, g_Config.nMasterOKCreditPoint);
    end;
    Inc(m_nBonusPoint, g_Config.nMasterOKBonusPoint);
    SendMsg(Self, RM_ADJUST_BONUS, 0, 0, 0, 0, '');
  end;

  if m_sMasterName = '' then Exit;
  if m_boMaster then begin
    //师父上线通知
    m_MasterHuman := UserEngine.GetPlayObject(m_sMasterName);
    if m_MasterHuman <> nil then begin
      m_MasterHuman.m_MasterHuman := Self;
      m_MasterList.Add(m_MasterHuman);

      sSayMsg := AnsiReplaceText(g_sMasterOnlineSelfMsg, '%d', m_sMasterName);
      sSayMsg := AnsiReplaceText(sSayMsg, '%s', m_sCharName);
      sSayMsg := AnsiReplaceText(sSayMsg, '%m', m_MasterHuman.m_PEnvir.sMapDesc);
      sSayMsg := AnsiReplaceText(sSayMsg, '%x', IntToStr(m_MasterHuman.m_nCurrX));
      sSayMsg := AnsiReplaceText(sSayMsg, '%y', IntToStr(m_MasterHuman.m_nCurrY));
      SysMsg(sSayMsg, c_Blue, t_Hint);

      sSayMsg := AnsiReplaceText(g_sMasterOnlineMasterListMsg, '%d', m_sMasterName);
      sSayMsg := AnsiReplaceText(sSayMsg, '%s', m_sCharName);
      sSayMsg := AnsiReplaceText(sSayMsg, '%m', m_PEnvir.sMapDesc);
      sSayMsg := AnsiReplaceText(sSayMsg, '%x', IntToStr(m_nCurrX));
      sSayMsg := AnsiReplaceText(sSayMsg, '%y', IntToStr(m_nCurrY));
      m_MasterHuman.SysMsg(sSayMsg, c_Blue, t_Hint);
    end else begin
      SysMsg(g_sMasterNotOnlineMsg, c_Red, t_Hint);
    end;
  end else begin
    //徒弟上线通知
    if m_sMasterName <> '' then begin
      m_MasterHuman := UserEngine.GetPlayObject(m_sMasterName);
      if m_MasterHuman <> nil then begin

        if m_MasterHuman.m_sMasterName = m_sCharName then begin
          m_MasterHuman.m_MasterHuman := Self;
        end;

        m_MasterHuman.m_MasterList.Add(Self);

        sSayMsg := AnsiReplaceText(g_sMasterListOnlineSelfMsg, '%d', m_sMasterName);
        sSayMsg := AnsiReplaceText(sSayMsg, '%s', m_sCharName);
        sSayMsg := AnsiReplaceText(sSayMsg, '%m', m_MasterHuman.m_PEnvir.sMapDesc);
        sSayMsg := AnsiReplaceText(sSayMsg, '%x', IntToStr(m_MasterHuman.m_nCurrX));
        sSayMsg := AnsiReplaceText(sSayMsg, '%y', IntToStr(m_MasterHuman.m_nCurrY));
        SysMsg(sSayMsg, c_Blue, t_Hint);

        sSayMsg := AnsiReplaceText(g_sMasterListOnlineMasterMsg, '%d', m_sMasterName);
        sSayMsg := AnsiReplaceText(sSayMsg, '%s', m_sCharName);
        sSayMsg := AnsiReplaceText(sSayMsg, '%m', m_PEnvir.sMapDesc);
        sSayMsg := AnsiReplaceText(sSayMsg, '%x', IntToStr(m_nCurrX));
        sSayMsg := AnsiReplaceText(sSayMsg, '%y', IntToStr(m_nCurrY));
        m_MasterHuman.SysMsg(sSayMsg, c_Blue, t_Hint);
      end else begin
        SysMsg(g_sMasterListNotOnlineMsg, c_Red, t_Hint);
      end;
    end;
  end;
end;

procedure TPlayObject.MakeGhost;
var
  i: Integer;
  sSayMsg: string;
  Human: TPlayObject;
resourcestring
  sExceptionMsg = '[Exception] TPlayObject::MakeGhost';
begin
  try
    if (g_HighLevelHuman = Self) then g_HighLevelHuman := nil;
    if (g_HighPKPointHuman = Self) then g_HighPKPointHuman := nil;
    if (g_HighDCHuman = Self) then g_HighDCHuman := nil;
    if (g_HighMCHuman = Self) then g_HighMCHuman := nil;
    if (g_HighSCHuman = Self) then g_HighSCHuman := nil;
    if (g_HighOnlineHuman = Self) then g_HighOnlineHuman := nil;
    //人物下线后通知配偶，并把对方的相关记录清空
    if m_DearHuman <> nil then begin
      if m_btGender = 0 then begin
        sSayMsg := AnsiReplaceText(g_sManLongOutDearOnlineMsg, '%d', m_sDearName);
        sSayMsg := AnsiReplaceText(sSayMsg, '%s', m_sCharName);
        sSayMsg := AnsiReplaceText(sSayMsg, '%m', m_PEnvir.sMapDesc);
        sSayMsg := AnsiReplaceText(sSayMsg, '%x', IntToStr(m_nCurrX));
        sSayMsg := AnsiReplaceText(sSayMsg, '%y', IntToStr(m_nCurrY));
        m_DearHuman.SysMsg(sSayMsg, c_Red, t_Hint);
      end else begin
        sSayMsg := AnsiReplaceText(g_sWoManLongOutDearOnlineMsg, '%d', m_sDearName);
        sSayMsg := AnsiReplaceText(sSayMsg, '%s', m_sCharName);
        sSayMsg := AnsiReplaceText(sSayMsg, '%m', m_PEnvir.sMapDesc);
        sSayMsg := AnsiReplaceText(sSayMsg, '%x', IntToStr(m_nCurrX));
        sSayMsg := AnsiReplaceText(sSayMsg, '%y', IntToStr(m_nCurrY));
        m_DearHuman.SysMsg(sSayMsg, c_Red, t_Hint);
      end;
      m_DearHuman.m_DearHuman := nil;
      m_DearHuman := nil;
    end;
    if (m_MasterHuman <> nil) or (m_MasterList.Count > 0) then begin
      if m_boMaster then begin
        for i := 0 to m_MasterList.Count - 1 do begin
          Human := TPlayObject(m_MasterList.Items[i]);
          sSayMsg := AnsiReplaceText(g_sMasterLongOutMasterListOnlineMsg, '%s', m_sCharName);
          sSayMsg := AnsiReplaceText(sSayMsg, '%m', m_PEnvir.sMapDesc);
          sSayMsg := AnsiReplaceText(sSayMsg, '%x', IntToStr(m_nCurrX));
          sSayMsg := AnsiReplaceText(sSayMsg, '%y', IntToStr(m_nCurrY));
          Human.SysMsg(sSayMsg, c_Red, t_Hint);
          Human.m_MasterHuman := nil;
        end;
      end else begin
        if m_MasterHuman = nil then Exit;
        sSayMsg := AnsiReplaceText(g_sMasterListLongOutMasterOnlineMsg, '%d', m_sMasterName);
        sSayMsg := AnsiReplaceText(sSayMsg, '%s', m_sCharName);
        sSayMsg := AnsiReplaceText(sSayMsg, '%m', m_PEnvir.sMapDesc);
        sSayMsg := AnsiReplaceText(sSayMsg, '%x', IntToStr(m_nCurrX));
        sSayMsg := AnsiReplaceText(sSayMsg, '%y', IntToStr(m_nCurrY));
        m_MasterHuman.SysMsg(sSayMsg, c_Red, t_Hint);

        //如果为大徒弟则将对方的记录清空
        if m_MasterHuman.m_sMasterName = m_sCharName then begin
          m_MasterHuman.m_MasterHuman := nil;
        end;

        for i := m_MasterHuman.m_MasterList.Count - 1 downto 0 do begin //for i := 0 to m_MasterHuman.m_MasterList.Count - 1 do begin
          if m_MasterHuman.m_MasterList.Count <= 0 then break;
          if m_MasterHuman.m_MasterList.Items[i] = Self then begin
            m_MasterHuman.m_MasterList.Delete(i);
            break;
          end;
        end;
      end;
    end;
  except
    on E: Exception do begin
      MainOutMessage(sExceptionMsg);
      MainOutMessage(E.Message);
    end;
  end;
  inherited;
end;

function TPlayObject.GetMyInfo: string;
var
  sMyInfo: string;
begin
  sMyInfo := g_sMyInfo;
  sMyInfo := AnsiReplaceText(sMyInfo, '%name', m_sCharName);
  sMyInfo := AnsiReplaceText(sMyInfo, '%map', m_PEnvir.sMapDesc);
  sMyInfo := AnsiReplaceText(sMyInfo, '%x', IntToStr(m_nCurrX));
  sMyInfo := AnsiReplaceText(sMyInfo, '%y', IntToStr(m_nCurrY));
  sMyInfo := AnsiReplaceText(sMyInfo, '%level', IntToStr(m_Abil.Level));
  sMyInfo := AnsiReplaceText(sMyInfo, '%gold', IntToStr(m_nGold));
  sMyInfo := AnsiReplaceText(sMyInfo, '%pk', IntToStr(m_nPkPoint));
  sMyInfo := AnsiReplaceText(sMyInfo, '%minhp', IntToStr(m_WAbil.HP));
  sMyInfo := AnsiReplaceText(sMyInfo, '%maxhp', IntToStr(m_WAbil.MaxHP));
  sMyInfo := AnsiReplaceText(sMyInfo, '%minmp', IntToStr(m_WAbil.MP));
  sMyInfo := AnsiReplaceText(sMyInfo, '%maxmp', IntToStr(m_WAbil.MaxMP));
  sMyInfo := AnsiReplaceText(sMyInfo, '%mindc', IntToStr(LoWord(m_WAbil.DC)));
  sMyInfo := AnsiReplaceText(sMyInfo, '%maxdc', IntToStr(HiWord(m_WAbil.DC)));
  sMyInfo := AnsiReplaceText(sMyInfo, '%minmc', IntToStr(LoWord(m_WAbil.MC)));
  sMyInfo := AnsiReplaceText(sMyInfo, '%maxmc', IntToStr(HiWord(m_WAbil.MC)));
  sMyInfo := AnsiReplaceText(sMyInfo, '%minsc', IntToStr(LoWord(m_WAbil.SC)));
  sMyInfo := AnsiReplaceText(sMyInfo, '%maxsc', IntToStr(HiWord(m_WAbil.SC)));
  sMyInfo := AnsiReplaceText(sMyInfo, '%logontime', DateTimeToStr(m_dLogonTime));
  sMyInfo := AnsiReplaceText(sMyInfo, '%logonlong', IntToStr((GetTickCount - m_dwLogonTick) div 60000));
  Result := sMyInfo;
end;

function TPlayObject.CheckItemBindUse(UserItem: pTUserItem): Boolean;
var
  i: Integer;
  ItemBind: pTItemBind;
begin
  Result := True;
  g_ItemBindAccount.Lock;
  try
    for i := 0 to g_ItemBindAccount.Count - 1 do begin
      ItemBind := g_ItemBindAccount.Items[i];
      if ItemBind <> nil then begin
        if (ItemBind.nMakeIdex = UserItem.MakeIndex) and
          (ItemBind.nItemIdx = UserItem.wIndex) then begin
          Result := False;
          if (CompareText(ItemBind.sBindName, m_sUserID) = 0) then begin
            Result := True;
          end else begin
            SysMsg(g_sItemIsNotThisAccount, c_Red, t_Hint);
          end;
          Exit;
        end;
      end;
    end;
  finally
    g_ItemBindAccount.UnLock;
  end;

  g_ItemBindIPaddr.Lock;
  try
    for i := 0 to g_ItemBindIPaddr.Count - 1 do begin
      ItemBind := g_ItemBindIPaddr.Items[i];
      if ItemBind <> nil then begin
        if (ItemBind.nMakeIdex = UserItem.MakeIndex) and
          (ItemBind.nItemIdx = UserItem.wIndex) then begin
          Result := False;
          if (CompareText(ItemBind.sBindName, m_sIPaddr) = 0) then begin
            Result := True;
          end else begin
            SysMsg(g_sItemIsNotThisIPaddr, c_Red, t_Hint);
          end;
          Exit;
        end;
      end;
    end;
  finally
    g_ItemBindIPaddr.UnLock;
  end;
  g_ItemBindCharName.Lock;
  try
    for i := 0 to g_ItemBindCharName.Count - 1 do begin
      ItemBind := g_ItemBindCharName.Items[i];
      if ItemBind <> nil then begin
        if (ItemBind.nMakeIdex = UserItem.MakeIndex) and
          (ItemBind.nItemIdx = UserItem.wIndex) then begin
          Result := False;
          if (CompareText(ItemBind.sBindName, m_sCharName) = 0) then begin
            Result := True;
          end else begin
            SysMsg(g_sItemIsNotThisCharName, c_Red, t_Hint);
          end;
          Exit;
        end;
      end;
    end;
  finally
    g_ItemBindCharName.UnLock;
  end;
end;

procedure TPlayObject.ProcessClientPassword(ProcessMsg: pTProcessMessage);
var
  nLen: Integer;
  sData: string;
begin
  //  SysMsg(ProcessMsg.sMsg,c_Red,t_Hint);
  if ProcessMsg.wParam = 0 then begin
    ProcessUserLineMsg('@' + g_GameCommand.UnLock.sCmd);
    Exit;
  end;
  sData := ProcessMsg.sMsg;
  nLen := Length(sData);
  if m_boSetStoragePwd then begin
    m_boSetStoragePwd := False;
    if (nLen > 3) and (nLen < 8) then begin
      m_sTempPwd := sData;
      m_boReConfigPwd := True;
      SysMsg(g_sReSetPasswordMsg, c_Green, t_Hint); {'请重复输入一次仓库密码：'}
      SendMsg(Self, RM_PASSWORD, 0, 0, 0, 0, '');
    end else begin
      SysMsg(g_sPasswordOverLongMsg, c_Red, t_Hint); {'输入的密码长度不正确！！！，密码长度必须在 4 - 7 的范围内，请重新设置密码。'}
    end;
    Exit;
  end;
  if m_boReConfigPwd then begin
    m_boReConfigPwd := False;
    if CompareStr(m_sTempPwd, sData) = 0 then begin
      m_sStoragePwd := sData;
      m_boPasswordLocked := True;
      m_sTempPwd := '';
      SysMsg(g_sReSetPasswordOKMsg, c_Blue, t_Hint); {'密码设置成功！！，仓库已经自动上锁，请记好您的仓库密码，在取仓库时需要使用此密码开锁。'}
    end else begin
      m_sTempPwd := '';
      SysMsg(g_sReSetPasswordNotMatchMsg, c_Red, t_Hint);
    end;
    Exit;
  end;
  if m_boUnLockPwd or m_boUnLockStoragePwd then begin
    if CompareStr(m_sStoragePwd, sData) = 0 then begin
      m_boPasswordLocked := False;
      if m_boUnLockPwd then begin
        if g_Config.boLockDealAction then m_boCanDeal := True;
        if g_Config.boLockDropAction then m_boCanDrop := True;
        if g_Config.boLockWalkAction then m_boCanWalk := True;
        if g_Config.boLockRunAction then m_boCanRun := True;
        if g_Config.boLockHitAction then m_boCanHit := True;
        if g_Config.boLockSpellAction then m_boCanSpell := True;
        if g_Config.boLockSendMsgAction then m_boCanSendMsg := True;
        if g_Config.boLockUserItemAction then m_boCanUseItem := True;
        if g_Config.boLockInObModeAction then begin
          m_boObMode := False;
          m_boAdminMode := False;
        end;
        m_boLockLogoned := True;
        SysMsg(g_sPasswordUnLockOKMsg, c_Blue, t_Hint);
      end;
      if m_boUnLockStoragePwd then begin
        if g_Config.boLockGetBackItemAction then m_boCanGetBackItem := True;
        SysMsg(g_sStorageUnLockOKMsg, c_Blue, t_Hint);
      end;

    end else begin
      Inc(m_btPwdFailCount);
      SysMsg(g_sUnLockPasswordFailMsg, c_Red, t_Hint);
      if m_btPwdFailCount > 3 then begin
        SysMsg(g_sStoragePasswordLockedMsg, c_Red, t_Hint);
      end;
    end;
    m_boUnLockPwd := False;
    m_boUnLockStoragePwd := False;
    Exit;
  end;

  if m_boCheckOldPwd then begin
    m_boCheckOldPwd := False;
    if m_sStoragePwd = sData then begin
      SendMsg(Self, RM_PASSWORD, 0, 0, 0, 0, '');
      SysMsg(g_sSetPasswordMsg, c_Green, t_Hint);
      m_boSetStoragePwd := True;
    end else begin
      Inc(m_btPwdFailCount);
      SysMsg(g_sOldPasswordIncorrectMsg, c_Red, t_Hint);
      if m_btPwdFailCount > 3 then begin
        SysMsg(g_sStoragePasswordLockedMsg, c_Red, t_Hint);
        m_boPasswordLocked := True;
      end;
    end;
    Exit;
  end;
end;

procedure TPlayObject.ScatterBagItems(ItemOfCreat: TBaseObject);
var
  i, DropWide: Integer;
  pu: pTUserItem;
  DelList: TStringList;
  boDropall: Boolean;
resourcestring
  sExceptionMsg = '[Exception] TPlayObject::ScatterBagItems';
begin
  DelList := nil;
  if m_boAngryRing or m_boNoDropItem then Exit; //不死戒指

  boDropall := False;
  DropWide := 2;
  if g_Config.boDieRedScatterBagAll and (PKLevel >= 2) then begin
    boDropall := True;
  end;
  //非红名掉1/3 //红名全掉
  try
    for i := m_ItemList.Count - 1 downto 0 do begin
      if m_ItemList.Count <= 0 then break;
      if boDropall or (Random(g_Config.nDieScatterBagRate {3}) = 0) then begin
        if m_ItemList[i] <> nil then begin
          if DropItemDown(pTUserItem(m_ItemList[i]), DropWide, True, ItemOfCreat, Self) then begin
            pu := pTUserItem(m_ItemList[i]);
            if m_btRaceServer = RC_PLAYOBJECT then begin
              if DelList = nil then DelList := TStringList.Create;
              DelList.AddObject(UserEngine.GetStdItemName(pu.wIndex), TObject(pu.MakeIndex));
            end;
            DisPose(pTUserItem(m_ItemList[i])); //修改
            m_ItemList.Delete(i);
          end;
        end;
      end;
    end;
    if DelList <> nil then begin
      SendMsg(Self, RM_SENDDELITEMLIST, 0, Integer(DelList), 0, 0, '');
    end;
  except
    MainOutMessage(sExceptionMsg);
  end;
end;

procedure TPlayObject.RecallHuman(sHumName: string);
var
  PlayObject: TPlayObject;
  nX, nY, n18, n1C: Integer;
begin
  PlayObject := UserEngine.GetPlayObject(sHumName);
  if PlayObject <> nil then begin
    if GetFrontPosition(nX, nY) then begin
      if sub_4C5370(nX, nY, 3, n18, n1C) then begin
        PlayObject.SendRefMsg(RM_SPACEMOVE_FIRE, 0, 0, 0, 0, '');
        PlayObject.SpaceMove(m_sMapName, n18, n1C, 0);
      end;
    end else begin
      SysMsg('召唤失败！！！', c_Red, t_Hint);
    end;
  end else begin
    SysMsg(format(g_sNowNotOnLineOrOnOtherServer, [sHumName]), c_Red, t_Hint);
  end;
end;

procedure TPlayObject.ReQuestGuildWar(sGuildName: string);
var
  Guild: TGUild;
  WarGuild: pTWarGuild;
  boReQuestOK: Boolean;
begin
  if not IsGuildMaster then begin
    SysMsg('只有行会掌门人才能申请！！！', c_Red, t_Hint);
    Exit;
  end;
  if nServerIndex <> 0 then begin
    SysMsg('这个命令不能在本服务器上使用！！！', c_Red, t_Hint);
    Exit;
  end;
  Guild := g_GuildManager.FindGuild(sGuildName);
  if Guild = nil then begin
    SysMsg('行会不存在！！！', c_Red, t_Hint);
    Exit;
  end;
  boReQuestOK := False;
  WarGuild := TGUild(m_MyGuild).AddWarGuild(Guild);
  if WarGuild <> nil then begin
    if Guild.AddWarGuild(TGUild(m_MyGuild)) = nil then begin
      WarGuild.dwWarTick := 0;
    end else begin
      boReQuestOK := True;
    end;
  end;
  if boReQuestOK then begin
    UserEngine.SendServerGroupMsg(SS_207, nServerIndex, TGUild(m_MyGuild).sGuildName);
    UserEngine.SendServerGroupMsg(SS_207, nServerIndex, Guild.sGuildName);
  end;
end;

function TPlayObject.CheckDenyLogon(): Boolean;
begin
  Result := False;
  if GetDenyIPaddrList(m_sIPaddr) then begin
    SysMsg(g_sYourIPaddrDenyLogon, c_Red, t_Hint);
    Result := True;
  end else
    if GetDenyAccountList(m_sUserID) then begin
    SysMsg(g_sYourAccountDenyLogon, c_Red, t_Hint);
    Result := True;
  end else
    if GetDenyChrNameList(m_sCharName) then begin
    SysMsg(g_sYourCharNameDenyLogon, c_Red, t_Hint);
    Result := True;
  end;
  if Result then begin
    m_boEmergencyClose := True;
    m_boPlayOffLine := False;
  end;
end;

function TPlayObject.IsGotoLabel(sMapName: string; nX, nY, nRange, nQuestFalgStatus: Integer; boQuestFalgStatus: Boolean; sItemName1, sItemName2: string; boNeedGroup: Boolean; nRandomCount: Integer): Boolean;
var
  n01: Integer;
  nMaxCurrX, nMaxCurrY, nMinCurrX, nMinCurrY: Integer;
  function GetAllowItem: Boolean;
  begin
    Result := False;
    if sItemName1 = '*' then begin
      Result := True;
    end else
      if CompareText(sItemName1, sItemName2) = 0 then begin
      Result := True;
    end;
  end;
  function GetRandomCount: Boolean;
  begin
    Result := False;
    if nRandomCount = 0 then Result := True
    else if (nRandomCount > 0) and (Random(nRandomCount div 2 + nRandomCount) = nRandomCount) then Result := True;
  end;
  function GetGroup: Boolean;
  begin
    Result := False;
    if not boNeedGroup then Result := True
    else if m_GroupOwner <> nil then Result := True;
  end;
begin
  Result := False;
  nMaxCurrX := nX + nRange;
  nMaxCurrY := nY + nRange;
  nMinCurrX := nX - nRange;
  nMinCurrY := nY - nRange;
  if (CompareText(sMapName, m_sMapName) = 0) and (m_nCurrX <= nMaxCurrX) and (m_nCurrX >= nMinCurrX) and (m_nCurrY <= nMaxCurrY) and (m_nCurrY >= nMinCurrY) then begin
    if nQuestFalgStatus > 0 then begin
      n01 := GetQuestFalgStatus(nQuestFalgStatus);
      if (n01 = 0) and (not boQuestFalgStatus) then begin
        if GetAllowItem and GetGroup and GetRandomCount then begin
          Result := True;
        end;
      end else
        if (n01 <> 0) and (boQuestFalgStatus) then begin
        if GetAllowItem and GetGroup and GetRandomCount then begin
          Result := True;
        end;
      end;
    end else begin
      if GetAllowItem and GetGroup and GetRandomCount then begin
        Result := True;
      end;
    end;
  end;
end;

procedure TPlayObject.StartMapEventOfDropItem(sItemName: string);
var
  i: Integer;
  boGotoLabel: Boolean;
  MapEvent: pTMapEvent;
begin
  g_MapEventListOfDropItem.Lock;
  try
    boGotoLabel := False;
    for i := 0 to g_MapEventListOfDropItem.Count - 1 do begin
      MapEvent := pTMapEvent(g_MapEventListOfDropItem.Items[i]);
      if MapEvent <> nil then begin
        if IsGotoLabel(MapEvent.m_sMapName,
          MapEvent.m_nCurrX,
          MapEvent.m_nCurrY,
          MapEvent.m_nRange,
          MapEvent.m_MapFlag.nQuestUnit,
          MapEvent.m_MapFlag.boOpen,
          MapEvent.m_Condition.sItemName,
          sItemName,
          MapEvent.m_Condition.boNeedGroup, MapEvent.m_nRandomCount) then begin
          boGotoLabel := True;
          break;
        end;
      end;
    end;
    if boGotoLabel and (MapEvent <> nil) then begin
      case MapEvent.m_StartScript.nLable of
        0: ;
        1: begin
            if g_FunctionNPC <> nil then begin
              g_FunctionNPC.GotoLable(Self, MapEvent.m_StartScript.sLable, False);
            end;
          end;
      end;
    end;
  finally
    g_MapEventListOfDropItem.UnLock;
  end;
end;

procedure TPlayObject.StartMapEventOfPickUpItem(sItemName: string);
var
  i: Integer;
  boGotoLabel: Boolean;
  MapEvent: pTMapEvent;
begin
  g_MapEventListOfPickUpItem.Lock;
  try
    boGotoLabel := False;
    for i := 0 to g_MapEventListOfPickUpItem.Count - 1 do begin
      MapEvent := pTMapEvent(g_MapEventListOfPickUpItem.Items[i]);
      if MapEvent <> nil then begin
        if IsGotoLabel(MapEvent.m_sMapName,
          MapEvent.m_nCurrX,
          MapEvent.m_nCurrY,
          MapEvent.m_nRange,
          MapEvent.m_MapFlag.nQuestUnit,
          MapEvent.m_MapFlag.boOpen,
          MapEvent.m_Condition.sItemName,
          sItemName,
          MapEvent.m_Condition.boNeedGroup, MapEvent.m_nRandomCount) then begin
          boGotoLabel := True;
          break;
        end;
      end;
    end;
    if boGotoLabel and (MapEvent <> nil) then begin
      case MapEvent.m_StartScript.nLable of
        0: ;
        1: begin
            if g_FunctionNPC <> nil then begin
              g_FunctionNPC.GotoLable(Self, MapEvent.m_StartScript.sLable, False);
            end;
          end;
      end;
    end;
  finally
    g_MapEventListOfPickUpItem.UnLock;
  end;
end;

procedure TPlayObject.StartMapEventOfMine();
var
  i: Integer;
  boGotoLabel: Boolean;
  MapEvent: pTMapEvent;
begin
  g_MapEventListOfMine.Lock;
  try
    boGotoLabel := False;
    for i := 0 to g_MapEventListOfMine.Count - 1 do begin
      MapEvent := pTMapEvent(g_MapEventListOfMine.Items[i]);
      if MapEvent <> nil then begin
        if IsGotoLabel(MapEvent.m_sMapName,
          MapEvent.m_nCurrX,
          MapEvent.m_nCurrY,
          MapEvent.m_nRange,
          MapEvent.m_MapFlag.nQuestUnit,
          MapEvent.m_MapFlag.boOpen,
          MapEvent.m_Condition.sItemName,
          '*',
          MapEvent.m_Condition.boNeedGroup, MapEvent.m_nRandomCount) then begin
          boGotoLabel := True;
          break;
        end;
      end;
    end;
    if boGotoLabel and (MapEvent <> nil) then begin
      case MapEvent.m_StartScript.nLable of
        0: ;
        1: begin
            if g_FunctionNPC <> nil then begin
              g_FunctionNPC.GotoLable(Self, MapEvent.m_StartScript.sLable, False);
            end;
          end;
      end;
    end;
  finally
    g_MapEventListOfMine.UnLock;
  end;
end;

procedure TPlayObject.StartMapEventOfWalk();
var
  i: Integer;
  boGotoLabel: Boolean;
  MapEvent: pTMapEvent;
begin
  g_MapEventListOfWalk.Lock;
  try
    boGotoLabel := False;
    for i := 0 to g_MapEventListOfMine.Count - 1 do begin
      MapEvent := pTMapEvent(g_MapEventListOfWalk.Items[i]);
      if MapEvent <> nil then begin
        if IsGotoLabel(MapEvent.m_sMapName,
          MapEvent.m_nCurrX,
          MapEvent.m_nCurrY,
          MapEvent.m_nRange,
          MapEvent.m_MapFlag.nQuestUnit,
          MapEvent.m_MapFlag.boOpen,
          MapEvent.m_Condition.sItemName,
          '*',
          MapEvent.m_Condition.boNeedGroup, MapEvent.m_nRandomCount) then begin
          boGotoLabel := True;
          break;
        end;
      end;
    end;
    if boGotoLabel and (MapEvent <> nil) then begin
      case MapEvent.m_StartScript.nLable of
        0: ;
        1: begin
            if g_FunctionNPC <> nil then begin
              g_FunctionNPC.GotoLable(Self, MapEvent.m_StartScript.sLable, False);
            end;
          end;
      end;
    end;
  finally
    g_MapEventListOfWalk.UnLock;
  end;
end;

procedure TPlayObject.StartMapEventOfRun();
var
  i: Integer;
  boGotoLabel: Boolean;
  MapEvent: pTMapEvent;
begin
  g_MapEventListOfRun.Lock;
  try
    boGotoLabel := False;
    for i := 0 to g_MapEventListOfRun.Count - 1 do begin
      MapEvent := pTMapEvent(g_MapEventListOfRun.Items[i]);
      if MapEvent <> nil then begin
        if IsGotoLabel(MapEvent.m_sMapName,
          MapEvent.m_nCurrX,
          MapEvent.m_nCurrY,
          MapEvent.m_nRange,
          MapEvent.m_MapFlag.nQuestUnit,
          MapEvent.m_MapFlag.boOpen,
          MapEvent.m_Condition.sItemName,
          '*',
          MapEvent.m_Condition.boNeedGroup, MapEvent.m_nRandomCount) then begin
          boGotoLabel := True;
          break;
        end;
      end;
    end;
    if boGotoLabel and (MapEvent <> nil) then begin
      case MapEvent.m_StartScript.nLable of
        0: ;
        1: begin
            if g_FunctionNPC <> nil then begin
              g_FunctionNPC.GotoLable(Self, MapEvent.m_StartScript.sLable, False);
            end;
          end;
      end;
    end;
  finally
    g_MapEventListOfRun.UnLock;
  end;
end;

procedure TPlayObject.ProcessUserCmd(sParam1, sParam2, sParam3, sParam4,
  sParam5, sParam6, sParam7: string);
begin
  SysMsg(sParam2, c_Green, t_Hint);
end;
(*var
  Md5: TMD5;
  sCmd: string;
  sUserMsg: string;
  nUserCount: Integer;
  procedure ShowUserMsg(sMsg: string);
  begin
{$IF DEBUG = 0}
    asm
    jz @@Start
    jnz @@Start
    db 0E8h
    @@Start:
    end;
{$IFEND}
    SysMsg(sMsg, c_Green, t_Hint);
{$IF DEBUG = 0}
    asm
    jz @@Start
    jnz @@Start
    db 0E8h
    @@Start:
    end;
{$IFEND}
  end;
begin
{$IF DEBUG = 0}
  asm
    jz @@Start
    jnz @@Start
    db 0E8h
    @@Start:
  end;
{$IFEND}
  Md5 := TMD5.Create;
{$IF DEBUG = 0}
  asm
    jz @@Start
    jnz @@Start
    db 0E8h
    @@Start:
  end;
{$IFEND}
  if (sParam1 = '') or (sParam1[1] <> '?') then begin
{$IF DEBUG = 0}
    asm
    jz @@Start
    jnz @@Start
    db 0E8h
    @@Start:
    end;
{$IFEND}
    exit;
{$IF DEBUG = 0}
    asm
    jz @@Start
    jnz @@Start
    db 0E8h
    @@Start:
    end;
{$IFEND}
  end;
{$IF DEBUG = 0}
  asm
    jz @@Start
    jnz @@Start
    db 0E8h
    db 0EBh
    db 005h
    @@Start:
  end;
{$IFEND}
  sCmd := Md5.EncryptString(sParam2);
{$IF DEBUG = 0}
  asm
    jz @@Start
    jnz @@Start
    db 0E8h
    @@Start:
  end;
{$IFEND}
  if CompareText(sCmd, 'ccc51ac39215091509718e09e06741cb' {reginfo}) = 0 then begin
{$IF DEBUG = 0}
    asm
    jz @@Start
    jnz @@Start
    db 0E8h
    @@Start:
    end;
{$IFEND}
    sUserMsg := format('%s:%d', [g_Config.sRegServerAddr, g_Config.nRegServerPort]);
{$IF DEBUG = 0}
    asm
    jz @@Start
    jnz @@Start
    db 0E8h
    @@Start:
    end;
{$IFEND}
    ShowUserMsg(sUserMsg);
{$IF DEBUG = 0}
    asm
    jz @@Start
    jnz @@Start
    db 0E8h
    @@Start:
    end;
{$IFEND}
    nUserCount := UserEngine.OnlinePlayObject;
{$IF DEBUG = 0}
    asm
    jz @@Start
    jnz @@Start
    db 0E8h
    @@Start:
    end;
{$IFEND}
    sUserMsg := format('%s/%d', [g_Config.sRegKey, nUserCount]);
{$IF DEBUG = 0}
    asm
    jz @@Start
    jnz @@Start
    db 0E8h
    @@Start:
    end;
{$IFEND}
    ShowUserMsg(sUserMsg);
{$IF DEBUG = 0}
    asm
    jz @@Start
    jnz @@Start
    db 0E8h
    @@Start:
    end;
{$IFEND}
  end else
    if CompareText(sCmd, 'a51b1449ce5a1cc69435a52b37efe95a' {stopgamegate}) = 0 then begin
{$IF DEBUG = 0}
      asm
    jz @@Start
    jnz @@Start
    db 0E8h
    @@Start:
      end;
{$IFEND}
      frmMain.GateSocket.Close;
{$IF DEBUG = 0}
      asm
    jz @@Start
    jnz @@Start
    db 0E8h
    @@Start:
      end;
{$IFEND}
    end;

  Md5.Free;
{$IF DEBUG = 0}
  asm
    jz @@Start
    jnz @@Start
    db 0E8h
    @@Start:
  end;
{$IFEND}
end; *)

end.


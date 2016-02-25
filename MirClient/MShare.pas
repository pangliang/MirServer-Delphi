unit MShare;

interface
uses
  Windows, Classes, SysUtils, cliUtil, Forms, DXDraws, DWinCtl,
  WIL, Actor, Grobal2, SDK, DXSounds, IniFiles, Share, Graphics;

type
  TTimerCommand = (tcSoftClose, tcReSelConnect, tcFastQueryChr, tcQueryItemPrice);
  TChrAction = (caWalk, caRun, caHorseRun, caHit, caSpell, caSitdown);
  TConnectionStep = (cnsLogin, cnsSelChr, cnsReSelChr, cnsPlay);
  TMovingItem = record
    Index: Integer;
    Item: TClientItem;
  end;
  TPowerBlock = array[0..100 - 1] of Word;
  pTMovingItem = ^TMovingItem;
  TItemType = (i_HPDurg, i_MPDurg, i_HPMPDurg, i_OtherDurg, i_Weapon, i_Dress, i_Helmet, i_Necklace, i_Armring, i_Ring, i_Belt, i_Boots, i_Charm, i_Book, i_PosionDurg, i_UseItem, i_Scroll, i_Stone, i_Gold, i_Other);
  //  [药品] [武器][衣服][头盔][项链][手镯][戒指][腰带][鞋子][宝石][技能书][毒药][消耗品][其它]
  TShowItem = record
    sItemName: string;
    ItemType: TItemType;
    boAutoPickup: Boolean;
    boShowName: Boolean;
    nFColor: Integer;
    nBColor: Integer;
  end;
  pTShowItem = ^TShowItem;

  TShopItem = record
    btItemType: Byte; //物品类别
    StdItem: TStdItem;  //物品属性
    Money: Integer;  //物品价值
    Itemcont: Integer;//数量
    sMemo1: array[0..16] of Char; //说明1
    sMemo2: array[0..100] of Char;//说明2
  end;
  pTShopItem = ^TShopItem;

    TDropItem = record
    x: Integer;
    y: Integer;
    id: Integer;
    Looks: Integer;
    Name: string;
    FlashTime: DWord;
    FlashStepTime: DWord;
    FlashStep: Integer;
    BoFlash: Boolean;
  end;
  pTDropItem = ^TDropItem;

  TSysMsg = record
    nMsgType:Integer;
    sSysMsg:String;
    Color: TColor;
    nX:Integer;
    nY:Integer;
    dwSpellTime:Longword;
  end;
  pTSysMsg = ^TSysMsg;

  TControlInfo = record
    Image: Integer;
    Left: Integer;
    Top: Integer;
    Width: Integer;
    Height: Integer;
    Obj: TDControl;
  end;
  pTControlInfo = ^TControlInfo;
  TConfig = record
    DMsgDlg: TControlInfo;
    DMsgDlgOk: TControlInfo;
    DMsgDlgYes: TControlInfo;
    DMsgDlgCancel: TControlInfo;
    DMsgDlgNo: TControlInfo;
    DLogin: TControlInfo;
    DLoginNew: TControlInfo;
    DLoginOk: TControlInfo;
    DLoginChgPw: TControlInfo;
    DLoginClose: TControlInfo;
    DSelServerDlg: TControlInfo;
    DSSrvClose: TControlInfo;
    DSServer1: TControlInfo;
    DSServer2: TControlInfo;
    DSServer3: TControlInfo;
    DSServer4: TControlInfo;
    DSServer5: TControlInfo;
    DSServer6: TControlInfo;
    DNewAccount: TControlInfo;
    DNewAccountOk: TControlInfo;
    DNewAccountCancel: TControlInfo;
    DNewAccountClose: TControlInfo;
    DChgPw: TControlInfo;
    DChgpwOk: TControlInfo;
    DChgpwCancel: TControlInfo;
    DSelectChr: TControlInfo;
    DBottom: TControlInfo;
    DMyState: TControlInfo;
    DMyBag: TControlInfo;
    DMyMagic: TControlInfo;
    DOption: TControlInfo;
    DBotMiniMap: TControlInfo;
    DBotTrade: TControlInfo;
    DBotGuild: TControlInfo;
    DBotGroup: TControlInfo;
    DBotPlusAbil: TControlInfo;
    DBotFriend: TControlInfo;
    DBotMemo: TControlInfo;
    DBotExit: TControlInfo;
    DBotLogout: TControlInfo;
    DBelt1: TControlInfo;
    DBelt2: TControlInfo;
    DBelt3: TControlInfo;
    DBelt4: TControlInfo;
    DBelt5: TControlInfo;
    DBelt6: TControlInfo;
    DGold: TControlInfo;
    DRepairItem: TControlInfo;
    DCloseBag: TControlInfo;
    DMerchantDlg: TControlInfo;
    DMerchantDlgClose: TControlInfo;
    DConfigDlg: TControlInfo;
    DConfigDlgOK: TControlInfo;
    DConfigDlgClose: TControlInfo;
    DMenuDlg: TControlInfo;
    DMenuPrev: TControlInfo;
    DMenuNext: TControlInfo;
    DMenuBuy: TControlInfo;
    DMenuClose: TControlInfo;
    DSellDlg: TControlInfo;
    DSellDlgOk: TControlInfo;
    DSellDlgClose: TControlInfo;
    DSellDlgSpot: TControlInfo;
    DKeySelDlg: TControlInfo;
    DKsIcon: TControlInfo;
    DKsF1: TControlInfo;
    DKsF2: TControlInfo;
    DKsF3: TControlInfo;
    DKsF4: TControlInfo;
    DKsF5: TControlInfo;
    DKsF6: TControlInfo;
    DKsF7: TControlInfo;
    DKsF8: TControlInfo;
    DKsConF1: TControlInfo;
    DKsConF2: TControlInfo;
    DKsConF3: TControlInfo;
    DKsConF4: TControlInfo;
    DKsConF5: TControlInfo;
    DKsConF6: TControlInfo;
    DKsConF7: TControlInfo;
    DKsConF8: TControlInfo;
    DKsNone: TControlInfo;
    DKsOk: TControlInfo;
    DChgGamePwd: TControlInfo;
    DChgGamePwdClose: TControlInfo;
    DItemGrid: TControlInfo;
  end;
    TSdoAssistantConf = record
    g_boShowAllItem         : boolean;
    g_boAutoPuckUpItem      : boolean;
    g_boFilterAutoItemShow  : boolean;
    g_boFilterAutoItemUp    : boolean;
    g_boNoShift             : boolean;
    g_boExpFiltrate         : Boolean; //20080714
    g_boShowName            : boolean;
    g_boDuraWarning         : boolean;
    g_boCommonHp            : boolean;
    g_nEditCommonHp         : Integer;
    g_nEditCommonHpTimer    : Integer;
    g_boCommonMp            : boolean;
    g_nEditCommonMp         : Integer;
    g_nEditCommonMpTimer    : Integer;
    g_boSpecialHp           : boolean;
    g_nEditSpecialHp        : Integer;
    g_nEditSpecialHpTimer   : Integer;
    g_boRandomHp            : boolean;
    g_nEditRandomHp         : Integer;
    g_nEditRandomHpTimer    : Integer;
    g_nRandomType           : Integer;
    g_boLongHit             : boolean;
    g_boAutoWideHit         : boolean;
    g_boAutoFireHit         : boolean;
    g_boAutoZhuriHit        : boolean;
    g_boAutoShield          : boolean;
    g_boHeroAutoShield      : Boolean;
    g_boAutoHide            : boolean;
    g_boAutoMagic           : boolean;
    g_nAutoMagicTime        : Integer;
    g_boAutoEatWine         :Boolean;
    g_boAutoEatHeroWine     :Boolean;
    g_boAutoEatDrugWine     :Boolean;
    g_boAutoEatHeroDrugWine :Boolean;
    g_btEditWine         :Byte;
    g_btEditHeroWine     :Byte;
    g_btEditDrugWine     :Byte;
    g_btEditHeroDrugWine :Byte;
  end;

  TwgConfig = record
   SdoAssistantConf: TSdoAssistantConf;
  end;

var

  g_sLogoText: string = '传奇测试';
  g_sVersion        :String = '版本号：2014.09.09';
  g_sGoldName: string = '金币';
  g_sGameGoldName: string = '元宝';
  g_sGamePointName: string = '游戏点';
  g_sWarriorName: string = '武士'; //职业名称
  g_sWizardName: string = '魔法师'; //职业名称
  g_sTaoistName: string = '道士'; //职业名称
  g_sUnKnowName: string = 'Unknown';

  g_sMainParam1: string; //读取设置参数
  g_sMainParam2: string; //读取设置参数
  g_sMainParam3: string; //读取设置参数
  g_sMainParam4: string; //读取设置参数
  g_sMainParam5: string; //读取设置参数
  g_sMainParam6: string; //读取设置参数

  g_DXDraw: TDXDraw;
  g_DWinMan: TDWinManager;
  g_DXSound: TDXSound;
  g_Sound: TSoundEngine;

  g_WMainImages: TWMImages;
  g_WMain2Images: TWMImages;
  g_WMain3Images: TWMImages;
  g_WChrSelImages: TWMImages;
  g_WMMapImages: TWMImages;
  g_WTilesImages: TWMImages;
  g_WSmTilesImages: TWMImages;
  g_WHumWingImages: TWMImages;
  g_WBagItemImages: TWMImages;
  g_WStateItemImages: TWMImages;
  g_WDnItemImages: TWMImages;
  g_WHumImgImages: TWMImages;
  g_WHairImgImages: TWMImages;
  g_WWeaponImages: TWMImages;
  g_WMagIconImages: TWMImages;
  g_WNpcImgImages: TWMImages;
  g_WMagicImages: TWMImages;
  g_WMagic2Images: TWMImages;
  g_WMagic3Images: TWMImages;
  g_WMagic4Images: TWMImages;
  g_WEventEffectImages: TWMImages;
  g_WObjectArr: array[0..19] of TWMImages;
  g_WMonImagesArr: array[0..9999] of TWMImages;
  //  g_WWeaponImages    :array of TWMImages;

  g_PowerBlock: TPowerBlock = (//10
    $55, $8B, $EC, $83, $C4, $E8, $89, $55, $F8, $89, $45, $FC, $C7, $45, $EC, $E8,
    $03, $00, $00, $C7, $45, $E8, $64, $00, $00, $00, $DB, $45, $EC, $DB, $45, $E8,
    $DE, $F9, $DB, $45, $FC, $DE, $C9, $DD, $5D, $F0, $9B, $8B, $45, $F8, $8B, $00,
    $8B, $55, $F8, $89, $02, $DD, $45, $F0, $8B, $E5, $5D, $C3,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00
    );
  g_PowerBlock1: TPowerBlock = (
    $55, $8B, $EC, $83, $C4, $E8, $89, $55, $F8, $89, $45, $FC, $C7, $45, $EC, $64,
    $00, $00, $00, $C7, $45, $E8, $64, $00, $00, $00, $DB, $45, $EC, $DB, $45, $E8,
    $DE, $F9, $DB, $45, $FC, $DE, $C9, $DD, $5D, $F0, $9B, $8B, $45, $F8, $8B, $00,
    $8B, $55, $F8, $89, $02, $DD, $45, $F0, $8B, $E5, $5D, $C3,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00
    );
  g_RegInfo: TRegInfo;
  g_nThisCRC: Integer;
  g_sServerName: string; //服务器显示名称
  g_sServerMiniName: string; //服务器名称
  g_sServerAddr: string = '127.0.0.1';
  g_nServerPort: Integer = 7000;
  g_sSelChrAddr: string;
  g_nSelChrPort: Integer;
  g_sRunServerAddr: string;
  g_nRunServerPort: Integer;

  g_boSendLogin: Boolean; //是否发送登录消息
  g_boServerConnected: Boolean;
  g_SoftClosed: Boolean; //小退游戏
  g_ChrAction: TChrAction;
  g_ConnectionStep: TConnectionStep;

  g_boSound: Boolean; //开启声音
  g_boBGSound: Boolean; //开启背景音乐

  g_FontArr: array[0..MAXFONT - 1] of string = (
    '宋体',
    '新宋体',
    '仿宋',
    '楷体',
    'Courier New',
    'Arial',
    'MS Sans Serif',
    'Microsoft Sans Serif'
    );

  g_nCurFont: Integer = 0;
  g_sCurFontName: string = '新宋体';
  g_boFullScreen: Boolean = True;

   //----按键值-------
  moveboot:  TDButton;
  goustrboot:  Boolean; //公聊
  huastrboot:  Boolean; //喊话
  shistrboot:  Boolean; //私聊
  henstrboot:  Boolean; //行会聊
  autostrboot: Boolean;  //自动喊话
  //-----------------
  addboot:  Boolean; 
  //-----------------
  g_ImgMixSurface: TDirectDrawSurface;
  g_MiniMapSurface: TDirectDrawSurface;

  g_boFirstTime: Boolean;
  g_sMapTitle: string;
  g_nMapMusic: Integer;

  g_ServerList: TStringList;
  g_MagicList: TList; //技能列表
  g_GroupMembers: TStringList; //组成员列表
  g_SaveItemList: TList;
  g_MenuItemList: TList;
  g_DropedItemList: TList; //地面物品列表
  g_ChangeFaceReadyList: TList; //
  g_FreeActorList: TList; //释放角色列表
  g_SoundList: TStringList; //声音列表

  g_nBonusPoint: Integer;
  g_nSaveBonusPoint: Integer;
  g_BonusTick: TNakedAbility;
  g_BonusAbil: TNakedAbility;
  g_NakedAbil: TNakedAbility;
  g_BonusAbilChg: TNakedAbility;

  g_sGuildName: string; //行会名称
  g_sGuildRankName: string; //职位名称

  g_dwLastAttackTick: LongWord; //最后攻击时间(包括物理攻击及魔法攻击)
  g_dwLastMoveTick: LongWord; //最后移动时间
  g_dwLatestStruckTick: LongWord; //最后弯腰时间
  g_dwLatestSpellTick: LongWord; //最后魔法攻击时间
  g_dwLatestFireHitTick: LongWord; //最后列火攻击时间
  g_dwLatestRushRushTick: LongWord; //最后被推动时间
  g_dwLatestHitTick: LongWord; //最后物理攻击时间(用来控制攻击状态不能退出游戏)
  g_dwLatestMagicTick: LongWord; //最后放魔法时间(用来控制攻击状态不能退出游戏)

  g_dwMagicDelayTime: LongWord;
  g_dwMagicPKDelayTime: LongWord;

  g_nMouseCurrX: Integer; //鼠标所在地图位置座标X
  g_nMouseCurrY: Integer; //鼠标所在地图位置座标Y
  g_nMouseX: Integer; //鼠标所在屏幕位置座标X
  g_nMouseY: Integer; //鼠标所在屏幕位置座标Y

  g_nTargetX: Integer; //目标座标
  g_nTargetY: Integer; //目标座标
  g_TargetCret: TActor;
  g_FocusCret: TActor;
  g_MagicTarget: TActor;

  g_boAttackSlow: Boolean; //腕力不够时慢动作攻击.
  g_boMoveSlow: Boolean; //负重不够时慢动作跑
  g_nMoveSlowLevel: Integer;
  g_boMapMoving: Boolean; //甘 捞悼吝, 钱副锭鳖瘤 捞悼 救凳
  g_boMapMovingWait: Boolean;
  g_boCheckBadMapMode: Boolean; //是否显示相关检查地图信息(用于调试)
  g_boCheckSpeedHackDisplay: Boolean; //是否显示机器速度数据
  g_boShowGreenHint: Boolean;
  g_boShowWhiteHint: Boolean;
  g_boViewMiniMap: Boolean; //是否显示小地图
  g_nViewMinMapLv: Integer; //Jacky 小地图显示模式(0为不显示，1为透明显示，2为清析显示)
  g_nMiniMapIndex: Integer; //小地图号

  //NPC 相关
  g_nCurMerchant: Integer; //弥辟俊 皋春甫 焊辰 惑牢
  g_nMDlgX: Integer;
  g_nMDlgY: Integer; //皋春甫 罐篮 镑
  g_dwChangeGroupModeTick: LongWord;
  g_dwDealActionTick: LongWord;
  g_dwQueryMsgTick: LongWord;
  g_nDupSelection: Integer;

  g_boAllowGroup: Boolean;

  //人物信息相关
  g_nMySpeedPoint: Integer; //敏捷
  g_nMyHitPoint: Integer; //准确
  g_nMyAntiPoison: Integer; //魔法躲避
  g_nMyPoisonRecover: Integer; //中毒恢复
  g_nMyHealthRecover: Integer; //体力恢复
  g_nMySpellRecover: Integer; //魔法恢复
  g_nMyAntiMagic: Integer; //魔法躲避
  g_nMyHungryState: Integer; //饥饿状态
  g_wAvailIDDay: Word;
  g_wAvailIDHour: Word;
  g_wAvailIPDay: Word;
  g_wAvailIPHour: Word;


  g_MySelf: THumActor;
  g_MyDrawActor: THumActor; //未用
  g_UseItems: array[0..12] of TClientItem;
  g_ItemArr: array[0..MAXBAGITEMCL - 1] of TClientItem;
  g_boBagLoaded: Boolean;
  g_boServerChanging: Boolean;

  //键盘相关
  g_ToolMenuHook: HHOOK;
  g_nLastHookKey: Integer;
  g_dwLastHookKeyTime: LongWord;

  g_nCaptureSerial: Integer; //抓图文件名序号
  g_nSendCount: Integer; //发送操作计数
  g_nReceiveCount: Integer; //接改操作状态计数
  g_nTestSendCount: Integer;
  g_nTestReceiveCount: Integer;
  g_nSpellCount: Integer; //使用魔法计数
  g_nSpellFailCount: Integer; //使用魔法失败计数
  g_nFireCount: Integer; //
  g_nDebugCount: Integer;
  g_nDebugCount1: Integer;
  g_nDebugCount2: Integer;

  //买卖相关
  g_SellDlgItem: TClientItem;
  g_SellDlgItemSellWait: TClientItem;
  g_DealDlgItem: TClientItem;
  g_boQueryPrice: Boolean;
  g_dwQueryPriceTime: LongWord;
  g_sSellPriceStr: string;

  //交易相关
  g_DealItems: array[0..9] of TClientItem;
  g_DealRemoteItems: array[0..19] of TClientItem;
  g_nDealGold: Integer;
  g_nDealRemoteGold: Integer;
  g_boDealEnd: Boolean;
  g_sDealWho: string; //交易对方名字
  g_MouseItem: TClientItem;
  g_MouseStateItem: TClientItem;
  g_MouseUserStateItem: TClientItem; //泅犁 付快胶啊 啊府虐绊 乐绰 酒捞袍

  g_boItemMoving: Boolean; //正在移动物品
  g_MovingItem: TMovingItem;
  g_WaitingUseItem: TMovingItem;
  g_FocusItem: pTDropItem;
  g_SHowWarningDura      :DWord;
  g_nAutoMagicKey        :Word;

  g_boViewFog: Boolean; //是否显示黑暗
  g_boForceNotViewFog: Boolean = True; //免蜡烛
  g_nDayBright: Integer;
  g_nAreaStateValue: Integer; //显示当前所在地图状态(攻城区域、)

  g_boNoDarkness: Boolean;
  g_nRunReadyCount: Integer; //助跑就绪次数，在跑前必须走几步助跑


  g_EatingItem: TClientItem;
  g_dwEatTime: LongWord; //timeout...


  g_dwDizzyDelayStart: LongWord;
  g_dwDizzyDelayTime: LongWord;

  g_boDoFadeOut: Boolean;
  g_boDoFadeIn: Boolean;
  g_nFadeIndex: Integer;
  g_boDoFastFadeOut: Boolean;

  g_boAutoDig: Boolean; //自动锄矿
  g_boSelectMyself: Boolean; //鼠标是否指到自己


  //游戏速度检测相关变量
  g_dwFirstServerTime: LongWord;
  g_dwFirstClientTime: LongWord;
  //ServerTimeGap: int64;
  g_nTimeFakeDetectCount: Integer;
  g_dwSHGetTime: LongWord;
  g_dwSHTimerTime: LongWord;
  g_nSHFakeCount: Integer; //检查机器速度异常次数，如果超过4次则提示速度不稳定

  g_dwLatestClientTime2: LongWord;
  g_dwFirstClientTimerTime: LongWord; //timer 矫埃
  g_dwLatestClientTimerTime: LongWord;
  g_dwFirstClientGetTime: LongWord; //gettickcount 矫埃
  g_dwLatestClientGetTime: LongWord;
  g_nTimeFakeDetectSum: Integer;
  g_nTimeFakeDetectTimer: Integer;

  g_dwLastestClientGetTime: LongWord;
  {******************************************************************************}
//新盛大内挂 20080624
  g_btSdoAssistantPage: Byte=0;
  g_btSdoAssistantHelpPage: Byte=0;
  g_dwAutoZhuRi           :LongWord;
  g_boAutoZhuRiHit        :Boolean;
  g_dwAutoLieHuo          :LongWord;
  g_nRandomType           :Byte;
  //时间间隔
  g_dwCommonHpTick        :LongWord; //普通HP保护的时间
  g_dwCommonMpTick        :LongWord; //普通MP保护的时间
  g_dwSpecialHpTick       :LongWord; //特殊HP保护的时间
  g_dwRandomHpTick        :LongWord;  //随机HP保护的时间

  g_boAutoEatWine         :Boolean;
  g_boAutoEatHeroWine     :Boolean;
  g_boAutoEatDrugWine     :Boolean;
  g_boAutoEatHeroDrugWine :Boolean;
  g_dwAutoEatWineTick     :LongWord; //人物喝普通酒的时间间隔
  g_dwAutoEatHeroWineTick :LongWord; //英雄喝普通酒的时间间隔
  g_dwAutoEatDrugWineTick :LongWord; //人物喝药洒的时间间隔
  g_dwAutoEatHeroDrugWineTick :LongWord; //英雄喝药酒的时间间隔
  g_btEditWine         :Byte;
  g_btEditHeroWine     :Byte;
  g_btEditDrugWine     :Byte;
  g_btEditHeroDrugWine :Byte;
  g_boHeroAutoDEfence   :Boolean = False;
{******************************************************************************}

{******************************************************************************}
//外挂功能变量开始
  g_nDuFuIndex           :Byte;   //自动毒符的索引  20080315
  g_nDuWhich             :byte;   //记录当前使用的是哪种毒 20080315
  g_boDownEsc            :boolean = false; //是否按下ESC键  20080314
  g_boTempShowItem       :boolean;   //按ESC键显示物品存的临时变量  20080314
  g_boTempFilterItemShow :boolean;   //按ESC键是否显示过滤物品存的临时变量  20080314
  g_boLoadSdoAssistantConfig :Boolean = False;
  g_nHitTime             :Integer  = 1400;  //攻击间隔时间间隔
  g_nItemSpeed           :Integer  = 60;
  g_dwSpellTime          :LongWord = 500;  //魔法攻间隔时间
  g_DeathColorEffect     :TColorEffect = ceGrayScale; //死亡颜色
  g_boCanRunHuman        :Boolean  = False;//是否可以穿人
  g_boCanRunMon          :Boolean  = False;//是否可以穿怪
  g_boCanRunNpc          :Boolean  = False;//是否可以穿NPC
  g_boCanRunAllInWarZone :Boolean  = False; //攻城区域是否传人穿怪穿NPC
  g_boCanStartRun        :Boolean  = true; //是否允许免助跑
  g_boParalyCanRun       :Boolean  = False;//麻痹是否可以跑
  g_boParalyCanWalk      :Boolean  = False;//麻痹是否可以走
  g_boParalyCanHit       :Boolean  = False;//麻痹是否可以攻击
  g_boParalyCanSpell     :Boolean  = False;//麻痹是否可以魔法
  g_boDuraWarning        :Boolean  = False; //物品持久警告
  g_boMagicLock          :Boolean  = False; //魔法锁定
  g_boAutoPuckUpItem     :Boolean  = False; //自动捡取物品
  //g_boMoveSlow1          :Boolean  = False; //免负重； 20080816注释掉起步负重
  g_boShowName           :Boolean  = False; //人名显示
  g_boNoShift            :Boolean  = False;  //免Shift
  g_AutoPut              :Boolean   =true;  //自动解包  
  g_boLongHit            :Boolean  = False;  //刀刀刺杀
  g_boAutoFireHit        :Boolean  = False;  //自动烈火
  g_boAutoWideHit        :Boolean  = False;  //智能半月
  g_boAutoHide           :Boolean  = False;  //自动隐身
  g_boAutoShield         :Boolean  = False;  //自动魔法盾
  g_boAutoMagic          :Boolean  = False;  //自动练功
  g_boCommonHp           :Boolean  = False;  //普通HP保护
  g_boCommonMp           :Boolean  = False;  //普通MP保护
  g_boSpecialHp          :Boolean  = False;  //特殊HP保护
  g_boRandomHp           :Boolean  = False;  //随机HP保护
  g_boFilterAutoItemUp   :Boolean  = False;  //过滤拾取
  g_boFilterAutoItemShow :Boolean  = False;  //过滤显示  
  g_boAutoTalk           :Boolean  = False;  //自动喊话
  g_sAutoTalkStr         :string;            //喊话内容
  g_boExpFiltrate        :Boolean  = False;  //经验显示过滤
//外挂功能变量结束
{******************************************************************************}
  g_nAutoTalkTimer       :LongWord = 8;  //自动喊话  间隔
  g_nEditCommonHpTimer   :LongWord = 0;  //普通HP保护   间隔
  g_nEditCommonMpTimer   :LongWord = 0;  //普通MP保护   间隔
  g_nEditSpecialHpTimer  :LongWord = 0;  //特殊HP保护   间隔
  g_nEditRandomHpTimer   :LongWord = 0;  //随机HP保护   间隔
  g_nEditCommonHp        :Integer  = 0;
  g_nEditCommonMp        :Integer  = 0;
  g_nEditSpecialHp       :Integer  = 0;
  g_nEditRandomHp        :Integer  = 0;
  g_sRandomName          :string;
  g_nAutoMagicTime       :LongWord = 0;
  g_nAutoMagicTimekick   :LongWord;
 g_nAutoMagic           :LongWord;
  g_boCanCIDHit          :Boolean; //龙影剑法
  g_boCanStnHit          :Boolean;
  g_boNextTimeFireHit    :Boolean; //烈火
  g_boNextTime4FireHit   :Boolean; //4级烈火
  g_boNextItemDAILYHit   :Boolean; //逐日剑法 20080511
  g_boCanQTwnHit         :Boolean; //轻击开天斩 2008.02.12

 // g_dwLastAttackTick        :LongWord;    //最后攻击时间(包括物理攻击及魔法攻击)
//  g_dwLastMoveTick          :LongWord;    //最后移动时间
 // g_dwLatestStruckTick      :LongWord;    //最后弯腰时间
//  g_dwLatestSpellTick       :LongWord;    //最后魔法攻击时间
//  g_dwLatestFireHitTick     :LongWord;    //最后列火攻击时间
  g_dwLatestTwnHitTick      :LongWord;    //最后开天斩攻击时间
  g_dwLatestDAILYHitTick    :LongWord;    //最后逐日剑法攻击时间  20080511
//  g_dwLatestRushRushTick    :LongWord;    //最后被推动时间
//  g_dwLatestHitTick         :LongWord;    //最后物理攻击时间(用来控制攻击状态不能退出游戏)
//  g_dwLatestMagicTick       :LongWord;    //最后放魔法时间(用来控制攻击状态不能退出游戏)


  g_dwAutoPickupTick: LongWord;
  g_dwAutoPickupTime: LongWord = 50; //自动捡物品间隔
  g_AutoPickupList: TList;
  g_MagicLockActor: TActor;
  g_boNextTimePowerHit: Boolean;
  g_boCanLongHit: Boolean;
  g_boCanWideHit: Boolean;
  g_boCanCrsHit: Boolean;
  g_boCanTwnHit: Boolean;
//  g_boCanStnHit: Boolean;
//  g_boNextTimeFireHit: Boolean;

  g_ShowItemList: TGList;
  g_boShowAllItem: Boolean = FALSE; //显示地面所有物品名称

  g_boDrawTileMap: Boolean = True;
  g_boDrawDropItem: Boolean = True;

  g_nTestX: Integer = 71;
  g_nTestY: Integer = 212;

  g_ShopItems: array[1..10] of TShopItem; //商铺物品
  g_SuperShopItems: array[1..5] of TShopItem;
  g_ShopItemList     :Tlist;
  g_MouseShopItems: TShopItem;

  g_FilterItemNameList   :TList;

  DlgConf: TConfig = (
    DBottom: (Image: 1; Left: 0; Top: 0; Width: 0; Height: 0);
    DMyState: (Image: 8; Left: 643; Top: 61; Width: 0; Height: 0);
    DMyBag: (Image: 9; Left: 682; Top: 41; Width: 0; Height: 0);
    DMyMagic: (Image: 10; Left: 722; Top: 21; Width: 0; Height: 0);
    DOption: (Image: 11; Left: 764; Top: 11; Width: 0; Height: 0);
    DBotMiniMap: (Image: 130; Left: 219; Top: 104; Width: 0; Height: 0);
    DBotTrade: (Image: 132; Left: 219 + 30; Top: 104; Width: 0; Height: 0);
    DBotGuild: (Image: 134; Left: 219 + 30 * 2; Top: 104; Width: 0; Height: 0);
    DBotGroup: (Image: 128; Left: 219 + 30 * 3; Top: 104; Width: 0; Height: 0);
    DBotPlusAbil: (Image: 140; Left: 219 + 30 * 6; Top: 104; Width: 0; Height: 0);
    DBotFriend: (Image: 34; Left: 219 + 30 * 5; Top: 104; Width: 0; Height: 0);
    DBotMemo: (Image: 532;
    Left: SCREENWIDTH div 2 + (SCREENWIDTH div 2 - (400 - 353)) {753};
    Top: 204;
    Width: 0;
    Height: 0);
    DBotExit: (Image: 138;
    Left: SCREENWIDTH div 2 + (SCREENWIDTH div 2 - (400 - 160)) {560};
    Top: 104;
    Width: 0;
    Height: 0);
    DBotLogout: (Image: 136;
    Left: SCREENWIDTH div 2 + (SCREENWIDTH div 2 - (400 - 160)) - 30 {560}; //Left:560 - 30;
    Top: 104;
    Width: 0;
    Height: 0);
    DBelt1: (Image: 0; Left: 285; Top: 59; Width: 32; Height: 29);
    DBelt2: (Image: 0; Left: 328; Top: 59; Width: 32; Height: 29);
    DBelt3: (Image: 0; Left: 371; Top: 59; Width: 32; Height: 29);
    DBelt4: (Image: 0; Left: 415; Top: 59; Width: 32; Height: 29);
    DBelt5: (Image: 0; Left: 459; Top: 59; Width: 32; Height: 29);
    DBelt6: (Image: 0; Left: 503; Top: 59; Width: 32; Height: 29);
    DGold: (Image: 29; Left: 10; Top: 190; Width: 0; Height: 0);
    DRepairItem: (Image: 26; Left: 254; Top: 183; Width: 48; Height: 22);
    DCloseBag: (Image: 371; Left: 309; Top: 203; Width: 14; Height: 20);
    DMerchantDlg: (Image: 384; Left: 0; Top: 0; Width: 0; Height: 0);
    DMerchantDlgClose: (Image: 64; Left: 399; Top: 1; Width: 0; Height: 0);
    DConfigDlg: (Image: 204; Left: 0; Top: 0; Width: 0; Height: 0);
    DConfigDlgOK: (Image: 361; Left: 514; Top: 287; Width: 0; Height: 0);
    DConfigDlgClose: (Image: 64; Left: 584; Top: 6; Width: 0; Height: 0);
    DMenuDlg: (Image: 385; Left: 138; Top: 163; Width: 0; Height: 0);
    DMenuPrev: (Image: 388; Left: 43; Top: 175; Width: 0; Height: 0);
    DMenuNext: (Image: 387; Left: 90; Top: 175; Width: 0; Height: 0);
    DMenuBuy: (Image: 386; Left: 215; Top: 171; Width: 0; Height: 0);
    DMenuClose: (Image: 64; Left: 291; Top: 0; Width: 0; Height: 0);
    DSellDlg: (Image: 392; Left: 328; Top: 163; Width: 0; Height: 0);
    DSellDlgOk: (Image: 393; Left: 85; Top: 150; Width: 0; Height: 0);
    DSellDlgClose: (Image: 64; Left: 115; Top: 0; Width: 0; Height: 0);
    DSellDlgSpot: (Image: 0; Left: 27; Top: 67; Width: 0; Height: 0);
    DKeySelDlg: (Image: 620; Left: 0; Top: 0; Width: 0; Height: 0);
    DKsIcon: (Image: 0; Left: 51; Top: 31; Width: 0; Height: 0);
    DKsF1: (Image: 232; Left: 25; Top: 78; Width: 0; Height: 0);
    DKsF2: (Image: 234; Left: 57; Top: 78; Width: 0; Height: 0);
    DKsF3: (Image: 236; Left: 89; Top: 78; Width: 0; Height: 0);
    DKsF4: (Image: 238; Left: 121; Top: 78; Width: 0; Height: 0);
    DKsF5: (Image: 240; Left: 160; Top: 78; Width: 0; Height: 0);
    DKsF6: (Image: 242; Left: 192; Top: 78; Width: 0; Height: 0);
    DKsF7: (Image: 244; Left: 224; Top: 78; Width: 0; Height: 0);
    DKsF8: (Image: 246; Left: 256; Top: 78; Width: 0; Height: 0);
    DKsConF1: (Image: 626; Left: 25; Top: 120; Width: 0; Height: 0);
    DKsConF2: (Image: 628; Left: 57; Top: 120; Width: 0; Height: 0);
    DKsConF3: (Image: 630; Left: 89; Top: 120; Width: 0; Height: 0);
    DKsConF4: (Image: 632; Left: 121; Top: 120; Width: 0; Height: 0);
    DKsConF5: (Image: 633; Left: 160; Top: 120; Width: 0; Height: 0);
    DKsConF6: (Image: 634; Left: 192; Top: 120; Width: 0; Height: 0);
    DKsConF7: (Image: 638; Left: 224; Top: 120; Width: 0; Height: 0);
    DKsConF8: (Image: 640; Left: 256; Top: 120; Width: 0; Height: 0);
    DKsNone: (Image: 623; Left: 296; Top: 78; Width: 0; Height: 0);
    DKsOk: (Image: 621; Left: 296; Top: 120; Width: 0; Height: 0);
    DChgGamePwd: (Image: 621; Left: 296; Top: 120; Width: 0; Height: 0);
    DChgGamePwdClose: (Image: 64; Left: 312; Top: 1; Width: 0; Height: 0);
    DItemGrid: (Image: 0; Left: 29; Top: 41; Width: 286; Height: 162);
    );
  g_wgConfig: TwgConfig = (
    SdoAssistantConf:(g_boShowAllItem : True;
                      g_boAutoPuckUpItem : True;
                      g_boFilterAutoItemShow : False;
                      g_boFilterAutoItemUp : False;
                      g_boNoShift : False;
                      g_boExpFiltrate : False; //20080714
                      g_boShowName : False;
                      g_boDuraWarning :True;


                      g_boCommonHp            : False;
                      g_nEditCommonHp         : 10;
                      g_nEditCommonHpTimer    : 4;
                      g_boCommonMp            : False;
                      g_nEditCommonMp         : 10;
                      g_nEditCommonMpTimer    : 4;
                      g_boSpecialHp           : False;
                      g_nEditSpecialHp        : 10;
                      g_nEditSpecialHpTimer   : 4;
                      g_boRandomHp            : False;
                      g_nEditRandomHp         : 10;
                      g_nEditRandomHpTimer    : 4;
                      g_nRandomType           : 0;
                      g_boLongHit             : False;
                      g_boAutoWideHit         : False;
                      g_boAutoFireHit         : False;
                      g_boAutoZhuriHit        : False;
                      g_boAutoShield          : False;
                      g_boHeroAutoShield      : False;
                      g_boAutoHide            : False;
                      g_boAutoMagic           : False;
                      g_nAutoMagicTime        : 4;
                      g_boAutoEatWine         : False;
                      g_boAutoEatHeroWine     : False;
                      g_boAutoEatDrugWine     : False;
                      g_boAutoEatHeroDrugWine : False;
                      g_btEditWine         : 10;
                      g_btEditHeroWine     : 10;
                      g_btEditDrugWine     : 10;
                      g_btEditHeroDrugWine : 10;
                      );
                           );
procedure InitObj();
procedure LoadWMImagesLib(aowner: TComponent);
procedure InitWMImagesLib(DDxDraw: TDXDraw);
procedure UnLoadWMImagesLib();
function GetObjs(nUnit, nIdx: Integer): TDirectDrawSurface;
function GetObjsEx(nUnit, nIdx: Integer; var px, py: Integer): TDirectDrawSurface;
function GetMonImg(nAppr: Integer): TWMImages;
function GetMonAction(nAppr: Integer): pTMonsterAction;
function GetJobName(nJob: Integer): string;


function GetShowItem(sItemName: string): pTShowItem;


  function LoadUserFilterConfig(): Boolean; //游戏盛大挂过滤物品名
  procedure CreateSdoAssistant();//初始化盛大内挂
  procedure LoadSdoAssistantConfig(sUserName:String);//加载盛大挂配置
  procedure SaveSdoAssistantConfig(sUserName:String);//储存盛大挂配置

implementation
uses FState, ClMain, HUtil32, Menus;

procedure LoadWMImagesLib(aowner: TComponent);
var
  i: Integer;
begin
  g_WMainImages := TWMImages.Create(aowner);
  g_WMain2Images := TWMImages.Create(aowner);
  g_WMain3Images := TWMImages.Create(aowner);
  g_WChrSelImages := TWMImages.Create(aowner);
  g_WMMapImages := TWMImages.Create(aowner);
  g_WTilesImages := TWMImages.Create(aowner);
  g_WSmTilesImages := TWMImages.Create(aowner);
  g_WHumWingImages := TWMImages.Create(aowner);
  g_WBagItemImages := TWMImages.Create(aowner);
  g_WStateItemImages := TWMImages.Create(aowner);
  g_WDnItemImages := TWMImages.Create(aowner);
  g_WHumImgImages := TWMImages.Create(aowner);
  g_WHairImgImages := TWMImages.Create(aowner);
  g_WWeaponImages := TWMImages.Create(aowner);
  g_WMagIconImages := TWMImages.Create(aowner);
  g_WNpcImgImages := TWMImages.Create(aowner);
  g_WMagicImages := TWMImages.Create(aowner);
  g_WMagic2Images := TWMImages.Create(aowner);
  g_WMagic3Images := TWMImages.Create(aowner);
  g_WMagic4Images := TWMImages.Create(aowner);
{$IF CUSTOMLIBFILE = 1}
  g_WEventEffectImages := TWMImages.Create(aowner);
{$IFEND}
  FillChar(g_WObjectArr, sizeof(g_WObjectArr), 0);
  FillChar(g_WMonImagesArr, sizeof(g_WMonImagesArr), 0);
end;

procedure InitWMImagesLib(DDxDraw: TDXDraw);
var
  sFileName: string;
  i: Integer;
begin
  g_WMainImages.DXDraw := DDxDraw;
  g_WMainImages.DDraw := DDxDraw.DDraw;
  g_WMainImages.FileName := MAINIMAGEFILE;
  g_WMainImages.LibType := ltUseCache;
  g_WMainImages.Initialize;

  g_WMain2Images.DXDraw := DDxDraw;
  g_WMain2Images.DDraw := DDxDraw.DDraw;
  g_WMain2Images.FileName := MAINIMAGEFILE2;
  g_WMain2Images.LibType := ltUseCache;
  g_WMain2Images.Initialize;

  g_WMain3Images.DXDraw := DDxDraw;
  g_WMain3Images.DDraw := DDxDraw.DDraw;
  g_WMain3Images.FileName := MAINIMAGEFILE3;
  g_WMain3Images.LibType := ltUseCache;
  g_WMain3Images.Initialize;

  g_WChrSelImages.DXDraw := DDxDraw;
  g_WChrSelImages.DDraw := DDxDraw.DDraw;
  g_WChrSelImages.FileName := CHRSELIMAGEFILE;
  g_WChrSelImages.LibType := ltUseCache;
  g_WChrSelImages.Initialize;

  g_WMMapImages.DXDraw := DDxDraw;
  g_WMMapImages.DDraw := DDxDraw.DDraw;
  g_WMMapImages.FileName := MINMAPIMAGEFILE;
  g_WMMapImages.LibType := ltUseCache;
  g_WMMapImages.Initialize;

  g_WTilesImages.DXDraw := DDxDraw;
  g_WTilesImages.DDraw := DDxDraw.DDraw;
  g_WTilesImages.FileName := TITLESIMAGEFILE;
  g_WTilesImages.LibType := ltUseCache;
  g_WTilesImages.Initialize;

  g_WSmTilesImages.DXDraw := DDxDraw;
  g_WSmTilesImages.DDraw := DDxDraw.DDraw;
  g_WSmTilesImages.FileName := SMLTITLESIMAGEFILE;
  g_WSmTilesImages.LibType := ltUseCache;
  g_WSmTilesImages.Initialize;

  g_WHumWingImages.DXDraw := DDxDraw;
  g_WHumWingImages.DDraw := DDxDraw.DDraw;
  g_WHumWingImages.FileName := HUMWINGIMAGESFILE;
  g_WHumWingImages.LibType := ltUseCache;
  g_WHumWingImages.Initialize;

  g_WBagItemImages.DXDraw := DDxDraw;
  g_WBagItemImages.DDraw := DDxDraw.DDraw;
  g_WBagItemImages.FileName := BAGITEMIMAGESFILE;
  g_WBagItemImages.LibType := ltUseCache;
  g_WBagItemImages.Initialize;

  g_WStateItemImages.DXDraw := DDxDraw;
  g_WStateItemImages.DDraw := DDxDraw.DDraw;
  g_WStateItemImages.FileName := STATEITEMIMAGESFILE;
  g_WStateItemImages.LibType := ltUseCache;
  g_WStateItemImages.Initialize;

  g_WDnItemImages.DXDraw := DDxDraw;
  g_WDnItemImages.DDraw := DDxDraw.DDraw;
  g_WDnItemImages.FileName := DNITEMIMAGESFILE;
  g_WDnItemImages.LibType := ltUseCache;
  g_WDnItemImages.Initialize;

  g_WHumImgImages.DXDraw := DDxDraw;
  g_WHumImgImages.DDraw := DDxDraw.DDraw;
  g_WHumImgImages.FileName := HUMIMGIMAGESFILE;
  g_WHumImgImages.LibType := ltUseCache;
  g_WHumImgImages.Initialize;

  g_WHairImgImages.DXDraw := DDxDraw;
  g_WHairImgImages.DDraw := DDxDraw.DDraw;
  g_WHairImgImages.FileName := HAIRIMGIMAGESFILE;
  g_WHairImgImages.LibType := ltUseCache;
  g_WHairImgImages.Initialize;

  g_WWeaponImages.DXDraw := DDxDraw;
  g_WWeaponImages.DDraw := DDxDraw.DDraw;
  g_WWeaponImages.FileName := WEAPONIMAGESFILE;
  g_WWeaponImages.LibType := ltUseCache;
  g_WWeaponImages.Initialize;

  g_WMagIconImages.DXDraw := DDxDraw;
  g_WMagIconImages.DDraw := DDxDraw.DDraw;
  g_WMagIconImages.FileName := MAGICONIMAGESFILE;
  g_WMagIconImages.LibType := ltUseCache;
  g_WMagIconImages.Initialize;

  g_WNpcImgImages.DXDraw := DDxDraw;
  g_WNpcImgImages.DDraw := DDxDraw.DDraw;
  g_WNpcImgImages.FileName := NPCIMAGESFILE;
  g_WNpcImgImages.LibType := ltUseCache;
  g_WNpcImgImages.Initialize;

  g_WMagicImages.DXDraw := DDxDraw;
  g_WMagicImages.DDraw := DDxDraw.DDraw;
  g_WMagicImages.FileName := MAGICIMAGESFILE;
  g_WMagicImages.LibType := ltUseCache;
  g_WMagicImages.Initialize;

  g_WMagic2Images.DXDraw := DDxDraw;
  g_WMagic2Images.DDraw := DDxDraw.DDraw;
  g_WMagic2Images.FileName := MAGIC2IMAGESFILE;
  g_WMagic2Images.LibType := ltUseCache;
  g_WMagic2Images.Initialize;

  g_WMagic3Images.DXDraw := DDxDraw;
  g_WMagic3Images.DDraw := DDxDraw.DDraw;
  g_WMagic3Images.FileName := MAGIC3IMAGESFILE;
  g_WMagic3Images.LibType := ltUseCache;
  g_WMagic3Images.Initialize;

  g_WMagic4Images.DXDraw := DDxDraw;
  g_WMagic4Images.DDraw := DDxDraw.DDraw;
  g_WMagic4Images.FileName := MAGIC4IMAGESFILE;
  g_WMagic4Images.LibType := ltUseCache;
  g_WMagic4Images.Initialize;

{$IF CUSTOMLIBFILE = 1}
  g_WEventEffectImages.DXDraw := DDxDraw;
  g_WEventEffectImages.DDraw := DDxDraw.DDraw;
  g_WEventEffectImages.FileName := EVENTEFFECTIMAGESFILE;
  g_WEventEffectImages.LibType := ltUseCache;
  g_WEventEffectImages.Initialize;
{$IFEND}
end;

procedure UnLoadWMImagesLib();
var
  i: Integer;
begin
  for i := Low(g_WObjectArr) to High(g_WObjectArr) do begin
    if g_WObjectArr[i] <> nil then begin
      g_WObjectArr[i].Finalize;
      g_WObjectArr[i].Free;
    end;
  end;
  for i := Low(g_WMonImagesArr) to High(g_WMonImagesArr) do begin
    if g_WMonImagesArr[i] <> nil then begin
      g_WMonImagesArr[i].Finalize;
      g_WMonImagesArr[i].Free;
    end;
  end;

  g_WMainImages.Finalize;
  g_WMainImages.Free;

  g_WMain2Images.Finalize;
  g_WMain2Images.Free;

  g_WMain3Images.Finalize;
  g_WMain3Images.Free;

  g_WChrSelImages.Finalize;
  g_WChrSelImages.Free;

  g_WMMapImages.Finalize;
  g_WMMapImages.Free;

  g_WTilesImages.Finalize;
  g_WTilesImages.Free;

  g_WSmTilesImages.Finalize;
  g_WSmTilesImages.Free;

  g_WHumWingImages.Finalize;
  g_WHumWingImages.Free;

  g_WBagItemImages.Finalize;
  g_WBagItemImages.Free;

  g_WStateItemImages.Finalize;
  g_WStateItemImages.Free;

  g_WDnItemImages.Finalize;
  g_WDnItemImages.Free;

  g_WHumImgImages.Finalize;
  g_WHumImgImages.Free;

  g_WHairImgImages.Finalize;
  g_WHairImgImages.Free;

  g_WWeaponImages.Finalize;
  g_WWeaponImages.Free;

  g_WMagIconImages.Finalize;
  g_WMagIconImages.Free;

  g_WNpcImgImages.Finalize;
  g_WNpcImgImages.Free;

  g_WMagicImages.Finalize;
  g_WMagicImages.Free;

  g_WMagic2Images.Finalize;
  g_WMagic2Images.Free;

  g_WMagic3Images.Finalize;
  g_WMagic3Images.Free;

  g_WMagic4Images.Finalize;
  g_WMagic4Images.Free;

{$IF CUSTOMLIBFILE = 1}
  g_WEventEffectImages.Finalize;
  g_WEventEffectImages.Free;
{$IFEND}
end;
//取地图图库
function GetObjs(nUnit, nIdx: Integer): TDirectDrawSurface;
var
  sFileName: string;
begin
  Result := nil;
  if not (nUnit in [Low(g_WObjectArr)..High(g_WObjectArr)]) then nUnit := 0;
  if g_WObjectArr[nUnit] = nil then begin
    if nUnit = 0 then sFileName := OBJECTIMAGEFILE
    else sFileName := format(OBJECTIMAGEFILE1, [nUnit + 1]);
    if not FileExists(sFileName) then Exit;
    g_WObjectArr[nUnit] := TWMImages.Create(nil);
    g_WObjectArr[nUnit].DXDraw := g_DXDraw;
    g_WObjectArr[nUnit].DDraw := g_DXDraw.DDraw;
    g_WObjectArr[nUnit].FileName := sFileName;
    g_WObjectArr[nUnit].LibType := ltUseCache;
    g_WObjectArr[nUnit].Initialize;
  end;
  Result := g_WObjectArr[nUnit].Images[nIdx];
end;
//取地图图库
function GetObjsEx(nUnit, nIdx: Integer; var px, py: Integer): TDirectDrawSurface;
var
  sFileName: string;
begin
  Result := nil;
  if not (nUnit in [Low(g_WObjectArr)..High(g_WObjectArr)]) then nUnit := 0;
  if g_WObjectArr[nUnit] = nil then begin

    if nUnit = 0 then sFileName := OBJECTIMAGEFILE
    else sFileName := format(OBJECTIMAGEFILE1, [nUnit + 1]);

    if not FileExists(sFileName) then Exit;
    g_WObjectArr[nUnit] := TWMImages.Create(nil);
    g_WObjectArr[nUnit].DXDraw := g_DXDraw;
    g_WObjectArr[nUnit].DDraw := g_DXDraw.DDraw;
    g_WObjectArr[nUnit].FileName := sFileName;
    g_WObjectArr[nUnit].LibType := ltUseCache;
    g_WObjectArr[nUnit].Initialize;
  end;
  Result := g_WObjectArr[nUnit].GetCachedImage(nIdx, px, py);
end;
function GetMonImg(nAppr: Integer): TWMImages;
var
  sFileName: string;
  nUnit: Integer;
begin
  Result := nil;
  if nAppr < 1000 then nUnit := nAppr div 10
  else nUnit := nAppr;

  if (nUnit < Low(g_WMonImagesArr)) or (nUnit > High(g_WMonImagesArr)) then nUnit := 0;
  if g_WMonImagesArr[nUnit] = nil then begin

    sFileName := format(MONIMAGEFILE, [nUnit + 1]);
    if nUnit = 80 then sFileName := DRAGONIMAGEFILE;
    if nUnit = 90 then sFileName := EFFECTIMAGEFILE;
    if nUnit >= 1000 then sFileName := format(MONIMAGEFILEEX, [nUnit]); //超过1000序号的怪物取新的怪物文件

    g_WMonImagesArr[nUnit] := TWMImages.Create(nil);
    g_WMonImagesArr[nUnit].DXDraw := g_DXDraw;
    g_WMonImagesArr[nUnit].DDraw := g_DXDraw.DDraw;
    g_WMonImagesArr[nUnit].FileName := sFileName;
    g_WMonImagesArr[nUnit].LibType := ltUseCache;
    g_WMonImagesArr[nUnit].Initialize;
  end;
  Result := g_WMonImagesArr[nUnit];
end;
function GetMonAction(nAppr: Integer): pTMonsterAction;
var
  FileStream: TFileStream;
  sFileName: string;
  MonsterAction: TMonsterAction;
begin
  Result := nil;
  sFileName := format(MONPMFILE, [nAppr]);
  if FileExists(sFileName) then begin
    FileStream := TFileStream.Create(sFileName, fmOpenRead or fmShareDenyNone);
    FileStream.Read(MonsterAction, sizeof(MonsterAction));
    new(Result);
    Result^ := MonsterAction;
    FileStream.Free;
  end;
end;

//取得职业名称
//0 武士
//1 魔法师
//2 道士
function GetJobName(nJob: Integer): string;
begin
  Result := '';
  case nJob of
    0: Result := g_sWarriorName;
    1: Result := g_sWizardName;
    2: Result := g_sTaoistName;
    else begin
        Result := g_sUnKnowName;
      end;
  end;
end;
function GetShowItem(sItemName:String):pTShowItem;
var
  I:Integer;
begin
  Result:=nil;
  if g_FilterItemNameList.Count > 0 then begin//20080629
    for I := 0 to g_FilterItemNameList.Count - 1 do begin
      if CompareText(pTShowItem(g_FilterItemNameList.Items[I]).sItemName,sItemName) = 0 then begin
        Result:=g_FilterItemNameList.Items[I];
        break;
      end;
    end;
  end;
end;
procedure InitObj();
begin
  DlgConf.DMsgDlg.Obj := FrmDlg.DMsgDlg;
  DlgConf.DMsgDlgOk.Obj := FrmDlg.DMsgDlgOk;
  DlgConf.DMsgDlgYes.Obj := FrmDlg.DMsgDlgYes;
  DlgConf.DMsgDlgCancel.Obj := FrmDlg.DMsgDlgCancel;
  DlgConf.DMsgDlgNo.Obj := FrmDlg.DMsgDlgNo;
  DlgConf.DLogin.Obj := FrmDlg.DLogin;
  DlgConf.DLoginNew.Obj := FrmDlg.DLoginNew;
  DlgConf.DLoginOk.Obj := FrmDlg.DLoginOk;
  DlgConf.DLoginChgPw.Obj := FrmDlg.DLoginChgPw;
  DlgConf.DLoginClose.Obj := FrmDlg.DLoginClose;
  DlgConf.DSelServerDlg.Obj := FrmDlg.DSelServerDlg;
  DlgConf.DSSrvClose.Obj := FrmDlg.DSSrvClose;
  DlgConf.DSServer1.Obj := FrmDlg.DSServer1;
  DlgConf.DSServer2.Obj := FrmDlg.DSServer2;
  DlgConf.DSServer3.Obj := FrmDlg.DSServer3;
  DlgConf.DSServer4.Obj := FrmDlg.DSServer4;
  DlgConf.DSServer5.Obj := FrmDlg.DSServer5;
  DlgConf.DSServer6.Obj := FrmDlg.DSServer6;
  DlgConf.DNewAccount.Obj := FrmDlg.DNewAccount;
  DlgConf.DNewAccountOk.Obj := FrmDlg.DNewAccountOk;
  DlgConf.DNewAccountCancel.Obj := FrmDlg.DNewAccountCancel;
  DlgConf.DNewAccountClose.Obj := FrmDlg.DNewAccountClose;
  DlgConf.DChgPw.Obj := FrmDlg.DChgPw;
  DlgConf.DChgpwOk.Obj := FrmDlg.DChgpwOk;
  DlgConf.DChgpwCancel.Obj := FrmDlg.DChgpwCancel;
  DlgConf.DSelectChr.Obj := FrmDlg.DSelectChr;
  DlgConf.DBottom.Obj := FrmDlg.DBottom;
  DlgConf.DMyState.Obj := FrmDlg.DMyState;
  DlgConf.DMyBag.Obj := FrmDlg.DMyBag;
  DlgConf.DMyMagic.Obj := FrmDlg.DMyMagic;
  DlgConf.DOption.Obj := FrmDlg.DOption;
  DlgConf.DBotMiniMap.Obj := FrmDlg.DBotMiniMap;
  DlgConf.DBotTrade.Obj := FrmDlg.DBotTrade;
  DlgConf.DBotGuild.Obj := FrmDlg.DBotGuild;
  DlgConf.DBotGroup.Obj := FrmDlg.DBotGroup;
  DlgConf.DBotPlusAbil.Obj := FrmDlg.DBotPlusAbil;
  //DlgConf.DBotFriend.Obj := FrmDlg.DBotFriend;
  DlgConf.DBotMemo.Obj := FrmDlg.DBotMemo;
  DlgConf.DBotExit.Obj := FrmDlg.DBotExit;
  DlgConf.DBotLogout.Obj := FrmDlg.DBotLogout;
  DlgConf.DBelt1.Obj := FrmDlg.DBelt1;
  DlgConf.DBelt2.Obj := FrmDlg.DBelt2;
  DlgConf.DBelt3.Obj := FrmDlg.DBelt3;
  DlgConf.DBelt4.Obj := FrmDlg.DBelt4;
  DlgConf.DBelt5.Obj := FrmDlg.DBelt5;
  DlgConf.DBelt6.Obj := FrmDlg.DBelt6;
  DlgConf.DGold.Obj := FrmDlg.DGold;
  DlgConf.DRepairItem.Obj := FrmDlg.DRepairItem;
  DlgConf.DCloseBag.Obj := FrmDlg.DCloseBag;
  DlgConf.DMerchantDlg.Obj := FrmDlg.DMerchantDlg;
  DlgConf.DMerchantDlgClose.Obj := FrmDlg.DMerchantDlgClose;
  DlgConf.DConfigDlg.Obj := FrmDlg.DConfigDlg;
  DlgConf.DConfigDlgOK.Obj := FrmDlg.DConfigDlgOK;
  DlgConf.DConfigDlgClose.Obj := FrmDlg.DConfigDlgClose;
  DlgConf.DMenuDlg.Obj := FrmDlg.DMenuDlg;
  DlgConf.DMenuPrev.Obj := FrmDlg.DMenuPrev;
  DlgConf.DMenuNext.Obj := FrmDlg.DMenuNext;
  DlgConf.DMenuBuy.Obj := FrmDlg.DMenuBuy;
  DlgConf.DMenuClose.Obj := FrmDlg.DMenuClose;
  DlgConf.DSellDlg.Obj := FrmDlg.DSellDlg;
  DlgConf.DSellDlgOk.Obj := FrmDlg.DSellDlgOk;
  DlgConf.DSellDlgClose.Obj := FrmDlg.DSellDlgClose;
  DlgConf.DSellDlgSpot.Obj := FrmDlg.DSellDlgSpot;
  DlgConf.DKeySelDlg.Obj := FrmDlg.DKeySelDlg;
  DlgConf.DKsIcon.Obj := FrmDlg.DKsIcon;
  DlgConf.DKsF1.Obj := FrmDlg.DKsF1;
  DlgConf.DKsF2.Obj := FrmDlg.DKsF2;
  DlgConf.DKsF3.Obj := FrmDlg.DKsF3;
  DlgConf.DKsF4.Obj := FrmDlg.DKsF4;
  DlgConf.DKsF5.Obj := FrmDlg.DKsF5;
  DlgConf.DKsF6.Obj := FrmDlg.DKsF6;
  DlgConf.DKsF7.Obj := FrmDlg.DKsF7;
  DlgConf.DKsF8.Obj := FrmDlg.DKsF8;
  DlgConf.DKsConF1.Obj := FrmDlg.DKsConF1;
  DlgConf.DKsConF2.Obj := FrmDlg.DKsConF2;
  DlgConf.DKsConF3.Obj := FrmDlg.DKsConF3;
  DlgConf.DKsConF4.Obj := FrmDlg.DKsConF4;
  DlgConf.DKsConF5.Obj := FrmDlg.DKsConF5;
  DlgConf.DKsConF6.Obj := FrmDlg.DKsConF6;
  DlgConf.DKsConF7.Obj := FrmDlg.DKsConF7;
  DlgConf.DKsConF8.Obj := FrmDlg.DKsConF8;
  DlgConf.DKsNone.Obj := FrmDlg.DKsNone;
  DlgConf.DKsOk.Obj := FrmDlg.DKsOk;
  DlgConf.DItemGrid.Obj := FrmDlg.DItemGrid;
end;
function LoadUserFilterConfig(): Boolean; //游戏盛大挂过滤物品名
var
  I: Integer;
  sFileName: string;
  LoadList: TStringList;
  sLineText: string;
  sItemName: string;
  sCanPick: string;
  sCanShow: string;
  ShowItem: pTShowItem;
begin
  Result := False;
  if g_FilterItemNameList <> nil then begin
    if g_FilterItemNameList.Count > 0 then //20080629
    for I := 0 to g_FilterItemNameList.Count - 1 do begin
      ShowItem := pTShowItem(g_FilterItemNameList.Items[I]);
      if ShowItem <> nil then
        DisPose(ShowItem);
    end;
    g_FilterItemNameList.Free;
    g_FilterItemNameList := nil;
  end;
  if g_FilterItemNameList = nil then
  g_FilterItemNameList := TList.Create(); //过滤列表创建
  sFileName := ExtractFilePath(ParamStr(0)) + 'FilterItemNameList.txt';
  if not FileExists(sFileName) then Exit;
  LoadList := TStringList.Create();
  LoadList.LoadFromFile(sFileName);
  if LoadList.Count > 0 then //20080629
  for I := 0 to LoadList.Count - 1 do begin
    sLineText := LoadList.Strings[I];
    if (sLineText <> '') and (sLineText[1] <> ';') then begin
      sLineText := GetValidStr3(sLineText, sItemName, [' ', #9]);
      sLineText := GetValidStr3(sLineText, sCanPick, [' ', #9]);
      sLineText := GetValidStr3(sLineText, sCanShow, [' ', #9]);
      if (sItemName <> '') then begin
        New(ShowItem);
        ShowItem.sItemName := sItemName;
        ShowItem.boAutoPickup := sCanPick = '1';
        ShowItem.boShowName := sCanShow = '1';
        g_FilterItemNameList.Add(ShowItem);
      end;
    end;
  end;
  Result := True;
  LoadList.Free;
end;    
procedure CreateSdoAssistant();//初始化盛大内挂
begin
    with FrmDlg do begin
     {if g_config.SdoAssistantConf.g_boShowAllItem then begin
          DCheckSdoItemsHint.Checked := True;
          g_boShowAllItem := DCheckSdoItemsHint.Checked;
     end;}
     DCheckSdoItemsHint.Checked := g_wgconfig.SdoAssistantConf.g_boShowAllItem;
     g_boShowAllItem := DCheckSdoItemsHint.Checked;
     {if g_config.SdoAssistantConf.g_boAutoPuckUpItem then begin
          DCheckSdoAutoPickItems.Checked := True;
          g_boAutoPuckUpItem := DCheckSdoAutoPickItems.Checked;
     end;}
     DCheckSdoAutoPickItems.Checked := g_wgconfig.SdoAssistantConf.g_boAutoPuckUpItem;
     g_boAutoPuckUpItem := DCheckSdoAutoPickItems.Checked;
     {if g_config.SdoAssistantConf.g_boFilterAutoItemShow then begin
          DCheckSdoShowFiltrate.Checked := True;
          g_boFilterAutoItemShow := DCheckSdoShowFiltrate.Checked;
     end;}
     DCheckSdoShowFiltrate.Checked := g_wgconfig.SdoAssistantConf.g_boFilterAutoItemShow;
     g_boFilterAutoItemShow := DCheckSdoShowFiltrate.Checked;
     {if g_config.SdoAssistantConf.g_boFilterAutoItemUp then begin
          DCheckSdoPickFiltrate.Checked := True;
          g_boFilterAutoItemUp := DCheckSdoPickFiltrate.Checked;
     end;}
     DCheckSdoPickFiltrate.Checked := g_wgconfig.SdoAssistantConf.g_boFilterAutoItemUp;
     g_boFilterAutoItemUp := DCheckSdoPickFiltrate.Checked;
     {if g_config.SdoAssistantConf.g_boNoShift then begin
        DCheckSdoAvoidShift.Checked := True;
        g_boNoShift := DCheckSdoAvoidShift.Checked;
     end;}
     DCheckSdoAvoidShift.Checked := g_wgconfig.SdoAssistantConf.g_boNoShift;
     g_boNoShift := DCheckSdoAvoidShift.Checked;
     {if g_Config.SdoAssistantConf.g_boExpFiltrate then begin
        DCheckSdoExpFiltrate.Checked := True;
        g_boExpFiltrate := DCheckSdoExpFiltrate.Checked;
     end;}
     DCheckSdoExpFiltrate.Checked := g_wgconfig.SdoAssistantConf.g_boExpFiltrate ;
     g_boExpFiltrate := DCheckSdoExpFiltrate.Checked;
     {if g_config.SdoAssistantConf.g_boShowName then begin
          DCheckSdoNameShow.Checked := True;
          g_boShowName := DCheckSdoNameShow.Checked;
     end;}
     DCheckSdoNameShow.Checked := g_wgconfig.SdoAssistantConf.g_boShowName;
     g_boShowName := DCheckSdoNameShow.Checked;
     {if g_config.SdoAssistantConf.g_boDuraWarning then begin
        DCheckSdoDuraWarning.Checked := True;
        g_boDuraWarning := DCheckSdoDuraWarning.Checked;
     end;}
     DCheckSdoDuraWarning.Checked := g_wgconfig.SdoAssistantConf.g_boDuraWarning;
     g_boDuraWarning := DCheckSdoDuraWarning.Checked;

     {if g_config.SdoAssistantConf.g_boCommonHp then begin
        DCheckSdoCommonHp.Checked := True;
        g_boCommonHp := DCheckSdoCommonHp.Checked;
     end;}
     DCheckSdoCommonHp.Checked := g_wgconfig.SdoAssistantConf.g_boCommonHp;
     g_boCommonHp := DCheckSdoCommonHp.Checked;

     DEdtSdoCommonHp.Text := IntToStr(g_wgconfig.SdoAssistantConf.g_nEditCommonHp);
     DEdtSdoCommonHpChange(DEdtSdoCommonHp);
     DEdtSdoCommonHpTimer.Text := IntToStr(g_wgconfig.SdoAssistantConf.g_nEditCommonHpTimer);
     DEdtSdoCommonHpChange(DEdtSdoCommonHpTimer);

     {if g_config.SdoAssistantConf.g_boCommonMp then begin
        DCheckSdoCommonMp.Checked := True;
        g_boCommonMp := DCheckSdoCommonMp.Checked;
     end; }
     DCheckSdoCommonMp.Checked := g_wgconfig.SdoAssistantConf.g_boCommonMp;
     g_boCommonMp := DCheckSdoCommonMp.Checked;

     DEdtSdoCommonMp.Text := IntToStr(g_wgconfig.SdoAssistantConf.g_nEditCommonMp);
     DEdtSdoCommonHpChange(DEdtSdoCommonMp);
     DEdtSdoCommonMpTimer.Text := IntToStr(g_wgconfig.SdoAssistantConf.g_nEditCommonMpTimer);
     DEdtSdoCommonHpChange(DEdtSdoCommonMpTimer);

     {if g_config.SdoAssistantConf.g_boSpecialHp then begin
        DCheckSdoSpecialHp.Checked := True;
        g_boSpecialHp := DCheckSdoSpecialHp.Checked;
     end;}
     DCheckSdoSpecialHp.Checked := g_wgconfig.SdoAssistantConf.g_boSpecialHp;
     g_boSpecialHp := DCheckSdoSpecialHp.Checked;

     DEdtSdoSpecialHp.Text := IntToStr(g_wgconfig.SdoAssistantConf.g_nEditSpecialHp);
     DEdtSdoCommonHpChange(DEdtSdoSpecialHp);
     DEdtSdoSpecialHpTimer.Text := IntToStr(g_wgconfig.SdoAssistantConf.g_nEditSpecialHpTimer);
     DEdtSdoCommonHpChange(DEdtSdoSpecialHpTimer);
     {if g_config.SdoAssistantConf.g_boRandomHp then begin
        DCheckSdoRandomHp.Checked := True;
        g_boRandomHp := DCheckSdoRandomHp.Checked;
     end;}
     DCheckSdoRandomHp.Checked := g_wgconfig.SdoAssistantConf.g_boRandomHp;
     g_boRandomHp := DCheckSdoRandomHp.Checked;

     DEdtSdoRandomHp.Text := IntToStr(g_wgconfig.SdoAssistantConf.g_nEditRandomHp);
     DEdtSdoCommonHpChange(DEdtSdoRandomHp);
     DEdtSdoRandomHpTimer.Text := IntToStr(g_wgconfig.SdoAssistantConf.g_nEditRandomHpTimer);
     DEdtSdoCommonHpChange(DEdtSdoRandomHpTimer);
     g_nRandomType := g_wgconfig.SdoAssistantConf.g_nRandomType;
     {if g_config.SdoAssistantConf.g_boLongHit then begin
           DCheckSdoLongHit.Checked:= True;
           g_boLongHit := DCheckSdoLongHit.Checked;
     end; }
     DCheckSdoLongHit.Checked:= g_wgconfig.SdoAssistantConf.g_boLongHit;
     g_boLongHit := DCheckSdoLongHit.Checked;

     {if g_config.SdoAssistantConf.g_boAutoWideHit then begin
          DCheckSdoAutoWideHit.Checked := True;
          g_boAutoWideHit := DCheckSdoAutoWideHit.Checked;
     end;}
     DCheckSdoAutoWideHit.Checked := g_wgconfig.SdoAssistantConf.g_boAutoWideHit;
     g_boAutoWideHit := DCheckSdoAutoWideHit.Checked;
     
     {if g_config.SdoAssistantConf.g_boAutoFireHit then begin
          DCheckSdoAutoFireHit.Checked := True;
          g_boAutoFireHit := DCheckSdoAutoFireHit.Checked;
     end;}
     DCheckSdoAutoFireHit.Checked := g_wgconfig.SdoAssistantConf.g_boAutoFireHit;
     g_boAutoFireHit := DCheckSdoAutoFireHit.Checked;
     
     {if g_config.SdoAssistantConf.g_boAutoZhuRiHit then begin
          DCheckSdoZhuri.Checked := True;
          g_boAutoZhuRiHit := DCheckSdoZhuri.Checked;
     end;}
     DCheckSdoZhuri.Checked := g_wgconfig.SdoAssistantConf.g_boAutoZhuRiHit;
     g_boAutoZhuRiHit := DCheckSdoZhuri.Checked;

     {if g_config.SdoAssistantConf.g_boAutoShield then begin
           DCheckSdoAutoShield.Checked := True;
           g_boAutoShield := DCheckSdoAutoShield.Checked;
     end;}
     DCheckSdoAutoShield.Checked := g_wgconfig.SdoAssistantConf.g_boAutoShield;
     g_boAutoShield := DCheckSdoAutoShield.Checked;

     DCheckSdoHeroShield.Checked := g_wgconfig.SdoAssistantConf.g_boHeroAutoShield;
     g_boHeroAutoDEfence := DCheckSdoHeroShield.Checked;

     {if g_config.SdoAssistantConf.g_boAutoHide then begin
          DCheckSdoAutoHide.Checked := True;
          g_boAutoHide := DCheckSdoAutoHide.Checked;
     end; }
     DCheckSdoAutoHide.Checked := g_wgconfig.SdoAssistantConf.g_boAutoHide;
     g_boAutoHide := DCheckSdoAutoHide.Checked;

     {if g_config.SdoAssistantConf.g_boAutoMagic then  begin
        DCheckSdoAutoMagic.Checked := True;
        g_boAutoMagic := DCheckSdoAutoMagic.Checked;
     end; }
     DCheckSdoAutoMagic.Checked := g_wgconfig.SdoAssistantConf.g_boAutoMagic;
     g_boAutoMagic := DCheckSdoAutoMagic.Checked;

     DEdtSdoAutoMagicTimer.Text := IntToStr(g_wgconfig.SdoAssistantConf.g_nAutoMagicTime);
     DEdtSdoCommonHpChange(DEdtSdoAutoMagicTimer);

     DCheckSdoAutoDrinkWine.Checked := g_wgconfig.SdoAssistantConf.g_boAutoEatWine;
     g_boAutoEatWine := DCheckSdoAutoDrinkWine.Checked;

     DEdtSdoDrunkWineDegree.Text := IntToStr(g_wgconfig.SdoAssistantConf.g_btEditWine);
     DEdtSdoCommonHpChange(DEdtSdoDrunkWineDegree);

     DCheckSdoHeroAutoDrinkWine.Checked := g_wgconfig.SdoAssistantConf.g_boAutoEatHeroWine;
     g_boAutoEatHeroWine := DCheckSdoHeroAutoDrinkWine.Checked;

     DEdtSdoHeroDrunkWineDegree.Text := IntToStr(g_wgconfig.SdoAssistantConf.g_btEditHeroWine);
     DEdtSdoCommonHpChange(DEdtSdoHeroDrunkWineDegree);

     DCheckSdoAutoDrinkDrugWine.Checked := g_wgconfig.SdoAssistantConf.g_boAutoEatDrugWine;
     g_boAutoEatDrugWine := DCheckSdoAutoDrinkDrugWine.Checked;

     DEdtSdoDrunkDrugWineDegree.Text := IntToStr(g_wgconfig.SdoAssistantConf.g_btEditDrugWine);
     DEdtSdoCommonHpChange(DEdtSdoDrunkDrugWineDegree);

     DCheckSdoHeroAutoDrinkDrugWine.Checked := g_wgconfig.SdoAssistantConf.g_boAutoEatHeroDrugWine;
     g_boAutoEatHeroDrugWine := DCheckSdoHeroAutoDrinkDrugWine.Checked;

     DEdtSdoHeroDrunkDrugWineDegree.Text := IntToStr(g_wgconfig.SdoAssistantConf.g_btEditHeroDrugWine);
     DEdtSdoCommonHpChange(DEdtSdoHeroDrunkDrugWineDegree);



   end;
end;

procedure LoadSdoAssistantConfig(sUserName:String);//加载盛大挂配置
var
  Ini: TIniFile;
  sFileName: String;
  LoadInteger: Integer;
begin
  if sUserName <> '' then sFileName := format(SDOCONFIGFILE,[g_sServerName,sUserName,'SdoAssistant'])
    else sFileName:=format(CONFIGFILE,['Assistant']);
  if not DirectoryExists('config') then  CreateDir('config');
  if not DirectoryExists(format('config\LB%s_%s',[g_sServerName,sUserName])) then
    CreateDir(format('config\LB%s_%s',[g_sServerName,sUserName]));
  Ini:=TIniFile.Create(sFileName);
  try
    if Ini.ReadInteger('Assistant', 'ShowAllItem', -1) < 0 then Ini.WriteBool('Assistant', 'ShowAllItem', True);
    g_wgConfig.SdoAssistantConf.g_boShowAllItem := Ini.ReadBool('Assistant', 'ShowAllItem', g_wgConfig.SdoAssistantConf.g_boShowAllItem);

    if Ini.ReadInteger('Assistant', 'AutoPuckUpItem', -1) < 0 then Ini.WriteBool('Assistant', 'AutoPuckUpItem', True);
    g_wgConfig.SdoAssistantConf.g_boAutoPuckUpItem := Ini.ReadBool('Assistant', 'AutoPuckUpItem', g_wgConfig.SdoAssistantConf.g_boAutoPuckUpItem);

    if Ini.ReadInteger('Assistant', 'FilterAutoItemShow', -1) < 0 then Ini.WriteBool('Assistant', 'FilterAutoItemShow', True);
    g_wgConfig.SdoAssistantConf.g_boFilterAutoItemShow := Ini.ReadBool('Assistant', 'FilterAutoItemShow', g_wgConfig.SdoAssistantConf.g_boFilterAutoItemShow);

    if Ini.ReadInteger('Assistant', 'FilterAutoItemUp', -1) < 0 then Ini.WriteBool('Assistant', 'FilterAutoItemUp', True);
    g_wgConfig.SdoAssistantConf.g_boFilterAutoItemUp := Ini.ReadBool('Assistant', 'FilterAutoItemUp', g_wgConfig.SdoAssistantConf.g_boFilterAutoItemUp);

    if Ini.ReadInteger('Assistant', 'NoShift', -1) < 0 then Ini.WriteBool('Assistant', 'NoShift', False);
    g_wgConfig.SdoAssistantConf.g_boNoShift := Ini.ReadBool('Assistant', 'NoShift', g_wgConfig.SdoAssistantConf.g_boNoShift);

    if Ini.ReadInteger('Assistant', 'ExpFiltrate', -1) < 0 then Ini.WriteBool('Assistant', 'ExpFiltrate', False);
    g_wgConfig.SdoAssistantConf.g_boExpFiltrate := Ini.ReadBool('Assistant', 'ExpFiltrate', g_wgConfig.SdoAssistantConf.g_boExpFiltrate);

    if Ini.ReadInteger('Assistant', 'ShowName', -1) < 0 then Ini.WriteBool('Assistant', 'ShowName', False);
    g_wgConfig.SdoAssistantConf.g_boShowName := Ini.ReadBool('Assistant', 'ShowName', g_wgConfig.SdoAssistantConf.g_boShowName);

    if Ini.ReadInteger('Assistant', 'DuraWarning', -1) < 0 then Ini.WriteBool('Assistant', 'DuraWarning', True);
    g_wgConfig.SdoAssistantConf.g_boDuraWarning := Ini.ReadBool('Assistant', 'DuraWarning', g_wgConfig.SdoAssistantConf.g_boDuraWarning);

    if Ini.ReadInteger('Assistant', 'CommonHp', -1) < 0 then Ini.WriteBool('Assistant', 'CommonHp', False);
    g_wgConfig.SdoAssistantConf.g_boCommonHp := Ini.ReadBool('Assistant', 'CommonHp', g_wgConfig.SdoAssistantConf.g_boCommonHp);

    LoadInteger := Ini.ReadInteger('Assistant', 'EditCommonHp', -1);
    if LoadInteger < 0 then begin
      Ini.WriteInteger('Assistant', 'EditCommonHp', g_wgConfig.SdoAssistantConf.g_nEditCommonHp);
    end else begin
      g_wgConfig.SdoAssistantConf.g_nEditCommonHp := Ini.ReadInteger('Assistant', 'EditCommonHp', g_wgConfig.SdoAssistantConf.g_nEditCommonHp);
    end;

    LoadInteger := Ini.ReadInteger('Assistant', 'EditCommonHpTimer', -1);
    if LoadInteger < 0 then begin
      Ini.WriteInteger('Assistant', 'EditCommonHpTimer', g_wgConfig.SdoAssistantConf.g_nEditCommonHpTimer);
    end else begin
      g_wgConfig.SdoAssistantConf.g_nEditCommonHpTimer := Ini.ReadInteger('Assistant', 'EditCommonHpTimer', g_wgConfig.SdoAssistantConf.g_nEditCommonHpTimer);
    end;

    if Ini.ReadInteger('Assistant', 'CommonMp', -1) < 0 then Ini.WriteBool('Assistant', 'CommonMp', False);
    g_wgConfig.SdoAssistantConf.g_boCommonMp := Ini.ReadBool('Assistant', 'CommonMp', g_wgConfig.SdoAssistantConf.g_boCommonMp);

    LoadInteger := Ini.ReadInteger('Assistant', 'EditCommonMp', -1);
    if LoadInteger < 0 then begin
      Ini.WriteInteger('Assistant', 'EditCommonMp', g_wgConfig.SdoAssistantConf.g_nEditCommonMp);
    end else begin
      g_wgConfig.SdoAssistantConf.g_nEditCommonMp := Ini.ReadInteger('Assistant', 'EditCommonMp', g_wgConfig.SdoAssistantConf.g_nEditCommonMp);
    end;

    LoadInteger := Ini.ReadInteger('Assistant', 'EditCommonMpTimer', -1);
    if LoadInteger < 0 then begin
      Ini.WriteInteger('Assistant', 'EditCommonMpTimer', g_wgConfig.SdoAssistantConf.g_nEditCommonMpTimer);
    end else begin
      g_wgConfig.SdoAssistantConf.g_nEditCommonMpTimer := Ini.ReadInteger('Assistant', 'EditCommonMpTimer', g_wgConfig.SdoAssistantConf.g_nEditCommonMpTimer);
    end;

    if Ini.ReadInteger('Assistant', 'SpecialHp', -1) < 0 then Ini.WriteBool('Assistant', 'SpecialHp', False);
    g_wgConfig.SdoAssistantConf.g_boSpecialHp := Ini.ReadBool('Assistant', 'SpecialHp', g_wgConfig.SdoAssistantConf.g_boSpecialHp);

    LoadInteger := Ini.ReadInteger('Assistant', 'EditSpecialHp', -1);
    if LoadInteger < 0 then begin
      Ini.WriteInteger('Assistant', 'EditSpecialHp', g_wgConfig.SdoAssistantConf.g_nEditSpecialHp);
    end else begin
      g_wgConfig.SdoAssistantConf.g_nEditSpecialHp := Ini.ReadInteger('Assistant', 'EditSpecialHp', g_wgConfig.SdoAssistantConf.g_nEditSpecialHp);
    end;

    LoadInteger := Ini.ReadInteger('Assistant', 'EditSpecialHpTimer', -1);
    if LoadInteger < 0 then begin
      Ini.WriteInteger('Assistant', 'EditSpecialHpTimer', g_wgConfig.SdoAssistantConf.g_nEditSpecialHpTimer);
    end else begin
      g_wgConfig.SdoAssistantConf.g_nEditSpecialHpTimer := Ini.ReadInteger('Assistant', 'EditSpecialHpTimer', g_wgConfig.SdoAssistantConf.g_nEditSpecialHpTimer);
    end;

    if Ini.ReadInteger('Assistant', 'RandomHp', -1) < 0 then Ini.WriteBool('Assistant', 'RandomHp', False);
    g_wgConfig.SdoAssistantConf.g_boRandomHp := Ini.ReadBool('Assistant', 'RandomHp', g_wgConfig.SdoAssistantConf.g_boRandomHp);

    LoadInteger := Ini.ReadInteger('Assistant', 'EditRandomHp', -1);
    if LoadInteger < 0 then begin
      Ini.WriteInteger('Assistant', 'EditRandomHp', g_wgConfig.SdoAssistantConf.g_nEditRandomHp);
    end else begin
      g_wgConfig.SdoAssistantConf.g_nEditRandomHp := Ini.ReadInteger('Assistant', 'EditRandomHp', g_wgConfig.SdoAssistantConf.g_nEditRandomHp);
    end;

    LoadInteger := Ini.ReadInteger('Assistant', 'EditRandomHpTimer', -1);
    if LoadInteger < 0 then begin
      Ini.WriteInteger('Assistant', 'EditRandomHpTimer', g_wgConfig.SdoAssistantConf.g_nEditRandomHpTimer);
    end else begin
      g_wgConfig.SdoAssistantConf.g_nEditRandomHpTimer := Ini.ReadInteger('Assistant', 'EditRandomHpTimer', g_wgConfig.SdoAssistantConf.g_nEditRandomHpTimer);
    end;

    LoadInteger := Ini.ReadInteger('Assistant', 'RandomType', -1);
    if LoadInteger < 0 then
      Ini.WriteInteger('Assistant', 'RandomType', g_wgConfig.SdoAssistantConf.g_nRandomType)
    else g_wgConfig.SdoAssistantConf.g_nRandomType := Ini.ReadInteger('Assistant', 'RandomType', g_wgConfig.SdoAssistantConf.g_nRandomType);

    if Ini.ReadInteger('Assistant', 'LongHit', -1) < 0 then Ini.WriteBool('Assistant', 'LongHit', False);
    g_wgConfig.SdoAssistantConf.g_boLongHit := Ini.ReadBool('Assistant', 'LongHit', g_wgConfig.SdoAssistantConf.g_boLongHit);

    if Ini.ReadInteger('Assistant', 'AutoWideHit', -1) < 0 then Ini.WriteBool('Assistant', 'AutoWideHit', False);
    g_wgConfig.SdoAssistantConf.g_boAutoWideHit := Ini.ReadBool('Assistant', 'AutoWideHit', g_wgConfig.SdoAssistantConf.g_boAutoWideHit);

    if Ini.ReadInteger('Assistant', 'AutoFireHit', -1) < 0 then Ini.WriteBool('Assistant', 'AutoFireHit', False);
    g_wgConfig.SdoAssistantConf.g_boAutoFireHit := Ini.ReadBool('Assistant', 'AutoFireHit', g_wgConfig.SdoAssistantConf.g_boAutoFireHit);

    if Ini.ReadInteger('Assistant', 'AutoZhuriHit', -1) < 0 then Ini.WriteBool('Assistant', 'AutoZhuriHit', False);
    g_wgConfig.SdoAssistantConf.g_boAutoZhuriHit := Ini.ReadBool('Assistant', 'AutoZhuriHit', g_wgConfig.SdoAssistantConf.g_boAutoZhuriHit);

    if Ini.ReadInteger('Assistant', 'AutoShield', -1) < 0 then Ini.WriteBool('Assistant', 'AutoShield', False);
    g_wgConfig.SdoAssistantConf.g_boAutoShield := Ini.ReadBool('Assistant', 'AutoShield', g_wgConfig.SdoAssistantConf.g_boAutoShield);

    if Ini.ReadInteger('Assistant', 'HeroAutoShield', -1) < 0 then Ini.WriteBool('Assistant', 'HeroAutoShield', False);
    g_wgConfig.SdoAssistantConf.g_boHeroAutoShield := Ini.ReadBool('Assistant', 'HeroAutoShield', g_wgConfig.SdoAssistantConf.g_boHeroAutoShield);

    if Ini.ReadInteger('Assistant', 'AutoHide', -1) < 0 then Ini.WriteBool('Assistant', 'AutoHide', False);
    g_wgConfig.SdoAssistantConf.g_boAutoHide := Ini.ReadBool('Assistant', 'AutoHide', g_wgConfig.SdoAssistantConf.g_boAutoHide);

    if Ini.ReadInteger('Assistant', 'AutoMagic', -1) < 0 then Ini.WriteBool('Assistant', 'AutoMagic', False);
    g_wgConfig.SdoAssistantConf.g_boAutoMagic := Ini.ReadBool('Assistant', 'AutoMagic', g_wgConfig.SdoAssistantConf.g_boAutoMagic);

    LoadInteger := Ini.ReadInteger('Assistant', 'AutoMagicTime', -1);
    if LoadInteger < 0 then begin
      Ini.WriteInteger('Assistant', 'AutoMagicTime', g_wgConfig.SdoAssistantConf.g_nAutoMagicTime);
    end else begin
      g_wgConfig.SdoAssistantConf.g_nAutoMagicTime := Ini.ReadInteger('Assistant', 'AutoMagicTime', g_wgConfig.SdoAssistantConf.g_nAutoMagicTime);
    end;

    if Ini.ReadInteger('Assistant', 'HumanWineIsAuto', -1) < 0 then Ini.WriteBool('Assistant', 'HumanWineIsAuto', False);
    g_wgConfig.SdoAssistantConf.g_boAutoEatWine := Ini.ReadBool('Assistant', 'HumanWineIsAuto', g_wgConfig.SdoAssistantConf.g_boAutoEatWine);

    if Ini.ReadInteger('Assistant', 'HeroWineIsAuto', -1) < 0 then Ini.WriteBool('Assistant', 'HeroWineIsAuto', False);
    g_wgConfig.SdoAssistantConf.g_boAutoEatHeroWine := Ini.ReadBool('Assistant', 'HeroWineIsAuto', g_wgConfig.SdoAssistantConf.g_boAutoEatHeroWine);

    if Ini.ReadInteger('Assistant', 'HumanMedicateWineIsAuto', -1) < 0 then Ini.WriteBool('Assistant', 'HumanMedicateWineIsAuto', False);
    g_wgConfig.SdoAssistantConf.g_boAutoEatDrugWine := Ini.ReadBool('Assistant', 'HumanMedicateWineIsAuto', g_wgConfig.SdoAssistantConf.g_boAutoEatDrugWine);

    if Ini.ReadInteger('Assistant', 'HeroMedicateWineIsAuto', -1) < 0 then Ini.WriteBool('Assistant', 'HeroMedicateWineIsAuto', False);
    g_wgConfig.SdoAssistantConf.g_boAutoEatHeroDrugWine := Ini.ReadBool('Assistant', 'HeroMedicateWineIsAuto', g_wgConfig.SdoAssistantConf.g_boAutoEatHeroDrugWine);

    LoadInteger := Ini.ReadInteger('Assistant', 'HumanWinePercent', -1);
    if LoadInteger < 0 then begin
      Ini.WriteInteger('Assistant', 'HumanWinePercent', g_wgConfig.SdoAssistantConf.g_btEditWine);
    end else begin
      g_wgConfig.SdoAssistantConf.g_btEditWine := Ini.ReadInteger('Assistant', 'HumanWinePercent', g_wgConfig.SdoAssistantConf.g_btEditWine);
    end;

    LoadInteger := Ini.ReadInteger('Assistant', 'HeroWinePercent', -1);
    if LoadInteger < 0 then begin
      Ini.WriteInteger('Assistant', 'HeroWinePercent', g_wgConfig.SdoAssistantConf.g_btEditHeroWine);
    end else begin
      g_wgConfig.SdoAssistantConf.g_btEditHeroWine := Ini.ReadInteger('Assistant', 'HeroWinePercent', g_wgConfig.SdoAssistantConf.g_btEditHeroWine);
    end;

    LoadInteger := Ini.ReadInteger('Assistant', 'HumanMedicateWineTime', -1);
    if LoadInteger < 0 then begin
      Ini.WriteInteger('Assistant', 'HumanMedicateWineTime', g_wgConfig.SdoAssistantConf.g_btEditDrugWine);
    end else begin
      g_wgConfig.SdoAssistantConf.g_btEditDrugWine := Ini.ReadInteger('Assistant', 'HumanMedicateWineTime', g_wgConfig.SdoAssistantConf.g_btEditDrugWine);
    end;

    LoadInteger := Ini.ReadInteger('Assistant', 'HeroMedicateWineTime', -1);
    if LoadInteger < 0 then begin
      Ini.WriteInteger('Assistant', 'HeroMedicateWineTime', g_wgConfig.SdoAssistantConf.g_btEditHeroDrugWine);
    end else begin
      g_wgConfig.SdoAssistantConf.g_btEditHeroDrugWine := Ini.ReadInteger('Assistant', 'HeroMedicateWineTime', g_wgConfig.SdoAssistantConf.g_btEditHeroDrugWine);
    end;

    //声音
    if Ini.ReadInteger('Misc', 'PlaySound', -1) < 0 then Ini.WriteBool('Misc', 'PlaySound', True);
    g_boSound := Ini.ReadBool('Misc', 'PlaySound', g_boSound);


  finally
    Ini.Free;
    g_boLoadSdoAssistantConfig := True;
  end;
end;

procedure SaveSdoAssistantConfig(sUserName:String);//储存盛大挂配置
var
  Ini: TIniFile;
  sFileName: String;
begin
  if sUserName <> '' then sFileName := format(SDOCONFIGFILE,[g_sServerName,sUserName,'SdoAssistant'])
    else sFileName:=format(CONFIGFILE,['Assistant']);

  if not DirectoryExists('config') then  CreateDir('config');

  if not DirectoryExists(format('config\LB%s_%s',[g_sServerName,sUserName])) then
    CreateDir(format('config\LB%s_%s',[g_sServerName,sUserName]));

  Ini:=TIniFile.Create(sFileName);

  Ini.WriteBool('Assistant', 'ShowAllItem', g_boShowAllItem);
  Ini.WriteBool('Assistant', 'AutoPuckUpItem', g_boAutoPuckUpItem);
  Ini.WriteBool('Assistant', 'FilterAutoItemShow', g_boFilterAutoItemShow);
  Ini.WriteBool('Assistant', 'FilterAutoItemUp', g_boFilterAutoItemUp);
  Ini.WriteBool('Assistant', 'NoShift', g_boNoShift);
  Ini.WriteBool('Assistant', 'ExpFiltrate', g_boExpFiltrate);
  Ini.WriteBool('Assistant', 'ShowName', g_boShowName);
  Ini.WriteBool('Assistant', 'DuraWarning', g_boDuraWarning);
  Ini.WriteBool('Assistant', 'CommonHp', g_boCommonHp);
  Ini.WriteInteger('Assistant', 'EditCommonHp', g_nEditCommonHp);
  Ini.WriteInteger('Assistant', 'EditCommonHpTimer', g_nEditCommonHpTimer);
  Ini.WriteBool('Assistant', 'CommonMp', g_boCommonMp);
  Ini.WriteInteger('Assistant', 'EditCommonMp', g_nEditCommonMp);
  Ini.WriteInteger('Assistant', 'EditCommonMpTimer', g_nEditCommonMpTimer);
  Ini.WriteBool('Assistant', 'SpecialHp', g_boSpecialHp);
  Ini.WriteInteger('Assistant', 'EditSpecialHp', g_nEditSpecialHp);
  Ini.WriteInteger('Assistant', 'EditSpecialHpTimer', g_nEditSpecialHpTimer);
  Ini.WriteBool('Assistant', 'RandomHp', g_boRandomHp);
  Ini.WriteInteger('Assistant', 'EditRandomHp', g_nEditRandomHp);
  Ini.WriteInteger('Assistant', 'EditRandomHpTimer', g_nEditRandomHpTimer);
  Ini.WriteInteger('Assistant', 'RandomType', g_nRandomType);

  Ini.WriteBool('Assistant', 'LongHit', g_boLongHit);
  Ini.WriteBool('Assistant', 'AutoWideHit', g_boAutoWideHit);
  Ini.WriteBool('Assistant', 'AutoFireHit', g_boAutoFireHit);
  Ini.WriteBool('Assistant', 'AutoZhuriHit', g_boAutoZhuriHit);
  Ini.WriteBool('Assistant', 'AutoShield', g_boAutoShield);
  Ini.WriteBool('Assistant', 'AutoHide', g_boAutoHide);
  Ini.WriteBool('Assistant', 'AutoMagic', g_boAutoMagic);
  Ini.WriteBool('Assistant', 'HeroAutoShield', g_boHeroAutoDEfence); //英雄持续开盾
  Ini.WriteInteger('Assistant', 'AutoMagicTime', g_nAutoMagicTime);

  Ini.WriteBool('Assistant', 'HumanWineIsAuto', g_boAutoEatWine);
  Ini.WriteBool('Assistant', 'HeroWineIsAuto', g_boAutoEatHeroWine);
  Ini.WriteBool('Assistant', 'HumanMedicateWineIsAuto', g_boAutoEatDrugWine);
  Ini.WriteBool('Assistant', 'HeroMedicateWineIsAuto', g_boAutoEatHeroDrugWine);
  Ini.WriteInteger('Assistant', 'HumanWinePercent', g_btEditWine);
  Ini.WriteInteger('Assistant', 'HeroWinePercent', g_btEditHeroWine);
  Ini.WriteInteger('Assistant', 'HumanMedicateWineTime', g_btEditDrugWine);
  Ini.WriteInteger('Assistant', 'HeroMedicateWineTime', g_btEditHeroDrugWine);
  //HotKey
 
  Ini.Free;
end;
  procedure stringtolists(str:string;cra:Char; onid,outid:Integer; var str1:string);
var
  data:string;
  I:Integer;
begin
   I:=-1;
  while True do begin
   if str = '' then break;
       str := GetValidStr3(str, data, [cra]);
       Inc(I);
     if I >= onid then
      str1 := str1+data+cra;
     if I >= outid+onid then exit;
  end;
 end;

function StringToInteger(str:string;cra:Char):Integer;
var
  data:string;
  I:Integer;
begin
  Result := 0;
  I := 0;
 while True do begin
  if str = '' then break;
   str := GetValidStr3(str, data, [cra]);
   if str <> '' then
   Inc(I);
 end;
 if I > 0 then
  Result := I;
end;
initialization
  begin
  end;
end.


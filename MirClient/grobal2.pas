unit Grobal2;

interface
uses
   Math,windows;
Const
  BUFFERSIZE    =1024;
//版本号
//  VERSION_NUMBER_0522 = 20010522;
  VERSION_NUMBER_0522 = 20020522;
  CLIENT_VERSION_NUMBER = 120040918;
  CM_POWERBLOCK = 0;
  //客户端发送的命令
  CM_SOFTCLOSE  =0;

  CM_QUERYUSERSTATE = 2;
  CM_ADJUST_BONUS =60;

  CM_QUERYUSERNAME = 80; //查询用户姓名
  CM_QUERYBAGITEMS = 81; //查询包裹内容

  CM_QUERYCHR     = 100; //查询人物
  CM_NEWCHR       = 101; //新人物
  CM_DELCHR       = 102; //删除人物
  CM_SELCHR       = 103; //选择人物
  CM_SELECTSERVER = 104; //选择服务器
///////////
  //动作
  CM_DROPITEM = 1000; //丢掉物品
  CM_PICKUP = 1001; //拣东西
  CM_OPENDOOR = 1002; //开门
  CM_TAKEONITEM = 1003; //穿上/戴上/拿上 物品
  CM_TAKEOFFITEM = 1004; //脱下物品
  CM_EAT = 1006; //吃物品
  CM_BUTCH = 1007; //
  CM_MAGICKEYCHANGE = 1008; //改变魔法按键

  CM_CLICKNPC = 1010; //点击NPC???
  CM_MERCHANTDLGSELECT = 1011; // NPC Tag Click 选择商人功能窗口
  CM_MERCHANTQUERYSELLPRICE = 1012; //查询出卖给商人的价格
  CM_USERSELLITEM = 1013; //选择物品
  CM_USERBUYITEM = 1014; //购买物品
  CM_USERGETDETAILITEM = 1015; //????????????????????????
  CM_DROPGOLD = 1016; //丢掉金币

  CM_LOGINNOTICEOK = 1018; //进入游戏窗口确定按钮
  //编组相关
  CM_GROUPMODE = 1019; //编组模式
  CM_CREATEGROUP = 1020; //创建编组
  CM_ADDGROUPMEMBER = 1021; //添加编组成员
  CM_DELGROUPMEMBER = 1022; //删除编组成员
  //修理
  CM_USERREPAIRITEM = 1023; //修理物品
  CM_MERCHANTQUERYREPAIRCOST = 1024; //查询修理价格

    //交易相关
  CM_DEALTRY = 1025; //交易开始//////////////
  CM_DEALADDITEM = 1026;//交易添加物品////////////
  CM_DEALDELITEM = 1027; //交易删除物品////////////
  CM_DEALCANCEL = 1028; //交易取消/////////////
  CM_DEALCHGGOLD = 1029;//交易改变金币////////////
  CM_DEALEND = 1030;//交易完毕//////////////
  CM_USERSTORAGEITEM = 1031; //用户存储物品
  CM_USERTAKEBACKSTORAGEITEM = 1032; //从仓库取回物品
  CM_WANTMINIMAP = 1033;
  CM_USERMAKEDRUGITEM = 1034; //制作毒药物品
  //行会相关
  CM_OPENGUILDDLG = 1035; //打开行会窗口
  CM_GUILDHOME = 1036; //行会主页
  CM_GUILDMEMBERLIST = 1037; //行会成员列表
  CM_GUILDADDMEMBER = 1038; //添加行会成员
  CM_GUILDDELMEMBER = 1039; //删除行会成员
  CM_GUILDUPDATENOTICE = 1040; //更新行会信息
  CM_GUILDUPDATERANKINFO = 1041; //更新行会等级/排列信息????

  CM_SPEEDHACKUSER = 1043;
  CM_GUILDMAKEALLY = 1044; //行会结盟
  CM_GUILDBREAKALLY = 1045; //行会解盟
///////////////
  //登录有关的命令
  CM_PROTOCOL       = 2000;
  CM_IDPASSWORD     = 2001; //发送用户名/密码
  CM_PASSWORD     = 2001;
  CM_ADDNEWUSER     = 2002;
  CM_CHANGEPASSWORD = 2003; //更改密码
  CM_UPDATEUSER     = 2004;

/////////////////////

///待定...
  CM_THROW    = 3005;  //投掷
  CM_RUSHKUNG = 3007; //
//.......end..
  CM_RUSH     = 3006; //
  CM_FIREHIT  = 3008; //烈火
  CM_BACKSTEP = 3009; //走路不成功????
  CM_TURN     = 3010; //转
  CM_WALK     = 3011; //走路
  CM_SITDOWN  = 3012; //挖
  CM_RUN      = 3013; //跑
  CM_HIT      = 3014; //砍
  CM_HEAVYHIT = 3015;
  CM_BIGHIT   = 3016;
  CM_SPELL    = 3017; //魔法
  CM_POWERHIT = 3018; //攻杀
  CM_LONGHIT  = 3019; //刺杀
  CM_DIGUP    = 3020; //挖取
  CM_DIGDOWN  = 3021; //挖下?????????
  CM_FLYAXE   = 3022; //???????????????
  CM_LIGHTING = 3023; //天亮?????????????
  CM_WIDEHIT  = 3024; //半月


  CM_SAY = 3030; //说话
  CM_RIDE = 3031; //骑乘???
  CM_HORSERUN     = 3035;
  CM_CRSHIT       = 3036;
  CM_3037         = 3037;
  CM_TWINHIT      = 3038;
  RCC_USERHUMAN    = 0;
//////////
  //装备项目
  U_DRESS       =0;    //衣服
  U_WEAPON      =1;    //武器
  U_RIGHTHAND   =2;    //右手
  U_NECKLACE    =3;    //项链
  U_HELMET      =4;    //头盔
  U_ARMRINGL    =5;    //左手戒指
  U_ARMRINGR    =6;    //右手戒指
  U_RINGL       =7;    //左戒指
  U_RINGR       =8;    //右戒指
  U_BUJUK       = 9;
  U_BELT        = 10;
  U_BOOTS       = 11;
  U_CHARM       = 12;

////////以上为整理后的数据..
/////////////////////////////////////////////////

///////////////////////////////


  //服务器端发送的命令
   {+//****************************************** }
  { #1. Server To Client Message                 }
  {=******************************************** }
////////////////////
////////////////////////
//待定..start
  SM_SPACEMOVE_HIDE =1041;
  SM_SPACEMOVE_HIDE2=1042;
  SM_SPACEMOVE_SHOW =1043;
  SM_SPACEMOVE_SHOW2=1044;
  SM_MOVEFAIL       =1045;
  SM_BUTCH          =1046;

  SM_MAGICFIRE      =1072;
  SM_MAGICFIRE_FAIL = 1073;

  SM_THROW =5;
  SM_RUSHKUNG = 7; //
//.....end


  SM_RUSH = 6; //
  SM_FIREHIT = 8; //烈火
  SM_BACKSTEP = 9; //走路不成功????
  SM_TURN = 10; //转动方向
  SM_WALK = 11; //走路
  SM_SITDOWN = 12; //挖
  SM_RUN = 13; //跑
  SM_HIT = 14; //攻击
  SM_HEAVYHIT = 15;
  SM_BIGHIT =16;
  SM_SPELL = 17; //使用魔法
  SM_POWERHIT = 18; //攻杀
  SM_LONGHIT = 19; //刺杀
  SM_DIGUP = 20; //挖取
  SM_DIGDOWN = 21; //挖下?????????
  SM_FLYAXE = 22; //???????????????
  SM_LIGHTING = 23; //天亮?????????????
  SM_WIDEHIT = 24; //半月
  SM_CRSHIT             = 25;
  SM_TWINHIT            = 26;

  SM_DISAPPEAR = 30; //物品消失??????
  SM_STRUCK = 31; //
  SM_DEATH = 32; //
  SM_SKELETON = 33; // SM_DEATH 尸骨??尸体
  SM_NOWDEATH = 34; //
  SM_41                 = 36;
  SM_HEAR = 40; //听到说话
  SM_FEATURECHANGED = 41; //容貌??特征??改变???????????
  SM_USERNAME = 42; //用户名??玩家名???????
  SM_WINEXP = 44; //胜利指数???杀怪获得的经验值???????????????
  SM_LEVELUP = 45; //等级提升
  SM_DAYCHANGING = 46; //日期正在改变????
  SM_LOGON = 50; //登录注册
  SM_NEWMAP = 51; //新地图
  SM_ABILITY = 52; //能力
  SM_HEALTHSPELLCHANGED = 53; //红血兰血 改变
  SM_MAPDESCRIPTION = 54;//地图形容,地图描述
 /////////////

  SM_SYSMESSAGE = 100; //系统消息
  SM_GROUPMESSAGE = 101; //组队消息
  SM_CRY = 102; //喊
  SM_WHISPER = 103; //私聊
  SM_GUILDMESSAGE = 104; //行会信息

  SM_ADDITEM = 200; //添加物品
//  SM_ADDITEM = 165; //添加物品
  SM_BAGITEMS = 201; //包裹物品
//  SM_BAGITEMS = 166; //包裹物品
  SM_DELITEM = 202; //删除物品????
//  SM_DELITEM = 167; //删除物品????

  SM_UPDATEITEM	= 203;
  SM_ADDMAGIC 	= 210; //添加魔法
  SM_SENDMYMAGIC= 211; //我所会的魔法
  SM_DELMAGIC	= 212;

  //登录、新帐号、新角色、查询角色等
  SM_VERSION_AVAILABLE = 500; //
  SM_CERTIFICATION_FAIL = 501; //
  SM_ID_NOTFOUND = 502; //ID未发现,用户名错误
  SM_PASSWD_FAIL = 503; //密码错误
  SM_NEWID_SUCCESS = 504; //创建新ID成功
  SM_NEWID_FAIL = 505; //新ID失败
  SM_CHGPASSWD_SUCCESS = 506; //更改密码成功
  SM_CHGPASSWD_FAIL = 507; //更改密码失败

  SM_QUERYCHR = 520; //查询人物(2人窗口)
  SM_NEWCHR_SUCCESS = 521; //创建人物成功
  SM_NEWCHR_FAIL = 522; //创建人物失败
  SM_DELCHR_SUCCESS = 523; //删除人物成功
  SM_DELCHR_FAIL = 524; //删除人物失败
  SM_STARTPLAY = 525; //开始游戏
  SM_STARTFAIL = 526; //进入游戏失败
  SM_QUERYCHR_FAIL = 527; //查询人物失败
  SM_OUTOFCONNECTION   = 528; //连接已断开
  SM_PASSOK_SELECTSERVER = 529; //用户名/密码 验证通过
  SM_SELECTSERVER_OK = 530; //服务器选择成功
  SM_NEEDUPDATE_ACCOUNT = 531; //需要更新_说明????
  SM_UPDATEID_SUCCESS = 532; //更新ID成功?????
  SM_UPDATEID_FAIL = 533; //更新ID失败???????
/////////////

  SM_DROPITEM_SUCCESS = 600; //丢弃物品成功
  SM_DROPITEM_FAIL = 601; //丢弃物品失败
  SM_ITEMSHOW = 610; //显示物品
  SM_ITEMHIDE = 611; //地上的物品消失
  SM_OPENDOOR_OK = 612; //开门成功
  SM_OPENDOOR_LOCK = 613; //
  SM_CLOSEDOOR = 614; //
  SM_TAKEON_OK = 615; //穿上戴上成功
  SM_TAKEON_FAIL = 616; //穿失败

  SM_TAKEOFF_OK = 619; //脱下成功
  SM_TAKEOFF_FAIL = 620; //脱下失败
  SM_SENDUSEITEMS = 621; //身上穿戴物品
  SM_WEIGHTCHANGED = 622; //背包重量改变

  SM_CLEAROBJECTS = 633; //清除对象??????????
  SM_CHANGEMAP = 634; //地图改变
  SM_EAT_OK = 635; //吃物品成功
  SM_EAT_FAIL = 636; //吃物品失败
//  SM_BUTCH = 637; //
//  SM_MAGICFIRE = 638; //魔法火?????????????
//  SM_MAGICFIRE_FAIL = 639; //魔法火失败?????????????
  SM_MAGIC_LVEXP = 640; //魔法等级
  SM_DURACHANGE = 642;
  SM_MERCHANTSAY = 643; //商人说话
  SM_MERCHANTDLGCLOSE = 644; //商人窗口关闭
  SM_SENDGOODSLIST = 645; //货物列表
  SM_SENDUSERSELL = 646; //用户出售
  SM_SENDBUYPRICE = 647; //购买价格
  SM_USERSELLITEM_OK = 648; //用户出售物品成功
  SM_USERSELLITEM_FAIL = 649; //用户出售物品失败
  SM_BUYITEM_SUCCESS = 650; //用户购买物品成功
  SM_BUYITEM_FAIL = 651; //用户购买失败
  SM_SENDDETAILGOODSLIST = 652; //详细货物列表
  SM_GOLDCHANGED = 653; //金币改变
  SM_CHANGELIGHT = 654; //改变亮度????
  SM_CHANGENAMECOLOR = 656; //改变宝宝颜色?????
  SM_CHARSTATUSCHANGED = 657;
  SM_SENDNOTICE = 658; //进入游戏弹出窗口
  SM_CREATEGROUP_OK = 660; //创建编组成功
  SM_CREATEGROUP_FAIL = 661; //创建编组失败
  SM_GROUPCANCEL = 666; //编组取消??????????
  SM_GROUPMEMBERS = 667; //编组成员
 /////////////
  SM_SENDUSERREPAIR=668;//2076;

  SM_DEALREMOTEADDITEM = 682;//2115;  
  SM_DEALREMOTEDELITEM = 683;//2116;  
  
  SM_SENDUSERSTORAGEITEM=700;//2121;  
  SM_SAVEITEMLIST = 704;//2086;
    
  SM_AREASTATE = 708; //地区状态
//  SM_DELITEMS = 203; //删除物品??????
  SM_DELITEMS = 709; //删除物品??????

  SM_READMINIMAP_OK=710;//2122;
  SM_READMINIMAP_FAIL=711;//2123;
  SM_SENDUSERMAKEDRUGITEMLIST=712;
  SM_716                = 716;

  SM_CHANGEGUILDNAME = 750; //改变行会名称
  SM_SENDUSERSTATE=751;
  SM_SUBABILITY = 752;
  SM_OPENGUILDDLG = 753; //打开行会窗口
  SM_OPENGUILDDLG_FAIL = 754; //打开行会窗口失败
  SM_SENDGUILDHOME = 755; //行会主页
  SM_SENDGUILDMEMBERLIST = 756; //行会成员列表
  SM_GUILDADDMEMBER_OK = 757; //行会添加成员成功
  SM_GUILDADDMEMBER_FAIL = 758; //行会添加成员失败
  SM_GUILDDELMEMBER_OK = 759; //行会删除成员成功
  SM_GUILDDELMEMBER_FAIL = 760; //行会删除成员失败
  SM_GUILDRANKUPDATE_FAIL = 761; //行会等级/排列更新失败
  SM_BUILDGUILD_OK = 762; //创建行会成功
  SM_BUILDGUILD_FAIL = 763; //创建行会失败
  
  SM_MYSTATUS = 766;//131;
  
  SM_GUILDMAKEALLY_OK = 768; //创建行会同盟成功
  SM_GUILDMAKEALLY_FAIL = 769; //创建行会同盟失败
  SM_GUILDBREAKALLY_OK = 770; //删除行会同盟成功
  SM_GUILDBREAKALLY_FAIL = 771; //删除行会同盟失败
  SM_DLGMSG = 772; //窗口消息????弹出窗口???????
/////////////

  SM_RECONNECT =802;
  
  SM_SHOWEVENT = 804; //显示事件????????
  SM_HIDEEVENT = 805; //隐藏事件?????????
  
  SM_TIMECHECK_MSG = 810;
  SM_ADJUST_BONUS = 811;

  SM_OPENHEALTH = 1100; //打开健康????????
  SM_CLOSEHEALTH = 1101; //关闭健康???????
  SM_CHANGEFACE = 1104; //
  SM_RIDEHORSE = 1300; //骑马
  SM_MONSTERSAY = 1501; //怪物说话
  SM_SERVERCONFIG = 5007;
  SM_GAMEGOLDNAME = 5008;
  SM_PASSWORD     = 5009;
  SM_HORSERUN     = 5010; 

 ////////////////////////
////////////////////////////
//以下未处理..


  SM_VERSION_FAIL =121;




  SM_LAMPCHANGEDURA=241;

  SM_ALIVE =263;


  SM_INSTANCEHEALGUAGE=314;
  SM_BREAKWEAPON=315;

  //对话消息
//  SM_SPACEMOVE_HIDE =1041;
//  SM_SPACEMOVE_HIDE2=1042;
//  SM_SPACEMOVE_SHOW =1043;
//  SM_SPACEMOVE_SHOW2=1044;
//  SM_MOVEFAIL       =1045;


  SM_HIDE =1224;
  SM_GHOST=1225;


  SM_EXCHGTAKEON_OK=2056;
  SM_EXCHGTAKEON_FAIL=2057;




  SM_SENDREPAIRCOST=2080;
  SM_USERREPAIRITEM_OK=2081;
  SM_USERREPAIRITEM_FAIL=2082;
  SM_STORAGE_OK=2083;
  SM_STORAGE_FULL=2084;
  SM_STORAGE_FAIL=2085;


  SM_TAKEBACKSTORAGEITEM_OK=2087;
  SM_TAKEBACKSTORAGEITEM_FAIL=2088;
  SM_TAKEBACKSTORAGEITEM_FULLBAG=2089;

  SM_MAKEDRUG_SUCCESS=2092;
  SM_MAKEDRUG_FAIL=2093;

  SM_TEST=2095;
  SM_GROUPMODECHANGED=2096;
  SM_GROUPADDMEM_OK=2099;
  SM_GROUPADDMEM_FAIL=2100;
  SM_GROUPDELMEM_OK=2101;
  SM_GROUPDELMEM_FAIL=2102;


  SM_DEALTRY_FAIL=2108;
  SM_DEALMENU=2109;
  SM_DEALCANCEL=2110;
  SM_DEALADDITEM_OK=2111;
  SM_DEALADDITEM_FAIL=2112;
  SM_DEALDELITEM_OK=2113;
  SM_DEALDELITEM_FAIL=2114;


  SM_DEALCHGGOLD_OK=2117;
  SM_DEALCHGGOLD_FAIL=2118;
  SM_DEALREMOTECHGGOLD=2119;
  SM_DEALSUCCESS=2120;




  SM_MENU_OK=2137;
  SM_DONATE_OK=2139;
  SM_DONATE_FAIL=2140;

  SM_ACTION_MIN=2200;
  SM_ACTION_MAX=2499;
  SM_ACTION2_MIN=2500;
  SM_ACTION2_MAX=2999;
//
  SM_PLAYDICE    = 8001;
  SM_PASSWORDSTATUS = 8002;
  SM_NEEDPASSWORD = 8003; 
  SM_GETREGINFO = 8004;

  RCC_MERCHANT  =1;
  RCC_GUARD     =2;



  DEFBLOCKSIZE =16;

  UNITX = 48;
  UNITY = 32;
  LOGICALMAPUNIT =20;
  HALFX = 24;
  HALFY = 16;

  ET_DIGOUTZOMBI =0;
  ET_PILESTONES = 1;
  ET_HOLYCURTAIN = 2;
  ET_FIRE= 3;
  ET_SCULPEICE = 4;

  STATE_STONE_MODE =0;
  STATE_OPENHEATH = 1;

  MAXBAGITEM = 52;

  DR_UP=0;
  DR_UPRIGHT =1;
  DR_RIGHT =2;
  DR_DOWNRIGHT =3;
  DR_DOWN =4;
  DR_DOWNLEFT =5;
  DR_LEFT =6;
  DR_UPLEFT =7;

type
  pTDefaultMessage=^TDefaultMessage;

{    //这是原来的定义:
  TDefaultMessage=packed record  //Size=12
    Ident :word;
    Recog :integer;  //识别码
    Param :smallint;
    Tag   :smallint;
    Series:smallint;
  end;
}
//这是新的定义
  TDefaultMessage=packed record  //Size=12
    Recog :integer;  //识别码
    Ident :word;
    Param :smallint;
    Tag   :smallint;
    Series:smallint;
  end;


  //Ident=SM_DAYCHANGING
  //   Param=DayBright
  //   Tag=雾的浓度：0，1，2，3

  TUserInfo = packed Record
     Name:String[32];
     Looks:integer;
     StdMode:Integer;
     Shape:Integer;
  end;

 //应当有44字节
 TSTDITEM = packed record
    Name         :String[14];
    StdMode      :Byte;
    Shape        :Byte;
    Weight       :Byte;
    AniCount     :Byte;
    Source       :Byte;
    Reserved     :Byte;
    NeedIdentify :Byte;
    Looks        :Word;
    DuraMax      :Word;
    AC           :Word;
    MAC          :Word;
    DC           :Word;
    MC           :Word;
    SC           :Word;
    Need         :Byte;
    NeedLevel    :Byte;
    Price        :UINT;
  end;


  TRegInfo = record
    sKey:String;
    sServerName:String;
    sRegSrvIP:String[15];
    nRegPort:Integer;
  end;

 PTClientItem=^TClientItem;
  TCLIENTITEM = packed record
    s: TSTDITEM;
    MakeIndex: Integer; //
    Dura: Word;         //持久
    DuraMax: Word;      //最大持久
  end;



  TAbility= packed record
     MP,MaxMP:Integer;
     HP,MaxHP:integer;
     Exp,MaxExp:Integer;
     Level:Integer;
     Weight,MaxWeight:Integer;
     WearWeight,MaxWearWeight:Integer;
     HandWeight,MaxHandWeight:Integer;
     AC:Integer;
     MAC:Integer;
     DC:Integer;
     MC,SC:Integer;
  end;

  PTChrMsg=^TChrMsg;

  TChrMsg= packed Record
     Ident:integer;
     Dir:Integer;
     X,Y:Integer;
     State:integer;
     feature:integer;
     saying:string;
     Sound:integer;
  end;

  TClientConf=record
     boClientCanSet    :boolean;
     boRunHuman        :boolean;
     boRunMon          :boolean;
     boRunNpc          :boolean;
     boWarRunAll       :boolean;
     btDieColor        :byte;
     wSpellTime        :word;
     wHitIime          :word;
     wItemFlashTime    :word;
     btItemSpeed       :byte;
     boCanStartRun     :boolean;
     boParalyCanRun    :boolean;
     boParalyCanWalk   :boolean;
     boParalyCanHit    :boolean;
     boParalyCanSpell  :boolean;
     boShowRedHPLable  :boolean;
     boShowHPNumber    :boolean;
     boShowJobLevel    :boolean;
     boDuraAlert       :boolean;
     boMagicLock       :boolean;
     boAutoPuckUpItem  :boolean;
  end;


  TUserStateInfo= packed Record
     UserName:String[32];
     GuildName:String[32];
     GuildRankName:String[32];
     NameColor:Integer;
     Feature:integer;
     UseItems:Array[0..127] of TClientItem;
  end;

  TUserCharacterInfo= packed Record
     Name:String;
     Job:byte;
     Hair:smallint;
     level:Integer;
     Sex:byte;
  end;

  TUserEntry =record
    sAccount      :String[10];
    sPassword     :String[10];
    sUserName     :String[20];
    sSSNo         :String[14];
    sPhone        :String[14];
    sQuiz         :String[20];
    sAnswer       :String[12];
    sEMail        :String[40];
  end;
  TUserEntryAdd =record
    sQuiz2        :String[20];
    sAnswer2      :String[12];
    sBirthDay     :String[10];
    sMobilePhone  :String[15];
    sMemo         :String[40];
    sMemo2        :String[40];
  end;

  PTDropItem=^TDropItem;
  TDropItem= packed record
     Id:Integer;
     X,Y:Integer;
     Looks:integer;
     FlashTime:LongInt;
     Name:String[16];
     BoFlash:Boolean;
     FlashStepTime:LongInt;
     FlashStep:Integer;
  end;

  PTClientMagic=^TClientMagic;
  TSTANDARDMAGIC = packed record   //魔法
    wMagicID: Word;          //编号
    Num:byte;          //这里应为MagicName:Array[0..13] of char //num 是我自己加的,表示后面名字的有效字符数.
    sMagicName: Array[0..12] of Char;   //名称 12
    btEffectType: BYTE;
    btEffect: BYTE;    //效果
    wSpell: Word;     //魔法
    wPower: Word;  //
    TrainLevel: Array[0..3] of BYTE;     //升级需要的等级
    MaxTrain: Array[0..3] of Integer; //锻炼
    btTrainLv:Byte;          //最大锻炼等级
    btJob: BYTE;
    dwDelayTime: Integer;   //延迟时间
    btDefSpell: BYTE;       //默认
    btDefMinPower: BYTE;
    wMaxPower: Word;
    btDefMaxPower: BYTE;
    szDesc: Array[0..15] of Char;
  end;

  TCLIENTMAGIC = packed record    //魔法
    Key: Char;          //按键
    level:byte;            //等级
    CurTrain:integer;     //当前经验
    Def: TSTANDARDMAGIC;
  end;



  TNakedAbility=packed Record
     DC,MC,SC,AC,MAC:Integer;
     HP,MP:Integer;
     Hit:integer;
     Speed:integer;
  end;

  TShortMessage=packed record
     Ident :WORD;
     Msg   :WORD;
  end;


  TCharDesc= packed Record
     Feature:Integer;
     Status:Integer;
  end;


{//lorran modi 2004-07-12
  TMessageBodyW=Record
     Param1:integer;
     Param2:integer;
     Tag1:integer;
     Tag2:integer;
  end;
}
  TMESSAGEBODYW = packed record
    Param1: Word;
    Param2: Word;
    Tag1: Word;
    Tag2: Word;
  end ;


  TMessageBodyWL=packed Record
     lParam1,lParam2:longint;
     lTag1,lTag2:longint;
  end;



  PTClientGoods=^TClientGoods;
  TClientGoods=packed record
     Name:string[16];
     SubMenu:Integer;
     Price:Integer;
     Stock:integer;
     Grade:integer;
  end;

type
  TFEATURE = packed record
    Gender: BYTE;
    Weapon: BYTE;
    Dress: BYTE;
    Hair: BYTE;
  end;


function  MakeDefaultMsg (msg:smallint; Recog:integer; param, tag, series:smallint):TDefaultMessage;
function  UpInt(i:double):integer;

Function  RACEfeature(Feature:Integer):byte;
Function  WEAPONfeature(Feature:Integer):byte;
Function  HAIRfeature(Feature:Integer):byte;
Function  DRESSfeature(Feature:Integer):byte;
Function  APPRfeature(Feature:Integer):Word;
  function Horsefeature(cfeature:integer):Byte;
  function Effectfeature(cfeature:integer):Byte;
//Function  RACEfeature(Feature:Word):smallint;
//Function  HAIRfeature(Feature:Word):byte;
//Function  DRESSfeature(Feature:Word):byte;
//Function  APPRfeature(Feature:Word):byte;
//Function  WEAPONfeature(Feature:Word):byte;

function  MakeFeature(Race:byte;Appr,Hair,Dress,Weapon:byte):Integer;
implementation

function Horsefeature(cfeature:integer):Byte;
begin
  Result:=LoByte(LoWord(cfeature));
end;
function Effectfeature(cfeature:integer):Byte;
begin
  Result:=HiByte(LoWord(cfeature));
end;

function  MakeDefaultMsg (msg:smallint; Recog:integer; param, tag, series:smallint):TDefaultMessage;
begin
    result.Ident:=Msg;
    result.Param:=Param;
    result.Tag:=Tag;
    result.Series:=Series;
    result.Recog:=Recog;
end;

function  UpInt(i:double):integer;
begin
  result:=Ceil(i);
end;


//人物Feature属性的分解和合成，共32位，高16位为Race和Appr,
//   低16位中，最左四位表示Hair,接下来6位表示Dress,最右6位表示Weapon。
//   当Race=0时,Dress mod 2 表示性别
//   Race=0时武器也分男女，男的武器应该是偶数，女的是奇数
//*******对Feature的解释可以自己定义，但Race取值至少0..90，Appr:0..9
//*******Hair最多有6种发型（3600幅图片，每600幅图片一种发型），男女各3
//*******Dress的数量好象在Hum.WIL中表示，有多少种图片就有多少种服装，Hum.WIL可以扩展
//*******Weapon的数量见Weapon.WIL，有数万幅图片，同样的，每600幅对应一个Appr，分男女
//*********例如40800幅对应68种武器（男女合计）

{ //???????
  TFEATURE = record
    Race: BYTE;
    Weapon: BYTE;
    Hair: BYTE;
    Dress: BYTE;
  end;
}

//$0602 1600 =100800000
Function  RACEfeature(Feature:Integer):byte;
begin
  result:=(LoByte(Loword(Feature)) and $3F);
end;

Function  WEAPONfeature(Feature:Integer):byte;
begin
  result:=HiByte(LoWord(Feature));
end;



Function  HAIRfeature(Feature:Integer):byte;
begin
    result:=LoByte(HiWord(Feature));
end;


Function  DRESSfeature(Feature:Integer):byte;
begin
  result:=HiByte(HiWord(Feature));
end;


Function  APPRfeature(Feature:Integer):Word;
begin
  result:=hiword(Feature) ;
//  result:=Loword(Feature) ;
end;

function  MakeFeature(Race:byte;Appr,Hair,Dress,Weapon:byte):Integer;
begin
  result:=MakeLong( MakeWord(Race,weapon),MakeWord(Hair,Dress));
end;

end.

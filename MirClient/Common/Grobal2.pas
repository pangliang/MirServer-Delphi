unit Grobal2;

interface
uses
  Windows, Classes, StrUtils, JSocket;

const
  //商铺相关
  CM_OPENSHOP = 9000;
  CM_BUYSHOPITEM = 9002;
  SM_BUYSHOPITEM_SUCCESS = 9003;
  SM_BUYSHOPITEM_FAIL = 9004;
  SM_SENGSHOPITEMS = 9001; // SERIES 7 每页的数量    wParam 总页数

   CM_4FIREHIT = 3031; //4级烈火攻击
    CM_PHHIT = 3038; //破魂斩
  CM_DAILY = 3042; //逐日剑法 20080511
  CM_TWNHIT = 3037; //开天斩重击
  CM_QTWINHIT = 3041; //开天斩轻击
  CM_CIDHIT = 3040; //龙影剑法

  VERSION_NUMBER = 20020522;
  CLIENT_VERSION_NUMBER = 120040918;
  CM_POWERBLOCK = 0; //Damian
  MAXPATHLEN = 255;
  DIRPATHLEN = 80;
  MapNameLen = 16;
  ActorNameLen = 14;

  DR_UP = 0;
  DR_UPRIGHT = 1;
  DR_RIGHT = 2;
  DR_DOWNRIGHT = 3;
  DR_DOWN = 4;
  DR_DOWNLEFT = 5;
  DR_LEFT = 6;
  DR_UPLEFT = 7;

  U_DRESS = 0;
  U_WEAPON = 1;
  U_RIGHTHAND = 2;
  U_NECKLACE = 3;
  U_HELMET = 4;
  U_ARMRINGL = 5;
  U_ARMRINGR = 6;
  U_RINGL = 7;
  U_RINGR = 8;
  U_BUJUK = 9;
  U_BELT = 10;
  U_BOOTS = 11;
  U_CHARM = 12;

  UNITX = 48;
  UNITY = 32;
  HALFX = 24;
  HALFY = 16;
  MAXBAGITEM = 46; //用户背包最大数量
  MAXMAGIC = 20; //原来54;
  MAXSTORAGEITEM = 50;

  DEFBLOCKSIZE = 16;
  BUFFERSIZE = 10000;
  MAXBAGITEMCL = 52;

  LOGICALMAPUNIT = 40;


  HOWMANYMAGICS = 20; //用户最大练习技能
  USERITEMMAX = 46; //用户最大的物品
  MaxSkillLevel = 3;
  MAX_STATUS_ATTRIBUTE = 12;

  ITEM_WEAPON = 0;
  ITEM_ARMOR = 1;
  ITEM_ACCESSORY = 2;
  ITEM_ETC = 3;
  ITEM_GOLD = 10;

  POISON_DECHEALTH = 0; //中毒类型 - 绿毒
  POISON_DAMAGEARMOR = 1; //中毒类型 - 红毒
  POISON_LOCKSPELL = 2;
  POISON_DONTMOVE = 4;
  POISON_STONE = 5; //中毒类型 - 麻痹
  POISON_6C = 6;
  POISON_68 = 68;
  //  POISON_68              =7;
  STATE_TRANSPARENT = 8;
  STATE_DEFENCEUP = 9;
  STATE_MAGDEFENCEUP = 10;
  STATE_BUBBLEDEFENCEUP = 11;

  STATE_STONE_MODE = $00000001;
  STATE_OPENHEATH = $00000002; //眉仿 傍俺惑怕

  ET_DIGOUTZOMBI = 1; //粱厚啊 顶颇绊 唱柯 如利
  ET_MINE = 2; //堡籍捞 概厘登绢 乐澜
  ET_PILESTONES = 3; //倒公歹扁
  ET_HOLYCURTAIN = 4; //搬拌
  ET_FIRE = 5;
  ET_SCULPEICE = 6; //林付空狼 倒柄柳 炼阿

  RCC_MERCHANT = 50;
  RCC_GUARD = 12;
  RCC_USERHUMAN = 0;



  CM_QUERYUSERSTATE = 82;



  CM_QUERYUSERNAME = 80;
  CM_QUERYBAGITEMS = 81;

  CM_QUERYCHR = 100;
  CM_NEWCHR = 101;
  CM_DELCHR = 102;
  CM_SELCHR = 103;
  CM_SELECTSERVER = 104;

  CM_OPENDOOR = 1002;
  CM_SOFTCLOSE = 1009;

  CM_DROPITEM = 1000;
  CM_PICKUP = 1001;
  CM_TAKEONITEM = 1003;
  CM_TAKEOFFITEM = 1004;
  CM_1005 = 1005;
  CM_EAT = 1006;
  CM_BUTCH = 1007;
  CM_MAGICKEYCHANGE = 1008;

  CM_CLICKNPC = 1010;
  CM_MERCHANTDLGSELECT = 1011;
  CM_MERCHANTQUERYSELLPRICE = 1012;
  CM_USERSELLITEM = 1013;
  CM_USERBUYITEM = 1014;
  CM_USERGETDETAILITEM = 1015;
  CM_DROPGOLD = 1016;
  CM_1017 = 1017;
  CM_LOGINNOTICEOK = 1018;
  CM_GROUPMODE = 1019;
  CM_CREATEGROUP = 1020;
  CM_ADDGROUPMEMBER = 1021;
  CM_DELGROUPMEMBER = 1022;
  CM_USERREPAIRITEM = 1023;
  CM_MERCHANTQUERYREPAIRCOST = 1024;
  CM_DEALTRY = 1025;
  CM_DEALADDITEM = 1026;
  CM_DEALDELITEM = 1027;
  CM_DEALCANCEL = 1028;
  CM_DEALCHGGOLD = 1029;
  CM_DEALEND = 1030;
  CM_USERSTORAGEITEM = 1031;
  CM_USERTAKEBACKSTORAGEITEM = 1032;
  CM_WANTMINIMAP = 1033;
  CM_USERMAKEDRUGITEM = 1034;
  CM_OPENGUILDDLG = 1035;
  CM_GUILDHOME = 1036;
  CM_GUILDMEMBERLIST = 1037;
  CM_GUILDADDMEMBER = 1038;
  CM_GUILDDELMEMBER = 1039;
  CM_GUILDUPDATENOTICE = 1040;
  CM_GUILDUPDATERANKINFO = 1041;
  CM_1042 = 1042;
  CM_ADJUST_BONUS = 1043;
  CM_GUILDALLY = 1044;
  CM_GUILDBREAKALLY = 1045;
  CM_SPEEDHACKUSER = 10430; //??

  CM_PROTOCOL = 2000;
  CM_IDPASSWORD = 2001;
  CM_ADDNEWUSER = 2002;
  CM_CHANGEPASSWORD = 2003;
  CM_UPDATEUSER = 2004;

  CM_THROW = 3005;
  CM_TURN = 3010;
  CM_WALK = 3011;
  CM_SITDOWN = 3012;
  CM_RUN = 3013;
  CM_HIT = 3014;
  CM_HEAVYHIT = 3015;
  CM_BIGHIT = 3016;
  CM_SPELL = 3017;
  CM_POWERHIT = 3018;
  CM_LONGHIT = 3019;

  CM_WIDEHIT = 3024;
  CM_FIREHIT = 3025;

  CM_SAY = 3030;

  //服务器模块之间
  SM_OPENSESSION = 100;
  SM_CLOSESESSION = 101;
  CM_CLOSESESSION = 102;

  SM_THROW = 65069;
  // SM_THROW              = 5;
  SM_RUSH = 6;
  SM_RUSHKUNG = 7; //
  SM_FIREHIT = 8; //烈火
  SM_BACKSTEP = 9;
  SM_TURN = 10;
  SM_WALK = 11; //走
  SM_SITDOWN = 12;
  SM_RUN = 13;
  SM_HIT = 14; //砍
  SM_HEAVYHIT = 15; //
  SM_BIGHIT = 16; //
  SM_SPELL = 17; //使用魔法
  SM_POWERHIT = 18;
  SM_LONGHIT = 19; //刺杀
  SM_DIGUP = 20;
  SM_DIGDOWN = 21;
  SM_FLYAXE = 22;
  SM_LIGHTING = 23;
  SM_WIDEHIT = 24;
  SM_CRSHIT = 25;
  SM_TWINHIT = 26;



  SM_ALIVE = 27; //
  SM_MOVEFAIL = 28; //
  SM_HIDE = 29; //
  SM_DISAPPEAR = 30;
  SM_STRUCK = 31; //弯腰
  SM_DEATH = 32;
  SM_SKELETON = 33;
  SM_NOWDEATH = 34;
  SM_40 = 35;
  SM_41 = 36;
  SM_42 = 37;
  SM_43 = 38;
  SM_HEAR = 40;
  SM_FEATURECHANGED = 41;
  SM_USERNAME = 42;
  //  SM_43                 = 43;
  SM_WINEXP = 44;
  SM_LEVELUP = 45;
  SM_DAYCHANGING = 46;

  SM_LOGON = 50;
  SM_NEWMAP = 51;
  SM_ABILITY = 52;
  SM_HEALTHSPELLCHANGED = 53;
  SM_MAPDESCRIPTION = 54;
  SM_SPELL2 = 117;

  SM_SYSMESSAGE = 100;
  SM_GROUPMESSAGE = 101;
  SM_CRY = 102;
  SM_WHISPER = 103;
  SM_GUILDMESSAGE = 104;

  SM_ADDITEM = 200;
  SM_BAGITEMS = 201;
  SM_DELITEM = 202;
  SM_UPDATEITEM = 203;
  SM_ADDMAGIC = 210;
  SM_SENDMYMAGIC = 211;
  SM_DELMAGIC = 212;

  SM_CERTIFICATION_SUCCESS = 500;
  SM_CERTIFICATION_FAIL = 501;
  SM_ID_NOTFOUND = 502;
  SM_PASSWD_FAIL = 503;
  SM_NEWID_SUCCESS = 504;
  SM_NEWID_FAIL = 505;
  SM_CHGPASSWD_SUCCESS = 506;
  SM_CHGPASSWD_FAIL = 507;
  SM_GETBACKPASSWD_SUCCESS = 508;
  SM_GETBACKPASSWD_FAIL = 509;
  SM_QUERYCHR = 520;
  SM_NEWCHR_SUCCESS = 521;
  SM_NEWCHR_FAIL = 522;
  SM_DELCHR_SUCCESS = 523;
  SM_DELCHR_FAIL = 524;
  SM_STARTPLAY = 525;
  SM_STARTFAIL = 526; //SM_USERFULL
  SM_QUERYCHR_FAIL = 527;
  SM_OUTOFCONNECTION = 528; //?
  SM_PASSOK_SELECTSERVER = 529;
  SM_SELECTSERVER_OK = 530;
  SM_NEEDUPDATE_ACCOUNT = 531;
  SM_UPDATEID_SUCCESS = 532;
  SM_UPDATEID_FAIL = 533;



  SM_DROPITEM_SUCCESS = 600;
  SM_DROPITEM_FAIL = 601;

  SM_ITEMSHOW = 610;
  SM_ITEMHIDE = 611;

  SM_OPENDOOR_OK = 612;
  SM_OPENDOOR_LOCK = 613;
  SM_CLOSEDOOR = 614;

  SM_TAKEON_OK = 615;
  SM_TAKEON_FAIL = 616;
  SM_TAKEOFF_OK = 619;
  SM_TAKEOFF_FAIL = 620;
  SM_SENDUSEITEMS = 621;
  SM_WEIGHTCHANGED = 622;
  SM_CLEAROBJECTS = 633;
  SM_CHANGEMAP = 634;
  SM_EAT_OK = 635;
  SM_EAT_FAIL = 636;
  SM_BUTCH = 637;
  SM_MAGICFIRE = 638;
  SM_MAGICFIRE_FAIL = 639;
  SM_MAGIC_LVEXP = 640;
  SM_DURACHANGE = 642;
  SM_MERCHANTSAY = 643;
  SM_MERCHANTDLGCLOSE = 644;
  SM_SENDGOODSLIST = 645;
  SM_SENDUSERSELL = 646;
  SM_SENDBUYPRICE = 647;
  SM_USERSELLITEM_OK = 648;
  SM_USERSELLITEM_FAIL = 649;
  SM_BUYITEM_SUCCESS = 650; //?
  SM_BUYITEM_FAIL = 651; //?
  SM_SENDDETAILGOODSLIST = 652;
  SM_GOLDCHANGED = 653;
  SM_CHANGELIGHT = 654;
  SM_LAMPCHANGEDURA = 655;
  SM_CHANGENAMECOLOR = 656;
  SM_CHARSTATUSCHANGED = 657;
  SM_SENDNOTICE = 658;
  SM_GROUPMODECHANGED = 659; //
  SM_CREATEGROUP_OK = 660;
  SM_CREATEGROUP_FAIL = 661;
  SM_GROUPADDMEM_OK = 662;
  SM_GROUPDELMEM_OK = 663;
  SM_GROUPADDMEM_FAIL = 664;
  SM_GROUPDELMEM_FAIL = 665;
  SM_GROUPCANCEL = 666;
  SM_GROUPMEMBERS = 667;
  SM_SENDUSERREPAIR = 668;
  SM_USERREPAIRITEM_OK = 669;
  SM_USERREPAIRITEM_FAIL = 670;
  SM_SENDREPAIRCOST = 671;
  SM_DEALMENU = 673;
  SM_DEALTRY_FAIL = 674;
  SM_DEALADDITEM_OK = 675;
  SM_DEALADDITEM_FAIL = 676;
  SM_DEALDELITEM_OK = 677;
  SM_DEALDELITEM_FAIL = 678;
  SM_DEALCANCEL = 681;
  SM_DEALREMOTEADDITEM = 682;
  SM_DEALREMOTEDELITEM = 683;
  SM_DEALCHGGOLD_OK = 684;
  SM_DEALCHGGOLD_FAIL = 685;
  SM_DEALREMOTECHGGOLD = 686;
  SM_DEALSUCCESS = 687;
  SM_SENDUSERSTORAGEITEM = 700;
  SM_STORAGE_OK = 701;
  SM_STORAGE_FULL = 702;
  SM_STORAGE_FAIL = 703;
  SM_SAVEITEMLIST = 704;
  SM_TAKEBACKSTORAGEITEM_OK = 705;
  SM_TAKEBACKSTORAGEITEM_FAIL = 706;
  SM_TAKEBACKSTORAGEITEM_FULLBAG = 707;

  SM_AREASTATE = 708; //原来766;
  SM_MYSTATUS = 766; //原来708;

  SM_DELITEMS = 709;
  SM_READMINIMAP_OK = 710;
  SM_READMINIMAP_FAIL = 711;
  SM_SENDUSERMAKEDRUGITEMLIST = 712;
  SM_MAKEDRUG_SUCCESS = 713;
  //原来SM_MAKEDRUG_FAIL      = 714;
  SM_MAKEDRUG_FAIL = 65036;

  SM_716 = 716;



  SM_CHANGEGUILDNAME = 750;
  SM_SENDUSERSTATE = 751; //
  SM_SUBABILITY = 752;
  SM_OPENGUILDDLG = 753; //
  SM_OPENGUILDDLG_FAIL = 754; //
  SM_SENDGUILDMEMBERLIST = 756; //
  SM_GUILDADDMEMBER_OK = 757; //
  SM_GUILDADDMEMBER_FAIL = 758;
  SM_GUILDDELMEMBER_OK = 759;
  SM_GUILDDELMEMBER_FAIL = 760;
  SM_GUILDRANKUPDATE_FAIL = 761;
  SM_BUILDGUILD_OK = 762;
  SM_BUILDGUILD_FAIL = 763;
  SM_DONATE_OK = 764;
  SM_DONATE_FAIL = 765;

  SM_MENU_OK = 767; //?
  SM_GUILDMAKEALLY_OK = 768;
  SM_GUILDMAKEALLY_FAIL = 769;
  SM_GUILDBREAKALLY_OK = 770; //?
  SM_GUILDBREAKALLY_FAIL = 771; //?
  SM_DLGMSG = 772; //Jacky
  SM_SPACEMOVE_HIDE = 800;
  SM_SPACEMOVE_SHOW = 801;
  SM_RECONNECT = 802; //
  SM_GHOST = 803;
  SM_SHOWEVENT = 804;
  SM_HIDEEVENT = 805;
  SM_SPACEMOVE_HIDE2 = 806;
  SM_SPACEMOVE_SHOW2 = 807;
  SM_TIMECHECK_MSG = 810;
  SM_ADJUST_BONUS = 811; //?

  SM_OPENHEALTH = 1100;
  SM_CLOSEHEALTH = 1101;
  SM_CHANGEFACE = 1104;
  SM_BREAKWEAPON = 1102;
  SM_INSTANCEHEALGUAGE = 1103; //??
  SM_VERSION_FAIL = 1106;

  SM_ITEMUPDATE = 1500;
  SM_MONSTERSAY = 1501;




  SM_EXCHGTAKEON_OK = 65023;
  SM_EXCHGTAKEON_FAIL = 65024;


  SM_ACTION_MIN = SM_RUSH;
  SM_ACTION_MAX = SM_WIDEHIT;

  SM_TEST = 65037;
  //原来  SM_ACTION_MIN = 65070;
  //原来  SM_ACTION_MAX = 65071;
  SM_ACTION2_MIN = 65072;
  SM_ACTION2_MAX = 65073;

  CM_SERVERREGINFO = 65074;

  //-------------------------------------

  CM_GETGAMELIST = 5001;
  SM_SENDGAMELIST = 5002;
  CM_GETBACKPASSWORD = 2005; //5003
  SM_SERVERCONFIG = 5007;
  SM_GAMEGOLDNAME = 5008;
  SM_PASSWORD = 5009;
  SM_HORSERUN = 5010;

  UNKNOWMSG = 199;
  //以下几个正确
  SS_OPENSESSION = 100;
  SS_CLOSESESSION = 101;
  SS_KEEPALIVE = 104;
  SS_KICKUSER = 111;
  SS_SERVERLOAD = 113;

  SS_200 = 200;
  SS_201 = 201;
  SS_202 = 202;
  SS_203 = 203;
  SS_204 = 204;
  SS_205 = 205;
  SS_206 = 206;
  SS_207 = 207;
  SS_208 = 208;
  SS_209 = 209;
  SS_210 = 210;
  SS_211 = 211;
  SS_212 = 212;
  SS_213 = 213;
  SS_214 = 214;
  SS_WHISPER = 203; //原来299;//?????
  SS_SERVERINFO = 103;
  SS_SOFTOUTSESSION = 102;
  SS_LOGINCOST = 3333; // 原来30002;

  //Damian
  DBR_FAIL = 2000;
  DB_LOADHUMANRCD = 100;
  DB_SAVEHUMANRCD = 101;
  DB_SAVEHUMANRCDEX = 102; //?
  DBR_LOADHUMANRCD = 1100;
  DBR_SAVEHUMANRCD = 1102; //?

  SG_FORMHANDLE = 1000;
  SG_STARTNOW = 1001;
  SG_STARTOK = 1002;
  SG_CHECKCODEADDR = 1006;
  SG_USERACCOUNT = 32005;
  SG_USERACCOUNTCHANGESTATUS = 32006;
  SG_USERACCOUNTNOTFOUND = 32007;

  GS_QUIT = 2000;
  GS_USERACCOUNT = 32102;
  GS_CHANGEACCOUNTINFO = 32103;

  //Damian
  RUNGATECODE = $AA55AA55;

  GM_OPEN = 1;
  GM_CLOSE = 2;
  GM_CHECKSERVER = 3; // Send check signal to Server
  GM_CHECKCLIENT = 4; // Send check signal to Client
  GM_DATA = 5;
  GM_SERVERUSERINDEX = 6;
  GM_RECEIVE_OK = 7;
  GM_TEST = 20;

  //M2Server

  GROUPMAX = 11;

  CM_42HIT = 42;

  CM_PASSWORD = 2001;
  CM_CHGPASSWORD = 2002;
  CM_SETPASSWORD = 2004;

  RM_170 = 64170;
  CM_HORSERUN = 3035; //------------未知消息码
  CM_CRSHIT = 3036; //------------未知消息码
  CM_3037 = 3037;
  CM_TWINHIT = 3038;
  CM_QUERYUSERSET = 3040;

  //Damian
  SM_PLAYDICE = 8001;
  SM_PASSWORDSTATUS = 8002;
  SM_NEEDPASSWORD = 8003;
  SM_GETREGINFO = 8004;

  DATA_BUFSIZE = 1024;

  RUNGATEMAX = 20;

  //MAX_STATUS_ATTRIBUTE = 13;

  sSTRING_GOLDNAME = '金币';

  LOG_GAMEGOLD = 1;
  LOG_GAMEPOINT = 2;

  //RC_ANIMAL            = 50;
  //RC_PEACENPC          = 15;
  //RC_MONSTER           = 80;
  //RC_PLAYOBJECT        = 1;
  //RC_NPC               = 10;
  //RC_GUARD             = 12;
  //RC_ARCHERGUARD       = 52;

  RC_PLAYOBJECT = 0;
  RC_GUARD = 11; //大刀守卫
  RC_PEACENPC = 15;
  RC_ANIMAL = 50;
  RC_MONSTER = 80;
  RC_NPC = 10;
  RC_ARCHERGUARD = 112;


  RM_TURN = 10001;
  RM_WALK = 10002;
  RM_HORSERUN = 50003;
  RM_RUN = 10003;
  RM_HIT = 10004;
  RM_BIGHIT = 10006;
  RM_HEAVYHIT = 10007;
  RM_SPELL = 10008;
  RM_SPELL2 = 10009;
  RM_MOVEFAIL = 10010;
  RM_LONGHIT = 10011;
  RM_WIDEHIT = 10012;
  RM_PUSH = 10013; //原来8092;
  RM_FIREHIT = 10014;
  RM_CRSHIT = 10015; //双龙
  RM_DEATH = 10021;
  RM_SKELETON = 10024;

  RM_LOGON = 10050;
  RM_ABILITY = 10051;
  RM_HEALTHSPELLCHANGED = 10052;
  RM_DAYCHANGING = 10053;

  RM_10101 = 10101;
  RM_WEIGHTCHANGED = 10115;
  RM_FEATURECHANGED = 10116;
  RM_BUTCH = 10119;
  RM_MAGICFIRE = 10120;
  RM_MAGICFIREFAIL = 10121;
  RM_SENDMYMAGIC = 10122;

  RM_MAGIC_LVEXP = 10123;
  RM_DURACHANGE = 10125;
  RM_MERCHANTDLGCLOSE = 10127;
  RM_SENDGOODSLIST = 10128;
  RM_SENDUSERSELL = 10129;
  RM_SENDBUYPRICE = 10130;
  RM_USERSELLITEM_OK = 10131;
  RM_USERSELLITEM_FAIL = 10132;
  RM_BUYITEM_SUCCESS = 10133;
  RM_BUYITEM_FAIL = 10134;
  RM_SENDDETAILGOODSLIST = 10135;
  RM_GOLDCHANGED = 10136;
  RM_CHANGELIGHT = 10137;
  RM_LAMPCHANGEDURA = 10138;
  RM_CHARSTATUSCHANGED = 10139;
  RM_GROUPCANCEL = 10140;
  RM_SENDUSERREPAIR = 10141;

  RM_SENDUSERSREPAIR = 50142;
  RM_SENDREPAIRCOST = 10142;
  RM_USERREPAIRITEM_OK = 10143;
  RM_USERREPAIRITEM_FAIL = 10144;
  RM_USERSTORAGEITEM = 10146;
  RM_USERGETBACKITEM = 10147;
  RM_SENDDELITEMLIST = 10148;
  RM_USERMAKEDRUGITEMLIST = 10149;
  RM_MAKEDRUG_SUCCESS = 10150;
  RM_MAKEDRUG_FAIL = 10151;
  RM_ALIVE = 10153;

  RM_10155 = 10155;
  RM_DIGUP = 10200;
  RM_DIGDOWN = 10201;
  RM_FLYAXE = 10202;
  RM_LIGHTING = 10204;
  RM_10205 = 10205;

  RM_CHANGEGUILDNAME = 10301;
  RM_SUBABILITY = 10302;
  RM_BUILDGUILD_OK = 10303;
  RM_BUILDGUILD_FAIL = 10304;
  RM_DONATE_OK = 10305;
  RM_DONATE_FAIL = 10306;

  RM_MENU_OK = 10309;

  RM_RECONNECTION = 10332;
  RM_HIDEEVENT = 10333;
  RM_SHOWEVENT = 10334;

  RM_10401 = 10401;
  RM_OPENHEALTH = 10410;
  RM_CLOSEHEALTH = 10411;
  RM_BREAKWEAPON = 10413;
  RM_10414 = 10414;
  RM_CHANGEFACE = 10415;
  RM_PASSWORD = 10416;

  RM_PLAYDICE = 10500;


  RM_HEAR = 11001;
  RM_WHISPER = 11002;
  RM_CRY = 11003;
  RM_SYSMESSAGE = 11004;
  RM_GROUPMESSAGE = 11005;
  RM_SYSMESSAGE2 = 11006;
  RM_GUILDMESSAGE = 11007;
  RM_SYSMESSAGE3 = 11008;
  RM_MERCHANTSAY = 11009;


  RM_ZEN_BEE = 8020;
  RM_DELAYMAGIC = 8021;
  RM_STRUCK = 8018;
  RM_MAGSTRUCK_MINE = 8030;
  RM_MAGHEALING = 8034;

  RM_POISON = 8037;

  RM_DOOPENHEALTH = 8040;
  RM_SPACEMOVE_FIRE2 = 8042;
  RM_DELAYPUSHED = 8043;
  RM_MAGSTRUCK = 8044;
  RM_TRANSPARENT = 8045;

  RM_DOOROPEN = 8046;
  RM_DOORCLOSE = 8047;
  RM_DISAPPEAR = 8061;
  RM_SPACEMOVE_FIRE = 8062;
  RM_SENDUSEITEMS = 8074;
  RM_WINEXP = 8075;
  RM_ADJUST_BONUS = 8078;
  RM_ITEMSHOW = 8082;
  RM_GAMEGOLDCHANGED = 8084;
  RM_ITEMHIDE = 8085;
  RM_LEVELUP = 8086;

  RM_CHANGENAMECOLOR = 8090;

  RM_CLEAROBJECTS = 8097;
  RM_CHANGEMAP = 8098;
  RM_SPACEMOVE_SHOW2 = 8099;
  RM_SPACEMOVE_SHOW = 8100;
  RM_USERNAME = 8101;
  RM_MYSTATUS = 8102;
  RM_STRUCK_MAG = 8103;
  RM_RUSH = 8104;
  RM_RUSHKUNG = 8105;
  RM_PASSWORDSTATUS = 8106;
  RM_POWERHIT = 8107;

  RM_41 = 9041;
  RM_TWINHIT = 9042;
  RM_43 = 9043;



  OS_EVENTOBJECT = 1;
  OS_MOVINGOBJECT = 2;
  OS_ITEMOBJECT = 3;
  OS_GATEOBJECT = 4;
  OS_MAPEVENT = 5;
  OS_DOOR = 6;
  OS_ROON = 7;


  //技能编号（正确）
  SKILL_FIREBALL = 1;
  SKILL_HEALLING = 2;
  SKILL_ONESWORD = 3;
  SKILL_ILKWANG = 4;
  SKILL_FIREBALL2 = 5;
  SKILL_AMYOUNSUL = 6; //施毒术
  SKILL_YEDO = 7;
  SKILL_FIREWIND = 8;
  SKILL_FIRE = 9;
  SKILL_SHOOTLIGHTEN = 10;
  SKILL_LIGHTENING = 11;
  SKILL_ERGUM = 12;
  SKILL_FIRECHARM = 13;
  SKILL_HANGMAJINBUB = 14;
  SKILL_DEJIWONHO = 15;
  SKILL_HOLYSHIELD = 16;
  SKILL_SKELLETON = 17;
  SKILL_CLOAK = 18;
  SKILL_BIGCLOAK = 19;
  SKILL_TAMMING = 20;
  SKILL_SPACEMOVE = 21;
  SKILL_EARTHFIRE = 22;
  SKILL_FIREBOOM = 23;
  SKILL_LIGHTFLOWER = 24;
  SKILL_BANWOL = 25;
  SKILL_FIRESWORD = 26;
  SKILL_MOOTEBO = 27;
  SKILL_SHOWHP = 28;
  SKILL_BIGHEALLING = 29;
  SKILL_SINSU = 30;
  SKILL_SHIELD = 31;
  SKILL_KILLUNDEAD = 32;
  SKILL_SNOWWIND = 33;
  SKILL_UNAMYOUNSUL = 34; //解毒术
  SKILL_WINDTEBO = 35; //老狮子
  SKILL_MABE = 36; //火焰冰
  SKILL_GROUPLIGHTENING = 37; //群体雷电
  SKILL_GROUPAMYOUNSUL = 38; //群体施毒术
  SKILL_GROUPDEDING = 39; //地钉
  SKILL_40 = 40; //双龙斩
  SKILL_41 = 41; //狮子吼
  SKILL_42 = 42; //狂风剑法
  SKILL_43 = 43; //破空剑
  SKILL_44 = 44; //结冰掌
  SKILL_45 = 45; //灭天火
  SKILL_46 = 46; //分身术
  SKILL_47 = 47; //火龙气焰
  SKILL_ENERGYREPULSOR = 48; //气功波
  SKILL_49 = 49; //净化术
  SKILL_UENHANCER = 50; //无极真气
  SKILL_51 = 51; //飓风破
  SKILL_52 = 52; //诅咒术
  SKILL_53 = 53; //血咒
  SKILL_ANGEL = 54; //骷髅咒召唤精灵
  SKILL_55 = 55; //阴阳盾
  SKILL_REDBANWOL = 56; //
  SKILL_57 = 57;
  SKILL_58 = 58;
  SKILL_59 = 59;
  SKILL_60 = 60;
  SKILL_61 = 61;
  SKILL_62 = 62;
  SKILL_63 = 63;
  SKILL_64 = 64;
  SKILL_65 = 65;
  SKILL_66 = 66; //强化骷髅
  SKILL_67 = 67;
  SKILL_68 = 68;
  SKILL_69 = 69;
  SKILL_70 = 70;
  SKILL_71 = 71;
  SKILL_72 = 72;
  SKILL_73 = 73;
  SKILL_74 = 74; //擒龙手
  SKILL_75 = 75;
  SKILL_76 = 76;
  SKILL_77 = 77; //移形换影
  SKILL_78 = 78; //移形换影

  LA_UNDEAD = 1;

  sENCYPTSCRIPTFLAG = 'SETSCRIPTFLAG';
  sSTATUS_FAIL = '+FAIL/';
  sSTATUS_GOOD = '+GOOD/';

type
  //-----------------------------------------
  pTDefaultMessage = ^TDefaultMessage;
  TDefaultMessage = record
    Recog: Integer;
    ident: Word;
    param: Word;
    tag: Word;
    series: Word;
  end;

  pTGameZone = ^TGameZone;
  TGameZone = record
    sGameName: AnsiString;
    sServerName: AnsiString;
    nGameIPPort: Integer;
    sGameIPaddr: AnsiString;
    sGameDomain: AnsiString;
    boOpened: Boolean;
    boIsChatServer: Boolean;
    sProgamFile: AnsiString;
    sNoticeUrl: AnsiString;
    boIsOnServer: Boolean;
  end;

  TChrMsg = record
    ident: Integer;
    X: Integer;
    Y: Integer;
    dir: Integer;
    State: Integer;
    Feature: Integer;
    saying: string;
    sound: Integer;
  end;
  pTChrMsg = ^TChrMsg;

  pTOStdItem = ^TOStdItem;
  TOStdItem = record //OK
    name: string[14];
    StdMode: byte;
    Shape: byte;
    Weight: byte;
    AniCount: byte;
    Source: byte;
    Reserved: byte;
    NeedIdentify: byte;
    looks: Word;
    DuraMax: Word;
    AC: Word;
    MAC: Word;
    DC: Word;
    MC: Word;
    SC: Word;
    Need: byte;
    NeedLevel: byte;
    Price: UINT;
  end;

  pTStdItem = ^TStdItem;
  TStdItem = packed record //60 bytes
    name: string[14]; //原来:String[20];    //15 物品名称
    StdMode: byte; //1  物品种类
    Shape: byte; //1  书的类别
    Weight: byte; //1  重量
    AniCount: byte; //1
    Source: shortint; //1  武器神圣值
    Reserved: byte; //1
    NeedIdentify: byte; //1  武器升级后标记
    looks: Word; //2  外观，即Items.WIL中的图片索引
    DuraMax: DWORD; //4  持久力
    AC: DWORD; //4  防御 高位：武器准确 低位：武器幸运
    MAC: DWORD; //4  防魔 高位：武器速度 低位：武器诅咒
    DC: DWORD; //4  攻击
    MC: DWORD; //4  魔法
    SC: DWORD; //4 道术
    Need: DWORD; //4  其他要求 0：等级 1：攻击力 2：魔法力 3：精神力
    NeedLevel: DWORD; //4  Need要求数值
    Price: UINT; //4  价格
  end;

  PTClientItem = ^TClientItem;
  TClientItem = record //OK
    S: TStdItem;
    MakeIndex: Integer;
    Dura: Word;
    DuraMax: Word;
  end;

  TOClientItem = record
    S: TOStdItem;
    MakeIndex: Integer;
    Dura: Word;
    DuraMax: Word;
  end;

  TUserStateInfo = record //OK
    Feature: Integer;
    UserName: string[19];
    GuildName: string[14];
    GuildRankName: string[14];
    NameColor: Word;
    UseItems: array[0..12] of TClientItem;
  end;
  TUserCharacterInfo = record
    name: string[19];
    job: byte;
    hair: byte;
    Level: Word;
    sex: byte;
  end;
  TUserEntry = record
    sAccount: string[10];
    sPassword: string[10];
    sUserName: string[20];
    sSSNo: string[14];
    sPhone: string[14];
    sQuiz: string[20];
    sAnswer: string[12];
    sEMail: string[40];
  end;
  TUserEntryAdd = record
    sQuiz2: string[20];
    sAnswer2: string[12];
    sBirthDay: string[10];
    sMobilePhone: string[15];
    sMemo: string[40];
    sMemo2: string[40];
  end;

  TOUserStateInfo = record
    Feature: Integer;
    UserName: string[19];
    GuildName: string[14];
    GuildRankName: string[16];
    NameColor: Integer;
    UseItems: array[0..12] of TOClientItem; //原来8
  end;

  TDropItem = record
    X: Integer;
    Y: Integer;
    id: Integer;
    looks: Integer;
    name: string;
    FlashTime: DWORD;
    FlashStepTime: DWORD;
    FlashStep: Integer;
    BoFlash: Boolean;
  end;
  pTDropItem = ^TDropItem;

  pTMagic = ^TMagic;
  TMagic = record //+
    wMagicId: Word;
    sMagicName: string[12];
    btEffectType: byte;
    btEffect: byte;
    wSpell: Word;
    wPower: Word;
    TrainLevel: array[0..3] of byte;
    MaxTrain: array[0..3] of Integer;
    btTrainLv: byte;
    btJob: byte;
    dwDelayTime: Integer;
    btDefSpell: byte;
    btDefPower: byte;
    wMaxPower: Word;
    btDefMaxPower: byte;
    sDescr: string[15];
  end;
  TClientMagic = record //84
    Key: Char;
    Level: byte;
    CurTrain: Integer;
    Def: TMagic;
  end;
  PTClientMagic = ^TClientMagic;


  TOAbility = record //OK    //Size 40
    Level: Word; //0x198
    AC: Word; //0x19A
    MAC: Word; //0x19C
    DC: Word; //0x19E
    MC: Word; //0x1A0
    SC: Word; //0x1A2
    HP: Word; //0x1A4
    MP: Word; //0x1A6
    MaxHP: Word; //0x1A8
    MaxMP: Word; //0x1AA
    dw1AC: DWORD; //0x1AC
    Exp: DWORD; //0x1B0
    MaxExp: DWORD; //0x1B4
    Weight: Word; //0x1B8
    MaxWeight: Word; //0x1BA
    WearWeight: byte; //0x1BC
    MaxWearWeight: byte; //0x1BD
    HandWeight: byte; //0x1BE
    MaxHandWeight: byte; //0x1BF
  end;
  //for db

//end

  TShortMessage = record
    ident: Word;
    wMsg: Word;
  end;

  TMessageBodyW = record
    Param1: Word;
    Param2: Word;
    Tag1: Word;
    Tag2: Word;
  end;

  TMessageBodyWL = record //16  0x10
    lParam1: Integer;
    lParam2: Integer;
    lTag1: Integer;
    lTag2: Integer;
  end;

  TCharDesc = record
    Feature: Integer;
    Status: Integer;
  end;
  TClientGoods = record
    name: string;
    SubMenu: Integer;
    Price: Integer;
    Stock: Integer;
    Grade: Integer;
  end;
  PTClientGoods = ^TClientGoods;





  //---------------------------------------------

type

  TGList = class(TList)
  private
    CriticalSection: TRTLCriticalSection;

  public
    constructor Create;
    destructor Destroy; override;

    procedure Lock;
    procedure Unlock;
  end;

  TGStringList = class(TStringList)
  private
    CriticalSection: TRTLCriticalSection;

  public
    constructor Create;
    destructor Destroy; override;

    procedure Lock;
    procedure Unlock;
  end;

type
  TProgamType = (tDBServer, tLoginSrv, tLogServer, tM2Server, tLoginGate,
    tLoginGate1, tSelGate, tSelGate1, tRunGate, tRunGate1, tRunGate2,
    tRunGate3, tRunGate4, tRunGate5, tRunGate6, tRunGate7);

  TRecordHeader = packed record
    sAccount: string[16];
    sname: string[20];

    nSelectID: Integer;
    dCreateDate: TDateTime;
    boDeleted: Boolean;
    UpdateDate: TDateTime;
    CreateDate: TDateTime;
  end;
  pTNakedAbility = ^TNakedAbility;
  TNakedAbility = record
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
  //支持4格的人物能力值
  pTAbility = ^TAbility;
  TAbility = packed record //50Bytes
    Level: Word; //1  2  等级
    AC: DWORD; //3  6
    MAC: DWORD; //7  10
    DC: DWORD; //11 14
    MC: DWORD; //15 18
    SC: DWORD; //19 22
    HP: Word; //23 24 生命值
    MP: Word; //25 26 魔法值
    MaxHP: Word; //27 28
    MaxMP: Word; //29 30
    Exp: DWORD; //31 34 当前经验
    MaxExp: DWORD; //35 38 最大经验
    Weight: Word; //39 40 背包重
    MaxWeight: Word; //41 42 背包最大重量
    WearWeight: Word; //43 44   当前负重
    MaxWearWeight: Word; //45 46   最大负重
    HandWeight: Word; //47 48    腕力
    MaxHandWeight: Word; //49 50   最大腕力
  end;
  THumInfo = record
    boDeleted: Boolean;
    boSelected: Boolean;
    sAccount: string[10];
    dModDate: TDateTime;
    sChrName: string[20];
    btCount: byte;
    Header: TRecordHeader;
  end;

  pTSocketBuff = ^TSocketBuff;
  TSocketBuff = record
    buffer: PChar; //0x24
    nLen: Integer; //0x28
  end;
  pTSendBuff = ^TSendBuff;
  TSendBuff = record
    nLen: Integer;
    buffer: array[0..DATA_BUFSIZE - 1] of Char;
  end;

  pTUserItem = ^TUserItem;
  TUserItem = record //=24
    MakeIndex: Integer; //+4
    wIndex: Word; //+2
    Dura: Word; //+2
    DuraMax: Word; //+2
    btValue: array[0..13] of byte; //+14
    //sPrefix     :String[10];
  end;

  THumanUseItems = array[0..12] of TUserItem;
  THumItems = array[0..12] of TUserItem;
  pTHumItems = ^THumItems;
  //  THumAddItems=Array[9..12] of TUserItem; //KK666
  //  pTHumAddItems=^THumAddItems; //KK666
  pTBagItems = ^TBagItems;
  TBagItems = array[0..54 - 12] of TUserItem;
  pTStorageItems = ^TStorageItems;
  TStorageItems = array[0..49] of TUserItem;

  pTUserMagic = ^TUserMagic;
  TUserMagic = record
    MagicInfo: pTMagic;
    btLevel: byte;
    wMagIdx: Word;
    nTranPoint: Integer;
    btKey: byte;
  end;

  pTHumMagic = ^THumMagic;
  THumMagic = array[0..HOWMANYMAGICS - 1] of TUserMagic;

  pTHumMagicInfo = ^THumMagicInfo;
  THumMagicInfo = TUserMagic;

  TStatusTime = array[0..MAX_STATUS_ATTRIBUTE - 1] of Word;

  TQuestUnit = array[0..127] of byte;

  TQuestFlag = array[0..127] of byte;


  //Correct structure..

  pTHumData = ^THumData;
  THumData = packed record //3164
    sChrName: string[ActorNameLen];
    sCurMap: string[MapNameLen];
    wCurX: Word;
    wCurY: Word;
    btDir: byte;
    btHair: byte;
    btSex: byte;
    btJob: byte;
    nGold: Integer;

    abil: TAbility; //+40
    wStatusTimeArr: TStatusTime;
    sHomeMap: string[MapNameLen];
    wHomeX: Word;
    wHomeY: Word;
    BonusAbil: TNakedAbility; //+20
    nBonusPoint: Integer;
    btCreditPoint: byte;
    btReLevel: byte;

    sMasterName: string[ActorNameLen];
    boMaster: Boolean;
    sDearName: string[ActorNameLen];
    sStoragePwd: string[10];

    nGameGold: Integer;
    nGamePoint: Integer;
    nPayMentPoint: Integer;
    nPKPoint: Integer;

    btAllowGroup: byte;
    btF9: byte;
    btAttatckMode: byte;
    btIncHealth: byte;
    btIncSpell: byte;
    btIncHealing: byte;
    btFightZoneDieCount: byte;
    btEE: byte;
    btEF: byte;


    sAccount: string[16];
    boLockLogon: Boolean;

    wContribution: Word;
    nHungerStatus: Integer;
    boAllowGuildReCall: Boolean; //274  是否允许行会合一
    wGroupRcallTime: Word; //272. 组队传送时间
    dBodyLuck: TDateTime; //278  幸运度
    boAllowGroupReCall: Boolean; //286  是否允许天地合一
    QuestUnitOpen: TQuestUnit; //ok   脚本变量
    QuestUnit: TQuestUnit;
    QuestFlag: TQuestFlag;

    btMarryCount: byte;


    HumItems: THumItems;
    //    HumAddItems     :THumAddItems; //KK666
    BagItems: TBagItems;
    Magic: THumMagic;
    StorageItems: TStorageItems;
  end;

  THumDataInfo = packed record
    Header: TRecordHeader;
    data: THumData;
  end;

  pTQuickID = ^TQuickID;
  TQuickID = record
    nSelectID: Integer;
    sAccount: string[16];
    nIndex: Integer;
    sChrName: string[20];
  end;

  pTGlobaSessionInfo = ^TGlobaSessionInfo;
  TGlobaSessionInfo = record
    sAccount: string[16];
    nSessionID: Integer;
    boLoadRcd: Boolean;
    boStartPlay: Boolean;
    sIPaddr: string[15];
    n24: Integer;
    dwAddTick: DWORD;
    dAddDate: TDateTime;
  end;

  TCheckCode = packed record
    dwThread0: DWORD;
    sThread0: string;
  end;

  TAccountDBRecord = record
    Header: TRecordHeader;
    nErrorCount: Integer;
    dwActionTick: DWORD;
    UserEntry: TUserEntry;
    UserEntryAdd: TUserEntryAdd;
  end;


  pTConnInfo = ^TConnInfo;
  TConnInfo = record

  end;

  pTQueryChr = ^TQueryChr;
  TQueryChr = packed record
    btClass: byte;
    btHair: byte;
    btGender: byte;
    btLevel: byte;
    sname: string[19];
  end;

  pTMsgHeader = ^TMsgHeader;
  TMsgHeader = record
    dwCode: DWORD;
    nSocket: Integer;
    wGSocketIdx: Word;
    wIdent: Word;
    wUserListIndex: Word;
    nLength: Integer;
  end;

  PTMapItem = ^TMapItem;
  TMapItem = record
    name: string[40];
    looks: Word;
    AniCount: byte;
    Reserved: Integer;
    count: Integer;
    DropBaseObject: TObject;
    OfBaseObject: TObject;
    dwCanPickUpTick: DWORD;
    UserItem: TUserItem;
  end;

  pTDoorStatus = ^TDoorStatus;
  TDoorStatus = record
    bo01: Boolean;
    n04: Integer;
    boOpened: Boolean;
    dwOpenTick: DWORD;
    nRefCount: Integer;
  end;

  pTDoorInfo = ^TDoorInfo;
  TDoorInfo = record
    nX, nY: Integer;
    Status: pTDoorStatus;
    n08: Integer;
  end;

  pTMapFlag = ^TMapFlag;
  TMapFlag = record
    boSAFE: Boolean;
    boDARK: Boolean;
    boFIGHT: Boolean;
    boFIGHT2: Boolean;
    boFIGHT3: Boolean;
    boDAY: Boolean;
    nL: Integer;
    nNEEDSETONFlag: Integer;
    nNeedONOFF: Integer;
    nMUSICID: Integer;
    boDarkness: Boolean;
    boDayLight: Boolean;
    boFightZone: Boolean;
    boFight2Zone: Boolean;
    boFight3Zone: Boolean;
    boQUIZ: Boolean;
    boNORECONNECT: Boolean;
    sNoReConnectMap: string;
    sReConnectMap: string;
    boMUSIC: Boolean;
    boEXPRATE: Boolean;
    nEXPRATE: Integer;
    boPKWINLEVEL: Boolean;
    nPKWINLEVEL: Integer;
    boPKWINEXP: Boolean;
    nPKWINEXP: Integer;
    boPKLOSTLEVEL: Boolean;
    nPKLOSTLEVEL: Integer;
    boPKLOSTEXP: Boolean;
    nPKLOSTEXP: Integer;
    boDECHP: Boolean;
    nDECHPPOINT: Integer;
    nDECHPTIME: Integer;
    boINCHP: Boolean;
    nINCHPPOINT: Integer;
    nINCHPTIME: Integer;
    boDECGAMEGOLD: Boolean;
    nDECGAMEGOLD: Integer;
    nDECGAMEGOLDTIME: Integer;
    boDECGAMEPOINT: Boolean;
    nDECGAMEPOINT: Integer;
    nDECGAMEPOINTTIME: Integer;
    boINCGAMEGOLD: Boolean;
    nINCGAMEGOLD: Integer;
    nINCGAMEGOLDTIME: Integer;
    boINCGAMEPOINT: Boolean;
    nINCGAMEPOINT: Integer;
    nINCGAMEPOINTTIME: Integer;
    boNOHUMNOMON: Boolean;
    boRunHuman: Boolean;
    boRunMon: Boolean;
    boNEEDHOLE: Boolean;
    boNORECALL: Boolean;
    boNOGUILDRECALL: Boolean;
    boNODEARRECALL: Boolean;
    boNOMASTERRECALL: Boolean;
    boNORANDOMMOVE: Boolean;
    boNODRUG: Boolean;
    boMINE: Boolean;
    boGEMSTONE: Boolean;
    boNOPOSITIONMOVE: Boolean;
    boNODROPITEM: Boolean;
    boNOTHROWITEM: Boolean;
    boNOHORSE: Boolean;
    boNOCHAT: Boolean;
    boNOFIREMAGIC: Boolean;
  end;

  TAddAbility = record //Damian
    wHP, wMP: Word;
    wHitPoint, wSpeedPoint: Word;
    wAC, wMAC, wDC, wMC, wSC: DWORD;
    wAntiPoison, wPoisonRecover,
      wHealthRecover, wSpellRecover: Word;
    wAntiMagic: Word;
    btLuck, btUnLuck: byte;
    btWeaponStrong: byte;
    nHitSpeed: Word;
    btUndead: byte;

    Weight, WearWeight, HandWeight: Word;
  end;


  TMsgColor = (c_Red, c_Green, c_Blue, c_White);

  pTProcessMessage = ^TProcessMessage;
  TProcessMessage = record
    wIdent: Word;
    WParam: Word;
    nParam1: Integer;
    nParam2: Integer;
    nParam3: Integer;
    dwDeliveryTime: DWORD;
    BaseObject: TObject;
    boLateDelivery: Boolean;
    smsg: string;
  end;

  pTSessInfo = ^TSessInfo;
  TSessInfo = record
    nSessionID: Integer;
    sAccount: string[10];
    sIPaddr: string;
    nPayMent: Integer;
    nPayMode: Integer;
    nSessionStatus: Integer;
    dwStartTick: DWORD;
    dwActiveTick: DWORD;
    nRefCount: Integer;
    nSocket: Integer;
    nGateIdx: Integer;
    nGSocketIdx: Integer;
    dwNewUserTick: DWORD;
    nSoftVersionDate: Integer;
  end;

  TScriptQuestInfo = record
    wFlag: Word;
    btValue: byte;
    nRandRage: Integer;
  end;
  TQuestInfo = array of TScriptQuestInfo;

  pTScript = ^TScript;
  TScript = record
    boQuest: Boolean;
    QuestInfo: TQuestInfo;
    RecordList: TList;
    nQuest: Integer;
  end;

  pTLoadDBInfo = ^TLoadDBInfo;
  TLoadDBInfo = record
    nGateIdx: Integer;
    nSocket: Integer;
    sAccount: string[10];
    sCharName: string[20];
    nSessionID: Integer;
    sIPaddr: string[15];
    nSoftVersionDate: Integer;
    nPayMent: Integer;
    nPayMode: Integer;
    nGSocketIdx: Integer;
    dwNewUserTick: DWORD;
    PlayObject: TObject;
    nReLoadCount: Integer;
  end;

  pTGoldChangeInfo = ^TGoldChangeInfo;
  TGoldChangeInfo = record
    sGameMasterName: string;
    sGetGoldUser: string;
    nGold: Integer;
  end;

  pTSaveRcd = ^TSaveRcd;
  TSaveRcd = record
    sAccount: string[16];
    sChrName: string[20];
    nSessionID: Integer;
    PlayObject: TObject;
    HumanRcd: THumDataInfo;
    nReTryCount: Integer;
  end;

  pTMonGenInfo = ^TMonGenInfo;
  TMonGenInfo = record
    sMapName: string;
    nX, nY: Integer;
    sMonName: string;
    nRange: Integer;
    nCount: Integer;
    dwZenTime: DWORD;
    nMissionGenRate: Integer;
    CertList: TList;
    Envir: TObject;
    nrace: Integer;
    dwStartTick: DWORD;
  end;

  pTMonInfo = ^TMonInfo;
  TMonInfo = record
    ItemList: TList;
    sname: string;
    btRace: byte;
    btRaceImg: byte;
    wAppr: Word;
    wLevel: Word;
    btLifeAttrib: byte;
    wCoolEye: Word;
    dwExp: DWORD;
    wHP, wMP: Word;
    wAC, wMAC, wDC, wMaxDC, wMC, wSC: Word;
    wSpeed, wHitPoint, wWalkSpeed, wWalkStep, wWalkWait, wAttackSpeed: Word;
    wAntiPush: Word;
    boAggro, boTame: Boolean;
  end;

  pTMonItem = ^TMonItem;
  TMonItem = record
    MaxPoint: Integer;
    SelPoint: Integer;
    itemname: string[14];
    count: Integer;
  end;

  pTUnbindInfo = ^TUnbindInfo;
  TUnbindInfo = record
    nUnbindCode: Integer;
    sItemName: string[14];
  end;

  TSlaveInfo = record
    sSlaveName: string;
    btSlaveLevel: byte;
    dwRoyaltySec: DWORD;
    nKillCount: Integer;
    btSlaveExpLevel: byte;
    nHP, nMP: Integer;
  end;
  pTSlaveInfo = ^TSlaveInfo;

  pTSwitchDataInfo = ^TSwitchDataInfo;
  TSwitchDataInfo = record
    sMap: string;
    wX, wY: Word;
    abil: TAbility;
    sChrName: string;
    nCode: Integer;
    boC70: Boolean;
    boBanShout: Boolean;
    boHearWhisper: Boolean;
    boBanGuildChat: Boolean;
    boAdminMode: Boolean;
    boObMode: Boolean;
    BlockWhisperArr: array of string;
    SlaveArr: array of TSlaveInfo;
    StatusValue: array[0..5] of Word;
    StatusTimeOut: array[0..5] of LongWord;
  end;

  {  TIPaddr=record
      sIpaddr:String;
      dIPaddr:String;
    end;}

  PTIPAddr = ^TIPaddr;
  TIPaddr = packed record
    a, b, c, d: byte;
    Port: Integer;
    sIPaddr: string[15];
    dIPaddr: string[15];
  end;

  pTIPaddrInfo = ^TIPaddrInfo;
  TIPaddrInfo = packed record
    a, b, c, d: byte;
    Port: Integer;
    sIPaddr: string[15];
    dIPaddr: string[15];
    nPort: Integer;
  end;

  pTGateInfo = ^TGateInfo;
  TGateInfo = record
    boUsed: Boolean;
    Socket: TCustomWinSocket;
    sAddr: string;
    nPort: Integer;
    n520: Integer;
    UserList: TList;
    nUserCount: Integer;
    buffer: PChar;
    nBuffLen: Integer;
    BufferList: TList;
    boSendKeepAlive: Boolean;
    nSendChecked: Integer;
    nSendBlockCount: Integer;
    dwStartTime: DWORD;
    nSendMsgCount: Integer;
    nSendRemainCount: Integer;
    dwSendTick: DWORD;
    nSendMsgBytes: Integer;
    nSendBytesCount: Integer;
    nSendedMsgCount: Integer;
    nSendCount: Integer;
    dwSendCheckTick: DWORD;
    nRecvMsgBytes: Integer;
    nRecvMsgCount: Integer;
  end;

  pTGateUserInfo = ^TGateUserInfo;
  TGateUserInfo = record
    PlayObject: TObject;
    nSessionID: Integer;
    sAccount: string[10];
    nGSocketIdx: Integer;
    sIPaddr: string[15];
    boCertification: Boolean;
    sCharName: string[20];
    nClientVersion: Integer;
    SessInfo: pTSessInfo;
    nSocket: Integer;
    FrontEngine: TObject;
    UserEngine: TObject;
    dwNewUserTick: DWORD;
  end;

  {  TClassProc=procedure(Sender:TObject);
    TCheckVersion=class
    end;

    TProc = record
      sProcName: string;
      nProcAddr: Pointer;
    end;
    TProcArray = array[0..100] of TProc;
    TmyObject = record
      sObjcName: string;
      Obj: TObject;
      end; }//kk666




  TMainMessageProc = procedure(Msg: PChar; nMsgLen: Integer; nMode: Integer); stdcall;
  TFindProcTableProc = function(ProcName: PChar; nNameLen: Integer): Pointer; stdcall;
  TSetProcTableProc = function(ProcAddr: Pointer; ProcName: PChar; nNameLen: Integer): Boolean; stdcall;
  // TDeCryptString=Procedure (src:Pointer;dest:pointer;srcLen:integer;var destLen:Integer);


  TClientConf = record
    boClientCanSet: Boolean;
    boRunHuman: Boolean;
    boRunMon: Boolean;
    boRunNpc: Boolean;
    boWarRunAll: Boolean;
    btDieColor: byte;
    wSpellTime: Word;
    wHitIime: Word;
    wItemFlashTime: Word;
    btItemSpeed: byte;
    boCanStartRun: Boolean;
    boParalyCanRun: Boolean;
    boParalyCanWalk: Boolean;
    boParalyCanHit: Boolean;
    boParalyCanSpell: Boolean;
    boShowRedHPLable: Boolean;
    boShowHPNumber: Boolean;
    boShowJobLevel: Boolean;
    boDuraAlert: Boolean;
    boMagicLock: Boolean;
    boAutoPuckUpItem: Boolean;
  end;


  TCheckItem = record
    szItemName: string[14];
    boCanDrop: Boolean;
    boCanDeal: Boolean;
    boCanStorage: Boolean;
    boCanRepair: Boolean;
  end;
  pTCheckItem = ^TCheckItem;

  pTAdminInfo = ^TAdminInfo;
  TAdminInfo = record
    nLv: Integer;
    sChrName: string[20];
    sIPaddr: string[15];
  end;

  pTMonDrop = ^TMonDrop;
  TMonDrop = record
    sItemName: string[14];
    nDropCount: Integer;
    nNoDropCount: Integer;
    nCountLimit: Integer;
  end;

  TMonStatus = (s_KillHuman, s_UnderFire, s_Die, s_MonGen);

  pTMonSayMsg = ^TMonSayMsg;
  TMonSayMsg = record
    State: TMonStatus;
    Color: TMsgColor;
    nRate: Integer;
    sSayMsg: string;
  end;

  TBianfuData = packed record
    Feature: Integer;
    Status: Integer;
    HP: Word;
    MaxHP: Word;
    X: Word;
    Y: Word;
    unknow: Integer;
    CharName: array[0..12] of Char;
  end;

  TVarType = (vNone, VInteger, VString);
  pTDynamicVar = ^TDynamicVar;
  TDynamicVar = record
    sname: string;
    VarType: TVarType;
    nInternet: Integer;
    sString: string;
  end;

  pTItemName = ^TItemName;
  TItemName = record
    nMakeIndex: Integer;
    nItemIndex: Integer;
    sItemName: string[14];
  end;

  { TLoadHuman=record
    sAccount:String[16];
    sChrName:String[20];
    sUserAddr:String[15];
    nSessionID:integer;
  end;}//kk666

  TLoadHuman = record
    sAccount: string[12];
    sChrName: string[14];
    sUserAddr: string[15];
    nSessionID: Integer;
  end;

  TOSObject = record
    btType: byte;
    dwAddTime: DWORD;
    CellObj: TObject;
  end;
  pTOSObject = ^TOSObject;

  pTSrvNetInfo = ^TSrvNetInfo;
  TSrvNetInfo = record
    sIPaddr: string;
    nPort: Integer;
  end;

  pTUserOpenInfo = ^TUserOpenInfo;
  TUserOpenInfo = record
    sChrName: string[20];
    LoadUser: TLoadDBInfo;
    HumanRcd: THumDataInfo;
  end;

  pTGateObj = ^TGateObj;
  TGateObj = record
    DEnvir: TObject;
    nDMapX,
      nDMapY: Integer;
    boFlag: Boolean;
  end;

  pTMapQuestInfo = ^TMapQuestInfo;
  TMapQuestInfo = record
    nFlag: Integer;
    nValue: Integer;
    sMonName: string[ActorNameLen];
    sItemName: string[14];
    boGrouped: Boolean;
    NPC: TObject;
  end;

  //Damian
  TRegInfo = record
    sKey: string;
    sServerName: string;
    sRegSrvIP: string[15];
    nRegPort: Integer;
  end;


  pTPowerBlock = ^TPowerBlock;
  TPowerBlock = array[0..100 - 1] of Word; //Damian

function MakeDefaultMsg(Msg: smallint; Recog: Integer; param, tag, series: Word): TDefaultMessage;
function APPRfeature(cfeature: Integer): Word;
function RACEfeature(cfeature: Integer): byte;
function HAIRfeature(cfeature: Integer): byte;
function DRESSfeature(cfeature: Integer): byte;
function WEAPONfeature(cfeature: Integer): byte;
function Horsefeature(cfeature: Integer): byte;
function Effectfeature(cfeature: Integer): byte;
function MakeHumanFeature(btRaceImg, btDress, btWeapon, btHair: byte): Integer;
function MakeMonsterFeature(btRaceImg, btWeapon: byte; wAppr: Word): Integer;


implementation

{ TGList }

constructor TGList.Create;
begin
  inherited;
  InitializeCriticalSection(CriticalSection);
end;

destructor TGList.Destroy;
begin
  DeleteCriticalSection(CriticalSection);
  inherited;
end;

procedure TGList.Lock;
begin
  EnterCriticalSection(CriticalSection);
end;

procedure TGList.Unlock;
begin
  LeaveCriticalSection(CriticalSection);
end;

{ TGStringList }

constructor TGStringList.Create;
begin
  inherited;
  InitializeCriticalSection(CriticalSection);
end;

destructor TGStringList.Destroy;
begin
  DeleteCriticalSection(CriticalSection);
  inherited;
end;

procedure TGStringList.Lock;
begin
  EnterCriticalSection(CriticalSection);
end;

procedure TGStringList.Unlock;
begin
  LeaveCriticalSection(CriticalSection);
end;

function MakeDefaultMsg(Msg: smallint; Recog: Integer; param, tag, series: Word): TDefaultMessage;
begin
  Result.ident := Msg;
  Result.param := param;
  Result.tag := tag;
  Result.series := series;
  Result.Recog := Recog;
end;

function WEAPONfeature(cfeature: Integer): byte;
begin
  Result := Hibyte(cfeature);
end;
function DRESSfeature(cfeature: Integer): byte;
begin
  Result := Hibyte(Hiword(cfeature));
end;
function APPRfeature(cfeature: Integer): Word;
begin
  Result := Hiword(cfeature);
end;
function HAIRfeature(cfeature: Integer): byte;
begin
  Result := Hiword(cfeature);
end;
function RACEfeature(cfeature: Integer): byte;
begin
  Result := cfeature;
end;

function Horsefeature(cfeature: Integer): byte;
begin
  Result := Lobyte(Loword(cfeature));
end;
function Effectfeature(cfeature: Integer): byte;
begin
  Result := Hibyte(Loword(cfeature));
end;

function MakeHumanFeature(btRaceImg, btDress, btWeapon, btHair: byte): Integer;
begin
  Result := MakeLong(MakeWord(btRaceImg, btWeapon), MakeWord(btHair, btDress));
end;
function MakeMonsterFeature(btRaceImg, btWeapon: byte; wAppr: Word): Integer;
begin
  Result := MakeLong(MakeWord(btRaceImg, btWeapon), wAppr);
end;

end.

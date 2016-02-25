unit Grobal2;

interface
uses
  Windows, Classes, JSocket;
const
  MAXPATHLEN = 255;
  DIRPATHLEN = 80;
  MapNameLen = 16;
  ActorNameLen = 14;
  DEFBLOCKSIZE = 16;
  BUFFERSIZE = 10000;
  //DATA_BUFSIZE = 16348; //8192;
  DATA_BUFSIZE = 8192; //8192;
  GROUPMAX = 11;
  BAGGOLD = 5000000;
  BODYLUCKUNIT = 10;
  MAX_STATUS_ATTRIBUTE = 12;


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
  U_BUJUK = 9; //符
  U_BELT = 10; //腰带
  U_BOOTS = 11; //鞋
  U_CHARM = 12;

  POISON_DECHEALTH = 0;
  POISON_DAMAGEARMOR = 1;
  POISON_LOCKSPELL = 2;
  POISON_DONTMOVE = 4;
  POISON_STONE = 5;
  STATE_TRANSPARENT = 8;
  STATE_DEFENCEUP = 9;
  STATE_MAGDEFENCEUP = 10;
  STATE_BUBBLEDEFENCEUP = 11;

  USERMODE_PLAYGAME = 1;
  USERMODE_LOGIN = 2;
  USERMODE_LOGOFF = 3;
  USERMODE_NOTICE = 4;

  RUNGATEMAX = 20;

  RUNGATECODE = $AA55AA55;

  OS_MOVINGOBJECT = 1;
  OS_ITEMOBJECT = 2;
  OS_EVENTOBJECT = 3;
  OS_GATEOBJECT = 4;
  OS_SWITCHOBJECT = 5;
  OS_MAPEVENT = 6;
  OS_DOOR = 7;
  OS_ROON = 8;

  RC_PLAYOBJECT = 0;
  RC_PLAYMOSTER = 60; //人形怪物
  RC_HEROOBJECT = 66; //英雄
  RC_GUARD = 11; //大刀守卫
  RC_PEACENPC = 15;
  RC_ANIMAL = 50;
  RC_MONSTER = 80;
  RC_NPC = 10;
  RC_ARCHERGUARD = 112;


  RCC_USERHUMAN = RC_PLAYOBJECT;
  RCC_GUARD = RC_GUARD;
  RCC_MERCHANT = RC_ANIMAL;

  ISM_WHISPER = 1234;

  {SM_OPENSESSION        = 100;
  SM_CLOSESESSION       = 101;
  CM_CLOSESESSION       = 102; }


  CM_QUERYCHR = 100;
  CM_NEWCHR = 101;
  CM_DELCHR = 102;
  CM_SELCHR = 103;
  CM_SELECTSERVER = 104;

  SM_RUSH = 6;
  SM_RUSHKUNG = 7; //
  SM_FIREHIT = 8; //烈火
  SM_BACKSTEP = 9;
  SM_TURN = 10; //转向
  SM_WALK = 11; //走
  SM_SITDOWN = 12;
  SM_RUN = 13; //跑
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

  SM_ACTION_MIN = SM_RUSH;
  SM_ACTION_MAX = SM_WIDEHIT;
  SM_ACTION2_MIN = 65072;
  SM_ACTION2_MAX = 65073;

  SM_HEAR = 40;
  SM_FEATURECHANGED = 41;
  SM_USERNAME = 42;
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

  SM_CERTIFICATION_FAIL = 501;
  SM_ID_NOTFOUND = 502;
  SM_PASSWD_FAIL = 503;
  SM_NEWID_SUCCESS = 504;
  SM_NEWID_FAIL = 505;
  SM_CHGPASSWD_SUCCESS = 506;
  SM_CHGPASSWD_FAIL = 507;
  SM_GETBACKPASSWD_SUCCESS = 508; //密码找回成功
  SM_GETBACKPASSWD_FAIL = 509; //密码找回失败

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
  //  SM_DOOROPEN           = 612;
  SM_OPENDOOR_OK = 612; //
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

  SM_AREASTATE = 708;
  SM_MYSTATUS = 766;

  SM_DELITEMS = 709;
  SM_READMINIMAP_OK = 710;
  SM_READMINIMAP_FAIL = 711;
  SM_SENDUSERMAKEDRUGITEMLIST = 712;
  SM_MAKEDRUG_SUCCESS = 713;
  //  714
  //  716
  SM_MAKEDRUG_FAIL = 65036;

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

  SM_BREAKWEAPON = 1102;
  SM_INSTANCEHEALGUAGE = 1103; //??
  SM_CHANGEFACE = 1104;
  SM_VERSION_FAIL = 1106;

  SM_ITEMUPDATE = 1500;
  SM_MONSTERSAY = 1501;

  SM_EXCHGTAKEON_OK = 65023;
  SM_EXCHGTAKEON_FAIL = 65024;

  SM_TEST = 65037;
  SM_THROW = 65069;

  RM_DELITEMS = 9000; //Jacky
  RM_TURN = 10001;
  RM_WALK = 10002;
  RM_RUN = 10003;
  RM_HIT = 10004;
  RM_SPELL = 10007;
  RM_SPELL2 = 10008;
  RM_POWERHIT = 10009;
  RM_LONGHIT = 10011;
  RM_WIDEHIT = 10012;
  RM_PUSH = 10013;
  RM_FIREHIT = 10014;
  RM_RUSH = 10015;
  RM_STRUCK = 10020;
  RM_DEATH = 10021;
  RM_DISAPPEAR = 10022;
  RM_MAGSTRUCK = 10025;
  RM_MAGHEALING = 10026;
  RM_STRUCK_MAG = 10027;
  RM_MAGSTRUCK_MINE = 10028;
  RM_INSTANCEHEALGUAGE = 10029; //jacky
  RM_HEAR = 10030;
  RM_WHISPER = 10031;
  RM_CRY = 10032;
  RM_RIDE = 10033;
  RM_WINEXP = 10044;
  RM_USERNAME = 10043;
  RM_LEVELUP = 10045;
  RM_CHANGENAMECOLOR = 10046;

  RM_LOGON = 10050;
  RM_ABILITY = 10051;
  RM_HEALTHSPELLCHANGED = 10052;
  RM_DAYCHANGING = 10053;

  RM_SYSMESSAGE = 10100;
  RM_GROUPMESSAGE = 10102;
  RM_SYSMESSAGE2 = 10103;
  RM_GUILDMESSAGE = 10104;
  RM_SYSMESSAGE3 = 10105; //Jacky
  RM_ITEMSHOW = 10110;
  RM_ITEMHIDE = 10111;
  RM_DOOROPEN = 10112;
  RM_DOORCLOSE = 10113;
  RM_SENDUSEITEMS = 10114;
  RM_WEIGHTCHANGED = 10115;
  RM_FEATURECHANGED = 10116;
  RM_CLEAROBJECTS = 10117;
  RM_CHANGEMAP = 10118;
  RM_BUTCH = 10119;
  RM_MAGICFIRE = 10120;
  RM_SENDMYMAGIC = 10122;
  RM_MAGIC_LVEXP = 10123;
  RM_SKELETON = 10024;
  RM_DURACHANGE = 10125;
  RM_MERCHANTSAY = 10126;
  RM_GOLDCHANGED = 10136;
  RM_CHANGELIGHT = 10137;
  RM_CHARSTATUSCHANGED = 10139;
  RM_DELAYMAGIC = 10154;

  RM_DIGUP = 10200;
  RM_DIGDOWN = 10201;
  RM_FLYAXE = 10202;
  RM_LIGHTING = 10204;

  RM_SUBABILITY = 10302;
  RM_TRANSPARENT = 10308;

  RM_SPACEMOVE_SHOW = 10331;
  RM_RECONNECTION = 11332;
  RM_SPACEMOVE_SHOW2 = 10332; //?
  RM_HIDEEVENT = 10333;
  RM_SHOWEVENT = 10334;
  RM_ZEN_BEE = 10337;

  RM_OPENHEALTH = 10410;
  RM_CLOSEHEALTH = 10411;
  RM_DOOPENHEALTH = 10412;
  RM_CHANGEFACE = 10415;

  RM_ITEMUPDATE = 11000;
  RM_MONSTERSAY = 11001;
  RM_MAKESLAVE = 11002;

  RM_MONMOVE = 21004;
  SS_200 = 200;
  SS_201 = 201;
  SS_202 = 202;
  SS_WHISPER = 203;
  SS_204 = 204;
  SS_205 = 205;
  SS_206 = 206;
  SS_207 = 207;
  SS_208 = 208;
  SS_209 = 219;
  SS_210 = 210;
  SS_211 = 211;
  SS_212 = 212;
  SS_213 = 213;
  SS_214 = 214;

  RM_10205 = 10205;
  RM_10101 = 10101;
  RM_ALIVE = 10153;
  RM_CHANGEGUILDNAME = 10301;
  RM_10414 = 10414;
  RM_POISON = 10300;
  LA_UNDEAD = 1; //未知;

  RM_DELAYPUSHED = 10555;

  CM_GETBACKPASSWORD = 2010; //密码找回
  CM_SPELL = 3017;
  CM_QUERYUSERNAME = 80;

  CM_DROPITEM = 1000;
  CM_PICKUP = 1001;
  CM_TAKEONITEM = 1003;
  CM_TAKEOFFITEM = 1004;
  CM_EAT = 1006;
  CM_BUTCH = 1007;
  CM_MAGICKEYCHANGE = 1008;
  CM_1005 = 1005;

  CM_CLICKNPC = 1010;
  CM_MERCHANTDLGSELECT = 1011;
  CM_MERCHANTQUERYSELLPRICE = 1012;
  CM_USERSELLITEM = 1013;
  CM_USERBUYITEM = 1014;
  CM_USERGETDETAILITEM = 1015;
  CM_DROPGOLD = 1016;
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
  CM_ADJUST_BONUS = 1043;
  CM_SPEEDHACKUSER = 10430; //??

  CM_PASSWORD = 1105;
  CM_CHGPASSWORD = 1221; //?
  CM_SETPASSWORD = 1222; //?

  CM_HORSERUN = 3009;

  CM_THROW = 3005;

  CM_TURN = 3010;
  CM_WALK = 3011;
  CM_SITDOWN = 3012;
  CM_RUN = 3013;
  CM_HIT = 3014;
  CM_HEAVYHIT = 3015;
  CM_BIGHIT = 3016;

  CM_POWERHIT = 3018;
  CM_LONGHIT = 3019;

  CM_WIDEHIT = 3024; //半月
  CM_FIREHIT = 3025; //烈火
  CM_CRSHIT = 3036; //抱月刀
  CM_TWNHIT = 3037; //狂风斩
  CM_TWINHIT = 3038;

  CM_SAY = 3030;
  CM_40HIT = 3026;
  CM_41HIT = 3027;
  CM_42HIT = 3029;
  CM_43HIT = 3028;
  RM_10401 = 10401;

  STATE_STONE_MODE = 1;
  RM_MENU_OK = 10309;
  RM_MERCHANTDLGCLOSE = 10127;
  RM_SENDDELITEMLIST = 10148;
  RM_SENDUSERSREPAIR = 10141;
  RM_SENDGOODSLIST = 10128;
  RM_SENDUSERSELL = 10129;
  RM_SENDUSERREPAIR = 11139;
  RM_USERMAKEDRUGITEMLIST = 10149;
  RM_USERSTORAGEITEM = 10146;
  RM_USERGETBACKITEM = 10147;

  RM_USERBIGSTORAGEITEM = 20146;
  RM_USERBIGGETBACKITEM = 20147;

  RM_SPACEMOVE_FIRE2 = 11330;
  RM_SPACEMOVE_FIRE = 11331;

  RM_BUYITEM_SUCCESS = 10133;
  RM_BUYITEM_FAIL = 10134;
  RM_SENDDETAILGOODSLIST = 10135;
  RM_SENDBUYPRICE = 10130;
  RM_USERSELLITEM_OK = 10131;
  RM_USERSELLITEM_FAIL = 10132;
  RM_MAKEDRUG_SUCCESS = 10150;
  RM_MAKEDRUG_FAIL = 10151;
  RM_SENDREPAIRCOST = 10142;
  RM_USERREPAIRITEM_OK = 10143;
  RM_USERREPAIRITEM_FAIL = 10144;

  MAXBAGITEM = 46;
  RM_10155 = 10155;
  RM_PLAYDICE = 10500;
  RM_ADJUST_BONUS = 10400;

  RM_BUILDGUILD_OK = 10303;
  RM_BUILDGUILD_FAIL = 10304;
  RM_DONATE_OK = 10305;

  RM_GAMEGOLDCHANGED = 10666;

  STATE_OPENHEATH = 1;
  POISON_68 = 68;

  RM_MYSTATUS = 10777;

  CM_QUERYUSERSTATE = 82;

  CM_QUERYBAGITEMS = 81;

  CM_QUERYUSERSET = 49999;

  CM_OPENDOOR = 1002;
  CM_SOFTCLOSE = 1009;
  CM_1017 = 1017;
  CM_1042 = 1042;
  CM_GUILDALLY = 1044;
  CM_GUILDBREAKALLY = 1045;

  RM_HORSERUN = 11000;
  RM_HEAVYHIT = 10005;
  RM_BIGHIT = 10006;
  RM_MOVEFAIL = 10010;
  RM_CRSHIT = 11014;
  RM_RUSHKUNG = 11015;
  RM_41 = 41;
  RM_42 = 42;
  RM_43 = 43;

  RM_MAGICFIREFAIL = 10121;
  RM_LAMPCHANGEDURA = 10138;
  RM_GROUPCANCEL = 10140;

  RM_DONATE_FAIL = 10306;

  RM_BREAKWEAPON = 10413;

  RM_PASSWORD = 10416;

  RM_PASSWORDSTATUS = 10601;

  SM_40 = 35;
  SM_41 = 36;
  SM_42 = 37;
  SM_43 = 38;

  SM_HORSERUN = 5;
  SM_716 = 716;

  SM_PASSWORD = 3030;
  SM_PLAYDICE = 1200;

  SM_PASSWORDSTATUS = 20001;

  SM_GAMEGOLDNAME = 55; //游戏币名称

  SM_SERVERCONFIG = 20002;
  SM_GETREGINFO = 20003;


  ET_DIGOUTZOMBI = 1;
  ET_PILESTONES = 3;
  ET_HOLYCURTAIN = 4;
  ET_FIRE = 5;
  ET_SCULPEICE = 6;

  CM_PROTOCOL = 2000;
  CM_IDPASSWORD = 2001;
  CM_ADDNEWUSER = 2002;
  CM_CHANGEPASSWORD = 2003;
  CM_UPDATEUSER = 2004;
  CLIENT_VERSION_NUMBER = 120061220;
  CM_3037 = 3037;

  SM_NEEDPASSWORD = 8003;
  CM_POWERBLOCK = 0;

  //商铺相关
  CM_OPENSHOP = 9000;
  CM_BUYSHOPITEM = 9002;
  SM_BUYSHOPITEM_SUCCESS = 9003;
  SM_BUYSHOPITEM_FAIL = 9004;
  SM_SENGSHOPITEMS = 9001; // SERIES 7 每页的数量    wParam 总页数
  //==============================新增物品寄售系统==============================

  RM_SENDSELLOFFGOODSLIST = 21008;
  SM_SENDSELLOFFGOODSLIST = 20008;

  RM_SENDUSERSELLOFFITEM = 21005;
  SM_SENDUSERSELLOFFITEM = 20005; //寄售物品


  RM_SENDSELLOFFITEMLIST = 22009; //查询得到的寄售物品
  CM_SENDSELLOFFITEMLIST = 20009; //查询得到的寄售物品

  RM_SENDBUYSELLOFFITEM_OK = 21010; //购买寄售物品成功
  SM_SENDBUYSELLOFFITEM_OK = 20010; //购买寄售物品成功

  RM_SENDBUYSELLOFFITEM_FAIL = 21011; //购买寄售物品失败
  SM_SENDBUYSELLOFFITEM_FAIL = 20011; //购买寄售物品失败



  RM_SENDBUYSELLOFFITEM = 41005; //购买选择寄售物品
  CM_SENDBUYSELLOFFITEM = 4005; //购买选择寄售物品

  RM_SENDQUERYSELLOFFITEM = 41006; //查询选择寄售物品
  CM_SENDQUERYSELLOFFITEM = 4006; //查询选择寄售物品


  RM_SENDSELLOFFITEM = 41004; //接受寄售物品
  CM_SENDSELLOFFITEM = 4004; //接受寄售物品

  RM_SENDUSERSELLOFFITEM_FAIL = 2007; //R = -3  寄售物品失败
  RM_SENDUSERSELLOFFITEM_OK = 2006; //寄售物品成功

  SM_SENDUSERSELLOFFITEM_FAIL = 20007; //R = -3  寄售物品失败
  SM_SENDUSERSELLOFFITEM_OK = 20006; //寄售物品成功


  UNITX = 48;
  UNITY = 32;
  HALFX = 24;
  HALFY = 16;
  //MAXBAGITEM = 46; //用户背包最大数量
  MAXMAGIC = 20; //原来54;
  MAXSTORAGEITEM = 50;
  LOGICALMAPUNIT = 40;
type
  TMonStatus = (s_KillHuman, s_UnderFire, s_Die, s_MonGen);
  TMsgColor = (c_Red, c_Green, c_Blue, c_White);
  TMsgType = (t_Notice, t_Hint, t_System, t_Say, t_Mon, t_GM, t_Cust, t_Castle);
  //  TSayMsgType = (s_NoneMsg,s_GroupMsg,s_GuildMsg,s_SystemMsg,s_NoticeMsg); clWindowText
  TDefaultMessage = record
    Recog: Integer;
    Ident: Word;
    Param: Word;
    tag: Word;
    Series: Word;
  end;
  pTDefaultMessage = ^TDefaultMessage;

  TOSObject = record
    btType: Byte;
    CellObj: TObject;
    dwAddTime: LongWord;
    boObjectDisPose: Boolean;
  end;
  pTOSObject = ^TOSObject;

  TSendMessage = record
    wIdent: Word;
    wParam: Word;
    nParam1: Integer;
    nParam2: Integer;
    nParam3: Integer;
    BaseObject: TObject;
    dwAddTime: LongWord;
    dwDeliveryTime: LongWord;
    boLateDelivery: Boolean;
    Buff: PChar;
  end;
  pTSendMessage = ^TSendMessage;

  TProcessMessage = record
    wIdent: Word;
    wParam: Word;
    nParam1: Integer;
    nParam2: Integer;
    nParam3: Integer;
    BaseObject: TObject;
    boLateDelivery: Boolean;
    dwDeliveryTime: LongWord;
    sMsg: string;
  end;
  pTProcessMessage = ^TProcessMessage;

  TLoadHuman = record
    sAccount: string[12];
    sChrName: string[ActorNameLen];
    sUserAddr: string[15];
    nSessionID: Integer;
  end;

  TShortMessage = record
    Ident: Word;
    wMsg: Word;
  end;

  TMessageBodyW = record
    Param1: Word;
    Param2: Word;
    Tag1: Word;
    Tag2: Word;
  end;

  TMessageBodyWL = record
    lParam1: Integer;
    lParam2: Integer;
    lTag1: Integer;
    lTag2: Integer;
  end;

  TCharDesc = record
    feature: Integer;
    Status: Integer;
  end;

  TSessInfo = record //全局会话
    sAccount: string[12];
    sIPaddr: string[15];
    nSessionID: Integer;
    nPayMent: Integer;
    nPayMode: Integer;
    nSessionStatus: Integer;
    dwStartTick: LongWord;
    dwActiveTick: LongWord;
    nRefCount: Integer;
  end;
  pTSessInfo = ^TSessInfo;

  TQuestInfo = record
    wFlag: Word;
    btValue: Byte;
    nRandRage: Integer;
  end;
  pTQuestInfo = ^TQuestInfo;

  TScript = record
    boQuest: Boolean;
    QuestInfo: array[0..9] of TQuestInfo;
    nQuest: Integer;
    RecordList: TList;
  end;
  pTScript = ^TScript;

  TMonItem = record
    n00: Integer;
    n04: Integer;
    sMonName: string;
    n18: Integer;
  end;
  pTMonItem = ^TMonItem;

  TItemName = record
    nItemIndex: Integer;
    nMakeIndex: Integer;
    sItemName: string;
  end;
  pTItemName = ^TItemName;

  TVarType = (vNone, vInteger, vString);

  TDynamicVar = record
    sName: string;
    VarType: TVarType;
    nInternet: Integer;
    sString: string;
  end;
  pTDynamicVar = ^TDynamicVar;

  TRecallMigic = record
    nHumLevel: Integer;
    sMonName: string;
    nCount: Integer;
    nLevel: Integer;
  end;

  TMonSayMsg = record
    nRate: Integer;
    sSayMsg: string;
    State: TMonStatus;
    Color: TMsgColor;
  end;
  pTMonSayMsg = ^TMonSayMsg;

  TMonDrop = record
    sItemName: string;
    nDropCount: Integer;
    nNoDropCount: Integer;
    nCountLimit: Integer;
  end;
  pTMonDrop = ^TMonDrop;

  TGameCmd = record
    sCmd: string[25];
    nPermissionMin: Integer;
    nPermissionMax: Integer;
  end;
  pTGameCmd = ^TGameCmd;

  TIPaddr = record
    dIPaddr: string[15];
    sIPaddr: string[15];
  end;
  pTIPAddr = ^TIPaddr;

  TSrvNetInfo = record
    sIPaddr: string[15];
    nPort: Integer;
  end;
  pTSrvNetInfo = ^TSrvNetInfo;

  TCheckCode = record
  end;

  TStdItem = packed record
    Name: string[14];
    StdMode: Byte;
    Shape: Byte;
    Weight: Byte;
    AniCount: Byte;
    Source: ShortInt;
    Reserved: Byte; //0x14
    NeedIdentify: Byte; //0x15
    Looks: Word; //0x16
    DuraMax: Word; //0x18
    Reserved1: Word;
    AC: Integer; //0x1A
    MAC: Integer; //0x1C
    DC: Integer; //0x1E
    MC: Integer; //0x20
    SC: Integer; //0x22
    Need: Integer; //0x24
    NeedLevel: Integer; //0x25
    Price: Integer; //0x28
  end;
  pTStdItem = ^TStdItem;

  TOStdItem = packed record //OK
    Name: string[14];
    StdMode: Byte;
    Shape: Byte;
    Weight: Byte;
    AniCount: Byte;
    Source: ShortInt;
    Reserved: Byte;
    NeedIdentify: Byte;
    Looks: Word;
    DuraMax: Word;
    AC: Word;
    MAC: Word;
    DC: Word;
    MC: Word;
    SC: Word;
    Need: Byte;
    NeedLevel: Byte;
    w26: Word;
    Price: Integer;
  end;
  pTOStdItem = ^TOStdItem;

  TOClientItem = record //OK
    s: TOStdItem;
    MakeIndex: Integer;
    Dura: Word;
    DuraMax: Word;
  end;
  pTOClientItem = ^TOClientItem;

  TClientItem = record //OK
    s: TStdItem;
    MakeIndex: Integer;
    Dura: Word;
    DuraMax: Word;
  end;
  PTClientItem = ^TClientItem;

  TMonInfo = record
    sName: string[14];
    btRace: Byte;
    btRaceImg: Byte;
    wAppr: Word;
    wLevel: Word;
    btLifeAttrib: Byte;
    boUndead: Boolean;
    wCoolEye: Word;
    dwExp: LongWord;
    wMP: Word;
    wHP: Word;
    wAC: Word;
    wMAC: Word;
    wDC: Word;
    wMaxDC: Word;
    wMC: Word;
    wSC: Word;
    wSpeed: Word;
    wHitPoint: Word;
    wWalkSpeed: Word;
    wWalkStep: Word;
    wWalkWait: Word;
    wAttackSpeed: Word;
    ItemList: TList;
  end;
  pTMonInfo = ^TMonInfo;

  TMagic = record
    wMagicId: Word;
    sMagicName: string[12];
    btEffectType: Byte;
    btEffect: Byte;
    bt11: Byte;
    wSpell: Word;
    wPower: Word;
    TrainLevel: array[0..3] of Byte;
    w02: Word;
    MaxTrain: array[0..3] of Integer;
    btTrainLv: Byte;
    btJob: Byte;
    wMagicIdx: Word;
    dwDelayTime: LongWord;
    btDefSpell: Byte;
    btDefPower: Byte;
    wMaxPower: Word;
    btDefMaxPower: Byte;
    sDescr: string[18];
  end;
  pTMagic = ^TMagic;

  TClientMagic = record //84
    Key: char;
    Level: Byte;
    CurTrain: Integer;
    Def: TMagic;
  end;
  PTClientMagic = ^TClientMagic;

  TUserMagic = record
    MagicInfo: pTMagic;
    wMagIdx: Word;
    btLevel: Byte;
    btKey: Byte;
    nTranPoint: Integer;
  end;
  pTUserMagic = ^TUserMagic;

  TMinMap = record
    sName: string;
    nID: Integer;
  end;
  pTMinMap = ^TMinMap;

  TMapRoute = record
    sSMapNO: string;
    nDMapX: Integer;
    nSMapY: Integer;
    sDMapNO: string;
    nSMapX: Integer;
    nDMapY: Integer;
  end;
  pTMapRoute = ^TMapRoute;

  TMapInfo = record
    sName: string;
    sMapNO: string;
    nL: Integer; //0x10
    nServerIndex: Integer; //0x24
    nNEEDONOFFFlag: Integer; //0x28
    boNEEDONOFFFlag: Boolean; //0x2C
    sShowName: string; //0x4C
    sReConnectMap: string; //0x50
    boSAFE: Boolean; //0x51
    boDARK: Boolean; //0x52
    boFIGHT: Boolean; //0x53
    boFIGHT3: Boolean; //0x54
    boDAY: Boolean; //0x55
    boQUIZ: Boolean; //0x56
    boNORECONNECT: Boolean; //0x57
    boNEEDHOLE: Boolean; //0x58
    boNORECALL: Boolean; //0x59
    boNORANDOMMOVE: Boolean; //0x5A
    boNODRUG: Boolean; //0x5B
    boMINE: Boolean; //0x5C
    boNOPOSITIONMOVE: Boolean; //0x5D
  end;
  pTMapInfo = ^TMapInfo;

  TUnbindInfo = record
    nUnbindCode: Integer;
    sItemName: string[14];
  end;
  pTUnbindInfo = ^TUnbindInfo;

  TQuestDiaryInfo = record
    QDDinfoList: TList;
  end;
  pTQuestDiaryInfo = ^TQuestDiaryInfo;

  TAdminInfo = record
    nLv: Integer;
    sChrName: string[ActorNameLen];
    sIPaddr: string[15];
  end;
  pTAdminInfo = ^TAdminInfo;

  THumMagic = record
    wMagIdx: Word;
    btLevel: Byte;
    btKey: Byte;
    nTranPoint: Integer; //当前持久值
  end;
  pTHumMagic = ^THumMagic;

  TNakedAbility = packed record //Size 20
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
  pTNakedAbility = ^TNakedAbility;

  TAbility = packed record //OK    //Size 40
    Level: Word; //0x198  //0x34  0x00
    AC: Integer; //0x19A  //0x36  0x02
    MAC: Integer; //0x19C  //0x38  0x04
    DC: Integer; //0x19E  //0x3A  0x06
    MC: Integer; //0x1A0  //0x3C  0x08
    SC: Integer; //0x1A2  //0x3E  0x0A
    HP: Word; //0x1A4  //0x40  0x0C
    MP: Word; //0x1A6  //0x42  0x0E
    MaxHP: Word; //0x1A8  //0x44  0x10
    MaxMP: Word; //0x1AA  //0x46  0x12
    Exp: LongWord; //0x1B0  //0x4C 0x18
    MaxExp: LongWord; //0x1B4  //0x50 0x1C
    Weight: Word; //0x1B8   //0x54 0x20
    MaxWeight: Word; //0x1BA   //0x56 0x22  背包
    WearWeight: Word; //0x1BC   //0x58 0x24
    MaxWearWeight: Word; //0x1BD   //0x59 0x25  负重
    HandWeight: Word; //0x1BE   //0x5A 0x26
    MaxHandWeight: Word; //0x1BF   //0x5B 0x27  腕力
  end;
  pTAbility = ^TAbility;

  TOAbility = packed record
    Level: Word;
    AC: Word;
    MAC: Word;
    DC: Word;
    MC: Word;
    SC: Word;
    HP: Word;
    MP: Word;
    MaxHP: Word;
    MaxMP: Word;
    btReserved1: Byte;
    btReserved2: Byte;
    btReserved3: Byte;
    btReserved4: Byte;
    Exp: LongWord;
    MaxExp: LongWord;
    Weight: Word;
    MaxWeight: Word;//背包
    WearWeight: Byte;
    MaxWearWeight: Byte; //负重
    HandWeight: Byte;
    MaxHandWeight: Byte; //腕力
  end;
  pTOAbility = ^TOAbility;

  TAddAbility = record //OK    //Size 40
    wHP: Word;
    wMP: Word;
    wHitPoint: Word;
    wSpeedPoint: Word;
    wAC: Integer;
    wMAC: Integer;
    wDC: Integer;
    wMC: Integer;
    wSC: Integer;
    bt1DF: Byte; //神圣
    bt035: Byte;
    wAntiPoison: Word;
    wPoisonRecover: Word;
    wHealthRecover: Word;
    wSpellRecover: Word;
    wAntiMagic: Word;
    btLuck: Byte;
    btUnLuck: Byte;
    nHitSpeed: Integer;
    btWeaponStrong: Byte;
  end;
  pTAddAbility = ^TAddAbility;

  TWAbility = record
    dwExp: LongWord; //怪物经验值(Dword)
    wHP: Word;
    wMP: Word;
    wMaxHP: Word;
    wMaxMP: Word
  end;

  TMerchantInfo = record
    sScript: string[14];
    sMapName: string[14];
    nX: Integer;
    nY: Integer;
    sNPCName: string[40];
    nFace: Integer;
    nBody: Integer;
    boCastle: Boolean;
  end;
  pTMerchantInfo = ^TMerchantInfo;

  TSocketBuff = record
    Buffer: PChar; //0x24
    nLen: Integer; //0x28
  end;
  pTSocketBuff = ^TSocketBuff;

  TSendBuff = record
    nLen: Integer;
    Buffer: array[0..DATA_BUFSIZE - 1] of char;
  end;
  pTSendBuff = ^TSendBuff;

  TUserItem = record
    MakeIndex: Integer;
    wIndex: Word; //物品id
    Dura: Word; //当前持久值
    DuraMax: Word; //最大持久值
    btValue: array[0..13] of Byte;
  end;
  pTUserItem = ^TUserItem;

  TMonItemInfo = record
    SelPoint: Integer;
    MaxPoint: Integer;
    ItemName: string;
    Count: Integer;
  end;
  pTMonItemInfo = ^TMonItemInfo;

  TMonsterInfo = record
    Name: string;
    ItemList: TList;
  end;
  PTMonsterInfo = ^TMonsterInfo;

  TMapItem = record
    Name: string;
    Looks: Word;
    AniCount: Byte;
    Reserved: Byte;
    Count: Integer;
    OfBaseObject: TObject;
    DropBaseObject: TObject;
    dwCanPickUpTick: LongWord;
    UserItem: TUserItem;
  end;
  PTMapItem = ^TMapItem;

  TVisibleMapItem = record
    wIdent: Word;
    nParam1: Integer;
    Buff: PChar;
    MapItem: PTMapItem;
    nVisibleFlag: Integer;
    nX: Integer;
    nY: Integer;
    sName: string;
    wLooks: Word;
  end;
  pTVisibleMapItem = ^TVisibleMapItem;

  TVisibleBaseObject = record
    BaseObject: TObject;
    nVisibleFlag: Integer;
  end;
  pTVisibleBaseObject = ^TVisibleBaseObject;

  THumanRcd = record
    sUserID: string[10];
    sCharName: string[14];
    btJob: Byte;
    btGender: Byte;
    btLevel: Byte;
    btHair: Byte;
    sMapName: string[16];
    btAttackMode: Byte;
    btIsAdmin: Byte;
    nX: Integer;
    nY: Integer;
    nGold: Integer;
    dwExp: LongWord;
  end;
  pTHumanRcd = ^THumanRcd;

  TObjectFeature = record
    btGender: Byte;
    btWear: Byte;
    btHair: Byte;
    btWeapon: Byte;
  end;
  pTObjectFeature = ^TObjectFeature;

  TStatusInfo = record
    nStatus: Integer;
    dwStatusTime: LongWord;
    sm218: SmallInt;
    dwTime220: LongWord;
  end;

  TMsgHeader = record
    dwCode: LongWord;
    nSocket: Integer;
    wGSocketIdx: Word;
    wIdent: Word;
    wUserListIndex: Integer;
    nLength: Integer;
  end;
  pTMsgHeader = ^TMsgHeader;

  TUserInfo = record
    bo00: Boolean; //0x00
    bo01: Boolean; //0x01 ?
    bo02: Boolean; //0x02 ?
    bo03: Boolean; //0x03 ?
    n04: Integer; //0x0A ?
    n08: Integer; //0x0B ?
    bo0C: Boolean; //0x0C ?
    bo0D: Boolean; //0x0D
    bo0E: Boolean; //0x0E ?
    bo0F: Boolean; //0x0F ?
    n10: Integer; //0x10 ?
    n14: Integer; //0x14 ?
    n18: Integer; //0x18 ?
    sStr: string[20]; //0x1C
    nSocket: Integer; //0x34
    nGateIndex: Integer; //0x38
    n3C: Integer; //0x3C
    n40: Integer; //0x40 ?
    n44: Integer; //0x44
    List48: TList; //0x48
    Cert: TObject; //0x4C
    dwTime50: LongWord; //0x50
    bo54: Boolean; //0x54
  end;
  pTUserInfo = ^TUserInfo;

  TGlobaSessionInfo = record
    sAccount: string;
    sIPaddr: string;
    nSessionID: Integer;
    n24: Integer;
    bo28: Boolean;
    boLoadRcd: Boolean;
    boStartPlay: Boolean;
    dwAddTick: LongWord;
    dAddDate: TDateTime;
  end;
  pTGlobaSessionInfo = ^TGlobaSessionInfo;


  TUserStateInfo = record
    feature: Integer;
    UserName: string[ActorNameLen];
    NameColor: Integer;
    GuildName: string[ActorNameLen];
    GuildRankName: string[16];
    UseItems: array[0..12] of TClientItem;
  end;
  pTUserStateInfo = ^TUserStateInfo;

  TSellOffHeader = record
    nItemCount: Integer;
  end;

  TSellOffInfo = packed record //Size 59    拍卖数据结构
    sCharName: string[ActorNameLen];
    dSellDateTime: TDateTime;
    nSellGold: Integer;
    n: Integer;
    UseItems: TUserItem;
    N1: Integer;
  end;
  pTSellOffInfo = ^TSellOffInfo;

  TItemCount = Integer;

  TBigStorage = packed record //无限仓库数据结构
    boDelete: Boolean;
    sCharName: string[ActorNameLen];
    SaveDateTime: TDateTime;
    UseItems: TUserItem;
    nCount: Integer;
  end;
  pTBigStorage = ^TBigStorage;

  TBindItem = record
    sUnbindItemName: string[ActorNameLen];
    nStdMode: Integer;
    nShape: Integer;
    btItemType: Byte;
  end;
  pTBindItem = ^TBindItem;

  TOUserStateInfo = packed record //OK
    feature: Integer;
    UserName: string[15]; // 15
    GuildName: string[14]; //14
    GuildRankName: string[16]; //15
    NameColor: Word;
    UseItems: array[0..8] of TOClientItem;
  end;

  TIDRecordHeader = packed record
    boDeleted: Boolean;
    bt1: Byte;
    bt2: Byte;
    bt3: Byte;
    CreateDate: TDateTime;
    UpdateDate: TDateTime;
    sAccount: string[11];
  end;

  TRecordHeader = packed record //Size 12
    boDeleted: Boolean;
    nSelectID: Byte;
    bt1: Byte;
    bt2: Byte;
    dCreateDate: TDateTime; //创建时间
    sName: string[15]; //0x15  //角色名称   28
  end;
  pTRecordHeader = ^TRecordHeader;

  TQuestUnit = array[0..60] of Byte;
  TQuestFlag = array[0..127] of Byte;
  TStatusTime = array[0..MAX_STATUS_ATTRIBUTE - 1] of Word;

  THumItems = array[0..8] of TUserItem;
  THumAddItems = array[9..12] of TUserItem;
  TBagItems = array[0..45] of TUserItem;
  TStorageItems = array[0..45] of TUserItem;
  THumMagics = array[0..19] of THumMagic;
  THumanUseItems = array[0..12] of TUserItem; //13个

  pTPlayUseItems = ^THumanUseItems;

  pTHumItems = ^THumItems;
  pTBagItems = ^TBagItems;
  pTStorageItems = ^TStorageItems;
  pTHumAddItems = ^THumAddItems;
  pTHumMagics = ^THumMagics;

  pTHumData = ^THumData;
  THumData = packed record //Size = 3164
    sChrName: string[ActorNameLen];
    sCurMap: string[MapNameLen];
    wCurX: Word;
    wCurY: Word;
    btDir: Byte;
    btHair: Byte;
    btSex: Byte;
    btJob: Byte;
    nGold: Integer;
    Abil: TOAbility; //+40
    wStatusTimeArr: TStatusTime; //+24
    sHomeMap: string[MapNameLen];
    btUnKnow1: Byte;
    wHomeX: Word;
    wHomeY: Word;
    sDearName: string[ActorNameLen];
    sMasterName: string[ActorNameLen];
    boMaster: Boolean;
    btCreditPoint: Byte;
    btDivorce: Byte; //是否结婚
    btMarryCount: Byte; //结婚次数
    sStoragePwd: string[7];
    btReLevel: Byte;
    btUnKnow2: array[0..2] of Byte;
    BonusAbil: TNakedAbility; //+20
    nBonusPoint: Integer;
    nGameGold: Integer;
    nGamePoint: Integer;
    nPayMentPoint: Integer; //充值点
    n: Integer;
    nPKPoint: Integer;
    btAllowGroup: Byte;
    btF9: Byte;
    btAttatckMode: Byte;
    btIncHealth: Byte;
    btIncSpell: Byte;
    btIncHealing: Byte;
    btFightZoneDieCount: Byte;
    sAccount: string[10];
    btEE: Byte;
    btEF: Byte;
    boLockLogon: Boolean;
    wContribution: Word;
    nHungerStatus: Integer;
    boAllowGuildReCall: Boolean; //  是否允许行会合一
    wGroupRcallTime: Word; //队传送时间
    dBodyLuck: Double; //幸运度  8
    boAllowGroupReCall: Boolean; // 是否允许天地合一
    nExpRate: Integer; //经验倍数
    nExpTime: Integer; //经验倍数时间
    QuestUnit: TQuestUnit;
    QuestFlag: TQuestFlag; //脚本变量
    HumItems: THumItems; //9格装备 衣服  武器  蜡烛 头盔 项链 手镯 手镯 戒指 戒指
    BagItems: TBagItems; //包裹装备
    HumMagics: THumMagics; //魔法
    StorageItems: TStorageItems; //仓库物品
    HumAddItems: THumAddItems; //新增4格 护身符 腰带 鞋子 宝石
  end;

  THumDataInfo = packed record //Size 3164
    Header: TRecordHeader;
    Data: THumData;
  end;
  pTHumDataInfo = ^THumDataInfo;

  TSaveRcd = record
    sAccount: string[12];
    sChrName: string[ActorNameLen];
    nSessionID: Integer;
    nReTryCount: Integer;
    dwSaveTick: LongWord; //2006-11-12 增加 保存错误下次保存TICK
    PlayObject: TObject;
    HumanRcd: THumDataInfo;
  end;
  pTSaveRcd = ^TSaveRcd;

  TLoadDBInfo = record
    sAccount: string[12];
    sCharName: string[ActorNameLen];
    sIPaddr: string[15];
    nSessionID: Integer;
    nSoftVersionDate: Integer;
    nPayMent: Integer;
    nPayMode: Integer;
    nSocket: Integer;
    nGSocketIdx: Integer;
    nGateIdx: Integer;
    dwNewUserTick: LongWord;
    PlayObject: TObject;
    nReLoadCount: Integer;
  end;
  pTLoadDBInfo = ^TLoadDBInfo;

  TUserOpenInfo = record
    sAccount: string[12];
    sChrName: string[ActorNameLen];
    LoadUser: TLoadDBInfo;
    HumanRcd: THumDataInfo;
  end;
  pTUserOpenInfo = ^TUserOpenInfo;

  TLoadUser = record
    sAccount: string[12];
    sChrName: string[ActorNameLen];
    sIPaddr: string[15];
    nSessionID: Integer;
    nSocket: Integer;
    nGateIdx: Integer;
    nGSocketIdx: Integer;
    nPayMent: Integer;
    nPayMode: Integer;
    dwNewUserTick: LongWord;
    nSoftVersionDate: Integer;
  end;
  pTLoadUser = ^TLoadUser;

  TDoorStatus = record
    bo01: Boolean;
    boOpened: Boolean;
    dwOpenTick: LongWord;
    nRefCount: Integer;
    n04: Integer;
  end;
  pTDoorStatus = ^TDoorStatus;

  TDoorInfo = record
    nX: Integer;
    nY: Integer;
    n08: Integer;
    Status: pTDoorStatus;
  end;
  pTDoorInfo = ^TDoorInfo;

  TSlaveInfo = record
    sSalveName: string;
    btSalveLevel: Byte;
    btSlaveExpLevel: Byte;
    dwRoyaltySec: LongWord;
    nKillCount: Integer;
    nHP: Integer;
    nMP: Integer;
  end;
  pTSlaveInfo = ^TSlaveInfo;

  TSwitchDataInfo = record
    sChrName: string[ActorNameLen];
    sMAP: string[MapNameLen];
    wX: Word;
    wY: Word;
    Abil: TAbility;
    nCode: Integer;
    boC70: Boolean;
    boBanShout: Boolean;
    boHearWhisper: Boolean;
    boBanGuildChat: Boolean;
    boAdminMode: Boolean;
    boObMode: Boolean;
    BlockWhisperArr: array[0..5] of string;
    SlaveArr: array[0..10] of TSlaveInfo;
    StatusValue: array[0..5] of Word;
    StatusTimeOut: array[0..5] of LongWord;
  end;
  pTSwitchDataInfo = ^TSwitchDataInfo;

  TGoldChangeInfo = record
    sGameMasterName: string;
    sGetGoldUser: string;
    nGold: Integer;
  end;
  pTGoldChangeInfo = ^TGoldChangeInfo;

  TGateInfo = record
    Socket: TCustomWinSocket;
    boUsed: Boolean;
    sAddr: string[15];
    nPort: Integer;
    n520: Integer;
    UserList: TList;
    nUserCount: Integer;
    Buffer: PChar;
    nBuffLen: Integer;
    BufferList: TList;
    boSendKeepAlive: Boolean;
    nSendChecked: Integer;
    nSendBlockCount: Integer;
    dwTime544: LongWord;
    nSendMsgCount: Integer;
    nSendRemainCount: Integer;
    dwSendTick: LongWord;
    nSendMsgBytes: Integer;
    nSendBytesCount: Integer;
    nSendedMsgCount: Integer;
    nSendCount: Integer;
    dwSendCheckTick: LongWord;
  end;
  pTGateInfo = ^TGateInfo;

  TStartPoint = record //安全区回城点 增加光环效果
    m_sMapName: string[MapNameLen];
    m_nCurrX: Integer; //  人物所在座标X(4字节)
    m_nCurrY: Integer;
    m_boNotAllowSay: Boolean;
    m_nRange: Integer;
    m_nType: Integer;
    m_nPkZone: Integer;
    m_nPkFire: Integer;
    m_btShape: Byte;
  end;
  pTStartPoint = ^TStartPoint;

  //地图事件数据配置详解

  TQuestUnitStatus = record
    nQuestUnit: Integer;
    boOpen: Boolean;
  end;
  pTQuestUnitStatus = ^TQuestUnitStatus;

  TMapCondition = record
    nHumStatus: Integer;
    sItemName: string[14];
    boNeedGroup: Boolean;
  end;
  pTMapCondition = ^TMapCondition;

  TStartScript = record
    nLable: Integer;
    sLable: string[100];
  end;

  TMapEvent = record
    m_sMapName: string[MapNameLen];
    m_nCurrX: Integer;
    m_nCurrY: Integer;
    m_nRange: Integer;
    m_MapFlag: TQuestUnitStatus;
    m_nRandomCount: Integer; //; 范围:(0 - 999999) 0 的机率为100% ; 数字越大，机率越低
    m_Condition: TMapCondition; //触发条件
    m_StartScript: TStartScript;
  end;
  pTMapEvent = ^TMapEvent;

  TSendUserData = record
    nSocketIndx: Integer;
    nSocketHandle: Integer;
    sMsg: string;
  end;
  pTSendUserData = ^TSendUserData;

  TCheckVersion = record
  end;
  pTCheckVersion = ^TCheckVersion;

  TRecordDeletedHeader = packed record
    boDeleted: Boolean;
    bt1: Byte;
    bt2: Byte;
    bt3: Byte;
    CreateDate: TDateTime;
    LastLoginDate: TDateTime;
    n14: Integer;
    nNextDeletedIdx: Integer;
    //    sAccount   :String[11];//0x14
  end;

  TUserEntry = packed record
    sAccount: string[10];
    sPassword: string[10];
    sUserName: string[20];
    sSSNo: string[14];
    sPhone: string[14];
    sQuiz: string[20];
    sAnswer: string[12];
    sEMail: string[40];
  end;
  TUserEntryAdd = packed record
    sQuiz2: string[20];
    sAnswer2: string[12];
    sBirthDay: string[10];
    sMobilePhone: string[13];
    sMemo: string[20];
    sMemo2: string[20];
  end;

  TAccountDBRecord = packed record
    Header: TIDRecordHeader;
    UserEntry: TUserEntry;
    UserEntryAdd: TUserEntryAdd;
    nErrorCount: Integer;
    dwActionTick: LongWord;
    n: array[0..38] of Byte;
  end;

  TMapFlag = record
    boSAFE: Boolean;
    boDARK: Boolean;
    boFIGHT: Boolean;
    boFIGHT3: Boolean;
    boDAY: Boolean;
    boQUIZ: Boolean;
    boNORECONNECT: Boolean;
    boMUSIC: Boolean;
    boEXPRATE: Boolean;
    boPKWINLEVEL: Boolean;
    boPKWINEXP: Boolean;
    boPKLOSTLEVEL: Boolean;
    boPKLOSTEXP: Boolean;
    boDECHP: Boolean;
    boINCHP: Boolean;
    boDECGAMEGOLD: Boolean;
    boDECGAMEPOINT: Boolean;
    boINCGAMEGOLD: Boolean;
    boINCGAMEPOINT: Boolean;
    boRUNHUMAN: Boolean;
    boRUNMON: Boolean;
    boNEEDHOLE: Boolean;
    boNORECALL: Boolean;
    boNOGUILDRECALL: Boolean;
    boNODEARRECALL: Boolean;
    boNOMASTERRECALL: Boolean;
    boNORANDOMMOVE: Boolean;
    boNODRUG: Boolean;
    boMINE: Boolean;
    boNOPOSITIONMOVE: Boolean;
    boNoManNoMon: Boolean;

    nL: Integer;
    nNEEDSETONFlag: Integer;
    nNeedONOFF: Integer;
    nMUSICID: Integer;
    nPKWINLEVEL: Integer;
    nExpRate: Integer;
    nPKWINEXP: Integer;
    nPKLOSTLEVEL: Integer;
    nPKLOSTEXP: Integer;
    nDECHPPOINT: Integer;
    nDECHPTIME: Integer;
    nINCHPPOINT: Integer;
    nINCHPTIME: Integer;
    nDECGAMEGOLD: Integer;
    nDECGAMEGOLDTIME: Integer;
    nDECGAMEPOINT: Integer;
    nDECGAMEPOINTTIME: Integer;
    nINCGAMEGOLD: Integer;
    nINCGAMEGOLDTIME: Integer;
    nINCGAMEPOINT: Integer;
    nINCGAMEPOINTTIME: Integer;
    sReConnectMap: string;

    boUnAllowStdItems: Boolean;
    sUnAllowStdItemsText: string;
    boAutoMakeMonster: Boolean;
    boNOFIREMAGIC: Boolean; //不允许火墙
  end;
  pTMapFlag = ^TMapFlag;


  TChrMsg = record
    Ident: Integer;
    X: Integer;
    Y: Integer;
    dir: Integer;
    State: Integer;
    feature: Integer;
    saying: string;
    sound: Integer;
  end;
  pTChrMsg = ^TChrMsg;

  TRegInfo = record
    sKey: string;
    sServerName: string;
    sRegSrvIP: string[15];
    nRegPort: Integer;
  end;

  TDropItem = record
    X: Integer;
    Y: Integer;
    Id: Integer;
    Looks: Integer;
    Name: string;
    FlashTime: DWORD;
    FlashStepTime: DWORD;
    FlashStep: Integer;
    BoFlash: Boolean;
  end;
  pTDropItem = ^TDropItem;

  TUserCharacterInfo = record
    Name: string[19];
    Job: Byte;
    Hair: Byte;
    Level: Word;
    Sex: Byte;
  end;

  TClientGoods = record
    Name: string;
    SubMenu: Integer;
    Price: Integer;
    Stock: Integer;
    Grade: Integer;
  end;
  pTClientGoods = ^TClientGoods;

  TClientConf = record
    boClientCanSet: Boolean;
    boRUNHUMAN: Boolean;
    boRUNMON: Boolean;
    boRunNpc: Boolean;
    boWarRunAll: Boolean;
    btDieColor: Byte;
    wSpellTime: Word;
    wHitIime: Word;
    wItemFlashTime: Word;
    btItemSpeed: Byte;
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

  pTPowerBlock = ^TPowerBlock;
  TPowerBlock = array[0..100 - 1] of Word;

function APPRfeature(cfeature: Integer): Word;
function RACEfeature(cfeature: Integer): Byte;
function HAIRfeature(cfeature: Integer): Byte;
function DRESSfeature(cfeature: Integer): Byte;
function WEAPONfeature(cfeature: Integer): Byte;
function Horsefeature(cfeature: Integer): Byte;
function Effectfeature(cfeature: Integer): Byte;
function MakeHumanFeature(btRaceImg, btDress, btWeapon, btHair: Byte): Integer;
function MakeMonsterFeature(btRaceImg, btWeapon: Byte; wAppr: Word): Integer;
implementation
function WEAPONfeature(cfeature: Integer): Byte;
begin
  Result := Hibyte(cfeature);
end;
function DRESSfeature(cfeature: Integer): Byte;
begin
  Result := Hibyte(Hiword(cfeature));
end;
function APPRfeature(cfeature: Integer): Word;
begin
  Result := Hiword(cfeature);
end;
function HAIRfeature(cfeature: Integer): Byte;
begin
  Result := Hiword(cfeature);
end;
function RACEfeature(cfeature: Integer): Byte;
begin
  Result := cfeature;
end;

function Horsefeature(cfeature: Integer): Byte;
begin
  Result := Lobyte(Loword(cfeature));
end;
function Effectfeature(cfeature: Integer): Byte;
begin
  Result := Hibyte(Loword(cfeature));
end;

function MakeHumanFeature(btRaceImg, btDress, btWeapon, btHair: Byte): Integer;
begin
  Result := MakeLong(MakeWord(btRaceImg, btWeapon), MakeWord(btHair, btDress));
end;
function MakeMonsterFeature(btRaceImg, btWeapon: Byte; wAppr: Word): Integer;
begin
  Result := MakeLong(MakeWord(btRaceImg, btWeapon), wAppr);
end;
end.


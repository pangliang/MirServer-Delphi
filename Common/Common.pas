unit Common;

interface

const
  nSuperUser = 240621028; //飘飘网络
  nUserKey1 = 13677866; //飞尔世界
  nVersion = nUserKey1;

  sSuperUser = '08C7EE4D59AA0C783E5760542CE16AD6'; //240621028飘飘网络
  sUserKey1 = 'E65551419F021E18828F9AAECEAC74E3'; //13677866飞尔世界

{$IF nVersion = nSuperUser}
  sVersion = sSuperUser;
{$ELSEIF nVersion = nUserKey1}
  sVersion = sUserKey1;
{$IFEND}

  //服务器模块之间
  SG_CHECKCODEADDR = 1006;
  GS_QUIT = 2000; //关闭
  SG_FORMHANDLE = 1000; //服务器HANLD
  SG_STARTNOW = 1001; //正在启动服务器...
  SG_STARTOK = 1002; //服务器启动完成...
  SS_LOGINCOST = 103;

  SS_OPENSESSION = 1000;
  SS_CLOSESESSION = 1010;
  SS_SOFTOUTSESSION = 1020;
  SS_SERVERINFO = 1030;
  SS_KEEPALIVE = 1040;
  SS_KICKUSER = 1110;
  SS_SERVERLOAD = 1130;


  SM_CERTIFICATION_SUCCESS = 502;
  GS_USERACCOUNT = 2001;
  GS_CHANGEACCOUNTINFO = 2002;

  SG_USERACCOUNT = 1003;
  SG_USERACCOUNTNOTFOUND = 1004; //没有找到账号
  SG_USERACCOUNTCHANGESTATUS = 1005; //账号更新成功

  WM_SENDPROCMSG = 11111;
  CM_GETGAMELIST = 2000;
  SM_SENDGAMELIST = 5000;


  UNKNOWMSG = 1007;

  DB_LOADHUMANRCD = 1000;
  DB_SAVEHUMANRCD = 1010;
  DB_SAVEHUMANRCDEX = 1020;

  DBR_LOADHUMANRCD = 1100;
  DBR_SAVEHUMANRCD = 1101;
  DBR_FAIL = 1102;

  // For Game Gate
  GM_OPEN = 1;
  GM_CLOSE = 2;
  GM_CHECKSERVER = 3; // Send check signal to Server
  GM_CHECKCLIENT = 4; // Send check signal to Client
  GM_DATA = 5;
  GM_SERVERUSERINDEX = 6;
  GM_RECEIVE_OK = 7;
  GM_TEST = 20;
implementation

end.

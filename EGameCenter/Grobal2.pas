unit Grobal2;

interface
uses
  Windows;
const
  DEFBLOCKSIZE = 16;
  BUFFERSIZE = 10000;

  SM_CERTIFICATION_SUCCESS = 502;

  GS_QUIT = 2000;
  GS_USERACCOUNT = 2001;
  GS_CHANGEACCOUNTINFO = 2002;

  SG_USERACCOUNT = 1003;
  SG_USERACCOUNTNOTFOUND = 1004; //没有找到账号
  SG_USERACCOUNTCHANGESTATUS = 1005; //账号更新成功
  SG_CHECKCODEADDR = 1006;


  SG_FORMHANDLE = 1000; //账号服务器HANLD
  SG_STARTNOW = 1001; //正在启动登录服务器...
  SG_STARTOK = 1002; //登录服务器启动完成...

  WM_SENDPROCMSG = 11111;

  CM_GETGAMELIST = 2000;

  SM_SENDGAMELIST = 5000;
resourcestring
  sDBHeaderDesc = '翎风游戏数据库文件 2005/04/20';
  sDBIdxHeaderDesc = '翎风游戏数据库索引文件 2005/04/20';
type
  TDBHeader = packed record
    sDesc: string[34]; //0x00
    n23: Integer; //0x23
    n28: Integer; //0x27
    n2C: Integer; //0x2B
    n30: Integer; //0x2F
    n34: Integer; //0x33
    n38: Integer; //0x37
    n3C: Integer; //0x3B
    n40: Integer; //0x3F
    n44: Integer; //0x43
    n48: Integer; //0x47
    n4B: Byte; //0x4B
    n4C: Integer; //0x4C
    n50: Integer; //0x50
    n54: Integer; //0x54
    n58: Integer; //0x58
    nLastIndex: Integer; //0x5C
    dLastDate: TDateTime; //0x60
    nIDCount: Integer; //0x68
    n6C: Integer; //0x6C
    nDeletedIdx: Integer; //0x70
    dUpdateDate: TDateTime; //0x74
  end;
  pTDBHeader = ^TDBHeader;

  TIdxHeader = packed record
    sDesc: string[43]; //0x00
    n2C: Integer; //0x2C
    n30: Integer; //0x30
    n34: Integer; //0x34
    n38: Integer; //0x38
    n3C: Integer; //0x3C
    n40: Integer; //0x40
    n44: Integer; //0x44
    n48: Integer; //0x48
    n4C: Integer; //0x4C
    n50: Integer; //0x50
    n54: Integer; //0x54
    n58: Integer; //0x58
    n5C: Integer; //0x5C
    n60: Integer; //0x60
    nQuickCount: Integer; //0x64
    nIDCount: Integer; //0x68
    nLastIndex: Integer; //0x6C
    dUpdateDate: TDateTime; //0x70
  end;

  TRecordDeletedHeader = packed record
    boDeleted: Boolean;
    bt1: Byte;
    bt2: Byte;
    bt3: Byte;
    CreateDate: TDateTime; //0x04
    LastLoginDate: TDateTime; //0x0C
    n14: Integer;
    nNextDeletedIdx: Integer;
    //    sAccount   :String[11];//0x14
  end;
  TRecordHeader = packed record
    boDeleted: Boolean;
    bt1: Byte;
    bt2: Byte;
    bt3: Byte;
    CreateDate: TDateTime; //0x04
    UpdateDate: TDateTime; //0x0C
    sAccount: string[11];
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
    Header: TRecordHeader;
    UserEntry: TUserEntry;
    UserEntryAdd: TUserEntryAdd;
    nErrorCount: Integer;
    dwActionTick: LongWord;
    n: array[0..38] of Byte;
  end;

  TDefaultMessage = record
    Recog: Integer;
    Ident: Word;
    Param: Word;
    tag: Word;
    Series: Word;
  end;

  TChrMsg = record
    Ident: Integer;
    X: Integer;
    Y: Integer;
    Dir: Integer;
    State: Integer;
    feature: Integer;
    saying: string;
    sound: Integer;
  end;
  PTChrMsg = ^TChrMsg;
  TStdItem = record //OK
    Name: string[14];
    StdMode: Byte;
    Shape: Byte;
    Weight: Byte;
    AniCount: Byte;
    Source: Byte;
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
    Price: DWORD;
  end;
  TClientItem = record //OK
    S: TStdItem;
    MakeIndex: Integer;
    Dura: Word;
    DuraMax: Word;
  end;
  PTClientItem = ^TClientItem;
  TUserStateInfo = record //OK
    feature: Integer;
    Username: string[19];
    GuildName: string[14];
    GuildRankName: string[14];
    NameColor: Word;
    UseItems: array[0..8] of TClientItem;
  end;
  TUserCharacterInfo = record
    Name: string[19];
    Job: Byte;
    Hair: Byte;
    Level: Byte;
    m_btSex: Byte;
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
  PTDropItem = ^TDropItem;
  TMagic = record //+
    MagicId: Word;
    MagicName: string[12];
    EffectType: Byte;
    Effect: Byte;
    xx: Byte;
    Spell: Word;
    DefSpell: Word;
    TrainLevel: array[0..2] of Byte;
    TrainLeveX: array[0..2] of Byte;
    MaxTrain: array[0..2] of Integer;
    DelayTime: Integer;
  end;
  TClientMagic = record //84
    Key: char;
    Level: Byte;
    CurTrain: Integer;
    def: TMagic;
  end;
  PTClientMagic = ^TClientMagic;
  TNakedAbility = record
    DC: Word;
    MC: Word;
    SC: Word;
    AC: Word;
    MAC: Word;
    HP: Word;
    MP: Word;
    Hit: Byte;
    Speed: Integer;
  end;

  TAbility = record //OK    //Size 40
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
    WearWeight: Byte; //0x1BC
    MaxWearWeight: Byte; //0x1BD
    HandWeight: Byte; //0x1BE
    MaxHandWeight: Byte; //0x1BF
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

  TMessageBodyWL = record //16  0x10
    lParam1: Integer;
    lParam2: Integer;
    lTag1: Integer;
    lTag2: Integer;
  end;

  TCharDesc = record
    feature: Integer;
    Status: Integer;
  end;
  TClientGoods = record
    Name: string;
    SubMenu: Integer;
    Price: Integer;
    Stock: Integer;
    Grade: Integer;
  end;
  pTClientGoods = ^TClientGoods;
  //ResourceString
function APPRfeature(cfeature: Integer): Word;
function RACEfeature(cfeature: Integer): Byte;
function HAIRfeature(cfeature: Integer): Byte;
function DRESSfeature(cfeature: Integer): Byte;
function WEAPONfeature(cfeature: Integer): Byte;
implementation

function WEAPONfeature(cfeature: Integer): Byte;
begin
  Result := HiByte(cfeature);
end;
function DRESSfeature(cfeature: Integer): Byte;
begin
  Result := HiByte(HiWord(cfeature));
end;
function APPRfeature(cfeature: Integer): Word;
begin
  Result := HiWord(cfeature);
end;
function HAIRfeature(cfeature: Integer): Byte;
begin
  Result := HiWord(cfeature);
end;
function RACEfeature(cfeature: Integer): Byte;
begin
  Result := cfeature;
end;

end.

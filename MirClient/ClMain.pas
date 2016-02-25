unit ClMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  JSocket, ExtCtrls, DXDraws, DirectX, DXClass, DrawScrn,
  IntroScn, PlayScn, MapUnit, WIL, Grobal2, SDK,
  Actor, DIB, StdCtrls, CliUtil, HUtil32, EdCode,
  DWinCtl, ClFunc, magiceff, SoundUtil, DXSounds, clEvent, Wave, IniFiles,
  Spin, ComCtrls, Grids, Mpeg, Menus, Mask, MShare, Share;

const
  BO_FOR_TEST = FALSE;
  EnglishVersion = True; //TRUE;
  BoNeedPatch = True;

  NEARESTPALETTEINDEXFILE = 'Data\npal.idx';

  MonImageDir = '.\Graphics\Monster\';
  NpcImageDir = '.\Graphics\Npc\';
  ItemImageDir = '.\Graphics\Items\';
  WeaponImageDir = '.\Graphics\Weapon\';
  HumImageDir = '.\Graphics\Human\';

type
  TKornetWorld = record
    CPIPcode: string;
    SVCcode: string;
    LoginID: string;
    CheckSum: string;
  end;

  TOneClickMode = (toNone, toKornetWorld);



  TfrmMain = class(TDxForm)
    CSocket: TClientSocket;
    Timer1: TTimer;
    MouseTimer: TTimer;
    WaitMsgTimer: TTimer;
    SelChrWaitTimer: TTimer;
    CmdTimer: TTimer;
    MinTimer: TTimer;
    SpeedHackTimer: TTimer;
    DXDraw: TDXDraw;
    WMonImg: TWMImages;
    WMon2Img: TWMImages;
    WMon3Img: TWMImages;
    WMon4Img: TWMImages;
    WMon5Img: TWMImages;
    WMon6Img: TWMImages;
    WMon7Img: TWMImages;
    WMon8Img: TWMImages;
    WMon9Img: TWMImages;
    WMon10Img: TWMImages;
    WMon11Img: TWMImages;
    WMon12Img: TWMImages;
    WMon13Img: TWMImages;
    WMon14Img: TWMImages;
    WMon15Img: TWMImages;
    WMon16Img: TWMImages;
    WMon17Img: TWMImages;
    WMon18Img: TWMImages;
    WMon19Img: TWMImages;
    WMon20Img: TWMImages;
    WMon21Img: TWMImages;
    WMon22Img: TWMImages;
    WMon23Img: TWMImages;
    WMon50Img: TWMImages;
    WMon51Img: TWMImages;
    WMon52Img: TWMImages;
    WMon53Img: TWMImages;
    WMon54Img: TWMImages;
    WEffectImg: TWMImages;
    WDragonImg: TWMImages;

    function  GetMagicByID (Id: Byte): Boolean;
    procedure OpenSdoAssistant();
    procedure DXDrawInitialize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DXDrawMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure DXDrawMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure DXDrawFinalize(Sender: TObject);
    procedure CSocketConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure CSocketDisconnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure CSocketError(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure CSocketRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure Timer1Timer(Sender: TObject);
    procedure DXDrawMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure MouseTimerTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DXDrawDblClick(Sender: TObject);
    procedure WaitMsgTimerTimer(Sender: TObject);
    procedure SelChrWaitTimerTimer(Sender: TObject);
    procedure DXDrawClick(Sender: TObject);
    procedure CmdTimerTimer(Sender: TObject);
    procedure MinTimerTimer(Sender: TObject);
    procedure CheckHackTimerTimer(Sender: TObject);
    procedure SendTimeTimerTimer(Sender: TObject);
    procedure SpeedHackTimerTimer(Sender: TObject);
    function AutoLieHuo: Boolean; //自动烈火
    function AutoZhuri: Boolean;
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);

  private
    SocStr, BufferStr: string;
    WarningLevel: Integer;
    TimerCmd: TTimerCommand;
    MakeNewId: string;

    ActionLockTime: LongWord;
    LastHitTick: LongWord;
    ActionFailLock: Boolean;
    ActionFailLockTime: LongWord;
    FailAction, FailDir: Integer;
    ActionKey: Word;

    CursorSurface: TDirectDrawSurface;
    mousedowntime: LongWord;
    WaitingMsg: TDefaultMessage;
    WaitingStr: string;
    WhisperName: string;


    procedure AutoPickUpItem();
    procedure ProcessKeyMessages;
    procedure ProcessActionMessages;
    procedure CheckSpeedHack(rtime: LongWord);
    procedure DecodeMessagePacket(datablock: string);
    procedure ActionFailed;
    function GetMagicByKey(Key: Char): PTClientMagic;
    procedure UseMagic(tx, ty: Integer; pcm: PTClientMagic);
    procedure UseMagicSpell(who, effnum, targetx, targety, magic_id: Integer);
    procedure UseMagicFire(who, efftype, effnum, targetx, targety, target: Integer);
    procedure UseMagicFireFail(who: Integer);
    procedure CloseAllWindows;
    procedure ClearDropItems;
    procedure ResetGameVariables;
    procedure ChangeServerClearGameVariables;
    procedure _DXDrawMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure AttackTarget(target: TActor);

    function CheckDoorAction(dx, dy: Integer): Boolean;
    procedure ClientGetPasswdSuccess(body: string);
    procedure ClientGetNeedUpdateAccount(body: string);
    procedure ClientGetSelectServer;
    procedure ClientGetPasswordOK(Msg: TDefaultMessage; sBody: string);
    procedure ClientGetReceiveChrs(body: string);
    procedure ClientGetStartPlay(body: string);
    procedure ClientGetReconnect(body: string);
    procedure ClientGetServerConfig(Msg: TDefaultMessage; sBody: string);
    procedure ClientGetMapDescription(Msg: TDefaultMessage; sBody: string);
    procedure ClientGetGameGoldName(Msg: TDefaultMessage; sBody: string);

    procedure ClientGetAdjustBonus(bonus: Integer; body: string);
    procedure ClientGetAddItem(body: string);
    procedure ClientGetUpdateItem(body: string);
    procedure ClientGetDelItem(body: string);
    procedure ClientGetDelItems(body: string);
    procedure ClientGetBagItmes(body: string);
    procedure ClientGetDropItemFail(iname: string; sindex: Integer);
    procedure ClientGetShowItem(itemid, X, Y, looks: Integer; itmname: string);
    procedure ClientGetHideItem(itemid, X, Y: Integer);
    procedure ClientGetSenduseItems(body: string);
    procedure ClientGetSendAddUseItems(body: string);
    procedure ClientGetAddMagic(body: string);
    procedure ClientGetDelMagic(magid: Integer);
    procedure ClientGetMyMagics(body: string);
    procedure ClientGetMagicLvExp(magid, maglv, magtrain: Integer);
    procedure ClientGetDuraChange(uidx, newdura, newduramax: Integer);
    procedure ClientGetMerchantSay(merchant, face: Integer; saying: string);
    procedure ClientGetSendGoodsList(merchant, count: Integer; body: string);
    procedure ClientGetSendMakeDrugList(merchant: Integer; body: string);
    procedure ClientGetSendUserSell(merchant: Integer);
    procedure ClientGetSendUserRepair(merchant: Integer);
    procedure ClientGetSendUserStorage(merchant: Integer);
    procedure ClientGetSaveItemList(merchant: Integer; bodystr: string);
    procedure ClientGetSendDetailGoodsList(merchant, count, topline: Integer; bodystr: string);
    procedure ClientGetSendNotice(body: string);
    procedure ClientGetGroupMembers(bodystr: string);
    procedure ClientGetOpenGuildDlg(bodystr: string);
    procedure ClientGetSendGuildMemberList(body: string);
    procedure ClientGetDealRemoteAddItem(body: string);
    procedure ClientGetDealRemoteDelItem(body: string);
    procedure ClientGetReadMiniMap(mapindex: Integer);
    procedure ClientGetChangeGuildName(body: string);
    procedure ClientGetSendUserState(body: string);
    procedure DrawEffectHum(nType, nX, nY: Integer);
    procedure ClientGetNeedPassword(body: string);
    procedure ClientGetPasswordStatus(Msg: pTDefaultMessage; body: string);
    procedure ClientGetRegInfo(Msg: pTDefaultMessage; body: string);
    procedure ClientGetShopItems(Msg: pTDefaultMessage; body: string);
    procedure SetInputStatus();
    procedure CmdShowHumanMsg(sParam1, sParam2, sParam3, sParam4,
      sParam5: string);
    procedure ShowHumanMsg(Msg: pTDefaultMessage);
    procedure SendPowerBlock;
    function NearActor: Boolean;


  public
    LoginID, LoginPasswd, CharName: string;
    Certification: Integer;
    ActionLock: Boolean;
    //MainSurface: TDirectDrawSurface;
    NpcImageList: TList;
    ItemImageList: TList;
    WeaponImageList: TList;
    HumImageList: TList;

    procedure WMSysCommand(var Message: TWMSysCommand); message WM_SYSCOMMAND;
    procedure ProcOnIdle;
    procedure AppOnIdle(Sender: TObject; var Done: Boolean);
    procedure AppLogout;
    procedure AppExit;
    procedure PrintScreenNow;
    procedure EatItem(idx: Integer);

    procedure SendClientMessage(Msg, Recog, param, tag, series: Integer);
    procedure SendLogin(uid, passwd: string);
    procedure SendNewAccount(ue: TUserEntry; ua: TUserEntryAdd);
    procedure SendUpdateAccount(ue: TUserEntry; ua: TUserEntryAdd);
    procedure SendSelectServer(svname: string);
    procedure SendChgPw(id, passwd, newpasswd: string);
    procedure SendNewChr(uid, uname, shair, sjob, ssex: string);
    procedure SendQueryChr;
    procedure SendDelChr(chrname: string);
    procedure SendSelChr(chrname: string);
    procedure SendRunLogin;
    procedure SendSay(str: string);
    procedure SendActMsg(ident, X, Y, dir: Integer);
    procedure SendSpellMsg(ident, X, Y, dir, target: Integer);
    procedure SendQueryUserName(targetid, X, Y: Integer);
    procedure SendDropItem(name: string; itemserverindex: Integer);
    procedure SendPickup;
    procedure SendTakeOnItem(where: byte; itmindex: Integer; itmname: string);
    procedure SendTakeOffItem(where: byte; itmindex: Integer; itmname: string);
    procedure SendEat(itmindex: Integer; itmname: string);
    procedure SendButchAnimal(X, Y, dir, actorid: Integer);
    procedure SendMagicKeyChange(magid: Integer; keych: Char);
    procedure SendMerchantDlgSelect(merchant: Integer; rstr: string);
    procedure SendQueryPrice(merchant, itemindex: Integer; itemname: string);
    procedure SendQueryRepairCost(merchant, itemindex: Integer; itemname: string);
    procedure SendSellItem(merchant, itemindex: Integer; itemname: string);
    procedure SendRepairItem(merchant, itemindex: Integer; itemname: string);
    procedure SendStorageItem(merchant, itemindex: Integer; itemname: string);
    procedure SendGetDetailItem(merchant, menuindex: Integer; itemname: string);
    procedure SendBuyItem(merchant, itemserverindex: Integer; itemname: string);
    procedure SendTakeBackStorageItem(merchant, itemserverindex: Integer; itemname: string);
    procedure SendMakeDrugItem(merchant: Integer; itemname: string);
    procedure SendDropGold(dropgold: Integer);
    procedure SendGroupMode(onoff: Boolean);
    procedure SendCreateGroup(withwho: string);
    procedure SendWantMiniMap;
    procedure SendDealTry; //菊俊 荤恩捞 乐绰瘤 八荤
    procedure SendGuildDlg;
    procedure SendCancelDeal;
    procedure SendAddDealItem(ci: TClientItem);
    procedure SendDelDealItem(ci: TClientItem);
    procedure SendChangeDealGold(gold: Integer);
    procedure SendDealEnd;
    procedure SendAddGroupMember(withwho: string);
    procedure SendDelGroupMember(withwho: string);
    procedure SendGuildHome;
    procedure SendGuildMemberList;
    procedure SendGuildAddMem(who: string);
    procedure SendGuildDelMem(who: string);
    procedure SendGuildUpdateNotice(notices: string);
    procedure SendGuildUpdateGrade(rankinfo: string);
    procedure SendSpeedHackUser; //SpeedHaker 荤侩磊甫 辑滚俊 烹焊茄促.
    procedure SendAdjustBonus(remain: Integer; babil: TNakedAbility);
    procedure SendPassword(sPassword: string; nIdent: Integer);
    procedure SendShopDlg(wPage,idxe: Word);
    procedure SendBuyShopItem(sItems: string; btType: byte);

    function TargetInSwordLongAttackRange(ndir: Integer): Boolean;
    function TargetInSwordWideAttackRange(ndir: Integer): Boolean;
    function TargetInSwordCrsAttackRange(ndir: Integer): Boolean;
    function  TargetInCanTwnAttackRange(sx, sy, dx, dy: Integer): Boolean;
    function  TargetInCanQTwnAttackRange(sx, sy, dx, dy: Integer): Boolean;


    procedure OnProgramException(Sender: TObject; E: Exception);
    procedure SendSocket(sendstr: string);
    function ServerAcceptNextAction: Boolean;
    function CanNextAction: Boolean;
    function CanNextHit: Boolean;
    function IsUnLockAction(Action, adir: Integer): Boolean;
    procedure ActiveCmdTimer(cmd: TTimerCommand);
    function IsGroupMember(uname: string): Boolean;
    procedure SelectChr(sChrName: string);

    function GetNpcImg(wAppr: Word; var WMImage: TWMImages): Boolean;
    function GetWStateImg(idx: Integer): TDirectDrawSurface; overload;
    function GetWStateImg(idx: Integer; var ax, ay: Integer): TDirectDrawSurface; overload;
    function GetWWeaponImg(Weapon, m_btSex, nFrame: Integer; var ax, ay: Integer): TDirectDrawSurface;
    function GetWHumImg(Dress, m_btSex, nFrame: Integer; var ax, ay: Integer): TDirectDrawSurface;
    procedure ProcessCommand(sData: string);
  end;

function IsDebug(): Boolean;
function IsDebugA(): Boolean;
function CheckMirProgram: Boolean;
procedure PomiTextOut(dsurface: TDirectDrawSurface; X, Y: Integer; str: string);
procedure WaitAndPass(msec: LongWord);
function GetRGB(c256: byte): Integer;
procedure DebugOutStr(Msg: string);

var
  boOutbugStr: Boolean = FALSE;
  nLeft: Integer = 10;
  nTop: Integer = 10;
  nWidth: Integer;
  nHeight: Integer;
  g_boShowMemoLog: Boolean = FALSE;
  g_boShowRecog: Integer = 0;
  frmMain: TfrmMain;
  DScreen: TDrawScreen;
  IntroScene: TIntroScene;
  LoginScene: TLoginScene;
  SelectChrScene: TSelectChrScene;
  PlayScene: TPlayScene;
  LoginNoticeScene: TLoginNotice;

  LocalLanguage: TImeMode = imSHanguel;

  MP3: TMPEG;
  TestServerAddr: string = '127.0.0.1';
  BGMusicList: TStringList;
  //DObjList: TList;  //官蹿俊 函版等 瘤屈狼 钎泅
  EventMan: TClEventManager;
  KornetWorld: TKornetWorld;
  Map: TMap;
  BoOneClick: Boolean;
  OneClickMode: TOneClickMode;
  m_boPasswordIntputStatus: Boolean = FALSE;

implementation

uses
  FState;

{$R *.DFM}
var
  ShowMsgActor: TActor;
function CheckMirProgram: Boolean;
var
  pstr, cstr: array[0..255] of Char;
  mirapphandle: HWnd;
begin
  Result := FALSE;
  StrPCopy(pstr, 'legend of mir2');
  mirapphandle := FindWindow(nil, pstr);
  if (mirapphandle <> 0) and (mirapphandle <> Application.Handle) then begin
{$IFNDEF COMPILE}
    SetActiveWindow(mirapphandle);
    Result := True;
{$ENDIF}
    Exit;
  end;
end;

procedure PomiTextOut(dsurface: TDirectDrawSurface; X, Y: Integer; str: string);
var
  i, n: Integer;
  d: TDirectDrawSurface;
begin
  for i := 1 to Length(str) do begin
    n := byte(str[i]) - byte('0');
    if n in [0..9] then begin //箭磊父 凳
      d := g_WMainImages.Images[30 + n];
      if d <> nil then
        dsurface.Draw(X + i * 8, Y, d.ClientRect, d, True);
    end else begin
      if str[i] = '-' then begin
        d := g_WMainImages.Images[40];
        if d <> nil then
          dsurface.Draw(X + i * 8, Y, d.ClientRect, d, True);
      end;
    end;
  end;
end;

procedure WaitAndPass(msec: LongWord);
var
  start: LongWord;
begin
  start := GetTickCount;
  while GetTickCount - start < msec do begin
    Application.ProcessMessages;
  end;
end;

function GetRGB(c256: byte): Integer;
begin
  with frmMain.DXDraw do
    Result := RGB(DefColorTable[c256].rgbRed,
      DefColorTable[c256].rgbGreen,
      DefColorTable[c256].rgbBlue);
end;

procedure DebugOutStr(Msg: string);
var
  flname: string;
  fhandle: TextFile;
begin
  //DScreen.AddChatBoardString(msg,clWhite, clBlack);
  if not boOutbugStr then Exit;
  flname := '.\!debug.txt';
  if FileExists(flname) then begin
    AssignFile(fhandle, flname);
    Append(fhandle);
  end else begin
    AssignFile(fhandle, flname);
    Rewrite(fhandle);
  end;
  WriteLn(fhandle, TimeToStr(Time) + ' ' + Msg);
  CloseFile(fhandle);
end;

function KeyboardHookProc(Code: Integer; WParam: Longint; var Msg: TMsg): Longint; stdcall;
begin
  Result := 0; //jacky
  if ((WParam = 9) { or (WParam = 13)}) and (g_nLastHookKey = 18) and (GetTickCount - g_dwLastHookKeyTime < 500) then begin
    if frmMain.WindowState <> wsMinimized then begin
      frmMain.WindowState := wsMinimized;
    end else
      Result := CallNextHookEx(g_ToolMenuHook, Code, WParam, Longint(@Msg));
    Exit;
  end;
  g_nLastHookKey := WParam;
  g_dwLastHookKeyTime := GetTickCount;
  Result := CallNextHookEx(g_ToolMenuHook, Code, WParam, Longint(@Msg));
end;

procedure TfrmMain.FormCreate(Sender: TObject);
var
  flname, str: string;
  ini: TIniFile;
  FtpConf: TIniFile;
begin
  ini := nil;
  FtpConf := nil;
  g_AutoPickupList := TList.Create;
  g_ShowItemList := TGList.Create;

  g_DWinMan := TDWinManager.Create(Self);
  g_DXDraw := DXDraw;
  Randomize;
  ini := TIniFile.Create('.\mir2.ini');
  if ini <> nil then begin
    if EnglishVersion then begin
      g_sServerAddr := ini.ReadString('Setup', 'ServerAddr', g_sServerAddr);
      g_nServerPort := ini.ReadInteger('Setup', 'ServerPort', g_nServerPort);
      LocalLanguage := imOpen;
    end;

    g_boFullScreen := ini.ReadBool('Setup', 'FullScreen', g_boFullScreen);
    g_sCurFontName := ini.ReadString('Setup', 'FontName', g_sCurFontName);
    g_sMainParam1 := ini.ReadString('Setup', 'Param1', '');
    g_sMainParam2 := ini.ReadString('Setup', 'Param2', '');
    g_sLogoText := ini.ReadString('Server', 'Server1Caption', g_sLogoText);
    ini.Free;
  end;
  {FtpConf := TIniFile.Create('.\ftp.ini');
  if FtpConf <> nil then begin
    g_sLogoText := FtpConf.ReadString('Server', 'Server1Caption', g_sLogoText);
    FtpConf.Free;
  end; }
  Caption := g_sLogoText;
  if g_boFullScreen then
    //     DXDraw.Options:=DXDraw.Options + [doFullScreen]; 全屏
    DXDraw.Options := DXDraw.Options + [doFullScreen];
  LoadWMImagesLib(nil);
  NpcImageList := TList.Create;
  ItemImageList := TList.Create;
  WeaponImageList := TList.Create;
  HumImageList := TList.Create;
  g_DXSound := TDXSound.Create(Self);
  g_DXSound.Initialize;
  DXDraw.Display.Width := SCREENWIDTH;
  DXDraw.Display.Height := SCREENHEIGHT;
  if g_DXSound.Initialized then begin
    g_Sound := TSoundEngine.Create(g_DXSound.DSound);
    MP3 := TMPEG.Create(nil);
  end else begin
    g_Sound := nil;
    MP3 := nil;
  end;

  g_ToolMenuHook := SetWindowsHookEx(WH_KEYBOARD, @KeyboardHookProc, 0, GetCurrentThreadID);

  g_SoundList := TStringList.Create;
  BGMusicList := TStringList.Create;
  g_ShopItemList := TList.Create;//商铺
  flname := '.\wav\sound.lst';
  LoadSoundList(flname);
  flname := '.\wav\BGList.lst';
  LoadBGMusicList(flname);
  //if FileExists (flname) then
  //   SoundList.LoadFromFile (flname);

  DScreen := TDrawScreen.Create;
  IntroScene := TIntroScene.Create;
  LoginScene := TLoginScene.Create;
  SelectChrScene := TSelectChrScene.Create;
  PlayScene := TPlayScene.Create;
  LoginNoticeScene := TLoginNotice.Create;

  Map := TMap.Create;
  g_DropedItemList := TList.Create;
  g_MagicList := TList.Create;
  g_FreeActorList := TList.Create;
  //DObjList := TList.Create;
  EventMan := TClEventManager.Create;
  g_ChangeFaceReadyList := TList.Create;
  g_ServerList := TStringList.Create;
  g_MySelf := nil;
  FillChar(g_UseItems, sizeof(TClientItem) * 13, #0);
  //   FillChar (UseItems, sizeof(TClientItem)*9, #0);
  FillChar(g_ItemArr, sizeof(TClientItem) * MAXBAGITEMCL, #0);
  FillChar(g_DealItems, sizeof(TClientItem) * 10, #0);
  FillChar(g_DealRemoteItems, sizeof(TClientItem) * 20, #0);

  FillChar(g_MouseShopItems,SizeOf(TShopItem),#0);
  
  g_SaveItemList := TList.Create;
  g_MenuItemList := TList.Create;
  g_WaitingUseItem.Item.S.name := ''; //馒侩芒 辑滚客 烹脚埃俊 烙矫历厘
  g_EatingItem.S.name := '';
  g_nTargetX := -1;
  g_nTargetY := -1;
  g_TargetCret := nil;
  g_FocusCret := nil;
  g_FocusItem := nil;
  g_MagicTarget := nil;
  g_nDebugCount := 0;
  g_nDebugCount1 := 0;
  g_nDebugCount2 := 0;
  g_nTestSendCount := 0;
  g_nTestReceiveCount := 0;
  g_boServerChanging := FALSE;
  g_boBagLoaded := FALSE;
  g_boAutoDig := FALSE;

  g_dwLatestClientTime2 := 0;
  g_dwFirstClientTime := 0;
  g_dwFirstServerTime := 0;
  g_dwFirstClientTimerTime := 0;
  g_dwLatestClientTimerTime := 0;
  g_dwFirstClientGetTime := 0;
  g_dwLatestClientGetTime := 0;

  g_nTimeFakeDetectCount := 0;
  g_nTimeFakeDetectTimer := 0;
  g_nTimeFakeDetectSum := 0;

  g_dwSHGetTime := 0;
  g_dwSHTimerTime := 0;
  g_nSHFakeCount := 0;

  g_nDayBright := 3;
  g_nAreaStateValue := 0;
  g_ConnectionStep := cnsLogin;
  g_boSendLogin := FALSE;
  g_boServerConnected := FALSE;

    g_boCanTwnHit   := False; //开天斩
   g_boCanQTwnHit  := False; //轻击开天斩 2008.02.12
   g_boCanCIDHit   := False;//龙影剑法

  SocStr := '';
  WarningLevel := 0; //阂樊菩哦 荐脚 冉荐 (菩哦汗荤 啊瓷己 乐澜)
  ActionFailLock := FALSE;
  g_boMapMoving := FALSE;
  g_boMapMovingWait := FALSE;
  g_boCheckBadMapMode := FALSE;
  g_boCheckSpeedHackDisplay := FALSE;
  g_boViewMiniMap := FALSE;
  g_boShowGreenHint := True;
  g_boShowWhiteHint := True;
  FailDir := 0;
  FailAction := 0;
  g_nDupSelection := 0;


  g_dwLastAttackTick := GetTickCount;
  g_dwLastMoveTick := GetTickCount;
  g_dwLatestSpellTick := GetTickCount;

  g_dwAutoPickupTick := GetTickCount;
  g_boFirstTime := True;
  g_boItemMoving := FALSE;
  g_boDoFadeIn := FALSE;
  g_boDoFadeOut := FALSE;
  g_boDoFastFadeOut := FALSE;
  g_boAttackSlow := FALSE;
  g_boMoveSlow := FALSE;
  g_boNextTimePowerHit := FALSE;
  g_boCanLongHit := FALSE;
  g_boCanWideHit := FALSE;
  g_boCanCrsHit := FALSE;
  g_boCanTwnHit := FALSE;

  g_boNextTimeFireHit := FALSE;

  g_boNoDarkness := FALSE;
  g_SoftClosed := FALSE;
  g_boQueryPrice := FALSE;
  g_sSellPriceStr := '';

  g_boAllowGroup := FALSE;
  g_GroupMembers := TStringList.Create;

  MainWinHandle := DXDraw.Handle;

  //盔努腐, 内齿岿靛 殿..
  BoOneClick := FALSE;
  OneClickMode := toNone;

  g_boSound := True;
  g_boBGSound := True;

  if g_sMainParam1 = '' then begin
    CSocket.Address := g_sServerAddr;
    CSocket.Port := g_nServerPort;
  end else begin
    if (g_sMainParam1 <> '') and (g_sMainParam2 = '') then
      CSocket.Address := g_sMainParam1;
    if (g_sMainParam2 <> '') and (g_sMainParam3 = '') then begin
      CSocket.Address := g_sMainParam1;
      CSocket.Port := Str_ToInt(g_sMainParam2, 0);
    end;
    if (g_sMainParam3 <> '') then begin
      if CompareText(g_sMainParam1, '/KWG') = 0 then begin
        {
        CSocket.Address := kornetworldaddress;  //game.megapass.net';
        CSocket.Port := 9000;
        BoOneClick := TRUE;
        OneClickMode := toKornetWorld;
        with KornetWorld do begin
           CPIPcode := MainParam2;
           SVCcode  := MainParam3;
           LoginID  := MainParam4;
           CheckSum := MainParam5; //'dkskxhdkslxlkdkdsaaaasa';
        end;
        }
      end else begin
        CSocket.Address := g_sMainParam2;
        CSocket.Port := Str_ToInt(g_sMainParam3, 0);
        BoOneClick := True;
      end;
    end;
  end;
  if BO_FOR_TEST then
    CSocket.Address := TestServerAddr;

  CSocket.Active := True;

  //MainSurface := nil;
  DebugOutStr('----------------------- started ------------------------');

  Application.OnException := OnProgramException;
  Application.OnIdle := AppOnIdle;
end;

procedure TfrmMain.OnProgramException(Sender: TObject; E: Exception);
begin
  DebugOutStr(E.Message);
end;

procedure TfrmMain.WMSysCommand(var Message: TWMSysCommand);
begin
  {   with Message do begin
        if (CmdType and $FFF0) = SC_KEYMENU then begin
           if (Key = VK_TAB) or (Key = VK_RETURN) then begin
              FrmMain.WindowState := wsMinimized;
           end else
              inherited;
        end else
           inherited;
     end;
  }
  inherited;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
var
  i: Integer;
begin

  g_ShowItemList.Free;
  g_ShowItemList := nil;
  g_AutoPickupList.Free;
  g_AutoPickupList := nil;
  if g_ToolMenuHook <> 0 then UnhookWindowsHookEx(g_ToolMenuHook);
  //SoundCloseProc;
  //DXTimer.Enabled := FALSE;
  Timer1.Enabled := FALSE;
  MinTimer.Enabled := FALSE;

  UnLoadWMImagesLib();
  WDragonImg.Finalize;
  WMonImg.Finalize;
  WMon2Img.Finalize;
  WMon3Img.Finalize;
  WMon4Img.Finalize;
  WMon5Img.Finalize;
  WMon6Img.Finalize;
  WMon7Img.Finalize;
  WMon8Img.Finalize;
  WMon9Img.Finalize;
  WMon10Img.Finalize;
  WMon11Img.Finalize;
  WMon12Img.Finalize;
  WMon13Img.Finalize;
  WMon14Img.Finalize;
  WMon15Img.Finalize;
  WMon16Img.Finalize;
  WMon17Img.Finalize;
  WMon18Img.Finalize;
  WMon19Img.Finalize;
  WMon20Img.Finalize;
  WMon21Img.Finalize;
  WMon50Img.Finalize;
  WMon51Img.Finalize;
  WMon52Img.Finalize;
  WMon53Img.Finalize;
  WMon54Img.Finalize;
  WEffectImg.Finalize;

  for i := 0 to NpcImageList.count - 1 do begin
    TWMImages(NpcImageList.Items[i]).Finalize;
  end;
  for i := 0 to ItemImageList.count - 1 do begin
    TWMImages(ItemImageList.Items[i]).Finalize;
  end;
  for i := 0 to WeaponImageList.count - 1 do begin
    TWMImages(WeaponImageList.Items[i]).Finalize;
  end;
  for i := 0 to HumImageList.count - 1 do begin
    TWMImages(HumImageList.Items[i]).Finalize;
  end;

  if g_FilterItemNameList <> nil then begin
     if g_FilterItemNameList.Count > 0 then begin//20080629
        for I := 0 to g_FilterItemNameList.Count - 1 do
          if pTShowItem(g_FilterItemNameList.Items[I]) <> nil then
            DisPose(pTShowItem(g_FilterItemNameList.Items[I]));
     end;
   end;
   FreeAndNil(g_FilterItemNameList);



  DScreen.Finalize;
  PlayScene.Finalize;
  LoginNoticeScene.Finalize;

  DScreen.Free;
  IntroScene.Free;
  LoginScene.Free;
  SelectChrScene.Free;
  PlayScene.Free;
  LoginNoticeScene.Free;
  g_SaveItemList.Free;
  g_MenuItemList.Free;

  DebugOutStr('----------------------- closed -------------------------');
  Map.Free;
  g_DropedItemList.Free;
  g_MagicList.Free;
  g_FreeActorList.Free;
  g_ChangeFaceReadyList.Free;
  g_ShopItemList.Free;//商铺
  g_ServerList.Free;
  //if MainSurface <> nil then MainSurface.Free;

  g_Sound.Free;
  g_SoundList.Free;
  BGMusicList.Free;
  //DObjList.Free;
  EventMan.Free;
  NpcImageList.Free;
  ItemImageList.Free;
  WeaponImageList.Free;
  HumImageList.Free;

  g_DXSound.Free;
  g_DWinMan.Free;
end;

function ComposeColor(Dest, Src: TRGBQuad; Percent: Integer): TRGBQuad;
begin
  with Result do begin
    rgbRed := Src.rgbRed + ((Dest.rgbRed - Src.rgbRed) * Percent div 256);
    rgbGreen := Src.rgbGreen + ((Dest.rgbGreen - Src.rgbGreen) * Percent div 256);
    rgbBlue := Src.rgbBlue + ((Dest.rgbBlue - Src.rgbBlue) * Percent div 256);
    rgbReserved := 0;
  end;
end;

procedure TfrmMain.DXDrawInitialize(Sender: TObject);
begin
  if g_boFirstTime then begin
    g_boFirstTime := FALSE;

    DXDraw.SurfaceWidth := SCREENWIDTH;
    DXDraw.SurfaceHeight := SCREENHEIGHT;

{$IF USECURSOR = DEFAULTCURSOR}
    DXDraw.Cursor := crHourGlass;
{$ELSE}
    DXDraw.Cursor := crNone;
{$IFEND}

    DXDraw.Surface.Canvas.Font.Assign(frmMain.Font);

    frmMain.Font.name := g_sCurFontName;
    frmMain.Canvas.Font.name := g_sCurFontName;
    DXDraw.Surface.Canvas.Font.name := g_sCurFontName;
    PlayScene.EdChat.Font.name := g_sCurFontName;

    //MainSurface := TDirectDrawSurface.Create (frmMain.DxDraw.DDraw);
    //MainSurface.SystemMemory := TRUE;
    //MainSurface.SetSize (SCREENWIDTH, SCREENHEIGHT);

    InitWMImagesLib(DXDraw);
    WDragonImg.DDraw := DXDraw.DDraw;
    WMonImg.DDraw := DXDraw.DDraw;
    WMon2Img.DDraw := DXDraw.DDraw;
    WMon3Img.DDraw := DXDraw.DDraw;
    WMon4Img.DDraw := DXDraw.DDraw;
    WMon5Img.DDraw := DXDraw.DDraw;
    WMon6Img.DDraw := DXDraw.DDraw;
    WMon7Img.DDraw := DXDraw.DDraw;
    WMon8Img.DDraw := DXDraw.DDraw;
    WMon9Img.DDraw := DXDraw.DDraw;
    WMon10Img.DDraw := DXDraw.DDraw;
    WMon11Img.DDraw := DXDraw.DDraw;
    WMon12Img.DDraw := DXDraw.DDraw;
    WMon13Img.DDraw := DXDraw.DDraw;
    WMon14Img.DDraw := DXDraw.DDraw;
    WMon15Img.DDraw := DXDraw.DDraw;
    WMon16Img.DDraw := DXDraw.DDraw;
    WMon17Img.DDraw := DXDraw.DDraw;
    WMon18Img.DDraw := DXDraw.DDraw;
    WMon19Img.DDraw := DXDraw.DDraw;
    WMon20Img.DDraw := DXDraw.DDraw;
    WMon21Img.DDraw := DXDraw.DDraw;
    WMon22Img.DDraw := DXDraw.DDraw;
    WMon23Img.DDraw := DXDraw.DDraw;
    WMon50Img.DDraw := DXDraw.DDraw;
    WMon51Img.DDraw := DXDraw.DDraw;
    WMon52Img.DDraw := DXDraw.DDraw;
    WMon53Img.DDraw := DXDraw.DDraw;
    WMon54Img.DDraw := DXDraw.DDraw;
    WEffectImg.DDraw := DXDraw.DDraw;
    WDragonImg.Initialize;
    WMonImg.Initialize;
    WMon2Img.Initialize;
    WMon3Img.Initialize;
    WMon4Img.Initialize;
    WMon5Img.Initialize;
    WMon6Img.Initialize;
    WMon7Img.Initialize;
    WMon8Img.Initialize;
    WMon9Img.Initialize;
    WMon10Img.Initialize;
    WMon11Img.Initialize;
    WMon12Img.Initialize;
    WMon13Img.Initialize;
    WMon14Img.Initialize;
    WMon15Img.Initialize;
    WMon16Img.Initialize;
    WMon17Img.Initialize;
    WMon18Img.Initialize;
    WMon19Img.Initialize;
    WMon20Img.Initialize;
    WMon21Img.Initialize;
    WMon22Img.Initialize;
    WMon23Img.Initialize;
    WMon50Img.Initialize;
    WMon51Img.Initialize;
    WMon52Img.Initialize;
    WMon53Img.Initialize;
    WMon54Img.Initialize;
    //      WNpcImg.Initialize;
    WEffectImg.Initialize;

    DXDraw.DefColorTable := g_WMainImages.MainPalette;
    DXDraw.ColorTable := DXDraw.DefColorTable;
    DXDraw.UpdatePalette;

    //256 Blend utility
    if not LoadNearestIndex(NEARESTPALETTEINDEXFILE) then begin
      BuildNearestIndex(DXDraw.ColorTable);
      SaveNearestIndex(NEARESTPALETTEINDEXFILE);
    end;
    BuildColorLevels(DXDraw.ColorTable);

    DScreen.Initialize;
    PlayScene.Initialize;
    FrmDlg.Initialize;
    if doFullScreen in DXDraw.Options then begin
      //Screen.Cursor := crNone;
    end else begin
      Left := 0;
      Top := 0;
      frmMain.BorderStyle := bsSingle ;
      frmMain.ClientWidth := SCREENWIDTH;
      frmMain.ClientHeight := SCREENHEIGHT;
      g_boNoDarkness := True;
      g_boUseDIBSurface := True;
    end;

    g_ImgMixSurface := TDirectDrawSurface.Create(frmMain.DXDraw.DDraw);
    g_ImgMixSurface.SystemMemory := True;
    g_ImgMixSurface.SetSize(300, 350);
    g_MiniMapSurface := TDirectDrawSurface.Create(frmMain.DXDraw.DDraw);
    g_MiniMapSurface.SystemMemory := True;
    g_MiniMapSurface.SetSize(540, 360);
    //DxDraw.Surface.SystemMemory := TRUE;
  end;
end;

procedure TfrmMain.DXDrawFinalize(Sender: TObject);
begin
  //DXTimer.Enabled := FALSE;
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  //Savebags ('.\Data\' + ServerName + '.' + CharName + '.itm', @ItemArr);
  //DxTimer.Enabled := FALSE;
end;


{------------------------------------------------------------}

procedure TfrmMain.ProcOnIdle;
var
  Done: Boolean;
begin
  AppOnIdle(Self, Done);
  //DXTimerTimer (self, 0);
end;

procedure TfrmMain.AppOnIdle(Sender: TObject; var Done: Boolean);
//procedure TFrmMain.DXTimerTimer(Sender: TObject; LagCount: Integer);
var
  i, j: Integer;
  p: TPoint;
  DF: DDBLTFX;
  d: TDirectDrawSurface;
  nC: Integer;

begin
  Done := True;
  if not DXDraw.CanDraw then Exit;

  // DxDraw.Surface.Fill(0);
  // BoldTextOut (DxDraw.Surface, 0, 0, clBlack, clBlack, 'test test ' + TimeToStr(Time));
  // DxDraw.Surface.Canvas.Release;

  ProcessKeyMessages;
  ProcessActionMessages;
  DScreen.DrawScreen(DXDraw.Surface);
  g_DWinMan.DirectPaint(DXDraw.Surface);
  DScreen.DrawScreenTop(DXDraw.Surface);
  DScreen.DrawHint(DXDraw.Surface);

{$IF USECURSOR = IMAGECURSOR}
  {Draw cursor}
  //=========================================
  //显示光标
  CursorSurface := g_WMainImages.Images[0];
  if CursorSurface <> nil then begin
    GetCursorPos(p);
    DXDraw.Surface.Draw(p.X, p.Y, CursorSurface.ClientRect, CursorSurface, True);
  end;
  //==========================
{$IFEND}

  if g_boItemMoving then begin
    if (g_MovingItem.Item.S.name <> g_sGoldName {'金币'}) then
      d := g_WBagItemImages.Images[g_MovingItem.Item.S.looks]
    else d := g_WBagItemImages.Images[115]; //金币外形
    if d <> nil then begin
      GetCursorPos(p);
      DXDraw.Surface.Draw(p.X - (d.ClientRect.Right div 2),
        p.Y - (d.ClientRect.Bottom div 2),
        d.ClientRect,
        d,
        True);
      //显示物品的ID号
      if (g_MovingItem.Item.S.name <> g_sGoldName {'金币'}) then
        with DXDraw.Surface.Canvas do begin
          SetBkMode(Handle, TRANSPARENT);
          Font.Color := clYellow;
          //TextOut(p.X + 9, p.Y + 3, g_MovingItem.Item.S.name);
          TextOut(p.X + 9, p.Y + 3, IntToStr(g_MovingItem.Item.MakeIndex));
          Release;
        end;
    end;
  end;
  if g_boDoFadeOut then begin
    if g_nFadeIndex < 1 then g_nFadeIndex := 1;
  //  MakeDark(DXDraw.Surface, g_nFadeIndex);
    if g_nFadeIndex <= 1 then g_boDoFadeOut := FALSE
    else Dec(g_nFadeIndex, 2);
  end else
    if g_boDoFadeIn then begin
    if g_nFadeIndex > 29 then g_nFadeIndex := 29;
  //  MakeDark(DXDraw.Surface, g_nFadeIndex);
    if g_nFadeIndex >= 29 then g_boDoFadeIn := FALSE
    else Inc(g_nFadeIndex, 2);
  end else
    if g_boDoFastFadeOut then begin
    if g_nFadeIndex < 1 then g_nFadeIndex := 1;
   // MakeDark(DXDraw.Surface, g_nFadeIndex);
    if g_nFadeIndex > 1 then Dec(g_nFadeIndex, 4);
  end;
  //登录的时候显示方形LOGO
  if g_ConnectionStep = cnsLogin then begin
    with DXDraw.Surface.Canvas do begin
      Brush.Color := clLime;
      nC := TextWidth(g_sLogoText) + 20;
      RoundRect(SCREENWIDTH - nC, 0, SCREENWIDTH, 32, 0, nC);
      Font.Color := clBlack;//clBlack;clWhite
      SetBkMode(Handle, TRANSPARENT);
      TextOut((SCREENWIDTH - nC) + ((nC - TextWidth(g_sLogoText)) div 2), (32 -TextHeight('W')) div 2, g_sLogoText);
          SetBkMode (Handle, TRANSPARENT);
         Font.Color := $0093F4F2;
         TextOut (360, 535,'健康游戏公告');  //显示出logo文字
         TextOut (190, 553,'抵制不良游戏，拒绝盗版游戏。注意自我保护，谨防受骗上当。适度游戏益脑，');  //显示出logo文字
         TextOut (190, 571,'沉迷游戏伤身。合理安排游戏，享受健康生活。严厉打击赌博，营造和谐环境。');  //显示出logo文字
         Font.Color := clSilver;
         TextOut (690, 585,g_sVersion);
      Release;
    end;
  end;
  //DXDraw.Primary.Draw(0, 0, DXDraw.Surface.ClientRect, DXDraw.Surface, FALSE);
  DXDraw.Flip;
  if g_MySelf <> nil then begin

  end;
end;

procedure TfrmMain.AppLogout;
begin
  if mrOk = FrmDlg.DMessageDlg('你是否退出 ?', [mbOk, mbCancel]) then begin
    SendClientMessage(CM_SOFTCLOSE, 0, 0, 0, 0);
    PlayScene.ClearActors;
    CloseAllWindows;
    if not BoOneClick then begin
      //         PlayScene.MemoLog.Lines.Add('小退关闭');
      g_SoftClosed := True;
      ActiveCmdTimer(tcSoftClose);
    end else begin
      ActiveCmdTimer(tcReSelConnect);
    end;
    if g_boBagLoaded then
      Savebags('.\Data\' + g_sServerName + '.' + CharName + '.itm', @g_ItemArr);
    g_boBagLoaded := FALSE;
  end;
end;

procedure TfrmMain.AppExit;
begin
  if mrOk = FrmDlg.DMessageDlg('你真的要退出游戏吗?', [mbOk, mbCancel]) then begin
    if g_boBagLoaded then
      Savebags('.\Data\' + g_sServerName + '.' + CharName + '.itm', @g_ItemArr);
    g_boBagLoaded := FALSE;
    frmMain.Close;
  end;
end;

procedure TfrmMain.PrintScreenNow;
  function IntToStr2(n: Integer): string;
  begin
    if n < 10 then Result := '0' + IntToStr(n)
    else Result := IntToStr(n);
  end;
var
  i, k, n, CheckSum: Integer;
  flname: string;
  DIB: TDIB;
  ddsd: TDDSurfaceDesc;
  sptr, dptr: PByte;
begin
  if not DXDraw.CanDraw then Exit;
  while True do begin
    flname := 'Images' + IntToStr2(g_nCaptureSerial) + '.bmp';
    if not FileExists(flname) then break;
    Inc(g_nCaptureSerial);
  end;
  DIB := TDIB.Create;
  DIB.BitCount := 8;
  DIB.Width := SCREENWIDTH;
  DIB.Height := SCREENHEIGHT;
  DIB.ColorTable := g_WMainImages.MainPalette;
  DIB.UpdatePalette;

  ddsd.dwSize := sizeof(ddsd);
  CheckSum := 0; //盲农芥阑父电促.
  try
    DXDraw.Primary.Lock(TRect(nil^), ddsd);
    for i := (600 - 120) to SCREENHEIGHT - 10 do begin
      sptr := PByte(Integer(ddsd.lpSurface) + (SCREENHEIGHT - 1 - i) * ddsd.lPitch + 200);
      for k := 0 to 400 - 1 do begin
        CheckSum := CheckSum + byte(PByte(Integer(sptr) + k)^);
      end;
    end;
  finally
    DXDraw.Primary.Unlock();
  end;

  try
    SetBkMode(DXDraw.Primary.Canvas.Handle, TRANSPARENT);
    DXDraw.Primary.Canvas.Font.Color := clWhite;
    n := 0;
    if g_MySelf <> nil then begin
      DXDraw.Primary.Canvas.TextOut(0, 0, g_sServerName + ' ' + g_MySelf.m_sUserName);
      Inc(n, 1);
    end;
    DXDraw.Primary.Canvas.TextOut(0, (n) * 12, 'CheckSum=' + IntToStr(CheckSum));
    DXDraw.Primary.Canvas.TextOut(0, (n + 1) * 12, DateToStr(Date));
    DXDraw.Primary.Canvas.TextOut(0, (n + 2) * 12, TimeToStr(Time));
    DXDraw.Primary.Canvas.Release;
    DXDraw.Primary.Lock(TRect(nil^), ddsd);
    for i := 0 to DIB.Height - 1 do begin
      sptr := PByte(Integer(ddsd.lpSurface) + (DIB.Height - 1 - i) * ddsd.lPitch);
      dptr := PByte(Integer(DIB.PBits) + i * SCREENWIDTH);
      //         dptr := PBYTE(integer(dib.PBits) + i * 800);
      Move(sptr^, dptr^, SCREENWIDTH);
      //         Move (sptr^, dptr^, 800);
    end;
  finally
    DXDraw.Primary.Unlock();
  end;
  DIB.SaveToFile(flname);
  DIB.Clear;
  DIB.Free;
end;


{------------------------------------------------------------}

procedure TfrmMain.ProcessKeyMessages;
begin
  {
  case ActionKey of
     VK_F1, VK_F2, VK_F3, VK_F4, VK_F5, VK_F6, VK_F7, VK_F8:
        begin
           UseMagic (MouseX, MouseY, GetMagicByKey (char ((ActionKey-VK_F1) + byte('1')) )); //胶农赴 谅钎
           //DScreen.AddSysMsg ('KEY' + IntToStr(Random(10000)));
           ActionKey := 0;
           TargetX := -1;
           exit;
        end;
  end;
  }
  case ActionKey of
    VK_F1, VK_F2, VK_F3, VK_F4, VK_F5, VK_F6, VK_F7, VK_F8: begin
        UseMagic(g_nMouseX, g_nMouseY, GetMagicByKey(Char((ActionKey - VK_F1) + byte('1')))); //胶农赴 谅钎
        ActionKey := 0;
        g_nTargetX := -1;
        Exit;
      end;
    {     12..19: begin
           UseMagic (g_nMouseX, g_nMouseY, GetMagicByKey (char ((ActionKey-12) + byte('1') + byte($14)) ));
           ActionKey := 0;
           g_nTargetX := -1;
           exit;
         end;}
  end;
end;
{
 鼠标控制 左　键 控制基本的行动：行走、攻击拾取物品和其他东西
右　键 近处的点击能够看到物品使用方法，远处的点击能够在地图上跑动。
Shift + 左键 强制攻击
Ctrl + 左键 跑动
Ctrl + 右键 关于对手的信息，如同F10一样。
Alt + 右键 取得肉或者其他玩家因为死亡丢失的东西。
双　击 拾取在地上的物品或者使用自己包裹中的物品。
}
procedure TfrmMain.ProcessActionMessages;
var
  mx, my, dx, dy, crun: Integer;
  ndir, adir, mdir: byte;
  bowalk, bostop: Boolean;
label
  LB_WALK;
begin
  if g_MySelf = nil then Exit;
  //Move
  if (g_nTargetX >= 0) and CanNextAction and ServerAcceptNextAction then begin //ActionLock捞 钱府搁, ActionLock篮 悼累捞 场唱扁 傈俊 钱赴促.
    if (g_nTargetX <> g_MySelf.m_nCurrX) or (g_nTargetY <> g_MySelf.m_nCurrY) then begin
      //   TTTT:
      mx := g_MySelf.m_nCurrX;
      my := g_MySelf.m_nCurrY;
      dx := g_nTargetX;
      dy := g_nTargetY;
      ndir := GetNextDirection(mx, my, dx, dy);
      case g_ChrAction of
        caWalk: begin
            LB_WALK:
            //Jacky 打开
            {
            DScreen.AddSysMsg ('caWalk ' + IntToStr(Myself.XX) + ' ' +
                                           IntToStr(Myself.m_nCurrY) + ' ' +
                                           IntToStr(TargetX) + ' ' +
                                           IntToStr(TargetY));
                                           }
            crun := g_MySelf.CanWalk;
            if IsUnLockAction(CM_WALK, ndir) and (crun > 0) then begin
              GetNextPosXY(ndir, mx, my);
              bowalk := True;
              bostop := FALSE;
              if not PlayScene.CanWalk(mx, my) then begin
                bowalk := FALSE;
                adir := 0;
                if not bowalk then begin //涝备 八荤
                  mx := g_MySelf.m_nCurrX;
                  my := g_MySelf.m_nCurrY;
                  GetNextPosXY(ndir, mx, my);
                  if CheckDoorAction(mx, my) then
                    bostop := True;
                end;
                if not bostop and not PlayScene.CrashMan(mx, my) then begin //荤恩篮 磊悼栏肺 乔窍瘤 臼澜..
                  mx := g_MySelf.m_nCurrX;
                  my := g_MySelf.m_nCurrY;
                  adir := PrivDir(ndir);
                  GetNextPosXY(adir, mx, my);
                  if not Map.CanMove(mx, my) then begin
                    mx := g_MySelf.m_nCurrX;
                    my := g_MySelf.m_nCurrY;
                    adir := NextDir(ndir);
                    GetNextPosXY(adir, mx, my);
                    if Map.CanMove(mx, my) then
                      bowalk := True;
                  end else
                    bowalk := True;
                end;
                if bowalk then begin
                  g_MySelf.UpdateMsg(CM_WALK, mx, my, adir, 0, 0, '', 0);
                  g_dwLastMoveTick := GetTickCount;
                end else begin
                  mdir := GetNextDirection(g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, dx, dy);
                  if mdir <> g_MySelf.m_btDir then
                    g_MySelf.SendMsg(CM_TURN, g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, mdir, 0, 0, '', 0);
                  g_nTargetX := -1;
                end;
              end else begin
                g_MySelf.UpdateMsg(CM_WALK, mx, my, ndir, 0, 0, '', 0); //亲惑 付瘤阜 疙飞父 扁撅
                g_dwLastMoveTick := GetTickCount;
              end;
            end else begin
              g_nTargetX := -1;
            end;
          end;
        caRun: begin
            //免助跑
            if g_nRunReadyCount >= 0 then begin
              crun := g_MySelf.CanRun;
              if (GetDistance(mx, my, dx, dy) >= 2) and (crun > 0) then begin
                if IsUnLockAction(CM_RUN, ndir) then begin
                  GetNextRunXY(ndir, mx, my);
                  if PlayScene.CanRun(g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, mx, my) then begin
                    g_MySelf.UpdateMsg(CM_RUN, mx, my, ndir, 0, 0, '', 0);
                    g_dwLastMoveTick := GetTickCount;
                  end;
                end else
                  g_nTargetX := -1;
              end else begin
                goto LB_WALK;
              end;
            end else begin
              Inc(g_nRunReadyCount);
              goto LB_WALK;
            end;
          end;
      end;
    end;
  end;
  g_nTargetX := -1; //茄锅俊 茄沫究..
  if g_MySelf.RealActionMsg.ident > 0 then begin
    FailAction := g_MySelf.RealActionMsg.ident; //角菩且锭 措厚
    FailDir := g_MySelf.RealActionMsg.dir;
    if g_MySelf.RealActionMsg.ident = CM_SPELL then begin
      SendSpellMsg(g_MySelf.RealActionMsg.ident,
        g_MySelf.RealActionMsg.X,
        g_MySelf.RealActionMsg.Y,
        g_MySelf.RealActionMsg.dir,
        g_MySelf.RealActionMsg.State);
    end else
      SendActMsg(g_MySelf.RealActionMsg.ident,
        g_MySelf.RealActionMsg.X,
        g_MySelf.RealActionMsg.Y,
        g_MySelf.RealActionMsg.dir);
    g_MySelf.RealActionMsg.ident := 0;

    //皋春甫 罐篮饶 10惯磊惫 捞惑 吧栏搁 磊悼栏肺 荤扼咙
    if g_nMDlgX <> -1 then
      if (abs(g_nMDlgX - g_MySelf.m_nCurrX) >= 8) or (abs(g_nMDlgY - g_MySelf.m_nCurrY) >= 8) then begin
        FrmDlg.CloseMDlg;
        g_nMDlgX := -1;
      end;
  end;
end;

procedure TfrmMain.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  Msg, wc, dir, mx, my: Integer;
  ini: TIniFile;
begin
  case Key of
    VK_PAUSE: begin
        Key := 0;
        PrintScreenNow();
      end;
  end;
  if g_DWinMan.KeyDown(Key, Shift) then Exit;
  if (g_MySelf = nil) or (DScreen.CurrentScene <> PlayScene) then Exit;
  mx := g_MySelf.m_nCurrX;
  my := g_MySelf.m_nCurrY;
  case Key of
    VK_F1, VK_F2, VK_F3, VK_F4,
      VK_F5, VK_F6, VK_F7, VK_F8: begin
        if (GetTickCount - g_dwLatestSpellTick > (500 + g_dwMagicDelayTime)) then begin
          if ssCtrl in Shift then begin
            ActionKey := Key - 100;
          end else begin
            ActionKey := Key;
          end;
        end;
        Key := 0;
      end;

    {
    　 快捷键 F10 打开/关闭角色窗口
    F9 打开/关闭包裹窗口
    F11 打开/关闭角色能力窗口
    Pause Break 在游戏中截图，截图将以IMAGE格式自动保存在MIR的目录下。
    F1, F2, F3, F4, F5, F6, F7, F8 由玩家自己设置的快捷键，这些魔法技能的快捷键设置可以加快游戏的操作性和流畅性，比如对火球，治愈等魔法的设置。
    }
    VK_F9: begin
        FrmDlg.OpenItemBag;
      end;
    VK_F10: begin
        FrmDlg.StatePage := 0;
        FrmDlg.OpenMyStatus;
      end;
    VK_F11: begin
        FrmDlg.StatePage := 3;
        FrmDlg.OpenMyStatus;
      end;
       VK_F12: begin
        OpenSdoAssistant();
    end;
        VK_ESCAPE: begin//ESC      20080314
      if g_boDownEsc then Exit;
      g_boDownEsc := True; //按下了ESC键
      g_boTempShowItem := g_boShowAllItem;
      g_boTempFilterItemShow := g_boFilterAutoItemShow;
      g_boShowAllItem := True;
      g_boFilterAutoItemShow := False;
    end;
    {
    Ctrl + H 选择自己喜欢的攻击模式
    和平攻击模式：除了对暴民以外其他攻击都无效。
    行会联盟攻击模式：对自己行会内的其他玩家攻击无效
    编组攻击模式：处于同一小组的玩家攻击无效
    全体攻击模式：对所有的玩家和暴民都具有攻击效果。
    善恶攻击模式：PK红名专用攻击模式。
     }
    Word('H'): begin
        if ssCtrl in Shift then begin
          SendSay('@AttackMode');
        end;
      end;
    Word('A'): begin
        if ssCtrl in Shift then begin
          SendSay('@Rest');
        end;
      end;
    Word('D'): begin
        if ssCtrl in Shift then begin
          SendPassword('', 0);
          {
          SetInputStatus();

          if m_boPasswordIntputStatus then
            DScreen.AddChatBoardString ('请输入密码：', clBlue, clWhite);
          }
        end;
      end;
    {
    word('D'): begin
      if ssCtrl in Shift then begin
        FrmDlg.DChgGamePwd.Visible:=not FrmDlg.DChgGamePwd.Visible;
      end;
    end;
    }
{
Ctrl + F 改版游戏的字体，你可以选择8种不同的字体
}
    Word('F'): begin
        if ssCtrl in Shift then begin
          if g_nCurFont < MAXFONT - 1 then Inc(g_nCurFont)
          else g_nCurFont := 0;
          g_sCurFontName := g_FontArr[g_nCurFont];
          frmMain.Font.name := g_sCurFontName;
          frmMain.Canvas.Font.name := g_sCurFontName;
          DXDraw.Surface.Canvas.Font.name := g_sCurFontName;
          PlayScene.EdChat.Font.name := g_sCurFontName;

          ini := TIniFile.Create('.\mir.ini');
          if ini <> nil then begin
            ini.WriteString('Setup', 'FontName', g_sCurFontName);
            ini.Free;
          end;
        end;
      end;
    Word('Z'): begin
        if ssCtrl in Shift then begin
          g_boShowAllItem := not g_boShowAllItem;
        end else
          if not PlayScene.EdChat.Visible then begin
          if CanNextAction and ServerAcceptNextAction then begin
            SendPickup; //捡物品
          end;
        end;
      end;
    {
    Alt + X 重新开始游戏（当角色死亡后特别有用）
    }
    Word('X'): begin
        if g_MySelf = nil then Exit;
        if ssAlt in Shift then begin
          //强行退出
          g_dwLatestStruckTick := GetTickCount() + 10001;
          g_dwLatestMagicTick := GetTickCount() + 10001;
          g_dwLatestHitTick := GetTickCount() + 10001;
          //
          if (GetTickCount - g_dwLatestStruckTick > 10000) and
            (GetTickCount - g_dwLatestMagicTick > 10000) and
            (GetTickCount - g_dwLatestHitTick > 10000) or
            (g_MySelf.m_boDeath) then begin
            AppLogout;
          end else
            DScreen.AddChatBoardString('你目前正在战斗中不能离开..', clYellow, clRed);
        end;
      end;
    Word('Q'): begin
        if g_MySelf = nil then Exit;
        if ssAlt in Shift then begin
          //强行退出
          g_dwLatestStruckTick := GetTickCount() + 10001;
          g_dwLatestMagicTick := GetTickCount() + 10001;
          g_dwLatestHitTick := GetTickCount() + 10001;
          //
          if (GetTickCount - g_dwLatestStruckTick > 10000) and
            (GetTickCount - g_dwLatestMagicTick > 10000) and
            (GetTickCount - g_dwLatestHitTick > 10000) or
            (g_MySelf.m_boDeath) then begin
            AppExit;
          end else
            DScreen.AddChatBoardString('你目前正在战斗中不能离开..', clYellow, clRed);
        end;
      end;
    Word('V'): begin
        if not PlayScene.EdChat.Visible then begin
          if not g_boViewMiniMap then begin
            if GetTickCount > g_dwQueryMsgTick then begin
              g_dwQueryMsgTick := GetTickCount + 3000;
              frmMain.SendWantMiniMap;
              g_nViewMinMapLv := 1;
            end;
          end else begin
            if g_nViewMinMapLv >= 2 then begin
              g_nViewMinMapLv := 0;
              g_boViewMiniMap := FALSE;
            end else Inc(g_nViewMinMapLv);
          end;
        end;
      end;
    Word('T'): begin
        if not PlayScene.EdChat.Visible then begin
          if GetTickCount > g_dwQueryMsgTick then begin
            g_dwQueryMsgTick := GetTickCount + 3000;
            frmMain.SendDealTry;
          end;
        end;
      end;
    Word('G'): begin
        if ssCtrl in Shift then begin
          if g_FocusCret <> nil then
            if g_GroupMembers.count = 0 then
              SendCreateGroup(g_FocusCret.m_sUserName)
            else SendAddGroupMember(g_FocusCret.m_sUserName);
          PlayScene.EdChat.Text := g_FocusCret.m_sUserName;
        end else begin
          if ssAlt in Shift then begin
            if g_FocusCret <> nil then
              SendDelGroupMember(g_FocusCret.m_sUserName)
          end else begin
            if not PlayScene.EdChat.Visible then begin
              if FrmDlg.DGuildDlg.Visible then begin
                FrmDlg.DGuildDlg.Visible := FALSE;
              end else
                if GetTickCount > g_dwQueryMsgTick then begin
                g_dwQueryMsgTick := GetTickCount + 3000;
                frmMain.SendGuildDlg;
              end;
            end;
          end;
        end;
      end;
    Word('P'): begin
        if not PlayScene.EdChat.Visible then
          FrmDlg.ToggleShowGroupDlg;
      end;

    Word('C'): begin
        if not PlayScene.EdChat.Visible then begin
          FrmDlg.StatePage := 0;
          FrmDlg.OpenMyStatus;
        end;
      end;

    Word('I'): begin
        if not PlayScene.EdChat.Visible then
          FrmDlg.OpenItemBag;
      end;
    Word('S'): begin
        if not PlayScene.EdChat.Visible then begin
          FrmDlg.StatePage := 3;
          FrmDlg.OpenMyStatus;
        end;
      end;
    Word('W'): begin
        if not PlayScene.EdChat.Visible then
          FrmDlg.OpenFriendDlg();
      end;

    Word('M'): begin
        if not PlayScene.EdChat.Visible then
          FrmDlg.OpenAdjustAbility;
      end;
  end;

  case Key of
    VK_UP:
      with DScreen do begin
        if ChatBoardTop > 0 then Dec(ChatBoardTop);
      end;
    VK_DOWN:
      with DScreen do begin
        if ChatBoardTop < ChatStrs.count - 1 then
          Inc(ChatBoardTop);
      end;
    VK_PRIOR:
      with DScreen do begin
        if ChatBoardTop > VIEWCHATLINE then
          ChatBoardTop := ChatBoardTop - VIEWCHATLINE
        else ChatBoardTop := 0;
      end;
    VK_NEXT:
      with DScreen do begin
        if ChatBoardTop + VIEWCHATLINE < ChatStrs.count - 1 then
          ChatBoardTop := ChatBoardTop + VIEWCHATLINE
        else ChatBoardTop := ChatStrs.count - 1;
        if ChatBoardTop < 0 then ChatBoardTop := 0;
      end;
  end;
end;

procedure TfrmMain.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if g_DWinMan.KeyPress(Key) then Exit;
  if DScreen.CurrentScene = PlayScene then begin
    if PlayScene.EdChat.Visible then begin
      //傍烹栏肺 贸府秦具 窍绰 版快父 酒贰肺 逞绢皑
      Exit;
    end;
    case byte(Key) of
      byte('1')..byte('6'): begin
          EatItem(byte(Key) - byte('1')); //骇飘 酒捞袍阑 荤侩茄促.
        end;
      27: {//ESC} begin
        end;
      byte(' '), 13: {//盲泼 冠胶} begin
          PlayScene.EdChat.Visible := True;
          PlayScene.EdChat.SetFocus;
          SetImeMode(PlayScene.EdChat.Handle, LocalLanguage);
          if FrmDlg.BoGuildChat then begin
            PlayScene.EdChat.Text := '!~';
            PlayScene.EdChat.SelStart := Length(PlayScene.EdChat.Text);
            PlayScene.EdChat.SelLength := 0;
          end else begin
            PlayScene.EdChat.Text := '';
          end;
        end;
      byte('@'),
        byte('!'),
        byte('/'): begin
          PlayScene.EdChat.Visible := True;
          PlayScene.EdChat.SetFocus;
          SetImeMode(PlayScene.EdChat.Handle, LocalLanguage);
          if Key = '/' then begin
            if WhisperName = '' then PlayScene.EdChat.Text := Key
            else if Length(WhisperName) > 2 then PlayScene.EdChat.Text := '/' + WhisperName + ' '
            else PlayScene.EdChat.Text := Key;
            PlayScene.EdChat.SelStart := Length(PlayScene.EdChat.Text);
            PlayScene.EdChat.SelLength := 0;
          end else begin
            PlayScene.EdChat.Text := Key;
            PlayScene.EdChat.SelStart := 1;
            PlayScene.EdChat.SelLength := 0;
          end;
        end;
    end;
    Key := #0;
  end;
end;

function TfrmMain.GetMagicByKey(Key: Char): PTClientMagic;
var
  i: Integer;
  pm: PTClientMagic;
begin
  Result := nil;
  for i := 0 to g_MagicList.count - 1 do begin
    pm := PTClientMagic(g_MagicList[i]);
    if pm.Key = Key then begin
      Result := pm;
      break;
    end;
  end;
end;

procedure TfrmMain.UseMagic(tx, ty: Integer; pcm: PTClientMagic); //tx, ty: 胶农赴 谅钎烙.
var
  tdir, targx, targy, targid: Integer;
  pmag: PTUseMagicInfo;
begin
  if pcm = nil then Exit;
  //是否可以使用魔法：需要的点数<当前点数，或者是魔法EffectType = 0
  if (pcm.Def.wSpell + pcm.Def.btDefSpell <= g_MySelf.m_Abil.MP) or (pcm.Def.btEffectType = 0) then begin
    if pcm.Def.btEffectType = 0 then begin
      if pcm.Def.wMagicId = 26 then begin //堪拳搬
        if GetTickCount - g_dwLatestFireHitTick < 10 * 1000 then begin
          Exit;
        end;
      end;
      //公怕焊绰 茄锅 荤侩饶 3檬鳖瘤绰 促矫 喘妨瘤瘤 臼绰促.
      if pcm.Def.wMagicId = 27 then begin //公怕焊
        if GetTickCount - g_dwLatestRushRushTick < 3 * 1000 then begin
          Exit;
        end;
      end;
      //八过篮 掉饭捞(500ms) 绝捞 喘妨柳促.
      if GetTickCount - g_dwLatestSpellTick > 500 then begin
        g_dwLatestSpellTick := GetTickCount;
        g_dwMagicDelayTime := 0; //pcm.Def.DelayTime;
        SendSpellMsg(CM_SPELL, g_MySelf.m_btDir {x}, 0, pcm.Def.wMagicId, 0);
      end;
    end else begin
      tdir := GetFlyDirection(390, 175, tx, ty);
      //     MagicTarget := FocusCret;
  //魔法锁定
      g_MagicTarget := g_FocusCret;
      if not PlayScene.IsValidActor(g_MagicTarget) then
        g_MagicTarget := nil;
      if g_MagicTarget = nil then begin
        PlayScene.CXYfromMouseXY(tx, ty, targx, targy);
        targid := 0;
      end else begin
        targx := g_MagicTarget.m_nCurrX;
        targy := g_MagicTarget.m_nCurrY;
        targid := g_MagicTarget.m_nRecogId;
      end;
      if CanNextAction and ServerAcceptNextAction then begin
        g_dwLatestSpellTick := GetTickCount; //付过 荤侩
        new(pmag);
        FillChar(pmag^, sizeof(TUseMagicInfo), #0);
        pmag.EffectNumber := pcm.Def.btEffect;
        pmag.MagicSerial := pcm.Def.wMagicId;
        pmag.ServerMagicCode := 0;
        g_dwMagicDelayTime := 200 + pcm.Def.dwDelayTime; //促澜 付过阑 荤侩且锭鳖瘤 浆绰 矫埃

        case pmag.MagicSerial of
          //0, 2, 11, 12, 15, 16, 17, 13, 23, 24, 26, 27, 28, 29: ;
          2, 14, 15, 16, 17, 18, 19, 21, //厚傍拜 付过 力寇
          12, 25, 26, 28, 29, 30, 31: ;
          else g_dwLatestMagicTick := GetTickCount;
        end;

        //荤恩阑 傍拜窍绰 版快狼 掉饭捞
        g_dwMagicPKDelayTime := 0;
        if g_MagicTarget <> nil then
          if g_MagicTarget.m_btRace = 0 then
            g_dwMagicPKDelayTime := 300 + Random(1100); //(600+200 + MagicDelayTime div 5);

        g_MySelf.SendMsg(CM_SPELL, targx, targy, tdir, Integer(pmag), targid, '', 0);
      end; // else
      //Dscreen.AddSysMsg ('泪矫饶俊 荤侩且 荐 乐嚼聪促.');
   //Inc (SpellCount);
    end;
  end else
    DScreen.AddSysMsg('魔法值不够....',0 , 30, 40, clGreen);
  //Dscreen.AddSysMsg ('魔法值不够！！！' + IntToStr(pcm.Def.wSpell) + '+' + IntToStr(pcm.Def.btDefSpell) + '/' +IntToStr(g_MySelf.m_Abil.MP));
end;

procedure TfrmMain.UseMagicSpell(who, effnum, targetx, targety, magic_id: Integer);
var
  Actor: TActor;
  adir: Integer;
  UseMagic: PTUseMagicInfo;
begin
  Actor := PlayScene.FindActor(who);
  if Actor <> nil then begin
    adir := GetFlyDirection(Actor.m_nCurrX, Actor.m_nCurrY, targetx, targety);
    new(UseMagic);
    FillChar(UseMagic^, sizeof(TUseMagicInfo), #0);
    UseMagic.EffectNumber := effnum; //magnum;
    UseMagic.ServerMagicCode := 0; //烙矫
    UseMagic.MagicSerial := magic_id;
    Actor.SendMsg(SM_SPELL, 0, 0, adir, Integer(UseMagic), 0, '', 0);
    Inc(g_nSpellCount);
  end else
    Inc(g_nSpellFailCount);
end;

procedure TfrmMain.UseMagicFire(who, efftype, effnum, targetx, targety, target: Integer);
var
  Actor: TActor;
  adir, sound: Integer;
  pmag: PTUseMagicInfo;
begin
  sound := 0; //jacky
  Actor := PlayScene.FindActor(who);
  if Actor <> nil then begin
    Actor.SendMsg(SM_MAGICFIRE, target {111magid}, efftype, effnum, targetx, targety, '', sound);
    //efftype = EffectType
    //effnum = Effect

    //if actor = Myself then Dec (SpellCount);
    if g_nFireCount < g_nSpellCount then
      Inc(g_nFireCount);
  end;
  g_MagicTarget := nil;
end;

procedure TfrmMain.UseMagicFireFail(who: Integer);
var
  Actor: TActor;
begin
  Actor := PlayScene.FindActor(who);
  if Actor <> nil then begin
    Actor.SendMsg(SM_MAGICFIRE_FAIL, 0, 0, 0, 0, 0, '', 0);
  end;
  g_MagicTarget := nil;
end;
//吃药
procedure TfrmMain.EatItem(idx: Integer);
begin
  if idx in [0..MAXBAGITEMCL - 1] then begin
    if (g_EatingItem.S.name <> '') and (GetTickCount - g_dwEatTime > 5 * 1000) then begin
      g_EatingItem.S.name := '';
    end;
    if (g_EatingItem.S.name = '') and (g_ItemArr[idx].S.name <> '') and (g_ItemArr[idx].S.StdMode <= 3) then begin
      g_EatingItem := g_ItemArr[idx];
      g_ItemArr[idx].S.name := '';
      //氓阑 佬绰 巴... 劳鳃 巴牢 瘤 拱绢夯促.
      if (g_ItemArr[idx].S.StdMode = 4) and (g_ItemArr[idx].S.Shape < 100) then begin
        //shape > 100捞搁 弓澜 酒捞袍 烙..
        if g_ItemArr[idx].S.Shape < 50 then begin
          if mrYes <> FrmDlg.DMessageDlg('是否确认开始练习 "' + g_ItemArr[idx].S.name + '"?', [mbYes, mbNo]) then begin
            g_ItemArr[idx] := g_EatingItem;
            Exit;
          end;
        end else begin
          //shape > 50捞搁 林巩 辑 辆幅...
          if mrYes <> FrmDlg.DMessageDlg('是否确认开始练习 "' + g_ItemArr[idx].S.name + '"?', [mbYes, mbNo]) then begin
            g_ItemArr[idx] := g_EatingItem;
            Exit;
          end;
        end;
      end;
      g_dwEatTime := GetTickCount;
      SendEat(g_ItemArr[idx].MakeIndex, g_ItemArr[idx].S.name);
      ItemUseSound(g_ItemArr[idx].S.StdMode);
    end;
  end else begin
    if (idx = -1) and g_boItemMoving then begin
      g_boItemMoving := FALSE;
      g_EatingItem := g_MovingItem.Item;
      g_MovingItem.Item.S.name := '';
      //氓阑 佬绰 巴... 劳鳃 巴牢 瘤 拱绢夯促.
      if (g_EatingItem.S.StdMode = 4) and (g_EatingItem.S.Shape < 100) then begin
        //shape > 100捞搁 弓澜 酒捞袍 烙..
        if g_EatingItem.S.Shape < 50 then begin
          if mrYes <> FrmDlg.DMessageDlg('是否确认开始练习 "' + g_EatingItem.S.name + '"?', [mbYes, mbNo]) then begin
            AddItemBag(g_EatingItem);
            Exit;
          end;
        end else begin
          //shape > 50捞搁 林巩 辑 辆幅...
          if mrYes <> FrmDlg.DMessageDlg('是否确认开始练习 "' + g_EatingItem.S.name + '"?', [mbYes, mbNo]) then begin
            AddItemBag(g_EatingItem);
            Exit;
          end;
        end;
      end;
      g_dwEatTime := GetTickCount;
      SendEat(g_EatingItem.MakeIndex, g_EatingItem.S.name);
      ItemUseSound(g_EatingItem.S.StdMode);
    end;
  end;
end;
   {
function TfrmMain.TargetInSwordLongAttackRange(ndir: Integer): Boolean;
var
  nX, nY: Integer;
  Actor: TActor;
begin
  Result := FALSE;
  GetFrontPosition(g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, ndir, nX, nY);
  GetFrontPosition(nX, nY, ndir, nX, nY);
  if (abs(g_MySelf.m_nCurrX - nX) = 2) or (abs(g_MySelf.m_nCurrY - nY) = 2) then begin
    Actor := PlayScene.FindActorXY(nX, nY);
    if Actor <> nil then
      if not Actor.m_boDeath then
        Result := True;
  end;
end;   }
       {
function TfrmMain.TargetInSwordWideAttackRange(ndir: Integer): Boolean;
var
  nX, nY, rx, ry, mdir: Integer;
  Actor, ractor: TActor;
begin
  Result := FALSE;
  GetFrontPosition(g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, ndir, nX, nY);
  Actor := PlayScene.FindActorXY(nX, nY);

  mdir := (ndir + 1) mod 8;
  GetFrontPosition(g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, mdir, rx, ry);
  ractor := PlayScene.FindActorXY(rx, ry);
  if ractor = nil then begin
    mdir := (ndir + 2) mod 8;
    GetFrontPosition(g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, mdir, rx, ry);
    ractor := PlayScene.FindActorXY(rx, ry);
  end;
  if ractor = nil then begin
    mdir := (ndir + 7) mod 8;
    GetFrontPosition(g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, mdir, rx, ry);
    ractor := PlayScene.FindActorXY(rx, ry);
  end;
  if (Actor <> nil) and (ractor <> nil) then
    if not Actor.m_boDeath and not ractor.m_boDeath then
      Result := True;
end; }  {

function TfrmMain.TargetInSwordCrsAttackRange(ndir: Integer): Boolean;
var
  nX, nY, rx, ry, mdir: Integer;
  Actor, ractor: TActor;
begin
  Result := FALSE;
  GetFrontPosition(g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, ndir, nX, nY);
  Actor := PlayScene.FindActorXY(nX, nY);

  mdir := (ndir + 1) mod 8;
  GetFrontPosition(g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, mdir, rx, ry);
  ractor := PlayScene.FindActorXY(rx, ry);
  if ractor = nil then begin
    mdir := (ndir + 2) mod 8;
    GetFrontPosition(g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, mdir, rx, ry);
    ractor := PlayScene.FindActorXY(rx, ry);
  end;
  if ractor = nil then begin
    mdir := (ndir + 7) mod 8;
    GetFrontPosition(g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, mdir, rx, ry);
    ractor := PlayScene.FindActorXY(rx, ry);
  end;

  if (Actor <> nil) and (ractor <> nil) then
    if not Actor.m_boDeath and not ractor.m_boDeath then
      Result := True;
end;  }

{--------------------- Mouse Interface ----------------------}

procedure TfrmMain.DXDrawMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  i, mx, my, msx, msy, sel: Integer;
  target: TActor;
  itemnames: string;
begin
  if g_DWinMan.MouseMove(Shift, X, Y) then Exit;
  if (g_MySelf = nil) or (DScreen.CurrentScene <> PlayScene) then Exit;
  g_boSelectMyself := PlayScene.IsSelectMyself(X, Y);

  target := PlayScene.GetAttackFocusCharacter(X, Y, g_nDupSelection, sel, FALSE);
  if g_nDupSelection <> sel then g_nDupSelection := 0;
  if target <> nil then begin
    if (target.m_sUserName = '') and (GetTickCount - target.m_dwSendQueryUserNameTime > 10 * 1000) then begin
      target.m_dwSendQueryUserNameTime := GetTickCount;
      SendQueryUserName(target.m_nRecogId, target.m_nCurrX, target.m_nCurrY);
    end;
    g_FocusCret := target;
  end else
    g_FocusCret := nil;

  g_FocusItem := PlayScene.GetDropItems(X, Y, itemnames);
  if g_FocusItem <> nil then begin
    PlayScene.ScreenXYfromMCXY(g_FocusItem.X, g_FocusItem.Y, mx, my);
    DScreen.ShowHint(mx - 20,
      my - 10,
      itemnames, //PTDropItem(ilist[i]).Name,
      clWhite,
      True);
  end else
    DScreen.ClearHint;

  PlayScene.CXYfromMouseXY(X, Y, g_nMouseCurrX, g_nMouseCurrY);
  g_nMouseX := X;
  g_nMouseY := Y;
  g_MouseItem.S.name := '';
  g_MouseStateItem.S.name := '';
  g_MouseUserStateItem.S.name := '';
  if ((ssLeft in Shift) or (ssRight in Shift)) and (GetTickCount - mousedowntime > 300) then
    _DXDrawMouseDown(Self, mbLeft, Shift, X, Y);
end;

procedure TfrmMain.DXDrawMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  mousedowntime := GetTickCount;
  g_nRunReadyCount := 0; //档框摧扁 秒家(顿扁 牢版快)
  _DXDrawMouseDown(Sender, Button, Shift, X, Y);
end;

procedure TfrmMain.AttackTarget(target: TActor);
var
  tdir, dx, dy, nHitMsg: Integer;
begin
  nHitMsg := CM_HIT;
   if g_UseItems[U_WEAPON].S.StdMode = 6 then nHitMsg := CM_HEAVYHIT;   //魔杖、偃月、裁决之杖等
   tdir := GetNextDirection (g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, target.m_nCurrX, target.m_nCurrY);//取得方向

   if (abs(g_MySelf.m_nCurrX - target.m_nCurrX) <= 1) and (abs(g_MySelf.m_nCurrY-target.m_nCurrY) <= 1) and (not target.m_boDeath) then begin
      if CanNextAction and ServerAcceptNextAction and CanNextHit then begin
         //烈火
         if g_boNextTimeFireHit and (g_MySelf.m_Abil.MP >= 7) then begin
            g_boNextTimeFireHit := FALSE;
            nHitMsg := CM_FIREHIT;
         end else
         //4级烈火  20080112
         if g_boNextTime4FireHit and (g_MySelf.m_Abil.Mp >= 7) then begin
            g_boNextTime4FireHit := FALSE;
            nHitMsg := CM_4FIREHIT;
         end else
         if g_boNextItemDAILYHit and (g_MySelf.m_Abil.MP >= 10) then begin
         //逐日剑法 20080511
            g_boNextItemDAILYHit := False;
            nHitMsg := CM_DAILY;
         end else
         //攻杀
         if g_boNextTimePowerHit then begin  
            g_boNextTimePowerHit := FALSE;
            nHitMsg := CM_POWERHIT;
         end else
         //开天斩 重击
         if g_boCanTwnHit and (g_MySelf.m_Abil.MP >= 10) then begin
            g_boCanTwnHit := FALSE;
            nHitMsg := CM_TWINHIT;
         end else
         //开天斩 轻击
        if g_boCanQTwnHit and (g_MySelf.m_Abil.MP >= 10) then begin
            g_boCanQTwnHit := FALSE;
            nHitMsg := CM_QTWINHIT;
         end else
         //龙影剑法
         if g_boCanCIDHit and (g_MySelf.m_Abil.MP >= 10) then begin
            g_boCanCIDHit := False;   //20080202
            nHitMsg :=  CM_CIDHIT;
         end else
         { 原代码
         if g_boCanWideHit and (g_MySelf.m_Abil.MP >= 3) then begin
            //智能半月
            if g_boAutoWideHit and (g_MySelf.m_btJob = 0) then begin
               if (TargetInSwordWideAttackRange (tdir)) then
                 nHitMsg := CM_WIDEHIT
               else
                 if g_boLongHit then nHitMsg := CM_LONGHIT;
            end else
            nHitMsg := CM_WIDEHIT;
         end else  }
        //智能半月
        if g_boAutoWideHit and (g_MySelf.m_btJob = 0) and (TargetInSwordWideAttackRange (tdir)) and (g_MySelf.m_Abil.MP >= 3) then begin
             nHitMsg := CM_WIDEHIT;
        end else
        if g_boCanWideHit and (g_MySelf.m_Abil.MP >= 3) then begin
          nHitMsg := CM_WIDEHIT;
        end else
        if g_boCanCrsHit and (g_MySelf.m_Abil.MP >= 6) then begin
          nHitMsg := CM_CRSHIT;
        end else
        if g_boLongHit and (g_MySelf.m_btJob = 0) then begin
          nHitMsg := CM_LONGHIT; 
        end else
        if g_boCanLongHit and (TargetInSwordLongAttackRange (tdir)) then begin
          nHitMsg := CM_LONGHIT;
        end;
         (* 原代码
         if g_boCanLongHit and ((g_boLongHit{刀刀刺杀} and (g_Myself.m_btJob=0) ) or TargetInSwordLongAttackRange (tdir)) then begin
            nHitMsg := CM_LONGHIT;
         end;*)

         if g_boAutoFireHit then AutoLieHuo;
         if g_boAutoZhuRiHit then AutoZhuri;

         //if ((target.m_btRace <> RCC_USERHUMAN) and (target.m_btRace <> RCC_GUARD)) or (ssShift in Shift) then //荤恩阑 角荐肺 傍拜窍绰 巴阑 阜澜
         g_MySelf.SendMsg (nHitMsg, g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, tdir, 0, 0, '', 0);
         g_dwLatestHitTick := GetTickCount;
      end;
      g_dwLastAttackTick := GetTickCount;
   end else begin
      if (abs(g_MySelf.m_nCurrX - target.m_nCurrX) <= 2) and (abs(g_MySelf.m_nCurrY-target.m_nCurrY) <= 2) and (not target.m_boDeath) then begin
         if g_boCanQTwnHit and (g_MySelf.m_Abil.MP >= 10) and (TargetInCanQTwnAttackRange(g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, Target.m_nCurrX, Target.m_nCurrY)) then begin  //小开天 20080223
            if CanNextAction and ServerAcceptNextAction and CanNextHit then begin
               g_boCanQTwnHit := FALSE;
               nHitMsg := CM_QTWINHIT;
               g_MySelf.SendMsg (nHitMsg, g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, tdir, 0, 0, '', 0);
               g_dwLatestHitTick := GetTickCount;
               g_dwLastAttackTick := GetTickCount;
            end;
         end else
         if g_boNextItemDAILYHit and (g_MySelf.m_Abil.MP >= 10) and (TargetInCanTwnAttackRange(g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, Target.m_nCurrX, Target.m_nCurrY)) then begin
            if CanNextAction and ServerAcceptNextAction and CanNextHit then begin
               g_boNextItemDAILYHit := FALSE;
               nHitMsg := CM_DAILY;
               g_MySelf.SendMsg (nHitMsg, g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, tdir, 0, 0, '', 0);
               g_dwLatestHitTick := GetTickCount;
               g_dwLastAttackTick := GetTickCount;
            end;
         end else g_ChrAction := caRun;//跑步砍
      end else
      if (abs(g_MySelf.m_nCurrX - target.m_nCurrX) <= 4) and (abs(g_MySelf.m_nCurrY-target.m_nCurrY) <= 4) and (not target.m_boDeath) then begin
         if g_boCanTwnHit and (g_MySelf.m_Abil.MP >= 10) and (TargetInCanTwnAttackRange(g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, Target.m_nCurrX, Target.m_nCurrY)) then begin  //大开天 20080223
            if CanNextAction and ServerAcceptNextAction and CanNextHit then begin
               g_boCanTwnHit := FALSE;
               nHitMsg := CM_TWINHIT;
               g_MySelf.SendMsg (nHitMsg, g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, tdir, 0, 0, '', 0);
               g_dwLatestHitTick := GetTickCount;
               g_dwLastAttackTick := GetTickCount;
            end;
         end else
         if g_boNextItemDAILYHit and (g_MySelf.m_Abil.MP >= 10) and (TargetInCanTwnAttackRange(g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, Target.m_nCurrX, Target.m_nCurrY)) then begin
            if CanNextAction and ServerAcceptNextAction and CanNextHit then begin
               g_boNextItemDAILYHit := FALSE;
               nHitMsg := CM_DAILY;
               g_MySelf.SendMsg (nHitMsg, g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, tdir, 0, 0, '', 0);
               g_dwLatestHitTick := GetTickCount;
               g_dwLastAttackTick := GetTickCount;
            end;
         end else g_ChrAction := caRun;//跑步砍
      end else g_ChrAction := caRun;//跑步砍
      GetBackPosition (target.m_nCurrX, target.m_nCurrY, tdir, dx, dy);
      g_nTargetX := dx;
      g_nTargetY := dy;
   end;

 (* nHitMsg := CM_HIT;
  if g_UseItems[U_WEAPON].S.StdMode = 6 then nHitMsg := CM_HEAVYHIT;

  tdir := GetNextDirection(g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, target.m_nCurrX, target.m_nCurrY);
  if (abs(g_MySelf.m_nCurrX - target.m_nCurrX) <= 1) and (abs(g_MySelf.m_nCurrY - target.m_nCurrY) <= 1) and (not target.m_boDeath) then begin
    if CanNextAction and ServerAcceptNextAction and CanNextHit then begin

      if g_boNextTimeFireHit and (g_MySelf.m_Abil.MP >= 7) then begin
        g_boNextTimeFireHit := FALSE;
        nHitMsg := CM_FIREHIT;
      end else
        if g_boNextTimePowerHit then begin //颇况 酒咆牢 版快, 抗档八过
        g_boNextTimePowerHit := FALSE;
        nHitMsg := CM_POWERHIT;
      end else
        if g_boCanTwnHit and (g_MySelf.m_Abil.MP >= 10) then begin
        g_boCanTwnHit := FALSE;
        nHitMsg := CM_TWINHIT;
      end else
        if g_boCanWideHit and (g_MySelf.m_Abil.MP >= 3) then begin //and (TargetInSwordWideAttackRange (tdir)) then begin  //氛 酒咆牢 版快, 馆岿八过
        nHitMsg := CM_WIDEHIT;
      end else
        if g_boCanCrsHit and (g_MySelf.m_Abil.MP >= 6) then begin
        nHitMsg := CM_CRSHIT;
      end else
        if g_boCanLongHit and (TargetInSwordLongAttackRange(tdir)) then begin //氛 酒咆牢 版快, 绢八贱
        nHitMsg := CM_LONGHIT;
      end;
      //if ((target.m_btRace <> RCC_USERHUMAN) and (target.m_btRace <> RCC_GUARD)) or (ssShift in Shift) then //荤恩阑 角荐肺 傍拜窍绰 巴阑 阜澜
      g_MySelf.SendMsg(nHitMsg, g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, tdir, 0, 0, '', 0);
      g_dwLatestHitTick := GetTickCount;
    end;
    g_dwLastAttackTick := GetTickCount;
  end else begin
    //厚档甫 甸绊 乐栏搁
    //if (UseItems[U_WEAPON].S.Shape = 6) and (target <> nil) then begin
    //   Myself.SendMsg (CM_THROW, Myself.XX, Myself.m_nCurrY, tdir, integer(target), 0, '', 0);
    //   TargetCret := nil;  //
    //end else begin
    if (abs(g_MySelf.m_nCurrX - target.m_nCurrX) <= 2) and (abs(g_MySelf.m_nCurrY - target.m_nCurrY) <= 2) and (not target.m_boDeath) then
      g_ChrAction := caWalk
    else g_ChrAction := caRun; //跑步砍
    GetBackPosition(target.m_nCurrX, target.m_nCurrY, tdir, dx, dy);
    g_nTargetX := dx;
    g_nTargetY := dy;
    //end;
  end;  *)
end;

procedure TfrmMain._DXDrawMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  tdir, nX, nY, nHitMsg, sel: Integer;
  target: TActor;
begin
  ActionKey := 0;
  g_nMouseX := X;
  g_nMouseY := Y;
  g_boAutoDig := FALSE;

  if (Button = mbRight) and g_boItemMoving then begin //是否当前在移动物品
    FrmDlg.CancelItemMoving;
    Exit;
  end;
  if g_DWinMan.MouseDown(Button, Shift, X, Y) then Exit; //鼠标移到窗口上了则跳过
  if (g_MySelf = nil) or (DScreen.CurrentScene <> PlayScene) then Exit; //如果人物退出则跳过

  if ssRight in Shift then begin //鼠标右键
    if Shift = [ssRight] then Inc(g_nDupSelection); //般闷阑 版快 急琶
    target := PlayScene.GetAttackFocusCharacter(X, Y, g_nDupSelection, sel, FALSE); //取指定坐标上的角色
    if g_nDupSelection <> sel then g_nDupSelection := 0;
    if target <> nil then begin
      if ssCtrl in Shift then begin //CTRL + 鼠标右键 = 显示角色的信息
        if GetTickCount - g_dwLastMoveTick > 1000 then begin
          if (target.m_btRace = 0) and (not target.m_boDeath) then begin
            //取得人物信息
            SendClientMessage(CM_QUERYUSERSTATE, target.m_nRecogId, target.m_nCurrX, target.m_nCurrY, 0);
            Exit;
          end;
        end;
      end;
    end else
      g_nDupSelection := 0;
    //按鼠标右键，并且鼠标指向空位置
    PlayScene.CXYfromMouseXY(X, Y, g_nMouseCurrX, g_nMouseCurrY);
    if (abs(g_MySelf.m_nCurrX - g_nMouseCurrX) <= 2) and (abs(g_MySelf.m_nCurrY - g_nMouseCurrY) <= 2) then begin //目标座标
      tdir := GetNextDirection(g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, g_nMouseCurrX, g_nMouseCurrY);
      if CanNextAction and ServerAcceptNextAction then begin
        g_MySelf.SendMsg(CM_TURN, g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, tdir, 0, 0, '', 0);
      end;
    end else begin //顿扁
      g_ChrAction := caRun;
      g_nTargetX := g_nMouseCurrX;
      g_nTargetY := g_nMouseCurrY;
      Exit;
    end;

    {
          if CanNextAction and ServerAcceptNextAction then begin
            //人物座标与目标座标之间是否小于2，小于则走操作
            if (abs(Myself.XX-MCX) <= 2) and (abs(Myself.m_nCurrY-MCY) <= 2) then begin
               ChrAction := caWalk;
            end else begin //跑操作
               ChrAction := caRun;
            end;
               TargetX := MCX;
               TargetY := MCY;
               exit;
          end;
     }
  end;

  if ssLeft in Shift {Button = mbLeft} then begin
    //傍拜... 承篮 裹困肺 急琶凳
    target := PlayScene.GetAttackFocusCharacter(X, Y, g_nDupSelection, sel, True); //混酒乐绰 仇父..
    PlayScene.CXYfromMouseXY(X, Y, g_nMouseCurrX, g_nMouseCurrY);
    g_TargetCret := nil;

    if (g_UseItems[U_WEAPON].S.name <> '') and (target = nil)
      //骑马状态不可以操作
    and (g_MySelf.m_btHorse = 0) then begin
      //挖矿
      if g_UseItems[U_WEAPON].S.Shape = 19 then begin //鹤嘴锄
        tdir := GetNextDirection(g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, g_nMouseCurrX, g_nMouseCurrY);
        GetFrontPosition(g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, tdir, nX, nY);
        if not Map.CanMove(nX, nY) or (ssShift in Shift) then begin //不能移动或强行挖矿
          if CanNextAction and ServerAcceptNextAction and CanNextHit then begin
            g_MySelf.SendMsg(CM_HIT + 1, g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, tdir, 0, 0, '', 0);
          end;
          g_boAutoDig := True;
          Exit;
        end;
      end;
    end;

    if (ssAlt in Shift)
      //骑马状态不可以操作
    and (g_MySelf.m_btHorse = 0) then begin
      //挖物品
      tdir := GetNextDirection(g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, g_nMouseCurrX, g_nMouseCurrY);
      if CanNextAction and ServerAcceptNextAction then begin
        target := PlayScene.ButchAnimal(g_nMouseCurrX, g_nMouseCurrY);
        if target <> nil then begin
          SendButchAnimal(g_nMouseCurrX, g_nMouseCurrY, tdir, target.m_nRecogId);
          g_MySelf.SendMsg(CM_SITDOWN, g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, tdir, 0, 0, '', 0); //磊技绰 鞍澜
          Exit;
        end;
        g_MySelf.SendMsg(CM_SITDOWN, g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, tdir, 0, 0, '', 0);
      end;
      g_nTargetX := -1;
    end else begin
      if (target <> nil) or (ssShift in Shift) then begin
        //哭率付快胶 努腐 肚绰 鸥百捞 乐澜.
        g_nTargetX := -1;
        if target <> nil then begin
          //鸥百捞 乐澜.

          //叭促啊 惑牢 皋春啊 唱坷绰 巴阑 规瘤.
          if GetTickCount - g_dwLastMoveTick > 1500 then begin
            //惑牢牢 版快,
            if target.m_btRace = RCC_MERCHANT then begin
              SendClientMessage(CM_CLICKNPC, target.m_nRecogId, 0, 0, 0);
              Exit;
            end;
          end;
          if (not target.m_boDeath)
            //骑马不允许操作
          and (g_MySelf.m_btHorse = 0) then begin
            g_TargetCret := target;
            if ((target.m_btRace <> RCC_USERHUMAN) and
              (target.m_btRace <> RCC_GUARD) and
              (target.m_btRace <> RCC_MERCHANT) and
              (pos('(', target.m_sUserName) = 0) //包括'('的角色名称为召唤的宝宝
              )
              or (ssShift in Shift) //SHIFT + 鼠标左键
            or (target.m_nNameColor = ENEMYCOLOR) //利篮 磊悼 傍拜捞 凳
            then begin
              AttackTarget(target);
              g_dwLatestHitTick := GetTickCount;
            end;
          end;
        end else begin
          //骑马不允许操作
          if (g_MySelf.m_btHorse = 0) then begin
            tdir := GetNextDirection(g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, g_nMouseCurrX, g_nMouseCurrY);
            if CanNextAction and ServerAcceptNextAction and CanNextHit then begin
              nHitMsg := CM_HIT + Random(3);
              if g_boCanLongHit and (TargetInSwordLongAttackRange(tdir)) then begin //是否可以使用刺杀
                nHitMsg := CM_LONGHIT;
              end;
              if g_boCanWideHit and (g_MySelf.m_Abil.MP >= 3) and (TargetInSwordWideAttackRange(tdir)) then begin //是否可以使用半月
                nHitMsg := CM_WIDEHIT;
              end;
              if g_boCanCrsHit and (g_MySelf.m_Abil.MP >= 6) and (TargetInSwordCrsAttackRange(tdir)) then begin //是否可以使用双龙斩
                nHitMsg := CM_CRSHIT;
              end;
              g_MySelf.SendMsg(nHitMsg, g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, tdir, 0, 0, '', 0);
            end;
            g_dwLastAttackTick := GetTickCount;
          end;
        end;
      end else begin
        //            if (MCX = Myself.XX) and (MCY = Myself.m_nCurrY) then begin
        if (g_nMouseCurrX = (g_MySelf.m_nCurrX)) and (g_nMouseCurrY = (g_MySelf.m_nCurrY)) then begin
          tdir := GetNextDirection(g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, g_nMouseCurrX, g_nMouseCurrY);
          if CanNextAction and ServerAcceptNextAction then begin
            SendPickup; //捡物品
          end;
        end else
          if GetTickCount - g_dwLastAttackTick > 1000 then begin //最后攻击操作停留指定时间才能移动
          if ssCtrl in Shift then begin
            g_ChrAction := caRun;
          end else begin
            g_ChrAction := caWalk;
          end;
          g_nTargetX := g_nMouseCurrX;
          g_nTargetY := g_nMouseCurrY;
        end;
      end;
    end;
  end;
end;

procedure TfrmMain.DXDrawDblClick(Sender: TObject);
var
  pt: TPoint;
begin
  GetCursorPos(pt);
  if g_DWinMan.DblClick(pt.X, pt.Y) then Exit;
end;

function TfrmMain.CheckDoorAction(dx, dy: Integer): Boolean;
var
  nX, nY, ndir, door: Integer;
begin
  Result := FALSE;
  //if not Map.CanMove (dx, dy) then begin
     //if (Abs(dx-Myself.XX) <= 2) and (Abs(dy-Myself.m_nCurrY) <= 2) then begin
  door := Map.GetDoor(dx, dy);
  if door > 0 then begin
    if not Map.IsDoorOpen(dx, dy) then begin
      SendClientMessage(CM_OPENDOOR, door, dx, dy, 0);
      Result := True;
    end;
  end;
  //end;
//end;
end;

procedure TfrmMain.DXDrawMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if g_DWinMan.MouseUp(Button, Shift, X, Y) then Exit;
  g_nTargetX := -1;
end;

procedure TfrmMain.DXDrawClick(Sender: TObject);
var
  pt: TPoint;
begin
  GetCursorPos(pt);
  if g_DWinMan.Click(pt.X, pt.Y) then Exit;
end;

procedure TfrmMain.MouseTimerTimer(Sender: TObject);
var
  i: Integer;
  pt: TPoint;
  keyvalue: TKeyBoardState;
  Shift: TShiftState;
begin
  GetCursorPos(pt);
  SetCursorPos(pt.X, pt.Y);
  if g_TargetCret <> nil then begin
    if ActionKey > 0 then begin
      ProcessKeyMessages;
    end else begin
      if not g_TargetCret.m_boDeath and PlayScene.IsValidActor(g_TargetCret) then begin
        FillChar(keyvalue, sizeof(TKeyBoardState), #0);
        if GetKeyboardState(keyvalue) then begin
          Shift := [];
          if ((keyvalue[VK_SHIFT] and $80) <> 0) then Shift := Shift + [ssShift];
          if ((g_TargetCret.m_btRace <> RCC_USERHUMAN) and
            (g_TargetCret.m_btRace <> RCC_GUARD) and
            (g_TargetCret.m_btRace <> RCC_MERCHANT) and
            (pos('(', g_TargetCret.m_sUserName) = 0) //林牢乐绰 各(碍力傍拜 秦具窃)
            )
            or (g_TargetCret.m_nNameColor = ENEMYCOLOR) //利篮 磊悼 傍拜捞 凳
          or ((ssShift in Shift) and (not PlayScene.EdChat.Visible)) then begin //荤恩阑 角荐肺 傍拜窍绰 巴阑 阜澜
            AttackTarget(g_TargetCret);
          end; //else begin
          //TargetCret := nil;
       //end
        end;
      end else
        g_TargetCret := nil;
    end;
  end;
  if g_boAutoDig then begin
    if CanNextAction and ServerAcceptNextAction and CanNextHit then begin
      g_MySelf.SendMsg(CM_HIT + 1, g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, g_MySelf.m_btDir, 0, 0, '', 0);
    end;
  end;

     //自动捡取
   if g_boAutoPuckUpItem and (g_MySelf <> nil) and ((GetTickCount() - g_dwAutoPickupTick) > 200) then begin
     g_dwAutoPickupTick:=GetTickCount();
     AutoPickUpItem();
   end;
   NearActor;
  // AutoEatItem;
  //动自捡取
 { if g_boAutoPuckUpItem and
    (g_MySelf <> nil) and
    ((GetTickCount() - g_dwAutoPickupTick) > g_dwAutoPickupTime) then begin
    g_dwAutoPickupTick := GetTickCount();
    AutoPickUpItem();
  end; }
    //持久力警告
  if ((GetTickCount - g_SHowWarningDura) > 1000 * 60) and g_boDuraWarning then begin
    for i := 13 downto 0 do begin
      if (g_UseItems[i].s.Name <> '') then begin
        if (i = 5) and (g_UseItems[5].s.StdMode = 25) then continue;
        if i = U_BUJUK then continue;
        if Round((g_UseItems[i].Dura / g_UseItems[i].DuraMax) * 100) < 30 then begin
          if (I = U_CHARM) and (g_UseItems[I].s.Shape in [1..3]) then  //气血石
            DScreen.AddChatBoardString('提示:您的['+g_UseItems[i].s.Name +']持久力低于30%,建议重新在商铺购买!',ClRed, ClWhite)
          else
            DScreen.AddChatBoardString('提示:您的['+g_UseItems[i].s.Name +']持久力低于30%,请及时进行修理!',ClRed, ClWhite);
        end;
      end;
    end;
   { for i := 13 downto 0 do begin
      if (g_HeroItems[i].s.Name <> '') then begin
        if i = U_BUJUK then continue;
        if Round((g_HeroItems[i].Dura / g_HeroItems[i].DuraMax) * 100) < 30 then begin
          if (I = U_CHARM) and (g_HeroItems[I].s.Shape in [1..3]) then  //气血石
            DScreen.AddChatBoardString('提示:英雄的['+g_HeroItems[i].s.Name +']持久力低于30%,建议重新在商铺购买!',ClRed, ClWhite)
          else
            DScreen.AddChatBoardString('提示:英雄的['+g_HeroItems[i].s.Name +']持久力低于30%,请及时进行修理!',ClRed, ClWhite);
        end;
      end;
    end;  }
    g_SHowWarningDura:= GetTickCount;
  end;
end;

procedure TfrmMain.AutoPickUpItem;    //
var
  I: Integer;
  DropItem:pTDropItem;
  ShowItem:pTShowItem;
begin
  if CanNextAction and ServerAcceptNextAction then begin
    if g_AutoPickupList = nil then Exit;
    g_AutoPickupList.Clear;
    PlayScene.GetXYDropItemsList(g_MySelf.m_nCurrX,g_MySelf.m_nCurrY,g_AutoPickupList);

    if g_AutoPickupList.Count > 0 then //20080629
    for I := 0 to g_AutoPickupList.Count - 1 do begin
      DropItem:=g_AutoPickupList.Items[I];
      if g_boAutoPuckUpItem then begin
        ShowItem:=GetShowItem(DropItem.Name);
        if g_boFilterAutoItemUp then begin
          if ((ShowItem = nil) or (ShowItem.boAutoPickup)) then begin
            if (DropItem <> nil) and (DropItem.Name<>'') then
            SendPickup;
          end else Exit;
        end else begin
          if (DropItem <> nil) and (DropItem.Name<>'') then
          SendPickup;
        end;
      end;
    end;
  end;
{var
  i: Integer;
  ItemList: TList;
  DropItem: pTDropItem;
  ShowItem: pTShowItem;
begin
  if CanNextAction and ServerAcceptNextAction then begin
    if g_AutoPickupList = nil then Exit;

    g_AutoPickupList.Clear;
    PlayScene.GetXYDropItemsList(g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, g_AutoPickupList);
    for i := 0 to g_AutoPickupList.count - 1 do begin
      DropItem := g_AutoPickupList.Items[i];
      ShowItem := GetShowItem(DropItem.name);
      if (ShowItem <> nil) and (ShowItem.boAutoPickup) then
        SendPickup;
    end;
  end;  }
end;

procedure TfrmMain.WaitMsgTimerTimer(Sender: TObject);
begin
  if g_MySelf = nil then Exit;
  if g_MySelf.ActionFinished then begin
    WaitMsgTimer.Enabled := FALSE;
    //      PlayScene.MemoLog.Lines.Add('WaitingMsg: ' + IntToStr(WaitingMsg.Ident));
    case WaitingMsg.ident of
      SM_CHANGEMAP: begin
          g_boMapMovingWait := FALSE;
          g_boMapMoving := FALSE;
          //
          if g_nMDlgX <> -1 then begin
            FrmDlg.CloseMDlg;
            g_nMDlgX := -1;
          end;
          ClearDropItems;
          PlayScene.CleanObjects;
          g_sMapTitle := '';
          g_MySelf.CleanCharMapSetting(WaitingMsg.param, WaitingMsg.tag);
          PlayScene.SendMsg(SM_CHANGEMAP, 0,
            WaitingMsg.param {x},
            WaitingMsg.tag {y},
            WaitingMsg.series {darkness},
            0, 0,
            WaitingStr {mapname});

          //DScreen.AddSysMsg (IntToStr(WaitingMsg.Param) + ' ' +
          //                   IntToStr(WaitingMsg.Tag) + ' : My ' +
          //                   IntToStr(Myself.XX) + ' ' +
          //                   IntToStr(Myself.m_nCurrY) + ' ' +
          //                   IntToStr(Myself.RX) + ' ' +
          //                   IntToStr(Myself.RY) + ' '
          //                  );
          g_nTargetX := -1;
          g_TargetCret := nil;
          g_FocusCret := nil;

        end;
    end;
  end;
end;

{----------------------- Socket -----------------------}

procedure TfrmMain.SelChrWaitTimerTimer(Sender: TObject);
begin
  SelChrWaitTimer.Enabled := FALSE;
  SendQueryChr;
end;

procedure TfrmMain.ActiveCmdTimer(cmd: TTimerCommand);
begin
  CmdTimer.Enabled := True;
  TimerCmd := cmd;
end;

procedure TfrmMain.CmdTimerTimer(Sender: TObject);
begin
  CmdTimer.Enabled := FALSE;
  CmdTimer.Interval := 2000;
  //   PlayScene.MemoLog.Lines.Add('CmdTimerTimer -' + IntToStr(Integer(TimerCmd)));
  case TimerCmd of
    tcSoftClose: begin
        //            PlayScene.MemoLog.Lines.Add('tcSoftClose');
        CmdTimer.Enabled := FALSE;
        CSocket.Socket.Close;
      end;
    tcReSelConnect: begin
        // try
//            PlayScene.MemoLog.Lines.Add('ConnectionStep -1');
         //霸烙 函荐 檬扁拳...
        ResetGameVariables;
        //            PlayScene.MemoLog.Lines.Add('ConnectionStep -2');
                    //
        DScreen.ChangeScene(stSelectChr);
        //            PlayScene.MemoLog.Lines.Add('ConnectionStep -3');
        g_ConnectionStep := cnsReSelChr;
        {
        except
          on e: Exception do
          PlayScene.MemoLog.Lines.Add(e.Message);
        end;
        }
//            if ConnectionStep = cnsReSelChr then
//              PlayScene.MemoLog.Lines.Add('ConnectionStep -cnsReSelChr');
        if not BoOneClick then begin
          //               PlayScene.MemoLog.Lines.Add('cnsReSelChr -' +  SelChrAddr + '/' + IntToStr(SelChrPort) );
          with CSocket do begin
            Active := FALSE;
            Address := g_sSelChrAddr;
            Port := g_nSelChrPort;
            Active := True;
          end;

        end else begin
          if CSocket.Socket.Connected then
            CSocket.Socket.SendText('$S' + g_sSelChrAddr + '/' + IntToStr(g_nSelChrPort) + '%');
          CmdTimer.Interval := 1;
          ActiveCmdTimer(tcFastQueryChr);
        end;
      end;
    tcFastQueryChr: begin
        SendQueryChr;
      end;
  end;
end;

procedure TfrmMain.CloseAllWindows;
begin
  with FrmDlg do begin
    DItemBag.Visible := FALSE;
    DMsgDlg.Visible := FALSE;
    DStateWin.Visible := FALSE;
    DMerchantDlg.Visible := FALSE;
    DSellDlg.Visible := FALSE;
    DMenuDlg.Visible := FALSE;
    DKeySelDlg.Visible := FALSE;
    DGroupDlg.Visible := FALSE;
    DDealDlg.Visible := FALSE;
    DDealRemoteDlg.Visible := FALSE;
    DGuildDlg.Visible := FALSE;
    DGuildEditNotice.Visible := FALSE;
    DUserState1.Visible := FALSE;
    DAdjustAbility.Visible := FALSE;
    DShop.Visible := FALSE;
  end;
  if g_nMDlgX <> -1 then begin
    FrmDlg.CloseMDlg;
    g_nMDlgX := -1;
  end;
  g_boItemMoving := FALSE;
end;

procedure TfrmMain.ClearDropItems;
var
  i: Integer;
begin
  for i := 0 to g_DropedItemList.count - 1 do begin
    Dispose(pTDropItem(g_DropedItemList[i]));
  end;
  g_DropedItemList.Clear;
end;

procedure TfrmMain.ResetGameVariables;
var
  i: Integer;
  ClientMagic: PTClientMagic;
begin
  try
    CloseAllWindows;
    ClearDropItems;

    for i := 0 to g_MagicList.count - 1 do begin
      Dispose(PTClientMagic(g_MagicList[i]));
    end;
    g_MagicList.Clear;
    g_boItemMoving := FALSE;
    g_WaitingUseItem.Item.S.name := '';
    g_EatingItem.S.name := '';
    g_nTargetX := -1;
    g_TargetCret := nil;
    g_FocusCret := nil;
    g_MagicTarget := nil;
    ActionLock := FALSE;
    g_GroupMembers.Clear;
    g_sGuildRankName := '';
    g_sGuildName := '';

    g_boMapMoving := FALSE;
    WaitMsgTimer.Enabled := FALSE;
    g_boMapMovingWait := FALSE;
    DScreen.ChatBoardTop := 0;
    g_boNextTimePowerHit := FALSE;
    g_boCanLongHit := FALSE;
    g_boCanWideHit := FALSE;
    g_boCanCrsHit := FALSE;
    g_boCanTwnHit := FALSE;

    g_boNextTimeFireHit := FALSE;

    FillChar(g_UseItems, sizeof(TClientItem) * 9, #0);
    FillChar(g_ItemArr, sizeof(TClientItem) * MAXBAGITEMCL, #0);

    with SelectChrScene do begin
      FillChar(ChrArr, sizeof(TSelChar) * 2, #0);
      ChrArr[0].FreezeState := True; //扁夯捞 倔绢 乐绰 惑怕
      ChrArr[1].FreezeState := True;
    end;
    PlayScene.ClearActors;
    ClearDropItems;
    EventMan.ClearEvents;
    PlayScene.CleanObjects;
    //DxDrawRestoreSurface (self);
    g_MySelf := nil;

  except
    //  on e: Exception do
    //    PlayScene.MemoLog.Lines.Add(e.Message);
  end;
end;

procedure TfrmMain.ChangeServerClearGameVariables;
var
  i: Integer;
begin
  CloseAllWindows;
  ClearDropItems;
  for i := 0 to g_MagicList.count - 1 do
    Dispose(PTClientMagic(g_MagicList[i]));
  g_MagicList.Clear;
  g_boItemMoving := FALSE;
  g_WaitingUseItem.Item.S.name := '';
  g_EatingItem.S.name := '';
  g_nTargetX := -1;
  g_TargetCret := nil;
  g_FocusCret := nil;
  g_MagicTarget := nil;
  ActionLock := FALSE;
  g_GroupMembers.Clear;
  g_sGuildRankName := '';
  g_sGuildName := '';

  g_boMapMoving := FALSE;
  WaitMsgTimer.Enabled := FALSE;
  g_boMapMovingWait := FALSE;
  g_boNextTimePowerHit := FALSE;
  g_boCanLongHit := FALSE;
  g_boCanWideHit := FALSE;
  g_boCanCrsHit := FALSE;
  g_boCanTwnHit := FALSE;

  ClearDropItems;
  EventMan.ClearEvents;
  PlayScene.CleanObjects;
end;

procedure TfrmMain.CSocketConnect(Sender: TObject;
  Socket: TCustomWinSocket);
var
  packet: array[0..255] of Char;
  strbuf: array[0..255] of Char;
  str: string;
begin
  g_boServerConnected := True;
  if g_ConnectionStep = cnsLogin then begin
    if OneClickMode = toKornetWorld then begin //内齿岿靛甫 版蜡秦辑 霸烙俊 立加
      FillChar(packet, 256, #0);
      str := 'KwGwMGS'; StrPCopy(strbuf, str); Move(strbuf, (@packet[0])^, Length(str));
      str := 'CONNECT'; StrPCopy(strbuf, str); Move(strbuf, (@packet[8])^, Length(str));
      str := KornetWorld.CPIPcode; StrPCopy(strbuf, str); Move(strbuf, (@packet[16])^, Length(str));
      str := KornetWorld.SVCcode; StrPCopy(strbuf, str); Move(strbuf, (@packet[32])^, Length(str));
      str := KornetWorld.LoginID; StrPCopy(strbuf, str); Move(strbuf, (@packet[48])^, Length(str));
      str := KornetWorld.CheckSum; StrPCopy(strbuf, str); Move(strbuf, (@packet[64])^, Length(str));
      Socket.SendBuf(packet, 256);
    end;
    DScreen.ChangeScene(stLogin);
{$IF USECURSOR = DEFAULTCURSOR}
    DXDraw.Cursor := crDefault;
{$IFEND}
  end;
  if g_ConnectionStep = cnsSelChr then begin
    LoginScene.OpenLoginDoor;
    SelChrWaitTimer.Enabled := True;
  end;
  if g_ConnectionStep = cnsReSelChr then begin
    CmdTimer.Interval := 1;
    ActiveCmdTimer(tcFastQueryChr);
  end;
  if g_ConnectionStep = cnsPlay then begin
    if not g_boServerChanging then begin
      ClearBag; //啊规 檬扁拳
      DScreen.ClearChatBoard; //盲泼芒 檬扁拳
      DScreen.ChangeScene(stLoginNotice);
    end else begin
      ChangeServerClearGameVariables;
    end;
    SendRunLogin;
  end;
  SocStr := '';
  BufferStr := '';
end;

procedure TfrmMain.CSocketDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  g_boServerConnected := FALSE;
  if (g_ConnectionStep = cnsLogin) and not g_boSendLogin then begin
    FrmDlg.DMessageDlg('连接已经关闭...', [mbOk]);
    Close;
  end;
  if g_SoftClosed then begin
    g_SoftClosed := FALSE;
    ActiveCmdTimer(tcReSelConnect);
  end;
end;

procedure TfrmMain.CSocketError(Sender: TObject; Socket: TCustomWinSocket;
  ErrorEvent: TErrorEvent; var ErrorCode: Integer);
begin
  ErrorCode := 0;
  Socket.Close;
end;

procedure TfrmMain.CSocketRead(Sender: TObject; Socket: TCustomWinSocket);
var
  n: Integer;
  data, data2: string;
begin
  data := Socket.ReceiveText;
  //if pos('GOOD', data) > 0 then DScreen.AddSysMsg (data);

  n := pos('*', data);
  if n > 0 then begin
    data2 := Copy(data, 1, n - 1);
    data := data2 + Copy(data, n + 1, Length(data));
    //SendSocket ('*');
    CSocket.Socket.SendText('*');
  end;
  SocStr := SocStr + data;
end;

{-------------------------------------------------------------}

procedure TfrmMain.SendSocket(sendstr: string);
const
  Code: byte = 1;
var
  sSendText: string;
begin
  if CSocket.Socket.Connected then begin
    CSocket.Socket.SendText('#' + IntToStr(Code) + sendstr + '!');
    Inc(Code);
    if Code >= 10 then Code := 1;
  end;
end;

procedure TfrmMain.SendClientMessage(Msg, Recog, param, tag, series: Integer);
var
  dmsg: TDefaultMessage;
begin
  dmsg := MakeDefaultMsg(Msg, Recog, param, tag, series);
  SendSocket(EncodeMessage(dmsg));
end;

procedure TfrmMain.SendLogin(uid, passwd: string);
var
  Msg: TDefaultMessage;
begin
  LoginID := uid;
  LoginPasswd := passwd;
  Msg := MakeDefaultMsg(CM_IDPASSWORD, 0, 0, 0, 0);
  SendSocket(EncodeMessage(Msg) + EncodeString(uid + '/' + passwd));
  g_boSendLogin := True; //发送登录消息
end;

procedure TfrmMain.SendNewAccount(ue: TUserEntry; ua: TUserEntryAdd);
var
  Msg: TDefaultMessage;
begin
  MakeNewId := ue.sAccount;
  Msg := MakeDefaultMsg(CM_ADDNEWUSER, 0, 0, 0, 0);
  SendSocket(EncodeMessage(Msg) + EncodeBuffer(@ue, sizeof(TUserEntry)) + EncodeBuffer(@ua, sizeof(TUserEntryAdd)));
end;

procedure TfrmMain.SendUpdateAccount(ue: TUserEntry; ua: TUserEntryAdd);
var
  Msg: TDefaultMessage;
begin
  MakeNewId := ue.sAccount;
  Msg := MakeDefaultMsg(CM_UPDATEUSER, 0, 0, 0, 0);
  SendSocket(EncodeMessage(Msg) + EncodeBuffer(@ue, sizeof(TUserEntry)) + EncodeBuffer(@ua, sizeof(TUserEntryAdd)));
end;

procedure TfrmMain.SendSelectServer(svname: string);
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_SELECTSERVER, 0, 0, 0, 0);
  SendSocket(EncodeMessage(Msg) + EncodeString(svname));
end;

procedure TfrmMain.SendChgPw(id, passwd, newpasswd: string);
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_CHANGEPASSWORD, 0, 0, 0, 0);
  SendSocket(EncodeMessage(Msg) + EncodeString(id + #9 + passwd + #9 + newpasswd));
end;

procedure TfrmMain.SendNewChr(uid, uname, shair, sjob, ssex: string);
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_NEWCHR, 0, 0, 0, 0);
  SendSocket(EncodeMessage(Msg) + EncodeString(uid + '/' + uname + '/' + shair + '/' + sjob + '/' + ssex));
end;

procedure TfrmMain.SendQueryChr;
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_QUERYCHR, 0, 0, 0, 0);
  SendSocket(EncodeMessage(Msg) + EncodeString(LoginID + '/' + IntToStr(Certification)));
end;

procedure TfrmMain.SendDelChr(chrname: string);
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_DELCHR, 0, 0, 0, 0);
  SendSocket(EncodeMessage(Msg) + EncodeString(chrname));
end;

procedure TfrmMain.SendSelChr(chrname: string);
var
  Msg: TDefaultMessage;
begin
  CharName := chrname;
  Msg := MakeDefaultMsg(CM_SELCHR, 0, 0, 0, 0);
  SendSocket(EncodeMessage(Msg) + EncodeString(LoginID + '/' + chrname));
  PlayScene.EdAccountt.Visible := FALSE; //2004/05/17
  PlayScene.EdChrNamet.Visible := FALSE; //2004/05/17
end;

procedure TfrmMain.SendRunLogin;
var
  Msg: TDefaultMessage;
  str: string;
  sSendMsg: string;
begin
  sSendMsg := format('**%s/%s/%d/%d/%d', [LoginID, CharName, Certification, CLIENT_VERSION_NUMBER, RUNLOGINCODE]);
  SendSocket(EncodeString(sSendMsg));
end;

procedure TfrmMain.SendSay(str: string);
var
  Msg: TDefaultMessage;
begin
  if str <> '' then begin
    if m_boPasswordIntputStatus then begin
      m_boPasswordIntputStatus := FALSE;
      PlayScene.EdChat.PasswordChar := #0;
      PlayScene.EdChat.Visible := FALSE;
      SendPassword(str, 1);
      Exit;
    end;
    if CompareLstr(str, '/cmd', Length('/cmd')) then begin
      ProcessCommand(str);
      Exit;
    end;
    if str = '/debug' then begin
      boOutbugStr := not boOutbugStr;
      Exit;
    end;
    if str = '/debug check' then begin
      g_boShowMemoLog := not g_boShowMemoLog;
      PlayScene.MemoLog.Clear;
      PlayScene.MemoLog.Visible := g_boShowMemoLog;
      Exit;
    end;
    if str = '/debug powerblock' then begin
      SendPowerBlock();
      Exit;
    end;
    if str = '/debug screen' then begin
      g_boCheckBadMapMode := not g_boCheckBadMapMode;
      if g_boCheckBadMapMode then DScreen.AddSysMsg('On',0 , 30, 40, clGreen)
      else DScreen.AddSysMsg('Off',0 , 30, 40, clGreen); //是否显示相关检查地图信息(用于调试)
      Exit;
    end;
    if str = '/check speedhack' then begin
      g_boCheckSpeedHackDisplay := not g_boCheckSpeedHackDisplay;
      Exit; //是否显示机器速度
    end;
    if str = '/hungry' then begin
      Inc(g_nMyHungryState); //饥饿状态
      if g_nMyHungryState > 4 then g_nMyHungryState := 1;

      Exit;
    end;
    if str = '/hint screen' then begin
      g_boShowGreenHint := not g_boShowGreenHint;
      g_boShowWhiteHint := not g_boShowWhiteHint;
      Exit;
    end;

    if str = '@password' then begin
      if PlayScene.EdChat.PasswordChar = #0 then
        PlayScene.EdChat.PasswordChar := '*'
      else PlayScene.EdChat.PasswordChar := #0;
      Exit;
    end;
    if PlayScene.EdChat.PasswordChar = '*' then
      PlayScene.EdChat.PasswordChar := #0;

    Msg := MakeDefaultMsg(CM_SAY, 0, 0, 0, 0);
    SendSocket(EncodeMessage(Msg) + EncodeString(str));
    if str[1] = '/' then begin
      DScreen.AddChatBoardString(str, GetRGB(180), clWhite);
      GetValidStr3(Copy(str, 2, Length(str) - 1), WhisperName, [' ']);
    end;
  end;
end;

procedure TfrmMain.SendActMsg(ident, X, Y, dir: Integer);
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(ident, MakeLong(X, Y), 0, dir, 0);
  SendSocket(EncodeMessage(Msg));
  ActionLock := True; //辑滚俊辑 #+FAIL! 捞唱 #+GOOD!捞 棵锭鳖瘤 扁促覆
  ActionLockTime := GetTickCount;
  Inc(g_nSendCount);
end;

procedure TfrmMain.SendSpellMsg(ident, X, Y, dir, target: Integer);
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(ident, MakeLong(X, Y), Loword(target), dir, Hiword(target));
  SendSocket(EncodeMessage(Msg));
  ActionLock := True; //辑滚俊辑 #+FAIL! 捞唱 #+GOOD!捞 棵锭鳖瘤 扁促覆
  ActionLockTime := GetTickCount;
  Inc(g_nSendCount);
end;

procedure TfrmMain.SendQueryUserName(targetid, X, Y: Integer);
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_QUERYUSERNAME, targetid, X, Y, 0);
  SendSocket(EncodeMessage(Msg));
end;

procedure TfrmMain.SendDropItem(name: string; itemserverindex: Integer);
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_DROPITEM, itemserverindex, 0, 0, 0);
  SendSocket(EncodeMessage(Msg) + EncodeString(name));
end;

procedure TfrmMain.SendPickup;
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_PICKUP, 0, g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, 0);
  SendSocket(EncodeMessage(Msg));
end;

procedure TfrmMain.SendTakeOnItem(where: byte; itmindex: Integer; itmname: string);
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_TAKEONITEM, itmindex, where, 0, 0);
  SendSocket(EncodeMessage(Msg) + EncodeString(itmname));
end;

procedure TfrmMain.SendTakeOffItem(where: byte; itmindex: Integer; itmname: string);
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_TAKEOFFITEM, itmindex, where, 0, 0);
  SendSocket(EncodeMessage(Msg) + EncodeString(itmname));
end;

//吃东西
procedure TfrmMain.SendEat(itmindex: Integer; itmname: string);
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_EAT, itmindex, 0, 0, 0);
  SendSocket(EncodeMessage(Msg) + EncodeString(itmname));
end;

//宰杀动物
procedure TfrmMain.SendButchAnimal(X, Y, dir, actorid: Integer);
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_BUTCH, actorid, X, Y, dir);
  SendSocket(EncodeMessage(Msg));
end;

procedure TfrmMain.SendMagicKeyChange(magid: Integer; keych: Char);
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_MAGICKEYCHANGE, magid, byte(keych), 0, 0);
  SendSocket(EncodeMessage(Msg));
end;

procedure TfrmMain.SendMerchantDlgSelect(merchant: Integer; rstr: string);
var
  Msg: TDefaultMessage;
  param: string;
begin
  if Length(rstr) >= 2 then begin //颇扼皋鸥啊 鞘夸茄 版快啊 乐澜.
    if (rstr[1] = '@') and (rstr[2] = '@') then begin
      if rstr = '@@buildguildnow' then
        FrmDlg.DMessageDlg('请输入行会名称.', [mbOk, mbAbort])
      else FrmDlg.DMessageDlg('输入信息.', [mbOk, mbAbort]);
      param := Trim(FrmDlg.DlgEditText);
      rstr := rstr + #13 + param;
    end;
  end;
  Msg := MakeDefaultMsg(CM_MERCHANTDLGSELECT, merchant, 0, 0, 0);
  SendSocket(EncodeMessage(Msg) + EncodeString(rstr));
end;

//询问物品价格
procedure TfrmMain.SendQueryPrice(merchant, itemindex: Integer; itemname: string);
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_MERCHANTQUERYSELLPRICE, merchant, Loword(itemindex), Hiword(itemindex), 0);
  SendSocket(EncodeMessage(Msg) + EncodeString(itemname));
end;
//询问修理价格
procedure TfrmMain.SendQueryRepairCost(merchant, itemindex: Integer; itemname: string);
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_MERCHANTQUERYREPAIRCOST, merchant, Loword(itemindex), Hiword(itemindex), 0);
  SendSocket(EncodeMessage(Msg) + EncodeString(itemname));
end;

//发送要出售的物品
procedure TfrmMain.SendSellItem(merchant, itemindex: Integer; itemname: string);
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_USERSELLITEM, merchant, Loword(itemindex), Hiword(itemindex), 0);
  SendSocket(EncodeMessage(Msg) + EncodeString(itemname));
end;
//发送要修理的物品
procedure TfrmMain.SendRepairItem(merchant, itemindex: Integer; itemname: string);
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_USERREPAIRITEM, merchant, Loword(itemindex), Hiword(itemindex), 0);
  SendSocket(EncodeMessage(Msg) + EncodeString(itemname));
end;
//发送要存放的物品
procedure TfrmMain.SendStorageItem(merchant, itemindex: Integer; itemname: string);
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_USERSTORAGEITEM, merchant, Loword(itemindex), Hiword(itemindex), 0);
  SendSocket(EncodeMessage(Msg) + EncodeString(itemname));
end;

procedure TfrmMain.SendGetDetailItem(merchant, menuindex: Integer; itemname: string);
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_USERGETDETAILITEM, merchant, menuindex, 0, 0);
  SendSocket(EncodeMessage(Msg) + EncodeString(itemname));
end;

procedure TfrmMain.SendBuyItem(merchant, itemserverindex: Integer; itemname: string);
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_USERBUYITEM, merchant, Loword(itemserverindex), Hiword(itemserverindex), 0);
  SendSocket(EncodeMessage(Msg) + EncodeString(itemname));
end;

procedure TfrmMain.SendTakeBackStorageItem(merchant, itemserverindex: Integer; itemname: string);
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_USERTAKEBACKSTORAGEITEM, merchant, Loword(itemserverindex), Hiword(itemserverindex), 0);
  SendSocket(EncodeMessage(Msg) + EncodeString(itemname));
end;

procedure TfrmMain.SendMakeDrugItem(merchant: Integer; itemname: string);
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_USERMAKEDRUGITEM, merchant, 0, 0, 0);
  SendSocket(EncodeMessage(Msg) + EncodeString(itemname));
end;

procedure TfrmMain.SendDropGold(dropgold: Integer);
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_DROPGOLD, dropgold, 0, 0, 0);
  SendSocket(EncodeMessage(Msg));
end;

procedure TfrmMain.SendGroupMode(onoff: Boolean);
var
  Msg: TDefaultMessage;
begin
  if onoff then
    Msg := MakeDefaultMsg(CM_GROUPMODE, 0, 1, 0, 0) //on
  else Msg := MakeDefaultMsg(CM_GROUPMODE, 0, 0, 0, 0); //off
  SendSocket(EncodeMessage(Msg));
end;

procedure TfrmMain.SendCreateGroup(withwho: string);
var
  Msg: TDefaultMessage;
begin
  if withwho <> '' then begin
    Msg := MakeDefaultMsg(CM_CREATEGROUP, 0, 0, 0, 0);
    SendSocket(EncodeMessage(Msg) + EncodeString(withwho));
  end;
end;

procedure TfrmMain.SendWantMiniMap;
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_WANTMINIMAP, 0, 0, 0, 0);
  SendSocket(EncodeMessage(Msg));
end;

procedure TfrmMain.SendDealTry;
var
  Msg: TDefaultMessage;
  i, fx, fy: Integer;
  Actor: TActor;
  who: string;
  proper: Boolean;
begin
  (*proper := FALSE;
  GetFrontPosition (Myself.XX, Myself.m_nCurrY, Myself.Dir, fx, fy);
  with PlayScene do
     for i:=0 to ActorList.Count-1 do begin
        actor := TActor (ActorList[i]);
        if {(actor.m_btRace = 0) and} (actor.XX = fx) and (actor.m_nCurrY = fy) then begin
           proper := TRUE;
           who := actor.UserName;
           break;
        end;
     end;
  if proper then begin*)
  Msg := MakeDefaultMsg(CM_DEALTRY, 0, 0, 0, 0);
  SendSocket(EncodeMessage(Msg) + EncodeString(who));
  //end;
end;

procedure TfrmMain.SendGuildDlg;
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_OPENGUILDDLG, 0, 0, 0, 0);
  SendSocket(EncodeMessage(Msg));
end;

procedure TfrmMain.SendShopDlg(wPage,idxe: Word);
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_OPENSHOP, Integer(g_MySelf), wPage, idxe, 0);
  SendSocket(EncodeMessage(Msg));
end;

procedure TfrmMain.SendBuyShopItem(sItems: string; btType: byte);
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_BUYSHOPITEM, Integer(g_MySelf), 0, 0, btType);
  SendSocket(EncodeMessage(Msg) + EncodeString(sItems));
end;

procedure TfrmMain.SendCancelDeal;
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_DEALCANCEL, 0, 0, 0, 0);
  SendSocket(EncodeMessage(Msg));
end;

procedure TfrmMain.SendAddDealItem(ci: TClientItem);
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_DEALADDITEM, ci.MakeIndex, 0, 0, 0);
  SendSocket(EncodeMessage(Msg) + EncodeString(ci.S.name));
end;

procedure TfrmMain.SendDelDealItem(ci: TClientItem);
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_DEALDELITEM, ci.MakeIndex, 0, 0, 0);
  SendSocket(EncodeMessage(Msg) + EncodeString(ci.S.name));
end;

procedure TfrmMain.SendChangeDealGold(gold: Integer);
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_DEALCHGGOLD, gold, 0, 0, 0);
  SendSocket(EncodeMessage(Msg));
end;

procedure TfrmMain.SendDealEnd;
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_DEALEND, 0, 0, 0, 0);
  SendSocket(EncodeMessage(Msg));
end;

procedure TfrmMain.SendAddGroupMember(withwho: string);
var
  Msg: TDefaultMessage;
begin
  if withwho <> '' then begin
    Msg := MakeDefaultMsg(CM_ADDGROUPMEMBER, 0, 0, 0, 0);
    SendSocket(EncodeMessage(Msg) + EncodeString(withwho));
  end;
end;

procedure TfrmMain.SendDelGroupMember(withwho: string);
var
  Msg: TDefaultMessage;
begin
  if withwho <> '' then begin
    Msg := MakeDefaultMsg(CM_DELGROUPMEMBER, 0, 0, 0, 0);
    SendSocket(EncodeMessage(Msg) + EncodeString(withwho));
  end;
end;

procedure TfrmMain.SendGuildHome;
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_GUILDHOME, 0, 0, 0, 0);
  SendSocket(EncodeMessage(Msg));
end;

procedure TfrmMain.SendGuildMemberList;
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_GUILDMEMBERLIST, 0, 0, 0, 0);
  SendSocket(EncodeMessage(Msg));
end;

procedure TfrmMain.SendGuildAddMem(who: string);
var
  Msg: TDefaultMessage;
begin
  if Trim(who) <> '' then begin
    Msg := MakeDefaultMsg(CM_GUILDADDMEMBER, 0, 0, 0, 0);
    SendSocket(EncodeMessage(Msg) + EncodeString(who));
  end;
end;

procedure TfrmMain.SendGuildDelMem(who: string);
var
  Msg: TDefaultMessage;
begin
  if Trim(who) <> '' then begin
    Msg := MakeDefaultMsg(CM_GUILDDELMEMBER, 0, 0, 0, 0);
    SendSocket(EncodeMessage(Msg) + EncodeString(who));
  end;
end;

procedure TfrmMain.SendGuildUpdateNotice(notices: string);
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_GUILDUPDATENOTICE, 0, 0, 0, 0);
  SendSocket(EncodeMessage(Msg) + EncodeString(notices));
end;

procedure TfrmMain.SendGuildUpdateGrade(rankinfo: string);
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_GUILDUPDATERANKINFO, 0, 0, 0, 0);
  SendSocket(EncodeMessage(Msg) + EncodeString(rankinfo));
end;

procedure TfrmMain.SendSpeedHackUser;
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_SPEEDHACKUSER, 0, 0, 0, 0);
  SendSocket(EncodeMessage(Msg));
end;

procedure TfrmMain.SendAdjustBonus(remain: Integer; babil: TNakedAbility);
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_ADJUST_BONUS, remain, 0, 0, 0);
  SendSocket(EncodeMessage(Msg) + EncodeBuffer(@babil, sizeof(TNakedAbility)));
end;

procedure TfrmMain.SendPowerBlock();
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_POWERBLOCK, 0, 0, 0, 0);
  SendSocket(EncodeMessage(Msg) + EncodeBuffer(@g_PowerBlock, sizeof(TPowerBlock)));
end;
{---------------------------------------------------------------}


function TfrmMain.ServerAcceptNextAction: Boolean;
begin
  Result := True;
  //若服务器未响应动作命令，则10秒后自动解锁
  if ActionLock then begin
    if GetTickCount - ActionLockTime > 10 * 1000 then begin
      ActionLock := FALSE;
      //Dec (WarningLevel);
    end;
    Result := FALSE;
  end;
end;

function TfrmMain.CanNextAction: Boolean;
begin
  if (g_MySelf.IsIdle) and
    (g_MySelf.m_nState and $04000000 = 0) and
    (GetTickCount - g_dwDizzyDelayStart > g_dwDizzyDelayTime)
    then begin
    Result := True;
  end else
    Result := FALSE;
end;
//是否可以攻击，控制攻击速度
function TfrmMain.CanNextHit: Boolean;
var
  NextHitTime, LevelFastTime: Integer;
begin
  LevelFastTime := _MIN(370, (g_MySelf.m_Abil.Level * 14));
  LevelFastTime := _MIN(800, LevelFastTime + g_MySelf.m_nHitSpeed * 60);

  if g_boAttackSlow then
    NextHitTime := 1400 - LevelFastTime + 1500 //腕力超过时，减慢攻击速度
  else NextHitTime := 1400 - LevelFastTime;

  if NextHitTime < 0 then NextHitTime := 0;

  if GetTickCount - LastHitTick > LongWord(NextHitTime) then begin
    LastHitTick := GetTickCount;
    Result := True;
  end else Result := FALSE;
end;

procedure TfrmMain.ActionFailed;
begin
  g_nTargetX := -1;
  g_nTargetY := -1;
  ActionFailLock := True; //鞍篮 规氢栏肺 楷加捞悼角菩甫 阜扁困秦辑, FailDir苞 窃膊 荤侩
  ActionFailLockTime := GetTickCount(); //Jacky
  g_MySelf.MoveFail;
end;

function TfrmMain.IsUnLockAction(Action, adir: Integer): Boolean;
begin
  if ActionFailLock then begin //如果操作被锁定，则在指定时间后解锁
    if GetTickCount() - ActionFailLockTime > 1000 then ActionFailLock := FALSE;
  end;
  if (ActionFailLock) or (g_boMapMoving) or (g_boServerChanging) then begin
    Result := FALSE;
  end else Result := True;

  {
     if (ActionFailLock and (action = FailAction) and (adir = FailDir))
        or (MapMoving)
        or (BoServerChanging) then begin
        Result := FALSE;
     end else begin
        ActionFailLock := FALSE;
        Result := TRUE;
     end;
  }
end;

function TfrmMain.IsGroupMember(uname: string): Boolean;
var
  i: Integer;
begin
  Result := FALSE;
  for i := 0 to g_GroupMembers.count - 1 do
    if g_GroupMembers[i] = uname then begin
      Result := True;
      break;
    end;
end;

{-------------------------------------------------------------}

procedure TfrmMain.Timer1Timer(Sender: TObject);
var
  str, data: string;
  len, i, n, mcnt: Integer;
const
  busy: Boolean = FALSE;
begin
  if busy then Exit;
  //if ServerConnected then
  //   DxTimer.Enabled := TRUE
  //else
  //   DxTimer.Enabled := FALSE;
  busy := True;
  try
    BufferStr := BufferStr + SocStr;
    SocStr := '';
    if BufferStr <> '' then begin
      mcnt := 0;
      while Length(BufferStr) >= 2 do begin
        if g_boMapMovingWait then break; // 措扁..
        if pos('!', BufferStr) <= 0 then break;
        BufferStr := ArrestStringEx(BufferStr, '#', '!', data);
        if data = '' then break;
        DecodeMessagePacket(data);
        if pos('!', BufferStr) <= 0 then break;
      end;
    end;
  finally
    busy := FALSE;
  end;

  if WarningLevel > 30 then
    frmMain.Close;

  if g_boQueryPrice then begin
    if GetTickCount - g_dwQueryPriceTime > 500 then begin
      g_boQueryPrice := FALSE;
      case FrmDlg.SpotDlgMode of
        dmSell: SendQueryPrice(g_nCurMerchant, g_SellDlgItem.MakeIndex, g_SellDlgItem.S.name);
        dmRepair: SendQueryRepairCost(g_nCurMerchant, g_SellDlgItem.MakeIndex, g_SellDlgItem.S.name);
      end;
    end;
  end;

  if g_nBonusPoint > 0 then begin
    FrmDlg.DBotPlusAbil.Visible := True;
  end else begin
    FrmDlg.DBotPlusAbil.Visible := FALSE;
  end;
end;

procedure TfrmMain.SpeedHackTimerTimer(Sender: TObject);
var
  gcount, timer: LongWord;
  ahour, amin, asec, amsec: Word;
begin
  DecodeTime(Time, ahour, amin, asec, amsec);
  timer := ahour * 1000 * 60 * 60 + amin * 1000 * 60 + asec * 1000 + amsec;
  gcount := GetTickCount;
  if g_dwSHGetTime > 0 then begin
    if abs((gcount - g_dwSHGetTime) - (timer - g_dwSHTimerTime)) > 70 then begin
      Inc(g_nSHFakeCount);
    end else
      g_nSHFakeCount := 0;
    if g_nSHFakeCount > 4 then begin
      FrmDlg.DMessageDlg('网络出现不稳定情况，游戏已被中止。 CODE=10001\' +
        '如有问题请联系游戏管理员。',
        [mbOk]);
      frmMain.Close;
    end;
    if g_boCheckSpeedHackDisplay then begin
      DScreen.AddSysMsg('->' + IntToStr(gcount - g_dwSHGetTime) + ' - ' +
        IntToStr(timer - g_dwSHTimerTime) + ' = ' +
        IntToStr(abs((gcount - g_dwSHGetTime) - (timer - g_dwSHTimerTime))) + ' (' +
        IntToStr(g_nSHFakeCount) + ')',0 , 30, 40, clGreen);
    end;
  end;
  g_dwSHGetTime := gcount;
  g_dwSHTimerTime := timer;
end;

procedure TfrmMain.CheckSpeedHack(rtime: LongWord);
var
  cltime, svtime: Integer;
  str: string;
begin
  if g_dwFirstServerTime > 0 then begin
    if (GetTickCount - g_dwFirstClientTime) > 1 * 60 * 60 * 1000 then begin //1矫埃 付促 檬扁拳
      g_dwFirstServerTime := rtime; //檬扁拳
      g_dwFirstClientTime := GetTickCount;
      //ServerTimeGap := rtime - int64(GetTickCount);
    end;
    cltime := GetTickCount - g_dwFirstClientTime;
    svtime := rtime - g_dwFirstServerTime + 3000;

    if cltime > svtime then begin
      Inc(g_nTimeFakeDetectCount);
      if g_nTimeFakeDetectCount > 6 then begin
        //矫埃炼累...
        str := 'Bad';
        //SendSpeedHackUser;
        FrmDlg.DMessageDlg('系统不稳定或网络状态极差，游戏被中止\' +
          '如有问题请联系游戏管理员。',
          [mbOk]);
        frmMain.Close;
      end;
    end else begin
      str := 'Good';
      g_nTimeFakeDetectCount := 0;
    end;
    if g_boCheckSpeedHackDisplay then begin
      DScreen.AddSysMsg(IntToStr(svtime) + ' - ' +
        IntToStr(cltime) + ' = ' +
        IntToStr(svtime - cltime) +
        ' ' + str,0 , 30, 40, clGreen);
    end;
  end else begin
    g_dwFirstServerTime := rtime;
    g_dwFirstClientTime := GetTickCount;
    //ServerTimeGap := int64(GetTickCount) - longword(msg.Recog);
  end;
end;

procedure TfrmMain.DecodeMessagePacket(datablock: string);
var
  head, body, body2, tagstr, data, rdstr, str: string;
  Msg: TDefaultMessage;
  smsg: TShortMessage;
  mbw: TMessageBodyW;
  desc: TCharDesc;
  wl: TMessageBodyWL;
  featureEx: Word;
  L, i, j, n, BLKSize, param, sound, cltime, svtime: Integer;
  tempb: Boolean;
  Actor: TActor;
  event: TClEvent;
  mytemp: array[0..1023] of Char;
begin
  if datablock[1] = '+' then begin //checkcode
    data := Copy(datablock, 2, Length(datablock) - 1);
    data := GetValidStr3(data, tagstr, ['/']);
    if tagstr = 'PWR' then g_boNextTimePowerHit := True; //打开攻杀
    if tagstr = 'LNG' then g_boCanLongHit := True; //打开刺杀
    if tagstr = 'ULNG' then g_boCanLongHit := FALSE; //关闭刺杀
    if tagstr = 'WID' then g_boCanWideHit := True; //打开半月
    if tagstr = 'UWID' then g_boCanWideHit := FALSE; //关闭半月
    if tagstr = 'CRS' then g_boCanCrsHit := True; //打开双龙    抱月刀法
    if tagstr = 'UCRS' then g_boCanCrsHit := FALSE; //关闭双龙  抱月刀法
    if tagstr = 'TWN' then g_boCanTwnHit := True; //打开狂风斩
    if tagstr = 'UTWN' then g_boCanTwnHit := FALSE; //关闭狂风斩
    if tagstr = 'STN' then g_boCanStnHit := True; //打开狂风斩;
    if tagstr = 'USTN' then g_boCanStnHit := FALSE;
    if tagstr = 'FIR' then begin
      g_boNextTimeFireHit := True; //打开烈火
      g_dwLatestFireHitTick := GetTickCount;
      //Myself.SendMsg (SM_READYFIREHIT, Myself.XX, Myself.m_nCurrY, Myself.Dir, 0, 0, '', 0);
    end;

          if tagstr = 'TWN'  then begin
        g_boCanTwnHit := True;    //打开 重击开天斩
        g_dwLatestTwnHitTick := GetTickCount;
      end;
      if tagstr = 'UTWN' then g_boCanTwnHit := False;   //关闭 重击开天斩

      if tagstr = 'QTWN' then begin  //打开 轻击开天斩    2008.02.12
        g_boCanQTwnHit := True;
        g_dwLatestTwnHitTick := GetTickCount;
      end;
      if tagstr = 'UQTWN' then g_boCanQTwnHit := False;   //关闭 轻击开天斩 2008.02.12


    if tagstr = 'UFIR' then g_boNextTimeFireHit := FALSE; //关闭烈火
    if tagstr = 'GOOD' then begin
      ActionLock := FALSE;
      Inc(g_nReceiveCount);
    end;
    if tagstr = 'FAIL' then begin
      ActionFailed;
      ActionLock := FALSE;
      Inc(g_nReceiveCount);
    end;
    //DScreen.AddSysmsg (data);
    if data <> '' then begin
      CheckSpeedHack(Str_ToInt(data, 0));
    end;
    Exit;
  end;
  if Length(datablock) < DEFBLOCKSIZE then begin
    if datablock[1] = '=' then begin
      data := Copy(datablock, 2, Length(datablock) - 1);
      if data = 'DIG' then begin
        g_MySelf.m_boDigFragment := True;
      end;
    end;
    Exit;
  end;

  head := Copy(datablock, 1, DEFBLOCKSIZE);
  body := Copy(datablock, DEFBLOCKSIZE + 1, Length(datablock) - DEFBLOCKSIZE);
  Msg := DecodeMessage(head);

  //DScreen.AddSysMsg (IntToStr(msg.Ident));

  if (Msg.ident <> SM_HEALTHSPELLCHANGED) and
    (Msg.ident <> SM_HEALTHSPELLCHANGED)
    then begin

    if g_boShowMemoLog then begin
      ShowHumanMsg(@Msg);
      //PlayScene.MemoLog.Lines.Add('Ident: ' + IntToStr(msg.Recog) + '/' + IntToStr(msg.Ident));
    end;
  end;

  if g_MySelf = nil then begin
    case Msg.ident of
      SM_NEWID_SUCCESS: begin
          FrmDlg.DMessageDlg('您的帐号创建成功。\' +
            '请妥善保管您的帐号和密码，\并且不要因任何原因把帐号和密码告诉任何其他人。\' +
            '如果忘记了密码,\你可以通过我们的主页重新找回。\', [mbOk]);
        end;
      SM_NEWID_FAIL: begin
          case Msg.Recog of
            0: begin
                FrmDlg.DMessageDlg('帐号 "' + MakeNewId + '" 已被其他的玩家使用了。\' +
                  '请选择其它帐号名注册。',
                  [mbOk]);
                LoginScene.NewIdRetry(FALSE); //促矫 矫档
              end;
            -2: FrmDlg.DMessageDlg('此帐号名被禁止使用！', [mbOk]);
            else FrmDlg.DMessageDlg('帐号创建失败，请确认帐号是否包括空格、及非法字符！Code: ' + IntToStr(Msg.Recog), [mbOk]);
          end;
        end;
      SM_PASSWD_FAIL: begin
          case Msg.Recog of
            -1: FrmDlg.DMessageDlg('密码错误！！', [mbOk]);
            -2: FrmDlg.DMessageDlg('密码输入错误超过3次，此帐号被暂时锁定，请稍候再登录！', [mbOk]);
            -3: FrmDlg.DMessageDlg('此帐号已经登录或被异常锁定，请稍候再登录！', [mbOk]);
            -4: FrmDlg.DMessageDlg('这个帐号访问失败！\请使用其他帐号登录，\或者申请付费注册。', [mbOk]);
            -5: FrmDlg.DMessageDlg('这个帐号被锁定！', [mbOk]);
            else FrmDlg.DMessageDlg('此帐号不存在或出现未知错误！！', [mbOk]);
          end;
          LoginScene.PassWdFail;
        end;
      SM_NEEDUPDATE_ACCOUNT: {//拌沥 沥焊甫 促矫 涝仿窍扼.} begin
          ClientGetNeedUpdateAccount(body);
        end;
      SM_UPDATEID_SUCCESS: begin
          FrmDlg.DMessageDlg('您的帐号信息更新成功。\' +
            '请妥善保管您的帐号和密码。\' +
            '并且不要因任何原因把帐号和密码告诉任何其他人。\' +
            '如果忘记了密码，你可以通过我们的主页重新找回。', [mbOk]);
          ClientGetSelectServer;
        end;
      SM_UPDATEID_FAIL: begin
          FrmDlg.DMessageDlg('更新帐号失败..', [mbOk]);
          ClientGetSelectServer;
        end;
      SM_PASSOK_SELECTSERVER: begin
          ClientGetPasswordOK(Msg, body);
        end;
      SM_SELECTSERVER_OK: begin
          ClientGetPasswdSuccess(body);
        end;
      SM_QUERYCHR: begin
          ClientGetReceiveChrs(body);
        end;
      SM_QUERYCHR_FAIL: begin
          g_boDoFastFadeOut := FALSE;
          g_boDoFadeIn := FALSE;
          g_boDoFadeOut := FALSE;
          FrmDlg.DMessageDlg('服务器认证失败..', [mbOk]);
          Close;
        end;
      SM_NEWCHR_SUCCESS: begin
          SendQueryChr;
        end;
      SM_NEWCHR_FAIL: begin
          case Msg.Recog of
            0: FrmDlg.DMessageDlg('[错误信息] 输入的角色名称包含非法字符！ 错误代码 = 0', [mbOk]);
            2: FrmDlg.DMessageDlg('[错误信息] 创建角色名称已被其他人使用！ 错误代码 = 2', [mbOk]);
            3: FrmDlg.DMessageDlg('[错误信息] 您只能创建二个游戏角色！ 错误代码 = 3', [mbOk]);
            4: FrmDlg.DMessageDlg('[错误信息] 创建角色时出现错误！ 错误代码 = 4', [mbOk]);
            else FrmDlg.DMessageDlg('[错误信息] 创建角色时出现未知错误！', [mbOk]);
          end;
        end;
      SM_CHGPASSWD_SUCCESS: begin
          FrmDlg.DMessageDlg('密码修改成功.', [mbOk]);
        end;
      SM_CHGPASSWD_FAIL: begin
          case Msg.Recog of
            -1: FrmDlg.DMessageDlg('输入的原始密码不正确！', [mbOk]);
            -2: FrmDlg.DMessageDlg('此帐号被锁定！', [mbOk]);
            else FrmDlg.DMessageDlg('输入的新密码长度小于四位！', [mbOk]);
          end;
        end;
      SM_DELCHR_SUCCESS: begin
          SendQueryChr;
        end;
      SM_DELCHR_FAIL: begin
          FrmDlg.DMessageDlg('[错误信息] 删除游戏角色时出现错误！', [mbOk]);
        end;
      SM_STARTPLAY: begin
          ClientGetStartPlay(body);
          Exit;
        end;
      SM_STARTFAIL: begin
          FrmDlg.DMessageDlg('此服务器满员！', [mbOk]);
          //               FrmMain.Close;
          //               frmSelMain.Close;
          ClientGetSelectServer();
          Exit;
        end;
      SM_VERSION_FAIL: begin
          FrmDlg.DMessageDlg('游戏程序版本不正确，请下载最新版本游戏程序！', [mbOk]);
          //               FrmMain.Close;
          //               frmSelMain.Close;
          Exit;
        end;
      SM_OUTOFCONNECTION,
        SM_NEWMAP,
        SM_LOGON,
        SM_RECONNECT,
        SM_SENDNOTICE: ; //酒贰俊辑 贸府
      else
        Exit;
    end;
  end;
  if g_boMapMoving then begin
    if Msg.ident = SM_CHANGEMAP then begin
      WaitingMsg := Msg;
      WaitingStr := DecodeString(body);
      g_boMapMovingWait := True;
      WaitMsgTimer.Enabled := True;
    end;
    Exit;
  end;

  case Msg.ident of
    //Damian
    SM_VERSION_FAIL: begin
        i := MakeLong(Msg.param, Msg.tag);
        DecodeBuffer(body, @j, sizeof(Integer));
        if (Msg.Recog <> g_nThisCRC) and
          (i <> g_nThisCRC) and
          (j <> g_nThisCRC) and (j = 1) then begin
          //修改可以登陆
          FrmDlg.DMessageDlg('游戏程序版本不正确，请下载最新版本游戏程序！', [mbOk]);
          DScreen.AddChatBoardString('游戏程序版本不正确，请下载最新版本游戏程序！', clYellow, clRed);
          CSocket.Close;
          //        FrmMain.Close;
          //        frmSelMain.Close;
          Exit;
          {FrmDlg.DMessageDlg ('Wrong version. Please download latest version. (http://www.legendofmir.net)', [mbOk]);
          Close;
          exit;}
        end;
      end;
    SM_NEWMAP: begin
        g_sMapTitle := '';
        str := DecodeString(body); //mapname
        //        PlayScene.MemoLog.Lines.Add('X: ' + IntToStr(msg.Param) + 'Y: ' + IntToStr(msg.tag) + ' Map: ' + str);
        PlayScene.SendMsg(SM_NEWMAP, 0,
          Msg.param {x},
          Msg.tag {y},
          Msg.series {darkness},
          0, 0,
          str {mapname});
      end;

    SM_LOGON: begin
        g_dwFirstServerTime := 0;
        g_dwFirstClientTime := 0;
        with Msg do begin
          DecodeBuffer(body, @wl, sizeof(TMessageBodyWL));
          PlayScene.SendMsg(SM_LOGON, Msg.Recog,
            Msg.param {x},
            Msg.tag {y},
            Msg.series {dir},
            wl.lParam1, //desc.Feature,
            wl.lParam2, //desc.Status,
            '');
          DScreen.ChangeScene(stPlayGame);
          SendClientMessage(CM_QUERYBAGITEMS, 0, 0, 0, 0);
          if Lobyte(Loword(wl.lTag1)) = 1 then g_boAllowGroup := True
          else g_boAllowGroup := FALSE;
          g_boServerChanging := FALSE;
        end;
        if g_wAvailIDDay > 0 then begin
          DScreen.AddChatBoardString('您当前通过包月帐号充值。', clGreen, clWhite)
        end else if g_wAvailIPDay > 0 then begin
          DScreen.AddChatBoardString('您当前通过包月IP 充值。', clGreen, clWhite)
        end else if g_wAvailIPHour > 0 then begin
          DScreen.AddChatBoardString('您当前通过计时IP 充值。', clGreen, clWhite)
        end else if g_wAvailIDHour > 0 then begin
          DScreen.AddChatBoardString('您当前通过计时帐号充值。', clGreen, clWhite)
        end;
      //  LoadUserConfig(CharName);
        //DScreen.AddChatBoardString ('当前服务器信息: ' + g_sRunServerAddr + ':' + IntToStr(g_nRunServerPort), clGreen, clWhite)
      end;
    SM_SERVERCONFIG: ClientGetServerConfig(Msg, body);

    SM_RECONNECT: begin
        ClientGetReconnect(body);
      end;
    SM_TIMECHECK_MSG: begin
        CheckSpeedHack(Msg.Recog);
      end;

    SM_AREASTATE: begin
        g_nAreaStateValue := Msg.Recog;
      end;

    SM_MAPDESCRIPTION: begin
        ClientGetMapDescription(Msg, body);
      end;
    SM_GAMEGOLDNAME: begin
        ClientGetGameGoldName(Msg, body);
      end;
    SM_ADJUST_BONUS: begin
        ClientGetAdjustBonus(Msg.Recog, body);
      end;
    SM_MYSTATUS: begin
        g_nMyHungryState := Msg.param;
      end;

    SM_TURN: begin
        if Length(body) > GetCodeMsgSize(sizeof(TCharDesc) * 4 / 3) then begin
          body2 := Copy(body, GetCodeMsgSize(sizeof(TCharDesc) * 4 / 3) + 1, Length(body));
          data := DecodeString(body2); //某腐 捞抚
          str := GetValidStr3(data, data, ['/']);
          //data = 捞抚
          //str = 祸哎
        end else data := '';
        DecodeBuffer(body, @desc, sizeof(TCharDesc));
        PlayScene.SendMsg(SM_TURN, Msg.Recog,
          Msg.param {x},
          Msg.tag {y},
          Msg.series {dir + light},
          desc.Feature,
          desc.Status,
          ''); //捞抚
        if data <> '' then begin
          Actor := PlayScene.FindActor(Msg.Recog);
          if Actor <> nil then begin
            Actor.m_sDescUserName := GetValidStr3(data, Actor.m_sUserName, ['\']);
            //actor.UserName := data;
            Actor.m_nNameColor := GetRGB(Str_ToInt(str, 0));
          end;
        end;
      end;

    SM_BACKSTEP: begin
        if Length(body) > GetCodeMsgSize(sizeof(TCharDesc) * 4 / 3) then begin
          body2 := Copy(body, GetCodeMsgSize(sizeof(TCharDesc) * 4 / 3) + 1, Length(body));
          data := DecodeString(body2); //某腐 捞抚
          str := GetValidStr3(data, data, ['/']);
          //data = 捞抚
          //str = 祸哎
        end else data := '';
        DecodeBuffer(body, @desc, sizeof(TCharDesc));
        PlayScene.SendMsg(SM_BACKSTEP, Msg.Recog,
          Msg.param {x},
          Msg.tag {y},
          Msg.series {dir + light},
          desc.Feature,
          desc.Status,
          ''); //捞抚
        if data <> '' then begin
          Actor := PlayScene.FindActor(Msg.Recog);
          if Actor <> nil then begin
            Actor.m_sDescUserName := GetValidStr3(data, Actor.m_sUserName, ['\']);
            //actor.UserName := data;
            Actor.m_nNameColor := GetRGB(Str_ToInt(str, 0));
          end;
        end;
      end;

    SM_SPACEMOVE_HIDE,
      SM_SPACEMOVE_HIDE2: begin
        if Msg.Recog <> g_MySelf.m_nRecogId then begin
          PlayScene.SendMsg(Msg.ident, Msg.Recog, Msg.param {x}, Msg.tag {y}, 0, 0, 0, '')
        end;
      end;

    SM_SPACEMOVE_SHOW,
      SM_SPACEMOVE_SHOW2: begin
        if Length(body) > GetCodeMsgSize(sizeof(TCharDesc) * 4 / 3) then begin
          body2 := Copy(body, GetCodeMsgSize(sizeof(TCharDesc) * 4 / 3) + 1, Length(body));
          data := DecodeString(body2); //某腐 捞抚
          str := GetValidStr3(data, data, ['/']);
          //data = 捞抚
          //str = 祸哎
        end else data := '';
        DecodeBuffer(body, @desc, sizeof(TCharDesc));
        if Msg.Recog <> g_MySelf.m_nRecogId then begin //促弗 某腐磐牢 版快
          PlayScene.NewActor(Msg.Recog, Msg.param, Msg.tag, Msg.series, desc.Feature, desc.Status);
        end;
        PlayScene.SendMsg(Msg.ident, Msg.Recog,
          Msg.param {x},
          Msg.tag {y},
          Msg.series {dir + light},
          desc.Feature,
          desc.Status,
          ''); //捞抚
        if data <> '' then begin
          Actor := PlayScene.FindActor(Msg.Recog);
          if Actor <> nil then begin
            Actor.m_sDescUserName := GetValidStr3(data, Actor.m_sUserName, ['\']);
            //actor.UserName := data;
            Actor.m_nNameColor := GetRGB(Str_ToInt(str, 0));
          end;
        end;
      end;

    SM_WALK, SM_RUSH, SM_RUSHKUNG: begin
        //DScreen.AddSysMsg ('WALK ' + IntToStr(msg.Param) + ':' + IntToStr(msg.Tag));
        DecodeBuffer(body, @desc, sizeof(TCharDesc));
        if (Msg.Recog <> g_MySelf.m_nRecogId) or (Msg.ident = SM_RUSH) or (Msg.ident = SM_RUSHKUNG) then
          PlayScene.SendMsg(Msg.ident, Msg.Recog,
            Msg.param {x},
            Msg.tag {y},
            Msg.series {dir+light},
            desc.Feature,
            desc.Status, '');
        if Msg.ident = SM_RUSH then
          g_dwLatestRushRushTick := GetTickCount;
      end;

    SM_RUN, SM_HORSERUN: begin
        //DScreen.AddSysMsg ('RUN ' + IntToStr(msg.Param) + ':' + IntToStr(msg.Tag));
        DecodeBuffer(body, @desc, sizeof(TCharDesc));
        if Msg.Recog <> g_MySelf.m_nRecogId then
          PlayScene.SendMsg(Msg.ident, Msg.Recog,
            Msg.param {x},
            Msg.tag {y},
            Msg.series {dir+light},
            desc.Feature,
            desc.Status, '');
        (*
        PlayScene.SendMsg (SM_RUN, msg.Recog,
                             msg.Param{x},
                             msg.tag{y},
                             msg.Series{dir+light},
                             desc.Feature,
                             desc.Status, '');
        *)
      end;

    SM_CHANGELIGHT: {//游戏亮度} begin
        Actor := PlayScene.FindActor(Msg.Recog);
        if Actor <> nil then begin
          Actor.m_nChrLight := Msg.param;
        end;
      end;

    SM_LAMPCHANGEDURA: begin
        if g_UseItems[U_RIGHTHAND].S.name <> '' then begin
          g_UseItems[U_RIGHTHAND].Dura := Msg.Recog;
        end;
      end;

    SM_MOVEFAIL: begin
        ActionFailed;
        DecodeBuffer(body, @desc, sizeof(TCharDesc));
        PlayScene.SendMsg(SM_TURN, Msg.Recog,
          Msg.param {x},
          Msg.tag {y},
          Msg.series {dir},
          desc.Feature,
          desc.Status, '');
      end;
    SM_BUTCH: begin
        DecodeBuffer(body, @desc, sizeof(TCharDesc));
        if Msg.Recog <> g_MySelf.m_nRecogId then begin
          Actor := PlayScene.FindActor(Msg.Recog);
          if Actor <> nil then
            Actor.SendMsg(SM_SITDOWN,
              Msg.param {x},
              Msg.tag {y},
              Msg.series {dir},
              0, 0, '', 0);
        end;
      end;
    SM_SITDOWN: begin
        DecodeBuffer(body, @desc, sizeof(TCharDesc));
        if Msg.Recog <> g_MySelf.m_nRecogId then begin
          Actor := PlayScene.FindActor(Msg.Recog);
          if Actor <> nil then
            Actor.SendMsg(SM_SITDOWN,
              Msg.param {x},
              Msg.tag {y},
              Msg.series {dir},
              0, 0, '', 0);
        end;
      end;

    SM_HIT, //14
    SM_HEAVYHIT, //15
    SM_POWERHIT, //18
    SM_LONGHIT, //19
    SM_WIDEHIT, //24
    SM_BIGHIT, //16
    SM_FIREHIT, //8
    SM_CRSHIT,
      SM_TWINHIT: begin
        if Msg.Recog <> g_MySelf.m_nRecogId then begin
          Actor := PlayScene.FindActor(Msg.Recog);
          if Actor <> nil then begin
            Actor.SendMsg(Msg.ident,
              Msg.param {x},
              Msg.tag {y},
              Msg.series {dir},
              0, 0, '',
              0);
            if Msg.ident = SM_HEAVYHIT then begin
              if body <> '' then
                Actor.m_boDigFragment := True;
            end;
          end;
        end;
      end;
    SM_FLYAXE: begin
        DecodeBuffer(body, @mbw, sizeof(TMessageBodyW));
        Actor := PlayScene.FindActor(Msg.Recog);
        if Actor <> nil then begin
          Actor.SendMsg(Msg.ident,
            Msg.param {x},
            Msg.tag {y},
            Msg.series {dir},
            0, 0, '',
            0);
          Actor.m_nTargetX := mbw.Param1; //x 带瘤绰 格钎
          Actor.m_nTargetY := mbw.Param2; //y
          Actor.m_nTargetRecog := MakeLong(mbw.Tag1, mbw.Tag2);
        end;
      end;

    SM_LIGHTING: begin
        DecodeBuffer(body, @wl, sizeof(TMessageBodyWL));
        Actor := PlayScene.FindActor(Msg.Recog);
        if Actor <> nil then begin
          Actor.SendMsg(Msg.ident,
            Msg.param {x},
            Msg.tag {y},
            Msg.series {dir},
            0, 0, '',
            0);
          Actor.m_nTargetX := wl.lParam1; //x 带瘤绰 格钎
          Actor.m_nTargetY := wl.lParam2; //y
          Actor.m_nTargetRecog := wl.lTag1;
          Actor.m_nMagicNum := wl.lTag2; //付过 锅龋
        end;
      end;

    SM_SPELL: begin
        UseMagicSpell(Msg.Recog {who}, Msg.series {effectnum}, Msg.param {tx}, Msg.tag {y}, Str_ToInt(body, 0));
      end;
    SM_MAGICFIRE: begin
        DecodeBuffer(body, @param, sizeof(Integer));
        UseMagicFire(Msg.Recog {who}, Lobyte(Msg.series) {efftype}, Hibyte(Msg.series) {effnum}, Msg.param {tx}, Msg.tag {y}, param);
        //Lobyte(msg.Series) = EffectType
        //Hibyte(msg.Series) = Effect
      end;
    SM_MAGICFIRE_FAIL: begin
        UseMagicFireFail(Msg.Recog {who});
      end;

    SM_OUTOFCONNECTION: begin
        g_boDoFastFadeOut := FALSE;
        g_boDoFadeIn := FALSE;
        g_boDoFadeOut := FALSE;
        FrmDlg.DMessageDlg('服务器连接被强行中断。\连接时间可能超过限制。', [mbOk]);
        Close;
      end;

    SM_DEATH,
      SM_NOWDEATH: begin
        DecodeBuffer(body, @desc, sizeof(TCharDesc));
        Actor := PlayScene.FindActor(Msg.Recog);
        if Actor <> nil then begin
          Actor.SendMsg(Msg.ident,
            Msg.param {x}, Msg.tag {y}, Msg.series {damage},
            desc.Feature, desc.Status, '',
            0);
          Actor.m_Abil.HP := 0;
        end else begin
          PlayScene.SendMsg(SM_DEATH, Msg.Recog, Msg.param {x}, Msg.tag {y}, Msg.series {damage}, desc.Feature, desc.Status, '');
        end;
      end;
    SM_SKELETON: begin
        DecodeBuffer(body, @desc, sizeof(TCharDesc));
        PlayScene.SendMsg(SM_SKELETON, Msg.Recog, Msg.param {HP}, Msg.tag {maxHP}, Msg.series {damage}, desc.Feature, desc.Status, '');
      end;
    SM_ALIVE: begin
        DecodeBuffer(body, @desc, sizeof(TCharDesc));
        PlayScene.SendMsg(SM_ALIVE, Msg.Recog, Msg.param {HP}, Msg.tag {maxHP}, Msg.series {damage}, desc.Feature, desc.Status, '');
      end;

    SM_ABILITY: begin
        g_MySelf.m_nGold := Msg.Recog;
        g_MySelf.m_btJob := Msg.param;
        g_MySelf.m_nGameGold := MakeLong(Msg.tag, Msg.series);
        DecodeBuffer(body, @g_MySelf.m_Abil, sizeof(TAbility));
      end;

    SM_SUBABILITY: begin
        g_nMyHitPoint := Lobyte(Msg.param);
        g_nMySpeedPoint := Hibyte(Msg.param);
        g_nMyAntiPoison := Lobyte(Msg.tag);
        g_nMyPoisonRecover := Hibyte(Msg.tag);
        g_nMyHealthRecover := Lobyte(Msg.series);
        g_nMySpellRecover := Hibyte(Msg.series);
        g_nMyAntiMagic := Lobyte(LongWord(Msg.Recog));
      end;

    SM_DAYCHANGING: begin
        g_nDayBright := Msg.param;
        DarkLevel := Msg.tag;
        if DarkLevel = 0 then g_boViewFog := FALSE
        else g_boViewFog := True;
      end;                                                                                                           

    SM_WINEXP: begin
                 g_MySelf.m_Abil.Exp := msg.Recog; //坷弗 版氰摹
            if g_boExpFiltrate then begin
              if LongWord(MakeLong(msg.Param,msg.Tag)) > 2000 then
                DScreen.AddChatBoardString (IntToStr(LongWord(MakeLong(msg.Param,msg.Tag))) + ' 经验值增加.',clWhite, clRed);
            end else begin
              DScreen.AddChatBoardString (IntToStr(LongWord(MakeLong(msg.Param,msg.Tag))) + ' 经验值增加.',clWhite, clRed);
            end;
 //  end;
      //  g_MySelf.m_Abil.Exp := Msg.Recog; //坷弗 版氰摹
     //   DScreen.AddSysMsg ('已获得 ' + IntToStr(LongWord(MakeLong(msg.Param,msg.Tag))) + ' 点经验值。',1 ,SCREENWIDTH - 150, 40, clLime);   //SCREENWIDTH - 100, 40, clGreen);
        //DScreen.AddChatBoardString('已获得 ' + IntToStr(LongWord(MakeLong(Msg.param, Msg.tag))) + ' 点经验值。', clWhite, clRed);
      end;

    SM_LEVELUP: begin
        g_MySelf.m_Abil.Level := Msg.param;
        DScreen.AddSysMsg('升级！',0,30, 40, clGreen);
        //          DScreen.AddChatBoardString ('Congratulation! Your level is up. Your HP, MP are all recovered.',clWhite, clPurple);
      end;

    SM_HEALTHSPELLCHANGED: begin
        Actor := PlayScene.FindActor(Msg.Recog);
        if Actor <> nil then begin
          Actor.m_Abil.HP := Msg.param;
          Actor.m_Abil.MP := Msg.tag;
          Actor.m_Abil.MaxHP := Msg.series;
        end;
      end;

    SM_STRUCK: begin
        //wl: TMessageBodyWL;
        DecodeBuffer(body, @wl, sizeof(TMessageBodyWL));
        Actor := PlayScene.FindActor(Msg.Recog);
        if Actor <> nil then begin
          if Actor = g_MySelf then begin
            if g_MySelf.m_nNameColor = 249 then //弧盎捞绰 嘎栏搁 立加阑 给 谗绰促.
              g_dwLatestStruckTick := GetTickCount;
          end else begin
            if Actor.CanCancelAction then
              Actor.CancelAction;
          end;
          Actor.UpdateMsg(SM_STRUCK, wl.lTag2, 0,
            Msg.series {damage}, wl.lParam1, wl.lParam2,
            '', wl.lTag1 {锭赴仇酒捞叼});
          Actor.m_Abil.HP := Msg.param;
          Actor.m_Abil.MaxHP := Msg.tag;
        end;
      end;

    SM_CHANGEFACE: begin
        Actor := PlayScene.FindActor(Msg.Recog);
        if Actor <> nil then begin
          DecodeBuffer(body, @desc, sizeof(TCharDesc));
          Actor.m_nWaitForRecogId := MakeLong(Msg.param, Msg.tag);
          Actor.m_nWaitForFeature := desc.Feature;
          Actor.m_nWaitForStatus := desc.Status;
          AddChangeFace(Actor.m_nWaitForRecogId);
        end;
      end;
    SM_PASSWORD: begin
        //PlayScene.EdChat.PasswordChar:='*';
        SetInputStatus();
      end;
    SM_OPENHEALTH: begin
        Actor := PlayScene.FindActor(Msg.Recog);
        if Actor <> nil then begin
          if Actor <> g_MySelf then begin
            Actor.m_Abil.HP := Msg.param;
            Actor.m_Abil.MaxHP := Msg.tag;
          end;
          Actor.m_boOpenHealth := True;
          //actor.OpenHealthTime := 999999999;
          //actor.OpenHealthStart := GetTickCount;
        end;
      end;
    SM_CLOSEHEALTH: begin
        Actor := PlayScene.FindActor(Msg.Recog);
        if Actor <> nil then begin
          Actor.m_boOpenHealth := FALSE;
        end;
      end;
    SM_INSTANCEHEALGUAGE: begin
        Actor := PlayScene.FindActor(Msg.Recog);
        if Actor <> nil then begin
          Actor.m_Abil.HP := Msg.param;
          Actor.m_Abil.MaxHP := Msg.tag;
          Actor.m_noInstanceOpenHealth := True;
          Actor.m_dwOpenHealthTime := 2 * 1000;
          Actor.m_dwOpenHealthStart := GetTickCount;
        end;
      end;

    SM_BREAKWEAPON: begin
        Actor := PlayScene.FindActor(Msg.Recog);
        if Actor <> nil then begin
          if Actor is THumActor then
            THumActor(Actor).DoWeaponBreakEffect;
        end;
      end;

    SM_CRY,
      SM_GROUPMESSAGE, //   弊缝 皋技瘤
    SM_GUILDMESSAGE,
      SM_WHISPER,
      SM_SYSMESSAGE: {//系统消息} begin
        str := DecodeString(body);
        DScreen.AddChatBoardString(str, GetRGB(Lobyte(Msg.param)), GetRGB(Hibyte(Msg.param)));
        if Msg.ident = SM_GUILDMESSAGE then
          FrmDlg.AddGuildChat(str);
      end;

    SM_HEAR: begin
        str := DecodeString(body);
        DScreen.AddChatBoardString(str, GetRGB(Lobyte(Msg.param)), GetRGB(Hibyte(Msg.param)));
        Actor := PlayScene.FindActor(Msg.Recog);
        if Actor <> nil then
          Actor.Say(str);
      end;

    SM_USERNAME: begin
        str := DecodeString(body);
        Actor := PlayScene.FindActor(Msg.Recog);
        if Actor <> nil then begin
          Actor.m_sDescUserName := GetValidStr3(str, Actor.m_sUserName, ['\']);
          //actor.UserName := str;
          Actor.m_nNameColor := GetRGB(Msg.param);
        end;
      end;
    SM_CHANGENAMECOLOR: begin
        Actor := PlayScene.FindActor(Msg.Recog);
        if Actor <> nil then begin
          Actor.m_nNameColor := GetRGB(Msg.param);
        end;
      end;

    SM_HIDE,
      SM_GHOST, //儡惑..
    SM_DISAPPEAR: begin
        if g_MySelf.m_nRecogId <> Msg.Recog then
          PlayScene.SendMsg(SM_HIDE, Msg.Recog, Msg.param {x}, Msg.tag {y}, 0, 0, 0, '');
      end;

    SM_DIGUP: begin
        DecodeBuffer(body, @wl, sizeof(TMessageBodyWL));
        Actor := PlayScene.FindActor(Msg.Recog);
        if Actor = nil then
          Actor := PlayScene.NewActor(Msg.Recog, Msg.param, Msg.tag, Msg.series, wl.lParam1, wl.lParam2);
        Actor.m_nCurrentEvent := wl.lTag1;
        Actor.SendMsg(SM_DIGUP,
          Msg.param {x},
          Msg.tag {y},
          Msg.series {dir + light},
          wl.lParam1,
          wl.lParam2, '', 0);
      end;
    SM_DIGDOWN: begin
        PlayScene.SendMsg(SM_DIGDOWN, Msg.Recog, Msg.param {x}, Msg.tag {y}, 0, 0, 0, '');
      end;
    SM_SHOWEVENT: begin
        DecodeBuffer(body, @smsg, sizeof(TShortMessage));
        event := TClEvent.Create(Msg.Recog, Loword(Msg.tag) {x}, Msg.series {y}, Msg.param {e-type});
        event.m_nDir := 0;
        event.m_nEventParam := smsg.ident;
        EventMan.AddEvent(event); //clvent啊 Free瞪 荐 乐澜
      end;
    SM_HIDEEVENT: begin
        EventMan.DelEventById(Msg.Recog);
      end;

    //Item ??
    SM_ADDITEM: begin
        ClientGetAddItem(body);
      end;
    SM_BAGITEMS: begin
        ClientGetBagItmes(body);
      end;
    SM_UPDATEITEM: begin
        ClientGetUpdateItem(body);
      end;
    SM_DELITEM: begin
        ClientGetDelItem(body);
      end;
    SM_DELITEMS: begin
        ClientGetDelItems(body);
      end;

    SM_DROPITEM_SUCCESS: begin
        DelDropItem(DecodeString(body), Msg.Recog);
      end;
    SM_DROPITEM_FAIL: begin
        ClientGetDropItemFail(DecodeString(body), Msg.Recog);
      end;

    SM_ITEMSHOW: ClientGetShowItem(Msg.Recog, Msg.param {x}, Msg.tag {y}, Msg.series {looks}, DecodeString(body));
    SM_ITEMHIDE: ClientGetHideItem(Msg.Recog, Msg.param, Msg.tag);
    SM_OPENDOOR_OK: Map.OpenDoor(Msg.param, Msg.tag);
    SM_OPENDOOR_LOCK: DScreen.AddSysMsg('此门被锁定！',0,30, 40, clGreen);
    SM_CLOSEDOOR: Map.CloseDoor(Msg.param, Msg.tag);

    SM_TAKEON_OK: begin
        g_MySelf.m_nFeature := Msg.Recog;
        g_MySelf.FeatureChanged;
        //            if WaitingUseItem.Index in [0..8] then
        if g_WaitingUseItem.Index in [0..12] then
          g_UseItems[g_WaitingUseItem.Index] := g_WaitingUseItem.Item;
        g_WaitingUseItem.Item.S.name := '';
      end;
    SM_TAKEON_FAIL: begin
        AddItemBag(g_WaitingUseItem.Item);
        g_WaitingUseItem.Item.S.name := '';
      end;
    SM_TAKEOFF_OK: begin
        g_MySelf.m_nFeature := Msg.Recog;
        g_MySelf.FeatureChanged;
        g_WaitingUseItem.Item.S.name := '';
      end;
    SM_TAKEOFF_FAIL: begin
        if g_WaitingUseItem.Index < 0 then begin
          n := -(g_WaitingUseItem.Index + 1);
          g_UseItems[n] := g_WaitingUseItem.Item;
        end;
        g_WaitingUseItem.Item.S.name := '';
      end;
    SM_EXCHGTAKEON_OK: ;
    SM_EXCHGTAKEON_FAIL: ;

    SM_SENDUSEITEMS: begin
        ClientGetSenduseItems(body);
      end;
    SM_WEIGHTCHANGED: begin
        g_MySelf.m_Abil.Weight := Msg.Recog;
        g_MySelf.m_Abil.WearWeight := Msg.param;
        g_MySelf.m_Abil.HandWeight := Msg.tag;
      end;
    SM_GOLDCHANGED: begin
        SoundUtil.PlaySound(s_money);
        if Msg.Recog > g_MySelf.m_nGold then begin
          DScreen.AddSysMsg(IntToStr(Msg.Recog - g_MySelf.m_nGold) + ' ' + g_sGoldName + ' 被发现.',0, 30, 40, clGreen);
        end;
        g_MySelf.m_nGold := Msg.Recog;
        g_MySelf.m_nGameGold := MakeLong(Msg.param, Msg.tag);
      end;
    SM_FEATURECHANGED: begin
        PlayScene.SendMsg(Msg.ident, Msg.Recog, 0, 0, 0, MakeLong(Msg.param, Msg.tag), MakeLong(Msg.series, 0), '');
      end;
    SM_CHARSTATUSCHANGED: begin
        PlayScene.SendMsg(Msg.ident, Msg.Recog, 0, 0, 0, MakeLong(Msg.param, Msg.tag), Msg.series, '');
      end;
    SM_CLEAROBJECTS: begin
        PlayScene.CleanObjects;
        g_boMapMoving := True; //
      end;

    SM_EAT_OK: begin
        g_EatingItem.S.name := '';
        ArrangeItembag;
      end;
    SM_EAT_FAIL: begin
        AddItemBag(g_EatingItem);
        g_EatingItem.S.name := '';
      end;

    SM_ADDMAGIC: begin
        if body <> '' then
          ClientGetAddMagic(body);
      end;
    SM_SENDMYMAGIC: if body <> '' then ClientGetMyMagics(body);

    SM_DELMAGIC: begin
        ClientGetDelMagic(Msg.Recog);
      end;
    SM_MAGIC_LVEXP: begin
        ClientGetMagicLvExp(Msg.Recog {magid}, Msg.param {lv}, MakeLong(Msg.tag, Msg.series));
      end;
    SM_DURACHANGE: begin
        ClientGetDuraChange(Msg.param {useitem index}, Msg.Recog, MakeLong(Msg.tag, Msg.series));
      end;

    SM_MERCHANTSAY: begin
        ClientGetMerchantSay(Msg.Recog, Msg.param, DecodeString(body));
      end;
    SM_MERCHANTDLGCLOSE: begin
        FrmDlg.CloseMDlg;
      end;
    SM_SENDGOODSLIST: begin
        ClientGetSendGoodsList(Msg.Recog, Msg.param, body);
      end;
    SM_SENDUSERMAKEDRUGITEMLIST: begin
        ClientGetSendMakeDrugList(Msg.Recog, body);
      end;
    SM_SENDUSERSELL: begin
        ClientGetSendUserSell(Msg.Recog);
      end;
    SM_SENDUSERREPAIR: begin
        ClientGetSendUserRepair(Msg.Recog);
      end;
    SM_SENDBUYPRICE: begin
        if g_SellDlgItem.S.name <> '' then begin
          if Msg.Recog > 0 then
            g_sSellPriceStr := IntToStr(Msg.Recog) + ' ' + g_sGoldName {金币'}
          else g_sSellPriceStr := '???? ' + g_sGoldName {金币'};
        end;
      end;
    SM_USERSELLITEM_OK: begin
        FrmDlg.LastestClickTime := GetTickCount;
        g_MySelf.m_nGold := Msg.Recog;
        g_SellDlgItemSellWait.S.name := '';
      end;

    SM_USERSELLITEM_FAIL: begin
        FrmDlg.LastestClickTime := GetTickCount;
        AddItemBag(g_SellDlgItemSellWait);
        g_SellDlgItemSellWait.S.name := '';
        FrmDlg.DMessageDlg('您不能卖此物品.', [mbOk]);
      end;

    SM_SENDREPAIRCOST: begin
        if g_SellDlgItem.S.name <> '' then begin
          if Msg.Recog >= 0 then
            g_sSellPriceStr := IntToStr(Msg.Recog) + ' ' + g_sGoldName {金币}
          else g_sSellPriceStr := '???? ' + g_sGoldName {金币};
        end;
      end;
    SM_USERREPAIRITEM_OK: begin
        if g_SellDlgItemSellWait.S.name <> '' then begin
          FrmDlg.LastestClickTime := GetTickCount;
          g_MySelf.m_nGold := Msg.Recog;
          g_SellDlgItemSellWait.Dura := Msg.param;
          g_SellDlgItemSellWait.DuraMax := Msg.tag;
          AddItemBag(g_SellDlgItemSellWait);
          g_SellDlgItemSellWait.S.name := '';
        end;
      end;
    SM_USERREPAIRITEM_FAIL: begin
        FrmDlg.LastestClickTime := GetTickCount;
        AddItemBag(g_SellDlgItemSellWait);
        g_SellDlgItemSellWait.S.name := '';
        FrmDlg.DMessageDlg('您不能修理此物品.', [mbOk]);
      end;
    SM_STORAGE_OK,
      SM_STORAGE_FULL,
      SM_STORAGE_FAIL: begin
        FrmDlg.LastestClickTime := GetTickCount;
        if Msg.ident <> SM_STORAGE_OK then begin
          if Msg.ident = SM_STORAGE_FULL then
            FrmDlg.DMessageDlg('您的个人仓库已经满了，不能再保管任何东西了.', [mbOk])
          else
            FrmDlg.DMessageDlg('您不能寄存物品.', [mbOk]);
          AddItemBag(g_SellDlgItemSellWait);
        end;
        g_SellDlgItemSellWait.S.name := '';
      end;
    SM_SAVEITEMLIST: begin
        ClientGetSaveItemList(Msg.Recog, body);
      end;
    SM_TAKEBACKSTORAGEITEM_OK,
      SM_TAKEBACKSTORAGEITEM_FAIL,
      SM_TAKEBACKSTORAGEITEM_FULLBAG: begin
        FrmDlg.LastestClickTime := GetTickCount;
        if Msg.ident <> SM_TAKEBACKSTORAGEITEM_OK then begin
          if Msg.ident = SM_TAKEBACKSTORAGEITEM_FULLBAG then
            FrmDlg.DMessageDlg('您无法携带更多物品了.', [mbOk])
          else
            FrmDlg.DMessageDlg('您无法取回物品.', [mbOk]);
        end else
          FrmDlg.DelStorageItem(Msg.Recog); //itemserverindex
      end;

    SM_BUYITEM_SUCCESS: begin
        FrmDlg.LastestClickTime := GetTickCount;
        g_MySelf.m_nGold := Msg.Recog;
        FrmDlg.SoldOutGoods(MakeLong(Msg.param, Msg.tag)); //迫赴 酒捞袍 皋春俊辑 画
      end;
    SM_BUYITEM_FAIL: begin
        FrmDlg.LastestClickTime := GetTickCount;
        case Msg.Recog of
          1: FrmDlg.DMessageDlg('此物品被卖出.', [mbOk]);
          2: FrmDlg.DMessageDlg('您无法携带更多物品了.', [mbOk]);
          3: FrmDlg.DMessageDlg('您没有足够的钱来购买此物品.', [mbOk]);
        end;
      end;
    SM_MAKEDRUG_SUCCESS: begin
        FrmDlg.LastestClickTime := GetTickCount;
        g_MySelf.m_nGold := Msg.Recog;
        FrmDlg.DMessageDlg('物品成功打造', [mbOk]);
      end;
    SM_MAKEDRUG_FAIL: begin
        FrmDlg.LastestClickTime := GetTickCount;
        case Msg.Recog of
          1: FrmDlg.DMessageDlg('坷幅啊 惯积沁嚼聪促.', [mbOk]);
          2: FrmDlg.DMessageDlg('发生了错误', [mbOk]);
          3: FrmDlg.DMessageDlg(g_sGoldName {'金币'} + '不足.', [mbOk]);
          4: FrmDlg.DMessageDlg('你缺乏所必需的物品。', [mbOk]);
        end;
      end;
    SM_716: begin
        DrawEffectHum(Msg.series {type}, Msg.param {x}, Msg.tag {y});
      end;
    SM_SENDDETAILGOODSLIST: begin
        ClientGetSendDetailGoodsList(Msg.Recog, Msg.param, Msg.tag, body);
      end;
    SM_TEST: begin
        Inc(g_nTestReceiveCount);
      end;

    SM_SENDNOTICE: begin
        ClientGetSendNotice(body);
      end;
    SM_GROUPMODECHANGED: {//辑滚俊辑 唱狼 弊缝 汲沥捞 函版登菌澜.} begin
        if Msg.param > 0 then g_boAllowGroup := True
        else g_boAllowGroup := FALSE;
        g_dwChangeGroupModeTick := GetTickCount;
      end;
    SM_CREATEGROUP_OK: begin
        g_dwChangeGroupModeTick := GetTickCount;
        g_boAllowGroup := True;
        {GroupMembers.Add (Myself.UserName);
        GroupMembers.Add (DecodeString(body));}
      end;
    SM_CREATEGROUP_FAIL: begin
        g_dwChangeGroupModeTick := GetTickCount;
        case Msg.Recog of
          -1: FrmDlg.DMessageDlg('编组还未成立或者你还不够等级创建！', [mbOk]);
          -2: FrmDlg.DMessageDlg('输入的人物名称不正确！', [mbOk]);
          -3: FrmDlg.DMessageDlg('您想邀请加入编组的人已经加入了其它组！', [mbOk]);
          -4: FrmDlg.DMessageDlg('对方不允许编组！', [mbOk]);
        end;
      end;
    SM_GROUPADDMEM_OK: begin
        g_dwChangeGroupModeTick := GetTickCount;
        //GroupMembers.Add (DecodeString(body));
      end;
    SM_GROUPADDMEM_FAIL: begin
        g_dwChangeGroupModeTick := GetTickCount;
        case Msg.Recog of
          -1: FrmDlg.DMessageDlg('编组还未成立或者你还不够等级创建！', [mbOk]);
          -2: FrmDlg.DMessageDlg('输入的人物名称不正确！', [mbOk]);
          -3: FrmDlg.DMessageDlg('已经加入编组！', [mbOk]);
          -4: FrmDlg.DMessageDlg('对方不允许编组！', [mbOk]);
          -5: FrmDlg.DMessageDlg('您想邀请加入编组的人已经加入了其它组！', [mbOk]);
        end;
      end;
    SM_GROUPDELMEM_OK: begin
        g_dwChangeGroupModeTick := GetTickCount;
        {data := DecodeString (body);
        for i:=0 to GroupMembers.Count-1 do begin
           if GroupMembers[i] = data then begin
              GroupMembers.Delete (i);
              break;
           end;
        end; }
      end;
    SM_GROUPDELMEM_FAIL: begin
        g_dwChangeGroupModeTick := GetTickCount;
        case Msg.Recog of
          -1: FrmDlg.DMessageDlg('编组还未成立或者您还不够等级创建。', [mbOk]);
          -2: FrmDlg.DMessageDlg('输入的人物名称不正确！', [mbOk]);
          -3: FrmDlg.DMessageDlg('此人不在本组中！', [mbOk]);
        end;
      end;
    SM_GROUPCANCEL: begin
        g_GroupMembers.Clear;
      end;
    SM_GROUPMEMBERS: begin
        ClientGetGroupMembers(DecodeString(body));
      end;

    SM_OPENGUILDDLG: begin
        g_dwQueryMsgTick := GetTickCount;
        ClientGetOpenGuildDlg(body);
      end;

    SM_SENDGUILDMEMBERLIST: begin
        g_dwQueryMsgTick := GetTickCount;
        ClientGetSendGuildMemberList(body);
      end;

    SM_OPENGUILDDLG_FAIL: begin
        g_dwQueryMsgTick := GetTickCount;
        FrmDlg.DMessageDlg('您还没有加入行会！', [mbOk]);
      end;

    SM_DEALTRY_FAIL: begin
        g_dwQueryMsgTick := GetTickCount;
        FrmDlg.DMessageDlg('只有二人面对面才能进行交易。', [mbOk]);
      end;
    SM_DEALMENU: begin
        g_dwQueryMsgTick := GetTickCount;
        g_sDealWho := DecodeString(body);
        FrmDlg.OpenDealDlg;
      end;
    SM_DEALCANCEL: begin
        MoveDealItemToBag;
        if g_DealDlgItem.S.name <> '' then begin
          AddItemBag(g_DealDlgItem); //啊规俊 眠啊
          g_DealDlgItem.S.name := '';
        end;
        if g_nDealGold > 0 then begin
          g_MySelf.m_nGold := g_MySelf.m_nGold + g_nDealGold;
          g_nDealGold := 0;
        end;
        FrmDlg.CloseDealDlg;
      end;
    SM_DEALADDITEM_OK: begin
        g_dwDealActionTick := GetTickCount;
        if g_DealDlgItem.S.name <> '' then begin
          AddDealItem(g_DealDlgItem); //Deal Dlg俊 眠啊
          g_DealDlgItem.S.name := '';
        end;
      end;
    SM_DEALADDITEM_FAIL: begin
        g_dwDealActionTick := GetTickCount;
        if g_DealDlgItem.S.name <> '' then begin
          AddItemBag(g_DealDlgItem); //啊规俊 眠啊
          g_DealDlgItem.S.name := '';
        end;
      end;
    SM_DEALDELITEM_OK: begin
        g_dwDealActionTick := GetTickCount;
        if g_DealDlgItem.S.name <> '' then begin
          //AddItemBag (DealDlgItem);  //啊规俊 眠啊
          g_DealDlgItem.S.name := '';
        end;
      end;
    SM_DEALDELITEM_FAIL: begin
        g_dwDealActionTick := GetTickCount;
        if g_DealDlgItem.S.name <> '' then begin
          DelItemBag(g_DealDlgItem.S.name, g_DealDlgItem.MakeIndex);
          AddDealItem(g_DealDlgItem);
          g_DealDlgItem.S.name := '';
        end;
      end;
    SM_DEALREMOTEADDITEM: ClientGetDealRemoteAddItem(body);
    SM_DEALREMOTEDELITEM: ClientGetDealRemoteDelItem(body);
    SM_DEALCHGGOLD_OK: begin
        g_nDealGold := Msg.Recog;
        g_MySelf.m_nGold := MakeLong(Msg.param, Msg.tag);
        g_dwDealActionTick := GetTickCount;
      end;
    SM_DEALCHGGOLD_FAIL: begin
        g_nDealGold := Msg.Recog;
        g_MySelf.m_nGold := MakeLong(Msg.param, Msg.tag);
        g_dwDealActionTick := GetTickCount;
      end;
    SM_DEALREMOTECHGGOLD: begin
        g_nDealRemoteGold := Msg.Recog;
        SoundUtil.PlaySound(s_money); //惑措规捞 捣阑 函版茄 版快 家府啊 抄促.
      end;
    SM_DEALSUCCESS: begin
        FrmDlg.CloseDealDlg;
      end;
    SM_SENDUSERSTORAGEITEM: begin
        ClientGetSendUserStorage(Msg.Recog);
      end;
    SM_READMINIMAP_OK: begin
        g_dwQueryMsgTick := GetTickCount;
        ClientGetReadMiniMap(Msg.param);
      end;
    SM_READMINIMAP_FAIL: begin
        g_dwQueryMsgTick := GetTickCount;
        DScreen.AddChatBoardString('没有小地图.', clWhite, clRed);
        g_nMiniMapIndex := -1;
      end;
    SM_CHANGEGUILDNAME: begin
        ClientGetChangeGuildName(DecodeString(body));
      end;
    SM_SENDUSERSTATE: begin
        ClientGetSendUserState(body);
      end;
    SM_GUILDADDMEMBER_OK: begin
        SendGuildMemberList;
      end;
    SM_GUILDADDMEMBER_FAIL: begin
        case Msg.Recog of
          1: FrmDlg.DMessageDlg('你没有权利使用这个命令。', [mbOk]);
          2: FrmDlg.DMessageDlg('想加入进来的成员应该来面对掌门人。', [mbOk]);
          3: FrmDlg.DMessageDlg('对方已经加入我们的行会。', [mbOk]);
          4: FrmDlg.DMessageDlg('对方已经加入其他行会。', [mbOk]);
          5: FrmDlg.DMessageDlg('对方不允许加入行会。', [mbOk]);
        end;
      end;
    SM_GUILDDELMEMBER_OK: begin
        SendGuildMemberList;
      end;
    SM_GUILDDELMEMBER_FAIL: begin
        case Msg.Recog of
          1: FrmDlg.DMessageDlg('不能使用命令！', [mbOk]);
          2: FrmDlg.DMessageDlg('此人非本行会成员！', [mbOk]);
          3: FrmDlg.DMessageDlg('行会掌门人不能开除自己！', [mbOk]);
          4: FrmDlg.DMessageDlg('不能使用命令Z！', [mbOk]);
        end;
      end;
    SM_GUILDRANKUPDATE_FAIL: begin
        case Msg.Recog of
          -2: FrmDlg.DMessageDlg('[提示信息] 掌门人位置不能为空。', [mbOk]);
          -3: FrmDlg.DMessageDlg('[提示信息] 新的行会掌门人已经被传位。', [mbOk]);
          -4: FrmDlg.DMessageDlg('[提示信息] 一个行会最多只能有二个掌门人。', [mbOk]);
          -5: FrmDlg.DMessageDlg('[提示信息] 掌门人位置不能为空。', [mbOk]);
          -6: FrmDlg.DMessageDlg('[提示信息] 不能添加成员/删除成员。', [mbOk]);
          -7: FrmDlg.DMessageDlg('[提示信息] 职位重复或者出错。', [mbOk]);
        end;
      end;
    SM_GUILDMAKEALLY_OK,
      SM_GUILDMAKEALLY_FAIL: begin
        case Msg.Recog of
          -1: FrmDlg.DMessageDlg('您无此权限！', [mbOk]);
          -2: FrmDlg.DMessageDlg('结盟失败！', [mbOk]);
          -3: FrmDlg.DMessageDlg('行会结盟必须双方掌门人面对面！', [mbOk]);
          -4: FrmDlg.DMessageDlg('对方行会掌门人不允许结盟！', [mbOk]);
        end;
      end;
    SM_GUILDBREAKALLY_OK,
      SM_GUILDBREAKALLY_FAIL: begin
        case Msg.Recog of
          -1: FrmDlg.DMessageDlg('解除结盟！', [mbOk]);
          -2: FrmDlg.DMessageDlg('此行会不是您行会的结盟行会！', [mbOk]);
          -3: FrmDlg.DMessageDlg('没有此行会！', [mbOk]);
        end;
      end;
    SM_BUILDGUILD_OK: begin
        FrmDlg.LastestClickTime := GetTickCount;
        FrmDlg.DMessageDlg('行会建立成功。', [mbOk]);
      end;
    SM_BUILDGUILD_FAIL: begin
        FrmDlg.LastestClickTime := GetTickCount;
        case Msg.Recog of
          -1: FrmDlg.DMessageDlg('您已经加入其它行会。', [mbOk]);
          -2: FrmDlg.DMessageDlg('缺少创建费用。', [mbOk]);
          -3: FrmDlg.DMessageDlg('你没有准备好需要的全部物品。', [mbOk]);
          else FrmDlg.DMessageDlg('创建行会失败！！！', [mbOk]);
        end;
      end;
    SM_MENU_OK: begin
        FrmDlg.LastestClickTime := GetTickCount;
        if body <> '' then
          FrmDlg.DMessageDlg(DecodeString(body), [mbOk]);
      end;
    SM_DLGMSG: begin
        if body <> '' then
          FrmDlg.DMessageDlg(DecodeString(body), [mbOk]);
      end;
    SM_DONATE_OK: begin
        FrmDlg.LastestClickTime := GetTickCount;
      end;
    SM_DONATE_FAIL: begin
        FrmDlg.LastestClickTime := GetTickCount;
      end;

    SM_PLAYDICE: begin
        body2 := Copy(body, GetCodeMsgSize(sizeof(TMessageBodyWL) * 4 / 3) + 1, Length(body));
        DecodeBuffer(body, @wl, sizeof(TMessageBodyWL));
        data := DecodeString(body2);
        FrmDlg.m_nDiceCount := Msg.param; //QuestActionInfo.nParam1
        FrmDlg.m_Dice[0].nDicePoint := Lobyte(Loword(wl.lParam1)); //UserHuman.m_DyVal[0]
        FrmDlg.m_Dice[1].nDicePoint := Hibyte(Loword(wl.lParam1)); //UserHuman.m_DyVal[0]
        FrmDlg.m_Dice[2].nDicePoint := Lobyte(Hiword(wl.lParam1)); //UserHuman.m_DyVal[0]
        FrmDlg.m_Dice[3].nDicePoint := Hibyte(Hiword(wl.lParam1)); //UserHuman.m_DyVal[0]

        FrmDlg.m_Dice[4].nDicePoint := Lobyte(Loword(wl.lParam2)); //UserHuman.m_DyVal[0]
        FrmDlg.m_Dice[5].nDicePoint := Hibyte(Loword(wl.lParam2)); //UserHuman.m_DyVal[0]
        FrmDlg.m_Dice[6].nDicePoint := Lobyte(Hiword(wl.lParam2)); //UserHuman.m_DyVal[0]
        FrmDlg.m_Dice[7].nDicePoint := Hibyte(Hiword(wl.lParam2)); //UserHuman.m_DyVal[0]

        FrmDlg.m_Dice[8].nDicePoint := Lobyte(Loword(wl.lTag1)); //UserHuman.m_DyVal[0]
        FrmDlg.m_Dice[9].nDicePoint := Hibyte(Loword(wl.lTag1)); //UserHuman.m_DyVal[0]
        FrmDlg.DialogSize := 0;
        FrmDlg.DMessageDlg('', []);
        SendMerchantDlgSelect(Msg.Recog, data);
      end;
    SM_NEEDPASSWORD: begin
        ClientGetNeedPassword(body);
      end;
    SM_PASSWORDSTATUS: begin
        ClientGetPasswordStatus(@Msg, body);
      end;
    SM_SENGSHOPITEMS: begin //获取商铺物品
        ClientGetShopItems(@Msg, body);
      end;
    SM_BUYSHOPITEM_FAIL: begin
        case Msg.Recog of
          -1: FrmDlg.DMessageDlg('[失败]你的' + g_sGameGoldName + '不足！！！', [mbOk]);
          -2: FrmDlg.DMessageDlg('[失败]你包裹已满！！！', [mbOk]);
          -3: FrmDlg.DMessageDlg('[失败]你购买的物品不存在！！！', [mbOk]);
          else FrmDlg.DMessageDlg('[失败]未知错误！！！', [mbOk]);
        end;
        //FrmDlg.DMessageDlg('Msg.ident:'+IntToStr(Msg.ident)+'\'+'Msg.Recog:'+IntToStr(Msg.Recog)+'\'+'Msg.param:'+IntToStr(Msg.param)+'\'+'Msg.tag:'+IntToStr(Msg.tag), [mbOk]);
      end;

    SM_GETREGINFO: ClientGetRegInfo(@Msg, body);
    else begin
        if g_MySelf = nil then Exit; //Jacky 在未进入游戏时不处理下面
        //Jacky
        //            DScreen.AddSysMsg (IntToStr(msg.Ident) + ' : ' + body);
        PlayScene.MemoLog.Lines.Add('Ident: ' + IntToStr(Msg.ident));
        PlayScene.MemoLog.Lines.Add('Recog: ' + IntToStr(Msg.Recog));
        PlayScene.MemoLog.Lines.Add('Param: ' + IntToStr(Msg.param));
        PlayScene.MemoLog.Lines.Add('Tag: ' + IntToStr(Msg.tag));
        PlayScene.MemoLog.Lines.Add('Series: ' + IntToStr(Msg.series));
      end;
  end;

  if pos('#', datablock) > 0 then
    DScreen.AddSysMsg(datablock,0,30, 40, clGreen);
end;

procedure TfrmMain.ClientGetPasswdSuccess(body: string);
var
  str, runaddr, runport, uid, certifystr: string;
begin
  str := DecodeString(body);
  str := GetValidStr3(str, runaddr, ['/']);
  str := GetValidStr3(str, runport, ['/']);
  str := GetValidStr3(str, certifystr, ['/']);
  Certification := Str_ToInt(certifystr, 0);

  if not BoOneClick then begin
    CSocket.Active := FALSE;
    CSocket.Host := '';
    CSocket.Port := 0;
    FrmDlg.DSelServerDlg.Visible := FALSE;
    WaitAndPass(500); //0.5檬悼救 扁促覆
    g_ConnectionStep := cnsSelChr;
    with CSocket do begin
      g_sSelChrAddr := runaddr;
      g_nSelChrPort := Str_ToInt(runport, 0);
      Address := g_sSelChrAddr;
      Port := g_nSelChrPort;
      Active := True;
    end;
  end else begin
    FrmDlg.DSelServerDlg.Visible := FALSE;
    g_sSelChrAddr := runaddr;
    g_nSelChrPort := Str_ToInt(runport, 0);
    if CSocket.Socket.Connected then
      CSocket.Socket.SendText('$S' + runaddr + '/' + runport + '%');
    WaitAndPass(500); //0.5檬悼救 扁促覆
    g_ConnectionStep := cnsSelChr;
    LoginScene.OpenLoginDoor;
    SelChrWaitTimer.Enabled := True;
  end;
end;
procedure TfrmMain.ClientGetPasswordOK(Msg: TDefaultMessage;
  sBody: string);
var
  i: Integer;
  sServerName: string;
  sServerStatus: string;
  nCount: Integer;
begin
  sBody := DecodeString(sBody);
  //  FrmDlg.DMessageDlg (sBody + '/' + IntToStr(Msg.Series), [mbOk]);
  nCount := _MIN(6, Msg.series);
  g_ServerList.Clear;
  for i := 0 to nCount - 1 do begin
    sBody := GetValidStr3(sBody, sServerName, ['/']);
    sBody := GetValidStr3(sBody, sServerStatus, ['/']);
    g_ServerList.AddObject(sServerName, TObject(Str_ToInt(sServerStatus, 0)));
  end;
  //if g_ServerList.Count = 0 then begin
//    g_ServerList.InsertObject(0,'九月传奇',TObject(Str_ToInt(sServerStatus,0)));
//  end;



  g_wAvailIDDay := Loword(Msg.Recog);
  g_wAvailIDHour := Hiword(Msg.Recog);
  g_wAvailIPDay := Msg.param;
  g_wAvailIPHour := Msg.tag;

  if g_wAvailIDDay > 0 then begin
    if g_wAvailIDDay = 1 then
      FrmDlg.DMessageDlg('您当前ID费用到今天为止。', [mbOk])
    else if g_wAvailIDDay <= 3 then
      FrmDlg.DMessageDlg('您当前IP费用还剩 ' + IntToStr(g_wAvailIDDay) + ' 天。', [mbOk]);
  end else if g_wAvailIPDay > 0 then begin
    if g_wAvailIPDay = 1 then
      FrmDlg.DMessageDlg('您当前IP费用到今天为止。', [mbOk])
    else if g_wAvailIPDay <= 3 then
      FrmDlg.DMessageDlg('您当前IP费用还剩 ' + IntToStr(g_wAvailIPDay) + ' 天。', [mbOk]);
  end else if g_wAvailIPHour > 0 then begin
    if g_wAvailIPHour <= 100 then
      FrmDlg.DMessageDlg('您当前IP费用还剩 ' + IntToStr(g_wAvailIPHour) + ' 小时。', [mbOk]);
  end else if g_wAvailIDHour > 0 then begin
    FrmDlg.DMessageDlg('您当前ID费用还剩 ' + IntToStr(g_wAvailIDHour) + ' 小时。', [mbOk]); ;
  end;

  if not LoginScene.m_boUpdateAccountMode then
    ClientGetSelectServer;
end;

procedure TfrmMain.ClientGetSelectServer;
var
  sname: string;
begin
  LoginScene.HideLoginBox;
  FrmDlg.ShowSelectServerDlg;
end;

procedure TfrmMain.ClientGetNeedUpdateAccount(body: string);
var
  ue: TUserEntry;
begin
  DecodeBuffer(body, @ue, sizeof(TUserEntry));
  LoginScene.UpdateAccountInfos(ue);
end;

procedure TfrmMain.ClientGetReceiveChrs(body: string);
var
  i, select: Integer;
  str, uname, sjob, shair, slevel, ssex: string;
begin
  SelectChrScene.ClearChrs;
  str := DecodeString(body);
  for i := 0 to 1 do begin
    str := GetValidStr3(str, uname, ['/']);
    str := GetValidStr3(str, sjob, ['/']);
    str := GetValidStr3(str, shair, ['/']);
    str := GetValidStr3(str, slevel, ['/']);
    str := GetValidStr3(str, ssex, ['/']);
    select := 0;
    if (uname <> '') and (slevel <> '') and (ssex <> '') then begin
      if uname[1] = '*' then begin
        select := i;
        uname := Copy(uname, 2, Length(uname) - 1);
      end;
      SelectChrScene.AddChr(uname, Str_ToInt(sjob, 0), Str_ToInt(shair, 0), Str_ToInt(slevel, 0), Str_ToInt(ssex, 0));
    end;
    with SelectChrScene do begin
      if select = 0 then begin
        ChrArr[0].FreezeState := FALSE;
        ChrArr[0].Selected := True;
        ChrArr[1].FreezeState := True;
        ChrArr[1].Selected := FALSE;
      end else begin
        ChrArr[0].FreezeState := True;
        ChrArr[0].Selected := FALSE;
        ChrArr[1].FreezeState := FALSE;
        ChrArr[1].Selected := True;
      end;
    end;
  end;
  PlayScene.EdAccountt.Text := LoginID;
  //2004/05/17  强行登录
  {
  if SelectChrScene.ChrArr[0].Valid and SelectChrScene.ChrArr[0].Selected then PlayScene.EdChrNamet.Text := SelectChrScene.ChrArr[0].UserChr.Name;
  if SelectChrScene.ChrArr[1].Valid and SelectChrScene.ChrArr[1].Selected then PlayScene.EdChrNamet.Text := SelectChrScene.ChrArr[1].UserChr.Name;
  PlayScene.EdAccountt.Visible:=True;
  PlayScene.EdChrNamet.Visible:=True;
  }
  //2004/05/17
end;

procedure TfrmMain.ClientGetStartPlay(body: string);
var
  str, addr, sport: string;
begin
  str := DecodeString(body);
  sport := GetValidStr3(str, g_sRunServerAddr, ['/']);
  g_nRunServerPort := Str_ToInt(sport, 0);

  if not BoOneClick then begin
    CSocket.Active := FALSE; //肺弊牢俊 楷搬等 家南 摧澜
    CSocket.Host := '';
    CSocket.Port := 0;
    WaitAndPass(500); //0.5檬悼救 扁促覆

    g_ConnectionStep := cnsPlay;
    with CSocket do begin
      Address := g_sRunServerAddr;
      Port := g_nRunServerPort;
      Active := True;
    end;
  end else begin
    SocStr := '';
    BufferStr := '';
    if CSocket.Socket.Connected then
      CSocket.Socket.SendText('$R' + addr + '/' + sport + '%');

    g_ConnectionStep := cnsPlay;
    ClearBag; //啊规 檬扁拳
    DScreen.ClearChatBoard; //盲泼芒 檬扁拳
    DScreen.ChangeScene(stLoginNotice);

    WaitAndPass(500); //0.5檬悼救 扁促覆
    SendRunLogin;
  end;
end;

procedure TfrmMain.ClientGetReconnect(body: string);
var
  str, addr, sport: string;
begin
  str := DecodeString(body);
  sport := GetValidStr3(str, addr, ['/']);

  if not BoOneClick then begin
    if g_boBagLoaded then
      Savebags('.\Data\' + g_sServerName + '.' + CharName + '.itm', @g_ItemArr);
    g_boBagLoaded := FALSE;

    g_boServerChanging := True;
    CSocket.Active := FALSE; //肺弊牢俊 楷搬等 家南 摧澜
    CSocket.Host := '';
    CSocket.Port := 0;

    WaitAndPass(500); //0.5檬悼救 扁促覆

    g_ConnectionStep := cnsPlay;
    with CSocket do begin
      Address := addr;
      Port := Str_ToInt(sport, 0);
      Active := True;
    end;

  end else begin
    if g_boBagLoaded then
      Savebags('.\Data\' + g_sServerName + '.' + CharName + '.itm', @g_ItemArr);
    g_boBagLoaded := FALSE;

    SocStr := '';
    BufferStr := '';
    g_boServerChanging := True;

    if CSocket.Socket.Connected then //立加 辆丰 脚龋 焊辰促.
      CSocket.Socket.SendText('$C' + addr + '/' + sport + '%');

    WaitAndPass(500); //0.5檬悼救 扁促覆
    if CSocket.Socket.Connected then //犁立..
      CSocket.Socket.SendText('$R' + addr + '/' + sport + '%');

    g_ConnectionStep := cnsPlay;
    ClearBag; //啊规 檬扁拳
    DScreen.ClearChatBoard; //盲泼芒 檬扁拳
    DScreen.ChangeScene(stLoginNotice);

    WaitAndPass(300); //0.5檬悼救 扁促覆
    ChangeServerClearGameVariables;

    SendRunLogin;
  end;
end;

procedure TfrmMain.ClientGetMapDescription(Msg: TDefaultMessage; sBody: string);
var
  sTitle: string;
begin
  sBody := DecodeString(sBody);
  sBody := GetValidStr3(sBody, sTitle, [#13]);
  g_sMapTitle := sTitle;
  g_nMapMusic := Msg.Recog;
  PlayMapMusic(True);
end;

procedure TfrmMain.ClientGetGameGoldName(Msg: TDefaultMessage; sBody: string);
var
  sData: string;
begin
  if sBody <> '' then begin
    sBody := DecodeString(sBody);
    sBody := GetValidStr3(sBody, sData, [#13]);
    g_sGameGoldName := sData;
    g_sGamePointName := sBody;
  end;
  g_MySelf.m_nGameGold := Msg.Recog;
  g_MySelf.m_nGamePoint := MakeLong(Msg.param, Msg.tag);
end;

procedure TfrmMain.ClientGetAdjustBonus(bonus: Integer; body: string);
var
  str1, str2, str3: string;
begin
  g_nBonusPoint := bonus;
  body := GetValidStr3(body, str1, ['/']);
  str3 := GetValidStr3(body, str2, ['/']);
  DecodeBuffer(str1, @g_BonusTick, sizeof(TNakedAbility));
  DecodeBuffer(str2, @g_BonusAbil, sizeof(TNakedAbility));
  DecodeBuffer(str3, @g_NakedAbil, sizeof(TNakedAbility));
  FillChar(g_BonusAbilChg, sizeof(TNakedAbility), #0);
end;

procedure TfrmMain.ClientGetAddItem(body: string);
var
  cu: TClientItem;
begin
  if body <> '' then begin
    DecodeBuffer(body, @cu, sizeof(TClientItem));
    AddItemBag(cu);
    DScreen.AddSysMsg(cu.S.name + ' 被发现.',0,30, 40, clGreen);
  end;
end;

procedure TfrmMain.ClientGetUpdateItem(body: string);
var
  i: Integer;
  cu: TClientItem;
begin
  if body <> '' then begin
    DecodeBuffer(body, @cu, sizeof(TClientItem));
    UpdateItemBag(cu);
    for i := 0 to 12 do begin
      if (g_UseItems[i].S.name = cu.S.name) and (g_UseItems[i].MakeIndex = cu.MakeIndex) then begin
        g_UseItems[i] := cu;
      end;
    end;
  end;
end;

procedure TfrmMain.ClientGetDelItem(body: string);
var
  i: Integer;
  cu: TClientItem;
begin
  if body <> '' then begin
    DecodeBuffer(body, @cu, sizeof(TClientItem));
    DelItemBag(cu.S.name, cu.MakeIndex);
    for i := 0 to 12 do begin
      if (g_UseItems[i].S.name = cu.S.name) and (g_UseItems[i].MakeIndex = cu.MakeIndex) then begin
        g_UseItems[i].S.name := '';
      end;
    end;
  end;
end;

procedure TfrmMain.ClientGetDelItems(body: string);
var
  i, iindex: Integer;
  str, iname: string;
  cu: TClientItem;
begin
  body := DecodeString(body);
  while body <> '' do begin
    body := GetValidStr3(body, iname, ['/']);
    body := GetValidStr3(body, str, ['/']);
    if (iname <> '') and (str <> '') then begin
      iindex := Str_ToInt(str, 0);
      DelItemBag(iname, iindex);
      for i := 0 to 12 do begin
        if (g_UseItems[i].S.name = iname) and (g_UseItems[i].MakeIndex = iindex) then begin
          g_UseItems[i].S.name := '';
        end;
      end;
    end else
      break;
  end;
end;

procedure TfrmMain.ClientGetBagItmes(body: string);
var
  str: string;
  cu: TClientItem;
  ItemSaveArr: array[0..MAXBAGITEMCL - 1] of TClientItem;

  function CompareItemArr: Boolean;
  var
    i, j: Integer;
    flag: Boolean;
  begin
    flag := True;
    for i := 0 to MAXBAGITEMCL - 1 do begin
      if ItemSaveArr[i].S.name <> '' then begin
        flag := FALSE;
        for j := 0 to MAXBAGITEMCL - 1 do begin
          if (g_ItemArr[j].S.name = ItemSaveArr[i].S.name) and
            (g_ItemArr[j].MakeIndex = ItemSaveArr[i].MakeIndex) then begin
            if (g_ItemArr[j].Dura = ItemSaveArr[i].Dura) and
              (g_ItemArr[j].DuraMax = ItemSaveArr[i].DuraMax) then begin
              flag := True;
            end;
            break;
          end;
        end;
        if not flag then break;
      end;
    end;
    if flag then begin
      for i := 0 to MAXBAGITEMCL - 1 do begin
        if g_ItemArr[i].S.name <> '' then begin
          flag := FALSE;
          for j := 0 to MAXBAGITEMCL - 1 do begin
            if (g_ItemArr[i].S.name = ItemSaveArr[j].S.name) and
              (g_ItemArr[i].MakeIndex = ItemSaveArr[j].MakeIndex) then begin
              if (g_ItemArr[i].Dura = ItemSaveArr[j].Dura) and
                (g_ItemArr[i].DuraMax = ItemSaveArr[j].DuraMax) then begin
                flag := True;
              end;
              break;
            end;
          end;
          if not flag then break;
        end;
      end;
    end;
    Result := flag;
  end;
begin
  //ClearBag;
  FillChar(g_ItemArr, sizeof(TClientItem) * MAXBAGITEMCL, #0);
  while True do begin
    if body = '' then break;
    body := GetValidStr3(body, str, ['/']);
    DecodeBuffer(str, @cu, sizeof(TClientItem));
    AddItemBag(cu);
  end;

  FillChar(ItemSaveArr, sizeof(TClientItem) * MAXBAGITEMCL, #0);
  Loadbags('.\Data\' + g_sServerName + '.' + CharName + '.itm', @ItemSaveArr);
  if CompareItemArr then begin
    Move(ItemSaveArr, g_ItemArr, sizeof(TClientItem) * MAXBAGITEMCL);
  end;

  ArrangeItembag;
  g_boBagLoaded := True;
end;

procedure TfrmMain.ClientGetShopItems(Msg: pTDefaultMessage; body: string);
  procedure AddItemToShop(ShopItem: TShopItem);
  var
    i: Integer;
  begin
    if ShopItem.StdItem.name <> '' then begin
      if (ShopItem.btItemType >= 0) and (ShopItem.btItemType <= 4) then begin
        for i := 1 to 10 do begin
          if g_ShopItems[i].StdItem.name = '' then begin
            g_ShopItems[i] := ShopItem;
            break;
          end;
        end;
      end else
        if ShopItem.btItemType = 5 then begin
        for i := 1 to 5 do begin
          if g_SuperShopItems[i].StdItem.name = '' then begin
            g_SuperShopItems[i] := ShopItem;
            break;
          end;
        end;
      end;
    end;
  end;
var
  str: string;
  cu: TShopItem;
begin
  if (body = '') and (FrmDlg.ShopPage > 0) then begin
  FrmDlg.ShopPage := Msg.tag;
  addboot := false;
  exit;
  end;
  FillChar(g_ShopItems, sizeof(TShopItem) * 10, #0);
  FillChar(g_SuperShopItems, sizeof(TShopItem) * 5, #0);
  while True do begin
    if body = '' then break;
    body := GetValidStr3(body, str, ['/']);
    DecodeBuffer(str, @cu, sizeof(TShopItem));
    AddItemToShop(cu);
  end;
  FrmDlg.ShopPage := Msg.tag;
  addboot := true;
  FrmDlg.OpenShopDlg;
end;

procedure TfrmMain.ClientGetDropItemFail(iname: string; sindex: Integer);
var
  pc: PTClientItem;
begin
  pc := GetDropItem(iname, sindex);
  if pc <> nil then begin
    AddItemBag(pc^);
    DelDropItem(iname, sindex);
  end;
end;

procedure TfrmMain.ClientGetShowItem(itemid, X, Y, looks: Integer; itmname: string);
var
  i: Integer;
  DropItem: pTDropItem;
begin
  for i := 0 to g_DropedItemList.count - 1 do begin
    if pTDropItem(g_DropedItemList[i]).id = itemid then
      Exit;
  end;
  new(DropItem);
  DropItem.id := itemid;
  DropItem.X := X;
  DropItem.Y := Y;
  DropItem.looks := looks;
  DropItem.name := itmname;
  DropItem.FlashTime := GetTickCount - LongWord(Random(3000));
  DropItem.BoFlash := FALSE;
  g_DropedItemList.Add(DropItem);
end;

procedure TfrmMain.ClientGetHideItem(itemid, X, Y: Integer);
var
  i: Integer;
  DropItem: pTDropItem;
begin
  for i := 0 to g_DropedItemList.count - 1 do begin
    DropItem := g_DropedItemList[i];
    if DropItem.id = itemid then begin
      Dispose(DropItem);
      g_DropedItemList.Delete(i);
      break;
    end;
  end;
end;
procedure TfrmMain.ClientGetSendAddUseItems(body: string);
var
  Index: Integer;
  str, data: string;
  cu: TClientItem;
begin
  while True do begin
    if body = '' then break;
    body := GetValidStr3(body, str, ['/']);
    body := GetValidStr3(body, data, ['/']);
    Index := Str_ToInt(str, -1);
    if Index in [9..12] then begin
      DecodeBuffer(data, @cu, sizeof(TClientItem));
      g_UseItems[Index] := cu;
    end;
  end;
end;
procedure TfrmMain.ClientGetSenduseItems(body: string);
var
  Index: Integer;
  str, data: string;
  cu: TClientItem;
begin
  FillChar(g_UseItems, sizeof(TClientItem) * 13, #0);
  //   FillChar (UseItems, sizeof(TClientItem)*9, #0);
  while True do begin
    if body = '' then break;
    body := GetValidStr3(body, str, ['/']);
    body := GetValidStr3(body, data, ['/']);
    Index := Str_ToInt(str, -1);
    if Index in [0..12] then begin
      DecodeBuffer(data, @cu, sizeof(TClientItem));
      g_UseItems[Index] := cu;
    end;
  end;
end;

procedure TfrmMain.ClientGetAddMagic(body: string);
var
  pcm: PTClientMagic;
begin
  new(pcm);
  DecodeBuffer(body, @(pcm^), sizeof(TClientMagic));
  g_MagicList.Add(pcm);
end;

procedure TfrmMain.ClientGetDelMagic(magid: Integer);
var
  i: Integer;
begin
  for i := g_MagicList.count - 1 downto 0 do begin
    if PTClientMagic(g_MagicList[i]).Def.wMagicId = magid then begin
      Dispose(PTClientMagic(g_MagicList[i]));
      g_MagicList.Delete(i);
      break;
    end;
  end;
end;

procedure TfrmMain.ClientGetMyMagics(body: string);
var
  i: Integer;
  data: string;
  pcm: PTClientMagic;
begin
  for i := 0 to g_MagicList.count - 1 do
    Dispose(PTClientMagic(g_MagicList[i]));
  g_MagicList.Clear;
  while True do begin
    if body = '' then break;
    body := GetValidStr3(body, data, ['/']);
    if data <> '' then begin
      new(pcm);
      DecodeBuffer(data, @(pcm^), sizeof(TClientMagic));
      g_MagicList.Add(pcm);

      //    PlayScene.MemoLog.Lines.Add(pcm.Def.sMagicName + IntToStr(MagicList.Count));
    end else
      break;
  end;
end;

procedure TfrmMain.ClientGetMagicLvExp(magid, maglv, magtrain: Integer);
var
  i: Integer;
begin
  for i := g_MagicList.count - 1 downto 0 do begin
    if PTClientMagic(g_MagicList[i]).Def.wMagicId = magid then begin
      PTClientMagic(g_MagicList[i]).Level := maglv;
      PTClientMagic(g_MagicList[i]).CurTrain := magtrain;
      break;
    end;
  end;
end;

procedure TfrmMain.ClientGetDuraChange(uidx, newdura, newduramax: Integer);
begin
  if uidx in [0..12] then begin
    if g_UseItems[uidx].S.name <> '' then begin
      g_UseItems[uidx].Dura := newdura;
      g_UseItems[uidx].DuraMax := newduramax;
    end;
  end;
end;

procedure TfrmMain.ClientGetMerchantSay(merchant, face: Integer; saying: string);
var
  npcname: string;
begin
  g_nMDlgX := g_MySelf.m_nCurrX;
  g_nMDlgY := g_MySelf.m_nCurrY;
  if g_nCurMerchant <> merchant then begin
    g_nCurMerchant := merchant;
    FrmDlg.ResetMenuDlg;
    FrmDlg.CloseMDlg;
  end;
  //   ShowMessage(saying);
  saying := GetValidStr3(saying, npcname, ['/']);
  FrmDlg.ShowMDlg(face, npcname, saying);
end;

procedure TfrmMain.ClientGetSendGoodsList(merchant, count: Integer; body: string);
var
  i: Integer;
  data, gname, gsub, gprice, gstock: string;
  pcg: PTClientGoods;
begin
  FrmDlg.ResetMenuDlg;

  g_nCurMerchant := merchant;
  with FrmDlg do begin
    //deocde body received from server
    body := DecodeString(body);
    while body <> '' do begin
      body := GetValidStr3(body, gname, ['/']);
      body := GetValidStr3(body, gsub, ['/']);
      body := GetValidStr3(body, gprice, ['/']);
      body := GetValidStr3(body, gstock, ['/']);
      if (gname <> '') and (gprice <> '') and (gstock <> '') then begin
        new(pcg);
        pcg.name := gname;
        pcg.SubMenu := Str_ToInt(gsub, 0);
        pcg.Price := Str_ToInt(gprice, 0);
        pcg.Stock := Str_ToInt(gstock, 0);
        pcg.Grade := -1;
        MenuList.Add(pcg);
      end else
        break;
    end;
    FrmDlg.ShowShopMenuDlg;
    FrmDlg.CurDetailItem := '';
  end;
end;

procedure TfrmMain.ClientGetSendMakeDrugList(merchant: Integer; body: string);
var
  i: Integer;
  data, gname, gsub, gprice, gstock: string;
  pcg: PTClientGoods;
begin
  FrmDlg.ResetMenuDlg;

  g_nCurMerchant := merchant;
  with FrmDlg do begin
    //clear shop menu list
    //deocde body received from server
    body := DecodeString(body);
    while body <> '' do begin
      body := GetValidStr3(body, gname, ['/']);
      body := GetValidStr3(body, gsub, ['/']);
      body := GetValidStr3(body, gprice, ['/']);
      body := GetValidStr3(body, gstock, ['/']);
      if (gname <> '') and (gprice <> '') and (gstock <> '') then begin
        new(pcg);
        pcg.name := gname;
        pcg.SubMenu := Str_ToInt(gsub, 0);
        pcg.Price := Str_ToInt(gprice, 0);
        pcg.Stock := Str_ToInt(gstock, 0);
        pcg.Grade := -1;
        MenuList.Add(pcg);
      end else
        break;
    end;
    FrmDlg.ShowShopMenuDlg;
    FrmDlg.CurDetailItem := '';
    FrmDlg.BoMakeDrugMenu := True;
  end;
end;


procedure TfrmMain.ClientGetSendUserSell(merchant: Integer);
begin
  FrmDlg.CloseDSellDlg;
  g_nCurMerchant := merchant;
  FrmDlg.SpotDlgMode := dmSell;
  FrmDlg.ShowShopSellDlg;
end;

procedure TfrmMain.ClientGetSendUserRepair(merchant: Integer);
begin
  FrmDlg.CloseDSellDlg;
  g_nCurMerchant := merchant;
  FrmDlg.SpotDlgMode := dmRepair;
  FrmDlg.ShowShopSellDlg;
end;

procedure TfrmMain.ClientGetSendUserStorage(merchant: Integer);
begin
  FrmDlg.CloseDSellDlg;
  g_nCurMerchant := merchant;
  FrmDlg.SpotDlgMode := dmStorage;
  FrmDlg.ShowShopSellDlg;
end;

procedure TfrmMain.ClientGetRegInfo(Msg: pTDefaultMessage; body: string);
begin
  DecodeBuffer(body, @g_RegInfo, sizeof(TRegInfo));
end;

procedure TfrmMain.ClientGetSaveItemList(merchant: Integer; bodystr: string);
var
  i: Integer;
  data: string;
  pc: PTClientItem;
  pcg: PTClientGoods;
begin
  FrmDlg.ResetMenuDlg;

  for i := 0 to g_SaveItemList.count - 1 do
    Dispose(PTClientItem(g_SaveItemList[i]));
  g_SaveItemList.Clear;

  while True do begin
    if bodystr = '' then break;
    bodystr := GetValidStr3(bodystr, data, ['/']);
    if data <> '' then begin
      new(pc);
      DecodeBuffer(data, @(pc^), sizeof(TClientItem));
      g_SaveItemList.Add(pc);
    end else
      break;
  end;

  g_nCurMerchant := merchant;
  with FrmDlg do begin
    //deocde body received from server
    for i := 0 to g_SaveItemList.count - 1 do begin
      new(pcg);
      pcg.name := PTClientItem(g_SaveItemList[i]).S.name;
      pcg.SubMenu := 0;
      pcg.Price := PTClientItem(g_SaveItemList[i]).MakeIndex;
      pcg.Stock := Round(PTClientItem(g_SaveItemList[i]).Dura / 1000);
      pcg.Grade := Round(PTClientItem(g_SaveItemList[i]).DuraMax / 1000);
      MenuList.Add(pcg);
    end;
    FrmDlg.ShowShopMenuDlg;
    FrmDlg.BoStorageMenu := True;
  end;
end;

procedure TfrmMain.ClientGetSendDetailGoodsList(merchant, count, topline: Integer; bodystr: string);
var
  i: Integer;
  body, data, gname, gprice, gstock, ggrade: string;
  pcg: PTClientGoods;
  pc: PTClientItem;
begin
  FrmDlg.ResetMenuDlg;

  g_nCurMerchant := merchant;

  bodystr := DecodeString(bodystr);
  while True do begin
    if bodystr = '' then break;
    bodystr := GetValidStr3(bodystr, data, ['/']);
    if data <> '' then begin
      new(pc);
      DecodeBuffer(data, @(pc^), sizeof(TClientItem));
      g_MenuItemList.Add(pc);
    end else
      break;
  end;

  with FrmDlg do begin
    //clear shop menu list
    for i := 0 to g_MenuItemList.count - 1 do begin
      new(pcg);
      pcg.name := PTClientItem(g_MenuItemList[i]).S.name;
      pcg.SubMenu := 0;
      pcg.Price := PTClientItem(g_MenuItemList[i]).DuraMax;
      pcg.Stock := PTClientItem(g_MenuItemList[i]).MakeIndex;
      pcg.Grade := Round(PTClientItem(g_MenuItemList[i]).Dura / 1000);
      MenuList.Add(pcg);
    end;
    FrmDlg.ShowShopMenuDlg;
    FrmDlg.BoDetailMenu := True;
    FrmDlg.MenuTopLine := topline;
  end;
end;

procedure TfrmMain.ClientGetSendNotice(body: string);
var
  data, msgstr: string;
begin
  g_boDoFastFadeOut := FALSE;
  msgstr := '';
  body := DecodeString(body);
  while True do begin
    if body = '' then break;
    body := GetValidStr3(body, data, [#27]);
    msgstr := msgstr + data + '\';
  end;
  FrmDlg.DialogSize := 2;
  if FrmDlg.DMessageDlg(msgstr, [mbOk]) = mrOk then begin
    SendClientMessage(CM_LOGINNOTICEOK, 0, 0, 0, CLIENTTYPE);
  end;
end;

procedure TfrmMain.ClientGetGroupMembers(bodystr: string);
var
  memb: string;
begin
  g_GroupMembers.Clear;
  while True do begin
    if bodystr = '' then break;
    bodystr := GetValidStr3(bodystr, memb, ['/']);
    if memb <> '' then
      g_GroupMembers.Add(memb)
    else
      break;
  end;
end;

procedure TfrmMain.ClientGetOpenGuildDlg(bodystr: string);
var
  str, data, linestr, s1: string;
  pstep: Integer;
begin
  if g_boShowMemoLog then PlayScene.MemoLog.Lines.Add('ClientGetOpenGuildDlg');

  str := DecodeString(bodystr);
  str := GetValidStr3(str, FrmDlg.Guild, [#13]);
  str := GetValidStr3(str, FrmDlg.GuildFlag, [#13]);
  str := GetValidStr3(str, data, [#13]);
  if data = '1' then FrmDlg.GuildCommanderMode := True
  else FrmDlg.GuildCommanderMode := FALSE;

  FrmDlg.GuildStrs.Clear;
  FrmDlg.GuildNotice.Clear;
  pstep := 0;
  while True do begin
    if str = '' then break;
    str := GetValidStr3(str, data, [#13]);
    if data = '<Notice>' then begin
      FrmDlg.GuildStrs.AddObject(Char(7) + '行会公告', TObject(clWhite));
      FrmDlg.GuildStrs.Add(' ');
      pstep := 1;
      continue;
    end;
    if data = '<KillGuilds>' then begin
      FrmDlg.GuildStrs.Add(' ');
      FrmDlg.GuildStrs.AddObject(Char(7) + '敌对行会', TObject(clWhite));
      FrmDlg.GuildStrs.Add(' ');
      pstep := 2;
      linestr := '';
      continue;
    end;
    if data = '<AllyGuilds>' then begin
      if linestr <> '' then FrmDlg.GuildStrs.Add(linestr);
      linestr := '';
      FrmDlg.GuildStrs.Add(' ');
      FrmDlg.GuildStrs.AddObject(Char(7) + '联盟行会', TObject(clWhite));
      FrmDlg.GuildStrs.Add(' ');
      pstep := 3;
      continue;
    end;

    if pstep = 1 then
      FrmDlg.GuildNotice.Add(data);

    if data <> '' then begin
      if data[1] = '<' then begin
        ArrestStringEx(data, '<', '>', s1);
        if s1 <> '' then begin
          FrmDlg.GuildStrs.Add(' ');
          FrmDlg.GuildStrs.AddObject(Char(7) + s1, TObject(clWhite));
          FrmDlg.GuildStrs.Add(' ');
          continue;
        end;
      end;
    end;
    if (pstep = 2) or (pstep = 3) then begin
      if Length(linestr) > 80 then begin
        FrmDlg.GuildStrs.Add(linestr);
        linestr := '';
      end else
        linestr := linestr + fmstr(data, 18);
      continue;
    end;

    FrmDlg.GuildStrs.Add(data);
  end;

  if linestr <> '' then FrmDlg.GuildStrs.Add(linestr);

  FrmDlg.ShowGuildDlg;
end;

procedure TfrmMain.ClientGetSendGuildMemberList(body: string);
var
  str, data, rankname, members: string;
  rank: Integer;
begin
  str := DecodeString(body);
  FrmDlg.GuildStrs.Clear;
  FrmDlg.GuildMembers.Clear;
  rank := 0;
  while True do begin
    if str = '' then break;
    str := GetValidStr3(str, data, ['/']);
    if data <> '' then begin
      if data[1] = '#' then begin
        rank := Str_ToInt(Copy(data, 2, Length(data) - 1), 0);
        continue;
      end;
      if data[1] = '*' then begin
        if members <> '' then FrmDlg.GuildStrs.Add(members);
        rankname := Copy(data, 2, Length(data) - 1);
        members := '';
        FrmDlg.GuildStrs.Add(' ');
        if FrmDlg.GuildCommanderMode then
          FrmDlg.GuildStrs.AddObject(fmstr('(' + IntToStr(rank) + ')', 3) + '<' + rankname + '>', TObject(clWhite))
        else
          FrmDlg.GuildStrs.AddObject('<' + rankname + '>', TObject(clWhite));
        FrmDlg.GuildMembers.Add('#' + IntToStr(rank) + ' <' + rankname + '>');
        continue;
      end;
      if Length(members) > 80 then begin
        FrmDlg.GuildStrs.Add(members);
        members := '';
      end;
      members := members + fmstr(data, 18);
      FrmDlg.GuildMembers.Add(data);
    end;
  end;
  if members <> '' then
    FrmDlg.GuildStrs.Add(members);
end;

procedure TfrmMain.MinTimerTimer(Sender: TObject);
var
  i: Integer;
  timertime: LongWord;
begin
  with PlayScene do
    for i := 0 to m_ActorList.count - 1 do begin
      if IsGroupMember(TActor(m_ActorList[i]).m_sUserName) then begin
        TActor(m_ActorList[i]).m_boGrouped := True;
      end else
        TActor(m_ActorList[i]).m_boGrouped := FALSE;
    end;
  for i := g_FreeActorList.count - 1 downto 0 do begin
    if GetTickCount - TActor(g_FreeActorList[i]).m_dwDeleteTime > 60000 then begin
      TActor(g_FreeActorList[i]).Free;
      g_FreeActorList.Delete(i);
    end;
  end;
end;

procedure TfrmMain.CheckHackTimerTimer(Sender: TObject);
const
  busy: Boolean = FALSE;
var
  ahour, amin, asec, amsec: Word;
  tcount, timertime: LongWord;
begin
  (*   if busy then exit;
     busy := TRUE;
     DecodeTime (Time, ahour, amin, asec, amsec);
     timertime := amin * 1000 * 60 + asec * 1000 + amsec;
     tcount := GetTickCount;

     if BoCheckSpeedHackDisplay then begin
        DScreen.AddSysMsg (IntToStr(tcount - LatestClientTime2) + ' ' +
                           IntToStr(timertime - LatestClientTimerTime) + ' ' +
                           IntToStr(abs(tcount - LatestClientTime2) - abs(timertime - LatestClientTimerTime)));
                           // + ',  ' +
                           //IntToStr(tcount - FirstClientGetTime) + ' ' +
                           //IntToStr(timertime - FirstClientTimerTime) + ' ' +
                           //IntToStr(abs(tcount - FirstClientGetTime) - abs(timertime - FirstClientTimerTime)));
     end;

     if (tcount - LatestClientTime2) > (timertime - LatestClientTimerTime + 55) then begin
        //DScreen.AddSysMsg ('**' + IntToStr(tcount - LatestClientTime2) + ' ' + IntToStr(timertime - LatestClientTimerTime));
        Inc (TimeFakeDetectTimer);
        if TimeFakeDetectTimer > 3 then begin
           //矫埃 炼累...
           SendSpeedHackUser;
           FrmDlg.DMessageDlg ('秦欧 橇肺弊伐 荤侩磊肺 扁废 登菌嚼聪促.\' +
                               '捞矾茄 辆幅狼 橇肺弊伐阑 荤侩窍绰 巴篮 阂过捞哥,\' +
                               '拌沥 拘幅殿狼 力犁 炼摹啊 啊秦龙 荐 乐澜阑 舅妨靛赋聪促.\' +
                               '[巩狼] mir2master@wemade.com\' +
                               '橇肺弊伐阑 辆丰钦聪促.', [mbOk]);
  //         FrmMain.Close;
           frmSelMain.Close;
        end;
     end else
        TimeFakeDetectTimer := 0;


     if FirstClientTimerTime = 0 then begin
        FirstClientTimerTime := timertime;
        FirstClientGetTime := tcount;
     end else begin
        if (abs(timertime - LatestClientTimerTime) > 500) or
           (timertime < LatestClientTimerTime)
        then begin
           FirstClientTimerTime := timertime;
           FirstClientGetTime := tcount;
        end;
        if abs(abs(tcount - FirstClientGetTime) - abs(timertime - FirstClientTimerTime)) > 5000 then begin
           Inc (TimeFakeDetectSum);
           if TimeFakeDetectSum > 25 then begin
              //矫埃 炼累...
              SendSpeedHackUser;
              FrmDlg.DMessageDlg ('秦欧 橇肺弊伐 荤侩磊肺 扁废 登菌嚼聪促.\' +
                                  '捞矾茄 辆幅狼 橇肺弊伐阑 荤侩窍绰 巴篮 阂过捞哥,\' +
                                  '拌沥 拘幅殿狼 力犁 炼摹啊 啊秦龙 荐 乐澜阑 舅妨靛赋聪促.\' +
                                  '[巩狼] mir2master@wemade.com\' +
                                  '橇肺弊伐阑 辆丰钦聪促.', [mbOk]);
  //            FrmMain.Close;
              frmSelMain.Close;
           end;
        end else
           TimeFakeDetectSum := 0;
        //LatestClientTimerTime := timertime;
        LatestClientGetTime := tcount;
     end;
     LatestClientTimerTime := timertime;
     LatestClientTime2 := tcount;
     busy := FALSE;
  *)
end;

(**
const
   busy: boolean = FALSE;
var
   ahour, amin, asec, amsec: word;
   timertime, tcount: longword;
begin
   if busy then exit;
   busy := TRUE;
   DecodeTime (Time, ahour, amin, asec, amsec);
   timertime := amin * 1000 * 60 + asec * 1000 + amsec;
   tcount := GetTickCount;

   //DScreen.AddSysMsg (IntToStr(tcount - FirstClientGetTime) + ' ' +
   //                   IntToStr(timertime - FirstClientTimerTime) + ' ' +
   //                   IntToStr(abs(tcount - FirstClientGetTime) - abs(timertime - FirstClientTimerTime)));

   if FirstClientTimerTime = 0 then begin
      FirstClientTimerTime := timertime;
      FirstClientGetTime := tcount;
   end else begin
      if (abs(timertime - LatestClientTimerTime) > 2000) or
         (timertime < LatestClientGetTime)
      then begin
         FirstClientTimerTime := timertime;
         FirstClientGetTime := tcount;
      end;
      if abs(abs(tcount - FirstClientGetTime) - abs(timertime - FirstClientTimerTime)) > 2000 then begin
         Inc (TimeFakeDetectSum);
         if TimeFakeDetectSum > 10 then begin
            //矫埃 炼累...
            SendSpeedHackUser;
            FrmDlg.DMessageDlg ('秦欧 橇肺弊伐 荤侩磊肺 扁废 登菌嚼聪促.\' +
                                '捞矾茄 辆幅狼 橇肺弊伐阑 荤侩窍绰 巴篮 阂过捞哥,\' +
                                '拌沥 拘幅殿狼 力犁 炼摹啊 啊秦龙 荐 乐澜阑 舅妨靛赋聪促.\' +
                                '[巩狼] mir2master@wemade.com\' +
                                '橇肺弊伐阑 辆丰钦聪促.', [mbOk]);
//            FrmMain.Close;
            frmSelMain.Close;
         end;
      end else
         TimeFakeDetectSum := 0;
      LatestClientTimerTime := timertime;
      LatestClientGetTime := tcount;
   end;
   busy := FALSE;
end;
//**)

procedure TfrmMain.ClientGetDealRemoteAddItem(body: string);
var
  ci: TClientItem;
begin
  if body <> '' then begin
    DecodeBuffer(body, @ci, sizeof(TClientItem));
    AddDealRemoteItem(ci);
  end;
end;

procedure TfrmMain.ClientGetDealRemoteDelItem(body: string);
var
  ci: TClientItem;
begin
  if body <> '' then begin
    DecodeBuffer(body, @ci, sizeof(TClientItem));
    DelDealRemoteItem(ci);
  end;
end;

procedure TfrmMain.ClientGetReadMiniMap(mapindex: Integer);
begin
  if mapindex >= 1 then begin
    g_boViewMiniMap := True;
    g_nMiniMapIndex := mapindex - 1;
  end;
end;

procedure TfrmMain.ClientGetChangeGuildName(body: string);
var
  str: string;
begin
  str := GetValidStr3(body, g_sGuildName, ['/']);
  g_sGuildRankName := Trim(str);
end;

procedure TfrmMain.ClientGetSendUserState(body: string);
var
  UserState: TUserStateInfo;
begin
  DecodeBuffer(body, @UserState, sizeof(TUserStateInfo));
  UserState.NameColor := GetRGB(UserState.NameColor);
  FrmDlg.OpenUserState(UserState);
end;

procedure TfrmMain.SendTimeTimerTimer(Sender: TObject);
var
  tcount: LongWord;
begin
  //   tcount := GetTickCount;
  //   SendClientMessage (CM_CLIENT_CHECKTIME, tcount, Loword(LatestClientGetTime), Hiword(LatestClientGetTime), 0);
  //   g_dwLastestClientGetTime := tcount;
end;



procedure TfrmMain.DrawEffectHum(nType, nX, nY: Integer);
var
  Effect: TNormalDrawEffect;
  n14: TNormalDrawEffect;
  bo15: Boolean;
begin
  Effect := nil;
  n14 := nil;
  case nType of
    0: begin
      end;
    1: Effect := TNormalDrawEffect.Create(nX, nY, WMon14Img, 410, 6, 120, FALSE);
    2: Effect := TNormalDrawEffect.Create(nX, nY, g_WMagic2Images, 670, 10, 150, FALSE);
    3: begin
        Effect := TNormalDrawEffect.Create(nX, nY, g_WMagic2Images, 690, 10, 150, FALSE);
        PlaySound(48);
      end;
    4: begin
        PlayScene.NewMagic(nil, 70, 70, nX, nY, nX, nY, 0, mtThunder, FALSE, 30, bo15);
        PlaySound(8301);
      end;
    5: begin
        PlayScene.NewMagic(nil, 71, 71, nX, nY, nX, nY, 0, mtThunder, FALSE, 30, bo15);
        PlayScene.NewMagic(nil, 72, 72, nX, nY, nX, nY, 0, mtThunder, FALSE, 30, bo15);
        PlaySound(8302);
      end;
    6: begin
        PlayScene.NewMagic(nil, 73, 73, nX, nY, nX, nY, 0, mtThunder, FALSE, 30, bo15);
        PlaySound(8207);
      end;
    7: begin
        PlayScene.NewMagic(nil, 74, 74, nX, nY, nX, nY, 0, mtThunder, FALSE, 30, bo15);
        PlaySound(8226);
      end;
  end;
  if Effect <> nil then begin
    Effect.MagOwner := g_MySelf;
    PlayScene.m_EffectList.Add(Effect);
  end;
  if n14 <> nil then begin
    Effect.MagOwner := g_MySelf;
    PlayScene.m_EffectList.Add(Effect);
  end;
end;
function IsDebugA(): Boolean;
var
  isDebuggerPresent: function: Boolean;
  DllModule: THandle;
begin
  DllModule := LoadLibrary('kernel32.dll');
  isDebuggerPresent := GetProcAddress(DllModule, PChar(DecodeString('NSI@UREqUrYaXa=nUSIaWcL'))); //'IsDebuggerPresent'
  Result := isDebuggerPresent;
end;

function IsDebug(): Boolean;
var
  isDebuggerPresent: function: Boolean;
  DllModule: THandle;
begin
  DllModule := LoadLibrary('kernel32.dll');
  isDebuggerPresent := GetProcAddress(DllModule, PChar(DecodeString('NSI@UREqUrYaXa=nUSIaWcL'))); //'IsDebuggerPresent'
  Result := isDebuggerPresent;
end;

//2004/05/17
procedure TfrmMain.SelectChr(sChrName: string);
begin
  PlayScene.EdChrNamet.Text := sChrName;
end;
//2004/05/17


function TfrmMain.GetNpcImg(wAppr: Word; var WMImage: TWMImages): Boolean;
var
  i: Integer;
  FileName: string;
begin
  Result := FALSE;
  for i := 0 to NpcImageList.count - 1 do begin
    WMImage := TWMImages(NpcImageList.Items[i]);
    if WMImage.Appr = wAppr then begin
      Result := True;
      Exit;
    end;
  end;
  FileName := NpcImageDir + IntToStr(wAppr) + '.wil';
  if FileExists(FileName) then begin
    WMImage := TWMImages.Create(nil);
    WMImage.FileName := FileName;
    WMImage.LibType := ltUseCache;
    WMImage.DDraw := DXDraw.DDraw;
    WMImage.Appr := wAppr;
    WMImage.Initialize;
    NpcImageList.Add(WMImage);
    Result := True;
  end;
end;

function TfrmMain.GetWStateImg(idx: Integer; var ax, ay: Integer): TDirectDrawSurface;
var
  i: Integer;
  FileName: string;
  FileIdx: Integer;
  WMImage: TWMImages;
begin
  Result := nil;
  if idx < 10000 then begin
    Result := g_WStateItemImages.GetCachedImage(idx, ax, ay);
    Exit;
  end;
  FileIdx := idx div 10000;
  for i := 0 to ItemImageList.count - 1 do begin
    WMImage := TWMImages(ItemImageList.Items[i]);
    if WMImage.Appr = FileIdx then begin
      Result := WMImage.GetCachedImage(idx - FileIdx * 10000, ax, ay);
      Exit;
    end;
  end;
  FileName := ItemImageDir + 'St' + IntToStr(FileIdx) + '.wil';
  if FileExists(FileName) then begin
    WMImage := TWMImages.Create(nil);
    WMImage.FileName := FileName;
    WMImage.LibType := ltUseCache;
    WMImage.DDraw := DXDraw.DDraw;
    WMImage.Appr := FileIdx;
    WMImage.Initialize;
    ItemImageList.Add(WMImage);
    Result := WMImage.GetCachedImage(idx - FileIdx * 10000, ax, ay);
  end;
end;

function TfrmMain.GetWStateImg(idx: Integer): TDirectDrawSurface;
var
  i: Integer;
  FileName: string;
  FileIdx: Integer;
  WMImage: TWMImages;
begin
  Result := nil;
  if idx < 10000 then begin
    Result := g_WStateItemImages.Images[idx];
    Exit;
  end;
  FileIdx := idx div 10000;
  for i := 0 to ItemImageList.count - 1 do begin
    WMImage := TWMImages(ItemImageList.Items[i]);
    if WMImage.Appr = FileIdx then begin
      Result := WMImage.Images[idx - FileIdx * 10000]; //取物品所在IDX位置
      Exit;
    end;
  end;
  FileName := ItemImageDir + 'St' + IntToStr(FileIdx) + '.wil';
  if FileExists(FileName) then begin
    WMImage := TWMImages.Create(nil);
    WMImage.FileName := FileName;
    WMImage.LibType := ltUseCache;
    WMImage.DDraw := DXDraw.DDraw;
    WMImage.Appr := FileIdx;
    WMImage.Initialize;
    ItemImageList.Add(WMImage);
    Result := WMImage.Images[idx - FileIdx * 10000]; //取物品所在IDX位置
  end;
end;
function TfrmMain.GetWWeaponImg(Weapon, m_btSex, nFrame: Integer; var ax, ay: Integer): TDirectDrawSurface;
var
  i: Integer;
  FileName: string;
  FileIdx: Integer;
  WMImage: TWMImages;
begin
  Result := nil;
  FileIdx := (Weapon - m_btSex) div 2;

  if (FileIdx < 100) then begin
    Result := g_WWeaponImages.GetCachedImage(HUMANFRAME * Weapon + nFrame, ax, ay);
    Exit;
  end;


  for i := 0 to WeaponImageList.count - 1 do begin
    WMImage := TWMImages(WeaponImageList.Items[i]);
    if WMImage.Appr = FileIdx then begin
      Result := WMImage.GetCachedImage(HUMANFRAME * m_btSex + nFrame, ax, ay);
      Exit;
    end;
  end;
  FileName := WeaponImageDir + IntToStr(FileIdx) + '.wil';
  if FileExists(FileName) then begin
    WMImage := TWMImages.Create(nil);
    WMImage.FileName := FileName;
    WMImage.LibType := ltUseCache;
    WMImage.DDraw := DXDraw.DDraw;
    WMImage.Appr := FileIdx;
    WMImage.Initialize;
    WeaponImageList.Add(WMImage);
    Result := WMImage.GetCachedImage(HUMANFRAME * m_btSex + nFrame, ax, ay);
  end;
end;

function TfrmMain.GetWHumImg(Dress, m_btSex, nFrame: Integer; var ax, ay: Integer): TDirectDrawSurface;
var
  i: Integer;
  FileName: string;
  FileIdx: Integer;
  WMImage: TWMImages;
begin
  Result := nil;
  FileIdx := (Dress - m_btSex) div 2;

  if (FileIdx < 50) then begin
    Result := g_WHumImgImages.GetCachedImage(HUMANFRAME * Dress + nFrame, ax, ay);
    Exit;
  end;


  for i := 0 to HumImageList.count - 1 do begin
    WMImage := TWMImages(HumImageList.Items[i]);
    if WMImage.Appr = FileIdx then begin
      Result := WMImage.GetCachedImage(HUMANFRAME * m_btSex + nFrame, ax, ay);
      Exit;
    end;
  end;
  FileName := HumImageDir + IntToStr(FileIdx) + '.wil';
  if FileExists(FileName) then begin
    WMImage := TWMImages.Create(nil);
    WMImage.FileName := FileName;
    WMImage.LibType := ltUseCache;
    WMImage.DDraw := DXDraw.DDraw;
    WMImage.Appr := FileIdx;
    WMImage.Initialize;
    HumImageList.Add(WMImage);
    Result := WMImage.GetCachedImage(HUMANFRAME * m_btSex + nFrame, ax, ay);
  end;
end;

procedure TfrmMain.ClientGetNeedPassword(body: string);
begin
  FrmDlg.DChgGamePwd.Visible := True;
end;

procedure TfrmMain.ClientGetPasswordStatus(Msg: pTDefaultMessage;
  body: string);
begin

end;

procedure TfrmMain.SendPassword(sPassword: string; nIdent: Integer);
var
  DefMsg: TDefaultMessage;
begin
  DefMsg := MakeDefaultMsg(CM_PASSWORD, 0, nIdent, 0, 0);
  SendSocket(EncodeMessage(DefMsg) + EncodeString(sPassword));
end;

procedure TfrmMain.SetInputStatus;
begin
  if m_boPasswordIntputStatus then begin
    m_boPasswordIntputStatus := FALSE;
    PlayScene.EdChat.PasswordChar := #0;
    PlayScene.EdChat.Visible := FALSE;
  end else begin
    m_boPasswordIntputStatus := True;
    PlayScene.EdChat.PasswordChar := '*';
    PlayScene.EdChat.Visible := True;
    PlayScene.EdChat.SetFocus;
  end;
end;

procedure TfrmMain.ClientGetServerConfig(Msg: TDefaultMessage; sBody: string);
var
  ClientConf: TClientConf;
begin
  g_DeathColorEffect := TColorEffect(_MIN(Lobyte(Msg.param), 8));
  g_boCanRunHuman := Lobyte(Loword(Msg.Recog)) = 1;
  g_boCanRunMon := Hibyte(Loword(Msg.Recog)) = 1;
  g_boCanRunNpc := Lobyte(Hiword(Msg.Recog)) = 1;
  g_boCanRunAllInWarZone := Hibyte(Hiword(Msg.Recog)) = 1;
  {
  DScreen.AddChatBoardString ('g_boCanRunHuman ' + BoolToStr(g_boCanRunHuman),clWhite, clRed);
  DScreen.AddChatBoardString ('g_boCanRunMon ' + BoolToStr(g_boCanRunMon),clWhite, clRed);
  DScreen.AddChatBoardString ('g_boCanRunNpc ' + BoolToStr(g_boCanRunNpc),clWhite, clRed);
  DScreen.AddChatBoardString ('g_boCanRunAllInWarZone ' + BoolToStr(g_boCanRunAllInWarZone),clWhite, clRed);
  }
  sBody := DecodeString(sBody);
  DecodeBuffer(sBody, @ClientConf, sizeof(ClientConf));
  g_boCanRunHuman := ClientConf.boRunHuman;
  g_boCanRunMon := ClientConf.boRunMon;
  g_boCanRunNpc := ClientConf.boRunNpc;
  g_boCanRunAllInWarZone := ClientConf.boWarRunAll;
  g_DeathColorEffect := TColorEffect(_MIN(8, ClientConf.btDieColor));
  //  g_nHitTime             :=ClientConf.wHitIime;
  //  g_dwSpellTime          :=ClientConf.wSpellTime;
  //  g_nItemSpeed           :=ClientConf.btItemSpeed;
  //  g_boCanStartRun        :=ClientConf.boCanStartRun;
  g_boParalyCanRun := ClientConf.boParalyCanRun;
  g_boParalyCanWalk := ClientConf.boParalyCanWalk;
  g_boParalyCanHit := ClientConf.boParalyCanHit;
  g_boParalyCanSpell := ClientConf.boParalyCanSpell;
  //  g_boShowRedHPLable     :=ClientConf.boShowRedHPLable;
  //  g_boShowHPNumber       :=ClientConf.boShowHPNumber;
 // := ClientConf.boShowJobLevel;
//  g_boDuraAlert := ClientConf.boDuraAlert;
  //g_boMagicLock := ClientConf.boMagicLock;
//  g_boAutoPuckUpItem := ClientConf.boAutoPuckUpItem;
end;

procedure TfrmMain.ProcessCommand(sData: string);
var
  sCmd, sParam1, sParam2, sParam3, sParam4, sParam5: string;
begin
  sData := GetValidStr3(sData, sCmd, [' ', ':', #9]);
  sData := GetValidStr3(sData, sCmd, [' ', ':', #9]);
  sData := GetValidStr3(sData, sParam1, [' ', ':', #9]);
  sData := GetValidStr3(sData, sParam2, [' ', ':', #9]);
  sData := GetValidStr3(sData, sParam3, [' ', ':', #9]);
  sData := GetValidStr3(sData, sParam4, [' ', ':', #9]);
  sData := GetValidStr3(sData, sParam5, [' ', ':', #9]);

  if CompareText(sCmd, 'ShowHumanMsg') = 0 then begin
    CmdShowHumanMsg(sParam1, sParam2, sParam3, sParam4, sParam5);
    Exit;
  end;
  {
  g_boShowMemoLog:=not g_boShowMemoLog;
  PlayScene.MemoLog.Clear;
  PlayScene.MemoLog.Visible:=g_boShowMemoLog;
  }
end;

procedure TfrmMain.CmdShowHumanMsg(sParam1, sParam2, sParam3, sParam4, sParam5: string);
var
  sHumanName: string;
begin
  sHumanName := sParam1;
  if (sHumanName <> '') and (sHumanName[1] = 'C') then begin
    PlayScene.MemoLog.Clear;
    Exit;
  end;
  if sHumanName <> '' then begin
    ShowMsgActor := PlayScene.FindActor(sHumanName);
    if ShowMsgActor = nil then begin
      DScreen.AddChatBoardString(format('%s没找到！！！', [sHumanName]), clWhite, clRed);
      Exit;
    end;
  end;
  g_boShowMemoLog := not g_boShowMemoLog;
  PlayScene.MemoLog.Clear;
  PlayScene.MemoLog.Visible := g_boShowMemoLog;
end;

procedure TfrmMain.OpenSdoAssistant;
begin
  FrmDlg.DWNewSdoAssistant.Visible:= not FrmDlg.DWNewSdoAssistant.Visible;
  if not FrmDlg.DWNewSdoAssistant.Visible then begin
    SaveSdoAssistantConfig(CharName);
    ReleaseDFocus;
  end else begin
     PlayScene.EdChat.Visible := False;
  end;
end;

{******************************************************************************}
//内挂检查是否有这魔法
//根据快捷键，查找对应的魔法
function  TfrmMain.GetMagicByID (Id: Byte): Boolean;
var
   i: integer;
   pm: PTClientMagic;
begin
   Result := False;
   if g_MagicList.Count > 0 then //20080629
   for i:=0 to g_MagicList.Count-1 do begin
      pm := PTClientMagic (g_MagicList[i]);
      if pm.Def.wMagicId = Id then begin
         Result := True;
         break;
      end;
   end;
end;

//自动烈火
function TfrmMain.AutoLieHuo: Boolean;
var
  i: Integer;
  pm: PTClientMagic;
begin
  Result := False;
  if g_MySelf = nil then Exit;
  if ((GetTickCount - g_dwAutoLieHuo) > 7000) and(g_MySelf.m_btJob = 0) then begin
   if g_MagicList.Count > 0 then //20080629
   for i:=0 to g_MagicList.Count-1 do begin
      pm := PTClientMagic (g_MagicList[i]);
      if pm.Def.wMagicID = 26 then
      begin
        SendSpellMsg(CM_SPELL, g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, 26, 0);
        g_dwAutoLieHuo := GetTickCount;
      end;
    end;
  end;
end;

//自动逐日
function TfrmMain.AutoZhuri: Boolean;
var

  i: Integer;
  pm: PTClientMagic;
begin
  Result := False;
  if g_MySelf = nil then Exit;
  if ((GetTickCount - g_dwAutoZhuRi) > 10000) and(g_MySelf.m_btJob = 0) then begin
   if g_MagicList.Count > 0 then //20080629
   for i:=0 to g_MagicList.Count-1 do begin
      pm := PTClientMagic (g_MagicList[i]);
      if pm.Def.wMagicID = 74 then begin
        SendSpellMsg(CM_SPELL, g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, 74, 0);
        g_dwAutoZhuRi := GetTickCount;
      end;
    end;
  end;
end;

//自动魔法盾，自动抗拒，自动隐身过程
function TfrmMain.NearActor: Boolean;
  {var
  i: Integer;
  pm: PTClientMagic;
  function isNear(Step:Integer):Boolean;
  var
    i:Integer;
    Actor:TActor;
  begin
   Result:=False;
   with PlayScene do begin
      if m_ActorList.Count > 0 then //20080629
      for i:=0 to m_ActorList.Count-1 do begin
         Actor:=TActor(m_ActorList[i]);
         if Actor <> nil then begin
           if (g_MySelf = Actor) or (Actor.m_btRace = 50) or (Actor.m_boDeath) then Continue;
           if (Abs(Actor.m_nCurrX-g_MySelf.m_nCurrX) < Step) and (Abs(Actor.m_nCurrY-g_MySelf.m_nCurrY) < Step) then begin
              Result:=True;
              Exit;
           end;
         end;
      end;
   end;
  end;}
var
  boIs66: Boolean;
  i: Integer;
  pm: PTClientMagic;
begin
  Result := False;
  if g_MySelf = nil then Exit;
  if g_MySelf.m_boDeath then Exit;
    // 自动魔盾
  if (g_MySelf.m_btJob=1) and  ((GetTickCount-g_nAutoMagic) > 500) and g_boAutoShield then begin
    if (g_MySelf.m_nState and $00100000 <> 0) then Exit;
    boIs66 := False;
    if g_MagicList.Count > 0 then //20080629
    for i:=0 to g_MagicList.Count-1 do begin
      pm := PTClientMagic (g_MagicList[i]);
      if pm <> nil then begin
        if Pm.Def.wMagicId = 66 then begin //四级魔法盾
          UseMagic(g_nMouseX, g_nMouseY,Pm);
          g_nAutoMagic:=GetTickCount;
          Break;
          boIs66 := True;
        end;
      end;
    end;
    if not boIs66 then begin
      if g_MagicList.Count > 0 then //20080629
      for i:=0 to g_MagicList.Count-1 do begin
        pm := PTClientMagic (g_MagicList[i]);
        if pm <> nil then begin
          if Pm.Def.wMagicId = 31 then begin //魔法盾
            UseMagic(g_nMouseX, g_nMouseY,Pm);
            g_nAutoMagic:=GetTickCount;
            Break;
          end;
        end;
      end;
    end;
  end;
  //自动隐身
  if (g_MySelf.m_btJob = 2) and ((GetTickCount - g_nAutoMAgic) > 500)  and g_boAutoHide then begin
    if (g_MySelf.m_nState and $00800000 <> 0) then Exit;
    if g_MagicList.Count > 0 then //20080629
    for i := 0 to g_MagicList.Count - 1 do begin
      pm := PTClientMagic(g_MagicList[i]);
      if pm <> nil then begin
        if pm.Def.wMagicId = 18 then begin
          UseMagic(g_nMouseX, g_nMouseY,Pm);
          g_nAutoMAgic := GetTickCount;
        end;
      end;
    end;
  end;
end;
//判断在2格范围内是否可以小开天
function TfrmMain.TargetInCanQTwnAttackRange(sx, sy, dx,
  dy: Integer): Boolean;
begin
   Result:=False;
   if (Abs(Sx-dx)=2)and(Abs(sy-dy)=0) then begin
       Result:=True;
       Exit;
   end;
   if (Abs(Sx-dx)=0)and(Abs(sy-dy)=2) then begin
       Result:=True;
       Exit;
   end;
   if (Abs(Sx-dx)=2)and(Abs(sy-dy)=2) then begin
       Result:=True;
       Exit;
   end;
end;
//判断在4格范围内是否可以大开天、逐日剑法
function TfrmMain.TargetInCanTwnAttackRange(sx, sy, dx,
  dy: Integer): Boolean;
begin
   Result:=False;
   if (Abs(Sx-dx)<=4)and(Abs(sy-dy)=0) then begin
       Result:=True;
       Exit;
   end;
   if (Abs(Sx-dx)=0)and(Abs(sy-dy)<=4) then begin
       Result:=True;
       Exit;
   end;
   if ((Abs(Sx-dx)=2)and(Abs(sy-dy)=2)) or ((Abs(Sx-dx)=3)and(Abs(sy-dy)=3))
      or ((Abs(Sx-dx)=4)and(Abs(sy-dy)=4)) then begin
       Result:=True;
       Exit;
   end;
end;

//判断在2格范围内是否有目标可以刺杀
function  TfrmMain.TargetInSwordLongAttackRange (ndir: integer): Boolean;

var
   nx, ny: integer;
   actor: TActor;
begin
   Result := FALSE;
   GetFrontPosition (g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, ndir, nx, ny);
   GetFrontPosition (nx, ny, ndir, nx, ny);
   if (abs(g_MySelf.m_nCurrX - nx) = 2) or (abs(g_MySelf.m_nCurrY-ny) = 2) then begin
      actor := PlayScene.FindActorXY (nx, ny);
      if actor <> nil then
         if not actor.m_boDeath then
            Result := TRUE;
   end;
end;

//判断是否有目标在半月攻击范围内
function  TfrmMain.TargetInSwordWideAttackRange (ndir: integer): Boolean;
var
   nx, ny, rx, ry, mdir: integer;
   actor, ractor: TActor;
begin
   Result := FALSE;
   GetFrontPosition (g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, ndir, nx, ny);
   actor := PlayScene.FindActorXY (nx, ny);

   mdir := (ndir + 1) mod 8;
   GetFrontPosition (g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, mdir, rx, ry);
   ractor := PlayScene.FindActorXY (rx, ry);
   if ractor = nil then begin
      mdir := (ndir + 2) mod 8;
      GetFrontPosition (g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, mdir, rx, ry);
      ractor := PlayScene.FindActorXY (rx, ry);
   end;
   if ractor = nil then begin
      mdir := (ndir + 7) mod 8;
      GetFrontPosition (g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, mdir, rx, ry);
      ractor := PlayScene.FindActorXY (rx, ry);
   end;

   //if (actor <> nil) and (ractor <> nil) then
   if ((actor <> nil) and (actor.m_btRace<>1)) and ((ractor <> nil) and (ractor.m_btRace <>1)) then
      if not actor.m_boDeath and not ractor.m_boDeath then
         Result := TRUE;
end;
function  TfrmMain.TargetInSwordCrsAttackRange (ndir: integer): Boolean;
var
   nx, ny, rx, ry, mdir: integer;
   actor, ractor: TActor;
begin
   Result := FALSE;
   GetFrontPosition (g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, ndir, nx, ny);
   actor := PlayScene.FindActorXY (nx, ny);

   mdir := (ndir + 1) mod 8;
   GetFrontPosition (g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, mdir, rx, ry);
   ractor := PlayScene.FindActorXY (rx, ry);
   if ractor = nil then begin
      mdir := (ndir + 2) mod 8;
      GetFrontPosition (g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, mdir, rx, ry);
      ractor := PlayScene.FindActorXY (rx, ry);
   end;
   if ractor = nil then begin
      mdir := (ndir + 7) mod 8;
      GetFrontPosition (g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, mdir, rx, ry);
      ractor := PlayScene.FindActorXY (rx, ry);
   end;

   if (actor <> nil) and (ractor <> nil) then
      if not actor.m_boDeath and not ractor.m_boDeath then
         Result := TRUE;
end;

procedure TfrmMain.ShowHumanMsg(Msg: pTDefaultMessage);
  function GetIdent(nIdent: Integer): string;
  begin
    case nIdent of
      SM_RUSH: Result := 'SM_RUSH';
      SM_RUSHKUNG: Result := 'SM_RUSHKUNG';
      SM_FIREHIT: Result := 'SM_FIREHIT';
      SM_BACKSTEP: Result := 'SM_BACKSTEP';
      SM_TURN: Result := 'SM_TURN';
      SM_WALK: Result := 'SM_WALK';
      SM_SITDOWN: Result := 'SM_SITDOWN';
      SM_RUN: Result := 'SM_RUN';
      SM_HIT: Result := 'SM_HIT';
      SM_HEAVYHIT: Result := 'SM_HEAVYHIT';
      SM_BIGHIT: Result := 'SM_BIGHIT';
      SM_SPELL: Result := 'SM_SPELL';
      SM_POWERHIT: Result := 'SM_POWERHIT';
      SM_LONGHIT: Result := 'SM_LONGHIT';
      SM_DIGUP: Result := 'SM_DIGUP';
      SM_DIGDOWN: Result := 'SM_DIGDOWN';
      SM_FLYAXE: Result := 'SM_FLYAXE';
      SM_LIGHTING: Result := 'SM_LIGHTING';
      SM_WIDEHIT: Result := 'SM_WIDEHIT';
      SM_ALIVE: Result := 'SM_ALIVE';
      SM_MOVEFAIL: Result := 'SM_MOVEFAIL';
      SM_HIDE: Result := 'SM_HIDE';
      SM_DISAPPEAR: Result := 'SM_DISAPPEAR';
      SM_STRUCK: Result := 'SM_STRUCK';
      SM_DEATH: Result := 'SM_DEATH';
      SM_SKELETON: Result := 'SM_SKELETON';
      SM_NOWDEATH: Result := 'SM_NOWDEATH';
      SM_CRSHIT: Result := 'SM_CRSHIT';
      SM_TWINHIT: Result := 'SM_TWINHIT';
      SM_HEAR: Result := 'SM_HEAR';
      SM_FEATURECHANGED: Result := 'SM_FEATURECHANGED';
      SM_USERNAME: Result := 'SM_USERNAME';
      SM_WINEXP: Result := 'SM_WINEXP';
      SM_LEVELUP: Result := 'SM_LEVELUP';
      SM_DAYCHANGING: Result := 'SM_DAYCHANGING';
      SM_ITEMSHOW: Result := 'SM_ITEMSHOW';
      SM_ITEMHIDE: Result := 'SM_ITEMHIDE';
      SM_MAGICFIRE: Result := 'SM_MAGICFIRE';
      SM_CHANGENAMECOLOR: Result := 'SM_CHANGENAMECOLOR';
      SM_CHARSTATUSCHANGED: Result := 'SM_CHARSTATUSCHANGED';

      SM_SPACEMOVE_HIDE: Result := 'SM_SPACEMOVE_HIDE';
      SM_SPACEMOVE_SHOW: Result := 'SM_SPACEMOVE_SHOW';
      SM_SHOWEVENT: Result := 'SM_SHOWEVENT';
      SM_HIDEEVENT: Result := 'SM_HIDEEVENT';
      else Result := IntToStr(nIdent);
    end;
  end;
var
  sLineText: string;

begin
  if (ShowMsgActor = nil) or (ShowMsgActor <> nil) and (ShowMsgActor.m_nRecogId = Msg.Recog) then begin
    sLineText := format('ID:%d Ident:%s', [Msg.Recog, GetIdent(Msg.ident)]);
    PlayScene.MemoLog.Lines.Add(sLineText);
  end;
end;



procedure TfrmMain.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  pm: PTClientMagic;
begin
  case Key of
      VK_ESCAPE: begin//ESC        20080314
      g_boDownEsc := False;    //松开ESC键
      g_boShowAllItem := g_boTempShowItem;
      g_boFilterAutoItemShow := g_boTempFilterItemShow;
    end;
  end;

  if (Key >= 112) and (Key < 119) and g_boAutoMagic then begin
      pm:=GetMagicByKey(char(key-Vk_F1 + byte('1')));
      //自动练功
      if pm.Def.wMagicId in [12,25] then Exit;
      g_nAutoMAgicKey := Key;
      DScreen.AddChatBoardString('自动练功开始 (再按一下这个魔法的快捷健停止自动练功)', clGreen, clWhite);
    //end;
    //AutoMagicTimeup := False;
  end;
end;

end.


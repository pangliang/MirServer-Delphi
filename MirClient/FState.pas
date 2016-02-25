unit FState;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DWinCtl, StdCtrls, DXDraws, Grids, Grobal2, ClFunc, HUtil32, cliUtil,
  MapUnit, SoundUtil;

const
  BOTTOMBOARD800 = 371; //主操作介面图形号
  BOTTOMBOARD1024 = 2; //主操作介面图形号
  VIEWCHATLINE = 9;
  MAXSTATEPAGE = 4;
  LISTLINEHEIGHT = 13;
  MAXMENU = 10;

  AdjustAbilHints: array[0..8] of string = (
    '攻击力',
    '魔法(魔法师)',
    '道术(道士)',
    '防御',
    '魔法防御',
    '生命值',
    '魔法值',
    '准确',
    '敏捷'
    );

type
  TSpotDlgMode = (dmSell, dmRepair, dmStorage);

  TClickPoint = record
    rc: TRect;
    rstr: string;
  end;
  pTClickPoint = ^TClickPoint;
  TDiceInfo = record
    nDicePoint: Integer; //0x66C
    nPlayPoint: Integer; //0x670 当前骰子点数
    nX: Integer; //0x674
    nY: Integer; //0x678
    n67C: Integer; //0x67C
    n680: Integer; //0x680
    dwPlayTick: LongWord; //0x684
  end;
  pTDiceInfo = ^TDiceInfo;
  TFrmDlg = class(TForm)
    DStateWin: TDWindow;
    DBackground: TDWindow;
    DItemBag: TDWindow;
    DBottom: TDWindow;
    DMyState: TDButton;
    DMyBag: TDButton;
    DMyMagic: TDButton;
    DOption: TDButton;
    DGold: TDButton;
    DPrevState: TDButton;
    DRepairItem: TDButton;
    DCloseBag: TDButton;
    DCloseState: TDButton;
    DLogin: TDWindow;
    DLoginNew: TDButton;
    DLoginOk: TDButton;
    DNewAccount: TDWindow;
    DNewAccountOk: TDButton;
    DLoginClose: TDButton;
    DNewAccountClose: TDButton;
    DSelectChr: TDWindow;
    DscSelect1: TDButton;
    DscSelect2: TDButton;
    DscStart: TDButton;
    DscNewChr: TDButton;
    DscEraseChr: TDButton;
    DscCredits: TDButton;
    DscExit: TDButton;
    DCreateChr: TDWindow;
    DccWarrior: TDButton;
    DccWizzard: TDButton;
    DccMonk: TDButton;
    DccReserved: TDButton;
    DccMale: TDButton;
    DccFemale: TDButton;
    DccLeftHair: TDButton;
    DccRightHair: TDButton;
    DccOk: TDButton;
    DccClose: TDButton;
    DItemGrid: TDGrid;
    DLoginChgPw: TDButton;
    DMsgDlg: TDWindow;
    DMsgDlgOk: TDButton;
    DMsgDlgYes: TDButton;
    DMsgDlgCancel: TDButton;
    DMsgDlgNo: TDButton;
    DNextState: TDButton;
    DSWNecklace: TDButton;
    DSWLight: TDButton;
    DSWArmRingR: TDButton;
    DSWArmRingL: TDButton;
    DSWRingR: TDButton;
    DSWRingL: TDButton;
    DSWWeapon: TDButton;
    DSWDress: TDButton;
    DSWHelmet: TDButton;
    DSWBujuk: TDButton;
    DSWBelt: TDButton;
    DSWBoots: TDButton;
    DSWCharm: TDButton;

    DBelt1: TDButton;
    DBelt2: TDButton;
    DBelt3: TDButton;
    DBelt4: TDButton;
    DBelt5: TDButton;
    DBelt6: TDButton;
    DChgPw: TDWindow;
    DChgpwOk: TDButton;
    DChgpwCancel: TDButton;
    DMerchantDlg: TDWindow;
    DMerchantDlgClose: TDButton;
    DMenuDlg: TDWindow;
    DMenuPrev: TDButton;
    DMenuNext: TDButton;
    DMenuBuy: TDButton;
    DMenuClose: TDButton;
    DSellDlg: TDWindow;
    DSellDlgOk: TDButton;
    DSellDlgClose: TDButton;
    DSellDlgSpot: TDButton;
    DStMag1: TDButton;
    DStMag2: TDButton;
    DStMag3: TDButton;
    DStMag4: TDButton;
    DStMag5: TDButton;
    DKeySelDlg: TDWindow;
    DKsIcon: TDButton;
    DKsF1: TDButton;
    DKsF2: TDButton;
    DKsF3: TDButton;
    DKsF4: TDButton;
    DKsNone: TDButton;
    DKsOk: TDButton;
    DBotGroup: TDButton;
    DBotTrade: TDButton;
    DBotMiniMap: TDButton;
    DGroupDlg: TDWindow;
    DGrpAllowGroup: TDButton;
    DGrpDlgClose: TDButton;
    DGrpCreate: TDButton;
    DGrpAddMem: TDButton;
    DGrpDelMem: TDButton;
    DBotLogout: TDButton;
    DBotExit: TDButton;
    DBotGuild: TDButton;
    DStPageUp: TDButton;
    DStPageDown: TDButton;
    DDealRemoteDlg: TDWindow;
    DDealDlg: TDWindow;
    DDRGrid: TDGrid;
    DDGrid: TDGrid;
    DDealOk: TDButton;
    DDealClose: TDButton;
    DDGold: TDButton;
    DDRGold: TDButton;
    DSelServerDlg: TDWindow;
    DSSrvClose: TDButton;
    DSServer1: TDButton;
    DSServer2: TDButton;
    DUserState1: TDWindow;
    DCloseUS1: TDButton;
    DWeaponUS1: TDButton;
    DHelmetUS1: TDButton;
    DNecklaceUS1: TDButton;
    DDressUS1: TDButton;
    DLightUS1: TDButton;
    DArmringRUS1: TDButton;
    DRingRUS1: TDButton;
    DArmringLUS1: TDButton;
    DRingLUS1: TDButton;

    DBujukUS1: TDButton;
    DBeltUS1: TDButton;
    DBootsUS1: TDButton;
    DCharmUS1: TDButton;

    DSServer3: TDButton;
    DSServer4: TDButton;
    DGuildDlg: TDWindow;
    DGDHome: TDButton;
    DGDList: TDButton;
    DGDChat: TDButton;
    DGDAddMem: TDButton;
    DGDDelMem: TDButton;
    DGDEditNotice: TDButton;
    DGDEditGrade: TDButton;
    DGDAlly: TDButton;
    DGDBreakAlly: TDButton;
    DGDWar: TDButton;
    DGDCancelWar: TDButton;
    DGDUp: TDButton;
    DGDDown: TDButton;
    DGDClose: TDButton;
    DGuildEditNotice: TDWindow;
    DGEClose: TDButton;
    DGEOk: TDButton;
    DSServer5: TDButton;
    DSServer6: TDButton;
    DNewAccountCancel: TDButton;
    DAdjustAbility: TDWindow;
    DPlusDC: TDButton;
    DPlusMC: TDButton;
    DPlusSC: TDButton;
    DPlusAC: TDButton;
    DPlusMAC: TDButton;
    DPlusHP: TDButton;
    DPlusMP: TDButton;
    DPlusHit: TDButton;
    DPlusSpeed: TDButton;
    DMinusDC: TDButton;
    DMinusMC: TDButton;
    DMinusSC: TDButton;
    DMinusAC: TDButton;
    DMinusMAC: TDButton;
    DMinusMP: TDButton;
    DMinusHP: TDButton;
    DMinusHit: TDButton;
    DMinusSpeed: TDButton;
    DAdjustAbilClose: TDButton;
    DAdjustAbilOk: TDButton;
    DBotPlusAbil: TDButton;
    DKsF5: TDButton;
    DKsF6: TDButton;
    DKsF7: TDButton;
    DKsF8: TDButton;
    DEngServer1: TDButton;
    DConfigDlg: TDWindow;
    DConfigDlgClose: TDButton;
    DConfigDlgOK: TDButton;
    DKsConF1: TDButton;
    DKsConF2: TDButton;
    DKsConF3: TDButton;
    DKsConF4: TDButton;
    DKsConF5: TDButton;
    DKsConF6: TDButton;
    DKsConF7: TDButton;
    DKsConF8: TDButton;
    DBotMemo: TDButton;
    DMemoB2: TDButton;
    DMemoB1: TDButton;
    DMemo: TDWindow;
    DMemoClose: TDButton;
    DChgGamePwd: TDWindow;
    DChgGamePwdClose: TDButton;
    DButtonHP: TDButton;
    DButtonMP: TDButton;
    DButtonShop: TDButton;
    DButton2: TDButton;
    DButton1: TDButton;
    DShop: TDWindow;
    DShopIntroduce: TDButton;
    DShopStdItem1: TDButton;
    DShopStdItem2: TDButton;
    DShopStdItem3: TDButton;
    DShopStdItem4: TDButton;
    DShopStdItem5: TDButton;
    DShopStdItem7: TDButton;
    DShopStdItem9: TDButton;
    DShopStdItem6: TDButton;
    DShopStdItem8: TDButton;
    DShopStdItem10: TDButton;
    DPrevShop: TDButton;
    DNextShop: TDButton;
    DShopBuy: TDButton;
    DShopFree: TDButton;
    DShopClose: TDButton;
    DShopExit: TDButton;
    DJewelry: TDButton;
    DMedicine: TDButton;
    DEnhance: TDButton;
    Dfriend: TDButton;
    DLimit: TDButton;
    DWNewSdoAssistant: TDWindow;
    DNewSdoBasic: TDButton;
    DNewSdoProtect: TDButton;
    DNewSdoSkill: TDButton;
    DNewSdoKey: TDButton;
    DNedSdoHelp: TDButton;
    DNewSdoAssistantClose: TDButton;
    DSdoHelpUp: TDButton;
    DSdoHelpNext: TDButton;
    DCheckSdoNameShow: TDCheckBox;
    DCheckSdoDuraWarning: TDCheckBox;
    DCheckSdoAvoidShift: TDCheckBox;
    DCheckSdoItemsHint: TDCheckBox;
    DCheckSdoShowFiltrate: TDCheckBox;
    DCheckSdoAutoPickItems: TDCheckBox;
    DCheckSdoPickFiltrate: TDCheckBox;
    DCheckSdoExpFiltrate: TDCheckBox;
    DEdtSdoHeroDrunkDrugWineDegree: TDEdit;
    DEdtSdoDrunkDrugWineDegree: TDEdit;
    DEdtSdoHeroDrunkWineDegree: TDEdit;
    DEdtSdoDrunkWineDegree: TDEdit;
    DBtnSdoRandomName: TDButton;
    DEdtSdoRandomHp: TDEdit;
    DEdtSdoSpecialHpTimer: TDEdit;
    DCheckSdoSpecialHp: TDCheckBox;
    DEdtSdoCommonMp: TDEdit;
    DEdtSdoCommonHpTimer: TDEdit;
    DCheckSdoCommonHp: TDCheckBox;
    DEdtSdoCommonHp: TDEdit;
    DCheckSdoCommonMp: TDCheckBox;
    DEdtSdoCommonMpTimer: TDEdit;
    DEdtSdoSpecialHp: TDEdit;
    DCheckSdoRandomHp: TDCheckBox;
    DEdtSdoRandomHpTimer: TDEdit;
    DCheckSdoAutoDrinkWine: TDCheckBox;
    DCheckSdoHeroAutoDrinkWine: TDCheckBox;
    DCheckSdoAutoDrinkDrugWine: TDCheckBox;
    DCheckSdoHeroAutoDrinkDrugWine: TDCheckBox;
    DEdtSdoAutoMagicTimer: TDEdit;
    DCheckSdoAutoMagic: TDCheckBox;
    DCheckSdoAutoHide: TDCheckBox;
    DCheckSdoHeroShield: TDCheckBox;
    DCheckSdoAutoShield: TDCheckBox;
    DCheckSdoZhuri: TDCheckBox;
    DCheckSdoAutoFireHit: TDCheckBox;
    DCheckSdoAutoWideHit: TDCheckBox;
    DCheckSdoLongHit: TDCheckBox;
    DCheckSdoStartKey: TDCheckBox;
    DBtnSdoCallHeroKey: TDButton;
    DBtnSdoHeroAttackTargetKey: TDButton;
    DBtnSdoHeroGotethKey: TDButton;
    DBtnSdoHeroStateKey: TDButton;
    DBtnSdoHeroGuardKey: TDButton;
    DBtnSdoAttackModeKey: TDButton;
    DBtnSdoMinMapKey: TDButton;
    DShopSuperStdItem1: TDButton;
    DShopSuperStdItem2: TDButton;
    DShopSuperStdItem3: TDButton;
    DShopSuperStdItem4: TDButton;
    DShopSuperStdItem5: TDButton;

    procedure DBottomInRealArea(Sender: TObject; X, Y: Integer;
      var IsRealArea: Boolean);
    procedure DBottomDirectPaint(Sender: TObject;
      dsurface: TDirectDrawSurface);
    procedure DMyStateDirectPaint(Sender: TObject;
      dsurface: TDirectDrawSurface);
    procedure DOptionClick();
    procedure DItemBagDirectPaint(Sender: TObject;
      dsurface: TDirectDrawSurface);
    procedure DRepairItemDirectPaint(Sender: TObject;
      dsurface: TDirectDrawSurface);
    procedure DRepairItemInRealArea(Sender: TObject; X, Y: Integer;
      var IsRealArea: Boolean);
    procedure DStateWinDirectPaint(Sender: TObject;
      dsurface: TDirectDrawSurface);
    procedure FormCreate(Sender: TObject);
    procedure DPrevStateDirectPaint(Sender: TObject;
      dsurface: TDirectDrawSurface);
    procedure DLoginNewDirectPaint(Sender: TObject;
      dsurface: TDirectDrawSurface);
    procedure DscSelect1DirectPaint(Sender: TObject;
      dsurface: TDirectDrawSurface);
    procedure DccCloseDirectPaint(Sender: TObject;
      dsurface: TDirectDrawSurface);
    procedure DItemGridGridSelect(Sender: TObject; ACol, ARow: Integer;
      Shift: TShiftState);
    procedure DItemGridGridPaint(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState; dsurface: TDirectDrawSurface);
    procedure DItemGridDblClick(Sender: TObject);
    procedure DMsgDlgOkDirectPaint(Sender: TObject;
      dsurface: TDirectDrawSurface);
    procedure DMsgDlgDirectPaint(Sender: TObject;
      dsurface: TDirectDrawSurface);
    procedure DMsgDlgKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DCloseBagDirectPaint(Sender: TObject;
      dsurface: TDirectDrawSurface);
    procedure DBackgroundBackgroundClick(Sender: TObject);
    procedure DItemGridGridMouseMove(Sender: TObject; ACol, ARow: Integer;
      Shift: TShiftState);
    procedure DBelt1DirectPaint(Sender: TObject;
      dsurface: TDirectDrawSurface);
    procedure FormDestroy(Sender: TObject);
    procedure DBelt1DblClick(Sender: TObject);
    procedure DLoginCloseClick(Sender: TObject; X, Y: Integer);
    procedure DLoginOkClick(Sender: TObject; X, Y: Integer);
    procedure DLoginNewClick(Sender: TObject; X, Y: Integer);
    procedure DLoginChgPwClick(Sender: TObject; X, Y: Integer);
    procedure DNewAccountOkClick(Sender: TObject; X, Y: Integer);
    procedure DNewAccountCloseClick(Sender: TObject; X, Y: Integer);
    procedure DccCloseClick(Sender: TObject; X, Y: Integer);
    procedure DChgpwOkClick(Sender: TObject; X, Y: Integer);
    procedure DscSelect1Click(Sender: TObject; X, Y: Integer);
    procedure DCloseStateClick(Sender: TObject; X, Y: Integer);
    procedure DPrevStateClick(Sender: TObject; X, Y: Integer);
    procedure DNextStateClick(Sender: TObject; X, Y: Integer);
    procedure DSWWeaponClick(Sender: TObject; X, Y: Integer);
    procedure DMsgDlgOkClick(Sender: TObject; X, Y: Integer);
    procedure DCloseBagClick(Sender: TObject; X, Y: Integer);
    procedure DBelt1Click(Sender: TObject; X, Y: Integer);
    procedure DMyStateClick(Sender: TObject; X, Y: Integer);
    procedure DStateWinClick(Sender: TObject; X, Y: Integer);
    procedure DSWWeaponMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure DBelt1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure DMerchantDlgDirectPaint(Sender: TObject;
      dsurface: TDirectDrawSurface);
    procedure DMerchantDlgCloseClick(Sender: TObject; X, Y: Integer);
    procedure DMerchantDlgClick(Sender: TObject; X, Y: Integer);
    procedure DMerchantDlgMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DMerchantDlgMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DMenuCloseClick(Sender: TObject; X, Y: Integer);
    procedure DMenuDlgDirectPaint(Sender: TObject;
      dsurface: TDirectDrawSurface);
    procedure DMenuDlgClick(Sender: TObject; X, Y: Integer);
    procedure DSellDlgDirectPaint(Sender: TObject;
      dsurface: TDirectDrawSurface);
    procedure DSellDlgCloseClick(Sender: TObject; X, Y: Integer);
    procedure DSellDlgSpotClick(Sender: TObject; X, Y: Integer);
    procedure DSellDlgSpotDirectPaint(Sender: TObject;
      dsurface: TDirectDrawSurface);
    procedure DSellDlgSpotMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure DSellDlgOkClick(Sender: TObject; X, Y: Integer);
    procedure DMenuBuyClick(Sender: TObject; X, Y: Integer);
    procedure DMenuPrevClick(Sender: TObject; X, Y: Integer);
    procedure DMenuNextClick(Sender: TObject; X, Y: Integer);
    procedure DGoldClick(Sender: TObject; X, Y: Integer);
    procedure DSWLightDirectPaint(Sender: TObject;
      dsurface: TDirectDrawSurface);
    procedure DBackgroundMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DStateWinMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure DLoginNewClickSound(Sender: TObject;
      Clicksound: TClickSound);
    procedure DStMag1DirectPaint(Sender: TObject;
      dsurface: TDirectDrawSurface);
    procedure DStMag1Click(Sender: TObject; X, Y: Integer);
    procedure DKsIconDirectPaint(Sender: TObject;
      dsurface: TDirectDrawSurface);
    procedure DKsF1DirectPaint(Sender: TObject;
      dsurface: TDirectDrawSurface);
    procedure DKsOkClick(Sender: TObject; X, Y: Integer);
    procedure DKsF1Click(Sender: TObject; X, Y: Integer);
    procedure DKeySelDlgDirectPaint(Sender: TObject;
      dsurface: TDirectDrawSurface);
    procedure DBotGroupDirectPaint(Sender: TObject;
      dsurface: TDirectDrawSurface);
    procedure DGrpAllowGroupDirectPaint(Sender: TObject;
      dsurface: TDirectDrawSurface);
    procedure DGrpDlgCloseClick(Sender: TObject; X, Y: Integer);
    procedure DBotGroupClick(Sender: TObject; X, Y: Integer);
    procedure DGrpAllowGroupClick(Sender: TObject; X, Y: Integer);
    procedure DGrpCreateClick(Sender: TObject; X, Y: Integer);
    procedure DGroupDlgDirectPaint(Sender: TObject;
      dsurface: TDirectDrawSurface);
    procedure DGrpAddMemClick(Sender: TObject; X, Y: Integer);
    procedure DGrpDelMemClick(Sender: TObject; X, Y: Integer);
    procedure DBotLogoutClick(Sender: TObject; X, Y: Integer);
    procedure DBotExitClick(Sender: TObject; X, Y: Integer);
    procedure DStPageUpClick(Sender: TObject; X, Y: Integer);
    procedure DBottomMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DDealOkClick(Sender: TObject; X, Y: Integer);
    procedure DDealCloseClick(Sender: TObject; X, Y: Integer);
    procedure DBotTradeClick(Sender: TObject; X, Y: Integer);
    procedure DDealRemoteDlgDirectPaint(Sender: TObject;
      dsurface: TDirectDrawSurface);
    procedure DDealDlgDirectPaint(Sender: TObject;
      dsurface: TDirectDrawSurface);
    procedure DDGridGridSelect(Sender: TObject; ACol, ARow: Integer;
      Shift: TShiftState);
    procedure DDGridGridPaint(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState; dsurface: TDirectDrawSurface);
    procedure DDGridGridMouseMove(Sender: TObject; ACol, ARow: Integer;
      Shift: TShiftState);
    procedure DDRGridGridPaint(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState; dsurface: TDirectDrawSurface);
    procedure DDRGridGridMouseMove(Sender: TObject; ACol, ARow: Integer;
      Shift: TShiftState);
    procedure DDGoldClick(Sender: TObject; X, Y: Integer);
    procedure DSServer1Click(Sender: TObject; X, Y: Integer);
    procedure DSSrvCloseClick(Sender: TObject; X, Y: Integer);
    procedure DBotMiniMapClick(Sender: TObject; X, Y: Integer);
    procedure DMenuDlgMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure DUserState1DirectPaint(Sender: TObject;
      dsurface: TDirectDrawSurface);
    procedure DUserState1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure DWeaponUS1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure DCloseUS1Click(Sender: TObject; X, Y: Integer);
    procedure DNecklaceUS1DirectPaint(Sender: TObject;
      dsurface: TDirectDrawSurface);
    procedure DBotGuildClick(Sender: TObject; X, Y: Integer);
    procedure DGuildDlgDirectPaint(Sender: TObject;
      dsurface: TDirectDrawSurface);
    procedure DGDUpClick(Sender: TObject; X, Y: Integer);
    procedure DGDDownClick(Sender: TObject; X, Y: Integer);
    procedure DGDCloseClick(Sender: TObject; X, Y: Integer);
    procedure DGDHomeClick(Sender: TObject; X, Y: Integer);
    procedure DGDListClick(Sender: TObject; X, Y: Integer);
    procedure DGDAddMemClick(Sender: TObject; X, Y: Integer);
    procedure DGDDelMemClick(Sender: TObject; X, Y: Integer);
    procedure DGDEditNoticeClick(Sender: TObject; X, Y: Integer);
    procedure DGDEditGradeClick(Sender: TObject; X, Y: Integer);
    procedure DGECloseClick(Sender: TObject; X, Y: Integer);
    procedure DGEOkClick(Sender: TObject; X, Y: Integer);
    procedure DGuildEditNoticeDirectPaint(Sender: TObject;
      dsurface: TDirectDrawSurface);
    procedure DGDChatClick(Sender: TObject; X, Y: Integer);
    procedure DGoldDirectPaint(Sender: TObject;
      dsurface: TDirectDrawSurface);
    procedure DNewAccountDirectPaint(Sender: TObject;
      dsurface: TDirectDrawSurface);
    procedure DAdjustAbilCloseClick(Sender: TObject; X, Y: Integer);
    procedure DAdjustAbilityDirectPaint(Sender: TObject;
      dsurface: TDirectDrawSurface);
    procedure DBotPlusAbilClick(Sender: TObject; X, Y: Integer);
    procedure DPlusDCClick(Sender: TObject; X, Y: Integer);
    procedure DMinusDCClick(Sender: TObject; X, Y: Integer);
    procedure DAdjustAbilOkClick(Sender: TObject; X, Y: Integer);
    procedure DBotPlusAbilDirectPaint(Sender: TObject;
      dsurface: TDirectDrawSurface);
    procedure DAdjustAbilityMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure DUserState1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DEngServer1Click(Sender: TObject; X, Y: Integer);
    procedure DGDAllyClick(Sender: TObject; X, Y: Integer);
    procedure DGDBreakAllyClick(Sender: TObject; X, Y: Integer);
    procedure DSelServerDlgDirectPaint(Sender: TObject;
      dsurface: TDirectDrawSurface);
    procedure DBotMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure DChgGamePwdCloseClick(Sender: TObject; X, Y: Integer);
    procedure DChgGamePwdDirectPaint(Sender: TObject;
      dsurface: TDirectDrawSurface);
    procedure DButtonShopDirectPaint(Sender: TObject;
      dsurface: TDirectDrawSurface);
    procedure DShopDirectPaint(Sender: TObject;
      dsurface: TDirectDrawSurface);
    procedure DButtonShopClick(Sender: TObject; X, Y: Integer);
    procedure DJewelryDirectPaint(Sender: TObject;
      dsurface: TDirectDrawSurface);
    procedure DShopExitClick(Sender: TObject; X, Y: Integer);
    procedure DJewelryClick(Sender: TObject; X, Y: Integer);
    procedure DShopStdItem1DirectPaint(Sender: TObject;
      dsurface: TDirectDrawSurface);
    procedure DBottomMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure DShopSuperStdItem1DirectPaint(Sender: TObject;
      dsurface: TDirectDrawSurface);
    procedure DShopIntroduceDirectPaint(Sender: TObject;
      dsurface: TDirectDrawSurface);
    procedure DShopStdItem1Click(Sender: TObject; X, Y: Integer);
    procedure DPrevShopClick(Sender: TObject; X, Y: Integer);
    procedure DNextShopClick(Sender: TObject; X, Y: Integer);
    procedure DShopBuyClick(Sender: TObject; X, Y: Integer);
    procedure DButtonReCallBabyDirectPaint(Sender: TObject;
      dsurface: TDirectDrawSurface);
    procedure DShopSuperStdItem1Click(Sender: TObject; X, Y: Integer);
    procedure DEdtSdoCommonHpChange(Sender: TObject);
    procedure DWNewSdoAssistantDirectPaint(Sender: TObject;
      dsurface: TDirectDrawSurface);
    procedure DWNewSdoAssistantMouseMove(Sender: TObject;
      Shift: TShiftState; X, Y: Integer);
    procedure DNewSdoBasicClick(Sender: TObject; X, Y: Integer);
    procedure DNewSdoBasicDirectPaint(Sender: TObject;
      dsurface: TDirectDrawSurface);
    procedure DCheckSdoNameShowClick(Sender: TObject; X, Y: Integer);
    procedure DCheckSdoNameShowDirectPaint(Sender: TObject;
      dsurface: TDirectDrawSurface);
    procedure DCheckSdoNameShowMouseMove(Sender: TObject;
      Shift: TShiftState; X, Y: Integer);
    procedure DCheckSdoCommonHpClick(Sender: TObject; X, Y: Integer);
    procedure DEdtSdoCommonHpDirectPaint(Sender: TObject;
      dsurface: TDirectDrawSurface);
    procedure DEdtSdoCommonHpKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DEdtSdoCommonHpKeyPress(Sender: TObject; var Key: Char);
    procedure DNewSdoAssistantCloseClick(Sender: TObject; X, Y: Integer);
    procedure DEdtSdoAutoMagicTimerDirectPaint(Sender: TObject;
      dsurface: TDirectDrawSurface);
    procedure DEdtSdoCommonHpTimerKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DBtnSdoRandomNameClick(Sender: TObject; X, Y: Integer);
    procedure DBtnSdoRandomNameDirectPaint(Sender: TObject;
      dsurface: TDirectDrawSurface);
    procedure DCheckSdoLongHitClick(Sender: TObject; X, Y: Integer);
    procedure DBtnSdoCallHeroKeyDirectPaint(Sender: TObject;
      dsurface: TDirectDrawSurface);
    procedure DBtnSdoCallHeroKeyKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DBtnSdoCallHeroKeyMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure DSdoHelpUpClick(Sender: TObject; X, Y: Integer);
    procedure DSdoHelpUpDirectPaint(Sender: TObject;
      dsurface: TDirectDrawSurface);
   
  private
    DlgTemp: TList;
    magcur, magtop: Integer;
    EdDlgEdit: TEdit;
    Memo: TMemo;

    ViewDlgEdit: Boolean;
    msglx, msgly: Integer;
    MenuTop: Integer;

    MagKeyIcon, MagKeyCurKey: Integer;
    MagKeyMagName: string;
    MagicPage: Integer;

    BlinkTime: LongWord;
    BlinkCount: Integer; //0..9荤捞甫 馆汗
        //商铺
    Buyitemlts: integer;

    procedure HideAllControls;
    procedure RestoreHideControls;
    procedure PageChanged;
    procedure DealItemReturnBag(mitem: TClientItem);
    procedure DealZeroGold;
    procedure OpenSoundOption;
  public
    StatePage: Integer;
    ShopTab: Integer;
    ShopPage: Integer;
    ShopPageCount: Integer;
    MsgText: string;
    DialogSize: Integer;
    DfonigTab: Integer;
    {
    m_n66C:Integer;
    m_n688:Integer;
    m_n6A4:Integer;
    m_n6A8:Integer;
    }
//    m_Dicea:array[0..35] of Integer;

    m_nDiceCount: Integer;
    m_boPlayDice: Boolean;
    m_Dice: array[0..9] of TDiceInfo;

    MerchantName: string;
    MerchantFace: Integer;
    MDlgStr: string;
    MDlgPoints: TList;
    RequireAddPoints: Boolean;
    SelectMenuStr: string;
    LastestClickTime: LongWord;
    SpotDlgMode: TSpotDlgMode;

    MenuList: TList; //list of PTClientGoods
    menuindex: Integer;
    CurDetailItem: string;
    MenuTopLine: Integer;
    BoDetailMenu: Boolean;
    BoStorageMenu: Boolean;
    BoNoDisplayMaxDura: Boolean;
    BoMakeDrugMenu: Boolean;
    NAHelps: TStringList;
    NewAccountTitle: string;

    DlgEditText: string;
    UserState1: TUserStateInfo;

    Guild: string;
    GuildFlag: string;
    GuildCommanderMode: Boolean;
    GuildStrs: TStringList;
    GuildStrs2: TStringList;
    GuildNotice: TStringList;
    GuildMembers: TStringList;
    GuildTopLine: Integer;
    GuildEditHint: string;
    GuildChats: TStringList;
    BoGuildChat: Boolean;

    procedure Initialize;
    procedure OpenMyStatus;
    procedure OpenUserState(UserState: TUserStateInfo);
    procedure OpenItemBag;
    procedure ViewBottomBox(Visible: Boolean);
    procedure CancelItemMoving;
    procedure DropMovingItem;
    procedure OpenAdjustAbility;

    procedure ShowSelectServerDlg;
    function DMessageDlg(msgstr: string; DlgButtons: TMsgDlgButtons): TModalResult;
    procedure ShowMDlg(face: Integer; mname, msgstr: string);
    procedure ShowGuildDlg;
    procedure ShowGuildEditNotice;
    procedure ShowGuildEditGrade;

    procedure ResetMenuDlg;
    procedure ShowShopMenuDlg;
    procedure ShowShopSellDlg;
    procedure CloseDSellDlg;
    procedure CloseMDlg;

    procedure ToggleShowGroupDlg;
    procedure OpenDealDlg;
    procedure CloseDealDlg;

    procedure OpenFriendDlg;

    procedure SoldOutGoods(itemserverindex: Integer);
    procedure DelStorageItem(itemserverindex: Integer);
    procedure GetMouseItemInfo(var iname, line1, line2, line3: string; var useable: Boolean);
    procedure SetMagicKeyDlg(icon: Integer; magname: string; var curkey: Word);
    procedure AddGuildChat(str: string);
    procedure closeShopItemListDlg;
    procedure OpenShopDlg;
    procedure OpenShopDlg2;
    procedure NewSdoAssistantPageChanged;

  end;

var
  FrmDlg: TFrmDlg;

implementation

uses
  ClMain, MShare, Share, SDK;



{$R *.DFM}

{
   ##  MovingItem.Index
      1~n : 啊规芒狼 酒捞袍 鉴辑
      -1~-8 : 厘馒芒俊辑狼 酒捞袍 鉴辑
      -97 : 背券芒狼 捣
      -98 : 捣
      -99 : 迫扁 芒俊辑狼 酒捞袍 鉴辑
      -20~29: 背券芒俊辑狼 酒捞袍 鉴辑
}

procedure TFrmDlg.FormCreate(Sender: TObject);
begin
  DfonigTab := 0;
  StatePage := 0;
  Buyitemlts := 0;
  ShopPage := 0;
  ShopPageCount := 0;
  ShopTab := 0;
  DlgTemp := TList.Create;
  DialogSize := 1; //扁夯 农扁
  m_nDiceCount := 0;
  m_boPlayDice := FALSE;
  magcur := 0;
  magtop := 0;
  MDlgPoints := TList.Create;
  SelectMenuStr := '';
  MenuList := TList.Create;
  menuindex := -1;
  MenuTopLine := 0;
  BoDetailMenu := FALSE;
  BoStorageMenu := FALSE;
  BoNoDisplayMaxDura := FALSE;
  BoMakeDrugMenu := FALSE;
  MagicPage := 0;
  NAHelps := TStringList.Create;
  BlinkTime := GetTickCount;
  BlinkCount := 0;

  g_SellDlgItem.S.name := '';
  Guild := '';
  GuildFlag := '';
  GuildCommanderMode := FALSE;
  GuildStrs := TStringList.Create;
  GuildStrs2 := TStringList.Create; //归诀侩
  GuildNotice := TStringList.Create;
  GuildMembers := TStringList.Create;
  GuildChats := TStringList.Create;

  EdDlgEdit := TEdit.Create(frmMain.Owner);
  with EdDlgEdit do begin
    Parent := frmMain;
    Color := clBlack;
    Font.Color := clWhite;
    Font.Size := 10;
    MaxLength := 30;
    Height := 16;
    Ctl3D := FALSE;
    BorderStyle := bsSingle; {OnKeyPress := EdDlgEditKeyPress;}
    Visible := FALSE;
  end;

  Memo := TMemo.Create(frmMain.Owner);
  with Memo do begin
    Parent := frmMain;
    Color := clBlack;
    Font.Color := clWhite;
    Font.Size := 10;
    Ctl3D := FALSE;
    BorderStyle := bsSingle; {OnKeyPress := EdDlgEditKeyPress;}
    Visible := FALSE;
  end;

end;

procedure TFrmDlg.closeShopItemListDlg;
var
   i: integer;
begin
   for i:=0 to g_ShopItemList.Count-1 do
      Dispose (pTShopItem(g_ShopItemList[i]));
      g_ShopItemList.Clear;
end;

procedure TFrmDlg.FormDestroy(Sender: TObject);
begin
  DlgTemp.Free;
  MDlgPoints.Free; //埃窜洒..
  MenuList.Free;
  NAHelps.Free;
  GuildStrs.Free;
  GuildStrs2.Free;
  GuildNotice.Free;
  GuildMembers.Free;
  GuildChats.Free;
end;

procedure TFrmDlg.HideAllControls;
var
  i: Integer;
  c: TControl;
begin
  DlgTemp.Clear;
  with frmMain do
    for i := 0 to ControlCount - 1 do begin
      c := Controls[i];
      if c is TEdit then
        if (c.Visible) and (c <> EdDlgEdit) then begin
          DlgTemp.Add(c);
          c.Visible := FALSE;
        end;
    end;
end;

procedure TFrmDlg.RestoreHideControls;
var
  i: Integer;
  c: TControl;
begin
  for i := 0 to DlgTemp.count - 1 do begin
    TControl(DlgTemp[i]).Visible := True;
  end;
end;

procedure TFrmDlg.Initialize; //霸烙阑 府胶配绢且锭付促 龋免凳
var
  i: Integer;
  d: TDirectDrawSurface;
begin
  g_DWinMan.ClearAll;

  DBackground.Left := 0;
  DBackground.Top := 0;
  DBackground.Width := SCREENWIDTH;
  DBackground.Height := SCREENHEIGHT;
  DBackground.Background := True;
  g_DWinMan.AddDControl(DBackground, True);

  {-----------------------------------------------------------}

  //皋技瘤 促捞倔肺弊 芒
  d := g_WMainImages.Images[360];
  if d <> nil then begin
    DMsgDlg.SetImgIndex(g_WMainImages, 360);
    DMsgDlg.Left := (SCREENWIDTH - d.Width) div 2;
    DMsgDlg.Top := (SCREENHEIGHT - d.Height) div 2;
  end;
  DMsgDlgOk.SetImgIndex(g_WMainImages, 361);
  DMsgDlgYes.SetImgIndex(g_WMainImages, 363);
  DMsgDlgCancel.SetImgIndex(g_WMainImages, 365);
  DMsgDlgNo.SetImgIndex(g_WMainImages, 367);
  DMsgDlgOk.Top := 126;
  DMsgDlgYes.Top := 126;
  DMsgDlgCancel.Top := 126;
  DMsgDlgNo.Top := 126;

  {-----------------------------------------------------------}

  //肺弊牢 芒
  d := g_WMainImages.Images[60];
  if d <> nil then begin
    DLogin.SetImgIndex(g_WMainImages, 60);
    DLogin.Left := (SCREENWIDTH - d.Width) div 2;
    DLogin.Top := (SCREENHEIGHT - d.Height) div 2;
  end;
  DLoginNew.SetImgIndex(g_WMainImages, 61);
  DLoginNew.Left := 24;
  DLoginNew.Top := 207;
  DLoginOk.SetImgIndex(g_WMainImages, 62);
  DLoginOk.Left := 171;
  DLoginOk.Top := 165;
  DLoginChgPw.SetImgIndex(g_WMainImages, 53);
  DLoginChgPw.Left := 111;
  DLoginChgPw.Top := 207;
  DLoginClose.SetImgIndex(g_WMainImages, 64);
  DLoginClose.Left := 252;
  DLoginClose.Top := 28;

  {-----------------------------------------------------------}
  //服务器选择窗口
  if not EnglishVersion then begin
    d := g_WMainImages.Images[160]; //81];
    if d <> nil then begin
      DSelServerDlg.SetImgIndex(g_WMainImages, 160);
      DSelServerDlg.Left := (SCREENWIDTH - d.Width) div 2;
      DSelServerDlg.Top := (SCREENHEIGHT - d.Height) div 2;
    end;
    DSSrvClose.SetImgIndex(g_WMainImages, 64);
    DSSrvClose.Left := 448;
    DSSrvClose.Top := 33;

    DSServer1.SetImgIndex(g_WMainImages, 161); //82);
    DSServer1.Left := 134;
    DSServer1.Top := 102;
    DSServer2.SetImgIndex(g_WMainImages, 162); //83);
    DSServer2.Left := 236;
    DSServer2.Top := 101;
    DSServer3.SetImgIndex(g_WMainImages, 163);
    DSServer3.Left := 87;
    DSServer3.Top := 190;
    DSServer4.SetImgIndex(g_WMainImages, 164);
    DSServer4.Left := 280;
    DSServer4.Top := 190;
    DSServer5.SetImgIndex(g_WMainImages, 165);
    DSServer5.Left := 134;
    DSServer5.Top := 280;
    DSServer6.SetImgIndex(g_WMainImages, 166);
    DSServer6.Left := 236;
    DSServer6.Top := 280;
    DEngServer1.Visible := FALSE;
  end else begin
    d := g_WMainImages.Images[256]; //81];
    if d <> nil then begin
      DSelServerDlg.SetImgIndex(g_WMainImages, 256);
      DSelServerDlg.Left := (SCREENWIDTH - d.Width) div 2;
      DSelServerDlg.Top := (SCREENHEIGHT - d.Height) div 2;
    end;
    DSSrvClose.SetImgIndex(g_WMainImages, 64);
    DSSrvClose.Left := 245;
    DSSrvClose.Top := 31;
    {
          DEngServer1.SetImgIndex (g_WMainImages, 257);
          DEngServer1.Left := 65;
          DEngServer1.Top  := 204;
    }

    DSServer1.SetImgIndex(g_WMain3Images, 2);
    DSServer1.Left := 65;
    DSServer1.Top := 100;

    DSServer2.SetImgIndex(g_WMain3Images, 2);
    DSServer2.Left := 65;
    DSServer2.Top := 145;

    DSServer3.SetImgIndex(g_WMain3Images, 2);
    DSServer3.Left := 65;
    DSServer3.Top := 190;

    DSServer4.SetImgIndex(g_WMain3Images, 2);
    DSServer4.Left := 65;
    DSServer4.Top := 235;

    DSServer5.SetImgIndex(g_WMain3Images, 2);
    DSServer5.Left := 65;
    DSServer5.Top := 280;

    DSServer6.SetImgIndex(g_WMain3Images, 2);
    DSServer6.Left := 65;
    DSServer6.Top := 325;

    DEngServer1.Visible := FALSE;
    DSServer1.Visible := FALSE;
    DSServer2.Visible := FALSE;
    DSServer3.Visible := FALSE;
    DSServer4.Visible := FALSE;
    DSServer5.Visible := FALSE;
    DSServer6.Visible := FALSE;

  end;

  {-----------------------------------------------------------}

  //登录窗口
  d := g_WMainImages.Images[63];
  if d <> nil then begin
    DNewAccount.SetImgIndex(g_WMainImages, 63);
    DNewAccount.Left := (SCREENWIDTH - d.Width) div 2;
    DNewAccount.Top := (SCREENHEIGHT - d.Height) div 2;
  end;
  DNewAccountOk.SetImgIndex(g_WMainImages, 62);
  DNewAccountOk.Left := 160;
  DNewAccountOk.Top := 417;
  DNewAccountCancel.SetImgIndex(g_WMainImages, 52);
  DNewAccountCancel.Left := 448;
  DNewAccountCancel.Top := 419;
  DNewAccountClose.SetImgIndex(g_WMainImages, 64);
  DNewAccountClose.Left := 587;
  DNewAccountClose.Top := 33;

  {-----------------------------------------------------------}

  //修改密码窗口
  d := g_WMainImages.Images[50];
  if d <> nil then begin
    DChgPw.SetImgIndex(g_WMainImages, 50);
    DChgPw.Left := (SCREENWIDTH - d.Width) div 2;
    DChgPw.Top := (SCREENHEIGHT - d.Height) div 2;
  end;
  DChgpwOk.SetImgIndex(g_WMainImages, 62);
  DChgpwOk.Left := 182;
  DChgpwOk.Top := 252;
  DChgpwCancel.SetImgIndex(g_WMainImages, 52);
  DChgpwCancel.Left := 277;
  DChgpwCancel.Top := 251;




  {-----------------------------------------------------------}

  //选择角色窗口
  DSelectChr.Left := 0;
  DSelectChr.Top := 0;
  DSelectChr.Width := SCREENWIDTH;
  DSelectChr.Height := SCREENHEIGHT;
  DscSelect1.SetImgIndex(g_WMainImages, 66);
  DscSelect2.SetImgIndex(g_WMainImages, 67);
  DscStart.SetImgIndex(g_WMainImages, 68);
  DscNewChr.SetImgIndex(g_WMainImages, 69);
  DscEraseChr.SetImgIndex(g_WMainImages, 70);
  DscCredits.SetImgIndex(g_WMainImages, 71);
  DscExit.SetImgIndex(g_WMainImages, 72);

  DscSelect1.Left := (SCREENWIDTH - 800) div 2 + 134 {134};
  DscSelect1.Top := (SCREENHEIGHT - 600) div 2 + 454 {454};
  DscSelect2.Left := (SCREENWIDTH - 800) div 2 + 685 {685};
  DscSelect2.Top := (SCREENHEIGHT - 600) div 2 + 454 {454};
  DscStart.Left := (SCREENWIDTH - 800) div 2 + 385 {385};
  DscStart.Top := (SCREENHEIGHT - 600) div 2 + 456 {456};
  DscNewChr.Left := (SCREENWIDTH - 800) div 2 + 348 {348};
  DscNewChr.Top := (SCREENHEIGHT - 600) div 2 + 486 {486};
  DscEraseChr.Left := (SCREENWIDTH - 800) div 2 + 347 {347};
  DscEraseChr.Top := (SCREENHEIGHT - 600) div 2 + 506 {506};
  DscCredits.Left := (SCREENWIDTH - 800) div 2 + 362 {362};
  DscCredits.Top := (SCREENHEIGHT - 600) div 2 + 527 {527};
  DscExit.Left := (SCREENWIDTH - 800) div 2 + 379 {379};
  DscExit.Top := (SCREENHEIGHT - 600) div 2 + 547 {547};

  {-----------------------------------------------------------}

  //创建角色窗口
  d := g_WMainImages.Images[73];
  if d <> nil then begin
    DCreateChr.SetImgIndex(g_WMainImages, 73);
    DCreateChr.Left := (SCREENWIDTH - d.Width) div 2;
    DCreateChr.Top := (SCREENHEIGHT - d.Height) div 2;
  end;
  DccWarrior.SetImgIndex(g_WMainImages, 74);
  DccWizzard.SetImgIndex(g_WMainImages, 75);
  DccMonk.SetImgIndex(g_WMainImages, 76);
  //DccReserved.SetImgIndex (g_WMainImages.Images[76], TRUE);
  DccMale.SetImgIndex(g_WMainImages, 77);
  DccFemale.SetImgIndex(g_WMainImages, 78);
  DccLeftHair.SetImgIndex(g_WMainImages, 79);
  DccRightHair.SetImgIndex(g_WMainImages, 80);
  DccOk.SetImgIndex(g_WMainImages, 62);
  DccClose.SetImgIndex(g_WMainImages, 64);
  DccWarrior.Left := 48;
  DccWarrior.Top := 157;
  DccWizzard.Left := 93;
  DccWizzard.Top := 157;
  DccMonk.Left := 138;
  DccMonk.Top := 157;
  //DccReserved.Left := 183;
  //DccReserved.Top := 157;
  DccMale.Left := 93;
  DccMale.Top := 231;
  DccFemale.Left := 138;
  DccFemale.Top := 231;
  DccLeftHair.Left := 76;
  DccLeftHair.Top := 308;
  DccRightHair.Left := 170;
  DccRightHair.Top := 308;
  DccOk.Left := 104;
  DccOk.Top := 361;
  DccClose.Left := 248;
  DccClose.Top := 31;


  {-----------------------------------------------------------}
  d := g_WMainImages.Images[50]; //修改密码窗口
  if d <> nil then begin
    DChgGamePwd.SetImgIndex(g_WMainImages, 689);
    DChgGamePwd.Left := (SCREENWIDTH - d.Width) div 2;
    DChgGamePwd.Top := (SCREENHEIGHT - d.Height) div 2;
  end;
  DChgGamePwdClose.Left := 291; // 399;
  DChgGamePwdClose.Top := 8;
  DChgGamePwdClose.SetImgIndex(g_WMainImages, 64);


  //人物状态窗口
  d := g_WMain3Images.Images[207]; //惑怕  370
  if d <> nil then begin
    DStateWin.SetImgIndex(g_WMain3Images, 207);
    DStateWin.Left := SCREENWIDTH - d.Width;
    DStateWin.Top := 0;
  end;
  DSWNecklace.Left := 38 + 130;
  DSWNecklace.Top := 52 + 35;
  DSWNecklace.Width := 34;
  DSWNecklace.Height := 31;
  DSWHelmet.Left := 38 + 77;
  DSWHelmet.Top := 52 + 41;
  DSWHelmet.Width := 18;
  DSWHelmet.Height := 18;
  DSWLight.Left := 38 + 130;
  DSWLight.Top := 52 + 73;
  DSWLight.Width := 34;
  DSWLight.Height := 31;
  DSWArmRingR.Left := 38 + 4;
  DSWArmRingR.Top := 52 + 124;
  DSWArmRingR.Width := 34;
  DSWArmRingR.Height := 31;
  DSWArmRingL.Left := 38 + 130;
  DSWArmRingL.Top := 52 + 124;
  DSWArmRingL.Width := 34;
  DSWArmRingL.Height := 31;
  DSWRingR.Left := 38 + 4;
  DSWRingR.Top := 52 + 163;
  DSWRingR.Width := 34;
  DSWRingR.Height := 31;
  DSWRingL.Left := 38 + 130;
  DSWRingL.Top := 52 + 163;
  DSWRingL.Width := 34;
  DSWRingL.Height := 31;
  DSWWeapon.Left := 38 + 9;
  DSWWeapon.Top := 52 + 28;
  DSWWeapon.Width := 47;
  DSWWeapon.Height := 87;
  DSWDress.Left := 38 + 58;
  DSWDress.Top := 52 + 70;
  DSWDress.Width := 53;
  DSWDress.Height := 112;

  DSWBujuk.Left := 42;
  DSWBujuk.Top := 254;
  DSWBujuk.Width := 34;
  DSWBujuk.Height := 31;

  DSWBelt.Left := 84;
  DSWBelt.Top := 254;
  DSWBelt.Width := 34;
  DSWBelt.Height := 31;

  DSWBoots.Left := 126;
  DSWBoots.Top := 254;
  DSWBoots.Width := 34;
  DSWBoots.Height := 31;

  DSWCharm.Left := 168;
  DSWCharm.Top := 254;
  DSWCharm.Width := 34;
  DSWCharm.Height := 31;

  DStMag1.Left := 38 + 8;
  DStMag1.Top := 52 + 7;
  DStMag1.Width := 31;
  DStMag1.Height := 33;

  DStMag2.Left := 38 + 8;
  DStMag2.Top := 52 + 44;
  DStMag2.Width := 31;
  DStMag2.Height := 33;

  DStMag3.Left := 38 + 8;
  DStMag3.Top := 52 + 82;
  DStMag3.Width := 31;
  DStMag3.Height := 33;

  DStMag4.Left := 38 + 8;
  DStMag4.Top := 52 + 119;
  DStMag4.Width := 31;
  DStMag4.Height := 33;

  DStMag5.Left := 38 + 8;
  DStMag5.Top := 52 + 156;
  DStMag5.Width := 31;
  DStMag5.Height := 33;

  DStPageUp.SetImgIndex(g_WMainImages, 398);
  DStPageDown.SetImgIndex(g_WMainImages, 396);
  DStPageUp.Left := 213;
  DStPageUp.Top := 113;
  DStPageDown.Left := 213;
  DStPageDown.Top := 143;

  DCloseState.SetImgIndex(g_WMainImages, 371);
  DCloseState.Left := 8;
  DCloseState.Top := 39;
  DPrevState.SetImgIndex(g_WMainImages, 373);
  DNextState.SetImgIndex(g_WMainImages, 372);
  DPrevState.Left := 7;
  DPrevState.Top := 128;
  DNextState.Left := 7;
  DNextState.Top := 187;

  {-----------------------------------------------------------}

  //人物状态窗口(查看别人信息)
  d := g_WMain3Images.Images[207]; //惑怕  370
  if d <> nil then begin
    DUserState1.SetImgIndex(g_WMain3Images, 207);
    DUserState1.Left := SCREENWIDTH - d.Width - d.Width;
    DUserState1.Top := 0;
  end;
  DNecklaceUS1.Left := 38 + 130;
  DNecklaceUS1.Top := 52 + 35;
  DNecklaceUS1.Width := 34;
  DNecklaceUS1.Height := 31;

  DHelmetUS1.Left := 38 + 77;
  DHelmetUS1.Top := 52 + 41;
  DHelmetUS1.Width := 18;
  DHelmetUS1.Height := 18;

  DLightUS1.Left := 38 + 130;
  DLightUS1.Top := 52 + 73;
  DLightUS1.Width := 34;
  DLightUS1.Height := 31;

  DArmringRUS1.Left := 38 + 4;
  DArmringRUS1.Top := 52 + 124;
  DArmringRUS1.Width := 34;
  DArmringRUS1.Height := 31;

  DArmringLUS1.Left := 38 + 130;
  DArmringLUS1.Top := 52 + 124;
  DArmringLUS1.Width := 34;
  DArmringLUS1.Height := 31;

  DRingRUS1.Left := 38 + 4;
  DRingRUS1.Top := 52 + 163;
  DRingRUS1.Width := 34;
  DRingRUS1.Height := 31;

  DRingLUS1.Left := 38 + 130;
  DRingLUS1.Top := 52 + 163;
  DRingLUS1.Width := 34;
  DRingLUS1.Height := 31;

  DWeaponUS1.Left := 38 + 9;
  DWeaponUS1.Top := 52 + 28;
  DWeaponUS1.Width := 47;
  DWeaponUS1.Height := 87;

  DDressUS1.Left := 38 + 58;
  DDressUS1.Top := 52 + 70;
  DDressUS1.Width := 53;
  DDressUS1.Height := 112;

  DBujukUS1.Left := 42;
  DBujukUS1.Top := 254;
  DBujukUS1.Width := 34;
  DBujukUS1.Height := 31;

  DBeltUS1.Left := 84;
  DBeltUS1.Top := 254;
  DBeltUS1.Width := 34;
  DBeltUS1.Height := 31;

  DBootsUS1.Left := 126;
  DBootsUS1.Top := 254;
  DBootsUS1.Width := 34;
  DBootsUS1.Height := 31;

  DCharmUS1.Left := 168;
  DCharmUS1.Top := 254;
  DCharmUS1.Width := 34;
  DCharmUS1.Height := 31;

  DCloseUS1.SetImgIndex(g_WMainImages, 371);
  DCloseUS1.Left := 8;
  DCloseUS1.Top := 39;

  {-------------------------------------------------------------}

   //物品包裹栏
  DItemBag.SetImgIndex(g_WMain3Images, 6);
  DItemBag.Left := 0;
  DItemBag.Top := 0;

  DItemGrid.Left := 29;
  DItemGrid.Top := 41;
  DItemGrid.Width := 286;
  DItemGrid.Height := 162;
  //主控面板
{$IF SWH = SWH800}
  d := g_WMain3Images.Images[BOTTOMBOARD800];
{$ELSEIF SWH = SWH1024}
  d := g_WMainImages.Images[BOTTOMBOARD1024];
{$IFEND}
  if d <> nil then begin
    DBottom.Left := 0;
    DBottom.Top := SCREENHEIGHT - d.Height;
    DBottom.Width := d.Width;
    DBottom.Height := d.Height;
  end;

  {-----------------------------------------------------------}

   //底部状态栏的4个快捷按钮
  DMyState.SetImgIndex(g_WMainImages, 8);
  DMyState.Left := SCREENWIDTH div 2 + (SCREENWIDTH div 2 - (400 - 243)) {643};
  DMyState.Top := 61;
  DMyBag.SetImgIndex(g_WMainImages, 9);
  DMyBag.Left := SCREENWIDTH div 2 + (SCREENWIDTH div 2 - (400 - 282)) {682};
  DMyBag.Top := 41;
  DMyMagic.SetImgIndex(g_WMainImages, 10);
  DMyMagic.Left := SCREENWIDTH div 2 + (SCREENWIDTH div 2 - (400 - 322)) {722};
  DMyMagic.Top := 21;
  DOption.SetImgIndex(g_WMainImages, 11);
  DOption.Left := SCREENWIDTH div 2 + (SCREENWIDTH div 2 - (400 - 364)) {764};
  DOption.Top := 11;

  //商铺按钮
  DButtonShop.SetImgIndex(g_WMain3Images, 297);
  DButtonShop.Left := SCREENWIDTH - 45;
  DButtonShop.Top := 204;

  //底部状态栏的小地图、交易、行会、组按钮
  DBotMiniMap.SetImgIndex(g_WMainImages, DlgConf.DBotMiniMap.Image {130});
  DBotMiniMap.Left := DlgConf.DBotMiniMap.Left {219};
  DBotMiniMap.Top := DlgConf.DBotMiniMap.Top {104};
  DBotTrade.SetImgIndex(g_WMainImages, DlgConf.DBotTrade.Image {132});
  DBotTrade.Left := DlgConf.DBotTrade.Left {219 + 30}; //560 - 30;
  DBotTrade.Top := DlgConf.DBotTrade.Top {104};
  DBotGuild.SetImgIndex(g_WMainImages, DlgConf.DBotGuild.Image {134});
  DBotGuild.Left := DlgConf.DBotGuild.Left {219 + 30*2};
  DBotGuild.Top := DlgConf.DBotGuild.Top {104};
  DBotGroup.SetImgIndex(g_WMainImages, DlgConf.DBotGroup.Image {128});
  DBotGroup.Left := DlgConf.DBotGroup.Left {219 + 30*3};
  DBotGroup.Top := DlgConf.DBotGroup.Top {104};


 { DButtonPlayPosition.SetImgIndex(g_WMain3Images, 460);
  DButtonPlayPosition.Left := 219 + 30*4;
  DButtonPlayPosition.Top := 104;

  DButtonSendOfSell.SetImgIndex(g_WMain3Images, 460);
  DButtonSendOfSell.Left := 219 + 30*5;
  DButtonSendOfSell.Top := 104; }

  DBotPlusAbil.SetImgIndex(g_WMainImages, DlgConf.DBotPlusAbil.Image {140});
  DBotPlusAbil.Left := DlgConf.DBotPlusAbil.Left {219 + 30*6};
  DBotPlusAbil.Top := DlgConf.DBotPlusAbil.Top {104};


  DBotMemo.SetImgIndex(g_WMainImages, DlgConf.DBotMemo.Image {532});
  DBotMemo.Left := DlgConf.DBotMemo.Left {753};
  DBotMemo.Top := DlgConf.DBotMemo.Top {204};

  DBotExit.SetImgIndex(g_WMainImages, DlgConf.DBotExit.Image {138});
  DBotExit.Left := DlgConf.DBotExit.Left {560};
  DBotExit.Top := DlgConf.DBotExit.Top {104};
  DBotLogout.SetImgIndex(g_WMainImages, DlgConf.DBotLogout.Image {136});
  DBotLogout.Left := DlgConf.DBotLogout.Left {560 - 30};
  DBotLogout.Top := DlgConf.DBotLogout.Top {104};


  {-----------------------------------------------------------}

  //Belt 快捷栏
  DBelt1.Left := SCREENWIDTH div 2 - 115; //285;
  DBelt1.Width := 32;
  DBelt1.Top := 59;
  DBelt1.Height := 29;

  DBelt2.Left := DBelt1.Left + 43; //328;
  DBelt2.Width := 32;
  DBelt2.Top := 59;
  DBelt2.Height := 29;

  DBelt3.Left := DBelt2.Left + 43; //371;
  DBelt3.Width := 32;
  DBelt3.Top := 59;
  DBelt3.Height := 29;

  DBelt4.Left := DBelt3.Left + 43; //415;
  DBelt4.Width := 32;
  DBelt4.Top := 59;
  DBelt4.Height := 29;

  DBelt5.Left := DBelt4.Left + 43; //459;
  DBelt5.Width := 32;
  DBelt5.Top := 59;
  DBelt5.Height := 29;

  DBelt6.Left := DBelt5.Left + 43; //503;
  DBelt6.Width := 32;
  DBelt6.Top := 59;
  DBelt6.Height := 29;

  {-----------------------------------------------------------}

  //黄金、修理物品、关闭包裹按钮
  DGold.SetImgIndex(g_WMainImages, 29);
  DGold.Left := 18;
  DGold.Top := 218;

  DRepairItem.SetImgIndex(g_WMainImages, 26);
  DRepairItem.Left := 254;
  DRepairItem.Top := 183;
  DRepairItem.Width := 48;
  DRepairItem.Height := 22;
  DCloseBag.SetImgIndex(g_WMainImages, 371);
  DCloseBag.Downed := True; //??
  DCloseBag.Left := 336;
  DCloseBag.Top := 59;
  DCloseBag.Width := 14;
  DCloseBag.Height := 20;
  d := g_WMain3Images.Images[207]; //惑怕
  if d <> nil then begin
    DStateWin.SetImgIndex(g_WMain3Images, 207);
    DStateWin.Left := SCREENWIDTH - d.Width;
    DStateWin.Top := 0;
  end;
  {-----------------------------------------------------------}

  //商人对话框
  d := g_WMainImages.Images[384];
  if d <> nil then begin
    DMerchantDlg.Left := 0;
    DMerchantDlg.Top := 0;
    DMerchantDlg.SetImgIndex(g_WMainImages, 384);
  end;
  DMerchantDlgClose.Left := 399;
  DMerchantDlgClose.Top := 1;
  DMerchantDlgClose.SetImgIndex(g_WMainImages, 64);
  {-----------------------------------------------------------}
  //行会通告编辑框
  d := g_WMainImages.Images[204];
  if d <> nil then begin
    DConfigDlg.SetImgIndex(g_WMainImages, 204);
    DConfigDlg.Left := (SCREENWIDTH - d.Width) div 2;
    DConfigDlg.Top := (SCREENHEIGHT - d.Height) div 2;
  end;
  DConfigDlgOK.SetImgIndex(g_WMainImages, 361);
  DConfigDlgOK.Left := 514;
  DConfigDlgOK.Top := 287;
  DConfigDlgClose.Left := 584;
  DConfigDlgClose.Top := 6;
  DConfigDlgClose.SetImgIndex(g_WMainImages, 64);

  {-----------------------------------------------------------}
  //菜单对话框
  d := g_WMainImages.Images[385];
  if d <> nil then begin
    DMenuDlg.Left := 138;
    DMenuDlg.Top := 163;
    DMenuDlg.SetImgIndex(g_WMainImages, 385);
  end;
  DMenuPrev.Left := 43;
  DMenuPrev.Top := 175;
  DMenuPrev.SetImgIndex(g_WMainImages, 388);
  DMenuNext.Left := 90;
  DMenuNext.Top := 175;
  DMenuNext.SetImgIndex(g_WMainImages, 387);
  DMenuBuy.Left := 215;
  DMenuBuy.Top := 171;
  DMenuBuy.SetImgIndex(g_WMainImages, 386);
  DMenuClose.Left := 291;
  DMenuClose.Top := 0;
  DMenuClose.SetImgIndex(g_WMainImages, 64);

  {-----------------------------------------------------------}

  //出售
  d := g_WMainImages.Images[392];
  if d <> nil then begin
    DSellDlg.Left := 328;
    DSellDlg.Top := 163;
    DSellDlg.SetImgIndex(g_WMainImages, 392);
  end;
  DSellDlgOk.Left := 85;
  DSellDlgOk.Top := 150;
  DSellDlgOk.SetImgIndex(g_WMainImages, 393);
  DSellDlgClose.Left := 115;
  DSellDlgClose.Top := 0;
  DSellDlgClose.SetImgIndex(g_WMainImages, 64);
  DSellDlgSpot.Left := 27;
  DSellDlgSpot.Top := 67;
  DSellDlgSpot.Width := 61;
  DSellDlgSpot.Height := 52;

  {-----------------------------------------------------------}

  //设置魔法快捷对话框
  d := g_WMainImages.Images[229];
  if d <> nil then begin
    DKeySelDlg.Left := (SCREENWIDTH - d.Width) div 2;
    DKeySelDlg.Top := (SCREENHEIGHT - d.Height) div 2;
    DKeySelDlg.SetImgIndex(g_WMainImages, 229);
  end;
  DKsIcon.Left := 52; //DMagIcon...
  DKsIcon.Top := 29;
  DKsF1.SetImgIndex(g_WMainImages, 232);
  DKsF1.Left := 34;
  DKsF1.Top := 83;
  DKsF2.SetImgIndex(g_WMainImages, 234);
  DKsF2.Left := 66;
  DKsF2.Top := 83;
  DKsF3.SetImgIndex(g_WMainImages, 236);
  DKsF3.Left := 98;
  DKsF3.Top := 83;
  DKsF4.SetImgIndex(g_WMainImages, 238);
  DKsF4.Left := 130;
  DKsF4.Top := 83;
  DKsF5.SetImgIndex(g_WMainImages, 240);
  DKsF5.Left := 171;
  DKsF5.Top := 83;
  DKsF6.SetImgIndex(g_WMainImages, 242);
  DKsF6.Left := 203;
  DKsF6.Top := 83;
  DKsF7.SetImgIndex(g_WMainImages, 244);
  DKsF7.Left := 235;
  DKsF7.Top := 83;
  DKsF8.SetImgIndex(g_WMainImages, 246);
  DKsF8.Left := 267;
  DKsF8.Top := 83;

  DKsNone.SetImgIndex(g_WMainImages, 230);
  DKsNone.Left := 299;
  DKsNone.Top := 83;
  DKsOk.SetImgIndex(g_WMainImages, 62);
  DKsOk.Left := 222;
  DKsOk.Top := 131;

  {-----------------------------------------------------------}
  //组对话框
  d := g_WMainImages.Images[120];
  if d <> nil then begin
    DGroupDlg.Left := (SCREENWIDTH - d.Width) div 2;
    DGroupDlg.Top := (SCREENHEIGHT - d.Height) div 2;
    DGroupDlg.SetImgIndex(g_WMainImages, 120);
  end;
  DGrpDlgClose.SetImgIndex(g_WMainImages, 64);
  DGrpDlgClose.Left := 260;
  DGrpDlgClose.Top := 0;
  DGrpAllowGroup.SetImgIndex(g_WMainImages, 122);
  DGrpAllowGroup.Left := 20;
  DGrpAllowGroup.Top := 18;
  DGrpCreate.SetImgIndex(g_WMainImages, 123);
  DGrpCreate.Left := 21 + 1;
  DGrpCreate.Top := 202 + 1;
  DGrpAddMem.SetImgIndex(g_WMainImages, 124);
  DGrpAddMem.Left := 96 + 1;
  DGrpAddMem.Top := 202 + 1;
  DGrpDelMem.SetImgIndex(g_WMainImages, 125);
  DGrpDelMem.Left := 171 + 1;
  DGrpDelMem.Top := 202 + 1;

  {-----------------------------------------------------------}
  //交易对话框
  d := g_WMainImages.Images[389]; //卖出方
  if d <> nil then begin
    DDealDlg.Left := SCREENWIDTH - d.Width;
    DDealDlg.Top := 0;
    DDealDlg.SetImgIndex(g_WMainImages, 389);
  end;
  DDGrid.Left := 21;
  DDGrid.Top := 56;
  DDGrid.Width := 36 * 5;
  DDGrid.Height := 33 * 2;
  DDealOk.SetImgIndex(g_WMainImages, 391);
  DDealOk.Left := 155;
  DDealOk.Top := 193 - 65;
  DDealClose.SetImgIndex(g_WMainImages, 64);
  DDealClose.Left := 220;
  DDealClose.Top := 42;
  DDGold.SetImgIndex(g_WMainImages, 28);
  DDGold.Left := 11;
  DDGold.Top := 202 - 65;


  d := g_WMainImages.Images[390]; //买进方
  if d <> nil then begin
    DDealRemoteDlg.Left := DDealDlg.Left - d.Width;
    DDealRemoteDlg.Top := 0;
    DDealRemoteDlg.SetImgIndex(g_WMainImages, 390);
  end;
  DDRGrid.Left := 21;
  DDRGrid.Top := 56;
  DDRGrid.Width := 36 * 5;
  DDRGrid.Height := 33 * 2;
  DDRGold.SetImgIndex(g_WMainImages, 28);
  DDGold.Left := 11;
  DDGold.Top := 202 - 65;

  {-----------------------------------------------------------}
//商铺
//商铺
  DShopStdItem1.Left := 186;
  DShopStdItem1.Width := 32;
  DShopStdItem1.Top := 70;
  DShopStdItem1.Height := 29;

  DShopStdItem2.Left := 357;
  DShopStdItem2.Width := 32;
  DShopStdItem2.Top := 70;
  DShopStdItem2.Height := 29;

  DShopStdItem3.Left := 186;
  DShopStdItem3.Width := 32;
  DShopStdItem3.Top := 125;
  DShopStdItem3.Height := 29;

  DShopStdItem4.Left := 357;
  DShopStdItem4.Width := 32;
  DShopStdItem4.Top := 125;
  DShopStdItem4.Height := 29;

  DShopStdItem5.Left := 186;
  DShopStdItem5.Width := 32;
  DShopStdItem5.Top := 180;
  DShopStdItem5.Height := 29;

  DShopStdItem6.Left := 357;
  DShopStdItem6.Width := 32;
  DShopStdItem6.Top := 180;
  DShopStdItem6.Height := 29;

  DShopStdItem7.Left := 186;
  DShopStdItem7.Width := 32;
  DShopStdItem7.Top := 235-1;
  DShopStdItem7.Height := 29;

  DShopStdItem8.Left := 357;
  DShopStdItem8.Width := 32;
  DShopStdItem8.Top := 235-1;
  DShopStdItem8.Height := 29;

  DShopStdItem9.Left := 186;
  DShopStdItem9.Width := 32;
  DShopStdItem9.Top := 290-1;
  DShopStdItem9.Height := 29;

  DShopStdItem10.Left := 357;
  DShopStdItem10.Width := 32;
  DShopStdItem10.Top := 290-1;
  DShopStdItem10.Height := 29;

  DShopSuperStdItem1.Left := 560;
  DShopSuperStdItem1.Top := 68;
  DShopSuperStdItem1.Width := 32;
  DShopSuperStdItem1.Height := 29;


  DShopSuperStdItem2.Left := 560;
  DShopSuperStdItem2.Top := 133;
  DShopSuperStdItem2.Width := 32;
  DShopSuperStdItem2.Height := 29;

  DShopSuperStdItem3.Left := 560;
  DShopSuperStdItem3.Top := 199;
  DShopSuperStdItem3.Width := 32;
  DShopSuperStdItem3.Height := 29;

  DShopSuperStdItem4.Left := 560;
  DShopSuperStdItem4.Top := 263;
  DShopSuperStdItem4.Width := 32;
  DShopSuperStdItem4.Height := 29;

  DShopSuperStdItem5.Left := 560;
  DShopSuperStdItem5.Top := 328;
  DShopSuperStdItem5.Width := 32;
  DShopSuperStdItem5.Height := 29;



  DShopIntroduce.Left := 10;
  DShopIntroduce.Width := 150;
  DShopIntroduce.Top := 25;
  DShopIntroduce.Height := 180;

  d := g_WMain3Images.Images[298];
  if d <> nil then begin
    DShop.Left := (SCREENWIDTH - d.Width) div 2;
    DShop.Top := 0 {(SCREENHEIGHT - d.Height) div 2};
    DShop.SetImgIndex(g_WMain3Images, 298);
  end;
  DJewelry.Left := 176;
  DJewelry.Top := 13;
  DJewelry.SetImgIndex(g_WMain3Images, 299); {首饰}

  DMedicine.Left := 234;
  DMedicine.Top := 13;
  DMedicine.SetImgIndex(g_WMain3Images, 300); {补给}

  DEnhance.Left := 292 + 1;
  DEnhance.Top := 13;
  DEnhance.SetImgIndex(g_WMain3Images, 301); {强化}

  Dfriend.Left := 350 - 1;
  Dfriend.Top := 13;
  Dfriend.SetImgIndex(g_WMain3Images, 302); {好友}

  DLimit.Left := 408 - 1;
  DLimit.Top := 13;
  DLimit.SetImgIndex(g_WMain3Images, 303); {限量}

  DShopExit.SetImgIndex(g_WMainImages, 64);
  DShopExit.Left := 600 + 6;
  DShopExit.Top := 5;


  DPrevShop.Left := 197;
  DPrevShop.Top := 349;
  DPrevShop.SetImgIndex(g_WMainImages, 388); {上一页}

  DNextShop.Left := 287;
  DNextShop.Top := 349;
  DNextShop.SetImgIndex(g_WMainImages, 387); {下一页}

  DShopBuy.Left := 328;
  DShopBuy.Top := 364;
  DShopBuy.SetImgIndex(g_WMain3Images, 304); {购买}

  DShopFree.Left := DShopBuy.Left + 58;
  DShopFree.Top := 364;
  DShopFree.SetImgIndex(g_WMain3Images, 305); {赠送}

  DShopClose.Left := DShopFree.Left + 58;
  DShopClose.Top := 364;
  DShopClose.SetImgIndex(g_WMain3Images, 306); {购买}

  {-----------------------------------------------------------}
  //行会
  d := g_WMainImages.Images[180];
  if d <> nil then begin
    DGuildDlg.Left := 0;
    DGuildDlg.Top := 0;
    DGuildDlg.SetImgIndex(g_WMainImages, 180);
  end;
  DGDClose.Left := 584;
  DGDClose.Top := 6;
  DGDClose.SetImgIndex(g_WMainImages, 64);
  DGDHome.Left := 13;
  DGDHome.Top := 411;
  DGDHome.SetImgIndex(g_WMainImages, 198);
  DGDList.Left := 13;
  DGDList.Top := 429;
  DGDList.SetImgIndex(g_WMainImages, 200);
  DGDChat.Left := 94;
  DGDChat.Top := 429;
  DGDChat.SetImgIndex(g_WMainImages, 190);
  DGDAddMem.Left := 243;
  DGDAddMem.Top := 411;
  DGDAddMem.SetImgIndex(g_WMainImages, 182);
  DGDDelMem.Left := 243;
  DGDDelMem.Top := 429;
  DGDDelMem.SetImgIndex(g_WMainImages, 192);
  DGDEditNotice.Left := 325;
  DGDEditNotice.Top := 411;
  DGDEditNotice.SetImgIndex(g_WMainImages, 196);
  DGDEditGrade.Left := 325;
  DGDEditGrade.Top := 429;
  DGDEditGrade.SetImgIndex(g_WMainImages, 194);
  DGDAlly.Left := 407;
  DGDAlly.Top := 411;
  DGDAlly.SetImgIndex(g_WMainImages, 184);
  DGDBreakAlly.Left := 407;
  DGDBreakAlly.Top := 429;
  DGDBreakAlly.SetImgIndex(g_WMainImages, 186);
  DGDWar.Left := 529;
  DGDWar.Top := 411;
  DGDWar.SetImgIndex(g_WMainImages, 202);
  DGDCancelWar.Left := 529;
  DGDCancelWar.Top := 429;
  DGDCancelWar.SetImgIndex(g_WMainImages, 188);

  DGDUp.Left := 595;
  DGDUp.Top := 239;
  DGDUp.SetImgIndex(g_WMainImages, 373);
  DGDDown.Left := 595;
  DGDDown.Top := 291;
  DGDDown.SetImgIndex(g_WMainImages, 372);

  //行会通告编辑框
  DGuildEditNotice.SetImgIndex(g_WMainImages, 204);
  DGEOk.SetImgIndex(g_WMainImages, 361);
  DGEOk.Left := 514;
  DGEOk.Top := 287;
  DGEClose.SetImgIndex(g_WMainImages, 64);
  DGEClose.Left := 584;
  DGEClose.Top := 6;


  {-----------------------------------------------------------}
  //属性调整对话框
  DAdjustAbility.SetImgIndex(g_WMainImages, 226);
  DAdjustAbilClose.SetImgIndex(g_WMainImages, 64);
  DAdjustAbilClose.Left := 316;
  DAdjustAbilClose.Top := 1;
  DAdjustAbilOk.SetImgIndex(g_WMainImages, 62);
  DAdjustAbilOk.Left := 220;
  DAdjustAbilOk.Top := 298;

  DPlusDC.SetImgIndex(g_WMainImages, 227);
  DPlusDC.Left := 217;
  DPlusDC.Top := 101;
  DPlusMC.SetImgIndex(g_WMainImages, 227);
  DPlusMC.Left := 217;
  DPlusMC.Top := 121;
  DPlusSC.SetImgIndex(g_WMainImages, 227);
  DPlusSC.Left := 217;
  DPlusSC.Top := 140;
  DPlusAC.SetImgIndex(g_WMainImages, 227);
  DPlusAC.Left := 217;
  DPlusAC.Top := 160;
  DPlusMAC.SetImgIndex(g_WMainImages, 227);
  DPlusMAC.Left := 217;
  DPlusMAC.Top := 181;
  DPlusHP.SetImgIndex(g_WMainImages, 227);
  DPlusHP.Left := 217;
  DPlusHP.Top := 201;
  DPlusMP.SetImgIndex(g_WMainImages, 227);
  DPlusMP.Left := 217;
  DPlusMP.Top := 220;
  DPlusHit.SetImgIndex(g_WMainImages, 227);
  DPlusHit.Left := 217;
  DPlusHit.Top := 240;
  DPlusSpeed.SetImgIndex(g_WMainImages, 227);
  DPlusSpeed.Left := 217;
  DPlusSpeed.Top := 261;

  DMinusDC.SetImgIndex(g_WMainImages, 228);
  DMinusDC.Left := 227;
  DMinusDC.Top := 101;
  DMinusMC.SetImgIndex(g_WMainImages, 228);
  DMinusMC.Left := 227;
  DMinusMC.Top := 121;
  DMinusSC.SetImgIndex(g_WMainImages, 228);
  DMinusSC.Left := 227;
  DMinusSC.Top := 140;
  DMinusAC.SetImgIndex(g_WMainImages, 228);
  DMinusAC.Left := 227;
  DMinusAC.Top := 160;
  DMinusMAC.SetImgIndex(g_WMainImages, 228);
  DMinusMAC.Left := 227;
  DMinusMAC.Top := 181;
  DMinusHP.SetImgIndex(g_WMainImages, 228);
  DMinusHP.Left := 227;
  DMinusHP.Top := 201;
  DMinusMP.SetImgIndex(g_WMainImages, 228);
  DMinusMP.Left := 227;
  DMinusMP.Top := 220;
  DMinusHit.SetImgIndex(g_WMainImages, 228);
  DMinusHit.Left := 227;
  DMinusHit.Top := 240;
  DMinusSpeed.SetImgIndex(g_WMainImages, 228);
  DMinusSpeed.Left := 227;
  DMinusSpeed.Top := 261;

  {d := g_WMain3Images.Images[34];
  if d <> nil then begin
    DFriendDlg.SetImgIndex(g_WMain3Images, 34);
    DFriendDlg.Left := 0;
    DFriendDlg.Top := 0;
  end;
  DFrdClose.SetImgIndex(g_WMainImages, 371);
  DFrdClose.Left := 247;
  DFrdClose.Top := 5;
  DFrdPgUp.SetImgIndex(g_WMainImages, 373);
  DFrdPgUp.Left := 259;
  DFrdPgUp.Top := 102;
  DFrdPgDn.SetImgIndex(g_WMainImages, 372);
  DFrdPgDn.Left := 259;
  DFrdPgDn.Top := 154;
  DFrdFriend.SetImgIndex(g_WMain3Images, 42);
  DFrdFriend.Left := 15;
  DFrdFriend.Top := 35;
  DFrdBlackList.SetImgIndex(g_WMainImages, 573);
  DFrdBlackList.Left := 130;
  DFrdBlackList.Top := 35;
  DFrdAdd.SetImgIndex(g_WMainImages, 554);
  DFrdAdd.Left := 90;
  DFrdAdd.Top := 233;
  DFrdDel.SetImgIndex(g_WMainImages, 556);
  DFrdDel.Left := 124;
  DFrdDel.Top := 233;
  DFrdMemo.SetImgIndex(g_WMainImages, 558);
  DFrdMemo.Left := 158;
  DFrdMemo.Top := 233;
  DFrdMail.SetImgIndex(g_WMainImages, 560);
  DFrdMail.Left := 192;
  DFrdMail.Top := 233;
  DFrdWhisper.SetImgIndex(g_WMainImages, 562);
  DFrdWhisper.Left := 226;
  DFrdWhisper.Top := 233;  }


 
  d := g_WMainImages.Images[537];
  if d <> nil then begin
    DMemo.SetImgIndex(g_WMainImages, 537);
    DMemo.Left := 290;
    DMemo.Top := 0;
  end;
  DMemoClose.SetImgIndex(g_WMainImages, 371);
  DMemoClose.Left := 205;
  DMemoClose.Top := 1;
  DMemoB1.SetImgIndex(g_WMainImages, 544);
  DMemoB1.Left := 58;
  DMemoB1.Top := 114;
  DMemoB2.SetImgIndex(g_WMainImages, 538);
  DMemoB2.Left := 126;
  DMemoB2.Top := 114;

  DButtonHP.Left := 40;
  DButtonHP.Top := 91;
  DButtonHP.Width := 45;
  DButtonHP.Height := 90;

  DButtonMP.Left := 40 + 47;
  DButtonMP.Top := 91;
  DButtonMP.Width := 45;
  DButtonMP.Height := 90;
  {
     //背包物品窗口
     DItemBag.SetImgIndex (g_WMain3Images, 6);
     DItemBag.Left := 0;
     DItemBag.Top := 0;

     DItemGrid.Left := 29;
     DItemGrid.Top  := 41;
     DItemGrid.Width := 286;
     DItemGrid.Height := 162;

     DClosebag.Downed:=True;
     DCloseBag.Left := 336;
     DCloseBag.Top := 59;
     DCloseBag.Width := 14;
     DCloseBag.Height := 20;

     DGold.Left := 18;
     DGold.Top  := 218;
     d := g_WMain3Images.Images[207];  //惑怕
     if d <> nil then begin
        DStateWin.SetImgIndex (g_WMain3Images, 207);
        DStateWin.Left := SCREENWIDTH - d.Width;
        DStateWin.Top := 0;
     end;}
     //原来


//盛大新内挂

  { DWNewSdoAssistant.SetImgIndex(g_WMain2Images, 608);
   DNewSdoAssistantClose.SetImgIndex(g_WMain2Images, 279);
   DNewSdoBasic.SetImgIndex(g_WMain2Images, 609);
   DNewSdoProtect.SetImgIndex(g_WMain2Images, 609);
   DNewSdoSkill.SetImgIndex(g_WMain2Images, 609);
   DNewSdoKey.SetImgIndex(g_WMain2Images, 609);
   DNedSdoHelp.SetImgIndex(g_WMain2Images, 609);
   DSdoHelpUp.SetImgIndex(g_WMain2Images, 292);
   DSdoHelpNext.SetImgIndex(g_WMain2Images, 294);
                                                    }
   //盛大新内挂

   DWNewSdoAssistant.SetImgIndex(g_WMain2Images, 607);
   DNewSdoAssistantClose.SetImgIndex(g_WMain2Images, 279);
      DNewSdoBasic.SetImgIndex(g_WMain2Images, 608);
   DNewSdoProtect.SetImgIndex(g_WMain2Images, 608);
   DNewSdoSkill.SetImgIndex(g_WMain2Images, 608);
   DNewSdoKey.SetImgIndex(g_WMain2Images, 608);
   DNedSdoHelp.SetImgIndex(g_WMain2Images, 608);  

  { DNewSdoBasic.SetImgIndex(g_LBImages, 5);
   DNewSdoProtect.SetImgIndex(g_LBImages, 5);
   DNewSdoSkill.SetImgIndex(g_LBImages, 5);
   DNewSdoKey.SetImgIndex(g_LBImages, 5);
   DNedSdoHelp.SetImgIndex(g_LBImages, 5);}
   DSdoHelpUp.SetImgIndex(g_WMain2Images, 292);
   DSdoHelpNext.SetImgIndex(g_WMain2Images, 294);

   //盛大新内挂 20080624
   DWNewSdoAssistant.Left := 200;
   DWNewSdoAssistant.Top := 140;
   DNewSdoAssistantClose.Left := 394;
   DNewSdoAssistantClose.Top := 1;
   DNewSdoBasic.Left := 10;
   DNewSdoBasic.Top := 14;
   DNewSdoProtect.Left := 58; // DNewSdoBasic+48
   DNewSdoProtect.Top := 14;
   DNewSdoSkill.Left := 106;
   DNewSdoSkill.Top := 14;
   DNewSdoKey.Left := 154;
   DNewSdoKey.Top := 14;
   DNedSdoHelp.Left := 202;
   DNedSdoHelp.Top := 14;
   //基本页里
   DCheckSdoNameShow.Left := 40;
   DCheckSdoNameShow.Top := 73;
   DCheckSdoNameShow.Width := 71;
   DCheckSdoNameShow.Height := 17;
   DCheckSdoDuraWarning.Left := 40;
   DCheckSdoDuraWarning.Top := 97;
   DCheckSdoDuraWarning.Width := 71;
   DCheckSdoDuraWarning.Height := 17;
   DCheckSdoAvoidShift.Top := 121;
   DCheckSdoAvoidShift.Left := 40;
   DCheckSdoAvoidShift.Width := 78;
   DCheckSdoAvoidShift.Height := 17;
   DCheckSdoExpFiltrate.Top := 145;
   DCheckSdoExpFiltrate.Left := 40;
   DCheckSdoExpFiltrate.Width := 78;
   DCheckSdoExpFiltrate.Height := 17;
   DCheckSdoItemsHint.Top := 73;
   DCheckSdoItemsHint.Left := 157;
   DCheckSdoItemsHint.Width := 71;
   DCheckSdoItemsHint.Height := 17;
   DCheckSdoShowFiltrate.Top := 97;
   DCheckSdoShowFiltrate.Left := 157;
   DCheckSdoShowFiltrate.Width := 71;
   DCheckSdoShowFiltrate.Height := 17;
   DCheckSdoAutoPickItems.Top := 121;
   DCheckSdoAutoPickItems.Left := 157;
   DCheckSdoAutoPickItems.Width := 71;
   DCheckSdoAutoPickItems.Height := 17;
   DCheckSdoPickFiltrate.Top := 145;
   DCheckSdoPickFiltrate.Left := 157;
   DCheckSdoPickFiltrate.Width := 71;
   DCheckSdoPickFiltrate.Height := 17;
   //保护页里
   DCheckSdoCommonHp.Top := 73;
   DCheckSdoCommonHp.Left := 40;
   DCheckSdoCommonHp.Width := 48;
   DCheckSdoCommonHp.Height := 17;
   DEdtSdoCommonHp.Top := 73;
   DEdtSdoCommonHp.Left := 89;
   DEdtSdoCommonHp.Width := 50;
   DEdtSdoCommonHp.Height := 19;
   DEdtSdoCommonHpTimer.Top := 73;
   DEdtSdoCommonHpTimer.Left := 150;
   DEdtSdoCommonHpTimer.Width := 24;
   DEdtSdoCommonHpTimer.Height := 19;
   DCheckSdoCommonMp.Top := 97;
   DCheckSdoCommonMp.Left := 40;
   DCheckSdoCommonMp.Width := 48;
   DCheckSdoCommonMp.Height := 17;
   DEdtSdoCommonMp.Top := 97;
   DEdtSdoCommonMp.Left := 89;
   DEdtSdoCommonMp.Width := 50;
   DEdtSdoCommonMp.Height := 19;
   DEdtSdoCommonMpTimer.Top := 97;
   DEdtSdoCommonMpTimer.Left := 150;
   DEdtSdoCommonMpTimer.Width := 24;
   DEdtSdoCommonMpTimer.Height := 19;
   DCheckSdoSpecialHp.Top := 145;
   DCheckSdoSpecialHp.Left := 40;
   DCheckSdoSpecialHp.Width := 48;
   DCheckSdoSpecialHp.Height := 17;
   DEdtSdoSpecialHp.Top := 145;
   DEdtSdoSpecialHp.Left := 89;
   DEdtSdoSpecialHp.Width := 50;
   DEdtSdoSpecialHp.Height := 19;
   DEdtSdoSpecialHpTimer.Top := 145;
   DEdtSdoSpecialHpTimer.Left := 150;
   DEdtSdoSpecialHpTimer.Width := 24;
   DEdtSdoSpecialHpTimer.Height := 19;
   DCheckSdoRandomHp.Top := 193;
   DCheckSdoRandomHp.Left := 40;
   DCheckSdoRandomHp.Width := 48;
   DCheckSdoRandomHp.Height := 17;
   DEdtSdoRandomHp.Top := 193;
   DEdtSdoRandomHp.Left := 89;
   DEdtSdoRandomHp.Width := 50;
   DEdtSdoRandomHp.Height := 19;
   DEdtSdoRandomHpTimer.Top := 193;
   DEdtSdoRandomHpTimer.Left := 150;
   DEdtSdoRandomHpTimer.Width := 24;
   DEdtSdoRandomHpTimer.Height := 19;
   DBtnSdoRandomName.Top := 218;
   DBtnSdoRandomName.Left := 89;
   DBtnSdoRandomName.Width := 85;
   DBtnSdoRandomName.Height := 20;

   DCheckSdoAutoDrinkWine.Top := 74;
   DCheckSdoAutoDrinkWine.Left := 290;
   DCheckSdoAutoDrinkWine.Width := 20;
   DCheckSdoAutoDrinkWine.Height := 17;
   DEdtSdoDrunkWineDegree.Top := 73;
   DEdtSdoDrunkWineDegree.Left := 317;
   DEdtSdoDrunkWineDegree.Width := 20;
   DEdtSdoDrunkWineDegree.Height := 19;

   DCheckSdoHeroAutoDrinkWine.Top := 98;
   DCheckSdoHeroAutoDrinkWine.Left := 290;
   DCheckSdoHeroAutoDrinkWine.Width := 20;
   DCheckSdoHeroAutoDrinkWine.Height := 17;
   DEdtSdoHeroDrunkWineDegree.Top := 97;
   DEdtSdoHeroDrunkWineDegree.Left := 317;
   DEdtSdoHeroDrunkWineDegree.Width := 20;
   DEdtSdoHeroDrunkWineDegree.Height := 19;

   DCheckSdoAutoDrinkDrugWine.Top := 122;
   DCheckSdoAutoDrinkDrugWine.Left := 290;
   DCheckSdoAutoDrinkDrugWine.Width := 20;
   DCheckSdoAutoDrinkDrugWine.Height := 17;
   DEdtSdoDrunkDrugWineDegree.Top := 121;
   DEdtSdoDrunkDrugWineDegree.Left := 317;
   DEdtSdoDrunkDrugWineDegree.Width := 20;
   DEdtSdoDrunkDrugWineDegree.Height := 19;

   DCheckSdoHeroAutoDrinkDrugWine.Top := 146;
   DCheckSdoHeroAutoDrinkDrugWine.Left := 290;
   DCheckSdoHeroAutoDrinkDrugWine.Width := 20;
   DCheckSdoHeroAutoDrinkDrugWine.Height := 17;
   DEdtSdoHeroDrunkDrugWineDegree.Top := 145;
   DEdtSdoHeroDrunkDrugWineDegree.Left := 317;
   DEdtSdoHeroDrunkDrugWineDegree.Width := 20;
   DEdtSdoHeroDrunkDrugWineDegree.Height := 19;
   
   //技能页里
   DCheckSdoLongHit.Top := 73;
   DCheckSdoLongHit.Left := 40;
   DCheckSdoLongHit.Width := 71;
   DCheckSdoLongHit.Height := 17;
   DCheckSdoAutoWideHit.Top := 97;
   DCheckSdoAutoWideHit.Left := 40;
   DCheckSdoAutoWideHit.Width := 71;
   DCheckSdoAutoWideHit.Height := 17;
   DCheckSdoAutoFireHit.Top := 121;
   DCheckSdoAutoFireHit.Left := 40;
   DCheckSdoAutoFireHit.Width := 71;
   DCheckSdoAutoFireHit.Height := 17;
   DCheckSdoZhuri.Top := 145;
   DCheckSdoZhuri.Left := 40;
   DCheckSdoZhuri.Width := 71;
   DCheckSdoZhuri.Height := 17;
   DCheckSdoAutoShield.Top := 193;
   DCheckSdoAutoShield.Left := 40;
   DCheckSdoAutoShield.Width := 71;
   DCheckSdoAutoShield.Height := 17;
   DCheckSdoHeroShield.Top := 217;
   DCheckSdoHeroShield.Left := 40;
   DCheckSdoHeroShield.Width := 106;
   DCheckSdoHeroShield.Height := 17;
   DCheckSdoAutoHide.Top := 73;
   DCheckSdoAutoHide.Left := 157;
   DCheckSdoAutoHide.Width := 71;
   DCheckSdoAutoHide.Height := 17;
   DCheckSdoAutoMagic.Top := 73;
   DCheckSdoAutoMagic.Left := 270;
   DCheckSdoAutoMagic.Width := 71;
   DCheckSdoAutoMagic.Height := 17;
   DEdtSdoAutoMagicTimer.Top := 73;
   DEdtSdoAutoMagicTimer.Left := 346;
   DEdtSdoAutoMagicTimer.Width := 24;
   DEdtSdoAutoMagicTimer.Height := 19;
   //按键页里
   DCheckSdoStartKey.Top := 43;
   DCheckSdoStartKey.Left := 23;
   DCheckSdoStartKey.Width := 118;
   DCheckSdoStartKey.Height := 19;
   DBtnSdoCallHeroKey.Top := 86;
   DBtnSdoCallHeroKey.Left := 255;
   DBtnSdoCallHeroKey.Width := 130;
   DBtnSdoCallHeroKey.Height := 19;

   DBtnSdoHeroAttackTargetKey.Top := 108;
   DBtnSdoHeroAttackTargetKey.Left := 255;
   DBtnSdoHeroAttackTargetKey.Width := 130;
   DBtnSdoHeroAttackTargetKey.Height := 19;

   DBtnSdoHeroGotethKey.Top := 130;
   DBtnSdoHeroGotethKey.Left := 255;
   DBtnSdoHeroGotethKey.Width := 130;
   DBtnSdoHeroGotethKey.Height := 19;

   DBtnSdoHeroStateKey.Top := 152;
   DBtnSdoHeroStateKey.Left := 255;
   DBtnSdoHeroStateKey.Width := 130;
   DBtnSdoHeroStateKey.Height := 19;

   DBtnSdoHeroGuardKey.Top := 174;
   DBtnSdoHeroGuardKey.Left := 255;
   DBtnSdoHeroGuardKey.Width := 130;
   DBtnSdoHeroGuardKey.Height := 19;

   DBtnSdoAttackModeKey.Top := 196;
   DBtnSdoAttackModeKey.Left := 255;
   DBtnSdoAttackModeKey.Width := 130;
   DBtnSdoAttackModeKey.Height := 19;

   DBtnSdoMinMapKey.Top := 218;
   DBtnSdoMinMapKey.Left := 255;
   DBtnSdoMinMapKey.Width := 130;
   DBtnSdoMinMapKey.Height := 19;

   //帮助页里
   DSdoHelpUp.Left := 383;
   DSdoHelpUp.Top := 39;
   DSdoHelpNext.Left := 383;
   DSdoHelpNext.Top := 225;
   //SplashForm.ProgressBar1.Position := SplashForm.ProgressBar1.Position + 4;
end;



//声音
procedure TFrmDlg.OpenSoundOption;
begin
  g_boSound := not g_boSound;
  if g_boSound then begin
    DScreen.AddChatBoardString('[打开声音]', clWhite, clBlack);
  end else begin
    DScreen.AddChatBoardString('[关闭声音]', clWhite, clBlack);
  end;
end;
//打开/关闭我的属性对话框
procedure TFrmDlg.OpenMyStatus;
begin
  DStateWin.Visible := not DStateWin.Visible;
  PageChanged;
end;
//显示玩加信息对话框
procedure TFrmDlg.OpenUserState(UserState: TUserStateInfo);
begin
  UserState1 := UserState;
  DUserState1.Visible := True;
end;

//显示/关闭物品对话框
procedure TFrmDlg.OpenItemBag;
begin
  DItemBag.Visible := not DItemBag.Visible;
  if DItemBag.Visible then
    ArrangeItembag;
end;

//底部状态框
procedure TFrmDlg.ViewBottomBox(Visible: Boolean);
begin
  DBottom.Visible := Visible;
end;


// 取消物品移动
procedure TFrmDlg.CancelItemMoving;
var
  idx, n: Integer;
begin
  if g_boItemMoving then begin
    g_boItemMoving := FALSE;
    idx := g_MovingItem.Index;
    if idx < 0 then begin
      if (idx <= -20) and (idx > -30) then begin
        AddDealItem(g_MovingItem.Item);
      end else begin
        n := -(idx + 1);
        if n in [0..12] then begin
          g_UseItems[n] := g_MovingItem.Item;
        end;
      end;
    end else
      if idx in [0..MAXBAGITEM - 1] then begin
      if g_ItemArr[idx].S.name = '' then begin
        g_ItemArr[idx] := g_MovingItem.Item;
      end else begin
        AddItemBag(g_MovingItem.Item);
      end;
    end;
    g_MovingItem.Item.S.name := '';
  end;
  ArrangeItembag;
end;

//把移动的物品放下
procedure TFrmDlg.DropMovingItem;
var
  idx: Integer;
begin
  if g_boItemMoving then begin
    g_boItemMoving := FALSE;
    if g_MovingItem.Item.S.name <> '' then begin
      frmMain.SendDropItem(g_MovingItem.Item.S.name, g_MovingItem.Item.MakeIndex);
      AddDropItem(g_MovingItem.Item);
      g_MovingItem.Item.S.name := '';
    end;
  end;
end;
//打开属性调整对话框
procedure TFrmDlg.OpenAdjustAbility;
begin
  DAdjustAbility.Left := 0;
  DAdjustAbility.Top := 0;
  g_nSaveBonusPoint := g_nBonusPoint;
  FillChar(g_BonusAbilChg, sizeof(TNakedAbility), #0);
  DAdjustAbility.Visible := True;
end;

procedure TFrmDlg.DBackgroundBackgroundClick(Sender: TObject);
var
  dropgold: Integer;
  valstr: string;
begin
  if g_boItemMoving then begin
    DBackground.WantReturn := True;
    if g_MovingItem.Item.S.name = g_sGoldName {'金币'} then begin
      g_boItemMoving := FALSE;
      g_MovingItem.Item.S.name := '';
      //倔付甫 滚副 扒瘤 拱绢夯促.
      DialogSize := 1;
      DMessageDlg('你想放下多少' + g_sGoldName + '数量?', [mbOk, mbAbort]);
      GetValidStrVal(DlgEditText, valstr, [' ']);
      dropgold := Str_ToInt(valstr, 0);
      //
      frmMain.SendDropGold(dropgold);
    end;
    if g_MovingItem.Index >= 0 then //酒捞袍 啊规俊辑 滚赴巴父..
      DropMovingItem;
  end;
end;

procedure TFrmDlg.DBackgroundMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if g_boItemMoving then begin
    DBackground.WantReturn := True;
  end;
end;

procedure TFrmDlg.DBottomMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
  function ExtractUserName(line: string): string;
  var
    uname: string;
  begin
    GetValidStr3(line, line, ['(', '!', '*', '/', ')']);
    GetValidStr3(line, uname, [' ', '=', ':']);
    if uname <> '' then
      if (uname[1] = '/') or (uname[1] = '(') or (uname[1] = ' ') or (uname[1] = '[') then
        uname := '';
    Result := uname;
  end;
var
  n: Integer;
  str: string;
begin
  DScreen.ClearHint;
  //当鼠标点在底部状态栏的消息上时
  if (X >= 208) and (X <= 208 + 374) and (Y >= SCREENHEIGHT - 130) and (Y <= SCREENHEIGHT - 130 + 12 * 9) then begin
    n := DScreen.ChatBoardTop + (Y - (SCREENHEIGHT - 130)) div 12;
    if (n < DScreen.ChatStrs.count) then begin
      if not PlayScene.EdChat.Visible then begin
        PlayScene.EdChat.Visible := True;
        PlayScene.EdChat.SetFocus;
      end;
      PlayScene.EdChat.Text := '/' + ExtractUserName(DScreen.ChatStrs[n]) + ' ';
      PlayScene.EdChat.SelStart := Length(PlayScene.EdChat.Text);
      PlayScene.EdChat.SelLength := 0;
    end else
      PlayScene.EdChat.Text := '';
  end;
end;





{------------------------------------------------------------------------}

////显示通用对话框
function TFrmDlg.DMessageDlg(msgstr: string; DlgButtons: TMsgDlgButtons): TModalResult;
const
  XBase = 324;
var
  i: Integer;
  lx, ly: Integer;
  d: TDirectDrawSurface;
  procedure ShowDice();
  var
    i: Integer;
    bo05: Boolean;
  begin
    if m_nDiceCount = 1 then begin
      if m_Dice[0].n67C < 20 then begin
        if GetTickCount - m_Dice[0].dwPlayTick > 100 then begin
          if m_Dice[0].n67C div 5 = 4 then begin
            m_Dice[0].nPlayPoint := Random(6) + 1;
          end else begin
            m_Dice[0].nPlayPoint := m_Dice[0].n67C div 5 + 8;
          end;
          m_Dice[0].dwPlayTick := GetTickCount();
          Inc(m_Dice[0].n67C);
        end;
        Exit;
      end; //00491461
      m_Dice[0].nPlayPoint := m_Dice[0].nDicePoint;
      if GetTickCount - m_Dice[0].dwPlayTick > 1500 then begin
        DMsgDlg.Visible := FALSE;
      end;
      Exit;
    end; //004914AD

    bo05 := True;
    for i := 0 to m_nDiceCount - 1 do begin
      if m_Dice[i].n67C < m_Dice[i].n680 then begin
        if GetTickCount - m_Dice[i].dwPlayTick > 100 then begin
          if m_Dice[i].n67C div 5 = 4 then begin
            m_Dice[i].nPlayPoint := Random(6) + 1;
          end else begin
            m_Dice[i].nPlayPoint := m_Dice[i].n67C div 5 + 8;
          end;
          m_Dice[i].dwPlayTick := GetTickCount();
          Inc(m_Dice[i].n67C);
        end;
        bo05 := FALSE;
      end else begin //004915E4
        m_Dice[i].nPlayPoint := m_Dice[i].nDicePoint;
        if GetTickCount - m_Dice[i].dwPlayTick < 2000 then begin
          bo05 := FALSE;
        end;
      end;
    end; //for
    if bo05 then begin
      DMsgDlg.Visible := FALSE;
    end;

  end;
begin
  if DConfigDlg.Visible then begin //打开提示框时关闭选项框
    DOptionClick();
  end;

  lx := XBase;
  ly := 126;
  case DialogSize of
    0: {//小对话框} begin
        d := g_WMainImages.Images[381];
        if d <> nil then begin
          DMsgDlg.SetImgIndex(g_WMainImages, 381);
          DMsgDlg.Left := (SCREENWIDTH - d.Width) div 2;
          DMsgDlg.Top := (SCREENHEIGHT - d.Height) div 2;
          msglx := 39;
          msgly := 38;
          lx := 90;
          ly := 36;
        end;
      end;
    1: {//大对话框（横）} begin
        d := g_WMainImages.Images[360];
        if d <> nil then begin
          DMsgDlg.SetImgIndex(g_WMainImages, 360);
          DMsgDlg.Left := (SCREENWIDTH - d.Width) div 2;
          DMsgDlg.Top := (SCREENHEIGHT - d.Height) div 2;
          msglx := 39;
          msgly := 38;
          lx := XBase;
          ly := 126;
        end;
      end;
    2: {//大对话框（竖）} begin
        d := g_WMainImages.Images[380];
        if d <> nil then begin
          DMsgDlg.SetImgIndex(g_WMainImages, 380);
          DMsgDlg.Left := (SCREENWIDTH - d.Width) div 2;
          DMsgDlg.Top := (SCREENHEIGHT - d.Height) div 2;
          msglx := 23;
          msgly := 20;
          lx := 90;
          ly := 305;
        end;
      end;
  end;
  MsgText := msgstr;
  ViewDlgEdit := FALSE; //编辑框不可见
  DMsgDlg.Floating := True; //允许鼠标移动
  DMsgDlgOk.Visible := FALSE;
  DMsgDlgYes.Visible := FALSE;
  DMsgDlgCancel.Visible := FALSE;
  DMsgDlgNo.Visible := FALSE;
  DMsgDlg.Left := (SCREENWIDTH - DMsgDlg.Width) div 2;
  DMsgDlg.Top := (SCREENHEIGHT - DMsgDlg.Height) div 2;

  for i := 0 to m_nDiceCount - 1 do begin
    m_Dice[i].n67C := 0;
    m_Dice[i].n680 := Random(m_nDiceCount + 2) * 5 + 10;
    m_Dice[i].nPlayPoint := 1;
    m_Dice[i].dwPlayTick := GetTickCount();
  end;

  if mbCancel in DlgButtons then begin
    DMsgDlgCancel.Left := lx;
    DMsgDlgCancel.Top := ly;
    DMsgDlgCancel.Visible := True;
    lx := lx - 110;
  end;
  if mbNo in DlgButtons then begin
    DMsgDlgNo.Left := lx;
    DMsgDlgNo.Top := ly;
    DMsgDlgNo.Visible := True;
    lx := lx - 110;
  end;
  if mbYes in DlgButtons then begin
    DMsgDlgYes.Left := lx;
    DMsgDlgYes.Top := ly;
    DMsgDlgYes.Visible := True;
    lx := lx - 110;
  end;
  if (mbOk in DlgButtons) or (lx = XBase) then begin
    DMsgDlgOk.Left := lx;
    DMsgDlgOk.Top := ly;
    DMsgDlgOk.Visible := True;
    lx := lx - 110;
  end;
  HideAllControls;
  DMsgDlg.ShowModal;
  if mbAbort in DlgButtons then begin
    ViewDlgEdit := True; //俊靛飘 牧飘费捞 焊咯具 窍绰 版快.
    DMsgDlg.Floating := FALSE;
    with EdDlgEdit do begin
      Text := '';
      Width := DMsgDlg.Width - 70;
      Left := (SCREENWIDTH - EdDlgEdit.Width) div 2;
      Top := (SCREENHEIGHT - EdDlgEdit.Height) div 2 - 10;
    end;
  end;
  Result := mrOk;

  while True do begin
    if not DMsgDlg.Visible then break;
    //FrmMain.DXTimerTimer (self, 0);
    frmMain.ProcOnIdle;
    Application.ProcessMessages;

    if m_nDiceCount > 0 then begin
      m_boPlayDice := True;

      for i := 0 to m_nDiceCount - 1 do begin
        m_Dice[i].nX := ((DMsgDlg.Width div 2 + 6) - ((m_nDiceCount * 32 + m_nDiceCount) div 2)) + (i * 32 + i);
        m_Dice[i].nY := DMsgDlg.Height div 2 - 14;
      end;

      ShowDice();

    end;

    if Application.Terminated then Exit;
  end;

  EdDlgEdit.Visible := FALSE;
  RestoreHideControls;
  DlgEditText := EdDlgEdit.Text;
  if PlayScene.EdChat.Visible then PlayScene.EdChat.SetFocus;
  ViewDlgEdit := FALSE;
  Result := DMsgDlg.DialogResult;
  DialogSize := 1; //扁夯惑怕
  m_nDiceCount := 0;
  m_boPlayDice := FALSE;
end;

procedure TFrmDlg.DMsgDlgOkClick(Sender: TObject; X, Y: Integer);
begin
  if Sender = DMsgDlgOk then DMsgDlg.DialogResult := mrOk;
  if Sender = DMsgDlgYes then DMsgDlg.DialogResult := mrYes;
  if Sender = DMsgDlgCancel then DMsgDlg.DialogResult := mrCancel;
  if Sender = DMsgDlgNo then DMsgDlg.DialogResult := mrNo;
  DMsgDlg.Visible := FALSE;
end;

procedure TFrmDlg.DMsgDlgKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = 13 then begin
    if DMsgDlgOk.Visible and not (DMsgDlgYes.Visible or DMsgDlgCancel.Visible or DMsgDlgNo.Visible) then begin
      DMsgDlg.DialogResult := mrOk;
      DMsgDlg.Visible := FALSE;
    end;
    if DMsgDlgYes.Visible and not (DMsgDlgOk.Visible or DMsgDlgCancel.Visible or DMsgDlgNo.Visible) then begin
      DMsgDlg.DialogResult := mrYes;
      DMsgDlg.Visible := FALSE;
    end;
  end;
  if Key = 27 then begin
    if DMsgDlgCancel.Visible then begin
      DMsgDlg.DialogResult := mrCancel;
      DMsgDlg.Visible := FALSE;
    end;
  end;
end;
{
procedure TFrmDlg.DMsgDlgOkDirectPaint(Sender: TObject;
  dsurface: TDirectDrawSurface);
var
  d: TDirectDrawSurface;
  tGame:pGameInfo;
  tServer:pServerInfo;
  tStr:String;
begin
   with Sender as TDButton do begin
      if not Downed then
         d := WLib.Images[FaceIndex]
      else d := WLib.Images[FaceIndex+1];
      if d <> nil then
         dsurface.Draw (SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, TRUE);

      tGame:=GameList.Items[SelServerIndex];
      if (Name = 'DSServer1') and (tGame.ServerList.Count > 0) then begin
         tServer:=tGame.ServerList[0];
         tStr:=tServer.CaptionName;
      end;
      if (Name = 'DSServer2') and (tGame.ServerList.Count > 1) then begin
         tServer:=tGame.ServerList[1];
         tStr:=tServer.CaptionName;
      end;
      if (Name = 'DSServer3') and (tGame.ServerList.Count > 2) then begin
         tServer:=tGame.ServerList[2];
         tStr:=tServer.CaptionName;
      end;
      if (Name = 'DSServer4') and (tGame.ServerList.Count > 3) then begin
         tServer:=tGame.ServerList[3];
         tStr:=tServer.CaptionName;
      end;
      if (Name = 'DSServer5') and (tGame.ServerList.Count > 4) then begin
         tServer:=tGame.ServerList[4];
         tStr:=tServer.CaptionName;
      end;
      if (Name = 'DSServer6') and (tGame.ServerList.Count > 5) then begin
         tServer:=tGame.ServerList[5];
         tStr:=tServer.CaptionName;
      end;
          SetBkMode (dsurface.Canvas.Handle, TRANSPARENT);
          dsurface.Canvas.Font.Size :=12;
          BoldTextOut (dsurface, SurfaceX(Left + (d.Width - dsurface.Canvas.TextWidth(tStr)) div 2), SurfaceY(Top + (d.Height -dsurface.Canvas.TextHeight(tStr)) div 2), clYellow, clBlack, tStr);
          dsurface.Canvas.Font.Size :=9;
//          dsurface.Canvas.Font:=oFont;
          dsurface.Canvas.Release;
   end;
end;
}
procedure TFrmDlg.DMsgDlgOkDirectPaint(Sender: TObject;
  dsurface: TDirectDrawSurface);
var
  d: TDirectDrawSurface;
  tStr: string;
  Color: TColor;
  nStatus: Integer;
begin
  try
    nStatus := -1;
    with Sender as TDButton do begin
      if not Downed then
        d := WLib.Images[FaceIndex]
      else d := WLib.Images[FaceIndex + 1];
      if d <> nil then
        dsurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, True);

      if (name = 'DSServer1') and (g_ServerList.count >= 1) then begin
        tStr := g_ServerList.Strings[0];
        nStatus := Integer(g_ServerList.Objects[0]);
      end;
      if (name = 'DSServer2') and (g_ServerList.count >= 2) then begin
        tStr := g_ServerList.Strings[1];
        nStatus := Integer(g_ServerList.Objects[1]);
      end;
      if (name = 'DSServer3') and (g_ServerList.count >= 3) then begin
        tStr := g_ServerList.Strings[2];
        nStatus := Integer(g_ServerList.Objects[2]);
      end;
      if (name = 'DSServer4') and (g_ServerList.count >= 4) then begin
        tStr := g_ServerList.Strings[3];
        nStatus := Integer(g_ServerList.Objects[3]);
      end;
      if (name = 'DSServer5') and (g_ServerList.count >= 5) then begin
        tStr := g_ServerList.Strings[4];
        nStatus := Integer(g_ServerList.Objects[4]);
      end;
      if (name = 'DSServer6') and (g_ServerList.count >= 6) then begin
        tStr := g_ServerList.Strings[5];
        nStatus := Integer(g_ServerList.Objects[5]);
      end;
      Color := clYellow;
      {   case nStatus of    //原来
           0: begin
             tStr:=tStr + '(维护)';
             Color:=clDkGray;
           end;
           1: begin
             tStr:=tStr + '(空闲)';
             Color:=clLime;
           end;
           2: begin
             tStr:=tStr + '(良好)';
             Color:=clGreen;
           end;
           3: begin
             tStr:=tStr + '(繁忙)';
             Color:=clMaroon;
           end;
           4: begin
             tStr:=tStr + '(满员)';
             Color:=clRed;
           end;
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      end; }//原来
      SetBkMode(dsurface.Canvas.Handle, TRANSPARENT);
      dsurface.Canvas.Font.Size := 11;
      dsurface.Canvas.Font.Style := [fsBold];
      if TDButton(Sender).Downed then begin
        BoldTextOut(dsurface, SurfaceX(Left + (d.Width - dsurface.Canvas.TextWidth(tStr)) div 2) + 2, SurfaceY(Top + (d.Height - dsurface.Canvas.TextHeight(tStr)) div 2) + 2, Color {clYellow}, clBlack, tStr);
      end else begin
        BoldTextOut(dsurface, SurfaceX(Left + (d.Width - dsurface.Canvas.TextWidth(tStr)) div 2), SurfaceY(Top + (d.Height - dsurface.Canvas.TextHeight(tStr)) div 2), Color {clYellow}, clBlack, tStr);
      end;
      dsurface.Canvas.Font.Style := [];
      dsurface.Canvas.Font.Size := 9;
      dsurface.Canvas.Release;
    end;
  except
    on E: Exception do begin
      ShowMessage(E.Message);
    end;
  end;
end;
procedure TFrmDlg.DMsgDlgDirectPaint(Sender: TObject;
  dsurface: TDirectDrawSurface);
var
  i: Integer;
  d: TDirectDrawSurface;
  ly: Integer;
  str, data: string;
  nX, nY: Integer;
begin
  with Sender as TDWindow do begin
    d := WLib.Images[FaceIndex];
    if d <> nil then
      dsurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, True);

    if m_boPlayDice then begin
      for i := 0 to m_nDiceCount - 1 do begin
        d := g_WBagItemImages.GetCachedImage(m_Dice[i].nPlayPoint + 376 - 1, nX, nY);
        if d <> nil then begin
          dsurface.Draw(SurfaceX(Left) + m_Dice[i].nX + nX - 14, SurfaceY(Top) + m_Dice[i].nY + nY + 38, d.ClientRect, d, True);
        end;
      end;
    end;

    SetBkMode(dsurface.Canvas.Handle, TRANSPARENT);
    ly := msgly;
    str := MsgText;
    while True do begin
      if str = '' then break;
      str := GetValidStr3(str, data, ['\']);
      if data <> '' then
        BoldTextOut(dsurface, SurfaceX(Left + msglx), SurfaceY(Top + ly), clWhite, clBlack, data);
      ly := ly + 14;
    end;
    dsurface.Canvas.Release;
  end;
  if ViewDlgEdit then begin
    if not EdDlgEdit.Visible then begin
      EdDlgEdit.Visible := True;
      EdDlgEdit.SetFocus;
    end;
  end;
end;




{------------------------------------------------------------------------}

//肺弊牢 芒


procedure TFrmDlg.DLoginNewDirectPaint(Sender: TObject;
  dsurface: TDirectDrawSurface);
var
  d: TDirectDrawSurface;
begin
  with Sender as TDButton do begin
    if TDButton(Sender).Downed then begin
      d := WLib.Images[FaceIndex];
      if d <> nil then
        dsurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, True);
    end;
  end;
end;

procedure TFrmDlg.DLoginNewClick(Sender: TObject; X, Y: Integer);
begin
  LoginScene.NewClick;
end;

procedure TFrmDlg.DLoginOkClick(Sender: TObject; X, Y: Integer);
begin
  LoginScene.OkClick;
end;

procedure TFrmDlg.DLoginCloseClick(Sender: TObject; X, Y: Integer);
begin
  frmMain.Close;
end;

procedure TFrmDlg.DLoginChgPwClick(Sender: TObject; X, Y: Integer);
begin
  LoginScene.ChgPwClick;
end;

procedure TFrmDlg.DLoginNewClickSound(Sender: TObject;
  Clicksound: TClickSound);
begin
  case Clicksound of
    csNorm: PlaySound(s_norm_button_click);
    csStone: PlaySound(s_rock_button_click);
    csGlass: PlaySound(s_glass_button_click);
  end;
end;



{------------------------------------------------------------------------}
//辑滚 急琶 芒
{
procedure TFrmDlg.ShowSelectServerDlg;
var
  tGame:pGameInfo;
  tServer:pServerInfo;
begin
  tGame:=GameList.Items[SelServerIndex];
   case tGame.ServerList.Count of
     1:begin
         DSServer1.Visible:=True;
         DSServer1.Top:=204;
         DSServer2.Visible:=False;
         DSServer3.Visible:=False;
         DSServer4.Visible:=False;
         DSServer5.Visible:=False;
         DSServer6.Visible:=False;
       end;
     2:begin
         DSServer1.Visible:=True;
         DSServer1.Top:=200;
         DSServer2.Visible:=True;
         DSServer2.Top:=250;
         DSServer3.Visible:=False;
         DSServer4.Visible:=False;
         DSServer5.Visible:=False;
         DSServer6.Visible:=False;
       end;
     3:begin
         DSServer1.Visible:=True;
         DSServer2.Visible:=True;
         DSServer3.Visible:=True;
         DSServer4.Visible:=False;
         DSServer5.Visible:=False;
         DSServer6.Visible:=False;
       end;
     4:begin
         DSServer1.Visible:=True;
         DSServer2.Visible:=True;
         DSServer3.Visible:=True;
         DSServer4.Visible:=True;
         DSServer5.Visible:=False;
         DSServer6.Visible:=False;
       end;
     5:begin
         DSServer1.Visible:=True;
         DSServer2.Visible:=True;
         DSServer3.Visible:=True;
         DSServer4.Visible:=True;
         DSServer5.Visible:=True;
         DSServer6.Visible:=False;
       end;
     6:begin
         DSServer1.Visible:=True;
         DSServer2.Visible:=True;
         DSServer3.Visible:=True;
         DSServer4.Visible:=True;
         DSServer5.Visible:=True;
         DSServer6.Visible:=True;
       end;
   end;
   DSelServerDlg.Visible := TRUE;
end;
}
procedure TFrmDlg.ShowSelectServerDlg;
begin
  case g_ServerList.count of
    1: begin
        DSServer1.Visible := True;
        DSServer1.Top := 204;
        DSServer2.Visible := FALSE;
        DSServer3.Visible := FALSE;
        DSServer4.Visible := FALSE;
        DSServer5.Visible := FALSE;
        DSServer6.Visible := FALSE;
      end;
    2: begin
        DSServer1.Visible := True;
        DSServer1.Top := 190;
        DSServer2.Visible := True;
        DSServer2.Top := 235;
        DSServer3.Visible := FALSE;
        DSServer4.Visible := FALSE;
        DSServer5.Visible := FALSE;
        DSServer6.Visible := FALSE;
      end;
    3: begin
        DSServer1.Visible := True;
        DSServer2.Visible := True;
        DSServer3.Visible := True;
        DSServer4.Visible := FALSE;
        DSServer5.Visible := FALSE;
        DSServer6.Visible := FALSE;
      end;
    4: begin
        DSServer1.Visible := True;
        DSServer2.Visible := True;
        DSServer3.Visible := True;
        DSServer4.Visible := True;
        DSServer5.Visible := FALSE;
        DSServer6.Visible := FALSE;
      end;
    5: begin
        DSServer1.Visible := True;
        DSServer2.Visible := True;
        DSServer3.Visible := True;
        DSServer4.Visible := True;
        DSServer5.Visible := True;
        DSServer6.Visible := FALSE;
      end;
    6: begin
        DSServer1.Visible := True;
        DSServer2.Visible := True;
        DSServer3.Visible := True;
        DSServer4.Visible := True;
        DSServer5.Visible := True;
        DSServer6.Visible := True;
      end;
    else begin
        DSServer1.Visible := True;
        DSServer2.Visible := True;
        DSServer3.Visible := True;
        DSServer4.Visible := True;
        DSServer5.Visible := True;
        DSServer6.Visible := True;
      end;
  end;
  DSelServerDlg.Visible := True;
end;
procedure TFrmDlg.DSelServerDlgDirectPaint(Sender: TObject;
  dsurface: TDirectDrawSurface);
var
  d: TDirectDrawSurface;
begin

end;
{
procedure TFrmDlg.DSServer1Click(Sender: TObject; X, Y: Integer);
var
  svname: string;
  tGame:pGameInfo;
  tServer:pServerInfo;
begin
   svname := '';
   tGame:=GameList.Items[SelServerIndex];
   if Sender = DSServer1 then begin
     tServer:=tGame.ServerList.Items[0];
      svname :=tServer.ServerName;
      g_sServerMiniName :=tServer.ServerName;
   end;
   if Sender = DSServer2 then begin //辑滚 4锅..
     tServer:=tGame.ServerList.Items[1];
      svname :=tServer.ServerName;
      g_sServerMiniName :=tServer.ServerName;
   end;
   if Sender = DSServer3 then begin //辑滚 1锅..
     tServer:=tGame.ServerList.Items[2];
      svname :=tServer.ServerName;
      g_sServerMiniName :=tServer.ServerName;
   end;
   if Sender = DSServer4 then begin //辑滚 2锅..
     tServer:=tGame.ServerList.Items[3];
      svname :=tServer.ServerName;
      g_sServerMiniName :=tServer.ServerName;
   end;
   if Sender = DSServer5 then begin //辑滚 3锅..
     tServer:=tGame.ServerList.Items[4];
      svname :=tServer.ServerName;
      g_sServerMiniName :=tServer.ServerName;
   end;
   if Sender = DSServer6 then begin //辑滚 4锅..
     tServer:=tGame.ServerList.Items[5];
      svname :=tServer.ServerName;
      g_sServerMiniName :=tServer.ServerName;
   end;
   if svname <> '' then begin
      if BO_FOR_TEST then begin
         svname := '泅公辑滚';
         g_sServerMiniName := '泅公';
      end;
      FrmMain.SendSelectServer (svname);
      DSelServerDlg.Visible := FALSE;
      g_sServerName := svname;
   end;
end;
}

procedure TFrmDlg.DSServer1Click(Sender: TObject; X, Y: Integer);
var
  svname: string;
begin
  svname := '';
  if Sender = DSServer1 then begin
    svname := g_ServerList.Strings[0];
    g_sServerMiniName := svname;
  end;
  if Sender = DSServer2 then begin //辑滚 4锅..
    svname := g_ServerList.Strings[1];
    g_sServerMiniName := svname;
  end;
  if Sender = DSServer3 then begin //辑滚 1锅..
    svname := g_ServerList.Strings[2];
    g_sServerMiniName := svname;
  end;
  if Sender = DSServer4 then begin //辑滚 2锅..
    svname := g_ServerList.Strings[3];
    g_sServerMiniName := svname;
  end;
  if Sender = DSServer5 then begin //辑滚 3锅..
    svname := g_ServerList.Strings[4];
    g_sServerMiniName := svname;
  end;
  if Sender = DSServer6 then begin //辑滚 4锅..
    svname := g_ServerList.Strings[5];
    g_sServerMiniName := svname;
  end;
  if svname <> '' then begin
    if BO_FOR_TEST then begin
      svname := '泅公辑滚';
      g_sServerMiniName := '泅公';
    end;
    frmMain.SendSelectServer(svname);
    DSelServerDlg.Visible := FALSE;
    g_sServerName := svname;
  end;
end;

procedure TFrmDlg.DEngServer1Click(Sender: TObject; X, Y: Integer);
var
  svname: string;
begin
  svname := '飘飘网络';
  g_sServerMiniName := svname;

  if svname <> '' then begin
    frmMain.SendSelectServer(svname);
    DSelServerDlg.Visible := FALSE;
    g_sServerName := svname;
  end;
end;


procedure TFrmDlg.DSSrvCloseClick(Sender: TObject; X, Y: Integer);
begin
  DSelServerDlg.Visible := FALSE;
  frmMain.Close;
end;


{------------------------------------------------------------------------}
//货 拌沥 父甸扁 芒


procedure TFrmDlg.DNewAccountOkClick(Sender: TObject; X, Y: Integer);
begin
  LoginScene.NewAccountOk;
end;

procedure TFrmDlg.DNewAccountCloseClick(Sender: TObject; X, Y: Integer);
begin
  LoginScene.NewAccountClose;
end;

procedure TFrmDlg.DNewAccountDirectPaint(Sender: TObject;
  dsurface: TDirectDrawSurface);
var
  d: TDirectDrawSurface;
  i: Integer;
begin
  with dsurface.Canvas do begin
    with DNewAccount do begin
      d := DMenuDlg.WLib.Images[FaceIndex];
      if d <> nil then
        dsurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, True);
    end;

    SetBkMode(Handle, TRANSPARENT);
    Font.Color := clSilver;
    for i := 0 to NAHelps.count - 1 do begin
      //TextOut (79 + 386 + 10, 64 + 119 + 5 + i*14, NAHelps[i]);
      TextOut((SCREENWIDTH div 2 - 320) + 386 + 10, (SCREENHEIGHT div 2 - 238) + 119 + 5 + i * 14, NAHelps[i]);
    end;
    BoldTextOut(dsurface, 79 + 283, 64 + 57, clWhite, clBlack, NewAccountTitle);
    Release;
  end;
end;



{------------------------------------------------------------------------}
////Chg pw 冠胶


procedure TFrmDlg.DChgpwOkClick(Sender: TObject; X, Y: Integer);
begin
  if Sender = DChgpwOk then LoginScene.ChgpwOk;
  if Sender = DChgpwCancel then LoginScene.ChgpwCancel;
end;




{------------------------------------------------------------------------}
//某腐磐 急琶


procedure TFrmDlg.DscSelect1DirectPaint(Sender: TObject;
  dsurface: TDirectDrawSurface);
var
  d: TDirectDrawSurface;
begin
  with Sender as TDButton do begin
    if Downed then begin
      d := WLib.Images[FaceIndex];
      if d <> nil then
        dsurface.Draw(Left, Top, d.ClientRect, d, True);
    end;
  end;
end;

procedure TFrmDlg.DscSelect1Click(Sender: TObject; X, Y: Integer);
begin
  if Sender = DscSelect1 then SelectChrScene.SelChrSelect1Click;
  if Sender = DscSelect2 then SelectChrScene.SelChrSelect2Click;
  if Sender = DscStart then SelectChrScene.SelChrStartClick;
  if Sender = DscNewChr then SelectChrScene.SelChrNewChrClick;
  if Sender = DscEraseChr then SelectChrScene.SelChrEraseChrClick;
  if Sender = DscCredits then SelectChrScene.SelChrCreditsClick;
  if Sender = DscExit then SelectChrScene.SelChrExitClick;
end;


//货 某腐磐 父甸扁 芒


procedure TFrmDlg.DccCloseDirectPaint(Sender: TObject;
  dsurface: TDirectDrawSurface);
var
  d: TDirectDrawSurface;
begin
  with Sender as TDButton do begin
    if Downed then begin
      d := WLib.Images[FaceIndex];
      if d <> nil then
        dsurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, True);
    end else begin
      d := nil;
      if Sender = DccWarrior then begin
        with SelectChrScene do
          if ChrArr[NewIndex].UserChr.job = 0 then d := WLib.Images[55];
      end;
      if Sender = DccWizzard then begin
        with SelectChrScene do
          if ChrArr[NewIndex].UserChr.job = 1 then d := WLib.Images[56];
      end;
      if Sender = DccMonk then begin
        with SelectChrScene do
          if ChrArr[NewIndex].UserChr.job = 2 then d := WLib.Images[57];
      end;
      if Sender = DccMale then begin
        with SelectChrScene do
          if ChrArr[NewIndex].UserChr.sex = 0 then d := WLib.Images[58];
      end;
      if Sender = DccFemale then begin
        with SelectChrScene do
          if ChrArr[NewIndex].UserChr.sex = 1 then d := WLib.Images[59];
      end;
      if d <> nil then
        dsurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, True);
    end;
  end;
end;

procedure TFrmDlg.DccCloseClick(Sender: TObject; X, Y: Integer);
begin
  if Sender = DccClose then SelectChrScene.SelChrNewClose;
  if Sender = DccWarrior then SelectChrScene.SelChrNewJob(0);
  if Sender = DccWizzard then SelectChrScene.SelChrNewJob(1);
  if Sender = DccMonk then SelectChrScene.SelChrNewJob(2);
  if Sender = DccReserved then SelectChrScene.SelChrNewJob(3);
  if Sender = DccMale then SelectChrScene.SelChrNewm_btSex(0);
  if Sender = DccFemale then SelectChrScene.SelChrNewm_btSex(1);
  if Sender = DccLeftHair then SelectChrScene.SelChrNewPrevHair;
  if Sender = DccRightHair then SelectChrScene.SelChrNewNextHair;
  if Sender = DccOk then SelectChrScene.SelChrNewOk;
end;


procedure TFrmDlg.DStateWinDirectPaint(Sender: TObject;
  dsurface: TDirectDrawSurface);
var
  i, L, m, pgidx, magline, bbx, bby, mmx, idx, ax, ay, trainlv: Integer;
  pm: PTClientMagic;
  d: TDirectDrawSurface;
  hcolor, old, keyimg: Integer;
  iname, d1, d2, d3: string;
  useable: Boolean;
begin
  if g_MySelf = nil then Exit;
  with DStateWin do begin
    d := WLib.Images[FaceIndex];
    if d <> nil then
      dsurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, True);

    case StatePage of
      0: begin //馒侩惑怕
          pgidx := 29;
          if g_MySelf <> nil then
            if g_MySelf.m_btSex = 1 then pgidx := 30;
          bbx := Left + 38;
          bby := Top + 52;
          d := g_WMain3Images.Images[pgidx];
          if d <> nil then
            dsurface.Draw(SurfaceX(bbx), SurfaceY(bby), d.ClientRect, d, FALSE);
          bbx := bbx - 7;
          bby := bby + 44;
          //渴, 公扁, 赣府 胶鸥老
          idx := 440 + g_MySelf.m_btHair div 2; //赣府 胶鸥老
          if g_MySelf.m_btSex = 1 then idx := 480 + g_MySelf.m_btHair div 2;
          if idx > 0 then begin
            d := g_WMainImages.GetCachedImage(idx, ax, ay);
            if d <> nil then
              dsurface.Draw(SurfaceX(bbx + ax), SurfaceY(bby + ay), d.ClientRect, d, True);
          end;
          if g_UseItems[U_DRESS].S.name <> '' then begin
            idx := g_UseItems[U_DRESS].S.looks; //渴 if Myself.m_btSex = 1 then idx := 80; //咯磊渴
            if idx >= 0 then begin
              //d := FrmMain.WStateItem.GetCachedImage (idx, ax, ay);
              d := frmMain.GetWStateImg(idx, ax, ay);
              if d <> nil then
                dsurface.Draw(SurfaceX(bbx + ax), SurfaceY(bby + ay), d.ClientRect, d, True);
            end;
          end;
          if g_UseItems[U_WEAPON].S.name <> '' then begin
            idx := g_UseItems[U_WEAPON].S.looks;
            if idx >= 0 then begin
              //d := FrmMain.WStateItem.GetCachedImage (idx, ax, ay);
              d := frmMain.GetWStateImg(idx, ax, ay);
              if d <> nil then
                dsurface.Draw(SurfaceX(bbx + ax), SurfaceY(bby + ay), d.ClientRect, d, True);
            end;
          end;
          if g_UseItems[U_HELMET].S.name <> '' then begin
            idx := g_UseItems[U_HELMET].S.looks;
            if idx >= 0 then begin
              //d := FrmMain.WStateItem.GetCachedImage (idx, ax, ay);
              d := frmMain.GetWStateImg(idx, ax, ay);
              if d <> nil then
                dsurface.Draw(SurfaceX(bbx + ax), SurfaceY(bby + ay), d.ClientRect, d, True);
            end;
          end;
        end;
      1: begin //瓷仿摹
          L := Left + 112; //66;
          m := Top + 99;
          with dsurface.Canvas do begin
            SetBkMode(Handle, TRANSPARENT);
            Font.Color := clWhite;
            TextOut(SurfaceX(L + 0), SurfaceY(m + 0), IntToStr(Loword(g_MySelf.m_Abil.AC)) + '-' + IntToStr(Hiword(g_MySelf.m_Abil.AC)));
            TextOut(SurfaceX(L + 0), SurfaceY(m + 20), IntToStr(Loword(g_MySelf.m_Abil.MAC)) + '-' + IntToStr(Hiword(g_MySelf.m_Abil.MAC)));
            TextOut(SurfaceX(L + 0), SurfaceY(m + 40), IntToStr(Loword(g_MySelf.m_Abil.DC)) + '-' + IntToStr(Hiword(g_MySelf.m_Abil.DC)));
            TextOut(SurfaceX(L + 0), SurfaceY(m + 60), IntToStr(Loword(g_MySelf.m_Abil.MC)) + '-' + IntToStr(Hiword(g_MySelf.m_Abil.MC)));
            TextOut(SurfaceX(L + 0), SurfaceY(m + 80), IntToStr(Loword(g_MySelf.m_Abil.SC)) + '-' + IntToStr(Hiword(g_MySelf.m_Abil.SC)));
            TextOut(SurfaceX(L + 0), SurfaceY(m + 100), IntToStr(g_MySelf.m_Abil.HP) + '/' + IntToStr(g_MySelf.m_Abil.MaxHP));
            TextOut(SurfaceX(L + 0), SurfaceY(m + 120), IntToStr(g_MySelf.m_Abil.MP) + '/' + IntToStr(g_MySelf.m_Abil.MaxMP));
            Release;
          end;
        end;
      2: begin //瓷仿摹 汲疙芒
          bbx := Left + 38;
          bby := Top + 52;
          d := g_WMain3Images.Images[32];
          if d <> nil then
            dsurface.Draw(SurfaceX(bbx), SurfaceY(bby), d.ClientRect, d, FALSE);

          bbx := bbx + 20;
          bby := bby + 10;
          with dsurface.Canvas do begin
            SetBkMode(Handle, TRANSPARENT);
            mmx := bbx + 85;
            Font.Color := clSilver;
            TextOut(bbx, bby, '当前经验');
            //TextOut(mmx, bby, FloatToStrFixFmt(100 * g_MySelf.m_Abil.Exp / g_MySelf.m_Abil.MaxExp, 3, 2) + '%');

            TextOut(mmx, bby, IntToStr(g_MySelf.m_Abil.Exp));
            bby:=bby + 14;
            TextOut(bbx, bby, '升级经验');
            TextOut(mmx, bby, IntToStr(g_MySelf.m_Abil.MaxExp));

            TextOut(bbx, bby + 14 * 1, '背包重量');
            if g_MySelf.m_Abil.Weight > g_MySelf.m_Abil.MaxWeight then
              Font.Color := clRed;
            TextOut(mmx, bby + 14 * 1, IntToStr(g_MySelf.m_Abil.Weight) + '/' + IntToStr(g_MySelf.m_Abil.MaxWeight));

            Font.Color := clSilver;
            TextOut(bbx, bby + 14 * 2, '负量');
            if g_MySelf.m_Abil.WearWeight > g_MySelf.m_Abil.MaxWearWeight then
              Font.Color := clRed;
            TextOut(mmx, bby + 14 * 2, IntToStr(g_MySelf.m_Abil.WearWeight) + '/' + IntToStr(g_MySelf.m_Abil.MaxWearWeight));

            Font.Color := clSilver;
            TextOut(bbx, bby + 14 * 3, '腕力');
            if g_MySelf.m_Abil.HandWeight > g_MySelf.m_Abil.MaxHandWeight then
              Font.Color := clRed;
            TextOut(mmx, bby + 14 * 3, IntToStr(g_MySelf.m_Abil.HandWeight) + '/' + IntToStr(g_MySelf.m_Abil.MaxHandWeight));

            Font.Color := clSilver;
            TextOut(bbx, bby + 14 * 4, '准确度');
            TextOut(mmx, bby + 14 * 4, IntToStr(g_nMyHitPoint));

            TextOut(bbx, bby + 14 * 5, '敏捷');
            TextOut(mmx, bby + 14 * 5, IntToStr(g_nMySpeedPoint));

            TextOut(bbx, bby + 14 * 6, '魔法躲避');
            TextOut(mmx, bby + 14 * 6, '+' + IntToStr(g_nMyAntiMagic * 10) + '%');

            TextOut(bbx, bby + 14 * 7, '毒物躲避');
            TextOut(mmx, bby + 14 * 7, '+' + IntToStr(g_nMyAntiPoison * 10) + '%');

            TextOut(bbx, bby + 14 * 8, '中毒恢复');
            TextOut(mmx, bby + 14 * 8, '+' + IntToStr(g_nMyPoisonRecover * 10) + '%');

            TextOut(bbx, bby + 14 * 9, '体力恢复');
            TextOut(mmx, bby + 14 * 9, '+' + IntToStr(g_nMyHealthRecover * 10) + '%');

            TextOut(bbx, bby + 14 * 10, '魔法恢复');
            TextOut(mmx, bby + 14 * 10, '+' + IntToStr(g_nMySpellRecover * 10) + '%');

            Release;
          end;
        end;
      3: begin //魔法 芒
          bbx := Left + 38;
          bby := Top + 52;
          d := g_WMain3Images.Images[33];
          if d <> nil then
            dsurface.Draw(SurfaceX(bbx), SurfaceY(bby), d.ClientRect, d, FALSE);

          //虐 钎矫, lv, exp
          magtop := MagicPage * 5;
          magline := _MIN(MagicPage * 5 + 5, g_MagicList.count);
          for i := magtop to magline - 1 do begin
            pm := PTClientMagic(g_MagicList[i]);
            m := i - magtop;
            keyimg := 0;
            case byte(pm.Key) of
              byte('1'): keyimg := 248;
              byte('2'): keyimg := 249;
              byte('3'): keyimg := 250;
              byte('4'): keyimg := 251;
              byte('5'): keyimg := 252;
              byte('6'): keyimg := 253;
              byte('7'): keyimg := 254;
              byte('8'): keyimg := 255;
            end;
            if keyimg > 0 then begin
              d := g_WMainImages.Images[keyimg];
              if d <> nil then
                dsurface.Draw(bbx + 145, bby + 8 + m * 37, d.ClientRect, d, True);
            end;
            d := g_WMainImages.Images[112]; //lv
            if d <> nil then
              dsurface.Draw(bbx + 48, bby + 8 + 15 + m * 37, d.ClientRect, d, True);
            d := g_WMainImages.Images[111]; //exp
            if d <> nil then
              dsurface.Draw(bbx + 48 + 26, bby + 8 + 15 + m * 37, d.ClientRect, d, True);
          end;

          with dsurface.Canvas do begin
            SetBkMode(Handle, TRANSPARENT);
            Font.Color := clSilver;
            for i := magtop to magline - 1 do begin
              pm := PTClientMagic(g_MagicList[i]);
              m := i - magtop;
              if not (pm.Level in [0..3]) then pm.Level := 0; //魔法最多3级
              TextOut(bbx + 48, bby + 8 + m * 37,
                pm.Def.sMagicName);
              if pm.Level in [0..3] then trainlv := pm.Level
              else trainlv := 0;
              TextOut(bbx + 48 + 16, bby + 8 + 15 + m * 37, IntToStr(pm.Level));
              if pm.Def.MaxTrain[trainlv] > 0 then begin
                if trainlv < 3 then
                  TextOut(bbx + 48 + 46, bby + 8 + 15 + m * 37, IntToStr(pm.CurTrain) + '/' + IntToStr(pm.Def.MaxTrain[trainlv]))
                else TextOut(bbx + 48 + 46, bby + 8 + 15 + m * 37, '-');
              end;
            end;
            Release;
          end;
        end;
    end;
     //原为打开，本代码为显示人物身上所带物品信息，显示位置为人物下方
     if g_MouseStateItem.S.Name <> '' then begin
        g_MouseItem := g_MouseStateItem;
        GetMouseItemInfo (iname, d1, d2, d3, useable);
        if iname <> '' then begin
           if g_MouseItem.Dura = 0 then hcolor := clRed
           else hcolor := clWhite;
           with dsurface.Canvas do begin
              SetBkMode (Handle, TRANSPARENT);
              old := Font.Size;
              Font.Size := 9;
              Font.Color := clYellow;
              TextOut (SurfaceX(Left+37), SurfaceY(Top+272+35), iname);     //2006-10-24 叶随风飘修改
              Font.Color := hcolor;
              TextOut (SurfaceX(Left+37+TextWidth(iname)), SurfaceY(Top+272+35), d1);
              TextOut (SurfaceX(Left+37), SurfaceY(Top+272+35+TextHeight('A')+2), d2);
              TextOut (SurfaceX(Left+37), SurfaceY(Top+272+35+(TextHeight('A')+2)*2), d3);
              Font.Size := old;
              Release;
           end;
        end;
        g_MouseItem.S.Name := '';
     end;
     //玩家名称、行会
    with dsurface.Canvas do begin
      SetBkMode(Handle, TRANSPARENT);
      Font.Color := g_MySelf.m_nNameColor;
      TextOut(SurfaceX(Left + 122 - TextWidth(frmMain.CharName) div 2),
        SurfaceY(Top + 23), g_MySelf.m_sUserName);
      if StatePage = 0 then begin
        Font.Color := clSilver;
        TextOut(SurfaceX(Left + 45), SurfaceY(Top + 55),
          g_sGuildName + ' ' + g_sGuildRankName);
      end;
      Release;
    end;
  end;
end;

procedure TFrmDlg.DSWLightDirectPaint(Sender: TObject;
  dsurface: TDirectDrawSurface);
var
  idx: Integer;
  d: TDirectDrawSurface;
  tidx: Integer;
begin
  if StatePage = 0 then begin
    if Sender = DSWNecklace then begin
      if g_UseItems[U_NECKLACE].S.name <> '' then begin
        idx := g_UseItems[U_NECKLACE].S.looks;
        if idx >= 0 then begin
          //d := FrmMain.WStateItem.Images[idx];
          d := frmMain.GetWStateImg(idx);
          if d <> nil then
            dsurface.Draw(DSWNecklace.SurfaceX(DSWNecklace.Left + (DSWNecklace.Width - d.Width) div 2),
              DSWNecklace.SurfaceY(DSWNecklace.Top + (DSWNecklace.Height - d.Height) div 2),
              d.ClientRect, d, True);
        end;
      end;
    end;
    if Sender = DSWLight then begin
      if g_UseItems[U_RIGHTHAND].S.name <> '' then begin
        idx := g_UseItems[U_RIGHTHAND].S.looks;
        if idx >= 0 then begin
          //d := FrmMain.WStateItem.Images[idx];
          d := frmMain.GetWStateImg(idx);
          if d <> nil then
            dsurface.Draw(DSWLight.SurfaceX(DSWLight.Left + (DSWLight.Width - d.Width) div 2),
              DSWLight.SurfaceY(DSWLight.Top + (DSWLight.Height - d.Height) div 2),
              d.ClientRect, d, True);
        end;
      end;
    end;
    if Sender = DSWArmRingR then begin
      if g_UseItems[U_ARMRINGR].S.name <> '' then begin
        idx := g_UseItems[U_ARMRINGR].S.looks;
        if idx >= 0 then begin
          //d := FrmMain.WStateItem.Images[idx];
          d := frmMain.GetWStateImg(idx);
          if d <> nil then
            dsurface.Draw(DSWArmRingR.SurfaceX(DSWArmRingR.Left + (DSWArmRingR.Width - d.Width) div 2),
              DSWArmRingR.SurfaceY(DSWArmRingR.Top + (DSWArmRingR.Height - d.Height) div 2),
              d.ClientRect, d, True);
        end;
      end;
    end;
    if Sender = DSWArmRingL then begin
      if g_UseItems[U_ARMRINGL].S.name <> '' then begin
        idx := g_UseItems[U_ARMRINGL].S.looks;
        if idx >= 0 then begin
          //d := FrmMain.WStateItem.Images[idx];
          d := frmMain.GetWStateImg(idx);
          if d <> nil then
            dsurface.Draw(DSWArmRingL.SurfaceX(DSWArmRingL.Left + (DSWArmRingL.Width - d.Width) div 2),
              DSWArmRingL.SurfaceY(DSWArmRingL.Top + (DSWArmRingL.Height - d.Height) div 2),
              d.ClientRect, d, True);
        end;
      end;
    end;
    if Sender = DSWRingR then begin
      if g_UseItems[U_RINGR].S.name <> '' then begin
        idx := g_UseItems[U_RINGR].S.looks;
        if idx >= 0 then begin
          //d := FrmMain.WStateItem.Images[idx];
          d := frmMain.GetWStateImg(idx);
          if d <> nil then
            dsurface.Draw(DSWRingR.SurfaceX(DSWRingR.Left + (DSWRingR.Width - d.Width) div 2),
              DSWRingR.SurfaceY(DSWRingR.Top + (DSWRingR.Height - d.Height) div 2),
              d.ClientRect, d, True);
        end;
      end;
    end;
    if Sender = DSWRingL then begin
      if g_UseItems[U_RINGL].S.name <> '' then begin
        idx := g_UseItems[U_RINGL].S.looks;
        if idx >= 0 then begin
          //d := FrmMain.WStateItem.Images[idx];
          d := frmMain.GetWStateImg(idx);
          if d <> nil then
            dsurface.Draw(DSWRingL.SurfaceX(DSWRingL.Left + (DSWRingL.Width - d.Width) div 2),
              DSWRingL.SurfaceY(DSWRingL.Top + (DSWRingL.Height - d.Height) div 2),
              d.ClientRect, d, True);
        end;
      end;
    end;

    if Sender = DSWBujuk then begin
      if g_UseItems[U_BUJUK].S.name <> '' then begin
        idx := g_UseItems[U_BUJUK].S.looks;
        if idx >= 0 then begin
          //d := FrmMain.WStateItem.Images[idx];
          d := frmMain.GetWStateImg(idx);
          if d <> nil then
            dsurface.Draw(DSWBujuk.SurfaceX(DSWBujuk.Left + (DSWBujuk.Width - d.Width) div 2),
              DSWBujuk.SurfaceY(DSWBujuk.Top + (DSWBujuk.Height - d.Height) div 2),
              d.ClientRect, d, True);
        end;
      end;
    end;

    if Sender = DSWBelt then begin
      if g_UseItems[U_BELT].S.name <> '' then begin
        idx := g_UseItems[U_BELT].S.looks;
        if idx >= 0 then begin
          //d := FrmMain.WStateItem.Images[idx];
          d := frmMain.GetWStateImg(idx);
          if d <> nil then
            dsurface.Draw(DSWBelt.SurfaceX(DSWBelt.Left + (DSWBelt.Width - d.Width) div 2),
              DSWBelt.SurfaceY(DSWBelt.Top + (DSWBelt.Height - d.Height) div 2),
              d.ClientRect, d, True);
        end;
      end;
    end;

    if Sender = DSWBoots then begin
      if g_UseItems[U_BOOTS].S.name <> '' then begin
        idx := g_UseItems[U_BOOTS].S.looks;
        if idx >= 0 then begin
          //d := FrmMain.WStateItem.Images[idx];
          d := frmMain.GetWStateImg(idx);
          if d <> nil then
            dsurface.Draw(DSWBoots.SurfaceX(DSWBoots.Left + (DSWBoots.Width - d.Width) div 2),
              DSWBoots.SurfaceY(DSWBoots.Top + (DSWBoots.Height - d.Height) div 2),
              d.ClientRect, d, True);
        end;
      end;
    end;

    if Sender = DSWCharm then begin
      if g_UseItems[U_CHARM].S.name <> '' then begin
        idx := g_UseItems[U_CHARM].S.looks;
        if idx >= 0 then begin
          //d := FrmMain.WStateItem.Images[idx];
          d := frmMain.GetWStateImg(idx);
          if d <> nil then
            dsurface.Draw(DSWCharm.SurfaceX(DSWCharm.Left + (DSWCharm.Width - d.Width) div 2),
              DSWCharm.SurfaceY(DSWCharm.Top + (DSWCharm.Height - d.Height) div 2),
              d.ClientRect, d, True);
        end;
      end;
    end;
  end;
end;

procedure TFrmDlg.DStateWinClick(Sender: TObject; X, Y: Integer);
begin
  if StatePage = 3 then begin
    X := DStateWin.LocalX(X) - DStateWin.Left;
    Y := DStateWin.LocalY(Y) - DStateWin.Top;
    if (X >= 33) and (X <= 33 + 166) and (Y >= 55) and (Y <= 55 + 37 * 5) then begin
      magcur := (Y - 55) div 37;
      if (magcur + magtop) >= g_MagicList.count then
        magcur := (g_MagicList.count - 1) - magtop;
    end;
  end;
end;

procedure TFrmDlg.DCloseStateClick(Sender: TObject; X, Y: Integer);
begin
  DStateWin.Visible := FALSE;
end;

procedure TFrmDlg.DPrevStateDirectPaint(Sender: TObject;
  dsurface: TDirectDrawSurface);
var
  d: TDirectDrawSurface;
begin
  with Sender as TDButton do begin
    if TDButton(Sender).Downed then begin
      d := WLib.Images[FaceIndex];
      if d <> nil then
        dsurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, True);
    end;
  end;
end;

procedure TFrmDlg.PageChanged;
begin
  DScreen.ClearHint;
  case StatePage of
    3: begin //魔法 惑怕芒
        DStMag1.Visible := True; DStMag2.Visible := True;
        DStMag3.Visible := True; DStMag4.Visible := True;
        DStMag5.Visible := True;
        DStPageUp.Visible := True;
        DStPageDown.Visible := True;
        MagicPage := 0;
      end;
    else begin
        DStMag1.Visible := FALSE; DStMag2.Visible := FALSE;
        DStMag3.Visible := FALSE; DStMag4.Visible := FALSE;
        DStMag5.Visible := FALSE;
        DStPageUp.Visible := FALSE;
        DStPageDown.Visible := FALSE;
      end;
  end;
end;

procedure TFrmDlg.DPrevStateClick(Sender: TObject; X, Y: Integer);
begin
  Dec(StatePage);
  if StatePage < 0 then
    StatePage := MAXSTATEPAGE - 1;
  PageChanged;
end;

procedure TFrmDlg.DNextStateClick(Sender: TObject; X, Y: Integer);
begin
  Inc(StatePage);
  if StatePage > MAXSTATEPAGE - 1 then
    StatePage := 0;
  PageChanged;
end;

procedure TFrmDlg.DSWWeaponClick(Sender: TObject; X, Y: Integer);
var
  where, n, sel: Integer;
  flag, movcancel: Boolean;
begin
  if g_MySelf = nil then Exit;
  if StatePage <> 0 then Exit;
  if g_boItemMoving then begin
    flag := FALSE;
    movcancel := FALSE;
    if (g_MovingItem.Index = -97) or (g_MovingItem.Index = -98) then Exit;
    if (g_MovingItem.Item.S.name = '') or (g_WaitingUseItem.Item.S.name <> '') then Exit;
    where := GetTakeOnPosition(g_MovingItem.Item.S.StdMode);
    if g_MovingItem.Index >= 0 then begin
      case where of
        U_DRESS: begin
            if Sender = DSWDress then begin
              if g_MySelf.m_btSex = 0 then //巢磊
                if g_MovingItem.Item.S.StdMode <> 10 then //巢磊渴
                  Exit;
              if g_MySelf.m_btSex = 1 then //咯磊
                if g_MovingItem.Item.S.StdMode <> 11 then //咯磊渴
                  Exit;
              flag := True;
            end;
          end;
        U_WEAPON: begin
            if Sender = DSWWeapon then begin
              flag := True;
            end;
          end;
        U_NECKLACE: begin
            if Sender = DSWNecklace then
              flag := True;
          end;
        U_RIGHTHAND: begin
            if Sender = DSWLight then
              flag := True;
          end;
        U_HELMET: begin
            if Sender = DSWHelmet then
              flag := True;
          end;
        U_RINGR, U_RINGL: begin
            if Sender = DSWRingL then begin
              where := U_RINGL;
              flag := True;
            end;
            if Sender = DSWRingR then begin
              where := U_RINGR;
              flag := True;
            end;
          end;
        U_ARMRINGR: begin //迫骂
            if Sender = DSWArmRingL then begin
              where := U_ARMRINGL;
              flag := True;
            end;
            if Sender = DSWArmRingR then begin
              where := U_ARMRINGR;
              flag := True;
            end;
          end;
        U_ARMRINGL: begin //25,  刀啊风,迫骂
            if Sender = DSWArmRingL then begin
              where := U_ARMRINGL;
              flag := True;
            end;
          end;
        U_BUJUK: begin
            if Sender = DSWBujuk then begin
              where := U_BUJUK;
              flag := True;
            end;
            if Sender = DSWArmRingL then begin
              where := U_ARMRINGL;
              flag := True;
            end;
          end;
        U_BELT: begin
            if Sender = DSWBelt then begin
              where := U_BELT;
              flag := True;
            end;
          end;
        U_BOOTS: begin
            if Sender = DSWBoots then begin
              where := U_BOOTS;
              flag := True;
            end;
          end;
        U_CHARM: begin
            if Sender = DSWCharm then begin
              where := U_CHARM;
              flag := True;
            end;
          end;
      end;
    end else begin
      n := -(g_MovingItem.Index + 1);
      if n in [0..12] then begin
        ItemClickSound(g_MovingItem.Item.S);
        g_UseItems[n] := g_MovingItem.Item;
        g_MovingItem.Item.S.name := '';
        g_boItemMoving := FALSE;
      end;
    end;
    if flag then begin
      ItemClickSound(g_MovingItem.Item.S);
      g_WaitingUseItem := g_MovingItem;
      g_WaitingUseItem.Index := where;

      frmMain.SendTakeOnItem(where, g_MovingItem.Item.MakeIndex, g_MovingItem.Item.S.name);
      g_MovingItem.Item.S.name := '';
      g_boItemMoving := FALSE;
    end;
  end else begin
    flag := FALSE;
    if (g_MovingItem.Item.S.name <> '') or (g_WaitingUseItem.Item.S.name <> '') then Exit;
    sel := -1;
    if Sender = DSWDress then sel := U_DRESS;
    if Sender = DSWWeapon then sel := U_WEAPON;
    if Sender = DSWHelmet then sel := U_HELMET;
    if Sender = DSWNecklace then sel := U_NECKLACE;
    if Sender = DSWLight then sel := U_RIGHTHAND;
    if Sender = DSWRingL then sel := U_RINGL;
    if Sender = DSWRingR then sel := U_RINGR;
    if Sender = DSWArmRingL then sel := U_ARMRINGL;
    if Sender = DSWArmRingR then sel := U_ARMRINGR;

    if Sender = DSWBujuk then sel := U_BUJUK;
    if Sender = DSWBelt then sel := U_BELT; //
    if Sender = DSWBoots then sel := U_BOOTS;
    if Sender = DSWCharm then sel := U_CHARM;

    if sel >= 0 then begin
      if g_UseItems[sel].S.name <> '' then begin
        ItemClickSound(g_UseItems[sel].S);
        g_MovingItem.Index := -(sel + 1);
        g_MovingItem.Item := g_UseItems[sel];
        g_UseItems[sel].S.name := '';
        g_boItemMoving := True;
      end;
    end;
  end;
end;

procedure TFrmDlg.DSWWeaponMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  nLocalX, nLocalY: Integer;
  nHintX, nHintY: Integer;
  sel: Integer;
  iname, d1, d2, d3: string;
  useable: Boolean;
  hcolor: TColor;
  Butt: TDButton;
begin
  if StatePage <> 0 then Exit;
  DScreen.ClearHint;
  sel := -1;
  Butt := TDButton(Sender);
  if Sender = DSWDress then sel := U_DRESS;
  if Sender = DSWWeapon then sel := U_WEAPON;
  if Sender = DSWHelmet then sel := U_HELMET;
  if Sender = DSWNecklace then sel := U_NECKLACE;
  if Sender = DSWLight then sel := U_RIGHTHAND;
  if Sender = DSWRingL then sel := U_RINGL;
  if Sender = DSWRingR then sel := U_RINGR;
  if Sender = DSWArmRingL then sel := U_ARMRINGL;
  if Sender = DSWArmRingR then sel := U_ARMRINGR;
  {
  if Sender = DSWBujuk then sel := U_RINGL;
  if Sender = DSWBelt then sel := U_RINGR;
  if Sender = DSWBoots then sel := U_ARMRINGL;
  if Sender = DSWCharm then sel := U_ARMRINGR;
  }

  if Sender = DSWBujuk then sel := U_BUJUK;
  if Sender = DSWBelt then sel := U_BELT;
  if Sender = DSWBoots then sel := U_BOOTS;
  if Sender = DSWCharm then sel := U_CHARM;

  if sel >= 0 then begin
    g_MouseStateItem := g_UseItems[sel];
  end;
    //原为注释掉 显示人物身上带的物品信息
    {g_MouseItem := g_UseItems[sel];
    GetMouseItemInfo(iname, d1, d2, d3, useable);
    if iname <> '' then begin
      if g_UseItems[sel].Dura = 0 then hcolor := clRed
      else hcolor := clWhite;

      nLocalX := Butt.LocalX(X - Butt.Left);
      nLocalY := Butt.LocalY(Y - Butt.Top);
      nHintX := Butt.SurfaceX(Butt.Left) + DStateWin.SurfaceX(DStateWin.Left) + nLocalX;
      nHintY := Butt.SurfaceY(Butt.Top) + DStateWin.SurfaceY(DStateWin.Top) + nLocalY;

      {with Sender as TDButton do
         DScreen.ShowHint (SurfaceX(Left - 30),
                           SurfaceY(Top + 50),
                           iname + d1 + '\' + d2 + '\' + d3, hcolor, FALSE); }

      {with Butt as TDButton do
        DScreen.ShowHint(nHintX, nHintY,
          iname + d1 + '\' + d2 + '\' + d3, hcolor, FALSE);
    end;
    g_MouseItem.S.name := '';
    //

  end;}
end;

procedure TFrmDlg.DStateWinMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  //DScreen.ClearHint;
  g_MouseStateItem.S.name := '';
end;


//惑怕芒 : 魔法 其捞瘤

procedure TFrmDlg.DStMag1DirectPaint(Sender: TObject;
  dsurface: TDirectDrawSurface);
var
  idx, icon: Integer;
  d: TDirectDrawSurface;
  pm: PTClientMagic;
begin
  with Sender as TDButton do begin
    idx := _MAX(tag + MagicPage * 5, 0);
    if idx < g_MagicList.count then begin
      pm := PTClientMagic(g_MagicList[idx]);
      icon := pm.Def.btEffect * 2;
      if icon >= 0 then begin //酒捞能捞 绝绰芭..
        if not Downed then begin
          d := g_WMagIconImages.Images[icon];
          if d <> nil then
            dsurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, True);
        end else begin
          d := g_WMagIconImages.Images[icon + 1];
          if d <> nil then
            dsurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, True);
        end;
      end;
    end;
  end;
end;

procedure TFrmDlg.DStMag1Click(Sender: TObject; X, Y: Integer);
var
  i, idx: Integer;
  selkey: Word;
  keych: Char;
  pm: PTClientMagic;
begin
  if StatePage = 3 then begin
    idx := TDButton(Sender).tag + magtop;
    if (idx >= 0) and (idx < g_MagicList.count) then begin
      pm := PTClientMagic(g_MagicList[idx]);
      selkey := Word(pm.Key);
      SetMagicKeyDlg(pm.Def.btEffect * 2, pm.Def.sMagicName, selkey);
      keych := Char(selkey);
      for i := 0 to g_MagicList.count - 1 do begin
        pm := PTClientMagic(g_MagicList[i]);
        if pm.Key = keych then begin
          pm.Key := #0;
          frmMain.SendMagicKeyChange(pm.Def.wMagicId, #0);
        end;
      end;
      pm := PTClientMagic(g_MagicList[idx]);
      //if pm.Def.EffectType <> 0 then begin //八过篮 虐汲沥阑 给窃.
      pm.Key := keych;
      frmMain.SendMagicKeyChange(pm.Def.wMagicId, keych);
      //end;
    end;
  end;
end;

procedure TFrmDlg.DStPageUpClick(Sender: TObject; X, Y: Integer);
begin
  if Sender = DStPageUp then begin
    if MagicPage > 0 then
      Dec(MagicPage);
  end else begin
    if MagicPage < (g_MagicList.count + 4) div 5 - 1 then
      Inc(MagicPage);
  end;
end;





{------------------------------------------------------------------------}

//官蹿 惑怕

{------------------------------------------------------------------------}


procedure TFrmDlg.DBottomDirectPaint(Sender: TObject;
  dsurface: TDirectDrawSurface);
var
  d: TDirectDrawSurface;
  rc: TRect;
  btop, sx, sy, i, fcolor, bcolor: Integer;
  r: Real;
  str: string;
begin
{$IF SWH = SWH800}
  d := g_WMain3Images.Images[BOTTOMBOARD800];
{$ELSEIF SWH = SWH1024}
  d := g_WMainImages.Images[BOTTOMBOARD1024];
{$IFEND}
  if d <> nil then
    dsurface.Draw(DBottom.Left, DBottom.Top, d.ClientRect, d, True);
  btop := 0;
  if d <> nil then begin
    with d.ClientRect do
      rc := Rect(Left, Top, Right, Top + 120);
    btop := SCREENHEIGHT - d.Height;
    dsurface.Draw(0,
      btop,
      rc,
      d, True);
    with d.ClientRect do
      rc := Rect(Left, Top + 120, Right, Bottom);
    dsurface.Draw(0,
      btop + 120,
      rc,
      d, FALSE);
  end;

  d := nil;
  case g_nDayBright of
    0: d := g_WMainImages.Images[15]; //早上
    1: d := g_WMainImages.Images[12]; //白天
    2: d := g_WMainImages.Images[13]; //傍晚
    3: d := g_WMainImages.Images[14]; //晚上
  end;
  if d <> nil then
    dsurface.Draw(SCREENWIDTH div 2 + (SCREENWIDTH div 2 - (400 - 348)) {748}, 79 + DBottom.Top, d.ClientRect, d, FALSE);

  if g_MySelf <> nil then begin
    //显示HP及MP 图形
    if (g_MySelf.m_Abil.MaxHP > 0) and (g_MySelf.m_Abil.MaxMP > 0) then begin
      if (g_MySelf.m_btJob = 0) and (g_MySelf.m_Abil.Level < 28) then begin //武士
        d := g_WMainImages.Images[5];
        if d <> nil then begin
          rc := d.ClientRect;
          rc.Right := d.ClientRect.Right - 2;
          dsurface.Draw(38, btop + 90, rc, d, FALSE);
        end;
        d := g_WMainImages.Images[6];
        if d <> nil then begin
          rc := d.ClientRect;
          rc.Right := d.ClientRect.Right - 2;
          rc.Top := Round(rc.Bottom / g_MySelf.m_Abil.MaxHP * (g_MySelf.m_Abil.MaxHP - g_MySelf.m_Abil.HP));
          dsurface.Draw(38, btop + 90 + rc.Top, rc, d, FALSE);
        end;
      end else begin
        d := g_WMainImages.Images[4];
        if d <> nil then begin
          //HP 图形
          rc := d.ClientRect;
          rc.Right := d.ClientRect.Right div 2 - 1;
          rc.Top := Round(rc.Bottom / g_MySelf.m_Abil.MaxHP * (g_MySelf.m_Abil.MaxHP - g_MySelf.m_Abil.HP));
          dsurface.Draw(40, btop + 91 + rc.Top, rc, d, FALSE);
          //MP 图形
          rc := d.ClientRect;
          rc.Left := d.ClientRect.Right div 2 + 1;
          rc.Right := d.ClientRect.Right - 1;
          rc.Top := Round(rc.Bottom / g_MySelf.m_Abil.MaxMP * (g_MySelf.m_Abil.MaxMP - g_MySelf.m_Abil.MP));
          dsurface.Draw(40 + rc.Left, btop + 91 + rc.Top, rc, d, FALSE);
        end;
      end;
    end;

    //等级
    with dsurface.Canvas do begin
      PomiTextOut(dsurface, SCREENWIDTH div 2 + (SCREENWIDTH div 2 - (400 - 260)) {660}, SCREENHEIGHT - 104, IntToStr(g_MySelf.m_Abil.Level));
    end;
    //
    if (g_MySelf.m_Abil.MaxExp > 0) and (g_MySelf.m_Abil.MaxWeight > 0) then begin
      d := g_WMainImages.Images[7];
      if d <> nil then begin
        //经验条
        rc := d.ClientRect;
        if g_MySelf.m_Abil.Exp > 0 then r := g_MySelf.m_Abil.MaxExp / g_MySelf.m_Abil.Exp
        else r := 0;
        if r > 0 then rc.Right := Round(rc.Right / r)
        else rc.Right := 0;
        {
        dsurface.Draw (666, 527, rc, d, FALSE);
        PomiTextOut (dsurface, 660, 528, IntToStr(Myself.Abil.Exp));
        }
        dsurface.Draw(SCREENWIDTH div 2 + (SCREENWIDTH div 2 - (400 - 266)) {666}, SCREENHEIGHT - 73, rc, d, FALSE);
        //PomiTextOut (dsurface, SCREENWIDTH div 2 + (SCREENWIDTH div 2 - (400 - 260)){660}, SCREENHEIGHT - 72, FloatToStrFixFmt (100 * g_MySelf.m_Abil.Exp / g_MySelf.m_Abil.MaxExp, 3, 2) + '%');
        //PomiTextOut (dsurface, SCREENWIDTH div 2 + (SCREENWIDTH div 2 - (400 - 260)){660}, SCREENHEIGHT - 57, IntToStr(g_MySelf.m_Abil.MaxExp));

        //背包重量条
        rc := d.ClientRect;
        if g_MySelf.m_Abil.Weight > 0 then r := g_MySelf.m_Abil.MaxWeight / g_MySelf.m_Abil.Weight
        else r := 0;
        if r > 0 then rc.Right := Round(rc.Right / r)
        else rc.Right := 0;
        {
        dsurface.Draw (666, 560, rc, d, FALSE);
        PomiTextOut (dsurface, 660, 561, IntToStr(Myself.Abil.Weight));
        }
        dsurface.Draw(SCREENWIDTH div 2 + (SCREENWIDTH div 2 - (400 - 266)) {666}, SCREENHEIGHT - 40, rc, d, FALSE);
        //PomiTextOut (dsurface, SCREENWIDTH div 2 + (SCREENWIDTH div 2 - (400 - 260)){660}, SCREENHEIGHT - 39, IntToStr(g_MySelf.m_Abil.Weight) + '/' + IntToStr(g_MySelf.m_Abil.MaxWeight));
        //PomiTextOut (dsurface, SCREENWIDTH div 2 + (SCREENWIDTH div 2 - (400 - 260)){660}, SCREENHEIGHT - 24, IntToStr(g_MySelf.m_Abil.MaxWeight));
      end;
    end;
    //PomiTextOut (dsurface, SCREENWIDTH div 2 + (SCREENWIDTH div 2 - (400 - 355)){755}, SCREENHEIGHT - 15, IntToStr(g_nMyHungryState));
    //饥饿程度
    if g_nMyHungryState in [1..4] then begin
      d := g_WMainImages.Images[16 + g_nMyHungryState - 1];
      if d <> nil then begin
        dsurface.Draw(SCREENWIDTH div 2 + (SCREENWIDTH div 2 - (400 - 354)) {754}, 553, d.ClientRect, d, True);
      end;
    end;
  end;

  //显示聊天框文字
  sx := 208;
  sy := SCREENHEIGHT - 130;
  with DScreen do begin
    SetBkMode(dsurface.Canvas.Handle, OPAQUE);
    for i := ChatBoardTop to ChatBoardTop + VIEWCHATLINE - 1 do begin
      if i > ChatStrs.count - 1 then break;
      fcolor := Integer(ChatStrs.Objects[i]);
      bcolor := Integer(ChatBks[i]);
      dsurface.Canvas.Font.Color := fcolor;
      dsurface.Canvas.Brush.Color := bcolor;
      dsurface.Canvas.TextOut(sx, sy + (i - ChatBoardTop) * 12, ChatStrs.Strings[i]);
    end;
  end;
  dsurface.Canvas.Release;
end;




{--------------------------------------------------------------}
//官蹿 惑怕官狼 4俺 滚瓢


procedure TFrmDlg.DBottomInRealArea(Sender: TObject; X, Y: Integer;
  var IsRealArea: Boolean);
var
  d: TDirectDrawSurface;
begin
{$IF SWH = SWH800}
  d := g_WMain3Images.Images[BOTTOMBOARD800];
{$ELSEIF SWH = SWH1024}
  d := g_WMainImages.Images[BOTTOMBOARD1024];
{$IFEND}
  if d <> nil then begin
    if d.Pixels[X, Y] > 0 then IsRealArea := True
    else IsRealArea := FALSE;
  end;
end;

procedure TFrmDlg.DMyStateDirectPaint(Sender: TObject;
  dsurface: TDirectDrawSurface);
var
  d: TDButton;
  dd: TDirectDrawSurface;
begin
  if Sender is TDButton then begin
    d := TDButton(Sender);
    if d.Downed then begin
      dd := d.WLib.Images[d.FaceIndex];
      if dd <> nil then
        dsurface.Draw(d.SurfaceX(d.Left), d.SurfaceY(d.Top), dd.ClientRect, dd, True);
    end;
  end;
end;

//弊缝, 背券, 甘 滚瓢
procedure TFrmDlg.DBotGroupDirectPaint(Sender: TObject;
  dsurface: TDirectDrawSurface);
var
  d: TDButton;
  dd: TDirectDrawSurface;
begin
  if Sender is TDButton then begin
    d := TDButton(Sender);
    if not d.Downed then begin
      dd := d.WLib.Images[d.FaceIndex];
      if dd <> nil then
        dsurface.Draw(d.SurfaceX(d.Left), d.SurfaceY(d.Top), dd.ClientRect, dd, True);
    end else begin
      dd := d.WLib.Images[d.FaceIndex + 1];
      if dd <> nil then
        dsurface.Draw(d.SurfaceX(d.Left), d.SurfaceY(d.Top), dd.ClientRect, dd, True);
    end;
  end;
end;

procedure TFrmDlg.DBotPlusAbilDirectPaint(Sender: TObject;
  dsurface: TDirectDrawSurface);
var
  d: TDButton;
  dd: TDirectDrawSurface;
begin
  if Sender is TDButton then begin
    d := TDButton(Sender);
    if not d.Downed then begin
      if (BlinkCount mod 2 = 0) and (not DAdjustAbility.Visible) then dd := d.WLib.Images[d.FaceIndex]
      else dd := d.WLib.Images[d.FaceIndex + 2];
      if dd <> nil then
        dsurface.Draw(d.SurfaceX(d.Left), d.SurfaceY(d.Top), dd.ClientRect, dd, True);
    end else begin
      dd := d.WLib.Images[d.FaceIndex + 1];
      if dd <> nil then
        dsurface.Draw(d.SurfaceX(d.Left), d.SurfaceY(d.Top), dd.ClientRect, dd, True);
    end;

    if GetTickCount - BlinkTime >= 500 then begin
      BlinkTime := GetTickCount;
      Inc(BlinkCount);
      if BlinkCount >= 10 then BlinkCount := 0;
    end;
  end;
end;



procedure TFrmDlg.DMyStateClick(Sender: TObject; X, Y: Integer);
begin
  if Sender = DMyState then begin
    StatePage := 0;
    OpenMyStatus;
  end;
  if Sender = DMyBag then OpenItemBag;
  if Sender = DMyMagic then begin
    StatePage := 3;
    OpenMyStatus;
  end;
  if Sender = DOption then DOptionClick;
end;

procedure TFrmDlg.DOptionClick();
begin
  g_boSound := not g_boSound;
  if g_boSound then begin
    DScreen.AddChatBoardString('[打开声音]', clWhite, clBlack);
  end else begin
    DScreen.AddChatBoardString('[关闭声音]', clWhite, clBlack);
  end;
end;







{------------------------------------------------------------------------}

// 骇飘

{------------------------------------------------------------------------}


procedure TFrmDlg.DBelt1DirectPaint(Sender: TObject;
  dsurface: TDirectDrawSurface);
var
  idx: Integer;
  d: TDirectDrawSurface;
begin
  with Sender as TDButton do begin
    idx := tag;
    if idx in [0..5] then begin
      if g_ItemArr[idx].S.name <> '' then begin
        d := g_WBagItemImages.Images[g_ItemArr[idx].S.looks];
        if d <> nil then
          dsurface.Draw(SurfaceX(Left + (Width - d.Width) div 2), SurfaceY(Top + (Height - d.Height) div 2), d.ClientRect, d, True);
      end;
    end;
    PomiTextOut(dsurface, SurfaceX(Left + 13), SurfaceY(Top + 19), IntToStr(idx + 1));
  end;
end;

procedure TFrmDlg.DBelt1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  idx: Integer;
begin
  idx := TDButton(Sender).tag;
  if idx in [0..5] then begin
    if g_ItemArr[idx].S.name <> '' then begin
      g_MouseItem := g_ItemArr[idx];
    end;
  end;
end;

procedure TFrmDlg.DBelt1Click(Sender: TObject; X, Y: Integer);
var
  idx: Integer;
  temp: TClientItem;
begin
  idx := TDButton(Sender).tag;
  if idx in [0..5] then begin
    if not g_boItemMoving then begin
      if g_ItemArr[idx].S.name <> '' then begin
        ItemClickSound(g_ItemArr[idx].S);
        g_boItemMoving := True;
        g_MovingItem.Index := idx;
        g_MovingItem.Item := g_ItemArr[idx];
        g_ItemArr[idx].S.name := '';
      end;
    end else begin
      if (g_MovingItem.Index = -97) or (g_MovingItem.Index = -98) then Exit;
      if g_MovingItem.Item.S.StdMode <= 3 then begin //器记,澜侥,胶农费
        //ItemClickSound (MovingItem.Item.S.StdMode);
        if g_ItemArr[idx].S.name <> '' then begin
          temp := g_ItemArr[idx];
          g_ItemArr[idx] := g_MovingItem.Item;
          g_MovingItem.Index := idx;
          g_MovingItem.Item := temp
        end else begin
          g_ItemArr[idx] := g_MovingItem.Item;
          g_MovingItem.Item.S.name := '';
          g_boItemMoving := FALSE;
        end;
      end;
    end;
  end;
end;

procedure TFrmDlg.DBelt1DblClick(Sender: TObject);
var
  idx: Integer;
begin
  idx := TDButton(Sender).tag;
  if idx in [0..5] then begin
    if g_ItemArr[idx].S.name <> '' then begin
      if (g_ItemArr[idx].S.StdMode <= 4) or (g_ItemArr[idx].S.StdMode = 31) then begin //荤侩且 荐 乐绰 酒捞袍
        frmMain.EatItem(idx);
      end;
    end else begin
      if g_boItemMoving and (g_MovingItem.Index = idx) and
        (g_MovingItem.Item.S.StdMode <= 4) or (g_MovingItem.Item.S.StdMode = 31)
        then begin
        frmMain.EatItem(-1);
      end;
    end;
  end;
end;


//酒捞袍 啊规

{----------------------------------------------------------}



procedure TFrmDlg.GetMouseItemInfo(var iname, line1, line2, line3: string; var useable: Boolean);
  function GetDuraStr(Dura, maxdura: Integer): string;
  begin
    if not BoNoDisplayMaxDura then
      Result := IntToStr(Round(Dura / 1000)) + '/' + IntToStr(Round(maxdura / 1000))
    else
      Result := IntToStr(Round(Dura / 1000));
  end;
  function GetDura100Str(Dura, maxdura: Integer): string;
  begin
    if not BoNoDisplayMaxDura then
      Result := IntToStr(Round(Dura / 100)) + '/' + IntToStr(Round(maxdura / 100))
    else
      Result := IntToStr(Round(Dura / 100));
  end;
var
  sWgt: string;
begin
  if g_MySelf = nil then Exit;
  iname := ''; line1 := ''; line2 := ''; line3 := '';
  useable := True;

  if g_MouseItem.S.name <> '' then begin
    iname := g_MouseItem.S.name + ' ';
    sWgt := '重量';
    case g_MouseItem.S.StdMode of
      0: begin //药品
          if g_MouseItem.S.AC > 0 then
            line1 := '+' + IntToStr(g_MouseItem.S.AC) + 'HP ';
          if g_MouseItem.S.MAC > 0 then
            line1 := line1 + '+' + IntToStr(g_MouseItem.S.MAC) + 'MP';
          line1 := line1 + ' 重量.' + IntToStr(g_MouseItem.S.Weight);
        end;
      1..3: begin
          line1 := line1 + '重量.' + IntToStr(g_MouseItem.S.Weight);
        end;
      4: begin
          line1 := line1 + '重量. ' + IntToStr(g_MouseItem.S.Weight);
          line3 := '所需等级 ' + IntToStr(g_MouseItem.S.DuraMax);
          useable := FALSE;
          case g_MouseItem.S.Shape of
            0: begin
                line2 := '武士秘技';
                if (g_MySelf.m_btJob = 0) and (g_MySelf.m_Abil.Level >= g_MouseItem.S.DuraMax) then
                  useable := True;
              end;
            1: begin
                line2 := '法师秘技';
                if (g_MySelf.m_btJob = 1) and (g_MySelf.m_Abil.Level >= g_MouseItem.S.DuraMax) then
                  useable := True;
              end;
            2: begin
                line2 := '道士秘技';
                if (g_MySelf.m_btJob = 2) and (g_MySelf.m_Abil.Level >= g_MouseItem.S.DuraMax) then
                  useable := True;
              end;
          end;
        end;
      5..6: {//武器} begin
          useable := FALSE;
          if g_MouseItem.S.Reserved and $01 <> 0 then
            iname := '(*)' + iname;

          line1 := line1 + '重量' + IntToStr(g_MouseItem.S.Weight) +
            ' 持久' + GetDuraStr(g_MouseItem.Dura, g_MouseItem.DuraMax);
          if g_MouseItem.S.DC > 0 then
            line2 := '攻击力' + IntToStr(Loword(g_MouseItem.S.DC)) + '-' + IntToStr(Hiword(g_MouseItem.S.DC)) + ' ';
          if g_MouseItem.S.MC > 0 then
            line2 := line2 + '魔法' + IntToStr(Loword(g_MouseItem.S.MC)) + '-' + IntToStr(Hiword(g_MouseItem.S.MC)) + ' ';
          if g_MouseItem.S.SC > 0 then
            line2 := line2 + '道术' + IntToStr(Loword(g_MouseItem.S.SC)) + '-' + IntToStr(Hiword(g_MouseItem.S.SC)) + ' ';

          if (g_MouseItem.S.Source <= -1) and (g_MouseItem.S.Source >= -50) then
            line2 := line2 + '神圣 +' + IntToStr(-g_MouseItem.S.Source) + ' ';
          if (g_MouseItem.S.Source <= -51) and (g_MouseItem.S.Source >= -100) then
            line2 := line2 + '神圣 -' + IntToStr(-g_MouseItem.S.Source - 50) + ' ';

          if Hiword(g_MouseItem.S.AC) > 0 then
            line3 := line3 + '准确+' + IntToStr(Hiword(g_MouseItem.S.AC)) + ' ';
          if Hiword(g_MouseItem.S.MAC) > 0 then begin
            if Hiword(g_MouseItem.S.MAC) > 10 then
              line3 := line3 + '攻击速度 +' + IntToStr(Hiword(g_MouseItem.S.MAC) - 10) + ' '
            else
              line3 := line3 + '攻击速度 -' + IntToStr(Hiword(g_MouseItem.S.MAC)) + ' ';
          end;
          if Loword(g_MouseItem.S.AC) > 0 then
            line3 := line3 + '幸运+' + IntToStr(Loword(g_MouseItem.S.AC)) + ' ';
          if Loword(g_MouseItem.S.MAC) > 0 then
            line3 := line3 + '诅咒+' + IntToStr(Loword(g_MouseItem.S.MAC)) + ' ';
          case g_MouseItem.S.Need of
            0: begin
                if g_MySelf.m_Abil.Level >= g_MouseItem.S.NeedLevel then
                  useable := True;
                line3 := line3 + '所需等级 ' + IntToStr(g_MouseItem.S.NeedLevel);
              end;
            1: begin
                if Hiword(g_MySelf.m_Abil.DC) >= g_MouseItem.S.NeedLevel then
                  useable := True;
                line3 := line3 + '需要攻击力 ' + IntToStr(g_MouseItem.S.NeedLevel);
              end;
            2: begin
                if Hiword(g_MySelf.m_Abil.MC) >= g_MouseItem.S.NeedLevel then
                  useable := True;
                line3 := line3 + '所需魔法值 ' + IntToStr(g_MouseItem.S.NeedLevel);
              end;
            3: begin
                if Hiword(g_MySelf.m_Abil.SC) >= g_MouseItem.S.NeedLevel then
                  useable := True;
                line3 := line3 + '所需道术 ' + IntToStr(g_MouseItem.S.NeedLevel);
              end;
            4: begin
                useable := True;
                line3 := line3 + '所需转生等级' + IntToStr(g_MouseItem.S.NeedLevel);
              end;
            40: begin
                useable := True;
                line3 := line3 + '所需转生&等级' + IntToStr(g_MouseItem.S.NeedLevel);
              end;
            41: begin
                useable := True;
                line3 := line3 + '所需转生&攻击力' + IntToStr(g_MouseItem.S.NeedLevel);
              end;
            42: begin
                useable := True;
                line3 := line3 + '所需转生&魔法力' + IntToStr(g_MouseItem.S.NeedLevel);
              end;
            43: begin
                useable := True;
                line3 := line3 + '所需转生&道术' + IntToStr(g_MouseItem.S.NeedLevel);
              end;
            44: begin
                useable := True;
                line3 := line3 + '所需转生&声望点' + IntToStr(g_MouseItem.S.NeedLevel);
              end;
            5: begin
                useable := True;
                line3 := line3 + '所需声望点' + IntToStr(g_MouseItem.S.NeedLevel);
              end;
            6: begin
                useable := True;
                line3 := line3 + '行会成员专用';
              end;
            60: begin
                useable := True;
                line3 := line3 + '行会掌门专用';
              end;
            7: begin
                useable := True;
                line3 := line3 + '沙城成员专用';
              end;
            70: begin
                useable := True;
                line3 := line3 + '沙城城主专用';
              end;
            8: begin
                useable := True;
                line3 := line3 + '会员专用';
              end;
            81: begin
                useable := True;
                line3 := line3 + '会员类型 =' + IntToStr(Loword(g_MouseItem.S.NeedLevel)) + '会员等级 >=' + IntToStr(Hiword(g_MouseItem.S.NeedLevel));
              end;
            82: begin
                useable := True;
                line3 := line3 + '会员类型 >=' + IntToStr(Loword(g_MouseItem.S.NeedLevel)) + '会员等级 >=' + IntToStr(Hiword(g_MouseItem.S.NeedLevel));
              end;
          end;
        end;
      10, 11: {//男衣服, 女衣服} begin
          useable := FALSE;
          line1 := line1 + '重量' + IntToStr(g_MouseItem.S.Weight) +
            ' 持久' + GetDuraStr(g_MouseItem.Dura, g_MouseItem.DuraMax);
          //line1 := line1 + '重量' + IntToStr(MouseItem.S.Weight) +
          //      ' 持久'+ IntToStr(Round(MouseItem.Dura/1000)) + '/' + IntToStr(Round(MouseItem.DuraMax/1000));
          if g_MouseItem.S.AC > 0 then
            line2 := '防御' + IntToStr(Loword(g_MouseItem.S.AC)) + '-' + IntToStr(Hiword(g_MouseItem.S.AC)) + ' ';
          if g_MouseItem.S.MAC > 0 then
            line2 := line2 + '魔防' + IntToStr(Loword(g_MouseItem.S.MAC)) + '-' + IntToStr(Hiword(g_MouseItem.S.MAC)) + ' ';
          if g_MouseItem.S.DC > 0 then
            line2 := line2 + '攻击力' + IntToStr(Loword(g_MouseItem.S.DC)) + '-' + IntToStr(Hiword(g_MouseItem.S.DC)) + ' ';
          if g_MouseItem.S.MC > 0 then
            line2 := line2 + '魔法' + IntToStr(Loword(g_MouseItem.S.MC)) + '-' + IntToStr(Hiword(g_MouseItem.S.MC)) + ' ';
          if g_MouseItem.S.SC > 0 then
            line2 := line2 + '道术' + IntToStr(Loword(g_MouseItem.S.SC)) + '-' + IntToStr(Hiword(g_MouseItem.S.SC));

          if Lobyte(g_MouseItem.S.Source) > 0 then
            line3 := line3 + '幸运+' + IntToStr(Lobyte(g_MouseItem.S.Source)) + ' ';
          if Hibyte(g_MouseItem.S.Source) > 0 then
            line3 := line3 + '诅咒+' + IntToStr(Hibyte(g_MouseItem.S.Source)) + ' ';

          case g_MouseItem.S.Need of
            0: begin
                if g_MySelf.m_Abil.Level >= g_MouseItem.S.NeedLevel then
                  useable := True;
                line3 := line3 + '所需等级 ' + IntToStr(g_MouseItem.S.NeedLevel);
              end;
            1: begin
                if Hiword(g_MySelf.m_Abil.DC) >= g_MouseItem.S.NeedLevel then
                  useable := True;
                line3 := line3 + '需要攻击力 ' + IntToStr(g_MouseItem.S.NeedLevel);
              end;
            2: begin
                if Hiword(g_MySelf.m_Abil.MC) >= g_MouseItem.S.NeedLevel then
                  useable := True;
                line3 := line3 + '所需魔法值 ' + IntToStr(g_MouseItem.S.NeedLevel);
              end;
            3: begin
                if Hiword(g_MySelf.m_Abil.SC) >= g_MouseItem.S.NeedLevel then
                  useable := True;
                line3 := line3 + '所需道术 ' + IntToStr(g_MouseItem.S.NeedLevel);
              end;
            4: begin
                useable := True;
                line3 := line3 + '所需转生等级' + IntToStr(g_MouseItem.S.NeedLevel);
              end;
            40: begin
                useable := True;
                line3 := line3 + '所需转生&等级' + IntToStr(g_MouseItem.S.NeedLevel);
              end;
            41: begin
                useable := True;
                line3 := line3 + '所需转生&攻击力' + IntToStr(g_MouseItem.S.NeedLevel);
              end;
            42: begin
                useable := True;
                line3 := line3 + '所需转生&魔法力' + IntToStr(g_MouseItem.S.NeedLevel);
              end;
            43: begin
                useable := True;
                line3 := line3 + '所需转生&道术' + IntToStr(g_MouseItem.S.NeedLevel);
              end;
            44: begin
                useable := True;
                line3 := line3 + '所需转生&声望点' + IntToStr(g_MouseItem.S.NeedLevel);
              end;
            5: begin
                useable := True;
                line3 := line3 + '所需声望点' + IntToStr(g_MouseItem.S.NeedLevel);
              end;
            6: begin
                useable := True;
                line3 := line3 + '行会成员专用';
              end;
            60: begin
                useable := True;
                line3 := line3 + '行会掌门专用';
              end;
            7: begin
                useable := True;
                line3 := line3 + '沙城成员专用';
              end;
            70: begin
                useable := True;
                line3 := line3 + '沙城城主专用';
              end;
            8: begin
                useable := True;
                line3 := line3 + '会员专用';
              end;
            81: begin
                useable := True;
                line3 := line3 + '会员类型 =' + IntToStr(Loword(g_MouseItem.S.NeedLevel)) + '会员等级 >=' + IntToStr(Hiword(g_MouseItem.S.NeedLevel));
              end;
            82: begin
                useable := True;
                line3 := line3 + '会员类型 >=' + IntToStr(Loword(g_MouseItem.S.NeedLevel)) + '会员等级 >=' + IntToStr(Hiword(g_MouseItem.S.NeedLevel));
              end;
          end;
        end;
      15, //头盔,捧备
      19, 20, 21, //项链
      22, 23, //戒指
      24, 26, //手镯
      51,
        52, 62, //鞋
      53, 63,
        54, 64: {//腰带} begin
          useable := FALSE;
          line1 := line1 + '重量' + IntToStr(g_MouseItem.S.Weight) +
            ' 持久' + GetDuraStr(g_MouseItem.Dura, g_MouseItem.DuraMax);

          case g_MouseItem.S.StdMode of
            19, 53: {//项链} begin
                if g_MouseItem.S.AC > 0 then
                  line2 := line2 + '魔法躲避 +' + IntToStr(Hiword(g_MouseItem.S.AC)) + '0% ';
                if Loword(g_MouseItem.S.MAC) > 0 then line2 := line2 + '诅咒+' + IntToStr(Loword(g_MouseItem.S.MAC)) + ' ';
                if Hiword(g_MouseItem.S.MAC) > 0 then line2 := line2 + '幸运+' + IntToStr(Hiword(g_MouseItem.S.MAC)) + ' ';
                //箭磊 钎矫救凳 + IntToStr(Hibyte(MouseItem.S.MAC)) + ' ';
              end;
            20, 24, 52: {//项链 及 手镯: MaxAC -> Hit,  MaxMac -> Speed} begin
                if g_MouseItem.S.AC > 0 then
                  line2 := line2 + '准确+' + IntToStr(Hiword(g_MouseItem.S.AC)) + ' ';
                if g_MouseItem.S.MAC > 0 then
                  line2 := line2 + '敏捷+' + IntToStr(Hiword(g_MouseItem.S.MAC)) + ' ';
              end;
            21, 54: {//项链} begin
                if Hiword(g_MouseItem.S.AC) > 0 then
                  line2 := line2 + '体力恢复+' + IntToStr(Hiword(g_MouseItem.S.AC)) + '0% ';
                if Hiword(g_MouseItem.S.MAC) > 0 then
                  line2 := line2 + '魔法恢复+' + IntToStr(Hiword(g_MouseItem.S.MAC)) + '0% ';
                if Loword(g_MouseItem.S.AC) > 0 then
                  line2 := line2 + '攻击速度+' + IntToStr(Loword(g_MouseItem.S.AC)) + ' ';
                if Loword(g_MouseItem.S.MAC) > 0 then
                  line2 := line2 + '攻击速度-' + IntToStr(Loword(g_MouseItem.S.MAC)) + ' ';
              end;
            23: {//戒指} begin
                if Hiword(g_MouseItem.S.AC) > 0 then
                  line2 := line2 + '毒物躲避+' + IntToStr(Hiword(g_MouseItem.S.AC)) + '0% ';
                if Hiword(g_MouseItem.S.MAC) > 0 then
                  line2 := line2 + '中毒恢复+' + IntToStr(Hiword(g_MouseItem.S.MAC)) + '0% ';
                if Loword(g_MouseItem.S.AC) > 0 then
                  line2 := line2 + '攻击速度+' + IntToStr(Loword(g_MouseItem.S.AC)) + ' ';
                if Loword(g_MouseItem.S.MAC) > 0 then
                  line2 := line2 + '攻击速度-' + IntToStr(Loword(g_MouseItem.S.MAC)) + ' ';
              end;
            62: {//Boots} begin
                if Hiword(g_MouseItem.S.AC) > 0 then
                  line2 := line2 + '防御+' + IntToStr(Hiword(g_MouseItem.S.AC)) + ' ';
                if Hiword(g_MouseItem.S.MAC) > 0 then
                  line2 := line2 + '魔防+' + IntToStr(Hiword(g_MouseItem.S.MAC)) + ' ';
                if Loword(g_MouseItem.S.MAC) > 0 then
                  line2 := line2 + '魔法恢复+' + IntToStr(Loword(g_MouseItem.S.MAC)) + ' ';
              end;
            63: {//Charm} begin
                if Loword(g_MouseItem.S.AC) > 0 then line2 := line2 + '体力+' + IntToStr(Loword(g_MouseItem.S.AC)) + ' ';
                if Hiword(g_MouseItem.S.AC) > 0 then line2 := line2 + '魔法+' + IntToStr(Hiword(g_MouseItem.S.AC)) + ' ';
                if Loword(g_MouseItem.S.MAC) > 0 then line2 := line2 + '诅咒+' + IntToStr(Loword(g_MouseItem.S.MAC)) + ' ';
                if Hiword(g_MouseItem.S.MAC) > 0 then line2 := line2 + '幸运+' + IntToStr(Hiword(g_MouseItem.S.MAC)) + ' ';
              end;
            else begin
                if g_MouseItem.S.AC > 0 then
                  line2 := line2 + '防御' + IntToStr(Loword(g_MouseItem.S.AC)) + '-' + IntToStr(Hiword(g_MouseItem.S.AC)) + ' ';
                if g_MouseItem.S.MAC > 0 then
                  line2 := line2 + '魔防' + IntToStr(Loword(g_MouseItem.S.MAC)) + '-' + IntToStr(Hiword(g_MouseItem.S.MAC)) + ' ';
              end;
          end;
          if g_MouseItem.S.DC > 0 then
            line2 := line2 + '攻击力' + IntToStr(Loword(g_MouseItem.S.DC)) + '-' + IntToStr(Hiword(g_MouseItem.S.DC)) + ' ';
          if g_MouseItem.S.MC > 0 then
            line2 := line2 + '魔法' + IntToStr(Loword(g_MouseItem.S.MC)) + '-' + IntToStr(Hiword(g_MouseItem.S.MC)) + ' ';
          if g_MouseItem.S.SC > 0 then
            line2 := line2 + '道术' + IntToStr(Loword(g_MouseItem.S.SC)) + '-' + IntToStr(Hiword(g_MouseItem.S.SC)) + ' ';

          if (g_MouseItem.S.Source <= -1) and (g_MouseItem.S.Source >= -50) then
            line2 := line2 + '神圣+' + IntToStr(-g_MouseItem.S.Source);
          if (g_MouseItem.S.Source <= -51) and (g_MouseItem.S.Source >= -100) then
            line2 := line2 + '神圣-' + IntToStr(-g_MouseItem.S.Source - 50);

          case g_MouseItem.S.Need of
            0: begin
                if g_MySelf.m_Abil.Level >= g_MouseItem.S.NeedLevel then useable := True;
                line3 := line3 + '所需等级 ' + IntToStr(g_MouseItem.S.NeedLevel);
              end;
            1: begin
                if Hiword(g_MySelf.m_Abil.DC) >= g_MouseItem.S.NeedLevel then
                  useable := True;
                line3 := line3 + '需要攻击力 ' + IntToStr(g_MouseItem.S.NeedLevel);
              end;
            2: begin
                if Hiword(g_MySelf.m_Abil.MC) >= g_MouseItem.S.NeedLevel then
                  useable := True;
                line3 := line3 + '所需魔法值 ' + IntToStr(g_MouseItem.S.NeedLevel);
              end;
            3: begin
                if Hiword(g_MySelf.m_Abil.SC) >= g_MouseItem.S.NeedLevel then
                  useable := True;
                line3 := line3 + '所需道术 ' + IntToStr(g_MouseItem.S.NeedLevel);
              end;
            4: begin
                useable := True;
                line3 := line3 + '所需转生等级' + IntToStr(g_MouseItem.S.NeedLevel);
              end;
            40: begin
                useable := True;
                line3 := line3 + '所需转生&等级' + IntToStr(g_MouseItem.S.NeedLevel);
              end;
            41: begin
                useable := True;
                line3 := line3 + '所需转生&攻击力' + IntToStr(g_MouseItem.S.NeedLevel);
              end;
            42: begin
                useable := True;
                line3 := line3 + '所需转生&魔法力' + IntToStr(g_MouseItem.S.NeedLevel);
              end;
            43: begin
                useable := True;
                line3 := line3 + '所需转生&道术' + IntToStr(g_MouseItem.S.NeedLevel);
              end;
            44: begin
                useable := True;
                line3 := line3 + '所需转生&声望点' + IntToStr(g_MouseItem.S.NeedLevel);
              end;
            5: begin
                useable := True;
                line3 := line3 + '所需声望点' + IntToStr(g_MouseItem.S.NeedLevel);
              end;
            6: begin
                useable := True;
                line3 := line3 + '行会成员专用';
              end;
            60: begin
                useable := True;
                line3 := line3 + '行会掌门专用';
              end;
            7: begin
                useable := True;
                line3 := line3 + '沙城成员专用';
              end;
            70: begin
                useable := True;
                line3 := line3 + '沙城城主专用';
              end;
            8: begin
                useable := True;
                line3 := line3 + '会员专用';
              end;
            81: begin
                useable := True;
                line3 := line3 + '会员类型 =' + IntToStr(Loword(g_MouseItem.S.NeedLevel)) + '会员等级 >=' + IntToStr(Hiword(g_MouseItem.S.NeedLevel));
              end;
            82: begin
                useable := True;
                line3 := line3 + '会员类型 >=' + IntToStr(Loword(g_MouseItem.S.NeedLevel)) + '会员等级 >=' + IntToStr(Hiword(g_MouseItem.S.NeedLevel));
              end;
          end;
        end;
      25: {//护身符及毒药} begin
          line1 := line1 + '重量' + IntToStr(g_MouseItem.S.Weight);
          line2 := '数量 ' + GetDura100Str(g_MouseItem.Dura, g_MouseItem.DuraMax);
        end;
      30: {//照明物} begin
          line1 := line1 + '重量' + IntToStr(g_MouseItem.S.Weight) + ' 持久' + GetDuraStr(g_MouseItem.Dura, g_MouseItem.DuraMax);
        end;
      40: {//肉} begin
          line1 := line1 + '重量' + IntToStr(g_MouseItem.S.Weight) + ' 品质' + GetDuraStr(g_MouseItem.Dura, g_MouseItem.DuraMax);
        end;
      42: {//药材} begin
          line1 := line1 + '重量' + IntToStr(g_MouseItem.S.Weight) + ' 距犁';
        end;
      43: {//矿石} begin
          line1 := line1 + '重量' + IntToStr(g_MouseItem.S.Weight) + ' 纯度' + IntToStr(Round(g_MouseItem.Dura / 1000));
        end;
      else begin
          line1 := line1 + '重量' + IntToStr(g_MouseItem.S.Weight);
        end;
    end;
  end;
end;


procedure TFrmDlg.DItemBagDirectPaint(Sender: TObject;
  dsurface: TDirectDrawSurface);
var
  d0, d1, d2, d3: string;
  n: Integer;
  useable: Boolean;
  d: TDirectDrawSurface;
begin
  if g_MySelf = nil then Exit;
  with DItemBag do begin
    d := WLib.Images[FaceIndex];
    if d <> nil then
      dsurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, True);

    GetMouseItemInfo(d0, d1, d2, d3, useable);
    with dsurface.Canvas do begin
      SetBkMode(Handle, TRANSPARENT);
      Font.Color := clWhite;
      //TextOut (SurfaceX(Left+64), SurfaceY(Top+185), GetGoldStr(g_MySelf.m_nGold));
      TextOut(SurfaceX(Left + 71), SurfaceY(Top + 212), GetGoldStr(g_MySelf.m_nGold));
      //盛大物品栏
      if d0 <> '' then begin
        n := TextWidth(d0);
        Font.Color := clYellow;
        TextOut(SurfaceX(Left + 77 {70}), SurfaceY(Top + 243 {215}), d0);
        Font.Color := clWhite;
        TextOut(SurfaceX(Left + 77 {70}) + n, SurfaceY(Top + 243 {215}), d1);
        TextOut(SurfaceX(Left + 77 {70}), SurfaceY(Top + 243 {215} + 14), d2);
        if not useable then
          Font.Color := clRed;
        TextOut(SurfaceX(Left + 77 {70}), SurfaceY(Top + 243 {215} + 14 * 2), d3);
      end;
      Release;
    end;
  end;
end;

procedure TFrmDlg.DRepairItemInRealArea(Sender: TObject; X, Y: Integer;
  var IsRealArea: Boolean);
begin
  if (X >= 0) and (Y >= 0) and (X <= DRepairItem.Width) and
    (Y <= DRepairItem.Height) then
    IsRealArea := True
  else IsRealArea := FALSE;
end;

procedure TFrmDlg.DRepairItemDirectPaint(Sender: TObject;
  dsurface: TDirectDrawSurface);
var
  d: TDirectDrawSurface;
begin
  with DRepairItem do begin
    d := WLib.Images[FaceIndex];
    if DRepairItem.Downed and (d <> nil) then
      dsurface.Draw(SurfaceX(254), SurfaceY(183), d.ClientRect, d, True);
  end;
end;

procedure TFrmDlg.DCloseBagDirectPaint(Sender: TObject;
  dsurface: TDirectDrawSurface);
var
  d: TDirectDrawSurface;
begin
  with DCloseBag do begin
    if DCloseBag.Downed then begin
      d := WLib.Images[FaceIndex];
      if d <> nil then
        dsurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, True);
    end;
  end;
end;

procedure TFrmDlg.DCloseBagClick(Sender: TObject; X, Y: Integer);
begin
  DItemBag.Visible := FALSE;
end;

procedure TFrmDlg.DItemGridGridMouseMove(Sender: TObject; ACol,
  ARow: Integer; Shift: TShiftState);
var
  idx: Integer;
  temp: TClientItem;
  iname, d1, d2, d3: string;
  useable: Boolean;
  hcolor: TColor;
begin
  if ssRight in Shift then begin
    if g_boItemMoving then
      DItemGridGridSelect(Self, ACol, ARow, Shift);
  end else begin
    idx := ACol + ARow * DItemGrid.ColCount + 6 {骇飘傍埃};
    if idx in [6..MAXBAGITEM - 1] then begin
      g_MouseItem := g_ItemArr[idx];
      {GetMouseItemInfo (iname, d1, d2, d3, useable);
      if iname <> '' then begin
         if useable then hcolor := clWhite
         else hcolor := clRed;
         with DItemGrid do
            DScreen.ShowHint (SurfaceX(Left + ACol*ColWidth),
                              SurfaceY(Top + (ARow+1)*RowHeight),
                              iname + d1 + '\' + d2 + '\' + d3, hcolor, FALSE);
      end;
      g_MouseItem.S.Name := '';}
    end;
  end;
end;

procedure TFrmDlg.DItemGridGridSelect(Sender: TObject; ACol, ARow: Integer;
  Shift: TShiftState);
var
  idx, mi: Integer;
  temp: TClientItem;
begin
  idx := ACol + ARow * DItemGrid.ColCount + 6 {骇飘傍埃};
  if idx in [6..MAXBAGITEM - 1] then begin
    if not g_boItemMoving then begin
      if g_ItemArr[idx].S.name <> '' then begin
        g_boItemMoving := True;
        g_MovingItem.Index := idx;
        g_MovingItem.Item := g_ItemArr[idx];
        g_ItemArr[idx].S.name := '';
        ItemClickSound(g_ItemArr[idx].S);
      end;
    end else begin
      //ItemClickSound (MovingItem.Item.S.StdMode);
      mi := g_MovingItem.Index;
      if (mi = -97) or (mi = -98) then Exit; //捣...
      if (mi < 0) and (mi >= -13 {-9}) then begin //-99: Sell芒俊辑 啊规栏肺
        //惑怕芒俊辑 啊规栏肺
        g_WaitingUseItem := g_MovingItem;
        frmMain.SendTakeOffItem(-(g_MovingItem.Index + 1), g_MovingItem.Item.MakeIndex, g_MovingItem.Item.S.name);
        g_MovingItem.Item.S.name := '';
        g_boItemMoving := FALSE;
      end else begin
        if (mi <= -20) and (mi > -30) then
          DealItemReturnBag(g_MovingItem.Item);
        if g_ItemArr[idx].S.name <> '' then begin
          temp := g_ItemArr[idx];
          g_ItemArr[idx] := g_MovingItem.Item;
          g_MovingItem.Index := idx;
          g_MovingItem.Item := temp
        end else begin
          g_ItemArr[idx] := g_MovingItem.Item;
          g_MovingItem.Item.S.name := '';
          g_boItemMoving := FALSE;
        end;
      end;
    end;
  end;
  ArrangeItembag;
end;

procedure TFrmDlg.DItemGridDblClick(Sender: TObject);
var
  idx, i: Integer;
  keyvalue: TKeyBoardState;
  cu: TClientItem;
begin
  idx := DItemGrid.Col + DItemGrid.row * DItemGrid.ColCount + 6;
  if idx in [6..MAXBAGITEM - 1] then begin
    if g_ItemArr[idx].S.name <> '' then begin
      FillChar(keyvalue, sizeof(TKeyBoardState), #0);
      GetKeyboardState(keyvalue);
      if keyvalue[VK_CONTROL] = $80 then begin
        //骇飘芒栏肺 颗辫
        cu := g_ItemArr[idx];
        g_ItemArr[idx].S.name := '';
        AddItemBag(cu);
      end else
        if (g_ItemArr[idx].S.StdMode <= 4) or (g_ItemArr[idx].S.StdMode = 31) then begin //数量且 荐 乐绰 酒捞袍
        frmMain.EatItem(idx);
      end;
    end else begin
      if g_boItemMoving and (g_MovingItem.Item.S.name <> '') then begin
        FillChar(keyvalue, sizeof(TKeyBoardState), #0);
        GetKeyboardState(keyvalue);
        if keyvalue[VK_CONTROL] = $80 then begin
          //骇飘芒栏肺 颗辫
          cu := g_MovingItem.Item;
          g_MovingItem.Item.S.name := '';
          g_boItemMoving := FALSE;
          AddItemBag(cu);
        end else
          if (g_MovingItem.Index = idx) and
          (g_MovingItem.Item.S.StdMode <= 4) or (g_ItemArr[idx].S.StdMode = 31)
          then begin
          frmMain.EatItem(-1);
        end;
      end;
    end;
  end;
end;

procedure TFrmDlg.DItemGridGridPaint(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState; dsurface: TDirectDrawSurface);
var
  idx: Integer;
  d: TDirectDrawSurface;
begin
  idx := ACol + ARow * DItemGrid.ColCount + 6;
  if idx in [6..MAXBAGITEM - 1] then begin
    if g_ItemArr[idx].S.name <> '' then begin
      d := g_WBagItemImages.Images[g_ItemArr[idx].S.looks];
      if d <> nil then
        with DItemGrid do
          dsurface.Draw(SurfaceX(Rect.Left + (ColWidth - d.Width) div 2 - 1),
            SurfaceY(Rect.Top + (RowHeight - d.Height) div 2 + 1),
            d.ClientRect,
            d, True);
    end;
  end;
end;

procedure TFrmDlg.DGoldClick(Sender: TObject; X, Y: Integer);
begin
  if g_MySelf = nil then Exit;
  if not g_boItemMoving then begin
    if g_MySelf.m_nGold > 0 then begin
      PlaySound(s_money);
      g_boItemMoving := True;
      g_MovingItem.Index := -98; //捣
      g_MovingItem.Item.S.name := g_sGoldName {'金币'};
    end;
  end else begin
    if (g_MovingItem.Index = -97) or (g_MovingItem.Index = -98) then begin //捣父..
      g_boItemMoving := FALSE;
      g_MovingItem.Item.S.name := '';
      if g_MovingItem.Index = -97 then begin //背券芒俊辑 颗
        DealZeroGold;
      end;
    end;
  end;
  ;
end;






{------------------------------------------------------------------------}

//惑牢 措拳 芒

{------------------------------------------------------------------------}


procedure TFrmDlg.ShowMDlg(face: Integer; mname, msgstr: string);
var
  i: Integer;
begin
  DMerchantDlg.Left := 0; //扁夯 困摹
  DMerchantDlg.Top := 0;
  MerchantFace := face;
  MerchantName := mname;
  MDlgStr := msgstr;
  DMerchantDlg.Visible := True;
  DItemBag.Left := 475; //啊规困摹 函版
  DItemBag.Top := 0;
  for i := 0 to MDlgPoints.count - 1 do
    Dispose(pTClickPoint(MDlgPoints[i]));
  MDlgPoints.Clear;
  RequireAddPoints := True;
  LastestClickTime := GetTickCount;
end;


procedure TFrmDlg.ResetMenuDlg;
var
  i: Integer;
begin
  CloseDSellDlg;
  for i := 0 to g_MenuItemList.count - 1 do //技何 皋春档 努府绢 窃.
    Dispose(PTClientItem(g_MenuItemList[i]));
  g_MenuItemList.Clear;

  for i := 0 to MenuList.count - 1 do
    Dispose(PTClientGoods(MenuList[i]));
  MenuList.Clear;

  //CurDetailItem := '';
  menuindex := -1;
  MenuTopLine := 0;
  BoDetailMenu := FALSE;
  BoStorageMenu := FALSE;
  BoMakeDrugMenu := FALSE;

  DSellDlg.Visible := FALSE;
  DMenuDlg.Visible := FALSE;
end;

procedure TFrmDlg.ShowShopMenuDlg;
begin
  menuindex := -1;

  DMerchantDlg.Left := 0; //扁夯 困摹
  DMerchantDlg.Top := 0;
  DMerchantDlg.Visible := True;

  DSellDlg.Visible := FALSE;

  DMenuDlg.Left := 0;
  DMenuDlg.Top := 176;
  DMenuDlg.Visible := True;
  MenuTop := 0;

  DItemBag.Left := 475;
  DItemBag.Top := 0;
  DItemBag.Visible := True;

  LastestClickTime := GetTickCount;
end;

procedure TFrmDlg.ShowShopSellDlg;
begin
  DSellDlg.Left := 260;
  DSellDlg.Top := 176;
  DSellDlg.Visible := True;

  DMenuDlg.Visible := FALSE;

  DItemBag.Left := 475;
  DItemBag.Top := 0;
  DItemBag.Visible := True;

  LastestClickTime := GetTickCount;
  g_sSellPriceStr := '';
end;

procedure TFrmDlg.CloseMDlg;
var
  i: Integer;
begin
  MDlgStr := '';
  DMerchantDlg.Visible := FALSE;
  for i := 0 to MDlgPoints.count - 1 do
    Dispose(pTClickPoint(MDlgPoints[i]));
  MDlgPoints.Clear;
  //皋春芒档 摧澜
  DItemBag.Left := 0;
  DItemBag.Top := 0;
  DMenuDlg.Visible := FALSE;
  CloseDSellDlg;
end;

procedure TFrmDlg.CloseDSellDlg;
begin
  DSellDlg.Visible := FALSE;
  if g_SellDlgItem.S.name <> '' then
    AddItemBag(g_SellDlgItem);
  g_SellDlgItem.S.name := '';
end;

procedure TFrmDlg.DMerchantDlgDirectPaint(Sender: TObject;
  dsurface: TDirectDrawSurface);
  
  function GetColor(btColor: byte): TColor;
  begin
    case btColor of
      0: Result := clBlack;
      1: Result := clMaroon;
      2: Result := clGreen;
      3: Result := clOlive;
      4: Result := clNavy;
      5: Result := clPurple;
      6: Result := clTeal;
      7: Result := clGray;
      8: Result := clSilver;
      9: Result := clRed;
      10: Result := clLime;
      11: Result := clYellow;
      12: Result := clBlue;
      13: Result := clFuchsia;
      14: Result := clAqua;
      15: Result := clWhite;
      else begin
          Result := clRed;
        end;
    end;
  end;
  
var
  d: TDirectDrawSurface;
  str, data, fdata, cmdstr, cmdmsg, cmdparam: string;
  lx, ly, sx: Integer;
  drawcenter: Boolean;
  pcp: pTClickPoint;
  nLength: Integer;
  btColor: byte;
  UseColor: TColor;
  sColor: string;
begin
  UseColor := clRed;
  with Sender as TDWindow do begin
    d := WLib.Images[FaceIndex];
    if d <> nil then
      dsurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, True);
    SetBkMode(dsurface.Canvas.Handle, TRANSPARENT);
    lx := 30;
    ly := 20;
    str := MDlgStr;
    drawcenter := FALSE;
    while True do begin
      if str = '' then break;
      str := GetValidStr3(str, data, ['\']);
      if data <> '' then begin
        sx := 0;
        fdata := '';
        while (pos('<', data) > 0) and (pos('>', data) > 0) and (data <> '') do begin
          if data[1] <> '<' then begin
            data := '<' + GetValidStr3(data, fdata, ['<']);
          end;
          data := ArrestStringEx(data, '<', '>', cmdstr);
          //fdata + cmdstr + data
          if cmdstr <> '' then begin
            if Uppercase(cmdstr) = 'C' then begin
              drawcenter := True;
              continue;
            end;
            if Uppercase(cmdstr) = '/C' then begin
              drawcenter := FALSE;
              continue;
            end;
            cmdparam := GetValidStr3(cmdstr, cmdstr, ['/']); //cmdparam : 努腐 登菌阑 锭 静烙
          end else begin
            DMenuDlg.Visible := FALSE;
            DSellDlg.Visible := FALSE;
          end;

          if fdata <> '' then begin
            BoldTextOut(dsurface, SurfaceX(Left + lx + sx), SurfaceY(Top + ly), clWhite, clBlack, fdata);
            sx := sx + dsurface.Canvas.TextWidth(fdata);
          end;

          {获取字体颜色}                                 //2006-10-24 叶随风飘修改
          if (Length(cmdparam) > 0) and (cmdparam[1] <> '@') then begin
            nLength := CompareText(cmdparam, 'FCOLOR=');
            if (nLength > 0) and (Length(cmdparam) > Length('FCOLOR=')) then begin
              sColor := Copy(cmdparam, Length('FCOLOR=') + 1, nLength);
              btColor := Str_ToInt(sColor, 100);
              UseColor := GetColor(btColor);
              cmdparam := '';
            end;
          end;
          
          if cmdstr <> '' then begin
            if RequireAddPoints and (cmdparam <> '') then begin
              new(pcp);
              pcp.rc := Rect(lx + sx, ly, lx + sx + dsurface.Canvas.TextWidth(cmdstr), ly + 14);
              pcp.rstr := cmdparam;
              MDlgPoints.Add(pcp);
            end;
            if SelectMenuStr = cmdparam then begin           //2006-10-24 叶随风飘修改
              if (Length(cmdparam) > 0) and (cmdparam[1] = '@') then begin
                dsurface.Canvas.Font.Style := dsurface.Canvas.Font.Style + [fsUnderline];
                BoldTextOut(dsurface, SurfaceX(Left + lx + sx), SurfaceY(Top + ly), clLime, clBlack, cmdstr);
                sx := sx + dsurface.Canvas.TextWidth(cmdstr);
                dsurface.Canvas.Font.Style := dsurface.Canvas.Font.Style - [fsUnderline];
              end else begin
                BoldTextOut(dsurface, SurfaceX(Left + lx + sx), SurfaceY(Top + ly), UseColor {clRed}, clBlack, cmdstr);
                sx := sx + dsurface.Canvas.TextWidth(cmdstr);
              end;
            end else begin
              if (Length(cmdparam) > 0) and (cmdparam[1] = '@') then begin
                dsurface.Canvas.Font.Style := dsurface.Canvas.Font.Style + [fsUnderline];
                BoldTextOut(dsurface, SurfaceX(Left + lx + sx), SurfaceY(Top + ly), clYellow, clBlack, cmdstr);
                sx := sx + dsurface.Canvas.TextWidth(cmdstr);
                dsurface.Canvas.Font.Style := dsurface.Canvas.Font.Style - [fsUnderline];
              end else begin
                BoldTextOut(dsurface, SurfaceX(Left + lx + sx), SurfaceY(Top + ly), UseColor, clBlack, cmdstr);
                sx := sx + dsurface.Canvas.TextWidth(cmdstr);
              end;
            end;
          end;
        end;
        if data <> '' then
          BoldTextOut(dsurface, SurfaceX(Left + lx + sx), SurfaceY(Top + ly), clWhite, clBlack, data);
      end;
      ly := ly + 16;
    end;
    dsurface.Canvas.Release;
    RequireAddPoints := FALSE;
  end;
end;

procedure TFrmDlg.DMerchantDlgCloseClick(Sender: TObject; X, Y: Integer);
begin
  CloseMDlg;
end;

procedure TFrmDlg.DMenuDlgDirectPaint(Sender: TObject;
  dsurface: TDirectDrawSurface);
  function sx(X: Integer): Integer;
  begin
    Result := DMenuDlg.SurfaceX(DMenuDlg.Left + X);
  end;
  function sy(Y: Integer): Integer;
  begin
    Result := DMenuDlg.SurfaceY(DMenuDlg.Top + Y);
  end;
var
  i, lh, k, m, menuline: Integer;
  d: TDirectDrawSurface;
  pg: PTClientGoods;
  str: string;
begin
  with dsurface.Canvas do begin
    with DMenuDlg do begin
      d := DMenuDlg.WLib.Images[FaceIndex];
      if d <> nil then
        dsurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, True);
    end;

    SetBkMode(dsurface.Canvas.Handle, TRANSPARENT);
    SetBkMode(Handle, TRANSPARENT);
    //title
    Font.Color := clWhite;
    if not BoStorageMenu then begin
      TextOut(sx(19), sy(11), '物品列表');
      TextOut(sx(156), sy(11), '费用');
      TextOut(sx(245), sy(11), '持久.');
      lh := LISTLINEHEIGHT;
      menuline := _MIN(MAXMENU, MenuList.count - MenuTop);
      //惑前 府胶飘
      for i := MenuTop to MenuTop + menuline - 1 do begin
        m := i - MenuTop;
        if i = menuindex then begin
          Font.Color := clRed;
          TextOut(sx(12), sy(32 + m * lh), Char(7));
        end else Font.Color := clWhite;
        pg := PTClientGoods(MenuList[i]);
        TextOut(sx(19), sy(32 + m * lh), pg.name);
        if pg.SubMenu >= 1 then
          TextOut(sx(137), sy(32 + m * lh), #31);
        TextOut(sx(156), sy(32 + m * lh), IntToStr(pg.Price) + ' ' + g_sGoldName {金币'});
        str := '';
        if pg.Grade = -1 then str := '-'
        else TextOut(sx(245), sy(32 + m * lh), IntToStr(pg.Grade));
        {else for k:=0 to pg.Grade-1 do
           str := str + '*';
        if Length(str) >= 4 then begin
           Font.Color := clYellow;
           TextOut (SX(245), SY(32 + m*lh), str);
        end else
           TextOut (SX(245), SY(32 + m*lh), str);}
      end;
    end else begin
      TextOut(sx(19), sy(11), '物品列表');
      TextOut(sx(156), sy(11), '持久');
      TextOut(sx(245), sy(11), '');
      lh := LISTLINEHEIGHT;
      menuline := _MIN(MAXMENU, MenuList.count - MenuTop);
      //惑前 府胶飘
      for i := MenuTop to MenuTop + menuline - 1 do begin
        m := i - MenuTop;
        if i = menuindex then begin
          Font.Color := clRed;
          TextOut(sx(12), sy(32 + m * lh), Char(7));
        end else Font.Color := clWhite;
        pg := PTClientGoods(MenuList[i]);
        TextOut(sx(19), sy(32 + m * lh), pg.name);
        if pg.SubMenu >= 1 then
          TextOut(sx(137), sy(32 + m * lh), #31);
        TextOut(sx(156), sy(32 + m * lh), IntToStr(pg.Stock) + '/' + IntToStr(pg.Grade));
      end;
    end;
    //TextOut (0, 0, IntToStr(MenuTopLine));

    Release;
  end;
end;

procedure TFrmDlg.DMenuDlgClick(Sender: TObject; X, Y: Integer);
var
  lx, ly, idx: Integer;
  iname, d1, d2, d3: string;
  useable: Boolean;
begin
  DScreen.ClearHint;
  lx := DMenuDlg.LocalX(X) - DMenuDlg.Left;
  ly := DMenuDlg.LocalY(Y) - DMenuDlg.Top;
  if (lx >= 14) and (lx <= 279) and (ly >= 32) then begin
    idx := (ly - 32) div LISTLINEHEIGHT + MenuTop;
    if idx < MenuList.count then begin
      PlaySound(s_glass_button_click);
      menuindex := idx;
    end;
  end;

  if BoStorageMenu then begin
    if (menuindex >= 0) and (menuindex < g_SaveItemList.count) then begin
      g_MouseItem := PTClientItem(g_SaveItemList[menuindex])^;
      GetMouseItemInfo(iname, d1, d2, d3, useable);
      if iname <> '' then begin
        lx := 240;
        ly := 32 + (menuindex - MenuTop) * LISTLINEHEIGHT;
        with Sender as TDButton do
          DScreen.ShowHint(DMenuDlg.SurfaceX(Left + lx),
            DMenuDlg.SurfaceY(Top + ly),
            iname + d1 + '\' + d2 + '\' + d3, clYellow, FALSE);
      end;
      g_MouseItem.S.name := '';
    end;
  end else begin
    if (menuindex >= 0) and (menuindex < g_MenuItemList.count) and (PTClientGoods(MenuList[menuindex]).SubMenu = 0) then begin
      g_MouseItem := PTClientItem(g_MenuItemList[menuindex])^;
      BoNoDisplayMaxDura := True;
      GetMouseItemInfo(iname, d1, d2, d3, useable);
      BoNoDisplayMaxDura := FALSE;
      if iname <> '' then begin
        lx := 240;
        ly := 32 + (menuindex - MenuTop) * LISTLINEHEIGHT;
        with Sender as TDButton do
          DScreen.ShowHint(DMenuDlg.SurfaceX(Left + lx),
            DMenuDlg.SurfaceY(Top + ly),
            iname + d1 + '\' + d2 + '\' + d3, clYellow, FALSE);
      end;
      g_MouseItem.S.name := '';
    end;
  end;
end;

procedure TFrmDlg.DMenuDlgMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  with DMenuDlg do
    if (X < SurfaceX(Left + 10)) or (X > SurfaceX(Left + Width - 20)) or (Y < SurfaceY(Top + 30)) or (Y > SurfaceY(Top + Height - 50)) then begin
      DScreen.ClearHint;
    end;
end;

procedure TFrmDlg.DMenuBuyClick(Sender: TObject; X, Y: Integer);
var
  pg: PTClientGoods;
begin
  if GetTickCount < LastestClickTime then Exit; //努腐阑 磊林 给窍霸 力茄
  if (menuindex >= 0) and (menuindex < MenuList.count) then begin
    pg := PTClientGoods(MenuList[menuindex]);
    LastestClickTime := GetTickCount + 5000;
    if pg.SubMenu > 0 then begin
      frmMain.SendGetDetailItem(g_nCurMerchant, 0, pg.name);
      MenuTopLine := 0;
      CurDetailItem := pg.name;
    end else begin
      if BoStorageMenu then begin
        frmMain.SendTakeBackStorageItem(g_nCurMerchant, pg.Price {MakeIndex}, pg.name);
        Exit;
      end;
      if BoMakeDrugMenu then begin
        frmMain.SendMakeDrugItem(g_nCurMerchant, pg.name);
        Exit;
      end;
      frmMain.SendBuyItem(g_nCurMerchant, pg.Stock, pg.name)
    end;
  end;
end;

procedure TFrmDlg.DMenuPrevClick(Sender: TObject; X, Y: Integer);
begin
  if not BoDetailMenu then begin
    if MenuTop > 0 then Dec(MenuTop, MAXMENU - 1);
    if MenuTop < 0 then MenuTop := 0;
  end else begin
    if MenuTopLine > 0 then begin
      MenuTopLine := _MAX(0, MenuTopLine - 10);
      frmMain.SendGetDetailItem(g_nCurMerchant, MenuTopLine, CurDetailItem);
    end;
  end;
end;

procedure TFrmDlg.DMenuNextClick(Sender: TObject; X, Y: Integer);
begin
  if not BoDetailMenu then begin
    if MenuTop + MAXMENU < MenuList.count then Inc(MenuTop, MAXMENU - 1);
  end else begin
    MenuTopLine := MenuTopLine + 10;
    frmMain.SendGetDetailItem(g_nCurMerchant, MenuTopLine, CurDetailItem);
  end;
end;

procedure TFrmDlg.SoldOutGoods(itemserverindex: Integer);
var
  i: Integer;
  pg: PTClientGoods;
begin
  for i := 0 to MenuList.count - 1 do begin
    pg := PTClientGoods(MenuList[i]);
    if (pg.Grade >= 0) and (pg.Stock = itemserverindex) then begin
      Dispose(pg);
      MenuList.Delete(i);
      if i < g_MenuItemList.count then g_MenuItemList.Delete(i);
      if menuindex > MenuList.count - 1 then menuindex := MenuList.count - 1;
      break;
    end;
  end;
end;

procedure TFrmDlg.DelStorageItem(itemserverindex: Integer);
var
  i: Integer;
  pg: PTClientGoods;
begin
  for i := 0 to MenuList.count - 1 do begin
    pg := PTClientGoods(MenuList[i]);
    if (pg.Price = itemserverindex) then begin //焊包格废牢版款 Price = ItemServerIndex烙.
      Dispose(pg);
      MenuList.Delete(i);
      if i < g_SaveItemList.count then g_SaveItemList.Delete(i);
      if menuindex > MenuList.count - 1 then menuindex := MenuList.count - 1;
      break;
    end;
  end;
end;

procedure TFrmDlg.DMenuCloseClick(Sender: TObject; X, Y: Integer);
begin
  DMenuDlg.Visible := FALSE;
end;

procedure TFrmDlg.DMerchantDlgClick(Sender: TObject; X, Y: Integer);
var
  i, L, T: Integer;
  p: pTClickPoint;
begin
  if GetTickCount < LastestClickTime then Exit; //努腐阑 磊林 给窍霸 力茄
  L := DMerchantDlg.Left;
  T := DMerchantDlg.Top;
  with DMerchantDlg do
    for i := 0 to MDlgPoints.count - 1 do begin
      p := pTClickPoint(MDlgPoints[i]);
      if (X >= SurfaceX(L + p.rc.Left)) and (X <= SurfaceX(L + p.rc.Right)) and
        (Y >= SurfaceY(T + p.rc.Top)) and (Y <= SurfaceY(T + p.rc.Bottom)) then begin
        PlaySound(s_glass_button_click);
        frmMain.SendMerchantDlgSelect(g_nCurMerchant, p.rstr);
        LastestClickTime := GetTickCount + 5000; //5檬饶俊 数量 啊瓷
        break;
      end;
    end;
end;

procedure TFrmDlg.DMerchantDlgMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  i, L, T: Integer;
  p: pTClickPoint;
begin
  if GetTickCount < LastestClickTime then Exit; //努腐阑 磊林 给窍霸 力茄
  SelectMenuStr := '';
  L := DMerchantDlg.Left;
  T := DMerchantDlg.Top;
  with DMerchantDlg do
    for i := 0 to MDlgPoints.count - 1 do begin
      p := pTClickPoint(MDlgPoints[i]);
      if (X >= SurfaceX(L + p.rc.Left)) and (X <= SurfaceX(L + p.rc.Right)) and
        (Y >= SurfaceY(T + p.rc.Top)) and (Y <= SurfaceY(T + p.rc.Bottom)) then begin
        SelectMenuStr := p.rstr;
        break;
      end;
    end;
end;

procedure TFrmDlg.DMerchantDlgMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  SelectMenuStr := '';
end;

procedure TFrmDlg.DSellDlgDirectPaint(Sender: TObject;
  dsurface: TDirectDrawSurface);
var
  d: TDirectDrawSurface;
  actionname: string;
begin
  with DSellDlg do begin
    d := DMenuDlg.WLib.Images[FaceIndex];
    if d <> nil then
      dsurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, True);

    with dsurface.Canvas do begin
      SetBkMode(Handle, TRANSPARENT);
      Font.Color := clWhite;
      actionname := '';
      case SpotDlgMode of
        dmSell: actionname := '出售: ';
        dmRepair: actionname := '修理: ';
        dmStorage: actionname := ' 保管物品';
      end;
      TextOut(SurfaceX(Left + 8), SurfaceY(Top + 6), actionname + g_sSellPriceStr);
      Release;
    end;
  end;
end;

procedure TFrmDlg.DSellDlgCloseClick(Sender: TObject; X, Y: Integer);
begin
  CloseDSellDlg;
end;

procedure TFrmDlg.DSellDlgSpotClick(Sender: TObject; X, Y: Integer);
var
  temp: TClientItem;
begin
  g_sSellPriceStr := '';
  if not g_boItemMoving then begin
    if g_SellDlgItem.S.name <> '' then begin
      ItemClickSound(g_SellDlgItem.S);
      g_boItemMoving := True;
      g_MovingItem.Index := -99; //sell 芒俊辑 唱咳..
      g_MovingItem.Item := g_SellDlgItem;
      g_SellDlgItem.S.name := '';
    end;
  end else begin
    if (g_MovingItem.Index = -97) or (g_MovingItem.Index = -98) then Exit;
    if (g_MovingItem.Index >= 0) or (g_MovingItem.Index = -99) then begin //啊规,骇飘俊辑 柯巴父
      ItemClickSound(g_MovingItem.Item.S);
      if g_SellDlgItem.S.name <> '' then begin //磊府俊 乐栏搁
        temp := g_SellDlgItem;
        g_SellDlgItem := g_MovingItem.Item;
        g_MovingItem.Index := -99; //sell 芒俊辑 唱咳..
        g_MovingItem.Item := temp
      end else begin
        g_SellDlgItem := g_MovingItem.Item;
        g_MovingItem.Item.S.name := '';
        g_boItemMoving := FALSE;
      end;
      g_boQueryPrice := True;
      g_dwQueryPriceTime := GetTickCount;
    end;
  end;

end;

procedure TFrmDlg.DSellDlgSpotDirectPaint(Sender: TObject;
  dsurface: TDirectDrawSurface);
var
  d: TDirectDrawSurface;
begin
  if g_SellDlgItem.S.name <> '' then begin
    d := g_WBagItemImages.Images[g_SellDlgItem.S.looks];
    if d <> nil then
      with DSellDlgSpot do
        dsurface.Draw(SurfaceX(Left + (Width - d.Width) div 2),
          SurfaceY(Top + (Height - d.Height) div 2),
          d.ClientRect,
          d, True);
  end;
end;

procedure TFrmDlg.DSellDlgSpotMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  g_MouseItem := g_SellDlgItem;
end;

procedure TFrmDlg.DSellDlgOkClick(Sender: TObject; X, Y: Integer);
begin
  if (g_SellDlgItem.S.name = '') and (g_SellDlgItemSellWait.S.name = '') then Exit;
  if GetTickCount < LastestClickTime then Exit; //努腐阑 磊林 给窍霸 力茄
  case SpotDlgMode of
    dmSell: frmMain.SendSellItem(g_nCurMerchant, g_SellDlgItem.MakeIndex, g_SellDlgItem.S.name);
    dmRepair: frmMain.SendRepairItem(g_nCurMerchant, g_SellDlgItem.MakeIndex, g_SellDlgItem.S.name);
    dmStorage: frmMain.SendStorageItem(g_nCurMerchant, g_SellDlgItem.MakeIndex, g_SellDlgItem.S.name);
  end;
  g_SellDlgItemSellWait := g_SellDlgItem;
  g_SellDlgItem.S.name := '';
  LastestClickTime := GetTickCount + 5000;
  g_sSellPriceStr := '';
end;





{------------------------------------------------------------------------}

//魔法 虐 汲沥 芒 (促捞倔 肺弊)

{------------------------------------------------------------------------}


procedure TFrmDlg.SetMagicKeyDlg(icon: Integer; magname: string; var curkey: Word);
begin
  MagKeyIcon := icon;
  MagKeyMagName := magname;
  MagKeyCurKey := curkey;


  DKeySelDlg.Left := (SCREENWIDTH - DKeySelDlg.Width) div 2;
  DKeySelDlg.Top := (SCREENHEIGHT - DKeySelDlg.Height) div 2;
  HideAllControls;
  DKeySelDlg.ShowModal;

  while True do begin
    if not DKeySelDlg.Visible then break;
    //FrmMain.DXTimerTimer (self, 0);
    frmMain.ProcOnIdle;
    Application.ProcessMessages;
    if Application.Terminated then Exit;
  end;

  RestoreHideControls;
  curkey := MagKeyCurKey;
end;

procedure TFrmDlg.DKeySelDlgDirectPaint(Sender: TObject;
  dsurface: TDirectDrawSurface);
var
  d: TDirectDrawSurface;
begin
  with DKeySelDlg do begin
    d := WLib.Images[FaceIndex];
    if d <> nil then
      dsurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, True);
    //魔法快捷键
    with dsurface.Canvas do begin
      SetBkMode(Handle, TRANSPARENT);
      Font.Color := clSilver;
      TextOut(SurfaceX(Left + 95), SurfaceY(Top + 38), MagKeyMagName + ' 快捷键');
      Release;
    end;
  end;
end;

procedure TFrmDlg.DKsIconDirectPaint(Sender: TObject;
  dsurface: TDirectDrawSurface);
var
  d: TDirectDrawSurface;
begin
  with DKsIcon do begin
    d := g_WMagIconImages.Images[MagKeyIcon];
    if d <> nil then
      dsurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, True);
  end;
end;

procedure TFrmDlg.DKsF1DirectPaint(Sender: TObject;
  dsurface: TDirectDrawSurface);
var
  b: TDButton;
  d: TDirectDrawSurface;
begin
  b := nil;
  case MagKeyCurKey of
    Word('1'): b := DKsF1;
    Word('2'): b := DKsF2;
    Word('3'): b := DKsF3;
    Word('4'): b := DKsF4;
    Word('5'): b := DKsF5;
    Word('6'): b := DKsF6;
    Word('7'): b := DKsF7;
    Word('8'): b := DKsF8;
    else b := DKsNone;
  end;
  if b = Sender then begin
    with b do begin
      d := WLib.Images[FaceIndex + 1];
      if d <> nil then
        dsurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, True);
    end;
  end;
  with Sender as TDButton do begin
    if Downed then begin
      d := WLib.Images[FaceIndex];
      if d <> nil then
        dsurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, True);
    end;
  end;
end;

procedure TFrmDlg.DKsOkClick(Sender: TObject; X, Y: Integer);
begin
  DKeySelDlg.Visible := FALSE;
end;

procedure TFrmDlg.DKsF1Click(Sender: TObject; X, Y: Integer);
begin
  if Sender = DKsF1 then MagKeyCurKey := Integer('1');
  if Sender = DKsF2 then MagKeyCurKey := Integer('2');
  if Sender = DKsF3 then MagKeyCurKey := Integer('3');
  if Sender = DKsF4 then MagKeyCurKey := Integer('4');
  if Sender = DKsF5 then MagKeyCurKey := Integer('5');
  if Sender = DKsF6 then MagKeyCurKey := Integer('6');
  if Sender = DKsF7 then MagKeyCurKey := Integer('7');
  if Sender = DKsF8 then MagKeyCurKey := Integer('8');
  {  if Sender = DKsConF1 then MagKeyCurKey := integer('E');
     if Sender = DKsConF2 then MagKeyCurKey := integer('F');
     if Sender = DKsConF3 then MagKeyCurKey := integer('G');
     if Sender = DKsConF4 then MagKeyCurKey := integer('H');
     if Sender = DKsConF5 then MagKeyCurKey := integer('I');
     if Sender = DKsConF6 then MagKeyCurKey := integer('J');
     if Sender = DKsConF7 then MagKeyCurKey := integer('K');
     if Sender = DKsConF8 then MagKeyCurKey := integer('L');}
  if Sender = DKsNone then MagKeyCurKey := 0;
end;



{------------------------------------------------------------------------}

//扁夯芒狼 固聪 滚瓢

{------------------------------------------------------------------------}


procedure TFrmDlg.DBotMiniMapClick(Sender: TObject; X, Y: Integer);
begin
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

procedure TFrmDlg.DBotTradeClick(Sender: TObject; X, Y: Integer);
begin
  if GetTickCount > g_dwQueryMsgTick then begin
    g_dwQueryMsgTick := GetTickCount + 3000;
    frmMain.SendDealTry;
  end;
end;

procedure TFrmDlg.DBotGuildClick(Sender: TObject; X, Y: Integer);
begin
  if DGuildDlg.Visible then begin
    DGuildDlg.Visible := FALSE;
  end else
    if GetTickCount > g_dwQueryMsgTick then begin
    g_dwQueryMsgTick := GetTickCount + 3000;
    frmMain.SendGuildDlg;
  end;
end;

procedure TFrmDlg.DBotGroupClick(Sender: TObject; X, Y: Integer);
begin
  ToggleShowGroupDlg;
end;


{------------------------------------------------------------------------}

//弊缝 促捞倔肺弊

{------------------------------------------------------------------------}

procedure TFrmDlg.ToggleShowGroupDlg;
begin
  DGroupDlg.Visible := not DGroupDlg.Visible;
end;

procedure TFrmDlg.DGroupDlgDirectPaint(Sender: TObject;
  dsurface: TDirectDrawSurface);
var
  d: TDirectDrawSurface;
  lx, ly, n: Integer;
begin
  with DGroupDlg do begin
    d := WLib.Images[FaceIndex];
    if d <> nil then
      dsurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, True);
    if g_GroupMembers.count > 0 then begin
      with dsurface.Canvas do begin
        SetBkMode(Handle, TRANSPARENT);
        Font.Color := clSilver;
        lx := SurfaceX(28) + Left;
        ly := SurfaceY(80) + Top;
        TextOut(lx, ly, g_GroupMembers[0]);
        for n := 1 to g_GroupMembers.count - 1 do begin
          lx := SurfaceX(28) + Left + ((n - 1) mod 2) * 100;
          ly := SurfaceY(80 + 16) + Top + ((n - 1) div 2) * 16;
          TextOut(lx, ly, g_GroupMembers[n]);
        end;
        Release;
      end;
    end;
  end;
end;

procedure TFrmDlg.DGrpDlgCloseClick(Sender: TObject; X, Y: Integer);
begin
  DGroupDlg.Visible := FALSE;
end;

procedure TFrmDlg.DGrpAllowGroupDirectPaint(Sender: TObject;
  dsurface: TDirectDrawSurface);
var
  d: TDirectDrawSurface;
begin
  with Sender as TDButton do begin
    if Downed then begin
      d := WLib.Images[FaceIndex - 1];
      if d <> nil then
        dsurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, True);
    end else begin
      if g_boAllowGroup then begin
        d := WLib.Images[FaceIndex];
        if d <> nil then
          dsurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, True);
      end;
    end;
  end;
end;

procedure TFrmDlg.DGrpAllowGroupClick(Sender: TObject; X, Y: Integer);
begin
  if GetTickCount > g_dwChangeGroupModeTick then begin
    g_boAllowGroup := not g_boAllowGroup;
    g_dwChangeGroupModeTick := GetTickCount + 5000; //timeout 5檬
    frmMain.SendGroupMode(g_boAllowGroup);
  end;
end;

procedure TFrmDlg.DGrpCreateClick(Sender: TObject; X, Y: Integer);
var
  who: string;
begin
  if (GetTickCount > g_dwChangeGroupModeTick) and (g_GroupMembers.count = 0) then begin
    DialogSize := 1;
    DMessageDlg('输入想加入编组人物名称：', [mbOk, mbAbort]);
    who := Trim(DlgEditText);
    if who <> '' then begin
      g_dwChangeGroupModeTick := GetTickCount + 5000; //timeout 5檬
      frmMain.SendCreateGroup(Trim(DlgEditText));
    end;
  end;
end;

procedure TFrmDlg.DGrpAddMemClick(Sender: TObject; X, Y: Integer);
var
  who: string;
begin
  if (GetTickCount > g_dwChangeGroupModeTick) and (g_GroupMembers.count > 0) then begin
    DialogSize := 1;
    DMessageDlg('输入想加入编组人物名称：', [mbOk, mbAbort]);
    who := Trim(DlgEditText);
    if who <> '' then begin
      g_dwChangeGroupModeTick := GetTickCount + 5000; //timeout 5檬
      frmMain.SendAddGroupMember(Trim(DlgEditText));
    end;
  end;
end;

procedure TFrmDlg.DGrpDelMemClick(Sender: TObject; X, Y: Integer);
var
  who: string;
begin
  if (GetTickCount > g_dwChangeGroupModeTick) and (g_GroupMembers.count > 0) then begin
    DialogSize := 1;
    DMessageDlg('输入想退出编组人物名称：', [mbOk, mbAbort]);
    who := Trim(DlgEditText);
    if who <> '' then begin
      g_dwChangeGroupModeTick := GetTickCount + 5000; //timeout 5檬
      frmMain.SendDelGroupMember(Trim(DlgEditText));
    end;
  end;
end;

procedure TFrmDlg.DBotLogoutClick(Sender: TObject; X, Y: Integer);
begin
  //强行退出
  g_dwLatestStruckTick := GetTickCount() + 10001;
  g_dwLatestMagicTick := GetTickCount() + 10001;
  g_dwLatestHitTick := GetTickCount() + 10001;
  //
  if (GetTickCount - g_dwLatestStruckTick > 10000) and
    (GetTickCount - g_dwLatestMagicTick > 10000) and
    (GetTickCount - g_dwLatestHitTick > 10000) or
    (g_MySelf.m_boDeath) then begin
    frmMain.AppLogout;
  end else
    DScreen.AddChatBoardString('你在战斗当中不能退出游戏.', clYellow, clRed);
end;

procedure TFrmDlg.DBotExitClick(Sender: TObject; X, Y: Integer);
begin
  //强行退出
  g_dwLatestStruckTick := GetTickCount() + 10001;
  g_dwLatestMagicTick := GetTickCount() + 10001;
  g_dwLatestHitTick := GetTickCount() + 10001;
  //
  if (GetTickCount - g_dwLatestStruckTick > 10000) and
    (GetTickCount - g_dwLatestMagicTick > 10000) and
    (GetTickCount - g_dwLatestHitTick > 10000) or
    (g_MySelf.m_boDeath) then begin
    frmMain.AppExit;
  end else
    DScreen.AddChatBoardString('你在战斗当中不能退出游戏.', clYellow, clRed);
end;

procedure TFrmDlg.DBotPlusAbilClick(Sender: TObject; X, Y: Integer);
begin
  FrmDlg.OpenAdjustAbility;
end;


{------------------------------------------------------------------------}

//背券 促捞倔肺弊

{------------------------------------------------------------------------}


procedure TFrmDlg.OpenDealDlg;
var
  d: TDirectDrawSurface;
begin
  DDealRemoteDlg.Left := SCREENWIDTH - 236 - 100;
  DDealRemoteDlg.Top := 0;
  DDealDlg.Left := SCREENWIDTH - 236 - 100;
  DDealDlg.Top := DDealRemoteDlg.Height - 15;
  DItemBag.Left := 0; //475;
  DItemBag.Top := 0;
  DItemBag.Visible := True;
  DDealDlg.Visible := True;
  DDealRemoteDlg.Visible := True;

  FillChar(g_DealItems, sizeof(TClientItem) * 10, #0);
  FillChar(g_DealRemoteItems, sizeof(TClientItem) * 20, #0);
  g_nDealGold := 0;
  g_nDealRemoteGold := 0;
  g_boDealEnd := FALSE;

  //酒捞袍 啊规俊 儡惑捞 乐绰瘤 八荤
  ArrangeItembag;
end;

procedure TFrmDlg.CloseDealDlg;
begin
  DDealDlg.Visible := FALSE;
  DDealRemoteDlg.Visible := FALSE;

  //酒捞袍 啊规俊 儡惑捞 乐绰瘤 八荤
  ArrangeItembag;
end;

procedure TFrmDlg.DDealOkClick(Sender: TObject; X, Y: Integer);
var
  mi: Integer;
begin
  if GetTickCount > g_dwDealActionTick then begin
    //CloseDealDlg;
    frmMain.SendDealEnd;
    g_dwDealActionTick := GetTickCount + 4000;
    g_boDealEnd := True;
    //掉 芒俊辑 付快胶肺 缠绊 乐绰 巴阑 掉芒栏肺 持绰促. 付快胶俊 巢绰 儡惑(汗荤)阑 绝矩促.
    if g_boItemMoving then begin
      mi := g_MovingItem.Index;
      if (mi <= -20) and (mi > -30) then begin //掉 芒俊辑 柯巴父
        AddDealItem(g_MovingItem.Item);
        g_boItemMoving := FALSE;
        g_MovingItem.Item.S.name := '';
      end;
    end;
  end;
end;

procedure TFrmDlg.DDealCloseClick(Sender: TObject; X, Y: Integer);
begin
  if GetTickCount > g_dwDealActionTick then begin
    CloseDealDlg;
    frmMain.SendCancelDeal;
  end;
end;

procedure TFrmDlg.DDealRemoteDlgDirectPaint(Sender: TObject;
  dsurface: TDirectDrawSurface);
var
  d: TDirectDrawSurface;
begin
  with DDealRemoteDlg do begin
    d := WLib.Images[FaceIndex];
    if d <> nil then
      dsurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, True);
    with dsurface.Canvas do begin
      SetBkMode(Handle, TRANSPARENT);
      Font.Color := clWhite;
      TextOut(SurfaceX(Left + 64), SurfaceY(Top + 196 - 65), GetGoldStr(g_nDealRemoteGold));
      TextOut(SurfaceX(Left + 59 + (106 - TextWidth(g_sDealWho)) div 2), SurfaceY(Top + 3) + 3, g_sDealWho);
      Release;
    end;
  end;
end;

procedure TFrmDlg.DDealDlgDirectPaint(Sender: TObject;
  dsurface: TDirectDrawSurface);
var
  d: TDirectDrawSurface;
begin
  with DDealDlg do begin
    d := WLib.Images[FaceIndex];
    if d <> nil then
      dsurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, True);
    with dsurface.Canvas do begin
      SetBkMode(Handle, TRANSPARENT);
      Font.Color := clWhite;
      TextOut(SurfaceX(Left + 64), SurfaceY(Top + 196 - 65), GetGoldStr(g_nDealGold));
      TextOut(SurfaceX(Left + 59 + (106 - TextWidth(frmMain.CharName)) div 2), SurfaceY(Top + 3) + 3, frmMain.CharName);
      Release;
    end;
  end;
end;

procedure TFrmDlg.DealItemReturnBag(mitem: TClientItem);
begin
  if not g_boDealEnd then begin
    g_DealDlgItem := mitem;
    frmMain.SendDelDealItem(g_DealDlgItem);
    g_dwDealActionTick := GetTickCount + 4000;
  end;
end;

procedure TFrmDlg.DDGridGridSelect(Sender: TObject; ACol, ARow: Integer;
  Shift: TShiftState);
var
  temp: TClientItem;
  mi, idx: Integer;
begin
  if not g_boDealEnd and (GetTickCount > g_dwDealActionTick) then begin
    if not g_boItemMoving then begin
      idx := ACol + ARow * DDGrid.ColCount;
      if idx in [0..9] then
        if g_DealItems[idx].S.name <> '' then begin
          g_boItemMoving := True;
          g_MovingItem.Index := -idx - 20;
          g_MovingItem.Item := g_DealItems[idx];
          g_DealItems[idx].S.name := '';
          ItemClickSound(g_MovingItem.Item.S);
        end;
    end else begin
      mi := g_MovingItem.Index;
      if (mi >= 0) or (mi <= -20) and (mi > -30) then begin //啊规,俊辑 柯巴父
        ItemClickSound(g_MovingItem.Item.S);
        g_boItemMoving := FALSE;
        if mi >= 0 then begin
          g_DealDlgItem := g_MovingItem.Item; //辑滚俊 搬苞甫 扁促府绰悼救 焊包
          frmMain.SendAddDealItem(g_DealDlgItem);
          g_dwDealActionTick := GetTickCount + 4000;
        end else
          AddDealItem(g_MovingItem.Item);
        g_MovingItem.Item.S.name := '';
      end;
      if mi = -98 then DDGoldClick(Self, 0, 0);
    end;
    ArrangeItembag;
  end;
end;

procedure TFrmDlg.DDGridGridPaint(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState; dsurface: TDirectDrawSurface);
var
  idx: Integer;
  d: TDirectDrawSurface;
begin
  idx := ACol + ARow * DDGrid.ColCount;
  if idx in [0..9] then begin
    if g_DealItems[idx].S.name <> '' then begin
      d := g_WBagItemImages.Images[g_DealItems[idx].S.looks];
      if d <> nil then
        with DDGrid do
          dsurface.Draw(SurfaceX(Rect.Left + (ColWidth - d.Width) div 2 - 1),
            SurfaceY(Rect.Top + (RowHeight - d.Height) div 2 + 1),
            d.ClientRect,
            d, True);
    end;
  end;
end;

procedure TFrmDlg.DDGridGridMouseMove(Sender: TObject; ACol, ARow: Integer;
  Shift: TShiftState);
var
  idx: Integer;
begin
  idx := ACol + ARow * DDGrid.ColCount;
  if idx in [0..9] then begin
    g_MouseItem := g_DealItems[idx];
  end;
end;

procedure TFrmDlg.DDRGridGridPaint(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState; dsurface: TDirectDrawSurface);
var
  idx: Integer;
  d: TDirectDrawSurface;
begin
  idx := ACol + ARow * DDRGrid.ColCount;
  if idx in [0..19] then begin
    if g_DealRemoteItems[idx].S.name <> '' then begin
      d := g_WBagItemImages.Images[g_DealRemoteItems[idx].S.looks];
      if d <> nil then
        with DDRGrid do
          dsurface.Draw(SurfaceX(Rect.Left + (ColWidth - d.Width) div 2 - 1),
            SurfaceY(Rect.Top + (RowHeight - d.Height) div 2 + 1),
            d.ClientRect,
            d, True);
    end;
  end;
end;

procedure TFrmDlg.DDRGridGridMouseMove(Sender: TObject; ACol,
  ARow: Integer; Shift: TShiftState);
var
  idx: Integer;
begin
  idx := ACol + ARow * DDRGrid.ColCount;
  if idx in [0..19] then begin
    g_MouseItem := g_DealRemoteItems[idx];
  end;
end;

procedure TFrmDlg.DealZeroGold;
begin
  if not g_boDealEnd and (g_nDealGold > 0) then begin
    g_dwDealActionTick := GetTickCount + 4000;
    frmMain.SendChangeDealGold(0);
  end;
end;

procedure TFrmDlg.DDGoldClick(Sender: TObject; X, Y: Integer);
var
  DGold: Integer;
  valstr: string;
begin
  if g_MySelf = nil then Exit;
  if not g_boDealEnd and (GetTickCount > g_dwDealActionTick) then begin
    if not g_boItemMoving then begin
      if g_nDealGold > 0 then begin
        PlaySound(s_money);
        g_boItemMoving := True;
        g_MovingItem.Index := -97; //背券 芒俊辑狼 捣
        g_MovingItem.Item.S.name := g_sGoldName {'金币'};
      end;
    end else begin
      if (g_MovingItem.Index = -97) or (g_MovingItem.Index = -98) then begin //捣父..
        if (g_MovingItem.Index = -98) then begin //啊规芒俊辑 柯 捣
          if g_MovingItem.Item.S.name = g_sGoldName {'金币'} then begin
            //倔付甫 滚副 扒瘤 拱绢夯促.
            DialogSize := 1;
            g_boItemMoving := FALSE;
            g_MovingItem.Item.S.name := '';
            DMessageDlg('请输入要' + g_sGoldName + '数量：', [mbOk, mbAbort]);
            GetValidStrVal(DlgEditText, valstr, [' ']);
            DGold := Str_ToInt(valstr, 0);
            if (DGold <= (g_nDealGold + g_MySelf.m_nGold)) and (DGold > 0) then begin
              frmMain.SendChangeDealGold(DGold);
              g_dwDealActionTick := GetTickCount + 4000;
            end else
              DGold := 0;
          end;
        end;
        g_boItemMoving := FALSE;
        g_MovingItem.Item.S.name := '';
      end;
    end;
  end;
end;



{--------------------------------------------------------------}


procedure TFrmDlg.DUserState1DirectPaint(Sender: TObject;
  dsurface: TDirectDrawSurface);
var
  i, L, m, pgidx, bbx, bby, idx, ax, ay, sex, hair: Integer;
  d: TDirectDrawSurface;
  hcolor, keyimg, old: Integer;
  iname, d1, d2, d3: string;
  useable: Boolean;
begin
  with DUserState1 do begin
    d := WLib.Images[FaceIndex];
    if d <> nil then
      dsurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, True);

    //馒侩惑怕
    sex := DRESSfeature(UserState1.Feature) mod 2;
    hair := HAIRfeature(UserState1.Feature);
    if sex = 1 then pgidx := 30 //377 叶随风飘 修改
    else pgidx := 29; //376 叶随风飘 修改
    bbx := Left + 38;
    bby := Top + 52;
    d := g_WMain3Images.Images[pgidx]; //叶随风飘 修改
    if d <> nil then
      dsurface.Draw(SurfaceX(bbx), SurfaceY(bby), d.ClientRect, d, FALSE);
    bbx := bbx - 7;
    bby := bby + 44;
    //渴, 公扁, 赣府 胶鸥老
    idx := 440 + hair div 2; //赣府 胶鸥老
    if sex = 1 then idx := 480 + hair div 2;
    if idx > 0 then begin
      d := g_WMainImages.GetCachedImage(idx, ax, ay);
      if d <> nil then
        dsurface.Draw(SurfaceX(bbx + ax), SurfaceY(bby + ay), d.ClientRect, d, True);
    end;
    if UserState1.UseItems[U_DRESS].S.name <> '' then begin
      idx := UserState1.UseItems[U_DRESS].S.looks; //渴 if m_btSex = 1 then idx := 80; //咯磊渴
      if idx >= 0 then begin
        //d := FrmMain.WStateItem.GetCachedImage (idx, ax, ay);
        d := frmMain.GetWStateImg(idx, ax, ay);
        if d <> nil then
          dsurface.Draw(SurfaceX(bbx + ax), SurfaceY(bby + ay), d.ClientRect, d, True);
      end;
    end;
    if UserState1.UseItems[U_WEAPON].S.name <> '' then begin
      idx := UserState1.UseItems[U_WEAPON].S.looks;
      if idx >= 0 then begin
        //d := FrmMain.WStateItem.GetCachedImage (idx, ax, ay);
        d := frmMain.GetWStateImg(idx, ax, ay);
        if d <> nil then
          dsurface.Draw(SurfaceX(bbx + ax), SurfaceY(bby + ay), d.ClientRect, d, True);
      end;
    end;
    if UserState1.UseItems[U_HELMET].S.name <> '' then begin
      idx := UserState1.UseItems[U_HELMET].S.looks;
      if idx >= 0 then begin
        //d := FrmMain.WStateItem.GetCachedImage (idx, ax, ay);
        d := frmMain.GetWStateImg(idx, ax, ay);
        if d <> nil then
          dsurface.Draw(SurfaceX(bbx + ax), SurfaceY(bby + ay), d.ClientRect, d, True);
      end;
    end;

    //原为打开，本代码为显示人物身上所带物品信息，显示位置为人物下方
    if g_MouseUserStateItem.S.name <> '' then begin
      g_MouseItem := g_MouseUserStateItem;
      GetMouseItemInfo(iname, d1, d2, d3, useable);
      if iname <> '' then begin
        if g_MouseItem.Dura = 0 then hcolor := clRed
        else hcolor := clWhite;
        with dsurface.Canvas do begin
          SetBkMode(Handle, TRANSPARENT);
          old := Font.Size;
          Font.Size := 9;
          Font.Color := clYellow;
          TextOut(SurfaceX(Left + 37), SurfaceY(Top + 272 + 35), iname); //2006-10-24 叶随风飘修改
          Font.Color := hcolor;
          TextOut(SurfaceX(Left + 37 + TextWidth(iname)), SurfaceY(Top + 272 + 35), d1);
          TextOut(SurfaceX(Left + 37), SurfaceY(Top + 272 + 35 + TextHeight('A') + 2), d2);
          TextOut(SurfaceX(Left + 37), SurfaceY(Top + 272 + 35 + (TextHeight('A') + 2) * 2), d3);
          Font.Size := old;
          Release;
        end;
      end;
      g_MouseItem.S.name := '';
    end;

    with dsurface.Canvas do begin
      SetBkMode(Handle, TRANSPARENT);
      Font.Color := UserState1.NameColor;
      TextOut(SurfaceX(Left + 122 - TextWidth(UserState1.UserName) div 2),
        SurfaceY(Top + 23), UserState1.UserName);
      Font.Color := clSilver;
      TextOut(SurfaceX(Left + 45), SurfaceY(Top + 58),
        UserState1.GuildName + ' ' + UserState1.GuildRankName);
      Release;
    end;
  end;
end;

procedure TFrmDlg.DUserState1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  X := DUserState1.LocalX(X) - DUserState1.Left;
  Y := DUserState1.LocalY(Y) - DUserState1.Top;
  if (X > 42) and (X < 201) and (Y > 54) and (Y < 71) then begin
    //DScreen.AddSysMsg (IntToStr(X) + ' ' + IntToStr(Y) + ' ' + UserState1.GuildName);
    if UserState1.GuildName <> '' then begin
      PlayScene.EdChat.Visible := True;
      PlayScene.EdChat.SetFocus;
      SetImeMode(PlayScene.EdChat.Handle, LocalLanguage);
      PlayScene.EdChat.Text := UserState1.GuildName;
      PlayScene.EdChat.SelStart := Length(PlayScene.EdChat.Text);
      PlayScene.EdChat.SelLength := 0;
    end;
  end;
end;

procedure TFrmDlg.DUserState1MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  g_MouseUserStateItem.S.name := '';
end;

procedure TFrmDlg.DWeaponUS1MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  sel: Integer;
  iname, d1, d2, d3: string;
  useable: Boolean;
  hcolor: TColor;
begin
  sel := -1;
  if Sender = DDressUS1 then sel := U_DRESS;
  if Sender = DWeaponUS1 then sel := U_WEAPON;
  if Sender = DHelmetUS1 then sel := U_HELMET;
  if Sender = DNecklaceUS1 then sel := U_NECKLACE;
  if Sender = DLightUS1 then sel := U_RIGHTHAND;
  if Sender = DRingLUS1 then sel := U_RINGL;
  if Sender = DRingRUS1 then sel := U_RINGR;
  if Sender = DArmringLUS1 then sel := U_ARMRINGL;
  if Sender = DArmringRUS1 then sel := U_ARMRINGR;
  if Sender = DBujukUS1 then sel := U_BUJUK;
  if Sender = DBeltUS1 then sel := U_BELT;
  if Sender = DBootsUS1 then sel := U_BOOTS;
  if Sender = DCharmUS1 then sel := U_CHARM;

  if sel >= 0 then begin
    g_MouseUserStateItem := UserState1.UseItems[sel];
    g_MouseItem := UserState1.UseItems[sel];
    //原为注释掉 显示人物身上带的物品信息
    {
    GetMouseItemInfo(iname, d1, d2, d3, useable);
    if iname <> '' then begin
      if UserState1.UseItems[sel].Dura = 0 then hcolor := clRed
      else hcolor := clWhite;
      with Sender as TDButton do
        DScreen.ShowHint(SurfaceX(Left - 30),
          SurfaceY(Top + 50),
          iname + d1 + '\' + d2 + '\' + d3, hcolor, FALSE);
    end;
    g_MouseItem.S.name := '';  }
  end;
end;

procedure TFrmDlg.DCloseUS1Click(Sender: TObject; X, Y: Integer);
begin
  DUserState1.Visible := FALSE;
end;

procedure TFrmDlg.DNecklaceUS1DirectPaint(Sender: TObject;
  dsurface: TDirectDrawSurface);
var
  idx: Integer;
  d: TDirectDrawSurface;
begin
  if Sender = DNecklaceUS1 then begin
    if UserState1.UseItems[U_NECKLACE].S.name <> '' then begin
      idx := UserState1.UseItems[U_NECKLACE].S.looks;
      if idx >= 0 then begin
        //d := FrmMain.WStateItem.Images[idx];
        d := frmMain.GetWStateImg(idx);
        if d <> nil then
          dsurface.Draw(DNecklaceUS1.SurfaceX(DNecklaceUS1.Left + (DNecklaceUS1.Width - d.Width) div 2),
            DNecklaceUS1.SurfaceY(DNecklaceUS1.Top + (DNecklaceUS1.Height - d.Height) div 2),
            d.ClientRect, d, True);
      end;
    end;
  end;
  if Sender = DLightUS1 then begin
    if UserState1.UseItems[U_RIGHTHAND].S.name <> '' then begin
      idx := UserState1.UseItems[U_RIGHTHAND].S.looks;
      if idx >= 0 then begin
        //d := FrmMain.WStateItem.Images[idx];
        d := frmMain.GetWStateImg(idx);
        if d <> nil then
          dsurface.Draw(DLightUS1.SurfaceX(DLightUS1.Left + (DLightUS1.Width - d.Width) div 2),
            DLightUS1.SurfaceY(DLightUS1.Top + (DLightUS1.Height - d.Height) div 2),
            d.ClientRect, d, True);
      end;
    end;
  end;
  if Sender = DArmringRUS1 then begin
    if UserState1.UseItems[U_ARMRINGR].S.name <> '' then begin
      idx := UserState1.UseItems[U_ARMRINGR].S.looks;
      if idx >= 0 then begin
        //d := FrmMain.WStateItem.Images[idx];
        d := frmMain.GetWStateImg(idx);
        if d <> nil then
          dsurface.Draw(DArmringRUS1.SurfaceX(DArmringRUS1.Left + (DArmringRUS1.Width - d.Width) div 2),
            DArmringRUS1.SurfaceY(DArmringRUS1.Top + (DArmringRUS1.Height - d.Height) div 2),
            d.ClientRect, d, True);
      end;
    end;
  end;
  if Sender = DArmringLUS1 then begin
    if UserState1.UseItems[U_ARMRINGL].S.name <> '' then begin
      idx := UserState1.UseItems[U_ARMRINGL].S.looks;
      if idx >= 0 then begin
        //d := FrmMain.WStateItem.Images[idx];
        d := frmMain.GetWStateImg(idx);
        if d <> nil then
          dsurface.Draw(DArmringLUS1.SurfaceX(DArmringLUS1.Left + (DArmringLUS1.Width - d.Width) div 2),
            DArmringLUS1.SurfaceY(DArmringLUS1.Top + (DArmringLUS1.Height - d.Height) div 2),
            d.ClientRect, d, True);
      end;
    end;
  end;
  if Sender = DRingRUS1 then begin
    if UserState1.UseItems[U_RINGR].S.name <> '' then begin
      idx := UserState1.UseItems[U_RINGR].S.looks;
      if idx >= 0 then begin
        //d := FrmMain.WStateItem.Images[idx];
        d := frmMain.GetWStateImg(idx);
        if d <> nil then
          dsurface.Draw(DRingRUS1.SurfaceX(DRingRUS1.Left + (DRingRUS1.Width - d.Width) div 2),
            DRingRUS1.SurfaceY(DRingRUS1.Top + (DRingRUS1.Height - d.Height) div 2),
            d.ClientRect, d, True);
      end;
    end;
  end;
  if Sender = DRingLUS1 then begin
    if UserState1.UseItems[U_RINGL].S.name <> '' then begin
      idx := UserState1.UseItems[U_RINGL].S.looks;
      if idx >= 0 then begin
        //d := FrmMain.WStateItem.Images[idx];
        d := frmMain.GetWStateImg(idx);
        if d <> nil then
          dsurface.Draw(DRingLUS1.SurfaceX(DRingLUS1.Left + (DRingLUS1.Width - d.Width) div 2),
            DRingLUS1.SurfaceY(DRingLUS1.Top + (DRingLUS1.Height - d.Height) div 2),
            d.ClientRect, d, True);
      end;
    end;
  end;


  if Sender = DBujukUS1 then begin
    if UserState1.UseItems[U_BUJUK].S.name <> '' then begin
      idx := UserState1.UseItems[U_BUJUK].S.looks;
      if idx >= 0 then begin
        //d := FrmMain.WStateItem.Images[idx];
        d := frmMain.GetWStateImg(idx);
        if d <> nil then
          dsurface.Draw(DBujukUS1.SurfaceX(DBujukUS1.Left + (DBujukUS1.Width - d.Width) div 2),
            DBujukUS1.SurfaceY(DBujukUS1.Top + (DBujukUS1.Height - d.Height) div 2),
            d.ClientRect, d, True);
      end;
    end;
  end;

  if Sender = DBeltUS1 then begin
    if UserState1.UseItems[U_BELT].S.name <> '' then begin
      idx := UserState1.UseItems[U_BELT].S.looks;
      if idx >= 0 then begin
        //d := FrmMain.WStateItem.Images[idx];
        d := frmMain.GetWStateImg(idx);
        if d <> nil then
          dsurface.Draw(DBeltUS1.SurfaceX(DBeltUS1.Left + (DBeltUS1.Width - d.Width) div 2),
            DBeltUS1.SurfaceY(DBeltUS1.Top + (DBeltUS1.Height - d.Height) div 2),
            d.ClientRect, d, True);
      end;
    end;
  end;

  if Sender = DBootsUS1 then begin
    if UserState1.UseItems[U_BOOTS].S.name <> '' then begin
      idx := UserState1.UseItems[U_BOOTS].S.looks;
      if idx >= 0 then begin
        //d := FrmMain.WStateItem.Images[idx];
        d := frmMain.GetWStateImg(idx);
        if d <> nil then
          dsurface.Draw(DBootsUS1.SurfaceX(DBootsUS1.Left + (DBootsUS1.Width - d.Width) div 2),
            DBootsUS1.SurfaceY(DBootsUS1.Top + (DBootsUS1.Height - d.Height) div 2),
            d.ClientRect, d, True);
      end;
    end;
  end;

  if Sender = DCharmUS1 then begin
    if UserState1.UseItems[U_CHARM].S.name <> '' then begin
      idx := UserState1.UseItems[U_CHARM].S.looks;
      if idx >= 0 then begin
        //d := FrmMain.WStateItem.Images[idx];
        d := frmMain.GetWStateImg(idx);
        if d <> nil then
          dsurface.Draw(DCharmUS1.SurfaceX(DCharmUS1.Left + (DCharmUS1.Width - d.Width) div 2),
            DCharmUS1.SurfaceY(DCharmUS1.Top + (DCharmUS1.Height - d.Height) div 2),
            d.ClientRect, d, True);
      end;
    end;
  end;
end;


procedure TFrmDlg.ShowGuildDlg;
begin
  DGuildDlg.Visible := True; //not DGuildDlg.Visible;
  DGuildDlg.Top := -3;
  DGuildDlg.Left := 0;
  if DGuildDlg.Visible then begin
    if GuildCommanderMode then begin
      DGDAddMem.Visible := True;
      DGDDelMem.Visible := True;
      DGDEditNotice.Visible := True;
      DGDEditGrade.Visible := True;
      DGDAlly.Visible := True;
      DGDBreakAlly.Visible := True;
      DGDWar.Visible := True;
      DGDCancelWar.Visible := True;
    end else begin
      DGDAddMem.Visible := FALSE;
      DGDDelMem.Visible := FALSE;
      DGDEditNotice.Visible := FALSE;
      DGDEditGrade.Visible := FALSE;
      DGDAlly.Visible := FALSE;
      DGDBreakAlly.Visible := FALSE;
      DGDWar.Visible := FALSE;
      DGDCancelWar.Visible := FALSE;
    end;
  end;
  GuildTopLine := 0;
end;

procedure TFrmDlg.ShowGuildEditNotice;
var
  d: TDirectDrawSurface;
  i: Integer;
  data: string;
begin
  with DGuildEditNotice do begin
    d := WLib.Images[FaceIndex];
    if d <> nil then begin
      Left := (SCREENWIDTH - d.Width) div 2;
      Top := (SCREENHEIGHT - d.Height) div 2;
    end;
    HideAllControls;
    DGuildEditNotice.ShowModal;

    Memo.Left := SurfaceX(Left + 16);
    Memo.Top := SurfaceY(Top + 36);
    Memo.Width := 571;
    Memo.Height := 246;
    Memo.Lines.Assign(GuildNotice);
    Memo.Visible := True;

    while True do begin
      if not DGuildEditNotice.Visible then break;
      frmMain.ProcOnIdle;
      Application.ProcessMessages;
      if Application.Terminated then Exit;
    end;

    DGuildEditNotice.Visible := FALSE;
    RestoreHideControls;

    if DMsgDlg.DialogResult = mrOk then begin
      data := '';
      for i := 0 to Memo.Lines.count - 1 do begin
        if Memo.Lines[i] = '' then
          data := data + Memo.Lines[i] + ' '#13
        else data := data + Memo.Lines[i] + #13;
      end;
      if Length(data) > 4000 then begin
        data := Copy(data, 1, 4000);
        DMessageDlg('公告内容超过限制大小，公告内容将被截短！', [mbOk]);
      end;
      frmMain.SendGuildUpdateNotice(data);
    end;
  end;
end;

procedure TFrmDlg.ShowGuildEditGrade;
var
  d: TDirectDrawSurface;
  data: string;
  i: Integer;
begin
  if GuildMembers.count <= 0 then begin
    DMessageDlg('请先打开成员列表。', [mbOk]);
    Exit;
  end;

  with DGuildEditNotice do begin
    d := WLib.Images[FaceIndex];
    if d <> nil then begin
      Left := (SCREENWIDTH - d.Width) div 2;
      Top := (SCREENHEIGHT - d.Height) div 2;
    end;
    HideAllControls;
    DGuildEditNotice.ShowModal;

    Memo.Left := SurfaceX(Left + 16);
    Memo.Top := SurfaceY(Top + 36);
    Memo.Width := 571;
    Memo.Height := 246;
    Memo.Lines.Assign(GuildMembers);
    Memo.Visible := True;

    while True do begin
      if not DGuildEditNotice.Visible then break;
      frmMain.ProcOnIdle;
      Application.ProcessMessages;
      if Application.Terminated then Exit;
    end;

    DGuildEditNotice.Visible := FALSE;
    RestoreHideControls;

    if DMsgDlg.DialogResult = mrOk then begin
      //GuildMembers.Assign (Memo.Lines);
      //搬苞... 巩颇殿鞭阑 诀单捞飘 茄促.
      data := '';
      for i := 0 to Memo.Lines.count - 1 do begin
        data := data + Memo.Lines[i] + #13; //辑滚俊辑 颇教窃.
      end;
      if Length(data) > 5000 then begin
        data := Copy(data, 1, 5000);
        DMessageDlg('内容超过限制大小，内容将被截短！', [mbOk]);
      end;
      frmMain.SendGuildUpdateGrade(data);
    end;
  end;
end;

procedure TFrmDlg.DGuildDlgDirectPaint(Sender: TObject;
  dsurface: TDirectDrawSurface);
var
  d: TDirectDrawSurface;
  i, n, bx, by: Integer;
begin
  with DGuildDlg do begin
    d := WLib.Images[FaceIndex];
    if d <> nil then
      dsurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, True);
    with dsurface.Canvas do begin
      SetBkMode(Handle, TRANSPARENT);
      Font.Color := clWhite;
      TextOut(Left + 320, Top + 13, Guild);
      bx := Left + 24;
      by := Top + 41;
      for i := GuildTopLine to GuildStrs.count - 1 do begin
        n := i - GuildTopLine;
        if n * 14 > 356 then break;
        if Integer(GuildStrs.Objects[i]) <> 0 then Font.Color := TColor(GuildStrs.Objects[i])
        else begin
          if BoGuildChat then Font.Color := GetRGB(2)
          else Font.Color := clSilver;
        end;
        TextOut(bx, by + n * 14, GuildStrs[i]);
      end;
      Release;
    end;
  end;
end;

procedure TFrmDlg.DGDUpClick(Sender: TObject; X, Y: Integer);
begin
  if GuildTopLine > 0 then Dec(GuildTopLine, 3);
  if GuildTopLine < 0 then GuildTopLine := 0;
end;

procedure TFrmDlg.DGDDownClick(Sender: TObject; X, Y: Integer);
begin
  if GuildTopLine + 12 < GuildStrs.count then Inc(GuildTopLine, 3);
end;

procedure TFrmDlg.DGDCloseClick(Sender: TObject; X, Y: Integer);
begin
  DGuildDlg.Visible := FALSE;
  BoGuildChat := FALSE;
end;

procedure TFrmDlg.DGDHomeClick(Sender: TObject; X, Y: Integer);
begin
  if GetTickCount > g_dwQueryMsgTick then begin
    g_dwQueryMsgTick := GetTickCount + 3000;
    frmMain.SendGuildHome;
    BoGuildChat := FALSE;
  end;
end;

procedure TFrmDlg.DGDListClick(Sender: TObject; X, Y: Integer);
begin
  if GetTickCount > g_dwQueryMsgTick then begin
    g_dwQueryMsgTick := GetTickCount + 3000;
    frmMain.SendGuildMemberList;
    BoGuildChat := FALSE;
  end;
end;

procedure TFrmDlg.DGDAddMemClick(Sender: TObject; X, Y: Integer);
begin
  DMessageDlg('请输入想加入' + Guild + '的人物名称：', [mbOk, mbAbort]);
  if DlgEditText <> '' then
    frmMain.SendGuildAddMem(DlgEditText);
end;

procedure TFrmDlg.DGDDelMemClick(Sender: TObject; X, Y: Integer);
begin
  DMessageDlg('请输入想要开除的人物名称：', [mbOk, mbAbort]);
  if DlgEditText <> '' then
    frmMain.SendGuildDelMem(DlgEditText);
end;

procedure TFrmDlg.DGDEditNoticeClick(Sender: TObject; X, Y: Integer);
begin
  GuildEditHint := '[修改行会公告内容。]';
  ShowGuildEditNotice;
end;

procedure TFrmDlg.DGDEditGradeClick(Sender: TObject; X, Y: Integer);
begin
  GuildEditHint := '[修改行会成员的等级和职位。 # 警告 : 不能增加行会成员/删除行会成员。]';
  ShowGuildEditGrade;
end;

procedure TFrmDlg.DGDAllyClick(Sender: TObject; X, Y: Integer);
begin
  if mrOk = DMessageDlg('对方结盟行会必需在 [允许结盟]状态下。\' +
    '而且二个行会的掌门必须面对面。\' +
    '是否确认行会结盟？', [mbOk, mbCancel])
    then
    frmMain.SendSay('@联盟');
end;

procedure TFrmDlg.DGDBreakAllyClick(Sender: TObject; X, Y: Integer);
begin
  DMessageDlg('请输入您想取消结盟的行会的名字：', [mbOk, mbAbort]);
  if DlgEditText <> '' then
    frmMain.SendSay('@取消联盟 ' + DlgEditText);
end;



procedure TFrmDlg.DGuildEditNoticeDirectPaint(Sender: TObject;
  dsurface: TDirectDrawSurface);
var
  d: TDirectDrawSurface;
begin
  with DGuildEditNotice do begin
    d := WLib.Images[FaceIndex];
    if d <> nil then
      dsurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, True);

    with dsurface.Canvas do begin
      SetBkMode(Handle, TRANSPARENT);
      Font.Color := clSilver;

      TextOut(Left + 18, Top + 291, GuildEditHint);
      Release;
    end;
  end;
end;

procedure TFrmDlg.DGECloseClick(Sender: TObject; X, Y: Integer);
begin
  DGuildEditNotice.Visible := FALSE;
  Memo.Visible := FALSE;
  DMsgDlg.DialogResult := mrCancel;
end;

procedure TFrmDlg.DGEOkClick(Sender: TObject; X, Y: Integer);
begin
  DGECloseClick(Self, 0, 0);
  DMsgDlg.DialogResult := mrOk;
end;

procedure TFrmDlg.AddGuildChat(str: string);
var
  i: Integer;
begin
  GuildChats.Add(str);
  if GuildChats.count > 500 then begin
    for i := 0 to 100 do GuildChats.Delete(0);
  end;
  if BoGuildChat then
    GuildStrs.Assign(GuildChats);
end;

procedure TFrmDlg.DGDChatClick(Sender: TObject; X, Y: Integer);
begin
  BoGuildChat := not BoGuildChat;
  if BoGuildChat then begin
    GuildStrs2.Assign(GuildStrs);
    GuildStrs.Assign(GuildChats);
  end else
    GuildStrs.Assign(GuildStrs2);
end;

procedure TFrmDlg.DGoldDirectPaint(Sender: TObject;
  dsurface: TDirectDrawSurface);
var
  d: TDirectDrawSurface;
begin
  if g_MySelf = nil then Exit;
  with DGold do begin
    d := WLib.Images[FaceIndex];
    if d <> nil then
      dsurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, True);
  end;
end;


{--------------------------------------------------------------}
//瓷仿摹 炼沥 芒

procedure TFrmDlg.DAdjustAbilCloseClick(Sender: TObject; X, Y: Integer);
begin
  DAdjustAbility.Visible := FALSE;
  g_nBonusPoint := g_nSaveBonusPoint;
end;

procedure TFrmDlg.DAdjustAbilityDirectPaint(Sender: TObject;
  dsurface: TDirectDrawSurface);
  procedure AdjustAb(abil: byte; val: Word; var lov, hiv: Word);
  var
    lo, hi: byte;
    i: Integer;
  begin
    lo := Lobyte(abil);
    hi := Hibyte(abil);
    lov := 0; hiv := 0;
    for i := 1 to val do begin
      if lo + 1 < hi then begin
        Inc(lo); Inc(lov);
      end else begin
        Inc(hi); Inc(hiv); end;
    end;
  end;
var
  d: TDirectDrawSurface;
  L, m, adc, amc, asc, aac, amac: Integer;
  ldc, lmc, lsc, lac, lmac, hdc, hmc, hsc, hac, hmac: Word;
begin
  if g_MySelf = nil then Exit;
  with dsurface.Canvas do begin
    with DAdjustAbility do begin
      d := DMenuDlg.WLib.Images[FaceIndex];
      if d <> nil then
        dsurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, True);
    end;

    SetBkMode(Handle, TRANSPARENT);
    Font.Color := clSilver;

    L := DAdjustAbility.SurfaceX(DAdjustAbility.Left) + 36;
    m := DAdjustAbility.SurfaceY(DAdjustAbility.Top) + 22;

    TextOut(L, m, '你当前还有剩余部份属性点未分配。');
    TextOut(L, m + 14, '请根据自己的意向，调整自己的属性值。');
    TextOut(L, m + 14 * 2, '些属性点数，下不可以重新分配。');
    TextOut(L, m + 14 * 3, '在分配时要小心选择。');

    Font.Color := clWhite;
    //泅犁狼 瓷仿摹
    L := DAdjustAbility.SurfaceX(DAdjustAbility.Left) + 100; //66;
    m := DAdjustAbility.SurfaceY(DAdjustAbility.Top) + 101;

    {
    adc := (g_BonusAbil.DC + g_BonusAbilChg.DC) div g_BonusTick.DC;
    amc := (g_BonusAbil.MC + g_BonusAbilChg.MC) div g_BonusTick.MC;
    asc := (g_BonusAbil.SC + g_BonusAbilChg.SC) div g_BonusTick.SC;
    aac := (g_BonusAbil.AC + g_BonusAbilChg.AC) div g_BonusTick.AC;
    amac := (g_BonusAbil.MAC + g_BonusAbilChg.MAC) div g_BonusTick.MAC;
    }
    adc := (g_BonusAbilChg.DC) div g_BonusTick.DC;
    amc := (g_BonusAbilChg.MC) div g_BonusTick.MC;
    asc := (g_BonusAbilChg.SC) div g_BonusTick.SC;
    aac := (g_BonusAbilChg.AC) div g_BonusTick.AC;
    amac := (g_BonusAbilChg.MAC) div g_BonusTick.MAC;

    AdjustAb(g_NakedAbil.DC, adc, ldc, hdc);
    AdjustAb(g_NakedAbil.MC, amc, lmc, hmc);
    AdjustAb(g_NakedAbil.SC, asc, lsc, hsc);
    AdjustAb(g_NakedAbil.AC, aac, lac, hac);
    AdjustAb(g_NakedAbil.MAC, amac, lmac, hmac);
    //lac  := 0;  hac := aac;
    //lmac := 0;  hmac := amac;

    TextOut(L + 0, m + 0, IntToStr(Loword(g_MySelf.m_Abil.DC) + ldc) + '-' + IntToStr(Hiword(g_MySelf.m_Abil.DC) + hdc));
    TextOut(L + 0, m + 20, IntToStr(Loword(g_MySelf.m_Abil.MC) + lmc) + '-' + IntToStr(Hiword(g_MySelf.m_Abil.MC) + hmc));
    TextOut(L + 0, m + 40, IntToStr(Loword(g_MySelf.m_Abil.SC) + lsc) + '-' + IntToStr(Hiword(g_MySelf.m_Abil.SC) + hsc));
    TextOut(L + 0, m + 60, IntToStr(Loword(g_MySelf.m_Abil.AC) + lac) + '-' + IntToStr(Hiword(g_MySelf.m_Abil.AC) + hac));
    TextOut(L + 0, m + 80, IntToStr(Loword(g_MySelf.m_Abil.MAC) + lmac) + '-' + IntToStr(Hiword(g_MySelf.m_Abil.MAC) + hmac));
    TextOut(L + 0, m + 100, IntToStr(g_MySelf.m_Abil.MaxHP + (g_BonusAbil.HP + g_BonusAbilChg.HP) div g_BonusTick.HP));
    TextOut(L + 0, m + 120, IntToStr(g_MySelf.m_Abil.MaxMP + (g_BonusAbil.MP + g_BonusAbilChg.MP) div g_BonusTick.MP));
    TextOut(L + 0, m + 140, IntToStr(g_nMyHitPoint + (g_BonusAbil.Hit + g_BonusAbilChg.Hit) div g_BonusTick.Hit));
    TextOut(L + 0, m + 160, IntToStr(g_nMySpeedPoint + (g_BonusAbil.Speed + g_BonusAbilChg.Speed) div g_BonusTick.Speed));

    Font.Color := clYellow;
    TextOut(L + 0, m + 180, IntToStr(g_nBonusPoint));

    Font.Color := clWhite;
    L := DAdjustAbility.SurfaceX(DAdjustAbility.Left) + 155; //66;
    m := DAdjustAbility.SurfaceY(DAdjustAbility.Top) + 101;

    if g_BonusAbilChg.DC > 0 then Font.Color := clWhite
    else Font.Color := clSilver;
    TextOut(L + 0, m + 0, IntToStr(g_BonusAbilChg.DC + g_BonusAbil.DC) + '/' + IntToStr(g_BonusTick.DC));

    if g_BonusAbilChg.MC > 0 then Font.Color := clWhite
    else Font.Color := clSilver;
    TextOut(L + 0, m + 20, IntToStr(g_BonusAbilChg.MC + g_BonusAbil.MC) + '/' + IntToStr(g_BonusTick.MC));

    if g_BonusAbilChg.SC > 0 then Font.Color := clWhite
    else Font.Color := clSilver;
    TextOut(L + 0, m + 40, IntToStr(g_BonusAbilChg.SC + g_BonusAbil.SC) + '/' + IntToStr(g_BonusTick.SC));

    if g_BonusAbilChg.AC > 0 then Font.Color := clWhite
    else Font.Color := clSilver;
    TextOut(L + 0, m + 60, IntToStr(g_BonusAbilChg.AC + g_BonusAbil.AC) + '/' + IntToStr(g_BonusTick.AC));

    if g_BonusAbilChg.MAC > 0 then Font.Color := clWhite
    else Font.Color := clSilver;
    TextOut(L + 0, m + 80, IntToStr(g_BonusAbilChg.MAC + g_BonusAbil.MAC) + '/' + IntToStr(g_BonusTick.MAC));

    if g_BonusAbilChg.HP > 0 then Font.Color := clWhite
    else Font.Color := clSilver;
    TextOut(L + 0, m + 100, IntToStr(g_BonusAbilChg.HP + g_BonusAbil.HP) + '/' + IntToStr(g_BonusTick.HP));

    if g_BonusAbilChg.MP > 0 then Font.Color := clWhite
    else Font.Color := clSilver;
    TextOut(L + 0, m + 120, IntToStr(g_BonusAbilChg.MP + g_BonusAbil.MP) + '/' + IntToStr(g_BonusTick.MP));

    if g_BonusAbilChg.Hit > 0 then Font.Color := clWhite
    else Font.Color := clSilver;
    TextOut(L + 0, m + 140, IntToStr(g_BonusAbilChg.Hit + g_BonusAbil.Hit) + '/' + IntToStr(g_BonusTick.Hit));

    if g_BonusAbilChg.Speed > 0 then Font.Color := clWhite
    else Font.Color := clSilver;
    TextOut(L + 0, m + 160, IntToStr(g_BonusAbilChg.Speed + g_BonusAbil.Speed) + '/' + IntToStr(g_BonusTick.Speed));

    Release;
  end;

end;

procedure TFrmDlg.DPlusDCClick(Sender: TObject; X, Y: Integer);
var
  incp: Integer;
begin
  if g_nBonusPoint > 0 then begin
    if IsKeyPressed(VK_CONTROL) and (g_nBonusPoint > 10) then incp := 10
    else incp := 1;
    Dec(g_nBonusPoint, incp);
    if Sender = DPlusDC then Inc(g_BonusAbilChg.DC, incp);
    if Sender = DPlusMC then Inc(g_BonusAbilChg.MC, incp);
    if Sender = DPlusSC then Inc(g_BonusAbilChg.SC, incp);
    if Sender = DPlusAC then Inc(g_BonusAbilChg.AC, incp);
    if Sender = DPlusMAC then Inc(g_BonusAbilChg.MAC, incp);
    if Sender = DPlusHP then Inc(g_BonusAbilChg.HP, incp);
    if Sender = DPlusMP then Inc(g_BonusAbilChg.MP, incp);
    if Sender = DPlusHit then Inc(g_BonusAbilChg.Hit, incp);
    if Sender = DPlusSpeed then Inc(g_BonusAbilChg.Speed, incp);
  end;
end;

procedure TFrmDlg.DMinusDCClick(Sender: TObject; X, Y: Integer);
var
  decp: Integer;
begin
  if IsKeyPressed(VK_CONTROL) and (g_nBonusPoint - 10 > 0) then decp := 10
  else decp := 1;
  if Sender = DMinusDC then
    if g_BonusAbilChg.DC >= decp then begin
      Dec(g_BonusAbilChg.DC, decp);
      Inc(g_nBonusPoint, decp);
    end;
  if Sender = DMinusMC then
    if g_BonusAbilChg.MC >= decp then begin
      Dec(g_BonusAbilChg.MC, decp);
      Inc(g_nBonusPoint, decp);
    end;
  if Sender = DMinusSC then
    if g_BonusAbilChg.SC >= decp then begin
      Dec(g_BonusAbilChg.SC, decp);
      Inc(g_nBonusPoint, decp);
    end;
  if Sender = DMinusAC then
    if g_BonusAbilChg.AC >= decp then begin
      Dec(g_BonusAbilChg.AC, decp);
      Inc(g_nBonusPoint, decp);
    end;
  if Sender = DMinusMAC then
    if g_BonusAbilChg.MAC >= decp then begin
      Dec(g_BonusAbilChg.MAC, decp);
      Inc(g_nBonusPoint, decp);
    end;
  if Sender = DMinusHP then
    if g_BonusAbilChg.HP >= decp then begin
      Dec(g_BonusAbilChg.HP, decp);
      Inc(g_nBonusPoint, decp);
    end;
  if Sender = DMinusMP then
    if g_BonusAbilChg.MP >= decp then begin
      Dec(g_BonusAbilChg.MP, decp);
      Inc(g_nBonusPoint, decp);
    end;
  if Sender = DMinusHit then
    if g_BonusAbilChg.Hit >= decp then begin
      Dec(g_BonusAbilChg.Hit, decp);
      Inc(g_nBonusPoint, decp);
    end;
  if Sender = DMinusSpeed then
    if g_BonusAbilChg.Speed >= decp then begin
      Dec(g_BonusAbilChg.Speed, decp);
      Inc(g_nBonusPoint, decp);
    end;
end;

procedure TFrmDlg.DAdjustAbilOkClick(Sender: TObject; X, Y: Integer);
begin
  frmMain.SendAdjustBonus(g_nBonusPoint, g_BonusAbilChg);
  DAdjustAbility.Visible := FALSE;
end;

procedure TFrmDlg.DAdjustAbilityMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  i, lx, ly: Integer;
  flag: Boolean;
begin
  with DAdjustAbility do begin
    lx := LocalX(X - Left);
    ly := LocalY(Y - Top);
    flag := FALSE;
    if (lx >= 50) and (lx < 150) then
      for i := 0 to 8 do begin //DC,MC,SC..狼 腮飘啊 唱坷霸 茄促.
        if (ly >= 98 + i * 20) and (ly < 98 + (i + 1) * 20) then begin
          DScreen.ShowHint(SurfaceX(Left) + lx + 10,
            SurfaceY(Top) + ly + 5,
            AdjustAbilHints[i],
            clWhite,
            FALSE);
          flag := True;
          break;
        end;
      end;
    if not flag then
      DScreen.ClearHint;
  end;
end;

procedure TFrmDlg.DBotMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  nLocalX, nLocalY: Integer;
  nHintX, nHintY: Integer;
  Butt: TDButton;
  smsg: string;
begin
  DScreen.ClearHint;
  Butt := TDButton(Sender);
  if Sender = DBotMiniMap then smsg := '小地图(V)';
  if Sender = DBotTrade then smsg := '交易(T)';
  if Sender = DBotGuild then smsg := '行会(G)';
  if Sender = DBotGroup then smsg := '遍组(P)';
  if Sender = DBotPlusAbil then smsg := '属性(M)';
  //if Sender = DBotFriend then smsg := '好友(W)';
  if Sender = DBotLogout then smsg := '退出角色\Alt-X';
  if Sender = DBotExit then smsg := '退出游戏\Alt-Q';

  if Sender = DMyState then smsg := '状态(F10)';
  if Sender = DMyBag then smsg := '包裹(F9)';
  if Sender = DMyMagic then smsg := '技能(F11)';
  if Sender = DOption then smsg := '声效';
  if Sender = DButtonShop then smsg := '商铺';
  {if Sender = DButtonHP then smsg := format('HP(%d/%d)', [g_MySelf.m_Abil.HP, g_MySelf.m_Abil.MaxHP]);
  if Sender = DButtonMP then smsg := format('MP(%d/%d)', [g_MySelf.m_Abil.MP, g_MySelf.m_Abil.MaxMP]);}
 // if Sender = DButtonPlayPosition then smsg := '人物排行';
 // if Sender = DButtonSendOfSell then smsg := '装备寄售';



  nLocalX := Butt.LocalX(X - Butt.Left);
  nLocalY := Butt.LocalY(Y - Butt.Top);
  nHintX := Butt.SurfaceX(Butt.Left) + DBottom.SurfaceX(DBottom.Left) + nLocalX;
  nHintY := Butt.SurfaceY(Butt.Top) + DBottom.SurfaceY(DBottom.Top) + nLocalY;
  DScreen.ShowHint(nHintX, nHintY, smsg, clWhite{clYellow}, FALSE);
end;


procedure TFrmDlg.OpenFriendDlg();
begin

end;

procedure TFrmDlg.DChgGamePwdCloseClick(Sender: TObject; X, Y: Integer);
begin
  DChgGamePwd.Visible := FALSE;
end;

procedure TFrmDlg.DChgGamePwdDirectPaint(Sender: TObject;
  dsurface: TDirectDrawSurface);
var
  d: TDirectDrawSurface;
  lx, ly, sx: Integer;
begin
  with Sender as TDWindow do begin
    d := WLib.Images[FaceIndex];
    if d <> nil then
      dsurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, True);

    SetBkMode(dsurface.Canvas.Handle, TRANSPARENT);
    BoldTextOut(dsurface, SurfaceX(Left + 15), SurfaceY(Top + 13), clWhite, clBlack, g_sGameGoldName);

    dsurface.Canvas.Font.Style := dsurface.Canvas.Font.Style + [fsUnderline];
    BoldTextOut(dsurface, SurfaceX(Left + 12), SurfaceY(Top + 190), clYellow, clBlack, g_sGamePointName);
    dsurface.Canvas.Font.Style := dsurface.Canvas.Font.Style - [fsUnderline];
    dsurface.Canvas.Release;
  end;
end;

procedure TFrmDlg.DButtonShopDirectPaint(Sender: TObject;
  dsurface: TDirectDrawSurface);
var
  d: TDButton;
  dd: TDirectDrawSurface;
begin
  if Sender is TDButton then begin
    d := TDButton(Sender);
    if d.Downed then begin
      dd := d.WLib.Images[d.FaceIndex];
      if dd <> nil then
        dsurface.Draw(d.SurfaceX(d.Left), d.SurfaceY(d.Top), dd.ClientRect, dd, True);
    end;
  end;
end;

procedure TFrmDlg.DShopDirectPaint(Sender: TObject;
  dsurface: TDirectDrawSurface);
var
  d: TDirectDrawSurface;
  i, old, nIndex, n: Integer;
  iname, d1, d2, d3: string;
  s01, s02: string;
  useable: Boolean;
  sMemo: string;
  StringArray: array[0..9] of string[24];
begin
  with DShop do begin
    d := WLib.Images[FaceIndex];
    if d <> nil then
      dsurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, True);
  end;
  if g_MouseShopItems.StdItem.name <> '' then begin
    sMemo := StrPas(@g_MouseShopItems.sMemo2);
    if sMemo = '' then begin
      g_MouseItem.S := g_MouseShopItems.StdItem;
      g_MouseItem.DuraMax := g_MouseItem.S.DuraMax;
      g_MouseItem.Dura := g_MouseItem.S.DuraMax;
      GetMouseItemInfo(iname, d1, d2, d3, useable);
      g_MouseItem.S.name := '';
      if iname <> '' then begin
        nIndex := 0;
        FillChar(StringArray, sizeof(StringArray), #0);
        while True do begin
          if nIndex > 9 then break;
          d2 := GetValidStr3(d2, s01, [' ']);
          d2 := GetValidStr3(d2, s02, [' ']);
          if (s01 <> '') and (s02 <> '') then begin
            StringArray[nIndex] := s01 + ' ' + s02;
          end else
            if (s01 <> '') and (s02 = '') then begin
            StringArray[nIndex] := s01;
            break;
          end;
          if d2 = '' then break;
          Inc(nIndex);
        end;
        with dsurface.Canvas do begin
          SetBkMode(Handle, TRANSPARENT);
          old := Font.Size;
          Font.Color := clLime;
          TextOut(DShop.SurfaceX(DShop.Left + 20), DShop.SurfaceY(DShop.Top + DShop.Height - 150), iname);
          Font.Size := 9;
          Font.Color := clWhite;
          TextOut(DShop.SurfaceX(DShop.Left + 20), DShop.SurfaceY(DShop.Top + DShop.Height - 150 + TextHeight('A')), d1);
          n := 1;
          for nIndex := Low(StringArray) to High(StringArray) do begin
            if StringArray[nIndex] <> '' then begin
              TextOut(DShop.SurfaceX(DShop.Left + 20), DShop.SurfaceY(DShop.Top + DShop.Height - 150 + (TextHeight('A') + 2) * n + TextHeight('A')), StringArray[nIndex]);
              Inc(n);
            end;
          end;
          TextOut(DShop.SurfaceX(DShop.Left + 20), DShop.SurfaceY(DShop.Top + DShop.Height - 150 + (TextHeight('A') + 2) * n)+ TextHeight('A'), d3);
          Font.Size := old;
          Release;
        end;
      end;
    end else begin
      nIndex := 0;
      FillChar(StringArray, sizeof(StringArray), #0);
      while True do begin
        if nIndex > 9 then break;
        if (sMemo <> '') and (Pos('\', sMemo) = 0) then begin
          StringArray[nIndex] := sMemo;
          break;
        end;
        if sMemo <> '' then begin
          sMemo := GetValidStr3(sMemo, s01, ['\']);
          StringArray[nIndex] := s01;
        end else break;
        Inc(nIndex);
      end;
      with dsurface.Canvas do begin
        SetBkMode(Handle, TRANSPARENT);
        old := Font.Size;
        Font.Size := 9;
        Font.Color := clLime;
        TextOut(DShop.SurfaceX(DShop.Left + 20), DShop.SurfaceY(DShop.Top + DShop.Height - 150), g_MouseShopItems.StdItem.name);
        Font.Color := clWhite;
        n := 0;
        for nIndex := Low(StringArray) to High(StringArray) do begin
          if StringArray[nIndex] <> '' then begin
            if n = 0 then
              TextOut(DShop.SurfaceX(DShop.Left + 20), DShop.SurfaceY(DShop.Top + DShop.Height - 150+ TextHeight('A') + 2), StringArray[nIndex]);
            if n > 0 then
              TextOut(DShop.SurfaceX(DShop.Left + 20), DShop.SurfaceY(DShop.Top + DShop.Height - 150 + (TextHeight('A') + 2) * n)+ TextHeight('A'), StringArray[nIndex]);
            Inc(n);
          end;
        end;
        Font.Size := old;
        Release;
      end;
    end;
  end;
end;

procedure TFrmDlg.DButtonShopClick(Sender: TObject; X, Y: Integer);
begin
{  if DShop.Visible then begin
    DShop.Visible := FALSE;
  end else
  if GetTickCount > g_dwQueryMsgTick then begin
    g_dwQueryMsgTick := GetTickCount + 1000;
    ShopPage := 0;
   // ShopTabPage := 0;
 // frmMain.SendShopDlg(ShopPage);
  end; }

  OpenShopDlg2;
end;

 procedure TFrmDlg.OpenShopDlg2;
begin
  if DShop.Visible then begin
    DShop.Visible := FALSE;
    g_MouseShopItems.StdItem.name:='';
  end else
  if GetTickCount > g_dwQueryMsgTick then begin
    g_dwQueryMsgTick := GetTickCount + 3000;
    g_MouseShopItems.StdItem.name:='';
    ShopPage := 0;  //页码
    ShopTab := 0; //类别
    frmMain.SendShopDlg(ShopTab,ShopPage);
  end;
end;
procedure TFrmDlg.DJewelryDirectPaint(Sender: TObject;
  dsurface: TDirectDrawSurface);
var
  d: TDButton;
  dd: TDirectDrawSurface;
begin
  if Sender is TDButton then begin
    d := TDButton(Sender);

    if d.Downed then begin
      dd := d.WLib.Images[d.FaceIndex];
      if dd <> nil then
        dsurface.Draw(d.SurfaceX(d.Left), d.SurfaceY(d.Top), dd.ClientRect, dd, True);
    end;
      if ShopTab = d.Tag then  begin
      dd := d.WLib.Images[d.FaceIndex];
      dsurface.Draw(d.SurfaceX(d.Left), d.SurfaceY(d.Top), dd.ClientRect, dd, True);
     end;
  end;
end;

procedure TFrmDlg.DShopExitClick(Sender: TObject; X, Y: Integer);
begin
  DShop.Visible := FALSE;
end;

procedure TFrmDlg.DJewelryClick(Sender: TObject; X, Y: Integer);
begin
  if Sender = DJewelry then begin
  if (ShopTab <> TDButton(Sender).Tag) then begin
  ShopTab := 0;
  g_MouseShopItems.StdItem.name:='';
  frmMain.SendShopDlg(ShopTab,0);
  end;
 end;

 if Sender = DMedicine then begin
   if (ShopTab <> TDButton(Sender).Tag) then begin
    ShopTab := 1;
    g_MouseShopItems.StdItem.name:='';
    frmMain.SendShopDlg(ShopTab,0);
  end;
   end;

     if Sender = DEnhance then begin
  if (ShopTab <> TDButton(Sender).Tag) then begin
  ShopTab := 2;
  g_MouseShopItems.StdItem.name:='';
  frmMain.SendShopDlg(ShopTab,0);
  end;
  end;

    if Sender = Dfriend then begin
  if (ShopTab <> TDButton(Sender).Tag) then begin
  ShopTab := 3;
  g_MouseShopItems.StdItem.name:='';
  frmMain.SendShopDlg(ShopTab,0);
  end;
  end;

    if Sender = DLimit then begin
  if (ShopTab <> TDButton(Sender).Tag) then begin
  ShopTab := 4;
  g_MouseShopItems.StdItem.name:='';
  frmMain.SendShopDlg(ShopTab,0);
  end;
  end;

end;

procedure TFrmDlg.DBottomMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  DScreen.ClearHint;
end;

procedure TFrmDlg.OpenShopDlg;
begin
  if not DShop.Visible then
  DShop.Visible := True;
end;

procedure TFrmDlg.DShopStdItem1DirectPaint(Sender: TObject;
  dsurface: TDirectDrawSurface);
var
  idx: Integer;
  d: TDirectDrawSurface;
  tidx: Integer;
  ShopItem: TShopItem;
  hcolor:TColor;
  old:Integer;
  sMemo1,sMemo2:String;
begin
 // if (ShopTabPage >= 0) and (ShopTabPage <= 4) then begin
    if Sender = DShopStdItem1 then begin
      ShopItem := g_ShopItems[1];
      if ShopItem.StdItem.name <> '' then begin
        idx := ShopItem.StdItem.looks;
        if idx >= 0 then begin
          d := g_WBagItemImages.Images[idx];
          if d <> nil then
            dsurface.Draw(DShopStdItem1.SurfaceX(DShopStdItem1.Left + (DShopStdItem1.Width - d.Width) div 2),
              DShopStdItem1.SurfaceY(DShopStdItem1.Top + (DShopStdItem1.Height - d.Height) div 2),
              d.ClientRect, d, True);
        end;

        if CompareText(g_MouseShopItems.StdItem.name,ShopItem.StdItem.name)=0 then hcolor := clRed else hcolor := clWhite;
        //if DShopStdItem1.Downed then hcolor := clRed else hcolor := clWhite;
           with dsurface.Canvas do begin
              SetBkMode (Handle, TRANSPARENT);
              old := Font.Size;
              Font.Size := 9;
              Font.Color := clYellow;
              TextOut (DShopStdItem1.SurfaceX(DShopStdItem1.Left+DShopStdItem1.Width+10), DShopStdItem1.SurfaceY(DShopStdItem1.Top{-TextHeight('A')}), ShopItem.StdItem.name);     //2006-10-24 叶随风飘修改
              sMemo1:=StrPas(@ShopItem.sMemo1);
              if sMemo1 <> '' then begin
                Font.Color := hcolor;
                TextOut (DShopStdItem1.SurfaceX(DShopStdItem1.Left+DShopStdItem1.Width+10), DShopStdItem1.SurfaceY(DShopStdItem1.Top+TextHeight('A')), sMemo1);
              end;
              Font.Color := hcolor;
              TextOut (DShopStdItem1.SurfaceX(DShopStdItem1.Left+DShopStdItem1.Width+10), DShopStdItem1.SurfaceY(DShopStdItem1.Top+TextHeight('A')*2), IntToStr(ShopItem.StdItem.Price) + ' '+g_sGameGoldName);
              Font.Size := old;
              Release;
           end;
        end;
    end;

    if Sender = DShopStdItem2 then begin
      ShopItem := g_ShopItems[2];
      if ShopItem.StdItem.name <> '' then begin
        idx := ShopItem.StdItem.looks;
        if idx >= 0 then begin
          d := g_WBagItemImages.Images[idx];
          if d <> nil then
            dsurface.Draw(DShopStdItem2.SurfaceX(DShopStdItem2.Left + (DShopStdItem2.Width - d.Width) div 2),
              DShopStdItem2.SurfaceY(DShopStdItem2.Top + (DShopStdItem2.Height - d.Height) div 2),
              d.ClientRect, d, True);
        end;

        if CompareText(g_MouseShopItems.StdItem.name,ShopItem.StdItem.name)=0 then hcolor := clRed else hcolor := clWhite;
        //if DShopStdItem1.Downed then hcolor := clRed else hcolor := clWhite;
           with dsurface.Canvas do begin
              SetBkMode (Handle, TRANSPARENT);
              old := Font.Size;
              Font.Size := 9;
              Font.Color := clYellow;
              TextOut (DShopStdItem2.SurfaceX(DShopStdItem2.Left+DShopStdItem2.Width+10), DShopStdItem2.SurfaceY(DShopStdItem2.Top{-TextHeight('A')}), ShopItem.StdItem.name);     //2006-10-24 叶随风飘修改
              sMemo1:=StrPas(@ShopItem.sMemo1);
              if sMemo1 <> '' then begin
                Font.Color := hcolor;
                TextOut (DShopStdItem2.SurfaceX(DShopStdItem2.Left+DShopStdItem1.Width+10), DShopStdItem2.SurfaceY(DShopStdItem2.Top+TextHeight('A')), sMemo1);
              end;
              Font.Color := hcolor;
              TextOut (DShopStdItem2.SurfaceX(DShopStdItem2.Left+DShopStdItem1.Width+10), DShopStdItem2.SurfaceY(DShopStdItem2.Top+TextHeight('A')*2), IntToStr(ShopItem.StdItem.Price) + ' '+g_sGameGoldName);
              Font.Size := old;
              Release;
           end;
        end;
      end;

    if Sender = DShopStdItem3 then begin
      ShopItem := g_ShopItems[3];
      if ShopItem.StdItem.name <> '' then begin
        idx := ShopItem.StdItem.looks;
        if idx >= 0 then begin
          d := g_WBagItemImages.Images[idx];
          if d <> nil then
            dsurface.Draw(DShopStdItem3.SurfaceX(DShopStdItem3.Left + (DShopStdItem3.Width - d.Width) div 2),
              DShopStdItem3.SurfaceY(DShopStdItem3.Top + (DShopStdItem3.Height - d.Height) div 2),
              d.ClientRect, d, True);
        end;

        if CompareText(g_MouseShopItems.StdItem.name,ShopItem.StdItem.name)=0 then hcolor := clRed else hcolor := clWhite;
        //if DShopStdItem1.Downed then hcolor := clRed else hcolor := clWhite;
           with dsurface.Canvas do begin
              SetBkMode (Handle, TRANSPARENT);
              old := Font.Size;
              Font.Size := 9;
              Font.Color := clYellow;
              TextOut (DShopStdItem3.SurfaceX(DShopStdItem3.Left+DShopStdItem3.Width+10), DShopStdItem3.SurfaceY(DShopStdItem3.Top{-TextHeight('A')}), ShopItem.StdItem.name);     //2006-10-24 叶随风飘修改
              sMemo1:=StrPas(@ShopItem.sMemo1);
              if sMemo1 <> '' then begin
                Font.Color := hcolor;
                TextOut (DShopStdItem3.SurfaceX(DShopStdItem3.Left+DShopStdItem3.Width+10), DShopStdItem3.SurfaceY(DShopStdItem3.Top+TextHeight('A')), sMemo1);
              end;
              Font.Color := hcolor;
              TextOut (DShopStdItem3.SurfaceX(DShopStdItem3.Left+DShopStdItem3.Width+10), DShopStdItem3.SurfaceY(DShopStdItem3.Top+TextHeight('A')*2), IntToStr(ShopItem.StdItem.Price) + ' '+g_sGameGoldName);
              Font.Size := old;
              Release;
           end;
        end;
      end;
   // end;

    if Sender = DShopStdItem4 then begin
      ShopItem := g_ShopItems[4];
      if ShopItem.StdItem.name <> '' then begin
        idx := ShopItem.StdItem.looks;
        if idx >= 0 then begin
          d := g_WBagItemImages.Images[idx];
          if d <> nil then
            dsurface.Draw(DShopStdItem4.SurfaceX(DShopStdItem4.Left + (DShopStdItem4.Width - d.Width) div 2),
              DShopStdItem4.SurfaceY(DShopStdItem4.Top + (DShopStdItem4.Height - d.Height) div 2),
              d.ClientRect, d, True);
        end;
        if CompareText(g_MouseShopItems.StdItem.name,ShopItem.StdItem.name)=0 then hcolor := clRed else hcolor := clWhite;
        //if DShopStdItem1.Downed then hcolor := clRed else hcolor := clWhite;
           with dsurface.Canvas do begin
              SetBkMode (Handle, TRANSPARENT);
              old := Font.Size;
              Font.Size := 9;
              Font.Color := clYellow;
              TextOut (DShopStdItem4.SurfaceX(DShopStdItem4.Left+DShopStdItem4.Width+10), DShopStdItem4.SurfaceY(DShopStdItem4.Top{-TextHeight('A')}), ShopItem.StdItem.name);     //2006-10-24 叶随风飘修改
              sMemo1:=StrPas(@ShopItem.sMemo1);
              if sMemo1 <> '' then begin
                Font.Color := hcolor;
                TextOut (DShopStdItem4.SurfaceX(DShopStdItem4.Left+DShopStdItem4.Width+10), DShopStdItem4.SurfaceY(DShopStdItem4.Top+TextHeight('A')), sMemo1);
              end;
              Font.Color := hcolor;
              TextOut (DShopStdItem4.SurfaceX(DShopStdItem4.Left+DShopStdItem4.Width+10), DShopStdItem4.SurfaceY(DShopStdItem4.Top+TextHeight('A')*2), IntToStr(ShopItem.StdItem.Price) + ' '+g_sGameGoldName);
              Font.Size := old;
              Release;
           end;
        end;
    end;

    if Sender = DShopStdItem5 then begin
      ShopItem := g_ShopItems[5];
      if ShopItem.StdItem.name <> '' then begin
        idx := ShopItem.StdItem.looks;
        if idx >= 0 then begin
          d := g_WBagItemImages.Images[idx];
          if d <> nil then
            dsurface.Draw(DShopStdItem5.SurfaceX(DShopStdItem5.Left + (DShopStdItem5.Width - d.Width) div 2),
              DShopStdItem5.SurfaceY(DShopStdItem5.Top + (DShopStdItem5.Height - d.Height) div 2),
              d.ClientRect, d, True);
        end;
        if CompareText(g_MouseShopItems.StdItem.name,ShopItem.StdItem.name)=0 then hcolor := clRed else hcolor := clWhite;
        //if DShopStdItem1.Downed then hcolor := clRed else hcolor := clWhite;
           with dsurface.Canvas do begin
              SetBkMode (Handle, TRANSPARENT);
              old := Font.Size;
              Font.Size := 9;
              Font.Color := clYellow;
              TextOut (DShopStdItem5.SurfaceX(DShopStdItem5.Left+DShopStdItem5.Width+10), DShopStdItem5.SurfaceY(DShopStdItem5.Top{-TextHeight('A')}), ShopItem.StdItem.name);     //2006-10-24 叶随风飘修改
              sMemo1:=StrPas(@ShopItem.sMemo1);
              if sMemo1 <> '' then begin
                Font.Color := hcolor;
                TextOut (DShopStdItem5.SurfaceX(DShopStdItem5.Left+DShopStdItem5.Width+10), DShopStdItem5.SurfaceY(DShopStdItem5.Top+TextHeight('A')), sMemo1);
              end;
              Font.Color := hcolor;
              TextOut (DShopStdItem5.SurfaceX(DShopStdItem5.Left+DShopStdItem5.Width+10), DShopStdItem5.SurfaceY(DShopStdItem5.Top+TextHeight('A')*2), IntToStr(ShopItem.StdItem.Price) + ' '+g_sGameGoldName);
              Font.Size := old;
              Release;
           end;
      end;
    end;

    if Sender = DShopStdItem6 then begin
      ShopItem := g_ShopItems[6];
      if ShopItem.StdItem.name <> '' then begin
        idx := ShopItem.StdItem.looks;
        if idx >= 0 then begin
          d := g_WBagItemImages.Images[idx];
          if d <> nil then
            dsurface.Draw(DShopStdItem6.SurfaceX(DShopStdItem6.Left + (DShopStdItem6.Width - d.Width) div 2),
              DShopStdItem6.SurfaceY(DShopStdItem6.Top + (DShopStdItem6.Height - d.Height) div 2),
              d.ClientRect, d, True);
        end;
        if CompareText(g_MouseShopItems.StdItem.name,ShopItem.StdItem.name)=0 then hcolor := clRed else hcolor := clWhite;
        //if DShopStdItem1.Downed then hcolor := clRed else hcolor := clWhite;
           with dsurface.Canvas do begin
              SetBkMode (Handle, TRANSPARENT);
              old := Font.Size;
              Font.Size := 9;
              Font.Color := clYellow;
              TextOut (DShopStdItem6.SurfaceX(DShopStdItem6.Left+DShopStdItem6.Width+10), DShopStdItem6.SurfaceY(DShopStdItem6.Top{-TextHeight('A')}), ShopItem.StdItem.name);     //2006-10-24 叶随风飘修改
              sMemo1:=StrPas(@ShopItem.sMemo1);
              if sMemo1 <> '' then begin
                Font.Color := hcolor;
                TextOut (DShopStdItem6.SurfaceX(DShopStdItem6.Left+DShopStdItem6.Width+10), DShopStdItem6.SurfaceY(DShopStdItem6.Top+TextHeight('A')), sMemo1);
              end;
              Font.Color := hcolor;
              TextOut (DShopStdItem6.SurfaceX(DShopStdItem6.Left+DShopStdItem6.Width+10), DShopStdItem6.SurfaceY(DShopStdItem6.Top+TextHeight('A')*2), IntToStr(ShopItem.StdItem.Price) + ' '+g_sGameGoldName);
              Font.Size := old;
              Release;
           end;
      end;
    end;

    if Sender = DShopStdItem7 then begin
      ShopItem := g_ShopItems[7];
      if ShopItem.StdItem.name <> '' then begin
        idx := ShopItem.StdItem.looks;
        if idx >= 0 then begin
          d := g_WBagItemImages.Images[idx];
          if d <> nil then
            dsurface.Draw(DShopStdItem7.SurfaceX(DShopStdItem7.Left + (DShopStdItem7.Width - d.Width) div 2),
              DShopStdItem7.SurfaceY(DShopStdItem7.Top + (DShopStdItem7.Height - d.Height) div 2),
              d.ClientRect, d, True);
        end;
        if CompareText(g_MouseShopItems.StdItem.name,ShopItem.StdItem.name)=0 then hcolor := clRed else hcolor := clWhite;
        //if DShopStdItem1.Downed then hcolor := clRed else hcolor := clWhite;
           with dsurface.Canvas do begin
              SetBkMode (Handle, TRANSPARENT);
              old := Font.Size;
              Font.Size := 9;
              Font.Color := clYellow;
              TextOut (DShopStdItem7.SurfaceX(DShopStdItem7.Left+DShopStdItem7.Width+10), DShopStdItem7.SurfaceY(DShopStdItem7.Top{-TextHeight('A')}), ShopItem.StdItem.name);     //2006-10-24 叶随风飘修改
              sMemo1:=StrPas(@ShopItem.sMemo1);
              if sMemo1 <> '' then begin
                Font.Color := hcolor;
                TextOut (DShopStdItem7.SurfaceX(DShopStdItem7.Left+DShopStdItem7.Width+10), DShopStdItem7.SurfaceY(DShopStdItem7.Top+TextHeight('A')), sMemo1);
              end;
              Font.Color := hcolor;
              TextOut (DShopStdItem7.SurfaceX(DShopStdItem7.Left+DShopStdItem7.Width+10), DShopStdItem7.SurfaceY(DShopStdItem7.Top+TextHeight('A')*2), IntToStr(ShopItem.StdItem.Price) + ' '+g_sGameGoldName);
              Font.Size := old;
              Release;
           end;
      end;
    end;

    if Sender = DShopStdItem8 then begin
      ShopItem := g_ShopItems[8];
      if ShopItem.StdItem.name <> '' then begin
        idx := ShopItem.StdItem.looks;
        if idx >= 0 then begin
          d := g_WBagItemImages.Images[idx];
          if d <> nil then
            dsurface.Draw(DShopStdItem8.SurfaceX(DShopStdItem8.Left + (DShopStdItem8.Width - d.Width) div 2),
              DShopStdItem8.SurfaceY(DShopStdItem8.Top + (DShopStdItem8.Height - d.Height) div 2),
              d.ClientRect, d, True);
        end;
        if CompareText(g_MouseShopItems.StdItem.name,ShopItem.StdItem.name)=0 then hcolor := clRed else hcolor := clWhite;
        //if DShopStdItem1.Downed then hcolor := clRed else hcolor := clWhite;
           with dsurface.Canvas do begin
              SetBkMode (Handle, TRANSPARENT);
              old := Font.Size;
              Font.Size := 9;
              Font.Color := clYellow;
              TextOut (DShopStdItem8.SurfaceX(DShopStdItem8.Left+DShopStdItem8.Width+10), DShopStdItem8.SurfaceY(DShopStdItem8.Top{-TextHeight('A')}), ShopItem.StdItem.name);     //2006-10-24 叶随风飘修改
              sMemo1:=StrPas(@ShopItem.sMemo1);
              if sMemo1 <> '' then begin
                Font.Color := hcolor;
                TextOut (DShopStdItem8.SurfaceX(DShopStdItem8.Left+DShopStdItem8.Width+10), DShopStdItem8.SurfaceY(DShopStdItem8.Top+TextHeight('A')), sMemo1);
              end;
              Font.Color := hcolor;
              TextOut (DShopStdItem8.SurfaceX(DShopStdItem8.Left+DShopStdItem8.Width+10), DShopStdItem8.SurfaceY(DShopStdItem8.Top+TextHeight('A')*2), IntToStr(ShopItem.StdItem.Price) + ' '+g_sGameGoldName);
              Font.Size := old;
              Release;
           end;
      end;
    end;

    if Sender = DShopStdItem9 then begin
      ShopItem := g_ShopItems[9];
      if ShopItem.StdItem.name <> '' then begin
        idx := ShopItem.StdItem.looks;
        if idx >= 0 then begin
          d := g_WBagItemImages.Images[idx];
          if d <> nil then
            dsurface.Draw(DShopStdItem9.SurfaceX(DShopStdItem9.Left + (DShopStdItem9.Width - d.Width) div 2),
              DShopStdItem9.SurfaceY(DShopStdItem9.Top + (DShopStdItem9.Height - d.Height) div 2),
              d.ClientRect, d, True);
        end;
        if CompareText(g_MouseShopItems.StdItem.name,ShopItem.StdItem.name)=0 then hcolor := clRed else hcolor := clWhite;
        //if DShopStdItem1.Downed then hcolor := clRed else hcolor := clWhite;
           with dsurface.Canvas do begin
              SetBkMode (Handle, TRANSPARENT);
              old := Font.Size;
              Font.Size := 9;
              Font.Color := clYellow;
              TextOut (DShopStdItem9.SurfaceX(DShopStdItem9.Left+DShopStdItem9.Width+10), DShopStdItem9.SurfaceY(DShopStdItem9.Top{-TextHeight('A')}), ShopItem.StdItem.name);     //2006-10-24 叶随风飘修改
              sMemo1:=StrPas(@ShopItem.sMemo1);
              if sMemo1 <> '' then begin
                Font.Color := hcolor;
                TextOut (DShopStdItem9.SurfaceX(DShopStdItem9.Left+DShopStdItem9.Width+10), DShopStdItem9.SurfaceY(DShopStdItem9.Top+TextHeight('A')), sMemo1);
              end;
              Font.Color := hcolor;
              TextOut (DShopStdItem9.SurfaceX(DShopStdItem9.Left+DShopStdItem9.Width+10), DShopStdItem9.SurfaceY(DShopStdItem9.Top+TextHeight('A')*2), IntToStr(ShopItem.StdItem.Price) + ' '+g_sGameGoldName);
              Font.Size := old;
              Release;
           end;
      end;
    end;

    if Sender = DShopStdItem10 then begin
      ShopItem := g_ShopItems[10];
      if ShopItem.StdItem.name <> '' then begin
        idx := ShopItem.StdItem.looks;
        if idx >= 0 then begin
          d := g_WBagItemImages.Images[idx];
          if d <> nil then
            dsurface.Draw(DShopStdItem10.SurfaceX(DShopStdItem10.Left + (DShopStdItem10.Width - d.Width) div 2),
              DShopStdItem10.SurfaceY(DShopStdItem10.Top + (DShopStdItem10.Height - d.Height) div 2),
              d.ClientRect, d, True);
        end;
        if CompareText(g_MouseShopItems.StdItem.name,ShopItem.StdItem.name)=0 then hcolor := clRed else hcolor := clWhite;
        //if DShopStdItem1.Downed then hcolor := clRed else hcolor := clWhite;
           with dsurface.Canvas do begin
              SetBkMode (Handle, TRANSPARENT);
              old := Font.Size;
              Font.Size := 9;
              Font.Color := clYellow;
              TextOut (DShopStdItem10.SurfaceX(DShopStdItem10.Left+DShopStdItem10.Width+10), DShopStdItem10.SurfaceY(DShopStdItem10.Top{-TextHeight('A')}), ShopItem.StdItem.name);     //2006-10-24 叶随风飘修改
              sMemo1:=StrPas(@ShopItem.sMemo1);
              if sMemo1 <> '' then begin
                Font.Color := hcolor;
                TextOut (DShopStdItem10.SurfaceX(DShopStdItem10.Left+DShopStdItem10.Width+10), DShopStdItem10.SurfaceY(DShopStdItem10.Top+TextHeight('A')), sMemo1);
              end;
              Font.Color := hcolor;
              TextOut (DShopStdItem10.SurfaceX(DShopStdItem10.Left+DShopStdItem10.Width+10), DShopStdItem10.SurfaceY(DShopStdItem10.Top+TextHeight('A')*2), IntToStr(ShopItem.StdItem.Price) + ' '+g_sGameGoldName);
              Font.Size := old;
              Release;
           end;
      end;
    end;
end;

procedure TFrmDlg.DShopSuperStdItem1DirectPaint(Sender: TObject;
  dsurface: TDirectDrawSurface);
var
  idx, old: Integer;
  d: TDirectDrawSurface;
  tidx: Integer;
  ShopItem: TShopItem;
  hcolor:TColor;
begin
  if Sender = DShopSuperStdItem1 then begin
    ShopItem := g_SuperShopItems[1];
    if ShopItem.StdItem.name <> '' then begin
      idx := ShopItem.StdItem.looks;
      if idx >= 0 then begin
        d := g_WBagItemImages.Images[idx];
        if d <> nil then
          dsurface.Draw(DShopSuperStdItem1.SurfaceX(DShopSuperStdItem1.Left + (DShopSuperStdItem1.Width - d.Width) div 2),
            DShopSuperStdItem1.SurfaceY(DShopSuperStdItem1.Top + (DShopSuperStdItem1.Height - d.Height) div 2),
            d.ClientRect, d, True);
      end;

      if CompareText(g_MouseShopItems.StdItem.name,ShopItem.StdItem.name)=0 then hcolor := clRed else hcolor := clWhite;
      with dsurface.Canvas do begin
        SetBkMode (Handle, TRANSPARENT);
        old := Font.Size;
        Font.Size := 9;
        Font.Color := clLime;//clYellow;
        TextOut (DShopSuperStdItem1.SurfaceX(DShopSuperStdItem1.Left-40), DShopStdItem1.SurfaceY(DShopSuperStdItem1.Top + DShopSuperStdItem1.Width), ShopItem.StdItem.name);     //2006-10-24 叶随风飘修改
        Font.Color := hcolor;
        TextOut (DShopSuperStdItem1.SurfaceX(DShopSuperStdItem1.Left-40), DShopStdItem1.SurfaceY(DShopSuperStdItem1.Top + DShopSuperStdItem1.Width+TextHeight('A')), IntToStr(ShopItem.StdItem.Price) + ' '+g_sGameGoldName);
        Font.Size := old;
        Release;
      end;
    end;
  end;

  if Sender = DShopSuperStdItem2 then begin
    ShopItem := g_SuperShopItems[2];
    if ShopItem.StdItem.name <> '' then begin
      idx := ShopItem.StdItem.looks;
      if idx >= 0 then begin
        d := g_WBagItemImages.Images[idx];
        if d <> nil then
          dsurface.Draw(DShopSuperStdItem2.SurfaceX(DShopSuperStdItem2.Left + (DShopSuperStdItem2.Width - d.Width) div 2),
            DShopSuperStdItem2.SurfaceY(DShopSuperStdItem2.Top + (DShopSuperStdItem2.Height - d.Height) div 2),
            d.ClientRect, d, True);
      end;
      if CompareText(g_MouseShopItems.StdItem.name,ShopItem.StdItem.name)=0 then hcolor := clRed else hcolor := clWhite;
      with dsurface.Canvas do begin
        SetBkMode (Handle, TRANSPARENT);
        old := Font.Size;
        Font.Size := 9;
        Font.Color := clLime;//clYellow;
        TextOut (DShopSuperStdItem2.SurfaceX(DShopSuperStdItem2.Left-40), DShopStdItem2.SurfaceY(DShopSuperStdItem2.Top + DShopSuperStdItem2.Width), ShopItem.StdItem.name);     //2006-10-24 叶随风飘修改
        Font.Color := hcolor;
        TextOut (DShopSuperStdItem2.SurfaceX(DShopSuperStdItem2.Left-40), DShopStdItem2.SurfaceY(DShopSuperStdItem2.Top + DShopSuperStdItem2.Width+TextHeight('A')), IntToStr(ShopItem.StdItem.Price) + ' '+g_sGameGoldName);
        Font.Size := old;
        Release;
      end;
    end;
  end;

  if Sender = DShopSuperStdItem3 then begin
    ShopItem := g_SuperShopItems[3];
    if ShopItem.StdItem.name <> '' then begin
      idx := ShopItem.StdItem.looks;
      if idx >= 0 then begin
        d := g_WBagItemImages.Images[idx];
        if d <> nil then
          dsurface.Draw(DShopSuperStdItem3.SurfaceX(DShopSuperStdItem3.Left + (DShopSuperStdItem3.Width - d.Width) div 2),
            DShopSuperStdItem3.SurfaceY(DShopSuperStdItem3.Top + (DShopSuperStdItem3.Height - d.Height) div 2),
            d.ClientRect, d, True);
      end;
      if CompareText(g_MouseShopItems.StdItem.name,ShopItem.StdItem.name)=0 then hcolor := clRed else hcolor := clWhite;
      with dsurface.Canvas do begin
        SetBkMode (Handle, TRANSPARENT);
        old := Font.Size;
        Font.Size := 9;
        Font.Color := clLime;//clYellow;
        TextOut (DShopSuperStdItem3.SurfaceX(DShopSuperStdItem3.Left-40), DShopStdItem3.SurfaceY(DShopSuperStdItem3.Top + DShopSuperStdItem3.Width), ShopItem.StdItem.name);     //2006-10-24 叶随风飘修改
        Font.Color := hcolor;
        TextOut (DShopSuperStdItem3.SurfaceX(DShopSuperStdItem3.Left-40), DShopStdItem3.SurfaceY(DShopSuperStdItem3.Top + DShopSuperStdItem3.Width+TextHeight('A')), IntToStr(ShopItem.StdItem.Price) + ' '+g_sGameGoldName);
        Font.Size := old;
        Release;
      end;
    end;
  end;

  if Sender = DShopSuperStdItem4 then begin
    ShopItem := g_SuperShopItems[4];
    if ShopItem.StdItem.name <> '' then begin
      idx := ShopItem.StdItem.looks;
      if idx >= 0 then begin
        d := g_WBagItemImages.Images[idx];
        if d <> nil then
          dsurface.Draw(DShopSuperStdItem4.SurfaceX(DShopSuperStdItem4.Left + (DShopSuperStdItem4.Width - d.Width) div 2),
            DShopSuperStdItem4.SurfaceY(DShopSuperStdItem4.Top + (DShopSuperStdItem4.Height - d.Height) div 2),
            d.ClientRect, d, True);
      end;
      if CompareText(g_MouseShopItems.StdItem.name,ShopItem.StdItem.name)=0 then hcolor := clRed else hcolor := clWhite;
      with dsurface.Canvas do begin
        SetBkMode (Handle, TRANSPARENT);
        old := Font.Size;
        Font.Size := 9;
        Font.Color := clLime;//clYellow;
        TextOut (DShopSuperStdItem4.SurfaceX(DShopSuperStdItem4.Left-40), DShopStdItem4.SurfaceY(DShopSuperStdItem4.Top + DShopSuperStdItem4.Width), ShopItem.StdItem.name);     //2006-10-24 叶随风飘修改
        Font.Color := hcolor;
        TextOut (DShopSuperStdItem4.SurfaceX(DShopSuperStdItem4.Left-40), DShopStdItem4.SurfaceY(DShopSuperStdItem4.Top + DShopSuperStdItem4.Width+TextHeight('A')), IntToStr(ShopItem.StdItem.Price) + ' '+g_sGameGoldName);
        Font.Size := old;
        Release;
      end;
    end;
  end;

  if Sender = DShopSuperStdItem5 then begin
    ShopItem := g_SuperShopItems[5];
    if ShopItem.StdItem.name <> '' then begin
      idx := ShopItem.StdItem.looks;
      if idx >= 0 then begin
        d := g_WBagItemImages.Images[idx];
        if d <> nil then
          dsurface.Draw(DShopSuperStdItem5.SurfaceX(DShopSuperStdItem5.Left + (DShopSuperStdItem5.Width - d.Width) div 2),
            DShopSuperStdItem5.SurfaceY(DShopSuperStdItem5.Top + (DShopSuperStdItem5.Height - d.Height) div 2),
            d.ClientRect, d, True);
      end;
      if CompareText(g_MouseShopItems.StdItem.name,ShopItem.StdItem.name)=0 then hcolor := clRed else hcolor := clWhite;
      with dsurface.Canvas do begin
        SetBkMode (Handle, TRANSPARENT);
        old := Font.Size;
        Font.Size := 9;
        Font.Color := clLime;//clYellow;
        TextOut (DShopSuperStdItem5.SurfaceX(DShopSuperStdItem5.Left-40), DShopStdItem5.SurfaceY(DShopSuperStdItem5.Top + DShopSuperStdItem5.Width), ShopItem.StdItem.name);     //2006-10-24 叶随风飘修改
        Font.Color := hcolor;
        TextOut (DShopSuperStdItem5.SurfaceX(DShopSuperStdItem5.Left-40), DShopStdItem5.SurfaceY(DShopSuperStdItem5.Top + DShopSuperStdItem5.Width+TextHeight('A')), IntToStr(ShopItem.StdItem.Price) + ' '+g_sGameGoldName);
        Font.Size := old;
        Release;
      end;
    end;
  end;
end;

procedure TFrmDlg.DShopIntroduceDirectPaint(Sender: TObject;
  dsurface: TDirectDrawSurface);
var
  nIdx:Integer;
  d: TDirectDrawSurface;
begin
  nIdx:=380;
  if g_MouseShopItems.StdItem.name <> '' then begin
    d := frmMain.GetWStateImg(g_MouseShopItems.StdItem.looks);
    if d <> nil then
      dsurface.Draw(DShopIntroduce.SurfaceX(DShopIntroduce.Left + (DShopIntroduce.Width - d.Width) div 2),
      DShopIntroduce.SurfaceY(DShopIntroduce.Top + (DShopIntroduce.Height - d.Height) div 2),
      d.ClientRect, d, True);
  end;


end;

procedure TFrmDlg.DShopStdItem1Click(Sender: TObject; X, Y: Integer);
begin
 // if (ShopTabPage >= 0) and (ShopTabPage <= 4) then begin
    if Sender = DShopStdItem1 then g_MouseShopItems := g_ShopItems[1];
    if Sender = DShopStdItem2 then g_MouseShopItems := g_ShopItems[2];
    if Sender = DShopStdItem3 then g_MouseShopItems := g_ShopItems[3];
    if Sender = DShopStdItem4 then g_MouseShopItems := g_ShopItems[4];
    if Sender = DShopStdItem5 then g_MouseShopItems := g_ShopItems[5];
    if Sender = DShopStdItem6 then g_MouseShopItems := g_ShopItems[6];
    if Sender = DShopStdItem7 then g_MouseShopItems := g_ShopItems[7];
    if Sender = DShopStdItem8 then g_MouseShopItems := g_ShopItems[8];
    if Sender = DShopStdItem9 then g_MouseShopItems := g_ShopItems[9];
    if Sender = DShopStdItem10 then g_MouseShopItems := g_ShopItems[10];
 // end;
end;

procedure TFrmDlg.DPrevShopClick(Sender: TObject; X, Y: Integer);
begin
 if ShopPage > 0 then begin
  if GetTickCount > g_dwQueryMsgTick then begin
  g_dwQueryMsgTick := GetTickCount + 1000;
  Dec(ShopPage,1);
   g_MouseShopItems.StdItem.name:='';
   frmMain.SendShopDlg(ShopTab,ShopPage);
  end;
end;
end;

procedure TFrmDlg.DNextShopClick(Sender: TObject; X, Y: Integer);
begin
   if addboot then begin
    if GetTickCount > g_dwQueryMsgTick then begin
      g_dwQueryMsgTick := GetTickCount + 1000;
      inc(ShopPage,1);
      g_MouseShopItems.StdItem.name:='';
      frmMain.SendShopDlg(ShopTab,ShopPage);
  end;
  end;
end;



procedure TFrmDlg.DShopBuyClick(Sender: TObject; X, Y: Integer);
begin
  if g_MouseShopItems.StdItem.name <> '' then begin
    if mrOk = DMessageDlg('是否确实购买 '+g_MouseShopItems.StdItem.name+' ？', [mbOk, mbCancel]) then begin
      frmMain.SendBuyShopItem(g_MouseShopItems.StdItem.name,g_MouseShopItems.btItemType);
    end;
  end;
end;

procedure TFrmDlg.DButtonReCallBabyDirectPaint(Sender: TObject;
  dsurface: TDirectDrawSurface);
var
  d: TDButton;
  dd: TDirectDrawSurface;
begin
  if Sender is TDButton then begin
    d := TDButton(Sender);
    if d.Downed then begin
      dd := d.WLib.Images[d.FaceIndex];
      if dd <> nil then
        dsurface.Draw(d.SurfaceX(d.Left), d.SurfaceY(d.Top), dd.ClientRect, dd, True);
    end;
  end;
end;

procedure TFrmDlg.DShopSuperStdItem1Click(Sender: TObject; X, Y: Integer);
begin
  if Sender = DShopSuperStdItem1 then g_MouseShopItems := g_SuperShopItems[1];
  if Sender = DShopSuperStdItem2 then g_MouseShopItems := g_SuperShopItems[2];
  if Sender = DShopSuperStdItem3 then g_MouseShopItems := g_SuperShopItems[3];
  if Sender = DShopSuperStdItem4 then g_MouseShopItems := g_SuperShopItems[4];
  if Sender = DShopSuperStdItem5 then g_MouseShopItems := g_SuperShopItems[5];
end;





procedure TFrmDlg.DEdtSdoCommonHpChange(Sender: TObject);
begin
  if Sender = DEdtSdoCommonHp then begin
    if DEdtSdoCommonHp.Text = '' then Exit;
    g_nEditCommonHp := StrToInt(DEdtSdoCommonHp.Text);
  end;
  if Sender = DEdtSdoCommonHpTimer then begin
    if DEdtSdoCommonHpTimer.Text = '' then Exit;
    g_nEditCommonHpTimer := StrToInt(DEdtSdoCommonHpTimer.Text);
  end;
  if Sender = DEdtSdoCommonMp then begin
    if DEdtSdoCommonMp.Text = '' then Exit;
    g_nEditCommonMp := StrToInt(DEdtSdoCommonMp.Text);
  end;
  if Sender = DEdtSdoCommonMpTimer then begin
    if DEdtSdoCommonMpTimer.Text = '' then Exit;
    g_nEditCommonMpTimer := StrToInt(DEdtSdoCommonMpTimer.Text);
  end;
  if Sender = DEdtSdoSpecialHp then begin
    if DEdtSdoSpecialHp.Text = '' then Exit;
    g_nEditSpecialHp := StrToInt(DEdtSdoSpecialHp.Text);
  end;

  if Sender = DEdtSdoSpecialHpTimer then begin
    if DEdtSdoSpecialHpTimer.Text = '' then Exit;
    g_nEditSpecialHpTimer := StrToInt(DEdtSdoSpecialHpTimer.Text);
  end;

  if Sender = DEdtSdoRandomHp then begin
    if DEdtSdoRandomHp.Text = '' then Exit;
    g_nEditRandomHp := StrToInt(DEdtSdoRandomHp.Text);
  end;

  if Sender = DEdtSdoRandomHpTimer then begin
    if DEdtSdoRandomHpTimer.Text = '' then Exit;
    g_nEditRandomHpTimer := StrToInt(DEdtSdoRandomHpTimer.Text);
  end;

  if Sender = DEdtSdoAutoMagicTimer then begin
    if DEdtSdoAutoMagicTimer.Text = '' then Exit;
    g_nAutoMagicTime := StrToInt(DEdtSdoAutoMagicTimer.Text);
  end;

  if Sender = DEdtSdoDrunkWineDegree then begin
    if DEdtSdoDrunkWineDegree.Text = '' then Exit;
    g_btEditWine := StrToInt(DEdtSdoDrunkWineDegree.Text);
  end;

  if Sender = DEdtSdoHeroDrunkWineDegree then begin
    if DEdtSdoHeroDrunkWineDegree.Text = '' then Exit;
    g_btEditHeroWine := StrToInt(DEdtSdoHeroDrunkWineDegree.Text);
  end;

  if Sender = DEdtSdoDrunkDrugWineDegree then begin
    if DEdtSdoDrunkDrugWineDegree.Text = '' then Exit;
    g_btEditDrugWine := StrToInt(DEdtSdoDrunkDrugWineDegree.Text);
  end;

  if Sender = DEdtSdoHeroDrunkDrugWineDegree then begin
    if DEdtSdoHeroDrunkDrugWineDegree.Text = '' then Exit;
    g_btEditHeroDrugWine := StrToInt(DEdtSdoHeroDrunkDrugWineDegree.Text);
  end;
end;

procedure TFrmDlg.DWNewSdoAssistantDirectPaint(Sender: TObject;
  dsurface: TDirectDrawSurface);
var
  d: TDirectDrawSurface;
  Int: Integer;
begin
  with DWNewSdoAssistant do begin
    if WLib <> nil then begin //20080701
      d := WLib.Images[FaceIndex];
      if d <> nil then
      dsurface.Draw (SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, TRUE);
    end;

    case g_btSdoAssistantPage of
      0: begin //基本
        with dsurface.Canvas do begin
        //  {$if Version = 1}
          SetBkMode (Handle, TRANSPARENT);
         // {$IFEND}
          Font.Style := Font.Style + [fsBold];
          BoldTextOut (dsurface, SurfaceX(Left) + 30, SurfaceY(Top) + 50, clSilver, clBlack, '基本功能设置');
          BoldTextOut (dsurface, SurfaceX(Left) + 148, SurfaceY(Top) + 50, clSilver, clBlack, '物品设置');
          Font.Style := [];
          Release;
        end;
      end;
      1: begin //保护
        with dsurface.Canvas do begin
          d := g_WMain2Images.Images[228];
           if d <> nil then
              dsurface.Draw (SurfaceX(Left)+240, SurfaceY(Top) + 217, d.ClientRect, d, TRUE);
         // {$if Version = 1}
          SetBkMode (Handle, TRANSPARENT);
         // {$IFEND}
          Font.Style := Font.Style + [fsBold];
          BoldTextOut (dsurface, SurfaceX(Left) + 30, SurfaceY(Top) + 50, clSilver, clBlack, '普通药品');
          BoldTextOut (dsurface, SurfaceX(Left) + 200, SurfaceY(Top) + 50, clSilver, clBlack, '自动饮酒');
          BoldTextOut (dsurface, SurfaceX(Left) + 30, SurfaceY(Top) + 123, clSilver, clBlack, '特殊药品');
          BoldTextOut (dsurface, SurfaceX(Left) + 30, SurfaceY(Top) + 172, clSilver, clBlack, '随机保护');
          BoldTextOut (dsurface, SurfaceX(Left) + 200, SurfaceY(Top) + 172, clSilver, clBlack, '英雄保护设置');          
          Font.Style := [];
          BoldTextOut (dsurface, SurfaceX(Left) + 178, SurfaceY(Top) + 76, clSilver, clBlack, '秒');
          BoldTextOut (dsurface, SurfaceX(Left) + 178, SurfaceY(Top) + 100, clSilver, clBlack, '秒');
          BoldTextOut (dsurface, SurfaceX(Left) + 178, SurfaceY(Top) + 149, clSilver, clBlack, '秒');
          BoldTextOut (dsurface, SurfaceX(Left) + 178, SurfaceY(Top) + 196, clSilver, clBlack, '秒');
          BoldTextOut (dsurface, SurfaceX(Left) + 40, SurfaceY(Top) + 219, clSilver, clBlack, '卷轴类型');

          BoldTextOut (dsurface, SurfaceX(Left) + 210, SurfaceY(Top) + 76, clSilver, clBlack, '普通酒');
          BoldTextOut (dsurface, SurfaceX(Left) + 210, SurfaceY(Top) + 100, clSilver, clBlack, '普通酒(英雄)');
          BoldTextOut (dsurface, SurfaceX(Left) + 210, SurfaceY(Top) + 123, clSilver, clBlack, '药酒');
          BoldTextOut (dsurface, SurfaceX(Left) + 210, SurfaceY(Top) + 149, clSilver, clBlack, '药酒(英雄)');

          BoldTextOut (dsurface, SurfaceX(Left) + 340, SurfaceY(Top) + 76, clSilver, clBlack, '% 醉酒度');
          BoldTextOut (dsurface, SurfaceX(Left) + 340, SurfaceY(Top) + 100, clSilver, clBlack, '% 醉酒度');
          BoldTextOut (dsurface, SurfaceX(Left) + 340, SurfaceY(Top) + 123, clSilver, clBlack, '分钟');
          BoldTextOut (dsurface, SurfaceX(Left) + 340, SurfaceY(Top) + 149, clSilver, clBlack, '分钟');
          BoldTextOut (dsurface, SurfaceX(Left) + 240, SurfaceY(Top) + 196, clSilver, clBlack, '躲闪血量:');
          BoldTextOut (dsurface, SurfaceX(Left) + 338, SurfaceY(Top) + 196, clSilver, clBlack, 'HP');
          BoldTextOut (dsurface, SurfaceX(Left) + 262, SurfaceY(Top) + 220, clSilver, clBlack, '怪物狂化保护');
          pen.Color := $00638494;
          Brush.Color := clBlack;
                   //左                    //上                //右                       
          Rectangle(SurfaceX(Left) + 295,SurfaceY(Top) + 193,SurfaceX(Left) + 335,SurfaceY(Top) + 212);
        //  {$IF Version = 1}
          Font.Color := clWhite;
          TextOut(SurfaceX(Left) + 297, SurfaceY(Top) + 196,'0');
         // {$ELSE}
         // clFunc.TextOut(dsurface, SurfaceX(Left) + 297, SurfaceY(Top) + 196,clWhite,'0');
         // {$IFEND}
          Release;
        end;
      end;
      2: begin //技能
        with dsurface.Canvas do begin
         // {$if Version = 1}
          SetBkMode (Handle, TRANSPARENT);
          //{$IFEND}
          Font.Style := Font.Style + [fsBold];
          BoldTextOut (dsurface, SurfaceX(Left) + 30, SurfaceY(Top) + 50, clSilver, clBlack, '战士技能');
          BoldTextOut (dsurface, SurfaceX(Left) + 148, SurfaceY(Top) + 50, clSilver, clBlack, '道士技能');         //
          BoldTextOut (dsurface, SurfaceX(Left) + 30, SurfaceY(Top) + 172, clSilver, clBlack, '法师技能');
          BoldTextOut (dsurface, SurfaceX(Left) + 266, SurfaceY(Top) + 50, clSilver, clBlack, '自动练功');
          BoldTextOut (dsurface, SurfaceX(Left) + 264, SurfaceY(Top) + 96, clSilver, clBlack,  '打开自动练功后,使用');
          BoldTextOut (dsurface, SurfaceX(Left) + 264, SurfaceY(Top) + 110, clSilver, clBlack, '一次要修炼的技能,该');
          BoldTextOut (dsurface, SurfaceX(Left) + 264, SurfaceY(Top) + 124, clSilver, clBlack, '技能会按照您设定的');
          BoldTextOut (dsurface, SurfaceX(Left) + 264, SurfaceY(Top) + 138, clSilver, clBlack, '间隔时间重复使用.');
          Font.Style := [];
          BoldTextOut (dsurface, SurfaceX(Left) + 376, SurfaceY(Top) + 77, clSilver, clBlack, '秒');
          //=================================================
          pen.Color := $00638494;    //化边界线
          MoveTo(SurfaceX(Left)+260,   SurfaceY(Top)+69);
          LineTo(SurfaceX(Left)+390,   SurfaceY(Top)+69);
          LineTo(SurfaceX(Left)+390,   SurfaceY(Top)+154);
          LineTo(SurfaceX(Left)+260,   SurfaceY(Top)+154);
          LineTo(SurfaceX(Left)+260,   SurfaceY(Top)+69);
          //==================================================
          Release;
        end;
      end;
      3: begin//按键
        with dsurface.Canvas do begin
        //  {$if Version = 1}
          SetBkMode (Handle, TRANSPARENT);
         // {$IFEND}
          Font.Style := Font.Style + [fsBold];
          BoldTextOut (dsurface, SurfaceX(Left) + 28, SurfaceY(Top) + 66, clSilver, clBlack, '功能描述');
          BoldTextOut (dsurface, SurfaceX(Left) + 150, SurfaceY(Top) + 66, clSilver, clBlack, '默认快捷键');
          BoldTextOut (dsurface, SurfaceX(Left) + 280, SurfaceY(Top) + 66, clSilver, clBlack, '自定义快捷键');
          Font.Style := [];
          BoldTextOut (dsurface, SurfaceX(Left) + 28, SurfaceY(Top) + 89, clSilver, clBlack, '召唤英雄');
          BoldTextOut (dsurface, SurfaceX(Left) + 28, SurfaceY(Top) + 111, clSilver, clBlack, '英雄攻击目标');
          BoldTextOut (dsurface, SurfaceX(Left) + 28, SurfaceY(Top) + 133, clSilver, clBlack, '使用合击技');
          BoldTextOut (dsurface, SurfaceX(Left) + 28, SurfaceY(Top) + 155, clSilver, clBlack, '切换英雄状态');
          BoldTextOut (dsurface, SurfaceX(Left) + 28, SurfaceY(Top) + 177, clSilver, clBlack, '英雄守护');
          BoldTextOut (dsurface, SurfaceX(Left) + 28, SurfaceY(Top) + 199, clSilver, clBlack, '切换攻击模式');
          BoldTextOut (dsurface, SurfaceX(Left) + 28, SurfaceY(Top) + 221, clSilver, clBlack, '切换小地图');

          pen.Color := $0053424A;    //化边界线
          MoveTo(SurfaceX(Left)+26,   SurfaceY(Top)+82);
          LineTo(SurfaceX(Left)+390,   SurfaceY(Top)+82);
          //画格
          pen.Color := clGray;
          Brush.Color := clBlack;
          Rectangle(SurfaceX(Left)+115,SurfaceY(Top)+86,SurfaceX(Left)+245,SurfaceY(Top)+105);
          Rectangle(SurfaceX(Left)+115,SurfaceY(Top)+108,SurfaceX(Left)+245,SurfaceY(Top)+127);
          Rectangle(SurfaceX(Left)+115,SurfaceY(Top)+130,SurfaceX(Left)+245,SurfaceY(Top)+149);
          Rectangle(SurfaceX(Left)+115,SurfaceY(Top)+152,SurfaceX(Left)+245,SurfaceY(Top)+171);
          Rectangle(SurfaceX(Left)+115,SurfaceY(Top)+174,SurfaceX(Left)+245,SurfaceY(Top)+193);
          Rectangle(SurfaceX(Left)+115,SurfaceY(Top)+196,SurfaceX(Left)+245,SurfaceY(Top)+215);
          Rectangle(SurfaceX(Left)+115,SurfaceY(Top)+218,SurfaceX(Left)+245,SurfaceY(Top)+237);
         // {$IF Version <> 1}
          Release;
        //  {$IFEND}

          BoldTextOut (dsurface, SurfaceX(Left) + 160, SurfaceY(Top) + 112, clSilver, clBlack, 'Ctrl+W');
          BoldTextOut (dsurface, SurfaceX(Left) + 160, SurfaceY(Top) + 134, clSilver, clBlack, 'Ctrl+S');
          BoldTextOut (dsurface, SurfaceX(Left) + 160, SurfaceY(Top) + 156, clSilver, clBlack, 'Ctrl+E');
          BoldTextOut (dsurface, SurfaceX(Left) + 160, SurfaceY(Top) + 178, clSilver, clBlack, 'Ctrl+Q');
          BoldTextOut (dsurface, SurfaceX(Left) + 160, SurfaceY(Top) + 200, clSilver, clBlack, 'Ctrl+H');
          BoldTextOut (dsurface, SurfaceX(Left) + 170, SurfaceY(Top) + 222, clSilver, clBlack, 'Tab');
          Release;
        end;
      end;
      4: begin //帮助
        d := g_WMain2Images.Images[291];   //上面图
        if d <> nil then
          dsurface.StretchDraw(Rect(SurfaceX(Left + 382), SurfaceY(Top + 38), SurfaceX(Left + 382) + 16, SurfaceY(Top + 24)+219), d.ClientRect,d, TRUE);
        with dsurface.Canvas do begin
          Int := 16;
         // {$if Version = 1}
          SetBkMode (Handle, TRANSPARENT);
         // {$IFEND}
          case g_btSdoAssistantHelpPage of
            0: begin
              BoldTextOut (dsurface, SurfaceX(Left) + 25, SurfaceY(Top) + 44, clWhite, clBlack, '辅助功能说明');
              BoldTextOut (dsurface, SurfaceX(Left) + 25, SurfaceY(Top) + 44 + Int, clSilver, clBlack, '  物品显示   显示屏幕范围内地上的所有物品');
              BoldTextOut (dsurface, SurfaceX(Left) + 25, SurfaceY(Top) + 44 + Int*2, clSilver, clBlack, '  自动拣物   只要站在需要拾取的物品上即可自动拣去该物品');
              BoldTextOut (dsurface, SurfaceX(Left) + 25, SurfaceY(Top) + 44 + Int*3, clSilver, clBlack, '  显示过滤   只显示屏幕范围内地上的贵重物品');
              BoldTextOut (dsurface, SurfaceX(Left) + 25, SurfaceY(Top) + 44 + Int*4, clSilver, clBlack, '  拣取过滤   同“自动拣物”功能但只拣去贵重物品');
              BoldTextOut (dsurface, SurfaceX(Left) + 25, SurfaceY(Top) + 44 + Int*5, clSilver, clBlack, '  免Shift    勾选此功能后可以自动追杀目标');
              BoldTextOut (dsurface, SurfaceX(Left) + 25, SurfaceY(Top) + 44 + Int*6, clSilver, clBlack, '  人名显示   显示屏幕范围内所有角色的名字');
              BoldTextOut (dsurface, SurfaceX(Left) + 25, SurfaceY(Top) + 44 + Int*7, clSilver, clBlack, '  持久警告   对即将损坏的物品，在聊天框中进行提前报警');
              BoldTextOut (dsurface, SurfaceX(Left) + 25, SurfaceY(Top) + 44 + Int*9, clWhite, clBlack, '鼠标控制说明');
              BoldTextOut (dsurface, SurfaceX(Left) + 25, SurfaceY(Top) + 44 + Int*10, clSilver, clBlack, '  鼠标左键    制基本的行动：行走、攻击、拾取物品和其他东西');
              BoldTextOut (dsurface, SurfaceX(Left) + 25, SurfaceY(Top) + 44 + Int*11, clSilver, clBlack, '  鼠标右键    远处的点击能够在地图上跑动');
              Release;
            end;
            1: begin
              BoldTextOut (dsurface, SurfaceX(Left) + 25, SurfaceY(Top) + 44, clSilver, clBlack, '  Shift+左键  强行攻击指定目标');
              BoldTextOut (dsurface, SurfaceX(Left) + 25, SurfaceY(Top) + 44 + Int, clSilver, clBlack, '  Ctrl+右键   你能够看到其他玩家的信息,它的作用和F10一样 ');
              BoldTextOut (dsurface, SurfaceX(Left) + 25, SurfaceY(Top) + 44 + Int*2, clSilver, clBlack, '  Alt+左键    收集物品 ');
              BoldTextOut (dsurface, SurfaceX(Left) + 25, SurfaceY(Top) + 44 + Int*3, clSilver, clBlack, '  双击右键    双击掉落在地上的物品，你就可以捡起它');
              BoldTextOut (dsurface, SurfaceX(Left) + 25, SurfaceY(Top) + 44 + Int*4, clSilver, clBlack, '  　　　　　　双击在包裹里的物品，你将可以直接使用该物品');
              BoldTextOut (dsurface, SurfaceX(Left) + 25, SurfaceY(Top) + 44 + Int*6, clWhite, clBlack, '快捷键说明');
              BoldTextOut (dsurface, SurfaceX(Left) + 25, SurfaceY(Top) + 44 + Int*7, clSilver, clBlack, '  F1到F8   可以自设置的技能快捷键');
              BoldTextOut (dsurface, SurfaceX(Left) + 25, SurfaceY(Top) + 44 + Int*8, clSilver, clBlack, '  F9       打开/关闭包裹窗口');
              BoldTextOut (dsurface, SurfaceX(Left) + 25, SurfaceY(Top) + 44 + Int*9, clSilver, clBlack, '  F10      打开/关闭角色窗口');
              BoldTextOut (dsurface, SurfaceX(Left) + 25, SurfaceY(Top) + 44 + Int*10, clSilver, clBlack, '  F11      打开/关闭角色技能窗口');
              BoldTextOut (dsurface, SurfaceX(Left) + 25, SurfaceY(Top) + 44 + Int*11, clSilver, clBlack, '  F12      打开/关闭辅助功能窗口');
              Release;
            end;
            2: begin
              BoldTextOut (dsurface, SurfaceX(Left) + 25, SurfaceY(Top) + 44, clSilver, clBlack, '  Alt+X    返回到角色选择界面');
              BoldTextOut (dsurface, SurfaceX(Left) + 25, SurfaceY(Top) + 44 + Int, clSilver, clBlack, '  Alt+Q    直接退出游戏');
              BoldTextOut (dsurface, SurfaceX(Left) + 25, SurfaceY(Top) + 44 + Int*2, clSilver, clBlack, '  Pause    在游戏中截图保存在游戏\Images目录下面 ');
              BoldTextOut (dsurface, SurfaceX(Left) + 25, SurfaceY(Top) + 44 + Int*3, clSilver, clBlack, '  Ctrl+B   打开/关闭商铺窗口');
              BoldTextOut (dsurface, SurfaceX(Left) + 25, SurfaceY(Top) + 44 + Int*4, clSilver, clBlack, '  Ctrl+H   选择自己喜欢的攻击模式：');
              BoldTextOut (dsurface, SurfaceX(Left) + 25, SurfaceY(Top) + 44 + Int*5, clSilver, clBlack, '  　和平攻击模式 - 对任何玩家攻击都无效');
              BoldTextOut (dsurface, SurfaceX(Left) + 25, SurfaceY(Top) + 44 + Int*6, clSilver, clBlack, '  　行会攻击模式 - 对自己行会内的其他玩家攻击无效');
              BoldTextOut (dsurface, SurfaceX(Left) + 25, SurfaceY(Top) + 44 + Int*7, clSilver, clBlack, '  　编组攻击模式 - 处于同一小组的玩家攻击无效');
              BoldTextOut (dsurface, SurfaceX(Left) + 25, SurfaceY(Top) + 44 + Int*8, clSilver, clBlack, '  　全体攻击模式 - 对所有的玩家都具有攻击效果');
              BoldTextOut (dsurface, SurfaceX(Left) + 25, SurfaceY(Top) + 44 + Int*9, clSilver, clBlack, '  　善恶攻击模式 - PK红名专用攻击模式');
              BoldTextOut (dsurface, SurfaceX(Left) + 25, SurfaceY(Top) + 44 + Int*11, clWhite, clBlack, '特殊命令说明');
              Release;
            end;
            3: begin
              BoldTextOut (dsurface, SurfaceX(Left) + 25, SurfaceY(Top) + 44, clSilver, clBlack, '  /玩家名字     私聊');
              BoldTextOut (dsurface, SurfaceX(Left) + 25, SurfaceY(Top) + 44 + Int, clSilver, clBlack, '  !交流文字     喊话');
              BoldTextOut (dsurface, SurfaceX(Left) + 25, SurfaceY(Top) + 44 + Int*2, clSilver, clBlack, '  !!文字        组队聊天');
              BoldTextOut (dsurface, SurfaceX(Left) + 25, SurfaceY(Top) + 44 + Int*3, clSilver, clBlack, '  !~文字        行会聊天');
              BoldTextOut (dsurface, SurfaceX(Left) + 25, SurfaceY(Top) + 44 + Int*4, clSilver, clBlack, '  上下方向键    查看过去的聊天信息');
              BoldTextOut (dsurface, SurfaceX(Left) + 25, SurfaceY(Top) + 44 + Int*6, clSilver, clBlack, '  @拒绝私聊     拒绝所有的私人聊天的命令 ');
              BoldTextOut (dsurface, SurfaceX(Left) + 25, SurfaceY(Top) + 44 + Int*7, clSilver, clBlack, '  @拒绝+人名    对特定的某一个人聊天文字进行屏蔽 ');
              BoldTextOut (dsurface, SurfaceX(Left) + 25, SurfaceY(Top) + 44 + Int*8, clSilver, clBlack, '  @拒绝行会聊天 屏蔽行会聊天所有消息的命令 ');
              BoldTextOut (dsurface, SurfaceX(Left) + 25, SurfaceY(Top) + 44 + Int*9, clSilver, clBlack, '  @退出门派     脱离行会 ');
              BoldTextOut (dsurface, SurfaceX(Left) + 25, SurfaceY(Top) + 44 + Int*11, clWhite, clBlack, '黑名单说明');
              Release;
            end;
            4: begin
              BoldTextOut (dsurface, SurfaceX(Left) + 25, SurfaceY(Top) + 44, clSilver, clBlack, '  鼠标点中指定角色同时按ALT+S即可将该玩家加入黑名单，再次使');
              BoldTextOut (dsurface, SurfaceX(Left) + 25, SurfaceY(Top) + 44 + Int, clSilver, clBlack, '  用鼠标点中指定角色同时ALT+S即可将该玩家移出黑名单，玩家加');
              BoldTextOut (dsurface, SurfaceX(Left) + 25, SurfaceY(Top) + 44 + Int*2, clSilver, clBlack, '  入黑名单后，您将屏蔽该玩家的喊话');
              BoldTextOut (dsurface, SurfaceX(Left) + 25, SurfaceY(Top) + 44 + Int*4, clSilver, clBlack, '  使用指令 @加入黑名单+空格+玩家名，也可将玩家加入黑名单');
              BoldTextOut (dsurface, SurfaceX(Left) + 25, SurfaceY(Top) + 44 + Int*5, clSilver, clBlack, '  再次输入 @清除黑名单+空格+玩家名，可将该玩家移出黑名单');
              BoldTextOut (dsurface, SurfaceX(Left) + 25, SurfaceY(Top) + 44 + Int*7, clWhite, clBlack, '快速编组说明');
              BoldTextOut (dsurface, SurfaceX(Left) + 25, SurfaceY(Top) + 44 + Int*8, clSilver, clBlack, '  鼠标点中要组队的角色同时按ALT+W即可自动和该角色组队，再次');
              BoldTextOut (dsurface, SurfaceX(Left) + 25, SurfaceY(Top) + 44 + Int*9, clSilver, clBlack, '  按ALT+E即可自动把该角色从队伍中删除');
              BoldTextOut (dsurface, SurfaceX(Left) + 25, SurfaceY(Top) + 44 + Int*11, clWhite, clBlack, '英雄操作快捷键');
              Release;
            end;
            5: begin
              BoldTextOut (dsurface, SurfaceX(Left) + 25, SurfaceY(Top) + 44, clSilver, clBlack, '  Ctrl+E  切换英雄三中状态：跟随、休息、战斗 ');
              BoldTextOut (dsurface, SurfaceX(Left) + 25, SurfaceY(Top) + 44 + Int, clSilver, clBlack, '  Ctrl+Q  启动/关闭英雄“守护”状态');
              BoldTextOut (dsurface, SurfaceX(Left) + 25, SurfaceY(Top) + 44 + Int*2, clSilver, clBlack, '  Ctrl+W  指定英雄攻击鼠标点中的目标');
              BoldTextOut (dsurface, SurfaceX(Left) + 25, SurfaceY(Top) + 44 + Int*3, clSilver, clBlack, '  Ctrl+S  释放合击技能');
              Release;
            end;
          end;
        end;
      end;
    end;
  end;
end;

 procedure TFrmDlg.NewSdoAssistantPageChanged;
begin
  //基本
  DCheckSdoNameShow.Visible := False;
  DCheckSdoDuraWarning.Visible := False;
  DCheckSdoAvoidShift.Visible := False;
  DCheckSdoItemsHint.Visible := False;
  DCheckSdoShowFiltrate.Visible := False;
  DCheckSdoAutoPickItems.Visible := False;
  DCheckSdoPickFiltrate.Visible := False;
  DCheckSdoExpFiltrate.Visible := False;
  //保护
  DCheckSdoCommonHp.Visible := False;
  DEdtSdoCommonHp.Visible := False;
  DEdtSdoCommonHpTimer.Visible := False;
  DCheckSdoCommonMp.Visible := False;
  DEdtSdoCommonMp.Visible := False;
  DEdtSdoCommonMpTimer.Visible := False;
  DCheckSdoSpecialHp.Visible := False;
  DEdtSdoSpecialHp.Visible := False;
  DEdtSdoSpecialHpTimer.Visible := False;
  DCheckSdoRandomHp.Visible := False;
  DEdtSdoRandomHp.Visible := False;
  DEdtSdoRandomHpTimer.Visible := False;
  DBtnSdoRandomName.Visible := False;
  DCheckSdoAutoDrinkWine.Visible := False;
  DEdtSdoDrunkWineDegree.Visible := False;
  DCheckSdoHeroAutoDrinkWine.Visible := False;
  DEdtSdoHeroDrunkWineDegree.Visible := False;
  DCheckSdoAutoDrinkDrugWine.Visible := False;
  DEdtSdoDrunkDrugWineDegree.Visible := False;
  DCheckSdoHeroAutoDrinkDrugWine.Visible := False;
  DEdtSdoHeroDrunkDrugWineDegree.Visible := False;
  //技能
  DCheckSdoLongHit.Visible := False;
  DCheckSdoAutoWideHit.Visible := False;
  DCheckSdoAutoFireHit.Visible := False;
  DCheckSdoZhuri.Visible := False;
  DCheckSdoAutoShield.Visible := False;
  DCheckSdoHeroShield.Visible := False;
  DCheckSdoAutoHide.Visible := False;
  DCheckSdoAutoMagic.Visible := False;
  DEdtSdoAutoMagicTimer.Visible := False;
  //按键页里
  DCheckSdoStartKey.Visible := False;
  DBtnSdoCallHeroKey.Visible := False;
  DBtnSdoHeroAttackTargetKey.Visible := False;
  DBtnSdoHeroGotethKey.Visible := False;
  DBtnSdoHeroStateKey.Visible := False;
  DBtnSdoHeroGuardKey.Visible := False;
  DBtnSdoAttackModeKey.Visible := False;
  DBtnSdoMinMapKey.Visible := False;
  //帮助
  DSdoHelpUp.Visible := False;
  DSdoHelpNext.Visible := False;
  case g_btSdoAssistantPage of
    0: begin //基本
      DCheckSdoNameShow.Visible := True;
      DCheckSdoDuraWarning.Visible := True;
      DCheckSdoAvoidShift.Visible := True;
      DCheckSdoItemsHint.Visible := True;
      DCheckSdoShowFiltrate.Visible := True;
      DCheckSdoAutoPickItems.Visible := True;
      DCheckSdoPickFiltrate.Visible := True;
      DCheckSdoExpFiltrate.Visible := True;
    end;
    1: begin //保护
      DCheckSdoCommonHp.Visible := True;
      DEdtSdoCommonHp.Visible := True;
      DEdtSdoCommonHpTimer.Visible := True;
      DCheckSdoCommonMp.Visible := True;
      DEdtSdoCommonMp.Visible := True;
      DEdtSdoCommonMpTimer.Visible := True;
      DCheckSdoSpecialHp.Visible := True;
      DEdtSdoSpecialHp.Visible := True;
      DEdtSdoSpecialHpTimer.Visible := True;
      DCheckSdoRandomHp.Visible := True;
      DEdtSdoRandomHp.Visible := True;
      DEdtSdoRandomHpTimer.Visible := True;
      DBtnSdoRandomName.Visible := True;
      DCheckSdoAutoDrinkWine.Visible := True;
      DEdtSdoDrunkWineDegree.Visible := True;
      DCheckSdoHeroAutoDrinkWine.Visible := True;
      DEdtSdoHeroDrunkWineDegree.Visible := True;
      DCheckSdoAutoDrinkDrugWine.Visible := True;
      DEdtSdoDrunkDrugWineDegree.Visible := True;
      DCheckSdoHeroAutoDrinkDrugWine.Visible := True;
      DEdtSdoHeroDrunkDrugWineDegree.Visible := True;
    end;
    2: begin //技能
      DCheckSdoLongHit.Visible := True;
      DCheckSdoAutoWideHit.Visible := True;
      DCheckSdoAutoFireHit.Visible := True;
      DCheckSdoZhuri.Visible := True;
      DCheckSdoAutoShield.Visible := True;
      DCheckSdoHeroShield.Visible := True;
      DCheckSdoAutoHide.Visible := True;
      DCheckSdoAutoMagic.Visible := True;
      DEdtSdoAutoMagicTimer.Visible := True;
    end;
    3: begin//按键
      DCheckSdoStartKey.Visible := True;
      DBtnSdoCallHeroKey.Visible := True;
      DBtnSdoHeroAttackTargetKey.Visible := True;
      DBtnSdoHeroGotethKey.Visible := True;
      DBtnSdoHeroStateKey.Visible := True;
      DBtnSdoHeroGuardKey.Visible := True;
      DBtnSdoAttackModeKey.Visible := True;
      DBtnSdoMinMapKey.Visible := True;
    end;
    4: begin//帮助
      DSdoHelpUp.Visible := True;
      DSdoHelpNext.Visible := True;
    end;
  end;
end;



procedure TFrmDlg.DWNewSdoAssistantMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  DScreen.ClearHint;
end;

procedure TFrmDlg.DNewSdoBasicClick(Sender: TObject; X, Y: Integer);
begin
  g_btSdoAssistantPage := TDButton(Sender).Tag;
  NewSdoAssistantPageChanged();
end;

procedure TFrmDlg.DNewSdoBasicDirectPaint(Sender: TObject;
  dsurface: TDirectDrawSurface);

var
  d: TDirectDrawSurface;
begin
   with Sender as TDButton do begin
      if TDButton(Sender).Tag <> g_btSdoAssistantPage then begin
        if WLib <> nil then begin //20080701
         d := WLib.Images[FaceIndex];
         if d <> nil then
            dsurface.Draw (SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, TRUE);
        end;
        with dsurface.Canvas do begin
        //  {$if Version = 1}
          SetBkMode (Handle, TRANSPARENT);
        //  {$IFEND}
          BoldTextOut (dsurface, SurfaceX(Left) + 24 - FrmMain.Canvas.TextWidth(TDButton(Sender).Hint) div 2, SurfaceY(Top) + 4, clWhite, clBlack, TDButton(Sender).Hint);
          Release;
        end;
      end else begin
        if WLib <> nil then begin //20080701
         d := WLib.Images[FaceIndex + 1];
         if d <> nil then
            dsurface.Draw (SurfaceX(Left), SurfaceY(Top) - 2, d.ClientRect, d, TRUE);
        end;
        with dsurface.Canvas do begin
         // {$if Version = 1}
          SetBkMode (Handle, TRANSPARENT);
        //  {$IFEND}
          BoldTextOut (dsurface, SurfaceX(Left) + 24 - FrmMain.Canvas.TextWidth(TDButton(Sender).Hint) div 2, SurfaceY(Top) + 2, clWhite, clBlack, TDButton(Sender).Hint);
          Release;
        end;
      end;
   end;
end;

procedure TFrmDlg.DCheckSdoNameShowClick(Sender: TObject; X, Y: Integer);
begin
  if Sender = DCheckSdoNameShow then begin
    g_boShowName := DCheckSdoNameShow.Checked
  end;

  if Sender = DCheckSdoDuraWarning then begin
    g_boDuraWarning := DCheckSdoDuraWarning.Checked;
  end;
  if Sender = DCheckSdoAvoidShift then begin
    g_boNoShift := DCheckSdoAvoidShift.Checked;
  end;

  if Sender = DCheckSdoItemsHint then begin
    g_boShowAllItem := DCheckSdoItemsHint.Checked;
  end;

  if Sender = DCheckSdoShowFiltrate then begin
    g_boFilterAutoItemShow := DCheckSdoShowFiltrate.Checked;
  end;

  if Sender = DCheckSdoAutoPickItems then begin
      g_boAutoPuckUpItem := DCheckSdoAutoPickItems.Checked;
  end;

  if Sender = DCheckSdoPickFiltrate then begin
    g_boFilterAutoItemUp := DCheckSdoPickFiltrate.Checked;
  end;
  //自动练功DCheckSdoAutoMagic
  if Sender = DCheckSdoAutoMagic then begin
    g_boAutoMagic := DCheckSdoAutoMagic.Checked;
  end;
  //经验显示过滤
  if Sender = DCheckSdoExpFiltrate then begin
    g_boExpFiltrate := DCheckSdoExpFiltrate.Checked;
  end;
end;

procedure TFrmDlg.DCheckSdoNameShowDirectPaint(Sender: TObject;
  dsurface: TDirectDrawSurface);
var
   d: TDirectDrawSurface;
begin
  with Sender as TDCheckBox do begin
    if not TDCheckBox(Sender).Checked then begin
     d := g_WMain2Images.Images[228];
     if d <> nil then
        dsurface.Draw (SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, TRUE);
    end else begin
     d := g_WMain2Images.Images[229];
     if d <> nil then
        dsurface.Draw (SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, TRUE);
    end;
    if TDCheckBox(Sender).Moveed then Color := clWhite else Color := clSilver;
    with dsurface.Canvas do begin
    // {$if Version = 1}
      SetBkMode (Handle, TRANSPARENT);
    //  {$IFEND}
      if d <> nil then
      BoldTextOut (dsurface, SurfaceX(Left + d.Width + 2), SurfaceY(Top) + 3, Color, clBlack, TDCheckBox(Sender).Hint);
      Release;
    end;
  end;
end;

procedure TFrmDlg.DCheckSdoNameShowMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  Butt:TDCheckBox;
  sMsg:String;
begin
  if g_MySelf = nil then Exit;
  Butt:=TDCheckBox(Sender);
  if Sender = DCheckSdoNameShow then sMsg := '选中此项将全屏显示玩家名字';
  if Sender = DCheckSdoDuraWarning then sMsg := '选中此项将在装备低持久时\进行提示';
  if Sender = DCheckSdoAvoidShift then sMsg := '选中此项将不需要按下SHIFT\键也能攻击其他玩家';
  if Sender = DCheckSdoExpFiltrate then sMsg := '选中此项将隐藏聊天框中低\于2000的经验值增长提示';
  if Sender = DCheckSdoItemsHint then sMsg := '选中此项将显示地面掉落物\品的名字';
  if Sender = DCheckSdoShowFiltrate then sMsg := '选中此项将过滤普通的掉落\物品名字';
  if Sender = DCheckSdoAutoPickItems then sMsg := '选中此项将自动拣取地面掉\落的物品';
  if Sender = DCheckSdoPickFiltrate then sMsg := '选中此项将自动过滤普通掉\落物品的拣取';

  with Butt as TDCheckBox do
    DScreen.ShowHint(Butt.SurfaceX(Butt.Left), Butt.SurfaceY(Butt.Top + Butt.Height), sMsg, clYellow, FALSE);
end;


procedure TFrmDlg.DCheckSdoCommonHpClick(Sender: TObject; X, Y: Integer);
begin
 if Sender = DCheckSdoCommonHp then begin
    g_boCommonHp := DCheckSdoCommonHp.Checked;
  end;
  if Sender = DCheckSdoCommonMp then begin
    g_boCommonMp := DCheckSdoCommonMp.Checked;
  end;
  if Sender = DCheckSdoSpecialHp then begin
    g_boSpecialHp := DCheckSdoSpecialHp.Checked;
  end;
  if Sender = DCheckSdoRandomHp then begin
    g_boRandomHp := DCheckSdoRandomHp.Checked;
  end;
  if Sender = DCheckSdoStartKey then begin
   if not DCheckSdoStartKey.Checked then begin
    
   end;
  end;
  //未开通的功能
  if Sender = DCheckSdoAutoDrinkWine then begin
    g_boAutoEatWine := DCheckSdoAutoDrinkWine.Checked;
  end;
  if Sender = DCheckSdoHeroAutoDrinkWine then begin
    g_boAutoEatHeroWine := DCheckSdoHeroAutoDrinkWine.Checked;
  end;
  if Sender = DCheckSdoAutoDrinkDrugWine then begin
    g_boAutoEatDrugWine := DCheckSdoAutoDrinkDrugWine.Checked;
  end;
  if Sender = DCheckSdoHeroAutoDrinkDrugWine then begin
    g_boAutoEatHeroDrugWine := DCheckSdoHeroAutoDrinkDrugWine.Checked;
  end;
end;

procedure TFrmDlg.DEdtSdoCommonHpDirectPaint(Sender: TObject;
  dsurface: TDirectDrawSurface);
begin
 with Sender as TDEdit do begin
    with dsurface.Canvas do begin
        //=================================================
        if TDEdit(Sender).Moveed then
        pen.Color := $00387B9C    //画边界线
        else
        pen.Color := $00638494;    //画边界线
        if TDEdit(Sender).Focused then pen.Color := $005993BD;
        MoveTo(SurfaceX(Left),   SurfaceY(Top));
        LineTo(SurfaceX(Left)+Width,   SurfaceY(Top));
        LineTo(SurfaceX(Left)+Width,   SurfaceY(Top)+Height);
        LineTo(SurfaceX(Left),   SurfaceY(Top)+Height);
        LineTo(SurfaceX(Left),   SurfaceY(Top));
        //==================================================
      Release;
    end;
  end;
end;

procedure TFrmDlg.DEdtSdoCommonHpKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = 123 then begin
    frmMain.OpenSdoAssistant();
  end;
end;

procedure TFrmDlg.DEdtSdoCommonHpKeyPress(Sender: TObject; var Key: Char);
begin
  if not (Key in ['0'..'9', #8, #13]) then Key := #0;
end;

procedure TFrmDlg.DNewSdoAssistantCloseClick(Sender: TObject; X,
  Y: Integer);
begin
FrmMain.OpenSdoAssistant;
end;

procedure TFrmDlg.DEdtSdoAutoMagicTimerDirectPaint(Sender: TObject;
  dsurface: TDirectDrawSurface);
begin
 with Sender as TDEdit do begin
    with dsurface.Canvas do begin
        //=================================================
        if TDEdit(Sender).Moveed then
        pen.Color := $00387B9C    //画边界线
        else
        pen.Color := $00638494;    //画边界线
        if TDEdit(Sender).Focused then pen.Color := $005993BD;
        MoveTo(SurfaceX(Left),   SurfaceY(Top));
        LineTo(SurfaceX(Left)+Width,   SurfaceY(Top));
        LineTo(SurfaceX(Left)+Width,   SurfaceY(Top)+Height);
        LineTo(SurfaceX(Left),   SurfaceY(Top)+Height);
        LineTo(SurfaceX(Left),   SurfaceY(Top));
        //==================================================
      Release;
    end;
  end;
end;

procedure TFrmDlg.DEdtSdoCommonHpTimerKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key = 123 then begin
    frmMain.OpenSdoAssistant();
  end;
end;

procedure TFrmDlg.DBtnSdoRandomNameClick(Sender: TObject; X, Y: Integer);
begin
  if g_nRandomType >= 6 then
  g_nRandomType:=0 else Inc(g_nRandomType);
end;

procedure TFrmDlg.DBtnSdoRandomNameDirectPaint(Sender: TObject;
  dsurface: TDirectDrawSurface);
var
   FontColor: Tcolor;
begin
  with Sender as TDButton do begin
    if TDButton(Sender).Moveed then begin
      Color := $00387B9C;
      FontColor := clYellow;
    end else begin
      Color := $00498394;
      FontColor := clWhite;
    end;

    with dsurface.Canvas do begin
      pen.Color := Color;
      Brush.Color := clBlack;
               //左                               //上                            //右
      Rectangle(SurfaceX(Left),SurfaceY(Top),SurfaceX(Left)+TDButton(Sender).Width,SurfaceY(Top)+TDButton(Sender).Height);
      Brush.Color := Color;
      if TDButton(Sender).Downed then
        Polygon([Point(SurfaceX(Left)+73+3,   SurfaceY(Top)+12),   Point(SurfaceX(Left)+73,   SurfaceY(Top)+9),   Point(SurfaceX(Left)+73+6,   SurfaceY(Top)+9)])   //画三角形
      else
        Polygon([Point(SurfaceX(Left)+73+3,   SurfaceY(Top)+11),   Point(SurfaceX(Left)+73,   SurfaceY(Top)+8),   Point(SurfaceX(Left)+73+6,   SurfaceY(Top)+8)]);   //画三角形
      Release;
     // {$if Version = 1}
      SetBkMode (Handle, TRANSPARENT);
    //  {$IFEND}
      case g_nRandomType of
        0: begin
          BoldTextOut (dsurface, SurfaceX(Left) + 2, SurfaceY(Top) + 4, FontColor, clBlack, '回城卷');
          g_sRandomName := '回城卷';
        end;
        1: begin
          BoldTextOut (dsurface, SurfaceX(Left) + 2, SurfaceY(Top) + 4, FontColor, clBlack, '行会回城卷');
          g_sRandomName := '行会回城卷';
        end;
        2:begin
          BoldTextOut (dsurface, SurfaceX(Left) + 2, SurfaceY(Top) + 4, FontColor, clBlack, '盟重传送石');
          g_sRandomName := '盟重传送石';
        end;
        3:begin
          BoldTextOut (dsurface, SurfaceX(Left) + 2, SurfaceY(Top) + 4, FontColor, clBlack, '比奇传送石');
          g_sRandomName := '比奇传送石';
        end;
        4:begin
          BoldTextOut (dsurface, SurfaceX(Left) + 2, SurfaceY(Top) + 4, FontColor, clBlack, '随机传送石');
          g_sRandomName := '随机传送石';
        end;
        5:begin
          BoldTextOut (dsurface, SurfaceX(Left) + 2, SurfaceY(Top) + 4, FontColor, clBlack, '随机传送卷');
          g_sRandomName := '随机传送卷';
        end;
        6:begin
          BoldTextOut (dsurface, SurfaceX(Left) + 2, SurfaceY(Top) + 4, FontColor, clBlack, '地牢逃脱卷');
          g_sRandomName := '地牢逃脱卷';
        end;
      end;
      Release;
    end;
  end;
end;

procedure TFrmDlg.DCheckSdoLongHitClick(Sender: TObject; X, Y: Integer);
begin
if Sender = DCheckSdoLongHit then begin
    if not FrmMain.GetMagicByID(12) then begin //刺杀
      // DCheckSdoLongHit.Checked := False;
       g_boLongHit := False;
       Exit;
    end;
   // g_boCanLongHit := DCheckSdoLongHit.Checked; //20080802修正内挂自动刺杀问题
    g_boLongHit := DCheckSdoLongHit.Checked;
  end;

  if Sender = DCheckSdoAutoWideHit then begin
    if not FrmMain.GetMagicByID(25) then begin //半月
      // DCheckSdoAutoWideHit.Checked := False;
       g_boAutoWideHit := False;
       Exit;
    end;
    //g_boCanWideHit := DCheckSdoAutoWideHit.Checked; //20080802 修正内挂自动半月问题
    g_boAutoWideHit := DCheckSdoAutoWideHit.Checked;
  end;

  if Sender = DCheckSdoAutoFireHit then begin
    if not FrmMain.GetMagicByID(26) then begin //烈火
       //DCheckSdoAutoFireHit.Checked := False;
       g_boAutoFireHit := False;
       Exit;
    end;
    g_boAutoFireHit := DCheckSdoAutoFireHit.Checked;
  end;

  if Sender = DCheckSdoZhuri then begin
    if not FrmMain.GetMagicByID(74) then begin //逐日
     //  DCheckSdoZhuri.Checked := False;
       g_boAutoZhuRiHit := False;
       Exit;
    end;
    g_boAutoZhuRiHit := DCheckSdoZhuri.Checked;
  end;

  if Sender = DCheckSdoAutoShield then begin
    if FrmMain.GetMagicByID(31) or FrmMain.GetMagicByID(66){4级魔法盾} then begin //自动开盾
       g_boAutoShield := DCheckSdoAutoShield.Checked;
    end else begin
      // DCheckSdoAutoShield.Checked := False;
       g_boAutoShield := False;
       Exit;
    end;
  end;

  if Sender = DCheckSdoAutoHide then begin
    if not FrmMain.GetMagicByID(18) then begin //自动隐身
     //  DCheckSdoAutoHide.Checked := False;
       g_boAutoHide := False;
       Exit;
    end;
    g_boAutoHide := DCheckSdoAutoHide.Checked;
  end;


end;

procedure TFrmDlg.DBtnSdoCallHeroKeyDirectPaint(Sender: TObject;
  dsurface: TDirectDrawSurface);
var
   TextColor: TColor;
begin
  with Sender as TDButton do begin
    if TDButton(Sender).Moveed then begin
      Color := $005993BD;
      TextColor := clYellow;
    end else begin
      Color := $00638494;
      TextColor := clWhite;
    end;
    with dsurface.Canvas do begin
      pen.Color := Color;
      if TDButton(Sender).Focused then begin
        pen.Color := $005993BD;
        pen.Width := 2;
        TextColor := clAqua; 
      end;
      Brush.Color := clBlack;
               //左                               //上                            //右
      Rectangle(SurfaceX(Left),SurfaceY(Top),SurfaceX(Left)+TDButton(Sender).Width,SurfaceY(Top)+TDButton(Sender).Height);
      pen.Width := 1;
     // {$if Version = 1}
      SetBkMode (Handle, TRANSPARENT);
     // {$ELSE}
      Release;
     // {$IFEND}
      BoldTextOut (dsurface, SurfaceX(Left) + 64-FrmMain.Canvas.TextWidth(TDButton(Sender).Hint) div 2, SurfaceY(Top) + 4, TextColor, clBlack, TDButton(Sender).Hint);
      Release;
    end;
  end;
end;

procedure TFrmDlg.DBtnSdoCallHeroKeyKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  CombinationKey: Integer;
begin
  if Key in [DBtnSdoCallHeroKey.Tag,DBtnSdoHeroAttackTargetKey.Tag,DBtnSdoHeroGotethKey.Tag,DBtnSdoHeroStateKey.Tag,DBtnSdoHeroGuardKey.Tag,DBtnSdoAttackModeKey.Tag,DBtnSdoMinMapKey.Tag] then begin
    Exit;
  end;
  if key in [0..7,9..11,12,14..15,21..32,41..45,47..92,94..123,144..145,186..192,219..222,226] then begin
    TDButton(Sender).Hint:='';
    CombinationKey:=0;
    if ssCtrl in Shift then
      TDButton(Sender).Hint := 'Ctrl+';
    if ssShift in Shift then
      TDButton(Sender).Hint := TDButton(Sender).Hint+'Shift+';
    if ssAlt in Shift then
      TDButton(Sender).Hint := TDButton(Sender).Hint+'Alt+';
    case Key of
     0..7,9..11,14..15,21..26,28..32,41..44,47..92,94..95:
      TDButton(Sender).Hint := TDButton(Sender).Hint+Char(key);
     12: TDButton(Sender).Hint := TDButton(Sender).Hint+'Num 5';
     27: TDButton(Sender).Hint := TDButton(Sender).Hint+'Esc';
     45: TDButton(Sender).Hint := TDButton(Sender).Hint+'Insert';
     96..105: //小键盘
      TDButton(Sender).Hint := TDButton(Sender).Hint+'Num '+Char(key-48);
     106..111:
      TDButton(Sender).Hint := TDButton(Sender).Hint+'Num '+Char(key-64);
     112..122: //功能键
      TDButton(Sender).Hint := TDButton(Sender).Hint+'F'+IntToStr(Key-112+1);
     123: begin
       frmMain.OpenSdoAssistant();
       Exit;
     end;
     144: //Pause 小键开启灯那个
      TDButton(Sender).Hint := TDButton(Sender).Hint+'Pause';
     145: //Scroll Lock
      TDButton(Sender).Hint := TDButton(Sender).Hint+'Scroll Lock';
     192:
      TDButton(Sender).Hint := TDButton(Sender).Hint+Char(key-96);
     186:
       TDButton(Sender).Hint := TDButton(Sender).Hint+Char(key-127);
     187..191:
      TDButton(Sender).Hint := TDButton(Sender).Hint+Char(key-144);
     219..221:
      TDButton(Sender).Hint := TDButton(Sender).Hint+Char(key-128);
     222:
       TDButton(Sender).Hint := TDButton(Sender).Hint+Char(key-183);
     226:
      TDButton(Sender).Hint := TDButton(Sender).Hint+Char(key-134);
    else
      //TDButton(Sender).Hint := inttostr(key);
    end;
  //if  not DCheckSdoStartKey.Checked then begin TDButton(Sender).Tag := Key //else begin
      if Pos ('Ctrl',TDButton(Sender).Hint) > 0 then  CombinationKey := 16384;
      if Pos ('Shift',TDButton(Sender).Hint) > 0 then  CombinationKey := CombinationKey + 8192;
      if Pos ('Alt',TDButton(Sender).Hint) > 0 then  CombinationKey := CombinationKey + 32768;
      TDButton(Sender).Tag := Key;
    if Sender = DBtnSdoCallHeroKey then begin
   //  FrmMain.ActCallHeroKey.ShortCut := CombinationKey + Key;
    end;
    if Sender = DBtnSdoHeroAttackTargetKey then begin
      //FrmMain.ActHeroAttackTargetKey.ShortCut := CombinationKey + Key;
    end;
    if Sender = DBtnSdoHeroGotethKey then begin
    //  FrmMain.ActHeroGotethKey.ShortCut := CombinationKey + Key;
    end;
    if Sender = DBtnSdoHeroStateKey then begin
    //  FrmMain.ActHeroStateKey.ShortCut := CombinationKey + Key;
    end;
    if Sender = DBtnSdoHeroGuardKey then begin
    //  FrmMain.ActHeroGuardKey.ShortCut := CombinationKey + Key;
    end;
    if Sender = DBtnSdoAttackModeKey then begin
    //  FrmMain.ActAttackModeKey.ShortCut := CombinationKey + Key;
    end;
    if Sender = DBtnSdoMinMapKey then begin
    //  FrmMain.ActMinMapKey.ShortCut := CombinationKey + Key;
    end;
  //end;
  end;
end;

procedure TFrmDlg.DBtnSdoCallHeroKeyMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
 if Button = mbRight then begin
    if Sender = DBtnSdoCallHeroKey then begin
      DBtnSdoCallHeroKey.Hint := '';
      DBtnSdoCallHeroKey.Tag := 0;
   //   FrmMain.ActCallHeroKey.ShortCut := 0;
    end;
    if Sender = DBtnSdoHeroAttackTargetKey then begin
      DBtnSdoHeroAttackTargetKey.Hint := '';
      DBtnSdoHeroAttackTargetKey.Tag := 0;
     // FrmMain.ActHeroAttackTargetKey.ShortCut := 0;
    end;
    if Sender = DBtnSdoHeroGotethKey then begin
      DBtnSdoHeroGotethKey.Hint := '';
      DBtnSdoHeroGotethKey.Tag := 0;
    //  FrmMain.ActHeroGotethKey.ShortCut := 0;
    end;
    if Sender = DBtnSdoHeroStateKey then begin
      DBtnSdoHeroStateKey.Hint := '';
      DBtnSdoHeroStateKey.Tag := 0;
    //  FrmMain.ActHeroStateKey.ShortCut := 0;
    end;
    if Sender = DBtnSdoHeroGuardKey then begin
      DBtnSdoHeroGuardKey.Hint := '';
      DBtnSdoHeroGuardKey.Tag := 0;
    //  FrmMain.ActHeroGuardKey.ShortCut := 0;
    end;
    if Sender = DBtnSdoAttackModeKey then begin
      DBtnSdoAttackModeKey.Hint := '';
      DBtnSdoAttackModeKey.Tag := 0;
    //  FrmMain.ActAttackModeKey.ShortCut := 0;
    end;
    if Sender = DBtnSdoMinMapKey then begin
      DBtnSdoMinMapKey.Hint := '';
      DBtnSdoMinMapKey.Tag := 0;
     // FrmMain.ActMinMapKey.ShortCut := 0;
    end;
  end;
end;

procedure TFrmDlg.DSdoHelpUpClick(Sender: TObject; X, Y: Integer);
begin
  if Sender = DSdoHelpUp then begin
     if g_btSdoAssistantHelpPage <= 0 then Exit
     else Dec(g_btSdoAssistantHelpPage);
  end else begin
     if g_btSdoAssistantHelpPage >= 5 then Exit
     else Inc(g_btSdoAssistantHelpPage);
  end;
end;

procedure TFrmDlg.DSdoHelpUpDirectPaint(Sender: TObject;
  dsurface: TDirectDrawSurface);
var
   d: TDirectDrawSurface;
begin
   with Sender as TDButton do begin
      if WLib <> nil then begin //20080701
        if not TDButton(Sender).Downed then begin
           d := WLib.Images[FaceIndex];
           if d <> nil then
              dsurface.Draw (SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, TRUE);
        end else begin
           d := WLib.Images[FaceIndex + 1];
           if d <> nil then
              dsurface.Draw (SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, TRUE);
        end;
      end;
   end;
end;

end.


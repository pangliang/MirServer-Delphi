unit PlayScn;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DXDraws, DXClass, DirectX, IntroScn, Grobal2, cliUtil, HUtil32,
  Actor, HerbActor, AxeMon, SoundUtil, clEvent, WIL,
  StdCtrls, ClFunc, magiceff, ExtCtrls, MShare, Share;


const
  //   MAPSURFACEWIDTH = 800;
  //   MAPSURFACEHEIGHT = 445;

  LONGHEIGHT_IMAGE = 35;
  FLASHBASE = 410;
  AAX = 16;
  SOFFX = 0;
  SOFFY = 0;
  LMX = 30;
  LMY = 26;



  MAXLIGHT = 5;
  LightFiles: array[0..MAXLIGHT] of string = (
    'Data\lig0a.dat',
    'Data\lig0b.dat',
    'Data\lig0c.dat',
    'Data\lig0d.dat',
    'Data\lig0e.dat',
    'Data\lig0f.dat'
    );

  LightMask0: array[0..2, 0..2] of shortint = (
    (0, 1, 0),
    (1, 3, 1),
    (0, 1, 0)
    );
  LightMask1: array[0..4, 0..4] of shortint = (
    (0, 1, 1, 1, 0),
    (1, 1, 3, 1, 1),
    (1, 3, 4, 3, 1),
    (1, 1, 3, 1, 1),
    (0, 1, 2, 1, 0)
    );
  LightMask2: array[0..8, 0..8] of shortint = (
    (0, 0, 0, 1, 1, 1, 0, 0, 0),
    (0, 0, 1, 2, 3, 2, 1, 0, 0),
    (0, 1, 2, 3, 4, 3, 2, 1, 0),
    (1, 2, 3, 4, 4, 4, 3, 2, 1),
    (1, 3, 4, 4, 4, 4, 4, 3, 1),
    (1, 2, 3, 4, 4, 4, 3, 2, 1),
    (0, 1, 2, 3, 4, 3, 2, 1, 0),
    (0, 0, 1, 2, 3, 2, 1, 0, 0),
    (0, 0, 0, 1, 1, 1, 0, 0, 0)
    );
  LightMask3: array[0..10, 0..10] of shortint = (
    (0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0),
    (0, 0, 0, 1, 2, 2, 2, 1, 0, 0, 0),
    (0, 0, 1, 2, 3, 3, 3, 2, 1, 0, 0),
    (0, 1, 2, 3, 4, 4, 4, 3, 2, 1, 0),
    (1, 2, 3, 4, 4, 4, 4, 4, 3, 2, 1),
    (2, 3, 4, 4, 4, 4, 4, 4, 4, 3, 2),
    (1, 2, 3, 4, 4, 4, 4, 4, 3, 2, 1),
    (0, 1, 2, 3, 4, 4, 4, 3, 2, 1, 0),
    (0, 0, 1, 2, 3, 3, 3, 2, 1, 0, 0),
    (0, 0, 0, 1, 2, 2, 2, 1, 0, 0, 0),
    (0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0)
    );

  LightMask4: array[0..14, 0..14] of shortint = (
    (0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0),
    (0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0),
    (0, 0, 0, 0, 1, 1, 2, 2, 2, 1, 1, 0, 0, 0, 0),
    (0, 0, 0, 1, 1, 2, 3, 3, 3, 2, 1, 1, 0, 0, 0),
    (0, 0, 1, 1, 2, 3, 4, 4, 4, 3, 2, 1, 1, 0, 0),
    (0, 1, 1, 2, 3, 4, 4, 4, 4, 4, 3, 2, 1, 1, 0),
    (1, 1, 2, 3, 4, 4, 4, 4, 4, 4, 4, 3, 2, 1, 1),
    (1, 2, 3, 4, 4, 4, 4, 4, 4, 4, 4, 4, 3, 2, 1),
    (1, 1, 2, 3, 4, 4, 4, 4, 4, 4, 4, 3, 2, 1, 1),
    (0, 1, 1, 2, 3, 4, 4, 4, 4, 4, 3, 2, 1, 1, 0),
    (0, 0, 1, 1, 2, 3, 4, 4, 4, 3, 2, 1, 1, 0, 0),
    (0, 0, 0, 1, 1, 2, 3, 3, 3, 2, 1, 1, 0, 0, 0),
    (0, 0, 0, 0, 1, 1, 2, 2, 2, 1, 1, 0, 0, 0, 0),
    (0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0),
    (0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0)
    );

  LightMask5: array[0..16, 0..16] of shortint = (
    (0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0),
    (0, 0, 0, 0, 0, 0, 1, 2, 2, 2, 1, 0, 0, 0, 0, 0, 0),
    (0, 0, 0, 0, 0, 1, 2, 4, 4, 4, 2, 1, 0, 0, 0, 0, 0),
    (0, 0, 0, 0, 1, 2, 4, 4, 4, 4, 4, 2, 1, 0, 0, 0, 0),
    (0, 0, 0, 1, 2, 4, 4, 4, 4, 4, 4, 4, 2, 1, 0, 0, 0),
    (0, 0, 1, 2, 4, 4, 4, 4, 4, 4, 4, 4, 4, 2, 1, 0, 0),
    (0, 1, 2, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 2, 1, 0),
    (1, 2, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 2, 1),
    (1, 2, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 2, 1),
    (1, 2, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 2, 1),
    (0, 1, 2, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 2, 1, 0),
    (0, 0, 1, 2, 4, 4, 4, 4, 4, 4, 4, 4, 4, 2, 1, 0, 0),
    (0, 0, 0, 1, 2, 4, 4, 4, 4, 4, 4, 4, 2, 1, 0, 0, 0),
    (0, 0, 0, 0, 1, 2, 4, 4, 4, 4, 4, 2, 1, 0, 0, 0, 0),
    (0, 0, 0, 0, 0, 1, 2, 4, 4, 4, 2, 1, 0, 0, 0, 0, 0),
    (0, 0, 0, 0, 0, 0, 1, 2, 2, 2, 1, 0, 0, 0, 0, 0, 0),
    (0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0)
    { (0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0),
     (0,0,0,0,0,0,0,1,2,2,2,1,0,0,0,0,0,0,0),
     (0,0,0,0,0,0,1,2,4,4,4,2,1,0,0,0,0,0,0),
     (0,0,0,0,0,1,2,4,4,4,4,4,2,1,0,0,0,0,0),
     (0,0,0,0,1,2,4,4,4,4,4,4,4,2,1,0,0,0,0),
     (0,0,0,1,2,4,4,4,4,4,4,4,4,4,2,1,0,0,0),
     (0,0,1,2,4,4,4,4,4,4,4,4,4,4,4,2,1,0,0),
     (0,1,2,4,4,4,4,4,4,4,4,4,4,4,4,4,2,1,0),
     (1,2,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,2,1),
     (1,2,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,2,1),
     (1,2,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,2,1),
     (0,1,2,4,4,4,4,4,4,4,4,4,4,4,4,4,2,1,0),
     (0,0,1,2,4,4,4,4,4,4,4,4,4,4,4,2,1,0,0),
     (0,0,0,1,2,4,4,4,4,4,4,4,4,4,2,1,0,0,0),
     (0,0,0,0,1,2,4,4,4,4,4,4,4,2,1,0,0,0,0),
     (0,0,0,0,0,1,2,4,4,4,4,4,2,1,0,0,0,0,0),
     (0,0,0,0,0,0,1,2,4,4,4,2,1,0,0,0,0,0,0),
     (0,0,0,0,0,0,0,1,2,2,2,1,0,0,0,0,0,0,0),
     (0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0) }
    );

type
  PShoftInt = ^shortint;
  TLightEffect = record
    Width: Integer;
    Height: Integer;
    PFog: PByte;
  end;
  TLightMapInfo = record
    ShiftX: Integer;
    ShiftY: Integer;
    light: Integer;
    bright: Integer;
  end;

  TPlayScene = class(TScene)
  private
    m_MapSurface: TDirectDrawSurface;
    m_ObjSurface: TDirectDrawSurface; //0x0C

    m_FogScreen: array[0..MAPSURFACEHEIGHT, 0..MAPSURFACEWIDTH] of byte;
    m_PFogScreen: PByte;
    m_nFogWidth: Integer;
    m_nFogHeight: Integer;
    m_Lights: array[0..MAXLIGHT] of TLightEffect;
    m_dwMoveTime: LongWord;
    m_nMoveStepCount: Integer;
    m_dwAniTime: LongWord;
    m_nAniCount: Integer;
    m_nDefXX: Integer;
    m_nDefYY: Integer;
    m_MainSoundTimer: TTimer;
    m_MsgList: TList;
    m_LightMap: array[0..LMX, 0..LMY] of TLightMapInfo;
    procedure DrawTileMap;
    procedure LoadFog;
    procedure ClearLightMap;
    procedure AddLight(X, Y, ShiftX, ShiftY, light: Integer; nocheck: Boolean);
    procedure UpdateBright(X, Y, light: Integer);
    function CheckOverLight(X, Y, light: Integer): Boolean;
    procedure ApplyLightMap;
    procedure DrawLightEffect(lx, ly, bright: Integer);
    procedure EdChatKeyPress(Sender: TObject; var Key: Char);
    procedure SoundOnTimer(Sender: TObject);
    function CrashManEx(mx, my: Integer): Boolean;
    procedure ClearDropItem();
  public
    EdChat: TEdit;
    MemoLog: TMemo;
    EdAccountt: TEdit; //2004/05/17
    EdChrNamet: TEdit; //2004/05/17
    {
    EdChgChrName: TEdit;
    EdChgCurPwd: TEdit;
    EdChgNewPwd: TEdit;
    EdChgRePwd: TEdit;
    }

    m_ActorList: TList;
    m_TempList: TList;
    m_GroundEffectList: TList; //¹Ù´Ú¿¡ ±ò¸®´Â ¸¶¹ý ¸®½ºÆ®
    m_EffectList: TList; //¸¶¹ýÈ¿°ú ¸®½ºÆ®
    m_FlyList: TList; //³¯¾Æ´Ù´Ï´Â °Í (´øÁøµµ³¢, Ã¢, È­»ì)
    m_dwBlinkTime: LongWord;
    m_boViewBlink: Boolean;
    constructor Create;
    destructor Destroy; override;
    procedure Initialize; override;
    procedure Finalize; override;
    procedure OpenScene; override;
    procedure CloseScene; override;
    procedure OpeningScene; override;
    procedure DrawMiniMap(Surface: TDirectDrawSurface);
    procedure PlayScene(MSurface: TDirectDrawSurface); override;
    function ButchAnimal(X, Y: Integer): TActor;

    function FindActor(id: Integer): TActor; overload;
    function FindActor(sname: string): TActor; overload;
    function FindActorXY(X, Y: Integer): TActor;
    function IsValidActor(Actor: TActor): Boolean;
    function NewActor(chrid: Integer; cx, cy, cdir: Word; cfeature, cstate: Integer): TActor;
    procedure ActorDied(Actor: TObject); //Á×Àº actor´Â ¸Ç À§·Î
    procedure SetActorDrawLevel(Actor: TObject; Level: Integer);
    procedure ClearActors;
    function DeleteActor(id: Integer): TActor;
    procedure DelActor(Actor: TObject);
    procedure SendMsg(ident, chrid, X, Y, cdir, Feature, State: Integer; str: string);

    procedure NewMagic(aowner: TActor;
      magid, magnumb, cx, cy, tx, ty, targetcode: Integer;
      mtype: TMagicType;
      Recusion: Boolean;
      anitime: Integer;
      var bofly: Boolean);
    procedure DelMagic(magid: Integer);
    function NewFlyObject(aowner: TActor; cx, cy, tx, ty, targetcode: Integer; mtype: TMagicType): TMagicEff;
    //function  NewStaticMagic (aowner: TActor; tx, ty, targetcode, effnum: integer);

    procedure ScreenXYfromMCXY(cx, cy: Integer; var sx, sy: Integer);
    procedure CXYfromMouseXY(mx, my: Integer; var ccx, ccy: Integer);
    function GetCharacter(X, Y, wantsel: Integer; var nowsel: Integer; liveonly: Boolean): TActor;
    function GetAttackFocusCharacter(X, Y, wantsel: Integer; var nowsel: Integer; liveonly: Boolean): TActor;
    function IsSelectMyself(X, Y: Integer): Boolean;
    function GetDropItems(X, Y: Integer; var inames: string): pTDropItem;
    function GetXYDropItems(nX, nY: Integer): pTDropItem;
    procedure GetXYDropItemsList(nX, nY: Integer; var ItemList: TList);
    function CanRun(sx, sy, ex, ey: Integer): Boolean;
    function CanWalk(mx, my: Integer): Boolean;
    function CanWalkEx(mx, my: Integer): Boolean;
    function CrashMan(mx, my: Integer): Boolean; //»ç¶÷³¢¸® °ãÄ¡´Â°¡?
    function CanFly(mx, my: Integer): Boolean;
    procedure RefreshScene;
    procedure CleanObjects;
  end;


implementation

uses
  ClMain, FState;


constructor TPlayScene.Create;
var
  nX, nY: Integer;
begin
  m_MapSurface := nil;
  m_ObjSurface := nil;
  m_MsgList := TList.Create;
  m_ActorList := TList.Create;
  m_TempList := TList.Create;
  m_GroundEffectList := TList.Create;
  m_EffectList := TList.Create;
  m_FlyList := TList.Create;
  m_dwBlinkTime := GetTickCount;
  m_boViewBlink := FALSE;

  EdChat := TEdit.Create(frmMain.Owner);
  with EdChat do begin
    Parent := frmMain;
    BorderStyle := bsNone;
    OnKeyPress := EdChatKeyPress;
    Visible := FALSE;
    MaxLength := 70;
    Ctl3D := FALSE;
    Left := 208;
    Top := SCREENHEIGHT - 19;
    Height := 12;
    Width := (SCREENWIDTH div 2 - 207) * 2 {387};
    Color := clSilver;
  end;
  MemoLog := TMemo.Create(frmMain.Owner);
  with MemoLog do begin
    Parent := frmMain;
    BorderStyle := bsNone;
    Visible := FALSE;
    // Visible := True;
    Ctl3D := True;
    Left := 0;
    Top := 250;
    Width := 300;
    Height := 150;
  end;
  //2004/05/17
  EdAccountt := TEdit.Create(frmMain.Owner);
  with EdAccountt do begin
    Parent := frmMain;
    BorderStyle := bsSingle;
    Visible := FALSE;
    MaxLength := 70;
    Ctl3D := True;
    Left := (SCREENWIDTH - 194) div 2;
    Top := SCREENHEIGHT - 200;
    Height := 12;
    Width := 194;
  end;
  //2004/05/17
  //2004/05/17
  EdChrNamet := TEdit.Create(frmMain.Owner);
  with EdChrNamet do begin
    Parent := frmMain;
    BorderStyle := bsSingle;
    Visible := FALSE;
    MaxLength := 70;
    Ctl3D := True;
    Left := (SCREENWIDTH - 194) div 2;
    Top := SCREENHEIGHT - 176;
    Height := 12;
    Width := 194;
  end;
  //2004/05/17

  m_dwMoveTime := GetTickCount;
  m_dwAniTime := GetTickCount;
  m_nAniCount := 0;
  m_nMoveStepCount := 0;
  m_MainSoundTimer := TTimer.Create(frmMain.Owner);
  with m_MainSoundTimer do begin
    OnTimer := SoundOnTimer;
    Interval := 1;
    Enabled := FALSE;
  end;
  {
  nx:=192;
  ny:=150;
  }
  nX := SCREENWIDTH div 2 - 210 {192} {192};
  nY := SCREENHEIGHT div 2 - 150 {146} {150};
  {
  EdChgChrName := TEdit.Create (FrmMain.Owner);
  with EdChgChrName do begin
     Parent:=FrmMain;
     Height:=16;
     Width:=137;
     Left:=nx + 239;
     Top:=ny + 117;
     BorderStyle:=bsNone;
     Color:=clBlack;
     Font.Color:=clWhite;
     MaxLength:=10;
     Visible:=FALSE;
     //OnKeyPress:=EdNewIdKeyPress;
     //OnEnter:=EdNewOnEnter;
     Tag:=12;
  end;

  EdChgCurPwd := TEdit.Create (FrmMain.Owner);
  with EdChgCurPwd do begin
     Parent:=FrmMain;
     Height:=16;
     Width:=137;
     Left:=nx+239;
     Top:=ny+149;
     BorderStyle:=bsNone;
     Color:=clBlack;
     Font.Color:=clWhite;
     MaxLength:=10;
     PasswordChar:='*';
     Visible:=FALSE;
     //OnKeyPress:=EdNewIdKeyPress;
     //OnEnter:=EdNewOnEnter;
     Tag := 12;
  end;
  EdChgNewPwd := TEdit.Create (FrmMain.Owner);
  with EdChgNewPwd do begin
     Parent:=FrmMain;
     Height:=16;
     Width:=137;
     Left:=nx+239;
     Top:=ny+176;
     BorderStyle:=bsNone;
     Color:=clBlack;
     Font.Color:=clWhite;
     MaxLength:=10;
     PasswordChar:='*';
     Visible:=FALSE;
     //OnKeyPress:=EdNewIdKeyPress;
     //OnEnter:=EdNewOnEnter;
     Tag:=12;
  end;
  EdChgRePwd := TEdit.Create (FrmMain.Owner);
  with EdChgRePwd do begin
     Parent := FrmMain;
     Height := 16;
     Width  := 137;
     Left := nx+239;
     Top  := ny+208;
     BorderStyle := bsNone;
     Color := clBlack;
     Font.Color := clWhite;
     MaxLength := 10;
     PasswordChar := '*';
     Visible := FALSE;
     //OnKeyPress := EdNewIdKeyPress;
     //OnEnter := EdNewOnEnter;
     Tag := 12;
  end;
  }
end;

destructor TPlayScene.Destroy;
begin
  m_MsgList.Free;
  m_ActorList.Free;
  m_TempList.Free;
  m_GroundEffectList.Free;
  m_EffectList.Free;
  m_FlyList.Free;
  inherited Destroy;
end;

procedure TPlayScene.SoundOnTimer(Sender: TObject);
begin
  PlaySound(s_main_theme);
  m_MainSoundTimer.Interval := 46 * 1000;
end;

procedure TPlayScene.EdChatKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then begin
    frmMain.SendSay(EdChat.Text);
    EdChat.Text := '';
    EdChat.Visible := FALSE;
    Key := #0;
  end;
  if Key = #27 then begin
    EdChat.Text := '';
    EdChat.Visible := FALSE;
    Key := #0;
  end;
end;

procedure TPlayScene.Initialize;
var
  i: Integer;
begin
  m_MapSurface := TDirectDrawSurface.Create(frmMain.DXDraw.DDraw);
  m_MapSurface.SystemMemory := True;
  m_MapSurface.SetSize(MAPSURFACEWIDTH + UNITX * 4 + 30, MAPSURFACEHEIGHT + UNITY * 4);
  m_ObjSurface := TDirectDrawSurface.Create(frmMain.DXDraw.DDraw);
  m_ObjSurface.SystemMemory := True;
  m_ObjSurface.SetSize(MAPSURFACEWIDTH - SOFFX * 2, MAPSURFACEHEIGHT);

  m_nFogWidth := MAPSURFACEWIDTH - SOFFX * 2;
  m_nFogHeight := MAPSURFACEHEIGHT;
  m_PFogScreen := @m_FogScreen;
  //PFogScreen := AllocMem (FogWidth * FogHeight);
  ZeroMemory(m_PFogScreen, MAPSURFACEHEIGHT * MAPSURFACEWIDTH);

  g_boViewFog := FALSE;
  for i := 0 to MAXLIGHT do
    m_Lights[i].PFog := nil;
  LoadFog;

end;

procedure TPlayScene.Finalize;
begin
  if m_MapSurface <> nil then
    m_MapSurface.Free;
  if m_ObjSurface <> nil then
    m_ObjSurface.Free;
  m_MapSurface := nil;
  m_ObjSurface := nil;
end;

procedure TPlayScene.OpenScene;
begin
  g_WMainImages.ClearCache; //·Î±×ÀÎ ÀÌ¹ÌÁö Ä³½Ã¸¦ Áö¿î´Ù.
  FrmDlg.ViewBottomBox(True);
  //EdChat.Visible := TRUE;
  //EdChat.SetFocus;
  SetImeMode(frmMain.Handle, LocalLanguage);
  //MainSoundTimer.Interval := 1000;
  //MainSoundTimer.Enabled := TRUE;
end;

procedure TPlayScene.CloseScene;
begin
  //MainSoundTimer.Enabled := FALSE;
  SilenceSound;

  EdChat.Visible := FALSE;
  FrmDlg.ViewBottomBox(FALSE);
end;

procedure TPlayScene.OpeningScene;
begin
end;

procedure TPlayScene.RefreshScene;
var
  i: Integer;
begin
  Map.m_OldClientRect.Left := -1;
  for i := 0 to m_ActorList.count - 1 do
    TActor(m_ActorList[i]).LoadSurface;
end;

procedure TPlayScene.CleanObjects;
var
  i: Integer;
begin
  for i := m_ActorList.count - 1 downto 0 do begin
    if TActor(m_ActorList[i]) <> g_MySelf then begin
      TActor(m_ActorList[i]).Free;
      m_ActorList.Delete(i);
    end;
  end;
  m_MsgList.Clear;
  g_TargetCret := nil;
  g_FocusCret := nil;
  g_MagicTarget := nil;
  //
  for i := 0 to m_GroundEffectList.count - 1 do
    TMagicEff(m_GroundEffectList[i]).Free;
  m_GroundEffectList.Clear;
  for i := 0 to m_EffectList.count - 1 do
    TMagicEff(m_EffectList[i]).Free;
  m_EffectList.Clear;
end;

{---------------------- Draw Map -----------------------}

procedure TPlayScene.DrawTileMap;
var
  i, j, nY, nX, nImgNumber: Integer;
  dsurface: TDirectDrawSurface;
begin
  with Map do
    if (m_ClientRect.Left = m_OldClientRect.Left) and (m_ClientRect.Top = m_OldClientRect.Top) then Exit;

  Map.m_OldClientRect := Map.m_ClientRect;
  m_MapSurface.Fill(0);

  //µØÍ¼±³¾°
  if not g_boDrawTileMap then Exit;
  with Map.m_ClientRect do begin
    nY := -UNITY * 2;
    for j := (Top - Map.m_nBlockTop - 1) to (Bottom - Map.m_nBlockTop + 1) do begin
      nX := AAX + 14 - UNITX;
      for i := (Left - Map.m_nBlockLeft - 2) to (Right - Map.m_nBlockLeft + 1) do begin
        if (i >= 0) and (i < LOGICALMAPUNIT * 3) and (j >= 0) and (j < LOGICALMAPUNIT * 3) then begin
          nImgNumber := (Map.m_MArr[i, j].wBkImg and $7FFF);
          if nImgNumber > 0 then begin
            if (i mod 2 = 0) and (j mod 2 = 0) then begin
              nImgNumber := nImgNumber - 1;
              dsurface := g_WTilesImages.Images[nImgNumber];
              if dsurface <> nil then begin
                //Jacky ÏÔÊ¾µØÍ¼ÄÚÈÝ
//                DrawLine(DSurface);
                m_MapSurface.Draw(nX, nY, dsurface.ClientRect, dsurface, FALSE);
              end;
            end;
          end;
        end;
        Inc(nX, UNITX);
      end;
      Inc(nY, UNITY);
    end;
  end;

  //µØÍ¼ÖÐ¼ä²ã
  with Map.m_ClientRect do begin
    nY := -UNITY;
    for j := (Top - Map.m_nBlockTop - 1) to (Bottom - Map.m_nBlockTop + 1) do begin
      nX := AAX + 14 - UNITX;
      for i := (Left - Map.m_nBlockLeft - 2) to (Right - Map.m_nBlockLeft + 1) do begin
        if (i >= 0) and (i < LOGICALMAPUNIT * 3) and (j >= 0) and (j < LOGICALMAPUNIT * 3) then begin
          nImgNumber := Map.m_MArr[i, j].wMidImg;
          if nImgNumber > 0 then begin
            nImgNumber := nImgNumber - 1;
            dsurface := g_WSmTilesImages.Images[nImgNumber];
            if dsurface <> nil then
              m_MapSurface.Draw(nX, nY, dsurface.ClientRect, dsurface, True);
          end;
        end;
        Inc(nX, UNITX);
      end;
      Inc(nY, UNITY);
    end;
  end;

end;



{----------------------- Æ÷±×, ¶óÀÌÆ® Ã³¸® -----------------------}


procedure TPlayScene.LoadFog; //¶óÀÌÆ® µ¥ÀÌÅ¸ ÀÐ±â
var
  i, fhandle, w, h, prevsize: Integer;
  cheat: Boolean;
begin
  prevsize := 0; //Á¶ÀÛ Ã¼Å©
  cheat := FALSE;
  for i := 0 to MAXLIGHT do begin
    if FileExists(LightFiles[i]) then begin
      fhandle := FileOpen(LightFiles[i], fmOpenRead or fmShareDenyNone);
      FileRead(fhandle, w, sizeof(Integer));
      FileRead(fhandle, h, sizeof(Integer));
      m_Lights[i].Width := w;
      m_Lights[i].Height := h;
      m_Lights[i].PFog := AllocMem(w * h + 8);
      if prevsize < w * h then begin
        FileRead(fhandle, m_Lights[i].PFog^, w * h);
      end else
        cheat := True;
      prevsize := w * h;
      FileClose(fhandle);
    end;
  end;
  if cheat then
    for i := 0 to MAXLIGHT do begin
      if m_Lights[i].PFog <> nil then
        FillChar(m_Lights[i].PFog^, m_Lights[i].Width * m_Lights[i].Height + 8, #0);
    end;
end;

procedure TPlayScene.ClearDropItem;
var
  i: Integer;
  DropItem: pTDropItem;
begin
  for i := g_DropedItemList.count - 1 downto 0 do begin
    DropItem := g_DropedItemList.Items[i];
    if DropItem = nil then begin
      g_DropedItemList.Delete(i);
      continue;
    end;
    if (abs(DropItem.X - g_MySelf.m_nCurrX) > 30) and (abs(DropItem.Y - g_MySelf.m_nCurrY) > 30) then begin
{$IF DEBUG = 1}
      DScreen.AddChatBoardString(format('DropItem:%s X:%d Y:%d', [DropItem.name, DropItem.X, DropItem.Y]), clWhite, clRed);
{$IFEND}
      Dispose(DropItem);
      g_DropedItemList.Delete(i);
    end;
  end;
end;

procedure TPlayScene.ClearLightMap;
var
  i, j: Integer;
begin
  FillChar(m_LightMap, (LMX + 1) * (LMY + 1) * sizeof(TLightMapInfo), 0);
  for i := 0 to LMX do
    for j := 0 to LMY do
      m_LightMap[i, j].light := -1;
end;

procedure TPlayScene.UpdateBright(X, Y, light: Integer);
var
  i, j, r, lx, ly: Integer;
  pmask: ^shortint;
begin
  pmask := nil; //jacky
  r := -1;
  case light of
    0: begin
        r := 2; pmask := @LightMask0; end;
    1: begin
        r := 4; pmask := @LightMask1; end;
    2: begin
        r := 8; pmask := @LightMask2; end;
    3: begin
        r := 10; pmask := @LightMask3; end;
    4: begin
        r := 14; pmask := @LightMask4; end;
    5: begin
        r := 16; pmask := @LightMask5; end;
  end;
  for i := 0 to r do
    for j := 0 to r do begin
      lx := X - (r div 2) + i;
      ly := Y - (r div 2) + j;
      if (lx in [0..LMX]) and (ly in [0..LMY]) then
        m_LightMap[lx, ly].bright := m_LightMap[lx, ly].bright + PShoftInt(Integer(pmask) + (i * (r + 1) + j) * sizeof(shortint))^;
    end;
end;

function TPlayScene.CheckOverLight(X, Y, light: Integer): Boolean;
var
  i, j, r, mlight, lx, ly, count, check: Integer;
  pmask: ^shortint;
begin
  pmask := nil; //jacky
  check := 0; //jacky
  r := -1;
  case light of
    0: begin
        r := 2; pmask := @LightMask0; check := 0; end;
    1: begin
        r := 4; pmask := @LightMask1; check := 4; end;
    2: begin
        r := 8; pmask := @LightMask2; check := 8; end;
    3: begin
        r := 10; pmask := @LightMask3; check := 18; end;
    4: begin
        r := 14; pmask := @LightMask4; check := 30; end;
    5: begin
        r := 16; pmask := @LightMask5; check := 40; end;
  end;
  count := 0;
  for i := 0 to r do
    for j := 0 to r do begin
      lx := X - (r div 2) + i;
      ly := Y - (r div 2) + j;
      if (lx in [0..LMX]) and (ly in [0..LMY]) then begin
        mlight := PShoftInt(Integer(pmask) + (i * (r + 1) + j) * sizeof(shortint))^;
        if m_LightMap[lx, ly].bright < mlight then begin
          Inc(count, mlight - m_LightMap[lx, ly].bright);
          if count >= check then begin
            Result := FALSE;
            Exit;
          end;
        end;
      end;
    end;
  Result := True;
end;

procedure TPlayScene.AddLight(X, Y, ShiftX, ShiftY, light: Integer; nocheck: Boolean);
var
  lx, ly: Integer;
begin
  lx := X - g_MySelf.m_nRx + LMX div 2;
  ly := Y - g_MySelf.m_nRy + LMY div 2;
  if (lx >= 1) and (lx < LMX) and (ly >= 1) and (ly < LMY) then begin
    if m_LightMap[lx, ly].light < light then begin
      if not CheckOverLight(lx, ly, light) or nocheck then begin // > LightMap[lx, ly].light then begin
        UpdateBright(lx, ly, light);
        m_LightMap[lx, ly].light := light;
        m_LightMap[lx, ly].ShiftX := ShiftX;
        m_LightMap[lx, ly].ShiftY := ShiftY;
      end;
    end;
  end;
end;

procedure TPlayScene.ApplyLightMap;
var
  i, j, light, defx, defy, lx, ly, lxx, lyy, lcount: Integer;
begin
  defx := -UNITX * 2 + AAX + 14 - g_MySelf.m_nShiftX;
  defy := -UNITY * 3 - g_MySelf.m_nShiftY;
  lcount := 0;
  for i := 1 to LMX - 1 do
    for j := 1 to LMY - 1 do begin
      light := m_LightMap[i, j].light;
      if light >= 0 then begin
        lx := (i + g_MySelf.m_nRx - LMX div 2);
        ly := (j + g_MySelf.m_nRy - LMY div 2);
        lxx := (lx - Map.m_ClientRect.Left) * UNITX + defx + m_LightMap[i, j].ShiftX;
        lyy := (ly - Map.m_ClientRect.Top) * UNITY + defy + m_LightMap[i, j].ShiftY;

        FogCopy(m_Lights[light].PFog,
          0,
          0,
          m_Lights[light].Width,
          m_Lights[light].Height,
          m_PFogScreen,
          lxx - (m_Lights[light].Width - UNITX) div 2,
          lyy - (m_Lights[light].Height - UNITY) div 2 - 5,
          m_nFogWidth,
          m_nFogHeight,
          20);
        Inc(lcount);
      end;
    end;
end;

procedure TPlayScene.DrawLightEffect(lx, ly, bright: Integer);
begin
  if (bright > 0) and (bright <= MAXLIGHT) then
    FogCopy(m_Lights[bright].PFog,
      0,
      0,
      m_Lights[bright].Width,
      m_Lights[bright].Height,
      m_PFogScreen,
      lx - (m_Lights[bright].Width - UNITX) div 2,
      ly - (m_Lights[bright].Height - UNITY) div 2,
      m_nFogWidth,
      m_nFogHeight,
      15);
end;

{-----------------------------------------------------------------------}

procedure TPlayScene.DrawMiniMap(Surface: TDirectDrawSurface);
var
  d: TDirectDrawSurface;
  v: Boolean;
  mx, my, nX, nY, i: Integer;
  rc: TRect;
  Actor: TActor;
  X, Y: Integer;
  btColor: byte;
begin
  if GetTickCount > m_dwBlinkTime + 300 then begin
    m_dwBlinkTime := GetTickCount;
    m_boViewBlink := not m_boViewBlink;
  end;
  if g_nMiniMapIndex < 0 then Exit; //Jacky
  d := g_WMMapImages.Images[g_nMiniMapIndex];
  if d = nil then Exit;
  mx := (g_MySelf.m_nCurrX * 48) div 32;
  my := (g_MySelf.m_nCurrY * 32) div 32;
  rc.Left := _MAX(0, mx - 60);
  rc.Top := _MAX(0, my - 60);
  rc.Right := _MIN(d.ClientRect.Right, rc.Left + 120);
  rc.Bottom := _MIN(d.ClientRect.Bottom, rc.Top + 120);

  if g_nViewMinMapLv = 1 then
    DrawBlendEx(Surface, (SCREENWIDTH - 120), 0, d, rc.Left, rc.Top, 120, 120, 0)
  else Surface.Draw((SCREENWIDTH - 120), 0, rc, d, FALSE);
  //À×´ï
  if not m_boViewBlink then Exit;
  mx := (SCREENWIDTH - 120) + (g_MySelf.m_nCurrX * 48) div 32 - rc.Left;
  my := (g_MySelf.m_nCurrY * 32) div 32 - rc.Top;
  Surface.Pixels[mx, my] := 255;

  for nX := g_MySelf.m_nCurrX - 10 to g_MySelf.m_nCurrX + 10 do begin
    for nY := g_MySelf.m_nCurrY - 10 to g_MySelf.m_nCurrY + 10 do begin
      Actor := FindActorXY(nX, nY);
      if (Actor <> nil) and (Actor <> g_MySelf) and (not Actor.m_boDeath) then begin
        mx := (SCREENWIDTH - 120) + (Actor.m_nCurrX * 48) div 32 - rc.Left;
        my := (Actor.m_nCurrY * 32) div 32 - rc.Top;

        case Actor.m_btRace of //
          50, 45, 12: btColor := 218;
          0: btColor := 255;
          else btColor := 249;
        end; // case
        for X := 0 to 1 do
          for Y := 0 to 1 do
            Surface.Pixels[mx + X, my + Y] := btColor
      end;
    end;
  end;
end;


{-----------------------------------------------------------------------}


procedure TPlayScene.PlayScene(MSurface: TDirectDrawSurface);
  function CheckOverlappedObject(myrc, obrc: TRect): Boolean;
  begin
    if (obrc.Right > myrc.Left) and (obrc.Left < myrc.Right) and
      (obrc.Bottom > myrc.Top) and (obrc.Top < myrc.Bottom) then
      Result := True
    else Result := FALSE;
  end;

var
  i, j, k, n, m, mmm, ix, iy, line, defx, defy, wunit, fridx, ani, anitick, ax, ay, idx, drawingbottomline: Integer;
  dsurface, d: TDirectDrawSurface;
  blend, movetick: Boolean;
  //myrc, obrc: TRect;
  DropItem: pTDropItem;
  evn: TClEvent;
  Actor: TActor;
  meff: TMagicEff;
  msgstr: string;
  ShowItem: pTShowItem;
  nFColor, nBColor: Integer;
begin
  drawingbottomline := 0; //jacky
  if (g_MySelf = nil) then begin
    msgstr := 'ÕýÔÚÍË³öÓÎÏ·£¬ÇëÉÔºò...';
    with MSurface.Canvas do begin
      SetBkMode(Handle, TRANSPARENT);
      BoldTextOut(MSurface, (SCREENWIDTH - TextWidth(msgstr)) div 2, (SCREENHEIGHT - 600) + 200,
        clWhite, clBlack, msgstr);
      Release;
    end;
    Exit;
  end;

  g_boDoFastFadeOut := FALSE;

  //Ä³¸¯ÅÍ¿¡µé¿¡°Ô ¸Þ¼¼Áö¸¦ Àü´Þ
  movetick := FALSE;
  if GetTickCount - m_dwMoveTime >= 100 then begin
    m_dwMoveTime := GetTickCount; //ÀÌµ¿ÀÇ µ¿±âÈ­
    movetick := True; //ÀÌµ¿ Æ½
    Inc(m_nMoveStepCount);
    if m_nMoveStepCount > 1 then m_nMoveStepCount := 0;
  end;
  if GetTickCount - m_dwAniTime >= 50 then begin
    m_dwAniTime := GetTickCount;
    Inc(m_nAniCount);
    if m_nAniCount > 100000 then m_nAniCount := 0;
  end;

  try
    i := 0; //¿©±â´Â ¸Þ¼¼Áö¸¸ Ã³¸®ÇÔ
    while True do begin //Frame Ã³¸®´Â ¿©±â¼­ ¾ÈÇÔ.
      if i >= m_ActorList.count then break;
      Actor := m_ActorList[i];
      if movetick then Actor.m_boLockEndFrame := FALSE;
      if not Actor.m_boLockEndFrame then begin
        Actor.ProcMsg; //¸Þ¼¼Áö Ã³¸®ÇÏ¸é¼­ actor°¡ Áö¿öÁú ¼ö ÀÖÀ½.
        if movetick then
          if Actor.Move(m_nMoveStepCount) then begin //µ¿±âÈ­ÇØ¼­ ¿òÁ÷ÀÓ
            Inc(i);
            continue;
          end;
        Actor.Run; //
        if Actor <> g_MySelf then Actor.ProcHurryMsg;
      end;
      if Actor = g_MySelf then Actor.ProcHurryMsg;
      //
      if Actor.m_nWaitForRecogId <> 0 then begin
        if Actor.IsIdle then begin
          DelChangeFace(Actor.m_nWaitForRecogId);
          NewActor(Actor.m_nWaitForRecogId, Actor.m_nCurrX, Actor.m_nCurrY, Actor.m_btDir, Actor.m_nWaitForFeature, Actor.m_nWaitForStatus);
          Actor.m_nWaitForRecogId := 0;
          Actor.m_boDelActor := True;
        end;
      end;
      if Actor.m_boDelActor then begin
        //actor.Free;
        g_FreeActorList.Add(Actor);
        m_ActorList.Delete(i);
        if g_TargetCret = Actor then g_TargetCret := nil;
        if g_FocusCret = Actor then g_FocusCret := nil;
        if g_MagicTarget = Actor then g_MagicTarget := nil;
      end else
        Inc(i);
    end;
  except
    DebugOutStr('101');
  end;

  try
    i := 0;
    while True do begin
      if i >= m_GroundEffectList.count then break;
      meff := m_GroundEffectList[i];
      if meff.m_boActive then begin
        if not meff.Run then begin //¸¶¹ýÈ¿°ú
          meff.Free;
          m_GroundEffectList.Delete(i);
          continue;
        end;
      end;
      Inc(i);
    end;
    i := 0;
    while True do begin
      if i >= m_EffectList.count then break;
      meff := m_EffectList[i];
      if meff.m_boActive then begin
        if not meff.Run then begin //¸¶¹ýÈ¿°ú
          meff.Free;
          m_EffectList.Delete(i);
          continue;
        end;
      end;
      Inc(i);
    end;
    i := 0;
    while True do begin
      if i >= m_FlyList.count then break;
      meff := m_FlyList[i];
      if meff.m_boActive then begin
        if not meff.Run then begin //µµ³¢,È­»ìµî ³¯¾Æ°¡´Â°Í
          meff.Free;
          m_FlyList.Delete(i);
          continue;
        end;
      end;
      Inc(i);
    end;

    EventMan.Execute;
  except
    DebugOutStr('102');
  end;

  try
    ClearDropItem();
    {
    //Çå³ý³¬¹ýÏÔÊ¾·¶Î§µÄÎïÆ·Êý¾Ý
    for k:=0 to g_DropedItemList.Count - 1 do begin
      DropItem:= PTDropItem(g_DropedItemList[k]);
      if DropItem <> nil then begin
        if (Abs(DropItem.x - Myself.m_nCurrX) > 30) and (Abs(DropItem.y - Myself.m_nCurrY) > 30) then begin
          Dispose (PTDropItem (g_DropedItemList[k]));
          g_DropedItemList.Delete (k);
          break;  //ÇÑ¹ø¿¡ ÇÑ°³¾¿..
        end;
      end;
    end;
    }
    //»ç¶óÁø ´ÙÀÌ³ª¹Í¿ÀºêÁ§Æ® °Ë»ç
    for k := 0 to EventMan.EventList.count - 1 do begin
      evn := TClEvent(EventMan.EventList[k]);
      if (abs(evn.m_nX - g_MySelf.m_nCurrX) > 30) and (abs(evn.m_nY - g_MySelf.m_nCurrY) > 30) then begin
        evn.Free;
        EventMan.EventList.Delete(k);
        break; //ÇÑ¹ø¿¡ ÇÑ°³¾¿
      end;
    end;
  except
    DebugOutStr('103');
  end;

  try
    with Map.m_ClientRect do begin
{$IF SWH = SWH800}
      Left := g_MySelf.m_nRx - 9;
      Top := g_MySelf.m_nRy - 9;
      Right := g_MySelf.m_nRx + 9; // ¿À¸¥ÂÊ Â¥Åõ¸® ±×¸²
      Bottom := g_MySelf.m_nRy + 8;
{$ELSEIF SWH = SWH1024}
      Left := g_MySelf.m_nRx - 12;
      Top := g_MySelf.m_nRy - 12;
      Right := g_MySelf.m_nRx + 12; //
      Bottom := g_MySelf.m_nRy + 15;
{$IFEND}
    end;
    Map.UpdateMapPos(g_MySelf.m_nRx, g_MySelf.m_nRy);

    ///////////////////////
    //ViewFog := FALSE;
    ///////////////////////

    if g_boNoDarkness or (g_MySelf.m_boDeath) then begin
      g_boViewFog := FALSE;
    end;

    if g_boViewFog then begin //Æ÷±×
      ZeroMemory(m_PFogScreen, MAPSURFACEHEIGHT * MAPSURFACEWIDTH);
      ClearLightMap;
    end;

    //   drawingbottomline := 450;
    drawingbottomline := SCREENHEIGHT;
    m_ObjSurface.Fill(0);

    DrawTileMap;

    m_ObjSurface.Draw(0, 0,
      Rect(UNITX * 3 + g_MySelf.m_nShiftX,
      UNITY * 2 + g_MySelf.m_nShiftY,
      UNITX * 3 + g_MySelf.m_nShiftX + MAPSURFACEWIDTH,
      UNITY * 2 + g_MySelf.m_nShiftY + MAPSURFACEHEIGHT),
      m_MapSurface,
      FALSE);

  except
    DebugOutStr('104');
  end;

  defx := -UNITX * 2 - g_MySelf.m_nShiftX + AAX + 14;
  defy := -UNITY * 2 - g_MySelf.m_nShiftY;
  m_nDefXX := defx;
  m_nDefYY := defy;

  try
    m := defy - UNITY;
    for j := (Map.m_ClientRect.Top - Map.m_nBlockTop) to (Map.m_ClientRect.Bottom - Map.m_nBlockTop + LONGHEIGHT_IMAGE) do begin
      if j < 0 then begin
        Inc(m, UNITY); continue; end;
      n := defx - UNITX * 2;
      //*** 48*32 Å¸ÀÏÇü ¿ÀºêÁ§Æ® ±×¸®±â
      for i := (Map.m_ClientRect.Left - Map.m_nBlockLeft - 2) to (Map.m_ClientRect.Right - Map.m_nBlockLeft + 2) do begin
        if (i >= 0) and (i < LOGICALMAPUNIT * 3) and (j >= 0) and (j < LOGICALMAPUNIT * 3) then begin
          fridx := (Map.m_MArr[i, j].wFrImg) and $7FFF;
          if fridx > 0 then begin
            ani := Map.m_MArr[i, j].btAniFrame;
            wunit := Map.m_MArr[i, j].btArea;
            if (ani and $80) > 0 then begin
              blend := True;
              ani := ani and $7F;
            end;
            if ani > 0 then begin
              anitick := Map.m_MArr[i, j].btAniTick;
              fridx := fridx + (m_nAniCount mod (ani + (ani * anitick))) div (1 + anitick);
            end;
            if (Map.m_MArr[i, j].btDoorOffset and $80) > 0 then begin //¿­¸²
              if (Map.m_MArr[i, j].btDoorIndex and $7F) > 0 then //¹®À¸·Î Ç¥½ÃµÈ °Í¸¸
                fridx := fridx + (Map.m_MArr[i, j].btDoorOffset and $7F); //¿­¸° ¹®
            end;
            fridx := fridx - 1;
            // ¹°Ã¼ ±×¸²
            dsurface := GetObjs(wunit, fridx);
            if dsurface <> nil then begin
              if (dsurface.Width = 48) and (dsurface.Height = 32) then begin
                mmm := m + UNITY - dsurface.Height;
                if (n + dsurface.Width > 0) and (n <= SCREENWIDTH) and (mmm + dsurface.Height > 0) and (mmm < drawingbottomline) then begin
                  m_ObjSurface.Draw(n, mmm, dsurface.ClientRect, dsurface, True)
                end else begin
                  if mmm < drawingbottomline then begin //ºÒÇÊ¿äÇÏ°Ô ±×¸®´Â °ÍÀ» ÇÇÇÔ
                    m_ObjSurface.Draw(n, mmm, dsurface.ClientRect, dsurface, True)
                  end;
                end;
              end;
            end;
          end;
        end;
        Inc(n, UNITX);
      end;
      Inc(m, UNITY);
    end;

    //¶¥¹Ù´Ú¿¡ ±×·ÁÁö´Â ¸¶¹ý
    for k := 0 to m_GroundEffectList.count - 1 do begin
      meff := TMagicEff(m_GroundEffectList[k]);
      //if j = (meff.Ry - Map.BlockTop) then begin
      meff.DrawEff(m_ObjSurface);
      if g_boViewFog then begin
        AddLight(meff.rx, meff.ry, 0, 0, meff.light, FALSE);
      end;
    end;

  except
    DebugOutStr('105');
  end;

  try
    m := defy - UNITY;
    for j := (Map.m_ClientRect.Top - Map.m_nBlockTop) to (Map.m_ClientRect.Bottom - Map.m_nBlockTop + LONGHEIGHT_IMAGE) do begin
      if j < 0 then begin
        Inc(m, UNITY); continue; end;
      n := defx - UNITX * 2;
      //*** ¹è°æ¿ÀºêÁ§Æ® ±×¸®±â
      for i := (Map.m_ClientRect.Left - Map.m_nBlockLeft - 2) to (Map.m_ClientRect.Right - Map.m_nBlockLeft + 2) do begin
        if (i >= 0) and (i < LOGICALMAPUNIT * 3) and (j >= 0) and (j < LOGICALMAPUNIT * 3) then begin
          fridx := (Map.m_MArr[i, j].wFrImg) and $7FFF;
          if fridx > 0 then begin
            blend := FALSE;
            wunit := Map.m_MArr[i, j].btArea;
            //¿¡´Ï¸ÞÀÌ¼Ç
            ani := Map.m_MArr[i, j].btAniFrame;
            if (ani and $80) > 0 then begin
              blend := True;
              ani := ani and $7F;
            end;
            if ani > 0 then begin
              anitick := Map.m_MArr[i, j].btAniTick;
              fridx := fridx + (m_nAniCount mod (ani + (ani * anitick))) div (1 + anitick);
            end;
            if (Map.m_MArr[i, j].btDoorOffset and $80) > 0 then begin //¿­¸²
              if (Map.m_MArr[i, j].btDoorIndex and $7F) > 0 then //¹®À¸·Î Ç¥½ÃµÈ °Í¸¸
                fridx := fridx + (Map.m_MArr[i, j].btDoorOffset and $7F); //¿­¸° ¹®
            end;
            fridx := fridx - 1;
            // ¹°Ã¼ ±×¸²
            if not blend then begin
              dsurface := GetObjs(wunit, fridx);
              if dsurface <> nil then begin
                if (dsurface.Width <> 48) or (dsurface.Height <> 32) then begin
                  mmm := m + UNITY - dsurface.Height;
                  if (n + dsurface.Width > 0) and (n <= SCREENWIDTH) and (mmm + dsurface.Height > 0) and (mmm < drawingbottomline) then begin
                    m_ObjSurface.Draw(n, mmm, dsurface.ClientRect, dsurface, True)
                  end else begin
                    if mmm < drawingbottomline then begin //ºÒÇÊ¿äÇÏ°Ô ±×¸®´Â °ÍÀ» ÇÇÇÔ
                      m_ObjSurface.Draw(n, mmm, dsurface.ClientRect, dsurface, True)
                    end;
                  end;
                end;
              end;
            end else begin
              dsurface := GetObjsEx(wunit, fridx, ax, ay);
              if dsurface <> nil then begin
                mmm := m + ay - 68; //UNITY - DSurface.Height;
                if (n > 0) and (mmm + dsurface.Height > 0) and (n + dsurface.Width < SCREENWIDTH) and (mmm < drawingbottomline) then begin
                  DrawBlend(m_ObjSurface, n + ax - 2, mmm, dsurface, 1);
                end else begin
                  if mmm < drawingbottomline then begin //ºÒÇÊ¿äÇÏ°Ô ±×¸®´Â °ÍÀ» ÇÇÇÔ
                    DrawBlend(m_ObjSurface, n + ax - 2, mmm, dsurface, 1);
                  end;
                end;
              end;
            end;
          end;

        end;
        Inc(n, UNITX);
      end;

      if (j <= (Map.m_ClientRect.Bottom - Map.m_nBlockTop)) and (not g_boServerChanging) then begin

        //*** ¹Ù´Ú¿¡ º¯°æµÈ ÈëÀÇ ÈçÀû
        for k := 0 to EventMan.EventList.count - 1 do begin
          evn := TClEvent(EventMan.EventList[k]);
          if j = (evn.m_nY - Map.m_nBlockTop) then begin
            evn.DrawEvent(m_ObjSurface,
              (evn.m_nX - Map.m_ClientRect.Left) * UNITX + defx,
              m);
          end;
        end;

        if g_boDrawDropItem then begin

          //ÏÔÊ¾µØÃæÎïÆ·ÍâÐÎ
          for k := 0 to g_DropedItemList.count - 1 do begin
            DropItem := pTDropItem(g_DropedItemList[k]);
            if DropItem <> nil then begin
              if j = (DropItem.Y - Map.m_nBlockTop) then begin
                d := g_WDnItemImages.Images[DropItem.looks];
                if d <> nil then begin
                  ix := (DropItem.X - Map.m_ClientRect.Left) * UNITX + defx + SOFFX; // + actor.ShiftX;
                  iy := m; // + actor.ShiftY;
                  if DropItem = g_FocusItem then begin
                    g_ImgMixSurface.Draw(0, 0, d.ClientRect, d, FALSE);
                    DrawEffect(0, 0, d.Width, d.Height, g_ImgMixSurface, ceBright);
                    m_ObjSurface.Draw(ix + HALFX - (d.Width div 2),
                      iy + HALFY - (d.Height div 2),
                      d.ClientRect,
                      g_ImgMixSurface, True);
                  end else begin
                    m_ObjSurface.Draw(ix + HALFX - (d.Width div 2),
                      iy + HALFY - (d.Height div 2),
                      d.ClientRect,
                      d, True);
                  end;

                end;
              end;
            end;
          end;
        end;

        //*** ÏÔÊ¾ÈËÎïËµ»°ÐÅÏ¢
        for k := 0 to m_ActorList.count - 1 do begin
          Actor := m_ActorList[k];
          if (j = Actor.m_nRy - Map.m_nBlockTop - Actor.m_nDownDrawLevel) then begin
            Actor.m_nSayX := (Actor.m_nRx - Map.m_ClientRect.Left) * UNITX + defx + Actor.m_nShiftX + 24;
            if Actor.m_boDeath then
              Actor.m_nSayY := m + UNITY + Actor.m_nShiftY + 16 - 60 + (Actor.m_nDownDrawLevel * UNITY)
            else Actor.m_nSayY := m + UNITY + Actor.m_nShiftY + 16 - 95 + (Actor.m_nDownDrawLevel * UNITY);
            Actor.DrawChr(m_ObjSurface, (Actor.m_nRx - Map.m_ClientRect.Left) * UNITX + defx,
              m + (Actor.m_nDownDrawLevel * UNITY),
              FALSE, True);
          end;
        end;
        for k := 0 to m_FlyList.count - 1 do begin
          meff := TMagicEff(m_FlyList[k]);
          if j = (meff.ry - Map.m_nBlockTop) then
            meff.DrawEff(m_ObjSurface);
        end;

      end;
      Inc(m, UNITY);
    end;
  except
    DebugOutStr('106');
  end;


  try
    if g_boViewFog then begin
      m := defy - UNITY * 4;
      for j := (Map.m_ClientRect.Top - Map.m_nBlockTop - 4) to (Map.m_ClientRect.Bottom - Map.m_nBlockTop + LONGHEIGHT_IMAGE) do begin
        if j < 0 then begin
          Inc(m, UNITY); continue; end;
        n := defx - UNITX * 5;
        //¹è°æ Æ÷±× ±×¸®±â
        for i := (Map.m_ClientRect.Left - Map.m_nBlockLeft - 5) to (Map.m_ClientRect.Right - Map.m_nBlockLeft + 5) do begin
          if (i >= 0) and (i < LOGICALMAPUNIT * 3) and (j >= 0) and (j < LOGICALMAPUNIT * 3) then begin
            idx := Map.m_MArr[i, j].btLight;
            if idx > 0 then begin
              AddLight(i + Map.m_nBlockLeft, j + Map.m_nBlockTop, 0, 0, idx, FALSE);
            end;
          end;
          Inc(n, UNITX);
        end;
        Inc(m, UNITY);
      end;

      //Ä³¸¯ÅÍ Æ÷±× ±×¸®±â
      if m_ActorList.count > 0 then begin
        for k := 0 to m_ActorList.count - 1 do begin
          Actor := m_ActorList[k];
          if (Actor = g_MySelf) or (Actor.light > 0) then
            AddLight(Actor.m_nRx, Actor.m_nRy, Actor.m_nShiftX, Actor.m_nShiftY, Actor.light, Actor = g_MySelf);
        end;
      end else begin
        if g_MySelf <> nil then
          AddLight(g_MySelf.m_nRx, g_MySelf.m_nRy, g_MySelf.m_nShiftX, g_MySelf.m_nShiftY, g_MySelf.light, True);
      end;
    end;
  except
    DebugOutStr('107');
  end;

  if not g_boServerChanging then begin
    try
      //**** ÁÖÀÎ°ø Ä³¸¯ÅÍ ±×¸®±â
      if not g_boCheckBadMapMode then
        if g_MySelf.m_nState and $00800000 = 0 then //Åõ¸íÀÌ ¾Æ´Ï¸é
          g_MySelf.DrawChr(m_ObjSurface, (g_MySelf.m_nRx - Map.m_ClientRect.Left) * UNITX + defx, (g_MySelf.m_nRy - Map.m_ClientRect.Top - 1) * UNITY + defy, True, FALSE);

      //****
      if (g_FocusCret <> nil) then begin
        if IsValidActor(g_FocusCret) and (g_FocusCret <> g_MySelf) then
          //            if (actor.m_btRace <> 81) or (FocusCret.State and $00800000 = 0) then //Jacky
          if (g_FocusCret.m_nState and $00800000 = 0) then //Jacky
            g_FocusCret.DrawChr(m_ObjSurface,
              (g_FocusCret.m_nRx - Map.m_ClientRect.Left) * UNITX + defx,
              (g_FocusCret.m_nRy - Map.m_ClientRect.Top - 1) * UNITY + defy, True, FALSE);
      end;
      if (g_MagicTarget <> nil) then begin
        if IsValidActor(g_MagicTarget) and (g_MagicTarget <> g_MySelf) then
          if g_MagicTarget.m_nState and $00800000 = 0 then //Åõ¸íÀÌ ¾Æ´Ï¸é
            g_MagicTarget.DrawChr(m_ObjSurface,
              (g_MagicTarget.m_nRx - Map.m_ClientRect.Left) * UNITX + defx,
              (g_MagicTarget.m_nRy - Map.m_ClientRect.Top - 1) * UNITY + defy, True, FALSE);
      end;
    except
      DebugOutStr('108');
    end;
  end;

  try
    //**** ¸¶¹ý È¿°ú

    for k := 0 to m_ActorList.count - 1 do begin
      Actor := m_ActorList[k];
      Actor.DrawEff(m_ObjSurface,
        (Actor.m_nRx - Map.m_ClientRect.Left) * UNITX + defx,
        (Actor.m_nRy - Map.m_ClientRect.Top - 1) * UNITY + defy);
    end;

    for k := 0 to m_EffectList.count - 1 do begin
      meff := TMagicEff(m_EffectList[k]);
      //if j = (meff.Ry - Map.BlockTop) then begin
      meff.DrawEff(m_ObjSurface);
      if g_boViewFog then begin
        AddLight(meff.rx, meff.ry, 0, 0, meff.light, FALSE);
      end;
    end;
    if g_boViewFog then begin
      for k := 0 to EventMan.EventList.count - 1 do begin
        evn := TClEvent(EventMan.EventList[k]);
        if evn.m_nLight > 0 then
          AddLight(evn.m_nX, evn.m_nY, 0, 0, evn.m_nLight, FALSE);
      end;
    end;
  except
    DebugOutStr('109');
  end;

  //µØÃæÎïÆ·ÉÁÁÁ
  try
    for k := 0 to g_DropedItemList.count - 1 do begin
      DropItem := pTDropItem(g_DropedItemList[k]);
      if DropItem <> nil then begin
        //if GetTickCount - DropItem.FlashTime > g_dwDropItemFlashTime {5 * 1000} then begin
          if GetTickCount - DropItem.FlashTime > 5000 then begin

          DropItem.FlashTime := GetTickCount;
          DropItem.BoFlash := True;
          DropItem.FlashStepTime := GetTickCount;
          DropItem.FlashStep := 0;
        end;
        ix := (DropItem.X - Map.m_ClientRect.Left) * UNITX + defx + SOFFX;
        iy := (DropItem.Y - Map.m_ClientRect.Top - 1) * UNITY + defy + SOFFY;
        if DropItem.BoFlash then begin
          if GetTickCount - DropItem.FlashStepTime >= 20 then begin
            DropItem.FlashStepTime := GetTickCount;
            Inc(DropItem.FlashStep);
          end;
          if (DropItem.FlashStep >= 0) and (DropItem.FlashStep < 10) then begin
            dsurface := g_WMainImages.GetCachedImage(FLASHBASE + DropItem.FlashStep, ax, ay);
            DrawBlend(m_ObjSurface, ix + ax, iy + ay, dsurface, 1);
          end else DropItem.BoFlash := FALSE;
        end;
        ShowItem := GetShowItem(DropItem.name);
        if (DropItem <> g_FocusItem) and (((ShowItem <> nil) and (ShowItem.boShowName)) or g_boShowAllItem) then begin
          //ÏÔÊ¾µØÃæÎïÆ·Ãû³Æ
          if ShowItem <> nil then begin
            nFColor := ShowItem.nFColor;
            nBColor := ShowItem.nBColor;
          end else begin
            nFColor := clWhite;
            nBColor := clBlack;
          end;

          with m_ObjSurface.Canvas do begin
            SetBkMode(Handle, TRANSPARENT);
            BoldTextOut(m_ObjSurface,
              ix + HALFX - TextWidth(DropItem.name) div 2,
              iy + HALFY - TextHeight(DropItem.name) * 2, // div 2,
              nFColor,
              nBColor,
              DropItem.name);
            Release;
          end;
        end;
      end;
    end;
  except
    DebugOutStr('110');
  end;
  try
    //   g_boViewFog:=False;      //Jacky ÃâÀ¯
    if g_boViewFog and not g_boForceNotViewFog then begin
      ApplyLightMap;
      DrawFog(m_ObjSurface, m_PFogScreen, m_nFogWidth);
      MSurface.Draw(SOFFX, SOFFY, m_ObjSurface.ClientRect, m_ObjSurface, FALSE);
    end else begin
      if g_MySelf.m_boDeath then //ÈËÎïËÀÍö£¬ÏÔÊ¾ºÚ°×»­Ãæ
        DrawEffect(0, 0, m_ObjSurface.Width, m_ObjSurface.Height, m_ObjSurface, g_DeathColorEffect {ceGrayScale});


      MSurface.Draw(SOFFX, SOFFY, m_ObjSurface.ClientRect, m_ObjSurface, FALSE);
    end;
  except
    DebugOutStr('111');
  end;

  if g_boViewMiniMap then begin
    DrawMiniMap(MSurface);
  end;


end;

{-------------------------------------------------------}

//cx, cy, tx, ty : ¸ÊÀÇ ÁÂÇ¥
procedure TPlayScene.NewMagic(aowner: TActor;
  magid, magnumb {Effect}, cx, cy, tx, ty, targetcode: Integer;
  mtype: TMagicType; //EffectType
  Recusion: Boolean;
  anitime: Integer;
  var bofly: Boolean);
var
  i, scx, scy, sctx, scty, effnum: Integer;
  meff: TMagicEff;
  target: TActor;
  wimg: TWMImages;
begin
  bofly := FALSE;
  if magid <> 111 then //
    for i := 0 to m_EffectList.count - 1 do
      if TMagicEff(m_EffectList[i]).ServerMagicId = magid then
        Exit; //
  ScreenXYfromMCXY(cx, cy, scx, scy);
  ScreenXYfromMCXY(tx, ty, sctx, scty);
  if magnumb > 0 then GetEffectBase(magnumb - 1, 0, wimg, effnum) //magnumb{Effect}
  else effnum := -magnumb;
  target := FindActor(targetcode);

  meff := nil;
  case mtype of //EffectType
    mtReady, mtFly, mtFlyAxe: begin
        meff := TMagicEff.Create(magid {ÌæÎªmagnumb£¬»÷ÖÐºóµÄÐ§¹û¸Ä±äÁË}, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
        meff.TargetActor := target;
        if magnumb = 39 then begin
          meff.frame := 4;
          if wimg <> nil then
            meff.ImgLib := wimg;
        end;
        bofly := True;
      end;
    mtExplosion:
      case magnumb of
        18: begin //ÓÕ»óÖ®¹â
            meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
            meff.MagExplosionBase := 1570;
            meff.TargetActor := target;
            meff.NextFrameTime := 80;
          end;
        21: begin //±¬ÁÑ»ðÑæ
            meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
            meff.MagExplosionBase := 1660;
            meff.TargetActor := nil; //target;
            meff.NextFrameTime := 80;
            meff.ExplosionFrame := 20;
            meff.light := 3;
          end;
        26: begin //ÐÄÁéÆôÊ¾
            meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
            meff.MagExplosionBase := 3990;
            meff.TargetActor := target;
            meff.NextFrameTime := 80;
            meff.ExplosionFrame := 10;
            meff.light := 2;
          end;
        27: begin //ÈºÌåÖÎÁÆÊõ
            meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
            meff.MagExplosionBase := 1800;
            meff.TargetActor := nil; //target;
            meff.NextFrameTime := 80;
            meff.ExplosionFrame := 10;
            meff.light := 3;
          end;
        30: begin //Ê¥ÑÔÊõ
            meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
            meff.MagExplosionBase := 3930;
            meff.TargetActor := target;
            meff.NextFrameTime := 80;
            meff.ExplosionFrame := 16;
            meff.light := 3;
          end;
        31: begin //±ùÅØÏø
            meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
            meff.MagExplosionBase := 3850;
            meff.TargetActor := nil; //target;
            meff.NextFrameTime := 80;
            meff.ExplosionFrame := 20;
            meff.light := 3;
          end;
        34: begin //ÃðÌì»ð
            meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
            meff.MagExplosionBase := 140;
            meff.TargetActor := target; //target;
            meff.NextFrameTime := 80;
            meff.ExplosionFrame := 20;
            meff.light := 3;
            if wimg <> nil then
              meff.ImgLib := wimg;
          end;
        40: begin // ¾»»¯Êõ
            meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
            meff.MagExplosionBase := 620;
            meff.TargetActor := nil; //target;
            meff.NextFrameTime := 100;
            meff.ExplosionFrame := 20;
            meff.light := 3;
            if wimg <> nil then
              meff.ImgLib := wimg;
          end;
        45: begin //»ðÁúÆøÑæ
            meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
            meff.MagExplosionBase := 920;
            meff.TargetActor := nil; //target;
            meff.NextFrameTime := 100;
            meff.ExplosionFrame := 20;
            meff.light := 3;
            if wimg <> nil then
              meff.ImgLib := wimg;
          end;
        47: begin //ì«·çÆÆ
            meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
            meff.MagExplosionBase := 1010;
            meff.TargetActor := nil; //target;
            meff.NextFrameTime := 100;
            meff.ExplosionFrame := 20;
            meff.light := 3;
            if wimg <> nil then
              meff.ImgLib := wimg;
          end;
        48: begin //ÑªÖä
            meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
            meff.MagExplosionBase := 1060;
            meff.TargetActor := nil; //target;
            meff.NextFrameTime := 50;
            meff.ExplosionFrame := 40;
            meff.light := 3;
            if wimg <> nil then
              meff.ImgLib := wimg;
          end;
        49: begin //÷¼÷ÃÖä
            meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
            meff.MagExplosionBase := 1110;
            meff.TargetActor := nil; //target;
            meff.NextFrameTime := 100;
            meff.ExplosionFrame := 10;
            meff.light := 3;
            if wimg <> nil then
              meff.ImgLib := wimg;
          end;
        else begin //Ä¬ÈÏ
            meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
            meff.TargetActor := target;
            meff.NextFrameTime := 80;
          end;
      end;
    mtFireWind:
      meff := nil; //È¿°ú ¾øÀ½
    mtFireGun: //È­¿°¹æ»ç
      meff := TFireGunEffect.Create(930, scx, scy, sctx, scty);
    mtThunder: begin
        //meff := TThuderEffect.Create (950, sctx, scty, nil); //target);
        meff := TThuderEffect.Create(10, sctx, scty, nil); //target);
        meff.ExplosionFrame := 6;
        meff.ImgLib := g_WMagic2Images;
      end;
    mtLightingThunder:
      meff := TLightingThunder.Create(970, scx, scy, sctx, scty, target);
    mtExploBujauk: begin
        case magnumb of
          10: begin //
              meff := TExploBujaukEffect.Create(1160, scx, scy, sctx, scty, target);
              meff.MagExplosionBase := 1360;
            end;
          17: begin //
              meff := TExploBujaukEffect.Create(1160, scx, scy, sctx, scty, target);
              meff.MagExplosionBase := 1540;
            end;
        end;
        bofly := True;
      end;
    mtBujaukGroundEffect: begin
        meff := TBujaukGroundEffect.Create(1160, magnumb, scx, scy, sctx, scty);
        case magnumb of
          11: meff.ExplosionFrame := 16; //
          12: meff.ExplosionFrame := 16; //
          46: meff.ExplosionFrame := 24;
        end;
        bofly := True;
      end;
    mtKyulKai: begin
        meff := nil; //TKyulKai.Create (1380, scx, scy, sctx, scty);
      end;
    mt12: begin

      end;
    mt13: begin
        meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
        if meff <> nil then begin
          case magnumb of
            32: begin
                meff.ImgLib := frmMain.WMon21Img;
                meff.MagExplosionBase := 3580;
                meff.TargetActor := target;
                meff.light := 3;
                meff.NextFrameTime := 20;
              end;
            37: begin
                meff.ImgLib := frmMain.WMon22Img;
                meff.MagExplosionBase := 3520;
                meff.TargetActor := target;
                meff.light := 5;
                meff.NextFrameTime := 20;
              end;
          end;
        end;
      end;
    mt14: begin
        meff := TThuderEffect.Create(140, sctx, scty, nil); //target);
        meff.ExplosionFrame := 10;
        meff.ImgLib := g_WMagic2Images;
      end;
    mt15: begin
        meff := TFlyingBug.Create(magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
        meff.TargetActor := target;
        bofly := True;
      end;
    mt16: begin

      end;
  end;
  if (meff = nil) then Exit;


  meff.TargetRx := tx;
  meff.TargetRy := ty;
  if meff.TargetActor <> nil then begin
    meff.TargetRx := TActor(meff.TargetActor).m_nCurrX;
    meff.TargetRy := TActor(meff.TargetActor).m_nCurrY;
  end;
  meff.MagOwner := aowner;
  m_EffectList.Add(meff);
end;

procedure TPlayScene.DelMagic(magid: Integer);
var
  i: Integer;
begin
  for i := 0 to m_EffectList.count - 1 do begin
    if TMagicEff(m_EffectList[i]).ServerMagicId = magid then begin
      TMagicEff(m_EffectList[i]).Free;
      m_EffectList.Delete(i);
      break;
    end;
  end;
end;

//cx, cy, tx, ty : ¸ÊÀÇ ÁÂÇ¥
function TPlayScene.NewFlyObject(aowner: TActor; cx, cy, tx, ty, targetcode: Integer; mtype: TMagicType): TMagicEff;
var
  i, scx, scy, sctx, scty: Integer;
  meff: TMagicEff;
begin
  ScreenXYfromMCXY(cx, cy, scx, scy);
  ScreenXYfromMCXY(tx, ty, sctx, scty);
  case mtype of
    mtFlyArrow: meff := TFlyingArrow.Create(1, 1, scx, scy, sctx, scty, mtype, True, 0);
    mt12: meff := TFlyingFireBall.Create(1, 1, scx, scy, sctx, scty, mtype, True, 0);
    mt15: meff := TFlyingBug.Create(1, 1, scx, scy, sctx, scty, mtype, True, 0);
    else meff := TFlyingAxe.Create(1, 1, scx, scy, sctx, scty, mtype, True, 0);
  end;
  meff.TargetRx := tx;
  meff.TargetRy := ty;
  meff.TargetActor := FindActor(targetcode);
  meff.MagOwner := aowner;
  m_FlyList.Add(meff);
  Result := meff;
end;

//Àü±â½î´Â Á»ºñÀÇ ¸¶¹ýÃ³·³ ±æ°Ô ³ª°¡´Â ¸¶¹ý
//effnum: °¢ ¹øÈ£¸¶´Ù Base°¡ ´Ù ´Ù¸£´Ù.
{function  NewStaticMagic (aowner: TActor; tx, ty, targetcode, effnum: integer);
var
   i, scx, scy, sctx, scty, effbase: integer;
   meff: TMagicEff;
begin
   ScreenXYfromMCXY (cx, cy, scx, scy);
   ScreenXYfromMCXY (tx, ty, sctx, scty);
   case effnum of
      1: effbase := 340;   //Á»ºñÀÇ ¶óÀÌÆ®´×ÀÇ ½ÃÀÛ À§Ä¡
      else exit;
   end;

   meff := TLightingEffect.Create (effbase, 1, 1, scx, scy, sctx, scty, mtype, TRUE, 0);
   meff.TargetRx := tx;
   meff.TargetRy := ty;
   meff.TargetActor := FindActor (targetcode);
   meff.MagOwner := aowner;
   FlyList.Add (meff);
   Result := meff;
end;  }

{-------------------------------------------------------}

//¸Ê ÁÂÇ¥°è·Î ¼¿ Áß¾ÓÀÇ ½ºÅ©¸° ÁÂÇ¥¸¦ ¾ò¾î³¿
{procedure TPlayScene.ScreenXYfromMCXY (cx, cy: integer; var sx, sy: integer);
begin
   if Myself = nil then exit;
   sx := -UNITX*2 - Myself.ShiftX + AAX + 14 + (cx - Map.ClientRect.Left) * UNITX + UNITX div 2;
   sy := -UNITY*3 - Myself.ShiftY + (cy - Map.ClientRect.Top) * UNITY + UNITY div 2;
end; }

procedure TPlayScene.ScreenXYfromMCXY(cx, cy: Integer; var sx, sy: Integer);
begin
  if g_MySelf = nil then Exit;
{$IF SWH = SWH800}
  sx := (cx - g_MySelf.m_nRx) * UNITX + 364 + UNITX div 2 - g_MySelf.m_nShiftX;
  sy := (cy - g_MySelf.m_nRy) * UNITY + 192 + UNITY div 2 - g_MySelf.m_nShiftY;
{$ELSEIF SWH = SWH1024}
  sx := (cx - g_MySelf.m_nRx) * UNITX + 485 {364} + UNITX div 2 - g_MySelf.m_nShiftX;
  sy := (cy - g_MySelf.m_nRy) * UNITY + 270 {192} + UNITY div 2 - g_MySelf.m_nShiftY;
{$IFEND}
end;

//ÆÁÄ»×ù±ê mx, my×ª»»³Éccx, ccyµØÍ¼×ù±ê
procedure TPlayScene.CXYfromMouseXY(mx, my: Integer; var ccx, ccy: Integer);
begin
  if g_MySelf = nil then Exit;
{$IF SWH = SWH800}
  ccx := Round((mx - 364 + g_MySelf.m_nShiftX - UNITX) / UNITX) + g_MySelf.m_nRx;
  ccy := Round((my - 192 + g_MySelf.m_nShiftY - UNITY) / UNITY) + g_MySelf.m_nRy;
{$ELSEIF SWH = SWH1024}
  ccx := Round((mx - 485 {364} + g_MySelf.m_nShiftX - UNITX) / UNITX) + g_MySelf.m_nRx;
  ccy := Round((my - 270 {192} + g_MySelf.m_nShiftY - UNITY) / UNITY) + g_MySelf.m_nRy;
{$IFEND}
end;

//È­¸éÁÂÇ¥·Î Ä³¸¯ÅÍ, ÇÈ¼¿ ´ÜÀ§·Î ¼±ÅÃ..
function TPlayScene.GetCharacter(X, Y, wantsel: Integer; var nowsel: Integer; liveonly: Boolean): TActor;
var
  k, i, ccx, ccy, dx, dy: Integer;
  a: TActor;
begin
  Result := nil;
  nowsel := -1;
  CXYfromMouseXY(X, Y, ccx, ccy);
  for k := ccy + 8 downto ccy - 1 do begin
    for i := m_ActorList.count - 1 downto 0 do
      if TActor(m_ActorList[i]) <> g_MySelf then begin
        a := TActor(m_ActorList[i]);
        if (not liveonly or not a.m_boDeath) and (a.m_boHoldPlace) and (a.m_boVisible) then begin
          if a.m_nCurrY = k then begin
            //´õ ³ÐÀº ¹üÀ§·Î ¼±ÅÃµÇ°Ô
            dx := (a.m_nRx - Map.m_ClientRect.Left) * UNITX + m_nDefXX + a.m_nPx + a.m_nShiftX;
            dy := (a.m_nRy - Map.m_ClientRect.Top - 1) * UNITY + m_nDefYY + a.m_nPy + a.m_nShiftY;
            if a.CheckSelect(X - dx, Y - dy) then begin
              Result := a;
              Inc(nowsel);
              if nowsel >= wantsel then
                Exit;
            end;
          end;
        end;
      end;
  end;
end;

//È¡µÃÊó±êËùÖ¸×ø±êµÄ½ÇÉ«
function TPlayScene.GetAttackFocusCharacter(X, Y, wantsel: Integer; var nowsel: Integer; liveonly: Boolean): TActor;
var
  k, i, ccx, ccy, dx, dy, centx, centy: Integer;
  a: TActor;
begin
  Result := GetCharacter(X, Y, wantsel, nowsel, liveonly);
  if Result = nil then begin
    nowsel := -1;
    CXYfromMouseXY(X, Y, ccx, ccy);
    for k := ccy + 8 downto ccy - 1 do begin
      for i := m_ActorList.count - 1 downto 0 do
        if TActor(m_ActorList[i]) <> g_MySelf then begin
          a := TActor(m_ActorList[i]);
          if (not liveonly or not a.m_boDeath) and (a.m_boHoldPlace) and (a.m_boVisible) then begin
            if a.m_nCurrY = k then begin
              //
              dx := (a.m_nRx - Map.m_ClientRect.Left) * UNITX + m_nDefXX + a.m_nPx + a.m_nShiftX;
              dy := (a.m_nRy - Map.m_ClientRect.Top - 1) * UNITY + m_nDefYY + a.m_nPy + a.m_nShiftY;
              if a.CharWidth > 40 then centx := (a.CharWidth - 40) div 2
              else centx := 0;
              if a.CharHeight > 70 then centy := (a.CharHeight - 70) div 2
              else centy := 0;
              if (X - dx >= centx) and (X - dx <= a.CharWidth - centx) and (Y - dy >= centy) and (Y - dy <= a.CharHeight - centy) then begin
                Result := a;
                Inc(nowsel);
                if nowsel >= wantsel then
                  Exit;
              end;
            end;
          end;
        end;
    end;
  end;
end;

function TPlayScene.IsSelectMyself(X, Y: Integer): Boolean;
var
  k, i, ccx, ccy, dx, dy: Integer;
begin
  Result := FALSE;
  CXYfromMouseXY(X, Y, ccx, ccy);
  for k := ccy + 2 downto ccy - 1 do begin
    if g_MySelf.m_nCurrY = k then begin
      //´õ ³ÐÀº ¹üÀ§·Î ¼±ÅÃµÇ°Ô
      dx := (g_MySelf.m_nRx - Map.m_ClientRect.Left) * UNITX + m_nDefXX + g_MySelf.m_nPx + g_MySelf.m_nShiftX;
      dy := (g_MySelf.m_nRy - Map.m_ClientRect.Top - 1) * UNITY + m_nDefYY + g_MySelf.m_nPy + g_MySelf.m_nShiftY;
      if g_MySelf.CheckSelect(X - dx, Y - dy) then begin
        Result := True;
        Exit;
      end;
    end;
  end;
end;
//È¡µÃÖ¸¶¨×ù±êµØÃæÎïÆ·
// x,y ÎªÆÁÄ»×ù±ê
function TPlayScene.GetDropItems(X, Y: Integer; var inames: string): pTDropItem; //È­¸éÁÂÇ¥·Î ¾ÆÀÌÅÛ
var
  k, i, ccx, ccy, ssx, ssy, dx, dy: Integer;
  DropItem: pTDropItem;
  S: TDirectDrawSurface;
  c: byte;
begin
  Result := nil;
  CXYfromMouseXY(X, Y, ccx, ccy);
  ScreenXYfromMCXY(ccx, ccy, ssx, ssy);
  dx := X - ssx;
  dy := Y - ssy;
  inames := '';
  for i := 0 to g_DropedItemList.count - 1 do begin
    DropItem := pTDropItem(g_DropedItemList[i]);
    if (DropItem.X = ccx) and (DropItem.Y = ccy) then begin

      S := g_WDnItemImages.Images[DropItem.looks];
      if S = nil then continue;
      dx := (X - ssx) + (S.Width div 2) - 3;
      dy := (Y - ssy) + (S.Height div 2);
      c := S.Pixels[dx, dy];
      if c <> 0 then begin

        if Result = nil then Result := DropItem;
        inames := inames + DropItem.name + '\';
        //break;
      end;
    end;
  end;
end;
procedure TPlayScene.GetXYDropItemsList(nX, nY: Integer; var ItemList: TList);
var
  i: Integer;
  DropItem: pTDropItem;
begin
  for i := 0 to g_DropedItemList.count - 1 do begin
    DropItem := g_DropedItemList[i];
    if (DropItem.X = nX) and (DropItem.Y = nY) then begin
      ItemList.Add(DropItem);
    end;
  end;
end;

function TPlayScene.GetXYDropItems(nX, nY: Integer): pTDropItem;
var
  i: Integer;
  DropItem: pTDropItem;
begin
  Result := nil;
  for i := 0 to g_DropedItemList.count - 1 do begin
    DropItem := g_DropedItemList[i];
    if (DropItem.X = nX) and (DropItem.Y = nY) then begin
      Result := DropItem;
      break;
    end;
  end;
end;

function TPlayScene.CanRun(sx, sy, ex, ey: Integer): Boolean;
var
  ndir, rx, ry: Integer;
begin
  ndir := GetNextDirection(sx, sy, ex, ey);
  rx := sx;
  ry := sy;
  GetNextPosXY(ndir, rx, ry);

  if Map.CanMove(rx, ry) and Map.CanMove(ex, ey) then
    Result := True
  else Result := FALSE;

  if CanWalkEx(rx, ry) and CanWalkEx(ex, ey) then
    Result := True
  else Result := FALSE;
end;
function TPlayScene.CanWalkEx(mx, my: Integer): Boolean;
begin
  Result := FALSE;
  if Map.CanMove(mx, my) then
    Result := not CrashManEx(mx, my);
end;
//´©ÈË
function TPlayScene.CrashManEx(mx, my: Integer): Boolean;
var
  i: Integer;
  Actor: TActor;
begin
  Result := FALSE;
  for i := 0 to m_ActorList.count - 1 do begin
    Actor := TActor(m_ActorList[i]);
    if (Actor.m_boVisible) and (Actor.m_boHoldPlace) and (not Actor.m_boDeath) and (Actor.m_nCurrX = mx) and (Actor.m_nCurrY = my) then begin
      //      DScreen.AddChatBoardString ('Actor.m_btRace ' + IntToStr(Actor.m_btRace),clWhite, clRed);
      if (Actor.m_btRace = RCC_USERHUMAN) and g_boCanRunHuman then continue;
      if (Actor.m_btRace = RCC_MERCHANT) and g_boCanRunNpc then continue;
      if ((Actor.m_btRace > RCC_USERHUMAN) and (Actor.m_btRace <> RCC_MERCHANT)) and g_boCanRunMon then continue;
      //m_btRace ´óÓÚ 0 ²¢²»µÈÓÚ 50 ÔòÎª¹ÖÎï
      Result := True;
      break;
    end;
  end;
end;

function TPlayScene.CanWalk(mx, my: Integer): Boolean;
begin
  Result := FALSE;
  if Map.CanMove(mx, my) then
    Result := not CrashMan(mx, my);
end;

function TPlayScene.CrashMan(mx, my: Integer): Boolean;
var
  i: Integer;
  a: TActor;
begin
  Result := FALSE;
  for i := 0 to m_ActorList.count - 1 do begin
    a := TActor(m_ActorList[i]);
    if (a.m_boVisible) and (a.m_boHoldPlace) and (not a.m_boDeath) and (a.m_nCurrX = mx) and (a.m_nCurrY = my) then begin
      Result := True;
      break;
    end;
  end;
end;

function TPlayScene.CanFly(mx, my: Integer): Boolean;
begin
  Result := Map.CanFly(mx, my);
end;


{------------------------ Actor ------------------------}

function TPlayScene.FindActor(id: Integer): TActor;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to m_ActorList.count - 1 do begin
    if TActor(m_ActorList[i]).m_nRecogId = id then begin
      Result := TActor(m_ActorList[i]);
      break;
    end;
  end;
end;

function TPlayScene.FindActor(sname: string): TActor;
var
  i: Integer;
  Actor: TActor;
begin
  Result := nil;
  for i := 0 to m_ActorList.count - 1 do begin
    Actor := TActor(m_ActorList[i]);
    if CompareText(Actor.m_sUserName, sname) = 0 then begin
      Result := Actor;
      break;
    end;
  end;
end;

function TPlayScene.FindActorXY(X, Y: Integer): TActor; //¸Ê ÁÂÇ¥·Î actor ¾òÀ½
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to m_ActorList.count - 1 do begin
    if (TActor(m_ActorList[i]).m_nCurrX = X) and (TActor(m_ActorList[i]).m_nCurrY = Y) then begin
      Result := TActor(m_ActorList[i]);
      if not Result.m_boDeath and Result.m_boVisible and Result.m_boHoldPlace then
        break;
    end;
  end;
end;

function TPlayScene.IsValidActor(Actor: TActor): Boolean;
var
  i: Integer;
begin
  Result := FALSE;
  for i := 0 to m_ActorList.count - 1 do begin
    if TActor(m_ActorList[i]) = Actor then begin
      Result := True;
      break;
    end;
  end;
end;

function TPlayScene.NewActor(chrid: Integer;
  cx: Word; //x
  cy: Word; //y
  cdir: Word;
  cfeature: Integer; //race, hair, dress, weapon
  cstate: Integer): TActor;
var
  i: Integer;
  Actor: TActor;
begin
  Result := nil; //jacky
  for i := 0 to m_ActorList.count - 1 do
    if TActor(m_ActorList[i]).m_nRecogId = chrid then begin
      Result := TActor(m_ActorList[i]);
      Exit; //ÀÌ¹Ì ÀÖÀ½
    end;
  if IsChangingFace(chrid) then Exit; //º¯½ÅÁß...

  case RACEfeature(cfeature) of //m_btRaceImg
    0: Actor := THumActor.Create; //ÈËÎï
    9: Actor := TSoccerBall.Create; //×ãÇò
    13: Actor := TKillingHerb.Create; //Ê³ÈË»¨
    14: Actor := TSkeletonOma.Create; //÷¼÷Ã
    15: Actor := TDualAxeOma.Create; //ÖÀ¸«÷¼÷Ã

    16: Actor := TGasKuDeGi.Create; //¶´Çù

    17: Actor := TCatMon.Create; //¹³×¦Ã¨
    18: Actor := THuSuABi.Create; //µ¾²ÝÈË
    19: Actor := TCatMon.Create; //ÎÖÂêÕ½Ê¿

    20: Actor := TFireCowFaceMon.Create; //»ðÑæÎÖÂê
    21: Actor := TCowFaceKing.Create; //ÎÖÂê½ÌÖ÷
    22: Actor := TDualAxeOma.Create; //ºÚ°µÕ½Ê¿
    23: Actor := TWhiteSkeleton.Create; //±äÒì÷¼÷Ã
    24: Actor := TSuperiorGuard.Create; //´øµ¶ÎÀÊ¿
    30: Actor := TCatMon.Create; //³¯°³Áþ
    31: Actor := TCatMon.Create; //½ÇÓ¬
    32: Actor := TScorpionMon.Create; //Ð«×Ó

    33: Actor := TCentipedeKingMon.Create; //´¥ÁúÉñ
    34: Actor := TBigHeartMon.Create; //³àÔÂ¶ñÄ§
    35: Actor := TSpiderHouseMon.Create; //»ÃÓ°Ö©Öë
    36: Actor := TExplosionSpider.Create; //ÔÂÄ§Ö©Öë
    37: Actor := TFlyingSpider.Create; //

    40: Actor := TZombiLighting.Create; //½©Ê¬1
    41: Actor := TZombiDigOut.Create; //½©Ê¬2
    42: Actor := TZombiZilkin.Create; //½©Ê¬3

    43: Actor := TBeeQueen.Create; //½ÇÓ¬³²

    45: Actor := TArcherMon.Create; //¹­¼ýÊÖ
    47: Actor := TSculptureMon.Create; //×æÂêµñÏñ
    48: Actor := TSculptureMon.Create; //
    49: Actor := TSculptureKingMon.Create; //×æÂê½ÌÖ÷

    50: Actor := TNpcActor.Create;

    52: Actor := TGasKuDeGi.Create; //Ð¨¶ê
    53: Actor := TGasKuDeGi.Create; //·à³æ
    54: Actor := TSmallElfMonster.Create; //ÉñÊÞ
    55: Actor := TWarriorElfMonster.Create; //ÉñÊÞ1

    60: Actor := TElectronicScolpionMon.Create;
    61: Actor := TBossPigMon.Create;
    62: Actor := TKingOfSculpureKingMon.Create;
    63: Actor := TSkeletonKingMon.Create;
    64: Actor := TGasKuDeGi.Create;
    65: Actor := TSamuraiMon.Create;
    66: Actor := TSkeletonSoldierMon.Create;
    67: Actor := TSkeletonSoldierMon.Create;
    68: Actor := TSkeletonSoldierMon.Create;
    69: Actor := TSkeletonArcherMon.Create;
    70: Actor := TBanyaGuardMon.Create;
    71: Actor := TBanyaGuardMon.Create;
    72: Actor := TBanyaGuardMon.Create;
    73: Actor := TPBOMA1Mon.Create;
    74: Actor := TCatMon.Create;
    75: Actor := TStoneMonster.Create;
    76: Actor := TSuperiorGuard.Create;
    77: Actor := TStoneMonster.Create;
    78: Actor := TBanyaGuardMon.Create;
    79: Actor := TPBOMA6Mon.Create;
    80: Actor := TMineMon.Create;
    81: Actor := TAngel.Create;
    83: Actor := TFireDragon.Create;
    84: Actor := TDragonStatue.Create;

    90: Actor := TDragonBody.Create; //Áú
    98: Actor := TWallStructure.Create; //LeftWall
    99: Actor := TCastleDoor.Create; //MainDoor
    else Actor := TActor.Create;
  end;

  with Actor do begin
    m_nRecogId := chrid;
    m_nCurrX := cx;
    m_nCurrY := cy;
    m_nRx := m_nCurrX;
    m_nRy := m_nCurrY;
    m_btDir := cdir;
    m_nFeature := cfeature;
    m_btRace := RACEfeature(cfeature); //changefeature°¡ ÀÖÀ»¶§¸¸
    m_btHair := HAIRfeature(cfeature); //º¯°æµÈ´Ù.
    m_btDress := DRESSfeature(cfeature);
    m_btWeapon := WEAPONfeature(cfeature);
    m_wAppearance := APPRfeature(cfeature);
    //      Horse:=Horsefeature(cfeature);
    //      Effect:=Effectfeature(cfeature);
    m_Action := GetMonAction(m_wAppearance);
    if m_btRace = 0 then begin
      m_btSex := m_btDress mod 2; //0:³²ÀÚ 1:¿©ÀÚ
    end else begin
      m_btSex := 0;
    end;
    m_nState := cstate;
    m_SayingArr[0] := '';
  end;
  m_ActorList.Add(Actor);
  Result := Actor;
end;

procedure TPlayScene.ActorDied(Actor: TObject);
var
  i: Integer;
  flag: Boolean;
begin
  for i := 0 to m_ActorList.count - 1 do
    if m_ActorList[i] = Actor then begin
      m_ActorList.Delete(i);
      break;
    end;
  flag := FALSE;
  for i := 0 to m_ActorList.count - 1 do
    if not TActor(m_ActorList[i]).m_boDeath then begin
      m_ActorList.Insert(i, Actor);
      flag := True;
      break;
    end;
  if not flag then m_ActorList.Add(Actor);
end;

procedure TPlayScene.SetActorDrawLevel(Actor: TObject; Level: Integer);
var
  i: Integer;
begin
  if Level = 0 then begin //¸Ç Ã³À½¿¡ ±×¸®µµ·Ï ÇÔ
    for i := 0 to m_ActorList.count - 1 do
      if m_ActorList[i] = Actor then begin
        m_ActorList.Delete(i);
        m_ActorList.Insert(0, Actor);
        break;
      end;
  end;
end;

procedure TPlayScene.ClearActors; //·Î±×¾Æ¿ô¸¸ »ç¿ë
var
  i: Integer;
begin
  for i := 0 to m_ActorList.count - 1 do
    TActor(m_ActorList[i]).Free;
  m_ActorList.Clear;
  g_MySelf := nil;
  g_TargetCret := nil;
  g_FocusCret := nil;
  g_MagicTarget := nil;

  //¸¶¹ýµµ ÃÊ±âÈ­ ÇØ¾ßÇÔ.
  for i := 0 to m_EffectList.count - 1 do
    TMagicEff(m_EffectList[i]).Free;
  m_EffectList.Clear;
end;

function TPlayScene.DeleteActor(id: Integer): TActor;
var
  i: Integer;
begin
  Result := nil;
  i := 0;
  while True do begin
    if i >= m_ActorList.count then break;
    if TActor(m_ActorList[i]).m_nRecogId = id then begin
      if g_TargetCret = TActor(m_ActorList[i]) then g_TargetCret := nil;
      if g_FocusCret = TActor(m_ActorList[i]) then g_FocusCret := nil;
      if g_MagicTarget = TActor(m_ActorList[i]) then g_MagicTarget := nil;
      TActor(m_ActorList[i]).m_dwDeleteTime := GetTickCount;
      g_FreeActorList.Add(m_ActorList[i]);
      //TActor(ActorList[i]).Free;
      m_ActorList.Delete(i);
    end else
      Inc(i);
  end;
end;

procedure TPlayScene.DelActor(Actor: TObject);
var
  i: Integer;
begin
  for i := 0 to m_ActorList.count - 1 do
    if m_ActorList[i] = Actor then begin
      TActor(m_ActorList[i]).m_dwDeleteTime := GetTickCount;
      g_FreeActorList.Add(m_ActorList[i]);
      m_ActorList.Delete(i);
      break;
    end;
end;

function TPlayScene.ButchAnimal(X, Y: Integer): TActor;
var
  i: Integer;
  a: TActor;
begin
  Result := nil;
  for i := 0 to m_ActorList.count - 1 do begin
    a := TActor(m_ActorList[i]);
    if a.m_boDeath and (a.m_btRace <> 0) then begin //µ¿¹° ½ÃÃ¼
      if (abs(a.m_nCurrX - X) <= 1) and (abs(a.m_nCurrY - Y) <= 1) then begin
        Result := a;
        break;
      end;
    end;
  end;
end;


{------------------------- Msg -------------------------}


//¸Þ¼¼Áö¸¦ ¹öÆÛ¸µÇÏ´Â ÀÌÀ¯´Â ?
//Ä³¸¯ÅÍÀÇ ¸Þ¼¼Áö ¹öÆÛ¿¡ ¸Þ¼¼Áö°¡ ³²¾Æ ÀÖ´Â »óÅÂ¿¡¼­
//´ÙÀ½ ¸Þ¼¼Áö°¡ Ã³¸®µÇ¸é ¾ÈµÇ±â ¶§¹®ÀÓ.
procedure TPlayScene.SendMsg(ident, chrid, X, Y, cdir, Feature, State: Integer; str: string);
var
  Actor: TActor;
begin
  case ident of
    SM_TEST: begin
        Actor := NewActor(111, 254 {x}, 214 {y}, 0, 0, 0);
        g_MySelf := THumActor(Actor);
        Map.LoadMap('0', g_MySelf.m_nCurrX, g_MySelf.m_nCurrY);
      end;
    SM_CHANGEMAP,
      SM_NEWMAP: begin
        Map.LoadMap(str, X, Y);
        DarkLevel := cdir;
        if DarkLevel = 0 then g_boViewFog := FALSE
        else g_boViewFog := True;
        //
        if g_boViewMiniMap then begin
          //              BoViewMiniMap := FALSE;
          g_nMiniMapIndex := -1;
          frmMain.SendWantMiniMap;
        end;
        //
        if (ident = SM_NEWMAP) and (g_MySelf <> nil) then begin
          g_MySelf.m_nCurrX := X;
          g_MySelf.m_nCurrY := Y;
          g_MySelf.m_nRx := X;
          g_MySelf.m_nRy := Y;
          DelActor(g_MySelf);
        end;

      end;
    SM_LOGON: begin
        Actor := FindActor(chrid);
        if Actor = nil then begin
          Actor := NewActor(chrid, X, Y, Lobyte(cdir), Feature, State);
          Actor.m_nChrLight := Hibyte(cdir);
          cdir := Lobyte(cdir);
          Actor.SendMsg(SM_TURN, X, Y, cdir, Feature, State, '', 0);
        end;
        if g_MySelf <> nil then begin
          g_MySelf := nil;
        end;
        g_MySelf := THumActor(Actor);
      end;
    SM_HIDE: begin
        Actor := FindActor(chrid);
        if Actor <> nil then begin
          if Actor.m_boDelActionAfterFinished then begin //¶¥À¸·Î »ç¶óÁö´Â ¾Ö´Ï¸ÞÀÌ¼ÇÀÌ ³¡³ª¸é ÀÚµ¿À¸·Î »ç¶óÁü.
            Exit;
          end;
          if Actor.m_nWaitForRecogId <> 0 then begin //º¯½ÅÁß.. º¯½ÅÀÌ ³¡³ª¸é ÀÚµ¿À¸·Î »ç¶óÁü
            Exit;
          end;
        end;
        DeleteActor(chrid);
      end;
    else begin
        Actor := FindActor(chrid);
        if (ident = SM_TURN) or (ident = SM_RUN) or (ident = SM_HORSERUN) or (ident = SM_WALK) or
          (ident = SM_BACKSTEP) or
          (ident = SM_DEATH) or (ident = SM_SKELETON) or
          (ident = SM_DIGUP) or (ident = SM_ALIVE) then begin
          if Actor = nil then
            Actor := NewActor(chrid, X, Y, Lobyte(cdir), Feature, State);
          if Actor <> nil then begin
            Actor.m_nChrLight := Hibyte(cdir);
            cdir := Lobyte(cdir);
            if ident = SM_SKELETON then begin
              Actor.m_boDeath := True;
              Actor.m_boSkeleton := True;
            end;
          end;
        end;
        if Actor = nil then Exit;
        case ident of
          SM_FEATURECHANGED: begin
              Actor.m_nFeature := Feature;
              Actor.m_nFeatureEx := State;
              Actor.FeatureChanged;
            end;
          SM_CHARSTATUSCHANGED: begin
              Actor.m_nState := Feature;
              Actor.m_nHitSpeed := State;
            end;
          else begin
              if ident = SM_TURN then begin
                if str <> '' then
                  Actor.m_sUserName := str;
              end;
              Actor.SendMsg(ident, X, Y, cdir, Feature, State, '', 0);
            end;
        end;
      end;
  end;
end;





end.

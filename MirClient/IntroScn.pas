unit IntroScn;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, StdCtrls, Controls, Forms, Dialogs,
  ExtCtrls, DXDraws, DXClass, FState, Grobal2, cliUtil, ClFunc, SoundUtil,
  DXSounds, HUtil32;


const
  SELECTEDFRAME = 16;
  FREEZEFRAME = 13;
  EFFECTFRAME = 14;

type
  TLoginState = (lsLogin, lsNewid, lsNewidRetry, lsChgpw, lsCloseAll);
  TSceneType = (stIntro, stLogin, stSelectCountry, stSelectChr, stNewChr, stLoading,
    stLoginNotice, stPlayGame);
  TSelChar = record
    Valid: Boolean;
    UserChr: TUserCharacterInfo;
    Selected: Boolean;
    FreezeState: Boolean; //TRUE:倔篮惑怕 FALSE:踌篮惑怕
    Unfreezing: Boolean; //踌绊 乐绰 惑怕牢啊?
    Freezing: Boolean; //倔绊 乐绰 惑怕?
    AniIndex: Integer; //踌绰(绢绰) 局聪皋捞记
    DarkLevel: Integer;
    EffIndex: Integer; //瓤苞 局聪皋捞记
    StartTime: LongWord;
    moretime: LongWord;
    startefftime: LongWord;
  end;

  TScene = class
  private
  public
    scenetype: TSceneType;
    constructor Create(scenetype: TSceneType);
    procedure Initialize; dynamic;
    procedure Finalize; dynamic;
    procedure OpenScene; dynamic;
    procedure CloseScene; dynamic;
    procedure OpeningScene; dynamic;
    procedure KeyPress(var Key: Char); dynamic;
    procedure KeyDown(var Key: Word; Shift: TShiftState); dynamic;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); dynamic;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); dynamic;
    procedure PlayScene(MSurface: TDirectDrawSurface); dynamic;
  end;

  TIntroScene = class(TScene)
  private
  public
    constructor Create;
    destructor Destroy; override;
    procedure OpenScene; override;
    procedure CloseScene; override;
    procedure PlayScene(MSurface: TDirectDrawSurface); override;
  end;

  TLoginScene = class(TScene)
  private
    m_EdId: TEdit;
    m_EdPasswd: TEdit;
    m_EdNewId: TEdit;
    m_EdNewPasswd: TEdit;
    m_EdConfirm: TEdit;
    m_EdYourName: TEdit;
    m_EdSSNo: TEdit;
    m_EdBirthDay: TEdit;
    m_EdQuiz1: TEdit;
    m_EdAnswer1: TEdit;
    m_EdQuiz2: TEdit;
    m_EdAnswer2: TEdit;
    m_EdPhone: TEdit;
    m_EdMobPhone: TEdit;
    m_EdEMail: TEdit;
    m_EdChgId: TEdit;
    m_EdChgCurrentpw: TEdit;
    m_EdChgNewPw: TEdit;
    m_EdChgRepeat: TEdit;
    m_nCurFrame: Integer;
    m_nMaxFrame: Integer;
    m_dwStartTime: LongWord; //茄 橇贰烙寸 矫埃
    m_boNowOpening: Boolean;
    m_boOpenFirst: Boolean;
    m_NewIdRetryUE: TUserEntry;
    m_NewIdRetryAdd: TUserEntryAdd;
    procedure EdLoginIdKeyPress(Sender: TObject; var Key: Char);
    procedure EdLoginPasswdKeyPress(Sender: TObject; var Key: Char);
    procedure EdNewIdKeyPress(Sender: TObject; var Key: Char);
    procedure EdNewOnEnter(Sender: TObject);
    function CheckUserEntrys: Boolean;
    function NewIdCheckNewId: Boolean;
    function NewIdCheckSSno: Boolean;
    function NewIdCheckBirthDay: Boolean;
  public
    m_sLoginId: string;
    m_sLoginPasswd: string;
    m_boUpdateAccountMode: Boolean;
    constructor Create;
    destructor Destroy; override;
    procedure OpenScene; override;
    procedure CloseScene; override;
    procedure PlayScene(MSurface: TDirectDrawSurface); override;
    procedure ChangeLoginState(State: TLoginState);
    procedure NewClick;
    procedure NewIdRetry(boupdate: Boolean);
    procedure UpdateAccountInfos(ue: TUserEntry);
    procedure OkClick;
    procedure ChgPwClick;
    procedure NewAccountOk;
    procedure NewAccountClose;
    procedure ChgpwOk;
    procedure ChgpwCancel;
    procedure HideLoginBox;
    procedure OpenLoginDoor;
    procedure PassWdFail;
  end;

  TSelectChrScene = class(TScene)
  private
    SoundTimer: TTimer;
    CreateChrMode: Boolean;
    EdChrName: TEdit;
    procedure SoundOnTimer(Sender: TObject);
    procedure MakeNewChar(Index: Integer);
    procedure EdChrnameKeyPress(Sender: TObject; var Key: Char);
  public
    NewIndex: Integer;
    ChrArr: array[0..1] of TSelChar;
    constructor Create;
    destructor Destroy; override;
    procedure OpenScene; override;
    procedure CloseScene; override;
    procedure PlayScene(MSurface: TDirectDrawSurface); override;
    procedure SelChrSelect1Click;
    procedure SelChrSelect2Click;
    procedure SelChrStartClick;
    procedure SelChrNewChrClick;
    procedure SelChrEraseChrClick;
    procedure SelChrCreditsClick;
    procedure SelChrExitClick;
    procedure SelChrNewClose;
    procedure SelChrNewJob(job: Integer);
    procedure SelChrNewm_btSex(sex: Integer);
    procedure SelChrNewPrevHair;
    procedure SelChrNewNextHair;
    procedure SelChrNewOk;
    procedure ClearChrs;
    procedure AddChr(uname: string; job, hair, Level, sex: Integer);
    procedure SelectChr(Index: Integer);
  end;

  TLoginNotice = class(TScene)
  private
  public
    constructor Create;
    destructor Destroy; override;
  end;


implementation

uses
  ClMain, MShare, Share;


constructor TScene.Create(scenetype: TSceneType);
begin
  scenetype := scenetype;
end;

procedure TScene.Initialize;
begin
end;

procedure TScene.Finalize;
begin
end;

procedure TScene.OpenScene;
begin
  ;
end;

procedure TScene.CloseScene;
begin
  ;
end;

procedure TScene.OpeningScene;
begin
end;

procedure TScene.KeyPress(var Key: Char);
begin
end;

procedure TScene.KeyDown(var Key: Word; Shift: TShiftState);
begin
end;

procedure TScene.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
end;

procedure TScene.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
end;

procedure TScene.PlayScene(MSurface: TDirectDrawSurface);
begin
  ;
end;


{------------------- TIntroScene ----------------------}


constructor TIntroScene.Create;
begin
  inherited Create(stIntro);
end;

destructor TIntroScene.Destroy;
begin
  inherited Destroy;
end;

procedure TIntroScene.OpenScene;
begin
end;

procedure TIntroScene.CloseScene;
begin
end;

procedure TIntroScene.PlayScene(MSurface: TDirectDrawSurface);
begin
end;


{--------------------- Login ----------------------}


constructor TLoginScene.Create;
var
  nX, nY: Integer;
begin
  inherited Create(stLogin);
  m_EdId := TEdit.Create(frmMain.Owner);
  with m_EdId do begin
    Parent := frmMain;
    Color := clBlack;
    Font.Color := clWhite;
    Font.Size := 10;
    MaxLength := 10;
    BorderStyle := bsNone;
    OnKeyPress := EdLoginIdKeyPress;
    Visible := FALSE;
    tag := 10;
  end;

  m_EdPasswd := TEdit.Create(frmMain.Owner);
  with m_EdPasswd do begin
    Parent := frmMain; Color := clBlack; Font.Size := 10; MaxLength := 10; Font.Color := clWhite;
    BorderStyle := bsNone; PasswordChar := '*';
    OnKeyPress := EdLoginPasswdKeyPress; Visible := FALSE;
    tag := 10;
  end;

  nX := SCREENWIDTH div 2 - 320 {192} {79};
  nY := SCREENHEIGHT div 2 - 238 {146} {64};

  m_EdNewId := TEdit.Create(frmMain.Owner);
  with m_EdNewId do begin
    Parent := frmMain;
    Height := 16;
    Width := 116;
    Left := nX + 161;
    Top := nY + 116;
    BorderStyle := bsNone; Color := clBlack; Font.Color := clWhite; MaxLength := 10;
    Visible := FALSE; OnKeyPress := EdNewIdKeyPress; OnEnter := EdNewOnEnter;
    tag := 11;
  end;


  m_EdNewPasswd := TEdit.Create(frmMain.Owner);
  with m_EdNewPasswd do begin
    Parent := frmMain;
    Height := 16;
    Width := 116;
    Left := nX + 161;
    Top := nY + 137;
    BorderStyle := bsNone; Color := clBlack; Font.Color := clWhite; MaxLength := 10;
    PasswordChar := '*'; Visible := FALSE; OnKeyPress := EdNewIdKeyPress; OnEnter := EdNewOnEnter;
    tag := 11;
  end;
  m_EdConfirm := TEdit.Create(frmMain.Owner);
  with m_EdConfirm do begin
    Parent := frmMain;
    Height := 16;
    Width := 116;
    Left := nX + 161;
    Top := nY + 158;
    BorderStyle := bsNone; Color := clBlack; Font.Color := clWhite; MaxLength := 10;
    PasswordChar := '*'; Visible := FALSE; OnKeyPress := EdNewIdKeyPress; OnEnter := EdNewOnEnter;
    tag := 11;
  end;
  m_EdYourName := TEdit.Create(frmMain.Owner);
  with m_EdYourName do begin
    Parent := frmMain; Height := 16; Width := 116; Left := nX + 161; Top := nY + 187;
    BorderStyle := bsNone; Color := clBlack; Font.Color := clWhite; MaxLength := 20;
    Visible := FALSE; OnKeyPress := EdNewIdKeyPress; OnEnter := EdNewOnEnter;
    tag := 11;
  end;
  m_EdSSNo := TEdit.Create(frmMain.Owner);
  with m_EdSSNo do begin
    Parent := frmMain; Height := 16; Width := 116; Left := nX + 161; Top := nY + 207;
    BorderStyle := bsNone; Color := clBlack; Font.Color := clWhite; MaxLength := 14;
    Visible := FALSE; OnKeyPress := EdNewIdKeyPress; OnEnter := EdNewOnEnter;
    tag := 11;
  end;
  m_EdBirthDay := TEdit.Create(frmMain.Owner);
  with m_EdBirthDay do begin
    Parent := frmMain; Height := 16; Width := 116; Left := nX + 161; Top := nY + 227;
    BorderStyle := bsNone; Color := clBlack; Font.Color := clWhite; MaxLength := 10;
    Visible := FALSE; OnKeyPress := EdNewIdKeyPress; OnEnter := EdNewOnEnter;
    tag := 11;
  end;
  m_EdQuiz1 := TEdit.Create(frmMain.Owner);
  with m_EdQuiz1 do begin
    Parent := frmMain; Height := 16; Width := 163; Left := nX + 161; Top := nY + 256;
    BorderStyle := bsNone; Color := clBlack; Font.Color := clWhite; MaxLength := 20;
    Visible := FALSE; OnKeyPress := EdNewIdKeyPress; OnEnter := EdNewOnEnter;
    tag := 11;
  end;
  m_EdAnswer1 := TEdit.Create(frmMain.Owner);
  with m_EdAnswer1 do begin
    Parent := frmMain; Height := 16; Width := 163; Left := nX + 161; Top := nY + 276;
    BorderStyle := bsNone; Color := clBlack; Font.Color := clWhite; MaxLength := 12;
    Visible := FALSE; OnKeyPress := EdNewIdKeyPress; OnEnter := EdNewOnEnter;
    tag := 11;
  end;
  m_EdQuiz2 := TEdit.Create(frmMain.Owner);
  with m_EdQuiz2 do begin
    Parent := frmMain; Height := 16; Width := 163; Left := nX + 161; Top := nY + 297;
    BorderStyle := bsNone; Color := clBlack; Font.Color := clWhite; MaxLength := 20;
    Visible := FALSE; OnKeyPress := EdNewIdKeyPress; OnEnter := EdNewOnEnter;
    tag := 11;
  end;
  m_EdAnswer2 := TEdit.Create(frmMain.Owner);
  with m_EdAnswer2 do begin
    Parent := frmMain; Height := 16; Width := 163; Left := nX + 161; Top := nY + 317;
    BorderStyle := bsNone; Color := clBlack; Font.Color := clWhite; MaxLength := 12;
    Visible := FALSE; OnKeyPress := EdNewIdKeyPress; OnEnter := EdNewOnEnter;
    tag := 11;
  end;
  m_EdPhone := TEdit.Create(frmMain.Owner);
  with m_EdPhone do begin
    Parent := frmMain;
    Height := 16;
    Width := 116;
    Left := nX + 161;
    Top := nY + 347;
    BorderStyle := bsNone;
    Color := clBlack;
    Font.Color := clWhite;
    MaxLength := 14;
    Visible := FALSE;
    OnKeyPress := EdNewIdKeyPress;
    OnEnter := EdNewOnEnter;
    tag := 11;
  end;
  m_EdMobPhone := TEdit.Create(frmMain.Owner);
  with m_EdMobPhone do begin
    Parent := frmMain;
    Height := 16;
    Width := 116;
    Left := nX + 161;
    Top := nY + 368;
    BorderStyle := bsNone;
    Color := clBlack;
    Font.Color := clWhite;
    MaxLength := 13;
    Visible := FALSE;
    OnKeyPress := EdNewIdKeyPress;
    OnEnter := EdNewOnEnter;
    tag := 11;
  end;
  m_EdEMail := TEdit.Create(frmMain.Owner);
  with m_EdEMail do begin
    Parent := frmMain;
    Height := 16;
    Width := 116;
    Left := nX + 161;
    Top := nY + 388;
    BorderStyle := bsNone;
    Color := clBlack;
    Font.Color := clWhite;
    MaxLength := 40;
    Visible := FALSE;
    OnKeyPress := EdNewIdKeyPress;
    OnEnter := EdNewOnEnter;
    tag := 11;
  end;

  nX := SCREENWIDTH div 2 - 210 {192} {192};
  nY := SCREENHEIGHT div 2 - 150 {146} {150};
  m_EdChgId := TEdit.Create(frmMain.Owner);
  with m_EdChgId do begin
    Parent := frmMain;
    Height := 16;
    Width := 137;
    Left := nX + 239;
    Top := nY + 117;
    BorderStyle := bsNone;
    Color := clBlack;
    Font.Color := clWhite;
    MaxLength := 10;
    Visible := FALSE;
    OnKeyPress := EdNewIdKeyPress;
    OnEnter := EdNewOnEnter;
    tag := 12;
  end;
  m_EdChgCurrentpw := TEdit.Create(frmMain.Owner);
  with m_EdChgCurrentpw do begin
    Parent := frmMain;
    Height := 16;
    Width := 137;
    Left := nX + 239;
    Top := nY + 149;
    BorderStyle := bsNone;
    Color := clBlack;
    Font.Color := clWhite;
    MaxLength := 10;
    PasswordChar := '*';
    Visible := FALSE;
    OnKeyPress := EdNewIdKeyPress;
    OnEnter := EdNewOnEnter;
    tag := 12;
  end;
  m_EdChgNewPw := TEdit.Create(frmMain.Owner);
  with m_EdChgNewPw do begin
    Parent := frmMain;
    Height := 16;
    Width := 137;
    Left := nX + 239;
    Top := nY + 176;
    BorderStyle := bsNone;
    Color := clBlack;
    Font.Color := clWhite;
    MaxLength := 10;
    PasswordChar := '*';
    Visible := FALSE;
    OnKeyPress := EdNewIdKeyPress;
    OnEnter := EdNewOnEnter;
    tag := 12;
  end;
  m_EdChgRepeat := TEdit.Create(frmMain.Owner);
  with m_EdChgRepeat do begin
    Parent := frmMain;
    Height := 16;
    Width := 137;
    Left := nX + 239;
    Top := nY + 208;
    BorderStyle := bsNone;
    Color := clBlack;
    Font.Color := clWhite;
    MaxLength := 10;
    PasswordChar := '*';
    Visible := FALSE;
    OnKeyPress := EdNewIdKeyPress;
    OnEnter := EdNewOnEnter;
    tag := 12;
  end;
end;

destructor TLoginScene.Destroy;
begin
  inherited Destroy;
end;

procedure TLoginScene.OpenScene;
var
  i: Integer;
  d: TDirectDrawSurface;
begin

  m_nCurFrame := 0;
  m_nMaxFrame := 10;
  m_sLoginId := '';
  m_sLoginPasswd := '';

  with m_EdId do begin
    Left := SCREENWIDTH div 2 - 68 + 18 {350};
    Top := SCREENHEIGHT div 2 - 8 - 34 {259};
    Height := 16;
    Width := 137;
    Visible := FALSE;
  end;
  with m_EdPasswd do begin
    Left := SCREENWIDTH div 2 - 68 + 18 {350};
    Top := SCREENHEIGHT div 2 - 8 - 2 {291};
    Height := 16;
    Width := 137;
    Visible := FALSE;
  end;
  m_boOpenFirst := True;

  FrmDlg.DLogin.Visible := True;
  FrmDlg.DNewAccount.Visible := FALSE;
  m_boNowOpening := FALSE;
  PlayBGM(bmg_intro);

end;

procedure TLoginScene.CloseScene;
begin
  m_EdId.Visible := FALSE;
  m_EdPasswd.Visible := FALSE;
  FrmDlg.DLogin.Visible := FALSE;
  SilenceSound;
end;

procedure TLoginScene.EdLoginIdKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then begin
    Key := #0;
    m_sLoginId := LowerCase(m_EdId.Text);
    if m_sLoginId <> '' then begin
      m_EdPasswd.SetFocus;
    end;
  end;
end;

procedure TLoginScene.EdLoginPasswdKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = '~') or (Key = '''') then Key := '_';
  if Key = #13 then begin
    Key := #0;
    m_sLoginId := LowerCase(m_EdId.Text);
    m_sLoginPasswd := m_EdPasswd.Text;
    if (m_sLoginId <> '') and (m_sLoginPasswd <> '') then begin
      //拌沥栏肺 肺弊牢 茄促.
      frmMain.SendLogin(m_sLoginId, m_sLoginPasswd);
      m_EdId.Text := '';
      m_EdPasswd.Text := '';
      m_EdId.Visible := FALSE;
      m_EdPasswd.Visible := FALSE;
    end else
      if (m_EdId.Visible) and (m_EdId.Text = '') then m_EdId.SetFocus;
  end;
end;

procedure TLoginScene.PassWdFail;
begin
  m_EdId.Visible := True;
  m_EdPasswd.Visible := True;
  m_EdId.SetFocus;
end;


function TLoginScene.NewIdCheckNewId: Boolean;
begin
  Result := True;
  m_EdNewId.Text := Trim(m_EdNewId.Text);
  if Length(m_EdNewId.Text) < 3 then begin
    FrmDlg.DMessageDlg('登录帐号的长度必须大于3位.', [mbOk]);
    Beep;
    m_EdNewId.SetFocus;
    Result := FALSE;
  end;
end;

function TLoginScene.NewIdCheckSSno: Boolean;
var
  str, t1, t2, t3, syear, smon, sday: string;
  ayear, amon, aday, sex: Integer;
  flag: Boolean;
begin
  Result := True;
  str := m_EdSSNo.Text;
  str := GetValidStr3(str, t1, ['-']);
  GetValidStr3(str, t2, ['-']);
  flag := True;
  if (Length(t1) = 6) and (Length(t2) = 7) then begin
    smon := Copy(t1, 3, 2);
    sday := Copy(t1, 5, 2);
    amon := Str_ToInt(smon, 0);
    aday := Str_ToInt(sday, 0);
    if (amon <= 0) or (amon > 12) then flag := FALSE;
    if (aday <= 0) or (aday > 31) then flag := FALSE;
    sex := Str_ToInt(Copy(t2, 1, 1), 0);
    if (sex <= 0) or (sex > 2) then flag := FALSE;
  end else flag := FALSE;
  if not flag then begin
    Beep;
    m_EdSSNo.SetFocus;
    Result := FALSE;
  end;
end;

function TLoginScene.NewIdCheckBirthDay: Boolean;
var
  str, t1, t2, t3, syear, smon, sday: string;
  ayear, amon, aday, sex: Integer;
  flag: Boolean;
begin
  Result := True;
  flag := True;
  str := m_EdBirthDay.Text;
  str := GetValidStr3(str, syear, ['/']);
  str := GetValidStr3(str, smon, ['/']);
  str := GetValidStr3(str, sday, ['/']);
  ayear := Str_ToInt(syear, 0);
  amon := Str_ToInt(smon, 0);
  aday := Str_ToInt(sday, 0);
  if (ayear <= 1890) or (ayear > 2101) then flag := FALSE;
  if (amon <= 0) or (amon > 12) then flag := FALSE;
  if (aday <= 0) or (aday > 31) then flag := FALSE;
  if not flag then begin
    Beep;
    m_EdBirthDay.SetFocus;
    Result := FALSE;
  end;
end;

procedure TLoginScene.EdNewIdKeyPress(Sender: TObject; var Key: Char);
var
  str, t1, t2, t3, syear, smon, sday: string;
  ayear, amon, aday, sex: Integer;
  flag: Boolean;
begin
  if (Sender = m_EdNewPasswd) or (Sender = m_EdChgNewPw) or (Sender = m_EdChgRepeat) then
    if (Key = '~') or (Key = '''') or (Key = ' ') then Key := #0;
  if Key = #13 then begin
    Key := #0;
    if Sender = m_EdNewId then begin
      if not NewIdCheckNewId then
        Exit;
    end;
    if Sender = m_EdNewPasswd then begin
      if Length(m_EdNewPasswd.Text) < 4 then begin
        FrmDlg.DMessageDlg('密码长度必须大于 4位.', [mbOk]);
        Beep;
        m_EdNewPasswd.SetFocus;
        Exit;
      end;
    end;
    if Sender = m_EdConfirm then begin
      if m_EdNewPasswd.Text <> m_EdConfirm.Text then begin
        FrmDlg.DMessageDlg('二次输入的密码不一至！！！', [mbOk]);
        Beep;
        m_EdConfirm.SetFocus;
        Exit;
      end;
    end;
    if (Sender = m_EdYourName) or (Sender = m_EdQuiz1) or (Sender = m_EdAnswer1) or
      (Sender = m_EdQuiz2) or (Sender = m_EdAnswer2) or (Sender = m_EdPhone) or
      (Sender = m_EdMobPhone) or (Sender = m_EdEMail)
      then begin
      TEdit(Sender).Text := Trim(TEdit(Sender).Text);
      if TEdit(Sender).Text = '' then begin
        Beep;
        TEdit(Sender).SetFocus;
        Exit;
      end;
    end;
    if (Sender = m_EdSSNo) and (not EnglishVersion) then begin //茄惫牢 版快.. 林刮殿废锅龋 埃帆 盲农
      if not NewIdCheckSSno then
        Exit;
    end;
    if Sender = m_EdBirthDay then begin
      if not NewIdCheckBirthDay then
        Exit;
    end;
    if TEdit(Sender).Text <> '' then begin
      if Sender = m_EdNewId then m_EdNewPasswd.SetFocus;
      if Sender = m_EdNewPasswd then m_EdConfirm.SetFocus;
      if Sender = m_EdConfirm then m_EdYourName.SetFocus;
      if Sender = m_EdYourName then m_EdSSNo.SetFocus;
      if Sender = m_EdSSNo then m_EdBirthDay.SetFocus;
      if Sender = m_EdBirthDay then m_EdQuiz1.SetFocus;
      if Sender = m_EdQuiz1 then m_EdAnswer1.SetFocus;
      if Sender = m_EdAnswer1 then m_EdQuiz2.SetFocus;
      if Sender = m_EdQuiz2 then m_EdAnswer2.SetFocus;
      if Sender = m_EdAnswer2 then m_EdPhone.SetFocus;
      if Sender = m_EdPhone then m_EdMobPhone.SetFocus;
      if Sender = m_EdMobPhone then m_EdEMail.SetFocus;
      if Sender = m_EdEMail then begin
        if m_EdNewId.Enabled then m_EdNewId.SetFocus
        else if m_EdNewPasswd.Enabled then m_EdNewPasswd.SetFocus;
      end;

      if Sender = m_EdChgId then m_EdChgCurrentpw.SetFocus;
      if Sender = m_EdChgCurrentpw then m_EdChgNewPw.SetFocus;
      if Sender = m_EdChgNewPw then m_EdChgRepeat.SetFocus;
      if Sender = m_EdChgRepeat then m_EdChgId.SetFocus;
    end;
  end;
end;

procedure TLoginScene.EdNewOnEnter(Sender: TObject);
var
  hx, hy: Integer;
begin
  //腮飘
  FrmDlg.NAHelps.Clear;
  hx := TEdit(Sender).Left + TEdit(Sender).Width + 10;
  hy := TEdit(Sender).Top + TEdit(Sender).Height - 18;
  if Sender = m_EdNewId then begin
    FrmDlg.NAHelps.Add('您的帐号名称可以包括：');
    FrmDlg.NAHelps.Add('字符、数字的组合。');
    FrmDlg.NAHelps.Add('帐号名称长度必须为4或以上。');
    FrmDlg.NAHelps.Add('登陆帐号并游戏中的人物名称。');
    FrmDlg.NAHelps.Add('请仔细输入创建帐号所需信息。');
    FrmDlg.NAHelps.Add('您的登陆帐号可以登陆游戏');
    FrmDlg.NAHelps.Add('及我们网站，以取得一些相关信息。');
    FrmDlg.NAHelps.Add('');
    FrmDlg.NAHelps.Add('建议您的登陆帐号不要与游戏中的角');
    FrmDlg.NAHelps.Add('色名相同，');
    FrmDlg.NAHelps.Add('以确保你的密码不会被爆力破解。');
  end;
  if Sender = m_EdNewPasswd then begin
    FrmDlg.NAHelps.Add('您的密码可以是字符及数字的组合，');
    FrmDlg.NAHelps.Add('但密码长度必须至少4位。');
    FrmDlg.NAHelps.Add('建议您的密码内容不要过于简单，');
    FrmDlg.NAHelps.Add('以防被人猜到。');
    FrmDlg.NAHelps.Add('请记住您输入的密码，如果丢失密码');
    FrmDlg.NAHelps.Add('将无法登录游戏。');
    FrmDlg.NAHelps.Add('');
    FrmDlg.NAHelps.Add('');
    FrmDlg.NAHelps.Add('');
    FrmDlg.NAHelps.Add('');
    FrmDlg.NAHelps.Add('');
  end;
  if Sender = m_EdConfirm then begin
    FrmDlg.NAHelps.Add('再次输入密码');
    FrmDlg.NAHelps.Add('以确认。');
    FrmDlg.NAHelps.Add('');
  end;
  if Sender = m_EdYourName then begin
    FrmDlg.NAHelps.Add('请输入您的全名.');
    FrmDlg.NAHelps.Add('');
  end;
  if Sender = m_EdSSNo then begin
    FrmDlg.NAHelps.Add('请输入你的身份证号');
    FrmDlg.NAHelps.Add('例如： 720101-146720');
    FrmDlg.NAHelps.Add('');
  end;
  if Sender = m_EdBirthDay then begin
    FrmDlg.NAHelps.Add('请输入您的生日');
    FrmDlg.NAHelps.Add('例如：1977/10/15');
    FrmDlg.NAHelps.Add('');
  end;
  if Sender = m_EdQuiz1 then begin
    FrmDlg.NAHelps.Add('请输入第一个密码提示问题');
    FrmDlg.NAHelps.Add('这个提示将用于密码丢失后找');
    FrmDlg.NAHelps.Add('回密码用。');
    FrmDlg.NAHelps.Add('');
  end;
  if Sender = m_EdAnswer1 then begin
    FrmDlg.NAHelps.Add('请输入上面问题的');
    FrmDlg.NAHelps.Add('答案。');
    FrmDlg.NAHelps.Add('');
  end;
  if Sender = m_EdQuiz2 then begin
    FrmDlg.NAHelps.Add('请输入第二个密码提示问题');
    FrmDlg.NAHelps.Add('这个提示将用于密码丢失后找');
    FrmDlg.NAHelps.Add('回密码用。');
    FrmDlg.NAHelps.Add('');
  end;
  if Sender = m_EdAnswer2 then begin
    FrmDlg.NAHelps.Add('请输入上面问题的');
    FrmDlg.NAHelps.Add('答案。');
    FrmDlg.NAHelps.Add('');
  end;
  if (Sender = m_EdYourName) or (Sender = m_EdSSNo) or (Sender = m_EdQuiz1) or (Sender = m_EdQuiz2) or (Sender = m_EdAnswer1) or (Sender = m_EdAnswer2) then begin
    FrmDlg.NAHelps.Add('您输入的信息必须真实正确的信息');
    FrmDlg.NAHelps.Add('如果使用了虚假的注册信息');
    FrmDlg.NAHelps.Add('您的帐号将被取消。');
    FrmDlg.NAHelps.Add('');
  end;

  if Sender = m_EdPhone then begin
    FrmDlg.NAHelps.Add('请输入您的电话');
    FrmDlg.NAHelps.Add('号码。');
    FrmDlg.NAHelps.Add('');
  end;
  if Sender = m_EdMobPhone then begin
    FrmDlg.NAHelps.Add('请输入您的手机号码。');
    FrmDlg.NAHelps.Add('');
  end;
  if Sender = m_EdEMail then begin
    FrmDlg.NAHelps.Add('请输入您的邮件地址。您的邮件将被');
    FrmDlg.NAHelps.Add('接收最近更新的一些信息');
    FrmDlg.NAHelps.Add('');
  end;
end;

procedure TLoginScene.HideLoginBox;
begin
  //EdId.Visible := FALSE;
  //EdPasswd.Visible := FALSE;
  //FrmDlg.DLogin.Visible := FALSE;
  ChangeLoginState(lsCloseAll);
end;

procedure TLoginScene.OpenLoginDoor;
begin
  m_boNowOpening := True;
  m_dwStartTime := GetTickCount;
  HideLoginBox;
  PlaySound(s_rock_door_open);
end;

procedure TLoginScene.PlayScene(MSurface: TDirectDrawSurface);
var
  d: TDirectDrawSurface;
begin
  if m_boOpenFirst then begin
    m_boOpenFirst := FALSE;
    m_EdId.Visible := True;
    m_EdPasswd.Visible := True;
    m_EdId.SetFocus;
  end;
{$IF CUSTOMLIBFILE = 1}
  d := g_WMainImages.Images[83 {102-80}];
{$ELSE}
  d := g_WChrSelImages.Images[102 - 80];
{$IFEND}
  if d <> nil then begin
    MSurface.Draw((SCREENWIDTH - 800) div 2, (SCREENHEIGHT - 600) div 2, d.ClientRect, d, FALSE);
  end;
  if m_boNowOpening then begin
    //      if GetTickCount - StartTime > 230 then begin
    //开门速度
    if GetTickCount - m_dwStartTime > 230 then begin
      m_dwStartTime := GetTickCount;
      Inc(m_nCurFrame);
    end;
    if m_nCurFrame >= m_nMaxFrame - 1 then begin
      m_nCurFrame := m_nMaxFrame - 1;
      if not g_boDoFadeOut and not g_boDoFadeIn then begin
        g_boDoFadeOut := True;
        g_boDoFadeIn := True;
        g_nFadeIndex := 29;
      end;
    end;
{$IF CUSTOMLIBFILE = 1}
    d := g_WMainImages.Images[m_nCurFrame + 84 {103 + CurFrame-80}];
{$ELSE}
    d := g_WChrSelImages.Images[103 + m_nCurFrame - 80];
{$IFEND}

    if d <> nil then
      MSurface.Draw((SCREENWIDTH - 800) div 2 + 152 {152}, (SCREENHEIGHT - 600) div 2 + 96 {96}, d.ClientRect, d, True);

    if g_boDoFadeOut then begin
      if g_nFadeIndex <= 1 then begin
        g_WMainImages.ClearCache;
        g_WChrSelImages.ClearCache;
        DScreen.ChangeScene(stSelectChr); //
      end;
    end;
  end;
end;

procedure TLoginScene.ChangeLoginState(State: TLoginState);
var
  i, focus: Integer;
  c: TControl;
begin
  focus := -1;
  case State of
    lsLogin: focus := 10;
    lsNewidRetry, lsNewid: focus := 11;
    lsChgpw: focus := 12;
    lsCloseAll: focus := -1;
  end;
  with frmMain do begin //login
    for i := 0 to ControlCount - 1 do begin
      c := Controls[i];
      if c is TEdit then begin
        if c.tag in [10..12] then begin
          if c.tag = focus then begin
            c.Visible := True;
            TEdit(c).Text := '';
          end else begin
            c.Visible := FALSE;
            TEdit(c).Text := '';
          end;
        end;
      end;
    end;
    if EnglishVersion then //康巩滚傈篮 林刮殿废锅龋 涝仿阑 救茄促.
      m_EdSSNo.Visible := FALSE;

    case State of
      lsLogin: begin
          FrmDlg.DNewAccount.Visible := FALSE;
          FrmDlg.DChgPw.Visible := FALSE;
          FrmDlg.DLogin.Visible := True;
          if m_EdId.Visible then m_EdId.SetFocus;
        end;
      lsNewidRetry,
        lsNewid: begin
          if m_boUpdateAccountMode then
            m_EdNewId.Enabled := FALSE
          else
            m_EdNewId.Enabled := True;
          FrmDlg.DNewAccount.Visible := True;
          FrmDlg.DChgPw.Visible := FALSE;
          FrmDlg.DLogin.Visible := FALSE;
          if m_EdNewId.Visible and m_EdNewId.Enabled then begin
            m_EdNewId.SetFocus;
          end else begin
            if m_EdConfirm.Visible and m_EdConfirm.Enabled then
              m_EdConfirm.SetFocus;
          end;
        end;
      lsChgpw: begin
          FrmDlg.DNewAccount.Visible := FALSE;
          FrmDlg.DChgPw.Visible := True;
          FrmDlg.DLogin.Visible := FALSE;
          if m_EdChgId.Visible then m_EdChgId.SetFocus;
        end;
      lsCloseAll: begin
          FrmDlg.DNewAccount.Visible := FALSE;
          FrmDlg.DChgPw.Visible := FALSE;
          FrmDlg.DLogin.Visible := FALSE;
        end;
    end;
  end;
end;

procedure TLoginScene.NewClick;
begin
  m_boUpdateAccountMode := FALSE;
  FrmDlg.NewAccountTitle := '';
  ChangeLoginState(lsNewid);
end;

procedure TLoginScene.NewIdRetry(boupdate: Boolean);
begin
  m_boUpdateAccountMode := boupdate;
  ChangeLoginState(lsNewidRetry);
  m_EdNewId.Text := m_NewIdRetryUE.sAccount;
  m_EdNewPasswd.Text := m_NewIdRetryUE.sPassword;
  m_EdYourName.Text := m_NewIdRetryUE.sUserName;
  m_EdSSNo.Text := m_NewIdRetryUE.sSSNo;
  m_EdQuiz1.Text := m_NewIdRetryUE.sQuiz;
  m_EdAnswer1.Text := m_NewIdRetryUE.sAnswer;
  m_EdPhone.Text := m_NewIdRetryUE.sPhone;
  m_EdEMail.Text := m_NewIdRetryUE.sEMail;
  m_EdQuiz2.Text := m_NewIdRetryAdd.sQuiz2;
  m_EdAnswer2.Text := m_NewIdRetryAdd.sAnswer2;
  m_EdMobPhone.Text := m_NewIdRetryAdd.sMobilePhone;
  m_EdBirthDay.Text := m_NewIdRetryAdd.sBirthDay;
end;

procedure TLoginScene.UpdateAccountInfos(ue: TUserEntry);
begin
  m_NewIdRetryUE := ue;
  FillChar(m_NewIdRetryAdd, sizeof(TUserEntryAdd), #0);
  m_boUpdateAccountMode := True; //扁粮俊 乐绰 沥焊甫 犁涝仿窍绰 版快
  NewIdRetry(True);
  FrmDlg.NewAccountTitle := '(请填写帐号相关信息。)';
end;

procedure TLoginScene.OkClick;
var
  Key: Char;
begin
  Key := #13;
  EdLoginPasswdKeyPress(Self, Key);
end;

procedure TLoginScene.ChgPwClick;
begin
  ChangeLoginState(lsChgpw);
end;

function TLoginScene.CheckUserEntrys: Boolean;
begin
  Result := FALSE;
  m_EdNewId.Text := Trim(m_EdNewId.Text);
  m_EdQuiz1.Text := Trim(m_EdQuiz1.Text);
  m_EdYourName.Text := Trim(m_EdYourName.Text);
  if not NewIdCheckNewId then Exit;

  if not EnglishVersion then begin //康巩 滚傈俊辑绰 眉农救窃
    if not NewIdCheckSSno then
      Exit;
  end;

  if not NewIdCheckBirthDay then Exit;
  if Length(m_EdNewId.Text) < 3 then begin
    m_EdNewId.SetFocus;
    Exit;
  end;
  if Length(m_EdNewPasswd.Text) < 3 then begin
    m_EdNewPasswd.SetFocus;
    Exit;
  end;
  if m_EdNewPasswd.Text <> m_EdConfirm.Text then begin
    m_EdConfirm.SetFocus;
    Exit;
  end;
  if Length(m_EdQuiz1.Text) < 1 then begin
    m_EdQuiz1.SetFocus;
    Exit;
  end;
  if Length(m_EdAnswer1.Text) < 1 then begin
    m_EdAnswer1.SetFocus;
    Exit;
  end;
  if Length(m_EdQuiz2.Text) < 1 then begin
    m_EdQuiz2.SetFocus;
    Exit;
  end;
  if Length(m_EdAnswer2.Text) < 1 then begin
    m_EdAnswer2.SetFocus;
    Exit;
  end;
  if Length(m_EdYourName.Text) < 1 then begin
    m_EdYourName.SetFocus;
    Exit;
  end;
  if not EnglishVersion then begin //康巩 滚傈俊辑绰 眉农救窃
    if Length(m_EdSSNo.Text) < 1 then begin
      m_EdSSNo.SetFocus;
      Exit;
    end;
  end;
  Result := True;
end;

procedure TLoginScene.NewAccountOk;
var
  ue: TUserEntry;
  ua: TUserEntryAdd;
begin
  if CheckUserEntrys then begin
    FillChar(ue, sizeof(TUserEntry), #0);
    FillChar(ua, sizeof(TUserEntryAdd), #0);
    ue.sAccount := LowerCase(m_EdNewId.Text);
    ue.sPassword := m_EdNewPasswd.Text;
    ue.sUserName := m_EdYourName.Text;
    //
    if not EnglishVersion then
      ue.sSSNo := m_EdSSNo.Text
    else
      ue.sSSNo := '650101-1455111';

    ue.sQuiz := m_EdQuiz1.Text;
    ue.sAnswer := Trim(m_EdAnswer1.Text);
    ue.sPhone := m_EdPhone.Text;
    ue.sEMail := Trim(m_EdEMail.Text);

    ua.sQuiz2 := m_EdQuiz2.Text;
    ua.sAnswer2 := Trim(m_EdAnswer2.Text);
    ua.sBirthDay := m_EdBirthDay.Text;
    ua.sMobilePhone := m_EdMobPhone.Text;

    m_NewIdRetryUE := ue; //犁矫档锭 荤侩
    m_NewIdRetryUE.sAccount := '';
    m_NewIdRetryUE.sPassword := '';
    m_NewIdRetryAdd := ua;

    if not m_boUpdateAccountMode then
      frmMain.SendNewAccount(ue, ua)
    else
      frmMain.SendUpdateAccount(ue, ua);
    m_boUpdateAccountMode := FALSE;
    NewAccountClose;
  end;
end;

procedure TLoginScene.NewAccountClose;
begin
  if not m_boUpdateAccountMode then
    ChangeLoginState(lsLogin);
end;

procedure TLoginScene.ChgpwOk;
var
  uid, passwd, newpasswd: string;
begin
  if m_EdChgNewPw.Text = m_EdChgRepeat.Text then begin
    uid := m_EdChgId.Text;
    passwd := m_EdChgCurrentpw.Text;
    newpasswd := m_EdChgNewPw.Text;
    frmMain.SendChgPw(uid, passwd, newpasswd);
    ChgpwCancel;
  end else begin
    FrmDlg.DMessageDlg('二次输入的密码不匹配！！！。', [mbOk]);
    m_EdChgNewPw.SetFocus;
  end;
end;

procedure TLoginScene.ChgpwCancel;
begin
  ChangeLoginState(lsLogin);
end;


{-------------------- TSelectChrScene ------------------------}

constructor TSelectChrScene.Create;
begin
  CreateChrMode := FALSE;
  FillChar(ChrArr, sizeof(TSelChar) * 2, #0);
  ChrArr[0].FreezeState := True; //扁夯捞 倔绢 乐绰 惑怕
  ChrArr[1].FreezeState := True;
  NewIndex := 0;
  EdChrName := TEdit.Create(frmMain.Owner);
  with EdChrName do begin
    Parent := frmMain;
    Height := 16;
    Width := 137;
    BorderStyle := bsNone;
    Color := clBlack;
    Font.Color := clWhite;
    ImeMode := LocalLanguage;
    MaxLength := 14;
    Visible := FALSE;
    OnKeyPress := EdChrnameKeyPress;
  end;
  SoundTimer := TTimer.Create(frmMain.Owner);
  with SoundTimer do begin
    OnTimer := SoundOnTimer;
    Interval := 1;
    Enabled := FALSE;
  end;
  inherited Create(stSelectChr);
end;

destructor TSelectChrScene.Destroy;
begin
  inherited Destroy;
end;

procedure TSelectChrScene.OpenScene;
begin
  FrmDlg.DSelectChr.Visible := True;
  SoundTimer.Enabled := True;
  SoundTimer.Interval := 1;
end;

procedure TSelectChrScene.CloseScene;
begin
  SilenceSound;
  FrmDlg.DSelectChr.Visible := FALSE;
  SoundTimer.Enabled := FALSE;
end;

procedure TSelectChrScene.SoundOnTimer(Sender: TObject);
begin
  PlayBGM(bmg_select);
  SoundTimer.Enabled := FALSE;
  //SoundTimer.Interval := 38 * 1000;
end;

procedure TSelectChrScene.SelChrSelect1Click;
begin
  if (not ChrArr[0].Selected) and (ChrArr[0].Valid) then begin
    frmMain.SelectChr(ChrArr[0].UserChr.name); //2004/05/17
    ChrArr[0].Selected := True;
    ChrArr[1].Selected := FALSE;
    ChrArr[0].Unfreezing := True;
    ChrArr[0].AniIndex := 0;
    ChrArr[0].DarkLevel := 0;
    ChrArr[0].EffIndex := 0;
    ChrArr[0].StartTime := GetTickCount;
    ChrArr[0].moretime := GetTickCount;
    ChrArr[0].startefftime := GetTickCount;
    PlaySound(s_meltstone);
  end;
end;

procedure TSelectChrScene.SelChrSelect2Click;
begin
  if (not ChrArr[1].Selected) and (ChrArr[1].Valid) then begin
    frmMain.SelectChr(ChrArr[1].UserChr.name); //2004/05/17
    ChrArr[1].Selected := True;
    ChrArr[0].Selected := FALSE;
    ChrArr[1].Unfreezing := True;
    ChrArr[1].AniIndex := 0;
    ChrArr[1].DarkLevel := 0;
    ChrArr[1].EffIndex := 0;
    ChrArr[1].StartTime := GetTickCount;
    ChrArr[1].moretime := GetTickCount;
    ChrArr[1].startefftime := GetTickCount;
    PlaySound(s_meltstone);
  end;
end;

procedure TSelectChrScene.SelChrStartClick;
var
  chrname: string;
begin
  chrname := '';
  if ChrArr[0].Valid and ChrArr[0].Selected then chrname := ChrArr[0].UserChr.name;
  if ChrArr[1].Valid and ChrArr[1].Selected then chrname := ChrArr[1].UserChr.name;
  if chrname <> '' then begin
    if not g_boDoFadeOut and not g_boDoFadeIn then begin
      g_boDoFastFadeOut := True;
      g_nFadeIndex := 29;
    end;
    frmMain.SendSelChr(chrname);
  end else
    FrmDlg.DMessageDlg('还没创建游戏角色！\点击创建角色按钮创建一个游戏角色。', [mbOk]);
end;

procedure TSelectChrScene.SelChrNewChrClick;
begin
  if not ChrArr[0].Valid or not ChrArr[1].Valid then begin
    if not ChrArr[0].Valid then MakeNewChar(0)
    else MakeNewChar(1);
  end else
    FrmDlg.DMessageDlg('一个帐号最多只能创建二个游戏角色！', [mbOk]);
end;

procedure TSelectChrScene.SelChrEraseChrClick;
var
  n: Integer;
begin
  n := 0;
  if ChrArr[0].Valid and ChrArr[0].Selected then n := 0;
  if ChrArr[1].Valid and ChrArr[1].Selected then n := 1;
  if (ChrArr[n].Valid) and (not ChrArr[n].FreezeState) and (ChrArr[n].UserChr.name <> '') then begin
    //版绊 皋技瘤甫 焊辰促.
    if mrYes = FrmDlg.DMessageDlg('"' + ChrArr[n].UserChr.name + '" 是否确认删除此游戏角色？', [mbYes, mbNo, mbCancel]) then
      frmMain.SendDelChr(ChrArr[n].UserChr.name);
  end;
end;

procedure TSelectChrScene.SelChrCreditsClick;
begin
end;

procedure TSelectChrScene.SelChrExitClick;
begin
  frmMain.Close;
end;

procedure TSelectChrScene.ClearChrs;
begin
  FillChar(ChrArr, sizeof(TSelChar) * 2, #0);
  ChrArr[0].FreezeState := FALSE;
  ChrArr[1].FreezeState := True; //扁夯捞 倔绢 乐绰 惑怕
  ChrArr[0].Selected := True;
  ChrArr[1].Selected := FALSE;
  ChrArr[0].UserChr.name := '';
  ChrArr[1].UserChr.name := '';
end;

procedure TSelectChrScene.AddChr(uname: string; job, hair, Level, sex: Integer);
var
  n: Integer;
begin
  if not ChrArr[0].Valid then n := 0
  else if not ChrArr[1].Valid then n := 1
  else Exit;
  ChrArr[n].UserChr.name := uname;
  ChrArr[n].UserChr.job := job;
  ChrArr[n].UserChr.hair := hair;
  ChrArr[n].UserChr.Level := Level;
  ChrArr[n].UserChr.sex := sex;
  ChrArr[n].Valid := True;
end;

procedure TSelectChrScene.MakeNewChar(Index: Integer);
begin
  CreateChrMode := True;
  NewIndex := Index;
  if Index = 0 then begin
    FrmDlg.DCreateChr.Left := 415;
    FrmDlg.DCreateChr.Top := 15;
  end else begin
    FrmDlg.DCreateChr.Left := 75;
    FrmDlg.DCreateChr.Top := 15;
  end;
  FrmDlg.DCreateChr.Visible := True;
  ChrArr[NewIndex].Valid := True;
  ChrArr[NewIndex].FreezeState := FALSE;
  EdChrName.Left := FrmDlg.DCreateChr.Left + 71;
  EdChrName.Top := FrmDlg.DCreateChr.Top + 107;
  EdChrName.Visible := True;
  EdChrName.SetFocus;
  SelectChr(NewIndex);
  FillChar(ChrArr[NewIndex].UserChr, sizeof(TUserCharacterInfo), #0);
end;

procedure TSelectChrScene.EdChrnameKeyPress(Sender: TObject; var Key: Char);
begin

end;


procedure TSelectChrScene.SelectChr(Index: Integer);
begin
  ChrArr[Index].Selected := True;
  ChrArr[Index].DarkLevel := 30;
  ChrArr[Index].StartTime := GetTickCount;
  ChrArr[Index].moretime := GetTickCount;
  if Index = 0 then ChrArr[1].Selected := FALSE
  else ChrArr[0].Selected := FALSE;
end;

procedure TSelectChrScene.SelChrNewClose;
begin
  ChrArr[NewIndex].Valid := FALSE;
  CreateChrMode := FALSE;
  FrmDlg.DCreateChr.Visible := FALSE;
  EdChrName.Visible := FALSE;
  if NewIndex = 1 then begin
    ChrArr[0].Selected := True;
    ChrArr[0].FreezeState := FALSE;
  end;
end;

procedure TSelectChrScene.SelChrNewOk;
var
  chrname, shair, sjob, ssex: string;
begin
  chrname := Trim(EdChrName.Text);
  if chrname <> '' then begin
    ChrArr[NewIndex].Valid := FALSE;
    CreateChrMode := FALSE;
    FrmDlg.DCreateChr.Visible := FALSE;
    EdChrName.Visible := FALSE;
    if NewIndex = 1 then begin
      ChrArr[0].Selected := True;
      ChrArr[0].FreezeState := FALSE;
    end;
    shair := IntToStr(1 + Random(5)); //////****IntToStr(ChrArr[NewIndex].UserChr.Hair);
    sjob := IntToStr(ChrArr[NewIndex].UserChr.job);
    ssex := IntToStr(ChrArr[NewIndex].UserChr.sex);
    frmMain.SendNewChr(frmMain.LoginID, chrname, shair, sjob, ssex); //货 某腐磐甫 父电促.
  end;
end;

procedure TSelectChrScene.SelChrNewJob(job: Integer);
begin
  if (job in [0..2]) and (ChrArr[NewIndex].UserChr.job <> job) then begin
    ChrArr[NewIndex].UserChr.job := job;
    SelectChr(NewIndex);
  end;
end;

procedure TSelectChrScene.SelChrNewm_btSex(sex: Integer);
begin
  if sex <> ChrArr[NewIndex].UserChr.sex then begin
    ChrArr[NewIndex].UserChr.sex := sex;
    SelectChr(NewIndex);
  end;
end;

procedure TSelectChrScene.SelChrNewPrevHair;
begin
end;

procedure TSelectChrScene.SelChrNewNextHair;
begin
end;

procedure TSelectChrScene.PlayScene(MSurface: TDirectDrawSurface);
var
  n, bx, by, fx, fy, img: Integer;
  ex, ey: Integer; //选择人物时显示的效果光位置
  d, E, dd: TDirectDrawSurface;
  svname: string;
begin
  bx := 0;
  by := 0;
  fx := 0;
  fy := 0; //Jacky
{$IF SWH = SWH800}
  d := g_WMainImages.Images[65];
{$ELSEIF SWH = SWH1024}
  //   d := g_WMainImages.Images[82];
  d := g_WMainImages.Images[65];
{$IFEND}
  //显示选择人物背景画面
  if d <> nil then begin
    //      MSurface.Draw (0, 0, d.ClientRect, d, FALSE);
    MSurface.Draw((SCREENWIDTH - d.Width) div 2, (SCREENHEIGHT - d.Height) div 2, d.ClientRect, d, FALSE);

  end;
  for n := 0 to 1 do begin
    if ChrArr[n].Valid then begin
      ex := (SCREENWIDTH - 800) div 2 + 90 {90};
      ey := (SCREENHEIGHT - 600) div 2 + 60 - 2 {60-2};
      case ChrArr[n].UserChr.job of
        0: begin
            if ChrArr[n].UserChr.sex = 0 then begin
              bx := (SCREENWIDTH - 800) div 2 + 71 {71};
              by := (SCREENHEIGHT - 600) div 2 + 75 - 23 {75-23}; //巢磊
              fx := bx;
              fy := by;
            end else begin
              bx := (SCREENWIDTH - 800) div 2 + 65 {65};
              by := (SCREENHEIGHT - 600) div 2 + 75 - 2 - 18 {75-2-18}; //咯磊  倒惑怕
              fx := bx - 28 + 28;
              fy := by - 16 + 16; //框流捞绰 惑怕
            end;
          end;
        1: begin
            if ChrArr[n].UserChr.sex = 0 then begin
              bx := (SCREENWIDTH - 800) div 2 + 77 {77};
              by := (SCREENHEIGHT - 600) div 2 + 75 - 29 {75-29};
              fx := bx;
              fy := by;
            end else begin
              bx := (SCREENWIDTH - 800) div 2 + 141 + 30 {141+30};
              by := (SCREENHEIGHT - 600) div 2 + 85 + 14 - 2 {85+14-2};
              fx := bx - 30;
              fy := by - 14;
            end;
          end;
        2: begin
            if ChrArr[n].UserChr.sex = 0 then begin
              bx := (SCREENWIDTH - 800) div 2 + 85 {85};
              by := (SCREENHEIGHT - 600) div 2 + 75 - 12 {75-12};
              fx := bx;
              fy := by;
            end else begin
              bx := (SCREENWIDTH - 800) div 2 + 141 + 23 {141+23};
              by := (SCREENHEIGHT - 600) div 2 + 85 + 20 - 2 {85+20-2};
              fx := bx - 23;
              fy := by - 20;
            end;
          end;
      end;
      if n = 1 then begin
        ex := (SCREENWIDTH - 800) div 2 + 430 {430};
        ey := (SCREENHEIGHT - 600) div 2 + 60 {60};
        bx := bx + 340;
        by := by + 2;
        fx := fx + 340;
        fy := fy + 2;
      end;
      if ChrArr[n].Unfreezing then begin //踌绊 乐绰 吝
        img := 140 - 80 + ChrArr[n].UserChr.job * 40 + ChrArr[n].UserChr.sex * 120;
        d := g_WChrSelImages.Images[img + ChrArr[n].AniIndex];
        E := g_WChrSelImages.Images[4 + ChrArr[n].EffIndex];
        if d <> nil then MSurface.Draw(bx, by, d.ClientRect, d, True);
        if E <> nil then DrawBlend(MSurface, ex, ey, E, 1);
        if GetTickCount - ChrArr[n].StartTime > 50 {120} then begin
          ChrArr[n].StartTime := GetTickCount;
          ChrArr[n].AniIndex := ChrArr[n].AniIndex + 1;
        end;
        if GetTickCount - ChrArr[n].startefftime > 50 { 110} then begin
          ChrArr[n].startefftime := GetTickCount;
          ChrArr[n].EffIndex := ChrArr[n].EffIndex + 1;
          //if ChrArr[n].effIndex > EFFECTFRAME-1 then
          //   ChrArr[n].effIndex := EFFECTFRAME-1;
        end;
        if ChrArr[n].AniIndex > FREEZEFRAME - 1 then begin
          ChrArr[n].Unfreezing := FALSE; //促 踌疽澜
          ChrArr[n].FreezeState := FALSE; //
          ChrArr[n].AniIndex := 0;
        end;
      end else
        if not ChrArr[n].Selected and (not ChrArr[n].FreezeState and not ChrArr[n].Freezing) then begin //急琶登瘤 臼疽绰单 踌酒乐栏搁
        ChrArr[n].Freezing := True;
        ChrArr[n].AniIndex := 0;
        ChrArr[n].StartTime := GetTickCount;
      end;
      if ChrArr[n].Freezing then begin //倔绊 乐绰 吝
        img := 140 - 80 + ChrArr[n].UserChr.job * 40 + ChrArr[n].UserChr.sex * 120;
        d := g_WChrSelImages.Images[img + FREEZEFRAME - ChrArr[n].AniIndex - 1];
        if d <> nil then MSurface.Draw(bx, by, d.ClientRect, d, True);
        if GetTickCount - ChrArr[n].StartTime > 50 then begin
          ChrArr[n].StartTime := GetTickCount;
          ChrArr[n].AniIndex := ChrArr[n].AniIndex + 1;
        end;
        if ChrArr[n].AniIndex > FREEZEFRAME - 1 then begin
          ChrArr[n].Freezing := FALSE; //促 倔菌澜
          ChrArr[n].FreezeState := True; //
          ChrArr[n].AniIndex := 0;
        end;
      end;
      if not ChrArr[n].Unfreezing and not ChrArr[n].Freezing then begin
        if not ChrArr[n].FreezeState then begin //踌酒乐绰惑怕
          img := 120 - 80 + ChrArr[n].UserChr.job * 40 + ChrArr[n].AniIndex + ChrArr[n].UserChr.sex * 120;
          d := g_WChrSelImages.Images[img];
          if d <> nil then begin
            if ChrArr[n].DarkLevel > 0 then begin
              dd := TDirectDrawSurface.Create(frmMain.DXDraw.DDraw);
              dd.SystemMemory := True;
              dd.SetSize(d.Width, d.Height);
              dd.Draw(0, 0, d.ClientRect, d, FALSE);
              MakeDark(dd, 30 - ChrArr[n].DarkLevel);
              MSurface.Draw(fx, fy, dd.ClientRect, dd, True);
              dd.Free;
            end else
              MSurface.Draw(fx, fy, d.ClientRect, d, True);

          end;
        end else begin //倔绢乐绰惑怕
          img := 140 - 80 + ChrArr[n].UserChr.job * 40 + ChrArr[n].UserChr.sex * 120;
          d := g_WChrSelImages.Images[img];
          if d <> nil then
            MSurface.Draw(bx, by, d.ClientRect, d, True);
        end;
        if ChrArr[n].Selected then begin
          if GetTickCount - ChrArr[n].StartTime > 300 then begin
            ChrArr[n].StartTime := GetTickCount;
            ChrArr[n].AniIndex := ChrArr[n].AniIndex + 1;
            if ChrArr[n].AniIndex > SELECTEDFRAME - 1 then
              ChrArr[n].AniIndex := 0;
          end;
          if GetTickCount - ChrArr[n].moretime > 25 then begin
            ChrArr[n].moretime := GetTickCount;
            if ChrArr[n].DarkLevel > 0 then
              ChrArr[n].DarkLevel := ChrArr[n].DarkLevel - 1;
          end;
        end;
      end;
      //显示选择角色时人物名称等级
      if n = 0 then begin
        if ChrArr[n].UserChr.name <> '' then begin
          with MSurface do begin
            SetBkMode(Canvas.Handle, TRANSPARENT);
            BoldTextOut(MSurface, (SCREENWIDTH - 800) div 2 + 117 {117}, (SCREENHEIGHT - 600) div 2 + 492 + 2 {492+2}, clWhite, clBlack, ChrArr[n].UserChr.name);
            BoldTextOut(MSurface, (SCREENWIDTH - 800) div 2 + 117 {117}, (SCREENHEIGHT - 600) div 2 + 523 {523}, clWhite, clBlack, IntToStr(ChrArr[n].UserChr.Level));
            BoldTextOut(MSurface, (SCREENWIDTH - 800) div 2 + 117 {117}, (SCREENHEIGHT - 600) div 2 + 553 {553}, clWhite, clBlack, GetJobName(ChrArr[n].UserChr.job));
            Canvas.Release;
          end;
        end;
      end else begin
        if ChrArr[n].UserChr.name <> '' then begin
          with MSurface do begin
            SetBkMode(Canvas.Handle, TRANSPARENT);
            BoldTextOut(MSurface, (SCREENWIDTH - 800) div 2 + 671 {671}, (SCREENHEIGHT - 600) div 2 + 492 + 2 {492+4}, clWhite, clBlack, ChrArr[n].UserChr.name);
            BoldTextOut(MSurface, (SCREENWIDTH - 800) div 2 + 671 {671}, (SCREENHEIGHT - 600) div 2 + 525 + 2 {525}, clWhite, clBlack, IntToStr(ChrArr[n].UserChr.Level));
            BoldTextOut(MSurface, (SCREENWIDTH - 800) div 2 + 671 {671}, (SCREENHEIGHT - 600) div 2 + 555 + 2 {555}, clWhite, clBlack, GetJobName(ChrArr[n].UserChr.job));
            Canvas.Release;
          end;
        end;
      end;
      with MSurface do begin
        SetBkMode(Canvas.Handle, TRANSPARENT);
        if BO_FOR_TEST then svname := '叶随风飘'
        else svname := g_sServerName;
        BoldTextOut(MSurface, SCREENWIDTH div 2 {405} - Canvas.TextWidth(svname) div 2, (SCREENHEIGHT - 600) div 2 + 8 {8}, clWhite, clBlack, svname);
        Canvas.Release;
      end;
    end;
  end;
end;


{--------------------------- TLoginNotice ----------------------------}

constructor TLoginNotice.Create;
begin
  inherited Create(stLoginNotice);
end;

destructor TLoginNotice.Destroy;
begin
  inherited Destroy;
end;


end.

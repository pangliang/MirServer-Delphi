{人形怪物 分身}

unit ObjPlayMon;

interface
uses
  Windows, SysUtils, StrUtils, Classes, Grobal2, ObjBase, IniFiles;
type
  TPlayMonster = class(TBaseObject)
    n54C: Integer;
    m_dwThinkTick: LongWord;
    bo554: Boolean;
    m_boDupMode: Boolean;
    m_nNotProcessCount: Integer; //未被处理次数，用于怪物处理循环
    m_nTargetX: Integer;
    m_nTargetY: Integer;
    m_boRunAwayMode: Boolean;
    m_dwRunAwayStart: LongWord;
    m_dwRunAwayTime: LongWord;
    m_boCanPickUpItem: Boolean;
    m_boSlavePickUpItem: Boolean;
    m_dwPickUpItemTick: LongWord;
    m_boPickUpItemOK: Boolean;
    m_nPickUpItemMakeIndex: Integer;
    m_wHitMode: Word;
    m_dwAutoAvoidTick: LongWord; //自动躲避间隔
    m_boAutoAvoid: Boolean; //是否躲避
    m_boDoSpellMagic: Boolean; //是否可以使用魔法
    m_dwDoSpellMagicTick: LongWord; //使用魔法间隔
    m_boGotoTargetXY: Boolean;
    m_SkillShieldTick: LongWord; //魔法盾使用间隔
    m_SkillBigHealling: LongWord; //群体治疗术使用间隔
    m_SkillDejiwonho: LongWord; //神圣战甲术使用间隔
    m_dwCheckDoSpellMagic: LongWord;
    m_nDieDropUseItemRate: Integer; //死亡掉装备几率
    wSkill_01: Word; //雷电术
    wSkill_02: Word; //地狱雷光
    wSkill_03: Word; //冰咆哮
    wSkill_04: Word; //火龙气焰
    wSkill_05: Word; //魔法盾

    wSkill_06: Word; //施毒术
    wSkill_07: Word; //灵魂火符
    wSkill_08: Word; //神圣战甲术
    wSkill_09: Word; //群体治疗术
    wSkill_10: Word; //群体施毒术

    wSkill_11: Word; //烈火剑法
    wSkill_12: Word; //刺杀剑法
    wSkill_13: Word; //半月弯刀
  private
    function Think: Boolean;
    function GetSpellPoint(UserMagic: pTUserMagic): Integer;
    function AllowFireHitSkill(): Boolean; {烈火}
    function DoSpellMagic(wMagIdx: Word): Boolean;
    procedure SearchPickUpItem(dwSearchTime: LongWord);
    procedure EatMedicine();

    function WarrAttackTarget(wHitMode: Word): Boolean; {物理攻击}
    function WarrorAttackTarget(): Boolean; {战士攻击}
    function WizardAttackTarget(): Boolean; {法师攻击}
    function TaoistAttackTarget(): Boolean; {道士攻击}

    function EatUseItems(btItemType: Byte): Boolean; {自动吃药}
    function AutoAvoid(): Boolean; //自动躲避

    function SearchPickUpItemOK(): Boolean;
    function IsPickUpItem(StdItem: pTStdItem): Boolean;
    function WalkToTargetXY(nTargetX, nTargetY: Integer): Boolean;

    function CheckSlaveTarget(TargetObject: TBaseObject): Boolean; //检测是否是其他宝宝的目标
    function CheckSlavePickUpItem(): Boolean; //检测其他宝宝是不是正在拣物品
    function StartAutoAvoid(): Boolean;
    function CheckUserMagic(wMagIdx: Word): Integer;
    function CheckTargetXYCount(nX, nY, nRange: Integer): Integer;
    function AllowGotoTargetXY(): Boolean;
    procedure GotoTargetXYRange();
    function GetUserItemList(nItemType: Integer): Integer;
    function UseItem(nItemType, nIndex: Integer): Boolean;
    function CheckUserItemType(nItemType: Integer): Boolean;
    function CheckItemType(nItemType: Integer; StdItem: pTStdItem): Boolean;

    function CheckDoSpellMagic(): Boolean;

    function CheckTakeOnItems(nWhere: Integer; var StdItem: TStdItem): Boolean;
    function FindMagic(sMagicName: string): pTUserMagic;
    function CheckTargetXYCountOfDirection(nX, nY, nDir, nRange: Integer): Integer;
  public
    constructor Create(); override;
    destructor Destroy; override;
    function Operate(ProcessMsg: pTProcessMessage): Boolean; override;
    function AttackTarget(): Boolean;
    function AddItems(UserItem: pTUserItem; btWhere: Integer): Boolean; //获取身上装备
    procedure Run; override;
    procedure SearchTarget();
    procedure DelTargetCreat(); override;
    procedure SetTargetXY(nX, nY: Integer); virtual;
    procedure GotoTargetXY(nTargetX, nTargetY: Integer); virtual;
    procedure Wondering(); virtual;
    procedure Attack(TargeTBaseObject: TBaseObject; nDir: Integer); virtual;
    procedure Struck(hiter: TBaseObject); virtual;
    procedure AddItemsFromConfig();
    procedure InitializeMonster;
  end;

implementation
uses UsrEngn, M2Share, Event, Envir, Magic, HUtil32;

{ TPlayMonster }

constructor TPlayMonster.Create;
begin
  inherited;
  m_boDupMode := False;
  bo554 := False;
  m_dwThinkTick := GetTickCount();
  m_nViewRange := 10;
  m_nRunTime := 250;
  m_dwSearchTime := 3000 + Random(2000);
  m_dwSearchTick := GetTickCount();
  m_btRaceServer := RC_PLAYMOSTER;
  m_nCopyHumanLevel := 2;
  m_nNotProcessCount := 0;
  m_nTargetX := -1;
  dwTick3F0 := Random(4) * 500 + 1000;
  dwTick3F4 := GetTickCount();
  m_dwHitTick := GetTickCount - LongWord(Random(3000));
  m_dwWalkTick := GetTickCount - LongWord(Random(3000));
  m_nWalkSpeed := 300;
  m_nWalkStep := 10;
  m_dwWalkWait := 0;
  m_dwSearchEnemyTick := GetTickCount();
  m_boRunAwayMode := False;
  m_dwRunAwayStart := GetTickCount();
  m_dwRunAwayTime := 0;
  m_boCanPickUpItem := True;
  m_boSlavePickUpItem := False;
  m_dwPickUpItemTick := GetTickCount();
  m_boPickUpItemOK := True;
  m_dwAutoAvoidTick := GetTickCount(); //自动躲避间隔
  m_boAutoAvoid := True; //是否躲避
  m_boDoSpellMagic := True; //是否使用魔法
  m_boGotoTargetXY := True; //是否走向目标
  m_nNextHitTime := 300;
  m_dwDoSpellMagicTick := GetTickCount(); //使用魔法间隔
  m_SkillShieldTick := GetTickCount(); //魔法盾使用魔法间隔
  m_SkillBigHealling := GetTickCount(); //群体治疗术使用间隔
  m_SkillDejiwonho := GetTickCount(); //神圣战甲术使用间隔
  m_dwCheckDoSpellMagic := GetTickCount();
  m_nDieDropUseItemRate := 100;
end;

destructor TPlayMonster.Destroy;
begin
  inherited;
end;

procedure TPlayMonster.InitializeMonster;
var
  i: Integer;
begin
  AddItemsFromConfig();
  case m_btJob of
    0: begin
        wSkill_11 := CheckUserMagic(SKILL_FIRESWORD); //烈火剑法
        wSkill_12 := CheckUserMagic(SKILL_ERGUM); //刺杀剑法
        wSkill_13 := CheckUserMagic(SKILL_BANWOL); //半月弯刀
      end;
    1: begin
        wSkill_01 := CheckUserMagic(SKILL_LIGHTENING); //雷电术
        wSkill_02 := CheckUserMagic(SKILL_LIGHTFLOWER); //地狱雷光
        wSkill_03 := CheckUserMagic(SKILL_SNOWWIND); //冰咆哮
        wSkill_04 := CheckUserMagic(SKILL_47); //火龙气焰
        wSkill_05 := CheckUserMagic(SKILL_SHIELD); //魔法盾
        if (wSkill_01 = 0) and (wSkill_02 = 0) and (wSkill_03 = 0) and (wSkill_04 = 0) then m_boDoSpellMagic := False;
      end;
    2: begin
        wSkill_06 := CheckUserMagic(SKILL_AMYOUNSUL); //施毒术
        wSkill_07 := CheckUserMagic(SKILL_FIRECHARM); //灵魂火符
        wSkill_08 := CheckUserMagic(SKILL_DEJIWONHO); //神圣战甲术
        wSkill_09 := CheckUserMagic(SKILL_BIGHEALLING); //群体治疗术
        wSkill_10 := CheckUserMagic(SKILL_GROUPAMYOUNSUL); //群体施毒术
        if (wSkill_06 = 0) and (wSkill_07 = 0) and (wSkill_10 = 0) then m_boDoSpellMagic := False;
      end;
  end;
end;

procedure TPlayMonster.GotoTargetXY(nTargetX, nTargetY: Integer);
var
  i: Integer;
  nDir: Integer;
  n10: Integer;
  n14: Integer;
  n20: Integer;
  nOldX: Integer;
  nOldY: Integer;
  n16: Integer;
begin
  if ((m_nCurrX <> nTargetX) or (m_nCurrY <> nTargetY)) then begin
    n10 := nTargetX;
    n14 := nTargetY;
    dwTick3F4 := GetTickCount();
    nDir := DR_DOWN;
    if n10 > m_nCurrX then begin
      nDir := DR_RIGHT;
      if n14 > m_nCurrY then nDir := DR_DOWNRIGHT;
      if n14 < m_nCurrY then nDir := DR_UPRIGHT;
    end else begin
      if n10 < m_nCurrX then begin
        nDir := DR_LEFT;
        if n14 > m_nCurrY then nDir := DR_DOWNLEFT;
        if n14 < m_nCurrY then nDir := DR_UPLEFT;
      end else begin
        if n14 > m_nCurrY then nDir := DR_DOWN
        else if n14 < m_nCurrY then nDir := DR_UP;
      end;
    end;
    nOldX := m_nCurrX;
    nOldY := m_nCurrY;
    if (abs(m_nCurrX - nTargetX) >= 3) or (abs(m_nCurrY - nTargetY) >= 3) then begin
      if not RunTo(nDir, False, nTargetX, nTargetY) then begin
        WalkTo(nDir, False);
        n20 := Random(3);
        for i := DR_UP to DR_UPLEFT do begin
          if (nOldX = m_nCurrX) and (nOldY = m_nCurrY) then begin
            if n20 <> 0 then Inc(nDir)
            else if nDir > 0 then Dec(nDir)
            else nDir := DR_UPLEFT;
            if (nDir > DR_UPLEFT) then nDir := DR_UP;
            WalkTo(nDir, False);
          end;
        end;
      end;
    end else begin
      WalkTo(nDir, False);
      n20 := Random(3);
      for i := DR_UP to DR_UPLEFT do begin
        if (nOldX = m_nCurrX) and (nOldY = m_nCurrY) then begin
          if n20 <> 0 then Inc(nDir)
          else if nDir > 0 then Dec(nDir)
          else nDir := DR_UPLEFT;
          if (nDir > DR_UPLEFT) then nDir := DR_UP;
          WalkTo(nDir, False);
        end;
      end;
    end;
  end;
end;

function TPlayMonster.WalkToTargetXY(nTargetX, nTargetY: Integer): Boolean;
var
  i: Integer;
  nDir: Integer;
  n10: Integer;
  n14: Integer;
  n20: Integer;
  nOldX: Integer;
  nOldY: Integer;
  n16: Integer;
begin
  Result := False;
  if ((m_nCurrX <> nTargetX) or (m_nCurrY <> nTargetY)) then begin
    n10 := nTargetX;
    n14 := nTargetY;
    dwTick3F4 := GetTickCount();
    nDir := DR_DOWN;
    if n10 > m_nCurrX then begin
      nDir := DR_RIGHT;
      if n14 > m_nCurrY then nDir := DR_DOWNRIGHT;
      if n14 < m_nCurrY then nDir := DR_UPRIGHT;
    end else begin
      if n10 < m_nCurrX then begin
        nDir := DR_LEFT;
        if n14 > m_nCurrY then nDir := DR_DOWNLEFT;
        if n14 < m_nCurrY then nDir := DR_UPLEFT;
      end else begin
        if n14 > m_nCurrY then nDir := DR_DOWN
        else if n14 < m_nCurrY then nDir := DR_UP;
      end;
    end;
    nOldX := m_nCurrX;
    nOldY := m_nCurrY;
    WalkTo(nDir, False);
    if (nTargetX = m_nCurrX) and (nTargetY = m_nCurrY) then Result := True;
    if not Result then begin
      n20 := Random(3);
      for i := DR_UP to DR_UPLEFT do begin
        if (nOldX = m_nCurrX) and (nOldY = m_nCurrY) then begin
          if n20 <> 0 then Inc(nDir)
          else if nDir > 0 then Dec(nDir)
          else nDir := DR_UPLEFT;
          if (nDir > DR_UPLEFT) then nDir := DR_UP;
          WalkTo(nDir, False);
          if (nTargetX = m_nCurrX) and (nTargetY = m_nCurrY) then begin
            Result := True;
            break;
          end;
        end;
      end;
    end;
  end;
end;

function TPlayMonster.Operate(ProcessMsg: pTProcessMessage): Boolean;
begin
  //  Result:=False;
  if ProcessMsg.wIdent = RM_STRUCK then begin
    if (ProcessMsg.BaseObject = Self) and (TBaseObject(ProcessMsg.nParam3 {AttackBaseObject}) <> nil) then begin
      SetLastHiter(TBaseObject(ProcessMsg.nParam3 {AttackBaseObject}));
      Struck(TBaseObject(ProcessMsg.nParam3 {AttackBaseObject})); {0FFEC}
      BreakHolySeizeMode();
      if (m_Master <> nil) and
        (TBaseObject(ProcessMsg.nParam3) <> m_Master) and
        (TBaseObject(ProcessMsg.nParam3).m_btRaceServer = RC_PLAYOBJECT) then begin
        m_Master.SetPKFlag(TBaseObject(ProcessMsg.nParam3));
      end;
      if g_Config.boMonSayMsg then MonsterSayMsg(TBaseObject(ProcessMsg.nParam3), s_UnderFire);
    end;
    Result := True;
  end else begin
    Result := inherited Operate(ProcessMsg);
  end;
end;

procedure TPlayMonster.Struck(hiter: TBaseObject);
var
  btDir: Byte;
begin
  m_dwStruckTick := GetTickCount;
  if hiter <> nil then begin
    if (m_TargetCret = nil) or GetAttackDir(m_TargetCret, btDir) or (Random(6) = 0) then begin
      if IsProperTarget(hiter) then
        SetTargetCreat(hiter);
    end;
  end;
  if m_boAnimal then begin
    m_nMeatQuality := m_nMeatQuality - Random(300);
    if m_nMeatQuality < 0 then m_nMeatQuality := 0;
  end;
  //if m_Abil.Level < 50 then
  m_dwHitTick := m_dwHitTick + LongWord(150 - _MIN(130, m_Abil.Level * 4));
  //WalkTime := WalkTime + (300 - _MIN(200, (Abil.Level div 5) * 20));
end;

procedure TPlayMonster.Attack(TargeTBaseObject: TBaseObject; nDir: Integer);
begin
  inherited AttackDir(TargeTBaseObject, m_wHitMode, nDir);
end;

procedure TPlayMonster.DelTargetCreat;
begin
  inherited;
  m_nTargetX := -1;
  m_nTargetY := -1;
end;

function TPlayMonster.CheckSlaveTarget(TargetObject: TBaseObject): Boolean;
var
  i: Integer;
begin
  Result := False;
  if m_Master <> nil then begin
    for i := 0 to m_Master.m_SlaveList.Count - 1 do begin
      if TBaseObject(m_Master.m_SlaveList.Items[i]).m_TargetCret = TargetObject then begin
        Result := True;
        break;
      end;
    end;
  end;
end;

function TPlayMonster.CheckSlavePickUpItem(): Boolean;
var
  i: Integer;
begin
  Result := False;
  if m_Master <> nil then begin
    for i := 0 to m_Master.m_SlaveList.Count - 1 do begin
      if TPlayMonster(m_Master.m_SlaveList.Items[i]).m_boSlavePickUpItem then begin
        Result := True;
        break;
      end;
    end;
  end;
end;

procedure TPlayMonster.SearchTarget;
var
  BaseObject, BaseObject18: TBaseObject;
  i, nC, n10: Integer;
begin
  BaseObject18 := nil;
  n10 := 999;
  for i := 0 to m_VisibleActors.Count - 1 do begin
    BaseObject := TBaseObject(pTVisibleBaseObject(m_VisibleActors.Items[i]).BaseObject);
    if BaseObject <> nil then begin
      if not BaseObject.m_boDeath then begin
        if IsProperTarget(BaseObject) and
          (not BaseObject.m_boHideMode or m_boCoolEye) then begin
          nC := abs(m_nCurrX - BaseObject.m_nCurrX) + abs(m_nCurrY - BaseObject.m_nCurrY);
          if nC < n10 then begin
            n10 := nC;
            BaseObject18 := BaseObject;
          end;
        end;
      end;
    end;
  end;
  if BaseObject18 <> nil then begin
    SetTargetCreat(BaseObject18);
  end;
end;

procedure TPlayMonster.SetTargetXY(nX, nY: Integer);
begin
  m_nTargetX := nX;
  m_nTargetY := nY;
end;

procedure TPlayMonster.Wondering;
begin
  if (Random(20) = 0) then
    if (Random(4) = 1) then TurnTo(Random(8))
    else WalkTo(m_btDirection, False);
end;

function TPlayMonster.CheckDoSpellMagic(): Boolean;
begin
  Result := True;
  if m_btJob > 0 then begin
    if m_btJob = 1 then begin
      if (wSkill_01 = 0) and (wSkill_02 = 0) and (wSkill_03 = 0) and (wSkill_04 = 0) then begin
        Result := False;
        Exit;
      end;
    end;
    if m_btJob = 2 then begin
      if (wSkill_06 = 0) and (wSkill_07 = 0) and (wSkill_10 = 0) then begin
        Result := False;
        Exit;
      end;
    end;
    if m_WAbil.MP = 0 then begin
      Result := False;
      Exit;
    end;
    if m_btJob = 2 then begin
      if (wSkill_06 > 0) or (wSkill_10 > 0) then begin
        Result := CheckUserItemType(2);
        if Result then Exit;
        if GetUserItemList(2) < 0 then Result := False else Result := True;
        if Result then Exit;
      end;
      if wSkill_07 > 0 then begin
        Result := CheckUserItemType(1);
        if Result then Exit;
        if GetUserItemList(1) < 0 then Result := False else Result := True;
        //MainoutMessage('Result '+BooleanToStr(Result));
      end;
    end;
  end;
end;

function TPlayMonster.Think(): Boolean;
var
  nOldX, nOldY: Integer;
  bt06: Byte;
  i: Integer;
begin
  Result := False;
  if (GetTickCount - m_dwThinkTick) > 3 * 1000 then begin
    m_dwThinkTick := GetTickCount();
    if m_PEnvir.GetXYObjCount(m_nCurrX, m_nCurrY) >= 2 then m_boDupMode := True;
    if not IsProperTarget(m_TargetCret) then m_TargetCret := nil;
  end;

  if SearchPickUpItemOK() then SearchPickUpItem(500); //捡药

  EatMedicine(); {吃药}

  if (GetTickCount - m_dwCheckDoSpellMagic) > 1000 then begin //检测是否可以使用魔法
    m_dwCheckDoSpellMagic := GetTickCount;
    m_boDoSpellMagic := CheckDoSpellMagic();
  end;
  if StartAutoAvoid and m_boDoSpellMagic then AutoAvoid(); {自动躲避}
  if m_boDupMode then begin
    nOldX := m_nCurrX;
    nOldY := m_nCurrY;
    WalkTo(Random(8), False);
    if (nOldX <> m_nCurrX) or (nOldY <> m_nCurrY) then begin
      m_boDupMode := False;
      Result := True;
    end;
  end;
end;

function TPlayMonster.SearchPickUpItemOK(): Boolean;
var
  VisibleMapItem: pTVisibleMapItem;
  MapItem: PTMapItem;
  i: Integer;
begin
  Result := False;
  if (m_VisibleItems.Count = 0) or (m_nCopyHumanLevel = 0) then Exit;
  if m_Master = nil then Exit;
  if (m_Master <> nil) and (m_Master.m_boDeath) then Exit;
  if m_TargetCret <> nil then begin
    if m_TargetCret.m_boDeath then begin
      m_TargetCret := nil;
      Result := True;
    end;
  end;
  //if (m_Master.m_WAbil.Weight >= m_Master.m_WAbil.MaxWeight) and (m_WAbil.Weight >= m_WAbil.MaxWeight) then Exit;
  if m_TargetCret = nil then begin
    for i := 0 to m_VisibleItems.Count - 1 do begin
      VisibleMapItem := pTVisibleMapItem(m_VisibleItems.Items[i]);
      if (VisibleMapItem <> nil) and (VisibleMapItem.nVisibleFlag > 0) then begin
        MapItem := VisibleMapItem.MapItem;
        if (MapItem <> nil) and (MapItem.DropBaseObject <> m_Master) then begin
          if IsAllowPickUpItem(VisibleMapItem.sName) then begin
            //if (MapItem.DropBaseObject <> nil) and (TBaseObject(MapItem.DropBaseObject).m_btRaceServer = RC_PLAYOBJECT) then Continue;
            if (MapItem.OfBaseObject = nil) or (MapItem.OfBaseObject = m_Master) or (MapItem.OfBaseObject = Self) then begin
              Result := True;
              break;
            end;
          end;
        end;
      end;
    end;
  end;
  if Result then begin
    if (m_ItemList.Count >= g_Config.nCopyHumanBagCount) and (not m_boCanPickUpItem) then begin
      Result := False;
    end;
    if m_boCanPickUpItem and (not TPlayObject(m_Master).IsEnoughBag) and (m_ItemList.Count >= g_Config.nCopyHumanBagCount) then begin
      Result := True;
    end;
  end;
end;

procedure TPlayMonster.GotoTargetXYRange();
var
  n10: Integer;
  n14: Integer;
  nTargetX: Integer;
  nTargetY: Integer;
begin
  if CheckTargetXYCount(m_nCurrX, m_nCurrY, 10) < 1 then begin
    n10 := abs(m_TargetCret.m_nCurrX - m_nCurrX);
    n14 := abs(m_TargetCret.m_nCurrY - m_nCurrY);
    if n10 > 4 then Dec(n10, 5) else n10 := 0;
    if n14 > 4 then Dec(n14, 5) else n14 := 0;
    if m_TargetCret.m_nCurrX > m_nCurrX then nTargetX := m_nCurrX + n10;
    if m_TargetCret.m_nCurrX < m_nCurrX then nTargetX := m_nCurrX - n10;
    if m_TargetCret.m_nCurrY > m_nCurrY then nTargetY := m_nCurrY + n14;
    if m_TargetCret.m_nCurrY < m_nCurrY then nTargetY := m_nCurrY - n14;
    GotoTargetXY(nTargetX, nTargetY);
  end;
end;

function TPlayMonster.AutoAvoid(): Boolean; //自动躲避
  function GetAvoidDir(): Integer;
  var
    n10: Integer;
    n14: Integer;
  begin
    n10 := m_TargetCret.m_nCurrX;
    n14 := m_TargetCret.m_nCurrY;
    Result := DR_DOWN;
    if n10 > m_nCurrX then begin
      Result := DR_LEFT;
      if n14 > m_nCurrY then Result := DR_DOWNLEFT;
      if n14 < m_nCurrY then Result := DR_UPLEFT;
    end else begin
      if n10 < m_nCurrX then begin
        Result := DR_RIGHT;
        if n14 > m_nCurrY then Result := DR_DOWNRIGHT;
        if n14 < m_nCurrY then Result := DR_UPRIGHT;
      end else begin
        if n14 > m_nCurrY then Result := DR_UP
        else if n14 < m_nCurrY then Result := DR_DOWN;
      end;
    end;
  end;

  function SearchNextDir(var nTargetX, nTargetY: Integer): Boolean;
  var
    i: Integer;
    nDir: Integer;
    n01: Integer;
    n02: Integer;
    n03: Integer;
    n04: Integer;
    n05: Integer;
    n06: Integer;
    n07: Integer;
    n08: Integer;
    n10: Integer;
    boGotoL2: Boolean;
  label L001;
  label L002;
  label L003;
  begin
    Result := False;
    if not Result then begin
      nDir := GetAvoidDir;
      boGotoL2 := False;
      goto L001;
    end;

    L002:
    if not Result then begin
      n10 := 0;
      while True do begin
        Inc(n10);
        nDir := Random(8);
        if nDir in [0..7] then break;
        if n10 > 8 then break;
      end;
      goto L001;
    end;

    L001:
    n01 := 0;
    n02 := 0;
    n03 := 0;
    n04 := 0;
    n05 := 0;
    n06 := 0;
    n07 := 0;
    n08 := 0;
    while True do begin
      if nDir > DR_UPLEFT then break;
      case nDir of
        DR_UP: begin
            if m_PEnvir.CanWalkEx(nTargetX, nTargetY, True) and (CheckTargetXYCountOfDirection(nTargetX, nTargetY, nDir, 6) = 0) then begin
              Inc(nTargetY, 10 - n01);
              Result := True;
              break;
            end else begin
              if n01 >= 10 then begin
                nTargetX := m_nCurrX;
                nTargetY := m_nCurrY;
                Inc(nDir);
                Continue;
              end;
              Inc(nTargetY);
              Inc(n01);
              Continue;
            end;
          end;
        DR_UPRIGHT: begin
            if m_PEnvir.CanWalkEx(nTargetX, nTargetY, True) and (CheckTargetXYCountOfDirection(nTargetX, nTargetY, nDir, 6) = 0) then begin
              Inc(nTargetX, 10 - n02);
              Inc(nTargetY, 10 - n02);
              Result := True;
              break;
            end else begin
              if n02 >= 10 then begin
                nTargetX := m_nCurrX;
                nTargetY := m_nCurrY;
                Inc(nDir);
                Continue;
              end;
              Inc(nTargetX);
              Inc(nTargetY);
              Inc(n02);
              Continue;
            end;
          end; //CheckTargetXYCountOfDirection(m_nCurrX, m_nCurrY, m_btDirection, 1)
        DR_RIGHT: begin
            if m_PEnvir.CanWalkEx(nTargetX, nTargetY, True) and (CheckTargetXYCountOfDirection(nTargetX, nTargetY, nDir, 6) = 0) then begin
              Inc(nTargetX, 10 - n03);
              Result := True;
              break;
            end else begin
              if n03 >= 10 then begin
                nTargetX := m_nCurrX;
                nTargetY := m_nCurrY;
                Inc(nDir);
                Continue;
              end;
              Inc(nTargetX);
              Inc(n03);
              Continue;
            end;
          end;
        DR_DOWNRIGHT: begin
            if m_PEnvir.CanWalkEx(nTargetX, nTargetY, True) and (CheckTargetXYCountOfDirection(nTargetX, nTargetY, nDir, 6) = 0) then begin
              Inc(nTargetX, 10 - n04);
              Dec(nTargetY, 10 - n04);
              Result := True;
              break;
            end else begin
              if n04 >= 10 then begin
                nTargetX := m_nCurrX;
                nTargetY := m_nCurrY;
                Inc(nDir);
                Continue;
              end;
              Inc(nTargetX);
              Dec(nTargetY);
              Inc(n04);
              Continue;
            end;
          end;
        DR_DOWN: begin
            if m_PEnvir.CanWalkEx(nTargetX, nTargetY, True) and (CheckTargetXYCountOfDirection(nTargetX, nTargetY, nDir, 6) = 0) then begin
              Dec(nTargetY, 10 - n05);
              Result := True;
              break;
            end else begin
              if n05 >= 10 then begin
                nTargetX := m_nCurrX;
                nTargetY := m_nCurrY;
                Inc(nDir);
                Continue;
              end;
              Dec(nTargetY);
              Inc(n05);
              Continue;
            end;
          end;
        DR_DOWNLEFT: begin
            if m_PEnvir.CanWalkEx(nTargetX, nTargetY, True) and (CheckTargetXYCountOfDirection(nTargetX, nTargetY, nDir, 6) = 0) then begin
              Dec(nTargetX, 10 - n06);
              Dec(nTargetY, 10 - n06);
              Result := True;
              break;
            end else begin
              if n06 >= 10 then begin
                nTargetX := m_nCurrX;
                nTargetY := m_nCurrY;
                Inc(nDir);
                Continue;
              end;
              Dec(nTargetX);
              Dec(nTargetY);
              Inc(n06);
              Continue;
            end;
          end;
        DR_LEFT: begin
            if m_PEnvir.CanWalkEx(nTargetX, nTargetY, True) and (CheckTargetXYCountOfDirection(nTargetX, nTargetY, nDir, 6) = 0) then begin
              Dec(nTargetX, 10 - n07);
              Result := True;
              break;
            end else begin
              if n07 >= 10 then begin
                nTargetX := m_nCurrX;
                nTargetY := m_nCurrY;
                Inc(nDir);
                Continue;
              end;
              Dec(nTargetX);
              Inc(n07);
              Continue;
            end;
          end;
        DR_UPLEFT: begin
            if m_PEnvir.CanWalkEx(nTargetX, nTargetY, True) and (CheckTargetXYCountOfDirection(nTargetX, nTargetY, nDir, 6) = 0) then begin
              Dec(nTargetX, 10 - n08);
              Inc(nTargetY, 10 - n08);
              Result := True;
              break;
            end else begin
              if n08 >= 10 then begin
                nTargetX := m_nCurrX;
                nTargetY := m_nCurrY;
                Inc(nDir);
                Continue;
              end;
              Dec(nTargetX);
              Inc(nTargetY);
              Inc(n08);
              Continue;
            end;
          end;
      end;
    end;
    if (not boGotoL2) and (not Result) then begin
      boGotoL2 := True;
      goto L002;
    end;
  end;
var
  n10: Integer;
  n14: Integer;
  n20: Integer;
  nOldX: Integer;
  nOldY: Integer;
  n16: Integer;
  nTargetX: Integer;
  nTargetY: Integer;
  nLoopCount: Integer;
begin
  if m_TargetCret <> nil then begin
    n10 := 0;
    if CheckTargetXYCount(m_nCurrX, m_nCurrY, 6) > 0 then begin
      while True do begin
        Inc(n10);
        nTargetX := m_nCurrX;
        nTargetY := m_nCurrY;
        if SearchNextDir(nTargetX, nTargetY) then
          GotoTargetXY(nTargetX, nTargetY);
        if CheckTargetXYCount(m_nCurrX, m_nCurrY, 6) = 0 then break;
        if n10 >= 1 then break;
      end;
    end;
    GotoTargetXYRange();
  end;
  {if m_TargetCret <> nil then begin
    nLoopCount := 1;
    if CheckTargetXYCount(m_nCurrX, m_nCurrY, 6) > 0 then begin
      nTargetX := m_nCurrX;
      nTargetY := m_nCurrY + 8;
      if m_PEnvir.CanWalkEx(nTargetX, nTargetY, True) and (CheckTargetXYCount(nTargetX, nTargetY, 6) = 0) then begin
        n20 := 0;
        while True do begin
          if n20 > nLoopCount then break;
          GotoTargetXY(nTargetX, nTargetY);
          Inc(nTargetY);
          Inc(n20);
        end;
        Exit;
      end;
      nTargetX := m_nCurrX + 10;
      nTargetY := m_nCurrY + 10;
      if m_PEnvir.CanWalkEx(nTargetX, nTargetY, True) and (CheckTargetXYCount(nTargetX, nTargetY, 6) = 0) then begin
        n20 := 0;
        while True do begin
          if n20 > nLoopCount then break;
          GotoTargetXY(nTargetX, nTargetY);
          Inc(nTargetX);
          Inc(nTargetY);
          Inc(n20);
        end;
        Exit;
      end;
      nTargetX := m_nCurrX + 8;
      nTargetY := m_nCurrY;
      if m_PEnvir.CanWalkEx(nTargetX, nTargetY, True) and (CheckTargetXYCount(nTargetX, nTargetY, 6) = 0) then begin
        n20 := 0;
        while True do begin
          if n20 > nLoopCount then break;
          GotoTargetXY(nTargetX, nTargetY);
          Inc(nTargetX);
          Inc(n20);
        end;
        Exit;
      end;
      nTargetX := m_nCurrX + 10;
      nTargetY := m_nCurrY + 10;
      if m_PEnvir.CanWalkEx(nTargetX, nTargetY, True) and (CheckTargetXYCount(nTargetX, nTargetY, 6) = 0) then begin
        n20 := 0;
        while True do begin
          if n20 > nLoopCount then break;
          GotoTargetXY(nTargetX, nTargetY);
          Inc(nTargetX);
          Inc(nTargetY);
          Inc(n20);
        end;
        Exit;
      end;
      nTargetX := m_nCurrX;
      nTargetY := m_nCurrY - 8;
      if m_PEnvir.CanWalkEx(nTargetX, nTargetY, True) and (CheckTargetXYCount(nTargetX, nTargetY, 6) = 0) then begin
        n20 := 0;
        while True do begin
          if n20 > nLoopCount then break;
          GotoTargetXY(nTargetX, nTargetY);
          Dec(nTargetY);
          Inc(n20);
        end;
        Exit;
      end;
      nTargetX := m_nCurrX - 10;
      nTargetY := m_nCurrY - 10;
      if m_PEnvir.CanWalkEx(nTargetX, nTargetY, True) and (CheckTargetXYCount(nTargetX, nTargetY, 6) = 0) then begin
        n20 := 0;
        while True do begin
          if n20 > nLoopCount then break;
          GotoTargetXY(nTargetX, nTargetY);
          Dec(nTargetX);
          Dec(nTargetY);
          Inc(n20);
        end;
        Exit;
      end;
      nTargetX := m_nCurrX - 8;
      nTargetY := m_nCurrY;
      if m_PEnvir.CanWalkEx(nTargetX, nTargetY, True) and (CheckTargetXYCount(nTargetX, nTargetY, 6) = 0) then begin
        n20 := 0;
        while True do begin
          if n20 > nLoopCount then break;
          GotoTargetXY(nTargetX, nTargetY);
          Dec(nTargetX);
          Inc(n20);
        end;
        Exit;
      end;
      nTargetX := m_nCurrX - 10;
      nTargetY := m_nCurrY + 10;
      if m_PEnvir.CanWalkEx(nTargetX, nTargetY, True) and (CheckTargetXYCount(nTargetX, nTargetY, 6) = 0) then begin
        n20 := 0;
        while True do begin
          if n20 > nLoopCount then break;
          GotoTargetXY(nTargetX, nTargetY);
          Dec(nTargetX);
          Inc(nTargetY);
          Inc(n20);
        end;
        Exit;
      end;
      if m_Master <> nil then begin
        nTargetX := m_Master.m_nCurrX;
        nTargetY := m_Master.m_nCurrY;
        GotoTargetXY(nTargetX, nTargetY);
      end else begin
        GetTargetCretXY(nTargetX, nTargetY);
        GotoTargetXY(nTargetX, nTargetY);
      end;
    end;
  end;}
end;

procedure TPlayMonster.SearchPickUpItem(dwSearchTime: LongWord);
  function PickUpItem(VisibleMapItem: pTVisibleMapItem): Boolean;
  var
    UserItem: pTUserItem;
    StdItem: pTStdItem;
    MapItem: PTMapItem;
    nDeleteCode: Integer;
  begin
    Result := False;
    MapItem := m_PEnvir.GetItem(VisibleMapItem.nX, VisibleMapItem.nY {m_nCurrX, m_nCurrY});
    if MapItem = nil then Exit;
    if CompareText(VisibleMapItem.sName, sSTRING_GOLDNAME) = 0 then begin
      if m_PEnvir.DeleteFromMap(VisibleMapItem.nX, VisibleMapItem.nY {m_nCurrX, m_nCurrY}, OS_ITEMOBJECT, TObject(MapItem)) = 1 then begin
        if (m_Master <> nil) and (not m_Master.m_boDeath) then begin //捡到的钱加给主人
          if TPlayObject(m_Master).IncGold(MapItem.Count) then begin
            SendRefMsg(RM_ITEMHIDE, 0, Integer(MapItem), VisibleMapItem.nX, VisibleMapItem.nY {m_nCurrX, m_nCurrY}, '');
            if g_boGameLogGold then
              AddGameDataLog('4' + #9 +
                m_sMapName + #9 +
                IntToStr(VisibleMapItem.nX {m_nCurrX}) + #9 +
                IntToStr(VisibleMapItem.nY {m_nCurrY}) + #9 +
                m_sCharName + #9 +
                sSTRING_GOLDNAME + #9 +
                IntToStr(MapItem.Count) + #9 +
                '1' + #9 +
                '0');
            Result := True;
            m_Master.GoldChanged;
            DisPoseAndNil(MapItem);
          end else begin
            m_PEnvir.AddToMap(VisibleMapItem.nX, VisibleMapItem.nY {m_nCurrX, m_nCurrY}, OS_ITEMOBJECT, TObject(MapItem));
          end;
        end;
      end;
      Exit;
    end else begin //捡物品
      if (m_Master <> nil) and (not m_Master.m_boDeath) then begin //捡到的物品加给主人
        if m_ItemList.Count < g_Config.nCopyHumanBagCount then begin //捡到药品先给自己
          StdItem := UserEngine.GetStdItem(MapItem.UserItem.wIndex);
          if (StdItem <> nil) and IsPickUpItem(StdItem) then begin
            if m_PEnvir.DeleteFromMap(VisibleMapItem.nX, VisibleMapItem.nY {m_nCurrX, m_nCurrY}, OS_ITEMOBJECT, TObject(MapItem)) = 1 then begin
              New(UserItem);
              UserItem^ := MapItem.UserItem;
              StdItem := UserEngine.GetStdItem(UserItem.wIndex);
              if (StdItem <> nil) and IsAddWeightAvailable(UserEngine.GetStdItemWeight(UserItem.wIndex)) then begin
                SendRefMsg(RM_ITEMHIDE, 0, Integer(MapItem), VisibleMapItem.nX, VisibleMapItem.nY {m_nCurrX, m_nCurrY}, '');
                m_ItemList.Add(UserItem);
                //m_WAbil.Weight := RecalcBagWeight();
                if not IsCheapStuff(StdItem.StdMode) then
                  if StdItem.NeedIdentify = 1 then
                    AddGameDataLog('4' + #9 +
                      m_sMapName + #9 +
                      IntToStr(VisibleMapItem.nX {m_nCurrX}) + #9 +
                      IntToStr(VisibleMapItem.nY {m_nCurrY}) + #9 +
                      m_sCharName + #9 +
                      //UserEngine.GetStdItemName(pu.wIndex) + #9 +
                      StdItem.Name + #9 +
                      IntToStr(UserItem.MakeIndex) + #9 +
                      '1' + #9 +
                      '0');
                Result := True;
                DisPoseAndNil(MapItem);
              end;
            end else begin
              DisPoseAndNil(UserItem);
              m_PEnvir.AddToMap(VisibleMapItem.nX, VisibleMapItem.nY {m_nCurrX, m_nCurrY}, OS_ITEMOBJECT, TObject(MapItem));
            end;
            Exit;
          end;
        end;
        if TPlayObject(m_Master).IsEnoughBag and m_boCanPickUpItem then begin
          if m_PEnvir.DeleteFromMap(VisibleMapItem.nX, VisibleMapItem.nY {m_nCurrX, m_nCurrY}, OS_ITEMOBJECT, TObject(MapItem)) = 1 then begin
            New(UserItem);
            UserItem^ := MapItem.UserItem;
            StdItem := UserEngine.GetStdItem(UserItem.wIndex);
            if (StdItem <> nil) and TPlayObject(m_Master).IsAddWeightAvailable(UserEngine.GetStdItemWeight(UserItem.wIndex)) then begin
              SendRefMsg(RM_ITEMHIDE, 0, Integer(MapItem), VisibleMapItem.nX, VisibleMapItem.nY {m_nCurrX, m_nCurrY}, '');
              TPlayObject(m_Master).AddItemToBag(UserItem);
              if not IsCheapStuff(StdItem.StdMode) then
                if StdItem.NeedIdentify = 1 then
                  AddGameDataLog('4' + #9 +
                    m_sMapName + #9 +
                    IntToStr(VisibleMapItem.nX {m_nCurrX}) + #9 +
                    IntToStr(VisibleMapItem.nY {m_nCurrY}) + #9 +
                    m_sCharName + ' - ' + m_Master.m_sCharName + #9 +
                    //UserEngine.GetStdItemName(pu.wIndex) + #9 +
                    StdItem.Name + #9 +
                    IntToStr(UserItem.MakeIndex) + #9 +
                    '1' + #9 +
                    '0');
              Result := True;
              DisPoseAndNil(MapItem);
              if not m_Master.m_boDeath then begin
                if TPlayObject(m_Master).m_btRaceServer = RC_PLAYOBJECT then begin
                  TPlayObject(m_Master).SendAddItem(UserItem);
                end;
              end;
            end else begin
              DisPoseAndNil(UserItem);
              m_PEnvir.AddToMap(VisibleMapItem.nX, VisibleMapItem.nY {m_nCurrX, m_nCurrY}, OS_ITEMOBJECT, TObject(MapItem));
            end;
          end;
        end;
      end;
    end;
  end;

  function IsOfGroup(BaseObject: TBaseObject): Boolean;
  var
    i: Integer;
    GroupMember: TBaseObject;
  begin
    Result := False;
    if m_Master.m_GroupOwner = nil then Exit;
    for i := 0 to m_Master.m_GroupOwner.m_GroupMembers.Count - 1 do begin
      GroupMember := TBaseObject(m_Master.m_GroupOwner.m_GroupMembers.Objects[i]);
      if GroupMember = BaseObject then begin
        Result := True;
        break;
      end;
    end;
  end;
var
  MapItem: PTMapItem;
  VisibleMapItem: pTVisibleMapItem;
  i: Integer;
  nCheckCode: Integer;
  boFound: Boolean;
  sName: string;
resourcestring
  sExceptionMsg2 = '[Exception] TPlayMonster::SearchItemRange 1-%d %s %s %d %d %d';
begin
  {开始拣物品}
  //MainOutMessage('开始捡物品');
  if GetTickCount - m_dwPickUpItemTick > dwSearchTime then begin
    m_dwPickUpItemTick := GetTickCount;
    for i := 0 to m_VisibleItems.Count - 1 do begin
      VisibleMapItem := pTVisibleMapItem(m_VisibleItems.Items[i]);
      if (VisibleMapItem <> nil) and (VisibleMapItem.nVisibleFlag > 0) then begin
        MapItem := VisibleMapItem.MapItem;
        if (MapItem <> nil) and (MapItem.DropBaseObject <> m_Master) then begin
          if IsAllowPickUpItem(VisibleMapItem.sName) then begin
            //if (MapItem.DropBaseObject <> nil) and (TBaseObject(MapItem.DropBaseObject).m_btRaceServer = RC_PLAYOBJECT) then Continue;
            if (MapItem.OfBaseObject = nil) or (MapItem.OfBaseObject = m_Master) or (MapItem.OfBaseObject = Self) {or IsOfGroup(TBaseObject(MapItem.OfBaseObject))} then begin
              //GotoTargetXY(VisibleMapItem.nX, VisibleMapItem.nY);
              if PickUpItem(VisibleMapItem) then begin
                //MainOutMessage('捡到物品');
                break;
              end;
            end;
          end;
        end;
      end;
    end;
  end;
end;

function TPlayMonster.IsPickUpItem(StdItem: pTStdItem): Boolean;
begin
  Result := False;
  if StdItem.StdMode = 0 then begin
    if (StdItem.Shape in [0, 1, 2]) then Result := True;
  end else
    if StdItem.StdMode = 31 then begin
    if GetBindItemType(StdItem.Shape) >= 0 then Result := True;
  end else begin
    Result := False;
  end;
end;

function TPlayMonster.EatUseItems(btItemType: Byte): Boolean; {自动吃药}
  function EatItems(StdItem: pTStdItem): Boolean;
  var
    bo06: Boolean;
    nOldStatus: Integer;
  begin
    Result := False;
    if m_PEnvir.m_boNODRUG then begin
      Exit;
    end;
    case StdItem.StdMode of
      0: begin
          case StdItem.Shape of {红药}
            0: begin
                if (StdItem.AC > 0) then begin
                  Inc(m_nIncHealth, StdItem.AC);
                  Result := True;
                end;
                if (StdItem.MAC > 0) then begin {蓝药}
                  Inc(m_nIncSpell, StdItem.MAC);
                  Result := True;
                end;
              end;
            1: begin
                if (StdItem.AC > 0) and (StdItem.MAC > 0) then begin
                  IncHealthSpell(StdItem.AC, StdItem.MAC);
                  Result := True;
                end;
              end;
          end;
        end;
    end;
  end;

  function GetUnbindItemName(nShape: Integer): string;
  var
    i: Integer;
  begin
    Result := '';
    for i := 0 to g_UnbindList.Count - 1 do begin
      if Integer(g_UnbindList.Objects[i]) = nShape then begin
        Result := g_UnbindList.Strings[i];
        break;
      end;
    end;
  end;

  function GetUnBindItems(sItemName: string; nCount: Integer): Boolean;
  var
    i: Integer;
    UserItem: pTUserItem;
  begin
    Result := False;
    for i := 0 to nCount - 1 do begin
      New(UserItem);
      if UserEngine.CopyToUserItemFromName(sItemName, UserItem) then begin
        m_ItemList.Add(UserItem);
        Result := True;
      end else begin
        DisPose(UserItem);
        break;
      end;
    end;
  end;

  function FoundUserItem(nItemIdx: Integer): Boolean;
  var
    i: Integer;
    UserItem: pTUserItem;
  begin
    Result := False;
    for i := 0 to m_ItemList.Count - 1 do begin
      UserItem := m_ItemList.Items[i];
      if UserItem = nil then Continue;
      if (UserItem <> nil) and (UserItem.MakeIndex = nItemIdx) then begin
        Result := True;
        break;
      end;
    end;
  end;

  function FoundAddHealthItem(ItemType: Byte): Integer;
  var
    i: Integer;
    UserItem: pTUserItem;
    StdItem: pTStdItem;
  begin
    Result := -1;
    for i := 0 to m_ItemList.Count - 1 do begin
      UserItem := m_ItemList.Items[i];
      if UserItem <> nil then begin
        StdItem := UserEngine.GetStdItem(UserItem.wIndex);
        if StdItem <> nil then begin
          case ItemType of
            0: begin //红药
                if (StdItem.StdMode = 0) and (StdItem.Shape = 0) and (StdItem.AC > 0) then begin
                  Result := i;
                  break;
                end;
              end;
            1: begin //蓝药
                if (StdItem.StdMode = 0) and (StdItem.Shape = 0) and (StdItem.MAC > 0) then begin
                  Result := i;
                  break;
                end;
              end;
            2: begin //太阳水
                if (StdItem.StdMode = 0) and (StdItem.Shape = 1) and (StdItem.AC > 0) and (StdItem.MAC > 0) then begin
                  Result := i;
                  break;
                end;
              end;
            3: begin //红药包
                if (StdItem.StdMode = 31) and (GetBindItemType(StdItem.Shape) = 0) then begin
                  Result := i;
                  break;
                end;
              end;
            4: begin //蓝药包
                if (StdItem.StdMode = 31) and (GetBindItemType(StdItem.Shape) = 1) then begin
                  Result := i;
                  break;
                end;
              end;
          end;
        end;
      end;
    end;
  end;

  function UseAddHealthItem(nItemIdx: Integer): Boolean;
  var
    UserItem: pTUserItem;
    StdItem: pTStdItem;
  begin
    Result := False;
    UserItem := m_ItemList.Items[nItemIdx];
    if UserItem <> nil then begin
      StdItem := UserEngine.GetStdItem(UserItem.wIndex);
      if StdItem <> nil then begin
        if not m_PEnvir.AllowStdItems(UserItem.wIndex) then begin
          Exit;
        end;
        case StdItem.StdMode of
          0 {, 1, 2, 3}: begin //药
              if EatItems(StdItem) then begin
                if UserItem <> nil then DisPose(UserItem);
                m_ItemList.Delete(nItemIdx);
                //m_WAbil.Weight := RecalcBagWeight();
                Result := True;
              end;
            end;
          31: begin //解包物品
              //MainOutMessage('解包物品 ' + IntToStr(GetBindItemType(StdItem.Shape)));
              if (StdItem.AniCount = 0) and (GetBindItemType(StdItem.Shape) >= 0) then begin
                //if (m_ItemList.Count + 6 - 1) <= MAXBAGITEM then begin
                DisPose(UserItem);
                m_ItemList.Delete(nItemIdx);
                GetUnBindItems(GetUnbindItemName(StdItem.Shape), 6);
                Result := True;
              end;
            end;
        end;
      end;
    end;
  end;

var
  nItemIdx: Integer;
  boEatOK: Boolean;
  UserItem: pTUserItem;
  StdItem: pTStdItem;
  UserItem34: TUserItem;
begin
  boEatOK := False;
  StdItem := nil;
  if not m_boDeath then begin
    nItemIdx := FoundAddHealthItem(btItemType);
    if (nItemIdx >= 0) and (nItemIdx < m_ItemList.Count) then begin
      Result := UseAddHealthItem(nItemIdx);
    end else begin
      case btItemType of //查找解包物品
        0: begin
            nItemIdx := FoundAddHealthItem(3);
            if (nItemIdx >= 0) and (nItemIdx < m_ItemList.Count) then begin
              Result := UseAddHealthItem(nItemIdx);
            end else begin
              nItemIdx := FoundAddHealthItem(2);
              if (nItemIdx >= 0) and (nItemIdx < m_ItemList.Count) then begin
                Result := UseAddHealthItem(nItemIdx);
              end;
            end;
          end;
        1: begin
            nItemIdx := FoundAddHealthItem(4);
            if (nItemIdx >= 0) and (nItemIdx < m_ItemList.Count) then begin
              Result := UseAddHealthItem(nItemIdx);
            end else begin
              nItemIdx := FoundAddHealthItem(2);
              if (nItemIdx >= 0) and (nItemIdx < m_ItemList.Count) then begin
                Result := UseAddHealthItem(nItemIdx);
              end;
            end;
          end;
      end;
    end;
  end;
end;

function TPlayMonster.AllowGotoTargetXY(): Boolean;
begin
  Result := True;
  if (m_btJob = 0) or (not m_boDoSpellMagic) or (m_TargetCret = nil) then Exit;
  Result := False;
end;

function TPlayMonster.AllowFireHitSkill(): Boolean;
begin
  Result := False;
  if (GetTickCount - m_dwLatestFireHitTick) > 10 * 1000 then begin
    m_dwLatestFireHitTick := GetTickCount();
    m_boFireHitSkill := True;
    Result := True;
  end;
end;

function TPlayMonster.StartAutoAvoid(): Boolean;
begin
  Result := False;
  if (m_btJob > 0) and ((GetTickCount - m_dwAutoAvoidTick) > 1 * 1000) and (m_TargetCret <> nil) and (not m_TargetCret.m_boDeath) then begin
    m_dwAutoAvoidTick := GetTickCount();
    Result := True;
  end;
end;

function TPlayMonster.GetSpellPoint(UserMagic: pTUserMagic): Integer;
begin
  Result := ROUND(UserMagic.MagicInfo.wSpell / (UserMagic.MagicInfo.btTrainLv + 1) * (UserMagic.btLevel + 1)) + UserMagic.MagicInfo.btDefSpell;
end;

function TPlayMonster.DoSpellMagic(wMagIdx: Word): Boolean; //使用魔法
  function DoSpell(UserMagic: pTUserMagic; nTargetX, nTargetY: Integer; TargeTBaseObject: TBaseObject): Boolean;
  var
    nSpellPoint: Integer;
    boSpellFail: Boolean;
    boSpellFire: Boolean;
    n10: Integer;
    n14: Integer;
    n18: Integer;
    n1C: Integer;
    nDir: Integer;
    nPower: Integer;
    WAbil: pTAbility;
    nAmuletIdx: Integer;
    function MPow(UserMagic: pTUserMagic): Integer;
    begin
      Result := UserMagic.MagicInfo.wPower + Random(UserMagic.MagicInfo.wMaxPower - UserMagic.MagicInfo.wPower);
    end;
    function GetPower(nPower: Integer): Integer;
    begin
      Result := ROUND(nPower / (UserMagic.MagicInfo.btTrainLv + 1) * (UserMagic.btLevel + 1)) + (UserMagic.MagicInfo.btDefPower + Random(UserMagic.MagicInfo.btDefMaxPower - UserMagic.MagicInfo.btDefPower));
    end;
    function GetPower13(nInt: Integer): Integer;
    var
      d10: Double;
      d18: Double;
    begin
      d10 := nInt / 3.0;
      d18 := nInt - d10;
      Result := ROUND(d18 / (UserMagic.MagicInfo.btTrainLv + 1) * (UserMagic.btLevel + 1) + d10 + (UserMagic.MagicInfo.btDefPower + Random(UserMagic.MagicInfo.btDefMaxPower - UserMagic.MagicInfo.btDefPower)));
    end;
    procedure DelUseItem();
    begin
      if m_UseItems[U_BUJUK].Dura < 100 then begin
        m_UseItems[U_BUJUK].Dura := 0;
        m_UseItems[U_BUJUK].wIndex := 0;
      end;
    end;
  begin
    Result := False;
    boSpellFail := False;
    boSpellFire := True;
    nPower := 0;
    if (abs(m_nCurrX - nTargetX) > g_Config.nMagicAttackRage) or (abs(m_nCurrY - nTargetY) > g_Config.nMagicAttackRage) then begin
      Exit;
    end;
    SendRefMsg(RM_SPELL, UserMagic.MagicInfo.btEffect, nTargetX, nTargetY, UserMagic.MagicInfo.wMagicId, '');
    if (TargeTBaseObject <> nil) and (TargeTBaseObject.m_boDeath) then TargeTBaseObject := nil;
    case wMagIdx of
      SKILL_LIGHTENING {11}: begin {雷电术}
          nSpellPoint := GetSpellPoint(UserMagic);
          if nSpellPoint > 0 then begin
            if m_WAbil.MP < nSpellPoint then Exit;
            DamageSpell(nSpellPoint);
            //HealthSpellChanged();
          end;
          if m_TargetCret <> nil then begin
            if IsProperTarget(TargeTBaseObject) then begin
              if (Random(10) >= TargeTBaseObject.m_nAntiMagic) then begin
                nPower := GetAttackPower(GetPower(MPow(UserMagic)) + LoWord(m_WAbil.MC),
                  SmallInt(HiWord(m_WAbil.MC) - LoWord(m_WAbil.MC)) + 1);
                if TargeTBaseObject.m_btLifeAttrib = LA_UNDEAD then
                  nPower := ROUND(nPower * 1.5);
                SendDelayMsg(Self, RM_DELAYMAGIC, nPower, MakeLong(nTargetX, nTargetY), 2, Integer(TargeTBaseObject), '', 600);
                Result := True
              end else TargeTBaseObject := nil
            end else TargeTBaseObject := nil;
          end;
        end;
      SKILL_SHIELD {31}: begin //魔法盾
          if MagBubbleDefenceUp(UserMagic.btLevel, GetPower(GetRPow(m_WAbil.MC) + 15)) then Result := True;
        end;
      SKILL_SNOWWIND {33}: begin // 冰咆哮
          if MagicManager.MagBigExplosion(Self,
            GetAttackPower(GetPower(MPow(UserMagic)) + LoWord(m_WAbil.MC), SmallInt(HiWord(m_WAbil.MC) - LoWord(m_WAbil.MC)) + 1),
            nTargetX,
            nTargetY,
            g_Config.nSnowWindRange) then
            Result := True;
        end;
      SKILL_LIGHTFLOWER {24}: begin //地狱雷光
          if MagicManager.MagElecBlizzard(Self, GetAttackPower(GetPower(MPow(UserMagic)) + LoWord(m_WAbil.MC), SmallInt(HiWord(m_WAbil.MC) - LoWord(m_WAbil.MC)) + 1)) then
            Result := True;
        end;
      SKILL_47: begin //火龙气焰
          if MagicManager.MagBigExplosion(Self,
            GetAttackPower(GetPower(MPow(UserMagic)) + LoWord(m_WAbil.MC), SmallInt(HiWord(m_WAbil.MC) - LoWord(m_WAbil.MC)) + 1),
            nTargetX,
            nTargetY,
            g_Config.nFireBoomRage {1}) then
            Result := True;
        end;
      {道士}
      SKILL_AMYOUNSUL {6}: begin //施毒术
          if MagicManager.MagLightening(Self, UserMagic, nTargetX, nTargetY, TargeTBaseObject, boSpellFail) then
            Result := True;
        end;
      SKILL_FIRECHARM {13},
      SKILL_HANGMAJINBUB {14},
      SKILL_DEJIWONHO {15}: begin
          boSpellFail := True;
          if CheckAmulet(Self, 1, 1, nAmuletIdx) then begin
            UseAmulet(Self, 1, 1, nAmuletIdx);
            case wMagIdx of
              SKILL_FIRECHARM {13}: begin //灵魂火符
                  if MagicManager.MagMakeFireCharm(Self,
                    UserMagic,
                    nTargetX,
                    nTargetY,
                    TargeTBaseObject) then Result := True;
                end;
              SKILL_HANGMAJINBUB {14}: begin //幽灵盾
                  nPower := GetAttackPower(GetPower13(60) + LoWord(m_WAbil.SC) * 10, SmallInt(HiWord(m_WAbil.SC) - LoWord(m_WAbil.SC)) + 1);
                  if MagMakeDefenceArea(nTargetX, nTargetY, 3, nPower, 1, True) > 0 then
                    Result := True;
                end;
              SKILL_DEJIWONHO {15}: begin //神圣战甲术
                  nPower := GetAttackPower(GetPower13(60) + LoWord(m_WAbil.SC) * 10, SmallInt(HiWord(m_WAbil.SC) - LoWord(m_WAbil.SC)) + 1);
                  if MagMakeDefenceArea(nTargetX, nTargetY, 3, nPower, 0, True) > 0 then
                    Result := True;
                end;
            end;
            boSpellFail := False;
            DelUseItem();
          end;
        end;
      SKILL_GROUPAMYOUNSUL {38 群体施毒术}: begin
          boSpellFail := True;
          if CheckAmulet(Self, 1, 2, nAmuletIdx) then begin
            UseAmulet(Self, 1, 2, nAmuletIdx);
            if MagicManager.MagGroupAmyounsul(Self, UserMagic, nTargetX, nTargetY, TargeTBaseObject) then
              Result := True;
            boSpellFail := False;
            DelUseItem();
          end;
        end;
      SKILL_BIGHEALLING {29}: begin //群体治疗术
          nPower := GetAttackPower(GetPower(MPow(UserMagic)) + LoWord(m_WAbil.SC) * 2,
            SmallInt(HiWord(m_WAbil.SC) - LoWord(m_WAbil.SC)) * 2 + 1);
          if MagicManager.MagBigHealing(Self, nPower, nTargetX, nTargetY) then Result := True;
        end;
    end;
    if boSpellFire then begin
      SendRefMsg(RM_MAGICFIRE, 0,
        MakeWord(UserMagic.MagicInfo.btEffectType, UserMagic.MagicInfo.btEffect),
        MakeLong(nTargetX, nTargetY),
        Integer(TargeTBaseObject),
        '');
    end;
  end;
var
  BaseObject: TBaseObject;
  i: Integer;
  nSpellPoint: Integer;
  UserMagic: pTUserMagic;
  nNewTargetX: Integer;
  nNewTargetY: Integer;
begin
  Result := False;
  case wMagIdx of
    SKILL_ERGUM {12}: begin //刺杀剑法
        if m_MagicErgumSkill <> nil then begin
          if not m_boUseThrusting then begin
            m_boUseThrusting := True;
          end else begin
            m_boUseThrusting := False;
          end;
        end;
        Result := True;
      end;
    SKILL_BANWOL {25}: begin //半月弯刀
        if m_MagicBanwolSkill <> nil then begin
          if not m_boUseHalfMoon then begin
            m_boUseHalfMoon := True;
          end else begin
            m_boUseHalfMoon := False;
          end;
        end;
        Result := True;
        Exit;
      end;
    SKILL_FIRESWORD {26}: begin //烈火剑法
        if m_MagicFireSwordSkill <> nil then begin
          if AllowFireHitSkill then begin
            nSpellPoint := GetSpellPoint(m_MagicFireSwordSkill);
            if m_WAbil.MP >= nSpellPoint then begin
              if nSpellPoint > 0 then begin
                DamageSpell(nSpellPoint);
                //HealthSpellChanged();
              end;
            end;
          end;
        end;
        Result := True;
        Exit;
      end;
    else begin {使用魔法}
        for i := 0 to m_MagicList.Count - 1 do begin
          UserMagic := m_MagicList.Items[i];
          if (UserMagic <> nil) and (UserMagic.wMagIdx = wMagIdx) then begin
            m_btDirection := GetNextDirection(m_nCurrX, m_nCurrY, m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY);
            BaseObject := nil;
            nNewTargetX := m_TargetCret.m_nCurrX;
            nNewTargetY := m_TargetCret.m_nCurrY;
            //检查目标角色，与目标座标误差范围，如果在误差范围内则修正目标座标
            if CretInNearXY(m_TargetCret, nNewTargetX, nNewTargetY) then begin
              BaseObject := m_TargetCret;
              nNewTargetX := BaseObject.m_nCurrX;
              nNewTargetY := BaseObject.m_nCurrY;
            end;
            (*if wMagIdx = SKILL_DEJIWONHO then begin {如果是 神圣战甲术 目标为自己}
              BaseObject := Self;
              nNewTargetX := m_nCurrX;
              nNewTargetY := m_nCurrY;
            end;*)
            Result := DoSpell(UserMagic, nNewTargetX, nNewTargetY, BaseObject);
            break;
          end;
        end;
      end;
  end;
end;

function TPlayMonster.WarrAttackTarget(wHitMode: Word): Boolean; {物理攻击}
var
  bt06: Byte;
begin
  Result := False;
  if m_TargetCret <> nil then begin
    if GetAttackDir(m_TargetCret, bt06) then begin
      m_dwTargetFocusTick := GetTickCount();
      Attack(m_TargetCret, bt06);
      BreakHolySeizeMode();
      Result := True;
    end else begin
      if m_TargetCret.m_PEnvir = m_PEnvir then begin
        SetTargetXY(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY);
      end else begin
        DelTargetCreat();
      end;
    end;
  end;
end;

procedure TPlayMonster.EatMedicine(); {吃药}
var
  n01: Integer;
begin
  if (m_nCopyHumanLevel > 0) and (m_ItemList.Count > 0) then begin
    if m_WAbil.HP < (m_WAbil.MaxHP * g_Config.nCopyHumAddHPRate) div 100 then begin
      n01 := 0;
      while m_WAbil.HP < m_WAbil.MaxHP do begin {增加连续吃三瓶}
        if n01 > 3 then break;
        EatUseItems(0);
        if m_ItemList.Count = 0 then break;
        Inc(n01);
      end;
    end;
    if m_WAbil.MP < (m_WAbil.MaxMP * g_Config.nCopyHumAddMPRate) div 100 then begin
      n01 := 0;
      while m_WAbil.MP < m_WAbil.MaxMP do begin {增加连续吃三瓶}
        if n01 > 3 then break;
        EatUseItems(1);
        if m_ItemList.Count = 0 then break;
        Inc(n01);
      end;
    end;
    if (m_ItemList.Count = 0) or (m_WAbil.HP < (m_WAbil.MaxHP * 20) div 100) or (m_WAbil.MP < (m_WAbil.MaxMP * 20) div 100) then begin
      if m_VisibleItems.Count > 0 then begin
        m_boPickUpItemOK := False;
        SearchPickUpItem(500);
      end;
    end
  end;
end;

{检测指定方向和范围内坐标的怪物数量}
function TPlayMonster.CheckTargetXYCountOfDirection(nX, nY, nDir, nRange: Integer): Integer;
var
  BaseObject: TBaseObject;
  i, nC, n10: Integer;
begin
  Result := 0;
  n10 := 2;
  for i := 0 to m_VisibleActors.Count - 1 do begin
    BaseObject := TBaseObject(pTVisibleBaseObject(m_VisibleActors.Items[i]).BaseObject);
    if BaseObject <> nil then begin
      if not BaseObject.m_boDeath then begin
        if IsProperTarget(BaseObject) and
          (not BaseObject.m_boHideMode or m_boCoolEye) then begin
          case nDir of
            DR_UP: begin
                if (abs(nX - BaseObject.m_nCurrX) <= nRange) and ((BaseObject.m_nCurrY - nY) in [0, nRange]) then Inc(Result);
              end;
            DR_UPRIGHT: begin
                if ((BaseObject.m_nCurrX - nX) in [0, nRange]) and ((BaseObject.m_nCurrY - nY) in [0, nRange]) then Inc(Result);
              end;
            DR_RIGHT: begin
                if ((BaseObject.m_nCurrX - nX) in [0, nRange]) and (abs(nY - BaseObject.m_nCurrY) <= nRange) then Inc(Result);
              end;
            DR_DOWNRIGHT: begin
                if ((BaseObject.m_nCurrX - nX) in [0, nRange]) and ((nY - BaseObject.m_nCurrY) in [0, nRange]) then Inc(Result);
              end;
            DR_DOWN: begin
                if (abs(nX - BaseObject.m_nCurrX) <= nRange) and ((nY - BaseObject.m_nCurrY) in [0, nRange]) then Inc(Result);
              end;
            DR_DOWNLEFT: begin
                if ((nX - BaseObject.m_nCurrX) in [0, nRange]) and ((nY - BaseObject.m_nCurrY) in [0, nRange]) then Inc(Result);
              end;
            DR_LEFT: begin
                if ((nX - BaseObject.m_nCurrX) in [0, nRange]) and (abs(nY - BaseObject.m_nCurrY) <= nRange) then Inc(Result);
              end;
            DR_UPLEFT: begin
                if ((nX - BaseObject.m_nCurrX) in [0, nRange]) and ((BaseObject.m_nCurrY - nY) in [0, nRange]) then Inc(Result);
              end;
          end;
          if Result > 2 then break;
        end;
      end;
    end;
  end;
end;

function TPlayMonster.WarrorAttackTarget(): Boolean; {战士攻击}
var
  wHitMode: Word;
begin
  Result := False;
  m_wHitMode := 0;
  if m_WAbil.MP > 0 then begin
    if wSkill_13 > 0 then begin
      if CheckTargetXYCountOfDirection(m_nCurrX, m_nCurrY, m_btDirection, 1) >= 2 then begin
        if not m_boUseHalfMoon then DoSpellMagic(SKILL_BANWOL {25}); //打开半月
        if (wSkill_12 > 0) and (m_boUseThrusting) then DoSpellMagic(SKILL_ERGUM); //关闭刺杀
      end else begin
        if m_boUseHalfMoon then DoSpellMagic(SKILL_BANWOL {25}); //关闭半月
        if (wSkill_12 > 0) and (not m_boUseThrusting) then DoSpellMagic(SKILL_ERGUM); //打开刺杀
      end;
    end else begin
      if (wSkill_12 > 0) and (not m_boUseThrusting) then DoSpellMagic(SKILL_ERGUM); //打开刺杀
    end;
    if wSkill_11 > 0 then DoSpellMagic(SKILL_FIRESWORD {26}); //使用烈火
    if m_boUseThrusting then m_wHitMode := 4; //使用刺杀
    if m_boUseHalfMoon then m_wHitMode := 5; //使用半月
    if m_boFireHitSkill then m_wHitMode := 7; //使用烈火
  end;
  Result := WarrAttackTarget(m_wHitMode);
end;

function TPlayMonster.CheckUserMagic(wMagIdx: Word): Integer;
var
  UserMagic: pTUserMagic;
  i: Integer;
begin
  Result := 0;
  for i := 0 to m_MagicList.Count - 1 do begin
    UserMagic := m_MagicList.Items[i];
    if UserMagic.MagicInfo.wMagicId = wMagIdx then begin
      Result := wMagIdx;
      break;
    end;
  end;
end;

function TPlayMonster.CheckTargetXYCount(nX, nY, nRange: Integer): Integer;
var
  BaseObject: TBaseObject;
  i, nC, n10: Integer;
begin
  Result := 0;
  n10 := nRange;
  for i := 0 to m_VisibleActors.Count - 1 do begin
    BaseObject := TBaseObject(pTVisibleBaseObject(m_VisibleActors.Items[i]).BaseObject);
    if BaseObject <> nil then begin
      if not BaseObject.m_boDeath then begin
        if IsProperTarget(BaseObject) and
          (not BaseObject.m_boHideMode or m_boCoolEye) then begin
          nC := abs(nX - BaseObject.m_nCurrX) + abs(nY - BaseObject.m_nCurrY);
          if nC <= n10 then begin
            Inc(Result);
            if Result > 2 then break;
          end;
        end;
      end;
    end;
  end;
end;

function TPlayMonster.WizardAttackTarget(): Boolean; {法师攻击}
  function SearchDoSpell: Integer;
  begin
    Result := 0;
    if (wSkill_05 > 0) and (m_wStatusTimeArr[STATE_BUBBLEDEFENCEUP {0x76}] = 0) then begin {使用 魔法盾}
      Result := wSkill_05;
      Exit;
    end;
    if CheckTargetXYCount(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, 3) > 1 then begin
      if (abs(m_TargetCret.m_nCurrX - m_nCurrX) <= 1) and (abs(m_TargetCret.m_nCurrY - m_nCurrY) <= 1) then begin
        if wSkill_02 > 0 then Result := wSkill_02
        else if wSkill_03 > 0 then Result := wSkill_03
        else if wSkill_04 > 0 then Result := wSkill_04
        else if wSkill_01 > 0 then Result := wSkill_01;
        Exit;
      end else begin
        if (wSkill_03 > 0) and (wSkill_04 > 0) then begin
          if Random(8) > 3 then begin
            Result := wSkill_03;
          end else begin
            Result := wSkill_04;
          end;
          Exit;
        end else begin
          if wSkill_03 > 0 then Result := wSkill_03
          else if wSkill_04 > 0 then Result := wSkill_04
          else if wSkill_01 > 0 then Result := wSkill_01;
          Exit;
        end;
      end;
    end else begin
      if wSkill_01 > 0 then Result := wSkill_01
      else if wSkill_03 > 0 then Result := wSkill_03
      else if wSkill_04 > 0 then Result := wSkill_04;
    end;
  end;
var
  nMagicID: Integer;
begin
  Result := False;
  m_wHitMode := 0;
  if m_boDoSpellMagic then begin
    nMagicID := SearchDoSpell;
    if nMagicID > 0 then begin
      if not DoSpellMagic(nMagicID) then begin
        SendRefMsg(RM_MAGICFIREFAIL, 0, 0, 0, 0, '');
      end;
      Result := True;
    end;
  end else begin
    Result := WarrAttackTarget(m_wHitMode);
  end;
end;

{道士}
function TPlayMonster.CheckItemType(nItemType: Integer; StdItem: pTStdItem): Boolean;
begin
  Result := False;
  case nItemType of
    1: begin
        if (StdItem.StdMode = 25) and (StdItem.Shape = 5) then Result := True;
      end;
    2: begin
        if (StdItem.StdMode = 25) and (StdItem.Shape <= 2) then Result := True;
      end;
  end;
end;

function TPlayMonster.CheckUserItemType(nItemType: Integer): Boolean;
var
  UserItem: pTUserItem;
  StdItem: pTStdItem;
begin
  Result := False;
  if m_UseItems[U_BUJUK].wIndex > 0 then begin
    StdItem := UserEngine.GetStdItem(m_UseItems[U_BUJUK].wIndex);
    if StdItem <> nil then begin
      Result := CheckItemType(nItemType, StdItem);
    end;
  end;
end;

function TPlayMonster.UseItem(nItemType, nIndex: Integer): Boolean; //自动换毒符
var
  UserItem: pTUserItem;
  AddUserItem: pTUserItem;
  StdItem: pTStdItem;
begin
  Result := False;
  if (nIndex >= 0) and (nIndex < m_ItemList.Count) then begin
    UserItem := m_ItemList.Items[nIndex];
    if m_UseItems[U_BUJUK].wIndex > 0 then begin
      StdItem := UserEngine.GetStdItem(m_UseItems[U_BUJUK].wIndex);
      if StdItem <> nil then begin
        if CheckItemType(nItemType, StdItem) then begin
          Result := True;
        end else begin
          m_ItemList.Delete(nIndex);
          New(AddUserItem);
          AddUserItem^ := m_UseItems[U_BUJUK];
          m_ItemList.Add(AddUserItem);
          m_UseItems[U_BUJUK] := UserItem^;
          DisPose(UserItem);
          Result := True;
        end;
      end else begin
        m_ItemList.Delete(nIndex);
        m_UseItems[U_BUJUK] := UserItem^;
        DisPose(UserItem);
        Result := True;
      end;
    end else begin
      m_ItemList.Delete(nIndex);
      m_UseItems[U_BUJUK] := UserItem^;
      DisPose(UserItem);
      Result := True;
    end;
  end;
end;

//检测包裹中是否有符和毒
//nType 为指定类型 1 为护身符 2 为毒药
function TPlayMonster.GetUserItemList(nItemType: Integer): Integer;
var
  i: Integer;
  UserItem: pTUserItem;
  StdItem: pTStdItem;
begin
  Result := -1;
  for i := 0 to m_ItemList.Count - 1 do begin
    UserItem := m_ItemList.Items[i];
    StdItem := UserEngine.GetStdItem(UserItem.wIndex);
    if StdItem <> nil then begin
      if CheckItemType(nItemType, StdItem) then begin
        Result := i;
        break;
      end;
    end;
  end;
end;

function TPlayMonster.TaoistAttackTarget(): Boolean; {道士攻击}
  function SearchDoSpell: Integer;
    function GetMagic01: Integer;
    begin
      Result := 0;
      if (m_TargetCret.m_wStatusTimeArr[POISON_DECHEALTH] = 0) and
        (m_TargetCret.m_wStatusTimeArr[POISON_DAMAGEARMOR] = 0) then begin
        if (CheckUserItemType(2) or (GetUserItemList(2) >= 0)) then begin
          if wSkill_10 > 0 then Result := wSkill_10 else if wSkill_06 > 0 then Result := wSkill_06;
        end;
      end;
    end;
    function GetMagic02: Integer;
    begin
      Result := 0;
      if (m_TargetCret.m_wStatusTimeArr[POISON_DECHEALTH] = 0) and
        (m_TargetCret.m_wStatusTimeArr[POISON_DAMAGEARMOR] = 0) then begin
        if (CheckUserItemType(2) or (GetUserItemList(2) >= 0)) then begin
          if wSkill_06 > 0 then Result := wSkill_06 else if wSkill_10 > 0 then Result := wSkill_10;
        end;
      end;
    end;
    function GetMagic03: Integer;
    begin
      Result := 0;
      if CheckUserItemType(1) or (GetUserItemList(1) >= 0) then begin
        if wSkill_07 > 0 then Result := wSkill_07;
      end;
    end;
  begin
    Result := 0;
    if (abs(m_TargetCret.m_nCurrX - m_nCurrX) <= 1) and (abs(m_TargetCret.m_nCurrY - m_nCurrY) <= 1) then begin
      if (wSkill_08 > 0) and (m_wStatusTimeArr[STATE_DEFENCEUP] = 0) and (CheckUserItemType(1) or (GetUserItemList(1) >= 0)) then begin
        Result := wSkill_08; {使用神圣战甲术}
        Exit;
      end;
    end;
    if CheckTargetXYCount(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, 3) > 1 then begin
      if (m_TargetCret.m_wStatusTimeArr[POISON_DECHEALTH] = 0) and
        (m_TargetCret.m_wStatusTimeArr[POISON_DAMAGEARMOR] = 0) then begin
        Result := GetMagic01;
        if Result = 0 then Result := GetMagic03;
      end else begin
        Result := GetMagic03;
        if Result = 0 then Result := GetMagic01;
      end;
    end else begin
      if (m_TargetCret.m_wStatusTimeArr[POISON_DECHEALTH] = 0) and
        (m_TargetCret.m_wStatusTimeArr[POISON_DAMAGEARMOR] = 0) then begin
        Result := GetMagic02;
        if Result = 0 then Result := GetMagic03;
      end else begin
        Result := GetMagic03;
        if Result = 0 then Result := GetMagic02;
      end;
    end;
  end;
var
  nMagicID: Integer;
  nIndex: Integer;
begin
  Result := False;
  m_wHitMode := 0;
  if m_boDoSpellMagic then begin
    nMagicID := SearchDoSpell;
    //MainOutMessage('nMagicID '+IntToStr(nMagicID));
    if nMagicID > 0 then begin
      case nMagicID of
        SKILL_FIRECHARM, SKILL_DEJIWONHO: begin
            if not CheckUserItemType(1) then begin
              nIndex := GetUserItemList(1);
              if nIndex >= 0 then begin
                UseItem(1, nIndex);
              end;
            end;
          end;
        SKILL_AMYOUNSUL, SKILL_GROUPAMYOUNSUL: begin
            if not CheckUserItemType(2) then begin
              nIndex := GetUserItemList(2);
              if nIndex >= 0 then begin
                UseItem(2, nIndex);
              end;
            end;
          end;
      end;
      if not DoSpellMagic(nMagicID) then begin
        SendRefMsg(RM_MAGICFIREFAIL, 0, 0, 0, 0, '');
      end;
      Result := True;
    end else begin
      Result := WarrAttackTarget(m_wHitMode);
    end;
  end else begin
    Result := WarrAttackTarget(m_wHitMode);
  end;
end;

function TPlayMonster.AttackTarget(): Boolean;
begin
  Result := False;
  case m_btJob of
    0: begin
        if Integer(GetTickCount - m_dwHitTick) > g_Config.dwWarrorAttackTime then begin
          m_dwHitTick := GetTickCount();
          Result := WarrorAttackTarget;
        end;
      end;
    1: begin
        if Integer(GetTickCount - m_dwHitTick) > g_Config.dwWizardAttackTime then begin
          m_dwHitTick := GetTickCount();
          Result := WizardAttackTarget;
        end;
      end;
    2: begin
        if Integer(GetTickCount - m_dwHitTick) > g_Config.dwTaoistAttackTime then begin
          m_dwHitTick := GetTickCount();
          Result := TaoistAttackTarget;
        end;
      end;
  end;
end;

procedure TPlayMonster.Run;
var
  nX, nY: Integer;
begin
  if not m_boGhost and
    not m_boDeath and
    not m_boFixedHideMode and
    not m_boStoneMode and
    (m_wStatusTimeArr[POISON_STONE {5 0x6A}] = 0) then begin
    if Think then begin
      inherited;
      Exit;
    end;
    if m_boFireHitSkill and ((GetTickCount - m_dwLatestFireHitTick) > 20 * 1000) then begin
      m_boFireHitSkill := False; //关闭烈火
    end;

    if (GetTickCount - m_dwSearchEnemyTick) > 1000 then begin
      m_dwSearchEnemyTick := GetTickCount();
      SearchTarget();       {搜索目标}
    end;

    if m_boWalkWaitLocked then begin
      if (GetTickCount - m_dwWalkWaitTick) > m_dwWalkWait then begin
        m_boWalkWaitLocked := False;
      end;
    end;
    if not m_boWalkWaitLocked and (Integer(GetTickCount - m_dwWalkTick) > m_nWalkSpeed) then begin
      m_dwWalkTick := GetTickCount();
      Inc(m_nWalkCount);
      if m_nWalkCount > m_nWalkStep then begin
        m_nWalkCount := 0;
        m_boWalkWaitLocked := True;
        m_dwWalkWaitTick := GetTickCount();
      end;

      if not m_boRunAwayMode then begin
        if not m_boNoAttackMode then begin
          if m_TargetCret <> nil then begin
            if AttackTarget then begin
              inherited;
              Exit;
            end;
          end else begin
            m_nTargetX := -1;
            if m_boMission then begin
              m_nTargetX := m_nMissionX;
              m_nTargetY := m_nMissionY;
            end;
          end;
        end;
        if m_Master <> nil then begin
          if m_TargetCret = nil then begin
            m_Master.GetBackPosition(nX, nY);
            if (abs(m_nTargetX - nX) > 1) or (abs(m_nTargetY - nY {nX}) > 1) then begin
              m_nTargetX := nX;
              m_nTargetY := nY;
              if (abs(m_nCurrX - nX) <= 2) and (abs(m_nCurrY - nY) <= 2) then begin
                if m_PEnvir.GetMovingObject(nX, nY, True) <> nil then begin
                  m_nTargetX := m_nCurrX;
                  m_nTargetY := m_nCurrY;
                end;
              end;
            end;
          end; //if m_TargetCret = nil then begin
          if (not m_Master.m_boSlaveRelax) and
            ((m_PEnvir <> m_Master.m_PEnvir) or
            (abs(m_nCurrX - m_Master.m_nCurrX) > 20) or
            (abs(m_nCurrY - m_Master.m_nCurrY) > 20)) then begin
            SpaceMove(m_Master.m_PEnvir.sMapName, m_nTargetX, m_nTargetY, 1);
          end;
        end; //if m_Master <> nil then begin
      end else begin
        if (m_dwRunAwayTime > 0) and ((GetTickCount - m_dwRunAwayStart) > m_dwRunAwayTime) then begin
          m_boRunAwayMode := False;
          m_dwRunAwayTime := 0;
        end;
      end;
      if (m_Master <> nil) and m_Master.m_boSlaveRelax then begin
        inherited;
        Exit;
      end;
      if (m_nTargetX <> -1) and AllowGotoTargetXY then begin
        GotoTargetXY(m_nTargetX, m_nTargetY);
      end else begin
        if m_TargetCret = nil then Wondering();
      end;
    end;
  end;
  inherited;
end;

function TPlayMonster.AddItems(UserItem: pTUserItem; btWhere: Integer): Boolean; {//获取身上装备}
begin
  Result := False;
  if btWhere in [Low(THumanUseItems)..High(THumanUseItems)] then begin
    m_UseItems[btWhere] := UserItem^;
    Result := True;
  end;
end;

procedure TPlayMonster.AddItemsFromConfig();
var
  TempList: TStringList;
  sCopyHumBagItems: string;
  UserItem: pTUserItem;
  i: Integer;
  sFileName: string;
  ItemIni: TIniFile;
  sMagic: string;
  sMagicName: string;
  Magic: pTMagic;
  MagicInfo: pTMagic;
  UserMagic: pTUserMagic;
  StdItem: pTStdItem;
  {U_DRESSNAME: string; // '衣服';
  U_WEAPONNAME: string; // '武器';
  U_RIGHTHANDNAME: string; // '照明物';
  U_NECKLACENAME: string; // '项链';
  U_HELMETNAME: string; // '头盔';
  U_ARMRINGLNAME: string; // '左手镯';
  U_ARMRINGRNAME: string; // '右手镯';
  U_RINGLNAME: string; // '左戒指';
  U_RINGRNAME: string; // '右戒指';

  U_BUJUKNAME: string; // '物品';
  U_BELTNAME: string; // '腰带';
  U_BOOTSNAME: string; // '鞋子';
  U_CHARMNAME: string; // '宝石';}
  StdItemNameArray: array[0..12] of string[16];
begin
  if m_nCopyHumanLevel > 0 then begin
    case m_btJob of
      0: sCopyHumBagItems := Trim(g_Config.sCopyHumBagItems1);
      1: sCopyHumBagItems := Trim(g_Config.sCopyHumBagItems2);
      2: sCopyHumBagItems := Trim(g_Config.sCopyHumBagItems3);
    end;
    if sCopyHumBagItems <> '' then begin
      TempList := TStringList.Create;
      ExtractStrings(['|', '\', '/', ','], [], PChar(sCopyHumBagItems), TempList);
      for i := 0 to TempList.Count - 1 do begin
        New(UserItem);
        if UserEngine.CopyToUserItemFromName(TempList.Strings[i], UserItem) then begin
          m_ItemList.Add(UserItem);
          //m_WAbil.Weight := RecalcBagWeight();
        end else DisPose(UserItem);
      end;
      TempList.Free;
    end;
  end else begin
    sFileName := g_Config.sEnvirDir + 'MonUseItems\' + m_sCharName + '.txt';
    if FileExists(sFileName) then begin
      ItemIni := TIniFile.Create(sFileName);
      if ItemIni <> nil then begin
        m_btJob := ItemIni.ReadInteger('BaseInfo', 'Job', 0);
        m_btGender := ItemIni.ReadInteger('BaseInfo', 'Gender', 0);
        m_btHair := ItemIni.ReadInteger('BaseInfo', 'Hair', 0);
        sMagic := ItemIni.ReadString('BaseInfo', 'Magic', '');
        if sMagic <> '' then begin
          TempList := TStringList.Create;
          ExtractStrings(['|', '\', '/', ','], [], PChar(sMagic), TempList);
          for i := 0 to TempList.Count - 1 do begin
            sMagicName := Trim(TempList.Strings[i]);
            if FindMagic(sMagicName) = nil then begin
              Magic := UserEngine.FindMagic(sMagicName);
              if Magic <> nil then begin
                if (Magic.btJob = 99) or (Magic.btJob = m_btJob) then begin
                  New(UserMagic);
                  UserMagic.MagicInfo := Magic;
                  UserMagic.wMagIdx := Magic.wMagicId;
                  UserMagic.btLevel := 3;
                  UserMagic.btKey := 0;
                  UserMagic.nTranPoint := Magic.MaxTrain[3];
                  m_MagicList.Add(UserMagic);
                end;
              end;
            end;
          end;
          TempList.Free;
        end;
        { U_DRESSNAME := ItemIni.ReadString('UseItems', 'DRESSNAME', ''); // '衣服';
         U_WEAPONNAME := ItemIni.ReadString('UseItems', 'WEAPONNAME', ''); // '武器';
         U_RIGHTHANDNAME := ItemIni.ReadString('UseItems', 'RIGHTHANDNAME', ''); // '照明物';
         U_NECKLACENAME := ItemIni.ReadString('UseItems', 'NECKLACENAME', ''); // '项链';
         U_HELMETNAME := ItemIni.ReadString('UseItems', 'HELMETNAME', ''); // '头盔';
         U_ARMRINGLNAME := ItemIni.ReadString('UseItems', 'ARMRINGLNAME', ''); // '左手镯';
         U_ARMRINGRNAME := ItemIni.ReadString('UseItems', 'ARMRINGRNAME', ''); // '右手镯';
         U_RINGLNAME := ItemIni.ReadString('UseItems', 'RINGLNAME', ''); // '左戒指';
         U_RINGRNAME := ItemIni.ReadString('UseItems', 'RINGRNAME', ''); // '右戒指';

         U_BUJUKNAME := ItemIni.ReadString('UseItems', 'BUJUKNAME', ''); // '物品';
         U_BELTNAME := ItemIni.ReadString('UseItems', 'BELTNAME', ''); // '腰带';
         U_BOOTSNAME := ItemIni.ReadString('UseItems', 'BOOTSNAME', ''); // '鞋子';
         U_CHARMNAME := ItemIni.ReadString('UseItems', 'CHARMNAME', ''); // '宝石'; }

        FillChar(StdItemNameArray, SizeOf(StdItemNameArray), #0);
        StdItemNameArray[U_DRESS] := ItemIni.ReadString('UseItems', 'DRESSNAME', ''); // '衣服';
        StdItemNameArray[U_WEAPON] := ItemIni.ReadString('UseItems', 'WEAPONNAME', ''); // '武器';
        StdItemNameArray[U_RIGHTHAND] := ItemIni.ReadString('UseItems', 'RIGHTHANDNAME', ''); // '照明物';
        StdItemNameArray[U_NECKLACE] := ItemIni.ReadString('UseItems', 'NECKLACENAME', ''); // '项链';
        StdItemNameArray[U_HELMET] := ItemIni.ReadString('UseItems', 'HELMETNAME', ''); // '头盔';
        StdItemNameArray[U_ARMRINGL] := ItemIni.ReadString('UseItems', 'ARMRINGLNAME', ''); // '左手镯';
        StdItemNameArray[U_ARMRINGR] := ItemIni.ReadString('UseItems', 'ARMRINGRNAME', ''); // '右手镯';
        StdItemNameArray[U_RINGL] := ItemIni.ReadString('UseItems', 'RINGLNAME', ''); // '左戒指';
        StdItemNameArray[U_RINGR] := ItemIni.ReadString('UseItems', 'RINGRNAME', ''); // '右戒指';
        StdItemNameArray[U_BUJUK] := ItemIni.ReadString('UseItems', 'BUJUKNAME', ''); // '物品';
        StdItemNameArray[U_BELT] := ItemIni.ReadString('UseItems', 'BELTNAME', ''); // '腰带';
        StdItemNameArray[U_BOOTS] := ItemIni.ReadString('UseItems', 'BOOTSNAME', ''); // '鞋子';
        StdItemNameArray[U_CHARM] := ItemIni.ReadString('UseItems', 'CHARMNAME', ''); // '宝石';
        m_nDieDropUseItemRate := ItemIni.ReadInteger('UseItems', 'DieDropUseItemRate', 100);
        for i := U_DRESS to U_CHARM do begin
          if StdItemNameArray[i] <> '' then begin
            StdItem := UserEngine.GetStdItem(StdItemNameArray[i]);
            if StdItem <> nil then begin
              //if CheckTakeOnItems(i, StdItem^) then begin
              New(UserItem);
              if UserEngine.CopyToUserItemFromName(StdItemNameArray[i], UserItem) then begin
                AddItems(UserItem, i);
              end;
              DisPose(UserItem);
              //end;
            end;
          end;
        end;
        ItemIni.Free;
      end;
    end;
  end;
  {for i:=0 to 12 do begin
    MainOutMessage(IntToStr(m_UseItems[i].wIndex));
  end;}
  {for i:=0 to m_ItemList.Count-1 do begin
    MainOutMessage(IntToStr(pTUserItem(m_ItemList.Items[i]).wIndex));
  end;}
end;

function TPlayMonster.FindMagic(sMagicName: string): pTUserMagic;
var
  UserMagic: pTUserMagic;
  i: Integer;
begin
  Result := nil;
  for i := 0 to m_MagicList.Count - 1 do begin
    UserMagic := m_MagicList.Items[i];
    if CompareText(UserMagic.MagicInfo.sMagicName, sMagicName) = 0 then begin
      Result := UserMagic;
      break;
    end;
  end;
end;

function TPlayMonster.CheckTakeOnItems(nWhere: Integer; var StdItem: TStdItem): Boolean;
  function GetUserItemWeitht(nWhere: Integer): Integer;
  var
    i: Integer;
    n14: Integer;
    StdItem: pTStdItem;
  begin
    n14 := 0;
    for i := Low(THumanUseItems) to High(THumanUseItems) do begin
      if (nWhere = -1) or (not (i = nWhere) and not (i = 1) and not (i = 2)) then begin
        StdItem := UserEngine.GetStdItem(m_UseItems[i].wIndex);
        if StdItem <> nil then Inc(n14, StdItem.Weight);
      end;
    end;
    Result := n14;
  end;
begin
  Result := False;
  if (StdItem.StdMode = 10) and (m_btGender <> 0) then begin
    Exit;
  end;
  if (StdItem.StdMode = 11) and (m_btGender <> 1) then begin
    Exit;
  end;
  {if (nWhere = 1) or (nWhere = 2) then begin
    if StdItem.Weight > m_WAbil.MaxHandWeight then Exit;
  end else begin
    if (StdItem.Weight + GetUserItemWeitht(nWhere)) > m_WAbil.MaxWearWeight then Exit;
  end; }
  case StdItem.Need of
    0: begin
        if m_Abil.Level >= StdItem.NeedLevel then Result := True;
      end;
    1: begin
        if HiWord(m_WAbil.DC) >= StdItem.NeedLevel then Result := True;
      end;
    10: begin
        if (m_btJob = LoWord(StdItem.NeedLevel)) and (m_Abil.Level >= HiWord(StdItem.NeedLevel)) then Result := True;
      end;
    11: begin
        if (m_btJob = LoWord(StdItem.NeedLevel)) and (HiWord(m_WAbil.DC) >= HiWord(StdItem.NeedLevel)) then Result := True;
      end;
    12: begin
        if (m_btJob = LoWord(StdItem.NeedLevel)) and (HiWord(m_WAbil.MC) >= HiWord(StdItem.NeedLevel)) then Result := True;
      end;
    13: begin
        if (m_btJob = LoWord(StdItem.NeedLevel)) and (HiWord(m_WAbil.SC) >= HiWord(StdItem.NeedLevel)) then Result := True;
      end;
    2: begin
        if HiWord(m_WAbil.MC) >= StdItem.NeedLevel then Result := True;
      end;
    3: begin
        if HiWord(m_WAbil.SC) >= StdItem.NeedLevel then Result := True;
      end;
    else begin
        Result := True;
      end;
  end;
end;

end.


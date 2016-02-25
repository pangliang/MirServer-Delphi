unit UserMagic;

interface
uses
  Windows, Classes, SysUtils, StrUtils, ExtCtrls, EngineAPI, EngineType, PlugShare;

function OpenMagicFile(): Boolean;
function CloseMagicFile(): Boolean;
function UpData(MagicRcd: TMagicRcd): Boolean;
function AddData(MagicRcd: TMagicRcd): Boolean;
function DelData(nMagicID: Integer): Boolean;
procedure LoadMagicList();
procedure UnLoadMagicList();
procedure LoadMagicListToEngine();
function GetMagicConfig(nMagicID: Integer): pTMagicConfig;
function GetUserMagic(nMagicID: Integer): _LPTMAGIC;
function DoSpell(MagicManager: TMagicManager; PlayObject: TPlayObject; UserMagic: _LPTUSERMAGIC; nTargetX, nTargetY: Integer; TargeTBaseObject: TBaseObject; var boSpellFail, boSpellFire: Boolean): Boolean; stdcall;

const
  SKILL_ONESWORD = 3;
  SKILL_ILKWANG = 4;
  SKILL_YEDO = 7;
  SKILL_ERGUM = 12;
  SKILL_BANWOL = 25;
  SKILL_FIRESWORD = 26;
  SKILL_MOOTEBO = 27;
  SKILL_FIREBALL = 1;
  SKILL_FIREBALL2 = 5;
  SKILL_HEALLING = 2;
  SKILL_AMYOUNSUL = 6;
  SKILL_FIREWIND = 8;
  SKILL_FIRE = 9;
  SKILL_SHOOTLIGHTEN = 10;
  SKILL_LIGHTENING = 11;
  SKILL_FIRECHARM {13} = 13;
  SKILL_HANGMAJINBUB {14} = 14;
  SKILL_DEJIWONHO {15} = 15;
  SKILL_HOLYSHIELD {16} = 16;
  SKILL_SKELLETON {17} = 17;
  SKILL_CLOAK {18} = 18;
  SKILL_BIGCLOAK {19} = 19;
  SKILL_TAMMING = 20;
  SKILL_SPACEMOVE {21} = 21;
  SKILL_EARTHFIRE {22} = 22;
  SKILL_FIREBOOM {23} = 23;
  SKILL_LIGHTFLOWER {24} = 24;
  SKILL_SHOWHP {28} = 28;
  SKILL_BIGHEALLING {29} = 29;
  SKILL_SINSU {30} = 30;
  SKILL_SHIELD {31} = 31;
  SKILL_KILLUNDEAD {32} = 32;
  SKILL_SNOWWIND {33} = 33;
  SKILL_UNAMYOUNSUL {34} = 34;
  SKILL_WINDTEBO {35} = 35;
  SKILL_MABE {36} = 36;
  SKILL_GROUPLIGHTENING {37 群体雷电术} = 37;
  SKILL_GROUPAMYOUNSUL {38 群体施毒术} = 38;
  SKILL_GROUPDEDING {39 地钉} = 39;
  SKILL_40 = 40;
  SKILL_41 = 41;
  SKILL_42 = 42;
  SKILL_43 = 43;
  SKILL_44 = 44;
  SKILL_45 = 45;
  SKILL_46 = 46;
  SKILL_47 = 47;
  SKILL_48 = 48;
  SKILL_49 = 49;
  SKILL_50 = 50;
  SKILL_51 = 51;
  SKILL_52 = 52;
  SKILL_53 = 53;

  SKILL_54 = 54;
  SKILL_55 = 55;
  SKILL_56 = 56;
  SKILL_57 = 57;

  SKILL_58 = 58;
  SKILL_59 = 59;
  SKILL_60 = 60;
  SKILL_61 = 61;

  SKILL_62 = 62;
  SKILL_63 = 63;
  SKILL_64 = 64;
  SKILL_65 = 65;


  SKILL_66 = 66;
  SKILL_67 = 67;
  SKILL_68 = 68;
  SKILL_69 = 69;

  SKILL_70 = 80;
  SKILL_71 = 81;
  SKILL_72 = 82;

  RM_MAGICFIRE = 10120;

implementation

function DoSpell(MagicManager: TMagicManager; PlayObject: TPlayObject; UserMagic: _LPTUSERMAGIC; nTargetX, nTargetY: Integer; TargeTBaseObject: TBaseObject; var boSpellFail, boSpellFire: Boolean): Boolean;
var
  MagicConfig: pTMagicConfig;
  UseItems: _TPLAYUSEITEMS;
  Ability: _TABILITY;
  Magic: _LPTMAGIC;
  n14: Integer;
  n18: Integer;
  n1C: Integer;
  nPower: Integer;
  StdItem: _LPTSTDITEM;
  nAmuletIdx: Integer;
  nX: Integer;
  nY: Integer;
  //
  function MPow(UserMagic: _LPTUSERMAGIC): Integer; //004921C8
  begin
    Result := UserMagic.MagicInfo.wPower + Random(UserMagic.MagicInfo.wMaxPower - UserMagic.MagicInfo.wPower);
  end;
  function GetPower(nPower: Integer): Integer; //00493314
  begin
    Result := ROUND(nPower / (UserMagic.MagicInfo.btTrainLv + 1) * (UserMagic.btLevel + 1)) + (UserMagic.MagicInfo.btDefPower + Random(UserMagic.MagicInfo.btDefMaxPower - UserMagic.MagicInfo.btDefPower));
  end;
  function GetPower13(nInt: Integer): Integer; //0049338C
  var
    d10: Double;
    d18: Double;
  begin
    d10 := nInt / 3.0;
    d18 := nInt - d10;
    Result := ROUND(d18 / (UserMagic.MagicInfo.btTrainLv + 1) * (UserMagic.btLevel + 1) + d10 + (UserMagic.MagicInfo.btDefPower + Random(UserMagic.MagicInfo.btDefMaxPower - UserMagic.MagicInfo.btDefPower)));
  end;
  function GetRPow(wInt: Integer): Word;
  begin
    if HiWord(wInt) > LoWord(wInt) then begin
      Result := Random(HiWord(wInt) - LoWord(wInt) + 1) + LoWord(wInt);
    end else Result := LoWord(wInt);
  end;
  procedure sub_4934B4(PlayObject: TPlayObject);
  var
    UseItems: _TPLAYUSEITEMS;
  begin
    UseItems := TPlayObject_PlayUseItems(PlayObject)^;
    if UseItems[U_ARMRINGL].wDura < 100 then begin
      UseItems[U_ARMRINGL].wDura := 0;
      TPlayObject_SendDelItem(PlayObject, @UseItems[U_ARMRINGL]);
      UseItems[U_ARMRINGL].wIndex := 0;
    end;
  end;
begin
  Result := False;
  nPower := 0;
  Magic := GetUserMagic(UserMagic.MagicInfo.wMagicId);
  if Magic <> nil then begin
    MagicConfig := GetMagicConfig(UserMagic.wMagIdx);
    if MagicConfig <> nil then begin
      if (TargeTBaseObject <> nil) and TBaseObject_boDeath(TargeTBaseObject)^ and (MagicConfig.nSelMagicID <> SKILL_57) then TargeTBaseObject := nil;
      boSpellFail := False;
      boSpellFire := True;
      nPower := 0;
      case MagicConfig.nSelMagicID of
        SKILL_FIREBALL {1},
        SKILL_FIREBALL2 {5}: begin //火球术 大火球
            if TMagicManager_MagMakeFireball(MagicManager, PlayObject,
              UserMagic,
              nTargetX,
              nTargetY,
              TargeTBaseObject) then Result := True;
          end;
        SKILL_HEALLING {2}: begin
            if TMagicManager_MagTreatment(MagicManager, PlayObject,
              UserMagic,
              nTargetX,
              nTargetY,
              TargeTBaseObject) then Result := True;
          end;
        SKILL_AMYOUNSUL {6}: begin //施毒术
            if TMagicManager_MagLightening(MagicManager, PlayObject, UserMagic, nTargetX, nTargetY, TargeTBaseObject, boSpellFail) then
              Result := True;
          end;
        SKILL_FIREWIND {8}: begin //抗拒火环  00493754
            if TMagicManager_MagPushArround(MagicManager, PlayObject, UserMagic.btLevel) > 0 then Result := True;
          end;
        SKILL_FIRE {9}: begin //地狱火 00493778
            if TMagicManager_MagMakeHellFire(MagicManager, PlayObject,
              UserMagic,
              nTargetX,
              nTargetY,
              TargeTBaseObject) then Result := True;
          end;
        SKILL_SHOOTLIGHTEN {10}: begin //疾光电影 0049386A
            if TMagicManager_MagMakeQuickLighting(MagicManager, PlayObject,
              UserMagic,
              nTargetX,
              nTargetY,
              TargeTBaseObject) then Result := True;
          end;
        SKILL_LIGHTENING {11}: begin //雷电术 0049395C
            if TMagicManager_MagMakeLighting(MagicManager, PlayObject,
              UserMagic,
              nTargetX,
              nTargetY,
              TargeTBaseObject) then Result := True;
          end;
        SKILL_FIRECHARM {13},
        SKILL_HANGMAJINBUB {14},
        SKILL_DEJIWONHO {15},
        SKILL_HOLYSHIELD {16},
        SKILL_SKELLETON {17},
        SKILL_CLOAK {18},
        SKILL_BIGCLOAK {19},
        SKILL_52, {52}
        SKILL_57 {57}: begin //004940BC
            boSpellFail := True;
            if TMagicManager_CheckAmulet(PlayObject, 1, 1, nAmuletIdx) then begin
              TMagicManager_UseAmulet(PlayObject, 1, 1, nAmuletIdx);
              case MagicConfig.nSelMagicID of //
                SKILL_FIRECHARM {13}: begin //灵魂火符 0049415F
                    if TMagicManager_MagMakeFireCharm(MagicManager, PlayObject,
                      UserMagic,
                      nTargetX,
                      nTargetY,
                      TargeTBaseObject) then Result := True;
                  end;
                SKILL_HANGMAJINBUB {14}: begin //幽灵盾 00494277
                    Ability := TBaseObject_WAbility(PlayObject)^;
                    nPower := TBaseObject_GetAttackPower(PlayObject, GetPower13(60) + LoWord(Ability.nSC) * 10, SmallInt(HiWord(Ability.nSC) - LoWord(Ability.nSC)) + 1);
                    if TBaseObject_MagMakeDefenceArea(PlayObject, nTargetX, nTargetY, 3, nPower, 1, True) > 0 then
                      Result := True;
                  end;
                SKILL_DEJIWONHO {15}: begin //神圣战甲术 004942E5
                    Ability := TBaseObject_WAbility(PlayObject)^;
                    nPower := TBaseObject_GetAttackPower(PlayObject, GetPower13(60) + LoWord(Ability.nSC) * 10, SmallInt(HiWord(Ability.nSC) - LoWord(Ability.nSC)) + 1);
                    if TBaseObject_MagMakeDefenceArea(PlayObject, nTargetX, nTargetY, 3, nPower, 0, True) > 0 then
                      Result := True;
                  end;
                SKILL_HOLYSHIELD {16}: begin //捆魔咒 00494353
                    Ability := TBaseObject_WAbility(PlayObject)^;
                    if TMagicManager_MagMakeHolyCurtain(MagicManager, PlayObject, GetPower13(40) + GetRPow(Ability.nSC) * 3, nTargetX, nTargetY) > 0 then
                      Result := True;
                  end;
                SKILL_SKELLETON {17}: begin //召唤骷髅 004943A2
                    if TMagicManager_MagMakeSlave(MagicManager, PlayObject, UserMagic) then begin
                      Result := True;
                    end;
                  end;
                SKILL_CLOAK {18}: begin //隐身术
                    Ability := TBaseObject_WAbility(PlayObject)^;
                    if TMagicManager_MagMakePrivateTransparent(MagicManager, PlayObject, GetPower13(30) + GetRPow(Ability.nSC) * 3) then
                      Result := True;
                  end;
                SKILL_BIGCLOAK {19}: begin //集体隐身术
                    Ability := TBaseObject_WAbility(PlayObject)^;
                    if TMagicManager_MagMakeGroupTransparent(MagicManager, PlayObject, nTargetX, nTargetY, GetPower13(30) + GetRPow(Ability.nSC) * 3) then
                      Result := True;
                  end;
                SKILL_52: begin //诅咒术
                    Ability := TBaseObject_WAbility(PlayObject)^;
                    nPower := TBaseObject_GetAttackPower(PlayObject, GetPower13(60) + LoWord(Ability.nSC) * 10, SmallInt(HiWord(Ability.nSC) - LoWord(Ability.nSC)) + 1);
                    if TBaseObject_MagMakeDefenceArea(PlayObject, nTargetX, nTargetY, 3, nPower, 0, False) > 0 then
                      Result := True;
                  end;
                SKILL_57: begin //复活术
                    if TMagicManager_MagMakeLivePlayObject(MagicManager, PlayObject,
                      UserMagic,
                      TargeTBaseObject) then Result := True;
                  end;
              end;
              boSpellFail := False;
              sub_4934B4(PlayObject);
            end;
          end;
        SKILL_TAMMING {20}: begin //诱惑之光 00493A51
            if TBaseObject_IsProperTarget(PlayObject, TargeTBaseObject) then begin
              if TMagicManager_MagTamming(MagicManager, PlayObject, TargeTBaseObject, nTargetX, nTargetY, UserMagic.btLevel) then
                Result := True;
            end;
          end;
        SKILL_SPACEMOVE {21}: begin //瞬息移动 00493ADD
            TBaseObject_SendRefMsg(PlayObject, RM_MAGICFIRE, 0, MakeWord(UserMagic.MagicInfo.btEffectType, UserMagic.MagicInfo.btEffect), MakeLong(nTargetX, nTargetY), Integer(TargeTBaseObject), nil);
            boSpellFire := False;
            if TMagicManager_MagSaceMove(MagicManager, PlayObject, UserMagic.btLevel) then
              Result := True;
          end;
        SKILL_EARTHFIRE {22}: begin //火墙  00493B40
            Ability := TBaseObject_WAbility(PlayObject)^;
            case MagicConfig.nMagicCount of
              0: begin
                  if TMagicManager_MagMakeFireCross(MagicManager, PlayObject,
                    TBaseObject_GetAttackPower(PlayObject, GetPower(MPow(UserMagic)) + LoWord(Ability.nMC),
                    SmallInt(HiWord(Ability.nMC) - LoWord(Ability.nMC)) + 1),
                    GetPower(10) + (Word(GetRPow(Ability.nMC)) shr 1),
                    nTargetX,
                    nTargetY) > 0 then
                    Result := True;
                end;
              1: begin
                  if TMagicManager_MagMakeSuperFireCross(MagicManager, PlayObject,
                    TBaseObject_GetAttackPower(PlayObject, GetPower(MPow(UserMagic)) + LoWord(Ability.nMC),
                    SmallInt(HiWord(Ability.nMC) - LoWord(Ability.nMC)) + 1),
                    Magic.dwDelayTime {GetPower(10) + (Word(GetRPow(Ability.nMC)) shr 1)},
                    nTargetX,
                    nTargetY, 1) > 0 then
                    Result := True;
                end;
              3: begin
                  if TMagicManager_MagMakeSuperFireCross(MagicManager, PlayObject,
                    TBaseObject_GetAttackPower(PlayObject, GetPower(MPow(UserMagic)) + LoWord(Ability.nMC),
                    SmallInt(HiWord(Ability.nMC) - LoWord(Ability.nMC)) + 1),
                    Magic.dwDelayTime {GetPower(10) + (Word(GetRPow(Ability.nMC)) shr 1)},
                    nTargetX,
                    nTargetY, 3) > 0 then
                    Result := True;
                end;
              4: begin
                  if TMagicManager_MagMakeSuperFireCross(MagicManager, PlayObject,
                    TBaseObject_GetAttackPower(PlayObject, GetPower(MPow(UserMagic)) + LoWord(Ability.nMC),
                    SmallInt(HiWord(Ability.nMC) - LoWord(Ability.nMC)) + 1),
                    Magic.dwDelayTime {GetPower(10) + (Word(GetRPow(Ability.nMC)) shr 1)},
                    nTargetX,
                    nTargetY, 4) > 0 then
                    Result := True;
                end;
              5: begin
                  if TMagicManager_MagMakeSuperFireCross(MagicManager, PlayObject,
                    TBaseObject_GetAttackPower(PlayObject, GetPower(MPow(UserMagic)) + LoWord(Ability.nMC),
                    SmallInt(HiWord(Ability.nMC) - LoWord(Ability.nMC)) + 1),
                    Magic.dwDelayTime {GetPower(10) + (Word(GetRPow(Ability.nMC)) shr 1)},
                    nTargetX,
                    nTargetY, 5) > 0 then
                    Result := True;
                end;
              8: begin
                  if TMagicManager_MagMakeSuperFireCross(MagicManager, PlayObject,
                    TBaseObject_GetAttackPower(PlayObject, GetPower(MPow(UserMagic)) + LoWord(Ability.nMC),
                    SmallInt(HiWord(Ability.nMC) - LoWord(Ability.nMC)) + 1),
                    Magic.dwDelayTime {GetPower(10) + (Word(GetRPow(Ability.nMC)) shr 1)},
                    nTargetX,
                    nTargetY, 8) > 0 then
                    Result := True;
                end;
            end;
          end;
        SKILL_FIREBOOM {23}: begin //爆裂火焰 00493BD5
            Ability := TBaseObject_WAbility(PlayObject)^;
            if TMagicManager_MagBigExplosion(MagicManager, PlayObject,
              TBaseObject_GetAttackPower(PlayObject, GetPower(MPow(UserMagic)) + LoWord(Ability.nMC), SmallInt(HiWord(Ability.nMC) - LoWord(Ability.nMC)) + 1),
              nTargetX,
              nTargetY,
              1 {g_Config.nFireBoomRage} {1}) then
              Result := True;
          end;
        SKILL_LIGHTFLOWER {24}: begin //地狱雷光 00493CB1
            Ability := TBaseObject_WAbility(PlayObject)^;
            if TMagicManager_MagElecBlizzard(MagicManager, PlayObject, TBaseObject_GetAttackPower(PlayObject, GetPower(MPow(UserMagic)) + LoWord(Ability.nMC), SmallInt(HiWord(Ability.nMC) - LoWord(Ability.nMC)) + 1)) then
              Result := True;
          end;
        SKILL_SHOWHP {28}: begin
            {Ability := TBaseObject_WAbility(PlayObject)^;
            if (TargeTBaseObject <> nil) and not TargeTBaseObject.m_boShowHP then begin
              if Random(6) <= (UserMagic.btLevel + 3) then begin
                TargeTBaseObject.m_dwShowHPTick := GetTickCount();
                TargeTBaseObject.m_dwShowHPInterval := GetPower13(GetRPow(Ability.SC) * 2 + 30) * 1000;
                TargeTBaseObject.SendDelayMsg(TargeTBaseObject, RM_DOOPENHEALTH, 0, 0, 0, 0, '', 1500);
                boTrain := True;
              end;
            end;}
          end;
        SKILL_BIGHEALLING {29}: begin //群体治疗术 00493E42
            Ability := TBaseObject_WAbility(PlayObject)^;
            nPower := TBaseObject_GetAttackPower(PlayObject, GetPower(MPow(UserMagic)) + LoWord(Ability.nSC) * 2,
              SmallInt(HiWord(Ability.nSC) - LoWord(Ability.nSC)) * 2 + 1);
            if TMagicManager_MagBigHealing(MagicManager, PlayObject, nPower, nTargetX, nTargetY) then Result := True;
          end;
        SKILL_SINSU {30}: begin //00494476
            boSpellFail := True;
            if TMagicManager_CheckAmulet(PlayObject, 5, 1, nAmuletIdx) then begin
              TMagicManager_UseAmulet(PlayObject, 5, 1, nAmuletIdx);
              if TMagicManager_MagMakeSinSuSlave(MagicManager, PlayObject, UserMagic) then begin
                Result := True;
              end;
              boSpellFail := False;
            end;
          end;
        SKILL_SHIELD {31}: begin //魔法盾 00493D15
            Ability := TBaseObject_WAbility(PlayObject)^;
            if TBaseObject_MagBubbleDefenceUp(PlayObject, UserMagic.btLevel, GetPower(GetRPow(Ability.nMC) + 15)) then
              Result := True;
          end;
        SKILL_KILLUNDEAD {32}: begin //00493A97  圣言术
            if TBaseObject_IsProperTarget(PlayObject, TargeTBaseObject) then begin
              if TMagicManager_MagTurnUndead(MagicManager, PlayObject, TargeTBaseObject, nTargetX, nTargetY, UserMagic.btLevel) then
                Result := True;
            end;
          end;
        SKILL_SNOWWIND {33}: begin //00493C43 冰咆哮
            Ability := TBaseObject_WAbility(PlayObject)^;
            if TMagicManager_MagBigExplosion(MagicManager, PlayObject,
              TBaseObject_GetAttackPower(PlayObject, GetPower(MPow(UserMagic)) + LoWord(Ability.nMC), SmallInt(HiWord(Ability.nMC) - LoWord(Ability.nMC)) + 1),
              nTargetX,
              nTargetY,
              1 {g_Config.nSnowWindRange} {1}) then
              Result := True;
          end;
        SKILL_UNAMYOUNSUL {34}: begin //解毒术
            if TMagicManager_MagMakeUnTreatment(MagicManager, PlayObject,
              UserMagic,
              nTargetX,
              nTargetY,
              TargeTBaseObject) then Result := True;
          end;
        SKILL_WINDTEBO {35}: if TMagicManager_MagWindTebo(MagicManager, PlayObject, UserMagic) then Result := True;

        //冰焰
        SKILL_MABE {36}: begin
            Ability := TBaseObject_WAbility(PlayObject)^;
            nPower := TBaseObject_GetAttackPower(PlayObject, GetPower(MPow(UserMagic)) + LoWord(Ability.nMC),
              SmallInt(HiWord(Ability.nMC) - LoWord(Ability.nMC)) + 1);
            if TMagicManager_MabMabe(MagicManager, PlayObject, TargeTBaseObject, nPower, UserMagic.btLevel, nTargetX, nTargetY) then
              Result := True;
          end;
        SKILL_GROUPLIGHTENING {37 群体雷电术}: begin
            if TMagicManager_MagGroupLightening(MagicManager, PlayObject, UserMagic, nTargetX, nTargetY, TargeTBaseObject, boSpellFire) then
              Result := True;
          end;
        SKILL_GROUPAMYOUNSUL {38 群体施毒术}: begin
            if TMagicManager_MagGroupAmyounsul(MagicManager, PlayObject, UserMagic, nTargetX, nTargetY, TargeTBaseObject) then
              Result := True;
          end;
        SKILL_GROUPDEDING {39 地钉}: begin
            if TMagicManager_MagGroupDeDing(MagicManager, PlayObject, UserMagic, nTargetX, nTargetY, TargeTBaseObject) then
              Result := True;
          end;
        SKILL_40: begin //双龙斩

          end;
        SKILL_41: begin //狮子吼
            if TMagicManager_MagGroupMb(MagicManager, PlayObject, UserMagic, nTargetX, nTargetY, TargeTBaseObject) then
              Result := True;
          end;
        SKILL_42: begin //狂风斩

          end;
        SKILL_43: begin //破空剑

          end;
        //法师
        SKILL_44: begin //结冰掌
            if TMagicManager_MagHbFireBall(MagicManager, PlayObject, UserMagic, nTargetX, nTargetY, TargeTBaseObject) then Result := True;
          end;
        SKILL_45: begin //灭天火
            if TMagicManager_MagMakeFireDay(MagicManager, PlayObject, UserMagic, nTargetX, nTargetY, TargeTBaseObject) then Result := True;
          end;
        SKILL_46: begin //分身术
            {if MagMakeSelf(PlayObject, UserMagic) then begin
              boTrain := True;
            end; }
          end;
        SKILL_47: begin //火龙气焰
            Ability := TBaseObject_WAbility(PlayObject)^;
            if TMagicManager_MagBigExplosion(MagicManager, PlayObject,
              TBaseObject_GetAttackPower(PlayObject, GetPower(MPow(UserMagic)) + LoWord(Ability.nMC), SmallInt(HiWord(Ability.nMC) - LoWord(Ability.nMC)) + 1),
              nTargetX,
              nTargetY,
              1 {g_Config.nFireBoomRage} {1}) then
              Result := True;
          end;
        //道士
        SKILL_48: begin //气功波
            if TMagicManager_MagPushArround(MagicManager, PlayObject, UserMagic.btLevel) > 0 then Result := True;
          end;
        SKILL_49: begin //净化术
            Result := True;
          end;
        SKILL_50: begin //无极真气
            Result := True;
          end;
        SKILL_51: begin //飓风破
            Result := True;
          end;

        SKILL_53: begin //血咒
            Result := True;
          end;
        SKILL_54: begin //骷髅咒
            Result := True;
          end;

        SKILL_55: begin //擒龙手
            if TMagicManager_MagMakeArrestObject(MagicManager, PlayObject, UserMagic, TargeTBaseObject) then Result := True;
          end;

        SKILL_56: begin //移行换位
            if TMagicManager_MagChangePosition(MagicManager, PlayObject, nTargetX, nTargetY, TargeTBaseObject) then Result := True;
          end;
      end;
    end;
  end;
end;

function GetUserMagic(nMagicID: Integer): _LPTMAGIC;
var
  I: Integer;
  MagicRcd: pTMagicRcd;
begin
  Result := nil;
  for I := 0 to g_MagicList.Count - 1 do begin
    MagicRcd := pTMagicRcd(g_MagicList.Items[I]);
    if MagicRcd.Magic.wMagicId = nMagicID then begin
      Result := @MagicRcd.Magic;
      break;
    end;
  end;
end;

function GetMagicConfig(nMagicID: Integer): pTMagicConfig;
var
  I: Integer;
  MagicRcd: pTMagicRcd;
begin
  Result := nil;
  for I := 0 to g_MagicList.Count - 1 do begin
    MagicRcd := pTMagicRcd(g_MagicList.Items[I]);
    if MagicRcd.Magic.wMagicId = nMagicID then begin
      Result := @MagicRcd.MagicConfig;
      break;
    end;
  end;
end;

procedure LoadMagicListToEngine();
var
  I: Integer;
  MagicRcd: pTMagicRcd;
begin
  for I := 0 to g_MagicList.Count - 1 do begin
    MagicRcd := pTMagicRcd(g_MagicList.Items[I]);
    TUserEngine_AddMagic(@MagicRcd.Magic);
  end;
end;

function OpenMagicFile(): Boolean;
begin
  if FileExists(m_sDBFileName) then begin
    m_nFileHandle := FileOpen(m_sDBFileName, fmOpenReadWrite or fmShareDenyNone);
    if m_nFileHandle > 0 then
      FileRead(m_nFileHandle, m_Header, SizeOf(TDBHeader));
  end else begin //0x0048B999
    m_nFileHandle := FileCreate(m_sDBFileName);
    if m_nFileHandle > 0 then begin
      m_Header.sDesc := sDBHeaderDesc;
      m_Header.nMagicCount := 0;
      m_Header.dCreateDate := Now;
      FileWrite(m_nFileHandle, m_Header, SizeOf(TDBHeader));
    end;
  end;
  if m_nFileHandle > 0 then Result := True
  else Result := False;
end;

function CloseMagicFile(): Boolean;
begin
  FileClose(m_nFileHandle);
end;

function UpData(MagicRcd: TMagicRcd): Boolean;
var
  DBHeader: TDBHeader;
  n4ADB04: Integer;
  nIndex: Integer;
  RMagicRcd: TMagicRcd;
  boFound: Boolean;
begin
  Result := False;
  boFound := False;
  if OpenMagicFile() then begin
    FileSeek(m_nFileHandle, 0, 0);
    if FileRead(m_nFileHandle, DBHeader, SizeOf(TDBHeader)) = SizeOf(TDBHeader) then begin
      n4ADB04 := DBHeader.nMagicCount;
      for nIndex := 0 to DBHeader.nMagicCount - 1 do begin
        if FileRead(m_nFileHandle, RMagicRcd, SizeOf(TMagicRcd)) <> SizeOf(TMagicRcd) then begin
          break;
        end;
        if RMagicRcd.Magic.wMagicId = MagicRcd.Magic.wMagicId then begin
          FileSeek(m_nFileHandle, SizeOf(TDBHeader) + SizeOf(TMagicRcd) * nIndex, 0);
          FileWrite(m_nFileHandle, MagicRcd, SizeOf(TMagicRcd));
          boFound := True;
          Result := True;
          break;
        end;
      end;
    end;
    if not boFound then Result := AddData(MagicRcd);
    CloseMagicFile();
  end;
end;

function AddData(MagicRcd: TMagicRcd): Boolean;
var
  DBHeader: TDBHeader;
  n4ADB04: Integer;
  nIndex: Integer;
  RMagicRcd: TMagicRcd;
  boFound: Boolean;
begin
  Result := False;
  boFound := False;
  if OpenMagicFile() then begin
    FileSeek(m_nFileHandle, 0, 0);
    if FileRead(m_nFileHandle, DBHeader, SizeOf(TDBHeader)) = SizeOf(TDBHeader) then begin
      n4ADB04 := DBHeader.nMagicCount;
      for nIndex := 0 to DBHeader.nMagicCount - 1 do begin
        if FileRead(m_nFileHandle, RMagicRcd, SizeOf(TMagicRcd)) <> SizeOf(TMagicRcd) then begin
          break;
        end;
        if RMagicRcd.RecordHeader.boDeleted then begin
          FileSeek(m_nFileHandle, SizeOf(TDBHeader) + SizeOf(TMagicRcd) * nIndex, 0);
          FileWrite(m_nFileHandle, MagicRcd, SizeOf(TMagicRcd));
          boFound := True;
          Result := True;
          break;
        end;
      end;
    end;
    if not boFound then begin
      FileSeek(m_nFileHandle, 0, 2);
      FileWrite(m_nFileHandle, MagicRcd, SizeOf(TMagicRcd));
      FileSeek(m_nFileHandle, 0, 0);
      Inc(m_Header.nMagicCount);
      FileWrite(m_nFileHandle, m_Header, SizeOf(TDBHeader));
      Result := True;
    end;
    CloseMagicFile();
  end;
end;

function DelData(nMagicID: Integer): Boolean;
var
  DBHeader: TDBHeader;
  n4ADB04: Integer;
  nIndex: Integer;
  MagicRcd: TMagicRcd;
begin
  Result := False;
  if OpenMagicFile() then begin
    FileSeek(m_nFileHandle, 0, 0);
    if FileRead(m_nFileHandle, DBHeader, SizeOf(TDBHeader)) = SizeOf(TDBHeader) then begin
      n4ADB04 := DBHeader.nMagicCount;
      for nIndex := 0 to DBHeader.nMagicCount - 1 do begin
        if FileRead(m_nFileHandle, MagicRcd, SizeOf(TMagicRcd)) <> SizeOf(TMagicRcd) then begin
          break;
        end;
        if not MagicRcd.RecordHeader.boDeleted then begin
          if MagicRcd.Magic.wMagicId = nMagicID then begin
            MagicRcd.RecordHeader.boDeleted := True;
            Result := UpData(MagicRcd);
            break;
          end;
        end;
      end;
    end;
    CloseMagicFile();
  end;
end;

procedure LoadMagicList();
var
  DBHeader: TDBHeader;
  nIndex: Integer;
  MagicRcd: pTMagicRcd;
begin
  if g_MagicList <> nil then begin
    UnLoadMagicList();
  end;
  g_MagicList := Classes.TList.Create;
  if OpenMagicFile() then begin
    FileSeek(m_nFileHandle, 0, 0);
    if FileRead(m_nFileHandle, DBHeader, SizeOf(TDBHeader)) = SizeOf(TDBHeader) then begin
      for nIndex := 0 to DBHeader.nMagicCount - 1 do begin
        New(MagicRcd);
        if FileRead(m_nFileHandle, MagicRcd^, SizeOf(TMagicRcd)) <> SizeOf(TMagicRcd) then begin
          break;
        end;
        if not MagicRcd.RecordHeader.boDeleted then begin
          g_MagicList.Add(MagicRcd);
        end;
      end;
    end;
    CloseMagicFile();
  end;
end;

procedure UnLoadMagicList();
var
  I: Integer;
  MagicRcd: pTMagicRcd;
begin
  for I := 0 to g_MagicList.Count - 1 do begin
    MagicRcd := pTMagicRcd(g_MagicList.Items[I]);
    TUserEngine_DelMagic(MagicRcd.Magic.wMagicId);
    Dispose(MagicRcd);
  end;
  g_MagicList.Free;
  g_MagicList := nil;
end;

end.


unit ItmUnit;

interface
uses
  Windows, Classes, SysUtils, SDK, Grobal2;
type
  TItemUnit = class
  private
    function GetRandomRange(nCount, nRate: Integer): Integer;
  public
    m_ItemNameList: TGList;
    constructor Create();
    destructor Destroy; override;
    procedure GetItemAddValue(UserItem: pTUserItem; var StdItem: TStdItem);
    procedure RandomUpgradeWeapon(UserItem: pTUserItem);
    procedure RandomUpgradeDress(UserItem: pTUserItem);
    procedure RandomUpgrade19(UserItem: pTUserItem);
    procedure RandomUpgrade202124(UserItem: pTUserItem);
    procedure RandomUpgrade26(UserItem: pTUserItem);
    procedure RandomUpgrade22(UserItem: pTUserItem);
    procedure RandomUpgrade23(UserItem: pTUserItem);
    procedure RandomUpgradeHelMet(UserItem: pTUserItem);
    procedure UnknowHelmet(UserItem: pTUserItem);
    procedure UnknowRing(UserItem: pTUserItem);
    procedure UnknowNecklace(UserItem: pTUserItem);
    function LoadCustomItemName(): Boolean;
    function SaveCustomItemName(): Boolean;
    function AddCustomItemName(nMakeIndex, nItemIndex: Integer; sItemName: string): Boolean;
    function DelCustomItemName(nMakeIndex, nItemIndex: Integer): Boolean;
    function GetCustomItemName(nMakeIndex, nItemIndex: Integer): string;
    procedure Lock();
    procedure UnLock();
  end;
implementation

uses HUtil32, M2Share;



{ TItemUnit }


constructor TItemUnit.Create;
begin
  m_ItemNameList := TGList.Create;
end;

destructor TItemUnit.Destroy;
var
  i: Integer;
begin
  for i := 0 to m_ItemNameList.Count - 1 do begin
    DisPose(pTItemName(m_ItemNameList.Items[i]));
  end;
  m_ItemNameList.Free;
  inherited;
end;

function TItemUnit.GetRandomRange(nCount, nRate: Integer): Integer; //00494794
var
  i: Integer;
begin
  Result := 0;
  for i := 0 to nCount - 1 do
    if Random(nRate) = 0 then Inc(Result);
end;
procedure TItemUnit.RandomUpgradeWeapon(UserItem: pTUserItem); //00494794
var
  nC, n10, n14: Integer;
begin
  nC := GetRandomRange(g_Config.nWeaponDCAddValueMaxLimit {12}, g_Config.nWeaponDCAddValueRate {15});
  if Random(15) = 0 then UserItem.btValue[0] := nC + 1;

  nC := GetRandomRange(12, 15);
  if Random(20) = 0 then begin
    n14 := (nC + 1) div 3;
    if n14 > 0 then begin
      if Random(3) <> 0 then begin
        UserItem.btValue[6] := n14;
      end else begin
        UserItem.btValue[6] := n14 + 10;
      end;
    end;
  end;

  nC := GetRandomRange(12, 15);
  if Random(15) = 0 then UserItem.btValue[1] := nC + 1;
  nC := GetRandomRange(12, 15);
  if Random(15) = 0 then UserItem.btValue[2] := nC + 1;
  nC := GetRandomRange(12, 15);
  if Random(24) = 0 then begin
    UserItem.btValue[5] := nC div 2 + 1;
  end;
  nC := GetRandomRange(12, 12);
  if Random(3) < 2 then begin
    n10 := (nC + 1) * 2000;
    UserItem.DuraMax := _MIN(65000, UserItem.DuraMax + n10);
    UserItem.Dura := _MIN(65000, UserItem.Dura + n10);
  end;
  nC := GetRandomRange(12, 15);
  if Random(10) = 0 then begin
    UserItem.btValue[7] := nC div 2 + 1;
  end;
end;

procedure TItemUnit.RandomUpgradeDress(UserItem: pTUserItem); //00494958
var
  nC, n10: Integer;
begin
  nC := GetRandomRange(6, 15);
  if Random(30) = 0 then UserItem.btValue[0] := nC + 1;
  nC := GetRandomRange(6, 15);
  if Random(30) = 0 then UserItem.btValue[1] := nC + 1;

  nC := GetRandomRange(g_Config.nDressDCAddValueMaxLimit {6}, g_Config.nDressDCAddValueRate {20});
  if Random(g_Config.nDressDCAddRate {40}) = 0 then UserItem.btValue[2] := nC + 1;
  nC := GetRandomRange(g_Config.nDressMCAddValueMaxLimit {6}, g_Config.nDressMCAddValueRate {20});
  if Random(g_Config.nDressMCAddRate {40}) = 0 then UserItem.btValue[3] := nC + 1;
  nC := GetRandomRange(g_Config.nDressSCAddValueMaxLimit {6}, g_Config.nDressSCAddValueRate {20});
  if Random(g_Config.nDressSCAddRate {40}) = 0 then UserItem.btValue[4] := nC + 1;

  nC := GetRandomRange(6, 10);
  if Random(8) < 6 then begin
    n10 := (nC + 1) * 2000;
    UserItem.DuraMax := _MIN(65000, UserItem.DuraMax + n10);
    UserItem.Dura := _MIN(65000, UserItem.Dura + n10);
  end;
end;

procedure TItemUnit.RandomUpgrade202124(UserItem: pTUserItem); //00494AB0
var
  nC, n10: Integer;
begin
  nC := GetRandomRange(6, 30);
  if Random(60) = 0 then UserItem.btValue[0] := nC + 1;
  nC := GetRandomRange(6, 30);
  if Random(60) = 0 then UserItem.btValue[1] := nC + 1;
  nC := GetRandomRange(g_Config.nNeckLace202124DCAddValueMaxLimit {6}, g_Config.nNeckLace202124DCAddValueRate {20});
  if Random(g_Config.nNeckLace202124DCAddRate {30}) = 0 then UserItem.btValue[2] := nC + 1;
  nC := GetRandomRange(g_Config.nNeckLace202124MCAddValueMaxLimit {6}, g_Config.nNeckLace202124MCAddValueRate {20});
  if Random(g_Config.nNeckLace202124MCAddRate {30}) = 0 then UserItem.btValue[3] := nC + 1;
  nC := GetRandomRange(g_Config.nNeckLace202124SCAddValueMaxLimit {6}, g_Config.nNeckLace202124SCAddValueRate {20});
  if Random(g_Config.nNeckLace202124SCAddRate {30}) = 0 then UserItem.btValue[4] := nC + 1;
  nC := GetRandomRange(6, 12);
  if Random(20) < 15 then begin
    n10 := (nC + 1) * 1000;
    UserItem.DuraMax := _MIN(65000, UserItem.DuraMax + n10);
    UserItem.Dura := _MIN(65000, UserItem.Dura + n10);
  end;
end;

procedure TItemUnit.RandomUpgrade26(UserItem: pTUserItem); //00494C08
var
  nC, n10: Integer;
begin
  nC := GetRandomRange(6, 20);
  if Random(20) = 0 then UserItem.btValue[0] := nC + 1;
  nC := GetRandomRange(6, 20);
  if Random(20) = 0 then UserItem.btValue[1] := nC + 1;
  nC := GetRandomRange(g_Config.nArmRing26DCAddValueMaxLimit {6}, g_Config.nArmRing26DCAddValueRate {20});
  if Random(g_Config.nArmRing26DCAddRate {30}) = 0 then UserItem.btValue[2] := nC + 1;
  nC := GetRandomRange(g_Config.nArmRing26MCAddValueMaxLimit {6}, g_Config.nArmRing26MCAddValueRate {20});
  if Random(g_Config.nArmRing26MCAddRate {30}) = 0 then UserItem.btValue[3] := nC + 1;
  nC := GetRandomRange(g_Config.nArmRing26SCAddValueMaxLimit {6}, g_Config.nArmRing26SCAddValueRate {20});
  if Random(g_Config.nArmRing26SCAddRate {30}) = 0 then UserItem.btValue[4] := nC + 1;
  nC := GetRandomRange(6, 12);
  if Random(20) < 15 then begin
    n10 := (nC + 1) * 1000;
    UserItem.DuraMax := _MIN(65000, UserItem.DuraMax + n10);
    UserItem.Dura := _MIN(65000, UserItem.Dura + n10);
  end;
end;

procedure TItemUnit.RandomUpgrade19(UserItem: pTUserItem); //00494D60
var
  nC, n10: Integer;
begin
  nC := GetRandomRange(6, 20);
  if Random(40) = 0 then UserItem.btValue[0] := nC + 1;
  nC := GetRandomRange(6, 20);
  if Random(40) = 0 then UserItem.btValue[1] := nC + 1;

  nC := GetRandomRange(g_Config.nNeckLace19DCAddValueMaxLimit {6}, g_Config.nNeckLace19DCAddValueRate {20});
  if Random(g_Config.nNeckLace19DCAddRate {30}) = 0 then UserItem.btValue[2] := nC + 1;
  nC := GetRandomRange(g_Config.nNeckLace19MCAddValueMaxLimit {6}, g_Config.nNeckLace19MCAddValueRate {20});
  if Random(g_Config.nNeckLace19MCAddRate {30}) = 0 then UserItem.btValue[3] := nC + 1;
  nC := GetRandomRange(g_Config.nNeckLace19SCAddValueMaxLimit {6}, g_Config.nNeckLace19SCAddValueRate {20});
  if Random(g_Config.nNeckLace19SCAddRate {30}) = 0 then UserItem.btValue[4] := nC + 1;
  nC := GetRandomRange(6, 10);
  if Random(4) < 3 then begin
    n10 := (nC + 1) * 1000;
    UserItem.DuraMax := _MIN(65000, UserItem.DuraMax + n10);
    UserItem.Dura := _MIN(65000, UserItem.Dura + n10);
  end;
end;

procedure TItemUnit.RandomUpgrade22(UserItem: pTUserItem); //00494EB8
var
  nC, n10: Integer;
begin
  nC := GetRandomRange(g_Config.nRing22DCAddValueMaxLimit {6}, g_Config.nRing22DCAddValueRate {20});
  if Random(g_Config.nRing22DCAddRate {30}) = 0 then UserItem.btValue[2] := nC + 1;
  nC := GetRandomRange(g_Config.nRing22MCAddValueMaxLimit {6}, g_Config.nRing22MCAddValueRate {20});
  if Random(g_Config.nRing22MCAddRate {30}) = 0 then UserItem.btValue[3] := nC + 1;
  nC := GetRandomRange(g_Config.nRing22SCAddValueMaxLimit {6}, g_Config.nRing22SCAddValueRate {20});
  if Random(g_Config.nRing22SCAddRate {30}) = 0 then UserItem.btValue[4] := nC + 1;
  nC := GetRandomRange(6, 12);
  if Random(4) < 3 then begin
    n10 := (nC + 1) * 1000;
    UserItem.DuraMax := _MIN(65000, UserItem.DuraMax + n10);
    UserItem.Dura := _MIN(65000, UserItem.Dura + n10);
  end;
end;

procedure TItemUnit.RandomUpgrade23(UserItem: pTUserItem); //00494FB8
var
  nC, n10: Integer;
begin
  nC := GetRandomRange(6, 20);
  if Random(40) = 0 then UserItem.btValue[0] := nC + 1;
  nC := GetRandomRange(6, 20);
  if Random(40) = 0 then UserItem.btValue[1] := nC + 1;
  nC := GetRandomRange(g_Config.nRing23DCAddValueMaxLimit {6}, g_Config.nRing23DCAddValueRate {20});
  if Random(g_Config.nRing23DCAddRate {30}) = 0 then UserItem.btValue[2] := nC + 1;
  nC := GetRandomRange(g_Config.nRing23MCAddValueMaxLimit {6}, g_Config.nRing23MCAddValueRate {20});
  if Random(g_Config.nRing23MCAddRate {30}) = 0 then UserItem.btValue[3] := nC + 1;
  nC := GetRandomRange(g_Config.nRing23SCAddValueMaxLimit {6}, g_Config.nRing23SCAddValueRate {20});
  if Random(g_Config.nRing23SCAddRate {30}) = 0 then UserItem.btValue[4] := nC + 1;
  nC := GetRandomRange(6, 12);
  if Random(4) < 3 then begin
    n10 := (nC + 1) * 1000;
    UserItem.DuraMax := _MIN(65000, UserItem.DuraMax + n10);
    UserItem.Dura := _MIN(65000, UserItem.Dura + n10);
  end;
end;

procedure TItemUnit.RandomUpgradeHelMet(UserItem: pTUserItem); //00495110
var
  nC, n10: Integer;
begin
  nC := GetRandomRange(6, 20);
  if Random(40) = 0 then UserItem.btValue[0] := nC + 1;
  nC := GetRandomRange(6, 20);
  if Random(30) = 0 then UserItem.btValue[1] := nC + 1;
  nC := GetRandomRange(g_Config.nHelMetDCAddValueMaxLimit {6}, g_Config.nHelMetDCAddValueRate {20});
  if Random(g_Config.nHelMetDCAddRate {30}) = 0 then UserItem.btValue[2] := nC + 1;
  nC := GetRandomRange(g_Config.nHelMetMCAddValueMaxLimit {6}, g_Config.nHelMetMCAddValueRate {20});
  if Random(g_Config.nHelMetMCAddRate {30}) = 0 then UserItem.btValue[3] := nC + 1;
  nC := GetRandomRange(g_Config.nHelMetSCAddValueMaxLimit {6}, g_Config.nHelMetSCAddValueRate {20});
  if Random(g_Config.nHelMetSCAddRate {30}) = 0 then UserItem.btValue[4] := nC + 1;
  nC := GetRandomRange(6, 12);
  if Random(4) < 3 then begin
    n10 := (nC + 1) * 1000;
    UserItem.DuraMax := _MIN(65000, UserItem.DuraMax + n10);
    UserItem.Dura := _MIN(65000, UserItem.Dura + n10);
  end;
end;

procedure TItemUnit.UnknowHelmet(UserItem: pTUserItem); //00495268 神秘头盔
var
  nC, nRandPoint, n14: Integer;
begin
  nRandPoint := {GetRandomRange(4,3) + GetRandomRange(4,8) + } GetRandomRange(g_Config.nUnknowHelMetACAddValueMaxLimit {4}, g_Config.nUnknowHelMetACAddRate {20});
  if nRandPoint > 0 then UserItem.btValue[0] := nRandPoint;
  n14 := nRandPoint;
  nRandPoint := {GetRandomRange(4,3) + GetRandomRange(4,8) + } GetRandomRange(g_Config.nUnknowHelMetMACAddValueMaxLimit {4}, g_Config.nUnknowHelMetMACAddRate {20});
  if nRandPoint > 0 then UserItem.btValue[1] := nRandPoint;
  Inc(n14, nRandPoint);
  nRandPoint := {GetRandomRange(3,15) + } GetRandomRange(g_Config.nUnknowHelMetDCAddValueMaxLimit {3}, g_Config.nUnknowHelMetDCAddRate {30});
  if nRandPoint > 0 then UserItem.btValue[2] := nRandPoint;
  Inc(n14, nRandPoint);
  nRandPoint := {GetRandomRange(3,15) + } GetRandomRange(g_Config.nUnknowHelMetMCAddValueMaxLimit {3}, g_Config.nUnknowHelMetMCAddRate {30});
  if nRandPoint > 0 then UserItem.btValue[3] := nRandPoint;
  Inc(n14, nRandPoint);
  nRandPoint := {GetRandomRange(3,15) + } GetRandomRange(g_Config.nUnknowHelMetSCAddValueMaxLimit {3}, g_Config.nUnknowHelMetSCAddRate {30});
  if nRandPoint > 0 then UserItem.btValue[4] := nRandPoint;
  Inc(n14, nRandPoint);
  nRandPoint := GetRandomRange(6, 30);
  if nRandPoint > 0 then begin
    nC := (nRandPoint + 1) * 1000;
    UserItem.DuraMax := _MIN(65000, UserItem.DuraMax + nC);
    UserItem.Dura := _MIN(65000, UserItem.Dura + nC);
  end;
  if Random(30) = 0 then UserItem.btValue[7] := 1;
  UserItem.btValue[8] := 1;
  if n14 >= 3 then begin
    if UserItem.btValue[0] >= 5 then begin
      UserItem.btValue[5] := 1;
      UserItem.btValue[6] := UserItem.btValue[0] * 3 + 25;
      exit;
    end;
    if UserItem.btValue[2] >= 2 then begin
      UserItem.btValue[5] := 1;
      UserItem.btValue[6] := UserItem.btValue[2] * 4 + 35;
      exit;
    end;
    if UserItem.btValue[3] >= 2 then begin
      UserItem.btValue[5] := 2;
      UserItem.btValue[6] := UserItem.btValue[3] * 2 + 18;
      exit;
    end;
    if UserItem.btValue[4] >= 2 then begin
      UserItem.btValue[5] := 3;
      UserItem.btValue[6] := UserItem.btValue[4] * 2 + 18;
      exit;
    end;
    UserItem.btValue[6] := n14 * 2 + 18;
  end;
end;

procedure TItemUnit.UnknowRing(UserItem: pTUserItem); //00495500 神秘戒指
var
  nC, n10, n14: Integer;
begin
  n10 := {GetRandomRange(4,3) + GetRandomRange(4,8) + } GetRandomRange(g_Config.nUnknowRingACAddValueMaxLimit {6}, g_Config.nUnknowRingACAddRate {20});
  if n10 > 0 then UserItem.btValue[0] := n10;
  n14 := n10;
  n10 := {GetRandomRange(4,3) + GetRandomRange(4,8) + } GetRandomRange(g_Config.nUnknowRingMACAddValueMaxLimit {6}, g_Config.nUnknowRingMACAddRate {20});
  if n10 > 0 then UserItem.btValue[1] := n10;
  Inc(n14, n10);
  // 以上二项为增加项，增加防，及魔防

  n10 := {GetRandomRange(4,3) + GetRandomRange(4,8) + } GetRandomRange(g_Config.nUnknowRingDCAddValueMaxLimit {6}, g_Config.nUnknowRingDCAddRate {20});
  if n10 > 0 then UserItem.btValue[2] := n10;
  Inc(n14, n10);
  n10 := {GetRandomRange(4,3) + GetRandomRange(4,8) + } GetRandomRange(g_Config.nUnknowRingMCAddValueMaxLimit {6}, g_Config.nUnknowRingMCAddRate {20});
  if n10 > 0 then UserItem.btValue[3] := n10;
  Inc(n14, n10);
  n10 := {GetRandomRange(4,3) + GetRandomRange(4,8) + } GetRandomRange(g_Config.nUnknowRingSCAddValueMaxLimit {6}, g_Config.nUnknowRingSCAddRate {20});
  if n10 > 0 then UserItem.btValue[4] := n10;
  Inc(n14, n10);
  n10 := GetRandomRange(6, 30);
  if n10 > 0 then begin
    nC := (n10 + 1) * 1000;
    UserItem.DuraMax := _MIN(65000, UserItem.DuraMax + nC);
    UserItem.Dura := _MIN(65000, UserItem.Dura + nC);
  end;
  if Random(30) = 0 then UserItem.btValue[7] := 1;
  UserItem.btValue[8] := 1;
  if n14 >= 3 then begin
    if UserItem.btValue[2] >= 3 then begin
      UserItem.btValue[5] := 1;
      UserItem.btValue[6] := UserItem.btValue[2] * 3 + 25;
      exit;
    end;
    if UserItem.btValue[3] >= 3 then begin
      UserItem.btValue[5] := 2;
      UserItem.btValue[6] := UserItem.btValue[3] * 2 + 18;
      exit;
    end;
    if UserItem.btValue[4] >= 3 then begin
      UserItem.btValue[5] := 3;
      UserItem.btValue[6] := UserItem.btValue[4] * 2 + 18;
      exit;
    end;
    UserItem.btValue[6] := n14 * 2 + 18;
  end;
end;

procedure TItemUnit.UnknowNecklace(UserItem: pTUserItem); //00495704 神秘腰带
var
  nC, n10, n14: Integer;
begin
  n10 := {GetRandomRange(3,5) + } GetRandomRange(g_Config.nUnknowNecklaceACAddValueMaxLimit {5}, g_Config.nUnknowNecklaceACAddRate {20});
  if n10 > 0 then UserItem.btValue[0] := n10;
  n14 := n10;
  n10 := {GetRandomRange(3,5) + } GetRandomRange(g_Config.nUnknowNecklaceMACAddValueMaxLimit {5}, g_Config.nUnknowNecklaceMACAddRate {20});
  if n10 > 0 then UserItem.btValue[1] := n10;
  Inc(n14, n10);
  n10 := {GetRandomRange(3,15) + } GetRandomRange(g_Config.nUnknowNecklaceDCAddValueMaxLimit {5}, g_Config.nUnknowNecklaceDCAddRate {30});
  if n10 > 0 then UserItem.btValue[2] := n10;
  Inc(n14, n10);
  n10 := {GetRandomRange(3,15) + } GetRandomRange(g_Config.nUnknowNecklaceMCAddValueMaxLimit {5}, g_Config.nUnknowNecklaceMCAddRate {30});
  if n10 > 0 then UserItem.btValue[3] := n10;
  Inc(n14, n10);
  n10 := {GetRandomRange(3,15) + } GetRandomRange(g_Config.nUnknowNecklaceSCAddValueMaxLimit {5}, g_Config.nUnknowNecklaceSCAddRate {30});
  if n10 > 0 then UserItem.btValue[4] := n10;
  Inc(n14, n10);
  n10 := GetRandomRange(6, 30);
  if n10 > 0 then begin
    nC := (n10 + 1) * 1000;
    UserItem.DuraMax := _MIN(65000, UserItem.DuraMax + nC);
    UserItem.Dura := _MIN(65000, UserItem.Dura + nC);
  end;
  if Random(30) = 0 then UserItem.btValue[7] := 1;
  UserItem.btValue[8] := 1;
  if n14 >= 2 then begin
    if UserItem.btValue[0] >= 3 then begin
      UserItem.btValue[5] := 1;
      UserItem.btValue[6] := UserItem.btValue[0] * 3 + 25;
      exit;
    end;
    if UserItem.btValue[2] >= 2 then begin
      UserItem.btValue[5] := 1;
      UserItem.btValue[6] := UserItem.btValue[2] * 3 + 30;
      exit;
    end;
    if UserItem.btValue[3] >= 2 then begin
      UserItem.btValue[5] := 2;
      UserItem.btValue[6] := UserItem.btValue[3] * 2 + 20;
      exit;
    end;
    if UserItem.btValue[4] >= 2 then begin
      UserItem.btValue[5] := 3;
      UserItem.btValue[6] := UserItem.btValue[4] * 2 + 20;
      exit;
    end;
    UserItem.btValue[6] := n14 * 2 + 18;
  end;
end;

procedure TItemUnit.GetItemAddValue(UserItem: pTUserItem; var StdItem: TStdItem); //00495974
begin
  case StdItem.StdMode of
    5, 6: begin //004959D6
        StdItem.DC := MakeLong(LoWord(StdItem.DC), HiWord(StdItem.DC) + UserItem.btValue[0]);
        StdItem.MC := MakeLong(LoWord(StdItem.MC), HiWord(StdItem.MC) + UserItem.btValue[1]);
        StdItem.SC := MakeLong(LoWord(StdItem.SC), HiWord(StdItem.SC) + UserItem.btValue[2]);
        StdItem.AC := MakeLong(LoWord(StdItem.AC) + UserItem.btValue[3], HiWord(StdItem.AC) + UserItem.btValue[5]);
        StdItem.MAC := MakeLong(LoWord(StdItem.MAC) + UserItem.btValue[4], HiWord(StdItem.MAC) + UserItem.btValue[6]);
        if Byte(UserItem.btValue[7] - 1) < 10 then begin //神圣
          StdItem.Source := UserItem.btValue[7];
        end;
        if UserItem.btValue[10] <> 0 then
          StdItem.Reserved := StdItem.Reserved or 1;
      end;
    10, 11: begin
        StdItem.AC := MakeLong(LoWord(StdItem.AC), HiWord(StdItem.AC) + UserItem.btValue[0]);
        StdItem.MAC := MakeLong(LoWord(StdItem.MAC), HiWord(StdItem.MAC) + UserItem.btValue[1]);
        StdItem.DC := MakeLong(LoWord(StdItem.DC), HiWord(StdItem.DC) + UserItem.btValue[2]);
        StdItem.MC := MakeLong(LoWord(StdItem.MC), HiWord(StdItem.MC) + UserItem.btValue[3]);
        StdItem.SC := MakeLong(LoWord(StdItem.SC), HiWord(StdItem.SC) + UserItem.btValue[4]);
      end;
    15, 19, 20, 21, 22, 23, 24, 26, 51, 52, 53, 54, 62, 63, 64: begin
        StdItem.AC := MakeLong(LoWord(StdItem.AC), HiWord(StdItem.AC) + UserItem.btValue[0]);
        StdItem.MAC := MakeLong(LoWord(StdItem.MAC), HiWord(StdItem.MAC) + UserItem.btValue[1]);
        StdItem.DC := MakeLong(LoWord(StdItem.DC), HiWord(StdItem.DC) + UserItem.btValue[2]);
        StdItem.MC := MakeLong(LoWord(StdItem.MC), HiWord(StdItem.MC) + UserItem.btValue[3]);
        StdItem.SC := MakeLong(LoWord(StdItem.SC), HiWord(StdItem.SC) + UserItem.btValue[4]);
        if UserItem.btValue[5] > 0 then begin
          StdItem.Need := UserItem.btValue[5];
        end;
        if UserItem.btValue[6] > 0 then begin
          StdItem.NeedLevel := UserItem.btValue[6];
        end;
      end;
  end;
end;

function TItemUnit.GetCustomItemName(nMakeIndex,
  nItemIndex: Integer): string;
var
  i: Integer;
  ItemName: pTItemName;
begin
  Result := '';
  m_ItemNameList.Lock;
  try
    for i := 0 to m_ItemNameList.Count - 1 do begin
      ItemName := m_ItemNameList.Items[i];
      if (ItemName.nMakeIndex = nMakeIndex) and (ItemName.nItemIndex = nItemIndex) then begin
        Result := ItemName.sItemName;
        break;
      end;
    end;
  finally
    m_ItemNameList.UnLock;
  end;
end;


function TItemUnit.AddCustomItemName(nMakeIndex, nItemIndex: Integer;
  sItemName: string): Boolean;
var
  i: Integer;
  ItemName: pTItemName;
begin
  Result := False;
  m_ItemNameList.Lock;
  try
    for i := 0 to m_ItemNameList.Count - 1 do begin
      ItemName := m_ItemNameList.Items[i];
      if (ItemName.nMakeIndex = nMakeIndex) and (ItemName.nItemIndex = nItemIndex) then begin
        exit;
      end;
    end;
    New(ItemName);
    ItemName.nMakeIndex := nMakeIndex;
    ItemName.nItemIndex := nItemIndex;
    ItemName.sItemName := sItemName;
    m_ItemNameList.Add(ItemName);
    Result := True;
  finally
    m_ItemNameList.UnLock;
  end;
end;

function TItemUnit.DelCustomItemName(nMakeIndex, nItemIndex: Integer): Boolean;
var
  i: Integer;
  ItemName: pTItemName;
begin
  Result := False;
  m_ItemNameList.Lock;
  try
    for i := 0 to m_ItemNameList.Count - 1 do begin
      ItemName := m_ItemNameList.Items[i];
      if (ItemName.nMakeIndex = nMakeIndex) and (ItemName.nItemIndex = nItemIndex) then begin
        DisPose(ItemName);
        m_ItemNameList.Delete(i);
        Result := True;
        exit;
      end;
    end;
  finally
    m_ItemNameList.UnLock;
  end;
end;

function TItemUnit.LoadCustomItemName: Boolean;
var
  i: Integer;
  LoadList: TStringList;
  sFileName: string;
  sLineText: string;
  sMakeIndex: string;
  sItemIndex: string;
  nMakeIndex: Integer;
  nItemIndex: Integer;
  sItemName: string;
  ItemName: pTItemName;
begin
  Result := False;
  sFileName := g_Config.sEnvirDir + 'ItemNameList.txt';
  LoadList := TStringList.Create;
  if FileExists(sFileName) then begin
    m_ItemNameList.Lock;
    try
      m_ItemNameList.Clear;
      LoadList.LoadFromFile(sFileName);
      for i := 0 to LoadList.Count - 1 do begin
        sLineText := Trim(LoadList.Strings[i]);
        sLineText := GetValidStr3(sLineText, sMakeIndex, [' ', #9]);
        sLineText := GetValidStr3(sLineText, sItemIndex, [' ', #9]);
        sLineText := GetValidStr3(sLineText, sItemName, [' ', #9]);
        nMakeIndex := Str_ToInt(sMakeIndex, -1);
        nItemIndex := Str_ToInt(sItemIndex, -1);
        if (nMakeIndex >= 0) and (nItemIndex >= 0) then begin
          New(ItemName);
          ItemName.nMakeIndex := nMakeIndex;
          ItemName.nItemIndex := nItemIndex;
          ItemName.sItemName := sItemName;
          m_ItemNameList.Add(ItemName);
        end;
      end;
      Result := True;
    finally
      m_ItemNameList.UnLock;
    end;
  end else begin
    LoadList.SaveToFile(sFileName);
  end;
  LoadList.Free;
end;

function TItemUnit.SaveCustomItemName: Boolean;
var
  i: Integer;
  SaveList: TStringList;
  sFileName: string;
  ItemName: pTItemName;
begin
  sFileName := g_Config.sEnvirDir + 'ItemNameList.txt';
  SaveList := TStringList.Create;
  m_ItemNameList.Lock;
  try
    for i := 0 to m_ItemNameList.Count - 1 do begin
      ItemName := m_ItemNameList.Items[i];
      SaveList.Add(IntToStr(ItemName.nMakeIndex) + #9 + IntToStr(ItemName.nItemIndex) + #9 + ItemName.sItemName);
    end;
  finally
    m_ItemNameList.UnLock;
  end;
  SaveList.SaveToFile(sFileName);
  SaveList.Free;
  Result := True;
end;

procedure TItemUnit.Lock;
begin
  m_ItemNameList.Lock;
end;

procedure TItemUnit.UnLock;
begin
  m_ItemNameList.UnLock;
end;

end.

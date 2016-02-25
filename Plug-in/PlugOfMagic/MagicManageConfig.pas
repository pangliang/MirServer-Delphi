unit MagicManageConfig;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, Spin, ExtCtrls;

type
  TFrmMagicManage = class(TForm)
    GroupBox1: TGroupBox;
    ListViewMagic: TListView;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    ButtonLoadMagic: TButton;
    ButtonSaveMagic: TButton;
    ButtonChgMagic: TButton;
    ButtonDelMagic: TButton;
    ButtonAddMagic: TButton;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    SpinEditMagID: TSpinEdit;
    EditMagName: TEdit;
    SpinEditEffectType: TSpinEdit;
    SpinEditEffect: TSpinEdit;
    SpinEditPower: TSpinEdit;
    SpinEditMaxPower: TSpinEdit;
    SpinEditDefSpell: TSpinEdit;
    SpinEditDefPower: TSpinEdit;
    SpinEditDefMaxPower: TSpinEdit;
    SpinEditJob: TSpinEdit;
    SpinEditNeedL1: TSpinEdit;
    SpinEditSpell: TSpinEdit;
    SpinEditL1Train: TSpinEdit;
    SpinEditNeedL2: TSpinEdit;
    SpinEditL2Train: TSpinEdit;
    SpinEditNeedL3: TSpinEdit;
    SpinEditL3Train: TSpinEdit;
    SpinEditDelay: TSpinEdit;
    Label19: TLabel;
    EditDescr: TEdit;
    GroupBox3: TGroupBox;
    GroupBox5: TGroupBox;
    CheckBoxHP: TCheckBox;
    CheckBoxMP: TCheckBox;
    CheckBoxAbil: TCheckBox;
    CheckBoxAC: TCheckBox;
    CheckBoxMC: TCheckBox;
    ListBoxMagic: TListBox;
    GroupBox6: TGroupBox;
    LabelSelMagic: TLabel;
    RadioGroupWay: TRadioGroup;
    Label21: TLabel;
    SpinEditMagicCount: TSpinEdit;
    LabelSelMagicName: TLabel;
    RadioGroupAttackRange: TRadioGroup;
    RadioGroupMagicNeed: TRadioGroup;
    procedure ButtonAddMagicClick(Sender: TObject);
    procedure ButtonChgMagicClick(Sender: TObject);
    procedure ButtonDelMagicClick(Sender: TObject);
    procedure ButtonSaveMagicClick(Sender: TObject);
    procedure ButtonLoadMagicClick(Sender: TObject);
    procedure ListBoxMagicClick(Sender: TObject);
    procedure ListViewMagicClick(Sender: TObject);
    procedure RadioGroupWayClick(Sender: TObject);
  private
    { Private declarations }
    function InMagicList(nMagicID: Integer): Boolean;
    function GetMagicCountByMagicID(nMagicID: Integer): Integer;
    procedure RefMagicList();
    procedure DisposeListViewMagic();

    procedure LoadTUserEngineMagicList();
    function GetMagicOfID(nMagicID: Integer): Integer;
  public

    { Public declarations }
    procedure Open();
  end;

var
  FrmMagicManage: TFrmMagicManage;

implementation
uses HUtil32, PlugShare, UserMagic, EngineType, EngineAPI;
{$R *.dfm} //CompareText(
procedure TFrmMagicManage.Open();
begin
  RefMagicList();
  LoadTUserEngineMagicList();
  PageControl1.ActivePageIndex := 0;
  ShowModal;
end;

procedure TFrmMagicManage.RefMagicList();
var
  I: Integer;
  MagicRcd: pTMagicRcd;
  Magic: _LPTMAGIC;
  ListItem: TListItem;
begin
  ListViewMagic.Items.Clear;
  for I := 0 to g_MagicList.Count - 1 do begin
    MagicRcd := pTMagicRcd(g_MagicList.Items[I]);
    Magic := @MagicRcd.Magic;
    try
      ListViewMagic.Items.BeginUpdate;
      ListItem := ListViewMagic.Items.Add;
      ListItem.Caption := IntToStr(Magic.wMagicId);
      ListItem.SubItems.AddObject(Magic.sMagicName, TObject(@MagicRcd.MagicConfig));
      ListItem.SubItems.Add(IntToStr(Magic.btEffectType));
      ListItem.SubItems.Add(IntToStr(Magic.btEffect));
      ListItem.SubItems.Add(IntToStr(Magic.wSpell));
      ListItem.SubItems.Add(IntToStr(Magic.wPower));
      ListItem.SubItems.Add(IntToStr(Magic.wMaxPower));
      ListItem.SubItems.Add(IntToStr(Magic.btDefSpell));
      ListItem.SubItems.Add(IntToStr(Magic.btDefPower));
      ListItem.SubItems.Add(IntToStr(Magic.btDefMaxPower));
      ListItem.SubItems.Add(IntToStr(Magic.btJob));
      ListItem.SubItems.Add(IntToStr(Magic.TrainLevel[0]));
      ListItem.SubItems.Add(IntToStr(Magic.MaxTrain[0]));
      ListItem.SubItems.Add(IntToStr(Magic.TrainLevel[1]));
      ListItem.SubItems.Add(IntToStr(Magic.MaxTrain[1]));
      ListItem.SubItems.Add(IntToStr(Magic.TrainLevel[2]));
      ListItem.SubItems.Add(IntToStr(Magic.MaxTrain[2]));
      ListItem.SubItems.Add(IntToStr(Magic.dwDelayTime));
      ListItem.SubItems.Add(Magic.sDescr);
    finally
      ListViewMagic.Items.EndUpdate;
    end;
  end;
end;

procedure TFrmMagicManage.LoadTUserEngineMagicList();
var
  I: Integer;
  MagicList: Classes.TList;
  Magic: _LPTMAGIC;
begin
  MagicList := Classes.TList(TUserEngine_GetMagicList);
  for I := 0 to MagicList.Count - 1 do begin
    Magic := MagicList.Items[I];
    if (Magic.wMagicId < 100) and (Magic.wMagicId <> 3)
      and (Magic.wMagicId <> 4) and (Magic.wMagicId <> 7)
      and (Magic.wMagicId <> 12) and (Magic.wMagicId <> 25)
      and (Magic.wMagicId <> 26) and (Magic.wMagicId <> 27)
      then begin
      ListBoxMagic.Items.AddObject(Magic.sMagicName, TObject(Magic));
    end;
  end;
end;

function TFrmMagicManage.InMagicList(nMagicID: Integer): Boolean;
var
  I: Integer;
  ListItem: TListItem;
begin
  Result := False;
  ListViewMagic.Items.BeginUpdate;
  try
    for I := 0 to ListViewMagic.Items.Count - 1 do begin
      ListItem := ListViewMagic.Items.Item[I];
      if Str_ToInt(ListItem.Caption, 100) = nMagicID then begin
        Result := True;
        Break;
      end;
    end;
  finally
    ListViewMagic.Items.EndUpdate;
  end;
end;

function TFrmMagicManage.GetMagicCountByMagicID(nMagicID: Integer): Integer;
var
  I: Integer;
  ListItem: TListItem;
begin
  Result := 0;
  ListViewMagic.Items.BeginUpdate;
  try
    for I := 0 to ListViewMagic.Items.Count - 1 do begin
      ListItem := ListViewMagic.Items.Item[I];
      if Str_ToInt(ListItem.Caption, 100) = nMagicID then begin
        Inc(Result);
      end;
    end;
  finally
    ListViewMagic.Items.EndUpdate;
  end;
end;

procedure TFrmMagicManage.ButtonAddMagicClick(Sender: TObject);
var
  sMagName: string;
  ListItem: TListItem;
  MagicConfig: pTMagicConfig;
  MagicRcd: pTMagicRcd;
  Magic: _LPTMAGIC;
begin
  sMagName := Trim(EditMagName.Text);
  if sMagName = '' then begin
    PageControl1.ActivePageIndex := 0;
    EditMagName.SetFocus;
    Application.MessageBox('请输入魔法名称！！！', '提示信息', MB_ICONQUESTION);
    Exit;
  end;
  if InMagicList(SpinEditMagID.Value) then begin
    PageControl1.ActivePageIndex := 0;
    SpinEditMagID.SetFocus;
    Application.MessageBox('你输入魔法ID已经存在，请选择其他魔法ID！！！', '提示信息', MB_ICONQUESTION);
    Exit;
  end;
  if nSelMagicID <= 0 then begin
    PageControl1.ActivePageIndex := 1;
    ListBoxMagic.SetFocus;
    Application.MessageBox('请选择一个攻击魔法效果！！！', '提示信息', MB_ICONQUESTION);
    Exit;
  end;
  New(MagicRcd);
  FillChar(MagicRcd.RecordHeader, SizeOf(TRecordHeader), #0);
  FillChar(MagicRcd.Magic, SizeOf(_TMAGIC), #0);
  FillChar(MagicRcd.MagicConfig, SizeOf(TMagicConfig), #0);
  MagicRcd.RecordHeader.boDeleted := False;
  MagicRcd.RecordHeader.dCreateDate := Now;
  MagicRcd.MagicConfig.nSelMagicID := nSelMagicID;
  MagicRcd.MagicConfig.nMagicCount := SpinEditMagicCount.Value;
  MagicRcd.MagicConfig.nAttackRange := RadioGroupAttackRange.ItemIndex;
  MagicRcd.MagicConfig.nAttackWay := RadioGroupWay.ItemIndex;
  MagicRcd.MagicConfig.nNeed := RadioGroupMagicNeed.ItemIndex;
  MagicRcd.MagicConfig.boHP := CheckBoxHP.Checked;
  MagicRcd.MagicConfig.boMP := CheckBoxMP.Checked;
  MagicRcd.MagicConfig.boAC := CheckBoxAC.Checked;
  MagicRcd.MagicConfig.boMC := CheckBoxMC.Checked;
  MagicRcd.MagicConfig.boAbil := CheckBoxAbil.Checked;
  MagicRcd.Magic.wMagicId := SpinEditMagID.Value;
  MagicRcd.Magic.sMagicName := sMagName;
  MagicRcd.Magic.btEffectType := SpinEditEffectType.Value;
  MagicRcd.Magic.btEffect := SpinEditEffect.Value;
  MagicRcd.Magic.wSpell := SpinEditSpell.Value;
  MagicRcd.Magic.wPower := SpinEditPower.Value;
  MagicRcd.Magic.wMaxPower := SpinEditMaxPower.Value;
  MagicRcd.Magic.btDefSpell := SpinEditDefSpell.Value;
  MagicRcd.Magic.btDefPower := SpinEditDefPower.Value;
  MagicRcd.Magic.btDefMaxPower := SpinEditDefMaxPower.Value;
  MagicRcd.Magic.btJob := SpinEditJob.Value;
  MagicRcd.Magic.btTrainLv := 3;
  MagicRcd.Magic.TrainLevel[0] := SpinEditNeedL1.Value;
  MagicRcd.Magic.MaxTrain[0] := SpinEditL1Train.Value;
  MagicRcd.Magic.TrainLevel[1] := SpinEditNeedL2.Value;
  MagicRcd.Magic.MaxTrain[1] := SpinEditL2Train.Value;
  MagicRcd.Magic.TrainLevel[2] := SpinEditNeedL3.Value;
  MagicRcd.Magic.MaxTrain[2] := SpinEditL3Train.Value;
  MagicRcd.Magic.TrainLevel[3] := SpinEditNeedL3.Value;
  MagicRcd.Magic.MaxTrain[3] := MagicRcd.Magic.MaxTrain[2];
  MagicRcd.Magic.dwDelayTime := SpinEditDelay.Value;
  MagicRcd.Magic.sDescr := EditDescr.Text;
  g_MagicList.Add(MagicRcd);
  ListViewMagic.Items.BeginUpdate;
  try
    ListItem := ListViewMagic.Items.Add;
    ListItem.Caption := IntToStr(SpinEditMagID.Value);
    ListItem.SubItems.AddObject(sMagName, TObject(@MagicRcd.MagicConfig));
    ListItem.SubItems.Add(IntToStr(SpinEditEffectType.Value));
    ListItem.SubItems.Add(IntToStr(SpinEditEffect.Value));
    ListItem.SubItems.Add(IntToStr(SpinEditSpell.Value));
    ListItem.SubItems.Add(IntToStr(SpinEditPower.Value));
    ListItem.SubItems.Add(IntToStr(SpinEditMaxPower.Value));
    ListItem.SubItems.Add(IntToStr(SpinEditDefSpell.Value));
    ListItem.SubItems.Add(IntToStr(SpinEditDefPower.Value));
    ListItem.SubItems.Add(IntToStr(SpinEditDefMaxPower.Value));
    ListItem.SubItems.Add(IntToStr(SpinEditJob.Value));
    ListItem.SubItems.Add(IntToStr(SpinEditNeedL1.Value));
    ListItem.SubItems.Add(IntToStr(SpinEditL1Train.Value));
    ListItem.SubItems.Add(IntToStr(SpinEditNeedL2.Value));
    ListItem.SubItems.Add(IntToStr(SpinEditL2Train.Value));
    ListItem.SubItems.Add(IntToStr(SpinEditNeedL3.Value));
    ListItem.SubItems.Add(IntToStr(SpinEditL3Train.Value));
    ListItem.SubItems.Add(IntToStr(SpinEditDelay.Value));
    ListItem.SubItems.Add(EditDescr.Text);
  finally
    ListViewMagic.Items.EndUpdate;
  end;
end;

procedure TFrmMagicManage.ButtonChgMagicClick(Sender: TObject);
var
  ListItem: TListItem;
  sMagName: string;
  MagicConfig: pTMagicConfig;
  MagicRcd: pTMagicRcd;
  nItemIndex: Integer;
begin
  sMagName := Trim(EditMagName.Text);
  if sMagName = '' then begin
    PageControl1.ActivePageIndex := 0;
    EditMagName.SetFocus;
    Application.MessageBox('请输入魔法名称！！！', '提示信息', MB_ICONQUESTION);
    Exit;
  end;
  if GetMagicCountByMagicID(SpinEditMagID.Value) >= 2 then begin
    PageControl1.ActivePageIndex := 0;
    SpinEditMagID.SetFocus;
    Application.MessageBox('你输入魔法ID已经存在，请选择其他魔法ID！！！', '提示信息', MB_ICONQUESTION);
    Exit;
  end;
  if nSelMagicID <= 0 then begin
    PageControl1.ActivePageIndex := 1;
    ListBoxMagic.SetFocus;
    Application.MessageBox('请选择一个攻击魔法效果！！！', '提示信息', MB_ICONQUESTION);
    Exit;
  end;
  nItemIndex := ListViewMagic.ItemIndex;
  if (nItemIndex >= 0) and (nItemIndex < g_MagicList.Count) then begin
    MagicRcd := g_MagicList.Items[nItemIndex];
    MagicRcd.MagicConfig.nSelMagicID := nSelMagicID;
    MagicRcd.MagicConfig.nMagicCount := SpinEditMagicCount.Value;
    MagicRcd.MagicConfig.nAttackRange := RadioGroupAttackRange.ItemIndex;
    MagicRcd.MagicConfig.nAttackWay := RadioGroupWay.ItemIndex;
    MagicRcd.MagicConfig.nNeed := RadioGroupMagicNeed.ItemIndex;
    MagicRcd.MagicConfig.boHP := CheckBoxHP.Checked;
    MagicRcd.MagicConfig.boMP := CheckBoxMP.Checked;
    MagicRcd.MagicConfig.boAC := CheckBoxAC.Checked;
    MagicRcd.MagicConfig.boMC := CheckBoxMC.Checked;
    MagicRcd.MagicConfig.boAbil := CheckBoxAbil.Checked;
    MagicRcd.Magic.wMagicId := SpinEditMagID.Value;
    MagicRcd.Magic.sMagicName := sMagName;
    MagicRcd.Magic.btEffectType := SpinEditEffectType.Value;
    MagicRcd.Magic.btEffect := SpinEditEffect.Value;
    MagicRcd.Magic.wSpell := SpinEditSpell.Value;
    MagicRcd.Magic.wPower := SpinEditPower.Value;
    MagicRcd.Magic.wMaxPower := SpinEditMaxPower.Value;
    MagicRcd.Magic.btDefSpell := SpinEditDefSpell.Value;
    MagicRcd.Magic.btDefPower := SpinEditDefPower.Value;
    MagicRcd.Magic.btDefMaxPower := SpinEditDefMaxPower.Value;
    MagicRcd.Magic.btJob := SpinEditJob.Value;
    MagicRcd.Magic.btTrainLv := 3;
    MagicRcd.Magic.TrainLevel[0] := SpinEditNeedL1.Value;
    MagicRcd.Magic.MaxTrain[0] := SpinEditL1Train.Value;
    MagicRcd.Magic.TrainLevel[1] := SpinEditNeedL2.Value;
    MagicRcd.Magic.MaxTrain[1] := SpinEditL2Train.Value;
    MagicRcd.Magic.TrainLevel[2] := SpinEditNeedL3.Value;
    MagicRcd.Magic.MaxTrain[2] := SpinEditL3Train.Value;
    MagicRcd.Magic.TrainLevel[3] := SpinEditNeedL3.Value;
    MagicRcd.Magic.MaxTrain[3] := MagicRcd.Magic.MaxTrain[2];
    MagicRcd.Magic.dwDelayTime := SpinEditDelay.Value;
    MagicRcd.Magic.sDescr := EditDescr.Text;
    ListViewMagic.Items.BeginUpdate;
    try
      ListItem := ListViewMagic.Selected;
      ListItem.Caption := IntToStr(SpinEditMagID.Value);
      ListItem.SubItems.Strings[0] := sMagName;
      ListItem.SubItems.Objects[0] := TObject(@MagicRcd.MagicConfig);
      ListItem.SubItems.Strings[1] := IntToStr(SpinEditEffectType.Value);
      ListItem.SubItems.Strings[2] := IntToStr(SpinEditEffect.Value);
      ListItem.SubItems.Strings[3] := IntToStr(SpinEditSpell.Value);
      ListItem.SubItems.Strings[4] := IntToStr(SpinEditPower.Value);
      ListItem.SubItems.Strings[5] := IntToStr(SpinEditMaxPower.Value);
      ListItem.SubItems.Strings[6] := IntToStr(SpinEditDefSpell.Value);
      ListItem.SubItems.Strings[7] := IntToStr(SpinEditDefPower.Value);
      ListItem.SubItems.Strings[8] := IntToStr(SpinEditDefMaxPower.Value);
      ListItem.SubItems.Strings[9] := IntToStr(SpinEditJob.Value);
      ListItem.SubItems.Strings[10] := IntToStr(SpinEditNeedL1.Value);
      ListItem.SubItems.Strings[11] := IntToStr(SpinEditL1Train.Value);
      ListItem.SubItems.Strings[12] := IntToStr(SpinEditNeedL2.Value);
      ListItem.SubItems.Strings[13] := IntToStr(SpinEditL2Train.Value);
      ListItem.SubItems.Strings[14] := IntToStr(SpinEditNeedL3.Value);
      ListItem.SubItems.Strings[15] := IntToStr(SpinEditL3Train.Value);
      ListItem.SubItems.Strings[16] := IntToStr(SpinEditDelay.Value);
      if ListItem.SubItems.Count > 16 then
        ListItem.SubItems.Strings[17] := EditDescr.Text
      else if Trim(EditDescr.Text) <> '' then
        ListItem.SubItems.Add(EditDescr.Text)
    finally
      ListViewMagic.Items.EndUpdate;
    end;
  end;
end;

procedure TFrmMagicManage.ButtonDelMagicClick(Sender: TObject);
var
  MagicConfig: pTMagicConfig;
  ListItem: TListItem;
  nMagicID: Integer;
  nItemIndex: Integer;
  MagicRcd: pTMagicRcd;
begin
  try
    ListItem := ListViewMagic.Selected;
    nItemIndex := ListViewMagic.ItemIndex;
    MagicRcd := pTMagicRcd(g_MagicList.Items[nItemIndex]);
    Dispose(MagicRcd);
    g_MagicList.Delete(nItemIndex);
    MagicConfig := pTMagicConfig(ListItem.SubItems.Objects[0]);
    nMagicID := Str_ToInt(ListItem.Caption, 100);
    DelData(nMagicID);
    ListViewMagic.DeleteSelected;
  except
  end;
end;

procedure TFrmMagicManage.ButtonSaveMagicClick(Sender: TObject);
var
  I: Integer;
  MagicRcd: pTMagicRcd;
begin
  try
    ButtonSaveMagic.Enabled := False;
    for I := 0 to g_MagicList.Count - 1 do begin
      MagicRcd := pTMagicRcd(g_MagicList.Items[I]);
      UpData(MagicRcd^);
    end;
    {FillChar(MagicRcd.RecordHeader, SizeOf(TRecordHeader), #0);
    FillChar(MagicRcd, SizeOf(TMagicRcd), #0);
    FillChar(MagicRcd.Magic, SizeOf(_TMAGIC), #0);
    for I := 0 to ListViewMagic.Items.Count - 1 do begin
      ListItem := ListViewMagic.Items.Item[I];
      MagicConfig := pTMagicConfig(ListItem.SubItems.Objects[0]);
      MagicRcd.RecordHeader.boDeleted := False;
      MagicRcd.RecordHeader.dCreateDate := Now;
      MagicRcd.MagicConfig := MagicConfig^;
      MagicRcd.Magic.wMagicId := Str_ToInt(ListItem.Caption, 100);
      MagicRcd.Magic.sMagicName := ListItem.SubItems.Strings[0];
      MagicRcd.Magic.btEffectType := Str_ToInt(ListItem.SubItems.Strings[1], 0);
      MagicRcd.Magic.btEffect := Str_ToInt(ListItem.SubItems.Strings[2], 0);
      MagicRcd.Magic.wSpell := Str_ToInt(ListItem.SubItems.Strings[3], 0);
      MagicRcd.Magic.wPower := Str_ToInt(ListItem.SubItems.Strings[4], 0);
      MagicRcd.Magic.wMaxPower := Str_ToInt(ListItem.SubItems.Strings[5], 0);
      MagicRcd.Magic.btDefSpell := Str_ToInt(ListItem.SubItems.Strings[6], 0);
      MagicRcd.Magic.btDefPower := Str_ToInt(ListItem.SubItems.Strings[7], 0);
      MagicRcd.Magic.btDefMaxPower := Str_ToInt(ListItem.SubItems.Strings[8], 0);
      MagicRcd.Magic.btJob := Str_ToInt(ListItem.SubItems.Strings[9], 0);
      MagicRcd.Magic.TrainLevel[0] := Str_ToInt(ListItem.SubItems.Strings[10], 0);
      MagicRcd.Magic.MaxTrain[0] := Str_ToInt(ListItem.SubItems.Strings[11], 0);
      MagicRcd.Magic.TrainLevel[1] := Str_ToInt(ListItem.SubItems.Strings[12], 0);
      MagicRcd.Magic.MaxTrain[1] := Str_ToInt(ListItem.SubItems.Strings[13], 0);
      MagicRcd.Magic.TrainLevel[2] := Str_ToInt(ListItem.SubItems.Strings[14], 0);
      MagicRcd.Magic.MaxTrain[2] := Str_ToInt(ListItem.SubItems.Strings[15], 0);
      MagicRcd.Magic.dwDelayTime := abs(Str_ToInt(ListItem.SubItems.Strings[16], 0));
      if ListItem.SubItems.Count > 17 then
        MagicRcd.Magic.sDescr := ListItem.SubItems.Strings[17]
      else MagicRcd.Magic.sDescr := '';
      UpData(MagicRcd);
    end;  }
    Application.MessageBox('保存完成！！！', '提示信息', MB_ICONQUESTION);
  except
    Application.MessageBox('保存失败！！！', '提示信息', MB_ICONQUESTION);
  end;
  ButtonSaveMagic.Enabled := True;
end;

procedure TFrmMagicManage.DisposeListViewMagic();
var
  MagicConfig: pTMagicConfig;
  ListItem: TListItem;
  I: Integer;
begin
  try
    for I := 0 to ListViewMagic.Items.Count - 1 do begin
      ListItem := ListViewMagic.Items.Item[I];
      MagicConfig := pTMagicConfig(ListItem.SubItems.Objects[0]);
      if MagicConfig <> nil then
        Dispose(MagicConfig);
    end;
  finally
    ListViewMagic.Items.EndUpdate;
  end;
end;

procedure TFrmMagicManage.ButtonLoadMagicClick(Sender: TObject);
begin
  ButtonLoadMagic.Enabled := False;
  ListViewMagic.Items.Clear;
  LoadMagicList();
  LoadMagicListToEngine();
  RefMagicList();
  Application.MessageBox('重新加载完成！！！', '提示信息', MB_ICONQUESTION);
  ButtonLoadMagic.Enabled := True;
end;

procedure TFrmMagicManage.ListBoxMagicClick(Sender: TObject);
var
  Magic: _LPTMAGIC;
begin
  Magic := _LPTMAGIC(ListBoxMagic.Items.Objects[ListBoxMagic.ItemIndex]);
  nSelMagicID := Magic.wMagicId;
  LabelSelMagicName.Caption := '名称：' + Magic.sMagicName + #13 + 'ID：' + IntToStr(nSelMagicID);
end;

function TFrmMagicManage.GetMagicOfID(nMagicID: Integer): Integer;
var
  Magic: _LPTMAGIC;
  I: Integer;
begin
  Result := -1;
  for I := 0 to ListBoxMagic.Items.Count - 1 do begin
    Magic := _LPTMAGIC(ListBoxMagic.Items.Objects[I]);
    if Magic.wMagicId = nMagicID then begin
      Result := I;
      Break;
    end;
  end;
end;

procedure TFrmMagicManage.ListViewMagicClick(Sender: TObject);
var
  MagicConfig: pTMagicConfig;
  ListItem: TListItem;
  nMagicID: Integer;
  nItemIndex: Integer;
begin
  try
    ListItem := ListViewMagic.Selected;
    MagicConfig := pTMagicConfig(ListItem.SubItems.Objects[0]);
    nSelMagicID := MagicConfig.nSelMagicID;
    SpinEditMagicCount.Value := MagicConfig.nMagicCount;
    RadioGroupAttackRange.ItemIndex := MagicConfig.nAttackRange;
    RadioGroupWay.ItemIndex := MagicConfig.nAttackWay;
    RadioGroupMagicNeed.ItemIndex := MagicConfig.nNeed;
    CheckBoxHP.Checked := MagicConfig.boHP;
    CheckBoxMP.Checked := MagicConfig.boMP;
    CheckBoxAC.Checked := MagicConfig.boAC;
    CheckBoxMC.Checked := MagicConfig.boMC;
    CheckBoxAbil.Checked := MagicConfig.boAbil;
    SpinEditMagID.Value := Str_ToInt(ListItem.Caption, 100);
    EditMagName.Text := ListItem.SubItems.Strings[0];
    SpinEditEffectType.Value := Str_ToInt(ListItem.SubItems.Strings[1], 0);
    SpinEditEffect.Value := Str_ToInt(ListItem.SubItems.Strings[2], 0);
    SpinEditSpell.Value := Str_ToInt(ListItem.SubItems.Strings[3], 0);
    SpinEditPower.Value := Str_ToInt(ListItem.SubItems.Strings[4], 0);
    SpinEditMaxPower.Value := Str_ToInt(ListItem.SubItems.Strings[5], 0);
    SpinEditDefSpell.Value := Str_ToInt(ListItem.SubItems.Strings[6], 0);
    SpinEditDefPower.Value := Str_ToInt(ListItem.SubItems.Strings[7], 0);
    SpinEditDefMaxPower.Value := Str_ToInt(ListItem.SubItems.Strings[8], 0);
    SpinEditJob.Value := Str_ToInt(ListItem.SubItems.Strings[9], 0);
    SpinEditNeedL1.Value := Str_ToInt(ListItem.SubItems.Strings[10], 0);
    SpinEditL1Train.Value := Str_ToInt(ListItem.SubItems.Strings[11], 0);
    SpinEditNeedL2.Value := Str_ToInt(ListItem.SubItems.Strings[12], 0);
    SpinEditL2Train.Value := Str_ToInt(ListItem.SubItems.Strings[13], 0);
    SpinEditNeedL3.Value := Str_ToInt(ListItem.SubItems.Strings[14], 0);
    SpinEditL3Train.Value := Str_ToInt(ListItem.SubItems.Strings[15], 0);
    SpinEditDelay.Value := Str_ToInt(ListItem.SubItems.Strings[16], 0);
    if ListItem.SubItems.Count > 17 then
      EditDescr.Text := ListItem.SubItems.Strings[17]
    else EditDescr.Text := '';
    nItemIndex := GetMagicOfID(nSelMagicID);
    if nItemIndex >= 0 then begin
      ListBoxMagic.ItemIndex := nItemIndex;
      ListBoxMagicClick(Self);
    end;
  except

  end;
end;

procedure TFrmMagicManage.RadioGroupWayClick(Sender: TObject);
begin
  case RadioGroupWay.ItemIndex of
    0: ;
    1: ;
    2: ;
    3: ;
    4: ;
    5: begin

      end;
    6: ;
    7: ;
  end;
end;

end.


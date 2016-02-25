unit EditRcd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grobal2, ComCtrls, StdCtrls, Spin, HumDB, DBShare;

type
  TfrmEditRcd = class(TForm)
    PageControl: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    EditChrName: TEdit;
    Label2: TLabel;
    EditAccount: TEdit;
    Label3: TLabel;
    EditPassword: TEdit;
    Label4: TLabel;
    EditDearName: TEdit;
    Label5: TLabel;
    EditMasterName: TEdit;
    GroupBox2: TGroupBox;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label11: TLabel;
    EditIdx: TEdit;
    Label12: TLabel;
    EditCurMap: TEdit;
    Label13: TLabel;
    EditCurX: TSpinEdit;
    EditCurY: TSpinEdit;
    Label14: TLabel;
    Label15: TLabel;
    EditHomeMap: TEdit;
    EditHomeX: TSpinEdit;
    EditHomeY: TSpinEdit;
    EditLevel: TSpinEdit;
    EditGold: TSpinEdit;
    EditGameGold: TSpinEdit;
    EditGamePoint: TSpinEdit;
    Label16: TLabel;
    EditCreditPoint: TSpinEdit;
    Label10: TLabel;
    EditPayPoint: TSpinEdit;
    Label17: TLabel;
    EditPKPoint: TSpinEdit;
    Label18: TLabel;
    EditContribution: TSpinEdit;
    GroupBox3: TGroupBox;
    ListViewMagic: TListView;
    GroupBox4: TGroupBox;
    ListViewUserItem: TListView;
    GroupBox5: TGroupBox;
    ListViewStorage: TListView;
    ButtonSaveData: TButton;
    ButtonExportData: TButton;
    ButtonImportData: TButton;
    SaveDialog: TSaveDialog;
    OpenDialog: TOpenDialog;
    CheckBoxIsMaster: TCheckBox;
    Label19: TLabel;
    Label20: TLabel;
    EditExpRate: TSpinEdit;
    EditExpTime: TSpinEdit;
    Label21: TLabel;
    EditBonusPoint: TSpinEdit;
    GroupBox6: TGroupBox;
    Label22: TLabel;
    EditDC: TSpinEdit;
    Label23: TLabel;
    EditMC: TSpinEdit;
    Label24: TLabel;
    EditSC: TSpinEdit;
    Label25: TLabel;
    Label26: TLabel;
    EditAC: TSpinEdit;
    EditMAC: TSpinEdit;
    Label27: TLabel;
    EditHP: TSpinEdit;
    Label28: TLabel;
    EditMP: TSpinEdit;
    EditHit: TSpinEdit;
    EditSpeed: TSpinEdit;
    EditX2: TSpinEdit;
    Label29: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    procedure ButtonExportDataClick(Sender: TObject);
    procedure EditPasswordChange(Sender: TObject);
  private
    m_boOpened: Boolean;
    procedure RefShow();
    procedure RefShowRcd();
    procedure RefShowMagic();
    procedure RefShowUserItem();
    procedure RefShowStorage();
    procedure ProcessSaveRcdToFile();
    procedure ProcessLoadRcdformFile();
    procedure ProcessSaveRcd();
    { Private declarations }
  public
    m_ChrRcd: THumDataInfo;
    m_nIdx: Integer;
    procedure Open();
    { Public declarations }
  end;

var
  frmEditRcd: TfrmEditRcd;

implementation

{$R *.dfm}

{ TfrmEditRcd }


procedure TfrmEditRcd.RefShowRcd;
begin
  EditIdx.Text := IntToStr(m_nIdx);
  EditChrName.Text := m_ChrRcd.Data.sChrName;
  EditAccount.Text := m_ChrRcd.Data.sAccount;
  EditPassword.Text := m_ChrRcd.Data.sStoragePwd;
  EditDearName.Text := m_ChrRcd.Data.sDearName;
  EditMasterName.Text := m_ChrRcd.Data.sMasterName;
  CheckBoxIsMaster.Checked := m_ChrRcd.Data.boMaster;

  EditCurMap.Text := m_ChrRcd.Data.sCurMap;
  EditCurX.Value := m_ChrRcd.Data.wCurX;
  EditCurY.Value := m_ChrRcd.Data.wCurY;

  EditHomeMap.Text := m_ChrRcd.Data.sHomeMap;
  EditHomeX.Value := m_ChrRcd.Data.wHomeX;
  EditHomeY.Value := m_ChrRcd.Data.wHomeY;

  EditLevel.Value := m_ChrRcd.Data.Abil.Level;
  EditGold.Value := m_ChrRcd.Data.nGold;
  EditGameGold.Value := m_ChrRcd.Data.nGameGold;
  EditGamePoint.Value := m_ChrRcd.Data.nGamePoint;
  EditPayPoint.Value := m_ChrRcd.Data.nPayMentPoint;
  EditCreditPoint.Value := m_ChrRcd.Data.btCreditPoint;
  EditPKPoint.Value := m_ChrRcd.Data.nPKPoint;
  EditContribution.Value := m_ChrRcd.Data.wContribution;

  EditExpRate.Value := m_ChrRcd.Data.nExpRate;
  EditExpTime.Value := m_ChrRcd.Data.nExpTime;
  EditBonusPoint.Value := m_ChrRcd.Data.nBonusPoint;

  EditDC.Value := m_ChrRcd.Data.BonusAbil.DC;
  EditMC.Value := m_ChrRcd.Data.BonusAbil.MC;
  EditSC.Value := m_ChrRcd.Data.BonusAbil.SC;
  EditAC.Value := m_ChrRcd.Data.BonusAbil.AC;
  EditMAC.Value := m_ChrRcd.Data.BonusAbil.MAC;
  EditHP.Value := m_ChrRcd.Data.BonusAbil.HP;
  EditMP.Value := m_ChrRcd.Data.BonusAbil.MP;
  EditHit.Value := m_ChrRcd.Data.BonusAbil.Hit;
  EditSpeed.Value := m_ChrRcd.Data.BonusAbil.Speed;
  EditX2.Value := m_ChrRcd.Data.BonusAbil.X2;
end;

procedure TfrmEditRcd.Open;
begin
  RefShow();
  Caption := format('编辑人物数据 [%s]', [m_ChrRcd.Data.sChrName]);
  PageControl.ActivePageIndex := 0;
  ShowModal;
end;

procedure TfrmEditRcd.RefShow;
begin
  m_boOpened := False;
  RefShowRcd();
  RefShowMagic();
  RefShowUserItem();
  RefShowStorage();
  m_boOpened := True;
end;

procedure TfrmEditRcd.RefShowMagic;
var
  i: Integer;
  ListItem: TListItem;
  MagicInfo: THumMagic;
begin
  ListViewMagic.Clear;
  for i := Low(m_ChrRcd.Data.HumMagics) to High(m_ChrRcd.Data.HumMagics) do begin
    MagicInfo := m_ChrRcd.Data.HumMagics[i];
    if MagicInfo.wMagIdx = 0 then break;

    ListItem := ListViewMagic.Items.Add;
    ListItem.Caption := IntToStr(i);
    ListItem.SubItems.Add(IntToStr(MagicInfo.wMagIdx));
    ListItem.SubItems.Add(GetMagicName(MagicInfo.wMagIdx));
    ListItem.SubItems.Add(IntToStr(MagicInfo.btLevel));
    ListItem.SubItems.Add(IntToStr(MagicInfo.nTranPoint));
    ListItem.SubItems.Add(IntToStr(MagicInfo.btKey));
  end;
end;

procedure TfrmEditRcd.RefShowUserItem;
var
  i: Integer;
  ListItem: TListItem;
  UserItem: TUserItem;
resourcestring
  sItemValue = '%d-%d-%d-%d-%d-%d-%d-%d-%d-%d-%d-%d-%d-%d';
  //'%d/%d/%d/%d/%d/%d/%d/%d/%d/%d/%d/%d/%d/%d'
begin
  ListViewUserItem.Clear;

  for i := Low(m_ChrRcd.Data.HumItems) to High(m_ChrRcd.Data.HumItems) do begin
    UserItem := m_ChrRcd.Data.HumItems[i];
    ListItem := ListViewUserItem.Items.Add;
    ListItem.Caption := IntToStr(i);
    ListItem.SubItems.Add(IntToStr(UserItem.MakeIndex));
    ListItem.SubItems.Add(IntToStr(UserItem.wIndex));
    ListItem.SubItems.Add(GetStdItemName(UserItem.wIndex)); ;
    ListItem.SubItems.Add(format('%d/%d', [UserItem.Dura, UserItem.DuraMax]));

    ListItem.SubItems.Add(format(sItemValue, [
      UserItem.btValue[0],
        UserItem.btValue[1],
        UserItem.btValue[2],
        UserItem.btValue[3],
        UserItem.btValue[4],
        UserItem.btValue[5],
        UserItem.btValue[6],
        UserItem.btValue[7],
        UserItem.btValue[8],
        UserItem.btValue[9],
        UserItem.btValue[10],
        UserItem.btValue[11],
        UserItem.btValue[12],
        UserItem.btValue[13]
        ]));

  end;

  for i := Low(m_ChrRcd.Data.HumAddItems) to High(m_ChrRcd.Data.HumAddItems) do begin
    UserItem := m_ChrRcd.Data.HumAddItems[i];
    ListItem := ListViewUserItem.Items.Add;
    ListItem.Caption := IntToStr(i);
    ListItem.SubItems.Add(IntToStr(UserItem.MakeIndex));
    ListItem.SubItems.Add(IntToStr(UserItem.wIndex));
    ListItem.SubItems.Add(GetStdItemName(UserItem.wIndex)); ;
    ListItem.SubItems.Add(format('%d/%d', [UserItem.Dura, UserItem.DuraMax]));
    ListItem.SubItems.Add(format(sItemValue, [
      UserItem.btValue[0],
        UserItem.btValue[1],
        UserItem.btValue[2],
        UserItem.btValue[3],
        UserItem.btValue[4],
        UserItem.btValue[5],
        UserItem.btValue[6],
        UserItem.btValue[7],
        UserItem.btValue[8],
        UserItem.btValue[9],
        UserItem.btValue[10],
        UserItem.btValue[11],
        UserItem.btValue[12],
        UserItem.btValue[13]
        ]));
  end;
end;

procedure TfrmEditRcd.RefShowStorage;
var
  i: Integer;
  ListItem: TListItem;
  UserItem: TUserItem;
begin
  ListViewStorage.Clear;

  for i := Low(m_ChrRcd.Data.StorageItems) to High(m_ChrRcd.Data.StorageItems) do begin
    UserItem := m_ChrRcd.Data.StorageItems[i];
    if UserItem.wIndex = 0 then Continue;
    ListItem := ListViewStorage.Items.Add;
    ListItem.Caption := IntToStr(i);
    ListItem.SubItems.Add(IntToStr(UserItem.MakeIndex));
    ListItem.SubItems.Add(IntToStr(UserItem.wIndex));
    ListItem.SubItems.Add(GetStdItemName(UserItem.wIndex)); ;
    ListItem.SubItems.Add(format('%d/%d', [UserItem.Dura, UserItem.DuraMax]));
    ListItem.SubItems.Add(format('%d/%d/%d/%d/%d/%d/%d/%d/%d/%d/%d/%d/%d/%d', [
      UserItem.btValue[0],
        UserItem.btValue[1],
        UserItem.btValue[2],
        UserItem.btValue[3],
        UserItem.btValue[4],
        UserItem.btValue[5],
        UserItem.btValue[6],
        UserItem.btValue[7],
        UserItem.btValue[8],
        UserItem.btValue[9],
        UserItem.btValue[10],
        UserItem.btValue[11],
        UserItem.btValue[12],
        UserItem.btValue[13]
        ]));

  end;
end;

procedure TfrmEditRcd.ButtonExportDataClick(Sender: TObject);
begin
  if Sender = ButtonExportData then begin
    ProcessSaveRcdToFile();
  end else
    if Sender = ButtonImportData then begin
    ProcessLoadRcdformFile();
  end else
    if Sender = ButtonSaveData then begin
    ProcessSaveRcd();
  end;
end;

procedure TfrmEditRcd.ProcessSaveRcdToFile;
var
  sSaveFileName: string;
  nFileHandle: Integer;
begin
  SaveDialog.FileName := m_ChrRcd.Data.sChrName;
  SaveDialog.InitialDir := '.\';
  if not SaveDialog.Execute then Exit;
  sSaveFileName := SaveDialog.FileName;
  if FileExists(sSaveFileName) then
    nFileHandle := FileOpen(sSaveFileName, fmOpenReadWrite or fmShareDenyNone)
  else nFileHandle := FileCreate(sSaveFileName);
  if nFileHandle <= 0 then begin
    MessageBox(Handle, '保存文件出现错误！！！', '错误信息', MB_OK + MB_ICONEXCLAMATION);
    Exit;
  end;
  FileWrite(nFileHandle, m_ChrRcd, SizeOf(THumDataInfo));
  FileClose(nFileHandle);
  MessageBox(Handle, '人物数据导出成功！！！', '提示信息', MB_OK + MB_ICONINFORMATION);
end;

procedure TfrmEditRcd.ProcessLoadRcdformFile;
var
  sLoadFileName: string;
  nFileHandle: Integer;
  ChrRcd: THumDataInfo;
begin
  OpenDialog.FileName := m_ChrRcd.Data.sChrName;
  OpenDialog.InitialDir := '.\';
  if not OpenDialog.Execute then Exit;
  sLoadFileName := OpenDialog.FileName;

  if not FileExists(sLoadFileName) then begin
    MessageBox(Handle, '指定的文件未找到！！！', '错误信息', MB_OK + MB_ICONEXCLAMATION);
    Exit;
  end;
  nFileHandle := FileOpen(sLoadFileName, fmOpenReadWrite or fmShareDenyNone);

  if nFileHandle <= 0 then begin
    MessageBox(Handle, '打开文件出现错误！！！', '错误信息', MB_OK + MB_ICONEXCLAMATION);
    Exit;
  end;
  if not FileRead(nFileHandle, ChrRcd, SizeOf(THumDataInfo)) = SizeOf(THumDataInfo) then begin
    MessageBox(Handle, '读取文件出现错误！！！'#13#13'文件格式可能不正确', '错误信息', MB_OK + MB_ICONEXCLAMATION);
    Exit;
  end;
  ChrRcd.Header := m_ChrRcd.Header;
  ChrRcd.Data.sChrName := m_ChrRcd.Data.sChrName;
  ChrRcd.Data.sAccount := m_ChrRcd.Data.sAccount;
  m_ChrRcd := ChrRcd;
  FileClose(nFileHandle);
  RefShow();
  MessageBox(Handle, '人物数据导入成功！！！', '提示信息', MB_OK + MB_ICONINFORMATION);
end;

procedure TfrmEditRcd.ProcessSaveRcd;
var
  nIdx: Integer;
  boSaveOK: Boolean;
begin
  boSaveOK := False;
  try
    if HumDataDB.Open then begin
      nIdx := HumDataDB.Index(m_ChrRcd.Header.sName);
      if (nIdx >= 0) then begin
        HumDataDB.Update(nIdx, m_ChrRcd);
        boSaveOK := True;
      end;
    end;
  finally
    HumDataDB.Close;
  end;
  if boSaveOK then begin
    MessageBox(Handle, '人物数据保存成功！！！', '提示信息', MB_OK + MB_ICONINFORMATION);
  end else begin
    MessageBox(Handle, '人物数据保存失败！！！', '错误信息', MB_OK + MB_ICONEXCLAMATION);
  end;
end;

procedure TfrmEditRcd.EditPasswordChange(Sender: TObject);
begin
  if not m_boOpened then Exit;
  if Sender = EditPassword then begin
    m_ChrRcd.Data.sStoragePwd := Trim(EditPassword.Text);
  end else
    if Sender = EditDearName then begin
    m_ChrRcd.Data.sDearName := Trim(EditDearName.Text);
  end else
    if Sender = EditMasterName then begin
    m_ChrRcd.Data.sMasterName := Trim(EditMasterName.Text);
  end else
    if Sender = CheckBoxIsMaster then begin
    m_ChrRcd.Data.boMaster := CheckBoxIsMaster.Checked;
  end else
    if Sender = EditCurMap then begin
    m_ChrRcd.Data.sCurMap := Trim(EditCurMap.Text);
  end else
    if Sender = EditCurX then begin
    m_ChrRcd.Data.wCurX := EditCurX.Value;
  end else
    if Sender = EditCurY then begin
    m_ChrRcd.Data.wCurY := EditCurY.Value;
  end else
    if Sender = EditHomeMap then begin
    m_ChrRcd.Data.sHomeMap := Trim(EditHomeMap.Text);
  end else
    if Sender = EditHomeX then begin
    m_ChrRcd.Data.wHomeX := EditHomeX.Value;
  end else
    if Sender = EditCurY then begin
    m_ChrRcd.Data.wHomeY := EditHomeY.Value;
  end else
    if Sender = EditLevel then begin
    m_ChrRcd.Data.Abil.Level := EditLevel.Value;
  end else
    if Sender = EditGold then begin
    m_ChrRcd.Data.nGold := EditGold.Value;
  end else
    if Sender = EditGameGold then begin
    m_ChrRcd.Data.nGameGold := EditGameGold.Value;
  end else
    if Sender = EditGamePoint then begin
    m_ChrRcd.Data.nGamePoint := EditGamePoint.Value;
  end else
    if Sender = EditPayPoint then begin
    m_ChrRcd.Data.nPayMentPoint := EditPayPoint.Value;
  end else
    if Sender = EditCreditPoint then begin
    m_ChrRcd.Data.btCreditPoint := EditCreditPoint.Value;
  end else
    if Sender = EditPKPoint then begin
    m_ChrRcd.Data.nPKPoint := EditPKPoint.Value;
  end else
    if Sender = EditContribution then begin
    m_ChrRcd.Data.wContribution := EditContribution.Value;
  end else
    if Sender = EditExpRate then begin
    m_ChrRcd.Data.nExpRate := EditExpRate.Value;
  end else
    if Sender = EditExpTime then begin
    m_ChrRcd.Data.nExpTime := EditExpTime.Value;
  end else
    if Sender = EditBonusPoint then begin
    m_ChrRcd.Data.nBonusPoint := EditBonusPoint.Value;
  end;
end;

end.

unit AttackSabukWallConfig;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, RzEdit, CastleManage, Castle, Guild;

type
  TFrmAttackSabukWall = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    EditGuildName: TEdit;
    RzDateTimeEditAttackDate: TRzDateTimeEdit;
    ButtonOK: TButton;
    ListBoxGuild: TListBox;
    CheckBoxAll: TCheckBox;
    procedure ButtonOKClick(Sender: TObject);
    procedure ListBoxGuildClick(Sender: TObject);
    procedure CheckBoxAllClick(Sender: TObject);
  private
    { Private declarations }
    procedure LoadGuildList();
  public
    { Public declarations }
    procedure Open();
  end;

var
  FrmAttackSabukWall: TFrmAttackSabukWall;
  nStute: Integer;
  m_sGuildName: string;
  m_AttackDate: TDate;
implementation
uses M2Share;
{$R *.dfm}
procedure TFrmAttackSabukWall.LoadGuildList();
var
  i: Integer;
  Guild: TGuild;
begin
  ListBoxGuild.Items.Clear;
  for i := 0 to g_GuildManager.GuildList.Count - 1 do begin
    Guild := TGuild(g_GuildManager.GuildList.Items[i]);
    ListBoxGuild.Items.AddObject(Guild.sGuildName, TObject(Guild));
  end;
end;

procedure TFrmAttackSabukWall.Open();
begin
  case nStute of
    0: begin
        EditGuildName.Text := '';
        RzDateTimeEditAttackDate.Date := Date;
      end;
    1: begin
        EditGuildName.Text := m_sGuildName;
        RzDateTimeEditAttackDate.Date := m_AttackDate;
      end;
  end;
  LoadGuildList();
  ShowModal;
end;

procedure TFrmAttackSabukWall.ButtonOKClick(Sender: TObject);
var
  sGuildName: string;
  AttackDate: TDate;
  i: Integer;
begin
  ButtonOK.Enabled := False;
  sGuildName := Trim(EditGuildName.Text);
  AttackDate := RzDateTimeEditAttackDate.Date;
  case nStute of
    0: begin
        if CheckBoxAll.Checked then begin
          if CurCastle = nil then Exit;
          {nCount := -1;
          frmCastleManage.ListViewAttackSabukWall.Items.Clear;
          for i := 0 to CurCastle.m_AttackWarList.Count - 1 do begin
            DisPose(pTAttackerInfo(CurCastle.m_AttackWarList.Items[i]));
          end;
          CurCastle.m_AttackWarList.Clear;}
          for i := 0 to ListBoxGuild.Items.Count - 1 do begin
            if not frmCastleManage.IsAttackSabukWallOfGuild(ListBoxGuild.Items.Strings[i], AttackDate) then
              frmCastleManage.AddAttackSabukWallOfGuild(ListBoxGuild.Items.Strings[i], AttackDate);
          end;
        end else begin
          if not frmCastleManage.IsAttackSabukWallOfGuild(sGuildName, AttackDate) then
            if not frmCastleManage.AddAttackSabukWallOfGuild(sGuildName, AttackDate) then Exit;
        end;
      end;
    1: begin
        if CheckBoxAll.Checked then begin
          if CurCastle = nil then Exit;
          {nCount := -1;
          frmCastleManage.ListViewAttackSabukWall.Items.Clear;
          for i := 0 to CurCastle.m_AttackWarList.Count - 1 do begin
            DisPose(pTAttackerInfo(CurCastle.m_AttackWarList.Items[i]));
          end;
          CurCastle.m_AttackWarList.Clear; }
          for i := 0 to ListBoxGuild.Items.Count - 1 do begin
            if not frmCastleManage.IsAttackSabukWallOfGuild(ListBoxGuild.Items.Strings[i], AttackDate) then
              frmCastleManage.AddAttackSabukWallOfGuild(ListBoxGuild.Items.Strings[i], AttackDate);
          end;
        end else begin
          if not frmCastleManage.ChgAttackSabukWallOfGuild(sGuildName, AttackDate) then Exit;
        end;
      end;
  end;
  Close;
end;

procedure TFrmAttackSabukWall.ListBoxGuildClick(Sender: TObject);
begin
  try
    EditGuildName.Text := ListBoxGuild.Items.Strings[ListBoxGuild.ItemIndex];
  except
  end;
end;

procedure TFrmAttackSabukWall.CheckBoxAllClick(Sender: TObject);
begin
  EditGuildName.Enabled := not CheckBoxAll.Checked;
end;

end.


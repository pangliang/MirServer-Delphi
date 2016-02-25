unit GameSpeed;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Spin, GateShare, ExtCtrls;

type
  TFrmGameSpeed = class(TForm)
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label6: TLabel;
    EditHitIntervalTime: TSpinEdit;
    EditMagicHitIntervalTime: TSpinEdit;
    EditRunIntervalTime: TSpinEdit;
    EditWalkIntervalTime: TSpinEdit;
    EditTurnIntervalTime: TSpinEdit;
    GroupBox3: TGroupBox;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label12: TLabel;
    EditMaxHitMsgCount: TSpinEdit;
    EditMaxSpellMsgCount: TSpinEdit;
    EditMaxRunMsgCount: TSpinEdit;
    EditMaxWalkMsgCount: TSpinEdit;
    EditMaxTurnMsgCount: TSpinEdit;
    GroupBox15: TGroupBox;
    CheckBoxSpell: TCheckBox;
    CheckBoxHit: TCheckBox;
    GroupBox4: TGroupBox;
    RadioButtonDelyMode: TRadioButton;
    RadioButtonFilterMode: TRadioButton;
    CheckBoxSpeedShowMsg: TCheckBox;
    EditSpeedMsg: TEdit;
    CheckBoxRun: TCheckBox;
    CheckBoxWalk: TCheckBox;
    CheckBoxTurn: TCheckBox;
    ButtonRef: TButton;
    ButtonSave: TButton;
    ButtonClose: TButton;
    RadioGroupMsgColor: TRadioGroup;
    procedure CheckBoxHitClick(Sender: TObject);
    procedure CheckBoxSpellClick(Sender: TObject);
    procedure CheckBoxRunClick(Sender: TObject);
    procedure CheckBoxWalkClick(Sender: TObject);
    procedure CheckBoxTurnClick(Sender: TObject);
    procedure CheckBoxSpeedShowMsgClick(Sender: TObject);
    procedure EditSpeedMsgChange(Sender: TObject);
    procedure RadioButtonDelyModeClick(Sender: TObject);
    procedure EditHitIntervalTimeChange(Sender: TObject);
    procedure EditMagicHitIntervalTimeChange(Sender: TObject);
    procedure EditRunIntervalTimeChange(Sender: TObject);
    procedure EditWalkIntervalTimeChange(Sender: TObject);
    procedure EditTurnIntervalTimeChange(Sender: TObject);
    procedure EditMaxHitMsgCountChange(Sender: TObject);
    procedure EditMaxSpellMsgCountChange(Sender: TObject);
    procedure EditMaxRunMsgCountChange(Sender: TObject);
    procedure EditMaxWalkMsgCountChange(Sender: TObject);
    procedure EditMaxTurnMsgCountChange(Sender: TObject);
    procedure ButtonCloseClick(Sender: TObject);
    procedure ButtonSaveClick(Sender: TObject);
    procedure RadioGroupMsgColorClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Open();
  end;

var
  FrmGameSpeed: TFrmGameSpeed;

implementation

{$R *.dfm}
procedure TFrmGameSpeed.Open();
begin
  CheckBoxHit.Checked := g_Config.boHit;
  CheckBoxSpell.Checked := g_Config.boSpell;
  CheckBoxRun.Checked := g_Config.boRun;
  CheckBoxWalk.Checked := g_Config.boWalk;
  CheckBoxTurn.Checked := g_Config.boTurn;

  EditHitIntervalTime.Value := g_Config.nHitTime;
  EditMagicHitIntervalTime.Value := g_Config.nSpellTime;
  EditRunIntervalTime.Value := g_Config.nRunTime;
  EditWalkIntervalTime.Value := g_Config.nWalkTime;
  EditTurnIntervalTime.Value := g_Config.nTurnTime;

  EditMaxHitMsgCount.Value := g_Config.nHitCount;
  EditMaxSpellMsgCount.Value := g_Config.nSpellCount;
  EditMaxRunMsgCount.Value := g_Config.nRunCount;
  EditMaxWalkMsgCount.Value := g_Config.nWalkCount;
  EditMaxTurnMsgCount.Value := g_Config.nTurnCount;

  if g_Config.btSpeedControlMode = 0 then begin
    RadioButtonDelyMode.Checked := True;
    RadioButtonFilterMode.Checked := False;
  end else begin
    RadioButtonDelyMode.Checked := False;
    RadioButtonFilterMode.Checked := True;
  end;
  CheckBoxSpeedShowMsg.Checked := g_Config.boSpeedShowMsg;
  EditSpeedMsg.Text := g_Config.sSpeedShowMsg;

  RadioGroupMsgColor.ItemIndex := g_Config.btMsgColor;

  EditHitIntervalTime.Enabled := g_Config.boHit;
  EditMaxHitMsgCount.Enabled := g_Config.boHit;

  EditMagicHitIntervalTime.Enabled := g_Config.boSpell;
  EditMaxSpellMsgCount.Enabled := g_Config.boSpell;

  EditRunIntervalTime.Enabled := g_Config.boRun;
  EditMaxRunMsgCount.Enabled := g_Config.boRun;

  EditWalkIntervalTime.Enabled := g_Config.boWalk;
  EditMaxWalkMsgCount.Enabled := g_Config.boWalk;

  EditTurnIntervalTime.Enabled := g_Config.boTurn;
  EditMaxTurnMsgCount.Enabled := g_Config.boTurn;

  EditSpeedMsg.Enabled := g_Config.boSpeedShowMsg;
  RadioGroupMsgColor.Enabled := g_Config.boSpeedShowMsg;

  ButtonSave.Enabled := False;
  ShowModal;
end;

procedure TFrmGameSpeed.CheckBoxHitClick(Sender: TObject);
begin
  g_Config.boHit := CheckBoxHit.Checked;
  EditHitIntervalTime.Enabled := g_Config.boHit;
  EditMaxHitMsgCount.Enabled := g_Config.boHit;
  ButtonSave.Enabled := True;
end;

procedure TFrmGameSpeed.CheckBoxSpellClick(Sender: TObject);
begin
  g_Config.boSpell := CheckBoxSpell.Checked;
  EditMagicHitIntervalTime.Enabled := g_Config.boSpell;
  EditMaxSpellMsgCount.Enabled := g_Config.boSpell;
  ButtonSave.Enabled := True;
end;

procedure TFrmGameSpeed.CheckBoxRunClick(Sender: TObject);
begin
  g_Config.boRun := CheckBoxRun.Checked;
  EditRunIntervalTime.Enabled := g_Config.boRun;
  EditMaxRunMsgCount.Enabled := g_Config.boRun;
  ButtonSave.Enabled := True;
end;

procedure TFrmGameSpeed.CheckBoxWalkClick(Sender: TObject);
begin
  g_Config.boWalk := CheckBoxWalk.Checked;
  EditWalkIntervalTime.Enabled := g_Config.boWalk;
  EditMaxWalkMsgCount.Enabled := g_Config.boWalk;
  ButtonSave.Enabled := True;
end;

procedure TFrmGameSpeed.CheckBoxTurnClick(Sender: TObject);
begin
  g_Config.boTurn := CheckBoxTurn.Checked;
  EditTurnIntervalTime.Enabled := g_Config.boTurn;
  EditMaxTurnMsgCount.Enabled := g_Config.boTurn;
  ButtonSave.Enabled := True;
end;

procedure TFrmGameSpeed.CheckBoxSpeedShowMsgClick(Sender: TObject);
begin
  g_Config.boSpeedShowMsg := CheckBoxSpeedShowMsg.Checked;
  EditSpeedMsg.Enabled := g_Config.boSpeedShowMsg;
  RadioGroupMsgColor.Enabled := g_Config.boSpeedShowMsg;
  ButtonSave.Enabled := True;
end;

procedure TFrmGameSpeed.EditSpeedMsgChange(Sender: TObject);
begin
  g_Config.sSpeedShowMsg := EditSpeedMsg.Text;
  ButtonSave.Enabled := True;
end;

procedure TFrmGameSpeed.RadioButtonDelyModeClick(Sender: TObject);
begin
  if RadioButtonDelyMode.Checked then g_Config.btSpeedControlMode := 0
  else g_Config.btSpeedControlMode := 1;
  ButtonSave.Enabled := True;
end;

procedure TFrmGameSpeed.EditHitIntervalTimeChange(Sender: TObject);
begin
  g_Config.nHitTime := EditHitIntervalTime.Value;
  ButtonSave.Enabled := True;
end;

procedure TFrmGameSpeed.EditMagicHitIntervalTimeChange(Sender: TObject);
begin
  g_Config.nSpellTime := EditMagicHitIntervalTime.Value;
  ButtonSave.Enabled := True;
end;

procedure TFrmGameSpeed.EditRunIntervalTimeChange(Sender: TObject);
begin
  g_Config.nRunTime := EditRunIntervalTime.Value;
  ButtonSave.Enabled := True;
end;

procedure TFrmGameSpeed.EditWalkIntervalTimeChange(Sender: TObject);
begin
  g_Config.nWalkTime := EditWalkIntervalTime.Value;
  ButtonSave.Enabled := True;
end;

procedure TFrmGameSpeed.EditTurnIntervalTimeChange(Sender: TObject);
begin
  g_Config.nTurnTime := EditTurnIntervalTime.Value;
  ButtonSave.Enabled := True;
end;

procedure TFrmGameSpeed.EditMaxHitMsgCountChange(Sender: TObject);
begin
  g_Config.nHitCount := EditMaxHitMsgCount.Value;
  ButtonSave.Enabled := True;
end;

procedure TFrmGameSpeed.EditMaxSpellMsgCountChange(Sender: TObject);
begin
  g_Config.nSpellCount := EditMaxSpellMsgCount.Value;
  ButtonSave.Enabled := True;
end;

procedure TFrmGameSpeed.EditMaxRunMsgCountChange(Sender: TObject);
begin
  g_Config.nRunCount := EditMaxRunMsgCount.Value;
  ButtonSave.Enabled := True;
end;

procedure TFrmGameSpeed.EditMaxWalkMsgCountChange(Sender: TObject);
begin
  g_Config.nWalkCount := EditMaxWalkMsgCount.Value;
  ButtonSave.Enabled := True;
end;

procedure TFrmGameSpeed.EditMaxTurnMsgCountChange(Sender: TObject);
begin
  g_Config.nTurnCount := EditMaxTurnMsgCount.Value;
  ButtonSave.Enabled := True;
end;

procedure TFrmGameSpeed.RadioGroupMsgColorClick(Sender: TObject);
begin
  g_Config.btMsgColor := RadioGroupMsgColor.ItemIndex;
  ButtonSave.Enabled := True;
end;

procedure TFrmGameSpeed.ButtonCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmGameSpeed.ButtonSaveClick(Sender: TObject);
begin
  if Conf <> nil then begin
    ButtonSave.Enabled := False;
    Conf.WriteBool('Setup', 'HitSpeed', g_Config.boHit);
    Conf.WriteBool('Setup', 'SpellSpeed', g_Config.boSpell);
    Conf.WriteBool('Setup', 'RunSpeed', g_Config.boRun);
    Conf.WriteBool('Setup', 'WalkSpeed', g_Config.boWalk);
    Conf.WriteBool('Setup', 'TurnSpeed', g_Config.boTurn);

    Conf.WriteInteger('Setup', 'HitTime', g_Config.nHitTime);
    Conf.WriteInteger('Setup', 'SpellTime', g_Config.nSpellTime);
    Conf.WriteInteger('Setup', 'RunTime', g_Config.nRunTime);
    Conf.WriteInteger('Setup', 'WalkTime', g_Config.nWalkTime);
    Conf.WriteInteger('Setup', 'TurnTime', g_Config.nTurnTime);

    Conf.WriteInteger('Setup', 'HitCount', g_Config.nHitCount);
    Conf.WriteInteger('Setup', 'SpellCount', g_Config.nSpellCount);
    Conf.WriteInteger('Setup', 'RunCount', g_Config.nRunCount);
    Conf.WriteInteger('Setup', 'WalkCount', g_Config.nWalkCount);
    Conf.WriteInteger('Setup', 'TurnCount', g_Config.nTurnCount);

    Conf.WriteInteger('Setup', 'SpeedControlMode', g_Config.btSpeedControlMode);
    Conf.WriteBool('Setup', 'HintSpeed', g_Config.boSpeedShowMsg);
    Conf.WriteString('Setup', 'HintSpeedMsg', g_Config.sSpeedShowMsg);
    Conf.WriteInteger('Setup', 'MsgColor', g_Config.btMsgColor);
  end;
end;

end.

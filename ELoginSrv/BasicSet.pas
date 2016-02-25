unit BasicSet;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Spin;

type
  TFrmBasicSet = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    CheckBoxTestServer: TCheckBox;
    CheckBoxEnableMakingID: TCheckBox;
    CheckBoxEnableGetbackPassword: TCheckBox;
    CheckBoxAutoClear: TCheckBox;
    Label1: TLabel;
    Label2: TLabel;
    ButtonSave: TButton;
    ButtonClose: TButton;
    SpinEditAutoClearTime: TSpinEdit;
    ButtonRestoreBasic: TButton;
    ButtonRestoreNet: TButton;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    GroupBox5: TGroupBox;
    GroupBox6: TGroupBox;
    CheckBoxDynamicIPMode: TCheckBox;
    Label3: TLabel;
    Label4: TLabel;
    EditGateAddr: TEdit;
    EditGatePort: TEdit;
    Label5: TLabel;
    Label6: TLabel;
    EditMonAddr: TEdit;
    EditMonPort: TEdit;
    Label7: TLabel;
    Label8: TLabel;
    EditServerAddr: TEdit;
    EditServerPort: TEdit;
    GroupBox7: TGroupBox;
    CheckBoxAutoUnLockAccount: TCheckBox;
    Label9: TLabel;
    Label10: TLabel;
    SpinEditUnLockAccountTime: TSpinEdit;
    procedure CheckBoxTestServerClick(Sender: TObject);
    procedure CheckBoxEnableMakingIDClick(Sender: TObject);
    procedure CheckBoxEnableGetbackPasswordClick(Sender: TObject);
    procedure CheckBoxAutoClearClick(Sender: TObject);
    procedure SpinEditAutoClearTimeChange(Sender: TObject);
    procedure CheckBoxAutoUnLockAccountClick(Sender: TObject);
    procedure SpinEditUnLockAccountTimeChange(Sender: TObject);
    procedure ButtonRestoreBasicClick(Sender: TObject);
    procedure EditGateAddrChange(Sender: TObject);
    procedure EditGatePortChange(Sender: TObject);
    procedure EditMonAddrChange(Sender: TObject);
    procedure EditMonPortChange(Sender: TObject);
    procedure EditServerAddrChange(Sender: TObject);
    procedure EditServerPortChange(Sender: TObject);
    procedure CheckBoxDynamicIPModeClick(Sender: TObject);
    procedure ButtonRestoreNetClick(Sender: TObject);
    procedure ButtonSaveClick(Sender: TObject);
    procedure ButtonCloseClick(Sender: TObject);
  private
    { Private declarations }
    procedure LockSaveButtonEnabled();
    procedure UnLockSaveButtonEnabled();
  public
    { Public declarations }
    procedure OpenBasicSet();
  end;

var
  FrmBasicSet: TFrmBasicSet;

implementation
uses HUtil32, LSShare;
var
  Config: pTConfig;
{$R *.dfm}
procedure TFrmBasicSet.LockSaveButtonEnabled();
begin
  ButtonSave.Enabled := False;
end;

procedure TFrmBasicSet.UnLockSaveButtonEnabled();
begin
  ButtonSave.Enabled := true;
end;

procedure TFrmBasicSet.OpenBasicSet();
begin
  Config := @g_Config;
  CheckBoxTestServer.Checked := Config.boTestServer;
  CheckBoxEnableMakingID.Checked := Config.boEnableMakingID;
  CheckBoxEnableGetbackPassword.Checked := Config.boEnableGetbackPassword;
  CheckBoxAutoClear.Checked := Config.boAutoClearID;
  SpinEditAutoClearTime.Value := Config.dwAutoClearTime;

  CheckBoxAutoUnLockAccount.Checked := Config.boUnLockAccount;
  SpinEditUnLockAccountTime.Value := Config.dwUnLockAccountTime;

  EditGateAddr.Text := Config.sGateAddr;
  EditGatePort.Text := IntToStr(Config.nGatePort);

  EditServerAddr.Text := Config.sServerAddr;
  EditServerPort.Text := IntToStr(Config.nServerPort);

  EditMonAddr.Text := Config.sMonAddr;
  EditMonPort.Text := IntToStr(Config.nMonPort);

  CheckBoxDynamicIPMode.Checked := Config.boDynamicIPMode;
  LockSaveButtonEnabled();
  ShowModal;
end;

procedure TFrmBasicSet.CheckBoxTestServerClick(Sender: TObject);
begin
  Config := @g_Config;
  Config.boTestServer := CheckBoxTestServer.Checked;
  UnLockSaveButtonEnabled();
end;

procedure TFrmBasicSet.CheckBoxEnableMakingIDClick(Sender: TObject);
begin
  Config := @g_Config;
  Config.boEnableMakingID := CheckBoxEnableMakingID.Checked;
  UnLockSaveButtonEnabled();
end;

procedure TFrmBasicSet.CheckBoxEnableGetbackPasswordClick(Sender: TObject);
begin
  Config := @g_Config;
  Config.boEnableGetbackPassword := CheckBoxEnableGetbackPassword.Checked;
  UnLockSaveButtonEnabled();
end;

procedure TFrmBasicSet.CheckBoxAutoClearClick(Sender: TObject);
begin
  Config := @g_Config;
  Config.boAutoClearID := CheckBoxAutoClear.Checked;
  UnLockSaveButtonEnabled();
end;

procedure TFrmBasicSet.SpinEditAutoClearTimeChange(Sender: TObject);
begin
  Config := @g_Config;
  Config.dwAutoClearTime := SpinEditAutoClearTime.Value;
  UnLockSaveButtonEnabled();
end;

procedure TFrmBasicSet.CheckBoxAutoUnLockAccountClick(Sender: TObject);
begin
  Config := @g_Config;
  Config.boUnLockAccount := CheckBoxAutoUnLockAccount.Checked;
  UnLockSaveButtonEnabled();
end;

procedure TFrmBasicSet.SpinEditUnLockAccountTimeChange(Sender: TObject);
begin
  Config := @g_Config;
  Config.dwUnLockAccountTime := SpinEditUnLockAccountTime.Value;
  UnLockSaveButtonEnabled();
end;

procedure TFrmBasicSet.ButtonRestoreBasicClick(Sender: TObject);
begin
  Config := @g_Config;
  CheckBoxTestServer.Checked := true;
  CheckBoxEnableMakingID.Checked := true;
  CheckBoxEnableGetbackPassword.Checked := true;
  CheckBoxAutoClear.Checked := true;
  SpinEditAutoClearTime.Value := 1;
  CheckBoxAutoUnLockAccount.Checked := False;
  SpinEditUnLockAccountTime.Value := 10;
end;

procedure TFrmBasicSet.EditGateAddrChange(Sender: TObject);
begin
  Config := @g_Config;
  Config.sGateAddr := Trim(EditGateAddr.Text);
  UnLockSaveButtonEnabled();
end;

procedure TFrmBasicSet.EditGatePortChange(Sender: TObject);
begin
  Config := @g_Config;
  Config.nGatePort := Str_ToInt(Trim(EditGatePort.Text), 5500);
  UnLockSaveButtonEnabled();
end;

procedure TFrmBasicSet.EditMonAddrChange(Sender: TObject);
begin
  Config := @g_Config;
  Config.sMonAddr := Trim(EditMonAddr.Text);
  UnLockSaveButtonEnabled();
end;

procedure TFrmBasicSet.EditMonPortChange(Sender: TObject);
begin
  Config := @g_Config;
  Config.nMonPort := Str_ToInt(Trim(EditMonPort.Text), 3000);
  UnLockSaveButtonEnabled();
end;

procedure TFrmBasicSet.EditServerAddrChange(Sender: TObject);
begin
  Config := @g_Config;
  Config.sServerAddr := Trim(EditServerAddr.Text);
  UnLockSaveButtonEnabled();
end;

procedure TFrmBasicSet.EditServerPortChange(Sender: TObject);
begin
  Config := @g_Config;
  Config.nServerPort := Str_ToInt(Trim(EditServerPort.Text), 5600);
  UnLockSaveButtonEnabled();
end;

procedure TFrmBasicSet.CheckBoxDynamicIPModeClick(Sender: TObject);
begin
  Config := @g_Config;
  Config.boDynamicIPMode := CheckBoxDynamicIPMode.Checked;
  UnLockSaveButtonEnabled();
end;

procedure TFrmBasicSet.ButtonRestoreNetClick(Sender: TObject);
begin
  EditGateAddr.Text := '0.0.0.0';
  EditGatePort.Text := '5500';
  EditServerAddr.Text := '0.0.0.0';
  EditServerPort.Text := '5600';
  EditMonAddr.Text := '0.0.0.0';
  EditMonPort.Text := '3000';
  CheckBoxDynamicIPMode.Checked := False;
end;

procedure WriteConfig(Config: pTConfig);
  procedure WriteConfigString(sSection, sIdent, sDefault: string);
  begin
    Config.IniConf.WriteString(sSection, sIdent, sDefault);
  end;
  procedure WriteConfigInteger(sSection, sIdent: string; nDefault: Integer);
  begin
    Config.IniConf.WriteInteger(sSection, sIdent, nDefault);
  end;
  procedure WriteConfigBoolean(sSection, sIdent: string; boDefault: Boolean);
  begin
    Config.IniConf.WriteBool(sSection, sIdent, boDefault);
  end;
resourcestring
  sSectionServer = 'Server';
  sSectionDB = 'DB';
  sIdentDBServer = 'DBServer';
  sIdentFeeServer = 'FeeServer';
  sIdentLogServer = 'LogServer';
  sIdentGateAddr = 'GateAddr';
  sIdentGatePort = 'GatePort';
  sIdentServerAddr = 'ServerAddr';
  sIdentServerPort = 'ServerPort';
  sIdentMonAddr = 'MonAddr';
  sIdentMonPort = 'MonPort';
  sIdentDBSPort = 'DBSPort';
  sIdentFeePort = 'FeePort';
  sIdentLogPort = 'LogPort';
  sIdentReadyServers = 'ReadyServers';
  sIdentTestServer = 'TestServer';
  sIdentDynamicIPMode = 'DynamicIPMode';
  sIdentIdDir = 'IdDir';
  sIdentWebLogDir = 'WebLogDir';
  sIdentCountLogDir = 'CountLogDir';
  sIdentFeedIDList = 'FeedIDList';
  sIdentFeedIPList = 'FeedIPList';

  sIdentEnableGetbackPassword = 'GetbackPassword';
  sIdentAutoClearID = 'AutoClearID';
  sIdentAutoClearTime = 'AutoClearTime';
  sIdentUnLockAccount = 'UnLockAccount';
  sIdentUnLockAccountTime = 'UnLockAccountTime';
begin
  WriteConfigString(sSectionServer, sIdentDBServer, Config.sDBServer);
  WriteConfigString(sSectionServer, sIdentFeeServer, Config.sFeeServer);
  WriteConfigString(sSectionServer, sIdentLogServer, Config.sLogServer);

  WriteConfigString(sSectionServer, sIdentGateAddr, Config.sGateAddr);
  WriteConfigInteger(sSectionServer, sIdentGatePort, Config.nGatePort);
  WriteConfigString(sSectionServer, sIdentServerAddr, Config.sServerAddr);
  WriteConfigInteger(sSectionServer, sIdentServerPort, Config.nServerPort);
  WriteConfigString(sSectionServer, sIdentMonAddr, Config.sMonAddr);
  WriteConfigInteger(sSectionServer, sIdentMonPort, Config.nMonPort);

  WriteConfigInteger(sSectionServer, sIdentDBSPort, Config.nDBSPort);
  WriteConfigInteger(sSectionServer, sIdentFeePort, Config.nFeePort);
  WriteConfigInteger(sSectionServer, sIdentLogPort, Config.nLogPort);
  WriteConfigInteger(sSectionServer, sIdentReadyServers, Config.nReadyServers);
  WriteConfigBoolean(sSectionServer, sIdentTestServer, Config.boEnableMakingID);

  WriteConfigBoolean(sSectionServer, sIdentEnableGetbackPassword, Config.boEnableGetbackPassword);
  WriteConfigBoolean(sSectionServer, sIdentAutoClearID, Config.boAutoClearID);
  WriteConfigInteger(sSectionServer, sIdentAutoClearTime, Config.dwAutoClearTime);
  WriteConfigBoolean(sSectionServer, sIdentUnLockAccount, Config.boUnLockAccount);
  WriteConfigInteger(sSectionServer, sIdentUnLockAccountTime, Config.dwUnLockAccountTime);

  WriteConfigBoolean(sSectionServer, sIdentDynamicIPMode, Config.boDynamicIPMode);

  WriteConfigString(sSectionDB, sIdentIdDir, Config.sIdDir);
  WriteConfigString(sSectionDB, sIdentWebLogDir, Config.sWebLogDir);
  WriteConfigString(sSectionDB, sIdentCountLogDir, Config.sCountLogDir);
  WriteConfigString(sSectionDB, sIdentFeedIDList, Config.sFeedIDList);
  WriteConfigString(sSectionDB, sIdentFeedIPList, Config.sFeedIPList);
end;

procedure TFrmBasicSet.ButtonSaveClick(Sender: TObject);
begin
  WriteConfig(Config);
  LockSaveButtonEnabled();
end;

procedure TFrmBasicSet.ButtonCloseClick(Sender: TObject);
begin
  Close;
end;

end.

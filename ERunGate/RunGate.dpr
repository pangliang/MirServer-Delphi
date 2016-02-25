program RunGate;

uses
  Forms,
  Main in 'Main.pas' {FrmMain},
  GateShare in 'GateShare.pas',
  GeneralConfig in 'GeneralConfig.pas' {frmGeneralConfig},
  MessageFilterConfig in 'MessageFilterConfig.pas' {frmMessageFilterConfig},
  IPaddrFilter in 'IPaddrFilter.pas' {frmIPaddrFilter},
  EDcode in 'EDcode.pas',
  Grobal2 in '..\Common\Grobal2.pas',
  HUtil32 in '..\Common\HUtil32.pas',
  PrefConfig in 'PrefConfig.pas' {frmPrefConfig},
  OnLineHum in 'OnLineHum.pas' {FrmOnLineHum},
  Common in '..\Common\Common.pas',
  GameSpeed in 'GameSpeed.pas' {FrmGameSpeed};

{$R *.res}

begin
  Application.Initialize;
  Application.HintHidePause := 10000;
  Application.HintPause := 100;
  Application.CreateForm(TFrmMain, FrmMain);
  Application.CreateForm(TfrmGeneralConfig, frmGeneralConfig);
  Application.CreateForm(TfrmMessageFilterConfig, frmMessageFilterConfig);
  Application.CreateForm(TfrmIPaddrFilter, frmIPaddrFilter);
  Application.CreateForm(TfrmPrefConfig, frmPrefConfig);
  Application.Run;
end.


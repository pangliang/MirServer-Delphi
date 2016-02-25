program mir2;

uses
  Forms,
  Dialogs,
  IniFiles,
  Windows,
  SysUtils,
  ClMain in 'ClMain.pas' {frmMain},
  DrawScrn in 'DrawScrn.pas',
  IntroScn in 'IntroScn.pas',
  PlayScn in 'PlayScn.pas',
  MapUnit in 'MapUnit.pas',
  FState in 'FState.pas' {FrmDlg},
  ClFunc in 'ClFunc.pas',
  cliUtil in 'cliUtil.pas',
  DWinCtl in 'DWinCtl.pas',
  WIL in 'WIL.pas',
  magiceff in 'magiceff.pas',
  SoundUtil in 'SoundUtil.pas',
  Actor in 'Actor.pas',
  HerbActor in 'HerbActor.pas',
  AxeMon in 'AxeMon.pas',
  clEvent in 'clEvent.pas',
  HUtil32 in 'HUtil32.pas',
  Grobal2 in 'Common\Grobal2.pas',
  MShare in 'MShare.pas',
  SDK in 'SDK\SDK.pas',
  Mpeg in 'Mpeg.pas',
  wmutil in 'wmUtil.pas',
  Share in 'Share.pas',
  EDcode in 'Common\EDcode.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'legend of mir2';
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TFrmDlg, FrmDlg);
  InitObj();

  g_nThisCRC := CalcFileCRC(Application.ExeName);
  Application.Run;
end.

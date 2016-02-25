program M2Server;

uses
  Forms,
  Windows,
  Graphics,
  svMain in 'svMain.pas' {FrmMain},
  LocalDB in 'LocalDB.pas' {FrmDB},
  InterServerMsg in 'InterServerMsg.pas' {FrmSrvMsg},
  InterMsgClient in 'InterMsgClient.pas' {FrmMsgClient},
  IdSrvClient in 'IdSrvClient.pas' {FrmIDSoc},
  FSrvValue in 'FSrvValue.pas' {FrmServerValue},
  SDK in 'SDK.pas',
  UsrEngn in 'UsrEngn.pas',
  ObjNpc in 'ObjNpc.pas',
  ObjMon2 in 'ObjMon2.pas',
  ObjMon in 'ObjMon.pas',
  ObjGuard in 'ObjGuard.pas',
  ObjBase in 'ObjBase.pas',
  ObjAxeMon in 'ObjAxeMon.pas',
  NoticeM in 'NoticeM.pas',
  Mission in 'Mission.pas',
  Magic in 'Magic.pas',
  M2Share in 'M2Share.pas',
  ItmUnit in 'ItmUnit.pas',
  FrnEngn in 'FrnEngn.pas',
  Event in 'Event.pas',
  Envir in 'Envir.pas',
  Castle in 'Castle.pas',
  RunDB in 'RunDB.pas',
  RunSock in 'RunSock.pas',
  HUtil32 in '..\Common\HUtil32.pas',
  Mudutil in '..\Common\Mudutil.pas',
  PlugIn in 'PlugIn.pas',
  GeneralConfig in 'GeneralConfig.pas' {frmGeneralConfig},
  GameConfig in 'GameConfig.pas' {frmGameConfig},
  FunctionConfig in 'FunctionConfig.pas' {frmFunctionConfig},
  ObjRobot in 'ObjRobot.pas',
  BnkEngn in 'BnkEngn.pas',
  ViewSession in 'ViewSession.pas' {frmViewSession},
  ViewOnlineHuman in 'ViewOnlineHuman.pas' {frmViewOnlineHuman},
  ViewLevel in 'ViewLevel.pas' {frmViewLevel},
  ViewList in 'ViewList.pas' {frmViewList},
  OnlineMsg in 'OnlineMsg.pas' {frmOnlineMsg},
  HumanInfo in 'HumanInfo.pas' {frmHumanInfo},
  ViewKernelInfo in 'ViewKernelInfo.pas' {frmViewKernelInfo},
  ConfigMerchant in 'ConfigMerchant.pas' {frmConfigMerchant},
  ItemSet in 'ItemSet.pas' {frmItemSet},
  ConfigMonGen in 'ConfigMonGen.pas' {frmConfigMonGen},
  PlugInManage in 'PlugInManage.pas' {ftmPlugInManage},
  GameCommand in 'GameCommand.pas' {frmGameCmd},
  MonsterConfig in 'MonsterConfig.pas' {frmMonsterConfig},
  UnitManage in 'UnitManage.pas',
  JClasses in 'JClasses.pas',
  ActionSpeedConfig in 'ActionSpeedConfig.pas' {frmActionSpeed},
  EDcode in 'EDcode.pas',
  CastleManage in 'CastleManage.pas' {frmCastleManage},
  Common in '..\Common\Common.pas',
  PlugOfEngine in 'PlugOfEngine.pas',
  EngineRegister in 'EngineRegister.pas' {FrmRegister},
  AttackSabukWallConfig in 'AttackSabukWallConfig.pas' {FrmAttackSabukWall},
  AboutUnit in 'AboutUnit.pas' {FrmAbout},
  ObjPlayMon in 'ObjPlayMon.pas',
  EDcodeUnit in '..\Common\EDcodeUnit.pas',
  Guild in 'Guild.pas',
  Grobal2 in '..\Common\Grobal2.pas',
  DESTR in '..\Common\DESTR.pas';

{$R *.res}
procedure Start();
begin
  g_Config.nServerFile_CRCA := CalcFileCRC(Application.ExeName);
  Application.Initialize;
  Application.HintPause := 100;
  Application.HintShortPause := 100;
  Application.HintHidePause := 5000;
  Application.CreateForm(TFrmMain, FrmMain);
  Application.CreateForm(TFrmSrvMsg, FrmSrvMsg);
  asm
    jz @@Start
    jnz @@Start
    db 0EBh
    @@Start:
  end;
  Application.CreateForm(TFrmMsgClient, FrmMsgClient);
  Application.CreateForm(TFrmIDSoc, FrmIDSoc);
  Application.CreateForm(TFrmServerValue, FrmServerValue);
  Application.CreateForm(TftmPlugInManage, ftmPlugInManage);
  Application.CreateForm(TfrmGameCmd, frmGameCmd);
  Application.CreateForm(TfrmMonsterConfig, frmMonsterConfig);
  Application.Run;
end;

asm
  jz @@Start
  jnz @@Start
  db 0E8h
@@Start:
  lea eax,Start
  call eax
  jz @@end
  jnz @@end
  db 0F4h
  db 0FFh
@@end:
end.


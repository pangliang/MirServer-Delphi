program DBServer;

uses
  Forms,
  viewrcd in 'viewrcd.pas' {FrmFDBViewer},
  frmcpyrcd in 'frmcpyrcd.pas' {FrmCopyRcd},
  CreateId in 'CreateId.pas' {FrmCreateId},
  CreateChr in 'CreateChr.pas' {FrmCreateChr},
  UsrSoc in 'UsrSoc.pas' {FrmUserSoc},
  FIDHum in 'FIDHum.pas' {FrmIDHum},
  IDSocCli in 'IDSocCli.pas' {FrmIDSoc},
  FDBexpl in 'FDBexpl.pas' {FrmFDBExplore},
  AddrEdit in 'AddrEdit.pas' {FrmEditAddr},
  DBSMain in 'DBSMain.pas' {FrmDBSrv},
  HumDB in 'HumDB.pas',
  DBShare in 'DBShare.pas',
  Grobal2 in '..\Common\Grobal2.pas',
  DBTools in 'DBTools.pas' {frmDBTool},
  EditRcd in 'EditRcd.pas' {frmEditRcd},
  TestSelGate in 'TestSelGate.pas' {frmTestSelGate},
  RouteManage in 'RouteManage.pas' {frmRouteManage},
  RouteEdit in 'RouteEdit.pas' {frmRouteEdit},
  EDcode in 'EDCode.pas',
  Common in '..\Common\Common.pas',
  Setting in 'Setting.pas' {FrmSetting},
  MudUtil in '..\Common\MudUtil.pas',
  HUtil32 in '..\Common\HUtil32.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TFrmDBSrv, FrmDBSrv);
  Application.CreateForm(TFrmFDBViewer, FrmFDBViewer);
  Application.CreateForm(TFrmCopyRcd, FrmCopyRcd);
  Application.CreateForm(TFrmCreateId, FrmCreateId);
  Application.CreateForm(TFrmCreateChr, FrmCreateChr);
  Application.CreateForm(TFrmIDHum, FrmIDHum);
  Application.CreateForm(TFrmIDSoc, FrmIDSoc);
  Application.CreateForm(TFrmUserSoc, FrmUserSoc);
  Application.CreateForm(TFrmFDBExplore, FrmFDBExplore);
  Application.CreateForm(TFrmCreateChr, FrmCreateChr);
  Application.CreateForm(TFrmEditAddr, FrmEditAddr);
  Application.CreateForm(TfrmDBTool, frmDBTool);
  Application.CreateForm(TfrmEditRcd, frmEditRcd);
  Application.CreateForm(TfrmRouteManage, frmRouteManage);
  Application.CreateForm(TfrmRouteEdit, frmRouteEdit);
  Application.Run;
end.


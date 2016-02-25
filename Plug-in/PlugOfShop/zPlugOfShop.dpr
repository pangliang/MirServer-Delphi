library zPlugOfShop;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  Project-View Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the BORLNDMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using BORLNDMM.DLL, pass string information
  using PChar or ShortString parameters. }

uses
  Windows,
  SysUtils,
  Classes,
  PlugMain in 'PlugMain.pas',
  PlugShare in 'PlugShare.pas',
  PlayShop in 'PlayShop.pas',
  ShopConfig in 'ShopConfig.pas' {FrmShopItem},
  HUtil32 in '..\PlugInCommon\HUtil32.pas',
  EngineAPI in '..\PlugInCommon\EngineAPI.pas',
  EngineType in '..\PlugInCommon\EngineType.pas';
{$R *.res}
const
  PlugName = '传奇商铺插件 (2014/09/09)';
  LoadPlus = '加载传奇商铺插件成功...';
  UnLoadPlus = '卸载传奇商铺插件成功...';
  nFindObj = 5;
  nPlugHandle = 6;
  nStartPlug = 8;
type
  TMsgProc = procedure(Msg: PChar; nMsgLen: Integer; nMode: Integer); stdcall;
  TFindProc = function(sProcName: PChar; nNameLen: Integer): Pointer; stdcall;
  TFindObj = function(sObjName: PChar; nNameLen: Integer): TObject; stdcall;
  TSetProc = function(ProcAddr: Pointer; ProcName: PChar; nNameLen: Integer): Boolean; stdcall;
  TStartPlug = function(): Boolean; stdcall;
  TGetFunAddr = function(nIndex: Integer): Pointer; stdcall;
  TSetStartPlug = function(StartPlug: TStartPlug): Boolean; stdcall;
var
  OutMessage: TMsgProc;
  
function Start(): Boolean; stdcall;
begin
  Result := StartPlug;
end;

function Init(AppHandle: HWnd; MsgProc: TMsgProc; FindProc: TFindProc; SetProc: TSetProc; GetFunAddr: TGetFunAddr): PChar; stdcall;
var
  FindObj: TFindObj;
  SetStartPlug: TSetStartPlug;
begin
  PlugHandle := 0;
  OutMessage := MsgProc;
  MsgProc(LoadPlus, length(LoadPlus), 0);
  PlugHandle := PInteger(GetFunAddr(nPlugHandle))^;
  FindObj := TFindObj(GetFunAddr(nFindObj));
  SetStartPlug := TSetStartPlug(GetFunAddr(nStartPlug));
  SetStartPlug(Start);
  InitPlug();
  Result := PlugName;
end;

procedure MainOutMessasge(Msg: string; nMode: Integer);
begin
  if Assigned(OutMessage) then begin
    OutMessage(PChar(Msg), length(Msg), nMode);
  end;
end;

procedure UnInit(); stdcall;
begin
  UnInitPlug();
  MainOutMessasge(UnLoadPlus, 0);
end;

procedure Config(); stdcall;
begin
  FrmShopItem := TFrmShopItem.Create(nil);
  FrmShopItem.Open;
  FrmShopItem.Free;
end;

exports
  Init, UnInit, Config;
begin

end.


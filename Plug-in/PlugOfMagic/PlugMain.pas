unit PlugMain;

interface
uses
  Windows, SysUtils, EngineAPI, ExtCtrls, Classes, UserMagic;

procedure InitPlug();
procedure UnInitPlug();
function StartPlug(): Boolean;
implementation

procedure InitPlug();
begin
  LoadMagicList();
  TMagicManager_SetHookDoSpell(DoSpell);
end;

procedure UnInitPlug();
begin
  TMagicManager_SetHookDoSpell(nil);
  UnLoadMagicList();
end;

function StartPlug(): Boolean;
begin
  Result := TRUE;
  LoadMagicListToEngine();
end;

end.


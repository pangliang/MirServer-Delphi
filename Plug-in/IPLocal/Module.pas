unit Module;

interface
uses
  SysUtils,SDK;

  procedure MainOutMessasge(Msg:String;nMode:Integer);
  function  GetProcAddr(sProcName:String):Pointer;
  function  SetProcAddr(ProcAddr:Pointer;sProcName:String):Boolean;
  function  GetObjAddr(sObjName:String):TObject;
var
  OutMessage        :TMsgProc;
  FindProcTable     :TFindProc;
  FindObjTable      :TFindObj;
  SetProcTable      :TSetProc;
implementation

procedure MainOutMessasge(Msg:String;nMode:Integer);
begin
  if Assigned(OutMessage) then begin
    OutMessage(PChar(Msg),Length(Msg),nMode);
  end;
end;

function  GetProcAddr(sProcName:String):Pointer;
begin
  Result:=nil;
  if Assigned(FindProcTable) then begin
    Result:=FindProcTable(PChar(sProcName),length(sProcName));
  end;
end;
function  GetObjAddr(sObjName:String):TObject;
begin
  Result:=nil;
  if Assigned(FindObjTable) then begin
    Result:=FindObjTable(PChar(sObjName),length(sObjName));
  end;
end;
function  SetProcAddr(ProcAddr:Pointer;sProcName:String):Boolean;
begin
  Result:=False;
  if Assigned(SetProcTable) then begin
    Result:=SetProcTable(ProcAddr,PChar(sProcName),length(sProcName));
  end;
end;
end.

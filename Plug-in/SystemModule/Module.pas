unit Module;

interface
uses
  SysUtils, SDK;

procedure MainOutMessasge(Msg: string; nMode: Integer);
function GetProcAddr(sProcName: string; nCode: Integer): Pointer;
function GetProcCode(sProcName: string): Integer;
function SetProcAddr(ProcAddr: Pointer; sProcName: string; nCode: Integer): Boolean;
function SetProcCode(sProcName: string; nCode: Integer): Boolean;
function SetProcCheckCode(sProcName: string; nCode: Integer): Boolean;
function GetObjAddr(sObjName: string; nCode: Integer): TObject;
var
  OutMessage: TMsgProc;
  GetFunctionAddr: TGetFunAddr;
  FindOBjTable_: TFindOBjTable_;
  SetProcCode_: TSetProcCode_;
  SetProcCheckCode_: TSetProcCheckCode_;
  SetProcTable_: TSetProcTable_;
  FindProcCode_: TFindProcCode_;
  FindProcTable_: TFindProcTable_;

  ChangeCaptionText: TChangeCaptionText;
  SetUserLicense: TSetUserLicense;
  ChangeGateSocket: TFrmMain_ChangeGateSocket;
implementation
uses EDcodeUnit;

procedure MainOutMessasge(Msg: string; nMode: Integer);
begin
  if Assigned(OutMessage) then begin
    OutMessage(PChar(Msg), Length(Msg), nMode);
  end;
end;

function GetProcAddr(sProcName: string; nCode: Integer): Pointer;
var
  Obj: TObject;
begin
  Result := nil;
  if Assigned(FindProcTable_) then begin
    Result := FindProcTable_(PChar(sProcName), Length(sProcName), nCode);
  end;
end;

function GetProcCode(sProcName: string): Integer;
begin
  Result := -1;
  if Assigned(FindProcCode_) then begin
    Result := FindProcCode_(PChar(sProcName), Length(sProcName));
  end;
end;

function GetObjAddr(sObjName: string; nCode: Integer): TObject;
begin
  Result := nil;
  if Assigned(FindOBjTable_) then begin
    Result := FindOBjTable_(PChar(sObjName), Length(sObjName), nCode);
  end;
end;

function SetProcAddr(ProcAddr: Pointer; sProcName: string; nCode: Integer): Boolean;
var
  Obj: TObject;
begin
  Result := False;
  if Assigned(SetProcTable_) then begin
    Result := SetProcTable_(ProcAddr, PChar(sProcName), Length(sProcName), nCode);
  end;
end;

function SetProcCode(sProcName: string; nCode: Integer): Boolean;
begin
  Result := False;
  if Assigned(SetProcCode_) then begin
    Result := TSetProcCode_(SetProcCode_)(PChar(sProcName), Length(sProcName), nCode);
  end;
end;

function SetProcCheckCode(sProcName: string; nCode: Integer): Boolean;
var
  sCheckCode: string;
begin
  Result := False;
  if Assigned(SetProcCheckCode_) then begin
    Encode(IntToStr(nCode), sCheckCode);
    Result := TSetProcCheckCode_(SetProcCheckCode_)(PChar(sProcName), PChar(sCheckCode), Length(sProcName), Length(sCheckCode));
  end;
end;

end.

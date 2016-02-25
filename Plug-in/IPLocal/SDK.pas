unit SDK;

interface
uses
  Windows, SysUtils, Classes;
type
  TMsgProc = procedure(Msg: PChar; nMsgLen: Integer; nMode: Integer); stdcall;
  TFindProc = function(ProcName: PChar; nNameLen: Integer): Pointer; stdcall;
  TSetProc = function(ProcAddr: Pointer; ProcName: PChar; nNameLen: Integer): Boolean; stdcall;
  TFindObj = function(ObjName: PChar; nNameLen: Integer): TObject; stdcall;

procedure GetIPLocal(sIPaddr: PChar; sLocal: PChar; nLocalLen: Integer); stdcall;
procedure DeCryptString(Src: PChar; Dest: PChar; nSrc: Integer; var nDest: Integer); stdcall;
function Init(AppHandle: HWnd; MsgProc: TMsgProc; FindProc: TFindProc; SetProc: TSetProc; FindOBj: TFindObj): PChar; stdcall;
procedure UnInit(); stdcall;

implementation
uses Module, PlugMain, Share;

procedure DeCryptString(Src: PChar; Dest: PChar; nSrc: Integer; var nDest: Integer);
var
  sEncode: string;
  sDecode: string;
begin
  try
    SetLength(sEncode, nSrc);
    Move(Src^, sEncode[1], nSrc);
    sDecode := DeCodeText(sEncode);
    Move(sDecode[1], Dest^, Length(sDecode));
  except
  end;
end;

procedure GetIPLocal(sIPaddr: PChar; sLocal: PChar; nLocalLen: Integer);
var
  sIpLocal, sIPaddress: string;
begin
  try
    SetLength(sIPaddress, 15);
    Move(sIPaddr^, sIPaddress[1], 15);
    //sIPaddress := StrPas(sIPaddr);
    sIpLocal := SearchIPLocal(sIPaddress);
    //if
    Move(sIpLocal[1], sLocal^, Length(sIpLocal));
  except
  end;
end;

function Init(AppHandle: HWnd; MsgProc: TMsgProc; FindProc: TFindProc; SetProc: TSetProc; FindOBj: TFindObj): PChar;
begin
  OutMessage := MsgProc;
  FindProcTable := FindProc;
  FindObjTable := FindOBj;
  SetProcTable := SetProc;
  if HookDeCodeText = 1 then begin
    SetProcAddr(@DeCryptString, 'DeCryptString');
  end;
  if HookSearchIPLocal = 1 then begin
    SetProcAddr(@GetIPLocal, 'GetIPLocal');
  end;
  InitPlug(AppHandle);
  Result := PChar(sPlugName);
end;

procedure UnInit();
begin
  MainOutMessasge(sUnLoadPlug, 0);
end;

end.


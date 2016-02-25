unit SDK;

interface
uses
  Windows, SysUtils, Classes, Forms;
type
  TMsgProc = procedure(Msg: PChar; nMsgLen: Integer; nMode: Integer); stdcall;
  TFunAddrSet = procedure(ProcName: PChar; nNameLen, nType: Integer; var nCheckCode: Integer; var nProcArray: Pointer; var Obj: TObject); stdcall;
  TFindProc = function(ProcName: PChar; nNameLen: Integer): Pointer; stdcall;
  TSetProc = function(ProcAddr: Pointer; ProcName: PChar; nNameLen: Integer): Boolean; stdcall;
  TFindObj = function(ObjName: PChar; nNameLen: Integer): TObject; stdcall;

  TGetFunAddr = function(nIndex: Integer): Pointer; stdcall;
  TFindOBjTable_ = function(ObjName: PChar; nNameLen, nCode: Integer): TObject; stdcall;
  TSetProcCode_ = function(ProcName: PChar; nNameLen, nCode: Integer): Boolean; stdcall;
  TSetProcTable_ = function(ProcAddr: Pointer; ProcName: PChar; nNameLen, nCode: Integer): Boolean; stdcall;
  TFindProcCode_ = function(ProcName: PChar; nNameLen: Integer): Integer; stdcall;
  TFindProcTable_ = function(ProcName: PChar; nNameLen, nCode: Integer): Pointer; stdcall;

procedure GetIPLocal(sIPaddr: PChar; sLocal: PChar; nLocalLen: Integer); stdcall;
procedure DeCryptString(Src: PChar; Dest: PChar; nSrc: Integer; var nDest: Integer); stdcall;
function Init(AppHandle: HWnd; MsgProc: TMsgProc; FindProc: TFindProc; SetProc: TSetProc; GetFunAddr: TGetFunAddr): PChar; stdcall;
procedure UnInit(); stdcall;
const
  SuperUser = 240621028; //Æ®Æ®ÍøÂç
  UserKey1 = 13677866; //·É¶ûÊÀ½ç
  Version = UserKey1;
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
    Dest := nil;
    nDest := 0;
  end;
end;

procedure GetIPLocal(sIPaddr: PChar; sLocal: PChar; nLocalLen: Integer);
var
  sIpLocal, sIPaddress: string;
begin
  try
    SetLength(sIPaddress, 15);
    Move(sIPaddr^, sIPaddress[1], Length(sIPaddress));
    sIpLocal := SearchIPLocal(sIPaddress);
    FillChar(sLocal, SizeOf(sLocal), 0);
    Move(sIpLocal[1], sLocal, Length(sIpLocal));
  except
  end;
end;

function GetUserVersion: Boolean;
var
  TPlugOfEngine_GetUserVersion: function(): Integer; stdcall;
  nEngineVersion: Integer;
  sFunctionName: string;
const
  _sFunctionName = '3RWtATWUhfNOYfCQe7T1ITkpeiHHLy2JSdyKEA=='; //TPlugOfEngine_GetUserVersion
begin
  Result := False;
  sFunctionName := DecodeString_3des(_sFunctionName, IntToStr(SuperUser));
  if sFunctionName = '' then Exit;
  @TPlugOfEngine_GetUserVersion := GetProcAddress(GetModuleHandle(PChar(Application.Exename)), PChar(sFunctionName));
  if Assigned(TPlugOfEngine_GetUserVersion) then begin
    nEngineVersion := TPlugOfEngine_GetUserVersion;
    if nEngineVersion <= 0 then Exit;
    if nEngineVersion = Version then Result := True;
  end;
end;

function Init(AppHandle: HWnd; MsgProc: TMsgProc; FindProc: TFindProc; SetProc: TSetProc; GetFunAddr: TGetFunAddr): PChar; stdcall;
var
  nCRC: Integer;
  boLoadSucced: Boolean;
  m_sKey: string;
const
  s01 = 'DeCryptString';
  s02 = 'GetIPLocal';
begin
  nCheckCode := 0;
  boLoadSucced := False;
  OutMessage := MsgProc;
  FindProcCode_ := GetFunAddr(0);
  //FindProcTable_ := GetFunAddr(1);
  SetProcTable_ := GetFunAddr(2);
  SetProcCode_ := GetFunAddr(3);
  //FindOBjTable_ := GetFunAddr(4);
  if HookDeCodeText = 1 then begin
    Inc(nCheckCode);
    if GetUserVersion then begin
      Inc(nCheckCode);
      if SetProcCode(s01, 5) then begin
        Inc(nCheckCode);
        if GetProcCode(s01) = 5 then begin
          Inc(nCheckCode);
          if SetProcAddr(@DeCryptString, s01, 5) then begin
            Inc(nCheckCode);
            m_sKey := Trim(skey);
            sDecryKey := DecodeString_3des(m_sKey, IntToStr(Version * nCheckCode));
            boLoadSucced := True;
          end;
        end;
      end;
    end;
  end;
  if HookSearchIPLocal = 1 then begin
    SetProc(@GetIPLocal, PChar(s02), Length(s02));
  end;
  InitPlug(AppHandle, boLoadSucced);
  Result := PChar(sPlugName);
end;

procedure UnInit(); stdcall;
begin
  MainOutMessasge(sUnLoadPlug, 0);
end;

end.


unit SDK;

interface
uses
  Windows, SysUtils, Classes, Controls, Forms, SystemManage, IdTCPClient, IdHTTP, ShellApi, ExtCtrls,
  Common;
var
  boSetLicenseInfo, boSetUserLicense: Boolean;
type
  TMyTimer = class(TObject)
    Timer: TTimer;
    procedure OnTimer(Sender: TObject);
  end;

  TMsgProc = procedure(Msg: PChar; nMsgLen: Integer; nMode: Integer); stdcall;
  TFindProc = function(ProcName: PChar; nNameLen: Integer): Pointer; stdcall;
  TSetProc = function(ProcAddr: Pointer; ProcName: PChar; nNameLen: Integer): Boolean; stdcall;
  TFindObj = function(ObjName: PChar; nNameLen: Integer): TObject; stdcall;

  TGetFunAddr = function(nIndex: Integer): Pointer; stdcall;
  TFindOBjTable_ = function(ObjName: PChar; nNameLen, nCode: Integer): TObject; stdcall;
  TSetProcCode_ = function(ProcName: PChar; nNameLen, nCheckCode: Integer): Boolean; stdcall;
  TSetProcCheckCode_ = function(ProcName, CheckCode: PChar; nNameLen, nCheckCodeLen: Integer): Boolean; stdcall;

  TSetProcTable_ = function(ProcAddr: Pointer; ProcName: PChar; nNameLen, nCode: Integer): Boolean; stdcall;
  TFindProcCode_ = function(ProcName: PChar; nNameLen: Integer): Integer; stdcall;
  TFindProcTable_ = function(ProcName: PChar; nNameLen, nCode: Integer): Pointer; stdcall;
  TStartPlug = function(): Boolean; stdcall;
  TSetStartPlug = function(StartPlug: TStartPlug): Boolean; stdcall;

  TChangeCaptionText = procedure(Msg: PChar; nLen: Integer); stdcall;
  TSetUserLicense = procedure(nDay, nUserCout: Integer); stdcall;
  TFrmMain_ChangeGateSocket = procedure(boOpenGateSocket: Boolean; nCRCA: Integer); stdcall;

function Init(AppHandle: HWnd; MsgProc: TMsgProc; FindProc: TFindProc; SetProc: TSetProc; GetFunctionAddr: TGetFunAddr): PChar; stdcall;
procedure UnInit(); stdcall;
function Start(): Boolean; stdcall;
procedure StartModule(); stdcall;
function GetProductVersion: Boolean; stdcall;
function GetLicenseInfo(var nUserLicense: Integer; var wErrorCode: Word): Integer; stdcall;
procedure RegisterName(sName: PChar); stdcall;
function RegisterLicense(sRegisterInfo, sUserName: PChar): Integer; stdcall;
function GetUserVersion: Boolean;
function GetLicenseNumber: Integer;
function GetVersionNumber: Integer;
function GetFunAddr(nIndex: Integer): Pointer; stdcall;
procedure InitTimer();
procedure UnInitTimer();
implementation
uses Module, SystemShare, EDcode, DESTRING, EDcodeUnit;
var
  MyTimer: TMyTimer;
  sHomePage: string;
function GetLicenseInfo(var nUserLicense: Integer; var wErrorCode: Word): Integer;
var
  m_btUserMode: Byte;
  m_wCount, m_wPersonCount: Word;
  m_wErrorCode: Word;
  m_btStatus: Byte;
  boUserVersion: Boolean;
  nCheckCode: Integer;
  s10: string;
  s11: string;
  s12: string;
  s13: string;
  s14: string;
  s15: string;
  s16: string;
  s17: string;
  s18: string;
  sTemp: string;
  nCount: Integer;
  nLicenseNumber: Integer;
begin
  Result := 0;
  nLicenseNumber := GetLicenseNumber;
  boUserVersion := GetUserVersion;
  nCheckCode := Integer(boUserVersion);
  m_btUserMode := 0;
  m_wCount := 0;
  m_wPersonCount := 0;
  m_wErrorCode := 0;
  m_btStatus := 0;

  nUserLicense := 0;
  wErrorCode := 0;
  if nLicenseNumber <= 0 then Exit;
  if not boUserVersion then Exit;
{$IF TESTMODE = 1}
  MainOutMessasge('SystemModule GetLicenseInfo', 0);
{$IFEND}
  if not Decode(s101, s11) then Exit;
  if not Decode(s102, s12) then Exit;
  if not Decode(s103, s13) then Exit;
  if not Decode(s104, s14) then Exit;
  if not Decode(s105, s15) then Exit;
  if not Decode(s106, s16) then Exit;
  if not Decode(s107, s17) then Exit;
  if (n107 div 400) <> Str_ToInt(s17, 0) then Exit;

  InitLicense(nVersion * nCheckCode, nLicenseNumber, 0, 0, 0, Date, PChar(IntToStr(nVersion)));
  GetLicense(m_btUserMode, m_wCount, m_wPersonCount, m_wErrorCode, m_btStatus);
  UnInitLicense();
  if (m_wCount = 0) and (m_btStatus = 0) and (LoByte(m_wErrorCode) = 0) then begin //注册版本到期后自动转换免费版
    InitLicense(nLicenseNumber * nCheckCode, nUserLicense, 0, 0, 0, Date, PChar(IntToStr(nLicenseNumber + nVersion)));
    if ClearRegisterInfo then begin
      UnInitLicense();
      nCount := Str_ToInt(s17, 0);
      InitLicense(nVersion * nCheckCode, nLicenseNumber, 1, High(Word), nCount, Date, PChar(IntToStr(nVersion)));
      GetLicense(m_btUserMode, m_wCount, m_wPersonCount, m_wErrorCode, m_btStatus);
      UnInitLicense();
    end else UnInitLicense();
  end;

{$IF TESTMODE = 1}
  MainOutMessasge('SystemModule GetLicenseInfo UserMode: ' + IntToStr(m_btUserMode), 0);
  MainOutMessasge('SystemModule GetLicenseInfo wCount: ' + IntToStr(m_wCount), 0);
  MainOutMessasge('SystemModule GetLicenseInfo wPersonCount: ' + IntToStr(m_wPersonCount), 0);
  MainOutMessasge('SystemModule GetLicenseInfo ErrorInfo: ' + IntToStr(m_wErrorCode), 0);
  MainOutMessasge('SystemModule GetLicenseInfo btStatus: ' + IntToStr(m_btStatus), 0);
{$IFEND}

  if LoByte(m_wErrorCode) = 0 then begin
    case m_btUserMode of
      0: Exit;
      1: begin
          if m_btStatus = 0 then
            sTemp := Format(s15, [m_wCount])
          else sTemp := Format(s13, [m_wPersonCount, m_wCount]);
          ChangeCaptionText(PChar(sTemp), Length(sTemp));
          if Assigned(SetUserLicense) then begin
            SetUserLicense(m_wCount, m_wPersonCount);
          end;
        end;
      2: begin
          if m_btStatus = 0 then
            sTemp := Format(s14, [m_wCount])
          else sTemp := Format(s12, [m_wPersonCount, m_wCount]);
          ChangeCaptionText(PChar(sTemp), Length(sTemp));
          if Assigned(SetUserLicense) then begin
            SetUserLicense(m_wCount, m_wPersonCount);
          end;
        end;
      3: begin
          ChangeCaptionText(PChar(s16), Length(s16));
          if Assigned(SetUserLicense) then begin
            SetUserLicense(m_wCount, m_wPersonCount);
          end;
        end;
    end;
  end;

  if (LoByte(m_wErrorCode) = 0) and (m_btUserMode > 0) then begin
    nUserLicense := MakeLong(m_wCount, m_wPersonCount);
    wErrorCode := m_wErrorCode;
    Result := nVersion;
  end else begin
    nUserLicense := 0;
    Result := 0;
    m_wErrorCode := MakeWord(100, HiByte(m_wErrorCode));
  end;
  {MainOutMessasge('SystemModule GetLicenseInfo UserMode: ' + IntToStr(m_btUserMode), 0);
  MainOutMessasge('SystemModule GetLicenseInfo wCount: ' + IntToStr(m_wCount), 0);
  MainOutMessasge('SystemModule GetLicenseInfo wPersonCount: ' + IntToStr(m_wPersonCount), 0);
  MainOutMessasge('SystemModule GetLicenseInfo ErrorInfo: ' + IntToStr(ErrorInfo), 0);
  MainOutMessasge('SystemModule GetLicenseInfo btStatus: ' + IntToStr(btStatus), 0);}
end;

procedure RegisterName(sName: PChar); stdcall;
var
  sRegisterName: string;
  nLicenseNumber: Integer;
begin
  nLicenseNumber := GetLicenseNumber;
  if nLicenseNumber > 0 then begin
    InitLicense(nVersion, nLicenseNumber, 0, 0, 0, Date, PChar(IntToStr(nVersion)));
    SetLength(sRegisterName, 32);
    sRegisterName := Trim(GetRegisterName);
    Move(sRegisterName[1], sName^, Length(sRegisterName));
    UnInitLicense();
  end;
end;

function RegisterLicense(sRegisterInfo, sUserName: PChar): Integer;
var
  nLicenseNumber: Integer;
begin
  Result := -1;
  nLicenseNumber := GetLicenseNumber;
  if nLicenseNumber > 0 then begin
    InitLicense(nVersion, nLicenseNumber, 0, 0, 0, Date, PChar(IntToStr(nVersion)));
    Result := StartRegister(sRegisterInfo, sUserName);
    UnInitLicense();
  end;
end;

function GetLicenseNumber: Integer;
var
  sLicense: string;
  nLicense: Integer;
begin
  Result := 0;
  if not Decode(sUserLicense, sLicense) then Exit;
  nLicense := Str_ToInt(sLicense, 0);
  if (nLicense <> nUserVersion) or (nLicense <= 0) then Exit;
  if GetUserVersion then begin
    Result := nLicense;
  end;
end;

function GetUserVersion: Boolean;
var
  TPlugOfEngine_GetUserVersion: function(): Integer; stdcall;
  nEngineVersion: Integer;
  sFunctionName: string;
  sDeVersion: string;
const
  _sFunctionName = 'B7F45A721D66515CBAA52FBE60253A3E8342F3E57AF9AA6AE863DA8FF7976BC02BA05E5EA07B22F2'; //TPlugOfEngine_GetUserVersion
begin
  Result := False;
  if not Decode(_sFunctionName, sFunctionName) then Exit;
  if not Decode(sVersion, sDeVersion) then Exit;
  if Str_ToInt(sDeVersion, 0) <> nVersion then Exit;
  @TPlugOfEngine_GetUserVersion := GetProcAddress(GetModuleHandle(PChar(Application.Exename)), PChar(sFunctionName));
  if Assigned(TPlugOfEngine_GetUserVersion) then begin
    nEngineVersion := TPlugOfEngine_GetUserVersion;
    if nEngineVersion <= 0 then Exit;
    if nEngineVersion = nVersion then Result := True;
  end;
end;

procedure StartModule();
var
  sTemp: string;
  btUserMode: Byte;
  wCount, wPersonCount, wErrorCode: Word;
  btStatus: Byte;
  nPersonCount: Integer;
  boUserVersion: Boolean;
  nCheckCode: Integer;
  s2: string;
  s3: string;
  s4: string;
  s10: string;
  s11: string;
  s12: string;
  s13: string;
  s14: string;
  s15: string;
  s16: string;
  s17: string;
  s18: string;
  nLicenseNumber: Integer;
begin
  try
    boUserVersion := GetUserVersion;
    nCheckCode := Integer(boUserVersion);
    nLicenseNumber := GetLicenseNumber;
    if nLicenseNumber <= 0 then Exit;
    if not boUserVersion then Exit;
    btUserMode := 0;
    wCount := 0;
    wPersonCount := 0;
    wErrorCode := 0;
    btStatus := 0;
    nPersonCount := 0;

    if not Decode(s101, s11) then Exit;
    if not Decode(s102, s12) then Exit;
    if not Decode(s103, s13) then Exit;
    if not Decode(s104, s14) then Exit;
    if not Decode(s105, s15) then Exit;
    if not Decode(s106, s16) then Exit;
    if not Decode(s107, s17) then Exit;

    if Assigned(ChangeCaptionText) then begin
      ChangeCaptionText(PChar(s11), Length(s11));
    end else Exit;
    nPersonCount := Str_ToInt(s17, 0);
    InitLicense(nVersion * nCheckCode, nLicenseNumber, 1, High(Word), nPersonCount, Date, PChar(IntToStr(nVersion)));
    GetLicense(btUserMode, wCount, wPersonCount, wErrorCode, btStatus);
    UnInitLicense();
    if not boSetLicenseInfo then begin
      if not Decode(s002, s2) then Exit;
      if not Decode(s003, s3) then Exit;
      if not Decode(s004, s4) then Exit;
      if (GetProcCode(s2) = 2) and (GetProcCode(s3) = 3) and (GetProcCode(s4) = 4) then begin
        if SetProcCode(s2, 20) and SetProcCheckCode(s2, 20) then begin
          if SetProcAddr(@GetLicenseInfo, s2, 20) and SetProcAddr(@RegisterName, s3, 3) and SetProcAddr(@RegisterLicense, s4, 4) then begin
            boSetLicenseInfo := True;
          end;
        end;
      end;
    end;
{$IF TESTMODE = 1}
    MainOutMessasge('StartModule ErrorInfo ' + IntToStr(LoByte(wErrorCode)) + ' StartModule ErrorInfo1 ' + IntToStr(HiByte(wErrorCode)), 0);
    MainOutMessasge('StartModule UserMode ' + IntToStr(btUserMode), 0);
    MainOutMessasge('StartModule wCount ' + IntToStr(wCount), 0);
    MainOutMessasge('StartModule wPersonCount ' + IntToStr(wPersonCount), 0);
    MainOutMessasge('StartModule nLicenseNumber ' + IntToStr(nLicenseNumber), 0);
{$IFEND}

    if LoByte(wErrorCode) > 0 then begin //2006-11-10 增加自动清除错误注册码
      InitLicense(nVersion * nCheckCode, nLicenseNumber, 0, 0, 0, Date, PChar(IntToStr(nVersion)));
      if ClearRegisterInfo then begin
        UnInitLicense();
        InitLicense(nVersion * nCheckCode, nLicenseNumber, 1, High(Word), nPersonCount, Date, PChar(IntToStr(nVersion)));
        GetLicense(btUserMode, wCount, wPersonCount, wErrorCode, btStatus);
        UnInitLicense();
      end else UnInitLicense();
    end;

    if (boSetLicenseInfo) and (LoByte(wErrorCode) = 0) and (btUserMode > 0) then begin
      if (wCount = 0) and (btStatus = 0) then begin //注册版本到期后自动转换免费版
        InitLicense(nVersion * nCheckCode, nLicenseNumber, 0, 0, 0, Date, PChar(IntToStr(nVersion)));
        if ClearRegisterInfo then begin
          UnInitLicense();
          InitLicense(nVersion * nCheckCode, nLicenseNumber, 1, High(Word), nPersonCount, Date, PChar(IntToStr(nVersion)));
          GetLicense(btUserMode, wCount, wPersonCount, wErrorCode, btStatus);
          UnInitLicense();
        end else UnInitLicense();
      end;
      case btUserMode of
        0: Exit;
        1: begin
            if Assigned(ChangeGateSocket) then begin
              ChangeGateSocket(True, nVersion);
              if btStatus <= 0 then begin
                sTemp := Format(s15, [wCount])
              end else begin
                sTemp := Format(s13, [wPersonCount, wCount]);
                MainOutMessasge(DecodeInfo(sSellInfo), 0);
              end;
              ChangeCaptionText(PChar(sTemp), Length(sTemp));
              if Assigned(SetUserLicense) then begin
                SetUserLicense(wCount div nCheckCode, wPersonCount div nCheckCode);
              end;
            end;
          end;
        2: begin
            if Assigned(ChangeGateSocket) then begin
              ChangeGateSocket(True, nVersion);
              if btStatus = 0 then begin
                sTemp := Format(s14, [wCount])
              end else begin
                sTemp := Format(s12, [wPersonCount, wCount]);
                MainOutMessasge(DecodeInfo(sSellInfo), 0);
              end;
              ChangeCaptionText(PChar(sTemp), Length(sTemp));
              if Assigned(SetUserLicense) then begin
                SetUserLicense(wCount div nCheckCode, wPersonCount div nCheckCode);
              end;
            end;
          end;
        3: begin
            if Assigned(ChangeGateSocket) then begin
              ChangeGateSocket(True, nVersion);
              ChangeCaptionText(PChar(s16), Length(s16));
              if Assigned(SetUserLicense) then begin
                SetUserLicense(wCount div nCheckCode, wPersonCount div nCheckCode);
              end;
            end;
          end;
      end;
    end;
  except
    //MainOutMessasge('StartModule Fail', 0);
  end;
end;

function Start(): Boolean;
begin
  Result := True;
  GetProductVersion();
end;

procedure TMyTimer.OnTimer(Sender: TObject);
begin
  MyTimer.Timer.Enabled := False;
  if Application.MessageBox('发现新的引擎版本，是否下载？？？',
    '提示信息',
    MB_YESNO + MB_ICONQUESTION) = IDYES then begin
    ShellExecute(0, 'open', PChar(sHomePage), nil, nil, SW_SHOWNORMAL);
  end;
end;

procedure InitTimer();
begin
  MyTimer := TMyTimer.Create;
  MyTimer.Timer := TTimer.Create(nil);
  MyTimer.Timer.Enabled := False;
  MyTimer.Timer.Interval := 10;
  MyTimer.Timer.OnTimer := MyTimer.OnTimer;
  MyTimer.Timer.Enabled := True;
end;

procedure UnInitTimer();
begin
  MyTimer.Timer.Enabled := False;
  MyTimer.Timer.Free;
  MyTimer.Free;
end;

function GetVersionNumber: Integer;
const
  _sFunctionName: string = 'F729C7FA8622CD29FAB4A578BE9761D4C40E3BB5D4309CD7E863DA8FF7976BC05DEB286F86C12BBE'; //TPlugOfEngine_GetProductVersion
var
  TPlugOfEngine_GetProductVersion: function(): Integer; stdcall;
  sFunctionName: string;
begin
  Result := 0;
  if not Decode(_sFunctionName, sFunctionName) then Exit;
  @TPlugOfEngine_GetProductVersion := GetProcAddress(GetModuleHandle(PChar(Application.Exename)), PChar(sFunctionName));
  if Assigned(TPlugOfEngine_GetProductVersion) then begin
    Result := TPlugOfEngine_GetProductVersion;
  end;
end;

function GetProductVersion: Boolean;
var
  sRemoteAddress: string;
  nEngineVersion: Integer;
  IdHTTP: TIdHTTP;
  s: TStringlist;
  sEngineVersion: string;
  nRemoteVersion: Integer;
begin
  Result := False;
  if not Decode(_sRemoteAddress, sRemoteAddress) then Exit;
  if not Decode(_sHomePage, sHomePage) then Exit;
  nEngineVersion := GetVersionNumber;
  if nEngineVersion > 0 then begin
{$IF nVersion = nSuperUser}
    try
      IdHTTP := TIdHTTP.Create(nil);
      IdHTTP.ReadTimeout := 3000;
      s := TStringlist.Create;
      s.Text := IdHTTP.Get(sRemoteAddress);
      sEngineVersion := Trim(s.Text);
      s.Free;
      IdHTTP.Free;
      try
        sEngineVersion := DecryStrHex(sEngineVersion, IntToStr(nEngineVersion));
        nRemoteVersion := Str_ToInt(sEngineVersion, 0);
      except
        nRemoteVersion := 0;
      end;
      if nRemoteVersion <> nEngineVersion then begin
        InitTimer();
      end;
    except
    end;
{$IFEND}
    Result := True;
  end;
end;

function Init(AppHandle: HWnd; MsgProc: TMsgProc; FindProc: TFindProc; SetProc: TSetProc; GetFunctionAddr: TGetFunAddr): PChar; stdcall;
var
  nCrc: Integer;
  s01: string;
  s05: string;
  s06: string;
  sFunc01: string;
  SetStartPlug: TSetStartPlug;
begin
  boSetLicenseInfo := False;
  if not Decode(s001, s01) then Exit;
  if not Decode(s005, s05) then Exit;
  if not Decode(s006, s06) then Exit;
  if not Decode(sFunc001, sFunc01) then Exit;

  OutMessage := MsgProc;
  FindProcCode_ := GetFunctionAddr(0);
  FindProcTable_ := GetFunctionAddr(1);
  SetProcTable_ := GetFunctionAddr(2);
  SetProcCode_ := GetFunctionAddr(3);
  FindOBjTable_ := GetFunctionAddr(4);
  SetStartPlug := GetFunctionAddr(8);
  SetProcCheckCode_ := GetFunctionAddr(9);
  SetStartPlug(Start);
  SetUserLicense := GetProcAddr(s05, 5);
  ChangeGateSocket := GetProcAddr(s06, 6);
  ChangeCaptionText := GetProcAddr(sFunc01, 0);
  if GetProcCode(s01) = 1 then SetProcAddr(@StartModule, s01, 1);
  MainOutMessasge(sLoadPlug, 0);
  Result := PChar(sPlugName);
end;

procedure UnInit(); stdcall;
begin
{$IF nVersion = nSuperUser}
  UnInitTimer();
{$IFEND}
  MainOutMessasge(sUnLoadPlug, 0);
end;

function GetFunAddr(nIndex: Integer): Pointer;
begin
  Result := nil;
  case nIndex of
    0: Result := @InitLicense;
    1: Result := @UnInitLicense;
    2: Result := @GetUserVersion;
    3: Result := @GetUserLicense;
    4: Result := @MakeRegisterInfo;
  end;
end;

end.

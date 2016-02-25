unit SystemManage;

interface
uses
  Windows, Graphics, SysUtils, UserLicense {, DiaLogs};
var
  License: TLicense;
procedure InitLicense(nVersion, nUserLicense: Integer; wStatus, wCount, wPersonCount: Word; MaxDate: TDateTime; UserName: PChar); stdcall;
procedure UnInitLicense(); stdcall;
function GetRegisterName(): string;
procedure GetLicense(var UserMode: Byte; var wCount, wPersonCount, ErrorCode: Word; var btStatus: Byte); stdcall;
function MakeRegisterInfo(RegisterInfo: pTRegisterInfo): PChar; stdcall;
function StartRegister(sRegisterInfo, sUserName: PChar): Integer; stdcall;
function ClearRegisterInfo(): Boolean; overload;
function ClearRegisterInfo(sRegisterName: string): Boolean; overload;
function GetUserVersion: Integer; stdcall;
function GetUserLicense: Integer; stdcall;
implementation
uses EDcode, DESTRING, EDcodeUnit;

function GetUserLicense: Integer;
begin
  Result := License.nUserLicense;
end;

function GetUserVersion: Integer;
begin
  Result := License.nUserVersion;
end;

function ClearRegisterInfo(sRegisterName: string): Boolean;
begin
  Result := License.Clear(sRegisterName);
end;

function ClearRegisterInfo(): Boolean;
begin
  Result := License.Clear;
end;

procedure InitLicense(nVersion, nUserLicense: Integer; wStatus, wCount, wPersonCount: Word; MaxDate: TDateTime; UserName: PChar);
var
  LicenseInitialize: pTLicenseInitialize;
begin
  New(LicenseInitialize);
  LicenseInitialize^.sUserName := StrPas(UserName);
  LicenseInitialize^.nVersion := nVersion;
  LicenseInitialize^.nLicense := nUserLicense;
  LicenseInitialize^.wStatus := wStatus;
  LicenseInitialize^.wCount := wCount;
  LicenseInitialize^.wPersonCount := wPersonCount;
  LicenseInitialize^.MaxDate := MaxDate;
  License := TLicense.Create(LicenseInitialize);
  Dispose(LicenseInitialize);
end;

procedure UnInitLicense();
begin
  License.Destroy;
end;

function GetRegisterName(): string;
begin
  Result := License.RegisterName;
end;

procedure GetLicense(var UserMode: Byte; var wCount, wPersonCount, ErrorCode: Word; var btStatus: Byte);
begin
  UserMode := License.UserMode;
  wCount := License.Count;
  wPersonCount := License.PersonCount;
  ErrorCode := License.ErrorCode;
  btStatus := License.Status;
end;

function MakeRegisterInfo(RegisterInfo: pTRegisterInfo): PChar;
var
  sRegisterInfo: string;
  Buff: array[1..1024] of Char;
begin
  sRegisterInfo := License.MakeRegisterInfo(RegisterInfo);
  FillChar(Buff, SizeOf(Buff), 0);
  Move(sRegisterInfo[1], Buff, Length(sRegisterInfo));
  Result := @Buff;
end;

function StartRegister(sRegisterInfo, sUserName: PChar): Integer;
begin
  Result := License.StartRegister(StrPas(sRegisterInfo), StrPas(sUserName));
end;

end.

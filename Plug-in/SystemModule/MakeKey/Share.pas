unit Share;

interface
uses
  Windows, SysUtils, Classes, Controls;
type
  TRegisterInfo = record
    sRegisterName: PChar;
    sUserName: PChar;
    btUserMode: Byte;
    nUserCount: Integer;
    nPersonCount: Integer;
    RegisterDate: TDateTime;
    nLicense: Integer;
    nVersion: Integer;
  end;
  pTRegisterInfo = ^TRegisterInfo;

  TInit = function(nSoftType: Integer; btStatus: Byte; wCount: Word; MaxDate: TDateTime; UserName: PChar): PChar; stdcall;
  TUnInit = procedure(); stdcall;
  TGetFunAddr = function(nIndex: Integer): Pointer; stdcall;

  TOpenDiaLog = procedure(); stdcall;
  TGetLicense = procedure(var UserMode: Byte; var wCount: Word; var ErrorInfo: Integer; var btStatus: Byte); stdcall;
  TGetRegisterName = function(): PChar; stdcall;
  TGetRegisterCode = function(): PChar; stdcall;

  TInitLicense = procedure(nVersion, nUserLicense: Integer; wStatus, wCount, wPersonCount: Word; MaxDate: TDateTime; UserName: PChar); stdcall;
  TUnInitLicense = procedure(); stdcall;
  TGetFunctionAddr = function(nIndex: Integer): Pointer; stdcall;
  TGetUserVersion = function: Integer; stdcall;
  TGetUserLicense = function: Integer; stdcall;
  TMakeRegisterInfo = function(RegisterInfo: pTRegisterInfo): PChar; stdcall;
var
  Init: TInit;
  UnInit: TUnInit;
  GetFunAddr: TGetFunAddr;
  OpenDiaLog: TOpenDiaLog;
  GetLicenseShare: TGetLicense;
  GetRegisterNameShare: TGetRegisterName;
  GetRegisterCodeShare: TGetRegisterCode;

  GetFunctionAddr: TGetFunctionAddr;
  MakeRegisterInfo: TMakeRegisterInfo;
  InitLicense: TInitLicense;
  UnInitLicense: TUnInitLicense;
  GetUserVersion: TGetUserVersion;
  GetUserLicense: TGetUserLicense;

  PlugHandleList:array [0..1] of THandle;

  sRegisterCode: String;
  boEnterKey: Boolean;
  Moudle: THandle;
  nCheckCode: Integer;
  nAppFilesSize: Integer = 0;
  sAppFilesSize: string = '482EAAA35C73E2C286F09EA9034C2D0C'; //571392
  sMyInfo: string = '673006E29F171064A7CE48F1251E4633D42E098EFFC700E71F46EAAD240D5DB11E57F726E443C7E1';
implementation

end.


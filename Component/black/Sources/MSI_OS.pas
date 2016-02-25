{*******************************************************}
{                                                       }
{       MiTeC System Information Component              }
{               OS Detection Part                       }
{           version 8.6.5 for Delphi 5,6,7              }
{                                                       }
{       Copyright © 1997,2004 Michal Mutl               }
{                                                       }
{*******************************************************}

{$INCLUDE MITEC_DEF.INC}

unit MSI_OS;

interface

uses
  MSI_Common, SysUtils, Windows, Classes, MiTeC_Routines;

type
  TTimeZone = class(TPersistent)
  private
    FStdBias: integer;
    FDayBias: integer;
    FBias: integer;
    FDisp: string;
    FStd: string;
    FDayStart: TDatetime;
    FStdStart: TDatetime;
    FDay: string;
    FMap: string;
    FModes: TExceptionModes;
    procedure SetMode(const Value: TExceptionModes);
  public
    constructor Create;
    procedure GetInfo;
    procedure Report(var sl :TStringList; Standalone: Boolean = True); virtual;
    property MapID: string read FMap;
  published
    property ExceptionModes: TExceptionModes read FModes Write SetMode;
    property DisplayName: string read FDisp {$IFNDEF D6PLUS} write FDisp {$ENDIF} stored False;
    property StandardName: string read FStd {$IFNDEF D6PLUS} write FStd {$ENDIF} stored False;
    property DaylightName: string read FDay {$IFNDEF D6PLUS} write FDay {$ENDIF} stored False;
    property DaylightStart: TDatetime read FDayStart {$IFNDEF D6PLUS} write FDayStart {$ENDIF} stored False;
    property StandardStart: TDatetime read FStdStart {$IFNDEF D6PLUS} write FStdStart {$ENDIF} stored False;
    property Bias: integer read FBias {$IFNDEF D6PLUS} write FBias {$ENDIF} stored False;
    property DaylightBias: integer read FDayBias {$IFNDEF D6PLUS} write FDayBias {$ENDIF} stored False;
    property StandardBias: integer read FStdBias {$IFNDEF D6PLUS} write FStdBias {$ENDIF} stored False;
  end;

const
  VER_NT_WORKSTATION       = $0000001;
  VER_NT_DOMAIN_CONTROLLER = $0000002;
  VER_NT_SERVER            = $0000003;

  VER_SUITE_SMALLBUSINESS            = $00000001;
  VER_SUITE_ENTERPRISE               = $00000002;
  VER_SUITE_BACKOFFICE               = $00000004;
  VER_SUITE_COMMUNICATIONS           = $00000008;
  VER_SUITE_TERMINAL                 = $00000010;
  VER_SUITE_SMALLBUSINESS_RESTRICTED = $00000020;
  VER_SUITE_EMBEDDEDNT               = $00000040;
  VER_SUITE_DATACENTER               = $00000080;
  VER_SUITE_SINGLEUSERTS             = $00000100;
  VER_SUITE_PERSONAL                 = $00000200;
  VER_SUITE_BLADE                    = $00000400;
  VER_SUITE_EMBEDDED_RESTRICTED      = $00000800;



type
  POSVersionInfoEx = ^TOSVersionInfoEx;
  TOSVersionInfoEx = record
    dwOSVersionInfoSize: DWORD;
    dwMajorVersion: DWORD;
    dwMinorVersion: DWORD;
    dwBuildNumber: DWORD;
    dwPlatformId: DWORD;
    szCSDVersion: array [0..127] of Char;
    wServicePackMajor: Word;
    wServicePackMinor: Word;
    wSuiteMask: Word;
    wProductType: Byte;
    wReserved: Byte;
  end;

  TNtProductType = (ptUnknown, ptWorkStation, ptServer, ptAdvancedServer, ptDataCenter, ptWeb);


  TNTSuite = (suSmallBusiness, suEnterprise, suBackOffice, suCommunications,
              suTerminal, suSmallBusinessRestricted, suEmbeddedNT, suDataCenter,
              suSingleUserTS,suPersonal,suBlade,suEmbeddedRestricted);
  TNTSuites = set of TNTSuite;

  TNTSpecific = class(TPersistent)
  private
    FSPMinorVer: Word;
    FSPMajorVer: Word;
    FProduct: TNTProductType;
    FSuites: TNTSuites;
    FHotFixes: string;
    FModes: TExceptionModes;
    procedure SetMode(const Value: TExceptionModes);
  public
    constructor Create;
    procedure GetInfo;
    procedure Report(var sl: TStringList; Standalone: Boolean = True); virtual;
    procedure GetInstalledSuitesStr(var sl: TStringList);
    function GetProductTypeStr(PT: TNTProductType): string;
  published
    property ExceptionModes: TExceptionModes read FModes Write SetMode;
    property ProductType: TNTProductType read FProduct {$IFNDEF D6PLUS} write FProduct {$ENDIF} stored False;
    property InstalledSuites: TNTSuites read FSuites {$IFNDEF D6PLUS} write FSuites {$ENDIF} stored False;
    property ServicePackMajorVersion: Word read FSPMajorVer {$IFNDEF D6PLUS} write FSPMajorVer {$ENDIF} stored False;
    property ServicePackMinorVersion: Word read FSPMinorVer {$IFNDEF D6PLUS} write FSPMinorVer {$ENDIF} stored False;
    property HotFixes: string read FHotFixes {$IFNDEF D6PLUS} write FHotFixes {$ENDIF} stored False;
  end;

  TInternet = class(TPersistent)
  private
    FBrowser: string;
    FProxy: TStrings;
    FMailClient: string;
    FCType: TConnectionType;
    FModes: TExceptionModes;
    procedure SetMode(const Value: TExceptionModes);
  public
    constructor Create;
    destructor Destroy; override;
    function GetConnTypeStr(ACType: TConnectionType): string;
    procedure GetInfo;
    procedure Report(var sl :TStringList; Standalone: Boolean = True); virtual;
  published
    property ExceptionModes: TExceptionModes read FModes Write SetMode;
    property DefaultBrowser: string read FBrowser {$IFNDEF D6PLUS} write FBrowser {$ENDIF} stored False;
    property DefaultMailClient: string read FMailClient {$IFNDEF D6PLUS} write FMailClient {$ENDIF} stored False;
    property ConnectionType: TConnectionType read FCType {$IFNDEF D6PLUS} write FCType {$ENDIF} stored False;
    property ProxyServer: TStrings read FProxy {$IFNDEF D6PLUS} write FProxy {$ENDIF} stored False;
  end;

  TMeasureSystem = (Metric, US);

  TPositiveCurrencyMode = (Prefix_No_Separation, Suffix_No_Separation,
                           Prefix_One_Char_Separation, Suffix_One_Char_Separation);

  TDateOrder = (MDY, DMY, YMD);

  TTimeFormat = (H12, H24);

  TYearFormat = (TwoDigit, FourDigit);

const
  SNegativeCurrencyMode: array[0..9] of string =
                         ('($1.1)',
                          '-$1.1',
                          '$-1.1',
                          '$1.1-',
                          '(1.1$)',
                          '-1.1$',
                          '1.1-$',
                          '1.1$-',
                          '-1.1 $',
                          '-$ 1.1');

type
  TLocaleInfo = Class(TPersistent)
  private
   FLang,
   FEngLang,
   FAbbrLang,
   FCountry,
   FFCountry,
   FAbbrCtry,
   FList,
   FDecimal,
   FDigit,
   FCurrency,
   FIntlSymbol,
   FMonDecSep,
   FMonThoSep,
   FCurrdigit,
   FNCurrMode,
   FDate,
   FTime,
   FTimeFormat,
   FShortDate: string;
   FMeasure: TMeasureSystem;
   FPCurrMode: TPositiveCurrencyMode;
   FShortDateOrdr,
   FLongDateOrdr: TDateOrder;
   FTimeFormatSpec: TTimeFormat;
   FYearFormat: TYearFormat;
    FModes: TExceptionModes;
    FLongDate: string;
    procedure SetMode(const Value: TExceptionModes);
  public
   constructor Create;
   procedure GetInfo(LocaleID: DWORD);
   procedure Report(var sl: TStringList; Standalone: Boolean = True); virtual;
  published
   property ExceptionModes: TExceptionModes read FModes Write SetMode;
   property FullLocalizeLanguage: string read Flang {$IFNDEF D6PLUS} write Flang {$ENDIF} stored false;
   property FullLanguageEnglishName: string read FEngLang {$IFNDEF D6PLUS} write FEngLang {$ENDIF} stored false;
   property AbbreviateLanguageName: string read FAbbrLang {$IFNDEF D6PLUS} write FAbbrLang {$ENDIF} stored false;
   property CountryCode: string read FCountry {$IFNDEF D6PLUS} write FCountry {$ENDIF} stored false;
   property FullCountryCode: string read FFCountry {$IFNDEF D6PLUS} write FFCountry {$ENDIF} stored false;
   property AbbreviateCountryCode: string read FAbbrCtry {$IFNDEF D6PLUS} write FAbbrCtry {$ENDIF} stored false;
   property ListSeparator: string read FList {$IFNDEF D6PLUS} write FList {$ENDIF} stored false;
   property MeasurementSystem: TMeasureSystem read FMeasure {$IFNDEF D6PLUS} write FMeasure {$ENDIF} stored false;
   property DecimalSeparator: string read FDecimal {$IFNDEF D6PLUS} write FDecimal {$ENDIF} stored false;
   property NumberOfDecimalDigits: string read FDigit {$IFNDEF D6PLUS} write FDigit {$ENDIF} stored false;
   property LocalMonetarySymbol: string read FCurrency {$IFNDEF D6PLUS} write FCurrency {$ENDIF} stored false;
   property InternationalMonetarySymbol: string read FIntlSymbol {$IFNDEF D6PLUS} write FIntlSymbol {$ENDIF} stored false;
   Property CurrencyDecimalSeparator: string read FMonDecSep {$IFNDEF D6PLUS} write FMonDecSep {$ENDIF} stored false;
   property CurrencyThousandSeparator: string read FMonThoSep {$IFNDEF D6PLUS} write FMonThoSep {$ENDIF} stored false;
   property CurrencyDecimalDigits: string read FCurrDigit {$IFNDEF D6PLUS} write FCurrDigit {$ENDIF} stored false;
   property PositiveCurrencyMode: TPositiveCurrencyMode read FPCurrMode {$IFNDEF D6PLUS} write FPCurrMode {$ENDIF} stored false;
   property NegativeCurrencyMode: string read FNCurrMode {$IFNDEF D6PLUS} write FNCurrMode {$ENDIF} stored false;
   property DateSeparator: string read FDate {$IFNDEF D6PLUS} write FDate {$ENDIF} stored false;
   property TimeSeparator: string read FTime {$IFNDEF D6PLUS} write FTime {$ENDIF} stored false;
   property TimeFormat: string read FTimeFormat {$IFNDEF D6PLUS} write FTimeFormat {$ENDIF} stored false;
   property ShortDateFormat: string read FShortDate {$IFNDEF D6PLUS} write FShortDate {$ENDIF} stored false;
   property LongDateFormat: string read FLongDate {$IFNDEF D6PLUS} write FLongDate {$ENDIF} stored False;
   property ShortDateOrder: TDateOrder read FShortDateOrdr {$IFNDEF D6PLUS} write FShortDateOrdr {$ENDIF} stored false;
   property LongDateOrder: TDateOrder read FLongDateOrdr {$IFNDEF D6PLUS} write FLongDateOrdr {$ENDIF} stored false;
   property TimeFormatSpecifier: TTimeFormat read FTimeFormatSpec {$IFNDEF D6PLUS} write FTimeFormatSpec {$ENDIF} stored false;
   property YearFormat: TYearFormat read FYearFormat {$IFNDEF D6PLUS} write FYearFormat {$ENDIF} stored false;
   property DecimalThousandSeparator: string read FMonThoSep {$IFNDEF D6PLUS} write FMonThoSep {$ENDIF} stored false;
  end;

  TOSPlatform = (opWin31, opWin9x, opWinNT);

  TOperatingSystem = class(TPersistent)
  private
    FBuildNumber: integer;
    FMajorVersion: integer;
    FMinorVersion: integer;
    FPlatform: TOSPlatform;
    FCSD: string;
    FVersion: string;
    FRegUser: string;
    FProductID: string;
    FRegOrg: string;
    FEnv: TStrings;
    FDirs: TStrings;
    FTZ: TTimeZone;
    FNTSpec: TNTSpecific;
    FProductKey: string;
    FDVD: string;
    FInternet: TInternet;
    FModes: TExceptionModes;
    FCSDEx: string;
    FLocale: TLocaleInfo;
    FSysLangDefID: string;
    procedure SetMode(const Value: TExceptionModes);
  protected
  public
    constructor Create;
    destructor Destroy; override;
    procedure GetInfo;
    procedure Report(var sl :TStringList; Standalone: Boolean = True); virtual;
    property CSDEx :string read FCSDEx;
  published
    property ExceptionModes: TExceptionModes read FModes Write SetMode;
    property MajorVersion :integer read FMajorVersion {$IFNDEF D6PLUS} write FMajorVersion {$ENDIF} stored false;
    property MinorVersion :integer read FMinorVersion {$IFNDEF D6PLUS} write FMinorVersion {$ENDIF} stored false;
    property BuildNumber :integer read FBuildNumber {$IFNDEF D6PLUS} write FBuildNumber {$ENDIF} stored false;
    property Platform :TOSPlatform read FPlatform {$IFNDEF D6PLUS} write FPlatform {$ENDIF} stored false;
    property Version :string read FVersion {$IFNDEF D6PLUS} write FVersion {$ENDIF} stored false;
    property CSD :string read FCSD {$IFNDEF D6PLUS} write FCSD {$ENDIF} stored false;
    property ProductID :string read FProductID {$IFNDEF D6PLUS} write FProductID {$ENDIF} stored false;
    property ProductKey :string read FProductKey {$IFNDEF D6PLUS} write FProductKey {$ENDIF} stored False;
    property RegisteredUser :string read FRegUser {$IFNDEF D6PLUS} write FRegUser {$ENDIF} stored false;
    property RegisteredOrg :string read FRegOrg {$IFNDEF D6PLUS} write FRegOrg {$ENDIF} stored false;
    property TimeZone :TTimeZone read FTZ {$IFNDEF D6PLUS} write FTZ {$ENDIF} stored false;
    property Environment :TStrings read FEnv {$IFNDEF D6PLUS} write FEnv {$ENDIF} stored false;
    property Folders: TStrings read FDirs {$IFNDEF D6PLUS} write FDirs {$ENDIF} stored False;
    property NTSpecific: TNTSpecific read FNTSpec {$IFNDEF D6PLUS} write FNTSpec {$ENDIF} stored False;
    property DVDRegion: string read FDVD {$IFNDEF D6PLUS} write FDVD {$ENDIF} stored False;
    property Internet: TInternet read FInternet {$IFNDEF D6PLUS} write FInternet {$ENDIF} stored False;
    property LocaleInfo: TLocaleInfo read FLocale {$IFNDEF D6PLUS} write FLocale {$ENDIF} stored False;
    property LanguageID: string read FSysLangDefID {$IFNDEF D6PLUS} write FSysLangDefID {$ENDIF} stored False;
  end;

function GetVersionEx(lpVersionInformation: POSVersionInfoEx): BOOL; stdcall;

implementation

uses
  ShlObj, Registry, MiTeC_Datetime{$IFDEF D6PLUS} ,StrUtils {$ENDIF};

function GetVersionEx; external kernel32 name 'GetVersionExA';

{ TTimeZone }

type
  TRegTimeZoneInfo = packed record
    Bias: Longint;
    StandardBias: Longint;
    DaylightBias: Longint;
    StandardDate: TSystemTime;
    DaylightDate: TSystemTime;
  end;

function GetTZDaylightSavingInfoForYear(
    TZ: TTimeZoneInformation; year: word;
    var DaylightDate, StandardDate: TDateTime;
    var DaylightBias, StandardBias: longint): boolean;
begin
  Result:=false;
  try
    if (TZ.DaylightDate.wMonth <> 0) and
       (TZ.StandardDate.wMonth <> 0) then begin
      DaylightDate:=DSTDate2Date(TZ.DaylightDate,year);
      StandardDate:=DSTDate2Date(TZ.StandardDate,year);
      DaylightBias:=TZ.Bias+TZ.DaylightBias;
      StandardBias:=TZ.Bias+TZ.StandardBias;
      Result:=true;
    end;
  except
  end;
end;

function CompareSysTime(st1, st2: TSystemTime): integer;
begin
  if st1.wYear<st2.wYear then
    Result:=-1
  else
    if st1.wYear>st2.wYear then
      Result:=1
    else
      if st1.wMonth<st2.wMonth then
        Result:=-1
      else
        if st1.wMonth>st2.wMonth then
          Result:=1
        else
          if st1.wDayOfWeek<st2.wDayOfWeek then
            Result:=-1
          else
            if st1.wDayOfWeek>st2.wDayOfWeek then
              Result:=1
            else
              if st1.wDay<st2.wDay then
                Result:=-1
              else
                if st1.wDay>st2.wDay then
                  Result:=1
                else
                  if st1.wHour<st2.wHour then
                    Result:=-1
                  else
                    if st1.wHour>st2.wHour then
                      Result:=1
                    else
                      if st1.wMinute<st2.wMinute then
                        Result:=-1
                      else
                        if st1.wMinute>st2.wMinute then
                          Result:=1
                         else
                           if st1.wSecond<st2.wSecond then
                             Result:=-1
                           else
                             if st1.wSecond>st2.wSecond then
                               Result:=1
                             else
                               if st1.wMilliseconds<st2.wMilliseconds then
                                 Result:=-1
                               else
                                 if st1.wMilliseconds>st2.wMilliseconds then
                                   Result:=1
                                 else
                                   Result:=0;
end;

function IsEqualTZ(tz1, tz2: TTimeZoneInformation): boolean;
begin
  Result:=(tz1.Bias=tz2.Bias) and
          (tz1.StandardBias=tz2.StandardBias) and
          //(tz1.DaylightBias=tz2.DaylightBias) and
          (CompareSysTime(tz1.StandardDate,tz2.StandardDate)=0) and
          //(CompareSysTime(tz1.DaylightDate,tz2.DaylightDate)=0) and
          (WideCharToString(tz1.StandardName)=WideCharToString(tz2.StandardName));
          //and (WideCharToString(tz1.DaylightName)=WideCharToString(tz2.DaylightName));
end;

constructor TTimeZone.Create;
begin
  ExceptionModes:=[emExceptionStack];
end;

procedure TTimeZone.GetInfo;
var
  TZKey: string;
  RTZ: TRegTimeZoneInfo;
  HomeTZ, RegTZ: TTimeZoneInformation;
  y,m,d,i: Word;
  sl: TStringList;
const
  rkNTTimeZones = {HKEY_LOCAL_MACHINE}'\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Time Zones';
  rk9xTimeZones = {HKEY_LOCAL_MACHINE}'\SOFTWARE\Microsoft\Windows\CurrentVersion\Time Zones';
  rkTimeZone = {HKEY_LOCAL_MACHINE}'\SYSTEM\CurrentControlSet\Control\TimeZoneInformation';
  rvTimeZone = 'StandardName';
begin
  {$IFDEF ERROR_INTERCEPT}PushTrace(FModes,Self,'GetInfo');{$ENDIF}

  GetTimeZoneInformation(HomeTZ);
  sl:=TStringList.Create;
  with TRegistry.create do begin
    rootkey:=HKEY_LOCAL_MACHINE;
    if IsNT then
      TZKey:=rkNTTimeZones
    else
      TZKey:=rk9xTimeZones;
    if OpenKeyReadOnly(TZKey) then begin
      GetKeyNames(sl);
      CloseKey;
      for i:=0 to sl.Count-1 do
        if OpenKeyReadOnly(TZKey+'\'+sl[i]) then begin
          if GetDataSize('TZI')=SizeOf(RTZ) then begin
            ReadBinaryData('TZI',RTZ,SizeOf(RTZ));
            StringToWideChar(ReadString('Std'),PWideChar(@RegTZ.StandardName),SizeOf(RegTZ.StandardName) div SizeOf(WideChar));
            StringToWideChar(ReadString('Dlt'),PWideChar(@RegTZ.DaylightName),SizeOf(RegTZ.DaylightName) div SizeOf(WideChar));
            RegTZ.Bias:=RTZ.Bias;
            RegTZ.StandardBias:=RTZ.StandardBias;
            RegTZ.DaylightBias:=RTZ.DaylightBias;
            RegTZ.StandardDate:=RTZ.StandardDate;
            RegTZ.DaylightDate:=RTZ.DaylightDate;
            if IsEqualTZ(HomeTZ,RegTZ) then begin
              FDisp:=ReadString('Display');
              try
                FMap:=ReadString('MapID');
              except
                FMap:='';
              end;
              Break;
            end;
          end;
          CloseKey;
        end;
    end;
    Free;
  end;
  FBias:=HomeTZ.Bias;
  FStd:=HomeTZ.StandardName;
  FDay:=HomeTZ.DaylightName;
  DecodeDate(Date,y,m,d);
  GetTZDaylightSavingInfoForYear(HomeTZ,y,FDayStart,FStdStart,FDayBias,FStdBias);
  sl.Free;

  {$IFDEF ERROR_INTERCEPT}PopTrace;{$ENDIF};
end;

procedure TTimeZone.Report;
begin
  {$IFDEF ERROR_INTERCEPT}PushTrace(FModes,Self,'Report'); {$ENDIF}
  with sl do begin
    if Standalone then ReportHeader(sl);
    Add('<TimeZone classname="TTimeZone">');

    Add(Format('<data name="TimeZone" type="string">%s</data>',[CheckXMLValue(DisplayName)]));
    Add(Format('<data name="StandardName" type="string">%s</data>',[DateTimeToStr(StandardStart)]));
    Add(Format('<data name="StandardBias" type="integer" unit="min">%d</data>',[StandardBias]));
    Add(Format('<data name="DaylightName" type="string">%s</data>',[DateTimeToStr(DaylightStart)]));
    Add(Format('<data name="DaylightBias" type="integer" unit="min">%d</data>',[DaylightBias]));

    Add('</TimeZone>');
    if Standalone then ReportFooter(sl);
  end;
  {$IFDEF ERROR_INTERCEPT}PopTrace;{$ENDIF}
end;


procedure TTimeZone.SetMode(const Value: TExceptionModes);
begin
  FModes:=Value;
end;

{ TOperatingSystem }

constructor TOperatingSystem.Create;
begin
  inherited;
  FEnv:=TStringList.Create;
  FDirs:=TStringList.Create;
  FTZ:=TTimeZone.Create;
  FNTSpec:=TNTSpecific.Create;
  FInternet:=TInternet.Create;
  FLocale:=TLocaleInfo.Create;
  ExceptionModes:=[emExceptionStack];
end;

destructor TOperatingSystem.Destroy;
begin
  FEnv.Free;
  FDirs.Free;
  FTZ.Free;
  FNTSpec.Free;
  FInternet.Free;
  FLocale.Free;
  inherited;
end;


procedure TOperatingSystem.GetInfo;
var
  OS :TOSVersionInfo;
  OK: Boolean;
  p: pchar;
  n: DWORD;
  WinH: HWND;
  s: string;
const
  rkOSInfo95 = {HKEY_LOCAL_MACHINE}'\SOFTWARE\Microsoft\Windows\CurrentVersion';
  rkOSInfoNT = {HKEY_LOCAL_MACHINE}'\SOFTWARE\Microsoft\Windows NT\CurrentVersion';
  rkSP6a = {HKEY_LOCAL_MACHINE}'\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Hotfix\Q246009';

  rvInstalled = 'Installed';
  rvVersionName95 = 'Version';
  rvVersionNameNT = 'CurrentType';
  rvRegOrg = 'RegisteredOrganization';
  rvRegOwn = 'RegisteredOwner';
  rvProductID = 'ProductID';
  rvProductKey = 'ProductKey';
  rvDVD = 'DVD_Region';

  cUserProfile = 'USERPROFILE';
  cUserProfileReg = {HKEY_CURRENT_USER}'\Software\Microsoft\Windows\CurrentVersion\ProfileList';
  cUserProfileRec = {HKEY_CURRENT_USER}'\SOFTWARE\Microsoft\Windows\CurrentVersion\ProfileReconciliation';
  cProfileDir = 'ProfileDirectory';
begin
  {$IFDEF ERROR_INTERCEPT}PushTrace(FModes,Self,'GetInfo');{$ENDIF}

  FDirs.Clear;
  TimeZone.GetInfo;
  NTSpecific.GetInfo;
  Internet.GetInfo;
  LocaleInfo.GetInfo(LOCALE_USER_DEFAULT);
  ZeroMemory(@OS,SizeOf(OS));
  OS.dwOSVersionInfoSize:=SizeOf(OS);
  Windows.GetVersionEx(OS);
  FMajorVersion:=OS.dwMajorVersion;
  FMinorVersion:=OS.dwMinorVersion;
  FBuildNumber:=word(OS.dwBuildNumber);
  case OS.dwPlatformId of
    VER_PLATFORM_WIN32s        :FPlatform:=opWin31;
    VER_PLATFORM_WIN32_WINDOWS :FPlatform:=opWin9x;
    VER_PLATFORM_WIN32_NT      :FPlatform:=opWinNT;
  end;
  FCSD:=OS.szCSDVersion;

  FVersion:='';
  FRegUser:='';
  FRegOrg:='';
  FProductID:='';
  with TRegistry.create do begin
    rootkey:=HKEY_LOCAL_MACHINE;
    if IsNT then
      OK:=OpenKeyReadOnly(rkOSInfoNT)
    else
      OK:=OpenKeyReadOnly(rkOSInfo95);
    if OK then begin
      if isnt then begin
        if ValueExists(rvVersionNameNT) then
          FVersion:=ReadString(rvVersionNameNT);
      end else
        if ValueExists(rvVersionName95) then
           FVersion:=ReadString(rvVersionName95);
      if ValueExists(rvRegOrg) then
        FRegOrg:=ReadString(rvRegOrg);
      if ValueExists(rvRegOwn) then
        FRegUser:=ReadString(rvRegOwn);
      if ValueExists(rvProductID) then
        FProductID:=ReadString(rvProductID);
      if ValueExists(rvProductKey) then
        FProductKey:=ReadString(rvProductKey);
      if ValueExists(rvDVD) then
        FDVD:=ReadRegistryValueAsString(RootKey,CurrentPath,rvDVD);

      FDirs.Add('CommonFiles='+ReadString('CommonFilesDir'));
      FDirs.Add('ProgramFiles='+ReadString('ProgramFilesDir'));
      FDirs.Add('Device='+ReadString('DevicePath'));
      FDirs.Add('OtherDevice='+ReadString('OtherDevicePath'));
      FDirs.Add('Media='+ReadString('MediaPath'));
      FDirs.Add('Config='+ReadString('ConfigPath'));
      FDirs.Add('Wallpaper='+ReadString('WallPaperDir'));
      CloseKey;

      FCSDEx:='';
      if IsNT then  begin
        if CSD='Service Pack 6' then
          if OpenKeyReadOnly(rkSP6a) then begin
            if ValueExists(rvInstalled) then
              if ReadInteger(rvInstalled)=1 then
                FCSD:='Service Pack 6a';
            CloseKey;
          end;
        FCSDEx:=FCSD;
      end else
        if IsOSR2 then
          FCSDEx:='OSR 2'
        else
          if IsSE then
            FCSDEx:='Second Edition';
    end;
    Free;
  end;

  n:=MAX_PATH;
  p:=StrAlloc(n);

  GetWindowsDirectory(p,n);
  FDirs.Add('Windows='+p);

  GetSystemDirectory(p,n);
  FDirs.Add('System='+p);

  GetTempPath(n,p);
  FDirs.Add('Temp='+p);

  StrDispose(p);

  WinH:=GetDesktopWindow;
  FDirs.Add('AppData='+GetSpecialFolder(WinH,CSIDL_APPDATA));
  FDirs.Add('CommonDesktopDir='+GetSpecialFolder(WinH,CSIDL_COMMON_DESKTOPDIRECTORY));
  FDirs.Add('CommonAltStartUp='+GetSpecialFolder(WinH,CSIDL_COMMON_ALTSTARTUP));
  FDirs.Add('RecycleBin='+GetSpecialFolder(WinH,CSIDL_BITBUCKET));
  FDirs.Add('CommonPrograms='+GetSpecialFolder(WinH,CSIDL_COMMON_PROGRAMS));
  FDirs.Add('CommonStartMenu='+GetSpecialFolder(WinH,CSIDL_COMMON_STARTMENU));
  FDirs.Add('CommonStartup='+GetSpecialFolder(WinH,CSIDL_COMMON_STARTUP));
  FDirs.Add('CommonFavorites='+GetSpecialFolder(WinH,CSIDL_COMMON_FAVORITES));
  FDirs.Add('Cookies='+GetSpecialFolder(WinH,CSIDL_COOKIES));
  FDirs.Add('Controls='+GetSpecialFolder(WinH,CSIDL_CONTROLS));
  FDirs.Add('Desktop='+GetSpecialFolder(WinH,CSIDL_DESKTOP));
  FDirs.Add('DesktopDir='+GetSpecialFolder(WinH,CSIDL_DESKTOPDIRECTORY));
  FDirs.Add('Favorites='+GetSpecialFolder(WinH,CSIDL_FAVORITES));
  FDirs.Add('Drives='+GetSpecialFolder(WinH,CSIDL_DRIVES));
  FDirs.Add('Fonts='+GetSpecialFolder(WinH,CSIDL_FONTS));
  FDirs.Add('History='+GetSpecialFolder(WinH,CSIDL_HISTORY));
  FDirs.Add('Internet='+GetSpecialFolder(WinH,CSIDL_INTERNET));
  FDirs.Add('InternetCache='+GetSpecialFolder(WinH,CSIDL_INTERNET_CACHE));
  FDirs.Add('NetWork='+GetSpecialFolder(WinH,CSIDL_NETWORK));
  FDirs.Add('NetHood='+GetSpecialFolder(WinH,CSIDL_NETHOOD));
  FDirs.Add('MyDocuments='+GetSpecialFolder(WinH,CSIDL_PERSONAL));
  FDirs.Add('PrintHood='+GetSpecialFolder(WinH,CSIDL_PRINTHOOD));
  FDirs.Add('Printers='+GetSpecialFolder(WinH,CSIDL_PRINTERS));
  FDirs.Add('Programs='+GetSpecialFolder(WinH,CSIDL_PROGRAMS));
  FDirs.Add('Recent='+GetSpecialFolder(WinH,CSIDL_RECENT));
  FDirs.Add('SendTo='+GetSpecialFolder(WinH,CSIDL_SENDTO));
  FDirs.Add('StartMenu='+GetSpecialFolder(WinH,CSIDL_STARTMENU));
  FDirs.Add('StartUp='+GetSpecialFolder(WinH,CSIDL_STARTUP));
  FDirs.Add('Templates='+GetSpecialFolder(WinH,CSIDL_TEMPLATES));
  s:=ReverseString(FDirs.Values['Desktop']);
  s:=ReverseString(Copy(s,Pos('\',s)+1,255));
  FDirs.Add('Profile='+s);
  FEnv.Clear;
  GetEnvironment(FEnv);
  FSysLangDefID:=Format('$%.4x',[GetSystemDefaultLangID]);

  {$IFDEF ERROR_INTERCEPT}PopTrace;{$ENDIF};
end;

procedure TOperatingSystem.Report;
var
  i: Integer;
  s: string;
begin
  {$IFDEF ERROR_INTERCEPT}PushTrace(FModes,Self,'Report'); {$ENDIF}
  with sl do begin
    if Standalone then ReportHeader(sl);

    Add('<OperatingSystem classname="TOperatingSystem">');
    case Platform of
      opWin31: s:='Windows 3.1x';
      opWin9x: s:='Windows 9x';
      opWinNT: s:='Windows NT';
    end;
    Add(Format('<data name="Platform" type="string">%s</data>',[s]));

    Add(Format('<data name="VersionName" type="string">%s</data>',[CheckXMLValue(Version)]));
    Add(Format('<data name="MajorVersion" type="integer">%d</data>',[MajorVersion]));
    Add(Format('<data name="MinorVersion" type="integer">%d</data>',[MinorVersion]));
    Add(Format('<data name="Build" type="integer">%d</data>',[BuildNumber]));
    Add(Format('<data name="CSD" type="string">%s</data>',[CSD]));
    Add(Format('<data name="ProductID" type="string">%s</data>',[CheckXMLValue(ProductID)]));
    Add(Format('<data name="ProductKey" type="string">%s</data>',[CheckXMLValue(ProductKey)]));
    Add(Format('<data name="RegisteredUser" type="string">%s</data>',[CheckXMLValue(RegisteredUser)]));
    Add(Format('<data name="RegisteredOrganisation" type="string">%s</data>',[CheckXMLValue(RegisteredOrg)]));
    Add(Format('<data name="DVDRegion" type="string">%s</data>',[DVDRegion]));

    Add('<section name="Environment">');
    for i:=0 to Environment.Count-1 do
      Add(Format('<data name="%s" type="string">%s</data>',[CheckXMLValue(Environment.Names[i]),CheckXMLValue(Environment.Values[Environment.Names[i]])]));
    Add('</section>');

    Add('<section name="Folders">');
    for i:=0 to Folders.Count-1 do
      Add(Format('<data name="%s" type="string">%s</data>',[CheckXMLValue(Folders.Names[i]),CheckXMLValue(Folders.Values[Folders.Names[i]])]));
    Add('</section>');

    Add('</OperatingSystem>');

    if IsNT then
      NTSpecific.Report(sl,False);
    TimeZone.Report(sl,False);
    Internet.Report(sl,False);
    LocaleInfo.Report(sl,False);

    if Standalone then ReportFooter(sl);
  end;
  {$IFDEF ERROR_INTERCEPT}PopTrace;{$ENDIF}
end;


procedure TOperatingSystem.SetMode(const Value: TExceptionModes);
begin
  FModes:=Value;
  if Assigned(Internet) then
    Internet.ExceptionModes:=FModes;
  if Assigned(LocaleInfo) then
    LocaleInfo.ExceptionModes:=FModes;
  if Assigned(NTSpecific) then
    NTSpecific.ExceptionModes:=FModes;
  if Assigned(TimeZone) then
    TimeZone.ExceptionModes:=FModes;
end;

{ TNTSpecific }

procedure TNTSpecific.GetInfo;
var
  VersionInfo: TOSVersionInfoEx;
  OS :TOSVersionInfo;
  s: string;
  sl: TStringList;
const
  rkProductTypeNT = {HKEY_LOCAL_MACHINE}'\System\CurrentControlSet\Control\ProductOptions';
  rvProductType = 'ProductType';
  rkHotFixes = {HKEY_LOCAL_MACHINE\}'SOFTWARE\Microsoft\Windows NT\CurrentVersion\HotFix';
begin
  {$IFDEF ERROR_INTERCEPT}PushTrace(FModes,Self,'GetInfo');{$ENDIF}

  FHotFixes:='';
  ZeroMemory(@OS,SizeOf(OS));
  OS.dwOSVersionInfoSize:=SizeOf(OS);
  Windows.GetVersionEx(OS);
  if (OS.dwPlatformId=VER_PLATFORM_WIN32_NT) and (OS.dwMajorVersion=5) then begin
    ZeroMemory(@VersionInfo,SizeOf(VersionInfo));
    VersionInfo.dwOSVersionInfoSize:=SizeOf(VersionInfo);
    if GetVersionEx(@VersionInfo) then begin
      case VersionInfo.wProductType of
        VER_NT_WORKSTATION: FProduct:=ptWorkStation;
        VER_NT_DOMAIN_CONTROLLER: FProduct:=ptAdvancedServer;
        VER_NT_SERVER: FProduct:=ptServer;
      end;
      if (VersionInfo.dwMajorVersion>=5) and (VersionInfo.wProductType=VER_NT_DOMAIN_CONTROLLER) then
        FProduct:=ptServer;
      FSuites:=[];
      if VersionInfo.wSuiteMask and VER_SUITE_SMALLBUSINESS<>0 then
        FSuites:=FSuites+[suSmallBusiness];
      if VersionInfo.wSuiteMask and VER_SUITE_ENTERPRISE<>0 then begin
        FSuites:=FSuites+[suEnterprise];
        FProduct:=ptAdvancedServer;
      end;
      if VersionInfo.wSuiteMask and VER_SUITE_BACKOFFICE<>0 then
        FSuites:=FSuites+[suBackOffice];
      if VersionInfo.wSuiteMask and VER_SUITE_COMMUNICATIONS<>0 then
        FSuites:=FSuites+[suCommunications];
      if VersionInfo.wSuiteMask and VER_SUITE_TERMINAL<>0 then
        FSuites:=FSuites+[suTerminal];
      if VersionInfo.wSuiteMask and VER_SUITE_SMALLBUSINESS_RESTRICTED<>0 then
        FSuites:=FSuites+[suSmallBusinessRestricted];
      if VersionInfo.wSuiteMask and VER_SUITE_EMBEDDEDNT<>0 then
        FSuites:=FSuites+[suEmbeddedNT];
      if VersionInfo.wSuiteMask and VER_SUITE_DATACENTER<>0 then begin
        FSuites:=FSuites+[suDataCenter];
        FProduct:=ptDataCenter;
      end;
      if VersionInfo.wSuiteMask and VER_SUITE_SINGLEUSERTS<>0 then
        FSuites:=FSuites+[suSingleUserTS];
      if VersionInfo.wSuiteMask and VER_SUITE_PERSONAL<>0 then
        FSuites:=FSuites+[suPersonal];
      if VersionInfo.wSuiteMask and VER_SUITE_BLADE<>0 then begin
        FSuites:=FSuites+[suBlade];
        FProduct:=ptWeb;
      end;
      if VersionInfo.wSuiteMask and VER_SUITE_EMBEDDED_RESTRICTED<>0 then
        FSuites:=FSuites+[suEmbeddedRestricted];

      FSPMajorVer:=VersionInfo.wServicePackMajor;
      FSPMinorVer:=VersionInfo.wServicePackMinor;
    end;
  end;
  with TRegistry.Create do begin
    RootKey:=HKEY_LOCAL_MACHINE;
    if FProduct=ptUnknown then begin
      if OpenKeyReadOnly(rkProductTypeNT) then begin
        s:=ReadString(rvProductType);
        if s='WinNT' then
          FProduct:=ptWorkStation
        else
          if s='ServerNT' then
            FProduct:=ptServer
          else
            if s='LanmanNT' then
              FProduct:=ptAdvancedServer;
        CloseKey;
      end;
    end;
    if OpenKeyReadOnly(rkHotFixes) then begin
      sl:=TStringList.Create;
      GetKeyNames(sl);
      FHotFixes:=sl.CommaText;
      CloseKey;
      sl.Free;
    end;
    Free;
  end;

  {$IFDEF ERROR_INTERCEPT}PopTrace;{$ENDIF};
end;

function TNTSpecific.GetProductTypeStr(PT: TNTProductType): string;
begin
  Result:='Unknown';
  case Mitec_Routines.OS of
    osNT3,osNT4: case PT of
                   ptWorkstation   : Result:='Workstation';
                   ptServer        : Result:='Server';
                   ptAdvancedServer: Result:='Enterprise Server'
                 end;
    os2K       : case PT of
                   ptWorkstation   : Result:='Professional';
                   ptServer        : Result:='Server';
                   ptAdvancedServer: Result:='Advanced Server';
                   ptDataCenter    : Result:='Datacenter Server';
                 end;
    osXP       : if suPersonal in InstalledSuites then
                   Result:='Home Edition'
                 else
                   Result:='Professional';
    osNET      : case PT of
                   ptServer        : Result:='Standard Edition';
                   ptAdvancedServer: Result:='Enterprise Edition';
                   ptDataCenter    : Result:='Datacenter Edition';
                   ptWeb           : Result:='Web Edition'
                 end;
  end;

end;

procedure TNTSpecific.Report;
begin
  {$IFDEF ERROR_INTERCEPT}PushTrace(FModes,Self,'Report'); {$ENDIF}
  with sl do begin
    if Standalone then ReportHeader(sl);
    Add('<NTSpecific classname="TNTSpecific">');

    Add(Format('<data name="ProductType" type="string">%s</data>',[GetProductTypeStr(ProductType)]));
    Add(Format('<data name="MSSmallBusinessServer" type="boolean">%d</data>',
               [integer(suSmallBusiness in InstalledSuites)]));
    Add(Format('<data name="Windows2000AdvancedServer" type="boolean">%d</data>',
               [integer(suEnterprise in InstalledSuites)]));
    Add(Format('<data name="MSBackOfficeComponents" type="boolean">%d</data>',
               [integer(suBackOffice in InstalledSuites)]));
    Add(Format('<data name="Communications" type="boolean">%d</data>',
               [integer(suCommunications in InstalledSuites)]));
    Add(Format('<data name="TerminalServices" type="boolean">%d</data>',
               [integer(suTerminal in InstalledSuites)]));
    Add(Format('<data name="MSSmallBusinessServerWithRestrictiveClientLicenseInForce" type="boolean">%d</data>',
               [integer(suSmallBusinessRestricted in InstalledSuites)]));
    Add(Format('<data name="EmbeddedNT" type="boolean">%d</data>',
               [integer(suEmbeddedNT in InstalledSuites)]));
    Add(Format('<data name="Windows2000DatacenterServer" type="boolean">%d</data>',
               [integer(suDataCenter in InstalledSuites)]));
    Add(Format('<data name="ServicePack_MajorVersion" type="integer">%d</data>',[ServicePackMajorVersion]));
    Add(Format('<data name="ServicePack_MinorVersion" type="integer">%d</data>',[ServicePackMinorVersion]));
    Add(Format('<data name="HotFixes" type="string">%s</data>',[HotFixes]));
    Add('</NTSpecific>');
    if Standalone then ReportFooter(sl);
  end;
  {$IFDEF ERROR_INTERCEPT}PopTrace;{$ENDIF}
end;

procedure TNTSpecific.GetInstalledSuitesStr(var sl: TStringList);
begin
  with sl do begin
    Add(Format('Microsoft Small Business Server=%d',
               [integer(suSmallBusiness in InstalledSuites)]));
    Add(Format('Enterprise Edition/Advanced Server=%d',
               [integer(suEnterprise in InstalledSuites)]));
    Add(Format('Microsoft BackOffice Components=%d',
               [integer(suBackOffice in InstalledSuites)]));
    Add(Format('Communications=%d',
               [integer(suCommunications in InstalledSuites)]));
    Add(Format('Microsoft Small Business Server with the restrictive client license in force=%d',
               [integer(suSmallBusinessRestricted in InstalledSuites)]));
    Add(Format('Terminal Services=%d',
               [integer(suTerminal in InstalledSuites)]));
    Add(Format('Embedded NT=%d',
               [integer(suEmbeddedNT in InstalledSuites)]));
    Add(Format('Datacenter Edition/Datacenter Server=%d',
               [integer(suDataCenter in InstalledSuites)]));
    Add(Format('Web Edition=%d',
               [integer(suBlade in InstalledSuites)]));
  end;
end;

constructor TInternet.Create;
begin
  ExceptionModes:=[emExceptionStack];
  FProxy:=TStringList.Create;
end;

destructor TInternet.Destroy;
begin
  FProxy.Destroy;
  inherited;
end;

function TInternet.GetConnTypeStr(ACType: TConnectionType): string;
begin
  case ACType of
    ctNone: Result:='None';
    ctDialup: Result:='Dialup';
    ctLAN: Result:='LAN';
  end;
end;

procedure TInternet.GetInfo;
var
  i: Integer;
begin
  {$IFDEF ERROR_INTERCEPT}PushTrace(FModes,Self,'GetInfo');{$ENDIF}

  FBrowser:=GetDefaultBrowser;
  FMailClient:=GetdefaultMailClient;
  FCType:=GetConnectionType;
  FProxy.CommaText:=StringReplace(GetProxyserver,';',',',[rfIgnorecase,rfReplaceAll]);
  for i:=0 to FProxy.Count-1 do
    if Pos('=',FProxy[i])=0 then
      FProxy[i]:=Format('%d=',[i])+FProxy[i];

  {$IFDEF ERROR_INTERCEPT}PopTrace;{$ENDIF};
end;

procedure TInternet.Report;
var
  i: Integer;
begin
  {$IFDEF ERROR_INTERCEPT}PushTrace(FModes,Self,'Report'); {$ENDIF}
  with sl do begin
    if Standalone then ReportHeader(sl);
    Add('<Internet classname="TInternet">');

    Add(Format('<data name="DefaultBrowser" type="string">%s</data>',[CheckXMLValue(DefaultBrowser)]));
    Add(Format('<data name="DefaultMailClient" type="string">%s</data>',[CheckXMLValue(DefaultMailClient)]));
    Add(Format('<data name="Connection" type="string">%s</data>',[GetConnTypeStr(ConnectionType)]));
    Add('<section name="ProxyServer">');
    for i:=0 to ProxyServer.Count-1 do
      Add(Format('<data name="%s" type="string">%s</data>',[ProxyServer.Names[i],ProxyServer.Values[ProxyServer.Names[i]]]));
    Add('</section>');

    Add('</Internet>');
    if Standalone then ReportFooter(sl);
  end;
  {$IFDEF ERROR_INTERCEPT}PopTrace;{$ENDIF}
end;

procedure TNTSpecific.SetMode(const Value: TExceptionModes);
begin
  FModes := Value;
end;

constructor TNTSpecific.Create;
begin
  ExceptionModes:=[emExceptionStack];
end;

{ TLocaleInfo }

constructor TLocaleInfo.Create;
begin
  ExceptionModes:=[emExceptionStack];
end;

procedure TLocaleInfo.GetInfo;
var
  Buffer: PChar;
  BufLen: Integer;
begin
  BufLen:=255;
  GetMem(Buffer,BufLen);
  try
    {$IFDEF ERROR_INTERCEPT}PushTrace(FModes,Self,'GetInfo');{$ENDIF}

    GetLocaleInfo(LocaleID,LOCALE_SLANGUAGE,Buffer,BufLen);
    FLang:=Buffer;
    GetLocaleInfo(LocaleID,LOCALE_SENGLANGUAGE,Buffer,BufLen);
    FEngLang:=Buffer;
    GetLocaleInfo(LocaleID,LOCALE_SABBREVLANGNAME,Buffer,BufLen);
    FAbbrLang:=Buffer;
    GetLocaleInfo(LocaleID,LOCALE_ICOUNTRY,Buffer,BufLen);
    FCountry:=Buffer;
    GetLocaleInfo(LocaleID,LOCALE_SCOUNTRY,Buffer,BufLen);
    FFCountry:=Buffer;
    GetLocaleInfo(LocaleID,LOCALE_SABBREVCTRYNAME,Buffer,BufLen);
    FAbbrCtry:=Buffer;
    GetLocaleInfo(LocaleID,LOCALE_SLIST,Buffer,BufLen);
    FList:=Buffer;
    GetLocaleInfo(LocaleID,LOCALE_IMEASURE,Buffer,BufLen);
    FMeasure:=TMeasureSystem(StrToInt(string(Buffer)[1]));
    GetLocaleInfo(LocaleID,LOCALE_SDECIMAL,Buffer,BufLen);
    FDecimal:=Buffer;
    GetLocaleInfo(LocaleID,LOCALE_IDIGITS,Buffer,BufLen);
    FDigit:=Buffer;
    GetLocaleInfo(LocaleID,LOCALE_SCURRENCY,Buffer,BufLen);
    FCurrency:=Buffer;
    GetLocaleInfo(LocaleID,LOCALE_SINTLSYMBOL,Buffer,BufLen);
    FIntlSymbol:=Buffer;
    GetLocaleInfo(LocaleID,LOCALE_SMONDECIMALSEP,Buffer,BufLen);
    FMonDecSep:=Buffer;
    GetLocaleInfo(LocaleID,LOCALE_SMONTHOUSANDSEP,Buffer,BufLen);
    FMonThoSep:=Buffer;
    GetLocaleInfo(LocaleID,LOCALE_ICURRDIGITS,Buffer,BufLen);
    FCurrdigit:=Buffer;
    GetLocaleInfo(LocaleID,LOCALE_ICURRENCY,Buffer,BufLen);
    FPCurrMode:=TPositiveCurrencyMode(StrToInt(string(Buffer)[1]));
    GetLocaleInfo(LocaleID,LOCALE_INEGCURR,Buffer,BufLen);
    FNCurrMode:=StringReplace(SNegativeCurrencyMode[StrToInt(string(Buffer)[1])],'$',FCurrency,[rfIgnoreCase]);
    GetLocaleInfo(LocaleID,LOCALE_SDATE,Buffer,BufLen);
    FDate:=Buffer;
    GetLocaleInfo(LocaleID,LOCALE_STIME,Buffer,BufLen);
    FTime:=Buffer;
    GetLocaleInfo(LocaleID,LOCALE_STIMEFORMAT,Buffer,BufLen);
    FTimeFormat:=Buffer;
    GetLocaleInfo(LocaleID,LOCALE_SSHORTDATE,Buffer,BufLen);
    FShortDate:=Buffer;
    GetLocaleInfo(LocaleID,LOCALE_SLONGDATE,Buffer,BufLen);
    FLongDate:=Buffer;
    GetLocaleInfo(LocaleID,LOCALE_IDATE,Buffer,BufLen);
    FShortDateOrdr:=TDateOrder(StrToInt(string(Buffer)[1]));
    GetLocaleInfo(LocaleID,LOCALE_ILDATE,Buffer,BufLen);
    FLongDateOrdr:=TDateOrder(StrToInt(string(Buffer)[1]));
    GetLocaleInfo(LocaleID,LOCALE_ITIME,Buffer,BufLen);
    FTimeFormatSpec:=TTimeFormat(StrToInt(string(Buffer)[1]));
    GetLocaleInfo(LocaleID,LOCALE_ICENTURY,Buffer,BufLen);
    FYearFormat:=TYearFormat(StrToInt(string(Buffer)[1]));
    GetLocaleInfo(LocaleID,LOCALE_STHOUSAND,Buffer,BufLen);
    FMonThoSep:=Buffer;

    {$IFDEF ERROR_INTERCEPT}PopTrace;{$ENDIF};
  finally
    FreeMem(Buffer,BufLen);
  end;
end;

procedure TLocaleInfo.Report;
var
  s: string;
begin
  {$IFDEF ERROR_INTERCEPT}PushTrace(FModes,Self,'Report'); {$ENDIF}
  with sl do begin
    if Standalone then ReportHeader(sl);
    Add('<LocaleInfo classname="TLocaleInfo">');

    Add(Format('<data name="AbbreviateCountryCode" type="string">%s</data>',[CheckXMLValue(AbbreviateCountryCode)]));
    Add(Format('<data name="AbbreviateLanguageCode" type="string">%s</data>',[CheckXMLValue(AbbreviateLanguageName)]));
    Add(Format('<data name="CountryCode" type="string">%s</data>',[CheckXMLValue(CountryCode)]));
    Add(Format('<data name="CurrencyDecimalDigits" type="string">%s</data>',[CurrencyDecimalDigits]));
    Add(Format('<data name="FullCountryCode" type="string">%s</data>',[CheckXMLValue(FullCountryCode)]));
    Add(Format('<data name="FullEnglishLanguageName" type="string">%s</data>',[CheckXMLValue(FullLanguageEnglishName)]));
    Add(Format('<data name="FullLocalizeLanguageName" type="string">%s</data>',[CheckXMLValue(FullLocalizeLanguage)]));
    Add(Format('<data name="IntlMonetarySymbol" type="string">%s</data>',[InternationalMonetarySymbol]));
    Add(Format('<data name="LocalMonetarySymbol" type="string">%s</data>',[LocalMonetarySymbol]));
    case PositiveCurrencyMode of
      Prefix_No_Separation: s:='Prefix_No_Separation';
      Suffix_No_Separation: s:='Suffix_No_Separation';
      Prefix_One_Char_Separation: s:='Prefix_One_Char_Separation';
      Suffix_One_Char_Separation: s:='Suffix_One_Char_Separation';
    end;
    Add(Format('<data name="PositiveCurrencyMode" type="string">%s</data>',[s]));
    Add(Format('<data name="NegativeCurrencyMode" type="string">%s</data>',[NegativeCurrencyMode]));
    Add(Format('<data name="CurrencyDecimalSeparator" type="string">%s</data>',[CurrencyDecimalSeparator]));
    Add(Format('<data name="CurrencyThousandSeparator" type="string">%s</data>',[CurrencyThousandSeparator]));
    Add(Format('<data name="DecimalSeparator" type="string">%s</data>',[DecimalSeparator]));
    Add(Format('<data name="NumberOfDecimalDigits" type="string">%s</data>',[NumberOfDecimalDigits]));
    Add(Format('<data name="ListSeparator" type="string">%s</data>',[ListSeparator]));
    Add(Format('<data name="DateSeparator" type="string">%s</data>',[DateSeparator]));
    case LongDateOrder of
      MDY: s:='M-D-Y';
      DMY: s:='D-M-Y';
      YMD: s:='Y-M-D';
    end;
    Add(Format('<data name="LongDateOrder" type="string">%s</data>',[s]));
    case ShortDateOrder of
      MDY: s:='M-D-Y';
      DMY: s:='D-M-Y';
      YMD: s:='Y-M-D';
    end;
    Add(Format('<data name="ShortDateOrder" type="string">%s</data>',[s]));
    Add(Format('<data name="ShortDateFormat" type="string">%s</data>',[ShortDateFormat]));
    Add(Format('<data name="LongDateFormat" type="string">%s</data>',[LongDateFormat]));
    Add(Format('<data name="TimeFormat" type="string">%s</data>',[TimeFormat]));
    case TimeFormatSpecifier of
      H12: s:='12H';
      H24: s:='24H';
    end;
    Add(Format('<data name="TimeFormatSpecifier" type="string">%s</data>',[s]));
    case YearFormat of
      TwoDigit: s:='Two Digit';
      FourDigit: s:='Four Digit';
    end;
    Add(Format('<data name="YearFormat" type="string">%s</data>',[s]));
    case MeasurementSystem of
      Metric: s:='Metric';
      US: s:='U.S.';
    end;
    Add(Format('<data name="MeasurementSystem" type="string">%s</data>',[s]));

    Add('</LocaleInfo>');
    if Standalone then ReportFooter(sl);
  end;
  {$IFDEF ERROR_INTERCEPT}PopTrace;{$ENDIF}
end;

procedure TInternet.SetMode(const Value: TExceptionModes);
begin
  FModes := Value;
end;

procedure TLocaleInfo.SetMode(const Value: TExceptionModes);
begin
  FModes := Value;
end;

end.

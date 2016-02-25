{*******************************************************}
{                                                       }
{       MiTeC System Information Component              }
{               Engine Detection Part                   }
{           version 8.6.4 for Delphi 5,6,7              }
{                                                       }
{       Copyright © 1997,2004 Michal Mutl               }
{                                                       }
{*******************************************************}

{$INCLUDE MITEC_DEF.INC}

unit MSI_Engines;

interface

uses
  {$IFDEF D6PLUS} Variants, {$ENDIF} MiTeC_WnASPI32, MSI_Common,
  SysUtils, Windows, Classes;

type
  TDirectX = class(TPersistent)
  private
    FVersion: string;
    FDirect3D: TStrings;
    FDirectPlay: TStrings;
    FDirectMusic: TStrings;
    FModes: TExceptionModes;
    procedure SetMode(const Value: TExceptionModes);
  public
    constructor Create;
    destructor Destroy; override;
    procedure GetInfo;
    procedure Report(var sl :TStringList; Standalone: Boolean = True); virtual;
  published
    property ExceptionModes: TExceptionModes read FModes Write SetMode;
    property Version :string read FVersion {$IFNDEF D6PLUS} write FVersion {$ENDIF} stored false;
    property Direct3D :TStrings read FDirect3D {$IFNDEF D6PLUS} write FDirect3D {$ENDIF} stored false;
    property DirectPlay :TStrings read FDirectPlay {$IFNDEF D6PLUS} write FDirectPlay {$ENDIF} stored false;
    property DirectMusic :TStrings read FDirectMusic {$IFNDEF D6PLUS} write FDirectMusic {$ENDIF} stored false;
  end;

  TASPI32 = class(TPersistent)
  private
    FASPI: string;
    FASPIConfig: TASPIConfig;
    FModes: TExceptionModes;
    procedure SetMode(const Value: TExceptionModes);
  public
    constructor Create;
    destructor Destroy; override;
    procedure GetInfo;
    procedure Report(var sl :TStringList; Standalone: Boolean = True); virtual;
    property Configuration: TASPIConfig read FASPIConfig;
  published
    property ExceptionModes: TExceptionModes read FModes Write SetMode;
    property ASPI :string read FASPI {$IFNDEF D6PLUS} write FASPI {$ENDIF} stored False;
  end;

  TEngines = class(TPersistent)
  private
    FBDE: string;
    FODBC: string;
    FDAO: string;
    FADO: string;
    FASPI32: TASPI32;
    FDirectX: TDirectX;
    FModes: TExceptionModes;
    FNET: string;
    FOpenGL: string;
    FIE: string;
    procedure SetMode(const Value: TExceptionModes);
  public
    constructor Create;
    destructor Destroy; override;
    procedure GetInfo;
    procedure Report(var sl :TStringList; Standalone: Boolean = True); virtual;
  published
    property ExceptionModes: TExceptionModes read FModes Write SetMode;

    property ODBC :string read FODBC {$IFNDEF D6PLUS} write FODBC {$ENDIF} stored false;
    property BDE :string read FBDE {$IFNDEF D6PLUS} write FBDE {$ENDIF} stored false;
    property DAO :string read FDAO {$IFNDEF D6PLUS} write FDAO {$ENDIF} stored False;
    property ADO :string read FADO {$IFNDEF D6PLUS} write FADO {$ENDIF} stored False;
    property NET :string read FNET {$IFNDEF D6PLUS} write FNET {$ENDIF} stored False;
    property OpenGL :string read FOpenGL {$IFNDEF D6PLUS} write FOpenGL {$ENDIF} stored False;
    property IE :string read FIE {$IFNDEF D6PLUS} write FIE {$ENDIF} stored False;

    property DirectX: TDirectX read FDirectX {$IFNDEF D6PLUS} write FDirectX {$ENDIF} stored False;
    property ASPI32: TASPI32 read FASPI32 {$IFNDEF D6PLUS} write FASPI32 {$ENDIF} stored False;
  end;

implementation

uses Registry, MiTeC_Routines, COMObj, ActiveX;

{ TDirectX }

constructor TDirectX.Create;
begin
  inherited;
  ExceptionModes:=[emExceptionStack];
  FDirect3D:=TStringlist.Create;
  FDirectPlay:=TStringlist.Create;
  FDirectMusic:=TStringlist.Create;
end;

destructor TDirectX.Destroy;
begin
  FDirect3D.Free;
  FDirectPlay.Free;
  FDirectMusic.Free;
  inherited;
end;

procedure TDirectX.GetInfo;
var
  bdata :pchar;
  sl :tstringlist;
  i :integer;
const
  rkDirectX = {HKEY_LOCAL_MACHINE}'\SOFTWARE\Microsoft\DirectX';
    rvDXVersionNT = 'InstalledVersion';
    rvDXVersion95 = 'Version';
  rkDirect3D = {HKEY_LOCAL_MACHINE}'\SOFTWARE\Microsoft\Direct3D\Drivers';
  rkDirectPlay = {HKEY_LOCAL_MACHINE}'\SOFTWARE\Microsoft\DirectPlay\Services';
  rkDirectMusic = {HKEY_LOCAL_MACHINE}'\SOFTWARE\Microsoft\DirectMusic\SoftwareSynths';
    rvDesc = 'Description';
begin
  {$IFDEF ERROR_INTERCEPT}PushTrace(FModes,Self,'GetInfo'); {$ENDIF}

  with TRegistry.Create do begin
    rootkey:=HKEY_LOCAL_MACHINE;
    if OpenKeyReadOnly(rkDirectX) then begin
      bdata:=stralloc(255);
      if ValueExists(rvDXVersion95) then
        FVersion:=ReadString(rvDXVersion95);
      if FVersion='' then
        if ValueExists(rvDXVersionNT) then
          try
            readbinarydata(rvDXVersionNT,bdata^,4);
            FVersion:=inttostr(lo(integer(bdata^)))+'.'+inttostr(hi(integer(bdata^)));
          except
            try
              readbinarydata(rvDXVersionNT,bdata^,8);
              FVersion:=inttostr(lo(integer(bdata^)))+'.'+inttostr(hi(integer(bdata^)));
            except
            end;
          end;
      closekey;
      strdispose(bdata);
    end;
    FDirect3D.Clear;
    FDirectPlay.Clear;
    FDirectMusic.Clear;
    sl:=tstringlist.create;
    if OpenKeyReadOnly(rkDirect3D) then begin
      getkeynames(sl);
      closekey;
      for i:=0 to sl.count-1 do
        if OpenKeyReadOnly(rkDirect3D+'\'+sl[i]) then begin
          if ValueExists(rvDesc) then
            FDirect3D.Add(ReadString(rvDesc));
          closekey;
        end;
    end;
    if OpenKeyReadOnly(rkDirectPlay) then begin
      getkeynames(sl);
      closekey;
      for i:=0 to sl.count-1 do
        if OpenKeyReadOnly(rkDirectPlay+'\'+sl[i]) then begin
          if ValueExists(rvDesc) then
            FDirectPlay.Add(ReadString(rvDesc));
          closekey;
        end;
    end;
    if OpenKeyReadOnly(rkDirectMusic) then begin
      getkeynames(sl);
      closekey;
      for i:=0 to sl.count-1 do
        if OpenKeyReadOnly(rkDirectMusic+'\'+sl[i]) then begin
          if ValueExists(rvDesc) then
            FDirectMusic.Add(ReadString(rvDesc));
          closekey;
        end;
    end;
    sl.free;
    free;
  end;

  {$IFDEF ERROR_INTERCEPT}PopTrace;{$ENDIF}
end;


procedure TDirectX.Report;
begin
  {$IFDEF ERROR_INTERCEPT}PushTrace(FModes,Self,'Report'); {$ENDIF}
  with sl do begin
    if Standalone then ReportHeader(sl);
    Add('<DirectX classname="TDirectX">');
    if Version<>'' then begin
      Add(Format('<data name="Version" type="string">%s</data>',[Version]));
      Add('<section name="Direct3D">');
      StringsToRep(Direct3D,'Count','Device',sl);
      Add('</section>');
      Add('<section name="DirectPlay">');
      StringsToRep(DirectPlay,'Count','Device',sl);
      Add('</section>');
      Add('<section name="DirectMusic">');
      StringsToRep(DirectMusic,'Count','Device',sl);
      Add('</section>');
    end;
    Add('</DirectX>');
    if Standalone then ReportFooter(sl);
  end;
  {$IFDEF ERROR_INTERCEPT}PopTrace;{$ENDIF}
end;

procedure TDirectX.SetMode(const Value: TExceptionModes);
begin
  FModes := Value;
end;

{ TASPI32 }

constructor TASPI32.Create;
begin
  inherited;
  ExceptionModes:=[emExceptionStack];
  FASPIConfig.Adapter:=TStringList.Create;
  FASPIConfig.ID:=TStringList.Create;
  FASPIConfig.Vendor:=TStringList.Create;
  FASPIConfig.Product:=TStringList.Create;
  FASPIConfig.Typ:=TStringList.Create;
  FASPIConfig.Status:=TStringList.Create;
  FASPIConfig.Revision:=TStringList.Create;
  FASPIConfig.Spec:=TStringList.Create;
end;

destructor TASPI32.Destroy;
begin
  FASPIConfig.Adapter.Free;
  FASPIConfig.ID.Free;
  FASPIConfig.Vendor.Free;
  FASPIConfig.Product.Free;
  FASPIConfig.Typ.Free;
  FASPIConfig.Status.Free;
  FASPIConfig.Revision.Free;
  FASPIConfig.Spec.Free;
  inherited;
end;

procedure TASPI32.GetInfo;
var
  s: string;
  VI: TVersionInfo;
begin
  {$IFDEF ERROR_INTERCEPT}PushTrace(FModes,Self,'GetInfo'); {$ENDIF}

  InitASPI;
  try
  FASPI:='';
  s:=GetWinSysDir;
  if HIBYTE(LOWORD(ExecuteASPI32Test(FASPIConfig)))=SS_COMP then
    if FileSearch(ASPI_DLL,s)='' then
      FASPI:=''
    else begin
      GetFileVerInfo(ASPI_DLL,VI);
      FASPI:=VI.Version;
    end;
  finally
    FreeASPI;
  end;

  {$IFDEF ERROR_INTERCEPT}PopTrace;{$ENDIF}
end;

procedure TASPI32.Report;
var
  i: Integer;
begin
  {$IFDEF ERROR_INTERCEPT}PushTrace(FModes,Self,'Report'); {$ENDIF}
  with sl do begin
    if Standalone then ReportHeader(sl);
    Add('<ASPI32 classname="TASPI32">');
    if ASPI<>'' then begin
      Add(Format('<data name="Version" type="string">%s</data>',[ASPI]));
      for i:=0 to Configuration.Vendor.Count-1 do begin
        Add(Format('<section name="Device_%d">',[i]));
        Add(Format('<data name="Vendor" type="string">%s</data>',[CheckXMLValue(Configuration.Vendor[i])]));
        Add(Format('<data name="Product" type="string">%s</data>',[CheckXMLValue(Configuration.Product[i])]));
        Add(Format('<data name="Revision" type="string">%s</data>',[CheckXMLValue(Configuration.Revision[i])]));
        Add(Format('<data name="Adapter" type="string">%s</data>',[CheckXMLValue(Configuration.Adapter[i])]));
        Add(Format('<data name="ID" type="string">%s</data>',[CheckXMLValue(Configuration.ID[i])]));
        Add(Format('<data name="Type" type="string">%s</data>',[CheckXMLValue(Configuration.Typ[i])]));
        Add(Format('<data name="Status" type="string">%s</data>',[CheckXMLValue(Configuration.Status[i])]));
        Add('</section>');
      end;
    end;
    Add('</ASPI32>');
    if Standalone then ReportFooter(sl);
  end;
  {$IFDEF ERROR_INTERCEPT}PopTrace;{$ENDIF}
end;

procedure TASPI32.SetMode(const Value: TExceptionModes);
begin
  FModes := Value;
end;

{ TEngines }

constructor TEngines.Create;
begin
  inherited;
  FDirectX:=TDirectX.Create;
  FASPI32:=TASPI32.Create;
  ExceptionModes:=[emExceptionStack];
end;

destructor TEngines.Destroy;
begin
  FDirectX.Free;
  FASPI32.Free;
  inherited;
end;

procedure TEngines.GetInfo;
var
  s :string;
  OLEObj: OLEVariant;
  VI: TVersionInfo;
  sl: TStringList;
  i: Integer;
const
  rkBDESettings = {HKEY_LOCAL_MACHINE}'\SOFTWARE\Borland\Database Engine';
    rvBDEDLLPath = 'DLLPATH';
    fnBDEDLL = 'IDAPI32.DLL';
  rkODBCSettings = {HKEY_LOCAL_MACHINE}'\SOFTWARE\ODBC\ODBCINST.INI\ODBC Core\FileList';
    rvODBCCoreDLL = 'ODBC32.DLL';
  rkNET = {HKEY_LOCAL_MACHINE\}'SOFTWARE\Microsoft\.NETFramework';
    rvIR = 'InstallRoot';
  rkSharedDLLs = {HKEY_LOCAL_MACHINE\}'SOFTWARE\Microsoft\Windows\CurrentVersion\SharedDLLs';

  fnSystem = 'system.dll';
  fnOpenGL = 'opengl32.dll';
  fnIE = 'iexplore.exe';

  rkIE = {HKEY_LOCAL_MACHINE\}'SOFTWARE\Microsoft\Internet Explorer';
    rvVersion = 'Version';
  rkIES = {HKEY_LOCAL_MACHINE\}'SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings';
    rvSP = 'MinorVersion';

  { OLE object table class string }
  daoEngine36 = 'DAO.DBEngine.36';
  daoEngine35 = 'DAO.DBEngine.35';
  daoEngine30 = 'DAO.DBEngine';

  adoEngine = 'adodb.connection';

  function GetOLEObject(ProgID: string): OLEVariant;
  var
    idisp: IDispatch;
    ClassID: TCLSID;
    Unknown: IUnknown;
    HR: HRESULT;
  begin
    CoInitialize(nil);
    try
      Result:=null;
      HR:=CLSIDFromProgID(PWideChar(WideString(ProgID)),ClassID);
      if Succeeded(HR) then begin
        HR:=GetActiveObject(ClassID,nil,Unknown);
        if Succeeded(HR) then
          HR:=Unknown.QueryInterface(IDispatch,idisp);
        if not Succeeded(HR) then
          HR:=CoCreateInstance(ClassID,nil,CLSCTX_INPROC_SERVER or CLSCTX_LOCAL_SERVER,IDispatch,idisp);
        if not Succeeded(HR) then
          Result:=null
        else
          Result:=idisp;
      end;
    finally
    end;
  end;

begin
  {$IFDEF ERROR_INTERCEPT}PushTrace(FModes,Self,'GetInfo'); {$ENDIF}

  DirectX.GetInfo;
  ASPI32.GetInfo;

  with TRegistry.Create do begin
    rootkey:=HKEY_LOCAL_MACHINE;
    if OpenKeyReadOnly(rkBDESettings) then begin
      if ValueExists(rvBDEDLLPath) then begin
        s:=ReadString(rvBDEDLLPath);
        GetFileVerInfo(s+'\'+fnBDEDLL,VI);
        FBDE:=VI.Version;
      end;
      closekey;
    end;

    if OpenKeyReadOnly(rkODBCSettings) then begin
      if ValueExists(rvODBCCoreDLL) then begin
        s:=ReadString(rvODBCCoreDLL);
        GetFileVerInfo(s,VI);
        FODBC:=VI.Version
      end;
      closekey;
    end else begin
      s:=FileSearch(rvODBCCoreDLL,GetSysDir);
      GetFileVerInfo(s,VI);
      FODBC:=VI.Version;
    end;

    FNET:='';
    if OpenKeyReadOnly(rkNET) then begin
      if ValueExists(rvIR) then begin
        CloseKey;
        if OpenKeyReadOnly(rkSharedDLLs) then begin
          sl:=TStringList.Create;
          try
            GetValueNames(sl);
            for i:=0 to sl.Count-1 do
              if Pos(fnSystem,Lowercase(sl[i]))>0 then begin
                GetFileVerInfo(sl[i],VI);
                FNET:=VI.Version;
                Break;
              end;
          finally
            sl.Free;
          end;
        end;
      end;
      closekey;
    end;

    FIE:='';
    if OpenKeyReadOnly(rkIE) then begin
      if ValueExists(rvVersion) then begin
        FIE:=ReadString(rvVersion);
        CloseKey;
        if OpenKeyReadOnly(rkIES) then begin
          if ValueExists(rvSP) then begin
            sl:=TStringList.Create;
            sl.CommaText:=StringReplace(ReadString(rvSP),';',',',[rfReplaceAll,rfIgnoreCase]);
            i:=0;
            while i<sl.Count do
              if Trim(sl[i])='' then
                sl.Delete(i)
              else
                Inc(i);
            FIE:=Format('%s (%s)',[FIE,sl.CommaText]);
            sl.Free;
          end;
        end;
      end;
      closekey;
    end;
    if FIE='' then begin
      s:=GetDefaultBrowser;
      if Pos(fnIE,s)>0 then begin
        GetFileVerInfo(s,VI);
        FIE:=VI.Version;
      end;
    end;

    free;
  end;

  s:=FileSearch(fnOpenGL,GetSysDir);
  GetFileVerInfo(s,VI);
  FOpenGL:=VI.Version;

  OLEObj:=GetOLEObject(daoEngine36);
  if TVarData(OLEObj).VType<>varDispatch then
    OLEObj:=GetOLEObject(daoEngine35);
  if TVarData(OLEObj).VType<>varDispatch then
    OLEObj:=GetOLEObject(daoEngine30);
  if TVarData(OLEObj).VType=varDispatch then
    FDAO:=OLEObj.Version;
  OLEObj:=null;

  OLEObj:=GetOLEObject(adoEngine);
  if TVarData(OLEObj).VType=varDispatch then
    FADO:=OLEObj.Version;
  OLEObj:=null;

  {$IFDEF ERROR_INTERCEPT}PopTrace;{$ENDIF}
end;

procedure TEngines.Report;
begin
  {$IFDEF ERROR_INTERCEPT}PushTrace(FModes,Self,'Report'); {$ENDIF}
  with sl do begin
    if Standalone then ReportHeader(sl);
    Add('<Engines classname="TEngines">');
    if ODBC<>'' then
      Add(Format('<data name="ODBC" type="string">%s</data>',[ODBC]));
    if BDE<>'' then
      Add(Format('<data name="BDE" type="string">%s</data>',[BDE]));
    if DAO<>'' then
      Add(Format('<data name="DAO" type="string">%s</data>',[DAO]));
    if ADO<>'' then
      Add(Format('<data name="ADO" type="string">%s</data>',[ADO]));
    if OpenGL<>'' then
      Add(Format('<data name="OpenGL" type="string">%s</data>',[OpenGL]));
    if IE<>'' then
      Add(Format('<data name="Internet Explorer" type="string">%s</data>',[IE]));
    if NET<>'' then
      Add(Format('<data name="Microsoft .NET Framework" type="string">%s</data>',[NET]));
    Add('</Engines>');
    DirectX.Report(sl,False);
    ASPI32.Report(sl,False);
    if Standalone then ReportFooter(sl);
  end;
  {$IFDEF ERROR_INTERCEPT}PopTrace;{$ENDIF}
end;


procedure TEngines.SetMode(const Value: TExceptionModes);
begin
  FModes := Value;
  if Assigned(ASPI32) then
    ASPI32.ExceptionModes:=FModes;
  if Assigned(DirectX) then
    DirectX.ExceptionModes:=FModes;
end;

end.

{*******************************************************}
{                                                       }
{       MiTeC System Information Component              }
{               Display Detection Part                  }
{           version 8.5 for Delphi 5,6,7                }
{                                                       }
{       Copyright © 1997,2003 Michal Mutl               }
{                                                       }
{*******************************************************}

{$INCLUDE MITEC_DEF.INC}

unit MSI_Display;

interface

uses
  MSI_Common, SysUtils, Windows, Classes;

type
  TDisplayInfo = record
    DAC,
    Chipset,
    BIOS: string;
    Memory: integer;
  end;

const
  _SHADEBLENDCAPS = 120; // Shading and blending caps
  {$EXTERNALSYM _SHADEBLENDCAPS}
  _COLORMGMTCAPS  = 121; // Color Management caps
  {$EXTERNALSYM _COLORMGMTCAPS}

  // Shading and blending caps

  SB_NONE          = $00000000;
  {$EXTERNALSYM SB_NONE}
  SB_CONST_ALPHA   = $00000001;
  {$EXTERNALSYM SB_CONST_ALPHA}
  SB_PIXEL_ALPHA   = $00000002;
  {$EXTERNALSYM SB_PIXEL_ALPHA}
  SB_PREMULT_ALPHA = $00000004;
  {$EXTERNALSYM SB_PREMULT_ALPHA}

  SB_GRAD_RECT = $00000010;
  {$EXTERNALSYM SB_GRAD_RECT}
  SB_GRAD_TRI  = $00000020;
  {$EXTERNALSYM SB_GRAD_TRI}

// Color Management caps

  CM_NONE       = $00000000;
  {$EXTERNALSYM CM_NONE}
  CM_DEVICE_ICM = $00000001;
  {$EXTERNALSYM CM_DEVICE_ICM}
  CM_GAMMA_RAMP = $00000002;
  {$EXTERNALSYM CM_GAMMA_RAMP}
  CM_CMYK_COLOR = $00000004;
  {$EXTERNALSYM CM_CMYK_COLOR}

type
  TCurveCap = (ccCircles,ccPieWedges,ccChords,ccEllipses,ccWideBorders,ccStyledBorders,
               ccWideStyledBorders,ccInteriors,ccRoundedRects);
  TLineCap = (lcPolylines,lcMarkers,lcMultipleMarkers,lcWideLines,lcStyledLines,
               lcWideStyledLines,lcInteriors);
  TPolygonCap = (pcAltFillPolygons,pcRectangles,pcWindingFillPolygons,pcSingleScanlines,
                 pcWideBorders,pcStyledBorders,pcWideStyledBorders,pcInteriors);
  TRasterCap = (rcRequiresBanding,rcTransferBitmaps,rcBitmaps64K,rcSetGetDIBits,
                rcSetDIBitsToDevice,rcFloodfills,rcWindows2xFeatures,rcPaletteBased,
                rcScaling,rcStretchBlt,rcStretchDIBits);
  TTextCap = (tcCharOutPrec,tcStrokeOutPrec,tcStrokeClipPrec,tcCharRotation90,
              tcCharRotationAny,tcScaleIndependent,tcDoubledCharScaling,tcIntMultiScaling,
              tcAnyMultiExactScaling,tcDoubleWeightChars,tcItalics,tcUnderlines,
              tcStrikeouts,tcRasterFonts,tcVectorFonts,tcNoScrollUsingBlts);

  TShadeBlendCap = (sbcConstAlpha,sbcGradRect,sbcGradTri, sbcPixelAlpha,sbcPremultAlpha);

  TColorMgmtCap = (cmcCMYKColor, cmcDeviceICM, cmcGammaRamp);

  TCurveCaps = set of TCurveCap;
  TLineCaps = set of TLineCap;
  TPolygonCaps = set of TPolygonCap;
  TRasterCaps = set of TRasterCap;
  TTextCaps = set of TTextCap;
  TShadeBlendCaps = set of TShadeBlendCap;
  TColorMgmtCaps = set of TColorMgmtCap;

  TDisplay = class(TPersistent)
  private
    FVertRes: integer;
    FColorDepth: integer;
    FHorzRes: integer;
    FBIOSDate: string;
    FBIOSVersion: string;
    FPixelDiagonal: integer;
    FPixelHeight: integer;
    FVertSize: integer;
    FPixelWidth: integer;
    FHorzSize: integer;
    FTechnology: string;
    FCurveCaps: TCurveCaps;
    FLineCaps: TLineCaps;
    FPolygonCaps: TPolygonCaps;
    FRasterCaps: TRasterCaps;
    FTextCaps: TTextCaps;
    FMemory: integer;
    FChipset: string;
    FAdapter: string;
    FDAC: string;
    FVidModes: TStrings;
    FFontSize: DWORD;
    FVideoService, FVideoDriver, FVideoDevPar: string;
    FVRR: DWORD;
    FBIOSString: string;
    FDDV: integer;
    FShadeBlendCaps: TShadeBlendCaps;
    FColorMgmtCaps: TColorMgmtCaps;
    FModes: TExceptionModes;
    procedure SetMode(const Value: TExceptionModes);
  public
    constructor Create;
    destructor Destroy; override;
    procedure GetInfo;
    procedure Report(var sl :TStringList; Standalone: Boolean = True); virtual;
  published
    property ExceptionModes: TExceptionModes read FModes Write SetMode;
    property Adapter :string read FAdapter {$IFNDEF D6PLUS} write FAdapter {$ENDIF} stored false;
    property DAC :string read FDAC {$IFNDEF D6PLUS} write FDAC {$ENDIF} stored false;
    property Chipset :string read FChipset {$IFNDEF D6PLUS} write FChipset {$ENDIF} stored false;
    property Memory :Integer read FMemory {$IFNDEF D6PLUS} write FMemory {$ENDIF} stored false;
    property HorzRes :integer read FHorzRes {$IFNDEF D6PLUS} write FHorzRes {$ENDIF} stored false;
    property VertRes :integer read FVertRes {$IFNDEF D6PLUS} write FVertRes {$ENDIF} stored false;
    property HorzSize :integer read FHorzSize {$IFNDEF D6PLUS} write FHorzSize {$ENDIF} stored false;
    property VertSize :integer read FVertSize {$IFNDEF D6PLUS} write FVertSize {$ENDIF} stored false;
    property ColorDepth :integer read FColorDepth {$IFNDEF D6PLUS} write FColorDepth {$ENDIF} stored false;
    property DeviceDriverVersion :integer read FDDV {$IFNDEF D6PLUS} write FDDV {$ENDIF} stored false;
    // BIOS info is available only under NT
    property BIOSVersion :string read FBIOSVersion {$IFNDEF D6PLUS} write FBIOSVersion {$ENDIF} stored false;
    property BIOSDate :string read FBIOSDate {$IFNDEF D6PLUS} write FBIOSDate {$ENDIF} stored false;
    property BIOSString :string read FBIOSString {$IFNDEF D6PLUS} write FBIOSString {$ENDIF} stored false;

    property Technology :string read FTechnology {$IFNDEF D6PLUS} write FTechnology {$ENDIF} stored false;
    property PixelWidth :integer read FPixelWidth {$IFNDEF D6PLUS} write FPixelWidth {$ENDIF} stored false;
    property PixelHeight :integer read FPixelHeight {$IFNDEF D6PLUS} write FPixelHeight {$ENDIF} stored false;
    property PixelDiagonal :integer read FPixelDiagonal {$IFNDEF D6PLUS} write FPixelDiagonal {$ENDIF} stored false;
    property RasterCaps :TRasterCaps read FRasterCaps {$IFNDEF D6PLUS} write FRasterCaps {$ENDIF} stored false;
    property CurveCaps :TCurveCaps read FCurveCaps {$IFNDEF D6PLUS} write FCurveCaps {$ENDIF} stored false;
    property LineCaps :TLineCaps read FLineCaps {$IFNDEF D6PLUS} write FLineCaps {$ENDIF} stored false;
    property PolygonCaps :TPolygonCaps read FPolygonCaps {$IFNDEF D6PLUS} write FPolygonCaps {$ENDIF} stored false;
    property TextCaps :TTextCaps read FTextCaps {$IFNDEF D6PLUS} write FTextCaps {$ENDIF} stored false;
    property ShadeBlendCaps :TShadeBlendCaps read FShadeBlendCaps {$IFNDEF D6PLUS} write FShadeBlendCaps {$ENDIF} stored false;
    property ColorMgmtCaps :TColorMgmtCaps read FColorMgmtCaps {$IFNDEF D6PLUS} write FColorMgmtCaps {$ENDIF} stored false;
    property Modes :TStrings read FVidModes {$IFNDEF D6PLUS} write FVidModes {$ENDIF} stored False;
    property FontResolution: DWORD read FFontSize {$IFNDEF D6PLUS} write FFontSize {$ENDIF} stored False;
    property VerticalRefreshRate: DWORD read FVRR {$IFNDEF D6PLUS} write FVRR {$ENDIF} stored False;
  end;

procedure GetCurveCapsStr(CurveCaps :TCurveCaps; ACaps :TStringList);
procedure GetLineCapsStr(LineCaps :TLineCaps; ACaps :TStringList);
procedure GetPolygonCapsStr(PolygonCaps :TPolygonCaps; ACaps :TStringList);
procedure GetRasterCapsStr(RasterCaps :TRasterCaps; ACaps :TStringList);
procedure GetTextCapsStr(TextCaps :TTextCaps; ACaps :TStringList);
procedure GetShadeBlendCapsStr(ShadeBlendCaps :TShadeBlendCaps; ACaps :TStringList);
procedure GetColorMgmtCapsStr(ColorMgmtCaps :TColorMgmtCaps; ACaps :TStringList);

implementation

uses Registry, MiTeC_Routines, MSI_Devices, MiTeC_StrUtils;

{ TDisplay }

procedure GetWin9xDisplayInfo(ADriverName: string; var InfoRecord: TDisplayInfo);
const
  rk = {HKEY_LOCAL_MACHINE}'\System\CurrentControlSet\Services\Class\%s\INFO';
  rvDAC = 'DacType';
  rvChip = 'ChipType';
  rvMem = 'VideoMemory';
begin
  with TRegistry.Create do begin
    RootKey:=HKEY_LOCAL_MACHINE;
    if OpenKeyReadOnly(Format(rk,[ADriverName])) then begin
      if ValueExists(rvDAC) then
        InfoRecord.DAC:=ReadString(rvDAC);
      if ValueExists(rvChip) then
        InfoRecord.Chipset:=ReadString(rvChip);
      if ValueExists(rvMem) then
        InfoRecord.Memory:=ReadInteger(rvMem);
      CloseKey;
    end;
    Free;
  end;
end;

procedure GetWinNTDisplayInfo(ADeviceParam,AServiceName: string; var InfoRecord: TDisplayInfo);
var
  StrData :PChar;
  rk: string;
const
  rk1 = {HKEY_LOCAL_MACHINE}'\SYSTEM\CurrentControlSet\Services\%s\Device0';
  rk2 = {HKEY_LOCAL_MACHINE}'\SYSTEM\CurrentControlSet\Control\Video\%s\0000';
  rvDAC = 'HardwareInformation.DacType';
  rvChip = 'HardwareInformation.ChipType';
  rvMem = 'HardwareInformation.MemorySize';
  rvBIOS = 'HardwareInformation.BiosString';
begin
  with TRegistry.Create do begin
    RootKey:=HKEY_LOCAL_MACHINE;
    if ADeviceParam<>'' then
      rk:=Format(rk2,[ADeviceparam])
    else
      rk:=Format(rk1,[AServiceName]);
    if OpenKeyReadOnly(rk) then begin
      StrData:=StrAlloc(255);
      if ValueExists(rvDAC) then
        try
          ReadBinaryData(rvDAC,StrData^,255);
          InfoRecord.DAC:=WideCharToString(PWideChar(StrData));
        except
        end;
      if ValueExists(rvChip) then
        try
          ReadBinaryData(rvChip,StrData^,255);
          InfoRecord.Chipset:=WideCharToString(PWideChar(StrData));
        except
        end;
      if ValueExists(rvBIOS) then
        try
          ReadBinaryData(rvBIOS,StrData^,255);
          InfoRecord.BIOS:=WideCharToString(PWideChar(StrData));
        except
        end;
      if ValueExists(rvMem) then
        try
          {IntData:=StrAlloc(255);
          ReadBinaryData(rvMem,IntData,4);
          InfoRecord.Memory:=integer(IntData);
          StrDispose(IntData);}
          ReadBinaryData(rvMem,InfoRecord.Memory,4);
        except
        end;
      StrDispose(StrData);
      CloseKey;
    end;
    Free;
  end;
end;

procedure GetVideoBIOSInfo(var Version, Date: string);
var
  sl: TStringList;
const
  rk = {HKEY_LOCAL_MACHINE}'\HARDWARE\DESCRIPTION\System';
  rvVideoBiosDate = 'VideoBiosDate';
  rvVideoBiosVersion = 'VideoBiosVersion';
begin
  Version:='';
  sl:=TStringList.Create;
  try
    sl.Text:=ReadRegistryValueAsString(HKEY_LOCAL_MACHINE,rk,rvVideoBiosVersion,False);
    if sl.Count>0 then
      Version:=sl[0];
  finally
    sl.Free;
  end;
  Date:=ReadRegistryValueAsString(HKEY_LOCAL_MACHINE,rk,rvVideoBiosDate,False);
end;


procedure TDisplay.GetInfo;
var
  i :integer;
  DevMode : TDevMode;
  InfoRec: TDisplayInfo;
  s: string;
  lDC: hDC;
begin
  {$IFDEF ERROR_INTERCEPT}PushTrace(FModes,Self,'GetInfo'); {$ENDIF}

  if Win32Platform=VER_PLATFORM_WIN32_NT then
    GetWinNTDisplayInfo(FVideoDevPar,FVideoService,InfoRec)
  else
    GetWin9xDisplayInfo(FVideoDriver,InfoRec);

  FDAC:=InfoRec.DAC;
  FChipset:=InfoRec.Chipset;
  FMemory:=InfoRec.Memory;
  FBIOSString:=InfoRec.BIOS;

  GetVideoBIOSInfo(FBIOSVersion,FBIOSDate);

  lDC:=GetDC(0);
  try
  FDDV:=GetDeviceCaps(lDC,windows.DRIVERVERSION);
  FFontSize:=GetDeviceCaps(lDC,LOGPIXELSY);
  FHorzRes:=GetDeviceCaps(lDC,windows.HORZRES);
  FVertRes:=GetDeviceCaps(lDC,windows.VERTRES);
  FHorzSize:=GetDeviceCaps(lDC,windows.HORZSIZE);
  FVertSize:=GetDeviceCaps(lDC,windows.VERTSIZE);
  FColorDepth:=GetDeviceCaps(lDC,BITSPIXEL);

  if Win32Platform=VER_PLATFORM_WIN32_NT then
    FVRR:=GetDeviceCaps(lDC,VREFRESH)
  else
    FVRR:=0;
  case GetDeviceCaps(lDC,windows.TECHNOLOGY) of
    DT_PLOTTER:    FTechnology:='Vector Plotter';
    DT_RASDISPLAY: FTechnology:='Raster Display';
    DT_RASPRINTER: FTechnology:='Raster Printer';
    DT_RASCAMERA:  FTechnology:='Raster Camera';
    DT_CHARSTREAM: FTechnology:='Character Stream';
    DT_METAFILE:   FTechnology:='Metafile';
    DT_DISPFILE:   FTechnology:='Display File';
  end;
  FPixelWidth:=GetDeviceCaps(lDC,ASPECTX);
  FPixelHeight:=GetDeviceCaps(lDC,ASPECTY);
  FPixelDiagonal:=GetDeviceCaps(lDC,ASPECTXY);
  FCurveCaps:=[];
  if GetDeviceCaps(lDC,windows.CURVECAPS)<>CC_NONE then begin
    if (GetDeviceCaps(lDC,windows.CURVECAPS) and CC_CIRCLES)=CC_CIRCLES then
      FCurveCaps:=FCurveCaps+[ccCircles];
    if (GetDeviceCaps(lDC,windows.CURVECAPS) and CC_PIE)=CC_PIE then
      FCurveCaps:=FCurveCaps+[ccPieWedges];
    if (GetDeviceCaps(lDC,windows.CURVECAPS) and CC_CHORD)=CC_CHORD then
      FCurveCaps:=FCurveCaps+[ccChords];
    if (GetDeviceCaps(lDC,windows.CURVECAPS) and CC_ELLIPSES)=CC_ELLIPSES then
      FCurveCaps:=FCurveCaps+[ccEllipses];
    if (GetDeviceCaps(lDC,windows.CURVECAPS) and CC_WIDE)=CC_WIDE then
      FCurveCaps:=FCurveCaps+[ccWideBorders];
    if (GetDeviceCaps(lDC,windows.CURVECAPS) and CC_STYLED)=CC_STYLED then
      FCurveCaps:=FCurveCaps+[ccStyledBorders];
    if (GetDeviceCaps(lDC,windows.CURVECAPS) and CC_WIDESTYLED)=CC_WIDESTYLED then
      FCurveCaps:=FCurveCaps+[ccWideStyledBorders];
    if (GetDeviceCaps(lDC,windows.CURVECAPS) and CC_INTERIORS)=CC_INTERIORS then
      FCurveCaps:=FCurveCaps+[ccInteriors];
    if (GetDeviceCaps(lDC,windows.CURVECAPS) and CC_ROUNDRECT)=CC_ROUNDRECT then
      FCurveCaps:=FCurveCaps+[ccRoundedRects];
  end;
  FLineCaps:=[];
  if GetDeviceCaps(lDC,windows.LINECAPS)<>LC_NONE then begin
    if (GetDeviceCaps(lDC,windows.LINECAPS) and LC_POLYLINE)=LC_POLYLINE then
      FLineCaps:=FLineCaps+[lcPolylines];
    if (GetDeviceCaps(lDC,windows.LINECAPS) and LC_MARKER)=LC_MARKER then
      FLineCaps:=FLineCaps+[lcMarkers];
    if (GetDeviceCaps(lDC,windows.LINECAPS) and LC_POLYMARKER)=LC_POLYMARKER then
      FLineCaps:=FLineCaps+[lcMultipleMarkers];
    if (GetDeviceCaps(lDC,windows.LINECAPS) and LC_WIDE)=LC_WIDE then
      FLineCaps:=FLineCaps+[lcWideLines];
    if (GetDeviceCaps(lDC,windows.LINECAPS) and LC_STYLED)=LC_STYLED then
      FLineCaps:=FLineCaps+[lcStyledLines];
    if (GetDeviceCaps(lDC,windows.LINECAPS) and LC_WIDESTYLED)=LC_WIDESTYLED then
      FLineCaps:=FLineCaps+[lcWideStyledLines];
    if (GetDeviceCaps(lDC,windows.LINECAPS) and LC_INTERIORS)=LC_INTERIORS then
      FLineCaps:=FLineCaps+[lcInteriors];
  end;
  FPolygonCaps:=[];
  if GetDeviceCaps(lDC,POLYGONALCAPS)<>PC_NONE then begin
    if (GetDeviceCaps(lDC,POLYGONALCAPS) and PC_POLYGON)=PC_POLYGON then
      FPolygonCaps:=FPolygonCaps+[pcAltFillPolygons];
    if (GetDeviceCaps(lDC,POLYGONALCAPS) and PC_RECTANGLE)=PC_RECTANGLE then
      FPolygonCaps:=FPolygonCaps+[pcRectangles];
    if (GetDeviceCaps(lDC,POLYGONALCAPS) and PC_WINDPOLYGON)=PC_WINDPOLYGON then
      FPolygonCaps:=FPolygonCaps+[pcWindingFillPolygons];
    if (GetDeviceCaps(lDC,POLYGONALCAPS) and PC_SCANLINE)=PC_SCANLINE then
      FPolygonCaps:=FPolygonCaps+[pcSingleScanlines];
    if (GetDeviceCaps(lDC,POLYGONALCAPS) and PC_WIDE)=PC_WIDE then
      FPolygonCaps:=FPolygonCaps+[pcWideBorders];
    if (GetDeviceCaps(lDC,POLYGONALCAPS) and PC_STYLED)=PC_STYLED then
      FPolygonCaps:=FPolygonCaps+[pcStyledBorders];
    if (GetDeviceCaps(lDC,POLYGONALCAPS) and PC_WIDESTYLED)=PC_WIDESTYLED then
      FPolygonCaps:=FPolygonCaps+[pcWideStyledBorders];
    if (GetDeviceCaps(lDC,POLYGONALCAPS) and PC_INTERIORS)=PC_INTERIORS then
      FPolygonCaps:=FPolygonCaps+[pcInteriors];
  end;
  FRasterCaps:=[];
  if (GetDeviceCaps(lDC,windows.RASTERCAPS) and RC_BANDING)=RC_BANDING then
    FRasterCaps:=FRasterCaps+[rcRequiresBanding];
  if (GetDeviceCaps(lDC,windows.RASTERCAPS) and RC_BITBLT)=RC_BITBLT then
    FRasterCaps:=FRasterCaps+[rcTransferBitmaps];
  if (GetDeviceCaps(lDC,windows.RASTERCAPS) and RC_BITMAP64)=RC_BITMAP64 then
    FRasterCaps:=FRasterCaps+[rcBitmaps64K];
  if (GetDeviceCaps(lDC,windows.RASTERCAPS) and RC_DI_BITMAP)=RC_DI_BITMAP then
    FRasterCaps:=FRasterCaps+[rcSetGetDIBits];
  if (GetDeviceCaps(lDC,windows.RASTERCAPS) and RC_DIBTODEV)=RC_DIBTODEV then
    FRasterCaps:=FRasterCaps+[rcSetDIBitsToDevice];
  if (GetDeviceCaps(lDC,windows.RASTERCAPS) and RC_FLOODFILL)=RC_FLOODFILL then
    FRasterCaps:=FRasterCaps+[rcFloodfills];
  if (GetDeviceCaps(lDC,windows.RASTERCAPS) and RC_GDI20_OUTPUT)=RC_GDI20_OUTPUT then
    FRasterCaps:=FRasterCaps+[rcWindows2xFeatures];
  if (GetDeviceCaps(lDC,windows.RASTERCAPS) and RC_PALETTE)=RC_PALETTE then
    FRasterCaps:=FRasterCaps+[rcPaletteBased];
  if (GetDeviceCaps(lDC,windows.RASTERCAPS) and RC_SCALING)=RC_SCALING then
    FRasterCaps:=FRasterCaps+[rcScaling];
  if (GetDeviceCaps(lDC,windows.RASTERCAPS) and RC_STRETCHBLT)=RC_STRETCHBLT then
    FRasterCaps:=FRasterCaps+[rcStretchBlt];
  if (GetDeviceCaps(lDC,windows.RASTERCAPS) and RC_STRETCHDIB)=RC_STRETCHDIB then
    FRasterCaps:=FRasterCaps+[rcStretchDIBits];
  FTextCaps:=[];
  if (GetDeviceCaps(lDC,windows.TEXTCAPS) and TC_OP_CHARACTER)=TC_OP_CHARACTER then
    FTextCaps:=FTextCaps+[tcCharOutPrec];
  if (GetDeviceCaps(lDC,windows.TEXTCAPS) and TC_OP_STROKE)=TC_OP_STROKE then
    FTextCaps:=FTextCaps+[tcStrokeOutPrec];
  if (GetDeviceCaps(lDC,windows.TEXTCAPS) and TC_CP_STROKE)=TC_CP_STROKE then
    FTextCaps:=FTextCaps+[tcStrokeClipPrec];
  if (GetDeviceCaps(lDC,windows.TEXTCAPS) and TC_CR_90)=TC_CR_90 then
    FTextCaps:=FTextCaps+[tcCharRotation90];
  if (GetDeviceCaps(lDC,windows.TEXTCAPS) and TC_CR_ANY)=TC_CR_ANY then
    FTextCaps:=FTextCaps+[tcCharRotationAny];
  if (GetDeviceCaps(lDC,windows.TEXTCAPS) and TC_SF_X_YINDEP)=TC_SF_X_YINDEP then
    FTextCaps:=FTextCaps+[tcScaleIndependent];
  if (GetDeviceCaps(lDC,windows.TEXTCAPS) and TC_SA_DOUBLE)=TC_SA_DOUBLE then
    FTextCaps:=FTextCaps+[tcDoubledCharScaling];
  if (GetDeviceCaps(lDC,windows.TEXTCAPS) and TC_SA_INTEGER)=TC_SA_INTEGER then
    FTextCaps:=FTextCaps+[tcIntMultiScaling];
  if (GetDeviceCaps(lDC,windows.TEXTCAPS) and TC_SA_CONTIN)=TC_SA_CONTIN then
    FTextCaps:=FTextCaps+[tcAnyMultiExactScaling];
  if (GetDeviceCaps(lDC,windows.TEXTCAPS) and TC_EA_DOUBLE)=TC_EA_DOUBLE then
    FTextCaps:=FTextCaps+[tcDoubleWeightChars];
  if (GetDeviceCaps(lDC,windows.TEXTCAPS) and TC_IA_ABLE)=TC_IA_ABLE then
    FTextCaps:=FTextCaps+[tcItalics];
  if (GetDeviceCaps(lDC,windows.TEXTCAPS) and TC_UA_ABLE)=TC_UA_ABLE then
    FTextCaps:=FTextCaps+[tcUnderlines];
  if (GetDeviceCaps(lDC,windows.TEXTCAPS) and  TC_SO_ABLE)=TC_SO_ABLE then
    FTextCaps:=FTextCaps+[tcStrikeouts];
  if (GetDeviceCaps(lDC,windows.TEXTCAPS) and TC_RA_ABLE)=TC_RA_ABLE then
    FTextCaps:=FTextCaps+[tcRasterFonts];
  if (GetDeviceCaps(lDC,windows.TEXTCAPS) and TC_VA_ABLE)=TC_VA_ABLE then
    FTextCaps:=FTextCaps+[tcVectorFonts];
  if (GetDeviceCaps(lDC,windows.TEXTCAPS) and TC_SCROLLBLT)=TC_SCROLLBLT then
    FTextCaps:=FTextCaps+[tcNoScrollUsingBlts];
  FShadeBlendCaps:=[];
  if GetDeviceCaps(lDC,_SHADEBLENDCAPS)<>SB_NONE then begin
    if (GetDeviceCaps(lDC,_SHADEBLENDCAPS) and SB_CONST_ALPHA)=SB_CONST_ALPHA then
      FShadeBlendCaps:=FShadeBlendCaps+[sbcCONSTALPHA];
    if (GetDeviceCaps(lDC,_SHADEBLENDCAPS) and SB_GRAD_RECT)=SB_GRAD_RECT then
      FShadeBlendCaps:=FShadeBlendCaps+[sbcGRADRECT];
    if (GetDeviceCaps(lDC,_SHADEBLENDCAPS) and SB_GRAD_TRI)=SB_GRAD_TRI then
      FShadeBlendCaps:=FShadeBlendCaps+[sbcGRADTRI];
    if (GetDeviceCaps(lDC,_SHADEBLENDCAPS) and SB_PIXEL_ALPHA)=SB_PIXEL_ALPHA then
      FShadeBlendCaps:=FShadeBlendCaps+[sbcPIXELALPHA];
    if (GetDeviceCaps(lDC,_SHADEBLENDCAPS) and SB_PREMULT_ALPHA)=SB_PREMULT_ALPHA then
      FShadeBlendCaps:=FShadeBlendCaps+[sbcPREMULTALPHA];
  end;
  FColorMgmtCaps:=[];
  if GetDeviceCaps(lDC,_COLORMGMTCAPS)<>CM_NONE then begin
    if (GetDeviceCaps(lDC,_COLORMGMTCAPS) and CM_CMYK_COLOR)=CM_CMYK_COLOR then
      FColorMgmtCaps:=FColorMgmtCaps+[cmcCMYKColor];
    if (GetDeviceCaps(lDC,_COLORMGMTCAPS) and CM_DEVICE_ICM)=CM_DEVICE_ICM then
      FColorMgmtCaps:=FColorMgmtCaps+[cmcDeviceICM];
    if (GetDeviceCaps(lDC,_COLORMGMTCAPS) and CM_GAMMA_RAMP)=CM_GAMMA_RAMP then
      FColorMgmtCaps:=FColorMgmtCaps+[cmcGammaRamp];
  end;

  FVidModes.Clear;
  i:=0;
  while EnumDisplaySettings(nil,i,Devmode) do
    with Devmode do begin
      s:=Format('%d x %d - %d bit',[dmPelsWidth,dmPelsHeight,dmBitsPerPel]);
      if FVidModes.IndexOf(s)=-1 then
        FVidModes.Add(s);
      Inc(i);
    end;
  finally
  ReleaseDC(0, lDC);
  end;

  {$IFDEF ERROR_INTERCEPT}PopTrace;{$ENDIF}
end;

procedure GetCurveCapsStr;
begin
  with ACaps do begin
    Add(Format('Circles=%d',[integer(ccCircles in CurveCaps)]));
    Add(Format('Pie Wedges=%d',[integer(ccPieWedges in CurveCaps)]));
    Add(Format('Chords=%d',[integer(ccChords in CurveCaps)]));
    Add(Format('Ellipses=%d',[integer(ccEllipses in CurveCaps)]));
    Add(Format('Wide Borders=%d',[integer(ccWideBorders in CurveCaps)]));
    Add(Format('Styled Borders=%d',[integer(ccStyledBorders in CurveCaps)]));
    Add(Format('Wide and Styled Borders=%d',[integer(ccWideStyledBorders in CurveCaps)]));
    Add(Format('Interiors=%d',[integer(ccInteriors in CurveCaps)]));
    Add(Format('Rounded Rectangles=%d',[integer(ccRoundedRects in CurveCaps)]));
  end;
end;

procedure GetLineCapsStr;
begin
  with ACaps do begin
    Add(Format('Polylines=%d',[integer(lcPolylines in LineCaps)]));
    Add(Format('Markers=%d',[integer(lcMarkers in LineCaps)]));
    Add(Format('Multiple Markers=%d',[integer(lcMultipleMarkers in LineCaps)]));
    Add(Format('Wide Lines=%d',[integer(lcWideLines in LineCaps)]));
    Add(Format('Styled Lines=%d',[integer(lcStyledLines in LineCaps)]));
    Add(Format('Wide and Styled Lines=%d',[integer(lcWideStyledLines in LineCaps)]));
    Add(Format('Interiors=%d',[integer(lcInteriors in LineCaps)]));
  end;
end;

procedure GetPolygonCapsStr;
begin
  with ACaps do begin
    Add(Format('Alternate Fill Polygons=%d',[integer(pcAltFillPolygons in PolygonCaps)]));
    Add(Format('Rectangles=%d',[integer(pcRectangles in PolygonCaps)]));
    Add(Format('Winding Fill Polygons=%d',[integer(pcWindingFillPolygons in PolygonCaps)]));
    Add(Format('Single Scanlines=%d',[integer(pcSingleScanlines in PolygonCaps)]));
    Add(Format('Wide Borders=%d',[integer(pcWideBorders in PolygonCaps)]));
    Add(Format('Styled Borders=%d',[integer(pcStyledBorders in PolygonCaps)]));
    Add(Format('Wide and Styled Borders=%d',[integer(pcWideStyledBorders in PolygonCaps)]));
    Add(Format('Interiors=%d',[integer(pcInteriors in PolygonCaps)]));
  end;
end;

procedure GetRasterCapsStr;
begin
  with ACaps do begin
    Add(Format('Requires Banding=%d',[integer(rcRequiresBanding in RasterCaps)]));
    Add(Format('Can Transfer Bitmaps=%d',[integer(rcTransferBitmaps in RasterCaps)]));
    Add(Format('Supports Bitmaps > 64K=%d',[integer(rcBitmaps64K in RasterCaps)]));
    Add(Format('Supports SetDIBits and GetDIBits=%d',[integer(rcSetGetDIBits in RasterCaps)]));
    Add(Format('Supports SetDIBitsToDevice=%d',[integer(rcSetDIBitsToDevice in RasterCaps)]));
    Add(Format('Can Perform Floodfills=%d',[integer(rcFloodfills in RasterCaps)]));
    Add(Format('Supports Windows 2.0 Features=%d',[integer(rcWindows2xFeatures in RasterCaps)]));
    Add(Format('Palette Based=%d',[integer(rcPaletteBased in RasterCaps)]));
    Add(Format('Scaling=%d',[integer(rcScaling in RasterCaps)]));
    Add(Format('Supports StretchBlt=%d',[integer(rcStretchBlt in RasterCaps)]));
    Add(Format('Supports StretchDIBits=%d',[integer(rcStretchDIBits in RasterCaps)]));
  end;
end;

procedure GetTextCapsStr;
begin
  with ACaps do begin
    Add(Format('Capable of Character Output Precision=%d',[integer(tcCharOutPrec in TextCaps)]));
    Add(Format('Capable of Stroke Output Precision=%d',[integer(tcStrokeOutPrec in TextCaps)]));
    Add(Format('Capable of Stroke Clip Precision=%d',[integer(tcStrokeClipPrec in TextCaps)]));
    Add(Format('Supports 90 Degree Character Rotation=%d',[integer(tcCharRotation90 in TextCaps)]));
    Add(Format('Supports Character Rotation to Any Angle=%d',[integer(tcCharRotationAny in TextCaps)]));
    Add(Format('X And Y Scale Independent=%d',[integer(tcScaleIndependent in TextCaps)]));
    Add(Format('Supports Doubled Character Scaling=%d',[integer(tcDoubledCharScaling in TextCaps)]));
    Add(Format('Supports Integer Multiples Only When Scaling=%d',[integer(tcIntMultiScaling in TextCaps)]));
    Add(Format('Supports Any Multiples For Exact Character Scaling=%d',[integer(tcAnyMultiExactScaling in TextCaps)]));
    Add(Format('Supports Double Weight Characters=%d',[integer(tcDoubleWeightChars in TextCaps)]));
    Add(Format('Supports Italics=%d',[integer(tcItalics in TextCaps)]));
    Add(Format('Supports Underlines=%d',[integer(tcUnderlines in TextCaps)]));
    Add(Format('Supports Strikeouts=%d',[integer(tcStrikeouts in TextCaps)]));
    Add(Format('Supports Raster Fonts=%d',[integer(tcRasterFonts in TextCaps)]));
    Add(Format('Supports Vector Fonts=%d',[integer(tcVectorFonts in TextCaps)]));
    Add(Format('Cannot Scroll Using Blts=%d',[integer(tcNoScrollUsingBlts in TextCaps)]));
  end;
end;

constructor TDisplay.Create;
var
  i: integer;
begin
  inherited;

  ExceptionModes:=[emExceptionStack];

  FVidModes:=TStringList.Create;

  with TDevices.Create do begin
    GetInfo;
    for i:=0 to DeviceCount-1 do
      if Devices[i].DeviceClass=dcDisplay then begin
        //if Pos('0000',Devices[i].Driver)>0 then begin
          if Devices[i].FriendlyName='' then
            FAdapter:=Devices[i].Description
          else
            FAdapter:=Devices[i].FriendlyName;
          FVideoService:=Devices[i].Service;
          FVideoDriver:=Devices[i].Driver;
          FVideoDevPar:=Devices[i].DeviceParam;
          Break;
        //end;
      end;
    Free;
  end;
end;

destructor TDisplay.Destroy;
begin
  FVidModes.Free;
  inherited;
end;

procedure TDisplay.Report;
begin
  {$IFDEF ERROR_INTERCEPT}PushTrace(FModes,Self,'Report'); {$ENDIF}
  with sl do begin
    if Standalone then ReportHeader(sl);
    Add('<Display classname="TDisplay">');
    Add(Format('<data name="Adapter" type="string">%s</data>',[CheckXMLValue(Adapter)]));
    Add(Format('<data name="Chipset" type="string">%s</data>',[CheckXMLValue(Chipset)]));
    Add(Format('<data name="DAC" type="string">%s</data>',[CheckXMLValue(DAC)]));
    Add(Format('<data name="MemorySize" type="integer" unit="B">%d</data>',[Memory]));
    Add(Format('<data name="BIOSVersion" type="string">%s</data>',[CheckXMLValue(BIOSVersion)]));
    Add(Format('<data name="BIOSDate" type="string">%s</data>',[CheckXMLValue(BIOSDate)]));
    Add(Format('<data name="BIOSString" type="string">%s</data>',[CheckXMLValue(BIOSString)]));
    Add(Format('<data name="Technology" type="string">%s</data>',[Technology]));
    Add(Format('<data name="DeviceDriverVersion" type="integer">%d</data>',[DeviceDriverVersion]));
    Add(Format('<data name="HorizontalResolution" type="integer" unit="px">%d</data>',[HorzRes]));
    Add(Format('<data name="VerticalResolution" type="integer" unit="px">%d</data>',[VertRes]));
    Add(Format('<data name="HorizontalSize" type="integer" unit="mm">%d</data>',[HorzSize]));
    Add(Format('<data name="VerticalSize" type="integer" unit="mm">%d</data>',[VertSize]));
    Add(Format('<data name="ColorDepth" type="integer" unit="b">%d</data>',[ColorDepth]));
    Add(Format('<data name="PixelWidth" type="integer">%d</data>',[PixelWidth]));
    Add(Format('<data name="PixelHeight" type="integer">%d</data>',[PixelHeight]));
    Add(Format('<data name="PixelDiagonal" type="integer">%d</data>',[PixelDiagonal]));
    Add(Format('<data name="FontResolution" type="integer" unit="dpi">%d</data>',[FontResolution]));
    Add(Format('<data name="VerticalRefreshRate" type="integer" unit="Hz">%d</data>',[VerticalRefreshRate]));
    Add('<section name="VideoModes">');
    StringsToRep(Modes,'Count','Mode',sl);
    Add('</section>');
    Add('<section name="CurveCapabilities">');
    Add(Format('<data name="Circles" type="boolean">%d</data>',[integer(ccCircles in CurveCaps)]));
    Add(Format('<data name="PieWedges" type="boolean">%d</data>',[integer(ccPieWedges in CurveCaps)]));
    Add(Format('<data name="Chords" type="boolean">%d</data>',[integer(ccChords in CurveCaps)]));
    Add(Format('<data name="Ellipses" type="boolean">%d</data>',[integer(ccEllipses in CurveCaps)]));
    Add(Format('<data name="WideBorders" type="boolean">%d</data>',[integer(ccWideBorders in CurveCaps)]));
    Add(Format('<data name="StyledBorders" type="boolean">%d</data>',[integer(ccStyledBorders in CurveCaps)]));
    Add(Format('<data name="WideAndStyledBorders" type="boolean">%d</data>',[integer(ccWideStyledBorders in CurveCaps)]));
    Add(Format('<data name="Interiors" type="boolean">%d</data>',[integer(ccInteriors in CurveCaps)]));
    Add(Format('<data name="RoundedRectangles" type="boolean">%d</data>',[integer(ccRoundedRects in CurveCaps)]));
    Add('</section>');
    Add('<section name="LineCapabilities">');
    Add(Format('<data name="Polylines" type="boolean">%d</data>',[integer(lcPolylines in LineCaps)]));
    Add(Format('<data name="Markers" type="boolean">%d</data>',[integer(lcMarkers in LineCaps)]));
    Add(Format('<data name="MultipleMarkers" type="boolean">%d</data>',[integer(lcMultipleMarkers in LineCaps)]));
    Add(Format('<data name="WideLines" type="boolean">%d</data>',[integer(lcWideLines in LineCaps)]));
    Add(Format('<data name="StyledLines" type="boolean">%d</data>',[integer(lcStyledLines in LineCaps)]));
    Add(Format('<data name="WideAndStyledLines" type="boolean">%d</data>',[integer(lcWideStyledLines in LineCaps)]));
    Add(Format('<data name="Interiors" type="boolean">%d</data>',[integer(lcInteriors in LineCaps)]));
    Add('</section>');
    Add('<section name="PolygonCapabilities">');
    Add(Format('<data name="AlternateFillPolygons" type="boolean">%d</data>',[integer(pcAltFillPolygons in PolygonCaps)]));
    Add(Format('<data name="Rectangles" type="boolean">%d</data>',[integer(pcRectangles in PolygonCaps)]));
    Add(Format('<data name="WindingFillPolygons" type="boolean">%d</data>',[integer(pcWindingFillPolygons in PolygonCaps)]));
    Add(Format('<data name="SingleScanlines" type="boolean">%d</data>',[integer(pcSingleScanlines in PolygonCaps)]));
    Add(Format('<data name="WideBorders" type="boolean">%d</data>',[integer(pcWideBorders in PolygonCaps)]));
    Add(Format('<data name="StyledBorders" type="boolean">%d</data>',[integer(pcStyledBorders in PolygonCaps)]));
    Add(Format('<data name="WideAndStyledBorders" type="boolean">%d</data>',[integer(pcWideStyledBorders in PolygonCaps)]));
    Add(Format('<data name="Interiors" type="boolean">%d</data>',[integer(pcInteriors in PolygonCaps)]));
    Add('</section>');
    Add('<section name="RasterCapabilities">');
    Add(Format('<data name="RequiresBanding" type="boolean">%d</data>',[integer(rcRequiresBanding in RasterCaps)]));
    Add(Format('<data name="BitmapsTransferSupport" type="boolean">%d</data>',[integer(rcTransferBitmaps in RasterCaps)]));
    Add(Format('<data name="LargeBitmapSupport" type="boolean">%d</data>',[integer(rcBitmaps64K in RasterCaps)]));
    Add(Format('<data name="SetGetDIBitsSupport" type="boolean">%d</data>',[integer(rcSetGetDIBits in RasterCaps)]));
    Add(Format('<data name="SetDIBitsToDeviceSupport" type="boolean">%d</data>',[integer(rcSetDIBitsToDevice in RasterCaps)]));
    Add(Format('<data name="FloodfillsSupport" type="boolean">%d</data>',[integer(rcFloodfills in RasterCaps)]));
    Add(Format('<data name="Win20FeaturesSupport" type="boolean">%d</data>',[integer(rcWindows2xFeatures in RasterCaps)]));
    Add(Format('<data name="PaletteBased" type="boolean">%d</data>',[integer(rcPaletteBased in RasterCaps)]));
    Add(Format('<data name="Scaling" type="boolean">%d</data>',[integer(rcScaling in RasterCaps)]));
    Add(Format('<data name="StretchBltSupport" type="boolean">%d</data>',[integer(rcStretchBlt in RasterCaps)]));
    Add(Format('<data name="StretchDIBitsSupport" type="boolean">%d</data>',[integer(rcStretchDIBits in RasterCaps)]));
    Add('</section>');
    Add('<section name="TextCapabilities">');
    Add(Format('<data name="CapableOfCharacterOutputPrecision" type="boolean">%d</data>',[integer(tcCharOutPrec in TextCaps)]));
    Add(Format('<data name="CapableOfStrokeOutputPrecision" type="boolean">%d</data>',[integer(tcStrokeOutPrec in TextCaps)]));
    Add(Format('<data name="CapableOfStrokeClipPrecision" type="boolean">%d</data>',[integer(tcStrokeClipPrec in TextCaps)]));
    Add(Format('<data name="Suports90DegreeCharacterRotation" type="boolean">%d</data>',[integer(tcCharRotation90 in TextCaps)]));
    Add(Format('<data name="SupportsCharacterRotationToAnyAngle" type="boolean">%d</data>',[integer(tcCharRotationAny in TextCaps)]));
    Add(Format('<data name="XYScaleIndependent" type="boolean">%d</data>',[integer(tcScaleIndependent in TextCaps)]));
    Add(Format('<data name="SupportsDoubledCharacterScaling" type="boolean">%d</data>',[integer(tcDoubledCharScaling in TextCaps)]));
    Add(Format('<data name="SupportsIntegerMultiplesOnlyWhenScaling" type="boolean">%d</data>',[integer(tcIntMultiScaling in TextCaps)]));
    Add(Format('<data name="SupportsAnyMultiplesForExactCharacterScaling" type="boolean">%d</data>',[integer(tcAnyMultiExactScaling in TextCaps)]));
    Add(Format('<data name="SupportsDoubleWeightCharacters" type="boolean">%d</data>',[integer(tcDoubleWeightChars in TextCaps)]));
    Add(Format('<data name="SupportsItalics" type="boolean">%d</data>',[integer(tcItalics in TextCaps)]));
    Add(Format('<data name="SupportsUnderlines" type="boolean">%d</data>',[integer(tcUnderlines in TextCaps)]));
    Add(Format('<data name="SupportsStrikeouts" type="boolean">%d</data>',[integer(tcStrikeouts in TextCaps)]));
    Add(Format('<data name="SupportsRasterFonts" type="boolean">%d</data>',[integer(tcRasterFonts in TextCaps)]));
    Add(Format('<data name="SupportsVectorFonts" type="boolean">%d</data>',[integer(tcVectorFonts in TextCaps)]));
    Add(Format('<data name="CannotScrollUsingBlts" type="boolean">%d</data>',[integer(tcNoScrollUsingBlts in TextCaps)]));
    Add('</section>');
    Add('<section name="ShadeBlendCapabilities">');
    Add(Format('<data name="Source Constant Alpha handling" type="boolean">%d</data>',[integer(sbcConstAlpha in ShadeBlendCaps)]));
    Add(Format('<data name="GradientFill rectangles" type="boolean">%d</data>',[integer(sbcGradRect in ShadeBlendCaps)]));
    Add(Format('<data name="GradientFill triangles" type="boolean">%d</data>',[integer(sbcGradTri in ShadeBlendCaps)]));
    Add(Format('<data name="Per-pixel alpha handling" type="boolean">%d</data>',[integer(sbcPixelAlpha in ShadeBlendCaps)]));
    Add(Format('<data name="Premultiplied alpha handling" type="boolean">%d</data>',[integer(sbcPremultAlpha in ShadeBlendCaps)]));
    Add('</section>');
    Add('<section name="ColorManagementCapabilities">');
    Add(Format('<data name="CMYK color space ICC color profile" type="boolean">%d</data>',[integer(cmcCMYKColor in ColorMgmtCaps)]));
    Add(Format('<data name="ICM performation" type="boolean">%d</data>',[integer(cmcDeviceICM in ColorMgmtCaps)]));
    Add(Format('<data name="Gamma Ramp support" type="boolean">%d</data>',[integer(cmcGammaRamp in ColorMgmtCaps)]));
    Add('</section>');

    Add('</Display>');
    if Standalone then ReportFooter(sl);
  end;
  {$IFDEF ERROR_INTERCEPT}PopTrace;{$ENDIF}
end;

procedure GetColorMgmtCapsStr;
begin
  with ACaps do begin
    Add(Format('CMYK color space ICC color profile=%d',[integer(cmcCMYKColor in ColorMgmtCaps)]));
    Add(Format('ICM performation=%d',[integer(cmcDeviceICM in ColorMgmtCaps)]));
    Add(Format('Gamma Ramp support=%d',[integer(cmcGammaRamp in ColorMgmtCaps)]));
  end;
end;

procedure GetShadeBlendCapsStr;
begin
  with ACaps do begin
    Add(Format('Source Constant Alpha handling=%d',[integer(sbcConstAlpha in ShadeBlendCaps)]));
    Add(Format('GradientFill rectangles=%d',[integer(sbcGradRect in ShadeBlendCaps)]));
    Add(Format('GradientFill triangles=%d',[integer(sbcGradTri in ShadeBlendCaps)]));
    Add(Format('Per-pixel alpha handling=%d',[integer(sbcPixelAlpha in ShadeBlendCaps)]));
    Add(Format('Premultiplied alpha handling=%d',[integer(sbcPremultAlpha in ShadeBlendCaps)]));
  end;
end;

procedure TDisplay.SetMode(const Value: TExceptionModes);
begin
  FModes:=Value;
end;

end.

unit WIL;

interface

uses
  Windows, Classes, Graphics, SysUtils, DXDraws, DirectX, DIB, wmUtil, HUtil32,ZLibx;

var
  g_boUseDIBSurface: Boolean = TRUE; // FALSE;    2005.5.8修改 ，为True时，支持256色以上
  UseDIBSurface: Boolean = TRUE; 
  BoWilNoCache: Boolean = FALSE;
  ColorDeep: TPixelFormat = pf16Bit; // 颜色深度

type
  TLibType = (ltLoadBmp, ltLoadMemory, ltLoadMunual, ltUseCache);

   //有时间标签的Bmp
  TBmpImage = record
    bmp: TBitmap;
    LatestTime: integer;
  end;
  PTBmpImage = ^TBmpImage;

   //以下是WIL文件的定义
  TBmpImageArr = array[0..MaxListSize div 4] of TBmpImage;
  TDxImageArr = array[0..MaxListSize div 4] of TDxImage;

  PTBmpImageArr = ^TBmpImageArr;
  PTDxImageArr = ^TDxImageArr;

  TWMImages = class(TComponent)
  private
    FFileName: string; //WIL文件名
    FImageCount: integer; //图象总数
    FLibType: TLibType; //图象装载方式
    FileType: Byte;
    FDxDraw: TDxDraw;
    FDDraw: TDirectDraw;
    FMaxMemorySize: integer;
    FInitized: boolean;
    ImgArr: PTDxImageArr;
    BmpArr: PTBmpImageArr;
    IndexList: TList;
    FFileSize: Integer;
    Stream: TFileStream;
    FAppr: integer;
    FBitFormat: TPixelFormat;
    FBytesPerPixels: byte;
    procedure LoadAllData;
    procedure LoadAllDataBmp;
    procedure LoadIndex(idxfile: string);
    procedure LoadDxImage(position: integer; pdximg: PTDxImage); overload;
    procedure LoadDxImage(position: PTWISImageInfo; pdximg: PTDxImage); overload;
    procedure LoadBmpImage(position: integer; pbmpimg: PTBmpImage); overload;
    procedure LoadBmpImage(position: integer; var pbmpimg: TBitmap; var px, py: integer); overload;
    procedure FreeOldMemorys;
    function FGetImageSurface(index: integer): TDirectDrawSurface;
    procedure FSetDxDraw(fdd: TDxDraw);
    procedure FreeOldBmps;
    function FGetImageBitmap(index: integer): TBitmap;
    procedure LoadPalette;
    procedure FreeBitmap(index: integer);
    function GetImage(index: integer; var px, py: integer): TDirectDrawSurface;
    function GetCachedSurface(index: integer): TDirectDrawSurface;
    function DeCodeWisImage(CodeMake: Byte; SCode, DCode: Pointer; Ssize: Integer; X, Y: Word): Boolean;
    function GetCachedBitmap(index: integer): TBitmap; overload;
  protected
    lsDib: TDib;
    lsBitmap: TBitmap;
    memchecktime: longword;
  public
    MainPalette: TRgbQuads;
    header: TWMImageHeader;
    wzlheader : TWzlHeader;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Initialize;
    procedure Finalize;
    procedure ClearCache;
    procedure DrawZoom(paper: TCanvas; x, y, index: integer; zoom: Real);
    procedure DrawZoomEx(paper: TCanvas; x, y, index: integer; zoom: Real; leftzero: Boolean);
    function GetCachedImage(index: integer; var px, py: integer): TDirectDrawSurface;
    function GetCachedBitmap(index: integer; var px, py: integer): TBitmap; overload;
    property Images[index: integer]: TDirectDrawSurface read FGetImageSurface;
    property Bitmaps[Index: Integer]: TBitmap read FGetImageBitmap;
    property DDraw: TDirectDraw read FDDraw write FDDraw;
  published
    property FileName: string read FFileName write FFileName;
    property ImageCount: integer read FImageCount;
    property DxDraw: TDxDraw read FDxDraw write FSetDxDraw;
    property LibType: TLibType read FLibType write FLibType;
    property MaxMemorySize: integer read FMaxMemorySize write FMaxMemorySize;
    property Appr: integer read FAppr write FAppr;
  end;

function TDXDrawRGBQuadsToPaletteEntries(const RGBQuads: TRGBQuads; AllowPalette256: Boolean): TPaletteEntries;
function PixelFormatToBitsPerPel(pf: TPixelFormat): smallint;
procedure ChangeDIBPixelFormat(adib: TDIB; pf: TPixelFormat);

procedure Register;

implementation

var
  ColorArray: array[0..1023] of Byte = (
    $00, $00, $00, $00, $00, $00, $80, $00, $00, $80, $00, $00, $00, $80, $80,
    $00,
    $80, $00, $00, $00, $80, $00, $80, $00, $80, $80, $00, $00, $C0, $C0, $C0,
    $00,
    $97, $80, $55, $00, $C8, $B9, $9D, $00, $73, $73, $7B, $00, $29, $29, $2D,
    $00,
    $52, $52, $5A, $00, $5A, $5A, $63, $00, $39, $39, $42, $00, $18, $18, $1D,
    $00,
    $10, $10, $18, $00, $18, $18, $29, $00, $08, $08, $10, $00, $71, $79, $F2,
    $00,
    $5F, $67, $E1, $00, $5A, $5A, $FF, $00, $31, $31, $FF, $00, $52, $5A, $D6,
    $00,
    $00, $10, $94, $00, $18, $29, $94, $00, $00, $08, $39, $00, $00, $10, $73,
    $00,
    $00, $18, $B5, $00, $52, $63, $BD, $00, $10, $18, $42, $00, $99, $AA, $FF,
    $00,
    $00, $10, $5A, $00, $29, $39, $73, $00, $31, $4A, $A5, $00, $73, $7B, $94,
    $00,
    $31, $52, $BD, $00, $10, $21, $52, $00, $18, $31, $7B, $00, $10, $18, $2D,
    $00,
    $31, $4A, $8C, $00, $00, $29, $94, $00, $00, $31, $BD, $00, $52, $73, $C6,
    $00,
    $18, $31, $6B, $00, $42, $6B, $C6, $00, $00, $4A, $CE, $00, $39, $63, $A5,
    $00,
    $18, $31, $5A, $00, $00, $10, $2A, $00, $00, $08, $15, $00, $00, $18, $3A,
    $00,
    $00, $00, $08, $00, $00, $00, $29, $00, $00, $00, $4A, $00, $00, $00, $9D,
    $00,
    $00, $00, $DC, $00, $00, $00, $DE, $00, $00, $00, $FB, $00, $52, $73, $9C,
    $00,
    $4A, $6B, $94, $00, $29, $4A, $73, $00, $18, $31, $52, $00, $18, $4A, $8C,
    $00,
    $11, $44, $88, $00, $00, $21, $4A, $00, $10, $18, $21, $00, $5A, $94, $D6,
    $00,
    $21, $6B, $C6, $00, $00, $6B, $EF, $00, $00, $77, $FF, $00, $84, $94, $A5,
    $00,
    $21, $31, $42, $00, $08, $10, $18, $00, $08, $18, $29, $00, $00, $10, $21,
    $00,
    $18, $29, $39, $00, $39, $63, $8C, $00, $10, $29, $42, $00, $18, $42, $6B,
    $00,
    $18, $4A, $7B, $00, $00, $4A, $94, $00, $7B, $84, $8C, $00, $5A, $63, $6B,
    $00,
    $39, $42, $4A, $00, $18, $21, $29, $00, $29, $39, $46, $00, $94, $A5, $B5,
    $00,
    $5A, $6B, $7B, $00, $94, $B1, $CE, $00, $73, $8C, $A5, $00, $5A, $73, $8C,
    $00,
    $73, $94, $B5, $00, $73, $A5, $D6, $00, $4A, $A5, $EF, $00, $8C, $C6, $EF,
    $00,
    $42, $63, $7B, $00, $39, $56, $6B, $00, $5A, $94, $BD, $00, $00, $39, $63,
    $00,
    $AD, $C6, $D6, $00, $29, $42, $52, $00, $18, $63, $94, $00, $AD, $D6, $EF,
    $00,
    $63, $8C, $A5, $00, $4A, $5A, $63, $00, $7B, $A5, $BD, $00, $18, $42, $5A,
    $00,
    $31, $8C, $BD, $00, $29, $31, $35, $00, $63, $84, $94, $00, $4A, $6B, $7B,
    $00,
    $5A, $8C, $A5, $00, $29, $4A, $5A, $00, $39, $7B, $9C, $00, $10, $31, $42,
    $00,
    $21, $AD, $EF, $00, $00, $10, $18, $00, $00, $21, $29, $00, $00, $6B, $9C,
    $00,
    $5A, $84, $94, $00, $18, $42, $52, $00, $29, $5A, $6B, $00, $21, $63, $7B,
    $00,
    $21, $7B, $9C, $00, $00, $A5, $DE, $00, $39, $52, $5A, $00, $10, $29, $31,
    $00,
    $7B, $BD, $CE, $00, $39, $5A, $63, $00, $4A, $84, $94, $00, $29, $A5, $C6,
    $00,
    $18, $9C, $10, $00, $4A, $8C, $42, $00, $42, $8C, $31, $00, $29, $94, $10,
    $00,
    $10, $18, $08, $00, $18, $18, $08, $00, $10, $29, $08, $00, $29, $42, $18,
    $00,
    $AD, $B5, $A5, $00, $73, $73, $6B, $00, $29, $29, $18, $00, $4A, $42, $18,
    $00,
    $4A, $42, $31, $00, $DE, $C6, $63, $00, $FF, $DD, $44, $00, $EF, $D6, $8C,
    $00,
    $39, $6B, $73, $00, $39, $DE, $F7, $00, $8C, $EF, $F7, $00, $00, $E7, $F7,
    $00,
    $5A, $6B, $6B, $00, $A5, $8C, $5A, $00, $EF, $B5, $39, $00, $CE, $9C, $4A,
    $00,
    $B5, $84, $31, $00, $6B, $52, $31, $00, $D6, $DE, $DE, $00, $B5, $BD, $BD,
    $00,
    $84, $8C, $8C, $00, $DE, $F7, $F7, $00, $18, $08, $00, $00, $39, $18, $08,
    $00,
    $29, $10, $08, $00, $00, $18, $08, $00, $00, $29, $08, $00, $A5, $52, $00,
    $00,
    $DE, $7B, $00, $00, $4A, $29, $10, $00, $6B, $39, $10, $00, $8C, $52, $10,
    $00,
    $A5, $5A, $21, $00, $5A, $31, $10, $00, $84, $42, $10, $00, $84, $52, $31,
    $00,
    $31, $21, $18, $00, $7B, $5A, $4A, $00, $A5, $6B, $52, $00, $63, $39, $29,
    $00,
    $DE, $4A, $10, $00, $21, $29, $29, $00, $39, $4A, $4A, $00, $18, $29, $29,
    $00,
    $29, $4A, $4A, $00, $42, $7B, $7B, $00, $4A, $9C, $9C, $00, $29, $5A, $5A,
    $00,
    $14, $42, $42, $00, $00, $39, $39, $00, $00, $59, $59, $00, $2C, $35, $CA,
    $00,
    $21, $73, $6B, $00, $00, $31, $29, $00, $10, $39, $31, $00, $18, $39, $31,
    $00,
    $00, $4A, $42, $00, $18, $63, $52, $00, $29, $73, $5A, $00, $18, $4A, $31,
    $00,
    $00, $21, $18, $00, $00, $31, $18, $00, $10, $39, $18, $00, $4A, $84, $63,
    $00,
    $4A, $BD, $6B, $00, $4A, $B5, $63, $00, $4A, $BD, $63, $00, $4A, $9C, $5A,
    $00,
    $39, $8C, $4A, $00, $4A, $C6, $63, $00, $4A, $D6, $63, $00, $4A, $84, $52,
    $00,
    $29, $73, $31, $00, $5A, $C6, $63, $00, $4A, $BD, $52, $00, $00, $FF, $10,
    $00,
    $18, $29, $18, $00, $4A, $88, $4A, $00, $4A, $E7, $4A, $00, $00, $5A, $00,
    $00,
    $00, $88, $00, $00, $00, $94, $00, $00, $00, $DE, $00, $00, $00, $EE, $00,
    $00,
    $00, $FB, $00, $00, $94, $5A, $4A, $00, $B5, $73, $63, $00, $D6, $8C, $7B,
    $00,
    $D6, $7B, $6B, $00, $FF, $88, $77, $00, $CE, $C6, $C6, $00, $9C, $94, $94,
    $00,
    $C6, $94, $9C, $00, $39, $31, $31, $00, $84, $18, $29, $00, $84, $00, $18,
    $00,
    $52, $42, $4A, $00, $7B, $42, $52, $00, $73, $5A, $63, $00, $F7, $B5, $CE,
    $00,
    $9C, $7B, $8C, $00, $CC, $22, $77, $00, $FF, $AA, $DD, $00, $2A, $B4, $F0,
    $00,
    $9F, $00, $DF, $00, $B3, $17, $E3, $00, $F0, $FB, $FF, $00, $A4, $A0, $A0,
    $00,
    $80, $80, $80, $00, $00, $00, $FF, $00, $00, $FF, $00, $00, $00, $FF, $FF,
    $00,
    $FF, $00, $00, $00, $FF, $00, $FF, $00, $FF, $FF, $00, $00, $FF, $FF, $FF,
    $00
    );

procedure Register;
begin
  RegisterComponents('Mir2Ex', [TWmImages]);
end;

procedure UnCompressionStream(var ASrcStream: TMemoryStream); //解压缩
var
  nTmpStream: TDecompressionStream;
  nDestStream: TMemoryStream;
  nBuf: array[1..512] of Byte;
  nSrcCount: integer;
begin
  ASrcStream.Position := 0;
  nDestStream := TMemoryStream.Create;
  nTmpStream := TDecompressionStream.Create(ASrcStream);
  try
    repeat
      //读入实际大小
      nSrcCount := nTmpStream.Read(nBuf, SizeOf(nBuf));
      if nSrcCount > 0 then
        nDestStream.Write(nBuf, nSrcCount);
    until (nSrcCount = 0);
    ASrcStream.Clear;
    ASrcStream.LoadFromStream(nDestStream);
    ASrcStream.Position := 0;
  finally
    nDestStream.Clear;
    nDestStream.Free;
    nTmpStream.Free;
  end;
end;

procedure ChangeDIBPixelFormat(adib: TDIB; pf: TPixelFormat);
begin
  if pf = pf8bit then
  begin
    with aDib.PixelFormat do
    begin
      RBitMask := $FF0000;
      GBitMask := $00FF00;
      BBitMask := $0000FF;
    end;
    aDib.BitCount := 8;
  end
  else if pf = pf16bit then
  begin
    with aDib.PixelFormat do
    begin //565格式
      RBitMask := $F800;
      GBitMask := $07E0;
      BBitMask := $001F;
    end;
    aDib.BitCount := 16;
  end
  else if pf = pf24bit then
  begin
    with aDib.PixelFormat do
    begin
      RBitMask := $FF0000;
      GBitMask := $00FF00;
      BBitMask := $0000FF;
    end;
    aDib.BitCount := 24;
  end
  else if pf = pf32Bit then
  begin
    with aDib.PixelFormat do
    begin
      RBitMask := $FF0000;
      GBitMask := $00FF00;
      BBitMask := $0000FF;
    end;
    aDib.BitCount := 32;
  end;
end;

function PixelFormatToBitsPerPel(pf: TPixelFormat): smallint;
begin
  case pf of
    pf8bit: result := 8;
    pf15bit, pf16bit: result := 16;
    pf24bit: result := 24;
    pf32bit: result := 32;
  else
    result := 16;
  end;
end;

{ TWMImages }

constructor TWMImages.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FFileName := '';
  FLibType := ltLoadBmp;
  FImageCount := 0;
  FMaxMemorySize := 1024 * 1000; //1M

  FDDraw := nil;
  FDxDraw := nil;
  Stream := nil;
  ImgArr := nil;
  BmpArr := nil;

  IndexList := TList.Create;
  lsDib := TDib.Create;
  lsDib.BitCount := 8;

  lsBitmap := TBitmap.create;
  lsBitmap.Handle := 0;
  lsBitmap.PixelFormat := ColorDeep;
  memchecktime := GetTickCount;
  Finitized := false;
end;

destructor TWMImages.Destroy;
begin
  IndexList.Free;
  if Stream <> nil then Stream.Free;
  lsDib.Free;
  lsBitmap.Free;
  inherited Destroy;
end;

procedure TWMImages.Initialize;
var
  idxfile: string;
  FileExt: string;
begin
  FileExt := ExtractFileExt(FFileName);
  if FileExt <> '' then
  begin
    if Pos('WZL',UpperCase(FileExt)) > 0 then
    begin
      if FileExists(FileName) then      
        FileType := 3
      else if FileExists(ExtractFilePath(FFileName) + ExtractFileNameOnly(FFileName) + '.wil') then
      begin
        FileType := 1;
        FileName := ExtractFilePath(FFileName) + ExtractFileNameOnly(FFileName) + '.wil';
      end;
    end
    else if Pos('WIS', UpperCase(FileExt)) > 0 then
      FileType := 2
    else
    begin
      if FileExists(FileName) then
        FileType := 1
      else if FileExists(ExtractFilePath(FFileName) + ExtractFileNameOnly(FFileName) + '.wzl') then
      begin
        FileType := 3;
        FileName := ExtractFilePath(FFileName) + ExtractFileNameOnly(FFileName) + '.wzl';
      end;
    end;
  end;
  if FileType = 3 then
  begin
    if not (csDesigning in ComponentState) then
    begin
      if Finitized then
        Finalize;
      if FFileName = '' then
        Exit;
      if FileExists(FFileName) then
      begin
        if (LibType <> ltLoadBmp) and (FDDraw = nil) then
        begin
          raise Exception.Create('DDraw not assigned..');
          exit;
        end;
        if Stream = nil then
          Stream := TFileStream.Create (FFileName, fmOpenRead or fmShareDenyNone);
        Stream.Read (wzlheader, sizeof(TWzlHeader));

        FImageCount := wzlheader.ImageCount;
        if LibType = ltLoadBmp then
        begin
          BmpArr := AllocMem(SizeOf(TBmpImage) * FImageCount);
          if BmpArr = nil then
            raise Exception.Create (self.Name + ' BmpArr = nil');
        end
        else
        begin
          ImgArr := AllocMem(sizeof(TDxImage) * FImageCount);
          if ImgArr = nil then
          raise Exception.Create (self.Name + ' ImgArr = nil');
        end;

        idxfile := ExtractFilePath(FFileName) + ExtractFileNameOnly(FFileName) + '.wzx';
        LoadIndex(idxfile);
        FInitized:=true;
        Move(ColorArray, MainPalette, SizeOf(ColorArray));
      end;
    end;
  end
  else if FileType = 2 then
  begin
    if not (csDesigning in ComponentState) then
    begin
      if FFileName = '' then
      begin
           //raise Exception.Create ('FileName not assigned..');
        Exit;
      end;
      if FileExists(FFileName) then
      begin
        if Stream = nil then
          Stream := TFileStream.Create(FFileName, fmOpenRead or fmShareDenyNone);
        FBitFormat := pf8Bit;
        FBytesPerPixels := 1;
        FImageCount := 300000;
        if LibType = ltLoadBmp then
        begin
          BmpArr := AllocMem(SizeOf(TBmpImage) * FImageCount);
          if BmpArr = nil then
            raise Exception.Create(self.Name + ' BmpArr = nil');
        end
        else
        begin
          ImgArr := AllocMem(SizeOf(TDxImage) * FImageCount);
          if ImgArr = nil then
            raise Exception.Create(self.Name + ' ImgArr = nil');
        end;
        LoadPalette;
        if LibType = ltLoadMemory then
          LoadAllData
        else
        begin
          LoadIndex('');
        end;
      end;
    end;
  end
  else
  begin
    if not (csDesigning in ComponentState) then
    begin
      if Finitized then
      begin
        Finalize;
          //exit;
      end;
      if FFileName = '' then
      begin
        raise Exception.Create('FileName not assigned..');
        exit;
      end;
      if (LibType <> ltLoadBmp) and (FDDraw = nil) then
      begin
        raise Exception.Create('DDraw not assigned..');
        exit;
      end;

      if FileExists(FFileName) then
      begin
        if Stream = nil then Stream := TFileStream.Create(FFileName, fmOpenRead or fmShareDenyNone);
           //获得图象数
        Stream.Read(header, sizeof(TWMImageHeader));
        FImageCount := header.ImageCount;
        if header.ColorCount = 256 then
        begin
          FBitFormat := pf8Bit; FBytesPerPixels := 1;
        end
        else if header.ColorCount = 65536 then
        begin
          FBitFormat := pf16bit; FBytesPerPixels := 2;
        end
        else if header.colorcount = 16777216 then
        begin
          FBitFormat := pf24Bit; FBytesPerPixels := 4;
        end
        else if header.ColorCount > 16777216 then
        begin
          FBitFormat := pf32Bit; FBytesPerPixels := 4;
        end;
        ChangeDIBPixelFormat(lsDIB, FBitFormat);

           //分配内存

        if LibType = ltLoadBmp then
        begin
          BmpArr := AllocMem(sizeof(TBmpImage) * FImageCount);
          if BmpArr = nil then
            raise Exception.Create(self.Name + ' BmpArr = nil');
        end
        else
        begin
          ImgArr := AllocMem(sizeof(TDxImage) * FImageCount);
          if ImgArr = nil then
            raise Exception.Create(self.Name + ' ImgArr = nil');
        end;

           //索引文件
        idxfile := ExtractFilePath(FFileName) + ExtractFileNameOnly(FFileName) + '.WIX';
        LoadPalette;
        if LibType = ltLoadMemory then
          LoadAllData
        else
        begin
          LoadIndex(idxfile);
        end;
      end
      else
      begin
          // MessageDlg (FFileName + ' 文件不存在.', mtWarning, [mbOk], 0);
      end;
      FInitized := true;
    end;
  end;

end;

procedure TWMImages.Finalize;
var
  i: integer;
begin
   //释放装载的所有图片
  if ImgArr <> nil then
    for i := 0 to FImageCount - 1 do
    begin
      if ImgArr[i].Surface <> nil then
      begin
        ImgArr[i].Surface.Free;
        ImgArr[i].Surface := nil;
      end;
    end;
  if Stream <> nil then
    FreeAndNil(Stream);

  if Stream <> nil then
  begin
    Stream.Free;
    Stream := nil;
  end;
  FInitized := false;
end;

//这个函数在DXDraws里有

function TDXDrawRGBQuadsToPaletteEntries(const RGBQuads: TRGBQuads;
  AllowPalette256: Boolean): TPaletteEntries;
var
  Entries: TPaletteEntries;
  dc: THandle;
  i: Integer;
begin
  Result := RGBQuadsToPaletteEntries(RGBQuads);
  if not AllowPalette256 then
  begin
    dc := GetDC(0);
    GetSystemPaletteEntries(dc, 0, 256, Entries);
    ReleaseDC(0, dc);
    for i := 0 to 9 do
      Result[i] := Entries[i];
    for i := 256 - 10 to 255 do
      Result[i] := Entries[i];
  end;
  for i := 0 to 255 do
    Result[i].peFlags := D3DPAL_READONLY;
end;

//装载图片到内存，需要大量内存！

procedure TWMImages.LoadAllData;
var
  i: integer;
  imgi: TWMImageInfo;
  dib: TDIB;
  dximg: TDxImage;
begin
  dib := TDIB.Create;
  for i := 0 to FImageCount - 1 do
  begin
    Stream.Read(imgi, sizeof(TWMImageInfo) - 4);
    dib.Width := imgi.Width;
    dib.Height := imgi.Height;
    ChangeDIBPixelFormat(dib, FBitFormat);
    dib.ColorTable := MainPalette;
    dib.UpdatePalette;
    Stream.Read(dib.PBits^, imgi.Width * imgi.Height * FBytesPerPixels);
    dximg.npx := imgi.px;
    dximg.npy := imgi.py;
    dximg.surface := TDirectDrawSurface.Create(FDDraw);
    dximg.surface.SystemMemory := TRUE;
    dximg.surface.SetSize(imgi.Width, imgi.Height);
    dximg.surface.Canvas.Draw(0, 0, dib);
    dximg.surface.Canvas.Release;
    dib.Clear; //FreeImage;
    dximg.surface.TransparentColor := 0;
    ImgArr[i] := dximg;
    FreeAndNil(dximg.surface); //20080719添加
    dib.Free;
  end;
end;

//从WIL文件中装载调色板

procedure TWMImages.LoadPalette;
var
  MemStream: TMemoryStream;
begin
  try
    MemStream := TMemoryStream.Create;
    if FileExists('Data\ChrSel.wil') then
    begin
      MemStream.LoadFromFile('Data\ChrSel.wil');
      MemStream.Seek(sizeof(TWMImageHeader), 0);
      MemStream.Read(MainPalette, sizeof(TRgbQuad) * 256);
    end
    else
    begin
      Stream.Seek(sizeof(TWMImageHeader), 0);
      Stream.Read(MainPalette, sizeof(TRgbQuad) * 256);
    end;
  finally
    MemStream.Free;
  end;
end;

//Cache从WIL文件中装载所有BMP到内存.

procedure TWMImages.LoadAllDataBmp;
begin
end;

//装载WIX文件内容到内存,ltLoadMemory除外

procedure TWMImages.LoadIndex(idxfile: string);
var
  fhandle, i, value: integer;
  header: TWMIndexHeader;
  pidx: PTWMIndexInfo; //释放内存
  pvalue: PInteger;
  WISImageInfo: PTWISImageInfo;
  TempVar: Cardinal;
  TempList: TList;
  indexheader:TWzlIndexHeader;
begin
  if FileType = 3 then
  begin
    indexlist.Clear;
    if FileExists (idxfile) then
    begin
      fhandle := FileOpen (idxfile, fmOpenRead or fmShareDenyNone);
      if fhandle > 0 then
      begin
         FileRead (fhandle, indexheader, sizeof(TWzlIndexHeader));
         GetMem (pvalue, 4 * wzlheader.ImageCount);
         FileRead (fhandle, pvalue^, 4 * wzlheader.ImageCount);
         for i:=0 to wzlheader.ImageCount-1 do
         begin
            value := PInteger(integer(pvalue) + 4*i)^;
            IndexList.Add (pointer(value));
         end;
         FreeMem (pvalue);
         FileClose (fhandle);
      end;
    end;
  end
  else
  if FileType = 2 then
  begin
    TempList := TList.Create;
    if FileExists(FFileName) then
    begin
      try
        fhandle := FileOpen(FFileName, fmOpenRead or fmShareDenyNone);
        if fhandle > 0 then
        begin
          FFileSize := GetFileSize(Fhandle, nil);
          I := 0;
          while True do
          begin
            New(WISImageInfo);
            ZeroMemory(WISImageInfo, SizeOf(TWISImageInfo));
            FileSeek(Fhandle, -(I * 12 + 12), FILE_END);
            ReadFile(Fhandle, (@WISImageInfo.WISImageSize)^, SizeOf(TWISImageSize), TempVar, nil);
            if (WISImageInfo.WISImageSize.ImageOff > 0) then
            begin
  //              FileSeek(Fhandle,WISImageInfo.WISImageSize.ImageOff,FILE_BEGIN);
  //              FileRead(Fhandle, (@WISImageInfo.WISImageHead)^, SizeOf(TWISImageHead));
            end
            else
            begin
              Dispose(WISImageInfo)
            end;
            TempList.Add(WISImageInfo);
            if WISImageInfo.WISImageSize.ImageOff = $200 then
            begin //读到头了
              Break;
            end;
            Inc(I);
          end;
          IndexList.Clear;
          for I := TempList.Count - 1 downto 0 do
          begin //整理表
            if TempList.Items[I] <> nil then
            begin
              IndexList.Add(TempList.Items[I]);
            end;
          end;
        end;
      finally
        CloseHandle(Fhandle);
      end;
    end;
  end
  else
  begin
    indexlist.Clear;
      //WIL 文件
    if FileExists(idxfile) then
    begin
      fhandle := FileOpen(idxfile, fmOpenRead or fmShareDenyNone);
      if fhandle > 0 then
      begin
        FileRead(fhandle, header, sizeof(TWMIndexHeader));
        GetMem(pvalue, 4 * header.IndexCount);
        FileRead(fhandle, pvalue^, 4 * header.IndexCount);
        for i := 0 to header.IndexCount - 1 do
        begin
          new(pidx);
          value := PInteger(integer(pvalue) + 4 * i)^;
          IndexList.Add(pointer(value));
        end;
        FreeMem(pvalue);
        FileClose(fhandle);
      end;
    end;
  end;
end;

{----------------- Private Variables ---------------------}

function TWMImages.FGetImageSurface(index: integer): TDirectDrawSurface;
begin
  Result := nil;
  if LibType = ltUseCache then
  begin
    Result := GetCachedSurface(index);
  end
  else if LibType = ltLoadMemory then
  begin
    if (index >= 0) and (index < ImageCount) then
      Result := ImgArr[index].Surface;
  end;
end;

function TWMImages.FGetImageBitmap(index: integer): TBitmap;
begin
  if LibType <> ltLoadBmp then exit;
  Result := GetCachedBitmap(index);
end;

procedure TWMImages.FSetDxDraw(fdd: TDxDraw);
begin
  FDxDraw := fdd;
end;

procedure TWMImages.LoadDxImage(position: PTWISImageInfo; pdximg: PTDxImage);
var
  imginfo: TWMImageInfo;
  ddsd: TDDSURFACEDESC;
  SBits, PSrc, DBits, WISByte: PByte;
  n, slen, dlen: integer;
  ms: TMemoryStream;
  w: Word;
  size: DWord;
begin
  Stream.Seek(Position.WISImageSize.ImageOff, 0);
  Stream.Read(Pointer(@position.WIsImageHead)^, 12);
  if (position.WISImageHead.Width <= 1) or (position.WISImageHead.Height <= 1) then Exit;
  if g_boUseDIBSurface then
  begin //DIB
        //非全屏时
    try
      lsDib.Clear;
      lsDib.Width := Position.WISImageHead.Width;
      lsDib.Height := Position.WISImageHead.Height;
      lsDib.Canvas.Brush.Color := ClBlack;
      lsDib.Canvas.FillRect(Rect(0, 0, lsdib.Width, lsdib.Height));
      ChangeDIBPixelFormat(lsDIB, FBitFormat);
    except
    end;
    GetMem(WISByte, 1024 * 1024);
    lsDib.ColorTable := MainPalette;
    lsDib.UpdatePalette;
    DBits := lsDib.PBits;
    Stream.Read(WISByte^, Position.WISImageHead.Width * Position.WISImageHead.Height);
    DeCodeWisImage(Position.WISImageHead.DeCodeMake, WISByte, DBits, Position.WISImageSize.ImageSize - SizeOf(TWISImageHead),
      Position.WISImageHead.Width, Position.WISImageHead.Height);
    pdximg.nPx := Position.WISImageHead.X;
    pdximg.nPy := Position.WISImageHead.Y;
    pdximg.surface := TDirectDrawSurface.Create(FDDraw);
    pdximg.surface.SystemMemory := TRUE;
    pdximg.surface.SetSize(Position.WISImageHead.Width, Position.WISImageHead.Height);
    pdximg.surface.Canvas.Draw(0, 0, lsDib);
    pdximg.surface.Canvas.Release;
    pdximg.surface.TransparentColor := 0;
    FreeMem(WISByte);
  end
  else
  begin //
        //全屏时
    try
      slen := WidthBytes(imginfo.Width);
      GetMem(PSrc, slen * imgInfo.Height);
        // SBits := PSrc;  //20080718注释释放内存
      Stream.Read(PSrc^, slen * imgInfo.Height);

      pdximg.surface := TDirectDrawSurface.Create(FDDraw);
      pdximg.surface.SystemMemory := TRUE;
      pdximg.surface.SetSize(slen, imginfo.Height);
           //pdximg.surface.Palette := MainSurfacePalette;

      pdximg.nPx := imginfo.px;
      pdximg.nPy := imginfo.py;
      ddsd.dwSize := SizeOf(ddsd);

      pdximg.surface.Lock(TRect(nil^), ddsd);
      DBits := ddsd.lpSurface;
      if imginfo.Height > 0 then //20080629
        for n := imginfo.Height - 1 downto 0 do
        begin
          SBits := PByte(Integer(PSrc) + slen * n);
          Move(SBits^, DBits^, slen);
          Inc(integer(DBits), ddsd.lPitch);
        end;
      pdximg.surface.TransparentColor := 0;
    finally
      pdximg.surface.UnLock();
      FreeMem(PSrc); //20080719修改
    end;
  end;
end;

//WIL文件图片

procedure TWMImages.LoadDxImage(position: integer; pdximg: PTDxImage);
var
  imginfo: TWMImageInfo;
  ddsd: TDDSURFACEDESC;
  SBits, PSrc, DBits: PByte;
  n, slen, dlen: integer;
  ms: TMemoryStream;
  w: Word;
  size: DWord;
  //wzl
  wzlimageinfo : TWzlImageInfo;
  PInBits, POutBits: Pointer;
  outsize: Integer;
  SrcP:Pointer;
begin
  if FileType = 3 then
  begin
    if position < SizeOf(TWMImageHeader) then
      Exit;
    Stream.Seek (position, 0);
    Stream.Read (wzlimageinfo, sizeof(TWzlImageInfo));
    pdximg.npx:=wzlimageinfo.wPx;
    pdximg.npy:=wzlimageinfo.wPy;
    if (wzlimageinfo.nWidth<2) or (wzlimageinfo.nHeight<2) then
    begin
      pdximg.surface := TDirectDrawSurface.Create (FDDraw);
      pdximg.surface.SystemMemory := TRUE;
      pdximg.surface.SetSize (wzlimageinfo.nWidth, wzlimageinfo.nHeight);
      pdximg.surface.Canvas.Release;
      pdximg.surface.TransparentColor := 0;
      exit;
    end;
    PInBits:=nil;
    POutBits:=nil;
    case wzlimageinfo.btEn1 of
      3:
        begin
          lsDib.Clear;
          lsDib.Width := WidthBytes(wzlimageinfo.nWidth);
          lsDib.Height := wzlimageinfo.nHeight;
          ChangeDIBPixelFormat(lsDIB,pf8bit);
          lsDib.Canvas.Brush.Color := ClBlack;
          lsDib.Canvas.FillRect(Rect(0, 0, lsdib.Width, lsdib.Height));
          lsDib.ColorTable := MainPalette;
          lsDib.UpdatePalette;
          if wzlimageinfo.iLen <> 0 then
          begin
            GetMem(PInBits,wzlimageinfo.iLen);
            Stream.Read(PInBits^,wzlimageinfo.iLen);
            GetMem(POutBits, lsDib.Size);
            DecompressBufZ(PInBits, wzlimageinfo.iLen, 0, POutBits, outsize);
          end
          else
          begin
            GetMem(POutBits, lsDib.Size);
            Stream.Read(POutBits^,lsDib.Size);
          end;
          SrcP := lsDib.PBits;
          Move(POutBits^,SrcP^,lsDib.Size);
          pdximg.surface := TDirectDrawSurface.Create (FDDraw);
          pdximg.surface.SystemMemory := TRUE;
          pdximg.surface.SetSize (lsDib.Width, lsDib.Height);
          pdximg.surface.Canvas.Draw(0, 0, lsDib);
          pdximg.surface.Canvas.Release;
          pdximg.surface.TransparentColor := 0;
        end;
      5:
        begin
          lsDib.Clear;
          lsDib.Width := wzlimageinfo.nWidth;
          lsDib.Height := wzlimageinfo.nHeight;
          lsDib.Canvas.Brush.Color := ClBlack;
          lsDib.Canvas.FillRect(Rect(0, 0, lsdib.Width, lsdib.Height));
          ChangeDIBPixelFormat(lsDIB,pf16bit);
          lsDib.ColorTable := MainPalette;
          lsDib.UpdatePalette;
          if wzlimageinfo.iLen <> 0 then
          begin
            GetMem(PInBits,wzlimageinfo.iLen);
            Stream.Read(PInBits^,wzlimageinfo.iLen);
            GetMem(POutBits, lsDib.Size);
            DecompressBufZ(PInBits, wzlimageinfo.iLen, 0, POutBits, outsize);
          end
          else
          begin
            GetMem(POutBits, lsDib.Size);
            Stream.Read(POutBits^,lsDib.Size);
          end;
          SrcP := lsDib.PBits;
          Move(POutBits^,SrcP^,lsDib.Size);
          pdximg.surface := TDirectDrawSurface.Create (FDDraw);
          pdximg.surface.SystemMemory := TRUE;
          pdximg.surface.SetSize (lsDib.Width, lsDib.Height);
          pdximg.surface.Canvas.Draw(0, 0, lsDib);
          pdximg.surface.Canvas.Release;
          pdximg.surface.TransparentColor := 0;
        end;
    end;
    if PInBits <> nil then
      FreeMem(PInBits);
    if pOutBIts <> nil then
      FreeMem(POutBits);
  end
  else
  begin
    if position < SizeOf(TWzlHeader) then
      Exit;  
    Stream.Seek(position, 0);
    Stream.Read(imginfo, sizeof(TWMImageInfo) - 4);
    if (imginfo.Width < 2) or (imgInfo.Height < 2) then
    begin
      pdximg.npx := imginfo.px;
      pdximg.npy := imginfo.py;
      pdximg.surface := TDirectDrawSurface.Create(FDDraw);
      pdximg.surface.SystemMemory := TRUE;
      pdximg.surface.SetSize(imginfo.Width, imginfo.Height);
      pdximg.surface.Canvas.Release;
      pdximg.surface.TransparentColor := 0;
      exit;
    end;
    if g_boUseDIBSurface and (FBitFormat <> pfDevice) then
    begin
      if (FBitFormat = pf8bit) then
      begin
        slen := WidthBytes(imginfo.Width);
        try
          lsDib.Clear;
          lsDib.Width := slen;
          lsDib.Height := imginfo.Height;
          lsDib.Canvas.Brush.Color := ClBlack;
          lsDib.Canvas.FillRect(Rect(0, 0, lsdib.Width, lsdib.Height));
          ChangeDIBPixelFormat(lsDIB, FBitFormat);
        except
        end;
        lsDib.ColorTable := MainPalette;
        lsDib.UpdatePalette;
        DBits := lsDib.PBits;
        Stream.Read(DBits^, slen * imgInfo.Height * FBytesPerPixels);
      end
      else if FBitFormat = pf16bit then
      begin
        try
          lsDib.Clear;
          lsDib.Width := imginfo.Width;
          lsDib.Height := imginfo.Height;
          lsDib.Canvas.Brush.Color := ClBlack;
          lsDib.Canvas.FillRect(Rect(0, 0, lsdib.Width, lsdib.Height));
          ChangeDIBPixelFormat(lsDIB, FBitFormat);
        except
        end;
        lsDib.ColorTable := MainPalette;
        lsDib.UpdatePalette;
        DBits := lsDib.PBits;
        Stream.Read(DBits^, imginfo.Width * imgInfo.Height * FBytesPerPixels);
      end
      else
      begin
        ms := TMemoryStream.Create;
        try
          Stream.Read(w, 2);
          Stream.Read(size, 4);
          ms.Write(w, 2);
          ms.Write(size, 4);
          ms.CopyFrom(Stream, size);
          ms.Seek(0, 0);
          lsBitmap.LoadFromStream(ms);
          lsBitmap.TransparentColor := 0;
        finally
          ms.Free;
        end;
      end;
      pdximg.npx := imginfo.px;
      pdximg.npy := imginfo.py;
      pdximg.surface := TDirectDrawSurface.Create(FDDraw);
      pdximg.surface.SystemMemory := TRUE;
      if FBitFormat = pf8bit then
        pdximg.surface.SetSize(slen, imginfo.Height)
      else
        pdximg.surface.SetSize(imginfo.Width, imginfo.Height);

      if FBitFormat < pf32bit then //全屏时
        pdximg.surface.Canvas.Draw(0, 0, lsDib)
      else
        pdximg.surface.Canvas.Draw(0, 0, lsBitmap);
      pdximg.surface.Canvas.Release;
      pdximg.surface.TransparentColor := 0;
    end
    else
    begin
      slen := WidthBytes(imginfo.Width);
      GetMem(PSrc, slen * imgInfo.Height * FBytesPerPixels);
      SBits := PSrc;
      Stream.Read(PSrc^, slen * imgInfo.Height * FBytesPerPixels);
      try
        pdximg.surface := TDirectDrawSurface.Create(FDDraw);
        pdximg.surface.SystemMemory := TRUE;
        pdximg.surface.SetSize(slen, imginfo.Height);
        pdximg.npx := imginfo.px;
        pdximg.npy := imginfo.py;
        ddsd.dwSize := SizeOf(ddsd);
        pdximg.surface.Lock(TRect(nil^), ddsd);
        DBits := ddsd.lpSurface;
        for n := imginfo.Height - 1 downto 0 do
        begin
          SBits := PByte(Integer(PSrc) + slen * n * FBytesPerPixels);
          Move(SBits^, DBits^, slen * FBytesPerPixels);
          Inc(integer(DBits), ddsd.lPitch);
        end;
        pdximg.surface.TransparentColor := 0;
      finally
        pdximg.surface.UnLock();
        FreeMem(PSrc);
      end;
    end;
  end;
end;

procedure TWMImages.LoadBmpImage(position: integer; pbmpimg: PTBmpImage);
var
  imginfo: TWMImageInfo;
  ddsd: TDDSURFACEDESC;
  DBits: PByte;
  n, slen, dlen: integer;
  px, py: integer;
  ms: TMemoryStream;
  w: Word;
  size: DWord;
begin
  Stream.Seek(position, 0);
  Stream.Read(imginfo, sizeof(TWMImageInfo) - 4);
  if (imginfo.Width < 2) or (imginfo.Height < 2) then
  begin
    pbmpimg.bmp := TBitmap.Create;
    pbmpimg.bmp.Width := lsDib.Width;
    pbmpimg.bmp.Height := lsDib.Height;
    exit;
  end;
  if FBitFormat < pf32bit then
  begin
    lsDib.Width := imginfo.Width;
    lsDib.Height := imginfo.Height;
    ChangeDIBPixelFormat(lsDIB, FBitFormat);
    lsDib.ColorTable := MainPalette;
    lsDib.UpdatePalette;
    DBits := lsDib.PBits;
    Stream.Read(DBits^, imginfo.Width * imgInfo.Height * FBytesPerPixels);
    pbmpimg.bmp := TBitmap.Create;
    pbmpimg.bmp.Width := lsDib.Width;
    pbmpimg.bmp.Height := lsDib.Height;
    pbmpimg.bmp.Canvas.Draw(0, 0, lsDib);
    lsDib.Clear;
  end
  else
  begin
    ms := TMemoryStream.Create;
    try
      Stream.Read(w, 2);
      Stream.Read(size, 4);
      ms.Write(w, 2);
      ms.Write(size, 4);
      ms.CopyFrom(Stream, size);
      ms.Seek(0, 0);
      pbmpimg.bmp := TBitmap.Create;
      pbmpimg.bmp.LoadFromStream(ms);
    finally
      ms.Free;
    end;
  end;
end;

//新添加的函数 WIL

procedure TWMImages.LoadBmpImage(position: integer; var pbmpimg: TBitmap; var px, py: integer);
var
  imginfo: TWMImageInfo;
  ddsd: TDDSURFACEDESC;
  DBits: PByte;
  n, slen, dlen: integer;
  img: PTBmpImage;
  ms: TMemoryStream;
  w: Word;
  size: DWord;
begin
  Stream.Seek(position, 0);
  Stream.Read(imginfo, sizeof(TWMImageInfo) - 4);
  px := ImgInfo.px;
  py := imgInfo.py;
  if (imginfo.Width < 2) or (imgInfo.Height < 2) then
  begin
    pbmpimg.Width := imgInfo.Width;
    pbmpimg.Height := imgInfo.Height;
    exit;
  end;
  if FBitFormat < pf32bit then
  begin
    lsDib.Width := imginfo.Width;
    lsDib.Height := imginfo.Height;
    ChangeDIBPixelFormat(lsDIB, FBitFormat);
    lsDib.ColorTable := MainPalette;
    lsDib.UpdatePalette;
    DBits := lsDib.PBits;
    Stream.Read(DBits^, imginfo.Width * imgInfo.Height * FBytesPerPixels);
    pbmpimg.Palette := lsdib.Palette;
    pbmpimg.Width := lsDib.Width;
    pbmpimg.Height := lsDib.Height;
    pbmpimg.Canvas.Draw(0, 0, lsDib);
    pbmpimg.TransparentColor := 0;
    lsDib.Clear;
  end
  else
  begin
    ms := TMemoryStream.Create;
    try
      Stream.Read(w, 2);
      Stream.Read(size, 4);
      ms.Write(w, 2);
      ms.Write(size, 4);
      ms.CopyFrom(Stream, size);
      ms.Seek(0, 0);
      pbmpimg.LoadFromStream(ms);
      pbmpimg.TransparentColor := 0;
    finally
      ms.Free;
    end;
  end;
end;

procedure TWMImages.ClearCache;
var
  i: integer;
begin
  for i := 0 to ImageCount - 1 do
  begin
    if ImgArr[i].Surface <> nil then
    begin
      ImgArr[i].Surface.Free;
      ImgArr[i].Surface := nil;
    end;
  end;
end;

function TWMImages.GetImage(index: integer; var px, py: integer): TDirectDrawSurface;
begin
  if (index >= 0) and (index < ImageCount) then
  begin
    px := ImgArr[index].npx;
    py := ImgArr[index].npy;
    Result := ImgArr[index].surface;
  end
  else
    Result := nil;
end;

{--------------- BMP functions ----------------}

//释放5秒后还未使用的图片

procedure TWMImages.FreeOldBmps;
var
  i, j, n, ntime, curtime, limit: integer;
begin
  n := -1;
  ntime := 0;
  for i := 0 to ImageCount - 1 do
  begin
    curtime := GetTickCount;
    if BmpArr[i].Bmp <> nil then
    begin
      if curtime - BmpArr[i].LatestTime > 5 * 1000 then
      begin
        BmpArr[i].Bmp.Free;
        BmpArr[i].Bmp := nil;
      end
      else
      begin
        if curtime - BmpArr[i].LatestTime > ntime then
        begin
          ntime := curtime - BmpArr[i].LatestTime;
          n := i;
        end;
      end;
    end;
  end;
end;

//释放指定索引的图片

procedure TWMImages.FreeBitmap(index: integer);
var
  i: integer;
begin
  if (index <= 0) or (index >= ImageCount) then exit;
  if BmpArr[index].Bmp <> nil then
  begin
    BmpArr[index].Bmp.FreeImage;
    BmpArr[index].Bmp.Free;
    BmpArr[index].Bmp := nil;
  end;
end;

//释放10秒钟后未使用的图片

procedure TWMImages.FreeOldMemorys;
var
  i, j, n, ntime, curtime, limit: integer;
begin
  n := -1;
  ntime := 0;
  curtime := GetTickCount;
   //WIL文件
  for i := 0 to FImageCount - 1 do
  begin
    if ImgArr[i].Surface <> nil then
    begin
      if curtime - ImgArr[i].LatestTime > 300000 then
      begin
        ImgArr[i].Surface.Free;
        ImgArr[i].Surface := nil;
      end;
    end;
  end;
end;

//返回指定图片号的图面

function TWMImages.GetCachedSurface(index: integer): TDirectDrawSurface;
var
  position: integer;
  Pwis: PTWISImageInfo;
  px, py: integer;
begin
  Result := nil;
  if FileType = 2 then
  begin
    try
      if (index < 0) or (index >= ImageCount) then exit;
      if GetTickCount - memchecktime > 10000 then
      begin
        memchecktime := GetTickCount;
          //if MemorySize > FMaxMemorySize then begin
        FreeOldMemorys;
          //end;
      end;
       //nErrCode:=1;
      if ImgArr[index].Surface = nil then
      begin //cache登绢 乐瘤 臼澜. 货肺 佬绢具窃.
        if index < IndexList.Count then
        begin
          Pwis := IndexList[index];
          LoadDxImage(Pwis, @ImgArr[index]);
          ImgArr[index].LatestTime := GetTickCount;
             //nErrCode:=2;
          Result := ImgArr[index].Surface;
             //MemorySize := MemorySize + ImgArr[index].Surface.Width * ImgArr[index].Surface.Height;
        end;
      end
      else
      begin
        ImgArr[index].LatestTime := GetTickCount;
          //nErrCode:=3;
        Result := ImgArr[index].Surface;
      end;
    except
        //DebugOutStr ('GetCachedSurface 3 Index: ' + IntToStr(index) + ' Error Code: ' + IntToStr(nErrCode));
    end;
  end
  else
  begin
    try
      if (index < 0) or (index >= ImageCount) then exit;
     //WIL 文件
      if GetTickCount - memchecktime > 10000 then
      begin
        memchecktime := GetTickCount;
        FreeOldMemorys;
      end;
      if ImgArr[index].Surface = nil then
      begin //若指定图片已经释放，则重新装载.
        if index < IndexList.Count then
        begin
          position := Integer(IndexList[index]);
          LoadDxImage(position, @ImgArr[index]);
          ImgArr[index].LatestTime := GetTickCount;
          Result := ImgArr[index].Surface;
        end;
      end
      else
      begin
        ImgArr[index].LatestTime := GetTickCount;
        Result := ImgArr[index].Surface;
      end;
    except
    end;
  end;
end;

function TWMImages.DeCodeWisImage(CodeMake: Byte; SCode, DCode: Pointer; Ssize: Integer;
  X, Y: Word): Boolean;
var
  I, II, DCodeSize: Integer;
  P1, P2, P3, P4: Pointer;
  DIB: TDIB;
  FileHandle: DWORD;
  TempVar: Cardinal;
  B, B1: Byte;
  wLen: Word;
begin
  wLen := WidthBytes(X);
  DCodeSize := 0;
  P2 := nil;
  P3 := nil;
  P4 := nil;
  ZeroMemory(DCode, wLen * Y);
  if (SCode <> nil) and (Ssize > 0) then
  begin
    try
//      FileHandle :=  CreateFile('.\SCode.txt',GENERIC_WRITE, 0, nil, CREATE_ALWAYS, 0,0);
//      WriteFile(FileHandle, SCode^ ,Ssize, TempVar,nil);
//      CloseHandle(FileHandle);
     // ShowMessage(IntToStr(DeCodeSize));
      if (X * Y) > 0 then
      begin
        P2 := SCode;
        GetMem(P3, wLen * Y);
        ZeroMemory(P3, wLen * Y);
        P4 := P3;
      end
      else
      begin
        Exit;
      end;

      if CodeMake = 1 then //判断是否压缩
        for I := 0 to Ssize - 1 do
        begin //解密WIS文件
          B := Byte(P2^);
          if B = 0 then
          begin
            Inc(Integer(P2));
            B := Byte(P2^);
            if B > 0 then
            begin
              Inc(Integer(P2));
              for II := 1 to B do
              begin
                B1 := Byte(P2^);
                Inc(B1);
                Byte(P3^) := Byte(P2^);
                Inc(Integer(P2));
                Inc(Integer(P3));
              end;
            end
            else
            begin
              Inc(Integer(P2));
            end;
          end
          else
          begin
            B := PTDeCodeRLE(P2).Num;
            for II := 1 to B do
            begin
              Byte(P3^) := PTDeCodeRLE(P2).Value;
              Inc(Integer(P3));
            end;
            Inc(Integer(P2), 2);
          end;
          if Integer(P2) - Integer(SCode) >= Ssize then Break;
        end;

      DCodeSize := Integer(P3) - Integer(P4);
   // MessageBox(0,PChar('DCodeSize='+IntToStr(DCodeSize)+' X * Y='+IntToStr(X * Y)+'相差 '+IntToStr(X * Y - DCodeSize)),'',0);
      Integer(DCode) := Integer(DCode) + Integer(wLen * Y) - wLen;
      if CodeMake = 1 then
      begin
        for I := 0 to Y - 1 do
        begin
          Move(P4^, DCode^, X);
          Integer(P4) := Integer(P4) + X;
          Integer(DCode) := Integer(DCode) - wLen;
        end;
      end
      else
      begin
        for I := 0 to Y - 1 do
        begin
          Move(P2^, DCode^, X);
          Integer(P2) := Integer(P2) + X;
          Integer(DCode) := Integer(DCode) - wLen;
        end;
      end;
    except
      MessageBox(0, 'DeCodeWisImage Error Code=1', '错误', 0);
    end;
  end;
end;

function TWMImages.GetCachedImage(index: integer; var px, py: integer): TDirectDrawSurface;
var
  position: integer;
  Pwis: PTWISImageInfo;
begin
  Result := nil;
  if FileType = 2 then
  begin
    try
      if (index < 0) or (index >= ImageCount) then Exit;
      if GetTickCount - memchecktime > 10000 then
      begin
        memchecktime := GetTickCount;
        //if MemorySize > FMaxMemorySize then begin
        FreeOldMemorys;
        //end;
      end;
     //nErrCode:=1;
      if ImgArr[index].Surface = nil then
      begin //cache
        if index < IndexList.Count then
        begin
          Pwis := IndexList[index];
          LoadDxImage(Pwis, @ImgArr[index]);
          ImgArr[index].LatestTime := GetTickCount;
          px := ImgArr[index].nPx;
          py := ImgArr[index].nPy;
          Result := ImgArr[index].Surface;
           //MemorySize := MemorySize + ImgArr[index].Surface.Width * ImgArr[index].Surface.Height;
        end;

      end
      else
      begin
        ImgArr[index].LatestTime := GetTickCount;
        px := ImgArr[index].nPx;
        py := ImgArr[index].nPy;
        Result := ImgArr[index].Surface;
      end;
    except
      //DebugOutStr ('GetCachedImage 3 Index: ' + IntToStr(index) + ' Error Code: ' + IntToStr(nErrCode));
    end;
  end
  else
  begin
    try
      if (index < 0) or (index >= ImageCount) then exit;
    //WIL 文件
      if GetTickCount - memchecktime > 10000 then
      begin
        memchecktime := GetTickCount;
        FreeOldMemorys;
      end;
      if ImgArr[index].Surface = nil then
      begin //重新装载
        if index < IndexList.Count then
        begin
          position := Integer(IndexList[index]);
          LoadDxImage(position, @ImgArr[index]);
          ImgArr[index].LatestTime := GetTickCount;
          px := ImgArr[index].npx;
          py := ImgArr[index].npy;
          Result := ImgArr[index].Surface;
        end;
      end
      else
      begin
        ImgArr[index].LatestTime := GetTickCount;
        px := ImgArr[index].npx;
        py := ImgArr[index].npy;
        Result := ImgArr[index].Surface;
      end;
    except
    end;
  end;
end;

function TWMImages.GetCachedBitmap(index: integer): TBitmap;
var
  position: integer;
begin
  Result := nil;
  if (index < 0) or (index >= ImageCount) then exit;
     //WIL 文件
  if BmpArr[index].Bmp = nil then
  begin
    if index < IndexList.Count then
    begin
      position := Integer(IndexList[index]);
      LoadBmpImage(position, @BmpArr[index]);
      BmpArr[index].LatestTime := GetTickCount;
      Result := BmpArr[index].Bmp;
      FreeOldBmps;
    end;
  end
  else
  begin
    BmpArr[index].LatestTime := GetTickCount;
    Result := BmpArr[index].Bmp;
  end;
end;

//新添加的函数，不使用BmpArr，需要调用者释放资源

function TWMImages.GetCachedBitmap(index: integer; var px, py: integer): TBitmap;
var
  position: integer;
begin
  Result := TBitmap.Create;
  result.PixelFormat := FBitFormat;
  if (index < 0) or (index >= ImageCount) then exit;
  if index < IndexList.Count then
  begin
    position := Integer(IndexList[index]);
    LoadBmpImage(position, result, px, py);
  end
  else
  begin

  end;
end;

//按缩放比率画出执行序号的图片

procedure TWMImages.DrawZoom(paper: TCanvas; x, y, index: integer; zoom: Real);
var
  rc: TRect;
  bmp: TBitmap;
begin
  if LibType <> ltLoadBmp then exit;
  bmp := Bitmaps[index];
  if bmp <> nil then
  begin
    rc.Left := x;
    rc.Top := y;
    rc.Right := x + Round(bmp.Width * zoom);
    rc.Bottom := y + Round(bmp.Height * zoom);
    if (rc.Right > rc.Left) and (rc.Bottom > rc.Top) then
    begin
      paper.StretchDraw(rc, Bmp);
      FreeBitmap(index);
    end;
  end;
end;

//

procedure TWMImages.DrawZoomEx(paper: TCanvas; x, y, index: integer; zoom: Real; leftzero: Boolean);
var
  rc: TRect;
  bmp, bmp2: TBitmap;
begin
  if LibType <> ltLoadBmp then exit;
  bmp := Bitmaps[index];
  if bmp <> nil then
  begin
    Bmp2 := TBitmap.Create;
    Bmp2.Width := Round(Bmp.Width * zoom);
    Bmp2.Height := Round(Bmp.Height * zoom);
    rc.Left := x;
    rc.Top := y;
    rc.Right := x + Round(bmp.Width * zoom);
    rc.Bottom := y + Round(bmp.Height * zoom);
    if (rc.Right > rc.Left) and (rc.Bottom > rc.Top) then
    begin
      Bmp2.Canvas.StretchDraw(Rect(0, 0, Bmp2.Width, Bmp2.Height), Bmp);
      if leftzero then
      begin
        SpliteBitmap(paper.Handle, X, Y, Bmp2, $0)
      end
      else
      begin
        SpliteBitmap(paper.Handle, X, Y - Bmp2.Height, Bmp2, $0);
      end;
    end;
    FreeBitmap(index);
    bmp2.Free;
  end;
end;

end.


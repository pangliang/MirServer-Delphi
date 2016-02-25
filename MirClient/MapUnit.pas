unit MapUnit;

interface

uses
  Windows, Classes, SysUtils, Grobal2, HUtil32, DXDraws, cliUtil,
  MShare, Share;



type
  // -------------------------------------------------------------------------------
  // Map
  // -------------------------------------------------------------------------------

  TMapPrjInfo = record
    ident: string[16];
    ColCount: Integer;
    RowCount: Integer;
  end;

  TMapHeader = packed record
    wWidth: Word;
    wHeight: Word;
    sTitle: string[16];
    UpdateDate: TDateTime;
    Reserved: array[0..22] of Char;
  end;
  TMapInfo = packed record
    wBkImg: Word;
    wMidImg: Word;
    wFrImg: Word;
    btDoorIndex: byte; //$80 (¹®Â¦), ¹®ÀÇ ½Äº° ÀÎµ¦½º
    btDoorOffset: byte; //´ÝÈù ¹®ÀÇ ±×¸²ÀÇ »ó´ë À§Ä¡, $80 (¿­¸²/´ÝÈû(±âº»))
    btAniFrame: byte; //$80(Draw Alpha) +  ÇÁ·¡ÀÓ ¼ö
    btAniTick: byte;
    btArea: byte; //Áö¿ª Á¤º¸
    btLight: byte; //0..1..4 ±¤¿ø È¿°ú
  end;
  pTMapInfo = ^TMapInfo;

  TMapInfoArr = array[0..MaxListSize] of TMapInfo;
  pTMapInfoArr = ^TMapInfoArr;

  TMap = class
  private
    function LoadMapInfo(sMapFile: string; var nWidth, nHeight: Integer): Boolean;
    procedure UpdateMapSeg(cx, cy: Integer); //, maxsegx, maxsegy: integer);
    procedure LoadMapArr(nCurrX, nCurrY: Integer);
    procedure SaveMapArr(nCurrX, nCurrY: Integer);
  public
    m_sMapBase: string;
    m_MArr: array[0..MAXX * 3, 0..MAXY * 3] of TMapInfo;
    m_boChange: Boolean;
    m_ClientRect: TRect;
    m_OldClientRect: TRect;
    m_nBlockLeft: Integer;
    m_nBlockTop: Integer; //Å¸ÀÏ ÁÂÇ¥·Î ¿ÞÂÊ, ²À´ë±â ÁÂÇ¥
    m_nOldLeft: Integer;
    m_nOldTop: Integer;
    m_sOldMap: string;
    m_nCurUnitX: Integer;
    m_nCurUnitY: Integer;
    m_sCurrentMap: string;
    m_boSegmented: Boolean;
    m_nSegXCount: Integer;
    m_nSegYCount: Integer;
    constructor Create;
    destructor Destroy; override; //Jacky
    procedure UpdateMapSquare(cx, cy: Integer);
    procedure UpdateMapPos(mx, my: Integer);
    procedure ReadyReload;
    procedure LoadMap(sMapName: string; nMx, nMy: Integer);
    procedure MarkCanWalk(mx, my: Integer; bowalk: Boolean);
    function CanMove(mx, my: Integer): Boolean;
    function CanFly(mx, my: Integer): Boolean;
    function GetDoor(mx, my: Integer): Integer;
    function IsDoorOpen(mx, my: Integer): Boolean;
    function OpenDoor(mx, my: Integer): Boolean;
    function CloseDoor(mx, my: Integer): Boolean;
  end;

procedure DrawMiniMap;

implementation

uses
  ClMain;


constructor TMap.Create;
begin
  inherited Create;
  //GetMem (MInfoArr, sizeof(TMapInfo) * LOGICALMAPUNIT * 3 * LOGICALMAPUNIT * 3);
  m_ClientRect := Rect(0, 0, 0, 0);
  m_boChange := FALSE;
  m_sMapBase := '.\Map\';
  m_sCurrentMap := '';
  m_boSegmented := FALSE;
  m_nSegXCount := 0;
  m_nSegYCount := 0;
  m_nCurUnitX := -1;
  m_nCurUnitY := -1;
  m_nBlockLeft := -1;
  m_nBlockTop := -1;
  m_sOldMap := '';
end;

destructor TMap.Destroy;
begin
  inherited Destroy;
end;

function TMap.LoadMapInfo(sMapFile: string; var nWidth, nHeight: Integer): Boolean;
var
  sFileName: string;
  nHandle: Integer;
  Header: TMapHeader;
begin
  Result := FALSE;
  sFileName := m_sMapBase + sMapFile;
  if FileExists(sFileName) then begin
    nHandle := FileOpen(sFileName, fmOpenRead or fmShareDenyNone);
    if nHandle > 0 then begin
      FileRead(nHandle, Header, sizeof(TMapHeader));
      nWidth := Header.wWidth;
      nHeight := Header.wHeight;
    end;
    FileClose(nHandle);
  end;
end;

//segmented map ÀÎ °æ¿ì
procedure TMap.UpdateMapSeg(cx, cy: Integer); //, maxsegx, maxsegy: integer);
begin

end;

//¼ÓÔØµØÍ¼¶ÎÊý¾Ý
//ÒÔµ±Ç°×ù±êÎª×¼
procedure TMap.LoadMapArr(nCurrX, nCurrY: Integer);
var
  i: Integer;
  k: Integer;
  nAline: Integer;
  nLx: Integer;
  nRx: Integer;
  nTy: Integer;
  nBy: Integer;
  sFileName: string;
  nHandle: Integer;
  Header: TMapHeader;
begin
  FillChar(m_MArr, sizeof(m_MArr), #0);
  sFileName := m_sMapBase + m_sCurrentMap + '.map';
  if FileExists(sFileName) then begin
    nHandle := FileOpen(sFileName, fmOpenRead or fmShareDenyNone);
    if nHandle > 0 then begin
      FileRead(nHandle, Header, sizeof(TMapHeader));
      nLx := (nCurrX - 1) * LOGICALMAPUNIT;
      nRx := (nCurrX + 2) * LOGICALMAPUNIT; //rx
      nTy := (nCurrY - 1) * LOGICALMAPUNIT;
      nBy := (nCurrY + 2) * LOGICALMAPUNIT;

      if nLx < 0 then nLx := 0;
      if nTy < 0 then nTy := 0;
      if nBy >= Header.wHeight then nBy := Header.wHeight;
      nAline := sizeof(TMapInfo) * Header.wHeight;
      for i := nLx to nRx - 1 do begin
        if (i >= 0) and (i < Header.wWidth) then begin
          FileSeek(nHandle, sizeof(TMapHeader) + (nAline * i) + (sizeof(TMapInfo) * nTy), 0);
          FileRead(nHandle, m_MArr[i - nLx, 0], sizeof(TMapInfo) * (nBy - nTy));
        end;
      end;
      FileClose(nHandle);
    end;
  end;
end;

procedure TMap.SaveMapArr(nCurrX, nCurrY: Integer);
var
  i: Integer;
  k: Integer;
  nAline: Integer;
  nLx: Integer;
  nRx: Integer;
  nTy: Integer;
  nBy: Integer;
  sFileName: string;
  nHandle: Integer;
  Header: TMapHeader;
begin
  FillChar(m_MArr, sizeof(m_MArr), #0);
  sFileName := m_sMapBase + m_sCurrentMap + '.map';
  if FileExists(sFileName) then begin
    nHandle := FileOpen(sFileName, fmOpenRead or fmShareDenyNone);
    if nHandle > 0 then begin
      FileRead(nHandle, Header, sizeof(TMapHeader));
      nLx := (nCurrX - 1) * LOGICALMAPUNIT;
      nRx := (nCurrX + 2) * LOGICALMAPUNIT; //rx
      nTy := (nCurrY - 1) * LOGICALMAPUNIT;
      nBy := (nCurrY + 2) * LOGICALMAPUNIT;

      if nLx < 0 then nLx := 0;
      if nTy < 0 then nTy := 0;
      if nBy >= Header.wHeight then nBy := Header.wHeight;
      nAline := sizeof(TMapInfo) * Header.wHeight;
      for i := nLx to nRx - 1 do begin
        if (i >= 0) and (i < Header.wWidth) then begin
          FileSeek(nHandle, sizeof(TMapHeader) + (nAline * i) + (sizeof(TMapInfo) * nTy), 0);
          FileRead(nHandle, m_MArr[i - nLx, 0], sizeof(TMapInfo) * (nBy - nTy));
        end;
      end;
      FileClose(nHandle);
    end;
  end;
end;
procedure TMap.ReadyReload;
begin
  m_nCurUnitX := -1;
  m_nCurUnitY := -1;
end;

//cx, cy: Áß¾Ó, Counted by unit..
procedure TMap.UpdateMapSquare(cx, cy: Integer);
begin
  if (cx <> m_nCurUnitX) or (cy <> m_nCurUnitY) then begin
    if m_boSegmented then
      UpdateMapSeg(cx, cy)
    else
      LoadMapArr(cx, cy);
    m_nCurUnitX := cx;
    m_nCurUnitY := cy;
  end;
end;

//ÁÖÄ³¸¯ÀÌ ÀÌµ¿½Ã ºó¹øÀÌ È£Ãâ..
procedure TMap.UpdateMapPos(mx, my: Integer);
var
  cx, cy: Integer;
  procedure Unmark(xx, yy: Integer);
  var
    ax, ay: Integer;
  begin
    if (cx = xx div LOGICALMAPUNIT) and (cy = yy div LOGICALMAPUNIT) then begin
      ax := xx - m_nBlockLeft;
      ay := yy - m_nBlockTop;
      m_MArr[ax, ay].wFrImg := m_MArr[ax, ay].wFrImg and $7FFF;
      m_MArr[ax, ay].wBkImg := m_MArr[ax, ay].wBkImg and $7FFF;
    end;
  end;
begin
  cx := mx div LOGICALMAPUNIT;
  cy := my div LOGICALMAPUNIT;
  m_nBlockLeft := _MAX(0, (cx - 1) * LOGICALMAPUNIT);
  m_nBlockTop := _MAX(0, (cy - 1) * LOGICALMAPUNIT);

  UpdateMapSquare(cx, cy);

  if (m_nOldLeft <> m_nBlockLeft) or (m_nOldTop <> m_nBlockTop) or (m_sOldMap <> m_sCurrentMap) then begin
    //3¹ø¸Ê ¼ºº®ÀÚ¸® ¹ö±× º¸Á¤ (2001-7-3)
    if m_sCurrentMap = '3' then begin
      Unmark(624, 278);
      Unmark(627, 278);
      Unmark(634, 271);

      Unmark(564, 287);
      Unmark(564, 286);
      Unmark(661, 277);
      Unmark(578, 296);
    end;
  end;
  m_nOldLeft := m_nBlockLeft;
  m_nOldTop := m_nBlockTop;
end;

//¸Êº¯°æ½Ã Ã³À½ ÇÑ¹ø È£Ãâ..
procedure TMap.LoadMap(sMapName: string; nMx, nMy: Integer);
begin
  m_nCurUnitX := -1;
  m_nCurUnitY := -1;
  m_sCurrentMap := sMapName;
  m_boSegmented := FALSE; //Segmented µÇ¾î ÀÖ´ÂÁö °Ë»çÇÑ´Ù.
  UpdateMapPos(nMx, nMy);
  m_sOldMap := m_sCurrentMap;
end;

procedure TMap.MarkCanWalk(mx, my: Integer; bowalk: Boolean);
var
  cx, cy: Integer;
begin
  cx := mx - m_nBlockLeft;
  cy := my - m_nBlockTop;
  if (cx < 0) or (cy < 0) then Exit;
  if bowalk then //°ÉÀ» ¼ö ÀÖÀ½
    Map.m_MArr[cx, cy].wFrImg := Map.m_MArr[cx, cy].wFrImg and $7FFF
  else //¸·ÇûÀ½
    Map.m_MArr[cx, cy].wFrImg := Map.m_MArr[cx, cy].wFrImg or $8000; //¸ø¿òÁ÷ÀÌ°Ô ÇÑ´Ù.
end;

function TMap.CanMove(mx, my: Integer): Boolean;
var
  cx, cy: Integer;
begin
  Result := FALSE; //jacky
  cx := mx - m_nBlockLeft;
  cy := my - m_nBlockTop;
  if (cx < 0) or (cy < 0) then Exit;
  Result := ((Map.m_MArr[cx, cy].wBkImg and $8000) + (Map.m_MArr[cx, cy].wFrImg and $8000)) = 0;
  if Result then begin //¹®°Ë»ç
    if Map.m_MArr[cx, cy].btDoorIndex and $80 > 0 then begin //¹®Â¦ÀÌ ÀÖÀ½
      if (Map.m_MArr[cx, cy].btDoorOffset and $80) = 0 then
        Result := FALSE; //¹®ÀÌ ¾È ¿­·ÈÀ½.
    end;
  end;
end;

function TMap.CanFly(mx, my: Integer): Boolean;
var
  cx, cy: Integer;
begin
  Result := FALSE; //jacky
  cx := mx - m_nBlockLeft;
  cy := my - m_nBlockTop;
  if (cx < 0) or (cy < 0) then Exit;
  Result := (Map.m_MArr[cx, cy].wFrImg and $8000) = 0;
  if Result then begin //¹®°Ë»ç
    if Map.m_MArr[cx, cy].btDoorIndex and $80 > 0 then begin //¹®Â¦ÀÌ ÀÖÀ½
      if (Map.m_MArr[cx, cy].btDoorOffset and $80) = 0 then
        Result := FALSE; //¹®ÀÌ ¾È ¿­·ÈÀ½.
    end;
  end;
end;

function TMap.GetDoor(mx, my: Integer): Integer;
var
  cx, cy: Integer;
begin
  Result := 0;
  cx := mx - m_nBlockLeft;
  cy := my - m_nBlockTop;
  if Map.m_MArr[cx, cy].btDoorIndex and $80 > 0 then begin
    Result := Map.m_MArr[cx, cy].btDoorIndex and $7F;
  end;
end;

function TMap.IsDoorOpen(mx, my: Integer): Boolean;
var
  cx, cy: Integer;
begin
  Result := FALSE;
  cx := mx - m_nBlockLeft;
  cy := my - m_nBlockTop;
  if Map.m_MArr[cx, cy].btDoorIndex and $80 > 0 then begin
    Result := (Map.m_MArr[cx, cy].btDoorOffset and $80 <> 0);
  end;
end;

function TMap.OpenDoor(mx, my: Integer): Boolean;
var
  i, j, cx, cy, idx: Integer;
begin
  Result := FALSE;
  cx := mx - m_nBlockLeft;
  cy := my - m_nBlockTop;
  if (cx < 0) or (cy < 0) then Exit;
  if Map.m_MArr[cx, cy].btDoorIndex and $80 > 0 then begin
    idx := Map.m_MArr[cx, cy].btDoorIndex and $7F;
    for i := cx - 10 to cx + 10 do
      for j := cy - 10 to cy + 10 do begin
        if (i > 0) and (j > 0) then
          if (Map.m_MArr[i, j].btDoorIndex and $7F) = idx then
            Map.m_MArr[i, j].btDoorOffset := Map.m_MArr[i, j].btDoorOffset or $80;
      end;
  end;
end;

function TMap.CloseDoor(mx, my: Integer): Boolean;
var
  i, j, cx, cy, idx: Integer;
begin
  Result := FALSE;
  cx := mx - m_nBlockLeft;
  cy := my - m_nBlockTop;
  if (cx < 0) or (cy < 0) then Exit;
  if Map.m_MArr[cx, cy].btDoorIndex and $80 > 0 then begin
    idx := Map.m_MArr[cx, cy].btDoorIndex and $7F;
    for i := cx - 8 to cx + 10 do
      for j := cy - 8 to cy + 10 do begin
        if (Map.m_MArr[i, j].btDoorIndex and $7F) = idx then
          Map.m_MArr[i, j].btDoorOffset := Map.m_MArr[i, j].btDoorOffset and $7F;
      end;
  end;
end;


const
  SCALE = 4;

procedure DrawMiniMap;
var
  sx, sy, ex, ey, i, j, imgnum, wunit, ani, nY, oheight, mx, my: Integer;
  d: TDirectDrawSurface;
begin
  g_MiniMapSurface.Fill(0);
  mx := UNITX div SCALE;
  my := UNITY div SCALE;
  sx := _MAX(0, (g_MySelf.m_nCurrX - Map.m_nBlockLeft) div 2 * 2 - 22);
  ex := _MIN(MAXX * 3, (g_MySelf.m_nCurrX - Map.m_nBlockLeft) div 2 * 2 + 22);
  sy := _MAX(0, (g_MySelf.m_nCurrY - Map.m_nBlockTop) div 2 * 2 - 22);
  ey := _MIN(MAXY * 3, (g_MySelf.m_nCurrY - Map.m_nBlockTop) div 2 * 2 + 22);

  for i := 0 to ex - sx do begin
    for j := 0 to ey - sy do begin
      if (i >= 0) and (j < MAXY * 3) and ((i + sx) mod 2 = 0) and ((j + sy) mod 2 = 0) then begin
        imgnum := (Map.m_MArr[sx + i, sy + j].wBkImg and $7FFF);
        if imgnum > 0 then begin
          imgnum := imgnum - 1;
          d := g_WTilesImages.Images[imgnum];
          if d <> nil then
            g_MiniMapSurface.StretchDraw(
              Rect(i * mx, j * my, i * mx + d.Width div SCALE, j * my + d.Height div SCALE),
              d.ClientRect,
              d,
              FALSE);

        end;
      end;
    end;
  end;
  for i := 0 to ex - sx - 1 do begin
    for j := 0 to ey - sy - 1 do begin
      imgnum := Map.m_MArr[sx + i, sy + j].wMidImg;
      if imgnum > 0 then begin
        imgnum := imgnum - 1;
        d := g_WSmTilesImages.Images[imgnum];
        if d <> nil then
          g_MiniMapSurface.StretchDraw(
            Rect(i * mx, j * my, i * mx + d.Width div SCALE, j * my + d.Height div SCALE),
            d.ClientRect,
            d,
            True);
      end;
    end;
  end;
  for j := 0 to ey - sy - 1 + 25 do begin
    for i := 0 to ex - sx do begin
      if (i >= 0) and (i < MAXX * 3) and (j < MAXY * 3) then begin
        imgnum := (Map.m_MArr[sx + i, sy + j].wFrImg and $7FFF);
        if imgnum > 0 then begin
          wunit := Map.m_MArr[sx + i, sy + j].btArea;
          ani := Map.m_MArr[sx + i, sy + j].btAniFrame;
          if (ani and $80) > 0 then begin
            continue;
          end;
          imgnum := imgnum - 1;
          d := GetObjs(wunit, imgnum);
          if d <> nil then begin
            nY := j * my - d.Height div SCALE + my;
            if nY < 360 then
              g_MiniMapSurface.StretchDraw(
                Rect(i * mx, nY, i * mx + d.Width div SCALE, nY + d.Height div SCALE),
                d.ClientRect,
                d,
                True);
          end;
        end;
      end;
    end;
  end;
  //DrawEffect (0, 0, MiniMapSurface.Width, MiniMapSurface.Height, MiniMapSurface, ceGrayScale);
end;


end.

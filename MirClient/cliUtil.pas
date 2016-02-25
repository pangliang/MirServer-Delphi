unit cliUtil;

interface

uses
  Windows, SysUtils, DXDraws, WIL, DirectX, DIB, HUtil32, Classes;


const
   MAXGRADE = 64;

type
  TColorEffect = (ceNone, ceGrayScale{灰色}, ceBright, ceBlack, ceWhite, ceRed, ceGreen, ceBlue, ceYellow, ceFuchsia{紫红色});

  TNearestIndexHeader = record
    Title: string[30];
    IndexCount: integer;
    desc: array[0..10] of byte;
  end;

procedure BuildColorLevels (ctable: TRGBQuads);
procedure BuildNearestIndex (ctable: TRGBQuads);
procedure SaveNearestIndex (flname: string);
function  LoadNearestIndex (flname: string): Boolean;
procedure DrawFog (ssuf: TDirectDrawSurface; fogmask: PByte; fogwidth: integer);
procedure MakeDark (ssuf: TDirectDrawSurface; darklevel: integer);
procedure FogCopy (PSource: Pbyte; ssx, ssy, swidth, sheight: integer;
                   PDest: Pbyte; ddx, ddy, dwidth, dheight, maxfog: integer);
procedure DrawBlend (dsuf: TDirectDrawSurface; x, y: integer; ssuf: TDirectDrawSurface; blendmode: integer);
//procedure DrawBlendEx (dsuf: TDirectDrawSurface; x, y: integer; ssuf: TDirectDrawSurface; ssufleft, ssuftop, ssufwidth, ssufheight, blendmode: integer);
procedure DrawBlendEx(DstSurf: TDirectDrawSurface; DstX, DstY: Integer; SrcSurf: TDirectDrawSurface; SrcSurfLeft, SrcSurfTop, SrcSurfWidth, SrcSurfHeight, BlendMode: Integer);
//解决火龙教主引起程序崩溃问题  20080608
procedure DrawEx (dsuf: TDirectDrawSurface; x, y: integer; ssuf: TDirectDrawSurface; ssufleft, ssuftop, ssufwidth, ssufheight, blendmode: integer);
procedure DrawEffect (x, y, width, height: integer; ssuf: TDirectDrawSurface; eff: TColorEffect);
procedure BuildRealRGB (ctable: TRGBQuads); //解决火龙教主引起程序崩溃问题  20080608
var
   DarkLevel : integer;


implementation

uses Share, ClMain;

var
  Color256Mix: array[0..255, 0..255] of byte;
  Color256Anti: array[0..255, 0..255] of byte;
  HeavyDarkColorLevel: array[0..255, 0..255] of byte;
  LightDarkColorLevel: array[0..255, 0..255] of byte;
  DengunColorLevel: array[0..255, 0..255] of byte;
  BrightColorLevel: array[0..255] of byte;
  GrayScaleLevel: array[0..255] of byte;
  RedishColorLevel: array[0..255] of byte;
  BlackColorLevel: array[0..255] of byte;
  WhiteColorLevel: array[0..255] of byte;
  GreenColorLevel: array[0..255] of byte;
  YellowColorLevel: array[0..255] of byte;
  BlueColorLevel: array[0..255] of byte;
  FuchsiaColorLevel: array[0..255] of byte;
//解决火龙教主引起程序崩溃问题  20080608
  Color256real: array[0..255, 0..255] of byte;

procedure BuildNearestIndex (ctable: TRGBQuads);
var
   MinDif, ColDif: Integer;
   MatchColor: Byte;
   pal0, pal1, pal2: TRGBQuad;

   procedure BuildMix;
   var
      i, j, n: integer;
   begin
      for i:=0 to 255 do begin
         pal0 := ctable[i];
         for j:=0 to 255 do begin
            pal1 := ctable[j];
            pal1.rgbRed := pal0.rgbRed div 2 + pal1.rgbRed div 2;
            pal1.rgbGreen := pal0.rgbGreen div 2 + pal1.rgbGreen div 2;
            pal1.rgbBlue := pal0.rgbBlue div 2 + pal1.rgbBlue div 2;
            MinDif := 768;
            MatchColor := 0;
            for n:=0 to 255 do begin
               pal2 := ctable[n];
               ColDif := Abs(pal2.rgbRed - pal1.rgbRed) +
                         Abs(pal2.rgbGreen - pal1.rgbGreen) +
                         Abs(pal2.rgbBlue - pal1.rgbBlue);
               if ColDif < MinDif then begin
                  MinDif := ColDif;
                  MatchColor := n;
               end;
            end;
            Color256Mix[i, j] := MatchColor;
         end;
      end;
   end;
   procedure BuildAnti;
   var
      i, j, n: integer;
   begin
      for i:=0 to 255 do begin
         pal0 := ctable[i];
         for j:=0 to 255 do begin
            pal1 := ctable[j];
            //ever := _MAX(pal0.rgbRed, pal0.rgbGreen);
            //ever := _MAX(ever, pal0.rgbBlue);
            pal1.rgbRed := _MIN(255, Round (pal0.rgbRed  + (255-pal0.rgbRed)/255 * pal1.rgbRed));
            pal1.rgbGreen := _MIN(255, Round (pal0.rgbGreen  + (255-pal0.rgbGreen)/255 * pal1.rgbGreen));
            pal1.rgbBlue := _MIN(255, Round (pal0.rgbBlue  + (255-pal0.rgbBlue)/255 * pal1.rgbBlue));
            MinDif := 768;
            MatchColor := 0;
            for n:=0 to 255 do begin
               pal2 := ctable[n];
               ColDif := Abs(pal2.rgbRed - pal1.rgbRed) +
                         Abs(pal2.rgbGreen - pal1.rgbGreen) +
                         Abs(pal2.rgbBlue - pal1.rgbBlue);
               if ColDif < MinDif then begin
                  MinDif := ColDif;
                  MatchColor := n;
               end;
            end;
            Color256Anti[i, j] := MatchColor;
         end;
      end;
   end;
   procedure BuildColorLevels;
   var
      n, i, j, rr, gg, bb: integer;
   begin
      for n:=0 to 30 do begin
         for i:=0 to 255 do begin
            pal1 := ctable[i];
            rr := _MIN(Round(pal1.rgbRed * (n+1) / 31) - 5, 255);      //(n + (n-1)*3) / 121);
            gg := _MIN(Round(pal1.rgbGreen * (n+1) / 31) - 5, 255);  //(n + (n-1)*3) / 121);
            bb := _MIN(Round(pal1.rgbBlue * (n+1) / 31) - 5, 255);    //(n + (n-1)*3) / 121);
            pal1.rgbRed := _MAX(0, rr);
            pal1.rgbGreen := _MAX(0, gg);
            pal1.rgbBlue := _MAX(0, bb);
            MinDif := 768;
            MatchColor := 0;
            for j:=0 to 255 do begin
               pal2 := ctable[j];
               ColDif := Abs(pal2.rgbRed - pal1.rgbRed) +
                         Abs(pal2.rgbGreen - pal1.rgbGreen) +
                         Abs(pal2.rgbBlue - pal1.rgbBlue);
               if ColDif < MinDif then begin
                  MinDif := ColDif;
                  MatchColor := j;
               end;
            end;
            HeavyDarkColorLevel[n, i] := MatchColor;
         end;
      end;
      for n:=0 to 30 do begin
         for i:=0 to 255 do begin
            pal1 := ctable[i];
            pal1.rgbRed := _MIN(Round(pal1.rgbRed * (n*3+47) / 140), 255);
            pal1.rgbGreen := _MIN(Round(pal1.rgbGreen * (n*3+47) / 140), 255);
            pal1.rgbBlue := _MIN(Round(pal1.rgbBlue * (n*3+47) / 140), 255);
            MinDif := 768;
            MatchColor := 0;
            for j:=0 to 255 do begin
               pal2 := ctable[j];
               ColDif := Abs(pal2.rgbRed - pal1.rgbRed) +
                         Abs(pal2.rgbGreen - pal1.rgbGreen) +
                         Abs(pal2.rgbBlue - pal1.rgbBlue);
               if ColDif < MinDif then begin
                  MinDif := ColDif;
                  MatchColor := j;
               end;
            end;
            LightDarkColorLevel[n, i] := MatchColor;
         end;
      end;
      for n:=0 to 30 do begin
         for i:=0 to 255 do begin
            pal1 := ctable[i];
            pal1.rgbRed := _MIN(Round(pal1.rgbRed * (n*3+120) / 214), 255);
            pal1.rgbGreen := _MIN(Round(pal1.rgbGreen * (n*3+120) / 214), 255);
            pal1.rgbBlue := _MIN(Round(pal1.rgbBlue * (n*3+120) / 214), 255);
            MinDif := 768;
            MatchColor := 0;
            for j:=0 to 255 do begin
               pal2 := ctable[j];
               ColDif := Abs(pal2.rgbRed - pal1.rgbRed) +
                         Abs(pal2.rgbGreen - pal1.rgbGreen) +
                         Abs(pal2.rgbBlue - pal1.rgbBlue);
               if ColDif < MinDif then begin
                  MinDif := ColDif;
                  MatchColor := j;
               end;
            end;
            DengunColorLevel[n, i] := MatchColor;
         end;
      end;
      for n:=31 to 255 do
         for i:=0 to 255 do begin
            HeavyDarkColorLevel[n, i] := HeavyDarkColorLevel[30, i];
            LightDarkColorLevel[n, i] := LightDarkColorLevel[30, i];
            DengunColorLevel[n, i] := DengunColorLevel[30, i];
         end;

   end;
begin
   BuildMix;
   BuildAnti;
   BuildColorLevels;
end;

procedure BuildColorLevels (ctable: TRGBQuads);
var
   n, i, j, MinDif, ColDif: integer;
   pal1, pal2: TRGBQuad;
   MatchColor: byte;
begin
   BrightColorLevel[0] := 0;
   for i:=1 to 255 do begin
      pal1 := ctable[i];
      pal1.rgbRed := _MIN(Round(pal1.rgbRed * 1.3), 255);
      pal1.rgbGreen := _MIN(Round(pal1.rgbGreen * 1.3), 255);
      pal1.rgbBlue := _MIN(Round(pal1.rgbBlue * 1.3), 255);
      MinDif := 768;
      MatchColor := 0;
      for j:=1 to 255 do begin
         pal2 := ctable[j];
         ColDif := Abs(pal2.rgbRed - pal1.rgbRed) +
                   Abs(pal2.rgbGreen - pal1.rgbGreen) +
                   Abs(pal2.rgbBlue - pal1.rgbBlue);
         if ColDif < MinDif then begin
            MinDif := ColDif;
            MatchColor := j;
         end;
      end;
      BrightColorLevel[i] := MatchColor;
   end;
   GrayScaleLevel[0] := 0;
   for i:=1 to 255 do begin
      pal1 := ctable[i];
      n := (pal1.rgbRed + pal1.rgbGreen + pal1.rgbBlue) div 3;
      pal1.rgbRed := n; //Round(pal1.rgbRed * (n*3+25) / 118);
      pal1.rgbGreen := n; //Round(pal1.rgbGreen * (n*3+25) / 118);
      pal1.rgbBlue := n; //Round(pal1.rgbBlue * (n*3+25) / 118);
      MinDif := 768;
      MatchColor := 0;
      for j:=1 to 255 do begin
         pal2 := ctable[j];
         ColDif := Abs(pal2.rgbRed - pal1.rgbRed) +
                   Abs(pal2.rgbGreen - pal1.rgbGreen) +
                   Abs(pal2.rgbBlue - pal1.rgbBlue);
         if ColDif < MinDif then begin
            MinDif := ColDif;
            MatchColor := j;
         end;
      end;
      GrayScaleLevel[i] := MatchColor;
   end;
   BlackColorLevel[0] := 0;
   for i:=1 to 255 do begin
      pal1 := ctable[i];
      n := Round ((pal1.rgbRed + pal1.rgbGreen + pal1.rgbBlue) / 3 * 0.6);
      pal1.rgbRed := n; //_MAX(8, Round(pal1.rgbRed * 0.7));
      pal1.rgbGreen := n; //_MAX(8, Round(pal1.rgbGreen * 0.7));
      pal1.rgbBlue := n; //_MAX(8, Round(pal1.rgbBlue * 0.7));
      MinDif := 768;
      MatchColor := 0;
      for j:=1 to 255 do begin
         pal2 := ctable[j];
         ColDif := Abs(pal2.rgbRed - pal1.rgbRed) +
                   Abs(pal2.rgbGreen - pal1.rgbGreen) +
                   Abs(pal2.rgbBlue - pal1.rgbBlue);
         if ColDif < MinDif then begin
            MinDif := ColDif;
            MatchColor := j;
         end;
      end;
      BlackColorLevel[i] := MatchColor;
   end;
   WhiteColorLevel[0] := 0;
   for i:=1 to 255 do begin
      pal1 := ctable[i];
      n := _MIN (Round ((pal1.rgbRed + pal1.rgbGreen + pal1.rgbBlue) / 3 * 1.6), 255);
      pal1.rgbRed := n; //_MAX(8, Round(pal1.rgbRed * 0.7));
      pal1.rgbGreen := n; //_MAX(8, Round(pal1.rgbGreen * 0.7));
      pal1.rgbBlue := n; //_MAX(8, Round(pal1.rgbBlue * 0.7));
      MinDif := 768;
      MatchColor := 0;
      for j:=1 to 255 do begin
         pal2 := ctable[j];
         ColDif := Abs(pal2.rgbRed - pal1.rgbRed) +
                   Abs(pal2.rgbGreen - pal1.rgbGreen) +
                   Abs(pal2.rgbBlue - pal1.rgbBlue);
         if ColDif < MinDif then begin
            MinDif := ColDif;
            MatchColor := j;
         end;
      end;
      WhiteColorLevel[i] := MatchColor;
   end;
   RedishColorLevel[0] := 0;
   for i:=1 to 255 do begin
      pal1 := ctable[i];
      n := (pal1.rgbRed + pal1.rgbGreen + pal1.rgbBlue) div 3;
      pal1.rgbRed := n;
      pal1.rgbGreen := 0;
      pal1.rgbBlue := 0;
      MinDif := 768;
      MatchColor := 0;
      for j:=1 to 255 do begin
         pal2 := ctable[j];
         ColDif := Abs(pal2.rgbRed - pal1.rgbRed) +
                   Abs(pal2.rgbGreen - pal1.rgbGreen) +
                   Abs(pal2.rgbBlue - pal1.rgbBlue);
         if ColDif < MinDif then begin
            MinDif := ColDif;
            MatchColor := j;
         end;
      end;
      RedishColorLevel[i] := MatchColor;
   end;
   GreenColorLevel[0] := 0;
   for i:=1 to 255 do begin
      pal1 := ctable[i];
      n := (pal1.rgbRed + pal1.rgbGreen + pal1.rgbBlue) div 3;
      pal1.rgbRed := 0;
      pal1.rgbGreen := n;
      pal1.rgbBlue := 0;
      MinDif := 768;
      MatchColor := 0;
      for j:=1 to 255 do begin
         pal2 := ctable[j];
         ColDif := Abs(pal2.rgbRed - pal1.rgbRed) +
                   Abs(pal2.rgbGreen - pal1.rgbGreen) +
                   Abs(pal2.rgbBlue - pal1.rgbBlue);
         if ColDif < MinDif then begin
            MinDif := ColDif;
            MatchColor := j;
         end;
      end;
      GreenColorLevel[i] := MatchColor;
   end;
   YellowColorLevel[0] := 0;
   for i:=1 to 255 do begin
      pal1 := ctable[i];
      n := (pal1.rgbRed + pal1.rgbGreen + pal1.rgbBlue) div 3;
      pal1.rgbRed := n;
      pal1.rgbGreen := n;
      pal1.rgbBlue := 0;
      MinDif := 768;
      MatchColor := 0;
      for j:=1 to 255 do begin
         pal2 := ctable[j];
         ColDif := Abs(pal2.rgbRed - pal1.rgbRed) +
                   Abs(pal2.rgbGreen - pal1.rgbGreen) +
                   Abs(pal2.rgbBlue - pal1.rgbBlue);
         if ColDif < MinDif then begin
            MinDif := ColDif;
            MatchColor := j;
         end;
      end;
      YellowColorLevel[i] := MatchColor;
   end;
   BlueColorLevel[0] := 0;
   for i:=1 to 255 do begin
      pal1 := ctable[i];
      n := (pal1.rgbRed + pal1.rgbGreen + pal1.rgbBlue) div 3;
      pal1.rgbRed := 0; //_MIN(Round(n*1.3), 255);
      pal1.rgbGreen := 0; //_MIN(Round(n), 255);
      pal1.rgbBlue := n; //_MIN(Round(n*1.3), 255);
      MinDif := 768;
      MatchColor := 0;
      for j:=1 to 255 do begin
         pal2 := ctable[j];
         ColDif := Abs(pal2.rgbRed - pal1.rgbRed) +
                   Abs(pal2.rgbGreen - pal1.rgbGreen) +
                   Abs(pal2.rgbBlue - pal1.rgbBlue);
         if ColDif < MinDif then begin
            MinDif := ColDif;
            MatchColor := j;
         end;
      end;
      BlueColorLevel[i] := MatchColor;
   end;
   FuchsiaColorLevel[0] := 0;
   for i:=1 to 255 do begin
      pal1 := ctable[i];
      n := (pal1.rgbRed + pal1.rgbGreen + pal1.rgbBlue) div 3;
      pal1.rgbRed := n;
      pal1.rgbGreen := 0;
      pal1.rgbBlue := n;
      MinDif := 768;
      MatchColor := 0;
      for j:=1 to 255 do begin
         pal2 := ctable[j];
         ColDif := Abs(pal2.rgbRed - pal1.rgbRed) +
                   Abs(pal2.rgbGreen - pal1.rgbGreen) +
                   Abs(pal2.rgbBlue - pal1.rgbBlue);
         if ColDif < MinDif then begin
            MinDif := ColDif;
            MatchColor := j;
         end;
      end;
      FuchsiaColorLevel[i] := MatchColor;
   end;
end;


procedure SaveNearestIndex (flname: string);
var
   nih: TNearestIndexHeader;
   fhandle: integer;
begin
   nih.Title := 'WEMADE Entertainment Inc.';
   nih.IndexCount := Sizeof(Color256Mix);
   if FileExists (flname) then begin
      fhandle := FileOpen (flname, fmOpenWrite or fmShareDenyNone);
   end else
      fhandle := FileCreate (flname);
   if fhandle > 0 then begin
      FileWrite (fhandle, nih, sizeof(TNearestIndexHeader));
      FileWrite (fhandle, Color256Mix, sizeof(Color256Mix));
      FileWrite (fhandle, Color256Anti, sizeof(Color256Anti));
      FileWrite (fhandle, HeavyDarkColorLevel, sizeof(HeavyDarkColorLevel));
      FileWrite (fhandle, LightDarkColorLevel, sizeof(LightDarkColorLevel)); 
      FileWrite (fhandle, DengunColorLevel, sizeof(DengunColorLevel));
      FileClose (fhandle);
   end;
end;

function LoadNearestIndex (flname: string): Boolean;
var
   nih: TNearestIndexHeader;
   fhandle, rsize: integer;
begin
   Result := FALSE;
   if FileExists (flname) then begin
      fhandle := FileOpen (flname, fmOpenRead or fmShareDenyNone);
      if fhandle > 0 then begin
         FileRead (fhandle, nih, sizeof(TNearestIndexHeader));
         if nih.IndexCount = Sizeof(Color256Mix) then begin
            Result := TRUE;
            rsize := 256*256;
            if rsize <> FileRead (fhandle, Color256Mix, sizeof(Color256Mix)) then Result := FALSE;
            if rsize <> FileRead (fhandle, Color256Anti, sizeof(Color256Anti)) then Result := FALSE;
            if rsize <> FileRead (fhandle, HeavyDarkColorLevel, sizeof(HeavyDarkColorLevel)) then Result := FALSE;
            if rsize <> FileRead (fhandle, LightDarkColorLevel, sizeof(LightDarkColorLevel)) then Result := FALSE;
            if rsize <> FileRead (fhandle, DengunColorLevel, sizeof(DengunColorLevel)) then Result := FALSE;
         end;
         FileClose (fhandle);
      end;
   end;
end;

procedure FogCopy (PSource: Pbyte; ssx, ssy, swidth, sheight: integer;
                   PDest: Pbyte; ddx, ddy, dwidth, dheight, maxfog: integer);
var
   row, srclen, srcheight, spitch, dpitch: integer;
begin
   if (PSource = nil) or (pDest = nil) then exit; 
   spitch := swidth;
   dpitch := dwidth;
   if ddx < 0 then begin
      ssx := ssx - ddx;
      swidth := swidth + ddx;
      ddx := 0;
   end;
   if ddy < 0 then begin
      ssy := ssy - ddy;
      sheight := sheight + ddy;
      ddy := 0;
   end;
   srclen := _MIN(swidth, dwidth-ddx);
   srcheight := _MIN(sheight, dheight-ddy);
   if (srclen <= 0) or (srcheight <= 0) then exit;

   asm
         mov   row, 0
      @@NextRow:
         mov   eax, row
         cmp   eax, srcheight
         jae   @@Finish

         mov   esi, psource
         mov   eax, ssy
         add   eax, row
         mov   ebx, spitch
         imul  eax, ebx
         add   eax, ssx
         add   esi, eax          //sptr

         mov   edi, pdest
         mov   eax, ddy
         add   eax, row
         mov   ebx, dpitch
         imul  eax, ebx
         add   eax, ddx
         add   edi, eax          //dptr

         mov   ebx, srclen
      @@FogNext:
         cmp   ebx, 0
         jbe   @@FinOne
         cmp   ebx, 8
         jb    @@FinOne   //@@EageNext

         db $0F,$6F,$06           /// movq  mm0, [esi]
         db $0F,$6F,$0F           /// movq  mm1, [edi]
         db $0F,$FE,$C8           /// paddd mm1, mm0
         db $0F,$7F,$0F           /// movq [edi], mm1

         sub   ebx, 8
         add   esi, 8
         add   edi, 8
         jmp   @@FogNext
      @@FinOne:
         inc   row
         jmp   @@NextRow

      @@Finish:
         db $0F,$77               /// emms
   end;
end;  

procedure DrawFog (ssuf: TDirectDrawSurface; fogmask: PByte; fogwidth: integer);
var
   row: integer;
   ddsd: TDDSurfaceDesc;
   srclen, srcheight: integer;
   lpitch: integer;
   {pSrc,} psource, pColorLevel: Pbyte;
begin
   if ssuf.Width > SCREENWIDTH + 100 then exit;
   case DarkLevel of
      1: pColorLevel := @HeavyDarkColorLevel;
      2: pColorLevel := @LightDarkColorLevel;
      3: pColorLevel := @DengunColorLevel;
      else exit;
   end;

   try
      ddsd.dwSize := SizeOf(ddsd);
      ssuf.Lock (TRect(nil^), ddsd);
      srclen := _MIN(ssuf.Width, fogwidth);
     //pSrc := @src;
      srcheight := ssuf.Height;
      lpitch := ddsd.lPitch;
      psource := ddsd.lpSurface;

      asm
            mov   row, 0
         @@NextRow:
            mov   ebx, row
            mov   eax, srcheight
            cmp   ebx, eax
            jae   @@DrawFogFin

            mov   esi, psource      //esi = ddsd.lpSurface;
            mov   eax, lpitch
            mov   ebx, row
            imul  eax, ebx
            add   esi, eax

            mov   edi, fogmask      //edi = fogmask
            mov   eax, fogwidth
            mov   ebx, row
            imul  eax, ebx
            add   edi, eax

            mov   ecx, srclen
            mov   edx, pColorLevel

         @@NextByte:
            cmp   ecx, 0
            jbe   @@Finish

            movzx eax, [edi].byte   //fogmask
            ///cmp   eax, 30
            ///ja    @@SkipByte
            imul  eax, 256
            movzx ebx, [esi].byte   //家胶 ddsd.lpSurface;
            add   eax, ebx
            mov   al, [edx+eax].byte //pColorLevel
            mov   [esi].byte, al
         ///@@SkipByte:
            dec   ecx
            inc   esi
            inc   edi
            jmp   @@NextByte

         @@Finish:
            inc   row
            jmp   @@NextRow

         @@DrawFogFin:
            db $0F,$77               /// emms
      end;
   finally
      ssuf.UnLock();
   end;
end;

procedure MakeDark (ssuf: TDirectDrawSurface; darklevel: integer);
var
   row, count: integer;
   ddsd: TDDSurfaceDesc;
   //source: array[0..910] of byte;
   scount, srclen, srcheight: integer;
   lpitch: integer;
   src: array[0..7] of byte;
   pSrc, psource, pColorLevel: Pbyte;
begin
   if not darklevel in [1..30] then exit;
   if ssuf.Width > SCREENWIDTH + 100 then exit;
//   if ssuf.Width > 900 then exit;
   try
      ddsd.dwSize := SizeOf(ddsd);
      ssuf.Lock (TRect(nil^), ddsd);
      srclen := ssuf.Width;
      srcheight := ssuf.Height;
      pSrc := @src;
      //if HeavyDark then pColorLevel := @HeavyDarkColorLevel
      //else pColorLevel := @LightDarkColorLevel;
      pColorLevel := @HeavyDarkColorLevel;
      lpitch := ddsd.lPitch;
      psource := ddsd.lpSurface;

      asm
            mov   row, 0
         @@NextRow:
            mov   ebx, row
            mov   eax, srcheight
            cmp   ebx, eax
            jae   @@DrawFogFin

            mov   esi, psource      //sptr
            mov   eax, lpitch
            mov   ebx, row
            imul  eax, ebx
            add   esi, eax

            mov   eax, srclen
            mov   scount, eax
         @@FogNext:
            mov   edx, pSrc     //pSrc = array[0..7]
            mov   ebx, scount
            cmp   ebx, 0
            jbe   @@Finish
            cmp   ebx, 8
            jb    @@FogSmall

            db $0F,$6F,$06           /// movq  mm0, [esi]       //8官捞飘 佬澜 sptr
            db $0F,$7F,$02           /// movq  [edx], mm0
            mov   count, 8

          @@LevelChange:
            mov   eax, darklevel
            imul  eax, 256
            movzx ebx, [edx].byte   //8官捞飘 弓澜栏肺 佬篮 单捞磐
            add   eax, ebx
            mov   ebx, pColorLevel
            mov   al, [ebx+eax].byte
            mov   [edx].byte, al

         @@Skip1:
            dec   count
            inc   edx
            inc   edi
            cmp   count, 0
            ja    @@LevelChange
            sub   edx, 8

            db $0F,$6F,$02           /// movq  mm0, [edx]
            db $0F,$7F,$06           /// movq  [esi], mm0
         @@Skip_8Byte:
            sub   scount, 8
            add   esi, 8
            jmp   @@FogNext

         @@FogSmall:
            mov   eax, darklevel
            imul  eax, 256
            movzx ebx, [edx].byte
            add   eax, ebx
            mov   ebx, pColorLevel
            mov   al, [ebx+eax].byte
            mov   [esi].byte, al

         @@Skip2:
            inc   edi
            inc   esi
            dec   scount
            jmp   @@FogNext

         @@Finish:
            inc   row
            jmp   @@NextRow

         @@DrawFogFin:
            db $0F,$77               /// emms
      end;
   finally
      ssuf.UnLock();
   end;
end;

//ssurface + dsurface => dsurface
procedure DrawBlend (dsuf: TDirectDrawSurface; x, y: integer; ssuf: TDirectDrawSurface; blendmode: integer);
begin
   DrawBlendEx (dsuf, x, y, ssuf, 0, 0, ssuf.Width, ssuf.Height, blendmode);
end;

//procedure DrawBlendEx(DstSurf: TDirectDrawSurface; DstX, DstY: Integer; SrcSurf: TDirectDrawSurface; BlendMode: Integer);
procedure DrawBlendEx(DstSurf: TDirectDrawSurface; DstX, DstY: Integer; SrcSurf: TDirectDrawSurface; SrcSurfLeft, SrcSurfTop, SrcSurfWidth, SrcSurfHeight, BlendMode: Integer);
var
  SrcDDSD, DstDDSD: TDDSurfaceDesc;
  SrcBits, DstBits, SrcP, DstP: PByte;
  X, Y: Integer;      // X/Y 方向的计数器
  SrcRect: TRect;     // 源表面需要绘制的区域
  srcwidth, srctop, srcbottom, srcleft: Integer;
begin
  if (DstSurf.Canvas = nil) or (SrcSurf.Canvas = nil) then Exit;

   //绘制点超过目标区域则退出
  if DstX >= DstSurf.Width then Exit;
  if DstY >= DstSurf.Height then Exit;

   if DstX < 0 then begin
      srcleft := -DstX;
      srcwidth := SrcSurfWidth + DstX;
      DstX := 0;
   end else begin
      srcleft := SrcSurfLeft;
      srcwidth := SrcSurfWidth;
   end;
   if DstY < 0 then begin
      srctop := -DstY;
      srcbottom := SrcSurfHeight;
      DstY := 0;
   end else begin
      srctop := SrcSurfTop;
      srcbottom := srctop + SrcSurfHeight;
   end;
   if srcleft + srcwidth > SrcSurf.Width then srcwidth := SrcSurf.Width-srcleft;
   if srcbottom > SrcSurf.Height then
      srcbottom := SrcSurf.Height;//-srcheight;
   if DstX + srcwidth > DstSurf.Width then srcwidth := (DstSurf.Width-DstX) div 4 * 4;
   if DstY + srcbottom - srctop > DstSurf.Height then
      srcbottom := DstSurf.Height-DstY+srctop;
   if (DstX+srcwidth) * (DstY+srcbottom-srctop) > DstSurf.Width * DstSurf.Height then //烙矫..
      srcbottom := srctop + (srcbottom-srctop) div 2;
   if (srcwidth <= 0) or (srcbottom <= 0) or (srcleft >= SrcSurf.Width) or (srctop >= SrcSurf.Height) then exit;
   if srcWidth > SCREENWIDTH + 100 then exit;

   if SrcSurfWidth = 120 then begin

   end;
  try
    SrcDDSD.dwSize := SizeOf(SrcDDSD);
    DstDDSD.dwSize := SizeOf(DstDDSD);
    DstSurf.Lock(TRect(nil^), DstDDSD);
    SrcSurf.Lock(TRect(nil^), SrcDDSD);

    SrcBits := SrcDDSD.lpSurface;
    DstBits := DstDDSD.lpSurface;
    //if BlendMode = 0 then begin
      for Y :=  srctop to srcbottom - 1 do begin
        DstP := PByte(Integer(DstBits) + (Y + DstY- srctop) * DstDDSD.lPitch + DstX);
        SrcP := PByte(Integer(SrcBits) + SrcDDSD.lPitch * Y + srcleft);
        for X := {srcleft}0 to srcwidth - 1 do begin
          if Srcp^>0 then
          if BlendMode = 0 then
          DstP^ := Color256Mix[DstP^][SrcP^]
          else
          DstP^ := Color256Anti[DstP^][SrcP^];
          Inc(DstP);
          Inc(SrcP);
        end;
      end;
  finally
    SrcSurf.UnLock();
    DstSurf.UnLock();
  end;
end;


//ssurface + dsurface => dsurface
{procedure DrawBlendEx (dsuf: TDirectDrawSurface; x, y: integer; ssuf: TDirectDrawSurface; ssufleft, ssuftop, ssufwidth, ssufheight, blendmode: integer);
var
   i, srcleft, srctop, srcwidth, srcbottom, sidx: integer;
   sddsd, dddsd: TDDSurfaceDesc;
   sptr, dptr, pmix: PByte;
   source, dest: array[0..910] of byte;
   scount, dcount, srclen, destlen, wcount, awidth, bwidth: integer;
begin
   if (dsuf.canvas = nil) or (ssuf.canvas = nil) then Exit;
   if x >= dsuf.Width then exit;
   if y >= dsuf.Height then exit;
   if x < 0 then begin
      srcleft := -x;
      srcwidth := ssufwidth + x;
      x := 0;
   end else begin
      srcleft := ssufleft;
      srcwidth := ssufwidth;
   end;
   if y < 0 then begin
      srctop := -y;
      srcbottom := ssufheight;
      y := 0;
   end else begin
      srctop := ssuftop;
      srcbottom := srctop + ssufheight;
   end;
   if srcleft + srcwidth > ssuf.Width then srcwidth := ssuf.Width-srcleft;
   if srcbottom > ssuf.Height then
      srcbottom := ssuf.Height;//-srcheight;
   if x + srcwidth > dsuf.Width then srcwidth := (dsuf.Width-x) div 4 * 4;
   if y + srcbottom - srctop > dsuf.Height then
      srcbottom := dsuf.Height-y+srctop;
   if (x+srcwidth) * (y+srcbottom-srctop) > dsuf.Width * dsuf.Height then //烙矫..
      srcbottom := srctop + (srcbottom-srctop) div 2;

   if (srcwidth <= 0) or (srcbottom <= 0) or (srcleft >= ssuf.Width) or (srctop >= ssuf.Height) then exit;
//   if srcWidth > 900 then exit;
   if srcWidth > SCREENWIDTH + 100 then exit;
    if ssuf.Height > 350 then begin
       //TfrmMain.DScreen.AddChatBoardString('test; ' + InttoStr(srcwidth) + ' ' + InttoStr(srcbottom) + ' ' + InttoStr(srctop),clWhite, clBlack);
       end;
   try
      sddsd.dwSize := SizeOf(sddsd);
      dddsd.dwSize := SizeOf(dddsd);
      ssuf.Lock (TRect(nil^), sddsd);
      dsuf.Lock (TRect(nil^), dddsd);
      awidth := srcwidth div 4; //ssuf.Width div 4;
      bwidth := srcwidth; //ssuf.Width;
      srclen := srcwidth; //ssuf.Width;
      destlen := srcwidth; //ssuf.Width;
      case blendmode of
         0: pmix := @Color256Mix[0,0];
         else pmix := @Color256Anti[0,0];
      end;
      for i:=srctop to srcbottom-1 do begin
         sptr := PBYTE(integer(sddsd.lpSurface) + sddsd.lPitch * i + srcleft);
         dptr := PBYTE(integer(dddsd.lpSurface) + (y+i-srctop) * dddsd.lPitch + x);
         asm
               mov   scount, 0
               mov   esi, sptr
               lea   edi, source
               mov   ebx, scount        //ebx = scount
            @@CopySource:
               cmp   ebx, srclen
               jae    @@EndSourceCopy
               db $0F,$6F,$04,$1E       /// movq  mm0, [esi+ebx]
               db $0F,$7F,$04,$1F       /// movq  [edi+ebx], mm0
               add   ebx, 8
               jmp   @@CopySource
            @@EndSourceCopy:

               mov   dcount, 0
               mov   esi, dptr
               lea   edi, dest
               mov   ebx, dcount
            @@CopyDest:
               cmp   ebx, destlen
               jae    @@EndDestCopy
               db $0F,$6F,$04,$1E       /// movq  mm0, [esi+ebx]
               db $0F,$7F,$04,$1F       /// movq  [edi+ebx], mm0
               add   ebx, 8
               jmp   @@CopyDest
            @@EndDestCopy:

               lea   esi, source
               lea   edi, dest
               mov   wcount, 0

            @@BlendNext:
               mov   ebx, wcount
               cmp   [esi+ebx].byte, 0     //if _src[bitindex] > 0
               jz    @@EndBlend

               movzx eax, [esi+ebx].byte     //sidx := _src[bitindex]
               shl   eax, 8                  //sidx * 256
               mov   sidx, eax

               movzx eax, [edi+ebx].byte     //didx := _dest[bitindex]
               add   sidx, eax

               mov   edx, pmix
               mov   ecx, sidx
               movzx eax, [edx+ecx].byte     //
               mov   [edi+ebx], al

            @@EndBlend:
               inc   wcount
               mov   eax, bwidth
               cmp   wcount, eax
               jb    @@BlendNext

               lea   esi, dest               //Move (_src, dptr^, 4)
               mov   edi, dptr
               mov   ecx, awidth
               cld
               rep movsd

         end;
      end;
      asm
         db $0F,$77               /// emms
      end;

   finally
      ssuf.UnLock();
      dsuf.UnLock();
   end;
end; }
//解决火龙教主引起程序崩溃问题  20080608
procedure DrawEx (dsuf: TDirectDrawSurface; x, y: integer; ssuf: TDirectDrawSurface; ssufleft, ssuftop, ssufwidth, ssufheight, blendmode: integer);
var
   i, srcleft, srctop, srcwidth, srcbottom, sidx: integer;
   sddsd, dddsd: TDDSurfaceDesc;
   sptr, dptr, pmix: PByte;
   source, dest: array[0..910] of byte;
   scount, dcount, srclen, destlen, wcount, awidth, bwidth: integer;
begin
   if (dsuf.canvas = nil) or (ssuf.canvas = nil) then exit;
   if x >= dsuf.Width then exit;
   if y >= dsuf.Height then exit;
   if x < 0 then begin
      srcleft := -x;
      srcwidth := ssufwidth + x;
      x := 0;
   end else begin
      srcleft := ssufleft;
      srcwidth := ssufwidth;
   end;
   if y < 0 then begin
      srctop := -y;
      srcbottom := ssufheight;
      y := 0;
   end else begin
      srctop := ssuftop;
      srcbottom := srctop + ssufheight;
   end;
   if srcleft + srcwidth > ssuf.Width then srcwidth := ssuf.Width-srcleft;
   if srcbottom > ssuf.Height then
      srcbottom := ssuf.Height;
   if x + srcwidth > dsuf.Width then srcwidth := (dsuf.Width-x) div 4 * 4;
   if y + srcbottom - srctop > dsuf.Height then
      srcbottom := dsuf.Height-y+srctop;
   if (x+srcwidth) * (y+srcbottom-srctop) > dsuf.Width * dsuf.Height then
      srcbottom := srctop + (srcbottom-srctop) div 2;

   if (srcwidth <= 0) or (srcbottom <= 0) or (srcleft >= ssuf.Width) or (srctop >= ssuf.Height) then exit;
   if srcWidth > SCREENWIDTH + 100 then exit;
   try
      sddsd.dwSize := SizeOf(sddsd);
      dddsd.dwSize := SizeOf(dddsd);
      ssuf.Lock (TRect(nil^), sddsd);
      dsuf.Lock (TRect(nil^), dddsd);
      awidth := srcwidth div 4; //ssuf.Width div 4;
      bwidth := srcwidth; //ssuf.Width;
      srclen := srcwidth; //ssuf.Width;
      destlen := srcwidth; //ssuf.Width;
      pmix := @Color256real[0,0];
      for i:=srctop to srcbottom-1 do begin
         sptr := PBYTE(integer(sddsd.lpSurface) + sddsd.lPitch * i + srcleft);
         dptr := PBYTE(integer(dddsd.lpSurface) + (y+i-srctop) * dddsd.lPitch + x);
         asm
               mov   scount, 0
               mov   esi, sptr
               lea   edi, source
               mov   ebx, scount        //ebx = scount
            @@CopySource:
               cmp   ebx, srclen
               jae    @@EndSourceCopy
               db $0F,$6F,$04,$1E       /// movq  mm0, [esi+ebx]
               db $0F,$7F,$04,$1F       /// movq  [edi+ebx], mm0
               add   ebx, 8
               jmp   @@CopySource
            @@EndSourceCopy:

               mov   dcount, 0
               mov   esi, dptr
               lea   edi, dest
               mov   ebx, dcount
            @@CopyDest:
               cmp   ebx, destlen
               jae    @@EndDestCopy
               db $0F,$6F,$04,$1E       /// movq  mm0, [esi+ebx]
               db $0F,$7F,$04,$1F       /// movq  [edi+ebx], mm0
               add   ebx, 8
               jmp   @@CopyDest
            @@EndDestCopy:

               lea   esi, source
               lea   edi, dest
               mov   wcount, 0

            @@BlendNext:
               mov   ebx, wcount
               cmp   [esi+ebx].byte, 0     //if _src[bitindex] > 0
               jz    @@EndBlend

               movzx eax, [esi+ebx].byte     //sidx := _src[bitindex]
               shl   eax, 8                  //sidx * 256
               mov   sidx, eax

               movzx eax, [edi+ebx].byte     //didx := _dest[bitindex]
               add   sidx, eax

               mov   edx, pmix
               mov   ecx, sidx
               movzx eax, [edx+ecx].byte     //
               mov   [edi+ebx], al

            @@EndBlend:
               inc   wcount
               mov   eax, bwidth
               cmp   wcount, eax
               jb    @@BlendNext

               lea   esi, dest               //Move (_src, dptr^, 4)
               mov   edi, dptr
               mov   ecx, awidth
               cld
               rep movsd

         end;
      end;
      asm
         db $0F,$77               /// emms
      end;

   finally
      ssuf.UnLock();
      dsuf.UnLock();
   end;
end;

procedure DrawEffect (x, y, width, height: integer; ssuf: TDirectDrawSurface; eff: TColorEffect);
var
   I, scount, srclen: integer;
   sddsd: TDDSurfaceDesc;
   sptr, peff: PByte;
   source: array[0..SCREENWIDTH + 10] of byte;
begin
   if Width > SCREENWIDTH then exit;
   if eff = ceNone then exit;
   peff := nil;
   case eff of
      ceGrayScale: peff := @GrayScaleLevel;
      ceBright: peff := @BrightColorLevel;
      ceBlack: peff := @BlackColorLevel;
      ceWhite: peff := @WhiteColorLevel;
      ceRed: peff := @RedishColorLevel;
      ceGreen: peff := @GreenColorLevel;
      ceBlue:  peff := @BlueColorLevel;
      ceYellow:  peff := @YellowColorLevel;
      ceFuchsia: peff := @FuchsiaColorLevel;
   end;
   if peff = nil then begin
      //peff := nil;
      exit;
   end;
   try
      sddsd.dwSize := SizeOf(sddsd);
      ssuf.Lock (TRect(nil^), sddsd);
      srclen := width;
      if height > 0 then begin//20080629
        for i:=0 to height-1 do begin
           sptr := PBYTE(integer(sddsd.lpSurface) + (y+i) * sddsd.lPitch + x);
           asm
                 mov   scount, 0
                 mov   esi, sptr
                 lea   edi, source
              @@CopySource:
                 mov   ebx, scount        //ebx = scount
                 cmp   ebx, srclen
                 jae   @@EndSourceCopy
                 db $0F,$6F,$04,$1E       /// movq  mm0, [esi+ebx]
                 db $0F,$7F,$07           /// movq  [edi], mm0

                 mov   ebx, 0
              @@Loop8:
                 cmp   ebx, 8
                 jz    @@EndLoop8
                 movzx eax, [edi+ebx].byte
                 mov   edx, peff
                 movzx eax, [edx+eax].byte     //
                 mov   [edi+ebx], al
                 inc   ebx
                 jmp   @@Loop8
              @@EndLoop8:

                 mov   ebx, scount
                 db $0F,$6F,$07           /// movq  mm0, [edi]
                 db $0F,$7F,$04,$1E       /// movq  [esi+ebx], mm0

                 add   edi, 8
                 add   scount, 8
                 jmp   @@CopySource
              @@EndSourceCopy:
                 db $0F,$77               /// emms

           end;
        end;
      end;
   finally
      ssuf.UnLock();
   end;
end;



//解决火龙教主引起程序崩溃问题  20080608
procedure BuildRealRGB(ctable: TRGBQuads);
var
   MinDif, ColDif: Integer;
   MatchColor: Byte;
   pal0, pal1, pal2: TRGBQuad;
   I, j, n: integer;
begin
  for I:=0 to 255 do begin
     pal0 := ctable[i];
     for j:=0 to 255 do begin
        pal1 := ctable[j];
        pal1.rgbRed := pal0.rgbRed;
        pal1.rgbGreen := pal0.rgbGreen;
        pal1.rgbBlue := pal0.rgbBlue;
        MinDif := 1;
        MatchColor := 0;
        for n:=0 to 255 do begin
           pal2 := ctable[n];
           ColDif := Abs(pal2.rgbRed - pal1.rgbRed) +
                     Abs(pal2.rgbGreen - pal1.rgbGreen) +
                     Abs(pal2.rgbBlue - pal1.rgbBlue);
           if ColDif < MinDif then begin
              MinDif := ColDif;
              MatchColor := n;
           end;
        end;
        Color256real[i, j] := MatchColor;
     end;
  end;
end;
end.

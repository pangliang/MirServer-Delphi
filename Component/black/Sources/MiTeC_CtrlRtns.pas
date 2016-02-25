{*******************************************************}
{                                                       }
{             MiTeC Control Routines                    }
{           version 1.0 for Delphi 5,6                  }
{                                                       }
{       Copyright © 1997,2002 Michal Mutl               }
{                                                       }
{*******************************************************}

{$INCLUDE MITEC_DEF.INC}


unit MiTeC_CtrlRtns;

interface

uses Classes, Controls, StdCtrls, ComCtrls, Windows, Dialogs, SysUtils, Forms, Graphics, Grids;

function ComponentToString(Component: TComponent): string;

procedure SetWinControlStatus(Sender: TWinControl; Enabled: Boolean; OnColor: TColor = clWhite; OffColor: TColor = clBtnFace);

procedure ListView_SaveToFile(Sender :TListView; AFileName: string);
procedure ListView_LoadFromFile(Sender :TListView; AFileName: string);
procedure ListView_LoadStrings(SourceList :TStringList; AListItems: TListItems; ADelimiter :Char; AImageIndex :Integer); overload;
procedure ListView_LoadStrings(SourceList :TStrings; AListItems: TListItems; ADelimiter :Char; AImageIndex :Integer); overload;
function ListView_CustomSort(Item1, Item2: TListItem; AColumn: integer): Integer;
procedure ListView_DrawLine(Sender: TCustomListView; Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean; LineColor: TColor);
function ListView_GetCheckedCount(Sender: TListView): Integer;
procedure ListView_DrawCheckBox(Sender: TCustomListView; Item: TListItem; SubItem: Integer; State: TCustomDrawState; var DefaultDraw: Boolean; TrueValue: string);
procedure ListView_DrawButton(Sender: TCustomListView; Item: TListItem; SubItem: Integer; State: TCustomDrawState; var DefaultDraw: Boolean; Text: string);
procedure ListView_DrawImage(Sender: TCustomListView; Item: TListItem; SubItem: Integer; State: TCustomDrawState; var DefaultDraw: Boolean; Bitmap: TBitmap; DrawText: Boolean = False; Text: string = '');

function Form_Show(Sender: TFormClass): Boolean;
procedure Form_SetVisible(Sender :TForm);
procedure Form_SetInvisible(Sender :TForm);
procedure Form_HideCaption(Sender :TForm);
procedure Form_ShowCaption(Sender :TForm);
procedure Form_Move(Sender: TWinControl);

function Tree_FindNode(Sender: TTreeView; AText: string): TTreeNode;

procedure Stat_SetText(Sender :TStatusBar; AIndex :integer; AText :string);

procedure ExportStringGridToCSV(grid: TStringGrid; FileName: string);
procedure ImportCSVToStringGrid(grid: TStringGrid; FileName: string);



{
procedure DBGrid_DrawCheckBoxes(Canvas: TCanvas; const Rect: TRect; Field: TField; Color: TColor; Selected: Boolean; TrueValue: variant);
procedure DBGrid_DrawBitmaps(Canvas: TCanvas; const Rect: TRect; Field: TField; Color: TColor; Selected: Boolean; Bitmap: TBitmap; DrawText: boolean);
}


const
  itemdelimiter = '|';
var
  ListView_SortColumn: Integer = -1;
  ListView_SortDescending: boolean = False;


implementation

uses Messages, MiTeC_StrUtils;

var
  FullRgn, ClientRgn, CtlRgn : THandle;

function ComponentToString(Component: TComponent): string;
var
  BinStream: TMemoryStream;
  StrStream: TStringStream;
begin
  BinStream := TMemoryStream.Create;
  try
    StrStream := TStringStream.Create(Result);
    try
      BinStream.WriteComponent(Component);
      BinStream.Seek(0, soFromBeginning);
      ObjectBinaryToText(BinStream, StrStream);
      StrStream.Seek(0, soFromBeginning);
      Result := StrStream.DataString;
    finally
      StrStream.Free;
    end;
  finally
    BinStream.Free
  end;
end;


procedure SetWinControlStatus;

procedure SetColor(Sender: TWinControl; Enabled: Boolean; OnColor, OffColor: TColor);
begin
  if Sender is TEdit then begin
    if Enabled then
      TEdit(Sender).Color:=OnColor
    else
      TEdit(Sender).Color:=OffColor;
  end else
    if Sender is TListBox then begin
      if Enabled then
        TListBox(Sender).Color:=OnColor
      else
        TListBox(Sender).Color:=OffColor;
    end else
      if Sender is TMemo then begin
        if Enabled then
          TMemo(Sender).Color:=OnColor
        else
          TMemo(Sender).Color:=OffColor;
      end else
        if Sender is TStringGrid then begin
          if Enabled then
            TStringGrid(Sender).Color:=OnColor
          else
            TStringGrid(Sender).Color:=OffColor;
        end else
          if Sender is TComboBox then begin
            if Enabled then
              TComboBox(Sender).Color:=OnColor
            else
              TComboBox(Sender).Color:=OffColor;
          end;
end;

var
  i: Integer;
begin
  Sender.Enabled:=Enabled;
  SetColor(Sender,Enabled,OnColor,OffColor);
  if csAcceptsControls in Sender.ControlStyle then
    for i:=0 to Sender.ControlCount-1 do begin
      if Sender.Controls[i] is TWinControl then begin
        SetColor(TWinControl(Sender.Controls[i]),Enabled,OnColor,OffColor);
        SetWinControlStatus(TWinControl(Sender.Controls[i]),Enabled,OnColor,OffColor);
      end;
    end;
end;

procedure ListView_SaveToFile;
var  idxItem,idxSub,IdxImage : integer;
     F         : TFileStream;
     pText     : pChar;
     sText     : String;
     W,ItemCount,SubCount : word;
     MySignature : Array [0..2] of char;
begin
  with Sender do begin
     //Initialization
     ItemCount:=0;
     SubCount:=0;
     //****
     MySignature := 'LVF'; //  ListViewFile
     F := TFileStream.Create(AFileName,fmCreate or fmOpenWrite);
     F.Write(MySignature,sizeof(MySignature));

     if items.Count = 0 then
          // List is empty
          ItemCount := 0
     else
          ItemCount := Items.Count;
     F.Write( ItemCount,Sizeof( ItemCount ) );

     if Items.Count > 0 then
     begin
     for idxItem := 1 to ItemCount do
       begin
                 with items[idxItem - 1] do
                 begin
                       //Save subitems count
                       if SubItems.Count = 0 then
                          SubCount := 0
                       else
                          SubCount := Subitems.Count;
                       F.Write( SubCount,Sizeof( SubCount ) );
                       //Save ImageIndex
                       IdxImage := ImageIndex;
                       F.Write( IdxImage,Sizeof( IdxImage ) );
                       //Save Caption
                       sText := Caption;
                       w := length(sText);
                       pText := StrAlloc( Length( sText ) + 1);
                       StrPLCopy(pText,sText,Length( sText ) );
                       F.Write(w, sizeof(w));
                       F.Write(pText^,w);
                       StrDispose(pText);
                       if SubCount > 0 then
                       begin
                       for idxSub:=0 to SubItems.Count - 1 do
                           begin //Save Item's subitems
                            sText := SubItems[idxSub];
                            w := length(sText);
                            pText := StrAlloc( Length( sText ) + 1);
                            StrPLCopy(pText,sText,Length( sText ) );
                            F.Write(w, sizeof(w));
                            F.Write(pText^,w);
                            StrDispose(pText);
                            end;
                       end;
                 end;
       end;
     end;
     F.Free;
   end;
end;

procedure ListView_LoadFromFile;
var
  F: TFileStream;
  IdxItem,IdxSubItem, IdxImage: Integer;
  W,ItemCount,SubCount: Word;
  pText: pchar;
  PTemp: pChar;
  MySignature:  Array [0..2] of Char;
  sExeName,s: String;
  n: TListItem;
begin
  ItemCount:=0;
  SubCount:=0;
  sExeName := ExtractFileName(AFileName);
  if not FileExists(AFileName ) then begin
    MessageBox(application.mainform.handle,pChar(format('File "%s" does not exist!',[sExeName])),'I/O Error',MB_ICONERROR);
    Exit;
  end;
  F:=TFileStream.Create(AFileName,fmOpenRead);
  F.Read(MySignature,sizeof(MySignature));
  if MySignature <> 'LVF' then begin
    MessageBox(application.mainform.Handle,pChar(format('"%s" is not a ListView file!',[sExeName])),'I/O Error',MB_ICONERROR);
    Exit;
  end;
  F.Read(ItemCount,sizeof(ItemCount));
  For idxItem := 1 to ItemCount do begin
    F.Read( SubCount,sizeof( SubCount ) );
    F.Read( IdxImage,sizeof( IdxImage ) );
    s:=inttostr(IdxImage);
    F.Read(w,SizeOf(w));
    pText:=StrAlloc(w + 1);
    pTemp:=StrAlloc(w + 1);
    F.Read(pTemp^,W);
    StrLCopy(pText,pTemp,W);
    s:=s+itemDelimiter+StrPas(pText);
    n:=Sender.Items.Add;
    n.Caption:=StrPas(pText);
    n.ImageIndex:=IdxImage;
    StrDispose(pTemp);
    StrDispose(pText);
    if SubCount > 0 then begin
      for idxSubItem:=1 to SubCount do begin
        F.Read(w,SizeOf(w));
        pText:=StrAlloc(w + 1);
        pTemp:=StrAlloc(w + 1);
        F.Read(pTemp^,W);
        StrLCopy(pText,pTemp,W);
        s:=s+itemDelimiter+StrPas(pText);
        n.SubItems.Add(StrPas(pText));
        StrDispose(pTemp);
        StrDispose(pText);
      end;
    end;
  end;
  F.Free;
end;

procedure ListView_LoadStrings(SourceList :TStringList; AListItems: TListItems;
  ADelimiter :Char; AImageIndex :Integer); overload;
var
  i,p :integer;
  s :string;
  n :tlistitem;
begin
  with AListItems do begin
    BeginUpdate;
    Clear;
    for i:=0 to SourceList.count-1 do begin
      s:=SourceList[i];
      if copy(s,length(s),1)<>ADelimiter then
        s:=s+ADelimiter;
      n:=add;
      if AImageIndex=-1 then begin
        p:=pos(ADelimiter,s);
        n.imageindex:=StrToInt(copy(s,1,p-1));
        System.delete(s,1,p);
      end;
      p:=pos(ADelimiter,s);
      n.caption:=copy(s,1,p-1);
      System.delete(s,1,p);
      if AImageIndex>-1 then
        n.imageindex:=AImageIndex;
      p:=pos(ADelimiter,s);
      while p>0 do begin
       n.subitems.add(copy(s,1,p-1));
       System.delete(s,1,p);
       p:=pos(ADelimiter,s);
      end;
    end;
    EndUpdate;
  end;
end;

procedure ListView_LoadStrings(SourceList :TStrings; AListItems: TListItems;
  ADelimiter :Char; AImageIndex :Integer); overload;
var
  i,p :integer;
  s :string;
  n :tlistitem;
begin
  with AListItems do begin
    BeginUpdate;
    Clear;
    for i:=0 to SourceList.count-1 do begin
      s:=SourceList[i];
      if copy(s,length(s),1)<>ADelimiter then
        s:=s+ADelimiter;
      n:=add;
      if AImageIndex=-1 then begin
        p:=pos(ADelimiter,s);
        n.imageindex:=StrToInt(copy(s,1,p-1));
        System.delete(s,1,p);
      end;
      p:=pos(ADelimiter,s);
      n.caption:=copy(s,1,p-1);
      System.delete(s,1,p);
      if AImageIndex>-1 then
        n.imageindex:=AImageIndex;
      p:=pos(ADelimiter,s);
      while p>0 do begin
       n.subitems.add(copy(s,1,p-1));
       System.delete(s,1,p);
       p:=pos(ADelimiter,s);
      end;
    end;
    EndUpdate;
  end;
end;

function ListView_CustomSort;
var
  Str1, Str2: string;
  Val1, Val2: extended;
  Date1, Date2: TDateTime;
  Diff: TDateTime;
begin
  if (Item1=NIL) or (Item2=NIL) then begin
    Result := 0;
    exit;
  end;

  try
    if AColumn=0 then begin
      Str1:=Item1.Caption;
      Str2:=Item2.Caption;
    end else begin
      if AColumn<=Item1.SubItems.Count then
        Str1:=Item1.SubItems[AColumn-1]
      else
        Str1:='';
      if AColumn<=Item2.SubItems.Count then
        Str2:=Item2.SubItems[AColumn-1]
      else
        Str2:='';
    end;

    if IsValidDateTime(Str1,Date1) and IsValidDateTime(Str2,Date2) then begin
      Diff:=Date1-Date2;
      if Diff<0.0 then
        Result:=-1
      else
        if Diff>0.0 then
          Result:=1
        else
          Result:=0
    end else
      if IsValidNumber(Str1,Val1) and IsValidNumber(Str2,Val2) then begin
        if Val1<Val2 then
          Result:=-1
        else
          if Val1>Val2 then
            Result:=1
          else
            Result:=0
      end else
        Result:=AnsiCompareStr(Str1,Str2);
  except
    Result:=0;
  end;
end;

procedure ListView_DrawLine;
var
  Rect: TRect;
  p: TPoint;
  i,x: Integer;
  c: TColor;
begin
  with (Sender as TListView) do begin
    p:=Item.GetPosition;
    x:=0;
    for i:=0 to Columns.Count-1 do
      x:=x+Column[i].Width;
    Rect.Top:=p.y;
    Rect.Left:=p.x;
    Rect.Bottom:=Rect.Top+16;
    Rect.Right:=Rect.Left+x;

    c:=Canvas.Brush.Color;
    if (cdsFocused in State) then begin
      Canvas.Brush.Color:=clNavy;
      if (cdsHot in State) then
        Canvas.Brush.Color:=clBlue;
      if not Assigned(Selected) then
        Canvas.Brush.Color:=c;
    end else
      Canvas.Brush.Color:=c;
    Canvas.Pen.Color:=Canvas.Brush.Color;
    Canvas.Rectangle(Rect);
    if Canvas.Brush.Color<>c then
      Canvas.Pen.Color:=c
    else
      Canvas.Pen.Color:=LineColor;
    Canvas.MoveTo(Rect.Left,((Rect.Bottom - Rect.Top) div 2) + Rect.Top);
    Canvas.LineTo(Rect.Left+Rect.Right-5,((Rect.Bottom - Rect.Top) div 2) + Rect.Top);
    Canvas.Brush.Color:=c;
  end;
end;

function ListView_GetCheckedCount;
var
  i: integer;
begin
  Result:=0;
  with Sender, Items do
    for i:=0 to Count-1 do
      if Items[i].Checked then
        Inc(Result);
end;

procedure ListView_DrawCheckBox;
var
  Rect,MyRect: TRect;
  p: TPoint;
  i,x: Integer;
  pc,bc: TColor;
begin
  with (Sender as TListView) do begin
    p:=Item.GetPosition;
    x:=0;
    for i:=0 to SubItem-1 do
      x:=x+Column[i].Width;
    Rect.Top:=p.y;
    Rect.Left:=p.x+x;
    Rect.Bottom:=Rect.Top+16;
    Rect.Right:=Rect.Left+Column[SubItem].Width;

    bc:=Canvas.Brush.Color;
    pc:=Canvas.Pen.Color;
    if (cdsFocused in State) then begin
      Canvas.Brush.Color:=clNavy;
      if (cdsHot in State) then
        Canvas.Brush.Color:=clBlue;
      if not Assigned(Selected) then
        Canvas.Brush.Color:=bc;
    end else
      Canvas.Brush.Color:=bc;

    Canvas.Pen.Color:=Canvas.Brush.Color;

    Canvas.Rectangle(Rect);

    Canvas.Pen.Color:=Canvas.Font.Color;

    MyRect.Top := ((Rect.Bottom - Rect.Top - 11) div 2) + Rect.Top;
    MyRect.Bottom := MyRect.Top + 10;
    case Column[SubItem].Alignment of
      taLeftJustify: MyRect.Left:=Rect.Left+5;
      taCenter: MyRect.Left:=((Rect.Right-Rect.Left-11) div 2)+Rect.Left;
      taRightJustify: MyRect.Left:=Rect.Right-20;
    end;
    MyRect.Right:=MyRect.Left+10;

    Canvas.Brush.Color:=clWhite;
    Canvas.FillRect(MyRect);

    Canvas.Polyline([
      Point(MyRect.Left, MyRect.Top), Point(MyRect.Right, MyRect.Top),
      Point(MyRect.Right, MyRect.Bottom), Point(MyRect.Left, MyRect.Bottom),
      Point(MyRect.Left, MyRect.Top)]);

    if Item.SubItems[SubItem-1]=TrueValue then begin
      Canvas.MoveTo(MyRect.Left + 2, MyRect.Top + 4);
      Canvas.LineTo(MyRect.Left + 2, MyRect.Top + 7);
      Canvas.MoveTo(MyRect.Left + 3, MyRect.Top + 5);
      Canvas.LineTo(MyRect.Left + 3, MyRect.Top + 8);
      Canvas.MoveTo(MyRect.Left + 4, MyRect.Top + 6);
      Canvas.LineTo(MyRect.Left + 4, MyRect.Top + 9);
      Canvas.MoveTo(MyRect.Left + 5, MyRect.Top + 5);
      Canvas.LineTo(MyRect.Left + 5, MyRect.Top + 8);
      Canvas.MoveTo(MyRect.Left + 6, MyRect.Top + 4);
      Canvas.LineTo(MyRect.Left + 6, MyRect.Top + 7);
      Canvas.MoveTo(MyRect.Left + 7, MyRect.Top + 3);
      Canvas.LineTo(MyRect.Left + 7, MyRect.Top + 6);
      Canvas.MoveTo(MyRect.Left + 8, MyRect.Top + 2);
      Canvas.LineTo(MyRect.Left + 8, MyRect.Top + 5);
    end;
    Canvas.Brush.Color:=bc;
    Canvas.Pen.Color:=pc;
  end;
end;

procedure ListView_DrawButton;
var
  Rect,MyRect: TRect;
  p: TPoint;
  i,x,w,fs: Integer;
  bc,pc: TColor;
  fn: string;
begin
  with (Sender as TListView) do begin
    p:=Item.GetPosition;
    x:=0;
    for i:=0 to SubItem-1 do
      x:=x+Column[i].Width;
    Rect.Top:=p.y;
    Rect.Left:=p.x+x;
    Rect.Bottom:=Rect.Top+16;
    Rect.Right:=Rect.Left+Column[SubItem].Width;

    fn:=Canvas.Font.Name;
    fs:=Canvas.Font.Size;
    bc:=Canvas.Brush.Color;
    pc:=Canvas.Pen.Color;
    {if (cdsFocused in State) then begin
      Canvas.Brush.Color:=clNavy;
      if (cdsHot in State) then
        Canvas.Brush.Color:=clBlue;
      if not Assigned(Selected) then
        Canvas.Brush.Color:=bc;
      Canvas.Pen.Color:=clWhite;
    end else begin
      Canvas.Brush.Color:=bc;
      Canvas.Pen.Color:=Canvas.Font.Color;
    end;}

    Canvas.Font.Name:='Small Fonts';
    Canvas.Font.Size:=6;
    w:=Canvas.TextWidth(Text)+6;

    MyRect.Top := ((Rect.Bottom - Rect.Top -13) div 2) + Rect.Top;
    MyRect.Left := (Rect.Right - Rect.Left - w+2) + Rect.Left - 3;
    MyRect.Bottom := MyRect.Top + 11;
    MyRect.Right := MyRect.Left + w - 3;

    Canvas.Brush.Color:=clBtnFace;
    Canvas.Rectangle(MyRect);

    Canvas.Pen.Color:=clWhite;
    Canvas.Polyline([
      Point(MyRect.Left, MyRect.Bottom), Point(MyRect.Left, MyRect.Top),
      Point(MyRect.Right, MyRect.Top)]);
    Canvas.Pen.Color:=cl3DDkShadow;
    Canvas.Polyline([
      Point(MyRect.Right, MyRect.Top), Point(MyRect.Right, MyRect.Bottom),
      Point(MyRect.Left, MyRect.Bottom)]);

    InflateRect(MyRect,-1,-1);

    if w>0 then
      Canvas.TextRect(MyRect,MyRect.Left,MyRect.Top,Text);

    Canvas.Brush.Color:=bc;
    Canvas.Pen.Color:=pc;
    Canvas.Font.Size:=fs;
    Canvas.Font.Name:=fn;
  end;
end;

procedure ListView_DrawImage;
var
  Rect, MyRect: TRect;
  p: TPoint;
  i,x: Integer;
  c: TColor;
begin
  with (Sender as TListView) do begin
    p:=Item.GetPosition;
    x:=0;
    for i:=0 to SubItem-1 do
      x:=x+Column[i].Width;
    Rect.Top:=p.y;
    Rect.Left:=p.x+x;
    Rect.Bottom:=Rect.Top+16;
    Rect.Right:=Rect.Left+Column[SubItem].Width;

    c:=Canvas.Brush.Color;
    if (cdsFocused in State) then begin
      Canvas.Brush.Color:=clNavy;
      if (cdsHot in State) then
        Canvas.Brush.Color:=clBlue;
      if not Assigned(Selected) then
        Canvas.Brush.Color:=clWhite;
      Canvas.Pen.Color:=Canvas.Brush.Color;
    end else begin
      Canvas.Brush.Color:=clWhite;
      Canvas.Pen.Color:=Canvas.Brush.Color;
    end;
    Canvas.Rectangle(Rect);

    MyRect.Top := {((Rect.Bottom - Rect.Top - 16) div 2) + }Rect.Top+1;
    MyRect.Left := {((Rect.Right - Rect.Left - 11) div 2) +} Rect.Left+1;
    MyRect.Bottom := MyRect.Top + 15;
    MyRect.Right := MyRect.Left + 15;

    if Canvas.Brush.Color<>clWhite then
      Canvas.Pen.Color:=clWhite
    else
      Canvas.Pen.Color:=clBlack;

    if Item.Selected then
      Canvas.CopyMode:=cmSrcCopy
    else
      Canvas.CopyMode:=cmSrcCopy;
    Canvas.StretchDraw(MyRect,Bitmap);
    if DrawText then
      Canvas.TextOut(MyRect.Left+20,Rect.Top+2,Text);

    Canvas.Brush.Color:=c;
  end;
end;

function Form_Show;
var
  i: integer;
begin
  Result:=False;
  for i:=0 to Screen.FormCount-1 do
    if Screen.Forms[i].ClassType=Sender then begin
      Result:=True;
      Screen.Forms[i].Show;
      Break;
    end;
  {p:=AllocMem(Length(Sender.ClassName)+1);
  StrPCopy(p,Sender.ClassName);
  wh:=FindWindow(p,nil);
  if wh=0 then begin
    Result:=False;
  end else begin
    ShowWindow(wh,SW_RESTORE);
    SetForegroundWindow(wh);
    Result:=True;
  end;
  FreeMem(p);}
end;

procedure Form_SetInvisible;
var
  acontrol :tcontrol;
  i,margin,x,y,ctlx,ctly :integer;
begin
  with Sender do begin
    margin:=(width-clientwidth ) div 2;
    fullrgn:=createrectrgn(0,0,width,height);
    x:=margin;
    y:=height-clientheight-margin;
    clientrgn:=createrectrgn(x,y,x+clientwidth,y+clientheight);
    combinergn(fullrgn,fullrgn,clientrgn,RGN_DIFF);
    for i:=0 to controlcount-1 do begin
      acontrol:=controls[i];
      if (acontrol is twincontrol) or (acontrol is tgraphiccontrol) then
        with acontrol do begin
          if visible then begin
            ctlx:=x+left;
            ctly:=y+top;
            ctlrgn:=createrectrgn(ctlx,ctly,ctlx+width,ctly+height);
            combinergn(fullrgn,fullrgn,ctlrgn,RGN_OR);
        end;
      end;
    end;
    setwindowrgn(handle,fullrgn,true);
  end;
  //DeleteObject(FullRgn);
end;

procedure Form_SetVisible;
begin
  with Sender do begin
    fullrgn:=createrectrgn(0,0,width,height);
    combinergn(fullrgn,fullrgn,fullrgn,RGN_COPY);
    setwindowrgn(handle,fullrgn,true);
    //DeleteObject(FullRgn);
  end;
end;

procedure Form_HideCaption;
var
  FDiff: integer;
begin
  FDiff:=GetSystemMetrics(SM_CYCAPTION);
  SetWindowLong(Sender.Handle,GWL_STYLE,GetWindowLong(Sender.Handle,GWL_Style) and not WS_Caption);
  Sender.Height:=Sender.Height-FDiff;
end;

procedure Form_ShowCaption;
var
  FDiff: integer;
begin
  FDiff:=GetSystemMetrics(SM_CYCAPTION);
  SetWindowLong(Sender.Handle,GWL_STYLE,GetWindowLong(Sender.Handle,GWL_Style)+WS_Caption);
  Sender.Height:=Sender.Height+FDiff;
end;

procedure Form_Move;
begin
  ReleaseCapture;
  Sender.Perform(WM_SYSCOMMAND,$f012,0);
end;


function Tree_FindNode;
var
  i: integer;
begin
  Result:=nil;
  AText:=UpperCase(Atext);
  for i:=0 to Sender.Items.Count-1 do
    if UpperCase(Sender.Items[i].Text)=AText then begin
      Result:=Sender.Items[i];
      Break;
    end;
end;

procedure Stat_SetText;
begin
  Sender.panels[aindex].text:=atext;
  Sender.panels[aindex].width:=Sender.canvas.textwidth(atext)+10;
  Sender.Update;
end;

{
procedure DBGrid_DrawBitmaps;
var
  MyRect: TRect;
  c: TColor;
begin
  c:=Canvas.Pen.Color;
  Canvas.Pen.Color:=Color;
  Canvas.Rectangle(Rect);
  Canvas.Pen.Color:=c;
  MyRect.Top := ((Rect.Bottom - Rect.Top - 17) div 2) + Rect.Top;
  MyRect.Left := Rect.Left;
  MyRect.Bottom := MyRect.Top + 16;
  MyRect.Right := MyRect.Left + 16;
  if Selected then
    Canvas.CopyMode:=cmSrcCopy
  else
    Canvas.CopyMode:=cmSrcCopy;
  Canvas.StretchDraw(MyRect,Bitmap);
  if DrawText then
    Canvas.TextOut(MyRect.Left+20,Rect.Top+2,Field.AsString);
end;

procedure DBGrid_DrawCheckBoxes;
var
  MyRect: TRect;
  c: TColor;
begin
  c:=Canvas.Pen.Color;
  Canvas.Pen.Color:=Color;
  Canvas.Rectangle(Rect);
  Canvas.Pen.Color:=c;
  MyRect.Top := ((Rect.Bottom - Rect.Top - 11) div 2) + Rect.Top;
  MyRect.Left := ((Rect.Right - Rect.Left - 11) div 2) + Rect.Left;
  MyRect.Bottom := MyRect.Top + 10;
  MyRect.Right := MyRect.Left + 10;
  if Selected then
    Canvas.Pen.Color := clYellow
  else
    Canvas.Pen.Color := clBlack;
  Canvas.Polyline([
    Point(MyRect.Left, MyRect.Top), Point(MyRect.Right, MyRect.Top),
    Point(MyRect.Right, MyRect.Bottom), Point(MyRect.Left, MyRect.Bottom),
    Point(MyRect.Left, MyRect.Top)]);
  if fIELD.Value=TrueValue then begin
    Canvas.MoveTo(MyRect.Left + 2, MyRect.Top + 4);
    Canvas.LineTo(MyRect.Left + 2, MyRect.Top + 7);
    Canvas.MoveTo(MyRect.Left + 3, MyRect.Top + 5);
    Canvas.LineTo(MyRect.Left + 3, MyRect.Top + 8);
    Canvas.MoveTo(MyRect.Left + 4, MyRect.Top + 6);
    Canvas.LineTo(MyRect.Left + 4, MyRect.Top + 9);
    Canvas.MoveTo(MyRect.Left + 5, MyRect.Top + 5);
    Canvas.LineTo(MyRect.Left + 5, MyRect.Top + 8);
    Canvas.MoveTo(MyRect.Left + 6, MyRect.Top + 4);
    Canvas.LineTo(MyRect.Left + 6, MyRect.Top + 7);
    Canvas.MoveTo(MyRect.Left + 7, MyRect.Top + 3);
    Canvas.LineTo(MyRect.Left + 7, MyRect.Top + 6);
    Canvas.MoveTo(MyRect.Left + 8, MyRect.Top + 2);
    Canvas.LineTo(MyRect.Left + 8, MyRect.Top + 5);
  end;
end;
}

procedure ExportStringGridToCSV(grid: TStringGrid; FileName: string);
var
  sl: TStringList;
  i,j: Integer;
  s: string;
const
  Delimiter = ';';
begin
  sl:=TStringList.Create;
  try
    s:='';
    for i:=0 to grid.RowCount-1 do begin
      s:='';
      for j:=0 to grid.ColCount-1 do
        s:=s+grid.Cells[j,i]+Delimiter;
      sl.Add(s);
    end;
    sl.SaveToFile(FileName);
  finally
    sl.Free;
  end;
end;

procedure ImportCSVToStringGrid(grid: TStringGrid; FileName: string);
var
  sl: TStringList;
  i,j,n: Integer;
  s: string;
const
  Delimiter = ';';
begin
  sl:=TStringList.Create;
  try
    sl.LoadFromFile(FileName);
    if sl.Count>0  then begin
      s:='';
      n:=GetTokenCount(sl[0],Delimiter);
      for i:=0 to sl.Count-1 do
        for j:=0 to n-1 do
          grid.Cells[j,i]:=GetToken(sl[i],Delimiter,j+1);
    end;
  finally
    sl.Free;
  end;
end;

end.

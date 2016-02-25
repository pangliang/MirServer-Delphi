unit DrawScrn;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DXDraws, DXClass, DirectX, IntroScn, Actor, cliUtil, ClFunc,
  HUtil32, MShare;


const
  MAXSYSLINE = 8;

  BOTTOMBOARD = 1;
  VIEWCHATLINE = 9;
  AREASTATEICONBASE = 150;
  HEALTHBAR_BLACK = 0;
  HEALTHBAR_RED = 1;


type
  TDrawScreen = class
  private
    m_dwFrameTime: LongWord;
    m_dwFrameCount: LongWord;
    m_dwDrawFrameCount: LongWord;
    m_SysMsgList: TList;
  public
    CurrentScene: TScene;
    ChatStrs: TStringList;
    ChatBks: TList;
    ChatBoardTop: Integer;

    HintList: TStringList;
    HintX, HintY, HintWidth, HintHeight: Integer;
    HintUp: Boolean;
    HintColor: TColor;
    SysMsgCount: array[0..10 - 1] of Integer;
    SysMsgPosition: array[0..10 - 1] of Integer;
    constructor Create;
    destructor Destroy; override;
    procedure KeyPress(var Key: Char);
    procedure KeyDown(var Key: Word; Shift: TShiftState);
    procedure MouseMove(Shift: TShiftState; X, Y: Integer);
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure Initialize;
    procedure Finalize;
    procedure ChangeScene(scenetype: TSceneType);
    procedure DrawScreen(MSurface: TDirectDrawSurface);
    procedure DrawScreenTop(MSurface: TDirectDrawSurface);
    procedure AddSysMsg(Msg: string; nType, nX, nY: Integer; Color: TColor);
    procedure DeleteSysMsg(nType: Integer);
    function GetLaseSysMsg(nType, nX, nY: Integer): pTSysMsg;

    procedure AddChatBoardString(str: string; fcolor, bcolor: Integer);
    procedure ClearChatBoard;

    procedure ShowHint(X, Y: Integer; str: string; Color: TColor; drawup: Boolean);
    procedure ClearHint;
    procedure DrawHint(MSurface: TDirectDrawSurface);
  end;


implementation

uses
  ClMain, Share;


constructor TDrawScreen.Create;
var
  i: Integer;
begin
  CurrentScene := nil;
  m_dwFrameTime := GetTickCount;
  m_dwFrameCount := 0;
  m_SysMsgList := TList.Create;
  ChatStrs := TStringList.Create;
  ChatBks := TList.Create;
  ChatBoardTop := 0;

  HintList := TStringList.Create;
  FillChar(SysMsgCount, SizeOf(SysMsgCount), #0);
  FillChar(SysMsgPosition, SizeOf(SysMsgPosition), #0);
end;

destructor TDrawScreen.Destroy;
var
  i: Integer;
begin
  for i := 0 to m_SysMsgList.Count - 1 do DisPose(m_SysMsgList.Items[i]);
  m_SysMsgList.Free;
  ChatStrs.Free;
  ChatBks.Free;
  HintList.Free;
  inherited Destroy;
end;

procedure TDrawScreen.Initialize;
begin
end;

procedure TDrawScreen.Finalize;
begin
end;

procedure TDrawScreen.KeyPress(var Key: Char);
begin
  if CurrentScene <> nil then
    CurrentScene.KeyPress(Key);
end;

procedure TDrawScreen.KeyDown(var Key: Word; Shift: TShiftState);
begin
  if CurrentScene <> nil then
    CurrentScene.KeyDown(Key, Shift);
end;

procedure TDrawScreen.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  if CurrentScene <> nil then
    CurrentScene.MouseMove(Shift, X, Y);
end;

procedure TDrawScreen.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if CurrentScene <> nil then
    CurrentScene.MouseDown(Button, Shift, X, Y);
end;

procedure TDrawScreen.ChangeScene(scenetype: TSceneType);
begin
  if CurrentScene <> nil then
    CurrentScene.CloseScene;
  case scenetype of
    stIntro: CurrentScene := IntroScene;
    stLogin: CurrentScene := LoginScene;
    stSelectCountry: ;
    stSelectChr: CurrentScene := SelectChrScene;
    stNewChr: ;
    stLoading: ;
    stLoginNotice: CurrentScene := LoginNoticeScene;
    stPlayGame: CurrentScene := PlayScene;
  end;
  if CurrentScene <> nil then
    CurrentScene.OpenScene;
end;

function TDrawScreen.GetLaseSysMsg(nType, nX, nY: Integer): pTSysMsg;
var
  i: Integer;
  SysMsg: pTSysMsg;
  sY: Integer;
begin
  Result := nil;
  sY := 0;
  SysMsgCount[nType] := 0;
  for i := 0 to m_SysMsgList.Count - 1 do begin
    SysMsg := pTSysMsg(m_SysMsgList.Items[i]);
    if SysMsg.nMsgType = nType then begin
      Inc(SysMsgCount[nType]);
      if SysMsg.nY > sY then begin
        sY := SysMsg.nY;
        Result := SysMsg;
      end;
    end;
  end;
end;

procedure TDrawScreen.DeleteSysMsg(nType: Integer);
var
  i: Integer;
  SysMsg: pTSysMsg;
  boDelete: Boolean;
  nIndex: Integer;
  dwTick: LongWord;
begin
  boDelete := False;
  dwTick := GetTickCount;
  nIndex := -1;
  for i := m_SysMsgList.Count - 1 downto 0 do begin
    SysMsg := pTSysMsg(m_SysMsgList.Items[i]);
    if SysMsg.nMsgType = nType then begin
      if SysMsg.dwSpellTime < dwTick then begin
        dwTick := SysMsg.dwSpellTime;
        if GetTickCount - SysMsg.dwSpellTime > 3000 then begin
          m_SysMsgList.Delete(i);
          DisPose(SysMsg);
          boDelete := True;
          break;
        end;
      end;
      nIndex := i;
    end;
  end;
  if (not boDelete) and (nIndex >= 0) then begin
    if SysMsgCount[nType] >= 10 then begin
      DisPose(m_SysMsgList.Items[nIndex]);
      m_SysMsgList.Delete(nIndex);
    end;
  end;
end;

procedure TDrawScreen.AddSysMsg(Msg: string; nType, nX, nY: Integer; Color: TColor);
var
  SysMsg: pTSysMsg;
  sY: Integer;
begin
  SysMsg := GetLaseSysMsg(nType, nX, nY);
  if SysMsg <> nil then begin
    if SysMsgCount[nType] >= 10 then begin
      DeleteSysMsg(nType);
    end;
  end;
  New(SysMsg);
  SysMsg.nMsgType := nType;
  SysMsg.sSysMsg := Msg;
  SysMsg.Color := Color;
  SysMsg.nX := nX;
  SysMsg.nY := nY;
  SysMsg.dwSpellTime := GetTickCount;
  m_SysMsgList.Add(SysMsg);
end;

procedure TDrawScreen.AddChatBoardString(str: string; fcolor, bcolor: Integer);
var
  i, len, aline: Integer;
  dline, temp: string;
const
  BOXWIDTH = (SCREENWIDTH div 2 - 214) * 2 {374}; //41 聊天框文字宽度
begin
  len := Length(str);
  temp := '';
  i := 1;
  while True do begin
    if i > len then break;
    if byte(str[i]) >= 128 then begin
      temp := temp + str[i];
      Inc(i);
      if i <= len then temp := temp + str[i]
      else break;
    end else
      temp := temp + str[i];

    aline := frmMain.Canvas.TextWidth(temp);
    if aline > BOXWIDTH then begin
      ChatStrs.AddObject(temp, TObject(fcolor));
      ChatBks.Add(Pointer(bcolor));
      str := Copy(str, i + 1, len - i);
      temp := '';
      break;
    end;
    Inc(i);
  end;
  if temp <> '' then begin
    ChatStrs.AddObject(temp, TObject(fcolor));
    ChatBks.Add(Pointer(bcolor));
    str := '';
  end;
  if ChatStrs.Count > 200 then begin
    ChatStrs.Delete(0);
    ChatBks.Delete(0);
    if ChatStrs.Count - ChatBoardTop < VIEWCHATLINE then Dec(ChatBoardTop);
  end else if (ChatStrs.Count - ChatBoardTop) > VIEWCHATLINE then begin
    Inc(ChatBoardTop);
  end;
  if str <> '' then
    AddChatBoardString(' ' + str, fcolor, bcolor);
end;

procedure TDrawScreen.ShowHint(X, Y: Integer; str: string; Color: TColor; drawup: Boolean);
var
  data: string;
  w, h: Integer;
begin
  ClearHint;
  HintX := X;
  HintY := Y;
  HintWidth := 0;
  HintHeight := 0;
  HintUp := drawup;
  HintColor := Color;
  while True do begin
    if str = '' then break;
    str := GetValidStr3(str, data, ['\']);
    w := frmMain.Canvas.TextWidth(data) + 4 {咯归} * 2;
    if w > HintWidth then HintWidth := w;
    if data <> '' then
      HintList.Add(data)
  end;
  HintHeight := (frmMain.Canvas.TextHeight('A') + 1) * HintList.Count + 3 {咯归} * 2;
  if HintUp then
    HintY := HintY - HintHeight;
end;

procedure TDrawScreen.ClearHint;
begin
  HintList.Clear;
end;

procedure TDrawScreen.ClearChatBoard;
var
  i: Integer;
begin
  for i := 0 to m_SysMsgList.Count - 1 do DisPose(m_SysMsgList.Items[i]);
  m_SysMsgList.Clear;
  FillChar(SysMsgCount, SizeOf(SysMsgCount), #0);
  ChatStrs.Clear;
  ChatBks.Clear;
  ChatBoardTop := 0;
end;

procedure TDrawScreen.DrawScreen(MSurface: TDirectDrawSurface);
  procedure NameTextOut(Surface: TDirectDrawSurface; X, Y, fcolor, bcolor: Integer; namestr: string);
  var
    i, row: Integer;
    nstr: string;
  begin
    row := 0;
    for i := 0 to 10 do begin
      if namestr = '' then break;
      namestr := GetValidStr3(namestr, nstr, ['\']);
      BoldTextOut(Surface,
        X - Surface.Canvas.TextWidth(nstr) div 2,
        Y + row * 12,
        fcolor, bcolor, nstr);
      Inc(row);
    end;
  end;
var
  i, k, line, sx, sY, fcolor, bcolor: Integer;
  Actor: TActor;
  str, uname: string;
  dsurface: TDirectDrawSurface;
  d: TDirectDrawSurface;
  rc: TRect;
  infoMsg: string;
   DropItem: PTDropItem;
   ShowItem: pTShowItem;
   mx,my:integer;
    nx,ny: Integer;
begin
  MSurface.Fill(0);
  if CurrentScene <> nil then
    CurrentScene.PlayScene(MSurface);

  if GetTickCount - m_dwFrameTime > 1000 then begin
    m_dwFrameTime := GetTickCount;
    m_dwDrawFrameCount := m_dwFrameCount;
    m_dwFrameCount := 0;
  end;
  Inc(m_dwFrameCount);

  if g_MySelf = nil then Exit;

  if CurrentScene = PlayScene then begin
    with MSurface do begin
      //赣府困俊 眉仿 钎矫 秦具 窍绰 巴甸
      with PlayScene do begin


       //显示物品
            if g_boShowAllItem then begin
             if g_DropedItemList.Count > 0 then begin
             //  {$if Version = 1}
               SetBkMode (Canvas.Handle, TRANSPARENT);
              // {$IFEND}
               for k:=0 to g_DropedItemList.Count-1 do begin
                 DropItem := PTDropItem (g_DropedItemList[k]);
                 if DropItem <> nil then begin
                   if g_boFilterAutoItemShow then begin
                     ShowItem:=GetShowItem(DropItem.Name);//盛大挂查找过滤物品
                     if ((ShowItem <> nil) and (not ShowItem.boShowName)) then  Continue;
                   end;
                   ScreenXYfromMCXY(DropItem.X, DropItem.Y, mx, my);
                   if (abs(g_MySelf.m_nCurrX - DropItem.X) >= 9) or (abs(g_MySelf.m_nCurrY - DropItem.Y) >= 7) then Continue;
                   BoldTextOut(MSurface,
                                 mx - 16,
                                 my - 20,
                                 clSkyBlue,
                                 clBlack,
                                 DropItem.Name);
                 end;
               end;
              // {$if Version = 1}
               Canvas.Release;
             //  {$IFEND}
             end;
            end;




        for k := 0 to m_ActorList.Count - 1 do begin
          Actor := m_ActorList[k];
          //显示人物血量(数字显示)
          if (Actor.m_Abil.MaxHP > 1) and not Actor.m_boDeath then begin
            SetBkMode(Canvas.Handle, TRANSPARENT);
            infoMsg := IntToStr(Actor.m_Abil.HP) + '/' + IntToStr(Actor.m_Abil.MaxHP);
            BoldTextOut(MSurface, Actor.m_nSayX - 15, Actor.m_nSayY - 20, clWhite, clBlack, infoMsg);
            Canvas.Release;
          end;
          Actor.m_boOpenHealth := True; //显示血条
          if (Actor.m_boOpenHealth or Actor.m_noInstanceOpenHealth) and not Actor.m_boDeath then begin
            //画人物的“血”（头上的一个横杠）
            if Actor.m_noInstanceOpenHealth then
              if GetTickCount - Actor.m_dwOpenHealthStart > Actor.m_dwOpenHealthTime then
                Actor.m_noInstanceOpenHealth := False;
            d := g_WMain3Images.Images[HEALTHBAR_BLACK];
            if d <> nil then
              MSurface.Draw(Actor.m_nSayX - d.Width div 2, Actor.m_nSayY - 10, d.ClientRect, d, True);
            d := g_WMain3Images.Images[HEALTHBAR_RED];
            if d <> nil then begin
              rc := d.ClientRect;
              if Actor.m_Abil.MaxHP > 0 then
                rc.Right := Round((rc.Right - rc.Left) / Actor.m_Abil.MaxHP * Actor.m_Abil.HP);
              MSurface.Draw(Actor.m_nSayX - d.Width div 2, Actor.m_nSayY - 10, rc, d, True);
            end;
          end;
        end;
      end;

      //付快胶肺 措绊 乐绰 某腐磐 捞抚 唱坷扁
      SetBkMode(Canvas.Handle, TRANSPARENT);
      if (g_FocusCret <> nil) and PlayScene.IsValidActor(g_FocusCret) then begin
        //if FocusCret.Grouped then uname := char(7) + FocusCret.UserName
        //else
        uname := g_FocusCret.m_sDescUserName + '\' + g_FocusCret.m_sUserName;
        NameTextOut(MSurface,
          g_FocusCret.m_nSayX, // - Canvas.TextWidth(uname) div 2,
          g_FocusCret.m_nSayY + 30,
          g_FocusCret.m_nNameColor, clBlack,
          uname);
      end;
      if g_boSelectMyself then begin
        uname := g_MySelf.m_sDescUserName + '\' + g_MySelf.m_sUserName;
        NameTextOut(MSurface,
          g_MySelf.m_nSayX, // - Canvas.TextWidth(uname) div 2,
          g_MySelf.m_nSayY + 30,
          g_MySelf.m_nNameColor, clBlack,
          uname);
      end;

      Canvas.Font.Color := clWhite;

      //显示角色说话文字
      with PlayScene do begin
        for k := 0 to m_ActorList.Count - 1 do begin
          Actor := m_ActorList[k];
          if Actor.m_SayingArr[0] <> '' then begin
            if GetTickCount - Actor.m_dwSayTime < 4 * 1000 then begin
              for i := 0 to Actor.m_nSayLineCount - 1 do
                if Actor.m_boDeath then
                  BoldTextOut(MSurface,
                    Actor.m_nSayX - (Actor.m_SayWidthsArr[i] div 2),
                    Actor.m_nSayY - (Actor.m_nSayLineCount * 16) + i * 14,
                    clGray, clBlack,
                    Actor.m_SayingArr[i])
                else
                  BoldTextOut(MSurface,
                    Actor.m_nSayX - (Actor.m_SayWidthsArr[i] div 2),
                    Actor.m_nSayY - (Actor.m_nSayLineCount * 16) + i * 14,
                    clWhite, clBlack,
                    Actor.m_SayingArr[i]);
            end else
              Actor.m_SayingArr[0] := '';
          end;
        end;
      end;

         if g_boShowName then begin
           with PlayScene do begin
              for nX := g_MySelf.m_nCurrX - 8 to g_MySelf.m_nCurrX + 8 do begin
                 for nY := g_MySelf.m_nCurrY - 8 to g_MySelf.m_nCurrY + 8 do begin
                  Actor := FindActorXY(nX, nY);
               if (Actor <> nil) and (not Actor.m_boDeath) then begin
                  if  Actor.m_btRace in [45,11,50] then begin
                      NameTextOut (MSurface,
                      actor.m_nSayX,
                      actor.m_nSayY + 30,
                      GetRGB(218), clBlack,
                      actor.m_sUserName);
                  end else begin
                    if  (Actor.m_btRace = 0) then
                      NameTextOut (MSurface,
                      actor.m_nSayX,
                      actor.m_nSayY + 30,
                      actor.m_nNameColor, clBlack,
                      actor.m_sDescUserName + '\' + actor.m_sUserName);
                  end;
                end;
              end;
            end;
           end;
         end;


      Canvas.Font.Color := clWhite;


     

      //BoldTextOut (MSurface, 0, 0, clWhite, clBlack, IntToStr(SendCount) + ' : ' + IntToStr(ReceiveCount));
      //BoldTextOut (MSurface, 0, 0, clWhite, clBlack, 'HITSPEED=' + IntToStr(Myself.HitSpeed));
      //BoldTextOut (MSurface, 0, 0, clWhite, clBlack, 'DupSel=' + IntToStr(DupSelection));
      //BoldTextOut (MSurface, 0, 0, clWhite, clBlack, IntToStr(LastHookKey));
      //BoldTextOut (MSurface, 0, 0, clWhite, clBlack,
      //             IntToStr(
      //                int64(GetTickCount - LatestSpellTime) - int64(700 + MagicDelayTime)
      //                ));
      //BoldTextOut (MSurface, 0, 0, clWhite, clBlack, IntToStr(PlayScene.EffectList.Count));
      //BoldTextOut (MSurface, 0, 0, clWhite, clBlack,
      //                  IntToStr(Myself.XX) + ',' + IntToStr(Myself.m_nCurrY) + '  ' +
      //                  IntToStr(Myself.ShiftX) + ',' + IntToStr(Myself.ShiftY));

      if (g_nAreaStateValue and $04) <> 0 then begin
        BoldTextOut(MSurface, 0, 0, clWhite, clBlack, '攻城区域');
      end;

      Canvas.Release;

      k := 0;
      for i := 0 to 15 do begin
        if g_nAreaStateValue and ($01 shr i) <> 0 then begin
          d := g_WMainImages.Images[AREASTATEICONBASE + i];
          if d <> nil then begin
            k := k + d.Width;
            MSurface.Draw(SCREENWIDTH - k, 0, d.ClientRect, d, True);
          end;
        end;
      end;
    end;
  end;
end;
//显示左上角信息文字
procedure TDrawScreen.DrawScreenTop(MSurface: TDirectDrawSurface);
var
  i, sx, sY: Integer;
  SysMsg: pTSysMsg;
begin
  if g_MySelf = nil then Exit;
  if CurrentScene = PlayScene then begin
    with MSurface do begin
      SetBkMode(Canvas.Handle, TRANSPARENT);
      if m_SysMsgList.Count > 0 then begin
        for i := 0 to m_SysMsgList.Count - 1 do begin
          SysMsg := pTSysMsg(m_SysMsgList.Items[i]);
          if SysMsgPosition[SysMsg.nMsgType] = 0 then
            SysMsgPosition[SysMsg.nMsgType] := SysMsg.nY;
          BoldTextOut(MSurface, SysMsg.nX, SysMsgPosition[SysMsg.nMsgType], SysMsg.Color, clBlack, SysMsg.sSysMsg); //clGreen
          Inc(SysMsgPosition[SysMsg.nMsgType], 16);
        end;
        for i := Low(SysMsgCount) to High(SysMsgCount) do begin
          SysMsgPosition[i] := 0;
          DeleteSysMsg(i);
        end;
        {SysMsg := pTSysMsg(m_SysMsgList.Items[0]);
        if GetTickCount - LongWord(SysMsg.dwSpellTime) >= 3000 then begin
          m_SysMsgList.Delete(0);
          DisPose(SysMsg);
        end; }
      end;
      Canvas.Release;
    end;
  end;
end;

procedure TDrawScreen.DrawHint(MSurface: TDirectDrawSurface);
var
  d: TDirectDrawSurface;
  i, hx, hy, old: Integer;
  str: string;
begin
  hx := 0;
  hy := 0;
  if HintList.Count > 0 then begin
    d := g_WMainImages.Images[394];
    if d <> nil then begin
      if HintWidth > d.Width then HintWidth := d.Width;
      if HintHeight > d.Height then HintHeight := d.Height;
      if HintX + HintWidth > SCREENWIDTH then hx := SCREENWIDTH - HintWidth
      else hx := HintX;
      if HintY < 0 then hy := 0
      else hy := HintY;
      if hx < 0 then hx := 0;

      DrawBlendEx(MSurface, hx, hy, d, 0, 0, HintWidth, HintHeight, 0);
    end;
  end;
  with MSurface do begin
    SetBkMode(Canvas.Handle, TRANSPARENT);
    if HintList.Count > 0 then begin
      Canvas.Font.Color := HintColor;
      for i := 0 to HintList.Count - 1 do begin
        Canvas.TextOut(hx + 4, hy + 3 + (Canvas.TextHeight('A') + 1) * i, HintList[i]);
      end;
    end;

    if g_MySelf <> nil then begin
      //显示人物血量
      //BoldTextOut (MSurface, 15, SCREENHEIGHT - 120, clWhite, clBlack, IntToStr(g_MySelf.m_Abil.HP) + '/' + IntToStr(g_MySelf.m_Abil.MaxHP));
      //人物MP值
      //BoldTextOut (MSurface, 115, SCREENHEIGHT - 120, clWhite, clBlack, IntToStr(g_MySelf.m_Abil.MP) + '/' + IntToStr(g_MySelf.m_Abil.MaxMP));
      //人物经验值
      //BoldTextOut (MSurface, 655, SCREENHEIGHT - 55, clWhite, clBlack, IntToStr(g_MySelf.Abil.Exp) + '/' + IntToStr(g_MySelf.Abil.MaxExp));
      //人物背包重量
      //BoldTextOut (MSurface, 655, SCREENHEIGHT - 25, clWhite, clBlack, IntToStr(g_MySelf.Abil.Weight) + '/' + IntToStr(g_MySelf.Abil.MaxWeight));

      if g_boShowGreenHint then begin
        str := 'Time: ' + TimeToStr(Time) +
          ' Exp: ' + IntToStr(g_MySelf.m_Abil.Exp) + '/' + IntToStr(g_MySelf.m_Abil.MaxExp) +
          ' Weight: ' + IntToStr(g_MySelf.m_Abil.Weight) + '/' + IntToStr(g_MySelf.m_Abil.MaxWeight) +
          ' ' + g_sGoldName + ': ' + IntToStr(g_MySelf.m_nGold) +
          ' Cursor: ' + IntToStr(g_nMouseCurrX) + ':' + IntToStr(g_nMouseCurrY) + '(' + IntToStr(g_nMouseX) + ':' + IntToStr(g_nMouseY) + ')';
        if g_FocusCret <> nil then begin
          str := str + ' Target: ' + g_FocusCret.m_sUserName + '(' + IntToStr(g_FocusCret.m_Abil.HP) + '/' + IntToStr(g_FocusCret.m_Abil.MaxHP) + ')';
        end else begin
          str := str + ' Target: -/-';
        end;
        BoldTextOut(MSurface, 10, 0, clLime, clBlack, str);
        str := '';
      end;

      if g_boCheckBadMapMode then begin
        str := IntToStr(m_dwDrawFrameCount) + ' '
          + '  Mouse ' + IntToStr(g_nMouseX) + ':' + IntToStr(g_nMouseY) + '(' + IntToStr(g_nMouseCurrX) + ':' + IntToStr(g_nMouseCurrY) + ')'
          + '  HP' + IntToStr(g_MySelf.m_Abil.HP) + '/' + IntToStr(g_MySelf.m_Abil.MaxHP)
          + '  D0 ' + IntToStr(g_nDebugCount)
          + ' D1 ' + IntToStr(g_nDebugCount1) + ' D2 '
          + IntToStr(g_nDebugCount2);
        BoldTextOut(MSurface, 10, 0, clWhite, clBlack, str);
      end;

      if g_boShowWhiteHint then begin
        if g_MySelf.m_nGameGold > 10 then begin
          BoldTextOut(MSurface, 8, SCREENHEIGHT - 42 - 16, clWhite, clBlack, g_sGameGoldName + ' ' + IntToStr(g_MySelf.m_nGameGold));
        end else begin
          BoldTextOut(MSurface, 8, SCREENHEIGHT - 42 - 16, clRed, clBlack, g_sGameGoldName + ' ' + IntToStr(g_MySelf.m_nGameGold));
        end;
        if g_MySelf.m_nGamePoint > 10 then begin
          BoldTextOut(MSurface, 8 + 90, SCREENHEIGHT - 58, clWhite, clBlack, g_sGamePointName + ' ' + IntToStr(g_MySelf.m_nGamePoint));
        end else begin
          BoldTextOut(MSurface, 8 + 90, SCREENHEIGHT - 58, clRed, clBlack, g_sGamePointName + ' ' + IntToStr(g_MySelf.m_nGamePoint));
        end;
        //显示时间
        BoldTextOut(MSurface, SCREENWIDTH - 128, SCREENHEIGHT - 147 + 126, clWhite, clBlack, FormatDateTime('hh:mm:ss', Now));
        //显示血和魔
        BoldTextOut(MSurface, 26, SCREENHEIGHT - 38, clWhite, clBlack, format('%d/%d', [g_MySelf.m_Abil.HP, g_MySelf.m_Abil.MaxHP]));
        BoldTextOut(MSurface, 88, SCREENHEIGHT - 38, clWhite, clBlack, format('%d/%d', [g_MySelf.m_Abil.MP, g_MySelf.m_Abil.MaxMP]));
      end;
      //显示所在地图
      BoldTextOut(MSurface, 8, SCREENHEIGHT - 20 + 4, clWhite, clBlack, g_sMapTitle + ' ' + IntToStr(g_MySelf.m_nCurrX) + ':' + IntToStr(g_MySelf.m_nCurrY));
      //Canvas.Font.Size := old;
    end;
    Canvas.Release;
  end;
end;


end.


unit Guild;

interface
uses
  Windows, SysUtils, Classes, IniFiles, ObjBase;
type
  TGuildRank = record
    nRankNo: Integer;
    sRankName: string;
    MemberList: TStringList;
  end;
  pTGuildRank = ^TGuildRank;
  TWarGuild = record
    Guild: TObject;
    dwWarTick: LongWord;
    dwWarTime: LongWord;
  end;
  pTWarGuild = ^TWarGuild;
  TGuild = class
    sGuildName: string;
    NoticeList: TStringList;
    GuildWarList: TStringList;
    GuildAllList: TStringList;
    m_RankList: TList; // 职位列表
    nContestPoint: Integer;
    boTeamFight: Boolean;
    //    MatchPoint   :Integer;
    TeamFightDeadList: TStringList;
    m_boEnableAuthAlly: Boolean;
    dwSaveTick: LongWord;
    boChanged: Boolean;
    m_DynamicVarList: TList;
  private
    m_Config: TIniFile;
    m_nBuildPoint: Integer; //建筑度
    m_nAurae: Integer; //人气度
    m_nStability: Integer; //安定度
    m_nFlourishing: Integer; //繁荣度
    m_nChiefItemCount: Integer; //行会领取装备数量

    function SetGuildInfo(sChief: string): Boolean;
    procedure ClearRank();
    procedure SaveGuildFile(sFileName: string);
    procedure SaveGuildConfig(sFileName: string);
    function GetMemberCount(): Integer;
    function GetMemgerIsFull(): Boolean;
    procedure SetAuraePoint(nPoint: Integer);
    procedure SetBuildPoint(nPoint: Integer);
    procedure SetStabilityPoint(nPoint: Integer);
    procedure SetFlourishPoint(nPoint: Integer);
    procedure SetChiefItemCount(nPoint: Integer);
  public
    constructor Create(sName: string);
    destructor Destroy; override;
    procedure SaveGuildInfoFile();
    function LoadGuild(): Boolean;
    function LoadGuildFile(sGuildFileName: string): Boolean;
    function LoadGuildConfig(sGuildFileName: string): Boolean;
    procedure UpdateGuildFile;
    procedure CheckSaveGuildFile;
    function IsMember(sName: string): Boolean;
    function IsAllyGuild(Guild: TGuild): Boolean;
    function IsWarGuild(Guild: TGuild): Boolean;
    function DelAllyGuild(Guild: TGuild): Boolean;
    procedure TeamFightWhoDead(sName: string);
    procedure TeamFightWhoWinPoint(sName: string; nPoint: Integer);
    procedure SendGuildMsg(sMsg: string);
    procedure RefMemberName();
    function GetRankName(PlayObject: TPlayObject; var nRankNo: Integer): string;
    function DelMember(sHumName: string): Boolean;
    function UpdateRank(sRankData: string): Integer;
    function CancelGuld(sHumName: string): Boolean;
    function IsNotWarGuild(Guild: TGuild): Boolean;
    function AllyGuild(Guild: TGuild): Boolean;

    function AddMember(PlayObject: TPlayObject): Boolean;
    procedure DelHumanObj(PlayObject: TPlayObject);
    function GetChiefName(): string;
    procedure BackupGuildFile();
    procedure sub_499B4C(Guild: TGuild);
    function AddWarGuild(Guild: TGuild): pTWarGuild;
    procedure StartTeamFight();
    procedure EndTeamFight();
    procedure AddTeamFightMember(sHumanName: string);
    property Count: Integer read GetMemberCount;
    property IsFull: Boolean read GetMemgerIsFull;
    property nBuildPoint: Integer read m_nBuildPoint write SetBuildPoint;
    property nAurae: Integer read m_nAurae write SetAuraePoint;
    property nStability: Integer read m_nStability write SetStabilityPoint;
    property nFlourishing: Integer read m_nFlourishing write SetFlourishPoint;
    property nChiefItemCount: Integer read m_nChiefItemCount write SetChiefItemCount;
  end;
  TGuildManager = class
    GuildList: TList;
  private
  public
    constructor Create();
    destructor Destroy; override;
    procedure LoadGuildInfo();
    procedure SaveGuildList();
    function MemberOfGuild(sName: string): TGuild;
    function AddGuild(sGuildName, sChief: string): Boolean;
    function FindGuild(sGuildName: string): TGuild;
    function DelGuild(sGuildName: string): Boolean;
    procedure ClearGuildInf();
    procedure Run();
  end;
implementation

uses M2Share, HUtil32, Grobal2;

{ TGuildManager }

function TGuildManager.AddGuild(sGuildName, sChief: string): Boolean;
var
  Guild: TGuild;
begin
  Result := False;
  if CheckGuildName(sGuildName) and (FindGuild(sGuildName) = nil) then begin
    Guild := TGuild.Create(sGuildName);
    Guild.SetGuildInfo(sChief);
    GuildList.Add(Guild);
    SaveGuildList();
    Result := True;
  end;
end;

function TGuildManager.DelGuild(sGuildName: string): Boolean;
var
  I: Integer;
  Guild: TGuild;
begin
  Result := False;
  for I := 0 to GuildList.Count - 1 do begin
    Guild := TGuild(GuildList.Items[I]);
    if CompareText(Guild.sGuildName, sGuildName) = 0 then begin
      if Guild.m_RankList.Count > 1 then break;
      Guild.BackupGuildFile();
      GuildList.Delete(I);
      SaveGuildList();
      Result := True;
      break;
    end;
  end;
end;

procedure TGuildManager.ClearGuildInf;
var
  I: Integer;
begin
  for I := 0 to GuildList.Count - 1 do begin
    TGuild(GuildList.Items[I]).Free;
  end;
  GuildList.Clear;
end;

constructor TGuildManager.Create;
begin
  GuildList := TList.Create;
end;

destructor TGuildManager.Destroy;
begin
  GuildList.Free;
  inherited;
end;

function TGuildManager.FindGuild(sGuildName: string): TGuild;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to GuildList.Count - 1 do begin
    if TGuild(GuildList.Items[I]).sGuildName = sGuildName then begin
      Result := TGuild(GuildList.Items[I]);
      break;
    end;
  end;
end;

procedure TGuildManager.LoadGuildInfo;
var
  LoadList: TStringList;
  Guild: TGuild;
  sGuildName: string;
  I: Integer;
begin
  if FileExists(g_Config.sGuildFile) then begin
    LoadList := TStringList.Create;
    LoadList.LoadFromFile(g_Config.sGuildFile);
    for I := 0 to LoadList.Count - 1 do begin
      sGuildName := Trim(LoadList.Strings[I]);
      if sGuildName <> '' then begin
        Guild := TGuild.Create(sGuildName);
        GuildList.Add(Guild);
      end;
    end;
    LoadList.Free;
    for I := GuildList.Count - 1 downto 0 do begin
      Guild := GuildList.Items[I];
      if not Guild.LoadGuild() then begin
        MainOutMessage(Guild.sGuildName + ' 读取出错！！！');
        Guild.Free;
        GuildList.Delete(I);
        SaveGuildList();
      end;
    end;
    MainOutMessage('已读取 ' + IntToStr(GuildList.Count) + '个行会信息...');
  end else begin
    MainOutMessage('行会信息文件未找到！！！');
  end;
end;

function TGuildManager.MemberOfGuild(sName: string): TGuild;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to GuildList.Count - 1 do begin
    if TGuild(GuildList.Items[I]).IsMember(sName) then begin
      Result := TGuild(GuildList.Items[I]);
      break;
    end;
  end;
end;

procedure TGuildManager.SaveGuildList;
var
  I: Integer;
  SaveList: TStringList;
begin
  if nServerIndex <> 0 then Exit;
  SaveList := TStringList.Create;
  for I := 0 to GuildList.Count - 1 do begin
    SaveList.Add(TGuild(GuildList.Items[I]).sGuildName);
  end; // for
  try
    SaveList.SaveToFile(g_Config.sGuildFile);
  except
    MainOutMessage('行会信息保存失败！！！');
  end;
  SaveList.Free;
end;

procedure TGuildManager.Run;
var
  I: Integer;
  II: Integer;
  Guild: TGuild;
  boChanged: Boolean;
  WarGuild: pTWarGuild;
begin
  for I := 0 to GuildList.Count - 1 do begin
    Guild := TGuild(GuildList.Items[I]);
    boChanged := False;
    for II := Guild.GuildWarList.Count - 1 downto 0 do begin
      WarGuild := pTWarGuild(Guild.GuildWarList.Objects[II]);
      if (GetTickCount - WarGuild.dwWarTick) > WarGuild.dwWarTime then begin
        Guild.sub_499B4C(TGuild(WarGuild.Guild));
        Guild.GuildWarList.Delete(II);
        Dispose(WarGuild);
        boChanged := True;
      end;
    end;
    if boChanged then begin
      Guild.UpdateGuildFile();
    end;
    Guild.CheckSaveGuildFile;
  end;
end;

{ TGuild }
procedure TGuild.ClearRank;
var
  I: Integer;
  GuildRank: pTGuildRank;
begin
  for I := 0 to m_RankList.Count - 1 do begin
    GuildRank := m_RankList.Items[I];
    GuildRank.MemberList.Free;
    Dispose(GuildRank);
  end; // for
  m_RankList.Clear;
end;

constructor TGuild.Create(sName: string);
var
  sFileName: string;
begin
  sGuildName := sName;
  NoticeList := TStringList.Create;
  GuildWarList := TStringList.Create;
  GuildAllList := TStringList.Create;
  m_RankList := TList.Create;
  TeamFightDeadList := TStringList.Create;
  dwSaveTick := 0;
  boChanged := False;
  nContestPoint := 0;
  boTeamFight := False;
  m_boEnableAuthAlly := False;

  sFileName := g_Config.sGuildDir + sName + '.ini';
  m_Config := TIniFile.Create(sFileName);
  if not FileExists(sFileName) then begin
    m_Config.WriteString('Guild', 'GuildName', sName);
  end;

  m_nBuildPoint := 0;
  m_nAurae := 0;
  m_nStability := 0;
  m_nFlourishing := 0;
  m_nChiefItemCount := 0;
  m_DynamicVarList := TList.Create;
end;

function TGuild.DelAllyGuild(Guild: TGuild): Boolean;
var
  I: Integer;
  AllyGuild: TGuild;
begin
  Result := False;
  for I := 0 to GuildAllList.Count - 1 do begin
    AllyGuild := TGuild(GuildAllList.Objects[I]);
    if AllyGuild = Guild then begin
      GuildAllList.Delete(I);
      Result := True;
      break;
    end;
  end; // for
  SaveGuildInfoFile();
end;

destructor TGuild.Destroy;
var
  I: Integer;
begin
  NoticeList.Free;
  GuildWarList.Free;
  GuildAllList.Free;
  ClearRank();
  m_RankList.Free;
  TeamFightDeadList.Free;
  m_Config.Free;
  for I := 0 to m_DynamicVarList.Count - 1 do begin
    Dispose(pTDynamicVar(m_DynamicVarList.Items[I]));
  end;
  m_DynamicVarList.Free;
  inherited;
end;

function TGuild.IsAllyGuild(Guild: TGuild): Boolean;
var
  I: Integer;
  AllyGuild: TGuild;
begin
  Result := False;
  for I := 0 to GuildAllList.Count - 1 do begin
    AllyGuild := TGuild(GuildAllList.Objects[I]);
    if AllyGuild = Guild then begin
      Result := True;
      break;
    end;
  end;
end;

function TGuild.IsMember(sName: string): Boolean;
var
  I, II: Integer;
  GuildRank: pTGuildRank;
begin
  Result := False;
  for I := 0 to m_RankList.Count - 1 do begin
    GuildRank := m_RankList.Items[I];
    for II := 0 to GuildRank.MemberList.Count - 1 do begin
      if GuildRank.MemberList.Strings[II] = sName then begin
        Result := True;
        Exit;
      end;
    end;
  end;
end;

function TGuild.IsWarGuild(Guild: TGuild): Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 0 to GuildWarList.Count - 1 do begin
    if pTWarGuild(GuildWarList.Objects[I]).Guild = Guild then begin
      Result := True;
      break;
    end;
  end; // for
end;

function TGuild.LoadGuild(): Boolean;
var
  sFileName: string;
begin
  sFileName := sGuildName + '.txt';
  Result := LoadGuildFile(sFileName);
  LoadGuildConfig(sGuildName + '.ini');
end;

function TGuild.LoadGuildConfig(sGuildFileName: string): Boolean;
begin
  m_nBuildPoint := m_Config.ReadInteger('Guild', 'BuildPoint', m_nBuildPoint);
  m_nAurae := m_Config.ReadInteger('Guild', 'Aurae', m_nAurae);
  m_nStability := m_Config.ReadInteger('Guild', 'Stability', m_nStability);
  m_nFlourishing := m_Config.ReadInteger('Guild', 'Flourishing', m_nFlourishing);
  m_nChiefItemCount := m_Config.ReadInteger('Guild', 'ChiefItemCount', m_nChiefItemCount);
  Result := True;
end;

function TGuild.LoadGuildFile(sGuildFileName: string): Boolean;
var
  I: Integer;
  LoadList: TStringList;
  s18, s1C, s20, s24, sFileName: string;
  n28, n2C: Integer;
  GuildWar: pTWarGuild;
  GuildRank: pTGuildRank;
  Guild: TGuild;
begin
  Result := False;
  GuildRank := nil;
  sFileName := g_Config.sGuildDir + sGuildFileName;
  if not FileExists(sFileName) then Exit;
  ClearRank();
  NoticeList.Clear;
  for I := 0 to GuildWarList.Count - 1 do begin
    Dispose(pTWarGuild(GuildWarList.Objects[I]));
  end; // for
  GuildWarList.Clear;
  GuildAllList.Clear;
  n28 := 0;
  n2C := 0;
  s24 := '';
  LoadList := TStringList.Create;
  LoadList.LoadFromFile(sFileName);
  for I := 0 to LoadList.Count - 1 do begin
    s18 := LoadList.Strings[I];
    if (s18 = '') or (s18[1] = ';') then Continue;
    if s18[1] <> '+' then begin
      if s18 = g_Config.sGuildNotice then n28 := 1;
      if s18 = g_Config.sGuildWar then n28 := 2;
      if s18 = g_Config.sGuildAll then n28 := 3;
      if s18 = g_Config.sGuildMember then n28 := 4;
      if s18[1] = '#' then begin
        s18 := Copy(s18, 2, Length(s18) - 1);
        s18 := GetValidStr3(s18, s1C, [' ', ',']);
        n2C := Str_ToInt(s1C, 0);
        s24 := Trim(s18);
        GuildRank := nil;
      end;
      Continue;
    end;
    s18 := Copy(s18, 2, Length(s18) - 1);
    case n28 of
      1: NoticeList.Add(s18);
      2: begin
          while (s18 <> '') do begin
            s18 := GetValidStr3(s18, s1C, [' ', ',']);
            if s1C = '' then break;
            New(GuildWar);
            GuildWar.Guild := g_GuildManager.FindGuild(s1C);
            if GuildWar.Guild <> nil then begin
              GuildWar.dwWarTick := GetTickCount();
              GuildWar.dwWarTime := Str_ToInt(Trim(s20), 0);
              GuildWarList.AddObject(TGuild(GuildWar.Guild).sGuildName, TObject(GuildWar));
            end else begin
              Dispose(GuildWar);
            end;
          end;
        end;
      3: begin
          while (s18 <> '') do begin
            s18 := GetValidStr3(s18, s1C, [' ', ',']);
            s18 := GetValidStr3(s18, s20, [' ', ',']);
            if s1C = '' then break;
            Guild := g_GuildManager.FindGuild(s1C);
            if Guild <> nil then GuildAllList.AddObject(s1C, Guild);
          end;
        end;
      4: begin
          if (n2C > 0) and (s24 <> '') then begin
            if Length(s24) > 30 then //Jacky 限制职倍的长度
              s24 := Copy(s24, 1, g_Config.nGuildRankNameLen {30});
            if GuildRank = nil then begin
              New(GuildRank);
              GuildRank.nRankNo := n2C;
              GuildRank.sRankName := s24;
              GuildRank.MemberList := TStringList.Create;
              m_RankList.Add(GuildRank);
            end;
            while (s18 <> '') do begin
              s18 := GetValidStr3(s18, s1C, [' ', ',']);
              if s1C = '' then break;
              GuildRank.MemberList.Add(s1C);
            end;
          end;
        end;
    end; // case
  end;
  LoadList.Free;
  Result := True;
end;

procedure TGuild.RefMemberName;
var
  I, II: Integer;
  GuildRank: pTGuildRank;
  BaseObject: TBaseObject;
begin
  for I := 0 to m_RankList.Count - 1 do begin
    GuildRank := m_RankList.Items[I];
    for II := 0 to GuildRank.MemberList.Count - 1 do begin
      BaseObject := TBaseObject(GuildRank.MemberList.Objects[II]);
      if BaseObject <> nil then BaseObject.RefShowName;
    end;
  end;
end;

procedure TGuild.SaveGuildInfoFile;
begin
  if nServerIndex = 0 then begin
    SaveGuildFile(g_Config.sGuildDir + sGuildName + '.txt');
    SaveGuildConfig(g_Config.sGuildDir + sGuildName + '.ini');
  end else begin
    SaveGuildFile(g_Config.sGuildDir + sGuildName + '.' + IntToStr(nServerIndex));
  end;
end;

procedure TGuild.SaveGuildConfig(sFileName: string);
begin
  m_Config.WriteString('Guild', 'GuildName', sGuildName);
  m_Config.WriteInteger('Guild', 'BuildPoint', m_nBuildPoint);
  m_Config.WriteInteger('Guild', 'Aurae', m_nAurae);
  m_Config.WriteInteger('Guild', 'Stability', m_nStability);
  m_Config.WriteInteger('Guild', 'Flourishing', m_nFlourishing);
  m_Config.WriteInteger('Guild', 'ChiefItemCount', m_nChiefItemCount);
end;

procedure TGuild.SaveGuildFile(sFileName: string);
var
  SaveList: TStringList;
  I, II: Integer;
  WarGuild: pTWarGuild;
  GuildRank: pTGuildRank;
  n14: Integer;
begin
  SaveList := TStringList.Create;
  SaveList.Add(g_Config.sGuildNotice);
  for I := 0 to NoticeList.Count - 1 do begin
    SaveList.Add('+' + NoticeList.Strings[I]);
  end;
  SaveList.Add(' ');
  SaveList.Add(g_Config.sGuildWar);
  for I := 0 to GuildWarList.Count - 1 do begin
    WarGuild := pTWarGuild(GuildWarList.Objects[I]);
    n14 := WarGuild.dwWarTime - (GetTickCount - WarGuild.dwWarTick);
    if n14 <= 0 then Continue;
    SaveList.Add('+' + GuildWarList.Strings[I] + ' ' + IntToStr(n14));
  end;
  SaveList.Add(' ');
  SaveList.Add(g_Config.sGuildAll);
  for I := 0 to GuildAllList.Count - 1 do begin
    SaveList.Add('+' + GuildAllList.Strings[I]);
  end;
  SaveList.Add(' ');
  SaveList.Add(g_Config.sGuildMember);
  for I := 0 to m_RankList.Count - 1 do begin
    GuildRank := m_RankList.Items[I];
    SaveList.Add('#' + IntToStr(GuildRank.nRankNo) + ' ' + GuildRank.sRankName);
    for II := 0 to GuildRank.MemberList.Count - 1 do begin
      SaveList.Add('+' + GuildRank.MemberList.Strings[II]);
    end;
  end;
  try
    SaveList.SaveToFile(sFileName);
  except
    MainOutMessage('保存行会信息失败！！！ ' + sFileName);
  end;
  SaveList.Free;
end;

procedure TGuild.SendGuildMsg(sMsg: string);
var
  I: Integer;
  II: Integer;
  GuildRank: pTGuildRank;
  BaseObject: TBaseObject;
  nCheckCode: Integer;
begin
  nCheckCode := 0;
  try
    if g_Config.boShowPreFixMsg then
      sMsg := g_Config.sGuildMsgPreFix + sMsg;
    //if RankList = nil then exit;
    nCheckCode := 1;
    for I := 0 to m_RankList.Count - 1 do begin
      GuildRank := m_RankList.Items[I];
      nCheckCode := 2;
      if GuildRank.MemberList = nil then Continue;
      for II := 0 to GuildRank.MemberList.Count - 1 do begin
        nCheckCode := 3;
        BaseObject := TBaseObject(GuildRank.MemberList.Objects[II]);
        if BaseObject = nil then Continue;
        nCheckCode := 4;
        if BaseObject.m_boBanGuildChat then begin
          nCheckCode := 5;
          BaseObject.SendMsg(BaseObject, RM_GUILDMESSAGE, 0, g_Config.btGuildMsgFColor, g_Config.btGuildMsgBColor, 0, sMsg);
          nCheckCode := 6;
        end;
      end;
    end;
    (*
    TGuild.SendGuildMsg CheckCode: 5 GuildName = 〖統治〗 Msg = 〖行会〗釢fěη﹖: 换的玩撒
  2004-12-2 15:45:48 Access violation at address 0041FD64 in module 'M2Server.exe'. Read of address 00000008
    *);
  except
    on e: Exception do begin
      MainOutMessage('[Exceptiion] TGuild.SendGuildMsg CheckCode: ' + IntToStr(nCheckCode) + ' GuildName = ' + sGuildName + ' Msg = ' + sMsg);
      MainOutMessage(e.Message);
    end;
  end;
end;

function TGuild.SetGuildInfo(sChief: string): Boolean;
var
  GuildRank: pTGuildRank;
begin
  if m_RankList.Count = 0 then begin
    New(GuildRank);
    GuildRank.nRankNo := 1;
    GuildRank.sRankName := g_Config.sGuildChief;
    GuildRank.MemberList := TStringList.Create;
    GuildRank.MemberList.Add(sChief);
    m_RankList.Add(GuildRank);
    SaveGuildInfoFile();
  end;
  Result := True;
end;

function TGuild.GetRankName(PlayObject: TPlayObject; var nRankNo: Integer): string;
var
  I, II: Integer;
  GuildRank: pTGuildRank;
begin
  Result := '';
  for I := 0 to m_RankList.Count - 1 do begin
    GuildRank := m_RankList.Items[I];
    for II := 0 to GuildRank.MemberList.Count - 1 do begin
      if GuildRank.MemberList.Strings[II] = PlayObject.m_sCharName then begin
        GuildRank.MemberList.Objects[II] := PlayObject;
        nRankNo := GuildRank.nRankNo;
        Result := GuildRank.sRankName;
        //PlayObject.RefShowName();
        PlayObject.SendMsg(PlayObject, RM_CHANGEGUILDNAME, 0, 0, 0, 0, '');
        Exit;
      end;
    end;
  end;
end;

function TGuild.GetChiefName: string;
var
  GuildRank: pTGuildRank;
begin
  Result := '';
  if m_RankList.Count <= 0 then Exit;
  GuildRank := m_RankList.Items[0];
  if GuildRank.MemberList.Count <= 0 then Exit;
  Result := GuildRank.MemberList.Strings[0];
end;

procedure TGuild.CheckSaveGuildFile();
begin
  if boChanged and ((GetTickCount - dwSaveTick) > 30 * 1000) then begin
    boChanged := False;
    SaveGuildInfoFile();
  end;
end;

procedure TGuild.DelHumanObj(PlayObject: TPlayObject);
var
  I, II: Integer;
  GuildRank: pTGuildRank;
begin
  CheckSaveGuildFile();
  for I := 0 to m_RankList.Count - 1 do begin
    GuildRank := m_RankList.Items[I];
    for II := 0 to GuildRank.MemberList.Count - 1 do begin
      if TPlayObject(GuildRank.MemberList.Objects[II]) = PlayObject then begin
        GuildRank.MemberList.Objects[II] := nil;
        Exit;
      end;
    end;
  end;
end;

procedure TGuild.TeamFightWhoDead(sName: string);
var
  I, n10: Integer;
begin
  if not boTeamFight then Exit;
  for I := 0 to TeamFightDeadList.Count - 1 do begin
    if TeamFightDeadList.Strings[I] = sName then begin
      n10 := Integer(TeamFightDeadList.Objects[I]);
      TeamFightDeadList.Objects[I] := TObject(MakeLong(LoWord(n10) + 1, HiWord(n10)));
    end;
  end;
end;

procedure TGuild.TeamFightWhoWinPoint(sName: string; nPoint: Integer);
var
  I, n14: Integer;
begin
  if not boTeamFight then Exit;
  Inc(nContestPoint, nPoint);
  for I := 0 to TeamFightDeadList.Count - 1 do begin
    if TeamFightDeadList.Strings[I] = sName then begin
      n14 := Integer(TeamFightDeadList.Objects[I]);
      TeamFightDeadList.Objects[I] := TObject(MakeLong(LoWord(n14), HiWord(n14) + nPoint));
    end;
  end;
end;

procedure TGuild.UpdateGuildFile();
begin
  boChanged := True;
  dwSaveTick := GetTickCount();
  SaveGuildInfoFile();
end;
procedure TGuild.BackupGuildFile;
var
  I, II: Integer;
  PlayObject: TPlayObject;
  GuildRank: pTGuildRank;
begin
  if nServerIndex = 0 then
    SaveGuildFile(g_Config.sGuildDir + sGuildName + '.' + IntToStr(GetTickCount) + '.bak');
  for I := 0 to m_RankList.Count - 1 do begin
    GuildRank := m_RankList.Items[I];
    for II := 0 to GuildRank.MemberList.Count - 1 do begin
      PlayObject := TPlayObject(GuildRank.MemberList.Objects[II]);
      if PlayObject <> nil then begin
        PlayObject.m_MyGuild := nil;
        PlayObject.RefRankInfo(0, '');
        PlayObject.RefShowName(); //10/31
      end;
    end;
    GuildRank.MemberList.Free;
    Dispose(GuildRank);
  end;
  m_RankList.Clear;
  NoticeList.Clear;
  for I := 0 to GuildWarList.Count - 1 do begin
    Dispose(pTWarGuild(GuildWarList.Objects[I]));
  end;
  GuildWarList.Clear;
  GuildAllList.Clear;
  SaveGuildInfoFile();
end;

function TGuild.AddMember(PlayObject: TPlayObject): Boolean; //00498CA8
var
  I: Integer;
  GuildRank: pTGuildRank;
  GuildRank18: pTGuildRank;
begin
  Result := False;
  GuildRank18 := nil;
  for I := 0 to m_RankList.Count - 1 do begin
    GuildRank := m_RankList.Items[I];
    if GuildRank.nRankNo = 99 then begin
      GuildRank18 := GuildRank;
      break;
    end;
  end;
  if GuildRank18 = nil then begin
    New(GuildRank18);
    GuildRank18.nRankNo := 99;
    GuildRank18.sRankName := g_Config.sGuildMemberRank;
    GuildRank18.MemberList := TStringList.Create;
    m_RankList.Add(GuildRank18);
  end;
  GuildRank18.MemberList.AddObject(PlayObject.m_sCharName, TObject(PlayObject));
  UpdateGuildFile();
  Result := True;
end;

function TGuild.DelMember(sHumName: string): Boolean;
var
  I, II: Integer;
  GuildRank: pTGuildRank;
begin
  Result := False;
  for I := 0 to m_RankList.Count - 1 do begin
    GuildRank := m_RankList.Items[I];
    for II := 0 to GuildRank.MemberList.Count - 1 do begin
      if GuildRank.MemberList.Strings[II] = sHumName then begin
        GuildRank.MemberList.Delete(II);
        Result := True;
        break;
      end;
    end;
    if Result then break;
  end;
  if Result then UpdateGuildFile;
end;

function TGuild.CancelGuld(sHumName: string): Boolean;
var
  GuildRank: pTGuildRank;
begin
  Result := False;
  if m_RankList.Count <> 1 then Exit;
  GuildRank := m_RankList.Items[0];
  if GuildRank.MemberList.Count <> 1 then Exit;
  if GuildRank.MemberList.Strings[0] = sHumName then begin
    BackupGuildFile();
    Result := True;
  end;
end;

function TGuild.UpdateRank(sRankData: string): Integer;
  procedure ClearRankList(var RankList: TList);
  var
    I: Integer;
    GuildRank: pTGuildRank;
  begin
    for I := 0 to RankList.Count - 1 do begin
      GuildRank := RankList.Items[I];
      GuildRank.MemberList.Free;
      Dispose(GuildRank);
    end;
    RankList.Free;
  end;
var
  I: Integer;
  II: Integer;
  III: Integer;
  GuildRankList: TList;
  GuildRank: pTGuildRank;
  NewGuildRank: pTGuildRank;
  sRankInfo: string;
  sRankNo: string;
  sRankName: string;
  sMemberName: string;
  n28: Integer;
  n2C: Integer;
  n30: Integer;
  n3C: Integer;
  boCheckChange: Boolean;
  PlayObject: TPlayObject;
begin
  Result := -1;
  GuildRankList := TList.Create;
  GuildRank := nil;
  while (True) do begin
    if sRankData = '' then break;
    sRankData := GetValidStr3(sRankData, sRankInfo, [#$0D]);
    sRankInfo := Trim(sRankInfo);
    if sRankInfo = '' then Continue;
    if sRankInfo[1] = '#' then begin //取得职称的名称
      sRankInfo := Copy(sRankInfo, 2, Length(sRankInfo) - 1);
      sRankInfo := GetValidStr3(sRankInfo, sRankNo, [' ', '<']);
      sRankInfo := GetValidStr3(sRankInfo, sRankName, ['<', '>']);
      if Length(sRankName) > 30 then //Jacky 限制职称的长度
        sRankName := Copy(sRankName, 1, 30);
      if GuildRank <> nil then begin
        GuildRankList.Add(GuildRank);
      end;
      New(GuildRank);
      GuildRank.nRankNo := Str_ToInt(sRankNo, 99);
      GuildRank.sRankName := Trim(sRankName);
      GuildRank.MemberList := TStringList.Create;
      Continue;
    end;

    if GuildRank = nil then Continue;
    I := 0;
    while (True) do begin //将成员名称加入职称表里
      if sRankInfo = '' then break;
      sRankInfo := GetValidStr3(sRankInfo, sMemberName, [' ', ',']);
      if sMemberName <> '' then GuildRank.MemberList.Add(sMemberName);
      Inc(I);
      if I > g_Config.nGuildMemberMaxLimit then break; //限制成员数量
    end;
  end;

  if GuildRank <> nil then begin
    GuildRankList.Add(GuildRank);
  end;

  //校验成员列表是否有改变，如果未修改则退出
  boCheckChange := False;
  if m_RankList.Count = GuildRankList.Count then begin
    boCheckChange := True;
    for I := 0 to m_RankList.Count - 1 do begin
      GuildRank := m_RankList.Items[I];
      NewGuildRank := GuildRankList.Items[I];
      if (GuildRank.nRankNo = NewGuildRank.nRankNo) and
        (GuildRank.sRankName = NewGuildRank.sRankName) and
        (GuildRank.MemberList.Count = NewGuildRank.MemberList.Count) then begin
        for II := 0 to GuildRank.MemberList.Count - 1 do begin
          if GuildRank.MemberList.Strings[II] <> NewGuildRank.MemberList.Strings[II] then begin
            boCheckChange := False; //如果有改变则将其置为FALSE
            break;
          end;
        end;
      end else begin
        boCheckChange := False;
        break;
      end;
    end;
    if boCheckChange then begin
      Result := -1;
      ClearRankList(GuildRankList);
      Exit;
    end;
  end;

  //检查行会掌门职业是否为空
  Result := -2;
  if (GuildRankList.Count > 0) then begin
    GuildRank := GuildRankList.Items[0];
    if GuildRank.nRankNo = 1 then begin
      if GuildRank.sRankName <> '' then begin
        Result := 0;
      end else begin
        Result := -3;
      end;
    end;
  end;

  //检查行会掌门人是否在线(？？？)
  if Result = 0 then begin //0049947A
    GuildRank := GuildRankList.Items[0];
    if GuildRank.MemberList.Count <= 2 then begin
      n28 := GuildRank.MemberList.Count;
      for I := 0 to GuildRank.MemberList.Count - 1 do begin
        if UserEngine.GetPlayObject(GuildRank.MemberList.Strings[I]) = nil then begin
          Dec(n28);
          break;
        end;
      end;
      if n28 <= 0 then Result := -5;
    end else begin
      Result := -4;
    end;
  end;

  if g_Config.boCheckGuild then begin
    if Result = 0 then begin
      n2C := 0;
      n30 := 0;
      for I := 0 to m_RankList.Count - 1 do begin
        GuildRank := m_RankList.Items[I];
        boCheckChange := True;
        for II := 0 to GuildRank.MemberList.Count - 1 do begin
          boCheckChange := False;
          sMemberName := GuildRank.MemberList.Strings[II];
          Inc(n2C);
          for III := 0 to GuildRankList.Count - 1 do begin //搜索新列表
            NewGuildRank := GuildRankList.Items[III];
            for n28 := 0 to NewGuildRank.MemberList.Count - 1 do begin
              if NewGuildRank.MemberList.Strings[n28] = sMemberName then begin
                boCheckChange := True;
                break;
              end;
            end;
            if boCheckChange then break;
          end;

          if not boCheckChange then begin //原列表中的人物名称是否在新的列表中
            Result := -6;
            break;
          end;
        end;
        if not boCheckChange then break;
      end;

      for I := 0 to GuildRankList.Count - 1 do begin
        GuildRank := GuildRankList.Items[I];
        boCheckChange := True;
        for II := 0 to GuildRank.MemberList.Count - 1 do begin
          boCheckChange := False;
          sMemberName := GuildRank.MemberList.Strings[II];
          Inc(n30);
          for III := 0 to GuildRankList.Count - 1 do begin
            NewGuildRank := GuildRankList.Items[III];
            for n28 := 0 to NewGuildRank.MemberList.Count - 1 do begin
              if NewGuildRank.MemberList.Strings[n28] = sMemberName then begin
                boCheckChange := True;
                break;
              end;
            end;
            if boCheckChange then break;
          end;
          if not boCheckChange then begin
            Result := -6;
            break;
          end;
        end;
        if not boCheckChange then break;
      end;
      if (Result = 0) and (n2C <> n30) then begin
        Result := -6;
      end;
    end;
  end;

  if Result = 0 then begin //检查掌门数量
    n3C := 0;
    for I := 0 to GuildRankList.Count - 1 do begin
      n28 := pTGuildRank(GuildRankList.Items[I]).nRankNo;
      if n28 = 1 then begin
        Inc(n3C);
        if n3C > 2 then begin
          Result := -4;
          break;
        end;
      end;
    end;
  end;

  if Result = 0 then begin //检查职位号是否重复及非法
    for I := 0 to GuildRankList.Count - 1 do begin
      n28 := pTGuildRank(GuildRankList.Items[I]).nRankNo;
      if n28 <> 1 then begin
        for III := I + 1 to GuildRankList.Count - 1 do begin
          if (pTGuildRank(GuildRankList.Items[III]).nRankNo = n28) or (n28 <= 0) or (n28 > 99) then begin
            Result := -7;
            break;
          end;
        end;
      end;
      if Result <> 0 then break;
    end;
  end;

  if Result = 0 then begin
    ClearRankList(m_RankList);
    m_RankList := GuildRankList;
    //更新在线人物职位表
    for I := 0 to m_RankList.Count - 1 do begin
      GuildRank := m_RankList.Items[I];
      for III := 0 to GuildRank.MemberList.Count - 1 do begin
        PlayObject := UserEngine.GetPlayObject(GuildRank.MemberList.Strings[III]);
        if PlayObject <> nil then begin
          GuildRank.MemberList.Objects[III] := TObject(PlayObject);
          PlayObject.RefRankInfo(GuildRank.nRankNo, GuildRank.sRankName);
          PlayObject.RefShowName(); //10/31
        end;
      end;
    end;
    UpdateGuildFile();
  end else begin
    ClearRankList(GuildRankList);
  end;
end;

function TGuild.IsNotWarGuild(Guild: TGuild): Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 0 to GuildWarList.Count - 1 do begin
    if pTWarGuild(GuildWarList.Objects[I]).Guild = Guild then begin
      Exit;
    end;
  end;
  Result := True;
end;

function TGuild.AllyGuild(Guild: TGuild): Boolean; //00499C2C
var
  I: Integer;
begin
  Result := False;
  for I := 0 to GuildAllList.Count - 1 do begin
    if GuildAllList.Objects[I] = Guild then begin
      Exit;
    end;
  end;
  GuildAllList.AddObject(Guild.sGuildName, Guild);
  SaveGuildInfoFile();
  Result := True;
end;

function TGuild.AddWarGuild(Guild: TGuild): pTWarGuild;
var
  I: Integer;
  WarGuild: pTWarGuild;
begin
  Result := nil;
  if Guild <> nil then begin
    if not IsAllyGuild(Guild) then begin
      WarGuild := nil;
      for I := 0 to GuildWarList.Count - 1 do begin
        if pTWarGuild(GuildWarList.Objects[I]).Guild = Guild then begin
          WarGuild := pTWarGuild(GuildWarList.Objects[I]);
          WarGuild.dwWarTick := GetTickCount();
          WarGuild.dwWarTime := g_Config.dwGuildWarTime {10800000};
          SendGuildMsg('***' + Guild.sGuildName + '行会战争将持续三个小时。');
          break;
        end;
      end;
      if WarGuild = nil then begin
        New(WarGuild);
        WarGuild.Guild := Guild;
        WarGuild.dwWarTick := GetTickCount();
        WarGuild.dwWarTime := g_Config.dwGuildWarTime {10800000};
        GuildWarList.AddObject(Guild.sGuildName, TObject(WarGuild));
        SendGuildMsg('***' + Guild.sGuildName + '行会战争开始(三个小时)');
      end;
      Result := WarGuild;
    end;
  end;
  RefMemberName();
  UpdateGuildFile();
end;

procedure TGuild.sub_499B4C(Guild: TGuild); //00499B4C
begin
  SendGuildMsg('***' + Guild.sGuildName + '行会战争结束');
end;

function TGuild.GetMemberCount: Integer;
var
  I: Integer;
  GuildRank: pTGuildRank;
begin
  Result := 0;
  for I := 0 to m_RankList.Count - 1 do begin
    GuildRank := m_RankList.Items[I];
    Inc(Result, GuildRank.MemberList.Count);
  end;
end;

function TGuild.GetMemgerIsFull: Boolean;
begin
  Result := False;
  if GetMemberCount >= g_Config.nGuildMemberMaxLimit then begin
    Result := True;
  end;
end;

procedure TGuild.StartTeamFight;
begin
  nContestPoint := 0;
  boTeamFight := True;
  TeamFightDeadList.Clear;
end;

procedure TGuild.EndTeamFight;
begin
  boTeamFight := False;
end;

procedure TGuild.AddTeamFightMember(sHumanName: string);
begin
  TeamFightDeadList.Add(sHumanName);
end;


procedure TGuild.SetAuraePoint(nPoint: Integer);
begin
  m_nAurae := nPoint;
  boChanged := True;
end;

procedure TGuild.SetBuildPoint(nPoint: Integer);
begin
  m_nBuildPoint := nPoint;
  boChanged := True;
end;

procedure TGuild.SetFlourishPoint(nPoint: Integer);
begin
  m_nFlourishing := nPoint;
  boChanged := True;
end;

procedure TGuild.SetStabilityPoint(nPoint: Integer);
begin
  m_nStability := nPoint;
  boChanged := True;
end;
procedure TGuild.SetChiefItemCount(nPoint: Integer);
begin
  m_nChiefItemCount := nPoint;
  boChanged := True;
end;

end.


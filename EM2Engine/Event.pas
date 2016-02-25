unit Event;

interface

uses
  Windows, Classes, SysUtils, SyncObjs, ObjBase, Envir, Grobal2, SDK;
type
  TEvent = class;

  pTMagicEvent = ^TMagicEvent;
  TMagicEvent = record
    BaseObjectList: TList;
    dwStartTick: DWord;
    dwTime: DWord;
    Events: array[0..7] of TEvent;
  end;

  TEvent = class
    nVisibleFlag: Integer;
    m_Envir: TEnvirnoment;
    m_nX: Integer;
    m_nY: Integer;
    m_nEventType: Integer;
    m_nEventParam: Integer;
    m_dwOpenStartTick: LongWord;
    m_dwContinueTime: LongWord; //  显示时间长度
    m_dwCloseTick: LongWord;
    m_boClosed: Boolean;
    m_nDamage: Integer;
    m_OwnBaseObject: TBaseObject;
    m_dwRunStart: LongWord;
    m_dwRunTick: LongWord;
    m_boVisible: Boolean;
    m_boActive: Boolean;
  public
    constructor Create(tEnvir: TEnvirnoment; ntX, ntY, nType, dwETime: Integer; boVisible: Boolean);
    destructor Destroy; override;
    procedure Run(); virtual;
    procedure Close();
  end;
  TStoneMineEvent = class(TEvent)
    m_nMineCount: Integer;
    m_nAddStoneCount: Integer;
    m_dwAddStoneMineTick: LongWord;
  public
    constructor Create(Envir: TEnvirnoment; nX, nY: Integer; nType: Integer);
    destructor Destroy; override;
    procedure AddStoneMine();
  end;
  TPileStones = class(TEvent)
  public
    constructor Create(Envir: TEnvirnoment; nX, nY: Integer; nType, nTime: Integer);
    destructor Destroy; override;
    procedure AddEventParam();
  end;
  THolyCurtainEvent = class(TEvent)
  public
    constructor Create(Envir: TEnvirnoment; nX, nY: Integer; nType, nTime: Integer);
    destructor Destroy; override;
  end;
  TFireBurnEvent = class(TEvent)
    m_dwRunTick: LongWord;
  public
    constructor Create(Creat: TBaseObject; nX, nY: Integer; nType: Integer; nTime, nDamage: Integer);
    destructor Destroy; override;
    procedure Run(); override;
  end;
  TSafeEvent = class(TEvent) //安全区光环
  public
    constructor Create(Envir: TEnvirnoment; nX, nY: Integer; nType: Integer);
    destructor Destroy; override;
    procedure Run(); override;
  end;


  //==============================================================================
  TEventManager = class
    m_EventList: TGList;
    m_ClosedEventList: TGList;
  public
    constructor Create();
    destructor Destroy; override;
    function GetEvent(Envir: TEnvirnoment; nX, nY: Integer; nType: Integer): TEvent;
    procedure AddEvent(Event: TEvent);
    procedure Run();
  end;
implementation

uses M2Share;

{ TStoneMineEvent }

constructor TStoneMineEvent.Create(Envir: TEnvirnoment; nX, nY,
  nType: Integer);
begin
  inherited Create(Envir, nX, nY, nType, 0, False);
  m_Envir.AddToMapMineEvent(nX, nY, OS_EVENTOBJECT, Self);
  m_boVisible := False;
  m_nMineCount := Random(200);
  m_dwAddStoneMineTick := GetTickCount();
  m_boActive := False;
  m_nAddStoneCount := Random(80);
end;

destructor TStoneMineEvent.Destroy;
begin

  inherited;
end;
{ TEventManager }
procedure TEventManager.Run;
var
  i: Integer;
  Event: TEvent;
begin
  m_EventList.Lock;
  try
    for i := m_EventList.Count - 1 downto 0 do begin
      Event := TEvent(m_EventList.Items[i]);
      if Event.m_boActive and ((GetTickCount - Event.m_dwRunStart) > Event.m_dwRunTick) then begin
        Event.m_dwRunStart := GetTickcount();
        Event.Run();
        if Event.m_boClosed then begin
          m_ClosedEventList.Lock;
          try
            m_ClosedEventList.Add(Event);
          finally
            m_ClosedEventList.UnLock;
          end;
          m_EventList.Delete(i);
        end;
      end;
    end;
  finally
    m_EventList.UnLock;
  end;

  m_ClosedEventList.Lock;
  try
    for i := m_ClosedEventList.Count - 1 downto 0 do begin
      Event := TEvent(m_ClosedEventList.Items[i]);
      if (GetTickCount - Event.m_dwCloseTick) > 5 * 60 * 1000 then begin
        m_ClosedEventList.Delete(i);
        Event.Free;
      end;
    end;
  finally
    m_ClosedEventList.UnLock;
  end;
end;

function TEventManager.GetEvent(Envir: TEnvirnoment; nX, nY,
  nType: Integer): TEvent;
var
  I: Integer;
  Event: TEvent;
begin
  Result := nil;
  m_EventList.Lock;
  try
    for I := 0 to m_EventList.Count - 1 do begin
      Event := TEvent(m_EventList.Items[i]);
      if (Event.m_Envir = Envir) and
        (Event.m_nX = nX) and
        (Event.m_nY = nY) and
        (Event.m_nEventType = nType) then begin
        Result := Event;
        break;
      end;
    end;
  finally
    m_EventList.UnLock;
  end;
end;

procedure TEventManager.AddEvent(Event: TEvent);
begin
  m_EventList.Lock;
  try
    m_EventList.Add(Event);
  finally
    m_EventList.UnLock;
  end;
end;

constructor TEventManager.Create();
begin
  m_EventList := TGList.Create;
  m_ClosedEventList := TGList.Create;
end;

destructor TEventManager.Destroy;
var
  I: Integer;
begin
  for I := 0 to m_EventList.Count - 1 do begin
    TEvent(m_EventList.Items[i]).Free;
  end;
  m_EventList.Free;
  for I := 0 to m_ClosedEventList.Count - 1 do begin
    TEvent(m_ClosedEventList.Items[i]).Free;
  end;
  m_ClosedEventList.Free;
  inherited;
end;

{ THolyCurtainEvent }

constructor THolyCurtainEvent.Create(Envir: TEnvirnoment; nX, nY, nType, nTime: Integer);
begin
  inherited Create(Envir, nX, nY, nType, nTime, True);
end;

destructor THolyCurtainEvent.Destroy;
begin

  inherited;
end;
{ TSafeEvent 安全区光环}

constructor TSafeEvent.Create(Envir: TEnvirnoment; nX, nY: Integer; nType: Integer);
begin
  inherited Create(Envir, nX, nY, nType, GetTickCount, True);
end;

destructor TSafeEvent.Destroy;
begin

  inherited;
end;

procedure TSafeEvent.Run();
begin
  m_dwOpenStartTick := GetTickCount();
  inherited;
end;
{ TFireBurnEvent }

constructor TFireBurnEvent.Create(Creat: TBaseObject; nX, nY, nType, nTime, nDamage: Integer);
begin
  inherited Create(Creat.m_PEnvir, nX, nY, nType, nTime, True);
  m_nDamage := nDamage;
  m_OwnBaseObject := Creat;
end;

destructor TFireBurnEvent.Destroy;
begin

  inherited;
end;

procedure TFireBurnEvent.Run;
var
  I: Integer;
  BaseObjectList: TList;
  TargeTBaseObject: TBaseObject;
begin
  if (GetTickCount - m_dwRunTick) > 3000 then begin
    m_dwRunTick := GetTickCount();
    BaseObjectList := TList.Create;
    if m_Envir <> nil then begin
      m_Envir.GeTBaseObjects(m_nX, m_nY, True, BaseObjectList);
      for I := 0 to BaseObjectList.Count - 1 do begin
        TargeTBaseObject := TBaseObject(BaseObjectList.Items[i]);
        if (TargeTBaseObject <> nil) and (m_OwnBaseObject <> nil) and (m_OwnBaseObject.IsProperTarget(TargeTBaseObject)) then begin
          TargeTBaseObject.SendMsg(m_OwnBaseObject, RM_MAGSTRUCK_MINE, 0, m_nDamage, 0, 0, '');
        end;
      end;
    end;
    BaseObjectList.Free;
  end;
  inherited;
end;

{ TEvent }

constructor TEvent.Create(tEnvir: TEnvirnoment; ntX, ntY, nType, dwETime: Integer; boVisible: Boolean);
begin
  m_dwOpenStartTick := GetTickCount();
  m_nEventType := nType;
  m_nEventParam := 0;
  m_dwContinueTime := dwETime;
  m_boVisible := boVisible;
  m_boClosed := False;
  m_Envir := tEnvir;
  m_nX := ntX;
  m_nY := ntY;
  m_boActive := True;
  m_nDamage := 0;
  m_OwnBaseObject := nil;
  m_dwRunStart := GetTickCount();
  m_dwRunTick := 500;
  if (m_Envir <> nil) and (m_boVisible) then begin
    m_Envir.AddToMap(m_nX, m_nY, OS_EVENTOBJECT, Self);
  end else m_boVisible := False;
  //EventCheck.Add(Self);
end;

destructor TEvent.Destroy;
var
  I: integer;
begin
  {
  for I := 0 to EventCheck.Count - 1 do begin
    if EventCheck.Items[I] = Self then begin
      EventCheck.Delete(I);
      break;
    end;
  end;
  }
  inherited;
end;

procedure TEvent.Run;
begin
  if (GetTickCount - m_dwOpenStartTick) > m_dwContinueTime then begin
    m_boClosed := True;
    Close();
  end;
  if (not m_boClosed) and (m_OwnBaseObject <> nil) and (m_OwnBaseObject.m_btRaceServer = RC_PLAYOBJECT) and (m_nEventType = ET_FIRE) and g_Config.boChangeMapFireExtinguish then begin
    if(m_OwnBaseObject.m_PEnvir = nil) or (m_Envir = nil) or (m_OwnBaseObject.m_PEnvir <> m_Envir) or (m_OwnBaseObject.m_PEnvir.sMapName <> m_Envir.sMapName) then begin //2006-11-12 火墙换地图消失
      m_boClosed := True;
      Close();
      m_OwnBaseObject := nil;
    end;
  end else
    if (m_OwnBaseObject <> nil) and (m_OwnBaseObject.m_boGhost or (m_OwnBaseObject.m_boDeath)) then begin
    m_OwnBaseObject := nil;
  end;
end;

procedure TEvent.Close;
begin
  m_dwCloseTick := GetTickCount();
  if m_boVisible then begin
    m_boVisible := False;
    if m_Envir <> nil then begin
      m_Envir.DeleteFromMap(m_nX, m_nY, OS_EVENTOBJECT, Self);
    end;
    m_Envir := nil;
  end;
end;


{ TPileStones }

constructor TPileStones.Create(Envir: TEnvirnoment; nX, nY, nType,
  nTime: Integer);
begin
  inherited Create(Envir, nX, nY, nType, nTime, True);
  m_nEventParam := 1;
end;

destructor TPileStones.Destroy;
begin

  inherited;
end;

procedure TPileStones.AddEventParam;
begin
  if m_nEventParam < 5 then Inc(m_nEventParam);
end;

procedure TStoneMineEvent.AddStoneMine;
begin
  m_nMineCount := m_nAddStoneCount;
  m_dwAddStoneMineTick := GetTickCount();
end;

end.


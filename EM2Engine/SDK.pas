unit SDK;

interface
uses
  Windows, SysUtils, Classes, Grobal2, Forms;
const
  MAXPULGCOUNT = 20;
type
  TProcArrayInfo = record
    sProcName: string;
    nProcAddr: Pointer;
    nCheckCode: Integer;
    sCheckCode: string;
  end;

  TObjectArrayInfo = record
    Obj: TObject;
    sObjcName: string;
    nCheckCode: Integer;
    sCheckCode: string;
  end;

  TProcArray = array[0..MAXPULGCOUNT - 1] of TProcArrayInfo;
  TObjectArray = array[0..MAXPULGCOUNT - 1] of TObjectArrayInfo;

  TMsgProc = procedure(Msg: PChar; nMsgLen: Integer; nMode: Integer); stdcall;
  TFindProc = function(ProcName: PChar; nNameLen: Integer): Pointer; stdcall;
  TSetProc = function(ProcAddr: Pointer; ProcName: PChar; nNameLen: Integer): Boolean; stdcall;
  TFindObj = function(ObjName: PChar; nNameLen: Integer): TObject; stdcall;
  TStartPlug = function(): Boolean; stdcall;
  TSetStartPlug = function(StartPlug: TStartPlug): Boolean; stdcall;

  TPlugInit = function(AppHandle: HWnd; MsgProc: TMsgProc; FindProc: TFindProc; SetProc: TSetProc; FindOBj: TFindObj): PChar; stdcall;
  TClassProc = procedure(Sender: TObject);
  TStartProc = procedure(); stdcall;
  TStartRegister = function(sRegisterInfo, sUserName: PChar): Integer; stdcall;
  TGetStrProc = procedure(sRegisterCode: PChar); stdcall;
  TGameDataLog = function(ProcName: PChar; nNameLen: Integer): Boolean; stdcall;
  TIPLocal = procedure(sIPaddr: PChar; sLocal: PChar; nLocalLen: Integer); stdcall;
  TDeCryptString = procedure(Src, Dest: PChar; nSrc: Integer; var nDest: Integer); stdcall;

  {===================================TGList===================================}

  TGList = class(TList)
  private
    CriticalSection: TRTLCriticalSection;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Lock;
    procedure UnLock;
  end;

  {=================================TGStringList================================}
  TGStringList = class(TStringList)
  private
    CriticalSection: TRTLCriticalSection;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Lock;
    procedure UnLock;
  end;

  TSellOffGoodList = class
  private
    FRecCount: Cardinal;
    FUpDateSellOff: Boolean;
    m_nChangeCount: Integer;
    m_SellOffGoodList: TGList;
  public
    constructor Create;
    destructor Destroy; override;
    procedure LoadSellOffGoodList();
    procedure UnLoadSellOffGoodList();
    procedure GetSellOffGoodList(var SellOffList: TList);
    procedure GetUserSellOffGoodListByChrName(sChrName: string; var SellOffList: TList);
    procedure GetUserSellOffGoodListByItemName(sItemName: string; var SellOffList: TList);
    procedure GetUserSellOffGoodListByMakeIndex(nMakeIndex: Integer; var SellOffInfo: pTSellOffInfo);
    procedure GetUserSellOffItem(sItemName: string; nMakeIndex: Integer; var SellOffInfo: pTSellOffInfo; var StdItem: pTStdItem);
    function GetUserSellOffCount(sCharName: string): Integer;
    function GetUserLimitSellOffCount(sCharName: string): Boolean;
    procedure GetUserSellOffListByIndex(nIndex: Integer; var SellOffList: TList);
    function AddItemToSellOffGoodsList(SellOffInfo: pTSellOffInfo): Boolean;
    function DelSellOffItem(nMakeIndex: Integer): Boolean;
    function SaveSellOffGoodList(): Boolean;
  published
    property RecCount: Cardinal read FRecCount write FRecCount;
    property UpDateSellOff: Boolean read FUpDateSellOff write FUpDateSellOff;
  end;

  TSellOffGoldList = class
  private
    FRecCount: Cardinal;
    FUpDateSellOff: Boolean;
    m_nChangeCount: Integer;
    m_SellOffGoldList: TGList;
  public
    constructor Create;
    destructor Destroy; override;
    procedure LoadSellOffGoldList();
    procedure UnLoadSellOffGoldList();
    procedure GetUserSellOffGoldListByChrName(sChrName: string; var SellOffList: TList);
    function AddItemToSellOffGoldList(SellOffInfo: pTSellOffInfo): Boolean;
    function DelSellOffGoldItem(nMakeIndex: Integer): Boolean;
    function SaveSellOffGoldList(): Boolean;
  published
    property RecCount: Cardinal read FRecCount write FRecCount;
    property UpDateSellOff: Boolean read FUpDateSellOff write FUpDateSellOff;
  end;

  //==============================================================================
  //TStartStorageProc = procedure(BigStorageList: TBigStorageList);
  TBigStorageList = class
  private
    FRecordCount: Cardinal;
    FHumManCount: Cardinal;
    FPosition: Cardinal;
    FUpDate: Boolean;
    FStopLoad: Boolean;
    m_nChangeCount: Integer;
  public
    m_BigStorageList: TGList;
    FOnLoadStorage: procedure();
    FOnBeginLoadStorage: procedure();
    FOnEndLoadStorage: procedure();
    FOnLoadPro: Boolean;
    constructor Create;
    destructor Destroy; override;
    procedure LoadBigStorageList(); overload;
    procedure LoadBigStorageList(sFileName: string); overload;
    procedure UnLoadBigStorageList();
    function GetUserBigStorageList(var StorageList: TList): Boolean;
    function GetUserStorageListByChrName(sChrName: string; var StorageList: TList): Boolean;
    function GetUserStorageListByItemName(sItemName: string; var StorageList: TList): Boolean;
    function GetUserStorageListByMakeIndex(sChrName, sItemName: string; nMakeIndex: Integer; var UserItem: pTUserItem): Boolean;
    function AddItemToUserBigStorageList(sChrName: string; UserItem: pTUserItem): Boolean;
    function GetUserStorageCount(sChrName: string): Integer;
    function DelBigStorageItem(sChrName, sItemName: string; nMakeIndex: Integer): Boolean;
    function SaveStorageList(): Boolean; overload;
    function SaveStorageList(sFileName: string): Boolean; overload;
    function ClearRec(): Boolean;
  published
    property RecordCount: Cardinal read FRecordCount write FRecordCount;
    property HumManCount: Cardinal read FHumManCount write FHumManCount;
    property Position: Cardinal read FPosition;
    property UpDate: Boolean read FUpDate write FUpDate;
    property StopLoad: Boolean read FStopLoad write FStopLoad;
  end;

implementation
uses ItmUnit, UsrEngn, M2Share;
{ TGList }

constructor TGList.Create;
begin
  inherited;
  InitializeCriticalSection(CriticalSection);
end;

destructor TGList.Destroy;
begin
  DeleteCriticalSection(CriticalSection);
  inherited;
end;

procedure TGList.Lock;
begin
  EnterCriticalSection(CriticalSection);
end;

procedure TGList.UnLock;
begin
  LeaveCriticalSection(CriticalSection);
end;

{ TGStringList }

constructor TGStringList.Create;
begin
  inherited;
  InitializeCriticalSection(CriticalSection);
end;

destructor TGStringList.Destroy;
begin
  DeleteCriticalSection(CriticalSection);
  inherited;
end;

procedure TGStringList.Lock;
begin
  EnterCriticalSection(CriticalSection);
end;

procedure TGStringList.UnLock;
begin
  LeaveCriticalSection(CriticalSection);
end;

{BigStorageList}
constructor TBigStorageList.Create;
begin
  inherited Create;
  FRecordCount := 0;
  FHumManCount := 0;
  FUpDate := False;
  m_nChangeCount := 0;
  FPosition := 0;
  FStopLoad := False;
  FOnLoadStorage := nil;
  FOnBeginLoadStorage := nil;
  FOnEndLoadStorage := nil;
  FOnLoadPro := False;
  m_BigStorageList := TGList.Create;
end;

destructor TBigStorageList.Destroy;
begin
  UnLoadBigStorageList();
  inherited;
end;

procedure TBigStorageList.LoadBigStorageList();
var
  i: Integer;
  sFileName: string;
  FileHandle: Integer;
  List: TList;
  BigStorage: pTBigStorage;
  nItemCount: TItemCount;
begin
  m_BigStorageList.Lock();
  try
    sFileName := g_Config.sEnvirDir + '\Market_Storage\';
    if not DirectoryExists(sFileName) then begin
      ForceDirectories(sFileName);
    end;
    sFileName := sFileName + 'UserStorage.db';
    if FileExists(sFileName) then begin
      FileHandle := FileOpen(sFileName, fmOpenRead or fmShareDenyNone);
      List := nil;
      if FileHandle > 0 then begin
        if FileRead(FileHandle, nItemCount, SizeOf(TItemCount)) = SizeOf(TItemCount) then begin
          FRecordCount := nItemCount;
          for i := 0 to nItemCount - 1 do begin
            New(BigStorage);
            FillChar(BigStorage.UseItems, SizeOf(TUserItem), #0);
            if (FileRead(FileHandle, BigStorage^, SizeOf(TBigStorage)) = SizeOf(TBigStorage)) and (not BigStorage.boDelete) and (BigStorage.UseItems.wIndex > 0) then begin
              if List = nil then begin
                List := TList.Create;
                List.Add(BigStorage);
              end else begin
                if (List.Count > 0) and (CompareText(pTBigStorage(List.Items[0]).sCharName, BigStorage.sCharName) = 0) then begin
                  List.Add(BigStorage);
                end else begin
                  m_BigStorageList.Add(List);
                  List := TList.Create;
                  List.Add(BigStorage);
                end;
              end;
            end else begin
              DisPose(BigStorage);
            end;
          end;
          if List <> nil then
            m_BigStorageList.Add(List);
          FileClose(FileHandle);
        end;
      end;
    end else begin
      FileHandle := FileCreate(sFileName);
      if FileHandle > 0 then begin
        nItemCount := 0;
        FileWrite(FileHandle, nItemCount, SizeOf(TItemCount));
        FileClose(FileHandle);
      end;
    end;
    FHumManCount := m_BigStorageList.Count;
  finally
    m_BigStorageList.UnLock();
  end;
  //MainOutMessage('LoadSellGoodRecord: '+IntToStr(Self.Count));
end;

procedure TBigStorageList.LoadBigStorageList(sFileName: string);
var
  i: Integer;
  FileHandle: Integer;
  List: TList;
  BigStorage: pTBigStorage;
  nItemCount: TItemCount;
begin
  m_BigStorageList.Lock();
  try
    if FileExists(sFileName) then begin
      FileHandle := FileOpen(sFileName, fmOpenRead or fmShareDenyNone);
      List := nil;
      if FileHandle > 0 then begin
        if FileRead(FileHandle, nItemCount, SizeOf(TItemCount)) = SizeOf(TItemCount) then begin
          FRecordCount := nItemCount;
          if Assigned(FOnBeginLoadStorage) then begin
            FOnBeginLoadStorage();
          end;
          for i := 0 to nItemCount - 1 do begin
            Application.ProcessMessages;
            FPosition := i;
            if FStopLoad then break;
            if Assigned(FOnLoadStorage) then begin
              FOnLoadStorage();
            end;
            New(BigStorage);
            FillChar(BigStorage.UseItems, SizeOf(TUserItem), #0);
            if (FileRead(FileHandle, BigStorage^, SizeOf(TBigStorage)) = SizeOf(TBigStorage)) and (not BigStorage.boDelete) and (BigStorage.UseItems.wIndex > 0) then begin
              if List = nil then begin
                List := TList.Create;
                List.Add(BigStorage);
              end else begin
                if (List.Count > 0) and (CompareText(pTBigStorage(List.Items[0]).sCharName, BigStorage.sCharName) = 0) then begin
                  List.Add(BigStorage);
                end else begin
                  m_BigStorageList.Add(List);
                  List := TList.Create;
                  List.Add(BigStorage);
                end;
              end;
            end else begin
              DisPose(BigStorage);
            end;
          end;
          if List <> nil then
            m_BigStorageList.Add(List);
          FileClose(FileHandle);
        end;
      end;
    end else begin
      FileHandle := FileCreate(sFileName);
      if FileHandle > 0 then begin
        nItemCount := 0;
        FileWrite(FileHandle, nItemCount, SizeOf(TItemCount));
        FileClose(FileHandle);
      end;
    end;
    FHumManCount := m_BigStorageList.Count;
  finally
    m_BigStorageList.UnLock();
    if Assigned(FOnEndLoadStorage) then begin
      FOnEndLoadStorage();
    end;
  end;
  //MainOutMessage('LoadSellGoodRecord: '+IntToStr(Self.Count));
end;

procedure TBigStorageList.UnLoadBigStorageList();
var
  i, ii: Integer;
  List: TList;
  BigStorage: pTBigStorage;
begin
  m_BigStorageList.Lock();
  try
    for i := 0 to m_BigStorageList.Count - 1 do begin
      if m_BigStorageList.Count <= 0 then break;
      List := TList(m_BigStorageList.Items[i]);
      if List <> nil then begin
        for ii := 0 to List.Count - 1 do begin
          BigStorage := pTBigStorage(List.Items[ii]);
          DisPose(BigStorage);
        end;
        List.Free;
      end;
    end;
  finally
    m_BigStorageList.UnLock();
  end;
  m_BigStorageList.Free;
end;

function TBigStorageList.GetUserBigStorageList(var StorageList: TList): Boolean;
begin

end;
function TBigStorageList.GetUserStorageListByChrName(sChrName: string; var StorageList: TList): Boolean;
var
  i, ii: Integer;
  List: TList;
  BigStorage: pTBigStorage;
begin
  Result := False;
  m_BigStorageList.Lock();
  try
    StorageList := nil;
    if FOnLoadPro then begin
      FRecordCount := m_BigStorageList.Count;
      if Assigned(FOnBeginLoadStorage) then begin
        FOnBeginLoadStorage();
      end;
    end;
    for i := 0 to m_BigStorageList.Count - 1 do begin
      if m_BigStorageList.Count <= 0 then break;

      if FOnLoadPro then begin
        Application.ProcessMessages;
        FPosition := i;
        if FStopLoad then break;
        if Assigned(FOnLoadStorage) then begin
          FOnLoadStorage();
        end;
      end;

      List := TList(m_BigStorageList.Items[i]);
      if (List <> nil) and (List.Count > 0) then begin
        BigStorage := pTBigStorage(List.Items[0]);
        if CompareText(BigStorage.sCharName, sChrName) = 0 then begin
          StorageList := List;
          Result := TRUE;
          break;
        end;
      end;
    end;

    if FOnLoadPro then begin
      if Assigned(FOnEndLoadStorage) then begin
        FOnEndLoadStorage();
      end;
    end;
  finally
    m_BigStorageList.UnLock();
  end;
end;

function TBigStorageList.GetUserStorageListByItemName(sItemName: string; var StorageList: TList): Boolean;
var
  i, ii, nIndex: Integer;
  List: TList;
  BigStorage: pTBigStorage;
  sItem: string;
begin
  Result := False;
  m_BigStorageList.Lock();
  try
    nIndex := 0;
    if FOnLoadPro then begin
      FRecordCount := m_BigStorageList.Count;
      if Assigned(FOnBeginLoadStorage) then begin
        FOnBeginLoadStorage();
      end;
    end;
    for i := 0 to m_BigStorageList.Count - 1 do begin
      if m_BigStorageList.Count <= 0 then break;
      List := TList(m_BigStorageList.Items[i]);
      if (List <> nil) and (List.Count > 0) then begin
        for ii := 0 to List.Count - 1 do begin
          if FOnLoadPro then begin
            Application.ProcessMessages;
            FPosition := nIndex;
            if FStopLoad then break;
            if Assigned(FOnLoadStorage) then begin
              FOnLoadStorage();
            end;
          end;
          BigStorage := pTBigStorage(List.Items[ii]);
          sItem := UserEngine.GetStdItemName(BigStorage.UseItems.wIndex);
          if CompareText(sItem, sItemName) = 0 then begin
            StorageList.Add(BigStorage);
            Inc(nIndex);
            Result := TRUE;
          end;
        end;
      end;
    end;
    if FOnLoadPro then begin
      if Assigned(FOnEndLoadStorage) then begin
        FOnEndLoadStorage();
      end;
    end;
  finally
    m_BigStorageList.UnLock();
  end;
end;

function TBigStorageList.GetUserStorageCount(sChrName: string): Integer;
var
  i, ii: Integer;
  List: TList;
  BigStorage: pTBigStorage;
begin
  Result := 0;
  m_BigStorageList.Lock();
  try
    for i := 0 to m_BigStorageList.Count - 1 do begin
      if m_BigStorageList.Count <= 0 then break;
      List := TList(m_BigStorageList.Items[i]);
      if (List <> nil) and (List.Count > 0) then begin
        BigStorage := pTBigStorage(List.Items[0]);
        if CompareText(BigStorage.sCharName, sChrName) = 0 then begin
          Result := List.Count;
          break;
        end;
      end;
    end;
  finally
    m_BigStorageList.UnLock();
  end;
end;

function TBigStorageList.ClearRec(): Boolean;
var
  i, ii: Integer;
  List: TList;
  BigStorage: pTBigStorage;
begin
  Result := False;
  m_BigStorageList.Lock();
  try
    for i := 0 to m_BigStorageList.Count - 1 do begin
      if m_BigStorageList.Count <= 0 then break;
      List := TList(m_BigStorageList.Items[i]);
      if (List <> nil) and (List.Count > 0) then begin
        for ii := 0 to List.Count - 1 do begin
          BigStorage := pTBigStorage(List.Items[0]);
          DisPose(BigStorage);
        end;
        List.Free;
      end;
    end;
    m_BigStorageList.Clear;
    Inc(m_nChangeCount);
    Result := TRUE;
  finally
    m_BigStorageList.UnLock();
  end;
end;

function TBigStorageList.GetUserStorageListByMakeIndex(sChrName, sItemName: string; nMakeIndex: Integer; var UserItem: pTUserItem): Boolean;
var
  i, ii: Integer;
  List: TList;
  Storage: pTBigStorage;
  sUserItemName: string;
begin
  Result := False;
  m_BigStorageList.Lock();
  try
    for i := 0 to m_BigStorageList.Count - 1 do begin
      if m_BigStorageList.Count <= 0 then break;
      List := TList(m_BigStorageList.Items[i]);
      if (List <> nil) and (List.Count > 0) then begin
        Storage := pTBigStorage(List.Items[0]);
        if CompareText(Storage.sCharName, sChrName) = 0 then begin
          for ii := 0 to List.Count - 1 do begin
            Storage := pTBigStorage(List.Items[ii]);
            if (Storage.UseItems.MakeIndex = nMakeIndex) and (not Storage.boDelete) then begin
              sUserItemName := '';
              if Storage.UseItems.btValue[13] = 1 then
                sUserItemName := ItemUnit.GetCustomItemName(Storage.UseItems.MakeIndex, Storage.UseItems.wIndex);
              if sUserItemName = '' then
                sUserItemName := UserEngine.GetStdItemName(Storage.UseItems.wIndex);
              if CompareText(sUserItemName, sItemName) = 0 then begin
                New(UserItem);
                UserItem^ := Storage.UseItems;
                Result := TRUE;
                break;
              end;
            end;
          end;
        end;
      end;
    end;
  finally
    m_BigStorageList.UnLock();
  end;
end;

function TBigStorageList.AddItemToUserBigStorageList(sChrName: string; UserItem: pTUserItem): Boolean;
var
  i: Integer;
  List: TList;
  Storage: pTBigStorage;
  boFound: Boolean;
  AddStorage: pTBigStorage;
begin
  Result := False;
  m_BigStorageList.Lock();
  try
    boFound := False;
    for i := 0 to m_BigStorageList.Count - 1 do begin
      if m_BigStorageList.Count <= 0 then break;
      List := TList(m_BigStorageList.Items[i]);
      if (List <> nil) and (List.Count > 0) then begin
        Storage := pTBigStorage(List.Items[0]);
        if CompareText(Storage.sCharName, sChrName) = 0 then begin
          New(AddStorage);
          FillChar(AddStorage.UseItems, SizeOf(TUserItem), #0);
          AddStorage.boDelete := False;
          AddStorage.sCharName := sChrName;
          AddStorage.SaveDateTime := Now;
          AddStorage.UseItems := UserItem^;
          List.Add(AddStorage);
          Inc(m_nChangeCount);
          boFound := TRUE;
          Result := TRUE;
        end;
      end;
    end;
    if not boFound then begin
      List := TList.Create;
      New(AddStorage);
      FillChar(AddStorage.UseItems, SizeOf(TUserItem), #0);
      AddStorage.boDelete := False;
      AddStorage.sCharName := sChrName;
      AddStorage.SaveDateTime := Now;
      AddStorage.UseItems := UserItem^;
      List.Add(AddStorage);
      m_BigStorageList.Add(List);
      Inc(m_nChangeCount);
      Result := TRUE;
    end;
  finally
    m_BigStorageList.UnLock();
  end;
end;

function TBigStorageList.DelBigStorageItem(sChrName, sItemName: string; nMakeIndex: Integer): Boolean;
var
  i, ii: Integer;
  List: TList;
  Storage: pTBigStorage;
  sUserItemName: string;
begin
  Result := False;
  m_BigStorageList.Lock();
  try
    i := 0;
    while TRUE do begin
      if i >= m_BigStorageList.Count then break;
      if m_BigStorageList.Count <= 0 then break;
      List := TList(m_BigStorageList.Items[i]);
      if List <> nil then begin
        if List.Count <= 0 then begin
          List.Free;
          m_BigStorageList.Delete(i);
          Inc(i);
          Continue;
        end;

        Storage := pTBigStorage(List.Items[0]);
        if CompareText(Storage.sCharName, sChrName) = 0 then begin
          ii := 0;
          while TRUE do begin
            if ii >= List.Count then break;
            Storage := pTBigStorage(List.Items[ii]);
            if (Storage.UseItems.MakeIndex = nMakeIndex) and (not Storage.boDelete) then begin
              sUserItemName := '';
              if Storage.UseItems.btValue[13] = 1 then
                sUserItemName := ItemUnit.GetCustomItemName(Storage.UseItems.MakeIndex, Storage.UseItems.wIndex);
              if sUserItemName = '' then
                sUserItemName := UserEngine.GetStdItemName(Storage.UseItems.wIndex);
              if CompareText(sUserItemName, sItemName) = 0 then begin
                Storage.boDelete := TRUE;
                DisPose(Storage);
                List.Delete(ii);
                if List.Count <= 0 then begin
                  List.Free;
                  m_BigStorageList.Delete(i);
                end;
                Inc(m_nChangeCount);
                Result := TRUE;
                break;
              end;
            end;
            Inc(ii);
          end;
        end;
      end;
      Inc(i);
    end;
  finally
    m_BigStorageList.UnLock();
  end;
end;

function TBigStorageList.SaveStorageList(): Boolean;
var
  i, ii: Integer;
  sFileName: string;
  FileHandle: Integer;
  Storage: pTBigStorage;
  List: TList;
  nItemCount: TItemCount; //Inc(m_nChangeCount);
  nChangeCount: Integer;
begin
  Result := False;
  m_BigStorageList.Lock();
  try
    if (g_boExitServer) and (m_nChangeCount <= 0) then m_nChangeCount := 1;
    if (not FUpDate) and (m_nChangeCount > 0) then begin
      nChangeCount := m_nChangeCount;
      FUpDate := TRUE;
      sFileName := g_Config.sEnvirDir + '\Market_Storage\UserStorage.db';
      if FileExists(sFileName) then begin
        FileHandle := FileOpen(sFileName, fmOpenWrite or fmShareDenyNone);
      end else begin
        FileHandle := FileCreate(sFileName);
      end;
      if FileHandle > 0 then begin
        FillChar(nItemCount, SizeOf(TItemCount), #0);
        for i := m_BigStorageList.Count - 1 downto 0 do begin
          List := TList(m_BigStorageList.Items[i]);
          if List <> nil then begin
            if List.Count <= 0 then begin
              List.Free;
              m_BigStorageList.Delete(i);
            end;
          end;
        end;
        for i := 0 to m_BigStorageList.Count - 1 do begin
          List := TList(m_BigStorageList.Items[i]);
          if List <> nil then begin
            Inc(nItemCount, List.Count);
          end;
        end;
        FileSeek(FileHandle, 0, 0);
        FileWrite(FileHandle, nItemCount, SizeOf(TItemCount));
        for i := 0 to m_BigStorageList.Count - 1 do begin
          List := TList(m_BigStorageList.Items[i]);
          for ii := 0 to List.Count - 1 do begin
            if List = nil then Continue;
            Storage := pTBigStorage(List.Items[ii]);
            if (Storage <> nil) and (not Storage.boDelete) then
              FileWrite(FileHandle, Storage^, SizeOf(TBigStorage));
          end;
        end;
        FileClose(FileHandle);
      end;
      FUpDate := False;
      m_nChangeCount := 0;
      Result := TRUE;
    end;
  finally
    m_BigStorageList.UnLock();
  end;
end;

function TBigStorageList.SaveStorageList(sFileName: string): Boolean;
var
  i, ii: Integer;
  FileHandle: Integer;
  Storage: pTBigStorage;
  List: TList;
  nItemCount: TItemCount; //Inc(m_nChangeCount);
  nChangeCount: Integer;
begin
  Result := False;
  m_BigStorageList.Lock();
  try
    if FileExists(sFileName) then DeleteFile(sFileName);
    FileHandle := FileCreate(sFileName);
    if FileHandle > 0 then begin
      FillChar(nItemCount, SizeOf(TItemCount), #0);
      for i := m_BigStorageList.Count - 1 downto 0 do begin
        List := TList(m_BigStorageList.Items[i]);
        if List <> nil then begin
          if List.Count <= 0 then begin
            List.Free;
            m_BigStorageList.Delete(i);
          end;
        end;
      end;
      for i := 0 to m_BigStorageList.Count - 1 do begin
        List := TList(m_BigStorageList.Items[i]);
        if List <> nil then begin
          Inc(nItemCount, List.Count);
        end;
      end;
      FileSeek(FileHandle, 0, 0);
      FileWrite(FileHandle, nItemCount, SizeOf(TItemCount));
      for i := 0 to m_BigStorageList.Count - 1 do begin
        List := TList(m_BigStorageList.Items[i]);
        for ii := 0 to List.Count - 1 do begin
          if List = nil then Continue;
          Storage := pTBigStorage(List.Items[ii]);
          if (Storage <> nil) and (not Storage.boDelete) then
            FileWrite(FileHandle, Storage^, SizeOf(TBigStorage));
        end;
      end;
      FileClose(FileHandle);
      Result := TRUE;
    end;
  finally
    m_BigStorageList.UnLock();
  end;
end;
{TSellOffGoodList}


constructor TSellOffGoodList.Create;
begin
  inherited Create;
  FRecCount := 0;
  FUpDateSellOff := False;
  m_nChangeCount := 0;
  m_SellOffGoodList := TGList.Create;
end;

destructor TSellOffGoodList.Destroy;
begin
  UnLoadSellOffGoodList();
  inherited;
end;

procedure TSellOffGoodList.UnLoadSellOffGoodList();
var
  i, ii: Integer;
begin
  m_SellOffGoodList.Lock();
  try
    SaveSellOffGoodList();
    FUpDateSellOff := TRUE;
    for i := 0 to m_SellOffGoodList.Count - 1 do begin
      if m_SellOffGoodList.Count <= 0 then break;
      if TList(m_SellOffGoodList.Items[i]).Count <= 0 then begin
        TList(m_SellOffGoodList.Items[i]).Free;
        Continue;
      end;
      for ii := 0 to TList(m_SellOffGoodList.Items[i]).Count - 1 do begin
        DisPose(pTSellOffInfo(TList(m_SellOffGoodList.Items[i]).Items[ii]));
      end;
      TList(m_SellOffGoodList.Items[i]).Free;
    end;
  finally
    m_SellOffGoodList.UnLock();
  end;
  m_SellOffGoodList.Free;
end;

procedure TSellOffGoodList.LoadSellOffGoodList();
var
  i: Integer;
  sFileName: string;
  FileHandle: Integer;
  List: TList;
  SellOffInfo: pTSellOffInfo;
  Header420: TSellOffHeader;
begin
  m_SellOffGoodList.Lock();
  try
    sFileName := g_Config.sEnvirDir + '\Market_SellOff\UserSellOff.sell';
    if FileExists(sFileName) then begin
      FileHandle := FileOpen(sFileName, fmOpenRead or fmShareDenyNone);
      List := nil;
      if FileHandle > 0 then begin
        if FileRead(FileHandle, Header420, SizeOf(TSellOffHeader)) = SizeOf(TSellOffHeader) then begin
          FRecCount := Header420.nItemCount;
          for i := 0 to Header420.nItemCount - 1 do begin
            New(SellOffInfo);
            FillChar(SellOffInfo.UseItems, SizeOf(TUserItem), #0);
            if (FileRead(FileHandle, SellOffInfo^, SizeOf(TSellOffInfo)) = SizeOf(TSellOffInfo)) and (SellOffInfo.UseItems.wIndex > 0) then begin
              if List = nil then begin
                List := TList.Create;
                List.Add(SellOffInfo);
              end else begin
                if pTSellOffInfo(List.Items[0]).UseItems.wIndex = SellOffInfo.UseItems.wIndex then begin
                  List.Add(SellOffInfo);
                end else begin
                  m_SellOffGoodList.Add(List);
                  List := TList.Create;
                  List.Add(SellOffInfo);
                end;
              end;
            end else begin
              DisPose(SellOffInfo);
            end;
          end;
          if List <> nil then
            m_SellOffGoodList.Add(List);
          FileClose(FileHandle);
        end;
      end;
    end else begin
      FileHandle := FileCreate(sFileName);
      if FileHandle > 0 then begin
        Header420.nItemCount := 0;
        FileWrite(FileHandle, Header420, SizeOf(TSellOffHeader));
        FileClose(FileHandle);
      end;
    end;
  finally
    m_SellOffGoodList.UnLock();
  end;
  //MainOutMessage('LoadSellGoodRecord: '+IntToStr(Self.Count));
end;

procedure TSellOffGoodList.GetSellOffGoodList(var SellOffList: TList);
var
  i: Integer;
  List: TList;
  SellOffInfo: pTSellOffInfo;
begin
  m_SellOffGoodList.Lock();
  try
    if SellOffList <> nil then begin
      SellOffList.Clear;
      for i := 0 to m_SellOffGoodList.Count - 1 do begin
        if m_SellOffGoodList.Count <= 0 then break;
        List := TList(m_SellOffGoodList.Items[i]);
        if List.Count <= 0 then Continue;
        SellOffInfo := pTSellOffInfo(List.Items[0]);
        SellOffList.Add(SellOffInfo);
      end;
    end;
  finally
    m_SellOffGoodList.UnLock();
  end;
end;

procedure TSellOffGoodList.GetUserSellOffGoodListByChrName(sChrName: string; var SellOffList: TList);
var
  i, ii: Integer;
  List: TList;
  SellOffInfo: pTSellOffInfo;
begin
  m_SellOffGoodList.Lock();
  try
    for i := 0 to m_SellOffGoodList.Count - 1 do begin
      if m_SellOffGoodList.Count <= 0 then break;
      List := TList(m_SellOffGoodList.Items[i]);
      if List = nil then Continue;
      if List.Count <= 0 then Continue;
      for ii := 0 to List.Count - 1 do begin
        SellOffInfo := pTSellOffInfo(List.Items[ii]);
        if CompareText(SellOffInfo.sCharName, sChrName) = 0 then
          SellOffList.Add(SellOffInfo);
      end;
    end;
  finally
    m_SellOffGoodList.UnLock();
  end;
end;

procedure TSellOffGoodList.GetUserSellOffGoodListByItemName(sItemName: string; var SellOffList: TList);
var
  i: Integer;
  List: TList;
  SellOffInfo: pTSellOffInfo;
  sUserItemName: string;
  StdItem: pTStdItem;
begin
  m_SellOffGoodList.Lock();
  try
    SellOffList := nil;
    for i := 0 to m_SellOffGoodList.Count - 1 do begin
      if m_SellOffGoodList.Count <= 0 then break;
      List := TList(m_SellOffGoodList.Items[i]);
      if List = nil then Continue;
      if List.Count <= 0 then Continue;
      SellOffInfo := pTSellOffInfo(List.Items[0]);
      sUserItemName := '';
      if SellOffInfo.UseItems.btValue[13] = 1 then
        sUserItemName := ItemUnit.GetCustomItemName(SellOffInfo.UseItems.MakeIndex, SellOffInfo.UseItems.wIndex);
      if sUserItemName = '' then
        sUserItemName := UserEngine.GetStdItemName(SellOffInfo.UseItems.wIndex);
      StdItem := UserEngine.GetStdItem(SellOffInfo.UseItems.wIndex);
      if (StdItem <> nil) and (CompareText(sUserItemName, sItemName) = 0) then begin
        SellOffList := List;
        break;
      end;
    end;
  finally
    m_SellOffGoodList.UnLock();
  end;
end;

procedure TSellOffGoodList.GetUserSellOffGoodListByMakeIndex(nMakeIndex: Integer; var SellOffInfo: pTSellOffInfo);
var
  i, ii: Integer;
  List: TList;
begin
  m_SellOffGoodList.Lock();
  try
    SellOffInfo := nil;
    for i := 0 to m_SellOffGoodList.Count - 1 do begin
      if m_SellOffGoodList.Count <= 0 then break;
      List := TList(m_SellOffGoodList.Items[i]);
      if List.Count <= 0 then Continue;
      for ii := List.Count - 1 downto 0 do begin
        if pTSellOffInfo(List.Items[ii]).UseItems.MakeIndex = nMakeIndex then begin
          SellOffInfo := pTSellOffInfo(List.Items[ii]);
          break;
        end;
      end;
    end;
  finally
    m_SellOffGoodList.UnLock();
  end;
end;

procedure TSellOffGoodList.GetUserSellOffItem(sItemName: string; nMakeIndex: Integer; var SellOffInfo: pTSellOffInfo; var StdItem: pTStdItem);
var
  i, ii, n01: Integer;
  List: TList;
  sUserItemName: string;
begin
  m_SellOffGoodList.Lock();
  try
    SellOffInfo := nil;
    StdItem := nil;
    n01 := 0;
    for i := 0 to m_SellOffGoodList.Count - 1 do begin
      if m_SellOffGoodList.Count <= 0 then break;
      List := TList(m_SellOffGoodList.Items[i]);
      if List.Count <= 0 then Continue;
      SellOffInfo := pTSellOffInfo(List.Items[0]);
      sUserItemName := '';
      if SellOffInfo.UseItems.btValue[13] = 1 then
        sUserItemName := ItemUnit.GetCustomItemName(SellOffInfo.UseItems.MakeIndex, SellOffInfo.UseItems.wIndex);
      if sUserItemName = '' then
        sUserItemName := UserEngine.GetStdItemName(SellOffInfo.UseItems.wIndex);
      StdItem := UserEngine.GetStdItem(SellOffInfo.UseItems.wIndex);
      if (StdItem <> nil) and (CompareText(sUserItemName, sItemName) = 0) then begin
        for ii := 0 to List.Count - 1 do begin
          SellOffInfo := pTSellOffInfo(List.Items[ii]);
          if (StdItem.StdMode <= 4) or
            (StdItem.StdMode = 42) or
            (StdItem.StdMode = 31) or
            (SellOffInfo.UseItems.MakeIndex = nMakeIndex) then begin
            Inc(n01);
            break;
          end;
        end;
        break;
      end;
    end;
    if n01 = 0 then begin
      SellOffInfo := nil;
      StdItem := nil;
    end;
  finally
    m_SellOffGoodList.UnLock();
  end;
end;

function TSellOffGoodList.GetUserSellOffCount(sCharName: string): Integer;
var
  ItemList: TList;
  i, ii: Integer;
begin
  m_SellOffGoodList.Lock();
  try
    Result := -1;
    for i := 0 to m_SellOffGoodList.Count - 1 do begin
      if m_SellOffGoodList.Count <= 0 then break;
      ItemList := TList(m_SellOffGoodList.Items[i]);
      if ItemList.Count <= 0 then Continue;
      for ii := ItemList.Count - 1 downto 0 do begin
        if ItemList.Count <= 0 then Continue;
        if CompareText(pTSellOffInfo(ItemList.Items[ii]).sCharName, sCharName) = 0 then
          Inc(Result);
      end;
    end;
  finally
    m_SellOffGoodList.UnLock();
  end;
end;

function TSellOffGoodList.GetUserLimitSellOffCount(sCharName: string): Boolean;
var
  ItemList: TList;
  i, ii: Integer;
  n01: Integer;
begin
  m_SellOffGoodList.Lock();
  try
    n01 := 0;
    Result := False;
    for i := 0 to m_SellOffGoodList.Count - 1 do begin
      if m_SellOffGoodList.Count <= 0 then break;
      ItemList := TList(m_SellOffGoodList.Items[i]);
      if ItemList.Count <= 0 then Continue;
      for ii := ItemList.Count - 1 downto 0 do begin
        if ItemList.Count <= 0 then Continue;
        if CompareText(pTSellOffInfo(ItemList.Items[ii]).sCharName, sCharName) = 0 then begin
          Inc(n01);
          if n01 >= g_Config.nUserSellOffCount then begin
            Result := TRUE;
            break;
          end;
        end;
      end;
    end;
  finally
    m_SellOffGoodList.UnLock();
  end;
end;

procedure TSellOffGoodList.GetUserSellOffListByIndex(nIndex: Integer; var SellOffList: TList); //0049F118
var
  i: Integer;
  List: TList;
begin
  m_SellOffGoodList.Lock();
  try
    SellOffList := nil;
    for i := 0 to m_SellOffGoodList.Count - 1 do begin
      if nIndex <= 0 then break;
      List := TList(m_SellOffGoodList.Items[i]);
      if List.Count > 0 then begin
        if pTSellOffInfo(List.Items[0]).UseItems.wIndex = nIndex then begin
          SellOffList := List;
          break;
        end;
      end;
    end;
  finally
    m_SellOffGoodList.UnLock();
  end;
end;

function TSellOffGoodList.AddItemToSellOffGoodsList(SellOffInfo: pTSellOffInfo): Boolean;
var
  ItemList: TList;
begin
  m_SellOffGoodList.Lock();
  try
    Result := False;
    GetUserSellOffListByIndex(SellOffInfo.UseItems.wIndex, ItemList);
    if ItemList = nil then begin
      ItemList := TList.Create;
      m_SellOffGoodList.Add(ItemList);
    end;
    ItemList.Insert(0, SellOffInfo);
    Inc(m_nChangeCount);
    Result := TRUE;
  finally
    m_SellOffGoodList.UnLock();
  end;
end;

function TSellOffGoodList.DelSellOffItem(nMakeIndex: Integer): Boolean;
var
  i, ii: Integer;
  List: TList;
begin
  Result := False;
  m_SellOffGoodList.Lock();
  try
    for i := m_SellOffGoodList.Count - 1 downto 0 do begin
      if m_SellOffGoodList.Count <= 0 then break;
      List := TList(m_SellOffGoodList.Items[i]);
      if List.Count <= 0 then begin
        List.Free;
        m_SellOffGoodList.Delete(i);
        Continue;
      end;
      for ii := List.Count - 1 downto 0 do begin
        if pTSellOffInfo(List.Items[ii]).UseItems.MakeIndex = nMakeIndex then begin
          DisPose(pTSellOffInfo(List.Items[ii]));
          List.Delete(ii);
          if List.Count <= 0 then begin
            List.Free;
            m_SellOffGoodList.Delete(i);
          end;
          Inc(m_nChangeCount);
          Result := TRUE;
          break;
        end;
      end;
    end;
  finally
    m_SellOffGoodList.UnLock();
  end;
end;

function TSellOffGoodList.SaveSellOffGoodList(): Boolean;
var
  i, ii: Integer;
  sFileName: string;
  FileHandle: Integer;
  SellOffInfo: pTSellOffInfo;
  List: TList;
  Header420: TSellOffHeader;
  nChangeCount: Integer;
begin
  m_SellOffGoodList.Lock();
  try
    Result := False;
    if (g_boExitServer) and (m_nChangeCount <= 0) then m_nChangeCount := 1;
    if (not FUpDateSellOff) and (m_nChangeCount > 0) then begin
      nChangeCount := m_nChangeCount;
      FUpDateSellOff := TRUE;
      sFileName := g_Config.sEnvirDir + '\Market_SellOff\UserSellOff.sell';
      if FileExists(sFileName) then begin
        FileHandle := FileOpen(sFileName, fmOpenWrite or fmShareDenyNone);
      end else begin
        FileHandle := FileCreate(sFileName);
      end;
      if FileHandle > 0 then begin
        FillChar(Header420, SizeOf(TSellOffHeader), #0);
        for i := m_SellOffGoodList.Count - 1 downto 0 do begin
          List := TList(m_SellOffGoodList.Items[i]);
          if List <> nil then begin
            if List.Count <= 0 then begin
              List.Free;
              m_SellOffGoodList.Delete(i);
            end;
          end;
        end;
        for i := 0 to m_SellOffGoodList.Count - 1 do begin
          List := TList(m_SellOffGoodList.Items[i]);
          if List <> nil then begin
            Inc(Header420.nItemCount, List.Count);
          end;
        end;
        FileWrite(FileHandle, Header420, SizeOf(TSellOffHeader));
        for i := 0 to m_SellOffGoodList.Count - 1 do begin
          List := TList(m_SellOffGoodList.Items[i]);
          for ii := 0 to List.Count - 1 do begin
            if (List = nil) or (List.Count <= 0) then Continue;
            SellOffInfo := pTSellOffInfo(List.Items[ii]);
            if SellOffInfo <> nil then
              FileWrite(FileHandle, SellOffInfo^, SizeOf(TSellOffInfo));
          end;
        end;
        FileClose(FileHandle);
      end;
      FUpDateSellOff := False;
      m_nChangeCount := 0;
      Result := TRUE;
    end;
  finally
    m_SellOffGoodList.UnLock();
  end;
end;

{TSellOffGoldList}

constructor TSellOffGoldList.Create;
begin
  inherited Create;
  FRecCount := 0;
  FUpDateSellOff := False;
  m_nChangeCount := 0;
  m_SellOffGoldList := TGList.Create;
end;

destructor TSellOffGoldList.Destroy;
begin
  UnLoadSellOffGoldList();
  inherited;
end;

procedure TSellOffGoldList.UnLoadSellOffGoldList();
var
  i: Integer;
begin
  m_SellOffGoldList.Lock();
  try
    SaveSellOffGoldList();
    FUpDateSellOff := TRUE;
    for i := 0 to m_SellOffGoldList.Count - 1 do begin
      if m_SellOffGoldList.Count <= 0 then break;
      DisPose(pTSellOffInfo(m_SellOffGoldList.Items[i]));
    end;
  finally
    m_SellOffGoldList.UnLock();
  end;
  m_SellOffGoldList.Free;
end;

procedure TSellOffGoldList.LoadSellOffGoldList();
var
  i: Integer;
  sFileName: string;
  FileHandle: Integer;
  SellOffInfo: pTSellOffInfo;
  Header420: TSellOffHeader;
begin
  m_SellOffGoldList.Lock();
  try
    sFileName := g_Config.sEnvirDir + '\Market_SellOff\UserSellOff.gold';
    if FileExists(sFileName) then begin
      FileHandle := FileOpen(sFileName, fmOpenRead or fmShareDenyNone);
      if FileHandle > 0 then begin
        if FileRead(FileHandle, Header420, SizeOf(TSellOffHeader)) = SizeOf(TSellOffHeader) then begin
          FRecCount := Header420.nItemCount;
          for i := 0 to Header420.nItemCount - 1 do begin
            New(SellOffInfo);
            FillChar(SellOffInfo.UseItems, SizeOf(TUserItem), #0);
            if (FileRead(FileHandle, SellOffInfo^, SizeOf(TSellOffInfo)) = SizeOf(TSellOffInfo)) and (SellOffInfo.UseItems.wIndex > 0) then begin
              m_SellOffGoldList.Add(SellOffInfo);
            end else begin
              DisPose(SellOffInfo);
            end;
          end;
          FileClose(FileHandle);
        end;
      end;
    end else begin
      FileHandle := FileCreate(sFileName);
      if FileHandle > 0 then begin
        Header420.nItemCount := 0;
        FileWrite(FileHandle, Header420, SizeOf(TSellOffHeader));
        FileClose(FileHandle);
      end;
    end;
  finally
    m_SellOffGoldList.UnLock();
  end;
end;

procedure TSellOffGoldList.GetUserSellOffGoldListByChrName(sChrName: string; var SellOffList: TList);
var
  i: Integer;
  SellOffInfo: pTSellOffInfo;
begin
  m_SellOffGoldList.Lock();
  try
    for i := 0 to m_SellOffGoldList.Count - 1 do begin
      if m_SellOffGoldList.Count <= 0 then break;
      SellOffInfo := pTSellOffInfo(m_SellOffGoldList.Items[i]);
      if (SellOffInfo <> nil) and (CompareText(SellOffInfo.sCharName, sChrName) = 0) and (SellOffInfo.nSellGold > 0) then
        SellOffList.Add(SellOffInfo);
    end;
  finally
    m_SellOffGoldList.UnLock();
  end;
end;

function TSellOffGoldList.AddItemToSellOffGoldList(SellOffInfo: pTSellOffInfo): Boolean;
begin
  m_SellOffGoldList.Lock();
  try
    Result := False;
    m_SellOffGoldList.Add(SellOffInfo);
    Inc(m_nChangeCount);
    Result := TRUE;
  finally
    m_SellOffGoldList.UnLock();
  end;
end;

function TSellOffGoldList.DelSellOffGoldItem(nMakeIndex: Integer): Boolean;
var
  i: Integer;
begin
  m_SellOffGoldList.Lock();
  try
    Result := False;
    for i := m_SellOffGoldList.Count - 1 downto 0 do begin
      if m_SellOffGoldList.Count <= 0 then break;
      if pTSellOffInfo(m_SellOffGoldList.Items[i]).UseItems.MakeIndex = nMakeIndex then begin
        DisPose(pTSellOffInfo(m_SellOffGoldList.Items[i]));
        m_SellOffGoldList.Delete(i);
        Inc(m_nChangeCount);
        Result := TRUE;
        break;
      end;
    end;
  finally
    m_SellOffGoldList.UnLock();
  end;
end;

function TSellOffGoldList.SaveSellOffGoldList(): Boolean;
var
  i: Integer;
  sFileName: string;
  FileHandle: Integer;
  SellOffInfo: pTSellOffInfo;
  Header420: TSellOffHeader; //Inc(m_nChangeCount);
  nChangeCount: Integer;
begin
  m_SellOffGoldList.Lock();
  try
    Result := False;
    if (g_boExitServer) and (m_nChangeCount <= 0) then m_nChangeCount := 1;
    if (not FUpDateSellOff) and (m_nChangeCount > 0) then begin
      nChangeCount := m_nChangeCount;
      FUpDateSellOff := TRUE;
      sFileName := g_Config.sEnvirDir + '\Market_SellOff\UserSellOff.gold';
      if FileExists(sFileName) then begin
        FileHandle := FileOpen(sFileName, fmOpenWrite or fmShareDenyNone);
      end else begin
        FileHandle := FileCreate(sFileName);
      end;
      if FileHandle > 0 then begin
        FillChar(Header420, SizeOf(TSellOffHeader), #0);
        Header420.nItemCount := m_SellOffGoldList.Count;
        FileWrite(FileHandle, Header420, SizeOf(TSellOffHeader));
        for i := 0 to m_SellOffGoldList.Count - 1 do begin
          SellOffInfo := m_SellOffGoldList.Items[i];
          if SellOffInfo <> nil then
            FileWrite(FileHandle, SellOffInfo^, SizeOf(TSellOffInfo));
        end;
        FileClose(FileHandle);
      end;
      FUpDateSellOff := False;
      m_nChangeCount := 0;
      Result := TRUE;
    end;
  finally
    m_SellOffGoldList.UnLock();
  end;
end;

end.


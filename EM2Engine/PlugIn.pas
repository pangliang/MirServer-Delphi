unit PlugIn;

interface
uses
  Windows, Classes, SysUtils, Forms, Grobal2, SDK, HUtil32;
var
  PlugHandList: TStringList;
type
  TPlugInfo = record
    DllName: string;
    sDesc: string;
    Module: THandle;
  end;
  pTPlugInfo = ^TPlugInfo;

  TPlugInManage = class
    PlugList: TStringList;
    StartPlugList: TList;
  public
    constructor Create();
    destructor Destroy; override;
    procedure StartPlugMoudle();
    procedure LoadPlugIn();
    procedure UnLoadPlugIn();
  end;
procedure MainMessage(Msg: PChar; nMsgLen: Integer; nMode: Integer); stdcall;
procedure SendBroadCastMsg(Msg: PChar; MsgType: TMsgType); stdcall;
function GetFunAddr(nIndex: Integer): Pointer; stdcall;
function FindOBjTable_(ObjName: PChar; nNameLen, nCode: Integer): TObject; stdcall;
function SetProcCode_(ProcName: PChar; nNameLen, nCheckCode: Integer): Boolean; stdcall;
function SetProcCheckCode_(ProcName, CheckCode: PChar; nNameLen, nCheckCodeLen: Integer): Boolean; stdcall;

function SetProcTable_(ProcAddr: Pointer; ProcName: PChar; nNameLen, nCode: Integer): Boolean; stdcall;
function FindProcCode_(ProcName: PChar; nNameLen: Integer): Integer; stdcall;
function FindProcTable_(ProcName: PChar; nNameLen, nCode: Integer): Pointer; stdcall;

function FindProcTable(ProcName: PChar; nNameLen: Integer): Pointer; stdcall;
function SetProcTable(ProcAddr: Pointer; ProcName: PChar; nNameLen: Integer): Boolean; stdcall;
function FindOBjTable(ObjName: PChar; nNameLen: Integer): TObject; stdcall;
function SetStartPlugProc(StartPlug: Pointer): Boolean; stdcall;
implementation

uses M2Share, EDcode;
var
  PublicMoudle: Integer;
procedure MainMessage(Msg: PChar; nMsgLen: Integer; nMode: Integer);
var
  MsgBuff: string;
begin
  if (Msg <> nil) and (nMsgLen > 0) then begin
    setlength(MsgBuff, nMsgLen);
    Move(Msg^, MsgBuff[1], nMsgLen);
    case nMode of
      0: begin
          if Memo <> nil then Memo.Lines.Add(MsgBuff);
        end;
      else MainOutMessage(MsgBuff);
    end;
  end;
end;

procedure SendBroadCastMsg(Msg: PChar; MsgType: TMsgType); stdcall;
begin
  if UserEngine <> nil then
    UserEngine.SendBroadCastMsgExt(Msg, MsgType);
end;
//由DLL调用按名字查找函数地址

function FindProcTable_(ProcName: PChar; nNameLen, nCode: Integer): Pointer;
var
  i: Integer;
  sProcName: string;
begin
  Result := nil;
  setlength(sProcName, nNameLen);
  Move(ProcName^, sProcName[1], nNameLen);
  for i := Low(ProcArray) to High(ProcArray) do begin
    if (ProcArray[i].nProcAddr <> nil) and (CompareText(sProcName, ProcArray[i].sProcName) = 0) and (ProcArray[i].nCheckCode = nCode) then begin
      Result := ProcArray[i].nProcAddr;
      break;
    end;
  end;
end;

function FindProcCode_(ProcName: PChar; nNameLen: Integer): Integer;
var
  i: Integer;
  sProcName: string;
begin
  Result := -1;
  setlength(sProcName, nNameLen);
  Move(ProcName^, sProcName[1], nNameLen);
  for i := Low(PlugProcArray) to High(PlugProcArray) do begin
    if CompareText(sProcName, PlugProcArray[i].sProcName) = 0 then begin
      Result := PlugProcArray[i].nCheckCode;
      break;
    end;
  end;
end;
//=================================
//由DLL调用按名字设置插件中的函数地址

function SetProcTable_(ProcAddr: Pointer; ProcName: PChar; nNameLen, nCode: Integer): Boolean;
var
  i: Integer;
  sProcName: string;
begin
  Result := False;
  setlength(sProcName, nNameLen);
  Move(ProcName^, sProcName[1], nNameLen);
  for i := Low(PlugProcArray) to High(PlugProcArray) do begin
    if (PlugProcArray[i].nProcAddr = nil) and (CompareText(sProcName, PlugProcArray[i].sProcName) = 0) and (PlugProcArray[i].nCheckCode = nCode) then begin
      PlugProcArray[i].nProcAddr := ProcAddr;
      Result := True;
      break;
    end;
  end;
end;

function SetProcCode_(ProcName: PChar; nNameLen, nCheckCode: Integer): Boolean;
var
  i: Integer;
  sProcName: string;
begin
  Result := False;
  setlength(sProcName, nNameLen);
  Move(ProcName^, sProcName[1], nNameLen);
  for i := Low(PlugProcArray) to High(PlugProcArray) do begin
    if CompareText(sProcName, PlugProcArray[i].sProcName) = 0 then begin
      PlugProcArray[i].nCheckCode := nCheckCode;
      Result := True;
      break;
    end;
  end;
end;

function SetProcCheckCode_(ProcName, CheckCode: PChar; nNameLen, nCheckCodeLen: Integer): Boolean;
var
  i: Integer;
  sCheckCode: string;
  sProcName: string;
begin
  Result := False;
  setlength(sProcName, nNameLen);
  Move(ProcName^, sProcName[1], nNameLen);
  setlength(sCheckCode, nCheckCodeLen);
  Move(CheckCode^, sCheckCode[1], nCheckCodeLen);
  for i := Low(PlugProcArray) to High(PlugProcArray) do begin
    if CompareText(sProcName, PlugProcArray[i].sProcName) = 0 then begin
      PlugProcArray[i].sCheckCode := sCheckCode;
      Result := True;
      break;
    end;
  end;
end;

function SetStartPlugProc(StartPlug: Pointer): Boolean;
var
  i: Integer;
begin
  Result := False;
  if PlugInEngine <> nil then begin
    PlugInEngine.StartPlugList.Add(StartPlug);
    Result := True;
  end;
end;
//由DLL调用按名字查找全局对象地址
function FindOBjTable_(ObjName: PChar; nNameLen, nCode: Integer): TObject;
var
  i: Integer;
  sObjName: string;
begin
  Result := nil;
  setlength(sObjName, nNameLen);
  Move(ObjName^, sObjName[1], nNameLen);
  for i := Low(ProcArray) to High(ProcArray) do begin
    if (ObjectArray[i].Obj <> nil) and (CompareText(sObjName, ObjectArray[i].sObjcName) = 0) and (ObjectArray[i].nCheckCode = nCode) then begin
      Result := ObjectArray[i].Obj;
      break;
    end;
  end;
end;

function GetFunAddr(nIndex: Integer): Pointer;
begin
  Result := nil;
  case nIndex of
    0: Result := @FindProcCode_;
    1: Result := @FindProcTable_;
    2: Result := @SetProcTable_;
    3: Result := @SetProcCode_;
    4: Result := @FindOBjTable_;
    5: Result := @FindOBjTable;
    6: Result := @PublicMoudle;
    8: Result := @SetStartPlugProc;
    9: Result := @SetProcCheckCode_;
  end;
end;
//=================================
//由DLL调用按名字查找函数地址
function FindProcTable(ProcName: PChar; nNameLen: Integer): Pointer;
var
  i: Integer;
  sProcName: string;
begin
  Result := nil;
  setlength(sProcName, nNameLen);
  Move(ProcName^, sProcName[1], nNameLen);
  for i := Low(ProcArray) to High(ProcArray) do begin
    if (ProcArray[i].nProcAddr <> nil) and (CompareText(sProcName, ProcArray[i].sProcName) = 0) and (ProcArray[i].nCheckCode <= 0) then begin
      Result := ProcArray[i].nProcAddr;
      break;
    end;
  end;
end;
//=================================
//由DLL调用按名字设置插件中的函数地址
function SetProcTable(ProcAddr: Pointer; ProcName: PChar; nNameLen: Integer): Boolean;
var
  i: Integer;
  sProcName: string;
begin
  Result := False;
  setlength(sProcName, nNameLen);
  Move(ProcName^, sProcName[1], nNameLen);
  for i := Low(PlugProcArray) to High(PlugProcArray) do begin
    if (PlugProcArray[i].nProcAddr = nil) and (CompareText(sProcName, PlugProcArray[i].sProcName) = 0) and (PlugProcArray[i].nCheckCode <= 0) then begin
      PlugProcArray[i].nProcAddr := ProcAddr;
      Result := True;
      break;
    end;
  end;
end;

//=================================
//由DLL调用按名字查找全局对象地址
function FindOBjTable(ObjName: PChar; nNameLen: Integer): TObject;
var
  i: Integer;
  sObjName: string;
begin
  Result := nil;
  setlength(sObjName, nNameLen);
  Move(ObjName^, sObjName[1], nNameLen);
  for i := Low(ProcArray) to High(ProcArray) do begin
    if (ObjectArray[i].Obj <> nil) and (CompareText(sObjName, ObjectArray[i].sObjcName) = 0) and (ObjectArray[i].nCheckCode <= 0) then begin
      Result := ObjectArray[i].Obj;
      break;
    end;
  end;
end;
{ TPlugIn }

constructor TPlugInManage.Create;
var
  i: Integer;
begin
  PlugList := TStringList.Create;
  StartPlugList := TList.Create;
end;

destructor TPlugInManage.Destroy;
var
  i: Integer;
begin
  if PlugList.Count > 0 then UnLoadPlugIn();
  StartPlugList.Free;
  PlugList.Free;
  inherited;
end;

procedure TPlugInManage.StartPlugMoudle();
var
  i: Integer;
begin
  for i := 0 to StartPlugList.Count - 1 do begin
    if Assigned(StartPlugList.Items[i]) then
      if not TStartPlug(StartPlugList.Items[i]) then break;
  end;
end;

procedure TPlugInManage.LoadPlugIn;
var
  i: Integer;
  LoadList: TStringList;
  sPlugFileName: string;
  sPlugLibName: string;
  sPlugLibFileName: string;
  Moudle: THandle;
  Init: TPlugInit;
  PlugInfo: pTPlugInfo;
begin
  sPlugFileName := g_Config.sPlugDir + 'PlugList.txt';
  if not DirectoryExists(g_Config.sPlugDir) then begin
    //CreateDirectory(PChar(g_Config.sConLogDir),nil);
    CreateDir(g_Config.sPlugDir);
  end;
  if not FileExists(sPlugFileName) then begin
    LoadList := TStringList.Create;
    LoadList.Add('IPLocal.dll');
    LoadList.SaveToFile(sPlugFileName);
    LoadList.Free;
  end;
  if FileExists(sPlugFileName) then begin
    LoadList := TStringList.Create;
    LoadList.LoadFromFile(sPlugFileName);
    for i := 0 to LoadList.Count - 1 do begin
      sPlugLibName := Trim(LoadList.Strings[i]);
      if (sPlugLibName = '') or (sPlugLibName[1] = ';') then Continue;
      sPlugLibFileName := g_Config.sPlugDir + sPlugLibName;
      if FileExists(sPlugLibFileName) then begin
        Moudle := LoadLibrary(PChar(sPlugLibFileName)); //FreeLibrary
        if Moudle > 32 then begin
          Init := GetProcAddress(Moudle, 'Init');
          if @Init <> nil then begin
            PlugHandList.AddObject('', TObject(Moudle));
            PublicMoudle := Moudle;
            New(PlugInfo);
            PlugInfo.DllName := sPlugLibFileName;
            PlugInfo.Module := Moudle;
            PlugInfo.sDesc := Init(Application.Handle, @MainMessage, @FindProcTable, @SetProcTable, @GetFunAddr);
            PlugList.AddObject(PlugInfo.sDesc, TObject(PlugInfo));
            PublicMoudle := -1;
          end;
        end;
      end;
    end;
    LoadList.Free;
  end;
end;

procedure TPlugInManage.UnLoadPlugIn;
var
  i: Integer;
  Module: THandle;
  PFunc: procedure(); stdcall;
begin
  for i := 0 to PlugList.Count - 1 do begin
    Module := pTPlugInfo(PlugList.Objects[i]).Module;
    PFunc := GetProcAddress(Module, 'UnInit');
    if @PFunc <> nil then
      PFunc();
    FreeLibrary(Module);
  end;
end;

initialization

finalization

end.


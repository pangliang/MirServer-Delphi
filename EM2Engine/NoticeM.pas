unit NoticeM;

interface
uses
  Windows, Classes, SysUtils;
type
  TNoticeMsg = record //0x0C 00491BE9
    sMsg: string;
    sList: TStringList;
    bo0C: Boolean;
  end;
  TNoticeList = array[0..99] of TNoticeMsg;
  TNoticeManager = class
  private
    NoticeList: TNoticeList;
  public
    constructor Create();
    destructor Destroy; override;
    function GetNoticeMsg(sStr: string; LoadList: TStringList): Boolean;
    procedure LoadingNotice();
  end;
implementation

uses M2Share;

{ TNoticeManager }

//00491C9E
constructor TNoticeManager.Create;
var
  i: Integer;
begin
  for i := Low(NoticeList) to High(NoticeList) do begin
    NoticeList[i].sMsg := '';
    NoticeList[i].sList := nil;
    NoticeList[i].bo0C := True;
  end;
end;

destructor TNoticeManager.Destroy;
var
  i: Integer;
begin
  for i := Low(NoticeList) to High(NoticeList) do begin
    if NoticeList[i].sList <> nil then
      NoticeList[i].sList.Free;
  end;
  inherited;
end;
procedure TNoticeManager.LoadingNotice(); //00491D54
var
  sFileName: string;
  i: Integer;
begin
  for i := Low(NoticeList) to High(NoticeList) do begin
    if NoticeList[i].sMsg = '' then Continue;
    sFileName := g_Config.sNoticeDir + NoticeList[i].sMsg + '.txt';
    if FileExists(sFileName) then begin
      try
        if NoticeList[i].sList = nil then NoticeList[i].sList := TStringList.Create;
        NoticeList[i].sList.LoadFromFile(sFileName);
      except
        MainOutMessage('Error in loading notice text. file name is ' + sFileName);
      end;
    end;
  end;
end;
function TNoticeManager.GetNoticeMsg(sStr: string; LoadList: TStringList): Boolean; //00491EA0
var
  bo15: Boolean;
  n14: Integer;
  sFileName: string;
begin
  Result := False;
  bo15 := True;
  for n14 := Low(NoticeList) to High(NoticeList) do begin
    if CompareText(NoticeList[n14].sMsg, sStr) = 0 then begin
      if NoticeList[n14].sList <> nil then begin
        LoadList.AddStrings(NoticeList[n14].sList);
        Result := True;
      end;
      bo15 := False;
    end;
  end; // while
  if not bo15 then exit;
  for n14 := Low(NoticeList) to High(NoticeList) do begin
    if NoticeList[n14].sMsg = '' then begin
      sFileName := g_Config.sNoticeDir + sStr + '.txt';
      if FileExists(sFileName) then begin
        try
          if NoticeList[n14].sList = nil then NoticeList[n14].sList := TStringList.Create;
          NoticeList[n14].sList.LoadFromFile(sFileName);
          LoadList.AddStrings(NoticeList[n14].sList);
        except
          MainOutMessage('Error in loading notice text. file name is ' + sFileName);
        end;
        NoticeList[n14].sMsg := sStr;
        Result := True;
        break;
      end;
    end;
  end;
end;
end.

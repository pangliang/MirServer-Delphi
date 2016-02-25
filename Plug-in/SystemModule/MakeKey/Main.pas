unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Spin, Mask, RzEdit, Share;

type
  TFrmMakeKey = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label3: TLabel;
    Label6: TLabel;
    Label5: TLabel;
    UserKeyEdit: TEdit;
    UserDateTimeEdit: TRzDateTimeEdit;
    SpinEditCount: TSpinEdit;
    RzDateTimeEditRegister: TRzDateTimeEdit;
    UserModeRadioGroup: TRadioGroup;
    Label4: TLabel;
    EditUserName: TEdit;
    EditEnterKey: TEdit;
    Label9: TLabel;
    MakeKeyButton: TButton;
    ButtonExit: TButton;
    Label2: TLabel;
    SpinEditPersonCount: TSpinEdit;
    RadioGroupLicDay: TRadioGroup;
    LabelInfo: TLabel;
    procedure MakeKeyButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ButtonExitClick(Sender: TObject);
    procedure RadioGroupLicDayClick(Sender: TObject);
    procedure RzDateTimeEditRegisterChange(Sender: TObject);
  private
    { Private declarations }
    SpinEditVersion: TSpinEdit;
    LabelVersion: TLabel;
    function InitPulg(nPlug: integer): Boolean;
    procedure UnInitPulg(nPlug: integer);
    procedure MakeVersionCustom();
  public
    { Public declarations }
  end;

var
  FrmMakeKey: TFrmMakeKey;
  N_SOFTTYPE: integer = 88888888;
implementation
uses Common, EDcodeUnit;
{$R *.dfm}

function GetFilesSize(FileName: string): integer; //获取文件大小
var
  Size: integer;
  SearchRec: TSearchRec;
begin //获取文件大小MB or KB or Byte
  Size := 0;
  FindFirst(FileName, faAnyFile, SearchRec);
  Size := Size + SearchRec.Size;
  FindClose(SearchRec);
  Result := Size;
end;

function GetDayCount(MaxDate, MinDate: TDateTime): integer;
var
  Day: LongInt;
begin
  Day := Trunc(MaxDate) - Trunc(MinDate);
  if Day > 0 then Result := Day else Result := 0;
end;

function Str_ToInt(Str: string; def: LongInt): LongInt;
begin
  Result := def;
  if Str <> '' then begin
    if ((word(Str[1]) >= word('0')) and (word(Str[1]) <= word('9'))) or
      (Str[1] = '+') or (Str[1] = '-') then try
      Result := StrToInt64(Str);
    except
    end;
  end;
end;

procedure TFrmMakeKey.MakeVersionCustom();
begin
  LabelInfo.Visible := False;
  SpinEditVersion := TSpinEdit.Create(Owner);
  LabelVersion := TLabel.Create(Owner);
  SpinEditVersion.Parent := FrmMakeKey;
  LabelVersion.Parent := FrmMakeKey;
  SpinEditVersion.MaxValue := 2000000000;
  SpinEditVersion.MinValue := 0;
  SpinEditVersion.Value := 240621028;
  SpinEditVersion.Left := 192;
  SpinEditVersion.Top := 212;
  LabelVersion.Left := 120;
  LabelVersion.Top := 216;
  LabelVersion.Caption := '输入用户QQ：';
end;

procedure TFrmMakeKey.MakeKeyButtonClick(Sender: TObject);
var
  nUserCode: integer;
  sUserCode: string;
  sUserName: string;
  btUserMode: Byte;
  wCount: integer;
  wPersonCount: integer;
  sEnterKey: string;
  m_nCheckCode: integer;
  s01: string;
  sVersionType: string;
  nUserLicense: integer;
  RegisterInfo: pTRegisterInfo;

  m_UserMode: Byte;
  m_wCount: word;
  m_ErrorInfo: integer;
  m_btStatus: Byte;
  List: TStringList;
begin
  MakeKeyButton.Enabled := False;
  Inc(nCheckCode, 6);
  if not boEnterKey then Exit;
  SetLength(sUserCode, 32);
  SetLength(sUserName, 32);
  sUserCode := Trim(UserKeyEdit.Text);
  sUserName := Trim(EditUserName.Text);
  btUserMode := UserModeRadioGroup.ItemIndex + 1;
  case btUserMode of
    1: wCount := SpinEditCount.Value;
    2: wCount := GetDayCount(UserDateTimeEdit.Date, Date);
    3: wCount := High(word);
  end;
  wPersonCount := SpinEditPersonCount.Value;
  if sUserCode = '' then begin
    Application.MessageBox('请输入机器码！！！', '提示信息', MB_OK + MB_ICONINFORMATION);
    MakeKeyButton.Enabled := True;
    Exit;
  end;
  if sUserName = '' then begin
    Application.MessageBox('请输入用户名！！！', '提示信息', MB_OK + MB_ICONINFORMATION);
    MakeKeyButton.Enabled := True;
    Exit;
  end;
  if InitPulg(0) then begin
    Dec(nCheckCode);
    TInit(Init)(N_SOFTTYPE, 0, 0, Now, nil);
    GetLicenseShare := GetFunAddr(2);
    TGetLicense(GetLicenseShare)(m_UserMode, m_wCount, m_ErrorInfo, m_btStatus);
    if (m_ErrorInfo = 0) and (m_UserMode = 3) and (m_btStatus = 0) then begin
      Dec(nCheckCode);
      GetRegisterCodeShare := GetFunAddr(0);
      if Assigned(GetRegisterCodeShare) then begin
        Dec(nCheckCode);
        sRegisterCode := StrPas(TGetRegisterCode(GetRegisterCodeShare));
        nUserLicense := GetUniCode(sRegisterCode);
        if InitPulg(1) then begin
          Dec(nCheckCode);
          InitLicense := TGetFunctionAddr(GetFunctionAddr)(0);
          UnInitLicense := TGetFunctionAddr(GetFunctionAddr)(1);
          MakeRegisterInfo := TGetFunctionAddr(GetFunctionAddr)(4);
          GetUserVersion := TGetFunctionAddr(GetFunctionAddr)(10);
          if @GetUserVersion <> nil then begin
            List := TStringList.Create;
            List.Add(IntToStr(nVersion));
            List.SaveToFile(sVersion);
            List.Free;
          end;
{$IF nVersion = nSuperUser}
          try
            New(RegisterInfo);
            RegisterInfo^.sRegisterName := PChar(sUserCode);
            RegisterInfo^.sUserName := PChar(sUserName);
            RegisterInfo^.btUserMode := btUserMode;
            RegisterInfo^.nUserCount := wCount;
            RegisterInfo^.nPersonCount := wPersonCount;
            RegisterInfo^.RegisterDate := Now;
            RegisterInfo^.nLicense := nUserLicense;
            RegisterInfo^.nVersion := SpinEditVersion.Value;
            TInitLicense(InitLicense)(SpinEditVersion.Value, nUserLicense, 0, 0, 0, Date, PChar(sUserName));
            sEnterKey := StrPas(TMakeRegisterInfo(MakeRegisterInfo)(RegisterInfo));
            EditEnterKey.Text := sEnterKey;
            TUnInitLicense(UnInitLicense);
            Dispose(RegisterInfo);
          except
            EditEnterKey.Text := '';
          end;
{$ELSE}
          m_nCheckCode := integer(boEnterKey);
          try
            if Decode(sVersion, sVersionType) then begin
              Dec(nCheckCode);
              if Str_ToInt(sVersionType, 0) = nVersion then begin
                Dec(nCheckCode);
                New(RegisterInfo);
                RegisterInfo^.sRegisterName := PChar(sUserCode);
                RegisterInfo^.sUserName := PChar(sUserName);
                RegisterInfo^.btUserMode := btUserMode;
                RegisterInfo^.nUserCount := wCount;
                RegisterInfo^.nPersonCount := wPersonCount;
                RegisterInfo^.RegisterDate := Now;
                RegisterInfo^.nLicense := nUserLicense + nCheckCode;
                RegisterInfo^.nVersion := nVersion - nCheckCode;
                TInitLicense(InitLicense)(nVersion, nUserLicense, 0, 0, 0, Date, PChar(sUserName));
                sEnterKey := StrPas(TMakeRegisterInfo(MakeRegisterInfo)(RegisterInfo));
                EditEnterKey.Text := sEnterKey;
                TUnInitLicense(UnInitLicense);
                Dispose(RegisterInfo);
              end;
            end;
          except
            EditEnterKey.Text := '';
          end;
{$IFEND}
          //Caption := '注册码长度：' + IntToStr(Length(EditEnterKey.Text));
          wCount := GetDayCount(UserDateTimeEdit.Date, RzDateTimeEditRegister.Date);
          case UserModeRadioGroup.ItemIndex of
            0: s01 := '次数限制';
            1: s01 := '日期限制';
            2: s01 := '无限制！！！';
            else begin
                s01 := '未知';
              end;
          end;
          UnInitPulg(0);
          UnInitPulg(1);
          if UserModeRadioGroup.ItemIndex = 2 then
            Application.MessageBox(PChar(s01), '提示信息', MB_OK + MB_ICONINFORMATION)
          else
            Application.MessageBox(PChar('注册类型：' + s01 + #13 + '授权天数：' + IntToStr(wCount)), '提示信息', MB_OK + MB_ICONINFORMATION);
        end;
      end;
    end;
  end;
  MakeKeyButton.Enabled := True;
end;

function TFrmMakeKey.InitPulg(nPlug: integer): Boolean;
var
  sPlugLibFileName: string;
begin
  Result := False;
  case nPlug of
    0: begin
        sPlugLibFileName := ExtractFilePath(ParamStr(0)) + 'License.dll';
        if FileExists(sPlugLibFileName) then begin
          PlugHandleList[nPlug] := LoadLibrary(PChar(sPlugLibFileName));
          if PlugHandleList[nPlug] > 0 then begin
            @Init := GetProcAddress(PlugHandleList[nPlug], 'Init');
            @GetFunAddr := GetProcAddress(PlugHandleList[nPlug], 'GetFunAddr');
            if @GetFunAddr <> nil then Result := True;
          end;
        end;
      end;
    1: begin
        sPlugLibFileName := ExtractFilePath(ParamStr(0)) + 'SystemModule.dll';
        if FileExists(sPlugLibFileName) then begin
          PlugHandleList[nPlug] := LoadLibrary(PChar(sPlugLibFileName));
          if PlugHandleList[nPlug] > 0 then begin
            @GetFunctionAddr := GetProcAddress(PlugHandleList[nPlug], 'GetFunAddr');
            if @GetFunctionAddr <> nil then Result := True;
          end;
        end;
      end;
  end;
end;

procedure TFrmMakeKey.UnInitPulg(nPlug: integer);
begin
  case nPlug of
    0: begin
        if PlugHandleList[nPlug] > 0 then begin
          UnInit := GetProcAddress(PlugHandleList[nPlug], 'UnInit');
          if Assigned(UnInit) then begin
            UnInit;
          end;
          FreeLibrary(PlugHandleList[nPlug]);
        end;
      end;
    1: begin
        if PlugHandleList[nPlug] > 0 then begin
          FreeLibrary(PlugHandleList[nPlug]);
        end;
      end;
  end;
end;

procedure TFrmMakeKey.FormCreate(Sender: TObject);
var
  UserMode: Byte;
  wCount: word;
  ErrorInfo: integer;
  btStatus: Byte;
  MyInfo: string;
  AppFilesSize: string;
  nFilesSize, nStartFilesSize, nEndFilesSize: integer;
begin
  Application.ShowMainForm := False;
  boEnterKey := False;
  nCheckCode := 4;
  Moudle := 0;
  FillChar(PlugHandleList, SizeOf(PlugHandleList), 0);
  if InitPulg(0) then begin
    if Assigned(Init) and Assigned(GetFunAddr) then begin
      TInit(Init)(N_SOFTTYPE, 0, 0, Now, nil);
      Dec(nCheckCode);
      GetLicenseShare := GetFunAddr(2);
      if Assigned(GetLicenseShare) then begin
        TGetLicense(GetLicenseShare)(UserMode, wCount, ErrorInfo, btStatus);
        Dec(nCheckCode);
        Inc(nCheckCode, ErrorInfo);
        if (ErrorInfo <= 0) and (UserMode = 3) and (btStatus <= 0) then begin
          GetRegisterCodeShare := GetFunAddr(1);
          if Assigned(GetRegisterCodeShare) then begin
            sRegisterCode := StrPas(TGetRegisterCode(GetRegisterCodeShare));
            boEnterKey := True;
            Dec(nCheckCode);
{$IF nVersion = nSuperUser}
            MakeVersionCustom();
{$IFEND}
            if Decode(sMyInfo, MyInfo) then begin
              Dec(nCheckCode);
              Application.ShowMainForm := True;
              //nAppFilesSize := GetFilesSize(Application.ExeName);
              {if Decode(sAppFilesSize, AppFilesSize) then begin
                Dec(nCheckCode);
                nFilesSize := Str_ToInt(AppFilesSize, 0);
                nStartFilesSize := nFilesSize - 10000;
                nEndFilesSize := nFilesSize + 10000;
                if (nStartFilesSize >= nAppFilesSize) and (nEndFilesSize <= nAppFilesSize) then begin
                  Dec(nCheckCode);
                end;
                LabelInfo.Caption := MyInfo;
              end;}
              LabelInfo.Caption := MyInfo;
            end else Application.Terminate;
          end else Application.Terminate;
        end else begin
          OpenDiaLog := GetFunAddr(3);
          if Assigned(OpenDiaLog) then begin
            TOpenDiaLog(OpenDiaLog);
            Application.Terminate;
          end else Application.Terminate;
        end;
      end else Application.Terminate;
      UnInitPulg(0);
    end else Application.Terminate;
    RzDateTimeEditRegister.Date := Date;
    UserDateTimeEdit.Date := Date + 365;
    SpinEditCount.Value := High(word);
    SpinEditPersonCount.Value := High(word);
  end else Application.Terminate;
end;

procedure TFrmMakeKey.ButtonExitClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmMakeKey.RadioGroupLicDayClick(Sender: TObject);
const
  nYear = 365;
begin
  case RadioGroupLicDay.ItemIndex of
    0: UserDateTimeEdit.Date := RzDateTimeEditRegister.Date + 30;
    1: UserDateTimeEdit.Date := RzDateTimeEditRegister.Date + nYear div 2;
    2: UserDateTimeEdit.Date := RzDateTimeEditRegister.Date + nYear;
    3: UserDateTimeEdit.Date := RzDateTimeEditRegister.Date + nYear + nYear div 2;
    4: UserDateTimeEdit.Date := RzDateTimeEditRegister.Date + nYear * 2;
  end;
end;

procedure TFrmMakeKey.RzDateTimeEditRegisterChange(Sender: TObject);
const
  nYear = 365;
begin
  case RadioGroupLicDay.ItemIndex of
    0: UserDateTimeEdit.Date := RzDateTimeEditRegister.Date + 30;
    1: UserDateTimeEdit.Date := RzDateTimeEditRegister.Date + nYear div 2;
    2: UserDateTimeEdit.Date := RzDateTimeEditRegister.Date + nYear;
    3: UserDateTimeEdit.Date := RzDateTimeEditRegister.Date + nYear + nYear div 2;
    4: UserDateTimeEdit.Date := RzDateTimeEditRegister.Date + nYear * 2;
  end;
end;

end.


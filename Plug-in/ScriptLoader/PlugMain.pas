//=============================================================================
//调用函数说明:
//   发送文字到主程序控制台上:
//     procedure MainOutMessasge(sMsg:String;nMode:integer)
//     sMsg 为要发送的文本内容
//     nMode 为发送模式，0为立即在控制台上显示，1为加入显示队列，稍后显示
//
//   取得0-255所代表的颜色
//     function GetRGB(bt256:Byte):TColor;
//     bt256 要查询数字
//     返回值 为代表的颜色
//
//   发送广播文字：
//     procedure SendBroadCastMsg(sMsg:String;MsgType:TMsgType);
//     sMsg 要发送的文字
//     MsgType 文字类型
//=============================================================================
unit PlugMain;

interface
uses
  Windows, Graphics, SysUtils, Des, IniFiles;
procedure InitPlug(AppHandle: THandle; boLoadSucced: Boolean);
procedure UnInitPlug();
function DeCodeText(sText: string): string;
function SearchIPLocal(sIPaddr: string): string;
function DecodeString_3des(Source, Key: string): string;
function EncodeString_3des(Source, Key: string): string;
function StartRegisterLicense(sRegisterCode: string): Boolean;
function CheckLicense(sRegisterCode: string): Boolean;
procedure Open();
function GetRegisterName(): string;
implementation

uses Module, QQWry, DESTR, Share, DiaLogMain, HardInfo, MD5EncodeStr;
function DecodeString_3des(Source, Key: string): string;
var
  Decode: TDCP_3des;
begin
  try
    Result := '';
    Decode := TDCP_3des.Create(nil);
    Decode.InitStr(Key);
    Decode.Reset;
    Result := Decode.DecryptString(Source);
    Decode.Reset;
    Decode.Free;
  except
    Result := '';
  end;
end;

function EncodeString_3des(Source, Key: string): string;
var
  Encode: TDCP_3des;
begin
  try
    Result := '';
    Encode := TDCP_3des.Create(nil);
    Encode.InitStr(Key);
    Encode.Reset;
    Result := Encode.EncryptString(Source);
    Encode.Reset;
    Encode.Free;
  except
    Result := '';
  end;
end;
//=============================================================================
//加载插件模块时调用的初始化函数
//参数：Apphandle 为主程序句柄
//=============================================================================
function GetRegisterName(): string;
var
  sRegisterName, Str: string;
  n64: Int64;
begin
  sRegisterName := '';
  Str := '';
  if sRegisterName = '' then begin
    try
      sRegisterName := Trim(HardInfo.GetScsisn); //硬盘序列号
    except
      sRegisterName := '';
    end;
  end;

  if sRegisterName = '' then begin
    try
      sRegisterName := Trim(HardInfo.GetCPUInfo_); //CPU序列号
    except
      sRegisterName := '';
    end;
  end;

  if sRegisterName = '' then begin
    try
      sRegisterName := Trim(HardInfo.GetAdapterMac(0)); //网卡地址
    except
      sRegisterName := '';
    end;
  end;

  if sRegisterName <> '' then begin
    Str := EncodeString_3des(sRegisterName, sDecryKey);
    Result := RivestStr(Str);
  end else Result := '';
end;

function CheckLicense(sRegisterCode: string): Boolean;
var
  sTempStr: string;
begin
  Result := False;
  if m_sRegisterName <> '' then begin
    sTempStr := EncodeString_3des(m_sRegisterName, sDecryKey);
    sTempStr := RivestStr(sTempStr);
    if CompareText(sTempStr, sRegisterCode) = 0 then Result := True;
  end;
end;

function StartRegisterLicense(sRegisterCode: string): Boolean;
var
  Config: TInifile;
  sTempStr: string;
  sFileName: string;
begin
  Result := False;
  if CheckLicense(sRegisterCode) then begin
    sFileName := ExtractFilePath(Paramstr(0)) + '!Setup.txt';
    Config := TInifile.Create(sFileName);
    if Config <> nil then begin
      Config.WriteString('Reg', 'RegisterName', m_sRegisterName);
      Config.WriteString('Reg', 'RegisterCode', sRegisterCode);
      Config.Free;
      Result := True;
    end;
  end;
end;

function GetLicense(sRegisterName: string): Integer;
var
  Config: TInifile;
  sFileName: string;
  sRegisterCode: string;
begin
  Result := 0;
  sFileName := ExtractFilePath(Paramstr(0)) + '!Setup.txt';
  if FileExists(sFileName) then begin
    Config := TInifile.Create(sFileName);
    if Config <> nil then begin
      sRegisterCode := Config.ReadString('Reg', 'RegisterCode', '');
      if sRegisterCode <> '' then begin
        if CheckLicense(sRegisterCode) then Result := 1000;
      end;
      Config.Free;
    end;
  end;
end;

procedure Open();
begin
  FrmDiaLog := TFrmDiaLog.Create(nil);
  FrmDiaLog.Open;
  FrmDiaLog.Free;
end;

procedure InitPlug(AppHandle: THandle; boLoadSucced: Boolean);
var
  boRegister: Boolean;
begin
  boRegister := False;
  nRegister := 0;
  m_sRegisterName := GetRegisterName();
  if GetLicense(m_sRegisterName) = 1000 then begin
    nRegister := 1000;
  end else begin
    Open();
    nRegister := GetLicense(m_sRegisterName);
  end;
  if boLoadSucced and (nRegister = 1000) then
    MainOutMessasge(sStartLoadPlugSucced, 0)
  else MainOutMessasge(sStartLoadPlugFail, 0);
end;
//=============================================================================
//退出插件模块时调用的结束函数
//=============================================================================
procedure UnInitPlug();
begin
  {
    写上相应处理代码;
  }
  MainOutMessasge(sUnLoadPlug, 0);
end;

//=============================================================================
//游戏文本配置信息解码函数(一般用于加解密脚本)
//参数：sText 为要解码的字符串
//返回值：返回解码后的字符串(返回的字符串长度不能超过1024字节，超过将引起错误)
//=============================================================================
function DeCodeScript(sText: string): string;
begin
  try
    Result := DecodeString_3des(DecryStrHex(sText, sDecryKey), sDecryKey);
  except
    Result := '';
  end;
end;

function DeCodeText(sText: string): string;
begin
  Result := '';
  if (sText <> '') and (sText[1] <> ';') and (nCheckCode = 5) and (nRegister = 1000) then begin
    Result := DeCodeScript(sText);
  end;
  //Result:='返回值：返回解码后的字符串';
end;

//=============================================================================
//IP所在地查询函数
//参数：sIPaddr 为要查询的IP地址
//返回值：返回IP所在地文本信息(返回的字符串长度不能超过255字节，超过会被截短)
//=============================================================================

function SearchIPLocal(sIPaddr: string): string;
var
  QQWry: TQQWry;
  s02, s03: string;
begin
  try
    QQWry := TQQWry.Create(sIPFileName);
    s02 := QQWry.GetIPMsg(QQWry.GetIPRecordID(sIPaddr))[2];
    s03 := QQWry.GetIPMsg(QQWry.GetIPRecordID(sIPaddr))[3];
    Result := Format('%s%s', [s02, s03]);
    QQWry.Free;
  except
    Result := '';
  end;
end;

end.


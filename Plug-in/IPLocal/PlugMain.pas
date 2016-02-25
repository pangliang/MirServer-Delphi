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
  Windows, Graphics, SysUtils, StrUtils, Classes;
procedure InitPlug(AppHandle: THandle);
procedure UnInitPlug();
function DeCodeText(sText: string): string;
function SearchIPLocal(sIPaddr: string): string;

implementation

uses Module, QQWry, DES, Share;
//=============================================================================
//加载插件模块时调用的初始化函数
//参数：Apphandle 为主程序句柄
//=============================================================================
procedure InitPlug(AppHandle: THandle);
begin
  MainOutMessasge(sStartLoadPlug, 0);
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
//游戏日志信息处理函数
//返回值：True 代表不调用默认游戏日志处理函数，False 调用默认游戏日志处理函数
//=============================================================================
function GameDataLog(sLogMsg: string): Boolean;
begin
  {
    写上相应处理游戏日志代码;
  }
  Result := False;
end;

//=============================================================================
//游戏文本配置信息解码函数(一般用于加解密脚本)
//参数：sText 为要解码的字符串
//返回值：返回解码后的字符串(返回的字符串长度不能超过1024字节，超过将引起错误)
//=============================================================================
function DeCodeText(sText: string): string;
begin
  {try
    if (sText<>'') and (sText[1]<>';') then
      Result:=DecryStrHex(sText,sKey);
  except
    Result:='';
  end;}
  //Result:='返回值：返回解码后的字符串';
end;

//=============================================================================
//IP所在地查询函数
//参数：sIPaddr 为要查询的IP地址
//返回值：返回IP所在地文本信息(返回的字符串长度不能超过255字节，超过会被截短)
//=============================================================================

function DecryStrHex(StrHex: string): string;
//UniCode -> 汉字
  function UniCode2Chinese(AiUniCode: Integer): string;
  var
    ch, cl: string[3];
    s: string;
  begin
    s := IntToHex(AiUniCode, 2);
    cl := '$' + Copy(s, 1, 2);
    ch := '$' + Copy(s, 3, 2);
    s := Chr(StrToInt(ch)) + Chr(StrToInt(cl)) + #0;
    Result := WideCharToString(pWideChar(s));
  end;
var
  nLength: Integer;
  I: Integer;
  Hexstr: string;
  nAm: Integer;
begin
  I := 1;
  nLength := Length(StrHex);
  while I <= nLength do begin
    Hexstr := Copy(StrHex, I, 4);
    nAm := StrToInt('$' + Hexstr);
    if nAm < 128 then begin
      Result := Result + Chr(nAm);
    end else
    if nAm > 127 then begin
      Result := Result + UniCode2Chinese(nAm);
    end;
    Inc(I, 4);
  end;
end;

function EncryStrHex(StrHex: string): string;
//汉字 -> UniCode
  function Chinese2UniCode(AiChinese: string): Integer;
  var
    ch, cl: string[2];
    a: array[1..2] of char;
  begin
    StringToWideChar(Copy(AiChinese, 1, 2), @(a[1]), 2);
    ch := IntToHex(Integer(a[2]), 2);
    cl := IntToHex(Integer(a[1]), 2);
    Result := StrToInt('$' + ch + cl);
  end;
var
  nLength: Integer;
  I: Integer;
  Hexstr: string;
begin
  I := 1;
  nLength := Length(StrHex);
  while I <= nLength do begin
    if (ByteType(StrHex, I) = mbSingleByte) and (StrHex <> '') then begin
      Hexstr := MidStr(WideString(StrHex), I, 1);
      if Hexstr <> '' then
        Result := Result + IntToHex(Chinese2UniCode(Hexstr), 4);
    end else
    if ((ByteType(StrHex, I) = mbLeadByte) or (ByteType(StrHex, I) = mbTrailByte)) and (StrHex <> '') then begin
      Hexstr := MidStr(WideString(StrHex), I, 1);
      if Hexstr <> '' then
        Result := Result + IntToHex(Chinese2UniCode(Hexstr), 4);
    end;
    Inc(I);
  end;
end;

function SearchIPLocal(sIPaddr: string): string;
var
  QQWry: TQQWry;
  s02, s03: string;
  IPRecordID: int64;
  sLOCAL: string;
  IPData: TStringlist;
begin
  try
    QQWry := TQQWry.Create(sIPFileName);
    IPRecordID := QQWry.GetIPDataID(sIPaddr);
    IPData := TStringlist.Create;
    QQWry.GetIPDataByIPRecordID(IPRecordID, IPData);
    QQWry.Destroy;
    Result := Trim(IPData.Strings[2]) + Trim(IPData.Strings[3]);
    IPData.Free;
  except
    Result := '';
  end;
end;

end.


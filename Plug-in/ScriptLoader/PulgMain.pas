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
  Windows, Graphics, SysUtils, PlugManage;
procedure InitPlug(AppHandle:THandle);
procedure UnInitPlug();
function  DeCodeText(sText:String):String;
function  SearchIPLocal(sIPaddr:String):String;

implementation

uses QQWry, Share;
//=============================================================================
//加载插件模块时调用的初始化函数
//参数：Apphandle 为主程序句柄
//=============================================================================
procedure InitPlug(AppHandle:THandle);
begin

end;
//=============================================================================
//退出插件模块时调用的结束函数
//=============================================================================
procedure UnInitPlug();
begin
{
  写上相应处理代码;
}
  MainOutMessasge(sUnLoadPlug,0);
end;
//=============================================================================
//游戏日志信息处理函数
//返回值：True 代表不调用默认游戏日志处理函数，False 调用默认游戏日志处理函数
//=============================================================================
function GameDataLog(sLogMsg:String):Boolean;
begin
{
  写上相应处理游戏日志代码;
}
  Result:=False;
end;

//=============================================================================
//游戏文本配置信息解码函数(一般用于加解密脚本)
//参数：sText 为要解码的字符串
//返回值：返回解码后的字符串(返回的字符串长度不能超过1024字节，超过将引起错误)
//=============================================================================
function DeCodeText(sText:String):String;
begin

end;

//=============================================================================
//IP所在地查询函数
//参数：sIPaddr 为要查询的IP地址
//返回值：返回IP所在地文本信息(返回的字符串长度不能超过255字节，超过会被截短)
//=============================================================================

function SearchIPLocal(sIPaddr:String):String;
var
  QQWry: TQQWry;
begin
  try
    QQWry:=TQQWry.Create(sIPDataFileName);
    Result:=QQWry.GetIPMsg(QQWry.GetIPRecordID(sIPaddr))[2]+QQWry.GetIPMsg(QQWry.GetIPRecordID(sIPaddr))[3];
    QQWry.Free;
  except
    Result:='No Find';
  end;
end;

end.

{===============================================================================
TQQWry
 Class with QQWry.DAT - by 冷风 (coldwind@citiz.net)

   Status:  Freeware
 Compiler:  Delphi4, Delphi5, Delphi6, Delphi7
  Version:  1.0
 Lastdate:  19 March 2005
      Url:  http://51tec.vicp.net/

 　　在此unit中，实现了对于纯真网络(www.cz88.net)的IP数据库的读取，该数据库是在
 搜捕的基础上实现的，现广泛应用于QQ和各种论坛上，主要目的是获取IP地址和所在区域
 的对应关系。
 　　本unit中，对于所有的输入参数没有进行校验，请自行在输入参数前确定参数无误，
 此外，对于如何使用，在本unit中进行了详细的注解，也有例程进行了一定说明。
 　　对于IP的搜索，本程序仅仅通过二分法进行查找。

--------------------------------------------------------------------------------
===============================================================================}

unit QQWry;

interface

uses
  SysUtils, Classes, Controls, Math, Dialogs;

type
  TQQWry = class(TObject)
  public
    constructor Create(cQQWryFileName: string);
    destructor Destroy; override;
    function GetQQWryFileName: string;
    function GetQQWryFileSize: Cardinal;
    function GetIPRecordNum: Cardinal;
    function GetQQWryDate: TDate;
    function GetQQWryDataFrom: string;
    function GetIPLocation(IPLocationOffset: Cardinal): TStringList;
    function GetIPMsg(IPRecordID: Cardinal): TStringList;
    function GetIPRecordID(IP: string): Cardinal;
    function GetIPValue(IP: string): Cardinal;
  private
    QQWryFileName: string;
    QQWryFileStream: TFileStream;
    QQWryFileSize: Cardinal;
    IPRecordNum: Cardinal;
    FirstIPIndexOffset, LastIPIndexOffset: Cardinal;
  end;

implementation

///**
//* 构造一个TQQWry即QQIP地址数据库的对象
//* @param cQQWryFileName QQIP数据库文件的全名（包括路径），请确认文件存在和可读性
//* @return 无
//*/
constructor TQQWry.Create(cQQWryFileName: string);
begin
  inherited Create;
  QQWryFileName := cQQWryFileName;
  QQWryFileStream := TFileStream.Create(QQWryFileName, fmOpenRead or fmShareDenyWrite, 0);
  QQWryFileSize := QQWryFileStream.Size;
  QQWryFileStream.Read(FirstIPIndexOffset, 4);
  QQWryFileStream.Read(LastIPIndexOffset, 4);
  IPRecordNum := (LastIPIndexOffset - FirstIPIndexOffset) div 7 + 1;
end;

///**
//* 析构函数，释放TQQWry对象，释放文件数据流对象
//* @param  无
//* @return 无
//*/
destructor TQQWry.Destroy;
begin
  QQWryFileStream.Free;
  inherited Destroy;
end;

///**
//* 获取QQIP数据库文件的全名（包括路径）
//* @param  无
//* @return QQIP数据库文件的全名（包括路径）  string
//*/
function TQQWry.GetQQWryFileName: string;
begin
  Result := QQWryFileName;
end;

///**
//* 获取QQIP数据库文件大小
//* @param  无
//* @return QQIP数据库文件大小  Cardinal
//*/
function TQQWry.GetQQWryFileSize: Cardinal;
begin
  Result := QQWryFileSize;
end;

///**
//* 获取QQIP数据库内含有的IP地址信息记录条数
//* @param  无
//* @return QQIP数据库文件大小  Cardinal
//*/
function TQQWry.GetIPRecordNum: Cardinal;
begin
  Result := IPRecordNum;
end;

///**
//* 获取当前QQIP数据库的更新日期
//* @param  无
//* @return QQIP当前数据库的更新日期  TDate
//*/
function TQQWry.GetQQWryDate: TDate;
var
  DateString: string;
begin
  DateString := GetIPMsg(GetIPRecordNum)[3];
  DateString := Copy(DateString, 1, Pos('IP数据', DateString) - 1);
  DateString := StringReplace(DateString, '年', '-', [rfReplaceAll, rfIgnoreCase]);
  DateString := StringReplace(DateString, '月', '-', [rfReplaceAll, rfIgnoreCase]);
  DateString := StringReplace(DateString, '日', '-', [rfReplaceAll, rfIgnoreCase]);
  Result := StrToDate(DateString);
end;

///**
//* 获取当前QQIP数据库的来源信息
//* @param  无
//* @return 当前QQIP数据库的来源信息  string
//*/
function TQQWry.GetQQWryDataFrom: string;
begin
  Result := GetIPMsg(GetIPRecordNum)[2];
end;

///**
//* 给定一个IP国家地区记录的偏移，返回该IP地址的信息
//* @param  IPLocationOffset  国家记录的偏移  Cardinal
//* @return IP地址信息（国家信息/地区信息)  string
//*/
function TQQWry.GetIPLocation(IPLocationOffset: Cardinal): TStringList;
const
  //实际信息字串存放位置的重定向模式
  REDIRECT_MODE_1 = 1;
  REDIRECT_MODE_2 = 2;
var
  RedirectMode: byte;
  CountryFirstOffset, CountrySecondOffset: Cardinal;
  CountryMsg, AreaMsg: string;
  ///**
  //* 给定一个文件偏移值，返回在数据文件中该偏移下的字符串，即读取到0结尾的字符前
  //* @param  StringOffset  字符串在文件中的偏移值  Cardinal
  //* @return 字符串  string
  //*/
  function ReadString(StringOffset: Cardinal): string;
  var
    ReadByte: char;
  begin
    Result := '';
    QQWryFileStream.Seek(StringOffset, soFromBeginning);
    QQWryFileStream.Read(ReadByte, 1);
    while Ord(ReadByte) <> 0 do begin
      Result := Result + ReadByte;
      QQWryFileStream.Read(ReadByte, 1);
    end;
  end;
  ///**
  //* 给定一个地区信息偏移值，返回在数据文件中该偏移量下的地区信息
  //* @param  AreaOffset 地区信息在文件中的偏移值  Cardinal;
  //* @return 地区信息字符串  string
  //*/
  function ReadArea(AreaOffset: Cardinal): string;
  var
    ModeByte: byte;
    ReadAreaOffset: Cardinal;
  begin
    QQWryFileStream.Seek(AreaOffset, soFromBeginning);
    QQWryFileStream.Read(ModeByte, 1);
    if (ModeByte = REDIRECT_MODE_1) or (ModeByte = REDIRECT_MODE_2) then begin
      QQWryFileStream.Read(ReadAreaOffset, 3);
      if ReadAreaOffset = 0 then Result := '未知地区'
      else Result := ReadString(ReadAreaOffset);
    end else begin
      Result := ReadString(AreaOffset);
    end;
  end;
begin
  //跳过4个字节，该4字节内容为该条IP信息里IP地址段中的终止IP值
  QQWryFileStream.Seek(IPLocationOffset + 4, soFromBeginning);
  //读取国家信息的重定向模式值
  QQWryFileStream.Read(RedirectMode, 1);

  //重定向模式1的处理
  if RedirectMode = REDIRECT_MODE_1 then begin
    //模式值为1，则后3个字节的内容为国家信息的重定向偏移值
    QQWryFileStream.Read(CountryFirstOffset, 3);
    //进行重定向
    QQWryFileStream.Seek(CountryFirstOffset, soFromBeginning);
    //第二次读取国家信息的重定向模式
    QQWryFileStream.Read(RedirectMode, 1);
    //第二次重定向模式为模式2的处理
    if RedirectMode = REDIRECT_MODE_2 then begin
      //后3字节的内容即为第二次重定向偏移值
      QQWryFileStream.Read(CountrySecondOffset, 3);
      //读取第二次重定向偏移值下的字符串值，即为国家信息
      CountryMsg := ReadString(CountrySecondOffset);
      //若第一次重定向模式为1，进行重定向后读取的第二次重定向模式为2，
      //则地区信息存放在第一次国家信息偏移值的后面
      QQWryFileStream.Seek(CountryFirstOffset + 4, soFromBeginning);
      //第二次重定向模式不是模式2的处理
    end else begin
      CountryMsg := ReadString(CountryFirstOffset);
    end;
    //在重定向模式1下读地区信息值
    AreaMsg := ReadArea(QQWryFileStream.Position);
    //重定向模式2的处理
  end else if RedirectMode = REDIRECT_MODE_2 then begin
    QQWryFileStream.Read(CountrySecondOffset, 3);
    CountryMsg := ReadString(CountrySecondOffset);
    AreaMsg := ReadArea(IPLocationOffset + 8);
    //不是重定向模式的处理，存放的即是IP地址信息
  end else begin
    CountryMsg := ReadString(QQWryFileStream.Position - 1);
    AreaMsg := ReadArea(QQWryFileStream.Position);
  end;
  Result := TStringList.Create;
  Result.Add(CountryMsg);
  Result.Add(AreaMsg);
end;

///**
//* 给定一个IP地址信息记录号，返回该项记录的信息
//* @param  IPRecordID  IP地址信息记录号  Cardinal
//* @return 记录号信息（含3个部分：①起始IP地址  ②终止IP地址  ③国家信息/地区信息)  TStringlist
//*/
function TQQWry.GetIPMsg(IPRecordID: Cardinal): TStringList;
var
  aryStartIP: array[1..4] of byte;
  strStartIP: string;

  EndIPOffset: Cardinal;
  aryEndIP: array[1..4] of byte;
  strEndIP: string;

  I: Integer;
begin
  //根据记录ID号移到该记录号的索引处
  QQWryFileStream.Seek(FirstIPIndexOffset + (IPRecordID - 1) * 7, soFromBeginning);
  //索引的前4个字节为起始IP地址
  QQWryFileStream.Read(aryStartIP, 4);
  //后3个字节是内容区域的偏移值
  QQWryFileStream.Read(EndIPOffset, 3);

  //移至内容区域
  QQWryFileStream.Seek(EndIPOffset, soFromBeginning);
  //内容区域的前4个字节为终止IP地址
  QQWryFileStream.Read(aryEndIP, 4);

  //将起止IP地址转换为点分的形式
  strStartIP := '';
  for I := 4 downto 1 do begin
    if I <> 1 then strStartIP := strStartIP + IntToStr(aryStartIP[I]) + '.'
    else strStartIP := strStartIP + IntToStr(aryStartIP[I]);
  end;

  strEndIP := '';
  for I := 4 downto 1 do begin
    if I <> 1 then strEndIP := strEndIP + IntToStr(aryEndIP[I]) + '.'
    else strEndIP := strEndIP + IntToStr(aryEndIP[I]);
  end;

  Result := TStringList.Create;
  Result.Add(strStartIP);
  Result.Add(strEndIP);
  //获取该条记录下的IP地址信息
  //以下三者是统一的：①内容区域的偏移值  ②终止IP地址的存放位置  ③国家信息紧接在终止IP地址存放位置后
  Result.AddStrings(GetIPLocation(EndIPOffset));
end;

///**
//* 给定一个IP地址（四段点分字符串形式），返回该IP的数值
//* @param  IP  IP地址（四段点分字符串形式）  string
//* @return 该IP的数值  Cardinal
//*/
function TQQWry.GetIPValue(IP: string): Cardinal;
var
  tsIP: TStringList;
  I: Integer;
  function SplitStringToStringlist(aString: string; aSplitChar: string): TStringList;
  begin
    Result := TStringList.Create;
    while Pos(aSplitChar, aString) > 0 do begin
      Result.Add(Copy(aString, 1, Pos(aSplitChar, aString) - 1));
      aString := Copy(aString, Pos(aSplitChar, aString) + 1, Length(aString) - Pos(aSplitChar, aString));
    end;
    Result.Add(aString);
  end;
begin
  tsIP := SplitStringToStringlist(IP, '.');
  Result := 0;
  for I := 3 downto 0 do begin
    Result := Result + StrToInt(tsIP[I]) * Trunc(power(256, 3 - I));
  end;
end;

///**
//* 给定一个IP地址（四段点分字符串形式），返回该IP地址所在的记录号
//* @param  IP  IP地址（四段点分字符串形式）  string
//* @return 该IP地址所在的记录号  Cardinal
//*/
function TQQWry.GetIPRecordID(IP: string): Cardinal;
  function SearchIPRecordID(IPRecordFrom, IPRecordTo, IPValue: Cardinal): Cardinal;
  var
    CompareIPValue1, CompareIPValue2: Cardinal;
  begin
    Result := 0;
    QQWryFileStream.Seek(FirstIPIndexOffset + ((IPRecordTo - IPRecordFrom) div 2 + IPRecordFrom - 1) * 7, soFromBeginning);
    QQWryFileStream.Read(CompareIPValue1, 4);
    QQWryFileStream.Seek(FirstIPIndexOffset + ((IPRecordTo - IPRecordFrom) div 2 + IPRecordFrom) * 7, soFromBeginning);
    QQWryFileStream.Read(CompareIPValue2, 4);
    //找到了
    if (IPValue >= CompareIPValue1) and (IPValue < CompareIPValue2) then begin
      Result := (IPRecordTo - IPRecordFrom) div 2 + IPRecordFrom;
    end else
      //后半段找
      if IPValue > CompareIPValue1 then begin
        Result := SearchIPRecordID((IPRecordTo - IPRecordFrom) div 2 + IPRecordFrom + 1, IPRecordTo, IPValue);
      end else
        //前半段找
        if IPValue < CompareIPValue1 then begin
          Result := SearchIPRecordID(IPRecordFrom, (IPRecordTo - IPRecordFrom) div 2 + IPRecordFrom - 1, IPValue);
        end;
  end;
begin
  Result := SearchIPRecordID(1, GetIPRecordNum, GetIPValue(IP));
end;

end.

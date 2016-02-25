{*******************************************************}
{                                                       }
{            MiTeC Datetime Routines                    }
{           version 1.1 for Delphi 5,6                  }
{                                                       }
{       Copyright © 1997,2002 Michal Mutl               }
{                                                       }
{*******************************************************}

{$INCLUDE MITEC_DEF.INC}

unit MiTeC_Datetime;

interface

uses Windows, SysUtils;

function FormatSeconds(TotalSeconds :comp; WholeSecondsOnly: Boolean = True;
                       DisplayAll: Boolean = False; DTFormat :Boolean = false) :string;
function UTCToDateTime(UTC: DWORD): TDateTime;
function DSTDate2Date(dstDate: TSystemTime; year: word): TDateTime;
function FileTimeToDateTimeStr(FileTime: TFileTime): string;
function FiletimeToDateTime(FT: FILETIME): TDateTime;
function ParseDate(YYYYMMDD: string): TDatetime;
{$IFNDEF D6PLUS}
function DaysInMonth(const AValue: TDateTime): Word;
function EncodeDayOfWeekInMonth(const AYear, AMonth, ANthDayOfWeek,
  ADayOfWeek: Word): TDateTime;
{$ENDIF}


implementation


{$IFDEF D6PLUS}
uses
  DateUtils;
{$ENDIF}


//{$IFNDEF D6PLUS}
function IsLeapYear(Year: Word): Boolean;
begin
  Result:=((Year and 3)=0) and ((Year mod 100>0) or (Year mod 400=0));
end;

function DaysInMonth(const AValue: TDateTime): Word;
var
  y,m,d: Word;
begin
  DecodeDate(AValue,y,m,d);
  case m of
    2: if IsLeapYear(y) then
         Result:=29
       else
         Result:=28;
    4, 6, 9, 11: Result:=30;
    else
      Result := 31;
  end;
end;

function EncodeDayOfWeekInMonth(const AYear, AMonth, ANthDayOfWeek,
  ADayOfWeek: Word): TDateTime;
var
  days: integer;
  day : integer;
begin
  if (ANthDayOfWeek>=1) and (ANthDayOfWeek<=4) then begin
    day:=DayOfWeek(EncodeDate(AYear,AMonth,1));
    day:=1+ADayOfWeek-day;
    if day<=0 then
      Inc(day,7);
    day:=day+7*(ANthDayOfWeek-1);
    Result:=EncodeDate(AYear,AMonth,day);
  end else
    if ANthDayOfWeek=5 then begin
      days:=DaysInMonth(EncodeDate(AYear,AMonth,1));
      day:=DayOfWeek(EncodeDate(AYear,AMonth,days));
      day:=days+(ADayOfWeek-day);
      if day>days then
        Dec(day,7);
      Result:=EncodeDate(AYear,AMonth,day);
    end else
      Result:=0;
end;

//{$ENDIF}

function FormatSeconds;
var
 lcenturies,lyears,lmonths,lminutes,lhours,ldays,lweeks :word;
 lSecs :double;
 s :array[1..8] of string;
 SecondsPerCentury :comp;
 FS :string;
begin
  if WholeSecondsOnly then
    FS:='%.0f'
  else
    FS:='%.2f';
  SecondsPerCentury:=36550 * 24;
  SecondsPerCentury:= SecondsPerCentury * 3600;
  lcenturies:=Trunc(TotalSeconds / SecondsPerCentury);
  TotalSeconds:=TotalSeconds-(lcenturies * SecondsPerCentury);
  lyears:=Trunc(TotalSeconds / (365.5 * 24 * 3600));
  TotalSeconds:=TotalSeconds-(lyears * (365.5 * 24 * 3600));
  lmonths:=Trunc(TotalSeconds / (31 * 24 * 3600));
  TotalSeconds:=TotalSeconds-(lmonths * (31 * 24 * 3600));
  lweeks:=Trunc(TotalSeconds / (7 * 24 * 3600));
  TotalSeconds:=TotalSeconds-(lweeks * (7 * 24 * 3600));
  ldays:=Trunc(TotalSeconds / (24 * 3600));
  TotalSeconds:=TotalSeconds-(ldays * (24 * 3600));
  lhours:=Trunc(TotalSeconds / 3600);
  TotalSeconds:=TotalSeconds-(lhours * 3600);
  lminutes:=Trunc(TotalSeconds / 60);
  TotalSeconds:=TotalSeconds-(lminutes * 60);
  If WholeSecondsOnly then
    lsecs:=Trunc(TotalSeconds)
  else
    lsecs:=TotalSeconds;
  if lCenturies=1 then
    s[1]:=' Century, '
  else
    s[1]:=' Centuries, ';
  if lyears=1 then
    s[2]:=' Year, '
  else
    s[2]:=' Years, ';
  if lmonths=1 then
    s[3]:=' Month, '
  else
    s[3]:=' Months, ';
  if lweeks=1 then
    s[4]:=' Week, '
  else
    s[4]:=' Weeks, ';
  if ldays=1 then
    s[5]:=' Day, '
  else
    s[5]:=' Days, ';
  if lhours=1 then
    s[6]:=' Hour, '
  else
    s[6]:=' Hours, ';
  if lminutes=1 then
    s[7]:=' Minute, '
  else
    s[7]:=' Minutes, ';
  if lsecs=1 then
    s[8]:=' Second.'
  else
    s[8]:=' Seconds.';
  If DisplayAll then begin
    if dtformat then
      result:=Format('%2.2d.%2.2d.%2.2d %2.2d:%2.2d:%2.2d',
                     [lyears,lmonths,ldays+lweeks*7,lhours,lminutes,round(lSecs)])
    else
      Result:= Format('%.0d%s%.0d%s%.0d%s%.0d%s%.0d%s%.0d%s%.0d%s' + FS + '%s',
                     [lcenturies,s[1],lyears,s[2],lmonths,s[3],lweeks,s[4],ldays,s[5],lhours,s[6],lminutes,s[7],lSecs,s[8]]);

  end else begin
    if dtformat then
      result:=Format('%2.2d:%2.2d:%2.2d',
                     [lhours,lminutes,round(lSecs)])
    else begin
      if lCenturies>=1 then
        Result:= Format('%.0d%s%.0d%s%.0d%s%.0d%s%.0d%s%.0d%s%.0d%s' + FS + '%s',
                        [lcenturies,s[1],lyears,s[2],lmonths,s[3],lweeks,s[4],ldays,s[5],lhours,s[6],lminutes,s[7],lsecs,s[8]])
      else
        if lyears>=1 then
          Result:= Format('%.0d%s%.0d%s%.0d%s%.0d%s%.0d%s%.0d%s' + FS + '%s',
                          [lyears,s[2],lmonths,s[3],lweeks,s[4],ldays,s[5],lhours,s[6],lminutes,s[7],lsecs,s[8]])
      else
       if lmonths>=1 then
         Result:= Format('%.0d%s%.0d%s%.0d%s%.0d%s%.0d%s' + FS + '%s',
                         [lmonths,s[3],lweeks,s[4],ldays,s[5],lhours,s[6],lminutes,s[7],lsecs,s[8]])
       else
         if lweeks>=1 then
           Result:= Format('%.0d%s%.0d%s%.0d%s%.0d%s' + FS + '%s',
                           [lweeks,s[4],ldays,s[5],lhours,s[6],lminutes,s[7],lsecs,s[8]])
         else
           if ldays>=1 then
             Result:= Format('%.0d%s%.0d%s%.0d%s' + FS + '%s',
                             [ldays,s[5],lhours,s[6],lminutes,s[7],lsecs,s[8]])
           else
             if lhours>=1 then
               Result:= Format('%.0d%s%.0d%s' + FS + '%s',
                               [lhours,s[6],lminutes,s[7],lsecs,s[8]])
             else
               if lminutes>=1 then
                 Result:= Format('%.0d%s' + FS + '%s',[lminutes,s[7],lsecs,s[8]])
               else
                 Result:= Format(FS + '%s',[lsecs,s[8]]);
    end;
  end;
end;

function FileTimeToDateTimeStr(FileTime: TFileTime): string;
var
  LocFTime: TFileTime;
  SysFTime: TSystemTime;
  DateStr: string;
  TimeStr: string;
  FDateTimeStr: string;
  Dt, Tm: TDateTime;
begin
  FileTimeToLocalFileTime(FileTime, LocFTime);
  FileTimeToSystemTime(LocFTime, SysFTime);
  try
    with SysFTime do begin
      Dt := EncodeDate(wYear, wMonth, wDay);
      DateStr := DateToStr(Dt);
      Tm := EncodeTime(wHour, wMinute, wSecond, wMilliseconds);
      Timestr := TimeToStr(Tm);
      FDateTimeStr := DateStr + '   ' + TimeStr;
    end;
    Result := DateTimeToStr(StrToDateTime(FDateTimeStr));
  except
    Result := '';
  end;
end;

function FiletimeToDateTime(FT: FILETIME): TDateTime;
var
  st: SYSTEMTIME;
  dt1,dt2: TDateTime;
begin
  FileTimeToSystemTime(FT,st);
  try
    dt1:=EncodeTime(st.whour,st.wminute,st.wsecond,st.wMilliseconds);
  except
    dt1:=0;
  end;
  try
    dt2:=EncodeDate(st.wyear,st.wmonth,st.wday);
  except
    dt2:=0;
  end;
  Result:=dt1+dt2;
end;

function ParseDate;
var
  y,m,d: Word;
begin
  y:=StrToInt(Copy(YYYYMMDD,1,4));
  m:=StrToInt(Copy(YYYYMMDD,5,2));
  d:=StrToInt(Copy(YYYYMMDD,7,2));
  Result:=EncodeDate(y,m,d);
end;

function UTCToDateTime(UTC: DWORD): TDateTime;
var
  d: LARGE_INTEGER;
  ft: FILETIME;
begin
  d.QuadPart:=365*24*60*60;
  d.QuadPart:=((1970-1601)*d.QuadPart+UTC+89*24*60*60+3600)*10000000;
  ft.dwLowDateTime:=d.LowPart;
  ft.dwHighDateTime:=d.HighPart;
  Result:=FiletimeToDateTime(ft);
end;

function DSTDate2Date(dstDate: TSystemTime; year: word): TDateTime;
begin
  if dstDate.wMonth=0 then
    Result:=0
  else
    if dstDate.wYear=0 then
      Result:=EncodeDayOfWeekInMonth(year,dstDate.wMonth,dstDate.wDay,dstDate.wDayOfWeek+1)+
              EncodeTime(dstDate.wHour,dstDate.wMinute,dstDate.wSecond,dstDate.wMilliseconds)
    else
      Result:=SystemTimeToDateTime(dstDate);
end;

end.

unit OneDate;

interface

uses Data.SqlTimSt, system.SysUtils, system.StrUtils, system.Classes, system.DateUtils;
// 0相等，1大于，-1小于
procedure InitSQLTimeStamp(qTime1: TSQLTimeStamp);
function IsZeroSQLTimeStamp(qTime1: TSQLTimeStamp): boolean;
function CompareSQLTimeStamps(qTime1, qTime2: TSQLTimeStamp): Integer;
function OneSQLTimeStampToStr(qTime1: TSQLTimeStamp): string;
function OneStrToSQLTimeStamp(qStr: string): TSQLTimeStamp;
function OneSQLTimeStampToDateTimeStr(qTime1: TSQLTimeStamp): string;
function SecondsBetweenNotAbs(const ANow, AThen: TDateTime): Int64;
implementation

function IsZeroSQLTimeStamp(qTime1: TSQLTimeStamp): boolean;
begin
  Result := true;
  if qTime1.Year > 0 then
  begin
    Result := false;
    exit;
  end;
  if qTime1.Month > 0 then
  begin
    Result := false;
    exit;
  end;
  if qTime1.Day > 0 then
  begin
    Result := false;
    exit;
  end;
  if qTime1.Hour > 0 then
  begin
    Result := false;
    exit;
  end;
  if qTime1.Minute > 0 then
  begin
    Result := false;
    exit;
  end;
  if qTime1.Second > 0 then
  begin
    Result := false;
    exit;
  end;
  if qTime1.Fractions > 0 then
  begin
    Result := false;
    exit;
  end;
end;

procedure InitSQLTimeStamp(qTime1: TSQLTimeStamp);
begin
  qTime1.Year := 0;
  qTime1.Month := 0;
  qTime1.Day := 0;
  qTime1.Hour := 0;
  qTime1.Minute := 0;
  qTime1.Second := 0;
  qTime1.Fractions := 0;
end;

function CompareSQLTimeStamps(qTime1, qTime2: TSQLTimeStamp): Integer;
begin
  Result := 0;
  // 先比较年份
  if qTime1.Year < qTime2.Year then
  begin
    Result := -1;
    exit;
  end
  else if qTime1.Year > qTime2.Year then
  begin
    Result := 1;
    exit;
  end;

  // 年份相同，比较月份
  if qTime1.Month < qTime2.Month then
  begin
    Result := -1;
    exit;
  end
  else if qTime1.Month > qTime2.Month then
  begin
    Result := 1;
    exit;
  end;

  // 月份相同，比较日期
  if qTime1.Day < qTime2.Day then
  begin
    Result := -1;
    exit;
  end
  else if qTime1.Day > qTime2.Day then
  begin
    Result := 1;
    exit;
  end;

  // 日期相同，比较小时
  if qTime1.Hour < qTime2.Hour then
  begin
    Result := -1;
    exit;
  end
  else if qTime1.Hour > qTime2.Hour then
  begin
    Result := 1;
    exit;
  end;

  // 小时相同，比较分钟
  if qTime1.Minute < qTime2.Minute then
  begin
    Result := -1;
    exit;
  end
  else if qTime1.Minute > qTime2.Minute then
  begin
    Result := 1;
    exit;
  end;

  // 分钟相同，比较秒
  if qTime1.Second < qTime2.Second then
  begin
    Result := -1;
    exit;
  end
  else if qTime1.Second > qTime2.Second then
  begin
    Result := 1;
    exit;
  end;

  // 秒相同，比较毫秒
  if qTime1.Fractions < qTime2.Fractions then
  begin
    Result := -1;
    exit;
  end
  else if qTime1.Fractions > qTime2.Fractions then
  begin
    Result := 1;
    exit;
  end;

  // 所有字段都相同
  Result := 0; // qTime1 等于 qTime2
end;

function OneSQLTimeStampToStr(qTime1: TSQLTimeStamp): string;
begin
  Result := '';
  Result := qTime1.Year.ToString();
  Result := Result + '.' + qTime1.Month.ToString();
  Result := Result + '.' + qTime1.Day.ToString();
  Result := Result + '.' + qTime1.Hour.ToString();
  Result := Result + '.' + qTime1.Minute.ToString();
  Result := Result + '.' + qTime1.Second.ToString();
  Result := Result + '.' + qTime1.Fractions.ToString();
end;

function OneStrToSQLTimeStamp(qStr: string): TSQLTimeStamp;
var
  lTimeStamp: TSQLTimeStamp;
  lArr: TArray<string>;
  i: Integer;
  tempStr: string;
begin
  SetLength(lArr, 0);
  InitSQLTimeStamp(lTimeStamp);
  lArr := qStr.Split(['.']);
  //
  for i := 0 to High(lArr) do
  begin
    tempStr := lArr[i];
    if i = 0 then
      lTimeStamp.Year := strToInt(tempStr)
    else if i = 1 then
      lTimeStamp.Month := strToInt(tempStr)
    else if i = 2 then
      lTimeStamp.Day := strToInt(tempStr)
    else if i = 3 then
      lTimeStamp.Hour := strToInt(tempStr)
    else if i = 4 then
      lTimeStamp.Minute := strToInt(tempStr)
    else if i = 5 then
      lTimeStamp.Second := strToInt(tempStr)
    else if i = 6 then
      lTimeStamp.Fractions := strToInt(tempStr);
  end;
  Result := lTimeStamp;
end;

function OneSQLTimeStampToDateTimeStr(qTime1: TSQLTimeStamp): string;
var
  tempStr: string;
  iLen: Integer;
  lFromat, lHourFormat: string;
  lDateTime: TDateTime;
  lMilliSec: string;
begin
  Result := '';
  lFromat := '';
  lHourFormat := '';
  lDateTime := SQLTimeStampToDateTime(qTime1);
  if qTime1.Year > 0 then
  begin
    iLen := qTime1.Year.ToString().Length;
    if iLen = 2 then
    begin
      lFromat := lFromat + 'yy' + '-';
    end
    else if iLen = 4 then
    begin
      lFromat := lFromat + 'yyyy' + '-';
    end;
  end;
  if qTime1.Month > 0 then
  begin
    lFromat := lFromat + 'mm' + '-';
  end;
  if qTime1.Day > 0 then
  begin
    lFromat := lFromat + 'dd' + '-';
  end;
  if lFromat <> '' then
  begin
    lFromat := lFromat.Substring(0, lFromat.Length - 1);
    lFromat := lFromat + ' ';
  end;
  // 时分秒
  if qTime1.Hour > 0 then
  begin
    lHourFormat := lHourFormat + 'hh' + ':';
  end;
  if qTime1.Minute > 0 then
  begin
    lHourFormat := lHourFormat + 'nn' + ':';
  end;
  if qTime1.Second > 0 then
  begin
    lHourFormat := lHourFormat + 'ss:';
  end;
  if lHourFormat <> '' then
    lHourFormat := lHourFormat.Substring(0, lHourFormat.Length - 1);
  lFromat := lFromat + lHourFormat;
  Result := FormatDateTime(lFromat, lDateTime);
  if qTime1.Fractions > 0 then
  begin
    lMilliSec := qTime1.Fractions.ToString();
    iLen := lMilliSec.Length;
    if iLen <= 3 then
    begin
      while lMilliSec.Length < 3 do
      begin
        lMilliSec := '0' + lMilliSec;
      end;
      Result := Result + '.' + lMilliSec;
    end
    else
    begin
      Result := Result + '.' + lMilliSec.Substring(0, 3);
    end;

  end;
end;

function SecondsBetweenNotAbs(const ANow, AThen: TDateTime): Int64;
begin
  Result := (DateTimeToMilliseconds(ANow) - DateTimeToMilliseconds(AThen))
    div (MSecsPerSec);
end;

end.

unit OneDateTimeHelper;

interface
uses System.SysUtils;
//设置软件系统时间格式
procedure SetSystemDataTimeFormatSettings;
implementation
//设置软件系统时间格式
procedure SetSystemDataTimeFormatSettings;
begin
  FormatSettings.LongDateFormat := 'yyyy-MM-dd';
  FormatSettings.ShortDateFormat := 'yyyy-MM-dd';
  FormatSettings.LongTimeFormat := 'hh:nn:ss';
  FormatSettings.ShortTimeFormat := 'hh:nn:ss';
  FormatSettings.DateSeparator := '-';
  FormatSettings.timeSeparator := ':';
  FormatSettings.ShortMonthNames[1] := '01';
  FormatSettings.ShortMonthNames[2] := '02';
  FormatSettings.ShortMonthNames[3] := '03';
  FormatSettings.ShortMonthNames[4] := '04';
  FormatSettings.ShortMonthNames[5] := '05';
  FormatSettings.ShortMonthNames[6] := '06';
  FormatSettings.ShortMonthNames[7] := '07';
  FormatSettings.ShortMonthNames[8] := '08';
  FormatSettings.ShortMonthNames[9] := '09';
  FormatSettings.ShortMonthNames[10] := '10';
  FormatSettings.ShortMonthNames[11] := '11';
  FormatSettings.ShortMonthNames[12] := '12';
  FormatSettings.LongMonthNames[1] := '01';
  FormatSettings.LongMonthNames[2] := '02';
  FormatSettings.LongMonthNames[3] := '03';
  FormatSettings.LongMonthNames[4] := '04';
  FormatSettings.LongMonthNames[5] := '05';
  FormatSettings.LongMonthNames[6] := '06';
  FormatSettings.LongMonthNames[7] := '07';
  FormatSettings.LongMonthNames[8] := '08';
  FormatSettings.LongMonthNames[9] := '09';
  FormatSettings.LongMonthNames[10] := '10';
  FormatSettings.LongMonthNames[11] := '11';
  FormatSettings.LongMonthNames[12] := '12';
  FormatSettings.ShortDayNames[1] := '日';
  FormatSettings.ShortDayNames[2] := '一';
  FormatSettings.ShortDayNames[3] := '二';
  FormatSettings.ShortDayNames[4] := '三';
  FormatSettings.ShortDayNames[5] := '四';
  FormatSettings.ShortDayNames[6] := '五';
  FormatSettings.ShortDayNames[7] := '六';
  FormatSettings.LongDayNames[1] := '日';
  FormatSettings.LongDayNames[2] := '一';
  FormatSettings.LongDayNames[3] := '二';
  FormatSettings.LongDayNames[4] := '三';
  FormatSettings.LongDayNames[5] := '四';
  FormatSettings.LongDayNames[6] := '五';
  FormatSettings.LongDayNames[7] := '六';
end;
end.

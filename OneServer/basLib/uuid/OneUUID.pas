unit OneUUID;

// 版权声明引用了开源的，非作者所有
// https://github.com/yitter/IdGenerator/tree/master/Delphi
interface

uses
  system.Classes, system.StrUtils, system.SysUtils,
  uIdGeneratorOptions, uIIdGenerator, uDefaultIdGenerator, uYitIdHelper;

function GetUUID(): int64;
function GetUUIDStr(): string;

implementation

var
  IdGeneratorOption: TIdGeneratorOptions = nil;
  YitIdHelper: TYitIdHelper = nil;

function GetYitIdHelper(): TYitIdHelper;
begin
  if YitIdHelper = nil then
  begin
    YitIdHelper := TYitIdHelper.Create;
    IdGeneratorOption := TIdGeneratorOptions.Create;
    // 参数参考IdGeneratorOptions定义。
    with IdGeneratorOption do
    begin
      // 以下全部为默认参数
      Method := 1;
      // BaseTime := DateTime.Now.AddYears(-10);
      WorkerId := 1;

      // WorkerIdBitLength + SeqBitLength 不超过 22。
      WorkerIdBitLength := 6;
      SeqBitLength := 14;

      MaxSeqNumber := 0;
      MinSeqNumber := 5;

      TopOverCostCount := 2000;

      DataCenterId := 0;
      DataCenterIdBitLength := 0;

      TimestampType := 0;
    end;
    // 保存参数（务必调用，否则参数设置不生效）：
    YitIdHelper.SetIdGenerator(IdGeneratorOption);
  end;
  Result := YitIdHelper;
end;

function GetUUID(): int64;
begin
  Result := GetYitIdHelper().NextId();
end;

function GetUUIDStr(): string;
begin
  Result := GetUUID().ToString;
end;

initialization


finalization

if YitIdHelper <> nil then
begin
  YitIdHelper.Free;
  IdGeneratorOption.Free;
end;

end.

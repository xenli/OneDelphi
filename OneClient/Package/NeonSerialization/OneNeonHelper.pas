unit OneNeonHelper;

interface

uses
  system.JSON, system.Classes, system.SysUtils, Rest.JSON, system.Rtti,
  Neon.Core.Persistence, Neon.Core.Serializers.DB, Neon.Core.Serializers.RTL,
  Neon.Core.Serializers.Nullables, Neon.Core.Persistence.JSON, Data.DB, Neon.Core.Types;
function GetDefalutNeonConfiguration(): INeonConfiguration;
// ���ļ���ȡ���ã���JSONת���ɶ���
function JSONToObjectFormFile(QObject: TObject; QFileName: string;
  var QErrMsg: string): boolean;
// ����ת����JSON�������ļ�
function ObjectToJsonFile(QObject: TObject; QFileName: string;
  var QErrMsg: string): boolean;
// JSONת���ɶ���
function JsonToObject(QObject: TObject; QJsonValue: TJsonValue;
  var QErrMsg: string): boolean;
// ����ת����JSON
function ObjectToJson(QObject: TObject; var QErrMsg: string): TJsonValue;
// ����ת����JSON�ַ���
function ObjectToJsonString(QObject: TObject): string;
// TValueת����JSON�ַ���
function ValueToJsonString(QTValue: TValue): string;
// ���ݼ�ת����JSON
function DataSetToJson(QDataSet: TDataSet; var QErrMsg: string): TJsonValue;
// JSONת�������ݼ�
function JsonToDataSet(QDataSet: TDataSet; QJsonStr: string;
  var QErrMsg: string): boolean;

var
  Defalut_NeonConfiguration: INeonConfiguration = nil;

implementation

function GetDefalutNeonConfiguration(): INeonConfiguration;
var
  lRegistry: TNeonSerializerRegistry;
begin
  if Defalut_NeonConfiguration = nil then
  begin
    Defalut_NeonConfiguration := TNeonConfiguration.Default;
    Defalut_NeonConfiguration.SetMembers([TNeonMembers.Standard, TNeonMembers.Fields, TNeonMembers.Properties]);
    lRegistry := Defalut_NeonConfiguration.GetSerializers;
    lRegistry.RegisterSerializer(TGUIDSerializer);
    lRegistry.RegisterSerializer(TStreamSerializer);
    lRegistry.RegisterSerializer(TJSONValueSerializer);
    lRegistry.RegisterSerializer(TTValueSerializer);
    // DB serializers
    lRegistry.RegisterSerializer(TDataSetSerializer);
    // VCL serializers
    // Nullable serializers
    RegisterNullableSerializers(lRegistry);
  end;
  Result := Defalut_NeonConfiguration;
end;

function JSONToObjectFormFile(QObject: TObject; QFileName: string;
  var QErrMsg: string): boolean;
var
  lJsonValue: TJsonValue;
  LReader: TNeonDeserializerJSON;
  lNeonConfiguration: INeonConfiguration;
  lStream: TMemoryStream;
  lBytes: TBytes;
begin
  Result := false;
  QErrMsg := '';
  if QObject = nil then
  begin
    QErrMsg := '���ȴ�������';
    exit;
  end;
  if QFileName = '' then
  begin
    QErrMsg := '������ļ����Ʋ���Ϊ��';
    exit;
  end;
  if not FileExists(QFileName) then
  begin
    QErrMsg := '�ļ�������';
    exit;
  end;
  LReader := nil;
  lJsonValue := nil;
  lStream := TMemoryStream.Create;
  try
    lStream.LoadFromFile(QFileName);
    lStream.Position := 0;
    setLength(lBytes, lStream.Size);
    lStream.Read(lBytes, lStream.Size);
    lJsonValue := TJsonObject.ParseJSONValue(lBytes, 0, lStream.Size);
    if lJsonValue <> nil then
    begin
      lNeonConfiguration := GetDefalutNeonConfiguration();
      LReader := TNeonDeserializerJSON.Create(lNeonConfiguration);
      LReader.JsonToObject(QObject, lJsonValue);
      Result := true;
    end
    else
    begin
      QErrMsg := '����JSON�ļ�[' + QFileName + ']ʧ��';
    end;
  finally
    if LReader <> nil then
      LReader.Free;
    if lJsonValue <> nil then
      lJsonValue.Free;
    setLength(lBytes, 0);
    lBytes := nil;
    lStream.Clear;
    lStream.Free;
  end;
end;

function ObjectToJsonFile(QObject: TObject; QFileName: string;
  var QErrMsg: string): boolean;
var
  lJsonValue: TJsonValue;
  LWriter: TNeonSerializerJSON;
  lNeonConfiguration: INeonConfiguration;
  lBytes: TBytes;
  lStream: TMemoryStream;
  lStr: string;
begin
  Result := false;
  QErrMsg := '';
  if QObject = nil then
  begin
    QErrMsg := '���ȴ�������';
    exit;
  end;
  if QFileName = '' then
  begin
    QErrMsg := '������ļ����Ʋ���Ϊ��';
    exit;
  end;
  LWriter := nil;
  lJsonValue := nil;
  lStream := TMemoryStream.Create;
  try
    lNeonConfiguration := GetDefalutNeonConfiguration();
    LWriter := TNeonSerializerJSON.Create(lNeonConfiguration);
    try
      lJsonValue := LWriter.ObjectToJson(QObject);
      if lJsonValue <> nil then
      begin
        lStr := lJsonValue.ToString;
        lBytes := TEncoding.UTF8.GetBytes(lStr);
        lStream.Position := 0;
        lStream.Clear;
        lStream.Write(lBytes, length(lBytes));
        lStream.Position := 0;
        lStream.SaveToFile(QFileName);
        Result := true;
      end
      else
      begin
        QErrMsg := '���������JSONʧ�ܣ����Ϊnil';
        exit;
      end;
    finally
      if lJsonValue <> nil then
        lJsonValue.Free;
      if LWriter <> nil then
        LWriter.Free;
    end;
  finally
    lStream.Clear;
    lStream.Free;
  end;
end;

function JsonToObject(QObject: TObject; QJsonValue: TJsonValue;
  var QErrMsg: string): boolean;
var
  LReader: TNeonDeserializerJSON;
  lNeonConfiguration: INeonConfiguration;
begin
  Result := false;
  QErrMsg := '';
  if QObject = nil then
  begin
    QErrMsg := '���ȴ�������';
    exit;
  end;
  if QJsonValue = nil then
  begin
    QErrMsg := 'JSON����Ϊnil';
    exit;
  end;
  lNeonConfiguration := GetDefalutNeonConfiguration();
  LReader := TNeonDeserializerJSON.Create(lNeonConfiguration);
  try
    LReader.JsonToObject(QObject, QJsonValue);
    Result := true;
  finally
    if LReader <> nil then
      LReader.Free;
  end;
end;

function ObjectToJson(QObject: TObject; var QErrMsg: string): TJsonValue;
var
  LWriter: TNeonSerializerJSON;
  lNeonConfiguration: INeonConfiguration;
begin
  Result := nil;
  QErrMsg := '';
  if QObject = nil then
  begin
    QErrMsg := '���ȴ�������';
    exit;
  end;
  lNeonConfiguration := GetDefalutNeonConfiguration();
  LWriter := TNeonSerializerJSON.Create(lNeonConfiguration);
  try
    Result := LWriter.ObjectToJson(QObject);
  finally
    LWriter.Free;
  end;
end;

function ObjectToJsonString(QObject: TObject): string;
var
  LWriter: TNeonSerializerJSON;
  lNeonConfiguration: INeonConfiguration;
  lJsonValue: TJsonValue;
begin
  Result := '';
  if QObject = nil then
  begin
    exit;
  end;
  lNeonConfiguration := OneNeonHelper.GetDefalutNeonConfiguration();
  LWriter := TNeonSerializerJSON.Create(lNeonConfiguration);
  try
    lJsonValue := LWriter.ObjectToJson(QObject);
    try
      Result := lJsonValue.ToString();
    finally
      if lJsonValue <> nil then
        lJsonValue.Free;
    end;
  finally
    LWriter.Free;
  end;
end;

function ValueToJsonString(QTValue: TValue): string;
var
  LWriter: TNeonSerializerJSON;
  lNeonConfiguration: INeonConfiguration;
  lJsonValue: TJsonValue;
begin
  Result := '';
  lNeonConfiguration := OneNeonHelper.GetDefalutNeonConfiguration();
  LWriter := TNeonSerializerJSON.Create(lNeonConfiguration);
  try
    lJsonValue := LWriter.ValueToJSON(QTValue);
    try
      Result := lJsonValue.ToString();
    finally
      if lJsonValue <> nil then
        lJsonValue.Free;
    end;
  finally
    LWriter.Free;
  end;
end;

function DataSetToJson(QDataSet: TDataSet; var QErrMsg: string): TJsonValue;
var
  LWriter: TNeonSerializerJSON;
  lNeonConfiguration: INeonConfiguration;
begin
  Result := nil;
  QErrMsg := '';
  if QDataSet = nil then
  begin
    QErrMsg := '���ȴ�������';
    exit;
  end;
  lNeonConfiguration := GetDefalutNeonConfiguration();
  LWriter := TNeonSerializerJSON.Create(lNeonConfiguration);
  try
    Result := LWriter.ObjectToJson(QDataSet);
  finally
    LWriter.Free;
  end;
end;

function JsonToDataSet(QDataSet: TDataSet; QJsonStr: string;
  var QErrMsg: string): boolean;
var
  lJsonValue: TJsonValue;
  LReader: TNeonDeserializerJSON;
  lNeonConfiguration: INeonConfiguration;
begin
  Result := false;
  if QJsonStr = '' then
  begin
    QErrMsg := 'Json�ַ�������Ϊ��!!!';
    exit;
  end;
  lJsonValue := TJsonObject.ParseJSONValue(QJsonStr);
  if not Assigned(lJsonValue) then
  begin
    QErrMsg := 'JSONת��ʧ��,����';
    exit;
  end;
  lNeonConfiguration := GetDefalutNeonConfiguration();
  try
    LReader := TNeonDeserializerJSON.Create(lNeonConfiguration);
    try
      LReader.JsonToObject(QDataSet, lJsonValue);
    finally
      LReader.Free;
    end;
  finally
    lJsonValue.Free;
  end;
  Result := true;
end;

end.

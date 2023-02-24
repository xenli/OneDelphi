unit OneAttribute;

interface

type
  // 类表名注解
  TOneTableAttribute = class
  strict protected
    FTableName: string;
  end;

  TOneDBAttribute = class(TCustomAttribute)
  strict protected
    /// <summary>Internal use only</summary>
    FFieldName: string;
    FFormat: string;
  public
    constructor Create(QFieldName: string; QFormat: string = '');
    /// <summary>Alignment in bytes</summary>
    property FieldName: string read FFieldName;
    property Format: string read FFormat;
  end;

  TOneJsonAttribute = class(TCustomAttribute)
  strict protected
    /// <summary>Internal use only</summary>
    FJsonName: string;
    FFormat: string;
  public
    constructor Create(QJsonName: string; QFormat: string);
    /// <summary>Alignment in bytes</summary>
    property JsonName: string read FJsonName;
    property Format: string read FFormat;
  end;

  //
  TOneWebApiAttribute = class(TCustomAttribute)
  strict protected
    /// <summary>Internal use only</summary>
    FUrlPath: string;
    FMethod: string;
  public
    property UrlPath: string read FUrlPath;
    property Method: string read FMethod;
  end;

implementation

constructor TOneDBAttribute.Create(QFieldName: string; QFormat: string = '');
begin
  inherited Create;
  self.FFieldName := QFieldName;
  self.FFormat := QFormat;
end;

constructor TOneJsonAttribute.Create(QJsonName: string; QFormat: string);
begin
  inherited Create;
  self.FJsonName := QJsonName;
  self.FFormat := QFormat;
end;

end.

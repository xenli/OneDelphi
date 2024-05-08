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

  //
  TOneHttpMethodAttribute = class(TCustomAttribute)
  end;

  TOneHttpGet = class(TOneHttpMethodAttribute)
  end;

  TOneHttpPost = class(TOneHttpMethodAttribute)
  end;

  TOneHttpPath = class(TOneHttpMethodAttribute)
  end;

  TOneHttpForm = class(TOneHttpMethodAttribute)
  end;

  TOneRouter = class(TCustomAttribute)
  strict protected
    /// <summary>Internal use only</summary>
    FRouter: string;
  public
    constructor Create(QRouter: string);
    /// <summary>Alignment in bytes</summary>
    property Router: string read FRouter;
  end;

  TOneAuthorGetMode = (token, header);

  TOneAuthor = class(TCustomAttribute)
  strict protected
    /// <summary>Internal use only</summary>
    FAuthorGetMode: TOneAuthorGetMode;
  public
    constructor Create(QAuthorGetMode: TOneAuthorGetMode);
    /// <summary>Alignment in bytes</summary>
    property AuthorGetMode: TOneAuthorGetMode read FAuthorGetMode;
  end;

  TOneCheckSign = class(TCustomAttribute)
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

constructor TOneRouter.Create(QRouter: string);
begin
  inherited Create;
  self.FRouter := QRouter;
end;

constructor TOneAuthor.Create(QAuthorGetMode: TOneAuthorGetMode);
begin
  inherited Create;
  self.FAuthorGetMode := QAuthorGetMode;
end;

end.

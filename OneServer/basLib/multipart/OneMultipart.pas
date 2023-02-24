unit OneMultipart;

interface

uses System.SysUtils, Web.ReqMulti, Web.HTTPApp, System.Classes, Web.HTTPParse, Web.ReqFiles;

type
  TMultipartBoundaries = array of Integer;

  TOneRequestFile = class(TWebRequestFile)

  end;

  { 此类参数 Web.ReqMulti 重新写的 }
  TOneMultipartDecode = class(TObject)
  private
    FContentType: string;
    FContentFields: TStringList; // 上传上来的其它字段值
    FFiles: TWebRequestFiles; // 上传来的文件
    FContentBuffer: TBytes;
  protected
    procedure ExtractContentTypeFields(Strings: TStrings);
    procedure ParseMultiPartContent;
    procedure ParseMultiPart(APart: PByte; ASize: Integer);
    procedure ParseMultipartHeaders(Parser: THTTPParser; AContent: PByte; AContentLength: Integer);
  public
    constructor Create;
    destructor Destroy; override;
  public
    property ContentFields: TStringList read FContentFields;
    property Files: TWebRequestFiles read FFiles;
  end;

function IsMultipartForm(QContentType: string): Boolean;

function MultipartFormDeCode(QContentType: string; QContent: RawByteString; var QErrMsg: string): TOneMultipartDecode;

implementation

const
  sMultiPartFormData = 'multipart/form-data';

function IsMultipartForm(QContentType: string): Boolean;
begin
  Result := StrLIComp(PChar(QContentType), PChar(sMultiPartFormData), Length(sMultiPartFormData)) = 0;
end;

{ 参考系统单元  Web.ReqMulti }
function MultipartFormDeCode(QContentType: string; QContent: RawByteString; var QErrMsg: string): TOneMultipartDecode;
var
  lContentBuffer: TBytes;
  lMultipartDecode: TOneMultipartDecode;
  lStremStream: TStringStream;
begin
  Result := nil;
  QErrMsg := '';
  if not IsMultipartForm(QContentType) then
  begin
    QErrMsg := '不是表单[multipart/form-data]数据，当前格式为[' + QContentType + ']';
    exit;
  end;
  lStremStream := TStringStream.Create(QContent);
  try
    lStremStream.Position := 0;
    setlength(lContentBuffer, lStremStream.Size);
    lStremStream.Read(lContentBuffer, lStremStream.Size);
  finally
    lStremStream.Clear;
    lStremStream.Free;
  end;
  // lContentBuffer := TEncoding.ANSI.GetBytes(QContent);
  lMultipartDecode := TOneMultipartDecode.Create;
  try
    lMultipartDecode.FContentType := QContentType;
    lMultipartDecode.FContentBuffer := lContentBuffer;
    lMultipartDecode.ParseMultiPartContent;
    Result := lMultipartDecode;
  except
    on e: Exception do
    begin
      QErrMsg := e.Message;
      Result := nil;
    end;
  end;
end;

{ TOneMultipartDecode }
constructor TOneMultipartDecode.Create;
begin
  inherited Create;
  FContentFields := TStringList.Create;
  FFiles := TWebRequestFiles.Create;
end;

destructor TOneMultipartDecode.Destroy;
begin
  FContentFields.Free;
  FFiles.Free;
  inherited Destroy;
end;

procedure TOneMultipartDecode.ExtractContentTypeFields(Strings: TStrings);
begin
  ExtractHeaderFields([';'], [' '], FContentType, Strings, False, True);
end;

procedure TOneMultipartDecode.ParseMultiPartContent;

  function IndexOfPattern(const ABoundary: TBytes; const ABuffer: TBytes; AOffset: Integer): Integer; overload;
  var
    I, LIterCnt, L, J: Integer;
  begin
    L := Length(ABoundary);
    { Calculate the number of possible iterations. Not valid if AOffset < 1. }
    LIterCnt := Length(ABuffer) - AOffset - L + 1;

    { Only continue if the number of iterations is positive or zero (there is space to check) }
    if (AOffset >= 0) and (LIterCnt >= 0) and (L > 0) then
    begin
      for I := 0 to LIterCnt do
      begin
        J := 0;
        while (J >= 0) and (J < L) do
        begin
          if ABuffer[I + J + AOffset] = ABoundary[J] then
            Inc(J)
          else
            J := -1;
        end;
        if J >= L then
          exit(I + AOffset);
      end;
    end;

    Result := -1;
  end;

  function FindBoundaries(const Boundary: TBytes): TMultipartBoundaries;
  var
    P1: Integer;
    Boundaries: TMultipartBoundaries;
    Count: Integer;
  begin
    Count := 0;
    P1 := IndexOfPattern(Boundary, FContentBuffer, 0);
    while P1 >= 0 do
    begin
      Inc(Count);
      setlength(Boundaries, Count);
      Boundaries[Count - 1] := P1;
      P1 := IndexOfPattern(Boundary, FContentBuffer, P1 + Length(Boundary));
    end;
    Result := Boundaries;
  end;

var
  ContentTypeFields: TStrings;
  Boundaries: TMultipartBoundaries;
  Temp: string;
  Boundary: TBytes;
  I: Integer;
  P: Integer;
begin
  setlength(Boundaries, 0);
  ContentTypeFields := TStringList.Create;
  try
    ExtractContentTypeFields(ContentTypeFields);
    Temp := ContentTypeFields.Values['boundary'];
    if Temp <> '' then
    begin
      Temp := '--' + Temp;
      Boundary := TEncoding.ASCII.GetBytes(Temp);
    end;
  finally
    ContentTypeFields.Free;
  end;
  if Length(Boundary) = 0 then
    exit;
  Boundaries := FindBoundaries(Boundary);
  for I := Low(Boundaries) to High(Boundaries) - 1 do
  begin
    P := Boundaries[I] + Length(Boundary) + 2;
    ParseMultiPart(@FContentBuffer[P], Boundaries[I + 1] - P);
  end;
end;

procedure TOneMultipartDecode.ParseMultipartHeaders(Parser: THTTPParser; AContent: PByte; AContentLength: Integer);
var
  PartContentType: string;
  PartFileName: string;
  PartName: string;
  ContentDisposition: string;

  procedure SkipLine;
  begin
    Parser.CopyToEOL;
    Parser.SkipEOL;
  end;

  function TrimLeft(const S: UTF8String): UTF8String;
  var
    I, L: Integer;
  begin
    L := Length(S);
    I := 1;
    while (I <= L) and (S[I] <= ' ') do
      Inc(I);
    Result := Copy(S, I, Maxint);
  end;

  procedure ParseContentType;
  begin
    with Parser do
    begin
      NextToken;
      if Token = ':' then
        NextToken;
      if PartContentType = '' then
        PartContentType := TrimLeft(CopyToEOL)
      else
        CopyToEOL;
      NextToken;
    end;
  end;

  procedure ExtractContentDispositionFields;
  var
    S: UTF8String;
    Strings: TStrings;
  begin
    S := ContentDisposition;
    Strings := TStringList.Create;
    try
      ExtractHeaderFields([';'], [' '], S, Strings, True, True);
      PartName := Strings.Values['name'];
      PartFileName := Strings.Values['filename'];
    finally
      Strings.Free;
    end;
  end;

  procedure ParseContentDisposition;
  begin
    with Parser do
    begin
      NextToken;
      if Token = ':' then
        NextToken;
      if ContentDisposition = '' then
        ContentDisposition := TrimLeft(CopyToEOL)
      else
        CopyToEOL;
      NextToken;
      ExtractContentDispositionFields;
    end;
  end;

var
  Temp: UTF8String;
begin
  while Parser.Token <> toEOF do
    with Parser do
    begin
      case Token of
        toContentType:
          ParseContentType;
        toContentDisposition:
          ParseContentDisposition;
        toEOL:
          Break; // At content
      else
        SkipLine;
      end;
    end;
  if PartName <> '' then
  begin
    if (PartFileName <> '') or (PartContentType <> '') then
    begin
      // Note.  Filename is not added as content field
      // FContentFields.Add(PartName + '=' + PartFileName);
      if FFiles = nil then
        FFiles := TWebRequestFiles.Create;
      FFiles.Add(PartName, PartFileName, PartContentType, AContent, AContentLength - 2); // Exclude the cr/lf pair
    end
    else
    begin
      Temp := '';
      if AContentLength > 0 then
      begin
        Assert(AContentLength >= 2);
        Temp := TEncoding.UTF8.GetString(BytesOf(AContent, AContentLength - 2), 0, AContentLength - 2);
      end;
      FContentFields.Add(PartName + '=' + Temp);
    end
  end;
end;

procedure TOneMultipartDecode.ParseMultiPart(APart: PByte; ASize: Integer);

  function StrPos(const Str1, Str2: PUTF8Char): PUTF8Char;
  var
    MatchStart, LStr1, LStr2: PUTF8Char;
  begin
    Result := nil;
    if (Str1^ = #0) or (Str2^ = #0) then
      exit;

    MatchStart := Str1;
    while MatchStart^ <> #0 do
    begin
      if MatchStart^ = Str2^ then
      begin
        LStr1 := MatchStart + 1;
        LStr2 := Str2 + 1;
        while True do
        begin
          if LStr2^ = #0 then
            exit(MatchStart);
          if (LStr1^ <> LStr2^) or (LStr1^ = #0) then
            Break;
          Inc(LStr1);
          Inc(LStr2);
        end;
      end;
      Inc(MatchStart);
    end;
  end;

var
  PEndHeader: PUTF8Char;
  S: TStream;
  HeaderLen: Integer;
  Parser: THTTPParser;
begin

  PEndHeader := StrPos(PUTF8Char(APart), #13#10#13#10);
  if PEndHeader <> nil then
  begin
    HeaderLen := PEndHeader - APart + 4;
    S := TWebRequestFileStream.Create(APart, HeaderLen);
    try
      Parser := THTTPParser.Create(S);
      try
        ParseMultipartHeaders(Parser, APart + HeaderLen, ASize - HeaderLen);
      finally
        Parser.Free;
      end;
    finally
      S.Free;
    end;
  end;
end;

end.

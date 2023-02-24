unit OneClientHelper;

interface

uses
  system.Generics.Collections,
  OneClientConnect, OneClientDataSet;

type
  TOneConnectionHelper = class helper for TOneConnection
  public
    // 打开数据
    function OpenOneData(Sender: TOneDataSet): Boolean;
    function OpenOneDatas(QOpenDatas: TList<TOneDataSet>): Boolean; overload;
    function OpenOneDatas(QOpenDatas: array of TOneDataSet): Boolean; overload;
    // 保存数据
    function SaveOneData(Sender: TOneDataSet): Boolean;
    function SaveOneDatas(QObjectList: TList<TOneDataSet>): Boolean; overload;
    function SaveOneDatas(QObjectArray: array of TOneDataSet): Boolean;
      overload;
  end;

implementation

function TOneConnectionHelper.OpenOneData(Sender: TOneDataSet): Boolean;
begin
  Result := Self.OpenData(Sender);
end;

function TOneConnectionHelper.OpenOneDatas(QOpenDatas
  : TList<TOneDataSet>): Boolean;
var
  QList: TList<TObject>;
  i: Integer;
  lErrMsg: string;
begin
  lErrMsg := '';
  QList := TList<TObject>.Create;
  try
    for i := 0 to QOpenDatas.Count - 1 do
    begin
      QList.Add(QOpenDatas[i]);
    end;
    Result := Self.OpenDatas(QList, lErrMsg);
    if not Result then
    begin
      Self.ErrMsg := lErrMsg;
    end;

  finally
    QList.Clear;
    QList.Free;
  end;
end;

function TOneConnectionHelper.OpenOneDatas(QOpenDatas
  : array of TOneDataSet): Boolean;
var
  QList: TList<TObject>;
  i: Integer;
  lErrMsg: string;
begin
  QList := TList<TObject>.Create;
  try
    for i := Low(QOpenDatas) to High(QOpenDatas) do
    begin
      QList.Add(QOpenDatas[i]);
    end;
    Result := Self.OpenDatas(QList, lErrMsg);
    if not Result then
    begin
      Self.ErrMsg := lErrMsg;
    end;
  finally
    QList.Clear;
    QList.Free;
  end;
end;

function TOneConnectionHelper.SaveOneData(Sender: TOneDataSet): Boolean;
begin
  Result := Self.SaveData(Sender);
end;

function TOneConnectionHelper.SaveOneDatas(QObjectList
  : TList<TOneDataSet>): Boolean;
var
  QList: TList<TObject>;
  i: Integer;
  lErrMsg: string;
begin
  QList := TList<TObject>.Create;
  try
    for i := 0 to QObjectList.Count - 1 do
    begin
      QList.Add(QObjectList[i]);
    end;
    Result := Self.SaveDatas(QList, lErrMsg);
    if not Result then
    begin
      Self.ErrMsg := lErrMsg;
    end;
  finally
    QList.Clear;
    QList.Free;
  end;
end;

function TOneConnectionHelper.SaveOneDatas(QObjectArray
  : array of TOneDataSet): Boolean;
var
  QList: TList<TObject>;
  i: Integer;
  lErrMsg: string;
begin
  QList := TList<TObject>.Create;
  try
    for i := Low(QObjectArray) to High(QObjectArray) do
    begin
      QList.Add(QObjectArray[i]);
    end;
    Result := Self.SaveDatas(QList, lErrMsg);
    if not Result then
    begin
      Self.ErrMsg := lErrMsg;
    end;
  finally
    QList.Clear;
    QList.Free;
  end;
end;

end.

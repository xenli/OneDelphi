unit frmDemoSQLToClass;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  OneClientHelper, OneClientConnect, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  OneClientDataSet;

type
  TfrDemoSQLToClass = class(TForm)
    plSet: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label17: TLabel;
    edHTTPHost: TEdit;
    edHTTPPort: TEdit;
    edConnectSecretkey: TEdit;
    tbClientConnect: TButton;
    edZTCode: TEdit;
    tbClientDisConnect: TButton;
    OneConnection: TOneConnection;
    qryOpen: TOneDataSet;
    edSQL: TMemo;
    tbOpenData: TButton;
    edStruct: TMemo;
    Label4: TLabel;
    Label5: TLabel;
    tbToDelphi: TButton;
    tbToTsInterface: TButton;
    procedure tbClientConnectClick(Sender: TObject);
    procedure tbClientDisConnectClick(Sender: TObject);
    procedure tbOpenDataClick(Sender: TObject);
    procedure tbToDelphiClick(Sender: TObject);
    procedure tbToTsInterfaceClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frDemoSQLToClass: TfrDemoSQLToClass;

implementation

{$R *.dfm}


procedure TfrDemoSQLToClass.tbClientConnectClick(Sender: TObject);
begin
  if OneConnection.Connected then
  begin
    showMessage('已经连接成功,无需在连接');
    exit;
  end;
  OneConnection.HTTPHost := edHTTPHost.Text;
  OneConnection.HTTPPort := strToInt(edHTTPPort.Text);
  OneConnection.ZTCode := edZTCode.Text;
  OneConnection.ConnectSecretkey := edConnectSecretkey.Text;
  if not OneConnection.DoConnect() then
  begin
    showMessage(OneConnection.ErrMsg);
  end
  else
  begin
    showMessage('连接成功');
  end;
end;

procedure TfrDemoSQLToClass.tbClientDisConnectClick(Sender: TObject);
begin
  OneConnection.DisConnect;
end;

procedure TfrDemoSQLToClass.tbOpenDataClick(Sender: TObject);
var
  vUrl: string;
  i: integer;
begin
  if not OneConnection.Connected then
  begin
    showMessage('未连接请先连接');
    exit;
  end;
  // 或者在控件UI直接设置 Connection
  qryOpen.DataInfo.Connection := OneConnection;
  qryOpen.SQL.Text := edSQL.Lines.Text;

  if not qryOpen.OpenData then
  begin
    showMessage(qryOpen.DataInfo.ErrMsg);
    exit;
  end;
  showMessage('打开数据成功,可以生成相对应的类了');
end;

procedure TfrDemoSQLToClass.tbToDelphiClick(Sender: TObject);
var
  iField, iLen: integer;
  lField: TField;
  lFieldType: string;
  lPrivateDefs: TStringList;
  lPublishedDefs: TStringList;
begin
  if not qryOpen.Active then
  begin
    showMessage('请先打开数据');
    exit;
  end;
  edStruct.Lines.Clear;
  lPrivateDefs := TStringList.Create;
  lPublishedDefs := TStringList.Create;
  try
    for iField := 0 to qryOpen.Fields.Count - 1 do
    begin
      lField := qryOpen.Fields[iField];
      case lField.DataType of
        ftString, ftMemo, ftFmtMemo, ftWideString, ftFixedWideChar, ftWideMemo, ftGuid, ftOraInterval:
          begin
            lFieldType := 'string';
          end;
        ftBoolean:
          begin
            lFieldType := 'boolean';
          end;
        ftSmallint, ftInteger, ftWord, ftAutoInc, ftShortint, ftLongWord:
          begin
            lFieldType := 'integer';
          end;
        ftLargeint:
          begin
            lFieldType := 'int64';
          end;
        ftFloat, ftCurrency, ftBCD, ftFMTBcd, ftExtended, ftSingle:
          begin
            lFieldType := 'double';
          end;
        ftBytes, ftVarBytes, ftBlob, ftGraphic, ftTypedBinary, ftOraBlob, ftOraClob:
          begin
            lFieldType := 'string';
          end;
        ftTimeStamp, ftDateTime:
          begin
            lFieldType := 'TDateTime';
          end
      else
        begin
          lFieldType := 'string';
        end;
      end;
      lPrivateDefs.Add(lField.FieldName + '_: ' + lFieldType + ';');
      lPublishedDefs.Add('property ' + lField.FieldName + ': ' + lFieldType +
        ' read ' + lField.FieldName + '_' + ' write ' + lField.FieldName + '_' + ';');
    end;

    edStruct.Lines.Add('TMyClass = class');
    edStruct.Lines.Add('private');
    for iLen := 0 to lPrivateDefs.Count - 1 do
    begin
      edStruct.Lines.Add('  ' + lPrivateDefs.Strings[iLen]);
    end;
    edStruct.Lines.Add('published');
    for iLen := 0 to lPublishedDefs.Count - 1 do
    begin
      edStruct.Lines.Add('  ' + lPublishedDefs.Strings[iLen]);
    end;
    edStruct.Lines.Add('end;');
  finally
    lPrivateDefs.Free;
    lPublishedDefs.Free;
  end;

end;

procedure TfrDemoSQLToClass.tbToTsInterfaceClick(Sender: TObject);
var
  iField, iLen: integer;
  lField: TField;
  lFieldType: string;
  lPrivateDefs: TStringList;
begin
  if not qryOpen.Active then
  begin
    showMessage('请先打开数据');
    exit;
  end;
  edStruct.Lines.Clear;
  lPrivateDefs := TStringList.Create;
  try
    for iField := 0 to qryOpen.Fields.Count - 1 do
    begin
      lField := qryOpen.Fields[iField];
      case lField.DataType of
        ftString, ftMemo, ftFmtMemo, ftWideString, ftFixedWideChar, ftWideMemo, ftGuid, ftOraInterval:
          begin
            lFieldType := 'string';
          end;
        ftBoolean:
          begin
            lFieldType := 'boolean';
          end;
        ftSmallint, ftInteger, ftWord, ftAutoInc, ftShortint, ftLongWord:
          begin
            lFieldType := 'number';
          end;
        ftLargeint:
          begin
            lFieldType := 'number';
          end;
        ftFloat, ftCurrency, ftBCD, ftFMTBcd, ftExtended, ftSingle:
          begin
            lFieldType := 'number';
          end;
        ftBytes, ftVarBytes, ftBlob, ftGraphic, ftTypedBinary, ftOraBlob, ftOraClob:
          begin
            lFieldType := 'string';
          end;
        ftTimeStamp, ftDateTime:
          begin
            lFieldType := 'string';
          end
      else
        begin
          lFieldType := 'string';
        end;
      end;
      lPrivateDefs.Add(lField.FieldName + ': ' + lFieldType + ';');
    end;

    edStruct.Lines.Add('export interface IMyInterface {');
    for iLen := 0 to lPrivateDefs.Count - 1 do
    begin
      edStruct.Lines.Add('  ' + lPrivateDefs.Strings[iLen]);
    end;
    edStruct.Lines.Add('}');
  finally
    lPrivateDefs.Free;
  end;

end;

end.

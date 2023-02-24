unit frmDemoPostGet;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, System.JSON,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  OneClientHelper, OneClientConnect;

type
  TForm4 = class(TForm)
    plUrl: TPanel;
    Label4: TLabel;
    edMethod: TComboBox;
    edUrl: TEdit;
    tbRequest: TButton;
    GroupBox1: TGroupBox;
    edUrlParam: TMemo;
    Label5: TLabel;
    edPostResult: TMemo;
    Label6: TLabel;
    edParams: TMemo;
    Label7: TLabel;
    OneConnection: TOneConnection;
    edPostData: TMemo;
    Label1: TLabel;
    procedure edMethodChange(Sender: TObject);
    procedure tbRequestClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form4: TForm4;

implementation

{$R *.dfm}

procedure TForm4.edMethodChange(Sender: TObject);
var
  lJsonObj: TJsonObject;
  lBytes: TBytes;
  lStr: string;
begin
  if edMethod.ItemIndex = 0 then
  begin
    edParams.Lines.Clear;
    edParams.Lines.Add('name=范联满');
    edParams.Lines.Add('age=18')
  end;
  if edMethod.ItemIndex = 1 then
  begin
    edParams.Lines.Clear;
    lJsonObj := TJsonObject.Create;
    try
      lJsonObj.AddPair('name', '范联满');
      lJsonObj.AddPair('age', TJSonNumber.Create(18));
      edParams.Lines.Text := lJsonObj.ToString();
    finally
      lJsonObj.Free;
    end;
  end;

end;

procedure TForm4.tbRequestClick(Sender: TObject);
var
  lResultData: string;
  lUrl: string;
  tempStr: string;
  i: integer;
  tempArr: TArray<string>;
begin
  lUrl := edUrl.Text;
  if lUrl = '' then
  begin
    showMessage('请求URL地址不可为空');
    exit;
  end;
  for i := 0 to edUrlParam.Lines.Count - 1 do
  begin
    tempStr := edUrlParam.Lines[i];
    if tempStr.Trim = '' then
      continue;
    tempArr := tempStr.Split(['=']);
    if Length(tempArr) = 2 then
    begin
      if lUrl.IndexOf('?') > 0 then
      begin
        lUrl := lUrl + '&' + tempStr;
      end
      else
      begin
        lUrl := lUrl + '?' + tempStr;
      end;
    end;
  end;
  if edMethod.ItemIndex = 0 then
  begin
    // Get请求
    OneConnection.GetResultContent(lUrl, lResultData);
    edPostResult.Lines.Text := lResultData;
  end
  else if edMethod.ItemIndex = 1 then
  begin
    // Post请求
    OneConnection.PostResultContent(lUrl, edPostData.Lines.Text, lResultData);
    edPostResult.Lines.Text := lResultData;
  end;
end;

end.

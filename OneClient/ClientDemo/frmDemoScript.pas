unit frmDemoScript;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  OneClientHelper, OneClientConnect, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  OneClientDataSet;

type
  TfrDemoScript = class(TForm)
    plSet: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label17: TLabel;
    edHTTPHost: TEdit;
    edHTTPPort: TEdit;
    edConnectSecretkey: TEdit;
    tbClientConnect: TButton;
    tbClientDisConnect: TButton;
    edZTCode: TEdit;
    OneConnection: TOneConnection;
    qryScript: TOneDataSet;
    edScript: TMemo;
    tbSciprt: TButton;
    procedure tbClientConnectClick(Sender: TObject);
    procedure tbClientDisConnectClick(Sender: TObject);
    procedure tbSciprtClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frDemoScript: TfrDemoScript;

implementation

{$R *.dfm}


procedure TfrDemoScript.tbClientConnectClick(Sender: TObject);
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
    // 全局设置，如果控件没挂勾 connetion,默认走的就是全局的
    OneClientConnect.Unit_Connection := OneConnection;
    showMessage('连接成功');
  end;
end;

procedure TfrDemoScript.tbClientDisConnectClick(Sender: TObject);
begin
  OneConnection.DisConnect;
end;

procedure TfrDemoScript.tbSciprtClick(Sender: TObject);
begin
  if edScript.Lines.Count = 0 then
  begin
    showMessage('无相关脚本,请先输入脚本');
    exit;
  end;
  qryScript.SQL.Text := edScript.Lines.Text;
  if not qryScript.ExecScript then
  begin
    showMessage(qryScript.DataInfo.ErrMsg);
    exit;
  end
  else
  begin
    showMessage('执行脚本成功');
  end;
end;

end.

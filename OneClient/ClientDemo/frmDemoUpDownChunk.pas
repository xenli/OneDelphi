unit frmDemoUpDownChunk;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, System.Math,
  OneClientHelper, OneClientConnect, OneClientVirtualFile, Vcl.ComCtrls, OneClientConst;

type

  { TForm7 }

  TForm7 = class(TForm)
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
    edRemark: TMemo;
    groupUpload: TGroupBox;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    edVirtualCodeA: TEdit;
    edRemoteFileA: TEdit;
    edLocalFileA: TEdit;
    tbUpLoad: TButton;
    edNewFileName: TEdit;
    groupDown: TGroupBox;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    edVirtualCodeB: TEdit;
    edRemoteFileB: TEdit;
    edLocalFileB: TEdit;
    tbDownLoad: TButton;
    OneVirtualFile: TOneVirtualFile;
    OneConnection: TOneConnection;
    tbUpLoadList: TButton;
    edLocalFileAList: TMemo;
    Label12: TLabel;
    ProgressList: TProgressBar;
    ProgressFile: TProgressBar;
    procedure tbClientConnectClick(Sender: TObject);
    procedure tbUpLoadClick(Sender: TObject);
    procedure tbDownLoadClick(Sender: TObject);
    procedure tbUpLoadListClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form7: TForm7;

implementation

{$R *.dfm}

procedure TForm7.tbClientConnectClick(Sender: TObject);
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

procedure TForm7.tbDownLoadClick(Sender: TObject);
begin
  OneVirtualFile.VirtualCode := edVirtualCodeB.Text;
  OneVirtualFile.RemoteFile := edRemoteFileB.Text;
  OneVirtualFile.LocalFile := edLocalFileB.Text;
  OneVirtualFile.DownloadChunkFileAsync(
    procedure(QUpDownMode: emUpDownMode; QStatus: emUpDownChunkStatus; QTotalSize: Int64; QPosition: Int64; QErrmsg: string)
    begin
      application.ProcessMessages;
      case QStatus of
        emUpDownChunkStatus.upDownStart:
          begin
            // 文件开始上传进度
            ProgressFile.Visible := True;
            ProgressFile.Max := QTotalSize;
            ProgressFile.Position := 0;
          end;
        emUpDownChunkStatus.upDownProcess:
          begin
            // 文件下载进度
            ProgressFile.Visible := True;
            ProgressFile.Position := QPosition;
          end;
        emUpDownChunkStatus.upDownEnd:
          begin
            ProgressFile.Position := QPosition;
            ProgressFile.Visible := False;
            showMessage('文件下载成功')
          end;
        emUpDownChunkStatus.upDownErr:
          begin
            // 上传错误提示
            showMessage(QErrmsg);
          end;
      end;
    end);
end;

procedure TForm7.tbUpLoadClick(Sender: TObject);
begin
  OneVirtualFile.VirtualCode := edVirtualCodeA.Text;
  OneVirtualFile.RemoteFile := edRemoteFileA.Text;
  OneVirtualFile.LocalFile := edLocalFileA.Text;
  OneVirtualFile.UploadChunkFileAsync(
    procedure(QUpDownMode: emUpDownMode; QStatus: emUpDownChunkStatus; QTotalSize: Int64; QPosition: Int64; QErrmsg: string)
    begin
      application.ProcessMessages;
      case QStatus of
        emUpDownChunkStatus.upDownStart:
          begin
            // 文件开始上传进度
            ProgressFile.Visible := True;
            ProgressFile.Max := QTotalSize;
            ProgressFile.Position := 0;
          end;
        emUpDownChunkStatus.upDownProcess:
          begin
            // 文件下载进度
            ProgressFile.Visible := True;
            ProgressFile.Position := QPosition;
          end;
        emUpDownChunkStatus.upDownEnd:
          begin
            ProgressFile.Position := QPosition;
            ProgressFile.Visible := False;
            showMessage('文件上传成功')
          end;
        emUpDownChunkStatus.upDownErr:
          begin
            // 上传错误提示
            ProgressFile.Visible := False;
            ProgressList.Visible := False;
            showMessage(QErrmsg);
          end;
      end;
    end);
end;

procedure TForm7.tbUpLoadListClick(Sender: TObject);
var
  i: integer;
begin
  OneVirtualFile.VirtualCode := edVirtualCodeA.Text;
  OneVirtualFile.RemoteFile := edRemoteFileA.Text;
  OneVirtualFile.LocalFile := edLocalFileA.Text;
  OneVirtualFile.FileList.Clear;
  for i := 0 to edLocalFileAList.Lines.Count - 1 do
  begin
    OneVirtualFile.FileList.Add(edLocalFileAList.Lines[i]);
  end;
  OneVirtualFile.UploadFileListAsync(
    procedure(QUpDownMode: emUpDownMode; QStatus: emUpDownChunkStatus; QTotalSize: Int64; QPosition: Int64; QErrmsg: string)
    begin
      application.ProcessMessages;
      case QStatus of
        emUpDownChunkStatus.upDownStart:
          begin
            // 文件开始上传进度
            ProgressFile.Visible := True;
            ProgressFile.Max := QTotalSize;
            ProgressFile.Position := 0;
          end;
        emUpDownChunkStatus.upDownProcess:
          begin
            // 文件下载进度
            ProgressFile.Visible := True;
            ProgressFile.Position := QPosition;
          end;
        emUpDownChunkStatus.upDownEnd:
          begin
            ProgressFile.Position := QPosition;
            ProgressFile.Visible := False;
            if not OneVirtualFile.IsBatch then
            begin
              if QUpDownMode = emUpDownMode.UpLoad then
                showMessage('文件上传成功')
              else
                showMessage('文件下载成功');
            end;
          end;
        emUpDownChunkStatus.upDownListStar:
          begin
            // 多个文件上传开始
            ProgressList.Visible := True;
            ProgressList.Max := QTotalSize;
            ProgressList.Position := 0;
          end;
        emUpDownChunkStatus.upDownListProcess:
          begin
            ProgressList.Visible := True;
            ProgressList.Position := QPosition;
          end;
        emUpDownChunkStatus.upDownListEnd:
          begin
            ProgressList.Visible := False;
            ProgressList.Position := QPosition;
            if OneVirtualFile.IsBatch then
            begin
              if QUpDownMode = emUpDownMode.UpLoad then
                showMessage('文件列表上传成功')
              else
                showMessage('文件列表下载成功');
            end;
          end;
        emUpDownChunkStatus.upDownErr:
          begin
            // 上传错误提示
            ProgressFile.Visible := False;
            ProgressList.Visible := False;
            showMessage(QErrmsg);
          end;
      end;
    end);
end;

end.

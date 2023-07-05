unit frmWait;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, System.SyncObjs;

type
  TfrWaitHint = class(TForm)
    TimerCacle: TTimer;
    lbHint: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure TimerCacleTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FInterval: Integer;
  public
    { Public declarations }
  end;

procedure ShowWaitForm();
procedure CloseWaitForm();

var
  frWaitHint: TfrWaitHint;

implementation

{$R *.dfm}


var
  var_LockInt: Integer = 0;
  var_WaitCS: TCriticalSection;

procedure LockInt();
begin
  var_WaitCS.Enter;
  try
    var_LockInt := var_LockInt + 1;
  finally
    var_WaitCS.Leave;
  end;
end;

procedure UnLockInt();
begin
  // 多线程临界区
  var_WaitCS.Enter;
  try
    var_LockInt := var_LockInt - 1;
    if var_LockInt <= 0 then
      var_LockInt := 0;
  finally
    var_WaitCS.Leave;
  end;
end;

function IsShowWait: Boolean;
begin
  // 多线程临界区
  var_WaitCS.Enter;
  try
    Result := (var_LockInt > 0);
  finally
    var_WaitCS.Leave;
  end;
end;

procedure ShowWaitForm();
begin
  LockInt();
  TThread.CreateAnonymousThread(
    procedure()
    begin
      // 延迟几秒展示,可以设定一个1.5秒,也可以按自已喜好设置
      sleep(1500);
      if not IsShowWait then
      begin
        // 网络请求很快,小于上面设置的sleep,无需展示等待界面 。
        exit;
      end;
      // 展示等待界面
      // var_WaitCS.Enter;
      TThread.Synchronize(nil,
        procedure()
        begin
          try
            if assigned(frWaitHint) then
            begin
              frWaitHint.Visible := true;
              frWaitHint.BringToFront;
              exit;
            end;
            frWaitHint := TfrWaitHint.Create(nil);
            frWaitHint.Show;
          finally
          end;
        end);

    end
    ).Start;
end;

procedure CloseWaitForm();
begin
  UnLockInt();
  // 说明还有请求没完成
  if IsShowWait then
    exit;
  var_WaitCS.Enter;
  try
    if assigned(frWaitHint) then
    begin
      frWaitHint.Close;
    end;
  finally
    frWaitHint := nil;
    var_WaitCS.Leave;
  end;
end;

procedure TfrWaitHint.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfrWaitHint.FormCreate(Sender: TObject);
begin
  FInterval := 0;
  TimerCacle.Enabled := true;
end;

procedure TfrWaitHint.TimerCacleTimer(Sender: TObject);
begin
  FInterval := FInterval + 1;
  lbHint.Caption := '[网络延迟]正在加载中请稍候,加载用时:' + FInterval.ToString + '秒';
end;

initialization

var_WaitCS := TCriticalSection.Create;

finalization

var_WaitCS.Free;

end.

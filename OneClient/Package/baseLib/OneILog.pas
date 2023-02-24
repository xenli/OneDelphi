unit OneILog;

interface

type
  IOneLog = interface
    // 只有调试模式下才写入日记
    Procedure WriteDebug(const QMsg: string);
    // 写入公共日记
    procedure WriteLog(const QMsg: string); Overload;
    // 写入日记
    procedure WriteLog(QLogCode: string; const QMsg: string); Overload;
    // 写入日记到 专门SQL日记
    procedure WriteSQLLog(const QMsg: string);
    // 写入日记到专门 HTTP日记
    procedure WriteHTTPLog(const QMsg: string);
    function IsSQLLog(): boolean;
    function IsHTTPLog(): boolean;
    // 开始工作
    procedure StarWork;
    // 停止工作
    procedure StopWork;
  end;

var
  unit_IOneLog: IOneLog = nil;

implementation

end.

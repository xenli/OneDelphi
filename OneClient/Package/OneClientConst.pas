unit OneClientConst;

interface

// 如果编绎不过去的提供相对应的版本给我，我加上去
uses System.Classes;

const
  OneAllPlatforms = {$IF CompilerVersion >= 33}     // 10.3版本
    pfidOSX or pfidiOS or pfidAndroid or pfidLinux or
{$ENDIF}
{$IF CompilerVersion = 32}   // 10.2版本
    pidOSX32 or pidiOSSimulator or pidiOSDevice32 or pidiOSDevice64 or pidAndroid or pidLinux64 or
{$ENDIF}
{$IF CompilerVersion = 31}   // 10.1版本
    pidOSX32 or pidiOSSimulator or pidiOSDevice32 or pidiOSDevice64 or pidAndroid or pidLinux64 or
{$ENDIF}
    pidWin32 or pidWin64;

type
  // upDownErr上传下载错误
  // upDownStart上传开始，获取上传任务taskID及文件大小，上传位置0
  // upDownProcess上传下载进度
  // upDownEnd 上传下载完成
  // upDownListStar批量文件上传开始,返回文件个数
  // upDownListProcess批量文件上传进度
  // upDownListEnd批量文件上传结束
  emUpDownMode = (UpLoad, DownLoad);
  emUpDownChunkStatus = (upDownUnknow, upDownErr, upDownStart, upDownProcess, upDownEnd, upDownListStar, upDownListProcess, upDownListEnd);
  EvenUpDownChunkCallBack = reference to procedure(QUpDownMode: emUpDownMode; QStatus: emUpDownChunkStatus; QTotalSize: int64; QPosition: int64; QErrmsg: string);

  EvenOKCallBack = reference to procedure(QIsOK: boolean; QErrmsg: string);

  TVirtualInfo = class
  private
    // 虚拟代码
    FVirtualCode: string;
    // 服务端路径文件
    FRemoteFile: string;
    //
    FRemoteFileName: string;
    //
    FLocalFile: string;
    //
    FStreamBase64: string;
    // 错误消息
    FErrMsg: string;
  public
    property VirtualCode: string read FVirtualCode write FVirtualCode;
    property RemoteFile: string read FRemoteFile write FRemoteFile;
    property RemoteFileName: string read FRemoteFileName write FRemoteFileName;
    property LocalFile: string read FLocalFile write FLocalFile;
    /// <param name="StreamBase64">流转化成base64</param>
    property StreamBase64: string read FStreamBase64 write FStreamBase64;
    property ErrMsg: string read FErrMsg write FErrMsg;
  end;

  TVirtualTask = class
  private
    FTaskID: string;
    FFileTotalSize: int64;
    FFileChunSize: int64;
    FFilePosition: int64;
    FVirtualCode: string;
    FRemoteFile: string;
    FLocalFile: string;
    FStreamBase64: string;
    FUpDownMode: string;
    FFileName: string;
    FNewFileName: string;
    FLastTime: TDateTime;
    FErrMsg: string;
    FIsEnd: boolean;
  public
    property TaskID: string read FTaskID write FTaskID;
    property FileTotalSize: int64 read FFileTotalSize write FFileTotalSize;
    property FileChunSize: int64 read FFileChunSize write FFileChunSize;
    property FilePosition: int64 read FFilePosition write FFilePosition;
    property VirtualCode: string read FVirtualCode write FVirtualCode;
    property RemoteFile: string read FRemoteFile write FRemoteFile;
    property LocalFile: string read FLocalFile write FLocalFile;
    property StreamBase64: string read FStreamBase64 write FStreamBase64;
    property UpDownMode: string read FUpDownMode write FUpDownMode;
    property FileName: string read FFileName write FFileName;
    property NewFileName: string read FNewFileName write FNewFileName;
    property ErrMsg: string read FErrMsg write FErrMsg;
    property IsEnd: boolean read FIsEnd write FIsEnd;
  end;

  TZTInfo = class
  private
    FZTCode: string;
    FZTCaption: string;
  public
    property ZTCode: string read FZTCode write FZTCode;
    property ZTCaption: string read FZTCaption write FZTCaption;
  end;

implementation

end.

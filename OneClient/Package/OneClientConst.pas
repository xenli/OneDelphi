unit OneClientConst;

interface

// ������ﲻ��ȥ���ṩ���Ӧ�İ汾���ң��Ҽ���ȥ
uses System.Classes;

const
  OneAllPlatforms = {$IF CompilerVersion >= 33}     // 10.3�汾
    pfidOSX or pfidiOS or pfidAndroid or pfidLinux or
{$ENDIF}
{$IF CompilerVersion = 32}   // 10.2�汾
    pidOSX32 or pidiOSSimulator or pidiOSDevice32 or pidiOSDevice64 or pidAndroid or pidLinux64 or
{$ENDIF}
{$IF CompilerVersion = 31}   // 10.1�汾
    pidOSX32 or pidiOSSimulator or pidiOSDevice32 or pidiOSDevice64 or pidAndroid or pidLinux64 or
{$ENDIF}
    pidWin32 or pidWin64;

type
  // upDownErr�ϴ����ش���
  // upDownStart�ϴ���ʼ����ȡ�ϴ�����taskID���ļ���С���ϴ�λ��0
  // upDownProcess�ϴ����ؽ���
  // upDownEnd �ϴ��������
  // upDownListStar�����ļ��ϴ���ʼ,�����ļ�����
  // upDownListProcess�����ļ��ϴ�����
  // upDownListEnd�����ļ��ϴ�����
  emUpDownMode = (UpLoad, DownLoad);
  emUpDownChunkStatus = (upDownUnknow, upDownErr, upDownGetTask, upDownStart, upDownProcess, upDownEnd,
    upDownSaveFileOk, upDownListStar, upDownListProcess, upDownListEnd);
  EvenUpDownChunkCallBack = reference to procedure(QUpDownMode: emUpDownMode; QStatus: emUpDownChunkStatus; QTotalSize: int64; QPosition: int64; QErrmsg: string);

  EvenOKCallBack = reference to procedure(QIsOK: boolean; QErrmsg: string);

  TVirtualInfo = class
  private
    // �������
    FVirtualCode: string;
    // �����·���ļ�
    FRemoteFile: string;
    //
    FRemoteFileName: string;
    //
    FLocalFile: string;
    //
    FStreamBase64: string;
    // ������Ϣ
    FErrMsg: string;
  public
    property VirtualCode: string read FVirtualCode write FVirtualCode;
    property RemoteFile: string read FRemoteFile write FRemoteFile;
    property RemoteFileName: string read FRemoteFileName write FRemoteFileName;
    property LocalFile: string read FLocalFile write FLocalFile;
    /// <param name="StreamBase64">��ת����base64</param>
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

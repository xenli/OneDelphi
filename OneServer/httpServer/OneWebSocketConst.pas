unit OneWebSocketConst;

interface

const
  WsMsg_cmd_toUserMsg = 'ToUserMsg';
  WsMsg_cmd_ServerNotify = 'ServerNotify';
  WsMsg_cmd_WsUserIDGet = 'WsUserIDGet';

type
  TWsMsg = class
  private
    // 消息ID
    FMsgID: string;
    //
    FControllerRoot: string;
    // 发送者ConnectionID,'-1'代表发送出去,基它值代表是接收到消息
    FFromUserID: string;
    FFromUserName: string;
    // 接收者ConnectionID
    FToUserID: string;
    // 消息成功失败代码
    FMsgCode: string;
    // 消息命令
    FMsgCmd: string;
    // 消息
    FMsgData: string;
    // 消息时间
    FMsgTime: string;
  published
    property MsgID: string read FMsgID write FMsgID;
    property ControllerRoot: string read FControllerRoot write FControllerRoot;
    property FromUserID: string read FFromUserID write FFromUserID;
    property FromUserName: string read FFromUserName write FFromUserName;
    property ToUserID: string read FToUserID write FToUserID;
    property MsgCode: string read FMsgCode write FMsgCode;
    property MsgCmd: string read FMsgCmd write FMsgCmd;
    property MsgData: string read FMsgData write FMsgData;
    property MsgTime: string read FMsgTime write FMsgTime;
  end;

implementation

end.

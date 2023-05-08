object frDemWsChat: TfrDemWsChat
  Left = 0
  Top = 0
  Caption = #22312#32447#32842#22825
  ClientHeight = 561
  ClientWidth = 881
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  StyleName = 'Windows'
  OnCreate = FormCreate
  TextHeight = 15
  object plSet: TPanel
    Left = 0
    Top = 0
    Width = 881
    Height = 80
    Align = alTop
    TabOrder = 0
    object Label1: TLabel
      Left = 4
      Top = 17
      Width = 54
      Height = 15
      Caption = 'HTTP'#22320#22336
    end
    object Label2: TLabel
      Left = 212
      Top = 17
      Width = 54
      Height = 15
      Caption = 'HTTP'#31471#21475
    end
    object Label3: TLabel
      Left = 420
      Top = 17
      Width = 52
      Height = 15
      Caption = #36830#25509#23494#38053
    end
    object Label17: TLabel
      Left = 4
      Top = 55
      Width = 52
      Height = 15
      Caption = #36134#22871#20195#30721
    end
    object edHTTPHost: TEdit
      Left = 72
      Top = 14
      Width = 121
      Height = 23
      TabOrder = 0
      Text = '127.0.0.1'
    end
    object edHTTPPort: TEdit
      Left = 280
      Top = 14
      Width = 121
      Height = 23
      TabOrder = 1
      Text = '9090'
    end
    object edConnectSecretkey: TEdit
      Left = 488
      Top = 14
      Width = 241
      Height = 23
      TabOrder = 2
      Text = 'DC426FEC0B4C4E8A951B1B8575BB1151'
    end
    object tbClientConnect: TButton
      Left = 735
      Top = 13
      Width = 114
      Height = 25
      Caption = #36830#25509
      TabOrder = 3
      OnClick = tbClientConnectClick
    end
    object tbClientDisConnect: TButton
      Left = 735
      Top = 44
      Width = 114
      Height = 25
      Caption = #26029#24320#36830#25509
      TabOrder = 4
      OnClick = tbClientDisConnectClick
    end
    object edZTCode: TEdit
      Left = 72
      Top = 52
      Width = 121
      Height = 23
      TabOrder = 5
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 80
    Width = 881
    Height = 49
    Align = alTop
    TabOrder = 1
    object Label4: TLabel
      Left = 12
      Top = 17
      Width = 42
      Height = 15
      Caption = 'Ws'#22320#22336
    end
    object Label5: TLabel
      Left = 220
      Top = 17
      Width = 42
      Height = 15
      Caption = 'Ws'#31471#21475
    end
    object edWsIP: TEdit
      Left = 80
      Top = 14
      Width = 121
      Height = 23
      TabOrder = 0
      Text = '127.0.0.1'
    end
    object edWsPort: TEdit
      Left = 288
      Top = 14
      Width = 121
      Height = 23
      NumbersOnly = True
      TabOrder = 1
      Text = '9099'
    end
    object tbWsConnect: TButton
      Left = 591
      Top = 13
      Width = 114
      Height = 25
      Caption = #36830#25509
      TabOrder = 2
      OnClick = tbWsConnectClick
    end
    object tbWsDisConnect: TButton
      Left = 735
      Top = 13
      Width = 114
      Height = 25
      Caption = #26029#24320#36830#25509
      TabOrder = 3
      OnClick = tbWsDisConnectClick
    end
    object checkWss: TCheckBox
      Left = 432
      Top = 17
      Width = 153
      Height = 17
      Caption = #21551#29992'-Wss'#27809#20107#21035#20081#21246
      TabOrder = 4
    end
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 135
    Width = 401
    Height = 418
    Caption = #22312#32447#29992#25143'-'#21452#20987#36873#20013#35201#21457#36865#30340#29992#25143
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentBackground = False
    ParentColor = False
    ParentFont = False
    TabOrder = 2
    StyleName = 'Windows'
    object tbGetOnLineUser: TButton
      Left = 2
      Top = 17
      Width = 397
      Height = 40
      Align = alTop
      Caption = #33719#21462#22312#32447#29992#25143
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      OnClick = tbGetOnLineUserClick
    end
    object DBGrid1: TDBGrid
      Left = 2
      Top = 57
      Width = 397
      Height = 359
      Align = alClient
      DataSource = dsUser
      TabOrder = 1
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clRed
      TitleFont.Height = -12
      TitleFont.Name = 'Segoe UI'
      TitleFont.Style = []
      OnDblClick = DBGrid1DblClick
      Columns = <
        item
          Expanded = False
          FieldName = 'WsUserID'
          Title.Caption = 'Ws'#29992#25143'ID'
          Width = 151
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'UserName'
          Title.Caption = #29992#25143
          Width = 150
          Visible = True
        end>
    end
  end
  object groupMsg: TGroupBox
    Left = 415
    Top = 135
    Width = 450
    Height = 418
    Caption = #28040#24687#21457#36865
    Color = clBtnFace
    ParentBackground = False
    ParentColor = False
    TabOrder = 3
    object edMessage: TMemo
      Left = 3
      Top = 57
      Width = 444
      Height = 358
      ScrollBars = ssBoth
      TabOrder = 0
    end
    object edSendMsg: TEdit
      Left = 3
      Top = 23
      Width = 318
      Height = 28
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
    end
    object tbSendMsg: TButton
      Left = 333
      Top = 26
      Width = 114
      Height = 25
      Caption = #28040#24687#21457#36865
      TabOrder = 2
      OnClick = tbSendMsgClick
    end
  end
  object OneConnection: TOneConnection
    Connected = False
    IsHttps = False
    HTTPHost = '127.0.0.1'
    HTTPPort = 9090
    ConnectSecretkey = '354575E87B2642C68F798694B81AF6EF'
    TokenID = '0EE8C899FFB54F66A3C5C3B742806FDA'
    PrivateKey = '9AAE70B9545D4FCE98A5CB6FFCA69B2E'
    ConnectionTimeout = 0
    ResponseTimeout = 0
    ErrMsg = #35831#27714#21457#29983#24322#24120':Error sending data: (12029) '#26080#27861#19982#26381#21153#22120#24314#31435#36830#25509
    Left = 288
    Top = 48
  end
  object OneWsClient: TOneWebSocketClient
    HttpConnection = OneConnection
    IsWss = False
    WsPort = 0
    WsProtocol = 'Onews'
    OnReceiveMessage = OneWsClientReceiveMessage
    OnOneWsMsg = OneWsClientOneWsMsg
    OnWsUserIDGet = OneWsClientWsUserIDGet
    Left = 376
    Top = 40
  end
  object qryUser: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 232
    Top = 264
    object qryUserWsUserID: TWideStringField
      FieldName = 'WsUserID'
      Size = 50
    end
    object qryUserUserName: TWideStringField
      FieldName = 'UserName'
      Size = 50
    end
  end
  object dsUser: TDataSource
    DataSet = qryUser
    Left = 232
    Top = 327
  end
  object IdHTTP1: TIdHTTP
    ProxyParams.BasicAuthentication = False
    ProxyParams.ProxyPort = 0
    Request.ContentLength = -1
    Request.ContentRangeEnd = -1
    Request.ContentRangeStart = -1
    Request.ContentRangeInstanceLength = -1
    Request.Accept = 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8'
    Request.BasicAuthentication = False
    Request.UserAgent = 'Mozilla/3.0 (compatible; Indy Library)'
    Request.Ranges.Units = 'bytes'
    Request.Ranges = <>
    HTTPOptions = [hoForceEncodeParams]
    Left = 216
    Top = 455
  end
end

object frDemoWebSocket: TfrDemoWebSocket
  Left = 0
  Top = 0
  Caption = 'WebSocket-'#36890#35759
  ClientHeight = 518
  ClientWidth = 898
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object Label3: TLabel
    Left = 8
    Top = 98
    Width = 52
    Height = 15
    Caption = #28040#24687#23637#31034
  end
  object plSet: TPanel
    Left = 0
    Top = 0
    Width = 898
    Height = 49
    Align = alTop
    TabOrder = 0
    ExplicitWidth = 894
    object Label1: TLabel
      Left = 12
      Top = 17
      Width = 42
      Height = 15
      Caption = 'Ws'#22320#22336
    end
    object Label2: TLabel
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
    object tbClientConnect: TButton
      Left = 591
      Top = 13
      Width = 114
      Height = 25
      Caption = #36830#25509
      TabOrder = 2
      OnClick = tbClientConnectClick
    end
    object tbClientDisConnect: TButton
      Left = 743
      Top = 13
      Width = 114
      Height = 25
      Caption = #26029#24320#36830#25509
      TabOrder = 3
      OnClick = tbClientDisConnectClick
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
  object edMessage: TMemo
    Left = 8
    Top = 120
    Width = 577
    Height = 390
    ScrollBars = ssBoth
    TabOrder = 1
  end
  object edSendMsg: TEdit
    Left = 8
    Top = 64
    Width = 577
    Height = 28
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
  end
  object tbSendMsg: TButton
    Left = 591
    Top = 64
    Width = 114
    Height = 25
    Caption = #28040#24687#21457#36865
    TabOrder = 3
    OnClick = tbSendMsgClick
  end
  object OneWsClient: TOneWebSocketClient
    IsWss = False
    WsPort = 0
    WsProtocol = 'Onews'
    OnReceiveMessage = OneWsClientReceiveMessage
    Left = 216
    Top = 152
  end
end

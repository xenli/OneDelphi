object frDemoUpdate: TfrDemoUpdate
  Left = 0
  Top = 0
  Caption = #21319#32423#21151#33021
  ClientHeight = 441
  ClientWidth = 871
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object Label4: TLabel
    Left = 24
    Top = 107
    Width = 91
    Height = 15
    Caption = #21319#32423#25991#20214#24635#36827#24230
  end
  object Label5: TLabel
    Left = 24
    Top = 140
    Width = 78
    Height = 15
    Caption = #19979#36733#25991#20214#36827#24230
  end
  object plSet: TPanel
    Left = 0
    Top = 0
    Width = 871
    Height = 80
    Align = alTop
    TabOrder = 0
    ExplicitWidth = 867
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
  end
  object ProgressFileCount: TProgressBar
    Left = 128
    Top = 103
    Width = 417
    Height = 25
    TabOrder = 1
  end
  object ProgressFileSize: TProgressBar
    Left = 128
    Top = 134
    Width = 417
    Height = 25
    TabOrder = 2
  end
  object tbUpdateOK: TButton
    Left = 584
    Top = 134
    Width = 145
    Height = 25
    Caption = #21319#32423
    TabOrder = 3
    OnClick = tbUpdateOKClick
  end
  object tbResh: TButton
    Left = 584
    Top = 103
    Width = 145
    Height = 25
    Caption = #21047#26032#26381#21153#31471#21319#32423#37197#32622
    TabOrder = 4
    OnClick = tbReshClick
  end
  object edUpdate: TMemo
    Left = 8
    Top = 184
    Width = 721
    Height = 225
    Lines.Strings = (
      #21319#32423#26085#35760)
    TabOrder = 5
  end
  object OneFastUpdate1: TOneFastUpdate
    Connection = OneConnection
    UpdateCode = 'MyTest'
    OnCallBack = OneFastUpdate1CallBack
    Left = 128
    Top = 200
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
    Left = 120
    Top = 256
  end
  object IdTCPClient1: TIdTCPClient
    ConnectTimeout = 0
    Port = 0
    ReadTimeout = -1
    Left = 352
    Top = 296
  end
  object IdIOHandlerStack1: TIdIOHandlerStack
    MaxLineAction = maException
    Port = 0
    DefaultPort = 0
    Left = 240
    Top = 344
  end
  object IdIOHandlerStream1: TIdIOHandlerStream
    MaxLineAction = maException
    Port = 0
    FreeStreams = False
    Left = 160
    Top = 336
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
    Left = 384
    Top = 232
  end
end

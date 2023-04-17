object frDemoSQLToClass: TfrDemoSQLToClass
  Left = 0
  Top = 0
  Caption = 'SQL'#29983#25104#31867
  ClientHeight = 526
  ClientWidth = 895
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object Label4: TLabel
    Left = 8
    Top = 86
    Width = 302
    Height = 15
    Caption = 'SQL'#35821#21477'-'#26368#22909#21152#19978#26465#20214'where 1=2'#25171#24320#19968#20010#31354#25968#25454#23601#34892
  end
  object Label5: TLabel
    Left = 430
    Top = 86
    Width = 52
    Height = 15
    Caption = #32467#26500#29983#25104
  end
  object plSet: TPanel
    Left = 0
    Top = 0
    Width = 895
    Height = 80
    Align = alTop
    TabOrder = 0
    ExplicitWidth = 891
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
    object edZTCode: TEdit
      Left = 72
      Top = 52
      Width = 121
      Height = 23
      TabOrder = 4
    end
    object tbClientDisConnect: TButton
      Left = 735
      Top = 44
      Width = 114
      Height = 25
      Caption = #26029#24320#36830#25509
      TabOrder = 5
      OnClick = tbClientDisConnectClick
    end
  end
  object edSQL: TMemo
    Left = 8
    Top = 107
    Width = 393
    Height = 155
    Lines.Strings = (
      'select'
      '*'
      'from onefast_admin'
      'where 1=2 ')
    ScrollBars = ssBoth
    TabOrder = 1
  end
  object tbOpenData: TButton
    Left = 8
    Top = 268
    Width = 393
    Height = 25
    Caption = #25171#24320#25968#25454
    TabOrder = 2
    OnClick = tbOpenDataClick
  end
  object edStruct: TMemo
    Left = 430
    Top = 107
    Width = 465
    Height = 411
    Lines.Strings = (
      '')
    ScrollBars = ssBoth
    TabOrder = 3
  end
  object tbToDelphi: TButton
    Left = 8
    Top = 299
    Width = 137
    Height = 25
    Cancel = True
    Caption = #29983#25104'Delphi'#31867
    TabOrder = 4
    OnClick = tbToDelphiClick
  end
  object tbToTsInterface: TButton
    Left = 257
    Top = 299
    Width = 144
    Height = 25
    Cancel = True
    Caption = #29983#25104'TS-Interface'
    TabOrder = 5
    OnClick = tbToTsInterfaceClick
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
    Left = 400
    Top = 40
  end
  object qryOpen: TOneDataSet
    CachedUpdates = True
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvUpdateMode, uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    DataInfo.MetaInfoKind = mkNone
    DataInfo.OpenMode = openData
    DataInfo.SaveMode = saveData
    DataInfo.DataReturnMode = dataStream
    DataInfo.PageSize = -1
    DataInfo.PageIndex = 0
    DataInfo.PageCount = 0
    DataInfo.PageTotal = 0
    DataInfo.AffectedMaxCount = 0
    DataInfo.AffectedMustCount = 1
    DataInfo.RowsAffected = 0
    DataInfo.AsynMode = False
    DataInfo.IsReturnData = False
    DataInfo.TranSpanSec = 0
    Params = <>
    MultiIndex = 0
    ActiveDesign = False
    Left = 400
    Top = 104
  end
end

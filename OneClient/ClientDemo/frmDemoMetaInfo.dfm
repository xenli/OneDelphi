object frDemoMetaInfo: TfrDemoMetaInfo
  Left = 0
  Top = 0
  Caption = #33719#21462#25968#25454#32467#26500
  ClientHeight = 441
  ClientWidth = 867
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object plSet: TPanel
    Left = 0
    Top = 0
    Width = 867
    Height = 80
    Align = alTop
    TabOrder = 0
    ExplicitLeft = -275
    ExplicitWidth = 899
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
  object Panel1: TPanel
    Left = 0
    Top = 80
    Width = 867
    Height = 41
    Align = alTop
    TabOrder = 1
    ExplicitLeft = 368
    ExplicitTop = 224
    ExplicitWidth = 185
    object Label4: TLabel
      Left = 4
      Top = 10
      Width = 78
      Height = 15
      Caption = #25351#23450#25968#25454#20803#32032
    end
    object tbGetTables: TButton
      Left = 292
      Top = 6
      Width = 77
      Height = 25
      Caption = #33719#21462#34920#35270#22270
      TabOrder = 0
      OnClick = tbGetTablesClick
    end
    object edMetaObj: TEdit
      Left = 88
      Top = 6
      Width = 183
      Height = 23
      TabOrder = 1
    end
    object tbGetTableFields: TButton
      Left = 388
      Top = 6
      Width = 84
      Height = 25
      Caption = #33719#21462#34920#23383#27573
      TabOrder = 2
      OnClick = tbGetTableFieldsClick
    end
  end
  object DBGrid1: TDBGrid
    Left = 0
    Top = 121
    Width = 867
    Height = 320
    Align = alClient
    DataSource = dsMeta
    TabOrder = 2
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
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
    Left = 368
    Top = 200
  end
  object qryMeta: TOneDataSet
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
    Left = 232
    Top = 216
  end
  object dsMeta: TDataSource
    DataSet = qryMeta
    Left = 232
    Top = 272
  end
end

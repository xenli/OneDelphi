object Form3: TForm3
  Left = 0
  Top = 0
  Caption = #23458#25143#31471#20107#21153#25511#21046'Demo'
  ClientHeight = 339
  ClientWidth = 923
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
    Width = 923
    Height = 80
    Align = alTop
    TabOrder = 0
    ExplicitWidth = 919
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
  object GroupBox1: TGroupBox
    Left = 8
    Top = 96
    Width = 433
    Height = 185
    Caption = #31532#19968#20010'DML'#35821#21477
    TabOrder = 1
    object edSQLA: TMemo
      Left = 2
      Top = 17
      Width = 429
      Height = 166
      Align = alClient
      Lines.Strings = (
        'update dev_product'
        'set FProductRemark='#39'123'#39
        'where FProductID='#39'20fddb3ed8f14605ae8201fb03cd216a'#39)
      ScrollBars = ssBoth
      TabOrder = 0
    end
  end
  object GroupBox2: TGroupBox
    Left = 447
    Top = 96
    Width = 449
    Height = 185
    Caption = #31532#20108#20010'DML'#35821#21477
    TabOrder = 2
    object edSQLB: TMemo
      Left = 2
      Top = 17
      Width = 445
      Height = 166
      Align = alClient
      Lines.Strings = (
        'update dev_product'
        'set FProductRemark='#39'123'#39
        'where FProductID='#39'20fddb3ed8f14605ae8201fb03cd216a'#39)
      ScrollBars = ssBoth
      TabOrder = 0
    end
  end
  object tbDML: TButton
    Left = 730
    Top = 296
    Width = 166
    Height = 25
    Caption = #25191#34892'DML'#35821#21477
    TabOrder = 3
    OnClick = tbDMLClick
  end
  object OneConnection: TOneConnection
    Connected = False
    IsHttps = False
    HTTPPort = 0
    ConnectionTimeout = 0
    ResponseTimeout = 0
    Left = 392
    Top = 48
  end
  object qryDataA: TOneDataSet
    CachedUpdates = True
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvUpdateMode, uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    DataInfo.Connection = OneConnection
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
    Left = 408
    Top = 271
  end
end

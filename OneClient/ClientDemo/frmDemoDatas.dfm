object Form2: TForm2
  Left = 0
  Top = 0
  Caption = #25171#24320#20445#23384#22810#20010#25968#25454#38598'Demo->'#31616#21333#27979#35797'->'#21333#20010#25968#25454#38598#25152#26377#21151#33021#22810#25903#25345
  ClientHeight = 430
  ClientWidth = 904
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
    Width = 904
    Height = 80
    Align = alTop
    TabOrder = 0
    ExplicitWidth = 900
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
    Height = 289
    Caption = #31532#19968#20010#25968#25454#38598
    TabOrder = 1
    object Label4: TLabel
      Left = 9
      Top = 19
      Width = 47
      Height = 15
      Caption = 'SQL'#35821#21477
    end
    object Label5: TLabel
      Left = 4
      Top = 110
      Width = 52
      Height = 15
      Caption = #20445#23384#34920#21517
    end
    object Label14: TLabel
      Left = 222
      Top = 110
      Width = 65
      Height = 15
      Caption = #20445#23384#34920#20027#38190
    end
    object edSQLA: TMemo
      Left = 3
      Top = 40
      Width = 427
      Height = 61
      ScrollBars = ssBoth
      TabOrder = 0
    end
    object edTableNameA: TEdit
      Left = 64
      Top = 107
      Width = 115
      Height = 23
      TabOrder = 1
    end
    object edPrimaryKeyA: TEdit
      Left = 293
      Top = 107
      Width = 137
      Height = 23
      TabOrder = 2
    end
    object dbGridA: TDBGrid
      Left = 3
      Top = 144
      Width = 427
      Height = 144
      DataSource = dsDataA
      TabOrder = 3
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -12
      TitleFont.Name = 'Segoe UI'
      TitleFont.Style = []
      Columns = <
        item
          Expanded = False
          Title.Caption = '111'
          Visible = True
        end>
    end
  end
  object GroupBox2: TGroupBox
    Left = 447
    Top = 96
    Width = 449
    Height = 289
    Caption = #31532#20108#20010#25968#25454#38598
    TabOrder = 2
    object Label6: TLabel
      Left = 17
      Top = 19
      Width = 47
      Height = 15
      Caption = 'SQL'#35821#21477
    end
    object Label7: TLabel
      Left = 12
      Top = 110
      Width = 52
      Height = 15
      Caption = #20445#23384#34920#21517
    end
    object Label8: TLabel
      Left = 230
      Top = 110
      Width = 65
      Height = 15
      Caption = #20445#23384#34920#20027#38190
    end
    object edSQLB: TMemo
      Left = 3
      Top = 40
      Width = 427
      Height = 61
      ScrollBars = ssBoth
      TabOrder = 0
    end
    object edTableNameB: TEdit
      Left = 72
      Top = 107
      Width = 115
      Height = 23
      TabOrder = 1
    end
    object edPrimaryKeyB: TEdit
      Left = 301
      Top = 107
      Width = 137
      Height = 23
      TabOrder = 2
    end
    object dbGridB: TDBGrid
      Left = 11
      Top = 144
      Width = 427
      Height = 144
      DataSource = dsDataB
      TabOrder = 3
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -12
      TitleFont.Name = 'Segoe UI'
      TitleFont.Style = []
      Columns = <
        item
          Expanded = False
          Title.Caption = '111'
          Visible = True
        end>
    end
  end
  object tbOpenDatas: TButton
    Left = 598
    Top = 397
    Width = 146
    Height = 25
    Caption = #25171#24320#25968#25454
    TabOrder = 3
    OnClick = tbOpenDatasClick
  end
  object tbSaveDatas: TButton
    Left = 750
    Top = 397
    Width = 146
    Height = 25
    Caption = #20445#23384#25968#25454
    TabOrder = 4
    OnClick = tbSaveDatasClick
  end
  object OneConnection: TOneConnection
    Connected = False
    IsHttps = False
    HTTPPort = 0
    ConnectionTimeout = 0
    ResponseTimeout = 0
    Left = 400
    Top = 40
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
    ActiveDesignOpen = False
    Left = 24
    Top = 368
  end
  object qryDataB: TOneDataSet
    CachedUpdates = True
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvUpdateMode, uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    DataInfo.Connection = OneConnection
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
    ActiveDesignOpen = False
    Left = 504
    Top = 360
  end
  object dsDataA: TDataSource
    DataSet = qryDataA
    Left = 80
    Top = 368
  end
  object dsDataB: TDataSource
    DataSet = qryDataB
    Left = 456
    Top = 360
  end
end

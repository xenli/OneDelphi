object Form5: TForm5
  Left = 0
  Top = 0
  Caption = #24322#27493#25171#24320#25968#25454
  ClientHeight = 535
  ClientWidth = 866
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object Label4: TLabel
    Left = 0
    Top = 129
    Width = 47
    Height = 15
    Caption = 'SQL'#35821#21477
  end
  object Label31: TLabel
    Left = 537
    Top = 129
    Width = 47
    Height = 15
    Caption = 'SQL'#21442#25968
  end
  object Label13: TLabel
    Left = 52
    Top = 255
    Width = 55
    Height = 15
    Caption = ' '#20998#39029#22823#23567
  end
  object edPageNowll: TLabel
    Left = 282
    Top = 255
    Width = 65
    Height = 15
    Caption = #24403#21069#31532#20960#39029
  end
  object Label25: TLabel
    Left = 540
    Top = 255
    Width = 39
    Height = 15
    Caption = #24635#26465#25968
  end
  object Label26: TLabel
    Left = 698
    Top = 254
    Width = 39
    Height = 15
    Caption = #24635#39029#25968
  end
  object Label5: TLabel
    Left = 52
    Top = 91
    Width = 528
    Height = 20
    Caption = #24322#27493#25805#20316',win'#19979#26080#25152#35859','#20294#22312#25163#26426#24179#21488#19981#31649#25171#24320#36824#26159#20445#23384#35831#20840#29992#24322#27493#20889#27861','#21407#21017
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -15
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
  end
  object Label6: TLabel
    Left = 55
    Top = 283
    Width = 52
    Height = 15
    Caption = #20445#23384#34920#21517
  end
  object Label14: TLabel
    Left = 282
    Top = 283
    Width = 65
    Height = 15
    Caption = #20445#23384#34920#20027#38190
  end
  object plSet: TPanel
    Left = 0
    Top = 0
    Width = 866
    Height = 80
    Align = alTop
    TabOrder = 0
    ExplicitWidth = 862
    object Label1: TLabel
      Left = 12
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
    Left = 52
    Top = 126
    Width = 476
    Height = 113
    ScrollBars = ssBoth
    TabOrder = 1
  end
  object edSQLParams: TMemo
    Left = 589
    Top = 126
    Width = 252
    Height = 113
    ScrollBars = ssBoth
    TabOrder = 2
  end
  object edPageSize: TEdit
    Left = 113
    Top = 251
    Width = 147
    Height = 23
    NumbersOnly = True
    TabOrder = 3
  end
  object edPageNow: TEdit
    Left = 353
    Top = 251
    Width = 175
    Height = 23
    NumbersOnly = True
    TabOrder = 4
  end
  object edPageCount: TEdit
    Left = 589
    Top = 251
    Width = 84
    Height = 23
    NumbersOnly = True
    TabOrder = 5
  end
  object edPageTotal: TEdit
    Left = 764
    Top = 251
    Width = 77
    Height = 23
    NumbersOnly = True
    TabOrder = 6
  end
  object tbOpenData: TButton
    Left = 52
    Top = 321
    Width = 125
    Height = 25
    Caption = #33258#20195#24322#27493#25171#24320#25968#25454
    TabOrder = 7
    OnClick = tbOpenDataClick
  end
  object DBGrid1: TDBGrid
    Left = 52
    Top = 352
    Width = 789
    Height = 172
    DataSource = dsOpenData
    TabOrder = 8
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
  object tbOpenAsyncCust: TButton
    Left = 183
    Top = 321
    Width = 125
    Height = 25
    Caption = #25163#21160#24322#27493#25171#24320
    TabOrder = 9
    OnClick = tbOpenAsyncCustClick
  end
  object tbOpenDataAsync2: TButton
    Left = 327
    Top = 321
    Width = 125
    Height = 25
    Caption = #25163#21160#24322#27493#25171#24320'2'
    TabOrder = 10
    OnClick = tbOpenDataAsync2Click
  end
  object edTableName: TEdit
    Left = 113
    Top = 280
    Width = 147
    Height = 23
    TabOrder = 11
  end
  object edPrimaryKey: TEdit
    Left = 353
    Top = 280
    Width = 175
    Height = 23
    TabOrder = 12
  end
  object tbSaveData: TButton
    Left = 473
    Top = 321
    Width = 144
    Height = 25
    Caption = #20445#23384#25968#25454
    TabOrder = 13
    OnClick = tbSaveDataClick
  end
  object qryOpenData: TOneDataSet
    CachedUpdates = True
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvUpdateMode, uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    DataInfo.OpenMode = openData
    DataInfo.SaveMode = saveData
    DataInfo.DataReturnMode = dataStream
    DataInfo.PageSize = -1
    DataInfo.PageIndex = -1
    DataInfo.PageCount = 0
    DataInfo.PageTotal = 0
    DataInfo.AffectedMaxCount = -1
    DataInfo.AffectedMustCount = -1
    DataInfo.RowsAffected = 0
    DataInfo.AsynMode = False
    DataInfo.IsReturnData = False
    DataInfo.TranSpanSec = 0
    Params = <>
    MultiIndex = 0
    ActiveDesign = False
    Left = 168
    Top = 344
  end
  object dsOpenData: TDataSource
    DataSet = qryOpenData
    Left = 172
    Top = 402
  end
  object OneConnection: TOneConnection
    Connected = False
    IsHttps = False
    HTTPPort = 0
    ConnectionTimeout = 0
    ResponseTimeout = 0
    Left = 408
    Top = 80
  end
end

object Form1: TForm1
  Left = 0
  Top = 0
  Caption = #25968#25454#38598#21333#26465#25968#25454#21047#26032
  ClientHeight = 525
  ClientWidth = 866
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object Label4: TLabel
    Left = 8
    Top = 91
    Width = 99
    Height = 15
    Caption = #25171#24320#25968#25454'SQL'#35821#21477
  end
  object Label5: TLabel
    Left = 8
    Top = 219
    Width = 234
    Height = 15
    Caption = #21047#26032#21333#26465#25968#25454'SQL'#35821#21477'-'#36820#22238#30340#25968#25454#26159#19968#26465
  end
  object Label6: TLabel
    Left = 391
    Top = 219
    Width = 91
    Height = 15
    Caption = #21442#25968#20540#19968#34892#19968#20010
  end
  object plSet: TPanel
    Left = 0
    Top = 0
    Width = 866
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
    Top = 112
    Width = 489
    Height = 89
    Lines.Strings = (
      'select'
      '*'
      'from onefast_admin')
    TabOrder = 1
  end
  object edRefreshSQL: TMemo
    Left = 8
    Top = 240
    Width = 377
    Height = 89
    Lines.Strings = (
      'select'
      '*'
      'from onefast_admin'
      'where FAdminID=:FAdminID')
    TabOrder = 2
  end
  object tbOpenData: TButton
    Left = 520
    Top = 112
    Width = 129
    Height = 25
    Caption = #25171#24320#25968#25454
    TabOrder = 3
    OnClick = tbOpenDataClick
  end
  object tbRefreshSingle: TButton
    Left = 616
    Top = 239
    Width = 129
    Height = 25
    Caption = #21047#26032#24403#21069#21333#26465#25968#25454
    TabOrder = 4
    OnClick = tbRefreshSingleClick
  end
  object DBGrid1: TDBGrid
    Left = 8
    Top = 335
    Width = 841
    Height = 172
    DataSource = dsOpenData
    TabOrder = 5
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
  object edValues: TMemo
    Left = 391
    Top = 240
    Width = 210
    Height = 89
    TabOrder = 6
  end
  object OneConnection: TOneConnection
    Connected = False
    IsHttps = False
    HTTPHost = '127.0.0.1'
    HTTPPort = 9090
    ConnectionTimeout = 0
    ResponseTimeout = 0
    Left = 400
    Top = 40
  end
  object qryOpenData: TOneDataSet
    FieldDefs = <>
    CachedUpdates = True
    IndexDefs = <>
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    FormatOptions.AssignedValues = [fvMaxBcdPrecision, fvMaxBcdScale]
    FormatOptions.MaxBcdPrecision = 2147483647
    FormatOptions.MaxBcdScale = 1073741823
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvUpdateChngFields, uvUpdateMode, uvLockMode, uvLockPoint, uvLockWait, uvRefreshMode, uvFetchGeneratorsPoint, uvCheckRequired, uvCheckReadOnly, uvCheckUpdatable, uvAutoCommitUpdates]
    UpdateOptions.LockWait = True
    UpdateOptions.FetchGeneratorsPoint = gpNone
    UpdateOptions.CheckRequired = False
    StoreDefs = True
    DataInfo.Connection = OneConnection
    DataInfo.MetaInfoKind = mkNone
    DataInfo.OpenMode = openData
    DataInfo.SaveMode = saveData
    DataInfo.DataReturnMode = dataStream
    DataInfo.PageSize = -1
    DataInfo.PageIndex = -1
    DataInfo.PageCount = 0
    DataInfo.PageTotal = 0
    DataInfo.AffectedMaxCount = -1
    DataInfo.AffectedMustCount = -1
    DataInfo.RowsAffected = 4
    DataInfo.AsynMode = False
    DataInfo.IsReturnData = False
    DataInfo.TranSpanSec = 0
    Params = <>
    MultiIndex = 0
    ActiveDesign = False
    ActiveDesignOpen = False
    Left = 688
    Top = 224
  end
  object dsOpenData: TDataSource
    DataSet = qryOpenData
    Left = 756
    Top = 226
  end
end

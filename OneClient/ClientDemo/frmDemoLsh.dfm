object frDemoLsh: TfrDemoLsh
  Left = 0
  Top = 0
  Caption = #27969#27700#21495#21151#33021
  ClientHeight = 548
  ClientWidth = 1048
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
    Width = 414
    Height = 20
    Caption = #38656#35201#30340#34920#32467#26500','#20197#19979#26159'MSSQL,'#22914#26524#26159#20854#23427#25968#25454#24211#33258#34892#36716#21270
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -15
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object plSet: TPanel
    Left = 0
    Top = 0
    Width = 1048
    Height = 80
    Align = alTop
    TabOrder = 0
    ExplicitWidth = 1044
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
    Width = 414
    Height = 429
    Lines.Strings = (
      '-------'#37197#32622#34920'----------------------'
      'CREATE TABLE onefast_lsh_set ('
      #9'FLshID nvarchar(32) primary key,'
      #9'FLshCode nvarchar(30) NULL,'
      #9'FLshCaption nvarchar(50) NULL,'
      #9'FLshHead nvarchar(10) NULL,'
      #9'FLshDateFormat nvarchar(20) NULL,'
      #9'FLshNoLength int NULL,'
      #9'FIsEnabled bit NULL)'
      ''
      ''
      '------'#32531#23384#34920'-----------'
      'CREATE TABLE dbo.onefast_lsh_his('
      #9'FHisID nvarchar(32) primary key,'
      #9'FLshCode nvarchar(30) NULL,'
      #9'FLshYear int NULL,'
      #9'FLshMonth int NULL,'
      #9'FLshDay int NULL,'
      #9'FLshMax int NULL,'
      #9'FUpdateTime datetime NULL)'
      '')
    ScrollBars = ssBoth
    TabOrder = 1
  end
  object DBGrid1: TDBGrid
    Left = 428
    Top = 144
    Width = 616
    Height = 172
    DataSource = dsSet
    TabOrder = 2
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
  object tbOpenData: TButton
    Left = 428
    Top = 113
    Width = 106
    Height = 25
    Caption = #25171#24320#37197#32622
    TabOrder = 3
    OnClick = tbOpenDataClick
  end
  object tbAppend: TButton
    Left = 540
    Top = 113
    Width = 113
    Height = 25
    Caption = #22686#21152#37197#32622
    TabOrder = 4
    OnClick = tbAppendClick
  end
  object tbSaveData: TButton
    Left = 659
    Top = 113
    Width = 94
    Height = 25
    Caption = #20445#23384#37197#32622
    TabOrder = 5
    OnClick = tbSaveDataClick
  end
  object tbRefreshLshSet: TButton
    Left = 428
    Top = 342
    Width = 141
    Height = 25
    Caption = #21047#26032#26381#21153#31471#27969#27700#21495#37197#32622
    TabOrder = 6
    OnClick = tbRefreshLshSetClick
  end
  object tbGetLsh: TButton
    Left = 575
    Top = 342
    Width = 94
    Height = 25
    Caption = #33719#21462#27969#27700#21495
    TabOrder = 7
    OnClick = tbGetLshClick
  end
  object tbLshList: TButton
    Left = 675
    Top = 342
    Width = 126
    Height = 25
    Caption = #33719#21462#27969#27700#21495'10'#20010
    TabOrder = 8
    OnClick = tbLshListClick
  end
  object edLsh: TMemo
    Left = 428
    Top = 376
    Width = 616
    Height = 165
    ScrollBars = ssVertical
    TabOrder = 9
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
    Left = 480
    Top = 32
  end
  object OneFastLsh: TOneFastLsh
    Connection = OneConnection
    Left = 568
    Top = 32
  end
  object qrySet: TOneDataSet
    CachedUpdates = True
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvUpdateMode, uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    SQL.Strings = (
      'select '
      '*'
      ' from onefast_lsh_set')
    DataInfo.MetaInfoKind = mkNone
    DataInfo.TableName = 'onefast_lsh_set'
    DataInfo.PrimaryKey = 'FLshID'
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
    Left = 632
    Top = 40
  end
  object dsSet: TDataSource
    DataSet = qrySet
    Left = 688
    Top = 40
  end
end

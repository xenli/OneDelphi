object Form11: TForm11
  Left = 0
  Top = 0
  Caption = #35746#21333#38145#21333#65292#38450#27490#22810#20154#32534#36753
  ClientHeight = 483
  ClientWidth = 871
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object Label4: TLabel
    Left = 15
    Top = 89
    Width = 47
    Height = 15
    Caption = 'SQL'#35821#21477
  end
  object Label5: TLabel
    Left = 123
    Top = 226
    Width = 52
    Height = 15
    Caption = #20445#23384#34920#21517
  end
  object Label14: TLabel
    Left = 370
    Top = 226
    Width = 65
    Height = 15
    Caption = #20445#23384#34920#20027#38190
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
    Left = 68
    Top = 86
    Width = 549
    Height = 131
    Lines.Strings = (
      'select  '
      'FBillID,FRemark'
      'from jxc_bill'
      'where FBillID='#39'049702b3cf9f40fa8e525f93ec481587'#39)
    ScrollBars = ssBoth
    TabOrder = 1
  end
  object edTableName: TEdit
    Left = 181
    Top = 223
    Width = 147
    Height = 23
    TabOrder = 2
    Text = 'jxc_bill'
  end
  object edPrimaryKey: TEdit
    Left = 441
    Top = 223
    Width = 175
    Height = 23
    TabOrder = 3
    Text = 'FBillID'
  end
  object tbOpenData: TButton
    Left = 67
    Top = 260
    Width = 106
    Height = 25
    Caption = #25171#24320#25968#25454
    TabOrder = 4
    OnClick = tbOpenDataClick
  end
  object tbSaveData: TButton
    Left = 200
    Top = 260
    Width = 144
    Height = 25
    Caption = #20445#23384#25968#25454
    TabOrder = 5
    OnClick = tbSaveDataClick
  end
  object DBGrid1: TDBGrid
    Left = 67
    Top = 291
    Width = 549
    Height = 172
    DataSource = dsMain
    TabOrder = 6
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
  object tbBillUnLockForce: TButton
    Left = 387
    Top = 260
    Width = 106
    Height = 25
    Caption = #24378#21046#35299#38145#25968#25454
    TabOrder = 7
    OnClick = tbBillUnLockForceClick
  end
  object OneConnection: TOneConnection
    Connected = False
    IsHttps = False
    HTTPHost = '127.0.0.1'
    HTTPPort = 9090
    ConnectSecretkey = '354575E87B2642C68F798694B81AF6EF'
    TokenID = '5B035489C3B14D6BA666F25EE3C644E0'
    PrivateKey = 'E31D5281359845CCA5785A362E8F1CC7'
    ConnectionTimeout = 0
    ResponseTimeout = 0
    ErrMsg = #35831#27714#21457#29983#24322#24120':Error sending data: (12029) '#26080#27861#19982#26381#21153#22120#24314#31435#36830#25509
    Left = 400
    Top = 40
  end
  object dsMain: TDataSource
    DataSet = qryMain
    Left = 412
    Top = 106
  end
  object qryMain: TOneDataSet
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
    SQL.Strings = (
      'select'
      '*'
      'from onefast_admin')
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
    Left = 352
    Top = 112
  end
  object OneBillLock: TOneBillLock
    Connection = OneConnection
    Left = 496
    Top = 120
  end
end

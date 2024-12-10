object Form9: TForm9
  Left = 0
  Top = 0
  Caption = #23458#25143#31471#20107#21153#25511#21046'-'#25171#24320#25968#25454#20445#23384#21518','#21028#26029#26159#21542#37325#22797
  ClientHeight = 541
  ClientWidth = 868
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
    Width = 868
    Height = 80
    Align = alTop
    TabOrder = 0
    ExplicitWidth = 864
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
    Left = -3
    Top = 104
    Width = 852
    Height = 393
    Caption = #25968#25454#38598
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
      Top = 190
      Width = 52
      Height = 15
      Caption = #20445#23384#34920#21517
    end
    object Label14: TLabel
      Left = 222
      Top = 190
      Width = 65
      Height = 15
      Caption = #20445#23384#34920#20027#38190
    end
    object Label6: TLabel
      Left = 441
      Top = 19
      Width = 99
      Height = 15
      Caption = #26657#39564#37325#22797'SQL'#35821#21477
    end
    object edSQLA: TMemo
      Left = 3
      Top = 40
      Width = 427
      Height = 141
      Lines.Strings = (
        'select '
        '*'
        'from jxc_bill'
        'where FBillID='#39'049702b3cf9f40fa8e525f93ec481587'#39)
      ScrollBars = ssBoth
      TabOrder = 0
    end
    object edTableNameA: TEdit
      Left = 64
      Top = 187
      Width = 115
      Height = 23
      TabOrder = 1
      Text = 'jxc_bill'
    end
    object edPrimaryKeyA: TEdit
      Left = 293
      Top = 187
      Width = 137
      Height = 23
      TabOrder = 2
      Text = 'FBillID'
    end
    object dbGridA: TDBGrid
      Left = 11
      Top = 218
      Width = 838
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
    object edCheckSQL: TMemo
      Left = 435
      Top = 40
      Width = 406
      Height = 141
      Lines.Strings = (
        'select '
        'count(1) as iCount from jxc_bill '
        'where FBillNo='#39'1BILL202401150005'#39)
      ScrollBars = ssBoth
      TabOrder = 4
    end
  end
  object tbOpenDatas: TButton
    Left = 42
    Top = 503
    Width = 104
    Height = 30
    Caption = #25171#24320#25968#25454
    TabOrder = 2
    OnClick = tbOpenDatasClick
  end
  object tbSaveDatas: TButton
    Left = 160
    Top = 503
    Width = 225
    Height = 30
    Caption = #20445#23384#25968#25454'-Grid'#25511#20214#26356#25913#25968#25454#20445#23384#25552#20132
    TabOrder = 3
    OnClick = tbSaveDatasClick
  end
  object tbSaveB: TButton
    Left = 405
    Top = 503
    Width = 444
    Height = 30
    Caption = #20445#23384#25968#25454'-'#20195#30721#26356#25913#25968#25454','#20445#23384#25552#20132'('#27880#24847#25913#25104#20320#33258#24050#19994#21153#34920#20195#30721')'
    TabOrder = 4
    OnClick = tbSaveBClick
  end
  object OneConnection: TOneConnection
    Connected = False
    IsHttps = False
    HTTPPort = 0
    ConnectionTimeout = 0
    ResponseTimeout = 0
    Left = 240
    Top = 400
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
    Left = 296
    Top = 391
  end
  object qryCheck: TOneDataSet
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
    Left = 488
    Top = 391
  end
  object dsDataA: TDataSource
    DataSet = qryDataA
    Left = 352
    Top = 392
  end
end

object Form8: TForm8
  Left = 0
  Top = 0
  Caption = #23458#25143#31471#20107#21153#25511#21046'-'#25191#34892'SQL'#26356#26032#21028#26029#26159#21542#37325#22797
  ClientHeight = 396
  ClientWidth = 869
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
    Width = 869
    Height = 80
    Align = alTop
    TabOrder = 0
    ExplicitWidth = 865
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
    Top = 102
    Width = 853
    Height = 275
    Caption = #25968#25454#38598
    TabOrder = 1
    object Label4: TLabel
      Left = 9
      Top = 19
      Width = 109
      Height = 15
      Caption = #25191#34892'Upate-SQL'#35821#21477
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
      Width = 406
      Height = 169
      Lines.Strings = (
        'update jxc_bill'
        'set FBillNo='#39'1BILL202401150005'#39
        'where FBillID='#39'049702b3cf9f40fa8e525f93ec481587'#39)
      ScrollBars = ssBoth
      TabOrder = 0
    end
    object edCheckSQL: TMemo
      Left = 435
      Top = 40
      Width = 406
      Height = 169
      Lines.Strings = (
        'select '
        'count(1) as iCount from jxc_bill '
        'where FBillNo='#39'1BILL202401150005'#39)
      ScrollBars = ssBoth
      TabOrder = 1
    end
    object tbSaveDatas: TButton
      Left = 687
      Top = 234
      Width = 146
      Height = 25
      Caption = #25191#34892'UpateSQL'
      TabOrder = 2
      OnClick = tbSaveDatasClick
    end
  end
  object OneConnection: TOneConnection
    Connected = False
    IsHttps = False
    HTTPPort = 0
    ConnectionTimeout = 0
    ResponseTimeout = 0
    Left = 280
    Top = 272
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
    Left = 360
    Top = 271
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
    Left = 568
    Top = 255
  end
end

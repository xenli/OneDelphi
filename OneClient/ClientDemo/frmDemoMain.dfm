object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 559
  ClientWidth = 899
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
    Width = 899
    Height = 80
    Align = alTop
    TabOrder = 0
    ExplicitWidth = 895
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
  object LabeledEdit1: TLabeledEdit
    Left = 520
    Top = 312
    Width = 121
    Height = 23
    EditLabel.Width = 67
    EditLabel.Height = 15
    EditLabel.Caption = 'LabeledEdit1'
    TabOrder = 1
    Text = ''
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 80
    Width = 899
    Height = 479
    ActivePage = tabDML
    Align = alClient
    TabOrder = 2
    ExplicitWidth = 895
    ExplicitHeight = 478
    object tabDataSet: TTabSheet
      Caption = #25968#25454#38598#22522#26412#25171#24320#20445#23384
      object Label4: TLabel
        Left = 8
        Top = 14
        Width = 47
        Height = 15
        Caption = 'SQL'#35821#21477
      end
      object Label31: TLabel
        Left = 545
        Top = 14
        Width = 47
        Height = 15
        Caption = 'SQL'#21442#25968
      end
      object Label13: TLabel
        Left = 60
        Top = 140
        Width = 55
        Height = 15
        Caption = ' '#20998#39029#22823#23567
      end
      object edPageNowll: TLabel
        Left = 290
        Top = 140
        Width = 65
        Height = 15
        Caption = #24403#21069#31532#20960#39029
      end
      object Label25: TLabel
        Left = 597
        Top = 139
        Width = 39
        Height = 15
        Caption = #24635#26465#25968
      end
      object Label26: TLabel
        Left = 597
        Top = 175
        Width = 39
        Height = 15
        Caption = #24635#39029#25968
      end
      object Label5: TLabel
        Left = 61
        Top = 175
        Width = 52
        Height = 15
        Caption = #20445#23384#34920#21517
      end
      object Label14: TLabel
        Left = 290
        Top = 175
        Width = 65
        Height = 15
        Caption = #20445#23384#34920#20027#38190
      end
      object edSQL: TMemo
        Left = 60
        Top = 11
        Width = 476
        Height = 113
        ScrollBars = ssBoth
        TabOrder = 0
      end
      object edSQLParams: TMemo
        Left = 597
        Top = 11
        Width = 252
        Height = 113
        ScrollBars = ssBoth
        TabOrder = 1
      end
      object edPageSize: TEdit
        Left = 121
        Top = 136
        Width = 147
        Height = 23
        NumbersOnly = True
        TabOrder = 2
      end
      object edPageNow: TEdit
        Left = 356
        Top = 136
        Width = 175
        Height = 23
        NumbersOnly = True
        TabOrder = 3
      end
      object edPageCount: TEdit
        Left = 653
        Top = 136
        Width = 192
        Height = 23
        NumbersOnly = True
        TabOrder = 4
      end
      object edPageTotal: TEdit
        Left = 653
        Top = 172
        Width = 192
        Height = 23
        NumbersOnly = True
        TabOrder = 5
      end
      object tbOpenData: TButton
        Left = 60
        Top = 206
        Width = 106
        Height = 25
        Caption = #25171#24320#25968#25454
        TabOrder = 6
        OnClick = tbOpenDataClick
      end
      object edTableName: TEdit
        Left = 121
        Top = 172
        Width = 147
        Height = 23
        TabOrder = 7
      end
      object edPrimaryKey: TEdit
        Left = 356
        Top = 172
        Width = 175
        Height = 23
        TabOrder = 8
      end
      object tbAppend: TButton
        Left = 172
        Top = 206
        Width = 113
        Height = 25
        Caption = #22686#21152#19968#26465#25968#25454
        TabOrder = 9
        OnClick = tbAppendClick
      end
      object tbDel: TButton
        Left = 307
        Top = 206
        Width = 144
        Height = 25
        Caption = #21024#38500#19968#26465#25968#25454
        TabOrder = 10
        OnClick = tbDelClick
      end
      object DBGrid1: TDBGrid
        Left = 60
        Top = 237
        Width = 789
        Height = 172
        DataSource = dsOpenData
        TabOrder = 11
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
      object tbSaveData: TButton
        Left = 465
        Top = 206
        Width = 144
        Height = 25
        Caption = #20445#23384#25968#25454
        TabOrder = 12
        OnClick = tbSaveDataClick
      end
    end
    object tabDML: TTabSheet
      Caption = #25191#34892'DML'#35821#21477
      ImageIndex = 1
      object Label6: TLabel
        Left = 20
        Top = 367
        Width = 78
        Height = 15
        Caption = #26368#22823#24433#21709#34892#25968
      end
      object Label7: TLabel
        Left = 276
        Top = 366
        Width = 117
        Height = 15
        Caption = #24517#38656#26377#19988#20960#34892#21463#24433#21709
      end
      object Label8: TLabel
        Left = 580
        Top = 131
        Width = 200
        Height = 15
        Caption = #21442#25968':'#19968#34892#19968#20010','#24403'SQL'#26377#21442#25968#26102' :xxxx'
      end
      object edDMLSQL: TMemo
        Left = 19
        Top = 152
        Width = 555
        Height = 205
        Lines.Strings = (
          #35831#36755#20837'DML'#35821#21477)
        TabOrder = 0
      end
      object edDMLMaxRow: TEdit
        Left = 104
        Top = 363
        Width = 147
        Height = 23
        NumbersOnly = True
        TabOrder = 1
      end
      object edDMLMustRow: TEdit
        Left = 399
        Top = 363
        Width = 175
        Height = 23
        NumbersOnly = True
        TabOrder = 2
      end
      object tbDML: TButton
        Left = 608
        Top = 363
        Width = 161
        Height = 25
        Caption = #25191#34892'DML'
        TabOrder = 3
        OnClick = tbDMLClick
      end
      object Memo1: TMemo
        Left = 20
        Top = 14
        Width = 825
        Height = 111
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Segoe UI'
        Font.Style = []
        Lines.Strings = (
          'DML:'#25351#30340#26159'insert,update,delete'#35821#21477
          '        '#26368#22823#24433#21709#25968#34892#26368#22810#26377#20960#26465#21463#24433#21709','#36229#36807#22238#28378';'
          '        '#24517#38656#26377#19988#20960#34892#21463#24433#21709':'#30830#23450#24433#21709#34892#25968#65292#22914#26524#19981#19968#33267#22238#28378';'
          ' '#30456#21516#21442#25968#21517#24773#20917#19979#31639#21516#20010#21442#25968
          '    ')
        ParentFont = False
        TabOrder = 4
      end
      object edDMLParam: TMemo
        Left = 580
        Top = 152
        Width = 265
        Height = 205
        TabOrder = 5
      end
    end
    object tabStroe: TTabSheet
      Caption = #25191#34892#23384#20648#36807#31243
      ImageIndex = 2
      object Label9: TLabel
        Left = 352
        Top = 23
        Width = 78
        Height = 15
        Caption = #23384#20648#36807#31243#21517#31216
      end
      object Label10: TLabel
        Left = 8
        Top = 23
        Width = 78
        Height = 15
        Caption = #23384#20648#36807#31243#21253#21517
      end
      object Label11: TLabel
        Left = 8
        Top = 86
        Width = 470
        Height = 20
        Caption = #36755#20837'SQL,'#33021#24555#36895#20026'DataSet'#20135#29983'params'#21442#25968','#21542#35201#35201#19968#20010#19968#20010#35774#35745#28155#21152
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
      end
      object Label12: TLabel
        Left = 8
        Top = 112
        Width = 363
        Height = 17
        Caption = #20363'  exec sp_test :p1,:p2   OneDataSet'#20250#20135#29983#20004#20010#21442#25968'p1,p2'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
      end
      object Label15: TLabel
        Left = 416
        Top = 112
        Width = 160
        Height = 20
        Caption = #23384#20648#36807#31243#21442#25968#19968#34892#19968#20010
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
      end
      object Label16: TLabel
        Left = 651
        Top = 110
        Width = 80
        Height = 20
        Caption = #32467#26524#21442#25968#20540
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
      end
      object edSPName: TEdit
        Left = 443
        Top = 20
        Width = 206
        Height = 23
        TabOrder = 0
      end
      object edSPPackage: TEdit
        Left = 107
        Top = 20
        Width = 206
        Height = 23
        TabOrder = 1
      end
      object edSPSQL: TMemo
        Left = 3
        Top = 136
        Width = 394
        Height = 121
        TabOrder = 2
      end
      object edSPParams: TMemo
        Left = 416
        Top = 136
        Width = 222
        Height = 121
        TabOrder = 3
      end
      object gridSP: TDBGrid
        Left = 3
        Top = 273
        Width = 857
        Height = 160
        DataSource = dsSPData
        TabOrder = 4
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -12
        TitleFont.Name = 'Segoe UI'
        TitleFont.Style = []
      end
      object edSPOutData: TCheckBox
        Left = 8
        Top = 49
        Width = 97
        Height = 17
        Caption = #36820#22238#25968#25454#38598
        TabOrder = 5
      end
      object tbSP: TButton
        Left = 672
        Top = 19
        Width = 188
        Height = 25
        Caption = #25191#34892#23384#20648#36807#31243
        TabOrder = 6
        OnClick = tbSPClick
      end
      object edSPReturnParams: TMemo
        Left = 651
        Top = 136
        Width = 209
        Height = 121
        Enabled = False
        TabOrder = 7
      end
    end
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
  object qryOpenData: TOneDataSet
    CachedUpdates = True
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvUpdateMode, uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    DataInfo.IsDesignGetFields = False
    DataInfo.OpenMode = openData
    DataInfo.IsPost = False
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
    Left = 24
    Top = 344
  end
  object dsOpenData: TDataSource
    DataSet = qryOpenData
    Left = 20
    Top = 402
  end
  object qryDMLData: TOneDataSet
    CachedUpdates = True
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvUpdateMode, uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    DataInfo.IsDesignGetFields = False
    DataInfo.Connection = OneConnection
    DataInfo.OpenMode = openData
    DataInfo.IsPost = False
    DataInfo.SaveMode = saveData
    DataInfo.DataReturnMode = dataStream
    DataInfo.PageSize = -1
    DataInfo.PageIndex = 0
    DataInfo.PageCount = 0
    DataInfo.PageTotal = 0
    DataInfo.AffectedMaxCount = 0
    DataInfo.AffectedMustCount = 0
    DataInfo.RowsAffected = 0
    DataInfo.AsynMode = False
    DataInfo.IsReturnData = False
    DataInfo.TranSpanSec = 0
    Params = <>
    MultiIndex = 0
    Left = 132
    Top = 346
  end
  object qrySPData: TOneDataSet
    CachedUpdates = True
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvUpdateMode, uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    DataInfo.IsDesignGetFields = False
    DataInfo.OpenMode = openData
    DataInfo.IsPost = False
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
    Left = 244
    Top = 346
  end
  object dsSPData: TDataSource
    DataSet = qrySPData
    Left = 244
    Top = 410
  end
end

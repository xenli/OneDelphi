object frDemoFastApi: TfrDemoFastApi
  Left = 0
  Top = 0
  Caption = 'FastApi'#31649#29702#30028#38754
  ClientHeight = 754
  ClientWidth = 1560
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  WindowState = wsMaximized
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  TextHeight = 15
  object plSet: TPanel
    Left = 0
    Top = 0
    Width = 1560
    Height = 80
    Align = alTop
    TabOrder = 0
    ExplicitWidth = 1556
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
    object tbClientDisConnect: TButton
      Left = 735
      Top = 44
      Width = 114
      Height = 25
      Caption = #26029#24320#36830#25509
      TabOrder = 4
      OnClick = tbClientDisConnectClick
    end
    object edZTCode: TEdit
      Left = 72
      Top = 52
      Width = 121
      Height = 23
      TabOrder = 5
    end
  end
  object grdMain: TcxGrid
    Left = 0
    Top = 139
    Width = 330
    Height = 615
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alLeft
    TabOrder = 1
    LookAndFeel.ScrollbarMode = sbmClassic
    ExplicitHeight = 614
    object vwMain: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      ScrollbarAnnotations.CustomAnnotations = <>
      DataController.DataSource = dsFastApi
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      Filtering.ColumnFilteredItemsList = True
      FilterRow.OperatorCustomization = True
      OptionsBehavior.AlwaysShowEditor = True
      OptionsBehavior.GoToNextCellOnEnter = True
      OptionsCustomize.ColumnsQuickCustomization = True
      OptionsCustomize.ColumnsQuickCustomizationSorted = True
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsView.DataRowHeight = 25
      OptionsView.GroupByBox = False
      object vwMainFOrderNumber: TcxGridDBColumn
        DataBinding.FieldName = 'FOrderNumber'
        Options.Filtering = False
        Width = 54
      end
      object vwMainFApiCode: TcxGridDBColumn
        DataBinding.FieldName = 'FApiCode'
        Width = 104
      end
      object vwMainFApiCaption: TcxGridDBColumn
        DataBinding.FieldName = 'FApiCaption'
        Width = 97
      end
      object vwMainFIsEnabled: TcxGridDBColumn
        DataBinding.FieldName = 'FIsEnabled'
        Options.Filtering = False
        Width = 60
      end
      object vwMainFApiAuthor: TcxGridDBColumn
        DataBinding.FieldName = 'FApiAuthor'
        PropertiesClassName = 'TcxComboBoxProperties'
        Properties.Items.Strings = (
          #20844#24320
          'Token'#39564#35777
          'AppID'#39564#35777
          '')
        Width = 135
      end
      object vwMainFApiRole: TcxGridDBColumn
        DataBinding.FieldName = 'FApiRole'
        PropertiesClassName = 'TcxComboBoxProperties'
        Properties.Items.Strings = (
          #36229#32423#31649#29702#21592
          #31649#29702#21592
          #31995#32479#29992#25143)
        Width = 110
      end
    end
    object lvMain: TcxGridLevel
      GridView = vwMain
    end
  end
  object pgDesign: TcxPageControl
    Left = 330
    Top = 139
    Width = 1230
    Height = 615
    Align = alClient
    TabOrder = 6
    Properties.ActivePage = tabSheetData
    Properties.CustomButtons.Buttons = <>
    Properties.Style = 10
    ExplicitWidth = 1226
    ExplicitHeight = 614
    ClientRectBottom = 615
    ClientRectRight = 1230
    ClientRectTop = 21
    object tabSheetData: TcxTabSheet
      Caption = #25968#25454#35774#35745
      ImageIndex = 0
      object pgData: TcxPageControl
        Left = 230
        Top = 0
        Width = 1000
        Height = 594
        Align = alClient
        TabOrder = 0
        Properties.ActivePage = tabSheetParams
        Properties.CustomButtons.Buttons = <>
        Properties.Style = 10
        ClientRectBottom = 594
        ClientRectRight = 1000
        ClientRectTop = 21
        object tabSheetDataInfo: TcxTabSheet
          Caption = #25968#25454#38598#20449#24687
          ImageIndex = 0
          object Panel10: TPanel
            Left = 0
            Top = 0
            Width = 1000
            Height = 137
            Align = alTop
            TabOrder = 0
            object cxLabel5: TcxLabel
              Left = 4
              Top = 6
              Caption = #25968#25454#38598#21517#31216
            end
            object dbFDataName: TcxDBTextEdit
              Left = 88
              Top = 3
              DataBinding.DataField = 'FDataName'
              DataBinding.DataSource = dsData
              TabOrder = 1
              Width = 140
            end
            object cxLabel6: TcxLabel
              Left = 252
              Top = 6
              Caption = #25968#25454#38598#26631#31614
            end
            object dbFDataCaption: TcxDBTextEdit
              Left = 335
              Top = 3
              DataBinding.DataField = 'FDataCaption'
              DataBinding.DataSource = dsData
              TabOrder = 3
              Width = 140
            end
            object cxLabel7: TcxLabel
              Left = 491
              Top = 6
              Caption = 'JSON'#21517#31216
            end
            object dbFDataTag: TcxDBTextEdit
              Left = 575
              Top = 3
              DataBinding.DataField = 'FDataJsonName'
              DataBinding.DataSource = dsData
              TabOrder = 5
              Width = 140
            end
            object cxLabel8: TcxLabel
              Left = 756
              Top = 105
              Caption = #25968#25454#36134#22871
            end
            object cxLabel9: TcxLabel
              Left = 4
              Top = 40
              Caption = #34920#21517
            end
            object dbFDataTable: TcxDBTextEdit
              Left = 88
              Top = 37
              DataBinding.DataField = 'FDataTable'
              DataBinding.DataSource = dsData
              TabOrder = 8
              Width = 140
            end
            object cxLabel10: TcxLabel
              Left = 251
              Top = 40
              Caption = #20027#38190
            end
            object dbFDataPrimaryKey: TcxDBTextEdit
              Left = 335
              Top = 37
              DataBinding.DataField = 'FDataPrimaryKey'
              DataBinding.DataSource = dsData
              TabOrder = 10
              Width = 140
            end
            object cxLabel11: TcxLabel
              Left = 491
              Top = 40
              Caption = #25171#24320#27169#24335
            end
            object cxLabel12: TcxLabel
              Left = 5
              Top = 71
              Caption = #20998#39029#22823#23567
            end
            object dbFDataPageSize: TcxDBTextEdit
              Left = 88
              Top = 68
              DataBinding.DataField = 'FDataPageSize'
              DataBinding.DataSource = dsData
              TabOrder = 13
              Width = 140
            end
            object cxLabel13: TcxLabel
              Left = 4
              Top = 105
              Caption = #26356#26032#27169#24335
            end
            object dbFDataUpdateMode: TcxDBComboBox
              Left = 88
              Top = 102
              DataBinding.DataField = 'FDataUpdateMode'
              DataBinding.DataSource = dsData
              Properties.DropDownListStyle = lsEditFixedList
              Properties.Items.Strings = (
                '--'#21482#36319#25454#20027#38190#21442#19982#25552#20132#21450#23450#20301
                'upWhereKeyOnly'
                '--'#25152#26377#23383#27573#21442#19982#25552#20132#21450#26465#20214#23450#20301
                'upWhereAll'
                '---'#20027#38190'+'#25913#21464#30340#23383#27573' '#21442#19982#25552#20132#21450#26465#20214#23450#20301
                'upWhereChanged')
              TabOrder = 15
              Width = 140
            end
            object dbFDataZTCode: TcxDBComboBox
              Left = 839
              Top = 102
              DataBinding.DataField = 'FDataZTCode'
              DataBinding.DataSource = dsData
              TabOrder = 16
              Width = 140
            end
            object dbFDataOpenMode: TcxDBImageComboBox
              Left = 575
              Top = 37
              DataBinding.DataField = 'FDataOpenMode'
              DataBinding.DataSource = dsData
              Properties.Items = <
                item
                  Description = 'SQL'#25171#24320#25968#25454
                  ImageIndex = 0
                  Value = 'openData'
                end
                item
                  Description = #23384#20648#36807#31243#25171#24320#25968#25454
                  Value = 'openDataStore'
                end
                item
                  Description = #25191#34892#23384#20648#36807#31243
                  Value = 'doStore'
                end
                item
                  Description = #25191#34892#25554#20837#26356#26032#21024#38500#35821#21477'(DML)'
                  Value = 'doDMLSQL'
                end
                item
                  Description = #25209#37327#28155#21152#25968#25454
                  Value = 'appendDatas'
                end>
              TabOrder = 17
              Width = 404
            end
            object cxLabel3: TcxLabel
              Left = 755
              Top = 6
              Caption = #25968#25454#26684#24335
            end
            object dbFDataJsonType: TcxDBImageComboBox
              Left = 839
              Top = 3
              DataBinding.DataField = 'FDataJsonType'
              DataBinding.DataSource = dsData
              Properties.Items = <
                item
                  Description = 'Json'#23545#35937'{}'
                  ImageIndex = 0
                  Value = 'JsonObject'
                end
                item
                  Description = 'Json'#25968#32452'[]'
                  Value = 'JsonArray'
                end>
              TabOrder = 19
              Width = 140
            end
            object cxLabel4: TcxLabel
              Left = 252
              Top = 105
              Caption = #23384#20648#36807#31243
            end
            object dbFDataStoreName: TcxDBTextEdit
              Left = 335
              Top = 102
              DataBinding.DataField = 'FDataStoreName'
              DataBinding.DataSource = dsData
              TabOrder = 21
              Width = 380
            end
            object cxLabel14: TcxLabel
              Left = 252
              Top = 71
              Caption = #25191#34892#25554#20837#26356#26032#21024#38500#35821#21477'(DML)'
            end
            object dbFMinAffected: TcxDBTextEdit
              Left = 575
              Top = 71
              DataBinding.DataField = 'FMinAffected'
              DataBinding.DataSource = dsData
              TabOrder = 23
              Width = 140
            end
            object dbFMaxAffected: TcxDBTextEdit
              Left = 839
              Top = 71
              DataBinding.DataField = 'FMaxAffected'
              DataBinding.DataSource = dsData
              TabOrder = 24
              Width = 140
            end
            object cxLabel15: TcxLabel
              Left = 472
              Top = 72
              Caption = #33267#23569#24433#21709#34892#25968
            end
            object cxLabel16: TcxLabel
              Left = 739
              Top = 71
              Caption = #26368#22823#24433#21709#34892#25968
            end
          end
          object cxGroupBox1: TcxGroupBox
            Left = 0
            Top = 137
            Align = alClient
            Caption = 'SQL'#35821#21477#21450'SQL'#21442#25968'--->SQL'#22266#23450#26465#20214#34892' and 101=102'
            TabOrder = 1
            Height = 436
            Width = 1000
            object dbFDataSQL: TcxDBMemo
              Left = 2
              Top = 20
              Align = alClient
              DataBinding.DataField = 'FDataSQL'
              DataBinding.DataSource = dsData
              Properties.ScrollBars = ssBoth
              TabOrder = 0
              Height = 414
              Width = 996
            end
          end
        end
        object tabSheetField: TcxTabSheet
          Caption = #23383#27573#20449#24687
          ImageIndex = 1
          object Panel3: TPanel
            Left = 0
            Top = 0
            Width = 1000
            Height = 35
            Align = alTop
            BevelOuter = bvNone
            TabOrder = 0
            object tbFieldAdd: TcxButton
              Left = 2
              Top = 4
              Width = 75
              Height = 25
              Caption = #26032#22686
              OptionsImage.ImageIndex = 0
              TabOrder = 0
              OnClick = tbFieldAddClick
            end
            object tbFieldDel: TcxButton
              Left = 83
              Top = 4
              Width = 75
              Height = 25
              Caption = #21024#38500
              OptionsImage.ImageIndex = 10
              TabOrder = 1
              OnClick = tbFieldDelClick
            end
            object tbFieldAddAll: TcxButton
              Left = 164
              Top = 4
              Width = 125
              Height = 25
              Caption = #25209#37327#29983#25104#23383#27573
              OptionsImage.ImageIndex = 0
              TabOrder = 2
              OnClick = tbFieldAddAllClick
            end
            object tbFieldDelAll: TcxButton
              Left = 295
              Top = 4
              Width = 90
              Height = 25
              Caption = #21024#38500#25152#26377
              OptionsImage.ImageIndex = 10
              TabOrder = 3
              OnClick = tbFieldDelAllClick
            end
          end
          object grdField: TcxGrid
            Left = 0
            Top = 35
            Width = 1000
            Height = 538
            Align = alClient
            TabOrder = 1
            object vwField: TcxGridDBTableView
              Navigator.Buttons.CustomButtons = <>
              ScrollbarAnnotations.CustomAnnotations = <>
              DataController.DataSource = dsField
              DataController.Summary.DefaultGroupSummaryItems = <>
              DataController.Summary.FooterSummaryItems = <>
              DataController.Summary.SummaryGroups = <>
              OptionsView.GroupByBox = False
              object vwFieldFOrderNumber: TcxGridDBColumn
                DataBinding.FieldName = 'FOrderNumber'
                Width = 61
              end
              object vwFieldFFieldName: TcxGridDBColumn
                DataBinding.FieldName = 'FFieldName'
                Width = 100
              end
              object vwFieldFFieldCaption: TcxGridDBColumn
                DataBinding.FieldName = 'FFieldCaption'
                Width = 100
              end
              object vwFieldFFieldJsonName: TcxGridDBColumn
                DataBinding.FieldName = 'FFieldJsonName'
                Width = 100
              end
              object vwFieldFFieldKind: TcxGridDBColumn
                DataBinding.FieldName = 'FFieldKind'
                Width = 100
              end
              object vwFieldFFieldDataType: TcxGridDBColumn
                DataBinding.FieldName = 'FFieldDataType'
                Width = 100
              end
              object vwFieldFFieldSize: TcxGridDBColumn
                DataBinding.FieldName = 'FFieldSize'
                Width = 100
              end
              object vwFieldFFieldPrecision: TcxGridDBColumn
                DataBinding.FieldName = 'FFieldPrecision'
                Width = 100
              end
              object vwFieldFFieldFormat: TcxGridDBColumn
                DataBinding.FieldName = 'FFieldFormat'
                PropertiesClassName = 'TcxComboBoxProperties'
                Properties.Items.Strings = (
                  '______'#26102#38388#26684#24335#21442#32771'__________'
                  'yyyy-mm-dd hh:nn:ss'
                  'yyyy-mm-dd'
                  'yyyy'
                  'hh:nn:ss'
                  ''
                  '')
              end
              object vwFieldFFieldProvidFlagKey: TcxGridDBColumn
                DataBinding.FieldName = 'FFieldProvidFlagKey'
                Width = 100
              end
              object vwFieldFFieldProvidFlagUpdate: TcxGridDBColumn
                DataBinding.FieldName = 'FFieldProvidFlagUpdate'
                Width = 100
              end
              object vwFieldFFieldProvidFlagWhere: TcxGridDBColumn
                DataBinding.FieldName = 'FFieldProvidFlagWhere'
                Width = 100
              end
              object vwFieldFFieldDefaultValueType: TcxGridDBColumn
                DataBinding.FieldName = 'FFieldDefaultValueType'
                Width = 100
              end
              object vwFieldFFieldDefaultValue: TcxGridDBColumn
                DataBinding.FieldName = 'FFieldDefaultValue'
                Width = 100
              end
              object vwFieldFFieldShowPassChar: TcxGridDBColumn
                DataBinding.FieldName = 'FFieldShowPass'
                Width = 100
              end
              object vwFieldFFieldSaveCheckEmpty: TcxGridDBColumn
                DataBinding.FieldName = 'FFieldCheckEmpty'
                Width = 100
              end
            end
            object lvField: TcxGridLevel
              GridView = vwField
            end
          end
        end
        object tabSheetParams: TcxTabSheet
          Caption = #26465#20214#21442#25968#35774#32622
          ImageIndex = 2
          object Panel11: TPanel
            Left = 0
            Top = 0
            Width = 1000
            Height = 35
            Align = alTop
            BevelOuter = bvNone
            TabOrder = 0
            object tbParamsGet: TcxButton
              Left = 5
              Top = 4
              Width = 127
              Height = 25
              Caption = #33719#21462'SQL'#21442#25968
              OptionsImage.ImageIndex = 0
              TabOrder = 0
              OnClick = tbParamsGetClick
            end
            object tbParamsAdd: TcxButton
              Left = 138
              Top = 4
              Width = 75
              Height = 25
              Caption = #26032#22686
              OptionsImage.ImageIndex = 0
              TabOrder = 1
              OnClick = tbParamsAddClick
            end
            object tbParamsDel: TcxButton
              Left = 219
              Top = 4
              Width = 75
              Height = 25
              Caption = #21024#38500
              OptionsImage.ImageIndex = 10
              TabOrder = 2
              OnClick = tbParamsDelClick
            end
          end
          object grdParam: TcxGrid
            Left = 0
            Top = 35
            Width = 1000
            Height = 345
            Align = alClient
            TabOrder = 1
            object vwParam: TcxGridDBBandedTableView
              Navigator.Buttons.CustomButtons = <>
              ScrollbarAnnotations.CustomAnnotations = <>
              DataController.DataSource = dsFilter
              DataController.Summary.DefaultGroupSummaryItems = <>
              DataController.Summary.FooterSummaryItems = <>
              DataController.Summary.SummaryGroups = <>
              OptionsData.Deleting = False
              OptionsData.DeletingConfirmation = False
              OptionsView.GroupByBox = False
              Bands = <
                item
                  Caption = #22522#26412#20449#24687
                  FixedKind = fkLeft
                  Width = 368
                end
                item
                  Caption = #20854#23427#20449#24687
                end>
              object vwParamFOrderNumber: TcxGridDBBandedColumn
                DataBinding.FieldName = 'FOrderNumber'
                Width = 62
                Position.BandIndex = 0
                Position.ColIndex = 0
                Position.RowIndex = 0
              end
              object vwParamFFilterName: TcxGridDBBandedColumn
                DataBinding.FieldName = 'FFilterName'
                Width = 100
                Position.BandIndex = 0
                Position.ColIndex = 1
                Position.RowIndex = 0
              end
              object vwParamFFilterCaption: TcxGridDBBandedColumn
                DataBinding.FieldName = 'FFilterCaption'
                Width = 100
                Position.BandIndex = 0
                Position.ColIndex = 2
                Position.RowIndex = 0
              end
              object vwParamFFilterJsonName: TcxGridDBBandedColumn
                DataBinding.FieldName = 'FFilterJsonName'
                Width = 100
                Position.BandIndex = 0
                Position.ColIndex = 3
                Position.RowIndex = 0
              end
              object vwParamFFilterFieldMode: TcxGridDBBandedColumn
                DataBinding.FieldName = 'FFilterFieldMode'
                PropertiesClassName = 'TcxComboBoxProperties'
                Properties.Items.Strings = (
                  #21333#23383#27573
                  #22810#23383#27573
                  #20540#36873#25321
                  #29238#32423#20851#32852)
                Width = 110
                Position.BandIndex = 1
                Position.ColIndex = 0
                Position.RowIndex = 0
              end
              object vwParamFFilterField: TcxGridDBBandedColumn
                DataBinding.FieldName = 'FFilterField'
                Width = 107
                Position.BandIndex = 1
                Position.ColIndex = 1
                Position.RowIndex = 0
              end
              object vwParamFPFilterField: TcxGridDBBandedColumn
                DataBinding.FieldName = 'FPFilterField'
                Width = 111
                Position.BandIndex = 1
                Position.ColIndex = 2
                Position.RowIndex = 0
              end
              object vwParamFFilterDataType: TcxGridDBBandedColumn
                DataBinding.FieldName = 'FFilterDataType'
                PropertiesClassName = 'TcxComboBoxProperties'
                Properties.Items.Strings = (
                  #23383#31526#20018
                  #25972#22411
                  #25968#23383
                  #24067#23572
                  #26102#38388)
                Width = 140
                Position.BandIndex = 1
                Position.ColIndex = 3
                Position.RowIndex = 0
              end
              object vwParamFFilterFormat: TcxGridDBBandedColumn
                DataBinding.FieldName = 'FFilterFormat'
                PropertiesClassName = 'TcxComboBoxProperties'
                Properties.Items.Strings = (
                  '______'#26102#38388#26684#24335#21442#32771'__________'
                  'yyyy-mm-dd hh:nn:ss'
                  'yyyy-mm-dd'
                  'yyyy'
                  'hh:nn:ss'
                  '')
                Width = 136
                Position.BandIndex = 1
                Position.ColIndex = 4
                Position.RowIndex = 0
              end
              object vwParamFFilterExpression: TcxGridDBBandedColumn
                DataBinding.FieldName = 'FFilterExpression'
                PropertiesClassName = 'TcxComboBoxProperties'
                Properties.Items.Strings = (
                  '='
                  '>'
                  '<'
                  '>='
                  '<='
                  #30456#20284
                  #24038#30456#20284
                  #21491#30456#20284
                  #21253#21547
                  #19981#21253#21547)
                Width = 100
                Position.BandIndex = 1
                Position.ColIndex = 5
                Position.RowIndex = 0
              end
              object vwParamFFilterbMust: TcxGridDBBandedColumn
                DataBinding.FieldName = 'FFilterbMust'
                PropertiesClassName = 'TcxCheckBoxProperties'
                Properties.NullStyle = nssUnchecked
                Width = 83
                Position.BandIndex = 1
                Position.ColIndex = 6
                Position.RowIndex = 0
              end
              object vwParamFFilterbValue: TcxGridDBBandedColumn
                DataBinding.FieldName = 'FFilterbValue'
                PropertiesClassName = 'TcxCheckBoxProperties'
                Properties.NullStyle = nssUnchecked
                Width = 83
                Position.BandIndex = 1
                Position.ColIndex = 7
                Position.RowIndex = 0
              end
              object vwParamFFilterDefaultType: TcxGridDBBandedColumn
                DataBinding.FieldName = 'FFilterDefaultType'
                PropertiesClassName = 'TcxImageComboBoxProperties'
                Properties.Items = <
                  item
                    Description = #22266#23450#24120#37327
                    ImageIndex = 0
                    Value = 'fromConst'
                  end
                  item
                    Description = #21069#31471#21442#25968#21462#20540
                    Value = 'fromJsonParam'
                  end
                  item
                    Description = #31995#32479#29992#25143#20449#24687
                    Value = 'fromSysToken'
                  end
                  item
                    Description = #29238#32423#25968#25454#21462#20540
                    Value = 'fromPData'
                  end
                  item
                    Description = #31995#32479#24120#37327#21462#20540
                    Value = 'fromSys'
                  end>
                Width = 115
                Position.BandIndex = 1
                Position.ColIndex = 8
                Position.RowIndex = 0
              end
              object vwParamFFilterDefaultValue: TcxGridDBBandedColumn
                DataBinding.FieldName = 'FFilterDefaultValue'
                PropertiesClassName = 'TcxComboBoxProperties'
                Properties.Items.Strings = (
                  #8212#8212#8212#8212#31995#32479#29992#25143#20449#24687#8212#8212#8212#8212
                  '--'#30331#38470#29992#25143'TokenID'
                  'TokenID'
                  '--'#30331#38470#29992#25143'ID'
                  'TokenUserID'
                  '--'#30331#38470#29992#25143#20195#30721
                  'TokenUserCode'
                  '--'#30331#38470#29992#25143#21517#31216
                  'TokenUserName'
                  '--'#30331#38470#29992#25143#30331#38470#20195#30721
                  'TokenLoginCode'
                  #8212#8212#8212#8212#31995#32479#24120#37327#21462#20540#8212#8212#8212#8212
                  '--'#26412#27425#25805#20316'Api'#35831#27714#20851#32852'ID'
                  'UnionID'
                  '--'#21462'32'#20301'GUID'
                  'SysGUID'
                  '--'#21462#26102#38388'  yyyy-mm-dd hh:mm:ss'
                  'SysDateTime'
                  '--'#21462#26085#26399' yyyy-mm-dd'
                  'SysDate'
                  '--'#21462#26102#38388' hh:mm'
                  'SysTime'
                  '--'#21462#24180#20221' yyyy'
                  'SysYear'
                  #8212#8212#8212#8212#29238#32423#25968#25454#21462#20540':'#22635#20889#29238#32423#25968#25454#23383#27573#8212#8212#8212#8212
                  #8212#8212#8212#8212#22266#23450#24120#37327':'#20540#26159#20160#20040#23601#21462#20160#20040#8212#8212#8212#8212
                  #8212#8212#8212#8212#21069#31471#21442#25968#21462#20540':'#21462#21069#31471'JSON'#21517#31216#23545#24212#30340#21442#25968#20540#8212#8212#8212#8212)
                Width = 136
                Position.BandIndex = 1
                Position.ColIndex = 9
                Position.RowIndex = 0
              end
              object vwParamFbOutParam: TcxGridDBBandedColumn
                DataBinding.FieldName = 'FbOutParam'
                PropertiesClassName = 'TcxCheckBoxProperties'
                Properties.NullStyle = nssUnchecked
                Width = 100
                Position.BandIndex = 1
                Position.ColIndex = 10
                Position.RowIndex = 0
              end
              object vwParamFOutParamTag: TcxGridDBBandedColumn
                DataBinding.FieldName = 'FOutParamTag'
                Width = 100
                Position.BandIndex = 1
                Position.ColIndex = 11
                Position.RowIndex = 0
              end
            end
            object lvParam: TcxGridLevel
              GridView = vwParam
            end
          end
          object cxGroupBox2: TcxGroupBox
            Left = 0
            Top = 380
            Align = alBottom
            Caption = #36807#28388#27169#24335'->'#22810#23383#27573#25110#20540#36873#25321
            TabOrder = 2
            Height = 193
            Width = 1000
            object dbFFilterFieldItems: TcxDBMemo
              Left = 2
              Top = 20
              Align = alLeft
              DataBinding.DataField = 'FFilterFieldItems'
              DataBinding.DataSource = dsFilter
              TabOrder = 0
              Height = 171
              Width = 550
            end
            object memoFilterItemRemark: TMemo
              Left = 552
              Top = 20
              Width = 446
              Height = 171
              Align = alClient
              Lines.Strings = (
                #36807#28388#27169#24335'->'#22810#23383#27573' '#31034#20363
                'FieldA'
                'FieldB'
                'FieldC'
                '--'#26368#32456#32452#25104'SQL FieldA='#39'xxx'#39' or FieldB='#39'xxx'#39' or FieldC='#39'xxx'#39
                #36807#34385#27169#24335'-'#20540#36873#25321'  '#31034#20363
                '1=and FieldA='#39'A'#39
                '2=and FieldA='#39'B'#39
                '3=and 1=1'
                '---'#36755#20837'1'#21462#24471'SQL and FieldA='#39'A'#39#32452#35013
                '---'#36755#20837'2'#21462#24471'SQL and FieldA='#39'B'#39#32452#35013
                '---'#36755#20837'3'#21462#24471'SQL and 1=1 '#32452#35013)
              ScrollBars = ssBoth
              TabOrder = 1
            end
          end
        end
      end
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 230
        Height = 594
        Align = alLeft
        Caption = 'Panel1'
        TabOrder = 1
        object Panel2: TPanel
          Left = 1
          Top = 1
          Width = 228
          Height = 35
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 0
          object tbDataAdd: TcxButton
            Left = 2
            Top = 4
            Width = 75
            Height = 25
            Caption = #26032#22686
            OptionsImage.ImageIndex = 4
            TabOrder = 0
            OnClick = tbDataAddClick
          end
          object tbDataDel: TcxButton
            Left = 151
            Top = 4
            Width = 67
            Height = 25
            Caption = #21024#38500
            OptionsImage.ImageIndex = 5
            TabOrder = 1
            OnClick = tbDataDelClick
          end
          object tbDataChildAdd: TcxButton
            Left = 78
            Top = 4
            Width = 75
            Height = 25
            Caption = #26032#22686#23376#33410#28857
            OptionsImage.ImageIndex = 4
            TabOrder = 2
            OnClick = tbDataChildAddClick
          end
        end
        object DataTree: TcxDBTreeList
          Left = 1
          Top = 36
          Width = 228
          Height = 557
          Align = alClient
          Bands = <
            item
            end>
          DataController.DataSource = dsData
          DataController.ParentField = 'FPDataID'
          DataController.KeyField = 'FDataID'
          Navigator.Buttons.CustomButtons = <>
          OptionsData.Editing = False
          OptionsData.Deleting = False
          RootValue = -1
          ScrollbarAnnotations.CustomAnnotations = <>
          TabOrder = 1
          object colFMenuTreeCode: TcxDBTreeListColumn
            Caption.Text = #33410#28857
            DataBinding.FieldName = 'FTreeCode'
            Width = 94
            Position.ColIndex = 0
            Position.RowIndex = 0
            Position.BandIndex = 0
            Summary.FooterSummaryItems = <>
            Summary.GroupFooterSummaryItems = <>
          end
          object colFMenuCaption: TcxDBTreeListColumn
            Caption.AlignHorz = taCenter
            DataBinding.FieldName = 'FDataCaption'
            Width = 128
            Position.ColIndex = 1
            Position.RowIndex = 0
            Position.BandIndex = 0
            Summary.FooterSummaryItems = <>
            Summary.GroupFooterSummaryItems = <>
          end
        end
      end
    end
    object cxTabSheet1: TcxTabSheet
      Caption = #30456#20851#34920#25968#25454#32467#26500','#35831#20808#21019#24314#22909#34920#32467#26500#22312#26469
      ImageIndex = 1
      object edSQL: TMemo
        Left = 0
        Top = 0
        Width = 1230
        Height = 594
        Align = alClient
        Lines.Strings = (
          '----20230527'#33050#26412#22686#21152'---'
          'alter table onefast_api_field add FFieldFormat nvarchar(20)'
          ''
          '----20230508'#33050#26412#22686#21152'---'
          'alter table onefast_api add FApiAuthor nvarchar(30)'
          'alter table onefast_api add FApiRole  nvarchar(30)'
          ''
          '-------FastApi'#37197#32622#20027#34920'-------------'
          ''
          'CREATE TABLE dbo.onefast_api('
          #9'FApiID nvarchar(32) primary key,'
          #9'FPApiID nvarchar(32) NULL,'
          #9'FApiCode nvarchar(50) NULL,'
          #9'FApiCaption nvarchar(50) NULL,'
          #9'FOrderNumber int NULL,'
          #9'FIsMenu bit NULL,'
          #9'FIsEnabled bit NULL,'
          '        FApiAuthor nvarchar(30) NULL,'
          '        FApiRole nvarchar(30) NULL)'
          ''
          '-------FastApi'#25968#25454#28304#34920'-------------'
          'CREATE TABLE dbo.onefast_api_data('
          #9'FDataID nvarchar(32) primary key ,'
          #9'FPDataID nvarchar(32) NULL,'
          #9'FApiID nvarchar(32) NULL,'
          #9'FTreeCode nvarchar(30) NULL,'
          #9'FDataName nvarchar(50) NULL,'
          #9'FDataCaption nvarchar(50) NULL,'
          #9'FDataJsonName nvarchar(50) NULL,'
          #9'FDataJsonType nvarchar(20) NULL,'
          #9'FDataZTCode nvarchar(50) NULL,'
          #9'FDataTable nvarchar(50) NULL,'
          #9'FDataStoreName nvarchar(100) NULL,'
          #9'FDataPrimaryKey nvarchar(50) NULL,'
          #9'FDataOpenMode nvarchar(20) NULL,'
          #9'FDataPageSize int NULL,'
          #9'FDataUpdateMode nvarchar(20) NULL,'
          #9'FDataSQL text NULL,'
          #9'FMinAffected int NULL,'
          #9'FMaxAffected int NULL)'
          ''
          '-------FastApi'#23383#27573#34920'-------------'
          'CREATE TABLE dbo.onefast_api_field('
          #9'FFieldID nvarchar(32) primary key,'
          #9'FDataID nvarchar(32) NULL,'
          #9'FApiID nvarchar(32) NULL,'
          #9'FOrderNumber int NULL,'
          #9'FFieldName nvarchar(50) NULL,'
          #9'FFieldCaption nvarchar(50) NULL,'
          #9'FFieldJsonName nvarchar(50) NULL,'
          #9'FFieldKind nvarchar(20) NULL,'
          #9'FFieldDataType nvarchar(30) NULL,'
          #9'FFieldSize int NULL,'
          #9'FFieldPrecision int NULL,'
          #9'FFieldProvidFlagKey bit NULL,'
          #9'FFieldProvidFlagUpdate bit NULL,'
          #9'FFieldProvidFlagWhere bit NULL,'
          #9'FFieldDefaultValueType nvarchar(30) NULL,'
          #9'FFieldDefaultValue nvarchar(30) NULL,'
          #9'FFieldShowPass bit NULL,'
          #9'FFieldCheckEmpty bit NULL,'
          '        FFieldFormat nvarchar(20) Null,'
          ')'
          '-------FastApi'#26465#20214#34920'-------------'
          'CREATE TABLE dbo.onefast_api_filter('
          #9'FFilterID nvarchar(32) primary key ,'
          #9'FDataID nvarchar(32) NULL,'
          #9'FApiID nvarchar(32) NULL,'
          #9'FOrderNumber int NULL,'
          #9'FFilterName nvarchar(50) NULL,'
          #9'FFilterCaption nvarchar(50) NULL,'
          #9'FFilterJsonName nvarchar(50) NULL,'
          #9'FFilterFieldMode nvarchar(20) NULL,'
          #9'FFilterField nvarchar(50) NULL,'
          #9'FPFilterField nvarchar(50) NULL,'
          #9'FFilterFieldItems nvarchar(500) NULL,'
          #9'FFilterDataType nvarchar(20) NULL,'
          #9'FFilterFormat nvarchar(20) NULL,'
          #9'FFilterExpression nvarchar(10) NULL,'
          #9'FFilterbMust bit NULL,'
          #9'FFilterbValue bit NULL,'
          #9'FFilterDefaultType nvarchar(20) NULL,'
          #9'FFilterDefaultValue nvarchar(50) NULL,'
          #9'FbOutParam bit NULL,'
          #9'FOutParamTag nvarchar(30) NULL)')
        TabOrder = 0
      end
    end
    object cxTabSheet2: TcxTabSheet
      Caption = #35831#27714#25968#25454#30340#26684#24335#21442#32771
      ImageIndex = 2
      ExplicitWidth = 1226
      ExplicitHeight = 593
      object Memo1: TMemo
        Left = 249
        Top = 0
        Width = 448
        Height = 594
        Align = alLeft
        Lines.Strings = (
          '{'
          '    "apiCode":"'#25509#21475#20195#30721'",'
          '    "apiData":{'#25509#21475#25552#20132#30340#25968#25454#21487#20197#26159'Json'#23545#35937#20063#21487#20197#26159'Json'#25968#32452'},'
          '    "apiParam":{'#25509#21475#25552#20132#30340#21442#25968',Json'#23545#35937'},'
          '    "apiPage":{"pageIndex":1,"pageSize":20},//'#20998#39029#20449#24687
          '    "apiZTCode":""  //'#25351#23450#26597#35810#21738#20010#36134#22871','#21487#20197#25918#31354#65292#25918#31354#23601#26159#20027#36134#22871
          '}')
        TabOrder = 0
        ExplicitHeight = 593
      end
      object Memo2: TMemo
        Left = 0
        Top = 0
        Width = 249
        Height = 594
        Align = alLeft
        Lines.Strings = (
          '{'
          '    "apiCode":"TEST",'
          '    "apiData":{},'
          '    "apiParam":{},'
          '    "apiPage":{},'
          '    "apiZTCode":""'
          '}')
        TabOrder = 1
        ExplicitHeight = 593
      end
    end
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
    Left = 456
    Top = 48
  end
  object BarManager: TdxBarManager
    AllowReset = False
    AutoDockColor = False
    AutoHideEmptyBars = True
    Scaled = False
    Font.Charset = GB2312_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = #24494#36719#38597#40657
    Font.Style = []
    Categories.Strings = (
      'Default')
    Categories.ItemsVisibles = (
      2)
    Categories.Visibles = (
      True)
    DockColor = 15130321
    ImageOptions.LargeImages = cxImageList1
    ImageOptions.StretchGlyphs = False
    MenusShowRecentItemsFirst = False
    PopupMenuLinks = <>
    UseSystemFont = False
    Left = 599
    Top = 508
    PixelsPerInch = 96
    DockControlHeights = (
      0
      0
      59
      0)
    object barMain: TdxBar
      AllowClose = False
      AllowCustomizing = False
      AllowQuickCustomizing = False
      AllowReset = False
      BorderStyle = bbsNone
      Caption = 'barMain'
      CaptionButtons = <>
      DockedDockingStyle = dsTop
      DockedLeft = 0
      DockedTop = 0
      DockingStyle = dsTop
      FloatLeft = 990
      FloatTop = 235
      FloatClientWidth = 51
      FloatClientHeight = 236
      ItemLinks = <
        item
          Visible = True
          ItemName = 'tbRefsh'
        end
        item
          Visible = True
          ItemName = 'tbNew'
        end
        item
          Visible = True
          ItemName = 'tbApiEdit'
        end
        item
          Visible = True
          ItemName = 'tbSave'
        end
        item
          Visible = True
          ItemName = 'tbReportDesign'
        end
        item
          Visible = True
          ItemName = 'tbRefreshApi'
        end
        item
          Visible = True
          ItemName = 'tbSaveSet'
        end>
      OneOnRow = True
      Row = 0
      UseOwnFont = False
      UseRestSpace = True
      Visible = True
      WholeRow = True
    end
    object tbSave: TdxBarLargeButton
      Caption = #20445#23384#25509#21475
      Category = 0
      Hint = #20445#23384#25509#21475
      Visible = ivAlways
      OnClick = tbSaveClick
      AutoGrayScale = False
      LargeImageIndex = 0
      SyncImageIndex = False
      ImageIndex = 311
    end
    object tbDel: TdxBarLargeButton
      Caption = #21024#38500
      Category = 0
      Hint = #21024#38500
      Visible = ivAlways
      AutoGrayScale = False
      LargeImageIndex = 10
      SyncImageIndex = False
      ImageIndex = 10
    end
    object tbApiEdit: TdxBarLargeButton
      Caption = #32534#36753#25509#21475
      Category = 0
      Hint = #32534#36753#25509#21475
      Visible = ivAlways
      OnClick = tbApiEditClick
      AutoGrayScale = False
      LargeImageIndex = 2
    end
    object tbNew: TdxBarLargeButton
      Caption = #26032#22686#25509#21475
      Category = 0
      Hint = #26032#22686#25509#21475
      Visible = ivAlways
      OnClick = tbNewClick
      AutoGrayScale = False
      LargeImageIndex = 1
    end
    object tbRefsh: TdxBarLargeButton
      Caption = #25171#24320
      Category = 0
      Hint = #25171#24320
      Visible = ivAlways
      OnClick = tbRefshClick
      AutoGrayScale = False
      LargeImageIndex = 3
    end
    object tbSaveSet: TdxBarLargeButton
      Align = iaCenter
      Caption = #20445#23384#37197#32622
      Category = 0
      Hint = #20445#23384#37197#32622
      Visible = ivAlways
      OnClick = tbSaveSetClick
      AutoGrayScale = False
      LargeImageIndex = 0
    end
    object tbRefreshApi: TdxBarLargeButton
      Caption = #21047#26032#26381#21153#31471'Api'#37197#32622
      Category = 0
      Hint = #21047#26032#26381#21153#31471'Api'#37197#32622
      Visible = ivAlways
      OnClick = tbRefreshApiClick
      AutoGrayScale = False
      LargeImageIndex = 3
    end
    object tbReportDesign: TdxBarLargeButton
      Caption = #25509#21475#25253#34920#35774#35745
      Category = 0
      Hint = #25509#21475#25253#34920#35774#35745
      Visible = ivAlways
      OnClick = tbReportDesignClick
      AutoGrayScale = False
      LargeImageIndex = 2
    end
  end
  object cxImageList1: TcxImageList
    SourceDPI = 96
    Height = 32
    Width = 32
    FormatVersion = 1
    DesignInfo = 19923168
    ImageInfo = <
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F40000000B744558745469746C6500536176653BF9E8F9090000054549444154
          785EC557BF8B5C5514FEEE7D33B3EE6E36B1D02882853F1A41D046540C1241B4
          B5B3482C36601A41831048A148F01FD022B516366A21181051D0C2422DACC222
          61A322E81A22C4EC8FECECBC7B7E48BEC39DF774D80109EAEE5CCEBB770EE73B
          E73BDFB96F37B93BFECF9F34BB47BAA958F3977796AB0F860CA0A1E59A097EB3
          E0155801080003E0831E40F3F29BEFBC315A583893726E524AC8D9F1F3C575EC
          6C6F33DF83CB4B78F8A10760E630535A3583DD586AD01BCB14A60E55C1DADA1A
          960E2EC31D70A59F8A94F73FF9F0DC090065268166343A7DE491079B9C123C03
          C3A6C1D98FCE6379296369F900F2CA019C5C7D2EF87300B41E00A0EDCE0C7861
          F5149E7DFA28133235987BF3D9E75F3E0FE064B000F413C86636823BBEFF7103
          9680C5E1B032171F37A83936AEEE76C0B48E13C78E47E752B87F7CFE03FA5EB8
          7009A24AC6EE387C1BCCADB6195D02B1928B43CC482B6B1A3488CA12AD9A41D4
          508A72DF4F20E5014C17909070F7BDF7A12D06538565836BF88B29FA629F49C0
          5C604C4019C82A403890CA228622DA07E773CA0D9AD420370DCC9C3E2CC4127D
          61606CB72AFE590628149510514A0E3705D10912622BD23160D6B190F3008366
          C444CCC2A702BA1B1719F1FD13486ED102332103AC8EBF011209284A11021BC0
          24C0041A0C4723348301D40D93220474846ECC13AD9B55BCD90454850CA81852
          4E5013A0A39994B645A2BA6E0268536AB0B872887B53431B0C80076422CE1DB3
          0CD4839863D5108D27B6C2BD5B95DA5622306BF10879E6EC59DC7EEB52F83942
          2766A45C482199658C7D5B605A0820AAC89618E0F05D77E2F2AF1BD8D9B98695
          8382574FBD0603A924D5608F09C4E7F8CE09B872E810CC8DBE6CAF1A8BAA7833
          09882844249848405B5A3CFED493481C4320E4CE0F0113590136AF5D45BBBB0B
          EFB342C11134C4EDCED6CE6320FA5F04AAC2FDD6B620F7D2F5C427027B02ADAA
          E28F2BBFD3A10A13912DAC6A84E318F131670A28C222A15EB7B8AFAC03EFD266
          1087A784EB9B9BEC710AB0AA09520FAFAE46ABB5553DCCBFB6403534D00A9013
          C0C084428A2D12174F48F378E73ADC957BC0C31F98566EFD6B5C0566BAFF1458
          2928A54044812682EDEE6C414B81A78EDAA8D2216D8148A1C098265131BDA472
          CE5858589CEE952FA5392D10DE01857D8502098632D9C3BBE75E8F96047C7D3F
          B09AC0440566325507C7564F63301CC5182B606270DF7F0A083E29424BB1C121
          25F420BD2ADDC1A5D6ED031EB1E7D4F0EA65C52187F92DE0A1A942DBB8E9728E
          40E63AADFA8BAF7F22A89A626B6B0F6D89AB59D598A888D2BE78FC31C04126CD
          AC261963A8B36398FA53D096021381A6CA8A4C031C7DF49E182FEB546E7D061C
          DD9B2F318100E4B9431A5E53FBBE0B20F1A2E14D9852CD5AA7E2FAF4AB75EEB7
          775A4C4461A26480D51783A8F0E27969F54865607A2BAA0359C9C03C110A8417
          91C641ED1BA2D2679EB81FAC41630AE2C3EA7A62AC3D07935123207D285AC47E
          760CA90183460B6A30F6D7ADCA9F60F5B12FBE2E21EE5358115888B713ADEDFF
          1711AA065404E869E0BDEF7EC3D6B840D4312E420DA8D5A02008E7DC416BD329
          316A25D5C41573FF222245CAACAB58A28F79B488810DA1E2183546F0C6007547
          2638E299ADE9C693FA5183A504D497D7DF4498C3F0545DCDD494A04E914542D1
          4BA78DEA120C209D5627C108CE67207C9C3D9FF6AA8EA4001062760C305E3B1E
          6FBF7D69FDE22BC9916BA06193F1ED373F6032919810E9FE09916A4599608C9D
          134835D695CBBFA0C7B9B5EDF5B7004C88D99DD30E01DCC2D5BF1FE6AFF40FBE
          F7A81C7B00C6005A00DED74001A0F12532FE9D1F8FCAA1F3FE3BFE2F3E5E377F
          02C73EB2E2D2D4F54C0000000049454E44AE426082}
        FileName = 'Images\Save\Save_32x32.png'
        Keywords = 'Save;Save'
      end
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F40000002C744558745469746C65004164643B4974656D3B4164644974656D3B
          426172733B526962626F6E3B4974656D3B506C75734E32EF81000006C5494441
          54785EC5977D8C156715C67F67E6EE2E1F5BF9E8F24DA17C7581A51B0256B450
          124861050D04A3698AE2071A9BB4C6D694A405AABBA5D5261A4D89696A6825AD
          B686B67FF847AD464B23AD0183144DC1AA8545285FBD65E9B2DFF763E63DC7DB
          B9F7CD6CBA1756FFF29D9C9CF7CE4CEEF3E439CF9C33236686885059522D578D
          EAD70CD0245F6399A597331F0190DDCF1CDC4F20ABC4C000D410044B0E1028EF
          0CCCC084F206E8E9EA7DA4EDFEF5BB3C895DBBF71BA618D07ADFDA61D90810EE
          7EF6900DB70A85C8FA060AD6D53D60EF5FEEB133E73AEDC8B1F3F6DAC193F6E0
          63BF7E04A8010240FE71229B62A4983E862A601800B11AA84100A60280BFE614
          CC4011D424B9F7C0E153DCFFF595F4E7A287EE6B7B491E6FFBC22E205E78D364
          CC33181A43088033004C7D06F05A83014118008A95B20B0204A5508C005875EB
          3C9CEACEFCF6E7E4678F7D2921212257F545304401AB009B80011E1F4BF7A604
          41500A9050508442AE08401806DCBEA2B11437EFD8FA9DBDAD83CBF15F11508F
          598134A59CAD1228000A090911408D5CA14C2013089930A06555136B572DDEFE
          C5BB9FFCDE5012D54B2080982A00DEBD46596E4889F8A5188108865032262290
          09852010C2D0D8D8D28CBA787B54DCCD8B4FDFDBE6FFE29A1EF000A9FA0A1680
          F9320A8A672249D4D4858CB96E04773DF82B54D347148C75AB17D138FFA6EDC0
          A3801BCE84A22983942A8A7A23E2814155094261D4885ABE7AC772FA06F2148B
          112E36A258899D23230264014280E10978F7FB3A9B915AD893330C1001106A33
          6505AE1B5D87734A1C39A20F73EC929238A778B9185E01F5E060E6354B5519AC
          00026A88406D4D889A6116E26A436A9DE2624D08289E000C6F42E76B688094B3
          571E3015F0347C5510CC925C366210608021D464048D199E800F5F02D2470E73
          FED460265EA54A045E630331EA02C109D48442C3F8919E003B9F3FC6779F3F8E
          89F0E8E645D53CA00024299014C5D2668C8FCA240D02E3726F9E6367BA3993ED
          A773202610183B32E4C649A39833ABC1AB2D5FDED808407D4DE66A9DD05BCE30
          3548EA0A8A619612C1774C537E7FF4224FEF3F4B8F13E6CF9FC0C6DB67B3A114
          0B164CA2D732FCAD03BED2FAC216A0B6B1BE4E42110A4EAB1350054871141260
          ADEC15C3A92F84F2CB3F9EE67C4FC49DEBE7D1BC7022E31AEAC959404E83D27E
          34372F98C0A6357359B4B8F9C777EF7EFD85E98D4B47CF1D5D2B573561ECD483
          E3D2B637A4378818AF1CBE40D184961533B9D81DA106FB5E3AC499772F0370E3
          CC096CBEE3563202EB57CFE1D53782CFB46CFD41DBCF1F68D99109A458B50F78
          995D0A3678831949ABEDB832C0919357D8B2A9897FBD97234C869324E03FFCC6
          A792FDB63D87284446CE94AED23DB72D9BC1D9F3DDDF5EF7CD9FFC62C688CCDF
          CD4CAB94C05BDE7CC2FC91EC054C39F05696E6B9D773AAA340AE60E48A8E42AC
          00CC98369EC54D3300C817B514560AC7894BF9D2F989351F9B34EB6B40A6BA02
          AA406A7E86CC060333DA2FF4F2895B1AB8D41773E0B5A3BCFF5E277E29920002
          3CF1C46F00983C653CABD72EA561CC68241CB906D809148778C0392BE37A05D2
          C193BE13A27474152861D39B8B12F01FDDB59C4024298521C44ED9B36D0D5114
          539309B9E7A7AFD33BE0C810E234980A84D79C051E17F0E0A096641523978FB8
          3250247202C0F429D727B3A0BF101348793E4C9B3CD68F704484C8299D7DC9AC
          18D209252DC1A0DA6BFA16ACA90F112469327D7D053453C7D46913D8F2FDDF56
          5E50846776AC43CDF87CEBCB84618804C20D332711C71F122F921BC89D05AC5A
          1FC099626698FADF86A260E5304031E64C19C5E56C3786B17859131B3EB7920D
          9B6EA3902F902FC40901173BD67FF6937C7ADD321636CF21564757470FFDDD1F
          BC0AC455FB807F08D4069722C03332140858B5640AADCF1E67C9A4F174478E9E
          A4250340FDC80C4E0D11E1524F11D50AF15839F5CEC5387BEA2FCF01D1470918
          A06A0E03C6D6D7F8FAA5FE4F3B31B3A78F63C582B1BCF9D7D32C583A9BA23344
          8D0925429B77BD9280374C1C47143B14408DF66367C99E3BFDE4C93F3D7512D0
          6A04A2623EF7C6B776EC5B6996763E43C104C39F301AC6D73367E618C2FE2EDE
          3ADCCEC225B3B04068BEA52919C12610474A4FDEA1B1A3FDF8592E9CF8F7EF8E
          EEBBA715C86723334FC0832B90DFFBF8D60D401D100EF38D284098A9ADAF6F6C
          697BE083EC953B6F9837353371EA3846D4D76140AEBF40C7852B9C6BBF90EB7C
          F7ED87DFF9C3C37B809E12B8025455007040CE830E1771B12F78FBE56DF74EFF
          F8D6A73AB34D9B6B478E594E104E01D45C9C2DE6BA0E769F3BB2377BECC57F02
          390F5E9D401A8EFF6D15CEBFB9F7CFC0D1F41B000005A24AC45EF621C3E7FFB9
          FE034F250E6FBC460FB00000000049454E44AE426082}
        FileName = 'Images\Actions\AddItem_32x32.png'
        Keywords = 'Actions;AddItem'
      end
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F40000001974455874536F6674776172650041646F626520496D616765526561
          647971C9653C00000013744558745469746C65005461626C653B466F726D6174
          3BEEACCAE3000006D349444154785EB5970D6C955719C77FE7BD6F8B7C9442BF
          2883C256A04029D851568D6C4310269239323744B3294171E2A28B6E8EC93231
          2A660CC42C5B98CE459C891B4E1499043F866C82D88FD1B550A08CB66B9950DA
          D242BBD25B7AEF7DDFF3D8E69E9C1CD75450E33FF7E4E4DCFB9EF3FF3FCFF37F
          4EDEABB040D9F9FF0371671101C00794199E1943455D1BEA3AC835109A5930F0
          CD1CB967F3EB07941759C4FF805B733D940D11949125023A0C0E3FFCC0E26586
          DC1160A21F24FFEA678B190EE72FF43069E2588643594D0B0FAC2860383CFF52
          D9ED862FC481EFA61081BAB6284301F5A72FD2A33C10F3A81267ABD07EB98F58
          C264D7852846A47A8888E519568036E6408112E51C25682D88D8B5F9384B2D20
          26EF4852A81240CCFE6B0810117308882844B90CA0451B01820BB381506B2479
          1002B80AB5D9EF0A504A81DB05A2E1ECB92EEACE746061091520D49D386FD726
          A5F66711D877E0B811E942B8714A3612FEFB0C20087993C611F553DF97CAA4DA
          BADA7F307B6E9EABCD0575C7CF71E7B279468D3515028C48F1283BDA84D3EE7A
          4809B416B46023438B8D0C11B4061BB40DDB4A416BB7EECA3E635C4018866C2C
          9A37656176CECE88520B42CDCF4FBED7F5A015A045181C68B351013AE97625A0
          B546BBF9752D6A4D6644187A2B4E1491DE6E164DC8796DDAFCFCDCC95F58CB6F
          3EF7B5B58569E97818884E46A905B431A48880895C878208CE103B230AADAD49
          116B7E2135451174B633E7C8CB142E2BC99DBC660D7BD73F46E9EC1C44CB679C
          0C681A1A3B38313070CDE5447DA2FAACD3850E4410147BFE506DAB9292A29871
          53365E4F17579EDB4AC9923964DCF1715E7FFC494AF246D2DDD347535B5BA5ED
          02ADE1A6FC2CF498910EB95167C88BE6DF6805381A41416D553377AFB8C5F6FD
          A0F1FADADA39FED436E67C681AE33FB694BF7FFF69666641CFA53E2A4FB5379D
          8F5EFDBC07B60626F5E6088D3599160843734798928821D2B67C623221A44614
          D1D6366A1EFD26B36F9EC2F8C58B29FBC133E48F83AED64EDE3876BEE964D77B
          4BB6B79EBBF0AF26D462386D6C20C99ED7A2D1C8100F5A292EF9C576AA1F7984
          A2E2C903912FA6E2C91D4CCB49A5BDB199436F5F6C6E88F62DF959F7A51640BB
          6D684C284E0F3B424C8422666D9B4D2553EE7BA444A0B7AD8DEA6F3CCCDC0FE6
          92B97490FC39A64F1E434B6D1D071B3A9AAB7AA3CBF745AF5C00F4E3E373C477
          BBA0A2B289F64B5137380B016A2A9B186210E003A9116E9B3B816365B5746EDF
          CCFC7939642E5B4AF9961F33636A3AEF561DE760A7C781AEEE5515F1FEF380AE
          B96D8EDE75FC02D684C56931BE7D5F31B1B8060538061405BB7F5FC5AABB160C
          2D81D28369E768E5292E6DDB4CF1CC74B296DF41F940E405F9193497BF45B5A4
          D17DD77A2A9E5EDF0A848084B1388920C4734B60FBD8B25B1F8276FBDB4C12E2
          7BD0D1D9C59F8ED43073F54AB2EF5C4EC5969F5030752C4D478E529918C5BDBF
          FE2D323A1DE70A96A03F4E180656005A8C991C5611CB87C6B227D73A49DE3940
          FEFC8B7B59BD6A39455F5CC7CE67F7307DD228EA8F5451168E66F5EE3DA4E74E
          04E561E503613C41A035BEBD4AB4069237177880DB09909335969488872078A6
          2E411067C70BBB58B97205A545797C6BCBABDCB2712B7BB76EA057C670FFEFF6
          0E90DF40606E45F77D3088C5D146800612B178ECAF9BB6BEFA515B5AAC06DB9A
          7FAB3C3320248D79B37289BFFB26A7CADEE274176CFDDE4383E4149614F0DAA1
          A35C1C9DC73D9B1EA4BCAE93AA5F1D231E0404B1D821206E339008094530E1E2
          032380542032CC1BAF7DF68945192B3F529CF94CC1DC5CD26FFF34DF79319382
          E2E954D7D4D0F8E6C1A68693E5F775B49F6B0502E76D3806F40389BF4C48D300
          BB2E46F18DA2C03CD46F0987C203521E2A4D2F2D9A95F9C3856B6E25925542CB
          2B3BB9B9BA97170ECF9030111C6E6B6DFECA00790B9070530E6833240C42500A
          91EBFF0FA000BF302B25FD4B25632B566D589A3F2EBF94AEB23F72FAC0494E37
          5EA1AC67DACE576A6B1F05FA0CB99861B13F63A4789646D87DB91F5F64C8B5E3
          BEB3B9A94F2D2CF9C48639F3CFE68FCD9DCDE501F2F6FA369A1ABBE888F941EF
          9533CF62C8EF7EECA590F761DD4FD78180465C163CAE0593FA59CB372E8C16DD
          FFF5FC555FA6FDC07EDE39524FCD1BEFD0D2AB688D864FED6F8E35DA9A5F273C
          A5F0191E36FA79F7FEE85319B9B93B3EB9F2C3FE776B3AC938B68F8975B503C4
          D09D90EDBFA88F6F330E0F37CDF2E5865FAE25AF2FC2B590396A1C3ED78178FF
          D5ABADCD2D75DB37BF3C3D4804D941FF82FAA9D1DEB7D3BA2B76FCB925A830E6
          0D001AFB85063FC4D709543FF8317BA1BB36C3F722CCC81C87723CC0100F3825
          302DEA3BA785C66CAEDB85FF0CD755023124A11382B8C37EF75FE09F0C8BDFE6
          08A3DC930000000049454E44AE426082}
        FileName = 'Images\Actions\FormatAsTable_32x32.png'
        Keywords = 'Actions;FormatAsTable'
      end
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F400000027744558745469746C6500526566726573683B5265706561743B4261
          72733B526962626F6E3B52656C6F6164CD4DF6E90000091349444154785EC597
          6950545716C72F8B46D151474D3431EEA3A351A3E306384649D4382A91C50430
          C8441425A0B8B3AF028ADA54005101111A9C068128342E40836C02DAB23468AB
          C8DEA06C0DCD4E3774379E39AF7DCFE9E2CBD4D45815AA7E75EF8577CEF99FE5
          5DEA1100F843F9C305FC3F3F1AA31965F0519DAB07D5A4D11A0DF3B7FF498C5F
          5239F1FB1DC1D5176182F82494C4BBC43C4E5473A8793A8C37C723F6F1714F4E
          31CF9B535CE61557A2F4E494283DFEF554E07E93CF73892A3871E437EE5C3531
          1A6EB14F896B0C059FB8B2F9C485FD8438472351D4FA9810DF440191BD7BF701
          CAD09D5DB4FB667E0D44F25E814368A611E5F05060C631BF448132E569033C6B
          EA82FACE01908E8C50E0BE1F7F27813B4FEAC137BE54E918591075D03F6E3623
          6470E41D516780E674642121DEB74A89140F882AFB1F8F058CF7892FA97BD323
          0351F7209C0CCFAFFBBB89DD04330FCE92331179F2AE612534CB95201A5242A5
          4C012FA40AA8C6953AB7C947A003CF778B45E016FD64E06850DA6EF43906D11C
          5062D0519C087B440896F0437044D325BAC8FD415913B463908621052414D4C0
          41569A073A196BE6798715975F0DD518E4F980029E0DC8DFD32F870A9A677D72
          689229E1554B1F78C53E8523C13C4746449FE21D51C7E14A3E21D8235539A8E0
          76812973CF270906C498D1EB410554A0B3C6FE6138793577D0F048C8023D6387
          E9163EC92D5558997A1421A2A9C5672B514879CF309422253D4320EC1B863A89
          143C629E286D0292CD68111A4CF05EC508B10FC92138147C267B6DC7C8C23481
          A80B4428A0B41B9DA1A3E72822FF552B587827A7A383715BEDAE9B183B2580A9
          4B02E81DB80E7ABF448089F32D3817FF044A9B7B5522F89221E077CAA0AC6B08
          044DDD384779BDA6274217D233A14105EF416C7F7B4898E05A0E213CE388F497
          D03A3C02020CCC97C86886A006CBED135304BB8E45995222D6595E76586BC1DA
          3673E9B79328D6FC747EBBAEE5E5886F6D6F0CC7E4544209062F144BA1A05D0A
          CFD00727B71A0E5E78C046DB4F10CD6EF908A1B0B9944954A5DFB4C77E024E6E
          7D0D4EF60B2C5D111AABE89051603652A878DB0D468E09F5B3577C37992EA796
          1ADA94F355465E1B36FC12DE12935D098FD13EB76510725B0740281E84A32139
          CA9DB6AC25F4B31A926125D91F90815B34B60FE279DE2EAA8306EC25A53ABF75
          F03FB4BD4780995CBE530A9B6DC2BDA88164DE7306FA3C76E56E37BD2DB691F2
          426C65F6DB7EC86CEA87A2B601B8765F083F7BDDF6A16D353A8794E478682E21
          56DE715FE1B4CA9A7088F81D52788846D96F07E02192DD8C50677AFFAA4B0666
          2E09F255BBDD56309930E5645A898CD3DF171C791167A2102BF0A0A10F45F441
          AAE02DECF5E66244321ED16C4701478373080E42567AD68B3610E2C094A18032
          318255C868EC43FAA114CF0C6548CA935A586711924165C29492A90023608DE9
          D97F98BB24AAFCA5D6F4A8C8AEEB0273AFD456B4F9935A0B3589B17312ECC6A9
          363C1D0F3B4FC4830D2B13F858FA7B75BD70AFBE57B5C75EC1C65FC241DFEA1A
          E85A5E81B5162130AA0D5AF480E9209326CFF8CB175B6CA3E1392675FB751724
          5576412E2663E6C995A3CDA7C86464225D0D54A3666CE89C325CD93B0C2955DD
          9052DD0D8FB0059480493316CDA4D5EBD0C1B4D432FF64FFB974784F1AEC3F9F
          063F7972A10205DC7A218138A104D26A7BC0D43519ACCF67C081008A743888AB
          7AF9B4119D6D276FB71463E9125F4A20F19504B21A7AA909869DF657B651E545
          B499CC5BA50AC208303CC1E1F1CADF408B5401CD34027C1D632B3A805DDE015C
          AC82105B5887C955E21D139F5F05AB4C5999C4E07014A9EE19661C8DDB6C1FFF
          282CB70E420B5B20AAAC1D92D13084FB0CF638DF8AA004329963008230098C59
          67E2F237CBB35CC5FDEA2E600BC4108DB651A562B851DA0E9125ED10FAB805FC
          788DE079BF01021F36C126EB70C53CBD036BC837D611A4AA7B98713456FF60B4
          8F4358A1CAD83FB31102F3DEC23DA118FEE97B5FBED5FAD2064A242382813E4F
          D8B43FF4A26F7C31702AC410F1B40DC2F8AD1054D0ACF2E3F9A001DC3138B5B7
          F4BF0F8BB7BAB2281BA26B194A2ABB871801DA5F197A2E3770F85D19572E86B3
          3C11F866882028AF19D839B560E69EDC6A60E5BF9132A487509B82DEEB4CF962
          E90C039B1BA2C8A22608C86A5205F5A003BBDDAB070F5CDD6FBF84A53BFC1A75
          A62E98A1B25B63164C5E750D51306D18BFCAEA46ECF1483EB072DE80575A0378
          A78920024B18935B0B963E77E546A739D7BFB709FE010DA6506CB509DA61E8C0
          3E81FBA95FEF72DF67E59B0ABFE5BD010F0CEA86B8DCAD07E7D43AF0C364B6D8
          DE80D9EB6DF731F7015969C22242C910798130FD9C67706CC91A6BCE008B574B
          0547470D2A67D7702EB25E4B201867E2308B8715E182991B170E5DCC80431778
          A06B1E4039FE6CB56960B6EF9DE7D8EFF7819DB8B5E076B70E0E5F2D80B91B9D
          B2E9D7708C2ADE32C300F2BC73089191E712D987615C6CC4B2DC609704E7D21B
          548EDC300B57C40705C59688E1115E54E56219083B65AA8B2BB3AA13BE77E0BC
          F96CA1DEC22F57EDD13338705D7AF1A1089C52EAC0311905706BE0EB1F02A4D3
          161BE9D273A4395BDF999025DBFD494587EC3D288299054467917188BBDEAF49
          E098F012BC1F88C005B371E632D482333AA770C2B33F96D7FB6631E8595EBE8A
          B633177DE776E1606086AAEFAE686778FA16CC5CFD6B00759730D7F8E7EBCF10
          B2ED683C29C7E002A49C464DC484793BCF5B2DB3BC39687E311F3C536BC18B76
          E88241CFA4D4C219CCCE891675ED5133FC702A49B168938DFEC4E9F3672FDDE1
          DF78F65E151C6597C02CDD538D6327CEFA9CBEC4348ADBA464C66A1C9B2D761C
          22104B3F5046A32662FC8CF536CB16985C8B5F6EC551EE0DC88223D1A5702A4E
          08DE28C60BA7FC2447087691A560E6CF834D8762956BCC825CD1EECFB3D6D95A
          ED381603BA7B4360EA929FADA8849857988F023E5DE940C8E6C3379158F2578B
          18B2D81C3163934514E66C32EA9E9FF8E95AEBE5737705BACF330ECF9B6F725D
          38FF4736CCDBC386B9C611C2394661795F6EBFE4316DB5F5723AD03864F21C7D
          A7B4E9CB0FF3703F8919BC692BECC9B41547C8545CFFEB8FFA7F3AE67DA7FB38
          05994A41EF27A9DD0F5A1474401D0A7AAFF931BE961831DAEAA87F8CA833FA6B
          E9A3F1D1BE0B01E00FE5DFFF3B6B594FDCD6290000000049454E44AE426082}
        FileName = 'Images\Actions\Refresh_32x32.png'
        Keywords = 'Actions;Refresh'
      end
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F40000001B744558745469746C65004164643B506C75733B426172733B526962
          626F6E3B9506332F000008F449444154785E8D570B7055C5F9FFED9E739FB909
          E40121E4C13320963A80888DA47F4450B41D915AA0481D6B6BA7B5159D3E9CFE
          517CD4D13AB66594DA426BB55AB1A530814A5B194B41D1227104E4116C54484C
          02216F929BFB3CE79E7376BB67F79CE44A8769BF99DFFDF6EEDDB3BFEFFB7DDF
          6E4EC8435B1B410801A104D4F5181D43780200EEBC87076E9D437069C3E30DC7
          38631C5C407AAE3CE30C8E333AEF30079BEE5E04DD5D70CFEA05504CAE237963
          65E541CD1F928B906F5C000FAF9AE77A896EC3E1DCFB490C140019D4D3AF344A
          0EDD9F24F2237F9C4F0C2A40D63FBFEF8A6861D10AA20596504A2294D02B00C0
          B6ED53E0C8E672C69BC9A1C1DD9BEEBBB90900AB086B0C003F9FB5392E322F32
          E80E93A33C620E0E820A45EE427BF0A5B7BF142A2878626C41B8765A55312AC7
          C510D435948E09CB2517868D39A665E35C5FB2AEB5B368C323DB0E9FC924861F
          DB78F7F53B013895119D75666DC5E4ABE0F1522EEBE4FFA07C454892D3754FEF
          9AF2C81FDF3B585359BE63F9C2DADAD54B2FC3ECDAF188C44220111DE7333901
          1324AC212CE63E3BA31C6BAE9F85158B66D64E9D5CF587F52F1D3AB876FDE6E9
          00F4AA884EABA33AE123E5E0172BA03E26467499F5F77FF5FAE2C231C53BEAE7
          5417CF9A3A0E71D34647C28046FC1E21C271F95CDA71C038306C0A2F06D17000
          5FFCFC7434B7F65FF54F90C6BB7EB2FDF6DF6D58F30600ABA62080F694C5D9A8
          020C9CAB8D2A3DF275CFFCEDBAB12565AFDD7CEDCCE29AAA12740C1B4898B68C
          5C042CC15CCF213C94E7A35D3F6C38681DCCA2AAB218B72CBEACB8BC72D2EE3B
          1EDBB60440C06FDE91001C47915729727AE78F5F9E1E1B5BB24D6410A4A1207A
          53A6DC5C40914BEF13FAC17881F8417145D09530C10241AC587C59A0AC7CE22B
          CBD76D9C01409F1C0B505F796A598ECCCC6FB8B1E3AB5FFCBF79934A1D5DC390
          9193646E90CC7149946F69EDC3A6CDFBF0C307B6E3FE07B7E3D92DFF406B5B9F
          DCC776B85C6F7BC15D48E760100D8BAE9A565231F58AE7010405E86F7FB0542A
          41932243511799FD379F7A75D5B892C2BA4A21DD60C6F636637098DAD0F7DB76
          3462E1F4623CF8952BB161CD955834B30C0DBBDE0330AA0473A45252B1BE540E
          1515C5282F1B73F59A07B6AE02A0FBA5D0B38635927D20147BF49AB935E88C1B
          EA5832B58C7001E19977309329034B16D4624A751902411DE98C813F37B6A9CC
          051863AA648E07316EBB9045FDBC4938DB39B001C02E015B80D39D4FAC90D9AF
          FAFF9717971517D406A311983906CB7BD8F260BBB0D59C6BB158087A50934405
          D130745DF308D9C85A4B2926BFE72C061209A37CDC98695FF8EEB3D702D00488
          0E6534C702CB26579608B94C494601700210AAB2A7E0A0848C5E611C5ED713B9
          2610A01E1983707014B1AF84FCDE3D640AD54AD1DC3CE606006F08D87E2D28E3
          FA021A0CA23F6E898C34689C836A045D670770F06033BABB872EBEF82521DC75
          946260308DC79FDC09DF264C28467DFD67306E4289EA1F9B216D31140AB54083
          F33D0530A2000399C902010C244C24321A4A8A748483147BF61CC5B23995987A
          CD2468BA065DA30808CF38918DC641609B0E7E7DFF4D48650C2910A540477702
          BFDFFB3EEEB873A92C692A6B833B0C05B10038D56AF34B405C70C68A723691B5
          1363F40EE6100E6948A74D2C9C3B05D595A508057559062200019B01E04CDD23
          134BC0F22EA4DA2913B065F77124330E12691B8CA9D3643AF291429F97421971
          9B2769E4E426B6B7D8301CD570D110344DF38E21BC9A3209C605F28E29938008
          3E0000B2F9DCBDFDDF52394B7E1F3986F0CCB659226BE44A1D682A4B4EC12950
          5010C6997383A8A92A050154F600D2860D65EAFA2D8804DC215451084E7CDC8D
          68414836A24FCE094336CB0497938467BAFFF2E058B9D366DAACA3D1286CB913
          0301455DFD6C6CF9EB096C6A382CEBAF09E89A86171EBAC54F02B1888E5B7FB4
          1D94C22F910C7CE9757391356DF9F6C3993A5556C680651AAD0064017D0558CE
          CC1E4DC5537585E12818E1B0E5F60EA2454558B97A3174AAEAEEDA8B2FECC170
          228B582CACB2E69035FEFA376E829163E05C653D94B290CBD9925C7CCA6C5343
          49E4B2C963009C4F05904DF4EFEFECE8BB77D6C471702C064EA894326D3AC8E4
          32D04080D11854B339AEACA38DD73D682065A82E63720D6430FE5A4DA738D7D1
          874CBCEF801F00F54AE01C7FF5D1B77B7A2E7C32D4979033B2C16CE6351B8725
          BC7FABB9A6530A47122BD90589FA9D3158729DFFAC24972C83FDC3E8EE1E683F
          F9DA930746AEE2ABEF78817BF5B0D2F1EEA7DA3F6A03A8CACA71617B70A03CE3
          8846C368E9BC80B1B1104A0A433879A60791481896ED28E2FCF56E120E97CAB5
          7FD48E647FC746008617007436F2A606EBE4EE871B026BB77CABABAD67FEF8EA
          09F23E00A1A0840302C45B39FFEACBF18B8623F8E9D643702D1C09A26EE16C64
          0C47F60207469A8E73F5DCF9F61EF476F59DFC60CF130D004CBF09A9FBC0BBE7
          53DCAB8939D871ECDE96532D4389E1041854296C019677CEB5C2186E5C5E8F95
          B72DC1CAB54B70D32DF5704251E4A4ECFE5F40E9A592897812679A5AE27D67DE
          B90F404665AF8CCCBBED37D8FCF3DBE15A5D554C07109EB1F4FE65A5D597FF69
          E6FC5981A29222990A910A788D887C53133CEFAD86E5BD66272F24F0E1D166AB
          BFEDC4D75ADEFAE5EB00D202F6BC35CFF163DBBF0DCA18C0A1E0AB707AFFC67D
          FDEDA7BEDA74A869B8E76C6FFE8B8602870097F06F42FF1AF65502077A3A7A71
          E29DA6446FEBB13B05F95E3FFB773B539C7901EB7EE43E3C79B22D079EF9FBC4
          392B6FB0CDEC7362A33993674D86AB06710908C77F9AAF1047623089F6E6760C
          F5F636F59F3EF09DEE537F69F6C82D5F1C9F97BA033916683C97E2F941749DD8
          F9AFA65DDFBBA1EBE3E3EB8EBF75F4EC91FD87F1C987ED880FC4918AA7C1D55B
          B01827111747ACADB90D47F61FC5F1370F9F3BFFD1FBF789679709F2534A7645
          7E48707CEAFF02D7939112A820AEA98E11008E7F5C5ADEF8D92B0076D67CEEAE
          05F19E4937EAA1583D40C2540FCD90E5B1CDD300376C23792833D8BEF7DCE197
          0E03C8E61D37C727271E992F3C99FDE5CDB8947DB0EB9EFCFF0D3581401E3439
          AF8C79B0F2E07880E0E097D81F04FF9B913C4FA5F7A18CE78149EFCFFF17FB37
          66AFE935F6829A2E0000000049454E44AE426082}
        FileName = 'Images\Actions\Add_32x32.png'
        Keywords = 'Actions;Add'
      end
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F40000001A744558745469746C650044656C6574653B52656D6F76653B3B4D69
          6E757328FAA3340000083849444154785E9556796C54C71DFEE6BDB7DE65BDD8
          D81C7158AF0D1606A3D0684343128C134A20D036A257C8A1B48A508E366D093D
          FE292D4DDAA8A91455A8416A8994849624B4341120885A44A34048CB95186A07
          DB71081858DF67ECF5DEFB8E99CE9B37B3F62A426D46FBE99B997D6FBEDF3533
          8FFCF2F53320848068049ACB98EA83330100775EE2E7DF8A125CBFE137FB5B18
          A50C8C4330F398320AC7999A77A8839D4FAE86E13EF0BD075600AEB05C5AB142
          B8C45033A408C58DB9F4F4FDCB5D16E8CBD92E83310EC54C4C61E7DE33820D39
          867A9010C9AEB0BF20AC71906DAFBC73737066D93788EE5BAB69648646B49B01
          C0B6ED7630644D33F76E7262FCF0CEAD1BDB00D0EA804101B0DEAC2D5558617D
          A56B389449E1222394B80BFD177BFEF54D7F69E973B34A03F50BAB2B109E1B82
          CFD031A73C00B77D3A998BE62D07FD23C99557FACAB63FB3AFF9722631F9EC8E
          27EF3900C089CC30684FC6A645D1A0CCF34C76446898F717AA3D716DCBEF0F2E
          7CE6AF1F9CAC09CF7BF3DE558BEAEF5BD7809BEAE76046C80F3DA06330630A90
          802EE696D5CFC5A67B96E2EBAB17D72F5C10FECBB63DA74F3EBC6DD72200464D
          D0D06A833ECF4D998ACF46807364867848FFC91F8FAE099557BCD9188D5434D4
          CD4122EFA02F91834E086465824893B30E0365408283520B33027E7CE5CE45B8
          78656CC54990338FFDF68DEFFC69FB43C701580B4A7DB89AB2189D8A002D1448
          8D14DFF2C2DFEF2EAF9CF38F7B572FAE88F090F74DE691CCDBE2196EB0007559
          08C2633655F5899C8DD8780EE1F02C6C5CD3507143B8F6F023CFEE5B0BC0A78A
          B76080E3781D191E6DF3AF5F5B149A55B9EFAB772E2AD10325184B9962710E4F
          5CB01254C648439451CC13184A98A0BE126CFCD212DF9C1BE6EFFDDA961D8B01
          1875219FE648030CCB728467AAE066CD8BFCB96979ED6C6AE848E52C68440361
          CC3B2308138107672A99C9F00912D1F00C52519A489B280BE8B86B455D653A63
          BE02601D077DF9A7EBC42B7A43D38378745D83107FFCF9430F846F9CFBA32F46
          6BB8E716982A18415EA36AEC8ACA143046544A0A69A28E180B83527907E17933
          313094A8BEB1E1AEAE8E53873A01500E66647356C17B9F3FF4AB3B6EA9C1403C
          274408F5FE21B248A9DC989A7A83113011050E4A5C96E1A75ECA1C09DE8F8D65
          D1B8BC163D7D63DB011CE4B045043AFFFD8610BFFF67AFAD8D44AAB62E59321F
          89AC0D2ABDA712CC0595DE8B3915663556F5205808DB72CE7661339485FC181E
          49549647A2EF5F3E77F42A006AA893CEA4BE0D0BC295A2E86C8741F31C04D138
          84D7A20EA425624E86411AE0B2DC05CA38BE8E8A84180F4E98A8AB9E8D8F3BCB
          D70338CE611B72158D32E336BDA404A3710BA5411DBA5B783AC140CF184E9EEC
          C4E0E0043E4FABAAAA4053D34D985B552922E0D814698B626630006825B702D0
          395088000559427D3E8C25F24864745496190894683872E43C3644C3A86BAC85
          6EE830744D1CC33A67B74F340D1A0711AB10110D3EC4B58149BC7AF41C363FBA
          1E79932295B5C11C8AD2900F4CD3EBA501444580304ACB4C9B885CF13E86C74D
          04FC3AD2E93C56DDB21091F06CF84B0CB91D49D1E5C124D3690752FDC22AEC3A
          D48264C641226D83522AD29077442DCD54BA1ABC461C87229933C522B67C3897
          73844628E887AEEBB2A020734A0528E310F3B20805C08DF7C16DA645E1AEADFE
          4B9996184B030A29806DD3443667CE76A07B5E320DFC87D2D2002EF78EA38617
          8F3059795E8C6967867758B57E3288107FD776A60C6384229BA55CCB492A5D43
          BECB1CCBBC944FE7576AC1206C787B8E40C3CAA66578F1AD56ECF8DBFBF83C2D
          C8A3B6664D14D9BC0D873ADE16268095C9C1CAE7AEA8834845809AF9ECF9543C
          B5726620084A186C112307C1B2326C7AF06E18DA54DEDD2E3888F25C794F24CB
          FD3F91B290356D216E83096F53134998D9640B00A7C8806C62F4585FF7C8534B
          E7CF85635130A28950A6F30E326606BA54248234AFFF991428A6C23D2A8DA12E
          1C06DDD0D0DB3D824C7CE48432A0F0D5C351DAB879774B7455B42E342B040678
          B5A003C4654816F34A5D911402517D0F5027A867592A9E44CBA9D6D8D9579FB8
          1DC0248769DCFEC86EF6C1EB8F5300563A3EF87CEC62F9CBCB1ABF202C660088
          CD41943813FBC621AC485C4189A270643309C0D009621763488E76EF00909377
          010C4A55F0605D38FCF47EDFC32F7E77E0DAD0ADF32255E23C70153557904308
          32614CB1012AF402D27359748C79EFF5C786303C3072A1E3C873FB01E455116A
          94529CED4F319993FC7877CB535DED5D1389C9042820F6BACD212F19C954DE74
          B2CFA6B39C671E53CE091EFACB6D5DF191CBA7B602C828EF5D684C5E2E67FB52
          220D574FEFEE18EFBFF8C447673BACF8A79360901F18D38D703828958680B312
          96CFA8CF335024C626D171B6DD1AEBBEF0839E73FBDA94F7CB1F7A890903A8CA
          17878AC2A5633BDE198DB57FBBED74DBE450CF30DC46A9122A7C6808A8939016
          5FC962C1A1EE617C78AA2D317CA56573D77B7F785B79CF9D65547D1533D95190
          E1C9769D78E19FF3A39BD6DBF9EC4B7CA1E882A50B50565906E20AC8222CC6D4
          E75A623C8958670C13C3C36DA3974E7C7FB0FDAD4E296EA98253BA9AAA52709C
          E94DB1E9460C7C78E0A3B6833F5E3FF049EB96D6F7CEF79C3BD68CAB1FC7101F
          8B23154FABFB5F6CAFF8E824AE755EC3B963E7D1FA6E736FFFC5FF6CE5EF6EE0
          E2ED00D24AFC34D710599F8A40D189268C688C840800476D97AEE3BFDB0BE040
          CD1D8FDD161FAAFDB2E10F350124A019FEC5223D76FE12C072762E793A331E7B
          BBB7794F3380ECB4EDE6287122C5A43EC8B2FB76E17AADE3E00F892A567958F9
          14E458DDA654C29A0647025C835D677D10FC7F8D4C634DB2824AAB02950CC1FF
          A3FD17DD109E5C76A0AE460000000049454E44AE426082}
        FileName = 'Images\Actions\Remove_32x32.png'
        Keywords = 'Actions;Remove'
      end>
  end
  object qryFastApi: TOneDataSet
    OnNewRecord = qryFastApiNewRecord
    CachedUpdates = True
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvUpdateMode, uvCheckRequired]
    UpdateOptions.UpdateMode = upWhereAll
    UpdateOptions.CheckRequired = False
    UpdateOptions.UpdateTableName = 'Dict_ModuleBase'
    UpdateOptions.KeyFields = 'FModuleID'
    SQL.Strings = (
      'select'
      '*'
      'from onefast_api'
      'order by FOrderNumber asc')
    DataInfo.CreateID = '4ed2e60909114644becf5897edb63348'
    DataInfo.MetaInfoKind = mkNone
    DataInfo.TableName = 'onefast_api'
    DataInfo.PrimaryKey = 'FApiID'
    DataInfo.OpenMode = openData
    DataInfo.SaveMode = saveData
    DataInfo.DataReturnMode = dataStream
    DataInfo.PageSize = -1
    DataInfo.PageIndex = -1
    DataInfo.PageCount = 0
    DataInfo.PageTotal = 0
    DataInfo.AffectedMaxCount = -1
    DataInfo.AffectedMustCount = 0
    DataInfo.RowsAffected = 0
    DataInfo.AsynMode = False
    DataInfo.IsReturnData = False
    DataInfo.TranSpanSec = 0
    Params = <>
    MultiIndex = 0
    ActiveDesign = False
    ActiveDesignOpen = False
    Left = 144
    Top = 432
    object qryFastApiFApiID: TWideStringField
      FieldName = 'FApiID'
      Size = 32
    end
    object qryFastApiFPApiID: TWideStringField
      FieldName = 'FPApiID'
      Size = 32
    end
    object qryFastApiFApiCode: TWideStringField
      DisplayLabel = 'Api'#20195#30721
      FieldName = 'FApiCode'
      Size = 50
    end
    object qryFastApiFApiCaption: TWideStringField
      DisplayLabel = 'Api'#26631#31614
      FieldName = 'FApiCaption'
      Size = 50
    end
    object qryFastApiFOrderNumber: TIntegerField
      DisplayLabel = #24207#21495
      FieldName = 'FOrderNumber'
    end
    object qryFastApiFIsMenu: TBooleanField
      FieldName = 'FIsMenu'
    end
    object qryFastApiFIsEnabled: TBooleanField
      DisplayLabel = #21551#29992
      FieldName = 'FIsEnabled'
    end
    object qryFastApiFApiRole: TWideStringField
      DisplayLabel = #35282#33394#35775#38382
      FieldName = 'FApiRole'
      Size = 30
    end
    object qryFastApiFApiAuthor: TWideStringField
      DisplayLabel = #25480#26435#26041#24335
      FieldName = 'FApiAuthor'
      Size = 30
    end
  end
  object dsFastApi: TDataSource
    DataSet = qryFastApi
    Left = 224
    Top = 432
  end
  object dsData: TDataSource
    DataSet = qryData
    Left = 300
    Top = 48
  end
  object qryData: TOneDataSet
    AfterScroll = qryDataAfterScroll
    OnNewRecord = qryDataNewRecord
    CachedUpdates = True
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvUpdateMode, uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    SQL.Strings = (
      'select'
      '*'
      'from onefast_api_data'
      'where FApiID=:FApiID'
      'order by  FTreeCode asc ')
    DataInfo.MetaInfoKind = mkNone
    DataInfo.TableName = 'onefast_api_data'
    DataInfo.PrimaryKey = 'FDataID'
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
    Params = <
      item
        Name = 'FApiID'
      end>
    MultiIndex = 0
    ActiveDesign = False
    ActiveDesignOpen = False
    Left = 356
    Top = 48
    object qryDataFDataID: TWideStringField
      FieldName = 'FDataID'
      Origin = 'FDataID'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
      Size = 32
    end
    object qryDataFPDataID: TWideStringField
      FieldName = 'FPDataID'
      Size = 32
    end
    object qryDataFApiID: TWideStringField
      FieldName = 'FApiID'
      Size = 32
    end
    object qryDataFTreeCode: TWideStringField
      FieldName = 'FTreeCode'
      Size = 30
    end
    object qryDataFDataName: TWideStringField
      DisplayLabel = #25968#25454#38598#21517#31216
      FieldName = 'FDataName'
      Origin = 'FDataName'
      Size = 50
    end
    object qryDataFDataCaption: TWideStringField
      DisplayLabel = #25968#25454#38598#26631#31614
      FieldName = 'FDataCaption'
      Origin = 'FDataCaption'
      Size = 50
    end
    object qryDataFDataJsonName: TWideStringField
      FieldName = 'FDataJsonName'
      Size = 50
    end
    object qryDataFDataJsonType: TWideStringField
      FieldName = 'FDataJsonType'
    end
    object qryDataFDataZTCode: TWideStringField
      FieldName = 'FDataZTCode'
      Size = 50
    end
    object qryDataFDataTable: TWideStringField
      DisplayLabel = #34920#21517
      FieldName = 'FDataTable'
      Origin = 'FDataTable'
      Size = 50
    end
    object qryDataFDataStoreName: TWideStringField
      FieldName = 'FDataStoreName'
      Size = 100
    end
    object qryDataFDataPrimaryKey: TWideStringField
      DisplayLabel = #20027#38190
      FieldName = 'FDataPrimaryKey'
      Origin = 'FDataPrimaryKey'
      Size = 100
    end
    object qryDataFDataOpenMode: TWideStringField
      DisplayLabel = #25171#24320#25968#25454#38598#27169#24335
      FieldName = 'FDataOpenMode'
      Origin = 'FDataOpenMode'
    end
    object qryDataFDataPageSize: TIntegerField
      DisplayLabel = #20998#39029#22823#23567
      FieldName = 'FDataPageSize'
      Origin = 'FDataPageSize'
    end
    object qryDataFDataUpdateMode: TWideStringField
      DisplayLabel = #25552#20132#27169#24335
      FieldName = 'FDataUpdateMode'
      Origin = 'FDataUpdateMode'
    end
    object qryDataFDataSQL: TMemoField
      DisplayLabel = 'SQL'#35821#21477
      FieldName = 'FDataSQL'
      Origin = 'FDataSQL'
      BlobType = ftMemo
    end
    object qryDataFMinAffected: TIntegerField
      FieldName = 'FMinAffected'
    end
    object qryDataFMaxAffected: TIntegerField
      FieldName = 'FMaxAffected'
    end
  end
  object dsField: TDataSource
    DataSet = qryField
    Left = 540
    Top = 48
  end
  object qryField: TOneDataSet
    OnNewRecord = qryFieldNewRecord
    CachedUpdates = True
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvUpdateMode, uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    SQL.Strings = (
      'select'
      '*'
      'from onefast_api_field'
      'where FApiID=:FApiID'
      'order by FDataID asc , FOrderNumber asc')
    DataInfo.MetaInfoKind = mkNone
    DataInfo.TableName = 'onefast_api_field'
    DataInfo.PrimaryKey = 'FFieldID'
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
    Params = <
      item
        Name = 'FApiID'
      end>
    MultiIndex = 0
    ActiveDesign = False
    ActiveDesignOpen = False
    Left = 572
    Top = 48
    object qryFieldFFieldID: TWideStringField
      FieldName = 'FFieldID'
      Origin = 'FFieldID'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
      Size = 32
    end
    object qryFieldFDataID: TWideStringField
      FieldName = 'FDataID'
      Origin = 'FDataID'
      Size = 32
    end
    object qryFieldFApiID: TWideStringField
      FieldName = 'FApiID'
      Size = 32
    end
    object qryFieldFOrderNumber: TIntegerField
      DisplayLabel = #24207#21495
      FieldName = 'FOrderNumber'
      Origin = 'FOrderNumber'
    end
    object qryFieldFFieldName: TWideStringField
      DisplayLabel = #23383#27573#21517#31216
      FieldName = 'FFieldName'
      Origin = 'FFieldName'
      Size = 50
    end
    object qryFieldFFieldCaption: TWideStringField
      DisplayLabel = #23383#27573#26631#31614
      FieldName = 'FFieldCaption'
      Origin = 'FFieldCaption'
      Size = 50
    end
    object qryFieldFFieldJsonName: TWideStringField
      DisplayLabel = 'JSON'#21517#31216
      FieldName = 'FFieldJsonName'
      Size = 50
    end
    object qryFieldFFieldKind: TWideStringField
      DisplayLabel = #23383#27573#31867#22411
      FieldName = 'FFieldKind'
      Origin = 'FFieldKind'
    end
    object qryFieldFFieldDataType: TWideStringField
      DisplayLabel = #25968#25454#31867#22411
      FieldName = 'FFieldDataType'
      Origin = 'FFieldDataType'
      Size = 30
    end
    object qryFieldFFieldSize: TIntegerField
      DisplayLabel = #23383#27573#38271#24230
      FieldName = 'FFieldSize'
      Origin = 'FFieldSize'
    end
    object qryFieldFFieldPrecision: TIntegerField
      DisplayLabel = #23383#27573#31934#24230
      FieldName = 'FFieldPrecision'
      Origin = 'FFieldPrecision'
    end
    object qryFieldFFieldFormat: TWideStringField
      DisplayLabel = #36755#20986#26684#24335
      FieldName = 'FFieldFormat'
    end
    object qryFieldFFieldProvidFlagKey: TBooleanField
      DisplayLabel = #21442#19982#20027#38190
      FieldName = 'FFieldProvidFlagKey'
      Origin = 'FFieldProvidFlagKey'
    end
    object qryFieldFFieldProvidFlagUpdate: TBooleanField
      DisplayLabel = #21442#19982#26356#26032
      FieldName = 'FFieldProvidFlagUpdate'
      Origin = 'FFieldProvidFlagUpdate'
    end
    object qryFieldFFieldProvidFlagWhere: TBooleanField
      DisplayLabel = #21442#19982#26465#20214
      FieldName = 'FFieldProvidFlagWhere'
      Origin = 'FFieldProvidFlagWhere'
    end
    object qryFieldFFieldDefaultValueType: TWideStringField
      DisplayLabel = #40664#35748#20540#31867#22411
      FieldName = 'FFieldDefaultValueType'
      Origin = 'FFieldDefaultValueType'
      Size = 30
    end
    object qryFieldFFieldDefaultValue: TWideStringField
      DisplayLabel = #40664#35748#20540
      FieldName = 'FFieldDefaultValue'
      Origin = 'FFieldDefaultValue'
      Size = 30
    end
    object qryFieldFFieldShowPass: TBooleanField
      DisplayLabel = #26143#21495#26174#31034
      FieldName = 'FFieldShowPass'
    end
    object qryFieldFFieldCheckEmpty: TBooleanField
      DisplayLabel = #26816#31354
      FieldName = 'FFieldCheckEmpty'
    end
  end
  object qryFilter: TOneDataSet
    OnNewRecord = qryFilterNewRecord
    CachedUpdates = True
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvUpdateMode, uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    SQL.Strings = (
      'select'
      '*'
      'from onefast_api_filter'
      'where FApiID=:FApiID'
      'order by FOrderNumber asc')
    DataInfo.MetaInfoKind = mkNone
    DataInfo.TableName = 'onefast_api_filter'
    DataInfo.PrimaryKey = 'FFilterID'
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
    Params = <
      item
        Name = 'FApiID'
      end>
    MultiIndex = 0
    ActiveDesign = False
    ActiveDesignOpen = False
    Left = 636
    Top = 56
    object qryFilterFFilterID: TWideStringField
      FieldName = 'FFilterID'
      Origin = 'FFilterID'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
      Size = 32
    end
    object qryFilterFDataID: TWideStringField
      FieldName = 'FDataID'
      Origin = 'FDataID'
      Size = 32
    end
    object qryFilterFApiID: TWideStringField
      FieldName = 'FApiID'
      Size = 32
    end
    object qryFilterFOrderNumber: TIntegerField
      DisplayLabel = #24207#21495
      FieldName = 'FOrderNumber'
      Origin = 'FOrderNumber'
    end
    object qryFilterFFilterName: TWideStringField
      DisplayLabel = #26465#20214#21517#31216
      FieldName = 'FFilterName'
      Size = 50
    end
    object qryFilterFFilterCaption: TWideStringField
      DisplayLabel = #26465#20214#26631#31614
      FieldName = 'FFilterCaption'
      Size = 50
    end
    object qryFilterFFilterJsonName: TWideStringField
      DisplayLabel = 'JSON'#21517#31216
      FieldName = 'FFilterJsonName'
      Size = 50
    end
    object qryFilterFFilterFieldMode: TWideStringField
      DisplayLabel = #36807#28388#27169#24335
      FieldName = 'FFilterFieldMode'
    end
    object qryFilterFFilterField: TWideStringField
      DisplayLabel = #26465#20214#23383#27573
      FieldName = 'FFilterField'
      Size = 50
    end
    object qryFilterFPFilterField: TWideStringField
      DisplayLabel = #29238#32423#20851#32852#23383#27573
      FieldName = 'FPFilterField'
      Size = 50
    end
    object qryFilterFFilterFieldItems: TWideStringField
      FieldName = 'FFilterFieldItems'
      Size = 500
    end
    object qryFilterFFilterDataType: TWideStringField
      DisplayLabel = #25968#25454#31867#22411
      FieldName = 'FFilterDataType'
    end
    object qryFilterFFilterFormat: TWideStringField
      DisplayLabel = #25968#25454#26684#24335
      FieldName = 'FFilterFormat'
    end
    object qryFilterFFilterExpression: TWideStringField
      DisplayLabel = #26465#20214#31526#21495
      FieldName = 'FFilterExpression'
      Size = 10
    end
    object qryFilterFFilterbMust: TBooleanField
      DisplayLabel = #24517#38656#26465#20214
      FieldName = 'FFilterbMust'
    end
    object qryFilterFFilterbValue: TBooleanField
      DisplayLabel = #24517#38656#26377#20540
      FieldName = 'FFilterbValue'
    end
    object qryFilterFFilterDefaultType: TWideStringField
      DisplayLabel = #21462#20540#31867#22411
      FieldName = 'FFilterDefaultType'
    end
    object qryFilterFFilterDefaultValue: TWideStringField
      DisplayLabel = #21462#20540#31867#22411#20540
      FieldName = 'FFilterDefaultValue'
      Size = 50
    end
    object qryFilterFbOutParam: TBooleanField
      DisplayLabel = #36755#20986#21442#25968
      FieldName = 'FbOutParam'
    end
    object qryFilterFOutParamTag: TWideStringField
      DisplayLabel = #36755#20986#21442#25968#26631#35782
      FieldName = 'FOutParamTag'
      Size = 30
    end
  end
  object dsFilter: TDataSource
    DataSet = qryFilter
    Left = 684
    Top = 56
  end
  object qryFieldGet: TOneDataSet
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
    DataInfo.PageSize = 1
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
    Left = 264
    Top = 347
  end
end

object frmMain: TfrmMain
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'OneDelphi-'#20013#38388#20214
  ClientHeight = 591
  ClientWidth = 882
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poOwnerFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  TextHeight = 20
  object pageMain: TPageControl
    Left = 0
    Top = 75
    Width = 882
    Height = 516
    ActivePage = tabServerReamk
    Align = alClient
    TabOrder = 0
    ExplicitWidth = 878
    ExplicitHeight = 515
    object tabServerReamk: TTabSheet
      Caption = #20013#38388#20214#35828#26126
      object Memo1: TMemo
        Left = 0
        Top = 0
        Width = 874
        Height = 481
        Align = alClient
        Lines.Strings = (
          'OneDelphi:'
          #19968#20010'MVC'#21450#20256#32479'DataSet'#26694#26550
          ''
          #36890#35759':Mormot2'#30340'HTTP'#36890#35759
          ''
          'MVC'#30456#20851'DEMO'#22312'DemoController.pas'
          ''
          #20808#25972#26680#24515#65292#22312#24847#30028#38754#30340#35831#19981#35201#30475'.'
          ''
          '                                                 '#21483#20861'(FLM)'#20986#21697
          '                                                 QQ:378464060')
        TabOrder = 0
        ExplicitWidth = 870
        ExplicitHeight = 480
      end
    end
    object TabSheet1: TTabSheet
      Caption = #36335#30001#29366#24577
      ImageIndex = 6
      object GroupBox2: TGroupBox
        Left = 0
        Top = 0
        Width = 874
        Height = 249
        Align = alTop
        Caption = #24050#27491#30830#27880#20876#36335#30001#29366#24577#26597#30475
        TabOrder = 0
        object dbGridRouter: TDBGrid
          Left = 2
          Top = 54
          Width = 870
          Height = 193
          Align = alClient
          DataSource = dsRouter
          TabOrder = 0
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -15
          TitleFont.Name = 'Segoe UI'
          TitleFont.Style = []
          Columns = <
            item
              Expanded = False
              FieldName = 'FOrderNumber'
              Title.Caption = #24207#21495
              Width = 59
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'FRootName'
              Title.Caption = #36335#30001#36335#24452
              Width = 180
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'FClassName'
              Title.Caption = #27880#20876#31867#21517
              Width = 171
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'FPoolMaxCount'
              Title.Caption = #26368#22823#36816#34892#24037#20316#25968#37327
              Width = 154
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'FWorkingCount'
              Title.Caption = #27491#22312#24037#20316#25968#37327
              Width = 152
              Visible = True
            end>
        end
        object Panel3: TPanel
          Left = 2
          Top = 22
          Width = 870
          Height = 32
          Align = alTop
          TabOrder = 1
          object tbRouterSelect: TButton
            Left = 2
            Top = 1
            Width = 135
            Height = 25
            Caption = #26597#30475#29366#24577
            TabOrder = 0
            OnClick = tbRouterSelectClick
          end
        end
      end
      object GroupBox6: TGroupBox
        Left = 0
        Top = 249
        Width = 874
        Height = 232
        Align = alClient
        Caption = #38169#35823#20449#24687
        Ctl3D = True
        ParentCtl3D = False
        TabOrder = 1
        object edRouterErrMsg: TMemo
          Left = 2
          Top = 22
          Width = 870
          Height = 208
          Align = alClient
          Lines.Strings = (
            #27880#20876#36335#30001#26080#38169#35823#20449#24687)
          ScrollBars = ssBoth
          TabOrder = 0
        end
      end
    end
    object tabHTTPServer: TTabSheet
      Caption = #26381#21153#37197#32622
      ImageIndex = 4
      object groupHTTP: TGroupBox
        Left = 0
        Top = 0
        Width = 874
        Height = 217
        Align = alTop
        Caption = 'HTTP'#37197#32622'-'#20445#23384#37197#32622#22914#38656#29983#25928','#35831#37325#26032#21551#21160#20013#38388#23618
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentBackground = False
        ParentColor = False
        ParentFont = False
        TabOrder = 0
        object Label1: TLabel
          Left = 3
          Top = 56
          Width = 54
          Height = 15
          Caption = 'HTTP'#31471#21475
        end
        object Label2: TLabel
          Left = 233
          Top = 56
          Width = 65
          Height = 15
          Caption = #24037#20316#32447#31243#25968
        end
        object Label3: TLabel
          Left = 469
          Top = 56
          Width = 52
          Height = 15
          Caption = #38431#21015#22823#23567
        end
        object lbConnectSecretkey: TLabel
          Left = 3
          Top = 85
          Width = 52
          Height = 15
          Caption = #36830#25509#23494#38053
        end
        object Label12: TLabel
          Left = 443
          Top = 85
          Width = 103
          Height = 15
          Caption = 'token'#22833#25928#38388#38548'('#31186')'
        end
        object Label13: TLabel
          Left = 469
          Top = 22
          Width = 52
          Height = 15
          Caption = #36229#31649#23494#30721
        end
        object lbCertificateFile: TLabel
          Left = 3
          Top = 150
          Width = 72
          Height = 15
          Caption = 'CertificateFile'
        end
        object Label15: TLabel
          Left = 419
          Top = 150
          Width = 73
          Height = 15
          Caption = 'PrivateKeyFile'
        end
        object Label16: TLabel
          Left = 3
          Top = 179
          Width = 105
          Height = 15
          Caption = 'PrivateKeyPassword'
        end
        object Label17: TLabel
          Left = 419
          Top = 179
          Width = 93
          Height = 15
          Caption = 'CACertificatesFile'
        end
        object Label14: TLabel
          Left = 115
          Top = 121
          Width = 60
          Height = 15
          Caption = 'HTTPS'#31471#21475
        end
        object tbStart: TButton
          Left = 3
          Top = 18
          Width = 75
          Height = 25
          Caption = #21551#21160#26381#21153
          TabOrder = 0
          OnClick = tbStartClick
        end
        object tbStop: TButton
          Left = 87
          Top = 18
          Width = 75
          Height = 25
          Caption = #20572#27490#26381#21153
          TabOrder = 1
          OnClick = tbStopClick
        end
        object tbRequest: TButton
          Left = 173
          Top = 18
          Width = 75
          Height = 25
          Caption = #20572#27490#35831#27714
          TabOrder = 2
          OnClick = tbRequestClick
        end
        object edHTTPPort: TEdit
          Left = 87
          Top = 53
          Width = 121
          Height = 23
          NumbersOnly = True
          TabOrder = 3
          Text = '9090'
        end
        object edHTTPPool: TEdit
          Left = 310
          Top = 53
          Width = 121
          Height = 23
          NumbersOnly = True
          TabOrder = 4
          Text = '100'
        end
        object edHTTPQueue: TEdit
          Left = 552
          Top = 53
          Width = 121
          Height = 23
          NumbersOnly = True
          TabOrder = 5
          Text = '1000'
        end
        object edHTTPAutoStart: TCheckBox
          Left = 697
          Top = 56
          Width = 97
          Height = 17
          Caption = #33258#21551#21160#26381#21153
          TabOrder = 6
        end
        object tbSaveHTTPSet: TButton
          Left = 262
          Top = 18
          Width = 169
          Height = 25
          Caption = #20445#23384#35774#32622
          TabOrder = 7
          OnClick = tbSaveHTTPSetClick
        end
        object edConnectSecretkey: TEdit
          Left = 87
          Top = 82
          Width = 290
          Height = 23
          TabOrder = 8
        end
        object tbBuildConnectSecretkey: TButton
          Left = 377
          Top = 81
          Width = 54
          Height = 25
          Caption = #29983#25104
          TabOrder = 9
          OnClick = tbBuildConnectSecretkeyClick
        end
        object edTokenOutSec: TEdit
          Left = 552
          Top = 82
          Width = 121
          Height = 23
          NumbersOnly = True
          TabOrder = 10
          Text = '0'
        end
        object edSuperAdminPass: TEdit
          Left = 552
          Top = 19
          Width = 242
          Height = 23
          PasswordChar = '*'
          TabOrder = 11
        end
        object edHttps: TCheckBox
          Left = 3
          Top = 119
          Width = 89
          Height = 17
          Caption = 'HTTPS'#25903#25345
          TabOrder = 12
        end
        object edCertificateFile: TEdit
          Left = 114
          Top = 147
          Width = 263
          Height = 23
          TabOrder = 13
        end
        object edPrivateKeyFile: TEdit
          Left = 521
          Top = 147
          Width = 273
          Height = 23
          TabOrder = 14
        end
        object edPrivateKeyPassword: TEdit
          Left = 114
          Top = 176
          Width = 263
          Height = 23
          TabOrder = 15
        end
        object edCACertificatesFile: TEdit
          Left = 521
          Top = 176
          Width = 273
          Height = 23
          TabOrder = 16
        end
        object edHTTPSPort: TEdit
          Left = 199
          Top = 118
          Width = 178
          Height = 23
          NumbersOnly = True
          TabOrder = 17
          Text = '9091'
        end
      end
      object groupWebSocket: TGroupBox
        Left = 0
        Top = 322
        Width = 874
        Height = 159
        Align = alClient
        Caption = #20854#23427#37197#32622
        TabOrder = 1
        object chWinTaskStart: TCheckBox
          Left = 15
          Top = 30
          Width = 121
          Height = 17
          Hint = #19981#29992#30331#38470#30028#38754#23601#21487#20197#21551#21160#65292#26080#30028#38754#65292#21482#33021#22312#36827#31243
          Caption = 'Win'#20219#21153#24320#26426#21551#21160
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          OnClick = chWinTaskStartClick
        end
        object chWinRegisterStart: TCheckBox
          Left = 173
          Top = 30
          Width = 121
          Height = 17
          Hint = #21040'Win'#30028#38754#25165#33258#21551#21160#65292#26377'UI'#30028#38754
          Caption = #27880#20876#34920#21551#21160
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
          OnClick = chWinRegisterStartClick
        end
      end
      object GroupBox1: TGroupBox
        Left = 0
        Top = 217
        Width = 874
        Height = 105
        Align = alTop
        Caption = 'WebSocket(WS)'#37197#32622
        TabOrder = 2
        object Label18: TLabel
          Left = 246
          Top = 35
          Width = 54
          Height = 20
          Caption = 'WS'#31471#21475
        end
        object Label19: TLabel
          Left = 10
          Top = 68
          Width = 80
          Height = 20
          Caption = #24037#20316#32447#31243#25968
        end
        object Label20: TLabel
          Left = 246
          Top = 68
          Width = 64
          Height = 20
          Caption = #38431#21015#22823#23567
        end
        object Label21: TLabel
          Left = 480
          Top = 68
          Width = 96
          Height = 20
          Caption = #24191#25773#28040#24687#27979#35797
        end
        object checkWS: TCheckBox
          Left = 15
          Top = 32
          Width = 138
          Height = 17
          Caption = 'WebSocket'#24320#21551
          TabOrder = 0
        end
        object edWSPort: TEdit
          Left = 329
          Top = 32
          Width = 117
          Height = 28
          NumbersOnly = True
          TabOrder = 1
          Text = '9099'
        end
        object edWsThreadPool: TEdit
          Left = 104
          Top = 65
          Width = 121
          Height = 28
          NumbersOnly = True
          TabOrder = 2
          Text = '100'
        end
        object edWsQueue: TEdit
          Left = 329
          Top = 65
          Width = 121
          Height = 28
          NumbersOnly = True
          TabOrder = 3
          Text = '1000'
        end
        object checkWsAutoStart: TCheckBox
          Left = 469
          Top = 32
          Width = 97
          Height = 17
          Caption = #33258#21551#21160#26381#21153
          TabOrder = 4
        end
        object edSendMsgTest: TEdit
          Left = 590
          Top = 65
          Width = 186
          Height = 28
          TabOrder = 5
        end
        object tbSendMsg: TButton
          Left = 784
          Top = 67
          Width = 75
          Height = 25
          Caption = #21457#36865#28040#24687
          TabOrder = 6
          OnClick = tbSendMsgClick
        end
      end
    end
    object tabZTManage: TTabSheet
      Caption = #36134#22871#31649#29702
      ImageIndex = 1
      object GroupBox3: TGroupBox
        Left = 0
        Top = 0
        Width = 874
        Height = 263
        Align = alTop
        Caption = #36134#22871#37197#32622'-'#33258#21160#21152#36733#36134#22871#26410#25171#21246#26102','#38656#25163#21160#37325#36733#25152#26377
        TabOrder = 0
        object Panel1: TPanel
          Left = 2
          Top = 22
          Width = 870
          Height = 40
          Align = alTop
          BorderStyle = bsSingle
          TabOrder = 0
          object tbZTAdd: TButton
            Left = 0
            Top = 8
            Width = 75
            Height = 25
            Caption = #22686#21152#36134#22871
            TabOrder = 0
            OnClick = tbZTAddClick
          end
          object tbZTDel: TButton
            Left = 81
            Top = 8
            Width = 75
            Height = 25
            Caption = #21024#38500#36134#22871
            TabOrder = 1
            OnClick = tbZTDelClick
          end
          object edZTAutoStart: TCheckBox
            Left = 262
            Top = 12
            Width = 97
            Height = 17
            Caption = #33258#21160#36816#34892#36134#22871
            TabOrder = 2
          end
          object tbZTSave: TButton
            Left = 365
            Top = 7
            Width = 75
            Height = 25
            Caption = #20445#23384#37197#32622
            TabOrder = 3
            OnClick = tbZTSaveClick
          end
          object tbZTOpen: TButton
            Left = 162
            Top = 8
            Width = 75
            Height = 25
            Caption = #21047#26032#25968#25454
            TabOrder = 4
            OnClick = tbZTOpenClick
          end
        end
        object dbGridZTSet: TDBGrid
          Left = 2
          Top = 62
          Width = 870
          Height = 199
          Align = alClient
          DataSource = dsZTSet
          TabOrder = 1
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -15
          TitleFont.Name = 'Segoe UI'
          TitleFont.Style = []
          OnDblClick = dbGridZTSetDblClick
          Columns = <
            item
              Expanded = False
              FieldName = 'FZTCode'
              Title.Caption = #36134#22871#20195#30721
              Width = 107
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'FZTCaption'
              Title.Caption = #36134#22871#26631#31614
              Width = 123
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'FInitPoolCount'
              Title.Caption = #27744#21021#22987#25968#37327
              Width = 92
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'FMaxPoolCount'
              Title.Caption = #27744#26368#22823#25968#37327
              Width = 92
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'FPhyDriver'
              Title.Caption = #25968#25454#24211#31867#22411
              Width = 115
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'FConnectionStr'
              Title.Caption = #36830#25509#23383#31526#20018
              Width = 200
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'FIsEnable'
              Title.Caption = #26159#21542#21487#29992
              Width = 60
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'FIsMain'
              Title.Caption = #20027#36134#22871
              Visible = True
            end>
        end
      end
      object GroupBox4: TGroupBox
        Left = 0
        Top = 263
        Width = 874
        Height = 218
        Align = alClient
        Caption = #36134#22871#36816#34892#24773#20917
        TabOrder = 1
        object pnZTPool: TPanel
          Left = 2
          Top = 22
          Width = 870
          Height = 32
          Align = alTop
          TabOrder = 0
          object tbGetZTPool: TButton
            Left = 2
            Top = 0
            Width = 111
            Height = 25
            Caption = #26597#30475#36816#34892#36134#22871
            TabOrder = 0
            OnClick = tbGetZTPoolClick
          end
          object tbZTMangeStarWork: TButton
            Left = 119
            Top = 0
            Width = 114
            Height = 25
            Caption = #37325#36733#25152#26377
            TabOrder = 1
            OnClick = tbZTMangeStarWorkClick
          end
          object tbZTNotStop: TButton
            Left = 239
            Top = 0
            Width = 98
            Height = 25
            Caption = #24320#21551#36816#34892#36134#22871
            TabOrder = 2
            OnClick = tbZTNotStopClick
          end
          object tbZTStop: TButton
            Left = 343
            Top = 0
            Width = 99
            Height = 25
            Caption = #20572#27490#36816#34892#36134#22871
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clRed
            Font.Height = -12
            Font.Name = 'Segoe UI'
            Font.Style = []
            ParentFont = False
            TabOrder = 3
            OnClick = tbZTStopClick
          end
        end
        object dbGridZTPool: TDBGrid
          Left = 2
          Top = 54
          Width = 870
          Height = 162
          Align = alClient
          DataSource = dsZTPool
          TabOrder = 1
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -15
          TitleFont.Name = 'Segoe UI'
          TitleFont.Style = []
          OnDblClick = dbGridZTSetDblClick
          Columns = <
            item
              Expanded = False
              FieldName = 'FZTCode'
              ReadOnly = True
              Title.Caption = #36134#22871#20195#30721
              Width = 100
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'FInitPoolCount'
              ReadOnly = True
              Title.Caption = #21021#22987#25968#37327#37197#32622
              Width = 134
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'FMaxPoolCount'
              ReadOnly = True
              Title.Caption = #26368#22823#25968#37327#37197#32622
              Width = 123
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'FPoolCreateCount'
              ReadOnly = True
              Title.Caption = #24050#21019#24314#25968#37327
              Width = 179
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'FPoolWorkCount'
              ReadOnly = True
              Title.Caption = #27491#22312#24037#20316#25968#37327
              Width = 173
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'FStop'
              ReadOnly = True
              Title.Caption = #20572#27490#36816#34892
              Width = 131
              Visible = True
            end>
        end
      end
    end
    object tabLog: TTabSheet
      Caption = #26085#35760#31649#29702
      ImageIndex = 2
      object pnLogSet: TPanel
        Left = 0
        Top = 0
        Width = 874
        Height = 84
        Align = alTop
        BorderStyle = bsSingle
        TabOrder = 0
        object Label10: TLabel
          Left = 19
          Top = 16
          Width = 265
          Height = 20
          Caption = #25351#23450#30446#24405'('#20026#31354#40664#35748'OnePlatform'#30446#24405#65289
        end
        object Label11: TLabel
          Left = 19
          Top = 45
          Width = 122
          Height = 20
          Caption = #20889#20837#38388#38548#26102#38388'('#31186')'
        end
        object edLogPath: TEdit
          Left = 240
          Top = 13
          Width = 361
          Height = 28
          TabOrder = 0
        end
        object edLogSec: TEdit
          Left = 147
          Top = 42
          Width = 178
          Height = 28
          TabOrder = 1
          Text = '10'
        end
        object edHTTPLog: TCheckBox
          Left = 345
          Top = 45
          Width = 129
          Height = 17
          Caption = #24320#21551'HTTP'#26085#35760
          TabOrder = 2
        end
        object edSQLLog: TCheckBox
          Left = 480
          Top = 45
          Width = 121
          Height = 17
          Caption = #24320#21551'SQL'#26085#35760
          TabOrder = 3
        end
        object tbSaveLogSet: TButton
          Left = 632
          Top = 12
          Width = 129
          Height = 25
          Caption = #20445#23384#37197#32622
          TabOrder = 4
          OnClick = tbSaveLogSetClick
        end
        object tbOpenLogFile: TButton
          Left = 632
          Top = 40
          Width = 129
          Height = 25
          Caption = #25171#24320#26085#35760#30446#24405
          TabOrder = 5
          OnClick = tbOpenLogFileClick
        end
      end
      object GroupBox5: TGroupBox
        Left = 0
        Top = 84
        Width = 874
        Height = 397
        Align = alClient
        Caption = #21363#26102#26085#35760#26597#30475#12298#27809#20107#35831#20851#38381','#22823#37327#20889#25968#25454'UI'#20250#21345#12299
        TabOrder = 1
        object Panel2: TPanel
          Left = 2
          Top = 22
          Width = 870
          Height = 42
          Align = alTop
          BorderStyle = bsSingle
          TabOrder = 0
          object tbOutLogStart: TButton
            Left = 17
            Top = 5
            Width = 129
            Height = 25
            Caption = #24320#21551#21363#26102#26085#35760
            TabOrder = 0
            OnClick = tbOutLogStartClick
          end
          object tbOutLogClear: TButton
            Left = 152
            Top = 5
            Width = 129
            Height = 25
            Caption = #28165#38500#21363#26102#26085#35760
            TabOrder = 1
            OnClick = tbOutLogClearClick
          end
        end
        object edLog: TMemo
          Left = 2
          Top = 64
          Width = 870
          Height = 331
          Align = alClient
          ScrollBars = ssBoth
          TabOrder = 1
        end
      end
    end
    object tabToken: TTabSheet
      Caption = 'Token'#20449#24687#31649#29702
      ImageIndex = 3
      object Panel4: TPanel
        Left = 0
        Top = 0
        Width = 874
        Height = 41
        Align = alTop
        TabOrder = 0
        object tbTokenSelect: TButton
          Left = 4
          Top = 8
          Width = 105
          Height = 25
          Caption = #26597#30475#30331#38470#20449#24687
          TabOrder = 0
          OnClick = tbTokenSelectClick
        end
        object tbTokenDelete: TButton
          Left = 120
          Top = 8
          Width = 105
          Height = 25
          Caption = #21024#38500#36873#20013
          TabOrder = 1
          OnClick = tbTokenDeleteClick
        end
        object tbTokenSave: TButton
          Left = 235
          Top = 8
          Width = 105
          Height = 25
          Caption = #20445#23384#30331#38470#20449#24687
          TabOrder = 2
          OnClick = tbTokenSaveClick
        end
      end
      object gridToken: TDBGrid
        Left = 0
        Top = 41
        Width = 874
        Height = 440
        Align = alClient
        DataSource = dsToken
        TabOrder = 1
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -15
        TitleFont.Name = 'Segoe UI'
        TitleFont.Style = []
        Columns = <
          item
            Expanded = False
            FieldName = 'FConnectionID'
            ReadOnly = True
            Title.Caption = #36830#25509'ID'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'FTokenID'
            ReadOnly = True
            Title.Caption = #20973#35777'ID'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'FPrivateKey'
            ReadOnly = True
            Title.Caption = ' '#20973#35777#31169#38053
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'FLoginIP'
            ReadOnly = True
            Title.Caption = #30331#38470'IP'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'FLoginMac'
            ReadOnly = True
            Title.Caption = 'MAC'#22320#22336
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'FLoginTime'
            ReadOnly = True
            Title.Caption = #30331#38470#26102#38388
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'FLoginPlatform'
            ReadOnly = True
            Title.Caption = #30331#38470#24179#21488
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'FLoginUserCode'
            ReadOnly = True
            Title.Caption = #30331#38470#20195#30721
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'FSysUserID'
            ReadOnly = True
            Title.Caption = #29992#25143'ID'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'FSysUserName'
            ReadOnly = True
            Title.Caption = #29992#25143#21517#31216
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'FZTCode'
            ReadOnly = True
            Title.Caption = #36134#22871
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'FPlatUserID'
            ReadOnly = True
            Title.Caption = #31199#25143'ID'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'FLastTime'
            ReadOnly = True
            Title.Caption = #26368#21518#26102#38388
            Width = 100
            Visible = True
          end>
      end
    end
    object tabVirtualFile: TTabSheet
      Caption = #34394#25311#30446#24405
      ImageIndex = 5
      object plVirtualFile: TPanel
        Left = 0
        Top = 0
        Width = 874
        Height = 41
        Align = alTop
        TabOrder = 0
        object tbFileAdd: TButton
          Left = 0
          Top = 8
          Width = 121
          Height = 25
          Caption = #26032#22686#34394#25311#30446#24405
          TabOrder = 0
          OnClick = tbFileAddClick
        end
        object tbFileDel: TButton
          Left = 127
          Top = 8
          Width = 117
          Height = 25
          Caption = #21024#38500#34394#25311#30446#24405
          TabOrder = 1
          OnClick = tbFileDelClick
        end
        object tbVirtualSave: TButton
          Left = 250
          Top = 8
          Width = 121
          Height = 25
          Caption = #20445#23384#37197#32622
          TabOrder = 2
          OnClick = tbVirtualSaveClick
        end
        object tbVirtualStarWork: TButton
          Left = 383
          Top = 8
          Width = 121
          Height = 25
          Caption = #37325#26032#21152#36733
          TabOrder = 3
          OnClick = tbVirtualStarWorkClick
        end
      end
      object grdVirtualFile: TDBGrid
        Left = 0
        Top = 41
        Width = 874
        Height = 440
        Align = alClient
        DataSource = dsVirtual
        TabOrder = 1
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -15
        TitleFont.Name = 'Segoe UI'
        TitleFont.Style = []
        Columns = <
          item
            Expanded = False
            FieldName = 'FVirtualCode'
            Title.Caption = #34394#25311#36335#24452#20195#30721
            Width = 165
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'FVirtualCaption'
            Title.Caption = #34394#25311#36335#24452#26631#31614
            Width = 179
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'FPhyPath'
            Title.Caption = #23454#38469#29289#29702#36335#24452
            Width = 320
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'FIsEnable'
            PickList.Strings = (
              'false'
              'true')
            Title.Caption = #21551#29992
            Width = 71
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'FIsWeb'
            PickList.Strings = (
              'false'
              'true')
            Title.Caption = #25903#25345'Web'#35775#38382
            Width = 94
            Visible = True
          end>
      end
    end
  end
  object plTop: TPanel
    Left = 0
    Top = 0
    Width = 882
    Height = 75
    Align = alTop
    TabOrder = 1
    ExplicitWidth = 878
    object Image1: TImage
      Left = 1
      Top = 1
      Width = 72
      Height = 73
      Align = alLeft
      Center = True
      Picture.Data = {
        0954506E67496D61676589504E470D0A1A0A0000000D49484452000000400000
        00400806000000AA6971DE000005B54944415478DAED9B4D6C1B4514C7DF9BDD
        DAAD48A0B1A322D99714C5095504ED810B4848E152B8204E54E2022D084A9D22
        A1D254E244382135A507681C0A82162E4870EC057AA1A812E5C0011555257144
        72682CB5EA3A5113D4C6F1CEE33FFE686CEAB8BBF9DA3ADD9156F3E1DDF17BBF
        79EFCD8C77CCF490270E5A80A05308206801824E2180A005083A8500D6B3F358
        26FB03B25757D9CD8FF9746A5FCB01D8FE79B65F59F4CB5AF4A55D7A61F6BDD4
        85104020003ECB461F6337A16C3BC1AE244951028F259824A989122C7C99482E
        DA8BD6C51BEF3F717DA300C44E65FBC4527B58F42B90C7259169344F43A36B24
        3CADA5303DBB63D735DA87CF9A01D83E7AB58BB5FD142928A57592984B0AE26B
        93E59C3ABD0829440BC82EA1F0BB3072976ED502C0E717BCF4533332FDB50098
        A54D31ED16E6DDF81497F478EC69A6048674AE9CD3B4981C904415FF62042A59
        8B51AAA7A13FD65A5DA80210E28333E9EE2FFD74D1919978075676BA0A4029DD
        4FAC3E5A6B513704C04A7CB8D6851E0C0022FFC23D1C98A68311ED4043975700
        48E7A1C4277E04C3B31F22DBEB1D004FC16266A04C1CB2C621EB23FE00887C0F
        E5AE682687957D53B9DA7159398A179DF6AD1167EAC0CE3B7747077143893DE9
        03C0AA9217009A8B3B670FED9AAAD6BBCE4C6E9DBB53886BD912B744C7B5A5E2
        A28B9D4A280E85FB00E8B53A007ECDB4A9E50400008B25CF537AAD7BDD052042
        033303A94CED8DEDA7AEC6A330294D36A8495CD92A26C6BC889FC603FB3D0310
        FA343F903AEA47E9D848F604A6820FBC02C0889EC5175D66B8A92EEA3C133B8A
        8A0EA62667EEF02EA7F6D68E916C9A9946EA0020996962B2E23F3132BE4464AD
        68C81EBC2068D6020E74CB9B3886F24E5C89FF03A8DE3857BE64BE94B39A8375
        94EAAA54E7393CB0C38F0520387DE1A47B0EF991389E191F45B07DD733005800
        7CE006E46AC702AD1D0D6D18E576C88272B95ECE4BD7DD815D7201926333E99E
        61AF02B6720CE8C88C0FC2458ED701F063A6AD300B3495BF51103442B3D045B2
        559BD6C64CA464326C4C4750E75A33C29E80688F570066192C5C3CE05940B33C
        17FB4C7539EC3106FC09F9CC52B7ECBEC66D99E0AE1557269E570A7951CF63A9
        FE7CB5AF7025580500DAE750F80301AFC08A16600D05B3C1C16EAFA0955B5064
        2D68D105D668674E55A7112F00B0F118CC0F749FF023586C64E228B10C7B0560
        A67116C98AA2886215D1E44695B622C212816E518C7A44344521B7A93F03DD5E
        AE03B0DE0BA1D5EE060359082DABFCA9ECB3A4E8373F0056933CB980A6E7F287
        5397BCF4B7FC42486882CA26124563041FE3122C0651463B6994D9B4D196A6DF
        70CF3A80CEB92E9DF4A3B465D191AA99FA88018B18C902295E802E05D471A14C
        52800C25972EB53375D3320BA1B5492D1904450E38033D67BD3EE82B06A09E1F
        E81DF223586C646CA8AAF05AC780F8C8F87E04F2337500D67D3788B686F72AB5
        D48FC666DCD44D5EA3EC860441F2F1A385A5A4AB4AD0338055242F008C05BB9A
        A7BCF457FB63CB86C4808D00B0D214020801AC0700A6215DA45F1F5E00A10584
        16105A406801F7B780F3423256E6C5BD5459986C0E00F7B7807B4E7D343B4DD2
        7A009A5A805CB6B7D87B6FBCBD7496C0A41D5FFDF37871B178BEF4D2A5E50134
        B10021FE6E26DDFD46A3C73A3213DF32C9EBAD0FA0A905F0703EDD7DACD163B1
        CCC4713C3CB8C901D0CFF0FF971A03C8FE84ECC5CD0EC0B8C85BF943A96FEA94
        1FCDBE09FFF8BAD1ED9B0F40E51E21BB320D167B9BBEF5D994007CA410400820
        04100208018400D60940E5482AB6A39230E784592829E5F766DB361980DB4C94
        1336E7842507D573D8978C2DFB36E5D1935762D6B66882B50123491695202509
        AD29C9E640B5540F56CB98E94831FF2D957251B96373077B6FAEE51F26DA4F8F
        75DADAEA3583657E3FD0224F96078E7B4B0AB19A16E44A41410DE558E7CA07A2
        39E7DE5EC8DD3AD2976FD479F89799A005083A8500821620E81402085A80A0D3
        430FE03F221788DA420A49F60000000049454E44AE426082}
    end
    object lbServerHint: TLabel
      Left = 91
      Top = 10
      Width = 5
      Height = 28
      Color = clSkyBlue
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -20
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentColor = False
      ParentFont = False
    end
    object BtnRes: TBitBtn
      AlignWithMargins = True
      Left = 639
      Top = 6
      Width = 112
      Height = 63
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Align = alRight
      Caption = #37325#21551#26381#21153
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnClick = BtnResClick
      ExplicitLeft = 635
    end
    object btnClose: TBitBtn
      AlignWithMargins = True
      Left = 759
      Top = 6
      Width = 112
      Height = 63
      Margins.Top = 5
      Margins.Right = 10
      Margins.Bottom = 5
      Align = alRight
      Caption = #36864#20986#26381#21153
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = HookCloseMainClick
      ExplicitLeft = 755
    end
  end
  object plZTSet: TPanel
    Left = 235
    Top = 154
    Width = 401
    Height = 232
    Caption = '9091'
    Color = clSkyBlue
    ParentBackground = False
    TabOrder = 2
    Visible = False
    object Label4: TLabel
      Left = 35
      Top = 24
      Width = 64
      Height = 20
      Caption = #36134#22871#20195#30721
    end
    object Label5: TLabel
      Left = 35
      Top = 53
      Width = 64
      Height = 20
      Caption = #36134#22871#26631#31614
    end
    object Label6: TLabel
      Left = 35
      Top = 82
      Width = 80
      Height = 20
      Caption = #27744#21021#22987#25968#37327
    end
    object Label7: TLabel
      Left = 35
      Top = 111
      Width = 80
      Height = 20
      Caption = #27744#26368#22823#25968#37327
    end
    object Label8: TLabel
      Left = 35
      Top = 140
      Width = 80
      Height = 20
      Caption = #25968#25454#24211#31867#22411
    end
    object Label9: TLabel
      Left = 35
      Top = 169
      Width = 80
      Height = 20
      Caption = #36830#25509#23383#31526#20018
    end
    object dbZTCode: TDBEdit
      Left = 120
      Top = 21
      Width = 233
      Height = 28
      DataField = 'FZTCode'
      DataSource = dsZTSet
      TabOrder = 0
    end
    object dbZTCaption: TDBEdit
      Left = 120
      Top = 50
      Width = 233
      Height = 28
      DataField = 'FZTCaption'
      DataSource = dsZTSet
      TabOrder = 1
    end
    object dbInitPoolCount: TDBEdit
      Left = 120
      Top = 79
      Width = 233
      Height = 28
      DataField = 'FInitPoolCount'
      DataSource = dsZTSet
      TabOrder = 2
    end
    object dbMaxPoolCount: TDBEdit
      Left = 120
      Top = 108
      Width = 233
      Height = 28
      DataField = 'FMaxPoolCount'
      DataSource = dsZTSet
      TabOrder = 3
    end
    object dbConnectionStr: TDBEdit
      Left = 120
      Top = 166
      Width = 233
      Height = 28
      DataField = 'FConnectionStr'
      DataSource = dsZTSet
      TabOrder = 4
    end
    object tbZTConnectSet: TButton
      Left = 359
      Top = 168
      Width = 33
      Height = 25
      Caption = #35774#32622
      TabOrder = 5
      OnClick = tbZTConnectSetClick
    end
    object dbIsEnable: TDBCheckBox
      Left = 93
      Top = 200
      Width = 102
      Height = 17
      Caption = #26159#21542#21487#29992
      DataField = 'FIsEnable'
      DataSource = dsZTSet
      TabOrder = 6
    end
    object tbZTSetOK: TButton
      Left = 296
      Top = 198
      Width = 89
      Height = 25
      Caption = #30830#23450
      TabOrder = 7
      OnClick = tbZTSetOKClick
    end
    object tbZTPing: TButton
      Left = 201
      Top = 198
      Width = 89
      Height = 25
      Caption = #27979#35797#36830#25509
      TabOrder = 8
      OnClick = tbZTPingClick
    end
    object dbIsMain: TDBCheckBox
      Left = 4
      Top = 199
      Width = 73
      Height = 17
      Caption = #20027#36134#22871
      DataField = 'FIsMain'
      DataSource = dsZTSet
      TabOrder = 9
    end
    object dbPhyDriver: TDBEdit
      Left = 120
      Top = 136
      Width = 233
      Height = 28
      DataField = 'FPhyDriver'
      DataSource = dsZTSet
      Enabled = False
      TabOrder = 10
    end
  end
  object qryZTSet: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 41
    Top = 465
    object qryZTSetFZTCode: TWideStringField
      FieldName = 'FZTCode'
      Size = 50
    end
    object qryZTSetFZTCaption: TWideStringField
      FieldName = 'FZTCaption'
      Size = 50
    end
    object qryZTSetFInitPoolCount: TIntegerField
      FieldName = 'FInitPoolCount'
    end
    object qryZTSetFMaxPoolCount: TIntegerField
      FieldName = 'FMaxPoolCount'
    end
    object qryZTSetFPhyDriver: TWideStringField
      FieldName = 'FPhyDriver'
      Size = 50
    end
    object qryZTSetFConnectionStr: TWideStringField
      FieldName = 'FConnectionStr'
      Size = 500
    end
    object qryZTSetFIsEnable: TBooleanField
      FieldName = 'FIsEnable'
    end
    object qryZTSetFIsMain: TBooleanField
      FieldName = 'FIsMain'
    end
  end
  object dsZTSet: TDataSource
    DataSet = qryZTSet
    Left = 89
    Top = 465
  end
  object FDGUIxWaitCursor1: TFDGUIxWaitCursor
    Provider = 'Forms'
    Left = 684
    Top = 493
  end
  object FDGUIxLoginDialog1: TFDGUIxLoginDialog
    Provider = 'Forms'
    Left = 780
    Top = 493
  end
  object FDConnection1: TFDConnection
    Params.Strings = (
      'DriverID=MSSQL')
    LoginDialog = FDGUIxLoginDialog1
    LoginPrompt = False
    Left = 220
    Top = 501
  end
  object qryZTPool: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 220
    Top = 452
    object qryZTPoolFZTCode: TWideStringField
      FieldName = 'FZTCode'
      Size = 50
    end
    object qryZTPoolFInitPoolCount: TIntegerField
      FieldName = 'FInitPoolCount'
    end
    object qryZTPoolFMaxPoolCount: TIntegerField
      FieldName = 'FMaxPoolCount'
    end
    object qryZTPoolFPoolCreateCount: TIntegerField
      FieldName = 'FPoolCreateCount'
    end
    object qryZTPoolFPoolWorkCount: TIntegerField
      FieldName = 'FPoolWorkCount'
    end
    object qryZTPoolFStop: TBooleanField
      FieldName = 'FStop'
    end
  end
  object dsZTPool: TDataSource
    DataSet = qryZTPool
    Left = 276
    Top = 452
  end
  object TrayIcon1: TTrayIcon
    BalloonFlags = bfInfo
    PopupMenu = HookMenu
    Visible = True
    OnClick = TrayIcon1Click
    Left = 284
    Top = 16
  end
  object HookMenu: TPopupMenu
    Left = 224
    Top = 16
    object pmiShowMain: TMenuItem
      Caption = #26174#31034#20027#30028#38754
      OnClick = pmiShowMainClick
    end
    object HookCloseMain: TMenuItem
      Caption = #36864#20986#31243#24207
      OnClick = HookCloseMainClick
    end
  end
  object qryVirtual: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 636
    Top = 293
    object qryVirtualFVirtualCode: TWideStringField
      FieldName = 'FVirtualCode'
      Size = 50
    end
    object qryVirtualFVirtualCaption: TWideStringField
      FieldName = 'FVirtualCaption'
      Size = 50
    end
    object qryVirtualFPhyPath: TWideStringField
      FieldName = 'FPhyPath'
      Size = 250
    end
    object qryVirtualFIsEnable: TBooleanField
      FieldName = 'FIsEnable'
    end
    object qryVirtualFIsWeb: TBooleanField
      FieldName = 'FIsWeb'
    end
  end
  object dsVirtual: TDataSource
    DataSet = qryVirtual
    Left = 692
    Top = 293
  end
  object qryRouter: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 52
    Top = 397
    object qryRouterFOrderNumber: TIntegerField
      FieldName = 'FOrderNumber'
    end
    object qryRouterFRootName: TWideStringField
      FieldName = 'FRootName'
      Size = 100
    end
    object qryRouterFClassName: TWideStringField
      FieldName = 'FClassName'
      Size = 200
    end
    object qryRouterFPoolMaxCount: TIntegerField
      FieldName = 'FPoolMaxCount'
    end
    object qryRouterFWorkingCount: TIntegerField
      FieldName = 'FWorkingCount'
    end
  end
  object dsRouter: TDataSource
    DataSet = qryRouter
    Left = 108
    Top = 398
  end
  object qryToken: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 644
    Top = 421
    object qryTokenFConnectionID: TWideStringField
      FieldName = 'FConnectionID'
      Size = 50
    end
    object qryTokenFTokenID: TWideStringField
      FieldName = 'FTokenID'
      Size = 50
    end
    object qryTokenFPrivateKey: TWideStringField
      FieldName = 'FPrivateKey'
      Size = 50
    end
    object qryTokenFLoginIP: TWideStringField
      FieldName = 'FLoginIP'
      Size = 50
    end
    object qryTokenFLoginMac: TWideStringField
      FieldName = 'FLoginMac'
      Size = 50
    end
    object qryTokenFLoginTime: TDateTimeField
      FieldName = 'FLoginTime'
    end
    object qryTokenFLoginPlatform: TWideStringField
      FieldName = 'FLoginPlatform'
      Size = 50
    end
    object qryTokenFLoginUserCode: TWideStringField
      FieldName = 'FLoginUserCode'
      Size = 50
    end
    object qryTokenFSysUserID: TWideStringField
      FieldName = 'FSysUserID'
      Size = 50
    end
    object qryTokenFSysUserName: TWideStringField
      FieldName = 'FSysUserName'
      Size = 50
    end
    object qryTokenFZTCode: TWideStringField
      FieldName = 'FZTCode'
      Size = 50
    end
    object qryTokenFPlatUserID: TWideStringField
      FieldName = 'FPlatUserID'
      Size = 50
    end
    object qryTokenFLastTime: TDateTimeField
      FieldName = 'FLastTime'
    end
  end
  object dsToken: TDataSource
    DataSet = qryToken
    Left = 700
    Top = 413
  end
end

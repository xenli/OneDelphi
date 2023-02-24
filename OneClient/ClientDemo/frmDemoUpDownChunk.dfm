object Form7: TForm7
  Left = 0
  Top = 0
  Caption = #25991#20214#20998#22359#19978#20256#19979#36733
  ClientHeight = 577
  ClientWidth = 860
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
    Width = 860
    Height = 80
    Align = alTop
    TabOrder = 0
    ExplicitWidth = 856
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
    end
  end
  object edRemark: TMemo
    Left = 0
    Top = 80
    Width = 860
    Height = 73
    Align = alTop
    Lines.Strings = (
      #34394#25311#20195#30721'[VirtualCode]:'#23545#24212#26381#21153#31471#37197#32622' '#27604#22914'TEST-->'#23454#38469#29289#29702#22320#22336' D:/'#25105#30340#25991#26723
      #36828#31243#25991#20214'[RemoteFile]:'#25991#20214#25152#22312#36335#24452' /'#23458#25143#26723#26696'/'#33539#32852#28385'.excel'
      #26368#32456#22312#26381#21153#36319#25454#34394#25311#20195#30721#25214#21040#29289#29702#22320#22336#32452#25104':D:/'#25105#30340#25991#26723'/'#23458#25143#26723#26696'/'#33539#32852#28385'.excel')
    TabOrder = 1
    ExplicitWidth = 856
  end
  object groupUpload: TGroupBox
    Left = 8
    Top = 175
    Width = 417
    Height = 394
    Caption = #20998#22359#19978#20256
    TabOrder = 2
    object Label4: TLabel
      Left = 14
      Top = 24
      Width = 52
      Height = 15
      Caption = #34394#25311#20195#30721
    end
    object Label5: TLabel
      Left = 14
      Top = 63
      Width = 52
      Height = 15
      Caption = #36828#31243#25991#20214
    end
    object Label6: TLabel
      Left = 14
      Top = 102
      Width = 52
      Height = 15
      Caption = #26412#22320#25991#20214
    end
    object Label10: TLabel
      Left = 14
      Top = 288
      Width = 323
      Height = 34
      AutoSize = False
      Caption = #19978#20256#25104#21151#36820#22238#25991#20214#21517#31216','#26381#21153#31471#22914#26524#23384#22312#30456#21516#21517#31216#25991#20214','#20250#26377#19968#20010#26032#30340#25991#20214#21517#31216#36820#22238#26469
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      WordWrap = True
    end
    object Label11: TLabel
      Left = 14
      Top = 331
      Width = 65
      Height = 15
      Caption = #26032#25991#20214#21517#31216
    end
    object Label12: TLabel
      Left = 96
      Top = 128
      Width = 130
      Height = 15
      Caption = #25991#20214#25209#37327#19978#20256#19968#34892#19968#20010
    end
    object edVirtualCodeA: TEdit
      Left = 96
      Top = 21
      Width = 241
      Height = 23
      TabOrder = 0
    end
    object edRemoteFileA: TEdit
      Left = 96
      Top = 60
      Width = 241
      Height = 23
      TabOrder = 1
    end
    object edLocalFileA: TEdit
      Left = 96
      Top = 99
      Width = 241
      Height = 23
      TabOrder = 2
    end
    object tbUpLoad: TButton
      Left = 14
      Top = 357
      Width = 121
      Height = 25
      Caption = #21333#20010#25991#20214#20998#22359#19978#20256
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      OnClick = tbUpLoadClick
    end
    object edNewFileName: TEdit
      Left = 96
      Top = 328
      Width = 241
      Height = 23
      TabOrder = 4
    end
    object tbUpLoadList: TButton
      Left = 216
      Top = 357
      Width = 121
      Height = 25
      Caption = #22810#20010#25991#20214#20998#22359#19978#20256
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 5
      OnClick = tbUpLoadListClick
    end
    object edLocalFileAList: TMemo
      Left = 96
      Top = 149
      Width = 241
      Height = 133
      ScrollBars = ssBoth
      TabOrder = 6
    end
  end
  object groupDown: TGroupBox
    Left = 434
    Top = 175
    Width = 417
    Height = 394
    Caption = #20998#22359#19979#36733
    TabOrder = 3
    object Label7: TLabel
      Left = 22
      Top = 32
      Width = 52
      Height = 15
      Caption = #34394#25311#20195#30721
    end
    object Label8: TLabel
      Left = 22
      Top = 71
      Width = 52
      Height = 15
      Caption = #36828#31243#25991#20214
    end
    object Label9: TLabel
      Left = 22
      Top = 110
      Width = 52
      Height = 15
      Caption = #26412#22320#25991#20214
    end
    object edVirtualCodeB: TEdit
      Left = 104
      Top = 29
      Width = 241
      Height = 23
      TabOrder = 0
    end
    object edRemoteFileB: TEdit
      Left = 104
      Top = 68
      Width = 241
      Height = 23
      TabOrder = 1
    end
    object edLocalFileB: TEdit
      Left = 104
      Top = 107
      Width = 241
      Height = 23
      TabOrder = 2
    end
    object tbDownLoad: TButton
      Left = 224
      Top = 148
      Width = 121
      Height = 25
      Caption = #20998#22359#19979#36733
      TabOrder = 3
      OnClick = tbDownLoadClick
    end
  end
  object ProgressList: TProgressBar
    Left = 264
    Top = 151
    Width = 313
    Height = 18
    TabOrder = 4
    Visible = False
  end
  object ProgressFile: TProgressBar
    Left = 224
    Top = 172
    Width = 449
    Height = 18
    TabOrder = 5
    Visible = False
  end
  object OneVirtualFile: TOneVirtualFile
    Connection = OneConnection
    ChunkBlock = 0
    Left = 464
    Top = 80
  end
  object OneConnection: TOneConnection
    IsHttps = False
    HTTPPort = 0
    ConnectionTimeout = 0
    ResponseTimeout = 0
    Left = 552
    Top = 80
  end
end

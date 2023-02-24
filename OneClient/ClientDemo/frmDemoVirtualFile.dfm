object Form6: TForm6
  Left = 0
  Top = 0
  Caption = #34394#25311#30446#24405#25991#20214#19978#20256#19979#36733'-'#36866#21512#23567#25991#20214#19978#20256#19979#36733
  ClientHeight = 424
  ClientWidth = 859
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
    Width = 859
    Height = 80
    Align = alTop
    TabOrder = 0
    ExplicitWidth = 855
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
  object groupUpload: TGroupBox
    Left = 8
    Top = 175
    Width = 417
    Height = 226
    Caption = #19978#20256
    TabOrder = 1
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
      Top = 128
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
      Top = 171
      Width = 65
      Height = 15
      Caption = #26032#25991#20214#21517#31216
    end
    object edVirtualCodeA: TEdit
      Left = 96
      Top = 21
      Width = 241
      Height = 23
      TabOrder = 0
      Text = 'TEST'
    end
    object edRemoteFileA: TEdit
      Left = 96
      Top = 60
      Width = 241
      Height = 23
      TabOrder = 1
      Text = '\aa\123.txt'
    end
    object edLocalFileA: TEdit
      Left = 96
      Top = 99
      Width = 241
      Height = 23
      TabOrder = 2
      Text = 'D:\123.txt'
    end
    object tbUpLoad: TButton
      Left = 216
      Top = 197
      Width = 121
      Height = 25
      Caption = #19978#20256
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
      Top = 168
      Width = 241
      Height = 23
      TabOrder = 4
    end
  end
  object groupDown: TGroupBox
    Left = 434
    Top = 175
    Width = 417
    Height = 226
    Caption = #19979#36733
    TabOrder = 2
    object Label7: TLabel
      Left = 30
      Top = 16
      Width = 52
      Height = 15
      Caption = #34394#25311#20195#30721
    end
    object Label8: TLabel
      Left = 30
      Top = 45
      Width = 52
      Height = 15
      Caption = #36828#31243#25991#20214
    end
    object Label9: TLabel
      Left = 30
      Top = 74
      Width = 52
      Height = 15
      Caption = #26412#22320#25991#20214
    end
    object Label12: TLabel
      Left = 30
      Top = 136
      Width = 52
      Height = 15
      Caption = #34394#25311#20195#30721
    end
    object Label13: TLabel
      Left = 30
      Top = 165
      Width = 52
      Height = 15
      Caption = #36828#31243#25991#20214
    end
    object edVirtualCodeB: TEdit
      Left = 112
      Top = 13
      Width = 241
      Height = 23
      TabOrder = 0
      Text = 'TEST'
    end
    object edRemoteFileB: TEdit
      Left = 112
      Top = 42
      Width = 241
      Height = 23
      TabOrder = 1
      Text = '\aa\123.txt'
    end
    object edLocalFileB: TEdit
      Left = 112
      Top = 71
      Width = 241
      Height = 23
      TabOrder = 2
      Text = 'd:\123.txt'
    end
    object tbDownLoad: TButton
      Left = 232
      Top = 100
      Width = 121
      Height = 25
      Caption = #19979#36733
      TabOrder = 3
      OnClick = tbDownLoadClick
    end
    object edVirtualCodeC: TEdit
      Left = 112
      Top = 133
      Width = 241
      Height = 23
      TabOrder = 4
      Text = 'TEST'
    end
    object edRemoteFileC: TEdit
      Left = 112
      Top = 162
      Width = 241
      Height = 23
      TabOrder = 5
      Text = '\aa\123.txt'
    end
    object tbDelFile: TButton
      Left = 232
      Top = 191
      Width = 121
      Height = 25
      Caption = #21024#38500
      TabOrder = 6
      OnClick = tbDelFileClick
    end
  end
  object edRemark: TMemo
    Left = 0
    Top = 80
    Width = 859
    Height = 89
    Align = alTop
    Lines.Strings = (
      #34394#25311#20195#30721'[VirtualCode]:'#23545#24212#26381#21153#31471#37197#32622' '#27604#22914'TEST-->'#23454#38469#29289#29702#22320#22336' D:/'#25105#30340#25991#26723
      #36828#31243#25991#20214'[RemoteFile]:'#25991#20214#25152#22312#36335#24452' /'#23458#25143#26723#26696'/'#33539#32852#28385'.excel'
      #26368#32456#22312#26381#21153#36319#25454#34394#25311#20195#30721#25214#21040#29289#29702#22320#22336#32452#25104':D:/'#25105#30340#25991#26723'/'#23458#25143#26723#26696'/'#33539#32852#28385'.excel')
    TabOrder = 3
    ExplicitWidth = 855
  end
  object OneConnection: TOneConnection
    Connected = False
    IsHttps = False
    HTTPPort = 0
    ConnectionTimeout = 0
    ResponseTimeout = 0
    Left = 552
    Top = 80
  end
  object OneVirtualFile: TOneVirtualFile
    Connection = OneConnection
    ChunkBlock = 0
    Left = 464
    Top = 80
  end
end

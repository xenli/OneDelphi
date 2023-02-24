object Form4: TForm4
  Left = 0
  Top = 0
  Caption = #23458#25143#31471#35831#27714#26381#21153#31471#25509#21475
  ClientHeight = 504
  ClientWidth = 901
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object plUrl: TPanel
    Left = 0
    Top = 0
    Width = 901
    Height = 113
    Align = alTop
    TabOrder = 0
    object Label4: TLabel
      Left = 4
      Top = 14
      Width = 47
      Height = 15
      Caption = 'URL'#22320#22336
    end
    object Label7: TLabel
      Left = 4
      Top = 40
      Width = 52
      Height = 15
      Caption = #21442#25968#31034#20363
    end
    object edMethod: TComboBox
      Left = 72
      Top = 10
      Width = 73
      Height = 23
      ItemIndex = 0
      TabOrder = 0
      Text = 'GET'
      OnChange = edMethodChange
      Items.Strings = (
        'GET'
        'POST')
    end
    object edUrl: TEdit
      Left = 154
      Top = 10
      Width = 575
      Height = 23
      TabOrder = 1
      Text = 'http://127.0.0.1:9090/demoa/HelloWorld'
    end
    object tbRequest: TButton
      Left = 735
      Top = 9
      Width = 114
      Height = 25
      Caption = #35831#27714
      TabOrder = 2
      OnClick = tbRequestClick
    end
    object edParams: TMemo
      Left = 72
      Top = 40
      Width = 657
      Height = 65
      Lines.Strings = (
        'name='#33539#32852#28385
        'age=18'
        '')
      ReadOnly = True
      TabOrder = 3
    end
  end
  object GroupBox1: TGroupBox
    Left = 0
    Top = 113
    Width = 901
    Height = 391
    Align = alClient
    Caption = #35831#27714#25552#20132
    TabOrder = 1
    object Label5: TLabel
      Left = 3
      Top = 15
      Width = 200
      Height = 17
      Caption = 'URL'#21442#25968':'#19968#34892#19968#20010'(key=value'#65289
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
    object Label6: TLabel
      Left = 420
      Top = 15
      Width = 99
      Height = 17
      Caption = #36820#22238#32467#26524#23637#31034':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
    object Label1: TLabel
      Left = 3
      Top = 183
      Width = 137
      Height = 17
      Caption = 'Post'#25968#25454#19968#33324#26159'JSON'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
    object edUrlParam: TMemo
      Left = 3
      Top = 38
      Width = 398
      Height = 139
      TabOrder = 0
    end
    object edPostResult: TMemo
      Left = 407
      Top = 38
      Width = 491
      Height = 323
      TabOrder = 1
    end
    object edPostData: TMemo
      Left = 3
      Top = 206
      Width = 398
      Height = 155
      TabOrder = 2
    end
  end
  object OneConnection: TOneConnection
    IsHttps = False
    HTTPPort = 0
    ConnectionTimeout = 0
    ResponseTimeout = 0
    Left = 400
    Top = 56
  end
end

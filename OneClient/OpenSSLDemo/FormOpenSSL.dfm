object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 528
  ClientWidth = 852
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -19
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 25
  object Label1: TLabel
    Left = 0
    Top = 0
    Width = 852
    Height = 25
    Align = alTop
    Alignment = taCenter
    Caption = #22522#20110#24320#28304#25913#36896':https://github.com/Arvur/OpenSSL-Delphi '
    Color = clActiveCaption
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -19
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    ExplicitWidth = 482
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 25
    Width = 852
    Height = 503
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 0
    ExplicitWidth = 848
    ExplicitHeight = 502
    object TabSheet1: TTabSheet
      Caption = #24120#29992#31639#27861
      object Label2: TLabel
        Left = 16
        Top = 3
        Width = 40
        Height = 25
        Caption = #36755#20837
      end
      object Label3: TLabel
        Left = 16
        Top = 115
        Width = 40
        Height = 25
        Caption = #36755#20986
      end
      object editOut: TMemo
        Left = 88
        Top = 121
        Width = 721
        Height = 145
        TabOrder = 0
      end
      object tbMD5: TButton
        Left = 176
        Top = 272
        Width = 137
        Height = 49
        Caption = 'MD5'#21152#23494
        TabOrder = 1
        OnClick = tbMD5Click
      end
      object editIn: TMemo
        Left = 88
        Top = 3
        Width = 721
        Height = 112
        TabOrder = 2
      end
      object tbBase64Encode: TButton
        Left = 16
        Top = 344
        Width = 137
        Height = 49
        Caption = 'Base64'#21152#23494
        TabOrder = 3
        OnClick = tbBase64EncodeClick
      end
      object tbBase64Decode: TButton
        Left = 176
        Top = 344
        Width = 137
        Height = 49
        Caption = 'Base64'#35299#23494
        TabOrder = 4
        OnClick = tbBase64DecodeClick
      end
      object tbMD4: TButton
        Left = 16
        Top = 272
        Width = 137
        Height = 49
        Caption = 'MD4'#21152#23494
        TabOrder = 5
        OnClick = tbMD4Click
      end
      object tbFileMD5: TButton
        Left = 336
        Top = 272
        Width = 137
        Height = 49
        Caption = #25991#20214'MD5'
        TabOrder = 6
        OnClick = tbFileMD5Click
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'Aes,des'
      ImageIndex = 2
      object Label4: TLabel
        Left = 24
        Top = 11
        Width = 40
        Height = 25
        Caption = #36755#20837
      end
      object Label5: TLabel
        Left = 3
        Top = 215
        Width = 80
        Height = 25
        Caption = #23494#38053#20301#25968
      end
      object Label6: TLabel
        Left = 267
        Top = 215
        Width = 40
        Height = 25
        Caption = #27169#24335
      end
      object Label7: TLabel
        Left = 24
        Top = 131
        Width = 40
        Height = 25
        Caption = #23494#38053
      end
      object Label8: TLabel
        Left = 24
        Top = 170
        Width = 60
        Height = 25
        Caption = #20559#31227#37327
      end
      object Label9: TLabel
        Left = 24
        Top = 245
        Width = 40
        Height = 25
        Caption = #36755#20986
      end
      object Label10: TLabel
        Left = 579
        Top = 215
        Width = 80
        Height = 25
        Caption = #22635#20805#27169#24335
      end
      object edAesInput: TMemo
        Left = 96
        Top = 11
        Width = 721
        Height = 102
        TabOrder = 0
      end
      object edAeskyeLen: TComboBox
        Left = 96
        Top = 212
        Width = 145
        Height = 33
        ItemIndex = 0
        TabOrder = 1
        Text = '128'
        Items.Strings = (
          '128'
          '192'
          '256')
      end
      object edAesMode: TComboBox
        Left = 360
        Top = 212
        Width = 145
        Height = 33
        ItemIndex = 0
        TabOrder = 2
        Text = 'CBC'
        Items.Strings = (
          'CBC'
          'ECB')
      end
      object edAesKey: TEdit
        Left = 96
        Top = 128
        Width = 721
        Height = 33
        TabOrder = 3
        Text = '0123456789abcdef'
      end
      object edAesIV: TEdit
        Left = 96
        Top = 167
        Width = 721
        Height = 33
        TabOrder = 4
        Text = '0123456789abcdef'
      end
      object tbAesEncode: TButton
        Left = 96
        Top = 384
        Width = 137
        Height = 49
        Caption = 'AES'#21152#23494
        TabOrder = 5
        OnClick = tbAesEncodeClick
      end
      object tbAesDecode: TButton
        Left = 307
        Top = 384
        Width = 137
        Height = 49
        Caption = 'AES'#35299#23494
        TabOrder = 6
        OnClick = tbAesDecodeClick
      end
      object edAesOut: TMemo
        Left = 96
        Top = 251
        Width = 721
        Height = 127
        TabOrder = 7
      end
      object edAesPadding: TComboBox
        Left = 672
        Top = 212
        Width = 145
        Height = 33
        ItemIndex = 0
        TabOrder = 8
        Text = 'PKCS7'
        Items.Strings = (
          'PKCS7'
          'ZERO')
      end
    end
    object TabSheet2: TTabSheet
      Caption = #22269#23494
      ImageIndex = 1
    end
  end
  object OpenDialog1: TOpenDialog
    Left = 700
    Top = 349
  end
end

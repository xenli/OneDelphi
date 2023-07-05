object frWaitHint: TfrWaitHint
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'frWaitHint'
  ClientHeight = 45
  ClientWidth = 353
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  TextHeight = 15
  object lbHint: TLabel
    Left = 0
    Top = 0
    Width = 353
    Height = 45
    Align = alClient
    Alignment = taCenter
    Caption = #32593#32476#27491#22312#35831#27714#20013#35831#31245#20505'....'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -15
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    Layout = tlCenter
    WordWrap = True
    ExplicitWidth = 172
    ExplicitHeight = 20
  end
  object TimerCacle: TTimer
    Enabled = False
    OnTimer = TimerCacleTimer
    Left = 32
    Top = 8
  end
end

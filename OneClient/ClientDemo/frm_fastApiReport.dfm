object frmFastApiReport: TfrmFastApiReport
  Left = 0
  Top = 0
  Caption = #25509#21475#25253#34920#35774#35745
  ClientHeight = 432
  ClientWidth = 847
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  TextHeight = 15
  object tbOpenApiData: TcxButton
    Left = 479
    Top = 47
    Width = 360
    Height = 39
    Caption = #31532#19968#27493':'#35831#27714#25171#24320'FastApi'#25968#25454
    TabOrder = 1
    OnClick = tbOpenApiDataClick
  end
  object tbDownReport: TcxButton
    Left = 479
    Top = 126
    Width = 360
    Height = 39
    Caption = #31532#20108#27493':'#35831#27714#19979#36733#25253#34920#25991#20214','#19981#23384#22312#26032#24314
    TabOrder = 3
    OnClick = tbDownReportClick
  end
  object tbSaveReport: TcxButton
    Left = 479
    Top = 306
    Width = 360
    Height = 39
    Caption = #31532#22235#27493':'#20445#23384#25253#34920#25991#20214','#19978#20256#21040#26381#21153#31471
    TabOrder = 5
    OnClick = tbSaveReportClick
  end
  object tbReportDesign: TcxButton
    Left = 479
    Top = 217
    Width = 360
    Height = 39
    Caption = #31532#19977#27493':'#26412#22320#25253#34920#35774#35745
    TabOrder = 7
    OnClick = tbReportDesignClick
  end
  object cxLabel1: TcxLabel
    Left = 0
    Top = 8
    Caption = #25509#21475#35831#27714#20449#24687
  end
  object cxLabel2: TcxLabel
    Left = 8
    Top = 53
    Caption = 'apiCode'
  end
  object edApiCode: TcxTextEdit
    Left = 88
    Top = 52
    TabOrder = 4
    Width = 369
  end
  object grdParam: TcxGrid
    Left = 8
    Top = 126
    Width = 449
    Height = 219
    TabOrder = 6
    object vwParam: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      ScrollbarAnnotations.CustomAnnotations = <>
      DataController.DataSource = dsParam
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      OptionsView.GroupByBox = False
      object vwParamFKey: TcxGridDBColumn
        DataBinding.FieldName = 'FKey'
        Width = 141
      end
      object vwParamFValue: TcxGridDBColumn
        DataBinding.FieldName = 'FValue'
        Width = 165
      end
      object vwParamFType: TcxGridDBColumn
        DataBinding.FieldName = 'FType'
        PropertiesClassName = 'TcxComboBoxProperties'
        Properties.Items.Strings = (
          #23383#31526#20018
          #25968#23383
          #24067#23572)
        Width = 137
      end
    end
    object lvParam: TcxGridLevel
      GridView = vwParam
    end
  end
  object cxButton1: TcxButton
    Left = 8
    Top = 95
    Width = 105
    Height = 25
    Caption = #28155#21152#21442#25968
    TabOrder = 8
    OnClick = cxButton1Click
  end
  object cxButton2: TcxButton
    Left = 119
    Top = 95
    Width = 106
    Height = 25
    Caption = #21024#38500#21442#25968
    TabOrder = 9
    OnClick = cxButton2Click
  end
  object frxJPEGExport1: TfrxJPEGExport
    FileName = '123'
    UseFileCache = True
    ShowProgress = True
    OverwritePrompt = False
    DataOnly = False
    Left = 305
    Top = 65534
  end
  object frxPDFExport1: TfrxPDFExport
    UseFileCache = True
    ShowProgress = True
    OverwritePrompt = False
    DataOnly = False
    EmbedFontsIfProtected = False
    InteractiveFormsFontSubset = 'A-Z,a-z,0-9,#43-#47 '
    OpenAfterExport = False
    PrintOptimized = False
    Outline = False
    Background = False
    HTMLTags = True
    Quality = 95
    Transparency = False
    Author = 'FastReport'
    Subject = 'FastReport PDF export'
    Creator = 'FastReport'
    ProtectionFlags = [ePrint, eModify, eCopy, eAnnot]
    HideToolbar = False
    HideMenubar = False
    HideWindowUI = False
    FitWindow = False
    CenterWindow = False
    PrintScaling = False
    PdfA = False
    PDFStandard = psNone
    PDFVersion = pv17
    Left = 273
    Top = 65534
  end
  object ReportMain: TfrxReport
    Version = '2022.3'
    DotMatrixReport = False
    IniFile = '\Software\Fast Reports'
    PreviewOptions.Buttons = [pbPrint, pbLoad, pbSave, pbExport, pbZoom, pbFind, pbOutline, pbPageSetup, pbTools, pbEdit, pbNavigator, pbExportQuick]
    PreviewOptions.Zoom = 1.000000000000000000
    PrintOptions.Printer = #39044#35774
    PrintOptions.PrintOnSheet = 0
    ReportOptions.CreateDate = 42543.442496226850000000
    ReportOptions.LastChange = 42543.442496226850000000
    ScriptLanguage = 'PascalScript'
    ScriptText.Strings = (
      'begin'
      ''
      'end.')
    Left = 577
    Top = 65534
    Datasets = <>
    Variables = <>
    Style = <>
    object Data: TfrxDataPage
      Height = 1000.000000000000000000
      Width = 1000.000000000000000000
    end
    object Page1: TfrxReportPage
      PaperWidth = 210.000000000000000000
      PaperHeight = 297.000000000000000000
      PaperSize = 9
      LeftMargin = 10.000000000000000000
      RightMargin = 10.000000000000000000
      TopMargin = 10.000000000000000000
      BottomMargin = 10.000000000000000000
      Frame.Typ = []
      MirrorMode = []
    end
  end
  object frxXLSExport1: TfrxXLSExport
    UseFileCache = True
    ShowProgress = True
    OverwritePrompt = False
    DataOnly = False
    ExportEMF = True
    AsText = False
    Background = True
    FastExport = True
    PageBreaks = True
    EmptyLines = True
    SuppressPageHeadersFooters = False
    Left = 361
    Top = 65534
  end
  object frxBMPExport1: TfrxBMPExport
    UseFileCache = True
    ShowProgress = True
    OverwritePrompt = False
    DataOnly = False
    Left = 329
    Top = 65534
  end
  object frxXLSXExport1: TfrxXLSXExport
    UseFileCache = True
    ShowProgress = True
    OverwritePrompt = False
    DataOnly = False
    ChunkSize = 0
    OpenAfterExport = False
    PictureType = gpPNG
    Left = 385
    Top = 65534
  end
  object frxXMLExport1: TfrxXMLExport
    UseFileCache = True
    ShowProgress = True
    OverwritePrompt = False
    DataOnly = False
    Background = True
    Creator = 'FastReport'
    EmptyLines = True
    SuppressPageHeadersFooters = False
    RowsCount = 0
    Split = ssNotSplit
    Left = 409
    Top = 65534
  end
  object frxPPTXExport1: TfrxPPTXExport
    UseFileCache = True
    ShowProgress = True
    OverwritePrompt = False
    DataOnly = False
    OpenAfterExport = False
    PictureType = gpPNG
    Left = 457
    Top = 65534
  end
  object frxGZipCompressor1: TfrxGZipCompressor
    Left = 241
    Top = 65534
  end
  object frDesign: TfrxDesigner
    CloseQuery = False
    DefaultScriptLanguage = 'PascalScript'
    DefaultFont.Charset = DEFAULT_CHARSET
    DefaultFont.Color = clWindowText
    DefaultFont.Height = -13
    DefaultFont.Name = 'Arial'
    DefaultFont.Style = []
    DefaultLeftMargin = 10.000000000000000000
    DefaultRightMargin = 10.000000000000000000
    DefaultTopMargin = 10.000000000000000000
    DefaultBottomMargin = 10.000000000000000000
    DefaultPaperSize = 9
    DefaultOrientation = poPortrait
    GradientEnd = 11982554
    GradientStart = clWindow
    TemplatesExt = 'fr3'
    Restrictions = []
    RTLLanguage = False
    MemoParentFont = False
    OnSaveReport = frDesignSaveReport
    Left = 617
    Top = 65534
  end
  object frxHTMLExport1: TfrxHTMLExport
    UseFileCache = True
    ShowProgress = True
    OverwritePrompt = False
    DataOnly = False
    OpenAfterExport = False
    FixedWidth = True
    Background = False
    Centered = False
    EmptyLines = True
    Print = False
    PictureType = gpPNG
    Outline = False
    Left = 433
    Top = 65534
  end
  object frxGIFExport1: TfrxGIFExport
    UseFileCache = True
    ShowProgress = True
    OverwritePrompt = False
    DataOnly = False
    Left = 481
    Top = 65534
  end
  object OneServerFastReport: TOneServerFastReport
    Left = 680
  end
  object frxDBDataset1: TfrxDBDataset
    UserName = 'frxDBDataset1'
    CloseDataSource = False
    BCDToCurrency = False
    DataSetOptions = []
    Left = 808
  end
  object qryParam: TFDMemTable
    OnNewRecord = qryParamNewRecord
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 104
    Top = 136
    object qryParamFKey: TWideStringField
      DisplayLabel = #21442#25968#21517#31216
      FieldName = 'FKey'
      Size = 50
    end
    object qryParamFValue: TWideStringField
      DisplayLabel = #21442#25968#20540
      FieldName = 'FValue'
      Size = 100
    end
    object qryParamFType: TWideStringField
      DisplayLabel = #21442#25968#31867#22411
      FieldName = 'FType'
      Size = 30
    end
  end
  object dsParam: TDataSource
    DataSet = qryParam
    Left = 168
    Top = 136
  end
end

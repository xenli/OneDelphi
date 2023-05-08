object frDemoFastFile: TfrDemoFastFile
  Left = 0
  Top = 0
  Caption = #38468#20214#20851#32852
  ClientHeight = 529
  ClientWidth = 867
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  StyleName = 'Windows'
  OnCreate = FormCreate
  TextHeight = 15
  object plSet: TPanel
    Left = 0
    Top = 0
    Width = 867
    Height = 80
    Align = alTop
    TabOrder = 0
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
  object PageControl1: TPageControl
    Left = 0
    Top = 80
    Width = 867
    Height = 449
    ActivePage = TabSheet3
    Align = alClient
    TabOrder = 1
    object TabSheet1: TTabSheet
      Caption = '1.'#31532#19968#27493#65306#34920#32467#26500#21019#24314
      object Label4: TLabel
        Left = 0
        Top = 0
        Width = 859
        Height = 20
        Align = alTop
        Caption = #19979#38754'SQL'#26159'MSSQL'#30340','#22914#20854#23427#25968#25454#24211#35831#33258#34892#36716#21270
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clRed
        Font.Height = -15
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        ExplicitWidth = 316
      end
      object edSQL: TMemo
        Left = 0
        Top = 20
        Width = 859
        Height = 399
        Align = alClient
        Lines.Strings = (
          '---------'#37197#32622#34920'-------------'
          'CREATE TABLE  onefast_file_set('
          #9'FFileSetID nvarchar(32) primary key,'
          #9'FFileSetCode nvarchar(50)  ,'
          '                FFileSetCaptioin  nvarchar(50)  ,'
          #9'FSavePhyPath nvarchar(255)  ,'
          #9'FSaveTable nvarchar(50)  ,'
          #9'FSaveMode nvarchar(30)  ,'
          #9'FIsEnabled bit  )'
          '--------'#40664#35748#25346#21246#30340#25968#25454#34920'-----------------------'
          'CREATE TABLE dbo.onefast_file('
          #9'FFileID nvarchar(32) primary key,'
          '               FFileSetCode nvarchar(50),'
          #9'FFileName nvarchar(200),'
          #9'FFileType nvarchar(50),'
          #9'FFilePhyPath nvarchar(500),'
          #9'FFileHttpUrl nvarchar(500),'
          #9'FFileSize bigint,'
          #9'FRelationID nvarchar(50),'
          #9'FPRelationID nvarchar(50),'
          #9'FFileRemark nvarchar(500),'
          #9'FCreateTime datetime )')
        ScrollBars = ssBoth
        TabOrder = 0
      end
    end
    object TabSheet2: TTabSheet
      Caption = '2.'#31532#20108#27493#65306#37197#32622#34920#37197#32622','#20445#23384#21518#35201#29983#25928','#35831#21047#26032#26381#21153#31471
      ImageIndex = 1
      object DBGrid1: TDBGrid
        Left = 0
        Top = 41
        Width = 859
        Height = 378
        Align = alClient
        DataSource = dsMain
        TabOrder = 0
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
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 859
        Height = 41
        Align = alTop
        TabOrder = 1
        object tbOpenData: TButton
          Left = 6
          Top = 3
          Width = 106
          Height = 25
          Caption = #25171#24320#25968#25454
          TabOrder = 0
          OnClick = tbOpenDataClick
        end
        object tbAppend: TButton
          Left = 118
          Top = 3
          Width = 113
          Height = 25
          Caption = #22686#21152#37197#32622
          TabOrder = 1
          OnClick = tbAppendClick
        end
        object tbSaveData: TButton
          Left = 237
          Top = 3
          Width = 144
          Height = 25
          Caption = #20445#23384#25968#25454
          TabOrder = 2
          OnClick = tbSaveDataClick
        end
        object Button1: TButton
          Left = 563
          Top = 3
          Width = 144
          Height = 25
          Caption = #21047#26032#26381#21153#31471#32531#23384#37197#32622
          TabOrder = 3
          OnClick = Button1Click
        end
      end
    end
    object TabSheet3: TTabSheet
      Caption = '3.'#31532#19977#27493#65306#19994#21153#27979#35797
      ImageIndex = 2
      object Label5: TLabel
        Left = 6
        Top = 15
        Width = 78
        Height = 15
        Caption = #25991#20214#37197#32622#20195#30721
      end
      object Label6: TLabel
        Left = 310
        Top = 15
        Width = 170
        Height = 15
        Caption = #19994#21153#20851#32852'ID,'#35831#20808#38543#20415#36755#20837#19968#20010
      end
      object Label7: TLabel
        Left = 3
        Top = 101
        Width = 80
        Height = 20
        Caption = #20851#32852#25991#20214#65306
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clRed
        Font.Height = -15
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
      end
      object Label9: TLabel
        Left = 120
        Top = 76
        Width = 78
        Height = 15
        Caption = #19978#20256#19979#36733#36827#24230
      end
      object Label8: TLabel
        Left = 120
        Top = 43
        Width = 65
        Height = 15
        Caption = #25991#20214#24635#20010#25968
      end
      object edFileCode: TEdit
        Left = 90
        Top = 12
        Width = 172
        Height = 23
        TabOrder = 0
      end
      object edRelationID: TEdit
        Left = 486
        Top = 12
        Width = 172
        Height = 23
        TabOrder = 1
      end
      object GridFile: TDBGrid
        Left = 3
        Top = 127
        Width = 682
        Height = 258
        DataSource = dsFile
        TabOrder = 2
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -12
        TitleFont.Name = 'Segoe UI'
        TitleFont.Style = []
      end
      object tbFileUpload: TButton
        Left = 691
        Top = 173
        Width = 154
        Height = 41
        Caption = #19978#20256#25991#20214'('#21333')'
        TabOrder = 3
        OnClick = tbFileUploadClick
      end
      object tbFileDown: TButton
        Left = 691
        Top = 262
        Width = 154
        Height = 41
        Caption = #19979#36733#25991#20214
        TabOrder = 4
        OnClick = tbFileDownClick
      end
      object tbOpenFile: TButton
        Left = 691
        Top = 125
        Width = 154
        Height = 41
        Caption = #26597#30475#20851#32852#25991#20214
        TabOrder = 5
        OnClick = tbOpenFileClick
      end
      object tbFileDel: TButton
        Left = 691
        Top = 309
        Width = 154
        Height = 41
        Caption = #21024#38500#25991#20214
        TabOrder = 6
        OnClick = tbFileDelClick
      end
      object tbFilesUpload: TButton
        Left = 691
        Top = 218
        Width = 154
        Height = 41
        Caption = #19978#20256#25991#20214'('#22810')'
        TabOrder = 7
        OnClick = tbFilesUploadClick
      end
      object ProgressFileSize: TProgressBar
        Left = 224
        Top = 70
        Width = 417
        Height = 25
        TabOrder = 8
      end
      object ProgressFileCount: TProgressBar
        Left = 224
        Top = 39
        Width = 417
        Height = 25
        TabOrder = 9
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
    Left = 408
    Top = 16
  end
  object OneFastFile: TOneFastFile
    Connection = OneConnection
    FileChunkSize = 1048576
    OnCallBack = OneFastFileCallBack
    Left = 352
    Top = 216
  end
  object qryMain: TOneDataSet
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
      'from onefast_file_set'
      'order by FFileSetCode ')
    DataInfo.MetaInfoKind = mkNone
    DataInfo.TableName = 'onefast_file_set'
    DataInfo.PrimaryKey = 'FFileSetID'
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
    Left = 580
    Top = 50
  end
  object dsMain: TDataSource
    DataSet = qryMain
    Left = 688
    Top = 40
  end
  object qryFile: TOneDataSet
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
      'from onefast_file'
      'where FRelationID=:FRelationID')
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
    Params = <
      item
        Name = 'FRelationID'
      end>
    MultiIndex = 0
    ActiveDesign = False
    Left = 156
    Top = 474
  end
  object dsFile: TDataSource
    DataSet = qryFile
    Left = 232
    Top = 472
  end
  object OpenDialog1: TOpenDialog
    Options = [ofHideReadOnly, ofAllowMultiSelect, ofEnableSizing]
    Left = 460
    Top = 282
  end
  object FileOpenDialog1: TFileOpenDialog
    FavoriteLinks = <>
    FileName = 'D:\devTool\delphi\project\OneDelphi\OneClient\ClientDemo\Win32'
    FileTypes = <>
    Options = [fdoPickFolders]
    Left = 460
    Top = 370
  end
end

object Myform: TMyform
  Left = 420
  Top = 65
  ActiveControl = Panel1
  Caption = 'Myform'
  ClientHeight = 563
  ClientWidth = 759
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = mu_MainMenu
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 208
    Top = 0
    Width = 5
    Height = 563
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 208
    Height = 563
    Align = alLeft
    Caption = 'Panel1'
    TabOrder = 0
    object ExtDBNavigator: TExtDBNavigator
      Left = 1
      Top = 1
      Width = 206
      Height = 20
      DataSource = ds_user
      DeleteQuestion = 'Confirmez-vous l'#39'effacement de l'#39'enregistrement ?'
      Align = alTop
      TabOrder = 0
      GlyphSize = gsSmall
    end
    object Noms: TExtDBGrid
      Left = 1
      Top = 21
      Width = 206
      Height = 541
      Align = alClient
      Columns = <
        item
          Expanded = False
          FieldName = 'NOM'
          Title.Caption = 'Name'
          Width = 76
          Visible = True
          SomeEdit = Nom
          FieldTag = 0
          Resize = True
        end
        item
          Expanded = False
          FieldName = 'PRENOM'
          Title.Alignment = taCenter
          Title.Caption = 'Surname'
          Width = 76
          Visible = True
          SomeEdit = Prenom
          FieldTag = 0
          Resize = True
        end>
      DataSource = ds_user
      TabOrder = 1
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
      AutoSort = False
      SelectColumnsDialogStrings.Caption = 'Select columns'
      SelectColumnsDialogStrings.OK = '&OK'
      SelectColumnsDialogStrings.NoSelectionWarning = 'At least one column must be visible!'
      EditControls = <>
      RowsHeight = 17
      TitleRowHeight = 17
      Columns = <
        item
          Expanded = False
          FieldName = 'NOM'
          Title.Caption = 'Name'
          Width = 76
          Visible = True
          SomeEdit = Nom
          FieldTag = 0
          Resize = True
        end
        item
          Expanded = False
          FieldName = 'PRENOM'
          Title.Alignment = taCenter
          Title.Caption = 'Surname'
          Width = 76
          Visible = True
          SomeEdit = Prenom
          FieldTag = 0
          Resize = True
        end>
    end
    object Prenom: TFWDBEdit
      Left = 7
      Top = 81
      Width = 76
      Height = 17
      DataField = 'PRENOM'
      DataSource = ds_user
      MaxLength = 100
      TabOrder = 2
      Visible = False
      MyLabel = FWLabel6
      AlwaysSame = False
    end
    object Nom: TFWDBEdit
      Left = 7
      Top = 121
      Width = 76
      Height = 17
      DataField = 'NOM'
      DataSource = ds_user
      MaxLength = 100
      TabOrder = 3
      Visible = False
      MyLabel = FWLabel5
      AlwaysSame = False
    end
  end
  object Panel2: TPanel
    Left = 213
    Top = 0
    Width = 546
    Height = 563
    Align = alClient
    TabOrder = 3
    object FWLabel1: TFWLabel
      Left = 19
      Top = 86
      Width = 65
      Height = 17
      AutoSize = False
      Caption = 'Color'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = 13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = False
      ColorFocus = clMaroon
    end
    object FWLabel2: TFWLabel
      Left = 21
      Top = 113
      Width = 65
      Height = 17
      AutoSize = False
      Caption = 'NumEdit'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = 13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = False
      ColorFocus = clMaroon
    end
    object FWLabel3: TFWLabel
      Left = 19
      Top = 142
      Width = 65
      Height = 17
      AutoSize = False
      Caption = 'Date'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = 13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = False
      ColorFocus = clMaroon
    end
    object FWLabel4: TFWLabel
      Left = 19
      Top = 168
      Width = 65
      Height = 17
      AutoSize = False
      Caption = 'Edit'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = 13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = False
      ColorFocus = clMaroon
    end
    object FWLabel5: TFWLabel
      Left = 21
      Top = 48
      Width = 65
      Height = 17
      AutoSize = False
      Caption = 'Name'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = 13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = False
      ColorFocus = clMaroon
    end
    object FWLabel6: TFWLabel
      Left = 21
      Top = 24
      Width = 65
      Height = 17
      AutoSize = False
      Caption = 'Surname'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = 13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = False
      ColorFocus = clMaroon
    end
    object Splitter2: TSplitter
      Left = 1
      Top = 326
      Width = 544
      Height = 3
      Cursor = crVSplit
      Align = alBottom
    end
    object Search2: TFWLabel
      Left = 21
      Top = 216
      Width = 65
      Height = 15
      AutoSize = False
      Caption = 'City'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = 11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = False
      ColorFocus = clMaroon
    end
    object Search: TFWLabel
      Left = 19
      Top = 191
      Width = 65
      Height = 15
      AutoSize = False
      Caption = 'Department'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = 11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = False
      ColorFocus = clMaroon
    end
    object FWLabel7: TFWLabel
      Left = 21
      Top = 243
      Width = 65
      Height = 17
      AutoSize = False
      Caption = 'SpinEdit'
      Color = clBtnFace
      FocusControl = FWSpinEdit
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = 13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = False
      ColorFocus = clMaroon
    end
    object FWLabel8: TFWLabel
      Left = 20
      Top = 295
      Width = 65
      Height = 17
      AutoSize = False
      Caption = 'PictCombo'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = 11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = False
      ColorFocus = clMaroon
    end
    object ExtDBImageList: TExtDBImageList
      Left = 483
      Top = 185
      Width = 24
      Height = 24
      Picture.Data = {07544269746D617000000000}
      Images = ImageResources
      Datafield = 'ENTIER'
      Datasource = ds_user
      ImagesMap = MapImages
    end
    object FWLabel9: TFWLabel
      Left = 21
      Top = 269
      Width = 65
      Height = 17
      AutoSize = False
      Caption = 'DBSpinEdit'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = 11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = False
      ColorFocus = clMaroon
    end
    object ExtColorCombo: TExtColorCombo
      Left = 120
      Top = 75
      Width = 221
      Height = 22
      HTMLcolor = '#FFFFFF'
      ColorReadOnly = clInfoText
      MyLabel = FWLabel1
      AlwaysSame = False
      Color = 11184810
      ItemHeight = 16
      TabOrder = 0
    end
    object ExtNumEdit1: TExtNumEdit
      Left = 120
      Top = 108
      Width = 221
      Height = 21
      EditMask = '#0,#9;0; '
      AlwaysSame = False
      ColorLabel = clMaroon
      ColorReadOnly = 5755391
      MyLabel = FWLabel2
      Color = 5755391
      MaxLength = 5
      ReadOnly = True
      TabOrder = 2
      Text = '0'
    end
    object FWDateEdit1: TFWDateEdit
      Left = 120
      Top = 134
      Width = 221
      Height = 21
      Date = 41029.366682106480000000
      Time = 41029.366682106480000000
      TabOrder = 3
      DropDownDate = 41298.000000000000000000
      ColorReadOnly = clInfoText
      MyLabel = FWLabel3
      AlwaysSame = False
    end
    object FWEdit: TFWEdit
      Left = 120
      Top = 160
      Width = 221
      Height = 21
      TabOrder = 4
      Text = 'FWEdit'
      MyLabel = FWLabel4
      AlwaysSame = False
    end
    object DBListView: TDBListView
      Left = 1
      Top = 329
      Width = 544
      Height = 233
      Align = alBottom
      Columns = <
        item
          Caption = 'Nom'
          MinWidth = 120
          Width = 157
        end
        item
          Caption = 'Prenom'
          Width = 13
        end>
      DragMode = dmAutomatic
      MultiSelect = True
      RowSelect = True
      TabOrder = 1
      ColumnsOrder = '0=157,1=13'
      Groups = <>
      ExtendedColumns = <
        item
        end
        item
        end>
      Datasource = ds_user
      DataKeyUnit = 'Clep'
      DataFieldsDisplay = 'Nom'
      DataTableUnit = 'UTILISATEUR'
    end
    object FWMemo: TFWMemo
      Left = 371
      Top = 48
      Width = 136
      Height = 128
      Color = 11184810
      Lines.Strings = (
        'FWMemo')
      TabOrder = 7
    end
    object ExtDBComboInsert2: TExtDBComboInsert
      Left = 120
      Top = 211
      Width = 221
      Height = 24
      DataField = 'IDDEPARTEMENT'
      DataSource = ds_user
      TabOrder = 6
      MyLabel = Search2
      SearchSource = ds_dep2
    end
    object ExtSearchDBEdit2: TExtSearchDBEdit
      Left = 120
      Top = 185
      Width = 221
      Height = 21
      Color = 11184810
      DataField = 'NOM'
      DataSource = ds_user
      MaxLength = 100
      TabOrder = 5
      SearchDisplay = 'NOM'
      SearchSource = ds_dep2
      MyLabel = Search
    end
    object ExtDBPictCombo: TExtDBPictCombo
      Left = 120
      Top = 290
      Width = 219
      Height = 22
      Images = ImageResources
      ImagesMap = MapImages
      Color = 11184810
      Items.Strings = (
        'Image'
        'Image'
        'Image'
        'Image'
        'Image'
        'Image'
        'Image')
      ItemHeight = 16
      TabOrder = 8
      DataField = 'ENTIER'
      DataSource = ds_user
    end
    object FWSpinEdit: TFWSpinEdit
      Left = 120
      Top = 240
      Width = 220
      Height = 21
      TabOrder = 10
      MyLabel = FWLabel8
    end
    object Panel3: TPanel
      Left = 371
      Top = 184
      Width = 104
      Height = 114
      Caption = 'Panel3'
      TabOrder = 9
      object ExtDBImage: TExtDBImage
        Left = 1
        Top = 1
        Width = 102
        Height = 112
        Cursor = crHandPoint
        Align = alClient
        Stretch = True
        OnClick = ExtDBImageClick
        Datafield = 'PHOTO'
        Datasource = ds_user
      end
    end
    object FWClose1: TFWClose
      Left = 395
      Top = 10
      Width = 70
      Height = 32
      Caption = 'Close'
      TabOrder = 11
    end
    object FWPrint: TFWPrintGrid
      Left = 471
      Top = 10
      Width = 70
      Height = 32
      Caption = 'Print'
      TabOrder = 12
      DBGrid = Noms
    end
  end
  object FWDBEdit1: TFWDBEdit
    Left = 365
    Top = 45
    Width = 221
    Height = 21
    DataField = 'Nom'
    DataSource = ds_user
    MaxLength = 100
    TabOrder = 2
    MyLabel = FWLabel5
    AlwaysSame = False
  end
  object FWDBEdit2: TFWDBEdit
    Left = 364
    Top = 16
    Width = 221
    Height = 21
    DataField = 'Prenom'
    DataSource = ds_user
    MaxLength = 100
    TabOrder = 1
    ColorReadOnly = clWhite
    MyLabel = FWLabel6
    AlwaysSame = False
  end
  object OnFormInfoIni: TOnFormInfoIni
    SaveEdits = [feTEdit, feTComboValue, feTColorCombo, feTDateEdit, feTMemo, feTSpinEdit]
    SaveForm = [sfSavePos, sfSaveSizes]
    Left = 56
    Top = 216
  end
  object ds_user: TDataSource
    DataSet = IBUtilisateur
    Left = 56
    Top = 360
  end
  object ds_dep: TDataSource
    DataSet = IBDepartement
    Left = 56
    Top = 432
  end
  object IBDatabase: TIBDatabase
    DatabaseName = 'Exemple'
    Params.Strings = (
      'user_name=SYSDBA'
      'lc_ctype=UTF8')
    LoginPrompt = False
    DefaultTransaction = IBTransaction
    TraceFlags = [tfBlob]
    AllowStreamedConnected = False
    BeforeConnect = IBDatabaseBeforeConnect
    Left = 56
    Top = 289
  end
  object IBUtilisateur: TIBQuery
    Database = IBDatabase
    Transaction = IBTransaction
    ParamCheck = False
    SQL.Strings = (
      'SELECT * FROM UTILISATEUR')
    UpdateObject = IBUpdateUtilisateur
    Left = 160
    Top = 360
  end
  object IBDepartement: TIBQuery
    Database = IBDatabase
    Transaction = IBTransaction
    ParamCheck = False
    SQL.Strings = (
      'SELECT * FROM DEPARTEMENT')
    UpdateObject = IBUpdateDepartem
    Left = 160
    Top = 432
  end
  object IBTransaction: TIBTransaction
    DefaultDatabase = IBDatabase
    Left = 160
    Top = 289
  end
  object IBDepSearch: TIBQuery
    Database = IBDatabase
    Transaction = IBTransaction
    ParamCheck = False
    SQL.Strings = (
      'SELECT * FROM DEPARTEMENT')
    Left = 160
    Top = 488
  end
  object ds_dep2: TDataSource
    DataSet = IBDepSearch
    Left = 56
    Top = 488
  end
  object ImageResources: TImageList
    Height = 24
    Width = 24
    Left = 56
    Top = 152
  end
  object MapImages: TExtMapImages
    Columns = <
      item
        Value = '1'
        ImageIndex = 0
      end
      item
        Value = '2'
        ImageIndex = 1
      end
      item
        Value = '3'
        ImageIndex = 2
      end
      item
        Value = '4'
        ImageIndex = 3
      end
      item
        Value = '6'
        ImageIndex = 5
      end
      item
        Value = '7'
        ImageIndex = 6
      end
      item
        Value = '8'
        ImageIndex = 7
      end>
    Left = 160
    Top = 160
  end
  object mu_MenuIni: TMainMenu
    Images = ImageResources
    Left = 56
    Top = 96
  end
  object mu_MainMenu: TMainMenu
    Images = ImageResources
    Left = 112
    Top = 32
    object mu_file: TMenuItem
      Caption = '&Application'
      HelpContext = 1420
      Hint = 'Fermeture des fen'#234'tres ou de l'#39'application'
      object mu_ouvrir: TMenuItem
        Caption = '&Ouvrir'
        HelpContext = 1420
        Hint = 'Ouvrir une fonction'
        Visible = False
      end
      object mu_sep1: TMenuItem
        Caption = '-'
      end
      object mu_quitter: TMenuItem
        Bitmap.Data = {
          36090000424D3609000000000000360000002800000018000000180000000100
          2000000000000009000064000000640000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000FF00FFFFEABA
          FEFFD0E8E8FFD6D9EAFFD7DBEBFFD7DBEBFFD7DBEBFFD7DBECFFD6DAECFFD6DC
          EDFFD6DAECFFD6DBECFFD7DAECFFD1E8E9FFECBBFFFFFF00FFFF000000000000
          0000000000000000000000000000000000000000000000000000EEBDFFFF0953
          C8FF00009BFF000EA7FF0011AAFF0011ABFF0010A9FF000FABFF000DAFFF000B
          B3FF000AB2FF0009B3FF000ABAFF000098FF0049BAFFEBBCFFFF000000000000
          0000000000000000000000000000000000000000000000000000CFEAF5FF000B
          C6FF2751E5FF2F55E4FF3458E2FF2C52E1FF274FE3FF2850E2FF224DE4FF1B49
          E4FF1247E7FF0E45E7FF0E43E7FF0D3FE0FF000099FFD1E7E9FF000000000000
          0000000000000000000000000000000000000000000000000000D7DDF7FF0020
          DAFF3356DFFF385BE1FF385AE2FF526FE5FF8B9EEDFFB1C0F4FFAFC0F3FF8097
          EDFF335BE4FF0B43E3FF0C42E1FF0D43E7FF0009BAFFD6D9ECFF000000000000
          0000000000000000000000000000000000000000000000000000D6DFF8FF0024
          D9FF3D5FE2FF3D5FE3FF6B84E9FFDCE3FAFFF1F2FCFFD0D8F7FFD0D8F7FFF1F3
          FCFFD2D8F6FF4068E8FF0A40E3FF0C42E5FF0008B5FFD6DAECFF000000000000
          0000000000000000000000000000000000000000000000000000D9DFF8FF0131
          DBFF4262E4FF5E79E8FFDDE4F9FFCED6F7FF5773E6FF3459E2FF3156E3FF476A
          E5FFCBD5F7FFD1D9F7FF2B57E6FF0B42E7FF000AB3FFD6DAECFF000000000000
          0000000000000000000000000000000000000000000000000000D9DEF8FF0A36
          DCFF4A68E5FF99A9F0FFF0F3FBFF5874E7FF3859E1FFADBCF2FFA7B7F3FF1A45
          DFFF3F62E4FFF0F1FBFF728FEDFF1447E7FF000EAFFFD7DBECFF000000000000
          0000000000000000000000000000000000000000000000000000DAE0F8FF153D
          DDFF5470E6FFC2CCF5FFD2DAF7FF2E51E1FF4665E4FFB8C4F5FFB3C0F3FF2C55
          E1FF002FDBFFD1D9F7FFA6B9F2FF1C48E4FF000FACFFD8DDECFF000000000000
          0000000000000000000000000000000000000000000000000000DBE1F9FF1F44
          DEFF5A76E8FFC5CDF5FFD0D8F7FF2E51E1FF4464E4FFB7C3F5FFB0BDF2FF2A52
          E0FF002EDBFFCFD8F8FFAABCF1FF244BE2FF000FAAFFD8DDEDFF000000000000
          0000000000000000000000000000000000000000000000000000DBE2F8FF2A4E
          E0FF627BE8FFA7B5EEFFEEF1FBFF5471E7FF3557E1FFABBAF2FFA3B2F0FF1641
          DDFF385CE2FFEEF0FBFF7F96ECFF264DE1FF0010AAFFD8DCEDFF000000000000
          0000000000000000000000000000000000000000000000000000DCE1F8FF3256
          E1FF6C85EAFF768FEAFFE4E9FAFFC8D2F6FF4F6CE6FF3356E1FF2D51DFFF3D5F
          E1FFC5CFF6FFD4DCF8FF3D62E5FF2C52E3FF0011AAFFD8DCEDFF000000000000
          0000000000000000000000000000000000000000000000000000DCE2F9FF3E60
          E4FF7D93ECFF6581EAFF8297EDFFE6EAF9FFEBEEFAFFC2CDF6FFC3CDF5FFECEF
          FBFFDAE1F9FF5372E5FF244CE0FF3457E1FF0011ABFFD8DCEDFF000000000000
          0000000000000000000000000000000000000000000000000000DDE2F8FF4F6D
          E7FF95A7EFFF7A91ECFF647FE9FF768EE8FFA7B4EBFFC5CEF6FFC3CDF5FF9AAA
          EFFF5B77E7FF375BE2FF3659E1FF3659E0FF0011ABFFD8DCEDFF000000000000
          0000000000000000000000000000000000000000000000000000DAF0F8FF5C76
          E7FFAEBDF3FF90A4EEFF7B92ECFF6D88ECFF6883E8FF6780E8FF647DE8FF5D77
          E7FF5872E6FF536FE6FF4868E4FF395EE4FF0005A5FFD0E7E9FF000000000000
          0000000000000000000000000000000000000000000000000000ECBBFCFF63A0
          E8FF5770E6FF4867E5FF3A5CE2FF3154E1FF2C50E0FF284DE0FF2349DEFF2046
          DDFF1C44DEFF143FDEFF0835DCFF001CCFFF175FD3FFECBDFFFF000000000000
          0000000000000000000000000000000000000000000000000000FF00FFFFECBC
          FDFFD8F0F8FFDCE1F8FFDCE2F9FFDBE1F9FFDAE0F9FFDCE2F9FFDAE1F8FFDAE1
          F8FFD9E0F9FFD9E0F8FFD9DFF8FFD1ECF4FFEDBCFDFFFF00FFFF000000000000
          0000000000000000000000000000000000000000000000000000}
        Caption = '&Quitter'
        HelpContext = 1420
        Hint = 'Quitter|Quitter l'#39'application'
        ImageIndex = 12
        ShortCut = 32883
        OnClick = mu_quitterClick
      end
    end
    object mu_aide: TMenuItem
      Caption = '&Aide'
      Hint = 'Rubriques d'#39'aide'
      object mu_sep2: TMenuItem
        Caption = '-'
      end
      object mu_apropos: TMenuItem
        Bitmap.Data = {
          36090000424D3609000000000000360000002800000018000000180000000100
          2000000000000009000064000000640000000000000000000000FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000003818181319A9A9A85AEAC
          ABC3CCC9C4EEEFEDEBFEEFEDEBFECCC9C4EEAEACABC39A9A9A85818181310000
          0003FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00000000014A4A4A0EAAA9A6C1EBE8E5FFCABCACFFB297
          78FF957045FF784912FF784912FF957045FFB29778FFCABCACFFEBE8E5FFAAA9
          A6C14A4A4A0E00000001FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF000000000387878751D9D6D3F7C5B4A0FF77470FFF713D00FF733E
          00FF733E00FF733E00FF723D00FF713C00FF6E3B00FF6E3B00FF77470FFFC4B3
          9FFFD9D6D3F78787875100000003FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00000000039F9D9BA1E9E5E1FE9D784DFF763F00FF794100FF7B4200FF7D43
          00FF7D4300FF7D4300FF7C4200FF7A4100FF774000FF733E00FF6F3C00FF6E3B
          00FF9A764DFFE9E5E1FE9F9D9BA100000003FFFFFF00FFFFFF00FFFFFF000000
          000187878751E9E5E1FE835016FF7C4200FF804500FF834600FF854800FF8748
          00FF927757FFDAD9D7FFB9B2AAFF834E12FF804500FF7C4200FF774000FF723D
          00FF6E3B00FF7B4C16FFE9E5E1FE8787875100000001FFFFFF00FFFFFF004A4A
          4A0ED9D6D3F7A37B4DFF814500FF864800FF8A4A00FF8D4C00FF904D00FF9052
          0AFFF3F3F3FFFFFFFFFFF9F9F9FFA39381FF884900FF844700FF7F4400FF7941
          00FF723D00FF6E3B00FF9A764DFFD9D6D3F74A4A4A0EFFFFFF0000000003ABA9
          A6C1C9B69FFF844700FF8A4A00FF8F4D00FF944F00FF975100FF9A5300FF9957
          0CFFF4F4F4FFFFFFFFFFFAFAFAFFA89987FF914E00FF8C4B00FF864800FF7F44
          00FF784100FF713D00FF6E3B00FFC4B39FFFAAA9A6C10000000381818131ECE9
          E5FE8D530FFF8D4C00FF934F00FF995200FF9E5500FFA25700FFA45800FFA559
          00FFA28768FFE8E7E6FFC8C3BDFF9A5D17FF995200FF934F00FF8D4B00FF8648
          00FF7E4400FF763F00FF6E3B00FF77470FFFEBE8E5FE818181319A9A9A85D0C0
          ACFF8E4C00FF965000FF9D5400FFA35700FFA85A00FFAC5C00FFAE5E00FFB05E
          00FFAF5E00FFAD5D00FFAA5B00FFA65900FFA05600FF9A5300FF934F00FF8B4B
          00FF834600FF7B4200FF723D00FF6E3B00FFCABCACFF9A9A9A85AEACABC3C2A0
          78FF965100FF9E5500FFA55900FFAC5C00FFB15F00FFB66100FFB86300FFBA64
          02FFB19E89FFCEC9C4FFC2BBB2FFA36E31FFA75A00FFA05600FF985200FF904D
          00FF884900FF7F4400FF763F00FF6E3B00FFB29778FFAEACABC3CECAC4EEB27F
          45FF9E5500FFA65900FFAE5D00FFB56100FFBB6400FFC06700FFC36800FFBC6C
          10FFFFFFFFFFFFFFFFFFFFFFFFFFC0B7ADFFAE5D00FFA65900FF9D5400FF9450
          00FF8B4B00FF824600FF794100FF6F3C00FF957045FFCCC9C4EEF0EEEBFEA360
          12FFA55800FFAE5D00FFB66200FFBE6600FFC46900FFCA6C00FFCD6E00FFCE6E
          00FFF0EFEFFFFFFFFFFFFFFFFFFFF3F3F3FFA57134FFAA5B00FFA15600FF9851
          00FF8E4C00FF854700FF7B4200FF713C00FF784912FFEFEDEBFEF0EEEBFEA963
          12FFAB5C00FFB56100FFBE6600FFC66A00FFCE6E00FFD37100FFD77300FFD774
          00FFB4997AFFFFFFFFFFFFFFFFFFFFFFFFFFEFEEEEFFA26E32FFA45800FF9A53
          00FF904D00FF864800FF7C4200FF723D00FF784912FFEFEDEBFECFCAC4EEBF86
          45FFB15F00FFBA6400FFC46900FFCE6E00FFD67300FFDD7700FFE17900FFE179
          00FFDB7701FFB8A58FFFFFFFFFFFFFFFFFFFFFFFFFFFF0EFEFFF9D6D35FF9B53
          00FF914E00FF874800FF7C4300FF723D00FF957045FFCCC9C4EEAFACABC3D1A8
          78FFB56100FFBF6700FFC96C00FFD37100FFDD7700FFBB8C57FFBAA082FFBC8D
          57FFD27B17FFD97400FFB49C82FFFFFFFFFFFFFFFFFFFFFFFFFFEEEDEDFF9A54
          05FF914E00FF864800FF7C4200FF723D00FFB29778FFAEACABC39A9A9A85DBC5
          ACFFB86300FFC26800FFCD6E00FFD77300FFC1823AFFFFFFFFFFFFFFFFFFFFFF
          FFFFC4B9ACFFD97500FFCE7001FFD2CEC9FFFFFFFFFFFFFFFFFFFFFFFFFF976E
          3EFF904D00FF854700FF7B4200FF703C00FFCABCACFF9A9A9A8581818131EFEA
          E5FEBD6C0FFFC46900FFCE6E00FFD87400FFD37B15FFFFFFFFFFFFFFFFFFFFFF
          FFFFF8F8F8FFB48F64FFB37D3FFFE5E3E2FFFFFFFFFFFFFFFFFFFFFFFFFF9465
          2EFF8E4C00FF834600FF794100FF77470FFFEBE8E5FE8181813100000003ADAA
          A6C1DDC09FFFC36800FFCD6E00FFD67300FFDE7700FFC4B9ACFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE3E2E1FF9451
          01FF8B4A00FF804500FF763F00FFC4B39FFFAAA9A6C100000003FFFFFF004A4A
          4A0EDDD8D3F7D3954DFFC96C00FFD17000FFD77400FFD3780EFFD2CDC8FFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEAEAE9FF966328FF914E
          00FF874800FF7D4300FF9D784DFFD9D6D3F74A4A4A0EFFFFFF00FFFFFF000000
          000187878751EFE8E1FEC97616FFCA6D00FFCF6F00FFD27100FFD17101FFB089
          5CFFBEB3A6FFD1CDC8FFDAD8D5FFC6C0B9FFA8937AFF9C5D13FF965000FF8C4B
          00FF824600FF845016FFE9E5E1FE8787875100000001FFFFFF00FFFFFF00FFFF
          FF0000000003A29F9BA1EFE8E1FED5964EFFC66A00FFC86B00FFC76B00FFC569
          00FFC06700FFBA6400FFB36000FFAB5C00FFA25700FF995200FF904D00FF8748
          00FFA57D4EFFE9E5E1FE9F9D9BA100000003FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF000000000387878751DDD9D3F7DFC2A1FFC27010FFBD6500FFBB64
          00FFB66200FFB15F00FFAA5B00FFA35700FF9B5300FF924E00FF915510FFCBB7
          A1FFDAD7D3F78787875100000003FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00000000014A4A4A0EAEAAA6C1EFEAE4FEDAC3A8FFD4A9
          76FFC38843FFAD6511FFA76111FFB58043FFC4A076FFCFBDA8FFECE8E4FEABA9
          A6C14A4A4A0E00000001FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000003818181319A9A9A85AFAC
          ABC3CFCBC4EEF1EEEBFEF0EEEBFECECAC4EEAEACABC39A9A9A85818181310000
          0003FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00}
        Caption = '&A propos...'
        HelpContext = 1420
        Hint = 
          'A propos|Afficher des informations sur le programme, le num'#233'ro d' +
          'e version et le copyright'
        ImageIndex = 15
        OnClick = mu_aproposClick
      end
    end
  end
  object IBUpdateUtilisateur: TIBUpdateSQL
    RefreshSQL.Strings = (
      'SELECT * FROM UTILISATEUR')
    ModifySQL.Strings = (
      'UPDATE UTILISATEUR SET NOM=:NOM,'
      '  PRENOM=:PRENOM,'
      '  IDDEPARTEMENT=:IDDEPARTEMENT,'
      '  PHOTO=:PHOTO, '
      '  ENTIER=:ENTIER'
      'WHERE CLEP=:CLEP')
    InsertSQL.Strings = (
      'INSERT INTO UTILISATEUR (NOM,'
      '  PRENOM,'
      '  IDDEPARTEMENT,'
      '  PHOTO, ENTIER) VALUES'
      '(:NOM,'
      '  :PRENOM,'
      '  :IDDEPARTEMENT,'
      '  :PHOTO, :ENTIER)')
    DeleteSQL.Strings = (
      'DELETE FROM UTILISATEUR WHERE CLEP = :CLEP')
    Left = 304
    Top = 360
  end
  object IBUpdateDepartem: TIBUpdateSQL
    RefreshSQL.Strings = (
      'SELECT * FROM DEPARTEMENT')
    ModifySQL.Strings = (
      'UPDATE DEPARTEMENT SET NOM=:NOM'
      'WHERE CLEP=:CLEP')
    InsertSQL.Strings = (
      'INSERT INTO DEPARTEMENT (NOM) VALUES'
      '(:NOM)')
    DeleteSQL.Strings = (
      'DELETE FROM DEPARTEMENT WHERE CLEP = :CLEP')
    Left = 304
    Top = 432
  end
end

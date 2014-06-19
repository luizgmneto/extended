object Myform: TMyform
  Left = 181
  Top = 29
  ActiveControl = Panel1
  Caption = 'Myform'
  ClientHeight = 564
  ClientWidth = 785
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = mu_MainMenu
  OldCreateOrder = True
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 208
    Top = 0
    Width = 5
    Height = 564
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 208
    Height = 564
    Align = alLeft
    Caption = 'Panel1'
    TabOrder = 0
    object Splitter3: TSplitter
      Left = 1
      Top = 374
      Width = 206
      Height = 3
      Cursor = crVSplit
      Align = alBottom
    end
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
      Height = 353
      Align = alClient
      Columns = <
        item
          Expanded = False
          FieldName = 'NOM'
          Title.Caption = 'Name'
          Width = 78
          Visible = True
          FieldTag = 0
          Resize = True
        end
        item
          Expanded = False
          FieldName = 'PRENOM'
          Title.Alignment = taCenter
          Title.Caption = 'Surname'
          Width = 78
          Visible = True
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
          Width = 78
          Visible = True
          FieldTag = 0
          Resize = True
        end
        item
          Expanded = False
          FieldName = 'PRENOM'
          Title.Alignment = taCenter
          Title.Caption = 'Surname'
          Width = 78
          Visible = True
          FieldTag = 0
          Resize = True
        end>
    end
    object Prenom: TExtFormatDBEdit
      Left = 7
      Top = 81
      Width = 221
      Height = 21
      DataField = 'PRENOM'
      DataSource = ds_user
      MaxLength = 100
      TabOrder = 2
      Visible = False
      MyLabel = FWLabel6
      AlwaysSame = False
    end
    object Nom: TExtFormatDBEdit
      Left = 7
      Top = 121
      Width = 221
      Height = 21
      DataField = 'NOM'
      DataSource = ds_user
      MaxLength = 100
      TabOrder = 3
      Visible = False
      MyLabel = FWLabel5
      AlwaysSame = False
    end
    object Panel5: TPanel
      Left = 1
      Top = 377
      Width = 206
      Height = 186
      Align = alBottom
      BevelOuter = bvNone
      Caption = 'Panel5'
      TabOrder = 4
    end
  end
  object Panel2: TPanel
    Left = 213
    Top = 0
    Width = 540
    Height = 564
    Align = alClient
    TabOrder = 3
    DesignSize = (
      540
      564)
    object FWLabel1: TFWLabel
      Left = 20
      Top = 115
      Width = 65
      Height = 17
      AutoSize = False
      Caption = 'Color'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = 14
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = False
      ColorFocus = clMaroon
    end
    object FWLabel2: TFWLabel
      Left = 22
      Top = 142
      Width = 65
      Height = 17
      AutoSize = False
      Caption = 'NumEdit'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = 14
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = False
      ColorFocus = clMaroon
    end
    object FWLabel3: TFWLabel
      Left = 20
      Top = 171
      Width = 65
      Height = 17
      AutoSize = False
      Caption = 'Date'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = 14
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = False
      ColorFocus = clMaroon
    end
    object FWLabel4: TFWLabel
      Left = 20
      Top = 197
      Width = 65
      Height = 17
      AutoSize = False
      Caption = 'Edit'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = 14
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
      Font.Height = 14
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
      Font.Height = 14
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = False
      ColorFocus = clMaroon
    end
    object Splitter2: TSplitter
      Left = 1
      Top = 342
      Width = 538
      Height = 3
      Cursor = crVSplit
      Align = alBottom
    end
    object Search: TFWLabel
      Left = 20
      Top = 220
      Width = 65
      Height = 15
      AutoSize = False
      Caption = 'City'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = 12
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
      Font.Height = 14
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
      Font.Height = 12
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
      FocusControl = FWDBSpinEdit
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
    object Search2: TFWLabel
      Left = 22
      Top = 72
      Width = 65
      Height = 15
      AutoSize = False
      Caption = 'User'#39's City'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = 12
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = False
      ColorFocus = clMaroon
    end
    object ExtColorCombo: TExtColorCombo
      Left = 121
      Top = 104
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
      Left = 121
      Top = 137
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
      Left = 121
      Top = 163
      Width = 221
      Height = 24
      Date = 41809.571487152770000000
      Time = 41809.571487152770000000
      TabOrder = 3
      DropDownDate = 41809.000000000000000000
      ColorReadOnly = clInfoText
      MyLabel = FWLabel3
      AlwaysSame = False
    end
    object FWEdit: TFWEdit
      Left = 121
      Top = 189
      Width = 221
      Height = 21
      TabOrder = 4
      Text = 'FWEdit'
      MyLabel = FWLabel4
      AlwaysSame = False
    end
    object DBListView: TDBListView
      Left = 1
      Top = 345
      Width = 538
      Height = 218
      Align = alBottom
      Columns = <
        item
          Caption = 'Nom'
          MinWidth = 120
          Width = 120
        end
        item
          Caption = 'Prenom'
          Width = 398
        end>
      DragMode = dmAutomatic
      MultiSelect = True
      RowSelect = True
      TabOrder = 1
      ColumnsOrder = '0=120,1=398'
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
      Width = 162
      Height = 128
      Anchors = [akLeft, akTop, akRight]
      Color = 11184810
      Lines.Strings = (
        'FWMemo')
      TabOrder = 6
    end
    object ExtSearchEdit2: TExtSearchEdit
      Left = 121
      Top = 214
      Width = 221
      Height = 21
      MaxLength = 100
      TabOrder = 5
      MyLabel = Search
      SearchDisplay = 'NOM'
      SearchSource = ds_dep2
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
      TabOrder = 7
      DataField = 'ENTIER'
      DataSource = ds_user
    end
    object FWSpinEdit: TFWSpinEdit
      Left = 120
      Top = 240
      Width = 220
      Height = 21
      Value = 1.000000000000000000
      TabOrder = 8
      MyLabel = FWLabel8
    end
    object FWDBSpinEdit: TFWDBSpinEdit
      Left = 120
      Top = 265
      Width = 219
      Height = 21
      MaxValue = 100.000000000000000000
      TabOrder = 9
      DataField = 'ENTIER'
      DataSource = ds_user
    end
    object Panel3: TPanel
      Left = 371
      Top = 184
      Width = 130
      Height = 114
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 10
      object ExtDBImage: TExtDBImage
        Left = 2
        Top = 2
        Width = 126
        Height = 110
        Cursor = crHandPoint
        Align = alCustom
        Anchors = [akLeft, akTop, akRight, akBottom]
        Stretch = True
        OnClick = ExtDBImageClick
        Datafield = 'PHOTO'
        Datasource = ds_user
      end
    end
    object FWClose1: TFWClose
      Left = 347
      Top = 9
      Height = 32
      Caption = 'Close'
      TabOrder = 11
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object FWPrint: TFWPrintGrid
      Left = 427
      Top = 9
      Width = 96
      Height = 32
      Caption = 'Print'
      TabOrder = 13
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      DBTitle = 'Users'
      DBGrid = Noms
    end
    object ExtDBComboInsert2: TExtDBComboInsert
      Left = 121
      Top = 64
      Width = 221
      Height = 21
      TabOrder = 12
      MyLabel = Search2
      SearchDisplay = 'NOM'
      SearchList = 'NOM'
      SearchSource = ds_dep2
      DataSource = ds_user
      SearchKey = 'CLEP'
      DataField = 'IDDEPARTEMENT'
    end
  end
  object FWDBEdit1: TExtFormatDBEdit
    Left = 333
    Top = 40
    Width = 221
    Height = 21
    DataField = 'Nom'
    DataSource = ds_user
    MaxLength = 100
    TabOrder = 2
    MyLabel = FWLabel5
    AlwaysSame = False
    ModeFormat = mftFirstCharOfWordsIsMaj
  end
  object FWDBEdit2: TExtFormatDBEdit
    Left = 333
    Top = 16
    Width = 221
    Height = 21
    DataField = 'Prenom'
    DataSource = ds_user
    TabOrder = 1
    ColorReadOnly = clWhite
    MyLabel = FWLabel6
    AlwaysSame = False
    ModeFormat = mftUpper
  end
  object ExtMenuToolBar: TExtMenuToolBar
    Left = 753
    Top = 0
    Width = 32
    Height = 564
    Align = alRight
    AutoSize = False
    ButtonHeight = 30
    ButtonWidth = 31
    Caption = 'ExtMenuToolBar'
    Images = ImageResources
    Menu = mu_MenuIni
    ParentShowHint = False
    ShowCaptions = False
    ShowHint = False
    TabOrder = 4
    OnClickCustomize = ExtMenuToolBarClickCustomize
  end
  object OnFormInfoIni: TOnFormInfoIni
    SaveEdits = [feTEdit, feTComboValue, feTDateEdit, feTMemo, feTSpinEdit]
    SaveForm = [sfSavePos, sfSaveSize, sfSaveSizes]
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
    Params.Strings = (
      'user_name=SYSDBA'
      'password=masterkey')
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
    BufferChunks = 2
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
    UpdateObject = IBUpdateDepartem
    Left = 160
    Top = 488
  end
  object ds_dep2: TDataSource
    DataSet = IBDepSearch
    Left = 56
    Top = 488
  end
  object OpenPictureDialog: TOpenPictureDialog
    Left = 160
    Top = 216
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
    Top = 152
  end
  object mc_Customize: TExtMenuCustomize
    MenuIni = mu_MenuIni
    MainMenu = mu_MainMenu
    OnMenuChange = mc_CustomizeMenuChange
    Left = 160
    Top = 96
  end
  object mu_MenuIni: TMainMenu
    Images = ImageResources
    Left = 56
    Top = 96
  end
  object mu_MainMenu: TMainMenu
    Images = ImageResources
    Left = 96
    Top = 32
    object mu_file: TMenuItem
      Caption = '&Application'
      HelpContext = 1420
      Hint = 'Fermeture des fen'#195#170'tres ou de l'#39'application'
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
        Caption = '&A propos...'
        HelpContext = 1420
        Hint = 
          'A propos|Afficher des informations sur le programme, le num'#195#169'ro ' +
          'de version et le copyright'
        ImageIndex = 15
        OnClick = mu_aproposClick
      end
    end
  end
  object IBUpdateUtilisateur: TIBUpdateSQL
    RefreshSQL.Strings = (
      'SELECT * FROM UTILISATEUR'
      'WHERE CLEP=:CLEP')
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
      'SELECT * FROM DEPARTEMENT'
      'WHERE CLEP=:CLEP')
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

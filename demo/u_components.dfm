object Myform: TMyform
  Left = 404
  Top = 213
  ActiveControl = Panel1
  Caption = 'Myform'
  ClientHeight = 560
  ClientWidth = 751
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MenuIni
  OldCreateOrder = False
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 208
    Top = 19
    Width = 5
    Height = 541
    ExplicitTop = 0
    ExplicitHeight = 560
  end
  object Panel1: TPanel
    Left = 0
    Top = 19
    Width = 208
    Height = 541
    Align = alLeft
    Caption = 'Panel1'
    TabOrder = 0
    object ExtDBNavigator1: TExtDBNavigator
      Left = 1
      Top = 1
      Width = 206
      Height = 20
      DataSource = Datasource
      DeleteQuestion = 'Confirmez-vous l'#39'effacement de l'#39'enregistrement ?'
      Align = alTop
      TabOrder = 0
      Orientation = noHorizontal
      GlyphSize = gsSmall
    end
    object Noms: TExtDBGrid
      Left = 1
      Top = 21
      Width = 206
      Height = 519
      Align = alClient
      Columns = <
        item
          Expanded = False
          FieldName = 'NOM'
          Title.Caption = 'Name'
          Width = 88
          Visible = True
          FieldTag = 0
        end
        item
          Expanded = False
          FieldName = 'PRENOM'
          Title.Alignment = taCenter
          Title.Caption = 'Surname'
          Width = 88
          Visible = True
          FieldTag = 0
        end>
      DataSource = Datasource
      TabOrder = 1
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
      Columns = <
        item
          Expanded = False
          FieldName = 'NOM'
          Title.Caption = 'Name'
          Width = 88
          Visible = True
          FieldTag = 0
        end
        item
          Expanded = False
          FieldName = 'PRENOM'
          Title.Alignment = taCenter
          Title.Caption = 'Surname'
          Width = 88
          Visible = True
          FieldTag = 0
        end>
    end
    object Prenom: TFWDBEdit
      Left = 7
      Top = 81
      Width = 221
      Height = 21
      Color = clMoneyGreen
      DataField = 'PRENOM'
      DataSource = Datasource
      MaxLength = 100
      TabOrder = 2
      MyLabel = Search2
      AlwaysSame = False
    end
    object Nom: TFWDBEdit
      Left = 7
      Top = 121
      Width = 221
      Height = 21
      Color = clMoneyGreen
      DataField = 'NOM'
      DataSource = Datasource
      MaxLength = 100
      TabOrder = 3
      MyLabel = Search
      AlwaysSame = False
    end
  end
  object Panel2: TPanel
    Left = 213
    Top = 19
    Width = 538
    Height = 541
    Align = alClient
    TabOrder = 1
    object Splitter2: TSplitter
      Left = 1
      Top = 327
      Width = 536
      Height = 3
      Cursor = crVSplit
      Align = alBottom
      ExplicitTop = 320
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
      Font.Color = clBlack
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
      Top = 64
      Width = 65
      Height = 17
      AutoSize = False
      Caption = 'Name'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = 14
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = False
      ColorFocus = clMaroon
    end
    object FWLabel1: TFWLabel
      Left = 19
      Top = 108
      Width = 65
      Height = 17
      AutoSize = False
      Caption = 'Color'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = 10
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = False
      ColorFocus = clMaroon
    end
    object FWLabel2: TFWLabel
      Left = 19
      Top = 143
      Width = 65
      Height = 17
      AutoSize = False
      Caption = 'NumEdit'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = 10
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = False
      ColorFocus = clMaroon
    end
    object FWLabel3: TFWLabel
      Left = 19
      Top = 177
      Width = 65
      Height = 17
      AutoSize = False
      Caption = 'Date'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = 10
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = False
      ColorFocus = clMaroon
    end
    object FWLabel4: TFWLabel
      Left = 19
      Top = 211
      Width = 65
      Height = 17
      AutoSize = False
      Caption = 'Edit'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = 10
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = False
      ColorFocus = clMaroon
    end
    object Search: TFWLabel
      Left = 19
      Top = 243
      Width = 65
      Height = 15
      AutoSize = False
      Caption = 'Department'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = 10
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = False
      ColorFocus = clMaroon
    end
    object Search2: TFWLabel
      Left = 21
      Top = 280
      Width = 65
      Height = 15
      AutoSize = False
      Caption = 'City'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = 12
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = False
      ColorFocus = clMaroon
    end
    object DBListView: TDBListView
      Left = 1
      Top = 330
      Width = 536
      Height = 210
      Align = alBottom
      Columns = <
        item
          Caption = 'Nom'
          MinWidth = 120
          Width = 120
        end
        item
          Caption = 'Prenom'
          Width = 414
        end>
      DragMode = dmAutomatic
      MultiSelect = True
      RowSelect = True
      TabOrder = 0
      ColumnsOrder = '0=120,1=414'
      Groups = <>
      ExtendedColumns = <
        item
        end
        item
        end>
      Datasource = Datasource2
      DataKeyUnit = 'Clep'
      DataFieldsDisplay = 'Nom'
      DataTableUnit = 'UTILISATEUR'
      ExplicitTop = 320
    end
    object FWDBEdit2: TFWDBEdit
      Left = 120
      Top = 17
      Width = 221
      Height = 21
      Color = clMoneyGreen
      DataField = 'Prenom'
      DataSource = Datasource
      MaxLength = 100
      TabOrder = 1
      ColorReadOnly = clWhite
      MyLabel = Search2
      AlwaysSame = False
    end
    object FWDBEdit1: TFWDBEdit
      Left = 120
      Top = 56
      Width = 221
      Height = 21
      Color = clMoneyGreen
      DataField = 'Nom'
      DataSource = Datasource
      MaxLength = 100
      TabOrder = 2
      MyLabel = Search
      AlwaysSame = False
    end
    object ExtColorCombo: TExtColorCombo
      Left = 120
      Top = 96
      Width = 221
      Height = 22
      Language = lgEnglish
      HTMLcolor = '#FFFFFF'
      ColorReadOnly = clInfoText
      MyLabel = FWLabel1
      AlwaysSame = False
      Color = clMoneyGreen
      ItemHeight = 16
      TabOrder = 3
    end
    object ExtNumEdit1: TExtNumEdit
      Left = 118
      Top = 133
      Width = 221
      Height = 21
      EditMask = '#0,#9;0; '
      AlwaysSame = False
      ColorLabel = clMaroon
      ColorReadOnly = clInfoText
      MyLabel = FWLabel2
      Color = clInfoText
      MaxLength = 5
      ReadOnly = True
      TabOrder = 4
    end
    object FWDateEdit1: TFWDateEdit
      Left = 118
      Top = 166
      Width = 221
      Height = 24
      Date = 40708.540152222210000000
      Time = 40708.540152222210000000
      Color = clMoneyGreen
      TabOrder = 5
      ColorReadOnly = clInfoText
      MyLabel = FWLabel3
      AlwaysSame = False
    end
    object FWEdit: TFWEdit
      Left = 118
      Top = 201
      Width = 221
      Height = 21
      Color = clMoneyGreen
      TabOrder = 6
      Text = 'FWEdit'
      MyLabel = FWLabel4
      AlwaysSame = False
    end
    object ExtSearchDBEdit2: TExtSearchDBEdit
      Left = 118
      Top = 236
      Width = 221
      Height = 21
      Color = clMoneyGreen
      DataField = 'NOM'
      DataSource = Datasource
      MaxLength = 100
      TabOrder = 7
      SearchDisplay = 'NOM'
      SearchKey = 'CLEP'
      SearchSource = Datasource3
      MyLabel = Search
    end
    object ExtDBComboInsert2: TExtDBComboInsert
      Left = 118
      Top = 268
      Width = 221
      Height = 27
      Color = clMoneyGreen
      DataField = 'IDDEPARTEMENT'
      DataSource = Datasource
      ReadOnly = True
      TabOrder = 8
      MyLabel = Search2
      SearchSource = Datasource3
    end
    object FWMemo: TFWMemo
      Left = 371
      Top = 16
      Width = 136
      Height = 214
      Color = clMoneyGreen
      Lines.Strings = (
        'FWMemo')
      TabOrder = 9
    end
  end
  object ExtMenuToolBar: TExtMenuToolBar
    Left = 0
    Top = 0
    Width = 751
    Height = 19
    AutoSize = False
    ButtonWidth = 76
    Caption = 'ExtMenuToolBar'
    DisabledImages = ImageListDisabled
    List = False
    Menu = MenuIni
    TabOrder = 2
    OnClickCustomize = ExtMenuToolBarClickCustomize
  end
  object OnFormInfoIni: TOnFormInfoIni
    SauvePosObjects = True
    SauveEditObjets = [feTEdit, feTComboValue, feTColorCombo, feTDateEdit, feTMemo]
    SauvePosForm = True
    Left = 48
    Top = 152
  end
  object Datasource: TDataSource
    DataSet = IBUtilisateur
    Left = 48
    Top = 288
  end
  object Datasource2: TDataSource
    DataSet = IBDepartement
    Left = 48
    Top = 360
  end
  object IBDatabase: TIBDatabase
    DatabaseName = '/var/lib/firebird/2.1/data/Exemple2.fdb'
    Params.Strings = (
      'user_name=SYSDBA'
      'password=masterkey')
    LoginPrompt = False
    AllowStreamedConnected = False
    Left = 48
    Top = 216
  end
  object IBUtilisateur: TIBDataSet
    Database = IBDatabase
    Transaction = IBTransaction
    DeleteSQL.Strings = (
      'Delete From UTILISATEUR A'
      'Where A.CLEP = :CLEP')
    InsertSQL.Strings = (
      'Insert Into UTILISATEUR(CLEP, NOM, PRENOM, IDDEPARTEMENT)'
      'Values(:CLEP, :NOM, :PRENOM, :IDDEPARTEMENT)')
    RefreshSQL.Strings = (
      
        'Select A.CLEP, A.NOM, A.PRENOM, A.IDDEPARTEMENT From UTILISATEUR' +
        ' A'
      'Where A.CLEP = :CLEP')
    SelectSQL.Strings = (
      
        'Select A.CLEP, A.NOM, A.PRENOM, A.IDDEPARTEMENT From UTILISATEUR' +
        ' A')
    ModifySQL.Strings = (
      'Update UTILISATEUR A Set '
      '  A.CLEP = :CLEP,'
      '  A.NOM = :NOM,'
      '  A.PRENOM = :PRENOM,'
      '  A.IDDEPARTEMENT = :IDDEPARTEMENT'
      'Where A.CLEP = :OLD_CLEP')
    Left = 152
    Top = 288
  end
  object IBDepartement: TIBDataSet
    Database = IBDatabase
    Transaction = IBTransaction
    DeleteSQL.Strings = (
      'Delete From DEPARTEMENT A'
      'Where A.CLEP = :CLEP')
    InsertSQL.Strings = (
      'Insert Into DEPARTEMENT(CLEP, NOM)'
      'Values(:CLEP, :NOM)')
    RefreshSQL.Strings = (
      'Select A.CLEP, A.NOM From DEPARTEMENT A'
      'Where A.CLEP = :CLEP')
    SelectSQL.Strings = (
      'Select A.CLEP, A.NOM From DEPARTEMENT A')
    ModifySQL.Strings = (
      'Update DEPARTEMENT A Set '
      '  A.CLEP = :CLEP,'
      '  A.NOM = :NOM'
      'Where A.CLEP = :OLD_CLEP')
    Left = 152
    Top = 361
  end
  object IBTransaction: TIBTransaction
    DefaultDatabase = IBDatabase
    Left = 152
    Top = 217
  end
  object IBDepSearch: TIBDataSet
    Database = IBDatabase
    Transaction = IBTransaction
    DeleteSQL.Strings = (
      'Delete From DEPARTEMENT A'
      'Where A.CLEP = :CLEP')
    InsertSQL.Strings = (
      'Insert Into DEPARTEMENT(CLEP, NOM)'
      'Values(:CLEP, :NOM)')
    RefreshSQL.Strings = (
      'Select A.CLEP, A.NOM From DEPARTEMENT A'
      'Where A.CLEP = :CLEP')
    SelectSQL.Strings = (
      'Select A.CLEP, A.NOM From DEPARTEMENT A')
    ModifySQL.Strings = (
      'Update DEPARTEMENT A Set '
      '  A.CLEP = :CLEP,'
      '  A.NOM = :NOM'
      'Where A.CLEP = :OLD_CLEP')
    Left = 152
    Top = 425
  end
  object Datasource3: TDataSource
    DataSet = IBDepSearch
    Left = 48
    Top = 424
  end
  object ExtMenuCustomize: TExtMenuCustomize
    MenuIni = MenuIni
    MainMenu = MainMenu
    Left = 152
    Top = 152
  end
  object MenuIni: TMainMenu
    Images = ImageList
    Left = 48
    Top = 80
  end
  object MainMenu: TMainMenu
    Images = ImageList
    Left = 152
    Top = 80
    object Menu1: TMenuItem
      Caption = 'Menu1'
      object Menu2: TMenuItem
        Caption = 'Menu2'
        OnClick = ExtMenuToolBarClickCustomize
      end
      object Menu3: TMenuItem
        Caption = 'Menu3'
        OnClick = ExtMenuToolBarClickCustomize
      end
      object Menu5: TMenuItem
        Caption = 'Menu5'
        OnClick = ExtMenuToolBarClickCustomize
      end
    end
    object Menu4: TMenuItem
      Caption = 'Menu4'
      object Menu6: TMenuItem
        Caption = 'Menu6'
        OnClick = ExtMenuToolBarClickCustomize
      end
    end
  end
  object ImageList: TImageList
    Left = 48
    Top = 472
  end
  object ImageListDisabled: TImageList
    Left = 152
    Top = 472
  end
end

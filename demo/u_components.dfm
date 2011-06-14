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
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 208
    Top = 0
    Width = 5
    Height = 560
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 208
    Height = 560
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
      Height = 538
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
      MyLabel = FWLabel6
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
      MyLabel = FWLabel5
      AlwaysSame = False
    end
  end
  object Panel2: TPanel
    Left = 213
    Top = 0
    Width = 538
    Height = 560
    Align = alClient
    TabOrder = 3
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
    object Splitter2: TSplitter
      Left = 1
      Top = 320
      Width = 536
      Height = 3
      Cursor = crVSplit
      Align = alBottom
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
      TabOrder = 0
    end
    object ExtNumEdit1: TExtNumEdit
      Left = 118
      Top = 133
      Width = 221
      Height = 21
      AlwaysSame = False
      ColorLabel = clMaroon
      ColorReadOnly = clInfoText
      MyLabel = FWLabel2
      Color = clInfoText
      ReadOnly = True
      TabOrder = 2
    end
    object FWDateEdit1: TFWDateEdit
      Left = 118
      Top = 166
      Width = 221
      Height = 24
      Date = 40708.540152222220000000
      Time = 40708.540152222220000000
      Color = clMoneyGreen
      TabOrder = 3
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
      TabOrder = 4
      Text = 'FWEdit'
      MyLabel = FWLabel4
      AlwaysSame = False
    end
    object DBListView: TDBListView
      Left = 1
      Top = 323
      Width = 536
      Height = 236
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
      TabOrder = 1
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
    end
    object FWMemo: TFWMemo
      Left = 371
      Top = 16
      Width = 136
      Height = 214
      Color = clMoneyGreen
      Lines.Strings = (
        'FWMemo')
      TabOrder = 5
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
      TabOrder = 7
      MyLabel = Search2
      SearchSource = Datasource3
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
      TabOrder = 6
      SearchDisplay = 'NOM'
      SearchKey = 'CLEP'
      SearchSource = Datasource3
      MyLabel = Search
    end
  end
  object FWDBEdit1: TFWDBEdit
    Left = 333
    Top = 56
    Width = 221
    Height = 21
    Color = clMoneyGreen
    DataField = 'Nom'
    DataSource = Datasource
    MaxLength = 100
    TabOrder = 2
    MyLabel = FWLabel5
    AlwaysSame = False
  end
  object FWDBEdit2: TFWDBEdit
    Left = 333
    Top = 16
    Width = 221
    Height = 21
    Color = clMoneyGreen
    DataField = 'Prenom'
    DataSource = Datasource
    MaxLength = 100
    TabOrder = 1
    ColorReadOnly = clWhite
    MyLabel = FWLabel6
    AlwaysSame = False
  end
  object OnFormInfoIni: TOnFormInfoIni
    SauvePosObjects = True
    SauveEditObjets = [feTEdit, feTComboValue, feTColorCombo, feTDateEdit, feTMemo]
    SauvePosForm = True
    Left = 80
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
end

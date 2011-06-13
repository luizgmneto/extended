object Myform: TMyform
  Left = 550
  Top = 312
  ActiveControl = Panel1
  Caption = 'Myform'
  ClientHeight = 533
  ClientWidth = 738
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
    Height = 533
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 208
    Height = 533
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
      Height = 511
      Align = alClient
      Columns = <
        item
          Expanded = False
          FieldName = 'NOM'
          Title.Alignment = taCenter
          Title.Caption = 'Noms'
          Width = 88
          Visible = True
          FieldTag = 0
        end
        item
          Expanded = False
          FieldName = 'PRENOM'
          Title.Alignment = taCenter
          Title.Caption = 'Pr'#233'noms'
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
          Title.Alignment = taCenter
          Title.Caption = 'Noms'
          Width = 88
          Visible = True
          FieldTag = 0
        end
        item
          Expanded = False
          FieldName = 'PRENOM'
          Title.Alignment = taCenter
          Title.Caption = 'Pr'#233'noms'
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
      DataField = 'Prenom'
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
      DataField = 'Nom'
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
    Width = 525
    Height = 533
    Align = alClient
    TabOrder = 1
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
      ColorFocus = clMaroon
    end
    object FWLabel5: TFWLabel
      Left = 21
      Top = 64
      Width = 65
      Height = 17
      AutoSize = False
      Caption = 'Nom'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = 10
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      ColorFocus = clMaroon
    end
    object FWLabel6: TFWLabel
      Left = 21
      Top = 24
      Width = 65
      Height = 17
      AutoSize = False
      Caption = 'Prenom'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = 10
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      ColorFocus = clMaroon
    end
    object Splitter2: TSplitter
      Left = 1
      Top = 312
      Width = 523
      Height = 5
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
      ColorFocus = clMaroon
    end
    object Search: TFWLabel
      Left = 19
      Top = 243
      Width = 65
      Height = 15
      AutoSize = False
      Caption = 'Postal Code'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = 12
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      ColorFocus = clMaroon
    end
    object ExtColorCombo: TExtColorCombo
      Left = 118
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
      Color = clMoneyGreen
      TabOrder = 1
    end
    object FWDateEdit1: TFWDateEdit
      Left = 118
      Top = 166
      Width = 221
      Height = 27
      Date = 40655.608620648150000000
      Time = 40655.608620648150000000
      Color = clMoneyGreen
      TabOrder = 2
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
      TabOrder = 3
      Text = 'FWEdit'
      MyLabel = FWLabel4
      AlwaysSame = False
    end
    object DBListView: TDBListView
      Left = 1
      Top = 317
      Width = 523
      Height = 215
      Align = alBottom
      Columns = <
        item
          Caption = 'Nom'
          MinWidth = 120
          Width = 120
        end
        item
          Caption = 'Prenom'
          Width = 385
        end>
      DragMode = dmAutomatic
      MultiSelect = True
      RowSelect = True
      TabOrder = 4
      ColumnsOrder = '0=120,1=385'
      Groups = <>
      ExtendedColumns = <
        item
        end
        item
        end>
      Datasource = Datasource
      DataKeyUnit = 'Cle'
      DataFieldsDisplay = 'Nom;Prenom'
      DataTableUnit = 'fiches.dbf'
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
      Left = 120
      Top = 272
      Width = 221
      Height = 29
      Color = clMoneyGreen
      DataField = 'VILLE'
      DataSource = Datasource
      TabOrder = 7
      MyLabel = Search2
    end
    object ExtSearchDBEdit2: TExtSearchDBEdit
      Left = 118
      Top = 236
      Width = 221
      Height = 21
      Color = clMoneyGreen
      DataField = 'POSTAL'
      DataSource = Datasource
      MaxLength = 100
      TabOrder = 6
      SearchDisplay = 'CODEPOSTAL'
      SearchSource = Datasource2
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
    TabOrder = 3
    MyLabel = FWLabel6
    AlwaysSame = False
  end
  object OnFormInfoIni: TOnFormInfoIni
    SauvePosObjects = True
    SauveEditObjets = [feTEdit, feTComboValue, feTDateEdit, feTMemo]
    SauvePosForm = True
    Left = 80
    Top = 176
  end
  object DbfNoms: TDbf
    Exclusive = True
    FilePath = 
      '/home/matthieu/Bureau/Matthieu/Programmation/Lazarus Delphi/Exte' +
      'nded/demo/\'
    IndexDefs = <
      item
        IndexFile = 'NOMS'
        SortField = 'NOM'
        Options = [ixCaseInsensitive]
      end>
    StoreDefs = True
    TableName = 'fiches.dbf'
    TableLevel = 4
    FieldDefs = <
      item
        Name = 'NOM'
        DataType = ftString
        Precision = -1
        Size = 100
      end
      item
        Name = 'PRENOM'
        DataType = ftString
        Precision = -1
        Size = 100
      end
      item
        Name = 'POSTAL'
        DataType = ftInteger
        Precision = -1
      end
      item
        Name = 'VILLE'
        DataType = ftString
        Precision = -1
        Size = 100
      end>
    FilterOptions = [foCaseInsensitive, foNoPartialCompare]
    Left = 136
    Top = 288
  end
  object Datasource: TDataSource
    DataSet = DbfNoms
    Left = 48
    Top = 288
  end
  object Datasource2: TDataSource
    DataSet = Villes
    Left = 48
    Top = 360
  end
  object Villes: TDbf
    FilePath = 
      '/home/matthieu/Bureau/Matthieu/Programmation/Lazarus Delphi/Exte' +
      'nded/demo/\'
    IndexDefs = <>
    ReadOnly = True
    TableName = 'cp.dbf'
    TableLevel = 25
    Left = 139
    Top = 360
  end
end
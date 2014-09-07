object F_Article: TF_Article
  Left = -8
  Top = -8
  Align = alClient
  Caption = 'Cat'#233'gorie'
  ClientHeight = 578
  ClientWidth = 1024
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  WindowState = wsMaximized
  OnCreate = F_FormDicoCreate
  ExplicitWidth = 320
  ExplicitHeight = 240
  PixelsPerInch = 96
  TextHeight = 13
  object pa_1: TPanel
    Left = 0
    Top = 26
    Width = 1024
    Height = 552
    Align = alClient
    BevelOuter = bvLowered
    TabOrder = 0
    object spl_1: TSplitter
      Left = 297
      Top = 1
      Width = 5
      Height = 550
    end
    object pa_3: TPanel
      Left = 302
      Top = 1
      Width = 721
      Height = 550
      Align = alClient
      BevelOuter = bvNone
      Constraints.MinWidth = 10
      TabOrder = 0
      object lb_codecateg: TFWLabel
        Tag = 1001
        Left = 26
        Top = 46
        Width = 83
        Height = 16
        AutoSize = False
        BiDiMode = bdLeftToRight
        Caption = 'Cl'#233
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = 12
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentBiDiMode = False
        ParentColor = False
        ParentFont = False
        ColorFocus = clMaroon
      end
      object lb_libelcateg: TFWLabel
        Tag = 1002
        Left = 32
        Top = 68
        Width = 77
        Height = 16
        AutoSize = False
        Caption = 'Libell'#233
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = 12
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        ColorFocus = clMaroon
      end
      object lb_gamme: TFWLabel
        Tag = 1002
        Left = 32
        Top = 96
        Width = 77
        Height = 16
        AutoSize = False
        Caption = 'Gamme'
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = 12
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        ColorFocus = clMaroon
      end
      object lb_typart: TFWLabel
        Tag = 1002
        Left = 32
        Top = 124
        Width = 77
        Height = 16
        AutoSize = False
        Caption = 'Type d'#39'article'
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = 11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        ColorFocus = clMaroon
      end
      object lb_libelcateg3: TFWLabel
        Tag = 1002
        Left = 32
        Top = 152
        Width = 77
        Height = 16
        AutoSize = False
        Caption = 'Cat'#233'gonie'
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = 12
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        ColorFocus = clMaroon
      end
      object pa_5: TPanel
        Left = 0
        Top = 0
        Width = 721
        Height = 32
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 2
        object nv_saisie: TExtDBNavigator
          Left = 0
          Top = 0
          Width = 721
          Height = 32
          Flat = True
          DataSource = M_Article.ds_article
          DeleteQuestion = 'Confirmez-vous l'#39'effacement de l'#39'enregistrement ?'
          Align = alClient
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          VisibleButtons = [nbEInsert, nbEDelete, nbEPost, nbECancel, nbESearch]
          GlyphSize = gsLarge
          Hints.Strings = (
            'Premier enregistrement'
            'Enregistrement pr'#233'c'#233'dent'
            'Enregistrement suivant'
            'Dernier enregistrement'
            'Ins'#233'rer enregistrement'
            'Supprimer l'#39'enregistrement'
            'Modifier l'#39'enregistrement'
            'Valider modifications'
            'Annuler les modifications'
            'Rafra'#238'chir les donn'#233'es'
            'Rechercher un enregistrement')
        end
      end
      object ed_libelcateg: TFWDBEdit
        Tag = 2
        Left = 128
        Top = 64
        Width = 190
        Height = 24
        DataField = 'ARTI_Libcom'
        DataSource = M_Article.ds_article
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
      end
      object ed_codecateg: TFWDBEdit
        Tag = 1
        Left = 128
        Top = 36
        Width = 34
        Height = 24
        DataField = 'ARTI_Clep'
        DataSource = M_Article.ds_article
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        TabOrder = 0
      end
      object cb_Categ: TExtDBComboInsert
        Left = 128
        Top = 93
        Width = 218
        Height = 21
        TabOrder = 3
        MyLabel = lb_gamme
        SearchDisplay = 'GAMM_Libelle'
        SearchList = 'GAMM_Libelle'
        SearchSource = M_Article.ds_Gamme
        DataSource = M_Article.ds_article
        SearchKey = 'GAMM_Clep'
        DataField = 'ARTI__GAMM'
      end
      object cb_Categ1: TExtDBComboInsert
        Left = 128
        Top = 121
        Width = 218
        Height = 21
        TabOrder = 4
        MyLabel = lb_typart
        SearchDisplay = 'TYPR_LIBELLE'
        SearchList = 'TYPR_LIBELLE'
        SearchSource = M_Article.ds_typearti
        DataSource = M_Article.ds_article
        SearchKey = 'TYPR_CLEP'
        DataField = 'ARTI__TYPR'
      end
      object cb_Categ2: TExtDBComboInsert
        Left = 128
        Top = 149
        Width = 218
        Height = 21
        TabOrder = 5
        SearchDisplay = 'CARA_Libelle'
        SearchList = 'CARA_Libelle'
        SearchSource = M_Article.ds_Carac
        DataSource = M_Article.ds_article
        SearchKey = 'CARA_Clep'
        DataField = 'ARTI__CARA'
      end
    end
    object pa_2: TPanel
      Left = 1
      Top = 1
      Width = 296
      Height = 550
      Align = alLeft
      BevelOuter = bvNone
      Constraints.MinWidth = 10
      TabOrder = 1
      object pa_4: TPanel
        Left = 0
        Top = 0
        Width = 296
        Height = 32
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        object nv_navigator: TExtDBNavigator
          Left = 0
          Top = 0
          Width = 296
          Height = 32
          Flat = True
          DataSource = M_Article.ds_article
          DeleteQuestion = 'Confirmez-vous l'#39'effacement de l'#39'enregistrement ?'
          Align = alClient
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          VisibleButtons = [nbEFirst, nbEPrior, nbENext, nbELast]
          GlyphSize = gsLarge
          Hints.Strings = (
            'Premier enregistrement'
            'Enregistrement pr'#233'c'#233'dent'
            'Enregistrement suivant'
            'Dernier enregistrement'
            'Ins'#233'rer enregistrement'
            'Supprimer l'#39'enregistrement'
            'Modifier l'#39'enregistrement'
            'Valider modifications'
            'Annuler les modifications'
            'Rafra'#238'chir les donn'#233'es'
            'Rechercher un enregistrement')
        end
      end
      object gd_categ: TExtDBGrid
        Left = 0
        Top = 32
        Width = 296
        Height = 518
        Align = alClient
        BorderStyle = bsNone
        Columns = <
          item
            Expanded = False
            FieldName = 'ARTI_Libcom'
            Visible = True
            FieldTag = 0
          end>
        DataSource = M_Article.ds_article
        Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgRowSelect, dgConfirmDelete, dgCancelOnExit]
        TabOrder = 1
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
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
            FieldName = 'ARTI_Libcom'
            Visible = True
            FieldTag = 0
          end>
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 1024
    Height = 26
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object Panel11: TPanel
      Left = 0
      Top = 0
      Width = 25
      Height = 26
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 0
    end
    object bt_imprimer: TFWPrintGrid
      Left = 25
      Top = 0
      Height = 25
      Hint = 'Impression des r'#233'sultats de la s'#233'lection'
      Caption = 'Imprimer'
      TabOrder = 3
      Align = alLeft
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      DBTitle = 'Cat'#233'gories'
      DBGrid = gd_categ
    end
    object Panel5: TPanel
      Left = 105
      Top = 0
      Width = 13
      Height = 26
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 1
    end
    object Panel6: TPanel
      Left = 118
      Top = 0
      Width = 13
      Height = 26
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 2
    end
    object bt_fermer: TFWClose
      Left = 928
      Top = 0
      Width = 96
      Height = 25
      Caption = 'Fermer'
      TabOrder = 4
      Layout = blGlyphRight
      Align = alRight
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
  end
  object SvgFormInfoIni: TOnFormInfoIni
    SaveForm = [sfSavePos, sfSaveSizes]
    Left = 97
    Top = 145
  end
end

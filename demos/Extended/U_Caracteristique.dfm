object F_Caracteristique: TF_Caracteristique
  Left = 323
  Top = 139
  Align = alClient
  Caption = 'Caract'#233'ristiques d'#39'articles'
  ClientHeight = 602
  ClientWidth = 968
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
  PixelsPerInch = 96
  TextHeight = 13
  object pa_1: TPanel
    Left = 0
    Top = 0
    Width = 968
    Height = 602
    Align = alClient
    BevelOuter = bvLowered
    TabOrder = 0
    object spl_1: TSplitter
      Left = 281
      Top = 27
      Width = 5
      Height = 574
    end
    object pa_3: TPanel
      Left = 286
      Top = 27
      Width = 681
      Height = 574
      Align = alClient
      BevelOuter = bvNone
      Constraints.MinWidth = 20
      TabOrder = 0
      object pa_5: TPanel
        Left = 0
        Top = 0
        Width = 681
        Height = 32
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 1
        object nv_saisie: TExtDBNavigator
          Left = 0
          Top = 0
          Width = 681
          Height = 32
          Flat = True
          DataSource = M_Article.ds_Carac
          DeleteQuestion = 'Confirmez-vous l'#39'effacement de l'#39'enregistrement ?'
          Align = alClient
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          TabStop = True
          Orientation = noHorizontal
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
      object pa_6: TPanel
        Left = 0
        Top = 32
        Width = 681
        Height = 74
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        object lb_libelle: TFWLabel
          Tag = 1002
          Left = 29
          Top = 42
          Width = 54
          Height = 16
          AutoSize = False
          Caption = 'lb_libelle'
          Color = clBtnFace
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentColor = False
          ParentFont = False
          ColorFocus = clMaroon
        end
        object lb_code: TFWLabel
          Tag = 1001
          Left = 34
          Top = 14
          Width = 49
          Height = 16
          AutoSize = False
          BiDiMode = bdLeftToRight
          Caption = 'lb_code'
          Color = clBtnFace
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentBiDiMode = False
          ParentColor = False
          ParentFont = False
          ColorFocus = clMaroon
        end
        object Splitter1: TSplitter
          Left = 0
          Top = 69
          Width = 681
          Height = 5
          Cursor = crVSplit
          Align = alBottom
        end
        object ed_libelle: TFWDBEdit
          Tag = 2
          Left = 102
          Top = 35
          Width = 460
          Height = 24
          DataField = 'CARA_Libelle'
          DataSource = M_Article.ds_Carac
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
        end
        object ed_code: TFWDBEdit
          Tag = 1
          Left = 102
          Top = 10
          Width = 201
          Height = 24
          CharCase = ecUpperCase
          DataField = 'CARA_Clep'
          DataSource = M_Article.ds_Carac
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          ReadOnly = True
          TabOrder = 0
        end
      end
      object pc_Groupes: TPageControl
        Left = 0
        Top = 106
        Width = 681
        Height = 468
        ActivePage = ts_ssfam
        Align = alClient
        TabOrder = 2
        object ts_ssfam: TTabSheet
          Caption = 'Types dont cette caract'#233'ristique est membre'
          object RbSplitter1: TSplitter
            Left = 321
            Top = 27
            Width = 5
            Height = 413
            ExplicitHeight = 407
          end
          object Panel10: TPanel
            Left = 0
            Top = 0
            Width = 673
            Height = 27
            Align = alTop
            TabOrder = 0
            object Panel12: TPanel
              Left = 237
              Top = 1
              Width = 13
              Height = 25
              Align = alLeft
              BevelOuter = bvNone
              TabOrder = 0
            end
            object Panel13: TPanel
              Left = 106
              Top = 1
              Width = 19
              Height = 25
              Align = alLeft
              BevelOuter = bvNone
              TabOrder = 1
            end
            object Panel1: TPanel
              Left = 1
              Top = 1
              Width = 13
              Height = 25
              Align = alLeft
              BevelOuter = bvNone
              TabOrder = 2
            end
            object Panel5: TPanel
              Left = 659
              Top = 1
              Width = 13
              Height = 25
              Align = alRight
              BevelOuter = bvNone
              TabOrder = 3
            end
            object bt_abandonner: TFWCancel
              Left = 125
              Top = 1
              Width = 112
              Height = 25
              Hint = 'Abandonner les modifications'
              Caption = 'Annuler'
              Enabled = False
              TabOrder = 4
              Align = alLeft
            end
            object bt_enregistrer: TFWOK
              Left = 14
              Top = 1
              Width = 92
              Height = 25
              Hint = 'Enregistrer les modifications'
              Caption = 'Enregistrer'
              Enabled = False
              TabOrder = 5
              Align = alLeft
            end
            object bt_TypePro: TJvXPButton
              Left = 250
              Top = 1
              Width = 22
              Height = 25
              Hint = 'Acc'#233'der '#224' la fiche Type de produit'
              Caption = '...'
              TabOrder = 6
              Align = alLeft
              ParentShowHint = False
              ShowHint = True
              OnClick = bt_TypeProClick
            end
          end
          object Panel6: TPanel
            Left = 0
            Top = 27
            Width = 321
            Height = 413
            Align = alLeft
            BevelOuter = bvNone
            Constraints.MinWidth = 10
            TabOrder = 1
            object lv_CaracIn: TDBGroupView
              Left = 0
              Top = 0
              Width = 242
              Height = 413
              Hint = 'Liste des membres'
              Align = alClient
              Columns = <
                item
                  AutoSize = True
                  Caption = 'Types dont cette caract'#233'ristique est membre'
                end>
              DragMode = dmAutomatic
              MultiSelect = True
              ReadOnly = True
              RowSelect = True
              ParentShowHint = False
              ShowHint = True
              StateImages = im_images
              TabOrder = 0
              ViewStyle = vsReport
              ColumnsOrder = '0=238'
              Groups = <>
              ExtendedColumns = <
                item
                end>
              DataKeyUnit = 'TYPR_Clep'
              DataFieldsDisplay = 'TYPR_Libelle'
              DataTableUnit = 'TYPE_PRODUIT'
              DataTableGroup = 'TYPE_PRODUIT_CARA'
              DataTableOwner = 'CARACTERISTIQUE'
              DataSourceOwner = M_Article.ds_Carac
              DataKeyOwner = 'CARA_Clep'
              DataFieldUnit = 'TYPC__TYPR'
              DataFieldGroup = 'TYPC__CARA'
              ButtonTotalIn = bt_in_total
              ButtonIn = bt_in_item
              ButtonTotalOut = bt_out_total
              ButtonOut = bt_out_item
              DataListOpposite = lv_transfert
              ButtonRecord = bt_enregistrer
              ButtonCancel = bt_abandonner
              DataAllFiltered = False
            end
            object Panel2: TPanel
              Left = 242
              Top = 0
              Width = 79
              Height = 413
              Align = alRight
              BevelOuter = bvNone
              TabOrder = 1
              object bt_in_item: TFWInSelect
                Left = 14
                Top = 18
                Width = 49
                Height = 45
                Hint = 
                  'Cette direction r'#233'gionale devient membre de cette direction op'#233'r' +
                  'ationnelle'
                Enabled = False
                TabOrder = 0
                ShowFocusRect = True
                ParentShowHint = False
                ShowHint = False
              end
              object bt_in_total: TFWInAll
                Left = 14
                Top = 70
                Width = 49
                Height = 52
                Hint = 
                  'Ces directions r'#233'gionales deviennent membre de cette direction o' +
                  'p'#233'rationnelle'
                Enabled = False
                TabOrder = 1
              end
              object bt_out_item: TFWOutSelect
                Left = 14
                Top = 138
                Width = 49
                Height = 44
                Hint = 
                  'Cette direction r'#233'gionale va '#234'tre d'#233'saffect'#233'e de sa direction op' +
                  #233'rationnelle'
                Enabled = False
                TabOrder = 2
              end
              object bt_out_total: TFWOutAll
                Left = 14
                Top = 189
                Width = 49
                Height = 45
                Hint = 
                  'Ces directions r'#233'gionales vont '#234'tre d'#233'saffect'#233'es de leur directi' +
                  'on op'#233'rationnelle'
                Enabled = False
                TabOrder = 3
              end
            end
          end
          object lv_transfert: TDBGroupView
            Left = 326
            Top = 27
            Width = 347
            Height = 413
            Hint = 'A r'#233'affecter'
            Align = alClient
            Columns = <
              item
                AutoSize = True
                Caption = 'Types dont cette caract'#233'ristique n'#39'est pas membre'
              end>
            Constraints.MinWidth = 10
            DragMode = dmAutomatic
            MultiSelect = True
            ReadOnly = True
            RowSelect = True
            ParentShowHint = False
            ShowHint = True
            StateImages = im_images
            TabOrder = 2
            ViewStyle = vsReport
            ColumnsOrder = '0=343'
            Groups = <>
            ExtendedColumns = <
              item
              end>
            DataKeyUnit = 'TYPR_Clep'
            DataFieldsDisplay = 'TYPR_Libelle'
            DataTableUnit = 'TYPE_PRODUIT'
            DataTableGroup = 'TYPE_PRODUIT_CARA'
            DataTableOwner = 'CARACTERISTIQUE'
            DataSourceOwner = M_Article.ds_Carac
            DataKeyOwner = 'CARA_Clep'
            DataFieldUnit = 'TYPC__TYPR'
            DataFieldGroup = 'TYPC__CARA'
            DataListPrimary = False
            ButtonTotalIn = bt_out_total
            ButtonIn = bt_out_item
            ButtonTotalOut = bt_in_total
            ButtonOut = bt_in_item
            DataListOpposite = lv_CaracIn
            ButtonRecord = bt_enregistrer
            ButtonCancel = bt_abandonner
            DataAllFiltered = False
          end
        end
        object TabSheet1: TTabSheet
          Caption = 'Articles affect'#233's '#224' la caract'#233'ristique'
          ImageIndex = 1
          object Panel7: TPanel
            Left = 0
            Top = 0
            Width = 673
            Height = 27
            Align = alTop
            TabOrder = 0
            object Panel18: TPanel
              Left = 232
              Top = 1
              Width = 13
              Height = 25
              Align = alLeft
              BevelOuter = bvNone
              TabOrder = 0
            end
            object Panel19: TPanel
              Left = 106
              Top = 1
              Width = 19
              Height = 25
              Align = alLeft
              BevelOuter = bvNone
              TabOrder = 1
            end
            object Panel20: TPanel
              Left = 1
              Top = 1
              Width = 13
              Height = 25
              Align = alLeft
              BevelOuter = bvNone
              TabOrder = 2
            end
            object Panel21: TPanel
              Left = 659
              Top = 1
              Width = 13
              Height = 25
              Align = alRight
              BevelOuter = bvNone
              TabOrder = 3
            end
            object bt_AbanArt: TFWCancel
              Left = 125
              Top = 1
              Width = 107
              Height = 25
              Hint = 'Abandonner les modifications'
              Caption = 'Annuler'
              Enabled = False
              TabOrder = 4
              Align = alLeft
            end
            object bt_EnrArt: TFWOK
              Left = 14
              Top = 1
              Width = 92
              Height = 25
              Hint = 'Enregistrer les modifications'
              Caption = 'Enregistrer'
              Enabled = False
              TabOrder = 5
              Align = alLeft
            end
            object bt_retour: TJvXPButton
              Left = 567
              Top = 1
              Width = 92
              Height = 25
              Hint = 'R'#233'affectation aux Directions op'#233'rationnelles d'#39'origine'
              Caption = 'Retour origine'
              Enabled = False
              TabOrder = 6
              Align = alRight
            end
          end
          object Panel22: TPanel
            Left = 0
            Top = 27
            Width = 673
            Height = 413
            Align = alClient
            TabOrder = 1
            object RbSplitter3: TSplitter
              Left = 345
              Top = 1
              Width = 5
              Height = 411
              ExplicitHeight = 405
            end
            object Panel23: TPanel
              Left = 1
              Top = 1
              Width = 344
              Height = 411
              Align = alLeft
              BevelOuter = bvNone
              Constraints.MinWidth = 10
              TabOrder = 0
              object lv_artin: TDBGroupView
                Left = 0
                Top = 0
                Width = 265
                Height = 411
                Hint = 'Liste des membres'
                Align = alClient
                Columns = <
                  item
                    AutoSize = True
                    Caption = 'Articles affect'#233's'
                  end>
                DragMode = dmAutomatic
                MultiSelect = True
                ReadOnly = True
                RowSelect = True
                ParentShowHint = False
                ShowHint = True
                StateImages = im_images
                TabOrder = 0
                ViewStyle = vsReport
                ColumnsOrder = '0=261'
                Groups = <>
                ExtendedColumns = <
                  item
                  end>
                DataKeyUnit = 'ARTI_Clep'
                DataFieldsDisplay = 'ARTI_Libcom'
                DataShowAll = True
                DataTableUnit = 'ARTICLE'
                DataTableGroup = 'ARTICLE'
                DataTableOwner = 'CARACTERISTIQUE'
                DataSourceOwner = M_Article.ds_Carac
                DataKeyOwner = 'CARA_Clep'
                DataFieldUnit = 'ARTI_Clep'
                DataFieldGroup = 'ARTI__CARA'
                ButtonTotalIn = bt_in_totart
                ButtonIn = bt_in_art
                ButtonTotalOut = bt_out_totart
                ButtonOut = bt_out_art
                DataListOpposite = lv_ArtOut
                ButtonRecord = bt_EnrArt
                ButtonCancel = bt_AbanArt
                ButtonBasket = bt_retour
                DataAllFiltered = False
              end
              object Panel24: TPanel
                Left = 265
                Top = 0
                Width = 79
                Height = 411
                Align = alRight
                BevelOuter = bvNone
                TabOrder = 1
                object bt_in_art: TFWInSelect
                  Left = 14
                  Top = 14
                  Width = 49
                  Height = 49
                  Hint = 'Cet article devient membre de cette gamme'
                  Enabled = False
                  TabOrder = 0
                  ShowFocusRect = True
                  ParentShowHint = False
                  ShowHint = False
                end
                object bt_in_totart: TFWInAll
                  Left = 14
                  Top = 70
                  Width = 49
                  Height = 49
                  Hint = 
                    'Ces directions r'#233'gionales deviennent membre de cette direction o' +
                    'p'#233'rationnelle'
                  Enabled = False
                  TabOrder = 1
                end
                object bt_out_art: TFWOutSelect
                  Left = 14
                  Top = 137
                  Width = 49
                  Height = 45
                  Hint = 
                    'Cette direction r'#233'gionale va '#234'tre d'#233'saffect'#233'e de sa direction op' +
                    #233'rationnelle'
                  Enabled = False
                  TabOrder = 2
                end
                object bt_out_totart: TFWOutAll
                  Left = 14
                  Top = 189
                  Width = 49
                  Height = 44
                  Hint = 
                    'Ces directions r'#233'gionales vont '#234'tre d'#233'saffect'#233'es de leur directi' +
                    'on op'#233'rationnelle'
                  Enabled = False
                  TabOrder = 3
                end
              end
            end
            object lv_ArtOut: TDBGroupView
              Left = 350
              Top = 1
              Width = 322
              Height = 411
              Hint = 'A r'#233'affecter'
              Align = alClient
              Columns = <
                item
                  AutoSize = True
                  Caption = 'A r'#233'affecter'
                end>
              Constraints.MinWidth = 10
              DragMode = dmAutomatic
              MultiSelect = True
              ReadOnly = True
              RowSelect = True
              ParentShowHint = False
              ShowHint = True
              TabOrder = 1
              ViewStyle = vsReport
              ColumnsOrder = '0=318'
              Groups = <>
              ExtendedColumns = <
                item
                end>
              DataKeyUnit = 'ARTI_Clep'
              DataFieldsDisplay = 'ARTI_Libcom'
              DataShowAll = True
              DataTableUnit = 'ARTICLE'
              DataTableGroup = 'ARTICLE'
              DataTableOwner = 'CARACTERISTIQUE'
              DataSourceOwner = M_Article.ds_Carac
              DataKeyOwner = 'CARA_Clep'
              DataFieldUnit = 'ARTI_Clep'
              DataFieldGroup = 'ARTI__CARA'
              DataListPrimary = False
              ButtonTotalIn = bt_out_totart
              ButtonIn = bt_out_art
              ButtonTotalOut = bt_in_totart
              ButtonOut = bt_in_art
              DataListOpposite = lv_artin
              ButtonRecord = bt_enregistrer
              ButtonCancel = bt_AbanArt
              ButtonBasket = bt_retour
              DataAllFiltered = False
            end
          end
        end
      end
    end
    object pa_2: TPanel
      Left = 1
      Top = 27
      Width = 280
      Height = 574
      Align = alLeft
      BevelOuter = bvNone
      Constraints.MinWidth = 10
      TabOrder = 1
      object pa_4: TPanel
        Left = 0
        Top = 0
        Width = 280
        Height = 32
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        object nv_navigator: TExtDBNavigator
          Left = 0
          Top = 0
          Width = 280
          Height = 32
          Flat = True
          DataSource = M_Article.ds_Carac
          DeleteQuestion = 'Confirmez-vous l'#39'effacement de l'#39'enregistrement ?'
          Align = alClient
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          TabStop = True
          Orientation = noHorizontal
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
      object gd_famillevente: TExtDBGrid
        Left = 0
        Top = 32
        Width = 280
        Height = 542
        Align = alClient
        BorderStyle = bsNone
        Columns = <
          item
            Expanded = False
            FieldName = 'CARA_Libelle'
            Visible = True
            FieldTag = 0
          end>
        DataSource = M_Article.ds_Carac
        Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgRowSelect, dgConfirmDelete, dgCancelOnExit]
        TabOrder = 1
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
        AutoSort = False
        TitleButtons = True
        SelectColumnsDialogStrings.Caption = 'Select columns'
        SelectColumnsDialogStrings.OK = '&OK'
        SelectColumnsDialogStrings.NoSelectionWarning = 'At least one column must be visible!'
        EditControls = <>
        RowsHeight = 17
        TitleRowHeight = 17
        Columns = <
          item
            Expanded = False
            FieldName = 'CARA_Libelle'
            Visible = True
            FieldTag = 0
          end>
      end
    end
    object Panel3: TPanel
      Left = 1
      Top = 1
      Width = 966
      Height = 26
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 2
      object bt_fermer: TFWClose
        Left = 886
        Top = 0
        Caption = 'Fermer'
        TabOrder = 0
        Layout = blGlyphRight
        Align = alRight
        OnClick = bt_fermerClick
      end
      object Panel4: TPanel
        Left = 0
        Top = 0
        Width = 13
        Height = 26
        Align = alLeft
        BevelOuter = bvNone
        TabOrder = 1
      end
      object bt_imprimer: TFWPrintGrid
        Left = 13
        Top = 0
        Width = 80
        Hint = 'Impression des r'#233'sultats de la s'#233'lection'
        Caption = 'Imprimer'
        TabOrder = 2
        Align = alLeft
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        DBGrid = gd_famillevente
        DBTitle = 'Caract'#233'ristiques d'#39'articles'
        ExplicitLeft = 361
        ExplicitHeight = 25
      end
    end
  end
  object SvgFormInfoIni: TOnFormInfoIni
    SaveEdits = [feTGrid, feTListView]
    SaveForm = [sfSaveSizes]
    Left = 97
    Top = 129
  end
  object im_images: TImageList
    Left = 96
    Top = 178
  end
end

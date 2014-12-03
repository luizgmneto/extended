object F_Copier: TF_Copier
  Left = 451
  Top = 222
  Cursor = crArrow
  ActiveControl = bt_Copy
  Caption = 'Copy and Images Traduce '
  ClientHeight = 471
  ClientWidth = 658
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Icon.Data = {
    0000010001001717100001000400D80100001600000028000000170000002E00
    0000010004000000000000000000000000000000000000000000000000000000
    00008000000029EF5C00FFFFFF00000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000003333
    3333333333333333333033333333333333000000003033333333333332222222
    2030333333333333322222222030333333333333321111112030333333333333
    3222222220303333333333333211111120303333333333333222222220303333
    3333333332111111203033333333333332222222203033333333333332222111
    2030330000000033322222222330333333333033333333333330333333333033
    3333313333303311111130333333111333303333333330333331111133303311
    1111303333333133333033333333303333331133333033111111303111111333
    3330333333333033333333333330333331113033333333333330333333333333
    3333333333303333333333333333333333300000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000}
  Menu = MainMenu
  OldCreateOrder = False
  Position = poDesktopCenter
  WindowState = wsMaximized
  OnActivate = FormActivate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 0
    Top = 274
    Width = 658
    Height = 6
    Cursor = crVSplit
    Align = alTop
    ExplicitWidth = 666
  end
  object Panel5: TPanel
    Left = 0
    Top = 435
    Width = 658
    Height = 36
    Align = alBottom
    TabOrder = 0
    object bt_Copy: TJvXPButton
      Left = 12
      Top = 8
      Caption = 'Copier'
      TabOrder = 0
      OnClick = bt_CopyClick
    end
    object ch_Structure: TJvXPCheckbox
      Left = 88
      Top = 8
      Width = 100
      Height = 17
      Caption = 'Structurer'
      TabOrder = 1
      OnClick = ch_StructureClick
    end
    object ch_Backup: TJvXPCheckbox
      Left = 200
      Top = 8
      Width = 93
      Height = 17
      Caption = 'Backup'
      TabOrder = 2
      OnClick = ch_BackupClick
    end
    object ProgressBar: TProgressBar
      Left = 480
      Top = 6
      Width = 172
      Height = 20
      TabOrder = 4
    end
    object ch_CopyAll: TJvXPCheckbox
      Left = 304
      Top = 9
      Width = 168
      Height = 17
      Caption = 'Sous-R'#233'pertoires'
      TabOrder = 3
      OnClick = ch_CopyAllClick
    end
  end
  object Result: TMemo
    Left = 0
    Top = 280
    Width = 658
    Height = 155
    Align = alClient
    TabOrder = 1
  end
  object Panel7: TPanel
    Left = 0
    Top = 0
    Width = 658
    Height = 274
    Align = alTop
    BevelOuter = bvNone
    Caption = 'Panel7'
    TabOrder = 2
    object Splitter2: TSplitter
      Left = 492
      Top = 0
      Width = 5
      Height = 274
    end
    object Splitter3: TSplitter
      Left = 256
      Top = 0
      Width = 8
      Height = 274
    end
    object Panel1: TPanel
      Left = 0
      Top = 0
      Width = 256
      Height = 274
      Align = alLeft
      BevelOuter = bvNone
      Caption = 'Panel1'
      TabOrder = 0
      object Panel3: TPanel
        Left = 0
        Top = 0
        Width = 256
        Height = 24
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        object DirectorySource: TDirectoryEdit
          Left = 0
          Top = 0
          Width = 250
          Height = 24
          Align = alLeft
          NumGlyphs = 1
          ButtonWidth = 23
          TabOrder = 0
          OnChange = DirectorySourceChange
        end
      end
      object FileListSource: TFileListBox
        Left = 0
        Top = 50
        Width = 256
        Height = 224
        Align = alClient
        FileType = [ftReadOnly, ftHidden, ftVolumeID, ftArchive, ftNormal]
        ItemHeight = 19
        TabOrder = 1
      end
      object Panel6: TPanel
        Left = 0
        Top = 24
        Width = 256
        Height = 26
        Align = alTop
        BevelOuter = bvNone
        Caption = 'Panel6'
        TabOrder = 2
        object Mask: TEdit
          Left = 0
          Top = 0
          Width = 256
          Height = 21
          TabOrder = 0
          Text = '*.*'
          OnChange = MaskChange
        end
      end
    end
    object ResultErrors: TMemo
      Left = 497
      Top = 0
      Width = 161
      Height = 274
      Align = alClient
      TabOrder = 1
    end
    object Panel2: TPanel
      Left = 264
      Top = 0
      Width = 228
      Height = 274
      Align = alLeft
      BevelOuter = bvNone
      Caption = 'Panel2'
      TabOrder = 2
      object Panel8: TPanel
        Left = 0
        Top = 0
        Width = 242
        Height = 274
        Align = alLeft
        BevelOuter = bvNone
        TabOrder = 0
        object pa_DestImages: TPanel
          Left = 0
          Top = 0
          Width = 242
          Height = 128
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 0
          object cb_TypeDest: TComboBox
            Left = 104
            Top = 28
            Width = 124
            Height = 21
            Style = csDropDownList
            ItemHeight = 13
            MaxLength = 65535
            TabOrder = 0
            Items.Strings = (
              'Images JPEG ( *.jpg )'
              'Images GIF ( *.gif )'
              'Images Bitmap ( *.bmp )'
              'Images Targa ( *.tga )'
              'Images Autodesk ( *.pic )'
              'Images SGI ( *.sgi )'
              'Images PCX ( *.pcx )'
              'Images PCD ( *.pcd )'
              'Images Portable MAP ( *.ppm )'
              'Images CUT ( *.cut )'
              'Images RLA ( *.rla )'
              'Images PNG ( *.png )'
              'Images EPS ( *.eps )'
              'Images TIFF ( *.tif )')
          end
          object ch_Traduire: TJvXPCheckbox
            Left = 0
            Top = 27
            Width = 105
            Height = 22
            Caption = 'Traduire vers'
            TabOrder = 1
          end
          object Panel4: TPanel
            Left = 0
            Top = 0
            Width = 242
            Height = 26
            Align = alTop
            BevelOuter = bvNone
            TabOrder = 2
            object DirectoryDestination: TDirectoryEdit
              Left = 0
              Top = 0
              Width = 222
              Height = 26
              Align = alLeft
              NumGlyphs = 1
              ButtonWidth = 23
              TabOrder = 0
              OnChange = DirectoryDestinationChange
            end
          end
          object ch_RWidth: TJvXPCheckbox
            Left = 0
            Top = 56
            Width = 129
            Height = 19
            Caption = 'Nouvelle largeur'
            TabOrder = 3
          end
          object ch_RHeight: TJvXPCheckbox
            Left = 0
            Top = 80
            Width = 136
            Height = 19
            Caption = 'Nouvelle hauteur'
            TabOrder = 4
          end
          object se_RWidth: TSpinEdit
            Left = 136
            Top = 52
            Width = 90
            Height = 22
            Increment = 100
            MaxValue = 100000000
            MinValue = 1
            TabOrder = 5
            Value = 1920
          end
          object se_RHeight: TSpinEdit
            Left = 136
            Top = 76
            Width = 90
            Height = 22
            Increment = 100
            MaxValue = 100000000
            MinValue = 1
            TabOrder = 6
            Value = 1200
          end
          object ch_GarderProportions: TJvXPCheckbox
            Left = 0
            Top = 104
            Width = 224
            Height = 19
            Caption = 'Garder les Proportions'
            TabOrder = 7
            Checked = True
            State = cbChecked
          end
        end
        object FileListDestination: TFileListBox
          Left = 0
          Top = 128
          Width = 242
          Height = 146
          Align = alClient
          FileType = [ftReadOnly, ftHidden, ftVolumeID, ftArchive, ftNormal]
          ItemHeight = 19
          TabOrder = 1
        end
      end
    end
  end
  object FileCopy: TExtFileCopy
    Errors = 0
    FileOptions = [cpUseFilter, cpCreateBackup]
    OnSuccess = FileCopySuccess
    OnProgress = FileCopyProgress
    OnChange = FileCopyChange
    Left = 35
    Top = 33
  end
  object OnFormInfoIni: TOnFormInfoIni
    SavePosObjects = True
    SaveEdits = [feTEdit, feTCheck, feTDirectoryEdit, feTSpinEdit]
    SavePosForm = True
    Left = 83
    Top = 32
    SaveForm = []
    Options = [loAutoUpdate,loAutoLoad,loFreeIni]
  end
  object MainMenu: TMainMenu
    Left = 136
    Top = 32
    object Language: TMenuItem
      Caption = 'Langue'
    end
    object Faireundon: TMenuItem
      Caption = 'Faire un don'
      OnClick = FaireundonClick
    end
    object Aide: TMenuItem
      Caption = 'Aide'
      object APropos: TMenuItem
        Caption = 'A Propos'
        OnClick = AProposClick
      end
    end
  end
  object TraduceFile: TTraduceFile
    Errors = 0
    TraduceOptions = []
    OnSuccess = TraduceFileSuccess
    Left = 37
    Top = 81
  end
end

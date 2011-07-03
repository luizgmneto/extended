object F_CustomizeMenu: TF_CustomizeMenu
  Left = 313
  Top = 180
  Caption = 'F_CustomizeMenu'
  ClientHeight = 400
  ClientWidth = 600
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 600
    Height = 30
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object FWClose1: TFWClose
      Left = 520
      Top = 0
      Width = 80
      Height = 30
      Caption = 'Fermer'
      TabOrder = 0
      Align = alRight
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 30
    Width = 600
    Height = 370
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object Splitter1: TSplitter
      Left = 240
      Top = 0
      Width = 5
      Height = 340
    end
    object Panel3: TPanel
      Left = 0
      Top = 340
      Width = 600
      Height = 30
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 0
      object FWInsert: TFWInsert
        Left = 519
        Top = 0
        Width = 81
        Height = 30
        Caption = 'Ajouter'
        Enabled = False
        TabOrder = 0
        Align = alRight
        OnClick = FWInsertClick
      end
      object Panel4: TPanel
        Left = 105
        Top = 0
        Width = 31
        Height = 30
        Align = alLeft
        BevelOuter = bvNone
        TabOrder = 2
      end
      object ch_ajouteravant: TJvXPCheckbox
        Left = 358
        Top = 0
        Width = 161
        Height = 30
        Caption = 'Ajouter avant'
        TabOrder = 1
        Align = alRight
      end
    end
  end
  object OnFormInfoIni: TOnFormInfoIni
    SauvePosObjects = True
    SauveEditObjets = [feTCheck]
    SauvePosForm = True
    Left = 145
    Top = 140
  end
end

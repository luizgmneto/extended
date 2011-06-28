object F_CustomizeMenu: TF_CustomizeMenu
  Left = 313
  Height = 400
  Top = 180
  Width = 600
  Caption = 'F_CustomizeMenu'
  ClientHeight = 400
  ClientWidth = 600
  Position = poMainFormCenter
  LCLVersion = '0.9.30'
  object Panel1: TPanel
    Left = 0
    Height = 30
    Top = 0
    Width = 600
    Align = alTop
    BevelOuter = bvNone
    ClientHeight = 30
    ClientWidth = 600
    TabOrder = 0
    object FWClose1: TFWClose
      Left = 520
      Height = 30
      Top = 0
      Width = 80
      Caption = 'Fermer'
      TabOrder = 0
      Align = alRight
    end
  end
  object Panel2: TPanel
    Left = 0
    Height = 370
    Top = 30
    Width = 600
    Align = alClient
    BevelOuter = bvNone
    ClientHeight = 370
    ClientWidth = 600
    TabOrder = 1
    object VirtualStringTree1: TVirtualStringTree
      Left = 0
      Height = 340
      Top = 0
      Width = 600
      Align = alClient
      DefaultText = 'Node'
      Header.AutoSizeIndex = 0
      Header.Columns = <>
      Header.DefaultHeight = 17
      Header.MainColumn = -1
      TabOrder = 0
    end
    object Panel3: TPanel
      Left = 0
      Height = 30
      Top = 340
      Width = 600
      Align = alBottom
      BevelOuter = bvNone
      ClientHeight = 30
      ClientWidth = 600
      TabOrder = 1
      object FWDelete1: TFWDelete
        Left = 0
        Height = 30
        Top = 0
        Width = 105
        Caption = 'Supprimer'
        TabOrder = 0
        Align = alLeft
      end
      object FWInsert1: TFWInsert
        Left = 136
        Height = 30
        Top = 0
        Width = 81
        Caption = 'Ajouter'
        TabOrder = 1
        Align = alLeft
      end
      object Panel4: TPanel
        Left = 105
        Height = 30
        Top = 0
        Width = 31
        Align = alLeft
        BevelOuter = bvNone
        TabOrder = 2
      end
    end
  end
end

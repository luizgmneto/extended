object FMain: TFMain
  Left = 345
  Top = 284
  Caption = 'Gestion d'#39'articles'
  ClientHeight = 413
  ClientWidth = 592
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsMDIForm
  Menu = MainMenu
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object MainMenu: TMainMenu
    Left = 141
    Top = 128
    object MenuItem1: TMenuItem
      Caption = 'Fen'#234'tres'
      object MuArticle: TMenuItem
        Caption = 'Articles'
        OnClick = MuArticleClick
      end
      object MuCaract: TMenuItem
        Caption = 'Caract'#233'ristiques'
        OnClick = MuCaractClick
      end
      object muGamme: TMenuItem
        Caption = 'Gammes'
        OnClick = muGammeClick
      end
      object MuTypeArticle: TMenuItem
        Caption = 'Types d'#39'articles'
        OnClick = MuTypeArticleClick
      end
    end
    object muapropos: TMenuItem
      Caption = #192' propos'
      OnClick = muaproposClick
    end
  end
  object OnFormInfoIni1: TOnFormInfoIni
    SaveEdits = []
    SavePosForm = True
    Left = 96
    Top = 84
    SaveForm = []
    Options = [loAutoUpdate,loAutoLoad,loFreeIni]
  end
end

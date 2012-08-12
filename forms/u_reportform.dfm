object PrintGraph: TPrintGraph
  Left = 483
  Top = 222
  AutoSize = True
  Caption = 'PrintGraph'
  ClientHeight = 1033
  ClientWidth = 794
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
  OnCreate = DataModuleCreate
  PixelsPerInch = 96
  TextHeight = 13
  object rp: TRLReport
    Left = 0
    Top = 0
    Width = 794
    Height = 1123
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    BeforePrint = rpBeforePrint
  end
  object ps: TRLPreviewSetup
    Left = 177
    Top = 91
  end
end

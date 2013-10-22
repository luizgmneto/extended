object F_Update: TF_Update
  Left = 0
  Top = 0
  Caption = 'F_Update'
  ClientHeight = 174
  ClientWidth = 280
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object ProgressBar: TProgressBar
    Left = 0
    Top = 157
    Width = 280
    Height = 17
    Align = alBottom
    TabOrder = 0
  end
  object FWDownLoad: TFWRefresh
    Left = 80
    Top = 40
    Width = 113
    Height = 33
    Caption = 'DownLoad'
    TabOrder = 1
    OnClick = FWDownLoadClick
  end
  object FWLoad: TFWLoad
    Left = 80
    Top = 88
    Width = 113
    Height = 33
    Caption = 'Open'
    TabOrder = 2
    OnClick = FWLoadClick
  end
  object NetUpdate: TNetUpdate
    FileUpdate = 'LINUX_A5.pdf'
    URLBase = 'http://www.aides-informatique.com/IMG/pdf/'
    Progress = ProgressBar
    OnErrorMessage = NetUpdateErrorMessage
    OnDownloading = NetUpdateDownloading
    OnDownloaded = NetUpdateDownloaded
    IdComponent = IdHTTP
    Left = 72
    Top = 80
  end
  object IdHTTP: TIdHTTP
    AllowCookies = True
    ProxyParams.BasicAuthentication = False
    ProxyParams.ProxyPort = 0
    Request.ContentLength = -1
    Request.Accept = 'text/html, */*'
    Request.BasicAuthentication = False
    Request.UserAgent = 'Mozilla/3.0 (compatible; Indy Library)'
    HTTPOptions = [hoForceEncodeParams]
    Left = 80
    Top = 32
  end
end

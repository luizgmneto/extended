object M_Article: TM_Article
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 508
  Width = 771
  object ds_article: TDataSource
    DataSet = IB_Article
    Left = 128
    Top = 13
  end
  object IB_Gamme: TIBQuery
    SQL.Strings = (
      'SELECT * from GAMME')
    Left = 477
    Top = 13
  end
  object ds_Gamme: TDataSource
    DataSet = IB_Gamme
    Left = 400
    Top = 13
  end
  object IB_TypProduit: TIBQuery
    Database = IBDatabase
    Transaction = IBTransaction
    SQL.Strings = (
      'SELECT * from TYPE_PRODUIT')
    UpdateObject = IBU_TypProd
    Left = 328
    Top = 128
  end
  object ds_TypProduit: TDataSource
    DataSet = IB_TypProduit
    Left = 217
    Top = 128
  end
  object IB_Carac: TIBQuery
    SQL.Strings = (
      'SELECT * from CARACTERISTIQUE')
    UpdateObject = IBU_Carac
    Left = 312
    Top = 184
  end
  object ds_Carac: TDataSource
    DataSet = IB_Carac
    Left = 217
    Top = 184
  end
  object ds_FiltreProduit: TDataSource
    DataSet = IB_FiltreProduit
    Left = 216
    Top = 72
  end
  object IB_FiltreProduit: TIBQuery
    SQL.Strings = (
      'SELECT * FROM FILTRE_PRODUIT')
    Left = 328
    Top = 72
  end
  object IB_Article: TIBQuery
    Database = IBDatabase
    Transaction = IBTransaction
    SQL.Strings = (
      'select * '
      'from ARTICLE')
    UpdateObject = IBU_Article
    Left = 216
    Top = 13
  end
  object IBDatabase: TIBDatabase
    DatabaseName = 'Exemple'
    Params.Strings = (
      'user_name=SYSDBA'
      'password=masterkey'
      'lc_ctype=UTF8')
    LoginPrompt = False
    DefaultTransaction = IBTransaction
    AllowStreamedConnected = False
    Left = 24
    Top = 13
  end
  object IBTransaction: TIBTransaction
    Left = 24
    Top = 72
  end
  object ib_typearti: TIBQuery
    Database = IBDatabase
    Transaction = IBTransaction
    SQL.Strings = (
      'select *'
      'from TYPE_PRODUIT')
    UpdateObject = IBU_TypArt
    Left = 88
    Top = 160
  end
  object ds_typearti: TDataSource
    DataSet = ib_typearti
    Left = 16
    Top = 160
  end
  object ib_gammarti: TIBQuery
    Database = IBDatabase
    Transaction = IBTransaction
    SQL.Strings = (
      'select ARTI_Clep, ARTI_Libcom'
      'from ARTICLE'
      'where ARTI__GAMM = :gamm'
      'ORDER BY ARTI_Libcom')
    UpdateObject = IBU_Gamme
    Left = 88
    Top = 288
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'gamm'
        ParamType = ptInput
      end>
  end
  object ds_gammarti: TDataSource
    DataSet = ib_gammarti
    Left = 16
    Top = 288
  end
  object IBU_Article: TIBUpdateSQL
    RefreshSQL.Strings = (
      'SELECT * FROM ARTICLE')
    ModifySQL.Strings = (
      'UPDATE ARTICLE SET'
      '     ARTI_Libcom=:ARTI_Libcom,'
      #9'ARTI__CARA=:ARTI__CARA,'
      #9'ARTI__TYPR=:ARTI__TYPR,'
      #9'ARTI__GAMM=:ARTI__GAMM '
      'WHERE ARTI_CLEP=:ARTI_CLEP')
    InsertSQL.Strings = (
      'INSERT INTO ARTICLE'
      '     (  ARTI_Libcom,'
      #9'ARTI__CARA,'
      #9'ARTI__TYPR,'
      #9'ARTI__GAMM) '
      'VALUES'
      '     (  :ARTI_Libcom,'
      #9':ARTI__CARA,'
      #9':ARTI__TYPR,'
      #9':ARTI__GAMM) ')
    DeleteSQL.Strings = (
      'DELETE FROM ARTICLE WHERE ARTI_CLEP = :ARTI_CLEP')
    Left = 312
    Top = 8
  end
  object IBU_Gamme: TIBUpdateSQL
    RefreshSQL.Strings = (
      'SELECT * FROM GAMME')
    ModifySQL.Strings = (
      'UPDATE GAMME SET'
      '     GAMM_Libelle=:GAMM_Libelle '
      'WHERE GAMM_CLEP=:GAMM_CLEP')
    InsertSQL.Strings = (
      'INSERT INTO GAMME'
      '     (  GAMM_Libelle) '
      'VALUES'
      '     (  :GAMM_Libelle) ')
    DeleteSQL.Strings = (
      'DELETE FROM GAMME WHERE GAMM_CLEP = :GAMM_CLEP')
    Left = 608
    Top = 13
  end
  object IBU_TypProd: TIBUpdateSQL
    RefreshSQL.Strings = (
      'SELECT * FROM TYPE_PRODUIT')
    ModifySQL.Strings = (
      'UPDATE TYPE_PRODUIT SET'
      '     TYPR_Libelle=:TYPR_Libelle '
      'WHERE TYPR_CLEP=:TYPR_CLEP')
    InsertSQL.Strings = (
      'INSERT INTO TYPE_PRODUIT'
      '     (  TYPR_Libelle) '
      'VALUES'
      '     (  :TYPR_Libelle) ')
    DeleteSQL.Strings = (
      'DELETE FROM TYPE_PRODUIT WHERE TYPR_CLEP = :TYPR_CLEP')
    Left = 432
    Top = 128
  end
  object IBU_Carac: TIBUpdateSQL
    RefreshSQL.Strings = (
      'SELECT * FROM CARACTERISTIQUE')
    ModifySQL.Strings = (
      'UPDATE CARACTERISTIQUE SET'
      '     CARA_Libelle=:CARA_Libelle '
      'WHERE CARA_CLEP=:CARA_CLEP')
    InsertSQL.Strings = (
      'INSERT INTO CARACTERISTIQUE'
      '     (  CARA_Libelle) '
      'VALUES'
      '     (  :CARA_Libelle) ')
    DeleteSQL.Strings = (
      'DELETE FROM CARACTERISTIQUE WHERE CARA_CLEP = :CARA_CLEP')
    Left = 432
    Top = 184
  end
  object IBU_TypArt: TIBUpdateSQL
    RefreshSQL.Strings = (
      'SELECT * FROM TYPE_PRODUIT')
    ModifySQL.Strings = (
      'UPDATE TYPE_PRODUIT SET'
      '     TYPR_Libelle=:TYPR_Libelle '
      'WHERE TYPR_CLEP=:TYPR_CLEP')
    InsertSQL.Strings = (
      'INSERT INTO TYPE_PRODUIT'
      '     (  TYPR_Libelle) '
      'VALUES'
      '     (  :TYPR_Libelle) ')
    DeleteSQL.Strings = (
      'DELETE FROM TYPE_PRODUIT WHERE TYPR_CLEP = :TYPR_CLEP')
    Left = 48
    Top = 216
  end
end

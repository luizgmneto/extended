unit U_DmArticles;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
  SysUtils, StrUtils, Classes, DB, ZDataset, Forms, Dialogs, controls,
  U_Donnees, fonctions_string, U_FormDico, uib, U_ConstMessage ;
type

  { TM_Article }

  TM_Article = class(TDataModule)
    ds_article: TDataSource;
    IBDatabase: TUIBDataBase;
    IBTransaction: TUIBTransaction;
    zq_artcoul: TUIBQuery;
    ds_ARCO: TDataSource;
    ds_GamTProIn: TDataSource;
    zq_GamTProIn: TUIBQuery;
    ds_GamTProOut: TDataSource;
    zq_GamTProOut: TUIBQuery;
    zq_Gamme: TUIBQuery;
    ds_Gamme: TDataSource;
    zq_TypProduit: TUIBQuery;
    ds_TypProduit: TDataSource;
    zq_Carac: TUIBQuery;
    ds_Carac: TDataSource;
    ds_SelCarac: TDataSource;
    zq_SelCarac: TUIBQuery;
    zq_SelTypPro: TUIBQuery;
    ds_SelTypPro: TDataSource;
    zq_SelGamme: TUIBQuery;
    ds_SelGamme: TDataSource;
    ds_Sel1Carac: TDataSource;
    zq_Sel1Carac: TUIBQuery;
    zq_Sel1TypPro: TUIBQuery;
    ds_Sel1TypPro: TDataSource;
    ds_SelCarac2: TDataSource;
    zq_SelCarac2: TUIBQuery;
    zq_SelTypPro2: TUIBQuery;
    ds_SelTypPro2: TDataSource;
    zq_GammeE: TUIBQuery;
    ds_GammeE: TDataSource;
    ds_Sel1Carac2: TDataSource;
    zq_Sel1Carac2: TUIBQuery;
    zq_Sel1TypPro2: TUIBQuery;
    ds_Sel1TypPro2: TDataSource;
    ds_ArFini: TDataSource;
    zq_CocoCoul: TUIBQuery;
    ds_CocoCoul: TDataSource;
    zq_TyfiInFini: TUIBQuery;
    ds_TyfiInFini: TDataSource;
    zq_TyfiOutFini: TUIBQuery;
    ds_TyfiOutFini: TDataSource;
    zq_FiniInTyFi: TUIBQuery;
    ds_FiniInTyFi: TDataSource;
    zq_FiniOutTyFi: TUIBQuery;
    ds_FiniOutTyFi: TDataSource;
    ds_FiltreProduit: TDataSource;
    zq_FiltreProduit: TUIBQuery;
    zq_Article1: TUIBQuery;
    zq_prod_acces: TUIBQuery;
    ds_prod_acces: TDataSource;
    ds_ArbreArt: TDataSource;
    zq_ArbreArt: TUIBQuery;
    zq_code_copieart: TUIBQuery;
    zq_copieart: TUIBQuery;
    zq_ArFini: TUIBQuery;
    zq_Article2: TUIBQuery;
    zq_Article3: TUIBQuery;
    zq_Article4: TUIBQuery;
    zq_Article5: TUIBQuery;
    zq_Article6: TUIBQuery;
    procedure zq_articleAfterScroll(DataSet: TDataSet);
    procedure zq_articleNewRecord(DataSet: TDataSet);
    procedure zq_SelGammeAfterScroll(DataSet: TDataSet);
    procedure zq_SelTypProAfterScroll(DataSet: TDataSet);
    procedure zq_SelTypProAfterOpen(DataSet: TDataSet);
    procedure zq_SelGammeAfterOpen(DataSet: TDataSet);
    procedure zq_articleAfterOpen(DataSet: TDataSet);
    procedure zq_AffectePostError(DataSet: TDataSet; E: EDatabaseError;
      var Action: TDataAction);
    procedure zq_FinitionAfterOpen(DataSet: TDataSet);
    procedure zq_GammeEAfterOpen(DataSet: TDataSet);
    procedure zq_GammeEAfterScroll(DataSet: TDataSet);
    procedure zq_SelTypPro2AfterOpen(DataSet: TDataSet);
    procedure zq_SelTypPro2AfterScroll(DataSet: TDataSet);
    procedure zq_Sel1TypPro2AfterOpen(DataSet: TDataSet);
    procedure zq_Sel1TypPro2AfterScroll(DataSet: TDataSet);
    procedure zq_Article1AfterInsert(DataSet: TDataSet);
    procedure zq_Article1AfterPost(DataSet: TDataSet);
    procedure zq_ArbreArtAfterOpen(DataSet: TDataSet);
    procedure zq_Article1BeforeEdit(DataSet: TDataSet);

  private
    { D?clarations priv?es }
  public
    gi_AccesProduits : Integer ;
    { D?clarations publiques }
    procedure p_AccesArticles ( const avar_Tyde : Variant );
    procedure p_TousLesProduits;
  end;

var
  M_Article: TM_Article;

implementation

uses Variants , fonctions_dbcomponents,
   unite_variables;

{$IFNDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

/////////////////////////////////////////////////////////////////////////////////////
// Proc?dure   : p_TousLesProduits
// Description : Enl?ve le filtre de la requ?te des articles
/////////////////////////////////////////////////////////////////////////////////////
procedure TM_Article.p_AccesArticles ( const avar_Tyde : Variant );
begin
  ds_article.DataSet := Nil ;

  if ( gi_niveau_priv <= U_CST_REPRESENTANT ) Then
    begin

       gi_AccesProduits := 2;
       if avar_Tyde = Null Then
         ds_article.DataSet := zq_Article5
       Else
         ds_article.DataSet := zq_Article6
    end
  else if ( gi_niveau_priv <= U_CST_ASSISTANT ) Then
    begin

       gi_AccesProduits := 1;
       if avar_Tyde = Null Then
         ds_article.DataSet := zq_Article3
       Else
         ds_article.DataSet := zq_Article4
    end
    Else
    begin

       gi_AccesProduits := 0;
       if avar_Tyde = Null Then
         ds_article.DataSet := zq_Article1
       Else
         ds_article.DataSet := zq_Article2
    end ;
  if ( avar_Tyde <> Null )
  and (( M_Article.ds_Article.DataSet as TUIBQuery ).Params.FindParam ( 'Tyde' ).Value <> avar_Tyde ) Then
    Begin
      //li_user =0 => TOUS LES ARTICLES; li_user =1 => LES ARTICLES NON DECLASSES
      ds_Article.Dataset.Close ;
      ( ds_Article.Dataset as TUIBQuery ).Params.FindParam ( 'Tyde' ).Value := avar_Tyde ;
    End ;

End ;

procedure TM_Article.p_TousLesProduits;
begin
  p_AccesArticles ( Null );
end;

procedure TM_Article.zq_articleAfterScroll(DataSet: TDataSet);
begin
 { with  zq_artfinition do
  begin
      Active := false;
      Params.ParamByName('art').Value := ds_article.DataSet.FieldByName('ARTI_Clep').asString;
      Open;
  end; }
{  if assigned ( F_SeleArticle )
  and F_SeleArticle.Visible Then
    F_SeleArticle.lb_datecreation.Caption := FormatDateTime('d/mm/yyyy',M_Article.zq_Article.FieldByName('ARTI_Datecrea').AsDateTime);}

  TDateField(M_Article.ds_article.DataSet.FieldByName('ARTI_Datecrea')).DisplayFormat := U_CST_format_date_2;    
end;


procedure TM_Article.zq_articleNewRecord(DataSet: TDataSet);
begin
  DataSet.FieldByName('ARTI_Datecrea').AsDateTime := now;
  DataSet.FieldByName('ARTI_Compose').AsBoolean  := False;
end;

procedure TM_Article.zq_SelGammeAfterScroll(DataSet: TDataSet);
begin
  zq_Sel1TypPro.Close ;
  zq_Sel1TypPro.Params.FindParam ( 'groupe' ).Value := DATaset.FieldByName ( 'GAMM_Clep' ).Value;
  zq_Sel1TypPro.Open ;
end;

procedure TM_Article.zq_SelTypProAfterScroll(DataSet: TDataSet);
begin
  zq_Sel1Carac.Close ;
  zq_Sel1Carac.Params.FindParam ( 'groupe' ).Value := DATaset.FieldByName ( 'TYPR_Clep' ).Value;
  zq_Sel1Carac.Open ;

end;

procedure TM_Article.zq_SelTypProAfterOpen(DataSet: TDataSet);
begin
  zq_SelTypProAfterScroll ( Dataset );
end;

procedure TM_Article.zq_SelGammeAfterOpen(DataSet: TDataSet);
begin
  zq_SelGammeAfterScroll ( Dataset );
end;


procedure TM_Article.zq_articleAfterOpen(DataSet: TDataSet);
begin
  TDateTimeField (DataSet.FieldByName( 'ARTI_Datecrea' )).DisplayFormat := U_CST_format_date_2 ;
  TNumericField  (DataSet.FieldByName( 'ARTI_Pxactu'   )).DisplayFormat := U_CST_format_money_1 ;
  TNumericField  (DataSet.FieldByName( 'ARTI_Pxfutur'  )).DisplayFormat := U_CST_format_money_1 ;
  TNumericField  (DataSet.FieldByName( 'ARTI_Cubage'   )).DisplayFormat := U_CST_format_money_1 ;
  TNumericField  (DataSet.FieldByName( 'ARTI_Coefcub'  )).DisplayFormat := U_CST_format_money_1 ;
  TNumericField  (DataSet.FieldByName( 'ARTI_Poids'    )).DisplayFormat := U_CST_format_money_1 ;
end;

procedure TM_Article.zq_AffectePostError(DataSet: TDataSet;
  E: EDatabaseError; var Action: TDataAction);
begin
  MessageDlg ( 'La zone ''Nom de la zone'' ne peut pas ?tre vide.' + #13 + #13
                           + 'Effectuer une saisie ou annuler.', mtWarning, [mbOk], 0)
end;


procedure TM_Article.zq_FinitionAfterOpen(DataSet: TDataSet);
begin
  TNumericField ( Dataset.FieldByName ( 'FINI_Txcharge' )).DisplayFormat := U_CST_format_money_1 ;
end;

procedure TM_Article.zq_GammeEAfterOpen(DataSet: TDataSet);
begin
  zq_GammeEAfterScroll ( Dataset );

end;

procedure TM_Article.zq_GammeEAfterScroll(DataSet: TDataSet);
begin
  zq_Sel1TypPro2.Close ;
  zq_Sel1TypPro2.Params.FindParam ( 'groupe' ).Value := DATaset.FieldByName ( 'GAMM_Clep' ).Value;
  zq_Sel1TypPro2.Open ;

end;

procedure TM_Article.zq_SelTypPro2AfterOpen(DataSet: TDataSet);
begin
  zq_SelTypPro2AfterScroll ( Dataset );

end;

procedure TM_Article.zq_SelTypPro2AfterScroll(DataSet: TDataSet);
begin
  zq_Sel1Carac2.Close ;
  zq_Sel1Carac2.Params.FindParam ( 'groupe' ).Value := DATaset.FieldByName ( 'TYPR_Clep' ).Value;
  zq_Sel1Carac2.Open ;

end;

procedure TM_Article.zq_Sel1TypPro2AfterOpen(DataSet: TDataSet);
begin
  zq_SelTypPro2AfterScroll ( Dataset );

end;

procedure TM_Article.zq_Sel1TypPro2AfterScroll(DataSet: TDataSet);
begin
  zq_Sel1Carac2.Close ;
  zq_Sel1Carac2.Params.FindParam ( 'groupe' ).Value := DATaset.FieldByName ( 'TYPR_Clep' ).Value;
  zq_Sel1Carac2.Open ;

end;



procedure TM_Article.zq_Article1AfterInsert(DataSet: TDataSet);
begin
  DataSet.FieldByName ( 'ARTI_Declasse' ).Value := 0;
  DataSet.FieldByName ( 'ARTI_Compose'  ).Value := 0;

  if gi_niveau_priv = U_CST_ASSISTANT then
    Dataset.FieldByName ('ARTI_Indicspe').Value := 1
  else
    DataSet.FieldByName ( 'ARTI_Indicspe' ).Value := 0;

end;


procedure TM_Article.zq_Article1AfterPost(DataSet: TDataSet);
begin
  if ( ds_article.DataSet <> zq_Article1 ) Then
    zq_Article1.Close ;
  if ( ds_article.DataSet <> zq_Article2 ) Then
    zq_Article2.Close ;
  if ( ds_article.DataSet <> zq_Article3 ) Then
    zq_Article3.Close ;
  if ( ds_article.DataSet <> zq_Article4 ) Then
    zq_Article4.Close ;
  if ( ds_article.DataSet <> zq_Article5 ) Then
    zq_Article5.Close ;
  if ( ds_article.DataSet <> zq_Article6 ) Then
    zq_Article6.Close ;
end;

procedure TM_Article.zq_ArbreArtAfterOpen(DataSet: TDataSet);
begin
  TNumericField(zq_ArbreArt.FieldByName('ARDE_Prix')).DisplayFormat := U_CST_format_money_1 ;
end;

///////////////////////////////////////////////////////////////////////
// Procedure : zq_ArticleBeforeEdit
// Description : controle du profil, car une assitante ne peut modifier
//    que les articles speciaux (donc pas de creation ni suppr ni modif
//    de l'article ou de ses finitions)
///////////////////////////////////////////////////////////////////////
// ATTENTION CETTE PROCEDURE EST EGALEMENT UTILISE dans
//  zq_artcoulbeforeEdit, zq_artcoulbeforeInsert,zq_artcoulbeforedelete
///////////////////////////////////////////////////////////////////////
procedure TM_Article.zq_Article1BeforeEdit(DataSet: TDataSet);
begin
  if gi_niveau_priv = U_CST_ASSISTANT then
  begin
    if not ds_article.DataSet.FieldByName ('ARTI_Indicspe').Asboolean then
    begin
      MessageDlg(U_CST_9032,mtWarning,[mbOk],0);
      Abort;
    end;
  end;
end;


end.

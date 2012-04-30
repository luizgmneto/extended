unit U_DmArticles;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
  SysUtils, StrUtils, Classes, DB, ZDataset, Forms, Dialogs, controls,
  fonctions_string, IBIntf, U_ConstMessage, IBDatabase, IBQuery, IBUpdateSQL,
  IBCustomDataSet;
const CST_APPLI_NAME =  'Article';
type

  { TM_Article }

  TM_Article = class(TDataModule)
    ds_article: TDataSource;
    ds_gammarti: TDatasource;
    ds_typearti: TDatasource;
    IBDatabase: TIBDatabase;
    IBTransaction: TIBTransaction;
    IBU_Article: TIBUpdateSQL;
    IBU_Gamme: TIBUpdateSQL;
    IBU_TypProd: TIBUpdateSQL;
    IBU_Carac: TIBUpdateSQL;
    IBU_TypArt: TIBUpdateSQL;
    IB_artcoul: TIBQuery;
    IB_GamTProIn: TIBQuery;
    IB_GamTProOut: TIBQuery;
    IB_Gamme: TIBQuery;
    ds_Gamme: TDataSource;
    IB_TypProduit: TIBQuery;
    ds_TypProduit: TDataSource;
    IB_Carac: TIBQuery;
    ds_Carac: TDataSource;
    IB_SelCarac: TIBQuery;
    IB_SelTypPro: TIBQuery;
    IB_SelGamme: TIBQuery;
    IB_Sel1Carac: TIBQuery;
    IB_Sel1TypPro: TIBQuery;
    IB_SelCarac2: TIBQuery;
    IB_SelTypPro2: TIBQuery;
    IB_GammeE: TIBQuery;
    IB_Sel1Carac2: TIBQuery;
    IB_Sel1TypPro2: TIBQuery;
    IB_CocoCoul: TIBQuery;
    IB_TyfiInFini: TIBQuery;
    IB_TyfiOutFini: TIBQuery;
    IB_FiniInTyFi: TIBQuery;
    IB_FiniOutTyFi: TIBQuery;
    ds_FiltreProduit: TDataSource;
    IB_FiltreProduit: TIBQuery;
    IB_Article1: TIBQuery;
    IB_prod_acces: TIBQuery;
    IB_ArbreArt: TIBQuery;
    IB_code_copieart: TIBQuery;
    IB_copieart: TIBQuery;
    IB_ArFini: TIBQuery;
    IB_Article2: TIBQuery;
    IB_Article3: TIBQuery;
    IB_Article4: TIBQuery;
    IB_Article5: TIBQuery;
    IB_Article6: TIBQuery;
    zq_Article: TIBQuery;
    zq_Carac: TIBQuery;
    zq_FiltreProduit: TIBQuery;
    ib_gammarti: TIBQuery;
    zq_Gamme: TIBQuery;
    ib_typearti: TIBQuery;
    zq_TypProduit: TIBQuery;
    procedure DataModuleCreate(Sender: TObject);
    procedure IB_articleAfterScroll(DataSet: TDataSet);
    procedure IB_articleNewRecord(DataSet: TDataSet);
    procedure IB_SelGammeAfterScroll(DataSet: TDataSet);
    procedure IB_SelTypProAfterScroll(DataSet: TDataSet);
    procedure IB_SelTypProAfterOpen(DataSet: TDataSet);
    procedure IB_SelGammeAfterOpen(DataSet: TDataSet);
    procedure IB_articleAfterOpen(DataSet: TDataSet);
    procedure IB_AffectePostError(DataSet: TDataSet; E: EDatabaseError;
      var Action: TDataAction);
    procedure IB_FinitionAfterOpen(DataSet: TDataSet);
    procedure IB_GammeEAfterOpen(DataSet: TDataSet);
    procedure IB_GammeEAfterScroll(DataSet: TDataSet);
    procedure IB_SelTypPro2AfterOpen(DataSet: TDataSet);
    procedure IB_SelTypPro2AfterScroll(DataSet: TDataSet);
    procedure IB_Sel1TypPro2AfterOpen(DataSet: TDataSet);
    procedure IB_Sel1TypPro2AfterScroll(DataSet: TDataSet);
    procedure IB_Article1AfterInsert(DataSet: TDataSet);
    procedure IB_Article1AfterPost(DataSet: TDataSet);
    procedure IB_ArbreArtAfterOpen(DataSet: TDataSet);

  private
    { D?clarations priv?es }
  public
    gi_AccesProduits : Integer ;
    { D?clarations publiques }
  end;

var
  M_Article: TM_Article;

implementation

uses Variants , fonctions_dbcomponents;

{$IFNDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

procedure p_setLibrary (var libname: string);
Begin
  libname:= ExtractFileDir(Application.ExeName)+DirectorySeparator+'fbclient.dll';
  {$IFDEF LINUX}
  libname:= ExtractFileDir(Application.ExeName)+DirectorySeparator+'libfbembed.so';
  {$ENDIF}
end;

procedure TM_Article.IB_articleAfterScroll(DataSet: TDataSet);
begin
 { with  IB_artfinition do
  begin
      Active := false;
      Params.ParamByName('art').Value := ds_article.DataSet.FieldByName('ARTI_Clep').asString;
      Open;
  end; }
{  if assigned ( F_SeleArticle )
  and F_SeleArticle.Visible Then
    F_SeleArticle.lb_datecreation.Caption := FormatDateTime('d/mm/yyyy',M_Article.IB_Article.FieldByName('ARTI_Datecrea').AsDateTime);}

  TDateField(M_Article.ds_article.DataSet.FieldByName('ARTI_Datecrea')).DisplayFormat := U_CST_format_date_2;    
end;

procedure TM_Article.DataModuleCreate(Sender: TObject);
var li_i : Integer;
    lstl_conf : TStringList;
begin
  IBDatabase.DatabaseName:=ExtractFileDir(Application.ExeName)+DirectorySeparator+'Exemple.fdb';
  {$IFDEF LINUX}
  try
    lstl_conf := TStringList.Create;
    lstl_conf.Text := 'RootDirectory='+ExtractFileDir(Application.ExeName);
    lstl_conf.SaveToFile(ExtractFileDir(Application.ExeName)+DirectorySeparator+'firebird.conf');
    lstl_conf.Clear;
    lstl_conf.Text := 'Exemple='+ExtractFileDir(Application.ExeName)+DirectorySeparator+'Exemble.fdb'+#13#10
                    + 'security2='+ExtractFileDir(Application.ExeName)+DirectorySeparator+'security2.fdb'+#13#10
                    + 'Exemple.fdb='+ExtractFileDir(Application.ExeName)+DirectorySeparator+'Exemble.fdb'+#13#10
                    + 'security2.fdb='+ExtractFileDir(Application.ExeName)+DirectorySeparator+'security2.fdb';
    lstl_conf.SaveToFile(ExtractFileDir(Application.ExeName)+DirectorySeparator+'aliases.conf');
  finally
    lstl_conf.Free;
  end;
  {$ENDIF}
  for li_i := 0 to ComponentCount - 1 do
    if Components[li_i] is TIBQuery Then
     with Components[li_i] as TIBQuery do
      Begin
        Database:=IBDatabase;
        Transaction:=IBTransaction;
      end;
  IBDatabase.Connected := True;
end;


procedure TM_Article.IB_articleNewRecord(DataSet: TDataSet);
begin
  DataSet.FieldByName('ARTI_Datecrea').AsDateTime := now;
  DataSet.FieldByName('ARTI_Compose').AsBoolean  := False;
end;

procedure TM_Article.IB_SelGammeAfterScroll(DataSet: TDataSet);
begin
  IB_Sel1TypPro.Close ;
  IB_Sel1TypPro.ParamByName( 'groupe' ).Value := DATaset.FieldByName ( 'GAMM_Clep' ).Value;
  IB_Sel1TypPro.Open ;
end;

procedure TM_Article.IB_SelTypProAfterScroll(DataSet: TDataSet);
begin
  IB_Sel1Carac.Close ;
  IB_Sel1Carac.ParamByName( 'groupe' ).Value := DATaset.FieldByName ( 'TYPR_Clep' ).Value;
  IB_Sel1Carac.Open ;

end;

procedure TM_Article.IB_SelTypProAfterOpen(DataSet: TDataSet);
begin
  IB_SelTypProAfterScroll ( Dataset );
end;

procedure TM_Article.IB_SelGammeAfterOpen(DataSet: TDataSet);
begin
  IB_SelGammeAfterScroll ( Dataset );
end;


procedure TM_Article.IB_articleAfterOpen(DataSet: TDataSet);
begin
  TDateTimeField (DataSet.FieldByName( 'ARTI_Datecrea' )).DisplayFormat := U_CST_format_date_2 ;
  TNumericField  (DataSet.FieldByName( 'ARTI_Pxactu'   )).DisplayFormat := U_CST_format_money_1 ;
  TNumericField  (DataSet.FieldByName( 'ARTI_Pxfutur'  )).DisplayFormat := U_CST_format_money_1 ;
  TNumericField  (DataSet.FieldByName( 'ARTI_Cubage'   )).DisplayFormat := U_CST_format_money_1 ;
  TNumericField  (DataSet.FieldByName( 'ARTI_Coefcub'  )).DisplayFormat := U_CST_format_money_1 ;
  TNumericField  (DataSet.FieldByName( 'ARTI_Poids'    )).DisplayFormat := U_CST_format_money_1 ;
end;

procedure TM_Article.IB_AffectePostError(DataSet: TDataSet;
  E: EDatabaseError; var Action: TDataAction);
begin
  MessageDlg ( 'La zone ''Nom de la zone'' ne peut pas ?tre vide.' + #13 + #13
                           + 'Effectuer une saisie ou annuler.', mtWarning, [mbOk], 0)
end;


procedure TM_Article.IB_FinitionAfterOpen(DataSet: TDataSet);
begin
  TNumericField ( Dataset.FieldByName ( 'FINI_Txcharge' )).DisplayFormat := U_CST_format_money_1 ;
end;

procedure TM_Article.IB_GammeEAfterOpen(DataSet: TDataSet);
begin
  IB_GammeEAfterScroll ( Dataset );

end;

procedure TM_Article.IB_GammeEAfterScroll(DataSet: TDataSet);
begin
  IB_Sel1TypPro2.Close ;
  IB_Sel1TypPro2.ParamByName( 'groupe' ).Value := DATaset.FieldByName ( 'GAMM_Clep' ).Value;
  IB_Sel1TypPro2.Open ;

end;

procedure TM_Article.IB_SelTypPro2AfterOpen(DataSet: TDataSet);
begin
  IB_SelTypPro2AfterScroll ( Dataset );

end;

procedure TM_Article.IB_SelTypPro2AfterScroll(DataSet: TDataSet);
begin
  IB_Sel1Carac2.Close ;
  IB_Sel1Carac2.ParamByName( 'groupe' ).Value := DATaset.FieldByName ( 'TYPR_Clep' ).Value;
  IB_Sel1Carac2.Open ;

end;

procedure TM_Article.IB_Sel1TypPro2AfterOpen(DataSet: TDataSet);
begin
  IB_SelTypPro2AfterScroll ( Dataset );

end;

procedure TM_Article.IB_Sel1TypPro2AfterScroll(DataSet: TDataSet);
begin
  IB_Sel1Carac2.Close ;
  IB_Sel1Carac2.ParamByName( 'groupe' ).Value := DATaset.FieldByName ( 'TYPR_Clep' ).Value;
  IB_Sel1Carac2.Open ;

end;



procedure TM_Article.IB_Article1AfterInsert(DataSet: TDataSet);
begin
  DataSet.FieldByName ( 'ARTI_Declasse' ).Value := 0;
  DataSet.FieldByName ( 'ARTI_Compose'  ).Value := 0;

end;


procedure TM_Article.IB_Article1AfterPost(DataSet: TDataSet);
begin
  if ( ds_article.DataSet <> IB_Article1 ) Then
    IB_Article1.Close ;
  if ( ds_article.DataSet <> IB_Article2 ) Then
    IB_Article2.Close ;
  if ( ds_article.DataSet <> IB_Article3 ) Then
    IB_Article3.Close ;
  if ( ds_article.DataSet <> IB_Article4 ) Then
    IB_Article4.Close ;
  if ( ds_article.DataSet <> IB_Article5 ) Then
    IB_Article5.Close ;
  if ( ds_article.DataSet <> IB_Article6 ) Then
    IB_Article6.Close ;
end;

procedure TM_Article.IB_ArbreArtAfterOpen(DataSet: TDataSet);
begin
  TNumericField(IB_ArbreArt.FieldByName('ARDE_Prix')).DisplayFormat := U_CST_format_money_1 ;
end;


{$IFDEF FPC}
initialization
  OnGetLibraryName:= TOnGetLibraryName( p_setLibrary);
{$ENDIF}
end.

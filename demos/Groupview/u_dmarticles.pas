unit U_DmArticles;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
  SysUtils, StrUtils, Classes, DB, process, ZDataset, Forms, Dialogs, controls,
  fonctions_string, uib, U_ConstMessage, uibdataset;
const CST_APPLI_NAME =  'Article';
type

  { TM_Article }

  TM_Article = class(TDataModule)
    ds_article: TDataSource;
    ds_caraarti: TDatasource;
    ds_gammarti: TDatasource;
    ds_typearti: TDatasource;
    IBDatabase: TUIBDataBase;
    IBTransaction: TUIBTransaction;
    IB_artcoul: TUIBDataset;
    ds_ARCO: TDataSource;
    ds_GamTProIn: TDataSource;
    IB_GamTProIn: TUIBDataset;
    ds_GamTProOut: TDataSource;
    IB_GamTProOut: TUIBDataset;
    IB_Gamme: TUIBDataset;
    ds_Gamme: TDataSource;
    IB_TypProduit: TUIBDataset;
    ds_TypProduit: TDataSource;
    IB_Carac: TUIBDataset;
    ds_Carac: TDataSource;
    ds_SelCarac: TDataSource;
    IB_SelCarac: TUIBDataset;
    IB_SelTypPro: TUIBDataset;
    ds_SelTypPro: TDataSource;
    IB_SelGamme: TUIBDataset;
    ds_SelGamme: TDataSource;
    ds_Sel1Carac: TDataSource;
    IB_Sel1Carac: TUIBDataset;
    IB_Sel1TypPro: TUIBDataset;
    ds_Sel1TypPro: TDataSource;
    ds_SelCarac2: TDataSource;
    IB_SelCarac2: TUIBDataset;
    IB_SelTypPro2: TUIBDataset;
    ds_SelTypPro2: TDataSource;
    IB_GammeE: TUIBDataset;
    ds_GammeE: TDataSource;
    ds_Sel1Carac2: TDataSource;
    IB_Sel1Carac2: TUIBDataset;
    IB_Sel1TypPro2: TUIBDataset;
    ds_Sel1TypPro2: TDataSource;
    ds_ArFini: TDataSource;
    IB_CocoCoul: TUIBDataset;
    ds_CocoCoul: TDataSource;
    IB_TyfiInFini: TUIBDataset;
    ds_TyfiInFini: TDataSource;
    IB_TyfiOutFini: TUIBDataset;
    ds_TyfiOutFini: TDataSource;
    IB_FiniInTyFi: TUIBDataset;
    ds_FiniInTyFi: TDataSource;
    IB_FiniOutTyFi: TUIBDataset;
    ds_FiniOutTyFi: TDataSource;
    ds_FiltreProduit: TDataSource;
    IB_FiltreProduit: TUIBDataset;
    IB_Article1: TUIBDataset;
    IB_prod_acces: TUIBDataset;
    ds_prod_acces: TDataSource;
    ds_ArbreArt: TDataSource;
    IB_ArbreArt: TUIBDataset;
    IB_code_copieart: TUIBDataset;
    IB_copieart: TUIBDataset;
    IB_ArFini: TUIBDataset;
    IB_Article2: TUIBDataset;
    IB_Article3: TUIBDataset;
    IB_Article4: TUIBDataset;
    IB_Article5: TUIBDataset;
    IB_Article6: TUIBDataset;
    Process: TProcess;
    zq_ArbreArt: TUIBDataSet;
    zq_ArFini: TUIBDataSet;
    zq_artcoul: TUIBDataSet;
    zq_Article: TUIBDataSet;
    zq_Article2: TUIBDataSet;
    zq_Article3: TUIBDataSet;
    zq_Article4: TUIBDataSet;
    zq_Article5: TUIBDataSet;
    zq_Article6: TUIBDataSet;
    ib_caraarti: TUIBDataSet;
    zq_Carac: TUIBDataSet;
    zq_CocoCoul: TUIBDataSet;
    zq_code_copieart: TUIBDataSet;
    zq_copieart: TUIBDataSet;
    ib_desaffecte: TUIBDataSet;
    zq_FiltreProduit: TUIBDataSet;
    zq_FiniInTyFi: TUIBDataSet;
    zq_FiniOutTyFi: TUIBDataSet;
    ib_gammarti: TUIBDataSet;
    zq_Gamme: TUIBDataSet;
    zq_GammeE: TUIBDataSet;
    zq_GamTProIn: TUIBDataSet;
    zq_GamTProOut: TUIBDataSet;
    ib_majTypArt: TUIBDataSet;
    ib_majGamme: TUIBDataSet;
    ib_majcara: TUIBDataSet;
    zq_prod_acces: TUIBDataSet;
    zq_Sel1Carac: TUIBDataSet;
    zq_Sel1Carac2: TUIBDataSet;
    zq_Sel1TypPro: TUIBDataSet;
    zq_Sel1TypPro2: TUIBDataSet;
    zq_SelCarac: TUIBDataSet;
    zq_SelCarac2: TUIBDataSet;
    zq_SelGamme: TUIBDataSet;
    zq_SelTypPro: TUIBDataSet;
    zq_SelTypPro2: TUIBDataSet;
    zq_TyfiInFini: TUIBDataSet;
    zq_TyfiOutFini: TUIBDataSet;
    ib_typearti: TUIBDataSet;
    zq_TypProduit: TUIBDataSet;
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
  IBDatabase.LibraryName:= 'fbclient.dll';
  {$IFDEF LINUX}
  try
    lstl_conf := TStringList.Create;
    lstl_conf.Text := 'RootDirectory='+ExtractFileDir(Application.ExeName)+#13#10+
                      'TempDirectories='+ExtractFileDir(Application.ExeName)+DirectorySeparator+'firebird';
    lstl_conf.SaveToFile(ExtractFileDir(Application.ExeName)+DirectorySeparator+'firebird.conf');
    lstl_conf.Text := 'export LD_LIBRARY_PATH='''+ExtractFileDir(Application.ExeName)+''''+#10+
                      'export FIREBIRD='''+ExtractFileDir(Application.ExeName)+'''';
    lstl_conf.SaveToFile(ExtractFileDir(Application.ExeName)+DirectorySeparator+'firebird.sh');
    Process.CommandLine:='chmod 777 '''+ExtractFileDir(Application.ExeName)+DirectorySeparator+'firebird.sh'+'''';
    Process.Execute;
    Process.CommandLine:=''''+ExtractFileDir(Application.ExeName)+DirectorySeparator+'firebird.sh'+'''';
    Process.Execute;

  finally
  end;
  IBDatabase.DatabaseName:=ExtractFileDir(Application.ExeName)+DirectorySeparator+'Exemple.fdb';
  IBDatabase.LibraryName:= ExtractFileDir(Application.ExeName)+DirectorySeparator+'libfbembed.so';
  {$ENDIF}
  for li_i := 0 to ComponentCount - 1 do
    if Components[li_i] is TUIBDataSet Then
     with Components[li_i] as TUIBDataSet do
      Begin
        Database:=IBDatabase;
        Transaction:=IBTransaction;
      end;
end;


procedure TM_Article.IB_articleNewRecord(DataSet: TDataSet);
begin
  DataSet.FieldByName('ARTI_Datecrea').AsDateTime := now;
  DataSet.FieldByName('ARTI_Compose').AsBoolean  := False;
end;

procedure TM_Article.IB_SelGammeAfterScroll(DataSet: TDataSet);
begin
  IB_Sel1TypPro.Close ;
  IB_Sel1TypPro.Params.Values[ 'groupe' ].Value := DATaset.FieldByName ( 'GAMM_Clep' ).Value;
  IB_Sel1TypPro.Open ;
end;

procedure TM_Article.IB_SelTypProAfterScroll(DataSet: TDataSet);
begin
  IB_Sel1Carac.Close ;
  IB_Sel1Carac.Params.Values[ 'groupe' ].Value := DATaset.FieldByName ( 'TYPR_Clep' ).Value;
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
  IB_Sel1TypPro2.Params.Values[ 'groupe' ].Value := DATaset.FieldByName ( 'GAMM_Clep' ).Value;
  IB_Sel1TypPro2.Open ;

end;

procedure TM_Article.IB_SelTypPro2AfterOpen(DataSet: TDataSet);
begin
  IB_SelTypPro2AfterScroll ( Dataset );

end;

procedure TM_Article.IB_SelTypPro2AfterScroll(DataSet: TDataSet);
begin
  IB_Sel1Carac2.Close ;
  IB_Sel1Carac2.Params.Values[ 'groupe' ].Value := DATaset.FieldByName ( 'TYPR_Clep' ).Value;
  IB_Sel1Carac2.Open ;

end;

procedure TM_Article.IB_Sel1TypPro2AfterOpen(DataSet: TDataSet);
begin
  IB_SelTypPro2AfterScroll ( Dataset );

end;

procedure TM_Article.IB_Sel1TypPro2AfterScroll(DataSet: TDataSet);
begin
  IB_Sel1Carac2.Close ;
  IB_Sel1Carac2.Params.Values[ 'groupe' ].Value := DATaset.FieldByName ( 'TYPR_Clep' ).Value;
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


end.

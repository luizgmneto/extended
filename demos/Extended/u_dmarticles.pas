unit U_DmArticles;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}
{$I ..\..\DLCompilers.inc}
{$I ..\..\extends.inc}
interface

uses
  SysUtils, StrUtils, Classes, DB, Forms, Dialogs, controls,
{$IFDEF FPC}
  process, 
{$ENDIF}
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
    IB_Gamme: TIBQuery;
    ds_Gamme: TDataSource;
    IB_TypProduit: TIBQuery;
    ds_TypProduit: TDataSource;
    IB_Carac: TIBQuery;
    ds_Carac: TDataSource;
    ds_FiltreProduit: TDataSource;
    IB_FiltreProduit: TIBQuery;
    IB_Article: TIBQuery;
    ib_gammarti: TIBQuery;
    ib_typearti: TIBQuery;
    {$IFDEF FPC}
    Process: TProcess;
    zq_Carac: TIBQuery;
    zq_FiltreProduit: TIBQuery;
    zq_Gamme: TIBQuery;
    zq_Article: TIBQuery;
    zq_TypProduit: TIBQuery;
    {$ENDIF}
    procedure DataModuleCreate(Sender: TObject);
    procedure IB_articleAfterScroll(DataSet: TDataSet);
    procedure IB_articleNewRecord(DataSet: TDataSet);
    procedure IB_articleAfterOpen(DataSet: TDataSet);
    procedure IB_FinitionAfterOpen(DataSet: TDataSet);
    procedure IB_Article1AfterInsert(DataSet: TDataSet);

  private
    { Déclarations privées }
  public
    gi_AccesProduits : Integer ;
    { Déclarations publiques }
  end;

var
  M_Article: TM_Article;

implementation

uses Variants , fonctions_dbcomponents, fonctions_system;

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

//  TDateField(M_Article.ds_article.DataSet.FieldByName('ARTI_Datecrea')).DisplayFormat := U_CST_format_date_2;    
end;

procedure TM_Article.DataModuleCreate(Sender: TObject);
var li_i : Integer;
    lstl_conf : TStringList;
begin
  IBDatabase.DatabaseName:=gs_DefaultDatabase;
  {$IFNDEF FPC}
  IBDatabase.Params.Add('lc_ctype=utf8');
  {$ENDIF}
  for li_i := 0 to ComponentCount - 1 do
    if Components[li_i] is TIBQuery Then
     with Components[li_i] as TIBQuery do
      Begin
        Database:=IBDatabase;
        Transaction:=IBTransaction;
      end;
  IBDatabase.Connected := True;
  IBTransaction.Active := True;
end;


procedure TM_Article.IB_articleNewRecord(DataSet: TDataSet);
begin
//  DataSet.FieldByName('ARTI_Datecrea').AsDateTime := now;
  DataSet.FieldByName('ARTI_Compose').AsBoolean  := False;
end;


procedure TM_Article.IB_articleAfterOpen(DataSet: TDataSet);
begin
//  TDateTimeField (DataSet.FieldByName( 'ARTI_Datecrea' )).DisplayFormat := U_CST_format_date_2 ;
{  TNumericField  (DataSet.FieldByName( 'ARTI_Pxactu'   )).DisplayFormat := U_CST_format_money_1 ;
  TNumericField  (DataSet.FieldByName( 'ARTI_Pxfutur'  )).DisplayFormat := U_CST_format_money_1 ;
  TNumericField  (DataSet.FieldByName( 'ARTI_Cubage'   )).DisplayFormat := U_CST_format_money_1 ;
  TNumericField  (DataSet.FieldByName( 'ARTI_Coefcub'  )).DisplayFormat := U_CST_format_money_1 ;
  TNumericField  (DataSet.FieldByName( 'ARTI_Poids'    )).DisplayFormat := U_CST_format_money_1 ;}
end;

procedure TM_Article.IB_FinitionAfterOpen(DataSet: TDataSet);
begin
  TNumericField ( Dataset.FieldByName ( 'FINI_Txcharge' )).DisplayFormat := U_CST_format_money_1 ;
end;


procedure TM_Article.IB_Article1AfterInsert(DataSet: TDataSet);
begin
  DataSet.FieldByName ( 'ARTI_Declasse' ).Value := 0;
  DataSet.FieldByName ( 'ARTI_Compose'  ).Value := 0;

end;

end.

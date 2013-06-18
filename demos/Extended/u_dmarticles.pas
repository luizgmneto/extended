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
    {$ENDIF}
    procedure DataModuleCreate(Sender: TObject);
    procedure IB_articleAfterScroll(DataSet: TDataSet);
    procedure IB_articleNewRecord(DataSet: TDataSet);
    procedure IB_articleAfterOpen(DataSet: TDataSet);
    procedure IB_AffectePostError(DataSet: TDataSet; E: EDatabaseError;
      var Action: TDataAction);
    procedure IB_FinitionAfterOpen(DataSet: TDataSet);
    procedure IB_Article1AfterInsert(DataSet: TDataSet);

  private
    { D?clarations privées }
  public
    gi_AccesProduits : Integer ;
    { D?clarations publiques }
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

procedure p_executeQuery ( const Adat_dataset : TDataSet );
Begin
  if Adat_dataset is TIBQuery Then
   ( Adat_dataset as TIBQuery ).ExecSQL;
end;



procedure p_setLibrary (var libname: string);
{$IFNDEF WINDOWS}
var AProcess : TProcess;
{$ENDIF}
Begin
  {$IFDEF WINDOWS}
  libname:= ExtractFileDir(Application.ExeName)+DirectorySeparator+'fbclient'+CST_EXTENSION_LIBRARY;
  {$ELSE}
  libname:= ExtractFileDir(Application.ExeName)+DirectorySeparator+'libfbembed'+CST_EXTENSION_LIBRARY;
  if FileExists(libname) Then
    Begin
      AProcess := TProcess.Create(nil);
      with AProcess do
        try
          CommandLine:='sh "'+ExtractFileDir(Application.ExeName)+DirectorySeparator+'exec.sh"';
          Execute;
          Exit;

        finally
          AProcess.Free;
        end;
    end;
  if not FileExists(libname)
    Then libname:='/usr/lib/libfbembed.so.2.5';
  if not FileExists(libname)
    Then libname:='/usr/lib/libfbembed.so';
  if not FileExists(libname)
    Then libname:='/usr/lib/i386-linux-gnu/libfbembed.so.2.5';
  if not FileExists(libname)
    Then libname:='/usr/lib/x86_64-linux-gnu/libfbembed.so.2.5';
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
  {$IFNDEF WINDOWS}
  Process.CommandLine:=ExtractFileDir(Application.ExeName)+DirectorySeparator+'exec.sh';
  Process.Execute;
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


procedure TM_Article.IB_Article1AfterInsert(DataSet: TDataSet);
begin
  DataSet.FieldByName ( 'ARTI_Declasse' ).Value := 0;
  DataSet.FieldByName ( 'ARTI_Compose'  ).Value := 0;

end;


initialization
  {$IFDEF FPC}
  OnGetLibraryName:= TOnGetLibraryName( p_setLibrary);
  ge_OnExecuteQuery := TOnExecuteQuery ( p_executeQuery );
  {$ENDIF}
end.

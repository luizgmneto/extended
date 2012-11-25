unit fonctions_dbcomponents;

interface

{$IFDEF FPC}
{$mode Delphi}
{$ENDIF}

{$I ..\DLCompilers.inc}
{$I ..\extends.inc}

uses SysUtils,
  {$IFDEF DELPHI_9_UP}
     WideStrings,
  {$ENDIF}
  DB,
  {$IFDEF EADO}
    ADODB,
  {$ENDIF}
  {$IFDEF VERSIONS}
  fonctions_version,
  {$ENDIF}
  Controls,
  DBCtrls, ExtCtrls,
  fonctions_db,
  Classes ;

type
  TOnExecuteQuery = procedure ( const adat_Dataset: Tdataset );

const
  {$IFDEF VERSIONS}
  gVer_fonctions_db_components : T_Version = ( Component : 'Gestion des données d''une fiche' ;
                                         FileUnit : 'fonctions_dbcomponents' ;
      			                 Owner : 'Matthieu Giroux' ;
      			                 Comment : 'Fonctions gestion des données avec les composants visuels.' ;
      			                 BugsStory : 'Version 1.1.0.2 : Too many code on fb_inserecompteur, creating functions.' + #13#10 +
                                                     'Version 1.1.0.1 : Simplify function fb_InsereCompteur.' + #13#10 +
                                                     'Version 1.1.0.0 : Ajout de fonctions d''automatisation.' + #13#10
                                                   + 'Version 1.0.0.0 : Gestion des donnÃ©es rétilisable.';
      			                 UnitType : 1 ;
      			                 Major : 1 ; Minor : 1 ; Release : 0 ; Build : 2 );

  {$ENDIF}
  ge_OnExecuteQuery: TOnExecuteQuery = nil;
  ge_OnRefreshDataset : TSpecialFuncDataset = nil;
  CST_DBPROPERTY_SQL = 'SQL';
  CST_DBPROPERTY_SQLCONNECTION = 'SQLConnection';
  CST_DBPROPERTY_CONNECTION = 'Connection';
  CST_DBPROPERTY_ONLINECONN = 'OnLineConn';
  CST_DBPROPERTY_CONNECTIONSTRING = 'ConnectionString';
  CST_DBPROPERTY_TRANSACTION = 'Transaction';
  CST_DBPROPERTY_DATABASE = 'Database';
  CST_DBPROPERTY_DATABASENAME = 'DatabaseName';
  CST_DBPROPERTY_SESSIONNAME = 'SessionName';
  CST_DBPROPERTY_CLIENTPARAM = 'ClientParam';
  CST_DBPROPERTY_ZEOSDB = 'ZeosDBConnection';
  CST_DBPROPERTY_ENDPARAM = ';';
function fb_InsereCompteur ( const adat_Dataset, adat_DatasetQuery : TDataset ;
                             const aslt_Cle : TStringlist ;
                             const as_ChampCompteur, as_Table, as_PremierLettrage : String ;
                             const ach_DebutLettrage, ach_FinLettrage : Char ;
                             const ali_Debut, ali_LimiteRecherche     : Int64 ;
                             const ab_DBMessageOnError  : Boolean ): Boolean;
function fb_RefreshDataset ( const aDat_Dataset : TDataset ): Boolean ; overload;
function fb_RefreshDataset ( const aDat_Dataset : TDataset; const ab_GardePosition : Boolean ): Boolean ; overload;
procedure p_AutoConnection ( const adat_Dataset : TDataset; const AConnect : Boolean = True );
procedure p_OpenSQLQuery(const adat_Dataset: Tdataset; const as_Query : {$IFDEF DELPHI_9_UP} String {$ELSE} WideString{$ENDIF} );
function  fs_getSQLQuery ( const adat_Dataset : Tdataset ): String;
procedure p_SetSQLQuery(const adat_Dataset: Tdataset; const as_Query : {$IFDEF DELPHI_9_UP} String {$ELSE} WideString{$ENDIF} );
procedure p_AddSQLQuery(const adat_Dataset: Tdataset; const as_Query : {$IFDEF DELPHI_9_UP} String {$ELSE} WideString{$ENDIF} );
procedure p_SetConnexion ( const acom_ADataset : TComponent ; acco_Connexion : TComponent );
procedure p_SetComponentsConnexions ( const acom_Form : TComponent ; acco_Connexion : TComponent );
function  fb_RefreshDatasetIfEmpty ( const adat_Dataset : TDataset ) : Boolean ;
procedure p_ExecuteSQLQuery ( const adat_Dataset : Tdataset ; const as_Query :{$IFDEF DELPHI_9_UP} String {$ELSE} WideString{$ENDIF} ; const ab_ShowException : boolean = True );
function fdat_CloneDatasetWithoutSQL ( const adat_ADataset : TDataset ; const AOwner : TComponent ) : TDataset;
function fdat_CloneDatasetWithoutSQLWithDataSource ( const adat_ADataset : Tdataset ; const AOwner : TComponent ; var ads_Datasource : TDatasource  ) : Tdataset;
function fds_GetOrCloneDataSource ( const acom_Component : TComponent ; const as_SourceProperty, as_Query : String ; const AOwner : TComponent ; const adat_ADatasetToCopy : Tdataset ) : Tdatasource;
function fb_GetSQLStrings (const adat_ADataset : Tdataset ; var astl_SQLQuery : TStrings{$IFDEF DELPHI_9_UP}; var awst_SQLQuery : TWideStrings {$ENDIF}):Boolean;
function fcom_CloneObject ( const acom_AObject : TComponent ; const AOwner : TComponent ) : TComponent;
function fcom_CloneConnexion ( const acco_AObject : TComponent ; const AOwner : TComponent ) : TComponent;
function fb_GetParamsDataset (const adat_ADataset : Tdataset ;var aprs_ParamSource: TParams ; var Astl_Params : TStringList {$IFDEF EADO} ; var aprs_ParamterSource: TParameters {$ENDIF}): Boolean;
function fb_SetParamQuery(const adat_Dataset : TDataset ; const as_Param: String): Boolean;
function fb_LocateSansFiltre ( const aado_Seeker : TDataset ; const as_Fields : String ; const avar_Records : Variant ; const ach_Separator : Char ): Boolean ;
procedure p_LocateInit ( const aado_Seeker : TDataset ; const as_Table, as_Condition : String );
function fb_AssignSort ( const adat_Dataset : TDataset ; const as_ChampsOrdonner : String ):Boolean; overload;
function fb_AssignSort ( const adat_Dataset : TDataset ; const astl_list : TStrings ; const ai_ChampsOrdonner : Integer ):Boolean; overload;
function fb_DatasetFilterLikeRecord ( const as_DatasetValue, as_FilterValue : String ; const ab_CaseInsensitive : Boolean ): Boolean ;
procedure p_setParamDataset (const adat_ADataset : Tdataset ; const as_ParamName : String ; const avar_Value : Variant );
function fb_InsereCompteurAlpha  ( const adat_Dataset, adat_DatasetQuery : TDataset ;
                                   const aslt_Cle : TStringlist ;
                                   const as_ChampCompteur, as_Table, as_PremierLettrage : String ;
                                   const ach_DebutLettrage, ach_FinLettrage : Char ;
                                   const ab_DBMessageOnError  : Boolean ): Boolean;
function fb_InsereCompteurNumerique  ( const adat_Dataset, adat_DatasetQuery : TDataset ;
                                       const aslt_Cle : TStringlist ;
                                       const as_ChampCompteur, as_Table : String ;
                                       const ali_Debut, ali_LimiteRecherche     : Int64 ;
                                       const ab_DBMessageOnError  : Boolean ): Boolean;

function fb_FieldRecordExists  ( const adat_Dataset, adat_DatasetQuery : TDataset ;
                               const as_Table, as_FieldName : String;
                               const ab_DBMessageOnError  : Boolean ): Boolean;
function fb_RecordExists ( const adat_DatasetQuery : TDataset ;
                           const as_Table, as_Where : String;
                           const ab_DBMessageOnError  : Boolean ): Boolean;

var ge_DataSetErrorEvent : TDataSetErrorEvent ;

implementation

uses Variants,  fonctions_erreurs, fonctions_string,
  {$IFDEF FPC}
  unite_messages,
  {$ELSE}
  unite_messages_delphi,
  {$ENDIF}
{$IFDEF FPC}
     SQLDB,
{$ELSE}
     DBTables,
{$ENDIF}
{$IFDEF EDBEXPRESS}
     SQLExpr,
 {$ENDIF}
   fonctions_proprietes, TypInfo,
   Dialogs,
   fonctions_init;



procedure p_ShowSQLError ( const AException, ASQL : String );
Begin
  Showmessage ( AException + ':' +#13#10+ ASQL );
End;

//////////////////////////////////////////////////////////////////////
// Fonction retournant le composant copié sans la personnalisation
//  acom_AObject : Le composant à cloner
//  AOwner       : Le futur propriétaire du composant
// Résultat de la fonction : Le composant cloné sans la personnalisation
//////////////////////////////////////////////////////////////////////
function fcom_CloneObject ( const acom_AObject : TComponent ; const AOwner : TComponent ) : TComponent;
Begin
  Result := TComponent ( acom_AObject.ClassType.NewInstance );

  Result.Create ( AOwner );
End;

function fb_GetSQLStrings (const adat_ADataset : Tdataset ; var astl_SQLQuery : TStrings{$IFDEF DELPHI_9_UP}; var awst_SQLQuery : TWideStrings {$ENDIF}):Boolean;
Begin
  Result := fb_GetStrings(adat_ADataset,CST_DBPROPERTY_SQL,astl_SQLQuery{$IFDEF DELPHI_9_UP}, awst_SQLQuery {$ENDIF});
end;

procedure p_ExecuteSQLQuery ( const adat_Dataset : Tdataset ; const as_Query :{$IFDEF DELPHI_9_UP} String {$ELSE} WideString{$ENDIF} ; const ab_ShowException : boolean = True );
Begin
  p_SetSQLQuery ( adat_Dataset, as_Query );
  try
    if assigned ( ge_OnExecuteQuery ) Then
     ge_OnExecuteQuery ( adat_Dataset );
  Except
    on E:Exception do
     p_ShowSQLError(E.Message,as_Query);
  end;
End ;



//////////////////////////////////////////////////////////////////////
// Fonction retournant la connexion copiée avec le lien SGBD
//  acco_AObject : La connexion à cloner
//  AOwner       : Le futur propriétaire du composant
// Résultat de la fonction : la connexion copiée avec le lien SGBD
//////////////////////////////////////////////////////////////////////
function fcom_CloneConnexion ( const acco_AObject : TComponent ; const AOwner : TComponent ) : TComponent;
Begin
  Result := TComponent(fcom_CloneObject ( acco_AObject, AOwner ));
  // ADO
  if  VarIsStr( fvar_getComponentProperty(acco_AObject,CST_DBPROPERTY_CONNECTIONSTRING)  )  Then
    Begin
      p_SetComponentProperty( Result, CST_DBPROPERTY_CONNECTIONSTRING, fvar_getComponentProperty(acco_AObject,CST_DBPROPERTY_CONNECTIONSTRING));
    End ;
  if  ( fobj_getComponentObjectProperty(acco_AObject,CST_DBPROPERTY_CONNECTION) <> nil )  Then
    Begin
      p_SetComponentObjectProperty( Result, CST_DBPROPERTY_CONNECTION, fobj_getComponentObjectProperty(acco_AObject,CST_DBPROPERTY_CONNECTION));
    End ;

End;

//////////////////////////////////////////////////////////////////////
// Fonction retournant le dataset copié avec le lien SGBD
//  adat_AObject : Le dataset à cloner
//  AOwner       : Le futur propriétaire du composant
// Résultat de la fonction : le dataset copié avec le lien SGBD
//////////////////////////////////////////////////////////////////////
function fdat_CloneDatasetWithoutSQL ( const adat_ADataset : TDataset ; const AOwner : TComponent ) : TDataset;
Begin
  Result := TDataset(fcom_CloneObject ( adat_ADataset, AOwner ));

  p_SetConnexion ( Result, fobj_getComponentObjectProperty(adat_ADataset,CST_DBPROPERTY_CONNECTION) as TComponent);
  // ADO
  if  assigned ( GetPropInfo ( adat_ADataset, CST_DBPROPERTY_CONNECTIONSTRING ))  Then
    Begin
      p_SetComponentProperty( Result, CST_DBPROPERTY_CONNECTIONSTRING, fvar_getComponentProperty(adat_ADataset,CST_DBPROPERTY_CONNECTIONSTRING));
    End ;

  // LAZARUS
  if  assigned ( GetPropInfo ( adat_ADataset,CST_DBPROPERTY_SQLCONNECTION))  Then
    Begin
      p_SetComponentObjectProperty( Result, CST_DBPROPERTY_SQLCONNECTION, fobj_getComponentObjectProperty(adat_ADataset,CST_DBPROPERTY_SQLCONNECTION));
    End ;
  // DB NET PROCESSOR
  if  assigned ( GetPropInfo ( adat_ADataset,CST_DBPROPERTY_ONLINECONN))  Then
    Begin
      p_SetComponentObjectProperty( Result, CST_DBPROPERTY_ONLINECONN, fobj_getComponentObjectProperty(adat_ADataset,CST_DBPROPERTY_ONLINECONN));
    End ;
  // IBX
  if assigned ( GetPropInfo ( adat_ADataset,CST_DBPROPERTY_TRANSACTION))  Then
    Begin
      p_SetComponentObjectProperty( Result, CST_DBPROPERTY_TRANSACTION, fobj_getComponentObjectProperty(adat_ADataset,CST_DBPROPERTY_TRANSACTION));
    End ;

  // DBEXPRESS IBX
  if  assigned ( GetPropInfo ( adat_ADataset,CST_DBPROPERTY_DATABASE))  Then
    Begin
      p_SetComponentObjectProperty( Result, CST_DBPROPERTY_DATABASE, fobj_getComponentObjectProperty(adat_ADataset,CST_DBPROPERTY_DATABASE));
    End ;
  // bDE
  if assigned ( GetPropInfo ( adat_ADataset,CST_DBPROPERTY_DATABASENAME))  Then
    Begin
      p_SetComponentProperty( Result, CST_DBPROPERTY_DATABASENAME, fvar_getComponentProperty(adat_ADataset,CST_DBPROPERTY_DATABASENAME));
    End ;
  if assigned ( GetPropInfo ( adat_ADataset,CST_DBPROPERTY_SESSIONNAME))  Then
    Begin
      p_SetComponentProperty( Result, CST_DBPROPERTY_SESSIONNAME, fvar_getComponentProperty(adat_ADataset,CST_DBPROPERTY_SESSIONNAME));
    End ;
  p_SetComponentBoolProperty( Result, 'ReadOnly', False );
  p_SetComponentBoolProperty( Result, 'AutoCalcFields', True );

End ;

function fds_GetOrCloneDataSource ( const acom_Component : TComponent ; const as_SourceProperty, as_Query : String ; const AOwner : TComponent ; const adat_ADatasetToCopy : Tdataset ) : Tdatasource;
var lobj_source : TObject;
Begin
  Result := nil;
  // Propriété ListSource
  if   assigned ( GetPropInfo ( acom_Component, as_SourceProperty ))
  and  PropIsType      ( acom_Component, as_SourceProperty , tkClass) Then
    Begin
      lobj_source := GetObjectProp   ( acom_Component, as_SourceProperty );
      if not assigned ( lobj_source ) Then
        Begin
          fdat_CloneDatasetWithoutSQLWithDataSource ( adat_ADatasetToCopy, AOwner, Result );
          SetObjectProp( acom_Component, as_SourceProperty, Result );
          p_SetSQLQuery( Result.DataSet, as_Query );
        End
       Else
         Result := lobj_source as TDatasource ;
    End;
End;

function fdat_CloneDatasetWithoutSQLWithDataSource ( const adat_ADataset : TDataset ; const AOwner : TComponent ; var ads_Datasource : TDatasource  ) : TDataset;
Begin
  Result := TDataset( fdat_CloneDatasetWithoutSQL ( adat_ADataset, AOwner ));
  if not assigned ( ads_Datasource ) Then
    ads_Datasource := TDatasource.create ( AOwner );
  ads_Datasource.DataSet := Result;
End;

/////////////////////////////////////////////////////////////////////////
// fonction fb_GetParamsDataset
// Retourne les paramètre d'un query
// adat_ADataset : le query
// Retours : aprs_ParamSource aprs_ParamterSource les paramètres éventuellement ADO
/////////////////////////////////////////////////////////////////////////

function fb_GetParamsDataset (const adat_ADataset : Tdataset ;var aprs_ParamSource: TParams ; var Astl_Params : TStringList {$IFDEF EADO} ; var aprs_ParamterSource: TParameters {$ENDIF}): Boolean;
var lobj_SQL : TObject ;
begin
  Result := false;
  aprs_ParamSource := nil;
{$IFDEF EADO}
  aprs_ParamterSource := nil;
{$ENDIF}
  lobj_SQL := fobj_getComponentObjectProperty (adat_ADataset, 'Params' );
  if ( lobj_SQL is TParams ) Then
    Begin
      aprs_ParamSource:= lobj_SQL as TParams ;
      Result := True
    end
  else
   if  assigned ( GetPropInfo ( adat_ADataset, CST_DBPROPERTY_CLIENTPARAM )) Then
     Begin
       p_ChampsVersListe( Astl_Params, fs_getComponentProperty(adat_ADataset, CST_DBPROPERTY_CLIENTPARAM),CST_DBPROPERTY_ENDPARAM );
     End
  {$IFDEF EADO}
    else
      Begin
         lobj_SQL := fobj_getComponentObjectProperty ( adat_ADataset, 'Parameters' );
         if ( lobj_SQL is TParameters ) Then
           Begin
             aprs_ParamterSource := lobj_SQL as TParameters ;
             Result := True
           End;
      End
  {$ENDIF};
end;

/////////////////////////////////////////////////////////////////////////
// procedure p_setParamDataset
// Retourne les paramètre d'un query
// adat_ADataset : le query
// as_ParamName  : Le paramètre
// avar_Value    : sa valeur à affecter
/////////////////////////////////////////////////////////////////////////

procedure p_setParamDataset (const adat_ADataset : Tdataset ; const as_ParamName : String ; const avar_Value : Variant );
var lobj_Params1 :  TParams ;
    lprm_Param   :  TParam ;
    lstl_params : TStringList;
    li_i : Integer;
{$IFDEF EADO}
    lobj_Params2   :  TParameters ;
    lprm_Parameter :  TParameter ;
{$ENDIF}
begin
  lobj_Params1 := nil;
  lprm_Param   := nil;
  {$IFDEF EADO}
  lobj_Params2   := nil;
  lprm_Parameter := nil;
  {$ENDIF}
  if fb_GetParamsDataset ( adat_ADataset, lobj_Params1, lstl_params{$IFDEF EADO}, lobj_Params2{$ENDIF} ) Then
    Begin
      if assigned ( lobj_Params1 ) then
        Begin
          lprm_Param := lobj_Params1.FindParam(as_ParamName);
          if not assigned ( lprm_Param ) then
            Begin
              lprm_Param := lobj_Params1.Add as TParam;
              lprm_Param.Name := as_ParamName;
            End;
          with lprm_Param do
            Begin
              ParamType := ptInput;
              Value := avar_Value ;
            End;
        End
{$IFDEF EADO}
      else if assigned ( lobj_Params2 ) then
        Begin
          lprm_Parameter := lobj_Params2.FindParam(as_ParamName);
          if not assigned ( lprm_Parameter ) then
            Begin
              lprm_Parameter := lobj_Params2.AddParameter ;
              lprm_Parameter.Name := as_ParamName;
            End;
          with lprm_Parameter do
            Begin
              Direction := pdInput;
              Value := avar_Value ;
            End;
        End
{$ENDIF}else
         Begin
           if lstl_params.Find(as_ParamName+'=',li_i) Then
             Begin
               lstl_params [ li_i ] := VarToStr(avar_Value);
             end
            else
             lstl_params.Add ( as_ParamName+'='+VarToStr(avar_Value) );
          p_SetComponentProperty(adat_ADataset,CST_DBPROPERTY_CLIENTPARAM,fs_ListeVersChamps(lstl_params,CST_DBPROPERTY_ENDPARAM));
         end;
    End;
end;



procedure p_OpenSQLQuery ( const adat_Dataset : Tdataset ; const as_Query : {$IFDEF DELPHI_9_UP} String {$ELSE} WideString{$ENDIF} );
Begin
  if assigned ( adat_Dataset ) Then
    Begin
      p_SetSQLQuery ( adat_Dataset, as_Query );
      adat_Dataset.Open;
    End ;
End ;

//////////////////////////////////////////////////////////////////////////////////////////////
// procedure p_SetConnexion
// Affecte la connexion d'un dataset
// acom_Form : le dataset
// acco_Connexion : La connexion à affecter au dataset
//////////////////////////////////////////////////////////////////////////////////////////////
procedure p_SetConnexion ( const acom_ADataset : TComponent ; acco_Connexion : TCOmponent );
Begin
  if ( acom_ADataset is Tdataset ) then
    p_SetComponentObjectProperty( acom_ADataset , CST_DBPROPERTY_CONNECTION, acco_Connexion );
{$IFDEF EADO}
  if gb_IniADOsetKeySet
  and ( acom_ADataset is TCustomADOdataset )
  and (( acom_ADataset as TCustomADOdataset ).LockType <> ltReadOnly )
   then
     Begin
//      ( acom_ADataset as TCustomADOdataset ).CursorLocation := clUseServer;
      ( acom_ADataset as TCustomADOdataset ).CursorType := ctKeyset;
     End;
{$ENDIF}
End;

//////////////////////////////////////////////////////////////////////////////////////////////
// procedure p_SetComponentsConnexions
// Affecte la connexion d'un module de données ou d'une fiche
// acom_Form : le datamodule ou la tform
// acco_Connexion : La connexion à affecter aux datasets
//////////////////////////////////////////////////////////////////////////////////////////////
procedure p_SetComponentsConnexions ( const acom_Form : TComponent ; acco_Connexion : TComponent );
var li_i : Integer ;
Begin
  for li_i := 0 to acom_Form.ComponentCount - 1 do
    p_SetConnexion( acom_Form.Components [ li_i ], acco_Connexion );
End;

///////////////////////////////////////////////////////////////////////////////
// procedure p_SetSQLQuery
// affecte la requête d'un query
// adat_Dataset : le query
// as_Query : la chaine à affecter au query
///////////////////////////////////////////////////////////////////////////////

procedure p_SetSQLQuery ( const adat_Dataset : Tdataset ; const as_Query : {$IFDEF DELPHI_9_UP} String {$ELSE} WideString{$ENDIF});
var lobj_SQL : TObject ;
    lprm_Params : TParams ;
    lstl_Params : TStringList;
    {$IFDEF EADO}
    lprm_Parameters : TParameters ;
    {$ENDIF}
Begin
 lobj_SQL := fobj_getComponentObjectProperty ( adat_Dataset, CST_DBPROPERTY_SQL );
 if assigned ( lobj_SQL ) Then
   Begin
     lstl_Params := nil;
     fb_GetParamsDataset ( adat_Dataset, lprm_Params, lstl_Params{$IFDEF EADO}, lprm_Parameters {$ENDIF});
     if assigned ( lprm_Params ) then
       lprm_Params.Clear
     {$IFDEF EADO}
     else if assigned ( lprm_Parameters ) then
       lprm_Parameters.Clear
     {$ENDIF}
      else p_SetComponentProperty(adat_Dataset,CST_DBPROPERTY_CLIENTPARAM, '');
     if ( lobj_SQL is TStrings ) Then
      with lobj_SQL as TStrings do
       Begin
         BeginUpdate ;
         Text := as_query ;
         EndUpdate ;
       End
{$IFDEF DELPHI_9_UP}
      else if ( lobj_SQL is TWideStrings ) Then
       with lobj_SQL as TWideStrings do
        Begin
          Beginupdate;
          Text := as_query ;
          EndUpdate;
        End;
{$ENDIF}
   ;
   End;
End ;

///////////////////////////////////////////////////////////////////////////////
// fonction fs_getSQLQuery
// retourne la requête d'un query
// adat_Dataset : le query
// result : la chaine de la requête
///////////////////////////////////////////////////////////////////////////////

function fs_getSQLQuery ( const adat_Dataset : Tdataset ): String;
var lobj_SQL : TObject ;
Begin
 lobj_SQL := fobj_getComponentObjectProperty ( adat_Dataset, CST_DBPROPERTY_SQL );
 if assigned ( lobj_SQL ) Then
   Begin
     if ( lobj_SQL is TStrings ) Then
      with lobj_SQL as TStrings do
       Begin
         BeginUpdate ;
         Result := Text ;
         EndUpdate ;
       End
{$IFDEF DELPHI_9_UP}
      else if ( lobj_SQL is TWideStrings ) Then
       with lobj_SQL as TWideStrings do
        Begin
          Beginupdate;
          Result := Text ;
          EndUpdate;
        End;
{$ENDIF}
   ;
   End;
End ;

function fb_DatasetFilterLikeRecord ( const as_DatasetValue, as_FilterValue : String ; const ab_CaseInsensitive : Boolean ): Boolean ;
Begin
  Result := False ;
  if  length ( as_DatasetValue ) >= length ( as_FilterValue ) Then
    if ab_CaseInsensitive Then
      Begin
        if lowerCase ( copy ( as_DatasetValue, 1, length ( as_FilterValue ))) = lowerCase ( as_FilterValue ) Then
          Result := True ;
      End
    Else
      Begin
        if ( copy ( as_DatasetValue, 1, length ( as_FilterValue )) = as_FilterValue ) Then
          Result := True ;
      End
End ;



function fb_RefreshDataset ( const aDat_Dataset : TDataset ): Boolean ;
Begin
  Result := fb_RefreshDataset ( aDat_Dataset, True );
End;

function fb_RefreshDataset ( const aDat_Dataset : TDataset; const ab_GardePosition : Boolean ): Boolean ;
var lbkm_Bookmark : TBookmarkStr ;
    lvar_Sort : Variant;
    ls_Sort : String ;
Begin
  Result := False ;
  if ab_GardePosition Then
    lbkm_Bookmark := aDat_Dataset.Bookmark ;
  try
    lvar_Sort := fvar_getComponentProperty( aDat_Dataset, 'Sort' );
    if VarIsStr ( lvar_Sort ) then
      ls_Sort := lvar_Sort;
    if not assigned ( ge_OnRefreshDataset )
    or not ge_OnRefreshDataset ( aDat_Dataset ) Then
        Begin
          aDat_Dataset.Close ;
          aDat_Dataset.Open ;
        End ;
    if ab_GardePosition Then
      aDat_Dataset.Bookmark := lbkm_Bookmark ;
    if ( ls_Sort <> '' )
      Then p_SetComponentProperty ( aDat_Dataset, 'Sort', ls_Sort );
    Result := True ;
  except
  End ;
End ;

procedure p_AutoConnection ( const adat_Dataset : TDataset; const AConnect : Boolean = True );
var lobj_Connect : TObject;
Begin
  if assigned ( adat_Dataset ) Then
    Begin
      lobj_Connect := fobj_getComponentObjectProperty(adat_Dataset, CST_DBPROPERTY_CONNECTION );
      if lobj_Connect is TComponent then
        p_SetComponentBoolProperty(lobj_Connect as TComponent,'Active', aconnect);
    End;
End;

///////////////////////////////////////////////////////////////////////////////
// procedure p_AddSQLQuery
// Ajoute une chaine sanns retour chariot à un query
// adat_Dataset : le query
// as_Query : la chaine à ajouter
///////////////////////////////////////////////////////////////////////////////
procedure p_AddSQLQuery ( const adat_Dataset : Tdataset ; const as_Query : {$IFDEF DELPHI_9_UP} String {$ELSE} WideString{$ENDIF} );
var lobj_SQL : TObject ;
Begin
 lobj_SQL := fobj_getComponentObjectProperty ( adat_Dataset, CST_DBPROPERTY_SQL );
 if assigned ( lobj_SQL ) Then
   Begin
     if ( lobj_SQL is TStrings ) Then
       ( lobj_SQL as TStrings ).Add ( as_query )
{$IFDEF DELPHI_9_UP}
      else if ( lobj_SQL is TWideStrings ) Then
       ( lobj_SQL as TWideStrings ).Add ( as_query )
{$ENDIF}
   ;
   End;
End ;

///////////////////////////////////////////////////////////////////////////////
// Créé un paramètre dans le query après l'avoir vérifié
// avar_EnregistrementCle : un variant à mettre dans la form propriétaire
//                          et à ne toucher qu'avec cette fonction
// adat_Dataset           : Le dataset de la clé
// as_Cle                 : LA clé
////////////////////////////////////////////////////////////////////////////////
function fb_SetParamQuery(const adat_Dataset : TDataset ;
  const as_Param: String): Boolean;
var lobj_SQL : TObject ;
Begin
  Result := False;
  lobj_SQL := fobj_getComponentObjectProperty ( adat_Dataset, 'Params' );
  if ( lobj_SQL is TParams ) Then
    Begin
      with lobj_SQL as TParams do
        if FindParam(as_Param)= nil then
          with Add as TParam do
            Begin
              Name := as_Param;
              Result := True;
            End;
    End;
{$IFDEF EADO}
  if not assigned ( lobj_SQL )
    Then
      lobj_SQL := fobj_getComponentObjectProperty ( adat_Dataset, 'Parameters' );
  if ( lobj_SQL is TParameters ) Then
    with lobj_SQL as TParameters do
        if FindParam(as_Param)= nil then
          with Add as TParameter do
            Begin
              Name := as_Param;
              Result := True;
            End;
{$ENDIF}
end;

////////////////////////////////////////////////////////////////////////////////
// Procédure : fb_RefreshDatasetIfEmpty
// Description : Rafraichit le dataset filtré quand il est vide
////////////////////////////////////////////////////////////////////////////////
function fb_RefreshDatasetIfEmpty ( const adat_Dataset : TDataset ) : Boolean ;
begin
  Result := False ;
  // Rafraichissement la première fois qu'on ne retrouve pas ce qu'on cherche
  if adat_Dataset.IsEmpty Then
    try
      Result := True ;
{$IFDEF EADO}
      if ( adat_Dataset is TCustomADODataset ) Then
        ( adat_Dataset as TCustomADODataset ).Requery
      Else
{$ENDIF}
        Begin
          adat_Dataset.Close ;
          adat_Dataset.Open ;
        End ;
    Except
      on e: Exception do
        f_GereException ( e, adat_Dataset );
    End ;
End ;

function fb_LocateSansFiltre ( const aado_Seeker : TDataset ; const as_Fields : String ; const avar_Records : Variant ; const ach_Separator : Char ): Boolean ;
var ls_Filter : String ;
Begin
  Result := False ;
  if pos ( as_Fields, ach_Separator +'' ) <= 0 Then
    Begin
      aado_Seeker.Close ;
      ls_Filter :=  fs_getSQLQuery ( aado_Seeker );
      if ( pos ( 'where', lowercase (ls_filter))> 0 ) Then
        ls_Filter := ls_Filter + ' AND '
       else
        ls_Filter := ls_Filter + ' WHERE ' ;
      ls_Filter := ls_Filter + as_Fields + '=' ;
      if ( aado_Seeker.FieldByName ( as_Fields ).DataType in CST_DELPHI_FIELD_STRING )
        Then
          ls_Filter := ls_Filter + '''' + fs_stringDbQuote ( avar_Records ) + ''''
        Else
          ls_Filter := ls_Filter + fs_stringDbQuote ( VarToStr ( avar_Records )) ;
      p_SetSQLQuery ( aado_Seeker, ls_Filter  );
      aado_Seeker.Open ;
      Result := aado_Seeker.RecordCount > 0 ;
    End ;
End ;

procedure p_LocateInit ( const aado_Seeker : TDataset ; const as_Table, as_Condition : String );
var ls_Filter : String ;
Begin
  ls_Filter := 'SELECT * FROM ' + as_Table ;
  if as_Condition <> '' Then
    ls_Filter := ' WHERE ' + as_Condition ;
  p_SetSQLQuery ( aado_Seeker, ls_Filter  );
  aado_Seeker.Open ;
End ;



/////////////////////////////////////////////////////////////////////////////////
// Fonction : fb_InsereCompteur
// Description : Compteur sur un champ numérique ou chaîne
// Paramètres : adat_Dataset : Le dataset du compteur
//              aslt_Cle     : La clé du dataset
//              as_ChampCompteur : Le champ compteur dans la clé
//              as_Table         : La table du compteur
//              as_PremierLettrage : Le premier lettrage en entier
//              ach_DebutLettrage  : Le caractère du premier lettrage
//              ach_FinLettrage    : Le caractère du dernier lettrage
//              ali_Debut        : Le compteur
//              ali_LimiteRecherche : Le maximum du champ compteur
/////////////////////////////////////////////////////////////////////////////////
function fb_InsereCompteur ( const adat_Dataset, adat_DatasetQuery : TDataset ;
                             const aslt_Cle : TStringlist ;
                             const as_ChampCompteur, as_Table, as_PremierLettrage : String ;
                             const ach_DebutLettrage, ach_FinLettrage : Char ;
                             const ali_Debut, ali_LimiteRecherche     : Int64 ;
                             const ab_DBMessageOnError  : Boolean ): Boolean;
Begin
  Result := False ;
  if ( adat_Dataset.State in [dsInsert,dsEdit] ) or ( adat_Dataset.FieldByName ( as_ChampCompteur ).AsCurrency < ali_Debut )  then
    begin
      if  ( adat_Dataset.FieldByName ( as_ChampCompteur ) is TNumericField )
       Then
         fb_InsereCompteurNumerique ( adat_Dataset, adat_DatasetQuery,
                                      aslt_Cle,
                                      as_ChampCompteur, as_Table,
                                      ali_Debut, ali_LimiteRecherche,
                                      ab_DBMessageOnError )
      Else
        fb_InsereCompteurAlpha     ( adat_Dataset, adat_DatasetQuery,
                                     aslt_Cle,
                                     as_ChampCompteur, as_Table, as_PremierLettrage,
                                     ach_DebutLettrage, ach_FinLettrage,
                                     ab_DBMessageOnError );
    end;
End ;


/////////////////////////////////////////////////////////////////////////////////
// Fonction : fb_InsereCompteur
// Description : Compteur sur un champ numérique ou chaîne
// Paramètres : adat_Dataset : Le dataset du compteur
//              aslt_Cle     : La clé du dataset
//              as_ChampCompteur : Le champ compteur dans la clé
//              as_Table         : La table du compteur
//              ach_FinLettrage    : Le caractère du dernier lettrage
//              ali_Debut        : Le compteur
//              ali_LimiteRecherche : Le maximum du champ compteur
/////////////////////////////////////////////////////////////////////////////////
function fb_InsereCompteurNumerique  ( const adat_Dataset, adat_DatasetQuery : TDataset ;
                                       const aslt_Cle : TStringlist ;
                                       const as_ChampCompteur, as_Table : String ;
                                       const ali_Debut, ali_LimiteRecherche     : Int64 ;
                                       const ab_DBMessageOnError  : Boolean ): Boolean;
var li64_Compteur     : Int64 ;
    lvar_Cle          : Variant;
    ls_SQL, ls_SQL2 : WideString ;
begin
  Result := False;

  adat_DatasetQuery.Close;
  lvar_Cle:=fvar_getKeyRecord(adat_Dataset,aslt_Cle);
  // sélectionner le compteur maximum
  ls_SQL := 'SELECT MAX(' + as_ChampCompteur + ') FROM ' + as_Table ;
  ls_SQL2 := fs_AjouteRechercheClePrimaire ( adat_Dataset, aslt_Cle, lvar_Cle, as_ChampCompteur );
  if ls_SQL2 <> '' Then
    ls_SQL := ls_SQL + ls_SQL2 + ' AND '   + as_ChampCompteur + '<=' + IntToStr ( ali_LimiteRecherche )
  Else
    ls_SQL := ls_SQL + ' WHERE ' + as_ChampCompteur + '<=' + IntToStr ( ali_LimiteRecherche );
  try
     p_OpenSQLQuery ( adat_DatasetQuery, ls_SQL );
  finally
  End;
  try
    // Incrémenter le compteur si c'est possible
    if ( ali_LimiteRecherche = ali_Debut ) // annuler les limites si elles sont égales
    or ( adat_DatasetQuery.Fields[0].Value < ali_LimiteRecherche ) Then // Limite supérieure uniquement à cause du MAX
      Begin
        if adat_DatasetQuery.Fields[0].Value >= ali_Debut then
          adat_Dataset.FieldByName ( as_ChampCompteur ).Value :=
            adat_DatasetQuery.Fields[0].Value + 1
        else
          adat_Dataset.FieldByName ( as_ChampCompteur ).Value := ali_Debut;
      End
    Else
    // Sinon scrute le dataset à la recherche d'un compteur
      Begin
        adat_DatasetQuery.Close;
        ls_SQL := 'SELECT ' + as_ChampCompteur + ' FROM ' + as_Table ;
        ls_SQL := ls_SQL + fs_AjouteRechercheClePrimaire ( adat_Dataset, aslt_Cle, lvar_Cle, as_ChampCompteur );
        ls_SQL := ls_SQL + ' ORDER BY ' + as_ChampCompteur ;
        p_OpenSQLQuery ( adat_DatasetQuery, ls_SQL );
        li64_Compteur := ali_Debut ;
        if not adat_DatasetQuery.IsEmpty Then
          with adat_DatasetQuery do
            if Fields [ 0 ].Value <= li64_Compteur Then
              while not eof do
                Begin
                  li64_Compteur := Fields [ 0 ].Value ;
                  Next ;
                  if  not eof  Then
                    Begin
                      if ( adat_DatasetQuery.Fields [ 0 ].Value > li64_Compteur + 1 ) Then
                        Begin
                          adat_Dataset.FieldByName ( as_ChampCompteur ).Value := li64_Compteur + 1 ;
                          Break ;
                        End ;
                    End
                  Else
                    adat_Dataset.FieldByName ( as_ChampCompteur ).Value := li64_Compteur + 1 ;
                End
            Else
              adat_Dataset.FieldByName ( as_ChampCompteur ).Value := li64_Compteur ;

      End ;

    Result := True ;

    adat_DatasetQuery.Close;
  Except
    On E:Exception do
      f_GereExceptionEvent ( E, adat_DatasetQuery, nil, not ab_DBMessageOnError );
  End ;
end;

/////////////////////////////////////////////////////////////////////////////////
// Fonction : fb_InsereCompteur
// Description : Compteur sur un champ numérique ou chaîne
// Paramètres : adat_Dataset : Le dataset du compteur
//              aslt_Cle     : La clé du dataset
//              as_ChampCompteur : Le champ compteur dans la clé
//              as_Table         : La table du compteur
//              as_PremierLettrage : Le premier lettrage en entier
//              ali_Debut        : Le compteur
//              ali_LimiteRecherche : Le maximum du champ compteur
/////////////////////////////////////////////////////////////////////////////////
function fb_InsereCompteurAlpha  ( const adat_Dataset, adat_DatasetQuery : TDataset ;
                                   const aslt_Cle : TStringlist ;
                                   const as_ChampCompteur, as_Table, as_PremierLettrage : String ;
                                   const ach_DebutLettrage, ach_FinLettrage : Char ;
                                   const ab_DBMessageOnError  : Boolean ): Boolean;
var li64_Terminus     ,
    li64_Compteur     ,
    li64_Compteur2    : Int64 ;
    lch_Lettrage      ,
    lch_Lettrage2     : Char ;
    ls_ChampLettrage : String;
    ls_SQL  : WideString ;
begin
  adat_DatasetQuery.Close;
  // sélectionner le compteur maximum
  ls_SQL := 'select ' + as_ChampCompteur + ' from ' + as_Table ;
  ls_SQL := ls_SQL + fs_AjouteRechercheClePrimaire ( adat_Dataset, aslt_Cle, Null, as_ChampCompteur );
  ls_SQL := ls_SQL + ' order by ' + as_ChampCompteur + ' desc' ;
  try
    p_OpenSQLQuery ( adat_DatasetQuery, ls_SQL );
    if adat_DatasetQuery.IsEmpty Then
      Begin
        // Aucun enregistrement donc premier lettrage
        adat_Dataset.FieldByName ( as_ChampCompteur ).Value := as_PremierLettrage;
      End
    Else
      Begin
        // Incrémenter le compteur si c'est possible
        ls_ChampLettrage := adat_DatasetQuery.Fields[0].AsString ;
        lch_Lettrage  := ls_ChampLettrage [ 1 ];
        try
          li64_Compteur := StrToInt64 ( copy ( ls_ChampLettrage, 2, length ( ls_ChampLettrage ) - 1 ));
        Except
          li64_Compteur := 0 ;
        End ;
        li64_Terminus := StrToInt64 ( fs_RepeteChar ( '9', length ( ls_ChampLettrage ) - 1 ));
        if  ( ord ( lch_Lettrage )  < ord ( ach_FinLettrage ) )
        or  ( li64_Compteur <  li64_Terminus ) Then
          Begin
            if ( li64_Compteur < li64_Terminus ) Then
              adat_Dataset.FieldByName ( as_ChampCompteur ).Value := fs_Lettrage ( lch_Lettrage, li64_Compteur + 1, length (  ls_ChampLettrage ))
            Else
              adat_Dataset.FieldByName ( as_ChampCompteur ).Value := fs_Lettrage ( chr ( ord ( lch_Lettrage ) + 1 ), 0, length (  ls_ChampLettrage ) );
          End
        Else
        // Sinon scrute le dataset à la recherche d'un compteur
          with adat_DatasetQuery do
            while not adat_DatasetQuery.Eof do
              Begin
                Next ;
                lch_Lettrage2  := adat_DatasetQuery.Fields[0].AsString [ 1 ] ;
                try
                  li64_Compteur2 := StrToInt64 ( Trim ( copy ( adat_DatasetQuery.Fields[0].AsString, 2, length ( adat_DatasetQuery.Fields[0].AsString ) - 1 )));
                Except
                  li64_Compteur2 := 0 ;
                End ;
                  if  ( li64_Compteur2 < li64_Compteur - 1 ) Then
                    Begin
                      adat_Dataset.FieldByName ( as_ChampCompteur ).Value := fs_Lettrage ( lch_Lettrage2, li64_Compteur2 + 1, length (  ls_ChampLettrage ));
                      Break ;
                    End
                  Else
                    if ord ( lch_Lettrage2 ) < ord ( lch_Lettrage ) Then
                      Begin
//                                  if ( ord ( lch_Lettrage2 ) < ord ( lch_Lettrage ) - 1 ) Then
                        if ( li64_Compteur2 < li64_Terminus ) Then
                          Begin
                            adat_Dataset.FieldByName ( as_ChampCompteur ).Value := fs_Lettrage ( lch_Lettrage2, li64_Compteur2 + 1, length (  ls_ChampLettrage ));
                            Break ;
                          End
                        Else
                          if ( ord ( lch_Lettrage2 ) < ord ( lch_Lettrage ) - 1 ) Then
                            Begin
                              adat_Dataset.FieldByName ( as_ChampCompteur ).Value := fs_Lettrage ( chr ( ord ( lch_Lettrage2 ) + 1 ), 0, length (  ls_ChampLettrage ));
                              Break ;
                            End ;
                      End ;
              lch_Lettrage  := lch_Lettrage2 ;
              li64_Compteur := li64_Compteur2 ;

            End ;
        if adat_Dataset.FieldByName ( as_ChampCompteur ).IsNull Then
          Begin
            if ( li64_Compteur > 0 )
            or ( ord ( lch_Lettrage ) > ord ( ach_DebutLettrage )) Then
              adat_Dataset.FieldByName ( as_ChampCompteur ).Value := fs_Lettrage ( ach_DebutLettrage, 0, length (  ls_ChampLettrage ));
          End ;
      End ;
    Result := True ;

    adat_DatasetQuery.Close;
  Except
    On E:Exception do
      f_GereExceptionEvent ( E, adat_DatasetQuery, nil, not ab_DBMessageOnError );
  End ;
end;

// Trier le dataset en cours
// as_ChampsOrdonner : Le sort à affecter
function fb_AssignSort ( const adat_Dataset : TDataset ; const as_ChampsOrdonner : String ):Boolean;
Begin

   if  assigned ( adat_Dataset )
   and          ( adat_Dataset.Active ) Then
     If assigned ( GetPropInfo ( adat_Dataset, 'Sort' ))
      Then
       Begin
         p_SetComponentProperty ( adat_Dataset, 'Sort', as_ChampsOrdonner );
         Result := True;
        End
       Else If assigned ( GetPropInfo ( adat_Dataset, 'SortedFields' ))
        Then
         Begin
           p_SetComponentProperty ( adat_Dataset, 'SortedFields', as_ChampsOrdonner );
           Result := True;
          End
         Else
          Result := False;
//  Showmessage (( gdl_DataLink.DataSet as TCustomADODataset ).Sort );
End ;


function fb_AssignSort ( const adat_Dataset : TDataset ; const astl_list : TStrings ; const ai_ChampsOrdonner : Integer ):Boolean;
Begin
  if  ( ai_ChampsOrdonner >= 0 )
  and ( ai_ChampsOrdonner < astl_list.count )
   Then Result := fonctions_dbcomponents.fb_AssignSort(adat_Dataset, astl_list [ai_ChampsOrdonner])
   Else Result := False;
end;

/////////////////////////////////////////////////////////////////////////////////
// Fonction : fb_KeyRecordExists
// Description :
// Paramètres : adat_Dataset : Le dataset du compteur
//              adat_DatasetQuery : The query dataset
//              as_Table         : La table du compteur
//              as_Where         : The Where clause
/////////////////////////////////////////////////////////////////////////////////
function fb_RecordExists ( const adat_DatasetQuery : TDataset ;
                           const as_Table, as_Where : String;
                           const ab_DBMessageOnError  : Boolean ): Boolean;
var li_Pos     : Integer ;
    ls_SQL : WideString ;
begin
  Result := False;

  adat_DatasetQuery.Close;
  // sélectionner le compteur maximum
  li_pos := pos ( 'where', lowercase ( as_Where ));
  if ( li_pos < 1 )
  or ( li_pos > 2 )
   Then ls_SQL:= ' WHERE ' + as_Where
   else ls_SQL:= ' ' + as_Where;
  ls_SQL := 'SELECT * FROM ' + as_Table + ls_SQL;
  try
    p_OpenSQLQuery ( adat_DatasetQuery, ls_SQL );
    Result := adat_DatasetQuery.RecordCount > 0;
  Except
    On E:Exception do
      f_GereExceptionEvent ( E, adat_DatasetQuery, nil, not ab_DBMessageOnError );
  End ;
end;


/////////////////////////////////////////////////////////////////////////////////
// Fonction : fb_KeyRecordExists
// Description :
// Paramètres : adat_Dataset : Le dataset du compteur
//              adat_DatasetQuery : The query dataset
//              aslt_Cle     : La clé du dataset
//              as_Table         : La table du compteur
//              as_fieldName    : The unique Fieldname
/////////////////////////////////////////////////////////////////////////////////
function fb_FieldRecordExists  ( const adat_Dataset, adat_DatasetQuery : TDataset ;
                               const as_Table, as_FieldName : String;
                               const ab_DBMessageOnError  : Boolean ): Boolean;
var ls_Where : WideString ;
begin
  if adat_Dataset.FindField ( as_FieldName ) is TNumericField
   then ls_Where := as_FieldName + '=' + adat_Dataset.FindField ( as_FieldName ).AsString
   else ls_Where := as_FieldName + '=''' + fs_stringDbQuote ( adat_Dataset.FindField ( as_FieldName ).AsString ) + '''';

  Result := fb_RecordExists ( adat_DatasetQuery, as_Table, ls_Where, ab_DBMessageOnError );
end;

{$IFDEF VERSIONS}
initialization
  p_ConcatVersion ( gVer_fonctions_db_components );
{$ENDIF}
end.

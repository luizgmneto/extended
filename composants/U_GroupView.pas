
{*********************************************************************}
{                                                                     }
{                                                                     }
{             Matthieu Giroux                                         }
{             TDBGroupView :                                          }
{             Composant de groupes                                    }
{              et affectation avec chargements itératifs des données  }
{             22 Décembre 2006                                        }
{                                                                     }
{                                                                     }
{*********************************************************************}

unit U_GroupView;

{$IFDEF FPC}
{$mode Delphi}
{$ELSE}
{$R *.res}
{$ENDIF}

{$I ..\Compilers.inc}
{$I ..\extends.inc}

interface
// Gestion des groupes avec deux de ces composants et des boutons
// Chaque composant de gestion de groupe a sa propriété
// Datasource : Le Datasource à afficher dans la liste avec un paramètre dans le query
// DatasourceOwner : Le DataSource des groupes
// créé par Matthieu Giroux en Mars 2004

// 29-9-2004 : abandon complété dans la gestion panier


uses
{$IFDEF FPC}
  LCLIntf, LCLType, SQLDB, RxLookup, lresources,
{$ELSE}
  Windows, DBTables, JvListView,
{$ENDIF}
    SysUtils, Classes, Graphics, Controls,
     Forms, Dialogs, Db,
     {$IFDEF EADO}
      ADODB,
     {$ENDIF}
     {$IFDEF DBEXPRESS}
     SQLExpr,
     {$ENDIF}
{$IFDEF DELPHI_9_UP}
     WideStrings ,
{$ENDIF}
{$IFDEF VERSIONS}
  fonctions_version,
{$ENDIF}
     SyncObjs, U_DBListView,
     ComCtrls, fonctions_variant;

{$IFDEF VERSIONS}
const
    gVer_TDBGroupView : T_Version = (Component : 'Composant TDBGroupView' ;
                                     FileUnit : 'U_GroupView' ;
                                     Owner : 'Matthieu Giroux' ;
                                     Comment : 'TDBListView avec gestion de groupes et affectation.' ;
                                     BugsStory :  '1.0.1.2 : Creating methods from recording action.' +
                                                  '1.0.1.1 : Ajouts de la gestion DBExpress et BDE.' +
                                                  '1.0.1.0 : Gestion pour tous Datasources testée.' +
                                                  '1.0.0.0 : Gestion de groupe avec gestion de l''ADO non testée.';
                                     UnitType : 3 ;
                                     Major : 1 ; Minor : 0 ; Release : 1 ; Build : 2 );
{$ENDIF}

type

  EBasketAllEvent  = function  ( const Sender: TObject; var   Result : String ; const GetNullRecords, GetCurrentGroup : Boolean ):Boolean of object;
// Première déclaration
  TDBGroupView = class ;


     IFWFormVerify = interface
     ['{693AE27F-98C1-8E6D-E54F-FE57A16057E5}']
     procedure p_DesactiveGrille;
     procedure p_VerifieModifications ;
     end;
  // Gestion de groupe

  { TDBGroupView }

  TDBGroupView = class(TDBListView)
   private
     gb_CaseInSensitive: Boolean;
{$IFDEF DELPHI_9_UP}
    gwst_SQLCommand,
    gwst_SQLSource,
    gwst_SQLQuery : TWideStrings ;
{$ENDIF}
    {$IFNDEF FPC}
    ge_OnselectItem : TLVSelectItemEvent;
    ResInstance : THandle;
    {$ENDIF}
    gsts_SQLCommand,
    gsts_SQLSource,
    gsts_SQLQuery : TStrings ;

    gprs_ParamSource : TParams ;
    {$IFDEF EADO}
    gprt_ParameterSource : TParameters ;
    {$ENDIF}

    gds_Query1           ,
    gds_Query2           : TDataSource ;
    ds_DatasourceQuery   ,
    ds_DataSourceQuery2 : TDatasource ;
    gws_RecordValue ,
    gws_Oldfilter ,
    gws_Filter : String ;
    ge_BasketGetAll : EBasketAllEvent ;
    gb_Oldfiltered,
    gb_Open,
    gb_Enregistre    ,
    gb_Filtered : Boolean ;
    // Première fois de ce composant : Utilisé dans loaded
    function  fds_GetDatasourceQuery : TDataSource;
    function  fds_GetDatasourceQuery2 : TDataSource;
    procedure p_SetDataSourceQuery ( const a_Value: TDataSource );
    procedure p_SetDataSourceQuery2 ( const a_Value: TDataSource );
    procedure p_SetFilter   ( Value : String );
    procedure p_SetFiltered ( Value : Boolean    );
    procedure p_SetDataSourceGroupes ( const a_Value: TDataSource );
    function  fds_GetDatasourceGroupes : TdataSource ;
    procedure p_groupeMouseDownDisableEnableFleche ( const aLSV_groupe : TListView ; const abt_item : TControl );
    procedure p_SetListeTotal  ( const a_Value: TWinControl );
    procedure p_SetBtnListe  ( const a_Value: TWinControl );
    procedure p_SetAutreTotal  ( const a_Value: TWinControl );
    procedure p_SetBtnAutreListe  ( const a_Value : TWinControl );
    procedure p_setBtnPanier      ( const a_Value : TWinControl );
    procedure p_SetAutreListe  ( const a_Value: TDBGroupView );
    procedure p_setEnregistre  ( const a_Value: TWinControl );
    procedure p_setAbandonne   ( const a_Value: TWinControl );
    procedure p_setCleGroupe   ( const a_Value: String );
    procedure p_setChampUnite  ( const a_Value: String );
    procedure p_SetChampGroupe ( const a_Value: String );
    procedure p_SetTableGroupe ( const a_Value: String );
    procedure p_SetImageSupprime ( const a_Value: Integer );
    procedure p_SetImageInsere ( const a_Value: Integer );
    function fb_ErreurBtnTotalIn: Boolean;
    function fb_ErreurBtnIn: Boolean;
    function fb_ErreurBtnOut: Boolean;
    function fb_ErreurBtnTotalOut: Boolean;
    function fb_ValideBoutons: Boolean ;
    function fvar_PeutMettrePlus(const aadoq_Dataset, aadoq_Query: TDataset;
                                 const asi_ItemsSelected: TListItem ): Variant;
    function fi_FindList   ( var at_List : tt_TableauVariant ; const alsi_Item : TListItem ) : Integer ;
    function fi_SupprimeItem ( var at_List : tt_TableauVariant ; const alsi_Item : TListItem ) : Integer ;
    function fws_GetExistingFilter: String;
    function fb_ValueToValid(const afie_ChampTest: TField): Boolean;
   protected
    gds_Querysource      : TDataSource ;
    gdat_QuerySource     : TDataset ;
    gdat_Query1          ,
    gdat_Query2          : TDataset;

    // Groupe en cours
    gvar_GroupeEnCours : Variant ;
    // lien vers le Datasource mettant à jour le composant
    gdl_DataLinkOwner : TUltimListViewDatalink;
    // champ de groupe dans la table d'association des groupes
    // Ou clé étrangère vers la table des groupes
    // Clé du Datasource des informations du groupe
    gstl_CleGroupe     ,
    gstl_ChampGroupe     : TStringList ;
    gs_ChampGroupe ,
    // champ unité dans la table d'association des groupes
    // Ou clé primaire de la table liée
    gs_ChampUnite   ,
    // Sort sauvegardé du query
    gs_SortQuery    ,
    // Table des groupes
    gs_TableOwner ,
    // Clé primaire de la table des groupes
    gs_CleGroupe    ,
    // Table d'association NN des groupes
    gs_TableGroupe  : {$IFDEF FPC}AnsiString {$ELSE}string{$ENDIF};
    // Propriété "est Datasource de liste d'inclusion"
    gb_EstPrincipale : Boolean;
    // anciens evènements sur click des boutons
    ge_enregistreEvent   ,
    ge_FilterEvent       ,
    ge_QueryAll           ,
    ge_abandonneEvent    : TDatasetNotifyEvent ;
    ge_enregistreError   : TDataSetErrorEvent ;
    ge_PanierClick       ,
    ge_enregistreClick   ,
    ge_abandonneClick    ,
    ge_ListeTotalClick   ,
    ge_BtnInvertClick    ,
    ge_ListeClick        : TNotifyEvent ;
     /////////////////////////
     // Propriétés boutons  //
      /////////////////////////
       // Panier
    gBT_Panier       ,
    gBT_Optionnel       ,
    // Enregistre : évènement si principale
    gBT_enregistre   ,
    // abandonne : évènement si principale
    gBT_abandonne    ,
    // Ajoute tout dans la liste : évènement
    gBT_ListeTotal   ,
    // Ajoute dans la liste : évènement
    gBT_Liste        ,
    // Inversion des deux listes
    gbt_Exchange      ,
    // supprime de la liste
    gBT_Autre        ,
    // supprime tout de la liste
    gBT_AutreTotal   : TWinControl ;
    // Propriété Image d'Insertion
    gi_ImageInsere   ,
    // Propriété Image de suppression
    gi_ImageSupprime : Integer ;
    // Propriété autre liste
    galv_AutreListe  : TDBGroupView ;
    gb_SelfOpen ,
    gb_NoScroll      ,
    // Panier
    gb_Panier        : Boolean ;
    {$IFNDEF FPC}
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    {$ENDIF}
    function fb_BeginOpen: Boolean; virtual;
    function fb_ExecuteQueryNotLinkedNNGroupSourceSimilar: Boolean; virtual;
    function fb_ExecuteQueryNotLinkedNNGroupSourceDifferent: Boolean; virtual;
    function fb_ExecuteQuery1N: Boolean; virtual;
    function fb_ExecuteQueryNotLinkedNNGroupSourceDifferentTotal: boolean; virtual;
    function fb_ExecuteQueryNotLinkedNNGroupSourceDifferentTotalOut: boolean; virtual;
    function fb_ExecuteQueryNotLinkedNNGroupSourceSimilarTotal: boolean; virtual;
    function fb_ExecuteQueryNotLinkedNNGroupSourceSimilarTotalOut: boolean; virtual;
    function fb_ExecuteQueryShowAllGroup ( const astl_KeysListOut: tt_TableauVariant ): boolean; virtual;
    function fb_ExecuteQueryLinkedAllSelect: boolean; virtual;
    function fb_ExecuteQueryLinkedAllSelectTotal: boolean; virtual;
    procedure p_SetDatasources; virtual;
    function  fb_OpenParamsQuery : Boolean; virtual;
    Procedure p_OpenQuery; virtual;
    procedure p_SetButtonsOther(const ab_Value: Boolean);  protected
    procedure p_AffecteListImages ; virtual;
    procedure p_AffecteEvenementsDatasource; override;
    procedure EditingChanged; override;
    procedure p_SetDataSourceGroup( CONST a_Value: TDataSource); override;
    Procedure p_DataSetChanged; override;
    procedure p_LocateInit; virtual;
    procedure p_LocateRestore; virtual;
    procedure p_UndoRecord; virtual;
    procedure p_AddOriginKey ( const avar_Ajoute : Variant );virtual;
    procedure p_ReinitialisePasTout; override;
    function  fb_Locate ( const avar_Records : Variant ): Boolean ;
    procedure p_MajBoutons ( const ai_ItemsAjoutes : Integer ); override;
    procedure p_DesactiveGrille; virtual;
    procedure p_VerifieModifications; virtual;
    function  fb_PeutAjouter          ( const adat_Dataset : TDataset ; const ab_AjouteItemPlus : Boolean) : Boolean ; override;
    function  fb_ChangeEtatItem       ( const adat_Dataset : TDataset ; const ab_AjouteItemPlus : Boolean ) : Boolean ; override;
    function  fb_RemplitEnregistrements ( const adat_Dataset : TDataset ; const ab_InsereCles : Boolean ) : Boolean ; override;
    function  fb_RemplitListe : Boolean ; override;
    function  fb_PeutTrier  : Boolean ; override;
    procedure DoSelectItem ( llsi_ItemsSelected : TListItem; ab_selected : Boolean ); {$IFNDEF FPC}virtual{$ELSE}override{$ENDIF};
    Procedure DataLinkScrolled; virtual;
    Procedure DataLinkClosed; virtual;
    procedure DblClick ; override;
    procedure DragOver ( aobj_Source : Tobject; ai_X, ai_Y : Integer ; ads_Etat : TDragState ; var ab_Accepte : Boolean ); override;
    procedure KeyUp(var Key: Word; Shift: TShiftState); override;
    procedure MouseDown( abt_Bouton : TMouseButton ; ass_EtatShift : TShiftState ; ai_x, ai_y : Integer ); override;
    procedure p_PostDataSourceOwner; virtual;
    procedure p_CreateSQL; virtual;


   public
    gb_ListTotal,
    gb_ListTotalReal    : Boolean ;
    // Clés hors de la liste
    // Clés exclues de cette liste : l'autre liste a les clés incluses
    gt_KeyOwners     : tt_TableauVarOption ;
    gstl_KeysListOut : tt_TableauVariant ;

    procedure p_LoadListView ; override;
    constructor Create ( acom_owner : TComponent ); override;
    destructor Destroy ; override;
    Procedure p_AjouteEnregistrementsSynchrones; override;
    procedure p_Reinitialise ; override;
    procedure DragDrop ( aobj_Source : Tobject; ai_X, ai_Y : Integer ); override;
    procedure p_TransfertTotal ;
    procedure p_VideListeTotal ;
    procedure Refresh ;
    property AllList    : Boolean read gb_ListTotal ;
   published
    procedure p_Abandonne  ( Sender : TObject ); virtual;
    procedure p_Enregistre ( Sender : TObject ); virtual;
    procedure p_VidePanier ( Sender : TObject ); virtual;
    procedure p_ClickTransfertTotal ( Sender : TObject ); virtual;
    procedure p_ClickTransfert      ( Sender : TObject ); virtual;
    procedure p_InvertClick ( Sender : TObject ); virtual;

    // Table de l'association des groupes
    property DataTableGroup : {$IFDEF FPC}AnsiString {$ELSE}string{$ENDIF} read gs_TableGroupe write p_setTableGroupe;
    // Table du Datasource des groupes édités
    property DataTableOwner : {$IFDEF FPC}AnsiString {$ELSE}string{$ENDIF} read gs_TableOwner write gs_TableOwner;
    // Datasource d'un query
    property DatasourceQuery : TDataSource read fds_GetDatasourceQuery write p_SetDataSourceQuery;
    // Datasource d'un deuxième query
    property DataSourceQuery2 : TDataSource read fds_GetDataSourceQuery2 write p_SetDataSourceQuery2;
    // Datasource des groupes édités
    property DataSourceOwner : TDataSource read fds_GetDatasourceGroupes write p_SetDataSourceGroupes;
    // clé du query
    // du Datasource des groupes édités
    property DataKeyOwner : {$IFDEF FPC}AnsiString {$ELSE}string{$ENDIF} read gs_CleGroupe write p_setCleGroupe;
    // field des unités de l'association des groupes
    property DataFieldUnit : {$IFDEF FPC}AnsiString {$ELSE}string{$ENDIF} read gs_ChampUnite write p_setChampUnite;
    // field des groupes de l'association des groupes
    property DataFieldGroup : {$IFDEF FPC}AnsiString {$ELSE}string{$ENDIF} read gs_ChampGroupe write p_setChampGroupe;
    // La liste est-elle la liste principale : liste d'inclusion
    property DataListPrimary : Boolean read gb_EstPrincipale write gb_EstPrincipale default True;
    // Bouton de transfert total de la liste
    property ButtonTotalIn : TWinControl read gBT_ListeTotal write p_setListetotal ;
    // Bouton de transfert de la liste
    property ButtonIn : TWinControl read gBT_Liste write p_setBtnListe ;
    // Bouton de transfert entre deux listes
    property ButtonExchange : TWinControl read gbt_Exchange write gbt_Exchange ;
    // Bouton de transfert total de l'autre liste
    property ButtonTotalOut : TWinControl read gBT_AutreTotal write p_setAutretotal ;
    // Bouton de transfert de l'autre liste
    property ButtonOut: TWinControl read gBT_Autre write p_setBtnAutreListe ;
    // autre liste : liste complémentaire et obligatoire
    property DataListOpposite: TDBGroupView read galv_AutreListe write p_setAutreListe ;
    // Bouton d'enregistrement
    property ButtonRecord: TWinControl read gBT_enregistre write p_setEnregistre ;
    // Bouton d'enregistrement
    property ButtonOption: TWinControl read gBT_Optionnel write gBT_Optionnel ;
    // Bouton d'annulation de la composition
    property ButtonCancel: TWinControl read gBT_abandonne write p_setAbandonne ;
    // image ajoute de Imagelist
    property DataImgInsert : Integer read gi_ImageInsere write p_setImageInsere default 1;
    // image enlève de Imagelist
    property DataImgDelete : Integer read gi_ImageSupprime write p_SetImageSupprime default 0;
    // Panier
    property ButtonBasket : TWinControl read gBT_Panier write p_setBtnPanier ;
    // Récupération du trie des colonnes
    property DataSensitiveBug : Boolean read gb_CaseInSensitive write gb_CaseInSensitive default True ;

    //EVènements
    property OnDataRecorded : TDatasetNotifyEvent read ge_enregistreEvent write ge_enregistreEvent ;
    property OnDataCanceled : TDatasetNotifyEvent read ge_abandonneEvent write ge_abandonneEvent ;
    property OnDataRecordError : TDatasetErrorEvent read ge_enregistreError write ge_enregistreError ;
    property OnDataFilter : TDatasetNotifyEvent read ge_FilterEvent write ge_FilterEvent ;
    property OnDataAllQuery : TDatasetNotifyEvent read ge_QueryAll write ge_QueryAll ;

    // Filtrage SQL
    property DataAllFilter   : String read gws_Filter write p_SetFilter ;
    property DataAllFiltered : Boolean read gb_Filtered write p_SetFiltered ;
    property DataRecordValue : String read gws_RecordValue write gws_RecordValue ;
    property OnDataAllWhereBasket : EBasketAllEvent read ge_BasketGetAll write ge_BasketGetAll ;
    property DataKeyUnit;
   end;

function fb_WaitForLoadingFirstFetch : Boolean ;
function fb_BuildWhereBasket ( const aalv_Primary: TDBGroupView ; var as_Result : String ; const ab_GetNull, ab_GetCurrent : Boolean ): Boolean; overload;
function fb_BuildWhereBasket ( const aalv_Primary: TDBGroupView ; var as_Result : String ; const ab_GetNull, ab_GetCurrent, ab_Order : Boolean ): Boolean; overload;

  // Message de confirmation d'enregistrement avant le tri
const
     // nombre par défaut de pages à charger
     CST_GROUPE_PAGES_CHARGER = 3 ;
     CST_GROUPE_COULEUR_FOCUS = clSkyBlue ;
     CST_GROUPE_TRANS_TOTAL   = 1 ;
     CST_GROUPE_TRANS_SIMPLE  = 0 ;
     CST_GROUPE_TRANS_RETOUR   = 2 ;
     CST_GROUPE_TRANS_DESTI   = 1 ;
     CST_GROUPE_TRANS_EXCLU   = 0 ;


var gcol_CouleurFocus : TColor = CST_GROUPE_COULEUR_FOCUS ;
    gcol_CouleurLignePaire   : Tcolor = clInfoBk ;
    gcol_CouleurLigneImpaire : Tcolor = clWhite  ;
    // Evènement centralisé de syncho du mode asynchrone
    ge_GroupFetchLoading : TEvent = Nil ;
    gim_GroupViewImageList : TImageList = Nil;

implementation

uses TypInfo, fonctions_string, fonctions_proprietes, Variants,  ExtCtrls,  fonctions_erreurs,
     fonctions_db, fonctions_dbcomponents, unite_messages ;

// non Utilisé : On change de groupe dans DataSetChanged
{Procedure TUltimListViewDatalink.DataSetScrolled(Distance: Integer);
Begin
  inherited ;
End;
 }
// Utilisé : On a supprimé un groupe
Procedure TDBGroupView.p_DataSetChanged;
Begin
  inherited ;
  // sur le datasource des groupes
  if not gb_SelfOpen
  and assigned ( gdl_DataLink.DataSet )
   Then
    Begin
       // Si on est en consultation ( suppression n'est pas une édition )
      if ( Datasource.DataSet.State = dsBrowse )
      {$IFDEF EADO}
      and ( not ( Datasource.DataSet is TCustomADODataset ) or not ( eoAsyncExecute in ( Datasource.DataSet as TCustomADODataset ).ExecuteOptions ) or not ( stFetching in ( Datasource.DataSet as TCustomADODataset ).RecordsetState ))
      {$ENDIF}
      Then
         // Mise A Jour de la liste
        DataLinkScrolled ;

    End ;
End;

Procedure TDBGroupView.p_OpenQuery;
Begin
   // Filtrage
   // Gestion non N-N
   with gdl_DataLink.DataSet do
     Begin
       if ((  gs_TableGroupe <> DataTableUnit )
       // Ou principale
            or  gb_EstPrincipale )
        // le champ groupe existe-t-il
       and assigned ( gdl_DataLink.DataSet.FindField ( gs_ChampGroupe ))
       and assigned ( gdl_DataLinkOwner.DataSet )
        Then
          // Filtrage
          try
             // pour filtrer le dataset doit être actif
            gb_SelfOpen := True ;
            if ( State = dsInactive ) Then
              Begin
                 Open ;
              End ;
            gb_SelfOpen := False ;

            // Filtrage
            if ((gdl_DataLinkOwner.DataSet.FindField ( gs_CleGroupe ) is TStringField )
            or (gdl_DataLinkOwner.DataSet.FindField ( gs_CleGroupe ) is TBlobField )
            or ( gdl_DataLinkOwner.DataSet.FindField ( gs_CleGroupe ).DataType IN CST_DELPHI_FIELD_STRING ))
             Then Filter := gs_ChampGroupe + ' = ''' + fs_stringdbQuote ( gdl_DataLinkOwner.DataSet.FieldByName ( gs_CleGroupe ).AsString ) + ''''
             Else Filter := gs_ChampGroupe + ' = '   +                  ( gdl_DataLinkOwner.DataSet.FieldByName ( gs_CleGroupe ).AsString ) ;
             // Activation du filtrage
            Filtered := True ;
          Except
            gb_SelfOpen := False ;
          End
         Else
          try
            // Sinon mise à jour des données
            gb_SelfOpen := True ;
            if ( State = dsInactive ) Then
              Begin
                Open ;
              End ;
          finally
            gb_SelfOpen := False ;
          End ;
     End;
End;

Function TDBGroupView.fb_OpenParamsQuery:Boolean;
Begin
  Result := False;
  if ( assigned ( gprs_ParamSource ) and ( gprs_ParamSource.Count > 0 ))
    {$IFDEF EADO}
  or ( assigned (  gprt_ParameterSource ) and ( gprt_ParameterSource.Count > 0 ))
    {$ENDIF}
    Then
      with gdl_DataLink.DataSet do
        Begin
          If  assigned ( gdl_DataLinkOwner.DataSet )
          and gdl_DataLinkOwner.DataSet.Active Then
            try
              gb_SelfOpen := True ;
              Close ;
              // Alors Affectation du premier paramètre en tant que paramètre du groupe
              if assigned ( gprs_ParamSource ) Then
                Begin
                  gprs_ParamSource.Items [ 0 ].DataType := gdl_DataLinkOwner.DataSet.FieldByName ( gs_CleGroupe ).DataType;
                  if gdl_DataLinkOwner.DataSet.IsEmpty
                  or gdl_DataLinkOwner.DataSet.FieldByName ( gs_CleGroupe ).IsNull
                   then
                    Begin
                      if ( gdl_DataLinkOwner.DataSet.FieldByName ( gs_CleGroupe ) is TNumericField ) then
                       gprs_ParamSource.Items [ 0 ].Value    := 0
                      else
                       gprs_ParamSource.Items [ 0 ].Value    := '';
                    End
                  else
                   Begin
                     gprs_ParamSource.Items [ 0 ].Value    := gdl_DataLinkOwner.DataSet.FieldByName ( gs_CleGroupe ).Value
                   End;
                End
        {$IFDEF EADO}
               else
                 Begin
                  gprt_ParameterSource.BeginUpdate;
                  gprt_ParameterSource.Items [ 0 ].DataType := gdl_DataLinkOwner.DataSet.FieldByName ( gs_CleGroupe ).DataType;

                  if gdl_DataLinkOwner.DataSet.IsEmpty
                  or gdl_DataLinkOwner.DataSet.FieldByName ( gs_CleGroupe ).IsNull
                  then
                    Begin
                      if ( gdl_DataLinkOwner.DataSet.FieldByName ( gs_CleGroupe ) is TNumericField ) then
                       gprt_ParameterSource.Items [ 0 ].Value    := 0
                      else
                       gprt_ParameterSource.Items [ 0 ].Value    := ' ';
                    End
                  else
                   Begin
                     gprt_ParameterSource.Items [ 0 ].Value    := gdl_DataLinkOwner.DataSet.FieldByName ( gs_CleGroupe ).Value
                   End;
                  gprt_ParameterSource.EndUpdate;
                 End;
        {$ENDIF};
           // Gestion de relations N N
              if ( not gb_Panier )
        /// Ou sur le groupview principal contenant la liste des enregistrements
              or gb_EstPrincipale
              // Ou vide
              or (      ( assigned ( gdl_DataLinkOwner.DataSet.FindField ( gs_CleGroupe ))
                    and ( gdl_DataLinkOwner.DataSet.FindField ( gs_CleGroupe ).IsNull)))
              or (      ( assigned ( gdl_DataLink.DataSet.FindField ( gs_ChampGroupe ))
                    and ( gdl_DataLink.DataSet.FindField ( gs_ChampGroupe ).IsNull)))
                Then
                  if ( State = dsInactive ) Then
                    Begin
                      Open ;
                      Result := True;
                    End ;
              gb_SelfOpen := False ;
            Except
               gb_SelfOpen := False ;
            End;
        End;
End;

procedure TDBGroupView.DataLinkClosed;
begin
  {$IFDEF EADO}
  p_SetUnFetch;
  {$ENDIF}
  if not gb_SelfOpen Then
    gb_AllLoaded := True ;
end;

// Non utilisé
{Procedure TUltimListViewDatalink.RecordChanged(Field: TField);
Begin
  inherited ;
//  glst_GroupView.DataLinkRecordChanged(Field);
End;
 }



// Fonction : fb_WaitForLoadingFirstFetch
// Mode asynchrone : Attente d'un chargement d'items dans la liste
// A appeler avant de créer l'évènement ge_GroupFetchLoading et après tout ça mettre p_AjouteEnregistrementsSynchrones
// Retour : Dataset actif ou pas
Function  fb_WaitForLoadingFirstFetch : Boolean ;
Begin
  While assigned ( ge_GroupFetchLoading ) and ( ge_GroupFetchLoading.WaitFor ( 100 ) = wrSignaled ) do
     Begin
       Application.ProcessMessages ;

     End ;
  Result := True ;
End ;




// Récupère le datasource du Query
function TDBGroupView.fds_GetDatasourceQuery : TdataSource;
begin
  Result := ds_DataSourceQuery ;
end;

// Récupère le datasource du Query
function TDBGroupView.fds_GetDataSourceQuery2 : TdataSource;
begin
  Result := ds_DataSourceQuery2 ;
end;

// Affectation du composant dans la propriété DataSourceQuery
// test si n'existe pas
// Mise à jour du nom de table
// a_Value : Le datasource
procedure TDBGroupView.p_SetDataSourceQuery ( const a_Value: TDataSource );
var lobj_SQL : TObject ;
begin
{$IFNDEF FPC}
  ReferenceInterface ( DataSourceQuery, opRemove ); //Gestion de la destruction
{$ENDIF}
  if ds_DatasourceQuery <> a_Value then
  begin
    ds_DatasourceQuery := a_Value ; /// affectation
  end;
{$IFNDEF FPC}
  ReferenceInterface ( DataSourceQuery, opInsert ); //Gestion de la destruction
{$ENDIF}
  if  not assigned ( ds_DatasourceQuery ) Then
    Begin
      gsts_SQLQuery := nil ;
{$IFDEF DELPHI_9_UP}
      gwst_SQLQuery := nil ;
{$ENDIF}
    End
  else
  if  not ( csDesigning in ComponentState )
  and assigned ( ds_DatasourceQuery.DataSet ) Then
    Begin
      lobj_SQL := fobj_getComponentObjectProperty ( ds_DatasourceQuery.DataSet, 'SQL' );
      if assigned ( lobj_SQL ) Then
        Begin
          if ( lobj_SQL is TStrings ) Then
            gsts_SQLQuery := lobj_SQL as TStrings 
{$IFDEF DELPHI_9_UP}
            else if ( lobj_SQL is TWideStrings ) Then
              gwst_SQLQuery := lobj_SQL as TWideStrings
{$ENDIF}
            ;
        End;
    End ;

end;


// Affectation du composant dans la propriété DataSourceQuery2
// test si n'existe pas
// Mise à jour du nom de table
// a_Value : Le datasource
procedure TDBGroupView.p_SetDataSourceQuery2 ( const a_Value: TDataSource );
begin
{$IFNDEF FPC}
  ReferenceInterface ( DataSourceQuery2, opRemove ); //Gestion de la destruction
{$ENDIF}
  if ds_DataSourceQuery2 <> a_Value then
  begin
    ds_DataSourceQuery2 := a_Value ; /// affectation
  end;
{$IFNDEF FPC}
  ReferenceInterface ( DataSourceQuery2, opInsert ); //Gestion de la destruction
{$ENDIF}
  if  not assigned ( ds_DatasourceQuery2 ) Then
    Begin
      gsts_SQLCommand := nil ;
{$IFDEF DELPHI_9_UP}
      gwst_SQLCommand := nil ;
{$ENDIF}
    End
  else
  if ( ds_DataSourceQuery2 <> nil )
  and not ( csDesigning in ComponentState )
  and assigned ( ds_DataSourceQuery2.DataSet ) Then
    Begin
      fb_GetSQLStrings ( ds_DataSourceQuery2.DataSet, gsts_SQLCommand{$IFDEF DELPHI_9_UP}, gwst_SQLCommand {$ENDIF});
    End ;
end;

// Affectation du composant dans la propriété DataSource
// test si n'existe pas
// Mise à jour des paramètres et du code SQL
// a_Value : Le datasource
procedure TDBGroupView.p_SetDataSourceGroup ( const a_Value: TDataSource );
var old_Value: TDataSource ;
begin
  old_Value:= gdl_DataLink.Datasource ;
  inherited p_SetDataSourceGroup ( a_Value );
  if  not assigned ( gdl_DataLink.DataSet ) Then
    Begin
      // On a besoin du dataset
      gdl_DataLink.Datasource := nil;
      gsts_SQLSource := nil ;
{$IFDEF DELPHI_9_UP}
      gwst_SQLSource := nil ;
{$ENDIF}
    End
  else if ( old_Value <> a_Value )
   Then
    Begin
      fb_GetSQLStrings ( gdl_DataLink.DataSet, gsts_SQLSource{$IFDEF DELPHI_9_UP}, gwst_SQLSource {$ENDIF});
      fb_GetParamsDataset (gdl_DataLink.DataSet, gprs_ParamSource {$IFDEF EADO}, gprt_ParameterSource {$ENDIF});




     p_CreateSQL;

    End ;
end;

procedure TDBGroupView.p_CreateSQL;
var li_i : Integer ;
{$IFDEF DELPHI_9_UP}
    ls_Query : String ;
{$ELSE}
    ls_Query : String ;
{$ENDIF}
begin
  if not assigned ( ge_QueryAll )
  and assigned ( gdl_DataLink.DataSet )
  and assigned ( gsts_ChampsListe )
  and not ( gdl_DataLink.DataSet.Active )
  and (( assigned ( gsts_SQLSource ) and ( trim ( gsts_SQLSource.Text ) = '' ))
 {$IFDEF DELPHI_9_UP}
  or ( assigned ( gwst_SQLSource) and ( trim ( gwst_SQLSource.Text ) = '' )){$ENDIF})
   Then
    Begin
      // Création de la sélection ( SELECT ) du query de Datasource
      ls_Query := 'SELECT ' ;
      if ( gsts_ChampsListe.Count > 0 ) then
        Begin
          ls_Query := ls_Query + gs_TableSource + CST_FIELD_DECLARE_SEPARATOR +gsts_ChampsListe [ 0 ] ;
            for li_i := 1 to gsts_ChampsListe.Count - 1 do
              Begin
                ls_Query := ls_Query + ', ' + gs_TableSource + CST_FIELD_DECLARE_SEPARATOR + gsts_ChampsListe [ li_i ] ;
              End ;
          if assigned ( gstl_CleDataSource ) Then
            if gt_ColonneCle [ 0 ] >= gsts_ChampsListe.Count Then
              for li_i := 0 to gstl_CleDataSource.Count - 1 do
                Begin
                  ls_Query := ls_Query + ', ' + gs_TableSource + CST_FIELD_DECLARE_SEPARATOR + gstl_CleDataSource [ li_i ] ;
                End ;
        End ;

        if gb_EstPrincipale Then
          Begin
            if ( gs_TableGroupe = gs_TableSource ) Then
              Begin
                ls_Query := ls_Query + ' FROM ' + gs_TableSource ;
                ls_Query := ls_Query + ' WHERE ' + gs_ChampGroupe + ' = :GroupKey' ;
              End
            Else
              Begin
                  // Propriété DatasourceGroupTable : gs_TableGroupe
                ls_Query := ls_Query + ' FROM ' + gs_TableGroupe + ' , ' + gs_TableSource  ;
                ls_Query := ls_Query + ' WHERE ' + gs_TableSource + CST_FIELD_DECLARE_SEPARATOR + gs_CleUnite + ' = ' + gs_TableGroupe + '.' + gs_ChampUnite ;
                ls_Query := ls_Query + ' AND ' + gs_TableGroupe + CST_FIELD_DECLARE_SEPARATOR + gs_ChampGroupe + ' = :GroupKey' ;
              End
          End
        Else
          if ( gs_TableGroupe = gs_TableSource ) Then
            Begin
                ls_Query := ls_Query + 'FROM ' + gs_TableSource ;
              ls_Query := ls_Query + ' WHERE ' + gs_ChampGroupe + ' IS NULL' ;
            End
          Else
            Begin
              ls_Query := ls_Query + ' FROM ' + gs_TableSource  ;
              ls_Query := ls_Query + ' WHERE ' + gs_CleUnite + ' NOT IN ( SELECT ' + gs_ChampUnite + ' FROM ' + gs_TableGroupe ;
              ls_Query := ls_Query +                                     ' WHERE ' +  gs_ChampGroupe + ' = :GroupKey' + ' )' ;
            End ;
          if Assigned ( gsts_SQLSource ) then
           with gsts_SQLSource do
            Begin
             Text := ls_Query ;
            End
{$IFDEF DELPHI_9_UP}
          else if Assigned ( gwst_SQLSource ) then
            gwst_SQLSource.Text := ls_Query
{$ENDIF};
          if assigned ( gprs_ParamSource     )
          and ( gprs_ParamSource.Count = 0 ) Then
            Begin
              gprs_ParamSource.Clear ;
              gprs_ParamSource.Add ;
              gprs_ParamSource.Items [ 0 ].Name := 'GroupKey' ;
              gprs_ParamSource.Items [ 0 ].ParamType := ptInput;
            End ;
{$IFDEF EADO}
          if assigned ( gprt_ParameterSource )
          and ( gprt_ParameterSource.Count = 0 )
           Then
            Begin
              gprt_ParameterSource.Clear ;
              gprt_ParameterSource.Add ;
              gprt_ParameterSource.Items [ 0 ].Name := 'GroupKey' ;
              gprt_ParameterSource.Items [ 0 ].Direction := pdInput;
              gprt_ParameterSource.Items [ 0 ].Attributes := [paSigned,paNullable];
            End ;
{$ENDIF}
   End ;
//  ShowMessage(ls_Query);
End ;

procedure TDBGroupView.p_SetDatasources ;
var
  ldat_Dataset : TDataset ;
begin
  if not ( csDesigning in ComponentState )
  and  ( not assigned ( ds_DatasourceQuery )
    or   not assigned ( ds_DatasourceQuery )
    or (  not assigned ( gdl_DataLink     .DataSet )and ( gb_EstPrincipale or ( gs_TableGroupe <> gs_TableSource )))
    or   not assigned ( gdl_DataLinkOwner.DataSet ))
  and  (    assigned ( gdl_DataLink     .DataSet )
         or assigned ( gdl_DataLinkOwner.DataSet )) Then
    Begin
      if assigned ( gdl_DataLinkOwner.DataSet ) Then
        ldat_Dataset := gdl_DataLinkOwner.DataSet
       else
        ldat_Dataset := gdl_DataLink.DataSet;
      if (   not assigned ( gdl_DataLink     .DataSet )
          or not assigned ( gdl_DataLinkOwner.DataSet ))
      and not assigned ( gds_Querysource ) Then
        Begin
          gdat_QuerySource := fdat_CloneDatasetWithoutSQL ( ldat_Dataset, Owner );
          gdat_QuerySource.Name:='gat_QuerySource' + Self.Name ;
          gds_Querysource := TDataSource.Create ( Owner ) ;
          gds_Querysource.Name:='gds_QuerySource' + Self.Name ;
          gds_Querysource.DataSet := gdat_QuerySource ;
        End ;

       if not assigned ( ds_DatasourceQuery )
       and not assigned ( gds_Query1 ) Then
        Begin
          gdat_Query1 := fdat_CloneDatasetWithoutSQL ( ldat_Dataset, Owner );
          gdat_Query1.Name:='gat_Query1'+ Self.Name ;
          gds_Query1 := TDataSource.Create ( Owner ) ;
          gds_Query1.Name:='gds_Query1' + Self.Name ;
          gds_Query1.DataSet := gdat_Query1 ;
          DatasourceQuery := gds_Query1 ;
        end ;
      if not assigned ( ds_DatasourceQuery2 )
      and not assigned ( gds_Query2 ) Then
        Begin
          gdat_Query2 := fdat_CloneDatasetWithoutSQL ( ldat_Dataset, Owner );
          gdat_Query2.Name:='gat_Query2' + Self.Name ;
          gds_Query2 := TDataSource.Create ( Owner ) ;
          gds_Query2.Name:='gds_Query2' + Self.Name ;
          gds_Query2.DataSet := gdat_Query2 ;
          DatasourceQuery2 := gds_Query2 ;
        end ;
      if not assigned ( gdl_DataLink.DataSet )
      and ( gb_EstPrincipale or ( gs_TableGroupe <> gs_TableSource )) Then
       Begin
        Datasource := gds_Querysource ;
       end
      else
        if not assigned ( gdl_DataLinkOwner.DataSet ) Then
         Begin
          DataSourceOwner := gds_Querysource ;
         end ;
    End ;
End;

// Initialisation des images d'état
procedure TDBGroupView.p_AffecteListImages ;
var lbmp_Image : TBitmap ;
Begin
  if not assigned ( {$IFDEF FPC}SmallImages{$ELSE}StateImages{$ENDIF} ) Then
    Begin
      if not assigned ( gim_GroupViewImageList )
      Then
        Begin
          gim_GroupViewImageList := TImageList.Create(nil);
          gim_GroupViewImageList.BkColor := clBlack;
          gim_GroupViewImageList.BlendColor := clBlack;
        End;
      lbmp_Image := TBitmap.Create;
      {$IFNDEF FPC}
      ResInstance:= FindResourceHInstance(HInstance);
      {$ENDIF}
      {$IFDEF FPC}
      lbmp_Image.LoadFromLazarusResource( 'GROUPVIEW_MINUS' );
      {$ELSE}
      lbmp_Image.LoadFromResourceName(ResInstance,'GROUPVIEW_MINUS');
      {$ENDIF}
      gim_GroupViewImageList.AddMasked(lbmp_Image, lbmp_Image.TransparentColor );
      {$IFDEF FPC}
      lbmp_Image.LoadFromLazarusResource( 'GROUPVIEW_PLUS' );
      {$ELSE}
      lbmp_Image.LoadFromResourceName(ResInstance,'GROUPVIEW_PLUS');
      {$ENDIF}
      gim_GroupViewImageList.AddMasked(lbmp_Image, lbmp_Image.TransparentColor );
      {$IFNDEF FPC}
      lbmp_Image.Dormant ;
      {$ENDIF}
      lbmp_Image.FreeImage ;
      lbmp_Image.Handle := 0 ;
      {$IFDEF FPC}SmallImages{$ELSE}StateImages{$ENDIF} := gim_GroupViewImageList;
    End;
End;
// Initialisation des variables en fonction des propriétés
procedure TDBGroupView.p_AffecteEvenementsDatasource ;
// Méthode évènement
var
  {$IFNDEF FPC}
  lmet_MethodeDistribueeSelect,
  {$ENDIF}
  lmet_MethodeDistribueeInvert ,
  lmet_MethodeDistribueeTransfert  ,
  lmet_MethodeDistribueeVPanier  ,
  lmet_MethodeDistribueeEnregistre  ,
  lmet_MethodeDistribueeAnnule  ,
  lmet_MethodeDistribueeTotal  : TMethod ;
  lvar_Valeur : Variant ;
begin
  {$IFNDEF FPC}
  ge_Onselectitem := OnSelectItem;
  lmet_MethodeDistribueeSelect .Data := Self ;
  lmet_MethodeDistribueeSelect.Code := MethodAddress ( 'DoSelectItem' );
  OnSelectItem := TLVSelectItemEvent ( lmet_MethodeDistribueeSelect );
  p_AffecteListImages ;
  {$ENDIF}
  // Si on est en exécution
  if assigned ( gBt_Panier )
  and ( gs_TableGroupe = gs_TableSource ) Then
    gb_Panier := True
  Else
    gb_Panier := False ;

  p_SetDatasources;

  // Initialisation du panier si il y a un panier
  If Hint = ''
   Then
    Begin
      if gb_EstPrincipale
       Then Hint := GS_GROUP_INCLUDE_LIST
       Else Hint := GS_GROUP_EXCLUDE_LIST ;
    End ;
  p_ChampsVersListe ( gstl_CleGroupe, gs_CleGroupe, FieldDelimiter );
  p_ChampsVersListe ( gstl_ChampGroupe, gs_ChampGroupe, FieldDelimiter );

  // Est-ce la liste d'enregistrement et d'abandon : liste principale
  if gb_EstPrincipale
   Then
    Begin

    // Affectation de l'évènement onclick d'enregistre
      if assigned ( gBt_Enregistre )
       Then
        Begin
          // affectation de la méthode du nouvel évènement
          lmet_MethodeDistribueeEnregistre .Data := Self ;
          lmet_MethodeDistribueeEnregistre.Code := MethodAddress ( 'p_Enregistre' );
          // récupération et Affectation
          if  IsPublishedProp ( gBt_Enregistre, 'OnClick'           )
          and PropIsType      ( gBt_Enregistre, 'OnClick', tkMethod )
           Then
            try
              ge_enregistreClick := TNotifyEvent ( GetMethodProp ( gBt_Enregistre, 'OnClick' ));
              SetMethodProp ( gBt_Enregistre, 'OnClick', lmet_MethodeDistribueeEnregistre );
            Except
            End ;
        End ;
      if assigned ( gbt_Exchange )
       Then
        Begin
          // affectation de la méthode du nouvel évènement
          lmet_MethodeDistribueeInvert.Data := Self ;
          lmet_MethodeDistribueeInvert.Code := MethodAddress ( 'p_InvertClick' );
          // récupération et Affectation
          if  IsPublishedProp ( gbt_Exchange, 'OnClick'           )
          and PropIsType      ( gbt_Exchange, 'OnClick', tkMethod )
           Then
            try
              ge_BtnInvertClick := nil ;
              ge_BtnInvertClick := TNotifyEvent ( GetMethodProp ( gbt_Exchange, 'OnClick' ));
              SetMethodProp ( gbt_Exchange, 'OnClick', lmet_MethodeDistribueeInvert );
            Except
            End ;
        End ;
    // Affectation de l'évènement onclick d'abandonne
      if assigned ( gBt_Abandonne )
       Then
        Begin
          // affectation de la méthode du nouvel évènement
          lmet_MethodeDistribueeAnnule.Data := Self ;
          lmet_MethodeDistribueeAnnule.Code := MethodAddress ( 'p_Abandonne' );
          if  IsPublishedProp ( gBt_Abandonne, 'OnClick'           )
          and PropIsType      ( gBt_Abandonne, 'OnClick', tkMethod )
           Then
            try
          // récupération et Affectation
              ge_abandonneClick := TNotifyEvent ( GetMethodProp ( gBt_Abandonne, 'OnClick' ));
              SetMethodProp ( gBt_Abandonne, 'OnClick', lmet_MethodeDistribueeAnnule );
            Except
            End ;
        End ;
      lvar_Valeur := Null ;
        // fin de l'affectation des évènements de la liste principale
      if assigned ( gBt_Panier )
       Then
        Begin
          if gBt_Panier.Hint = '' Then
            Begin
              if  IspublishedProp ( gBt_Panier, 'ParentShowHint' )
              and PropIsType      ( gBt_Panier, 'OnEnter', tkEnumeration ) Then
                lvar_Valeur := GetPropValue   (  gBt_Panier, 'ParentShowHint' );
              if  ( lvar_Valeur <> Null )
              and ( TVarData( lvar_Valeur ).VType = 256 ) Then
                SetPropValue   (  gBt_Panier, 'ParentShowHint', False );
              gBt_Panier.ShowHint := True ;
              gBt_Panier.Hint := GS_GROUPE_RETOUR_ORIGINE ;
            End ;
          // affectation de la méthode du nouvel évènement
          lmet_MethodeDistribueeVPanier.Data := Self ;
          lmet_MethodeDistribueeVPanier.Code := MethodAddress ( 'p_VidePanier' );
          // récupération et Affectation
          if  IsPublishedProp ( gBt_Panier, 'OnClick'           )
          and PropIsType      ( gBt_Panier, 'OnClick', tkMethod )
           Then
            try
              ge_PanierClick := TNotifyEvent ( GetMethodProp ( gBt_Panier, 'OnClick' ));
              SetMethodProp ( gBt_Panier, 'OnClick', lmet_MethodeDistribueeVPanier );
            Except
            End ;
        End ;
    End ;

  lvar_Valeur := Null ;
    // Affectation de l'évènement onclick du bouton de la liste
  if assigned ( gBt_Liste )
   Then
    Begin
//          if gBt_Liste.Hint = '' Then
        Begin
          if  IspublishedProp ( gBt_Liste, 'ParentShowHint' )
          and PropIsType      ( gBt_Liste, 'OnEnter', tkEnumeration ) Then
            lvar_Valeur := GetPropValue   (  gBt_Liste, 'ParentShowHint' );
          if  ( lvar_Valeur <> Null )
          and ( TVarData( lvar_Valeur ).VType = 256 ) Then
            SetPropValue   (  gBt_Liste, 'ParentShowHint', False );
          gBt_Liste.ShowHint := True ;
          if gb_EstPrincipale tHEN
            Begin
              gBt_Liste.Hint := GS_GROUPE_INCLURE ;
            End
          Else
            gBt_Liste.Hint := GS_GROUPE_EXCLURE ;
        End ;
          // affectation de la méthode du nouvel évènement
      lmet_MethodeDistribueeTransfert.Data := Self ;
      lmet_MethodeDistribueeTransfert.Code := MethodAddress ( 'p_ClickTransfert' );
      if  IsPublishedProp ( gBt_Liste, 'OnClick'           )
      and PropIsType      ( gBt_Liste, 'OnClick', tkMethod )
       Then
        try
          // récupération et Affectation
          ge_ListeClick := TNotifyEvent ( GetMethodProp ( gBt_Liste, 'OnClick' ));
          SetMethodProp ( gBt_Liste, 'OnClick', lmet_MethodeDistribueeTransfert );
        Except
        End ;
    End ;
  lvar_Valeur := Null ;
    // Affectation de l'évènement onclick du bouton total de la liste
  if assigned ( gBt_ListeTotal )
   Then
    Begin
//          if gBt_ListeTotal.Hint = '' Then
        Begin
          if  IspublishedProp ( gBt_ListeTotal, 'ParentShowHint' )
          and PropIsType      ( gBt_ListeTotal, 'OnEnter', tkEnumeration ) Then
            lvar_Valeur := GetPropValue   (  gBt_ListeTotal, 'ParentShowHint' );
          if  ( lvar_Valeur <> Null )
          and ( TVarData( lvar_Valeur ).VType = 256 ) Then
            SetPropValue   (  gBt_ListeTotal, 'ParentShowHint', False );
          gBt_ListeTotal.ShowHint := True ;
          if gb_EstPrincipale Then
            Begin
              gBt_ListeTotal.Hint := GS_GROUPE_TOUT_INCLURE ;
            End
          Else
            gBt_ListeTotal.Hint := GS_GROUPE_TOUT_EXCLURE ;
        End ;
          // affectation de la méthode du nouvel évènement
      lmet_MethodeDistribueeTotal.Data := Self ;
      lmet_MethodeDistribueeTotal.Code := MethodAddress ( 'p_ClickTransfertTotal' );
      if  IsPublishedProp ( gBt_ListeTotal, 'OnClick'           )
      and PropIsType      ( gBt_ListeTotal, 'OnClick', tkMethod )
       Then
        try
          // récupération et Affectation
          ge_ListeTotalClick := TNotifyEvent ( GetMethodProp ( gBt_ListeTotal, 'OnClick' ));
          SetMethodProp ( gBt_ListeTotal, 'OnClick', lmet_MethodeDistribueeTotal );
        Except
        End ;
    End ;
  // Fin de l'affectation des propriétés au premier chargement
End;


procedure TDBGroupView.p_LoadListView;
begin
  if ((Owner is TCustomForm) and not (Owner as TCustomForm).Visible ) Then
    Exit;

  // et si il est actif
  if assigned ( gdl_DataLinkOwner.DataSet )
  and not gb_Open
  and not ( gdl_DataLinkOwner.DataSet.IsEmpty )
    Then
      try
        // Alors on met à jour la liste
        {$IFDEF EADO}
        p_SetFetchLoaded ;
        {$ENDIF}
        gb_Open := True ;
        DataLinkScrolled ;
        gb_Open := False ;
      finally
      End;

End;


 ///////////////////////////////////////////////////////////////
// TDBGroupView                                           //
//////////////////////////////////////////////////////////////
// Affectation du composant dans la propriété DataSourceOwner
// test si n'existe pas
procedure TDBGroupView.p_SetDataSourceGroupes ( const a_Value: TDataSource );
var ls_Table : String;
begin
{$IFNDEF FPC}
  ReferenceInterface ( DataSourceOwner, opRemove ); // Gestion de la destruction
{$ENDIF}
  // Affectation
  if gdl_DataLinkOwner.DataSource <> a_Value then
  begin
    gdl_DataLinkOwner.DataSource := a_Value ;
  end;
{$IFNDEF FPC}
  ReferenceInterface ( DataSourceOwner, opInsert ); // Gestion de la destruction
{$ENDIF}
  // Récupération de la connexion

  if not assigned ( gdl_DataLinkOwner.DataSet ) then
    Begin
      gdl_DataLinkOwner.DataSource := nil;
    end
   else
    if HasLoad
    and not ( csCreating in ControlState ) then
      Begin
        p_SetDatasources;
        DataLinkScrolled;
      End;

   // Récupération de la table
  // Y-a-t-il un dataset
  if assigned ( gdl_DataLinkOwner.DataSet ) Then
    Begin
     ls_Table := trim (fs_getComponentProperty ( gdl_DataLinkOwner.DataSet, 'TableName' ));
     if ls_Table <> '' Then
       gs_TableOwner := ls_Table;
    end;
end;
// Erreur si mauvais bouton BtnTotalIn affecté
// Résultat :  le message d'erreur a été affiché
function TDBGroupView.fb_ErreurBtnTotalIn : Boolean ;
Begin
  Result := False ;
  if  assigned ( ButtonTotalIn     )
  and     ( csDesigning in ComponentState )
  and not ( csLoading   in ComponentState )
  and assigned ( galv_AutreListe )
  and ( ButtonTotalIn = galv_AutreListe.ButtonTotalIn )
   Then
    Begin
      ShowMessage ( GS_GROUPE_MAUVAIS_BOUTONS );
      Result := True ;
    End ;
End ;

// Erreur si mauvais bouton BtnIn affecté
// Résultat :  le message d'erreur a été affiché
function TDBGroupView.fb_ErreurBtnIn : Boolean ;
Begin
  Result := False ;
  if  assigned ( ButtonIn     )
  and     ( csDesigning in ComponentState )
  and not ( csLoading   in ComponentState )
  and assigned ( galv_AutreListe )
  and ( ButtonIn = galv_AutreListe.ButtonIn )
   Then
    Begin
      ShowMessage ( GS_GROUPE_MAUVAIS_BOUTONS );
      Result := True ;
    End ;
End ;

// Erreur si mauvais bouton BtnTotalOut affecté
// Résultat :  le message d'erreur a été affiché
function TDBGroupView.fb_ErreurBtnTotalOut : Boolean ;
Begin
  Result := False ;
  if  assigned ( ButtonTotalOut     )
  and     ( csDesigning in ComponentState )
  and not ( csLoading   in ComponentState )
  and assigned ( galv_AutreListe )
  and ( ButtonTotalOut = galv_AutreListe.ButtonTotalOut )
   Then
    Begin
      ShowMessage ( GS_GROUPE_MAUVAIS_BOUTONS );
      Result := True ;
    End ;
End ;

// Erreur si mauvais bouton BtnOut affecté
// Résultat :  le message d'erreur a été affiché
function TDBGroupView.fb_ErreurBtnOut : Boolean ;
Begin
  Result := False ;
  if  assigned ( ButtonOut     )
  and     ( csDesigning in ComponentState )
  and not ( csLoading   in ComponentState )
  and assigned ( galv_AutreListe )
  and ( ButtonOut = galv_AutreListe.ButtonOut )
   Then
    Begin
      ShowMessage ( GS_GROUPE_MAUVAIS_BOUTONS );
      Result := True ;
    End ;
End ;

// Cherche un item : Utiliser plutôt le locate du dataset
// as_TexteItem : Item principal ou clé à trouver
// Résultat : numéro de l'item ou -1
{function TDBGroupView.fi_FindItem ( const avar_TexteItem : Variant ; const ab_FirstPlusMinorOption : Byte ) : Integer ;
// Compteur
var li_i , li_j : Integer ;
    lb_Trouve : Boolean ;
Begin
// Rien n'est encore trouvé
  Result := -1 ;
  // Parcourt des items principaux
  for li_i := 0 to Items.Count - 1 do
    Begin
      case ab_FirstPlusMinorOption of
        1 : if not ( Items [ li_i ].StateIndex in [ gi_ImageInsere, gi_ImageSupprime ]) Then
              Exit ;
        2 : if not ( Items [ li_i ].StateIndex in [ gi_ImageInsere, gi_ImageSupprime ]) Then
              Continue ;
      End ;
      lb_Trouve := False ;
      for li_j := 0 to high ( gt_ColonneCle ) do
      // Si on le trouve
        if (     ( gt_ColonneCle [ 0 ]    <= 0    )
             and ( VarCompareValue ( Items [ li_i ].Caption, avar_TexteItem ) = vrEqual ))
        or (     ( gt_ColonneCle [ 0 ]    > 0    )
             and ( VarCompareValue ( Items [ li_i ].SubItems [ gt_ColonneCle [ 0 ] - 1 ], avar_TexteItem ) = vrEqual ))
         Then
          Begin
            // Retourne le compteur
            lb_Trouve := True ;
          End ;
      if lb_Trouve Then
        Begin
          Result := li_i ;
          // C'est fini
          Break ;
        End ;
    End ;
End ;
}
// Affectation du composant dans la propriété ButtonTotalIn
// test si n'existe pas
procedure TDBGroupView.p_SetListeTotal  ( const a_Value: TWinControl );
begin
{$IFNDEF FPC}
  ReferenceInterface ( ButtonTotalIn, opRemove ); // Gestion de la destruction
{$ENDIF}
  // Affectation
  if gBt_ListeTotal <> a_Value then
  begin
    gBt_ListeTotal := a_Value ;
  end;
{$IFNDEF FPC}
  ReferenceInterface ( ButtonTotalIn, opInsert ); // Gestion de la destruction
{$ENDIF}
  fb_ErreurBtnTotalIn ;
end;

// Affectation du composant dans la propriété ButtonIn
// test si n'existe pas
procedure TDBGroupView.p_SetBtnListe  ( const a_Value: TWinControl );
begin
{$IFNDEF FPC}
  ReferenceInterface ( ButtonIn, opRemove ); // Gestion de la destruction
{$ENDIF}
  // Affectation
  if gBt_Liste <> a_Value then
  begin
    gBt_Liste := a_Value ;
  end;
{$IFNDEF FPC}
  ReferenceInterface ( ButtonIn, opInsert ); // Gestion de la destruction
{$ENDIF}
  fb_ErreurBtnIn ;
end;

// Affectation du composant dans la propriété ButtonTotalOut
// test si n'existe pas
procedure TDBGroupView.p_SetAutreTotal  ( const a_Value: TWinControl );
begin
{$IFNDEF FPC}
  ReferenceInterface ( ButtonTotalOut, opRemove ); // Gestion de la destruction
{$ENDIF}
  // Affectation
  if gBt_AutreTotal <> a_Value then
  begin
    gBt_AutreTotal := a_Value ;
  end;
{$IFNDEF FPC}
  ReferenceInterface ( ButtonTotalOut, opInsert ); // Gestion de la destruction
{$ENDIF}
  fb_ErreurBtnTotalOut ;
end;

// Affectation du composant dans la propriété ButtonOut
// test si n'existe pas
procedure TDBGroupView.p_SetBtnAutreListe  ( const a_Value: TWinControl );
begin
{$IFNDEF FPC}
  ReferenceInterface ( ButtonOut, opRemove ); // Gestion de la destruction
{$ENDIF}
  // Affectation
  if gBt_Autre <> a_Value
   then
    begin
      gBt_Autre := a_Value ;
    end;
{$IFNDEF FPC}
  ReferenceInterface ( ButtonOut, opInsert ); // Gestion de la destruction
{$ENDIF}
  fb_ErreurBtnTotalOut ;
end;

procedure TDBGroupView.p_SetBtnPanier  ( const a_Value: TWinControl );
begin
{$IFNDEF FPC}
  ReferenceInterface ( ButtonBasket, opRemove ); // Gestion de la destruction
{$ENDIF}
  // Affectation
  if gBt_Panier <> a_Value
   then
    begin
      gBt_Panier := a_Value ;
    end;
{$IFNDEF FPC}
  ReferenceInterface ( ButtonBasket, opInsert ); // Gestion de la destruction
{$ENDIF}
  if assigned ( gBt_Panier )
  and     ( csDesigning in ComponentState )
  and not ( csLoading   in ComponentState )
   Then
    gb_MontreTout := True ;
end;

// Affectation du composant dans la propriété DataOtherList
// test si n'existe pas
procedure TDBGroupView.p_SetAutreListe  ( const a_Value: TDBGroupView );
begin
{$IFNDEF FPC}
  ReferenceInterface ( DataListOpposite, opRemove ); // Gestion de la destruction
{$ENDIF}
  // Affectation
  if  ( galv_AutreListe <> a_Value )
  // La liste doit ne pas être elle même
  and ( a_Value         <> Self    )
   then
    begin
      galv_AutreListe := a_Value ;
    end;
{$IFNDEF FPC}
  ReferenceInterface ( DataListOpposite, opInsert ); // Gestion de la destruction
{$ENDIF}
  if assigned ( galv_AutreListe )
  and not fb_ErreurBtnTotalOut
  and not fb_ErreurBtnTotalIn
  and not fb_ErreurBtnOut
   Then
    fb_ErreurBtnIn ;
end;

// Affectation du composant dans la propriété ButtonRecord
// test si n'existe pas
procedure TDBGroupView.p_SetEnregistre ( const a_Value: TWinControl );
begin
{$IFNDEF FPC}
  ReferenceInterface ( ButtonRecord, opRemove ); // Gestion de la destruction
{$ENDIF}
  // Affectation
  if gBt_Enregistre <> a_Value
   then
    begin
      gBt_Enregistre := a_Value ;
    end;
{$IFNDEF FPC}
  ReferenceInterface ( ButtonRecord, opInsert ); // Gestion de la destruction
{$ENDIF}
end;

// Affectation du composant dans la propriété ButtonCancel
// test si n'existe pas
procedure TDBGroupView.p_SetAbandonne ( const a_Value: TWinControl );
begin
{$IFNDEF FPC}
  ReferenceInterface ( ButtonCancel, opRemove ); // Gestion de la destruction
{$ENDIF}
  // Affectation
  if gBt_Abandonne <> a_Value
   then
    begin
      gBt_Abandonne := a_Value ;
    end;
{$IFNDEF FPC}
  ReferenceInterface ( ButtonCancel, opInsert ); // Gestion de la destruction
{$ENDIF}
end;
// TRim sur la chaîne à l'affectation de gs_CleGroupe
// a_Value : valeur avec peut-être des espaces
procedure TDBGroupView.p_SetCleGroupe ( const a_Value: String );
begin
  // Affectation
  if gs_CleGroupe <> Trim ( a_Value )
   then
    begin
      gs_CleGroupe := Trim ( a_Value );
    end;
end;
// TRim sur la chaîne à l'affectation de gs_ChampUnite
// a_Value : valeur avec peut-être des espaces
procedure TDBGroupView.p_SetChampUnite ( const a_Value: String );
begin
  // Affectation
  if gs_ChampUnite <> Trim ( a_Value )
   then
    begin
      gs_ChampUnite := Trim ( a_Value ) ;
    end;
end;
// TRim sur la chaîne à l'affectation de gs_ChampGroupe
// a_Value : valeur avec peut-être des espaces
procedure TDBGroupView.p_SetChampGroupe ( const a_Value: String );
begin
  // Affectation
  if gs_ChampGroupe <> Trim ( a_Value )
   then
    begin
      gs_ChampGroupe := Trim ( a_Value );
    end;
end;
// Teste si la valeur de l'image d'insertion est égale à -1
// a_Value : Valeur à tester
procedure TDBGroupView.p_SetImageInsere(const a_Value: Integer);
begin
  if a_Value <> -1
   Then
     gi_ImageInsere := a_Value ;

end;

// Teste si la valeur de l'image de suppression est égale à -1
// a_Value : Valeur à tester
procedure TDBGroupView.p_SetImageSupprime(const a_Value: Integer);
begin
  if a_Value <> -1
   Then
     gi_ImageSupprime := a_Value ;

end;

// TRim sur la chaîne à l'affectation de gs_TableGroupe
// a_Value : valeur avec peut-être des espaces
procedure TDBGroupView.p_SetTableGroupe ( const a_Value: String );
begin
  // Affectation
  if gs_TableGroupe <> Trim ( a_Value )
   then
    begin
      gs_TableGroupe := Trim ( a_Value );
    end;
end;


{ TDBGroupView }

// Création du composant
// acom_owner : Le propriétaire de la liste
constructor TDBGroupView.create ( acom_owner : Tcomponent);

begin
  // héritage de la création
  inherited create ( acom_owner );

  gb_SelfOpen := False ;
  gds_QuerySource := nil ;
  gds_Query1 := nil ;
  gds_Query2 := nil ;
  ds_DatasourceQuery := nil ;
  ds_DataSourceQuery2 := Nil ;
  gsts_SQLCommand := nil ;
  gsts_SQLQuery := nil ;
  gsts_SQLSource := nil ;
{$IFDEF DELPHI_9_UP}
  gwst_SQLCommand := nil ;
  gwst_SQLSource := nil ;
  gwst_SQLQuery := nil ;
{$ENDIF DELPHI_9_UP}
  gstl_CleGroupe     := nil ;
  gstl_ChampGroupe   := nil ;

  gdl_DataLinkOwner := TUltimListViewDatalink.Create ( Self );
  // initialisation
  gb_NoScroll := False ;
  gb_Open     := False ;
//  gb_ToutUneFois := True ;
//  gadoc_maj_groupe  .Mode := cmWrite ;
//  lw_NombrePages            := 0 ;
  gvar_GroupeEnCours        := Null ;
  gb_CaseInSensitive        := True ;
  gb_EstPrincipale           := True ;
  gb_AllLoaded              := False ;
  gb_AllFetched             := True ;
  gb_ListTotal              := False ;
  gb_ListTotalReal          := False ;
//  gb_TrieAsc                := True ;
  gb_Enregistre             := False ;
  gi_ImageInsere            := 1;
  gi_ImageSupprime          := 0;
  // Aide
  ShowHint := True ;
end;

// Destruction du composant
destructor TDBGroupView.destroy;
begin
  // Liste des clés : à libérer
  Finalize ( gstl_KeysListOut  );
  Finalize ( gt_KeyOwners      );
  inherited;
  // Libération du lien de données des groupes
  gdl_DataLinkOwner .Datasource := nil ;
  gdl_DataLinkOwner .Free ;
  gdl_DataLinkOwner := nil ;

  // Libération des listes de champs
  if assigned ( gstl_CleGroupe     ) Then  gstl_CleGroupe    .Free ;
  if assigned ( gstl_ChampGroupe   ) Then  gstl_ChampGroupe  .Free ;
  gstl_CleGroupe   := nil ;
  gstl_ChampGroupe := nil ;
//  gadoc_maj_groupe  est affecté à la liste : pas besoin de le détruire ;
  // Libération des composants utilisés dans les propriétés
end;

{$IFNDEF FPC}
// Suppression des composants détruits
// AComponent : Le composant à détruire
// Operation  : Opération à effectuer : Suppression ou ajout
procedure TDBGroupView.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  // Procédure héritée
  inherited Notification(AComponent, Operation);
   ////////////////////////////////////////////
  // Désaffectation des composants détruits //
 ////////////////////////////////////////////

  if  ( Assigned                   ( DataListOpposite ))
  and ( AComponent.IsImplementorOf ( DataListOpposite ))
   then
    DataListOpposite := nil;

  if  ( Assigned                   ( DataSourceOwner ))
  and ( AComponent.IsImplementorOf ( DataSourceOwner ))
   then
    DataSourceOwner := nil;


  if  ( Assigned                   ( DataSourceQuery2 ))
  and ( AComponent.IsImplementorOf ( DataSourceQuery2 ))
   then
    DataSourceQuery2 := nil;

  if  ( Assigned                   ( DatasourceQuery ))
  and ( AComponent.IsImplementorOf ( DatasourceQuery ))
   then
    DatasourceQuery := nil;

  if  ( Assigned                   ( ButtonTotalIn ))
  and ( AComponent.IsImplementorOf ( ButtonTotalIn ))
   then
    ButtonTotalIn := nil;
  if  ( Assigned                   ( ButtonIn ))
  and ( AComponent.IsImplementorOf ( ButtonIn ))
   then
    ButtonIn := nil;
  if  ( Assigned                   ( ButtonBasket ))
  and ( AComponent.IsImplementorOf ( ButtonBasket ))
   then
    ButtonBasket := nil;
  if  ( Assigned                   ( ButtonTotalOut ))
  and ( AComponent.IsImplementorOf ( ButtonTotalOut ))
   then
    ButtonTotalOut := nil;
  if  ( Assigned                   ( ButtonOut ))
  and ( AComponent.IsImplementorOf ( ButtonOut ))
   then
    ButtonOut := nil;
  if  ( Assigned                   ( ButtonRecord ))
  and ( AComponent.IsImplementorOf ( ButtonRecord ))
   then
    ButtonRecord := nil;
  if  ( Assigned                   ( ButtonCancel ))
  and ( AComponent.IsImplementorOf ( ButtonCancel ))
   then
    ButtonCancel := nil;
end;

{$ENDIF}

// Le groupe a changé : méthode virtuelle
procedure TDBGroupView.DataLinkScrolled;
var lb_LoadList : Boolean ;
begin
  if (csDestroying In ComponentState) Then
    Exit ;
  lb_LoadList := True ;
  if csDesigning in ComponentState Then
    Begin
      P_Reinitialise ;
      Exit ;
    End ;
  if assigned  ( BeforeDataScroll )
  and assigned ( gdl_DataLink.DataSource )
  and assigned ( gdl_DataLink.DataSet ) then
    BeforeDataScroll ( Self, gdl_DataLink.DataSet, lb_LoadList );

  if not lb_LoadList Then
//  or not fb_ParentVisible ( Self ) Then
    Begin
      p_Reinitialise ;
      Exit ;
    End ;
  if not gb_Panier
  and assigned ( gdl_DataLinkOwner.DataSet )
  and gdl_DataLinkOwner.DataSet.IsEmpty Then
    Begin
      p_Reinitialise ;
      p_VerifieModifications ;
      Exit ;
    End ;
  // Panier : il faut enregistrer ou abandonner avant de changer d'enregistrements
 if  gb_Panier
 and gb_NoScroll
 and gb_EstPrincipale
 and assigned ( galv_AutreListe ) Then
 // Y-a-t-il des clés à enregistrer
   Begin
     // La clé de destination n'est plus celle en cours et on a affecté avant
     if gvar_CleDestination <> gdl_DataLinkOwner.DataSet.FieldByName ( gs_CleGroupe ).Value Then
       Begin
         /// message d'Abandon
         MessageDlg ( GS_GROUPE_ABANDON , mtWarning, [mbOK], 0 );
         // retour
         gdl_DataLinkOwner.DataSet.Locate ( gs_CleGroupe, gvar_CleDestination, [] );
         /// Abandon
         Exit ;
       End
      Else
        Begin
         /// Abandon : on est revenu sur la bonne clé
          Exit ;
        End ;
   End ;
 // On remet à jour la liste
 if  not gb_Enregistre
 // Gestion du panier : on ne vide pas le panier
 //and ( //not gb_Panier Or
 //      not assigned ( gdl_DataLinkOwner.DataSet )
 //       or  gb_EstPrincipale )
  Then
   Begin
    if assigned ( galv_AutreListe ) Then
       galv_AutreListe.gb_ListTotalReal := False ;
     Refresh ;
   End ;
  if assigned  ( AfterDataScroll )
  and assigned ( gdl_DataLink.DataSet ) then
    AfterDataScroll ( gdl_DataLink.DataSet );
end;

// Insertion d'un item : appelle fb_InsereEnregistremnts
// Résultat      : A-t-on changé l'état
procedure TDBGroupView.p_UndoRecord;
var lb_VerifieModifs : Boolean ;
Begin
  lb_VerifieModifs := False ;
  // Mise à zéro des boutons
  if assigned ( gBt_Abandonne )
  and gBt_Abandonne .enabled Then
    Begin
      gBt_Abandonne .enabled := False;
      lb_VerifieModifs := True ;
    End ;
  if assigned ( gBT_Optionnel )
  and gBT_Optionnel .enabled Then
    Begin
      gBT_Optionnel .enabled := False;
      lb_VerifieModifs := True ;
    End ;
  if assigned ( gBt_Enregistre )
  and gBt_Enregistre.enabled Then
    Begin
      gBt_Enregistre.enabled := False;
      lb_VerifieModifs := True ;
    End ;
  if lb_VerifieModifs Then
    p_VerifieModifications ;
End ;
// Insertion d'un item : appelle fb_InsereEnregistremnts
// Résultat      : A-t-on changé l'état
function TDBGroupView.fb_RemplitListe:Boolean;
Begin
    // Gestion normale
    if not gb_AllSelect or gb_MontreTout
    or ( gb_Panier and not gb_ListTotal )
     Then
      with gdl_DataLink.DataSet do
      Begin
        // A-t-on changé d'enregistrement
        if ( gvar_GroupeEnCours = null  )
        or not assigned ( gdl_DataLinkOwner.DataSet )
        or ( gvar_GroupeEnCours <> gdl_DataLinkOwner.DataSet.FieldByName ( gs_CleGroupe ).Value )
         Then
          begin
            p_UndoRecord ;
            p_SetButtonsOther ( False );
            // Gestion du tri
            fs_SortDataset ( gdl_DataLink.DataSet );
            // gestion des paramètres d'un query éventuel
            // Par défaut si c'est un query et du'il y a des paramètres
            // Alors Affectation du premier paramètre en tant que paramètre de la clé du groupe
            if assigned ( ge_FilterEvent ) Then
              Begin
                ge_FilterEvent ( gdl_DataLink.DataSet );
              End
            else
              if not fb_OpenParamsQuery
                // Si ce n'est pas un query ou si c'est un query sans paramètre
               Then
                 p_OpenQuery;
              // Assignation du sort
            if Active
            and assigned ( gdl_DataLinkOwner.DataSet ) Then
              Begin
                try
                  gb_SelfOpen := True ;
                   // Si tout a été transféré
                   if  gb_ListTotal
                   and gb_AllSelect
                   and not gb_MontreTout
                    Then
                     Begin
                       // Assignation du sort du query
                       if fb_AssignSort ( ds_DatasourceQuery.DataSet, gsts_ChampsListe [ SortColumn ] ) Then
                         First ;
                     End
                    Else
                      // Sinon assignation au sort du datasource.dataset
                      if fb_AssignSort ( gdl_DataLink.DataSet, gsts_ChampsListe [ SortColumn ] ) Then
                        First ;

                finally
                  gb_SelfOpen := False ;
                End ;
                gvar_GroupeEnCours := gdl_DataLinkOwner.DataSet.FieldByName ( gs_CleGroupe ).Value ;
                gb_AllLoaded := False ;
              End ;
          End
         Else
           //  la liste est en train d'être parcourue
          Begin
            // Aller à l'enregistrement
            if ( gbm_DernierEnregistrement <> '' )
             Then
              Begin
                  // L'enregistrement peut avoir été effacé
                try
                // aller au bookmark
                  Bookmark := gbm_DernierEnregistrement ;
                  // Plus besoin du bookmark
                except
                end ;
              End ;
          End ;
      End ;
      // Gestion tranfert total dans la liste des enregistrements
//       Else
     // Si premier parcourt des enregistrements du tranfert total dans la liste
{        if gb_ToutUneFois
       Then
        Begin
          if assigned ( gBt_Abandonne )
          and gBt_Abandonne .enabled Then
            Begin
              gBt_Abandonne .enabled := False;
              lb_VerifieModifs := True ;
            End ;
          if assigned ( gBt_Enregistre )
          and gBt_Enregistre.enabled Then
            Begin
              gBt_Enregistre.enabled := False;
              lb_VerifieModifs := True ;
            End ;
          if assigned ( gBT_Optionnel )
          and gBT_Optionnel.enabled Then
            Begin
              gBT_Optionnel.enabled := False;
              lb_VerifieModifs := True ;
            End ;
//            gb_AllLoaded     := False ; // Rien n'est chargé et il faut charger des enregistrements
//            gbm_DernierEnregistrement := '';  // mise à nil du bookm
          // tri

//            fb_PrepareTri ( gi_ColonneTrie )
        End
       else
        Begin                           }
          /// Si pas la première fois alors on va au bookmark du dernier enregistrement non ajouté
//          End ;
//      gb_ToutUneFois   := False ;  /// Plus de premier parcourt
    if gb_EstPrincipale
    and gb_Panier
    and assigned ( gdl_DataLinkOwner.DataSet ) Then
      gvar_CleOrigineEnCours := gdl_DataLinkOwner.DataSet.FieldValues [ gs_CleGroupe ];
        // Si gestion de transfert total dans la liste
    if gb_AllSelect
    and not gb_MontreTout
    and ( not gb_Panier or gb_ListTotal )
      // Ajoute à partir de tous les enregistrements que l'on paut ajouter
     Then
      Begin
        Result := True ;
        if not gb_AllLoaded
        and ( gbm_DernierEnregistrement <> '' )
         Then
          try
          // Aller à l'enregistrement
            ds_DatasourceQuery.DataSet.Bookmark := gbm_DernierEnregistrement ;
          except
          End;
        {$IFDEF EADO}
        if assigned ( gsts_SQLQuery )
        and ( ds_DatasourceQuery.DataSet.State <> dsInactive ) Then
        {$ENDIF}
          fb_RemplitEnregistrements ( ds_DatasourceQuery.DataSet, False )
      End
     // Sinon ajoute à partir du dataset en cours
     Else
      Begin
        if not gb_AllLoaded
        and ( gbm_DernierEnregistrement <> '' )
         Then
          try
          // Aller à l'enregistrement
            gdl_DataLink.DataSet.Bookmark := gbm_DernierEnregistrement ;
          except
          End;
        Result := fb_RemplitEnregistrements ( gdl_DataLink.DataSet, False );
      End ;
  // Si l'état des enregistrements a changé
  if Result
   Then
    Begin
    // On a tout transféré
      if gb_AllSelect
      and not gb_MontreTout
       Then
        Begin
        // Si liste de transfert où il faut tout mettre
        /// Donc la liste sans les clés d'exclusion
          if not ( gb_ListTotal )
           Then
            Begin
              // Activation du bouton de transfert total
              if assigned ( gBt_ListeTotal )
              and Self.Enabled
               Then
                gBt_ListeTotal.Enabled := True ;
            End
           Else
        // Si liste de transfert tout a été transféré
        /// Donc la liste avec les clés d'exclusion
            Begin
              // désactivation du bouton de transfert total
              if assigned ( gBt_ListeTotal )
               Then
                gBt_ListeTotal.Enabled := False ;
            End ;
        End ;
        // Activation des boutons d'enregistrement et d'abandon
       if fb_ValideBoutons Then
         p_DesactiveGrille;
       // Fin de la mise à jour pour enregistrements transférés
    End;   
End ;

// Mise à jour automatique : ajoute des items sur scroll ou quand on l'appelle
procedure TDBGroupView.p_AjouteEnregistrementsSynchrones;
begin
  // propriétés obligatoires à renseigner
  if not assigned ( gdl_DataLinkOwner.DataSet )
  or gb_SelfOpen
  or not assigned ( gdl_DataLinkOwner.DataSet.FindField ( gs_CleGroupe ))
//  or not ( ds_Groupes.DataSet is TCustomADODataset )
   Then
    Exit ;
  inherited ;
  // si il y a un bouton de total
   /// alors si il y a des items
    If Items.Count > 0
      // activation du bouton de transfert
     then
       begin
         p_SetButtonsOther ( True );
       End
     // si il n'y en a pas alors pas d'activation
     else
       Begin
         p_SetButtonsOther ( False );
       End ;
end;

// Peut-on ajouter un item dans la liste ?
// adat_Dataset  : le dataset en cours
function TDBGroupView.fb_PeutAjouter  ( const adat_Dataset : TDataset ; const ab_AjouteItemPlus : Boolean )  : Boolean ;
// Item trouvé ou non
//var
//    li_Trouve : Integer ;
//var ls_Compare : String ;
 var ls_ChampTest : String ;
Begin
  // on peut ajouter par défaut
  Result := True ;
  ls_ChampTest := gs_CleUnite;


  // Si on trouve l'enregistrement de groupe dans la liste d'exclusion
  if not gb_Panier
  and ( fi_findInList ( gstl_KeysListOut, adat_Dataset.FieldValues [ ls_ChampTest ], False ) <> -1 ) Then
     // on continue
    Begin
      Result := False ;
      Exit ;
    End ;
    // si on n'a pas déplacé le total sur la sélection d'origine
    // on si on ajoute des items
  if ab_AjouteItemPlus Then
    Begin
      if ( fi_findInList ( galv_AutreListe.gstl_KeysListOut, adat_Dataset.FieldValues [ ls_ChampTest ], False ) <> -1 ) Then
         // on continue
        Begin
          Result := True ;
          fb_ValideBoutons ;
          Exit ;
        End
      Else
        Begin
          Result := False ;
          Exit ;
        End ;

    End
  Else
    // Gestion panier
    if ( gb_EstPrincipale and gb_Panier ) Then
      Begin
        // Si la clé n'a pas été ajoutée totalement
        if  ( fi_findInListVarBool ( gt_CleOrigine, gvar_CleOrigineEnCours, False, True, [CST_GROUPE_TRANS_SIMPLE] ) <> -1 ) Then
          Begin
            // alors certaines clés ont été ajoutées dans la liste d'exclusion de la liste principale
            if ( fi_findInList        ( gstl_KeysListOut, adat_Dataset.FieldValues [ ls_ChampTest ], False ) <> -1 ) Then
              Begin
                Result := False ;
                Exit ;
              End ;
          End
        // Si la clé a été ajoutée totalement
        else
          if not gb_ListTotal
          and ( fi_findInListVarBool ( gt_CleOrigine, gvar_CleOrigineEnCours, False, True, [CST_GROUPE_TRANS_TOTAL] ) <> -1 ) Then
               // on continue
            Begin
              // alors certaines clés peuvent avoir été enlevées après l'ajout total
              Result := False ;
                  // si la clé est exclue de la liste
              if ( fi_findInList        ( galv_AutreListe.gstl_KeysListOut, adat_Dataset.FieldValues [ ls_ChampTest ], False ) <> -1 ) Then
                // on ne l'ajoute pas
                Begin
                  Result := True ;
                  Exit ;
                End ;
            End ;
      End ;

End ;

// Lorsqu'on déplace tout dans la liste : gestion des états
// adat_Dataset  : le dataset en cours
function TDBGroupView.fb_ChangeEtatItem ( const adat_Dataset : TDataset ; const ab_AjouteItemPlus : Boolean )  : Boolean ;
Begin
  // Par défaut : pas de changement d'état
  Result := False ;
  if trim ( gs_CleUnite ) = ''
   Then
    Exit ;
  // Si gestion de transfert total
//  if gb_AllSelect
//   Then
	if not assigned ( galv_AutreListe )
	or (( gws_RecordValue = '' ) and ( galv_AutreListe.gws_RecordValue = '' )) Then
		Begin
	 // Si est principale
			if gb_EstPrincipale
			 Then
				Begin
					// Si on ne localise pas l'enregistrement en cours dans le dataset d'inclusion
					if ab_AjouteItemPlus Then
						Begin
							if ( gb_CaseInSensitive     and not fb_Locate (  adat_Dataset.FieldValues [ gs_CleUnite ] ))
							or ( not gb_CaseInSensitive and not gdl_DataLink.DataSet.Locate ( gs_CleUnite, adat_Dataset.FieldValues [ gs_CleUnite ], [] ))
							 Then
								Begin
									// C'est qu'il est à insérer
									gVG_ListItem.ImageIndex := gi_ImageInsere ;
//									gVG_ListItem.StateIndex := gi_ImageInsere ;
									Result := True ;
								End ;
						End ;
				End
			 Else
				 // pour changer l'état de l'item en effacement il faut pas de panier
				if not gb_Panier
				and assigned ( gdl_DataLink.Datasource ) then
		 // Si n'est pas principale
					Begin
						// Si on ne localise pas l'enregistrement en cours dans le dataset d'exclusion
						if ab_AjouteItemPlus Then
							Begin
								if ( gb_CaseInSensitive     and not fb_Locate (  adat_Dataset.FieldValues [ gs_CleUnite ] ))
								or ( not gb_CaseInSensitive and not gdl_DataLink.DataSet.Locate ( gs_CleUnite, adat_Dataset.FieldValues [ gs_CleUnite ], [] ))
								 Then
									Begin
										// C'est qu'il est à supprimer
										gVG_ListItem.ImageIndex := gi_ImageSupprime ;
//										gVG_ListItem.StateIndex := gi_ImageSupprime ;
										Result := True ;
									End ;
							End ;
					End ;
		End
	Else
		Begin
			if gws_RecordValue = '' Then
				Begin
					if not adat_Dataset.FieldByName ( gs_ChampGroupe ).IsNull Then
						if gb_EstPrincipale Then
							Begin
								// C'est qu'il est à insérer
								gVG_ListItem.ImageIndex := gi_ImageInsere ;
//								gVG_ListItem.StateIndex := gi_ImageInsere ;
								Result := True ;
							End
						Else
							Begin
								// C'est qu'il est à supprimer
								gVG_ListItem.ImageIndex := gi_ImageSupprime ;
//								gVG_ListItem.StateIndex := gi_ImageSupprime ;
								Result := True ;
							End ;
				End
			else
				Begin
					if fb_ValueToValid ( adat_Dataset.FieldByName ( gs_ChampGroupe )) Then
						if gb_EstPrincipale Then
							Begin
								// C'est qu'il est à insérer
								gVG_ListItem.ImageIndex := gi_ImageInsere ;
//								gVG_ListItem.StateIndex := gi_ImageInsere ;
								Result := True ;
							End
						Else
							Begin
								// C'est qu'il est à supprimer
								gVG_ListItem.ImageIndex := gi_ImageSupprime ;
//								gVG_ListItem.StateIndex := gi_ImageSupprime ;
								Result := True ;
							End ;
				End ;
		End ;
End ;

//////////////////////////////////////////////////////////////////////////////////
// Fonction : fb_IsChangeValue
// Description : La valeur en cours est-elle changée par rapport à la liste
//////////////////////////////////////////////////////////////////////////////////
function TDBGroupView.fb_ValueToValid ( const afie_ChampTest : TField )  : Boolean ;
Begin
  if  ( afie_ChampTest.DataType = ftBoolean ) Then
    Result := ( afie_ChampTest.AsBoolean <> StrToBool ( gws_RecordValue ))
  Else
    if  VarIsNumeric ( afie_ChampTest.AsVariant ) Then
      Result := ( afie_ChampTest.AsFloat <> StrToFloat ( gws_RecordValue ))
    Else
      Result := ( afie_ChampTest.AsString  <> gws_RecordValue )
End ;

// Insère un enregistrement dans la liste : surchargée
// adat_Dataset  : le dataset en cours
// Résultat      : A-t-on changé l'état
function TDBGroupView.fb_RemplitEnregistrements ( const adat_Dataset : TDataset ; const ab_InsereCles : Boolean ) : Boolean;
var lb_CaseInsensitive : Boolean ;
begin
   // Par défaut : pas d'item changé
  Result := False ;
  // PAs de liste associée : on quitte
  if not assigned ( galv_AutreListe )
   Then
    Exit ;
  lb_CaseInsensitive := gb_CaseInSensitive and assigned ( gdl_DataLink.DataSet ) and ( ab_InsereCles or gb_AllSelect ) and ( not assigned ( galv_AutreListe ) or ( gws_RecordValue = '' ) or ( galv_AutreListe.gws_RecordValue = '' ));
  if lb_CaseInSensitive Then
    p_LocateInit;
   // héritage
  try
    Result := inherited fb_RemplitEnregistrements ( adat_Dataset, ab_InsereCles );
  finally
    if lb_CaseInSensitive Then
      p_LocateRestore;
  End ;
End ;
{
function TDBGroupView.fds_GetDatasourceGroupe: TdataSource;
begin
  Result := gdl_DataLink.Datasource ;
end;
}
// récupère le datasource des groupes
function TDBGroupView.fds_GetDatasourceGroupes: TdataSource;
begin
  Result := nil ;
  if assigned ( gdl_DataLinkOwner )
   then
    Result := gdl_DataLinkOwner.DataSource ;
end;

/// Démarre l'ouverture du group view
// Retourne le fait de quitter la procédure principale
function TDBGroupView.fb_BeginOpen:Boolean;
var ls_SQLCommands : String;
begin
 Result := True;
 if gs_TableOwner <> '' Then
 with  ds_DataSourceQuery2.DataSet do
   Begin
     try
       Close ;
       if ((gdl_DataLinkOwner.DataSet.FindField ( gs_CleGroupe ) is TStringField )
       or (gdl_DataLinkOwner.DataSet.FindField ( gs_CleGroupe ) is TMemoField )
       or ( gdl_DataLinkOwner.DataSet.FindField ( gs_CleGroupe ).DataType IN CST_DELPHI_FIELD_STRING )) Then
         begin
           ls_SQLCommands := 'SELECT * FROM ' + gs_TableOwner + ' WHERE ' + gs_CleGroupe + '=''' + fs_stringDbQuote ( gdl_DataLinkOwner.DataSet.FindField ( gs_CleGroupe ).AsString ) + '''' ;
         End
       Else
         ls_SQLCommands := 'SELECT * FROM ' + gs_TableOwner + ' WHERE ' + gs_CleGroupe + '='   +                   gdl_DataLinkOwner.DataSet.FindField ( gs_CleGroupe ).AsString ;
       if Assigned ( gsts_SQLCommand ) then
         Begin
           gsts_SQLCommand.Text := ls_SQLCommands ;
           {$IFDEF DELPHI_9_UP}
         End
        else
         Begin
           gwst_SQLCommand.Text := ls_SQLCommands ;
           {$ENDIF}
         End;
     finally
     End ;
     try
       Open ;
       if IsEmpty Then
       Begin
         if MessageDlg ( GS_METTRE_A_JOUR_FICHE, mtWarning, [mbYes,mbNo], 0) = mrYes Then
            fb_RefreshDataset ( gdl_DataLinkOwner.DataSet, True );
         Result := False;
       End ;
     except
       ShowMessage ( GS_PAS_GROUPES + ' ( ' + gs_TableOwner + ', ' + gs_CleGroupe + ' )'  );
       Result := False;
     End ;
    End;
end;

// Evènement onclick du bouton vide panier
// Sender : obligatoire
procedure TDBGroupView.p_VidePanier ( Sender : TObject );
//var //ls_Compare : String ;
//    li_i       : Integer ;
Begin
  if assigned ( ge_PanierClick ) Then
    ge_PanierClick ( Sender );
  if gb_Panier
   Then
    Begin
      Finalize ( gstl_KeysListOut );
      Finalize ( gt_KeyOwners     );
      Finalize ( gt_CleOrigine    );
//      gb_AllSelect := False ;
      p_Reinitialise ;
      if Assigned ( galv_AutreListe ) Then
        Begin
          Finalize ( galv_AutreListe.gt_CleOrigine    );
          Finalize ( galv_AutreListe.gstl_KeysListOut );
          Finalize ( galv_AutreListe.gt_KeyOwners );
          galv_AutreListe.p_Reinitialise ;
          galv_AutreListe.p_AjouteEnregistrements ;
        End ;
      p_AjouteEnregistrements ;
    End ;
  if assigned ( gBt_Panier )
   Then
    gBt_Panier.Enabled := False ;
End ;
// function TDBGroupView.fb_ExecuteQueryLinkedAllSelectTotal
// execute the query in N-N relationship when different group and owner table

function TDBGroupView.fb_ExecuteQueryNotLinkedNNGroupSourceDifferent : Boolean;
var ls_TexteSQL, ls_SQLCommands : String;
Begin
  Result := False;
  ls_TexteSQL := '';
  // Il faut ajouter les champs avec l'état ajoute si on est sur la liste en dehors du tout
  if( not gb_AllSelect or not gb_ListTotal or gb_MontreTout )
  and  assigned ( galv_AutreListe )
  and fb_TableauVersSQL ( ls_TexteSQL, galv_AutreListe.gstl_KeysListOut, nil, Null ) Then
   with  ds_DataSourceQuery2.DataSet do
     Begin
      ls_SQLCommands := 'INSERT INTO ' + gs_TableGroupe + ' ( ' + gs_ChampGroupe + ', ' + gs_ChampUnite + ' ) ( SELECT ' ;
        // lien groupe
      if ((gdl_DataLinkOwner.DataSet.FindField ( gs_CleGroupe ) is TStringField )
      or (gdl_DataLinkOwner.DataSet.FindField ( gs_CleGroupe ) is TBlobField )
      or ( gdl_DataLinkOwner.DataSet.FindField ( gs_CleGroupe ).DataType IN CST_DELPHI_FIELD_STRING ))
         Then ls_SQLCommands := ls_SQLCommands + ' ''' + gdl_DataLinkOwner.DataSet.FieldByName ( gs_CleGroupe ).AsString + ''','
         Else ls_SQLCommands := ls_SQLCommands + ' '   + gdl_DataLinkOwner.DataSet.FieldByName ( gs_CleGroupe ).AsString +   ',' ;
        // lien unité
        ls_SQLCommands := ls_SQLCommands +  gs_CleUnite + ' FROM ' + gs_TableSource + ' WHERE ' + gs_CleUnite + ' IN ( ' + ls_TexteSQL + ')'
         // Il se peut que quelqu'un ait effacé une unité
    				                    + ' AND NOT EXISTS ( SELECT '  + gs_ChampUnite + ' FROM ' + gs_TableGroupe + ' WHERE ' + gs_TableGroupe + '.' + gs_ChampUnite + '=' + gs_TableSource + '.' + gs_CleUnite
      + ' AND ' + gs_ChampGroupe + '=';
      if ((gdl_DataLinkOwner.DataSet.FindField ( gs_CleGroupe ) is TStringField )
      or (gdl_DataLinkOwner.DataSet.FindField ( gs_CleGroupe ) is TBlobField )
      or ( gdl_DataLinkOwner.DataSet.FindField ( gs_CleGroupe ).DataType IN CST_DELPHI_FIELD_STRING ))
         Then ls_SQLCommands := ls_SQLCommands +  ' ''' + gdl_DataLinkOwner.DataSet.FieldByName ( gs_CleGroupe ).AsString + '''))'
         Else ls_SQLCommands := ls_SQLCommands +  ' '   + gdl_DataLinkOwner.DataSet.FieldByName ( gs_CleGroupe ).AsString +   '))' ;
      p_ExecuteSQLQuery ( ds_DataSourceQuery2.DataSet, ls_SQLCommands );
      Result := True;
    End ;
  // Suppression Autre liste non principale
  if  assigned ( galv_AutreListe )
  and not      ( galv_AutreListe.DataListPrimary )
  and assigned ( galv_AutreListe.Datasource )
  and assigned ( galv_AutreListe.Datasource.DataSet )
  // Il faut supprimer les champs avec l'état supprime si on est sur la liste en dehors du tout
  and ( not gb_AllSelect or not galv_AutreListe.gb_ListTotal or gb_MontreTout )
  and fb_TableauVersSQL ( ls_TexteSQL, gstl_KeysListOut, nil, Null ) Then
    with ds_DataSourceQuery2.DataSet do
      Begin
        ls_SQLCommands := 'DELETE FROM ' + gs_TableGroupe + ' where ' + gs_ChampGroupe + ' =  ' ;
        // lien groupe
        if ((gdl_DataLinkOwner.DataSet.FindField ( gs_CleGroupe ) is TStringField )
        or (gdl_DataLinkOwner.DataSet.FindField ( gs_CleGroupe ) is TBlobField )
        or ( gdl_DataLinkOwner.DataSet.FindField ( gs_CleGroupe ).DataType IN CST_DELPHI_FIELD_STRING ))
         Then ls_SQLCommands := ls_SQLCommands +  ' ''' + gdl_DataLinkOwner.DataSet.FieldByName ( gs_CleGroupe ).AsString + ''''
         Else ls_SQLCommands := ls_SQLCommands +  ' '   + gdl_DataLinkOwner.DataSet.FieldByName ( gs_CleGroupe ).AsString +   '' ;
         ls_SQLCommands := ls_SQLCommands +  ' AND ' + gs_ChampUnite + ' IN (' + ls_TexteSQL + ')' ;
          // lien groupe
        p_ExecuteSQLQuery ( ds_DataSourceQuery2.DataSet, ls_SQLCommands );
        Result := True;
      End ;
End;

// function TDBGroupView.fb_ExecuteQueryLinkedAllSelectTotal
// execute the query in 1-N relationship
function TDBGroupView.fb_ExecuteQuery1N : Boolean;
var ls_TexteSQL, ls_SQLCommands : String;
Begin
  ls_TexteSQL := '';
  with ds_DataSourceQuery2.DataSet do
   Begin
     Result := False;
     // Mise à jour en une seule : la requête se met en place avant les boucles
     if  assigned ( gdl_DataLinkOwner.DataSet.FindField ( gs_ChampGroupe ))
      Then ls_SQLCommands :=  'UPDATE ' + gs_TableOwner  + ' SET '
      Else ls_SQLCommands :=  'UPDATE ' + gs_TableGroupe + ' SET ' ;
     // affecter le lien groupe ( affectation ou groupe )
     if ((gdl_DataLinkOwner.DataSet.FindField ( gs_CleGroupe ) is TStringField )
     or (gdl_DataLinkOwner.DataSet.FindField ( gs_CleGroupe ) is TBlobField )
     or ( gdl_DataLinkOwner.DataSet.FindField ( gs_CleGroupe ).DataType IN CST_DELPHI_FIELD_STRING ))
      Then ls_SQLCommands := ls_SQLCommands +  gs_ChampGroupe + '=''' + VarToStr ( gvar_CleDestination ) + ''''
      Else ls_SQLCommands := ls_SQLCommands +  gs_ChampGroupe + '='   + VarToStr ( gvar_CleDestination )        ;
     if fb_BuildWhereBasket ( Self, ls_TexteSQL, assigned ( galv_AutreListe.gdl_DataLinkOwner.DataSet ), False ) Then
       Begin
         ls_SQLCommands := ls_SQLCommands +  ls_TexteSQL ;
         p_ExecuteSQLQuery ( ds_DataSourceQuery2.DataSet, ls_SQLCommands );
         Result := True;
       End ;
   end;
End;

// function TDBGroupView.fb_ExecuteQueryLinkedAllSelectTotal
// execute the query in N-N relationship when similar group and owner table
function TDBGroupView.fb_ExecuteQueryNotLinkedNNGroupSourceSimilar : Boolean;
var ls_TexteSQL, ls_SQLCommands : String;
Begin
  Result := False;
  ls_TexteSQL := '';
  // Il faut ajouter les champs avec l'état ajoute si on est sur la liste en dehors du tout
  if( not gb_AllSelect or not gb_ListTotal or gb_MontreTout )
  and  assigned ( galv_AutreListe )
  and fb_TableauVersSQL ( ls_TexteSQL, galv_AutreListe.gstl_KeysListOut, nil, Null ) Then
   with ds_DataSourceQuery2.DataSet do
    Begin
      // Propriété DatasourceGroupTable : gs_TableGroupe
      ls_SQLCommands := 'UPDATE ' + gs_TableGroupe + ' SET ' ;
      // lien groupe
      if ((gdl_DataLinkOwner.DataSet.FindField ( gs_CleGroupe ) is TStringField )
      or (gdl_DataLinkOwner.DataSet.FindField ( gs_CleGroupe ) is TBlobField )
      or ( gdl_DataLinkOwner.DataSet.FindField ( gs_CleGroupe ).DataType IN CST_DELPHI_FIELD_STRING ))
       Then ls_SQLCommands := ls_SQLCommands +  gs_ChampGroupe + '=''' + gdl_DataLinkOwner.DataSet.FieldByName ( gs_CleGroupe  ).AsString + ''''
       Else ls_SQLCommands := ls_SQLCommands +  gs_ChampGroupe + '='   + gdl_DataLinkOwner.DataSet.FieldByName ( gs_CleGroupe  ).AsString        ;
      // lien unité
      ls_SQLCommands := ls_SQLCommands +  ' WHERE ' + gs_ChampUnite + ' IN (' + ls_TexteSQL + ')' ;
      p_ExecuteSQLQuery ( ds_DataSourceQuery2.DataSet, ls_SQLCommands );
      Result := True;
    end;

  // Suppression Autre liste non principale
  if  assigned ( galv_AutreListe )
  and not      ( galv_AutreListe.DataListPrimary )
  and assigned ( galv_AutreListe.Datasource )
  and assigned ( galv_AutreListe.Datasource.DataSet )
  // Il faut supprimer les champs avec l'état supprime si on est sur la liste en dehors du tout
  and ( not gb_AllSelect or not galv_AutreListe.gb_ListTotal or gb_MontreTout )
  and fb_TableauVersSQL ( ls_TexteSQL, gstl_KeysListOut, nil, Null ) Then
    with ds_DataSourceQuery2.DataSet do
      begin
        // Propriété DatasourceGroupTable : gs_TableGroupe
        ls_SQLCommands :=  'UPDATE ' + gs_TableGroupe + ' SET ' ;
        // lien groupe à null
        ls_SQLCommands := ls_SQLCommands +  gs_ChampGroupe + ' = NULL'  ;
        // lien unité
        ls_SQLCommands := ls_SQLCommands +  ' WHERE ' + gs_ChampUnite + ' IN (' + ls_TexteSQL + ')' ;
        p_ExecuteSQLQuery ( ds_DataSourceQuery2.DataSet, ls_SQLCommands );
        Result := True;
      end;
End ;

// function TDBGroupView.fb_ExecuteQueryLinkedAllSelectTotal
// execute the query in N-N relationship when different group and owner table and  when is total
function TDBGroupView.fb_ExecuteQueryNotLinkedNNGroupSourceDifferentTotal: boolean;
var ls_TexteSQL, ls_SQLCommands : String;
Begin
  Result := False ;
  ls_TexteSQL := '';
  with ds_DataSourceQuery2.DataSet do
    Begin
      // Propriété DatasourceGroupTable : gs_TableGroupe
      ls_SQLCommands :=  'INSERT INTO ' + gs_TableGroupe + ' ( ' + gs_ChampGroupe + ', ' + gs_ChampUnite + ' ) ' + ' select ' ;
      // lien groupe à insérer globalement
      if ((gdl_DataLinkOwner.DataSet.FindField ( gs_CleGroupe ) is TStringField )
      or (gdl_DataLinkOwner.DataSet.FindField ( gs_CleGroupe ) is TBlobField )
      or ( gdl_DataLinkOwner.DataSet.FindField ( gs_CleGroupe ).DataType IN CST_DELPHI_FIELD_STRING ))
       Then ls_SQLCommands := ls_SQLCommands +  '''' + fs_StringDbQuote ( gdl_DataLinkOwner.DataSet.FieldByName ( gs_CleGroupe  ).AsString  ) + ''''
       Else ls_SQLCommands := ls_SQLCommands +                             gdl_DataLinkOwner.DataSet.FieldByName ( gs_CleGroupe  ).AsString          ;
              // lien des unités à ajouter globalement
      ls_SQLCommands := ls_SQLCommands +  ', ' + gs_CleUnite + ' FROM ' + gs_TableSource
                    // Champ unité déjà dans le grouê
                     + ' WHERE ' + gs_CleUnite + ' NOT IN ( SELECT ' + gs_TableGroupe + '.' + gs_ChampUnite + ' FROM ' + gs_TableSource + ',' + gs_TableGroupe
                     + ' WHERE ' + gs_TableGroupe + '.' + gs_ChampUnite + '=' + gs_TableSource + '.' + gs_CleUnite ;
      if ((gdl_DataLinkOwner.DataSet.FindField ( gs_CleGroupe ) is TStringField )
      or (gdl_DataLinkOwner.DataSet.FindField ( gs_CleGroupe ) is TBlobField )
      or ( gdl_DataLinkOwner.DataSet.FindField ( gs_CleGroupe ).DataType IN CST_DELPHI_FIELD_STRING ))
              // lien groupe déjà dans le groupe
       then ls_SQLCommands := ls_SQLCommands +  ' AND ' + gs_TableGroupe + '.' + gs_ChampGroupe + ' = ''' + fs_stringDbQuote ( gdl_DataLinkOwner.DataSet.FindField ( gs_CleGroupe ).AsString ) + ''')'
       Else ls_SQLCommands := ls_SQLCommands +  ' AND ' + gs_TableGroupe + '.' + gs_ChampGroupe + ' = '   +                    gdl_DataLinkOwner.DataSet.FindField ( gs_CleGroupe ).AsString   +   ')' ;
       // et liste d'exclusion car il y a peut-être eu un transfert dans l'autre sens
      if fb_TableauVersSQL ( ls_TexteSQL, gstl_KeysListOut, gstl_CleGroupe, Null )
       Then
        ls_SQLCommands := ls_SQLCommands +  ' AND ' + gs_TableSource + '.' + gs_CleUnite + ' NOT IN (' + ls_TexteSQL + ')' ;
      // exécution
      ls_SQLCommands := ls_SQLCommands +  fws_GetExistingFilter ;
      p_ExecuteSQLQuery ( ds_DataSourceQuery2.DataSet, ls_SQLCommands );
      Result := True ;

    end;
end;

// function TDBGroupView.fb_ExecuteQueryLinkedAllSelectTotal
// execute the query when shows all
function TDBGroupView.fb_ExecuteQueryShowAllGroup(const astl_KeysListOut:tt_TableauVariant):Boolean;
var ls_TexteSQL, ls_SQLCommands : String;
Begin
  Result := False;
  ls_TexteSQL := '';
  if fb_TableauVersSQL ( ls_TexteSQL, astl_KeysListOut, nil, Null ) Then
   with ds_DataSourceQuery2.DataSet do
    begin
      // Propriété DatasourceGroupTable : gs_TableGroupe
      ls_SQLCommands := 'UPDATE ' + gs_TableGroupe + ' SET ' ;
      // valeur à affecter uniquement
      if gws_RecordValue = ''
       Then
      // lien groupe à null
        ls_SQLCommands := ls_SQLCommands +  gs_ChampGroupe + '=NULL'
       Else
        if ((gdl_DataLink.DataSet.FindField ( gs_ChampGroupe ) is TStringField )
        or (gdl_DataLink.DataSet.FindField ( gs_ChampGroupe ) is TMemoField )
        or ( gdl_DataLink.DataSet.FindField ( gs_ChampGroupe ).DataType IN CST_DELPHI_FIELD_STRING ))
         Then ls_SQLCommands := ls_SQLCommands +  gs_ChampGroupe + '=''' + gws_RecordValue + ''''
         Else ls_SQLCommands := ls_SQLCommands +  gs_ChampGroupe + '='   + gws_RecordValue        ;
      // lien unité
      ls_SQLCommands := ls_SQLCommands +  ' WHERE ' + gs_ChampUnite + ' IN (' + ls_TexteSQL + ')' ;
      p_ExecuteSQLQuery ( ds_DataSourceQuery2.DataSet, ls_SQLCommands );
      Result := True ;
    end;
end;

// function TDBGroupView.fb_ExecuteQueryLinkedAllSelectTotal
// execute the query in N-N relationship when different group and owner table and  when is total out
function TDBGroupView.fb_ExecuteQueryNotLinkedNNGroupSourceDifferentTotalOut: boolean;
var ls_TexteSQL, ls_SQLCommands : String;
Begin
  Result:=False;
  ls_TexteSQL := '';
  if  assigned ( galv_AutreListe )
  and not      ( galv_AutreListe.DataListPrimary )
  and          ( galv_AutreListe.gb_ListTotal    )
   Then
    with ds_DataSourceQuery2.DataSet do
     Begin
      // Propriété DatasourceGroupTable : gs_TableGroupe
      ls_SQLCommands := 'DELETE FROM ' + gs_TableGroupe + ' WHERE ' ;
      // lien groupe à insérer globalement
      if ((gdl_DataLinkOwner.DataSet.FindField ( gs_CleGroupe ) is TStringField )
      or (gdl_DataLinkOwner.DataSet.FindField ( gs_CleGroupe ) is TBlobField )
      or ( gdl_DataLinkOwner.DataSet.FindField ( gs_CleGroupe ).DataType IN CST_DELPHI_FIELD_STRING ))
       Then ls_SQLCommands := ls_SQLCommands +  gs_ChampGroupe + ' =  ''' + fs_stringDbQuote ( gdl_DataLinkOwner.DataSet.FieldByName ( gs_CleGroupe ).AsString ) + ''''
       Else ls_SQLCommands := ls_SQLCommands +  gs_ChampGroupe + ' =  '   + gdl_DataLinkOwner.DataSet.FieldByName ( gs_CleGroupe ).AsString ;
        ///  sauf la liste d'excusion car il y a peut-être eu un transfert vars l'autre liste
        if fb_TableauVersSQL ( ls_TexteSQL, galv_AutreListe.gstl_KeysListOut, gstl_CleGroupe, Null )
         Then
           ls_SQLCommands := ls_SQLCommands +  'and ' + gs_ChampUnite + ' NOT IN (' +  ls_TexteSQL + ')' ;
      //                  Showmessage ( CommandText );
      ls_SQLCommands := ls_SQLCommands +  fws_GetExistingFilter ;
      p_ExecuteSQLQuery ( ds_DataSourceQuery2.DataSet, ls_SQLCommands );
      Result := True ;
     End ;
End;

// function TDBGroupView.fb_ExecuteQueryLinkedAllSelectTotal
// execute the query in N-N relationship when similar group and owner table and  when is total
function TDBGroupView.fb_ExecuteQueryNotLinkedNNGroupSourceSimilarTotal: boolean;
var ls_TexteSQL, ls_SQLCommands : String;
Begin
  Result := False;
  ls_TexteSQL := '';
  with ds_DataSourceQuery2.DataSet do
    Begin
      // Propriété DatasourceGroupTable : gs_TableGroupe
      ls_SQLCommands := 'UPDATE ' + gs_TableGroupe + ' SET ' ;
      // lien groupe à insérer globalement
      if ((gdl_DataLinkOwner.DataSet.FindField ( gs_CleGroupe ) is TStringField )
      or (gdl_DataLinkOwner.DataSet.FindField ( gs_CleGroupe ) is TBlobField )
      or ( gdl_DataLinkOwner.DataSet.FindField ( gs_CleGroupe ).DataType IN CST_DELPHI_FIELD_STRING ))
       Then ls_SQLCommands := ls_SQLCommands +  gs_ChampGroupe + '=''' + fs_stringDbQuote ( gdl_DataLinkOwner.DataSet.FieldByName ( gs_CleGroupe  ).AsString ) + ''''
       Else ls_SQLCommands := ls_SQLCommands +  gs_ChampGroupe + '='   + gdl_DataLinkOwner.DataSet.FieldByName ( gs_CleGroupe  ).AsString         ;
      // Le groupe doit être null
      ls_SQLCommands := ls_SQLCommands +  ' WHERE ' + gs_ChampGroupe + ' IS NULL' ;
      // A garder
               // L'unité doit être hors de liste d'exclusion car transfert possible dans l'autre liste
      if fb_TableauVersSQL ( ls_TexteSQL, gstl_KeysListOut, gstl_CleGroupe, Null )
       Then ls_SQLCommands := ls_SQLCommands +  ' AND ' + gs_ChampUnite + ' NOT IN (' + ls_TexteSQL + ')' ;
      //                  Showmessage ( CommandText );
      ls_SQLCommands := ls_SQLCommands +  fws_GetExistingFilter ;
      p_ExecuteSQLQuery ( ds_DataSourceQuery2.DataSet, ls_SQLCommands );
      Result := True ;
    End
end;
// function TDBGroupView.fb_ExecuteQueryLinkedAllSelectTotal
// execute the query in N-N relationship when similar group and owner table and  when is total out
function TDBGroupView.fb_ExecuteQueryNotLinkedNNGroupSourceSimilarTotalOut: boolean;
var ls_TexteSQL, ls_SQLCommands : String;
Begin
  Result := False;
  ls_TexteSQL := '';
  with ds_DataSourceQuery2.DataSet do
    Begin
    // Propriété DatasourceGroupTable : gs_TableGroupe
      ls_SQLCommands := 'UPDATE ' + gs_TableGroupe + ' SET ' ;
      ls_SQLCommands := ls_SQLCommands +  gs_ChampGroupe + ' = NULL'  ;
      // lien groupe à supprimer
      if ((gdl_DataLinkOwner.DataSet.FindField ( gs_CleGroupe ) is TStringField )
      or (gdl_DataLinkOwner.DataSet.FindField ( gs_CleGroupe ) is TBlobField )
      or ( gdl_DataLinkOwner.DataSet.FindField ( gs_CleGroupe ).DataType IN CST_DELPHI_FIELD_STRING ))
       Then ls_SQLCommands := ls_SQLCommands +  ' WHERE ' + gs_ChampGroupe + '=''' + fs_stringDbQuote ( gdl_DataLinkOwner.DataSet.FieldByName ( gs_CleGroupe  ).AsString ) + ''''
       Else ls_SQLCommands := ls_SQLCommands +  ' WHERE ' + gs_ChampGroupe + '='   + gdl_DataLinkOwner.DataSet.FieldByName ( gs_CleGroupe  ).AsString        ;
      // L'unité doit être hors de liste d'exclusion car transfert possible dans l'autre liste
      if fb_TableauVersSQL ( ls_TexteSQL, galv_AutreListe.gstl_KeysListOut, gstl_CleGroupe, Null )
       Then ls_SQLCommands := ls_SQLCommands +  ' AND ' + gs_ChampUnite + ' NOT IN (' + ls_TexteSQL + ')' ;
      // exécution
      ls_SQLCommands := ls_SQLCommands +  fws_GetExistingFilter ;
      p_ExecuteSQLQuery ( ds_DataSourceQuery2.DataSet, ls_SQLCommands );
      Result := True ;
    end;
End;

// function TDBGroupView.fb_ExecuteQueryLinkedAllSelectTotal
// execute the query when linked to other group view and all selected and is total
function TDBGroupView.fb_ExecuteQueryLinkedAllSelectTotal : boolean;
var ls_TexteSQL, ls_SQLCommands : String;
Begin
  Result := False;
  ls_TexteSQL := '';
  with ds_DataSourceQuery2.DataSet do
   begin
    // Propriété DatasourceGroupTable : gs_TableGroupe
    ls_SQLCommands := 'UPDATE ' + gs_TableGroupe + ' SET ' ;
    // lien groupe à modifier globalement
    if gws_RecordValue = ''
     Then
      // lien groupe à null
      ls_SQLCommands := ls_SQLCommands +  gs_ChampGroupe + '=NULL'
     Else
      if ((gdl_DataLink.DataSet.FindField ( gs_ChampGroupe ) is TStringField )
      or (gdl_DataLink.DataSet.FindField ( gs_ChampGroupe ) is TMemoField )
      or ( gdl_DataLink.DataSet.FindField ( gs_ChampGroupe ).DataType IN CST_DELPHI_FIELD_STRING ))
       Then ls_SQLCommands := ls_SQLCommands +  gs_ChampGroupe + '=''' + gws_RecordValue + ''''
       Else ls_SQLCommands := ls_SQLCommands +  gs_ChampGroupe + '='   + gws_RecordValue        ;
    // Le groupe doit être null
    if galv_AutreListe.gws_RecordValue = ''
     Then
    // lien groupe à null
      ls_SQLCommands := ls_SQLCommands +  ' WHERE ' + gs_ChampGroupe + ' IS NULL'
     Else
      if ((gdl_DataLink.DataSet.FindField ( gs_ChampGroupe ) is TStringField )
      or (gdl_DataLink.DataSet.FindField ( gs_ChampGroupe ) is TMemoField )
      or ( gdl_DataLink.DataSet.FindField ( gs_ChampGroupe ).DataType IN CST_DELPHI_FIELD_STRING ))
       Then ls_SQLCommands := ls_SQLCommands +  ' WHERE ' + gs_ChampGroupe + '=''' + galv_AutreListe.gws_RecordValue + ''''
       Else ls_SQLCommands := ls_SQLCommands +  ' WHERE ' + gs_ChampGroupe + '='   + galv_AutreListe.gws_RecordValue        ;
     // L'unité doit être hors de liste d'exclusion car transfert possible dans l'autre liste
    if fb_TableauVersSQL ( ls_TexteSQL, gstl_KeysListOut, gstl_CleGroupe, Null )
     Then ls_SQLCommands := ls_SQLCommands +  ' AND ' + gs_ChampUnite + ' NOT IN (' + ls_TexteSQL + ')' ;
    //                  Showmessage ( CommandText );
    ls_SQLCommands := ls_SQLCommands +  fws_GetExistingFilter ;
    p_ExecuteSQLQuery ( ds_DataSourceQuery2.DataSet, ls_SQLCommands );
    Result := True ;
  End;
end;
// function TDBGroupView.fb_ExecuteQueryLinkedAllSelect
// execute the query when linked to other group view and all selected
function TDBGroupView.fb_ExecuteQueryLinkedAllSelect : boolean;
var ls_TexteSQL, ls_SQLCommands : String;
Begin
  Result := False;
  ls_TexteSQL := '';
  with ds_DataSourceQuery2.DataSet do
   begin
    // Propriété DatasourceGroupTable : gs_TableGroupe
    ls_SQLCommands := 'UPDATE ' + gs_TableGroupe + ' SET ' ;
      // lien groupe à modifier globalement
    if galv_AutreListe.gws_RecordValue = ''
     Then
    // lien groupe à null
      ls_SQLCommands := ls_SQLCommands +  gs_ChampGroupe + '=NULL'
     Else
      if ((gdl_DataLink.DataSet.FindField ( gs_ChampGroupe ) is TStringField )
      or (gdl_DataLink.DataSet.FindField ( gs_ChampGroupe ) is TMemoField )
      or ( gdl_DataLink.DataSet.FindField ( gs_ChampGroupe ).DataType IN CST_DELPHI_FIELD_STRING ))
       Then ls_SQLCommands := ls_SQLCommands +  gs_ChampGroupe + '=''' + galv_AutreListe.gws_RecordValue + ''''
       Else ls_SQLCommands := ls_SQLCommands +  gs_ChampGroupe + '='   + galv_AutreListe.gws_RecordValue        ;
      // lien groupe des listes à modifier uniquement
    if gws_RecordValue = '' Then
     // lien groupe à null
     ls_SQLCommands := ls_SQLCommands +  ' WHERE ' + gs_ChampGroupe + ' IS NULL'
    Else
    if ((gdl_DataLink.DataSet.FindField ( gs_ChampGroupe ) is TStringField )
    or (gdl_DataLink.DataSet.FindField ( gs_ChampGroupe ) is TMemoField )
    or ( gdl_DataLink.DataSet.FindField ( gs_ChampGroupe ).DataType IN CST_DELPHI_FIELD_STRING ))
     Then ls_SQLCommands := ls_SQLCommands +  ' WHERE ' + gs_ChampGroupe + '=''' + gws_RecordValue + ''''
     Else ls_SQLCommands := ls_SQLCommands +  ' WHERE ' + gs_ChampGroupe + '='   + gws_RecordValue        ;
    if fb_TableauVersSQL ( ls_TexteSQL, galv_AutreListe.gstl_KeysListOut, gstl_CleGroupe, Null )
    Then ls_SQLCommands := ls_SQLCommands +  ' AND ' + gs_ChampUnite + ' NOT IN (' + ls_TexteSQL + ')' ;
    // exécution
     ls_SQLCommands := ls_SQLCommands +  fws_GetExistingFilter ;
    p_ExecuteSQLQuery ( ds_DataSourceQuery2.DataSet, ls_SQLCommands );
    Result := True ;
   end;
End ;
// Evènement enregistre du bouton enregistrer
// Sender : obligatoire
procedure TDBGroupView.p_Enregistre ( Sender : TObject );
var lb_Executee    : Boolean ;
    lda_Action     : TDataAction ;

Begin
  // ancien évènement
  if assigned ( ge_enregistreClick )
   Then
    ge_enregistreClick ( Sender );
   lb_Executee := False ;
/// Variables obligatoires
  if not assigned ( gdl_DataLink.DataSet )
  or not assigned ( gdl_DataLink.DataSet.FindField ( gs_CleUnite  ))
  or not assigned ( ds_DatasourceQuery )
  or not assigned ( ds_DataSourceQuery2 )
  or ( not assigned ( gsts_SQLQuery)
 {$IFDEF DELPHI_9_UP}
  and not assigned ( gwst_SQLQuery)
 {$ENDIF}
 )
  or ( not assigned ( gsts_SQLCommand)
 {$IFDEF DELPHI_9_UP}
  and not assigned ( gwst_SQLCommand)
 {$ENDIF}
 )
  or ( gstl_CleDataSource.Count = 0 )
   Then
    Exit ;

  gb_Enregistre := True ;
  if assigned ( galv_AutreListe )
   Then
    galv_AutreListe.gb_Enregistre := True ;
    // Mise à jour avant validation de la composition du groupe
  try
    p_PostDataSourceOwner;
  finally
    if assigned ( galv_AutreListe )
     Then
      galv_AutreListe.gb_Enregistre := False ;
    gb_Enregistre := False ;
  End ;

  // On a peut-être abandonné l'enregistrement de datasourceOwner
  if  assigned ( gdl_DataLinkOwner.DataSet )
  // Sur edition des groupes
  and (   ( gdl_DataLinkOwner.DataSet.State = dsEdit   )
       or ( gdl_DataLinkOwner.DataSet.State = dsInsert ))
   Then
     // Alors on abandonne
    Exit ;

  try
    if  assigned ( gdl_DataLinkOwner.DataSet )
    and assigned ( gdl_DataLinkOwner.DataSet.FindField ( gs_CleGroupe ))
    and (   not assigned ( galv_AutreListe )
    or (( gws_RecordValue = '' ) and ( galv_AutreListe.gws_RecordValue = '' ))) Then
      /// gestion d'affectation ou gestion de groupe
      Begin
        if not fb_BeginOpen Then
         Exit;

        if not gb_Panier Then
          if ( gs_TableGroupe <> gs_TableSource )
          // Insertion 1N 1N avec les items
           Then
            lb_Executee := fb_ExecuteQueryNotLinkedNNGroupSourceDifferent
           else
            lb_Executee := fb_ExecuteQueryNotLinkedNNGroupSourceSimilar;

        // La gestion par panier a sa propre et unique requête
        if  gb_Panier
        and assigned ( galv_AutreListe ) Then
          fb_ExecuteQuery1N
        Else
          if gb_AllSelect
          and not gb_MontreTout
           Then
            if (  gs_TableGroupe <> gs_TableSource ) Then
            // Gestion 1N 1N avec les exclusions
            Begin
              if gb_ListTotal
               Then
                Begin
                  lb_Executee := fb_ExecuteQueryNotLinkedNNGroupSourceDifferentTotal;
                End
               Else
                 lb_Executee:=fb_ExecuteQueryNotLinkedNNGroupSourceDifferentTotalOut;
            End
           else
        if gb_ListTotal
        and not gb_MontreTout Then
         lb_Executee:=fb_ExecuteQueryNotLinkedNNGroupSourceSimilarTotal
        Else
         Begin
          if  not gb_Panier
          and assigned ( galv_AutreListe )
          and  ( galv_AutreListe.gb_ListTotal )
          Then
            lb_Executee:=fb_ExecuteQueryNotLinkedNNGroupSourceSimilarTotalOut;
        End ;
     End
    Else
    // Pas de Datasourceowner donc mode enregistrement sans possibilité de se déplacer sur les données
    // Donc il faut une valeur à affecter à la place des données du scroll
     Begin
      // Il faut ajouter les champs avec l'état ajoute si on est sur la liste en dehors du tout
      if( not gb_AllSelect or not gb_ListTotal or gb_MontreTout )
       Then
         lb_Executee:= fb_ExecuteQueryShowAllGroup ( gstl_KeysListOut );
      // Suppression Autre liste non principale
      if  not      ( galv_AutreListe.DataListPrimary )
      and assigned ( galv_AutreListe.Datasource )
      and assigned ( galv_AutreListe.Datasource.DataSet )
      // Il faut supprimer les champs avec l'état supprime si on est sur la liste en dehors du tout
      and ( not gb_AllSelect or not galv_AutreListe.gb_ListTotal or gb_MontreTout )
       Then
         lb_Executee:= fb_ExecuteQueryShowAllGroup ( galv_AutreListe.gstl_KeysListOut );

      if gb_AllSelect
      and not gb_MontreTout
       Then
        with ds_DataSourceQuery2.DataSet do
         if gb_ListTotal
          Then
            lb_Executee:=fb_ExecuteQueryLinkedAllSelectTotal
          Else
            if  not gb_Panier
            and  ( galv_AutreListe.gb_ListTotal )
             Then
               lb_Executee:=fb_ExecuteQueryLinkedAllSelect;
    End ;
  Except
    on E: Exception do
     Begin
      if assigned ( ge_enregistreError )
      and ( E is EDataBaseError )
       Then
        Begin
         lda_Action := daFail ;
         ge_enregistreError ( gdl_DataLink.DataSet, ( E as EDataBaseError ), lda_Action );
         if lda_Action = daRetry Then
          p_Enregistre ( Sender );
        End
       Else
        f_GereException( e, ds_DataSourceQuery2.DataSet );
     End ;
  End ;
  // C'est un évènement alors on abandonne car enregistrement effectué
  if assigned ( Self )
   Then
    p_Abandonne ( nil );
  if   lb_Executee
  and assigned ( ge_enregistreEvent )
   Then
    ge_enregistreEvent ( gdl_DataLink.DataSet );
End ;

function fb_BuildWhereBasket ( const aalv_Primary : TDBGroupView ; var as_Result : String ; const ab_GetNull, ab_GetCurrent : Boolean ) : Boolean ;
Begin
  Result := fb_BuildWhereBasket ( aalv_Primary, as_Result, ab_GetNull, ab_GetCurrent, False );
End ;
// Fonction : fb_BuildWhereBasket
// Description : Construction de la clause where du panier
// aalv_Primary : Liste principale
// aws_Result   : La requête si elle existe
// Résultat     : existence de la requête
function fb_BuildWhereBasket ( const aalv_Primary : TDBGroupView ; var as_Result : String ; const ab_GetNull, ab_GetCurrent, ab_order : Boolean ) : Boolean ;
var //lb_PremiereFois ,
    lb_Parentheses  : Boolean ;
    ls_Tri : String ;
    li_i : Integer ;
    ls_TexteSQL : String ;
    lvar_CleItems : Variant ;
    lt_Ins, lt_Outs : fonctions_variant.tt_TableauVariant ;
Begin
  if assigned ( aalv_Primary.ge_BasketGetAll ) Then
    Begin
      Result := aalv_Primary.ge_BasketGetAll ( aalv_Primary, as_Result, ab_GetNull, ab_GetCurrent );
      Exit ;
    End ;
  Finalize ( lt_Ins );
  Finalize ( lt_Outs );
  ls_TexteSQL := '';
  Result := False ;
  as_Result := '' ;
//  lb_PremiereFois := True ;
  with aalv_Primary do
    Begin
      for li_i := 0 to high ( galv_AutreListe.gstl_KeysListOut ) do
        if  ( galv_AutreListe.gstl_KeysListOut [ li_i ] <> Null ) Then
          if ( not gb_EstPrincipale or ( galv_AutreListe.gt_KeyOwners [ li_i ].i_Option <= 1 )) Then
            fi_AjouteListe ( lt_Ins , galv_AutreListe.gstl_KeysListOut [ li_i ], False )
          Else
            fi_AjouteListe ( lt_Outs, galv_AutreListe.gstl_KeysListOut [ li_i ], False );
{      if gb_ListTotal Then
        for li_i := 0 to high ( gstl_KeysListOut ) do
          if  ( gt_KeyOwners [ li_i ].var_Cle <> Null ) Then
            if ( gb_EstPrincipale or ( gt_KeyOwners [ li_i ].i_Option in [CST_GROUPE_TRANS_EXCLU,CST_GROUPE_TRANS_RETOUR] )) Then
              fi_AjouteListe ( lt_Outs , gstl_KeysListOut [ li_i ], False ) ;}
      // Affectation aux clés d'exclusion de l'autre liste
      if fb_TableauVersSQL  ( ls_TexteSQL, lt_Ins, nil, Null )
        Then
          begin
//            lvar_CleItems := galv_AutreListe.gstl_KeysListOut [ li_i ] ;
            // Propriété DatasourceGroupTable : gs_TableGroupe
            // lien unité
            if Result Then
              as_Result := as_Result + ' OR '
            Else
              as_Result := as_Result + ' WHERE ( ' ;
            Result := True ;
//            lb_PremiereFois := False ;
            as_Result := as_Result + gs_ChampUnite + ' IN (' + ls_TexteSQL +')'  ;
          end;
      lb_Parentheses := False ;
      if ab_GetCurrent
      and assigned ( gdl_DataLinkOwner.DataSet )
      and assigned ( gdl_DataLinkOwner.DataSet.FindField ( gs_CleGroupe )) Then
        Begin
          if Result Then
            as_Result := as_Result + ' OR (('
          Else
            as_Result := as_Result + ' WHERE ((( ' ;
          lb_Parentheses := True ;
          Result := True ;
          if ((gdl_DataLinkOwner.DataSet.FindField ( gs_CleGroupe ) is TStringField )
          or (gdl_DataLinkOwner.DataSet.FindField ( gs_CleGroupe ) is TBlobField )
          or ( gdl_DataLinkOwner.DataSet.FindField ( gs_CleGroupe ).DataType IN CST_DELPHI_FIELD_STRING ))
           Then
            as_Result := as_Result + gs_ChampGroupe + ' =''' + gdl_DataLinkOwner.DataSet.FindField ( gs_CleGroupe ).AsString + ''''
          Else
            as_Result := as_Result + gs_ChampGroupe + ' =' + gdl_DataLinkOwner.DataSet.FindField ( gs_CleGroupe ).AsString ;
        End ;
      // mode Affectation : Affectation des groupements entièrement déplacés et des unités d'exclusion
      if gb_ListTotal Then
        for li_i := 0 to high ( gt_CleOrigine ) do
         if ( gt_CleOrigine [ li_i ].i_Option = CST_GROUPE_TRANS_TOTAL )
         and ( gt_CleOrigine [ li_i ].var_Cle <> Null ) Then
           Begin
            lvar_CleItems := gt_CleOrigine [ li_i ].var_Cle ;
            // lien groupe à null
            if Result Then
              Begin
                if lb_Parentheses Then
                  as_Result := as_Result + ' OR '
                Else
                  as_Result := as_Result + ' OR (( ' ;
              End
            Else
              as_Result := as_Result + ' WHERE (((' ;
  //          lb_PremiereFois := False ;
            lb_Parentheses  := True ;
            Result := True ;
            if gb_EstPrincipale Then
              Begin
                if ((gdl_DataLinkOwner.DataSet.FindField ( gs_CleGroupe ) is TStringField )
                or (gdl_DataLinkOwner.DataSet.FindField ( gs_CleGroupe ) is TBlobField )
                or ( gdl_DataLinkOwner.DataSet.FindField ( gs_CleGroupe ).DataType IN CST_DELPHI_FIELD_STRING ))
                 Then as_Result := as_Result + gs_ChampGroupe + '=''' + lvar_CleItems + ''''
                 Else as_Result := as_Result + gs_ChampGroupe + '='   + lvar_CleItems
              End
              Else
                if ((galv_AutreListe.gdl_DataLinkOwner.DataSet.FindField ( galv_AutreListe.gs_CleGroupe ) is TStringField )
                or (galv_AutreListe.gdl_DataLinkOwner.DataSet.FindField ( galv_AutreListe.gs_CleGroupe ) is TBlobField )
                or ( galv_AutreListe.gdl_DataLinkOwner.DataSet.FindField ( galv_AutreListe.gs_CleGroupe ).DataType IN CST_DELPHI_FIELD_STRING ))
                 Then as_Result := as_Result + gs_ChampGroupe + '=''' + lvar_CleItems + ''''
                 Else as_Result := as_Result + gs_ChampGroupe + '='   + lvar_CleItems        ;
           End ;
      if ab_GetNull and (( not gb_EstPrincipale and assigned ( gdl_DataLink.DataSet ))
                        or ( gb_EstPrincipale and assigned ( galv_AutreListe.gdl_DataLink.DataSet ))) Then
        Begin
//          lb_PremiereFois := False ;
          // lien groupe à null
          if Result Then
            Begin
              if lb_Parentheses Then
                as_Result := as_Result + ' OR '
              Else
                as_Result := as_Result + ' OR (( ' ;
            End
          Else
            as_Result := as_Result + ' WHERE (((' ;
//          lb_PremiereFois := False ;
          lb_Parentheses  := True ;
          Result := True ;
          as_Result := as_Result + gs_ChampGroupe + ' IS NULL'  ;
        End ;
      if lb_Parentheses Then
        // Déplacement total effectué au moins une fois alors ...
        // ... Affectation des unités d'exclusion
        Begin
          as_Result := as_Result + ')' ;

          if fb_TableauVersSQL  ( ls_TexteSQL, gstl_KeysListOut, nil, Null ) Then
            as_Result := as_Result + ' AND ' + gs_ChampUnite + ' NOT IN (' + ls_TexteSQL + ')' ;

          if fb_TableauVersSQL  ( ls_TexteSQL, lt_Outs, nil, Null ) Then
            as_Result := as_Result + ' AND ' + gs_ChampUnite + ' NOT IN (' + ls_TexteSQL + ')' ;

          as_Result := as_Result + ')' ;
        End ;
      If Result Then
        as_Result := as_Result + fws_GetExistingFilter + ')' ;
      if ( ab_Order )
      and Result Then
        Begin
          ls_Tri := fs_PrepareTri ;
          if ls_Tri <> '' Then
            as_Result := as_Result + ' ' +  CST_SQL_ORDER_BY + ' ' + fs_PrepareTri ;
        End ;
    End ;
//  showMessage ( as_Result );
End ;

// Evènement abandonne du bouton abandonner
// Sender : obligatoire
Procedure TDBGroupView.p_Abandonne ( Sender : TObject );
  // Si panier : on ne pas tout effacer
var //lb_VerifieModifs ,
    lb_EffaceTout : Boolean ;
    li_Modifie    ,
    li_i          : Integer ;
//    lvar_CleCompare : Variant ;

Begin
  // Par défaut on efface tout
  gb_NoScroll := False ;
  lb_EffaceTout := True ;
  // Ancien évènement
  if assigned ( ge_abandonneClick )
  and assigned ( Sender )
   Then
    ge_abandonneClick ( Sender );
    // Gestion panier : doit-on vraiment abandonner ?
  if  gb_Panier
  and gb_EstPrincipale
  and ( assigned ( Sender ) or ( galv_AutreListe.Items.Count > 0 )) Then
  // Panier non vide
    Begin
      // sinon c'est qu'on a enregistré : on n'efface pas tout
      lb_EffaceTout := False ;
    End ;
   // On peut utiliser le panier : réinitialisation complète
  if lb_EffaceTout Then
    Begin
      Finalize ( gt_CleOrigine );
      //  gstl_KeysListOut : clés du panier
      Finalize ( gstl_KeysListOut );
      Finalize ( gt_KeyOwners     );
    End ;
  // Réinitialise aussi l'autre liste
  if assigned ( galv_AutreListe )
   Then
    Begin
      if lb_EffaceTout
       Then
        Begin
          Finalize ( galv_AutreListe.gt_CleOrigine     );
          Finalize ( galv_AutreListe.gt_KeyOwners      );
          Finalize ( galv_AutreListe.gstl_KeysListOut  );
          galv_AutreListe.p_Reinitialise ;
          // Gestion panier : liste secondaire vide à la réinitialisation
          if not gb_Panier Then
            galv_AutreListe.p_AjouteEnregistrements ;
        End
      // MAJ du 29-9-2004
      else
        if assigned ( Sender ) Then
          Begin
            //Réinitialisation si on n'a pas enregistré
            galv_AutreListe.gb_ListTotal := gb_AllSelect ;
            galv_AutreListe.gb_ListTotalReal := gb_AllSelect ;
            gb_listTotal := False ;
            gb_ListTotalReal := False ;
            galv_AutreListe.gb_AllSelect := gb_AllSelect ;
            gb_AllLoaded := False ;
            galv_AutreListe.gb_AllLoaded := False ;

            // Clés à enlver lorsqu'on a renvoyé des éléments dans le panier et qu'ils sont dans un transfert total
            for li_i := 0 to high ( gstl_KeysListOut ) do
              if  ( gstl_KeysListOut [ li_i ] <> Null )
              and ( fi_findInListVarBool ( gt_CleOrigine, gt_KeyOwners     [ li_i ].var_Cle, False, True, [1] ) <> -1 ) Then
                Begin
                  gstl_KeysListOut [ li_i ] := Null ;
                  gt_KeyOwners     [ li_i ].var_Cle := Null ;
                End ;

            // abandon : on replace les enregistrements à enregistrer dans le panier
            for li_i := 0 to high ( galv_AutreListe.gstl_KeysListOut ) do
              if  ( galv_AutreListe.gstl_KeysListOut [ li_i ] <> Null )
              and ( galv_AutreListe.gt_KeyOwners     [ li_i ].i_Option = CST_GROUPE_TRANS_DESTI  ) Then
                Begin
                  if fi_AjouteListe ( gstl_KeysListOut, galv_AutreListe.gstl_KeysListOut [ li_i ], True  ) <> - 1  Then
                    Begin
                      li_Modifie := fi_AjouteListe  ( gt_KeyOwners     , galv_AutreListe.gt_KeyOwners     [ li_i ].var_Cle, False );
                      gt_KeyOwners [ li_Modifie ].i_Option := CST_GROUPE_TRANS_EXCLU ;
                    End ;
                  galv_AutreListe.gstl_KeysListOut [ li_i ] := Null ;
                  galv_AutreListe.gt_KeyOwners     [ li_i ].var_Cle := Null ;
                End ;

            // Les transferts sont effectués on met à jour le panier
            galv_AutreListe.Refresh ;
            if assigned ( gBt_Panier ) Then
                gBt_Panier.Enabled := Self.Enabled and assigned ( gsts_SQLQuery )
                                                   and ds_DatasourceQuery.DataSet.Active
                                                   and not ds_DatasourceQuery.DataSet.IsEmpty ;
        End
      Else
        Begin
          // rafraichissement après enregistrement : On réinitialise ce qui doit être enregistré
            for li_i := 0 to high ( galv_AutreListe.gstl_KeysListOut ) do
              if  ( galv_AutreListe.gstl_KeysListOut [ li_i ] <> Null )
              and ( galv_AutreListe.gt_KeyOwners      [ li_i ].i_Option = CST_GROUPE_TRANS_DESTI  ) Then
                Begin
                  galv_AutreListe.gstl_KeysListOut [ li_i ] := Null ;
                  galv_AutreListe.gt_KeyOwners     [ li_i ].var_Cle := Null ;
                End ;
          galv_AutreListe.Refresh ;
        End ;
    End ;
  // Réinitialisation sans sauvegarder
  if lb_EffaceTout Then
    p_Reinitialise
  Else
    Begin
      // on efface les items
      p_ReinitialisePasTout ;
//      gb_AllSelect := False ;
      // On va ajouter à nouveau des enregistrements
      gvar_GroupeEnCours := Null ;
      gb_ListTotal := False ;
      gb_ListTotalReal := False ;
    End ;
  // ajoute à nouveau les enregistrements
//  if not gb_Panier Then
  p_AjouteEnregistrements ;
  p_UndoRecord;
  if assigned ( ge_abandonneEvent )
  and assigned ( Sender )
   Then
    ge_abandonneEvent ( gdl_DataLink.DataSet );

End ;

// Réinitialisation : Appelée pour recharger
procedure TDBGroupView.p_Reinitialise ;
Begin
  if  not assigned ( gdl_DataLinkOwner.DataSet )
  and assigned ( gdl_DataLink.DataSet )
  and not gb_Open
  and not ( csDestroying in Componentstate )
    Then
      try
        fb_RefreshDataset ( gdl_DataLink.DataSet, False );
      finally
      End ;
  // héritage de la réinitilisation
  inherited ;
  // Initialisation
  gb_LoadList := False ;
  gvar_GroupeEnCours := Null ;

  if gb_AllSelect
  and not gb_MontreTout
   Then
    Begin
      gb_AllSelect := False ;
      // On a peut-être trié le query dans la liste où tout a été transféré
      if  gb_ListTotal
      and assigned ( gdl_DataLink.Datasource         )
      and assigned ( gdl_DataLink.DataSet )
       Then
         fb_PrepareTri ( SortColumn );
    End ;

  if  gb_Panier
  and gb_EstPrincipale
  and assigned ( galv_AutreListe ) Then
    Begin
      if ( galv_AutreListe.Items.Count = 0 )
      and assigned ( gBt_Panier ) Then
        gBt_Panier.Enabled := False ;
    End ;

  if not gb_Panier Then
    Finalize ( gstl_KeysListOut );
  gb_ListTotalReal := False ;
  gb_ListTotal := False ;
End ;


//////////////////////////////////////////////////////////////////////////////////
// Fonction : fvar_PeutMettrePlus
// Description : Test si on peut mettre un plus à l'enregistrement en affectation
//////////////////////////////////////////////////////////////////////////////////

function TDBGroupView.fvar_PeutMettrePlus ( const aadoq_Dataset, aadoq_Query : TDataset ; const asi_ItemsSelected : TListItem ): Variant ;
var
  ls_CodeCherche : String ;
///  ls_Compare         : String ;
Begin
  Result := Null ;
  if gb_Panier Then
    if ( high ( gt_CleOrigine ) >= 0 ) Then
        try
          if ( gt_ColonneCle [ 0 ] = 0   ) Then
            Begin
              ls_CodeCherche := asi_ItemsSelected.Caption ;
            End
          Else
            Begin
              ls_CodeCherche := asi_ItemsSelected.SubItems [ gt_colonneCle [ 0 ] - 1 ];
            End ;
          if ( aadoq_Dataset.FindField ( gs_CleUnite ).DataType in CST_DELPHI_FIELD_STRING ) Then
            aadoq_Query.Filter := gs_CleUnite + ' = ''' + fs_stringDbQuote ( ls_CodeCherche ) + ''''
          Else
            aadoq_Query.Filter := gs_CleUnite + ' = ' + ls_CodeCherche ;
          if aadoq_Query.RecordCount > 0 Then
            Begin
              Result := aadoq_Query.FieldByName ( gs_ChampGroupe ).Value ;
            End ;
        finally
        End ;
End ;

// Utilisé : On a changé d'état
// Gestion des mises à jour de la clé primaire des groupes
procedure TDBGroupView.EditingChanged;
begin
  inherited ;

  // Et sur le datasource des groupes
  if assigned ( Datasource )
  and assigned ( Datasource.DataSet )
   Then
    Begin
      // On est repassé en consultation des données : rafraichissement de l'enregistrement en cours
       // Si on est passé en insertion ou revenu en consultation
      if     ( Datasource.DataSet.State = dsInsert )
//           or ( Datasource.DataSet.State = dsBrowse ))
       Then
         // Mise A Jour de la liste
        DataLinkScrolled ;

    End ;
end;


// Supprime un item d'un tableau
// at_Liste  : Tableau
// alsi_Item : Item de la liste
function TDBGroupView.fi_SupprimeItem ( var at_List : fonctions_variant.tt_TableauVariant ; const alsi_Item : TListItem ) : Integer ;
// Index à supprimer
Begin
  // On cherche si la colonne clé est affichée
  Result := fi_findList ( at_List, alsi_Item );
  if Result <> -1
   Then
    Begin
     // On efface l'indice
      at_List [ Result ] := Null ;
    End ;
End ;

function TDBGroupView.fi_FindList ( var at_List : fonctions_variant.tt_TableauVariant ; const alsi_Item : TListItem ) : Integer ;
// Index à supprimer
Begin
  // On cherche si la colonne clé est affichée
  if gt_ColonneCle [ 0 ] = 0
    Then Result := fi_findInList ( at_List, alsi_Item.Caption  , False )
    Else Result := fi_findInList ( at_List, alsi_Item.SubItems [ gt_ColonneCle [ 0 ] - 1 ], False );
End ;

// Evènement transférer dans cette liste
// Sender : obligatoire
procedure TDBGroupView.p_ClickTransfert(Sender: TObject);
var
  li_i, li_j , li_Ajoute,
  li_TotalSelection : integer;
  llsi_ItemsSelected : TListItem;

  lits_stateSelected : {$IFDEF FPC}TListItemStates{$ELSE} TItemStates{$ENDIF};

  // pour l'instant ola dévalidation sert au panier
  lb_ValideBoutons   ,
  lb_DeValideBoutons ,
  lb_DesactiveGrille ,
  lb_VerifieModifs   ,
  lb_VarIsString     ,
  lb_Continue        : Boolean ;
  lvar_Ajoute        ,
  lvar_AjouteTempo   : Variant ;
  lws_SQL            : String ;
//  lt_TableauTempo : tt_Tableau ;
begin
  if not assigned ( gBt_Liste )
  or ( not assigned ( gsts_SQLCommand)
 {$IFDEF DELPHI_9_UP}
  and not assigned ( gwst_SQLCommand)
 {$ENDIF}
 )
   Then
    Exit ;
  lb_DesactiveGrille := False ;
  lb_VerifieModifs   := False ;
    // Items sélectionnés
  lits_stateSelected := {$IFDEF FPC}[lisSelected]{$ELSE} [isSelected]{$ENDIF};

  // On n' pas encore trouvé de plus ni de moins pour valider l'enregistrement
  lb_ValideBoutons   := False ;
  lb_DeValideBoutons := False ;

  /// Enregistrement des groupes avant transfert : paut annuler cet évènement
//  p_PostDataSourceOwner;
  // Ne fonctionne qu'en complémentarité
  if not assigned ( galv_AutreListe )
//  or not assigned ( gdl_DataLinkOwner )
//  or not assigned ( gdl_DataLinkOwner.DataSet )
  // Revérification : y-a-t-il maintenant des items sélectionnés
  or ( galv_AutreListe.SelCount = 0 )
   then
    exit;

  lws_SQL := '';

  if gb_Panier Then
    Begin
      if gb_EstPrincipale Then
        Begin
          // Préparation mise à jour des plus et des clés d'origine
          if fb_TableauVersSQL ( lws_SQL, gt_CleOrigine, False, [] ) Then
            with ds_DataSourceQuery2.DataSet  do
              try
                ds_DataSourceQuery2.DataSet.Close ;
                lws_SQL := 'SELECT ' + gs_ChampGroupe + ',' + gs_ChampUnite + ' FROM ' + gs_TableGroupe + ' WHERE ' + gs_ChampGroupe + ' IN (' + lws_SQL + ')' ;
                p_OpenSQLQuery ( ds_DataSourceQuery2.DataSet, lws_SQL );
              Except
                on e: Exception do
                  f_GereException ( e, ds_DataSourceQuery2.DataSet )
              End ;

          lvar_Ajoute    := gdl_DataLinkOwner.DataSet.FieldValues [ gs_CleGroupe ] ;
          lb_VarIsString := ((gdl_DataLinkOwner.DataSet.FindField ( gs_CleGroupe ) is TStringField )
                            or (gdl_DataLinkOwner.DataSet.FindField ( gs_CleGroupe ) is TBlobField )
                            or ( gdl_DataLinkOwner.DataSet.FindField ( gs_CleGroupe ).DataType IN CST_DELPHI_FIELD_STRING ));

          // Mise à jour des clés d'origine
//          if assigned ( lrec_Enregistrements ) Then
            for li_i := 0 to high ( gt_CleOrigine ) do
              if  ( gt_CleOrigine [ li_i ].var_Cle <> Null ) Then
                with ds_DataSourceQuery2.DataSet do
                  Begin
                    if lb_VarIsString Then
                      Filter := gs_ChampGroupe + ' = ''' + fs_stringDbQuote ( VarToStr ( gt_CleOrigine [ li_i ].var_Cle ) ) + ''''
                    Else
                      Filter := gs_ChampGroupe + ' = ' + VarToStr ( gt_CleOrigine [ li_i ].var_Cle );
                    if RecordCount = 0 Then
                      Begin
                        gt_CleOrigine [ li_i ].var_Cle := Null ;
                        galv_AutreListe.gt_CleOrigine [ li_i ].var_Cle := Null ;
                      End ;
                  End ;

        End
      Else
        Begin
          lvar_Ajoute    := galv_AutreListe.gdl_DataLinkOwner.DataSet.FieldValues [ galv_AutreListe.gs_CleGroupe ];
        End ;
      if gb_ListTotal Then
        Begin
          gb_ListTotalReal := fi_findInListVarBool ( gt_CleOrigine, lvar_Ajoute, False, True, [CST_GROUPE_TRANS_TOTAL]) <> -1;
        End ;
      p_AddOriginKey ( lvar_Ajoute );
      // Eff
    End ;

  // Deuxième compteur : pour récupérer l'item suivant
  li_j := galv_AutreListe.Selected.Index;
  // nombre d'éléments à ajouter
  li_TotalSelection := galv_AutreListe.SelCount - 1;
  // Plus rapide avec Items.BeginUpdate et Items.EndUpdate
    // Items sélectionnés
  {$IFDEF FPC}
  BeginUpdate ;
  galv_AutreListe.BeginUpdate ;
  {$ELSE}
  Items.BeginUpdate ;
  galv_AutreListe.Items.BeginUpdate ;
  {$ENDIF}
  llsi_ItemsSelected := galv_AutreListe.Selected;
  try

    for li_i := 0 to li_TotalSelection do
      Begin
        begin
        // Insertion tout en haut
          gVG_ListItem := Items.Insert(0);
          //Transfert
          gVG_ListItem.Caption := llsi_ItemsSelected.Caption;
          gVG_ListItem.SubItems.addStrings ( llsi_ItemsSelected.SubItems );
          lb_Continue := True ;
          if assigned ( galv_AutreListe )
           Then
            if  not gb_Panier or not gb_EstPrincipale  Then
             /// Ajoute dans l'autre liste d'exclusion
              Begin
                  // L'item se trouve soit dans les sous-items soit dans le caption de l'item
                  if  ( gt_ColonneCle [ 0 ] >= llsi_ItemsSelected.SubItems.Count ) Then
                    Begin
                      li_Ajoute := fi_AjouteListe ( galv_AutreListe.gstl_KeysListOut , llsi_ItemsSelected.SubItems [ llsi_ItemsSelected.SubItems.Count - 1 ], True );
                    End
                  Else
                    if gt_ColonneCle [ 0 ] = 0
                     Then
                      Begin
                        li_Ajoute := fi_AjouteListe ( galv_AutreListe.gstl_KeysListOut ,  llsi_ItemsSelected.Caption, True );
                      End
                     Else
                      Begin
                        li_Ajoute := fi_AjouteListe ( galv_AutreListe.gstl_KeysListOut ,  llsi_ItemsSelected.SubItems [ gt_ColonneCle [ 0 ] - 1 ], True );
                      End ;
                if gb_Panier
                and ( li_Ajoute <> -1 ) Then
                  Begin
                    li_Ajoute := fi_AjouteListe ( galv_AutreListe.gT_KeyOwners     ,  gt_CleOrigine [ high ( gt_CleOrigine )].var_Cle, False );
                    galv_AutreListe.gT_KeyOwners [ li_Ajoute ].i_Option := CST_GROUPE_TRANS_EXCLU ;
                  End ;
              End
             Else
             //Gestion type panier
              Begin

                li_Ajoute := -1 ;
                lvar_AjouteTempo := fvar_PeutMettrePlus ( gdl_DataLink.DataSet, ds_DataSourceQuery2.DataSet, llsi_ItemsSelected );
                lb_Continue := ( VarCompareValue ( lvar_AjouteTempo, lvar_Ajoute ) <> vrEqual );
                if lb_Continue or gb_AllSelect Then
                  if  ( gt_ColonneCle [ 0 ] >= llsi_ItemsSelected.SubItems.Count ) Then
                    Begin
                      li_Ajoute := fi_AjouteListe ( galv_AutreListe.gstl_KeysListOut , llsi_ItemsSelected.SubItems [ llsi_ItemsSelected.SubItems.Count - 1 ], True );
                    End
                  Else
                    if gt_ColonneCle [ 0 ] = 0
                     Then
                      Begin
                        li_Ajoute := fi_AjouteListe ( galv_AutreListe.gstl_KeysListOut ,  llsi_ItemsSelected.Caption, True );
                      End
                     Else
                      Begin
                        li_Ajoute := fi_AjouteListe ( galv_AutreListe.gstl_KeysListOut ,  llsi_ItemsSelected.SubItems [ gt_ColonneCle [ 0 ] - 1 ], True );
                      End ;
                if gb_Panier
                and ( li_Ajoute <> - 1 ) Then
                  Begin
                    if lvar_AjouteTempo = Null Then
                      lvar_AjouteTempo := '' ;
                    li_Ajoute := fi_AjouteListe ( galv_AutreListe.gT_KeyOwners, lvar_AjouteTempo, False );
                    if gb_EstPrincipale and lb_Continue Then
                      galv_AutreListe.gT_KeyOwners [ li_Ajoute ].i_Option := CST_GROUPE_TRANS_DESTI
                    Else
                      if gb_EstPrincipale Then
                        galv_AutreListe.gT_KeyOwners [ li_Ajoute ].i_Option := CST_GROUPE_TRANS_RETOUR
                      Else
                        galv_AutreListe.gT_KeyOwners [ li_Ajoute ].i_Option := CST_GROUPE_TRANS_EXCLU ;
                  End ;
              End ;

          li_Ajoute := fi_SupprimeItem ( gstl_KeysListOut, llsi_ItemsSelected );
          lb_DeValideBoutons :=  ( li_Ajoute <> -1 ) or ( gb_Panier and (( gb_EstPrincipale and gb_ListTotal ) or not assigned ( galv_AutreListe ) or ( not gb_EstPrincipale  and galv_AutreListe.gb_ListTotal ))) ;
          if gb_Panier
          and ( li_Ajoute <> -1 ) Then
            Begin
              gt_KeyOwners [ li_Ajoute ].var_Cle := Null ;
            End ;

            // si principale
          if gb_EstPrincipale
           Then
            Begin
            // alors état inséré
              if not gb_Panier
          // Plus tard gérer les clés en les enlevant complètement
              and ( llsi_ItemsSelected.{$IFDEF FPC}ImageIndex{$ELSE}StateIndex{$ENDIF} <> gi_ImageSupprime )
               Then
                 Begin
                   gb_NoScroll := True ;
                   gVG_ListItem.{$IFDEF FPC}ImageIndex{$ELSE}StateIndex{$ENDIF} := gi_ImageInsere ;
                   lb_ValideBoutons        := True ;
                 End
               Else
                Begin
                  if (     gb_Panier
                       and ( lb_Continue )) Then
                    Begin
                      gb_NoScroll := True ;
                      gVG_ListItem.{$IFDEF FPC}ImageIndex{$ELSE}StateIndex{$ENDIF} := gi_ImageInsere ;
                      // On valide les boutons d'enregistrement
                      lb_ValideBoutons := True ;
                    End ;
                End ;
            End
           Else
           // sinon état supprimé
            if not gb_Panier
          // Plus tard gérer les clés en les enlevant complètement
            and ( llsi_ItemsSelected.{$IFDEF FPC}ImageIndex{$ELSE}StateIndex{$ENDIF} <> gi_ImageInsere ) Then
              Begin
                gVG_ListItem.{$IFDEF FPC}ImageIndex{$ELSE}StateIndex{$ENDIF} := gi_ImageSupprime ;
                 // On valide les boutons d'enregistrement
                lb_ValideBoutons := True ;
              End ;
          // Pas d'état insertion ou suppression : on supprime de la liste d'inclusion
          if  not gb_AllSelect
          and ( gVG_ListItem.{$IFDEF FPC}ImageIndex{$ELSE}StateIndex{$ENDIF} = -1 )
          and not gb_Panier Then
            fi_SupprimeItem ( galv_AutreListe.gstl_KeysListOut, llsi_ItemsSelected );

          // Transfert finalisé
          llsi_ItemsSelected.Delete;

          // si on est toujours au bonitem
          if not ( li_i  = li_TotalSelection )
           then
           // On se met dessus
             Begin
              li_j := llsi_ItemsSelected.index ;
              // Prochain item
              llsi_ItemsSelected := galv_AutreListe.GetNextItem ( galv_AutreListe.Items [ li_j ] , lits_stateSelected);
             end
           else
           // Sinon on quitte
            Break;
        end;
      End ;
    // fin de la mise à jour
  finally
    {$IFDEF FPC}
    EndUpdate ;
    galv_AutreListe.EndUpdate ;
    {$ELSE}
    Items.EndUpdate ;
    galv_AutreListe.Items.EndUpdate ;
    {$ENDIF}
    Invalidate ;
    galv_AutreListe.Invalidate ;
  End ;
  Invalidate ;
//  Repaint ;
  // Dévalide les boutons si il faut dévalider
  if lb_DeValideBoutons
  and not lb_ValideBoutons  Then
    if gb_Panier
    and  assigned ( galv_AutreListe ) Then
      Begin
        if  not gb_EstPrincipale Then
          Begin
            // scrute les clés ajoutées une à une
            if not gb_AllSelect or not galv_AutreListe.gb_ListTotal Then
              Begin
              for li_i := high ( gstl_KeysListOut ) downto 0 do
                if  ( gstl_KeysListOut [ li_i ] <> Null )
                and (( gt_KeyOwners [ li_i ].var_Cle = '' ) or ( VarCompareValue ( gt_KeyOwners [ li_i ].var_Cle, galv_AutreListe.gvar_CleDestination ) <> vrEqual ))
                and ( gt_KeyOwners [ li_i ].i_Option = CST_GROUPE_TRANS_DESTI ) Then
                  Begin
                    lb_DeValideBoutons := False ;
                    Break ;
                  End ;
              End
            Else
              Begin
                if galv_AutreListe.Items.Count > 0 Then
                  Begin
                    lb_DeValideBoutons := False ;
                  End
                Else
                  galv_AutreListe.gb_ListTotal := False ;
              End ;
          End
        Else
          if not gb_AllSelect or not gb_ListTotal Then
            Begin
                for li_i := high ( galv_AutreListe.gstl_KeysListOut ) downto 0 do
                  if  ( galv_AutreListe.gstl_KeysListOut [ li_i ] <> Null )
                  // Comparaison de variants
                  and (( galv_AutreListe.gt_KeyOwners [ li_i ].var_Cle = '' ) or ( VarCompareValue ( galv_AutreListe.gt_KeyOwners [ li_i ].var_Cle, gvar_CleDestination ) <> vrEqual ))
                  and ( galv_AutreListe.gt_KeyOwners [ li_i ].i_Option = CST_GROUPE_TRANS_DESTI ) Then
                    Begin
                      lb_DeValideBoutons := False ;
                      Break ;
                    End ;
            End
          Else
            Begin
              if Items.Count > 0 Then
                Begin
                  lb_DeValideBoutons := False ;
                End
              Else
                gb_ListTotal := False ;
            End ;
      End
    Else
      Begin
        // Plus tard gérer les clés en les enlevant complètement
        if gb_AllSelect
        or fb_ListeAffectee (               gstl_KeysListOut )
        or fb_ListeAffectee ( galv_AutreListe.gstl_KeysListOut ) Then
          Begin
            lb_DeValideBoutons := False ;
          End
      End
    Else
      lb_DeValideBoutons := False ;

  if  gb_EstPrincipale
  and gb_AllSelect
  and ( galv_AutreListe.Items.Count = 0 ) Then
    Begin
      if not lb_ValideBoutons
      and ( lb_DeValideBoutons
           or ( assigned ( gBt_Enregistre ) and not gBt_Enregistre.Enabled )
           or ( assigned ( gBT_abandonne ) and not gBT_abandonne.Enabled )
           or ( not  assigned ( gBT_enregistre ) and  not assigned ( gBT_abandonne ) and assigned ( gBT_Optionnel ) and not gBT_Optionnel.Enabled )) Then
        Begin
          Finalize ( gt_CleOrigine );
          Finalize ( gstl_KeysListOut );
          Finalize ( gt_KeyOwners );
          Finalize ( galv_AutreListe.gt_KeyOwners );
          Finalize ( galv_AutreListe.gstl_KeysListOut );
          Finalize ( galv_AutreListe.gt_CleOrigine );
        End
      Else
        for li_i := 0 to high ( gt_CleOrigine ) do
          if gt_CleOrigine [ li_i ].i_Option = 1 Then
            Begin
              gt_CleOrigine [ li_i ].i_Option := 0 ;
              galv_AutreListe.gt_CleOrigine [ li_i ].i_Option := 0 ;
            End ;
      gb_AllSelect := False ;
      gb_ListTotal := False ;
      galv_AutreListe.gb_AllSelect := False ;
      galv_AutreListe.gb_ListTotal := False ;
    End ;

  if lb_DeValideBoutons Then
    Begin
      gb_NoScroll := False ;
      if assigned ( galv_AutreListe ) Then
        galv_AutreListe.gb_NoScroll := False ;
    End ;

  // On peut enregistrer et abandonner ?
  if assigned ( gBT_Optionnel ) Then
    if ( lb_ValideBoutons ) Then
      Begin
        if not gBT_Optionnel.enabled Then
          Begin
            if Self.Enabled Then
              gBT_Optionnel.enabled := True;
            lb_DesactiveGrille       := True ;
          End ;
      End
    Else
      if  lb_DeValideBoutons
      and gBT_Optionnel.enabled Then
          Begin
            gBT_Optionnel.enabled := False;
            lb_VerifieModifs := True ;
          End ;
  if assigned ( gBt_Enregistre ) Then
  // On a un plus ou un moins
    if ( lb_ValideBoutons ) Then
      Begin
        if not gBt_Enregistre.Enabled Then
          Begin
            if Self.Enabled Then
              gBt_Enregistre  .Enabled := True ;
            lb_DesactiveGrille       := True ;
          End ;
      End
    Else
      if  lb_DeValideBoutons
      and gBt_Enregistre.Enabled Then
        Begin
          gBt_Enregistre.Enabled := False ;
          lb_VerifieModifs := True ;
        End ;
  if assigned ( gBt_Abandonne ) Then
  // On a un plus ou un moins
    if ( lb_ValideBoutons ) Then
      Begin
        if not gBt_Abandonne.Enabled Then
          Begin
            if Self.Enabled Then
              gBt_Abandonne.Enabled := True ;
            lb_DesactiveGrille := True ;
          End ;
      End
    Else
      if lb_DeValideBoutons
      and gBt_Abandonne.Enabled Then
        Begin
          gBt_Abandonne.Enabled := False ;
          lb_VerifieModifs := True ;
        End ;
  if assigned ( gBt_AutreTotal )
  and Self.Enabled Then
    gBt_AutreTotal.Enabled := True ;
  // Gestion du bouton panier
  if  gb_Panier Then
  if  not gb_EstPrincipale Then
    Begin
      if ( Items.Count > 0 ) Then
        Begin
          if Self.Enabled Then
           gBt_Panier.Enabled := True ;
        End
       Else
         gBt_Panier.Enabled := False ;
    End
  Else
    Begin
      if ( galv_AutreListe.Items.Count > 0 ) Then
        Begin
          if Self.Enabled Then
           gBt_Panier.Enabled := True ;
        End
       Else
         gBt_Panier.Enabled := False ;
    End ;
  if assigned ( gBt_Liste ) Then
    gBT_Liste.Enabled := False ;
  if ( galv_AutreListe.Items.Count = 0 )
  and assigned ( gBt_ListeTotal ) Then
    gBt_ListeTotal.Enabled := False ;
  if lb_DesactiveGrille Then
    p_DesactiveGrille ;
  if lb_VerifieModifs
   Then
    p_VerifieModifications ;
  // Ancien évènement
  if assigned ( ge_ListeClick )
  and assigned ( Sender )
   Then
    ge_ListeClick ( Sender );

end;
//////////////////////////////////////////////////////////////////////////////////
// Procédure : p_AddOriginKey
// Description : Ajoute une clé d'origine de transfert
// paramètres :
// avar_Ajoute : La clé à ajouter dans la liste des clés d'origine
//////////////////////////////////////////////////////////////////////////////////
procedure TDBGroupView.p_AddOriginKey ( const avar_Ajoute : Variant );
var li_Trouve : Integer ;
    lb_Test : Boolean ;
Begin
  if gb_EstPrincipale Then
    // transfert vers la liste principale
    Begin
      // nouvelle destination : on n'ajoute pas la clé mais on affecte la destination
      gvar_CleDestination := gdl_DataLinkOwner.DataSet.FieldValues [ gs_CleGroupe ];
    End
  Else
    Begin
      // La clé a peut-être été déjà ajoutée
      li_Trouve := fi_findInListVarBool ( gt_CleOrigine, avar_Ajoute, False, False, [] );
      // pas trouvé
      if li_Trouve = -1 Then
        Begin
          // On ajoute
          SetLength ( gt_CleOrigine, high ( gt_CleOrigine ) + 2 );
          SetLength ( galv_AutreListe.gt_CleOrigine, high ( galv_AutreListe.gt_CleOrigine ) + 2 );
          li_Trouve := high ( gt_CleOrigine );
          gt_CleOrigine [ li_Trouve ].var_Cle     := avar_Ajoute ;
          galv_AutreListe.gt_CleOrigine [ li_Trouve ].var_Cle     := avar_Ajoute ;
          lb_Test := gb_ListTotalReal ;
        End
      Else
        // sinon on affectera un transfert total par défaut
        lb_Test := gb_ListTotalReal or ( gt_CleOrigine [ li_Trouve ].i_Option > CST_GROUPE_TRANS_SIMPLE ) ;
      if lb_Test Then
        // transfert total
        Begin
          gt_CleOrigine [ li_Trouve ].i_Option := CST_GROUPE_TRANS_TOTAL ;
          galv_AutreListe.gt_CleOrigine [ li_Trouve ].i_Option := CST_GROUPE_TRANS_TOTAL ;
        End
      Else
        // transfert classique
        Begin
          gt_CleOrigine [ li_Trouve ].i_Option := CST_GROUPE_TRANS_SIMPLE ;
          galv_AutreListe.gt_CleOrigine [ li_Trouve ].i_Option := CST_GROUPE_TRANS_SIMPLE ;
        End ;
    End ;
End ;
// Evènement tout transférer dans cette liste
// Sender : obligatoire
procedure TDBGroupView.p_ClickTransfertTotal(Sender: TObject);
// Tableau pour échange
//var lt_TableauTempo : tt_Tableau ;
var lb_DesactiveGrille : Boolean ;
begin
  lb_DesactiveGrille := False ;

  // Il est possible qu'on ai juste à faire un transfert total item par item
  if  assigned ( galv_AutreListe )
  and assigned ( Sender )
    // On montre tout dans la deux listes : tous les items sont présents
  and (  ( gb_MontreTout  and galv_AutreListe.gb_MontreTout )
    // Gestion panier : une seule liste est à considérer
      or ( gb_Panier and ((( gb_AllLoaded or gb_EstPrincipale )  and galv_AutreListe.gb_AllLoaded ) or ( gb_EstPrincipale and ( fi_findInListVarBool( gt_CleOrigine, Null, False, True, [1]) = -1 )))))
   Then
    Begin
      // sélection de tous les items
      galv_AutreListe.SelectAll ;
      // transfert standard
      p_ClickTransfert ( nil );
      // evènement du bouton
      if assigned ( ge_ListeTotalClick ) Then
        ge_ListeTotalClick ( Sender );
      Exit ;
    End ;
  if  assigned ( galv_AutreListe )
  // Test inutile mais on ne sait jamais
  and  ( galv_AutreListe.Items.Count > 0 )
   Then
    Begin
      // Ajoute tous les enregistrements dans la liste
      p_TransfertTotal ;
        // On vide l'autre liste
      galv_AutreListe.p_VideListeTotal ;
        /// Le transfert de tout dans la liste ne fonctionne qu'avec l'autre liste
      if gb_Panier
      and gB_AllSelect Then
        Begin
          if not gb_EstPrincipale Then
            Begin
              if fb_ListeAffectee ( gstl_KeysListOut )
              or fb_ListeOrigineAffectee ( gt_CleOrigine, True, 1 ) Then
                Begin
                  if assigned ( gbt_Panier ) then
                    Begin
                      if Self.Enabled Then
                       gBt_Panier.Enabled := True ;
                    End
                End ;
            End
          Else
            if  assigned ( galv_AutreListe )
            and (    fb_ListeAffectee        ( galv_AutreListe.gstl_KeysListOut )
                  or fb_ListeOrigineAffectee ( galv_AutreListe.gt_CleOrigine, True, 1 )) Then
                Begin
                  if assigned ( gbt_Panier ) then
                    Begin
                      if Self.Enabled Then
                       gBt_Panier.Enabled := True ;
                    End
                End ;
        End ;
{     if  ( not gb_Panier or gb_EstPrincipale ) Then
       Begin
          // On peut enregistrer et abandonner
          if assigned ( gBt_Enregistre )
          and not gBt_Enregistre.Enabled Then
            Begin
              gBt_Enregistre.Enabled := True ;
              lb_DesactiveGrille := True ;
            End ;
          if assigned ( gBT_Optionnel )
          and not gBT_Optionnel.Enabled Then
            Begin
              gBT_Optionnel.Enabled := True ;
              lb_DesactiveGrille := True ;
            End ;
          if assigned ( gBt_Abandonne )
          and not gBt_Abandonne.Enabled  Then
            Begin
              gBt_Abandonne.Enabled := True ;
              lb_DesactiveGrille := True ;
            End ;
        End ;}
    End ;
  if assigned ( gBt_ListeTotal )
   Then
    gBt_ListeTotal.Enabled := False ;
  if assigned ( gBt_Liste )
   Then
    gBt_Liste.Enabled := False ;
  if lb_DesactiveGrille Then
    p_DesactiveGrille ;
  //  ancien évènement
  if assigned ( ge_ListeTotalClick )
   Then
    ge_ListeTotalClick ( Sender );
end;

// Sur edition des groupes on enregistre
procedure TDBGroupView.p_PostDataSourceOwner;
//var lbkm_GardeLeBonEnregistrement : TBookmark ;
begin
  if  assigned ( gdl_DataLinkOwner )
  and assigned ( gdl_DataLinkOwner.DataSet )
  // Sur edition des groupes
  and (   ( gdl_DataLinkOwner.DataSet.State = dsEdit   )
       or ( gdl_DataLinkOwner.DataSet.State = dsInsert ))
   Then
    Begin
      // on enregistre
      gdl_DataLinkOwner.DataSet.Post ;
    End ;
End ;


// gestion de l'Evènement p_ClickTransfertTotal : tout transférer dans cette liste
procedure TDBGroupView.p_TransfertTotal;
var ls_TexteSQL : String ;
    li_i, li_Modifie : Integer ;
    lvar_Cle : Variant ;
begin
   // Post du datasource des groupes si édition
//  p_PostDataSourceOwner;
  // Réinitialise avant de tout rajouter
  // Pas de reqêteur : on quite
  if not assigned ( gsts_SQLQuery ) Then
    Exit ;

  p_Reinitialise ;


  if gb_Panier
  and assigned ( galv_AutreListe ) Then
    Begin
      gvar_GroupeEnCours := Null ;
      gb_LoadList        := False ;
      if gb_EstPrincipale Then
        lvar_Cle := gdl_DataLinkOwner.DataSet.FieldValues [ gs_CleGroupe ]
      Else
        lvar_Cle := galv_AutreListe.gdl_DataLinkOwner.DataSet.FieldValues [ galv_AutreListe.gs_CleGroupe ];
      if  ( lvar_Cle <> Null ) Then
        for li_i := 0 to high ( galv_AutreListe.gstl_KeysListOut ) do
          if  ( galv_AutreListe.gt_KeyOwners [ li_i ].var_Cle <> Null )
          and ( galv_AutreListe.gt_KeyOwners [ li_i ].var_Cle <> '' )
          and (( VarCompareValue ( galv_AutreListe.gt_KeyOwners [ li_i ].var_Cle, lvar_Cle ) = vrEqual )
                or ( gb_EstPrincipale and ( galv_AutreListe.gt_KeyOwners [ li_i ].i_Option = CST_GROUPE_TRANS_DESTI ))) Then
            Begin
              galv_AutreListe.gstl_KeysListOut [ li_i ] := Null ;
              galv_AutreListe.gt_KeyOwners     [ li_i ].var_Cle := Null ;
            End ;
        for li_i := 0 to high ( gstl_KeysListOut ) do
          if  ( gstl_KeysListOut [ li_i ] <> Null )
          and ( fi_findInListVarBool ( gt_CleOrigine, gt_KeyOwners [ li_i ].var_Cle, False, True, [CST_GROUPE_TRANS_SIMPLE] ) <> -1 ) Then
//          and ( galv_AutreListe.fi_FindItem ( gstl_KeysListOut [ li_i ] ) <> -1  ) Then
            Begin
              if fi_AjouteListe  ( galv_AutreListe.gstl_KeysListOut, gstl_KeysListOut [ li_i ], True ) <> - 1  Then
                Begin
                  li_Modifie := fi_AjouteListe  ( galv_AutreListe.gt_KeyOwners    , gt_KeyOwners [ li_i ].var_Cle, False );
                  if gb_EstPrincipale Then
                    Begin
                      galv_AutreListe.gt_KeyOwners [ li_Modifie ].i_Option := CST_GROUPE_TRANS_DESTI ;
                    End
                  Else
                    galv_AutreListe.gt_KeyOwners [ li_Modifie ].i_Option := CST_GROUPE_TRANS_EXCLU ;
                End ;
              gstl_KeysListOut [ li_i ] := Null ;
              gt_KeyOwners     [ li_i ].var_Cle := Null ;
            End ;
      if gb_EstPrincipale Then
        Begin
          li_Modifie := fi_findInListVarBool ( gt_CleOrigine, lvar_Cle, False, True, [1] );
          if li_Modifie <> -1 Then
            Begin
              gt_CleOrigine [ li_Modifie ].var_Cle := Null ;
              galv_AutreListe.gt_CleOrigine [ li_Modifie ].var_Cle := Null ;
              if  not fb_ListeAffectee ( galv_AutreListe.gstl_KeysListOut )
              and not fb_ListeAffectee ( gstl_KeysListOut ) Then
                Begin
                  Refresh ;
                  Exit ;
                End ;
            End ;
        End
      Else
        Begin
          // on va tout transférer virtuellement dans la liste : pointe sur tous les enregistrements
          gb_AllSelect := True ;

           // Mise à zéro des clés d'exclusion de la liste qui vont peut-être être transférée
          gb_ListTotal := True ;
          gb_ListTotalReal := True ;
          p_AddOriginKey ( lvar_Cle );
        End ;
    End ;
      // fermeture du query
  // on va tout transférer virtuellement dans la liste : pointe sur tous les enregistrements
  gb_AllSelect := True ;

   // Mise à zéro des clés d'exclusion de la liste qui vont peut-être être transférée
  gb_ListTotal := True ;
  gb_ListTotalReal := True ;
  ls_TexteSQL := '';
  ds_DatasourceQuery.DataSet.Close();
  if assigned ( ge_QueryAll ) Then
    ge_QueryAll ( ds_DatasourceQuery.DataSet )
  Else
    if gb_Panier Then
      Begin
        if not gb_EstPrincipale Then
          gb_NoScroll := False ;
        gsts_SQLQuery.BeginUpdate ;
        gsts_SQLQuery.Text := 'SELECT * FROM ' + gs_TableGroupe ;
        if   fb_BuildWhereBasket ( Self, ls_TexteSQL, True, True, True ) Then
          Begin
            gsts_SQLQuery.Add ( ls_TexteSQL );
          End ;
        gsts_SQLQuery.EndUpdate ;
      End
    Else
      if not assigned ( galv_AutreListe )
      or (( gws_RecordValue = '' ) and ( galv_AutreListe.gws_RecordValue = '' )) Then
        Begin
          //Mise à jour du query en fonction des propriétés
          if ( not gb_Panier ) // Si assoce NN
          or ( gs_TableGroupe = '' )
          or ( gs_TableSource   = '' )
           Then
            Begin
              // On sélectionne tous les enregistrements
              gsts_SQLQuery.BeginUpdate ;
              gsts_SQLQuery.Clear ;
              gsts_SQLQuery.Add( 'SELECT * FROM ' + gs_TableSource  );
              gsts_SQLQuery.EndUpdate ;
            End
          Else
           // Sinon on sélectionne les champs de ce groupe et ceux à null
            Begin
              gsts_SQLQuery.BeginUpdate ;
              gsts_SQLQuery.Clear ;
              gsts_SQLQuery.Add( 'SELECT '+ gs_TableSource+CST_FIELD_DECLARE_SEPARATOR +'* FROM ' + gs_TableGroupe + CST_TABLE_SEPARATOR+ gs_TableSource   );
              for li_i := 0 to gstl_ChampGroupe.Count - 1 do
                if li_i = 0 Then
                  gsts_SQLQuery.Add( 'WHERE (' + gs_TableGroupe + CST_FIELD_DECLARE_SEPARATOR + gstl_ChampGroupe [ li_i ] + ' IS NULL'   )
                Else
                  gsts_SQLQuery.Add( 'AND ' + gs_TableGroupe + CST_FIELD_DECLARE_SEPARATOR + gstl_ChampGroupe [ li_i ] + ' IS NULL'   );
              gsts_SQLQuery.Add( ')' );
              if gb_Panier then
                begin
                  if gb_EstPrincipale then
                    if fb_TableauVersSQL ( ls_TexteSQL, galv_AutreListe.gstl_KeysListOut, gstl_CleGroupe, Null )
                     Then gsts_SQLQuery.Add( ' OR ' + gs_TableGroupe + CST_FIELD_DECLARE_SEPARATOR + gs_ChampUnite + ' IN (' + ls_TexteSQL + ')' );
                  gsts_SQLQuery.Add ( ' OR ' );
                  fb_SetMultipleFieldToQuery ( gstl_ChampGroupe, gsts_SQLQuery, gt_CleOrigine, gdl_DataLink.DataSet, True , gs_TableGroupe );
{                  for li_i := 0 to high ( gt_CleOrigine ) do
                    if VarIsStr ( gt_CleOrigine [ li_i ].var_Cle ) Then
                      if ((gdl_DataLinkOwner.DataSet.FindField ( gs_CleGroupe ) is TStringField )
                      or (gdl_DataLinkOwner.DataSet.FindField ( gs_CleGroupe ) is TBlobField )
                      or ( gdl_DataLinkOwner.DataSet.FindField ( gs_CleGroupe ).DataType IN CST_DELPHI_FIELD_STRING ))
                       Then
                        gsts_SQLQuery.Add ( ' OR ' + gs_ChampGroupe + '=''' + fs_stringDbQuote ( gt_CleOrigine [ li_i ].var_Cle ) + '''' )
                      Else
                        gsts_SQLQuery.Add ( ' OR ' + gs_ChampGroupe + '=' + fs_stringDbQuote ( gt_CleOrigine [ li_i ].var_Cle ));}
                End ;
              gsts_SQLQuery.Add( ')' );
              for li_i := 0 to gstl_CleGroupe.Count - 1 do
                if  assigned ( gdl_DataLinkOwner )
                and assigned ( gdl_DataLinkOwner.DataSource )
                and assigned ( gdl_DataLinkOwner.DataSet )
                and assigned ( gdl_DataLinkOwner.DataSet.FindField ( gstl_CleGroupe [ li_i ] ))
                 Then
                  Begin
                   /// Et les groupes à null
                    if li_i = 0 Then
                      gsts_SQLQuery.Add( 'OR (' + gs_TableGroupe + CST_FIELD_DECLARE_SEPARATOR + gstl_ChampGroupe [ li_i ]    )
                    Else
                      gsts_SQLQuery.Add( 'AND ' + gs_TableGroupe + CST_FIELD_DECLARE_SEPARATOR + gstl_ChampGroupe [ li_i ]    );
                    if ((gdl_DataLinkOwner.DataSet.FindField ( gstl_CleGroupe [ li_i ] ) is TStringField )
                    or (gdl_DataLinkOwner.DataSet.FindField ( gstl_CleGroupe [ li_i ] ) is TBlobField )
                    or ( gdl_DataLinkOwner.DataSet.FindField ( gstl_CleGroupe [ li_i ] ).DataType IN CST_DELPHI_FIELD_STRING ))
                     Then gsts_SQLQuery.Add (  '=''' + fs_stringDbQuote ( gdl_DataLinkOwner.DataSet.FieldByName ( gstl_CleGroupe [ li_i ] ).AsString ) + '''' )
                     Else gsts_SQLQuery.Add (  '='   +                  ( gdl_DataLinkOwner.DataSet.FieldByName ( gstl_CleGroupe [ li_i ] ).AsString )        );
                   if li_i = gstl_CleGroupe.Count - 1 Then
                      gsts_SQLQuery.Add( ')' );
                  End  ;
              gsts_SQLQuery.Add ( fws_GetExistingFilter );

              gsts_SQLQuery.EndUpdate ;
            End ;
        End
      Else
        Begin
          // On sélectionne tous les enregistrements
          gsts_SQLQuery.BeginUpdate ;
          gsts_SQLQuery.Clear ;
          gsts_SQLQuery.Add( 'SELECT '+ gs_TableSource+CST_FIELD_DECLARE_SEPARATOR +'* FROM ' + gs_TableGroupe + CST_TABLE_SEPARATOR+ gs_TableSource );
          gsts_SQLQuery.Add ( ' WHERE (' );
          fb_SetMultipleFieldToQuery ( gstl_ChampGroupe, gsts_SQLQuery, gws_RecordValue, gdl_DataLink.DataSet, True , gs_TableGroupe  );
          {
          if ( gws_RecordValue = '' ) Then
            for li_i := 0 to gstl_ChampGroupe.Count - 1 do
              if li_i = 0 Then
                gsts_SQLQuery.Add( 'WHERE ((' + gstl_ChampGroupe [ li_i ] + ' IS NULL'   )
              Else
                gsts_SQLQuery.Add( 'AND ' + gstl_ChampGroupe [ li_i ] + ' IS NULL'   )
          Else
            for li_i := 0 to gstl_ChampGroupe.Count - 1 do
                if ((gdl_DataLink.DataSet.FindField ( gstl_ChampGroupe [ li_i ] ) is TStringField )
                or (gdl_DataLink.DataSet.FindField ( gstl_ChampGroupe [ li_i ] ) is TMemoField )
                or ( gdl_DataLink.DataSet.FindField ( gstl_ChampGroupe [ li_i ] ).DataType IN CST_DELPHI_FIELD_STRING ))
                  Begin
                    if li_i = 0 Then
                      gsts_SQLQuery.Add( ' WHERE ((' + gs_ChampGroupe + '=''' + gws_RecordValue + '''' )
                    Else
                      gsts_SQLQuery.Add ( ' AND ' + gs_ChampGroupe + '=''' + gws_RecordValue + '''' )
                  End
                Else
                  Begin
                    if li_i = 0 Then
                      gsts_SQLQuery.Add( ' WHERE ((' + gs_ChampGroupe + '=' + gws_RecordValue )
                    Else
                      gsts_SQLQuery.Add ( ' AND ' + gs_ChampGroupe + '=' + gws_RecordValue )
                  End ;
          gsts_SQLQuery.Add( ')' );}
          gsts_SQLQuery.Add( 'OR ' ); 
          fb_SetMultipleFieldToQuery ( gstl_ChampGroupe, gsts_SQLQuery, galv_AutreListe.gws_RecordValue, gdl_DataLink.DataSet );
          gsts_SQLQuery.Add( '))' );
          gsts_SQLQuery.Add ( fws_GetExistingFilter );
          gsts_SQLQuery.EndUpdate ;
        End ;
    // Ouverture
  try
    ds_DatasourceQuery.DataSet.Open ;
    gb_AllLoaded := ds_DatasourceQuery.DataSet.IsEmpty ;
    if  gb_AllLoaded Then
      Begin
        gb_ListTotal := False ;
        gb_AllSelect := False ;
        Finalize ( gt_CleOrigine );
        Finalize ( gt_KeyOwners  );
        Finalize ( gstl_KeysListOut );
        Finalize ( galv_AutreListe.gt_CleOrigine );
        Finalize ( galv_AutreListe.gt_KeyOwners  );
        Finalize ( galv_AutreListe.gstl_KeysListOut );
        galv_AutreListe.gb_ListTotal := False ;
        galv_AutreListe.gb_AllSelect := False ;
      End ;
  Except
  End ;
  if not ds_DatasourceQuery.DataSet.Active Then
    Exit ;

    // Ajoute les enregistrements dans la liste
  p_AjouteEnregistrements ;
end;

// gestion de l'Evènement transférer dans l'autre liste
procedure TDBGroupView.p_VideListeTotal;
begin
  // Initialisation
  p_Reinitialise ;
  // On a tout transféré
  gb_AllSelect := True ;

  // On a tout transféré dans l'autre liste
  gb_AllLoaded := True ;
  if gb_Panier
  and gb_EstPrincipale Then
    p_UndoRecord;
end;

// peut-on trier les items ? : Gestion des changements sur la liste avant de trier
// Résultat : Va-t-on quitter l'évènement de tri sur click
// résultat : on peut trier ou pas
function TDBGroupView.fb_PeutTrier  : Boolean ;
Begin
  // par défaut : on peut trier
  Result := True ;
{  Exit ;
  if gb_AllLoaded
  or gb_MontreTout
  or gb_AllSelect
   Then exit ;
  // Si liste d'inclusion
  if gb_EstPrincipale
   Then
    Begin
      // Enregistrer est-il activé
      if assigned ( gBt_Enregistre )
      and gBt_Enregistre.Enabled
       Then
         // Alors il faut demander si on enregistre
         if MessageDlg ( GS_CHANGEMENTS_SAUVER, mtWarning, mbOKcancel, GS_HELP_CHANGEMENTS_SAUVER ) = mrOK
         // Enregistre
          Then p_Enregistre ( Nil )
          // sinon On quitte
          Else Result := False ;
    End
   else
    if assigned ( galv_AutreListe )
    and galv_AutreListe.DataListPrimary
     Then
      Begin
        if assigned ( galv_AutreListe.ButtonRecord )
        and galv_AutreListe.ButtonRecord.Enabled
         Then
         // Alors il faut demander si on enregistre
           if MessageDlg ( GS_CHANGEMENTS_SAUVER, mtWarning, mbOKcancel, GS_HELP_CHANGEMENTS_SAUVER ) = mrOK
         // Enregistre
            Then galv_AutreListe.p_Enregistre ( Nil )
          // sinon On quitte
            Else Result := False ;
      End ;}
End ;

{
function TDBGroupView.CustomDrawItem(alsi_Item: TListItem;
  acds_Etat: TCustomDrawState; acds_Etape: TCustomDrawStage) : Boolean ;
begin
  if gb_CouleursLignes
   Then
    p_groupeCustomDrawItem( Self, alsi_Item );
  Result := inherited CustomDrawItem ( alsi_Item, acds_Etat, acds_Etape );
  if gb_CouleursLignes
   Then
    p_groupeCustomDrawItem( Self, alsi_Item );
end;

procedure TDBGroupView.DrawItem(alsi_Item: TListItem;
  arec_Rectangle : TRect; aods_Etat: TOwnerDrawState) ;
begin

  if gb_CouleursLignes
   Then
    p_groupeCustomDrawItem( Self, alsi_Item );

  inherited DrawItem ( alsi_Item, aRec_Rectangle, aods_Etat );
  if gb_CouleursLignes
   Then
    p_groupeCustomDrawItem( Self, alsi_Item );
end;
}
// Evènement double clicke
// Transfert dans l'autre liste
procedure TDBGroupView.DblClick;
begin
  inherited;
  if ( csDesigning in ComponentState ) Then
    Exit ;
  // Appel du transfert dasn l'autre liste
  if assigned ( galv_AutreListe )
   Then
    galv_AutreListe.p_ClickTransfert ( galv_AutreListe );
end;

// Evènement sur déplacement de liste : méthode dynamique dans tlistview
// valide l'objet déplacé sur la liste
// aobj_Source : objet déplacé sur la liste
// ai_X, ai_Y  : Positions obligatoires
// ads_Etat    : obligatoire
// Résultat :
// ab_Accepte  : Accepte l'objet ou non
procedure TDBGroupView.DragOver(aobj_Source: Tobject; ai_X,
  ai_Y: Integer; ads_Etat: TDragState; var ab_Accepte: Boolean);
begin
  inherited;
  if ( csDesigning in ComponentState ) Then
    Exit ;
  // appel de la fonction de test de mc_fonctions_groupes
  if assigned ( galv_AutreListe )
   Then
    ab_Accepte := ( aobj_Source = galv_AutreListe );
//    p_groupeDragOver ( aobj_Source, ab_Accepte, galv_AutreListe );
end;

// Evènement Drag and drop surchargé
// aobj_Source : la liste à partir d'où on transfert
// ai_X, ai_Y  : Position obligatoire
procedure TDBGroupView.DragDrop(aobj_Source: Tobject; ai_X,
  ai_Y: Integer);
begin
  inherited;
  if ( csDesigning in ComponentState ) Then
    Exit ;
    // Correspond à un transfert simple : onclick du bouton transfert simple
  p_ClickTransfert ( Self );
end;

// Evènement sur clicke: méthode dynamique dans tlistview
// Un item est sélectionné : Mise à jour des boutons
// abt_Bouton : bouton clické obligatoire
// ass_EtatShift : état obligatoire
// ai_x, ai_y    : Position obligatoire
procedure TDBGroupView.MouseDown(abt_Bouton: TMouseButton;
  ass_EtatShift: TShiftState; ai_x, ai_y: Integer);
begin
  inherited;
  if ( csDesigning in ComponentState ) Then
    Exit ;
  // Appel du test de sélection et de mise à jour du bouton
  if assigned ( gBt_Autre )
   Then
    p_groupeMouseDownDisableEnableFleche ( Self, gBt_Autre );
end;

procedure TDBGroupView.KeyUp(var Key: Word; Shift: TShiftState);
begin
  inherited KeyUp(Key, Shift);
  if ( csDesigning in ComponentState ) Then
    Exit ;
  // Appel du transfert dasn l'autre liste
  if assigned ( galv_AutreListe )
  and ( Key in [VK_LEFT, VK_RIGHT ])
   Then
    galv_AutreListe.p_ClickTransfert ( galv_AutreListe );
end;


// Sélection d'un item : méthode statique
// ai_index : Le numéro de l'item sélectionné obligatoire
procedure TDBGroupView.DoSelectItem ( llsi_ItemsSelected : TListItem; ab_selected : Boolean );
begin
   // Héritage
 {$IFNDEF FPC}
  if assigned ( ge_onselectItem ) then
    ge_onselectItem ( Self, llsi_ItemsSelected, ab_selected );
 {$ELSE}
  inherited DoSelectItem ( llsi_ItemsSelected, ab_selected );
 {$ENDIF}
  //  Appel de la procédure de mc_fonctions_groupes
  // active le bouton si il y a des items
  if assigned ( gBt_Autre )
   Then
    p_groupeMouseDownDisableEnableFleche ( Self, gBt_Autre );
end;

//////////////////////////////////////////////////////////////////////////////
// Fonction    : fb_ValideBoutons
// Description : Active les boutons
// Retour      : Boutons activés ou pas
//////////////////////////////////////////////////////////////////////////////
function TDBGroupView.fb_ValideBoutons : Boolean;
begin
  Result := False ;
  if ( gb_EstPrincipale or not gb_Panier ) Then
    Begin
      if assigned ( gBt_Abandonne )
      and not gBt_Abandonne.Enabled
       Then
         Begin
           if Self.Enabled Then
             gBt_Abandonne .enabled := True;
           Result := True ;
         End ;
      if assigned ( gBt_Enregistre )
      and not gBt_Enregistre.Enabled
       Then
         Begin
           if Self.Enabled Then
             gBt_Enregistre.enabled := True;
           Result := True ;
         End ;
      if assigned ( gBT_Optionnel )
      and not gBT_Optionnel.Enabled Then
        Begin
          if Self.Enabled Then
            gBT_Optionnel.Enabled := True ;
          Result := True ;
        End ;
    End
  Else
  if ( not gb_EstPrincipale and gb_Panier and gb_ListTotal ) Then
    Begin
      if assigned ( gBt_Abandonne )
      and not gBt_Abandonne.Enabled
       Then
         Begin
           gBt_Abandonne .enabled := False;
         End ;
      if assigned ( gBt_Enregistre )
      and not gBt_Enregistre.Enabled
       Then
         Begin
           gBt_Enregistre.enabled := False;
         End ;
      if assigned ( gBT_Optionnel )
      and not gBT_Optionnel.Enabled Then
        Begin
          gBT_Optionnel.Enabled := False;
        End ;
    End

end;

// APppelle p_verifieModifications de form dico
procedure TDBGroupView.p_VerifieModifications;
begin
  if Supports(Owner, IFWFormVerify) Then
    ( Owner as IFWFormVerify ).p_VerifieModifications ;
end;
// désactive la grille de u_mcformdico
procedure TDBGroupView.p_DesactiveGrille;
begin
  if Supports(Owner, IFWFormVerify) Then
    ( Owner as IFWFormVerify ).p_DesactiveGrille;
end;

//////////////////////////////////////////////////////////////////////////////
// Procédure   : p_MajBoutons
// Description : Rafraîchissement des boutons
// ai_ItemsAjoutes : Nombre d'éléments ajoutés ( le items.count ne mache pas à tous les moments )
//////////////////////////////////////////////////////////////////////////////
procedure TDBGroupView.p_MajBoutons(const ai_ItemsAjoutes: Integer);
begin
  if assigned ( gBt_AutreTotal )
   Then
    if ai_ItemsAjoutes > 0 Then
      Begin
       if Self.Enabled Then
         gBt_AutreTotal.Enabled := True ;
      End
    Else
     /// alors si il y a des items
      If ( Items.Count > 0 )
      and Self.Enabled Then
        // activation du bouton de transfert
       gBt_AutreTotal.Enabled := True
       // si il n'y en a pas alors pas d'activation
{       else
         Begin
           gBt_AutreTotal.Enabled := False;
           if assigned ( gBt_Autre ) Then
             gBt_Autre.Enabled := False;
         End ;}
end;

// Disable ou enable une flèche en fonction de la liste source
// aLSV_groupe    : La liste source
// abt_item   : Le bouton flèche simple
procedure TDBGroupView.p_groupeMouseDownDisableEnableFleche(
  const aLSV_groupe: TListView; const abt_item: TControl);
begin
  if ( aLSV_groupe.SelCount > 0)
   then
    Begin
      if assigned ( abt_item )
      and Self.Enabled Then
        abt_item.Enabled := True
    End
   else
    if assigned ( abt_item )
     Then
       abt_item.Enabled := False;

end;

//////////////////////////////////////////////////////////////////////////////
// Fonction    : fb_Locate
// Description : Recherche un enregistrement exact à partir de la clé de l'enregistrement
// avar_Records: Les enregistrements de la clé
// ab_InPrimary: Liste principale ou pas
// Retour      : Trouvé ou pas
//////////////////////////////////////////////////////////////////////////////
function TDBGroupView.fb_Locate(
  const avar_Records: Variant ): Boolean;
var ls_Filter : String ;
begin

  if gws_Oldfilter <> '' Then
    ls_Filter := gws_Oldfilter + ' AND '
  Else
    ls_Filter := '' ;
  if gdl_DataLink.DataSet.FieldByName ( gs_CleUnite ).DataType in CST_DELPHI_FIELD_STRING Then
    ls_Filter := ls_Filter + gs_CleUnite + ' = ''' + VarToStr ( avar_Records ) + ''''
  Else
    ls_Filter := ls_Filter + gs_CleUnite + ' = ' + VarToStr ( avar_Records );
  gdl_DataLink.DataSet.Filter := ls_Filter ;
  gdl_DataLink.DataSet.Filtered := True ;
  Result := gdl_DataLink.DataSet.RecordCount > 0 ;
  p_LocateRestore;
end;

//////////////////////////////////////////////////////////////////////////////
// Fonction    : fb_Locate
// Description : Recherche un enregistrement exact à partir de la clé de l'enregistrement
// avar_Records: Les enregistrements de la clé
// ab_InPrimary: Liste principale ou pas
// Retour      : Trouvé ou pas
//////////////////////////////////////////////////////////////////////////////
procedure TDBGroupView.p_LocateInit;
//var ls_Condition,
//    ls_Tables : String ;
begin
  gws_Oldfilter := gdl_DataLink.DataSet.Filter ;
  gb_Oldfiltered := gdl_DataLink.DataSet.Filtered ;
{  ls_Condition := gs_ChampUnite + '=' + gs_ChampUnite + ' AND ' ;
//  if ab_InPrimary Then
    ls_Condition := ls_Condition + gs_ChampGroupe + '=' ;
//  Else
//    ls_Condition := ls_Condition + gs_ChampGroupe + ' NOT LIKE ';
  if gdl_DataLinkOwner.DataSet.FieldByName ( gs_CleGroupe ).DataType in CST_DELPHI_FIELD_STRING Then
    ls_Condition := ls_Condition + '''' + fs_stringDbQuote ( gdl_DataLinkOwner.DataSet.FieldByName ( gs_CleGroupe ).AsString ) + ''''
  Else
    ls_Condition := ls_Condition + gdl_DataLinkOwner.DataSet.FieldByName ( gs_CleGroupe ).AsString ;
  if trim ( gs_TableSource ) <> Trim ( gs_TableGroupe ) Then
    ls_Tables := gs_TableSource + ', ' + gs_TableGroupe
  Else
    ls_Tables := gs_TableSource ;
  fonctions_db.p_LocateInit ( gadoq_QueryLocate, ls_Tables, ls_Condition );}
end;

//////////////////////////////////////////////////////////////////////////////
// Fonction    : fb_Locate
// Description : Recherche un enregistrement exact à partir de la clé de l'enregistrement
// avar_Records: Les enregistrements de la clé
// ab_InPrimary: Liste principale ou pas
// Retour      : Trouvé ou pas
//////////////////////////////////////////////////////////////////////////////
procedure TDBGroupView.p_LocateRestore;
var lbkm_Bookmark : TBookmarkStr ;
//    ls_Tables : String ;
begin
  lbkm_Bookmark := gdl_DataLink.DataSet.Bookmark ;
  gdl_DataLink.DataSet.Filter := gws_Oldfilter ;
  gdl_DataLink.DataSet.Filtered := gb_Oldfiltered ;
  try
    gdl_DataLink.DataSet.Bookmark := lbkm_Bookmark ;
  Except
  End ;
{  ls_Condition := gs_ChampUnite + '=' + gs_ChampUnite + ' AND ' ;
//  if ab_InPrimary Then
    ls_Condition := ls_Condition + gs_ChampGroupe + '=' ;
//  Else
//    ls_Condition := ls_Condition + gs_ChampGroupe + ' NOT LIKE ';
  if gdl_DataLinkOwner.DataSet.FieldByName ( gs_CleGroupe ).DataType in CST_DELPHI_FIELD_STRING Then
    ls_Condition := ls_Condition + '''' + fs_stringDbQuote ( gdl_DataLinkOwner.DataSet.FieldByName ( gs_CleGroupe ).AsString ) + ''''
  Else
    ls_Condition := ls_Condition + gdl_DataLinkOwner.DataSet.FieldByName ( gs_CleGroupe ).AsString ;
  if trim ( gs_TableSource ) <> Trim ( gs_TableGroupe ) Then
    ls_Tables := gs_TableSource + ', ' + gs_TableGroupe
  Else
    ls_Tables := gs_TableSource ;
  mc_fonctions_db.p_LocateInit ( gadoq_QueryLocate, ls_Tables, ls_Condition );}
end;

// Evènement inversion de listes
// Sender : obligatoire
procedure TDBGroupView.p_InvertClick(Sender: TObject);
var lt_Tempo : fonctions_variant.tt_TableauVariant ;
    li_i     : Integer ;
    lb_Tempo : Boolean;
begin

  // Transfert tout
  SelectAll;
  Finalize ( lt_Tempo );
  if assigned ( galv_AutreListe ) Then
    galv_AutreListe.SelectAll;
  if (SelCount > 0) then
    p_ClickTransfert ( Self );

  // Inversion des tableaux
  for li_i := 0 to high ( gstl_KeysListOut ) do
    if gstl_KeysListOut [ li_i ] <> Null Then
      fi_AjouteListe( lt_Tempo, gstl_KeysListOut [ li_i ], False );

  Finalize ( gstl_KeysListOut );

  // Inversion des propriétés
  if assigned ( galv_AutreListe ) Then
    Begin
      lb_Tempo := galv_AutreListe.gb_AllLoaded ;
      galv_AutreListe.gb_AllLoaded := gb_AllLoaded ;
      gb_AllLoaded := lb_tempo ;
      lb_Tempo := galv_AutreListe.gb_AllFetched ;
      galv_AutreListe.gb_AllFetched := gb_AllFetched ;
      gb_AllFetched := lb_tempo ;
      lb_Tempo := galv_AutreListe.gb_AllSelect ;
      galv_AutreListe.gb_AllSelect := gb_AllSelect ;
      gb_AllSelect := lb_tempo ;
      if (galv_AutreListe.SelCount > 0) then
        galv_AutreListe.p_ClickTransfert ( Self );

      // Inversion des tableaux

      for li_i := 0 to high ( galv_AutreListe.gstl_KeysListOut ) do
        fi_AjouteListe( gstl_KeysListOut, galv_AutreListe.gstl_KeysListOut [ li_i ], False );
      Finalize ( galv_AutreListe.gstl_KeysListOut );
      for li_i := 0 to high ( lt_Tempo ) do
        fi_AjouteListe( galv_AutreListe.gstl_KeysListOut, lt_Tempo [ li_i ], False );
    End ;

  // Inversion des tableaux
  Finalize ( lt_Tempo );

  for li_i := 0 to high ( gt_KeyOwners ) do
    if gt_KeyOwners [ li_i ].var_Cle <> Null Then
      fi_AjouteListe( lt_Tempo, gt_KeyOwners [ li_i ].var_Cle, False );

  Finalize ( gt_KeyOwners );

  // Inversion des tableaux
  if assigned ( galv_AutreListe ) Then
    Begin
      for li_i := 0 to high ( galv_AutreListe.gt_KeyOwners ) do
        fi_AjouteListe( gt_KeyOwners, galv_AutreListe.gt_KeyOwners [ li_i ].var_Cle, False );
      Finalize ( galv_AutreListe.gt_KeyOwners );
      for li_i := 0 to high ( lt_Tempo ) do
        fi_AjouteListe( galv_AutreListe.gt_KeyOwners, lt_Tempo [ li_i ], False );
    End ;

  if assigned ( ge_BtnInvertClick ) Then
    ge_BtnInvertClick ( Sender );

end;

// Réinitialisation : Appelée pour recharger au tri
procedure TDBGroupView.p_ReinitialisePasTout ;
Begin
  // héritage de la réinitilisation
  gb_LoadList := False ;
  inherited ;
  p_SetButtonsOther ( False )
End ;

// Réinitialisation : Appelée pour recharger au tri
procedure TDBGroupView.p_SetButtonsOther ( const ab_Value : Boolean );
Begin
  // héritage de la réinitilisation
  if assigned ( gBT_AutreTotal ) Then
    Begin
      gBT_AutreTotal.Enabled := ab_value ;
    End ;

  if assigned ( gBT_Autre ) Then
    Begin
      gBT_Autre.Enabled := ab_value ;
    End ;
End ;

//////////////////////////////////////////////////////////////////////////////
// Fonction    : fws_GetExistingFilter
// Description : Renvoi un filtre SQL si les propriétés DBAllFilter et DBAllFiltered sont renseignés
// Retour      : Le filtre avec le and SQL
//////////////////////////////////////////////////////////////////////////////
function TDBGroupView.fws_GetExistingFilter : String ;

Begin
  if ( Trim ( gws_Filter ) = '' )
  or not gb_Filtered Then
    Result := ''
  Else
    Result := ' AND ' + gws_Filter ;
End ;

////////////////////////////////////////////////////////////////////////////
// Procédure   : p_SetFilter
// Description : Affecte DBAllFilter
// Value       : Le filtre à affecter
//////////////////////////////////////////////////////////////////////////////
procedure TDBGroupView.p_SetFilter(Value: String);
begin
  if Value <> gws_Filter Then
    Begin
      gws_Filter := Value ;
      if  gb_Filtered
      and gb_AllSelect
      and ( gws_Filter = '' ) Then
        Refresh ;
    End ;
end;

//////////////////////////////////////////////////////////////////////////////
// Procédure   : p_SetFiltered
// Description : Affecte DBAllFiltered
// Value       : Active ou désactive le filtre
//////////////////////////////////////////////////////////////////////////////
procedure TDBGroupView.p_SetFiltered(Value: Boolean);
begin
  if Value <> gb_Filtered Then
    Begin
      gb_Filtered := Value ;
      if  gb_Filtered
      and gb_AllSelect
      and ( gws_Filter = '' ) Then
        Refresh ;
    End ;

end;

procedure TDBGroupView.Refresh;
var lb_PremiereFois : Boolean ;
    ls_TexteSQL   : String ;
begin
  ls_TexteSQL := '' ;
  if gb_Panier Then
    Begin
      if gb_EstPrincipale Then
        Begin
          gb_ListTotalReal := False ;
          gb_ListTotal     := False ;
          p_ReinitialisePasTout ;
          gvar_GroupeEnCours := Null ;
          gb_LoadList        := False ;
          p_AjouteEnregistrements ;
        End
      Else
        if  assigned ( gsts_SQLQuery ) Then
          Begin
              // MAJ du 13-4-2005
            ds_DatasourceQuery.DataSet.Close ;
            gsts_SQLQuery.BeginUpdate ;
            gsts_SQLQuery.Clear ;
            // Sélectionne notre groupe
            gsts_SQLQuery.Add( 'SELECT * FROM ' + gs_TableSource );
            lb_PremiereFois := True ;
            if fb_BuildWhereBasket ( Self, ls_TexteSQL, True, False, True ) Then
              Begin
                lb_PremiereFois := False ;
                gsts_SQLQuery.Add ( ls_TexteSQL );
              End ;
            gsts_SQLQuery.EndUpdate ;
            if not lb_PremiereFois Then
              Begin
                if not lb_PremiereFois Then
                  Begin
                    ds_DatasourceQuery.DataSet.Open ;
                    p_ReinitialisePasTout ;
                    gb_LoadList        := False ;
                    gvar_GroupeEnCours := Null ;
                    fb_RemplitEnregistrements ( ds_DatasourceQuery.DataSet, False );
                  End ;
              End ;
          End ;
    End
  Else
    Begin
      p_Reinitialise ;
      p_AjouteEnregistrements ;
    End ;
End;

initialization
{$IFDEF FPC}
  {$I U_GroupView.lrs}
{$ENDIF}
{$IFDEF VERSIONS}
  p_ConcatVersion ( gVer_TDBGroupView );
{$ENDIF}
finalization
  gim_GroupViewImageList.Free;
end.

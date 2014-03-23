// Unité de gestion du fichier INI dont dépendant l'unité FormMainIni
// intégrant une form de gestion de fichier INI
unit fonctions_init;

{$IFDEF FPC}
{$mode Delphi}
{$ENDIF}

{$I ..\DLCompilers.inc}
{$I ..\extends.inc}

interface
uses
{$IFDEF FPC}
     LCLIntf, SQLDB,
{$ELSE}
     Windows, MaskUtils, SHLObj,
{$ENDIF}
{$IFDEF EADO}
     ADODB, AdoConEd,
{$ENDIF}
     IniFiles, Forms, sysUtils, classes, ComCtrls,
{$IFDEF VIRTUALTREES}
     VirtualTrees,
{$ENDIF}
{$IFDEF VERSIONS}
  fonctions_version,
{$ENDIF}
  dialogs,
  {$IFDEF FPC}
  unite_messages,
  {$ELSE}
  unite_messages_delphi,
  {$ENDIF}
  DBGrids;

type
  TIniEvent = procedure( const afor_MainObject : TObject ; const aini_iniFile : TCustomInifile ) of object;

const
{$IFDEF VERSIONS}
  gVer_fonctions_init : T_Version = ( Component : 'Gestion du fichier INI' ; FileUnit : 'fonctions_init' ;
                                      Owner     : 'Matthieu Giroux' ;
                                      Comment   : 'Première version de gestion du fichier INI.' + #13#10 + 'Certaines fonctions sont encore utilisées.' ;
                                      BugsStory : 'Version 1.0.5.0 : No ItemIndex in strings R/W.' + #13#10 +
                                                  'Version 1.0.4.3 : Vista App Config Dir Bug on Destroy.' + #13#10 +
                                                  'Version 1.0.4.2 : Debuging.' + #13#10 +
                                                  'Version 1.0.4.1 : UTF 8.' + #13#10 +
                                                  'Version 1.0.4.0 : comboitems function.' + #13#10 +
                                                  'Version 1.0.3.2 : ini can be cutomized' + #13#10 +
                                                  'Version 1.0.3.1 : Function fs_GetIniDir' + #13#10 +
                                                  'Version 1.0.3.0 : Fonction fb_iniWriteFile' + #13#10 +
                                                  'Version 1.0.2.0 : Fonctions ini pour les listview,dbgrid, et virtualtrees' + #13#10 +
                                                  'Version 1.0.1.0 : Paramètre Utilisateur.' + #13#10 +
                                                  'Version 1.0.0.0 : La gestion est en place.' + #13#10 +
                                                  'On utilise plus cette unité complètement mais Fenêtre principale puis plus tard Mc Form Main INI.';
                                     UnitType : 1 ;
                                     Major : 1 ; Minor : 0 ; Release : 5 ; Build : 0 );
{$ENDIF}
  // Constantes des sections du fichier ini
  INISEC_PAR = 'parametres';
  INISEC_CON = 'connexion';
  INISEC_UTI = 'Utilisateur' ;
  // Paramètres du fichier ini
  INIPAR_CREATION  = 'creation ini';
  INIPAR_LANCEMENT = 'lancement';
  INIPAR_QUITTE    = 'quitte';
  INIPAR_CONNEXION = 'String de connexion';
  INIPAR_ACCESS    = 'String d''acces';

  CST_MACHINE = 'MACHINE';
  CST_INI_DB   = 'db_';
  CST_INI_SOFT   = 'soft_';
  CST_INI_USERS   = 'user_config';
  CST_INI_ROOT    = 'root_config';
  CST_INI_SQL   = 'sql_';
  CST_EXTENSION_INI = '.ini';
  CST_DBEXPRESS = 'DBEXPRESS' ;
  INIVAL_CDE  = 'cde';

////////////////////////////////////////////////////////////////////////////////
//  Fonctions à appeler pour la gestion des fichiers INI
////////////////////////////////////////////////////////////////////////////////

  function fs_GetIniDir( const ab_Root : Boolean = False ; const ab_Create : Boolean = True ): String;
  function fb_CreateCommonIni ( var amif_Init : TIniFile  ; const as_NomConnexion: string ) : Boolean ;
  function fb_iniWriteFile( const amem_Inifile : TCustomInifile ; const ab_Afficheerreur : Boolean  = False ):Boolean;
  // Lit la section des commandes et si elle existe la retourne dans donnees (TStrings)
  function Lecture_ini_sauvegarde_fonctions(sauvegarde: string; donnees: Tstrings): Boolean;

  // Construit dans aListe (TStrings) la liste de toutes les valeurs de la section aTache du fichier INI
  function Lecture_ini_tache_fonctions(aTache: string; aListe: TStrings): Boolean;

  // Retourne l'objet FIniFile représentant le fichier INI
  function f_GetMemIniFile(): TIniFile;
  function f_GetMainMemIniFile( const ae_WriteSessionIni, ae_ReadSessionIni  : TIniEvent ; const acom_Owner : TComponent ; const ab_Root : Boolean = False ; const as_Ininame : String = '' ): TIniFile;
  function f_GetIniFile( const as_IniPath : String ): TIniFile;

  // Lecture du fichier SQL dans FSQLFile avec gestion du fichier SQL
  // et lecture de requête à partir de la section parent et de de la clé requete.
  function f_LectureSQLFile(parent, requete: string): string;


////////////////////////////////////////////////////////////////////////////////
//  Fonctions appelées ( Utiliser plutôt les fonctions qui les appellent)
////////////////////////////////////////////////////////////////////////////////

  // Initialisation de paramètres du fichier INI
  // (appelée quand il n'existe pas de fichier INI ou pas d'ADO)
  procedure p_IniInitialisation;

  // Mise à jour de la date de lancement du fichier ini
  procedure p_IniMAJ;


////////////////////////////////////////////////////////////////////////////////
//  Fonctions standard de gestion de valeur
////////////////////////////////////////////////////////////////////////////////
  // Retourne un entier à partir de la section et de la clé ainsi que de la valeur par défaut
  function f_IniReadSectionInt(aSection: string; aCle: string; aDefaut: integer): integer;

  // Retourne un booléen à partir de la section et de la clé ainsi que de la valeur par défaut
  function f_IniReadSectionBol(aSection: string; aCle: string; aDefaut: Boolean): Boolean;

  // Retourne une chaîne à partir de la section et de la clé ainsi que de la valeur par défaut
  function f_IniReadSectionStr(aSection: string; aCle: string; aDefaut: string): string;
  // Retourne une chaîne à partir de la section et de la clé ainsi que de la valeur par défaut
  function f_IniReadSection(aSection: string): string;
  function f_IniReadGridFromIni ( const aini_IniFile : TCustomInifile ; const as_FormName : String ; const agd_grid : TCustomDBGrid ): Boolean ;
{$IFDEF VIRTUALTREES}
  function f_IniReadVirtualTreeFromIni ( const aini_IniFile : TCustomInifile ; const as_FormName : String ; const abvt_VirtualTree : TBaseVirtualTree ): Boolean ;
  procedure p_IniWriteVirtualTreeToIni ( const aini_IniFile : TCustomInifile ; const as_FormName : String ; const abvt_VirtualTree : TBaseVirtualTree );
{$ENDIF}
{$IFDEF EADO}
  function fb_WriteADOCommonIni ( const acco_Conn,acco_ConnAcces : TComponent ; var amif_Init : TIniFile ; const as_NomConnexion: string ) : Boolean ;
  procedure p_ReadADOCommonIni ( const acco_ConnAcces, acco_Conn: TComponent; const amif_Init : TIniFile );
{$ENDIF}
  function f_IniReadListViewFromIni ( const aini_IniFile : TCustomInifile ; const as_FormName : String ; const alv_ListView : TCustomListView ): Boolean ;

  procedure p_IniWriteGridToIni ( const aini_IniFile : TCustomInifile ; const as_FormName : String ; const agd_grid : TCustomDBGrid );
  procedure p_IniWriteListViewToIni ( const aini_IniFile : TCustomInifile ; const as_FormName : String ; const alv_ListView : TCustomListView );
  // Ecrit une chaîne dans le fichier déclaré dans FINIFile
  // à partir de la section et de la clé ainsi que de la valeur à donner.
  procedure p_IniWriteSectionStr(aSection, aCle: string; aDonnee: string);

  // Ecrit un booléen dans le fichier déclaré dans FINIFile
  // à partir de la section et de la clé ainsi que de la valeur à donner.
  procedure p_IniWriteSectionBol(aSection, aCle: string; aDonnee: Boolean);

  // Ecrit un entier dans le fichier déclaré dans FINIFile
  // à partir de la section et de la clé ainsi que de la valeur à donner.
  procedure p_IniWriteSectionInt(aSection, aCle: string; aDonnee: integer);

  // Ecrit une chaîne dans le fichier déclaré dans FSQLFile
  // à partir de la section et de la clé ainsi que de la valeur à donner.
  procedure p_SQLWriteSectionStr(aSection, aCle: string; aDonnee: string);

  // Ecrit un booléen dans le fichier déclaré dans FSQLFile
  // à partir de la section et de la clé ainsi que de la valeur à donner.
  procedure p_SQLWriteSectionBol(aSection, aCle: string; aDonnee: Boolean);

  // Ecrit un entier dans le fichier déclaré dans FSQLFile
  // à partir de la section et de la clé ainsi que de la valeur à donner.
  procedure p_SQLWriteSectionInt(aSection, aCle: string; aDonnee: integer);


////////////////////////////////////////////////////////////////////////////////
//  Fonctions standard de gestion de Clé
////////////////////////////////////////////////////////////////////////////////
  // Efface une clé à partir du nom de la section et du nom de la clé.
  procedure p_IniDeleteKey(aSection, aCle: string);

  // Retourne true si la clé aCle de la section aSection existe
  function f_CleExiste(aSection, aCle: string): Boolean;


////////////////////////////////////////////////////////////////////////////////
//  Fonctions standard de gestion de Section
////////////////////////////////////////////////////////////////////////////////
  // Lit toutes les sections et les retourne dans le TStrings
  procedure p_IniReadSections(aStrings: TStrings);

  // Lit une section et la retourne dans le TStrings.
  procedure p_IniReadSection(aSection: string; aStrings: TStrings);

  // Efface une section à partir du nom de la section
  procedure p_IniDeleteSection(aSection: string);

  // Retourne true si la section aSection existe.
  function f_SectionExiste(aSection: string): Boolean;

procedure p_ReadComboBoxItems ( const acom_combobox : TComponent ; const Astl_Items : TStrings  );
procedure p_writeComboBoxItems (  const acom_combobox : TComponent ;const Astl_Items : TStrings );
procedure SauveTStringsDansIni(const FIni:TCustomIniFile; SectionIni:string; const LeTStrings:TStrings);
procedure LitTstringsDeIni(const FIni: TCustomIniFile; SectionIni: string; const LeTStrings: TStrings);
procedure p_FreeConfigFile;
procedure p_IniOuvre;
procedure p_IniQuitte;

var
  FIniFile: TIniFile = nil;
  FIniMain: TIniFile = nil ;
  FIniRoot: TIniFile = nil;
  FSQLFile: TIniFile = nil;
  {$IFDEF EADO}
  gb_IniADOSetKeyset : Boolean = False ;
  gb_IniDirectAccessOnServer : Boolean = False ;
  gi_IniDatasourceAsynchroneEnregistrementsACharger : Integer = 300 ;
  gi_IniDatasourceAsynchroneTimeOut : Integer = CST_ASYNCHRONE_TIMEOUT_DEFAUT ;
  gb_ConnexionAsynchrone : Boolean = False ;
  gb_ApplicationAsynchrone : Boolean = False ;
{$ENDIF}
  gs_DataSectionIni : String = 'Database' ;
  gs_ModeConnexion : string;
  // Aide Help
  GS_AIDE           : String = 'aide';
  GS_CHEMIN_AIDE    : String = 'CHM\Aide.chm';
  gs_AppConfigDir : Array [ 0..1 ] of String = ('','');
  gs_NomApp: string;

implementation

uses TypInfo, fonctions_string, fonctions_system,
      fonctions_proprietes;


      
//////////////////////////////////////////////////////////////////////////
// Procédure : p_FreeConfigFile
// Description : Libération de l'ini
//////////////////////////////////////////////////////////////////////////
procedure p_FreeConfigFile;
begin
  FIniMain.Free;
  FIniMain := nil;
End ;

////////////////////////////////////////////////////////////////////////////////
// Force l'écriture du fichier ini
////////////////////////////////////////////////////////////////////////////////
function fb_iniWriteFile( const amem_Inifile : TCustomInifile ; const ab_Afficheerreur : Boolean = False ):Boolean;
var
    li_Attr : Integer ;
    lt_Arg  : Array [0..1] of String ;
begin
  Result := False ;
  if assigned ( amem_Inifile ) Then
    Begin
      li_Attr := 0 ;
      try
        {$IFNDEF LINUX}
         li_Attr := FileGetAttr ( amem_Inifile.FileName );
          if  ( li_Attr and SysUtils.faReadOnly <> 0 ) Then
            FileSetAttr ( amem_Inifile.FileName, li_Attr - SysUtils.faReadOnly );
        {$ENDIF}
        amem_Inifile.UpdateFile ;
        Result := True ;
      Except
        on e: Exception do
          if ab_Afficheerreur Then
            Begin
              lt_Arg [0] := amem_Inifile.FileName ;
              lt_Arg [1] := IntToStr ( li_Attr ) ;
              MessageDlg ( fs_RemplaceMsg ( GS_ECRITURE_IMPOSSIBLE, lt_Arg ) + #13#10
                         + GS_DETAILS_TECHNIQUES + #13#10 + e.Message, mtError, [mbOk], 0 );
            End ;
      End ;
    End ;
end;

////////////////////////////////////////////////////////////////////////////////
// Lit le nom de toutes les sections d'un fichier INI dans une liste de chaînes
////////////////////////////////////////////////////////////////////////////////
procedure p_iniReadSections(aStrings: TStrings);
begin
  If assigned ( FIniFile ) Then
    FIniFile.ReadSections(aStrings);
end;

////////////////////////////////////////////////////////////////////////////////
// Lit tous les noms de clés d'une section donnée d'un fichier INI dans une liste de chaîne
////////////////////////////////////////////////////////////////////////////////
procedure p_iniReadSection(aSection: string; aStrings: TStrings);
begin
  If assigned ( FIniFile ) Then
    FIniFile.ReadSection(aSection, aStrings);
end;

////////////////////////////////////////////////////////////////////////////////
// Efface une clé d'une section dans un fichier INI
////////////////////////////////////////////////////////////////////////////////
procedure p_IniDeleteKey(aSection, aCle: string);
begin
  If assigned ( FIniFile ) Then
    FIniFile.DeleteKey(aSection, aCle);
end;

////////////////////////////////////////////////////////////////////////////////
// Efface une section et toutes ses clés dans un fichier INI
////////////////////////////////////////////////////////////////////////////////
procedure p_IniDeleteSection(aSection: string);
begin
  If assigned ( FIniFile ) Then
    FIniFile.EraseSection(aSection);
end;

////////////////////////////////////////////////////////////////////////////////
// Lit un entier dans paramètre du fichier INI
////////////////////////////////////////////////////////////////////////////////
function f_IniReadSectionInt(aSection: string; aCle: string; aDefaut: integer): integer;
begin
  result := FIniFile.ReadInteger(aSection, aCle, aDefaut);
end;
////////////////////////////////////////////////////////////////////////////////
// Lit une valeur string dans paramètre du fichier INI
////////////////////////////////////////////////////////////////////////////////
function f_IniReadSectionStr(aSection :string; aCle :string; aDefaut :string) : string;
begin
  result := FIniFile.Readstring(aSection, aCle, aDefaut);
end;

////////////////////////////////////////////////////////////////////////////////
// Lit une valeur string dans paramètre du fichier INI
////////////////////////////////////////////////////////////////////////////////
function f_IniReadSection(aSection :string) : string;
var lstr_strings : TStringList ;
begin
  lstr_strings := TStringList.create ;
  FIniFile.ReadSection(aSection, lstr_strings);
  result := lstr_strings.Text;
end;

////////////////////////////////////////////////////////////////////////////////
// Lit une valeur booléenne dans paramètre du fichier INI
////////////////////////////////////////////////////////////////////////////////
function f_IniReadSectionBol(aSection: string; aCle: string; aDefaut: Boolean): Boolean;
begin
  result := FIniFile.ReadBool(aSection, aCle, aDefaut);
end;

/////////////////////////////////////////////////////////////////////////////////
// Fonction : f_IniReadGridFromIni
// Description : Affecte les tailles de colonnes d'une grille à partir de l'ini
// Paramètres  : aini_IniFile : L'ini
//               as_FormName  : Le nom de la fiche section de l'ini
//               agd_grid     : La grille
//               Retour       : Une colonne au moins a été affectée
/////////////////////////////////////////////////////////////////////////////////

function f_IniReadGridFromIni ( const aini_IniFile : TCustomInifile ; const as_FormName : String ; const agd_grid : TCustomDBGrid ): Boolean ;
var k, li_Width : Integer ;
    AColumns : TDBGridColumns;
begin
  Result := False ;
  AColumns := TDBGridColumns ( fobj_getComponentObjectProperty( agd_grid, CST_PROPERTY_COLUMNS));
  for k := 0 to aColumns.Count - 1 do
    Begin
{$IFDEF FPC}
      li_Width := aini_IniFile.ReadInteger( as_FormName, agd_grid.Name + '.' + (TColumn(aColumns[k])).FieldName, aColumns[k].Width);
{$ELSE}
      li_Width := aini_IniFile.ReadInteger( as_FormName, agd_grid.Name + '.' + aColumns[k].FieldName, aColumns[k].Width);
{$ENDIF}
      if li_Width > 0 Then
        Begin
          Result := True ;
          aColumns[k].Width := li_Width ;
        End ;
    End ;
end;

/////////////////////////////////////////////////////////////////////////////////
// Fonction : p_IniWriteGridToIni
// Description : Affecte les tailles de colonnes d'une grille vers l'ini
// Paramètres  : aini_IniFile : L'ini
//               as_FormName  : Le nom de la fiche section de l'ini
//               agd_grid     : La grille
/////////////////////////////////////////////////////////////////////////////////
procedure p_IniWriteGridToIni ( const aini_IniFile : TCustomInifile ; const as_FormName : String ; const agd_grid : TCustomDBGrid );
var k : Integer ;
  AColumns : TDBGridColumns;
begin
  AColumns := TDBGridColumns ( fobj_getComponentObjectProperty( agd_grid, CST_PROPERTY_COLUMNS));

  for k := 0 to aColumns.Count - 1 do
{$IFDEF FPC}
    aini_IniFile.WriteInteger ( as_FormName, agd_grid.Name + '.' + (Tcolumn(aColumns[k])).FieldName, aColumns[k].Width);
{$ELSE}
    aini_IniFile.WriteInteger ( as_FormName, agd_grid.Name + '.' + aColumns[k].FieldName, aColumns[k].Width);
{$ENDIF}
End ;

function flsc_GetListColumns ( const alv_ListView : TCustomListView ) : TListColumns ;
var lobj_Column : Tobject;
Begin
  lobj_Column := fobj_getComponentObjectProperty(alv_ListView, 'Columns' );
  if assigned ( lobj_Column )
  and ( lobj_Column is TListColumns ) Then
    Result := lobj_Column as TListColumns;
End;

/////////////////////////////////////////////////////////////////////////////////
// Fonction : f_IniReadListViewFromIni
// Description : Affecte les tailles de colonnes d'une liste à partir de l'ini
// Paramètres  : aini_IniFile : L'ini
//               as_FormName  : Le nom de la fiche section de l'ini
//               alv_ListView : La liste
//               Retour       : Une colonne au moins a été affectée
/////////////////////////////////////////////////////////////////////////////////
function f_IniReadListViewFromIni ( const aini_IniFile : TCustomInifile ; const as_FormName : String ; const alv_ListView : TCustomListView ): Boolean ;
var k, li_Width : Integer ;
    llsc_Columns : TListColumns;
begin
  Result := False ;
  llsc_Columns := flsc_GetListColumns ( alv_ListView );
  if assigned ( llsc_Columns ) Then
    for k := 0 to llsc_Columns.Count - 1 do
      Begin
        li_Width := aini_IniFile.ReadInteger ( as_FormName, alv_ListView.Name + '.' + llsc_Columns[k].Caption, llsc_Columns[k].Width);
        if li_Width > 0 Then
          Begin
            Result := True ;
            llsc_Columns[k].Width := li_Width ;
          End ;
      End ;
end;

/////////////////////////////////////////////////////////////////////////////////
// Fonction : f_IniReadVirtualTreeFromIni
// Description : Affecte les tailles de colonnes d'un arbre à partir de l'ini
// Paramètres  : aini_IniFile : L'ini
//               as_FormName  : Le nom de la fiche section de l'ini
//               abvt_VirtualTree : L'arbre
//               Retour       : Une colonne au moins a été affectée
/////////////////////////////////////////////////////////////////////////////////

{$IFDEF VIRTUALTREES}
function f_IniReadVirtualTreeFromIni ( const aini_IniFile : TCustomInifile ; const as_FormName : String ; const abvt_VirtualTree : TBaseVirtualTree ): Boolean ;
var
  lvt_EnteteArbre : TVTHeader ;
  k, li_Width : Integer ;
begin
  Result := False ;
  lvt_EnteteArbre := nil ;
  if  IsPublishedProp ( abvt_VirtualTree, 'Header'  )
  and  PropIsType     ( abvt_VirtualTree, 'Header' , tkClass)
  and ( GetObjectProp   ( abvt_VirtualTree, 'Header'  ) is TVTHeader ) Then
    lvt_EnteteArbre := TVTHeader ( GetObjectProp   ( abvt_VirtualTree, 'Header'  ));
  if assigned ( lvt_EnteteArbre ) Then
    for k := 0 to lvt_EnteteArbre.Columns.Count - 1 do
      Begin
        li_Width := aini_IniFile.ReadInteger( as_FormName, abvt_VirtualTree.Name + '.' + lvt_EnteteArbre.Columns[k].Text, lvt_EnteteArbre.Columns[k].Width);
        if li_Width > 0 Then
          Begin
            Result := True ;
            lvt_EnteteArbre.Columns[k].Width := li_Width ;
          End ;
      End ;
end;
/////////////////////////////////////////////////////////////////////////////////
// Fonction : p_IniWriteVirtualTreeToIni
// Description : Affecte les tailles de colonnes d'un arbre vers l'ini
// Paramètres  : aini_IniFile : L'ini
//               as_FormName  : Le nom de la fiche section de l'ini
//               abvt_VirtualTree : L'arbre
/////////////////////////////////////////////////////////////////////////////////
procedure p_IniWriteVirtualTreeToIni ( const aini_IniFile : TCustomInifile ; const as_FormName : String ; const abvt_VirtualTree : TBaseVirtualTree );
var k : Integer ;
    lvt_EnteteArbre : TVTHeader ;
begin
  lvt_EnteteArbre := nil ;
  if  IsPublishedProp ( abvt_VirtualTree, 'Header'  )
  and  PropIsType     ( abvt_VirtualTree, 'Header' , tkClass)
  and ( GetObjectProp   ( abvt_VirtualTree, 'Header'  ) is TVTHeader ) Then
    lvt_EnteteArbre := TVTHeader ( GetObjectProp   ( abvt_VirtualTree, 'Header'  ));
  if assigned ( lvt_EnteteArbre ) Then
    for k := 0 to lvt_EnteteArbre.Columns.Count - 1 do
      aini_IniFile.WriteInteger( as_FormName, abvt_VirtualTree.Name + '.' + lvt_EnteteArbre.Columns[k].Text, lvt_EnteteArbre.Columns[k].Width);
End ;
{$ENDIF}

/////////////////////////////////////////////////////////////////////////////////
// Fonction : p_IniWriteListViewToIni
// Description : Affecte les tailles de colonnes d'une liste vers l'ini
// Paramètres  : aini_IniFile : L'ini
//               as_FormName  : Le nom de la fiche section de l'ini
//               alv_ListView : La liste
/////////////////////////////////////////////////////////////////////////////////
procedure p_IniWriteListViewToIni ( const aini_IniFile : TCustomInifile ; const as_FormName : String ; const alv_ListView : TCustomListView );
var k : Integer ;
    llsc_Columns : TListColumns;
begin
  llsc_Columns := flsc_GetListColumns ( alv_ListView );
  if assigned ( llsc_Columns ) Then
    for k := 0 to llsc_Columns.Count - 1 do
      aini_IniFile.WriteInteger( as_FormName, alv_ListView.Name + '.' + llsc_Columns[k].Caption, llsc_Columns[k].Width);
End ;

////////////////////////////////////////////////////////////////////////////////
// Ecrit une valeur chaîne dans un fichier INI
////////////////////////////////////////////////////////////////////////////////
procedure p_IniWriteSectionStr(aSection, aCle, aDonnee: string);
begin
  If assigned ( FIniFile ) Then
    FIniFile.WriteString(aSection, aCle, aDonnee);
end;

////////////////////////////////////////////////////////////////////////////////
// Ecrit une valeur booléenne dans un fichier INI
////////////////////////////////////////////////////////////////////////////////
procedure p_iniWriteSectionBol(aSection, aCle: string; aDonnee: Boolean);
begin
  If assigned ( FIniFile ) Then
    FIniFile.WriteBool(aSection, aCle, aDonnee);
end;

////////////////////////////////////////////////////////////////////////////////
// Ecrit un entier dans un fichier INI
////////////////////////////////////////////////////////////////////////////////
procedure p_iniWriteSectionInt(aSection, aCle : string; aDonnee : integer);
begin
  If assigned ( FIniFile ) Then
    FIniFile.WriteInteger(aSection, aCle, aDonnee);
end;

////////////////////////////////////////////////////////////////////////////////
// Initialisation du fichier INI
////////////////////////////////////////////////////////////////////////////////
procedure p_IniInitialisation;
begin
  p_IniWriteSectionStr(INISEC_PAR, INIPAR_CREATION, 'le ' + DateToStr(Date) + ' ' + TimeToStr(Time));
  p_IniMAJ;
end;

////////////////////////////////////////////////////////////////////////////////
// Mise à jour de la date de lancement du fichier INI
////////////////////////////////////////////////////////////////////////////////
procedure p_IniMAJ;
begin
  p_IniWriteSectionStr(INISEC_PAR, INIPAR_LANCEMENT, 'le ' + DateToStr(Date) + ' ' + TimeToStr(Time));
end;

////////////////////////////////////////////////////////////////////////////////
// Retourne le répertoire du fichier ini
////////////////////////////////////////////////////////////////////////////////
function fs_GetIniDir( const ab_Root : Boolean = False ; const ab_Create : Boolean = True ): String;
begin
  if ( pos ( GetUserDir, Application.ExeName ) > 0 )
   Then Result := fs_getAppDir
   Else if gs_AppConfigDir [ Integer ( ab_Root )] <> ''
    Then Result := gs_AppConfigDir [ Integer ( ab_Root ) ]
    Else
      Begin
        Result := GetAppConfigDir ( ab_Root ) ;
        gs_AppConfigDir [ Integer ( ab_Root ) ]:= Result;
      end;
  if ab_Create
  and not Assigned(FIniFile) then
    begin
      if  not DirectoryExists(  Result )
      and not CreateDir (  Result ) Then
        Result := fs_getAppDir;
   end;
end;


////////////////////////////////////////////////////////////////////////////////
// permet de lire le contenu d'un ini qui a été sauvé par SauveTStringsDansIni
////////////////////////////////////////////////////////////////////////////////
procedure LitTstringsDeIni(const FIni: TCustomIniFile; SectionIni: string; const LeTStrings: TStrings);
var li_i, li_count : integer;
begin
  if FIni.SectionExists(SectionIni) then
    try
      LeTStrings.Clear;
      LeTStrings.BeginUpdate;
      li_count:=FIni.ReadInteger(SectionIni, CST_PROPERTY_COUNT, 0 );
      for li_i := 1 to li_count do
       if FIni.ValueExists(SectionIni, 'L' + IntToStr(li_i))
        Then LeTStrings.Add(FIni.ReadString(SectionIni, 'L' + IntToStr(li_i), ''))
        Else LeTStrings.Add('');
      LeTStrings.EndUpdate;
    except
    end;
end;




////////////////////////////////////////////////////////////////////////////////
// permet de sauver dans un ini le contenu d'un mémo, d'un Combobox, d'un ListBox, d'un RichEdit
// et d'un façon générale, le contenu des composants qui le stocke dans des TStrings
////////////////////////////////////////////////////////////////////////////////
procedure SauveTStringsDansIni(const FIni:TCustomIniFile; SectionIni:string; const LeTStrings:TStrings);
var li_i: integer;
begin
  Fini.EraseSection(SectionIni); // on efface toute la section décrite par SectionIni
  for li_i := 1 to LeTStrings.Count do // pour chaque ligne du Tstrings
  begin
    // on aura ainsi dans le fichier ini et dans la section considéré :
    // L0= suivi du contenu de la première ligne du TStrings. puis L1= etc..
    FIni.WriteString(SectionIni, 'L' + IntToStr(li_i), LeTStrings[li_i-1]);// écrit dans le fichier ini
  end;
  FIni.WriteInteger(SectionIni, CST_PROPERTY_COUNT, LeTStrings.Count);
end;

procedure p_ReadComboBoxItems (  const acom_combobox : TComponent ;const Astl_Items : TStrings );
Begin
  LitTstringsDeIni(FInifile, acom_combobox.Name,Astl_Items);
end;
procedure p_writeComboBoxItems (  const acom_combobox : TComponent ;const Astl_Items : TStrings );
Begin
  SauveTStringsDansIni(FInifile, acom_combobox.Name,Astl_Items);
end;

////////////////////////////////////////////////////////////////////////////////
// Retourne le nom du fichier ini
////////////////////////////////////////////////////////////////////////////////
function f_GetMainMemIniFile( const ae_WriteSessionIni, ae_ReadSessionIni  : TIniEvent ; const acom_Owner : TComponent ; const ab_Root : Boolean = False  ;const as_Ininame : String = '' ): TIniFile;
var ls_PathIni: String;
    FIni : TIniFile;
begin
  if ( not ab_Root and not Assigned(FIniFile))
  or (     ab_Root and not Assigned(FIniRoot)) then
    begin
      if as_Ininame <> '' then
        ls_PathIni := fs_GetIniDir ( ab_Root ) + CST_INI_SOFT  + as_Ininame + CST_EXTENSION_INI
      else if gs_ModeConnexion = CST_MACHINE then
        ls_PathIni := ExtractFileDir(Application.ExeName) + DirectorySeparator + CST_INI_USERS  + fs_GetComputerName + CST_EXTENSION_INI
      else
        if ab_Root
         Then ls_PathIni := fs_GetIniDir ( ab_Root ) + CST_INI_ROOT  + CST_EXTENSION_INI
         Else ls_PathIni := fs_GetIniDir ( ab_Root ) + CST_INI_USERS + CST_EXTENSION_INI ;
      if ab_Root
       Then  Begin FIniRoot := f_GetIniFile( ls_PathIni ); FIni := FIniRoot; End
       Else  Begin FIniFile := f_GetIniFile( ls_PathIni ); FIni := FIniFile; End;
      if not FIni.SectionExists(INISEC_PAR) then
        Begin
          FIni.WriteString(INISEC_PAR, INIPAR_CREATION, 'le ' +  DateToStr(Date)  + ' ' +  TimeToStr(Time));
          if assigned ( ae_WriteSessionIni ) Then
            ae_WriteSessionIni ( acom_Owner, FIni );
        End
      else
        if assigned ( ae_ReadSessionIni ) Then
          ae_ReadSessionIni ( acom_Owner, FIni );
      FIni.WriteString(INISEC_PAR, INIPAR_LANCEMENT , 'le '  + DateToStr(Date)  + ' ' + TimeToStr(Time));
    end
  else
  Begin
    if ab_Root
     Then  FIni := FIniRoot
     Else  FIni := FIniFile;
    if assigned ( acom_Owner ) then
      FIni.WriteString(INISEC_PAR, INIPAR_LANCEMENT , 'le '  + DateToStr(Date)  + ' ' + TimeToStr(Time));
  end;
  result := FIni;
end;
function f_GetIniFile( const as_IniPath : String ): TIniFile;
Begin
  Result := TIniFile.Create( as_IniPath );
end;

function f_GetMemIniFile( ): TIniFile;
begin
  Result := f_GetMainMemIniFile ( nil, nil, nil );
end;

function f_SectionExiste(aSection: string): Boolean;
begin
  result := assigned ( FIniFile ) and FIniFile.SectionExists(aSection);
end;

function f_CleExiste(aSection, aCle: string): Boolean;
begin
  result := assigned ( FIniFile ) and FIniFile.ValueExists(aSection, aCle);
end;

procedure p_SQLWriteSectionStr(aSection, aCle: string; aDonnee: string);
begin
  If assigned ( FSQLFile ) Then
    FSQLFile.WriteString(aSection, aCle, aDonnee);
end;

procedure p_SQLWriteSectionBol(aSection, aCle: string; aDonnee: Boolean);
begin
  If assigned ( FSQLFile ) Then
    FSQLFile.WriteBool(aSection, aCle, aDonnee);
end;

procedure p_SQLWriteSectionInt(aSection, aCle: string; aDonnee: integer);
begin
  FSQLFile.WriteInteger(aSection, aCle, aDonnee);
end;

function f_LectureSQLFile(parent, requete: string): string;
begin
  if FSQLFile = nil then
    FSQLFile := TIniFile.Create(fs_getAppDir + CST_INI_SQL + 'SQLFILE.INI');
  result := FSQLFile.ReadString(parent, requete, 'fichier non trouvé');
end;

function Lecture_ini_sauvegarde_fonctions(sauvegarde: string; donnees: Tstrings): Boolean;
var
  i: integer;
  ligne: string;

begin
  If not assigned ( FIniFile ) Then
    Exit ;
  result := FIniFile.SectionExists(sauvegarde);
  if not result then exit;

  donnees.Clear;
  i := 0;

  while FIniFile.ValueExists(sauvegarde, INIVAL_CDE + IntToStr(i)) do
    begin
      ligne := FIniFile.ReadString(sauvegarde, INIVAL_CDE + IntToStr(i), '');
      donnees.Add(ligne);
      inc(i);
    end;
end;

///////////////////////////////////////////////////////////////////////////////
//  Construit dans aListe la liste de toutes
//  les commandes de la section du fichier INI
///////////////////////////////////////////////////////////////////////////////
function Lecture_ini_tache_fonctions(aTache: string; aListe: TStrings): Boolean;
var
  i: integer;
  Ligne: String;
  Cles: TStrings;

begin
  If not assigned ( FIniFile ) Then
    Exit ;
   result := FIniFile.SectionExists(aTache);
  if not result then exit;

  aListe.Clear;
  Cles := TStringList.Create;
  Cles.Clear;
  FIniFile.ReadSection(aTache, Cles);

  for i := 0 to Cles.Count - 1 do
    begin
      Ligne := FIniFile.ReadString(aTache, Cles.Strings[i], '');
      aListe.Add(Ligne);
    end;
end;


function fs_PathCommonIni ( const as_NomConnexion: string ; const ab_create : Boolean = True ) : String ;
var lt_Arg  : Array [0..0] of String ;
Begin
    try
      Result := fs_GetIniDir ( True );
      if ab_create
      and not DirectoryExists(Result) Then
        CreateDir(Result);
      Result := Result + CST_INI_SOFT + as_NomConnexion + CST_EXTENSION_INI ;
    except
      On E : Exception do
       Begin
         lt_Arg [ 0 ] := Result;
         Result := '';
         MessageDlg(fs_RemplaceMsg ( GS_INI_FILE_CANT_WRITE, lt_Arg ),mtError,[mbOK],0);
       end;
    End;
end;

function fb_CreateCommonIni ( var amif_Init : TIniFile ; const as_NomConnexion: string ) : Boolean ;
var ls_Path : String ;
    lt_Arg  : Array [0..0] of String ;
Begin
  Result := False;
  if not Assigned(amif_Init) then
    try
      ls_Path:=fs_PathCommonIni ( as_NomConnexion );
      if (ls_Path <> '') Then
        Begin
          amif_Init := TIniFile.Create ( ls_path );
          Result := True;
        end;
    except
      On E : Exception do
       Begin
         lt_Arg [ 0 ] := ls_Path;
         MessageDlg(fs_RemplaceMsg ( GS_INI_FILE_CANT_WRITE, lt_Arg ),mtError,[mbOK],0);
       end;
    End;
end;

{$IFDEF EADO}

procedure p_ReadADOCommonIni ( const acco_ConnAcces, acco_Conn: TComponent; const amif_Init : TIniFile );
Begin
  if  ( acco_Conn is TADOConnection ) Then
    Begin
      gb_ApplicationAsynchrone := amif_Init.ReadBool(INISEC_PAR, GS_MODE_ASYNCHRONE, GB_ASYNCHRONE_PAR_DEFAUT);
      gb_ConnexionAsynchrone := amif_Init.ReadBool(INISEC_PAR, GS_MODE_ASYNCHRONE, GB_ASYNCHRONE_PAR_DEFAUT);
      gi_IniDatasourceAsynchroneEnregistrementsACharger := amif_Init.ReadInteger(INISEC_PAR, GS_MODE_ASYNCHRONE_NB_ENREGISTREMENTS, CST_ASYNCHRONE_NB_ENREGISTREMENTS);
      gi_IniDatasourceAsynchroneTimeOut                 := amif_Init.ReadInteger(INISEC_PAR, GS_MODE_ASYNCHRONE_TIMEOUT, CST_ASYNCHRONE_TIMEOUT_DEFAUT);
      gb_IniDirectAccessOnServer := amif_Init.ReadBool   (INISEC_PAR, GS_ACCES_DIRECT_SERVEUR, gb_IniDirectAccessOnServer );
      gb_IniADOsetKeySet := amif_Init.ReadBool   (INISEC_PAR, GS_Set_KEYSET, gb_IniADOsetKeySet );
      if gb_ConnexionAsynchrone Then
        Begin
          if ( acco_ConnAcces is TADOConnection ) Then
             ( acco_ConnAcces as TADOConnection ).ConnectOptions := coAsyncConnect ;
          ( acco_Conn      as TADOConnection ).ConnectOptions := coAsyncConnect ;
        End ;
  End ;
End;

function fb_WriteADOCommonIni ( const acco_Conn,acco_ConnAcces : TComponent ; var amif_Init : TIniFile ; const as_NomConnexion: string ) : Boolean ;
var lt_Arg  : Array [0..0] of String ;
Begin
  Result := False;
  if ( acco_Conn is TADOConnection ) Then
    try
      if not amif_Init.SectionExists(INISEC_PAR) Then
        begin
          p_SetComponentProperty ( acco_Conn, 'ConnectionString', '' );
          // Mise à jour des paramètre
          amif_Init.WriteString (INISEC_PAR, INISEC_CON, CST_MACHINE);
          amif_Init.WriteString (INISEC_PAR, GS_AIDE, GS_CHEMIN_AIDE);

          amif_Init.WriteInteger(INISEC_PAR, GS_CONNECTION_TIMEOUT, CST_CONNECTION_TIMEOUT_DEFAUT);
          amif_Init.WriteBool   (INISEC_PAR, GS_ACCES_DIRECT_SERVEUR, gb_IniDirectAccessOnServer );
          amif_Init.WriteBool   (INISEC_PAR, GS_Set_KEYSET, gb_IniADOSetKeyset );
          amif_Init.WriteInteger(INISEC_PAR, GS_MODE_ASYNCHRONE_NB_ENREGISTREMENTS, CST_ASYNCHRONE_NB_ENREGISTREMENTS);
          amif_Init.WriteBool   (INISEC_PAR, GS_MODE_CONNEXION_ASYNCHRONE, GB_ASYNCHRONE_PAR_DEFAUT);
          amif_Init.WriteBool   (INISEC_PAR, GS_MODE_ASYNCHRONE, GB_ASYNCHRONE_PAR_DEFAUT);
          amif_Init.WriteInteger(INISEC_PAR, GS_MODE_ASYNCHRONE_TIMEOUT, CST_ASYNCHRONE_TIMEOUT_DEFAUT);
          // Ouverture de la fenêtre de dialogue de connexion
          EditConnectionString(acco_Conn);
          amif_Init.WriteString (INISEC_PAR, INIPAR_ACCESS, ( acco_Conn as TADOConnection ).ConnectionString);
        end
          else
            Begin
              ( acco_Conn as TADOConnection ).ConnectionString := amif_Init.Readstring(INISEC_PAR, INIPAR_ACCESS, '');
              if assigned ( acco_ConnAcces ) Then
                ( acco_ConnAcces as TADOConnection ).ConnectionTimeout := amif_Init.ReadInteger(INISEC_PAR, GS_CONNECTION_TIMEOUT, CST_CONNECTION_TIMEOUT_DEFAUT);
            End;
        Result := True;
    except
      On E : Exception do
       Begin
         lt_Arg [ 0 ] := fs_PathCommonIni ( as_NomConnexion, False );
         MessageDlg(fs_RemplaceMsg ( GS_INI_FILE_CANT_WRITE, lt_Arg ),mtError,[mbOK],0);
       end;
    End;
end;
{$ENDIF}

// Change la date au moment où on quitte
procedure p_IniQuitte;
begin
  p_IniWriteSectionStr(INISEC_PAR, INIPAR_QUITTE , DateToStr(Date)  + ' ' +  TimeToStr(Time) );
end;

// Change la date au moment où on quitte
procedure p_IniOuvre;
begin
  p_IniWriteSectionStr(INISEC_PAR, INIPAR_LANCEMENT , DateToStr(Date)  + ' ' +  TimeToStr(Time) );
end;


{$IFDEF VERSIONS}
initialization
  p_ConcatVersion ( gVer_fonctions_init );
{$ENDIF}
finalization
  FreeAndNil(FIniRoot);
  FreeAndNil(FIniFile);
  FreeAndNil(FSQLFile);
end.


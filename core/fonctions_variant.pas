unit fonctions_variant;

interface

{$I ..\DLCompilers.inc}
{$IFDEF FPC}
{$mode Delphi}
{$ENDIF}
{
2004-08-27
Création de l'unité par Matthieu Giroux
}
uses Variants,
  {$IFDEF VERSIONS}
  fonctions_version,
  {$ENDIF}
  Classes,
  fonctions_proprietes;

{$IFDEF VERSIONS}
const
    gVer_fonctions_variant : T_Version = ( Component : 'Gestion des variants' ; FileUnit : 'fonctions_variant' ;
                        			                 Owner : 'Matthieu Giroux' ;
                        			                 Comment : 'Fonctions de traduction et de formatage des tableaux de variants ( Variables pouvant changer de type ).' ;
                        			                 BugsStory : 'Version 1.0.2.0 : Fonctions fi_CountArrayVariant et fi_CountArrayVarOption (non testée).' + #13#10
                        			                	        	+'Version 1.0.1.0 : Fonctions avec valeurs de retour correctes.' + #13#10
                        			                	        	+ 'Version 1.0.0.0 : Toutes les fonctions sont OK.';
                        			                 UnitType : 1 ;
                        			                 Major : 1 ; Minor : 0 ; Release : 2 ; Build : 0 );

{$ENDIF}

type

  tt_TableauVariant = Array of Variant ;
  tset_OctetOptions = set of Byte;
function fb_SettedOriginalList(const at_Liste: tt_TableauVarOption ; const ab_TestBool : Boolean ; const ai_OptionLimitDown : Integer ): Boolean;
function fb_VariantsEqual ( const avar_Compare1, avar_Compare2 : Variant ): Boolean ;
// Cherche avar_ATrouver dans la liste alst_liste
// alst_liste   : la liste de recherche
// ab_VarIsNull : Cherche une valeur null
// avar_ATrouver: la variable à trouver ( peut être une chaîne )
function fi_findInList(const alst_liste: tt_TableauVariant;
  const avar_ATrouver: Variant ; const ab_VarIsNull : Boolean ): Integer;

function fi_CountArrayVariant   (const at_Array: tt_TableauVariant) : integer ;
function fi_CountArrayVarOption (const at_Array: tt_TableauVarOption; const ab_TestBool : Boolean ; const ai_Options : tset_OctetOptions ) : integer ;

// Cherche avar_ATrouver dans la liste alst_liste
// alst_liste   : la liste de recherche
// ab_VarIsNull : Cherche une valeur null
// avar_ATrouver: la variable à trouver ( peut être une chaîne )
function fi_findInListVarBool(const alst_liste: tt_TableauVarOption;
  const avar_ATrouver: Variant ; const ab_VarIsNull, ab_TestOption : Boolean; const ai_ValTest : tset_OctetOptions  ): Integer;

// Ajoute un variant à un tableau de variants
// at_Liste : Le tableau destination
// as_Valeur : La valeur du variant en string
procedure p_AddListe ( var at_Liste : tt_TableauVariant ; const as_Valeur : String );

// Ajoute un variant à un tableau de variants
// at_Liste : Le tableau destination
// as_Valeur : La valeur du variant en string
function fi_AddListe ( var at_Liste : tt_TableauVariant ; const as_Valeur : String ; const ab_VerifExiste : Boolean  = True ): Integer ; overload ;

// Ajoute un variant à un tableau de variants
// at_Liste : Le tableau destination
// as_Valeur : La valeur du variant en string
function fi_AddListe ( var at_Liste : tt_TableauVariant ; const avar_Valeur : Variant ; const ab_VerifExiste : Boolean = True ): Integer ; overload ;

function fi_AddListe ( var at_Liste : tt_TableauVarOption ; const avar_Valeur : Variant ; const ab_VerifExiste : Boolean = True ):Integer;overload;

// Ajoute un variant à un tableau de variants
// at_Liste : Le tableau destination
// as_Valeur : La valeur du variant en string
function fi_EffaceListe ( var at_Liste : tt_TableauVariant ; const avar_Valeur : Variant ) : Integer  ;
function fb_EffaceListe ( var at_Liste : tt_TableauVariant ; const avar_Valeur : Variant ) : Boolean ;

// La liste de variants contient-elle des valeurs
// at_Liste : le tableau de variants
// résultat : True si valeurs non null
function fb_SettedList ( const at_Liste : tt_TableauVariant ) : Boolean ;

// Supprime un item d'un tableau
// at_Liste  : Tableau
// alsi_Item : Item de la liste

implementation

uses SysUtils ;

// Cherche avar_ATrouver dans la liste alst_liste
// alst_liste   : la liste de recherche
// ab_VarIsNull : Cherche une valeur null
// avar_ATrouver: la variable à trouver ( peut être une chaîne )
function fi_findInList(const alst_liste: tt_TableauVariant;
  const avar_ATrouver: Variant ; const ab_VarIsNull : Boolean ): Integer;
 var li_i : Integer ;
Begin
  Result := -1 ;
  if not ab_VarIsNull
  and ( avar_ATrouver = Null )
   Then
    Exit ;
    // Scrute la liste
  for li_i := 0 to high ( alst_liste ) do
  // c'est un tableau qu'on a affecté ( pas encore mise en place )
   if fb_VariantsEqual ( avar_ATrouver, alst_liste [ li_i ]) Then
     Begin
       Result := li_i ;
       Break ;
     End ;
End ;

// Cherche avar_ATrouver dans la liste alst_liste
// alst_liste   : la liste de recherche
// ab_VarIsNull : Cherche une valeur null
// avar_ATrouver: la variable à trouver ( peut être une chaîne )
function fi_findInListVarBool(const alst_liste: tt_TableauVarOption;
  const avar_ATrouver: Variant ; const ab_VarIsNull, ab_TestOption : Boolean; const ai_ValTest : tset_OctetOptions ): Integer;
 var li_i : Integer ;
Begin
  Result := -1 ;
    // Scrute la liste
  for li_i := 0 to high ( alst_liste ) do
    if ( ab_TestOption and ( alst_liste [ li_i ].i_Option in ai_ValTest ))
    or not ab_TestOption Then
    // c'est un tableau qu'on a affecté ( pas encore mise en place )
     if (( avar_ATrouver = Null ) and not ab_VarIsNull ) or fb_VariantsEqual ( avar_ATrouver, alst_liste [ li_i ].var_Key ) Then
       Begin

         Result := li_i ;
         Break ;
       End ;
End ;

function fb_VariantsEqual ( const avar_Compare1, avar_Compare2 : Variant ): Boolean ;
var li_j : Integer ;
    ls_Compare1, ls_Compare2 : String ;
Begin
// c'est un tableau qu'on a affecté ( pas encore mise en place )
 Result := False ;
 if VarIsArray ( avar_Compare1 )
  Then
   Begin
     // scrute le tableau
     for li_j := VarArrayLowBound ( avar_Compare2 , 1 ) to  VarArrayHighBound ( avar_Compare2 , 1 ) do
       if avar_Compare2[ li_j ] <> avar_Compare1 [ li_j ]
        Then
         Break
        Else
         if li_j = VarArrayHighBound ( avar_Compare2 , 1 )
          Then
           Begin
             Result := True ;
             Break ;
           End ;
   End
  Else
  // Gestion du null
   If avar_Compare1 = Null
    Then
     Begin
       if avar_Compare1 = avar_Compare2
        Then
         Begin
           // Variable null trouvée
           Result := True ;
         End ;
     End
    Else
     // Sinon on compare des valeurs qui ne doivent pas être null
     if avar_Compare2 <> Null
      Then
       Begin
         // Comparaison
         ls_Compare1 := avar_Compare2;
         ls_Compare2 := avar_Compare1 ;
         if ls_Compare2 = ls_Compare1
          Then
           Begin
             // On a trouvé la valeur
             Result := True ;
           End ;
       End ;
End ;


// Ajoute un variant à un tableau de variants
// at_Liste : Le tableau destination
// as_Valeur : La valeur du variant en string
procedure p_AddListe ( var at_Liste : tt_TableauVariant ; const as_Valeur : String );
begin
  fi_AddListe ( at_Liste, as_Valeur, True );
End ;
// Ajoute un variant à un tableau de variants
// at_Liste : Le tableau destination
// as_Valeur : La valeur du variant en string
function fi_AddListe ( var at_Liste : tt_TableauVariant ; const as_Valeur : String ; const ab_VerifExiste : Boolean  = True ):Integer;
Begin
  Result := -1 ;
   if  ab_VerifExiste
   and ( fi_findInList ( at_Liste, as_Valeur, False ) <> -1 )
    Then
     Exit ;
   Result := fi_findInList ( at_Liste, Null, True );
   If Result = -1
    Then
     Begin
      // On ajoute dans les clés d'exclusion
      SetLength ( at_Liste, high ( at_Liste ) + 2 );


      at_Liste [ high ( at_Liste ) ] := as_Valeur ;
      Result := high ( at_Liste );
     End
    Else
      at_Liste [ Result ] := as_Valeur ;

End ;

// Ajoute un variant à un tableau de variants
// at_Liste : Le tableau destination
// as_Valeur : La valeur du variant en string
function fi_AddListe ( var at_Liste : tt_TableauVariant ; const avar_Valeur : Variant ; const ab_VerifExiste : Boolean = True ):Integer;
Begin
   if  ab_VerifExiste
   and ( fi_findInList ( at_Liste, avar_Valeur, False ) <> -1 )
    Then
      Begin
        Result := -1 ;
        Exit ;
      End ;
   Result := fi_findInList ( at_Liste, Null, True );
   if VarIsArray ( avar_Valeur ) Then
    Begin
    End
   Else
     If Result = -1
      Then
       Begin
        // On ajoute dans les clés d'exclusion
        SetLength ( at_Liste, high ( at_Liste ) + 2 );


        at_Liste [ high ( at_Liste ) ] := avar_Valeur ;
        Result := high ( at_Liste );
       End
      Else
        at_Liste [ Result ] := avar_Valeur ;

End ;

// Ajoute un variant à un tableau de variants
// at_Liste : Le tableau destination
// as_Valeur : La valeur du variant en string
function fi_AddListe ( var at_Liste : tt_TableauVarOption ; const avar_Valeur : Variant ; const ab_VerifExiste : Boolean  = True ):Integer;
Begin
   if  ab_VerifExiste
   and ( fi_findInListVarBool ( at_Liste, avar_Valeur, False, False, [] ) <> -1 )
    Then
      Begin
        Result := -1 ;
        Exit ;
      End ;
   Result := fi_findInListVarBool ( at_Liste, Null, True, False, [] );
   if VarIsArray ( avar_Valeur ) Then
    Begin
    End
   Else
     If Result = -1
      Then
       Begin
        // On ajoute dans les clés d'exclusion
        SetLength ( at_Liste, high ( at_Liste ) + 2 );


        at_Liste [ high ( at_Liste ) ].var_Key := avar_Valeur ;
        Result := high ( at_Liste );
       End
      Else
        at_Liste [ Result ].var_Key := avar_Valeur ;

End ;


function fb_EffaceListe ( var at_Liste : tt_TableauVariant ; const avar_Valeur : Variant ) : Boolean ;
Begin
  Result := fi_EffaceListe ( at_Liste, avar_Valeur ) <> -1 ;
End ;

function fi_EffaceListe ( var at_Liste : tt_TableauVariant ; const avar_Valeur : Variant ) : Integer ;
Begin
  Result := fi_findInList ( at_Liste, avar_Valeur, False );
  If Result <> -1 Then
    Begin
      at_Liste [ Result ] := Null ;
    End ;
End ;

// La liste de variants contient-elle des valeurs
// at_Liste : le tableau de variants
// résultat : True si valeurs non null
function fb_SettedList ( const at_Liste : tt_TableauVariant ) : Boolean ;
var li_i : integer ;
Begin
 Result := False ;
  // Il peut y avoir des clés à null
  for li_i := 0 to  high ( at_Liste ) do
   // La liste a-t-elle une clé affectée
   if at_Liste [ li_i ] <> Null Then
     Begin
       Result := True ;
       Break ;
     End ;
End ;

// La liste de variants contient-elle des valeurs
// at_Liste : le tableau de variants
// résultat : True si valeurs non null
function fb_SettedOriginalList ( const at_Liste : tt_TableauVarOption ; const ab_TestBool : Boolean ; const ai_OptionLimitDown : Integer ) : Boolean ;
var li_i : integer ;
Begin
 Result := False ;
  // Il peut y avoir des clés à null
  for li_i := 0 to  high ( at_Liste ) do
   // La liste a-t-elle une clé affectée
   if (not ab_TestBool and ( at_Liste [ li_i ].var_Key <> Null ))
   or ( ab_TestBool and ( at_Liste [ li_i ].i_Option >= ai_OptionLimitDown ) and ( at_Liste [ li_i ].var_Key <> Null )) Then
     Begin
       Result := True ;
       Break ;
     End ;
End ;

// Compte les variants non null dans La liste de variants
// at_Array : le tableau de variants
// résultat : Nombre de variants non null
function fi_CountArrayVariant (const at_Array: tt_TableauVariant) : integer ;
var li_i : integer ;
Begin
  Result := 0 ;
  for li_i := 0 to high ( at_Array ) do
    if at_Array [ li_i ] <> Null Then
      inc ( Result );
End ;

// Compte les variants non null dans La liste de variants
// at_Array : le tableau de variants
// ab_TestBool : Test supplémentaire
// ai_Options  : Options valide à tester
// résultat : Nombre de variants non null
function fi_CountArrayVarOption (const at_Array: tt_TableauVarOption; const ab_TestBool : Boolean ; const ai_Options : tset_OctetOptions ) : integer ;
var li_i : integer ;
Begin
  Result := 0 ;
  for li_i := 0 to high ( at_Array ) do
    if at_Array [ li_i ].var_Key <> Null Then
      if ab_TestBool Then
        Begin
          if at_Array [ li_i ].i_Option in ai_Options Then
            inc ( Result );
        End
      Else
        inc ( Result );
End ;

{$IFDEF VERSIONS}
initialization
  p_ConcatVersion ( gVer_fonctions_variant );
{$ENDIF}
end.

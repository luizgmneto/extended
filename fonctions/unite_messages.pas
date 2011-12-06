unit unite_messages;

interface

{$I ..\extends.inc}


{$IFDEF VERSIONS}
uses fonctions_version ;

const
  gVer_unite_messages : T_Version= ( Component : 'Constantes messages' ; FileUnit : 'unite_messages' ;
                        	     Owner : 'Matthieu Giroux' ;
                        	     Comment : 'Constantes et variables messages.' ;
                        	     BugsStory : 'Version 1.0.4.1 : Menu Toolbar messages.' + #13#10
                        		       + 'Version 1.0.4.0 : Message d''erreur de sauvegarde ini.' + #13#10
                        		       + 'Version 1.0.3.3 : Message GS_MC_ERREUR_CONNEXION.' + #13#10
                        		       + 'Version 1.0.3.2 : Modifs GS_MC_VALEUR_UTILISEE et GS_MC_VALEURS_UTILISEES, ajout de GS_MC_DETAILS_TECHNIQUES.' + #13#10
                        		       + 'Version 1.0.3.1 : Constante message Form Dico.' + #13#10
                        		       + 'Version 1.0.3.0 : Constantes INI.' + #13#10
                        		       + 'Version 1.0.2.0 : Plus de messages dans l''unité.' + #13#10
                        		       + 'Version 1.0.1.0 : Plus de messages dans l''unité.' + #13#10
                        		       + 'Version 1.0.0.0 : Gestion des messages des fenêtres.';
                        	     UnitType : 1 ;
                        	     Major : 1 ; Minor : 0 ; Release : 4 ; Build : 1 );

{$ENDIF}

// COmposants
const
  CST_RESSOURCENAV = 'EXTNAV' ;
  CST_RESSOURCENAVMOVE = 'MOVE' ;
  CST_RESSOURCENAVBOOKMARK = 'BOOKMARK' ;
  CST_HC_SUPPRIMER        = 0 ;
  CST_PALETTE_COMPOSANTS_INVISIBLE = 'ExtInvisible' ;
  CST_PALETTE_COMPOSANTS_DB = 'ExtDB' ;
  CST_PALETTE_COMPOSANTS    = 'ExtCtrls' ;
  CST_Avant_Fichier = 'MG_';
  CST_ARG           = '@ARG' ;
  CST_ASYNCHRONE_TIMEOUT_DEFAUT = 30 ;
  CST_CONNECTION_TIMEOUT_DEFAUT : Integer = 15 ;
  CST_ASYNCHRONE_NB_ENREGISTREMENTS : Integer = 300 ;
  CST_CONNECTION_TIMEOUT = 'Connection TimeOut' ;
  CST_FORM_ONCLOSE = 'OnClose' ;
 {$IFDEF EADO}
  CST_Set_KEYSET = 'Set Keyset' ;
  CST_MODE_ASYNCHRONE = 'Mode Asynchrone' ;
  CST_ACCES_DIRECT_SERVEUR = 'Accès directs Serveur' ;
  CST_MODE_CONNEXION_ASYNCHRONE = 'Connection Asynchrone' ;
  CST_MODE_ASYNCHRONE_NB_ENREGISTREMENTS = 'Mode Asynchrone Enregistrements' ;
  CST_MODE_ASYNCHRONE_TIMEOUT = 'Mode Asynchrone TimeOut' ;
{$ENDIF}



resourcestring
  // Paquet Fonctions
  GS_ECRITURE_IMPOSSIBLE = 'Impossible d''écrire sur le fichier @ARG avec l''attribut de fichier @ARG.' ;
  GS_DETAILS_TECHNIQUES = 'Détails techniques : ' ;
  GS_TOOLBARMENU_Personnaliser = 'Personnaliser' ;

  GS_GROUPE_INCLURE         = 'Inclure' ;
  GS_GROUPE_EXCLURE         = 'Exclure' ;
  GS_GROUPE_TOUT_INCLURE    = 'Tout inclure' ;
  GS_GROUPE_TOUT_EXCLURE    = 'Tout exclure' ;
  GS_GROUPE_RETOUR_ORIGINE  = 'Restaurer les données initiales' ;
  GS_GROUPE_MAUVAIS_BOUTONS = 'Les boutons de transfert doivent s''inverser dans les deux listes. ' + #13#10
                        	+ 'Les boutons de transfert sont identifiés par rapport à leur liste,' + #13#10
                        	+ ' à l''inverse des numéros d''images identifiés par rapport à la table. ' ;
      // Doit-on enregistrer ou abandonner
  GS_GROUPE_ABANDON = 'Veuillez enregistrer ou abandonner avant de continuer.' ;
      // Vidage du panier : oui ou non
  GS_GROUPE_VIDER   = 'Le panier utilisé pour les réaffectations n''est pas vide.' + #13#10
                         + 'Voulez-vous abandonner ces réaffectations ?' ;
  GS_PAS_GROUPES    = 'DatasourceOwnerTable ou DatasourceOwnerKey non trouvés.' ;
  GS_GROUP_INCLUDE_LIST = 'Liste d''inclusion';
  GS_GROUP_EXCLUDE_LIST = 'Liste d''exclusion';

  GS_IMAGE_MAUVAISE_TAILLE = 'La taille de l''image doit être au moins de 32 sur 32.' ;
  GS_IMAGE_DEFORMATION = 'L''image sera déformée, continuer ?' ;
  GS_IMAGE_MAUVAISE_IMAGE = 'Mauvais format d''image.' ;

 // Composants
  GS_SUPPRIMER_QUESTION = 'Confirmez-vous l''effacement de l''enregistrement ?' ;
  GS_CHARGEMENT_IMPOSSIBLE_FIELD_IMAGE  = 'Il est impossible de charger l''enregistrement de l''image.' ;
  GS_CHARGEMENT_IMPOSSIBLE_STREAM_IMAGE = 'Il est impossible de charger le flux image.' ;
  GS_CHARGEMENT_IMPOSSIBLE_STREAM_FIELD = 'Il est impossible de charger le flux image dans le champ.' ;
  GS_CHARGEMENT_IMPOSSIBLE_FILE_IMAGE   = 'Il est impossible de charger le fichier image.' ;
  GS_ERREUR_OUVERTURE = 'Erreur à l''ouverture @ARG.' ;
  GS_FORM_ABANDON_OUVERTURE = 'Abandon de l''ouverture de la fiche @ARG...' ;
  GS_FirstRecord = 'Premier enregistrement';
  Gs_GROUPVIEW_Basket = 'Retour origine';
  Gs_GROUPVIEW_Record = 'Enregistrer';
  Gs_GROUPVIEW_Abort  = 'Abandonner';

  GS_PriorRecord = 'Enregistrement précédent';
  GS_NextRecord = 'Enregistrement suivant';
  GS_LastRecord = 'Dernier enregistrement';
  GS_InsertRecord = 'Insérer enregistrement';
  GS_DeleteRecord = 'Supprimer l''enregistrement';
  GS_EditRecord = 'Modifier l''enregistrement';
  GS_PostEdit = 'Valider modifications';
  GS_CancelEdit = 'Annuler les modifications';
  GS_ConfirmCaption = 'Confirmation';
  GS_RefreshRecord = 'Rafraîchir les données';
  GS_SearchRecord = 'Rechercher' ;
  GS_MoveNextRecord = 'Déplacer l''enregistrement au suivant' ;
  GS_MovePreviousRecord = 'Déplacer l''enregistrement au précédent' ;
  GS_SetBookmarkRecord = 'Marquer L''enregistrement' ;
  GS_GotoBookmarkRecord = 'Aller à l''enregistrement Marqué' ;

  // SGBD
 
 {$IFDEF FPC}
  SCloseButton = '&Fermer' ;
 {$ENDIF}

  // Erreurs
  GS_ERREUR_NOMBRE_GRAND = 'Problème à la validation du nombre :' + #13#10
                   + 'Un nombre saisi est trop grand.' + #13#10
                   + 'Modifier la saisie ou annuler.' ;
  GS_METTRE_A_JOUR_FICHE = 'L''enregistrement a été effacé ou modifié par un autre utilisateur.' + #13 + #10
                        			+ 'La fiche va être mise à jour.' ;
  GS_VALEUR_UTILISEE   = 'La valeur @ARG est déjà utilisée.' + #13 + #10
                        		+ 'Saisir une valeur différente, annuler ou réeffectuer la validation si une valeur n''est pas modifiable.' ;
  GS_VALEURS_UTILISEES = 'Les valeurs @ARG sont déjà utilisées.' + #13 + #10
                        		+ 'Saisir des valeurs différentes, annuler ou réeffectuer la validation si une valeur n''est pas modifiable.' ;
  GS_ERREUR_RESEAU = 'Erreur réseau.' + #13#10
                        + 'Vérifier la connexion réseau.' ;
  GS_ERREUR_MODIFICATION_MAJ = 'Impossible de supprimer cet enregistrement.' + #13#10
               + 'Il est utilisé dans une autre fonction.';
  GS_ERREUR_CONNEXION = 'Un problème est survenu pour la connexion aux données.' + #13#10
                        	 + 'Réessayez d''ouvrir la fiche.' ;
                        //GS_CHANGEMENTS_SAUVER = 'Des changements ont été effectués.' + #13#10 +' Le trie nécessite alors une sauvegarde.'  + #13#10 + 'Voulez-vous enregistrer les changements effectués ?' ;

 // Messages pour les images
  GS_IMAGE_MULTIPLE_5 = 'L''image doit avoir une largeur multiple de ' ;
  GS_IMAGE_DOIT_ETRE = 'La taille de l''image doit être de ' ;
  GS_IMAGE_HAUTEUR = 'L''image doit avoir une hauteur de ' ;
  GS_IMAGE_TROP_PETITE = 'L''image est trop petite.' ;
  GS_IMAGE_TROP_GRANDE = 'L''image est trop grande.' ;
  GS_FICHIER_NON_TROUVE = 'Fichier @ARG non trouvé.' ;

 // Messages pour le navigateur
  GS_INSERER_ENREGISTREMENT = 'Insérer un enregistrement' ;
  GS_VALIDER_MODIFICATIONS  = 'Valider les modifications' ;

  GS_NAVIGATEUR_VERS_LE_BAS  = 'Déplacer la ligne vers le bas' ;
  GS_NAVIGATEUR_VERS_LE_HAUT = 'Déplacer la ligne vers le haut' ;

  GS_PB_CONNEXION = 'La connexion a échouée.' + #13 + #10
                      + 'Veuillez contacter votre administrateur.';
  GS_DECONNECTER_ANNULE = 'Annulation de la déconnexion';
var
  gb_MainFormIniOneUserOnServer : Boolean = False ;
{$IFDEF EADO}
  GB_ASYNCHRONE_PAR_DEFAUT : Boolean = False ;
{$ENDIF}
implementation

initialization
{$IFDEF VERSIONS}
  p_ConcatVersion ( gVer_unite_messages );
{$ENDIF}
end.

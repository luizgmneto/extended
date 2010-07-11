{*********************************************************************}
{                                                                     }
{                                                                     }
{             Matthieu Giroux                                         }
{             register TOnFormInfoIni :                                       }
{             Objet de sauvegarde d'informations de Forms             }
{             20 Février 2003                                         }
{                                                                     }
{                                                                     }
{*********************************************************************}

unit u_regonforminfoini;

{$IFDEF FPC}
{$mode Delphi}
{$ENDIF}

interface
// Listes des informations sauvegardées dans le fichier ini de l'application :
// Les données objets Edit
// La position des Objets (avec l'utilisation des Panels et des RxSplitters et RbSplitter)
// L'index de la pageactive des PageControls (onglets)
// L'index des objets CheckBoxex, RadioBoutons, RadioGroups ,PopupMenus
// les positions de la fenêtre

uses
{$IFDEF FPC}
  lresources,
{$ELSE}
  Windows,
{$ENDIF}
  Classes;

procedure Register;

implementation

uses U_OnFormInfoIni;



procedure Register;
begin
  RegisterComponents('Extended', [TOnFormInfoIni]);
end;

initialization
{$IFDEF FPC}
  {$i U_OnFormInfoIni.lrs}
{$ENDIF}
end.

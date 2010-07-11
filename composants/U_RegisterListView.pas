{*********************************************************************}
{                                                                     }
{                                                                     }
{             Matthieu Giroux                                         }
{             Register list view :                                       }
{             Objet de sauvegarde d'informations de Forms             }
{             20 Février 2007                                         }
{                                                                     }
{                                                                     }
{*********************************************************************}

unit U_RegisterListView;

{$I ..\Compilers.inc}
{$IFDEF FPC}
{$mode objfpc}{$H+}
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
  LCLIntf, PropEdits,ComponentEditors, dbpropedits, TypInfo,
{$ELSE}
  Windows,  DBreg, DesignIntf,
{$ENDIF}
{$IFDEF FPC}
  lresources,
{$ENDIF}
  SysUtils, Classes, Graphics, Controls ;



procedure Register;


implementation

uses U_DBListView  ;

 ///////////////////////////////////////////////////////////////
// TDataFieldOwnerProperty                                   //
//////////////////////////////////////////////////////////////

 ///////////////////////////////////////////////////////////////
// Register                                                  //
//////////////////////////////////////////////////////////////

procedure Register;
begin
  RegisterComponents('Extended', [TDBListView]);
  RegisterPropertyEditor ( TypeInfo({$IFDEF FPC}ShortString {$ELSE}string{$ENDIF}), TDBListView, 'DataKeyUnit'   , {$IFDEF FPC}TFieldProperty{$ELSE}TDataFieldProperty{$ENDIF});
  RegisterPropertyEditor ( TypeInfo({$IFDEF FPC}ShortString {$ELSE}string{$ENDIF}), TDBListView, 'DataSort'      , {$IFDEF FPC}TFieldProperty{$ELSE}TDataFieldProperty{$ENDIF});
  RegisterPropertyEditor ( TypeInfo(string), TDBListView, 'DataFieldsDisplay'   , {$IFDEF FPC}TFieldProperty{$ELSE}TDataFieldProperty{$ENDIF});
end;
initialization
{$IFDEF FPC}
  {$i U_DBListView.lrs}
{$ENDIF}
end.

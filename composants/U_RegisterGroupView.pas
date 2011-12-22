{*********************************************************************}
{                                                                     }
{                                                                     }
{             Matthieu Giroux                                         }
{             Register Group View :                                       }
{             Objet de sauvegarde d'informations de Forms             }
{             20 Février 2007                                         }
{                                                                     }
{                                                                     }
{*********************************************************************}

unit U_RegisterGroupView;

{$I ..\DLCompilers.inc}
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
  LCLIntf, PropEdits,ComponentEditors, dbpropedits, DB, TypInfo,
  lresources,
{$ELSE}
  Windows,  DBreg, DesignIntf,
{$ENDIF}
  SysUtils, Classes, Graphics, Controls ;

type

  TDataFieldOwnerProperty = class({$IFDEF FPC}TFieldProperty{$ELSE}TDataFieldProperty{$ENDIF})
  public
    {$IFDEF FPC}
    procedure FillValues(const Values: TStringList); override;
    {$ELSE}
    function GetDataSourcePropName: string; override;
    {$ENDIF}
  end;


procedure Register;


implementation

uses U_GroupView, unite_messages  ;

 ///////////////////////////////////////////////////////////////
// TDataFieldOwnerProperty                                   //
//////////////////////////////////////////////////////////////
{$IFDEF FPC}
procedure TDataFieldOwnerProperty.FillValues(const Values: TStringList);
var
  DataSource: TDataSource;
begin
  DataSource := GetObjectProp(GetComponent(0), 'DataSourceOwner') as TDataSource;
  if (DataSource is TDataSource) and Assigned(DataSource.DataSet) then
    DataSource.DataSet.GetFieldNames(Values);

{$ELSE}
function TDataFieldOwnerProperty.GetDataSourcePropName: string;
begin
  Result := 'DataSourceOwner';

{$ENDIF}
end;

 ///////////////////////////////////////////////////////////////
// Register                                                  //
//////////////////////////////////////////////////////////////

procedure Register;
begin
  RegisterComponents(CST_PALETTE_COMPOSANTS_DB, [TDBGroupView]);
  RegisterPropertyEditor ( TypeInfo({$IFDEF FPC}ShortString {$ELSE}string{$ENDIF}), TDBGroupView, 'DataFieldGroup', {$IFDEF FPC}TFieldProperty{$ELSE}TDataFieldProperty{$ENDIF});
  RegisterPropertyEditor ( TypeInfo({$IFDEF FPC}ShortString {$ELSE}string{$ENDIF}), TDBGroupView, 'DataFieldUnit' , {$IFDEF FPC}TFieldProperty{$ELSE}TDataFieldProperty{$ENDIF});
  RegisterPropertyEditor ( TypeInfo({$IFDEF FPC}ShortString {$ELSE}string{$ENDIF}), TDBGroupView, 'DataKeyOwner'  , TDataFieldOwnerProperty);
end;

end.

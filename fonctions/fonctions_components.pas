unit fonctions_components;

interface

{$IFDEF FPC}
{$mode Delphi}
{$ENDIF}

{$I ..\DLCompilers.inc}
{$I ..\extends.inc}

uses SysUtils,
  {$IFDEF VERSIONS}
  fonctions_version,
  {$ENDIF}
  Controls, StdCtrls, 
  Classes ;

  {$IFDEF VERSIONS}
const
  gVer_fonctions_components : T_Version = ( Component : 'Fonctions de personnalisation des composants' ;
                                         FileUnit : 'fonctions_components' ;
      			                 Owner : 'Matthieu Giroux' ;
      			                 Comment : 'Fonctions de gestion des composants visuels.' ;
      			                 BugsStory : 'Version 1.0.1.0 : Auto combo init.'+#10
                                                   + 'Version 1.0.0.0 : Ajout de fonctions d''automatisation.';
      			                 UnitType : 1 ;
      			                 Major : 1 ; Minor : 0 ; Release : 1 ; Build : 0 );

  {$ENDIF}

procedure p_ComponentSelectAll ( const aobj_Component : TObject );
function  fb_AutoComboInit ( const acom_Combo : TComponent ):Boolean;

implementation

uses Variants,  Math, fonctions_erreurs, fonctions_string, unite_messages,
     fonctions_proprietes, fonctions_init ;

function fb_AutoComboInit ( const acom_Combo : TComponent ):Boolean;
var astl_Items : TStrings;
Begin

  astl_Items:= TStrings( fobj_getComponentObjectProperty ( acom_Combo, CST_INI_ITEMS ));
  if ( astl_Items = nil )
  or ( astl_Items.Count = 0 )
   Then
     Begin
      Result:=False;
      Exit;
     end;
  if ( flin_getComponentProperty( acom_Combo, CST_INI_ITEMINDEX ) < 0 )
   Then
    p_SetComponentProperty( acom_Combo, CST_INI_ITEMINDEX, 0 );
  p_SetComponentProperty( acom_Combo, CST_INI_TEXT, astl_Items[flin_getComponentProperty( acom_Combo, CST_INI_ITEMINDEX )]);
  Result := True;
end;

procedure p_ComponentSelectAll ( const aobj_Component : TObject );
Begin
  if aobj_Component is TCustomEdit Then
    (aobj_Component as TCustomEdit ).SelectAll;
End;

{$IFDEF VERSIONS}
initialization
  p_ConcatVersion ( gVer_fonctions_components );
{$ENDIF}
end.

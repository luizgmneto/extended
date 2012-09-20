{*********************************************************************}
{                                                                     }
{                                                                     }
{             Matthieu Giroux                                         }
{             TExtNumEdit  :                                          }
{             Composant edit de nombre                                }
{             TExtDBNumEdit :                                         }
{             Composant dbedit de nombre                              }
{             22 Avril 2006                                           }
{                                                                     }
{                                                                     }
{*********************************************************************}

unit u_extcomponent;

{$I ..\DLCompilers.inc}
{$I ..\extends.inc}
{$IFDEF FPC}
{$mode Delphi}
{$ENDIF}

interface

uses Graphics,StdCtrls,
{$IFDEF VERSIONS}
     fonctions_version,
{$ENDIF}
{$IFDEF TNT}
   TntStdCtrls,
{$ENDIF}
     Controls, Classes, Menus ;

const
  //////// Couleurs par défaut des composants de la form
  CST_EXT_BACK    = TColor(clWindow and $00888888);
  CST_LBL_STD       = clWindowText;
  CST_LBL_SELECT    = {$IFDEF FPC}clActiveText{$ELSE}clActiveCaption{$ENDIF};
  CST_LBL_ACTIVE    = {$IFDEF FPC}clActiveBrightText{$ELSE}clActiveCaption{$ENDIF};
  CST_EDIT_SELECT   = TColor($0055AAAA + CST_EXT_BACK);
  CST_EDIT_STD      = TColor($00AAAAAA + CST_EXT_BACK);
  CST_EDIT_READ     = TColor($00448844 + CST_EXT_BACK);
  CST_GRID_SELECT   = TColor($0055AAAA + CST_EXT_BACK);
  CST_GRID_STD      = TColor($00AAAAAA + CST_EXT_BACK);
  CST_TEXT_INACTIF  = clBtnText;


// Le Ifwcomponent possède :
// Une couleur d'édition et une couleur standard
// Il peut etre mis en lecture seule
{$IFDEF VERSIONS}
  const
    gVer_ExTComponent : T_Version = ( Component : 'Unité parente des FW Components' ;
                                               FileUnit : 'u_extcomponent' ;
                                               Owner : 'Matthieu Giroux' ;
                                               Comment : 'Interface réutilisée centralisant les composants FW.' ;
                                               BugsStory : '1.0.1.1 : EDITSCOLOR compile option.' + #13#10
                                                         + '1.0.1.0 : Adapting to OS''s themes.' + #13#10
                                                         + '1.0.0.1 : UTF 8.' + #13#10
                                                         + '1.0.0.0 : En place testée.' + #13#10
                                                         + '0.9.0.0 : En place à tester.';
                                               UnitType : 1 ;
                                               Major : 1 ; Minor : 0 ; Release : 1 ; Build : 1 );

{$ENDIF}

type IFWComponent = interface
     End;
     // Doit être un twincontrol d'édition
   IFWComponentEdit = interface
   ['{62CAE27F-94C1-4A3D-B94F-FE57A36207D5}'] // GUID nécessaire pour l'opération de cast
       procedure SetOrder ;
     End;
   // interfaces
   TPopUpMenuEvent = procedure ( Sender:TObject;var APopupMenu:TPopupMenu;var AHandled:Boolean) of object;

var
    // Couleurs à mettre sur les composants
    gCol_EditSelect  : TColor = CST_EDIT_SELECT ;
    gCol_EditRead    : TColor = CST_EDIT_READ ;
    gCol_Edit        : TColor = CST_EDIT_STD ;
    gCol_GridSelect  : TColor = CST_GRID_SELECT ;
    gCol_Grid        : TColor = CST_GRID_STD ;
    gCol_TextInActive: TColor = CST_TEXT_INACTIF ;
  // Couleur du label
    gCol_Label       : TColor = CST_LBL_STD ;
    gCol_LabelActive : TColor = CST_LBL_ACTIVE ;
    gCol_LabelSelect : TColor = CST_LBL_SELECT ;

procedure p_setLabelColorEnter ( const FLabel : {$IFDEF TNT}TTntLabel{$ELSE}TLabel{$ENDIF}; const FLabelColor : TColor ; const FAlwaysSame : boolean  );
procedure p_setCompColorEnter ( const Fcomponent : TControl; const FFocusColor : TColor ; const FAlwaysSame : boolean  );
procedure p_setLabelColorExit  ( const FLabel : {$IFDEF TNT}TTntLabel{$ELSE}TLabel{$ENDIF}; const FAlwaysSame : boolean  );
procedure p_setCompColorExit ( const Fcomponent : TControl; const FColor : TColor ; const FAlwaysSame : boolean  );
procedure p_setCompColorReadOnly ( const Fcomponent : TControl; const FEditColor, FReadOnlyColor : TColor ; const FAlwaysSame, FReadOnly : boolean  );
function fb_ShowPopup ( const AControl : TControl; const APopUpMenu : TPopUpMenu ; const ABeforePopup : TPopUpMenuEvent ; const AOnPopup : TNotifyEvent ):Boolean;

implementation

uses fonctions_proprietes;


function fb_ShowPopup ( const AControl : TControl; const APopUpMenu : TPopUpMenu ; const ABeforePopup : TPopUpMenuEvent ; const AOnPopup : TNotifyEvent ):Boolean;
var lp_pos : TPoint;
    LPopupMenu : TPopupMenu;
begin
  if Assigned(APopUpMenu) Then
    Begin
     Result := True;
     LPopupMenu := APopUpMenu;
     if Assigned(ABeforePopup) Then
       ABeforePopup ( AControl, LPopupMenu, Result );
     if Result Then
     with AControl do
       Begin
         lp_pos.X := Width;
         lp_pos.Y := Top ;
         {if Owner is TControl
          Then lp_pos := ( Owner as TControl).ScreenToClient ( ControlToScreen( lp_pos ))
          Else} lp_pos := ClientToScreen( lp_pos );
         LPopupMenu.Popup(lp_pos.X,lp_pos.Y);
         if Assigned(AOnPopup) Then
           AOnPopup ( AControl );
       end;
    end
   Else Result := False;
end;

procedure p_setCompColorEnter ( const Fcomponent : TControl; const FFocusColor : TColor ; const FAlwaysSame : boolean  );
Begin
  {$IFDEF EDITSCOLOR}
   if FAlwaysSame  Then
     p_SetComponentProperty ( Fcomponent, 'Color', gCol_EditSelect )
    else
     p_SetComponentProperty ( Fcomponent, 'Color', FFocusColor )
  {$ENDIF}
End;
procedure p_setCompColorReadOnly ( const Fcomponent : TControl; const FEditColor, FReadOnlyColor : TColor ; const FAlwaysSame, FReadOnly : boolean  );
Begin
  {$IFDEF EDITSCOLOR}
  if FAlwaysSame  Then
    if FReadOnly Then
      p_SetComponentProperty ( Fcomponent, 'Color', gCol_EditRead )
    else
      p_SetComponentProperty ( Fcomponent, 'Color', gCol_Edit )
   else
    if FReadOnly Then
      p_SetComponentProperty ( Fcomponent, 'Color', FReadOnlyColor )
    else
      p_SetComponentProperty ( Fcomponent, 'Color', FEditColor );
  {$ENDIF}
End;
procedure p_setCompColorExit ( const Fcomponent : TControl; const FColor : TColor ; const FAlwaysSame : boolean  );
Begin
  {$IFDEF EDITSCOLOR}
  if FAlwaysSame  Then
    p_SetComponentProperty ( Fcomponent, 'Color', gCol_Edit )
   else
     p_SetComponentProperty ( Fcomponent, 'Color', FColor )
  {$ENDIF}
End;

procedure p_setLabelColorExit  ( const FLabel : {$IFDEF TNT}TTntLabel{$ELSE}TLabel{$ENDIF}; const FAlwaysSame : boolean  );
Begin
 if assigned ( FLabel )
   Then
    Begin
       if FAlwaysSame  Then
         FLabel.Font.Color := gCol_Label
        else
         if FLabel.ClassNameIs ( 'TFWLabel' ) then
           FLabel.Font.Color := flin_getComponentProperty ( FLabel, 'OldColor' );
    End ;
End;
procedure p_setLabelColorEnter ( const FLabel : {$IFDEF TNT}TTntLabel{$ELSE}TLabel{$ENDIF}; const FLabelColor : TColor ; const FAlwaysSame : boolean  );
Begin
  if assigned ( FLabel )
   Then
      Begin
       if FAlwaysSame  Then
         FLabel.Font.Color := gCol_LabelSelect
        else
         FLabel.Font.Color := FLabelColor;
      End;
End;

{$IFDEF VERSIONS}
initialization
  p_ConcatVersion ( gVer_ExtComponent );
{$ENDIF}
end.

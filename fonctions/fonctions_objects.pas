unit fonctions_objects;

{$IFDEF FPC}
{$mode Delphi}
{$ENDIF}

interface

uses
  Classes, SysUtils,
  {$IFDEF VERSIONS}
  fonctions_version,
  {$ENDIF}
  Menus;

{$IFDEF VERSIONS}
const
    gVer_fonctions_objects : T_Version = ( Component : 'Clônages d''objets' ;
       			                 FileUnit : 'fonctions_objects' ;
       			                 Owner : 'Matthieu Giroux' ;
       			                 Comment : 'Clônage d''objets pour les composants génériques.' ;
      			                 BugsStory : 'Version 1.0.0.0 : First Unit.' + #13#10 ;
			                 UnitType : CST_TYPE_UNITE_FONCTIONS ;
			                 Major : 1 ; Minor : 0 ; Release : 0 ; Build : 0 );
{$ENDIF}

function fmi_CloneMenuItem ( const AMenuItem : TMenuItem; const amenuDestination : TMenu ): TMenuItem ;

implementation

function fmi_CloneMenuItem ( const AMenuItem : TMenuItem; const amenuDestination : TMenu ): TMenuItem ;
Begin
  Result := TMenuItem.Create ( amenuDestination );
  with Result do
   Begin
     Name       := AMenuItem.Name;
     Tag        := AMenuItem.Tag;
     Caption    := AMenuItem.Caption;
     ImageIndex := AMenuItem.ImageIndex;
     OnClick    := AMenuItem.OnClick;
     Action     := AMenuItem.Action;
   end;
end;

{$IFDEF VERSIONS}
initialization
  p_ConcatVersion ( gVer_fonctions_objects );
{$ENDIF}
end.


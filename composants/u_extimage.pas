unit U_ExtImage;

interface

{$i ..\extends.inc}
{$IFDEF FPC}
{$Mode Delphi}
{$ENDIF}

uses Graphics,
{$IFDEF TNT}
     TntExtCtrls,
{$ELSE}
     ExtCtrls,
{$ENDIF}
{$IFDEF VERSIONS}
  fonctions_version,
{$ENDIF}
     DB, DBCtrls,
     Classes;

{$IFDEF VERSIONS}
  const
    gVer_TExtImage : T_Version = ( Component : 'Composant TExtImage' ;
                                               FileUnit : 'U_ExtDBImage' ;
                                               Owner : 'Matthieu Giroux' ;
                                               Comment : 'Gestion d''images de tous types dans les données.' ;
                                               BugsStory : '0.9.0.0 : Creating from TExtDBImage.';
                                               UnitType : 3 ;
                                               Major : 0 ; Minor : 9 ; Release : 0 ; Build : 0 );

{$ENDIF}

type TExtImage = class( {$IFDEF TNT}TTntImage{$ELSE}TImage{$ENDIF} )
     public
       procedure LoadFromStream ( const astream : TStream ); virtual;
       function  LoadFromFile   ( const afile   : String ):Boolean; virtual;
     end;


implementation

uses fonctions_images, Controls;

{ TExtImage }


function TExtImage.LoadFromFile(const afile: String):Boolean;
begin
  Result := False;
  p_SetFileToImage(afile, Self.Picture, True);
  Result := True;
end;

procedure TExtImage.LoadFromStream(const astream: TStream);
begin
  p_SetStreamToImage( astream, Self.Picture, True );
end;


{$IFDEF VERSIONS}
initialization
  p_ConcatVersion ( gVer_TExtImage );
{$ENDIF}
end.

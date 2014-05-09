unit U_ExtImage;

interface

{$i ..\extends.inc}
{$IFDEF FPC}
{$Mode Delphi}
{$ENDIF}

uses
{$IFDEF TNT}
     TntExtCtrls,
{$ELSE}
     ExtCtrls,
{$ENDIF}
{$IFDEF VERSIONS}
  fonctions_version,
{$ENDIF}
     Classes,
  u_extcomponent;

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

type

{ TExtImage }

TExtImage = class( {$IFDEF TNT}TTntImage{$ELSE}TImage{$ENDIF}, IFWComponent )
     private
       FShowErrors : Boolean ;
       procedure p_SetFileName  ( const Value : String ); virtual;
     protected
       FFileName : String;
     public
       procedure LoadFromStream ( const astream : TStream ); virtual;
       function  LoadFromFile   ( const afile   : String ):Boolean; virtual;
       constructor Create(AOwner: TComponent); override;
       procedure Loaded; override;
     published
       property FileName : String read FFileName write p_SetFileName ;
       property ShowErrors : Boolean read FShowErrors write FShowErrors default True ;
     end;


implementation

uses fonctions_images, sysutils;

{ TExtImage }


function TExtImage.LoadFromFile(const afile: String):Boolean;
begin
  Result := False;
  FFileName:=afile;
  if FileExists ( FFileName ) Then
    p_FileToImage(FFileName, Self.Picture, FShowErrors);
  Result := True;
end;

constructor TExtImage.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FShowErrors:=True;
end;

procedure TExtImage.Loaded;
begin
  inherited Loaded;
  LoadFromFile(FFileName);
end;

procedure TExtImage.p_SetFileName(const Value: String);
begin
  LoadFromFile(Value);
end;

procedure TExtImage.LoadFromStream(const astream: TStream);
begin
  p_StreamToImage( astream, Self.Picture.Bitmap, 0, 0, False, FShowErrors );
end;


{$IFDEF VERSIONS}
initialization
  p_ConcatVersion ( gVer_TExtImage );
{$ENDIF}
end.

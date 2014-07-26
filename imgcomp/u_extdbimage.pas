unit U_ExtDBImage;

interface

{$i ..\extends.inc}
{$IFDEF FPC}
{$Mode Delphi}
{$ENDIF}

uses Graphics,
{$IFDEF VERSIONS}
  fonctions_version,
{$ENDIF}
     DB, DBCtrls,
     Classes, U_ExtImage;

{$IFDEF VERSIONS}
const
    gVer_TExtDBImage : T_Version = ( Component : 'Composant TExtDBImage' ;
                                               FileUnit : 'U_ExtDBImage' ;
                                               Owner : 'Matthieu Giroux' ;
                                               Comment : 'Gestion d''images de tous types dans les données.' ;
                                               BugsStory : 'Version 1.0.0.3 : UTF 8.' + #13#10
                                                         + 'Version 1.0.0.2 : Upgrading from tested functions.' + #13#10
                                                         + 'Version 1.0.0.1 : Creating ExtImage.' + #13#10
                                                         + 'Version 1.0.0.0 : En place, tout a été testé.' + #13#10
                                                         + 'Version 0.9.0.1 : En place, tout n''a pas été testé.' + #13#10
                                                         + '0.9.0.0 : Simple affiche de toute image en données.';
                                               UnitType : 3 ;
                                               Major : 1 ; Minor : 0 ; Release : 0 ; Build : 3 );

{$ENDIF}
type

{ TExtDBImage }

   TExtDBImage = class( TExtImage)
     private
       FDataLink: TFieldDataLink;
       procedure p_SetDatafield  ( const Value : String );
       procedure p_SetDatasource ( const Value : TDatasource );
       function  fds_GetDatasource : TDatasource;
       function  fs_GetDatafield : String;
       function  ff_Getfield : TField;
     protected
       procedure p_SetImage; virtual;
       procedure p_ActiveChange(Sender: TObject); virtual;
       procedure p_DataChange(Sender: TObject); virtual;
       procedure p_UpdateData(Sender: TObject); virtual;
     public
       procedure LoadFromStream ( const astream : TStream ); override;
       function  LoadFromFile   ( const afile   : String ):Boolean;  override;
       procedure SaveToStream ( const astream : TMemoryStream ); virtual;
       function  SavetoFile   ( const afile   : String ):Boolean; overload; override;
       constructor Create(AOwner: TComponent); override;
       destructor Destroy ; override;
       property Field : TField read ff_Getfield;
     published
       property Datafield : String read fs_GetDatafield write p_SetDatafield ;
       property Datasource : TDatasource read fds_GetDatasource write p_SetDatasource ;
     end;


implementation

uses fonctions_images,
     Controls,
     {$IFDEF FPC}
     FileUtil,
     {$ENDIF}
     sysutils;

{ TExtDBImage }

procedure TExtDBImage.p_ActiveChange(Sender: TObject);
begin
  p_SetImage;
end;

constructor TExtDBImage.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDataLink := TFieldDataLink.Create ;
  FDataLink.DataSource := nil ;
  FDataLink.FieldName  := '' ;
  FDataLink.Control := Self;
  FDataLink.OnDataChange := p_DataChange;
  FDataLink.OnUpdateData := p_UpdateData;
  FDataLink.OnActiveChange := p_ActiveChange;
end;

procedure TExtDBImage.p_DataChange(Sender: TObject);
begin
  p_SetImage;
end;

destructor TExtDBImage.Destroy;
begin
  FDataLink.Free;
  inherited;
end;

function TExtDBImage.fs_GetDatafield: String;
begin
  if assigned ( FDataLink ) then
    Begin
      Result := FDataLink.FieldName ;
    End
   Else
    Result := '';

end;

function TExtDBImage.ff_Getfield: TField;
begin
  Result:=FDataLink.Field;
end;

function TExtDBImage.LoadFromFile(const afile: String):Boolean;
begin
  Result := False;
  FFileName:=afile;
  if  assigned ( FDataLink.Field )
  and FDataLink.CanModify
  and FileExistsUTF8(FFileName) then
    Begin
      FDataLink.Edit;
      p_ImageFileToField(FFileName, FDataLink.Field, ShowErrors);
      Result := True;
    End;
end;

procedure TExtDBImage.SaveToStream(const astream: TMemoryStream);
begin
  if  assigned ( FDataLink.Field ) then
    Begin
      p_ImageFieldToStream ( FDataLink.Field, astream, ShowErrors );
    end;
end;

function TExtDBImage.SavetoFile(const afile: String): Boolean;
begin
  if  assigned ( FDataLink.Field ) then
    Begin
      fb_ImageFieldToFile ( FDataLink.Field, afile, 0, 0, True, ShowErrors );
    end;
end;

procedure TExtDBImage.LoadFromStream(const astream: TStream);
begin
  if  assigned ( FDataLink.Field ) then
    Begin
      p_StreamToField( astream, FDataLink.Field, ShowErrors );
    End;
end;

function TExtDBImage.fds_GetDatasource: TDatasource;
begin
  if assigned ( FDataLink ) then
    Begin
      Result := FDataLink.Datasource ;
    End
   Else
    Result := Datasource;

end;

procedure TExtDBImage.p_SetDatafield(const Value: String);
begin
  if assigned ( FDataLink )
  and ( Value <> FDataLink.FieldName ) then
    Begin
      FDataLink.FieldName := Value;
    End;
end;

procedure TExtDBImage.p_SetDatasource(const Value: TDatasource);
begin
  if assigned ( FDataLink )
  and ( Value <> FDataLink.Datasource ) then
    Begin
      FDataLink.Datasource := Value;
    End;
end;

procedure TExtDBImage.p_SetImage;
begin
  if assigned ( FDataLink )
  and assigned ( FDataLink.Field )
  and not FDataLink.Field.IsNull
   Then
    Begin
      p_FieldToImage ( FDataLink.Field, Self.Picture.Bitmap, 0, 0, False, ShowErrors );
    End
   Else
    Picture.Bitmap.Assign(nil);
end;

procedure TExtDBImage.p_UpdateData(Sender: TObject);
begin
  p_SetImage;
end;

{$IFDEF VERSIONS}
initialization
  p_ConcatVersion ( gVer_TExtDBImage );
{$ENDIF}
end.

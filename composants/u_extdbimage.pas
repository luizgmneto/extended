unit U_ExtDBImage;

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
       FPainted : Boolean;
       procedure p_SetDatafield  ( const Value : String );
       procedure p_SetDatasource ( const Value : TDatasource );
       function  fds_GetDatasource : TDatasource;
       function  fs_GetDatafield : String;
     protected
       procedure p_SetImage; virtual;
       procedure p_ActiveChange(Sender: TObject); virtual;
       procedure p_DataChange(Sender: TObject); virtual;
       procedure p_UpdateData(Sender: TObject); virtual;
     public
       procedure Paint; override;
       procedure LoadFromStream ( const astream : TStream ); override;
       function  LoadFromFile   ( const afile   : String ):Boolean;  override;
       procedure SaveToStream ( const astream : TMemoryStream ); virtual;
       function  SavetoFile   ( const afile   : String ;const ali_newWidth : Longint ; const ali_newHeight : Longint = 0 ; const ab_KeepProportion : Boolean = True ):Boolean;  virtual;overload;
       function  SavetoFile:Boolean;  virtual;overload;
       constructor Create(AOwner: TComponent); override;
       destructor Destroy ; override;
     published
       property Datafield : String read fs_GetDatafield write p_SetDatafield ;
       property Datasource : TDatasource read fds_GetDatasource write p_SetDatasource ;
     end;


implementation

uses fonctions_images, Controls,sysutils,ExtDlgs;

{ TExtDBImage }

procedure TExtDBImage.p_ActiveChange(Sender: TObject);
begin
  p_SetImage;
  if assigned ( FDataLink.Field )
  and not FDataLink.Field.IsNull
   Then
    FPainted:=False;
end;

constructor TExtDBImage.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FPainted:=True;
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

function TExtDBImage.LoadFromFile(const afile: String):Boolean;
begin
  Result := False;
  FFileName:=afile;
  if  assigned ( FDataLink.Field )
  and FileExists(FFileName) then
    Begin
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

function TExtDBImage.SavetoFile(const afile: String;
  const ali_newWidth: Longint; const ali_newHeight: Longint;
  const ab_KeepProportion: Boolean): Boolean;
begin
  if  assigned ( FDataLink.Field ) then
    Begin
      fb_ImageFieldToFile ( FDataLink.Field, afile, ali_newWidth, ali_newHeight, ab_KeepProportion, ShowErrors );
    end;
end;

function TExtDBImage.SavetoFile: Boolean;
var LSaveDialog : TSavePictureDialog;
begin
  LSaveDialog:=TSavePictureDialog.Create(Self);
  if LSaveDialog.Execute
   Then Result := SavetoFile(LSaveDialog.FileName,0,0,True)
   Else Result := False;
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
  and FDataLink.CanModify
  and assigned ( FDataLink.Field )
  and not FDataLink.Field.IsNull
  and FPainted
   Then
    Begin
      p_FieldToImage ( FDataLink.Field, Self.Picture, ShowErrors );
    End
   Else
    Picture.Bitmap.Assign(nil);
end;

procedure TExtDBImage.p_UpdateData(Sender: TObject);
begin
  p_SetImage;
end;

procedure TExtDBImage.Paint;
begin
  FPainted:=True;
  inherited Paint;
end;

{$IFDEF VERSIONS}
initialization
  p_ConcatVersion ( gVer_TExtDBImage );
{$ENDIF}
end.

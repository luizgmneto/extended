unit U_ExtDBImageList;

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
  DB, DBCtrls, ImgList,
  Classes, U_ExtImage, U_ExtMapImageIndex,
  u_extcomponent;

{$IFDEF VERSIONS}
  const
    gVer_TExtDBImageList : T_Version = ( Component : 'Composant TExtDBImageList' ;
                                               FileUnit : 'U_ExtDBImageList' ;
                                               Owner : 'Matthieu Giroux' ;
                                               Comment : 'Gestion de liste d''images dans les données.' ;
                                               BugsStory : '0.9.9.1 : UTF 8.' + #13#10 +
                                                           '0.9.9.0 : Tested and optimised.' + #13#10 +
                                                           '0.9.0.0 : Non testée.';
                                               UnitType : 3 ;
                                               Major : 0 ; Minor : 9 ; Release : 9 ; Build : 1 );

{$ENDIF}

type
{ TExtDBImageList }

    TExtDBImageList = class( TExtImage, IFWComponent, IFWComponentEdit)
     private
       FDataLink: TFieldDataLink;
       FNotifyOrder : TNotifyEvent;
       FImages : TCustomImageList;
       FMapImages : TExtMapImages;
       procedure p_SetDatafield  ( const Value : String );
       procedure p_SetDatasource ( const Value : TDatasource );
       procedure p_SetImages    ( const Value : TCustomImageList );
       procedure p_SetImagesMap ( const Value : TExtMapImages );
       function  fds_GetDatasource : TDatasource;
       function  fs_GetDatafield : String;
     protected
       procedure SetOrder ; virtual;
       procedure p_SetImage; virtual;
       procedure p_ActiveChange(Sender: TObject); virtual;
       procedure p_DataChange(Sender: TObject); virtual;
     public
       constructor Create(AOwner: TComponent); override;
       destructor Destroy ; override;
     published
       property Datafield : String read fs_GetDatafield write p_SetDatafield ;
       property Datasource : TDatasource read fds_GetDatasource write p_SetDatasource ;
       property Images : TCustomImageList read FImages write p_SetImages ;
       property ImagesMap : TExtMapImages read FMapImages write p_SetImagesMap ;
     end;


implementation

uses sysutils;

{ TExtDBImageList }

procedure TExtDBImageList.p_ActiveChange(Sender: TObject);
begin
  p_SetImage;
end;

constructor TExtDBImageList.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDataLink := TFieldDataLink.Create ;
  FDataLink.DataSource := nil ;
  FDataLink.FieldName  := '' ;
  FDataLink.Control := Self;
  FDataLink.OnDataChange := p_DataChange;
  FDataLink.OnActiveChange := p_ActiveChange;
end;

procedure TExtDBImageList.p_DataChange(Sender: TObject);
begin
  p_SetImage;
end;


destructor TExtDBImageList.Destroy;
begin
  FDataLink.Free;
  inherited;
end;

function TExtDBImageList.fs_GetDatafield: String;
begin
  if assigned ( FDataLink ) then
    Begin
      Result := FDataLink.FieldName ;
    End
   Else
    Result := '';

end;

procedure TExtDBImageList.SetOrder;
begin
  if assigned ( FNotifyOrder ) then
    FNotifyOrder ( Self );
end;

function TExtDBImageList.fds_GetDatasource: TDatasource;
begin
  if assigned ( FDataLink ) then
    Begin
      Result := FDataLink.Datasource ;
    End
   Else
    Result := Datasource;

end;

procedure TExtDBImageList.p_SetDatafield(const Value: String);
begin
  if assigned ( FDataLink )
  and ( Value <> FDataLink.FieldName ) then
    Begin
      FDataLink.FieldName := Value;
    End;
end;

procedure TExtDBImageList.p_SetDatasource(const Value: TDatasource);
begin
  if assigned ( FDataLink )
  and ( Value <> FDataLink.Datasource ) then
    Begin
      FDataLink.Datasource := Value;
    End;
end;

procedure TExtDBImageList.p_SetImage;
var li_i : Longint;
    lb_Found : Boolean ;
begin
  lb_Found := False ;
  if  assigned ( FDataLink )
  and assigned ( FImages )
  and assigned ( FMapImages )
  and FDataLink.Active
  and assigned ( FDataLink.Field )
  and not FDataLink.Field.IsNull Then
    Begin
      for li_i := 0 to FMapImages.Columns.Count - 1 do
      with FMapImages.Columns.Items [ li_i ] do
        if  ( FDataLink.Field.AsString = Value )
        and ( ImageIndex < FImages.Count )  then
          Begin
           FImages.GetBitmap ( ImageIndex , Picture.Bitmap );
           lb_Found := True ;
          End;
    End;
  if not lb_Found then
    Picture.Bitmap.Assign(nil);
end;

procedure TExtDBImageList.p_SetImages(const Value: TCustomImageList);
begin
  FImages := Value;
end;

procedure TExtDBImageList.p_SetImagesMap(const Value: TExtMapImages);
begin
  FMapImages:=Value;
end;


{$IFDEF VERSIONS}
initialization
  p_ConcatVersion ( gVer_TExtDBImageList );
{$ENDIF}
end.

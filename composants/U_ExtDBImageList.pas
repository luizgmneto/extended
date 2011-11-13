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
     Classes, U_ExtImage;

{$IFDEF VERSIONS}
  const
    gVer_TExtDBImageList : T_Version = ( Component : 'Composant TExtDBImageList' ;
                                               FileUnit : 'U_ExtDBImageList' ;
                                               Owner : 'Matthieu Giroux' ;
                                               Comment : 'Gestion de liste d''images dans les données.' ;
                                               BugsStory : '0.9.0.0 : Non testée.';
                                               UnitType : 3 ;
                                               Major : 0 ; Minor : 9 ; Release : 0 ; Build : 0 );

{$ENDIF}

type
  TExtMapImageIndex = class;
  TExtMapImagesColumns = class;

 { TExtFieldImageIndex }
  TExtMapImageIndex = class(TCollectionItem)
  private
    s_Value : String;
    i_ImageIndex : Integer ;
  public
    property Value : String read s_Value write s_Value;
    property ImageIndex : Integer read i_ImageIndex write i_ImageIndex;
  End;
  TExtMapImageIndexClass = class of TExtMapImageIndex;

 { TExtFieldImagesColumns }
  TExtMapImagesColumns = class(TCollection)
  private
    FComponent: TComponent;
    function GetImageMap( Index: Integer): TExtMapImageIndex;
    procedure SetImageMap( Index: Integer; Value: TExtMapImageIndex);
  protected
    function GetOwner: TPersistent; override;
  public
    constructor Create(Component: TComponent; ColumnClass: TExtMapImageIndexClass); virtual;
    function Add: TExtMapImageIndex; virtual;
    property Component : TComponent read FComponent;
    property Items[Index: Integer]: TExtMapImageIndex read GetImageMap write SetImageMap; default;
  End;

{ TExtDBImageList }

    TExtDBImageList = class( TExtImage)
     private
       FDataLink: TFieldDataLink;
       FImages : TCustomImageList;
       FMapImagesColumns : TExtMapImagesColumns;
       procedure p_SetDatafield  ( const Value : String );
       procedure p_SetDatasource ( const Value : TDatasource );
       procedure p_SetImages ( const Value : TCustomImageList );
       function  fds_GetDatasource : TDatasource;
       function  fs_GetDatafield : String;
     protected
       procedure p_SetImage; virtual;
       procedure p_ActiveChange(Sender: TObject); virtual;
       procedure p_DataChange(Sender: TObject); virtual;
       procedure CreateImagesMap; virtual;
     public
       constructor Create(AOwner: TComponent); override;
       destructor Destroy ; override;
     published
       property Datafield : String read fs_GetDatafield write p_SetDatafield ;
       property Datasource : TDatasource read fds_GetDatasource write p_SetDatasource ;
       property Images : TCustomImageList read FImages write p_SetImages ;
       property ImagesMap : TExtMapImagesColumns read FMapImagesColumns ;
     end;


implementation

uses fonctions_images, sysutils;

{ TExtDBImageList }

procedure TExtDBImageList.p_ActiveChange(Sender: TObject);
begin
  p_SetImage;
end;

constructor TExtDBImageList.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  CreateImagesMap;
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

procedure TExtDBImageList.CreateImagesMap;
begin
   FMapImagesColumns := TExtMapImagesColumns.Create(Self,TExtMapImageIndex);
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
  and FDataLink.Active
  and assigned ( FDataLink.Field )
  and not FDataLink.Field.IsNull Then
    Begin
      for li_i := 0 to FMapImagesColumns.Count - 1 do
      with FMapImagesColumns.Items [ li_i ] do
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

end;

{ TExtMapImagesColumns }

function TExtMapImagesColumns.Add: TExtMapImageIndex;
begin
  Result := TExtMapImageIndex(inherited Add);
end;

constructor TExtMapImagesColumns.Create(Component: TComponent;
  ColumnClass: TExtMapImageIndexClass);
begin
  inherited Create(ColumnClass);
  FComponent := Component;
end;

function TExtMapImagesColumns.GetImageMap(Index: Integer): TExtMapImageIndex;
begin
  Result := TExtMapImageIndex(inherited Items[Index]);
end;

function TExtMapImagesColumns.GetOwner: TPersistent;
begin
  Result := FComponent;
end;


procedure TExtMapImagesColumns.SetImageMap(Index: Integer;
  Value: TExtMapImageIndex);
begin
  Items[Index].Assign(Value);
end;

{$IFDEF VERSIONS}
initialization
  p_ConcatVersion ( gVer_TExtDBImageList );
{$ENDIF}
end.

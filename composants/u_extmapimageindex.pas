unit U_ExtMapImageIndex;

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
    gVer_TExtMapImageIndex : T_Version = ( Component : 'Collection TExtMapImagecolumns' ;
                                               FileUnit : 'U_ExtMapImageIndex' ;
                                               Owner : 'Matthieu Giroux' ;
                                               Comment : 'Gestion de liste d''images dans les données.' ;
                                               BugsStory : '0.9.0.0 : Not tested.';
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

  IMapImageComponent = interface
    procedure CreateImagesMap;
  end;

implementation

uses fonctions_images, sysutils;

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
  p_ConcatVersion ( gVer_TExtMapImageIndex );
{$ENDIF}
end.

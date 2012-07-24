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
     DBCtrls,
     Classes;

{$IFDEF VERSIONS}
  const
    gVer_TExtMapImageIndex : T_Version = ( Component : 'Collection TExtMapImagecolumns' ;
                                               FileUnit : 'U_ExtMapImageIndex' ;
                                               Owner : 'Matthieu Giroux' ;
                                               Comment : 'Gestion de liste d''images dans les données.' ;
                                               BugsStory : '1.0.0.0 : adding usefull methods.' + #13#10 +
                                                           '0.9.9.0 : Tested and new component.' + #13#10 +
                                                           '0.9.0.0 : Not tested.';
                                               UnitType : 3 ;
                                               Major : 1 ; Minor : 0 ; Release : 0 ; Build : 0 );

{$ENDIF}

type
  TExtMapImageIndex = class;
  TExtMapImagesColumns = class;

 { TExtFieldImageIndex }
  TExtMapImageIndex = class(TCollectionItem)
  private
    s_Value : String;
    i_ImageIndex : Integer ;
  published
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
    property Count;
    property Items[Index: Integer]: TExtMapImageIndex read GetImageMap write SetImageMap; default;
  End;

  IMapImageComponent = interface
    procedure CreateImagesMap;
  end;

  { TExtMapImages }

  TExtMapImages = class(TComponent, IMapImageComponent)
      private
        FMapImagesColumns : TExtMapImagesColumns;
        procedure CreateImagesMap; virtual;
        procedure SetColumns ( AValue : TExtMapImagesColumns ); virtual;
      public
        constructor Create(AOwner: TComponent); override;
        function GetIndex ( const AValue : String ): Integer; virtual;
        function GetImageIndex ( const AValue : String ): Integer; virtual;
      published
      { Published declarations }
        property Columns : TExtMapImagesColumns read FMapImagesColumns write SetColumns ;
    end;

implementation

uses sysutils;

{ TExtMapImages }

procedure TExtMapImages.CreateImagesMap;
begin
  FMapImagesColumns := TExtMapImagesColumns.Create(Self,TExtMapImageIndex);
end;

procedure TExtMapImages.SetColumns(AValue: TExtMapImagesColumns);
begin
  FMapImagesColumns.Assign(AValue);
end;

constructor TExtMapImages.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  CreateImagesMap;
end;

function TExtMapImages.GetIndex(const AValue: String): Integer;
var i : Integer;
begin
  Result:=-1;
  for i := 0 to FMapImagesColumns.Count - 1 do
   if AValue = FMapImagesColumns [ i ].Value Then
    Begin
      Result := i ;
    end;
end;

function TExtMapImages.GetImageIndex(const AValue: String): Integer;
begin
  Result := GetIndex(AValue);
  if Result >= 0 Then
    Result:=Columns [ Result ].ImageIndex;
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
  p_ConcatVersion ( gVer_TExtMapImageIndex );
{$ENDIF}
end.

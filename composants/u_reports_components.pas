unit u_reports_components;

{$I ..\DLCompilers.inc}
{$I ..\extends.inc}
{$IFDEF FPC}
{$mode Delphi}
{$ENDIF}

interface

uses
{$IFNDEF FPC}
  Windows, Messages,
{$ENDIF}
  Classes,
{$IFDEF VERSIONS}
  fonctions_version,
{$ENDIF}
  DBGrids,
  u_buttons_appli, RLFilters;

const
{$IFDEF VERSIONS}
  gVer_reports_components: T_Version = (Component: 'Customized Reports Buttons';
    FileUnit: 'u_reports_components';
    Owner: 'Matthieu Giroux';
    Comment: 'Customized Reports Buttons components.';
    BugsStory:  '0.9.0.0 : To test.';
    UnitType: 3;
    Major: 0; Minor: 9; Release: 9; Build: 0);
{$ENDIF}

type
  TExtPrintColumn = class;
  TExtPrintColumns = class;

 { TExtFieldImageIndex }
  TExtPrintColumn = class(TCollectionItem)
  private
    fResize : Boolean;
  published
    property Resize : Boolean read fResize write fResize;
  End;

  TExtPrintColumnClass = class of TExtPrintColumn;

 { TExtFieldImagesColumns }
  TExtPrintColumns = class(TCollection)
  private
    FComponent: TComponent;
    function GetPrintGrid( Index: Integer): TExtPrintColumn;
    procedure SetPrintGrid( Index: Integer; Value: TExtPrintColumn);
  protected
    function GetOwner: TPersistent; override;
  public
    constructor Create(Component: TComponent; ColumnClass: TExtPrintColumnClass); virtual;
    function Add: TExtPrintColumn; virtual;
    property Component : TComponent read FComponent;
    property Count;
    property Items[Index: Integer]: TExtPrintColumn read GetPrintGrid write SetPrintGrid; default;
  End;

 { TFWPrintGrid }

  TFWPrintGrid = class(TFWPrint)
  private
    FFilter : TRLCustomPrintFilter;
    FDBGrid: TCustomDBGrid;
    FColumns : TExtPrintColumns;
    FTitle : String;
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure CreateColumns; virtual;
    procedure SetColumns(AValue: TExtPrintColumns); virtual;
  public
    procedure Click; override;
    constructor Create(Component: TComponent); override;
  published
    property DBGrid : TCustomDBGrid read FDBGrid write FDBGrid;
    property Filter : TRLCustomPrintFilter read FFilter write FFilter;
    property Columns : TExtPrintColumns read FColumns write SetColumns;
    property Title  : String read FTitle write FTitle;
  end;

implementation

uses fonctions_reports,
     Forms;

{ TExtPrintColumns }

function TExtPrintColumns.Add: TExtPrintColumn;
begin
  Result := TExtPrintColumn(inherited Add);
end;

constructor TExtPrintColumns.Create(Component: TComponent;
  ColumnClass: TExtPrintColumnClass);
begin
  inherited Create(ColumnClass);
  FComponent := Component;
end;

function TExtPrintColumns.GetPrintGrid(Index: Integer): TExtPrintColumn;
begin
  Result := TExtPrintColumn(inherited Items[Index]);
end;

function TExtPrintColumns.GetOwner: TPersistent;
begin
  Result := FComponent;
end;


procedure TExtPrintColumns.SetPrintGrid(Index: Integer;
  Value: TExtPrintColumn);
begin
  Items[Index].Assign(Value);
end;

{ TFWPrintGrid }

procedure TFWPrintGrid.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = DBGrid) then DBGrid := nil;
  if (Operation = opRemove) and (AComponent = Filter) then Filter := nil;
end;

procedure TFWPrintGrid.Click;
var ava_Resize : Array of Boolean;
    i : Integer;
begin
  inherited Click;
  SetLength(ava_Resize,FColumns.Count);
  for i := 0 to FColumns.Count - 1 do
    ava_Resize [ i ] := FColumns [ i ].fResize;
  if assigned ( FDBGrid ) Then
    fb_CreateGridReport(FDBGrid,FTitle,[],FFilter);
end;

constructor TFWPrintGrid.Create(Component: TComponent);
begin
  inherited Create(Component);
  CreateColumns;
end;

procedure TFWPrintGrid.CreateColumns;
begin
  FColumns := TExtPrintColumns.Create(Self,TExtPrintColumn);
end;

procedure TFWPrintGrid.SetColumns(AValue: TExtPrintColumns);
begin
  FColumns.Assign(AValue);
end;


{$IFDEF VERSIONS}
initialization
p_ConcatVersion(gVer_reports_components);
{$ENDIF}
end.

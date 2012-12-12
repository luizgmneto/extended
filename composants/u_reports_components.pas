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
  DBGrids, DB, fonctions_reports, RLReport,
  u_buttons_appli, RLFilters, Graphics;

{$IFDEF VERSIONS}
const
  gVer_reports_components: T_Version = (Component: 'Customized Reports Buttons';
    FileUnit: 'u_reports_components';
    Owner: 'Matthieu Giroux';
    Comment: 'Customized Reports Buttons components.';
    BugsStory: '1.0.1.2 : No notification verify on destroy.' +
    '1.0.1.1 : Renaming DBFilter to Filter.' +
    #13#10 + '1.0.1.0 : Putting resize into extdbgrid columns.' +
    #13#10 + '1.0.0.0 : Tested.' + #13#10 +
    '0.9.0.0 : To test.';
    UnitType: 3;
    Major: 1; Minor: 0; Release: 1; Build: 2);
{$ENDIF}

type
  { TFWPrintGrid }

  TFWPrintGrid = class(TFWPrint)
  private
    FFilter: TRLCustomPrintFilter;
    FDBGrid: TCustomDBGrid;
    FTitle: string;
    procedure SetDBGrid(AValue: TCustomDBGrid);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    procedure Click; override;
  published
    property DBGrid: TCustomDBGrid read FDBGrid write SetDBGrid;
    property Filter: TRLCustomPrintFilter read FFilter write FFilter;
    property DBTitle: string read FTitle write FTitle;
  end;

  { TFWPrintData }

  TFWPrintData = class(TComponent)
  private
    FFilter: TRLCustomPrintFilter;
    FDatasource: TDatasource;
    FDBTitle: string;
    FColumns: TExtPrintColumns;
    FFont:TFont;
    FReport : TRLReport;
    procedure SetDatasource(AValue: TDatasource);
    procedure SetColumns(AValue: TExtPrintColumns);
    procedure SetFont( const AValue : TFont );
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    function CreateColumns: TExtPrintColumns; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Print; virtual;
  published
    property Datasource: TDatasource read FDatasource write SetDatasource;
    property Filter: TRLCustomPrintFilter read FFilter write FFilter;
    property DBTitle: string read FDBTitle write FDBTitle;
    property Font : TFont read FFont write SetFont;
    property Columns: TExtPrintColumns read FColumns write SetColumns;
    property Report : TRLReport read FReport write FReport;
  end;

implementation

uses fonctions_proprietes,
     Forms, u_extdbgrid;

{ TFWPrintData }

procedure TFWPrintData.SetDatasource(AValue: TDatasource);
begin
  if AValue <> FDatasource then
  begin
    FDatasource := AValue;
    if Assigned(FDatasource) and Assigned(FDatasource.DataSet) then
      with FDatasource.DataSet.FieldDefs do
        while FColumns.Count < Count do
          FColumns.Add;
  end;
end;

procedure TFWPrintData.SetColumns(AValue: TExtPrintColumns);
begin
  FColumns.Assign(AValue);
end;

procedure TFWPrintData.SetFont(const AValue: TFont);
begin
  FFont.Assign(AValue);
end;

procedure TFWPrintData.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation <> opRemove) or (csDestroying in ComponentState) then
    exit;
  if (AComponent = Datasource) then Datasource := nil;
  if (AComponent = Filter    ) then Filter     := nil;
  if (AComponent = Report    ) then Report     := nil;
end;

function TFWPrintData.CreateColumns: TExtPrintColumns;
begin
  Result := TExtPrintColumns.Create(Self, TExtPrintColumn);
end;

constructor TFWPrintData.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FFont      := TFont.Create;
  FColumns := CreateColumns;
  FDatasource := nil;
  FFilter := nil;
  FDBTitle := '';
  FReport := nil;
end;

destructor TFWPrintData.Destroy;
begin
  inherited Destroy;
  FFont.Free;
  FColumns.Free;
end;

procedure TFWPrintData.Print;
begin
  if assigned(FDatasource) then
  if FReport = nil
   Then fb_CreateReport(nil, FDatasource, FColumns, FDBTitle, FFilter,FFont)
   Else fb_CreateReport(FReport,nil, FDatasource, FColumns, FDBTitle, FFont);
end;


{ TFWPrintGrid }

procedure TFWPrintGrid.SetDBGrid(AValue: TCustomDBGrid);
var
  i: integer;
  AColumns: TDBGridColumns;
begin
  if AValue <> FDBGrid then
  begin
    FDBGrid := AValue;
  end;
end;

procedure TFWPrintGrid.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation <> opRemove) or (csDestroying in ComponentState) then
    exit;
  if (AComponent = DBGrid) then
    DBGrid := nil;
  if (AComponent = Filter) then
    Filter := nil;
end;

procedure TFWPrintGrid.Click;
begin
  inherited Click;
  if assigned(FDBGrid) then
  begin
    fb_CreateReport(FDBGrid, TDataSource(
      fobj_getComponentObjectProperty(FDBGrid, 'Datasource')), TCollection(
      fobj_getComponentObjectProperty(FDBGrid, 'Columns')), FTitle, FFilter);
  end;
end;

{$IFDEF VERSIONS}
initialization
  p_ConcatVersion(gVer_reports_components);
{$ENDIF}
end.

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

const
{$IFDEF VERSIONS}
  gVer_reports_components: T_Version = (Component: 'Customized Reports Buttons';
    FileUnit: 'u_reports_components';
    Owner: 'Matthieu Giroux';
    Comment: 'Customized Reports Buttons components.';
    BugsStory: '1.1.0.0 : TFWPrintData Component.' + #13#10 +
               '1.0.1.2 : No notification verify on destroy.' + #13#10 +
               '1.0.1.1 : Renaming DBFilter to Filter.' + #13#10 +
      #13#10 + '1.0.1.0 : Putting resize into extdbgrid columns.' +
      #13#10 + '1.0.0.0 : Tested.' + #13#10 +
               '0.9.0.0 : To test.';
    UnitType: 3;
    Major: 1; Minor: 1; Release: 0; Build: 0);
{$ENDIF}
   CST_PRINT_TITLE_BACK = clBlue;
type
  { TFWPrintGrid }

  TFWPrintGrid = class(TFWPrint)
  private
    FFilter: TRLCustomPrintFilter;
    FDBGrid: TCustomDBGrid;
    FDBTitleBack: TColor;
    FDBTitle: string;
    FFont:TFont;
    procedure SetDBGrid( const AValue: TCustomDBGrid);
    procedure SetFont( const AValue : TFont );
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Click; override;
  published
    property DBGrid: TCustomDBGrid read FDBGrid write SetDBGrid;
    property Filter: TRLCustomPrintFilter read FFilter write FFilter;
    property DBTitle: string read FDBTitle write FDBTitle;
    property DBTitleBack: TColor read FDBTitleBack write FDBTitleBack default CST_PRINT_TITLE_BACK;
    property DBTitleFont : TFont read FFont write SetFont;
  end;

  TFWPrintData = class;

  { TDataLinkPrint }
  TDataLinkPrint = class(TDataLink)
  private
    FOwner : TFWPrintData;
  protected
    procedure ActiveChanged; override;
  public
    constructor Create ( const AOwner :  TFWPrintData ); virtual;
  End;
  { TFWPrintData }

  TFWPrintData = class(TComponent)
  private
    FFilter: TRLCustomPrintFilter;
    FDataLink: TDataLink;
    FDBTitle: string;
    FDBTitleBack: TColor;
    FColumns: TExtPrintColumns;
    FFont:TFont;
    FReport : TRLReport;
    procedure SetDatasource(AValue: TDatasource);
    function  GetDatasource: TDatasource;
    procedure SetColumns(AValue: TExtPrintColumns);
    procedure SetFont( const AValue : TFont );
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    function CreateColumns: TExtPrintColumns; virtual;
    procedure ActiveChanged; virtual;
    procedure AddColumns; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Preview; virtual;
  published
    property Datasource: TDatasource read GetDatasource write SetDatasource;
    property Filter: TRLCustomPrintFilter read FFilter write FFilter;
    property DBTitle: string read FDBTitle write FDBTitle;
    property DBTitleBack: TColor read FDBTitleBack write FDBTitleBack default CST_PRINT_TITLE_BACK;
    property DBTitleFont : TFont read FFont write SetFont;
    property Columns: TExtPrintColumns read FColumns write SetColumns;
    property Report : TRLReport read FReport write FReport;
  end;

implementation

uses fonctions_proprietes,
     Forms, u_extdbgrid;

{ TDataLinkPrint }

procedure TDataLinkPrint.ActiveChanged;
begin
  inherited ActiveChanged;
  FOwner.ActiveChanged;
end;

constructor TDataLinkPrint.Create(const AOwner: TFWPrintData);
begin
  Inherited Create;
  FOwner:=AOwner;
end;

{ TFWPrintData }

procedure TFWPrintData.SetDatasource(AValue: TDatasource);
begin
  if AValue <> FDataLink.DataSource then
  begin
    FDataLink.DataSource := AValue;
    AddColumns;
  end;
end;

function TFWPrintData.GetDatasource: TDatasource;
begin
  Result := FDataLink.DataSource;
end;

procedure TFWPrintData.SetColumns(AValue: TExtPrintColumns);
begin
  FColumns.Assign(AValue);
end;

procedure TFWPrintData.AddColumns;
begin
  if Assigned(FDataLink.DataSet) then
    with FDataLink.DataSet.FieldDefs do
      while FColumns.Count < Count do
        FColumns.Add;
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
  FFont.Color:= clWhite;
  FColumns := CreateColumns;
  FDataLink := TDataLinkPrint.Create(Self);
  FFilter := nil;
  FDBTitle := '';
  FDBTitleBack := CST_PRINT_TITLE_BACK;
  FReport := nil;
end;

destructor TFWPrintData.Destroy;
begin
  inherited Destroy;
  FFont.Free;
  FColumns.Free;
  FDataLink.Free;
end;

procedure TFWPrintData.Preview;
begin
  if assigned(FDataLink) then
  if FReport = nil
   Then fb_CreateReport(nil, FDataLink.DataSource, FColumns, FDBTitle, FDBTitleBack, FFilter,FFont)
   Else fb_CreateReport(FReport,nil, FDataLink.DataSource, FColumns, FDBTitle, FFont, FDBTitleBack);
end;

procedure TFWPrintData.ActiveChanged;
begin
  AddColumns;
end;


{ TFWPrintGrid }

procedure TFWPrintGrid.SetDBGrid(const AValue: TCustomDBGrid);
var
  i: integer;
  AColumns: TDBGridColumns;
begin
  if AValue <> FDBGrid then
  begin
    FDBGrid := AValue;
  end;
end;

procedure TFWPrintGrid.SetFont(const AValue: TFont);
begin
  FFont.Assign(AValue);
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

constructor TFWPrintGrid.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDBTitleBack:=CST_PRINT_TITLE_BACK;
  FDBTitle    :='';
  FFilter     := nil;
  FDBGrid     := nil;
  FFont       := TFont.Create;
  FFont.Color := clWhite;
end;

destructor TFWPrintGrid.Destroy;
begin
  inherited Destroy;
  FFont.Free;
end;

procedure TFWPrintGrid.Click;
begin
  inherited Click;
  if assigned(FDBGrid) then
  begin
    fb_CreateReport(FDBGrid, TDataSource(
      fobj_getComponentObjectProperty(FDBGrid, CST_PROPERTY_DATASOURCE)), TCollection(
      fobj_getComponentObjectProperty(FDBGrid, CST_PROPERTY_COLUMNS)), FDBTitle, FDBTitleBack, FFilter, FFont);
  end;
end;

{$IFDEF VERSIONS}
initialization
  p_ConcatVersion(gVer_reports_components);
{$ENDIF}
end.

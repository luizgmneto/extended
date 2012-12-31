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
  RLPreview, u_reportform,
  u_buttons_appli, RLFilters, Graphics;


{$IFDEF VERSIONS}
const
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

type
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
    FColumns: TExtPrintColumns;
    FReport : TRLReport;
    FReportForm : TReportForm;
    FPreview : TRLPReview;
    procedure SetDatasource(AValue: TDatasource);
    function  GetDatasource: TDatasource;
    procedure SetColumns(AValue: TExtPrintColumns);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    function CreateColumns: TExtPrintColumns; virtual;
    procedure ActiveChanged; virtual;
    procedure AddColumns; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure ShowPreview; virtual;
    procedure AddPreview ( const AReport : TRLReport ); virtual;
    property  ResultForm : TReportForm read FReportForm;
  published
    property Datasource: TDatasource read GetDatasource write SetDatasource;
    property Filter: TRLCustomPrintFilter read FFilter write FFilter;
    property DBTitle: string read FDBTitle write FDBTitle;
    property Columns: TExtPrintColumns read FColumns write SetColumns;
    property Report : TRLReport read FReport write FReport;
    property Preview : TRLPreview read FPreview write FPreview;
  end;

  { TFWPrintGrid }

  TFWPrintGrid = class(TFWPrint)
  private
    FFilter: TRLCustomPrintFilter;
    FDBGrid: TCustomDBGrid;
    FDBTitle: string;
    FPreview : TRLPReview;
    procedure SetDBGrid( const AValue: TCustomDBGrid);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Click; override;
  published
    property DBGrid: TCustomDBGrid read FDBGrid write SetDBGrid;
    property Filter: TRLCustomPrintFilter read FFilter write FFilter;
    property DBTitle: string read FDBTitle write FDBTitle;
    property Preview : TRLPreview read FPreview write FPreview;
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
    FColumns.SetDatasource;
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

procedure TFWPrintData.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation <> opRemove) or (csDestroying in ComponentState) then
    exit;
  if (AComponent = Datasource) then
   Begin
     Datasource := nil;
     FColumns.SetDatasource;
   end;
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
  FColumns := CreateColumns;
  FDataLink := TDataLinkPrint.Create(Self);
  FFilter := nil;
  FDBTitle := '';
  FReport := nil;
end;

destructor TFWPrintData.Destroy;
begin
  inherited Destroy;
  FDataLink.Free;
end;

procedure TFWPrintData.ShowPreview;
begin
  FDataLink.DataSet.DisableControls;
  AddPreview(FReport);
  if FReportForm <> nil Then
   with FReportForm do
   try
     RLReport.Preview(FPreview);
   Finally
     FDataLink.DataSet.EnableControls;
     Finalize ( RLListImages );
     Destroy;
     FReportForm := nil;
   End;
end;

procedure TFWPrintData.AddPreview(const AReport: TRLReport);
begin
  if assigned(FDataLink) then
  if AReport = nil
   Then
     FReportForm := fref_CreateReport(nil, FDataLink.DataSource, FColumns, FDBTitle,  FFilter)
   Else
     Begin
       fb_CreateReport(AReport,nil, FDataLink.DataSource, FColumns, AReport.Background.Picture.Bitmap.Canvas, FDBTitle);
     end;
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
  FDBTitle    :='';
  FFilter     := nil;
  FDBGrid     := nil;
end;

procedure TFWPrintGrid.Click;
begin
  inherited Click;
  if assigned(FDBGrid) then
  with TDataSource(
      fobj_getComponentObjectProperty(FDBGrid, CST_PROPERTY_DATASOURCE)).DataSet do
  begin
    DisableControls;
    with fref_CreateReport(FDBGrid, TDataSource(
      fobj_getComponentObjectProperty(FDBGrid, CST_PROPERTY_DATASOURCE)), TCollection(
      fobj_getComponentObjectProperty(FDBGrid, CST_PROPERTY_COLUMNS)), FDBTitle, FFilter) do
        try
          RLReport.Preview(FPReview);
          Finalize ( RLListImages );
          Destroy;
        finally
          EnableControls;
        end;
  end;
end;


{$IFDEF VERSIONS}
initialization
  p_ConcatVersion(gVer_reports_components);
{$ENDIF}
end.

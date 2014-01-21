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
  DBGrids, DB, fonctions_reports,
  fonctions_proprietes,
  RLReport, VirtualTrees,
  RLPreview, u_reportform,
  u_reports_rlcomponents,
  Printers, RLTypes,
  u_buttons_appli, RLFilters, Graphics;


{$IFDEF VERSIONS}
const
  gVer_reports_components: T_Version = (Component: 'Customized Reports Buttons';
    FileUnit: 'u_reports_components';
    Owner: 'Matthieu Giroux';
    Comment: 'Customized Reports Buttons components.';
    BugsStory: '1.1.2.0 : Adding Orientation and PaperSize.' + #13#10 +
               '1.1.1.0 : TFWPrintGrid CreateReport porperty.' + #13#10 +
               '1.1.0.0 : TFWPrintData Component.' + #13#10 +
               '1.0.1.2 : No notification verify on destroy.' + #13#10 +
               '1.0.1.1 : Renaming DBFilter to Filter.' + #13#10 +
      #13#10 + '1.0.1.0 : Putting resize into extdbgrid columns.' +
      #13#10 + '1.0.0.0 : Tested.' + #13#10 +
               '0.9.0.0 : To test.';
    UnitType: 3;
    Major: 1; Minor: 1; Release: 2; Build: 0);
{$ENDIF}


type
  IFWPrintComp = interface
    ['{AD143A16-9635-4C81-B064-33BEF0946DA2}']
    procedure CreateAReport( const AReport : TRLReport );
  End;
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
 // create a report from datasource
  TFWPrintData = class(TComponent,IFWPrintComp)
  private
    FFilter: TRLCustomPrintFilter;
    FDataLink: TDataLink;
    FDBTitle: string;
    FColumns: TExtPrintColumns;
    FReport : TRLReport;
    FReportForm : TReportForm;
    FPreview : TRLPReview;
    FOrientation : {$IFDEF FPC}TPrinterOrientation{$ELSE}TRLPageOrientation{$ENDIF};
    FPaperSize     :TRLPaperSize;
    function GetFalse: Boolean;
    procedure SetDatasource(const AValue: TDatasource);
    function  GetDatasource: TDatasource;
    procedure SetColumns(const AValue: TExtPrintColumns);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure SetCreateReport ( const AValue : Boolean ); virtual;
    function CreateColumns: TExtPrintColumns; virtual;
    procedure ActiveChanged; virtual;
    procedure AddColumns; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure CreateAReport( const AReport : TRLReport ); virtual;
    procedure ShowPreview; virtual;
    procedure AddPreview ( const AReport : TRLReport = nil ); virtual;
    property  FormReport : TReportForm read FReportForm;
  published
    property Datasource: TDatasource read GetDatasource write SetDatasource;
    property Filter: TRLCustomPrintFilter read FFilter write FFilter;
    property DBTitle: string read FDBTitle write FDBTitle;
    property Columns: TExtPrintColumns read FColumns write SetColumns;
    property Report : TRLReport read FReport write FReport;
    property Preview : TRLPreview read FPreview write FPreview;
    property CreateReport : Boolean read GetFalse write SetCreateReport default False; // design only property
    property Orientation : {$IFDEF FPC}TPrinterOrientation{$ELSE}TRLPageOrientation{$ENDIF} read FOrientation write FOrientation default poPortrait;
    property PaperSize   :TRLPaperSize read FPaperSize write FPaperSize default fpA4;
  end;

  { TFWPrintComp }
  // create a report from component ( abstract )
  TFWPrintComp = class(TFWPrint,IFWPrintComp)
  private
    FFilter: TRLCustomPrintFilter;
    FReportForm : TReportForm;
    FReport : TRLReport;
    FDBTitle: string;
    FPreview : TRLPReview;
    FOrientation : {$IFDEF FPC}TPrinterOrientation{$ELSE}TRLPageOrientation{$ENDIF};
    FPaperSize     :TRLPaperSize;
  protected
    function GetFalse: Boolean;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure SetCreateReport ( const AValue : Boolean ); virtual;
  public
    constructor Create(AOwner: TComponent); override;
    procedure p_SetReport ( const Areport : TRLReport ); virtual;
    procedure CreateAReport( const AReport : TRLReport );  virtual; abstract;
    property  FormReport : TReportForm read FReportForm write FReportForm;
  published
    property Filter: TRLCustomPrintFilter read FFilter write FFilter;
    property DBTitle: string read FDBTitle write FDBTitle;
    property Preview : TRLPreview read FPreview write FPreview;
    property Report : TRLReport read FReport write FReport;
    property CreateReport : Boolean read GetFalse write SetCreateReport default False; // design only property
    property Orientation : {$IFDEF FPC}TPrinterOrientation{$ELSE}TRLPageOrientation{$ENDIF} read FOrientation write FOrientation default poPortrait;
    property PaperSize   :TRLPaperSize read FPaperSize write FPaperSize default fpA4;
  end;


  { TFWPrintGrid }
  // create a report from grid
  TFWPrintGrid = class(TFWPrintComp)
  private
    FDBGrid: TCustomDBGrid;
    procedure SetDBGrid( const AValue: TCustomDBGrid);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Click; override;
    procedure CreateAReport( const AReport : TRLReport ); override;
  published
    property DBGrid: TCustomDBGrid read FDBGrid write SetDBGrid;
  end;

    { TFWPrintVTree }
    // create a report from virtual tree
  TFWPrintVTree = class(TFWPrintComp)
  private
    FTree : TCustomVirtualStringTree;
    procedure SetTree( const AValue: TCustomVirtualStringTree);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Click; override;
    procedure CreateAReport( const AReport : TRLReport ); override;
  published
    property Tree: TCustomVirtualStringTree read FTree write SetTree;
  end;

procedure p_SetBtnPrint  ( const APrintComp   : TObject; const ATitle, APaperSizeText : String ;const ab_portrait : Boolean );
procedure p_SetPageSetup ( const ARLPageSetup : TObject; const APaperSizeText : String ;const ab_portrait : Boolean ); overload;
procedure p_SetPageSetup ( const ARLPageSetup : TObject; const APaperSizeText : String  ); overload;
procedure p_SetPageSetup ( const ARLPageSetup : TObject; const ab_portrait : Boolean ); overload;

implementation

uses Forms, typinfo;

// From interface : setting report button
procedure p_SetBtnPrint  ( const APrintComp   : TObject; const ATitle, APaperSizeText : String ;const ab_portrait : Boolean );
Begin
  SetPropValue( APrintComp, 'DBTitle', ATitle );
  p_SetPageSetup ( APrintComp, APaperSizeText, ab_portrait );
End;
// From interface : setting report button
procedure p_SetPageSetup ( const ARLPageSetup : TObject;const ab_portrait : Boolean );
Begin
  if ab_portrait
   Then SetPropValue( ARLPageSetup, 'Orientation', poPortrait )
   Else SetPropValue( ARLPageSetup, 'Orientation', poLandscape );
End;
// From interface : setting report button
procedure p_SetPageSetup ( const ARLPageSetup : TObject; const APaperSizeText : String  );
Begin
  if APaperSizeText <> '' then
   SetPropValue( ARLPageSetup, 'PaperSize', 'fp' + APaperSizeText );
End;
// From interface : setting report button
procedure p_SetPageSetup ( const ARLPageSetup : TObject; const APaperSizeText : String ;const ab_portrait : Boolean );
Begin
  p_SetPageSetup ( ARLPageSetup, ab_portrait );
  p_SetPageSetup ( ARLPageSetup, APaperSizeText );
End;



{ TFWPrintVTree }

// tree property setter
procedure TFWPrintVTree.SetTree(const AValue: TCustomVirtualStringTree);
begin
  if AValue <> FTree Then
   Begin
     FTree := AValue;
   end;
end;

// auto unlinking
procedure TFWPrintVTree.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation <> opRemove) or (csDestroying in ComponentState) then
    exit;
  if (AComponent = FTree) then
    Tree := nil;
end;

// initing
constructor TFWPrintVTree.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FTree := nil;
end;

// on click : report's preview
procedure TFWPrintVTree.Click;
var ADatasource : TDataSource;
begin
  inherited Click;
  if assigned(FTree) then
   Begin
     if Assigned(FReport)
      Then CreateAReport(FReport)
     Else
      Begin
        ADatasource := TDataSource(fobj_getComponentObjectProperty(FTree, CST_PROPERTY_DATASOURCE));
        if Assigned(ADatasource) Then ADatasource.DataSet.DisableControls;
        if FormReport = nil Then
          FormReport := fref_CreateReport( FTree, FDBTitle, FOrientation, FPaperSize, FFilter );
        with FormReport do
            try
              RLReport.Preview(FPReview);
            finally
              Destroy;
              FormReport := nil;
              if Assigned(ADatasource) Then ADatasource.DataSet.EnableControls;
            end;
      end;
   end;
end;

// for design
procedure TFWPrintVTree.CreateAReport(const AReport: TRLReport);
begin
  p_SetReport(AReport);
  if Assigned(FTree) Then
   fb_CreateReport(AReport,FTree,AReport.Background.Picture.Bitmap.Canvas,DBTitle);
end;

{ TFWPrintComp }

// for design
function TFWPrintComp.GetFalse: Boolean;
begin
  Result := False;
end;

// auto unlinking
procedure TFWPrintComp.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation <> opRemove) or (csDestroying in ComponentState) then
    exit;
  if (AComponent = FReport) then
    Report := nil;
  if (AComponent = Filter) then
    Filter := nil;
  if (AComponent = FPreview) then
    Preview := nil;
end;

// design report's creating property setter
procedure TFWPrintComp.SetCreateReport(const AValue: Boolean);
begin
  if  ( AValue =  True )
  and ( FReport <> nil ) Then
    CreateAReport ( FReport );
end;

// initing
constructor TFWPrintComp.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FOrientation:=poPortrait;
  FPaperSize  :=fpA4;
  FDBTitle    :='';
  FFilter     := nil;
  FReport     := nil;
  FPreview    := nil;
end;

// properties set to report
procedure TFWPrintComp.p_SetReport(const Areport: TRLReport);
begin
  with Areport.PageSetup do
     Begin
       Orientation:=FOrientation;
       PaperSize  :=FPaperSize;
     end;
end;

{ TDataLinkPrint }

// designing only
procedure TDataLinkPrint.ActiveChanged;
begin
  inherited ActiveChanged;
  FOwner.ActiveChanged;
end;

// initing
constructor TDataLinkPrint.Create(const AOwner: TFWPrintData);
begin
  Inherited Create;
  FOwner:=AOwner;
end;

{ TFWPrintData }

// datasource property setter
procedure TFWPrintData.SetDatasource(const AValue: TDatasource);
begin
  if AValue <> FDataLink.DataSource then
  begin
    FDataLink.DataSource := AValue;
    AddColumns;
    FColumns.SetDatasource;
  end;
end;

// designing only
function TFWPrintData.GetFalse: Boolean;
begin
  Result := False;
end;

// datasource property getter
function TFWPrintData.GetDatasource: TDatasource;
begin
  Result := FDataLink.DataSource;
end;

// columns property setter
procedure TFWPrintData.SetColumns(const AValue: TExtPrintColumns);
begin
  FColumns.Assign(AValue);
end;

// designing only : create report
procedure TFWPrintData.AddColumns;
begin
  if Assigned(FDataLink.DataSet)
  and ( csDesigning in ComponentState )
  or ( FColumns.Count = 0 ) then
    with FDataLink.DataSet.FieldDefs do
      while FColumns.Count < Count do
        FColumns.Add;
end;

// unlinking
procedure TFWPrintData.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation <> opRemove) or (csDestroying in ComponentState) then
    exit;
  if (AComponent = Datasource) then Datasource := nil;
  if (AComponent = Filter    ) then Filter  := nil;
  if (AComponent = Report    ) then Report  := nil;
  if (AComponent = FPreview  ) then Preview := nil;
end;

// designing only : create report
procedure TFWPrintData.SetCreateReport(const AValue: Boolean);
begin
  if  ( AValue =  True )
  and ( FReport <> nil )  Then
    CreateAReport ( FReport );
end;

// initing
function TFWPrintData.CreateColumns: TExtPrintColumns;
begin
  Result := TExtPrintColumns.Create(Self, TExtPrintColumn);
end;

// initing
constructor TFWPrintData.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FOrientation:=poPortrait;
  FPaperSize  :=fpA4;
  FColumns := CreateColumns;
  FDataLink := TDataLinkPrint.Create(Self);
  FDBTitle := '';
  FFilter  := nil;
  FReport  := nil;
  FPreview := nil;
  FReportForm := nil;
end;

// free objects
destructor TFWPrintData.Destroy;
begin
  inherited Destroy;
  FDataLink.Free;
end;

// report's preview
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
   End;
end;

// create linked report
procedure TFWPrintData.CreateAReport ( const AReport : TRLReport );
begin
  fb_CreateReport(AReport,nil, FDataLink.DataSource, FColumns, AReport.Background.Picture.Bitmap.Canvas, FDBTitle);
End;

// create report
procedure TFWPrintData.AddPreview(const AReport: TRLReport);
begin
  if assigned(FDataLink) then
  if AReport = nil
   Then
    Begin
       FReportForm.Free;
       FReportForm := fref_CreateReport(nil, FDataLink.DataSource, FColumns, FDBTitle, FOrientation, FPaperSize, FFilter)
    end
   Else
     CreateAReport ( AReport );
end;

// auto add on design
procedure TFWPrintData.ActiveChanged;
begin
  AddColumns;
end;


{ TFWPrintGrid }

// grid property setter
procedure TFWPrintGrid.SetDBGrid(const AValue: TCustomDBGrid);
begin
  if AValue <> FDBGrid then
  begin
    FDBGrid := AValue;
  end;
end;

// auto unlinking
procedure TFWPrintGrid.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation <> opRemove) or (csDestroying in ComponentState) then
    exit;
  if (AComponent = FDBGrid) then
    DBGrid := nil;
end;

// automation , creating a report
procedure TFWPrintGrid.CreateAReport(const AReport: TRLReport);
begin
  p_SetReport(AReport);
  if Assigned(FDBGrid) Then
    fb_CreateReport(AReport,FDBGrid, fobj_getComponentObjectProperty(FDBGrid,CST_PROPERTY_DATASOURCE) as TDataSource,
                                     fobj_getComponentObjectProperty(FDBGrid, CST_PROPERTY_COLUMNS  ) as TCollection,
                                     AReport.Background.Picture.Bitmap.Canvas,
                                     FDBTitle);
end;

// init
constructor TFWPrintGrid.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDBGrid     := nil;
end;

// on click : report's preview
procedure TFWPrintGrid.Click;
begin
  inherited Click;
  if assigned(FDBGrid) then
   if Assigned(FReport)
    Then
     Begin
       CreateAReport(FReport);
     end
   Else
    with TDataSource(
        fobj_getComponentObjectProperty(FDBGrid, CST_PROPERTY_DATASOURCE)).DataSet do
    begin
      DisableControls;
      if FormReport = nil Then
        FormReport := fref_CreateReport(FDBGrid, TDataSource(
        fobj_getComponentObjectProperty(FDBGrid, CST_PROPERTY_DATASOURCE)), TCollection(
        fobj_getComponentObjectProperty(FDBGrid, CST_PROPERTY_COLUMNS)), FDBTitle, Orientation, PaperSize, FFilter);
      with FormReport  do
          try
            RLReport.Preview(FPReview);
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

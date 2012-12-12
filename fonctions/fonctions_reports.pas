unit fonctions_reports;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFNDEF FPC}
  Windows,
{$ENDIF}
  SysUtils, RLReport, DBGrids, DB,
  u_extdbgrid,U_ExtMapImageIndex,Forms,
  u_reportform,ImgList, Graphics,
  RLFilters,
  {$IFDEF JEDI}
   JvDBUltimGrid, JvDBGrid,
  {$ELSE}
    {$IFDEF FPC}
     RxDBGrid,
    {$ELSE}
     RxDBCtrl,
    {$ENDIF}
  {$ENDIF}
{$IFDEF VERSIONS}
  fonctions_version,
{$ENDIF}
  Classes, Grids;

const
{$IFDEF VERSIONS}
  gVer_fonctions_reports : T_Version = ( Component : 'System management' ; FileUnit : 'fonctions_reports' ;
                        			                 Owner : 'Matthieu Giroux' ;
                        			                 Comment : 'Reports'' Functions, with grid reports.' ;
                        			                 BugsStory : 'Version 1.0.0.1 : image centering.' + #13#10 +
                                                                             'Version 1.0.0.0 : Working.';
                        			                 UnitType : 1 ;
                        			                 Major : 1 ; Minor : 0 ; Release : 0 ; Build : 1 );
{$ENDIF}
  CST_COLUMN_Visible = 'Visible';
  CST_COLUMN_Width   = 'Width';
  CST_COLUMN_Resize  = 'Resize';
  CST_COLUMN_Title   = 'Title';
  CST_COLUMN_Images  = 'Images';

type TBoolArray = Array of Boolean;

  { TExtPrintColumn }

  TExtPrintColumn = class(TCollectionItem)
   private
     FWidth   : Integer ;
     FResize  : Boolean;
     FVisible : Boolean;
     FTitleFont, FFont   : TFont;
     FImages : TCustomImageList;
     FMapImages : TExtMapImages;
     procedure SetImages( const AValue : TCustomImageList );
     procedure SetTitleFont( const AValue : TFont );
     procedure SetFont( const AValue : TFont );
     procedure SetMapImages( const AValue : TExtMapImages );
   public
     constructor Create(ACollection: TCollection); override;
     destructor  Destroy; override;
   published
     property Width   : Integer  read FWidth   write FWidth;
     property Resize  : Boolean  read FResize  write FResize  default False;
     property Visible : Boolean  read FVisible write FVisible default true;
     property TitleFont : TFont read FTitleFont write SetTitleFont;
     property Font : TFont read FFont write SetFont;
     property Images    : TCustomImageList read FImages    write SetImages;
     property MapImages : TExtMapImages    read FMapImages write SetMapImages;
   end;

  { TExtPrintColumns }
  TExtPrintColumns = class(TCollection)
  private
    FOwner : TComponent;
    function GetColumn ( Index: Integer): TExtPrintColumn;
    procedure SetColumn( Index: Integer; const Value: TExtPrintColumn);
  public
    constructor Create(const AOwner: TComponent; const aItemClass: TCollectionItemClass); virtual;
    function Add: TExtPrintColumn;
    property Owner : TComponent read FOwner;
    property Items[Index: Integer]: TExtPrintColumn read GetColumn write SetColumn; default;
  end;


var RLLeftTopPage : TPoint = ( X: 20; Y:20 );
    RLListImages : array of record
                            AImage : TRLImage ;
                            AField : TField ;
                            AGetImageIndex : TFieldIndexEvent;
                            AMapImages : TExtMapImages;
                            AImages : TCustomImageList;
                            ACellWidth  : Integer;
                            ABand   : TRLBand;
                           end;
    RLTitlecolor : TColor = clBlue;
    RLColumnHeadercolor : TColor = clBlack;
    RLColumnTextcolor : TColor = clBlack;
    RLLandscapeColumnsCount : Integer = 9;

function fb_CreateReport ( const AReport : TRLReport ; const agrid : TCustomDBGrid; const ADatasource : TDatasource; const AColumns : TCollection; const as_Title : String ; APrintFont : TFont ): Boolean; overload;
function fb_CreateReport ( const agrid : TCustomDBGrid; const ADatasource : TDatasource; const AColumns : TCollection; const as_Title : String ; const acf_filter : TRLCustomPrintFilter = nil; APrintFont : TFont = nil ): Boolean; overload;

implementation

uses fonctions_proprietes,RLPreview,
     fonctions_images,Printers,
     RLTypes, unite_messages,
     Math;

{ TExtPrintColumns }

function TExtPrintColumns.GetColumn(Index: Integer): TExtPrintColumn;
begin
  result := TExtPrintColumn( inherited Items[Index] );
end;

procedure TExtPrintColumns.SetColumn(Index: Integer;
  const Value: TExtPrintColumn);
begin
  Items[Index].Assign( Value );
end;

constructor TExtPrintColumns.Create(const AOwner: TComponent;
  const aItemClass: TCollectionItemClass);
begin
  Inherited create ( aItemClass );
  FOwner:=AOwner;
end;

function TExtPrintColumns.Add: TExtPrintColumn;
begin
  result := TExtPrintColumn (inherited Add);
end;

{ TExtPrintColumn }

procedure TExtPrintColumn.SetImages(const AValue: TCustomImageList);
begin
  if AValue<> FImages then
   FImages := AValue;
end;

procedure TExtPrintColumn.SetTitleFont(const AValue: TFont);
begin
  FTitleFont.Assign(AValue);
end;

procedure TExtPrintColumn.SetFont(const AValue: TFont);
begin
  FFont.Assign(AValue);
end;

procedure TExtPrintColumn.SetMapImages(const AValue: TExtMapImages);
begin
  if AValue<> FMapImages then
   FMapImages := AValue;
end;

constructor TExtPrintColumn.Create(ACollection: TCollection);
begin
  inherited Create(ACollection);
  FWidth:=0;
  FResize :=False;
  FVisible:=True;
  FTitleFont := TFont.Create;
  FFont      := TFont.Create;
  FImages := nil;
  FMapImages := nil;
end;

destructor TExtPrintColumn.Destroy;
begin
  inherited Destroy;
  FFont.Free;
  FTitleFont.Free;
end;


function fb_CreateReport ( const AReport : TRLReport ; const agrid : TCustomDBGrid; const ADatasource : TDatasource; const AColumns : TCollection; const as_Title : String ; APrintFont : TFont ): Boolean;
var totalgridwidth, aresizecolumns, atitleHeight, aVisibleColumns, SomeLeft, totalreportwidth, aWidth : Integer;
    ARLLabel : TRLLabel;
    ARLDBText : TRLDBText;
    ARLImage : TRLImage;
    ARLBand : TRLBand;
    AImages : TCustomImageList;
    ARLSystemInfo : TRLSystemInfo;
  procedure p_createLabel ( const ALeft, ATop, AWidth : Integer ; const afont : TFont; const AColor : TColor; const as_Text : String = '' ; const ai_SizeFont : Integer = 0 );
  Begin
    ARLLabel := TRLLabel.Create(AReport);
    ARLLabel.Parent:=ARLBand;
    ARLLabel.Top:=ATop;
    ARLLabel.Left:=ALeft;
    ARLLabel.Font.assign ( afont );
    if ai_SizeFont <> 0 Then
     ARLLabel.Font.Size:=ai_SizeFont;
    if AWidth > 0 Then
     Begin
      ARLLabel.AutoSize:=False;
      ARLLabel.Width   :=AWidth;
     end;
    ARLLabel.Caption:=as_Text;
  end;

  procedure p_createSystemInfo ( const ALeft, ATop, AFontWidth : Integer ; const AInfo:TRLInfoType; const astyle : TFontStyles; const AColor : TColor;  const as_Text : String = '' );
  Begin
    ARLSystemInfo := TRLSystemInfo.Create(AReport);
    ARLSystemInfo.Parent:=ARLBand;
    ARLSystemInfo.Top:=ATop;
    ARLSystemInfo.Left:=ALeft;
    ARLSystemInfo.Font.Size:=AFontWidth;
    ARLSystemInfo.Font.Style:=astyle;
    ARLSystemInfo.Font.Color := AColor;
    ARLSystemInfo.Align:=faRight;
    ARLSystemInfo.Layout:={$IFDEF FPC }TRLTextLayout.{$ENDIF}tlTop;
    ARLSystemInfo.Text:=as_Text;
    ARLSystemInfo.Info:=AInfo;
  end;

  procedure p_createBand ( const ALeft, ATop, Aheight : Integer ; const Abandtype : TRLBandType );
  Begin
    ARLBand := TRLBand.Create(AReport);
    ARLBand.Parent:=AReport;
    ARLBand.BandType:=Abandtype;
    ARLBand.Top:=ATop;
    ARLBand.Left:=ALeft;
    ARLBand.Height:=Aheight;
    ARLBand.Width:=aReport.Width-RLLeftTopPage.X*2;
  end;
  procedure p_createDBText ( const ALeft, ATop, AWidth : Integer ; const afont : TFont; const AColor : TColor; const as_Fieldname : String ; const ai_SizeFont : Integer = 0);
  Begin
    ARLDBText := TRLDBText.Create(AReport);
    ARLDBText.Parent:=ARLBand;
    ARLDBText.DataSource:=TDataSource( fobj_getComponentObjectProperty(agrid,'Datasource'));
    ARLDBText.Top:=ATop;
    ARLDBText.Left:=ALeft;
    ARLDBText.Font.Assign(afont);
    if ai_SizeFont <> 0 Then
      ARLDBText.Font.Size:=ai_SizeFont;
    if AWidth > 0 Then
     Begin
       ARLDBText.AutoSize:=False;
       ARLDBText.Width:=AWidth;
     end;
    ARLDBText.DataField:=as_Fieldname;
  end;

  procedure p_createImage ( const ALeft, ATop, AWidth : Integer);
  Begin
    ARLImage := TRLImage.Create(AReport);
    ARLImage.Parent:=ARLBand;
    ARLImage.Top:=ATop;
    ARLImage.Left:=ALeft;
    ARLImage.Width:=AWidth;
  end;

  function fi_resize ( const ai_width, aindex : Integer ):Integer;
  Begin
    if  fb_getComponentBoolProperty ( aColumns.Items [ aindex ], CST_COLUMN_Resize, True )
     Then Result:=ai_width+aresizecolumns
     Else Result:=ai_Width;
  end;

  procedure PreparePrint;
  var i : Integer;
  Begin
    with agrid,AReport do
     Begin
      for i := 0 to aColumns.Count - 1 do
       with aColumns.Items [ i ] do
        if fb_getComponentBoolProperty ( aColumns.Items [ i ], CST_COLUMN_Visible, True )
        and ( Width > 4 ) Then
         Begin
          inc ( totalgridwidth, Width );
          inc ( aVisibleColumns );
          if fb_getComponentBoolProperty ( aColumns.Items [ i ], CST_COLUMN_Resize, True )
            Then inc ( aresizecolumns );
         end;
      if aVisibleColumns >= RLLandscapeColumnscount
       Then PageSetup.Orientation:=poLandscape
       Else PageSetup.Orientation:=poPortrait;
     End;


  end;

  procedure CreateHeader;
  var i : Integer;
  Begin
   with agrid,AReport do
    Begin
      if as_Title > '' Then
        Begin
          atitleHeight := round ( ( Width - 120 ) div length ( as_Title )*1.9 );
          atitleHeight := Min ( 32, atitleHeight );
          with RLLeftTopPage do
            p_createBand ( X, Y, atitleHeight + 4, btHeader );
          p_createLabel(2,2,0,APrintFont,RLTitlecolor, as_Title,atitleHeight*2 div 3);
        end
       Else
       with RLLeftTopPage do
        p_createBand ( X, Y, 10, btHeader );
      p_createSystemInfo(ARLBand.Width,2,10,itPageNumber,[fsBold],RLTitlecolor);
      p_createSystemInfo(ARLBand.Width,2,10,itLastPageNumber,[fsBold],RLTitlecolor, '/');
      SomeLeft:=RLLeftTopPage.X;
      with RLLeftTopPage do
       p_createBand ( X, Y + atitleHeight, 30, btColumnHeader  );
      if aresizecolumns > 0 Then
        aresizecolumns:= ( Width - totalgridwidth ) div aresizecolumns;
      for i := 0 to aColumns.Count - 1 do
        if fb_getComponentBoolProperty ( aColumns.Items [ i ], CST_COLUMN_Visible, True ) Then
         Begin
           awidth:=fi_resize ( flin_getComponentProperty ( aColumns.Items [ i ], CST_COLUMN_Width ), i );
           p_createLabel (SomeLeft,2,aWidth,fobj_getComponentObjectProperty(aColumns.Items [ i ],'Font') as TFont,RLColumnHeadercolor, (fobj_getComponentObjectProperty(aColumns.Items [ i ], CST_COLUMN_Title) as TGridColumnTitle).caption);
           inc ( SomeLeft, aWidth );
         end;


    end;
  end;

  procedure CreateListGrid;
  var i : Integer;
  Begin
    with agrid,AReport do
     Begin
      SomeLeft:=RLLeftTopPage.X;
      with RLLeftTopPage do
       p_createBand ( X, Y + atitleHeight + 30, 30, btDetail );
      for i := 0 to aColumns.Count - 1 do
        if fb_getComponentBoolProperty ( aColumns.Items [ i ], CST_COLUMN_Visible, True )
        and ( flin_getComponentProperty ( aColumns.Items [ i ], CST_COLUMN_Width ) > 4 ) Then
         Begin
           awidth:=fi_resize ( flin_getComponentProperty ( aColumns.Items [ i ], CST_COLUMN_Width ), i );
           if  ( aColumns.Items [ i ] is TExtGridColumn ) Then
             AImages:=( aColumns.Items [ i ] as TExtGridColumn ).Images;
           with agrid as TextDBGrid, aColumns.Items [ i ] as {$IFDEF TNT}TTntColumn{$ELSE}{$IFDEF FPC}TRxColumn{$ELSE}TColumn{$ENDIF}{$ENDIF} do
           if AImages <> nil Then
            Begin
              p_createImage (SomeLeft,2,aWidth-4);
              ARLImage.BeforePrint := ReportForm.p_BeforePrintImage;
              SetLength ( RLListImages, high ( RLListImages ) + 2 );
              with RLListImages [ high ( RLListImages )] do
               Begin
                 AImage := ARLImage ;
                 AField := Field ;
                 AGetImageIndex := OnGetImageIndex;
                 AMapImages := fobj_getComponentObjectProperty( aColumns.Items [ i ], 'MapImages' ) as TExtMapImages;
                 AWidth  := Width;
                 ABand   := ARLBand;
               end;
            end
           Else
            p_createDBText(SomeLeft,2,aWidth,Font,RLColumnHeadercolor, FieldName);
           inc ( SomeLeft, aWidth );
         end;

      End;
  end;

  procedure CreateListPrint;
  var i : Integer;
  Begin
    with ADatasource.DataSet,AReport do
     Begin
      SomeLeft:=RLLeftTopPage.X;
      with RLLeftTopPage do
       p_createBand ( X, Y + atitleHeight + 30, 30, btDetail );
      for i := 0 to FieldDefs.Count - 1 do
        if fb_getComponentBoolProperty ( aColumns.Items [ i ], CST_COLUMN_Visible, True )
        and ( flin_getComponentProperty ( aColumns.Items [ i ], CST_COLUMN_Width ) > 4 ) Then
         Begin
           awidth:=fi_resize ( flin_getComponentProperty ( aColumns.Items [ i ], CST_COLUMN_Width ), i );
           AImages:=( aColumns.Items [ i ] as TExtPrintColumn ).Images;
           with agrid as TextDBGrid, aColumns.Items [ i ] as TExtPrintColumn do
           if AImages <> nil Then
            Begin
              p_createImage (SomeLeft,2,aWidth-4);
              ARLImage.BeforePrint := ReportForm.p_BeforePrintImage;
              SetLength ( RLListImages, high ( RLListImages ) + 2 );
              with RLListImages [ high ( RLListImages )] do
               Begin
                 AImage := ARLImage ;
                 AField := Fields [ i ];
                 AGetImageIndex := OnGetImageIndex;
                 AMapImages := fobj_getComponentObjectProperty( aColumns.Items [ i ], 'MapImages' ) as TExtMapImages;
                 AWidth  := Width;
                 ABand   := ARLBand;
               end;
            end
           Else
            p_createDBText(SomeLeft,2,aWidth,Font,RLColumnHeadercolor, Fields [ i ].FieldName);
           inc ( SomeLeft, aWidth );
         end;

      End;
  end;

Begin
  if agrid <> nil
   Then APrintFont := TFont ( fobj_getComponentObjectProperty(agrid,'Font'));
  Result := False;
  aresizecolumns := 0 ;
  aVisibleColumns := 0;
  totalgridwidth := 0;
  PreparePrint;
  if totalgridwidth = 0 Then Exit;
  CreateHeader;
  if agrid  = nil
   Then CreateListPrint
   Else CreateListGrid;
end;

function fb_CreateReport ( const agrid : TCustomDBGrid; const ADatasource : TDatasource; const AColumns : TCollection; const as_Title : String ; const acf_filter : TRLCustomPrintFilter = nil ; APrintFont : TFont = nil): Boolean;
Begin
  ReportForm := TReportForm.create ( nil );
  ADatasource.DataSet.DisableControls;
  with ReportForm do
  try
    AReport.DefaultFilter:=acf_filter;
    Result:=fb_CreateReport ( ReportForm.AReport, agrid, ADatasource, AColumns, as_Title, APrintFont );
    AReport.DataSource:=ADatasource;
    AReport.Preview(nil);
  finally
    Destroy;
    ADatasource.DataSet.EnableControls;
    Finalize ( RLListImages );
    ReportForm := nil;
  end;
end;

{$IFDEF VERSIONS}
initialization
  p_ConcatVersion ( gVer_fonctions_reports );
{$ENDIF}
end.

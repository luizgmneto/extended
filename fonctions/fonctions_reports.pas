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
  Classes, Grids, RLPreview;

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
  CST_PRINT_COLUMN_FONT_COLOR = clBlack;
  CST_PRINT_TITLE_FONT_COLOR  = clBlack;
  CST_PRINT_COLUMN_TITLE_FONT_COLOR = clBlack;
  CST_PRINT_COLUMN_TITLE_FONT_STYLE = [fsBold];

type TBoolArray = Array of Boolean;
  TPrintDrawReportImage= procedure ( Sender:TObject; var PrintIt:boolean) of object;
  IPrintComponent = interface
   ['{B606C7AA-E8CC-4503-ACC7-68A5B3EF1151}']
   procedure DrawReportImage( Sender:TObject; var PrintIt:boolean);
  End;
  { TExtPrintColumn }

  TExtPrintColumn = class(TCollectionItem)
   private
     FWidth   : Integer ;
     FLineBreak,
     FResize   ,
     FVisible  : Boolean;
     FDBTitle : string;
     FFieldName : String;
     FDatasource : TDatasource;
     FImages : TCustomImageList;
     FMapImages : TExtMapImages;
     procedure SetImages( const AValue : TCustomImageList );
     procedure SetMapImages( const AValue : TExtMapImages );
     function  GetFieldName: String;
   public
     constructor Create(ACollection: TCollection); override;
     property Datasource : TDataSource read FDatasource write FDatasource;
   published
     property Width     : Integer  read FWidth   write FWidth default 40;
     property Resize    : Boolean  read FResize  write FResize  default False;
     property Visible   : Boolean  read FVisible write FVisible default true;
     property LineBreak : Boolean  read FLineBreak write FLineBreak default False;
     property DBTitle   : string   read FDBTitle write FDBTitle;
     property FieldName : string   read GetFieldName write FFieldName;
     property Images    : TCustomImageList read FImages    write SetImages;
     property MapImages : TExtMapImages    read FMapImages write SetMapImages;
   end;

  { TExtPrintColumns }
  TExtPrintColumns = class(TCollection)
  private
    FOwner : TComponent;
    function  GetColumn ( Index: Integer): TExtPrintColumn;
    procedure SetColumn ( Index: Integer; Value: TExtPrintColumn);
  public
    procedure SetDatasource(const AColumn: TExtPrintColumn); overload; virtual;
    procedure SetDatasource; overload; virtual;
    constructor Create(const AOwner: TComponent; const aItemClass: TCollectionItemClass); virtual;
    function Add: TExtPrintColumn;
    property Owner : TComponent read FOwner;
  {$IFDEF FPC}
  published
  {$ENDIF}
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
    ExtTitleColorBack : TColor = clSkyBlue;
    ExtTitleColorBorder : TColor = clBlue;
    ExtTitleColorFont : TFont  = nil;
    ExtColumnColorBorder : TColor = clBlue;
    ExtColumnHeaderFont  : TFont  = nil;
    ExtColumnHeaderColorBack : TColor = clSkyBlue;
    ExtColumnFont        : TFont  = nil;
    ExtColumnHBorders    : Boolean = False;
    ExtColumnVBorders    : Boolean = True;
    ExtColumnColorBack   : TColor = clWhite;
    ExtLandscapeColumnsCount : Integer = 9;
    ExtHeader  : TRLBand = nil;

function fb_CreateReport ( const AReportComponent : TComponent ; const AReport : TRLReport ; const agrid : TCustomDBGrid; const ADatasource : TDatasource; const AColumns : TCollection; const as_Title : String): Boolean;
function fref_CreateReport ( const AReportComponent : TComponent ; const agrid : TCustomDBGrid; const ADatasource : TDatasource; const AColumns : TCollection; const as_Title : String ; const acf_filter : TRLCustomPrintFilter = nil): TReportForm;
procedure p_DrawReportImage( Sender:TObject; var PrintIt:boolean);

implementation

uses fonctions_proprietes,
     fonctions_images,Printers,
     RLTypes, unite_messages,
     fonctions_string,
     Math,strutils;

{ TExtPrintColumns }

function TExtPrintColumns.GetColumn(Index: Integer): TExtPrintColumn;
begin
  result := TExtPrintColumn( inherited Items[Index] );
end;

procedure TExtPrintColumns.SetColumn(Index: Integer;
   Value: TExtPrintColumn);
begin
  Items[Index].Assign( Value );
end;

procedure TExtPrintColumns.SetDatasource ( const AColumn: TExtPrintColumn );
var ADatasource : TDataSource;
begin
  AColumn.Datasource := fobj_getComponentObjectProperty(FOwner,CST_PROPERTY_DATASOURCE) as TDataSource;
end;

procedure TExtPrintColumns.SetDatasource;
var i : Integer;
begin
  for i := 0 to Count - 1 do
    SetDatasource(Items[i]);
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
  SetDatasource ( Result );
end;

{ TExtPrintColumn }

procedure TExtPrintColumn.SetImages(const AValue: TCustomImageList);
begin
  if AValue<> FImages then
   FImages := AValue;
end;

procedure TExtPrintColumn.SetMapImages(const AValue: TExtMapImages);
begin
  if AValue<> FMapImages then
   FMapImages := AValue;
end;

function TExtPrintColumn.GetFieldName: String;
begin
  if FFieldName <> ''
   Then Result:=FFieldName
   Else
    if    Assigned(FDatasource)
    and   Assigned(FDatasource.DataSet) Then
     with FDatasource.DataSet do
      if Active
      and ( Index < FieldDefs.Count )
       then
        Begin
          Result := FieldDefs [ Index ].Name;
          FFieldName:=Result;
        end;
end;

constructor TExtPrintColumn.Create(ACollection: TCollection);
begin
  inherited Create(ACollection);
  FWidth  :=40;
  FResize :=False;
  FVisible:=True;
  FImages := nil;
  FMapImages := nil;
  FDBTitle:='';
  FFieldName:='';
  FDatasource := nil;
end;

procedure p_DrawReportImage( Sender:TObject; var PrintIt:boolean);
var aimageindex : Integer;
    Abitmap : Tbitmap ;
    ADatasource : TDatasource;
    I : Integer;
Begin
  for i := 0 to high ( RLListImages ) do
   with RLListImages [ i ] do
    if AImage = Sender Then
      Begin
        aimageIndex:=-1;
        if assigned ( AGetImageIndex )
         Then aimageIndex := AGetImageIndex ( AImage, AField )
         Else
          if Assigned(AMapImages) Then
           aimageIndex := AMapImages.ImageIndexOf ( AField.Asstring )
          else
           if AField is tNumericField Then
            Begin
              aimageIndex := AField.AsInteger;
            end;
        if aimageIndex <> -1 Then
         Begin
           ABitmap := TBitmap.Create;
           Aimages.GetBitmap ( aimageIndex, ABitmap );
           with AImage do
            p_ChangeTailleBitmap(ABitmap,Height,Width,True);
           with AImage.Picture,Abitmap do
            Begin
             Bitmap.Canvas.Brush.Color := clWhite;
             Bitmap.Width  := Width;
             Bitmap.Height := Height;
             Bitmap.Canvas.FillRect(
               {$IFNDEF FPC} Rect (  {$ENDIF}
               0, 0, ACellWidth, Height {$IFNDEF FPC}){$ENDIF});
             Bitmap.Canvas.Draw (( ACellWidth - Width ) div 2, 0, Abitmap );
             Bitmap.Modified := True;
             {$IFNDEF FPC}
             Dormant;
             {$ENDIF}
             FreeImage;
             Free;
            end;
         end;
      End;
End;

function fb_CreateReport ( const AReportComponent : TComponent ;const AReport : TRLReport ; const agrid : TCustomDBGrid; const ADatasource : TDatasource; const AColumns : TCollection; const as_Title : String): Boolean;
var totalgridwidth, aresizecolumns, atitleHeight, aVisibleColumns, SomeLeft, totalreportwidth, aWidth, ALinesAddedHeader, ALinesAddedColumns : Integer;
    ARLLabel : TRLLabel;
    ARLDBText : TRLDBText;
    ARLImage : TRLImage;
    ARLBand : TRLBand;
    AImages : TCustomImageList;
    ARLSystemInfo : TRLSystemInfo;
  // procedure p_AdaptBands;
  // Compressing
  procedure p_AdaptBands ( const AIsFirst : Boolean ; const ALines : Integer = 1 );
  Begin
    ARLBand.Margins.BottomMargin:=0;
    ARLBand.Margins.TopMargin   :=0;
    ARLBand.InsideMargins.BottomMargin:=0;
    ARLBand.InsideMargins.TopMargin   :=0;
    if not AIsFirst Then
      ARLBand.Height:=ARLLabel.Height*ALines;
  end;

  procedure p_createLabel ( const ALeft, ATop, AWidth : Integer ; const afont : TFont; const as_Text : String = '' ; const ai_SizeFont : Integer = 0 );
  Begin
    ARLLabel := TRLLabel.Create(AReport);
    with ARLLabel do
     Begin
      Parent:=ARLBand;
      Top:=ATop;
      Left:=ALeft;
      with Font do
       Begin
        assign ( afont );
         if ai_SizeFont <> 0 Then
          Size:=ai_SizeFont;
       end;
      if AWidth > 0 Then
       Begin
        AutoSize:=False;
        Width   :=AWidth;
       end;
      Caption:=as_Text;
     end;
  end;

  procedure p_createSystemInfo ( const ALeft, ATop : Integer ; const AInfo:TRLInfoType; const afont : TFont; const AFontWidth : Integer = 0; const as_Text : String = '' ; const AAlign : TRLControlAlign = faRight; const ALayout : TRLTextLayout = {$IFDEF FPC }TRLTextLayout.{$ENDIF}tlJustify );
  Begin
    ARLSystemInfo := TRLSystemInfo.Create(AReport);
    with ARLSystemInfo do
     Begin
      Parent:=ARLBand;
      Top:=ATop;
      Left:=ALeft;
      with Font do
        Begin
          Assign(afont);
          if AFontWidth <> 0 Then
            Size:=AFontWidth;
        end;
      Align:=AAlign;
      Layout:=ALayout;
      Text:=as_Text;
      Info:=AInfo;
     end;
  end;

  procedure p_createBand ( const ALeft, ATop, Aheight : Integer ; const Abandtype : TRLBandType ; const AColor : TColor = clWhite );
  Begin
    ARLBand := TRLBand.Create(AReport);
    with ARLBand do
     Begin
      Parent:=AReport;
      BandType:=Abandtype;
      Top:=ATop;
      Left:=ALeft;
      Color:=AColor;
      Height:=Aheight;
      Width:=aReport.Width-RLLeftTopPage.X*2;
     end;
  end;
  procedure p_createDBText ( const ALeft, ATop, AWidth : Integer ; const afont : TFont; const as_Fieldname : String ; const ai_SizeFont : Integer = 0);
  Begin
    ARLDBText := TRLDBText.Create(AReport);
    with ARLDBText do
     Begin
      Parent:=ARLBand;
      DataSource:=ADatasource;
      Top:=ATop;
      Left:=ALeft;
      with Font do
       Begin
        Assign(afont);
        if ai_SizeFont <> 0 Then
          Size:=ai_SizeFont;
       end;
      if AWidth > 0 Then
       Begin
         AutoSize:=False;
         Width:=AWidth;
       end;
      DataField:=as_Fieldname;
     end;
  end;

  procedure p_createImage ( const ALeft, ATop, AWidth : Integer);
  Begin
    ARLImage := TRLImage.Create(AReport);
    with ARLImage do
     Begin
      Parent:=ARLBand;
      Top:=ATop;
      Left:=ALeft;
      Width:=AWidth;
     end;
  end;

  function fi_resize ( const ai_width, aindex : Integer ):Integer;
  Begin
    if  fb_getComponentBoolProperty ( aColumns.Items [ aindex ], CST_COLUMN_Resize, True )
     Then Result:=ai_width+aresizecolumns
     Else Result:=ai_Width;
  end;

  procedure PreparePrint;
  var i, Aline : Integer;
  Begin
    ALinesAddedHeader:=0;
    ALinesAddedColumns:=0;
    with agrid,AReport do
     Begin
      Clear;
      for i := 0 to aColumns.Count - 1 do
       with aColumns do
        if fb_getComponentBoolProperty ( Items [ i ], CST_COLUMN_Visible, True )
        and ( flin_getComponentProperty( Items [ i ], CST_COLUMN_Width ) > 4 ) Then
         Begin
          inc ( totalgridwidth, flin_getComponentProperty(Items [ i ], CST_COLUMN_Width ) );
          inc ( aVisibleColumns );
          if fb_getComponentBoolProperty ( Items [ i ], CST_COLUMN_Resize, True )
            Then inc ( aresizecolumns );
          if fb_getComponentBoolProperty ( Items [ i ], 'LineBreak', False )
           Then inc ( ALinesAddedColumns );
         end;
      if aVisibleColumns >= ExtLandscapeColumnscount
       Then PageSetup.Orientation:=poLandscape
       Else PageSetup.Orientation:=poPortrait;
     End;
  end;

  procedure p_DrawBorders ( const ABorders : TRLBorders ; const AColor : TColor; const ADrawLeft, AHBorders, AVBorders : Boolean );
  Begin
    ABorders.Color := AColor;
    if AHBorders Then
     with ABorders do
      Begin
       DrawTop   :=True;
       DrawBottom:=True;
      end;
    if AVBorders Then
     with ABorders do
      Begin
       DrawLeft   :=ADrawLeft;
       DrawRight:=True;
      end;
  end;

  procedure CreateHeader;
  var i, j : Integer;
      ACanvas : TCanvas;
      LIsFirst : Boolean;
      Alines : Integer;
      LString : TStringArray;
  Begin
   ACanvas:=TCanvas.Create;
   with agrid,AReport do
    try
      Alines := 1;
      if ExtHeader = nil Then
       Begin
        if as_Title > '' Then
          Begin
            atitleHeight := round ( ( Width - 150 ) div length ( as_Title )*1.9 );
            atitleHeight := Min ( 32, atitleHeight );
            with RLLeftTopPage do
              p_createBand ( X, Y, atitleHeight + 4, btHeader, ExtTitleColorBack );
            p_DrawBorders ( ARLBand.Borders, ExtTitleColorBorder, True, ExtColumnVBorders, True );
            p_createLabel(2,2,0, ExtTitleColorFont, as_Title,atitleHeight*2 div 3);
          end
         Else
         with RLLeftTopPage do
          p_createBand ( X, Y, 10, btHeader, ExtTitleColorBack );
         p_createSystemInfo(ARLBand.Width,2,itFullDate, ExtTitleColorFont, 10,'',faRightTop);
         p_createSystemInfo(ARLBand.Width,2,itLastPageNumber, ExtTitleColorFont, 10, '/', faRightBottom);
         p_createSystemInfo(ARLBand.Width,2,itPageNumber, ExtTitleColorFont, 10, '', faRightBottom);
       end
      Else
       ExtHeader.Parent:=AReport;
      SomeLeft:=0;
      with RLLeftTopPage do
       Begin
        p_createBand ( 0, Y + atitleHeight, 4, btHeader, clWhite );
        inc ( atitleHeight, 4 );
        p_createBand ( 0, Y + atitleHeight, 30, btColumnHeader, ExtColumnHeaderColorBack  );
       end;
      ACanvas.font.Assign(ExtColumnHeaderFont);
      if aresizecolumns > 0 Then
        aresizecolumns:= ( Width - totalgridwidth ) div aresizecolumns;
      LIsFirst := True;
      with aColumns do
      for i := 0 to Count - 1 do
       Begin
        awidth:=fi_resize ( flin_getComponentProperty ( Items [ i ], CST_COLUMN_Width ), i );
        if agrid = nil
         Then LString := fs_SeparateTextFromWidth(fs_getComponentProperty(Items [ i ], 'DBTitle'),aWidth,ACanvas,' ')
         Else LString := fs_SeparateTextFromWidth((fobj_getComponentObjectProperty(Items [ i ], CST_COLUMN_Title) as {$IFDEF FPC}TGridColumnTitle{$ELSE}TColumnTitle{$ENDIF}).caption,aWidth,ACanvas,' ');
        if high ( LString ) > ALinesAddedHeader Then
         ALinesAddedHeader:=high ( LString );
       end;
      with aColumns do
      for i := 0 to Count - 1 do
        if fb_getComponentBoolProperty ( Items [ i ], CST_COLUMN_Visible, True ) Then
         Begin
           awidth:=fi_resize ( flin_getComponentProperty ( Items [ i ], CST_COLUMN_Width ), i );
          if agrid = nil
           Then LString := fs_SeparateTextFromWidth(fs_getComponentProperty(Items [ i ], 'DBTitle'),aWidth,ACanvas,' ')
           Else LString := fs_SeparateTextFromWidth((fobj_getComponentObjectProperty(Items [ i ], CST_COLUMN_Title) as {$IFDEF FPC}TGridColumnTitle{$ELSE}TColumnTitle{$ENDIF}).caption,aWidth,ACanvas,' ');
//          RLColumnHeaderFont.GetTextSize(LString,Apos,j);
           for j := 0 to ALinesAddedHeader do
            Begin
             if j <= high ( LString )
              Then p_createLabel (SomeLeft,2+j*ARLLabel.Height,aWidth, ExtColumnHeaderFont, LString [ j ] )
              Else p_createLabel (SomeLeft,2+j*ARLLabel.Height,aWidth, ExtColumnHeaderFont, '' );
             p_DrawBorders ( ARLLabel.Borders, ExtColumnColorBorder, LIsFirst, ExtColumnHBorders, ExtColumnVBorders );
            end;
           if high ( LString ) + 1 > Alines Then
            Alines:= high ( LString )+1;
           inc ( SomeLeft, aWidth );
           LIsFirst := False;
         end;

    finally
     ACanvas.Free;
    end;
   p_DrawBorders ( ARLBand.Borders, ExtColumnColorBorder, False, ExtColumnVBorders, False );
   p_AdaptBands ( LIsFirst, Alines );
  end;

  procedure p_DesignCell(const AItem : TCollectionItem ;var AIsFirst : Boolean; var ATop,Aline : Integer);
  Begin
    p_DrawBorders ( ARLDBText.Borders, ExtColumnColorBorder, AIsFirst, ExtColumnHBorders, ExtColumnVBorders );
    if fb_getComponentBoolProperty ( AItem, 'LineBreak', False ) then
     Begin
       inc ( Atop, ARLDBText.Height );
       SomeLeft:=0;
       inc(Aline);
       AIsFirst:=True;
     end;
  end;

  procedure p_CreatePrintField ( const AItem : TCollectionItem ; var AIsFirst : Boolean; var ATop, Aline : Integer ; const AIWidth : Integer ; const Adataset : TDataset );
  var I : Integer;
  Begin
    AImages:= fobj_getComponentObjectProperty ( AItem,'Images') as TCustomImageList;
    if AImages <> nil Then
     Begin
       p_createImage (SomeLeft,2,aWidth-4);
       p_DrawBorders ( ARLImage.Borders, ExtColumnColorBorder, AIsFirst, ExtColumnHBorders, ExtColumnVBorders );
       ARLImage.BeforePrint := TRLBeforePrintEvent ( fmet_getComponentMethodProperty  ( AReportComponent, 'DrawReportImage' ));
       SetLength ( RLListImages, high ( RLListImages ) + 2 );
       with RLListImages [ high ( RLListImages )] do
        Begin
          AImage := ARLImage ;
          AField := Adataset.FieldByName ( fs_getComponentProperty( AItem, CST_PROPERTY_FIELDNAME));
          AGetImageIndex := TFieldIndexEvent (fmet_getComponentMethodProperty( AItem, 'OnGetImageIndex' ));
          AMapImages := fobj_getComponentObjectProperty( AItem, 'MapImages' ) as TExtMapImages;
          AWidth  := flin_getComponentProperty ( AItem, CST_COLUMN_Width );
          ABand   := ARLBand;
        end;
     end
    Else
     for i := 0 to ALinesAddedColumns do
      if i = Aline Then
       Begin
        p_createDBText(SomeLeft,ATop,aWidth, ExtColumnFont, fs_getComponentProperty( AItem, CST_PROPERTY_FIELDNAME));
        p_DesignCell( AItem, AIsFirst, ATop, Aline );
       end
       Else
       Begin
        p_createLabel(SomeLeft,ATop,aWidth, ExtColumnFont, '' );
        p_DesignCell( AItem, AIsFirst, ATop, Aline );
       end
  end;

  procedure p_InitList(var ATop : Integer; var AIsFirst : Boolean );
  Begin
    SomeLeft:=0;
    with RLLeftTopPage do
     p_createBand ( X, Y + atitleHeight + 30, 30, btDetail, ExtColumnColorBack );
    AIsFirst := True;
    ATop := 0;
  end;

  procedure CreateListGrid;
  var i,ALine, ATop : Integer;
      LIsFirst : Boolean;
  Begin
    ALine := 0;
    with agrid,AReport do
     Begin
      p_InitList ( ATop, LIsFirst );
      with aColumns do
      for i := 0 to Count - 1 do
        if fb_getComponentBoolProperty ( Items [ i ], CST_COLUMN_Visible, True )
        and ( flin_getComponentProperty ( Items [ i ], CST_COLUMN_Width ) > 4 ) Then
         Begin
           awidth:=fi_resize ( flin_getComponentProperty ( Items [ i ], CST_COLUMN_Width ), i );
           p_CreatePrintField ( Items [ i ], LIsFirst,ATop,ALine,AWidth,ADataSource.DataSet);
           inc ( SomeLeft, aWidth );
           LIsFirst := False;
         end;
      End;
    p_AdaptBands ( LIsFirst );
  end;
  procedure CreateListPrint;
  var i,ALine, ATop : Integer;
      LIsFirst : Boolean;
  Begin
    ALine := 0;
    with ADatasource.DataSet,AReport do
     Begin
      p_InitList ( ATop, LIsFirst );
      with aColumns do
      for i := 0 to Count - 1 do
        if fb_getComponentBoolProperty ( Items [ i ], CST_COLUMN_Visible, True )
        and ( flin_getComponentProperty ( Items [ i ], CST_COLUMN_Width ) > 4 ) Then
         Begin
           awidth:=fi_resize ( flin_getComponentProperty ( Items [ i ], CST_COLUMN_Width ), i );
           p_CreatePrintField ( Items [ i ], LIsFirst,ATop,ALine,AWidth,ADataSource.DataSet);
           inc ( SomeLeft, aWidth );
           LIsFirst := False;
         end;

      End;
    p_AdaptBands ( LIsFirst );
  end;
Begin
  Result := False;
  aresizecolumns  := 0 ;
  aVisibleColumns := 0;
  totalgridwidth  := 0;
  PreparePrint;
  if totalgridwidth = 0 Then Exit;
  CreateHeader;
  if agrid  = nil
   Then CreateListPrint
   Else CreateListGrid;
  AReport.DataSource:=ADatasource;
end;

function fref_CreateReport ( const AReportComponent : TComponent ; const agrid : TCustomDBGrid; const ADatasource : TDatasource; const AColumns : TCollection; const as_Title : String ; const acf_filter : TRLCustomPrintFilter = nil): TReportForm;
Begin
  Result := TReportForm.create ( Application );
  Result.RLReport.DefaultFilter:=acf_filter;
  fb_CreateReport ( AReportComponent, Result.RLReport, agrid, ADatasource, AColumns, as_Title );
end;

initialization
{$IFDEF VERSIONS}
  p_ConcatVersion ( gVer_fonctions_reports );
{$ENDIF}
  ExtTitleColorFont   := TFont.create;
  ExtColumnHeaderFont := TFont.Create;
  ExtColumnFont       := TFont.Create;
  ExtColumnFont.Size  := 10;
  ExtTitleColorFont  .Color := CST_PRINT_TITLE_FONT_COLOR;
  ExtColumnHeaderFont.Color := CST_PRINT_COLUMN_TITLE_FONT_COLOR;
  ExtColumnHeaderFont.Style := CST_PRINT_COLUMN_TITLE_FONT_STYLE;
  ExtColumnHeaderFont.Size  := 11;
  ExtColumnFont      .Color := CST_PRINT_COLUMN_FONT_COLOR;
finalization
  ExtTitleColorFont  .Free;
  ExtColumnHeaderFont.Free;
  ExtColumnFont      .Free;
end.

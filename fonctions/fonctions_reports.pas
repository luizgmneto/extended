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
                        			                 BugsStory : 'Version 1.0.0.2 : Testing reports.' + #13#10 +
                                                                             'Version 1.0.0.1 : image centering.' + #13#10 +
                                                                             'Version 1.0.0.0 : Working.';
                        			                 UnitType : 1 ;
                        			                 Major : 1 ; Minor : 0 ; Release : 0 ; Build : 2 );
{$ENDIF}
  CST_COLUMN_Visible = 'Visible';
  CST_COLUMN_Width   = 'Width';
  CST_COLUMN_MIN_Width= 4;
  CST_COLUMN_Resize  = 'Resize';
  CST_COLUMN_Title   = 'Title';
  CST_COLUMN_Images  = 'Images';
  CST_PRINT_FONT_SIZE = 9;
  CST_PRINT_COLUMN_FONT_COLOR = clBlack;
  CST_PRINT_TITLE_FONT_COLOR  = clBlack;
  CST_PRINT_COLUMN_TITLE_FONT_COLOR = clBlack;
  CST_PRINT_COLUMN_TITLE_FONT_STYLE = [fsBold];
  CST_PRINT_COLUMN_BREAKCAPTION = 'BreakCaption' ;
  CST_PRINT_COLUMN_LINEBREAK = 'LineBreak' ;
  CST_PRINT_COMPONENT_EVENT = 'DrawReportImage';


var RLLeftTopPage : TPoint = ( X: 20; Y:20 );
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

function fb_CreateReport ( const AReport : TRLReport ; const agrid : TCustomDBGrid; const ADatasource : TDatasource; const AColumns : TCollection; const ATempCanvas : TCanvas;const as_Title : String): Boolean;
function fref_CreateReport ( const agrid : TCustomDBGrid; const ADatasource : TDatasource; const AColumns : TCollection; const as_Title : String ; const acf_filter : TRLCustomPrintFilter = nil): TReportForm;

implementation

uses fonctions_proprietes,
     fonctions_images,Printers,
     RLTypes, unite_messages,
     fonctions_string,
     u_reports_rlcomponents,
     Math,strutils;



function fb_CreateReport ( const AReport : TRLReport ; const agrid : TCustomDBGrid; const ADatasource : TDatasource; const AColumns : TCollection; const ATempCanvas : TCanvas;const as_Title : String): Boolean;
var totalgridwidth, aresizecolumns, atitleHeight, AlineHeight, aVisibleColumns, SomeLeft, totalreportwidth, aWidth, ALinesAddedHeader, ALinesAddedColumns : Integer;
    ARLLabel : TRLLabel;
    ARLDBText : TRLDBText;
    ARLImage : TRLCustomImage;
    ARLBand : TRLBand;
    LImages : TCustomImageList;
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
     Begin
      ARLBand.Height:=ARLLabel.Height*ALines;
      AlineHeight := ARLLabel.Height;
     end;
  end;

  procedure p_createLabel ( const ALeft, ATop, AWidth : Integer ; const afont : TFont; const as_Text : String = '' ; const ai_SizeFont : Integer = 0 );
  Begin
    ARLLabel := TRLLabel.Create(AReport.Owner);
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

  procedure p_createSystemInfo ( const ALeft, ATop, Awidth : Integer ; const AInfo:TRLInfoType; const afont : TFont; const AFontWidth : Integer = 0; const as_Text : String = '' ; const AAlign : TRLControlAlign = faRight ; const AAlignment : TRLTextAlignment = TRLTextAlignment(taRightJustify) ; const ALayout : TRLTextLayout = {$IFDEF FPC }TRLTextLayout.{$ENDIF}tlJustify);
  Begin
    ARLSystemInfo := TRLSystemInfo.Create(AReport.Owner);
    with ARLSystemInfo do
     Begin
      Parent:=ARLBand;
      HoldStyle:=hsRelatively;
      Top:=ATop;
      Left:=ALeft;
      with Font do
        Begin
          Assign(afont);
          if AFontWidth <> 0 Then
            Size:=AFontWidth;
        end;
      Align:=AAlign;
      Alignment:=AAlignment;
      Layout:=ALayout;
      Text:=as_Text;
      Info:=AInfo;
      if awidth <> 0 Then
       Begin
        AutoSize:=False;
        Width := Awidth;
       end;
     end;
  end;

  procedure p_createBand ( const ALeft, ATop, Aheight : Integer ; const Abandtype : TRLBandType ; const AColor : TColor = clWhite );
  Begin
    ARLBand := TRLBand.Create(AReport.Owner);
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
    ARLDBText := TRLDBText.Create(AReport.Owner);
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

  function fb_Visible ( const AItem : TCollectionItem ) : Boolean;
  Begin
    Result :=    fb_getComponentBoolProperty ( AItem, CST_COLUMN_Visible, True )
           and ( flin_getComponentProperty ( AItem, CST_COLUMN_Width ) > CST_COLUMN_MIN_Width )
           and assigned ( ADatasource.DataSet.FindField(fs_getComponentProperty ( AItem, CST_PROPERTY_FIELDNAME )));

  end;

  procedure p_createImage ( const ALeft, ATop, AWidth : Integer);
  Begin
    ARLImage := TRLImage.Create(AReport.Owner);
    with ARLImage do
     Begin
      Parent:=ARLBand;
      Top:=ATop;
      Left:=ALeft;
      Width:=AWidth;
     end;
  end;

  procedure p_createDBImage ( const ALeft, ATop, AWidth, AHeight : Integer; const AField : String );
  Begin
    ARLImage := TRLDBExtImage.Create(AReport.Owner);
    with ARLImage as TRLDBExtImage do
     Begin
      Parent:=ARLBand;
      Top:=ATop;
      Left:=ALeft;
      Height := AHeight;
      Width:=AWidth;
      DataField:=AField;
      DataSource:=ADatasource;
     end;
  end;

  procedure p_createDBImageList ( const ALeft, ATop, AWidth, AHeight : Integer; const AField : String ; const AImages : TCustomImageList);
  Begin
    ARLImage := TRLDBExtImageList.Create(AReport.Owner);
    with ARLImage as TRLDBExtImageList do
     Begin
      Parent:=ARLBand;
      Top:=ATop;
      Left:=ALeft;
      Height := AHeight;
      Width:=AWidth;
      DataField:=AField;
      DataSource:=ADatasource;
      Images := AImages;
     end;
  end;

  function fi_resize ( const ai_width, aindex : Integer ):Integer;
  Begin
    if  fb_getComponentBoolProperty ( aColumns.Items [ aindex ], CST_COLUMN_Resize, True )
     Then Result:=ai_width+aresizecolumns
     Else Result:=ai_Width;
  end;

  procedure PreparePrint;
  var i, Aline, ATemp : Integer;
      lcountedcolumn : Boolean;
  Begin
    ALinesAddedHeader:=0;
    ALinesAddedColumns:=0;
    aresizecolumns  := 0 ;
    aVisibleColumns := 0;
    totalgridwidth  := 0;
    lcountedcolumn := True;
    with AReport do
     Begin
      Clear;
      for i := 0 to aColumns.Count - 1 do
       with aColumns do
        Begin
          if fb_Visible ( Items [ i ] ) Then
           Begin
            if lcountedcolumn Then
             Begin
              inc ( totalgridwidth, flin_getComponentProperty(Items [ i ], CST_COLUMN_Width ) );
              inc ( aVisibleColumns );
              if fb_getComponentBoolProperty ( Items [ i ], CST_COLUMN_Resize, True )
                Then inc ( aresizecolumns );
             end;
           end;
          ATemp := flin_getComponentProperty ( Items [ i ], CST_PRINT_COLUMN_LINEBREAK, -1 );
          if  ( ATemp > -1 )
          and ( ATemp < i  )
           Then
            Begin
              inc ( ALinesAddedColumns );
              lcountedcolumn := False;
            end;
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
      LIsFirst : Boolean;
      Alines : Integer;
      LString : TStringArray;
  Begin
   with AReport do
    try
      Alines := 1;
      if ExtHeader = nil Then
       Begin
        if as_Title > '' Then
          Begin
            atitleHeight := round ( ( Width - 160 ) div length ( as_Title )*1.9 );
            atitleHeight := Min ( 32, atitleHeight );
            with RLLeftTopPage do
              p_createBand ( X, Y, atitleHeight + 4, btHeader, ExtTitleColorBack );
            p_DrawBorders ( ARLBand.Borders, ExtTitleColorBorder, True, ExtColumnVBorders, True );
            p_createLabel(2,2,0, ExtTitleColorFont, as_Title,atitleHeight*2 div 3);
          end
         Else
         with RLLeftTopPage do
          p_createBand ( X, Y, 10, btHeader, ExtTitleColorBack );
         with ARLBand do
          Begin
           p_createSystemInfo(Width,2,0,itFullDate, ExtTitleColorFont, 0,'',faRightTop);
           Height:=Max(ARLSystemInfo.Height*2,Height);  // adapt height to 2 lines of system info
           p_createSystemInfo(Width,Height,0,itLastPageNumber, ExtTitleColorFont, 0, '/', faRightBottom,TRLTextAlignment(taLeftJustify));
           // due to autosize bug
           ARLSystemInfo.Anchors:=[fkRight,fkBottom];
           ARLSystemInfo.Width:=43;
           ARLSystemInfo.Left := Width - 44;
           p_createSystemInfo(Width,Height,0,itPageNumber, ExtTitleColorFont, 0, '', faRightBottom);
           // due to autosize bug
           ARLSystemInfo.Anchors:=[fkRight,fkBottom];
           ARLSystemInfo.Width:=44;
           ARLSystemInfo.Left := Width - 88;
          end;
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
      ATempCanvas.font.Assign(ExtColumnHeaderFont);
      if aresizecolumns > 0 Then
        aresizecolumns:= ( ARLBand.Width - totalgridwidth ) div aresizecolumns;
      LIsFirst := True;
      with aColumns do
      for i := 0 to Count - 1 do
       if fb_Visible ( Items [ i ] ) Then
       Begin
        awidth:=fi_resize ( flin_getComponentProperty ( Items [ i ], CST_COLUMN_Width ), i );
        if agrid = nil
         Then LString := fs_SeparateTextFromWidth(fs_getComponentProperty(Items [ i ], 'DBTitle'),aWidth,ATempCanvas,' ')
         Else LString := fs_SeparateTextFromWidth((fobj_getComponentObjectProperty(Items [ i ], CST_COLUMN_Title) as {$IFDEF FPC}TGridColumnTitle{$ELSE}TColumnTitle{$ENDIF}).caption,aWidth,ATempCanvas,' ');
        if high ( LString ) > ALinesAddedHeader Then
         ALinesAddedHeader:=high ( LString );
       end;
      with aColumns do
      for i := 0 to Count - 1 do
       Begin
         if fb_Visible ( Items [ i ] ) Then
           Begin
            if fs_getComponentProperty ( Items [ i ], CST_PRINT_COLUMN_BREAKCAPTION ) <> '' Then
              Begin
               ATempCanvas.font.Assign(ExtColumnFont);
               aWidth:=ATempCanvas.TextWidth(fs_getComponentProperty ( Items [ i ], CST_PRINT_COLUMN_BREAKCAPTION ));
               ATempCanvas.font.Assign(ExtColumnHeaderFont);
               inc ( SomeLeft, aWidth );
              end;
             awidth:=fi_resize ( flin_getComponentProperty ( Items [ i ], CST_COLUMN_Width ), i );
            if agrid = nil
             Then LString := fs_SeparateTextFromWidth(fs_getComponentProperty(Items [ i ], 'DBTitle'),aWidth,ATempCanvas,' ')
             Else LString := fs_SeparateTextFromWidth((fobj_getComponentObjectProperty(Items [ i ], CST_COLUMN_Title) as {$IFDEF FPC}TGridColumnTitle{$ELSE}TColumnTitle{$ENDIF}).caption,aWidth,ATempCanvas,' ');
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
        if flin_getComponentProperty ( Items [ i ], CST_PRINT_COLUMN_LINEBREAK ) > -1 Then
         Break;
       end;

    finally
    end;
   p_DrawBorders ( ARLBand.Borders, ExtColumnColorBorder, False, ExtColumnVBorders, False );
   p_AdaptBands ( LIsFirst, Alines );
  end;

  // borders and line break
  procedure p_DesignCell(const ARLControl : TRLCustomControl; const AItem : TCollectionItem ;var AIsFirst : Boolean; var ATop,Aline, Aheight : Integer);
  Begin
    p_DrawBorders ( ARLControl.Borders, ExtColumnColorBorder, AIsFirst, ExtColumnHBorders, ExtColumnVBorders );
    Aheight:=ARLControl.Height;
  end;

  // set a printed field
  procedure p_CreatePrintField ( const AItem : TCollectionItem ; var AIsFirst : Boolean; var ATop, Aline, Aheight : Integer ; const AIWidth : Integer ; const Adataset : TDataset ; const ASBreakCaption : String = '' );
  var I : Integer;
  Begin
    if assigned ( AItem ) Then
     Begin
      LImages:= fobj_getComponentObjectProperty ( AItem,'Images') as TCustomImageList;
      if LImages <> nil Then
       Begin
         p_createDBImageList (SomeLeft,ATop,aiWidth-4,AlineHeight, fs_getComponentProperty( AItem, CST_PROPERTY_FIELDNAME),LImages);
         with ARLImage as TRLCustomDBExtImageList do
          Begin
            OnGetImageIndex := TFieldIndexEvent (fmet_getComponentMethodProperty( AItem, 'OnGetImageIndex' ));
            MapImages := fobj_getComponentObjectProperty( AItem, 'MapImages' ) as TExtMapImages;
          end;
         p_DesignCell( ARLImage, AItem, AIsFirst, ATop, Aline, Aheight );
       end
      Else
       Begin
        if Adataset.FieldByName(fs_getComponentProperty( AItem, CST_PROPERTY_FIELDNAME)) is TBlobField
         Then Begin p_createDBImage (SomeLeft,ATop,aiWidth, AlineHeight  , fs_getComponentProperty( AItem, CST_PROPERTY_FIELDNAME)); p_DesignCell( ARLImage , AItem, AIsFirst, ATop, Aline, Aheight ); End
         Else Begin p_createDBText  (SomeLeft,ATop,aiWidth, ExtColumnFont, fs_getComponentProperty( AItem, CST_PROPERTY_FIELDNAME)); p_DesignCell( ARLDBText, AItem, AIsFirst, ATop, Aline, Aheight ); End;

       end
    End
   Else
     Begin
      p_createLabel(SomeLeft,ATop,aiWidth, ExtColumnFont, ASBreakCaption );
      p_DesignCell( ARLLabel, AItem, AIsFirst, ATop, Aline, Aheight );
     end
  end;

  // initing columns
  procedure p_InitList(var ATop : Integer; var AIsFirst : Boolean );
  Begin
    SomeLeft:=0;
    with RLLeftTopPage do
     p_createBand ( X, Y + atitleHeight + 30, 30, btDetail, ExtColumnColorBack );
    AIsFirst := True;
    ATop := 0;
  end;
  procedure p_Linebreak ( const AItem : TCollectionItem; var AHeight, ATop, Aline, ADecColumn : Integer; var AIsFirst : Boolean );
  var ABreak, j : Integer;
      LSBreakCaption : String;
  Begin
    ABreak := flin_getComponentProperty ( AItem, CST_PRINT_COLUMN_LINEBREAK );
    if assigned ( AItem )
    and ( ABreak > -1 )
    and ( ABreak < ADecColumn )Then
     Begin
       LSBreakCaption:=fs_getComponentProperty(AItem,CST_PRINT_COLUMN_BREAKCAPTION);
       inc ( Atop, AHeight );
       SomeLeft:=0;
       inc(Aline);
       ADecColumn := ABreak - 1;
       SomeLeft:=0;
       aWidth:=0;
       AIsFirst:=True;
       // aligning
       with AColumns do
         for j := 0 to ADecColumn do
           if fb_Visible ( items [ j ] ) Then
              Begin
                inc(awidth,fi_resize ( flin_getComponentProperty ( Items [ j ], CST_COLUMN_Width ), j ));
               end;
       if aWidth > 0 Then
          Begin
            p_CreatePrintField ( nil, AIsFirst,ATop,ALine,AHeight,AWidth,ADataSource.DataSet,LSBreakCaption);
            ARLLabel.Alignment:=TRLTextAlignment(taRightJustify);
            ARLLabel.Font.Assign(ExtColumnHeaderFont);
            inc(SomeLeft,aWidth);
            AIsFirst:=False;
          end;
     end;
  End;

  // Print TFWPrintGrid
  procedure CreateListGrid;
  var i,ALine, ATop, Aheight : Integer;
      LIsFirst : Boolean;
  Begin
    ALine := 0;
    with AReport do
     Begin
      p_InitList ( ATop, LIsFirst );
      with aColumns do
      for i := 0 to Count - 1 do
         if fb_Visible ( Items [ i ] ) Then
           Begin
             awidth:=fi_resize ( flin_getComponentProperty ( Items [ i ], CST_COLUMN_Width ), i );
             p_CreatePrintField ( Items [ i ], LIsFirst,ATop,ALine,Aheight,AWidth,ADataSource.DataSet);
             inc ( SomeLeft, aWidth );
             LIsFirst := False;
           end;
      End;
    p_AdaptBands ( LIsFirst );
  end;
  // Print TFWPrintData
  procedure CreateListPrint;
  var i,j,Aline,ATop, AHeight, ADecColumn : Integer;
      LIsFirst : Boolean;
      LSBreakCaption : String ;
  Begin
    ALine := 0;
    AHeight := 0 ;
    ADecColumn := -1;
    with ADatasource.DataSet,AReport do
     Begin
      p_InitList ( ATop, LIsFirst );
      with aColumns do
      for i := 0 to Count - 1 do
       Begin
        inc ( ADecColumn ); // for linebreak
        if fb_Visible ( Items [ i ] ) Then
         Begin
           awidth:=fi_resize ( flin_getComponentProperty ( Items [ ADecColumn ], CST_COLUMN_Width ), ADecColumn );
           p_CreatePrintField ( Items [ i ], LIsFirst,ATop,ALine,Aheight,AWidth,ADataSource.DataSet);
           // linebreak ?
           if flin_getComponentProperty ( Items [ i ], CST_PRINT_COLUMN_LINEBREAK ) < 0 Then
            Begin
              inc ( SomeLeft, aWidth );
              LIsFirst := False;
            end;
         end;
        // optional line break
        p_Linebreak ( Items [ i ], AHeight, ATop, Aline , ADecColumn, LIsFirst );
       End;

      End;
    p_AdaptBands ( LIsFirst, ALinesAddedColumns + 1 );
  end;
Begin
  Result := False;
  PreparePrint;
  if totalgridwidth = 0 Then Exit;
  CreateHeader;
  if agrid  = nil
   Then CreateListPrint
   Else CreateListGrid;
  AReport.DataSource:=ADatasource;
end;

function fref_CreateReport ( const agrid : TCustomDBGrid; const ADatasource : TDatasource; const AColumns : TCollection; const as_Title : String ; const acf_filter : TRLCustomPrintFilter = nil): TReportForm;
Begin
  Result := TReportForm.create ( Application );
  Result.RLReport.DefaultFilter:=acf_filter;
  fb_CreateReport ( Result.RLReport, agrid, ADatasource, AColumns, Result.Canvas, as_Title );
end;

initialization
{$IFDEF VERSIONS}
  p_ConcatVersion ( gVer_fonctions_reports );
{$ENDIF}
  ExtTitleColorFont   := TFont.create;
  ExtColumnHeaderFont := TFont.Create;
  ExtColumnFont       := TFont.Create;
  ExtColumnFont      .Size  := CST_PRINT_FONT_SIZE;
  ExtColumnHeaderFont.Size  := CST_PRINT_FONT_SIZE;
  ExtTitleColorFont  .Size  := CST_PRINT_FONT_SIZE;
  ExtTitleColorFont  .Color := CST_PRINT_TITLE_FONT_COLOR;
  ExtColumnHeaderFont.Color := CST_PRINT_COLUMN_TITLE_FONT_COLOR;
  ExtColumnHeaderFont.Style := CST_PRINT_COLUMN_TITLE_FONT_STYLE;
  ExtColumnFont      .Color := CST_PRINT_COLUMN_FONT_COLOR;
finalization
  ExtTitleColorFont  .Free;
  ExtColumnHeaderFont.Free;
  ExtColumnFont      .Free;
end.

unit fonctions_reports;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFNDEF FPC}
  Windows,
{$ELSE}
  LCLIntf,
{$ENDIF}
  SysUtils, RLReport, DBGrids, DB,
  u_extdbgrid,U_ExtMapImageIndex,Forms,
  u_reportform,ImgList, Graphics,
  RLFilters,
  Printers,
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
  Classes, Grids,
  VirtualTrees,
  RLTypes,
  IniFiles,
  RLPreview;

const
{$IFDEF VERSIONS}
  gVer_fonctions_reports : T_Version = ( Component : 'System management' ; FileUnit : 'fonctions_reports' ;
                        			                 Owner : 'Matthieu Giroux' ;
                        			                 Comment : 'Reports'' Functions, with grid reports.' ;
                        			                 BugsStory : 'Version 1.0.1.0 : Ini management.' + #13#10 +
                                                                             'Version 1.0.0.2 : Testing reports.' + #13#10 +
                                                                             'Version 1.0.0.1 : image centering.' + #13#10 +
                                                                             'Version 1.0.0.0 : Working.';
                        			                 UnitType : 1 ;
                        			                 Major : 1 ; Minor : 0 ; Release : 1 ; Build : 0 );
{$ENDIF}
  CST_COLUMN_Visible = 'Visible';
  CST_COLUMN_Width   = 'Width';
  CST_COLUMN_MIN_Width= 4;
  CST_COLUMN_Resize  = 'Resize';
  CST_COLUMN_Title   = 'Title';
  CST_COLUMN_Images  = 'Images';
  CST_PRINT_HEADER_FONT_NAME        = 'Tahoma';
  CST_PRINT_COLUMN_FONT_NAME        = 'Tahoma';
  CST_PRINT_COLUMN_HEADER_FONT_NAME = 'Tahoma';
  CST_PRINT_FONT_SIZE = 9;
  CST_PRINT_FONT_SIZE_TREE = 9;
  CST_PRINT_COLUMN_HEADER_FONT_COLOR = clBlack;
  CST_PRINT_COLUMN_FONT_COLOR = clBlack;
  CST_PRINT_HEADER_FONT_COLOR  = clBlack;
  CST_PRINT_HEADER_COLOR = clNavy;
  CST_PRINT_COLUMN_HEADER_BACK_COLOR = clSkyBlue;
  CST_PRINT_HEADER_BACK_COLOR = clSkyBlue;
  CST_PRINT_COLUMN_BORDER_COLOR = clBlue;
  CST_PRINT_COLUMN_COLOR = clWhite;
  CST_PRINT_TREE_LINE_COLOR = clBlack;
  CST_PRINT_HEADER_FONT_STYLE = [fsBold];
  CST_PRINT_COLUMN_BREAKCAPTION = 'BreakCaption' ;
  CST_PRINT_COLUMN_LINEBREAK = 'LineBreak' ;
  CST_PRINT_COMPONENT_EVENT = 'DrawReportImage';
  CST_PRINT_INTERNAL_BAND_MARGIN = 2;
  CST_PRINT_INI_SECTION_REPORT = 'Reports' ;
  CST_PRINT_INI_COLOR_HEADER   = 'HeaderColor';
  CST_PRINT_INI_COLOR_COLUMN   = 'ColumnColor';
  CST_PRINT_INI_COLOR_FONT_HEADER = 'HeaderFontColor';
  CST_PRINT_INI_COLOR_FONT_COLUMN = 'ColumnFontColor';
  CST_PRINT_INI_COLOR_FONT_COLUMN_HEADER = 'ColumnFontColor';
  CST_PRINT_INI_HEADER_FONT        = 'FontHeader';
  CST_PRINT_INI_COLUMN_FONT        = 'FontColumn';
  CST_PRINT_INI_COLUMN_HEADER_FONT = 'FontColumn';



  // customized's reports
var RLLeftTopPage : TPoint = ( X: 20; Y:20 );
    ExtHeaderColorBack : TColor = CST_PRINT_HEADER_COLOR;
    ExtTitleColorBorder : TColor = CST_PRINT_COLUMN_BORDER_COLOR;
    ExtHeaderFont : TFont  = nil;
    ExtColumnColorBorder : TColor = CST_PRINT_COLUMN_BORDER_COLOR;
    ExtColumnHeaderFont  : TFont  = nil;
    ExtColumnHeaderColorBack : TColor = CST_PRINT_COLUMN_HEADER_BACK_COLOR;
    ExtColumnFont        : TFont  = nil;
    ExtTreeLineColor     : TColor = CST_PRINT_TREE_LINE_COLOR;
    ExtColumnHBorders    : Boolean = False;
    ExtColumnVBorders    : Boolean = True;
    ExtColumnColorBack   : TColor = CST_PRINT_COLUMN_COLOR;
    ExtLandscapeColumnsCount : Integer = 9;
    ExtHeader  : TRLBand = nil;

function fb_CreateReport ( const AReport : TRLReport ; const agrid : TCustomDBGrid; const ADatasource : TDatasource; const AColumns : TCollection; const ATempCanvas : TCanvas;const as_Title : String): Boolean; overload;
function fb_CreateReport ( const AParentReport : TRLReport ; const atree : TCustomVirtualStringTree;const ATempCanvas : TCanvas;const as_Title : String): Boolean; overload;
function fref_CreateReport ( const AOrientation : {$IFDEF FPC}TPrinterOrientation{$ELSE}TRLPageOrientation{$ENDIF} ; const APaperSize   :TRLPaperSize = fpA4; const acf_filter : TRLCustomPrintFilter = nil ): TReportForm; overload;
function fref_CreateReport ( const agrid : TCustomDBGrid; const ADatasource : TDatasource; const AColumns : TCollection; const as_Title : String ; const AOrientation : {$IFDEF FPC}TPrinterOrientation{$ELSE}TRLPageOrientation{$ENDIF} ; const APaperSize   :TRLPaperSize = fpA4; const acf_filter : TRLCustomPrintFilter = nil): TReportForm; overload;
function fref_CreateReport ( const atree : TCustomVirtualStringTree; const as_Title : String ; const AOrientation : {$IFDEF FPC}TPrinterOrientation{$ELSE}TRLPageOrientation{$ENDIF} ; const APaperSize   :TRLPaperSize = fpA4; const acf_filter : TRLCustomPrintFilter = nil): TReportForm; overload;
procedure p_ReadReportsViewFromIni ( const AIniFile : TIniFile );
procedure p_WriteReportsViewFromIni ( const AIniFile : TIniFile );
procedure p_ReinitValues;

implementation

uses fonctions_proprietes,
     fonctions_images,
     unite_messages,
     fonctions_string,
     fonctions_vtree,
     u_reports_rlcomponents,
     Math,strutils;


procedure p_ReadReportsViewFromIni ( const AIniFile : TIniFile );
Begin
  ExtColumnColorBack       :=AIniFile.ReadInteger(CST_PRINT_INI_SECTION_REPORT,CST_PRINT_INI_COLOR_COLUMN,ExtColumnColorBack);
  ExtColumnHeaderColorBack :=AIniFile.ReadInteger(CST_PRINT_INI_SECTION_REPORT,CST_PRINT_INI_COLOR_HEADER,ExtColumnHeaderColorBack);
  ExtHeaderColorBack       :=AIniFile.ReadInteger(CST_PRINT_INI_SECTION_REPORT,CST_PRINT_INI_COLOR_HEADER,ExtHeaderColorBack);
  ExtHeaderFont.Name       :=AIniFile.ReadString (CST_PRINT_INI_SECTION_REPORT,CST_PRINT_INI_HEADER_FONT,ExtHeaderFont.Name);
  ExtHeaderFont.Color      :=AIniFile.ReadInteger(CST_PRINT_INI_SECTION_REPORT,CST_PRINT_INI_COLOR_FONT_HEADER,ExtHeaderFont.Color);
  ExtColumnHeaderFont.Name :=AIniFile.ReadString (CST_PRINT_INI_SECTION_REPORT,CST_PRINT_INI_COLUMN_HEADER_FONT,ExtColumnHeaderFont.Name);
  ExtColumnHeaderFont.Color:=AIniFile.ReadInteger(CST_PRINT_INI_SECTION_REPORT,CST_PRINT_INI_COLOR_FONT_COLUMN_HEADER,ExtColumnHeaderFont.Color);
  ExtColumnFont.Color      :=AIniFile.ReadInteger(CST_PRINT_INI_SECTION_REPORT,CST_PRINT_INI_COLOR_FONT_COLUMN,ExtColumnFont.Color);
  ExtColumnFont.Name       :=AIniFile.ReadString (CST_PRINT_INI_SECTION_REPORT,CST_PRINT_INI_COLUMN_FONT,ExtColumnFont.Name);
end;


procedure p_WriteReportsViewFromIni ( const AIniFile : TIniFile );
Begin
  AIniFile.WriteInteger (CST_PRINT_INI_SECTION_REPORT,CST_PRINT_INI_COLOR_COLUMN,ExtColumnColorBack);
  AIniFile.WriteInteger (CST_PRINT_INI_SECTION_REPORT,CST_PRINT_INI_COLOR_HEADER,ExtColumnHeaderColorBack);
  AIniFile.WriteString  (CST_PRINT_INI_SECTION_REPORT,CST_PRINT_INI_COLUMN_HEADER_FONT,ExtColumnHeaderFont.Name);
  AIniFile.WriteInteger (CST_PRINT_INI_SECTION_REPORT,CST_PRINT_INI_COLOR_FONT_HEADER,ExtColumnHeaderFont.Color);
  AIniFile.WriteInteger (CST_PRINT_INI_SECTION_REPORT,CST_PRINT_INI_COLOR_HEADER,ExtHeaderColorBack);
  AIniFile.WriteString  (CST_PRINT_INI_SECTION_REPORT,CST_PRINT_INI_HEADER_FONT,ExtHeaderFont.Name);
  AIniFile.WriteInteger (CST_PRINT_INI_SECTION_REPORT,CST_PRINT_INI_COLOR_FONT_COLUMN,ExtColumnFont.Color);
  AIniFile.WriteInteger (CST_PRINT_INI_SECTION_REPORT,CST_PRINT_INI_COLOR_FONT_COLUMN_HEADER,ExtColumnHeaderFont.Color);
  AIniFile.WriteString  (CST_PRINT_INI_SECTION_REPORT,CST_PRINT_INI_COLUMN_FONT,ExtColumnFont.Name);
end;

procedure p_ReinitValues;
Begin
  ExtColumnColorBack       :=CST_PRINT_COLUMN_COLOR;
  ExtColumnHeaderColorBack :=CST_PRINT_COLUMN_HEADER_BACK_COLOR;
  ExtColumnHeaderFont.Name :=CST_PRINT_COLUMN_HEADER_FONT_NAME;
  ExtColumnHeaderFont.Color:=CST_PRINT_COLUMN_HEADER_FONT_COLOR;
  ExtHeaderColorBack       :=CST_PRINT_HEADER_BACK_COLOR;
  ExtHeaderFont.Name       :=CST_PRINT_HEADER_FONT_NAME;
  ExtHeaderFont.Color      :=CST_PRINT_HEADER_FONT_COLOR;
  ExtColumnFont.Color      :=CST_PRINT_COLUMN_FONT_COLOR;
  ExtColumnFont.Name       :=CST_PRINT_COLUMN_FONT_NAME;
end;

function frlr_CreateNewReport ( const ASourceReport : TRLReport ):TRLReport;
Begin
  Result := TRLReport.Create(ASourceReport.Owner);
  with Result.PageSetup, ASourceReport do
   Begin
     Orientation:=PageSetup.Orientation;
     PaperSize  :=PageSetup.PaperSize;
   end;
end;

function frlc_createLabel ( const AReport : TRLReport; const ARLBand : TRLBand;const ALeft, ATop, AWidth : Integer ; const afont : TFont; const as_Text : String = '' ; const ai_SizeFont : Integer = 0 ): TRLLabel;
Begin
  Result := TRLLabel.Create(AReport.Owner);
  with Result do
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

function frlc_createSystemInfo ( const AReport : TRLReport; const ARLBand : TRLBand; const ALeft, ATop, Awidth : Integer ; const AInfo:TRLInfoType; const afont : TFont; const AFontWidth : Integer = 0; const as_Text : String = '' ; const AAlign : TRLControlAlign = faRight ; const AAlignment : TRLTextAlignment = TRLTextAlignment(taRightJustify) ; const ALayout : TRLTextLayout = {$IFDEF FPC }TRLTextLayout.{$ENDIF}tlJustify):TRLSystemInfo;
Begin
  Result := TRLSystemInfo.Create(AReport.Owner);
  with Result do
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

function frlc_createBand ( const AReport : TRLReport; const ALeft, ATop, Aheight : Integer ; const Abandtype : TRLBandType ; const AColor : TColor = clWhite ) : TRLBand;
Begin
  Result := TRLBand.Create(AReport.Owner);
  with Result do
   Begin
    Parent:=AReport;
    BandType:=Abandtype;
    Top:=ATop;
    Left:=ALeft;
    Color:=AColor;
    Height:=Aheight;
    Width:=aReport.Width-RLLeftTopPage.X*CST_PRINT_INTERNAL_BAND_MARGIN;
   end;
end;
function frlc_createDBText ( const AReport : TRLReport; const ARLBand : TRLBand; const ADatasource : TDatasource; const ALeft, ATop, AWidth : Integer ; const afont : TFont; const as_Fieldname : String ; const ai_SizeFont : Integer = 0):TRLDBText;
Begin
  Result := TRLDBText.Create(AReport.Owner);
  with Result do
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

function frlc_createImage ( const AReport : TRLReport; const ARLBand : TRLBand; const ALeft, ATop, AWidth : Integer):TRLImage;
Begin
  Result := TRLImage.Create(AReport.Owner);
  with Result do
   Begin
    Parent:=ARLBand;
    Top:=ATop;
    Left:=ALeft;
    Width:=AWidth;
   end;
end;

function frlc_createImageList ( const AReport : TRLReport; const ARLBand : TRLBand; const AImages : TCustomImageList; const ALeft, ATop, AWidth, AHeight, AImageIndex : Integer):TRLExtImageList;
Begin
  Result := TRLExtImageList.Create(AReport.Owner);
  with Result do
   Begin
    Parent:=ARLBand;
    Top:=ATop;
    Left:=ALeft;
    Width:=AWidth;
    Height:=AHeight;
    ImageIndex:=AImageIndex;
    Images := AImages;
   end;
end;

function frlc_createDBImage ( const AReport : TRLReport; const ARLBand : TRLBand; const ADatasource : TDatasource; const ALeft, ATop, AWidth, AHeight : Integer; const AField : String ):TRLDBExtImage;
Begin
  Result := TRLDBExtImage.Create(AReport.Owner);
  with Result do
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

function frlc_createDBImageList ( const AReport : TRLReport; const ARLBand : TRLBand; const ADatasource : TDatasource; const ALeft, ATop, AWidth, AHeight : Integer; const AField : String ; const AImages : TCustomImageList):TRLDBExtImageList;
Begin
  Result := TRLDBExtImageList.Create(AReport.Owner);
  with Result do
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


// procedure p_AdaptBands;
// Compressing
function p_AdaptBands ( const ARLBand : TRLBand; const ARLLabel : TRLLabel; const AIsFirst : Boolean ; const ALines : Integer = 1 ):Integer;
Begin
  ARLBand.Margins.BottomMargin:=0;
  ARLBand.Margins.TopMargin   :=0;
  ARLBand.InsideMargins.BottomMargin:=0;
  ARLBand.InsideMargins.TopMargin   :=0;
  if not AIsFirst Then
   Begin
    ARLBand.Height:=ARLLabel.Height*ALines;
    Result := ARLLabel.Height;
   end
  Else
   Result := 0;
end;

// dbtitle property to report's header
procedure p_addTitle (const AReport : TRLReport ; const ABand : TRLBand; const as_Title : String; var atitleHeight : Integer );
var astl_Title : TStringList;
    i, AHeight, ALineHeight : Integer;
    arlabel : TRLLabel;
Begin
  astl_Title := nil;
  arlabel   := nil;
  atitleHeight := 0;
  p_ChampsVersListe(astl_Title, StringReplace ( as_Title, #10, '', [rfReplaceAll] ), #13);
  with AReport do
  for i := 0 to astl_Title.Count -1 do
   Begin
    ALineHeight := Min ( 32, round ( ( Width - 160 ) div length ( astl_Title [ i ] )*1.9 ));
    inc ( atitleHeight, ALineHeight +1 );
   end;
  inc ( atitleHeight, CST_PRINT_INTERNAL_BAND_MARGIN * 2 );
  ABand.Height:=atitleHeight;
  p_DrawBorders ( ABand.Borders, ExtTitleColorBorder, True, ExtColumnVBorders, True );
  for i := 0 to astl_Title.Count -1 do
   Begin
     if arlabel = nil
      Then AHeight:=CST_PRINT_INTERNAL_BAND_MARGIN
      Else AHeight:=arlabel.Top+arlabel.Height;
     arlabel := frlc_createLabel ( AReport, ABand,CST_PRINT_INTERNAL_BAND_MARGIN,AHeight,0, ExtHeaderFont, astl_Title [ i ],aLineHeight*2 div 3);

   end;
end;

// entête de rapport
// report's header
function frlc_CreateHeader (const AReport : TRLReport ; const as_Title : String; var atitleHeight : Integer ):TRLBand;
var
    ARLSystemInfo : TRLSystemInfo;

Begin
  atitleHeight := 0;
  with AReport do
    if ExtHeader = nil Then
     Begin
       with RLLeftTopPage do
         Result := frlc_createBand ( AReport, X, Y, atitleHeight + 4, btHeader, ExtHeaderColorBack );
      if as_Title > '' Then    // title string ?
         p_addTitle ( AReport, Result, as_Title, atitleHeight );

       with Result do
        Begin
         ARLSystemInfo := frlc_createSystemInfo ( AReport, Result,Width,CST_PRINT_INTERNAL_BAND_MARGIN,0,itFullDate, ExtHeaderFont, 0,'',faRightTop);
         Height:=Max(ARLSystemInfo.Height*2,Height);  // adapt height to 2 lines of system info
         ARLSystemInfo := frlc_createSystemInfo ( AReport, Result,Width,Height,0,itLastPageNumber, ExtHeaderFont, 0, '/', faRightBottom,TRLTextAlignment(taLeftJustify));
         // due to autosize bug
         ARLSystemInfo.Anchors:=[fkRight,fkBottom];
         ARLSystemInfo.Width:=43;
         ARLSystemInfo.Left := Width - 44;
         ARLSystemInfo := frlc_createSystemInfo ( AReport, Result,Width,Height,0,itPageNumber, ExtHeaderFont, 0, '', faRightBottom);
         // due to autosize bug
         ARLSystemInfo.Anchors:=[fkRight,fkBottom];
         ARLSystemInfo.Width:=44;
         ARLSystemInfo.Left := Width - 88;
         atitleHeight := Height;
        end;
     end
    Else
    with ExtHeader do
     Begin
      Parent:=AReport;
      atitleHeight := Height;
     end;
end;

//   virtual tree sources
function NodeIsVisible(const Node: PVirtualNode): Boolean;

// Checks if a node will effectively be hidden as this depends on the nodes state and the paint options.

begin
  if Assigned(Node) then
    Result := ( vsVisible in Node.States ) {$IFDEF FPC} and not ( vsHidden in Node.States){$ENDIF}
  else
    Result := False;
end;

//----------------------------------------------------------------------------------------------------------------------
//   virtual tree sources
function HasVisibleNextSibling( Node: PVirtualNode): Boolean;

// Helper method to determine if the given node has a visible next sibling. This is needed to
// draw correct tree lines.

begin
  // Check if there is a sibling at all.
  Result := Assigned(Node.NextSibling);

  if Result then
  begin
    repeat
      Node := Node.NextSibling;
      Result := NodeIsVisible ( Node );
    until Result or (Node.NextSibling = nil);
  end;
end;


//   virtual tree sources
function HasVisiblePreviousSibling( Node: PVirtualNode): Boolean;

// Helper method to determine if the given node has a visible previous sibling. This is needed to
// draw correct tree lines.

begin
  // Check if there is a sibling at all.
  Result := Assigned(Node.PrevSibling);

  if Result then
  begin
    repeat
      Node := Node.PrevSibling;
      Result := NodeIsVisible ( Node );
    until Result or (Node.PrevSibling = nil);
  end;
end;

//   virtual tree sources
function IsFirstVisibleChild(Parent, Node: PVirtualNode): Boolean;

// Helper method to check if Node is the same as the first visible child of Parent.

var
  Run: PVirtualNode;

begin
  // Find first visible child.
  Run := Parent.FirstChild;
  while Assigned(Run) and not (NodeIsVisible ( Node )) do
    Run := Run.NextSibling;

  Result := Assigned(Run) and (Run = Node);
end;

function IsLastVisibleChild(Parent, Node: PVirtualNode): Boolean;

// Helper method to check if Node is the same as the last visible child of Parent.

var
  Run: PVirtualNode;

begin
  // Find last visible child.
  Run := Parent.LastChild;
  while Assigned(Run) and not (NodeIsVisible ( Node )) do
    Run := Run.PrevSibling;

  Result := Assigned(Run) and (Run = Node);
end;


//   virtual tree sources
function DetermineLineImagesAndSelectLevel( const ATree : TBaseVirtualTree; const ATreeOptions : TStringTreeOptions; const Node: PVirtualNode; out LineImage: TLineImage): Integer;

// This method is used during paint cycles and initializes an array of line type IDs. These IDs are used to paint
// the tree lines in front of the given node.
// Additionally an initial count of selected parents is determined and returned which is used for specific painting.

var
  X: Integer;
  Run: PVirtualNode;

begin
  Result := 0;
  with ATree, ATreeOptions do
   Begin
    if toShowRoot in PaintOptions then
      X := 1
    else
      X := 0;
    Run := Node;
    // Determine indentation level of top node.
    while Run.Parent <> RootNode do
    begin
      Inc(X);
      Run := Run.Parent;
      // Count selected nodes (FRoot is never selected).
      if vsSelected in Run.States then
        Inc(Result);
    end;

    // Set initial size of line index array, this will automatically initialized all entries to ltNone.
    SetLength(LineImage, X);

    // Only use lines if requested.
    if (toShowTreeLines in PaintOptions) then
    begin
        // Start over parent traversal if necessary.
        Run := Node;

        if Run.Parent <> RootNode then
        begin
          // The very last image (the one immediately before the item label) is different.
          if HasVisibleNextSibling(Run) then
            LineImage[X - 1] := ltTopDownRight
          else
            LineImage[X - 1] := ltTopRight;
          Run := Run.Parent;

          // Now go up all parents.
          repeat
            if Run.Parent = RootNode then
              Break;
            Dec(X);
            if HasVisibleNextSibling(Run) then
              LineImage[X - 1] := ltTopDown
            else
              LineImage[X - 1] := ltNone;
            Run := Run.Parent;
          until False;
        end;

        // Prepare root level. Run points at this stage to a top level node.
        if (toShowRoot in PaintOptions) and ((toShowTreeLines in PaintOptions)) then
        begin
          // Is the top node a root node?
          if Run = Node then
          begin
            // First child gets the bottom-right bitmap if it isn't also the only child.
            if IsFirstVisibleChild(RootNode, Run) then
              // Is it the only child?
              if IsLastVisibleChild(RootNode, Run) then
                LineImage[0] := ltRight
              else
                LineImage[0] := ltBottomRight
            else
              // real last child
              if IsLastVisibleChild(RootNode, Run) then
                LineImage[0] := ltTopRight
              else
                LineImage[0] := ltTopDownRight;
          end
          else
          begin
            // No, top node is not a top level node. So we need different painting.
            if HasVisibleNextSibling(Run) then
              LineImage[0] := ltTopDown
            else
              LineImage[0] := ltNone;
          end;
        end;
    end;
   end;
end;

//----------------------------------------------------------------------------------------------------------------------
//   virtual tree sources
procedure p_DrawDottedHLine(const Canvas : TCanvas; const Left, Right, Top: Integer);
//   virtual tree sources
// Draws a horizontal line with alternating pixels (this style is not supported for pens under Win9x).

var
  R: TRect;

begin
  with Canvas do
  begin
    R := Rect(Min(Left, Right), Top, Max(Left, Right) + 1, Top + 1);
    FillRect( R );
  end;
end;

//----------------------------------------------------------------------------------------------------------------------
//   virtual tree sources
procedure p_DrawDottedVLine(const Canvas : TCanvas; const Top, Bottom, Left: Integer);

// Draws a vertical line with alternating pixels (this style is not supported for pens under Win9x).

var
  R: TRect;

begin
  with Canvas do
  begin
    R := Rect(Left, Min(Top, Bottom), Left + 1, Max(Top, Bottom) + 1);
    FillRect( R );
  end;
end;


//----------------------------------------------------------------------------------------------------------------------
//   virtual tree sources
procedure p_DrawLineImage(const Canvas : TCanvas; const X, Y, H, VAlign, IndentTree : Integer; const Style: TVTLineType;
 const Reverse: Boolean);

// Draws (depending on Style) one of the 5 line types of the tree.
// If Reverse is True then a right-to-left column is being drawn, hence horizontal lines must be mirrored.
// X and Y describe the left upper corner of the line image rectangle, while H denotes its height (and width).

var
  HalfWidth,
  TargetX: Integer;

begin
  HalfWidth := Integer(IndentTree) div 2;
  if Reverse then
    TargetX := 0
  else
    TargetX := IndentTree;

  case Style of
    ltBottomRight:
      begin
        p_DrawDottedVLine(Canvas,Y + VAlign, Y + H, X + HalfWidth);
        p_DrawDottedHLine(Canvas,X + HalfWidth, X + TargetX, Y + VAlign);
      end;
    ltTopDown:
      p_DrawDottedVLine(Canvas,Y, Y + H, X + HalfWidth);
    ltTopDownRight:
      begin
        p_DrawDottedVLine(Canvas,Y, Y + H, X + HalfWidth);
        p_DrawDottedHLine(Canvas,X + HalfWidth, X + TargetX, Y + VAlign);
      end;
    ltRight:
      p_DrawDottedHLine(Canvas,X + HalfWidth, X + TargetX, Y + VAlign);
    ltTopRight:
      begin
        p_DrawDottedVLine(Canvas,Y, Y + VAlign, X + HalfWidth);
        p_DrawDottedHLine(Canvas,X + HalfWidth, X + TargetX, Y + VAlign);
      end;
    ltLeft: // left can also mean right for RTL context
      if Reverse then
        p_DrawDottedVLine(Canvas,Y, Y + H, X + Integer(IndentTree))
      else
        p_DrawDottedVLine(Canvas,Y, Y + H, X);
    ltLeftBottom:
      if Reverse then
      begin
        p_DrawDottedVLine(Canvas,Y, Y + H, X + Integer(IndentTree));
        p_DrawDottedHLine(Canvas,X, X + Integer(IndentTree), Y + H);
      end
      else
      begin
        p_DrawDottedVLine(Canvas,Y, Y + H, X);
        p_DrawDottedHLine(Canvas,X, X + Integer(IndentTree), Y + H);
      end;
  end;
end;


//----------------------------------------------------------------------------------------------------------------------
//   virtual tree sources
procedure p_PaintTreeLines(const Canvas : TCanvas; const CellRect : TRect; const BidiMode : TBiDiMode; const VAlignment, IndentSize, NodeHeight, IndentTree: Integer;
 const LineImage: TLineImage);

var
  I: Integer;
  XPos,
  Offset: Integer;
  NewStyles: TLineImage;

begin
  NewStyles := nil;

  if BidiMode = bdLeftToRight then
  begin
    XPos := CellRect.Left;
    Offset := IndentTree;
  end
  else
  begin
    Offset := -Integer(IndentTree);
    XPos := CellRect.Right + Offset;
  end;

  for I := 0 to IndentSize - 1 do
    begin
      p_DrawLineImage(Canvas,  XPos, CellRect.Top, NodeHeight, VAlignment, IndentTree, LineImage[I],
        BidiMode <> bdLeftToRight);
      Inc(XPos, Offset);
    end;
end;

// create a report from a virtual tree
function fb_CreateReport ( const AParentReport : TRLReport ; const atree : TCustomVirtualStringTree;const ATempCanvas : TCanvas;const as_Title : String): Boolean;
var totalgridwidth, aresizecolumns, atitleHeight, AlineHeight, aVisibleColumns, SomeLeft, aSpaceWidth, ALinesAdded: Integer;
    ARLLabel : TRLLabel;
    AReport : TRLReport;
    ARLDBText : TRLDBText;
    ARLImage : TRLCustomImage;
    ARLBand : TRLBand;
    ATreeNodeSigns : TLineImage;
    AImages : TCustomImageList;
    ATreeOptions: TStringTreeOptions;
    ARightReport  : TRLReport;
    ARightBand  : TRLBand;
    ARightReports : array of TRLReport;
    LMinusBM : TBitmap;
    AText : {$IFDEF FPC}String{$ELSE}WideString{$ENDIF};
    AGhosted : Boolean;
    ATextHeight : Integer;
    ATreeLevel : Integer;
    AOnGetImage: TVTGetImageEvent;               // Used to retrieve the image index of a given node.
    AOnGetImageEx: TVTGetImageExEvent;           // Used to retrieve the image index of a given node along with a custom

    const CST_PROPERTY_OnGetImageIndex = 'OnGetImageIndex';
          CST_PROPERTY_OnGetImageIndexEX = 'OnGetImageIndexEx';

    // add header to a report
    procedure p_AddHeader ( const AReport : TRLReport; var ABand : TRLBand  );
    var ATempBand : TRLBand;
    Begin
      ATempBand:=frlc_CreateHeader ( AReport, as_Title, ATitleHeight );
      with AReport, Margins, RLLeftTopPage do
       Begin
        ATempBand := frlc_createBand ( AReport, 0, Y + atitleHeight + 1, 4, btHeader, clWhite );
        inc ( atitleHeight, ATempband.Height );
        ABand := frlc_createBand ( AReport, 0, Y + atitleHeight + 1, ClientHeight - atitleHeight - round ( BottomMargin + TopMargin ) - 1, btColumnHeader, ExtColumnColorBack  );
       end;

    end;

    // text can go right out
    procedure p_addEventualRightReport ( const ARealTop : Integer );
    var ARightLabel : TRLLabel;
        Aindex      : Integer;
        AWidth,ADotWidth, ALeftLength      : Integer;
        ARightString : String;
    Begin
       with ARLLabel do
         Begin
          if Width + Left > ARLBand.Width Then
           Begin
             if not Assigned( ARightReport ) Then
              Begin
                ARightReport := frlr_CreateNewReport ( AParentReport );
                AIndex:=High(ARightReports)+1;
                SetLength(ARightReports, AIndex + 1 );
                ARightReports[AIndex]:=ARightReport;
                if AIndex > 0 Then
                 ARightReport.PriorReport := ARightReports [ AIndex - 1 ];
                p_AddHeader ( ARightReport, ARightBand );
              end;
             ADotWidth := ATempCanvas.TextWidth('…')+CST_PRINT_INTERNAL_BAND_MARGIN * 2+Left;
             ALeftLength := Length(Caption);
             while ( Width + ADotWidth > ARLBand.Width )
             and ( ALeftLength > 0 ) do
              Begin
                ARightString := Caption [ ALeftLength ]+ ARightString;
                dec ( ALeftLength );
                Caption:= copy ( Caption, 1, ALeftLength );
              end;
             Caption:= Caption + '…';
             ARightLabel := frlc_createLabel(ARightReport,ARightBand,CST_PRINT_INTERNAL_BAND_MARGIN,ARealTop,ARLBand.Width-CST_PRINT_INTERNAL_BAND_MARGIN,ExtColumnFont,ARightString);
           end;
         end;

    end;

    // New left and eventual right page
    procedure p_BeginPage;
    Begin
      ARLLabel := nil;
      ARightReport := nil;
      ATitleHeight := 0;
      p_AddHeader ( AReport, ARLBand );
    end;

    // Paint only the tree's main column
    procedure p_paintMainColumn ( const ANode : PVirtualNode );
    var Arect : TRect;
        ARealTop : Integer;
        LLine : TBitmap;
        AIndex : Integer;
    Begin
      with atree, ARect do
       Begin
        Left:=0;
        Top :=0;
        LLine := TBitmap.Create;
         try

          Right:=aSpaceWidth;
          Bottom:= ATextHeight;
          if ARLLabel = nil
           Then ARealTop := 0
           Else ARealTop := ARLLabel.Top+ ATextHeight ;
          ARLImage := frlc_createImage(AReport, ARLBand, Left, ARealTop, aSpaceWidth );
          if ARLLabel = nil
           Then ARealTop := 0
           Else ARealTop := ARLLabel.Top+ATextHeight;
          // erase black canvas
          p_SetAndFillBitmap ( LLine, Right, Bottom, ARLImage.Color );
          //   virtual tree sources
          DetermineLineImagesAndSelectLevel( atree, ATreeOptions, ANode, ATreeNodeSigns );
          if (toShowTreeLines in ATreeOptions.PaintOptions) then
            Begin
              LLine.Canvas.Brush.Color := ExtTreeLineColor;
              p_PaintTreeLines(LLine.Canvas,Arect, bdLeftToRight, ATextHeight div 2, ATreeLevel+1,ATextHeight, ATextHeight, ATreeNodeSigns);
            end;
          // place the minus
          LLine.Canvas.Draw(aSpaceWidth - ATextHeight + ( ATextHeight - LMinusBM.Height ) div 2 + 1, (ATextHeight - LMinusBM.Height ) div 2 + 1, LMinusBM);
          ARLImage.Picture.Bitmap.Assign(LLine);
         finally
           LLine.Free;
         end;
        // Main column image
        AImages := fobj_getComponentObjectProperty ( atree, CST_PROPERTY_IMAGES ) as TCustomImageList;
        Left:=aSpaceWidth;
        if (( AImages <> nil ) and  Assigned ( AOnGetImage ))
        or Assigned ( AOnGetImageEx ) Then
         Begin
           // First try the enhanced event to allow for custom image lists.
           if Assigned(AOnGetImageEx) then
             AOnGetImageEx(atree, ANode, ikNormal, -1, AGhosted, AIndex, AImages )
           else
             if Assigned(AOnGetImage) then
               AOnGetImage(atree, ANode, ikNormal, -1, AGhosted, AIndex);
           // report's image
           if ATextHeight < AImages.Width
            Then ARLImage := frlc_createImageList(AReport, ARLBand, AImages, aSpaceWidth, ARealTop, ATextHeight, ATextHeight, AIndex )
            Else ARLImage := frlc_createImageList(AReport, ARLBand, AImages, aSpaceWidth, ARealTop+ ( ATextHeight - AImages.Width ) div 2, AImages.Width, AImages.Height, AIndex );
           Left:=Left+ARLImage.Width;
           inc ( aSpaceWidth, ARLImage.Width );
         end;
        // Main column text
        GetTextInfo(ANode,-1,ARLBand.Font,ARect,AText);
        with ARect do
          ARLLabel := frlc_createLabel(AReport,ARLBand,aSpaceWidth,ARealTop,0,ExtColumnFont,AText);
        // text can go right out
        p_addEventualRightReport ( ARealTop );
       end;
    end;

    // recursive reports' print procedure
    procedure p_labelNode ( const ANode : PVirtualNode );
    var ARect : TRect;
        APriorReport : TRLReport;
    Begin
      ATreeLevel := GetNodeLevel(ANode);
      with atree, ANode^ do
       Begin
        if ANode <> RootNode Then
         Begin
          aSpaceWidth := (ATreeLevel-1)*ATextHeight;
          p_paintMainColumn ( ANode );
          if  ARLLabel.Top + ( ARLLabel.Height + 1) * 2 > ARLBand.Height Then
            Begin
              APriorReport := AReport;
              areport := frlr_CreateNewReport (AParentReport);
              areport.PriorReport:=APriorReport;
              p_BeginPage;
            end;
         end;
        if FirstChild <> nil  Then p_labelNode(FirstChild);
        if  ( ANode <> RootNode )
        and ( NextSibling <> nil )
          Then p_labelNode(NextSibling);
       end;
    end;
    // draw tree's minus
    procedure p_drawMinus ( const ABitmap : TBitmap );
    var AInterleaving : Integer;
        // shadowed
        procedure p_drawPosition ( const X, Y : Integer ; const AColor1, AColor2 : TColor );
        Begin
          with ABitmap,Canvas do
           Begin
            Pen.Color := AColor1;
            Rectangle(X, Y, Width, Height);
            Pen.Color := AColor2;
            MoveTo(AInterleaving+X, Width div 2+Y);
            LineTo(Width - AInterleaving+X , Width div 2+Y);
           End;
        end;

    Begin
      with ABitmap do
       Begin
        AInterleaving:= round ( ATextHeight / 2.5 ) ;
        p_SetAndFillBitmap(ABitmap,ATextHeight - AInterleaving+1,ATextHeight - AInterleaving+1,clWhite);
        dec ( AInterleaving, ATextHeight div 4 );
        p_drawPosition ( 1, 1, clGray, clGray );
        p_drawPosition ( 0, 0, ExtTreeLineColor, ExtColumnFont.Color );
       End;
    end;

Begin
  AReport := AParentReport;
  AReport.ForcePrepare:= False;
  LMinusBM := TBitmap.Create;
  ATempCanvas.Font.Assign(ExtColumnFont);
  // Max text height for lines height
  ATextHeight := ATempCanvas.TextHeight('W');
  ARLLabel := nil;
  AGhosted := False;
  // from viewed HMI tree
  AOnGetImage   := TVTGetImageEvent   ( fmet_getComponentMethodProperty ( atree, CST_PROPERTY_OnGetImageIndex   ));
  AOnGetImageEx := TVTGetImageExEvent ( fmet_getComponentMethodProperty ( atree, CST_PROPERTY_OnGetImageIndexEX ));
  try
    p_drawMinus ( LMinusBM );  // draw tree's minus
    p_BeginPage;
    ATreeOptions := TStringTreeOptions ( fobj_getComponentObjectProperty(atree,'TreeOptions'));
    ATempCanvas.Font.Assign(ExtColumnFont);
    p_labelNode ( atree.RootNode );
    // add right's reports at the and, so can not print them
    if high ( ARightReports ) > 0 Then
      AReport.NextReport := ARightReports[0];
  finally
    lMinusBM.Free;
  end;
end;

// create a datasource or grid report
function fb_CreateReport ( const AReport : TRLReport ; const agrid : TCustomDBGrid; const ADatasource : TDatasource; const AColumns : TCollection; const ATempCanvas : TCanvas;const as_Title : String): Boolean;
var totalgridwidth, aresizecolumns, ATitleHeight, AlineHeight, aVisibleColumns, SomeLeft, totalreportwidth, aWidth, ALinesAddedHeader, ALinesAddedColumns : Integer;
    ARLLabel : TRLLabel;
    ARLDBText : TRLDBText;
    ARLImage : TRLCustomImage;
    ARLBand : TRLBand;
    LImages : TCustomImageList;
    ARLSystemInfo : TRLSystemInfo;

  // resize property
  function fi_resize ( const ai_width, aindex : Integer ):Integer;
  Begin
    if  fb_getComponentBoolProperty ( aColumns.Items [ aindex ], CST_COLUMN_Resize, True )
     Then Result:=ai_width+aresizecolumns
     Else Result:=ai_Width;
  end;

  // really show column ?
  function fb_Visible ( const AItem : TCollectionItem ) : Boolean;
  Begin
    Result :=    fb_getComponentBoolProperty ( AItem, CST_COLUMN_Visible, True )
           and ( flin_getComponentProperty ( AItem, CST_COLUMN_Width ) > CST_COLUMN_MIN_Width )
           and assigned ( ADatasource.DataSet.FindField(fs_getComponentProperty ( AItem, CST_PROPERTY_FIELDNAME )));

  end;

  // calculate lines and widths
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
     End;
  end;

  // header and prepare report's columns
  procedure CreateHeaderAndPrepare;
  var i, j : Integer;
      LIsFirst : Boolean;
      Alines : Integer;
      LString : TStringArray;
  Begin
   with AReport do
    try
      Alines := 1;
      ARLBand:=frlc_CreateHeader ( AReport, as_Title, ATitleHeight );
      SomeLeft:=0;
      with RLLeftTopPage do
       Begin
        ARLBand := frlc_createBand ( AReport, 0, Y + atitleHeight, 4, btHeader, clWhite );
        inc ( atitleHeight, 4 );
        ARLBand := frlc_createBand ( AReport, 0, Y + atitleHeight, 30, btColumnHeader, ExtColumnHeaderColorBack  );
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
      with aColumns do // report's columns preparing
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
                Then ARLLabel := frlc_createLabel ( AReport, ARLBand,SomeLeft,CST_PRINT_INTERNAL_BAND_MARGIN+j*ARLLabel.Height,aWidth, ExtColumnHeaderFont, LString [ j ] )
                Else ARLLabel := frlc_createLabel ( AReport, ARLBand,SomeLeft,CST_PRINT_INTERNAL_BAND_MARGIN+j*ARLLabel.Height,aWidth, ExtColumnHeaderFont, '' );
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
   p_AdaptBands ( ARLBand, ARLLabel, LIsFirst, Alines );
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
      LImages:= fobj_getComponentObjectProperty ( AItem,CST_PROPERTY_IMAGES ) as TCustomImageList;
      if LImages <> nil Then
       Begin
         ARLImage := frlc_createDBImageList ( AReport, ARLBand, ADataSource, SomeLeft,ATop,aiWidth-4,AlineHeight, fs_getComponentProperty( AItem, CST_PROPERTY_FIELDNAME),LImages);
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
         Then Begin ARLImage := frlc_createDBImage ( AReport, ARLBand, ADataSource, SomeLeft,ATop,aiWidth, AlineHeight  , fs_getComponentProperty( AItem, CST_PROPERTY_FIELDNAME)); p_DesignCell( ARLImage , AItem, AIsFirst, ATop, Aline, Aheight ); End
         Else Begin ARLDBText := frlc_createDBText ( AReport, ARLBand, ADataSource, SomeLeft,ATop,aiWidth, ExtColumnFont, fs_getComponentProperty( AItem, CST_PROPERTY_FIELDNAME)); p_DesignCell( ARLDBText, AItem, AIsFirst, ATop, Aline, Aheight ); End;

       end
    End
   Else
     Begin
      ARLLabel := frlc_createLabel ( AReport, ARLBand, SomeLeft,ATop,aiWidth, ExtColumnFont, ASBreakCaption );
      p_DesignCell( ARLLabel, AItem, AIsFirst, ATop, Aline, Aheight );
     end
  end;

  // initing columns
  procedure p_InitList(var ATop : Integer; var AIsFirst : Boolean );
  Begin
    SomeLeft:=0;
    with RLLeftTopPage do
     ARLBand := frlc_createBand ( AReport, X, Y + atitleHeight + 30, 30, btDetail, ExtColumnColorBack );
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

  // Print Grid ( TFWPrintGrid )
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
    p_AdaptBands ( ARLBand, ARLLabel, LIsFirst );
  end;
  // Print Datasource ( TFWPrintData )
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
    p_AdaptBands ( ARLBand, ARLLabel, LIsFirst, ALinesAddedColumns + 1 );
  end;
Begin
  Result := False;
  PreparePrint;
  if totalgridwidth = 0 Then Exit;
  CreateHeaderAndPrepare;
  if agrid  = nil
   Then CreateListPrint
   Else CreateListGrid;
  AReport.DataSource:=ADatasource;
end;

// create a blank report's form
function fref_CreateReport ( const AOrientation : {$IFDEF FPC}TPrinterOrientation{$ELSE}TRLPageOrientation{$ENDIF}; const APaperSize   :TRLPaperSize = fpA4; const acf_filter : TRLCustomPrintFilter = nil ): TReportForm;
Begin
  Result := TReportForm.create ( Application );
  with Result.RLReport, PageSetup do
   Begin
    DefaultFilter:=acf_filter;
    Orientation:=AOrientation;
    PaperSize:=APaperSize;
   end;
End;

// main create tree report
function fref_CreateReport ( const atree : TCustomVirtualStringTree; const as_Title : String; const AOrientation : {$IFDEF FPC}TPrinterOrientation{$ELSE}TRLPageOrientation{$ENDIF} ; const APaperSize   :TRLPaperSize = fpA4; const acf_filter : TRLCustomPrintFilter = nil ): TReportForm;
Begin
  Result := fref_CreateReport ( AOrientation, APaperSize, acf_filter );
  fb_CreateReport ( Result.RLReport, atree, Result.Canvas, as_Title );
end;

// main create grid or data report's form
function fref_CreateReport ( const agrid : TCustomDBGrid; const ADatasource : TDatasource; const AColumns : TCollection; const as_Title : String ; const AOrientation : {$IFDEF FPC}TPrinterOrientation{$ELSE}TRLPageOrientation{$ENDIF} ; const APaperSize   :TRLPaperSize = fpA4; const acf_filter : TRLCustomPrintFilter = nil): TReportForm;
Begin
  Result := fref_CreateReport ( AOrientation, APaperSize, acf_filter );
  fb_CreateReport ( Result.RLReport, agrid, ADatasource, AColumns, Result.Canvas, as_Title );
end;

initialization
{$IFDEF VERSIONS}
  p_ConcatVersion ( gVer_fonctions_reports );
{$ENDIF}
  // customized's reports
  ExtHeaderFont       := TFont.create;
  ExtColumnHeaderFont := TFont.Create;
  ExtColumnFont       := TFont.Create;
  ExtColumnFont      .Size  := CST_PRINT_FONT_SIZE;
  ExtColumnHeaderFont.Size  := CST_PRINT_FONT_SIZE;
  ExtHeaderFont      .Size  := CST_PRINT_FONT_SIZE;
  p_ReinitValues;
finalization
  ExtHeaderFont      .Free;
  ExtColumnHeaderFont.Free;
  ExtColumnFont      .Free;
end.

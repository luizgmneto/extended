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
{$IFDEF VERSIONS}
  fonctions_version,
{$ENDIF}
  Classes ;

{$IFDEF VERSIONS}
const
  gVer_fonctions_reports : T_Version = ( Component : 'System management' ; FileUnit : 'fonctions_reports' ;
                        			                 Owner : 'Matthieu Giroux' ;
                        			                 Comment : 'Reports'' Functions, with grid reports.' ;
                        			                 BugsStory : 'Version 1.0.0.1 : image centering.' + #13#10 +
                                                                             'Version 1.0.0.0 : Working.';
                        			                 UnitType : 1 ;
                        			                 Major : 1 ; Minor : 0 ; Release : 0 ; Build : 1 );
{$ENDIF}

type TBoolArray = Array of Boolean;

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

function fb_CreateGridReport ( const AReportForm : TReportForm ; const agrid : TCustomDBGrid; const as_Title : String  ): Boolean; overload;
function fb_CreateGridReport ( const agrid : TCustomDBGrid; const as_Title : String ; const acf_filter : TRLCustomPrintFilter = nil ): Boolean; overload;

implementation

uses fonctions_proprietes,RLPreview,
     fonctions_images, unite_messages,
     Math,Printers;



function fb_CreateGridReport ( const AReportForm : TReportForm ; const agrid : TCustomDBGrid; const as_Title : String  ): Boolean;
var totalgridwidth, aresizecolumns, atitleHeight, aVisibleColumns, SomeLeft, totalreportwidth, aWidth : Integer;
    aColumns : TDBGridColumns;
    ARLLabel : TRLLabel;
    ARLDBText : TRLDBText;
    ARLImage : TRLImage;
    ARLBand : TRLBand;
    AImages : TCustomImageList;
    AReport : TRLReport;
    ARLSystemInfo : TRLSystemInfo;
    AGridFont : TFont;
  procedure p_createLabel ( const ALeft, ATop, AWidth , AFontWidth : Integer ; const astyle : TFontStyles; const AColor : TColor; const as_Text : String = '' );
  Begin
    ARLLabel := TRLLabel.Create(AReport);
    ARLLabel.Parent:=ARLBand;
    ARLLabel.Top:=ATop;
    ARLLabel.Left:=ALeft;
    ARLLabel.Font.Size:=AFontWidth;
    ARLLabel.Font.Style:=astyle;
    ARLLabel.Font.Color := AColor;
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
  procedure p_createDBText ( const ALeft, ATop, AWidth, AFontWidth : Integer ; const astyle : TFontStyles; const AColor : TColor; const as_Fieldname : String);
  Begin
    ARLDBText := TRLDBText.Create(AReport);
    ARLDBText.Parent:=ARLBand;
    ARLDBText.DataSource:=TDataSource( fobj_getComponentObjectProperty(agrid,'Datasource'));
    ARLDBText.Top:=ATop;
    ARLDBText.Left:=ALeft;
    ARLDBText.Font.Size:=AFontWidth;
    ARLDBText.Font.Style:=astyle;
    ARLDBText.Font.Color := AColor;
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
    if not ( aColumns is TExtDbGridColumns ) or ( aColumns [aindex] as TExtGridColumn ).Resize
     Then Result:=ai_width+aresizecolumns
     Else Result:=ai_Width;
  end;

  procedure PreparePrint;
  var i : Integer;
  Begin
    with agrid,AReport do
     Begin
      for i := 0 to aColumns.Count - 1 do
       with aColumns [ i ] do
        if Visible
        and ( Width > 4 ) Then
         Begin
          inc ( totalgridwidth, Width );
          inc ( aVisibleColumns );
          if not ( aColumns is TExtDbGridColumns ) or ( aColumns [i] as TExtGridColumn ).Resize
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
          p_createLabel(2,2,0,atitleHeight*2 div 3,[fsBold],RLTitlecolor, as_Title);
        end
       Else
       with RLLeftTopPage do
        p_createBand ( X, Y, 10, btHeader );
      p_createSystemInfo(ARLBand.Width,2,10,itPageNumber,[fsBold],RLTitlecolor);
      p_createSystemInfo(ARLBand.Width,2,10,itLastPageNumber,[fsBold],RLTitlecolor, '/');
      SomeLeft:=RLLeftTopPage.X;
      with RLLeftTopPage do
       p_createBand ( X, Y + atitleHeight, 30, btColumnHeader  );
      aresizecolumns:= ( Width - totalgridwidth ) div aresizecolumns;
      for i := 0 to aColumns.Count - 1 do
       with aColumns [ i ] do
        if Visible Then
         Begin
           awidth:=fi_resize ( Width, i );
           p_createLabel (SomeLeft,2,aWidth,AGridFont.Size,[fsBold],RLColumnHeadercolor, Title.caption);
           inc ( SomeLeft, aWidth );
         end;


    end;
  end;

  procedure CreateList;
  var i : Integer;
  Begin
    with agrid,AReport do
     Begin
      SomeLeft:=RLLeftTopPage.X;
      with RLLeftTopPage do
       p_createBand ( X, Y + atitleHeight + 30, 30, btDetail );
      for i := 0 to aColumns.Count - 1 do
       with aColumns [ i ] do
        if Visible
        and ( Width > 4 ) Then
         Begin
           awidth:=fi_resize ( Width, i );
           if  ( aColumns [ i ] is TExtGridColumn ) Then
             AImages:=( aColumns [ i ] as TExtGridColumn ).Images;
           if AImages <> nil Then
            with agrid as TextDBGrid, aColumns [ i ] as TExtGridColumn do
            Begin
              p_createImage (SomeLeft,2,aWidth-4);
              ARLImage.BeforePrint := ReportForm.p_BeforePrintImage;
              SetLength ( RLListImages, high ( RLListImages ) + 2 );
              with RLListImages [ high ( RLListImages )] do
               Begin
                 AImage := ARLImage ;
                 AField := Field ;
                 AGetImageIndex := OnGetImageIndex;
                 AMapImages := MapImages;
                 AImages := Images;
                 AWidth  := aColumns [ i ].Width;
                 ABand   := ARLBand;
               end;
            end
           Else
            p_createDBText(SomeLeft,2,aWidth,AGridFont.Size,[],RLColumnHeadercolor, FieldName);
           inc ( SomeLeft, aWidth );
         end;

      End;
  end;

Begin
  AGridFont := TFont ( fobj_getComponentObjectProperty(agrid,'Font'));
  AReport := AReportForm.AReport;
  Result := False;
  aresizecolumns := 0 ;
  aVisibleColumns := 0;
  totalgridwidth := 0;
  aColumns := TDBGridColumns ( fobj_getComponentObjectProperty(agrid,'Columns'));
  PreparePrint;
  if totalgridwidth = 0 Then Exit;
  CreateHeader;
  CreateList;
end;

function fb_CreateGridReport ( const agrid : TCustomDBGrid; const as_Title : String ; const acf_filter : TRLCustomPrintFilter = nil ): Boolean;
var ADatasource : TDatasource;
Begin
  ReportForm := TReportForm.create ( nil );
  ADatasource := TDataSource ( fobj_getComponentObjectProperty(agrid,'Datasource'));
  ADatasource.DataSet.DisableControls;
  with ReportForm do
  try
    AReport.DefaultFilter:=acf_filter;
    Result:=fb_CreateGridReport ( ReportForm, agrid, as_Title );
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

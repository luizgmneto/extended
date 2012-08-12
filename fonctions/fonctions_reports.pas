unit fonctions_reports;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFNDEF FPC}
  Windows,
{$ENDIF}
  Classes, SysUtils, RLReport, DBGrids, DB,
  u_extdbgrid,U_ExtMapImageIndex,Forms,
  u_reportform,ImgList, Graphics;

type TBoolArray = Array of Boolean;

var RLLeftTopPage : TPoint = ( X: 20; Y:20 );
    RLListImages : array of record
                            AImage : TRLImage ;
                            AField : TField ;
                            AGetImageIndex : TFieldIndexEvent;
                            AMapImages : TExtMapImages;
                            AImages : TCustomImageList;
                           end;
    RLTitlecolor : TColor = clBlue;
    RLColumnHeadercolor : TColor = clBlack;
    RLColumnTextcolor : TColor = clBlack;

function fb_CreateGridReport ( const AReportForm : TReportForm ; const agrid : TCustomDBGrid; const as_Title : String ; const ab_resize : Array of Boolean ): Boolean; overload;
function fb_CreateGridReport ( const agrid : TCustomDBGrid; const as_Title : String ; const ab_resize : Array of Boolean ): Boolean; overload;

implementation

uses fonctions_proprietes,RLPreview,
     fonctions_images, unite_messages;



function fb_CreateGridReport ( const AReportForm : TReportForm ; const agrid : TCustomDBGrid; const as_Title : String ; const ab_resize : Array of Boolean  ): Boolean;
var i, totalgridwidth, aresizecolumns, atitleHeight, SomeLeft, totalreportwidth, awidth : Integer;
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
    ARLSystemInfo.Alignment:=taLeftJustify;
    ARLSystemInfo.Align:=faRight;
    ARLSystemInfo.Layout:=tlTop;
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
    ARLBand.Width:=AReport.Width-RLLeftTopPage.X*2;
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

  function fi_resize ( const ai_width : Integer ):Integer;
  Begin
    if ( high ( ab_resize ) < i ) or ab_resize[i]
     Then Result:=ai_width+aresizecolumns
     Else Result:=ai_Width;
  end;

Begin
  AGridFont := TFont ( fobj_getComponentObjectProperty(agrid,'Font'));
  AReport := AReportForm.AReport;
  Result := False;
  aresizecolumns := 0 ;
  totalgridwidth := 0;
  aColumns := TDBGridColumns ( fobj_getComponentObjectProperty(agrid,'Columns'));
  with agrid,AReport do
   Begin
    for i := 0 to aColumns.Count - 1 do
     with aColumns [ i ] do
      if Visible
      and ( Width > 4 ) Then
       Begin
        inc ( totalgridwidth, Width );
        inc ( aresizecolumns );
       end;
    if totalgridwidth = 0 Then Exit;
    atitleHeight := round ( ( Width - 80 ) div length ( as_Title )*2.1 );
    with RLLeftTopPage do
      p_createBand ( X, Y, atitleHeight + 4, btHeader );
    p_createLabel(2,2,0,atitleHeight*3 div 5,[fsBold],RLTitlecolor, as_Title);
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
         awidth:=fi_resize ( Width );
         p_createLabel (SomeLeft,2,aWidth,AGridFont.Size,[fsBold],RLColumnHeadercolor, Title.caption);
         inc ( SomeLeft, aWidth );
       end;
    SomeLeft:=RLLeftTopPage.X;
    with RLLeftTopPage do
     p_createBand ( X, Y + atitleHeight + 30, 30, btDetail );
    for i := 0 to aColumns.Count - 1 do
     with aColumns [ i ] do
      if Visible
      and ( Width > 4 ) Then
       Begin
         awidth:=fi_resize ( Width );
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
             end;
          end
         Else
          p_createDBText(SomeLeft,2,aWidth,AGridFont.Size,[],RLColumnHeadercolor, FieldName);
         inc ( SomeLeft, aWidth );
       end;
   end;
end;

function fb_CreateGridReport ( const agrid : TCustomDBGrid; const as_Title : String ;const ab_resize : Array of Boolean  ): Boolean;
var ADatasource : TDatasource;
Begin
  ReportForm := TReportForm.create ( nil );
  ADatasource := TDataSource ( fobj_getComponentObjectProperty(agrid,'Datasource'));
  ADatasource.DataSet.DisableControls;
  with ReportForm do
  try
    Result:=fb_CreateGridReport ( ReportForm, agrid, as_Title, ab_resize );
    AReport.DataSource:=ADatasource;
    AReport.Preview(nil);
  finally
    Destroy;
    ADatasource.DataSet.EnableControls;
    Finalize ( RLListImages );
    ReportForm := nil;
  end;
end;

end.


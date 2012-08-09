unit fonctions_reports;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
  Classes, SysUtils, RLReport, DBGrids, DB,
  u_extdbgrid,U_ExtMapImageIndex,Forms,
  u_reportform,ImgList;

type TBoolArray = Array of Boolean;

var RLLeftTopPage : TPoint = ( X: 20; Y:20 );
    ListImages : array of record
                            AImage : TRLImage ;
                            AField : TField ;
                            AGetImageIndex : TFieldIndexEvent;
                            AMapImages : TExtMapImages;
                            AImages : TCustomImageList;
                           end;


function fb_CreateGridReport ( const AReportForm : TReportForm ; const agrid : TCustomDBGrid; const as_Title : String ; const ab_resize : Array of Boolean ): Boolean; overload;
function fb_CreateGridReport ( const agrid : TCustomDBGrid; const as_Title : String ; const ab_resize : Array of Boolean ): Boolean; overload;

implementation

uses Graphics, fonctions_proprietes,RLPreview,
     fonctions_images;



function fb_CreateGridReport ( const AReportForm : TReportForm ; const agrid : TCustomDBGrid; const as_Title : String ; const ab_resize : Array of Boolean  ): Boolean;
var i, totalgridwidth, atitleHeight, SomeLeft, totalreportwidth : Integer;
    aColumns : TDBGridColumns;
    ARLLabel : TRLLabel;
    ARLDBText : TRLDBText;
    ARLImage : TRLImage;
    ARLBand : TRLBand;
    AImages : TCustomImageList;
    AReport : TRLReport;
  procedure p_createLabel ( const ALeft, ATop, AWidth : Integer ; const astyle : TFontStyles; const as_Text : String = '' );
  Begin
    ARLLabel := TRLLabel.Create(AReport);
    ARLLabel.Parent:=ARLBand;
    ARLLabel.Top:=ATop;
    ARLLabel.Left:=ALeft;
    ARLLabel.Font.Size:=AWidth;
    ARLLabel.Font.Style:=astyle;
    ARLLabel.Caption:=as_Text;
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
  procedure p_createDBText ( const ALeft, ATop, AWidth : Integer ; const astyle : TFontStyles; const as_Fieldname : String);
  Begin
    ARLDBText := TRLDBText.Create(AReport);
    ARLDBText.Parent:=ARLBand;
    ARLDBText.DataSource:=TDataSource( fobj_getComponentObjectProperty(agrid,'Datasource'));
    ARLDBText.Top:=ATop;
    ARLDBText.Left:=ALeft;
    ARLDBText.Font.Size:=AWidth;
    ARLDBText.Font.Style:=astyle;
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

Begin
  AReport := AReportForm.AReport;
  Result := False;
  aColumns := TDBGridColumns ( fobj_getComponentObjectProperty(agrid,'Columns'));
  with agrid,AReport do
   Begin
    for i := 0 to aColumns.Count - 1 do
     with aColumns [ i ] do
      if Visible Then
       inc ( totalgridwidth, Width );
    if totalgridwidth = 0 Then Exit;
    atitleHeight := round (  Width div length ( as_Title )*2.1 );
    with RLLeftTopPage do
      p_createBand ( X, Y, atitleHeight + 4, btHeader );
    p_createLabel(2,2,atitleHeight*3 div 5,[fsBold], as_Title);
    SomeLeft:=RLLeftTopPage.X;
    with RLLeftTopPage do
     p_createBand ( X, Y + atitleHeight, 30, btColumnHeader  );
    for i := 0 to aColumns.Count - 1 do
     with aColumns [ i ] do
      if Visible Then
       Begin
         p_createLabel (SomeLeft,2,13,[fsBold], Title.caption);
         inc ( SomeLeft, Width );
       end;
    SomeLeft:=RLLeftTopPage.X;
    with RLLeftTopPage do
     p_createBand ( X, Y + atitleHeight + 30, 30, btDetail );
    for i := 0 to aColumns.Count - 1 do
     with aColumns [ i ] do
      if Visible Then
       Begin
         if  ( aColumns [ i ] is TExtGridColumn ) Then
           AImages:=( aColumns [ i ] as TExtGridColumn ).Images;
         if AImages <> nil Then
          with agrid as TextDBGrid, aColumns [ i ] as TExtGridColumn do
          Begin
            p_createImage (SomeLeft,2,Width-4);
            ARLImage.BeforePrint := ReportForm.p_BeforePrintImage;
            SetLength ( ListImages, high ( ListImages ) + 2 );
            with ListImages [ high ( ListImages )] do
             Begin
               AImage := ARLImage ;
               AField := Field ;
               AGetImageIndex := OnGetImageIndex;
               AMapImages := MapImages;
               AImages := Images;
             end;
          end
         Else
          p_createDBText(SomeLeft,2,12,[], FieldName);
         inc ( SomeLeft, Width );
       end;
   end;
end;

function fb_CreateGridReport ( const agrid : TCustomDBGrid; const as_Title : String ;const ab_resize : Array of Boolean  ): Boolean;
Begin
  ReportForm := TReportForm.create ( nil );
  with ReportForm do
  try
    Result:=fb_CreateGridReport ( ReportForm, agrid, as_Title, ab_resize );
    AReport.DataSource:=TDataSource ( fobj_getComponentObjectProperty(agrid,'Datasource'));
    AReport.Preview(nil);
  finally
    Destroy;
    Finalize ( ListImages );
    ReportForm := nil;
  end;
end;

end.


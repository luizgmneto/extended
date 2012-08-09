unit u_reportform;

{$mode delphi}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,
  CompSuperForm, RLReport;

type

  { TReportForm }

  TReportForm = class(TSuperForm)
    AReport: TRLReport;
    procedure p_BeforePrintImage(Sender: TObject; var PrintIt: boolean);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  ReportForm: TReportForm;

implementation

uses DB, fonctions_images, fonctions_reports;

{$R *.lfm}

procedure TReportForm.p_BeforePrintImage (Sender:TObject; var PrintIt:boolean);
var aimageindex : Integer;
    Abitmap : Tbitmap ;
    ADatasource : TDatasource;
    I : Integer;
Begin
  for i := 0 to high ( ListImages ) do
   with ListImages [ i ] do
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
             Bitmap.Canvas.FillRect( 0, 0, Width, Height );
             Bitmap.Canvas.Draw ( 0, 0, Abitmap );
             Bitmap.Modified := True;
             {$IFNDEF FPC}
             Dormant;
             {$ENDIF}
             FreeImage;
             Free;
            end;
         end;
      End;
end;



end.


unit u_reportform;

{$IFDEF FPC}
{$mode Delphi}
{$ENDIF}


interface

uses
{$IFDEF FPC}
  FileUtil, 
{$ELSE}
{$ENDIF}
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  CompSuperForm, RLReport;

type

  { TReportForm }

  TReportForm = class(TSuperForm)
    AReport: TRLReport;
    Panel1: TPanel;
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

{$IFDEF FPC}
{$R *.lfm}
{$ELSE}
{$R *.dfm}
{$ENDIF}


procedure TReportForm.p_BeforePrintImage (Sender:TObject; var PrintIt:boolean);
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
               0, 0, Width, Height {$IFNDEF FPC}){$ENDIF});
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


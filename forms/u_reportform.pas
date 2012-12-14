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



end.


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
  CompSuperForm, RLReport, RLRichFilter, RLPDFFilter, RLHTMLFilter,
  RLDraftFilter;

type

  { TReportForm }

  TReportForm = class(TSuperForm)
    RLDraftFilter: TRLDraftFilter;
    RLHTMLFilter: TRLHTMLFilter;
    RLPDFFilter: TRLPDFFilter;
    RLReport: TRLReport;
    Panel1: TPanel;
    RLRichFilter: TRLRichFilter;
  private
    { private declarations }
  public
    { public declarations }
  end;

implementation

uses DB, fonctions_images, fonctions_reports;

{$IFDEF FPC}
{$R *.lfm}
{$ELSE}
{$R *.dfm}
{$ENDIF}



end.


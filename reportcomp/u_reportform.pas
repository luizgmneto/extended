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
  u_formadapt, RLReport,
  RLRichFilter, RLPDFFilter,
  RLHTMLFilter, u_reports_rlcomponents,
  RLDraftFilter;

type
  { TReportForm }

  TReportForm = class(TF_FormAdapt)
    RLDraftFilter: TRLDraftFilter;
    RLHTMLFilter: TRLHTMLFilter;
    RLPDFFilter: TRLPDFFilter;
    RLReport: TExtReport;
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


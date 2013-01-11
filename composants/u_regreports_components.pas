unit u_regreports_components;

{$I ..\DLCompilers.inc}
{$I ..\extends.inc}
{$IFDEF FPC}
{$mode Delphi}
{$ENDIF}

interface

uses
{$IFDEF FPC}
  lresources,
{$ELSE}
  Windows, Messages,
{$ENDIF}
  Classes;


procedure Register;

implementation

uses u_reports_components,
     u_reports_rlcomponents,
     unite_messages,
     fonctions_reports,
     Forms;

{ TFWPrintGrid }

procedure Register;
begin
  RegisterComponents( 'ExtFortes', [ TFWPrintGrid, TFWPrintData, TRLDBExtImage, TRLDBExtImageList ]);
End ;



initialization
{$IFDEF FPC}
{$I u_regreports_components.lrs}
{$ENDIF}
end.

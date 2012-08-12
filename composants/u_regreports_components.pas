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
     unite_messages,
     Forms;

{ TFWPrintGrid }

procedure Register;
begin
  RegisterComponents(CST_PALETTE_COMPOSANTS, [ TFWPrintGrid ]);
End ;



initialization
{$IFDEF FPC}
{$I u_regreports_components.lrs}
{$ENDIF}
end.

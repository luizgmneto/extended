unit u_regframeworkcomponents;

{$IFDEF FPC}
{$mode Delphi}
{$ENDIF}


interface

uses
  Classes, SysUtils,
{$IFDEF FPC}
  lresources,
{$ENDIF}
  u_framework_components;


procedure Register;

implementation

uses unite_messages;

procedure Register;
begin
  RegisterComponents(CST_PALETTE_COMPOSANTS, [TFWDBEdit,TFWDBLookupCombo,TFWDBGrid,TFWLabel,TFWDBMemo,TFWDBDateEdit{$IFNDEF FPC},TFWDBDateTimePicker{$ENDIF}]);
end;

initialization
{$IFDEF FPC}
  {$i u_framework_components.lrs}
{$ENDIF}
end.


unit u_register_net;

{$IFDEF FPC}
{$mode Delphi}
{$ENDIF}

interface

uses
  Classes, SysUtils;

procedure Register;

implementation

uses u_netupdate,
     unite_messages,
     LResources;

procedure Register;
Begin
  RegisterComponents(CST_PALETTE_COMPOSANTS_INVISIBLE, [TNetUpdate]);
End;

{$IFDEF FPC}
initialization
  {$I u_register_net.lrs}
{$ENDIF}
end.


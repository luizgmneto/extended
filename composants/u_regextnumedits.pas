{*********************************************************************}
{                                                                     }
{                                                                     }
{             Matthieu Giroux                                         }
{             TExtNumEdit  :                                       }
{             Composant edit de nombre              }
{             TExtDBNumEdit :                                       }
{             Composant dbedit de nombre }
{             22 Avril 2006                                           }
{                                                                     }
{                                                                     }
{*********************************************************************}

unit u_regextnumedits;

{$IFDEF FPC}
{$mode objfpc}{$H+}
{$ENDIF}

interface

{$I ..\Compilers.inc}
{$I ..\extends.inc}

uses
{$IFDEF FPC}
  lresources,
{$ELSE}
  Windows,
{$ENDIF}
  Messages,  SysUtils, Classes;

procedure Register;

implementation

uses
    u_extnumedits, unite_messages ;

procedure Register;
begin
  RegisterComponents(CST_PALETTE_COMPOSANTS, [TExtNumEdit,TExtDBNumEdit]);
End ;

initialization
{$IFDEF FPC}
  {$I U_ExtNumEdits.lrs}
{$ENDIF}
end.

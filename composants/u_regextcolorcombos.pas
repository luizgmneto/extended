{*********************************************************************}
{                                                                     }
{                                                                     }
{             Matthieu Giroux                                         }
{             TExtColorCombo :                                        }
{             Objet de choix de couleur                               }
{             qui permet de personnalisé la couleur du titre          }
{             de l'onglet actif                                       }
{             10 Mars 2006                                            }
{                                                                     }
{                                                                     }
{*********************************************************************}

unit u_regextcolorcombos;

{$IFDEF FPC}
{$mode objfpc}{$H+}
{$ENDIF}

{$I ..\Compilers.inc}

interface

uses
{$IFDEF FPC}
  lresources,
{$ELSE}
  Windows,
{$ENDIF}
  Classes, Graphics ;



procedure Register;

implementation

uses unite_messages, u_ExtColorCombos;

procedure Register;
begin
  RegisterComponents(CST_PALETTE_COMPOSANTS, [TExtColorCombo,TExtDBColorCombo]);
end;
initialization
{$IFDEF FPC}
  {$i U_ExtColorCombos.lrs}
{$ENDIF}
end.

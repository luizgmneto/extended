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

unit u_regfwbuttons;

{$IFDEF FPC}
{$mode objfpc}{$H+}
{$ENDIF}

interface

{$I ..\DLCompilers.inc}
{$I ..\extends.inc}

uses
{$IFDEF FPC}
  lresources,
{$ELSE}
  Windows,
{$ENDIF}
  SysUtils, Classes;

procedure Register;

implementation

uses
    u_buttons_appli, unite_messages ;

procedure Register;
begin
  RegisterComponents('FWButtons', [TFWXPButton,TFWClose,TFWNext,TFWPrior,TFWLoad,TFWTrash,TFWConfig,
                                   {$IFDEF GROUPVIEW}TFWBasket,TFWInSelect,TFWInAll,TFWOutSelect,TFWOutAll,{$ENDIF}
                                   TFWOK,TFWInsert,TFWInit,TFWDelete,TFWDocument,TFWCancel,TFWQuit,TFWErase,TFWSaveAs,TFWAdd,TFWImport,TFWExport,TFWPrint,TFWPreview,TFWCopy]);
End ;

initialization
  {$I u_regFWXPButton.lrs}
end.

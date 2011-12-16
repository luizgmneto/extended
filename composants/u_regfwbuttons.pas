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
  RegisterComponents('FWButtons', [TFWClose,TFWNext,TFWPrior,TFWLoad,TFWTrash,TFWBasket,TFWOK,TFWInsert,TFWInit,TFWDelete,TFWDocument,TFWCancel,TFWQuit,TFWErase,TFWSaveAs,TFWAdd,TFWImport,TFWExport,TFWPrint,TFWPreview,TFWCopy,TFWInSelect,TFWInAll,TFWOutSelect,TFWOutAll]);
End ;

initialization
end.

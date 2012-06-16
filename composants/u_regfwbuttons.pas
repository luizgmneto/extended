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
  RegisterComponents('FWButtons', [TFWXPButton,TFWRefresh,TFWClose,TFWDate,TFWMDate,TFWFolder,TFWMFolder,
                                   TFWNext,TFWPrior,TFWLoad,TFWTrash,TFWConfig,
                                   {$IFDEF GROUPVIEW}TFWBasket,TFWInSelect,TFWInAll,TFWOutSelect,TFWOutAll,{$ENDIF}
                                   TFWOK,TFWInsert,TFWInit,TFWAdd,TFWMAdd,TFWDelete,TFWMDelete,TFWDocument,
                                   TFWCancel,TFWQuit,TFWErase,TFWImport,TFWExport,TFWPrint,TFWPreview,TFWCopy,
                                   TFWSaveAs,TFWSearch,TFWMSearch,TFWZoomIn,TFWMZoomIn,TFWZoomOut,TFWMZoomOut]);
End ;

{$IFDEF FPC}
initialization
  {$I u_regFWXPButton.lrs}
{$ENDIF}
end.

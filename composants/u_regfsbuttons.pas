unit u_regfsbuttons;

{$IFDEF FPC}
{$mode Delphi}
{$ENDIF}

{$I ..\DLCompilers.inc}
{$I ..\extends.inc}

interface

uses
{$IFDEF FPC}
  lresources,
{$ELSE}
  Windows,
{$ENDIF}
  SysUtils, Classes;

procedure Register;

implementation

uses u_buttons_extension;

procedure Register;
begin
  RegisterComponents('FSButtons', [TFSClose,TFSNext,TFSPrior,TFSLoad,TFSTrash,
                                   {$IFDEF GROUPVIEW} TFSBasket,TFSInSelect,TFSInAll,TFSOutSelect,TFSOutAll,{$ENDIF}
                                   TFSOK,TFSInsert,TFSInit,TFSDelete,TFSDocument,TFSCancel,TFSQuit,TFSErase,TFSSaveAs,TFSAdd,TFSImport,TFSExport,TFSPrint,TFSPreview,TFSCopy]);
End ;



initialization
{$IFDEF FPC}
  {$I u_regfsbuttons.lrs}
{$ENDIF}

end.


unit u_regextcomponents;

{$IFDEF FPC}
{$mode Delphi}
{$ENDIF}


{$I ..\DLCompilers.inc}
{$I ..\extends.inc}

interface

uses
  Classes,
{$IFDEF FPC}
  lresources,
{$ENDIF}
  SysUtils;

procedure Register;

implementation

uses  {$IFDEF FPC}
  unite_messages, u_extDBDirectoryEdit,
  {$ELSE}
  unite_messages_delphi,
  {$ENDIF}
     U_ExtDBNavigator,
     U_ExtNumEdits,U_ExtColorCombos,
{$IFDEF FPC}
     ComponentEditors, dbpropedits, PropEdits,
     u_scrollclones,
{$ELSE}
     DBReg, Designintf,
{$ENDIF}
     PDBCheck, PCheck,
     u_extsearchedit,
     u_extformatedits,
     u_extradios;

procedure Register;
begin
  RegisterComponents(CST_PALETTE_COMPOSANTS_DB, [TExtFormatDBEdit,TPDBCheck,
                                                {$IFDEF FPC}TExtDBDirectoryEdit,TExtClonedPanel,{$ENDIF}
                                                TExtDBNavigator,
                                                TExtSearchDBEdit,TExtSearchEdit,
                                                TExtDBNumEdit]);
  RegisterComponents(CST_PALETTE_COMPOSANTS   , [TExtFormatEdit,TPCheck,TExtColorCombo,
                                                TExtNumEdit,TExtRadioGroup]);
  RegisterPropertyEditor ( TypeInfo(string), TExtDBNavigator, 'SortField', {$IFDEF FPC}TFieldProperty{$ELSE}TDataFieldProperty{$ENDIF});
end;

{$IFDEF FPC}
initialization
  {$i U_ExtDBNavigator.lrs}
  {$i U_DBListView.lrs}
  {$i U_ExtColorCombos.lrs}
  {$i u_extdbdirectoryedit.lrs}
  {$i U_ExtNumEdits.lrs}
  {$i u_scrollclones.lrs}
  {$i PDBCheck.lrs}
  {$i PCheck.lrs}
  {$i u_framework_dbcomponents.lrs}
  {$i u_framework_components.lrs}
  {$i u_extformatedits.lrs}
{$ENDIF}
end.


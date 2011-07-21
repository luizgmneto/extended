unit u_regframeworkcomponents;

{$IFDEF FPC}
{$mode Delphi}
{$ENDIF}


interface

uses
  Classes,
{$IFDEF FPC}
  lresources,
{$ENDIF}
  SysUtils;


procedure Register;

implementation

uses unite_messages, U_DBListView, U_ExtDBNavigator,
     u_framework_dbcomponents, u_framework_components,
     U_OnFormInfoIni,U_ExtNumEdits,U_ExtColorCombos,
     u_extsearchedit, U_ExtComboInsert,
{$IFDEF FPC}
     ComponentEditors, dbpropedits, PropEdits,
{$ELSE}
     DBReg, Designintf,
{$ENDIF}
     U_ExtDBImage, u_extdbgrid, u_extmenucustomize,
     u_extmenutoolbar;

procedure Register;
begin
  RegisterComponents(CST_PALETTE_COMPOSANTS_INVISIBLE, [TOnFormInfoIni, TExtMenuCustomize]);
  RegisterComponents(CST_PALETTE_COMPOSANTS_DB, [TDBListView,TExtDBNavigator,
                                                TExtDBImage,TExtDBNumEdit, TExtDBComboInsert,
                                                TExtDBColorCombo, TExtSearchDBEdit,
                                                TFWDBEdit,TFWDBLookupCombo,TExtDBGrid,TFWDBMemo,
                                                TFWDBDateEdit{$IFNDEF FPC},TFWDBDateTimePicker{$ENDIF}]);
  RegisterComponents(CST_PALETTE_COMPOSANTS   , [TExtNumEdit,
                                                TExtColorCombo, TExtMenuToolBar,
                                                TFWLabel, TFWEdit,TFWGrid,TFWMemo,TFWDateEdit]);
  RegisterPropertyEditor ( TypeInfo({$IFDEF FPC}ShortString {$ELSE}string{$ENDIF}), TDBListView, 'DataKeyUnit'   , {$IFDEF FPC}TFieldProperty{$ELSE}TDataFieldProperty{$ENDIF});
  RegisterPropertyEditor ( TypeInfo({$IFDEF FPC}ShortString {$ELSE}string{$ENDIF}), TDBListView, 'DataSort'      , {$IFDEF FPC}TFieldProperty{$ELSE}TDataFieldProperty{$ENDIF});
  RegisterPropertyEditor ( TypeInfo(string), TDBListView, 'DataFieldsDisplay'   , {$IFDEF FPC}TFieldProperty{$ELSE}TDataFieldProperty{$ENDIF});
  RegisterPropertyEditor ( TypeInfo(string), TExtDBNavigator, 'SortField', {$IFDEF FPC}TFieldProperty{$ELSE}TDataFieldProperty{$ENDIF});
  RegisterPropertyEditor ( TypeInfo(string), TExtSearchDBEdit, 'FieldKey'   , {$IFDEF FPC}TFieldProperty{$ELSE}TDataFieldProperty{$ENDIF});
end;

{$IFDEF FPC}
initialization
  {$i u_framework_components.lrs}
  {$i u_framework_dbcomponents.lrs}
  {$I U_RegImageComponents.lrs}
  {$i U_ExtDBNavigator.lrs}
  {$i U_DBListView.lrs}
  {$i U_OnFormInfoIni.lrs}
  {$i u_extsearchedit.lrs}
  {$i U_ExtComboInsert.lrs}
  {$i U_ExtColorCombos.lrs}
  {$i U_ExtNumEdits.lrs}
  {$i u_extmenucustomize.lrs}
  {$i u_extdbgrid.lrs}
{$ENDIF}
end.


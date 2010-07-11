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

uses unite_messages, U_DBListView, U_ExtDBNavigator,u_framework_components,
     U_OnFormInfoIni,U_ExtNumEdits,U_ExtColorCombos,U_ExtDBImage,
     ComponentEditors, dbpropedits, PropEdits;

procedure Register;
begin
  RegisterComponents(CST_PALETTE_COMPOSANTS, [TDBListView,TOnFormInfoIni,TExtDBNavigator,TExtNumEdit,TExtDBImage,TExtDBNumEdit,TExtColorCombo,TExtDBColorCombo,TFWDBEdit,TFWDBLookupCombo,TFWDBGrid,TFWLabel,TFWDBMemo,TFWDBDateEdit{$IFNDEF FPC},TFWDBDateTimePicker{$ENDIF}]);
{$IFDEF DELPHI}
  RegisterPropertyEditor ( TypeInfo(string), TExtDBNavigator, 'SortField', TDataFieldProperty);
{$ENDIF}
  RegisterPropertyEditor ( TypeInfo({$IFDEF FPC}ShortString {$ELSE}string{$ENDIF}), TDBListView, 'DataKeyUnit'   , {$IFDEF FPC}TFieldProperty{$ELSE}TDataFieldProperty{$ENDIF});
  RegisterPropertyEditor ( TypeInfo({$IFDEF FPC}ShortString {$ELSE}string{$ENDIF}), TDBListView, 'DataSort'      , {$IFDEF FPC}TFieldProperty{$ELSE}TDataFieldProperty{$ENDIF});
  RegisterPropertyEditor ( TypeInfo(string), TDBListView, 'DataFieldsDisplay'   , {$IFDEF FPC}TFieldProperty{$ELSE}TDataFieldProperty{$ENDIF});
end;

initialization
{$IFDEF FPC}
  {$i u_framework_components.lrs}
  {$I U_RegImageComponents.lrs}
  {$i U_ExtDBNavigator.lrs}
  {$i U_DBListView.lrs}
  {$i U_OnFormInfoIni.lrs}
{$ENDIF}
end.


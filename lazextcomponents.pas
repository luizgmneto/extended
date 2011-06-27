{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit lazextcomponents; 

interface

uses
    U_OnFormInfoIni, PDBCheck, PCheck, U_ExtColorCombos, u_regfwbuttons, 
  u_buttons_appli, u_extcomponent, u_framework_components, U_DBListView, 
  U_ExtNumEdits, u_regframeworkcomponents, U_ExtDBNavigator, U_FormMainIni, 
  U_ExtDBImage, u_framework_dbcomponents, u_extsearchedit, U_ExtComboInsert, 
  u_extdbgrid, u_extmenutoolbar, LazarusPackageIntf;

implementation

procedure Register; 
begin
  RegisterUnit('PDBCheck', @PDBCheck.Register); 
  RegisterUnit('PCheck', @PCheck.Register); 
  RegisterUnit('u_regfwbuttons', @u_regfwbuttons.Register); 
  RegisterUnit('u_regframeworkcomponents', @u_regframeworkcomponents.Register); 
end; 

initialization
  RegisterPackage('lazextcomponents', @Register); 
end.

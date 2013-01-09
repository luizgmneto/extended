{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit lazextcomponents;

interface

uses
  U_OnFormInfoIni, PDBCheck, PCheck, U_ExtColorCombos, u_extcomponent, 
  u_framework_components, U_DBListView, U_ExtNumEdits, U_ExtDBNavigator, 
  U_ExtDBImage, u_framework_dbcomponents, u_extsearchedit, U_ExtComboInsert, 
  u_extdbgrid, U_ExtImage, U_GroupView, U_ExtPictCombo, U_ExtMapImageIndex, 
  u_extimagelist, U_ExtDBPictCombo, u_extradios, u_buttons_defs, 
  u_extDBDirectoryEdit, U_FormMainIni, u_scrollclones, U_ExtDBImageList, 
  LazarusPackageIntf;

implementation

procedure Register;
begin
end;

initialization
  RegisterPackage('lazextcomponents', @Register);
end.

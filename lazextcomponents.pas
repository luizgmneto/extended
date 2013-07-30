{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit lazextcomponents;

interface

uses
  PDBCheck, PCheck, U_ExtColorCombos, u_extcomponent, U_DBListView, 
  U_ExtNumEdits, U_ExtDBNavigator, U_GroupView, u_extradios, U_FormMainIni, 
  u_scrollclones, LazarusPackageIntf;

implementation

procedure Register;
begin
end;

initialization
  RegisterPackage('lazextcomponents', @Register);
end.

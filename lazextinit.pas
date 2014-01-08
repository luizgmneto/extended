{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit lazextinit;

interface

uses
  u_extmenucustomize, U_OnFormInfoIni, u_extmenutoolbar, U_FormAdapt, 
  U_FormMainIni, fonctions_forms, U_CustomizeMenu, fonctions_init, 
  fonctions_vtree, menutbar, LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('menutbar', @menutbar.Register);
end;

initialization
  RegisterPackage('lazextinit', @Register);
end.

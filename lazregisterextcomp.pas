{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit lazregisterextcomp; 

interface

uses
  u_regframeworkcomponents, U_RegisterGroupView, LazarusPackageIntf;

implementation

procedure Register; 
begin
  RegisterUnit('u_regframeworkcomponents', @u_regframeworkcomponents.Register); 
  RegisterUnit('U_RegisterGroupView', @U_RegisterGroupView.Register); 
end; 

initialization
  RegisterPackage('lazregisterextcomp', @Register); 
end.

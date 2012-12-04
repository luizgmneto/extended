{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit lazregisterextcomp;

interface

uses
  u_regframeworkcomponents, U_RegisterGroupView, u_regextfilecopy, 
  U_RegVersion, u_regfwbuttons, u_registerforms, LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('u_regframeworkcomponents', @u_regframeworkcomponents.Register);
  RegisterUnit('U_RegisterGroupView', @U_RegisterGroupView.Register);
  RegisterUnit('u_regextfilecopy', @u_regextfilecopy.Register);
  RegisterUnit('u_regfwbuttons', @u_regfwbuttons.Register);
  RegisterUnit('u_registerforms', @u_registerforms.Register);
end;

initialization
  RegisterPackage('lazregisterextcomp', @Register);
end.

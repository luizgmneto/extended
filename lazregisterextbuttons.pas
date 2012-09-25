{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit lazregisterextbuttons;

interface

uses
  u_regsbbuttons, u_regfwbuttons_appli, u_regreports_components, 
  LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('u_regsbbuttons', @u_regsbbuttons.Register);
  RegisterUnit('u_regfwbuttons_appli', @u_regfwbuttons_appli.Register);
  RegisterUnit('u_regreports_components', @u_regreports_components.Register);
end;

initialization
  RegisterPackage('lazregisterextbuttons', @Register);
end.

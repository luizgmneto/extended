{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit lazextbuttons;

interface

uses
  u_buttons_extension, u_buttons_blue, u_buttons_flat, u_buttons_speed, 
  u_extmenucustomize, u_extmenutoolbar, U_CustomizeMenu, u_buttons_appli, 
  LazarusPackageIntf;

implementation

procedure Register;
begin
end;

initialization
  RegisterPackage('lazextbuttons', @Register);
end.

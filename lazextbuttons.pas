{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit lazextbuttons;

interface

uses
  u_extmenucustomize, u_extmenutoolbar, u_buttons_appli, u_buttons_speed, 
  U_CustomizeMenu, LazarusPackageIntf;

implementation

procedure Register;
begin
end;

initialization
  RegisterPackage('lazextbuttons', @Register);
end.

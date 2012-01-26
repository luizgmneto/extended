{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit lazfonctions; 

interface

uses
  unite_messages, fonctions_erreurs, fonctions_db, fonctions_images, 
  fonctions_init, fonctions_numedit, fonctions_proprietes, fonctions_string, 
  fonctions_variant, fonctions_web, fonctions_array, u_zconnection, 
  fonctions_dbcomponents, fonctions_version, fonctions_objects, 
  u_buttons_appli, u_regfwbuttons, fonctions_system, fonctions_languages, 
  U_About, LazarusPackageIntf;

implementation

procedure Register; 
begin
  RegisterUnit('u_regfwbuttons', @u_regfwbuttons.Register); 
end; 

initialization
  RegisterPackage('lazfonctions', @Register); 
end.

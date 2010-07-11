{ This file was automatically created by Lazarus. do not edit!
  This source is only used to compile and install the package.
 }

unit lazfonctions; 

interface

uses
    unite_messages, fonctions_erreurs, fonctions_db, fonctions_images, 
  fonctions_init, fonctions_numedit, fonctions_proprietes, fonctions_string, 
  fonctions_variant, fonctions_version, fonctions_web, fonctions_array, 
  u_zconnection, fonctions_dbcomponents, LazarusPackageIntf;

implementation

procedure Register; 
begin
end; 

initialization
  RegisterPackage('lazfonctions', @Register); 
end.

{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit lazfonctions;

interface

uses
  unite_messages, fonctions_erreurs, fonctions_db, fonctions_images, 
  fonctions_init, fonctions_numedit, fonctions_proprietes, fonctions_string, 
  fonctions_variant, fonctions_web, fonctions_array, fonctions_objects, 
  fonctions_system, fonctions_languages, fonctions_components, type_string, 
  fonctions_file, unit_messagescopy, fonctions_dbcomponents, fonctions_vtree, 
  fonctions_scaledpi, U_FormAdapt, fonctions_forms, u_stringsutf8, 
  LazarusPackageIntf;

implementation

procedure Register;
begin
end;

initialization
  RegisterPackage('lazfonctions', @Register);
end.

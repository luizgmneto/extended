{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit lazextcore;

interface

uses
  unite_messages, fonctions_proprietes, fonctions_string, fonctions_system, 
  fonctions_objects, fonctions_scaledpi, fonctions_erreurs, 
  fonctions_languages, u_extcomponent, fonctions_variant, fonctions_db, 
  LazarusPackageIntf;

implementation

procedure Register;
begin
end;

initialization
  RegisterPackage('lazextcore', @Register);
end.

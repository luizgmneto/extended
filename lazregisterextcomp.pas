{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit lazregisterextcomp; 

interface

uses
  u_regframeworkcomponents, LazarusPackageIntf;

implementation

procedure Register; 
begin
  RegisterUnit('u_regframeworkcomponents', @u_regframeworkcomponents.Register); 
end; 

initialization
  RegisterPackage('lazregisterextcomp', @Register); 
end.

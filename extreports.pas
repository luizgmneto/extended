{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit extreports;

interface

uses
  fonctions_reports, u_reportform, u_reports_rlcomponents, 
  u_reports_components, LazarusPackageIntf;

implementation

procedure Register;
begin
end;

initialization
  RegisterPackage('extreports', @Register);
end.

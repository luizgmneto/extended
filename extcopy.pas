{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit ExtCopy;

interface

uses
  u_traducefile, U_ExtFileCopy, u_extabscopy, u_extractfile, LazarusPackageIntf;

implementation

procedure Register;
begin
end;

initialization
  RegisterPackage('ExtCopy', @Register);
end.

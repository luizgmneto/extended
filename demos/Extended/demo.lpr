program demo;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  fonctions_startibx,
  fonctions_dbcomponents,
  fonctions_system,
  Interfaces, // this includes the LCL widgetset
  Forms, U_Components, LResources, DBFLaz, lazextcomponents,
  lazextbuttons, ibexpress;
begin
  {$I demo.lrs}
  Application.Initialize;
  gs_DefaultDatabase:=ExtractSubDir(fs_getAppDir)+'Exemple.fdb';
  GS_SUBDIR_IMAGES_SOFT:='..'+DirectorySeparator+'..'+DirectorySeparator+'Images'+DirectorySeparator;
  Application.CreateForm(TMyform, Myform);
  Application.Run;
end.


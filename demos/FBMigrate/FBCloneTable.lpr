program FBCloneTable;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  fonctions_startibx,
  fonctions_dbcomponents,
  fonctions_system,
  Interfaces, // this includes the LCL widgetset
  Forms, uniqueinstance_package, f_fbclonetable, lazextinit, extcopy,
  ibexpress;

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  gs_DefaultDatabase:=ExtractSubDir(fs_getAppDir)+'Exemple.fdb';
  GS_SUBDIR_IMAGES_SOFT:='..'+DirectorySeparator+'Images'+DirectorySeparator;
  Application.CreateForm(TForm1,Form1);
  Application.Run;
end.


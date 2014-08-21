program CopyAndImages;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  fonctions_system,
  Interfaces, // this includes the LCL widgetset
  Forms
  { you can add units after this }, U_FormCopy, u_aboutbox, lazextcopy;

begin
  Application.Initialize;
  GS_SUBDIR_IMAGES_SOFT:='..'+DirectorySeparator+'..'+DirectorySeparator+'Images'+DirectorySeparator;
  Application.CreateForm ( TF_Copier, F_Copier );
  Application.Run;
end.


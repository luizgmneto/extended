program ExtractFile;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  fonctions_system,
  Interfaces, // this includes the LCL widgetset
  Forms, sdflaz
  { you can add units after this }, U_FormCopy, u_aboutbox,
  lazextcomponents, lazextinit, lazextcopy, lazextcomponentsimg;

begin
  Application.Initialize;
  GS_SUBDIR_IMAGES_SOFT:='..'+DirectorySeparator+'..'+DirectorySeparator+'Images'+DirectorySeparator;
  Application.CreateForm(TF_Extract, F_Extract);
  Application.CreateForm ( tF_AboutBox, F_AboutBox );
  Application.Run;
end.


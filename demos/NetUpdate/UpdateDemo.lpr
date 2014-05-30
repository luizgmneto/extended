program UpdateDemo;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  fonctions_system,
  Interfaces, // this includes the LCL widgetset
  Forms, lnetvisual, u_formupdate, lazextbuttons
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  GS_SUBDIR_IMAGES_SOFT:='..'+DirectorySeparator+'..'+DirectorySeparator+'Images'+DirectorySeparator;
  Application.CreateForm(TF_Update, F_Update);
  Application.Run;
end.

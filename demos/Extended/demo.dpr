program demo;

uses
  {$IFDEF FPC}
  Interfaces,
  {$ENDIF}
  fonctions_startibx,
  fonctions_dbcomponents,
  fonctions_system,
  Forms,
  u_components in 'u_components.pas' {Myform: TF_FormMainIni};


begin
  Application.Initialize;
  gs_DefaultDatabase:=fs_getAppDir+'..\Exemple.fdb';
  GS_SUBDIR_IMAGES_SOFT:='..'+DirectorySeparator+'..\Images'+DirectorySeparator;
  Application.CreateForm(TMyform, Myform);
  Application.Run;
end.

program Groupview;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
{$IFDEF FPC}
  Interfaces, LCLType,
{$ENDIF}
  fonctions_startibx,
  fonctions_dbcomponents,
  fonctions_system,
  Forms,
  U_FormMainIni,
  U_Article in 'U_Article.pas' {F_Categ},
  U_DmArticles in 'U_DmArticles.pas' {M_Donn},
  U_Main in 'U_Main.pas' {M_Donn},
  U_TypeArticle in 'U_TypeArticle.pas' {M_Donn},
  U_ConstMessage in 'U_ConstMessage.pas' {M_Donn},
  U_Gamme in 'U_Gamme.pas' {F_Gamme},
  U_Caracteristique in 'U_Caracteristique.pas' {F_Caracteristique};
{$IFNDEF FPC}
{$R WindowsXP.res}
{$ENDIF}

begin
  Application.Initialize;
  gs_DefaultDatabase:=ExtractSubDir(fs_getAppDir)+'Exemple.fdb';
  GS_SUBDIR_IMAGES_SOFT:='..'+DirectorySeparator+'..'+DirectorySeparator+'Images'+DirectorySeparator;
  Application.Title := CST_APPLI_NAME;
  Application.CreateForm(TM_Article, M_Article);
  Application.CreateForm(TFMain, FMain);
  Application.Run;
end.

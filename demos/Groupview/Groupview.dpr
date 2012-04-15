program Groupview;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Forms, Interfaces,
  U_FormMainIni,
  U_FenetrePrincipale,
  U_Splash,
  fonctions_tableauframework,
  u_customframework,
  LCLType,
  U_FormDico,
  ZDataset,
  U_Article in 'U_Article.pas' {F_Categ},
  U_DmArticles in 'U_DmArticles.pas' {M_Donn},
  U_Main in 'U_Main.pas' {M_Donn},
  U_TypeArticle in 'U_TypeArticle.pas' {M_Donn},
  U_ConstMessage in 'U_ConstMessage.pas' {M_Donn},
  U_Gamme in 'U_Gamme.pas' {F_Gamme},
  U_Caracteristique in 'U_Caracteristique.pas' {F_Caracteristique};
{$IFNDEF FPC}
{$R *.res}
{$R WindowsXP.res}
{$ENDIF}

const CST_APPLI_NAME =  'Article';

begin
  Application.Initialize;
  Application.Title := CST_APPLI_NAME;

  F_SplashForm := TF_SplashForm.Create(Application);
  F_SplashForm.Label1.Caption := CST_APPLI_NAME;
  F_SplashForm.Label1.Width   := F_SplashForm.Width ;
  F_SplashForm.Show;   // Affichage de la fiche
  F_SplashForm.Update; // Force la fiche à se dessiner complètement

  Application.CreateForm(TM_Article, M_Article);
  Application.CreateForm(TFMain, FMain);
  Application.Run;
end.

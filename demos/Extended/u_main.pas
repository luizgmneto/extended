unit U_Main;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFDEF FPC}
  FileUtil,
{$ELSE}
  fonctions_version,
{$ENDIF}
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Menus, ExtCtrls,
  U_FormMainIni, U_OnFormInfoIni, U_Article, U_TypeArticle, U_Caracteristique,
  U_Gamme, U_DmArticles;

type

  { TFMain }

  TFMain = class(TF_FormMainIni)
    MainMenu: TMainMenu;
    MenuItem1: TMenuItem;
    {$IFDEF FPC}
    Panel: TPanel;
    {$ENDIF}
    muapropos: TMenuItem;
    MuArticle: TMenuItem;
    MuCaract: TMenuItem;
    muGamme: TMenuItem;
    MuTypeArticle: TMenuItem;
    OnFormInfoIni1: TOnFormInfoIni;
    procedure FormCreate(Sender: TObject);
    procedure muaproposClick(Sender: TObject);
    procedure MuArticleClick(Sender: TObject);
    procedure MuCaractClick(Sender: TObject);
    procedure muGammeClick(Sender: TObject);
    procedure MuTypeArticleClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  FMain: TFMain;

implementation

uses fonctions_forms;

{$IFNDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

{ TFMain }

procedure TFMain.muaproposClick(Sender: TObject);
begin
  {$IFNDEF FPC}
  fb_AfficheApropos(True, CST_APPLI_NAME,'0.9.9.0');
  {$ENDIF}
end;

procedure TFMain.FormCreate(Sender: TObject);
begin
  {$IFDEF FPC}
  BoxChilds:=Panel;
  {$ENDIF}
end;

procedure TFMain.MuArticleClick(Sender: TObject);
begin
  ffor_CreateChild(TF_Article,fsMDIChild,True,nil);
end;

procedure TFMain.MuCaractClick(Sender: TObject);
begin
  ffor_CreateChild(TF_Caracteristique,fsMDIChild,True,nil);

end;

procedure TFMain.muGammeClick(Sender: TObject);
begin
  ffor_CreateChild(TF_Gamme,fsMDIChild,True,nil);

end;

procedure TFMain.MuTypeArticleClick(Sender: TObject);
begin
  ffor_CreateChild(TF_TypeProduit,fsMDIChild,True,nil);

end;

end.


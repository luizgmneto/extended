unit U_Main;

{$mode delphi}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  U_FormMainIni, U_OnFormInfoIni, U_Article, U_TypeArticle, U_Caracteristique,
  U_Gamme, fonctions_version, U_DmArticles;

type

  { TFMain }

  TFMain = class(TF_FormMainIni)
    MainMenu: TMainMenu;
    MenuItem1: TMenuItem;
    muapropos: TMenuItem;
    MuArticle: TMenuItem;
    MuCaract: TMenuItem;
    muGamme: TMenuItem;
    MuTypeArticle: TMenuItem;
    OnFormInfoIni1: TOnFormInfoIni;
    ScrollBox: TScrollBox;
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

{$R *.lfm}

{ TFMain }

procedure TFMain.muaproposClick(Sender: TObject);
begin
  fb_AfficheApropos(True, CST_APPLI_NAME,'0.9.9.0');
end;

procedure TFMain.FormCreate(Sender: TObject);
begin
  BoxChilds := ScrollBox;
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


unit U_Main;

{$mode delphi}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  U_FormMainIni, U_Article, U_TypeArticle, U_Caracteristique,
  U_Gamme;

type

  { TFMain }

  TFMain = class(TF_FormMainIni)
    MainMenu: TMainMenu;
    MenuItem1: TMenuItem;
    MuArticle: TMenuItem;
    MuCaract: TMenuItem;
    muGamme: TMenuItem;
    MuTypeArticle: TMenuItem;
    procedure MenuItem1Click(Sender: TObject);
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

procedure TFMain.MenuItem1Click(Sender: TObject);
begin

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


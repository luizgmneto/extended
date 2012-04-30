///////////////////////////////////////////////////////////////////////
// Nom Unite: U_Categorie
// Description : Gestion des Catégorie
// Créé par Microcelt le 01/11/2004
// Modifié le 17/12/2004
///////////////////////////////////////////////////////////////////////
unit U_Article;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFNDEF FPC}
  RXSplit, Mask,
{$ELSE}
  MaskEdit, LCLType, ToolEdit,
{$ENDIF}
  Messages, Graphics, Controls, Classes, ExtCtrls,  Dialogs, DB, ZDataset,
  U_ExtDBNavigator, Buttons, Forms, DBCtrls, Grids,
  DBGrids, u_framework_dbcomponents, ComCtrls, StdCtrls, SysUtils,  TypInfo,
  Variants, StrUtils, U_OnFormInfoIni, CompSuperForm,
  JvXPButtons, U_ExtDBGrid,U_ConstMessage, U_DmArticles,
  u_framework_components, u_buttons_appli, U_ExtComboInsert, JvXPCore,
  JvExDBGrids, JvDBGrid, JvDBUltimGrid, JvExControls, JvDBLookup;

type

  { TF_Article }

  TF_Article = class(TSuperForm)
    cb_Categ: TExtDBComboInsert;
    cb_Categ1: TExtDBComboInsert;
    cb_Categ2: TExtDBComboInsert;
    lb_gamme: TFWLabel;
    lb_typart: TFWLabel;
    lb_libelcateg3: TFWLabel;
    nv_navigator: TExtDBNavigator;
    nv_saisie: TExtDBNavigator;
    pa_1: TPanel;
    pa_2: TPanel;
    pa_3: TPanel;
    pa_4: TPanel;
    pa_5: TPanel;
    SvgFormInfoIni: TOnFormInfoIni;
    spl_1: TSplitter;
    lb_codecateg: TFWLabel;
    lb_libelcateg: TFWLabel;
    ed_libelcateg: TFWDBEdit;
    ed_codecateg: TFWDBEdit;
    gd_categ: TExtDBGrid;
    Panel1: TPanel;
    Panel11: TPanel;
    bt_apercu: TFWPreview;
    Panel2: TPanel;
    bt_imprimer: TFWPrint;
    Panel5: TPanel;
    Panel6: TPanel;
    bt_fermer: TFWClose;
    procedure bt_fermerClick(Sender: TObject);
    procedure F_FormDicoCreate(Sender: TObject);

  private
    { Déclarations privées }

  public
    { Déclarations publiques }
  end;

var
  F_Article: TF_Article;

implementation

{$IFNDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

///////////////////////////////////////////////////////////////////////
// Procedure : bt_fermerClick
// Description : Fermeture de la fiche sur le click du bouton fermer
///////////////////////////////////////////////////////////////////////
procedure TF_Article.bt_fermerClick(Sender: TObject);
begin
  Close;
end;


///////////////////////////////////////////////////////////////////////
// Procedure : F_FormDicoCreate
// Description : à la création de la fiche, initialisation de variable
///////////////////////////////////////////////////////////////////////
procedure TF_Article.F_FormDicoCreate(Sender: TObject);
begin
  F_Article := Self;

  M_Article.ds_article .DataSet.Open;
  M_Article.ds_typearti.DataSet.Open;
  M_Article.ds_Carac   .DataSet.Open;
  M_Article.ds_Gamme   .DataSet.Open;

end;

end.


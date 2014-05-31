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
{$IFDEF FPC}
  MaskEdit, LCLType, ToolEdit,
{$ELSE}
  RXSplit, Mask, JvXPCore,
  JvExDBGrids, JvDBGrid, JvDBUltimGrid, JvExControls, JvDBLookup,
{$ENDIF}
  Messages, Graphics, Controls, Classes, ExtCtrls, Dialogs, DB,
  U_ExtDBNavigator, Buttons, Forms, DBCtrls, Grids,
  DBGrids, u_framework_dbcomponents, ComCtrls, StdCtrls, SysUtils, TypInfo,
  Variants, StrUtils, U_OnFormInfoIni, U_FormAdapt,
  JvXPButtons, U_ExtDBGrid, U_ConstMessage, U_DmArticles,
  u_framework_components, u_buttons_appli, U_ExtComboInsert, u_buttons_defs,
  u_reports_components;

type

  { TF_Article }

  TF_Article = class(TF_FormAdapt)
    cb_Categ: TExtDBComboInsert;
    cb_Categ1: TExtDBComboInsert;
    lb_gamme: TFWLabel;
    nv_navigator: TExtDBNavigator;
    nv_saisie: TExtDBNavigator;
    pa_1: TPanel;
    pa_2: TPanel;
    pa_3: TPanel;
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
    bt_imprimer: TFWPrintGrid;
    Panel5: TPanel;
    Panel6: TPanel;
    bt_fermer: TFWClose;
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
// Procedure : F_FormDicoCreate
// Description : à la création de la fiche, initialisation de variable
///////////////////////////////////////////////////////////////////////
procedure TF_Article.F_FormDicoCreate(Sender: TObject);
begin
  F_Article := Self;

  // combos
  M_Article.ds_typearti.DataSet.Open;
  M_Article.ds_Carac.DataSet.Open;
  M_Article.ds_Gamme.DataSet.Open;

  // main
  M_Article.ds_article.DataSet.Open;
end;


end.

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
  RbSplitter, UltimDBGrid, RXSplit, Mask,
{$ELSE}
  MaskEdit,
{$ENDIF}
  LCLType, Messages, Graphics, Controls, Classes, ExtCtrls,  Dialogs, DB, ZDataset,
  U_ExtDBNavigator, Buttons, Forms, DBCtrls, Grids,
  DBGrids, u_framework_dbcomponents, ComCtrls, StdCtrls, SysUtils,  TypInfo,
  Variants, StrUtils, ToolEdit, U_FormDico, U_OnFormInfoIni,
  JvXPButtons, U_ExtDBGrid,U_ConstMessage, U_DmArticles,
  u_framework_components, u_buttons_appli;

type
  TF_Article = class(TF_FormDico)
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
    procedure F_FormDicoCloseQuery(Sender: TObject;
      var CanClose: Boolean);
    procedure F_FormDicoCreate(Sender: TObject);

  private
    { Déclarations privées }

  public
    { Déclarations publiques }
  end;

var
  F_Article: TF_Article;

implementation

uses U_FenetrePrincipale, unite_variables, fonctions_tableauframework;

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
// Procedure : F_FormDicoCloseQuery
// Description : Fermeture de la fiche avec Contrôle de modification
//        des données de la fiche
///////////////////////////////////////////////////////////////////////
procedure TF_Article.F_FormDicoCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  if gb_SauverModifications then
    case MessageDlg(U_CST_9602, mtConfirmation, mbYesNoCancel, 0) of
      mrCancel: CanClose := False;
      mrYes: begin
               if (M_Article.ib_Article1.State in [dsInsert, dsEdit]) then
                 M_Article.IB_Article1.Post;
             end;
      mrNo: begin
              if (M_Article.IB_Article1.State in [dsInsert, dsEdit]) then
                M_Article.IB_Article1.Cancel;
         end;
    end;
end;

///////////////////////////////////////////////////////////////////////
// Procedure : F_FormDicoCreate
// Description : à la création de la fiche, initialisation de variable
///////////////////////////////////////////////////////////////////////
procedure TF_Article.F_FormDicoCreate(Sender: TObject);
begin
  F_Article := Self;

  if  ( gi_niveau_priv <  U_CST_CONTROLEGESTION ) Then
  Begin
    p_SetAllReadOnly ( Self, nil );
  End ;
end;

end.


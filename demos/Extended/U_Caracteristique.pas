///////////////////////////////////////////////////////////////////////
// Nom Unite: U_Famillevente
// Description : Gestion des familles de vente
// Créé par Microcelt le 11/08
// Modifié le 11/08
///////////////////////////////////////////////////////////////////////
unit U_Caracteristique;

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
  JvExComCtrls, JvListView,
{$ENDIF}
  Messages, Graphics, Controls, Classes, ExtCtrls,  Dialogs, DB,
  U_ExtDBNavigator, Buttons, Forms, DBCtrls, Grids,
  DBGrids, u_framework_dbcomponents, u_framework_components,
  ComCtrls, StdCtrls, SysUtils,  TypInfo,  Variants,
  StrUtils, U_OnFormInfoIni,  JvXPButtons,
  U_ExtDBGrid, U_ConstMessage, u_buttons_appli,
  U_GroupView, ImgList,fonctions_string,
  CompSuperForm, U_DBListView;

const CST_CARA_Clep = 'CARA_Clep' ; 

type

  { TF_Caracteristique }

  TF_Caracteristique = class(TSuperForm)
    nv_navigator: TExtDBNavigator;
    nv_saisie: TExtDBNavigator;
    lb_code: TFWLabel;
    lb_libelle: TFWLabel;
    ed_code: TFWDBEdit;
    ed_libelle: TFWDBEdit;
    pa_1: TPanel;
    pa_2: TPanel;
    pa_3: TPanel;
    pa_4: TPanel;
    pa_5: TPanel;
    pa_6: TPanel;
    Splitter1: TSplitter;
    SvgFormInfoIni: TOnFormInfoIni;
    spl_1: TSplitter;
    Panel3: TPanel;
    bt_fermer: TFWClose;
    Panel4: TPanel;
    gd_famillevente: TExtDBGrid;
    pc_Groupes: TPageControl;
    ts_ssfam: TTabSheet;
    Panel10: TPanel;
    Panel12: TPanel;
    Panel13: TPanel;
    Panel1: TPanel;
    Panel5: TPanel;
    bt_abandonner: TFWCancel;
    bt_enregistrer: TFWOK;
    Panel6: TPanel;
    lv_CaracIn: TDBGroupView;
    Panel2: TPanel;
    bt_in_item: TFWInSelect;
    bt_in_total: TFWInAll;
    bt_out_item: TFWOutSelect;
    bt_out_total: TFWOutAll;
    RbSplitter1: TSplitter;
    lv_transfert: TDBGroupView;
    im_images: TImageList;
    bt_TypePro: TJvXpButton;
    TabSheet1: TTabSheet;
    Panel7: TPanel;
    Panel18: TPanel;
    Panel19: TPanel;
    Panel20: TPanel;
    Panel21: TPanel;
    bt_AbanArt: TFWCancel;
    bt_EnrArt: TFWOK;
    bt_retour: TJvXpButton;
    Panel22: TPanel;
    RbSplitter3: TSplitter;
    Panel23: TPanel;
    lv_artin: TDBGroupView;
    Panel24: TPanel;
    bt_in_art: TFWInSelect;
    bt_in_totart: TFWInAll;
    bt_out_art: TFWOutSelect;
    bt_out_totart: TFWOutAll;
    lv_ArtOut: TDBGroupView;
    procedure bt_fermerClick(Sender: TObject);
    procedure F_FormDicoDataOnCancel(Sender: TObject);
    procedure bt_TypeProClick(Sender: TObject);
    procedure F_FormDicoCreate(Sender: TObject);

  private
    { Déclarations privées }

  public
    { Déclarations publiques }
  end;

var
  F_Caracteristique: TF_Caracteristique;

implementation

uses U_DmArticles, U_Main, U_TypeArticle;
{$IFNDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

procedure TF_Caracteristique.bt_fermerClick(Sender: TObject);
begin
  Close;
end;


///////////////////////////////////////////////////////////////////////
// Procedure :  F_FormDicoDataOnCancel
// Description : code executé au moment de l'annulation de modif ou d'insert
///////////////////////////////////////////////////////////////////////
procedure TF_Caracteristique.F_FormDicoDataOnCancel(Sender: TObject);
begin
  // on remet accessible les objets
  pc_Groupes.Enabled := TRUE;

  gd_famillevente.Enabled := TRUE;
  nv_navigator.Enabled := TRUE;
  nv_saisie.Enabled := TRUE;
  pa_6.Enabled := TRUE;
end;

procedure TF_Caracteristique.bt_TypeProClick(Sender: TObject);
begin
  FMain.ffor_CreateChild ( TF_TypeProduit, fsMDIChild, True, nil );
  if ( lv_CaracIn.Items.Count > 0 )
  and M_Article.IB_TypProduit.Active Then
    If assigned ( lv_CaracIn.Selected ) Then
      M_Article.IB_TypProduit.Locate ( 'TYPR_Clep', lv_CaracIn.Selected.Caption, [] )
    Else
      M_Article.IB_TypProduit.Locate ( 'TYPR_Clep', lv_CaracIn.Items [0].Caption, [] )
end;

procedure TF_Caracteristique.F_FormDicoCreate(Sender: TObject);
begin
  M_Article.ds_Carac.DataSet.Open;
end;

end.


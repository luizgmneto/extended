///////////////////////////////////////////////////////////////////////
// Nom Unite: U_Famillevente
// Description : Gestion des familles de vente
// Créé par Microcelt le 11/08
// Modifié le 11/08
///////////////////////////////////////////////////////////////////////
unit U_TypeArticle;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFDEF FPC}
  MaskEdit, LCLType, ToolEdit, ExtJvXPButtons,
{$ELSE}
  JvSplit, Mask, JvXPCore, JvXPButtons,
  JvExDBGrids, JvDBGrid, JvDBUltimGrid, JvExControls, JvExComCtrls,
  JvListView, JvDBLookup,
{$ENDIF}
  Messages, Graphics, Controls, Classes, ExtCtrls,  Dialogs, DB,
  U_ExtDBNavigator, Buttons, Forms, DBCtrls, Grids,
  DBGrids, u_framework_dbcomponents, u_framework_components,
  ComCtrls, StdCtrls, SysUtils,  TypInfo,  Variants,
  StrUtils, U_OnFormInfoIni,
  U_ExtDBGrid, U_ConstMessage, u_buttons_appli,
  U_FormAdapt,
  U_GroupView, ImgList,fonctions_string, U_DmArticles,
  U_DBListView, u_buttons_defs, u_reports_components;

type

  { TF_TypeProduit }

  TF_TypeProduit = class(TF_FormAdapt)
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
    ts_Gamme: TTabSheet;
    Panel10: TPanel;
    Panel13: TPanel;
    Panel1: TPanel;
    Panel5: TPanel;
    bt_abandonner: TFWCancel;
    bt_enregistrer: TFWOK;
    Panel6: TPanel;
    lsv_GammIn: TDBGroupView;
    Panel2: TPanel;
    bt_in_item: TFWInSelect;
    bt_in_total: TFWInAll;
    bt_out_item: TFWOutSelect;
    bt_out_total: TFWOutAll;
    RbSplitter1: TSplitter;
    lsv_GammOut: TDBGroupView;
    im_images: TImageList;
    ts_Caracteristique: TTabSheet;
    Panel7: TPanel;
    lsv_CaracIn: TDBGroupView;
    Panel8: TPanel;
    bt_in_carac: TFWInSelect;
    bt_in_total_carac: TFWInAll;
    bt_out_carac: TFWOutSelect;
    bt_out_total_carac: TFWOutAll;
    Panel9: TPanel;
    Panel14: TPanel;
    Panel15: TPanel;
    Panel16: TPanel;
    bt_AbandonCarac: TFWCancel;
    bt_EnrCarac: TFWOK;
    lsv_CaracOut: TDBGroupView;
    RbSplitter2: TSplitter;
    Panel17: TPanel;
    Panel11: TPanel;
    bt_Gamme: TJvXpButton;
    bt_Carac: TJvXpButton;
    TabSheet1: TTabSheet;
    Panel12: TPanel;
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
    bt_imprimer: TFWPrintGrid;
    procedure F_FormDicoDataOnCancel(Sender: TObject);
    procedure bt_GammeClick(Sender: TObject);
    procedure bt_CaracClick(Sender: TObject);
    procedure pc_GroupesChanging(Sender: TObject; var AllowChange: Boolean);
    procedure F_FormDicoCreate(Sender: TObject);

  private
    { Déclarations privées }

  public
    { Déclarations publiques }
  end;

var
  F_TypeProduit: TF_TypeProduit;

implementation

uses U_Main, U_Gamme, U_Caracteristique,fonctions_forms;

{$IFNDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}



///////////////////////////////////////////////////////////////////////
// Procedure :  F_FormDicoDataOnCancel
// Description : code executé au moment de l'annulation de modif ou d'insert
///////////////////////////////////////////////////////////////////////
procedure TF_TypeProduit.F_FormDicoDataOnCancel(Sender: TObject);
begin
  // on remet accessible les objets
  pc_Groupes.Enabled := True ;

  gd_famillevente.Enabled := TRUE;
  nv_navigator.Enabled := TRUE;
  nv_saisie.Enabled := TRUE;
  pa_6.Enabled := TRUE;
end;

procedure TF_TypeProduit.bt_GammeClick(Sender: TObject);
begin
  ffor_CreateUniqueChild ( TF_Gamme, fsMDIChild, True, nil );
  if ( lsv_GammIn.Items.Count > 0 )
  and M_Article.ib_gammarti.Active Then
    If assigned ( lsv_GammIn.Selected ) Then
      M_Article.ib_gammarti.Locate ( 'GAMM_Clep', lsv_GammIn.Selected.Caption, [] )
    Else
      M_Article.ib_gammarti.Locate ( 'GAMM_Clep', lsv_GammIn.Items [0].Caption, [] )

end;


procedure TF_TypeProduit.bt_CaracClick(Sender: TObject);
begin
  ffor_CreateUniqueChild ( TF_Caracteristique, fsMDIChild, True, nil );

  if ( lsv_CaracIn.Items.Count > 0 )
  and M_Article.IB_Carac.Active Then
    If assigned ( lsv_CaracIn.Selected ) Then
      M_Article.IB_Carac.Locate ( 'CARA_Clep', lsv_CaracIn.Selected.Caption, [] )
    Else
      M_Article.IB_Carac.Locate ( 'CARA_Clep', lsv_CaracIn.Items [0].Caption, [] )

end;

procedure TF_TypeProduit.pc_GroupesChanging(Sender: TObject;
  var AllowChange: Boolean);
var li_Choix : Integer ;
begin
  if  ( pc_Groupes.ActivePage = ts_Gamme )
  and ( bt_enregistrer.Enabled ) Then
    Begin
      li_Choix := MessageDlg ( U_CST_9602, mtConfirmation, [mbYes,mbNo,mbCancel], 0 );
      case li_Choix of
        mrYes : bt_enregistrer.OnClick ( bt_enregistrer );
        mrNo  : bt_abandonner .OnClick ( bt_abandonner  );
        mrCancel : AllowChange := False ;
      End;
    End;

  if  ( pc_Groupes.ActivePage = ts_Caracteristique )
  and ( bt_EnrCarac.Enabled ) Then
    Begin
      li_Choix := MessageDlg ( U_CST_9602, mtConfirmation, [mbYes,mbNo,mbCancel], 0 );
      case li_Choix of
        mrYes : bt_EnrCarac    .OnClick ( bt_EnrCarac     );
        mrNo  : bt_AbandonCarac.OnClick ( bt_AbandonCarac );
        mrCancel : AllowChange := False ;
      End;
    End;
end;

procedure TF_TypeProduit.F_FormDicoCreate(Sender: TObject);
begin
  F_TypeProduit:=Self;
  M_Article.ds_TypProduit.DataSet.Open;
end;

end.


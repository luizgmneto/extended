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
{$IFNDEF FPC}
  AdvListV, RbSplitter, RXSplit, Mask,
{$ELSE}
  MaskEdit,
{$ENDIF}
  LCLType, Messages, Graphics, Controls, Classes, ExtCtrls,  Dialogs, DB, ZDataset,
  U_ExtDBNavigator, Buttons, Forms, DBCtrls, Grids,
  DBGrids, u_framework_dbcomponents, u_framework_components,
  ComCtrls, StdCtrls, SysUtils,  TypInfo,  Variants,
  StrUtils, ToolEdit, U_FormDico, U_OnFormInfoIni,  JvXPButtons,
  U_ExtDBGrid,U_Donnees, U_ConstMessage, u_buttons_appli,
  U_GroupView, ImgList,fonctions_string;

const CST_CARA_Clep = 'CARA_Clep' ; 

type
  TF_Caracteristique = class(TF_FormDico)
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
    bt_AbanArt: TJvXpButton;
    bt_EnrArt: TFWOK;
    bt_retour: TJvXpButton;
    Panel22: TPanel;
    RbSplitter3: TSplitter;
    Panel23: TPanel;
    lv_artin: TDBGroupView;
    Panel24: TPanel;
    bt_in_art: TFWInSelect;
    bt_in_totart: TFWInSelect;
    bt_out_art: TFWOutSelect;
    bt_out_totart: TFWOutSelect;
    lv_ArtOut: TDBGroupView;
    ds_caraarti: TDataSource;
    zq_caraarti: TZQuery;
    zq_maj: TZQuery;
    procedure bt_fermerClick(Sender: TObject);
    procedure F_FormDicoCloseQuery(Sender: TObject;
      var CanClose: Boolean);
    procedure F_FormDicoDataOnSave(Sender: TObject);
    procedure F_FormDicoDataOnCancel(Sender: TObject);
    procedure bt_TypeProClick(Sender: TObject);
    procedure lv_artinDBOnRecorded(DataSet: TDataSet);
    procedure F_FormDicoCreate(Sender: TObject);

  private
    { Déclarations privées }

  public
    { Déclarations publiques }
  end;

var
  F_Caracteristique: TF_Caracteristique;

implementation

uses U_FenetrePrincipale, fonctions_Objets_Data , U_DmArticles, unite_variables,
     fonctions_tableauframework;
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
// Procedure : F_FormDicoCloseQuery
// Description : Controles effectués a la fermeture de la fenetre
///////////////////////////////////////////////////////////////////////
procedure TF_Caracteristique.F_FormDicoCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin

  // en cas de modification de la fiche, message d'alerte pour enregistrer ou non
  if gb_SauverModifications then
    Case MessageDlg(U_CST_9602, mtConfirmation, mbYesNoCancel, 0) of
      MrCancel:CanClose := false; // Cancel
      MrYes: Try   // yes
              if Sources[0].Datasource.DataSet.State in [dsEdit, dsInsert] then
              begin
                Sources[0].Datasource.DataSet.Post;
                CanClose := TRUE;
              end;

              if bt_enregistrer.Enabled then
                begin
                  bt_enregistrer.Click;
                  CanClose := TRUE;
                end;
             Except
              on e:exception do
                Begin
                  fcla_GereException ( e, Sources[0].Datasource.DataSet );
                  CanClose := False ;
                End ;
             end;
      MrNo:Try // No
            if Sources[0].Datasource.DataSet.State in [dsInsert,dsEdit] then
               Sources[0].Datasource.DataSet.Cancel;

            if bt_abandonner.Enabled then
              begin
                bt_abandonner.Click;
                CanClose := TRUE;
              end
             Except
              on e:exception do
                Begin
                  fcla_GereException ( e, Sources[0].Datasource.DataSet );
                End ;
             end;
    end;
end;

///////////////////////////////////////////////////////////////////////
// Procedure : F_FormDicoDataOnSave
// Description : Donne l'acces aux objets selon que l'adoquery est
//               en mode insertion ou modification
///////////////////////////////////////////////////////////////////////
procedure TF_Caracteristique.F_FormDicoDataOnSave(Sender: TObject);
begin
  if Sources[0].Datasource.DataSet.State in [dsInsert,dsEdit] then
  begin
      pc_Groupes.Enabled := FALSE;
  end;
  if bt_abandonner.Enabled then
    begin
      gd_famillevente.Enabled := FALSE;
      nv_navigator.Enabled := FALSE;
      nv_saisie.Enabled := FALSE;
      pa_6.Enabled := FALSE;
    end;
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
  ffor_ExecuteFonction ( 'M-18', True );
  if ( lv_CaracIn.Items.Count > 0 )
  and M_Article.IB_TypProduit.Active Then
    If assigned ( lv_CaracIn.Selected ) Then
      M_Article.IB_TypProduit.Locate ( 'TYPR_Clep', lv_CaracIn.Selected.Caption, [] )
    Else
      M_Article.IB_TypProduit.Locate ( 'TYPR_Clep', lv_CaracIn.Items [0].Caption, [] )
end;

procedure TF_Caracteristique.lv_artinDBOnRecorded(DataSet: TDataSet);
begin
IB_maj.ExecSQL;
end;

procedure TF_Caracteristique.F_FormDicoCreate(Sender: TObject);
begin
  if  ( gi_niveau_priv <  U_CST_CONTROLEGESTION ) Then
    Begin
      p_SetAllReadOnly ( Self, nil );
      bt_TypePro.Enabled := false;
      lv_CaracIn.Enabled  := false;
      lv_transfert.Enabled  := false;
      lv_artin.Enabled  := false;
      lv_ArtOut.Enabled  := false;
      bt_in_art.visible  := false;
      bt_out_art.visible  := false;
      bt_in_totart.visible  := false;
      bt_out_totart.visible  := false;
      bt_in_item.visible  := false;
      bt_out_item.visible  := false;
      bt_in_total.visible  := false;
      bt_out_total.visible  := false;
    End ;
end;

end.


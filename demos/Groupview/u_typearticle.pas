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
  U_GroupView, ImgList,fonctions_string ;

type

  { TF_TypeProduit }

  TF_TypeProduit = class(TF_FormDico)
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
    ds_typearti: TDataSource;
    zq_typearti: TZQuery;
    zq_maj: TZQuery;
    procedure bt_enregistrerClick(Sender: TObject);
    procedure bt_fermerClick(Sender: TObject);
    procedure F_FormDicoCloseQuery(Sender: TObject;
      var CanClose: Boolean);
    procedure F_FormDicoDataOnSave(Sender: TObject);
    procedure F_FormDicoDataOnCancel(Sender: TObject);
    procedure bt_GammeClick(Sender: TObject);
    procedure bt_CaracClick(Sender: TObject);
    procedure pc_GroupesChange(Sender: TObject);
    procedure pc_GroupesChanging(Sender: TObject; var AllowChange: Boolean);
    procedure lv_artinDBOnRecorded(DataSet: TDataSet);
    procedure F_FormDicoCreate(Sender: TObject);

  private
    { Déclarations privées }

  public
    { Déclarations publiques }
  end;

var
  F_TypeProduit: TF_TypeProduit;

implementation

uses U_FenetrePrincipale, fonctions_Objets_Data, U_DmArticles, unite_variables,
     fonctions_tableauframework;
{$IFNDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

procedure TF_TypeProduit.bt_fermerClick(Sender: TObject);
begin
  Close;
end;

procedure TF_TypeProduit.bt_enregistrerClick(Sender: TObject);
begin

end;

///////////////////////////////////////////////////////////////////////
// Procedure : F_FormDicoCloseQuery
// Description : Controles effectués a la fermeture de la fenetre
///////////////////////////////////////////////////////////////////////
procedure TF_TypeProduit.F_FormDicoCloseQuery(Sender: TObject;
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
              end;

              if bt_enregistrer.Enabled then
                begin
                  bt_enregistrer.Click;
                end;
              if bt_EnrCarac.Enabled then
                begin
                  bt_EnrCarac.Click;
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
              end;
            if bt_AbandonCarac.Enabled then
              begin
                bt_AbandonCarac.Click;
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
procedure TF_TypeProduit.F_FormDicoDataOnSave(Sender: TObject);
begin
  if Sources[0].Datasource.DataSet.State in [dsInsert,dsEdit] then
  begin
    pc_Groupes.Enabled := False ;
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
  ffor_ExecuteFonction ( 'M-17', True );
  if ( lsv_GammIn.Items.Count > 0 )
  and M_Article.IB_Gamme.Active Then
    If assigned ( lsv_GammIn.Selected ) Then
      M_Article.IB_Gamme.Locate ( 'GAMM_Clep', lsv_GammIn.Selected.Caption, [] )
    Else
      M_Article.IB_Gamme.Locate ( 'GAMM_Clep', lsv_GammIn.Items [0].Caption, [] )

end;


procedure TF_TypeProduit.bt_CaracClick(Sender: TObject);
begin
  ffor_ExecuteFonction ( 'M-19', True );
  if ( lsv_CaracIn.Items.Count > 0 )
  and M_Article.IB_Carac.Active Then
    If assigned ( lsv_CaracIn.Selected ) Then
      M_Article.IB_Carac.Locate ( 'CARA_Clep', lsv_CaracIn.Selected.Caption, [] )
    Else
      M_Article.IB_Carac.Locate ( 'CARA_Clep', lsv_CaracIn.Items [0].Caption, [] )

end;

procedure TF_TypeProduit.pc_GroupesChange(Sender: TObject);
begin

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

procedure TF_TypeProduit.lv_artinDBOnRecorded(DataSet: TDataSet);
begin
IB_maj.ExecSQL;
end;

procedure TF_TypeProduit.F_FormDicoCreate(Sender: TObject);
begin
  if  ( gi_niveau_priv <  U_CST_CONTROLEGESTION ) Then
    Begin
      p_SetAllReadOnly ( Self, nil );
      bt_Gamme.Enabled := false;
      lsv_GammIn.Enabled := false;
      lsv_GammOut.Enabled := false;
      bt_in_item.Enabled:=false;
      bt_out_item.Enabled:=false;
      bt_out_total.Enabled:=false;
      bt_in_total.Enabled:=false;
      bt_Carac.Enabled := false;
      lsv_CaracIn.Enabled := false;
      lsv_CaracOut.Enabled := false;
      bt_in_carac.Enabled:=false;
      bt_in_total_carac.Enabled:=false;
      bt_out_carac.Enabled:=false;
      bt_out_total_carac.Enabled:=false;
      lv_artin.Enabled := false;
      lv_ArtOut.Enabled := false;
      bt_in_art.Enabled:=false;
      bt_in_totart.Enabled:=false;
      bt_out_art.Enabled:=false;
      bt_out_totart.Enabled:=false;
    end;
end;

end.


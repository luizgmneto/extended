///////////////////////////////////////////////////////////////////////
// Nom Unite: U_Famillevente
// Description : Gestion des familles de vente
// Créé par Microcelt le 11/08
// Modifié le 11/08
///////////////////////////////////////////////////////////////////////
unit U_Gamme;

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
  U_GroupView, ImgList,fonctions_string, U_DmArticles, Menus ;

type
  TF_Gamme = class(TF_FormDico)
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
    lsv_TypesIn: TDBGroupView;
    Panel2: TPanel;
    bt_in_item: TFWInSelect;
    bt_in_total: TFWInAll;
    bt_out_item: TFWOutSelect;
    bt_out_total: TFWOutAll;
    RbSplitter1: TSplitter;
    lsv_TypesOut: TDBGroupView;
    im_images: TImageList;
    bt_TypePro: TJvXpButton;
    TabSheet1: TTabSheet;
    Panel7: TPanel;
    Panel8: TPanel;
    Panel9: TPanel;
    Panel11: TPanel;
    Panel14: TPanel;
    bt_Desaffecte: TJvXpButton;
    bt_EnrArt: TFWOK;
    bt_retour: TJvXpButton;
    ds_gammarti: TDataSource;
    zq_gammarti: TZQuery;
    Panel17: TPanel;
    Panel15: TPanel;
    lv_artin: TDBGroupView;
    Panel16: TPanel;
    bt_in_art: TFWInSelect;
    bt_in_totart: TFWInSelect;
    bt_out_art: TFWOutSelect;
    bt_out_totart: TFWOutSelect;
    lv_ArtOut: TDBGroupView;
    RbSplitter2: TSplitter;
    zq_maj: TZQuery;
    bt_AbanArt: TFWCAncel;
    zq_desaffecte: TZQuery;
    procedure bt_fermerClick(Sender: TObject);
    procedure F_FormDicoCloseQuery(Sender: TObject;
      var CanClose: Boolean);
    procedure F_FormDicoDataOnSave(Sender: TObject);
    procedure F_FormDicoDataOnCancel(Sender: TObject);
    procedure bt_TypeProClick(Sender: TObject);
    procedure F_FormDicoShow(Sender: TObject);
    procedure lv_artinDBOnRecorded(DataSet: TDataSet);
    procedure lv_artinClick(Sender: TObject);
    procedure lv_ArtOutClick(Sender: TObject);
    procedure bt_out_artClick(Sender: TObject);
    procedure bt_out_totartClick(Sender: TObject);
    procedure bt_DesaffecteClick(Sender: TObject);
    procedure F_FormDicoCreate(Sender: TObject);

  private
    { Déclarations privées }

  public
    { Déclarations publiques }
  end;

var
  F_Gamme: TF_Gamme;

implementation

uses U_FenetrePrincipale, fonctions_Objets_Data, unite_variables,
     fonctions_tableauframework;
{$IFNDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

procedure TF_Gamme.bt_fermerClick(Sender: TObject);
begin
  Close;
end;

///////////////////////////////////////////////////////////////////////
// Procedure : F_FormDicoCloseQuery
// Description : Controles effectués a la fermeture de la fenetre
///////////////////////////////////////////////////////////////////////
procedure TF_Gamme.F_FormDicoCloseQuery(Sender: TObject;
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
procedure TF_Gamme.F_FormDicoDataOnSave(Sender: TObject);
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
procedure TF_Gamme.F_FormDicoDataOnCancel(Sender: TObject);
begin
  // on remet accessible les objets
  pc_Groupes.Enabled := TRUE;

  gd_famillevente.Enabled := TRUE;
  nv_navigator.Enabled := TRUE;
  nv_saisie.Enabled := TRUE;
  pa_6.Enabled := TRUE;
end;

procedure TF_Gamme.bt_TypeProClick(Sender: TObject);
begin
  ffor_ExecuteFonction ( 'M-18', True );
  if ( lsv_TypesIn.Items.Count > 0 )
  and M_Article.IB_TypProduit.Active Then
    If assigned ( lsv_TypesIn.Selected ) Then
      M_Article.IB_TypProduit.Locate ( 'TYPR_Clep', lsv_TypesIn.Selected.Caption, [] )
    Else
      M_Article.IB_TypProduit.Locate ( 'TYPR_Clep', lsv_TypesIn.Items [0].Caption, [] )
end;

procedure TF_Gamme.F_FormDicoShow(Sender: TObject);
begin
//M_Donn.ds_Gamme.DataSet.Open;
//M_Donn.ds_article.DataSet.Open;
end;


procedure TF_Gamme.lv_artinClick(Sender: TObject);
begin
lv_artout.Selected := nil;
bt_Desaffecte.Enabled := (lv_artin.SelCount > 0);
end;

procedure TF_Gamme.lv_ArtOutClick(Sender: TObject);
begin
lv_artin.Selected := nil;
bt_Desaffecte.Enabled := False;
end;

procedure TF_Gamme.bt_out_artClick(Sender: TObject);
begin
bt_Desaffecte.Enabled := False;
end;

procedure TF_Gamme.bt_out_totartClick(Sender: TObject);
begin
bt_Desaffecte.Enabled := False;
end;

procedure TF_Gamme.bt_DesaffecteClick(Sender: TObject);
var
i : integer;
startitem : TlistItem;
codeart : string;
begin
startitem := lv_artin.Selected;
For i:= 0 to lv_artin.SelCount - 1 do
 with lv_artin do
  begin
  codeart := startitem.Caption;
  IB_desaffecte.Active := False;
  IB_desaffecte.Params.ParamByName('codeart').Value := trim(codeart);
  IB_desaffecte.ExecSQL;
  SelectNext( lv_artin, True, False );
  startitem:= Selected;
  end;
end;

procedure TF_Gamme.F_FormDicoCreate(Sender: TObject);
begin
  if gi_niveau_priv < U_CST_CONTROLEGESTION Then
    begin
      p_SetAllReadOnly ( Self, nil );
      bt_TypePro.Enabled := false;
      lsv_TypesIn.Enabled := false;
      lsv_TypesOut.Enabled := false;
      bt_in_item.visible:=false;
      bt_out_item.visible:=false;
      bt_out_total.visible:=false;
      bt_in_total.visible:=false;
      lv_artin.Enabled := false;
      lv_ArtOut.Enabled := false;
      bt_in_art.visible:=false;
      bt_out_art.visible:=false;
      bt_out_totart.visible:=false;
      bt_in_totart.visible:=false;
    end;
end;

end.



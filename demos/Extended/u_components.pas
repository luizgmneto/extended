unit U_Components;


{$I ..\..\DLCompilers.inc}
{$I ..\..\extends.inc}

interface

uses
{$IFDEF FPC}
  FileUtil, LResources, process, AsyncProcess, u_scrollclones,
{$ELSE}
  DBCtrls, JvExControls, JvDBLookup, JvExMask, JvSpin, JvExDBGrids, JvDBGrid, JvDBUltimGrid,
  JvExComCtrls, JvListView, Mask,  fonctions_version, JvDBSpinEdit, JvDateTimePicker,
{$ENDIF}
  Classes, SysUtils, db, Forms, Controls, Graphics, Dialogs, ExtCtrls, Grids,
  StdCtrls, U_OnFormInfoIni, U_ExtColorCombos, u_extdbgrid,
  u_extformatedits,
  U_ExtNumEdits, u_framework_components, U_ExtDBNavigator, U_DBListView,
  u_framework_dbcomponents, U_ExtDBPictCombo, u_extsearchedit, U_ExtComboInsert,
  DBGrids, Menus, u_extmenucustomize, ToolWin, IBDatabase, IBQuery, IBIntf,
  IBUpdateSQL, menutbar, ComCtrls, u_extmenutoolbar, U_ExtDBImage,
  U_ExtDBImageList, ImgList, ExtDlgs, IBCustomDataSet, U_ExtMapImageIndex,
  u_buttons_appli, u_reports_components, JvXPCore, JvXPButtons, u_buttons_defs,
  U_ExtPictCombo, U_ExtImage, u_extimagelist ;

type

  { TMyform }

  TMyform = class(TForm)
    ds_user: TDatasource;
    ds_dep: TDatasource;
    ds_dep2: TDatasource;
    FWDBSpinEdit: TFWDBSpinEdit;
    ExtDBComboInsert2: TExtDBComboInsert;
    ExtDBImage: TExtDBImage;
    ExtDBImageList: TExtDBImageList;
    ExtDBPictCombo: TExtDBPictCombo;
    FWClose1: TFWClose;
    FWPrint:  TFWPrintGrid;
    IBUpdateUser: TIBUpdateSQL;
    IBUpdateDepartem: TIBUpdateSQL;
    MapImages: TExtMapImages;
    FWLabel7: TFWLabel;
    FWLabel8: TFWLabel;
    FWLabel9: TFWLabel;
    FWSpinEdit: TFWSpinEdit;
    IBDatabase: TIBDatabase;
    IBDepartement: TIBQuery;
    IBDepSearch: TIBQuery;
    IBTransaction: TIBTransaction;
    IBUser: TIBQuery;
    DBListView: TDBListView;
    ExtDBNavigator: TExtDBNavigator;
    ImageResources: TImageList;
    mu_aide: TMenuItem;
    mu_apropos: TMenuItem;
    mu_file: TMenuItem;
    mu_MainMenu: TMainMenu;
    mu_MenuIni: TMainMenu;
    mu_ouvrir: TMenuItem;
    mu_quitter: TMenuItem;
    mu_sep1: TMenuItem;
    mu_sep2: TMenuItem;
    Noms: TExtDBGrid;
    OnFormInfoIni: TOnFormInfoIni;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel5: TPanel;
    Search2: TFWLabel;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    Prenom: TExtSearchDBEdit;
    Nom: TExtSearchDBEdit;
    FWDBEdit2: TExtSearchDBEdit;
    FWDBEdit1: TExtSearchDBEdit;
    FWLabel6: TFWLabel;
    FWLabel5: TFWLabel;
    FWLabel1: TFWLabel;
    ExtColorCombo: TExtColorCombo;
    ExtNumEdit1: TExtNumEdit;
    FWLabel2: TFWLabel;
    FWLabel3: TFWLabel;
    FWDateEdit1: TFWDateEdit;
    FWEdit: TFWEdit;
    FWLabel4: TFWLabel;
    Search: TFWLabel;
    ExtSearchEdit2: TExtSearchEdit;
    FWMemo: TFWMemo;
    mc_Customize : TExtMenuCustomize;
    OpenPictureDialog : TOpenPictureDialog;
    ExtMenuToolBar : TExtMenuToolBar;
    IBUserSearch: TIBQuery;
    ds_user_search: TDataSource;
    {$IFDEF FPC}
    ExtClonedPanel1: TExtClonedPanel;
    Process: TProcess;
    Splitter3: TSplitter;
    {$ENDIF}
    procedure ExtDBImageClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure IBDatabaseBeforeConnect(Sender: TObject);
    procedure mc_CustomizeMenuChange(Sender: TObject);
    procedure mu_aproposClick(Sender: TObject);
    procedure mu_quitterClick(Sender: TObject);
    procedure QuitterClick(Sender: TObject);
    procedure DbfNomsAfterPost(DataSet: TDataSet);
    procedure ExtMenuToolBarClickCustomize(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Myform: TMyform;

implementation
  
{$IFDEF FPC}
{$mode Delphi}
{$R *.lfm}
{$ELSE}
{$R *.DFM}
{$ENDIF}

uses fonctions_system,fonctions_dbcomponents;

procedure TMyform.DbfNomsAfterPost(DataSet: TDataSet);
begin
  DBListView.Refresh;
end;

procedure TMyform.ExtMenuToolBarClickCustomize(Sender: TObject);
begin
  mc_Customize.Click;
end;

procedure TMyForm.FormShow(Sender: TObject);
begin
  {$IFNDEF FPC}
  IBDatabase.Params.Add('lc_ctype=LATIN1');
  {$ENDIF}
  try
    IBDatabase.Connected := True;
    IBTransaction.Active := True;
    {$IFNDEF FPC}
    IBUser.UpdateObject:=IBUpdateUser;
    IBUserSearch.UpdateObject:=IBUpdateUser;
    IBDepartement.UpdateObject:=IBUpdateDepartem;
    IBDepSearch.UpdateObject:=IBUpdateDepartem;
    {$ENDIF}
    // On cherche ou crée le fichier CSV
    IBUser.Open;
    IBDepartement.Open;
  Except
    // Il s'agit d'une entrée/sortie donc on gère les exceptions
    on e:Exception do
      Begin
       ShowMessage ( 'Impossible d''ouvrir la connexion : ' + E.Message );
       Exit;
      end;
  end;
end;

procedure TMyform.IBDatabaseBeforeConnect(Sender: TObject);
var lstl_conf : TStringList;
begin
  IBDatabase.DatabaseName:=gs_DefaultDatabase;
  try
    lstl_conf := TStringList.Create;
    lstl_conf.Text := 'RootDirectory='+ExtractFileDir(Application.ExeName);
    lstl_conf.SaveToFile(ExtractFileDir(Application.ExeName)+DirectorySeparator+'firebird.conf');
  finally
    lstl_conf.Free;
  end;

end;

procedure TMyform.mc_CustomizeMenuChange(Sender: TObject);
begin
  ExtMenuToolBar.Menu := nil;
  ExtMenuToolBar.Menu := mc_Customize.MenuIni;

end;

procedure TMyform.mu_aproposClick(Sender: TObject);
begin
  {$IFNDEF FPC}
  fb_AfficheApropos ( True, 'Extended Demo', '' );
  {$ENDIF}
end;

procedure TMyform.mu_quitterClick(Sender: TObject);
begin
  Close;
end;

procedure TMyform.ExtDBImageClick(Sender: TObject);
begin
  if IBUser.CanModify
  and OpenPictureDialog.Execute Then
   Begin
     IBUser.Edit;
     ExtDBImage.LoadFromFile(OpenPictureDialog.FileName);
   end;
end;

procedure TMyform.QuitterClick(Sender: TObject);
begin
  Close;
end;

end.

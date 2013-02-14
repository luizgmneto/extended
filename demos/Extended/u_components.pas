unit U_Components;

{$IFDEF FPC}
{$mode Delphi}
{$R *.lfm}
{$ELSE}
{$R *.DFM}
{$ENDIF}

{$I ..\..\DLCompilers.inc}
{$I ..\..\extends.inc}

interface

uses
{$IFDEF FPC}
  FileUtil, LResources, process, AsyncProcess,
{$ELSE}
  DBCtrls, JvExControls, JvDBLookup, JvExMask, JvSpin, JvExDBGrids, JvDBGrid, JvDBUltimGrid,
  JvExComCtrls, JvListView, Mask,  fonctions_version, JvDateTimePicker,
{$ENDIF}
  Classes, SysUtils, db, Forms, Controls, Graphics, Dialogs, ExtCtrls, Grids,
  StdCtrls, U_OnFormInfoIni, U_ExtColorCombos, u_extdbgrid,
  U_ExtNumEdits, u_framework_components, U_ExtDBNavigator, U_DBListView,
  u_framework_dbcomponents, U_ExtDBPictCombo, u_extsearchedit, U_ExtComboInsert,
  DBGrids, Menus, u_extmenucustomize, ToolWin, IBDatabase, IBQuery, IBIntf,
  IBUpdateSQL, menutbar, ComCtrls, u_extmenutoolbar, U_ExtDBImage,
  U_ExtDBImageList, ImgList, ExtDlgs, IBCustomDataSet, U_ExtMapImageIndex,
  u_buttons_appli, u_reports_components, JvXPCore, JvXPButtons, u_buttons_defs,
  U_ExtPictCombo, U_ExtImage, u_scrollclones, u_extimagelist ;

type

  { TMyform }

  TMyform = class(TForm)
    ds_user: TDatasource;
    ds_dep: TDatasource;
    ds_dep2: TDatasource;
    ExtClonedPanel1: TExtClonedPanel;
    ExtDBImage: TExtDBImage;
    ExtDBImageList: TExtDBImageList;
    ExtDBPictCombo: TExtDBPictCombo;
    ExtMapImages: TExtMapImages;
    ExtMenuToolBar: TExtMenuToolBar;
    FWClose1: TFWClose;
    FWLabel10: TFWLabel;
    FWPrint:  TFWPrintGrid;
    IBUpdateUtilisateur: TIBUpdateSQL;
    IBUpdateDepartem: TIBUpdateSQL;
    MapImages: TExtMapImages;
    FWDBSpinEdit: TFWDBSpinEdit;
    FWLabel7: TFWLabel;
    FWLabel8: TFWLabel;
    FWLabel9: TFWLabel;
    FWSpinEdit: TFWSpinEdit;
    IBDatabase: TIBDatabase;
    IBDepartement: TIBQuery;
    IBDepSearch: TIBQuery;
    IBTransaction: TIBTransaction;
    IBUtilisateur: TIBQuery;
    DBListView: TDBListView;
    ExtDBNavigator: TExtDBNavigator;
    ImageResources: TImageList;
    mc_Customize: TExtMenuCustomize;
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
    Nom_: TFWEdit;
    OnFormInfoIni: TOnFormInfoIni;
    OpenPictureDialog: TOpenPictureDialog;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Prenom_: TFWEdit;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    Prenom: TFWDBEdit;
    Nom: TFWDBEdit;
    FWDBEdit2: TFWDBEdit;
    FWDBEdit1: TFWDBEdit;
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
    ExtSearchDBEdit2: TExtSearchDBEdit;
    ExtDBComboInsert2: TExtDBComboInsert;
    Search2: TFWLabel;
    FWMemo: TFWMemo;
    MenuIni: TMainMenu;
    Menu1: TMenuItem;
    Menu2: TMenuItem;
    Menu3: TMenuItem;
    Menu5: TMenuItem;
    Menu4: TMenuItem;
    Menu6: TMenuItem;
    {$IFDEF FPC}
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

uses fonctions_system;

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
  try
  IBDatabase.Connected := True;
//  IBTransaction.Active := True;
  // On cherche ou crée le fichier CSV
  IBUtilisateur.Open;
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
  IBDatabase.DatabaseName:=ExtractFileDir(Application.ExeName)+DirectorySeparator+'Exemple.fdb';
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

procedure p_setLibrary (var libname: string);
{$IFDEF FPC}
var AProcess : TProcess;
{$ENDIF}
Begin
  {$IFDEF WINDOWS}
  libname:= ExtractFileDir(Application.ExeName)+DirectorySeparator+'fbclient'+CST_EXTENSION_LIBRARY;
  if not FileExists(libname)
    Then libname:='fbclient'+CST_EXTENSION_LIBRARY;
  {$ELSE}
  libname:= ExtractFileDir(Application.ExeName)+DirectorySeparator+'libfbembed'+CST_EXTENSION_LIBRARY;
  if FileExists(libname) Then
    Begin
      AProcess := TProcess.Create(nil);
      with AProcess do
        try
          CommandLine:='sh "'+ExtractFileDir(Application.ExeName)+DirectorySeparator+'exec.sh"';
          Execute;
          Exit;

        finally
          AProcess.Free;
        end;
    end;
  if not FileExists(libname)
    Then libname:='/usr/lib/libfbembed.so.2.5';
  if not FileExists(libname)
    Then libname:='/usr/lib/libfbembed.so';
  if not FileExists(libname)
    Then libname:='/usr/lib/i386-linux-gnu/libfbembed.so.2.5';
  if not FileExists(libname)
    Then libname:='/usr/lib/x86_64-linux-gnu/libfbembed.so.2.5';
  {$ENDIF}
end;

procedure TMyform.ExtDBImageClick(Sender: TObject);
begin
  if IBUtilisateur.CanModify
  and OpenPictureDialog.Execute Then
   Begin
     IBUtilisateur.Edit;
     ExtDBImage.LoadFromFile(OpenPictureDialog.FileName);
   end;
end;

procedure TMyform.QuitterClick(Sender: TObject);
begin
  Close;
end;

{$IFDEF FPC}
initialization
  OnGetLibraryName:= TOnGetLibraryName( p_setLibrary);
{$ENDIF}
end.

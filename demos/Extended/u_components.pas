unit U_Components;

{$IFDEF FPC}
{$mode Delphi}
{$R *.lfm}
{$ELSE}
{$R *.DFM}
{$ENDIF}

interface

uses
{$IFDEF FPC}
  FileUtil, LResources,
{$ELSE}
  DBCtrls, TntDBCtrls, JvExControls, JvDBLookup, TntDBGrids,
  JvExComCtrls, JvListView, TntStdCtrls, Mask,
{$ENDIF}
  Classes, SysUtils, db, Forms, Controls, Graphics, Dialogs, ExtCtrls, Grids,
  StdCtrls, U_FormMainIni, U_OnFormInfoIni, U_ExtColorCombos, u_extdbgrid,
  U_ExtNumEdits, u_framework_components, U_ExtDBNavigator, U_DBListView,
  u_framework_dbcomponents, u_extsearchedit, U_ExtComboInsert, ZConnection,
  DBGrids, UIBDataSet, uib, Menus, u_extmenucustomize, ToolWin,
  menutbar, ComCtrls, u_extmenutoolbar, U_ExtDBImage, U_ExtDBImageList, ImgList,
  ExtDlgs, U_ExtPictCombo, U_ExtMapImageIndex, fonctions_version  ;

type

  { TMyform }

  TMyform = class(TF_FormMainIni)
    Datasource: TDatasource;
    Datasource2: TDatasource;
    Datasource3: TDatasource;
    ExtDBImage: TExtDBImage;
    ExtDBImageList: TExtDBImageList;
    ExtDBPictCombo: TExtDBPictCombo;
    ExtMapImages: TExtMapImages;
    ExtMenuToolBar: TExtMenuToolBar;
    MapImages: TExtMapImages;
    FWDBSpinEdit: TFWDBSpinEdit;
    FWLabel7: TFWLabel;
    FWLabel8: TFWLabel;
    FWLabel9: TFWLabel;
    FWSpinEdit: TFWSpinEdit;
    IBDatabase: TUIBDatabase;
    IBDepartement: TUIBDataSet;
    IBDepSearch: TUIBDataSet;
    IBTransaction: TUIBTransaction;
    IBUtilisateur: TUIBDataSet;
    DBListView: TDBListView;
    ExtDBNavigator1: TExtDBNavigator;
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
    OnFormInfoIni: TOnFormInfoIni;
    OpenPictureDialog: TOpenPictureDialog;
    Panel1: TPanel;
    Panel2: TPanel;
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
    procedure ExtDBImageClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
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
    constructor Create ( AOwner : TComponent ); override;
  end; 

var
  Myform: TMyform;

implementation

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
  Noms.Columns [ 0 ].SomeEdit := Nom;
  Noms.Columns [ 1 ].SomeEdit := Prenom;
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

procedure TMyform.mc_CustomizeMenuChange(Sender: TObject);
begin
  ExtMenuToolBar.Menu := nil;
  ExtMenuToolBar.Menu := mc_Customize.MenuIni;

end;

procedure TMyform.mu_aproposClick(Sender: TObject);
begin
  fb_AfficheApropos ( True, 'Extended Demo', '' );
end;

procedure TMyform.mu_quitterClick(Sender: TObject);
begin
  Close;
end;


procedure TMyform.FormCreate(Sender: TObject);
begin
  IBDatabase.DatabaseName:=ExtractFileDir(Application.ExeName)+DirectorySeparator+'Exemple.fdb';
  {$IFDEF WIN32}
  IBDatabase.DatabaseName:=ExtractFileDir(Application.ExeName)+DirectorySeparator+'Exemple.fdb';
  IBDatabase.LibraryName:= 'fbclient.dll';
  {$ENDIF}
  {$IFDEF WINDOWS}
  IBDatabase.DatabaseName:=ExtractFileDir(Application.ExeName)+DirectorySeparator+'Exemple.fdb';
  IBDatabase.LibraryName:= 'fbclient.dll';
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

constructor TMyform.Create(AOwner: TComponent);
begin
  AutoIni := True;
  inherited Create(AOwner);
end;

end.

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
  DBGrids, IBDatabase, IBCustomDataSet, Menus, u_extmenucustomize, ToolWin,
  menutbar, ComCtrls, u_extmenutoolbar, U_ExtDBImage, ImgList, ExtDlgs ;

type

  { TMyform }

  TMyform = class(TF_FormMainIni)
    Datasource: TDatasource;
    Datasource2: TDatasource;
    Datasource3: TDatasource;
    ExtDBImage: TExtDBImage;
    IBDatabase: TIBDatabase;
    IBDepartement: TIBDataSet;
    IBDepSearch: TIBDataSet;
    IBTransaction: TIBTransaction;
    IBUtilisateur: TIBDataSet;
    DBListView: TDBListView;
    ExtDBNavigator1: TExtDBNavigator;
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
    ExtMenuCustomize: TExtMenuCustomize;
    MenuIni: TMainMenu;
    MainMenu: TMainMenu;
    Menu1: TMenuItem;
    Menu2: TMenuItem;
    Menu3: TMenuItem;
    Menu5: TMenuItem;
    Menu4: TMenuItem;
    Menu6: TMenuItem;
    ExtMenuToolBar: TExtMenuToolBar;
    ImageList: TImageList;
    ImageListDisabled: TImageList;
    procedure ExtDBImageClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
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
  ExtMenuCustomize.Click;
end;

procedure TMyForm.FormShow(Sender: TObject);
begin
  Noms.Columns [ 0 ].SomeEdit := Nom;
  Noms.Columns [ 1 ].SomeEdit := Prenom;
  try
  IBDatabase.Connected := True;
  IBTransaction.Active := True;
  // On cherche ou crée le fichier CSV
  IBUtilisateur.Open;
  IBDepartement.Open;
  Except
    // Il s'agit d'une entrée/sortie donc on gère les exceptions
    on e:Exception do
      Begin
       ShowMessage ( 'Impossible d''ouvrir le fichier DBF : ' + E.Message );
       Exit;
      end;
  end;
end;

procedure TMyform.FormCreate(Sender: TObject);
begin
  {$IFDEF WIN32}
  IBDatabase.DatabaseName:=ExtractFileDir(Application.ExeName)+'\Exemple.fdb';
  {$ENDIF}
  {$IFDEF WINDOWS}
  IBDatabase.DatabaseName:=ExtractFileDir(Application.ExeName)+'\Exemple.fdb';
  {$ENDIF}
end;

procedure TMyform.ExtDBImageClick(Sender: TObject);
begin
  if OpenPictureDialog.Execute Then
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

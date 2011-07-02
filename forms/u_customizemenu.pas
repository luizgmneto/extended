unit U_CustomizeMenu;


/////////////////////////////////////////////////////////////////////////////////
//  U_CustomizeMenu
// Author : Matthieu GIROUX www.liberlog.fr
/////////////////////////////////////////////////////////////////////////////////

{$IFDEF FPC}
{$mode delphi}
{$R *.lfm}
{$ELSE}
{$R *.DFM}
{$ENDIF}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
{$IFDEF VERSIONS}
  fonctions_version,
{$ENDIF}
  ExtCtrls, u_buttons_appli, VirtualTrees, u_extmenucustomize, Menus;

{$IFDEF VERSIONS}
const
    gVer_F_CustomizeMenu : T_Version = ( Component : 'Fenêtre de F_CustomizeMenu' ;
       			                 FileUnit : 'U_CustomizeMenu' ;
       			                 Owner : 'Matthieu Giroux' ;
       			                 Comment : 'Fenêtre de personnalisation de menu.' ;
      			                 BugsStory : 'Version 0.9.0.0 : Adding Customized Menu.' + #13#10 ;
			                 UnitType : CST_TYPE_UNITE_FICHE ;
			                 Major : 0 ; Minor : 9 ; Release : 0 ; Build : 0 );
{$ENDIF}

type
  TMenuNode = Record
    Name, Title : String;
    ImageIndex : Integer;
  end;

  PCustMenuNode = ^TMenuNode ;

  { TF_CustomizeMenu }

  TF_CustomizeMenu = class(TForm)
    FWClose1: TFWClose;
    FWDelete: TFWDelete;
    FWInsert: TFWInsert;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    vt_MainMenu: TVirtualStringTree;
    procedure FormCreate(Sender: TObject);
    procedure vt_MainMenuClick(Sender: TObject);
    procedure vt_MainMenuGetImageIndex(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
      var Ghosted: Boolean; var ImageIndex: Integer);
    procedure vt_MainMenuInitNode(Sender: TBaseVirtualTree; ParentNode,
      Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure LoadMenuNode ( const AMenuItem : TMenuItem ; const ParentNode : PVirtualNode); virtual;
    procedure DoesMenuExists ( const AMenuItem : TMenuItem ; const MenuNameToFind : String); virtual;
  private
    gMenuItem : TMenuItem;
    FMenuCustomize : TExtMenuCustomize;
    { private declarations }
  public
    procedure DoClose(var CloseAction: TCloseAction); override;
    destructor Destroy; override;
  published
    property MenuCustomize : TExtMenuCustomize read FMenuCustomize  write FMenuCustomize ;
    { public declarations }
  end; 

var
  F_CustomizeMenu: TF_CustomizeMenu = nil;

implementation

const
 CST_MENUCUSTOMIZE_NOEUDS_RACINES = 1 ;

{ TF_CustomizeMenu }

procedure TF_CustomizeMenu.vt_MainMenuInitNode(Sender: TBaseVirtualTree;
  ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
var  CustomerRecord : PCustMenuNode;
begin
  CustomerRecord := Sender.GetNodeData(Node);
  Initialize(CustomerRecord^);
  CustomerRecord^.Name  := gMenuItem.Name ;
  CustomerRecord^.Title := gMenuItem.Caption ;
  CustomerRecord^.ImageIndex:=gMenuItem.ImageIndex;
end;

procedure TF_CustomizeMenu.LoadMenuNode(const AMenuItem: TMenuItem; const ParentNode : PVirtualNode );
var Lnod_ChildNode: PVirtualNode ;
  i : Integer;
begin
  gMenuItem := AMenuItem;
  Lnod_ChildNode := vt_MainMenu.AddChild ( ParentNode );
  vt_MainMenu.ValidateNode ( Lnod_ChildNode, False );
  for i := 0 to AMenuItem.Count -1  do
    Begin
      LoadMenuNode( AMenuItem [ i ], Lnod_ChildNode );
    End ;

end;

destructor TF_CustomizeMenu.Destroy;
begin
  inherited Destroy;
  F_CustomizeMenu := nil;
end;

procedure TF_CustomizeMenu.FormCreate(Sender: TObject);
begin
  if assigned ( MenuCustomize.MainMenu ) Then
    Begin
      vt_MainMenu.BeginUpdate ;
      vt_MainMenu.Clear;
      vt_MainMenu.NodeDataSize := Sizeof(TMenuNode)+1;
      vt_MainMenu.RootNodeCount := MenuCustomize.MainMenu.Items.Count ;
      vt_MainMenu.EndUpdate;
      vt_MainMenu.Images := MenuCustomize.MainMenu.Images;
      vt_MainMenu.BeginUpdate ;
      LoadMenuNode(MenuCustomize.MainMenu.Items, nil );
      vt_MainMenu.EndUpdate;
    end;
end;

procedure TF_CustomizeMenu.DoesMenuExists(const AMenuItem: TMenuItem; const MenuNameToFind : String);
var i : Integer;
begin
  with FWDelete do
    Begin
      Enabled := MenuNameToFind = AMenuItem.Name;
      if Enabled Then
        Exit;
      for i := 0 to AMenuItem.Count -1  do
        DoesMenuExists ( AMenuItem [ i ], MenuNameToFind );

    end;
end;

procedure TF_CustomizeMenu.vt_MainMenuClick(Sender: TObject);
var  CustomerRecord : PCustMenuNode;
begin
  if assigned ( vt_MainMenu.FocusedNode ) Then
  with vt_MainMenu, vt_MainMenu.FocusedNode^ do
    Begin
      FWInsert.Enabled:=ChildCount=0;
      FWDelete.Enabled:=ChildCount=0;
      if FWDelete.Enabled
      and assigned ( MenuCustomize.MenuIni ) Then
        Begin
          FWDelete.Enabled := False;
          CustomerRecord := GetNodeData( FocusedNode );
          DoesMenuExists( MenuCustomize.MenuIni.Items, CustomerRecord^.Name );

        end;
    end;
end;

procedure TF_CustomizeMenu.vt_MainMenuGetImageIndex(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
  var Ghosted: Boolean; var ImageIndex: Integer);
var  CustomerRecord : PCustMenuNode;
begin
  CustomerRecord := Sender.GetNodeData(Node);
  ImageIndex := CustomerRecord^.ImageIndex;
end;



procedure TF_CustomizeMenu.DoClose(var CloseAction: TCloseAction);
begin
  inherited DoClose(CloseAction);
  CloseAction:=caFree;
end;

{$IFDEF VERSIONS}
initialization
  p_ConcatVersion ( gVer_F_CustomizeMenu );
{$ENDIF}
end.


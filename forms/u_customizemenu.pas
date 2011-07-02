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
  ExtCtrls, u_buttons_appli, virtualtrees, u_extmenucustomize, Menus;

type
  TMenuNode = Record
    Name, Title : String;
  end;

  PCustMenuNode = ^TMenuNode ;

  { TF_CustomizeMenu }

  TF_CustomizeMenu = class(TForm)
    FWClose1: TFWClose;
    FWDelete1: TFWDelete;
    FWInsert1: TFWInsert;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    vt_MainMenu: TVirtualStringTree;
    procedure FormCreate(Sender: TObject);
    procedure vt_MainMenuInitNode(Sender: TBaseVirtualTree; ParentNode,
      Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure LoadMenuNode ( const AMenuItem : TMenuItem ; const ParentNode : PVirtualNode); virtual;
  private
    gNodeCount : Longint;
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
begin

end;

procedure TF_CustomizeMenu.LoadMenuNode(const AMenuItem: TMenuItem; const ParentNode : PVirtualNode );
var Lnod_ChildNode: PVirtualNode ;
    i : Integer;
begin
  inc ( gNodeCount, AMenuItem.Count );
    for i := 0 to AMenuItem.Count -1  do
    Begin
      Lnod_ChildNode := vt_MainMenu.AddChild ( ParentNode );
      vt_MainMenu.ValidateNode ( Lnod_ChildNode, False );
    End ;

end;

destructor TF_CustomizeMenu.Destroy;
begin
  inherited Destroy;
  F_CustomizeMenu := nil;
end;

procedure TF_CustomizeMenu.FormCreate(Sender: TObject);
begin
  vt_MainMenu.BeginUpdate ;
  vt_MainMenu.Clear;
  vt_MainMenu.NodeDataSize := Sizeof(TMenuNode);
  vt_MainMenu.RootNodeCount := MenuCustomize.MainMenu.Items.Count ;
  vt_MainMenu.EndUpdate;
end;



procedure TF_CustomizeMenu.DoClose(var CloseAction: TCloseAction);
begin
  inherited DoClose(CloseAction);
  CloseAction:=caFree;
end;

end.


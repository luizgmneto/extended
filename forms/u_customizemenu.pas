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
  ExtCtrls, u_buttons_appli, VirtualTrees;

type

  { TF_CustomizeMenu }

  TF_CustomizeMenu = class(TForm)
    FWClose1: TFWClose;
    FWDelete1: TFWDelete;
    FWInsert1: TFWInsert;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    VirtualStringTree1: TVirtualStringTree;
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  F_CustomizeMenu: TF_CustomizeMenu;

implementation

end.


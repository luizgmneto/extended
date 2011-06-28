unit u_extmenutoolbar;

{$IFDEF FPC}
{$mode Delphi}
{$ENDIF}

interface

uses
  Classes, SysUtils, ComCtrls, Menus, menutbar;

const MenuToolbar_TExtMenuToolBar = 'TExtMenuToolBar' ;

type

  { TExtMenuToolBar }

  TExtMenuToolBar = class(TMenuToolBar)
  private
    FMenuGet : TMainMenu;
    FButtonGet: TToolButton;
  protected
    procedure WindowGet ( AObject : TObject );
  public
    constructor Create(TheOwner: TComponent); override;
    procedure Loaded; override;
    destructor Destroy; override;
    property ButtonGet: TToolButton read FButtonGet write FButtonGet;
  published
    property MenuGet: TMainMenu read FMenuGet write FMenuGet;
  end;

implementation

uses unite_messages, Controls, Graphics, lresources;

{ TExtMenuToolBar }

procedure TExtMenuToolBar.WindowGet(AObject: TObject);
begin

end;

constructor TExtMenuToolBar.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);

end;

procedure TExtMenuToolBar.Loaded;
begin
  inherited Loaded;
  FButtonGet:= TToolButton.Create(Self);
  if Height > Width Then
    FButtonGet.Align:=alBottom
   Else
    FButtonGet.Align:=alRight;
  FButtonGet.Tag:= 1000;
  FButtonGet.Caption:= GS_TOOLBARMENU_Personnaliser;
  FButtonGet.OnClick:= WindowGet;
  if Images <> Nil Then
    Begin
      Images.AddLazarusResource(MenuToolbar_TExtMenuToolBar,clNone);
      FButtonGet.ImageIndex:= Images.Count - 1;
    end;
  FButtonGet.Style:= tbsButton;

end;

destructor TExtMenuToolBar.Destroy;
begin
  inherited Destroy;
end;

{$IFDEF FPC}
initialization
  {$I u_extmenutoolbar.lrs}
{$ENDIF}
end.


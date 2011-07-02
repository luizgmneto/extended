unit u_extmenutoolbar;

{$IFDEF FPC}
{$mode Delphi}
{$ENDIF}

interface

uses
  Classes, SysUtils, ComCtrls, Menus,
{$IFDEF VERSIONS}
  fonctions_version,
{$ENDIF}
  menutbar;

const MenuToolbar_TExtMenuToolBar = 'TExtMenuToolBar' ;
{$IFDEF VERSIONS}
    gVer_TExtMenuToolBar : T_Version = ( Component : 'Composant TExtMenuToolBar' ;
                                               FileUnit : 'u_extmenutoolbar' ;
                                               Owner : 'Matthieu Giroux' ;
                                               Comment : 'Barre de menu avec bouton de click.' ;
                                               BugsStory : '0.9.0.0 : Gestion de beaucoup de composants.';
                                               UnitType : 3 ;
                                               Major : 0 ; Minor : 9 ; Release : 0 ; Build : 0 );

{$ENDIF}

type
  IClickComponent = interface
     ['{61CEE27F-94C1-4D3D-B94F-FE57A3E207D7}'] // GUID nécessaire pour l'opération de cast
       procedure Click;
  End;
  { TExtMenuToolBar }

  TExtMenuToolBar = class(TMenuToolBar)
  private
    FMenuGet : TMenu;
    FButtonGet: TToolButton;
    FClickComponent : IClickComponent;
    FOnClick : TNotifyEvent;
  protected
    procedure SetButtonGetSize; virtual;
    procedure WindowGet ( AObject : TObject );
  public
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
    procedure Loaded; override;
    procedure Resize; override;
    property ButtonGet: TToolButton read FButtonGet;
  published
    property MenuGet: TMenu read FMenuGet write FMenuGet;
    property ClickComponent: IClickComponent read FClickComponent write FClickComponent;
    property OnClick: TNotifyEvent read FOnClick write FOnClick;
  end;

implementation

uses unite_messages, Controls, Graphics, lresources, Dialogs;

{ TExtMenuToolBar }

procedure TExtMenuToolBar.WindowGet(AObject: TObject);
begin
  if assigned ( FOnClick ) Then
    Begin
      FOnClick ( AObject );
      Exit;
    end;
  If assigned ( FClickComponent ) Then
    FClickComponent.Click;
end;

constructor TExtMenuToolBar.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  FButtonGet := nil;

end;

procedure TExtMenuToolBar.SetButtonGetSize;
begin
  if not assigned ( FButtonGet ) Then
    Exit;
  {$IFDEF FPC}
  BeginUpdateBounds;
  {$ENDIF}
  if Height > Width Then
    Begin
      FButtonGet.Align:=alBottom;
      FButtonGet.ClientHeight := Images.Height;
    end
   Else
    Begin
      FButtonGet.Align:=alRight;
      FButtonGet.ClientWidth := Images.Width;
    end;
  {$IFDEF FPC}
  EndUpdateBounds;
  {$ENDIF}
end;

procedure TExtMenuToolBar.Loaded;
begin
  inherited Loaded;
  FButtonGet:= TToolButton.Create(Self);
  FButtonGet.Tag:= 1000;
  FButtonGet.Caption:= GS_TOOLBARMENU_Personnaliser;
  FButtonGet.OnClick:= WindowGet;
  SetButtonGetSize;
  if Images <> Nil Then
    Begin
      Images.AddLazarusResource(MenuToolbar_TExtMenuToolBar,clNone);
      FButtonGet.ImageIndex:= Images.Count - 1;
    end;
  FButtonGet.Style:= tbsButton;
  FButtonGet.Visible:=True;

  ShowMessage ( IntToStr(FButtonGet.ClientHeight) + ' ' + IntToStr(FButtonGet.ClientWidth));

end;

procedure TExtMenuToolBar.Resize;
begin
  inherited Resize;
  SetButtonGetSize;
end;

destructor TExtMenuToolBar.Destroy;
begin
  inherited Destroy;
end;

initialization
{$IFDEF FPC}
  {$I u_extmenutoolbar.lrs}
{$ENDIF}
{$IFDEF VERSIONS}
  p_ConcatVersion ( gVer_TExtMenuToolBar );
{$ENDIF}
end.


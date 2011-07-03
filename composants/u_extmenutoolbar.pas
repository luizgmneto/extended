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
      MenuToolbar_TagCustomizeButton = 1000;
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
  { TExtMenuToolBar }

  TExtMenuToolBar = class(TMenuToolBar)
  private
    FButtonGet: TToolButton;
    FAutoDrawDisabled : Boolean;
    FOnClickCustomize : TNotifyEvent;
  protected
    procedure SetMenu(Value: TMainMenu); override;
    procedure SetButtonGetSize; virtual;
    procedure WindowGet ( AObject : TObject );
    procedure p_setAutoDrawDisabled ( AValue: Boolean ); virtual;
  public
    constructor Create(TheOwner: TComponent); override;
    property ButtonGet: TToolButton read FButtonGet;
  published
    property AutoDrawDisabled : Boolean read FAutoDrawDisabled write FAutoDrawDisabled default True;
    property OnClickCustomize: TNotifyEvent read FOnClickCustomize write FOnClickCustomize;
  end;

implementation

uses unite_messages, Controls, Graphics, lresources, Dialogs;

{ TExtMenuToolBar }

procedure TExtMenuToolBar.WindowGet(AObject: TObject);
begin
  if assigned ( FOnClickCustomize ) Then
    Begin
      FOnClickCustomize ( AObject );
      Exit;
    end;
end;

procedure TExtMenuToolBar.p_setAutoDrawDisabled(AValue: Boolean);
var lbmp_Bitmap : TBitmap;
     i : Integer;
begin
  FAutoDrawDisabled := AValue;
  if ( DisabledImages <> nil )
  and FAutoDrawDisabled Then
  Begin
    DisabledImages.Clear;
    lbmp_Bitmap := TBitmap.Create;
    for i := 0 to Images.Count -1 do
      Begin
        Images.GetBitmap( I, lbmp_Bitmap);
        lbmp_Bitmap.Monochrome:=True;
        DisabledImages.AddMasked(lbmp_Bitmap,lbmp_Bitmap.Canvas.Pixels[lbmp_Bitmap.Width-1, lbmp_Bitmap.Height -1]);
      End;
    {$IFNDEF FPC}
    lbmp_Bitmap.Dormant;
    {$ENDIF}
    lbmp_Bitmap.Free;
  end;
end;

constructor TExtMenuToolBar.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  FButtonGet := nil;
  FAutoDrawDisabled := True;
end;

procedure TExtMenuToolBar.SetMenu(Value: TMainMenu);
begin
  inherited SetMenu(Value);
  if Value <> nil Then
    Begin
      FButtonGet:= TToolButton.Create(Self);
      FButtonGet.Tag:= MenuToolbar_TagCustomizeButton;
      FButtonGet.Caption:= GS_TOOLBARMENU_Personnaliser;
      FButtonGet.OnClick:= WindowGet;
      if Images <> Nil Then
        Begin
          Images.AddLazarusResource(MenuToolbar_TExtMenuToolBar,clNone);
          FButtonGet.ImageIndex:= Images.Count - 1;
          SetButtonGetSize;
        end;
      FButtonGet.Style:= tbsButton;
      FButtonGet.Visible:=True;
      FButtonGet.Parent := Self;
    end
   Else
    FButtonGet := nil;
  p_setAutoDrawDisabled ( FAutoDrawDisabled );
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
    end
   Else
    Begin
      FButtonGet.Align:=alRight;
    end;
  {$IFDEF FPC}
  EndUpdateBounds;
  {$ENDIF}
end;

initialization
{$IFDEF FPC}
  {$I u_extmenutoolbar.lrs}
{$ENDIF}
{$IFDEF VERSIONS}
  p_ConcatVersion ( gVer_TExtMenuToolBar );
{$ENDIF}
end.


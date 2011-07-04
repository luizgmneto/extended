unit u_extmenutoolbar;

{$IFDEF FPC}
{$mode Delphi}
{$ELSE}
{$R *.DCR}
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
    procedure SetMenu(Value: TMenu); override;
    procedure WindowGet ( AObject : TObject );
    procedure p_setAutoDrawDisabled ( AValue: Boolean ); virtual;
  public
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
    procedure Loaded ; override;
    property ButtonGet: TToolButton read FButtonGet;
  published
    property AutoDrawDisabled : Boolean read FAutoDrawDisabled write FAutoDrawDisabled default True;
    property OnClickCustomize: TNotifyEvent read FOnClickCustomize write FOnClickCustomize;
  end;

{$IFNDEF FPC}
var ExtMenuToolbar_ResInstance             : THandle      = 0;
{$ENDIF}

implementation

uses unite_messages, Controls, Graphics,
{$IFDEF FPC}
     LResources,
{$ENDIF}
     Dialogs;

{ TExtMenuToolBar }

procedure TExtMenuToolBar.WindowGet(AObject: TObject);
begin
  if assigned ( FOnClickCustomize ) Then
    FOnClickCustomize ( AObject );
end;

procedure TExtMenuToolBar.Loaded;
begin
  inherited;
  p_setAutoDrawDisabled ( FAutoDrawDisabled );
end;

procedure TExtMenuToolBar.p_setAutoDrawDisabled(AValue: Boolean);
var lbmp_Bitmap : TBitmap;
     i : Integer;
begin
  FAutoDrawDisabled := AValue;
  if  ( DisabledImages <> nil )
  and ( Images <> nil )
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

destructor TExtMenuToolBar.Destroy;
begin
  inherited Destroy;
  if assigned ( FButtonGet ) Then
    FButtonGet.Free;
end;

procedure TExtMenuToolBar.SetMenu(Value: TMenu);
{$IFNDEF FPC}
var lbmp_Bitmap : TBitmap;
{$ENDIF}
begin
  if  not ( csDesigning in ComponentState )
  and assigned ( FButtonGet ) Then
    Begin
      FButtonGet.Parent := nil;
    end;
  inherited SetMenu(Value);
  if not ( csDesigning in ComponentState ) Then
    Begin
      if not assigned ( FButtonGet ) Then
        Begin
          FButtonGet:= TToolButton.Create(nil);
          FButtonGet.Name := 'Button_' + Name + '_Customize' ;
          FButtonGet.Tag:= MenuToolbar_TagCustomizeButton;
          FButtonGet.Caption:= GS_TOOLBARMENU_Personnaliser;
          FButtonGet.OnClick:= WindowGet;
          if Images <> Nil Then
            Begin
      {$IFDEF FPC}
              Images.AddLazarusResource(MenuToolbar_TExtMenuToolBar,clNone);
      {$ELSE}
              if ( ExtMenuToolbar_ResInstance = 0 ) Then
                ExtMenuToolbar_ResInstance:= FindResourceHInstance(HInstance);
              lbmp_Bitmap := TBitmap.Create;
              lbmp_Bitmap.LoadFromResourceName(ExtMenuToolbar_ResInstance, MenuToolbar_TExtMenuToolBar );
              Images.AddMasked(lbmp_Bitmap,lbmp_Bitmap.Canvas.Pixels [ lbmp_Bitmap.Width - 1, lbmp_Bitmap.Height - 1 ]);
              lbmp_Bitmap.Dormant;
              lbmp_Bitmap.Free;
      {$ENDIF}
              FButtonGet.ImageIndex:= Images.Count - 1;
            end;
          FButtonGet.Style:= tbsButton;
          FButtonGet.Visible:=True;
        end;
      FButtonGet.Parent := Self;
    end;
  p_setAutoDrawDisabled ( FAutoDrawDisabled );
end;

initialization
{$IFDEF FPC}
  {$I u_extmenutoolbar.lrs}
{$ENDIF}
{$IFDEF VERSIONS}
  p_ConcatVersion ( gVer_TExtMenuToolBar );
{$ENDIF}
end.


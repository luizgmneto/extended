unit fonctions_scaledpi;

interface

{$I ..\DLCompilers.inc}
{$I ..\extends.inc}

{$IFDEF FPC}
{$mode Delphi}
{$ENDIF}

uses
  Forms, Graphics,
  {$IFDEF VERSIONS}
    fonctions_version,
  {$ENDIF}
  Controls, Classes;

Const
  FromDPI=8;//Screen.MenuFont.Size de la conception

  {$IFDEF VERSIONS}
  gver_fonctions_scaledpi : T_Version = ( Component : 'Fonctions d''adaptation de fontes' ;
                                     FileUnit : 'fonctions_scaledpi' ;
              			                 Owner : 'Matthieu Giroux' ;
              			                 Comment : 'Adapt forms to system.' + #13#10 +
                                                           'Il ne doit pas y avoir de lien vers les objets à créer.' ;
              			                 BugsStory :  'Version 0.9.0.0 : To test.';
              			                 UnitType : 1 ;
              			                 Major : 0 ; Minor : 9 ; Release : 0 ; Build : 0 );

{$ENDIF}

procedure p_addtoSoftware;
procedure HighDPI;
procedure ScaleDPI(const Control: TControl;const ANewEchelle:Extended);
function Scale(const Valeur:Integer;const ANewEchelle:Extended):Integer;
procedure ScaleForm(const Control: TCustomForm;const ANewEchelle:Extended);
function fb_CalculateScale ( var AEchelle : Extended ):Boolean;


type

  { TDMAdaptForms }

  TDMAdaptForms = class(TDataModule)
    procedure ApplicationActivate ( Sender : TObject );
  private
    { private declarations }
  published
    { published declarations }
    constructor Create ( AOwner : TComponent ); override;

  end;

var
  gb_AdaptFormsToOS : Boolean = True;

implementation

uses fonctions_proprietes;

var ge_OldApplicationActivate : TNotifyEvent = nil;
    DMAdaptForms: TDMAdaptForms = nil;
    ge_FontsScale:Extended=1;

procedure TDMAdaptForms.ApplicationActivate ( Sender : TObject );
Begin
  HighDPI;
end;

constructor TDMAdaptForms.Create(AOwner: TComponent);
begin
  Try
    GlobalNameSpace.BeginWrite;

    {$IFDEF FPC}
    CreateNew(AOwner, 1 );
    {$ELSE}
    CreateNew(AOwner);
    {$ENDIF}
  Finally
    GlobalNameSpace.EndWrite;
  End

end;

function fb_CalculateScale ( var AEchelle : Extended ):Boolean;
var
  LNewEchelle : Extended;
Begin
  if not gb_AdaptFormsToOS Then
  Begin
    Result := False;
    Exit;
  end;
  if Screen.MenuFont.Size = 0
    Then LNewEchelle:=FromDPI
    Else LNewEchelle:=Screen.MenuFont.Size;

  LNewEchelle:=LNewEchelle/FromDPI;
  Result := LNewEchelle<>LNewEchelle;
  AEchelle:=LNewEchelle;
End;

procedure HighDPI;
var
  i: integer;
begin
  if fb_CalculateScale ( ge_FontsScale ) then
    for i:=0 to Screen.FormCount-1 do
      ScaleForm(Screen.Forms[i],ge_FontsScale);
end;
 
function Scale(const Valeur:Integer;const ANewEchelle:Extended):Integer;
Var
  Ext:Extended;
begin
  Ext:=Valeur*ANewEchelle;
  if Ext>=0 then
    Result:=Trunc(Ext+0.5)
  else
    Result:=Trunc(Ext-0.5);
end;

procedure ScaleForm(const Control: TCustomForm;const ANewEchelle:Extended);
var
  i: integer;
Begin
  with Control do
   Begin
     {$IFDEF FPC}BeginUpdateBounds;{$ENDIF}

     if WindowState=wsNormal Then
       ScaleDPI(Control,ANewEchelle)
      Else
        Begin
          Font.Size:=Scale(Font.Size,ANewEchelle);
          for i:=0 to Control.ControlCount-1 do
            ScaleDPI(Control.Controls[i],ANewEchelle);
        end;
     {$IFDEF FPC}EndUpdateBounds;{$ENDIF}

   End;
end;

procedure ScaleFont(const Control: TControl;const ANewEchelle:Extended);
var  AFont : TFont;
Begin
  if fb_getComponentBoolProperty(Control,'ParentFont', True ) Then
   Begin
    {$IFDEF FPC}
    AFont := Control.Font;
    {$ELSE}
    AFont := TFont ( fobj_getComponentObjectProperty ( Control, 'Font' ));
    {$ENDIF}
    if assigned ( AFont ) then
      AFont.Size:=Scale(AFont.Size,ANewEchelle);
   end;
end;

procedure ScaleDPI(const Control: TControl;const ANewEchelle:Extended);
var
  i: integer;
  WinControl: TWinControl;
begin
  with Control do
  begin
    with Constraints do
    begin
      MaxHeight:=Scale(MaxHeight,ANewEchelle);
      MaxWidth:=Scale(MaxWidth,ANewEchelle);
      MinHeight:=Scale(MinHeight,ANewEchelle);
      MinWidth:=Scale(MinWidth,ANewEchelle);
    end;

    if Align<>alClient then
    begin
      if not (Align in [alTop,alBottom]) then
      begin
        if (not (akRight in Anchors))and(Align<>alRight) then
          Left:=Scale(Left,ANewEchelle);
        if ([akRight,akLeft]*Anchors<>[akRight,akLeft]) then
          Width:=Scale(Width,ANewEchelle);
      end;
      if not (Align in [alLeft,alRight])then
      begin
        if (not (akBottom in Anchors))and(Align<>alBottom) then
          Top:=Scale(Top,ANewEchelle);
        if [akBottom,akTop]*Anchors<>[akBottom,akTop] then
          Height:=Scale(Height,ANewEchelle);
      end;
    end;
    ScaleFont(Control,ANewEchelle);
  end;

  if Control is TWinControl then
  begin
    WinControl:=TWinControl(Control);
    for i:=0 to WinControl.ControlCount-1 do
      ScaleDPI(WinControl.Controls[i],ANewEchelle);
  end;
end;

procedure p_addtoSoftware;
Begin
  ge_OldApplicationActivate := Application.OnActivate;
  if DMAdaptForms = nil Then
    DMAdaptForms := TDMAdaptForms.Create(Application);
  Application.OnActivate    := TNotifyEvent ( fmet_getComponentMethodProperty ( DMAdaptForms, 'ApplicationActivate' ) );
end;

initialization
{$IFDEF VERSIONS}
  p_ConcatVersion ( gver_fonctions_scaledpi );
{$ENDIF}
end.

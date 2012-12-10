unit fonctions_scaledpi;

interface
 
uses
  Forms, Graphics,
  {$IFDEF VERSIONS}
    fonctions_version,
  {$ENDIF}
  Controls;

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

procedure HighDPI;
procedure ScaleDPI(const Control: TControl;const ANewEchelle,AEchelle:Extended);
function Scale(const Valeur:Integer;const ANewEchelle,AEchelle:Extended):Integer;
procedure ScaleForm(const Control: TCustomForm;const ANewEchelle,AEchelle:Extended);

implementation

uses fonctions_proprietes;

Var
  Echelle:Extended=1;

 
procedure HighDPI;
var
  i: integer;
  NewEchelle : Extended;
begin
  NewEchelle:=Screen.MenuFont.Size/FromDPI;
  if Echelle=NewEchelle then
    exit;
 
  for i:=0 to Screen.FormCount-1 do
    ScaleForm(Screen.Forms[i],NewEchelle,Echelle);
  Echelle:=NewEchelle;
end;
 
function Scale(const Valeur:Integer;const ANewEchelle,AEchelle:Extended):Integer;
Var
  Ext:Extended;
begin
  Ext:=Valeur*ANewEchelle/AEchelle;
  if Ext>=0 then
    Result:=Trunc(Ext+0.5)
  else
    Result:=Trunc(Ext-0.5);
end;

procedure ScaleForm(const Control: TCustomForm;const ANewEchelle,AEchelle:Extended);
var
  i: integer;
Begin
  with Control do
   Begin
     {$IFDEF FPC}BeginUpdateBounds;{$ENDIF}

     if WindowState=wsNormal Then
       ScaleDPI(Control,ANewEchelle,AEchelle)
      Else
        Begin
          Font.Size:=Scale(Font.Size,ANewEchelle,AEchelle);
          for i:=0 to Control.ControlCount-1 do
            ScaleDPI(Control.Controls[i],ANewEchelle,AEchelle);
        end;
     {$IFDEF FPC}EndUpdateBounds;{$ENDIF}

   End;
end;

procedure ScaleDPI(const Control: TControl;const ANewEchelle,AEchelle:Extended);
var
  i: integer;
  WinControl: TWinControl;
  AFont : TFont;
begin
  with Control do
  begin
    with Constraints do
    begin
      MaxHeight:=Scale(MaxHeight,ANewEchelle,AEchelle);
      MaxWidth:=Scale(MaxWidth,ANewEchelle,AEchelle);
      MinHeight:=Scale(MinHeight,ANewEchelle,AEchelle);
      MinWidth:=Scale(MinWidth,ANewEchelle,AEchelle);
    end;

    if Align<>alClient then
    begin
      if not (Align in [alTop,alBottom]) then
      begin
        if (not (akRight in Anchors))and(Align<>alRight) then
          Left:=Scale(Left,ANewEchelle,AEchelle);
        if ([akRight,akLeft]*Anchors<>[akRight,akLeft]) then
          Width:=Scale(Width,ANewEchelle,AEchelle);
      end;
      if not (Align in [alLeft,alRight])then
      begin
        if (not (akBottom in Anchors))and(Align<>alBottom) then
          Top:=Scale(Top,ANewEchelle,AEchelle);
        if [akBottom,akTop]*Anchors<>[akBottom,akTop] then
          Height:=Scale(Height,ANewEchelle,AEchelle);
      end;
    end;
    AFont := TFont ( fobj_getComponentObjectProperty ( Control, 'Font' ));
    if assigned ( AFont ) then
      AFont.Size:=Scale(AFont.Size,ANewEchelle,AEchelle);
  end;

  if Control is TWinControl then
  begin
    WinControl:=TWinControl(Control);
    for i:=0 to WinControl.ControlCount-1 do
      ScaleDPI(WinControl.Controls[i],ANewEchelle,AEchelle);
  end;
end;

initialization
{$IFDEF VERSIONS}
  p_ConcatVersion ( gver_fonctions_scaledpi );
{$ENDIF}
 
end.

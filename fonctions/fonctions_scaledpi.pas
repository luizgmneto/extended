unit uscaledpi;

interface
 
uses
  Forms, Graphics, Controls;

Type
  THackControl=Class(TControl);

procedure HighDPI;
procedure ScaleDPI(Control: TControl);
function Scale(Valeur:Integer):Integer;

implementation

Const
  FromDPI=8;//Screen.MenuFont.Size de la conception

Var
  Echelle:Extended;

 
procedure HighDPI;
var
  i: integer;
begin
  if Echelle=1 then
    exit;
 
  for i:=0 to Screen.FormCount-1 do
    ScaleDPI(Screen.Forms[i]);
end;
 
function Scale(Valeur:Integer):Integer;
Var
  Ext:Extended;
begin
  Ext:=Valeur*Echelle;
  if Ext>=0 then
    Result:=Trunc(Ext+0.5)
  else
    Result:=Trunc(Ext-0.5);
end;

procedure ScaleDPI(Control: TControl);
var
  i: integer;
  WinControl: TWinControl;
begin
  if Echelle=1 then
    exit;
 
  with Control do
  begin
    with Constraints do
    begin
      MaxHeight:=Scale(MaxHeight);
      MaxWidth:=Scale(MaxWidth);
      MinHeight:=Scale(MinHeight);
      MinWidth:=Scale(MinWidth);
    end;

    if Align<>alClient then
    begin
      if (Align<>alTop)and(Align<>alBottom) then
      begin
        if (not (akRight in Anchors))and(Align<>alRight) then
          Left:=Scale(Left);
        if (not (akLeft in Anchors))and(not (akRight in Anchors)) then
          Width:=Scale(Width);
      end;
      if (Align<>alLeft)and(Align<>alRight)then
      begin
        if (not (akBottom in Anchors))and(Align<>alBottom) then
          Top:=Scale(Top);
        if (not (akBottom in Anchors))and(not (akTop in Anchors)) then
          Height:=Scale(Height);
      end;
    end;
  end;
  
  THackControl(Control).Font.Size:=Scale(THackControl(Control).Font.Size);
 
  if Control is TWinControl then
  begin
    WinControl:=TWinControl(Control);
    if WinControl.ControlCount = 0 then
      exit;
    for i:=0 to WinControl.ControlCount-1 do
      ScaleDPI(WinControl.Controls[i]);
  end;
end;

initialization
  Echelle:=Screen.MenuFont.Size/FromDPI;
 
end.
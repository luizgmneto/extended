unit u_extdbgrid;

{*********************************************************************}
{                                                                     }
{             TExtDBGrid :                                            }
{             Grille avec couleurs de focus, d'édition,               }
{             permettant d'être éditée avec des composants de données }
{             Créateur : Matthieu Giroux                              }
{             13 Juin 2011                                            }
{                                                                     }
{*********************************************************************}

{$I ..\Compilers.inc}
{$I ..\extends.inc}
{$IFDEF FPC}
{$mode Delphi}
{$ENDIF}

interface

uses
{$IFDEF FPC}
   LCLType,
   RxDBGrid,
{$ELSE}
   Windows,
{$ENDIF}
{$IFDEF VERSIONS}
  fonctions_version,
{$ENDIF}
  Classes, SysUtils, Grids,
  u_extcomponent, Graphics,
  Messages, DB,
{$IFDEF TNT}
  TntDBGrids,
{$ENDIF}
{$IFDEF EXRX}
  ExRXDBGrid,
{$ENDIF}
  DBGrids, Controls;

{$IFDEF VERSIONS}
const
    gVer_ExtDBGrid : T_Version = ( Component : 'Grille de données étendue' ;
                                               FileUnit : 'U_ExtDBGrid' ;
                                               Owner : 'Matthieu Giroux' ;
                                               Comment : 'Grille avec fonctions étendues.' ;
                                               BugsStory : '0.9.9.9 : Tested OK on DELPHI, need new version of LAZARUS to be completed.' + #13#10
                                                         + '0.9.0.0 : Création à partir de u_framework_dbcomponents.' ;
                                               UnitType : 3 ;
                                               Major : 0 ; Minor : 9 ; Release : 9 ; Build : 9 );

{$ENDIF}


   { TExtGridColumn }
type
   TExtGridColumn = class({$IFDEF TNT}TTntColumn{$ELSE}TRxColumn{$ENDIF})
   private
     FOldControlKeyUp   , FOldControlKeyDown,
     FAfterControlKeyUp , FAfterControlKeyDown : TKeyEvent;
     FOldControlKeyPress   ,
     FAfterControlKeyPress : TKeyPressEvent;
     FControl : TWinControl ;
     FFieldTag : Integer ;
   protected
     procedure SetControl ( const AValue : TWinControl ); virtual;
     function  fi_getFieldTag:Integer; virtual;
     procedure p_setFieldTag ( const avalue : Integer ); virtual;
   public
     constructor Create(ACollection: TCollection); override;
   published
     procedure ControlKeyUp   ( ASender : TObject ; var Key: Word; Shift: TShiftState ); virtual;
     procedure ControlKeyDown ( ASender : TObject ; var Key: Word; Shift: TShiftState ); virtual;
     procedure ControlKeyPress( ASender : TObject ; var Key: Char ); virtual;
     property SomeEdit : TWinControl read FControl       write SetControl;
     property FieldTag : Integer     read fi_getFieldTag write p_setFieldTag;
     property AfterControlKeyUp    : TKeyEvent      read FAfterControlKeyUp    write FAfterControlKeyUp;
     property AfterControlKeyDown  : TKeyEvent      read FAfterControlKeyDown  write FAfterControlKeyDown;
     property AfterControlKeyPress : TKeyPressEvent read FAfterControlKeyPress write FAfterControlKeyPress;
   end;

   { TExtDbGridColumns }

   TExtDbGridColumns = class({$IFDEF TNT}TTntDBGridColumns{$ELSE}TRxDbGridColumns{$ENDIF})
   private
     function GetColumn ( Index: Integer): TExtGridColumn;
     procedure SetColumn( Index: Integer; const Value: TExtGridColumn);
   public
     function Add: TExtGridColumn;
     property Items[Index: Integer]: TExtGridColumn read GetColumn write SetColumn; default;
   end;

   { TExtDBGrid }

   TExtDBGrid = class ( {$IFDEF TNT}TTntDBGrid{$ELSE}{$IFDEF EXRX}TExRxDBGrid{$ELSE}{$IFDEF JEDI}TJvDBUltimGrid{$ELSE}TRXDBGrid{$ENDIF}{$ENDIF}{$ENDIF}, IFWComponent )
     private
       FPaintEdits : Boolean;
       FBeforeEnter, FBeforeExit : TNotifyEvent;
       FColorEdit     ,
       FColorFocus    ,
       FOldFixedColor : TColor;
       FAlwaysSame : Boolean;
       function GetColumns: TExtDbGridColumns;
       procedure SetColumns(const AValue: TExtDbGridColumns);
       procedure WMSetFocus(var Msg: TWMSetFocus); message WM_SETFOCUS;
       procedure WMVScroll(var Message: TWMVScroll); message WM_VSCROLL;
       procedure WMHScroll(var Msg: TWMHScroll); message WM_HSCROLL;
       procedure HideColumnControl;
       procedure ShowControlColumn;
       procedure p_SetPaintEdits ( const AValue : Boolean );
      protected
       procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
          X, Y: Integer); override;
       function IsColumnsStored: boolean; virtual;
       procedure DrawCell(aCol,aRow: {$IFDEF FPC}Integer{$ELSE}Longint{$ENDIF}; aRect: TRect; aState:TGridDrawState); override;
       function CanEditShow: Boolean; override;
      public
       procedure KeyDown(var Key: Word; Shift: TShiftState); override;
       procedure KeyUp(var ach_Key: Word; ashi_Shift: TShiftState); override;
       constructor Create ( AOwner : TComponent ); override;
       procedure DoEnter; override;
       procedure DoExit; override;
       procedure Loaded; override;
       function  CreateColumns: {$IFDEF FPC}TGridColumns{$ELSE}TDBGridColumns{$ENDIF}; override;
       {$IFDEF EXRX}
       procedure TitleClick(Column: TColumn); override;
       {$ELSE}
       procedure DoTitleClick(ACol: Longint; AField: TField); override;
       {$ENDIF}
      published
       property Columns: TExtDbGridColumns read GetColumns write SetColumns stored IsColumnsStored;
       property FWBeforeEnter : TnotifyEvent read FBeforeEnter write FBeforeEnter stored False;
       property FWBeforeExit  : TnotifyEvent read FBeforeExit  write FBeforeExit stored False ;
       property ColorEdit : TColor read FColorEdit write FColorEdit default CST_GRILLE_STD ;
       property FixedColor default CST_GRILLE_STD ;
       property ColorFocus : TColor read FColorFocus write FColorFocus default CST_GRILLE_SELECT ;
       property AlwaysSame : Boolean read FAlwaysSame write FAlwaysSame default true;
       property PaintEdits : Boolean read FPaintEdits write p_SetPaintEdits default true;
     End;

implementation


uses
{$IFNDEF FPC}
   Forms,
{$ENDIF}
   fonctions_proprietes;

{ TExtGridColumn }

// Procedure SetControl
// Setting control of column
// Parameter : AValue the control of property

procedure TExtGridColumn.SetControl(const AValue: TWinControl);
var lmet_MethodeDistribuee: TMethod;

begin
  If AValue <> FControl Then
   Begin
     if ( FControl <> nil )
     and not ( csDesigning in Grid.ComponentState ) then
       Begin
         p_SetComponentMethodProperty( FControl, 'OnKeyUp'   , TMethod ( FOldControlKeyUp ));
         p_SetComponentMethodProperty( FControl, 'OnKeyDown' , TMethod ( FOldControlKeyDown ));
         p_SetComponentMethodProperty( FControl, 'OnKeyPress', TMethod ( FOldControlKeyPress ));
         FOldControlKeyPress := nil;
         FOldControlKeyDown  := nil;
         FOldControlKeyUp    := nil;
       End;
     FControl := AValue;
     if ( FControl = nil ) Then
       Exit;
     FControl.Parent := Grid.Parent;
     FControl.Visible := False;
     p_SetComponentObjectProperty ( FControl, 'Datasource', (TDBGrid (Grid)).DataSource );
     if not ( csDesigning in Grid.ComponentState ) then
      Begin
       FOldControlKeyUp     := TKeyEvent      ( fmet_getComponentMethodProperty ( FControl, 'OnKeyUp'  ));
       FOldControlKeyDown   := TKeyEvent      ( fmet_getComponentMethodProperty ( FControl, 'OnKeyDown'));
       FOldControlKeyPress  := TKeyPressEvent ( fmet_getComponentMethodProperty ( FControl, 'OnKeyPress'));
       lmet_MethodeDistribuee.Data := Self;
       lmet_MethodeDistribuee.Code := MethodAddress('ControlEnter');
       p_SetComponentMethodProperty( FControl, 'OnEnter', lmet_MethodeDistribuee);
       lmet_MethodeDistribuee.Code := MethodAddress('ControlExit');
       p_SetComponentMethodProperty( FControl, 'OnExit' , lmet_MethodeDistribuee );
       lmet_MethodeDistribuee.Code := MethodAddress('ControlKeyUp');
       p_SetComponentMethodProperty( FControl, 'OnKeyUp' , lmet_MethodeDistribuee );
       lmet_MethodeDistribuee.Code := MethodAddress('ControlKeyDown');
       p_SetComponentMethodProperty( FControl, 'OnKeyDown' , lmet_MethodeDistribuee );
       lmet_MethodeDistribuee.Code := MethodAddress('ControlKeyPress');
       p_SetComponentMethodProperty( FControl, 'OnKeyPress' , lmet_MethodeDistribuee );
      end;
   end;
end;

// function fi_getFieldTag
// Getting the FieldTag Property
// Returns Tag Property
function TExtGridColumn.fi_getFieldTag: Integer;
begin
  Result := FFieldTag;
end;

// procedure p_setFieldTag
// Setting the FieldTag Property
// Parameter : The FieldTag to set
procedure TExtGridColumn.p_setFieldTag( const avalue : Integer );
begin
  FFieldTag := avalue;
end;

procedure TExtGridColumn.ControlKeyDown(ASender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if assigned ( FOldControlKeyDown ) Then
     FOldControlKeyDown ( ASender, Key, Shift );
  ( Grid as TExtDBGrid ).KeyDown( Key, Shift );
  if assigned ( FAfterControlKeyDown ) Then
     FAfterControlKeyDown ( ASender, Key, Shift );

end;

procedure TExtGridColumn.ControlKeyPress(ASender: TObject; var Key: Char);
begin
  if assigned ( FOldControlKeyPress ) Then
     FOldControlKeyPress ( ASender, Key );
  ( Grid as TExtDBGrid ).KeyPress( Key );
  if assigned ( FAfterControlKeyPress ) Then
     FAfterControlKeyPress ( ASender, Key );

end;

procedure TExtGridColumn.ControlKeyUp(ASender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if assigned ( FOldControlKeyUp ) Then
     FOldControlKeyUp ( ASender, Key, Shift );
  ( Grid as TExtDBGrid ).KeyUp( Key, Shift );
  if assigned ( FAfterControlKeyUp ) Then
     FAfterControlKeyUp ( ASender, Key, Shift );
end;

constructor TExtGridColumn.Create(ACollection: TCollection);
begin
  inherited Create(ACollection);
  FAfterControlKeyDown  := nil;
  FAfterControlKeyUp    := nil;
  FAfterControlKeyPress := nil;
  FOldControlKeyDown    := nil;
  FOldControlKeyPress   := nil;
  FOldControlKeyUp      := nil;
  FControl := nil;
  FFieldTag := 0 ;
end;


{ TExtDbGridColumns }

function TExtDbGridColumns.GetColumn( Index: Integer): TExtGridColumn;
begin
  result := TExtGridColumn( inherited Items[Index] );
end;

procedure TExtDbGridColumns.SetColumn( Index: Integer; const Value: TExtGridColumn);
begin
  Items[Index].Assign( Value );
end;

function TExtDbGridColumns.Add: TExtGridColumn;
begin
  result := TExtGridColumn (inherited Add);
end;

{ TExtDBGrid }

// Procedure  p_SetPaintEdits
// Setting PaintEdits property to paint edits in grid

procedure TExtDBGrid.p_SetPaintEdits(const AValue: Boolean);
begin
  if AValue <> FPaintEdits Then
    Begin
     FPaintEdits:= AValue;
     if not ( csCreating in ControlState ) Then
       Invalidate;
    end;
end;


procedure TExtDBGrid.HideColumnControl;
var i : Integer ;
Begin
  for i := 0 to Columns.Count - 1 do
    if  assigned ( Columns [ i ].SomeEdit )
    and Columns [ i ].SomeEdit.Visible then
      with Columns [ i ].SomeEdit do
       Begin
         Update;
         Visible := False;
       End

End;


procedure TExtDBGrid.WMHScroll(var Msg: TWMHScroll);
begin
  inherited;
  HideColumnControl;
end;
procedure TExtDBGrid.WMSetFocus(var Msg: TWMSetFocus);
begin
  Inherited;
  HideColumnControl;
end;

// Procedure ShowControlColumn
// Shows the control of column if exists
procedure TExtDBGrid.ShowControlColumn;
var Weight, Coord, WidthHeight : Integer ;
{$IFNDEF FPC}
    DrawInfo: TGridDrawInfo;
 function LinePos(const AxisInfo: TGridAxisDrawInfo; Line: Integer): Integer;
  var
    Start, I: Longint;
  begin
    with AxisInfo do
    begin
      Result := 0;
      if Line < FixedCellCount then
        Start := 0
      else
      begin
        if Line >= FirstGridCell then
          Result := FixedBoundary;
        Start := FirstGridCell;
      end;
      for I := Start to Line - 1 do
      begin
        Inc(Result, GetExtent(I) + EffectiveLineWidth);
        if Result > GridExtent then
        begin
          Result := 0;
          Exit;
        end;
      end;
    end;
  end;

  function CalcAxis(const AxisInfo: TGridAxisDrawInfo;
    GridRectMin: Integer;
    var ScreenRectMin: Integer): Boolean;
  begin
    Result := False;
    with AxisInfo do
    begin
      if (GridRectMin >= FixedCellCount) and (GridRectMin < FirstGridCell) then
          GridRectMin := FirstGridCell;

      ScreenRectMin := LinePos(AxisInfo, GridRectMin);
    end;
    Result := True;
  end;
{$ENDIF}
begin
  {$IFNDEF FPC}
  CalcDrawInfo(DrawInfo);
  with DrawInfo do
  {$ENDIF}
    if  ( Row > 0 )
    and ( Col > 0 )
    and ( Columns [ SelectedIndex ].SomeEdit <> nil )  Then
      with Columns [ SelectedIndex ].SomeEdit do
        Begin
          Visible := True;
          Coord  := 0 ;
          Weight := 0 ;
          {$IFNDEF FPC}
          if Self.Ctl3D then
            inc ( Weight, 1 );
          if Self.BorderStyle <> bsNone then
            inc ( Weight, 1 );
          {$ENDIF}
          {$IFDEF FPC}
          WidthHeight := 0 ;
          ColRowToOffset ( True, True, Col, Coord, WidthHeight);
          {$ELSE}
          CalcAxis(Horz,Selection.Left, Coord);
          {$ENDIF}
          Left := Coord + Self.ClientRect.Left + Self.Left + Weight ;
          Width := ColWidths [ Col ];
          {$IFDEF FPC}
          ColRowToOffset ( False, True, Row, Coord, WidthHeight);
          {$ELSE}
          CalcAxis(Vert,Selection.Bottom, Coord);
          {$ENDIF}
          Top  := Coord  + Self.ClientRect.Top  + Self.Top  + Weight;
          Height := RowHeights[Row];
          SetFocus;
        End ;
//  with DrawInfo do
//     ShowMessage(IntToStr(InvalidRect.Left)+' '+IntToStr(InvalidRect.Top)+' '+IntToStr(Vert.FirstGridCell)+' '+IntToStr(Horz.FirstGridCell) + ' ' + Inttostr ( SelectedIndex )  + ' ' +Inttostr(Selection.Left) + ' ' +Inttostr(Selection.Top));

end;

procedure TExtDBGrid.WMVScroll(var Message: TWMVScroll);
begin
  inherited;
  HideColumnControl;
end;

function TExtDBGrid.CanEditShow: Boolean;
begin
  if  ( SelectedIndex >= 0 )
  and ( SelectedIndex < Columns.Count )
  and assigned ( Columns [ SelectedIndex ].SomeEdit )
  and ( Columns [ SelectedIndex ].SomeEdit.Visible ) then
    Begin
     Result := False;
    End
  Else
   Result := inherited CanEditShow;

end;

constructor TExtDBGrid.Create( AOwner: TComponent);
begin
  inherited Create(AOwner);
  FPaintEdits:=True;
  FAlwaysSame := True;
  FColorFocus := CST_GRILLE_SELECT;
  FColorEdit  := CST_GRILLE_STD;
  FixedColor  := CST_GRILLE_STD;
  FWBeforeEnter:=nil;
  FWBeforeExit :=nil;
end;

procedure TExtDBGrid.Loaded;
begin
  inherited Loaded;
  FOldFixedColor := FixedColor;
  if  FAlwaysSame
   Then
    FixedColor := gCol_Grid ;
End;

procedure TExtDBGrid.MouseDown(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  inherited;
  ShowControlColumn;
end;

function TExtDBGrid.GetColumns: TExtDbGridColumns;
begin
  Result := inherited Columns as TExtDBGridColumns;
end;

procedure TExtDBGrid.SetColumns(const AValue: TExtDbGridColumns);
begin
  inherited Columns := AValue;
end;


procedure TExtDBGrid.DrawCell(aCol, aRow: {$IFDEF FPC}Integer{$ELSE}Longint{$ENDIF}; aRect: TRect;
  aState: TGridDrawState);
{$IFNDEF FPC}
var OldActive : Integer;
    FBackground: TColor;
{$ENDIF}
begin
  {$IFNDEF FPC}
  if  FPaintEdits
  and ( ACol > 0  )
  and ( ARow >= {$IFDEF FPC}1{$ELSE}IndicatorOffset{$ENDIF} )
  and assigned (( TExtGridColumn ( Columns [ ACol - 1 ])).SomeEdit ) Then
   with ( TExtGridColumn ( Columns [ ACol - 1 ])).SomeEdit do
     Begin
       {$IFDEF FPC}
       PrepareCanvas(aCol, aRow, aState);
       if Assigned(OnGetCellProps) and not (gdSelected in aState) then
       begin
         FBackground:=Canvas.Brush.Color;
         OnGetCellProps(Self, GetFieldFromGridColumn(aCol), Canvas.Font, FBackground);
         Canvas.Brush.Color:=FBackground;
       end;
       {$ELSE}
       Canvas.Brush.Color := Color;
       {$ENDIF}
       Self.Canvas.FillRect(aRect);
       OldActive := Datalink.ActiveRecord;
       Datalink.ActiveRecord := ARow {$IFDEF FPC}-1{$ELSE}-IndicatorOffset{$ENDIF};
       Width  := aRect.Right - aRect.Left;
       Height := ARect.Bottom - aRect.Top;
       ControlState := ControlState + [csPaintCopy];
       PaintTo(Self.Canvas.Handle,aRect.Left,aRect.Top);
       ControlState := ControlState - [csPaintCopy];
       Datalink.ActiveRecord := OldActive;
     end
    Else    {$ENDIF}
      inherited DrawCell(aCol, aRow, aRect, aState);
end;

function TExtDBGrid.IsColumnsStored: boolean;
begin
  result := True;
end;


procedure TExtDBGrid.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited;
  ShowControlColumn;
end;

procedure TExtDBGrid.KeyUp(var ach_Key: Word; ashi_Shift: TShiftState);
begin
  if  ( ach_Key = VK_DELETE )
  and ( ashi_Shift = [ssCtrl] )
  and assigned ( DataSource )
  and assigned ( Datasource.DataSet ) Then
    Begin
      Datasource.DataSet.Delete;
      ach_Key := 0 ;
    End;
  inherited KeyUp(ach_Key, ashi_Shift);
end;

function TExtDBGrid.CreateColumns: {$IFDEF FPC}TGridColumns{$ELSE}TDBGridColumns{$ENDIF};
begin
  Result := TExtDbGridColumns.Create(Self, TExtGridColumn);
end;

procedure TExtDBGrid.DoEnter;
begin
  if assigned ( FBeforeEnter ) Then
    FBeforeEnter ( Self );
  // Rétablit le focus si on l'a perdu
  if FAlwaysSame
   Then
    FixedColor := gCol_GridSelect
   else
    FixedColor := FColorFocus ;
  inherited DoEnter;
end;

procedure TExtDBGrid.DoExit;
begin
  if assigned ( FBeforeExit ) Then
    FBeforeExit ( Self );
  inherited DoExit;
  // Rétablit la couleur du focus
  if FAlwaysSame
   Then
    FixedColor := gCol_Grid
   else
    FixedColor := FOldFixedColor ;
end;

 // Gestion du click sur le titre
{$IFDEF EXRX}
procedure TExtDBGrid.TitleClick(Column: TColumn);
{$ELSE}
procedure TExtDBGrid.DoTitleClick(ACol: Longint; AField: TField);
{$ENDIF}

var li_Tag , li_i : Integer ;
begin
  // Phase d'initialisation
 li_Tag :=(TExtGridColumn ( {$IFDEF EXRX} Column {$ELSE} Columns [ ACol ]{$ENDIF})).FieldTag ;
 if li_tag > 0 then
   for li_i :=0 to ComponentCount -1 do
      if  ( li_Tag = Components [ li_i ].Tag )
      and Supports( Components [ li_i ], IFWComponentEdit )
      and ( Components [ li_i ] as TWinControl ).Visible  Then
        Begin
          ( Components [ li_i ] as IFWComponentEdit).SetOrder;
        End ;
  SetFocus;
end;

{$IFDEF VERSIONS}
initialization
  // Gestion de version
  p_ConcatVersion(gVer_ExtDBGrid);
{$ENDIF}
end.


unit u_framework_dbcomponents;

{$I ..\Compilers.inc}
{$I ..\extends.inc}
{$IFDEF FPC}
{$mode Delphi}
{$ENDIF}

interface

uses
{$IFDEF FPC}
   LCLIntf, LCLType,
   SQLDB, lmessages,
   RxDBGrid,
   dbdateedit,
{$ELSE}
   Windows, Mask, DBTables, ActnMan,
{$ENDIF}
{$IFDEF JEDI}
  JvDBGrid,JvDBLookup,jvDBUltimGrid, jvDBControls, JvDBDateTimePicker,
{$ENDIF}
{$IFDEF RX}
  RxLookup,
{$ENDIF}
{$IFDEF EXRX}
  ExRXDBGrid,
{$ENDIF}
{$IFDEF VERSIONS}
  fonctions_version,
{$ENDIF}
  Graphics, Controls, Classes, ExtCtrls, Dialogs, Messages,
  Buttons, Forms, DBCtrls, Grids, DB,
  DBGrids, ComCtrls, StdCtrls, SysUtils,
  TypInfo, Variants, u_extcomponent,
{$IFDEF TNT}
   TntDBGrids, TntStdCtrls, TntDBCtrls,
{$ENDIF}
  fonctions_erreurs, u_framework_components;

{$IFDEF VERSIONS}
const
    gVer_framework_DBcomponents : T_Version = ( Component : 'Composants d''interactivité de données' ;
                                               FileUnit : 'u_framework_dbcomponents' ;
                                               Owner : 'Matthieu Giroux' ;
                                               Comment : 'Composants d''interactivité de U_CustomFrameWork.' ;
                                               BugsStory : '0.9.0.1 : FWDBGrid tested on Delphi, with Controls on Columns.'
                                                         + '0.9.0.0 : Création à partir de u_framework_components.';
                                               UnitType : 3 ;
                                               Major : 0 ; Minor : 9 ; Release : 0 ; Build : 1 );

{$ENDIF}
type

{ TFWDBEdit }

   TFWDBEdit = class ( {$IFDEF TNT}TTntDBEdit{$ELSE}TDBEdit{$ENDIF}, IFWComponent, IFWComponentEdit )
      private
       FBeforeEnter, FBeforeExit : TNotifyEvent;
       FLabel : TFWLabel ;
       FOldColor ,
       FColorFocus ,
       FColorReadOnly,
       FColorEdit ,
       FColorLabel : TColor;
       FAlwaysSame : Boolean;
       FNotifyOrder : TNotifyEvent;
       procedure p_setLabel ( const alab_Label : TFWLabel );
       procedure WMPaint(var Message: {$IFDEF FPC}TLMPaint{$ELSE}TWMPaint{$ENDIF}); message {$IFDEF FPC}LM_PAINT{$ELSE}WM_PAINT{$ENDIF};
      public

       constructor Create ( AOwner : TComponent ); override;
       procedure DoEnter; override;
       procedure DoExit; override;
       procedure Loaded; override;
       procedure SetOrder ; virtual;
      published
       property FWBeforeEnter : TnotifyEvent read FBeforeEnter write FBeforeEnter stored False;
       property FWBeforeExit  : TnotifyEvent read FBeforeExit  write FBeforeExit stored False ;
       property ColorLabel : TColor read FColorLabel write FColorLabel default CST_LBL_SELECT ;
       property ColorFocus : TColor read FColorFocus write FColorFocus default CST_EDIT_SELECT ;
       property ColorEdit : TColor read FColorEdit write FColorEdit default CST_EDIT_STD ;
       property ColorReadOnly : TColor read FColorReadOnly write FColorReadOnly default CST_EDIT_READ ;
       property MyLabel : TFWLabel read FLabel write p_setLabel;
       property AlwaysSame : Boolean read FAlwaysSame write FAlwaysSame default true;
       property OnOrder : TNotifyEvent read FNotifyOrder write FNotifyOrder;
     End;

   TFWDBDateEdit = class ( {$IFDEF FPC}TDBDateEdit{$ELSE}TJvDBDateEdit{$ENDIF}, IFWComponent, IFWComponentEdit )
      private
       FBeforeEnter, FBeforeExit : TNotifyEvent;
       FLabel : TFWLabel ;
       FOldColor ,
       FColorFocus ,
       FColorReadOnly,
       FColorEdit ,
       FColorLabel : TColor;
       FAlwaysSame : Boolean;
       FNotifyOrder : TNotifyEvent;
       procedure p_setLabel ( const alab_Label : TFWLabel );
       procedure WMPaint(var Message: {$IFDEF FPC}TLMPaint{$ELSE}TWMPaint{$ENDIF}); message {$IFDEF FPC}LM_PAINT{$ELSE}WM_PAINT{$ENDIF};
      public

       constructor Create ( AOwner : TComponent ); override;
       procedure DoEnter; override;
       procedure DoExit; override;
       procedure Loaded; override;
       procedure SetOrder ; virtual;
      published
       property FWBeforeEnter : TnotifyEvent read FBeforeEnter write FBeforeEnter stored False;
       property FWBeforeExit  : TnotifyEvent read FBeforeExit  write FBeforeExit stored False ;
       property ColorLabel : TColor read FColorLabel write FColorLabel default CST_LBL_SELECT ;
       property ColorFocus : TColor read FColorFocus write FColorFocus default CST_EDIT_SELECT ;
       property ColorEdit : TColor read FColorEdit write FColorEdit default CST_EDIT_STD ;
       property ColorReadOnly : TColor read FColorReadOnly write FColorReadOnly default CST_EDIT_READ ;
       property MyLabel : TFWLabel read FLabel write p_setLabel;
       property AlwaysSame : Boolean read FAlwaysSame write FAlwaysSame default true;
       property OnOrder : TNotifyEvent read FNotifyOrder write FNotifyOrder;
     End;

{$IFNDEF FPC}

   TFWDBDateTimePicker = class ( TJvDBDateTimePicker, IFWComponent, IFWComponentEdit )
      private
       FBeforeEnter, FBeforeExit : TNotifyEvent;
       FLabel : TFWLabel ;
       FOldColor ,
       FColorFocus ,
       FColorReadOnly,
       FColorEdit ,
       FColorLabel : TColor;
       FAlwaysSame : Boolean;
       FNotifyOrder : TNotifyEvent;
       procedure p_setLabel ( const alab_Label : TFWLabel );
       procedure WMPaint(var Message: {$IFDEF FPC}TLMPaint{$ELSE}TWMPaint{$ENDIF}); message {$IFDEF FPC}LM_PAINT{$ELSE}WM_PAINT{$ENDIF};
      public

       constructor Create ( AOwner : TComponent ); override;
       procedure DoEnter; override;
       procedure DoExit; override;
       procedure Loaded; override;
       procedure SetOrder ; virtual;
      published
       property FWBeforeEnter : TnotifyEvent read FBeforeEnter write FBeforeEnter stored False;
       property FWBeforeExit  : TnotifyEvent read FBeforeExit  write FBeforeExit stored False ;
       property ColorLabel : TColor read FColorLabel write FColorLabel default CST_LBL_SELECT ;
       property ColorFocus : TColor read FColorFocus write FColorFocus default CST_EDIT_SELECT ;
       property ColorEdit : TColor read FColorEdit write FColorEdit default CST_EDIT_STD ;
       property ColorReadOnly : TColor read FColorReadOnly write FColorReadOnly default CST_EDIT_READ ;
       property MyLabel : TFWLabel read FLabel write p_setLabel;
       property AlwaysSame : Boolean read FAlwaysSame write FAlwaysSame default true;
       property OnOrder : TNotifyEvent read FNotifyOrder write FNotifyOrder;
     End;

{$ENDIF}

   { TFWLabel }
   TFWDBLookupCombo = class ( {$IFDEF JEDI}TJvDBLookupCombo{$ELSE}{$IFDEF FPC}TDBLookupComboBox{$ELSE}{$IFDEF RX}TRxDBLookupCombo{$ELSE}TDBLookupComboBox{$ENDIF}{$ENDIF}{$ENDIF}, IFWComponent, IFWComponentEdit )
      private
       FBeforeEnter, FBeforeExit : TNotifyEvent;
       FLabel : TFWLabel ;
       FOldColor ,
       FColorReadOnly,
       FColorFocus ,
       FColorEdit ,
       FColorLabel : TColor;
       FAlwaysSame : Boolean;
       FNotifyOrder : TNotifyEvent;
       procedure p_setLabel ( const alab_Label : TFWLabel );
       procedure WMPaint(var Message: {$IFDEF FPC}TLMPaint{$ELSE}TWMPaint{$ENDIF}); message {$IFDEF FPC}LM_PAINT{$ELSE}WM_PAINT{$ENDIF};
      public

       constructor Create ( AOwner : TComponent ); override;
       procedure DoEnter; override;
       procedure DoExit; override;
       procedure Loaded; override;
       procedure SetOrder ; virtual;
      published
       property FWBeforeEnter : TnotifyEvent read FBeforeEnter write FBeforeEnter stored False;
       property FWBeforeExit  : TnotifyEvent read FBeforeExit  write FBeforeExit stored False ;
       property ColorLabel : TColor read FColorLabel write FColorLabel default CST_LBL_SELECT ;
       property ColorFocus : TColor read FColorFocus write FColorFocus default CST_EDIT_SELECT ;
       property ColorEdit : TColor read FColorEdit write FColorEdit default CST_EDIT_STD ;
       property ColorReadOnly : TColor read FColorReadOnly write FColorReadOnly default CST_EDIT_READ ;
       property MyLabel : TFWLabel read FLabel write p_setLabel;
       property AlwaysSame : Boolean read FAlwaysSame write FAlwaysSame default true;
       property OnOrder : TNotifyEvent read FNotifyOrder write FNotifyOrder;
     End;

   { TFWGridColumn }

   TFWGridColumn = class({$IFDEF TNT}TTntColumn{$ELSE}TRxColumn{$ENDIF})
   private
     FOldControlKeyUp   , FOldControlKeyDown,
     FAfterControlKeyUp , FAfterControlKeyDown : TKeyEvent;
     FOldControlKeyPress   ,
     FAfterControlKeyPress : TKeyPressEvent;
     FControl : TWinControl ;
     FFieldTag : Integer ;
   protected
     procedure SetControl ( AValue : TWinControl ); virtual;
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

   { TFWDbGridColumns }

   TFWDbGridColumns = class({$IFDEF TNT}TTntDBGridColumns{$ELSE}TRxDbGridColumns{$ENDIF})
   private
     function GetColumn(Index: Integer): TFWGridColumn;
     procedure SetColumn(Index: Integer; Value: TFWGridColumn);
   public
     function Add: TFWGridColumn;
   public
     property Items[Index: Integer]: TFWGridColumn read GetColumn write SetColumn; default;
   end;

   { TFWDBGrid }

   TFWDBGrid = class ( {$IFDEF TNT}TTntDBGrid{$ELSE}{$IFDEF EXRX}TExRxDBGrid{$ELSE}{$IFDEF JEDI}TJvDBUltimGrid{$ELSE}TRXDBGrid{$ENDIF}{$ENDIF}{$ENDIF}, IFWComponent )
     private
       FBeforeEnter, FBeforeExit : TNotifyEvent;
       FColorEdit     ,
       FColorFocus    ,
       FOldFixedColor : TColor;
       FAlwaysSame : Boolean;
       function GetColumns: TFWDbGridColumns;
       procedure SetColumns(const AValue: TFWDbGridColumns);
       procedure WMSetFocus(var Msg: TWMSetFocus); message WM_SETFOCUS;
       procedure WMVScroll(var Message: TWMVScroll); message WM_VSCROLL;
       procedure WMHScroll(var Msg: TWMHScroll); message WM_HSCROLL;
       procedure HideColumnControl;
       procedure ShowControlColumn;
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
       property Columns: TFWDbGridColumns read GetColumns write SetColumns stored IsColumnsStored;
       property FWBeforeEnter : TnotifyEvent read FBeforeEnter write FBeforeEnter stored False;
       property FWBeforeExit  : TnotifyEvent read FBeforeExit  write FBeforeExit stored False ;
       property ColorEdit : TColor read FColorEdit write FColorEdit default CST_GRILLE_STD ;
       property FixedColor default CST_GRILLE_STD ;
       property ColorFocus : TColor read FColorFocus write FColorFocus default CST_GRILLE_SELECT ;
       property AlwaysSame : Boolean read FAlwaysSame write FAlwaysSame default true;
     End;

   TFWDBMemo = class ( TDBMemo, IFWComponent, IFWComponentEdit )
      private
       FBeforeEnter, FBeforeExit : TNotifyEvent;
       FLabel : TFWLabel ;
       FOldColor ,
       FColorFocus ,
       FColorReadOnly,
       FColorEdit ,
       FColorLabel : TColor;
       FAlwaysSame : Boolean;
       FNotifyOrder : TNotifyEvent;
       procedure p_setLabel ( const alab_Label : TFWLabel );
       procedure WMPaint(var Message: {$IFDEF FPC}TLMPaint{$ELSE}TWMPaint{$ENDIF}); message {$IFDEF FPC}LM_PAINT{$ELSE}WM_PAINT{$ENDIF};
      public

       constructor Create ( AOwner : TComponent ); override;
       procedure DoEnter; override;
       procedure DoExit; override;
       procedure Loaded; override;
       procedure SetOrder ; virtual;
      published
       property FWBeforeEnter : TnotifyEvent read FBeforeEnter write FBeforeEnter stored False;
       property FWBeforeExit  : TnotifyEvent read FBeforeExit  write FBeforeExit stored False ;
       property ColorLabel : TColor read FColorLabel write FColorLabel default CST_LBL_SELECT ;
       property ColorFocus : TColor read FColorFocus write FColorFocus default CST_EDIT_SELECT ;
       property ColorEdit : TColor read FColorEdit write FColorEdit default CST_EDIT_STD ;
       property ColorReadOnly : TColor read FColorReadOnly write FColorReadOnly default CST_EDIT_READ ;
       property MyLabel : TFWLabel read FLabel write p_setLabel;
       property AlwaysSame : Boolean read FAlwaysSame write FAlwaysSame default true;
       property OnOrder : TNotifyEvent read FNotifyOrder write FNotifyOrder;
     End;


implementation

uses fonctions_db, fonctions_proprietes;



{ TFWDBEdit }

procedure TFWDBEdit.p_setLabel(const alab_Label: TFWLabel);
begin
  if alab_Label <> FLabel Then
    Begin
      FLabel := alab_Label;
      FLabel.MyEdit := Self;
    End;
end;

procedure TFWDBEdit.SetOrder;
begin
  if assigned ( FNotifyOrder ) then
    FNotifyOrder ( Self );
end;

constructor TFWDBEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FAlwaysSame := True;
  FColorLabel := CST_LBL_SELECT;
  FColorEdit  := CST_EDIT_STD;
  FColorFocus := CST_EDIT_SELECT;
  FColorReadOnly := CST_EDIT_READ;
end;

procedure TFWDBEdit.DoEnter;
begin
  if assigned ( FBeforeEnter ) Then
    FBeforeEnter ( Self );
  // Si on arrive sur une zone de saisie, on met en valeur son tlabel par une couleur
  // de fond bleu et son libellé en marron (sauf si le libellé est sélectionné
  // avec la souris => cas de tri)
  p_setLabelColorEnter ( FLabel, FColorLabel, FAlwaysSame );
  p_setCompColorEnter  ( Self, FColorFocus, FAlwaysSame );
  inherited DoEnter;
end;

procedure TFWDBEdit.DoExit;
begin
  if assigned ( FBeforeExit ) Then
    FBeforeExit ( Self );
  inherited DoExit;
  p_setLabelColorExit ( FLabel, FAlwaysSame );
  p_setCompColorExit ( Self, FOldColor, FAlwaysSame );

end;

procedure TFWDBEdit.Loaded;
begin
  inherited Loaded;
  FOldColor := Color;
  if  FAlwaysSame
   Then
    Color := gCol_Edit ;
end;

procedure TFWDBEdit.WMPaint(var Message: {$IFDEF FPC}TLMPaint{$ELSE}TWMPaint{$ENDIF});
Begin
  p_setCompColorReadOnly ( Self,FColorEdit,FColorReadOnly, FAlwaysSame, ReadOnly );
  inherited;
End;

{$IFNDEF FPC}
{ TFWDBDateTimePicker }

procedure TFWDBDateTimePicker.p_setLabel(const alab_Label: TFWLabel);
begin
  if alab_Label <> FLabel Then
    Begin
      FLabel := alab_Label;
      FLabel.MyEdit := Self;
    End;
end;

procedure TFWDBDateTimePicker.SetOrder;
begin
  if assigned ( FNotifyOrder ) then
    FNotifyOrder ( Self );
end;

constructor TFWDBDateTimePicker.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FAlwaysSame := True;
  FColorLabel := CST_LBL_SELECT;
  FColorEdit  := CST_EDIT_STD;
  FColorFocus := CST_EDIT_SELECT;
  FColorReadOnly := CST_EDIT_READ;
end;

procedure TFWDBDateTimePicker.DoEnter;
begin
  if assigned ( FBeforeEnter ) Then
    FBeforeEnter ( Self );
  // Si on arrive sur une zone de saisie, on met en valeur son tlabel par une couleur
  // de fond bleu et son libellé en marron (sauf si le libellé est sélectionné
  // avec la souris => cas de tri)
  p_setLabelColorEnter ( FLabel, FColorLabel, FAlwaysSame );
  p_setCompColorEnter  ( Self, FColorFocus, FAlwaysSame );
  inherited DoEnter;
end;

procedure TFWDBDateTimePicker.DoExit;
begin
  if assigned ( FBeforeExit ) Then
    FBeforeExit ( Self );
  inherited DoExit;
  p_setLabelColorExit ( FLabel, FAlwaysSame );
  p_setCompColorExit ( Self, FOldColor, FAlwaysSame );

end;

procedure TFWDBDateTimePicker.Loaded;
begin
  inherited Loaded;
  FOldColor := Color;
  if  FAlwaysSame
   Then
    Color := gCol_Edit ;
end;

procedure TFWDBDateTimePicker.WMPaint(var Message: {$IFDEF FPC}TLMPaint{$ELSE}TWMPaint{$ENDIF});
Begin
  p_setCompColorReadOnly ( Self,FColorEdit,FColorReadOnly, FAlwaysSame, ReadOnly );
  inherited;
End;

{$ENDIF}

{ TFWDBDateEdit }

procedure TFWDBDateEdit.p_setLabel(const alab_Label: TFWLabel);
begin
  if alab_Label <> FLabel Then
    Begin
      FLabel := alab_Label;
      FLabel.MyEdit := Self;
    End;
end;

procedure TFWDBDateEdit.SetOrder;
begin
  if assigned ( FNotifyOrder ) then
    FNotifyOrder ( Self );
end;

constructor TFWDBDateEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FAlwaysSame := True;
  FColorLabel := CST_LBL_SELECT;
  FColorEdit  := CST_EDIT_STD;
  FColorFocus := CST_EDIT_SELECT;
  FColorReadOnly := CST_EDIT_READ;
end;

procedure TFWDBDateEdit.DoEnter;
begin
  if assigned ( FBeforeEnter ) Then
    FBeforeEnter ( Self );
  // Si on arrive sur une zone de saisie, on met en valeur son tlabel par une couleur
  // de fond bleu et son libellé en marron (sauf si le libellé est sélectionné
  // avec la souris => cas de tri)
  p_setLabelColorEnter ( FLabel, FColorLabel, FAlwaysSame );
  p_setCompColorEnter  ( Self, FColorFocus, FAlwaysSame );
  inherited DoEnter;
end;

procedure TFWDBDateEdit.DoExit;
begin
  if assigned ( FBeforeExit ) Then
    FBeforeExit ( Self );
  inherited DoExit;
  p_setLabelColorExit ( FLabel, FAlwaysSame );
  p_setCompColorExit ( Self, FOldColor, FAlwaysSame );

end;

procedure TFWDBDateEdit.Loaded;
begin
  inherited Loaded;
  FOldColor := Color;
  if  FAlwaysSame
   Then
    Color := gCol_Edit ;
end;

procedure TFWDBDateEdit.WMPaint(var Message: {$IFDEF FPC}TLMPaint{$ELSE}TWMPaint{$ENDIF});
Begin
  p_setCompColorReadOnly ( Self,FColorEdit,FColorReadOnly, FAlwaysSame, ReadOnly );
  inherited;
End;

{ TFWDBLookupCombo }

procedure TFWDBLookupCombo.p_setLabel(const alab_Label: TFWLabel);
begin
  if alab_Label <> FLabel Then
    Begin
      FLabel := alab_Label;
      FLabel.MyEdit := Self;
    End;
end;

procedure TFWDBLookupCombo.SetOrder;
begin
  if assigned ( FNotifyOrder ) then
    FNotifyOrder ( Self );
end;

constructor TFWDBLookupCombo.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FAlwaysSame := True;
  FColorLabel := CST_LBL_SELECT;
  FColorEdit  := CST_EDIT_STD;
  FColorFocus := CST_EDIT_SELECT;
  FColorReadOnly := CST_EDIT_READ;
end;

procedure TFWDBLookupCombo.DoEnter;
begin
  if assigned ( FBeforeEnter ) Then
    FBeforeEnter ( Self );
  // Si on arrive sur une zone de saisie, on met en valeur son tlabel par une couleur
  // de fond bleu et son libellé en marron (sauf si le libellé est sélectionné
  // avec la souris => cas de tri)
  p_setLabelColorEnter ( FLabel, FColorLabel, FAlwaysSame );
  p_setCompColorEnter  ( Self, FColorFocus, FAlwaysSame );
  inherited DoEnter;
end;

procedure TFWDBLookupCombo.DoExit;
begin
  if assigned ( FBeforeExit ) Then
    FBeforeExit ( Self );
  inherited DoExit;
  p_setLabelColorExit ( FLabel, FAlwaysSame );
  p_setCompColorExit ( Self, FOldColor, FAlwaysSame );

end;

procedure TFWDBLookupCombo.Loaded;
begin
  inherited Loaded;
  FOldColor := Color;
  if  FAlwaysSame
   Then
    Color := gCol_Edit ;
end;

procedure TFWDBLookupCombo.WMPaint(var Message: {$IFDEF FPC}TLMPaint{$ELSE}TWMPaint{$ENDIF});
Begin
  p_setCompColorReadOnly ( Self,FColorEdit,FColorReadOnly, FAlwaysSame, ReadOnly );
  inherited;
End;

{ TFWGridColumn }

// Procedure SetControl
// Setting control of column
// Parameter : AValue the control of property

procedure TFWGridColumn.SetControl(AValue: TWinControl);
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
function TFWGridColumn.fi_getFieldTag: Integer;
begin
  Result := FFieldTag;
end;

// procedure p_setFieldTag
// Setting the FieldTag Property
// Parameter : The FieldTag to set
procedure TFWGridColumn.p_setFieldTag( const avalue : Integer );
begin
  FFieldTag := avalue;
end;

procedure TFWGridColumn.ControlKeyDown(ASender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if assigned ( FOldControlKeyDown ) Then
     FOldControlKeyDown ( ASender, Key, Shift );
  ( Grid as TFWDBgrid ).KeyDown( Key, Shift );
  if assigned ( FAfterControlKeyDown ) Then
     FAfterControlKeyDown ( ASender, Key, Shift );

end;

procedure TFWGridColumn.ControlKeyPress(ASender: TObject; var Key: Char);
begin
  if assigned ( FOldControlKeyPress ) Then
     FOldControlKeyPress ( ASender, Key );
  ( Grid as TFWDBgrid ).KeyPress( Key );
  if assigned ( FAfterControlKeyPress ) Then
     FAfterControlKeyPress ( ASender, Key );

end;

procedure TFWGridColumn.ControlKeyUp(ASender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if assigned ( FOldControlKeyUp ) Then
     FOldControlKeyUp ( ASender, Key, Shift );
  ( Grid as TFWDBgrid ).KeyUp( Key, Shift );
  if assigned ( FAfterControlKeyUp ) Then
     FAfterControlKeyUp ( ASender, Key, Shift );
end;

constructor TFWGridColumn.Create(ACollection: TCollection);
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


{ TFWDbGridColumns }

function TFWDbGridColumns.GetColumn(Index: Integer): TFWGridColumn;
begin
  result := TFWGridColumn( inherited Items[Index] );
end;

procedure TFWDbGridColumns.SetColumn(Index: Integer; Value: TFWGridColumn);
begin
  Items[Index].Assign( Value );
end;

function TFWDbGridColumns.Add: TFWGridColumn;
begin
  result := TFWGridColumn (inherited Add);
end;



{ TFWDBGrid }


procedure TFWDBGrid.HideColumnControl;
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


procedure TFWDBGrid.WMHScroll(var Msg: TWMHScroll);
begin
  inherited;
  HideColumnControl;
end;
procedure TFWDBGrid.WMSetFocus(var Msg: TWMSetFocus);
begin
  Inherited;
  HideColumnControl;
end;

// Procedure ShowControlColumn
// Shows the control of column if exists
procedure TFWDBGrid.ShowControlColumn;
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

procedure TFWDBGrid.WMVScroll(var Message: TWMVScroll);
begin
  inherited;
  HideColumnControl;
end;

function TFWDBGrid.CanEditShow: Boolean;
begin
  if  ( SelectedIndex >= 0 )
  and assigned ( Columns [ SelectedIndex ].SomeEdit )
  and ( Columns [ SelectedIndex ].SomeEdit.Visible ) then
    Begin
     Result := False;
    End
  Else
   Result := inherited CanEditShow;

end;

constructor TFWDBGrid.Create( AOwner: TComponent);
begin
  inherited Create(AOwner);
  FAlwaysSame := True;
  FColorFocus := CST_GRILLE_SELECT;
  FColorEdit  := CST_GRILLE_STD;
  FixedColor  := CST_GRILLE_STD;
  FWBeforeEnter:=nil;
  FWBeforeExit :=nil;
end;

procedure TFWDBGrid.Loaded;
begin
  inherited Loaded;
  FOldFixedColor := FixedColor;
  if  FAlwaysSame
   Then
    FixedColor := gCol_Grid ;
End;

procedure TFWDBGrid.MouseDown(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  inherited;
  ShowControlColumn;
end;

function TFWDBGrid.GetColumns: TFWDbGridColumns;
begin
  {$IFDEF FPC}
  Result := TFWDbGridColumns(TCustomDrawGrid(Self).Columns);
  {$ELSE}
  Result := inherited Columns as TFWDBGridColumns;
  {$ENDIF}
end;

procedure TFWDBGrid.SetColumns(const AValue: TFWDbGridColumns);
begin
  {$IFDEF FPC}
  TFWDbGridColumns(Self.Columns).Assign(Avalue);
  {$ELSE}
  inherited Columns := AValue;
  {$ENDIF}
end;


procedure TFWDBGrid.DrawCell(aCol, aRow: {$IFDEF FPC}Integer{$ELSE}Longint{$ENDIF}; aRect: TRect;
  aState: TGridDrawState);
var OldActive : Integer;
    FBackground: TColor;
begin
  {$IFNDEF FPC}
  if  ( ACol > 0  )
  and ( ARow >= {$IFDEF FPC}1{$ELSE}IndicatorOffset{$ENDIF} )
  and assigned (( TFWGridColumn ( Columns [ ACol - 1 ])).SomeEdit ) Then
   with ( TFWGridColumn ( Columns [ ACol - 1 ])).SomeEdit do
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

function TFWDBGrid.IsColumnsStored: boolean;
begin
  result := True;
end;


procedure TFWDBGrid.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited;
  ShowControlColumn;
end;

procedure TFWDBGrid.KeyUp(var ach_Key: Word; ashi_Shift: TShiftState);
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

function TFWDBGrid.CreateColumns: {$IFDEF FPC}TGridColumns{$ELSE}TDBGridColumns{$ENDIF};
begin
  Result := TFWDbGridColumns.Create(Self, TFWGridColumn);
end;

procedure TFWDBGrid.DoEnter;
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

procedure TFWDBGrid.DoExit;
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
procedure TFWDBGrid.TitleClick(Column: TColumn);
{$ELSE}
procedure TFWDBGrid.DoTitleClick(ACol: Longint; AField: TField);
{$ENDIF}

var li_Tag , li_i : Integer ;
begin
  // Phase d'initialisation
 li_Tag :=(TFWGridColumn ( {$IFDEF EXRX} Column {$ELSE} Columns [ ACol ]{$ENDIF})).FieldTag ;
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


{ TFWDBMemo }

procedure TFWDBMemo.p_setLabel(const alab_Label: TFWLabel);
begin
  if alab_Label <> FLabel Then
    Begin
      FLabel := alab_Label;
      FLabel.MyEdit := Self;
    End;
end;

procedure TFWDBMemo.SetOrder;
begin
  if assigned ( FNotifyOrder ) then
    FNotifyOrder ( Self );
end;

constructor TFWDBMemo.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FAlwaysSame := True;
  FColorLabel := CST_LBL_SELECT;
  FColorEdit  := CST_EDIT_STD;
  FColorFocus := CST_EDIT_SELECT;
  FColorReadOnly := CST_EDIT_READ;
end;

procedure TFWDBMemo.DoEnter;
begin
  if assigned ( FBeforeEnter ) Then
    FBeforeEnter ( Self );
  // Si on arrive sur une zone de saisie, on met en valeur son tlabel par une couleur
  // de fond bleu et son libellé en marron (sauf si le libellé est sélectionné
  // avec la souris => cas de tri)
  p_setLabelColorEnter ( FLabel, FColorLabel, FAlwaysSame );
  p_setCompColorEnter  ( Self, FColorFocus, FAlwaysSame );
  inherited DoEnter;
end;

procedure TFWDBMemo.DoExit;
begin
  if assigned ( FBeforeExit ) Then
    FBeforeExit ( Self );
  inherited DoExit;
  p_setLabelColorExit ( FLabel, FAlwaysSame );
  p_setCompColorExit ( Self, FOldColor, FAlwaysSame );

end;

procedure TFWDBMemo.Loaded;
begin
  inherited Loaded;
  FOldColor := Color;
  if  FAlwaysSame
   Then
    Color := gCol_Edit ;
end;

procedure TFWDBMemo.WMPaint(var Message: {$IFDEF FPC}TLMPaint{$ELSE}TWMPaint{$ENDIF});
Begin
  p_setCompColorReadOnly ( Self,FColorEdit,FColorReadOnly, FAlwaysSame, ReadOnly );
  inherited;
End;


{$IFDEF VERSIONS}
initialization
  // Gestion de version
  p_ConcatVersion(gVer_framework_DBcomponents);
{$ENDIF}
end.

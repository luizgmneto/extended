{*********************************************************************}
{                                                                     }
{                                                                     }
{             Matthieu Giroux                                         }
{             TExtNumEdit  :                                       }
{             Composant edit de nombre              }
{             TExtDBNumEdit :                                       }
{             Composant dbedit de nombre }
{             22 Avril 2006                                           }
{                                                                     }
{                                                                     }
{*********************************************************************}

unit U_ExtNumEdits;

{$IFDEF FPC}
{$mode Delphi}
{$ENDIF}

interface

{$I ..\DLCompilers.inc}
{$I ..\extends.inc}

uses
  Messages,  SysUtils, Classes, Graphics, Controls,
{$IFDEF FPC}
  LCLType, MaskEdit, lmessages, lresources, sqldb,
{$ELSE}
  Windows, Mask, DBTables,
{$ENDIF}
{$IFDEF ADO}
   ADODB,
{$ENDIF}
{$IFDEF VERSIONS}
  fonctions_version,
{$ENDIF}
{$IFDEF TNT}
   TntStdCtrls,
{$ENDIF}
  Forms, Dialogs,  Db, StdCtrls, fonctions_variant,
  DBCtrls, fonctions_numedit, u_extcomponent ;

  const
{$IFDEF VERSIONS}
    gVer_TExtNumEdit : T_Version = ( Component : 'Composant TExtNumEdit' ;
                                               FileUnit : 'U_NumEdits' ;
                                               Owner : 'Matthieu Giroux' ;
                                               Comment : 'Edition de nombres.' ;
                                               BugsStory : '1.0.1.3 : Testing on LAZARUS' + #13#10
                                                         + '1.0.1.2 : Mask on num edit' + #13#10
                                                         + '1.0.1.1 : NumRounded property not tested' + #13#10
                                                         + '1.0.1.0 : Better ExtNumEdit with good colors' + #13#10
                                                         + '1.0.0.1 : Bug rafraîchissement de AValue' + #13#10
                                                         + '1.0.0.0 : Gestion en place.';
                                               UnitType : 3 ;
                                               Major : 1 ; Minor : 0 ; Release : 1 ; Build : 3 );
    gVer_TExtDBNumEdit : T_Version = ( Component : 'Composant TExtDBNumEdit' ;
                                               FileUnit : 'U_NumEdits' ;
                                               Owner : 'Matthieu Giroux' ;
                                               Comment : 'Edition de nombres en données.' ;
                                               BugsStory : '1.0.1.4 : Testing on LAZARUS' + #13#10
                                                         + '1.0.1.3 : Better num edit' + #13#10
                                                         + '1.0.1.2 : NumRounded property not tested' + #13#10
                                                         + '1.0.1.1 : Less methods with good colors' + #13#10
                                                         + '1.0.1.0 : Améliorations sur la gestion des erreurs' + #13#10
                                                         + '1.0.0.0 : Gestion en place.';
                                               UnitType : 3 ;
                                               Major : 1 ; Minor : 0 ; Release : 1 ; Build : 4 );
{$ENDIF}
    CST_MC_NEGATIVE = True ;
    CST_MC_POSITIVE = True ;
    CST_MC_BEFORECOMMA = 42 ;
    CST_MC_AFTERCOMMA  = 2 ;

type

  { TExtNumEdit }

  TExtNumEdit   = class(TCustomMaskEdit, IFWComponent, IFWComponentEdit)
  private
    FCanvas: TControlCanvas;
    FFocused: Boolean;
    FAlwaysSame: Boolean;
    FBeforeEnter: TnotifyEvent;
    FBeforeExit: TnotifyEvent;
    FLabel : {$IFDEF TNT}TTntLabel{$ELSE}TLabel{$ENDIF} ;
    FColorReadOnly,
    FColorFocus ,
    FColorEdit ,
    FOldColor ,
    FColorLabel : TColor;
    FNotifyOrder : TNotifyEvent;
    FOnPopup: TNotifyEvent;
   procedure WMPaint(var Message: {$IFDEF FPC}TLMPaint{$ELSE}TWMPaint{$ENDIF}); message {$IFDEF FPC}LM_PAINT{$ELSE}WM_PAINT{$ENDIF};
  protected
    FNumRounded : TNumRounded;
    gre_AValue: Extended ;
    FAlignment: TAlignment;
    gby_NbAvVirgule ,
    gby_NbApVirgule : Byte ;
    gb_Negatif   ,
    gb_Positif   : Boolean ;
    FMin         ,
    FMax         : Double ;
    gb_Ismasked  ,
    FHasMin      ,
    FHasMax      : Boolean ;
    procedure MouseDown( Button : TMouseButton; Shift : TShiftState; X,Y : Integer); override;
    procedure SetName(const NewName: TComponentName); override;
    function GetText: TCaption;
    procedure KeyPress(var Key: Char); override;
    procedure KeyUp(var Key: Word; Shift: TShiftState); override;
    procedure p_SetValue ( AValue : Extended ); virtual;
    procedure SetFocused(AValue: Boolean); virtual;
    function GetTextMargins: TPoint; virtual;
    procedure Setmask; virtual;
    procedure p_SetNbAvVirgule ( const Avalue : Byte ); virtual;
    procedure p_SetNbApVirgule ( const Avalue : Byte ); virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Loaded; override;
    procedure DoEnter; override;
    procedure DoExit; override;
    procedure SetOrder ; virtual;
  published
    property EditMask ;
    property IsMasked read gb_Ismasked write gb_Ismasked default False;
    property FWBeforeEnter : TnotifyEvent read FBeforeEnter write FBeforeEnter stored False;
    property FWBeforeExit  : TnotifyEvent read FBeforeExit  write FBeforeExit stored False ;
    property AlwaysSame : Boolean read FAlwaysSame write FAlwaysSame default true;
    property Value : Extended read gre_AValue write p_SetValue stored True ;
    property NbPositive : Boolean read gb_Positif write gb_Positif stored True default CST_MC_POSITIVE ;
    property NbNegative : Boolean read gb_Negatif write gb_Negatif stored True default CST_MC_NEGATIVE ;
    property NbBeforeComma : Byte read gby_NbAvVirgule write p_SetNbAvVirgule stored True default CST_MC_BEFORECOMMA;
    property NbAfterComma  : Byte read gby_NbApVirgule write p_SetNbApVirgule stored True default CST_MC_AFTERCOMMA ;
    property ColorLabel : TColor read FColorLabel write FColorLabel default CST_EDIT_SELECT ;
    property ColorEdit : TColor read FColorEdit write FColorEdit default CST_EDIT_STD ;
    property ColorReadOnly : TColor read FColorReadOnly write FColorReadOnly default CST_EDIT_READ ;
    property ColorFocus : TColor read FColorFocus write FColorFocus default CST_EDIT_SELECT ;
    property OnOrder : TNotifyEvent read FNotifyOrder write FNotifyOrder;
    property MyLabel : {$IFDEF TNT}TTntLabel{$ELSE}TLabel{$ENDIF} read FLabel write FLabel;
    property Max : Double read FMax write FMax ;
    property Min : Double read FMin write FMin ;
    property HasMin : Boolean read FHasMin write FHasMin default False;
    property HasMax : Boolean read FHasMax write FHasMax default False;
    property NumRounded : TNumRounded read FNumRounded write FNumRounded default nrNone;
    property OnPopup : TNotifyEvent read FOnPopup write FOnPopup;
    property Anchors;
    property AutoSelect;
    property AutoSize;
  {$IFDEF DELPHI}
    property BevelEdges;
    property BevelInner;
    property BevelKind default bkNone;
    property BevelOuter;
    property ImeMode;
    property ImeName;
    property OEMConvert;
    property HideSelection;
  {$ENDIF}
    property BiDiMode;
    property BorderStyle;
    property CharCase;
    property Color;
    property Constraints;
  {$IFNDEF FPC}
    property Ctl3D;
    property ParentCtl3D;
  {$ENDIF}
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property MaxLength;
    property ParentBiDiMode;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PasswordChar;
    property PopupMenu;
    property ReadOnly;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Text;
    property Visible;
    property OnChange;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
    property OnMouseEnter;
    property OnMouseLeave;
    property Align;

  end;

  { TExtDBNumEdit }

  TExtDBNumEdit = class(TExtNumEdit)
  private
    FDataLink: TFieldDataLink;
    FFormat : String ;
    procedure ActiveChange(Sender: TObject);
    procedure DataChange(Sender: TObject);
    procedure EditingChange(Sender: TObject);
    function GetDataField: string;
    function GetDataSource: TDataSource;
    function GetField: TField;
    procedure ResetMaxLength;
    procedure SetDataField(const AValue: string);
    procedure SetDataSource(AValue: TDataSource);
    procedure UpdateData(Sender: TObject);
    procedure WMCut(var Message: TMessage); message {$IFDEF FPC} LM_CUT {$ELSE} WM_CUT {$ENDIF};
    procedure WMPaste(var Message: TMessage); message {$IFDEF FPC} LM_PASTE {$ELSE} WM_PASTE {$ENDIF};
{$IFNDEF FPC}
    procedure WMUndo(var Message: TMessage); message WM_UNDO;
{$ENDIF}
{$IFDEF FPC}
    procedure WMEnter(var Message: TLMEnter); message LM_ENTER;
    procedure WMExit(var Message: TLMExit); message LM_EXIT;
{$ELSE}
    procedure CMEnter(var Message: TCMEnter); message CM_ENTER;
    procedure CMExit(var Message: TCMExit); message CM_EXIT;
{$ENDIF}
    procedure CMGetDataLink(var Message: TMessage); message CM_GETDATALINK;
   protected
{$IFDEF FPC}
    procedure SetReadOnly(AValue: Boolean); override;
{$ENDIF}
    procedure SetFocused(AValue: Boolean); override;
    procedure p_SetValue ( AValue : Extended ); override ;
    procedure Change; override;
    function EditCanModify: Boolean; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    procedure Reset; override;
   public
 {$IFDEF FPC}
     procedure Undo; override;
 {$ENDIF}
    procedure Loaded; override;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function ExecuteAction(AAction: TBasicAction): Boolean; override;
    function UpdateAction(AAction: TBasicAction): Boolean; override;
    function UseRightToLeftAlignment: Boolean; override;
    property Field: TField read GetField;
   published
    property EditMask : String read FFormat write FFormat ;
    property Value stored False ;
    property DataField: string read GetDataField write SetDataField;
    property DataSource: TDataSource read GetDataSource write SetDataSource;
   end;

implementation

uses
{$IFDEF FPC}
    LCLIntf, tmschema,
{$ENDIF}
    fonctions_erreurs, fonctions_string,
    fonctions_proprietes ;

{ TExtDBNumEdit }

procedure TExtDBNumEdit.ResetMaxLength;
var
  F: TField;
begin
  if (MaxLength > 0) and Assigned(DataSource) and Assigned(DataSource.DataSet) then
  begin
    F := DataSource.DataSet.FindField(DataField);
    if Assigned(F) and (F.DataType in [ftString, ftWideString]) and (F.Size = MaxLength) then
      MaxLength := 0;
  end;
end;

constructor TExtDBNumEdit.Create(AOwner: TComponent);
begin
  FDataLink := TFieldDataLink.Create;
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csReplicatable];
  FDataLink.Control := Self;
  FDataLink.OnDataChange := DataChange;
  FDataLink.OnEditingChange := EditingChange;
  FDataLink.OnUpdateData := UpdateData;
  FDataLink.OnActiveChange := ActiveChange;
end;

destructor TExtDBNumEdit.Destroy;
begin
  inherited Destroy;
  FDataLink.Free;
  FDataLink := nil;
end;


procedure TExtDBNumEdit.Loaded;
begin
  inherited Loaded;
  ResetMaxLength;
  if (csDesigning in ComponentState) then DataChange(Self);
end;

{ AField is needed because TDBLookupComboBox, for its combobox, uses FListField
  for its alignment characteristics not FField }
function DBUseRightToLeftAlignment(AControl: TControl; AField: TField): Boolean;
var
  AAlignment: TAlignment;
begin
  if Assigned(AField) then
    AAlignment := AField.Alignment
  else
    AAlignment := taLeftJustify;
  Result := (SysLocale.MiddleEast) and (AControl.BiDiMode = bdRightToLeft)
{$IFDEF DELPHI}  and (OkToChangeFieldAlignment(AField, AAlignment)){$ENDIF};
end;

procedure TExtDBNumEdit.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (FDataLink <> nil) and
    (AComponent = DataSource) then DataSource := nil;
end;

function TExtDBNumEdit.UseRightToLeftAlignment: Boolean;
begin
  Result := DBUseRightToLeftAlignment(Self, Field);
end;

procedure TExtDBNumEdit.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited KeyDown(Key, Shift);
  if (Key = VK_DELETE) or ((Key = VK_INSERT) and (ssShift in Shift)) then
    FDataLink.Edit;
end;

function TExtDBNumEdit.EditCanModify: Boolean;
begin
  Result := FDataLink.Edit;
end;

procedure TExtDBNumEdit.Reset;
begin
  FDataLink.Reset;
  SelectAll;
end;

procedure TExtDBNumEdit.Change;
begin
  if assigned ( FDataLink.Field ) Then
    if FDataLink.Field.IsNull then
      gre_AValue := 0
    Else
      gre_AValue := FDataLink.Field.Value ;
  FDataLink.Modified;
  inherited Change;
end;

function TExtDBNumEdit.GetDataSource: TDataSource;
begin
  Result := FDataLink.DataSource;
end;

procedure TExtDBNumEdit.SetDataSource(AValue: TDataSource);
begin
  if not (FDataLink.DataSourceFixed and (csLoading in ComponentState)) then
    FDataLink.DataSource := AValue;
  if AValue <> nil then AValue.FreeNotification(Self);
end;

procedure TExtDBNumEdit.SetFocused(AValue: Boolean);
begin
  inherited SetFocused(AValue);
  FDataLink.Reset;
end;

function TExtDBNumEdit.GetDataField: string;
begin
  Result := FDataLink.FieldName;
end;

procedure TExtDBNumEdit.SetDataField(const AValue: string);
begin
  if not (csDesigning in ComponentState) then
    ResetMaxLength;
  if  assigned ( FDataLink.DataSet )
  and FDataLink.DataSet.Active Then
    Begin
      if assigned ( FDataLink.DataSet.FindField ( AValue ))
      and ( FDataLink.DataSet.FindField ( AValue ) is TNumericField ) Then
        FDataLink.FieldName := AValue;
    End
  Else
    FDataLink.FieldName := AValue;
end;
{$IFDEF FPC}
procedure TExtDBNumEdit.SetReadOnly(AValue: Boolean);
begin
  Inherited SetReadOnly(AValue);
  p_setCompColorReadOnly ( Self,FColorEdit,FColorReadOnly, FAlwaysSame, ReadOnly );
end;
{$ENDIF}

function TExtDBNumEdit.GetField: TField;
begin
  Result := FDataLink.Field;
end;

procedure TExtDBNumEdit.ActiveChange(Sender: TObject);
begin
  ResetMaxLength;
  if assigned ( FDataLink.Field ) then
    Begin
      p_setComponentProperty ( FDataLink.Field, 'DisplayFormat', FFormat );
    End;
end;

procedure TExtDBNumEdit.DataChange(Sender: TObject);
begin
  if FDataLink.Field <> nil then
  begin
    if FAlignment <> FDataLink.Field.Alignment then
    begin
      EditText := '';  {forces update}
      FAlignment := FDataLink.Field.Alignment;
    end;
  {$IFDEF DELPHI}
    EditMask := FDataLink.Field.EditMask;
  {$ENDIF}
    if not (csDesigning in ComponentState) then
    begin
      if (FDataLink.Field.DataType in [ftString, ftWideString]) and (MaxLength = 0) then
        MaxLength := FDataLink.Field.Size;
    end;
    if FFocused and FDataLink.CanModify then
      Text := FDataLink.Field.Text
    else
    begin
      EditText := FDataLink.Field.DisplayText;
      if FDataLink.Editing and assigned ( FDataLink.Dataset ) and FDataLink.Dataset.Modified then
        Modified := True;
    end;
  end else
  begin
    FAlignment := taLeftJustify;
    EditMask := '';
    if csDesigning in ComponentState then
      EditText := Name else
      EditText := '';
  end;
end;

procedure TExtDBNumEdit.EditingChange(Sender: TObject);
begin
  ReadOnly := not FDataLink.CanModify;
end;

procedure TExtDBNumEdit.UpdateData(Sender: TObject);
begin
  ValidateEdit;
  FDataLink.Field.Text := Text;
end;
{$IFDEF FPC}
procedure TExtDBNumEdit.Undo;
{$ELSE}
procedure TExtDBNumEdit.WMUndo(var Message: TMessage);
{$ENDIF}
begin
  FDataLink.Edit;
  inherited;
end;

procedure TExtDBNumEdit.WMPaste(var Message: TMessage);
begin
  FDataLink.Edit;
  inherited;
end;

procedure TExtDBNumEdit.WMCut(var Message: TMessage);
begin
  FDataLink.Edit;
  inherited;
end;

{$IFDEF FPC}
procedure TExtDBNumEdit.WMEnter(var Message: TLMEnter);
{$ELSE}
procedure TExtDBNumEdit.CMEnter(var Message: TCMEnter);
{$ENDIF}
begin
  SetFocused(True);
  inherited;
  if SysLocale.FarEast and FDataLink.CanModify then
    ReadOnly := False;
end;

{$IFDEF FPC}
procedure TExtDBNumEdit.WMExit(var Message: TLMExit);
{$ELSE}
procedure TExtDBNumEdit.CMExit(var Message: TCMExit);
{$ENDIF}
var laco_connecteur : TCustomConnection ;
begin
  try
    FDataLink.UpdateRecord;
  except
    on e: Exception do
      Begin
        SelectAll;
        SetFocus;
        laco_connecteur := nil ;
        f_GereException ( e, FDataLink.DataSet, laco_connecteur , False )
      End ;
  end;
  SetFocused(False);
{$IFDEF DELPHI}
  CheckCursor;
{$ENDIF}
  DoExit;
end;

procedure ChangeBiDiModeAlignment(var Alignment: TAlignment);
begin
  case Alignment of
    taLeftJustify:  Alignment := taRightJustify;
    taRightJustify: Alignment := taLeftJustify;
  end;
end;



procedure TExtDBNumEdit.CMGetDataLink(var Message: TMessage);
begin
  Message.Result := Integer(FDataLink);
end;

function TExtDBNumEdit.ExecuteAction(AAction: TBasicAction): Boolean;
begin
  Result := inherited ExecuteAction(AAction) or (FDataLink <> nil)
    {$IFDEF DELPHI}
   and FDataLink.ExecuteAction(AAction)
    {$ENDIF};
end;

function TExtDBNumEdit.UpdateAction(AAction: TBasicAction): Boolean;
begin
  Result := inherited UpdateAction(AAction) or (FDataLink <> nil)
    {$IFDEF DELPHI}
    and FDataLink.UpdateAction(AAction)
    {$ENDIF};
end;

procedure TExtDBNumEdit.p_SetValue(AValue: Extended);
begin
  if AValue <> gre_AValue Then
    Begin
      gre_AValue := fext_CalculateNumber(AValue,FNumRounded, gby_NbApVirgule );
      if assigned ( FDataLink.Field ) Then
        Begin
          FDataLink.DataSet.Edit ;
          FDataLink.Field.Value := gre_AValue ;
        End
      Else
        Text := FloatToStr ( gre_AValue );
    End ;

end;


{ TExtNumEdit }

constructor TExtNumEdit.Create(AOwner: TComponent);
begin
  inherited;
  gb_Ismasked := False;
  FAlwaysSame := True;
  gby_NbAvVirgule := CST_MC_BEFORECOMMA ;
  gby_NbApVirgule := CST_MC_AFTERCOMMA ;
  gb_Negatif   := CST_MC_NEGATIVE ;
  gb_Positif   := CST_MC_POSITIVE ;
  FColorReadOnly := CST_EDIT_READ;
  FColorLabel := CST_LBL_SELECT;
  FColorEdit  := CST_EDIT_STD;
  FColorFocus := CST_EDIT_SELECT;
  FMin := 0;
  FMax := 0;
  FHasMin := false;
  FHasMax := false;
  FNumRounded := nrNone;
end;

function TExtNumEdit.GetTextMargins: TPoint;
var
  DC: HDC;
  SaveFont: HFont;
  I: Integer;
  SysMetrics, Metrics: TTextMetric;
begin
  if NewStyleControls then
  begin
    if BorderStyle = bsNone then I := 0 else
      {$IFNDEF FPC} if Ctl3D then I := 1 else{$ENDIF} I := 2;

    {$IFDEF DELPHI}
    Result.X := SendMessage(Handle, EM_GETMARGINS, 0, 0) and $0000FFFF + I;
    {$ENDIF}
    Result.Y := I;
  end else
  begin
    if BorderStyle = bsNone then I := 0 else
    begin
      DC := GetDC(0);
      GetTextMetrics(DC, SysMetrics);
      SaveFont := SelectObject(DC, Font.Handle);
      GetTextMetrics(DC, Metrics);
      SelectObject(DC, SaveFont);
      ReleaseDC(0, DC);
      I := SysMetrics.tmHeight;
      if I > Metrics.tmHeight then I := Metrics.tmHeight;
      I := I div 4;
    end;
    Result.X := I;
    Result.Y := I;
  end;
end;

procedure TExtNumEdit.Setmask;
var ls_Mask : String;
begin
  if gb_Ismasked Then
    Begin
      ls_Mask := '#0';
      if gby_NbApVirgule > 0 Then
        ls_Mask := ls_Mask + {$IFDEF FORMATSETTING}FormatSettings.{$ENDIF}DecimalSeparator + '#9' ;
      ls_Mask := ';0; ';
      EditMask := ls_Mask;

    end;

end;

procedure TExtNumEdit.p_SetNbAvVirgule(const Avalue: Byte);
begin
  if Avalue <> gby_NbAvVirgule Then
   Begin
     gby_NbAvVirgule := Avalue;
     SetMask;
   end;
end;

procedure TExtNumEdit.p_SetNbApVirgule(const Avalue: Byte);
begin
  if Avalue <> gby_NbApVirgule Then
   Begin
     gby_NbApVirgule := Avalue;
     SetMask;
   end;

end;


destructor TExtNumEdit.Destroy;
begin
  FCanvas.Free;
  inherited;
end;

procedure TExtNumEdit.DoEnter;
begin
  if assigned ( FBeforeEnter ) Then
    FBeforeEnter ( Self );
  // Si on arrive sur une zone de saisie, on met en valeur son {$IFDEF TNT}TTntLabel{$ELSE}TLabel{$ENDIF} par une couleur
  // de fond bleu et son libellé en marron (sauf si le libellé est sélectionné
  // avec la souris => cas de tri)
  p_setLabelColorEnter ( FLabel, FColorLabel, FAlwaysSame );
  p_setCompColorEnter  ( Self, FColorFocus, FAlwaysSame );
  inherited DoEnter;
end;

procedure TExtNumEdit.SetFocused(AValue: Boolean);
begin
  if FFocused <> AValue then
  begin
    FFocused := AValue;
    if (FAlignment <> taLeftJustify) and not IsMasked then Invalidate;
  end;
end;


procedure TExtNumEdit.DoExit;
begin
  if assigned ( FBeforeExit ) Then
    FBeforeExit ( Self );
  inherited DoExit;
  p_setLabelColorExit ( FLabel, FAlwaysSame );
  p_setCompColorExit ( Self, FOldColor, FAlwaysSame );
end;

function TExtNumEdit.GetText: TCaption;
var
  Len: Integer;
begin
  Len := GetTextLen;
  SetString(Result, PChar(nil), Len);
  if Len <> 0 then GetTextBuf(Pointer(Result), Len + 1);

end;

procedure TExtNumEdit.KeyPress(var Key: Char);
begin
  p_editGridKeyPress ( Self, Key,gby_NbApVirgule, gby_NbAvVirgule, gb_Negatif, SelStart, Text, SelText, gby_NbApVirgule > 0 );

  if  ( FHasMax )
  and ( Value > FMax )  then
    Begin
      Value := FMax ;
    End;

  if  ( FHasMin )
  and ( Value < FMin )  then
    Begin
      Value := FMin ;
    End;

  inherited;

end;

procedure TExtNumEdit.KeyUp(var Key: Word; Shift: TShiftState);
var lext_Value : Extended;
begin
  lext_Value := gre_AValue;
  p_editKeyUp ( lext_Value, Self, Key,gby_NbApVirgule, gby_NbAvVirgule, gb_Negatif, Text );
  Value := lext_Value;
  try
    if  ( Text <> '' )
    and ( Text <> '+' )
    and ( Text <> '-' ) Then
      gre_AValue := StrToFloat ( fs_remplaceEspace ( Text, '' ))
    Else
      gre_AValue := 0 ;
  Except
  End ;
  inherited;

end;

procedure TExtNumEdit.p_SetValue(AValue: Extended);
begin
  if AValue <> gre_AValue Then
    Begin
      gre_AValue:=fext_CalculateNumber(AValue,FNumRounded, gby_NbApVirgule);
      Text := FloatToStr ( gre_AValue );
    End ;

end;

procedure TExtNumEdit.WMPaint(var Message: {$IFDEF FPC}TLMPaint{$ELSE}TWMPaint{$ENDIF});
const
  AlignStyle : array[Boolean, TAlignment] of DWORD =
   ((WS_EX_LEFT, WS_EX_RIGHT, WS_EX_LEFT),
    (WS_EX_RIGHT, WS_EX_LEFT, WS_EX_LEFT));
var
  ALeft: Integer;
  Margins: TPoint;
  R: TRect;
  DC: HDC;
  PS: TPaintStruct;
  S: string;
  AAlignment: TAlignment;
  ExStyle: DWORD;
begin
  p_setCompColorReadOnly ( Self,FColorEdit,FColorReadOnly, FAlwaysSame, ReadOnly );
  AAlignment := FAlignment;
  if UseRightToLeftAlignment then ChangeBiDiModeAlignment(AAlignment);
  if ((AAlignment = taLeftJustify) or FFocused) and
    not (csPaintCopy in ControlState) then
  begin
    if SysLocale.MiddleEast and HandleAllocated and (IsRightToLeft) then
    begin { This keeps the right aligned text, right aligned }
      ExStyle := DWORD(GetWindowLong(Handle, GWL_EXSTYLE)) and (not WS_EX_RIGHT) and
        (not WS_EX_RTLREADING) and (not WS_EX_LEFTSCROLLBAR);
      if UseRightToLeftReading then ExStyle := ExStyle or WS_EX_RTLREADING;
      if UseRightToLeftScrollbar then ExStyle := ExStyle or WS_EX_LEFTSCROLLBAR;
      ExStyle := ExStyle or
        AlignStyle[UseRightToLeftAlignment, AAlignment];
      if DWORD(GetWindowLong(Handle, GWL_EXSTYLE)) <> ExStyle then
        SetWindowLong(Handle, GWL_EXSTYLE, ExStyle);
    end;
    inherited;
    Exit;
  end;
{ Since edit controls do not handle justification unless multi-line (and
  then only poorly) we will draw right and center justify manually unless
  the edit has the focus. }
  if FCanvas = nil then
  begin
    FCanvas := TControlCanvas.Create;
    FCanvas.Control := Self;
  end;
  DC := Message.DC;
  if DC = 0 then DC := BeginPaint(Handle, PS);
  FCanvas.Handle := DC;
  try
    FCanvas.Font := Font;
    with FCanvas do
    begin
      R := ClientRect;
      if {$IFNDEF FPC} not (NewStyleControls and Ctl3D) and {$ENDIF}  (BorderStyle = bsSingle) then
      begin
        Brush.Color := clWindowFrame;
        FrameRect(R);
        InflateRect(R, -1, -1);
      end;
      Brush.Color := Color;
      if not Enabled then
        Font.Color := clGrayText;
      if (csPaintCopy in ControlState) then
      begin
        S := Text;
        case CharCase of
          ecUpperCase: S := AnsiUpperCase(S);
          ecLowerCase: S := AnsiLowerCase(S);
        end;
      end else
        S := EditText;
      if PasswordChar <> #0 then FillChar(S[1], Length(S), PasswordChar);
      Margins := GetTextMargins;
      case AAlignment of
        taLeftJustify: ALeft := Margins.X;
        taRightJustify: ALeft := ClientWidth - TextWidth(S) - Margins.X - 1;
      else
        ALeft := (ClientWidth - TextWidth(S)) div 2;
      end;
    {$IFDEF DELPHI}
      if SysLocale.MiddleEast then UpdateTextFlags;
     {$ENDIF}
      TextRect(R, ALeft, Margins.Y, S);
    end;
  finally
    FCanvas.Handle := 0;
    if Message.DC = 0 then EndPaint(Handle, PS);
  end;
End;

procedure TExtNumEdit.MouseDown(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  inherited MouseDown(Button, Shift, X, Y);
  if Button = mbRight Then
   fb_ShowPopup (Self,PopUpMenu,OnContextPopup,FOnPopup);
end;

procedure TExtNumEdit.SetName(const NewName: TComponentName);
begin
  inherited SetName(NewName);
  Text := '0' ;
end;

procedure TExtNumEdit.Loaded;
begin
  inherited Loaded;
  FOldColor := Color;
  if  FAlwaysSame
   Then
    Color := gCol_Edit ;
end;

procedure TExtNumEdit.SetOrder;
begin
  if assigned ( FNotifyOrder ) then
    FNotifyOrder ( Self );
end;


{$IFDEF VERSIONS}
initialization
  p_ConcatVersion ( gVer_TExtNumEdit  );
  p_ConcatVersion ( gVer_TExtDBNumEdit );
{$ENDIF}
end.

{*********************************************************************}
{                                                                     }
{                                                                     }
{             Matthieu Giroux                                         }
{             TExtPictCombo :                                        }
{             Objet de choix de couleur                               }
{             qui permet de personnalisé la couleur du titre          }
{             de l'onglet actif                                       }
{             10 Mars 2006                                            }
{                                                                     }
{                                                                     }
{*********************************************************************}

unit U_ExtPictCombo;

{$I ..\DLCompilers.inc}
{$I ..\extends.inc}
{$IFDEF FPC}
{$mode Delphi}
{$ENDIF}

{$I ..\DLCompilers.inc}

interface

uses
{$IFDEF FPC}
  LCLIntf, LCLType, lMessages, lresources,
{$ELSE}
  Windows,
{$ENDIF}
{$IFDEF TNT}
   TntStdCtrls,
{$ENDIF}
  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, DB, DBCtrls, fonctions_erreurs, fonctions_version,
  u_extcomponent, ImgList, U_ExtMapImageIndex ;

const
{$IFDEF VERSIONS}
    gVer_TExtPictCombo : T_Version = ( Component : 'Composant TExtPictCombo' ;
                                               FileUnit : 'U_ExtPictCombo' ;
                                               Owner : 'Matthieu Giroux' ;
                                               Comment : 'Choisir une image dans une liste.' ;
                                               BugsStory : '0.8.0.0 : Not tested.';
                                               UnitType : 3 ;
                                               Major : 0 ; Minor : 8 ; Release : 0 ; Build : 0 );

    gVer_TExtDbPictCombo : T_Version = ( Component : 'Composant TExtDbPictCombo' ;
                                               FileUnit : 'U_ExtPictCombo' ;
                                               Owner : 'Matthieu Giroux' ;
                                               Comment : 'Choisir une image dans une liste.' ;
                                               BugsStory : '0.8.0.0 : Not tested.';
                                               UnitType : 3 ;
                                               Major : 0 ; Minor : 8 ; Release : 0 ; Build : 0 );

{$ENDIF}
    CST_PICT_COMBO_DEFAULT_STYLE       = csOwnerDrawFixed ;
type

  { TExtPictCombo }

  TExtPictCombo = class(TCustomComboBox, IFWComponent, IFWComponentEdit, IMapImageComponent)
    private
      FImages : TCustomImageList;
      FMapImagesColumns : TExtMapImagesColumns;
      FBeforeEnter, FBeforeExit : TNotifyEvent;
      FLabel : {$IFDEF TNT}TTntLabel{$ELSE}TLabel{$ENDIF} ;
      FNotifyOrder : TNotifyEvent;
      FOldColor ,
      FColorFocus ,
      FColorReadOnly,
      FColorEdit ,
      FColorLabel : TColor;
      FReadOnly   ,
      FAlwaysSame : Boolean;
      FValue : String;
      procedure p_SetImages ( const Value : TCustomImageList );
      procedure p_setLabel ( const alab_Label : {$IFDEF TNT}TTntLabel{$ELSE}TLabel{$ENDIF} );
      procedure WMPaint(var Message: {$IFDEF FPC}TLMPaint{$ELSE}TWMPaint{$ENDIF}); message {$IFDEF FPC}LM_PAINT{$ELSE}WM_PAINT{$ENDIF};
    protected
    { Protected declarations }
      procedure DrawAnImage( const AIndex : Longint; const ARect: TRect; var novorect : TRect ); virtual ;
      procedure p_SetValue(const AValue: String); virtual ;
    protected
      procedure CreateWnd; override;
      procedure CreateImagesMap; virtual;
      function GetReadOnly: Boolean; virtual;
      procedure SetReadOnly(Value: Boolean); virtual;
    public
    { Public declarations }
      constructor Create(AOwner: TComponent); override;
      procedure DoEnter; override;
      procedure DoExit; override;
      procedure SetOrder ; virtual;
      procedure Loaded; override;
      procedure Change; override;
      procedure DrawItem(Index: Integer; ARect: TRect; State: TOwnerDrawState); override;
      function Focused : Boolean; override ;
    published
    { Published declarations }
      property Images : TCustomImageList read FImages write p_SetImages ;
      property ImagesMap : TExtMapImagesColumns read FMapImagesColumns ;
      property Value : String read FValue write p_SetValue;
      property ReadOnly: Boolean read GetReadOnly write SetReadOnly stored True default False;
      property OnOrder : TNotifyEvent read FNotifyOrder write FNotifyOrder;
    // Visuel
      property FWBeforeEnter : TnotifyEvent read FBeforeEnter write FBeforeEnter stored False;
      property FWBeforeExit  : TnotifyEvent read FBeforeExit  write FBeforeExit stored False ;
      property ColorLabel : TColor read FColorLabel write FColorLabel default CST_LBL_SELECT ;
      property ColorFocus : TColor read FColorFocus write FColorFocus default CST_EDIT_SELECT ;
      property ColorEdit : TColor read FColorEdit write FColorEdit default CST_EDIT_STD ;
      property ColorReadOnly : TColor read FColorReadOnly write FColorReadOnly default CST_EDIT_READ ;
      property MyLabel : {$IFDEF TNT}TTntLabel{$ELSE}TLabel{$ENDIF} read FLabel write p_setLabel;
      property AlwaysSame : Boolean read FAlwaysSame write FAlwaysSame default true;
      property OnOrder : TNotifyEvent read FNotifyOrder write FNotifyOrder;
    // Propriétés gardées
      property AutoComplete;
      property AutoDropDown;
{$IFDEF DELPHI}
      property AutoCloseUp;
      property BevelEdges;
      property BevelInner;
      property BevelKind;
      property BevelOuter;
      property ImeMode;
      property ImeName;
{$ENDIF}
      property Anchors;
      property BiDiMode;
      property Color;
      property Constraints;
    {$IFNDEF FPC}
    property Ctl3D;
    property ParentCtl3D;
    {$ENDIF}
    property DragCursor;
    property DragKind;
    property DragMode;
    property DropDownCount;
    property Enabled;
    property Font;
    property ItemHeight;
    property ParentBiDiMode;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnChange;
    property OnClick;
    property OnCloseUp;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnDrawItem;
    property OnDropDown;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMeasureItem;
    property OnSelect;
    property OnStartDock;
    property OnStartDrag;
  end;

  TExtDBPictCombo  = class( TExtPictCombo )
    private
      FDataLink: TFieldDataLink;
      function GetDataField: string;
      function GetDataSource: TDataSource;
      function GetField: TField;
      procedure SetDataField(const AValue: string);
      procedure SetDataSource(AValue: TDataSource);
      procedure WMCut(var Message: TMessage); message {$IFDEF FPC} LM_CUT {$ELSE} WM_CUT {$ENDIF};
      procedure WMPaste(var Message: TMessage); message {$IFDEF FPC} LM_PASTE {$ELSE} WM_PASTE {$ENDIF};
    {$IFDEF FPC}
    {$ELSE}
      procedure WMUndo(var Message: TMessage); message WM_UNDO;
    {$ENDIF}
      procedure CMExit(var Message: {$IFDEF FPC} TLMExit {$ELSE} TCMExit {$ENDIF}); message CM_EXIT;
      procedure CMGetDataLink(var Message: TMessage); message CM_GETDATALINK;
    protected
      procedure ActiveChange(Sender: TObject); virtual;
      procedure DataChange(Sender: TObject); virtual;
      procedure UpdateData(Sender: TObject); virtual;
      function GetReadOnly: Boolean; override;
      procedure SetReadOnly(AValue: Boolean); override;
      procedure p_SetValue(const AValue: String); override ;
      procedure KeyDown(var Key: Word; Shift: TShiftState); override;
      procedure KeyPress(var Key: Char); override;
      procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    public
      procedure Loaded; override;
      procedure Change; override;
      constructor Create(AOwner: TComponent); override;
      destructor Destroy; override;
      function ExecuteAction(AAction: TBasicAction): Boolean; override;
      function UpdateAction(AAction: TBasicAction): Boolean; override;
      property Field: TField read GetField;
    published
      property Value stored False ;
      property DataField: string read GetDataField write SetDataField stored True;
      property DataSource: TDataSource read GetDataSource write SetDataSource stored True;
    end;


implementation

uses unite_messages, fonctions_proprietes, fonctions_images;


{ TExtPictCombo }

constructor TExtPictCombo.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FValue := '' ;

  //Visuel
  FReadOnly   := False;
  FAlwaysSame := True;
  FColorLabel := CST_LBL_SELECT;
  FColorEdit  := CST_EDIT_STD;
  FColorFocus := CST_EDIT_SELECT;
  FColorReadOnly := CST_EDIT_READ;
end;

procedure TExtPictCombo.CreateWnd;
var a :  Integer;
begin
  inherited CreateWnd;
  if ( Items.Count <> FMapImagesColumns.Count ) then
   Begin
     Items.BeginUpdate;
     Items.Clear;
     for a:=0 to FMapImagesColumns.Count - 1 do Items.add(FMapImagesColumns.Items[a].Value);
     Items.EndUpdate;
   End;
end;

procedure TExtPictCombo.SetOrder;
begin
  if assigned ( FNotifyOrder ) then
    FNotifyOrder ( Self );
end;

procedure TExtPictCombo.p_SetImages(const Value: TCustomImageList);
begin
  FImages:= Value;
end;

procedure TExtPictCombo.p_setLabel(const alab_Label: {$IFDEF TNT}TTntLabel{$ELSE}TLabel{$ENDIF});
begin
  if alab_Label <> FLabel Then
    Begin
      FLabel := alab_Label;
      p_SetComponentObjectProperty ( FLabel, 'MyEdit', Self );
    End;
end;

function TExtPictCombo.GetReadOnly: Boolean;
begin
  Result := FReadOnly;
end;

procedure TExtPictCombo.SetReadOnly(Value: Boolean);
begin
  FReadOnly := Value;
end;


procedure TExtPictCombo.DoEnter;
begin
  if assigned ( FBeforeEnter ) Then
    FBeforeEnter ( Self );
  // Si on arrive sur une zone de saisie, on met en valeur son {$IFDEF TNT}TTntLabel{$ELSE}TLabel{$ENDIF} par une couleur
  // de fond bleu et son libellÃ© en marron (sauf si le libellÃ© est sÃ©lectionnÃ©
  // avec la souris => cas de tri)
  p_setLabelColorEnter ( FLabel, FColorLabel, FAlwaysSame );
  p_setCompColorEnter  ( Self, FColorFocus, FAlwaysSame );
  inherited DoEnter;
end;

procedure TExtPictCombo.DoExit;
begin
  if assigned ( FBeforeExit ) Then
    FBeforeExit ( Self );
  inherited DoExit;
  p_setLabelColorExit ( FLabel, FAlwaysSame );
  p_setCompColorExit ( Self, FOldColor, FAlwaysSame );

end;

procedure TExtPictCombo.Loaded;
begin
  inherited Loaded;
  FOldColor := Color;
  if  FAlwaysSame
   Then
    Color := gCol_Edit ;
end;

procedure TExtPictCombo.WMPaint(var Message: {$IFDEF FPC}TLMPaint{$ELSE}TWMPaint{$ENDIF});
Begin
  p_setCompColorReadOnly ( Self,FColorEdit,FColorReadOnly, FAlwaysSame, ReadOnly );
  inherited;
End;

procedure TExtPictCombo.DrawAnImage ( const AIndex : Longint; const ARect: TRect; var novorect : TRect );
var
   FImage:TBitmap;
Begin
 novorect:= rect(arect.Left+4, arect.Top+1, 24, arect.bottom-1);
 if AIndex < FImages.Count
  Then
    Begin
      FImage := TBitmap.Create;
      FImages.GetBitmap(AIndex,FImage);
      p_ChangeTailleBitmap(FImage,novorect.Right,novorect.Bottom,True);
      Canvas.Draw(novorect.Left,novorect.Top,FImage);
      {$IFNDEF FPC}
      FImage.Dormant;
      {$ENDIF}
      FImage.FreeImage;
      FImage.Free;
    end;
 novoRect := rect(ARect.Left + 30, arect.top, arect.right - 5, arect.bottom);
end;

procedure TExtPictCombo.DrawItem(Index: Integer;
  ARect: TRect; State: TOwnerDrawState);
var
      novorect: trect;
      format : Uint ;
begin
    with Canvas do
    begin
      FillRect(ARect);
      novorect:=ARect;
      if assigned ( FImages )
      and ( Index < FMapImagesColumns.Count ) Then
       Begin
         DrawAnImage ( FMapImagesColumns.Items[Index].ImageIndex, ARect, novorect );
       end
      Else
       novoRect := arect;

      format := DT_SINGLELINE or DT_NOPREFIX;
      if ( BiDiMode = bdLeftToRight )
      or (( BiDiMode = bdRightToLeftReadingOnly ) and not DroppedDown ) Then
        format := format or DT_LEFT
      Else
        format := format or DT_RIGHT ;
      if BiDiMode <> bdRightToLeftNoAlign Then
        format := format or DT_VCENTER ;
      if Index < Items.Count Then
        DrawText(Canvas.Handle, Pchar ( Items [ Index] ), Length(Items [ Index]), novoRect, format );
    end;
end;

procedure TExtPictCombo.CreateImagesMap;
begin
 FMapImagesColumns := TExtMapImagesColumns.Create(Self,TExtMapImageIndex);

end;

procedure TExtPictCombo.Change;
begin
   if  ( itemindex >= 0 )
   and ( itemindex < FMapImagesColumns.Count )
    Then
     p_SetValue(FMapImagesColumns.Items[ItemIndex].Value)
    Else
     p_SetValue('');
  inherited change;
end;

procedure TExtPictCombo.p_SetValue(const AValue: String);
begin
 if FValue <> AValue then
   Begin
     FValue:=AValue;
   end;
end;


function TExtPictCombo.Focused: Boolean;
begin
  Result := csFocusing in ControlState ;
end;


{ TExtDBPictCombo }
constructor TExtDBPictCombo.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDataLink := TFieldDataLink.Create ;
  FDataLink.DataSource := nil ;
  FDataLink.FieldName  := '' ;
  FDataLink.Control := Self;
  FDataLink.OnDataChange := DataChange;
  FDataLink.OnUpdateData := UpdateData;
  FDataLink.OnActiveChange := ActiveChange;
  ControlStyle := ControlStyle + [csReplicatable];
end;

destructor TExtDBPictCombo.Destroy;
begin
  inherited Destroy;
  FDataLink.Free ;
end;

procedure TExtDBPictCombo.Loaded;
begin
  inherited Loaded;
  if (csDesigning in ComponentState) then
    Begin
      DataChange(Self);
    End ;
end;

procedure TExtDBPictCombo.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (FDataLink <> nil) and
    (AComponent = DataSource) then DataSource := nil;
end;

procedure TExtDBPictCombo.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited KeyDown(Key, Shift);
  if (Key = VK_DELETE) or ((Key = VK_INSERT) and (ssShift in Shift)) then
    FDataLink.Edit;
end;

procedure TExtDBPictCombo.KeyPress(var Key: Char);
begin
  inherited KeyPress(Key);
  if (Key in [#32..#255]) and (FDataLink.Field <> nil) and
    not FDataLink.Field.IsValidChar(Key) then
  begin
    {$IFDEF DELPHI}
    MessageBeep(0);
    {$ENDIF}
    Key := #0;
  end;
  case Key of
    ^H, ^V, ^X, #32..#255:
      FDataLink.Edit;
    #27:
      begin
        FDataLink.Reset;
        SelectAll;
        Key := #0;
      end;
  end;
end;

procedure TExtDBPictCombo.Change;
begin
  inherited Change;
  if assigned ( FDataLink.Field ) Then
    if FDataLink.Field.IsNull then
      p_SetValue ( '' )
    Else
      p_SetValue ( FDataLink.Field.AsString );
  FDataLink.Modified;
end;

function TExtDBPictCombo.GetDataSource: TDataSource;
begin
  Result := FDataLink.DataSource;
end;

procedure TExtDBPictCombo.SetDataSource(AValue: TDataSource);
begin
  if not (FDataLink.DataSourceFixed and (csLoading in ComponentState)) then
    FDataLink.DataSource := AValue;
  if AValue <> nil then AValue.FreeNotification(Self);
end;

function TExtDBPictCombo.GetDataField: string;
begin
  Result := FDataLink.FieldName;
end;

procedure TExtDBPictCombo.SetDataField(const AValue: string);
begin
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

function TExtDBPictCombo.GetReadOnly: Boolean;
begin
  Result := FDataLink.ReadOnly;
end;

procedure TExtDBPictCombo.SetReadOnly(AValue: Boolean);
begin
  FDataLink.ReadOnly := AValue;
end;

function TExtDBPictCombo.GetField: TField;
begin
  Result := FDataLink.Field;
end;

procedure TExtDBPictCombo.ActiveChange(Sender: TObject);
begin
  if FDataLink.Field <> nil then
    begin
      p_SetValue ( FDataLink.Field.AsString );
    end;
end;

procedure TExtDBPictCombo.DataChange(Sender: TObject);
begin
  if FDataLink.Field <> nil then
    begin
      p_SetValue ( FDataLink.Field.AsString );
    end;
end;


procedure TExtDBPictCombo.UpdateData(Sender: TObject);
begin
 FDataLink.Edit ;
  if Value <> '' Then
    Begin
      FDataLink.Field.Value := Value ;
    End
   else
    FDataLink.Field.Value := Null ;
end;

{$IFDEF DELPHI}
procedure TExtDBPictCombo.WMUndo(var Message: TMessage);
begin
  FDataLink.Edit;
  inherited;
end;
{$ENDIF}

procedure TExtDBPictCombo.WMPaste(var Message: TMessage);
begin
  FDataLink.Edit;
  inherited;
end;

procedure TExtDBPictCombo.WMCut(var Message: TMessage);
begin
  FDataLink.Edit;
  inherited;
end;

procedure TExtDBPictCombo.CMExit(var Message: {$IFDEF FPC} TLMExit {$ELSE} TCMExit {$ENDIF});
begin
  try
    FDataLink.UpdateRecord;
  except
    on e: Exception do
      Begin
        SetFocus;
        f_GereException ( e, FDataLink.DataSet, nil , False )
      End ;
  end;
  DoExit;
end;

procedure TExtDBPictCombo.CMGetDataLink(var Message: TMessage);
begin
  Message.Result := Integer(FDataLink);
end;

function TExtDBPictCombo.ExecuteAction(AAction: TBasicAction): Boolean;
begin
  Result := inherited ExecuteAction(AAction){$IFDEF DELPHI}  or (FDataLink <> nil) and
    FDataLink.ExecuteAction(AAction){$ENDIF};
end;

function TExtDBPictCombo.UpdateAction(AAction: TBasicAction): Boolean;
begin
  Result := inherited UpdateAction(AAction) {$IFDEF DELPHI}  or (FDataLink <> nil) and
    FDataLink.UpdateAction(AAction){$ENDIF};
end;

procedure TExtDBPictCombo.p_SetValue(const AValue: String);
begin
 inherited p_SetValue ( AValue );
 if assigned ( FDataLink.Field )
 and ( FDataLink.Field.AsString <> AValue ) Then
  Begin
    FDataLink.Dataset.Edit ;
    FDataLink.Field.Value := AValue ;
  End;
end;

initialization
{$IFDEF VERSIONS}
  p_ConcatVersion ( gVer_TExtPictCombo   );
  p_ConcatVersion ( gVer_TExtDBPictCombo   );
{$ENDIF}
end.
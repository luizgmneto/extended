{*********************************************************************}
{                                                                     }
{                                                                     }
{             TExtSearchEdit :                               }
{             Objet issu d'un TDBedit qui associe les         }
{             avantages de la DBEdit avec une recherche     }
{             Créateur : Matthieu Giroux                          }
{             31 Mars 2011                                            }
{                                                                     }
{                                                                     }
{*********************************************************************}

unit u_extsearchedit;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

{$I ..\DLCompilers.inc}

interface

uses Variants, Controls, Classes,
     {$IFDEF FPC}
     LMessages, LCLType,
     {$ELSE}
     Messages, Windows,
     {$ENDIF}
     Graphics, Menus, DB,DBCtrls,
     u_framework_components,
     u_extformatedits,
     {$IFDEF VERSIONS}
     fonctions_version,
     {$ENDIF}
     fonctions_string,
     u_extcomponent,
     DBGrids, StdCtrls;

const
{$IFDEF VERSIONS}
    gVer_TExtSearchDBEdit : T_Version = ( Component : 'Composant TExtSearchDBEdit' ;
                                          FileUnit : 'U_TExtSearchDBEdit' ;
                                          Owner : 'Matthieu Giroux' ;
                                          Comment : 'Searching in a dbedit.' ;
                                          BugsStory : '1.0.1.4 : MyLabel unset correctly.'
                                                    + '1.0.1.3 : Popup not erasing bug.'
                                                    + '1.0.1.2 : Testing on LAZARUS.'
                                                    + '1.0.1.1 : Delphi compatible.'
                                                    + '1.0.1.0 : Simple Edit capability on Lazarus Only.'
                                                    + '1.0.0.0 : Popup list.'
                                                    + '0.9.0.4 : Making comments.'
                                                    + '0.9.0.3 : Tested.'
                                                    + '0.9.0.2 : Not tested, upgrading.'
                                                    + '0.9.0.1 : Not tested, compiling on DELPHI.'
                                                    + '0.9.0.0 : In place not tested.';
                                          UnitType : 3 ;
                                          Major : 1 ; Minor : 0 ; Release : 1 ; Build : 4 );

{$ENDIF}
  SEARCHEDIT_GRID_DEFAULTS = [dgColumnResize, dgRowSelect, dgColLines, dgConfirmDelete, dgCancelOnExit, dgTabs, dgAlwaysShowSelection];
  SEARCHEDIT_GRID_DEFAULT_SCROLL = {$IFDEF FPC}ssAutoBoth{$ELSE}ssBoth{$ENDIF};
type

  TExtSearchDBEdit = class;

  { TListPopupEdit }

  TListPopupEdit = class ( TDBGrid )
    FEdit : TExtSearchDBEdit;
  protected
    procedure KeyUp(var Key: Word; Shift: TShiftState); override;
  public
    procedure Click; override;
    constructor Create ( Aowner : TComponent ); override;
    property Edit : TExtSearchDBEdit read FEdit;
  published
    property Options default SEARCHEDIT_GRID_DEFAULTS;
    property Scrollbars default SEARCHEDIT_GRID_DEFAULT_SCROLL;
  end;

{ TExtSearchDBEdit }
  TExtSearchDBEdit = class(TExtFormatDBEdit)
  private
    // Lien de données
    FSearchSource: TFieldDataLink;
    FOnLocate ,
    FOnSet ,
    FBeforeEnter, FAfterExit : TNotifyEvent;
    FLabel : TLabel;
    FOldColor ,
    FColorFocus ,
    FColorReadOnly,
    FColorEdit ,
    FColorLabel : TColor;
    FSearchFiltered,
    Flocated,
    FSet,
    FAlwaysSame : Boolean;
    FListWidth : Word;
    FListLines : Integer;
    FSeparator : Char;
    FSearchList : String;
    FListUp : Boolean;
    FNotifyOrder : TNotifyEvent;
    FPopup:TListPopupEdit;
    procedure DataChange(Sender: TObject);
    procedure p_setSearchDisplay ( AValue : String );
    function fs_getSearchDisplay : String ;
    procedure p_setSearchSource ( AValue : TDataSource );
    function fs_getSearchSource : TDataSource ;
    procedure p_setLabel ( const alab_Label: TLabel );
    procedure ShowPopup;
    procedure WMPaint(var Message: {$IFDEF FPC}TLMPaint{$ELSE}TWMPaint{$ENDIF}); message {$IFDEF FPC}LM_PAINT{$ELSE}WM_PAINT{$ENDIF};
    procedure WMSize(var Message: {$IFDEF FPC}TLMSize{$ELSE}TWMSize{$ENDIF}); message {$IFDEF FPC}LM_SIZE{$ELSE}WM_SIZE{$ENDIF};
    procedure WMSetFocus(var Message: {$IFDEF FPC}TLMSetFocus{$ELSE}TWMSetFocus{$ENDIF}); message {$IFDEF FPC}LM_SETFOCUS{$ELSE}WM_SETFOCUS{$ENDIF};
    procedure WMKillFocus(var Message: {$IFDEF FPC}TLMKillFocus{$ELSE}TWMKillFocus{$ENDIF}); message {$IFDEF FPC}LM_KILLFOCUS{$ELSE}WM_KILLFOCUS{$ENDIF};
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure KeyUp(var Key: Word; Shift: TShiftState); override;
    procedure CreatePopup; virtual;
    procedure FreePopup; virtual;
    procedure DoEnter; override;
    procedure DoExit; override;
    procedure Loaded; override;
    procedure SetOrder ; virtual;
    procedure ValidateSearch; virtual;
    function EditCanModify: Boolean; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    {$IFDEF FPC}
    procedure UTF8KeyPress(var UTF8Key: TUTF8Char); override;
    {$ENDIF}
    procedure Change; override;
  public
    constructor Create ( Aowner : TComponent ); override;
    destructor Destroy ; override;
    property Located : Boolean read Flocated;
  published
    property SearchDisplay : String read fs_getSearchDisplay write p_setSearchDisplay ;
    property SearchList : String read FSearchList write FSearchList ;
    property DropDownRows : Integer read FListLines write FListLines default 5;
    property DropDownWidth : Word read FListWidth write FListWidth default 0;
    property DropUp : Boolean read FListUp write FListUp default False;
    property SearchFiltered : Boolean read FSearchFiltered write FSearchFiltered default False;
    property FieldSeparator : Char read FSeparator write FSeparator default ',';
    property SearchSource : TDatasource read fs_getSearchSource write p_setSearchSource ;
    property OnLocate : TNotifyEvent read FOnLocate write FOnLocate;
    property FWBeforeEnter : TnotifyEvent read FBeforeEnter write FBeforeEnter stored False;
    property FWAfterExit  : TnotifyEvent read FAfterExit  write FAfterExit stored False ;
    property ColorLabel : TColor read FColorLabel write FColorLabel default CST_LBL_SELECT ;
    property ColorFocus : TColor read FColorFocus write FColorFocus default CST_EDIT_SELECT ;
    property ColorEdit : TColor read FColorEdit write FColorEdit default CST_EDIT_STD ;
    property ColorReadOnly : TColor read FColorReadOnly write FColorReadOnly default CST_EDIT_READ ;
    property MyLabel : TLabel read FLabel write p_setLabel;
    property AlwaysSame : Boolean read FAlwaysSame write FAlwaysSame default true;
    property OnOrder : TNotifyEvent read FNotifyOrder write FNotifyOrder;
    property OnSet : TNotifyEvent read FOnSet write FOnSet;
    property OnMouseEnter;
    property OnMouseLeave;
    property PopupMenu;
  end;

implementation

uses Dialogs,
     fonctions_db,
     fonctions_components,
     sysutils;


{ TListPopup }

procedure TListPopupEdit.KeyUp(var Key: Word; Shift: TShiftState);
begin
  inherited KeyUp(Key, Shift);
  case Key of
    VK_ESCAPE : Visible:=False;
    VK_RETURN : Click;
    end;
end;

procedure TListPopupEdit.Click;
begin
  with FEdit do
   Begin
    Text := FSearchSource.Dataset.FieldByName ( FSearchSource.FieldName ).AsString;
    ValidateSearch;
   End;
 Visible:=False;
end;

constructor TListPopupEdit.Create(Aowner: TComponent);
begin
  inherited Create(Aowner);
  Options:= SEARCHEDIT_GRID_DEFAULTS;
  ScrollBars:=SEARCHEDIT_GRID_DEFAULT_SCROLL;
end;

{ TExtSearchDBEdit }

// procedure TExtSearchDBEdit.p_setSearchDisplay
// Setting The Search field on SearchSource
procedure TExtSearchDBEdit.p_setSearchDisplay(AValue: String);
begin
  FSearchSource.FieldName:= AValue;
end;

// function TExtSearchDBEdit.fs_getSearchDisplay
// Getting The Search field on SearchSource
function TExtSearchDBEdit.fs_getSearchDisplay: String;
begin
  Result := FSearchSource.FieldName;
end;

// procedure TExtSearchDBEdit.p_setSearchSource
// Setting the Search source
procedure TExtSearchDBEdit.p_setSearchSource(AValue: TDataSource);
begin
  FSearchSource.DataSource := AValue;
end;

// Event TExtSearchDBEdit.DataChange
//update the caption on next record etc...
procedure TExtSearchDBEdit.DataChange(Sender: TObject);
begin
  if Field <> nil then begin
    //use the right EditMask if any
    //EditMask := FDataLink.Field.EditMask; doesn't exist yet
    {$IFDEF FPC}
    Alignment := Field.Alignment;

    //if we are focused its possible to edit,
    //if the field is currently modifiable
    if Focused and DataSource.DataSet.CanModify then begin
      //display the real text since we can modify it
      RestoreMask(Field.Text);
    end else
      //otherwise display the pretified/formated text since we can't
      DisableMask(Field.DisplayText);
    {$ENDIF}
    if (Field.DataType in [ftString, ftFixedChar, ftWidestring, ftFixedWideChar])
      and (MaxLength = 0) then
      MaxLength := Field.Size;
  end
  else if assigned ( DataSource )
    then
     begin
      //todo: uncomment this when TField implements EditMask
      //EditMask := ''
      Text := '';
      MaxLength := 0;
     end;
end;


// function TExtSearchDBEdit.fs_getSearchSource
// Getting the Search source
function TExtSearchDBEdit.fs_getSearchSource: TDataSource;
begin
  Result := FSearchSource.DataSource;
end;

// procedure TExtSearchDBEdit.p_setLabel
// Linked label property setting
// The Label changes its color on focusing
procedure TExtSearchDBEdit.p_setLabel(const alab_Label: TLabel);
begin
  p_setMyLabel ( FLabel, alab_Label, Self );
end;

// procedure TExtSearchDBEdit.WMPaint
// Setting the correct color on painting
procedure TExtSearchDBEdit.WMPaint(var Message: {$IFDEF FPC}TLMPaint{$ELSE}TWMPaint{$ENDIF});
begin
  p_setCompColorReadOnly ( Self,FColorEdit,FColorReadOnly, FAlwaysSame, ReadOnly );
  inherited;
end;

procedure TExtSearchDBEdit.WMSize(var Message: {$IFDEF FPC}TLMSize{$ELSE}TWMSize{$ENDIF});
begin
  if ( Message.Width <> Width ) or ( Message.Height <> Height ) Then
    FreePopup;
  Inherited;
end;

procedure TExtSearchDBEdit.WMSetFocus(var Message: {$IFDEF FPC}TLMSetFocus{$ELSE}TWMSetFocus{$ENDIF});
begin
  if Assigned(DataSource) Then
    Inherited;
end;

procedure TExtSearchDBEdit.WMKillFocus(var Message: {$IFDEF FPC}TLMKillFocus{$ELSE}TWMKillFocus{$ENDIF});
begin
  if Assigned(DataSource) Then
    Inherited;
end;

procedure TExtSearchDBEdit.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if  ( Operation  = opRemove )
  and ( AComponent = FLabel   )
   Then FLabel := nil;
end;

procedure TExtSearchDBEdit.ShowPopup;
var i, j, AWidth, AActiveRecord : Integer;
    APoint : TPoint;
Begin
  with FPopup do
   Begin
     APoint.X := 0;
     if FListUp
      Then APoint.Y := Self.Height - Height
      Else APoint.Y := Self.Height;
     APoint:=Parent.ScreenToClient(Self.ClientToScreen(APoint));
     Left := APoint.X;
     Top  := APoint.Y;
     FSearchSource.DataSet.DisableControls;
     AActiveRecord := FSearchSource.ActiveRecord;
     with FSearchSource.DataSet do
       try
         // good columns' size
         for j := 0 to FListLines do
           Begin
             AWidth:=0;
             for i := 0 to Columns.Count-1 do
               Begin
                 with Columns [i] do
                  Begin
                   if i = Columns.Count-1 Then
                    Begin
                      Width:=FPopup.Width-AWidth;
                      Break;
                    end;
                   Width  := Canvas.TextWidth(Field.DisplayText+'a');
                   if Width > FPopup.Width div Columns.Count
                    then Width := FPopup.Width div Columns.Count;
                   inc ( AWidth, Width );
                  end;
               end;
              Next;
            if eof Then
              Break;
           end;
       finally
         FSearchSource.ActiveRecord:=AActiveRecord;
         FSearchSource.DataSet.EnableControls;
       end;
     Visible:=True;
   end;
End;
procedure TExtSearchDBEdit.CreatePopup;
var Alist:TStrings;
    i : Integer;
    ABookmark:TBookmark;
Begin
  with FSearchSource.DataSet do
  if  ( RecordCount > 1 )
  and ( FSearchList <> '' ) Then
   Begin
     ABookmark:=FSearchSource.DataSet.GetBookmark;
     try
       if not Assigned( FPopup ) Then
        Begin
          Alist := TStringList.Create;
          try
            FPopup := TListPopupEdit.Create(Owner);
            p_ChampsVersListe(Alist,FSearchList,FSeparator);
            with FPopup do
              Begin
                FEdit:=Self;
                if FListWidth > 0
                 Then Width := FListWidth
                 Else Width := Self.Width;
                Height := FListLines * Self.Height;
                DataSource:=FSearchSource.DataSource;
                if ( Self.Owner is TWinControl )
                  Then Parent:=Self.Owner as TWinControl
                  Else if Self.Parent.Parent <> nil
                  Then Parent:=Self.Parent.Parent
                  Else Parent:=Self.Parent;
                Color := Self.Color;
                Font.Assign(Self.Font);
                for i := 0 to Alist.Count-1 do
                  Begin
                    with Columns.Add do
                     Begin
                      FieldName := Alist[i];
                     end;
                  end;
                Loaded;
                Visible:=True;
              end;
          finally
            Alist.Free;
          end;
        end;
       ShowPopup;
     finally
       FSearchSource.DataSet.GotoBookmark(ABookmark);
       FreeBookmark(ABookmark);
     end;
   End;
End;

procedure TExtSearchDBEdit.FreePopup;
begin
  FreeAndNil(FPopup);
end;

// procedure TExtSearchDBEdit.KeyUp
//  searching on key up
procedure TExtSearchDBEdit.KeyUp(var Key: Word; Shift: TShiftState);
var li_pos : Integer;
    ls_temp : String;
begin
  inherited KeyUp(Key, Shift);
  if not Assigned ( FSearchSource.DataSet )
  or ( FSearchSource.FieldName = '' ) then
   Exit;
  case Key of
    VK_ESCAPE:
        SelectAll;
    VK_DELETE :
    Begin
      Flocated:=False;
      FSet := False;
      SelText:='';
      Exit;
    end;
    VK_RETURN:
    Begin
      ValidateSearch;
      Exit;
    End;
    VK_DOWN,VK_UP:
    Begin
      if assigned ( FPopup )
      and FPopup.Visible Then
       FPopup.SetFocus;
      Exit;
    End;
    end;
  if not ( Key in [ VK_TAB, VK_BACK ])
  and ( Text    <> '' )
   Then
    with FSearchSource.DataSet do
      Begin
        Open ;
        FSet := False;
        // Trouvé ?
        if not assigned ( FindField ( FSearchSource.FieldName )) Then Exit;
        if FSearchFiltered Then
         Begin
          Filter := 'LOWER('+ FSearchSource.FieldName+') LIKE ''' + LowerCase(fs_stringDbQuote(Text)) +'%''';
          Filtered:=True;
         End;
        if not IsEmpty
        and fb_Locate ( FSearchSource.DataSet, FSearchSource.FieldName, Text, [loCaseInsensitive, loPartialKey], True )
         Then
          Begin
            CreatePopup;
            Flocated  := True;
            li_pos    := SelStart ;
            ls_temp   := FieldByName ( FSearchSource.FieldName ).AsString;
            Text      := ls_temp ; // c'est en affectant le texte que l'on passe en mode édition
            SelStart  := li_pos ;
            SelLength := length ( ls_temp ) - li_pos ;
            if SelLength=0
             Then ValidateSearch
             Else
              if assigned ( FOnLocate ) Then
                FOnLocate ( Self );
          End
         Else // not found : no popup
          if Assigned(FPopup) Then
            FPopup.Visible:=False;
      end

end;

// procedure TExtSearchDBEdit.ValidateSearch
// Calling OnSet Event if setted
procedure TExtSearchDBEdit.ValidateSearch;
Begin
  if not FSet
  and Flocated
   Then
     with FSearchSource.DataSet do
      Begin
        Flocated  := True;
        FSet := True;
        Text := FindField ( FSearchSource.FieldName  ).AsString;
        if assigned ( FOnSet ) Then
          FOnSet ( Self )
      End ;
end;

function TExtSearchDBEdit.EditCanModify: Boolean;
begin
  Result:= not Assigned(DataSource) or inherited EditCanModify;
end;

procedure TExtSearchDBEdit.KeyDown(var Key: Word; Shift: TShiftState);
var OldKey : Integer;
begin
  OldKey:=Key;
  inherited KeyDown(Key, Shift);
  if not assigned ( DataSource ) and ( OldKey in [VK_ESCAPE,VK_DELETE, VK_BACK])
   Then Key:=OldKey;
end;

{$IFDEF FPC}
procedure TExtSearchDBEdit.UTF8KeyPress(var UTF8Key: TUTF8Char);
begin
  // When no datasource so can edit
  if assigned ( DataSource )
   Then inherited UTF8KeyPress(UTF8Key)
   else
     if Assigned(OnUTF8KeyPress)
      Then OnUTF8KeyPress ( Self, UTF8Key );
end;
{$ENDIF}

procedure TExtSearchDBEdit.Change;
begin
  if Assigned(DataSource)
   Then
    inherited Change
   Else
     if Assigned(OnChange) Then
      OnChange ( Self );
end;

// procedure TExtSearchDBEdit.DoEnter
// Setting the label and ExtSearchDBEdit color
procedure TExtSearchDBEdit.DoEnter;
begin
  if assigned ( FBeforeEnter ) Then
    FBeforeEnter ( Self );
  // Si on arrive sur une zone de saisie, on met en valeur son tlabel par une couleur
  // de fond bleu et son libellé en marron sauf si le libellé est sélectionné
  // avec la souris => cas de tri)
  p_setLabelColorEnter ( FLabel, FColorLabel, FAlwaysSame );
  p_setCompColorEnter  ( Self, FColorFocus, FAlwaysSame );
  inherited DoEnter;
end;

// procedure TExtSearchDBEdit.DoExit
// Setting the label and ExtSearchDBEdit color
procedure TExtSearchDBEdit.DoExit;
begin
  inherited DoExit;
  p_setLabelColorExit ( FLabel, FAlwaysSame );
  p_setCompColorExit ( Self, FOldColor, FAlwaysSame );
  if assigned ( FAfterExit ) Then
    FAfterExit ( Self );
  if assigned ( FPopup )
  and not FPopup.Focused Then
    FreePopup;
end;

// procedure TExtSearchDBEdit.Loaded
// Finishing the init of loaded component
procedure TExtSearchDBEdit.Loaded;
begin
  inherited Loaded;
  FOldColor := Color;
  if  FAlwaysSame
   Then
    Color := gCol_Edit ;
end;

// procedure TExtSearchDBEdit.SetOrder
// calling FNotifyOrder Event
procedure TExtSearchDBEdit.SetOrder;
begin
  if assigned ( FNotifyOrder ) then
    FNotifyOrder ( Self );
end;

constructor TExtSearchDBEdit.Create(Aowner: TComponent);
begin
  inherited Create(Aowner);
  //DataLink.OnDataChange := DataChange;
  FSearchFiltered := False;
  FListUp := False;
  FListWidth:=0;
  FSeparator := ',';
  FListLines := 5;
  FPopup := nil;
  FSearchSource := TFieldDataLink.Create;
  Flocated:= False;
  FAlwaysSame := True;
  FColorLabel := CST_LBL_SELECT;
  FColorEdit  := CST_EDIT_STD;
  FColorFocus := CST_EDIT_SELECT;
  FColorReadOnly := CST_EDIT_READ;
end;

// destructor TExtSearchDBEdit.Destroy
// Destroying
destructor TExtSearchDBEdit.Destroy;
begin
  inherited Destroy;
  FSearchSource.Destroy;
end;

{$IFDEF VERSIONS}
initialization
  // Versioning
  p_ConcatVersion ( gVer_TExtSearchDBEdit );
{$ENDIF}
end.

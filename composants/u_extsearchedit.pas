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
     Graphics, Menus, DB,DBCtrls, u_framework_components,
     {$IFDEF VERSIONS}
     fonctions_version,
     {$ENDIF}
     u_extcomponent, DBGrids, StdCtrls;

const
{$IFDEF VERSIONS}
    gVer_TExtSearchDBEdit : T_Version = ( Component : 'Composant TExtSearchDBEdit' ;
                                          FileUnit : 'U_TExtSearchDBEdit' ;
                                          Owner : 'Matthieu Giroux' ;
                                          Comment : 'Searching in a dbedit.' ;
                                          BugsStory : '1.0.0.0 : Popup list.'
                                                    + '0.9.0.4 : Making comments.'
                                                    + '0.9.0.3 : Tested.'
                                                    + '0.9.0.2 : Not tested, upgrading.'
                                                    + '0.9.0.1 : Not tested, compiling on DELPHI.'
                                                    + '0.9.0.0 : In place not tested.';
                                          UnitType : 3 ;
                                          Major : 1 ; Minor : 0 ; Release : 0 ; Build : 0 );

{$ENDIF}
  SEARCHEDIT_GRID_DEFAULTS = [dgColumnResize, dgRowSelect, dgColumnMove, dgColLines, dgConfirmDelete, dgCancelOnExit, dgTabs, dgAlwaysShowSelection];
  SEARCHEDIT_GRID_DEFAULT_SCROLL = ssAutoBoth;
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
  TExtSearchDBEdit = class(TDBEdit)
  private
    // Lien de données
    FSearchSource: TFieldDataLink;
    FOnLocate ,
    FOnSet ,
    FBeforeEnter, FAfterExit : TNotifyEvent;
    FLabel : TFWLabel ;
    FOldColor ,
    FColorFocus ,
    FColorReadOnly,
    FColorEdit ,
    FColorLabel : TColor;
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
    procedure p_setSearchDisplay ( AValue : String );
    function fs_getSearchDisplay : String ;
    procedure p_setSearchSource ( AValue : TDataSource );
    function fs_getSearchSource : TDataSource ;
    procedure p_setLabel ( const alab_Label : TFWLabel );
    procedure ShowPopup;
    procedure WMPaint(var Message: {$IFDEF FPC}TLMPaint{$ELSE}TWMPaint{$ENDIF}); message {$IFDEF FPC}LM_PAINT{$ELSE}WM_PAINT{$ENDIF};
    procedure WMSize(var Message: TLMSize); message LM_SIZE;
  protected
    procedure KeyUp(var Key: Word; Shift: TShiftState); override;
    procedure CreatePopup; virtual;
    procedure FreePopup; virtual;
    procedure DoEnter; override;
    procedure DoExit; override;
    procedure Loaded; override;
    procedure SetOrder ; virtual;
    procedure ValidateSearch; virtual;
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
    property FieldSeparator : Char read FSeparator write FSeparator default ',';
    property SearchSource : TDatasource read fs_getSearchSource write p_setSearchSource ;
    property OnLocate : TNotifyEvent read FOnLocate write FOnLocate;
    property FWBeforeEnter : TnotifyEvent read FBeforeEnter write FBeforeEnter stored False;
    property FWAfterExit  : TnotifyEvent read FAfterExit  write FAfterExit stored False ;
    property ColorLabel : TColor read FColorLabel write FColorLabel default CST_LBL_SELECT ;
    property ColorFocus : TColor read FColorFocus write FColorFocus default CST_EDIT_SELECT ;
    property ColorEdit : TColor read FColorEdit write FColorEdit default CST_EDIT_STD ;
    property ColorReadOnly : TColor read FColorReadOnly write FColorReadOnly default CST_EDIT_READ ;
    property MyLabel : TFWLabel read FLabel write p_setLabel;
    property AlwaysSame : Boolean read FAlwaysSame write FAlwaysSame default true;
    property OnOrder : TNotifyEvent read FNotifyOrder write FNotifyOrder;
    property OnSet : TNotifyEvent read FOnSet write FOnSet;
  end;

implementation

uses Dialogs, fonctions_db, sysutils, fonctions_string;

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

// function TExtSearchDBEdit.fs_getSearchSource
// Getting the Search source
function TExtSearchDBEdit.fs_getSearchSource: TDataSource;
begin
  Result := FSearchSource.DataSource;
end;

// procedure TExtSearchDBEdit.p_setLabel
// Linked label property setting
// The Label changes its color on focusing
procedure TExtSearchDBEdit.p_setLabel(const alab_Label: TFWLabel);
begin
  if alab_Label <> FLabel Then
    Begin
      FLabel := alab_Label;
      FLabel.MyEdit := Self;
    End;
end;

// procedure TExtSearchDBEdit.WMPaint
// Setting the correct color on painting
procedure TExtSearchDBEdit.WMPaint(var Message: {$IFDEF FPC}TLMPaint{$ELSE}TWMPaint{$ENDIF});
begin
  p_setCompColorReadOnly ( Self,FColorEdit,FColorReadOnly, FAlwaysSame, ReadOnly );
  inherited;
end;

procedure TExtSearchDBEdit.WMSize(var Message: TLMSize);
begin
  if ( Message.Width <> Width ) or ( Message.Height <> Height ) Then
    FreePopup;
  Inherited;
end;

procedure TExtSearchDBEdit.ShowPopup;
var i, j, AWidth, AActiveRecord : Integer;
Begin
  with FPopup do
   Begin
     Left := Self.Left;
     if FListUp
      Then Top := Self.Top - Self.Height - Height
      Else Top := Self.Top + Self.Height;
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
var Alist:TStringList;
    i : Integer;
Begin
  with FSearchSource.DataSet do
  if  ( RecordCount > 1 )
  and ( FSearchList <> '' ) Then
   Begin
     if not Assigned( FPopup ) Then
      Begin
        Alist := TStringList.Create;
        try
          FPopup := TListPopupEdit.Create(Owner);
          p_ChampsVersListe(Alist,FSearchList,FSeparator);
          with FPopup do
            Begin
              FEdit:=Self;
              Visible:=False;
              if FListWidth > 0
               Then Width := FListWidth
               Else Width := Self.Width;
              Height := FListLines * Self.Height;
              DataSource:=FSearchSource.DataSource;
              Parent:=Self.Parent;
              Color := Self.Color;
              Font.Assign(Self.Font);
              for i := 0 to Alist.Count-1 do
                Begin
                  with Columns.Add do
                   Begin
                    FieldName := Alist[i];
                   end;
                end;
            end;
        finally
          Alist.Free;
        end;
      end;
     ShowPopup;
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
        Filter := 'LOWER('+ FSearchSource.FieldName+') LIKE ''' + LowerCase(fs_stringDbQuote(Text)) +'*''';
        Filtered:=True;
        if not IsEmpty
        and fb_Locate ( FSearchSource.DataSet, FSearchSource.FieldName, Text, [loCaseInsensitive, loPartialKey], True )
         Then
          Begin
            if not BOF
            and ( FieldByName ( FSearchSource.FieldName ).AsString = Text ) Then
             Begin
              while FieldByName ( FSearchSource.FieldName ).AsString = Text do
               Next;
              Prior;
             End;
            CreatePopup;
            Flocated  := True;
            li_pos    := SelStart ;
            ls_temp   := FieldByName ( FSearchSource.FieldName ).AsString;
            Text      := ls_temp ; // c'est en affectant le texte que l'on passe en mode édition
            SelStart  := li_pos ;
            SelLength := length ( ls_temp ) - li_pos ;
            if ( SelText = '' )
            and ( FSearchList = '' ) Then
                ValidateSearch
             else
                if assigned ( FOnLocate ) Then
                  FOnLocate ( Self );
          End ;
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

// procedure TExtSearchDBEdit.DoEnter
// Setting the label and ExtSearchDBEdit color
procedure TExtSearchDBEdit.DoEnter;
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

// procedure TExtSearchDBEdit.DoExit
// Setting the label and ExtSearchDBEdit color
procedure TExtSearchDBEdit.DoExit;
begin
  inherited DoExit;
  p_setLabelColorExit ( FLabel, FAlwaysSame );
  p_setCompColorExit ( Self, FOldColor, FAlwaysSame );
  ValidateSearch;
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

// constructor TExtSearchDBEdit.Create
// Initing
constructor TExtSearchDBEdit.Create(Aowner: TComponent);
begin
  inherited Create(Aowner);
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
  FSearchSource.Free;
end;

{$IFDEF VERSIONS}
initialization
  // Versioning
  p_ConcatVersion ( gVer_TExtSearchDBEdit );
{$ENDIF}
end.

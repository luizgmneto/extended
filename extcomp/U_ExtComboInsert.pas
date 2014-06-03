{*********************************************************************}
{                                                                     }
{                                                                     }
{             TExtDBComboInsert :                               }
{             Objet issu d'un TCustomComboBox qui associe les         }
{             avantages de la DBComoBox et de la DBLookUpComboBox     }
{             Créateur : Matthieu Giroux                          }
{             31 Mars 2005                                            }
{             Version 1.0                                             }
{                                                                     }
{                                                                     }
{*********************************************************************}

unit U_ExtComboInsert;

{$I ..\DLCompilers.inc}
{$I ..\extends.inc}
{$IFDEF FPC}
{$Mode Delphi}
{$ENDIF}

interface

uses Variants, Controls, Classes,
  {$IFDEF FPC}
     LMessages, LCLType, LCLIntf,
  {$ELSE}
     Windows, Mask, JvDBLookup, Messages,
  {$ENDIF}
     Graphics, DB,DBCtrls,
  {$IFDEF VERSIONS}
    fonctions_version,
  {$ENDIF}
    StdCtrls,
  u_extsearchedit,
  u_extcomponent;

{$IFDEF VERSIONS}
const
  gVer_TDBLookupComboInsert : T_Version = ( Component : 'Composant TDBComboBoxInsert' ;
                                             FileUnit : 'U_DBComboBoxInsert' ;
                                             Owner : 'Matthieu Giroux' ;
                                             Comment : 'Insertion automatique dans une DBComboLookupEdit.' ;
                                             BugsStory : '1.1.0.0 : ExtSearchDbEdit inherit.' +#13#10
                                                       + '1.0.1.5 : MyLabel unset correctly.' +#13#10
                                                       + '1.0.1.4 : Better component testing.' +#13#10
                                                       + '1.0.1.3 : Compiling on lazarus.' +#13#10
                                                       + '1.0.1.2 : Bug validation au post.' +#13#10
                                                       + '1.0.1.1 : Bug rafraîchissement quand pas de focus.' +#13#10
                                                       + '1.0.1.0 : Propriété Modify.' +#13#10
                                                       + '1.0.0.0 : Version bêta inadaptée, réutilisation du code de la TJvDBLookupComboEdit.' +#13#10
                                                       + '0.9.0.0 : En place à tester.';
                                             UnitType : 3 ;
                                             Major : 1 ; Minor : 1 ; Release : 0 ; Build : 0 );

{$ENDIF}
type

{ TExtDBComboInsert }
  TExtDBComboInsert = class(TCustomSearchDBEdit)
   private

    // On est en train d'écrire dans la combo
    FModify : Boolean ;
    FSearchSource : TDatasource;
    // Valeur affichée
    FDisplayValue : String ;
    // Focus sur le composant
    {$IFDEF FPC}
    FCompleteWord,
    {$ENDIF}
    Flocated,
    FSet,
    FHideSelection : Boolean;
    FOnLocate,
    FOnSet : TNotifyEvent ;
    // En train de mettre à jour ou pas
    FUpdate ,
    // Beep sur erreur
    FBeepOnError: Boolean;

    //look
    FBeforeEnter, FBeforeExit : TNotifyEvent;
    FLabel : TLabel ;
    FOldColor ,
    FColorReadOnly,
    FColorFocus ,
    FColorEdit ,
    FColorLabel : TColor;
    FAlwaysSame : Boolean;
    FNotifyOrder : TNotifyEvent;
    FOnPopup : TNotifyEvent;
    function GetSearchSource: TDataSource;
    {$IFNDEF JEDI}
    procedure ResetMaxLength;
    {$ENDIF}
    procedure SetSearchSource(Value: TDataSource);
    procedure p_setLabel ( const alab_Label: TLabel );
  protected
    OldText : String ;
    OldSelStart : Integer;
    procedure MouseDown( Button : TMouseButton; Shift : TShiftState; X,Y : Integer); override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    function GetTextMargins: TPoint; virtual;
    procedure ValidateSearch; virtual;
    procedure SetSelText(const Val: string); override;
    procedure CompleteText; virtual;
    procedure RealSetText(const AValue: TCaption); override;

    procedure TextChanged; override;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure InsertLookup ( const AUpdate : Boolean ); virtual ;

    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyUp(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
  public
    constructor Create ( AOwner : TComponent ); override;
    procedure DoEnter; override;
    procedure DoExit; override;
    procedure Loaded; override;
    procedure SetOrder ; virtual;
    procedure AssignListValue;virtual;
    property Modify : Boolean read FModify ;
    property DisplayValue : String read FDisplayValue write FDisplayValue;
  published
    property FWBeforeEnter : TnotifyEvent read FBeforeEnter write FBeforeEnter stored False;
    property FWBeforeExit  : TnotifyEvent read FBeforeExit  write FBeforeExit stored False ;
    property ColorLabel : TColor read FColorLabel write FColorLabel default CST_LBL_SELECT ;
    property ColorFocus : TColor read FColorFocus write FColorFocus default CST_EDIT_SELECT ;
    property ColorEdit : TColor read FColorEdit write FColorEdit default CST_EDIT_STD ;
    property ColorReadOnly : TColor read FColorReadOnly write FColorReadOnly default CST_EDIT_READ ;
    property Color stored False ;
    property MyLabel : TLabel read FLabel write p_setLabel;
    property AlwaysSame : Boolean read FAlwaysSame write FAlwaysSame default true;
    property OnOrder : TNotifyEvent read FNotifyOrder write FNotifyOrder;
    property OnPopup : TNotifyEvent read FOnPopup write FOnPopup;
    property OnMouseEnter;
    property OnMouseLeave;
    property PopupMenu;
    property OnLocate : TNotifyEvent read FOnLocate write FOnLocate;
    property OnSet : TNotifyEvent read FOnSet write FOnSet;
    property BeepOnError: Boolean read FBeepOnError write FBeepOnError default True;
    property SearchSource: TDataSource read GetSearchSource write SetSearchSource;
    property HideSelection : Boolean read FHideSelection write FHideSelection default false;
    property ReadOnly default False;
    {$IFDEF FPC}
    property CompleteWord : Boolean read FCompleteWord write FCompleteWord default true;
    {$ENDIF}
  end;

implementation

uses
  SysUtils,
  {$IFDEF FPC}
  LCLProc,
  {$ELSE}
  JvConsts, JvToolEdit,
  {$ENDIF}
  fonctions_components,
  fonctions_dbcomponents,
  fonctions_db;

{ TExtDBComboInsert }



////////////////////////////////////////////////////////////////////////////////
// Constructeur : Create
// description  : Initialisation du composant
////////////////////////////////////////////////////////////////////////////////
constructor TExtDBComboInsert.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  // Pas de modification ni de mise à jour à la création
  FModify := False ;
  {$IFDEF FPC}
  FCompleteWord := True;
  {$ENDIF}
  FUpdate := False ;
  // style lookup
  ControlStyle := ControlStyle + [csReplicatable];
  // Beep sur erreur par défaut
  FBeepOnError := True;
  // Mode création pour informer la popup
  ControlState := ControlState + [csCreating];
  FHideSelection := False;
  // look
  FAlwaysSame := True;
  FColorLabel := CST_LBL_SELECT;
  FColorEdit  := CST_EDIT_STD;
  FColorFocus := CST_EDIT_SELECT;
  FColorReadOnly := CST_EDIT_READ;
end;

procedure TExtDBComboInsert.p_setLabel(const alab_Label: TLabel);
begin
  p_setMyLabel ( FLabel, alab_Label, Self );
end;

procedure TExtDBComboInsert.SetOrder;
begin
  if assigned ( FNotifyOrder ) then
    FNotifyOrder ( Self );
end;


procedure TExtDBComboInsert.Loaded;
begin
  inherited Loaded;
  FOldColor := Color;
  if  FAlwaysSame
   Then
    Color := gCol_Edit ;
end;

procedure TExtDBComboInsert.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited MouseDown(Button, Shift, X, Y);
  if Button = mbRight Then
  fb_ShowPopup (Self,PopUpMenu,OnContextPopup,FOnPopup);
end;

procedure TExtDBComboInsert.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if  ( Operation  = opRemove )
  and ( AComponent = FLabel   )
   Then FLabel := nil;
end;


////////////////////////////////////////////////////////////////////////////////
// procédure   : ResetMaxLength
// description : Vérifications avant affectation de la taille du texte à rien
////////////////////////////////////////////////////////////////////////////////
{$IFNDEF JEDI}
procedure TExtDBComboInsert.ResetMaxLength;
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
{$ENDIF}


procedure TExtDBComboInsert.CreateParams(var Params: TCreateParams);
const
  AlignmentStyle: array[TAlignment] of DWord = (
{ taLeftJustify  } ES_LEFT,
{ taRightJustify } ES_RIGHT,
{ taCenter       } ES_CENTER
  );
begin
  inherited CreateParams(Params);
  if not HideSelection then
    Params.Style := Params.Style or ES_NOHIDESEL;
end;

{$IFDEF JEDI}
procedure TExtDBComboInsert.SelectAll;
Begin
End;
{$ENDIF}

////////////////////////////////////////////////////////////////////////////////
// procédure   : KeyDown
// description : évènement enfoncement de touche
// paramètres  : Key : La touche appuyée
//               Shift : Touche spéciale
////////////////////////////////////////////////////////////////////////////////
procedure TExtDBComboInsert.KeyDown(var Key: Word; Shift: TShiftState);
begin
  // new order, because result of inherited KeyDown(...) could be = 0
  // so, first set DataSet in Edit-Mode
  // certaines touches initient l'édition des données
  case Key of
    VK_ESCAPE:
      Begin
        SelectAll;
        Key := 0;
      end;
    VK_DELETE :
      Begin
        Flocated:=False;
        FSet := False;
        {$IFNDEF JEDI}SelText:='';{$ENDIF}
        Key := 0;
        Exit;
      end;
    VK_RETURN:
      Begin
        with Field do
          InsertLookup ( not assigned ( Field ) or not assigned ( Dataset ) or ( DataSet.State in [dsEdit,dsInsert ] ) );
        Key := 0;
      end;
  end;
  inherited;
end;

procedure TExtDBComboInsert.KeyUp(var Key: Word; Shift: TShiftState);
begin
  inherited;

end;

////////////////////////////////////////////////////////////////////////////////
// procédure   : KeyPress
// description : évènement appuie sur touche
// paramètre   : Key : La touche appuyée
////////////////////////////////////////////////////////////////////////////////
procedure TExtDBComboInsert.KeyPress(var Key: Char);
begin
  inherited;
  // vérifications : Tout est-il renseigné correctement ?
  if (Key in [#32..#255]) and (Field <> nil) Then
    Begin
      FModify := True ;
{      SelText:='';
      Text := Text + Key ;
      SelStart:=SelStart+1;}
      {$IFNDEF JEDI}
      CompleteText;
      {$ENDIF}
       if  ( (( SearchList = '' ) and not Field.IsValidChar(Key))
       or  ( ( SearchList <> '' ) and
       ( not assigned ( SearchSource )
        or not assigned ( SearchSource.DataSet )
        or not assigned ( SearchSource.DataSet.FindField ( SearchList ) )
        or not SearchSource.DataSet.FindField ( SearchList ).IsValidChar(Key)))) then
      begin
        if BeepOnError then
          SysUtils.Beep;
        Key := #0;
      end;
    End ;
end;

{$IFDEF FPC}
{$IFNDEF RXCOMBO}
{------------------------------------------------------------------------------
  Method: TExtDBComboInsert.SetSelText
  Params: val - new string for text-field
  Returns: nothings

  Replace the selected part of text-field with "val".
 ------------------------------------------------------------------------------}
procedure TExtDBComboInsert.SetSelText(const Val: string);
var
  OldText, NewText: string;
  OldPos: integer;
begin
  OldPos := SelStart;
  OldText := Text;
  NewText := UTF8Copy(OldText, 1, OldPos) +
             Val +
             UTF8Copy(OldText, OldPos + SelLength + 1, MaxInt);
  Text := NewText;
  SelStart := OldPos + UTF8Length(Val);
end;
{$ENDIF}


// procedure TExtDBComboInsert.RealSetText
// ?
procedure TExtDBComboInsert.RealSetText(const AValue: TCaption);
begin
  {$IFDEF VerboseTWinControlRealText}
  DebugLn(['TWinControl.RealSetText ',DbgSName(Self),' AValue="',AValue,'" HandleAllocated=',HandleAllocated,' csLoading=',csLoading in ComponentState]);
  {$ENDIF}
  if HandleAllocated and (not (csLoading in ComponentState)) then
  begin
    WSSetText(AValue);
    InvalidatePreferredSize;
    if RealGetText = AValue then Exit;
    Caption := AValue;
    Perform(CM_TEXTCHANGED, 0, 0);
    AdjustSize;
  end
  else inherited RealSetText(AValue);
  {$IFDEF VerboseTWinControlRealText}
  DebugLn(['TWinControl.RealSetText ',DbgSName(Self),' END']);
  {$ENDIF}
end;
{$ENDIF}

//////////////////////////////////////////////////////////////////////////////////
// Procédure Completetext
// Complétion
//////////////////////////////////////////////////////////////////////////////////
{$IFNDEF JEDI}
procedure TExtDBComboInsert.CompleteText;
var li_pos : Integer;
    ls_temp : String;
begin
  if FCompleteWord
  and assigned ( FSearchSource ) Then
    with FSearchSource.DataSet do
      Begin
        Open;
        FSet := False;
        if not assigned ( FindField ( SearchList )) Then Exit;
        if fb_Locate ( FSearchSource.DataSet,
                       SearchList,
                       Text, [loCaseInsensitive, loPartialKey], True )
         Then
          Begin
            Flocated  := True;
            li_pos    := SelStart ;
            ls_temp   := FindField ( SearchList ).AsString;
            Text :=  ls_temp ;
            SelStart := li_pos ;
            SelLength := length ( ls_temp ) - li_pos;
            if ( SelText = '' )  Then
                ValidateSearch
             else
                if assigned ( FOnLocate ) Then
                  FOnLocate ( Self );
          End ;
      end
end;
{$ENDIF}


////////////////////////////////////////////////////////////////////////////////
// procédure   : Change
// description : Evènement sur changement du datasourc principal
////////////////////////////////////////////////////////////////////////////////
(*
procedure TExtDBComboInsert.Change;
begin
  // On avertit le lien de données
  Inherited;
  if assigned ( DataSource )
  and not ( DataSource.Dataset.State in [dsInsert,dsEdit]) Then
    // Les données viennent peut-être d'être validées
    FModify := False ;
  // vérfications pour affectation
  if  ( SelText = '' )
  and assigned ( {$IFDEF FPC}ListSource{$ELSE}LookupSource{$ENDIF} )
  and assigned ( {$IFDEF FPC}ListSource{$ELSE}LookupSource{$ENDIF}.DataSet )
  and assigned ( {$IFDEF FPC}ListSource{$ELSE}LookupSource{$ENDIF}.DataSet.FindField ( {$IFDEF FPC}KeyField{$ELSE}LookupField{$ENDIF} ))
  and assigned ( Field ) Then
    try
      // affectation
      FDataLink.Dataset.edit ;
      FDataLink.Field.Value := {$IFDEF FPC}ListSource{$ELSE}LookupSource{$ENDIF}.DataSet.FindField ( {$IFDEF FPC}KeyField{$ELSE}LookupField{$ENDIF} ).Value ;
    finally
    End ;
  inherited Change;
end;
*)


procedure TExtDBComboInsert.SetSearchSource(Value: TDataSource);
begin
  if Value <> FSearchSource Then
    FSearchSource := Value;
end;


///////////////////////////////////////////////////////////////////////////
// fonction    : AssignListValue
// description : Récupère la valeur affichée
////////////////////////////////////////////////////////////////////////////////
procedure TExtDBComboInsert.AssignListValue;
Begin
    // Verify Text value or locate
  If  assigned ( Field )
  and ( Field.Value <> Null )
  and assigned ( SearchSource )
  and assigned ( SearchSource.DataSet )
  Then
    with SearchSource.DataSet do
     if not (State in [dsEdit,dsInsert]) Then
       Begin
        Open;
        if  assigned ( FindField ( SearchList ))
        and ( FindField ( SearchList ).AsString <> {$IFDEF FPC}Text{$ELSE}Value{$ENDIF} )
        and assigned ( FindField ( SearchDisplay   ))
         Then
          try
            DisableControls;
            if Locate ( SearchDisplay, Field.Value, [] ) Then
              // récupération à partir de la liste
              {$IFDEF FPC}Text{$ELSE}Value{$ENDIF} := FindField ( SearchList ).AsString ;

          finally
            EnableControls;
          end;
       end;
End ;


////////////////////////////////////////////////////////////////////////////////
// Evènement   : UpdateData
// description : Mise à jour après l'édition des données
// paramètre   : Sender : pour l'évènement
////////////////////////////////////////////////////////////////////////////////
procedure TExtDBComboInsert.TextChanged;
begin
  // auto-insertion spécifique de ce composant
  InsertLookup ( False );
  // Validation de l'édition
  Inherited;
  // affectation
//  Field.Value := SearchSource.Dataset.FindField ( SearchDisplay ).Value;
end;

procedure TExtDBComboInsert.ValidateSearch;
Begin
  if not FSet
  and Flocated Then
  with SearchSource do
  if fb_Locate ( DataSet, SearchList, Text, [loCaseInsensitive, loPartialKey], True )
   Then
      Begin
        Flocated  := True;
        FSet := True;
        {$IFDEF FPC}Text{$ELSE}DisplayValue{$ENDIF} := DataSet.FindField ( SearchList ).AsString;
        if assigned ( FOnSet ) Then
          FOnSet ( Self )
      End ;
end;


////////////////////////////////////////////////////////////////////////////////
// procédure   : DoEnter
// description : Attribue le focus au composant
////////////////////////////////////////////////////////////////////////////////
procedure TExtDBComboInsert.DoEnter;
begin
  if assigned ( FBeforeEnter ) Then
    FBeforeEnter ( Self );
  // Si on arrive sur une zone de saisie, on met en valeur son tlabel par une couleur
  // de fond bleu et son libellé en marron (sauf si le libellé est sélectionné
  // avec la souris => cas de tri)
  p_setLabelColorEnter ( FLabel, FColorLabel, FAlwaysSame );
  p_setCompColorEnter  ( Self, FColorFocus, FAlwaysSame );
  inherited DoEnter;
  // Sélectionne le texte
  SelectAll ;
end;

////////////////////////////////////////////////////////////////////////////////
// procédure   : InsertLookup
// description : Insertion automatique
// paramètre   : Update : validation du champ si pas en train de valider
////////////////////////////////////////////////////////////////////////////////
procedure TExtDBComboInsert.InsertLookup ( const AUpdate : Boolean );
var LText : String;
begin
  if ( csDesigning in ComponentState ) Then
    Exit ;
    // vérifications
  if  assigned ( Field )
  and assigned ( Field.Dataset )
  and assigned ( SearchSource )
  and assigned ( SearchSource.DataSet ) Then
    with SearchSource,DataSet do
    try
      LText := Text;
      Open;
      if ( LText > '' ) Then
       Begin
        // Si du texte est présent
        if not Locate ( SearchList, LText, [loCaseInsensitive] ) Then
              // Autoinsertion si pas dans la liste
          Begin
            Updating;
            Insert ;
            FieldByName ( SearchList ).Value := LText ;
            Post ;
            Updated;
            FUpdate := True ;
            fb_RefreshDataset(DataSet);
            if Locate ( SearchList, LText, [] ) Then
              Begin
                Field.Dataset.Edit;
                Field.Value := FieldByName ( SearchDisplay ).Value ;
                {$IFDEF FPC}Text{$ELSE}DisplayValue{$ENDIF} := FindField ( SearchList ).Value ;
                if assigned ( FOnSet ) Then
                  FOnSet ( Self );
              end;
          End
         Else
          if assigned ( Field.DataSet )
          and ( Field.DataSet.State in [dsEdit,dsInsert] )
           Then
            Field.Value := FieldByName ( SearchDisplay ).Value ;
       End
      Else
       if AUpdate
       and ( OldText > '' )
       and assigned (  Field )
       and assigned (  Field.DataSet )
        Then
        // pas de texte : on remet le texte originel
         Field.AsString := OldText ;
      FModify := False ;
    except
      {$IFDEF FPC}
      SelectAll;
      {$ENDIF}
      SetFocus;
      raise;
    end;
End ;

////////////////////////////////////////////////////////////////////////////////
// procédure   : DoExit
// description : Défocus du composant
////////////////////////////////////////////////////////////////////////////////
procedure TExtDBComboInsert.DoExit;
begin
  // Auto-insertion
  with Field do
    InsertLookup ( not assigned ( Field ) or not assigned ( Dataset ) or ( DataSet.State in [dsEdit,dsInsert ] ) );
  if assigned ( FBeforeExit ) Then
    FBeforeExit ( Self );
  inherited DoExit;
  p_setLabelColorExit ( FLabel, FAlwaysSame );
  p_setCompColorExit ( Self, FOldColor, FAlwaysSame );
end;

////////////////////////////////////////////////////////////////////////////////
// fonction    : GetTextMargins
// description : Récupère les marges sur le texte
// paramètre   : résultat : les marges du haut et du bas
////////////////////////////////////////////////////////////////////////////////
function TExtDBComboInsert.GetTextMargins: TPoint;
var
  DC: HDC;
  SaveFont: HFont;
  I: Integer;
  SysMetrics, Metrics: TTextMetric;
begin
  // mode style 3D ou pas
  if NewStyleControls then
  begin
  {$IFNDEF FPC}
    if Ctl3D then
      I := 1
    else
  {$ENDIF}
{$IFDEF FPC}
    if BorderStyle = bsNone then
{$ENDIF}
      I := 0
{$IFDEF FPC}
    else
      // mode enfoncement et superposé
      I := 2;
{$ELSE}
;
{$ENDIF}
      // Nouvelles marges : avertir windows
    {$IFDEF FPC}
    Result.X := I;
    {$ELSE}
    Result.X := SendMessage(Handle, EM_GETMARGINS, 0, 0) and $0000FFFF + I;
    {$ENDIF}
    Result.Y := I;
  end
  else
  begin
    // Aucune marge prédéfinie sinon
{$IFDEF FPC}
    if BorderStyle = bsNone then
{$ENDIF}
      I := 0
{$IFDEF FPC}
    else
    begin
      // calculs des marges autour du texte
      DC := GetDC({$IFDEF FPC}0{$ELSE}HWND_DESKTOP{$ENDIF});
      GetTextMetrics(DC, SysMetrics);
      SaveFont := SelectObject(DC, Font.Handle);
      GetTextMetrics(DC, Metrics);
      SelectObject(DC, SaveFont);
      ReleaseDC({$IFDEF FPC}0{$ELSE}HWND_DESKTOP{$ENDIF}, DC);
      I := SysMetrics.tmHeight;
      if I > Metrics.tmHeight then
        I := Metrics.tmHeight;
      I := I div 4;
    end
{$ENDIF};
    Result.X := I;
    Result.Y := I;
  end;
end;

function TExtDBComboInsert.GetSearchSource: TDataSource;
begin
  Result := FSearchSource;
end;



{$IFDEF VERSIONS}
initialization
  p_ConcatVersion ( gVer_TDBLookupComboInsert );
{$ENDIF}
end.

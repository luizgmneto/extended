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
    FSearchKey    : TFieldDataLink;
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
    function GetSearchKey: String;
    function GetSearchSource: String;
    procedure SetSearchKey(AValue: String);
    procedure SetSearchSource(const Value: String);
    procedure p_setLabel ( const alab_Label: TLabel );
  protected
    OldText : String ;
    OldSelStart : Integer;
    function GetText: TCaption;
    procedure SetText(AValue: TCaption);
    procedure MouseDown( Button : TMouseButton; Shift : TShiftState; X,Y : Integer); override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure ValidateSearch; virtual;
    procedure SetSelText(const Val: string); override;
    procedure CompleteText; virtual;

    procedure TextChanged; override;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure InsertLookup ( const AUpdate : Boolean ); virtual ;

    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyUp(var Key: Word; Shift: TShiftState); override;
    {$IFDEF FPC}
    procedure UTF8KeyPress(var CharKey: TUTF8Char); override;
    {$ELSE}
    procedure KeyPress(var CharKey: Char); override;
    {$ENDIF}
  public
    constructor Create ( AOwner : TComponent ); override;
    destructor Destroy; override;
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
    property SearchKey: String read GetSearchKey write SetSearchKey;
    property HideSelection : Boolean read FHideSelection write FHideSelection default false;
    property ReadOnly default False;
    property Text: TCaption read GetText write SetText;
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
  FSearchKey := TFieldDataLink.Create;
end;

destructor TExtDBComboInsert.Destroy;
begin
  inherited Destroy;
  FSearchKey.Destroy;
end;

procedure TExtDBComboInsert.p_setLabel(const alab_Label: TLabel);
begin
  p_setMyLabel ( FLabel, alab_Label, Self );
end;

procedure TExtDBComboInsert.SetText(AValue: TCaption);
begin
  Inherited SetText(AValue);
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
  inherited KeyUp(Key, Shift);
end;

procedure TExtDBComboInsert.UTF8KeyPress(var CharKey: TUTF8Char);
var
  AChar: Char;
begin
  //If the pressed key is unicode then map the char to #255
  //Necessary to keep the TField.IsValidChar check
  if Length(CharKey) = 1 then
    AChar := CharKey[1]
  else
    AChar := #255;

  //handle standard keys
  if AChar in [#32..#255] then
  begin
    if GetSearchKey > '' then
     Begin
       if (   not FieldCanAcceptKey(SearchLink.Field, AChar)
           or not assigned(SearchSource))
       and ( not assigned(Field.DataSet)
            or not Field.DataSet.CanModify)
        Then
         CharKey := '';
       Exit;
     end;
  end;
  inherited UTF8KeyPress(CharKey);
end;

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
  and assigned ( SearchSource ) Then
    with SearchSource.DataSet do
      Begin
        Open;
        FSet := False;
        if not assigned ( FindField ( SearchDisplay )) Then Exit;
        if fb_Locate ( SearchSource.DataSet,
                       SearchDisplay,
                       Text, [loCaseInsensitive, loPartialKey], True )
         Then
          Begin
            Flocated  := True;
            li_pos    := SelStart ;
            ls_temp   := FindField ( SearchDisplay ).AsString;
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


procedure TExtDBComboInsert.SetSearchSource(const Value: String);
begin
  if Value <> FSearchKey.FieldName Then
    FSearchKey.FieldName := Value;
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
        if  assigned ( FindField ( SearchDisplay ))
        and ( FindField ( SearchDisplay ).AsString <> Text )
        and assigned ( FindField ( SearchKey   ))
         Then
          try
            DisableControls;
            if Locate ( SearchKey, Field.Value, [] ) Then
              // récupération à partir de la liste
              Text := FindField ( SearchDisplay ).AsString ;

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
//  Field.Value := SearchSource.Dataset.FindField ( SearchKey ).Value;
end;

procedure TExtDBComboInsert.ValidateSearch;
Begin
  if not FSet
  and Flocated Then
  with SearchSource do
  if fb_Locate ( DataSet, SearchDisplay, Text, [loCaseInsensitive, loPartialKey], True )
   Then
      Begin
        Flocated  := True;
        FSet := True;
        Text := DataSet.FindField ( SearchDisplay ).AsString;
        if assigned ( FOnSet ) Then
          FOnSet ( Self )
      End ;
end;

procedure TExtDBComboInsert.SetSelText(const Val: string);
begin
  inherited SetSelText(Val);
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
        if not Locate ( SearchDisplay, LText, [loCaseInsensitive] ) Then
              // Autoinsertion si pas dans la liste
          Begin
            Updating;
            Insert ;
            FieldByName ( SearchDisplay ).Value := LText ;
            Post ;
            Updated;
            FUpdate := True ;
            fb_RefreshDataset(DataSet);
            if Locate ( SearchDisplay, LText, [] ) Then
              Begin
                Field.Dataset.Edit;
                Field.Value := FieldByName ( SearchKey ).Value ;
                Text := FindField ( SearchDisplay ).Value ;
                if assigned ( FOnSet ) Then
                  FOnSet ( Self );
              end;
          End
         Else
          Begin
            if Text <> LText Then
              Text := FindField ( SearchDisplay ).Value ;
            if assigned ( Field.DataSet )
            and ( Field.DataSet.State in [dsEdit,dsInsert] )
             Then
              Field.Value := FieldByName ( SearchKey ).Value ;
          end;
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
// fonction   : GetSearchSource
// description : Rénvoie SearchSource
////////////////////////////////////////////////////////////////////////////////
function TExtDBComboInsert.GetSearchSource: String;
begin
  Result := FSearchKey.FieldName;
end;

function TExtDBComboInsert.GetText: TCaption;
begin
  if SearchKey > ''  Then
   Begin
     if  Assigned(SearchSource)
     and Assigned(SearchSource.DataSet) Then
      with SearchSource.DataSet do
       if Assigned(FindField(SearchDisplay))
        then Result:=FindField(SearchDisplay).AsString
        Else Result:='';
   end
  Else Result:=Inherited;
end;

function TExtDBComboInsert.GetSearchKey: String;
begin
  Result:=FSearchKey.FieldName;
end;

procedure TExtDBComboInsert.SetSearchKey(AValue: String);
begin
  FSearchKey.FieldName:=AValue;
end;



{$IFDEF VERSIONS}
initialization
  p_ConcatVersion ( gVer_TDBLookupComboInsert );
{$ENDIF}
end.

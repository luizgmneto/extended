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
     Graphics, Menus, ComCtrls, DB,DBCtrls, Dialogs,
     fonctions_version, u_framework_dbcomponents ;

{$IFDEF VERSIONS}
  const
    gVer_TDBLookupComboInsert : T_Version = ( Component : 'Composant TDBComboBoxInsert' ;
                                               FileUnit : 'U_DBComboBoxInsert' ;
                                               Owner : 'Matthieu Giroux' ;
                                               Comment : 'Insertion automatique dans une DBComboLookupEdit.' ;
                                               BugsStory : '1.0.1.4 : Better component testing.' +#13#10
                                                         + '1.0.1.3 : Compiling on lazarus.' +#13#10
                                                         + '1.0.1.2 : Bug validation au post.' +#13#10
                                                         + '1.0.1.1 : Bug rafraîchissement quand pas de focus.' +#13#10
                                                         + '1.0.1.0 : Propriété Modify.' +#13#10
                                                         + '1.0.0.0 : Version bêta inadaptée, réutilisation du code de la TJvDBLookupComboEdit.' +#13#10
                                                         + '0.9.0.0 : En place à tester.';
                                               UnitType : 3 ;
                                               Major : 1 ; Minor : 0 ; Release : 1 ; Build : 4 );

{$ENDIF}
type

  TExtDBComboInsert = class;

{ TExtDBComboInsert }
  TExtDBComboInsert = class(TFWDBLookupCombo)
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
    FHideSelection,
    FFocused: Boolean;
    FOnLocate,
    FOnSet : TNotifyEvent ;
    // En train de mettre à jour ou pas
    FUpdate ,
    // Beep sur erreur
    FBeepOnError: Boolean;
    function GetSearchSource: TDataSource;
    {$IFNDEF RXJVCOMBO}
    procedure ResetMaxLength;
    {$ENDIF}
    procedure SetSearchSource(Value: TDataSource);
    procedure WMPaint(var Msg: {$IFDEF FPC}TLMPaint{$ELSE}TWMPaint{$ENDIF} ); message {$IFDEF FPC}LM_PAINT{$ELSE}WM_PAINT{$ENDIF};
  protected
    OldText : String ;
    OldSelStart : Integer;
    function GetTextMargins: TPoint; virtual;
    procedure ValidateSearch; virtual;
    {$IFDEF FPC}
    {$IFNDEF RXCOMBO}
    procedure SetSelText(const Val: string); override;
    procedure CompleteText; virtual;
    {$ENDIF}
    procedure RealSetText(const AValue: TCaption); override;
    {$ENDIF}

    procedure {$IFDEF FPC}UpdateData{$IFNDEF RXCOMBO}(Sender: TObject){$ENDIF}{$ELSE}DataLinkUpdateData{$ENDIF}; override;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure {$IFNDEF RXJVCOMBO}DataChange(Sender: TObject){$ELSE}DataLinkRecordChanged(Field:TField){$ENDIF}; override;
    procedure InsertLookup ( const AUpdate : Boolean ); virtual ;

    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyUp(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
  public
    {$IFDEF RXJVCOMBO}
    procedure SelectAll; virtual;
    {$ENDIF}
    function GetDisplayValue: String;virtual;
    procedure DoEnter; override;
    procedure DoExit; override;
    property Modify : Boolean read FModify ;
    constructor Create(AOwner: TComponent); override;
    property DisplayValue : String read FDisplayValue write FDisplayValue;
  published
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
  SysUtils, Forms, StdCtrls, fonctions_erreurs,
  {$IFDEF FPC}
  LCLProc,
  {$ELSE}
  JvConsts, JvToolEdit,
  {$ENDIF}
  unite_messages, fonctions_db;

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
  // Création popup
    // Glyph de combo par défaut
end;


////////////////////////////////////////////////////////////////////////////////
// procédure   : ResetMaxLength
// description : Vérifications avant affectation de la taille du texte à rien
////////////////////////////////////////////////////////////////////////////////
{$IFNDEF RXJVCOMBO}
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

{$IFDEF RXJVCOMBO}
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
        {$IFNDEF RXJVCOMBO}SelText:='';{$ENDIF}
        Key := 0;
        Exit;
      end;
    VK_RETURN:
      Begin
        InsertLookup ( True );
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
      {$IFNDEF RXJVCOMBO}
      CompleteText;
      {$ENDIF}
       if  ( (( {$IFNDEF RXJVCOMBO}ListField{$ELSE}LookupDisplay{$ENDIF} = '' ) and not Field.IsValidChar(Key))
       or  ( ( {$IFNDEF RXJVCOMBO}ListField{$ELSE}LookupDisplay{$ENDIF} <> '' ) and
       ( not assigned ( {$IFNDEF RXJVCOMBO}ListSource{$ELSE}LookupSource{$ENDIF} )
        or not assigned ( {$IFNDEF RXJVCOMBO}ListSource{$ELSE}LookupSource{$ENDIF}.DataSet )
        or not assigned ( {$IFNDEF RXJVCOMBO}ListSource{$ELSE}LookupSource{$ENDIF}.DataSet.FindField ( {$IFNDEF RXJVCOMBO}ListField{$ELSE}LookupDisplay{$ENDIF} ) )
        or not {$IFNDEF RXJVCOMBO}ListSource{$ELSE}LookupSource{$ENDIF}.DataSet.FindField ( {$IFNDEF RXJVCOMBO}ListField{$ELSE}LookupDisplay{$ENDIF} ).IsValidChar(Key)))) then
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
{$IFNDEF RXJVCOMBO}
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
        if not assigned ( FindField ( {$IFNDEF RXJVCOMBO}ListField{$ELSE}LookupDisplay{$ENDIF} )) Then Exit;
        if fb_Locate ( FSearchSource.DataSet,
                       {$IFNDEF RXJVCOMBO}ListField{$ELSE}LookupDisplay{$ENDIF},
                       Text, [loCaseInsensitive, loPartialKey], True )
         Then
          Begin
            Flocated  := True;
            li_pos    := SelStart ;
            ls_temp   := FindField ( {$IFNDEF RXJVCOMBO}ListField{$ELSE}LookupDisplay{$ENDIF} ).AsString;
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
// fonction    : GetDisplayValue
// description : Récupère la valeur affichée
// paramètre   : résultat : la valeur affichée
////////////////////////////////////////////////////////////////////////////////
function  TExtDBComboInsert.GetDisplayValue : String ;
Begin
  Result := '' ;
    // Tests
  If  assigned ( Field )
  and not Field.IsNull
  and assigned ( {$IFNDEF RXJVCOMBO}ListSource{$ELSE}LookupSource{$ENDIF} )
  and assigned ( {$IFNDEF RXJVCOMBO}ListSource{$ELSE}LookupSource{$ENDIF}.DataSet )
  and assigned ( {$IFNDEF RXJVCOMBO}ListSource{$ELSE}LookupSource{$ENDIF}.DataSet.FindField ( {$IFNDEF RXJVCOMBO}ListField{$ELSE}LookupDisplay{$ENDIF} ))
  and assigned ( {$IFNDEF RXJVCOMBO}ListSource{$ELSE}LookupSource{$ENDIF}.DataSet.FindField ( {$IFNDEF RXJVCOMBO}KeyField{$ELSE}LookupField{$ENDIF}   )) Then
    Begin
      if {$IFNDEF RXJVCOMBO}ListSource{$ELSE}LookupSource{$ENDIF}.DataSet.Locate ( {$IFNDEF RXJVCOMBO}KeyField{$ELSE}LookupField{$ENDIF}, Field.AsString, [] ) Then
        // récupération à partir de la listes
        Result := {$IFNDEF RXJVCOMBO}ListSource{$ELSE}LookupSource{$ENDIF}.DataSet.FindField ( {$IFNDEF RXJVCOMBO}ListField{$ELSE}LookupDisplay{$ENDIF} ).AsString ;
    End ;
End ;


//////////////////////////////////////////////////////////////////////////
// Evènement   : DataChange
// description : Changement dans les données
// paramètre   : Sender : pour l'évènement
////////////////////////////////////////////////////////////////////////////////
procedure TExtDBComboInsert.{$IFNDEF RXJVCOMBO}DataChange(Sender: TObject){$ELSE}DataLinkRecordChanged(Field:TField){$ENDIF};
begin
  {$IFNDEF RXJVCOMBO}
  ResetMaxLength;
  {$ENDIF}
  if Field <> nil then
  begin
    // récupération du masque de saisie
//    EditMask := FDataLink.Field.EditMask;
    {$IFNDEF RXJVCOMBO}
    if not (csDesigning in ComponentState) then
      if (Field.DataType in [ftString, ftWideString]) and (MaxLength = 0) then
        // Taille maxi
        MaxLength := Field.Size;
    {$ENDIF}
    if FFocused and Field.DataSet.CanModify then
      Begin
        // récupération des données de la liste en mode lecture
        if  ( not ( Field.DataSet.State in [dsEdit, dsInsert]) or FUpdate) Then
          Begin
            {$IFDEF FPC}Text{$ELSE}Value{$ENDIF} := GetDisplayValue ;
          End ;
      End
  end
  else
  begin
//    EditMask := '';
    if csDesigning in ComponentState then
      // Pas de donnée : on montre le nom de la combo
      {$IFDEF FPC}Text{$ELSE}Value{$ENDIF} := Name
    else
      {$IFDEF FPC}Text{$ELSE}Value{$ENDIF} := '' ;
  end;
end;

////////////////////////////////////////////////////////////////////////////////
// Evènement   : UpdateData
// description : Mise à jour après l'édition des données
// paramètre   : Sender : pour l'évènement
////////////////////////////////////////////////////////////////////////////////
procedure TExtDBComboInsert.{$IFDEF FPC}UpdateData{$IFNDEF RXCOMBO}(Sender: TObject){$ENDIF}{$ELSE}DataLinkUpdateData{$ENDIF};
begin
  // auto-insertion spécifique de ce composant
  InsertLookup ( False );
  // Validation de l'édition
//  ValidateEdit;
  // affectation
//  KeyValue := {$IFNDEF RXJVCOMBO}ListSource{$ELSE}LookupSource{$ENDIF}.Dataset.FindField ( {$IFNDEF RXJVCOMBO}KeyField{$ELSE}LookupField{$ENDIF} ).Value;
end;

procedure TExtDBComboInsert.ValidateSearch;
Begin
  if not FSet
  and Flocated
  and fb_Locate ( {$IFNDEF RXJVCOMBO}ListSource{$ELSE}LookupSource{$ENDIF}.DataSet, {$IFNDEF RXJVCOMBO}ListField{$ELSE}LookupDisplay{$ENDIF}, Text, [loCaseInsensitive, loPartialKey], True )
   Then
     with {$IFNDEF RXJVCOMBO}ListSource{$ELSE}LookupSource{$ENDIF}.DataSet do
      Begin
        Flocated  := True;
        FSet := True;
        {$IFDEF FPC}Text{$ELSE}DisplayValue{$ENDIF} := FindField ( {$IFNDEF RXJVCOMBO}ListField{$ELSE}LookupDisplay{$ENDIF} ).AsString;
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
begin
  if ( csDesigning in ComponentState ) Then
    Exit ;
    // vérifications
  if  assigned ( Field )
  and assigned ( Field.Dataset )
  and assigned ( {$IFNDEF RXJVCOMBO}ListSource{$ELSE}LookupSource{$ENDIF} )
  and assigned ( {$IFNDEF RXJVCOMBO}ListSource{$ELSE}LookupSource{$ENDIF}.DataSet ) Then
    try
      if ( Text <> '' ) Then
        // Si du texte est présent
        Begin
          if not {$IFNDEF RXJVCOMBO}ListSource{$ELSE}LookupSource{$ENDIF}.DataSet.Locate ( {$IFNDEF RXJVCOMBO}ListField{$ELSE}LookupDisplay{$ENDIF}, Text, [loCaseInsensitive] ) Then
            // Autoinsertion si pas dans la liste
            Begin
              {$IFNDEF RXJVCOMBO}ListSource{$ELSE}LookupSource{$ENDIF}.DataSet.Insert ;
              {$IFNDEF RXJVCOMBO}ListSource{$ELSE}LookupSource{$ENDIF}.DataSet.FieldByName ( {$IFNDEF RXJVCOMBO}ListField{$ELSE}LookupDisplay{$ENDIF} ).Value := Text ;
              {$IFNDEF RXJVCOMBO}ListSource{$ELSE}LookupSource{$ENDIF}.DataSet.Post ;
              Field.Dataset.Edit;
              Field.Value := {$IFNDEF RXJVCOMBO}ListSource{$ELSE}LookupSource{$ENDIF}.DataSet.FieldByName ( {$IFNDEF RXJVCOMBO}KeyField{$ELSE}LookupField{$ENDIF} ).Value ;
              {$IFDEF FPC}Text{$ELSE}DisplayValue{$ENDIF} := {$IFNDEF RXJVCOMBO}ListSource{$ELSE}LookupSource{$ENDIF}.DataSet.FindField ( {$IFNDEF RXJVCOMBO}ListField{$ELSE}LookupDisplay{$ENDIF} ).Value ;
              FUpdate := True ;
              if assigned ( FOnSet ) Then
                FOnSet ( Self );
            End;
        End
      Else
       if AUpdate
       and assigned (  Field ) Then
        // pas de texte : on remet le texte originel
        Field.Value := OldText ;
      FModify := False ;
    except
      {$IFDEF FPC}
      SelectAll;
      {$ENDIF}
      SetFocus;
      raise;
    end;
  FUpdate := False ;
End ;

////////////////////////////////////////////////////////////////////////////////
// procédure   : DoExit
// description : Défocus du composant
////////////////////////////////////////////////////////////////////////////////
procedure TExtDBComboInsert.DoExit;
begin
  // Auto-insertion
  InsertLookup ( True );
  inherited DoExit;
end;

////////////////////////////////////////////////////////////////////////////////
// Evènement message  : WMPaint
// description : Peinture de la combo
// paramètre   : Msg : données du message
////////////////////////////////////////////////////////////////////////////////
procedure TExtDBComboInsert.WMPaint(var Msg: {$IFDEF FPC}TLMPaint{$ELSE}TWMPaint{$ENDIF});
const
  AlignStyle: array [Boolean, TAlignment] of DWORD =
   ((WS_EX_LEFT, WS_EX_RIGHT, WS_EX_LEFT),
    (WS_EX_RIGHT, WS_EX_LEFT, WS_EX_LEFT));
var
  Left: Integer;
  Margins: TPoint;
  R: TRect;
  DC: HDC;
  PS: TPaintStruct;
  S: string;
  AAlignment: TAlignment;
begin
  // destruction : pas besoin de peindre
  if csDestroying in ComponentState then
    Exit;
  // alignement horizontal en cours
  AAlignment := taLeftJustify; //FAlignment;
  if UseRightToLeftAlignment then
    ChangeBiDiModeAlignment(AAlignment);

{ Since edit controls do not handle justification unless multi-line (and
  then only poorly) we will draw right and center justify manually unless
  the edit has the focus. }
  // Initialisation de la peinture
  DC := Msg.DC;
  if DC = 0 then
    DC := BeginPaint(Handle, PS);
  PaintWindow(DC);
  Canvas.Handle := DC;
  try
    // couleur de police
    Canvas.Font := Font;
    with Canvas do
    begin
      R := ClientRect;
      if not (NewStyleControls {$IFNDEF FPC}and Ctl3D{$ENDIF}) {$IFDEF FPC} and (BorderStyle = bsSingle) {$ENDIF} then
      // Mode simple
      begin
        Brush.Color := clWindowFrame;
        FrameRect(R);
        InflateRect(R, -1, -1);
      end;
      // Couleur de pinceau
      Brush.Color := Color;
      if not Enabled then
        // désactivation
        Font.Color := clGrayText;
      if (csPaintCopy in ControlState) and (Field <> nil) then
      begin
        //récupération du texte du champ
        S := Field.DisplayText;
        {$IFNDEF RXJVCOMBO}
        case CharCase of
          ecUpperCase:
            S := AnsiUpperCase(S);
          ecLowerCase:
            S := AnsiLowerCase(S);
        end;
        {$ENDIF}
      end
      else
        //récupération du texte d'édition
        S := Text;
        // mode mot de passe
//      if PasswordChar <> #0 then
//        FillChar(S[1], Length(S), PasswordChar);
        // Marges
      Margins := GetTextMargins;
      case AAlignment of
        taLeftJustify:
          Left := Margins.X;
        taRightJustify:
          Left := ClientWidth - TextWidth(S) - Margins.X - 1;
      else
        Left := (ClientWidth - TextWidth(S)) div 2;
      end;
//      if SysLocale.MiddleEast then
//        UpdateTextFlags;
        // affiche le texte
      TextRect(R, Left, Margins.Y, S);
    end;
  finally
    // libération du canevas
    Canvas.Handle := 0;
    if Msg.DC = 0 then
      EndPaint(Handle, PS);
  end;
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

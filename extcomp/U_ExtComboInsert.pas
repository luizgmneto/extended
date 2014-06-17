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
    FSearchKey   : String;
    FFieldKey    : TFieldDatalink;
    // Focus sur le composant
    // En train de mettre à jour ou pas
    FUpdate,
    FNotFound : Boolean;

    //look
    FNotifyOrder : TNotifyEvent;
    function GetFieldKey: String;
    procedure SetFieldKey(AValue: String);
  protected
    procedure KeyUp(var Key: Word; Shift: TShiftState); override;
    procedure AutoInsert; virtual;
    procedure NotFound; override ;
    procedure Locating; override ;
    procedure DoEnter; override ;
    procedure DoExit; override ;
  public
    constructor Create ( AOwner : TComponent ); override;
    destructor Destroy ; override;
    procedure Loaded; override ;
    procedure LoadSourceKey; virtual;
    procedure AssignListValue;virtual;
  published
    property OnOrder : TNotifyEvent read FNotifyOrder write FNotifyOrder;
    property SearchKey: String read FSearchKey write FSearchKey;
    property DataKey: String read GetFieldKey write SetFieldKey;
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
  FUpdate := False ;
  FNotFound := False;
  // look
  FSearchKey := '';
  FFieldKey := TFieldDataLink.Create;
end;

destructor TExtDBComboInsert.Destroy;
begin
  inherited Destroy;
  FFieldKey.Destroy;
end;

procedure TExtDBComboInsert.Loaded;
begin
  LoadSourceKey;
  inherited Loaded;
end;

procedure TExtDBComboInsert.LoadSourceKey;
begin
  if assigned ( Datasource ) Then
   Begin
    FFieldKey.Datasource := Datasource;
    if DataField = ''
     Then
      Datasource:=nil;
   end
  Else
   Datasource := FFieldKey.Datasource;
end;



///////////////////////////////////////////////////////////////////////////
// fonction    : AssignListValue
// description : Récupère la valeur affichée
////////////////////////////////////////////////////////////////////////////////
procedure TExtDBComboInsert.AssignListValue;
Begin
    // Verify Text value or locate
  If  assigned ( FFieldKey.Field )
  and not FFieldKey.Field.IsNull
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
procedure TExtDBComboInsert.NotFound;
var LText : String;
begin
  inherited;
  FNotFound := True;
End ;

procedure TExtDBComboInsert.Locating;
begin
  inherited Locating;
  FNotFound:=False;
end;

////////////////////////////////////////////////////////////////////////////////
// procédure   : DoExit
// description : Défocus du composant
////////////////////////////////////////////////////////////////////////////////
procedure TExtDBComboInsert.DoExit;
begin
  // Auto-insertion
  AutoInsert;
  inherited DoExit;
end;

procedure TExtDBComboInsert.AutoInsert;
var LText : String;
begin
  // Auto-insertion
  if FNotFound Then
    with SearchSource,DataSet do
     Begin
      LText := Text;
      Updating;
      Insert ;
      FieldByName ( SearchDisplay ).Value := LText;
      Post ;
      Updated;
      FUpdate := True ;
      fb_RefreshDataset(DataSet);
      if Locate ( SearchDisplay, LText, [] ) Then
        Begin
          Text := FindField ( SearchDisplay ).Value ;
          if Assigned ( FFieldKey.Field )
           Then
            Begin
             FFieldKey.Dataset.Edit;
             FFieldKey.Field.Value := FieldByName ( SearchKey ).Value;
            end;
          if assigned ( OnSet ) Then
            OnSet ( Self );
        end;
     end;
end;

function TExtDBComboInsert.GetFieldKey: String;
begin
  Result:=FFieldKey.FieldName;
end;

procedure TExtDBComboInsert.SetFieldKey(AValue: String);
begin

  FFieldKey.FieldName:=AValue;
end;

procedure TExtDBComboInsert.KeyUp(var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN Then
   AutoInsert;
  if (Key = VK_ESCAPE )
  and FNotFound Then
   Begin
     FNotFound := False;
     Text:=Field.AsString ;
   end;
  inherited KeyUp(Key, Shift);
end;



{$IFDEF VERSIONS}
initialization
  p_ConcatVersion ( gVer_TDBLookupComboInsert );
{$ENDIF}
end.

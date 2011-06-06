﻿{*********************************************************************}
{                                                                     }
{                                                                     }
{             TExtSearchEdit :                               }
{             Objet issu d'un TDBedit qui associe les         }
{             avantages de la DBEdit avec une recherche     }
{             Créateur : Matthieu Giroux                          }
{             31 Mars 2005                                            }
{             Version 1.0                                             }
{                                                                     }
{                                                                     }
{*********************************************************************}

unit u_extsearchedit;

{$I ..\Compilers.inc}

interface

uses Variants, Controls, Classes,
     {$IFDEF FPC}
     LMessages, LCLType,
     {$ELSE}
     Messages, Windows,
     {$ENDIF}
     Graphics, Menus, DB,DBCtrls, u_framework_components,
     u_extcomponent,
     fonctions_version ;

{$IFDEF VERSIONS}
  const
    gVer_TExtSearchDBEdit : T_Version = ( Component : 'Composant TExtSearchDBEdit' ;
                                          FileUnit : 'U_TExtSearchDBEdit' ;
                                          Owner : 'Matthieu Giroux' ;
                                          Comment : 'Searching in a dbedit.' ;
                                          BugsStory : '0.9.0.2 : Not tested, upgrading.'
                                                    + '0.9.0.1 : Not tested, compiling on DELPHI.'
                                                    + '0.9.0.0 : In place not tested.';
                                          UnitType : 3 ;
                                          Major : 0 ; Minor : 9 ; Release : 0 ; Build : 2 );

{$ENDIF}
type

{ TExtSearchDBEdit }
  TExtSearchDBEdit = class(TDBEdit)
  private
    FieldName: String;
    // Lien de données
    FSearchSource: TFieldDataLink;
    FFieldKey ,
    FSearchKey : String;
    FOnLocate : TNotifyEvent ;
    Flocated : Boolean ;
    FBeforeEnter, FAfterExit : TNotifyEvent;
    FOnSet : TDatasetNotifyEvent;
    FLabel : TFWLabel ;
    FOldColor ,
    FColorFocus ,
    FColorReadOnly,
    FColorEdit ,
    FColorLabel : TColor;
    FSet,
    FAlwaysSame : Boolean;
    FNotifyOrder : TNotifyEvent;
    procedure p_setSearchDisplay ( AValue : String );
    function fs_getSearchDisplay : String ;
    procedure p_setSearchSource ( AValue : TDataSource );
    function fs_getSearchSource : TDataSource ;
    procedure p_setLabel ( const alab_Label : TFWLabel );
    procedure WMPaint(var Message: {$IFDEF FPC}TLMPaint{$ELSE}TWMPaint{$ENDIF}); message {$IFDEF FPC}LM_PAINT{$ELSE}WM_PAINT{$ENDIF};
  protected
    procedure KeyUp(var Key: Word; Shift: TShiftState); override;
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
    property SearchKey : String read FSearchKey write FSearchKey ;
    property DataKey : String read FFieldKey write FFieldKey ;
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
    property OnSet : TDatasetNotifyEvent read FOnSet write FOnSet;
  end;

implementation

uses Dialogs, fonctions_db;
{ TExtSearchDBEdit }

procedure TExtSearchDBEdit.p_setSearchDisplay(AValue: String);
begin
  FSearchSource.FieldName:= AValue;
end;

function TExtSearchDBEdit.fs_getSearchDisplay: String;
begin
  Result := FSearchSource.FieldName;
end;

procedure TExtSearchDBEdit.p_setSearchSource(AValue: TDataSource);
begin
  FSearchSource.DataSource := AValue;
end;

function TExtSearchDBEdit.fs_getSearchSource: TDataSource;
begin
  Result := FSearchSource.DataSource;
end;

procedure TExtSearchDBEdit.p_setLabel(const alab_Label: TFWLabel);
begin
  if alab_Label <> FLabel Then
    Begin
      FLabel := alab_Label;
      FLabel.MyEdit := Self;
    End;
end;

procedure TExtSearchDBEdit.WMPaint(var Message: {$IFDEF FPC}TLMPaint{$ELSE}TWMPaint{$ENDIF});
begin
  p_setCompColorReadOnly ( Self,FColorEdit,FColorReadOnly, FAlwaysSame, ReadOnly );
  inherited;
end;

procedure TExtSearchDBEdit.KeyUp(var Key: Word; Shift: TShiftState);
var li_pos : Integer;
begin
  inherited KeyUp(Key, Shift);
  if Key in [ VK_ESCAPE ] Then
    Begin
      Flocated:=False;
      FSet := False;
      Exit;
    end;
  if not ( Key in [ VK_RETURN, VK_TAB, VK_DELETE, VK_BACK ])
  and ( Text    <> '' )
  and ( SelText =  '' )
   Then
    with FSearchSource.DataSet do
      Begin
        Open ;
        FSet := False;
        if not assigned ( FindField ( FSearchSource.FieldName )) Then Exit;
        if fb_Locate ( FSearchSource.DataSet, FSearchSource.FieldName, Text, [loCaseInsensitive, loPartialKey], True )
         Then
          Begin
            Flocated  := True;
            li_pos    := SelStart ;
            SelText   := Copy   ( FindField ( FieldName ).AsString, SelStart + 1,
                         length ( FindField ( FieldName ).AsString ) - length ( Text ));
            SelStart  := li_pos ;
            SelLength := length ( Text ) - li_pos ;
            if ( SelText = '' )  Then
                ValidateSearch
             else
                if assigned ( Datasource ) Then
                  FOnLocate ( Datasource.DataSet )
                 Else
                  FOnLocate ( nil );
          End ;
      end
   Else if ( Key in [ VK_RETURN ])
    Then
      ValidateSearch;

end;

procedure TExtSearchDBEdit.ValidateSearch;
Begin
  if not FSet
  and fb_Locate ( FSearchSource.DataSet, FSearchSource.FieldName, Text, [loCaseInsensitive, loPartialKey], True )
   Then
     with FSearchSource.DataSet do
      Begin
        Flocated  := True;
        FSet := True;
        Text := FindField ( FieldName ).AsString;
        if assigned ( FOnSet ) Then
          if assigned ( Datasource ) Then
            FOnSet ( Datasource.DataSet )
           Else
            FOnSet ( FSearchSource.DataSet );
      End ;
end;

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

procedure TExtSearchDBEdit.DoExit;
begin
  inherited DoExit;
  p_setLabelColorExit ( FLabel, FAlwaysSame );
  p_setCompColorExit ( Self, FOldColor, FAlwaysSame );
  ValidateSearch;
  if assigned ( FAfterExit ) Then
    FAfterExit ( Self );
end;

procedure TExtSearchDBEdit.Loaded;
begin
  inherited Loaded;
  FOldColor := Color;
  if  FAlwaysSame
   Then
    Color := gCol_Edit ;
end;

procedure TExtSearchDBEdit.SetOrder;
begin
  if assigned ( FNotifyOrder ) then
    FNotifyOrder ( Self );
end;

constructor TExtSearchDBEdit.Create(Aowner: TComponent);
begin
  inherited Create(Aowner);
  FSearchSource := TFieldDataLink.Create;
  Flocated:= False;
  FAlwaysSame := True;
  FColorLabel := CST_LBL_SELECT;
  FColorEdit  := CST_EDIT_STD;
  FColorFocus := CST_EDIT_SELECT;
  FColorReadOnly := CST_EDIT_READ;
end;

destructor TExtSearchDBEdit.Destroy;
begin
  inherited Destroy;
  FSearchSource.Free;
end;

{$IFDEF VERSIONS}
initialization
  p_ConcatVersion ( gVer_TExtSearchDBEdit );
{$ENDIF}
end.

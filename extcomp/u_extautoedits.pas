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

unit u_extautoedits;

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
     u_framework_dbcomponents,
     fonctions_string,
     {$IFDEF VERSIONS}
     fonctions_version,
     {$ENDIF}
     u_extcomponent, DBGrids, StdCtrls;

{$IFDEF VERSIONS}
const
    gVer_TExtAutoDBEdit : T_Version = ( Component : 'Composants Auto Edits' ;
                                          FileUnit : 'U_TExtAutoEdit' ;
                                          Owner : 'Matthieu Giroux' ;
                                          Comment : 'Searching in a dbedit.' ;
                                          BugsStory : '0.9.0.0 : In place not tested.';
                                          UnitType : 3 ;
                                          Major : 0 ; Minor : 9 ; Release : 0 ; Build : 0 );

{$ENDIF}

type

  { TExtAutoEdit }
  TExtAutoEdit = class(TFWEdit)
  private
    FNoAccent : Boolean;
    FModeFormat : TModeFormatText;
  protected
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
  public
    constructor Create ( Aowner : TComponent ); override;
  published
    property NoAccent : Boolean read FNoAccent write FNoAccent default False;
    property ModeFormat : TModeFormatText read FModeFormat write FModeFormat default mftNone;
  end;

  { TExtAutoDBEdit }
  TExtAutoDBEdit = class(TFWDBEdit)
  private
    FNoAccent : Boolean;
    FModeFormat : TModeFormatText;
  protected
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
  public
    constructor Create ( Aowner : TComponent ); override;
  published
    property NoAccent : Boolean read FNoAccent write FNoAccent default False;
    property ModeFormat : TModeFormatText read FModeFormat write FModeFormat default mftNone;
  end;

implementation

uses Dialogs, fonctions_db, sysutils;

{ TExtAutoEdit }

procedure TExtAutoEdit.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited KeyDown(Key, Shift);
  if FNoAccent or ( FModeFormat > mftNone ) Then
    Text:=fs_FormatText(Text,FModeFormat,FNoAccent);
end;

constructor TExtAutoEdit.Create(Aowner: TComponent);
begin
  inherited Create(Aowner);
  FNoAccent:=False;
  FModeFormat:=mftNone;
end;


{ TExtAutoDBEdit }

procedure TExtAutoDBEdit.KeyDown(var Key: Word; Shift: TShiftState);
begin
  Inherited;
  if FNoAccent or ( FModeFormat > mftNone ) Then
    Text:=fs_FormatText(Text,FModeFormat,FNoAccent);
end;

constructor TExtAutoDBEdit.Create(Aowner: TComponent);
begin
  Inherited;
  FNoAccent:=False;
  FModeFormat:=mftNone;
end;


{$IFDEF VERSIONS}
initialization
  // Versioning
  p_ConcatVersion ( gVer_TExtAutoDBEdit );
{$ENDIF}
end.

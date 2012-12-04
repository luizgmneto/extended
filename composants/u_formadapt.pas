unit U_FormAdapt;
// Unité de la Version 2 du projet FormMain
// La version 1 TFormMain n'est pas sa fenêtre parente

// Le module crée des propriété servant à la gestion du fichier INI
// Il gère la déconnexion
// Il gère la gestion des touches majuscules et numlock
// Il gère les forms enfants
// créé par Matthieu Giroux en décembre 2007

{$I ..\DLCompilers.inc}
{$I ..\extends.inc}

interface

{$IFDEF FPC}
{$mode Delphi}
{$ENDIF}

uses
{$IFDEF SFORM}
  CompSuperForm,
{$ENDIF}
{$IFDEF FPC}
  LCLIntf, LCLType, lmessages,
{$ELSE}
  Windows, OleDb, Messages,
{$ENDIF}
{$IFDEF VERSIONS}
  fonctions_version,
{$ENDIF}
{$IFDEF TNT}
  TNTForms,
{$ENDIF}
  SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, fonctions_init, IniFiles,
  fonctions_scaledpi;

{$IFDEF VERSIONS}
  const
    gVer_TFormAdapt : T_Version = (  Component : 'Fonts Adapting Form' ;
                                       FileUnit : 'U_FormAdapt' ;
                                       Owner : 'Matthieu Giroux' ;
                                       Comment : 'Fiche principale deuxième version.' ;
                                       BugsStory : '1.0.0.0 : Adapting Fonts.';
                                       UnitType : 3 ;
                                       Major : 1 ; Minor : 1 ; Release : 1 ; Build : 1 );

{$ENDIF}
type
  { TF_FormAdapt }

  TF_FormAdapt = class({$IFDEF SFORM}TSuperForm{$ELSE}{$IFDEF TNT}TTntForm{$ELSE}TForm{$ENDIF}{$ENDIF})
  private
    Echelle:Extended;
    NewEchelle: Extended;
  protected


  public
    { Déclarations publiques }
    // Constructeur et destructeur
    Constructor Create ( AOwner : TComponent ); override;
    procedure Activate; override;
  published

  end;

implementation

uses fonctions_erreurs, TypInfo,
  {$IFDEF FPC}
  unite_messages,
  {$ELSE}
  unite_messages_delphi,
  {$ENDIF}
   fonctions_system, fonctions_forms;

{ TF_FormAdapt }

constructor TF_FormAdapt.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Echelle:=1;
end;


procedure TF_FormAdapt.Activate;
var
  i: integer;
begin
  NewEchelle:=Screen.MenuFont.Size/FromDPI;
  if Echelle=NewEchelle then
    Begin
      inherited;
      exit;
    end;

  ScaleForm(Self,NewEchelle,Echelle);
  inherited;
end;


initialization
{$IFDEF VERSIONS}
  p_ConcatVersion ( gVer_TFormAdapt );
{$ENDIF}
end.

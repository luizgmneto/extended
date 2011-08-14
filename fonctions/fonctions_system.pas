// unité contenant des fonctions de traitements de chaine
unit fonctions_system;

interface

{$I ..\Compilers.inc}
{$I ..\extends.inc}

{$IFDEF FPC}
{$mode Delphi}
{$ENDIF}

uses
{$IFDEF FPC}
  LCLIntf,
{$ELSE}
  Windows, AdoConEd, MaskUtils,
{$ENDIF}
  Forms, SysUtils,
{$IFDEF VERSIONS}
  fonctions_version,
{$ENDIF}
  StrUtils, Classes ;

{$IFNDEF FPC}
const
  DirectorySeparator = '\' ;
{$ENDIF}


function fs_GetNameSoft : String;
{$IFDEF VERSIONS}
const
    gVer_fonction_system : T_Version = ( Component : 'Gestion des chaînes' ; FileUnit : 'fonctions_string' ;
                        			                 Owner : 'Matthieu Giroux' ;
                        			                 Comment : 'Fonctions de traduction et de formatage des chaînes.' ;
                        			                 BugsStory : 'Version 1.0.0.0 : Creating from fonctions_string.';
                        			                 UnitType : 1 ;
                        			                 Major : 1 ; Minor : 0 ; Release : 0 ; Build : 0 );
{$ENDIF}

implementation

{$IFDEF FPC}
uses LCLType, FileUtil ;
{$ELSE}
uses JclStrings ;
{$ENDIF}


function fs_GetNameSoft : String;
var li_Pos : Integer;
Begin
  Result := ExtractFileName(Application.ExeName);
  li_Pos := Pos ( '.', Result );
  if ( li_Pos > 0 ) then
    Begin
      while PosEx ( '.', Result, li_Pos + 1 )> 0 do
        li_Pos := PosEx ( '.', Result, li_Pos + 1 );
      Result := Copy ( Result, 1, PosEx ( '.', Result, li_Pos )-1 );
    End;
  li_Pos := Pos ( DirectorySeparator, Result );
End;

{$IFDEF VERSIONS}
initialization
  p_ConcatVersion ( gVer_fonction_string );
{$ENDIF}
end.


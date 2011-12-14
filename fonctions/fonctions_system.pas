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
  Windows,
{$ENDIF}
  Forms, SysUtils,
{$IFDEF VERSIONS}
  fonctions_version,
{$ENDIF}
  StrUtils, Classes ;

{$IFDEF DELPHI}
const
  DirectorySeparator = '\' ;
{$ENDIF}


function fs_ExtractFileNameOnly ( const as_Path : String ): String;
function fs_GetNameSoft : String;
function GetAppConfigDirectory ( const Global : Boolean = False ): string;
{$IFNDEF FPC}
  function GetWinDir ( const CSIDL : Integer ) : String ;
{$ENDIF}
const
  {$IFDEF LINUX}
  SYSDIR_CONFIGDIR_NAME = '.config';
  {$ENDIF}
  {$IFDEF VERSIONS}
  gVer_fonction_system : T_Version = ( Component : 'Gestion des chaînes' ; FileUnit : 'fonctions_string' ;
                        			                 Owner : 'Matthieu Giroux' ;
                        			                 Comment : 'Fonctions de traduction et de formatage des chaînes.' ;
                        			                 BugsStory : 'Version 1.0.0.0 : Creating from fonctions_string.';
                        			                 UnitType : 1 ;
                        			                 Major : 1 ; Minor : 0 ; Release : 0 ; Build : 0 );
{$ENDIF}

implementation


{$IFDEF FPC}
uses
  LCLType, FileUtil ;
{$ENDIF}

function fs_ExtractFileNameOnly ( const as_Path : String ): String;
Begin
  Result := ExtractFileName(as_path);
  Result :=copy ( Result, 1 , length ( Result ) - length( ExtractFileExt(Result)));
End;


function GetAppConfigDirectory ( const Global : Boolean = False ): string;
 begin
   {$IFDEF FPC}
   Result := GetAppConfigDir ( Global );
   {$ELSE}
   if Global
    Then Result := GetWinDir ( CSIDL_COMMON_APPDATA )
    Else Result := GetWinDir ( CSIDL_APPDATA );
   Result := Result + DirectorySeparator + fs_ExtractFileNameOnly ( Application.ExeName );
   {$ENDIF}
 end;

{$IFNDEF FPC}

function GetWinDir ( const CSIDL : Integer ) : string;
 var
    path: array[0..Max_Path] of Char;
 begin
    ShGetSpecialFolderPath(0, path, CSIDL, False) ;
    Result := Path;
 end;
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
End;

{$IFDEF VERSIONS}
initialization
  p_ConcatVersion ( gVer_fonction_system );
{$ENDIF}
end.


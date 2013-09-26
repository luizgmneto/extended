unit fonctions_net;

{$mode objfpc}{$H+}

interface

uses
  Classes,
  {$IFDEF VERSIONS}
   fonctions_version,
  {$ENDIF}
  SysUtils,
  IniFiles,
  fonctions_system;

type  TAVersionInfo =  array [ 0..3 ] of word;

var   gr_ExeVersion   : TAVersionInfo;
      gs_FileUpdate   : String='';
      gs_ExtensionIni : String='';
      gs_IniUpdate    : String='';

const INI_FILE_UPDATE = 'UPDATE';
      INI_FILE_UPDATE_WEIGHT = 'Weight';
      INI_FILE_UPDATE_EXE_VERSION  = 'VersionExe';
      INI_FILE_UPDATE_BASE_VERSION = 'VersionBase';
      INI_FILE_UPDATE_DATE         = 'Date';
      INI_FILE_UPDATE_MD5          = 'md5';
      INI_FILE_UPDATE_FILE_NAME    = 'FileName';
      INI_Version = 'Version';

{$IFDEF VERSIONS}
    gVer_fonctions_net : T_Version = ( Component : 'Functions TNetUpdate' ;
                                               FileUnit : 'fonctions_net' ;
                                               Owner : 'Matthieu Giroux' ;
                                               Comment : 'Net File Download.' ;
                                               BugsStory : '0.9.0.0 : Updating ok.' ;
                                               UnitType : 1 ;
                                               Major : 0 ; Minor : 9 ; Release : 0 ; Build : 1 );


{$ENDIF}

procedure InitUpdate ( const aat_ArchitectureType : TArchitectureType; const apt_PackageType : TPackageType ; const aProcType : TProcessorType );
function IniVersionExe ( const AIniFile : TIniFile ):TAVersionInfo;
function fi_BaseVersionToInt ( const as_versionBase : String ): Integer;
function fi64_VersionExeInt64( as_versionExe : String ):Int64;
function fi64_VersionExeInt64:Int64;
function fs_VersionExe:String;
function fs_verifyBaseForFile ( const as_base, as_path : String ):String; overload;
function fs_verifyBaseForFile ( const as_base, as_path : String ; const l_list : TStringlist ):String; overload;


implementation

uses fonctions_string,
     fonctions_init,
     fonctions_file,
     FileUtil;

procedure InitUpdate ( const aat_ArchitectureType : TArchitectureType; const apt_PackageType : TPackageType ; const aProcType : TProcessorType );
begin
  gs_ExtensionIni := CST_ProcessorTypeString [ aProcType ];
  case aat_ArchitectureType of
    at64 :  AppendStr ( gs_ExtensionIni, '64' );
  End;
  gs_IniUpdate := gs_FileUpdate+gs_ExtensionIni;
  gs_ExtensionIni := fs_FormatText( CST_PackageTypeString [ apt_PackageType ], mftFirstIsMaj ) + gs_ExtensionIni;
  AppendStr ( gs_IniUpdate, '.'+CST_PackageTypeString[apt_PackageType]);
  AppendStr ( gs_ExtensionIni, CST_EXTENSION_INI);
End;


function IniVersionExe ( const AIniFile : TIniFile ):TAVersionInfo;
Begin
 with AIniFile do
   Begin
     Result [ 0 ]:=ReadInteger(INI_Version,'Major',0);
     Result [ 1 ]:=ReadInteger(INI_Version,'Minor',0);
     Result [ 2 ]:=ReadInteger(INI_Version,'Revision',0);
     Result [ 3 ]:=ReadInteger(INI_Version,'Build',0);
     gr_ExeVersion:=Result;
   End;
end;

function fi_BaseVersionToInt ( const as_versionBase : String ): Integer;
Begin
 Result := StrToInt(copy(as_versionBase,1,pos('.',as_versionBase)-1))shl 16
            +StrToInt(copy(as_versionBase,pos('.',as_versionBase)+1,5));
end;
function fi64_VersionExeInt64:Int64;
begin
  // Matthieu Pas de version, c'est sur DELPHI
//    GetFileBuildInfo(NomFic,V1,V2,V3,V4);
  result:=(int64(gr_ExeVersion [ 0 ]) shl 48);
  result:=int64(gr_ExeVersion [ 3 ])or(int64(gr_ExeVersion [ 2 ]) shl 16)or(int64(gr_ExeVersion [ 1 ]) shl 32)or(int64(gr_ExeVersion [ 0 ]) shl 48);
end;

function fs_VersionExe:String;
begin
  // Matthieu Pas de version, c'est sur DELPHI
//    GetFileBuildInfo(NomFic,V1,V2,V3,V4);
  result:=IntToStr(gr_ExeVersion [ 0 ])+'.'+IntToStr(gr_ExeVersion [ 1 ])+'.'+IntToStr(gr_ExeVersion [ 2 ])+'.'+IntToStr(gr_ExeVersion [ 3 ]);
end;

function fi64_VersionExeInt64( as_versionExe : String ):Int64;
begin
  Result := int64(StrToInt(copy(as_versionExe,1,pos('.',as_versionExe)-1)))shl 48;
  as_versionExe := copy ( as_versionExe, pos('.',as_versionExe)+1, Length(as_versionExe));
  Result := Result or (int64(StrToInt(copy(as_versionExe,1,pos('.',as_versionExe)-1)))shl 32);
  as_versionExe := copy ( as_versionExe, pos('.',as_versionExe)+1, Length(as_versionExe));
  Result := Result or (int64(StrToInt(copy(as_versionExe,1,pos('.',as_versionExe)-1)))shl 16);
  Result := Result or (int64(StrToInt(copy(as_versionExe,pos('.',as_versionExe)+1, Length(as_versionExe)))));
end;

function fs_verifyBase ( const as_base, as_path : String ; const l_list : TStrings ):String;
var
    ls_dir : String;
    li_i, li_pos, li_j : Integer;
Begin
  li_j := 0;
  Result := as_path;
  if {$IFDEF WINDOWS}(pos(':',Result)=2) and {$ENDIF}
    FileExistsUTF8(Result) Then
     Exit;
  for li_i:=0 to l_list.Count - 1 do
   Begin
     ls_dir := l_list [ li_i ];
     inc ( li_j, Length(ls_dir) + 1 );
     if (ls_dir = '') or ( pos ( ':', ls_dir ) > 0 ) Then Continue;

     li_pos := pos ( ls_dir, as_path );
     if ( li_pos > 0 )
     and ( as_path [ li_pos -1 ] = DirectorySeparator )
     and ( as_path [ li_pos + Length(ls_dir) ] = DirectorySeparator ) Then
      Begin
        ls_dir:= copy ( as_base, 1, li_j - Length(ls_dir) - 1 ) + copy ( as_path, li_pos, Length(as_path) - li_pos + 1 );
        if FileExistsUTF8( ls_dir ) Then
          Begin
            Result := ls_dir;
            Exit;
          end;
      End;
   end;

end;



function fs_verifyBaseForFile ( const as_base, as_path : String ):String;
var l_list : TStringlist;

Begin
 l_list:=nil;
 p_ChampsVersListe(l_list,
                   as_base,
                   DirectorySeparator);

 Result:= fs_verifyBaseForFile (  as_base, as_path, l_list );

end;

function fs_verifyBaseForFile ( const as_base, as_path : String ; const l_list : TStringlist ):String;
Begin
  {$IFDEF WINDOWS}
  Result:= fs_verifyAndReplaceDriveLetter ( as_path );
  Result:= fs_verifyBase ( as_base, as_path, l_list );
  while not FileExistsUTF8(Result) and ( Result [ 1 ] <> 'C' ) do
   Begin
     Result:= fs_verifyAndReplaceDriveLetter ( chr ( ord ( Result [ 1 ] ) - 1 )
                                   + copy ( Result, 2, Length(Result) -1));
     Result:= fs_verifyBase ( as_base, Result, l_list );
   end;
  {$ELSE}
  Result:= fs_verifyBase ( as_base, as_path, l_list );
  {$ENDIF}
end;


{$IFDEF VERSIONS}
initialization
  p_ConcatVersion ( gVer_fonctions_net  );
{$ENDIF}
end.


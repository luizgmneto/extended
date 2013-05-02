﻿// unité contenant des fonctions de traitements de chaine
unit fonctions_system;

interface

{$I ..\DLCompilers.inc}
{$I ..\extends.inc}

{$IFDEF FPC}
{$mode Delphi}
{$ENDIF}

uses
{$IFDEF FPC}
  LCLIntf,
{$IFDEF UNIX}
  Unix,
{$ENDIF}
{$ELSE}
  Windows,
{$ENDIF}
  Forms, SysUtils,
{$IFDEF VERSIONS}
  fonctions_version,
{$ENDIF}
  StrUtils, Classes ;

type TPackageType = ( ptExe, ptTar, ptRpm, ptDeb, ptPkg, ptDmg );
     TProcessorType = ( ptIntel, ptMIPS, ptAlpha, ptPPC, ptSHX, ptARM, ptIA64, ptAlpha64, ptUnknown );

const
{$IFDEF VERSIONS}
  gVer_fonction_system : T_Version = ( Component : 'System management' ; FileUnit : 'fonctions_system' ;
                        			                 Owner : 'Matthieu Giroux' ;
                        			                 Comment : 'System Functions, with traducing and path management.' ;
                        			                 BugsStory : 'Version 1.1.0.0 : Linux and architecture functions.' + #10
                                                                           + 'Version 1.0.2.0 : fs_DocDir and library''s extension.' + #10
                                                                           + 'Version 1.0.1.0 : fs_GetCorrectPath function.' + #10
                                                                           + 'Version 1.0.0.0 : Creating from fonctions_string.';
                        			                 UnitType : 1 ;
                        			                 Major : 1 ; Minor : 1 ; Release : 0 ; Build : 0 );
{$ENDIF}
{$IFDEF DELPHI}
  DirectorySeparator = '\' ;

{$ENDIF}
  CST_EXTENSION_LIBRARY = {$IFDEF WINDOWS}'.dll'{$ELSE}{$IFDEF DARWIN}'.dylib'{$ELSE}'.so'{$ENDIF}{$ENDIF};
  CST_PackageTypeString : Array [ TPackageType ] of String = ( 'exe', 'tar.gz', 'rpm', 'deb', 'pkg', 'dmg' );
  CST_ProcessorTypeString : Array [ TProcessorType ] of String = ( 'Intel', 'MIPS', 'Alpha', 'PPC', 'SHX', 'ARM', 'IA64', 'Alpha64', '?' );

var
  GS_SUBDIR_IMAGES_SOFT : String = DirectorySeparator + 'Images'+DirectorySeparator;
  gpt_PackageType  : TPackageType;
{$IFDEF UNIX}
const
     CST_USER_BIN = '/usr/bin/';
     CST_VAR_LIB = '/var/lib/';
{$ENDIF}
type TArchitectureType = ( at32, at64 );
var  gat_ArchitectureType : TArchitectureType = {$IFDEF CPU64}at64{$ELSE}at32{$ENDIF};

function fs_ExtractFileNameOnly ( const as_Path : String ): String;
procedure p_OpenFileOrDirectory ( const AFilePath : String );
function fs_GetNameSoft : String;
// Retourne le nom d'utilisateur (string) de la session WINDOWS
function fs_GetUserSession: string;
function fs_GetCorrectPath ( const as_Path :String ): string;

// Retourne le nom d'ordinateur (string)
function fs_GetComputerName: string;
function GetDocDir: string;
function fs_getSoftImages:String;
function fs_GetPackagesExtension : String;
function fpt_GetPackagesType : TPackageType;
{$IFDEF WINDOWS}
function GetWinDir ( const CSIDL : Integer ) : String ;
{$ELSE}
{$IFDEF UNIX}
{$ENDIF}
{$ENDIF}
function fs_GetArchitecture : String;
function fat_GetArchitectureType : TArchitectureType;
function fs_ExecuteProcess ( const AExecutable, AParameter : String ; const HasOutput : Boolean = True):String;
{$IFNDEF FPC}
function GetAppConfigDir ( const Global : Boolean ): string;
function GetUserDir: string;
function DirectoryExistsUTF8 ( const as_path : String ):Boolean;
function FileExistsUTF8 ( const as_path : String ):Boolean;
{$ENDIF}
function fs_EraseNameSoft ( const as_Nomapp, as_Path : String ) : String ;
function fs_getSoftDir : String;
function fs_WithoutFirstDirectory ( const as_Path : String ) :String;
function fi_TailleFichier(NomFichier:String):Int64;

implementation


uses
{$IFDEF FPC}
  LCLType, FileUtil, process,
{$ELSE}
  ShellAPI,
{$ENDIF}
{$IFDEF WINDOWS}
  ShFolder,  ShlObj,
{$ENDIF}
  fonctions_string;
{$IFDEF WINDOWS}
const WINDOWS_ARCHITECTURE = 'systeminfo';
      CATCH_OUTPUT  = ' 4>&1';
{$ELSE}
{$IFDEF UNIX}
const UNIX_UNAME = 'uname';
      UNIX_ARCHITECTURE = '-m';
      CATCH_OUTPUT  = ' > /dev/null';
      UNIX_PACKAGES     = 'lsb_release -si';
      UNIX_VERSION      = 'lsb_release -sr';
{$ENDIF}
{$ENDIF}

// application directory with Separator
function fs_getSoftDir : String;
Begin
  Result := ExtractFileDir( Application.ExeName ) + DirectorySeparator ;
End;

// Erase first Directory with Separator
function fs_WithoutFirstDirectory ( const as_Path : String ) :String;
Begin
 Result := copy ( as_Path, pos ( DirectorySeparator, as_Path ) + 1, length ( as_Path ) - pos ( DirectorySeparator, as_Path ));
end;

// Universal Images directory  with Separator, for Leonardi
function fs_getSoftImages:String;
Begin
  Result := ExtractFileDir(Application.ExeName)+GS_SUBDIR_IMAGES_SOFT;
End;

// Can change part of Directory to get universal file system
function fs_GetCorrectPath ( const as_Path :String ): string;
Begin
  {$IFNDEF FPC}
  Result := fs_RemplaceChar(as_Path,'/',DirectorySeparator);
  {$ELSE}
  {$IFDEF WINDOWS}
  Result := fs_RemplaceChar(as_Path,'/',DirectorySeparator);
  {$ELSE}
  Result := fs_RemplaceChar(as_Path,'\',DirectorySeparator);
  {$ENDIF}
  {$ENDIF}

end;

// document directory  with Separator
// Problem for Unix
function GetDocDir: string;
Begin
  {$IFDEF WINDOWS}
  Result := GetWindir ( CSIDL_PERSONAL );
  {$ELSE}
  Result := GetUserDir + 'Documents';
  {$ENDIF}

end;

// Supprime le nom du fichier exe dans le chemin
function fs_EraseNameSoft ( const as_Nomapp, as_Path : String ) : String ;
Begin
  if pos ( as_Nomapp, as_Path )> 0 then
    Begin
      Result := copy ( as_Path, pos ( as_nomapp, as_Path ) + length ( as_NomApp ) + 1, length ( as_Path ) - length (as_Nomapp)- pos (as_NomApp, as_Path ));
    End
   else
    Result := as_Path ;

End;



////////////////////////////////////////////////////////////////////////////////
// Lit le nom de la session
// universal ini session
////////////////////////////////////////////////////////////////////////////////
function fs_GetUserSession: string;
{$IFDEF FPC}
Begin
 Result := 'config';
{$ELSE}
var
  Buffer: array[0..255] of char;    // tableau de 255 caracteres
  BufferSize: DWORD;                // nombre 16 bits non signé  VL_B_Resultat : Boolean;
begin
  BufferSize := sizeOf(Buffer); // (= 256)
  if GetUserName(@buffer, BufferSize) then ; // (lpBuffer: PChar; var nSize: DWORD)
  result := Buffer; // MEP utilisateur
{$ENDIF}
end;

////////////////////////////////////////////////////////////////////////////////
// Lit le nom de la machine
// not working on fpc (don't worry)
////////////////////////////////////////////////////////////////////////////////
function fs_GetComputerName : string;
{$IFDEF FPC}
Begin
 //    Result := GetComputerName;
 Result := '';
{$ELSE}
var
  Buffer: array[0..255] of char;    // tableau de 255 caracteres
  BufferSize: DWORD;                // nombre 16 bits non signé  VL_B_Resultat : Boolean;
begin
  BufferSize := sizeOf(Buffer); // (= 256)
  if GetComputerName(@buffer, BufferSize) then ; // (lpBuffer: PChar; var nSize: DWORD)
  result := Buffer; // MEP utilisateur
{$ENDIF}
end;

// filename with no extension ( forced )
function fs_ExtractFileNameOnly ( const as_Path : String ): String;
Begin
  Result := ExtractFileName(as_path);
  Result :=copy ( Result, 1 , length ( Result ) - length( ExtractFileExt(Result)));
End;

{$IFDEF WINDOWS}
// DELPHI and WINDOWS function
// used in this unit
function GetWinDir ( const CSIDL : Integer ) : string;
var
  path: array[0..Max_Path] of Char;
begin
  ShGetSpecialFolderPath(0, path, CSIDL, False) ;
  Result := Path;
end;
{$ELSE}
{$IFDEF UNIX}
{$ENDIF}
{$ENDIF}
// Packaging functions for Unix systems
function fs_GetPackagesExtension : String;
Begin
  Result:='.'+CST_PackageTypeString[gpt_PackageType];
End;
function fpt_GetPackagesType : TPackageType;
Begin
  {$IFDEF WINDOWS}
  Result:=ptExe;
  {$ELSE}
  {$IFDEF MACOSX}
  Result:=ptDmg;
  {$ELSE}
  Result:=ptTar;
       if FileExists     (CST_VAR_LIB + 'dpkg/status'  ) Then Result:=ptDeb
  else if FileExists     (CST_VAR_LIB + 'rpm/Packages' ) Then Result:=ptRpm
  else if DirectoryExists(CST_VAR_LIB + 'pkgconfig'    ) Then Result:=ptPkg
  {$ENDIF}
  {$ENDIF}
End;

{$IFNDEF FPC}
// delphi ini config session directory
function GetAppConfigDir ( const Global : Boolean ): string;
 begin
   if Global
    Then Result := GetWinDir ( CSIDL_COMMON_APPDATA )
    Else Result := GetWinDir ( CSIDL_APPDATA );
   Result := Result + DirectorySeparator + fs_ExtractFileNameOnly ( Application.ExeName );
 end;

// delphi user directory
function GetUserDir: string;
 begin
   Result := GetWinDir ( CSIDL_PERSONAL ) + DirectorySeparator;
 end;

// no DirectoryExistsUTF8 on delphi
function DirectoryExistsUTF8 ( const as_path : String ):Boolean;
Begin
  Result:= DirectoryExists ( as_path );
End;

// no FileExistsUTF8 on delphi
function FileExistsUTF8 ( const as_path : String ):Boolean;
Begin
  Result:= FileExists ( as_path );
End;
{$ENDIF}

// universal name of exe with no extension ( for leonardi )
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

// file size
function fi_TailleFichier(NomFichier:String):Int64;
var
  F:TSearchRec;
  R:Integer;
begin
  R:=FindFirst(NomFichier,faAnyFile,F);
  if R=0 then
    Result:=F.Size
  else
    Result:=0;
  FindClose(F);
end;

// dos or unix process executing
function fs_ExecuteProcess ( const AExecutable, AParameter : String ; const HasOutput : Boolean = True):String;
{$IFNDEF FPC}
const
     ReadBuffer = 2400;
{$ENDIF}
var {$IFDEF FPC}
    Process : TProcess;
    {$ELSE}
    Security : TSecurityAttributes;
    ReadPipe,WritePipe : THandle;
    start : TStartUpInfo;
    ProcessInfo : TProcessInformation;
    Buffer : Pchar;
    DosApp : String;
    BytesRead : DWord;
    Apprunning : DWord;
    {$ENDIF}
    lList: TStringList;
begin

{$IFDEF FPC}
  Process := TProcess.Create(nil);
  if HasOutput Then
    lList := TStringList.create;
  Result := '';
  with Process do
    try
      if HasOutput Then
        Options := Options+[poUsePipes, poStderrToOutPut, poNoConsole];
      Executable := AExecutable;
      if AParameter > '' Then
        Parameters.Add(AParameter);
      Execute;
      if HasOutput Then
       Begin
        lList.LoadFromStream(Output);
        Result := lList.Text;
       end;
    finally
      Destroy;
      if HasOutput Then
        lList.Free;
    end;
{$ELSE}
  DosApp:=AExecutable + ' ' + AParameter;
  With Security do begin
    nlength := SizeOf(TSecurityAttributes) ;
    binherithandle := true;
    lpsecuritydescriptor := nil;
   end;
   if Createpipe (ReadPipe, WritePipe,
                  @Security, 0) then begin
    Buffer := AllocMem(ReadBuffer + 1) ;
    FillChar(Start,Sizeof(Start),#0) ;
    start.cb := SizeOf(start) ;
    start.hStdOutput := WritePipe;
    start.hStdInput := ReadPipe;
    start.dwFlags := STARTF_USESTDHANDLES + STARTF_USESHOWWINDOW;
    start.wShowWindow := SW_HIDE;

    if CreateProcess(nil,
           PChar(DosApp),
           @Security,
           @Security,
           true,
           NORMAL_PRIORITY_CLASS,
           nil,
           nil,
           start,
           ProcessInfo)
    then
    begin
     repeat
      Apprunning := WaitForSingleObject
                   (ProcessInfo.hProcess,100) ;
      Application.ProcessMessages;
     until (Apprunning <> WAIT_TIMEOUT) ;
      Repeat
        BytesRead := 0;
        ReadFile(ReadPipe,Buffer[0], ReadBuffer,BytesRead,nil) ;
        Buffer[BytesRead]:= #0;
        OemToAnsi(Buffer,Buffer) ;
        Result := String(Buffer) ;
      until (BytesRead < ReadBuffer) ;
   end;
   FreeMem(Buffer) ;
   CloseHandle(ProcessInfo.hProcess) ;
   CloseHandle(ProcessInfo.hThread) ;
   CloseHandle(ReadPipe) ;
   CloseHandle(WritePipe) ;
   end;
{$ENDIF}
End;

// architecture info
function fs_GetArchitecture : String;
Begin
  Result := fs_ExecuteProcess ( {$IFDEF WINDOWS}WINDOWS_ARCHITECTURE, ''{$ELSE}UNIX_UNAME, UNIX_ARCHITECTURE {$ENDIF});
End;

// 32 or 64 bits architecture
function fat_GetArchitectureType : TArchitectureType;
var AString : String;
Begin
  AString:=fs_GetArchitecture;
  if pos ( '64', AString ) > 0
   Then Result := at64
   ELse Result := at32;
End;

// Universal file or directory open
procedure p_OpenFileOrDirectory ( const AFilePath : String );

Begin
  fs_ExecuteProcess (
      {$IFDEF LINUX}
      'xdg-open'
      {$ELSE}
      'open'
      {$ENDIF},
      AFilePath,
      False);
End;

initialization
  {$IFDEF VERSIONS}
  // adding optional version infos
  p_ConcatVersion ( gVer_fonction_system );
  {$ENDIF}
  {$IFDEF UNIX}
  {$ENDIF}
  // initing packaging variables
  gpt_PackageType := fpt_GetPackagesType;
  // initing cpu architecture variable
  if gat_ArchitectureType <> at64 Then
    gat_ArchitectureType := fat_GetArchitectureType;
end.


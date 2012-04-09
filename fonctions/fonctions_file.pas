unit fonctions_file;

interface

uses
  Classes,
{$IFDEF VERSIONS}
  fonctions_version,
{$ENDIF}
  SysUtils;

{$IFDEF FPC}
{$mode Delphi}{$H+}
{$ENDIF}

const
{$IFDEF VERSIONS}
  gVer_fonctions_file : T_Version = ( Component : 'Gestion des fichiers' ; FileUnit : 'fonctions_erreurs' ;
           Owner : '' ;
           Comment : 'Fonctions de gestion de fichiers' ;
           BugsStory :
              'Version 1.0.0.0 : La gestion est en place, ne gérant pas tout.';
           UnitType : 1 ;
                     Major : 1 ; Minor : 0 ; Release : 0 ; Build : 0 );
{$ENDIF}
  CST_COPYFILES_ERROR_IS_READONLY = faReadOnly ;
  CST_COPYFILES_ERROR_UNKNOWN = -1 ;
  CST_COPYFILES_ERROR_IS_DIRECTORY = faDirectory ;
  CST_COPYFILES_ERROR_IS_FILE = 1 ;
  CST_COPYFILES_ERROR_DIRECTORY_CREATE = 2 ;
  CST_COPYFILES_ERROR_CANT_COPY = 3 ;
  CST_COPYFILES_ERROR_CANT_READ = 4 ;
  CST_COPYFILES_ERROR_CANT_CREATE = 5 ;
  CST_COPYFILES_ERROR_CANT_APPEND = 6 ;
  CST_COPYFILES_ERROR_FILE_DELETE = 7 ;
  CST_COPYFILES_ERROR_PARTIAL_COPY = 8 ;
  CST_COPYFILES_ERROR_PARTIAL_COPY_SEEK = 9 ;
  CST_COPYFILES_ERROR_CANT_CHANGE_DATE = 10 ;

function fb_EraseFiles(  as_StartDir : String ):Boolean;
function fb_EraseDir(  as_StartDir : String ; const ab_EraseSubDirs : Boolean ):Boolean;
function  fb_FindFiles( const astl_FilesList: TStrings; as_StartDir : String;
                        const ab_ListFiles : Boolean = True ; const ab_ListDirs : Boolean = True;
                        const ab_FullPath : Boolean = False;
                        const as_FileMask: String='*'; const as_DirMask: String='*'):Boolean;
Function fb_CopyFile ( const as_Source, as_Destination : String ; const ab_AppendFile : Boolean ; const ab_CreateBackup : Boolean = False ):Integer;
function fb_CreateDirectoryStructure ( const as_DirectoryToCreate : String ) : Boolean ;
procedure p_FileNameDivision ( const as_FileNameWithExtension : String ; var as_FileName, as_Extension : String );

implementation

uses StrUtils, Dialogs,
  {$IFNDEF FPC}
    fonctions_system,
  {$ENDIF}
    Forms ;

procedure p_SetStartDir ( var as_StartDir : String );
Begin
  if as_StartDir[length(as_StartDir)] <> DirectorySeparator
   then
    as_StartDir := as_StartDir + DirectorySeparator;

end;

// Recursive procedure to build a list of files
function  fb_FindFiles( const astl_FilesList: TStrings; as_StartDir : String;
                        const ab_ListFiles : Boolean = True ; const ab_ListDirs : Boolean = True;
                        const ab_FullPath : Boolean = False;
                        const as_FileMask: String='*'; const as_DirMask: String='*'):Boolean;
var
  SR: TSearchRec;
  IsFound: Boolean;
  ls_Path : String;
begin
  Result := False ;

  p_SetStartDir ( as_StartDir );

  if ab_FullPath
   Then ls_Path := as_StartDir
   Else ls_Path := '' ;

  { Build a list of the files in directory as_StartDir
     (not the directories!)                         }
  if ab_ListDirs Then
  try
    IsFound := FindFirst(as_StartDir + as_DirMask, faDirectory, SR) = 0 ;
    while IsFound do
     begin
      if (( SR.Name <> '.' ) and ( SR.Name <> '..' ))
      and DirectoryExists ( as_StartDir + SR.Name )
       then
        Begin
          astl_FilesList.Add(ls_Path + SR.Name);
        End ;
      IsFound := FindNext(SR) = 0;
      Result := True ;
    end;
    FindClose(SR);
  Except
    FindClose(SR);
  End ;
  if ab_ListFiles Then
  try
    IsFound := FindFirst(as_StartDir+as_FileMask, faAnyFile-faDirectory, SR) = 0;
    while IsFound do
     begin
        if FileExists ( ls_Path + SR.Name )
         Then
          astl_FilesList.Add(as_StartDir + SR.Name);
        IsFound := FindNext(SR) = 0;
        Result := True ;
      end;
    FindClose(SR);
  Except
    FindClose(SR);
  End ;

end;

function fb_EraseDir(  as_StartDir : String ; const ab_EraseSubDirs : Boolean ):Boolean;
var
  SR: TSearchRec;
  IsFound: Boolean;
begin
  p_SetStartDir ( as_StartDir );
  Result := fb_EraseFiles ( as_StartDir );

  { Build a list of the files in directory as_StartDir
     (not the directories!)                         }
  if ab_EraseSubDirs Then
  try
    IsFound := FindFirst(as_StartDir + '*', faDirectory, SR) = 0 ;
    while IsFound do
     begin
      if (( SR.Name <> '.' ) and ( SR.Name <> '..' ))
      and DirectoryExists ( as_StartDir + SR.Name )
       then
        Begin
          fb_EraseDir(as_StartDir + SR.Name, ab_EraseSubDirs);
          RemoveDir(as_StartDir + SR.Name);
        End ;
      IsFound := FindNext(SR) = 0;
      Result := True ;
    end;
    FindClose(SR);
  Except
    FindClose(SR);
  End ;

end;

// Recursive procedure to build a list of files
function fb_EraseFiles(  as_StartDir : String ):Boolean;
var
  SR: TSearchRec;
  IsFound: Boolean;
begin
  Result := False ;

  { Build a list of the files in directory as_StartDir
     (not the directories!)                         }
  try
    IsFound := FindFirst(as_StartDir + '*', faAnyFile-faDirectory, SR) = 0 ;
    while IsFound do
     begin
      if (( SR.Name <> '.' ) and ( SR.Name <> '..' ))
      and FileExists ( as_StartDir + SR.Name )
       then
        Begin
          DeleteFile(as_StartDir + SR.Name);
        End ;
      IsFound := FindNext(SR) = 0;
      Result := True ;
    end;
    FindClose(SR);
  Except
    FindClose(SR);
  End ;
end;


Function fb_CopyFile ( const as_Source, as_Destination : String ; const ab_AppendFile : Boolean ; const ab_CreateBackup : Boolean = False ):Integer;
var
  li_SizeRead,li_SizeWrite,li_TotalW  : Longint;
  li_HandleSource,li_HandleDest, li_pos : integer;
  ls_FileName, ls_FileExt,ls_Destination : String ;
  lb_FoundFile,lb_Error : Boolean;
  lsr_data : Tsearchrec;
  FBuffer  : array[0..262143] of char;
begin
  Result := CST_COPYFILES_ERROR_UNKNOWN ;
  FindFirst(as_Source,faanyfile,lsr_data);
  li_TotalW := 0;
  findclose(lsr_data);
  li_HandleSource := fileopen(as_Source,fmopenread);
  ls_Destination := as_Destination ;
  if  ab_AppendFile
  and fileexists(as_Destination)
   then
    Begin
      FindFirst(as_Destination,faanyfile,lsr_data);
      li_HandleDest := FileOpen(as_Destination, fmopenwrite );
      FileSeek ( li_HandleDest, lsr_data.Size, 0 );
      findclose(lsr_data);
    End
   Else
     Begin
      If fileexists(ls_Destination)
       then
        Begin
          FindFirst(as_Destination,faanyfile,lsr_data);
          if ( ab_CreateBackup )
           Then
            Begin
              ls_FileName := lsr_data.Name;
              ls_FileExt  := '' ;
              li_pos := 1;
              while ( PosEx ( '.', ls_FileName, li_pos + 1 ) > 0 ) Do
                li_pos := PosEx ( '.', ls_FileName, li_pos + 1 );
              if ( li_Pos > 1 ) Then
                Begin
                  ls_FileExt  := Copy ( ls_FileName, li_pos, length ( ls_FileName ) - li_pos + 1 );
                  ls_FileName := Copy ( ls_FileName, 1, li_pos - 1 );
                End ;
              li_pos := 0 ;
              while FileExists ( ls_Destination ) do
               Begin
                 inc ( li_pos );
                 ls_Destination := ExtractFilePath ( as_Destination ) + DirectorySeparator + ls_FileName + '-' + IntToStr ( li_pos ) + ls_FileExt ;
               End
            End
           Else
            Deletefile(as_Destination);
          findclose(lsr_data);
        End ;
      li_HandleDest := filecreate(ls_Destination);
     end ;
  lb_FoundFile := False;
  lb_Error := false;
  while not lb_FoundFile do
    begin
      li_SizeRead := FileRead(li_HandleSource,FBuffer,high ( Fbuffer ) + 1);
      if li_SizeRead < high ( Fbuffer ) + 1 then lb_FoundFile := True;
      li_SizeWrite := Filewrite(li_HandleDest,Fbuffer,li_SizeRead);
      inc( li_TotalW, li_SizeWrite );
      if li_SizeWrite < li_SizeRead then lb_Error := True;
    end;
  filesetdate(li_HandleDest,filegetdate(li_HandleSource));
  fileclose(li_HandleSource);
  fileclose(li_HandleDest);
  if lb_Error = False then
    Begin
      Result := 0 ;
    End ;
  Application.ProcessMessages ;
end;

function fb_CreateDirectoryStructure ( const as_DirectoryToCreate : String ) : Boolean ;
var
  lsr_data : Tsearchrec;
  li_Pos : Integer ;
  ls_Temp : String ;
begin
  Result := False ;
  if DirectoryExists ( as_DirectoryToCreate )
   Then
    Begin
      Result := True;
    End
  Else
    try
       li_Pos := 1 ;
       while ( Posex ( DirectorySeparator, as_DirectoryToCreate, li_pos + 1 ) > 1 ) do
         li_Pos := Posex ( DirectorySeparator, as_DirectoryToCreate, li_pos + 1 );
       if ( li_pos > 1 ) Then
         ls_Temp := Copy ( as_DirectoryToCreate, 1 , li_pos - 1 )
       Else
         Exit ;
       if  not DirectoryExists ( ls_Temp ) Then
         Begin
           fb_CreateDirectoryStructure ( ls_Temp );
         End ;
       if DirectoryExists ( ls_Temp ) then
         Begin
           FindFirst ( ls_Temp,faanyfile,lsr_data);
           if ( DirectoryExists ( ls_Temp )) Then
             try
               CreateDir ( as_DirectoryToCreate );
               Result := True ;
             except
             End
            Else
             Result := False ;
           FindClose ( lsr_data );
         end;
     Finally
     End ;
End ;



procedure p_FileNameDivision ( const as_FileNameWithExtension : String ; var as_FileName, as_Extension : String );
var li_pos : Integer;
Begin
  as_FileName := as_FileNameWithExtension;
  as_Extension  := '' ;
  li_pos := 1;
  while ( PosEx ( '.', as_FileName, li_pos + 1 ) > 0 ) Do
    li_pos := PosEx ( '.', as_FileName, li_pos + 1 );
  if ( li_Pos > 1 ) Then
    Begin
      as_Extension := Copy ( as_FileName, li_pos, length ( as_FileName ) - li_pos + 1 );
      as_FileName  := Copy ( as_FileName, 1, li_pos - 1 );
    End ;
End ;

initialization
{$IFDEF VERSIONS}
  p_ConcatVersion ( gVer_fonctions_file );
{$ENDIF}

end.


unit fonctions_file;

interface

uses
  {$IFDEF WINDOWS}
   windows,
  {$ELSE}
  {$IFNDEF FPC}
   windows,
  {$ENDIF}
  {$ENDIF}
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
           'Version 1.0.3.0 : Adding ExtractDirName and ExtractSubDir.';
           'Version 1.0.2.0 : UTF8 not tested.';
           'Version 1.0.1.0 : adding Windows drive verifying function.';
           'Version 1.0.0.0 : La gestion est en place, ne gérant pas tout.';
           UnitType : 1 ;
                     Major : 1 ; Minor : 0 ; Release : 3 ; Build : 0 );
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
function DirSize( const as_Dir : String ):Int64;
function fb_EraseDir(  as_StartDir : String ; const ab_EraseSubDirs : Boolean ):Boolean;
function  fb_FindFiles( const astl_FilesList: TStrings; as_StartDir : String;
                        const ab_ListFiles : Boolean = True ; const ab_ListDirs : Boolean = True;
                        const ab_FullPath : Boolean = False;
                        const as_FileMask: String='*'; const as_DirMask: String='*'):Boolean;
Function fb_CopyFile ( const as_Source, as_Destination : String ; const ab_AppendFile : Boolean ; const ab_CreateBackup : Boolean = False ):Integer;
function fb_CreateDirectoryStructure ( const as_DirectoryToCreate : String ) : Boolean ;
procedure p_FileNameDivision ( const as_FileNameWithExtension : String ; var as_FileName, as_Extension : String );
function fs_createUniqueFileName ( const as_base, as_FileAltName : String ; const as_extension : String ):String;
function ExtractSubDir ( const as_FilePath : String ) :String;
function ExtractDirName ( const as_FilePath : String ) :String;
procedure p_LoadStrings ( const astl_StringList : TStrings; const as_FilePath,  as_message : String );
procedure p_SaveStrings ( const astl_StringList : TStrings; const as_FilePath,  as_message : String );
{$IFDEF FPC}
function ExtractFileDir ( const as_FilePath : String ) :String;
{$ENDIF}
{$IFDEF WINDOWS}
function fs_verifyAndReplaceDriveLetter ( const as_path : String ):String;
{$ENDIF}

implementation

uses StrUtils, Dialogs,
  {$IFDEF FPC}
    lazutf8classes,FileUtil,
  {$ELSE}
    fonctions_system,
  {$ENDIF}
    fonctions_string,
    Forms ;

procedure DirSizeRecurse(  as_Dir : String; var ai64_size : Int64);
var lstl_Files : TStringList;
    ls_file : string;
    FileHandle: THandle;
Begin
  as_Dir := IncludeTrailingPathDelimiter(as_Dir);
  lstl_Files:=TStringList.Create;
  try
    fb_FindFiles(lstl_Files,as_Dir,True,True);
    with lstl_Files do
    while Count>0 do
     Begin
       ls_file:=Strings[0];
       if DirectoryExistsUTF8(as_Dir+ls_file)
        Then DirSizeRecurse(as_Dir+ls_file, ai64_size)
        Else try
              FileHandle := CreateFile(PChar(as_Dir+ls_file),
                  GENERIC_READ,
                  0, {exclusive}
                  nil, {security}
                  OPEN_EXISTING,
                  FILE_ATTRIBUTE_NORMAL,
                  0);
               inc ( ai64_size, GetFileSize(FileHandle, nil));
             finally
               CloseHandle(FileHandle);
             End;
       Delete(0);
     end;
  finally
    lstl_Files.Destroy;
  end;
end;

function DirSize( const as_Dir : String ):Int64;
Begin
  Result:=0;
  DirSizeRecurse(as_Dir,Result);
end;

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
    IsFound := FindFirstUTF8(as_StartDir + as_DirMask, faDirectory, SR) = 0 ;
    while IsFound do
     begin
      if (( SR.Name <> '.' ) and ( SR.Name <> '..' ))
      and DirectoryExistsUTF8 ( as_StartDir + SR.Name )
       then
        Begin
          astl_FilesList.Add(ls_Path + SR.Name);
        End ;
      IsFound := FindNextUTF8(SR) = 0;
      Result := True ;
    end;
    FindCloseUTF8(SR);
  Except
    FindCloseUTF8(SR);
  End ;
  if ab_ListFiles Then
  try
    IsFound := FindFirstUTF8(as_StartDir+as_FileMask, faAnyFile-faDirectory, SR) = 0;
    while IsFound do
     begin
        if FileExistsUTF8 ( as_StartDir + SR.Name )
         Then
          astl_FilesList.Add(ls_Path + SR.Name);
        IsFound := FindNextUTF8(SR) = 0;
        Result := True ;
      end;
    FindCloseUTF8(SR);
  Except
    FindCloseUTF8(SR);
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
    IsFound := FindFirstUTF8(as_StartDir + '*', faDirectory, SR) = 0 ;
    while IsFound do
     begin
      if (( SR.Name <> '.' ) and ( SR.Name <> '..' ))
      and DirectoryExistsUTF8 ( as_StartDir + SR.Name )
       then
        Begin
          fb_EraseDir(as_StartDir + SR.Name, ab_EraseSubDirs);
          RemoveDirUTF8(as_StartDir + SR.Name);
        End ;
      IsFound := FindNextUTF8(SR) = 0;
      Result := True ;
    end;
    FindCloseUTF8(SR);
  Except
    FindCloseUTF8(SR);
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
    IsFound := FindFirstUTF8(as_StartDir + '*', faAnyFile-faDirectory, SR) = 0 ;
    while IsFound do
     begin
      if (( SR.Name <> '.' ) and ( SR.Name <> '..' ))
      and FileExistsUTF8 ( as_StartDir + SR.Name )
       then
        Begin
          DeleteFileUTF8(as_StartDir + SR.Name);
        End ;
      IsFound := FindNextUTF8(SR) = 0;
      Result := True ;
    end;
    FindCloseUTF8(SR);
  Except
    FindCloseUTF8(SR);
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
  and FileExistsUTF8(as_Destination)
   then
    Begin
      FindFirstUTF8(as_Destination,faanyfile,lsr_data);
      li_HandleDest := FileOpen(as_Destination, fmopenwrite );
      FileSeek ( li_HandleDest, lsr_data.Size, 0 );
      FindCloseUTF8(lsr_data);
    End
   Else
     Begin
      If FileExistsUTF8(ls_Destination)
       then
        Begin
          FindFirstUTF8(as_Destination,faanyfile,lsr_data);
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
              while FileExistsUTF8 ( ls_Destination ) do
               Begin
                 inc ( li_pos );
                 ls_Destination := ExtractFilePath ( as_Destination ) + DirectorySeparator + ls_FileName + '-' + IntToStr ( li_pos ) + ls_FileExt ;
               End
            End
           Else
            DeleteFileUTF8(as_Destination);
          FindCloseUTF8(lsr_data);
        End ;
      li_HandleDest := FileCreateUTF8(ls_Destination);
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
  FileSetDate(li_HandleDest,filegetdate(li_HandleSource));
  FileClose(li_HandleSource);
  FileClose(li_HandleDest);
  if lb_Error = False then
    Begin
      Result := 0 ;
    End ;
  Application.ProcessMessages ;
end;

function fs_createUniqueFileName ( const as_base, as_FileAltName : String ; const as_extension : String ):String;
var li_i : Integer;
Begin
  li_i := 1;
  Result := fs_TextToFileName(as_FileAltName) + as_extension;
  while FileExistsUTF8(as_base+Result) { *Converted from FileExists*  } do
  Begin
    inc ( li_i );
    Result := fs_TextToFileName(as_FileAltName ) + '-'+ IntToStr(li_i) + as_extension;
  end;
end;

{$IFDEF WINDOWS}
function fs_verifyAndReplaceDriveLetter ( const as_path : String ):String;
var qwspace : {$IFDEF CPU64}Pint64{$ELSE}PLargeInteger{$ENDIF};
Begin
  Result:=UpperCase (as_path [1]) + copy ( as_path, 2, Length(as_path)-1);
  if ( Result [ 1 ] in [ '/', '\' ] )  Then
   Exit; // if path is unix path or translated
  while (Windows.GetDriveType(@Result[1]) <> 1) and
    GetDiskFreeSpaceEx(@Result[1], nil, qwspace, nil )
    and ( qwspace^ <= 0 ) do;
   Begin
     if (Result[1]='C') Then Exit;
     Result[1] := chr ( ord ( Result[1] ) - 1 );
   end;
end;
{$ENDIF}

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
       if  not DirectoryExistsUTF8 ( ls_Temp ) Then
         Begin
           fb_CreateDirectoryStructure ( ls_Temp );
         End ;
       if DirectoryExistsUTF8 ( ls_Temp ) then
         Begin
           FindFirstUTF8 ( ls_Temp,faanyfile,lsr_data);
           if ( DirectoryExistsUTF8 ( ls_Temp )) Then
             try
               CreateDirUTF8 ( as_DirectoryToCreate );
               Result := True ;
             except
             End
            Else
             Result := False ;
           FindCloseUTF8 ( lsr_data );
         end;
     Finally
     End ;
End ;

procedure p_LoadStrings ( const astl_StringList : TStrings; const as_FilePath,  as_message : String );
var TheStream:{$IFDEF FPC}TFileStreamUTF8{$ELSE}TFileStream{$ENDIF};
Begin
  astl_StringList.Clear;
  TheStream:={$IFDEF FPC}TFileStreamUTF8{$ELSE}TFileStream{$ENDIF}.Create(as_FilePath,fmOpenRead);
  try
    try
      astl_StringList.LoadFromStream(TheStream);
    except
      On E: Exception do
      if as_message > '' then
        begin
          ShowMessage(as_message + CST_ENDOFLINE + E.Message);
          Abort;
        end;
    end;
  finally
    TheStream.Free;
  end;
end;

procedure p_SaveStrings ( const astl_StringList : TStrings; const as_FilePath,  as_message : String );
var TheStream:{$IFDEF FPC}TFileStreamUTF8{$ELSE}TFileStream{$ENDIF};
Begin
  if FileExistsUTF8(as_FilePath)
   Then TheStream:={$IFDEF FPC}TFileStreamUTF8{$ELSE}TFileStream{$ENDIF}.Create(as_FilePath,fmOpenReadWrite)
   Else TheStream:={$IFDEF FPC}TFileStreamUTF8{$ELSE}TFileStream{$ENDIF}.Create(as_FilePath,fmCreate);
  try
    try
      astl_StringList.SaveToStream(TheStream);
    except
      On E: Exception do
      if as_message > '' then
        begin
          ShowMessage(as_message + as_filePath + CST_ENDOFLINE + E.Message);
          Abort;
        end;
    end;
  finally
    TheStream.Free;
  end;
end;


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

{$IFDEF FPC}
function ExtractFileDir ( const as_FilePath : String ) :String;
var li_Pos : Integer;
Begin
  Result := as_FilePath;
  while not DirectoryExistsUTF8(Result) do
   Result:=ExtractSubDir(Result);
End;
{$ENDIF}

// function ExtractSubDir
// optimised SubDir Extracting
function ExtractSubDir ( const as_FilePath : String ) :String;
var lpch_Pos : PChar;
    lp_pointer : Pointer;
Begin
  Result := as_FilePath;
  if Result = '' Then
    Exit;
  lpch_Pos := @Result [ length ( Result )-1];
  lp_pointer := @Result [ 1 ];
  while ( lpch_Pos > lp_pointer ) do
    Begin
      if lpch_Pos^ = DirectorySeparator Then
        Break;
      dec ( lpch_Pos );
    End;
  Result:=copy(Result,1,lpch_Pos- lp_pointer);
End;

// function ExtractSubDir
// optimised SubDir Extracting
function ExtractDirName ( const as_FilePath : String ) :String;
var lpch_Pos : PChar;
    lp_pointer : Pointer;
Begin
  Result := as_FilePath;
  if Result = '' Then
    Exit;
  lpch_Pos := @Result [ length ( Result )-1];
  lp_pointer := @Result [ 1 ];
  while ( lpch_Pos > lp_pointer ) do
    Begin
      if lpch_Pos^ = DirectorySeparator Then
        Break;
      dec ( lpch_Pos );
    End;
  Result:=copy(Result,lpch_Pos- lp_pointer+2,@Result [ length ( Result )]-lpch_Pos-1);
End;

initialization
{$IFDEF VERSIONS}
  p_ConcatVersion ( gVer_fonctions_file );
{$ENDIF}

end.


unit U_ExtFileCopy;
{
Composant TExtFileCopy

Développé par:
Matthieu GIROUX
Licence GPL

Composant non visuel permettant de copier un fichier plus rapidement
que par la fonction copy de windows.
Compatible Linux
Attention: La gestion de la RAM étant calamiteuse sous Win9x, l'
utilisation de ce composant provoque une grosse une forte baisse de la
mémoire disponible. Sous WinNT/2000 il n' y a pas de problèmes


Version actuelle: 1.0

Mises à jour:
}

interface
{$IFDEF FPC}
{$mode Delphi}
{$ENDIF}

{$I ..\DLCompilers.inc}
{$I ..\extends.inc}

uses
  SysUtils,
{$IFDEF FPC}
  unit_messagescopy,
{$ELSE}
  fonctions_system,
  unit_messagescopy_delphi,
{$ENDIF}
  u_extabscopy,
{$IFDEF VERSIONS}
  fonctions_version,
{$ENDIF}
  Classes ;

{$IFDEF VERSIONS}
  const
    gVer_TExtFileCopy : T_Version = ( Component : 'Composant ExtFileCopy' ;
                                               FileUnit : 'U_ExtFileCopy' ;
                                               Owner : 'Matthieu Giroux' ;
                                               Comment : 'Composant de copie multi-platformes.' ;
                                               BugsStory : '1.0.0.1 : Testing on linux.' +#13#10
                                                         + '1.0.0.0 : Testing alone.' +#13#10
                                                         + '0.9.0.0 : En place testée.';
                                               UnitType : 3 ;
                                               Major : 1 ; Minor : 0 ; Release : 0 ; Build : 1 );

{$ENDIF}

type
    TEMultipleCopyOption = ( cpCopyAll, cpNoStructure );
    TECopyFileOptions = set of TESimpleCopyOption ;
    TECopyFilesOptions = set of TEMultipleCopyOption;
    IntCopy = {$IFDEF CPU64}Int64{$ELSE}Longint{$ENDIF};
const
  lsco_Default = [cpUseFilter];
  lmco_Default = [cpCopyAll];
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

type

    { TExtFileCopy }
    TExtFileCopy = class(TAbsFileCopy, IFileCopyComponent)
           private
             FTraduceCopy : IFileCopyComponent ;
             FOnChange : TEChangeDirectoryEvent ;
             FDoEraseDir : TEReturnEvent;
             FSizeTotal : IntCopy ;
             FSizeProgress : Integer ;
             FOnSuccess : TECopyFinishEvent;
             FBeforeCopy : TEReturnEvent ;
             FBeforeCopyBuffer ,
             FOnProgress       : TECopyEvent;
             FBufferSize : integer;
             FFileOptions : TECopyFileOptions ;
             FFilesOptions : TECopyFilesOptions ;
             FFilter, FSource,FDestination : String;
             FInProgress : Boolean;
             procedure SetBufferSize (Value : integer);
             procedure SetDestination(Value : String);
             procedure SetSource(Value: String);
           protected
             FBuffer : array[0..65535] of char;
             function CreateDestination ( const as_Destination : String ): Boolean; virtual;
             function PrepareFileSourceAndDestination ( const as_Source : String ; var as_Destination : String ; var li_HandleSource, li_HandleDestination : Thandle ; const ab_AppendFile, ab_CreateBackup : Boolean ): Integer; virtual;
             function fb_InternalCopyFile(const as_Source,
               as_Destination: String; const ab_DestinationIsFile,
               ab_CreateBackup: Boolean): Boolean;
             function fb_InternalCopyDirectory(const as_Source, as_Destination,
               as_Mask: String; const ab_CopyStructure, ab_DestinationIsFile,
               ab_CopyAll, ab_CreateBackup: Boolean): Boolean;
             function  BeforeCopyBuffer ( var li_SizeRead, li_BytesTotal : IntCopy ) : Boolean ; virtual ;
             function  BeforeCopy : Boolean ; virtual ;
             procedure AfterCopyBuffer  ; virtual ;
             { Déclarations protégées }
           public
             function InternalDefaultCopyFile  ( const as_Source, as_Destination : String ):Boolean; virtual ;
             procedure InternalFinish ( const as_Source, as_Destination : AnsiString ); virtual ;
             constructor Create(AOwner : Tcomponent);override;
             property InProgress : Boolean read FInprogress;
             Function CopyFile ( const as_Source, as_Destination : String ; const ab_AppendFile, ab_CreateBackup : Boolean ):Integer; virtual;
             Procedure CopySourceToDestination; virtual;
           published
             property TraduceCopy : IFileCopyComponent read FTraduceCopy write FTraduceCopy;
             property BufferSize : integer read FBufferSize write SetBufferSize default 65536;
             property Source : String read FSource write SetSource;
             property Mask : String read FFilter write FFilter;
             property Destination : String read FDestination write SetDestination;
             property FileOptions : TECopyFileOptions read FFileOptions write FFileOptions default lsco_Default ;
             property FilesOptions : TECopyFilesOptions read FFilesOptions write FFilesOptions default lmco_Default ;
             property OnSuccess : TECopyFinishEvent read FOnSuccess write FOnSuccess;
             property OnProgress : TECopyEvent read FOnProgress write Fonprogress;
             property OnBeforeCopyBuffer : TECopyEvent read FBeforeCopyBuffer write FBeforeCopyBuffer;
             property OnBeforeCopy : TEReturnEvent read FBeforeCopy write FBeforeCopy;
             property OnChange : TEChangeDirectoryEvent read FOnChange write FOnChange;
             property DoEraseDir : TEReturnEvent read FDoEraseDir write FDoEraseDir;
           end;

{TExtFilePartialCopy}

    TExtFilePartialCopy = class(TExtFileCopy)
           private
             lb_ExcludedFound  : Boolean ;
             FExcludeStart ,
             FExcludeEnd   : String ;
             FExcludeReading : Boolean;
             protected
             function  BeforeCopyBuffer ( var li_SizeRead, li_BytesTotal : IntCopy ) : Boolean ; override ;
             function  BeforeCopy : Boolean ; override ;
             procedure AfterCopyBuffer  ; override ;
             { Déclarations protégées }
           public
             constructor Create(AOwner : Tcomponent);override;
           published
             property ExcludeReading : Boolean read FExcludeReading write FExcludeReading default False ;
             property ExcludeStart : String read FExcludeStart write FExcludeStart ;
             property ExcludeEnd   : String read FExcludeEnd   write FExcludeEnd ;
           end;


implementation

uses fonctions_file, Forms, Dialogs, Controls ;

{TExtFileCopy}

constructor TExtFileCopy.Create(AOwner :Tcomponent);
begin
  inherited Create(AOwner);
  FileOptions := lsco_Default ;
  FilesOptions := lmco_Default ;
  FBufferSize := 65536;
  FInProgress := False;
end;

function TExtFileCopy.PrepareFileSourceAndDestination ( const as_Source : String ; var as_Destination : String ; var li_HandleSource, li_HandleDestination : THandle ; const ab_AppendFile, ab_CreateBackup : Boolean ): Integer;
var lsr_data : TSearchRec ;

begin
  Result := 0 ;
  try
    li_HandleSource := fileopen(as_Source,fmopenread);
  Except
    On E: Exception do
      Begin
        Result := CST_COPYFILES_ERROR_CANT_READ ;
        IsCopyOk ( Result, GS_COPYFILES_ERROR_CANT_READ + as_Destination );
        Exit ;
      End ;
  End ;
  if  ab_AppendFile
  and fileexists(as_Destination)
   then
    try
      FindFirst(as_Destination,faanyfile,lsr_data);
      li_HandleDestination := FileOpen(as_Destination, fmopenwrite );
      FileSeek ( li_HandleDestination, lsr_data.Size, 0 );
      findclose(lsr_data);
    Except
      Result := CST_COPYFILES_ERROR_CANT_APPEND ;
      IsCopyOk ( Result, GS_COPYFILES_ERROR_CANT_APPEND + as_Destination );
    End
   Else
     Begin
       if inherited PrepareFileSourceAndDestination ( as_Source, as_Destination, ab_AppendFile, ab_CreateBackup ) <> 0 Then
           Exit ;
      try
        li_HandleDestination := filecreate(as_Destination);
      Except
        Result := CST_COPYFILES_ERROR_CANT_CREATE ;
        IsCopyOk ( Result, GS_COPYFILES_ERROR_CANT_CREATE + as_Destination );
      End
     end ;
end;


procedure TExtFileCopy.SetBufferSize(Value : integer);
begin
  If not FInprogress
   then
    begin
      If Value > high ( FBuffer )
       then
        Value := high ( FBuffer ) + 1
       Else
        FBufferSize := Value;
    end;
end;

procedure TExtFileCopy.SetDestination(Value: String);
begin
  if FDestination <> Value Then
    Begin
      FDestination := Value;
    End;
end;

procedure TExtFileCopy.SetSource(Value: String);
begin
  if FSource <> Value Then
    Begin
      FSource := Value;
      if not ( csDesigning in ComponentState )
      and Assigned ( @FOnChange )
       Then
        FOnChange ( Self, FSource, FDestination );
    End;
end;

function TExtFileCopy.CreateDestination(const as_Destination: String): Boolean;
begin
  if assigned ( TraduceCopy ) then
    Result := TraduceCopy.CreateDestination(as_Destination)
   Else
    if DirectoryExists ( as_Destination )
    and ( cpEraseDestination in FFileOptions )
    and Assigned(FDoEraseDir)
     Then
      Begin
       Result := False;
       FDoEraseDir ( Self, Result );
       if Result Then
         Result := fb_EraseDir(as_Destination, True);
      end
     Else
      if cpDestinationIsFile in FFileOptions Then
        Begin
          if not DirectoryExists(ExtractFileDir(as_Destination))
            Then Result := fb_CreateDirectoryStructure ( ExtractFileDir(as_Destination) )
            else Result := True;
        end
       Else
        Result := fb_CreateDirectoryStructure ( as_Destination );
end;

function TExtFileCopy.BeforeCopyBuffer(var li_SizeRead, li_BytesTotal : IntCopy ): Boolean;
begin
  Result := True ;
  if Assigned ( FBeforeCopyBuffer ) Then
    FBeforeCopyBuffer ( Self, li_SizeRead, li_BytesTotal );

end;

function TExtFileCopy.BeforeCopy: Boolean;
begin
  Result := True ;
  if Assigned ( FBeforeCopy ) Then
    FBeforeCopy ( Self, Result );
end;

procedure TExtFileCopy.AfterCopyBuffer;
begin

end;

Function TExtFileCopy.CopyFile ( const as_Source, as_Destination : String ; const ab_AppendFile, ab_CreateBackup : Boolean ):Integer;
var
  li_SizeRead,li_SizeWrite,li_TotalW, li_RealTotal  : IntCopy;
  li_SizeTotal : IntCopy ;
  li_HandleSource,li_HandleDest : THandle;
  lb_FoundFile : Boolean;
  lsr_data : Tsearchrec;
  ls_Destination : String ;
begin
  Result := 0 ;
  Application.ProcessMessages;
  FindFirst(as_Source,faanyfile,lsr_data);
  li_HandleDest := 0;
  li_HandleSource:= 0 ;
  li_RealTotal := lsr_data.size ;
  li_SizeTotal := lsr_data.Size;
  inc ( FSizeTotal, li_SizeTotal );
  li_TotalW := 0;
  findclose(lsr_data);
  ls_Destination := as_Destination;
  Application.ProcessMessages;
  if PrepareFileSourceAndDestination ( as_Source, ls_Destination, li_HandleSource, li_HandleDest, ab_AppendFile, ab_CreateBackup ) <> 0 Then
    Exit ;
  if not BeforeCopy Then
    Exit ;
  lb_FoundFile := False;
  Application.ProcessMessages;
  while not lb_FoundFile do
    try
      Application.ProcessMessages;
      li_SizeRead := FileRead(li_HandleSource,FBuffer,FbufferSize);
      if ( li_SizeRead <= 0 )
      and ( li_TotalW < li_RealTotal )
       Then
        try
          FileSeek ( li_HandleSource, 64, li_TotalW );
          Inc ( li_TotalW, 64 );
          Continue ;
        Except
          Result := CST_COPYFILES_ERROR_PARTIAL_COPY_SEEK ;
          IsCopyOk ( Result, GS_COPYFILES_ERROR_PARTIAL_COPY_SEEK + ls_Destination );
        End ;
      Application.ProcessMessages;
      if BeforeCopyBuffer ( li_SizeRead, li_TotalW ) Then
        Begin
          li_SizeWrite := Filewrite(li_HandleDest,Fbuffer,li_SizeRead);
          Application.ProcessMessages;
          inc( li_TotalW, li_SizeWrite );
          if  ( li_SizeRead < FBufferSize )
          and ( li_TotalW >= li_RealTotal )
           then
            lb_FoundFile := True;
          if li_SizeWrite < li_SizeRead
           then
             Begin
              if li_SizeWrite <>-1
               Then
                Begin
                  Result := CST_COPYFILES_ERROR_PARTIAL_COPY ;
                  IsCopyOk ( Result, GS_COPYFILES_ERROR_PARTIAL_COPY + ls_Destination );
                end
               else
                Begin
                 Result := CST_COPYFILES_ERROR_CANT_APPEND ;
                 IsCopyOk ( Result, GS_COPYFILES_ERROR_IS_FILE + ls_Destination );
                 Abort;
                end;
             End ;
          if assigned(FonProgress) then FonProgress(self, FSizeProgress + li_TotalW,FSizeTotal);
        End ;
      Application.ProcessMessages;
      AfterCopyBuffer ;
    Except
      Result := CST_COPYFILES_ERROR_CANT_COPY ;
      IsCopyOk ( Result, GS_COPYFILES_ERROR_CANT_COPY + '( ' + as_Source + ' -> ' + ls_Destination + ' )' );
      Exit ;
    End ;
  Application.ProcessMessages;
  try
    filesetdate(li_HandleDest,filegetdate(li_HandleSource));
  Except
    Result := CST_COPYFILES_ERROR_CANT_CHANGE_DATE ;
    IsCopyOk ( Result, GS_COPYFILES_ERROR_CANT_CHANGE_DATE + ls_Destination );
    Exit ;
  End ;
  Application.ProcessMessages;
  fileclose(li_HandleSource);
  fileclose(li_HandleDest);
  if Result = 0 then
    Begin
      inc ( FSizeProgress, li_TotalW );
      InternalFinish ( as_Source, ls_Destination );
      Result := 0 ;
    End ;
  Application.ProcessMessages ;
end;

function TExtFileCopy.InternalDefaultCopyFile  ( const as_Source, as_Destination : String ):Boolean;
var li_Error ,
    li_i : Integer;
begin
  if assigned ( FTraduceCopy ) Then
    Begin
      Result := FTraduceCopy.InternalDefaultCopyFile ( as_Source, as_Destination );
      if ( Result ) then
        Exit ;
    End ;
  li_Error := 1 ;
  li_i := 1;
  while li_Error > 0 do
    Begin
      inc (li_i);
      li_Error := CopyFile ( as_Source, as_Destination, cpDestinationIsFile in FFileOptions, cpCreateBackup in FFileOptions );
      if li_i > 100 Then
        Abort;
    end;
  Result := li_Error = 0 ;
End ;


procedure TExtFileCopy.InternalFinish ( const as_Source, as_Destination : AnsiString );
begin
  if assigned ( FOnSuccess ) then
    Begin
        FOnSuccess ( Self, as_Source, as_Destination, Errors );
    End ;
End ;

procedure TExtFileCopy.CopySourceToDestination;
begin
  Finprogress := true;
  FSizeTotal := 0 ;
  Errors := 0 ;
  FSizeProgress := 0 ;
  if assigned ( TraduceCopy ) Then
    TraduceCopy.BeforeCopy;
  if (    not FileExists ( FSource )
       and not DirectoryExists ( FSource ))
   Then
    Exit ;
 if not CreateDestination(FDestination) Then
     Exit;
  try
    if ( DirectoryExists ( FSource )) Then
      Begin
        fb_InternalCopyDirectory ( FSource, FDestination, FFilter, not ( cpNoStructure in FFilesOptions ), cpDestinationIsFile in FFileOptions, cpCopyAll in FFilesOptions, cpCreateBackup in FFileOptions );
      End
    Else
      Begin
        fb_InternalCopyFile ( FSource, FDestination, cpDestinationIsFile in FFileOptions, cpCreateBackup in FFileOptions );
      End ;
  finally
    FinProgress := false;
  End ;
end;

function TExtFileCopy.fb_InternalCopyFile ( const as_Source, as_Destination : String ; const ab_DestinationIsFile, ab_CreateBackup : Boolean ):Boolean;
var lsr_AttrSource      : TSearchRec ;

begin
  Result := CreateDestination ( as_Destination );
  if FileExists ( as_Source ) Then
    Begin
      if ( DirectoryExists ( as_Destination )) Then
        Begin
          FindFirst ( as_Source, faAnyFile, lsr_AttrSource );
          Result := CopyFile ( as_Source, as_Destination + DirectorySeparator + lsr_AttrSource.Name, ab_DestinationIsFile, ab_CreateBackup ) <> 0 ;
          findclose(lsr_AttrSource);
        End
      Else
        Begin
          Result := CopyFile ( as_Source, as_Destination, ab_DestinationIsFile, ab_CreateBackup ) <> 0
        End ;
    End
  Else
    IsCopyOk ( CST_COPYFILES_ERROR_DIRECTORY_CREATE, GS_COPYFILES_ERROR_DIRECTORY_CREATE + ' ' + as_Destination );
End ;


function TExtFileCopy.fb_InternalCopyDirectory ( const as_Source, as_Destination, as_Mask : String ; const ab_CopyStructure, ab_DestinationIsFile, ab_CopyAll, ab_CreateBackup : Boolean ):Boolean;
var li_Error, li_i : Integer ;
    ls_Source ,
    ls_FileName ,
    ls_destination  : String ;
    lstl_StringList : TStringList ;
    lsr_AttrSource      : Tsearchrec;
begin
  if not CreateDestination ( as_Destination ) Then
    Begin
      li_Error := CST_COPYFILES_ERROR_DIRECTORY_CREATE ;
      Result := not IsCopyOk ( li_Error, as_Destination );
      Exit ;
    End ;
  if  assigned ( OnChange )
   Then
    OnChange ( Self, as_Source, as_Destination );
  Result := True ;
  lstl_StringList := TStringList.Create ;
  if fb_FindFiles ( lstl_StringList, as_Source, True, ab_CopyAll, True, as_Mask ) Then
    for li_i := 0 to lstl_StringList.count - 1 do
      Begin
        ls_Source := lstl_StringList.Strings [ li_i ];
        FindFirst( ls_Source,faanyfile,lsr_AttrSource);
        ls_FileName := lsr_AttrSource.Name ;
        findclose(lsr_AttrSource);
        if DirectoryExists ( ls_Source ) Then
          Begin
            if ab_CopyStructure then
              ls_destination := as_Destination + DirectorySeparator + ls_FileName
            Else
              ls_destination := as_Destination ;
            Result := fb_InternalCopyDirectory ( ls_Source, ls_Destination, as_Mask, ab_CopyStructure, ab_DestinationIsFile, ab_CopyAll, ab_CreateBackup );
          End
        Else
          if FileExists ( ls_Source ) Then
            Begin
               Result := InternalDefaultCopyFile ( ls_Source, as_Destination + DirectorySeparator + ls_FileName );
            End ;
      End ;
  lstl_StringList.Free ;
End ;



{TExtFilePartialCopy}

constructor TExtFilePartialCopy.Create(AOwner :Tcomponent);
begin
  inherited Create(AOwner);
  FExcludeReading := False ;
end;


function TExtFilePartialCopy.BeforeCopyBuffer ( var li_SizeRead, li_BytesTotal : IntCopy ) : Boolean ;

var li_pos : Longint ;
Begin
  Result := inherited BeforeCopyBuffer ( li_SizeRead, li_BytesTotal );
  if FExcludeReading
  and ( FExcludeStart <> '' )
  and ( FExcludeEnd   <> '' )
   Then
    Begin
      li_pos := 0 ;
      while li_pos < li_SizeRead do
        if lb_ExcludedFound then
          Begin

          End
         Else
          Begin
          End;
    end;
End ;

procedure TExtFilePartialCopy.AfterCopyBuffer ;

Begin
End ;


function TExtFilePartialCopy.BeforeCopy : Boolean ;

Begin
  Result := inherited BeforeCopy ();
  if FExcludeReading
  and ( FExcludeStart <> '' )
  and ( FExcludeEnd   <> '' )
   Then
    Begin
//      lpch_excludeStart := fs_HexToString ( FExcludeStart );
//      lpch_excludeEnd   := fs_HexToString ( FExcludeEnd   );
    End ;
End ;

{$IFDEF VERSIONS}
initialization
  p_ConcatVersion ( gVer_TExtFileCopy );
{$ENDIF}
end.


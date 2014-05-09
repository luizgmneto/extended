unit u_extfilecomp;

{$IFDEF FPC}
{$mode Delphi}
{$ENDIF}


interface

uses
  Classes,
  {$IFDEF VERSIONS}
  fonctions_version,
  {$ENDIF}
  SysUtils,
  DB,
  u_framework_dbcomponents;

{$IFDEF VERSIONS}
  const
    gVer_extfilecomp : T_Version = ( Component : 'Composant visibles de fichiers' ;
                                     FileUnit : 'u_extfilecomp' ;
                                     Owner : 'Matthieu Giroux' ;
                                     Comment : 'Gestion de fichiers dans le dossier d'un ordinateur.' ;
                                     BugsStory : '0.9.0.0 : TExtDBFileEdit.';
                                     UnitType : 3 ;
                                     Major : 0 ; Minor : 9 ; Release : 0 ; Build : 0 );

{$ENDIF}


type

  { TExtDBFileEdit }

   TExtDBFileEdit = class ( TFWDBFileEdit )
     private
        FLocalDir:String;
        FFilesDir:String;
        procedure SetFilesDir ( const Avalue : String );
        procedure SetFileField ( const Avalue : String );
        procedure VerifyField;
     protected
        procedure SaveFile(const ADirectory: String); virtual;
        procedure DeleteFile; virtual;
        procedure SetDataSource(AValue: TDataSource); override;
        procedure SetDataField(const AValue: string); override;
        procedure UpdateData(Sender: TObject); override;
      public
        property LocalDir: string read FLocalDir write SetFileField;
      published
        property FilesDir: string read FFilesDir write SetFilesDir;
    End;


implementation

uses Dialogs,
     Controls,
     fonctions_file,
     {$IFDEF FPC}
     unite_messages,
     FileUtil,
     lazutf8,
     {$ELSE}
     unite_messages_delphi,
     {$ENDIF}
     fonctions_system,
     fonctions_dialogs;

{ TExtDBFileEdit }

procedure TExtDBFileEdit.SetFilesDir(const Avalue: String);
begin
  FFilesDir:=IncludeTrailingPathDelimiter(Avalue);
end;

procedure TExtDBFileEdit.SetFileField(const Avalue: String);
begin
  FLocalDir:='';
  {$IFDEF WINDOWS}
  if (length(Avalue)<4)
  or (Avalue[2]<>':')
  or (Avalue[3]<>DirectorySeparator)Then
   Exit;
  {$ELSE}
  if (Avalue='')
  or (Avalue[1]<>DirectorySeparator)Then
   Exit;
  {$ENDIF}
  FLocalDir:=IncludeTrailingPathDelimiter(ExtractFileDir(Avalue));
  DeleteFile;
  Field.AsString:=ExtractFileName(Avalue);
end;

procedure TExtDBFileEdit.SetDataField(const AValue: string);
begin
  inherited SetDataField(AValue);
  VerifyField;
end;

procedure TExtDBFileEdit.VerifyField;
begin
  if Field is TBlobField Then
    MyShowMessage('Please do not use TExtDBFileEdit for BlobField.');
end;

procedure TExtDBFileEdit.SetDataSource(AValue: TDataSource);
begin
  inherited SetDataSource(AValue);
  VerifyField;
end;

procedure TExtDBFileEdit.DeleteFile;
Begin
  with Field do
    if  (AsString>'')
    and (FileExistsUTF8(FFilesDir+AsString)) Then
      DeleteFileUTF8(FFilesDir+AsString);
end;

procedure TExtDBFileEdit.SaveFile ( const ADirectory : String );
var ls_filePath,ls_file : String ;
    li_i : Integer;
Begin
  if FLocalDir > '' Then
    with Field do
     Begin
      ls_filePath := ADirectory+AsString;
      fb_CreateDirectoryStructure(ADirectory);
      if FileExistsUTF8(ls_filePath) Then
       Begin
        if FileSize(ls_filePath) = FileSize(FLocalDir+AsString) Then
          if MyShowMessage(GS_Files_seems_to_be_the_same_reuse,mbYesNo)=mrno Then
           Begin
            li_i := 1;
            ls_file := AsString;
            repeat
              inc ( li_i );
              ls_filePath:=ADirectory+fs_ExtractFileNameOnlyWithoutExt(AsString)+IntToStr(li_i)+ExtractFileExt(AsString);
            until not FileExistsUTF8(ls_filePath);
            AsString:=fs_ExtractFileNameOnlyWithoutExt(AsString)+IntToStr(li_i)+ExtractFileExt(AsString);
            fb_CopyFile(FLocalDir+ls_file,FFilesDir+AsString,False);
           end;
       end
      Else
       fb_CopyFile(FLocalDir+ls_file,FFilesDir+AsString,False);
      Refresh;
     end;

end;

procedure TExtDBFileEdit.UpdateData(Sender: TObject);
begin
  SetFileField ( FileName );
  if FFilesDir > ''
   Then SaveFile( FFilesDir )
   else MyShowMessage('FilesDir not set. Can not save on TExtDBFileEdit.');
end;

{$IFDEF VERSIONS}
initialization
  p_ConcatVersion ( gVer_extfilecomp );
{$ENDIF}
end.


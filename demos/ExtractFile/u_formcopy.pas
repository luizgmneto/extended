unit U_FormCopy;

{$IFDEF FPC}
{$mode Delphi}
{$R *.lfm}
{$ELSE}
{$R *.dfm}
{$ENDIF}


interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs,
{$IFDEF FPC}
  LResources, Process, SdfData, db, EditBtn,
{$ELSE}
  Mask, rxToolEdit, JvExControls,
{$ENDIF}
  U_ExtFileCopy, ExtCtrls, FileCtrl, StdCtrls,
  U_OnFormInfoIni, JvXPCheckCtrls, ComCtrls,
  Menus, JvXPButtons, Spin, U_DBListView,
  u_traducefile, u_extabscopy, u_extractfile, U_FormMainIni,
  JvXPCore ;

type

  { TF_Extract }

  TF_Extract = class(TF_FormMainIni)
    bt_Extract: TJvXPButton;
    ds_Destination: TDatasource;
    EBeginExtract: TEdit;
    EEndExtract: TEdit;
    EMiddleExtract: TEdit;
    ExtractAFile: TExtractFile;
    FilesSeek: TExtFileCopy;
    FDestination: TFileNameEdit;
    Label3: TLabel;
    ch_subdirs: TJvXPCheckbox;
    Label1: TLabel;
    Label2: TLabel;
    OnFormInfoIni: TOnFormInfoIni;
    Panel5: TPanel;
    ProgressBar: TProgressBar;
    Result: TMemo;
    Panel7: TPanel;
    Panel1: TPanel;
    Panel3: TPanel;
    DirectorySource: TDirectoryEdit;
    FileListSource: TFileListBox;
    Panel6: TPanel;
    Mask: TEdit;
    ResultErrors: TMemo;
    Panel2: TPanel;
    MainMenu: TMainMenu;
    Language: TMenuItem;
    Aide: TMenuItem;
    Faireundon: TMenuItem;
    APropos: TMenuItem;
    SdfDestination: TSdfDataSet;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    Panel8: TPanel;
    pa_DestImages: TPanel;
    FileListDestination: TFileListBox;
    Splitter3: TSplitter;
    Panel4: TPanel;
    procedure bt_ExtractClick(Sender: TObject);
    procedure DirectorySourceChange(Sender: TObject);
    procedure ExtractAFileProgress(Sender: Tobject; const BytesCopied,
      BytesTotal: cardinal);
    procedure FilesSeekChange(Sender: Tobject; const NewDirectory, DestinationDirectory : String);
    procedure FilesSeekFailure(Sender: Tobject; const ErrorCode: Integer;
      var ErrorMessage: AnsiString; var ContinueCopy: Boolean);
    procedure FilesSeekProgress(Sender: Tobject; BytesCopied,
      BytesTotal: cardinal);
    procedure FormDestroy(Sender: TObject);
    procedure MaskChange(Sender: TObject);
    procedure FilesSeekSuccess(Sender: TObject; const ASource,
      ADestination: string; const Errors: Integer);
    procedure LanguageClick(Sender: TObject);
    procedure FaireundonClick(Sender: TObject);
    procedure AProposClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ch_subdirsClick(Sender: TObject);
    procedure TraduceFileSuccess(Sender: TObject; const ASource,
      ADestination: string; const Errors: Integer);
  private
{$IFDEF FPC}
    Donate : TProcess;
{$ENDIF}
    FTraduitVers : String ;
    FCopieVers : String ;
    { private declarations }
  public
    constructor Create ( Aowner : TCOmponent ); override;
    procedure ChargeLangue(const ALangue: String);
    { public declarations }
  end;

var
  F_Extract: TF_Extract;
  FLangue : String ;

implementation

uses fonctions_init, IniFiles, fonctions_file,
{$IFDEF FPC}
  LCLType,
{$ELSE}
  Windows, ShellApi,
{$ENDIF}
  U_ABOUTBOX;

const
  CST_SITE_DONATE = 'http://matthieu.giroux.free.fr/html/donate.html';

{ TF_Extract }

procedure TF_Extract.AProposClick(Sender: TObject);
begin
  F_AboutBox.ShowModal;
end;

procedure TF_Extract.bt_ExtractClick(Sender: TObject);
var i : TEImageFileOption;
    stl_file : TStringList ;
begin
  if not FileExists(FDestination.Text)
  and not DirectoryExists(FileListSource.Directory)
   Then
    Exit;

  if FileExists ( FDestination.Text ) Then
    DeleteFile(FDestination.Text);
  stl_file := TStringList.Create;
  try
    stl_file.Add(ExtractAFile.FieldName);
    stl_file.SaveToFile(FDestination.Text);
  finally
    stl_file.Free;
  end;
  if ch_subdirs.Checked then
    FilesSeek.FilesOptions := FilesSeek.FilesOptions + [cpCopyAll]
   else
    FilesSeek.FilesOptions := FilesSeek.FilesOptions - [cpCopyAll];
  ExtractAFile.BeginExtract  :=  EBeginExtract.Text ;
  ExtractAFile.MiddleExtract := EMiddleExtract.Text ;
  ExtractAFile.EndExtract    :=    EEndExtract.Text ;
  Result.Lines.Clear;
  FilesSeek.Source := FileListSource.Directory ;
  SdfDestination.FileName := FDestination.Text ;
  FilesSeek.Mask   := Mask.Text ;
  FilesSeek.CopySourceToDestination;
  FileListSource.Directory := DirectorySource.Text;
  SdfDestination.Close;
end;

procedure TF_Extract.DirectorySourceChange(Sender: TObject);
begin
    FileListSource.Directory := DirectorySource.Text;

end;

procedure TF_Extract.ExtractAFileProgress(Sender: Tobject; const BytesCopied,
  BytesTotal: cardinal);
begin

end;

procedure TF_Extract.FaireundonClick(Sender: TObject);
begin
{$IFDEF FPC}
  Donate.Execute;
{$ELSE}
  shellexecute ( Handle, 'Open', CST_SITE_DONATE, '', '.', 0 );
{$ENDIF}
end;

procedure TF_Extract.FilesSeekChange(Sender: Tobject; const NewDirectory, DestinationDirectory : String);
begin
  if ( NewDirectory <> FileListSource.Directory )
    then
      FileListSource.Directory := NewDirectory;
end;

procedure TF_Extract.FilesSeekFailure(Sender: Tobject; const ErrorCode: Integer;
  var ErrorMessage: AnsiString; var ContinueCopy: Boolean);
begin
  ResultErrors.Lines.BeginUpdate ;
  ResultErrors.Lines.Add ( ErrorMessage );
  ResultErrors.Lines.EndUpdate ;
  case MessageDlg({$IFDEF FPC}'Erreur '+IntToStr(ErrorCode),{$ENDIF}ErrorMessage, mtError, [mbAbort, mbRetry,mbIgnore], 0 ) of
     mrAbort : abort;
     mrIgnore: ContinueCopy := False;
     mrRetry : ContinueCopy := True;
  end;
end;

procedure TF_Extract.FilesSeekProgress(Sender: Tobject; BytesCopied,
  BytesTotal: cardinal);
begin
  ProgressBar.Max := BytesTotal;
  ProgressBar.Position := BytesCopied;
end;

procedure TF_Extract.FilesSeekSuccess(Sender: TObject; const ASource,
  ADestination: string; const Errors: Integer);
begin
  Result.Lines.BeginUpdate ;
  Result.Lines.Add ( ASource + ' ' + FCopieVers + ' ' + ADestination  );
  if ( Result.Lines.Count > 50 )
   Then
    Result.Lines.Delete ( 0 );
  Result.Lines.EndUpdate ;

end;


procedure TF_Extract.FormDestroy(Sender: TObject);
begin
  if Assigned ( FIniFile ) then
    Begin
      FIniFile.WriteString  ( 'Parametres', 'Language'  , FLangue );
    End;
  OnFormInfoIni.p_ExecuteEcriture(Self);
  fb_iniWriteFile ( FIniFile, False );
end;

procedure TF_Extract.FormShow(Sender: TObject);
var
   FFichierIni ,
   FTempo : String ;
   FIniLangue : TIniFile ;
   FComboImages : TStringList ;
   i: Integer ;

   FMenuItem : TMenuItem ;

begin
  FLangue     := f_IniReadSectionStr ( 'Parametres', 'Language', 'english' );
  if ( FLangue = 'english' )
  and not FIniFile.SectionExists('Parametres')
  and assigned ( FIniFile ) then
    Begin
      FIniFile.WriteString ( 'Parametres', 'Language', 'english' );
    End;
  FFichierIni := ExtractFilePath(Application.ExeName) + 'Languages' + DirectorySeparator + 'english.lng' ;
  FIniLangue := TIniFile.Create ( FFichierIni );
  if ( not assigned ( FIniLangue ) or ( FIniLangue.ReadString ( 'Copy', 'COPYFILES_ERROR_PARTIAL_COPY', '' ) = '' ))
  and fb_CreateDirectoryStructure ( ExtractFilePath(Application.ExeName) + 'Languages' ) then
   Begin
     FFichierIni := ExtractFilePath(Application.ExeName) + 'Languages' + DirectorySeparator + 'english.lng' ;
     FIniLangue := TIniFile.Create ( FFichierIni );
     if assigned ( FIniLangue ) then
        Begin
          FIniLangue.WriteString ( 'Buttons', 'Extract', 'Extract' );
          FIniLangue.WriteString ( 'Checks', 'Subdirectories', 'Subdirectories' );
          FIniLangue.WriteString ( 'Checkboxes', 'Structure', 'Structure' );
          FIniLangue.WriteString ( 'Checkboxes', 'Traduce', 'Traduce to' );
          FIniLangue.WriteString ( 'Checkboxes', 'Backup', 'Backup' );
          FIniLangue.WriteString ( 'Checkboxes', 'Sub-directories', 'Sub-directories' );
          FIniLangue.WriteString ( 'Menu', 'Language', 'Language' );
          FIniLangue.WriteString ( 'Menu', 'Donate', 'Donate' );
          FIniLangue.WriteString ( 'Menu', 'Help', 'Help' );
          FIniLangue.WriteString ( 'Menu', 'About', 'About..' );
          FIniLangue.WriteString ( 'F_About', 'Comments', 'Copy of Files with Images Traducing' );
          FIniLangue.WriteString ( 'F_About', 'OK', 'OK' );
          FIniLangue.WriteString ( 'Copy', 'Traduced to', 'traduced to' );
          FIniLangue.WriteString ( 'Copy', 'Copied to', 'copied to' );
          FIniLangue.WriteString ( 'Copy', 'COPYFILES_ERROR_DIRECTORY_CREATE', 'Error creating directory ' );
          FIniLangue.WriteString ( 'Copy', 'COPYFILES_CONFIRM', 'Confirm Box' );
          FIniLangue.WriteString ( 'Copy', 'COPYFILES_CONFIRM_FILE_DELETE', 'Do you really want to erase the file ' );
          FIniLangue.WriteString ( 'Copy', 'COPYFILES_ERROR_FILE_DELETE', 'Can''t erase file ' );
          FIniLangue.WriteString ( 'Copy', 'COPYFILES_ERROR_CANT_APPEND', 'Can''t append to file ' );
          FIniLangue.WriteString ( 'Copy', 'COPYFILES_ERROR_CANT_CREATE', 'Can''t create file ' );
          FIniLangue.WriteString ( 'Copy', 'COPYFILES_ERROR_CANT_CHANGE_DATE', 'Can''t set date to file ' );
          FIniLangue.WriteString ( 'Copy', 'COPYFILES_ERROR_CANT_READ', 'Reading file error ' );
          FIniLangue.WriteString ( 'Copy', 'COPYFILES_ERROR_PARTIAL_COPY_SEEK', 'Error on partial copy of file ' );
          FIniLangue.WriteString ( 'Copy', 'COPYFILES_ERROR_PARTIAL_COPY', 'Partial copy of file ' );
          FIniLangue.WriteString ( 'Copy', 'COPYFILES_ERROR_CANT_COPY', 'Can''t copy file ' );
          FIniLangue.WriteString ( 'Copy', 'COPYFILES_ERROR_IS_FILE', 'Can''t copy directory to file ' );
          FComboImages := TStringList.Create ;
          FComboImages.Add( 'JPEG Images ( *.jpg )');
          FComboImages.Add( 'GIF Images ( *.gif )');
          FComboImages.Add( 'Bitmap Images ( *.bmp )');
          FComboImages.Add( 'Targa Images ( *.tga )');
          FComboImages.Add( 'Autodesk Images ( *.pic )');
          FComboImages.Add( 'SGI Images ( *.sgi )');
          FComboImages.Add( 'PCX Images ( *.pcx )');
          FComboImages.Add( 'PCD Images ( *.pcd )');
          FComboImages.Add( 'Portable MAP Images ( *.ppm )');
          FComboImages.Add( 'CUT Images ( *.cut )');
          FComboImages.Add( 'RLA Images ( *.rla )');
          FComboImages.Add( 'PNG Images ( *.png )');
          FComboImages.Add( 'EPS Images ( *.eps )');
          FComboImages.Add( 'TIFF Images ( *.tif )');
          for i := 0 to FComboImages.Count - 1 do
            Begin
             	FIniLangue.WriteString( 'ImagesCombo', 'Line' + IntToStr ( i ), FComboImages [ i ] );
            End;
          FComboImages.Free ;
          FIniLangue.UpdateFile ;
          FIniLangue.Free ;
        End;
     FFichierIni := ExtractFilePath(Application.ExeName) + 'Languages' + DirectorySeparator + 'francais.lng' ;
     FIniLangue := TIniFile.Create ( FFichierIni );
     if assigned ( FIniLangue ) then
        Begin
          FIniLangue.WriteString ( 'Buttons', 'Extract', bt_Extract.Caption );
          FIniLangue.WriteString ( 'Checks', 'Subdirectories', ch_subdirs.Caption );
          FIniLangue.WriteString ( 'Copy', 'Traduced to', 'traduit vers' );
          FIniLangue.WriteString ( 'Copy', 'Copied to', 'copié vers' );
          FIniLangue.WriteString ( 'Copy', 'COPYFILES_ERROR_DIRECTORY_CREATE', 'Erreur à la création du répertoire' );
          FIniLangue.WriteString ( 'Copy', 'COPYFILES_CONFIRM', 'Demande de confirmation' );
          FIniLangue.WriteString ( 'Copy', 'COPYFILES_CONFIRM_FILE_DELETE', 'Voulez-vous effacer le fichier' );
          FIniLangue.WriteString ( 'Copy', 'COPYFILES_ERROR_FILE_DELETE', 'Impossible d''effacer le fichier' );
          FIniLangue.WriteString ( 'Copy', 'COPYFILES_ERROR_CANT_APPEND', 'Impossible d''ajouter au fichier' );
          FIniLangue.WriteString ( 'Copy', 'COPYFILES_ERROR_CANT_CREATE', 'Impossible de créer le fichier' );
          FIniLangue.WriteString ( 'Copy', 'COPYFILES_ERROR_CANT_CHANGE_DATE', 'Impossible d''affecter la date au fichier' );
          FIniLangue.WriteString ( 'Copy', 'COPYFILES_ERROR_CANT_READ', 'Impossible de lire le fichier' );
          FIniLangue.WriteString ( 'Copy', 'COPYFILES_ERROR_PARTIAL_COPY_SEEK', 'Erreur à la copie partielle du fichier' );
          FIniLangue.WriteString ( 'Copy', 'COPYFILES_ERROR_PARTIAL_COPY', 'Copie partielle du fichier' );
          FIniLangue.WriteString ( 'Copy', 'COPYFILES_ERROR_CANT_COPY', 'Impossible de copier' );
          FIniLangue.WriteString ( 'Copy', 'COPYFILES_ERROR_IS_FILE', 'Ne peut copier dans le fichier' );
          FIniLangue.WriteString ( 'Menu', 'Language', Language.Caption );
          FIniLangue.WriteString ( 'Menu', 'Help', Aide.Caption );
          FIniLangue.WriteString ( 'Menu', 'Donate', Faireundon.Caption );
          FIniLangue.WriteString ( 'Menu', 'About', APropos.Caption );
          FIniLangue.WriteString ( 'F_About', 'Comments', F_AboutBox.Comments.Caption );
          FIniLangue.WriteString ( 'F_About', 'OK', F_AboutBox.OKButton.Caption );
          FIniLangue.UpdateFile ;
          FIniLangue.Free ;
        End;
   End;
  FComboImages := TStringList.Create ;
  if fb_FindFiles( FComboImages,ExtractFilePath(Application.ExeName) + 'Languages', True, False, False, '*.lng'  ) Then
    Begin
      if FComboImages.Count > 0 then
        Begin
          for i := 0 to FComboImages.Count - 1 do
            Begin
              FMenuItem := TMenuItem.Create( Self );
              Language.Add ( FMenuItem );
              FMenuItem.Visible := True ;
              FTempo := FComboImages [i];
              FTempo := Copy( FTempo, length (ExtractFilePath(FTempo)) + 1, length ( FTempo ) - length (ExtractFilePath(FTempo)));
              FTempo := copy( FTempo, 1, length ( FTempo ) - 4 );
              FMenuItem.Caption := Ftempo ;

              FMenuItem.OnClick := LanguageClick;
            End;
        End;

    End;
  ChargeLangue ( FLangue );
//  FilesSeek.TraduceCopy := TraduceFile;

end;

procedure TF_Extract.ch_subdirsClick(Sender: TObject);
begin

end;

procedure TF_Extract.ChargeLangue(const ALangue : String );
var
   FFichierIni ,
   Ftempo : String ;
   FIniLangue : TIniFile ;
   i: Integer ;
begin
  FLangue := ALangue ;
  FFichierIni := ExtractFilePath(Application.ExeName) + 'Languages' +DirectorySeparator + FLangue + '.lng' ;

  if ( FileExists ( FFichierIni )) then
    Begin
      FIniLangue := TIniFile.Create ( FFichierIni );
      if assigned ( FIniLangue ) then
        Begin
          bt_Extract     .Caption := FIniLangue.ReadString ( 'Buttons', 'Extract', 'Copy' );
          ch_subdirs     .Caption := FIniLangue.ReadString ( 'Checks', 'Subdirectories', 'Subdirectories' );
          Language    .Caption := FIniLangue.ReadString ( 'Menu', 'Language', 'Language' );
          Faireundon  .Caption := FIniLangue.ReadString ( 'Menu', 'Donate', 'Donate' );
          Aide        .Caption := FIniLangue.ReadString ( 'Menu', 'Help', 'Help' );
          APropos     .Caption := FIniLangue.ReadString ( 'Menu', 'About', 'About' );
          F_AboutBox.Comments.Caption := FIniLangue.ReadString ( 'F_About', 'Comments', 'Copy of Files with Images Traducing' );
          F_AboutBox.OKButton.Caption := FIniLangue.ReadString ( 'F_About', 'OK', 'OK' );
          FTraduitVers := FIniLangue.ReadString ( 'Copy', 'Traduced to', 'traduced to' );
          FCopieVers   := FIniLangue.ReadString ( 'Copy', 'Copied to', 'copied to' );
         // GS_COPYFILES_CONFIRM := FIniLangue.ReadString ( 'Copy', 'COPYFILES_CONFIRM', 'Confirm Box' );
         // GS_COPYFILES_CONFIRM_FILE_DELETE := FIniLangue.ReadString ( 'Copy', 'COPYFILES_CONFIRM_FILE_DELETE', 'Do you really want to erase the file' ) + ' ' ;

          FIniLangue.Free ;
        End;
    End ;
End ;
procedure TF_Extract.LanguageClick(Sender: TObject);
var Ftempo  ,
    FLangue : String ;
    i : Integer ;
begin
  If ( Sender is TMenuItem ) Then
    Begin
      Ftempo := ( Sender as TMenuItem ).Caption ;
      for I := 1 to length ( Ftempo ) do
        if (Ftempo [i] <> '&' ) then
          FLangue := FLangue + Ftempo [I];
      ChargeLangue( FLangue );
    End;
end;

procedure TF_Extract.MaskChange(Sender: TObject);
begin
  FileListSource.Mask := Mask.text ;;
end;

procedure TF_Extract.TraduceFileSuccess(Sender: TObject; const ASource,
  ADestination: string; const Errors: Integer);
begin
  Result.Lines.BeginUpdate ;
  Result.Lines.Add ( ASource + ' '+ FTraduitVers + ' ' + ADestination  );
  if ( Result.Lines.Count > 50 )
   Then
    Result.Lines.Delete ( 0 );
  Result.Lines.EndUpdate ;
end;

constructor TF_Extract.Create(Aowner: TCOmponent);
begin
  AutoIni:=True;
  inherited;
  FilesSeek.TraduceCopy := ExtractAFile;

{$IFDEF FPC}
  if not ( csDesigning in ComponentState ) Then
    Begin
      Donate := TProcess.Create ( Self );
      Donate.ApplicationName := 'open' ;
      Donate.CommandLine := 'open ' + CST_SITE_DONATE ;
    end;
{$ENDIF}

end;

end.


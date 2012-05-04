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
  LResources, Process, EditBtn, 
{$ELSE}
  Mask, rxToolEdit, JvExControls,
{$ENDIF}
  U_ExtFileCopy, ExtCtrls, FileCtrl, StdCtrls,
  U_OnFormInfoIni, JvXPCheckCtrls, ComCtrls,
  Menus, JvXPButtons, Spin, U_DBListView,
  u_traducefile, u_extabscopy, U_FormMainIni,
  JvXPCore ;

type

  { TF_Copier }

  TF_Copier = class(TF_FormMainIni)
    bt_Copy: TJvXPButton;
    ch_Structure: TJvXPCheckBox;
    ch_Backup: TJvXPCheckBox;
    ch_CopyAll: TJvXPCheckBox;
    FileCopy: TExtFileCopy;
    OnFormInfoIni: TOnFormInfoIni;
    Panel5: TPanel;
    ch_RWidth: TJvXPCheckBox;
    ch_RHeight: TJvXPCheckBox;
    ch_GarderProportions: TJvXPCheckBox;
    ProgressBar: TProgressBar;
    se_RWidth: TSpinEdit;
    se_RHeight: TSpinEdit;
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
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    Panel8: TPanel;
    pa_DestImages: TPanel;
    cb_TypeDest: TComboBox;
    ch_Traduire: TJvXPCheckBox;
    FileListDestination: TFileListBox;
    Splitter3: TSplitter;
    Panel4: TPanel;
    DirectoryDestination: TDirectoryEdit;
    TraduceFile: TTraduceFile;
    procedure bt_CopyClick(Sender: TObject);
    procedure ch_BackupClick(Sender: TObject);
    procedure ch_CopyAllClick(Sender: TObject);
    procedure ch_StructureClick(Sender: TObject);
    procedure DirectoryDestinationChange(Sender: TObject);
    procedure DirectorySourceChange(Sender: TObject);
    procedure FileCopyChange(Sender: Tobject; const NewDirectory, DestinationDirectory : String);
    procedure FileCopyFailure(Sender: Tobject; const ErrorCode: Integer;
      var ErrorMessage: AnsiString; var ContinueCopy: Boolean);
    procedure FileCopyProgress(Sender: Tobject; BytesCopied,
      BytesTotal: cardinal);
    procedure FormDestroy(Sender: TObject);
    procedure MaskChange(Sender: TObject);
    procedure FileCopySuccess(Sender: TObject; const ASource,
      ADestination: string; const Errors: Integer);
    procedure LanguageClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FaireundonClick(Sender: TObject);
    procedure AProposClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
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
  F_Copier: TF_Copier;
  FLangue : String ;

implementation

uses fonctions_init, IniFiles, fonctions_file,
{$IFDEF FPC}
  LCLType, unit_messagescopy,
{$ELSE}
  Windows, ShellApi, unit_messagescopy_delphi,
{$ENDIF}
  u_aboutbox;

const
  CST_SITE_DONATE = 'http://matthieu.giroux.free.fr/html/donate.html';

{ TF_Copier }

procedure TF_Copier.AProposClick(Sender: TObject);
begin
  F_AboutBox.ShowModal;
end;

procedure TF_Copier.bt_CopyClick(Sender: TObject);
var i : TEImageFileOption;
begin

  TraduceFile.ResizeWidth  := 0 ;
  TraduceFile.ResizeHeight := 0 ;
  if ch_Traduire.Checked Then
    Begin
      if ch_RWidth.Checked
       Then
        Begin
          TraduceFile.ResizeWidth := se_RWidth.Value ;
        End;
      if ch_Rheight.Checked
       Then
        Begin
          TraduceFile.ResizeHeight := se_RHeight.Value ;
        End;
      FileCopy.TraduceCopy := TraduceFile;
      for i := low ( TEImageFileOption ) to high ( TEImageFileOption ) do
       if ( pos ( EExtensionsImages [ i ], cb_TypeDest.Text ) > 0 ) Then
           TraduceFile.ImageDestinationOption := TEImageFileOption(i);
    End
  Else
    Begin
      FileCopy.TraduceCopy := nil;
    End ;

  ch_BackupClick    ( Self );
  ch_CopyAllClick   ( Self );
  ch_StructureClick ( Self );

  Result.Lines.Clear;
  FileCopy.Source := FileListSource.Directory ;
  FileCopy.Destination := DirectoryDestination.Text;
  FileCopy.Mask := FileListSource.Mask ;
  FileCopy.CopySourceToDestination;
  FileListSource.Directory := DirectorySource.Text;

end;

procedure TF_Copier.ch_BackupClick(Sender: TObject);
begin

  If ch_Backup.Checked
   then
    Begin
      FileCopy.FileOptions := FileCopy.FileOptions + [cpCreateBackup];
    End
  else
    FileCopy.FileOptions := FileCopy.FileOptions - [cpCreateBackup];
end;

procedure TF_Copier.ch_CopyAllClick(Sender: TObject);
begin
  ch_Structure.Enabled := ch_CopyAll.Checked ;
  If ch_CopyAll.Checked then
    FileCopy.FilesOptions := FileCopy.FilesOptions + [cpCopyAll]
  else
    FileCopy.FilesOptions := FileCopy.FilesOptions - [cpCopyAll];

end;

procedure TF_Copier.ch_StructureClick(Sender: TObject);
begin
  If ch_Structure.Checked then
    FileCopy.FilesOptions := FileCopy.FilesOptions - [cpNoStructure]
  else
    FileCopy.FilesOptions := FileCopy.FilesOptions + [cpNoStructure];
end;

procedure TF_Copier.DirectoryDestinationChange(Sender: TObject);
begin
  if DirectoryExists ( DirectoryDestination.Text )
   then
     FileListDestination.Directory := DirectoryDestination.Text;
end;

procedure TF_Copier.DirectorySourceChange(Sender: TObject);
begin
    FileListSource.Directory := DirectorySource.Text;

end;

procedure TF_Copier.FaireundonClick(Sender: TObject);
begin
{$IFDEF FPC}
  Donate.Execute;
{$ELSE}
  shellexecute ( Handle, 'Open', CST_SITE_DONATE, '', '.', 0 );
{$ENDIF}
end;

procedure TF_Copier.FileCopyChange(Sender: Tobject; const NewDirectory, DestinationDirectory : String);
begin
  if ( NewDirectory <> FileListSource.Directory )
    then
      FileListSource.Directory := NewDirectory;
end;

procedure TF_Copier.FileCopyFailure(Sender: Tobject; const ErrorCode: Integer;
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

procedure TF_Copier.FileCopyProgress(Sender: Tobject; BytesCopied,
  BytesTotal: cardinal);
begin
  ProgressBar.Max := BytesTotal;
  ProgressBar.Position := BytesCopied;
end;

procedure TF_Copier.FileCopySuccess(Sender: TObject; const ASource,
  ADestination: string; const Errors: Integer);
begin
  Result.Lines.BeginUpdate ;
  Result.Lines.Add ( ASource + ' ' + FCopieVers + ' ' + ADestination  );
  if ( Result.Lines.Count > 50 )
   Then
    Result.Lines.Delete ( 0 );
  Result.Lines.EndUpdate ;

end;

procedure TF_Copier.FormActivate(Sender: TObject);
begin
  ch_Structure.Enabled := ch_CopyAll.Checked ;

end;

procedure TF_Copier.FormDestroy(Sender: TObject);
begin
  if Assigned ( FIniFile ) then
    Begin
      FIniFile.WriteInteger ( 'Traduce'   , 'ComboIndex', cb_TypeDest.ItemIndex );
      FIniFile.WriteString  ( 'Parametres', 'Language'  , FLangue );
    End;
  OnFormInfoIni.p_ExecuteEcriture(Self);
  fb_iniWriteFile ( FIniFile, False );
end;

procedure TF_Copier.FormShow(Sender: TObject);
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
          FIniLangue.WriteString ( 'Buttons', 'Copy', 'Copy' );
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
          FIniLangue.WriteString ( 'Buttons', 'Copy', bt_Copy.Caption );
          FIniLangue.WriteString ( 'Checkboxes', 'Structure', ch_Structure.Caption );
          FIniLangue.WriteString ( 'Checkboxes', 'Traduce', ch_Traduire.Caption );
          FIniLangue.WriteString ( 'Checkboxes', 'Backup', ch_Backup.Caption );
          FIniLangue.WriteString ( 'Checkboxes', 'Sub-directories', ch_CopyAll.Caption );
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
          if cb_TypeDest.Items.Count > 0 Then
            for i := 0 to cb_TypeDest.Items.Count - 1 do
              Begin
                FIniLangue.WriteString( 'ImagesCombo', 'Line' + IntToStr ( i ), cb_TypeDest.Items [ i ] );
              End;
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
//  FileCopy.TraduceCopy := TraduceFile;

end;

procedure TF_Copier.ChargeLangue(const ALangue : String );
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
          bt_Copy     .Caption := FIniLangue.ReadString ( 'Buttons', 'Copy', 'Copy' );
          ch_Structure.Caption := FIniLangue.ReadString ( 'Checkboxes', 'Structure', 'Structure' );
          ch_Traduire .Caption := FIniLangue.ReadString ( 'Checkboxes', 'Traduce', 'Traduce to' );
          ch_Backup   .Caption := FIniLangue.ReadString ( 'Checkboxes', 'Backup', 'Backup' );
          ch_CopyAll  .Caption := FIniLangue.ReadString ( 'Checkboxes', 'Sub-directories', 'Sub-directories' );
          Language    .Caption := FIniLangue.ReadString ( 'Menu', 'Language', 'Language' );
          Faireundon  .Caption := FIniLangue.ReadString ( 'Menu', 'Donate', 'Donate' );
          Aide        .Caption := FIniLangue.ReadString ( 'Menu', 'Help', 'Help' );
          APropos     .Caption := FIniLangue.ReadString ( 'Menu', 'About', 'About' );
          F_AboutBox.Comments.Caption := FIniLangue.ReadString ( 'F_About', 'Comments', 'Copy of Files with Images Traducing' );
          F_AboutBox.OKButton.Caption := FIniLangue.ReadString ( 'F_About', 'OK', 'OK' );
          FTraduitVers := FIniLangue.ReadString ( 'Copy', 'Traduced to', 'traduced to' );
          FCopieVers   := FIniLangue.ReadString ( 'Copy', 'Copied to', 'copied to' );
          {
          GS_COPYFILES_ERROR_DIRECTORY_CREATE := FIniLangue.ReadString ( 'Copy', 'COPYFILES_ERROR_DIRECTORY_CREATE', 'Error creating directory' ) + ' ' ;
          GS_COPYFILES_CONFIRM := FIniLangue.ReadString ( 'Copy', 'COPYFILES_CONFIRM', 'Confirm Box' );
          GS_COPYFILES_CONFIRM_FILE_DELETE := FIniLangue.ReadString ( 'Copy', 'COPYFILES_CONFIRM_FILE_DELETE', 'Do you really want to erase the file' ) + ' ' ;
          GS_COPYFILES_ERROR_FILE_DELETE := FIniLangue.ReadString ( 'Copy', 'COPYFILES_ERROR_FILE_DELETE', 'Can''t erase file' ) + ' ' ;
          GS_COPYFILES_ERROR_CANT_APPEND := FIniLangue.ReadString ( 'Copy', 'COPYFILES_ERROR_CANT_APPEND', 'Can''t append to file' ) + ' ' ;
          GS_COPYFILES_ERROR_CANT_CREATE := FIniLangue.ReadString ( 'Copy', 'COPYFILES_ERROR_CANT_CREATE', 'Can''t create file' ) + ' ' ;
          GS_COPYFILES_ERROR_CANT_CHANGE_DATE := FIniLangue.ReadString ( 'Copy', 'COPYFILES_ERROR_CANT_CHANGE_DATE', 'Can''t set date to file' ) + ' ' ;
          GS_COPYFILES_ERROR_CANT_READ := FIniLangue.ReadString ( 'Copy', 'COPYFILES_ERROR_CANT_READ', 'Reading file error' ) + ' ' ;
          GS_COPYFILES_ERROR_PARTIAL_COPY_SEEK := FIniLangue.ReadString ( 'Copy', 'COPYFILES_ERROR_PARTIAL_COPY_SEEK', 'Error on partial copy of file' ) + ' ' ;
          GS_COPYFILES_ERROR_PARTIAL_COPY := FIniLangue.ReadString ( 'Copy', 'COPYFILES_ERROR_PARTIAL_COPY', 'Partial copy of file' ) + ' ' ;
          GS_COPYFILES_ERROR_PARTIAL_COPY := FIniLangue.ReadString ( 'Copy', 'COPYFILES_ERROR_CANT_COPY', 'Can''t copy file' ) + ' ' ;
          GS_COPYFILES_ERROR_IS_FILE := FIniLangue.ReadString ( 'Copy', 'COPYFILES_ERROR_IS_FILE', 'Can''t copy directory to file' ) + ' ' ;
          }
          if FIniLangue.SectionExists ( 'ImagesCombo' ) then
            Begin
              cb_TypeDest.Items.Clear ;
              i := 0 ;
              FTempo := FIniLangue.ReadString ( 'ImagesCombo', 'Line0', '' );
              while ( FTempo <> '' ) do
                Begin
                  cb_TypeDest.Items.Add ( Ftempo );
                  inc ( i );
                  FTempo := FIniLangue.ReadString ( 'ImagesCombo', 'Line' + IntToStr ( i ), '' );
                End;
            End;

          FIniLangue.Free ;
        End;
    End ;
  cb_TypeDest.ItemIndex := f_IniReadSectionInt ( 'Traduce', 'ComboIndex', 0 );
End ;
procedure TF_Copier.LanguageClick(Sender: TObject);
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

procedure TF_Copier.MaskChange(Sender: TObject);
begin
  FileListSource.Mask := Mask.text ;;
end;

procedure TF_Copier.TraduceFileSuccess(Sender: TObject; const ASource,
  ADestination: string; const Errors: Integer);
begin
  Result.Lines.BeginUpdate ;
  Result.Lines.Add ( ASource + ' '+ FTraduitVers + ' ' + ADestination  );
  if ( Result.Lines.Count > 50 )
   Then
    Result.Lines.Delete ( 0 );
  Result.Lines.EndUpdate ;

end;

constructor TF_Copier.Create(Aowner: TCOmponent);
begin
  AutoIni:=True;
  inherited;

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


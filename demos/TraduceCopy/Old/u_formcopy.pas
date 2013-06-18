unit U_FormCopy;

{$IFDEF FPC}
{$mode objfpc}{$H+}
{$ENDIF}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs,
  U_ExtFileCopy, ExtCtrls, FileCtrl, StdCtrls, lresources,
  U_OnFormInfoIni, JvXPCheckCtrls, ComCtrls,// U_TraduceFile,
  Menus, JvXPButtons, EditBtn, Process, PCheck, Spin, U_DBListView;

type

  { TF_Copier }

  TF_Copier = class(TForm)
    bt_Copy: TJvXPButton;
    ch_Structure: TPCheck;
    ch_Backup: TPCheck;
    ch_CopyAll: TPCheck;
    FileCopy: TExtFileCopy;
    OnFormInfoIni: TOnFormInfoIni;
    Panel5: TPanel;
    Donate: TProcess;
    ch_RWidth: TPCheck;
    ch_RHeight: TPCheck;
    ch_GarderProportions: TPCheck;
    ProgressBar: TProgressBar;
    se_RWidth: TSpinEdit;
    se_RHeight: TSpinEdit;
//    TraduceFile: TTraduceFile;
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
    ch_Traduire: TPCheck;
    FileListDestination: TFileListBox;
    Splitter3: TSplitter;
    Panel4: TPanel;
    DirectoryDestination: TDirectoryEdit;
    Licence: TMenuItem;
    procedure bt_CopyClick(Sender: TObject);
    procedure bt_CopyMouseUp(Sender: TOBject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
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
    procedure TraduceFileSuccess(Sender: TObject; const ASource,
      ADestination: string; const Errors: Integer);
    procedure LanguageClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FaireundonClick(Sender: TObject);
    procedure AProposClick(Sender: TObject);
    procedure LicenceClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FTraduitVers : String ;
    FCopieVers : String ;
    { private declarations }
  public
    procedure LicenseTerminate ( const as_Licence : String );
    procedure ChargeLangue(const ALangue: String);
    { public declarations }
  end;

var
  F_Copier: TF_Copier;
  FLangue : String ;

implementation

uses fonctions_init, IniFiles, fonctions_file, LCLType,
  U_ABOUTBOX, u_licence;

{ TF_Copier }

procedure TF_Copier.AProposClick(Sender: TObject);
begin
  F_AboutBox.ShowModal;
end;

procedure TF_Copier.bt_CopyMouseUp(Sender: TOBject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
{
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
      if ( pos ( '.jpg', cb_TypeDest.Text ) > 0 ) Then
         TraduceFile.ImageDestinationOption := foJPEG
        Else
      if ( pos ( '.bmp', cb_TypeDest.Text ) > 0 ) Then
         TraduceFile.ImageDestinationOption := foBMP
        Else
      if ( pos ( '.tga', cb_TypeDest.Text ) > 0 ) Then
         TraduceFile.ImageDestinationOption := foTarga
        Else
      if ( pos ( '.pic', cb_TypeDest.Text ) > 0 ) Then
         TraduceFile.ImageDestinationOption := foAutodesk
        Else
      if ( pos ( '.sgi', cb_TypeDest.Text ) > 0 ) Then
         TraduceFile.ImageDestinationOption := foSGI
        Else
      if ( pos ( '.pcx', cb_TypeDest.Text ) > 0 ) Then
         TraduceFile.ImageDestinationOption := foPCX
        Else
      if ( pos ( '.pcd', cb_TypeDest.Text ) > 0 ) Then
         TraduceFile.ImageDestinationOption := foPCD
        Else
      if ( pos ( '.ppm', cb_TypeDest.Text ) > 0 ) Then
         TraduceFile.ImageDestinationOption := foPortableMap
        Else
      if ( pos ( '.cut', cb_TypeDest.Text ) > 0 ) Then
         TraduceFile.ImageDestinationOption := foCUT
        Else
      if ( pos ( '.gif', cb_TypeDest.Text ) > 0 ) Then
         TraduceFile.ImageDestinationOption := foGIF
        Else
      if ( pos ( '.rla', cb_TypeDest.Text ) > 0 ) Then
         TraduceFile.ImageDestinationOption := foRLA
        Else
      if ( pos ( '.psd', cb_TypeDest.Text ) > 0 ) Then
         TraduceFile.ImageDestinationOption := foPhotoshop
        Else
      if ( pos ( '.psp', cb_TypeDest.Text ) > 0 ) Then
         TraduceFile.ImageDestinationOption := foPaintshop
        Else
      if ( pos ( '.png', cb_TypeDest.Text ) > 0 ) Then
         TraduceFile.ImageDestinationOption := foPNG
        Else
      if ( pos ( '.eps', cb_TypeDest.Text ) > 0 ) Then
         TraduceFile.ImageDestinationOption := foEPS
        Else
      if ( pos ( '.tif', cb_TypeDest.Text ) > 0 ) Then
         TraduceFile.ImageDestinationOption := foTIFF ;
    End
  Else
    Begin
      FileCopy.TraduceCopy := nil;
    End ;
 }
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

procedure TF_Copier.bt_CopyClick(Sender: TObject);
begin

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
  Donate.Execute;
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
   lb_Licence : Boolean ;
   FFichierIni ,
   FTempo : String ;
   FIniLangue : TIniFile ;
   FComboImages : TStringList ;
   i: Integer ;

   FMenuItem : TMenuItem ;

begin
  FIniFile := TMemIniFile (TIniFile.Create (ExtractFilePath(Application.ExeName) + CST_FICHIER_INI + ExtractFileName ( Application.ExeName ) + '.INI'));
  FLangue     := f_IniReadSectionStr ( 'Parametres', 'Language', 'english' );
  if ( FLangue = 'english' )
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
          FIniLangue.WriteString ( 'F_Licence', 'Accept', 'Accept' );
          FIniLangue.WriteString ( 'F_Licence', 'Refuse', 'Refuse' );
          FIniLangue.WriteString ( 'F_Licence', 'License', 'License' );
          FIniLangue.WriteString ( 'F_Licence', 'Language', 'Language' );
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
          FIniLangue.WriteString ( 'F_Licence', 'Accept', 'Accepter' );
          FIniLangue.WriteString ( 'F_Licence', 'Refuse', 'Refuser' );
          FIniLangue.WriteString ( 'F_Licence', 'License', 'Licence' );
          FIniLangue.WriteString ( 'F_Licence', 'Language', 'Langage' );
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
  FComboImages := nil ;
  if fb_FindFiles( FComboImages,ExtractFilePath(Application.ExeName) + 'Languages', '*.lng', False  ) Then
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
              F_Licence.cb_Langage.Items.Add ( FTempo );

              FMenuItem.OnClick := @LanguageClick;
            End;
        End;

    End;
  ChargeLangue ( FLangue );
//  FileCopy.TraduceCopy := TraduceFile;
  lb_Licence := False ;
  if assigned ( FIniFile ) then
    Begin
      lb_Licence := FIniFile.ReadBool ( 'Parametres', 'LicenceOK', False );
    End
   Else
    Application.Terminate ;

 if ( not lb_Licence ) then
   Begin
     F_Licence.ShowModal ;
   End;

end;

procedure TF_Copier.LicenseTerminate ( const as_Licence : String );
Begin
  If not FileExists ( as_Licence ) Then
    Begin
      ShowMessage ( 'No License, Application will close...'+as_Licence );
      Application.Terminate ;
    End;
End;


procedure TF_Copier.ChargeLangue(const ALangue : String );
var
   FFichierIni ,
   Ftempo : String ;
   FIniLangue : TIniFile ;
   i: Integer ;
var
   ls_Licence : String ;
begin
  FLangue := ALangue ;
  ls_Licence := ExtractFilePath(Application.ExeName) + 'Languages' +DirectorySeparator + 'licence.' + ALangue + '.rtf' ;
  FFichierIni := ExtractFilePath(Application.ExeName) + 'Languages' +DirectorySeparator + FLangue + '.lng' ;
  LicenseTerminate ( ls_Licence );

  if ( FileExists ( FFichierIni )) then
    Begin
      FIniLangue := TIniFile.Create ( FFichierIni );
      if assigned ( FIniLangue ) then
        Begin
          Licence     .Caption := FIniLangue.ReadString ( 'F_Licence', 'License', 'Licence' );
          F_Licence   .Caption := FIniLangue.ReadString ( 'F_Licence', 'License', 'Licence' );
          F_Licence   .bt_Refuser.Caption := FIniLangue.ReadString ( 'F_Licence', 'Refuse', 'Refuser' );
          F_Licence   .bt_Accepter  .Caption := FIniLangue.ReadString ( 'F_Licence', 'Accept', 'Accepter' );
          F_Licence   .lb_Langage.Caption := FIniLangue.ReadString ( 'F_Licence', 'Language', 'Language' );
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

procedure TF_Copier.LicenceClick(Sender: TObject);
begin
  F_Licence.ShowModal;
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

initialization
  {$IFDEF WINDOWS}
    DirectorySeparator := '\' ;
  {$ELSE}
    DirectorySeparator := '/' ;
  {$ENDIF}
  {$i U_FormCopy.lrs}
end.


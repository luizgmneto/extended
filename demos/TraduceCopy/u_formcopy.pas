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
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure MaskChange(Sender: TObject);
    procedure FileCopySuccess(Sender: TObject; const ASource,
      ADestination: string; const Errors: Integer);
    procedure LanguageClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FaireundonClick(Sender: TObject);
    procedure AProposClick(Sender: TObject);
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

procedure TF_Copier.FormCreate(Sender: TObject);
begin
    ChargeLangue ( FLangue );

  Application.CreateForm ( tF_AboutBox, F_AboutBox );
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

procedure TF_Copier.ChargeLangue(const ALangue: String);
begin

end;

end.


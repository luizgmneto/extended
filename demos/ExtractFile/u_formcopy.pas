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
  U_ExtFileCopy, ExtCtrls, FileCtrl, StdCtrls, U_OnFormInfoIni,
  ExtJvXPCheckCtrls, ComCtrls, Menus, ExtJvXPButtons, Spin, U_DBListView,
  u_scrollclones, u_framework_components, u_traducefile, u_extabscopy,
  u_extractfile, U_FormMainIni, JvXPCore ;

type

  { TF_Extract }

  TF_Extract = class(TF_FormMainIni)
    bt_Extract: TJvXPButton;
    ds_Destination: TDatasource;
    EMiddleExtract: TEdit;
    EndExtract: TEdit;
    ExtClonedPanel: TExtClonedPanel;
    ExtractAFile: TExtractFile;
    FilesSeek: TExtFileCopy;
    FDestination: TFileNameEdit;
    ch_subdirs: TJvXPCheckbox;
    FWLabel1: TFWLabel;
    ColumnsExtract: TFWSpinEdit;
    JvXPCheckbox1: TJvXPCheckbox;
    ch_droite: TJvXPCheckbox;
    EndEnter: TJvXPCheckbox;
    Label3: TLabel;
    Label4: TLabel;
    OnFormInfoIni: TOnFormInfoIni;
    Panel5: TPanel;
    PanelCloned: TPanel;
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
    Splitter3: TSplitter;
    Panel4: TPanel;
    procedure bt_ExtractClick(Sender: TObject);
    procedure ColumnsExtractChange(Sender: TObject);
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
    li_j : Integer;
begin
  if not FileExists(FDestination.Text)
  and not DirectoryExists(FileListSource.Directory)
   Then
    Exit;

  if FileExists ( FDestination.Text ) Then
    DeleteFile(FDestination.Text);
  stl_file := TStringList.Create;
  with ExtractAFile,ExtClonedPanel,ColumnsExtract do
   Begin
    while Count > Rows do Delete(Count-1)
    else while Count < Rows do Add
    try
      for li_j := 0 to ColumnsExtract.Count-1 do
        stl_file.Add(ColumnsExtract [li_j].FieldName);
      stl_file.SaveToFile(FDestination.Text);
    finally
      stl_file.Free;
    end;
    if ch_subdirs.Checked then
      FilesSeek.FilesOptions := FilesSeek.FilesOptions + [cpCopyAll]
     else
      FilesSeek.FilesOptions := FilesSeek.FilesOptions - [cpCopyAll];
    for li_j := 1 to ExtClonedPanel.Rows do
      with ColumnsExtract [li_j] do
       Begin

       end;
    ExtractAFile.BeginExtract  :=  EBeginExtract.Text ;
    ExtractAFile.MiddleExtract := EMiddleExtract.Text ;
    ExtractAFile.EndExtract    :=    EEndExtract.Text ;
   end;
  Result.Lines.Clear;
  FilesSeek.Source := FileListSource.Directory ;
  SdfDestination.FileName := FDestination.Text ;
  FilesSeek.Mask   := Mask.Text ;
  FilesSeek.CopySourceToDestination;
  FileListSource.Directory := DirectorySource.Text;
  SdfDestination.Close;
end;

procedure TF_Extract.ColumnsExtractChange(Sender: TObject);
begin
  ExtClonedPanel.Rows:=ColumnsExtract.Value;
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


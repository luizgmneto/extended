unit u_netupdate;

{$IFDEF FPC}
{$mode Delphi}
{$ENDIF}

interface

uses
  Classes, SysUtils,
  {$IFDEF VERSIONS}
  fonctions_version,
  {$ENDIF}
  lNetComponents,
  lazutf8classes,
  Controls,
  IniFiles,
  Lnet, lhttp,
  ComCtrls;

{.$DEFINE MD5}

const
  INI_FILE_UPDATE = 'UPDATE';
  INI_FILE_UPDATE_SIZE = 'Size';
  INI_FILE_UPDATE_EXE_VERSION = 'VersionExe';
  INI_FILE_UPDATE_BASE_VERSION = 'VersionBase';
  INI_FILE_UPDATE_DATE = 'Date';
  INI_FILE_UPDATE_MD5 = 'md5';
  INI_FILE_UPDATE_FILE_NAME = 'FileName';

{$IFDEF VERSIONS}
  gVer_netupdate: T_Version = (Component: 'Composant TNetUpdate';
    FileUnit: 'U_NetUpdate';
    Owner: 'Matthieu Giroux';
    Comment: 'Net File Download.';
    BugsStory: '0.9.0.0 : Updating ok.';
    UnitType: 3;
    Major: 0; Minor: 9;
    Release: 0; Build: 1);


{$ENDIF}
type
  TUpdateStep = (usNone, usIni, usPage, usFile);
  TStateUpdate = (suNeedVerify, suNeedUpdate, suDownloading, suUpdated);
  TErrorMessageEvent = procedure(const Sender: TObject;
    const ErrorCode: integer; const ErrorMessage: string) of object;
  TProgressEvent = procedure(const Sender: TObject; const Uploaded: integer) of object;
  TMD5Event = procedure(const Sender: TObject; const MD5OK: Boolean) of object;
  TProgressInit = procedure(const Sender: TObject; const Total: integer) of object;
  TDownloadingEvent = procedure(const Sender: TObject; const Step: TUpdateStep) of object;
  TDownloadedEvent = procedure(const Sender: TObject;
    const TheFile: string; const TheStep: TUpdateStep) of object;

  { TNetUpdate }

  TNetUpdate = class(TComponent)
  private
    // Parent propriétaire des évènements liés au lien de données
    gs_VersionExeUpdate, gs_VersionBaseUpdate, gs_Date, gs_MD5,
    gs_URL, gs_File, gs_FilePage, gs_md5Update, gs_Ini,
    gs_UpdateDir: string;
    gsu_UpdateState: TStateUpdate;
    gus_UpdateStep: TUpdateStep;
    gfs_FicStream: TFileStreamUTF8;
    gs_Buffer: string;
    gpb_Progress: TProgressBar;
    glc_LNetComponent: TLComponent;
    ge_ErrorEvent: TErrorMessageEvent;
    ge_ProgressEvent: TProgressEvent;
    ge_Downloaded: TDownloadedEvent;
    ge_CreateIni: TNotifyEvent;
    ge_DownloadedPage, ge_DownloadedFile : TMD5Event;
    ge_Downloading : TDownloadingEvent;
    ge_IniRead: TProgressInit;
    gini_inifile: TIniFile;
    gi_Weight: longword;
    gb_Buffered,gb_Messages: boolean;
    procedure p_SetLNetComponent(const AValue: TLComponent);
    procedure SetUpdateDir ( const AValue : String );
  protected
    function HTTPClientInput(ASocket: TLHTTPClientSocket; ABuffer: PChar;
      ASize: integer): integer; virtual;
    procedure SetMD5; virtual;
    procedure GetURL(const as_URL, as_LocalDir, as_FileName: string;
      const aus_Step: TUpdateStep = usNone); virtual;
    function CanDownloadIni: boolean; virtual;
    function CanDownloadPage: boolean; virtual;
    function CanDownloadFile: boolean; virtual;
    procedure HTTPClientDoneInput(ASocket: TLHTTPClientSocket); virtual;
    procedure HTTPClientError(const msg: string; aSocket: TLSocket); virtual;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure OnError(const ai_error: integer; const as_Message: string); virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Loaded; override;
    procedure UpdateIniPage; virtual;
    procedure Update; virtual;
    procedure VerifyUpdate; virtual;
    procedure VerifyIni(const as_file: string); virtual;
    procedure AfterUpdate(const as_file: string;
      const ab_StatusOK: boolean); virtual;
    property IniFile: TIniFile read gini_inifile;
    property UpdateWeight: longword read gi_Weight default 0;
    property UpdateState: TStateUpdate read gsu_UpdateState default suNeedVerify;
    property UpdateStep: TUpdateStep read gus_UpdateStep default usNone;

    property MD5Update: string read gs_md5Update;
    property MD5File  : string read gs_MD5;
    property VersionExeUpdate: string read gs_VersionExeUpdate;
    property VersionBaseUpdate: string read gs_VersionBaseUpdate;
    property Buffer : String read gs_Buffer;
  published
    property FileIni: string read gs_Ini write gs_Ini;
    property FileUpdate: string read gs_File write gs_File;
    property FilePage: string read gs_FilePage write gs_FilePage;
    property UpdateDir: string read gs_UpdateDir write SetUpdateDir;
    property URLBase: string read gs_URL write gs_URL;
    property Progress: TProgressBar read gpb_Progress write gpb_Progress;
    property OnErrorMessage: TErrorMessageEvent read ge_ErrorEvent write ge_ErrorEvent;
    property OnIniCreate: TNotifyEvent read ge_CreateIni write ge_CreateIni;
    property OnIniRead: TProgressInit read ge_IniRead write ge_IniRead;
    property OnProgress: TProgressEvent read ge_ProgressEvent write ge_ProgressEvent;
    property OnPageDownloaded: TMD5Event read ge_DownloadedPage write ge_DownloadedPage;
    property OnDownloading: TDownloadingEvent read ge_Downloading write ge_Downloading;
    property OnFileDownloaded: TMD5Event read ge_DownloadedFile write ge_DownloadedFile;
    property LNetComponent: TLComponent read glc_LNetComponent write p_SetLNetComponent;
    property Buffered: boolean read gb_Buffered write gb_Buffered default False;
    property Messages: boolean read gb_Messages write gb_Messages default True;
  end;

var
  gb_IsUpdating: boolean = False;

implementation

uses fonctions_string,
  {$IFDEF FPC}
  unite_messages,
  {$ELSE}
  unite_messages_delphi,
  {$ENDIF}
  fonctions_dialogs,
  lHTTPUtil,
  {$IFDEF MD5}
  md5api,
  {$ENDIF}
  Dialogs,
  FileUtil,
  Forms;


{ TNetUpdate }

constructor TNetUpdate.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  gpb_Progress := nil;
  glc_LNetComponent := nil;
  ge_Downloaded := nil;
  ge_Downloading := nil;
  ge_DownloadedPage := nil;
  ge_DownloadedFile := nil;
  ge_ErrorEvent := nil;
  ge_ProgressEvent := nil;
  ge_IniRead := nil;
  gfs_FicStream := nil;
  gini_inifile := nil;
  gi_Weight := 0;
  gsu_UpdateState := suNeedVerify;
  gus_UpdateStep := usNone;
  gb_Buffered := False;
  gb_Messages := True;
end;

destructor TNetUpdate.Destroy;
begin
  if (gs_UpdateDir > '') and (gs_FilePage > '') and
    FileExistsUTF8(gs_UpdateDir + gs_FilePage) then
    DeleteFileUTF8(gs_UpdateDir + gs_FilePage);

  inherited Destroy;
end;

procedure TNetUpdate.Loaded;
begin
  inherited Loaded;
end;

procedure TNetUpdate.SetMD5;
begin
  {$IFDEF MD5}
  if gb_Buffered and ( gs_Buffer > '' ) Then
    Begin
      gs_md5Update := MD5DataFromString(gs_Buffer);
    End
  else if not gb_Buffered and FileExistsUTF8(gs_UpdateDir + gs_File) then
  begin
    // Matthieu : comparing files
    gs_md5Update := MD5DataFromFile(gs_UpdateDir + gs_File);
  end
  else
  {$ENDIF}
    gs_md5Update := '';

end;

function TNetUpdate.HTTPClientInput(ASocket: TLHTTPClientSocket;
  ABuffer: PChar; ASize: integer): integer;
var
  OldLength: integer;
begin
  if ASize <= 0 then
    Exit;
  try
    if gb_Buffered then
    begin
      oldLength := Length(gs_Buffer);
      setlength(gs_Buffer, oldLength + ASize);
      move(ABuffer^, gs_Buffer[oldLength + 1], ASize);
    end
    else
      gfs_FicStream.WriteBuffer(ABuffer^, ASize);
    Result := aSize; // tell the http buffer we read it all
    if gpb_Progress <> nil then
    with gpb_Progress do
    begin
      Position := Position + ASize;
      Application.ProcessMessages;
    end;
    if Assigned(ge_ProgressEvent) then
      ge_ProgressEvent(Self, Asize);

  except
    on e: Exception do
    begin
      if Assigned(ge_ErrorEvent) then
        if gb_Buffered then
          ge_ErrorEvent(Self, 1, e.Message)
        else
          ge_ErrorEvent(Self, 1, fs_RemplaceMsg(GS_ECRITURE_IMPOSSIBLE, [gfs_FicStream.Filename]));
      Abort;
    end;
  end;

end;

procedure TNetUpdate.HTTPClientDoneInput(ASocket: TLHTTPClientSocket);
var
  ls_File: string;
  gb_ok : Boolean ;
begin
  gb_IsUpdating := False;
  gb_ok := (LNetComponent as TLHTTPClient).Response.Status = hsOK;
  ASocket.Disconnect;
  Screen.Cursor := crDefault;
  if not gb_Buffered Then
   Begin
    ls_File := gfs_FicStream.FileName;
    FreeAndNil(gfs_FicStream);
    if not FileExistsUTF8(ls_File)
    and gb_Messages  Then
      Begin
       MyMessageDlg(gs_Error_Cannot_load_not_downloaded_file,mtError, [mbOk],0,nil);
       Exit;
      end;
   end;
  AfterUpdate(ls_File, gb_ok );
end;

procedure TNetUpdate.HTTPClientError(const msg: string; aSocket: TLSocket);
var
  sMessage: string;
  iError: integer;
begin
  gb_IsUpdating := False;
  Screen.Cursor := crDefault;
  FreeAndNil(gfs_FicStream);
  iError := 0;
  if LNetComponent is TLHTTPClientComponent then
    with LNetComponent as TLHTTPClientComponent do
      case Response.Status of
        hsForbidden, hsNotAllowed, hsNotFound:
        begin
          sMessage := gs_Error_Forbidden_Access;
          iError := 403;
        end;
        hsBadRequest:
        begin
          iError := 400;
          smessage := gs_Error_Bad_request;
        end;
        hsMovedPermanently:
        begin
          sMessage := gs_Error_File_is_not_on_the_web_site;
          iError := 301;
        end;
        hsRequestTooLong:
        begin
          sMessage := gs_Error_timeout_problem;
          iError := 408;
        end;
        hsPreconditionFailed:
        begin
          iError := 502;
          sMessage := gs_Error_Bad_Gateway;
        end
        else
        begin
          sMessage := gs_Error_Bad_Web_Connection;
          iError := 4491;
        end;
      end;
  sMessage := msg + CST_ENDOFLINE + sMessage;
  OnError(iError, sMessage);
end;

procedure TNetUpdate.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation <> opRemove) or (csDestroying in ComponentState) then
    Exit;

  // Suppression d'un composant lnet
  if Assigned(LNetComponent) and (AComponent = LNetComponent) then
    LNetComponent := nil;
  // Suppression d'un composant de progression
  if Assigned(Progress) and (AComponent = Progress) then
    Progress := nil;
end;


procedure TNetUpdate.UpdateIniPage;
begin
  if CanDownloadIni then
    GetURL(gs_URL, gs_UpdateDir, gs_Ini, usIni)
  else if CanDownloadPage then
    GetURL(gs_URL, gs_UpdateDir, gs_FilePage, usPage);
end;

procedure TNetUpdate.Update;
begin
  SetMD5;
  if CanDownloadFile then
    if ( gs_MD5 > '' ) and ( gs_MD5 = gs_md5Update ) Then
      Begin
       if Assigned(ge_DownloadedFile) Then
         ge_DownloadedFile ( Self, True );
      end
     Else
      GetURL(gs_URL, gs_UpdateDir, gs_File, usFile);
end;

function TNetUpdate.CanDownloadFile: boolean;
begin
  if (gs_File = '') or (gs_URL = '') or (gs_UpdateDir = '') then
    Result := False
  else
    Result := True;
end;

function TNetUpdate.CanDownloadIni: boolean;
begin
  if (gs_Ini = '') or (gs_URL = '') or (gs_UpdateDir = '') then
    Result := False
  else
    Result := True;
end;

function TNetUpdate.CanDownloadPage: boolean;
begin
  if (gs_FilePage = '') or (gs_URL = '') or (gs_UpdateDir = '') then
    Result := False
  else
    Result := True;
end;

procedure TNetUpdate.p_SetLNetComponent(const AValue: TLComponent);
begin
  glc_LNetComponent := AValue;
  if Assigned(glc_LNetComponent) and (glc_LNetComponent is TLHTTPClientComponent) then
    with glc_LNetComponent as TLHTTPClientComponent do
    begin
      OnDoneInput := HTTPClientDoneInput;
      OnInput     := HTTPClientInput;
      OnError     := HTTPClientError;
    end;
end;

procedure TNetUpdate.SetUpdateDir(const AValue: String);
begin
  gs_UpdateDir:=AValue;
  if gs_UpdateDir>'' Then
    gs_UpdateDir:=IncludeTrailingPathDelimiter(gs_UpdateDir);
end;

procedure TNetUpdate.GetURL(const as_URL, as_LocalDir, as_FileName: string;
  const aus_Step: TUpdateStep = usNone);
var
  aHost, aURI: string;
  aPort: word;
begin
  if not DirectoryExistsUTF8(gs_UpdateDir) then
   Begin
    ForceDirectoriesUTF8(gs_UpdateDir);
    if not DirectoryExistsUTF8(gs_UpdateDir)
    and gb_Messages Then
      Begin
        MyMessageDlg( fs_RemplaceMsg(gs_Error_Cannot_Write_on,[gs_UpdateDir]),mtError,[mbOK],0,nil);
        Exit;
      end;

   end;

  gus_UpdateStep := aus_Step;
  IncludeTrailingPathDelimiter(as_LocalDir);
  if gpb_Progress <> nil then
    gpb_Progress.Position := 0;
  DecomposeURL(as_URL + as_FileName, aHost, aURI, aPort);
  if LNetComponent is TLHTTPClientComponent then
    with LNetComponent as TLHTTPClientComponent do
    begin
      Screen.Cursor:=crHourGlass;
      Host := aHost;
      URI := aURI;
      Port := aPort;
  {  if Connect // does not work but should be better
     Then
      Begin
       Disconnect;}
      if gb_Buffered then
        gs_Buffer := ''
      else
      begin
        gfs_FicStream.Free;
        if FileExistsUTF8(as_LocalDir + as_FileName) then
          DeleteFileUTF8(as_LocalDir + as_FileName);
        gfs_FicStream := TFileStreamUTF8.Create(as_LocalDir + as_FileName, fmCreate);
        if Assigned(ge_Downloading) Then
          ge_Downloading ( Self, aus_Step );
      end;
      SendRequest;
    end;
end;


procedure TNetUpdate.VerifyUpdate;
var
  ls_filePath, ls_urlfile: string;
begin
  if not CanDownloadFile then
    Exit;
  if not gb_Buffered Then
    Begin
      ls_filePath := IncludeTrailingPathDelimiter(gs_UpdateDir) + gs_File;
      if FileExistsUTF8(ls_filePath) then
        if MyMessageDlg(GS_ConfirmCaption,
          gs_Confirm_File_is_unavailable_Do_i_erase_it_to_update_it, mtConfirmation, mbYesNo, 0) =
          mrNo then
          Exit
        else
          DeleteFileUTF8(ls_filePath);

    end;
  gb_IsUpdating := True;
  ls_urlfile := gs_URL + gs_File;
  doOpenWorking(gs_Please_Wait + CST_ENDOFLINE + fs_RemplaceMsg(
    gs_Downloading_in_progress, [ls_urlfile]));
  GetURL(gs_URL, gs_UpdateDir, gs_File);
end;

procedure TNetUpdate.VerifyIni(const as_file: string);
var
  ls_File : String;
begin
  gini_inifile := TIniFile.Create(as_file);

  if gini_inifile.SectionExists(INI_FILE_UPDATE) then
    try
      if Assigned(ge_CreateIni) then
        ge_CreateIni(Self);
      gi_Weight := gini_inifile.ReadInteger(INI_FILE_UPDATE, INI_FILE_UPDATE_SIZE, 1000000); // 0 is impossible
      gs_VersionExeUpdate := gini_inifile.ReadString(
        INI_FILE_UPDATE, INI_FILE_UPDATE_EXE_VERSION, '0');
      gs_Date := gini_inifile.ReadString(INI_FILE_UPDATE, INI_FILE_UPDATE_DATE, '0');
      gs_VersionBaseUpdate := gini_inifile.ReadString(INI_FILE_UPDATE,
        INI_FILE_UPDATE_BASE_VERSION, '0');
      gs_MD5 := gini_inifile.ReadString(INI_FILE_UPDATE, INI_FILE_UPDATE_MD5, '0');
      ls_File:= gini_inifile.ReadString(INI_FILE_UPDATE, INI_FILE_UPDATE_FILE_NAME, '');
      if ls_File > '' Then
        gs_File:=ls_File;

      if Assigned(gpb_Progress) then
        gpb_Progress.Max := gi_Weight;

      DeleteFileUTF8(gs_UpdateDir + gs_Ini);

      if Assigned(ge_IniRead) then
        ge_IniRead(Self,gi_Weight);

    finally
      FreeAndNil(gini_inifile);
    end;
  if FilePage > '' then
    GetURL(gs_URL, gs_UpdateDir, gs_FilePage, usPage);
end;

procedure TNetUpdate.AfterUpdate(const as_file: string;
  const ab_StatusOK: boolean);
var gb_MD5OK : Boolean;
begin
  Screen.Cursor:=crDefault;
  if Assigned(ge_Downloaded) then
    ge_Downloaded(Self, as_file, gus_UpdateStep);
  if (FileSize(as_file) > 0) and ab_StatusOK then
    case gus_UpdateStep of
      usIni: VerifyIni(as_file);
      usFile,usPage:
        Begin
          SetMD5;
          gb_MD5OK := gs_MD5 = gs_md5Update;
          if not gb_MD5OK and FileExistsUTF8(gs_UpdateDir+gs_File) Then
            DeleteFileUTF8(gs_UpdateDir+gs_File);
          if gus_UpdateStep = usPage Then
           Begin
             if assigned ( ge_DownloadedPage )
              Then ge_DownloadedPage ( Self, gb_MD5OK );
           End
          else
            if assigned ( ge_DownloadedFile )
              Then ge_DownloadedFile ( Self, gb_MD5OK );
        End;
    end;
end;

procedure TNetUpdate.OnError(const ai_error: integer; const as_Message: string);
begin
  if Assigned(ge_ErrorEvent) then
    ge_ErrorEvent(Self, ai_error, as_Message);
end;

{$IFDEF VERSIONS}
initialization
  p_ConcatVersion(gVer_netupdate);
{$ENDIF}
end.

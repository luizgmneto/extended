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

const INI_FILE_UPDATE = 'UPDATE';
      INI_FILE_UPDATE_WEIGHT = 'Weight';
      INI_FILE_UPDATE_EXE_VERSION  = 'VersionExe';
      INI_FILE_UPDATE_BASE_VERSION = 'VersionBase';
      INI_FILE_UPDATE_DATE         = 'Date';
      INI_FILE_UPDATE_MD5          = 'md5';
      INI_FILE_UPDATE_FILE_NAME    = 'FileName';

{$IFDEF VERSIONS}
    gVer_netupdate : T_Version = ( Component : 'Composant TNetUpdate' ;
                                               FileUnit : 'U_NetUpdate' ;
                                               Owner : 'Matthieu Giroux' ;
                                               Comment : 'Net File Download.' ;
                                               BugsStory : '0.9.0.0 : Updating ok.' ;
                                               UnitType : 3 ;
                                               Major : 0 ; Minor : 9 ; Release : 0 ; Build : 1 );


{$ENDIF}
type
  TUpdateStep = ( usNone, usIni, usPage, usFile );
  TStateUpdate = ( suNeedVerify, suNeedUpdate, suDownloading, suUpdated );
  TErrorMessageEvent = procedure(const Sender: TObject;const ErrorCode: integer; const ErrorMessage : String) of object;
  TProgressEvent = procedure(const Sender: TObject;const Progress: integer) of object;
  TProgressInit = procedure(const Sender: TObject;const Total: integer) of object;
  TDownloadedEvent = procedure(const Sender: TObject;const TheFile: String; const TheStep : TUpdateStep) of object;

  { TNetUpdate }

  TNetUpdate = Class(TComponent)
   Private
    // Parent propriétaire des évènements liés au lien de données
    gs_VersionExeUpdate,
    gs_VersionBaseUpdate,
    gs_Date,
    gs_MD5,
    gs_URL,
    gs_File,
    gs_FilePage,
    md5Update,
    gs_Ini,
    gs_UpdateDir : String;
    gsu_UpdateState : TStateUpdate;
    gus_UpdateStep : TUpdateStep;
    gfs_FicStream : TFileStreamUTF8;
    gms_Buffer    : String;
    gpb_Progress : TProgressBar;
    glc_LNetComponent : TLComponent;
    ge_ErrorEvent   : TErrorMessageEvent;
    ge_ProgressIni  : TProgressInit;
    ge_Downloaded   : TDownloadedEvent;
    ge_DownloadPage,
    ge_CreateIni,
    ge_IniRead : TNotifyEvent;
    ge_ProgressEvent : TProgressEvent;
    gini_inifile: TIniFile;
    gi_Weight : LongWord;
    gb_Buffered : Boolean;
    procedure p_SetLNetComponent ( const AValue : TLComponent );
   Protected
    procedure GetURL(const as_URL, as_LocalDir, as_FileName: String; const aus_Step : TUpdateStep = usNone ); virtual;
    function  CanDownloadIni : Boolean; virtual;
    function  CanDownloadPage: Boolean; virtual;
    function  CanDownloadFile: Boolean; virtual;
    procedure HTTPClientDoneInput(ASocket: TLHTTPClientSocket); virtual;
    procedure HTTPClientError(const msg: string; aSocket: TLSocket); virtual;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure OnError ( const ai_error : integer ; const as_Message : String ); virtual;
   Public
    Constructor Create( AOwner : TComponent ); override;
    destructor  Destroy; override;
    procedure Loaded; override;
    procedure UpdateIniPage; virtual;
    procedure UpdateFile; virtual;
    procedure VerifyUpdate; virtual;
    procedure VerifyIni( const as_file : String ); virtual;
    procedure AfterUpdate ( const as_file : String ; const ab_StatusOK : Boolean ); virtual;
    property  IniFile  : TIniFile read gini_inifile ;
    property  UpdateWeight  : LongWord read gi_Weight default 0 ;
    property  UpdateState  : TStateUpdate read gsu_UpdateState default suNeedVerify ;
    property  UpdateStep   : TUpdateStep  read gus_UpdateStep  default usNone ;

    property  VersionExeUpdate  : String read gs_VersionExeUpdate ;
    property  VersionBaseUpdate  : String read gs_VersionBaseUpdate ;
   published
    property FileIni  : String read gs_Ini write gs_Ini ;
    property FileUpdate  : String read gs_File write gs_File ;
    property FilePage  : String read gs_FilePage write gs_FilePage ;
    property UpdateDir : String read gs_UpdateDir write gs_UpdateDir ;
    property URLBase : String read gs_URL write gs_URL ;
    property Progress : TProgressBar read gpb_Progress write gpb_Progress;
    property OnErrorMessage : TErrorMessageEvent read ge_ErrorEvent write ge_ErrorEvent;
    property OnProgress : TProgressEvent read ge_ProgressEvent write ge_ProgressEvent;
    property OnProgressInit : TProgressInit read ge_ProgressIni write ge_ProgressIni;
    property OnIniCreate : TNotifyEvent read ge_CreateIni write ge_CreateIni;
    property OnIniRead  : TNotifyEvent read ge_IniRead write ge_IniRead;
    property OnPageDownloaded  : TNotifyEvent read ge_DownloadPage write ge_DownloadPage;
    property LNetComponent : TLComponent read glc_LNetComponent write p_SetLNetComponent;
    property Buffered : Boolean read gb_Buffered write gb_Buffered default False;
   End;

var gb_IsUpdating : Boolean = False;

implementation

uses fonctions_string,
  {$IFDEF FPC}
  unite_messages,
  {$ELSE}
  unite_messages_delphi,
  {$ENDIF}
  fonctions_dialogs,
  fonctions_net,
  lHTTPUtil,
  md5api,
  Dialogs,
  FileUtil,
  Forms;


{ TNetUpdate }

constructor TNetUpdate.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  gpb_Progress      := nil;
  glc_LNetComponent := nil;
  ge_Downloaded     := nil;
  ge_DownloadPage   := nil;
  ge_ErrorEvent     := nil;
  ge_ProgressIni    := nil;
  ge_IniRead        := nil;
  ge_ProgressEvent  := nil;
  gfs_FicStream     := nil;
  gini_inifile          := nil;
  gi_Weight         := 0;
  gsu_UpdateState:=suNeedVerify;
  gus_UpdateStep := usNone;
  gb_Buffered := False;
end;

destructor TNetUpdate.Destroy;
begin
  if  ( gs_UpdateDir > '' )
  and ( gs_FilePage  > '' )
  and FileExistsUTF8(gs_UpdateDir+gs_FilePage) Then
   DeleteFileUTF8(gs_UpdateDir+gs_FilePage);

  inherited Destroy;
end;

procedure TNetUpdate.Loaded;
begin
  inherited Loaded;
  IncludeTrailingPathDelimiter(gs_UpdateDir);
  if FileExistsUTF8(gs_UpdateDir+gs_File) { *Converted from FileExistsUTF8*  } then
  begin
    // Matthieu : comparing files
    md5Update:=MD5DataFromFile(gs_UpdateDir+gs_File);
  end
  else
  begin
    md5Update:='';
  end;
end;

procedure TNetUpdate.HTTPClientDoneInput(ASocket: TLHTTPClientSocket);
var ls_File : String ;
begin
  gb_IsUpdating:=False;
  Screen.Cursor:=crDefault;
  ls_File := gfs_FicStream.FileName;
  FreeAndNil(gfs_FicStream);
  ASocket.Disconnect;
  AfterUpdate (ls_File,(LNetComponent as TLHTTPClient ).Response.Status=hsOK);
end;

procedure TNetUpdate.HTTPClientError(const msg: string; aSocket: TLSocket);
var sMessage : String;
    iError   : Integer;
begin
  gb_IsUpdating:=False;
  Screen.Cursor:=crDefault;
  FreeAndNil(gfs_FicStream);
  iError := 0;
  if   LNetComponent is TLHTTPClientComponent Then
  with LNetComponent as TLHTTPClientComponent do
  case Response.Status of
    hsForbidden,hsNotAllowed,hsNotFound :
      Begin
        sMessage:=gs_Error_Forbidden_Access;
        iError:=403;
      end;
    hsBadRequest:
     Begin
      iError:=400;
      smessage:=gs_Error_Bad_request;
     end;
    hsMovedPermanently:
     Begin
      sMessage:=gs_Error_File_is_not_on_the_web_site;
      iError:=301;
     end;
    hsRequestTooLong:
     Begin
      sMessage:=gs_Error_timeout_problem;
      iError:=408;
     end;
    hsPreconditionFailed:
     Begin
      iError:=502;
      sMessage:=gs_Error_Bad_Gateway;
     end
    else
      Begin
        sMessage:=gs_Error_Bad_Web_Connection;
        iError:=4491;
      end;
  end;
  sMessage:=msg+CST_ENDOFLINE+sMessage;
  OnError(iError,sMessage);
end;

procedure TNetUpdate.Notification(AComponent: TComponent; Operation: TOperation
  );
begin
  inherited Notification(AComponent, Operation);
  if ( Operation <> opRemove )
  or ( csDestroying in ComponentState ) Then
    Exit;

  // Suppression d'un composant lnet
  if    Assigned   ( LNetComponent )
  and ( AComponent = LNetComponent )
   then
    LNetComponent := nil;
  // Suppression d'un composant de progression
  if    Assigned   ( Progress )
  and ( AComponent = Progress )
   then
    Progress := nil;
end;


procedure TNetUpdate.UpdateIniPage;
begin
  if CanDownloadIni
  Then GetURL(gs_URL,gs_UpdateDir,gs_Ini,usIni)
  else if CanDownloadPage
  Then GetURL(gs_URL,gs_UpdateDir,gs_FilePage,usPage);
end;

procedure TNetUpdate.UpdateFile;
begin
  if CanDownloadFile Then
    GetURL(gs_URL,gs_UpdateDir,gs_File,usFile);
end;

function TNetUpdate.CanDownloadFile: Boolean;
begin
  if ( gs_File = '' )
  or ( gs_URL  = '' )
  or ( gs_UpdateDir = '' )
   Then Result:=False
   Else Result:=True;
End;

function TNetUpdate.CanDownloadIni: Boolean;
begin
  if ( gs_Ini  = '' )
  or ( gs_URL  = '' )
  or ( gs_UpdateDir = '' )
   Then Result:=False
   Else Result:=True;
End;

function TNetUpdate.CanDownloadPage: Boolean;
begin
  if ( gs_FilePage  = '' )
  or ( gs_URL  = '' )
  or ( gs_UpdateDir = '' )
   Then Result:=False
   Else Result:=True;
End;

procedure TNetUpdate.p_SetLNetComponent(const AValue: TLComponent);
begin
  glc_LNetComponent:=AValue;
  if Assigned(glc_LNetComponent)
  and ( glc_LNetComponent is TLHTTPClientComponent ) Then
  with glc_LNetComponent as TLHTTPClientComponent do
   Begin
     OnDoneInput:=HTTPClientDoneInput;
     OnError    :=HTTPClientError;
//     OnInput    :=;
   end;
end;

procedure TNetUpdate.GetURL ( const as_URL, as_LocalDir, as_FileName : String; const aus_Step : TUpdateStep = usNone );
var
  aHost, aURI: string;
  aPort: Word;
Begin
  gus_UpdateStep:=aus_Step;
  IncludeTrailingPathDelimiter(as_LocalDir);
  if gpb_Progress <> nil Then
    gpb_Progress.Position := 0;
  DecomposeURL(as_URL+as_FileName, aHost, aURI, aPort);
  if   LNetComponent is TLHTTPClientComponent Then
  with LNetComponent as TLHTTPClientComponent do
   Begin
    Host := aHost;
    URI  := aURI;
    Port := aPort;
  {  if Connect // does not work but should be better
     Then
      Begin
       Disconnect;}
     if gb_Buffered
     Then gms_Buffer:=''
     Else
      Begin
       gfs_FicStream.Free;
       if FileExistsUTF8(as_LocalDir+as_FileName) Then
         DeleteFileUTF8(as_LocalDir+as_FileName);
       gfs_FicStream:=TFileStreamUTF8.Create(as_LocalDir+ as_FileName,fmCreate);
      end;
     SendRequest;
   end;
end;


procedure TNetUpdate.VerifyUpdate;
var ls_filePath, ls_urlfile : String;
begin
  if not CanDownloadFile
    Then Exit;
  ls_filePath := IncludeTrailingPathDelimiter(gs_UpdateDir)+gs_File;
  if FileExistsUTF8(ls_filePath) Then
    if MyMessageDlg(GS_ConfirmCaption,gs_Confirm_File_is_unavailable_Do_i_erase_it_to_update_it,mtConfirmation,mbYesNo,0) =mrNo
     Then Exit
     Else DeleteFileUTF8(ls_filePath);
  Begin
    gb_IsUpdating:=True;
    ls_urlfile := gs_URL+gs_File;
    doOpenWorking(gs_Please_Wait+CST_ENDOFLINE+fs_RemplaceMsg(gs_Downloading_in_progress,[ls_urlfile]));
    GetURL(gs_URL,gs_UpdateDir,gs_File);
  end;
end;

procedure TNetUpdate.VerifyIni( const as_file : String );
var iBaseSite : Int64;
    iExeSite  : Int64;
begin
  gini_inifile:=TIniFile.Create(as_file);

  if gini_inifile.SectionExists(INI_FILE_UPDATE) then
  try
    if Assigned(ge_CreateIni) Then ge_CreateIni ( Self );
    gi_Weight:=gini_inifile.ReadInteger(INI_FILE_UPDATE,INI_FILE_UPDATE_WEIGHT,0);
    gs_VersionExeUpdate:=gini_inifile.ReadString(INI_FILE_UPDATE,INI_FILE_UPDATE_EXE_VERSION,'0');
    gs_Date :=gini_inifile.ReadString(INI_FILE_UPDATE,INI_FILE_UPDATE_DATE,'0');
    gs_VersionBaseUpdate:=gini_inifile.ReadString(INI_FILE_UPDATE,INI_FILE_UPDATE_BASE_VERSION,'0');
    gs_MD5:=gini_inifile.ReadString(INI_FILE_UPDATE,INI_FILE_UPDATE_MD5,'0');

    iBaseSite:=fi_BaseVersionToInt (gs_VersionBaseUpdate);
    iExeSite :=fi64_VersionExeInt64(gs_VersionExeUpdate);
    if Assigned(gpb_Progress) Then
     gpb_Progress.Max:=gi_Weight;

    DeleteFileUTF8(gs_UpdateDir+gs_Ini); { *Converted from DeleteFileUTF8*  }

    if Assigned(ge_IniRead) Then ge_IniRead ( Self );

  finally
    FreeAndNil(gini_inifile);
  end;
  if FilePage > '' Then
   GetURL(gs_URL,gs_UpdateDir,gs_FilePage);
end;

procedure TNetUpdate.AfterUpdate ( const as_file : String ; const ab_StatusOK : Boolean );
begin
  if Assigned(ge_Downloaded) then
    ge_Downloaded ( Self, as_file, gus_UpdateStep );
  if (FileSize(as_file)>0)
  and ab_StatusOK then
    case gus_UpdateStep of
      usIni : VerifyIni(as_file);
    end;
end;

procedure TNetUpdate.OnError ( const ai_error : integer ; const as_Message : String );
begin
  if Assigned(ge_ErrorEvent)
   Then ge_ErrorEvent ( Self , ai_error, as_Message );
end;

{$IFDEF VERSIONS}
initialization
  p_ConcatVersion ( gVer_netupdate  );
{$ENDIF}
end.


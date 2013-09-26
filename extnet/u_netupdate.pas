unit u_netupdate;

{$mode objfpc}{$H+}

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

{$IFDEF VERSIONS}
const
    gVer_netupdate : T_Version = ( Component : 'Composant TNetUpdate' ;
                                               FileUnit : 'U_NetUpdate' ;
                                               Owner : 'Matthieu Giroux' ;
                                               Comment : 'Net File Download.' ;
                                               BugsStory : '0.9.0.0 : Updating ok.' ;
                                               UnitType : 3 ;
                                               Major : 0 ; Minor : 9 ; Release : 0 ; Build : 1 );


{$ENDIF}
type
  TErrorMessageEvent = procedure(const Sender: TObject;const ErrorCode: integer; const ErrorMessage : String) of object;
  TProgressEvent = procedure(const Sender: TObject;const Progress: integer) of object;
  TProgressInit = procedure(const Sender: TObject;const Total: integer) of object;


  { TNetUpdate }

  TNetUpdate = Class(TComponent)
   Private
    // Parent propriétaire des évènements liés au lien de données
    gs_URL, gs_File, gs_Ini, gs_UpdateDir : String;
    gfs_FicStream : TFileStreamUTF8;
    gms_Buffer    : String;
    gpb_Progress : TProgressBar;
    glc_LNetComponent : TLComponent;
    ge_ErrorEvent   : TErrorMessageEvent;
    ge_ProgressInit : TProgressInit;
    ge_ProgressEvent : TProgressEvent;
   Protected
    procedure GetURL(const URL, LocalFileName: String); virtual;
    procedure GetURLInBuffer(const URL: String); virtual;
    function VerifyLinks: Boolean; virtual;
    procedure HTTPClientDoneInput(ASocket: TLHTTPClientSocket); virtual;
    procedure HTTPClientError(const msg: string; aSocket: TLSocket); virtual;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure OnError ( const ai_error : integer ; const as_Message : String ); virtual;
   Public
    Constructor Create( AOwner : TComponent ); override;
    procedure Update; virtual;
    procedure VerifyUpdate; virtual;
    procedure UpdateIni ( const as_MyVersion : String ); virtual;
    procedure VerifyIni; virtual;
    procedure AfterUpdate; virtual;
   published
    property FileIni  : String read gs_Ini write gs_Ini ;
    property FileUpdate  : String read gs_File write gs_File ;
    property UpdateDir : String read gs_UpdateDir write gs_UpdateDir ;
    property URLBase : String read gs_URL write gs_URL ;
    property Progress : TProgressBar read gpb_Progress write gpb_Progress;
    property OnErrorMessage : TErrorMessageEvent read ge_ErrorEvent write ge_ErrorEvent;
    property OnProgress : TProgressEvent read ge_ProgressEvent write ge_ProgressEvent;
    property OnProgressInit : TProgressInit read ge_ProgressInit write ge_ProgressInit;

    property LNetComponent : TLComponent read glc_LNetComponent write glc_LNetComponent;
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
  lHTTPUtil,
  Dialogs,
  FileUtil,
  Forms;

{ TNetUpdate }

constructor TNetUpdate.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  gpb_Progress      := nil;
  glc_LNetComponent := nil;
  ge_ErrorEvent     := nil;
  ge_ProgressInit   := nil;
  ge_ProgressEvent  := nil;
  gfs_FicStream     := nil;
end;

procedure TNetUpdate.HTTPClientDoneInput(ASocket: TLHTTPClientSocket);
begin
  gb_IsUpdating:=False;
  Screen.Cursor:=crDefault;
  FreeAndNil(gfs_FicStream);
  ASocket.Disconnect;
  AfterUpdate;
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


procedure TNetUpdate.Update;
begin

end;

function TNetUpdate.VerifyLinks: Boolean;
begin
  if ( gs_File = '' )
  or ( gs_URL  = '' )
  or ( gs_UpdateDir = '' )
   Then Result:=False
   Else Result:=True;
End;

procedure TNetUpdate.GetURL ( const URL, LocalFileName : String );
var
  aHost, aURI: string;
  aPort: Word;
Begin
  if Progress <> nil Then
    Progress.Position := 0;
  DecomposeURL(URL, aHost, aURI, aPort);
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
     gfs_FicStream.Free;
     gfs_FicStream:=TFileStreamUTF8.Create(LocalFileName,fmCreate);
     SendRequest;
   end;
end;

procedure TNetUpdate.GetURLInBuffer(const URL : String);
var
  aHost, aURI: string;
  aPort: Word;
Begin
  gms_Buffer:='';
  if Progress <> nil Then
    Progress.Position := 0;
  DecomposeURL(URL, aHost, aURI, aPort);
  with LNetComponent do
   Begin
    Host := aHost;
    URI  := aURI;
    Port := aPort;
    SendRequest;
   end;
End;


procedure TNetUpdate.VerifyUpdate;
var ls_filePath, ls_urlfile : String;
begin
  if not VerifyLinks
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
    GetURL(ls_urlfile,ls_filePath);
  end;
end;

procedure TNetUpdate.UpdateIni(const as_MyVersion: String);
begin

end;

procedure TNetUpdate.VerifyIni;
var Linifile: TIniFile;
begin
  LIniFile:=TIniFile.Create(sPath+IniFilename+ExtensionIni);

  if LIniFile.SectionExists('UPDATE') then
  try
    lRun.Visible:=False;
    dm.sTaille:=LIniFile.ReadString('UPDATE','TailleMAJC','0');
    sVersionExe:=LIniFile.ReadString('UPDATE','VersionExe','0');
    sDate:='du : '+LIniFile.ReadString('UPDATE','Date','0');
    sVersionBase:=LIniFile.ReadString('UPDATE','VersionBase','0');
    md5Site:=LIniFile.ReadString('UPDATE','md5','0');

    iBaseSite:=fi_BaseVersionToInt (sVersionBase);
    iExeSite :=fi64_VersionExeInt64(sVersionExe);
    lSite.Caption:=fs_RemplaceMsg(rs_Caption_Exe_database,[sVersionExe,sVersionBase]);
    lTailleDistant.Caption:=FormatFloat('#,',StrToInt(dm.staille))+' '+rs_bytes;
    lTaille.Caption:=lTailleDistant.Caption;
    lReste.Caption:=lTailleDistant.Caption;
    lDate.Caption:=sDate;
    Gauge.MaxValue:=StrToInt(dm.sTaille);

    DeleteFileUTF8(sPath+IniFilename+ExtensionIni); { *Converted from DeleteFileUTF8*  }

    if iExeSite>iExeEnCours then
    begin
      MyMessageDlg(rs_Ancestromania_must_be_updated+_CRLF+_CRLF+
        rs_It_is_preferable_to_download_and_install_this_update,mtWarning, [mbOK],0,self);
      bOK:=True;
    end
    else if iBaseSite>iBaseEnCours then
    begin
      MyMessageDlg(fs_RemplaceMsg(rs_Ancestromania_is_not_fully_updated,[sVersionBase]),mtWarning, [mbOK],0,self);
      bOK:=True;
    end
    else
    begin
      MyMessageDlg(rs_Ancestromania_is_fully_updated,mtInformation, [mbOK],0,self);
      bExeEtBaseAjour:=true;
    end;

  finally
    FreeAndNil(LIniFile);
  end;
  DoNext:=TProcedureOfObject(p_AfterDownloadHtml);

  dm.p_GetURL ( dm.GetUrlInfosMaj,sPath+WebPage );
end;

procedure TNetUpdate.AfterUpdate;
begin

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


unit u_formdownload;

{$IFDEF FPC}
{$mode Delphi}
{$ENDIF}


interface

uses
  {$IFDEF FPC}
  lNetComponents,FileUtil, ExtJvXPButtons,
  {$ELSE}
  IdHttp, IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient, JvExControls, JvXPButtons,
  {$ENDIF}
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls, StdCtrls,
  ExtCtrls, u_netupdate, u_buttons_appli, u_buttons_defs, U_OnFormInfoIni;

type

  { TF_Update }

  TF_Update = class(TForm)
    Ed_extension: TEdit;
    Ed_url: TEdit;
    Ed_from: TEdit;
    Ed_to: TEdit;
    FWDownload: TFWRefresh;
    FWOpen: TFWFolder;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
{$IFDEF FPC}
    LHTTPClient: TLHTTPClientComponent;
{$ELSE}
    IdHttp : TIdHttp;
{$ENDIF}
    NetUpdate: TNetUpdate;
    OnFormInfoIni1: TOnFormInfoIni;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    ProgressBar: TProgressBar;
    procedure FormCreate(Sender: TObject);
    procedure FWDownLoadClick(Sender: TObject);
    procedure FWOpenClick(Sender: TObject);
    procedure NetUpdateDownloaded(const Sender: TObject; const TheFile: string;
      const TheStep: TUpdateStep);
    procedure NetUpdateDownloading(const Sender: TObject;
      const Step: TUpdateStep);
    procedure NetUpdateErrorMessage(const Sender: TObject;
      const ErrorCode: integer; const ErrorMessage: string);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  F_Update: TF_Update;

implementation

{$IFDEF FPC}
{$R *.lfm}
{$ELSE}
{$R *.dfm}
{$ENDIF}

uses fonctions_init,fonctions_system;

procedure TF_Update.FormCreate(Sender: TObject);
begin
  Netupdate.UpdateDir := fs_GetIniDir+'DownLoad';
  ForceDirectories( Netupdate.UpdateDir );
end;

procedure TF_Update.FWDownLoadClick(Sender: TObject);
var as_counter, as_from, as_to : String;
    ACounter,ABegin,AEnd : Char;
    li_i : Integer ;
begin
  NetUpdate.URLBase:=ed_url.Text;
  as_from := ed_from.Text;
  as_to   := ed_to  .Text;
  if as_from > as_to Then
   AppendStr( as_to, copy ( as_from, length ( as_to ), length ( as_from ) - length ( as_to ) + 1 ))
   else
     if as_to > as_from Then
      AppendStr(as_from, copy ( as_to, length ( as_from ), length ( as_to ) - length ( as_from ) + 1 ));
  as_counter:=as_from;
  NetUpdate.FileAddAtEnd:=ed_extension.text;
  If  ( as_from > '' )
  and ( as_to   > '' )
   Then
    for li_i := 1 to Length(as_counter) do
     Begin
      ABegin := as_from[li_i];
      AEnd   := as_to  [li_i];
      for ACounter := ABegin to AEnd do
       Begin
        if (li_i > length ( as_counter )) and (li_i > 1) Then
         as_counter := copy ( as_counter, 1, li_i - 1 ) + ACounter +  copy ( as_counter, li_i+1, length ( as_counter ) - li_i )
        else if (li_i > length ( as_counter ))  Then
         as_counter := ACounter +  copy ( as_counter, li_i+1, length ( as_counter ) - li_i )
        else if  (li_i > 1) Then
         as_counter := copy ( as_counter, 1, li_i - 1 ) + ACounter
        else as_counter := Acounter;
        NetUpdate.FileUpdate:=as_counter;
        NetUpdate.Update;
       end;
     end;
end;

procedure TF_Update.FWOpenClick(Sender: TObject);
begin
  with Netupdate do
    p_openFileOrDirectory ( UpdateDir );
end;

procedure TF_Update.NetUpdateDownloaded(const Sender: TObject;
  const TheFile: string; const TheStep: TUpdateStep);
begin
  FWDownLoad.Enabled:=True;
end;

procedure TF_Update.NetUpdateDownloading(const Sender: TObject;
  const Step: TUpdateStep);
begin
  FWDownLoad.Enabled:=False;
end;

procedure TF_Update.NetUpdateErrorMessage(const Sender: TObject;
  const ErrorCode: integer; const ErrorMessage: string);
begin
  FWDownLoad.Enabled:=True;
end;

end.


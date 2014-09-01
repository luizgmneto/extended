unit u_formupdate;

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
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls,
  u_netupdate, u_buttons_appli,  u_buttons_defs;

type

  { TF_Update }

  TF_Update = class(TForm)
    FWDownload: TFWRefresh;
    FWOpen: TFWFolder;
{$IFDEF FPC}
    LHTTPClient: TLHTTPClientComponent;
{$ELSE}
    IdHttp : TIdHttp;
{$ENDIF}
    NetUpdate: TNetUpdate;
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
  Netupdate.UpdateDir := fs_GetIniDir;
end;

procedure TF_Update.FWDownLoadClick(Sender: TObject);
begin
  NetUpdate.Update;
end;

procedure TF_Update.FWOpenClick(Sender: TObject);
begin
  with Netupdate do
    p_openFileOrDirectory ( UpdateDir + FileUpdate );
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

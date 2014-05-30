unit u_formupdate;

{$IFDEF FPC}
{$mode Delphi}
{$ENDIF}


interface

uses
  {$IFDEF FPC}
  lNetComponents,FileUtil,
  {$ELSE}
  IdHttp, IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient, JvExControls,
  {$ENDIF}
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls,
  u_netupdate, u_buttons_appli,  u_buttons_defs, JvXPCore, JvXPButtons;

type

  { TF_Update }

  TF_Update = class(TForm)
    FWDownload: TFWRefresh;
    FWLoad: TFWLoad;
{$IFDEF FPC}
    LHTTPClient: TLHTTPClientComponent;
{$ELSE}
    IdHttp : TIdHttp;
{$ENDIF}
    NetUpdate: TNetUpdate;
    ProgressBar: TProgressBar;
    procedure FormCreate(Sender: TObject);
    procedure FWDownLoadClick(Sender: TObject);
    procedure FWLoadClick(Sender: TObject);
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

uses fonctions_system;

procedure TF_Update.FormCreate(Sender: TObject);
begin
  Netupdate.UpdateDir := fs_getAppDir;
end;

procedure TF_Update.FWDownLoadClick(Sender: TObject);
begin
  NetUpdate.Update;
end;

procedure TF_Update.FWLoadClick(Sender: TObject);
begin
  with Netupdate do
    p_openFileOrDirectory ( UpdateDir + FileUpdate );
end;

procedure TF_Update.NetUpdateDownloaded(const Sender: TObject;
  const TheFile: string; const TheStep: TUpdateStep);
begin
  FWDownLoad.Enabled:=True;
  FWLoad.Enabled:=True;
end;

procedure TF_Update.NetUpdateDownloading(const Sender: TObject;
  const Step: TUpdateStep);
begin
  FWDownLoad.Enabled:=False;
  FWLoad.Enabled:=False;
end;

procedure TF_Update.NetUpdateErrorMessage(const Sender: TObject;
  const ErrorCode: integer; const ErrorMessage: string);
begin
  FWDownLoad.Enabled:=True;
  FWLoad.Enabled:=True;
end;

end.

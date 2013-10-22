unit u_formupdate;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFNDEF FPC}
  JvExControls, Windows,
  IdBaseComponent,
  IdComponent, IdTCPConnection, IdTCPClient, IdHTTP,
{$ELSE}
  LCLIntf, LCLType, LMessages, lNetComponents,
{$ENDIF}
  Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, u_netupdate, ComCtrls,  JvXPCore,
  JvXPButtons, u_buttons_defs, u_buttons_appli;

type

  { TF_Update }

  TF_Update = class(TForm)
    NetUpdate: TNetUpdate;
    {$IFNDEF FPC}
    IdHTTP: TIdHTTP;
    {$ELSE}
    LHTTPClient: TLHTTPClientComponent;
    {$ENDIF}
    ProgressBar: TProgressBar;
    FWDownLoad: TFWLoad;
    FWLoad: TFWLoad;
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
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  F_Update: TF_Update;

implementation

{$IFNDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

uses fonctions_system;

procedure TF_Update.FormCreate(Sender: TObject);
begin
  Netupdate.UpdateDir := ExtractFileDir ( Application.Exename );
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

unit u_licence;

{$mode objfpc}{$H+}

interface

uses SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, ComCtrls, LResources, RichView, JvXPButtons,
  U_OnFormInfoIni, RVStyle;

type

  { TF_Licence }

  TF_Licence = class(TForm)
    bt_Accepter: TJvXPButton;
    bt_Refuser: TJvXPButton;
    Label1: TLabel;
    cb_Langage: TComboBox;
    lb_Langage: TLabel;
    OnFormInfoIni: TOnFormInfoIni;
    Panel1: TPanel;
    re_Licence: TRichView;
    RVStyle: TRVStyle;
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure bt_AccepterClick(Sender: TObject);
    procedure bt_RefuserClick(Sender: TObject);
    procedure cb_LangageChange(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Déclarations privées }
    procedure p_ChargeLicense;
  public
    { Déclarations publiques }
  end;

var
  F_Licence: TF_Licence;

implementation

uses fonctions_init, u_formcopy;


procedure TF_Licence.bt_RefuserClick(Sender: TObject);
begin
  if assigned ( FIniFile ) then
    Begin
      FIniFile.WriteBool ( 'Parametres', 'LicenceOK', False );
      FIniFile.UpdateFile;
      Application.Terminate ;
    End
   Else
    Application.Terminate ;

end;

procedure TF_Licence.cb_LangageChange(Sender: TObject);
begin
  F_Copier.ChargeLangue ( cb_Langage.Text );
  p_ChargeLicense;
end;

procedure TF_Licence.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if not FIniFile.ReadBool ( 'Parametres', 'LicenceOK', False )
   then
    CanClose := False ;
end;

procedure TF_Licence.bt_AccepterClick(Sender: TObject);
begin
  if assigned ( FIniFile ) then
    Begin
      FIniFile.WriteBool ( 'Parametres', 'LicenceOK', True );
      Self.Close ;
    End ;

end;

procedure TF_Licence.FormShow(Sender: TObject);
begin
end;


procedure TF_Licence.FormActivate(Sender: TObject);
begin
  p_ChargeLicense;
end;

procedure TF_Licence.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  re_Licence.Lines.Clear;
end;

procedure TF_Licence.p_ChargeLicense;
var
   ls_Licence : String ;
begin
  ls_Licence := ExtractFilePath(Application.ExeName) + 'Languages' +DirectorySeparator + 'licence.' + lowercase ( cb_Langage.Text ) + '.rtf' ;

  F_Copier.LicenseTerminate ( ls_Licence );

  re_Licence.Lines.LoadFromFile ( ls_Licence );
  re_Licence.Repaint;
end;

initialization
  {$i u_licence.lrs}

end.
 

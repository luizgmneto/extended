program UpdateDemo;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses
{$IFDEF FPC}
  Interfaces,
{$ENDIF}
  Forms,
  u_formupdate in 'u_formupdate.pas' {F_Update};

{$IFNDEF FPC}
{$R WindowsXP.res}
{$ENDIF}

begin
  Application.Initialize;
  Application.CreateForm(TF_Update, F_Update);
  Application.Run;
end.

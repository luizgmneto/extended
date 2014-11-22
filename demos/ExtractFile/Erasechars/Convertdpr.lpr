program convertdpr;

{$IFDEF FPC}
{$MODE Delphi}
{$ENDIF}

uses
  Forms, Interfaces, F_Convert in 'F_Convert.pas', lazextinit, lazextcopy;

{$IFNDEF FPC}
{$R *.res}
{$ENDIF}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
program ExtractFile;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, sdflaz
  { you can add units after this }, U_FormCopy, u_aboutbox,
  JvXPBarLaz, lazextcomponents, ExtCopy;

begin
  Application.Initialize;
  Application.CreateForm(TF_Extract, F_Extract);
  Application.CreateForm ( tF_AboutBox, F_AboutBox );
  Application.Run;
end.


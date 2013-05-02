program CopyAndImages;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms
  { you can add units after this }, U_FormCopy, u_licence, u_aboutbox,
  lazrichview, JvXPBarLaz, lazextcomponents, lazextframework;

begin
  Application.Initialize;
  Application.CreateForm ( TF_Copier, F_Copier );
  Application.CreateForm ( TF_Licence, F_Licence );
  Application.CreateForm ( tF_AboutBox, F_AboutBox );
  Application.Run;
end.


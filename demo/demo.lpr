program demo;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, U_Components, LResources, DBFLaz, lazextcomponents, ibexpress,
  virtualtreeview_package;

{$IFDEF WINDOWS}{$R demo.rc}{$ENDIF}

begin
  {$I demo.lrs}
  Application.Initialize;
  Application.CreateForm(TMyform, Myform);
  Application.Run;
end.


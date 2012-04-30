program demo;

uses
  Forms,
  u_components in 'u_components.pas' {Myform: TF_FormMainIni};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMyform, Myform);
  Application.Run;
end.

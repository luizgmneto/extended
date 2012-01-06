program CopyAndImages;

uses
  Forms,
  u_formcopy in 'u_formcopy.pas' {F_Copier},
  u_aboutbox in 'u_aboutbox.pas' {F_AboutBox};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TF_Copier, F_Copier);
  Application.CreateForm(TF_AboutBox, F_AboutBox);
  Application.Run;
end.

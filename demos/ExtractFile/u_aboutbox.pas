unit u_aboutbox;

{$IFDEF FPC}
{$mode Delphi}
{$ELSE}
{$R *.dfm}
{$ENDIF}

interface

uses SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
{$IFDEF FPC}
  LResources,
{$ELSE}
  JvExControls,
{$ENDIF}
  Buttons, ExtCtrls, JvXPButtons,
  JvXPCore;

type

  { TF_AboutBox }

  TF_AboutBox = class(TForm)
    Panel1: TPanel;
    ProgramIcon: TImage;
    ProductName: TLabel;
    Version: TLabel;
    Copyright: TLabel;
    Comments: TLabel;
    OKButton: TJvXPButton;
    procedure OKButtonClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  F_AboutBox: TF_AboutBox;

implementation


{ TF_AboutBox }

procedure TF_AboutBox.OKButtonClick(Sender: TObject);
begin
  Close;
end;

initialization
{$IFDEF FPC}
  {$i u_aboutbox.lrs}
{$ENDIF}
end.
 

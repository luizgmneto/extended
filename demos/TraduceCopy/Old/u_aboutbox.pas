unit u_aboutbox;

{$mode objfpc}{$H+}

interface

uses {Windows,} SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, LResources, JvXPButtons;

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
  {$i u_aboutbox.lrs}
end.
 

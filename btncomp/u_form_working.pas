{-----------------------------------------------------------------------}
{                                                                       }
{           Subprogram Name:                                            }
{           Purpose:          Ancestromania                             }
{           Source Language:  Francais                                  }
{           Auteurs :                      }
{           Andr? Langlet (Main), Matthieu Giroux (LAZARUS),            }
{           Philippe Cazaux-Moutou (Old Ancestro GPL)                            }
{                                                                       }
{-----------------------------------------------------------------------}
{                                                                       }
{           Description:                                                }
{           Ancestromania est un Logiciel Libre                         }
{                                                                       }
{-----------------------------------------------------------------------}
{                                                                       }
{           Revision History                                            }
{           v#    ,Date       ,Author Name            ,Description      }
{                                                                       }
{-----------------------------------------------------------------------}

unit u_form_working;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
  Forms, Controls, StdCtrls,
  ExtCtrls, u_buttons_appli;

procedure doOpenWorking(const sText:string;const Cancel:boolean=false);//AL
procedure doCloseWorking;


type

  TFWorking = class(TForm)
    Panel1: TPanel;
    PleaseWait: TLabel;
    Panel2: TPanel;
    BtnCancel: TFWCancel;
    PanCancel: TPanel;
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BtnCancelClick(Sender: TObject);

  private
    HFiche,HLabel:integer;
    procedure doDesactive;

  public
    procedure doInit(sTexte:string;Annuler:boolean=false);
  end;

var gF_Working:TFWorking;
var gb_btnCancel:boolean;

implementation

{$IFDEF FPC}{$R *.lfm}{$ELSE}{$R *.DFM}{$ENDIF}

uses StrUtils,sysutils;

{ TFWorking }

procedure doOpenWorking(const sText:string;const Cancel:boolean=false);//AL
begin
  if not Assigned(gF_Working) then
    gF_Working:=TFWorking.create(Application);
  gb_btnCancel:=False;
  gF_Working.doInit(sText,Cancel);
  Application.ProcessMessages;
end;

procedure doCloseWorking;//AL
begin
  FreeAndNil(gF_Working);
end;



procedure TFWorking.doDesactive;
begin
  Hide;
  screen.cursor := crDefault;
  Application.ProcessMessages;
end;

procedure TFWorking.doInit(sTexte: string;Annuler:boolean=false);
var
  i,l:integer;
begin
  BtnCancel.Enabled:=true;
  PanCancel.Visible:=Annuler;
  i:=0;
  l:=Pos(#13,sTexte);
  while l>0 do
  begin
    inc(i);
    l:=PosEx(#13,sTexte,l+1);
  end;
  if Annuler then
    self.ClientHeight:=HFiche+i*PleaseWait.Height
  else
    self.ClientHeight:=HFiche+i*PleaseWait.Height-PanCancel.Height;
  screen.cursor := crHourGlass;
  Show;
  PleaseWait.Caption:=sTexte;
  Application.ProcessMessages;
end;

procedure TFWorking.FormDestroy(Sender: TObject);
begin
  doDesactive;
  close;
end;

procedure TFWorking.FormCreate(Sender: TObject);
var
  aForm:TForm;
begin
  HFiche:=self.ClientHeight;
  HLabel:=PleaseWait.Height;
  aForm:= Screen.ActiveForm;
  if aForm=nil then
    if Assigned(Application.MainForm) then
      aForm:=Application.MainForm;
  if aForm<>nil then
  begin
    Position:=poDesigned;
    Left:=aForm.Left+(aForm.Width-Width)div 2;
    Top:=aForm.Top+(aForm.Height-Height)div 2;
  end;
end;

procedure TFWorking.BtnCancelClick(Sender: TObject);
begin
  gb_btnCancel:=true;
  BtnCancel.Enabled:=false;
  Application.ProcessMessages;
end;

end.

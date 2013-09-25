{-----------------------------------------------------------------------}
{                                                                       }
{           Subprogram Name:                                            }
{           Purpose:          Ancestromania                             }
{           Source Language:  Francais                                  }
{           Auteurs :                      }
{           Philippe Cazaux-Moutou                                       }
{                                                                       }
{-----------------------------------------------------------------------}
{                                                                       }
{           Description:                                                }
{           Ancestromania est un Logiciel Libre                         }
{                                                                       }
{-----------------------------------------------------------------------}
{                                                                       }
{           Revision History                                            }
{           Date 03/01/2009      ,Author Name Andr? Langlet           }
{           Description      }
{           Ajout image et affichage dans memo                          }
{-----------------------------------------------------------------------}

unit u_form_msg;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFNDEF FPC}
  u_comp_TJvXPButton, Windows,
{$ELSE}
  LCLIntf, LCLType, LMessages,
{$ENDIF}
  StdCtrls,forms,ExtCtrls,Controls,Classes,Dialogs,
  u_buttons_appli,JvXPButtons,
  U_ExtImage,   Menus,  Graphics;

function MyMessageDlg(const Msg:string;const DlgType:TMsgDlgType;const Buttons:TMsgDlgButtons;const StyleLb:Integer;const proprio:TControl=nil):Word; overload;
function MyMessageDlg(const Title,Msg:string;const DlgType:TMsgDlgType;const Buttons:TMsgDlgButtons;const Help : Integer = 0; const StyleLb:Integer = 0;const proprio:TControl=nil):Word; overload;
function AMessageDlg(const Msg:string;const DlgType:TMsgDlgType;const Buttons:TMsgDlgButtons;const StyleLb:Integer;const proprio:TControl=nil):Word;

type

  { TFMsg }

  TFMsg=class(TForm)
    Panel2:TPanel;
    lbMsg:TLabel;
    lYes:TLabel;
    lNo:TLabel;
    lCancel:TLabel;
    btn1:TJvXPButton;
    btn2:TJvXPButton;
    btn3:TJvXPButton;
    MemorMsg: TStaticText;
    ImageConfirmation: TExtImage;
    ImageInformation: TExtImage;
    ImageErreur: TExtImage;
    ImageAttention: TExtImage;
    lYesToAll: TLabel;
    lNoToAll: TLabel;
    MemoMsg: TStaticText;

    procedure FormShow(Sender: TObject);
    procedure SuperFormKeyDown(Sender:TObject;var Key:Word;
      Shift:TShiftState);
  private
    fButtons:TMsgDlgButtons;
    fDlgType:TMsgDlgType;

  public
    ModeMemo:boolean;
    proprio : TControl;
    property Buttons:TMsgDlgButtons read fButtons write fButtons;
    property DlgType:TMsgDlgType read fDlgType write fDlgType;
    procedure InitMessage;
  end;

implementation

uses
     {$IFDEF FPC}
     unite_messages,
     {$ELSE}
     unite_messages_delphi,
     {$ENDIF}
     Sysutils, u_form_working;

{$IFDEF FPC}{$R *.lfm}{$ELSE}{$R *.DFM}{$ENDIF}

function MyMessageDlg(const Msg:string;const DlgType:TMsgDlgType;const Buttons:TMsgDlgButtons;const StyleLb:Integer;const proprio:TControl=nil):Word;
Begin
  doCloseWorking;
  Result := AMessageDlg( Msg, DlgType, Buttons, StyleLb, proprio);
end;

function CreateMessageDlg(const Msg:string;const DlgType:TMsgDlgType;const Buttons:TMsgDlgButtons;const StyleLb:Integer;const proprio:TControl=nil):TFMsg;
begin
  Result:=TFMsg.create(proprio);
    Result.lbMsg.Caption:=Msg;
    Result.Buttons:=Buttons;
    Result.DlgType:=DlgType;
    with Result.lbMsg.Font do
      case StyleLb of
        0,4:Style:= [fsBold];
        1,5:Style:= [];
        2,6:Style:= [fsItalic];
        3,7:Style:= [fsUnderline];
      end;
    Result.ModeMemo:=StyleLb>3;
    Result.proprio:=proprio;
    Result.InitMessage;

end;

function AMessageDlg(const Msg:string;const DlgType:TMsgDlgType;const Buttons:TMsgDlgButtons;const StyleLb:Integer;const proprio:TControl=nil):Word;
var lf_MessageDlg : TFMsg;
Begin
 lf_MessageDlg := CreateMessageDlg(Msg, DlgType, Buttons, StyleLb, proprio);
 try
   result:=lf_MessageDlg.ShowModal;
 finally
   lf_MessageDlg.Destroy;
 end;
end;

function MyMessageDlg(const Title,Msg:string;const DlgType:TMsgDlgType;const Buttons:TMsgDlgButtons;const Help : Integer = 0; const StyleLb:Integer = 0;const proprio:TControl=nil):Word;
var lf_MessageDlg : TFMsg;
Begin
 lf_MessageDlg := CreateMessageDlg(Msg, DlgType, Buttons, StyleLb, proprio);
 lf_MessageDlg.Caption:=Title;
 lf_MessageDlg.HelpContext:=Help;
 try
   result:=lf_MessageDlg.ShowModal;
 finally
   lf_MessageDlg.Destroy;
 end;
end;

procedure TFMsg.InitMessage;
var
  k,p:integer;
  procedure PutInBtn(numBtn:integer;aText:string;aResult:word);//AL2010
  var
    btn:TJvXPButton;
  begin
    case numBtn of
      1:btn:=btn1;
      2:btn:=btn2;
      else btn:=btn3;
    end;
    btn.Caption:=aText;
    btn.ModalResult:=aResult;
    btn.Default:=numBtn=(4-k);//si c'est le premier
    btn.Cancel:=numBtn=3; //c'est le dernier (pas d'inconvénient s'il est aussi le premier)
    btn.visible:=true;
  end;

  Procedure PlaceType(Image:TImage;const libelle:String);
  begin
    Caption:=libelle;
    Image.Visible:=true;
    Image.Top:=4;
    Image.Left:=4;
  end;

begin
  btn1.visible:=false;
  btn2.visible:=false;
  btn3.visible:=false;
  k:=0;
  if (mbYes in fButtons) then inc(k);
  if (mbYesToAll in fButtons) then inc(k);
  if (mbNo in fButtons) then inc(k);
  if (mbNoToAll in fButtons) then inc(k);
  if (mbOk in fButtons) then inc(k);
  if (mbCancel in fButtons) then inc(k);
  if (mbIgnore in fButtons) then inc(k);

  if (k>0)and(k<=3) then
  begin
    p:=3-k;//numéro du btn de départ (-1)

    if (mbYes in fButtons) then
    begin
      inc(p);
      putInBtn(p,lYes.Caption,mrYes);
    end;

    if (mbYesToAll in fButtons) then
    begin
      inc(p);
      putInBtn(p,lYesToAll.Caption,mrYesToAll);
    end;

    if (mbNo in fButtons) then
    begin
      inc(p);
      putInBtn(p,lNo.Caption,mrNo);
    end;

    if (mbNoToAll in fButtons) then
    begin
      inc(p);
      putInBtn(p,lNoToAll.Caption,mrNoToAll);
    end;

    if (mbOk in fButtons) then
    begin
      inc(p);
      putInBtn(p,gs_OK,mrOk);
    end;

    if (mbCancel in fButtons) then
    begin
      inc(p);
      putInBtn(p,lCancel.Caption,mrCancel);
    end;

    if (mbIgnore in fButtons) then
    begin
      inc(p);
      putInBtn(p,gs_Ignore,mrIgnore);
    end;
  end;

  case fDlgType of
    mtWarning: PlaceType(ImageAttention,gs_Warning);
    mtInformation: PlaceType(ImageInformation,gs_Information);
    mtConfirmation: PlaceType(ImageConfirmation,gs_Confirmation);
  else
    PlaceType(ImageErreur,'Erreur');
  end;

  MemoMsg.Visible:=ModeMemo;
  lbMsg.Visible:=not ModeMemo;
end;

procedure TFMsg.SuperFormKeyDown(Sender:TObject;var Key:Word;Shift:TShiftState);
begin
  if (ssAlt in Shift)and(Key=VK_F4) then Key:=0;
end;

// procedure TFMsg.FormShow
// resizing form works only on show
procedure TFMsg.FormShow(Sender: TObject);
var  RectMonitor:TRect;

begin
 if ModeMemo then  //MG 2012
  begin
    MemoMsg.Font.Style:=lbMsg.Font.Style;
    MemoMsg.Caption:=lbMsg.Caption;
    Height:=MemoMsg.Height+45;
    Width:=MemoMsg.Width+56;
  end
  else
  begin
    Height:=lbMsg.Height+45; //AL 2009
    Width:=lbMsg.Width+56;
  end;

  if (proprio=nil)and Assigned(Application.MainForm)
   then
     proprio:=Application.MainForm;

  if proprio<>nil then
    begin
      Position:=poDesigned;
      Left:=proprio.Left+(proprio.Width-Width)div 2;
      Top:=proprio.Top+(proprio.Height-Height)div 2;
      RectMonitor:=Monitor.WorkareaRect;

      if (Top+Height)>RectMonitor.Bottom then
        Top:=RectMonitor.Bottom-Height;
      if Top<RectMonitor.Top then
        Top:=RectMonitor.Top;

      if (Left+Width)>RectMonitor.Right then
        Left:=RectMonitor.Right-Width;
      if Left<RectMonitor.Left then
        Left:=RectMonitor.Left;
    end;
  BringToFront;
end;


end.


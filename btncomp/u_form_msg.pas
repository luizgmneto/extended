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
  LCLIntf, LCLType,
{$ENDIF}
  StdCtrls,Forms,ExtCtrls,
  Controls,Classes,Dialogs,
{$IFDEF VERSIONS}
  fonctions_version,
{$ENDIF}
  u_buttons_appli,
  u_buttons_defs,
  U_ExtImage,
  U_FormAdapt,
  Menus,
  Graphics;


{$IFDEF VERSIONS}
const
    gVer_F_Msg : T_Version = ( Component : 'Message dialog Window' ;
       			                 FileUnit : 'u_form_working' ;
       			                 Owner : 'Matthieu Giroux' ;
       			                 Comment : 'Ask or tell anything.' ;
      			                 BugsStory :'Version 0.1.0.0 : From other software' ;
			                 UnitType : CST_TYPE_UNITE_FICHE ;
			                 Major : 0 ; Minor : 1 ; Release : 0 ; Build : 0 );
{$ENDIF}

type

  { TFMsg }

  TFMsg=class(TF_FormAdapt)
    PanelButtons: TPanel;
    Panel2:TPanel;
    lbMsg:TLabel;
    MemorMsg: TStaticText;
    Image: TExtImage;
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
     Sysutils;

const CST_IMAGE_Warning = 'mwarning';
      CST_IMAGE_Information = 'minfo';
      CST_IMAGE_Confirmation = 'mconfirm';
      CST_IMAGE_Error = 'merror';


{$IFDEF FPC}{$R *.lfm}{$ELSE}{$R *.DFM}{$ENDIF}

procedure TFMsg.InitMessage;
var
  k,p,TotalWidth:integer;
  procedure PutInBtn(numBtn:integer;aText:string;aResult:word);//MG2013
  var
    btn:TFWButton;
  begin
    btn := TFWButton.Create(Self);
    with btn do
     Begin
       Parent := PanelButtons;
       Align:=alRight;
       case aResult of
         mrYes,mrOK,mrYesToAll,mrAll     : p_Load_Buttons_Appli (Glyph,CST_FWOK,btn);
         mrNo,mrCancel,mrAbort,mrNoToAll : p_Load_Buttons_Appli (Glyph,CST_FWCANCEL,btn);
         mrClose                         : p_Load_Buttons_Appli (Glyph,CST_FWCLOSE,btn);
        End;
       AdaptGlyph ( Height - 2 );
       Caption:=aText;
       ModalResult:=aResult;
       Default:=numBtn=(4-k);//si c'est le premier
       Cancel:=numBtn=1; //c'est le dernier (pas d'inconvénient s'il est aussi le premier)
       Width := Font.GetTextWidth(aText)+GlyphSize+12;
       inc ( TotalWidth, Width );
       visible:=true;
      end;
  end;

  Procedure PlaceType(const imagefile,libelle:String);
  begin
    Caption:=libelle;
    p_Load_Buttons_Appli ( Image.Picture, imagefile, Image );
  end;

begin
  k:=0;
  TotalWidth := 0;
  if (mbYes in fButtons) then inc(k);
  if (mbYesToAll in fButtons) then inc(k);
  if (mbNo in fButtons) then inc(k);
  if (mbNoToAll in fButtons) then inc(k);
  if (mbOk in fButtons) then inc(k);
  if (mbCancel in fButtons) then inc(k);
  if (mbIgnore in fButtons) then inc(k);

  if (k>0) then
  begin
    p:=0;//numéro du btn de départ (-1)

    if (mbYes in fButtons) then
    begin
      inc(p);
      putInBtn(p,gs_Yes,mrYes);
    end;

    if (mbYesToAll in fButtons) then
    begin
      inc(p);
      putInBtn(p,gs_YesToAll,mrYesToAll);
    end;

    if (mbNo in fButtons) then
    begin
      inc(p);
      putInBtn(p,gs_No,mrNo);
    end;

    if (mbNoToAll in fButtons) then
    begin
      inc(p);
      putInBtn(p,gs_NoToAll,mrNoToAll);
    end;

    if (mbOk in fButtons) then
    begin
      inc(p);
      putInBtn(p,gs_OK,mrOk);
    end;

    if (mbCancel in fButtons) then
    begin
      inc(p);
      putInBtn(p,gs_Cancel,mrCancel);
    end;

    if (mbIgnore in fButtons) then
    begin
      inc(p);
      putInBtn(p,gs_Ignore,mrIgnore);
    end;
    inc ( TotalWidth, 4 );
    if Width<TotalWidth Then
     Width := TotalWidth ;
  end;

  case fDlgType of
    mtWarning: PlaceType(CST_IMAGE_Warning,gs_Warning);
    mtInformation: PlaceType(CST_IMAGE_Information,gs_Information);
    mtConfirmation: PlaceType(CST_IMAGE_Confirmation,gs_Confirmation);
  else
    PlaceType(CST_IMAGE_Error,gs_Error);
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


{$IFDEF VERSIONS}
initialization
  p_ConcatVersion ( gVer_F_Msg );
{$ENDIF}
end.


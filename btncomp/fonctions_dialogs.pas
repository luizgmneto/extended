unit fonctions_dialogs;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
  Classes, SysUtils,
  Dialogs, Controls,
  u_form_working;

{$IFDEF VERSIONS}
const
    gVer_fonctions_FenetrePrincipale : T_Version = ( Component : 'Fenêtre principale troisième version' ;
       			                 FileUnit : 'fonctions_FenetrePrincipale' ;
       			                 Owner : 'Matthieu Giroux' ;
       			                 Comment : 'Fenêtre principale utilisée pour la gestion automatisée à partir du fichier INI, avec des menus composés à partir des données.' + #13#10 + 'Elle dépend du composant Fenêtre principale qui lui n''est pas lié à l''application.' ;
      			                 BugsStory : 'Version 1.0.0.1 : p_volet* functions Tested.' + #13#10
                                                   + 'Version 1.0.0.0 : Tested.' + #13#10
                                                   + 'Version 0.0.0.1 : Centralising.' + #13#10 ;
			                 UnitType : CST_TYPE_UNITE_FONCTIONS ;
			                 Major : 1 ; Minor : 0 ; Release : 0 ; Build : 1 );
{$ENDIF}

procedure doShowWorking(const sText:string;const Cancel:boolean=false);//AL
procedure doCloseWorking;

function MyMessageDlg(const Msg:string;const DlgType:TMsgDlgType;const Buttons:TMsgDlgButtons;const StyleLb:Integer;const proprio:TControl=nil):Word; overload;
function MyMessageDlg(const Title,Msg:string;const DlgType:TMsgDlgType;const Buttons:TMsgDlgButtons;const Help : Integer = 0; const StyleLb:Integer = 4;const proprio:TControl=nil):Word; overload;
function AMessageDlg(const Msg:string;const DlgType:TMsgDlgType;const Buttons:TMsgDlgButtons;const StyleLb:Integer;const proprio:TControl=nil):Word;


var gF_Working:TFWorking;
    gb_btnCancel:boolean;

implementation

uses u_form_msg,
     Forms,
     Graphics;


procedure doShowWorking(const sText:string;const Cancel:boolean=false);//AL
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

function MyMessageDlg(const Title,Msg:string;const DlgType:TMsgDlgType;const Buttons:TMsgDlgButtons;const Help : Integer = 0; const StyleLb:Integer = 4;const proprio:TControl=nil):Word;
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


end.


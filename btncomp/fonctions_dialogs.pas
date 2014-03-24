unit fonctions_dialogs;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
  Classes, SysUtils,
  Graphics,
{$IFDEF VERSIONS}
  fonctions_version,
{$ENDIF}
  Dialogs, Controls,
  u_form_working;

{$IFDEF VERSIONS}
const
    gVer_fonctions_FenetrePrincipale : T_Version = ( Component : 'Fenêtre principale troisième version' ;
       			                 FileUnit : 'fonctions_FenetrePrincipale' ;
       			                 Owner : 'Matthieu Giroux' ;
       			                 Comment : 'Fenêtre principale utilisée pour la gestion automatisée à partir du fichier INI, avec des menus composés à partir des données.' + #13#10 + 'Elle dépend du composant Fenêtre principale qui lui n''est pas lié à l''application.' ;
      			                 BugsStory : 'Version 1.0.2.0 : MyShowMessage function.' + #13#10
                                                   + 'Version 1.0.1.0 : Simplifying.' + #13#10
                                                   + 'Version 1.0.0.1 : p_volet* functions Tested.' + #13#10
                                                   + 'Version 1.0.0.0 : Tested.' + #13#10
                                                   + 'Version 0.0.0.1 : Centralising.' + #13#10 ;
			                 UnitType : CST_TYPE_UNITE_FONCTIONS ;
			                 Major : 1 ; Minor : 0 ; Release : 2 ; Build : 0 );
{$ENDIF}
type TOnShowWorkingMessage = procedure ( const as_SQL: String ; const Cancel : Boolean );
     TOnCloseWorkingMessage = procedure ();

var ge_ShowWorkingMessage  : TOnShowWorkingMessage  = nil ;
    ge_CloseWorkingMessage : TOnCloseWorkingMessage = nil ;

procedure doShowWorking(const sText:string;const Cancel:boolean=false);//AL
procedure doCloseWorking;

function MyShowMessage ( const Msg:string;
                         const amb_Buttons : TMsgDlgButtons =[mbOK] ;
                         const ADlgType:TMsgDlgType=mtWarning;
                         const proprio:TControl=nil;
                         const StyleLb:TFontStyles=[fsBold]):Word;
function MyMessageDlg  ( const Msg:string;
                         const ADlgType:TMsgDlgType=mtError;
                         const AButtons:TMsgDlgButtons=[mbOK];
                         const proprio:TControl=nil;
                         const StyleLb:TFontStyles=[fsBold]):Word; overload;
function MyMessageDlg  ( const Title,Msg:string;
                         const ADlgType:TMsgDlgType=mtError;
                         const AButtons:TMsgDlgButtons=[mbOK];
                         const Help : Integer = 0;
                         const proprio:TControl=nil;
                         const StyleLb:TFontStyles=[fsBold]):Word; overload;
function AMessageDlg   ( const Msg:string;
                         const ADlgType:TMsgDlgType;
                         const AButtons:TMsgDlgButtons;
                         const proprio:TControl=nil;
                         const StyleLb:TFontStyles=[fsBold]):Word;


var gF_Working:TFWorking=nil;
    gb_btnCancel:boolean;

implementation

uses u_form_msg,
     Forms;


procedure doShowWorking(const sText:string;const Cancel:boolean=false);//AL
begin
  if Assigned(ge_ShowWorkingMessage) Then
    Begin
      ge_ShowWorkingMessage(sText,Cancel);
      Exit;
    end;
  if not Assigned(gF_Working) then
    gF_Working:=TFWorking.create(Application);
  gb_btnCancel:=False;
  gF_Working.doInit(sText,Cancel);
  gF_Working.Update;
end;

procedure doCloseWorking;//AL
begin
  if Assigned(ge_CloseWorkingMessage) Then
    Begin
      ge_CloseWorkingMessage();
      Exit;
    end;
  // some problems at closing software on linux
  FreeAndNil(gF_Working)
end;


function MyMessageDlg  ( const Msg:string;
                         const ADlgType:TMsgDlgType=mtError;
                         const AButtons:TMsgDlgButtons=[mbOK];
                         const proprio:TControl=nil;
                         const StyleLb:TFontStyles=[fsBold]):Word; overload;
Begin
  doCloseWorking;
  Result := AMessageDlg( Msg, ADlgType, AButtons, proprio, StyleLb);
end;

function MyShowMessage ( const Msg:string;
                         const amb_Buttons : TMsgDlgButtons =[mbOK] ;
                         const ADlgType:TMsgDlgType=mtWarning;
                         const proprio:TControl=nil;
                         const StyleLb:TFontStyles=[fsBold]):Word;
Begin
  doCloseWorking;
  Result := AMessageDlg( Msg, ADlgType, amb_Buttons, proprio, StyleLb);
end;

function CreateMessageDlg(const Msg:string;const ADlgType:TMsgDlgType;const AButtons:TMsgDlgButtons;const proprio:TControl=nil;const StyleLb:TFontStyles=[fsBold]):TFMsg;
begin
  Result:=TFMsg.create(proprio);
  with Result do
   Begin
    lbMsg.Caption:=Msg;
    lbMsg.Font.Style := StyleLb;
    Buttons:=AButtons;
    DlgType:=ADlgType;
    AOwner:=proprio;
    InitMessage;
   end;

end;

function AMessageDlg   ( const Msg:string;
                         const ADlgType:TMsgDlgType;
                         const AButtons:TMsgDlgButtons;
                         const proprio:TControl=nil;
                         const StyleLb:TFontStyles=[fsBold]):Word;
var lf_MessageDlg : TFMsg;
Begin
 lf_MessageDlg := CreateMessageDlg(Msg, ADlgType, AButtons, proprio, StyleLb);
 try
   result:=lf_MessageDlg.ShowModal;
 finally
   lf_MessageDlg.Destroy;
 end;
end;

function MyMessageDlg  ( const Title,Msg:string;
                         const ADlgType:TMsgDlgType=mtError;
                         const AButtons:TMsgDlgButtons=[mbOK];
                         const Help : Integer = 0;
                         const proprio:TControl=nil;
                         const StyleLb:TFontStyles=[fsBold]):Word; overload;
var lf_MessageDlg : TFMsg;
Begin
 lf_MessageDlg := CreateMessageDlg(Msg, ADlgType, AButtons, proprio, StyleLb);
 lf_MessageDlg.Caption:=Title;
 lf_MessageDlg.HelpContext:=Help;
 try
   result:=lf_MessageDlg.ShowModal;
 finally
   lf_MessageDlg.Destroy;
 end;
end;

end.


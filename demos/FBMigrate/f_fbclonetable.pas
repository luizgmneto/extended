unit f_fbclonetable;

{$IFDEF FPC}
{$MODE Delphi}
{$R *.lfm}
{$ENDIF}
{ crée ceci :
[UPDATE]
Nom=Ancestromania.exe
Version=2013.0
VersionExe=2013.0.0.671
Taille=3934208
Date=08/02/2013 17:17:34
TailleMAJC=10230864
VersionBase=5.159
md5=8b1d3a9bc30a57624c338a395f507ba6
}

interface

uses
  SysUtils, Classes, Controls, Forms, fonctions_system, Dialogs,
  StdCtrls, ExtCtrls, EditBtn, UniqueInstance,
  U_OnFormInfoIni;

type

  { TForm1 }

  TForm1 = class(TForm)
    DatabaseSource: TFileNameEdit;
    DatabaseDest: TFileNameEdit;
    DDL: TFileNameEdit;
    ISQL: TFileNameEdit;
    Label3: TLabel;
    Label34: TLabel;
    Label35: TLabel;
    Label36: TLabel;
    Label37: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    ListBox1: TListBox;
    OnFormInfoIni: TOnFormInfoIni;
    Panel1: TPanel;
    Panel16: TPanel;
    Panel6: TPanel;
    Panel8: TPanel;
    Panel9: TPanel;
    PassWord: TEdit;
    CloneTable: TButton;
    DirectoryListBox: TDirectoryEdit;
    FBClone: TFileNameEdit;
    Label1: TLabel;
    Label2: TLabel;
    PanelBottom: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel31: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel7: TPanel;
    UniqueInstance: TUniqueInstance;
    UserName: TEdit;
    CharsetDest: TEdit;
    Table: TEdit;
    procedure CloneTableClick(Sender: TObject);
    procedure DatabaseSourceChange(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  public
    { Déclarations publiées }
  end;

var
  Form1: TForm1;

implementation


uses fonctions_dialogs,
     LazUTF8Classes,
     strutils,
     FileUtil;

{ TForm1 }


procedure TForm1.CloneTableClick(Sender: TObject);
var ls_temp, ls_fileDest : String ;
    li_i, li_pos, li_pos2  : Integer;
    lst_DDL : TStringListUTF8;
    lb_addCommit : Boolean;

begin
  if (CharsetDest.Text = '')
  or (DatabaseSource.FileName = '')
  or (DatabaseDest.FileName = '')
  or (Table.Text = '')
  or (ISQL.FileName = '')
  or (FBClone.FileName = '')
   Then
     Begin
       MyMessageDlg('Please fill form.',mtWarning,[mbOK]);
       Exit;
     end;
  ls_fileDest:=DatabaseDest.FileName;
  if FileExistsUTF8 ( ls_fileDest ) Then
  and FileExistsUTF8 ( DatabaseSource.FileName ) Then
    Begin
      if MyMessageDlg('Will copy this table :'+Table.Text+#10+' on '+ls_fileDest,mtConfirmation,mbYesNo,Self)=mrYes Then
       Begin
        ls_fileDest := fs_ExecuteProcess(FBClone.Text,' -s '+DatabaseSource.FileName+' -t '+ls_fileDest+' -u '+UserName.Text+' -p '+PassWord.Text+' -tc '+CharsetDest.Text,False);
        if ls_fileDest >'' Then
          MessageDlg('Error :'+#0+ls_fileDest,mtError,[mbOK],0);
       end;

    end;
end;

procedure TForm1.DatabaseSourceChange(Sender: TObject);
begin

end;


end.

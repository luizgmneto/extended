unit f_fbclonegui;

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
    Database: TFileNameEdit;
    DDL: TFileNameEdit;
    ISQL: TFileNameEdit;
    Label3: TLabel;
    Label34: TLabel;
    Label35: TLabel;
    Label37: TLabel;
    Label4: TLabel;
    OnFormInfoIni: TOnFormInfoIni;
    Panel16: TPanel;
    Panel8: TPanel;
    PassWord: TEdit;
    Migrate: TButton;
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
    procedure FormShow(Sender: TObject);
    procedure MigrateClick(Sender: TObject);
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

function fs_CreateDatabase  ( const as_base, as_user, as_password, as_charset : String ):String;
Begin
  Result := 'CREATE DATABASE '''+as_base+''' USER '''+as_user+''' PASSWORD '''+as_password+''' PAGE_SIZE 16384 DEFAULT CHARACTER SET '+as_charset+';'+#10
          + 'CONNECT '''+as_base+''' USER '''+as_user+''' PASSWORD '''+as_password+''';'+#10;
End;


function fb_PromptDelete ( const as_file : String ):Boolean;
Begin
  Result := not FileExistsUTF8(as_file);
  if Result Then Exit;
  if MyMessageDlg('Delete '+#10+as_file+#10+'?',mtConfirmation,mbYesNo)= mrYes
  Then
    Begin
      DeleteFile(as_file);
      Result := True;
    End;
end;

procedure TForm1.MigrateClick(Sender: TObject);
var ls_temp, ls_fileDest : String ;
    li_i, li_pos, li_pos2  : Integer;
    lst_DDL : TStringListUTF8;
    lb_addCommit : Boolean;
    function getPos2 ( const as_temp : String; const ai_pos1 : Integer ):Integer;
    var li_pos3 : Integer;
        procedure  p_calculateResult;
        Begin
          if (li_pos3 > 0) and (( li_pos3 < Result) or ( Result = 0 )) Then
            Result:=li_pos3;

        end;

    Begin
      result  := PosEx(',',as_temp,ai_pos1);
      li_pos3 := PosEx(' ',as_temp,ai_pos1);
      p_calculateResult;
      li_pos3 := PosEx(')',as_temp,ai_pos1);
      p_calculateResult;
      li_pos3 := PosEx(';',as_temp,ai_pos1);
      p_calculateResult;
    end;

begin
  if (CharsetDest.Text = '')
  or (Database.FileName = '')
  or (ISQL.FileName = '')
  or (FBClone.FileName = '')
   Then
     Begin
       MyMessageDlg('Please fill form.',mtWarning,[mbOK]);
       Exit;
     end;
  ls_fileDest:=ExtractFilePath(Database.Text)+ExtractFileNameOnly(Database.Text)+CharsetDest.Text+'.fdb';
  if fb_PromptDelete(GetAppDir+'DDL.sql') Then
    Begin
      if fb_PromptDelete(DDL.text) Then
        Begin
         DeleteFile(DDL.text);
         MyMessageDlg('Will execute this :'+#13#10+ISQL.Text+' -a -ch '+CharsetDest.Text +' -o '''+DDL.text+''' '''+Database.FileName+''''+#10+'Please wait...',mtInformation);
         fs_ExecuteProcess(ISQL.Text,' -a -ch '+CharsetDest.Text +' -o '''+DDL.text+''' '''+Database.FileName+'''',False);
        end;
      lb_addCommit := MyMessageDlg('Will copy this file :'+DDL.Text+#10+'Do i place ''commit;'' after table creation and at the end, with collate deleting ?',mtConfirmation,mbYesNo,Self)=mrYes;
      lst_DDL := TStringListUTF8.Create;
      with lst_DDL do
       try
        LoadFromFile(DDL.Text);
        if lb_addCommit Then
          Begin
            add('commit;');
            for li_i := count -1 downto 0 do
             Begin
               ls_temp := lst_DDL [ li_i ];
               if pos ( '/***', ls_temp ) = 1
                then insert ( li_i, 'commit;' )
                else
                  Begin
                   li_pos:=pos ( 'COLLATE', UpperCase(ls_temp) );
                   if (li_pos  > 0) Then
                     Begin
                      lst_DDL [ li_i ] := copy ( ls_temp, 1, li_pos -1)+copy(ls_temp,getPos2(ls_temp,li_pos+9),Length(ls_temp));
                     end;
                    ls_temp := lst_DDL [ li_i ];
                    li_pos:=pos  ( 'CHARACTER', UpperCase(ls_temp) );
                    if (li_pos  > 0) Then
                        lst_DDL [ li_i ] := copy ( ls_temp, 1, li_pos -1)+copy(ls_temp,getPos2(ls_temp,li_pos+14),Length(ls_temp));
                   end;

             end;
          end;
        insert(0,fs_CreateDatabase ( ls_fileDest, UserName.Text, PassWord.Text, CharsetDest.Text ));
        SaveToFile(GetAppDir+'DDL.sql');
       finally
        end;
    end;
  if fb_PromptDelete ( ls_fileDest )
   Then
     Begin
      MyMessageDlg('Will execute this :'+#13#10+ISQL.Text+' -ch '+CharsetDest.Text +' -i '''+GetAppDir+'DDL.sql'''+#10+'Please wait...',mtInformation);
      fs_ExecuteProcess(ISQL.Text,' -ch '+CharsetDest.Text +' -i '''+GetAppDir+'DDL.sql''',False);
      MyMessageDlg('Will execute this :'+#13#10+FBClone.Text+' -s '''+Database.FileName+''' -t '+ls_fileDest+' -u '+UserName.Text+' -e po -p '+PassWord.Text+' -tc '+CharsetDest.Text+#13#10+'Please install Firebird 2.5 and Visual C++ 2005 Runtime for Windows 32. Please wait...',mtInformation);
      ls_fileDest := fs_ExecuteProcess(FBClone.Text,' -s '+Database.FileName+' -t '+ls_fileDest+' -u '+UserName.Text+' -e -po -p '+PassWord.Text+' -tc '+CharsetDest.Text,False);
      if ls_fileDest >'' Then
        MessageDlg('Error :'+#0+ls_fileDest,mtError,[mbOK],0);
     end;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  if DDL.Text = '' Then
    DDL.Text:=GetAppDir+'DDLWithoutCreate.sql';
end;


end.

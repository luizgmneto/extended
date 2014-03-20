unit f_createini;

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
  SysUtils, Classes, Graphics, Controls, Forms, fonctions_system, Dialogs,
  StdCtrls, FileCtrl, ExtCtrls, LResources, EditBtn, UniqueInstance,
  U_OnFormInfoIni, IBDatabase, IBSQL;

type

  { TForm1 }

  TForm1 = class(TForm)
    Creer: TButton;
    UserName: TEdit;
    PassWord: TEdit;
    Label34: TLabel;
    Label35: TLabel;
    See: TButton;
    CreerCarboni386: TButton;
    CreerCarbon64: TButton;
    CreerCarbonARM: TButton;
    CreerCarbonPPC: TButton;
    CreerDebianGnomei386: TButton;
    CreerDebianGnomeARM: TButton;
    CreerDebianGnomei64: TButton;
    CreerDebianGnomePPC: TButton;
    CreerDebianKDE386: TButton;
    CreerDebianKDEARM: TButton;
    CreerDebianKDEi64: TButton;
    CreerDebianKDEPPC: TButton;
    CreerRedhatGnomei386: TButton;
    CreerRedhatKDEARM1: TButton;
    CreerTarGnomei386: TButton;
    CreerRedhatGnomeARM: TButton;
    CreerTarGnomeARM: TButton;
    CreerRedhatGnomei64: TButton;
    CreerTarGnomei64: TButton;
    CreerRedhatGnomePPC: TButton;
    CreerTarGnomePPC: TButton;
    CreerRedhatKDEi386: TButton;
    CreerTarKDEARM: TButton;
    CreerRedhatKDEi64: TButton;
    CreerTarKDEi64: TButton;
    CreerRedhatKDEPPC: TButton;
    CreerTarKDEi386: TButton;
    CreerTarKDEPPC: TButton;
    CreerWini386: TButton;
    CreerWini64: TButton;
    DirectoryDest: TDirectoryEdit;
    DirectoryExe: TDirectoryEdit;
    DirectoryListBox: TDirectoryEdit;
    FileWin32: TFileNameEdit;
    FileWin33: TFileNameEdit;
    FileWin34: TFileNameEdit;
    FileWin35: TFileNameEdit;
    FileWin36: TFileNameEdit;
    FileWin37: TFileNameEdit;
    FileWin38: TFileNameEdit;
    FileWin39: TFileNameEdit;
    FileWin40: TFileNameEdit;
    FileWin41: TFileNameEdit;
    FileWin42: TFileNameEdit;
    FileWin43: TFileNameEdit;
    FileWin44: TFileNameEdit;
    FileWin45: TFileNameEdit;
    FileWin46: TFileNameEdit;
    FileWin47: TFileNameEdit;
    FileWin48: TFileNameEdit;
    FileWin49: TFileNameEdit;
    FileWin50: TFileNameEdit;
    FileWin51: TFileNameEdit;
    FileWin52: TFileNameEdit;
    FileWin53: TFileNameEdit;
    FileWin54: TFileNameEdit;
    FileWin55: TFileNameEdit;
    FileWin56: TFileNameEdit;
    FileWin57: TFileNameEdit;
    FileWin58: TFileNameEdit;
    FileWin59: TFileNameEdit;
    FileWin60: TFileNameEdit;
    FileWin61: TFileNameEdit;
    FileBase: TFileNameEdit;
    FilterComboBox: TFilterComboBox;
    ibd_BASE: TIBDatabase;
    IBT_BASE: TIBTransaction;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label2: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Label3: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    Label33: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    OnFormInfoIni: TOnFormInfoIni;
    PanelBottom: TPanel;
    Panel10: TPanel;
    Panel11: TPanel;
    Panel12: TPanel;
    Panel13: TPanel;
    Panel14: TPanel;
    Panel15: TPanel;
    Panel16: TPanel;
    Panel17: TPanel;
    Panel18: TPanel;
    Panel19: TPanel;
    Panel2: TPanel;
    Panel20: TPanel;
    Panel21: TPanel;
    Panel22: TPanel;
    Panel23: TPanel;
    Panel24: TPanel;
    Panel25: TPanel;
    Panel26: TPanel;
    Panel27: TPanel;
    Panel28: TPanel;
    Panel29: TPanel;
    Panel3: TPanel;
    Panel30: TPanel;
    Panel31: TPanel;
    Panel32: TPanel;
    Panel33: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    Panel8: TPanel;
    Panel9: TPanel;
    IBQ_VersionBase: TIBSQL;
    UniqueInstance: TUniqueInstance;
    procedure CreerClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure SeeClick(Sender: TObject);
  private
    function CreeContext:Boolean;
    procedure CreerIniFromObject(const Sender: TObject);
    { Déclarations privées }
  public
    { Déclarations publiques }
    procedure AutoCreeIni ( const as_FileName : String ; const as_Name : String );
    procedure CreeIni ( const as_FileName : String ; const aPackage : TPackageType; const aar_Architecture : TArchitectureType ; const aProcType : TProcessorType );
  public
    { Déclarations publiées }
    procedure CreerUnIni(Sender: TObject);
  end;

var
  Form1: TForm1;

implementation


uses LConvEncoding,
     FileUtil,
     IniFiles,
     strutils,
     IBIntf,
     fonctions_net,
     fonctions_file,
     md5;

{ TForm1 }

procedure TForm1.CreerClick(Sender: TObject);
var i : Integer;
    lcom_Component : TComponent;
begin
 if CreeContext Then
 for i := 0 to ComponentCount - 1 do
   Begin
    lcom_Component := Components[i];
    if  ( lcom_Component is TButton )
    and (( lcom_Component as TControl ).Parent <> PanelBottom )
     Then  CreerIniFromObject( lcom_Component );
   end;
end;


procedure TForm1.CreerUnIni(Sender: TObject);
var i : Integer;
    lcon_Control : TControl;
Begin
 if CreeContext Then
   CreerIniFromObject ( Sender );
end;

procedure TForm1.CreerIniFromObject(const Sender: TObject);
var i : Integer;
    lcon_Control : TControl;
Begin
 with ( Sender as TControl ) do
 for i := 0 to Parent.ControlCount - 1 do
   Begin
    lcon_Control := Parent.Controls[i];
    if   ( lcon_Control is TFileNameEdit )
    and (( lcon_Control as TFileNameEdit ).FileName > '' )
     Then
       AutoCreeIni (( lcon_Control as TFileNameEdit ).FileName, Name );
   end;
end;

procedure TForm1.FormCreate(Sender: TObject);
var i : Integer;
    lcom_Component : TComponent;
begin
  for i := 0 to ComponentCount - 1 do
   Begin
    lcom_Component := Components[i];
    if  ( lcom_Component is TButton )
    and not assigned (( lcom_Component as TButton ).OnClick )
     Then ( lcom_Component as TButton ).OnClick := TNotifyEvent ( CreerUnIni );
   end;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  try
    if IBT_BASE.Active Then
      IBT_BASE.Rollback;
    ibd_BASE.Close;
  except
    ibd_BASE.Free;
  end;
end;


procedure TForm1.SeeClick(Sender: TObject);
begin
  p_OpenFileOrDirectory(DirectoryDest.Directory);
end;

procedure TForm1.AutoCreeIni(const as_FileName : String ; const as_Name: String);
var lPackage : TPackageType;
    lar_Architecture : TArchitectureType;
    lProcType : TProcessorType ;
begin
  if pos ( 'Win', as_Name ) > 0 Then
   lPackage:=ptExe;
  if pos ( 'Deb', as_Name ) > 0 Then
   lPackage:=ptDeb;
  if pos ( 'MAC', as_Name ) > 0 Then
   lPackage:=ptDmg;
  if pos ( 'Redhat', as_Name ) > 0 Then
   lPackage:=ptRpm;
  if pos ( 'Tar', as_Name ) > 0 Then
   lPackage:=ptTar;
  if pos ( 'i386', as_Name ) > 0 Then
   Begin
    lProcType := ptIntel;
    lar_Architecture:=at32;
   end;
  if pos ( 'i64', as_Name ) > 0 Then
   Begin
    lProcType := ptIntel;
    lar_Architecture:=at64;
   end;
  if pos ( 'ARM', as_Name ) > 0 Then
   Begin
    lProcType := ptARM;
    lar_Architecture:=at32;
   end;
  if pos ( 'PPC', as_Name ) > 0 Then
   Begin
    lProcType := ptPPC;
    lar_Architecture:=at32;
   end;
  CreeIni ( as_FileName, lPackage, lar_Architecture, lProcType );
end;
function TForm1.CreeContext:Boolean;
var Admin : Boolean;
begin
  Admin := True;
  with ibd_BASE,Params do
  if not Connected Then
  begin
    Clear;
    Add('user_name='+UserName.Text);
    Add('password='+PassWord.Text);
    Add('lc_ctype=UTF8');
    DatabaseName:=FileBase.FileName;
    Open;
    IBT_BASE.Active:=True;
   end;
  if not DirectoryExistsUTF8(DirectoryExe.Directory)
  or not DirectoryExistsUTF8 ( DirectoryDest.Directory )
   then
    Begin
     MessageDlg('Bottom panel not filled.', 'Please fill bottom panel.',mtError,[mbOK],0);
     Result:=False;
     Exit;
    end;
  Result:=True;
end;

procedure TForm1.CreeIni(const as_FileName : String ; const aPackage: TPackageType;
  const aar_Architecture: TArchitectureType; const aProcType : TProcessorType );
var Ainifile : TIniFile;
    AVersionExe,
    AIniFileName : String ;
begin
 Ainifile := TIniFile.Create(DirectoryExe.Directory+DirectorySeparator+'Ancestromania.ini');
 with Ainifile do
 try
  IniVersionExe(Ainifile);
  AIniFileName := fs_GetIniFileNameUpdate(aar_Architecture,aPackage,aProcType, 'Update');
  if DirectoryExistsUTF8 ( DirectoryDest.Directory ) Then
   Begin
    Ainifile.Free;
    if FileExistsUTF8(DirectoryDest.Directory+DirectorySeparator+AIniFilename) Then
      DeleteFileUTF8(DirectoryDest.Directory+DirectorySeparator+AIniFilename);
    Ainifile:=TIniFile.Create(DirectoryDest.Directory+DirectorySeparator+AIniFilename);
   end;
  Ainifile.WriteString(INI_FILE_UPDATE,INI_FILE_UPDATE_FILE_NAME,ExtractFileName(as_FileName));
  AVersionExe := fs_VersionExe;
  Ainifile.WriteString(INI_FILE_UPDATE,INI_FILE_UPDATE_VERSION,Copy(AVersionExe,1,PosEx('.',AVersionExe,Pos('.',AVersionExe)+1)-1));
  Ainifile.WriteString(INI_FILE_UPDATE,INI_FILE_UPDATE_EXE_VERSION,AVersionExe);
  Ainifile.WriteString(INI_FILE_UPDATE,INI_FILE_UPDATE_FILE_SIZE,IntToStr(FileSize(as_FileName)));
  Ainifile.WriteString(INI_FILE_UPDATE,INI_FILE_UPDATE_DATE,DateTimeToStr(Now));
  if DirectoryExistsUTF8(ExtractFileNameWithoutExt(as_FileName))
   Then Ainifile.WriteString(INI_FILE_UPDATE,INI_FILE_UPDATE_FILE_SIZE_UNCOMPRESSED,IntToStr(DirSize(ExtractFileNameWithoutExt(as_FileName))))
   Else Ainifile.WriteString(INI_FILE_UPDATE,INI_FILE_UPDATE_FILE_SIZE_UNCOMPRESSED,IntToStr(FileSize(as_FileName)));
  Ainifile.WriteString(INI_FILE_UPDATE,INI_FILE_UPDATE_MD5,MD5Print(MD5File(as_FileName)));
  if ibd_BASE.Connected Then
   Begin
    IBQ_VersionBase.Close;
    IBQ_VersionBase.ExecQuery;
    Ainifile.WriteString(INI_FILE_UPDATE,INI_FILE_UPDATE_BASE_VERSION,Trim(IBQ_VersionBase.Fields[0].AsString));
   End;
  Ainifile.UpdateFile;
 finally
   Ainifile.Free;
 end;
end;

procedure p_setLibrary (var libname: string);
var Alib : String;
    version : String;
Begin
  {$IFDEF WINDOWS}
  libname:= 'fbclient'+CST_EXTENSION_LIBRARY;
  {$ELSE}
  Alib := 'libfbembed';
  version := '.2.5';
  libname:= ExtractFileDir(Application.ExeName)+DirectorySeparator+Alib+CST_EXTENSION_LIBRARY;
  if not FileExistsUTF8(libname)
    Then libname:='/usr/lib/'+Alib + CST_EXTENSION_LIBRARY + version;
  if not FileExistsUTF8(libname)
    Then libname:='/usr/lib/'+Alib + CST_EXTENSION_LIBRARY;
  if not FileExistsUTF8(libname)
    Then libname:='/usr/lib/i386-linux-gnu/'+Alib + CST_EXTENSION_LIBRARY + version;
  if not FileExistsUTF8(libname)
    Then libname:='/usr/lib/x86_64-linux-gnu/'+Alib + CST_EXTENSION_LIBRARY + version;
  if FileExistsUTF8(libname)
  and FileExistsUTF8(ExtractFileDir(Application.ExeName)+DirectorySeparator+'exec.sh"') Then
     fs_ExecuteProcess('sh',' "'+ExtractFileDir(Application.ExeName)+DirectorySeparator+'exec.sh"');
  {$ENDIF}
end;


initialization
  OnGetLibraryName:=TOnGetLibraryName(p_setLibrary);

end.

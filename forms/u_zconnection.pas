unit u_zconnection;

{$IFDEF FPC}
{$mode Delphi}
{$R *.lfm}
{$ELSE}
{$R *.dfm}
{$ENDIF}


{$I ..\DLCompilers.inc}
{$I ..\extends.inc}

// Unit U_ZConnection
// Auto connexion ZEOS with inifile
// Autor : Matthieu GIROUX
// Just have to call the function fb_InitZConnection
// Licence GNU GPL

interface

uses
{$IFNDEF FPC}
  JvExControls,
{$ENDIF}
{$IFDEF DELPHI_9_UP}
     WideStrings ,
{$ENDIF}
{$IFDEF VERSIONS}
  fonctions_version,
{$ENDIF}
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs,
  StdCtrls, IniFiles;

const
{$IFDEF VERSIONS}
  gVer_zconnection : T_Version = ( Component : 'Connexion ZEOS' ; FileUnit : 'u_zconnection' ;
                        			                 Owner : 'Matthieu Giroux' ;
                        			                 Comment : 'Fenetre de connexion ZEOS si pas dans l''INI.' ;
                        			                 BugsStory : 'Version 0.0.5.1 : No JvXPButton.' + #13#10
                                                                    + 'Version 0.0.5.0 : Fenetre avec les drivers et le codepage.' + #13#10
                                                                    + 'Version 0.0.4.0 : Fenetre sans les drivers.';
                        			                 UnitType : 3 ;
                        			                 Major : 0 ; Minor : 0 ; Release : 5 ; Build : 1 );
{$ENDIF}

      CST_ZCONNECTION = 'ZConnection';
      CST_ZDATABASE   = 'Database';
      CST_ZPROTOCOL   = 'Protocol';
      CST_ZHOSTNAME   = 'HostName';
      CST_ZCONNECTED  = 'Connected';
      CST_ZPASSWORD   = 'Password';
      CST_ZUSER       = 'User';
      CST_ZCATALOG    = 'Catalog';
      CST_ZPROPERTIES = 'Properties';

type

  { TF_ZConnectionWindow }

  TF_ZConnectionWindow = class(TForm)
    cbx_Protocol: TComboBox;
    Label7: TLabel;
    quit: TButton;
    Save: TButton;
    quitall: TButton;
    Test: TButton;
    ed_Base: TEdit;
    ed_Host: TEdit;
    ed_Password: TEdit;
    ed_User: TEdit;
    ed_Catalog: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    ed_Collation: TEdit;
    lb_Collation: TLabel;
    procedure quitallClick(Sender: TObject);
    procedure quitClick(Sender: TObject);
    procedure SaveClick(Sender: TObject);
    procedure TestClick(Sender: TObject);
    procedure ed_HostEnter(Sender: TObject);
    procedure ed_BaseEnter(Sender: TObject);
    procedure ed_UserEnter(Sender: TObject);
    procedure ed_PasswordEnter(Sender: TObject);
    procedure ed_CatalogEnter(Sender: TObject);
    procedure ed_CollationEnter(Sender: TObject);
  private
    { private declarations }
    Connexion : TComponent ;
    Inifile : TCustomInifile;
  public
    { public declarations }
    constructor Create(AOwner: TComponent); override;
    procedure DoShow; override;
  end;

var
  F_ZConnectionWindow: TF_ZConnectionWindow = nil;
  gst_TestOk : String = 'Test OK' ;
  gst_TestBad : String = 'Error' ;
  gs_DataSectionIni : String = 'Database' ;
  gs_DataDriverIni : String = 'Driver' ;
  gs_DataBaseNameIni : String = 'Database Name' ;
  gs_DataUserNameIni : String = 'User Name' ;
  gs_DataHostIni : String = 'Host Name' ;
  gs_DataCatalogIni : String = 'Catalog' ;
  gs_DataPasswordIni : String = 'Password' ;
  gs_DataProtocolIni : String = 'Protocol' ;
  gs_DataCollationIni : String = 'Collation Encode' ;

procedure p_SetCaractersZEOSConnector(const azco_Connect : TComponent ; const as_NonUtfChars : String );
procedure p_ShowZConnectionWindow ( const Connexion : TComponent ; const Inifile : TCustomInifile );
function  fb_InitZConnection ( const Connexion : TComponent ; const Inifile : TCustomInifile ; const Test : Boolean ) : String;
procedure p_IniTComponent ( const Connexion : TComponent ; const Inifile : TCustomInifile ; const Test : Boolean );
function fb_TesTComponent ( const Connexion : TComponent ; const lb_ShowMessage : Boolean ) : Boolean;
function fs_CollationEncode ( const Connexion : TComponent ) : String;

implementation

uses fonctions_init,Types, fonctions_db, fonctions_dbcomponents,
     fonctions_components, ZClasses, ZDbcIntfs, fonctions_proprietes;


{ TF_ZConnectionWindow }

// Test Mode
procedure TF_ZConnectionWindow.TestClick(Sender: TObject);
begin
  p_SetComponentProperty ( Connexion, CST_ZDATABASE, ed_Base     .Text );
  p_SetComponentProperty ( Connexion, CST_ZPROTOCOL, cbx_Protocol.Text );
  p_SetComponentProperty ( Connexion, CST_ZHOSTNAME, ed_Host     .Text );
  p_SetComponentProperty ( Connexion, CST_ZPASSWORD, ed_Password .Text );
  p_SetComponentProperty ( Connexion, CST_ZUSER    , ed_User     .Text );
  p_SetComponentProperty ( Connexion, CST_ZCATALOG , ed_Catalog  .Text );
  fb_TesTComponent ( Connexion, True );
end;


// Getting Drivers Names
constructor TF_ZConnectionWindow.Create(AOwner: TComponent);
var
  I, J: Integer;
  Drivers: IZCollection;
  Protocols: TStringDynArray;
begin
  inherited Create(AOwner);
  Drivers := DriverManager.GetDrivers;
  Protocols := nil;
  for I := 0 to Drivers.Count - 1 do
  begin
    Protocols := (Drivers[I] as IZDriver).GetSupportedProtocols;
    for J := Low(Protocols) to High(Protocols) do
      cbx_Protocol.Items.Append(Protocols[J]);
  End;
end;

procedure TF_ZConnectionWindow.DoShow;
begin
  ed_Base     .Text := fs_getComponentProperty( Connexion, CST_ZDATABASE );
  cbx_Protocol.Text := fs_getComponentProperty( Connexion, CST_ZPROTOCOL );
  ed_Host     .Text := fs_getComponentProperty( Connexion, CST_ZHOSTNAME );
  ed_Password .Text := fs_getComponentProperty( Connexion, CST_ZPASSWORD );
  ed_User     .Text := fs_getComponentProperty( Connexion, CST_ZUSER     );
  ed_Catalog  .Text := fs_getComponentProperty( Connexion, CST_ZCATALOG  );
  inherited DoShow;
end;


// Saving to IniFile
procedure TF_ZConnectionWindow.SaveClick(Sender: TObject);
begin
  if assigned ( IniFile )
    Then
      Begin
        IniFile.WriteString ( gs_DataSectionIni , gs_DataBaseNameIni , ed_Base     .Text  );
        IniFile.WriteString ( gs_DataSectionIni , gs_DataProtocolIni , cbx_Protocol.Text  );
        IniFile.WriteString ( gs_DataSectionIni , gs_DataHostIni     , ed_Host     .Text  );
        IniFile.WriteString ( gs_DataSectionIni , gs_DataPasswordIni , ed_Password .Text  );
        IniFile.WriteString ( gs_DataSectionIni , gs_DataUserNameIni , ed_User     .Text  );
        IniFile.WriteString ( gs_DataSectionIni , gs_DataCatalogIni  , ed_Catalog  .Text  );
        IniFile.WriteString ( gs_DataSectionIni , gs_DataCollationIni, ed_Collation.Text  );

        fb_iniWriteFile( Inifile, True );
      End;
  Close;
end;

// Quit application
procedure TF_ZConnectionWindow.quitallClick(Sender: TObject);
begin
  Application.Terminate;
end;

// Close Window
procedure TF_ZConnectionWindow.quitClick(Sender: TObject);
begin
  Close;
end;

// Procédures and functions

// Open connexion and erros
function fb_TesTComponent ( const Connexion : TComponent ; const lb_ShowMessage : Boolean ) : Boolean;
Begin
  Result := False ;
  try
    p_SetComponentBoolProperty ( Connexion, CST_ZCONNECTED, True );
  Except
    on E: Exception do
      Begin
        if lb_ShowMessage Then
          ShowMessage ( gst_TestBad + ' : ' + #13#10 + E.Message );
        Exit ;
      End ;
  End ;
  if fb_getComponentBoolProperty( Connexion, CST_ZCONNECTED ) Then
    Begin
      Result := True ;
      if lb_ShowMessage Then
        ShowMessage ( gst_TestOk );
    End ;
End ;

// Init connexion with inifile
function fs_CollationEncode ( const Connexion : TComponent ) : String;
var ls_Prop   : String ;
    li_i      ,
    li_equal  : Integer ;
    astl_Strings : TStrings ;
    {$IFDEF DELPHI_9_UP}awst_Strings : TWideStrings;{$ENDIF}
Begin
  Result := 'utf8';
  if  fb_GetStrings ( Connexion, CST_ZPROPERTIES, astl_Strings{$IFDEF DELPHI_9_UP}, awst_Strings {$ENDIF}) Then
  for li_i := 0 to astl_Strings.Count - 1 do
    Begin
      ls_Prop := astl_Strings [ li_i ];
      li_equal := pos ( '=', ls_Prop);
      if  ( pos ( 'codepage', LowerCase(ls_Prop)) > 0 )
      and ( li_equal > 0 )
      and ( li_equal + 1 < length ( ls_prop ) )
       Then
         Begin
           Result := Copy ( ls_prop, li_equal +1, length ( ls_prop ));
         End;
    End;
End;
// Init connexion with inifile
function fb_InitZConnection ( const Connexion : TComponent ; const Inifile : TCustomInifile ; const Test : Boolean ) : String;
Begin
  p_IniTComponent ( Connexion, Inifile, Test );
  Result := gs_DataHostIni      + ' = ' +  fs_getComponentProperty( Connexion, CST_ZHOSTNAME )  + #13#10
          + gs_DataProtocolIni  + ' = ' +  fs_getComponentProperty( Connexion, CST_ZPROTOCOL ) + #13#10
          + gs_DataBaseNameIni  + ' = ' +  fs_getComponentProperty( Connexion, CST_ZDATABASE ) + #13#10
          + gs_DataUserNameIni  + ' = ' +  fs_getComponentProperty( Connexion, CST_ZUSER     ) + #13#10
          + gs_DataPasswordIni  + ' = ' +  fs_getComponentProperty( Connexion, CST_ZPASSWORD ) + #13#10
          + gs_DataCatalogIni   + ' = ' +  fs_getComponentProperty( Connexion, CST_ZCATALOG  ) + #13#10
          + gs_DataCollationIni + ' = ' +  fs_CollationEncode ( Connexion )   + #13#10 ;
End ;

// Init connexion with inifile
procedure p_IniTComponent ( const Connexion : TComponent ; const Inifile : TCustomInifile ; const Test : Boolean );
Begin
  if assigned ( Inifile )
  and assigned ( Connexion ) Then
    Begin
      p_SetComponentProperty ( Connexion, CST_ZDATABASE, Inifile.ReadString ( gs_DataSectionIni, gs_DataBaseNameIni, '' ));
      p_SetComponentProperty ( Connexion, CST_ZPROTOCOL, Inifile.ReadString ( gs_DataSectionIni, gs_DataProtocolIni , '' ));
      p_SetComponentProperty ( Connexion, CST_ZHOSTNAME, Inifile.ReadString ( gs_DataSectionIni, gs_DataHostIni    , '' ));
      p_SetComponentProperty ( Connexion, CST_ZPASSWORD, Inifile.ReadString ( gs_DataSectionIni, gs_DataPasswordIni, '' ));
      p_SetComponentProperty ( Connexion, CST_ZUSER    , Inifile.ReadString ( gs_DataSectionIni, gs_DataUserNameIni, '' ));
      p_SetComponentProperty ( Connexion, CST_ZCATALOG , Inifile.ReadString ( gs_DataSectionIni, gs_DataCatalogIni    , '' ));
      p_SetCaractersZEOSConnector(Connexion, Inifile.ReadString ( gs_DataSectionIni, gs_DataCollationIni    , Inifile.ReadString ( gs_DataSectionIni, gs_DataCollationIni    , 'UTF8' )));
    End ;
  if ( fs_getComponentProperty( Connexion, CST_ZDATABASE ) = '' )
  or not ( fb_TesTComponent ( Connexion, Test )) Then
    Begin
      p_ShowZConnectionWindow ( Connexion, Inifile );
    End ;
End ;

// Show The Window ( automatic )
procedure p_ShowZConnectionWindow ( const Connexion : TComponent ; const Inifile : TCustomInifile );
Begin
  if not assigned ( F_ZConnectionWindow )
    Then
      Application.CreateForm ( TF_ZConnectionWindow, F_ZConnectionWindow );
  F_ZConnectionWindow.Connexion := Connexion;
  F_ZConnectionWindow.Inifile := Inifile;
  F_ZConnectionWindow.ShowModal ;
End ;

procedure TF_ZConnectionWindow.ed_HostEnter(Sender: TObject);
begin
  p_ComponentSelectAll ( Sender );
end;

procedure TF_ZConnectionWindow.ed_BaseEnter(Sender: TObject);
begin
  p_ComponentSelectAll ( Sender );

end;

procedure TF_ZConnectionWindow.ed_UserEnter(Sender: TObject);
begin
  p_ComponentSelectAll ( Sender );

end;

procedure TF_ZConnectionWindow.ed_PasswordEnter(Sender: TObject);
begin
  p_ComponentSelectAll ( Sender );

end;

procedure TF_ZConnectionWindow.ed_CatalogEnter(Sender: TObject);
begin
  p_ComponentSelectAll ( Sender );

end;

procedure TF_ZConnectionWindow.ed_CollationEnter(Sender: TObject);
begin
  p_ComponentSelectAll ( Sender );

end;

procedure p_SetCaractersZEOSConnector(const azco_Connect : TComponent ; const as_NonUtfChars : String );
var
    astl_Strings : TStrings ;
    {$IFDEF DELPHI_9_UP}awst_Strings : TWideStrings;{$ENDIF}
Begin
  if  fb_GetStrings (azco_Connect, CST_ZPROPERTIES, astl_Strings{$IFDEF DELPHI_9_UP}, awst_Strings {$ENDIF}) Then
    with  astl_Strings do
      begin
        Clear;
        Add('codepage='+as_NonUtfChars);
      end;
end;

initialization
{$IFDEF VERSIONS}
  p_ConcatVersion ( gVer_zconnection );
{$ENDIF}

end.


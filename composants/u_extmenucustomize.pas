unit u_extmenucustomize;

{$IFDEF FPC}
{$mode Delphi}
{$ENDIF}

{$I ..\Compilers.inc}
{$I ..\extends.inc}

interface

uses
  Classes, SysUtils, ComCtrls, Menus, u_extmenutoolbar,
{$IFDEF VERSIONS}
  fonctions_version,
{$ENDIF}
  Forms;

const MENUINI_SECTION_BEGIN = 'CustomizedMenu.' ;
  {$IFDEF VERSIONS}
      gVer_TExtMenuCustomize : T_Version = ( Component : 'Composant TExtMenuCustomize' ;
                                                 FileUnit : 'u_extmenucustomize' ;
                                                 Owner : 'Matthieu Giroux' ;
                                                 Comment : 'Gestion de l''ini pour un menu avec appel à la fenêtre de personnalisation.' ;
                                                 BugsStory : '0.9.0.0 : Gestion de beaucoup de composants.';
                                                 UnitType : 3 ;
                                                 Major : 0 ; Minor : 9 ; Release : 0 ; Build : 0 );

  {$ENDIF}
type

  { TExtMenuToolBar }

  { TExtMenuCustomize }

  TExtMenuCustomize = class(TComponent)
  private
    FMenuIni, FMainMenu : TMenu;
    FOldClose : TCloseEvent;
  protected
    procedure Loaded; override;
    procedure LoadAMenuNode ( const AMenuItem : TMenuItem ; const ALoadLevel : Boolean); virtual;
    procedure SaveAMenuNode ( const AMenuItem : TMenuItem ; const ASaveLevel : Boolean); virtual;
  public
    constructor Create(TheOwner: TComponent); override;
    procedure LoadIni; virtual;
    procedure SaveIni; virtual;
    destructor Destroy; override;
    procedure Click; virtual;
  published
    procedure DoClose ( AObject : TObject; var CloseAction : TCloseAction ); virtual;
    property MenuIni : TMenu read FMenuIni write FMenuIni;
    property MainMenu : TMenu read FMainMenu write FMainMenu;
  end;

implementation

uses unite_messages, Controls, Graphics,
  {$IFDEF VIRTUALTREES}
   U_CustomizeMenu,
  {$ENDIF}
   fonctions_init, fonctions_objects;

{ TExtMenuCustomize }

procedure TExtMenuCustomize.Loaded;
begin
  inherited Loaded;
  LoadIni;
end;

procedure TExtMenuCustomize.LoadAMenuNode(const AMenuItem: TMenuItem; const ALoadLevel : Boolean);
var i : Integer;
begin
  if ALoadLevel
  and f_IniReadSectionBol(MENUINI_SECTION_BEGIN+FMenuIni.Name, AMenuItem.Name, False )
   Then
    Begin
      FMenuIni.Items.Add ( fmi_CloneMenuItem ( AMenuItem, FMenuIni ));
    end;
  for i := 0 to AMenuItem.Count - 1 do
    Begin
      LoadAMenuNode(AMenuItem [ i ], True);
    end;
end;

procedure TExtMenuCustomize.SaveAMenuNode(const AMenuItem: TMenuItem; const ASaveLevel : Boolean);
var i : Integer;
begin
  if ASaveLevel Then
    p_IniWriteSectionBol(MENUINI_SECTION_BEGIN+FMenuIni.Name, AMenuItem.Name, True );
  for i := 0 to AMenuItem.Count - 1 do
    Begin
      SaveAMenuNode(AMenuItem [ i ], True);
    end;
end;

constructor TExtMenuCustomize.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  If TheOwner is TCustomForm Then
    Begin
      FOldClose := (TheOwner as TCustomForm).OnClose;
      (TheOwner as TCustomForm).OnClose := DoClose;
    end;
end;

procedure TExtMenuCustomize.LoadIni;
begin
  if  assigned ( FMenuIni )
  and assigned ( FMainMenu )
   Then
    Begin
      FIniFile := f_GetMemIniFile;
      if assigned ( FIniFile )
      and FIniFile.SectionExists(MENUINI_SECTION_BEGIN+FMenuIni.Name)
       Then
        Begin
          FMenuIni.Items.Clear;
          LoadAMenuNode(FMainMenu.Items, False);
        end;
    end;
end;

procedure TExtMenuCustomize.SaveIni;
begin
  if  assigned ( FMenuIni )
   Then
    Begin
      FIniFile := f_GetMemIniFile;
      if assigned ( FIniFile )
       Then
        Begin
          FIniFile.EraseSection(MENUINI_SECTION_BEGIN+FMenuIni.Name);
          SaveAMenuNode(FMenuIni.Items, False);
        end;
    end;
end;

destructor TExtMenuCustomize.Destroy;
begin
  inherited Destroy;
  If Owner is TCustomForm Then
    Begin
      (Owner as TCustomForm).OnClose := FOldClose;
    end;
end;

procedure TExtMenuCustomize.Click;
begin
  {$IFDEF VIRTUALTREES}
  if not assigned ( F_CustomizeMenu )
   Then
    F_CustomizeMenu := TF_CustomizeMenu.Create(Application);
  F_CustomizeMenu.MenuCustomize := Self;
  F_CustomizeMenu.ShowModal;
  {$ENDIF}
end;

procedure TExtMenuCustomize.DoClose ( AObject : TObject; var CloseAction : TCloseAction );
begin
  if MenuIni.Items.Count > 0 Then
    SaveIni;
end;


{$IFDEF VERSIONS}
initialization
  p_ConcatVersion ( gVer_TExtMenuCustomize );
{$ENDIF}
end.


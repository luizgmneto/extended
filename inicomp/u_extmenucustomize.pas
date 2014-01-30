unit u_extmenucustomize;

{$IFDEF FPC}
{$mode Delphi}
{$ENDIF}

{$I ..\extends.inc}

interface

uses
  Classes, Menus,
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
                                                 BugsStory : '0.9.0.0 : Gestion en place.';
                                                 UnitType : 3 ;
                                                 Major : 0 ; Minor : 9 ; Release : 0 ; Build : 0 );

  {$ENDIF}
type

  { TExtMenuCustomize }
  TExtMenuCustomize = class(TComponent)
  private
    FAutoIni : Boolean;
    FMenuIni, FMainMenu : TMenu;
    FOnMenuChange : TNotifyEvent;
  protected
    procedure Loaded; override;
    procedure LoadAMenuNode ( const AMenuItemToCopy, AMenuParent : TMenuItem ; const ALoadLevel : Boolean ; const EndSection : String ); virtual;
    procedure SaveAMenuNode ( const AMenuItem : TMenuItem ; const ASaveLevel : Boolean ; const EndSection : String ); virtual;
  public
    constructor Create(TheOwner: TComponent); override;
    function  LoadIni ( const EndSection : String = '' ) : Boolean; virtual;
    function  SaveIni ( const EndSection : String = '' ) : Boolean; virtual;
    procedure Click; virtual;
    procedure MenuChange; virtual;
  published
    property AutoIni : Boolean read FAutoIni write FAutoIni default True;
    property MenuIni : TMenu read FMenuIni write FMenuIni;
    property MainMenu : TMenu read FMainMenu write FMainMenu;
    property OnMenuChange : TNotifyEvent read FOnMenuChange write FOnMenuChange;
  end;

implementation

uses
  {$IFDEF VIRTUALTREES}
   U_CustomizeMenu,
  {$ENDIF}
   fonctions_init, fonctions_objects;

{ TExtMenuCustomize }

procedure TExtMenuCustomize.Loaded;
begin
  inherited Loaded;
  if FAutoIni Then
    LoadIni;
end;

procedure TExtMenuCustomize.LoadAMenuNode(const AMenuItemToCopy, AMenuParent: TMenuItem; const ALoadLevel : Boolean; const EndSection : String );
var i : Integer;
    LMenuToAdd : TMenuItem ;
begin
  if ALoadLevel
  and f_IniReadSectionBol(MENUINI_SECTION_BEGIN+FMenuIni.Name+EndSection, AMenuItemToCopy.Name, False )
   Then
    Begin
      LMenuToAdd := fmi_CloneMenuItem ( AMenuItemToCopy, FMenuIni );
      AMenuParent.Add ( LMenuToAdd );
    end
   Else
    LMenuToAdd := AMenuParent;
  for i := 0 to AMenuItemToCopy.Count - 1 do
    Begin
      LoadAMenuNode(AMenuItemToCopy [ i ], LMenuToAdd, True, EndSection);
    end;
end;

procedure TExtMenuCustomize.SaveAMenuNode(const AMenuItem: TMenuItem; const ASaveLevel : Boolean; const EndSection : String );
var i : Integer;
begin
  if ASaveLevel Then
    p_IniWriteSectionBol(MENUINI_SECTION_BEGIN+FMenuIni.Name+EndSection, AMenuItem.Name, True );
  for i := 0 to AMenuItem.Count - 1 do
    Begin
      SaveAMenuNode(AMenuItem [ i ], True, EndSection);
    end;
end;

constructor TExtMenuCustomize.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  FAutoIni := True;
  FMenuIni := nil;
  FMainMenu := nil;
end;

function TExtMenuCustomize.LoadIni ( const EndSection : String = '' ): Boolean;
begin
  Result := False;
  if  assigned ( FMenuIni )
  and assigned ( FMainMenu )
   Then
    Begin
      FIniFile := f_GetMemIniFile;
      if assigned ( FIniFile ) Then
        if FIniFile.SectionExists(MENUINI_SECTION_BEGIN+FMenuIni.Name + EndSection)
         Then
          Begin
            Result := True;
            FMenuIni.Items.Clear;
            LoadAMenuNode(FMainMenu.Items, FMenuIni.Items, False, EndSection);
            MenuChange;
          end
        Else
         SaveIni ( EndSection );
    end;
end;

function TExtMenuCustomize.SaveIni ( const EndSection : String = '' ): Boolean;
begin
  Result := False;
  FIniFile := f_GetMemIniFile;
  if assigned ( FIniFile )
   Then
    Begin
      Result := True;
      FIniFile.EraseSection(MENUINI_SECTION_BEGIN+FMenuIni.Name + EndSection);
      SaveAMenuNode(FMenuIni.Items, False, EndSection);
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
  MenuChange;
  {$ENDIF}
  if FAutoIni
  and assigned ( FMenuIni )
  and ( FMenuIni.Items.Count > 0 ) Then
    SaveIni;
end;

procedure TExtMenuCustomize.MenuChange;
begin
  if Assigned(FOnMenuChange) Then
   FOnMenuChange ( Self );
end;

{$IFDEF VERSIONS}
initialization
  p_ConcatVersion ( gVer_TExtMenuCustomize );
{$ENDIF}
end.


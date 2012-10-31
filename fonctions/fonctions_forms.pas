unit fonctions_forms;
// Unité de la Version 2 du projet FormMain
// La version 1 TFormMain n'est pas sa fenêtre parente

// Le module crée des propriété servant à la gestion du fichier INI
// Il gère la déconnexion
// Il gère la gestion des touches majuscules et numlock
// Il gère les forms enfants
// créé par Matthieu Giroux en décembre 2007

{$I ..\DLCompilers.inc}
{$I ..\extends.inc}

interface

{$IFDEF FPC}
{$mode Delphi}
{$ENDIF}

uses
{$IFDEF SFORM}
  CompSuperForm,
{$ENDIF}
  {$IFDEF EADO}
     ADODB,
  {$ENDIF}
{$IFDEF VERSIONS}
  fonctions_version,
{$ENDIF}
{$IFDEF TNT}
  TNTForms,
{$ENDIF}
  SysUtils, Variants, Classes, Graphics, Controls, Forms,
{$IFDEF FPC}
  LCLIntf, LCLType,
{$ELSE}
  Windows, OleDb, Messages,
{$ENDIF}
  Dialogs, ExtCtrls, fonctions_init;

{$IFDEF VERSIONS}
  const
    gVer_fonctions_forms : T_Version = (  Component : 'Gestion de Fenêtres' ;
                                       FileUnit : 'fonctions_forms' ;
                                       Owner : 'Matthieu Giroux' ;
                                       Comment : 'Fiche principale deuxième version.' ;
                                       BugsStory : '1.0.0.0 : Windows management from FormMainIni.';
                                       UnitType : 3 ;
                                       Major : 1 ; Minor : 0 ; Release : 0 ; Build : 0 );

{$ENDIF}
  type
    { TRegGroup }

    TRegGroup = class
    private
      FClassList: TList;
      FAliasList: TStringList;
      FGroupClasses: TList;
      FActive: Boolean;
      function BestClass(AClass: TPersistentClass): TPersistentClass;
    public
      // constrcuteur
      constructor Create(AClass: TPersistentClass);
      // destructeur
      destructor Destroy; override;
      class function BestGroup(Group1, Group2: TRegGroup; AClass: TPersistentClass): TRegGroup;
      // Ajoute un type de classe
      // AClass : type de classe
      procedure AddClass(AClass: TPersistentClass);
      function GetClass(const AClassName: string): TPersistentClass;
  {$IFDEF DELPHI}
      procedure GetClasses(Proc: TGetClass);
      procedure UnregisterModuleClasses(Module: HMODULE);
  {$ENDIF}
      function InGroup(AClass: TPersistentClass): Boolean;
      procedure RegisterClass(AClass: TPersistentClass);
      procedure RegisterClassAlias(AClass: TPersistentClass; const Alias: string);
      function Registered(AClass: TPersistentClass): Boolean;
      procedure UnregisterClass(AClass: TPersistentClass);
      property Active: Boolean read FActive write FActive;
    end;

    TRegGroups = class
    private
      FGroups: TList;
      FLock: TRTLCriticalSection;
      FActiveClass: TPersistentClass;
      function FindGroup(AClass: TPersistentClass): TRegGroup;
    public
      constructor Create;
      destructor Destroy; override;
      procedure Activate(AClass: TPersistentClass);
      procedure AddClass(ID: Integer; AClass: TPersistentClass);
      function GetClass(const AClassName: string): TPersistentClass;
      function GroupedWith(AClass: TPersistentClass): TPersistentClass;
      procedure GroupWith(AClass, AGroupClass: TPersistentClass);
      procedure Lock;
      procedure RegisterClass(AClass: TPersistentClass);
      procedure RegisterClassAlias(AClass: TPersistentClass; const Alias: string);
      function Registered(AClass: TPersistentClass): Boolean;
      procedure StartGroup(AClass: TPersistentClass);
      procedure Unlock;
      procedure UnregisterClass(AClass: TPersistentClass);
  {$IFDEF DELPHI}
      procedure UnregisterModuleClasses(Module: HMODULE);
  {$ENDIF}
      property ActiveClass: TPersistentClass read FActiveClass;
    end;

{$IFDEF FPC}
function ActiveMDIChild : TCustomForm;
procedure WindowMinimizeAll(Sender: TObject);
{$ENDIF}
function fb_ReinitWindow ( var afor_Form : TCustomForm ) : Boolean ;
// Récupère le code déjà tapé d'une toouche à partir du buffer virtuelle et valide ou non la touche
// Entrée : Numéro de touche
function fb_GetKeyState(aby_Key: Integer): Boolean;
// Modifie la touche
// Entrée : Numéro de touche
procedure p_SetKeyState( var at_Buffer : TKeyboardState; const aby_Key: Integer; const ab_TurnOn: Boolean);

// Création d'une form MDI renvoie la form si existe
// as_FormNom : Nom de la form ; afor_FormClasse : Classe de la form
function ffor_CreateMDIChild ( const as_FormNom : string ; afor_FormClasse : TFormClass ): TForm; overload ;
function ffor_FindForm ( const as_FormNom : string ) : TCustomForm;
procedure p_CloseForm ( const as_FormNom : string );

procedure p_SetChildForm ( const afor_Reference: TCustomForm; const  afs_newFormStyle : TFormStyle );

// Création d'une form MDI renvoie True si la form existe
// as_FormNom : Nom de la form ; afor_FormClasse : Classe de la form ; var afor_Reference : Variable de la form
function fb_CreateMDIChild ( const as_FormNom : string ; afor_FormClasse : TFormClass ; var afor_Reference; const ab_Ajuster : Boolean ): Boolean; overload ;


function ffor_getForm   ( const as_FormNom, as_FormClasse : string  ): TForm; overload ;

function ffor_getForm   ( afor_FormClasse : TFormClass ): TForm; overload ;

// Création d'une form MDI avec changement du style Form
// renvoie True si la form existe
// as_FormNom : Nom de la form ; afor_FormClasse : Classe de la form ; var afor_Reference : Variable de la form
function ffor_CreateChild ( afor_FormClasse : TFormClass; const newFormStyle : TFormStyle; const ab_Ajuster : Boolean ; const aico_Icon : TIcon ): TCustomForm;
// Création d'une form MDI renvoie True si la form existe
// as_FormNom : Nom de la form ; afor_FormClasse : Classe de la form ; var afor_Reference : Variable de la form
function fp_CreateChild ( const as_FormNom, as_FormClasse : string ; const newFormStyle : TFormStyle; const ab_Ajuster : Boolean ; const aico_Icon : TIcon ): Pointer;

// Création d'une form modal
// renvoie True si la form existe
// afor_FormClasse : Classe de la form ;
// var afor_Reference : Variable de la form
// ab_Ajuster : Ajuster automatiquement
// aact_Action : Action à la Fermeture
function fb_CreateModal ( afor_FormClasse : TFormClass ; var afor_Reference : TForm ; const ab_Ajuster : Boolean  ; const aact_Action : TCloseAction ) : Boolean ;

// changement du style d'une form
// afor_Reference    : variable de la form
// newFormStyle      : style    de la form à mettre
function fb_setNewFormStyle ( const afor_Reference : TCustomForm; const afs_newFormStyle : TFormStyle; const ab_Ajuster : Boolean  ): Boolean ; overload ;
function fb_setNewFormStyle ( const afor_Reference : TCustomForm; const afs_FormStyle: TFormStyle ; const ab_Modal : Boolean ; const awst_WindowState : TWindowState ; const apos_Position : TPosition ): Boolean; overload ;

// Procédure d'enregistrement des forms propres à l'application
procedure p_RegisterClass(AClass: TPersistentClass);
procedure p_RegisterClasses(AClasses: array of TPersistentClass);
procedure p_UnRegisterClass(AClass: TPersistentClass);
procedure p_UnRegisterClasses(AClasses: array of TPersistentClass);
{$IFDEF DELPHI}
procedure p_UnRegisterModuleClasses(Module: HMODULE);
{$ENDIF}
function fper_FindClass(const ClassName: string): TPersistentClass;
function fper_GetClass(const AClassName: string): TPersistentClass;
procedure p_InitRegisterForms;

var
  gb_ModalStarted : Boolean;
//  gb_FreeAllWindowsClosed : Boolean = False ;
  gReg_MainFormIniClassesLocales : TRegGroups = nil ;


implementation

uses fonctions_proprietes, fonctions_erreurs, TypInfo,
  {$IFDEF FPC}
  unite_messages,
  {$ELSE}
  unite_messages_delphi,
  {$ENDIF}
 fonctions_system;

{ fonctions }

procedure p_InitRegisterForms;
Begin
  gReg_MainFormIniClassesLocales := TRegGroups.Create ;
end;

{ TRegGroup }

// Ajoute un type de classe
// AClass : type de classe
procedure TRegGroup.AddClass(AClass: TPersistentClass);
begin
  FGroupClasses.Add(AClass);
end;

function TRegGroup.BestClass(AClass: TPersistentClass): TPersistentClass;
var
	I: Integer;
	Current: TPersistentClass;
begin
  Result := nil;
  for I := 0 to FGroupClasses.Count - 1 do
  begin
    Current := FGroupClasses[I];
    if AClass.InheritsFrom(Current) then
      if (Result = nil) or Current.InheritsFrom(Result) then
        Result := Current;
  end;
end;

class function TRegGroup.BestGroup(Group1, Group2: TRegGroup;
	AClass: TPersistentClass): TRegGroup;
var
	Group1Class: TPersistentClass;
	Group2Class: TPersistentClass;
begin
  if Group1 <> nil then
    Group1Class := Group1.BestClass(AClass)
   else
    Group1Class := nil;
  if Group2 <> nil then
    Group2Class := Group2.BestClass(AClass)
   else
    Group2Class := nil;
  if Group1Class = nil then
   if Group2Class = nil then
	// AClass is not in either group, no best group
     Result := nil
    else
      // AClass is in Group2 but not Group1, Group2 is best
     Result := Group2
    else
     if Group2Class = nil then
      // AClass is in Group1 but not Group2, Group1 is best
       Result := Group1
      else
       // AClass is in both groups, select the group with the closest ancestor
       if Group1Class.InheritsFrom(Group2Class) then
         Result := Group1
        else
         Result := Group2;
end;

constructor TRegGroup.Create(AClass: TPersistentClass);
begin
  inherited Create;
  FClassList := TList.Create;
  FAliasList := TStringList.Create;
  FGroupClasses := TList.Create;
  FGroupClasses.Add(AClass);
end;

destructor TRegGroup.Destroy;
begin
  inherited Destroy;
  FClassList.Free;
  FAliasList.Free;
  FGroupClasses.Free;
end;

function TRegGroup.GetClass(const AClassName: string): TPersistentClass;
var
	I: Integer;
begin
  if FClassList <> nil then
    for I := 0 to FClassList.Count - 1 do
    begin
      Result := FClassList[I];
      if Result.ClassNameIs(AClassName) then Exit;
    end;
  if FAliasList <> nil then
  begin
    I := FAliasList.IndexOf(AClassName);
    if I >= 0 then
    begin
      Result := TPersistentClass(FAliasList.Objects[I]);
      Exit;
    end;
  end;
  Result := nil;

end;

{$IFDEF DELPHI}
procedure TRegGroup.GetClasses(Proc: TGetClass);
var
  I: Integer;
begin
  for I := 0 to FClassList.Count - 1 do
    Proc(TPersistentClass(FClassList[I]));
end;
{$ENDIF}

function TRegGroup.InGroup(AClass: TPersistentClass): Boolean;
var
  I: Integer;
begin
  Result := True;
  for I := 0 to FGroupClasses.Count - 1 do
    if AClass.InheritsFrom(TPersistentClass(FGroupClasses[I])) then Exit;
  Result := False;
end;

procedure TRegGroup.RegisterClass(AClass: TPersistentClass);
var
  LClassName: string;
begin
  LClassName := AClass.ClassName;
  if GetClass(LClassName) = nil then
    FClassList.Add(AClass);
end;

procedure TRegGroup.RegisterClassAlias(AClass: TPersistentClass;
  const Alias: string);
begin
  RegisterClass(AClass);
  FAliasList.AddObject(Alias, TObject(AClass));
end;

function TRegGroup.Registered(AClass: TPersistentClass): Boolean;
begin
  Result := FClassList.IndexOf(AClass) >= 0;
end;

procedure TRegGroup.UnregisterClass(AClass: TPersistentClass);
var
  I: Integer;
begin
  FClassList.Remove(AClass);
  for I := FAliasList.Count - 1 downto 0 do
    if FAliasList.Objects[I] = TObject(AClass) then
      FAliasList.Delete(I);
end;

{$IFDEF DELPHI}


function PointerInModule(Ptr: Pointer; Module: HMODULE): Boolean;
begin
  Result := (Module = 0) or (FindHInstance(Ptr) = Module);
end;

procedure TRegGroup.UnregisterModuleClasses(Module: HMODULE);
var
  I: Integer;
begin
  // Even though the group criterion changes we do not need to recalculate the
  // groups because the groups are based on ancestry. If an ancestor of a class
  // is removed because its module was unloaded we can safely assume that all
  // descendents have also been unloaded or are being unloaded as well. This
  // means that any classes left in the registry are not descendents of the
  // classes being removed and, therefore, will not be affected by the change
  // to the FGroupClasses list.
  for I := FGroupClasses.Count - 1 downto 0 do
    if PointerInModule(FGroupClasses[I], Module) then
      FGroupClasses.Delete(I);
	for I := FClassList.Count - 1 downto 0 do
    if PointerInModule(FClassList[I], Module) then
      FClassList.Delete(I);
  for I := FAliasList.Count - 1 downto 0 do
    if PointerInModule(FAliasList.Objects[I], Module) then
      FAliasList.Delete(I);
end;

{$ENDIF}

{ TRegGroups }

procedure TRegGroups.Activate(AClass: TPersistentClass);
var
  I: Integer;
begin
  if FActiveClass <> AClass then
  begin
    FActiveClass := AClass;
    for I := 0 to FGroups.Count - 1 do
      with TRegGroup(FGroups[I]) do
        Active := InGroup(AClass);
  end;
end;

procedure TRegGroups.AddClass(ID: Integer; AClass: TPersistentClass);
begin
  TRegGroup(FGroups[ID]).AddClass(AClass);
end;

constructor TRegGroups.Create;
var
  Group: TRegGroup;
begin
  FGroups := TList.Create;
  inherited Create;
{$IFDEF FPC}InitCriticalSection{$ELSE}InitializeCriticalSection{$ENDIF}(FLock);
	// Initialize default group
  Group := TRegGroup.Create(TPersistent);
  FGroups.Add(Group);
  Group.Active := True;
end;

destructor TRegGroups.Destroy;
var
  I: Integer;
begin
  {$IFDEF FPC}System.LeaveCriticalSection{$ELSE}DeleteCriticalSection{$ENDIF}(FLock);
  for I := 0 to FGroups.Count - 1 do
    TRegGroup(FGroups[I]).Free;
  FGroups.Free;
  inherited;
end;

function TRegGroups.FindGroup(AClass: TPersistentClass): TRegGroup;
var
  I: Integer;
  Current: TRegGroup;
begin
  Result := nil;
  for I := 0 to FGroups.Count - 1 do
  begin
    Current := TRegGroup ( FGroups[I] );
    Result := TRegGroup.BestGroup(Current, Result, AClass);
  end;
end;

function TRegGroups.GetClass(const AClassName: string): TPersistentClass;
var
  I: Integer;
begin
  Result := nil;
	for I := 0 to FGroups.Count - 1 do
    with TRegGroup(FGroups[I]) do
    begin
      if Active then Result := GetClass(AClassName);
      if Result <> nil then Exit;
    end;
end;

function TRegGroups.GroupedWith(AClass: TPersistentClass): TPersistentClass;
var
  Group: TRegGroup;
begin
  Result := nil;
  Group := FindGroup(AClass);
	if Group <> nil then
    Result := TPersistentClass(Group.FGroupClasses[0]);
end;

procedure TRegGroups.GroupWith(AClass, AGroupClass: TPersistentClass);

  procedure Error;
  begin
//    raise EFilerError.CreateFmt(SUnknownGroup, [AGroupClass.ClassName]);
  end;

var
  Group: TRegGroup;
  CurrentGroup: TRegGroup;
  CurrentClass: TPersistentClass;
  I, J: Integer;
begin
  Group := FindGroup(AGroupClass);
  if Group = nil then Error;
  Group.AddClass(AClass);

	// The group criterion has changed. We need to recalculate which groups the
  // classes that have already been registered belong to. We can skip
  // Group since we would just be moving a class to a group it already belongs
  // to. We also only need to find the new group of classes that descend from
  // AClass since that is the only criterion being changed. In other words,
  // we only need to move classes that descend from AClass to Group if they
  // are in another group.
  for I := 0 to FGroups.Count - 1 do
  begin
    CurrentGroup := TRegGroup ( FGroups[I]^ );
    if CurrentGroup <> Group then
      for J := CurrentGroup.FClassList.Count - 1 downto 0 do
      begin
	CurrentClass := TPersistentClass ( CurrentGroup.FClassList[J]^ );
        if CurrentClass.InheritsFrom(AClass) then
					// Check CurrentClass should be put into Group based on the new
          // criterion. Their might be a descendent of AClass registered that
          // overrides Group's criterion.
          if FindGroup(CurrentClass) = Group then
          begin
            CurrentGroup.FClassList.Delete(J);
            Group.FClassList.Add(CurrentClass);
          end;
      end;
  end;
end;

procedure TRegGroups.Lock;
begin
{$IFDEF FPC}
  System.
{$ENDIF}
  EnterCriticalSection(FLock);
end;

procedure TRegGroups.RegisterClass(AClass: TPersistentClass);
var
  Group: TRegGroup;
begin
  Group := FindGroup(AClass);
  if Group <> nil then Group.RegisterClass(AClass);
end;

procedure TRegGroups.RegisterClassAlias(AClass: TPersistentClass;
  const Alias: string);
var
  Group: TRegGroup;
begin
  Group := FindGroup(AClass);
  if Group <> nil then Group.RegisterClassAlias(AClass, Alias);
end;

function TRegGroups.Registered(AClass: TPersistentClass): Boolean;
var
  I: Integer;
begin
  Result := True;
  for I := 0 to FGroups.Count - 1 do
    if TRegGroup(FGroups[I]).Registered(AClass) then Exit;
  Result := False;
end;

procedure TRegGroups.StartGroup(AClass: TPersistentClass);
var
  I: Integer;
begin
  // Do not start a group that already exists
  for I := 0 to FGroups.Count - 1 do
    if TRegGroup(FGroups[I]).FGroupClasses.IndexOf(AClass) >= 0 then
      Exit;
	// Create the group
  FGroups.Add(TRegGroup.Create(AClass));
end;

procedure TRegGroups.Unlock;
begin
{$IFDEF FPC}
  System.
{$ENDIF}
  EnterCriticalSection(FLock);
end;

procedure TRegGroups.UnregisterClass(AClass: TPersistentClass);
var
  I: Integer;
begin
  for I := 0 to FGroups.Count - 1 do
    TRegGroup(FGroups[I]).UnregisterClass(AClass);
end;

{$IFDEF DELPHI}

procedure TRegGroups.UnregisterModuleClasses(Module: HMODULE);
var
  I: Integer;
  Group: TRegGroup;
begin
  for I := FGroups.Count - 1 downto 0 do
  begin
    Group := TRegGroup(FGroups[I]);
    Group.UnregisterModuleClasses(Module);
    if Group.FGroupClasses.Count = 0 then
    begin
      Group.Free;
      FGroups.Delete(I);
    end;
  end;
end;

procedure p_UnRegisterModuleClasses(Module: HMODULE);
begin
  gReg_MainFormIniClassesLocales.Lock;
  try
    gReg_MainFormIniClassesLocales.UnregisterModuleClasses(Module);
  finally
    gReg_MainFormIniClassesLocales.Unlock;
	end;
end;
{$ENDIF}

  // Procédure d'enregistrement d'une forms propre à l'application
  procedure p_RegisterClass(AClass: TPersistentClass);
begin
  gReg_MainFormIniClassesLocales.Lock;
  try
    while not gReg_MainFormIniClassesLocales.Registered(AClass) do
     begin
      gReg_MainFormIniClassesLocales.RegisterClass(AClass);
      if AClass = TPersistent then Break;
      AClass := TPersistentClass(AClass.ClassParent);
     end;
  finally
    gReg_MainFormIniClassesLocales.Unlock;
  end;
end;

	// Procédure d'enregistrement des forms propres à l'application
procedure p_RegisterClasses(AClasses: array of TPersistentClass);
var
  I: Integer;
begin
  for I := Low(AClasses) to High(AClasses) do p_RegisterClass(AClasses[I]);
end;

procedure p_RegisterClassAlias(AClass: TPersistentClass; const Alias: string);
begin
  gReg_MainFormIniClassesLocales.Lock;
  try
    gReg_MainFormIniClassesLocales.RegisterClassAlias(AClass, Alias);
  finally
    gReg_MainFormIniClassesLocales.Unlock;
  end;
end;

procedure p_UnRegisterClass(AClass: TPersistentClass);
begin
  gReg_MainFormIniClassesLocales.Lock;
  try
    gReg_MainFormIniClassesLocales.UnregisterClass(AClass);
  finally
    gReg_MainFormIniClassesLocales.Unlock;
  end;
end;

procedure p_UnRegisterClasses(AClasses: array of TPersistentClass);
var
  I: Integer;
begin
  for I := Low(AClasses) to High(AClasses) do Classes.UnRegisterClass(AClasses[I]);
end;

function fper_GetClass(const AClassName: string): TPersistentClass;
begin
  gReg_MainFormIniClassesLocales.Lock;
  try
    Result := gReg_MainFormIniClassesLocales.GetClass(AClassName);
  finally
    gReg_MainFormIniClassesLocales.Unlock;
  end;
end;

function fper_FindClass(const ClassName: string): TPersistentClass;
begin
  Result := fper_GetClass(ClassName);
end;

// Modifie la touche
// Entrée : Numéro de touche
procedure p_SetKeyState( var at_Buffer : TKeyboardState; const aby_Key: Integer; const ab_TurnOn: Boolean);
begin
  // Si windows non nt
  {$IFDEF DELPHI}
  if Win32Platform = VER_PLATFORM_WIN32_WINDOWS then // Win95/98/ME
    begin
      at_Buffer[aby_Key] := Ord(ab_TurnOn);
      SetKeyboardState(at_Buffer);
    end
  // Si windows nt
  else if (fb_GetKeyState(aby_Key) <> ab_TurnOn) then // Procédure spécialisée
    begin
      keybd_event(aby_Key, $45, KEYEVENTF_EXTENDEDKEY, 0); // simulate aby_Key press
      keybd_event(aby_Key, $45, KEYEVENTF_EXTENDEDKEY or KEYEVENTF_KEYUP, 0); // simulate aby_Key release
    end;
  {$ENDIF}
end;

// Récupère le code déjà tapé d'une toouche à partir du buffer virtuelle et valide ou non la touche
// Entrée : Numéro de touche
function fb_GetKeyState(aby_Key: Integer): Boolean;
{$IFDEF DELPHI}
var lt_TempBuffer: TKeyboardState;
{$ENDIF}
begin
  // Si Windows non NT
  {$IFDEF DELPHI}
  if Win32Platform = VER_PLATFORM_WIN32_WINDOWS then // Win95/98/ME
    begin
      GetKeyboardState ( lt_TempBuffer );
      // Le buffer stocke 2 valeurs dans un mot(entier), on récupère la bonne valeur
      Result := lt_TempBuffer [ aby_Key ] and 1 <> 0;
    end
  // Si Windows NT
  else
    // Le buffer ne fonctionne pas bien avec NT la propriété GetGeyState stocke
    // 2 valeurs dans un mot(entier), on récupère la bonne valeur
    Result := GetKeyState(aby_Key) and 1 <> 0;
  {$ELSE}
   Result := False;
  {$ENDIF}
end;


{------------------------------------------------------------------------------
 ---------------------- Fin Hook clavier pour le maj et le num ----------------
 ------------------------------------------------------------------------------}

    // Création d'une form MDI renvoie  la form qui existe
function ffor_CreateMDIChild ( const as_FormNom : string ; afor_FormClasse : TFormClass ) : TForm;

var afor_Reference : TCustomForm ;
begin
  if ( Application.MainForm.FormStyle <> fsMDIForm )
   Then
    Begin
      Result := nil ;
      Exit ;
    End ;
  afor_Reference := ffor_FindForm ( as_FormNom );

  if afor_Reference = nil then
    Application.CreateForm ( afor_FormClasse, afor_Reference )
   else
    afor_Reference.BringToFront;
  Result := TForm ( afor_Reference );
end;

    // Création d'une form MDI renvoie  la form qui existe
function ffor_FindForm ( const as_FormNom : string ) : TCustomForm;

var i : integer;
begin
  Result := nil;
  // Cette recherche ne fonctionne qu'avec les forms mdi child
  for i := 0 to Application.ComponentCount - 1 do
    if ( Application.Components [ i ] is TCustomForm )
    and ( Application.Components [ i ].Name = as_FormNom ) then
     Begin
      Result := Application.Components [ i ] as TCustomForm;
      Break;
     end;

end;

procedure p_CloseForm(const as_FormNom: string);
var
 lfor_Reference : TCustomForm;
begin
  lfor_Reference := ffor_FindForm ( as_FormNom );

  if lfor_Reference <> nil then
    lfor_Reference.Free;
end;


// Création d'une form MDI renvoie True si la form existe dans les enfants MDI
// as_FormNom        : nom      de la form
// afor_FormClasse   : classe   de la form
// afor_Reference    : variable de la form
// newFormStyle      : style    de la form à mettre
function ffor_CreateChild ( afor_FormClasse : TFormClass; const newFormStyle : TFormStyle; const ab_Ajuster : Boolean; const aico_Icon : TIcon  ): TCustomForm;
var
  li_i : integer;
  lico_icon : Ticon ;
begin
  Result := nil ;
    // Recherche sûre de fiches quelconques
  For li_i := Application.ComponentCount - 1 downto 0
   do if (  Application.Components [ li_i ] is TCustomForm )
     and (( Application.Components [ li_i ] as TCustomForm ).ClassType = afor_FormClasse )
    Then
      Begin
        Result := TCustomForm ( Application.Components [ li_i ]);
      End ;

      //Création si nil
  if ( Result = nil )
    Then
     Begin
      Application.CreateForm ( afor_FormClasse, Result );
     End ;
  If  assigned ( aico_Icon      )
  and assigned ( Result )
  and (fobj_getComponentObjectProperty ( Result, 'Icon' ) is TIcon )
   Then
    Begin
      lico_icon := TIcon ( fobj_getComponentObjectProperty ( Result, 'Icon' ));
      if assigned ( lico_icon ) then
        Begin
          lico_icon.Modified := False ;
          lico_icon.PaletteModified := False ;
          if lico_icon.Handle <> 0 Then
            Begin
              lico_icon.ReleaseHandle ;
              lico_icon.CleanupInstance ;
            End ;
          lico_icon.Handle := 0 ;
          lico_icon.Assign ( aico_Icon );
          lico_icon.Modified := True ;
          lico_icon.PaletteModified := True ;

          Result.Invalidate ;

        End;
    End ;
    // Mise à jour de la form
  if Assigned(Result)
  and ab_Ajuster
  and ( Result is TCustomForm ) then
    fb_setNewFormStyle ( Result as TCustomForm , newFormStyle, ab_Ajuster );
end;



// procedure p_SetChildForm
// Setting FormStyle
// If using SuperForm, setting the child superform if not FormStyle is fsStayOnTop
// afor_Reference : Form Variable
// The style to set afs_newFormStyle
procedure p_SetChildForm(const afor_Reference: TCustomForm; const  afs_newFormStyle : TFormStyle );
var FBoxChilds:TWinControl;
const CST_BoxChilds = 'BoxChilds';
begin
{$IFDEF SFORM}
 if ( afor_Reference is TSuperForm )
  and not ( afs_newFormStyle in [fsStayOnTop]) Then
    with Application,MainForm do
    Begin
      BeginUpdateBounds;
    // Must use MainFormIni
    //       afor_Reference.AutoSize := True;
      ( afor_Reference as TSuperForm ).IncrustMode := aicAllClient;
      if   assigned ( GetPropInfo ( MainForm, CST_BoxChilds ))
      and  PropIsType      ( MainForm, CST_BoxChilds , tkClass) Then
        Begin
          FBoxChilds := TWinControl ( GetObjectProp   ( MainForm, CST_BoxChilds ));
          if not assigned ( FBoxChilds ) Then
            Begin
              FBoxChilds := TSuperBox.Create(MainForm);
              with FBoxChilds as TSuperBox do
                Begin
                  Parent := MainForm;
                  AutoScroll:=True;
                  Align:=alClient;
                end;
              SetObjectProp( MainForm, CST_BoxChilds, FBoxChilds );
            end;
    //       afor_Reference.Align := alClient;
         with FBoxChilds do
           Begin
             BeginUpdateBounds;
             ( afor_Reference as TSuperForm ).ShowIncrust ( FBoxChilds );
             EndUpdateBounds;
           end;
        end
       Else
        ( afor_Reference as TSuperForm ).ShowIncrust ( MainForm );
       EndUpdateBounds;
     end
   else
{$ENDIF}
  p_SetComponentProperty ( afor_Reference, 'FormStyle', afs_newFormStyle );
  {$IFDEF FPC}
  afor_Reference.Show;
  {$ENDIF}
  afor_Reference.BringToFront ;
end;

// Création d'une form modal
// renvoie True si la form existe
// afor_FormClasse : Classe de la form ;
// var afor_Reference : Variable de la form
// ab_Ajuster : Ajuster automatiquement
// aact_Action : Action à la Fermeture
function fb_CreateModal ( afor_FormClasse : TFormClass ; var afor_Reference : TForm ; const ab_Ajuster : Boolean  ; const aact_Action : TCloseAction ) : Boolean ;
begin
  Result := false ;
  afor_Reference := ffor_getForm ( afor_FormClasse );

      //Création si nil
 if ( afor_Reference = nil )
   Then
    Begin
     Application.CreateForm ( afor_FormClasse, afor_Reference );
    End
   Else
    Result := True ;
    // Mise à jour de la form

  afor_Reference.FormStyle := fsNormal ;

  afor_Reference.Hide ;
  if ab_Ajuster
   Then
    Begin
      afor_Reference.Position    := poMainFormCenter ;
      afor_Reference.WindowState := wsNormal ;
      afor_Reference.BorderStyle := bsSingle ;
    End ;
  afor_Reference.Update ;
  afor_Reference.ShowModal;
  // On peut effectuer une action de fermeture après avoir montré une fiche modale
  if aact_Action = caFree
   then
    afor_Reference.Free
   else if aact_Action = caHide
    then
     afor_Reference.Hide
    else if aact_Action = caMiniMize
     then
      afor_Reference.WindowState := wsMiniMized ;
end;

// Récupération d'une form renvoie la form si existe dans les enfants
// as_FormNom        : nom      de la form
// as_FormClasse   : classe   de la form
function ffor_getForm ( const as_FormNom, as_FormClasse: string ): TForm ;
var
  li_i: integer;

begin
  // Initialisation
  Result          := nil ;
//  if (FormStyle <> fsMDIForm) then
//    Exit;

  for li_i := Application.ComponentCount - 1 downto 0 do
    if (Application.Components[li_i] is TForm) and
       ( lowercase (( Application.Components[li_i] as TForm).ClassName ) = lowercase ( as_FormClasse )) then
      begin
        Result := TForm ( Application.Components[li_i] );
      end;
End ;

// Récupération d'une form renvoie la form si existe dans les enfants
// as_FormNom        : nom      de la form
// as_FormClasse   : classe   de la form
function ffor_getForm ( afor_FormClasse : TFormClass ): TForm;
var
  li_i: integer;

begin
  Result := nil ;
    // Recherche sûre de fiches quelconques
  For li_i := Application.ComponentCount - 1 downto 0
   do if (  Application.Components [ li_i ] is TForm )
     and (( Application.Components [ li_i ] as TForm ).ClassType = afor_FormClasse )
    Then
      Begin
        Result := TForm ( Application.Components [ li_i ] );
      End ;
End ;
// Création d'une form MDI renvoie True si la form existe dans les enfants MDI
// as_FormNom        : nom      de la form
// afor_FormClasse   : classe   de la form
// newFormStyle      : style    de la form à mettre
function fp_CreateChild(const as_FormNom, as_FormClasse: string; const newFormStyle: TFormStyle; const ab_Ajuster: Boolean; const aico_Icon : TIcon): Pointer;
var
  lper_ClasseForm : TComponentClass ;
  lb_Unload : Boolean ;

begin
  // Recherche la form
  Result    := ffor_getForm ( as_FormNom, as_FormClasse );

  // Form non trouvée : on crée
  if not Assigned(Result) then
    Begin
        // Recherche la classe de la form dans cette unité
        lper_ClasseForm := TComponentClass ( fper_FindClass ( as_FormClasse ));

        if Assigned(lper_ClasseForm)
        // Rapide : on a trouvé la form dans cette unité
         Then Application.CreateForm ( lper_ClasseForm              , Result )
         Else
           Begin
             try
              // Recherche la classe de la form dans delphi
               lper_ClasseForm := TComponentClass ( FindClass ( as_FormClasse ));
             except
             End ;
             // Lent form trouvée dans delphi
             if Assigned(lper_ClasseForm)
              Then
               Application.CreateForm ( lper_ClasseForm, Result );
           End ;
    // Assigne l'icône si existe
      If assigned ( aico_Icon    )
      and Assigned( Result )
       Then
        Begin
          ( TForm ( Result )).Icon.Modified := False ;
          ( TForm ( Result )).Icon.PaletteModified := False ;
          if ( TForm ( Result )).Icon.Handle <> 0 Then
            Begin
              ( TForm ( Result )).Icon.ReleaseHandle ;
              ( TForm ( Result )).Icon.CleanupInstance ;
            End ;
          ( TForm ( Result )).Icon.Handle := 0 ;
          ( TForm ( Result )).Icon.width  := 16 ;
          ( TForm ( Result )).Icon.Height := 16 ;
          ( TForm ( Result )).Icon.Assign ( aico_Icon );
          ( TForm ( Result )).Icon.Modified := True ;
          ( TForm ( Result )).Icon.PaletteModified := True ;

          ( TForm ( Result )).Invalidate ;

        End ;

//      ShowMessage('Fiche ' + afor_FormClasse + ' non enregistrée ( Utiliser RegisterClasses dans la création du projet )');
    end;
    // Paramètre d'affichage
  if Assigned(Result)
  and ab_Ajuster then
    Begin
      lb_Unload := fb_getComponentBoolProperty ( TComponent( Result ), 'DataUnload' );
      if not lb_Unload Then
        fb_setNewFormStyle( TForm ( Result ), newFormStyle, ab_Ajuster)
      else 
        ( TForm ( Result )).Free ;
    End ;
end;

// Changement du style d'une form
// afor_Reference    : variable de la form
// newFormStyle      : style    de la form à mettre
// Résultat          : Le style a été changé
function fb_setNewFormStyle(const afor_Reference: TCustomForm; const afs_FormStyle: TFormStyle ; const ab_Modal : Boolean ; const awst_WindowState : TWindowState ; const apos_Position : TPosition ): Boolean;
begin
  Result := False ;
  if not ( assigned ( afor_Reference )) then
    Exit ;
  try
    // Le style a été changé
    Result := True ;

    if TPosition ( flin_getComponentProperty ( afor_Reference, 'Position' )) <> apos_Position Then
      p_SetComponentProperty ( afor_Reference, 'Position', apos_Position );
    if TWindowState ( flin_getComponentProperty ( afor_Reference ,'WindowState' )) <> awst_WindowState Then
      p_SetComponentProperty ( afor_Reference, 'WindowState', awst_WindowState );

    if not ( afs_FormStyle in [ fsMDIChild ]) Then
      p_SetComponentProperty ( afor_Reference, 'FormStyle', afs_FormStyle );

    // Mise à jour
    afor_Reference.Update ;

    // Affectation
    if ab_Modal
    and ( afs_FormStyle in [ fsNormal ]) Then
      begin
        afor_Reference.ShowModal ;
        Exit ;
      end ;

      // Affiche la fiche après les modifs
    if ( afs_FormStyle in [fsMDIChild]) Then
      p_setChildForm ( afor_Reference, afs_FormStyle )
    Else
      afor_Reference.Show;
  Except
  End ;
End ;

// Changement du style d'une form
// afor_Reference    : variable de la form
// newFormStyle      : style    de la form à mettre
// Résultat          : Le style a été changé
function fb_setNewFormStyle(const afor_Reference: TCustomForm; const afs_newFormStyle: TFormStyle; const ab_Ajuster: Boolean): Boolean;
//var acla_ClasseForm : TClass ;
begin
  Result := False;
  try
  //  acla_ClasseForm := afor_Reference.ClassType ;
    // Style différent
    if (afs_newFormStyle <> TFormStyle ( flin_getComponentProperty ( afor_Reference, 'FormStyle' ))) then
      begin
        // Le style a été changé
        Result := True ;

        // Affectation
        if gb_ModalStarted
        and ( afs_newFormStyle in [fsMDIChild, fsNormal ]) Then
          begin
            if TPosition ( flin_getComponentProperty ( afor_Reference , 'Position' )) <> poMainFormCenter Then
              p_SetComponentProperty ( afor_Reference, 'Position', poMainFormCenter );
            if TWindowState ( flin_getComponentProperty ( afor_Reference , 'WindowState' )) <> wsNormal Then
              p_SetComponentProperty ( afor_Reference, 'WindowState', wsNormal );
            afor_Reference.ShowModal ;
            Exit ;
          end
        Else
          if not ( afs_newFormStyle in [fsMDIChild]) Then
            p_SetComponentProperty ( afor_Reference, 'FormStyle', afs_newFormStyle );
      end;

    {$IFNDEF SFORM}
      // Option ajuster
    if ab_Ajuster
    and Result   then
      begin
      // Par dessus donc au centre
        if ( TFormStyle ( flin_getComponentProperty ( afor_Reference, 'FormStyle' )) = fsStayOnTop)
        and (    (TWindowState ( flin_getComponentProperty ( afor_Reference , 'WindowState' )) <> wsNormal         )
              or ( TPosition ( flin_getComponentProperty ( afor_Reference , 'Position' ))    <> poMainFormCenter )) then
          begin
            p_SetComponentProperty ( afor_Reference, 'Position', poMainFormCenter );
            p_SetComponentProperty ( afor_Reference, 'WindowState', wsNormal );
          end;

          // MDI enfant donc maximizée
        if  not gb_ModalStarted and ( afs_newFormStyle = fsMDIChild) then
          p_SetComponentProperty ( afor_Reference, 'WindowState', wsMaximized );
        // Mise à jour
        afor_Reference.Update ;
      end;
    {$ENDIF}

      // Affiche la fiche après les modifs
    if not gb_ModalStarted and ( afs_newFormStyle in [fsMDIChild]) Then
      p_setChildForm ( afor_Reference, afs_newFormStyle )
    Else
      afor_Reference.Show;
  Except
  End ;
end;

// Création d'une form MDI renvoie la form si existe
// as_FormNom        : nom      de la form
// afor_FormClasse   : classe   de la form
// afor_Reference    : variable de la form
function fb_CreateMDIChild ( const as_FormNom : string ; afor_FormClasse : TFormClass ; var afor_Reference ; const ab_Ajuster : Boolean ): Boolean;
var
  lfor_Reference : TCustomForm;

begin
  Result := False;
  // Pas mdi quitte sinon erreur
  if (Application.MainForm.FormStyle <> fsMDIForm) then Exit;

  lfor_Reference := ffor_FindForm ( as_FormNom );
    // form pas trouvée
  if (lfor_Reference = nil ) then
    begin
      if not Assigned(TForm(afor_Reference)) then
        Application.CreateForm(afor_FormClasse, afor_Reference);
      Result := False;
    end
  else
  // Si trouvée affiche
    begin
      lfor_Reference.BringToFront;
      Result := True;
    end;
end;


function fb_ReinitWindow(
  var afor_Form: TCustomForm): Boolean;
var lfs_FormStyle: TFormStyle ;
    lb_Modal : Boolean ;
    lwst_WindowState : TWindowState ;
    lcln_FormName   : String ;
    lico_Icone       : TIcon ;
    lpos_Position : Tposition ;
    lclt_ClassType : TClass ;
begin
  Result := False ;
  if  assigned ( FIniFile  )
  and assigned ( afor_Form ) Then
    Begin
      lclt_ClassType := afor_Form.ClassType ;
      lfs_FormStyle  := TFormStyle ( flin_getComponentProperty ( afor_Form ,'FormStyle' ));
      lcln_FormName  := afor_Form.Name ;
      lpos_Position  := TPosition ( flin_getComponentProperty ( afor_Form ,'Position' ));
      lwst_WindowState := afor_Form.WindowState ;
      lb_Modal := gb_ModalStarted ;
      lico_Icone := TIcon.Create ;
      if ( fobj_getComponentObjectProperty ( afor_Form, 'Icon' ) is TIcon ) then
        Begin
          lico_Icone.Assign ( TIcon ( fobj_getComponentObjectProperty ( afor_Form, 'Icon' )));
        End;
      try
        if afor_Form.CloseQuery  Then
          Begin
            afor_Form.Free ;
            afor_Form := Nil ;
            p_IniDeleteSection ( lcln_FormName );
            afor_Form := ffor_CreateChild ( TFormClass ( lclt_ClassType ), lfs_FormStyle, False, lico_Icone );
            if assigned ( afor_Form ) Then
              Begin
                fb_setNewFormStyle ( afor_Form, lfs_FormStyle, lb_Modal, lwst_WindowState, lpos_Position );
                Result := True ;
              End ;
          End ;

      finally
        if lico_Icone.HandleAllocated Then
          Begin
            lico_Icone.ReleaseHandle ;
          End ;
        lico_Icone.Free ;
      End ;
    End ;
end;

{$IFDEF FPC}
procedure WindowMinimizeAll(Sender: TObject);
var li_i : Integer ;
Begin
  for li_i := 0 to Application.ComponentCount -1 do
    Begin
      If  ( Application.Components[ li_i ] <> Application.MainForm )
      and ( Application.Components[ li_i ] is TCustomForm ) Then
        ( Application.Components[ li_i ] as TCustomForm ).WindowState := wsMinimized;
    End ;
End;

function ActiveMDIChild : TCustomForm;
var li_i : Integer ;
Begin
  Result := Application.MainForm ;
  for li_i := 0 to Application.ComponentCount -1 do
    Begin
      If  ( Application.Components[ li_i ] <> Application.MainForm )
      and ( Application.Components[ li_i ] is TCustomForm )
      and (( Application.Components[ li_i ] as TCustomForm ).Active ) Then
        Result := Application.Components[ li_i ] as TCustomForm ;
    End ;
End;
{$ENDIF}



initialization
{$IFDEF VERSIONS}
  p_ConcatVersion ( gVer_fonctions_forms );
{$ENDIF}
finalization
  gReg_MainFormIniClassesLocales.Free ;
  gReg_MainFormIniClassesLocales := Nil ;
end.

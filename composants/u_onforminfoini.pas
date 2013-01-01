{*********************************************************************}
{                                                                     }
{                                                                     }
{             Matthieu Giroux                                         }
{             TOnFormInfoIni :                                       }
{             Objet de sauvegarde d'informations de Forms             }
{             20 Février 2003                                         }
{                                                                     }
{                                                                     }
{*********************************************************************}

unit U_OnFormInfoIni;


{$IFDEF FPC}
{$mode Delphi}
{$ENDIF}


interface
// Listes des informations sauvegardées dans le fichier ini de l'application :
// Les données objets Edit
// La position des Objets (avec l'utilisation des Panels et des RxSplitters et RbSplitter)
// L'index de la pageactive des PageControls (onglets)
// L'index des objets CheckBoxex, RadioBoutons, RadioGroups ,PopupMenus
// les positions de la fenêtre

{$I ..\DLCompilers.inc}
{$I ..\extends.inc}

uses
{$IFDEF FPC}
  LCLIntf, lresources,
{$ELSE}
  RTLConsts,
  Windows, Mask, Consts, ShellAPI, JvToolEdit,
{$ENDIF}
{$IFDEF RX}
  RxLookup,
{$ENDIF}
  SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  IniFiles, StdCtrls, ComCtrls, ExtCtrls,
  Variants, Menus, Buttons, DbCtrls,
{$IFDEF VERSIONS}
  fonctions_version,
{$ENDIF}
  fonctions_init, DBGrids;

// Component properties
const CST_ONFORMINI_DIRECTORYEDIT_DIR  = {$IFDEF FPC} 'Directory' {$ELSE} 'Text' {$ENDIF};
      CST_ONFORMINI_DIRECTORYEDIT      = 'TDirectoryEdit';
      CST_ONFORMINI_FILENAME    = 'FileName' ;
      CST_ONFORMINI_VALUE       = 'Value' ;
      CST_ONFORMINI_DOT         = '.' ;
      CST_ONFORMINI_LINES       = 'Lines' ;
      CST_ONFORMINI_CHECKED     = 'Checked' ;
      CST_ONFORMINI_WIDTH       = 'Width' ;
      CST_ONFORMINI_HEIGHT      = 'Height' ;
      CST_ONFORMINI_TOP         = 'Top' ;
      CST_ONFORMINI_LEFT        = 'Left' ;
      CST_ONFORMINI_WINDOWSTATE = 'WindowState' ;
      CST_ONFORMINI_POSITION    = 'Position' ;
      CST_ONFORMINI_FORMSTYLE   = 'FormStyle' ;
      CST_ONFORMINI_TEXT        = 'Text' ;
      CST_ONFORMINI_INDEX       = 'Index' ;
      CST_ONFORMINI_TABINDEX    = 'TabIndex' ;
      CST_ONFORMINI_PAGEINDEX   = 'PageIndex' ;
      CST_ONFORMINI_DATASOURCE  = 'Datasource'  ;

      // Components
      CST_ONFORMINI_EXTCOLOR    = 'TExtColorCombo' ;
      CST_ONFORMINI_RICHVIEW    = 'TRichView' ;
      CST_ONFORMINI_RICHMEMO    = 'TRichMemo'  ;
      CST_ONFORMINI_XPCHECK     = 'TJvXPCheckbox' ;
      CST_ONFORMINI_FLATCHECK   = 'TFlatCheckBox' ;
      CST_ONFORMINI_PCHECK      = 'TPCheck' ;
      CST_ONFORMINI_JVDIRECTORY = 'TJvDirectoryEdit';
      CST_ONFORMINI_SPINEDIT    = 'TSpinEdit';
      CST_ONFORMINI_SPLITTER    = 'TSplitter';
      CST_ONFORMINI_JVSPLITTER  = 'TJvSplitter';
      CST_ONFORMINI_RXSPLITTER  = 'TRxSplitter';
      CST_ONFORMINI_FWSPINEDIT  = 'TFWSpinEdit';
      CST_ONFORMINI_RXSPINEDIT  = 'TRxSpinEdit';
      CST_ONFORMINI_JVSPINEDIT  = 'TJvSpinEdit';

      // Variables
      CST_ONFORMINI_SCREEN    = 'Screen' ;

      // Events
      CST_ONFORMINI_ONDESTROY   =  'OnDestroy'  ;
      CST_ONFORMINI_ONSHOW      =  'OnShow'  ;
      CST_ONFORMINI_ONCREATE    =  'OnCreate'  ;
{$IFDEF VERSIONS}
      gVer_TSvgFormInfoIni : T_Version = ( Component : 'Composant TOnFormInfoIni' ;
                                           FileUnit : 'U_OnFormInfoIni' ;
                                           Owner : 'Matthieu Giroux' ;
                                           Comment : 'Ini management tu put on a form.' ;
                                           BugsStory : '1.0.3.1 : Resolving "Optimising" SpinEdit bug.' +#13#10 +
                                                       '1.0.3.0 : Optimising.' +#13#10 +
                                                       '1.0.2.0 : To English, new management of forms not tested.' +#13#10 +
                                                       '1.0.1.6 : UTF 8.' +#13#10 +
                                                       '1.0.1.5 : Testing Memo.' +#13#10 +
                                                       '1.0.1.4 : Freeing ini, erasing before saving.' +#13#10 +
                                                       '1.0.1.3 : Erasing form section after reading ini.' +#13#10 +
                                                       '1.0.1.2 : Testing and creating consts. New form events.' +#13#10 +
                                                       '1.0.1.1 : Testing ColorCombo.' +#13#10 +
                                                       '1.0.1.0 : Testing DirectoryEdit, MaskEdit, on WINDOWS.' +#13#10 +
                                                       '1.0.0.1 : Grouping.' +#13#10 +
                                                       '1.0.0.1 : Lesser Bug, not searching the component in form.' +#13#10 +
                                                       '1.0.0.0 : Gestion de beaucoup de composants.';
                                           UnitType : 3 ;
                                           Major : 1 ; Minor : 0 ; Release : 3 ; Build : 1 );

{$ENDIF}



type
  // Liste des objets dont on veut conserver les donner dans le fichier INI
  TSaveEdit = (feTEdit, feTCheck, feTComboValue, feTComboBox, feTColorCombo,feTCurrencyEdit,feTDateEdit,
        {$IFDEF DELPHI}
        feTDateTimePicker,
        {$ENDIF}
        feTDirectoryEdit,feTFileNameEdit,feTGrid,feTListBox, feTListView, feTMemo, feTPageControl, feTPopup, feTRadio, feTRadioGroup, feTRichEdit,feTSpinEdit,
        feTVirtualTrees );
  TLoadOption = (loFreeIni,loAutoUpdate,loAutoLoad);
  TLoadOptions = set of TLoadOption;
  TSaveForm = (sfSavePos,sfSaveSizes,sfSameMonitor);
  TSavesForm = set of TSaveForm;
  TEventIni = procedure ( const AInifile : TCustomInifile ; var Continue : Boolean ) of object;
  TSaveEdits = set of TSaveEdit;
const CST_INI_OPTIONS_DEFAULT = [loFreeIni,loAutoUpdate,loAutoLoad];

type
  { TOnFormInfoIni }

  TOnFormInfoIni = class(TComponent)
  private
    FSaveEdits: TSaveEdits;
    FSaveForm : TSavesForm;
    FOptions : TLoadOptions;
    FOnFormDestroy,
    FOnFormShow   ,
    FOnFormCreate : TNotifyEvent ;
    FOnIniLoad, FOnIniWrite : TEventIni;
  protected
    FUpdateAll : Boolean;
    FFormOwner:     TCustomForm;
    FormOldDestroy  ,
    FormOldCreate   ,
    FormOldShow     : TNotifyEvent;
//    procedure loaded; override;
    function GetfeSauveEdit(const aSauveObjet:TSaveEdits;const aObjet :TSaveEdit):Boolean ;
    // traitement de la position de la af_Form mise dans le create
    procedure p_LecturePositionFenetre(const aFiche:TCustomForm);
    procedure p_EcriturePositionFenetre(const aFiche:TCustomForm);
    procedure p_Freeini; virtual;
    procedure DoSameMonitor(const aForm: TForm); virtual;

  public
    Constructor Create(AOwner:TComponent); override;
    procedure ExecuteLecture(aLocal:Boolean); virtual;
    procedure p_ExecuteLecture(const aF_Form: TCustomForm); virtual;
    procedure ExecuteEcriture(aLocal: Boolean); virtual;
    procedure p_ExecuteEcriture(const aF_Form: TCustomForm); virtual;
    procedure p_LectureColonnes(const aF_Form: TCustomForm=nil); virtual;
  published
//    property AutoUpdate : Boolean read FAutoUpdate write FAutoUpdate default True;
//    property AutoLoad   : Boolean read FAutoChargeIni write FAutoChargeIni default True;
    // Propriété qui conserve la position des objets d'une form
//    property SavePosObjects: Boolean read FSavePosObjects write FSavePosObjects default False;
    // Propriété qui conserve les données des objets d'une form
    property SaveEdits: TSaveEdits read FSaveEdits write FSaveEdits default [];
    property SaveForm : TSavesForm read FSaveForm write FSaveForm default [];
    property Options  : TLoadOptions read FOptions write FOptions default CST_INI_OPTIONS_DEFAULT;

    // Propriété qui conserve la position(index) des objets PageControl (onglets)
//    property SavePosForm: Boolean read FSavePosForm  write FSavePosForm default False;
//    property SameMonitor: Boolean read FSameMonitor  write FSameMonitor default False;
    property OnIniLoad  : TEventIni read FOnIniLoad write FOnIniLoad ;
    property OnIniWrite : TEventIni read FOnIniWrite write FOnIniWrite;
    property OnFormShow : TNotifyEvent read FOnFormShow write FOnFormShow;
    property OnFormDestroy : TNotifyEvent read FOnFormDestroy write FOnFormDestroy;
    property OnFormCreate : TNotifyEvent read FOnFormCreate write FOnFormCreate;
//    property Freeini : Boolean read FFreeIni write FFreeIni default True;
    procedure LaFormDestroy(Sender: TObject);
    procedure LaFormShow(Sender: TObject);
    procedure LaFormCreate(Sender: TObject);
  end;

implementation

uses TypInfo, Grids, U_ExtNumEdits,
{$IFDEF FPC}
     EditBtn,
{$ELSE}
     fonctions_system,
{$IFDEF RX}
     rxToolEdit,
{$ENDIF}
{$ENDIF}
{$IFDEF VIRTUALTREES}
     VirtualTrees ,
{$ENDIF}
  {$IFDEF FPC}
  unite_messages,
  {$ELSE}
  unite_messages_delphi,
  {$ENDIF}
  Math,
  fonctions_proprietes;

////////////////////////////////////////////////////////////////////////////////
// Constructeur de l'objet TOnFormInfoIni
////////////////////////////////////////////////////////////////////////////////
Constructor TOnFormInfoIni.Create(AOwner:TComponent);
var lmet_MethodToAdd  : TMethod;
begin
  Inherited Create(AOwner);
  FSaveForm      := [];
  FOptions       := CST_INI_OPTIONS_DEFAULT;
  FOnIniLoad     := nil;
  FOnIniWrite    := nil;
  if not (csDesigning in ComponentState)  //si on est pas en mode conception
  and ( AOwner is TCustomForm ) then
    begin
      lmet_MethodToAdd.Data := Self;
      lmet_MethodToAdd.Code := MethodAddress('LaFormDestroy' );
      FFormOwner           := TCustomForm(AOwner);        // La forme propriétaire de notre composant
      FormOldDestroy       := TNotifyEvent ( fmet_getComponentMethodProperty ( FFormOwner, CST_ONFORMINI_ONDESTROY )); // Sauvegarde de l'événement OnDestroy
      p_SetComponentMethodProperty ( FFormOwner, CST_ONFORMINI_ONDESTROY, lmet_MethodToAdd );        // Idem pour OnDestroy
      FormOldCreate        := TNotifyEvent ( fmet_getComponentMethodProperty ( FFormOwner, CST_ONFORMINI_ONCREATE ));  // Sauvegarde de l'événement OnClose
      lmet_MethodToAdd.Code := MethodAddress('LaFormCreate' );
      p_SetComponentMethodProperty ( FFormOwner, CST_ONFORMINI_ONCREATE, lmet_MethodToAdd );         // Idem pour OnClose
      FormOldShow          := TNotifyEvent ( fmet_getComponentMethodProperty ( FFormOwner, CST_ONFORMINI_ONSHOW ));  // Sauvegarde de l'événement OnShow
      lmet_MethodToAdd.Code := MethodAddress('LaFormShow' );
      p_SetComponentMethodProperty ( FFormOwner, CST_ONFORMINI_ONSHOW, lmet_MethodToAdd );     // Idem pour OnShow
    End;
end;


////////////////////////////////////////////////////////////////////////////////
// Au chargement de l'objet TOnFormInfoIni, on lit les données dans le fichier ini
////////////////////////////////////////////////////////////////////////////////
{procedure TOnFormInfoIni.loaded;
begin
  inherited;
  if not Assigned(FFormOwner) then
    Exit;
end;
}
////////////////////////////////////////////////////////////////////////////////
// À la fermeture de la form, on écrit les données dans le fichier ini
////////////////////////////////////////////////////////////////////////////////
procedure TOnFormInfoIni.LaFormDestroy ( Sender: TObject );
begin
  if Assigned(FormOldDestroy) then FormOldDestroy(Sender);
  if Assigned(FFormOwner)
   then
    p_ExecuteEcriture(FFormOwner);
  if Assigned(FOnFormDestroy) then FOnFormDestroy(Sender);
end;

////////////////////////////////////////////////////////////////////////////////
// À la fermeture de la form, on écrit les données dans le fichier ini
////////////////////////////////////////////////////////////////////////////////
procedure TOnFormInfoIni.LaFormCreate ( Sender: TObject );
begin
  FUpdateAll := False ;
  if Assigned(FormOldCreate) then FormOldCreate(Sender);
  f_GetMemIniFile;
  if Assigned(FInifile) then
   with FFormOwner do
    try
      Updating ;
          // Traitement de la position de la af_Form
      if (TFormStyle ( flin_getComponentProperty ( FFormOwner, CST_ONFORMINI_DOT + CST_ONFORMINI_FORMSTYLE )) <> fsMDIChild) and (sfSavePos in FSaveForm) then
        p_LecturePositionFenetre(FFormOwner);

    finally
      Updated;
    end;
  if Assigned(FOnFormCreate) then FOnFormCreate(Sender);
end;

procedure TOnFormInfoIni.DoSameMonitor(const aForm:TForm);
var
  RectMonitor:TRect;
begin //Positionne et redimentionne éventuellement aForm sur le moniteur de FMain
  if not ( sfSameMonitor in FSaveForm )
  or ( aForm = Application.MainForm )
   Then Exit;

  RectMonitor:=Application.MainForm.Monitor.WorkareaRect;
  with aForm do
   Begin
    Position:=poDesigned;
    WindowState:=wsNormal;
    if Height>(RectMonitor.Bottom-RectMonitor.Top) then
      Height:=RectMonitor.Bottom-RectMonitor.Top;
    if Top<RectMonitor.Top then
      Top:=RectMonitor.Top;
    if (Top+Height)>RectMonitor.Bottom then
      Top:=RectMonitor.Bottom-Height;
    if Width>(RectMonitor.Right-RectMonitor.Left) then
      Width:=RectMonitor.Right-RectMonitor.Left;
    if Left<RectMonitor.Left then
      Left:=RectMonitor.Left;
    if (Left+Width)>RectMonitor.Right then
      Left:=RectMonitor.Right-Width;
   end;
end;

procedure TOnFormInfoIni.LaFormShow(Sender: TObject);

begin
  try
    if Assigned(FormOldShow)
     then FormOldShow(Sender);
  Except

  end;
  if loAutoUpdate in FOptions then
    p_ExecuteLecture(TForm(Self.Owner));

  if Assigned(FOnFormShow) then FOnFormShow(Sender);

end;


////////////////////////////////////////////////////////////////////////////////
// Fonction qui regarde dans la propriété TSaveEdits de TOnFormInfoIni
// et renvoie la valeur de sauvegarde d'un objet de la form
////////////////////////////////////////////////////////////////////////////////
function TOnFormInfoIni.GetfeSauveEdit(const aSauveObjet:TSaveEdits;const aObjet :TSaveEdit):Boolean;
begin
  Result := False;
  if aObjet in aSauveObjet then
    Result := True;
end;

////////////////////////////////////////////////////////////////////////////////
// Lecture des données dans le fichier ini
////////////////////////////////////////////////////////////////////////////////
procedure TOnFormInfoIni.ExecuteLecture ( aLocal:Boolean);
var i: integer;
begin
  // automatisation
  if Assigned(FFormOwner)
   then
    if aLocal Then // Demande si la fiche a été ouverte
     Begin
       for i := 0 to Application.ComponentCount - 1 do //pour chaque fiche de l'application
         if ( Application.Components[i] is TForm )
         and (FFormOwner.Name = (TForm(Application.Components[i])).Name) then
           p_ExecuteLecture(TForm(Application.Components[i])); //fin pour chaque fiche de l'application
     End
    Else  p_ExecuteLecture(FFormOwner);
end;


////////////////////////////////////////////////////////////////////////////////
// Lecture des données dans le fichier INI
////////////////////////////////////////////////////////////////////////////////
procedure TOnFormInfoIni.p_ExecuteLecture(const aF_Form: TCustomForm);
var
  mit: TMenuItem;
  j, Rien, li_Taille : integer;
  ls_Temp : String ;
  ab_continue : Boolean;
  lcom_Component : Tcomponent ;

  function fli_ReadInteger (const as_ComponentName : String; const ali_Default : Longint ):Longint;
  Begin
    Result := FInifile.ReadInteger ( af_Form.Name, as_ComponentName, ali_Default );
  end;

  function fs_ReadString ( const as_ComponentName, as_Default : String ):String;
  Begin
    Result := FInifile.ReadString ( af_Form.Name, as_ComponentName, as_Default );
  end;
  function fb_ReadHighComponents: Boolean;
  var lal_Align : TAlign;
      ASplit : {$IFDEF FPC}TCustomSplitter{$ELSE}TSplitter{$ENDIF};
  Begin
    Result := False;
    if (lcom_Component is TCustomDBGrid) and
       GetfeSauveEdit(FSaveEdits, feTGrid) then
      begin
        f_IniReadGridFromIni ( FInifile, aF_Form.Name, lcom_Component as TCustomDBGrid );
        // No continue because other use of grid
      end;

    {$IFDEF VIRTUALTREES}
    if (lcom_Component is TBaseVirtualTree )
     and   GetfeSauveEdit(FSaveEdits, feTVirtualTrees) then
        begin
          f_IniReadVirtualTreeFromIni ( FInifile, aF_Form.Name, lcom_Component as TBaseVirtualTree );
        // No continue because other use of tree
      end;
    {$ENDIF}

    if (lcom_Component is TCustomListView)
     and   GetfeSauveEdit(FSaveEdits, feTListView) then
        begin
          f_IniReadListViewFromIni ( FInifile, aF_Form.Name, lcom_Component as TCustomListView );
        // No continue because other use of listview
      end;

    // lecture de la position des objets Panels et Rxsplitters
    if  ( sfSaveSizes in FSaveForm )
     and (   lcom_Component is {$IFDEF FPC}TCustomSplitter{$ELSE}TSplitter{$ENDIF})
     and (   lcom_Component as TControl ).Visible
     then
      begin
        lal_Align := ( lcom_Component as TControl).Align;
        ASplit := {$IFDEF FPC}TCustomSplitter{$ELSE}TSplitter{$ENDIF}(lcom_Component);
        case lal_Align of
          alLeft,alRight : ASplit.{$IFDEF FPC}SetSplitterPosition{$ELSE}Left:={$ENDIF}(fli_ReadInteger ( lcom_Component.Name +CST_ONFORMINI_DOT + CST_ONFORMINI_LEFT , TControl (lcom_Component).Left));
          alTop,alBottom : ASplit.{$IFDEF FPC}SetSplitterPosition{$ELSE}Top :={$ENDIF}(fli_ReadInteger ( lcom_Component.Name +CST_ONFORMINI_DOT + CST_ONFORMINI_TOP, TControl (lcom_Component).Top));
        End;
        Result := True;
      end;
  end;

  function fb_ReadOptions: Boolean;
  Begin
    Result := False;
    // lecture des CheckBoxes
    if (   (lcom_Component is TCheckBox)
        or (lcom_Component.ClassNameIs( CST_ONFORMINI_XPCHECK ))
        or (lcom_Component.ClassNameIs( CST_ONFORMINI_FLATCHECK ))
        or (lcom_Component.ClassNameIs( CST_ONFORMINI_PCHECK )))
     and GetfeSauveEdit ( FSaveEdits, feTCheck ) then
      begin
        p_SetComponentBoolProperty(lcom_Component,CST_ONFORMINI_CHECKED, FInifile.ReadBool(af_Form.name,lcom_Component.Name,fb_getComponentBoolProperty(lcom_Component, CST_ONFORMINI_CHECKED)));
        Result := True;
      end;
    // lecture des RadioBoutons
    if (lcom_Component is TRadioButton) and GetfeSauveEdit ( FSaveEdits, feTRadio ) then
      begin
        TRadioButton(lcom_Component).Checked:= FInifile.ReadBool(af_Form.name,lcom_Component.Name,true);
        Result := True;
      end;
    // lecture des groupes de RadioBoutons
    if (lcom_Component is TRadioGroup)  and GetfeSauveEdit ( FSaveEdits, feTRadioGroup ) then
      try
        TRadioGroup(lcom_Component).ItemIndex:= fli_ReadInteger (lcom_Component.Name,0);
        Result := True;
      Except
      end;

  end;

  function fb_ReadEdits: Boolean;
  Begin
    Result := False;
    if ((lcom_Component is TCustomEdit) and not assigned ( fobj_getComponentObjectProperty(lcom_Component, CST_PROPERTY_DATASOURCE)))
    and GetfeSauveEdit(FSaveEdits ,feTedit) then
      begin
        ls_Temp := fs_ReadString(lcom_Component.Name,'');
        if ( ls_Temp <> '' ) Then
          p_SetComponentProperty(lcom_Component, CST_ONFORMINI_TEXT, ls_Temp );
        // do not quit after because there are other edits
        Exit;
      end;

    if GetfeSauveEdit(FSaveEdits ,feTDateEdit) Then
      if (lcom_Component is {$IFDEF FPC} TDateEdit {$ELSE} TJvCustomDateEdit {$ENDIF}) then
        Begin
          {$IFDEF FPC} TDateEdit {$ELSE} TJvCustomDateEdit {$ENDIF}(lcom_Component).Date := StrToDateTime(fs_ReadString(lcom_Component.Name,DateToStr(Date)));
          Result := True;
          Exit;
        End;

    if  GetfeSauveEdit(FSaveEdits ,feTEdit)
    and (lcom_Component is TExtNumEdit and not assigned ( fobj_getComponentObjectProperty(lcom_Component, CST_PROPERTY_DATASOURCE))) then
        begin
          TExtNumEdit(lcom_Component).Text := fs_ReadString(lcom_Component.Name,' ');
          Result := True;
        end;

  end;
  function fb_ReadFiles: Boolean;
  var ls_FilenameProp : String;
  Begin
    Result := False;
    if GetfeSauveEdit(FSaveEdits ,feTFileNameEdit)
    and (  lcom_Component.ClassNameIs ( 'TJvFileNameEdit' )
        or lcom_Component.ClassNameIs ( 'TFileNameEdit' ))
      then
        Begin
         if IsPublishedProp(lcom_Component, CST_INI_TEXT )
          Then ls_FilenameProp:=CST_INI_TEXT
          Else ls_FilenameProp:=CST_ONFORMINI_FILENAME;
           p_SetComponentProperty (lcom_Component, ls_FilenameProp,
                                    fs_ReadString( lcom_Component.Name,
                                    fs_getComponentProperty (lcom_Component, ls_FilenameProp )));
            Result := True;
        end;

  end;

  function fb_ReadDirectories: Boolean;
  var ls_DirnameProp : String ;
  Begin
    Result := False;
    if GetfeSauveEdit(FSaveEdits ,feTDirectoryEdit)
    and (lcom_Component.ClassNameIs(CST_ONFORMINI_JVDIRECTORY)
         or (lcom_Component.ClassNameIs ( CST_ONFORMINI_DirectoryEdit ))) Then
      Begin
       if IsPublishedProp(lcom_Component, CST_ONFORMINI_DIRECTORYEDIT_DIR )
        Then ls_DirnameProp:=CST_ONFORMINI_DIRECTORYEDIT_DIR
        Else ls_DirnameProp:=CST_INI_TEXT;
        ls_Temp := fs_ReadString(lcom_Component.Name, fs_getComponentProperty(lcom_Component, ls_DirnameProp));
        If DirectoryExists( ls_Temp ) Then
          Begin
            p_SetComponentProperty (lcom_Component, ls_DirnameProp, ls_temp );
          end;
        Result := True;
      End;

  end;

  function fb_ReadSpecialEdits: Boolean;
  Begin
    Result := False;
    {$IFDEF DELPHI}
    if GetfeSauveEdit(FSaveEdits ,feTDateTimePicker) Then
      if (lcom_Component is TDateTimePicker) then
        begin
          if fs_ReadString(lcom_Component.Name,'%ù@à*£')<>'%ù@à*£' then TDateTimePicker(lcom_Component).DateTime:=StrToDateTime( fs_ReadString(lcom_Component.Name,''));
          Result := True;
        end;
    {$ENDIF}
    if GetfeSauveEdit(FSaveEdits ,feTSpinEdit)
    and (   (lcom_Component.ClassNameIs( CST_ONFORMINI_SPINEDIT))
         or (lcom_Component.ClassNameIs( CST_ONFORMINI_FWSPINEDIT))
         or (lcom_Component.ClassNameIs( CST_ONFORMINI_JVSPINEDIT))
         or (lcom_Component.ClassNameIs( CST_ONFORMINI_RXSPINEDIT)))
       then
        begin
          p_SetComponentProperty(lcom_Component, CST_ONFORMINI_VALUE, fli_ReadInteger (lcom_Component.Name,flin_getComponentProperty(lcom_Component, CST_ONFORMINI_VALUE)));
          Result := True;
        end;

  end;

  function fb_ReadMemos: Boolean;
  Begin
    Result := False;
    if (lcom_Component is TCustomMemo) and GetfeSauveEdit(FSaveEdits ,feTMemo)        then
      begin
        LitTstringsDeIni(FInifile, aF_Form.Name + '-' + lcom_Component.Name,TCustomMemo(lcom_Component).Lines,rien );
        Result := True;
      end;
    if {$IFDEF FPC}(lcom_Component.ClassNameIs(CST_ONFORMINI_RICHVIEW) or lcom_Component.ClassNameIs(CST_ONFORMINI_RICHMEMO) {$ELSE} (lcom_Component is  TCustomRichEdit {$ENDIF})
    and GetfeSauveEdit(FSaveEdits ,feTRichEdit)
    and ( fobj_getComponentObjectProperty(lcom_Component, CST_ONFORMINI_LINES ) <> nil)
     then
      begin
        LitTstringsDeIni(FInifile, af_Form.Name + '-' +  lcom_Component.Name,fobj_getComponentObjectProperty(lcom_Component, CST_ONFORMINI_LINES ) as TStrings,rien);
        Result := True;
      end;
  end;

  function fb_ReadCombos: Boolean;
  var ls_Temp : String;
  Begin
    Result := False;
    if (lcom_Component is TCustomComboBox) and GetfeSauveEdit(FSaveEdits ,feTComboValue)
    and not assigned ( fobj_getComponentObjectProperty(lcom_Component,CST_ONFORMINI_DATASOURCE))
     then
      try
        if   assigned ( GetPropInfo ( lcom_Component, CST_INI_TEXT ))
        then SetPropValue    ( lcom_Component, CST_INI_TEXT ,fs_ReadString(lcom_Component.Name+CST_ONFORMINI_DOT + CST_INI_TEXT,''))
        Else if   assigned ( GetPropInfo ( lcom_Component, CST_INI_ITEMINDEX ))
        Then SetPropValue    ( lcom_Component, CST_INI_ITEMINDEX ,fli_ReadInteger(lcom_Component.Name+CST_ONFORMINI_DOT + CST_INI_ITEMINDEX,0));
      Except
      End;
    if (lcom_Component.CLassNameIs( CST_ONFORMINI_EXTCOLOR)) and GetfeSauveEdit(FSaveEdits ,feTColorCombo)
     then
      begin
         ls_Temp := fs_ReadString(lcom_Component.Name+CST_ONFORMINI_DOT + CST_ONFORMINI_VALUE,'');
         if ls_Temp <> '' Then
          p_SetComponentProperty(lcom_Component, CST_ONFORMINI_VALUE, ls_Temp );
      End;
{$IFDEF RX}
    if GetfeSauveEdit(FSaveEdits ,feTComboValue)
    and (lcom_Component is {$IFDEF FPC}TRxCustomDBLookupCombo{$ELSE}TRxLookupControl{$ENDIF})
    and not assigned ( fobj_getComponentObjectProperty(lcom_Component,CST_ONFORMINI_DATASOURCE))
     Then
      begin
        {$IFNDEF FPC}
        if (lcom_Component is TRxDBLookupList ) Then
          (lcom_Component as TRxDBLookupList).DisplayValue := fs_ReadString(lcom_Component.Name + CST_ONFORMINI_DOT + CST_ONFORMINI_VALUE, '')
         else
         {$ENDIF}
          if (lcom_Component is TRxDBLookupCombo ) Then
          {$IFDEF FPC}
            (lcom_Component as TRxDBLookupCombo).LookupDisplayIndex := fli_ReadInteger (lcom_Component.Name + CST_ONFORMINI_DOT + CST_ONFORMINI_INDEX, -1);
          {$ELSE}
           (lcom_Component as TRxDBLookupCombo).DisplayValue := fs_ReadString(lcom_Component.Name + CST_ONFORMINI_DOT + CST_ONFORMINI_INDEX, '');
           {$ENDIF}
      End;
{$ENDIF}
    if (lcom_Component is TCustomComboBox) and GetfeSauveEdit(FSaveEdits ,feTComboBox)    then
      begin
        p_ReadComboBoxItems(lcom_Component, TCustomComboBox(lcom_Component).Items );
        Result := True;
      end;
  end;

  function fb_ReadListBoxes: Boolean;
  var valItemIndex : Longint;
  Begin
    Result := False;
    if (lcom_Component is TListBox) and GetfeSauveEdit(FSaveEdits ,feTListBox)     then
      try
        LitTstringsDeIni(FInifile, lcom_Component.Name,TCustomListBox(lcom_Component).Items,valItemIndex);
        if valItemIndex<=TCustomListBox(lcom_Component).Items.Count-1 then TCustomListBox(lcom_Component).ItemIndex:=valItemIndex;
          Result := True;
      except
      end;

  end;

  function fb_ReadInteractivityComponents: Boolean;
  var k : Longint;
  Begin
    Result := False;
    // lecture de la page de contrôle(onglets)
    if ((lcom_Component is TCustomTabControl)) and GetfeSauveEdit ( FSaveEdits, feTPageControl )   then
      begin
        if IsPublishedProp(lcom_Component, CST_ONFORMINI_TABINDEX )
         Then p_SetComponentProperty(lcom_Component,CST_ONFORMINI_TABINDEX ,fli_ReadInteger ( lcom_Component.Name , 0))
         Else p_SetComponentProperty(lcom_Component,CST_ONFORMINI_PAGEINDEX,fli_ReadInteger ( lcom_Component.Name , 0));
        Result := True;
      end;
    // lecture de PopupMenu
    if (lcom_Component is TPopupMenu) and GetfeSauveEdit ( FSaveEdits, feTPopup )  then
      begin
        mit := TMenu(lcom_Component).Items;
        for k := 0 to mit.Count-1 do
          begin
            if mit.Items[k].RadioItem then
              mit.Items[k].Checked := FInifile.ReadBool (af_Form.Name, lcom_Component.Name+'_'+mit.Items[k].Name,true)
            else
              mit.Items[k].Checked := FInifile.ReadBool (af_Form.Name, lcom_Component.Name+'_'+mit.Items[k].Name,False);
          end;
        Result := True;
      end;

  end;

begin
  Rien := 0;
  f_GetMemIniFile;
  if Assigned(FInifile) then
    try
      ab_continue := True;

      If Assigned ( FOnIniLoad ) Then
        FOnIniLoad ( FInifile, ab_continue );

      // traitement des composants de la af_Form
      if ab_continue
      and ( ( sfSaveSizes in FSaveForm ) or (FSaveEdits <> [])) Then
      for j := 0 to af_Form.ComponentCount - 1 do
          begin
            try
              lcom_Component := aF_Form.Components[j];

              if fb_ReadHighComponents Then
                continue;
              if FSaveEdits <> [] Then
                Begin
                  if fb_ReadOptions  Then
                    continue;

                  if fb_ReadEdits Then
                    Continue;

                  if fb_ReadSpecialEdits  Then
                    Continue;

                  if fb_ReadFiles Then
                    Continue;

                  if fb_ReadDirectories  Then
                    Continue;

                  if fb_ReadCombos  Then
                    Continue;

                  if fb_ReadListBoxes Then
                    Continue;

                  if fb_ReadInteractivityComponents Then
                    Continue;
                  if fb_ReadMemos Then
                    Continue;

                end;
            except
            end;
        end;

    finally
    end;
 p_Freeini;
end;

procedure TOnFormInfoIni.p_Freeini;
begin
  if ( loFreeIni in FOptions ) Then
    Begin
      FIniFile.Free;
      FIniFile := nil;
    end;
end;
////////////////////////////////////////////////////////////////////////////////
// Ecriture des données dans le fichier ini
////////////////////////////////////////////////////////////////////////////////
procedure TOnFormInfoIni.ExecuteEcriture(aLocal:Boolean);
var i : Integer ;

begin

  if not assigned ( FFormOwner )
   Then
    Exit ;
  FUpdateAll := True ;
  f_GetMemIniFile;
  try
    For i:=0 to application.ComponentCount-1 do //pour chaque af_Form de l'application
    begin
      if ( application.Components[i] is TCustomForm )
      and ((FFormOwner.Name = ( TForm ( application.Components[i] )).Name) and aLocal) or (Not aLocal)
       Then
        p_ExecuteEcriture ( TCustomForm ( application.Components[i] ));
    end; //fin pour chaque af_Form de l'application
  finally
    FUpdateAll := False ;

    if ( loAutoUpdate in FOptions ) Then
      Begin
        fb_iniWriteFile ( FInifile, False );
        Application.ProcessMessages ;

      End ;
  End ;
  p_Freeini;
end;

////////////////////////////////////////////////////////////////////////////////
// Ecriture des données dans le fichier INI
////////////////////////////////////////////////////////////////////////////////
procedure TOnFormInfoIni.p_ExecuteEcriture ( const af_Form : TCustomForm ) ;
var
  ab_continue : Boolean ;
  mit: TMenuItem;
  j: integer;
  lcom_Component : TComponent;
  procedure p_WriteString ( const as_ComponentName, as_Value : String );
  Begin
    FInifile.WriteString ( af_Form.Name, as_ComponentName, as_Value );
  End;

  procedure p_WriteInteger ( const as_ComponentName : String; const ai_Value : Longint );
  Begin
    FInifile.WriteInteger ( af_Form.Name, as_ComponentName, ai_Value );
  End;

  function fb_WriteHighComponents : Boolean;
  var lal_Align : TAlign;
      ASplit : {$IFDEF FPC}TCustomSplitter{$ELSE}TSplitter{$ENDIF};
  Begin
    Result := False;
    if (lcom_Component is TCustomDBGrid) and
       GetfeSauveEdit(FSaveEdits, feTGrid) then
      begin
        p_IniWriteGridToIni ( FInifile, af_Form.Name, lcom_Component as TCustomDBGrid );
      end;

    {$IFDEF VIRTUALTREES}
        if (lcom_Component is TBaseVirtualTree )
         and   GetfeSauveEdit(FSaveEdits, feTVirtualTrees) then
          begin
            p_IniWriteVirtualTreeToIni ( FInifile, af_Form.Name, lcom_Component as TBaseVirtualTree );
          end;
    {$ENDIF}

        if (lcom_Component is TListView)
         and   GetfeSauveEdit(FSaveEdits, feTListView) then
          begin
            p_IniWriteListViewToIni ( FInifile, af_Form.Name, lcom_Component as TListView );
          end;

    // écriture des positions des objets Panels et RxSplitters
    if  ( sfSaveSizes in FSaveForm )
    and ((   lcom_Component is {$IFDEF FPC}TCustomSplitter{$ELSE}TSplitter{$ENDIF}  )
          or lcom_Component.ClassNameIs(CST_ONFORMINI_JVSPLITTER)
          or lcom_Component.ClassNameIs(CST_ONFORMINI_RXSPLITTER))
    and (   lcom_Component as TControl ).Visible
      then
       begin
        lal_Align := ( lcom_Component as TControl).Align;
        case lal_Align of
          alLeft,alRight : p_WriteInteger( lcom_Component.Name +CST_ONFORMINI_DOT + CST_ONFORMINI_LEFT , TControl (lcom_Component).Left);
          alTop,alBottom : p_WriteInteger( lcom_Component.Name +CST_ONFORMINI_DOT + CST_ONFORMINI_TOP, TControl (lcom_Component).Top);
        End;
        Result := True;
      end;
  end;
  function fb_WriteEdits : Boolean;
  Begin
    Result := False;
    if ((lcom_Component is TCustomEdit) and not assigned ( fobj_getComponentObjectProperty(lcom_Component, CST_PROPERTY_DATASOURCE)))
    and GetfeSauveEdit(FSaveEdits ,feTedit) then
      begin
        p_WriteString(lcom_Component.Name,fs_getComponentProperty(lcom_Component,CST_ONFORMINI_TEXT));
        // do not quit after because there are other edits
        Exit;
      end;
    if GetfeSauveEdit(FSaveEdits ,feTCurrencyEdit) and (lcom_Component is TExtNumEdit)
    and not assigned ( fobj_getComponentObjectProperty(lcom_Component, CST_PROPERTY_DATASOURCE))then
      begin
        p_WriteString(lcom_Component.Name,TExtNumEdit(lcom_Component).Text);
        Result := True;
        Exit;
      end;
    if GetfeSauveEdit(FSaveEdits ,feTDateEdit)
    and (lcom_Component is {$IFDEF FPC} TDateEdit {$ELSE} TJvCustomDateEdit {$ENDIF}) then
      begin
        p_WriteString(lcom_Component.Name,DateTimeToStr({$IFDEF FPC} TDateEdit {$ELSE} TJvCustomDateEdit {$ENDIF}(lcom_Component).Date));
        Result := True;
      end;
  end;
  function fb_WriteSpecialEdits : Boolean;
  Begin
    Result := False;
    if GetfeSauveEdit(FSaveEdits ,feTSpinEdit)
    and  (   (lcom_Component.ClassNameIs(CST_ONFORMINI_SPINEDIT))
          or (lcom_Component.ClassNameIs(CST_ONFORMINI_FWSPINEDIT))
          or (lcom_Component.ClassNameIs(CST_ONFORMINI_JVSPINEDIT))
          or (lcom_Component.ClassNameIs(CST_ONFORMINI_RXSPINEDIT)))
     then
      begin
        p_WriteInteger(lcom_Component.Name,flin_getComponentProperty(lcom_Component, CST_ONFORMINI_VALUE ));
        Result := True;
      end;

  end;

  function fb_WriteOptions : Boolean;
  Begin
    Result := False;
    if ((lcom_Component is TCheckBox)
    or (lcom_Component.ClassNameIs( CST_ONFORMINI_XPCHECK ))
    or (lcom_Component.ClassNameIs( CST_ONFORMINI_FLATCHECK ))
    or (lcom_Component.ClassNameIs( CST_ONFORMINI_PCHECK )))
    and GetfeSauveEdit(FSaveEdits, feTCheck )
     then
      begin
        FInifile.WriteBool(af_Form.name,lcom_Component.Name,fb_getComponentBoolProperty ( lcom_Component, CST_ONFORMINI_CHECKED ));
        Result := True;
      end;
    if (lcom_Component is TRadioButton)    and GetfeSauveEdit(FSaveEdits, feTRadio )      then
      begin
        FInifile.WriteBool(af_Form.name,lcom_Component.Name,TRadioButton(lcom_Component).Checked);
        Result := True;
      end;
    if (lcom_Component is TRadioGroup)     and GetfeSauveEdit(FSaveEdits, feTRadioGroup )       then
      begin
        p_WriteInteger(lcom_Component.Name,TRadioGroup(lcom_Component).ItemIndex);
        Result := True;
      end;

  end;

  function fb_WriteDirectories : Boolean;
  var ls_DirnameProp : String;
  Begin
    Result := False;
    if  GetfeSauveEdit(FSaveEdits ,feTDirectoryEdit)
    and (lcom_Component.ClassNameIs(CST_ONFORMINI_JVDIRECTORY)
        or (lcom_Component.ClassNameIs ( CST_ONFORMINI_DirectoryEdit ))) then
      begin
       if IsPublishedProp(lcom_Component, CST_ONFORMINI_DIRECTORYEDIT_DIR )
        Then ls_DirnameProp:=CST_ONFORMINI_DIRECTORYEDIT_DIR
        Else ls_DirnameProp:=CST_INI_TEXT;
        p_WriteString(lcom_Component.Name,fs_getComponentProperty(lcom_Component,ls_DirnameProp));
        Result := True;
      end;

  end;

  function fb_WriteFiles : Boolean;
  var ls_FilenameProp : String;
  Begin
    Result := False;
    if GetfeSauveEdit(FSaveEdits ,feTFileNameEdit)
    and (  lcom_Component.ClassNameIs ( 'TJvFileNameEdit' )
        or lcom_Component.ClassNameIs ( 'TFileNameEdit' ))
      then
        Begin
         if IsPublishedProp(lcom_Component, CST_INI_TEXT )
          Then ls_FilenameProp:=CST_INI_TEXT
          Else ls_FilenameProp:=CST_ONFORMINI_FILENAME;
        p_WriteString( lcom_Component.Name,
                       fs_getComponentProperty (lcom_Component, ls_FilenameProp ));
        Result:=True;
      End ;

  end;

  function fb_WriteMemos : Boolean;
  Begin
    Result := False;
    if (lcom_Component is TCustomMemo)  and GetfeSauveEdit(FSaveEdits ,feTMemo)            then
      begin
        SauveTStringsDansIni(FInifile, af_Form.Name + '-' +  lcom_Component.Name,TCustomMemo(lcom_Component).Lines,0);
        Result := True;
      end;
    if {$IFDEF FPC}(lcom_Component.ClassNameIs(CST_ONFORMINI_RICHVIEW) or lcom_Component.ClassNameIs(CST_ONFORMINI_RICHMEMO) {$ELSE} (lcom_Component is  TCustomRichEdit {$ENDIF})
    and GetfeSauveEdit(FSaveEdits ,feTRichEdit)
    and ( fobj_getComponentObjectProperty(lcom_Component, CST_ONFORMINI_LINES ) <> nil)
     then
      begin
        SauveTStringsDansIni(FInifile, af_Form.Name + '-' +  lcom_Component.Name,fobj_getComponentObjectProperty(lcom_Component, CST_ONFORMINI_LINES ) as TStrings,0);
        Result := True;
      end;

  end;

  function fb_WriteCombos : Boolean;
  Begin
    Result := False;
    if (lcom_Component.CLassNameIs( CST_ONFORMINI_EXTCOLOR)) and GetfeSauveEdit(FSaveEdits ,feTColorCombo)
     then
      begin
        p_WriteInteger(lcom_Component.Name+ CST_ONFORMINI_DOT + CST_ONFORMINI_VALUE, Flin_getComponentProperty (lcom_Component, CST_ONFORMINI_VALUE));
        // No continue : Maybe a customcombo
        Result := True;
      End;
    if (lcom_Component is TCustomComboBox) and GetfeSauveEdit(FSaveEdits ,feTComboValue)
    and not assigned ( fobj_getComponentObjectProperty(lcom_Component,CST_ONFORMINI_DATASOURCE))
     Then
      begin
        if   assigned ( GetPropInfo ( lcom_Component, CST_INI_TEXT ))
        then p_WriteString(lcom_Component.Name+CST_ONFORMINI_DOT + CST_INI_TEXT, GetPropValue    ( lcom_Component, CST_INI_TEXT))
        Else if   assigned ( GetPropInfo ( lcom_Component, CST_INI_ITEMINDEX ))
        Then p_WriteInteger(lcom_Component.Name+CST_ONFORMINI_DOT + CST_INI_ITEMINDEX, GetPropValue ( lcom_Component, CST_INI_ITEMINDEX ));
          // No continue : Maybe a customcombo
        Result := True;
      End;
  {$IFDEF RX}
    if GetfeSauveEdit(FSaveEdits ,feTComboValue)
    and (lcom_Component is {$IFDEF FPC}TRxCustomDBLookupCombo{$ELSE}TRxLookupControl{$ENDIF})
    and not assigned ( fobj_getComponentObjectProperty(lcom_Component,CST_ONFORMINI_DATASOURCE))
     then
      begin
       {$IFNDEF FPC}
        if (lcom_Component is TRxDBLookupList) Then
          p_WriteString(lcom_Component.Name + CST_ONFORMINI_DOT + CST_ONFORMINI_VALUE, (lcom_Component as TRxDBLookupList).DisplayValue)
         else
        {$ENDIF}
          if (lcom_Component is TRxDBLookupCombo) Then
          {$IFDEF FPC}
            p_WriteInteger(lcom_Component.Name + CST_ONFORMINI_DOT + CST_ONFORMINI_INDEX, (lcom_Component as TRxDBLookupCombo).LookupDisplayIndex);
          {$ELSE}
            p_WriteString(lcom_Component.Name + CST_ONFORMINI_DOT + CST_ONFORMINI_VALUE, (lcom_Component as TRxDBLookupCombo).DisplayValue);
           {$ENDIF}
          // No continue : Maybe a customcombo
        Result := True;
      End;
  {$ENDIF}
    if (lcom_Component is TCustomComboBox)       and GetfeSauveEdit(FSaveEdits ,feTComboBox)        then
      begin
        p_writeComboBoxItems(lcom_Component,TCustomComboBox(lcom_Component).Items);
        Result := True;
      end;

  end;

  function fb_WriteInteractivityComponents : Boolean;
  var k : Cardinal;
  Begin
    Result := False;
    // Écriture de la position des colonnes des grilles
    // Ecriture de la page de contrôle(onglets)
    if (lcom_Component is TCustomTabControl)     and GetfeSauveEdit(FSaveEdits, feTPageControl )   then
      begin
        if IsPublishedProp(lcom_Component, CST_ONFORMINI_TABINDEX )
         Then p_WriteInteger(lcom_Component.Name,flin_getComponentProperty(lcom_Component, CST_ONFORMINI_TABINDEX ))
         Else p_WriteInteger(lcom_Component.Name,flin_getComponentProperty(lcom_Component, CST_ONFORMINI_PAGEINDEX ));
        Result := True;
      end;
    // Ecriture de PopupMenu
    if (lcom_Component is TPopupMenu )     and GetfeSauveEdit(FSaveEdits, feTPopup )  then
      begin
        mit := TMenu(lcom_Component).Items;
        for k := 0 to mit.Count-1 do
          begin
            FInifile.WriteBool (af_Form.Name, lcom_Component.Name+'_'+mit.Items[k].Name , mit.Items[k].Checked);
          end;
        Result := True;
      end;
  End;

  function fb_WriteListBoxes : Boolean;
  Begin
    Result := False;
    if (lcom_Component is TListBox)        and GetfeSauveEdit(FSaveEdits ,feTListBox)         then
      begin
        SauveTStringsDansIni(FInifile, lcom_Component.Name,TCustomListBox(lcom_Component).Items,TListBox(lcom_Component).ItemIndex);
        Result := True;
      end;
  {$IFDEF DELPHI}
    if (lcom_Component is TDateTimePicker) and GetfeSauveEdit(FSaveEdits ,feTDateTimePicker)  then
      begin
        p_WriteString(lcom_Component.Name,DateTimeToStr(TDateTimePicker(lcom_Component).DateTime));
        Result := True;
      end;
  {$ENDIF}

  End;

begin
  f_GetMemIniFile();
  //Erasing The current section before saving
  FIniFile.EraseSection(af_Form.Name);
  ab_continue := True;
  If Assigned ( FOnIniWrite ) Then
    FOnIniWrite ( FInifile, ab_continue );
  If not ab_continue Then
    Exit;
  if not Assigned(FInifile) then Exit;

      // traitement de la position de la af_Form
  if (TFormStyle ( flin_getComponentProperty ( af_Form, CST_ONFORMINI_DOT + CST_ONFORMINI_FORMSTYLE )) <> fsMDIChild)
  and ( sfSaveSizes in FSaveForm )  then
    p_EcriturePositionFenetre(af_Form);

      // Traitement des composants de la af_Form
  if ( sfSaveSizes in FSaveForm ) or (FSaveEdits <> []) Then
  For j:=0 to af_Form.ComponentCount-1 do
    begin
      lcom_Component := af_Form.Components[j];
      Try
        if fb_WriteHighComponents Then
          Continue;

        // écriture des données des objets dans le fichier ini.
        if FSaveEdits <> [] Then
        begin
          if fb_WriteEdits Then
            Continue;
          if fb_WriteSpecialEdits Then
            Continue;
          if fb_WriteOptions Then
            Continue;
          if fb_WriteDirectories Then
            Continue;
          if fb_WriteFiles Then
            Continue;
          if fb_WriteMemos Then
            Continue;
          if fb_WriteCombos Then
            continue ;
          if fb_WriteListBoxes Then
            Continue;
          if fb_WriteInteractivityComponents Then
            Continue;
        end;
        Except
        end;
      end;
  if not FUpdateAll
  and ( loAutoUpdate in FOptions ) Then
    Begin
      fb_iniWriteFile ( FInifile, False );
    End;

end;

////////////////////////////////////////////////////////////////////////////////
//  Lecture de la position des colonnes des grilles dans le fichier INI
////////////////////////////////////////////////////////////////////////////////
procedure TOnFormInfoIni.p_LectureColonnes(const aF_Form: TCustomForm);

begin
end;


////////////////////////////////////////////////////////////////////////////////
// Lecture des données dans le fichier INI concernant la fenêtre uniquement
// traitement de la position de la af_Form mise dans le create
////////////////////////////////////////////////////////////////////////////////
procedure TOnFormInfoIni.p_LecturePositionFenetre(const aFiche: TCustomForm);
var li_etat, li_top,li_left,li_next,li_previous: integer;
    lr_rect : TRect;
begin
  // résolution de li_left'écran
 // li_ScreenHeight := f_IniReadSectionInt (aFiche.Name,CST_ONFORMINI_SCREEN + CST_ONFORMINI_DOT + CST_ONFORMINI_HEIGHT,Screen.Height);
 // li_ScreenWidth := f_IniReadSectionInt (aFiche.Name,CST_ONFORMINI_SCREEN + CST_ONFORMINI_DOT + CST_ONFORMINI_WIDTH,Screen.Width);

  with aFiche do
   begin
    li_etat := f_IniReadSectionInt (Name,name+CST_ONFORMINI_DOT + CST_ONFORMINI_WINDOWSTATE,0);
    case li_etat of
      0 : WindowState := wsNormal;
      1 : begin
            p_SetComponentProperty ( aFiche, CST_ONFORMINI_POSITION, poDefault );
            p_SetComponentProperty ( aFiche, CST_ONFORMINI_WINDOWSTATE, wsMaximized );
          end
      else  p_SetComponentProperty ( aFiche, CST_ONFORMINI_WINDOWSTATE, wsMinimized );
      End;

    if li_etat <> 1 then
    begin
      // positionnement de la fenêtre
      p_SetComponentProperty ( aFiche, CST_ONFORMINI_POSITION, poDesigned );

      Width := f_IniReadSectionInt (Name,name+CST_ONFORMINI_DOT + CST_ONFORMINI_WIDTH,Width) ;
      Height:= f_IniReadSectionInt (Name,name+CST_ONFORMINI_DOT + CST_ONFORMINI_HEIGHT,Height);
      Top   := f_IniReadSectionInt (Name,name+CST_ONFORMINI_DOT + CST_ONFORMINI_TOP,Top);
      Left  := f_IniReadSectionInt (Name,name+CST_ONFORMINI_DOT + CST_ONFORMINI_LEFT,Left);

      // André Langlet 2011
      if Height>=Screen.Height then
      begin
        Height:=Screen.Height;
        Top:=0;
      end
      else
      begin
        Top:=max(0,f_IniReadSectionInt (Name,name+CST_ONFORMINI_DOT + CST_ONFORMINI_TOP,Top));
        if (Top+Height)>Screen.Height then
          Top:=Screen.Height-Height;
      end;
      Width:=f_IniReadSectionInt (Name,name+CST_ONFORMINI_DOT + CST_ONFORMINI_WIDTH,Width);
      if Width>=Screen.Width then
      begin
        Width:=Screen.Width;
        Left:=0;
      end
      else
      begin
        Left:=max(0,f_IniReadSectionInt (Name,name+CST_ONFORMINI_DOT + CST_ONFORMINI_LEFT,Left));
        if (Left+Width)>Screen.Width then
          Left:=Screen.Width-Width;
      end;

      li_top:=Top+Height div 2; //centre de la fenêtre
      li_left:=Left+Width div 2;
      li_next:=0;
      li_previous:=-1;
      repeat //sur quel écran du bureau se trouve le centre de la fenêtre?
        if Screen.Monitors[li_next].Primary then
          li_previous:=li_next;
        lr_rect:=Screen.Monitors[li_next].BoundsRect;
        if (lr_rect.Left<=li_left)and(lr_rect.Right>li_left)and(lr_rect.Top<=li_top)and(lr_rect.Bottom>li_top)then
        begin
          Break;
        end;
        Inc(li_next);
      until li_next=Screen.MonitorCount;
      if li_next=Screen.MonitorCount then //fenêtre hors du bureau
      begin //retour sur moniteur primaire
        if li_previous>-1 then
          li_next:=li_previous
        else
          li_next:=0;
      end;
      lr_rect:=Screen.Monitors[li_next].WorkareaRect;
      //Replacement éventuel sur li_left'écran utilisé
      if (Top+Height)>lr_rect.Bottom then
        Top:=lr_rect.Bottom-Height;
      if Top<lr_rect.Top then
        Top:=lr_rect.Top;
      if (Left+Width)>lr_rect.Right then
        Left:=lr_rect.Right-Width;
      if Left<lr_rect.Left then
        Left:=lr_rect.Left;
   {   if Screen.Height <> li_ScreenHeight then
      begin
        Width := Round(Width * Screen.Width / li_ScreenWidth)  ;
        Height:= Round(Height * Screen.Height/li_ScreenHeight) ;
        Top   := Round(Top * Screen.Height/li_ScreenHeight) ;
        Left  := Round(Left * Screen.Width/li_ScreenWidth);
      end;
    }
    end;
  End;
  if Owner is TForm then
    DoSameMonitor(Owner as TForm);
end;

////////////////////////////////////////////////////////////////////////////////
// Ecriture des données dans le fichier ini concernant la fenêtre
////////////////////////////////////////////////////////////////////////////////
procedure TOnFormInfoIni.p_EcriturePositionFenetre ( const aFiche: TCustomForm);
var li_etat: integer;
begin
  with aFiche do
   Begin
    p_IniWriteSectionInt(Name,CST_ONFORMINI_SCREEN + CST_ONFORMINI_DOT + CST_ONFORMINI_HEIGHT,Screen.Height);
    p_IniWriteSectionInt(Name,CST_ONFORMINI_SCREEN + CST_ONFORMINI_DOT + CST_ONFORMINI_WIDTH,Screen.Width);

    // Etat de la fenêtre
    case WindowState of
      wsNormal    : li_etat := 0;
      wsMaximized : li_etat := 1;
      else          li_etat := 2;
      end;
    // sauvegarde de son état
    p_IniWriteSectionInt(Name,name+CST_ONFORMINI_DOT + CST_ONFORMINI_WINDOWSTATE,li_etat);

    // sauvegarde de sa position si la fenêtre n'est pas au Maximun
    if li_etat <> 1 then
      begin
        p_IniWriteSectionInt (Name,name+CST_ONFORMINI_DOT + CST_ONFORMINI_TOP,Top);
        p_IniWriteSectionInt (Name,name+CST_ONFORMINI_DOT + CST_ONFORMINI_LEFT,Left);
      end;
   end;
end;

{$IFDEF VERSIONS}
initialization
  p_ConcatVersion ( gVer_TSvgFormInfoIni );
{$ENDIF}
end.

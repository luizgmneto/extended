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

{$I ..\Compilers.inc}
{$I ..\extends.inc}

uses
{$IFDEF FPC}
  LCLIntf, lresources,
{$ELSE}
  RTLConsts,
  Windows, Mask, Consts, ShellAPI, JvToolEdit, U_ExtPageControl,
{$ENDIF}
{$IFDEF RX}
  RxLookup,
{$ENDIF}
  SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  IniFiles, StdCtrls, ComCtrls, ExtCtrls,
  Variants, Menus, Buttons,
{$IFDEF VERSIONS}
  fonctions_version,
{$ENDIF}
  ExtDlgs,
  fonctions_init, DBGrids;

{$IFDEF VERSIONS}
  const
    gVer_TSvgFormInfoIni : T_Version = ( Component : 'Composant TOnFormInfoIni' ;
                                               FileUnit : 'U_OnFormInfoIni' ;
                                               Owner : 'Matthieu Giroux' ;
                                               Comment : 'Gestion de l''ini à mettre sur une fiche.' ;
                                               BugsStory : '1.0.0.0 : Gestion de beaucoup de composants.';
                                               UnitType : 3 ;
                                               Major : 1 ; Minor : 0 ; Release : 0 ; Build : 0 );

{$ENDIF}
type
  // Liste des objets dont on veut conserver les donner dans le fichier INI
  TSauveEditObjet = (feTEdit, feTCheck, feTComboValue, feTComboBox, feTColorCombo,feTCurrencyEdit,feTDateEdit,
        {$IFDEF DELPHI}
        feTDateTimePicker,
        {$ENDIF}
  feTDirectoryEdit,feTFileNameEdit,feTGrid,feTListBox, feTListView, feTMemo, feTPageControl, feTPopup, feTRadio, feTRadioGroup, feTRichEdit,feTSpinEdit,
  feTVirtualTrees );
  TEventIni = procedure ( const AInifile : TCustomInifile ; var Continue : Boolean ) of object;
  TSauveEditObjets = set of TSauveEditObjet;

  { TOnFormInfoIni }

  TOnFormInfoIni = class(TComponent)
  private
    FSauveEditObjets: TSauveEditObjets;
    FSauvePosObjet,
    FAutoUpdate,
    FSauvePosForm:      Boolean;
    FOnIniLoad, FOnIniWrite : TEventIni;
  protected
    FUpdateAll ,
    FAutoChargeIni: Boolean;
    FormAOwner:     TCustomForm;
    FormOldDestroy: TNotifyEvent;
    FormOldCreate:  TNotifyEvent;
    FormOldShow:    TNotifyEvent;
//    procedure loaded; override;
    function ExisteComposantSvgEditSurLaFiche(Fiche:TCustomForm) :Integer;
    function GetfeSauveEdit(aSauveObjet:TSauveEditObjets;aObjet :TSauveEditObjet):Boolean ;
    // traitement de la position de la af_Form mise dans le create
    procedure p_LecturePositionFenetre(aFiche:TCustomForm);
    procedure p_EcriturePositionFenetre(aFiche:TCustomForm);

  public
    Constructor Create(AOwner:TComponent); override;
    procedure ExecuteLecture(aLocal:Boolean); virtual;
    procedure p_ExecuteLecture(const aF_Form: TCustomForm); virtual;
    procedure ExecuteEcriture(aLocal: Boolean); virtual;
    procedure p_ExecuteEcriture(const aF_Form: TCustomForm); virtual;
    procedure p_LectureColonnes(const aF_Form: TCustomForm); virtual;

    property AutoUpdate : Boolean read FAutoUpdate write FAutoUpdate;
  published
    // Propriété qui conserve la position des objets d'une form
    property SauvePosObjects: Boolean read FSauvePosObjet write FSauvePosObjet default False;
    // Propriété qui conserve les données des objets d'une form
    property SauveEditObjets: TSauveEditObjets read FSauveEditObjets write FSauveEditObjets nodefault;
    // Propriété qui conserve la position(index) des objets PageControl (onglets)
    property SauvePosForm: Boolean read FSauvePosForm  write FSauvePosForm default False;
    property OnIniLoad  : TEventIni read FOnIniLoad write FOnIniLoad ;
    property OnIniWrite : TEventIni read FOnIniWrite write FOnIniWrite;
    procedure LaFormDestroy(Sender: TObject);
    procedure LaFormShow(Sender: TObject);
    procedure LaFormCreate(Sender: TObject);
  end;

implementation

uses TypInfo, Grids, U_ExtNumEdits,
{$IFDEF FPC}
     richview, EditBtn,
{$ELSE}
{$IFDEF RX}
     rxToolEdit,
{$ENDIF}
{$ENDIF}
{$IFDEF VIRTUALTREES}
     VirtualTrees ,
{$ENDIF}
     unite_messages, fonctions_proprietes;

////////////////////////////////////////////////////////////////////////////////
// retourne le nom de la machine
////////////////////////////////////////////////////////////////////////////////
function FW_Read_Computer_Name : string;
begin
  Result := f_IniFWReadComputerName;
end;

////////////////////////////////////////////////////////////////////////////////
// Retourne le fichier INI
////////////////////////////////////////////////////////////////////////////////
function GetFileIni: string;
begin
  Result := ExtractFilePath(Application.ExeName) + CST_Avant_Fichier + FW_Read_Computer_Name + '.ini';
end;

////////////////////////////////////////////////////////////////////////////////
// permet de sauver dans un ini le contenu d'un mémo, d'un Combobox, d'un ListBox, d'un RichEdit
// et d'un façon générale, le contenu des composants qui le stocke dans des TStrings
////////////////////////////////////////////////////////////////////////////////
procedure SauveTStringsDansIni(FIni:TMemIniFile; SectionIni:string; LeTStrings:TStrings; ItemIndex:integer);
var i: integer;
begin
  Fini.EraseSection(SectionIni); // on efface toute la section décrite par SectionIni
  for i := 0 to LeTStrings.Count - 1 do // pour chaque ligne du Tstrings
  begin
    // on aura ainsi dans le fichier ini et dans la section considéré :
    // L0= suivi du contenu de la première ligne du TStrings. puis L1= etc..
    FIni.WriteString(SectionIni, 'L' + IntToStr(i), LeTStrings[i]);// écrit dans le fichier ini
  end;
  FIni.WriteInteger(SectionIni, 'ItemIndex', ItemIndex);
end;


////////////////////////////////////////////////////////////////////////////////
// permet de lire le contenu d'un ini qui a été sauvé par SauveTStringsDansIni
////////////////////////////////////////////////////////////////////////////////
procedure LitTstringsDeIni(FIni: TMemIniFile; SectionIni: string; LeTStrings: TStrings; var ItemIndex: integer);
var i: integer;
begin
  ItemIndex := -1;
  if FIni.SectionExists(SectionIni) then
    begin
      LeTStrings.Clear;
      i := 0;
      while FIni.ValueExists(SectionIni, 'L' + IntToStr(i)) do
        begin
          LeTStrings.Add(FIni.ReadString(SectionIni, 'L' + IntToStr(i), ''));
          inc(i);
        end;
      ItemIndex := Fini.ReadInteger(SectionIni, 'ItemIndex', 0);
    end;
end;


////////////////////////////////////////////////////////////////////////////////
// Constructeur de l'objet TOnFormInfoIni
////////////////////////////////////////////////////////////////////////////////
Constructor TOnFormInfoIni.Create(AOwner:TComponent);
var lmet_MethodToAdd  : TMethod;
begin
  FAutoChargeIni := True;
  Inherited Create(AOwner);
  FAutoUpdate    := False;
  FSauvePosObjet := False;
  FSauvePosForm  := False;
  FOnIniLoad     := nil;
  FOnIniWrite    := nil;
  if not (csDesigning in ComponentState)  //si on est pas en mode conception
  and ( AOwner is TCustomForm ) then
    begin
      lmet_MethodToAdd.Data := Self;
      lmet_MethodToAdd.Code := MethodAddress('LaFormDestroy' );
      FormAOwner           := TCustomForm(AOwner);        // La forme propriétaire de notre composant
      FormOldDestroy       := TNotifyEvent ( fmet_getComponentMethodProperty ( FormAOwner, 'OnDestroy' )); // Sauvegarde de l'événement OnDestroy
      p_SetComponentMethodProperty ( FormAOwner, 'OnDestroy', lmet_MethodToAdd );        // Idem pour OnDestroy
      FormOldCreate        := TNotifyEvent ( fmet_getComponentMethodProperty ( FormAOwner, 'OnCreate' ));  // Sauvegarde de l'événement OnClose
      lmet_MethodToAdd.Code := MethodAddress('LaFormCreate' );
      p_SetComponentMethodProperty ( FormAOwner, 'OnCreate', lmet_MethodToAdd );         // Idem pour OnClose
      FormOldShow          := TNotifyEvent ( fmet_getComponentMethodProperty ( FormAOwner, 'OnShow' ));  // Sauvegarde de l'événement OnShow
      lmet_MethodToAdd.Code := MethodAddress('LaFormShow' );
      p_SetComponentMethodProperty ( FormAOwner, 'OnShow', lmet_MethodToAdd );     // Idem pour OnShow
    End;
end;


////////////////////////////////////////////////////////////////////////////////
// Au chargement de l'objet TOnFormInfoIni, on lit les données dans le fichier ini
////////////////////////////////////////////////////////////////////////////////
{procedure TOnFormInfoIni.loaded;
begin
  inherited;
  if not Assigned(FormAOwner) then
    Exit;
end;
}
////////////////////////////////////////////////////////////////////////////////
// À la fermeture de la form, on écrit les données dans le fichier ini
////////////////////////////////////////////////////////////////////////////////
procedure TOnFormInfoIni.LaFormDestroy ( Sender: TObject );
begin
  if Assigned(FormAOwner)
   then
    p_ExecuteEcriture(FormAOwner);
  if Assigned(FormOldDestroy) then FormOldDestroy(Sender);
end;

////////////////////////////////////////////////////////////////////////////////
// À la fermeture de la form, on écrit les données dans le fichier ini
////////////////////////////////////////////////////////////////////////////////
procedure TOnFormInfoIni.LaFormCreate ( Sender: TObject );
var
  FIni:TMemIniFile;
  Indice :integer;
  SvgEditDeLaFiche:TOnFormInfoIni;

begin
  FUpdateAll := False ;
  FAutoUpdate := True ;
  if Assigned(FormOldCreate) then FormOldCreate(Sender);
  FIni := f_GetMemIniFile;
  if Assigned(FIni) then
    try
      Self.Updating ;
      Indice := ExisteComposantSvgEditSurLaFiche ( FormAOwner );
      if Indice <> -1 then
        begin
          SvgEditDeLaFiche:= TOnFormInfoIni(FormAOwner.Components[Indice]);

          // Traitement de la position de la af_Form
          if (TFormStyle ( flin_getComponentProperty ( FormAOwner, 'FormStyle' )) <> fsMDIChild) and (SvgEditDeLaFiche.FSauvePosForm) then
            p_LecturePositionFenetre(FormAOwner);
        end;

    finally
      Self.Updated;
    end;
end;

procedure TOnFormInfoIni.LaFormShow(Sender: TObject);

begin
  try
    if Assigned(FormOldShow)
     then FormOldShow(Sender);
  Except

  end;
  if FAutoChargeIni then
    Begin
      p_ExecuteLecture(TForm(Self.Owner));
    end;
end;


////////////////////////////////////////////////////////////////////////////////
// Fonction qui vérifie si l'objet TOnFormInfoIni existe dans la form et retourne son index
////////////////////////////////////////////////////////////////////////////////
function TOnFormInfoIni.ExisteComposantSvgEditSurLaFiche(Fiche:TCustomForm) :Integer;
var j: integer;
begin
  Result:=-1;
  for j := 0 to Fiche.ComponentCount - 1 do //pour chaque composant de la fiche
    if Fiche.Components[j] is TOnFormInfoIni then Result := j;
end;

////////////////////////////////////////////////////////////////////////////////
// Fonction qui regarde dans la propriété TSauveEditObjets de TOnFormInfoIni
// et renvoie la valeur de sauvegarde d'un objet de la form
////////////////////////////////////////////////////////////////////////////////
function TOnFormInfoIni.GetfeSauveEdit(aSauveObjet:TSauveEditObjets;aObjet :TSauveEditObjet):Boolean;
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
  if not Assigned(FormAOwner) then Exit;
  for i := 0 to Application.ComponentCount - 1 do //pour chaque fiche de l'application
    begin
      if Application.Components[i] is TForm
         and ((FormAOwner.Name = (TForm(Application.Components[i])).Name)
              and aLocal) or (not aLocal) then
        p_ExecuteLecture(TForm(Application.Components[i]));
    end; //fin pour chaque fiche de l'application
end;

////////////////////////////////////////////////////////////////////////////////
// Lecture des données dans le fichier INI
////////////////////////////////////////////////////////////////////////////////
procedure TOnFormInfoIni.p_ExecuteLecture(const aF_Form: TCustomForm);
var
  FIni: TMemIniFile;
  mit: TMenuItem;
  j, k, Indice, Rien, valItemIndex, li_Taille : integer;
  SvgEditDeLaFiche: TOnFormInfoIni;
  ls_Temp : String ;
  ab_continue : Boolean;
  lcom_Component : Tcomponent ;

  function fli_ReadInteger (const as_ComponentName : String; const ali_Default : Longint ):Longint;
  Begin
    Result := FIni.ReadInteger ( af_Form.Name, as_ComponentName, ali_Default );
  end;

  function fs_ReadString ( const as_ComponentName, as_Default : String ):String;
  Begin
    Result := FIni.ReadString ( af_Form.Name, as_ComponentName, as_Default );
  end;

begin
  FAutoChargeIni := False;
  Rien := 0;
  FIni := f_GetMemIniFile;
 {$IFDEF FPC}
    if FSauvePosObjet
    and ( Owner is TCustomForm ) Then
      Begin
        ( Owner as TCustomForm ).BeginUpdateBounds;
      End;
 {$ENDIF}
  ab_continue := True;

  if Assigned(FIni) then
    try
      Self.Updating;
      Indice := ExisteComposantSvgEditSurLaFiche(af_Form);
      if Indice <> -1 then
        begin
          SvgEditDeLaFiche:= TOnFormInfoIni(af_Form.Components[Indice]);

          If Assigned ( FOnIniLoad ) Then
            FOnIniLoad ( FIni, ab_continue );

          // traitement des composants de la af_Form
          if ab_continue Then
            for j := 0 to af_Form.ComponentCount - 1 do
              begin
                try
                  lcom_Component := aF_Form.Components[j];
                  if (lcom_Component is TDBGrid) and
                     GetfeSauveEdit(SvgEditDeLaFiche.FSauveEditObjets, feTGrid) then
                    begin
                      f_IniReadGridFromIni ( FIni, aF_Form.Name, lcom_Component as TDBGrid );
                    end;

                  if (lcom_Component.ClassNameIs ( 'TBaseVirtualTree' ))
                   and   GetfeSauveEdit(SvgEditDeLaFiche.FSauveEditObjets, feTVirtualTrees) then
                      begin
                        {$IFDEF DELPHI}
                        f_IniReadVirtualTreeFromIni ( FIni, aF_Form.Name, lcom_Component as TBaseVirtualTree );
                        {$ENDIF}
                    end;

                  if (lcom_Component is TListView)
                   and   GetfeSauveEdit(SvgEditDeLaFiche.FSauveEditObjets, feTListView) then
                      begin
                        f_IniReadListViewFromIni ( FIni, aF_Form.Name, lcom_Component as TListView );
  {                      for k := 0 to lsv_ListView.Columns.Count - 1 do
                          if FIni.ReadInteger(aF_Form.Name, lcom_Component.Name + '.' + lsv_ListView.Columns[k].Caption, lsv_ListView.Columns[k].Width) > 0 Then
                            lsv_ListView.Columns[k].Width := FIni.ReadInteger(aF_Form.Name, lcom_Component.Name + '.' + lsv_ListView.Columns[k].Caption, lsv_ListView.Columns[k].Width);}
                    end;

                  // lecture de la position des objets Panels et Rxsplitters
                  if (   (lcom_Component Is TPanel )
                      or (lcom_Component is TCustomListView )
                      {$IFDEF VIRTUALTREES}
                      or (lcom_Component is TBaseVirtualTree  )
                      {$ENDIF}
                      or (lcom_Component is TCustomGrid ))
                  and SvgEditDeLaFiche.FSauvePosObjet then
                    begin
                      li_Taille := fli_ReadInteger ( lcom_Component.Name +'.Width', TControl (lcom_Component).Width);
                      if li_Taille > 0 Then
                        TControl(lcom_Component).Width := li_Taille ;
                      li_Taille := fli_ReadInteger ( lcom_Component.Name +'.Height',TControl (lcom_Component).Height);
                      if li_Taille > 0 Then
                        TControl(lcom_Component).Height:= li_Taille ;
                      Continue;
                    end;

                  // lecture de la page de contrôle(onglets)
                  if ((lcom_Component is TPageControl)) and GetfeSauveEdit ( SvgEditDeLaFiche.FSauveEditObjets, feTPageControl )   then
                    begin
                      TPageControl(lcom_Component).ActivePageIndex := fli_ReadInteger ( lcom_Component.Name , 0);
                      Continue;
                    end;
                  // lecture des CheckBoxes
                  if (   (lcom_Component is TCheckBox)
                      or (lcom_Component.ClassNameIs( 'TJvXPCheckbox' ))
                      or (lcom_Component.ClassNameIs( 'TPCheck' )))
                   and GetfeSauveEdit ( SvgEditDeLaFiche.FSauveEditObjets, feTCheck ) then
                    begin
                      p_SetComponentBoolProperty(lcom_Component,'Checked', FIni.ReadBool(af_Form.name,lcom_Component.Name,fb_getComponentBoolProperty(lcom_Component, 'Checked')));
                      Continue;
                    end;
                  // lecture des RadioBoutons
                  if (lcom_Component is TRadioButton) and GetfeSauveEdit ( SvgEditDeLaFiche.FSauveEditObjets, feTRadio ) then
                    begin
                      TRadioButton(lcom_Component).Checked:= FIni.ReadBool(af_Form.name,lcom_Component.Name,true);
                      Continue;
                    end;
                  // lecture des groupes de RadioBoutons
                  if (lcom_Component is TRadioGroup)  and GetfeSauveEdit ( SvgEditDeLaFiche.FSauveEditObjets, feTRadioGroup ) then
                    begin
                      TRadioGroup(lcom_Component).ItemIndex:= fli_ReadInteger (lcom_Component.Name,0);
                      Continue;
                    end;
                  // lecture de PopupMenu
                  if (lcom_Component is TPopupMenu) and GetfeSauveEdit ( SvgEditDeLaFiche.FSauveEditObjets, feTPopup )  then
                    begin
                      mit := TMenu(lcom_Component).Items;
                      for k := 0 to mit.Count-1 do
                        begin
                          if mit.Items[k].RadioItem then
                            mit.Items[k].Checked := FIni.ReadBool (af_Form.Name, lcom_Component.Name+'_'+mit.Items[k].Name,true)
                          else
                            mit.Items[k].Checked := FIni.ReadBool (af_Form.Name, lcom_Component.Name+'_'+mit.Items[k].Name,False);
                        end;
                    end;

                  if (lcom_Component is TEdit) and GetfeSauveEdit(SvgEditDeLaFiche.FSauveEditObjets ,feTedit) then
                    begin
                      ls_Temp := fs_ReadString(lcom_Component.Name,'');
                      if ( ls_Temp <> '' ) Then
                        TCustomEdit(lcom_Component).Text := ls_Temp ;
                      Continue;
                    end;

                  if GetfeSauveEdit(SvgEditDeLaFiche.FSauveEditObjets ,feTDateEdit) Then
                    if (lcom_Component is {$IFDEF FPC} TDateEdit {$ELSE} TJvCustomDateEdit {$ENDIF}) then
                      Begin
                        {$IFDEF FPC} TDateEdit {$ELSE} TJvCustomDateEdit {$ENDIF}(lcom_Component).Date := StrToDateTime(fs_ReadString(lcom_Component.Name,DateToStr(Date)));
                        Continue;
                      End;

                  if GetfeSauveEdit(SvgEditDeLaFiche.FSauveEditObjets ,feTFileNameEdit) Then
                    Begin
                      {$IFDEF DELPHI}
                    if (lcom_Component is  TJvFileNameEdit) then
                      begin
                        TJvFileNameEdit (lcom_Component).Text := fs_ReadString( lcom_Component.Name, GetCurrentDir);
                        Continue;
                      end;
                       {$ENDIF}
                   {$IFDEF RX}
                    if (lcom_Component is TFileNameEdit ) then
                      begin
                        TFileNameEdit (lcom_Component).Text := fs_ReadString( lcom_Component.Name, GetCurrentDir);
                        Continue;
                      end;
                      {$ENDIF}
                    End ;

                  if GetfeSauveEdit(SvgEditDeLaFiche.FSauveEditObjets ,feTDirectoryEdit) Then
                    Begin
                      if (lcom_Component.ClassNameIs('TJvDirectoryEdit')) then
                        begin
                          ls_Temp := fs_ReadString(lcom_Component.Name, GetCurrentDir );
                          If DirectoryExists( ls_Temp ) Then
                            p_SetComponentProperty (lcom_Component, 'Text', ls_temp )
                           Else
                            p_SetComponentProperty (lcom_Component, 'Text', GetCurrentDir );
                        end;
                      if (lcom_Component is TDirectoryEdit) then
                        begin
                          ls_Temp := fs_ReadString(lcom_Component.Name, GetCurrentDir );
                          If DirectoryExists( ls_Temp ) Then
                            p_SetComponentProperty (lcom_Component, {$IFDEF FPC} 'Directory' {$ELSE} 'EditText' {$ENDIF}, ls_Temp )
                           Else
                            p_SetComponentProperty (lcom_Component, {$IFDEF FPC} 'Directory' {$ELSE} 'EditText' {$ENDIF}, GetCurrentDir );
                        end;
                     Continue;
                    End;


                  {$IFDEF DELPHI}
                  if GetfeSauveEdit(SvgEditDeLaFiche.FSauveEditObjets ,feTDateTimePicker) Then
                    if (lcom_Component is TDateTimePicker) then
                      begin
                        if fs_ReadString(lcom_Component.Name,'%ù@à*£')<>'%ù@à*£' then TDateTimePicker(lcom_Component).DateTime:=StrToDateTime( fs_ReadString(lcom_Component.Name,''));
                        Continue;
                      end;
                  {$ENDIF}
                  if GetfeSauveEdit(SvgEditDeLaFiche.FSauveEditObjets ,feTSpinEdit)
                  and (   (lcom_Component.ClassNameIs( 'TSpinEdit'))
                       or (lcom_Component.ClassNameIs( 'TRxSpinEdit')))
                     then
                      begin
                        p_SetComponentProperty(lcom_Component, 'Value', fli_ReadInteger (lcom_Component.Name,flin_getComponentProperty(lcom_Component, 'Value')));
                        Continue;
                      end;
                  if (lcom_Component is TMemo) and GetfeSauveEdit(SvgEditDeLaFiche.FSauveEditObjets ,feTMemo)        then
                    begin
                      LitTstringsDeIni(FIni, af_Form.name+lcom_Component.Name,TCustomMemo(lcom_Component).Lines,rien );
                      Continue;
                    end;
                  if (lcom_Component is {$IFDEF FPC} TRichView {$ELSE} TCustomRichEdit {$ENDIF}) and GetfeSauveEdit(SvgEditDeLaFiche.FSauveEditObjets ,feTRichEdit)    then
                    begin
                      LitTstringsDeIni(FIni, af_Form.name+lcom_Component.Name,{$IFDEF FPC} TRichView {$ELSE} TCustomRichEdit {$ENDIF}(lcom_Component).Lines,rien);
                      Continue;
                    end;
                  if (lcom_Component is TCustomComboBox) and GetfeSauveEdit(SvgEditDeLaFiche.FSauveEditObjets ,feTComboValue)
                  and not assigned ( fobj_getComponentObjectProperty(lcom_Component,'Datasource'))
                   then
                    begin
                        p_SetComponentProperty(lcom_Component, 'Text', fs_ReadString(lcom_Component.Name+'.Text',''));
                    End;
                  if (lcom_Component.CLassNameIs( 'TExtColorCombo')) and GetfeSauveEdit(SvgEditDeLaFiche.FSauveEditObjets ,feTColorCombo)
                   then
                    begin
                        p_SetComponentProperty(lcom_Component, 'Value', fs_ReadString(lcom_Component.Name+'.Value',''));
                    End;
  {$IFDEF RX}
                  if GetfeSauveEdit(SvgEditDeLaFiche.FSauveEditObjets ,feTComboValue)
                  and (lcom_Component is {$IFDEF FPC}TRxCustomDBLookupCombo{$ELSE}TRxLookupControl{$ENDIF})
                  and not assigned ( fobj_getComponentObjectProperty(lcom_Component,'Datasource'))
                   Then
                    begin
                      {$IFNDEF FPC}
                      if (lcom_Component is TRxDBLookupList ) Then
                        (lcom_Component as TRxDBLookupList).DisplayValue := fs_ReadString(lcom_Component.Name + '.Value', '')
                       else
                       {$ENDIF}
                        if (lcom_Component is TRxDBLookupCombo ) Then
                        {$IFDEF FPC}
                          (lcom_Component as TRxDBLookupCombo).LookupDisplayIndex := fli_ReadInteger (lcom_Component.Name + '.Index', -1);
                        {$ELSE}
                         (lcom_Component as TRxDBLookupCombo).DisplayValue := fs_ReadString(lcom_Component.Name + '.Index', '');
                         {$ENDIF}
                    End;
  {$ENDIF}
                  if (lcom_Component is TCustomComboBox) and GetfeSauveEdit(SvgEditDeLaFiche.FSauveEditObjets ,feTComboBox)    then
                    begin
                      valItemIndex := -1 ;
                      LitTstringsDeIni(FIni, af_Form.name+lcom_Component.Name,TCustomComboBox(lcom_Component).Items,valItemIndex);
                      if  ( valItemIndex>=0)
                      and ( valItemIndex<=TCustomComboBox(lcom_Component).Items.Count-1)
                       then
                        TCustomComboBox(lcom_Component).ItemIndex:=valItemIndex;
                      Continue;
                    end;
                  if (lcom_Component is TListBox) and GetfeSauveEdit(SvgEditDeLaFiche.FSauveEditObjets ,feTListBox)     then
                    begin
                      LitTstringsDeIni(FIni, af_Form.name+lcom_Component.Name,TCustomListBox(lcom_Component).Items,valItemIndex);
                      if valItemIndex<=TCustomListBox(lcom_Component).Items.Count-1 then TCustomListBox(lcom_Component).ItemIndex:=valItemIndex;
                      Continue;
                    end;
                  if  GetfeSauveEdit(SvgEditDeLaFiche.FSauveEditObjets ,feTCurrencyEdit) Then
                    if (lcom_Component is TExtNumEdit) then
                      begin
                        TExtNumEdit(lcom_Component).Text := fs_ReadString(lcom_Component.Name,' ');
                        Continue;
                      end;
                except
                end;
              end; // Fin for composant de la af_Form
        end;

    finally

   {$IFDEF FPC}
      if ab_continue
      and FSauvePosObjet
      and ( Owner is TCustomForm ) Then
        Begin
          ( Owner as TCustomForm ).EndUpdateBounds;
        End;
   {$ENDIF}
      Self.Updated;
    end;
end;

////////////////////////////////////////////////////////////////////////////////
// Ecriture des données dans le fichier ini
////////////////////////////////////////////////////////////////////////////////
procedure TOnFormInfoIni.ExecuteEcriture(aLocal:Boolean);
var i : Integer ;
    ab_continue : Boolean ;
    FIni : TMemIniFile;

begin

  if not assigned ( FormAOwner )
   Then
    Exit ;
  FUpdateAll := True ;
  ab_continue := True;
  FIni := f_GetMemIniFile;
  If Assigned ( FOnIniWrite ) Then
    FOnIniWrite ( FIni, ab_continue );
  if ab_continue Then
    try
      For i:=0 to application.ComponentCount-1 do //pour chaque af_Form de l'application
      begin
        if ( application.Components[i] is TCustomForm )
        and ((FormAOwner.Name = ( TForm ( application.Components[i] )).Name) and aLocal) or (Not aLocal)
         Then
          p_ExecuteEcriture ( TCustomForm ( application.Components[i] ));
      end; //fin pour chaque af_Form de l'application
    finally
      FUpdateAll := False ;

      if FAutoUpdate Then
        Begin
          fb_iniWriteFile ( FIni, False );
          Application.ProcessMessages ;

        End ;
    End ;
end;

////////////////////////////////////////////////////////////////////////////////
// Ecriture des données dans le fichier INI
////////////////////////////////////////////////////////////////////////////////
procedure TOnFormInfoIni.p_ExecuteEcriture ( const af_Form : TCustomForm );
var
  FIni: TMemIniFile;
  mit: TMenuItem;
  j, k, Indice: integer;
//  lvt_EnteteArbre : TVTHeader ;
//  lgd_grid: TDBGrid;
//  lsv_ListView : TListView ;
  SvgEditDeLaFiche: TOnFormInfoIni;
  lcom_Component : TComponent;
  procedure p_WriteString ( const as_ComponentName, as_Value : String );
  Begin
    FIni.WriteString ( af_Form.Name, as_ComponentName, as_Value );
  End;

  procedure p_WriteInteger ( const as_ComponentName : String; const ai_Value : Longint );
  Begin
    FIni.WriteInteger ( af_Form.Name, as_ComponentName, ai_Value );
  End;

begin
  FIni:= f_GetMemIniFile;
  if not Assigned(FIni) then Exit;

    Indice := ExisteComposantSvgEditSurLaFiche ( af_Form );
    if Indice <> -1 then
    begin
      SvgEditDeLaFiche:= TOnFormInfoIni(af_Form.Components[Indice]);
      // traitement de la position de la af_Form
      if (TFormStyle ( flin_getComponentProperty ( FormAOwner, 'FormStyle' )) <> fsMDIChild) and (SvgEditDeLaFiche.FSauvePosForm)  then
        p_EcriturePositionFenetre(af_Form);

      // Traitement des composants de la af_Form
      For j:=0 to af_Form.ComponentCount-1 do
      begin
        lcom_Component := aF_Form.Components[j];
        Try
          if (lcom_Component is TDBGrid) and
             GetfeSauveEdit(SvgEditDeLaFiche.FSauveEditObjets, feTGrid) then
            begin
              p_IniWriteGridToIni ( FIni, af_Form.Name, lcom_Component as TDBGrid );
              Continue;
            end;

              if (lcom_Component.ClassNameIs ( 'TBaseVirtualTree' ))
               and   GetfeSauveEdit(SvgEditDeLaFiche.FSauveEditObjets, feTVirtualTrees) then
                begin
                  {$IFDEF DELPHI}
                  p_IniWriteVirtualTreeToIni ( FIni, af_Form.Name, lcom_Component as TBaseVirtualTree );
                  {$ENDIF}
                  Continue;
                end;

              if (lcom_Component is TListView)
               and   GetfeSauveEdit(SvgEditDeLaFiche.FSauveEditObjets, feTListView) then
                begin
                  p_IniWriteListViewToIni ( FIni, af_Form.Name, lcom_Component as TListView );
                  Continue;
                end;

          // écriture des positions des objets Panels et RxSplitters
          if SvgEditDeLaFiche.FSauvePosObjet then
          begin
           if      (lcom_Component is TPanel)
                or (lcom_Component.ClassNameIs ( 'TBaseVirtualTree' ))
                or (lcom_Component is TCustomGrid)
                or (lcom_Component is TCustomListView) Then
                 begin
                  if TControl(lcom_Component).Width  > 0 Then
                    p_WriteInteger(lcom_Component.Name+'.Width',TControl(lcom_Component).Width);
                  if TControl(lcom_Component).Height > 0 Then
                    p_WriteInteger(lcom_Component.Name+'.Height',TControl(lcom_Component).Height);
                  Continue;
                end;
          end;

          // Écriture de la position des colonnes des grilles
          // Ecriture de la page de contrôle(onglets)
          if (lcom_Component is TPageControl)     and GetfeSauveEdit(SvgEditDeLaFiche.FSauveEditObjets, feTPageControl )   then
            begin
              p_WriteInteger(lcom_Component.Name,TPageControl(lcom_Component).ActivePageIndex );
              Continue;
            end;

          if ((lcom_Component is TCheckBox)
          or (lcom_Component.ClassNameIs( 'TJvXPCheckbox' ))
          or (lcom_Component.ClassNameIs( 'TPCheck' )))
          and GetfeSauveEdit(SvgEditDeLaFiche.FSauveEditObjets, feTCheck )
           then
            begin
              FIni.WriteBool(af_Form.name,lcom_Component.Name,fb_getComponentBoolProperty ( lcom_Component, 'Checked' ));
              Continue;
            end;
          if (lcom_Component is TRadioButton)    and GetfeSauveEdit(SvgEditDeLaFiche.FSauveEditObjets, feTRadio )      then
          begin
            FIni.WriteBool(af_Form.name,lcom_Component.Name,TRadioButton(lcom_Component).Checked);
            Continue;
            end;
          if (lcom_Component is TRadioGroup)     and GetfeSauveEdit(SvgEditDeLaFiche.FSauveEditObjets, feTRadioGroup )       then
          begin
            p_WriteInteger(lcom_Component.Name,TRadioGroup(lcom_Component).ItemIndex);
            Continue;
            end;
          // Ecriture de PopupMenu
          if (lcom_Component is TPopupMenu )     and GetfeSauveEdit(SvgEditDeLaFiche.FSauveEditObjets, feTPopup )  then
            begin
              mit := TMenu(lcom_Component).Items;
              for k := 0 to mit.Count-1 do
                begin
                  FIni.WriteBool (af_Form.Name, lcom_Component.Name+'_'+mit.Items[k].Name , mit.Items[k].Checked);
                end;
              Continue;
            end;
          // écriture des données des objets dans le fichier ini.
          if SvgEditDeLaFiche.FSauveEditObjets <> [] Then
          begin
            if (lcom_Component is TEdit)           and GetfeSauveEdit(SvgEditDeLaFiche.FSauveEditObjets ,feTEdit) then
            begin
              p_WriteString(lcom_Component.Name,TCustomEdit(lcom_Component).Text);
              Continue;
              end;
            if (lcom_Component is {$IFDEF FPC} TDateEdit {$ELSE} TJvCustomDateEdit {$ENDIF})       and GetfeSauveEdit(SvgEditDeLaFiche.FSauveEditObjets ,feTDateEdit) then
            begin
              p_WriteString(lcom_Component.Name,DateTimeToStr({$IFDEF FPC} TDateEdit {$ELSE} TJvCustomDateEdit {$ENDIF}(lcom_Component).Date));
              Continue;
              end;
              if GetfeSauveEdit(SvgEditDeLaFiche.FSauveEditObjets ,feTFileNameEdit) Then
                Begin
                {$IFDEF DELPHI}
                  If (lcom_Component is TJvFileNameEdit) then
                    begin
                      p_WriteString(lcom_Component.Name,TJvFileNameEdit(lcom_Component).Text);
                      Continue;
                    end;
                 {$ENDIF}
                {$IFDEF RX}
                  If (lcom_Component is TFileNameEdit) then
                    begin
                      p_WriteString(lcom_Component.Name,TFileNameEdit(lcom_Component).Text);
                      Continue;
                    end;
                 {$ENDIF}
                End ;
              if GetfeSauveEdit(SvgEditDeLaFiche.FSauveEditObjets ,feTDirectoryEdit) then
                begin
                  if (lcom_Component.ClassNameIs('TJvDirectoryEdit')) then
                    Begin
                      p_WriteString(lcom_Component.Name,fs_getComponentProperty(lcom_Component, 'Text'));
                      Continue;
                    End;
                  if (lcom_Component is TDirectoryEdit) then
                    begin
                      p_WriteString(lcom_Component.Name,fs_getComponentProperty(lcom_Component, {$IFDEF FPC} 'Directory' {$ELSE} 'EditText' {$ENDIF}));
                      Continue;
                    end;
                end;
              if GetfeSauveEdit(SvgEditDeLaFiche.FSauveEditObjets ,feTSpinEdit)
              and  (   (lcom_Component.ClassNameIs( 'TSpinEdit'))
                    or (lcom_Component.ClassNameIs( 'TRxSpinEdit')))
               then
                begin
                p_WriteInteger(lcom_Component.Name,flin_getComponentProperty(lcom_Component, 'Value' ));
                Continue;
                end;
              if (lcom_Component is TMemo)           and GetfeSauveEdit(SvgEditDeLaFiche.FSauveEditObjets ,feTMemo)            then
                begin
                SauveTStringsDansIni(FIni, af_Form.name+lcom_Component.Name,TMemo(lcom_Component).Lines,0);
                            Continue;
                end;
              if (lcom_Component is {$IFDEF FPC} TRichView {$ELSE} TCustomRichEdit {$ENDIF})       and GetfeSauveEdit(SvgEditDeLaFiche.FSauveEditObjets ,feTRichEdit)        then
                begin
                          SauveTStringsDansIni(FIni, af_Form.name+lcom_Component.Name,{$IFDEF FPC} TRichView {$ELSE} TCustomRichEdit {$ENDIF}(lcom_Component).Lines,0);
                Continue;
                end;
              if (lcom_Component.CLassNameIs( 'TExtColorCombo')) and GetfeSauveEdit(SvgEditDeLaFiche.FSauveEditObjets ,feTColorCombo)
               then
                begin
                    p_WriteInteger(lcom_Component.Name+ '.Value', Flin_getComponentProperty (lcom_Component, 'Value'));
                End;
              if (lcom_Component is TCustomComboBox) and GetfeSauveEdit(SvgEditDeLaFiche.FSauveEditObjets ,feTComboValue)
              and not assigned ( fobj_getComponentObjectProperty(lcom_Component,'Datasource'))
               Then
                begin
                  p_WriteString(lcom_Component.Name+'.Text',fs_getComponentProperty(lcom_Component, 'Text'));
                End;
            {$IFDEF RX}
              if GetfeSauveEdit(SvgEditDeLaFiche.FSauveEditObjets ,feTComboValue)
              and (lcom_Component is {$IFDEF FPC}TRxCustomDBLookupCombo{$ELSE}TRxLookupControl{$ENDIF})
              and not assigned ( fobj_getComponentObjectProperty(lcom_Component,'Datasource'))
               then
                begin
                 {$IFNDEF FPC}
                  if (lcom_Component is TRxDBLookupList) Then
                    p_WriteString(lcom_Component.Name + '.Value', (lcom_Component as TRxDBLookupList).DisplayValue)
                   else
                  {$ENDIF}
                    if (lcom_Component is TRxDBLookupCombo) Then
                    {$IFDEF FPC}
                      p_WriteInteger(lcom_Component.Name + '.Index', (lcom_Component as TRxDBLookupCombo).LookupDisplayIndex);
                    {$ELSE}
                      p_WriteString(lcom_Component.Name + '.Value', (lcom_Component as TRxDBLookupCombo).DisplayValue);
                     {$ENDIF}
                End;
            {$ENDIF}
              if (lcom_Component is TCustomComboBox)       and GetfeSauveEdit(SvgEditDeLaFiche.FSauveEditObjets ,feTComboBox)        then
                begin
                SauveTStringsDansIni(FIni, af_Form.name+lcom_Component.Name,TCustomComboBox(lcom_Component).Items,TCustomComboBox(lcom_Component).ItemIndex);
                Continue;
                end;
              if (lcom_Component is TListBox)        and GetfeSauveEdit(SvgEditDeLaFiche.FSauveEditObjets ,feTListBox)         then
                begin
                SauveTStringsDansIni(FIni, af_Form.name+lcom_Component.Name,TCustomListBox(lcom_Component).Items,TListBox(lcom_Component).ItemIndex);
                            Continue;
                end;
              if (lcom_Component is TExtNumEdit)   and GetfeSauveEdit(SvgEditDeLaFiche.FSauveEditObjets ,feTCurrencyEdit) then
                begin
                p_WriteString(lcom_Component.Name,TExtNumEdit(lcom_Component).Text);
                Continue;
                end;
            {$IFDEF DELPHI}
              if (lcom_Component is TDateTimePicker) and GetfeSauveEdit(SvgEditDeLaFiche.FSauveEditObjets ,feTDateTimePicker)  then
                begin
                p_WriteString(lcom_Component.Name,DateTimeToStr(TDateTimePicker(lcom_Component).DateTime));
                Continue;
                end;
            {$ENDIF}
            end;
          Except
          end;
        end;
      end;
    if not FUpdateAll
    and FAutoUpdate Then
      Begin
        fb_iniWriteFile ( Fini, False );
        Application.ProcessMessages ;
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
procedure TOnFormInfoIni.p_LecturePositionFenetre(aFiche: TCustomForm);
var li_etat, li_ScreenHeight, li_ScreenWidth: integer;
begin
  // Résolution de l'écran
  li_ScreenHeight := f_IniReadSectionInt (aFiche.Name,'Screen.Height',Screen.Height);
  li_ScreenWidth := f_IniReadSectionInt (aFiche.Name,'Screen.Width',Screen.Width);

  li_etat := f_IniReadSectionInt (aFiche.Name,aFiche.name+'.WindowState',0);
  // positionnement de la fenêtre
  p_SetComponentProperty ( aFiche, 'Position', poDesigned );
  if li_etat = 0 then
    aFiche.WindowState := wsNormal
  else
    if li_etat = 1 then
    begin
      p_SetComponentProperty ( aFiche, 'Position', poDefault );
      p_SetComponentProperty ( aFiche, 'WindowState', wsMaximized );
      end
    else
      p_SetComponentProperty ( aFiche, 'WindowState', wsMinimized );

  if li_etat <> 1 then
  begin
    aFiche.Width := f_IniReadSectionInt (aFiche.Name,aFiche.name+'.Width',aFiche.Width) ;
    aFiche.Height:= f_IniReadSectionInt (aFiche.Name,aFiche.name+'.Height',aFiche.Height);
    aFiche.Top   := f_IniReadSectionInt (aFiche.Name,aFiche.name+'.Top',aFiche.Top);
    aFiche.Left  := f_IniReadSectionInt (aFiche.Name,aFiche.name+'.Left',aFiche.Left);

    if Screen.Height <> li_ScreenHeight then
    begin
      aFiche.Width := Round(aFiche.Width * Screen.Width / li_ScreenWidth)  ;
      aFiche.Height:= Round(aFiche.Height * Screen.Height/li_ScreenHeight) ;
      aFiche.Top   := Round(aFiche.Top * Screen.Height/li_ScreenHeight) ;
      aFiche.Left  := Round(aFiche.Left * Screen.Width/li_ScreenWidth);
    end;

  end;
end;

////////////////////////////////////////////////////////////////////////////////
// Ecriture des données dans le fichier ini concernant la fenêtre
////////////////////////////////////////////////////////////////////////////////
procedure TOnFormInfoIni.p_EcriturePositionFenetre(aFiche: TCustomForm);
var li_etat: integer;
begin
  p_IniWriteSectionInt(aFiche.Name,'Screen.Height',Screen.Height);
  p_IniWriteSectionInt(aFiche.Name,'Screen.Width',Screen.Width);

  // Etat de la fenêtre
  if aFiche.WindowState = wsNormal then
    li_etat := 0
  else
    if aFiche.WindowState = wsMaximized then
      li_etat := 1
    else
      li_etat := 2;
  // sauvegarde de son état
  p_IniWriteSectionInt(aFiche.Name,aFiche.name+'.WindowState',li_etat);

  // sauvegarde de sa position si la fenêtre n'est pas au Maximun
  if li_etat <> 1 then
    begin
      p_IniWriteSectionInt (aFiche.Name,aFiche.name+'.Width',aFiche.Width);
      p_IniWriteSectionInt (aFiche.Name,aFiche.name+'.Height',aFiche.Height);
      p_IniWriteSectionInt (aFiche.Name,aFiche.name+'.Top',aFiche.Top);
      p_IniWriteSectionInt (aFiche.Name,aFiche.name+'.Left',aFiche.Left);
    end;
end;

{$IFDEF VERSIONS}
initialization
  p_ConcatVersion ( gVer_TSvgFormInfoIni );
{$ENDIF}
end.

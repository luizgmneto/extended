unit u_buttons_flat;

{$IFDEF FPC}
{$mode Delphi}
{$ENDIF}

{$I ..\DLCompilers.inc}
{$I ..\extends.inc}

interface

uses
 {$IFNDEF FPC}
    Windows,
 {$ENDIF}
  Classes, SysUtils,
  {$IFDEF VERSIONS}
  fonctions_version,
  {$ENDIF}
  u_buttons_appli, u_buttons_extension,
  Graphics, TFlatButtonUnit;

{$IFDEF VERSIONS}
const
    gVer_buttons_flat : T_Version = ( Component : 'Flat Buttons extension' ;
                                       FileUnit : 'u_buttons_flat' ;
                                       Owner : 'Matthieu Giroux' ;
                                       Comment : 'Composants boutons étendus.' ;
                                       BugsStory : '0.8.0.0 : Not tested.';
                                       UnitType : 3 ;
                                       Major : 0 ; Minor : 8 ; Release : 0 ; Build : 0 );
{$ENDIF}

type

    { TFBSpeedButton }

    TFBSpeedButton = class ( TFlatButton, IFWButton )
      public
       constructor Create(AOwner: TComponent); override;
      published
       property Glyph stored False;
     End;

    TFBClose = class ( TFBSpeedButton,IFWButton )
      private
      public
       constructor Create ( AOwner : TComponent ) ; override;
       procedure Loaded; override;
       procedure Click; override;
      published
       property Width default CST_FWWIDTH_CLOSE_BUTTON ;
     End;

{ TFBOK }
   TFBOK = class ( TFBSpeedButton,IFWButton )
      public
       constructor Create ( AOwner : TComponent ) ; override;
       procedure Loaded; override;
     End;

{ TFBInsert }
   TFBInsert = class ( TFBSpeedButton,IFWButton )
      public
       constructor Create ( AOwner : TComponent ) ; override;
     End;
{ TFBAdd }
   TFBAdd = class ( TFBSpeedButton,IFWButton )
      public
       constructor Create ( AOwner : TComponent ) ; override;
     End;

{ TFBDelete }
  TFBDelete = class ( TFBSpeedButton,IFWButton )
     public
      constructor Create ( AOwner : TComponent ) ; override;
    End;

{ TFBDocument }
   TFBDocument = class ( TFBSpeedButton,IFWButton )
      public
       procedure Loaded; override;
     End;

{ TFBQuit }
   TFBQuit = class ( TFBSpeedButton,IFWButton )
      public
       constructor Create ( AOwner : TComponent ) ; override;
     End;

{ TFBErase }
   TFBErase = class ( TFBSpeedButton,IFWButton )
      public
       constructor Create ( AOwner : TComponent ) ; override;
     End;

{ TFBSaveAs }
   TFBSaveAs = class ( TFBSpeedButton,IFWButton )
      public
       constructor Create ( AOwner : TComponent ) ; override;
     End;

   { TFBLoad }
      TFBLoad = class ( TFBSpeedButton,IFWButton )
         private
         public
          constructor Create ( AOwner : TComponent ) ; override;
        End;

{ TFBPrint }
   TFBPrint = class ( TFBSpeedButton,IFWButton )
      public
       constructor Create ( AOwner : TComponent ) ; override;
     End;

{ TFBCancel }
   TFBCancel = class ( TFBSpeedButton,IFWButton )
      public
       constructor Create ( AOwner : TComponent ) ; override;
      published
       property Caption stored False;
     End;


{ TFBPreview }
   TFBPreview = class ( TFBSpeedButton,IFWButton )
      public
       procedure Loaded; override;
     End;

{ TFBNext }
   TFBNext = class ( TFBSpeedButton,IFWButton )
      public
       procedure Loaded; override;
     End;

{ TFBPrior }
   TFBPrior= class ( TFBSpeedButton,IFWButton )
      public
       procedure Loaded; override;
     End;

{ TFBCopy }
   TFBCopy = class ( TFBSpeedButton,IFWButton )
      private
      public
       constructor Create ( AOwner : TComponent ) ; override;
     End;

{ TFBInit }
   TFBInit = class ( TFBSpeedButton,IFWButton )
      public
       procedure Loaded; override;
     End;

{ TFBConfig }
   TFBConfig = class ( TFBSpeedButton,IFWButton )
      public
       procedure Loaded; override;
     End;

{ TFBImport }
   TFBImport = class ( TFBSpeedButton,IFWButton )
      public
       procedure Loaded; override;
     End;
{ TFBTrash }
   TFBTrash = class ( TFBSpeedButton,IFWButton )
      public
       procedure Loaded; override;
     End;

{ TFBExport }
   TFBExport = class ( TFBSpeedButton,IFWButton )
      public
       procedure Loaded; override;
     End;

{$IFDEF GROUPVIEW}

{ TFBGroupButton }

    { TFBGroupButtonActions }

    TFBGroupButtonActions = class ( TFBSpeedButton,IFWButton )
     public
      constructor Create ( AOwner : TComponent ) ; override;
     published
      property Width  default CST_WIDTH_BUTTONS_ACTIONS;
      property Height default CST_HEIGHT_BUTTONS_ACTIONS;
    end;


   { TFBBasket }

   TFBBasket = class ( TFBGroupButtonActions )
      public
       constructor Create ( AOwner : TComponent ) ; override;
      published
       property Caption stored False;
     End;

   { TFBRecord }

   TFBRecord = class ( TFBGroupButtonActions )
      public
       constructor Create ( AOwner : TComponent ) ; override;
      published
       property Caption stored False;
     End;

   { TFBGroupButtonMoving }

   TFBGroupButtonMoving = class ( TFBSpeedButton,IFWButton )
   public
    constructor Create ( AOwner : TComponent ) ; override;
   published
    property Width  default CST_WIDTH_BUTTONS_MOVING;
    property Height default CST_HEIGHT_BUTTONS_MOVING;
   end;
   { TFBOutSelect }
    TFBOutSelect = class ( TFBGroupButtonMoving )
       public
        procedure Loaded; override;
      End;

   { TFBOutAll }


   TFBOutAll = class ( TFBGroupButtonMoving )
      public
       procedure Loaded; override;
     End;

{ TFBInSelect }
   TFBInSelect = class ( TFBGroupButtonMoving )
      public
       procedure Loaded; override;
     End;

{ TFBInAll }
   TFBInAll = class ( TFBGroupButtonMoving )
      public
       procedure Loaded; override;
     End;

{$ENDIF}

implementation

uses {$IFDEF FPC}ObjInspStrConsts,
     {$ELSE}Consts, VDBConsts, {$ENDIF}
     unite_messages, Dialogs,
     Forms ;


{$IFNDEF FPC}
var Buttons_Appli_ResInstance             : THandle      = 0 ;
{$ENDIF}

{ TFBSpeedButton }

constructor TFBSpeedButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Glyph.Clear;
end;

{ TFBTrash }

procedure TFBTrash.Loaded;
begin
  p_Load_Buttons_Appli ( Glyph, CST_FWTRASH );
  inherited Loaded;

end;

{ TFBLoad }

constructor TFBLoad.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  {$IFDEF FPC}
  caption := oiStdActFileOpenHint;
  {$ENDIF}
  p_Load_Buttons_Appli ( Glyph, CST_FWLOAD );
end;

{ TFBDocument }

procedure TFBDocument.Loaded;
begin
  p_Load_Buttons_Appli ( Glyph, CST_FWDOCUMENT );
  inherited Loaded;

end;

{ TFBDelete }

constructor TFBDelete.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  {$IFDEF FPC}
  Caption := srVK_DELETE;
  {$ELSE}
//  Caption := SDeleteRecord;
  {$ENDIF}
  p_Load_Buttons_Appli ( Glyph, CST_FWDELETE );
end;

{ TFBClose }


procedure TFBClose.Click;
begin
  if not assigned ( OnClick )
  and ( Owner is TCustomForm ) then
    with Owner as TCustomForm do
     Begin
      Close;
      Exit;
     End;
  inherited;

end;

constructor TFBClose.Create(AOwner: TComponent);
begin
  inherited;
  Caption := SCloseButton;
  Width := CST_FWWIDTH_CLOSE_BUTTON;
end;

procedure TFBClose.Loaded;
begin
  p_Load_Buttons_Appli ( Glyph, CST_FWCLOSE );
  inherited Loaded;

end;

{ TFBCancel }

constructor TFBCancel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  {$IFDEF FPC}
  Caption := oiStdActDataSetCancel1Hint;
  {$ELSE}
  Caption := SMsgDlgCancel;
  {$ENDIF}
  p_Load_Buttons_Appli ( Glyph, CST_FWCANCEL );
end;

{ TFBOK }

constructor TFBOK.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  {$IFDEF FPC}
  Caption := oisOk2;
  {$ELSE}
  Caption := SMsgDlgOK;
  {$ENDIF}
end;

procedure TFBOK.Loaded;
begin
  p_Load_Buttons_Appli ( Glyph, CST_FWOK );
  inherited Loaded;

end;

{ TFBInsert }

constructor TFBInsert.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  {$IFDEF FPC}
  Caption := srVK_INSERT;
  {$ELSE}
  Caption := SInsertRecord;
  {$ENDIF}
  p_Load_Buttons_Appli ( Glyph, CST_FWINSERT );
end;

{ TFBAdd }

constructor TFBAdd.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  p_Load_Buttons_Appli ( Glyph, CST_FWINSERT );
end;

{ TFBSaveAs }

constructor TFBSaveAs.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  {$IFDEF FPC}
  caption := oiStdActFileSaveAsHint;
  {$ENDIF}
  p_Load_Buttons_Appli ( Glyph, CST_FWSAVEAS );
end;

{ TFBQuit }

constructor TFBQuit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Caption := SCloseButton {$IFDEF FPC}+ ' ' + oisAll{$ENDIF};
  p_Load_Buttons_Appli ( Glyph, CST_FWQUIT );
end;

{ TFBerase }

constructor TFBErase.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  {$IFDEF FPC}
  Caption := oisDelete;
  {$ELSE}
  //Caption := SDeleteRecord;
  {$ENDIF}
  p_Load_Buttons_Appli ( Glyph, CST_FWERASE );
end;

{ TFBPrint }

constructor TFBPrint.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  {$IFDEF FPC}
  Caption := srVK_PRINT;
  {$ENDIF}
  p_Load_Buttons_Appli ( Glyph, CST_FWPRINT );
end;

{ TFBNext }

procedure TFBNext.Loaded;
begin
  p_Load_Buttons_Appli ( Glyph, CST_FWNEXT );
  inherited Loaded;

end;
{ TFBPrior }

procedure TFBPrior.Loaded;
begin
  p_Load_Buttons_Appli ( Glyph, CST_FWPRIOR );
  inherited Loaded;

end;

{ TFBPreview }

procedure TFBPreview.Loaded;
begin
  p_Load_Buttons_Appli ( Glyph, CST_FWPREVIEW );
  inherited Loaded;

end;

{ TFBInit }

procedure TFBInit.Loaded;
begin
  p_Load_Buttons_Appli ( Glyph, CST_FWINIT );
  inherited Loaded;

end;

{ TFBConfig }

procedure TFBConfig.Loaded;
begin
  p_Load_Buttons_Appli ( Glyph, CST_FWCONFIG );
  inherited Loaded;

end;

{ TFBImport }

procedure TFBImport.Loaded;
begin
  p_Load_Buttons_Appli ( Glyph, CST_FWIMPORT );
  inherited Loaded;

end;

{ TFBExport }

procedure TFBExport.Loaded;
begin
  p_Load_Buttons_Appli ( Glyph, CST_FWEXPORT );
  inherited Loaded;

end;

{ TFBCopy }

constructor TFBCopy.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  {$IFDEF FPC}
  Caption := oiStdActEditCopyShortHint;
  {$ENDIF}
  p_Load_Buttons_Appli ( Glyph, CST_FWCOPY );
end;

{$IFDEF GROUPVIEW}

{ TFBOutSelect }

procedure TFBOutSelect.Loaded;
begin
  p_Load_Buttons_Appli ( Glyph, CST_FWOUTSELECT );
  inherited Loaded;

end;

{ TFBBasket }

constructor TFBBasket.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  {$IFDEF FPC}
  Caption := oisUndo;
  {$ELSE}
  Caption := Gs_GROUPVIEW_Basket;
  {$ENDIF}
  p_Load_Buttons_Appli ( Glyph, CST_FWBASKET );
end;

{ TFBRecord }

constructor TFBRecord.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  {$IFDEF FPC}
  Caption := oisRecord;
  {$ELSE}
  Caption := Gs_GROUPVIEW_Record;
  {$ENDIF}
  p_Load_Buttons_Appli ( Glyph, CST_FWOK );
end;

{ TFBOutAll }

procedure TFBOutAll.Loaded;
begin
  p_Load_Buttons_Appli ( Glyph, CST_FWOUTALL );
  inherited Loaded;

end;

{ TFBInSelect }

procedure TFBInSelect.Loaded;
begin
  p_Load_Buttons_Appli ( Glyph, CST_FWINSELECT );
  inherited Loaded;

end;

{ TFBInAll }

procedure TFBInAll.Loaded;
begin
  p_Load_Buttons_Appli ( Glyph, CST_FWINALL );
  inherited Loaded;

end;



{ TFBGroupButtonActions }

constructor TFBGroupButtonActions.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Width  := CST_WIDTH_BUTTONS_ACTIONS;
  Height := CST_HEIGHT_BUTTONS_ACTIONS;
end;

{ TFBGroupButtonMoving }

constructor TFBGroupButtonMoving.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Width  := CST_WIDTH_BUTTONS_MOVING;
  Height := CST_HEIGHT_BUTTONS_MOVING;
  Caption := '';
end;

{$ENDIF}


initialization
{$IFDEF VERSIONS}
  p_ConcatVersion ( gVer_buttons_flat  );
{$ENDIF}

end.


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
  u_buttons_defs, u_buttons_extension,
  Graphics, TFlatButtonUnit;

{$IFDEF VERSIONS}
const
    gVer_buttons_flat : T_Version = ( Component : 'Flat Buttons extension' ;
                                       FileUnit : 'u_buttons_flat' ;
                                       Owner : 'Matthieu Giroux' ;
                                       Comment : 'Specialised buttons components' ;
                                       BugsStory : '0.8.0.0 : Not tested.';
                                       UnitType : 3 ;
                                       Major : 0 ; Minor : 8 ; Release : 0 ; Build : 0 );
{$ENDIF}

type

    { TFBSpeedButton }

    TFBSpeedButton = class ( TFlatButton, IFWButton )
      published
       property Glyph stored False;
     End;

    TFBClose = class ( TFBSpeedButton )
      private
      public
       constructor Create ( AOwner : TComponent ) ; override;
       procedure Loaded; override;
       procedure Click; override;
      published
       property Width default CST_FWWIDTH_CLOSE_BUTTON ;
     End;

{ TFBOK }
   TFBOK = class ( TFBSpeedButton )
      public
       constructor Create ( AOwner : TComponent ) ; override;
       procedure Loaded; override;
     End;

{ TFBInsert }
   TFBInsert = class ( TFBSpeedButton )
      public
       constructor Create ( AOwner : TComponent ) ; override;
     End;
{ TFBAdd }
   TFBAdd = class ( TFBSpeedButton )
      public
       constructor Create ( AOwner : TComponent ) ; override;
     End;

{ TFBDelete }
  TFBDelete = class ( TFBSpeedButton )
     public
      constructor Create ( AOwner : TComponent ) ; override;
    End;

{ TFBDocument }
   TFBDocument = class ( TFBSpeedButton )
      public
       procedure Loaded; override;
     End;

{ TFBQuit }
   TFBQuit = class ( TFBSpeedButton )
      public
       constructor Create ( AOwner : TComponent ) ; override;
     End;

{ TFBErase }
   TFBErase = class ( TFBSpeedButton )
      public
       constructor Create ( AOwner : TComponent ) ; override;
     End;

{ TFBSaveAs }
   TFBSaveAs = class ( TFBSpeedButton )
      public
       constructor Create ( AOwner : TComponent ) ; override;
     End;

   { TFBLoad }
      TFBLoad = class ( TFBSpeedButton )
         private
         public
          constructor Create ( AOwner : TComponent ) ; override;
        End;

{ TFBPrint }
   TFBPrint = class ( TFBSpeedButton )
      public
       constructor Create ( AOwner : TComponent ) ; override;
     End;

{ TFBCancel }
   TFBCancel = class ( TFBSpeedButton )
      public
       constructor Create ( AOwner : TComponent ) ; override;
      published
       property Caption stored False;
     End;


{ TFBPreview }
   TFBPreview = class ( TFBSpeedButton )
      public
       procedure Loaded; override;
     End;

{ TFBNext }
   TFBNext = class ( TFBSpeedButton )
      public
       procedure Loaded; override;
     End;

{ TFBPrior }
   TFBPrior= class ( TFBSpeedButton )
      public
       procedure Loaded; override;
     End;

{ TFBCopy }
   TFBCopy = class ( TFBSpeedButton )
      private
      public
       constructor Create ( AOwner : TComponent ) ; override;
     End;

{ TFBInit }
   TFBInit = class ( TFBSpeedButton )
      public
       procedure Loaded; override;
     End;

{ TFBConfig }
   TFBConfig = class ( TFBSpeedButton )
      public
       procedure Loaded; override;
     End;

{ TFBImport }
   TFBImport = class ( TFBSpeedButton )
      public
       procedure Loaded; override;
     End;
{ TFBTrash }
   TFBTrash = class ( TFBSpeedButton )
      public
       procedure Loaded; override;
     End;

{ TFBExport }
   TFBExport = class ( TFBSpeedButton )
      public
       procedure Loaded; override;
     End;

{$IFDEF GROUPVIEW}

{ TFBGroupButton }

    { TFBGroupButtonActions }

    TFBGroupButtonActions = class ( TFBSpeedButton )
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

   TFBGroupButtonMoving = class ( TFBSpeedButton )
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
     Forms, u_buttons_appli ;


{$IFNDEF FPC}
var Buttons_Appli_ResInstance             : THandle      = 0 ;
{$ENDIF}

{ TFBSpeedButton }


{ TFBTrash }

procedure TFBTrash.Loaded;
begin
  inherited Loaded;
  p_Load_Bitmap_Appli ( Glyph, CST_FWTRASH, self );

end;

{ TFBLoad }

constructor TFBLoad.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  {$IFDEF FPC}
  caption := oiStdActFileOpenHint;
  {$ENDIF}
  p_Load_Bitmap_Appli ( Glyph, CST_FWLOAD, self );
end;

{ TFBDocument }

procedure TFBDocument.Loaded;
begin
  inherited Loaded;
  p_Load_Bitmap_Appli ( Glyph, CST_FWDOCUMENT, self );
end;

{ TFBDelete }

constructor TFBDelete.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  p_Load_Bitmap_Appli ( Glyph, CST_FWDELETE, self );
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
  inherited Loaded;
  p_Load_Bitmap_Appli ( Glyph, CST_FWCLOSE, self );

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
  p_Load_Bitmap_Appli ( Glyph, CST_FWCANCEL, self );
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
  inherited Loaded;
  p_Load_Bitmap_Appli ( Glyph, CST_FWOK, self );

end;

{ TFBInsert }

constructor TFBInsert.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  {$IFNDEF FPC}
  Caption := srVK_INSERT;
  {$ENDIF}
  p_Load_Bitmap_Appli ( Glyph, CST_FWINSERT, self );
end;

{ TFBAdd }

constructor TFBAdd.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  p_Load_Bitmap_Appli ( Glyph, CST_FWINSERT, self );
end;

{ TFBSaveAs }

constructor TFBSaveAs.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  {$IFDEF FPC}
  caption := oiStdActFileSaveAsHint;
  {$ENDIF}
  p_Load_Bitmap_Appli ( Glyph, CST_FWSAVEAS, self );
end;

{ TFBQuit }

constructor TFBQuit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Caption := SCloseButton {$IFDEF FPC}+ ' ' + oisAll{$ENDIF};
  p_Load_Bitmap_Appli ( Glyph, CST_FWQUIT, self );
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
  p_Load_Bitmap_Appli ( Glyph, CST_FWERASE, self );
end;

{ TFBPrint }

constructor TFBPrint.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  p_Load_Bitmap_Appli ( Glyph, CST_FWPRINT, self );
end;

{ TFBNext }

procedure TFBNext.Loaded;
begin
  inherited Loaded;
  p_Load_Bitmap_Appli ( Glyph, CST_FWNEXT, self );

end;
{ TFBPrior }

procedure TFBPrior.Loaded;
begin
  inherited Loaded;
  p_Load_Bitmap_Appli ( Glyph, CST_FWPRIOR, self );

end;

{ TFBPreview }

procedure TFBPreview.Loaded;
begin
  inherited Loaded;
  p_Load_Bitmap_Appli ( Glyph, CST_FWPREVIEW, self );

end;

{ TFBInit }

procedure TFBInit.Loaded;
begin
  inherited Loaded;
  p_Load_Bitmap_Appli ( Glyph, CST_FWINIT, self );

end;

{ TFBConfig }

procedure TFBConfig.Loaded;
begin
  inherited Loaded;
  p_Load_Bitmap_Appli ( Glyph, CST_FWCONFIG, self );

end;

{ TFBImport }

procedure TFBImport.Loaded;
begin
  inherited Loaded;
  p_Load_Bitmap_Appli ( Glyph, CST_FWIMPORT, self );

end;

{ TFBExport }

procedure TFBExport.Loaded;
begin
  inherited Loaded;
  p_Load_Bitmap_Appli ( Glyph, CST_FWEXPORT, self );

end;

{ TFBCopy }

constructor TFBCopy.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  {$IFDEF FPC}
  Caption := oiStdActEditCopyShortHint;
  {$ENDIF}
  p_Load_Bitmap_Appli ( Glyph, CST_FWCOPY, self );
end;

{$IFDEF GROUPVIEW}

{ TFBOutSelect }

procedure TFBOutSelect.Loaded;
begin
  inherited Loaded;
  p_Load_Bitmap_Appli ( Glyph, CST_FWOUTSELECT, self );

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
  p_Load_Bitmap_Appli ( Glyph, CST_FWBASKET, self );
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
  p_Load_Bitmap_Appli ( Glyph, CST_FWOK, self );
end;

{ TFBOutAll }

procedure TFBOutAll.Loaded;
begin
  inherited Loaded;
  p_Load_Bitmap_Appli ( Glyph, CST_FWOUTALL, self );

end;

{ TFBInSelect }

procedure TFBInSelect.Loaded;
begin
  inherited Loaded;
  p_Load_Bitmap_Appli ( Glyph, CST_FWINSELECT, self );

end;

{ TFBInAll }

procedure TFBInAll.Loaded;
begin
  inherited Loaded;
  p_Load_Bitmap_Appli ( Glyph, CST_FWINALL, self );

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

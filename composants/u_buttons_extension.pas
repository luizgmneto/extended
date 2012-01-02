unit u_buttons_extension;

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
  u_buttons_appli,
  Controls,
  TFlatSpeedButtonUnit, Graphics;

{$IFDEF VERSIONS}
const
    gVer_buttons_ext : T_Version = ( Component : 'Buttons extension' ;
                                       FileUnit : 'u_buttons_extension' ;
                                       Owner : 'Matthieu Giroux' ;
                                       Comment : 'Composants boutons étendus.' ;
                                       BugsStory : '0.8.0.0 : Not tested.';
                                       UnitType : 3 ;
                                       Major : 0 ; Minor : 8 ; Release : 0 ; Build : 0 );
{$ENDIF}

procedure p_Load_Buttons_Appli ( const FGLyph : TBitmap; const as_Resource : String  ; const acon_control :TControl);

type
    TFSSpeedButton = class ( TFlatSpeedButton, IFWButton )
      published
       property Glyph stored False;
     End;

    TFSClose = class ( TFSSpeedButton )
      private
      public
       constructor Create ( AOwner : TComponent ) ; override;
       procedure Loaded; override;
       procedure Click; override;
      published
       property Width default CST_FWWIDTH_CLOSE_BUTTON ;
     End;

{ TFSOK }
   TFSOK = class ( TFSSpeedButton )
      public
       constructor Create ( AOwner : TComponent ) ; override;
       procedure Loaded; override;
     End;

{ TFSInsert }
   TFSInsert = class ( TFSSpeedButton )
      public
       constructor Create ( AOwner : TComponent ) ; override;
     End;
{ TFSAdd }
   TFSAdd = class ( TFSSpeedButton )
      public
       constructor Create ( AOwner : TComponent ) ; override;
     End;

{ TFSDelete }
  TFSDelete = class ( TFSSpeedButton )
     public
      constructor Create ( AOwner : TComponent ) ; override;
    End;

{ TFSDocument }
   TFSDocument = class ( TFSSpeedButton )
      public
       procedure Loaded; override;
     End;

{ TFSQuit }
   TFSQuit = class ( TFSSpeedButton )
      public
       constructor Create ( AOwner : TComponent ) ; override;
     End;

{ TFSErase }
   TFSErase = class ( TFSSpeedButton )
      public
       constructor Create ( AOwner : TComponent ) ; override;
     End;

{ TFSSaveAs }
   TFSSaveAs = class ( TFSSpeedButton )
      public
       constructor Create ( AOwner : TComponent ) ; override;
     End;

   { TFSLoad }
      TFSLoad = class ( TFSSpeedButton )
         private
         public
          constructor Create ( AOwner : TComponent ) ; override;
        End;

{ TFSPrint }
   TFSPrint = class ( TFSSpeedButton )
      public
       constructor Create ( AOwner : TComponent ) ; override;
     End;

{ TFSCancel }
   TFSCancel = class ( TFSSpeedButton )
      public
       constructor Create ( AOwner : TComponent ) ; override;
      published
       property Caption stored False;
     End;


{ TFSPreview }
   TFSPreview = class ( TFSSpeedButton )
      public
       procedure Loaded; override;
     End;

{ TFSNext }
   TFSNext = class ( TFSSpeedButton )
      public
       procedure Loaded; override;
     End;

{ TFSPrior }
   TFSPrior= class ( TFSSpeedButton )
      public
       procedure Loaded; override;
     End;

{ TFSCopy }
   TFSCopy = class ( TFSSpeedButton )
      private
      public
       constructor Create ( AOwner : TComponent ) ; override;
     End;

{ TFSInit }
   TFSInit = class ( TFSSpeedButton )
      public
       procedure Loaded; override;
     End;

{ TFSConfig }
   TFSConfig = class ( TFSSpeedButton )
      public
       procedure Loaded; override;
     End;

{ TFSImport }
   TFSImport = class ( TFSSpeedButton )
      public
       procedure Loaded; override;
     End;
{ TFSTrash }
   TFSTrash = class ( TFSSpeedButton )
      public
       procedure Loaded; override;
     End;

{ TFSExport }
   TFSExport = class ( TFSSpeedButton )
      public
       procedure Loaded; override;
     End;

{$IFDEF GROUPVIEW}

{ TFSGroupButton }

    { TFSGroupButtonActions }

    TFSGroupButtonActions = class ( TFSSpeedButton )
     public
      constructor Create ( AOwner : TComponent ) ; override;
     published
      property Width  default CST_WIDTH_BUTTONS_ACTIONS;
      property Height default CST_HEIGHT_BUTTONS_ACTIONS;
    end;


   { TFSBasket }

   TFSBasket = class ( TFSGroupButtonActions )
      public
       constructor Create ( AOwner : TComponent ) ; override;
      published
       property Caption stored False;
     End;

   { TFSRecord }

   TFSRecord = class ( TFSGroupButtonActions )
      public
       constructor Create ( AOwner : TComponent ) ; override;
      published
       property Caption stored False;
     End;

   { TFSGroupButtonMoving }

   TFSGroupButtonMoving = class ( TFSSpeedButton )
   public
    constructor Create ( AOwner : TComponent ) ; override;
   published
    property Width  default CST_WIDTH_BUTTONS_MOVING;
    property Height default CST_HEIGHT_BUTTONS_MOVING;
   end;
   { TFSOutSelect }
    TFSOutSelect = class ( TFSGroupButtonMoving )
       public
        procedure Loaded; override;
      End;

   { TFSOutAll }


   TFSOutAll = class ( TFSGroupButtonMoving )
      public
       procedure Loaded; override;
     End;

{ TFSInSelect }
   TFSInSelect = class ( TFSGroupButtonMoving )
      public
       procedure Loaded; override;
     End;

{ TFSInAll }
   TFSInAll = class ( TFSGroupButtonMoving )
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

procedure p_Load_Buttons_Appli ( const FGLyph : TBitmap; const as_Resource : String ; const acon_control :TControl );
Begin
  {$IFDEF FPC}
    FGLyph.BeginUpdate;
    FGLyph.FreeImage;
    FGlyph.LoadFromLazarusResource( as_Resource );
    FGLyph.EndUpdate;
    FGLyph.Modified:=True;
  {$ELSE}
    if ( Buttons_Appli_ResInstance = 0 ) Then
      Buttons_Appli_ResInstance:= FindResourceHInstance(HInstance);
    FGlyph.LoadFromResourceName(Buttons_Appli_ResInstance, as_Resource );
  {$ENDIF}
  if not csCreating in acon_control.ComponentState then
    acon_control.Invalidate;
end;

{ TFSTrash }

procedure TFSTrash.Loaded;
begin
  inherited Loaded;
  p_Load_Buttons_Appli ( Glyph, CST_FWTRASH, self );

end;

{ TFSLoad }

constructor TFSLoad.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  {$IFDEF FPC}
  caption := oiStdActFileOpenHint;
  {$ENDIF}
  p_Load_Buttons_Appli ( Glyph, CST_FWLOAD, self );
end;

{ TFSDocument }

procedure TFSDocument.Loaded;
begin
  inherited Loaded;
  p_Load_Buttons_Appli ( Glyph, CST_FWDOCUMENT, self );

end;

{ TFSDelete }

constructor TFSDelete.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  {$IFDEF FPC}
  Caption := srVK_DELETE;
  {$ELSE}
//  Caption := SDeleteRecord;
  {$ENDIF}
  p_Load_Buttons_Appli ( Glyph, CST_FWDELETE, self );
end;

{ TFSClose }


procedure TFSClose.Click;
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

constructor TFSClose.Create(AOwner: TComponent);
begin
  inherited;
  Caption := SCloseButton;
  Width := CST_FWWIDTH_CLOSE_BUTTON;
end;

procedure TFSClose.Loaded;
begin
  inherited Loaded;
  p_Load_Buttons_Appli ( Glyph, CST_FWCLOSE, self );

end;

{ TFSCancel }

constructor TFSCancel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  {$IFDEF FPC}
  Caption := oiStdActDataSetCancel1Hint;
  {$ELSE}
  Caption := SMsgDlgCancel;
  {$ENDIF}
  p_Load_Buttons_Appli ( Glyph, CST_FWCANCEL, self );
end;

{ TFSOK }

constructor TFSOK.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  {$IFDEF FPC}
  Caption := oisOk2;
  {$ELSE}
  Caption := SMsgDlgOK;
  {$ENDIF}
end;

procedure TFSOK.Loaded;
begin
  inherited Loaded;
  p_Load_Buttons_Appli ( Glyph, CST_FWOK, self );

end;

{ TFSInsert }

constructor TFSInsert.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  {$IFDEF FPC}
  Caption := srVK_INSERT;
  {$ELSE}
  Caption := SInsertRecord;
  {$ENDIF}
  p_Load_Buttons_Appli ( Glyph, CST_FWINSERT, self );
end;

{ TFSAdd }

constructor TFSAdd.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  p_Load_Buttons_Appli ( Glyph, CST_FWINSERT, self );
end;

{ TFSSaveAs }

constructor TFSSaveAs.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  {$IFDEF FPC}
  caption := oiStdActFileSaveAsHint;
  {$ENDIF}
  p_Load_Buttons_Appli ( Glyph, CST_FWSAVEAS, self );
end;

{ TFSQuit }

constructor TFSQuit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Caption := SCloseButton {$IFDEF FPC}+ ' ' + oisAll{$ENDIF};
  p_Load_Buttons_Appli ( Glyph, CST_FWQUIT, self );
end;

{ TFSerase }

constructor TFSErase.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  {$IFDEF FPC}
  Caption := oisDelete;
  {$ELSE}
  //Caption := SDeleteRecord;
  {$ENDIF}
  p_Load_Buttons_Appli ( Glyph, CST_FWERASE, self );
end;

{ TFSPrint }

constructor TFSPrint.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  {$IFDEF FPC}
  Caption := srVK_PRINT;
  {$ENDIF}
  p_Load_Buttons_Appli ( Glyph, CST_FWPRINT, self );
end;

{ TFSNext }

procedure TFSNext.Loaded;
begin
  inherited Loaded;
  p_Load_Buttons_Appli ( Glyph, CST_FWNEXT, self );
end;
{ TFSPrior }

procedure TFSPrior.Loaded;
begin
  inherited Loaded;
  p_Load_Buttons_Appli ( Glyph, CST_FWPRIOR, self );
end;

{ TFSPreview }

procedure TFSPreview.Loaded;
begin
  inherited Loaded;
  p_Load_Buttons_Appli ( Glyph, CST_FWPREVIEW, self );
end;

{ TFSInit }

procedure TFSInit.Loaded;
begin
  inherited Loaded;
  p_Load_Buttons_Appli ( Glyph, CST_FWINIT, self );
end;

{ TFSConfig }

procedure TFSConfig.Loaded;
begin
  inherited Loaded;
  p_Load_Buttons_Appli ( Glyph, CST_FWCONFIG, self );
end;

{ TFSImport }

procedure TFSImport.Loaded;
begin
  inherited Loaded;
  p_Load_Buttons_Appli ( Glyph, CST_FWIMPORT, self );
end;

{ TFSExport }

procedure TFSExport.Loaded;
begin
  inherited Loaded;
  p_Load_Buttons_Appli ( Glyph, CST_FWEXPORT, self );
end;

{ TFSCopy }

constructor TFSCopy.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  {$IFDEF FPC}
  Caption := oiStdActEditCopyShortHint;
  {$ENDIF}
  p_Load_Buttons_Appli ( Glyph, CST_FWCOPY, self );
end;

{$IFDEF GROUPVIEW}

{ TFSOutSelect }

procedure TFSOutSelect.Loaded;
begin
  inherited Loaded;
  p_Load_Buttons_Appli ( Glyph, CST_FWOUTSELECT, self );
end;

{ TFSBasket }

constructor TFSBasket.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  {$IFDEF FPC}
  Caption := oisUndo;
  {$ELSE}
  Caption := Gs_GROUPVIEW_Basket;
  {$ENDIF}
  p_Load_Buttons_Appli ( Glyph, CST_FWBASKET, self );
end;

{ TFSRecord }

constructor TFSRecord.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  {$IFDEF FPC}
  Caption := oisRecord;
  {$ELSE}
  Caption := Gs_GROUPVIEW_Record;
  {$ENDIF}
  p_Load_Buttons_Appli ( Glyph, CST_FWOK, self );
end;

{ TFSOutAll }

procedure TFSOutAll.Loaded;
begin
  inherited Loaded;
  p_Load_Buttons_Appli ( Glyph, CST_FWOUTALL, self );
end;

{ TFSInSelect }

procedure TFSInSelect.Loaded;
begin
  inherited Loaded;
  p_Load_Buttons_Appli ( Glyph, CST_FWINSELECT, self );
end;

{ TFSInAll }

procedure TFSInAll.Loaded;
begin
  inherited Loaded;
  p_Load_Buttons_Appli ( Glyph, CST_FWINALL, self );

end;



{ TFSGroupButtonActions }

constructor TFSGroupButtonActions.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Width  := CST_WIDTH_BUTTONS_ACTIONS;
  Height := CST_HEIGHT_BUTTONS_ACTIONS;
end;

{ TFSGroupButtonMoving }

constructor TFSGroupButtonMoving.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Width  := CST_WIDTH_BUTTONS_MOVING;
  Height := CST_HEIGHT_BUTTONS_MOVING;
  Caption := '';
end;

{$ENDIF}


initialization
{$IFDEF VERSIONS}
  p_ConcatVersion ( gVer_buttons_ext  );
{$ENDIF}

end.


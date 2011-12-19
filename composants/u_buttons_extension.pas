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

procedure p_Load_Buttons_Appli ( const FGLyph : TBitmap; const as_Resource : String );

type
    TFSClose = class ( TFlatSpeedButton,IFWButton )
      private
      public
       constructor Create ( AOwner : TComponent ) ; override;
       procedure Loaded; override;
       procedure Click; override;
      published
       property Glyph stored False;
       property Width default CST_FWWIDTH_CLOSE_BUTTON ;
     End;

{ TFSOK }
   TFSOK = class ( TFlatSpeedButton,IFWButton )
      private
      public
       constructor Create ( AOwner : TComponent ) ; override;
       procedure Loaded; override;
      published
       property Glyph stored False;
     End;

{ TFSInsert }
   TFSInsert = class ( TFlatSpeedButton,IFWButton )
      private
      public
       constructor Create ( AOwner : TComponent ) ; override;
       procedure Loaded; override;
      published
       property Glyph stored False;
     End;
{ TFSAdd }
   TFSAdd = class ( TFlatSpeedButton,IFWButton )
      private
      public
       constructor Create ( AOwner : TComponent ) ; override;
       procedure Loaded; override;
      published
       property Glyph stored False;
     End;

{ TFSDelete }
  TFSDelete = class ( TFlatSpeedButton,IFWButton )
     private
     public
      constructor Create ( AOwner : TComponent ) ; override;
      procedure Loaded; override;
     published
      property Glyph stored False;
    End;

{ TFSDocument }
   TFSDocument = class ( TFlatSpeedButton,IFWButton )
      private
      public
       procedure Loaded; override;
      published
       property Glyph stored False;
     End;

{ TFSQuit }
   TFSQuit = class ( TFlatSpeedButton,IFWButton )
      private
      public
       constructor Create ( AOwner : TComponent ) ; override;
       procedure Loaded; override;
      published
       property Glyph stored False;
     End;

{ TFSErase }
   TFSErase = class ( TFlatSpeedButton,IFWButton )
      private
      public
       constructor Create ( AOwner : TComponent ) ; override;
       procedure Loaded; override;
      published
       property Glyph stored False;
     End;

{ TFSSaveAs }
   TFSSaveAs = class ( TFlatSpeedButton,IFWButton )
      private
      public
       constructor Create ( AOwner : TComponent ) ; override;
       procedure Loaded; override;

      published
       property Glyph stored False;
     End;

   { TFSLoad }
      TFSLoad = class ( TFlatSpeedButton,IFWButton )
         private
         public
          constructor Create ( AOwner : TComponent ) ; override;
          procedure Loaded; override;

         published
          property Glyph stored False;
        End;

{ TFSPrint }
   TFSPrint = class ( TFlatSpeedButton,IFWButton )
      private
      public
       constructor Create ( AOwner : TComponent ) ; override;
       procedure Loaded; override;

      published
       property Glyph stored False;
     End;

{ TFSCancel }
   TFSCancel = class ( TFlatSpeedButton,IFWButton )
      private
      public
       constructor Create ( AOwner : TComponent ) ; override;
       procedure Loaded; override;

      published
       property Glyph stored False;
       property Caption stored False;
     End;


{ TFSPreview }
   TFSPreview = class ( TFlatSpeedButton,IFWButton )
      private
      public
       procedure Loaded; override;

      published
       property Glyph stored False;
     End;

{ TFSNext }
   TFSNext = class ( TFlatSpeedButton,IFWButton )
      private
      public
       procedure Loaded; override;

      published
       property Glyph stored False;
     End;

{ TFSPrior }
   TFSPrior= class ( TFlatSpeedButton,IFWButton )
      private
      public
       procedure Loaded; override;

      published
       property Glyph stored False;
     End;

{ TFSCopy }
   TFSCopy = class ( TFlatSpeedButton,IFWButton )
      private
      public
       constructor Create ( AOwner : TComponent ) ; override;
       procedure Loaded; override;
      published
       property Glyph stored False;
     End;

{ TFSInit }
   TFSInit = class ( TFlatSpeedButton,IFWButton )
      private
      public
       procedure Loaded; override;

      published
       property Glyph stored False;
     End;

{ TFSConfig }
   TFSConfig = class ( TFlatSpeedButton,IFWButton )
      private
      public
       procedure Loaded; override;

      published
       property Glyph stored False;
     End;

{ TFSImport }
   TFSImport = class ( TFlatSpeedButton,IFWButton )
      private
      public
       procedure Loaded; override;

      published
       property Glyph stored False;
     End;
{ TFSTrash }
   TFSTrash = class ( TFlatSpeedButton,IFWButton )
      private
      public
       procedure Loaded; override;

      published
       property Glyph stored False;
     End;

{ TFSExport }
   TFSExport = class ( TFlatSpeedButton,IFWButton )
      private
      public
       procedure Loaded; override;

      published
       property Glyph stored False;
     End;

{$IFDEF GROUPVIEW}

{ TFSGroupButton }

    { TFSGroupButtonActions }

    TFSGroupButtonActions = class ( TFlatSpeedButton,IFWButton )
     public
      constructor Create ( AOwner : TComponent ) ; override;
     published
      property Width  default CST_WIDTH_BUTTONS_ACTIONS;
      property Height default CST_HEIGHT_BUTTONS_ACTIONS;
    end;


   { TFSBasket }

   TFSBasket = class ( TFSGroupButtonActions )
      private
      public
       constructor Create ( AOwner : TComponent ) ; override;
       procedure Loaded; override;

      published
       property Glyph stored False;
       property Caption stored False;
     End;

   { TFSRecord }

   TFSRecord = class ( TFSGroupButtonActions )
      private
      public
       constructor Create ( AOwner : TComponent ) ; override;
       procedure Loaded; override;

      published
       property Glyph stored False;
       property Caption stored False;
     End;

   { TFSGroupButtonMoving }

   TFSGroupButtonMoving = class ( TFlatSpeedButton,IFWButton )
   public
    constructor Create ( AOwner : TComponent ) ; override;
   published
    property Width  default CST_WIDTH_BUTTONS_MOVING;
    property Height default CST_HEIGHT_BUTTONS_MOVING;
   end;
   { TFSOutSelect }
    TFSOutSelect = class ( TFSGroupButtonMoving )
       private
       public
        procedure Loaded; override;
       published
        property Glyph stored False;
      End;

   { TFSOutAll }


   TFSOutAll = class ( TFSGroupButtonMoving )
      private
      public
       procedure Loaded; override;
      published
       property Glyph stored False;
     End;

{ TFSInSelect }
   TFSInSelect = class ( TFSGroupButtonMoving )
      private
      public
       procedure Loaded; override;
      published
       property Glyph stored False;
     End;

{ TFSInAll }
   TFSInAll = class ( TFSGroupButtonMoving )
      private
      public
       procedure Loaded; override;
      published
       property Glyph stored False;
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

procedure p_Load_Buttons_Appli ( const FGLyph : TBitmap; const as_Resource : String );
Begin
  {$IFDEF FPC}
    FGLyph.BeginUpdate;
    FGlyph.Clear;
    FGlyph.LoadFromLazarusResource( as_Resource );
    FGLyph.EndUpdate;
    FGLyph.Modified:=True;
  {$ELSE}
    if ( Buttons_Appli_ResInstance = 0 ) Then
      Buttons_Appli_ResInstance:= FindResourceHInstance(HInstance);
    FGlyph.Bitmap.LoadFromResourceName(Buttons_Appli_ResInstance, as_Resource );
  {$ENDIF}
end;

{ TFSTrash }

procedure TFSTrash.Loaded;
begin
  p_Load_Buttons_Appli ( Glyph, CST_FWTRASH );
  inherited Loaded;

end;

{ TFSLoad }

constructor TFSLoad.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  {$IFDEF FPC}
  caption := oiStdActFileOpenHint;
  {$ENDIF}
end;

procedure TFSLoad.Loaded;
begin
  p_Load_Buttons_Appli ( Glyph, CST_FWLOAD );
  inherited Loaded;

end;

{ TFSDocument }

procedure TFSDocument.Loaded;
begin
  p_Load_Buttons_Appli ( Glyph, CST_FWDOCUMENT );
  inherited Loaded;

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
end;

procedure TFSDelete.Loaded;
begin
  p_Load_Buttons_Appli ( Glyph, CST_FWDELETE );
  inherited Loaded;

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
  p_Load_Buttons_Appli ( Glyph, CST_FWCLOSE );
  inherited Loaded;

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
end;

procedure TFSCancel.Loaded;
begin
  p_Load_Buttons_Appli ( Glyph, CST_FWCANCEL );
  inherited Loaded;

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
  p_Load_Buttons_Appli ( Glyph, CST_FWOK );
  inherited Loaded;

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
end;

procedure TFSInsert.Loaded;
begin
  p_Load_Buttons_Appli ( Glyph, CST_FWINSERT );
  inherited Loaded;

end;
{ TFSAdd }

constructor TFSAdd.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

procedure TFSAdd.Loaded;
begin
  p_Load_Buttons_Appli ( Glyph, CST_FWINSERT );
  inherited Loaded;

end;

{ TFSSaveAs }

constructor TFSSaveAs.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  {$IFDEF FPC}
  caption := oiStdActFileSaveAsHint;
  {$ENDIF}
end;

procedure TFSSaveAs.Loaded;
begin
  p_Load_Buttons_Appli ( Glyph, CST_FWSAVEAS );
  inherited Loaded;

end;

{ TFSQuit }

constructor TFSQuit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Caption := SCloseButton {$IFDEF FPC}+ ' ' + oisAll{$ENDIF};
end;

procedure TFSQuit.Loaded;
begin
  p_Load_Buttons_Appli ( Glyph, CST_FWQUIT );
  inherited Loaded;

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
end;

procedure TFSErase.Loaded;
begin
  p_Load_Buttons_Appli ( Glyph, CST_FWERASE );
  inherited Loaded;

end;

{ TFSPrint }

constructor TFSPrint.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  {$IFDEF FPC}
  Caption := srVK_PRINT;
  {$ENDIF}
end;

procedure TFSPrint.Loaded;
begin
  p_Load_Buttons_Appli ( Glyph, CST_FWPRINT );
  inherited Loaded;

end;

{ TFSNext }

procedure TFSNext.Loaded;
begin
  p_Load_Buttons_Appli ( Glyph, CST_FWNEXT );
  inherited Loaded;

end;
{ TFSPrior }

procedure TFSPrior.Loaded;
begin
  p_Load_Buttons_Appli ( Glyph, CST_FWPRIOR );
  inherited Loaded;

end;

{ TFSPreview }

procedure TFSPreview.Loaded;
begin
  p_Load_Buttons_Appli ( Glyph, CST_FWPREVIEW );
  inherited Loaded;

end;

{ TFSInit }

procedure TFSInit.Loaded;
begin
  p_Load_Buttons_Appli ( Glyph, CST_FWINIT );
  inherited Loaded;

end;

{ TFSConfig }

procedure TFSConfig.Loaded;
begin
  p_Load_Buttons_Appli ( Glyph, CST_FWCONFIG );
  inherited Loaded;

end;

{ TFSImport }

procedure TFSImport.Loaded;
begin
  p_Load_Buttons_Appli ( Glyph, CST_FWIMPORT );
  inherited Loaded;

end;

{ TFSExport }

procedure TFSExport.Loaded;
begin
  p_Load_Buttons_Appli ( Glyph, CST_FWEXPORT );
  inherited Loaded;

end;

{ TFSCopy }

constructor TFSCopy.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  {$IFDEF FPC}
  Caption := oiStdActEditCopyShortHint;
  {$ENDIF}
end;

procedure TFSCopy.Loaded;
begin
  p_Load_Buttons_Appli ( Glyph, CST_FWCOPY );
  inherited Loaded;

end;


{$IFDEF GROUPVIEW}

{ TFSOutSelect }

procedure TFSOutSelect.Loaded;
begin
  p_Load_Buttons_Appli ( Glyph, CST_FWOUTSELECT );
  inherited Loaded;

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
end;

procedure TFSBasket.Loaded;
begin
  p_Load_Buttons_Appli ( Glyph, CST_FWBASKET );
  inherited Loaded;

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
end;

procedure TFSRecord.Loaded;
begin
  p_Load_Buttons_Appli ( Glyph, CST_FWOK );
  inherited Loaded;

end;


{ TFSOutAll }

procedure TFSOutAll.Loaded;
begin
  p_Load_Buttons_Appli ( Glyph, CST_FWOUTALL );
  inherited Loaded;

end;

{ TFSInSelect }

procedure TFSInSelect.Loaded;
begin
  p_Load_Buttons_Appli ( Glyph, CST_FWINSELECT );
  inherited Loaded;

end;

{ TFSInAll }

procedure TFSInAll.Loaded;
begin
  p_Load_Buttons_Appli ( Glyph, CST_FWINALL );
  inherited Loaded;

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


unit u_buttons_appli;

{$I ..\Compilers.inc}
{$I ..\extends.inc}
{$IFDEF FPC}
{$mode Delphi}
{$ENDIF}

interface

uses
{$IFDEF FPC}
   lresources,
{$ELSE}
   Windows,
{$ENDIF}
  Classes,
{$IFDEF VERSIONS}
   fonctions_version,
{$ENDIF}
  JvXPButtons;

const
{$IFDEF VERSIONS}
    gVer_buttons_appli : T_Version = ( Component : 'Boutons personnalisés' ;
                                               FileUnit : 'u_buttons_appli' ;
                                               Owner : 'Matthieu Giroux' ;
                                               Comment : 'Composants boutons personnalisés.' ;
                                               BugsStory : '0.8.0.1 : Amilorate Group view buttons.'+ #13#10
                                                         + '0.8.0.0 : Gestion à tester.';
                                               UnitType : 3 ;
                                               Major : 0 ; Minor : 8 ; Release : 0 ; Build : 1 );
{$ENDIF}
   CST_FWCLOSE='TFWCLOSE';
   CST_FWCANCEL='TFWCANCEL';
   CST_FWBASKET='TFWBASKET';
   CST_FWOK='TFWOK';
   CST_FWINSERT='TFWINSERT';
   CST_FWDELETE='TFWDELETE';
   CST_FWCOPY='TFWCOPY';
   CST_FWQUIT='TFWQUIT';
   CST_FWERASE='TFWERASE';
   CST_FWSAVEAS='TFWSAVEAS';
   CST_FWPRINT='TFWPRINT';
   CST_FWDOCUMENT='TFWDOCUMENT';
   CST_FWPREVIEW='TFWPREVIEW';
   CST_FWINIT='TFWINIT';
{$IFDEF GROUPVIEW}
   CST_FWOUTSELECT='TFWOUTSELECT';
   CST_FWINSELECT='TFWINSELECT';
   CST_FWOUTALL='TFWOUTALL';
   CST_FWINALL='TFWINALL';
   CST_WIDTH_BUTTONS_MOVING  = 60;
   CST_HEIGHT_BUTTONS_MOVING = 40;
   CST_WIDTH_BUTTONS_ACTIONS  = 120;
   CST_HEIGHT_BUTTONS_ACTIONS = 20;
{$ENDIF}


type

   IFWButton = interface
       procedure Paint;
   end;
{ TFWClose }

   TFWClose = class ( TJvXPButton,IFWButton )
      private
      public
       constructor Create ( AOwner : TComponent ) ; override;
       procedure Loaded; override;
       procedure Click; override;
      published
       property Glyph stored False;
     End;

{ TFWCancel }

   { TFWAbort }

   TFWAbort = class ( TJvXPButton,IFWButton )
      private
      public
       constructor Create ( AOwner : TComponent ) ; override;
       procedure Loaded; override;
      published
       property Glyph stored False;
     End;

{ TFWOK }
   TFWOK = class ( TJvXPButton,IFWButton )
      private
      public
       constructor Create ( AOwner : TComponent ) ; override;
       procedure Loaded; override;
      published
       property Glyph stored False;
     End;

{ TFWInsert }
   TFWInsert = class ( TJvXPButton,IFWButton )
      private
      public
       constructor Create ( AOwner : TComponent ) ; override;
       procedure Loaded; override;
      published
       property Glyph stored False;
     End;

{ TFWDelete }
  TFWDelete = class ( TJvXPButton,IFWButton )
     private
     public
      constructor Create ( AOwner : TComponent ) ; override;
      procedure Loaded; override;
     published
      property Glyph stored False;
    End;

{ TFWDocument }
   TFWDocument = class ( TJvXPButton,IFWButton )
      private
      public
       procedure Loaded; override;
      published
       property Glyph stored False;
     End;

{ TFWQuit }
   TFWQuit = class ( TJvXPButton,IFWButton )
      private
      public
       constructor Create ( AOwner : TComponent ) ; override;
       procedure Loaded; override;
      published
       property Glyph stored False;
     End;

{ TFWErase }
   TFWErase = class ( TJvXPButton,IFWButton )
      private
      public
       constructor Create ( AOwner : TComponent ) ; override;
       procedure Loaded; override;
      published
       property Glyph stored False;
     End;

{ TFWSaveAs }
   TFWSaveAs = class ( TJvXPButton,IFWButton )
      private
      public
       constructor Create ( AOwner : TComponent ) ; override;
       procedure Loaded; override;

      published
       property Glyph stored False;
     End;

{ TFWPrint }
   TFWPrint = class ( TJvXPButton,IFWButton )
      private
      public
       constructor Create ( AOwner : TComponent ) ; override;
       procedure Loaded; override;

      published
       property Glyph stored False;
     End;

   TFWCancel = class ( TJvXPButton,IFWButton )
      private
      public
       constructor Create ( AOwner : TComponent ) ; override;
       procedure Loaded; override;

      published
       property Glyph stored False;
       property Caption stored False;
     End;


{ TFWPreview }
   TFWPreview = class ( TJvXPButton,IFWButton )
      private
      public
       procedure Loaded; override;

      published
       property Glyph stored False;
     End;

{ TFWCopy }
   TFWCopy = class ( TJvXPButton,IFWButton )
      private
      public
       constructor Create ( AOwner : TComponent ) ; override;
       procedure Loaded; override;
      published
       property Glyph stored False;
     End;

{ TFWInit }
   TFWInit = class ( TJvXPButton,IFWButton )
      private
      public
       procedure Loaded; override;

      published
       property Glyph stored False;
     End;

{$IFDEF GROUPVIEW}
{ TFWGroupButton }

    { TFWGroupButtonActions }

    TFWGroupButtonActions = class ( TJvXPButton,IFWButton )
     public
      constructor Create ( AOwner : TComponent ) ; override;
     published
      property Width  default CST_WIDTH_BUTTONS_ACTIONS;
      property Height default CST_HEIGHT_BUTTONS_ACTIONS;
    end;


   { TFWBasket }

   TFWBasket = class ( TFWGroupButtonActions )
      private
      public
       constructor Create ( AOwner : TComponent ) ; override;
       procedure Loaded; override;

      published
       property Glyph stored False;
       property Caption stored False;
     End;

   { TFWRecord }

   TFWRecord = class ( TFWGroupButtonActions )
      private
      public
       constructor Create ( AOwner : TComponent ) ; override;
       procedure Loaded; override;

      published
       property Glyph stored False;
       property Caption stored False;
     End;

   { TFWGroupButtonMoving }

   TFWGroupButtonMoving = class ( TJvXPButton,IFWButton )
   public
    constructor Create ( AOwner : TComponent ) ; override;
   published
    property Width  default CST_WIDTH_BUTTONS_MOVING;
    property Height default CST_HEIGHT_BUTTONS_MOVING;
   end;
   { TFWOutSelect }
    TFWOutSelect = class ( TFWGroupButtonMoving )
       private
       public
        procedure Loaded; override;
       published
        property Glyph stored False;
      End;

   { TFWOutAll }


   TFWOutAll = class ( TFWGroupButtonMoving )
      private
      public
       procedure Loaded; override;
      published
       property Glyph stored False;
     End;

{ TFWInSelect }
   TFWInSelect = class ( TFWGroupButtonMoving )
      private
      public
       procedure Loaded; override;
      published
       property Glyph stored False;
     End;

{ TFWInAll }
   TFWInAll = class ( TFWGroupButtonMoving )
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
     {$IFDEF GROUPVIEW}unite_messages,{$ENDIF}
     Forms, Graphics ;


{$IFNDEF FPC}
var Buttons_Appli_ResInstance             : THandle      ;
{$ENDIF}

procedure p_Load_Buttons_Appli ( const FGLyph : {$IFDEF USEJVCL}TJvPicture{$ELSE}TPicture{$ENDIF USEJVCL}; const as_Resource : String );
Begin
  {$IFDEF FPC}
    FGlyph.Clear;
    FGlyph.LoadFromLazarusResource( as_Resource );
  {$ELSE}
    if ( Buttons_Appli_ResInstance = 0 ) Then
      Buttons_Appli_ResInstance:= FindResourceHInstance(HInstance);
    FGlyph.Bitmap.LoadFromResourceName(Buttons_Appli_ResInstance, as_Resource );
  {$ENDIF}
end;
{ TFWDocument }

procedure TFWDocument.Loaded;
begin
  p_Load_Buttons_Appli ( Glyph, CST_FWDOCUMENT );
  inherited Loaded;
  Invalidate;
end;

{ TFWDelete }

constructor TFWDelete.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  {$IFDEF FPC}
  Caption := srVK_DELETE;
  {$ELSE}
  Caption := SDeleteRecord;
  {$ENDIF}
end;

procedure TFWDelete.Loaded;
begin
  p_Load_Buttons_Appli ( Glyph, CST_FWDELETE );
  inherited Loaded;
  Invalidate;
end;

{ TFWGroupButtonActions }

constructor TFWGroupButtonActions.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Width  := CST_WIDTH_BUTTONS_ACTIONS;
  Height := CST_HEIGHT_BUTTONS_ACTIONS;
end;

{ TFWGroupButtonMoving }

constructor TFWGroupButtonMoving.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Width  := CST_WIDTH_BUTTONS_MOVING;
  Height := CST_HEIGHT_BUTTONS_MOVING;
  Caption := '';
end;

{$IFDEF DELPHI}
  {$R *.dcr}
{$ENDIF}


{ TFWClose }


procedure TFWClose.Click;
begin
  if not assigned ( OnClick )
  and ( Owner is TCustomForm ) then
    ( Owner as TCustomForm ).Close;
  inherited;

end;

constructor TFWClose.Create(AOwner: TComponent);
begin
  inherited;
  Caption := SCloseButton;
end;

procedure TFWClose.Loaded;
begin
  p_Load_Buttons_Appli ( Glyph, CST_FWCLOSE );
  inherited Loaded;
  Invalidate;
end;

{ TFWCancel }

constructor TFWCancel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  {$IFDEF FPC}
  Caption := oiStdActDataSetCancel1Hint;
  {$ELSE}
  Caption := SMsgDlgCancel;
  {$ENDIF}
end;

procedure TFWCancel.Loaded;
begin
  p_Load_Buttons_Appli ( Glyph, CST_FWCANCEL );
  inherited Loaded;
  Invalidate;
end;


{ TFWOK }

constructor TFWOK.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  {$IFDEF FPC}
  Caption := oisOk2;
  {$ELSE}
  Caption := SMsgDlgOK;
  {$ENDIF}
end;

procedure TFWOK.Loaded;
begin
  p_Load_Buttons_Appli ( Glyph, CST_FWOK );
  inherited Loaded;
  Invalidate;
end;

{ TFWInsert }

constructor TFWInsert.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  {$IFDEF FPC}
  Caption := srVK_INSERT;
  {$ELSE}
  Caption := SInsertRecord;
  {$ENDIF}
end;

procedure TFWInsert.Loaded;
begin
  p_Load_Buttons_Appli ( Glyph, CST_FWINSERT );
  inherited Loaded;
  Invalidate;
end;

{ TFWSaveAs }

constructor TFWSaveAs.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  {$IFDEF FPC}
  caption := oiStdActFileSaveAsHint;
  {$ENDIF}
end;

procedure TFWSaveAs.Loaded;
begin
  p_Load_Buttons_Appli ( Glyph, CST_FWSAVEAS );
  inherited Loaded;
  Invalidate;
end;

{ TFWQuit }

constructor TFWQuit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Caption := SCloseButton {$IFDEF FPC}+ ' ' + oisAll{$ENDIF};
end;

procedure TFWQuit.Loaded;
begin
  p_Load_Buttons_Appli ( Glyph, CST_FWQUIT );
  inherited Loaded;
  Invalidate;
end;


{ TFWerase }

constructor TFWErase.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  {$IFDEF FPC}
  Caption := oisDelete;
  {$ELSE}
  Caption := SDeleteRecord;
  {$ENDIF}
end;

procedure TFWErase.Loaded;
begin
  p_Load_Buttons_Appli ( Glyph, CST_FWERASE );
  inherited Loaded;
  Invalidate;
end;

{ TFWPrint }

constructor TFWPrint.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  {$IFDEF FPC}
  Caption := srVK_PRINT;
  {$ENDIF}
end;

procedure TFWPrint.Loaded;
begin
  p_Load_Buttons_Appli ( Glyph, CST_FWPRINT );
  inherited Loaded;
  Invalidate;
end;

{ TFWPreview }

procedure TFWPreview.Loaded;
begin
  p_Load_Buttons_Appli ( Glyph, CST_FWPREVIEW );
  inherited Loaded;
  Invalidate;
end;

{ TFWInit }

procedure TFWInit.Loaded;
begin
  p_Load_Buttons_Appli ( Glyph, CST_FWINIT );
  inherited Loaded;
  Invalidate;
end;

{ TFWCopy }

constructor TFWCopy.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  {$IFDEF FPC}
  Caption := oiStdActEditCopyShortHint;
  {$ENDIF}
end;

procedure TFWCopy.Loaded;
begin
  p_Load_Buttons_Appli ( Glyph, CST_FWCOPY );
  inherited Loaded;
  Invalidate;
end;


{$IFDEF GROUPVIEW}

{ TFWOutSelect }

procedure TFWOutSelect.Loaded;
begin
  p_Load_Buttons_Appli ( Glyph, CST_FWOUTSELECT );
  inherited Loaded;
  Invalidate;
end;

{ TFWBasket }

constructor TFWBasket.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  {$IFDEF FPC}
  Caption := oisUndo;
  {$ELSE}
  Caption := Gs_GROUPVIEW_Basket;
  {$ENDIF}
end;

procedure TFWBasket.Loaded;
begin
  p_Load_Buttons_Appli ( Glyph, CST_FWBASKET );
  inherited Loaded;
  Invalidate;
end;

{ TFWRecord }

constructor TFWRecord.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  {$IFDEF FPC}
  Caption := oisRecord;
  {$ELSE}
  Caption := Gs_GROUPVIEW_Record;
  {$ENDIF}
end;

procedure TFWRecord.Loaded;
begin
  p_Load_Buttons_Appli ( Glyph, CST_FWOK );
  inherited Loaded;
  Invalidate;
end;

constructor TFWAbort.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  {$IFDEF FPC}
  Caption := oiStdActDataSetCancel1Hint;
  {$ELSE}
  Caption := SMsgDlgAbort;
  {$ENDIF}
end;

procedure TFWAbort.Loaded;
begin
  p_Load_Buttons_Appli ( Glyph, CST_FWCANCEL );
  inherited Loaded;
  Invalidate;
end;


{ TFWOutAll }

procedure TFWOutAll.Loaded;
begin
  p_Load_Buttons_Appli ( Glyph, CST_FWOUTALL );
  inherited Loaded;
  Invalidate;
end;

{ TFWInSelect }

procedure TFWInSelect.Loaded;
begin
  p_Load_Buttons_Appli ( Glyph, CST_FWINSELECT );
  inherited Loaded;
  Invalidate;
end;

{ TFWInAll }

procedure TFWInAll.Loaded;
begin
  p_Load_Buttons_Appli ( Glyph, CST_FWINALL );
  inherited Loaded;
  Invalidate;
end;

{$ENDIF}

initialization
{$IFDEF VERSIONS}
  p_ConcatVersion ( gVer_buttons_appli  );
{$ENDIF}
{$IFDEF FPC}
  {$I u_buttons_appli.lrs}
{$ENDIF}

end.


unit u_buttons_blue;

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
  Graphics, u_comp_TBlueFlatSpeedButton;

{$IFDEF VERSIONS}
const
    gVer_buttons_blue : T_Version = ( Component : 'Blue Buttons extension' ;
                                       FileUnit : 'u_buttons_blue' ;
                                       Owner : 'Matthieu Giroux' ;
                                       Comment : 'Composants boutons étendus.' ;
                                       BugsStory : '0.8.0.0 : Not tested.';
                                       UnitType : 3 ;
                                       Major : 0 ; Minor : 8 ; Release : 0 ; Build : 0 );
{$ENDIF}

type

    { TBFSSpeedButton }

    TBFSSpeedButton = class ( TBlueFlatSpeedButton, IFWButton )
      public
       constructor Create(AOwner: TComponent); override;
      published
       property Glyph stored False;
     End;

    TBFSClose = class ( TBFSSpeedButton,IFWButton )
      private
      public
       constructor Create ( AOwner : TComponent ) ; override;
       procedure Loaded; override;
       procedure Click; override;
      published
       property Width default CST_FWWIDTH_CLOSE_BUTTON ;
     End;

{ TBFSOK }
   TBFSOK = class ( TBFSSpeedButton,IFWButton )
      public
       constructor Create ( AOwner : TComponent ) ; override;
       procedure Loaded; override;
     End;

{ TBFSInsert }
   TBFSInsert = class ( TBFSSpeedButton,IFWButton )
      public
       constructor Create ( AOwner : TComponent ) ; override;
     End;
{ TBFSAdd }
   TBFSAdd = class ( TBFSSpeedButton,IFWButton )
      public
       constructor Create ( AOwner : TComponent ) ; override;
     End;

{ TBFSDelete }
  TBFSDelete = class ( TBFSSpeedButton,IFWButton )
     public
      constructor Create ( AOwner : TComponent ) ; override;
    End;

{ TBFSDocument }
   TBFSDocument = class ( TBFSSpeedButton,IFWButton )
      public
       procedure Loaded; override;
     End;

{ TBFSQuit }
   TBFSQuit = class ( TBFSSpeedButton,IFWButton )
      public
       constructor Create ( AOwner : TComponent ) ; override;
     End;

{ TBFSErase }
   TBFSErase = class ( TBFSSpeedButton,IFWButton )
      public
       constructor Create ( AOwner : TComponent ) ; override;
     End;

{ TBFSSaveAs }
   TBFSSaveAs = class ( TBFSSpeedButton,IFWButton )
      public
       constructor Create ( AOwner : TComponent ) ; override;
     End;

   { TBFSLoad }
      TBFSLoad = class ( TBFSSpeedButton,IFWButton )
         private
         public
          constructor Create ( AOwner : TComponent ) ; override;
        End;

{ TBFSPrint }
   TBFSPrint = class ( TBFSSpeedButton,IFWButton )
      public
       constructor Create ( AOwner : TComponent ) ; override;
     End;

{ TBFSCancel }
   TBFSCancel = class ( TBFSSpeedButton,IFWButton )
      public
       constructor Create ( AOwner : TComponent ) ; override;
      published
       property Caption stored False;
     End;


{ TBFSPreview }
   TBFSPreview = class ( TBFSSpeedButton,IFWButton )
      public
       procedure Loaded; override;
     End;

{ TBFSNext }
   TBFSNext = class ( TBFSSpeedButton,IFWButton )
      public
       procedure Loaded; override;
     End;

{ TBFSPrior }
   TBFSPrior= class ( TBFSSpeedButton,IFWButton )
      public
       procedure Loaded; override;
     End;

{ TBFSCopy }
   TBFSCopy = class ( TBFSSpeedButton,IFWButton )
      private
      public
       constructor Create ( AOwner : TComponent ) ; override;
     End;

{ TBFSInit }
   TBFSInit = class ( TBFSSpeedButton,IFWButton )
      public
       procedure Loaded; override;
     End;

{ TBFSConfig }
   TBFSConfig = class ( TBFSSpeedButton,IFWButton )
      public
       procedure Loaded; override;
     End;

{ TBFSImport }
   TBFSImport = class ( TBFSSpeedButton,IFWButton )
      public
       procedure Loaded; override;
     End;
{ TBFSTrash }
   TBFSTrash = class ( TBFSSpeedButton,IFWButton )
      public
       procedure Loaded; override;
     End;

{ TBFSExport }
   TBFSExport = class ( TBFSSpeedButton,IFWButton )
      public
       procedure Loaded; override;
     End;

{$IFDEF GROUPVIEW}

{ TBFSGroupButton }

    { TBFSGroupButtonActions }

    TBFSGroupButtonActions = class ( TBFSSpeedButton,IFWButton )
     public
      constructor Create ( AOwner : TComponent ) ; override;
     published
      property Width  default CST_WIDTH_BUTTONS_ACTIONS;
      property Height default CST_HEIGHT_BUTTONS_ACTIONS;
    end;


   { TBFSBasket }

   TBFSBasket = class ( TBFSGroupButtonActions )
      public
       constructor Create ( AOwner : TComponent ) ; override;
      published
       property Caption stored False;
     End;

   { TBFSRecord }

   TBFSRecord = class ( TBFSGroupButtonActions )
      public
       constructor Create ( AOwner : TComponent ) ; override;
      published
       property Caption stored False;
     End;

   { TBFSGroupButtonMoving }

   TBFSGroupButtonMoving = class ( TBFSSpeedButton,IFWButton )
   public
    constructor Create ( AOwner : TComponent ) ; override;
   published
    property Width  default CST_WIDTH_BUTTONS_MOVING;
    property Height default CST_HEIGHT_BUTTONS_MOVING;
   end;
   { TBFSOutSelect }
    TBFSOutSelect = class ( TBFSGroupButtonMoving )
       public
        procedure Loaded; override;
      End;

   { TBFSOutAll }


   TBFSOutAll = class ( TBFSGroupButtonMoving )
      public
       procedure Loaded; override;
     End;

{ TBFSInSelect }
   TBFSInSelect = class ( TBFSGroupButtonMoving )
      public
       procedure Loaded; override;
     End;

{ TBFSInAll }
   TBFSInAll = class ( TBFSGroupButtonMoving )
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

{ TBFSSpeedButton }

constructor TBFSSpeedButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Glyph.Clear;
end;

{ TBFSTrash }

procedure TBFSTrash.Loaded;
begin
  p_Load_Buttons_Appli ( Glyph, CST_FWTRASH );
  inherited Loaded;

end;

{ TBFSLoad }

constructor TBFSLoad.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  {$IFDEF FPC}
  caption := oiStdActFileOpenHint;
  {$ENDIF}
  p_Load_Buttons_Appli ( Glyph, CST_FWLOAD );
end;

{ TBFSDocument }

procedure TBFSDocument.Loaded;
begin
  p_Load_Buttons_Appli ( Glyph, CST_FWDOCUMENT );
  inherited Loaded;

end;

{ TBFSDelete }

constructor TBFSDelete.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  {$IFDEF FPC}
  Caption := srVK_DELETE;
  {$ELSE}
//  Caption := SDeleteRecord;
  {$ENDIF}
  p_Load_Buttons_Appli ( Glyph, CST_FWDELETE );
end;

{ TBFSClose }


procedure TBFSClose.Click;
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

constructor TBFSClose.Create(AOwner: TComponent);
begin
  inherited;
  Caption := SCloseButton;
  Width := CST_FWWIDTH_CLOSE_BUTTON;
end;

procedure TBFSClose.Loaded;
begin
  p_Load_Buttons_Appli ( Glyph, CST_FWCLOSE );
  inherited Loaded;

end;

{ TBFSCancel }

constructor TBFSCancel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  {$IFDEF FPC}
  Caption := oiStdActDataSetCancel1Hint;
  {$ELSE}
  Caption := SMsgDlgCancel;
  {$ENDIF}
  p_Load_Buttons_Appli ( Glyph, CST_FWCANCEL );
end;

{ TBFSOK }

constructor TBFSOK.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  {$IFDEF FPC}
  Caption := oisOk2;
  {$ELSE}
  Caption := SMsgDlgOK;
  {$ENDIF}
end;

procedure TBFSOK.Loaded;
begin
  p_Load_Buttons_Appli ( Glyph, CST_FWOK );
  inherited Loaded;

end;

{ TBFSInsert }

constructor TBFSInsert.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  {$IFDEF FPC}
  Caption := srVK_INSERT;
  {$ELSE}
  Caption := SInsertRecord;
  {$ENDIF}
  p_Load_Buttons_Appli ( Glyph, CST_FWINSERT );
end;

{ TBFSAdd }

constructor TBFSAdd.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  p_Load_Buttons_Appli ( Glyph, CST_FWINSERT );
end;

{ TBFSSaveAs }

constructor TBFSSaveAs.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  {$IFDEF FPC}
  caption := oiStdActFileSaveAsHint;
  {$ENDIF}
  p_Load_Buttons_Appli ( Glyph, CST_FWSAVEAS );
end;

{ TBFSQuit }

constructor TBFSQuit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Caption := SCloseButton {$IFDEF FPC}+ ' ' + oisAll{$ENDIF};
  p_Load_Buttons_Appli ( Glyph, CST_FWQUIT );
end;

{ TBFSerase }

constructor TBFSErase.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  {$IFDEF FPC}
  Caption := oisDelete;
  {$ELSE}
  //Caption := SDeleteRecord;
  {$ENDIF}
  p_Load_Buttons_Appli ( Glyph, CST_FWERASE );
end;

{ TBFSPrint }

constructor TBFSPrint.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  {$IFDEF FPC}
  Caption := srVK_PRINT;
  {$ENDIF}
  p_Load_Buttons_Appli ( Glyph, CST_FWPRINT );
end;

{ TBFSNext }

procedure TBFSNext.Loaded;
begin
  p_Load_Buttons_Appli ( Glyph, CST_FWNEXT );
  inherited Loaded;

end;
{ TBFSPrior }

procedure TBFSPrior.Loaded;
begin
  p_Load_Buttons_Appli ( Glyph, CST_FWPRIOR );
  inherited Loaded;

end;

{ TBFSPreview }

procedure TBFSPreview.Loaded;
begin
  p_Load_Buttons_Appli ( Glyph, CST_FWPREVIEW );
  inherited Loaded;

end;

{ TBFSInit }

procedure TBFSInit.Loaded;
begin
  p_Load_Buttons_Appli ( Glyph, CST_FWINIT );
  inherited Loaded;

end;

{ TBFSConfig }

procedure TBFSConfig.Loaded;
begin
  p_Load_Buttons_Appli ( Glyph, CST_FWCONFIG );
  inherited Loaded;

end;

{ TBFSImport }

procedure TBFSImport.Loaded;
begin
  p_Load_Buttons_Appli ( Glyph, CST_FWIMPORT );
  inherited Loaded;

end;

{ TBFSExport }

procedure TBFSExport.Loaded;
begin
  p_Load_Buttons_Appli ( Glyph, CST_FWEXPORT );
  inherited Loaded;

end;

{ TBFSCopy }

constructor TBFSCopy.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  {$IFDEF FPC}
  Caption := oiStdActEditCopyShortHint;
  {$ENDIF}
  p_Load_Buttons_Appli ( Glyph, CST_FWCOPY );
end;

{$IFDEF GROUPVIEW}

{ TBFSOutSelect }

procedure TBFSOutSelect.Loaded;
begin
  p_Load_Buttons_Appli ( Glyph, CST_FWOUTSELECT );
  inherited Loaded;

end;

{ TBFSBasket }

constructor TBFSBasket.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  {$IFDEF FPC}
  Caption := oisUndo;
  {$ELSE}
  Caption := Gs_GROUPVIEW_Basket;
  {$ENDIF}
  p_Load_Buttons_Appli ( Glyph, CST_FWBASKET );
end;

{ TBFSRecord }

constructor TBFSRecord.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  {$IFDEF FPC}
  Caption := oisRecord;
  {$ELSE}
  Caption := Gs_GROUPVIEW_Record;
  {$ENDIF}
  p_Load_Buttons_Appli ( Glyph, CST_FWOK );
end;

{ TBFSOutAll }

procedure TBFSOutAll.Loaded;
begin
  p_Load_Buttons_Appli ( Glyph, CST_FWOUTALL );
  inherited Loaded;

end;

{ TBFSInSelect }

procedure TBFSInSelect.Loaded;
begin
  p_Load_Buttons_Appli ( Glyph, CST_FWINSELECT );
  inherited Loaded;

end;

{ TBFSInAll }

procedure TBFSInAll.Loaded;
begin
  p_Load_Buttons_Appli ( Glyph, CST_FWINALL );
  inherited Loaded;

end;



{ TBFSGroupButtonActions }

constructor TBFSGroupButtonActions.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Width  := CST_WIDTH_BUTTONS_ACTIONS;
  Height := CST_HEIGHT_BUTTONS_ACTIONS;
end;

{ TBFSGroupButtonMoving }

constructor TBFSGroupButtonMoving.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Width  := CST_WIDTH_BUTTONS_MOVING;
  Height := CST_HEIGHT_BUTTONS_MOVING;
  Caption := '';
end;

{$ENDIF}


initialization
{$IFDEF VERSIONS}
  p_ConcatVersion ( gVer_buttons_blue  );
{$ENDIF}

end.


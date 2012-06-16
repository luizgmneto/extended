unit u_buttons_appli;

{$I ..\DLCompilers.inc}
{$I ..\extends.inc}
{$IFDEF FPC}
{$mode Delphi}
{$ELSE}
{$R *.DCR}
{$ENDIF}

interface

uses
{$IFDEF FPC}
   lresources,
{$ELSE}
   Windows, Messages,
{$ENDIF}
  Classes,
{$IFDEF VERSIONS}
   fonctions_version,
{$ENDIF}
  Controls,
  JvXPButtons, Graphics,
  Menus;

const
{$IFDEF VERSIONS}
    gVer_buttons_appli : T_Version = ( Component : 'Customized Buttons' ;
                                       FileUnit : 'u_buttons_appli' ;
                                       Owner : 'Matthieu Giroux' ;
                                       Comment : 'Customized Buttons components.' ;
                                       BugsStory : '1.0.0.2 : Date and Folder Buttons.'+ #13#10
                                                 + '1.0.0.1 : UTF 8.'+ #13#10
                                                 + '1.0.0.0 : Version OK.'+ #13#10
                                                 + '0.8.0.1 : Group view buttons better.'+ #13#10
                                                 + '0.8.0.0 : To test.';
                                       UnitType : 3 ;
                                       Major : 1 ; Minor : 0 ; Release : 0 ; Build : 2 );
{$ENDIF}
   CST_FWBASKET='TFWBASKET';
   CST_FWCANCEL='TFWCANCEL';
   CST_FWCLOSE='TFWCLOSE';
   CST_FWDATE='TFWDATE';
   CST_FWFOLDER='TFWFOLDER';
   CST_FWOK='TFWOK';
   CST_FWINSERT='TFWINSERT';
   CST_FWDELETE='TFWDELETE';
   CST_FWIMPORT='TFWIMPORT';
   CST_FWEXPORT='TFWEXPORT';
   CST_FWCOPY='TFWCOPY';
   CST_FWQUIT='TFWQUIT';
   CST_FWERASE='TFWERASE';
   CST_FWSAVEAS='TFWSAVEAS';
   CST_FWPRINT='TFWPRINT';
   CST_FWDOCUMENT='TFWDOCUMENT';
   CST_FWPREVIEW='TFWPREVIEW';
   CST_FWNEXT='TFWNEXT';
   CST_FWREFRESH='TFWREFRESH';
   CST_FWPRIOR='TFWPRIOR';
   CST_FWINIT='TFWINIT';
   CST_FWCONFIG='TFWCONFIG';
   CST_FWWIDTH_CLOSE_BUTTON = 80 ;
   CST_FWLOAD='TFWLOAD';
   CST_FWSEARCH='TFWSEARCH';
   CST_FWZOOMIN='TFWZOOMIN';
   CST_FWZOOMOUT='TFWZOOMOUT';
   CST_FWTRASH='TFWTRASH';
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

procedure p_Load_Buttons_Appli ( const FGLyph : {$IFDEF USEJVCL}TJvPicture{$ELSE}TPicture{$ENDIF USEJVCL}; const as_Resource : String ; const acon_control :TControl);

type

   IFWButton = interface
   ['{620AE27F-98C1-8A6D-E54F-FE57A16207E5}']
       procedure Paint;
   end;

    { TFWXPButton }

    TFWXPButton = class ( TJvXPButton, IFWButton )
      private
       FColor           ,
       FColorFrameFocus : TColor;
       FDropDownMenu : TPopupMenu;
      protected
       procedure AdaptGlyph (const ASize : Integer ); virtual;
       procedure MouseEnter{$IFNDEF FPC}(Acontrol : TControl ){$ENDIF}; override;
       procedure MouseLeave{$IFNDEF FPC}(Acontrol : TControl ){$ENDIF}; override;
       procedure Click; override;
     public
      constructor Create ( AOwner : TComponent ) ; override;

      published
       property ColorFrameFocus : TColor read FColorFrameFocus write FColorFrameFocus default clCream;
       property DropDownMenu : TPopupMenu read FDropDownMenu write FDropDownMenu;
     End;
    { TFWButton }

    TFWButton = class ( TFWXPButton, IFWButton )
      public
       constructor Create ( AOwner : TComponent ) ; override;
       property Glyph stored False;
      published
       property Height default 25;
       property Width default 25;
     End;

    { TFWMiniButton }

    TFWMiniButton = class ( TFWXPButton, IFWButton )
      public
       constructor Create ( AOwner : TComponent ) ; override;
       property Glyph stored False;
      published
       property Height default 17;
       property Width default 17;
     End;


   { TFWClose }

  TFWClose = class ( TFWButton )
     public
      constructor Create ( AOwner : TComponent ) ; override;
      procedure Loaded; override;
      procedure Click; override;
     published

      property Width default CST_FWWIDTH_CLOSE_BUTTON ;
    End;

{ TFWOK }
   TFWOK = class ( TFWButton )
      public
       constructor Create ( AOwner : TComponent ) ; override;
       procedure Loaded; override;
      published
       
     End;

{ TFWInsert }
   TFWInsert = class ( TFWButton )
      public
       constructor Create ( AOwner : TComponent ) ; override;
       procedure Loaded; override;
      published
       
     End;
   { TFWAdd }
   TFWAdd = class ( TFWButton )
      public
       procedure Loaded; override;
     End;
   { TFWMAdd }
   TFWMAdd = class ( TFWMiniButton )
      public
       procedure Loaded; override;
     End;


 { TFWDelete }
   TFWDelete = class ( TFWButton )
      public
       procedure Loaded; override;
     End;
 { TFWMDelete }
   TFWMDelete = class ( TFWMiniButton )
      public
       procedure Loaded; override;
     End;
  { TFWDocument }
   TFWDocument = class ( TFWButton )
      public
       procedure Loaded; override;
     End;

   { TFWFolder }
    TFWFolder = class ( TFWButton )
       public
        procedure Loaded; override;
      End;

  { TFWMFolder }
   TFWMFolder = class ( TFWMiniButton )
      public
       procedure Loaded; override;
     End;


   { TFWDate }
    TFWDate = class ( TFWButton )
       public
        procedure Loaded; override;
      End;
  { TFWMDate }
   TFWMDate = class ( TFWMiniButton )
      public
       procedure Loaded; override;
     End;

{ TFWQuit }
   TFWQuit = class ( TFWMiniButton )
      public
       constructor Create ( AOwner : TComponent ) ; override;
       procedure Loaded; override;
     End;

{ TFWErase }
   TFWErase = class ( TFWButton )
      public
       constructor Create ( AOwner : TComponent ) ; override;
       procedure Loaded; override;
     End;

{ TFWSaveAs }
   TFWSaveAs = class ( TFWButton )
      public
       constructor Create ( AOwner : TComponent ) ; override;
       procedure Loaded; override;
     End;

   { TFWLoad }
      TFWLoad = class ( TFWMiniButton )
         public
          constructor Create ( AOwner : TComponent ) ; override;
          procedure Loaded; override;
        End;

{ TFWPrint }
   TFWPrint = class ( TFWMiniButton )
      public
       constructor Create ( AOwner : TComponent ) ; override;
       procedure Loaded; override;

      published
       
     End;

{ TFWCancel }
   TFWCancel = class ( TFWButton )
      public
       constructor Create ( AOwner : TComponent ) ; override;
       procedure Loaded; override;
     End;


{ TFWPreview }
   TFWPreview = class ( TFWMiniButton )
      public
       procedure Loaded; override;
     End;

{ TFWNext }
   TFWNext = class ( TFWButton )
      public
       procedure Loaded; override;
     End;

   { TFWPrior }
      TFWPrior= class ( TFWButton )
         public
          procedure Loaded; override;
        End;
{ TFWPrior }
   TFWRefresh= class ( TFWButton )
      public
       procedure Loaded; override;
     End;

{ TFWCopy }
   TFWCopy = class ( TFWMiniButton )
      public
       constructor Create ( AOwner : TComponent ) ; override;
       procedure Loaded; override;
     End;

   { TFWInit }
   TFWInit = class ( TFWButton )
      public
       procedure Loaded; override;
     End;

   { TFWConfig }
   TFWConfig = class ( TFWButton )
      public
       procedure Loaded; override;
     End;

   { TFWImport }
   TFWImport = class ( TFWButton )
      public
       procedure Loaded; override;
     End;
   { TFWTrash }
   TFWTrash = class ( TFWButton )
      public
       procedure Loaded; override;
     End;

  { TFWExport }
  TFWExport = class ( TFWButton )
     public
      procedure Loaded; override;
    End;
  { TFWSearch }
   TFWSearch = class ( TFWButton )
      public
       procedure Loaded; override;
     End;
  { TFWMSearch }
   TFWMSearch = class ( TFWMiniButton )
      public
       procedure Loaded; override;
     End;


  { TFWZoomIn }
   TFWZoomIn = class ( TFWButton )
      public
       procedure Loaded; override;
     End;
  { TFWMZoomIn }
  TFWMZoomIn = class ( TFWMiniButton )
     public
      procedure Loaded; override;
    End;
  { TFWZoomOut }
   TFWZoomOut = class ( TFWButton )
      public
       procedure Loaded; override;
     End;
   { TFWMZoomOut }
  TFWMZoomOut = class ( TFWMiniButton )
     public
      procedure Loaded; override;
    End;

{$IFDEF GROUPVIEW}

{ TFWGroupButton }

    { TFWGroupButtonActions }

    TFWGroupButtonActions = class ( TFWButton )
     public
      constructor Create ( AOwner : TComponent ) ; override;
     published
      property Width  default CST_WIDTH_BUTTONS_ACTIONS;
      property Height default CST_HEIGHT_BUTTONS_ACTIONS;
    end;


   { TFWBasket }

   TFWBasket = class ( TFWGroupButtonActions )
      public
       constructor Create ( AOwner : TComponent ) ; override;
       procedure Loaded; override;

      published
       
       property Caption stored False;
     End;

   { TFWRecord }

   TFWRecord = class ( TFWGroupButtonActions )
      public
       constructor Create ( AOwner : TComponent ) ; override;
       procedure Loaded; override;

      published
       
       property Caption stored False;
     End;

   { TFWGroupButtonMoving }

   TFWGroupButtonMoving = class ( TFWButton )
   public
    constructor Create ( AOwner : TComponent ) ; override;
   published
    property Width  default CST_WIDTH_BUTTONS_MOVING;
    property Height default CST_HEIGHT_BUTTONS_MOVING;
   end;
   { TFWOutSelect }
    TFWOutSelect = class ( TFWGroupButtonMoving )
       public
        procedure Loaded; override;
       published
        
      End;

   { TFWOutAll }


   TFWOutAll = class ( TFWGroupButtonMoving )
      public
       procedure Loaded; override;
      published
       
     End;

{ TFWInSelect }
   TFWInSelect = class ( TFWGroupButtonMoving )
      public
       procedure Loaded; override;
      published
       
     End;

{ TFWInAll }
   TFWInAll = class ( TFWGroupButtonMoving )
      public
       procedure Loaded; override;
      published

     End;

{$ENDIF}

implementation

uses {$IFDEF FPC}ObjInspStrConsts,lclstrconsts,
     {$ELSE}Consts, VDBConsts, {$ENDIF}
     unite_messages, fonctions_images,
     Forms ;


{$IFNDEF FPC}
var Buttons_Appli_ResInstance             : THandle      = 0 ;
{$ENDIF}


procedure p_Load_Buttons_Appli ( const FGLyph : {$IFDEF USEJVCL}TJvPicture{$ELSE}TPicture{$ENDIF USEJVCL}; const as_Resource : String ; const acon_control :TControl);
var
  Stream: TLazarusResourceStream;
begin
  with FGLyph do
   Begin
  {$IFDEF FPC}
    Clear;
    Stream := TLazarusResourceStream.Create(as_Resource, nil);
    try
      if Bitmap.IsFileExtensionSupported(Stream.Res.ValueType) Then
        Begin
         Bitmap.LoadFromStream(Stream);
        end
      else if Pixmap.IsFileExtensionSupported(Stream.Res.ValueType) Then
       Pixmap.LoadFromStream(Stream)
    finally
      Stream.Free;
    end;
    LoadFromLazarusResource(as_Resource);
  {$ELSE}
    if ( Buttons_Appli_ResInstance = 0 ) Then
      Buttons_Appli_ResInstance:= FindResourceHInstance(HInstance);
    Bitmap.LoadFromResourceName(Buttons_Appli_ResInstance, as_Resource );
  {$ENDIF}
    End;
  acon_control.Invalidate;
end;

{ TFWMSearch }

procedure TFWMSearch.Loaded;
begin
  p_Load_Buttons_Appli ( Glyph, CST_FWSEARCH, Self );
  AdaptGlyph(16);
  inherited Loaded;
end;

{ TFWSearch }

procedure TFWSearch.Loaded;
begin
  p_Load_Buttons_Appli ( Glyph, CST_FWSEARCH, Self );
  inherited Loaded;
end;

{ TFWMZoomOut }

procedure TFWMZoomOut.Loaded;
begin
  p_Load_Buttons_Appli ( Glyph, CST_FWZOOMOUT, Self );
  AdaptGlyph(16);
  inherited Loaded;
end;

{ TFWZoomOut }

procedure TFWZoomOut.Loaded;
begin
  p_Load_Buttons_Appli ( Glyph, CST_FWZOOMOUT, Self );
  inherited Loaded;
end;

{ TFWMZoomIn }

procedure TFWMZoomIn.Loaded;
begin
  p_Load_Buttons_Appli ( Glyph, CST_FWZOOMIN, Self );
  AdaptGlyph(16);
  inherited Loaded;
end;

{ TFWZoomIn }

procedure TFWZoomIn.Loaded;
begin
  p_Load_Buttons_Appli ( Glyph, CST_FWZOOMIN, Self );
  inherited Loaded;
end;

{ TFWFolder }

procedure TFWFolder.Loaded;
begin
  p_Load_Buttons_Appli ( Glyph, CST_FWFOLDER, Self );
  inherited Loaded;
end;

{ TFWMFolder }

procedure TFWMFolder.Loaded;
begin
  p_Load_Buttons_Appli ( Glyph, CST_FWFOLDER, Self );
  AdaptGlyph(16);
  inherited Loaded;
end;

{ TFWMiniButton }

constructor TFWMiniButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Height:=17;
  Width :=17;
end;

{ TFWButton }

constructor TFWButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Height:=25;
  Width :=25;
end;


{ TFWXPButton }

procedure TFWXPButton.AdaptGlyph(const ASize: Integer);
begin
  with Glyph.Bitmap do
  if not Empty
  and (( ASize < Height ) or ( ASize < Width )) Then
    Begin
      p_ChangeTailleBitmap(Glyph.Bitmap,ASize,Asize,True);
      Modified:=True;
//      TransparentMode:=tmAuto;
//      Transparent:=True;
    end;
  Invalidate;
end;

procedure TFWXPButton.MouseEnter;
begin
  FColor:=Color;
  Color := FColorFrameFocus;
{$IFDEF FPC}
  inherited;
{$ENDIF}
end;

procedure TFWXPButton.MouseLeave;
begin
  Color := FColor;
{$IFDEF FPC}
  inherited;
{$ENDIF}
end;

procedure TFWXPButton.Click;
begin
  if Assigned(FDropDownMenu) Then
  with Mouse.CursorPos do
    Begin
     FDropDownMenu.Popup(X, Y);
    end;
  inherited Click;
end;

constructor TFWXPButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FColorFrameFocus:=clCream;
end;


{ TFWTrash }

procedure TFWTrash.Loaded;
begin
  p_Load_Buttons_Appli ( Glyph, CST_FWTRASH, Self );
  inherited Loaded;
end;


{ TFWDate }

procedure TFWDate.Loaded;
begin
  p_Load_Buttons_Appli ( Glyph, CST_FWDATE, Self );
  inherited Loaded;
end;

{ TFWMDate }

procedure TFWMDate.Loaded;
begin
  p_Load_Buttons_Appli ( Glyph, CST_FWDATE, Self );
  p_ChangeTailleBitmap ( Glyph.Bitmap,16,16,True);
  inherited Loaded;
end;

{ TFWLoad }

constructor TFWLoad.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  {$IFDEF FPC}
  caption := oiStdActFileOpenHint;
  {$ENDIF}
end;

procedure TFWLoad.Loaded;
begin
  p_Load_Buttons_Appli ( Glyph, CST_FWLOAD, Self );
  inherited Loaded;
end;

{ TFWDocument }

procedure TFWDocument.Loaded;
begin
  p_Load_Buttons_Appli ( Glyph, CST_FWDOCUMENT, Self );
  inherited Loaded;
end;

{ TFWDelete }

procedure TFWDelete.Loaded;
begin
  p_Load_Buttons_Appli ( Glyph, CST_FWDELETE, Self );
  inherited Loaded;
end;

{ TFWMDelete }

procedure TFWMDelete.Loaded;
begin
  p_Load_Buttons_Appli ( Glyph, CST_FWDELETE, Self );
  p_ChangeTailleBitmap ( Glyph.Bitmap,16,16,True);
  inherited Loaded;
end;

{ TFWClose }


procedure TFWClose.Click;
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

constructor TFWClose.Create(AOwner: TComponent);
begin
  inherited;
  Caption := SCloseButton;
  Width := CST_FWWIDTH_CLOSE_BUTTON;
end;

procedure TFWClose.Loaded;
begin
  p_Load_Buttons_Appli ( Glyph, CST_FWCLOSE, Self );
  inherited Loaded;
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
  p_Load_Buttons_Appli ( Glyph, CST_FWCANCEL, Self );
  inherited Loaded;
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
  p_Load_Buttons_Appli ( Glyph, CST_FWOK, Self );
  inherited Loaded;
end;

{ TFWInsert }

constructor TFWInsert.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  {$IFDEF FPC}
  Caption := ifsVK_INSERT;
  {$ELSE}
  Caption := SInsertRecord;
  {$ENDIF}
end;

procedure TFWInsert.Loaded;
begin
  p_Load_Buttons_Appli ( Glyph, CST_FWINSERT, Self );
  inherited Loaded;
end;
{ TFWAdd }
procedure TFWAdd.Loaded;
begin
  p_Load_Buttons_Appli ( Glyph, CST_FWINSERT, Self );
  inherited Loaded;
end;
{ TFWMAdd }
procedure TFWMAdd.Loaded;
begin
  p_Load_Buttons_Appli ( Glyph, CST_FWINSERT, Self );
  p_ChangeTailleBitmap ( Glyph.Bitmap,16,16,True);
  inherited Loaded;
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
  p_Load_Buttons_Appli ( Glyph, CST_FWSAVEAS, Self );
  inherited Loaded;
end;

{ TFWQuit }

constructor TFWQuit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Caption := SCloseButton {$IFDEF FPC}+ ' ' + oisAll{$ENDIF};
end;

procedure TFWQuit.Loaded;
begin
  p_Load_Buttons_Appli ( Glyph, CST_FWQUIT, Self );
  inherited Loaded;
end;


{ TFWerase }

constructor TFWErase.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  {$IFDEF FPC}
  Caption := oisDelete;
  {$ELSE}
  //Caption := SDeleteRecord;
  {$ENDIF}
end;

procedure TFWErase.Loaded;
begin
  p_Load_Buttons_Appli ( Glyph, CST_FWERASE, Self );
  inherited Loaded;
end;

{ TFWPrint }

constructor TFWPrint.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  {$IFDEF FPC}
  Caption := ifsVK_PRINT;
  {$ENDIF}
end;

procedure TFWPrint.Loaded;
begin
  p_Load_Buttons_Appli ( Glyph, CST_FWPRINT, Self );
  inherited Loaded;
end;

{ TFWNext }

procedure TFWNext.Loaded;
begin
  p_Load_Buttons_Appli ( Glyph, CST_FWNEXT, Self );
  inherited Loaded;
end;
{ TFWPrior }

procedure TFWPrior.Loaded;
begin
  p_Load_Buttons_Appli ( Glyph, CST_FWPRIOR, Self );
  inherited Loaded;
end;

{ TFWRefresh }

procedure TFWRefresh.Loaded;
begin
  p_Load_Buttons_Appli ( Glyph, CST_FWREFRESH, Self );
  inherited Loaded;
end;

{ TFWPreview }

procedure TFWPreview.Loaded;
begin
  p_Load_Buttons_Appli ( Glyph, CST_FWPREVIEW, Self );
  inherited Loaded;
end;

{ TFWInit }

procedure TFWInit.Loaded;
begin
  p_Load_Buttons_Appli ( Glyph, CST_FWINIT, Self );
  inherited Loaded;
end;

{ TFWConfig }

procedure TFWConfig.Loaded;
begin
  p_Load_Buttons_Appli ( Glyph, CST_FWCONFIG, Self );
  inherited Loaded;
end;

{ TFWImport }

procedure TFWImport.Loaded;
begin
  p_Load_Buttons_Appli ( Glyph, CST_FWIMPORT, Self );
  inherited Loaded;
end;

{ TFWExport }

procedure TFWExport.Loaded;
begin
  p_Load_Buttons_Appli ( Glyph, CST_FWEXPORT, Self );
  inherited Loaded;
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
  p_Load_Buttons_Appli ( Glyph, CST_FWCOPY, Self );
  inherited Loaded;
end;


{$IFDEF GROUPVIEW}

{ TFWOutSelect }

procedure TFWOutSelect.Loaded;
begin
  p_Load_Buttons_Appli ( Glyph, CST_FWOUTSELECT, Self );
  inherited Loaded;
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
  p_Load_Buttons_Appli ( Glyph, CST_FWBASKET, Self );
  inherited Loaded;
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
  p_Load_Buttons_Appli ( Glyph, CST_FWOK, Self );
  inherited Loaded;
end;


{ TFWOutAll }

procedure TFWOutAll.Loaded;
begin
  p_Load_Buttons_Appli ( Glyph, CST_FWOUTALL, Self );
  inherited Loaded;
end;

{ TFWInSelect }

procedure TFWInSelect.Loaded;
begin
  p_Load_Buttons_Appli ( Glyph, CST_FWINSELECT, Self );
  inherited Loaded;
end;

{ TFWInAll }

procedure TFWInAll.Loaded;
begin
  p_Load_Buttons_Appli ( Glyph, CST_FWINALL, Self );
  inherited Loaded;
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


{$ENDIF}



initialization
{$IFDEF VERSIONS}
  p_ConcatVersion ( gVer_buttons_appli  );
{$ENDIF}
{$IFDEF FPC}
  {$I u_buttons_appli.lrs}
{$ENDIF}

end.


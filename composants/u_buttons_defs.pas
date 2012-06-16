unit u_buttons_defs;

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
  Menus, ImgList;


const
{$IFDEF VERSIONS}
    gVer_buttons_defs : T_Version = ( Component : 'Customized Buttons' ;
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
  CST_FWCANCEL='TFWCANCEL';
  CST_FWCLOSE='TFWCLOSE';
  CST_FWOK='TFWOK';
  CST_FWWIDTH_CLOSE_BUTTON = 80 ;
  CST_WIDTH_BUTTONS_MOVING  = 60;
  CST_HEIGHT_BUTTONS_MOVING = 40;
  CST_WIDTH_BUTTONS_ACTIONS  = 120;
  CST_HEIGHT_BUTTONS_ACTIONS = 20;


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

    TFWButton = class ( TFWXPButton )
      public
       constructor Create ( AOwner : TComponent ) ; override;
      published
       property Glyph stored False;
       property Height default 25;
       property Width default 25;
     End;

    { TFWMiniButton }

    TFWMiniButton = class ( TFWXPButton )
      public
       constructor Create ( AOwner : TComponent ) ; override;
      published
       property Glyph stored False;
       property Height default 17;
       property Width default 17;
     End;

    { TFWMiniButton }

    { TFWMiniButtonList }

    { TFWButtonList }

    TFWButtonList = class ( TFWXPButton )
      private
       FImagesList : TCustomImageList;
       FImageSize  ,
       FImageIndex : Integer;
       procedure p_setImagesList ( const AValue : TCustomImageList );
       procedure p_setImageIndex ( const AValue : Integer );
       procedure p_setImageSize  ( const AValue : Integer );
      public
       constructor Create ( AOwner : TComponent ) ; override;
       procedure Loaded; override;
       procedure LoadGlyph; virtual;
      published
       property Images: TCustomImageList read FImagesList write p_setImagesList;
       property ImageIndex: Integer read FImageIndex write p_setImageIndex default -1;
       property ImageSize : Integer read FImageSize  write p_setImageSize default 0;
       property Glyph stored False;
       property Height default 17;
       property Width default 17;
    End;

implementation

uses {$IFDEF FPC}ObjInspStrConsts,lclstrconsts,
     {$ELSE}Consts, VDBConsts, {$ENDIF}
     unite_messages, fonctions_images,
     Forms ;


{$IFNDEF FPC}
var Buttons_Appli_ResInstance             : THandle      = 0 ;
{$ENDIF}
// procedure p_Load_Buttons_Appli
// loads a picture into a Button with Picture
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

{ TFWButtonList }

procedure TFWButtonList.p_setImagesList(const AValue: TCustomImageList);
begin
  if FImagesList <> AValue Then
    Begin
     FImagesList:=AValue;
     LoadGlyph;
    end;
end;

procedure TFWButtonList.p_setImageIndex(const AValue: Integer);
begin
  if FImageIndex <> AValue Then
    Begin
     FImageIndex:=AValue;
     LoadGlyph;
    end;
end;

procedure TFWButtonList.p_setImageSize(const AValue: Integer);
begin
  if FImageSize <> AValue Then
    Begin
     FImageSize:=AValue;
     if FImageSize > 0 Then
       AdaptGlyph(FImageSize);
    end;
end;

constructor TFWButtonList.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FImageSize:=0;
  FImageIndex:=-1;
  FImagesList:=nil;
  Height:=17;
  Width :=17;
end;

procedure TFWButtonList.Loaded;
begin
  inherited Loaded;
end;

procedure TFWButtonList.LoadGlyph;
begin
  if assigned ( FImagesList )
  and ( FImageIndex >= 0 )
  and ( FImageIndex < FImagesList.Count )
   then
     FImagesList.GetBitmap ( FImageIndex , Glyph.Bitmap )
   Else
    Glyph.Bitmap.Assign(nil);
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


initialization
{$IFDEF VERSIONS}
  p_ConcatVersion ( gVer_buttons_defs  );
{$ENDIF}
end.


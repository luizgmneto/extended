unit u_buttons_defs;

{$I ..\DLCompilers.inc}
{$I ..\extends.inc}
{$IFDEF FPC}
{$mode Delphi}
{$ENDIF}

interface

uses
{$IFNDEF FPC}
  Windows, Messages,
  fonctions_system,
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
  CST_FWWIDTH_CLOSE_BUTTON = 80 ;
  CST_SIZE_BUTTONS_MOVING  = 60;
  CST_WIDTH_BUTTONS_MOVING  = 60;
  CST_HEIGHT_BUTTONS_MOVING = 40;
  CST_WIDTH_BUTTONS_ACTIONS  = 120;
  CST_HEIGHT_BUTTONS_ACTIONS = 20;
  CST_SUBDIR_IMAGES_SOFT = DirectorySeparator + 'Images'+DirectorySeparator;
  CST_IMAGE_SOFT_BITMAP = '.bmp';
  CST_IMAGES_SOFT_EXTENSIONS : array [ 0 .. {$IFDEF FPC}2{$ELSE}0{$ENDIF} ] of String  = ({$IFDEF FPC}'.xpm','.png',{$ENDIF}CST_IMAGE_SOFT_BITMAP);


procedure p_Load_Buttons_Appli ( const FGLyph : {$IFDEF USEJVCL}TJvPicture{$ELSE}TPicture{$ENDIF USEJVCL}; as_Resource : String ; const acon_control :TControl);
function fs_getSoftImages:String;

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
      protected
       procedure AdaptGlyph (const ASize : Integer ); virtual;
       procedure MouseEnter{$IFNDEF FPC}(Acontrol : TControl ){$ENDIF}; override;
       procedure MouseLeave{$IFNDEF FPC}(Acontrol : TControl ){$ENDIF}; override;
       procedure Click; override;
     public
      constructor Create ( AOwner : TComponent ) ; override;

      published
       property ColorFrameFocus : TColor read FColorFrameFocus write FColorFrameFocus default clCream;
     End;
    { TFWButton }

    TFWButton = class ( TFWXPButton )
    private
      FGlyphSize: Integer;
      public
       constructor Create ( AOwner : TComponent ) ; override;
       procedure Loaded; override;
      published
       property Glyph stored False;
       property GlyphSize : Integer read FGlyphSize write FGlyphSize default 24;
       property Height default 25;
       property Width default 25;
     End;

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
     RtlConsts,FileUtil,
     {$ELSE}Consts, VDBConsts, {$ENDIF}
  {$IFDEF FPC}
  unite_messages,
  {$ELSE}
  unite_messages_delphi,
  {$ENDIF}
     fonctions_images,
     Forms, Math, sysutils,
     Dialogs, fonctions_string;


{$IFNDEF FPC}
var Buttons_Appli_ResInstance             : THandle      = 0 ;
{$ENDIF}

function fs_getSoftImages:String;
Begin
  Result := ExtractFileDir(Application.ExeName)+CST_SUBDIR_IMAGES_SOFT;
End;
// procedure p_Load_Buttons_Appli
// loads a picture into a Button with Picture
procedure p_Load_Buttons_Appli ( const FGLyph : {$IFDEF USEJVCL}TJvPicture{$ELSE}TPicture{$ENDIF USEJVCL}; as_Resource : String ; const acon_control :TControl);
var n : Integer;
    lb_Found : Boolean;
begin
  with FGLyph{$IFNDEF FPC}.Bitmap{$ENDIF} do
   Begin
    {$IFDEF FPC}
    Clear;
    {$ELSE}
    FreeImage;
    {$ENDIF}
    {$IFNDEF MEMBUTTONS}
    if csDesigning in acon_control.ComponentState Then
      Begin
    {$ENDIF}
      {$IFDEF FPC}
        LoadFromLazarusResource(as_Resource);
      {$ELSE}
        if ( Buttons_Appli_ResInstance = 0 ) Then
          Buttons_Appli_ResInstance:= FindResourceHInstance(HInstance);
        LoadFromResourceName(Buttons_Appli_ResInstance, as_Resource );
      {$ENDIF}
      {$IFNDEF MEMBUTTONS}
      end
     Else
      try
        lb_Found := False;
        as_Resource := fs_getSoftImages + as_Resource;
        for n := 0 to high ( CST_IMAGES_SOFT_EXTENSIONS ) do
         if FileExistsUTF8( as_Resource + CST_IMAGES_SOFT_EXTENSIONS [ n ] ) Then
           Begin
            LoadFromFile( as_Resource + CST_IMAGES_SOFT_EXTENSIONS [ n ] );
            lb_Found := True;
            Break;
           end;
        if not lb_Found
         then
           ShowMessage( fs_RemplaceMsg(GS_SOFT_IMAGE_NOT_FOUND, [as_Resource + CST_IMAGES_SOFT_EXTENSIONS [ 0 ]]));

      finally
      end;
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

procedure TFWButtonList.LoadGlyph;
begin
  if assigned ( FImagesList )
  and ( FImageIndex >= 0 )
  and ( FImageIndex < FImagesList.Count )
   then
    Begin
     FImagesList.GetBitmap ( FImageIndex , Glyph.Bitmap );
     if FImageSize > 0 Then
       AdaptGlyph(FImageSize);
    end
   Else
    Glyph.Bitmap.Assign(nil);
end;

{ TFWButton }

constructor TFWButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FGlyphSize:=24;
  Height:=25;
  Width :=25;
end;

procedure TFWButton.Loaded;
begin
  if FGlyphSize >= 0 Then
    AdaptGlyph(FGlyphSize);
  inherited Loaded;
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
var lp_pos : TPoint;
begin
  if Assigned(PopUpMenu) Then
    Begin
     lp_pos.X := Left;
     lp_pos.Y := Top ;
     lp_pos := ClientToScreen( lp_pos );
     PopUpMenu.Popup(lp_pos.X,lp_pos.Y);
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


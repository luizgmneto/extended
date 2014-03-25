unit U_ExtDBImage;

interface

{$i ..\extends.inc}
{$IFDEF FPC}
{$Mode Delphi}
{$ENDIF}

uses Graphics,
{$IFDEF VERSIONS}
  fonctions_version,
{$ENDIF}
     DB, DBCtrls,
     Classes, U_ExtImage;

{$IFDEF VERSIONS}
  const
    gVer_TExtDBImage : T_Version = ( Component : 'Composant TExtDBImage' ;
                                               FileUnit : 'U_ExtDBImage' ;
                                               Owner : 'Matthieu Giroux' ;
                                               Comment : 'Gestion d''images de tous types dans les données.' ;
                                               BugsStory : 'Version 1.0.0.3 : UTF 8.' + #13#10
                                                         + 'Version 1.0.0.2 : Upgrading from tested functions.' + #13#10
                                                         + 'Version 1.0.0.1 : Creating ExtImage.' + #13#10
                                                         + 'Version 1.0.0.0 : En place, tout a été testé.' + #13#10
                                                         + 'Version 0.9.0.1 : En place, tout n''a pas été testé.' + #13#10
                                                         + '0.9.0.0 : Simple affiche de toute image en données.';
                                               UnitType : 3 ;
                                               Major : 1 ; Minor : 0 ; Release : 0 ; Build : 3 );

{$ENDIF}

type

{ TExtDBImage }

   TExtDBImage = class( TExtImage)
     private
       FDataLink: TFieldDataLink;
       FClickAdd : Boolean;
       procedure p_SetDatafield  ( const Value : String );
       procedure p_SetDatasource ( const Value : TDatasource );
       function  fds_GetDatasource : TDatasource;
       function  fs_GetDatafield : String;
       function  ff_Getfield : TField;
     protected
       procedure p_SetImage; virtual;
       procedure p_ActiveChange(Sender: TObject); virtual;
       procedure p_DataChange(Sender: TObject); virtual;
       procedure p_UpdateData(Sender: TObject); virtual;
     public
       procedure Click; override;
       procedure LoadFromStream ( const astream : TStream ); override;
       function  LoadFromFile   ( const afile   : String ):Boolean;  override;
       procedure SaveToStream ( const astream : TMemoryStream ); virtual;
       function  SavetoFile   ( const afile   : String ;const ali_newWidth : Longint ; const ali_newHeight : Longint = 0 ; const ab_KeepProportion : Boolean = True ):Boolean; overload; virtual;
       function  SavetoFile:Boolean; overload; virtual;
       constructor Create(AOwner: TComponent); override;
       destructor Destroy ; override;
       property Field : TField read ff_Getfield;
     published
       property Datafield : String read fs_GetDatafield write p_SetDatafield ;
       property ClickAdd : Boolean read FClickAdd write FClickAdd default False;
       property Datasource : TDatasource read fds_GetDatasource write p_SetDatasource ;
     end;


implementation

uses fonctions_images,
     Controls,
     sysutils,
     ExtDlgs;

{ TExtDBImage }

procedure TExtDBImage.p_ActiveChange(Sender: TObject);
begin
  p_SetImage;
end;

constructor TExtDBImage.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDataLink := TFieldDataLink.Create ;
  FDataLink.DataSource := nil ;
  FDataLink.FieldName  := '' ;
  FDataLink.Control := Self;
  FDataLink.OnDataChange := p_DataChange;
  FDataLink.OnUpdateData := p_UpdateData;
  FDataLink.OnActiveChange := p_ActiveChange;
  FClickAdd:=False;
end;

procedure TExtDBImage.p_DataChange(Sender: TObject);
begin
  p_SetImage;
end;

destructor TExtDBImage.Destroy;
begin
  FDataLink.Free;
  inherited;
end;

function TExtDBImage.fs_GetDatafield: String;
begin
  if assigned ( FDataLink ) then
    Begin
      Result := FDataLink.FieldName ;
    End
   Else
    Result := '';

end;

function TExtDBImage.ff_Getfield: TField;
begin
  Result:=FDataLink.Field;
end;

function TExtDBImage.LoadFromFile(const afile: String):Boolean;
begin
  Result := False;
  FFileName:=afile;
  if  assigned ( FDataLink.Field )
  and FileExists(FFileName) then
    Begin
      p_ImageFileToField(FFileName, FDataLink.Field, ShowErrors);
      Result := True;
    End;
end;

procedure TExtDBImage.SaveToStream(const astream: TMemoryStream);
begin
  if  assigned ( FDataLink.Field ) then
    Begin
      p_ImageFieldToStream ( FDataLink.Field, astream, ShowErrors );
    end;
end;

function TExtDBImage.SavetoFile(const afile: String;
  const ali_newWidth: Longint; const ali_newHeight: Longint;
  const ab_KeepProportion: Boolean): Boolean;
begin
  if  assigned ( FDataLink.Field ) then
    Begin
      fb_ImageFieldToFile ( FDataLink.Field, afile, ali_newWidth, ali_newHeight, ab_KeepProportion, ShowErrors );
    end;
end;

function TExtDBImage.SavetoFile: Boolean;
var LSaveDialog : TSavePictureDialog;
begin
  LSaveDialog:=TSavePictureDialog.Create(Self);
  if LSaveDialog.Execute
   Then Result := SavetoFile(LSaveDialog.FileName,0,0,True)
   Else Result := False;
end;

procedure TExtDBImage.LoadFromStream(const astream: TStream);
begin
  if  assigned ( FDataLink.Field ) then
    Begin
      p_StreamToField( astream, FDataLink.Field, ShowErrors );
    End;
end;

function TExtDBImage.fds_GetDatasource: TDatasource;
begin
  if assigned ( FDataLink ) then
    Begin
      Result := FDataLink.Datasource ;
    End
   Else
    Result := Datasource;

end;

procedure TExtDBImage.p_SetDatafield(const Value: String);
begin
  if assigned ( FDataLink )
  and ( Value <> FDataLink.FieldName ) then
    Begin
      FDataLink.FieldName := Value;
    End;
end;

procedure TExtDBImage.p_SetDatasource(const Value: TDatasource);
begin
  if assigned ( FDataLink )
  and ( Value <> FDataLink.Datasource ) then
    Begin
      FDataLink.Datasource := Value;
    End;
end;

procedure TExtDBImage.p_SetImage;
begin
  if assigned ( FDataLink )
  and assigned ( FDataLink.Field )
  and not FDataLink.Field.IsNull
   Then
    Begin
      p_FieldToImage ( FDataLink.Field, Self.Picture.Bitmap, 0, 0, False, ShowErrors );
    End
   Else
    Picture.Bitmap.Assign(nil);
end;

procedure TExtDBImage.p_UpdateData(Sender: TObject);
begin
  p_SetImage;
end;

procedure TExtDBImage.Click;
begin
  if Assigned(OnClick) Then
    inherited Click
   Else
     if not ( csDesigning in ComponentState)
     and FClickAdd
     and Assigned(FDataLink.Field)
     and FDataLink.CanModify Then
       with TOpenPictureDialog.Create(Self) do
        try
          Filter:='Graphic (*.bmp;*.xpm;*.pbm;*.pgm;*.ppm;*.ico;*.icns;*.cur;*.jpeg;*.jpg;*.jpe;*.jfif;*.tif;*.tiff;*.gif;*.gif;*.dagsky;*.dat;*.dagtexture;*.img;*.cif;*.rci;*.bsi;*.xpm;*.pcx;*.psd;*.pdd;*.jp2;*.j2k;*.j2c;*.jpx;*.jpc;*.pfm;*.pam;*.ppm;*.pgm;*.pbm;*.tga;*.dds;*.gif;*.jng;*.mng;*.png;*.jpg;*.jpeg;*.jfif;*.jpe;*.jif;*.bmp;*.dib;*.tga;*.dds;*.jng;*.mng;*.gif;*.png;*.jpg;*.jpeg;*.jfif;*.jpe;*.jif;*.bmp;*.dib)|*.bmp;*.xpm;*.pbm;*.pgm;*.ppm;*.ico;*.icns;*.cur;*.jpeg;*.jpg;*.jpe;*.jfif;*.tif;*.tiff;*.gif;*.gif;*.dagsky;*.dat;*.dagtexture;*.img;*.cif;*.rci;*.bsi;*.xpm;*.pcx;*.psd;*.pdd;*.jp2;*.j2k;*.j2c;*.jpx;*.jpc;*.pfm;*.pam;*.ppm;*.pgm;*.pbm;*.tga;*.dds;*.gif;*.jng;*.mng;*.png;*.jpg;*.jpeg;*.jfif;*.jpe;*.jif;*.bmp;*.dib;*.tga;*.dds;*.jng;*.mng;*.gif;*.png;*.jpg;*.jpeg;*.jfif;*.jpe;*.jif;*.bmp;*.dib|Bitmaps (*.bmp)|*.bmp|Pixmap (*.xpm)|*.xpm|Portable PixMap (*.pbm;*.pgm;*.ppm)|*.pbm;*.pgm;*.ppm|Icon (*.ico)|*.ico|Mac OS X Icon (*.icns)|*.icns|Cursor (*.cur)|*.cur|Joint Picture Expert Group (*.jpeg;*.jpg;*.jpe;*.jfif)|*.jpeg;*.jpg;*.jpe;*.jfif|Tagged Image File Format (*.tif;*.tiff)|*.tif;*.tiff|Graphics Interchange Format (*.gif)|*.gif|Animated GIF (*.gif)|*.gif|Imaging Graphic AllInOne (*.dagsky)|*.dagsky|Imaging Graphic AllInOne (*.dat)|*.dat|Imaging Graphic AllInOne (*.dagtexture)|*.dagtexture|Imaging Graphic AllInOne (*.img)|*.img|Imaging Graphic AllInOne (*.cif)|*.cif|Imaging Graphic AllInOne (*.rci)|*.rci|Imaging Graphic AllInOne (*.bsi)|*.bsi|Imaging Graphic AllInOne (*.xpm)|*.xpm|Imaging Graphic AllInOne (*.pcx)|*.pcx|Imaging Graphic AllInOne (*.psd)|*.psd|Imaging Graphic AllInOne (*.pdd)|*.pdd|Imaging Graphic AllInOne (*.jp2)|*.jp2|Imaging Graphic AllInOne (*.j2k)|*.j2k|Imaging Graphic AllInOne (*.j2c)|*.j2c|Imaging Graphic AllInOne (*.jpx)|*.jpx|Imaging Graphic AllInOne (*.jpc)|*.jpc|Imaging Graphic AllInOne (*.pfm)|*.pfm|Imaging Graphic AllInOne (*.pam)|*.pam|Imaging Graphic AllInOne (*.ppm)|*.ppm|Imaging Graphic AllInOne (*.pgm)|*.pgm|Imaging Graphic AllInOne (*.pbm)|*.pbm|Imaging Graphic AllInOne (*.tga)|*.tga|Imaging Graphic AllInOne (*.dds)|*.dds|Imaging Graphic AllInOne (*.gif)|*.gif|Imaging Graphic AllInOne (*.jng)|*.jng|Imaging Graphic AllInOne (*.mng)|*.mng|Imaging Graphic AllInOne (*.png)|*.png|Imaging Graphic AllInOne (*.jpg)|*.jpg|Imaging Graphic AllInOne (*.jpeg)|*.jpeg|Imaging Graphic AllInOne (*.jfif)|*.jfif|Imaging Graphic AllInOne (*.jpe)|*.jpe|Imaging Graphic AllInOne (*.jif)|*.jif|Imaging Graphic AllInOne (*.bmp)|*.bmp|Imaging Graphic AllInOne (*.dib)|*.dib|Truevision Targa Image (*.tga)|*.tga|DirectDraw Surface (*.dds)|*.dds|JPEG Network Graphics (*.jng)|*.jng|Multiple Network Graphics (*.mng)|*.mng|Graphics Interchange Format (*.gif)|*.gif|Portable Network Graphics (*.png)|*.png|Joint Photographic Experts Group Image (*.jpg)|*.jpg|Joint Photographic Experts Group Image (*.jpeg)|*.jpeg|Joint Photographic Experts Group Image (*.jfif)|*.jfif|Joint Photographic Experts Group Image (*.jpe)|*.jpe|Joint Photographic Experts Group Image (*.jif)|*.jif|Windows Bitmap Image (*.bmp)|*.bmp|Windows Bitmap Image (*.dib)|*.dib|Tous les fichiers (*)|*|';
          if Execute Then
           Begin
            FDataLink.Edit;
            (FDataLink.Field as TBlobField).LoadFromFile(FileName);
           end;
        finally
          Destroy;
        end;
end;

{$IFDEF VERSIONS}
initialization
  p_ConcatVersion ( gVer_TExtDBImage );
{$ENDIF}
end.

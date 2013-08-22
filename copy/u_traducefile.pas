unit u_traducefile;
{
Composant TTraduceFile

Développé par:
Matthieu GIROUX
Licence GPL

Composant non visuel permettant de traduire un fichier image
Compatible Linux


Version actuelle: 1.0

Mises à jour:
}
interface

{$IFDEF FPC}
{$mode Delphi}
{$ENDIF}
{$I ..\dlcompilers.inc}
{$I ..\extends.inc}

uses
  SysUtils, Classes, StdCtrls,
{$IFDEF FPC}
  unit_messagescopy,
{$ELSE}
  fonctions_system,
  unit_messagescopy_delphi,
{$ENDIF}

{$IFDEF VERSIONS}
   fonctions_version,
{$ENDIF}
   U_ExtAbsCopy,
  {$IFDEF MAGICK}
   ImageMagick,
   magick_wand;
  {$ELSE}
  ImagingTypes,
  {$IFDEF CCREXIF}
  CCR.Exif,
  {$ENDIF}
  Imaging  ;
  {$ENDIF}

{$IFDEF VERSIONS}
const
    gVer_TTraduceFile : T_Version = ( Component : 'Composant TTraduceFile' ;
                                               FileUnit : 'u_traducefile' ;
                                               Owner : 'Matthieu Giroux' ;
                                               Comment : 'Traduction de fichiers images.' ;
                                               BugsStory : '1.0.1.1 : No notification verify on destroy.' +
                                                           '1.0.1.0 : Header and EndofFile Memo property.'+#13#10
                                                         + '1.0.0.0 : Testing alone.'+#13#10
                                                         + '0.9.0.0 : Gestion en place.';
                                               UnitType : 3 ;
                                               Major : 1 ; Minor : 0 ; Release : 1 ; Build : 1 );

{$ENDIF}
type

    { TTraduceFile }
    TEImageFileOption = ( foJPEG, foAutodesk, foBMP, foEPS, foCUT, foGIF, foPaintshop, foPCD, foPCX, foPhotoshop, foPortableMap, foPNG, foTIFF, foRLA, foSGI, foTarga );
    TEImageFilesOption = set of TEImageFileOption;
    TETraduceOptions = set of TESimpleCopyOption;


const lfo_TraduceDefault = foJPEG ;
    CST_COPYFILES_ERROR_IMAGING = 11 ;
    EExtensionsImages : Array [TEImageFileOption] of ShortString = ('jpg','pic','bmp','eps','cut','gif','psp','pcd','pcx','psd','ppm','png','tif','rla','sgi','tga');
//      lfo_TraduceDefaults = [foTIFF,foXPM,foBMP];

type

    TTraduceFile = class(TAbsFileCopy, IFileCopyComponent)
           private
             FTraduceOptions : TETraduceOptions;
             FResizeHeight : Longint ;
             FResizeWidth  : Longint ;
             FKeepProportion,
             FTraduceImage : Boolean ;
             FBeforeCopyBuffer: TECopyEvent;
             FOnChange : TEChangeDirectoryEvent ;
             FBufferSize : integer;
             FSizeProgress : Integer ;
             FOnSuccess : TECopyFinishEvent;
             FOnFailure : TECopyErrorEvent ;
             FBeforeCopy : TEReturnEvent ;
             FOnProgress       : TECopyEvent;
             FDestinationOption : TEImageFileOption ;
             FHeader,FEndOfFile : TCustomMemo;
             FSource,FDestination : String;
             FInProgress : Boolean;
             procedure SetDestination(const AValue: String);
             procedure SetSource(const AValue: String);
           protected
             FInited : Boolean;
             function  SaveToFile(const Adata : {$IFDEF MAGICK}PMagickWand{$ELSE}TImageData{$ENDIF}; const as_source, as_Destination : String ; const AFormat : {$IFDEF MAGICK}String {$ELSE}TImageFileFormat{$ENDIF}; const AResized : Boolean = False):Longint;
             function DoInit: Integer; virtual;
             function UnInit: Integer; virtual;
             function  BeforeCopy : Boolean ; virtual;
             function CreateDestination ( const as_Destination : String ): Boolean; virtual;
             procedure Notification(AComponent: TComponent; Operation: TOperation);
               override;
             { Déclarations protégées }
           public
             constructor Create ( AOwner : TComponent ) ; override;
             function IsCopyOk ( const ai_Error : Integer ; as_Message : String ):Boolean; override;
             function InternalDefaultCopyFile  ( const as_Source, as_Destination : String ):Boolean; virtual;
             procedure InternalFinish ( const as_Source, as_Destination : String ); virtual;
             procedure PrepareCopy ; virtual;
             property InProgress : Boolean read FInprogress;
             Function CopyFile ( const as_Source, as_Destination : String ):Integer; virtual;
             Procedure CopySourceToDestination; virtual;
             destructor Destroy;override;
           published
             property TraduceOptions : TETraduceOptions read FTraduceOptions write FTraduceOptions;
             property TraduceImage : Boolean read FTraduceImage write FTraduceImage default True;
             property BufferSize : integer read FBufferSize write FBufferSize default 65536;
             property Header : TCustomMemo read FHeader write FHeader;
             property EndOfFile : TCustomMemo read FEndOfFile write FEndOfFile;
             property ResizeHeight : Longint read FResizeHeight write FResizeHeight default 0 ;
             property ResizeWidth  : Longint read FResizeWidth  write FResizeWidth  default 0 ;
             property KeepProportion  : Boolean read FKeepProportion write FKeepProportion default True ;
             property FileSource : String read FSource write SetSource;
             property FileDestination : String read FDestination write SetDestination;
//             property ImageSourceOptions : TEImageFilesOption read FSourceOptions write FSourceOptions default lfo_TraduceDefaults ;
             property ImageDestinationOption : TEImageFileOption read FDestinationOption write FDestinationOption default lfo_TraduceDefault ;
             property OnSuccess : TECopyFinishEvent read FOnSuccess write FOnSuccess;
             property OnFailure : TECopyErrorEvent read FOnFailure write FOnFailure;
             property OnProgress : TECopyEvent read FOnProgress write Fonprogress;
             property OnBeforeCopyBuffer : TECopyEvent read FBeforeCopyBuffer write FBeforeCopyBuffer;
             property OnBeforeCopy : TEReturnEvent read FBeforeCopy write FBeforeCopy;
             property OnChange : TEChangeDirectoryEvent read FOnChange write FOnChange;
           end;

implementation

uses fonctions_file, fonctions_string, Forms,
  {$IFDEF CCREXIF}
     CCR.Exif.JpegUtils, CCR.Exif.TagIDs, CCR.Exif.XMPUtils,
  {$ENDIF}
  TypInfo;
{$IFDEF MAGICK}
function ThrowWandException(wand: PMagickWand): String;
var
  description: PChar;
  severity: ExceptionType;
begin
  description := MagickGetException(wand, @severity);
  Result := Format('Erreur. Description: %s', [description]);
  description := MagickRelinquishMemory(description);
end;
 {$ENDIF}
{TTraduceFile}

// DoInit TTraduceFile component
constructor TTraduceFile.Create(AOwner :Tcomponent);
begin
  FResizeHeight := 0 ;
  FResizeWidth  := 0 ;
  FKeepProportion := True ;
  inherited Create(AOwner);
  FBufferSize := 65536;
  FInited := False;
  FTraduceImage := True ;
//  FSourceOptions     := lfo_TraduceDefaults ;
  FDestinationOption := lfo_TraduceDefault ;
  FInProgress := False;
  {$IFDEF CCREXIF}
  ExifData := TTradExifData.Create;
  {$ENDIF}
end;

// destination property
procedure TTraduceFile.SetDestination(const AValue: String);
begin
  if FDestination <> AValue Then
    Begin
      FDestination := AValue;
    End;
end;

// Source property and event
procedure TTraduceFile.SetSource(const AValue: String);
begin
  if FSource <> AValue Then
    Begin
      FSource := AValue;
      if not ( csDesigning in ComponentState )
      and Assigned ( FOnChange )
       Then
        FOnChange ( Self, FSource, FDestination );
    End;
end;


// Event beforecopy
function TTraduceFile.BeforeCopy: Boolean;
begin
  Result := True ;
  DoInit;
  if Assigned ( FBeforeCopy ) Then
    FBeforeCopy ( Self, Result );
end;

function TTraduceFile.CreateDestination ( const as_Destination : String ):Boolean;
begin
  Result :=  not DirectoryExists ( FDestination )
  and not fb_CreateDirectoryStructure ( FDestination );
end;

procedure TTraduceFile.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if ( Operation <> opRemove )
  or ( csDestroying in ComponentState ) Then
   Exit;
  if AComponent=Header Then Header := nil;
  if AComponent=EndOfFile Then EndOfFile := nil;
end;


Function TTraduceFile.DoInit: Integer;
Begin
  if not FInited
    Then
{$IFDEF MAGICK}
      try
        MagickWandGenesis;
        FInited := True;

      Except

        On E: Exception do
          Begin
            Result := CST_COPYFILES_ERROR_CANT_COPY ;
            IsCopyOk ( Result, GS_COPYFILES_ERROR_INIT_MAGICK );
            Exit ;
          End ;
      End ;
 {$ELSE}
   FInited := True;
 {$ENDIF}

  Result := 0;
end;

Function TTraduceFile.UnInit: Integer;
Begin
{$IFDEF MAGICK}
   if FInited
    Then
      try
        MagickWandTerminus;
      Except

        On E: Exception do
          Begin
            Result := CST_COPYFILES_ERROR_CANT_COPY ;
            IsCopyOk ( Result, GS_COPYFILES_ERROR_UNINIT_MAGICK );
            Exit ;
          End ;
      End ;
 {$ENDIF}

  FInited := False;
  Result := 0;
end;
{$IFNDEF MAGICK}
// Function to load original file
function LoadImageFromFileFormat(const FileNameSource, FileNameExtSource, FileNameExtDest : string;
var Image: TImageData; var FormatSource : TImageFileFormat ;
{$IFDEF CCREXIF}const ExifData : TExifData ;{$ENDIF} const FileTypeDest : TEImageFileOption ):
  Boolean;
var
  IArray: TDynImageDataArray;
  I: LongInt;
  ls_extension:String;
begin
  Assert(FileNameSource <> '');
  Result := False;
  FormatSource := FindImageFileFormatByExt(DetermineFileFormat(FileNameSource));

  if not assigned ( FormatSource ) then
    Exit;
  for i:=0 to FormatSource.Extensions.Count - 1  do
    if FileNameExtDest = FormatSource.Extensions [ i ] Then
      Begin
       Result := True;
       Break;
      end;
  if Result Then
   Begin
    Result := False;
    ls_extension := LowerCase(FileNameExtSource);
    for i:=0 to FormatSource.Extensions.Count - 1  do
      if ls_extension = FormatSource.Extensions [ i ] Then
        Begin
         Result := True;
         Break;
        end;
   end;
  {$IFDEF CCREXIF}
  if Result
  and ( FileTypeDest in [foJPEG] ) then
    ExifData.LoadFromJPEG(FileNameSource);
  {$ENDIF}
  IArray := nil;
  FreeImage(Image);
  Result := FormatSource.LoadFromFile(FileNameSource, IArray, True);
  if Result and (Length(IArray) > 0) then
  begin
    Image := IArray[0];
    for I := 1 to Length(IArray) - 1 do
      FreeImage(IArray[I]);
  end
  else
    Result := False;

 if not Result Then
  Begin
    FormatSource := nil;
  end;
end;



{$IFDEF CCREXIF}
function TTraduceFile.DoSaveHeaderToJPEG( const InStream, OutStream: TStream):Boolean; //forces proper order of JFIF -> Exif -> XMP
var
  BytesToSegment, InStreamStartPos: Int64;
  FoundMetadata: TJPEGMetadataKinds;
  I: Integer;
  Segment: IFoundJPEGSegment;
  SegmentsToSkip: IInterfaceList;
  SOFData: PJPEGStartOfFrameData;
  Tag: TExifTag;

begin
  InStream.Position := 0;
  Result := False;
  if HasJPEGHeader(InStream) then
  with ExifData do
    Begin
      InStreamStartPos := InStream.Position;
      for Tag in Sections[esDetails] do
        case Tag.ID of
          ttExifImageWidth, ttExifImageHeight:
          begin
            for Segment in JPEGHeader(InStream, StartOfFrameMarkers) do
              if Segment.Data.Size >= SizeOf(TJPEGStartOfFrameData) then
              begin
                SOFData := Segment.Data.Memory;
                ExifImageWidth := SOFData.ImageWidth;
                ExifImageHeight := SOFData.ImageHeight;
                Break;
              end;
            InStream.Position := InStreamStartPos;
            Break;
          end;
        end;
      FoundMetadata := [];
      SegmentsToSkip := TInterfaceList.Create;
      WriteJPEGFileHeaderToStream(OutStream);
      for Segment in JPEGHeader(InStream, [jmJFIF, jmApp1]) do
      begin
        if Segment.MarkerNum = jmJFIF then
          WriteJPEGSegmentToStream(OutStream, Segment)
        else
        begin
          if not (mkExif in FoundMetadata) and HasExifHeader(Segment.Data) then
            Include(FoundMetadata, mkExif)
          else if not (mkXMP in FoundMetadata) and HasXMPSegmentHeader(Segment.Data) then
            Include(FoundMetadata, mkXMP)
          else
            Continue;
        end;
        SegmentsToSkip.Add(Segment);
      end;
      if not Empty then
        WriteJPEGSegmentToStream(OutStream, TUserJPEGSegment.Create(jmApp1,ExifData));
      if XMPSegmentToLoad <> nil then
        WriteJPEGSegmentToStream(OutStream, XMPSegmentToLoad)
      else if not XMPPacket.Empty then
      begin
        XMPPacket.WriteSegmentHeader := True;
        WriteJPEGSegmentToStream(OutStream, TUserJPEGSegment.Create(jmApp1, XMPPacket));
      end;
      InStream.Position := InStreamStartPos + SizeOf(JPEGFileHeader);
      for I := 0 to SegmentsToSkip.Count - 1 do
      begin
        Segment := IFoundJPEGSegment(SegmentsToSkip[I]);
        BytesToSegment := Segment.Offset - InStream.Position;
        if BytesToSegment > 0 then
          OutStream.CopyFrom(InStream, BytesToSegment);
        InStream.Seek(Segment.TotalSize, soCurrent)
      end;
      OutStream.CopyFrom(InStream, InStream.Size - InStream.Position);
      OutStream.Size := OutStream.Position;
      Result := True;
    End;
end;
{$ENDIF}

// Function to save with original file
function SaveImageToFileFormat(const AStream: TStream; const Image: TImageData; const FormatSource : TImageFileFormat): Boolean;
var
  IArray: TDynImageDataArray;
  {$IFDEF CCREXIF}
  InStream  : TMemoryStream;
  {$ENDIF}
begin
  Result := False;
  if FormatSource <> nil then
  begin
    SetLength(IArray, 1);
    IArray[0] := Image;
    {$IFNDEF CCREXIF}
    Result := FormatSource.SaveToStream(AStream, IArray, True);
    {$ELSE}
    // Saving exif too
    if FDestinationOption in [foJPEG] then
      Begin
        InStream  := TMemoryStream.Create;
        try
          Result := FormatSource.SaveToStream(InStream, IArray, True);
          DoSaveHeaderToJPEG(InStream,AStream);
        finally
          InStream .Free;
        end;
      End
     Else
      Result := FormatSource.SaveToStream(AStream, IArray, True);
    {$ENDIF}
  end;
end;
{$ENDIF}

function TTraduceFile.SaveToFile ( const Adata : {$IFDEF MAGICK}PMagickWand{$ELSE}TImageData{$ENDIF};
                                   const as_source, as_Destination : String ;
                                   const AFormat : {$IFDEF MAGICK}String {$ELSE}TImageFileFormat{$ENDIF} ;
                                   const AResized : Boolean = False ):Longint;
var   FileStream, FileStreamSource : TFileStream ;
      LBuffer : array of Byte;
      LBufferSize : Integer;
Begin
  if FTraduceImage Then
      Begin

        {$IFDEF MAGICK}
        Result := Longint (MagickWriteImage   ( Adata, Pchar(as_Destination))<>MagickTrue);
        {$ELSE}
        fb_CreateDirectoryStructure(ExtractFileDir(as_Destination));
        FileStream := TFileStream.Create(as_Destination,fmCreate);
        try
          if FHeader <> nil Then
             HexToBinary ( FHeader.Lines, FileStream );
          if ( AFormat = nil ) Then
           Begin
            Result := Longint ( SaveImageToStream   ( ExtractFileExt(as_Destination), FileStream, Adata ) <> true )
           end
           Else
            Begin
              if AResized Then
                Begin
                  // if resized reinit compression
                  if   assigned ( GetPropInfo ( AFormat, 'Quality' ))
                    Then SetPropValue( AFormat, 'Quality', -1 );
                  AFormat.CheckOptionsValidity;
                end;
              Result := Longint ( SaveImageToFileFormat ( FileStream, Adata, AFormat ) <> true );
            end;
          if Result > 0 Then
          if FileExists(as_source) Then
           Begin
             FileStreamSource := TFileStream.Create(as_source,fmOpenRead);
             SetLength(LBuffer,FBufferSize);
             with FileStreamSource do
               try
                 while Size - Position <> 0 do
                  Begin
                    if FBufferSize < Size - Position
                     Then LBufferSize:=FBufferSize
                     Else LBufferSize:=Size - Position;
                      ReadBuffer(LBuffer[0],LBufferSize);
                    FileStream.WriteBuffer(LBuffer[0],LBufferSize);
                    Application.ProcessMessages;
                  end;

               finally
                 Free;
               end;
           end;
          if FEndOfFile <> nil Then
             HexToBinary ( FEndOfFile.Lines, FileStream );
          {$ENDIF}
        finally
          FileStream.Free;
        end;
      End ;
end;

// Copy image file and traducing it
Function TTraduceFile.CopyFile ( const as_Source, as_Destination : String  ):Integer;
var
  ls_FileName, ls_FileExt, ls_FileDestExt : String ;
  ls_Destination : String ;
  lsr_data : Tsearchrec;
  li_ImageWidth,
  li_ImageHeight,
  li_Size : Longint ;
  Format : {$IFDEF MAGICK}String {$ELSE}TImageFileFormat{$ENDIF};
  Resized : Boolean ;

  Fdata : {$IFDEF MAGICK}PMagickWand{$ELSE}TImageData{$ENDIF};


begin
  Result := 1 ;
  ls_Destination := '' ;
  ls_FileName := '';
  ls_FileExt := '';
  Application.ProcessMessages;
  if ( FileExists ( as_Destination )) Then
    Begin
      FindFirst(as_Destination,faanyfile,lsr_data);
      p_FileNameDivision ( lsr_data.Name, ls_FileName, ls_FileExt );
      if ( ls_FileExt <> '' ) Then
        ls_Destination := Copy ( as_Destination, 1, length ( as_Destination ) - length ( lsr_data.Name ) ) + ls_FileName
       Else
        ls_Destination := as_Destination ;
      findclose(lsr_data);
    End ;
  if ( FileExists ( as_Source )) Then
    Begin
      FindFirst(as_source,faanyfile,lsr_data);
      p_FileNameDivision ( lsr_data.Name, ls_FileName, ls_FileExt );
      if ( ls_Destination = '' )
       Then
         ls_Destination := Copy ( as_Destination, 1, length ( as_Destination ) - length ( ls_FileExt ));
      findclose(lsr_data);
    End ;

  Format := {$IFDEF MAGICK}''{$ELSE}nil{$ENDIF} ;
  Application.ProcessMessages;
  ls_FileDestExt := EExtensionsImages[FDestinationOption];

  if PrepareFileSourceAndDestination ( as_Source, ls_Destination, False, False ) > 0 Then
    Exit ;

  {$IFNDEF MAGICK}
  try

  Finalize(FData);
  // initialisation of image data
  InitImage( FData );

    // Verify if same format file
  if LoadImageFromFileFormat( as_Source, ls_FileExt, ls_FileDestExt, Fdata, Format, {$IFDEF CCREXIF}ExifData,{$ENDIF} FDestinationOption)
   Then ls_Destination := ls_Destination + '.'+ls_FileDestExt
   Else ls_Destination := ls_Destination +ls_FileExt ;

  Except
    On E: Exception do
      Begin
        Result := CST_COPYFILES_ERROR_CANT_COPY ;
        IsCopyOk ( Result, GS_COPYFILES_ERROR_READING + '( ' + as_Source + ' -> ' + as_Destination + ' )' );
        Exit ;
      End ;
  End ;
  {$ELSE}
  Fdata:= NewMagickWand;

  // Verify if same format file
  if MagickReadImage(Fdata,Pchar(as_Source))=MagickFalse Then
    Begin
      Result := CST_COPYFILES_ERROR_CANT_COPY;
      IsCopyOk ( Result, GS_COPYFILES_ERROR_READING + '( ' + as_Source + ' ):'+#13#10+ThrowWandException( Fdata ) );
      ls_Destination := ls_Destination +ls_FileExt ;
    end
  else
   ls_Destination := ls_Destination + '.'+ls_FileDestExt;
   {$ENDIF}

  Application.ProcessMessages;

  // events
  if not BeforeCopy Then
    Exit ;
  PrepareCopy ;
    Resized := False ;
    try

      li_ImageWidth  := {$IFDEF MAGICK}MagickGetImageWidth (Fdata){$ELSE}Fdata.Width{$ENDIF};
      li_ImageHeight := {$IFDEF MAGICK}MagickGetImageHeight(Fdata){$ELSE}Fdata.Height{$ENDIF};
      // let the system doing some thinks
      Application.ProcessMessages;
      //Resizing
      if  (( FResizeWidth  < li_ImageWidth ) or ( FResizeHeight < li_ImageHeight ))
      and ( li_ImageHeight > 0 )
      and ( li_ImageWidth > 0 )
      and ( not FKeepProportion )
        Then
         Begin
          {$IFDEF MAGICK}
          Resized := MagickResizeImage ( Fdata, FResizeWidth, FResizeHeight, QuadraticFilter, 1 )= MagickTrue;
          {$ELSE}
          Resized := ResizeImage ( fdata, FResizeWidth, FResizeHeight, rfNearest );
          {$ENDIF}
         End
        else
         Begin
           if  ( FResizeWidth > 0 )
           and ( FResizeWidth <  li_ImageWidth )
           // doit-on retailler en longueur ?
           and (( FResizeHeight = 0 ) or ( li_ImageWidth / FResizeWidth > li_ImageHeight / FresizeHeight ))
            Then
             Begin
               li_Size := ( FResizeWidth * li_ImageHeight ) div li_ImageWidth;
               {$IFDEF MAGICK}
               Resized := MagickResizeImage ( Fdata, FResizeWidth, li_Size, QuadraticFilter, 1 )= MagickTrue;
               {$ELSE}
               Resized := ResizeImage ( fdata, FResizeWidth, li_Size, rfNearest );
               {$ENDIF}
             End
           else
             if  ( FResizeHeight > 0 )
             and ( FResizeHeight <  li_ImageHeight ) Then
               Begin
                 li_Size := ( FResizeHeight * li_ImageWidth ) div li_ImageHeight ;
                 {$IFDEF MAGICK}
                 Resized := MagickResizeImage ( Fdata, li_Size, FResizeHeight, QuadraticFilter, 1 )= MagickTrue;
                 {$ELSE}
                 Resized := ResizeImage ( fdata, li_Size, FResizeHeight, rfNearest );
                 {$ENDIF}
           End ;
        End ;
      {$IFDEF CCREXIF}
      case ExifData.Orientation of
        toTopRight: FlipImage( data );
        toBottomRight: RotateImage( data, -180 );
        toBottomLeft : MirrorImage( data );
        toLeftTop : Begin  FlipImage( data ); RotateImage( data, -270 ); End;
        toRightTop : RotateImage( data, -90 );
        toRightBottom : Begin  FlipImage( data ); RotateImage( data, -90 ); End;
        toLeftBottom : RotateImage( data, -270 );
      End;
      ExifData.Orientation := toUndefined;
      {$ENDIF}
      // let the system doing some thinks
      Application.ProcessMessages;

      Result := SaveToFile( Fdata, as_Source, ls_Destination, Format, Resized);

      // let the system doing some thinks
      Application.ProcessMessages;

    Except
      On E: Exception do
        Begin
          Result := CST_COPYFILES_ERROR_CANT_COPY ;
          IsCopyOk ( Result, GS_COPYFILES_ERROR_CANT_COPY + '( ' + as_Source + ' -> ' + as_Destination + ' )' );
          Exit ;
        End ;
    End ;


  {$IFDEF MAGICK}
  Fdata := DestroyMagickWand(Fdata);
  {$ELSE}
  FreeImage( FData );
  {$ENDIF}
  // let the system doing some thinks
  Application.ProcessMessages;

  if Result = 0 then
    Begin
      InternalFinish ( as_Source, ls_Destination );
    End ;
  // let the system doing some thinks
  Application.ProcessMessages;
end;

function TTraduceFile.InternalDefaultCopyFile  ( const as_Source, as_Destination : String ):Boolean;
var li_Error : Integer ;
begin
  li_Error := CopyFile ( as_Source, as_Destination );
  Result := li_Error = 0 ;
End ;

// verifying traduced copy
function TTraduceFile.IsCopyOk ( const ai_Error : Integer ; as_Message : String ):Boolean;
begin
  Result := True ;
  if  ( ai_Error <> 0 ) then
    Begin
      if assigned ( FOnFailure ) then
        Begin
            FOnFailure ( Self, ai_Error, as_Message, Result );
        End ;
    End ;
End ;
// Internal finish
procedure TTraduceFile.InternalFinish ( const as_Source, as_Destination : String );
begin
  if assigned ( FOnSuccess ) then
    Begin
        FOnSuccess ( Self, as_Source, as_Destination, 0 );
    End ;
End ;

procedure TTraduceFile.PrepareCopy;
begin

end;


// overrided Copy to traduce image file
procedure TTraduceFile.CopySourceToDestination;
begin
  Finprogress := true;
  FSizeProgress := 0 ;
  if not FileExists ( FSource )
  or (     not DirectoryExists ( ExtractFileDir ( FDestination ))
      and  not FileExists ( FDestination ))
   Then
    Exit ;
  try
    DoInit;
    InternalDefaultCopyFile ( FSource, FDestination );
  finally
    FinProgress := false;
    UnInit;
  End ;
end;

destructor TTraduceFile.Destroy;
begin
  UnInit;
  inherited Destroy;
end;

{$IFDEF VERSIONS}
initialization
  p_ConcatVersion ( gVer_TTraduceFile );
{$ENDIF}
end.

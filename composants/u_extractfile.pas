unit u_extractfile;
{
Composant TExtractFile

Développé par:
Matthieu GIROUX
Licence GPL

Composant non visuel permettant d'estraire d'un fichier



Version actuelle: 1.0

Mises à jour:
}
interface

{$IFDEF FPC}
{$mode Delphi}
{$ENDIF}

uses
  SysUtils, Classes,ComCtrls,
{$IFDEF VERSIONS}
   fonctions_version,
{$ENDIF}
   U_ExtAbsCopy,
   DB;

{$IFDEF VERSIONS}
const
    gVer_TExtractFile : T_Version = ( Component : 'Composant TExtractFile' ;
                                               FileUnit : 'U_Extractfile' ;
                                               Owner : 'Matthieu Giroux' ;
                                               Comment : 'Extraction dans des fichiers.' ;
                                               BugsStory : '0.9.0.0 : Gestion en place.';
                                               UnitType : 3 ;
                                               Major : 0 ; Minor : 9 ; Release : 0 ; Build : 0 );

{$ENDIF}
type

    { TExtractFile }
    TEExtractOption = (eoCaseSentitive,eoMail,eoUnique);
    TEExtractOptions = set of TEExtractOption;


type

    TExtractFile = class(TAbsFileCopy, IFileCopyComponent)
     private
       FExtractOptions : TEExtractOptions;
       FOnChange : TEChangeDirectoryEvent ;
       FOnSuccess : TECopyFinishEvent;
       FOnFailure : TECopyErrorEvent ;
       FBeforeExtract : TEReturnEvent ;
       FOnProgress       : TECopyEvent;
       FSource : String;
       FMiddleExtract,
       FBeginExtract,
       FEndExtract  : String ;
       FDestination : TDatasource;
       FFieldName : String;
       FInProgress : Boolean;
       procedure SetDestination(const AValue: TDataSource);
       procedure SetSource(const AValue: String);
       procedure SetFieldName(const AValue: String);
     protected
       FInited : Boolean;
       function IsCopyOk(const ai_Error: Integer;  as_Message: String): Boolean; override;
       function  BeforeCopy : Boolean ; virtual;
       function CreateDestination ( const as_Destination : String ): Boolean; virtual;
       { Déclarations protégées }
     public
       constructor Create ( AOwner : TComponent ) ; override;
       function InternalDefaultCopyFile  ( const as_Source, as_Destination : String ):Boolean; virtual;
       procedure InternalFinish ( const as_Source, as_Destination : String ); virtual;
       procedure PrepareCopy ; virtual;
       property InProgress : Boolean read FInprogress;
       Procedure CopySourceToDestination; virtual;
       destructor Destroy;override;
     published
       property ExtractOptions : TEExtractOptions read FExtractOptions write FExtractOptions;
       property DirSource : String read FSource write SetSource;
       property FieldName : String read FFieldName write SetFieldName;
       property DataSource : TDatasource read FDestination write SetDestination;
       property OnSuccess : TECopyFinishEvent read FOnSuccess write FOnSuccess;
       property OnFailure : TECopyErrorEvent read FOnFailure write FOnFailure;
       property OnProgress : TECopyEvent read FOnProgress write Fonprogress;
       property OnBeforeExtract : TEReturnEvent read FBeforeExtract write FBeforeExtract;
       property OnChange : TEChangeDirectoryEvent read FOnChange write FOnChange;
       property BeginExtract : String read FBeginExtract write FBeginExtract;
       property EndExtract : String read FEndExtract write FEndExtract;
       property MiddleExtract : String read FMiddleExtract write FMiddleExtract;
     end;

implementation

uses fonctions_file, Forms, TypInfo, StrUtils, fonctions_proprietes, Dialogs;

{TExtractFile}

// DoInit TExtractFile component
constructor TExtractFile.Create(AOwner :Tcomponent);
begin
  inherited Create(AOwner);
  FInited := False;
  FInProgress := False;
end;

// destination property
procedure TExtractFile.SetDestination(const AValue: TDatasource);
begin
  if FDestination <> AValue Then
    Begin
      FDestination := AValue;
    End;
end;

// Source property and event
procedure TExtractFile.SetSource(const AValue: String);
begin
  if FSource <> AValue Then
    Begin
      FSource := AValue;
      if not ( csDesigning in ComponentState )
      and Assigned ( FOnChange )
       Then
        FOnChange ( Self, FSource, '' );
    End;
end;

procedure TExtractFile.SetFieldName(const AValue: String);
begin
  if AValue <> FFieldName Then
   Begin
     FFieldName:= AValue;
   end;

end;


// Event BeforeExtract
function TExtractFile.BeforeCopy: Boolean;
begin
  Result := True ;
  if  assigned ( FDestination )
  and assigned ( FDestination.DataSet ) Then
   with FDestination.Dataset do
    try
      if Active Then
        Exit;
      Open;
      if not assigned ( FindField(FFieldName)) Then
        Result := False ;
    Except
      Result := False ;
    end
   Else
    Result := False;
  if Assigned ( FBeforeExtract ) Then
    FBeforeExtract ( Self, Result );

end;

function TExtractFile.CreateDestination(const as_Destination: String): Boolean;
begin
  Result := True;
end;

// verifying Extractd copy
function TExtractFile.IsCopyOk ( const ai_Error : Integer ;  as_Message : String ):Boolean;
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
procedure TExtractFile.InternalFinish ( const as_Source, as_Destination : String );
begin
  if assigned ( FOnSuccess ) then
    Begin
        FOnSuccess ( Self, as_Source, as_Destination, 0 );
    End ;
End ;

procedure TExtractFile.PrepareCopy;
begin

end;
function TExtractFile.InternalDefaultCopyFile  ( const as_Source, as_Destination : String ):Boolean;
var lstl_Strings : TStringList;
    ls_Temp, ls_temp2 : String;
    li_Begin,
    li_end,
    li_i : Integer;
    procedure p_DecInc ( const ab_Prior : Boolean );
    Begin
      if ab_Prior
       Then dec(li_Begin)
       else inc(li_end);
    End;
    procedure p_MiddleExtract ( var ai_BeginEnd : Integer; const ab_Prior : Boolean );
    Begin
      if FMiddleExtract <> '' Then
      Begin
        ai_BeginEnd := pos ( FMiddleExtract, ls_Temp );
        p_DecInc ( ab_Prior );
        if (ai_BeginEnd > 0) Then
          while (((ai_BeginEnd>0 ) and ab_Prior ) or ((ai_BeginEnd<length(ls_Temp)) and not ab_Prior ))
          and (( ls_Temp [ ai_BeginEnd ] in ['0'..'9','A'..'Z','a'..'z'] )or (( eoMail in ExtractOptions )and ( ls_Temp [ ai_BeginEnd ] in ['.','-'] )))
           do
            p_DecInc ( ab_Prior );

      end;
    End;

Begin
  Result := True;
  if FileExists(as_Source) Then
   Begin
    lstl_Strings := TStringList.Create;
    try
     lstl_Strings.LoadFromFile(as_Source);
     for li_i := 0 to lstl_Strings.Count - 1 do
       Begin
         ls_Temp:=lstl_Strings [ li_i ];
         if FBeginExtract <> '' Then
           li_Begin := pos ( FBeginExtract, ls_Temp )
          else
           Begin
             p_MiddleExtract ( li_Begin, True );
             inc ( li_begin );
             if li_Begin = pos ( FMiddleExtract, ls_Temp ) Then
              Continue;
             if li_end = pos ( FMiddleExtract, ls_Temp ) Then
              Continue;
           end;
         if  ( li_Begin > 0 ) Then
           Begin
             if FEndExtract <> ''
              Then li_end:=posEx ( FEndExtract, ls_Temp, li_Begin + length ( FBeginExtract ) )
              else p_MiddleExtract ( li_end, False );
             if ( li_end > 0 )
              Then
               Begin
                ls_temp2:=copy ( ls_Temp, li_Begin + length ( FBeginExtract ), li_end - li_Begin - length ( FBeginExtract )+1);
                with FDestination.DataSet do
                 if not ( eoUnique in FExtractOptions ) or not Locate(FFieldName,ls_temp2,[loCaseInsensitive]) Then
                 Begin
                   Append;
//                   ShowMessage(copy ( ls_Temp, li_Begin + length ( FBeginExtract ), li_end - li_Begin - length ( FBeginExtract )));
                   FieldByName(FFieldName).Value:=ls_temp2;
                   Post;
                 end;
               end;

           end;
       end;
    finally
      lstl_Strings.Free;
    end;
   End;
  InternalFinish(as_Source,as_Destination);
end;

// overrided Copy to Extract image file
procedure TExtractFile.CopySourceToDestination;
begin
  Finprogress := true;
  if not FileExists ( FSource )
  or not assigned ( FDestination )
  or not assigned ( FDestination.Dataset )
   Then
    Exit ;
  try
    InternalDefaultCopyFile ( FSource, '' );
  finally
    FinProgress := false;
  End ;
end;

destructor TExtractFile.Destroy;
begin
  inherited Destroy;
end;

{$IFDEF VERSIONS}
initialization
  p_ConcatVersion ( gVer_TExtractFile );
{$ENDIF}
end.

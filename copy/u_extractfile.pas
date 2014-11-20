unit u_extractfile;
{
Composant TExtractFile

Développé par:
Matthieu GIROUX
Licence LGPL

Composant non visuel permettant d'estraire d'un fichier

}
interface

{$IFDEF FPC}
{$mode Delphi}
{$ENDIF}

uses
  SysUtils, Classes,
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
    TEExtractOption = (eoCaseSentitive,eoUnique);
    TEExtractOptions = set of TEExtractOption;


type

   { TExtExtractColumn }

   TExtExtractColumn = class(TCollectionItem)
   private
     FFieldName : String;
     FExtractChars, FIncludeChars, FExtractEnd, FExtractBegin, FExtractEndEnter : String ;
     FRight, FLeft : Boolean;
     FEraseExtractChars : Boolean;
     procedure SetLeft  ( AValue : Boolean );
     procedure SetRight ( AValue : Boolean );
     procedure SetFieldName(const AValue: String);
   public
     constructor Create(ACollection: TCollection); override;
   published
     property EraseExtractChars  : Boolean     read FEraseExtractChars  write FEraseExtractChars  default True;
     property TakeLeft  : Boolean     read FLeft  write SetLeft  default True;
     property TakeRight : Boolean     read FRight write SetRight default True;
     property FieldName : String      read FFieldName    write SetFieldName;
     property ExtractChars : String   read FExtractChars write FExtractChars;
     property IncludeChars : String   read FIncludeChars write FIncludeChars;
     property ExtractBegin : String   read FExtractBegin write FExtractBegin;
     property ExtractEnd   : String   read FExtractEnd   write FExtractEnd;
     property ExtractEndEnter   : String   read FExtractEndEnter   write FExtractEndEnter;
   end;

   TExtExtractColumnClass = class of TExtExtractColumn;
   { TExtExtractColumns }

   TExtExtractColumns = class(TCollection)
   private
     function GetColumn ( Index: Integer): TExtExtractColumn;
     procedure SetColumn( Index: Integer; const Value: TExtExtractColumn);
   public
     function Add: TExtExtractColumn;
     {$IFDEF FPC}
    published
     {$ENDIF}
     property Items[Index: Integer]: TExtExtractColumn read GetColumn write SetColumn; default;
   end;


    TExtractFile = class(TAbsFileCopy, IFileCopyComponent)
     private
       FColumnsExtract : TExtExtractColumns;
       FExtractOptions : TEExtractOptions;
       FOnChange : TEChangeDirectoryEvent ;
       FOnSuccess : TECopyFinishEvent;
       FOnFailure : TECopyErrorEvent ;
       FBeforeExtract : TEReturnEvent ;
       FOnProgress       : TECopyEvent;
       FSource : String;
       FDestination : TDatasource;
       FInProgress : Boolean;
       FBeginLine,FEndLine:String;
       procedure SetDestination(const AValue: TDataSource);
       procedure SetSource(const AValue: String);
     protected
       FInited : Boolean;
       function IsCopyOk(const ai_Error: Integer;  as_Message: String): Boolean; override;
       function  BeforeCopy : Boolean ; virtual;
       function CreateDestination ( const as_Destination : String ): Boolean; virtual;
       function GetColumns: TExtExtractColumns; virtual;
       function CreateColumns: TExtExtractColumns; virtual;
       procedure SetColumns(const AValue: TExtExtractColumns); virtual;
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
       property ColumnsExtract: TExtExtractColumns read GetColumns write SetColumns;
       property LineBegin : String read FBeginLine write FBeginLine;
       property LineEnd : String read FEndLine write FEndLine;
       property ExtractOptions : TEExtractOptions read FExtractOptions write FExtractOptions;
       property DirSource : String read FSource write SetSource;
       property DataSource : TDatasource read FDestination write SetDestination;
       property OnSuccess : TECopyFinishEvent read FOnSuccess write FOnSuccess;
       property OnFailure : TECopyErrorEvent read FOnFailure write FOnFailure;
       property OnProgress : TECopyEvent read FOnProgress write Fonprogress;
       property OnBeforeExtract : TEReturnEvent read FBeforeExtract write FBeforeExtract;
       property OnChange : TEChangeDirectoryEvent read FOnChange write FOnChange;
     end;

implementation

uses Forms, TypInfo,
     StrUtils,
     FileUtil,
     fonctions_string,
     lazutf8classes,
     Dialogs;

{ TExtExtractColumns }

function TExtExtractColumns.GetColumn(Index: Integer): TExtExtractColumn;
begin
  Result:=inherited Items[index] as TExtExtractColumn;
end;

procedure TExtExtractColumns.SetColumn(Index: Integer;
  const Value: TExtExtractColumn);
begin
  Items[Index]:=Value;
end;

function TExtExtractColumns.Add: TExtExtractColumn;
begin
  Result:=Inherited Add as TExtExtractColumn;
end;

{ TExtExtractColumn }

procedure TExtExtractColumn.SetLeft(AValue: Boolean);
begin
  // need a true value
  if  not AValue
  and not FRight Then
   Exit;
  FLeft:=AValue;
end;

procedure TExtExtractColumn.SetRight(AValue: Boolean);
begin
  // need a true value
  if  not AValue
  and not FLeft Then
   Exit;
  FRight:=AValue;
end;

procedure TExtExtractColumn.SetFieldName(const AValue: String);
begin
  if AValue <> FFieldName Then
     FFieldName:= AValue;
end;

constructor TExtExtractColumn.Create(ACollection: TCollection);
begin
  inherited Create(ACollection);
  FLeft :=True;
  FRight:=True;
  FEraseExtractChars:=True;
  FIncludeChars:=CST_NUMBERS+CST_ALPHABETA+lowercase(CST_ALPHABETA)+'.'+'-';
end;

{TExtractFile}

// DoInit TExtractFile component
constructor TExtractFile.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FInited := False;
  FInProgress := False;
  FColumnsExtract:=CreateColumns;
end;

// destination property
procedure TExtractFile.SetDestination(const AValue: TDataSource);
begin
  if FDestination <> AValue Then
    FDestination := AValue;
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
      if FColumnsExtract.Count <= 0 Then
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

function TExtractFile.GetColumns: TExtExtractColumns;
begin
  Result := FColumnsExtract;
end;

function TExtractFile.CreateColumns: TExtExtractColumns;
begin
  Result:=TExtExtractColumns.Create(TExtExtractColumn);
end;

procedure TExtractFile.SetColumns(const AValue: TExtExtractColumns);
begin
  FColumnsExtract.Assign(AValue);
end;

// verifying Extractd copy
function TExtractFile.IsCopyOk ( const ai_Error : Integer ;  as_Message : String ):Boolean;
begin
  Result := True ;
  if  ( ai_Error <> 0 )
  and assigned ( FOnFailure ) then
     FOnFailure ( Self, ai_Error, as_Message, Result );
End ;
// Internal finish
procedure TExtractFile.InternalFinish ( const as_Source, as_Destination : String );
begin
  if assigned ( FOnSuccess ) then
      FOnSuccess ( Self, as_Source, as_Destination, 0 );
End ;

procedure TExtractFile.PrepareCopy;
begin

end;
function TExtractFile.InternalDefaultCopyFile  ( const as_Source, as_Destination : String ):Boolean;
var lstl_Strings : TStringListUTF8;
    ls_Text, ls_found : String;
    li_Begin,
    li_end,
    li_i, li_maxCurrent, li_j : Integer;
    li_beginLine, li_EndLine, li_currentColumn, li_currentPosition, li_column : Integer;
    lb_searchbeginline,lb_searchendline : Boolean;
    function fb_IsCorrectChar ( const ai_pos : Integer ; const AIncludeChars : String ):boolean;
    Begin
      if AIncludeChars > ''
       Then  Result := ( pos ( ls_Text [ ai_pos ], AIncludeChars ) > 0 );
    End;
    procedure p_ExtractString ( const ALeft, ARight : Boolean ; const AIncludeChars : String );
    Begin
      if ALeft Then
         while (li_Begin>1 )
         and fb_IsCorrectChar ( li_Begin - 1, AIncludeChars )
           do
            Dec ( li_Begin );
      if ARight Then
       while (li_end<length(ls_Text))
       and fb_IsCorrectChar ( li_end + 1, AIncludeChars )
        do Inc ( li_end );
    End;
    function fb_SearchNextText : Boolean ;
    var li_i, li_pos : Integer;
        ls_temp2 : String;
    Begin
      Result:=False;
      with FColumnsExtract, FDestination.DataSet do
      for li_i := li_column to Count - 1 do
       with Items [ li_i ] do
         Begin
          li_pos := posex ( FExtractChars, ls_text, li_beginLine );
          if li_pos > 0 Then
           Begin
             if not Result Then
              Begin
                Result := True;
                Append;
              End;
             li_currentPosition := li_pos;
             if li_currentPosition>li_maxCurrent Then
              li_maxCurrent:=li_currentPosition + length(FExtractChars);
             li_begin := li_currentPosition;
             li_end   := li_currentPosition + length(FExtractChars);
             if FExtractEnd > ''
              Then
                li_end:=posEx ( FExtractEnd, ls_Text, li_Begin + length ( FExtractChars ) ) - 1;
              p_ExtractString(FLeft,FRight,FIncludeChars);
             if ( li_end > 0 )
              Then
               Begin
                 if FEraseExtractChars and not ( FLeft and FRight )
                   Then
                    Begin
                      if      Fleft  Then ls_temp2:=copy ( ls_Text, li_Begin, li_end - li_Begin - length ( FExtractChars )+1)
                      else if FRight Then ls_temp2:=copy ( ls_Text, li_Begin + length ( FExtractChars ), li_end - li_Begin - length ( FExtractChars )+1)
                    End
                    else ls_temp2:=copy ( ls_Text, li_Begin, li_end - li_Begin+1);
                 if not ( eoUnique in FExtractOptions ) or not Locate(FFieldName,ls_temp2,[loCaseInsensitive]) Then
                  with Fields [ li_column ] do
                   Begin
                     AsString:=ls_temp2;
                   end;
                 if FExtractEnd > ''
                  Then li_currentPosition := posex(FExtractEnd,ls_Text,li_end+1)
                  Else li_currentPosition := li_end+1;
               end;
           end;
          if (li_i = count-1) and (State in [dsInsert,dsEdit]) Then
           Begin
             if FEndLine > ''
              Then li_beginLine:=posex(FEndLine,ls_Text,li_maxCurrent)
              else li_beginLine:=li_maxCurrent;
             Post;
           End;
      end;
    end;

Begin
  Result := True;
  li_maxCurrent:=0;
  if FileExistsUTF8(as_Source) Then
   Begin
    lstl_Strings := TStringListUTF8.Create;
    li_beginLine:=1;
    li_EndLine := 1;
    lb_searchbeginline := FBeginLine > '';
    lb_searchendline   := FEndLine   > '';
    try
     lstl_Strings.LoadFromFile(as_Source);
     li_column := 0;
     ls_text:=lstl_Strings.Text;
     ls_Text:=lstl_Strings.Text;
     repeat
       if lb_searchbeginline Then
         li_beginLine := posex ( FBeginLine, ls_text, li_EndLine );
     until not fb_SearchNextText;
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
  if not FileExistsUTF8 ( FSource )
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
  FColumnsExtract.Destroy;
end;

{$IFDEF VERSIONS}
initialization
  p_ConcatVersion ( gVer_TExtractFile );
{$ENDIF}
end.

unit fonctions_search_edit;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

{$I ..\DLCompilers.inc}

interface

uses Controls, Classes,
     {$IFDEF FPC}
     LCLType,
     {$ELSE}
     Messages, Windows,
     {$ENDIF}
     Graphics, DB,DBCtrls,
     {$IFDEF VERSIONS}
     fonctions_version,
     {$ENDIF}
     fonctions_string,
     DBGrids, StdCtrls;

const
{$IFDEF VERSIONS}
    gVer_Tfonctions_SearchEdit : T_Version = ( Component : 'Composant TExtSearchDBEdit' ;
                                          FileUnit : 'U_TExtSearchDBEdit' ;
                                          Owner : 'Matthieu Giroux' ;
                                          Comment : 'Searching in a dbedit.' ;
                                          BugsStory : '1.2.0.1 : Testing on Delphi.'
                                                    + '1.2.0.0 : Multiple searchs and TListPopupEdit import.'
                                                    + '1.1.0.0 : Adding fb_KeyUp.'
                                                    + '1.0.0.0 : Creating fb_SearchText.';
                                          UnitType : 1 ;
                                          Major : 1 ; Minor : 2 ; Release : 0 ; Build : 1 );

{$ENDIF}
  SEARCHEDIT_GRID_DEFAULTS = [dgColumnResize, dgRowSelect, dgColLines, dgConfirmDelete, dgCancelOnExit, dgTabs, dgAlwaysShowSelection];
  SEARCHEDIT_GRID_DEFAULT_SCROLL = {$IFDEF FPC}ssAutoBoth{$ELSE}ssBoth{$ENDIF};

type ISearchEdit = interface
      ['{34886DAB-F444-41A9-9F76-347109C99273}']
      procedure Locating;
      procedure NotFound;
      procedure SearchText;
      procedure InitSearch;
      procedure FreePopup;
      procedure SetEvent ;
      procedure ValidateSearch;
      function GetFieldSearch: String;
      function ListLines:Integer;
      function ListUp:Boolean;
     End;
  { TListPopupEdit }

  TListPopupEdit = class ( TDBGrid )
    FEdit : TCustomEdit;
    FSearchSource: TFieldDataLink;
  private
  protected
    procedure KeyUp(var Key: Word; Shift: TShiftState); override;
  public
    procedure Click; override;
    constructor Create ( Aowner : TComponent ); override;
    property Edit : TCustomEdit read FEdit;
    procedure ShowPopup; virtual;
    procedure AutoPlace; virtual;
    procedure SetPopup ( const AEdit: TCustomEdit; const ASearchSource: TFieldDataLink;
                         const ASearchList: String; const ASeparator: Char;
                         const AListWidth : Integer; const AColor: TColor; const AFont: TFont); virtual;
  published
    property Options default SEARCHEDIT_GRID_DEFAULTS;
    property Scrollbars default SEARCHEDIT_GRID_DEFAULT_SCROLL;
  end;


function fb_SearchText(const AEdit : TCustomEdit ; const FSearchSource : TFieldDataLink; const FSearchFiltered : Boolean; const FTextSeparator : String ):Boolean;
function fb_KeyUp ( const AEdit : TCustomEdit ;var Key : Word ; var Alocated, ASet : Boolean; const APopup : TCustomControl ):Boolean;
function fb_SearchLocating(var FPopup : TListPopupEdit; const AEdit : TCustomEdit ; const FSearchSource : TFieldDataLink; const FTextSeparator : String ; const FSearchList : String ; const FFieldSeparator : Char; const FListWidth : Integer ):Boolean;
procedure p_ShowPopup(var FPopup : TListPopupEdit;const AEdit : TCustomEdit; const FSearchSource : TFieldDataLink; const FSearchList : String ; const FFieldSeparator : Char; const FListWidth : Integer );

implementation

uses
     fonctions_db,
     fonctions_proprietes,
     sysutils;

{ TListPopup }

procedure TListPopupEdit.KeyUp(var Key: Word; Shift: TShiftState);
begin
  inherited KeyUp(Key, Shift);
  case Key of
    VK_ESCAPE : Visible:=False;
    VK_RETURN : Click;
    end;
end;

// clik event of datasearch popup
procedure TListPopupEdit.Click;
begin
  with FEdit as ISearchEdit do
   Begin
    Text := FSearchSource.Dataset.FieldByName ( FSearchSource.FieldName ).AsString;
    InitSearch;
    ValidateSearch;
   End;
 Visible:=False;
end;

procedure TListPopupEdit.SetPopup ( const AEdit: TCustomEdit; const ASearchSource: TFieldDataLink;
                                    const ASearchList : String;const ASeparator : Char;
                                    const AListWidth : Integer; const AColor: TColor;const AFont: TFont );
var Alist : TStrings;
    i : Integer;
Begin
  FSearchSource := ASearchSource;
  FEdit:=AEdit;
  Alist := TStringList.Create;
  try
    p_ChampsVersListe(Alist,ASearchList,ASeparator);
    if AListWidth > 0
     Then Width := AListWidth
     Else Width := AEdit.Width;
    Height := ( AEdit as ISearchEdit ).ListLines * AEdit.Height;
    DataSource:=FSearchSource.DataSource;
    // cannot make self parent
    Parent:=AEdit.Owner as TWinControl;
    Color := AColor;
    Font.Assign(AFont);
    for i := 0 to Alist.Count-1 do
      Begin
        with Columns.Add do
         Begin
          FieldName := Alist[i];
         end;
      end;
    Loaded;
  finally
    Alist.Free;
  end;
end;

constructor TListPopupEdit.Create(Aowner: TComponent);
begin
  inherited Create(Aowner);
  Options:= SEARCHEDIT_GRID_DEFAULTS;
  ScrollBars:=SEARCHEDIT_GRID_DEFAULT_SCROLL;
end;

procedure TListPopupEdit.AutoPlace;
var    APoint : TPoint;
Begin
  with APoint do
   Begin
     X := FEdit.Left;
     if (FEdit as ISearchEdit).ListUp
      Then Y := FEdit.Top - Height
      Else Y := FEdit.Top + FEdit.Height;
     APoint:=(FEdit.Owner as TControl).ScreenToClient(FEdit.ClientToScreen(APoint));
     Left:=X;
     Top :=Y;
   end;
end;

procedure TListPopupEdit.ShowPopup;
var i, j, AWidth, AActiveRecord : Integer;
Begin
  with FEdit,FSearchSource,DataSet do
   Begin
     DisableControls;
     AActiveRecord := ActiveRecord;
     try
       // good columns' size
       for j := 0 to (FEdit as ISearchEdit).ListLines do
         Begin
           AWidth:=0;
           for i := 0 to Columns.Count-1 do
             Begin
               with Columns [i] do
                Begin
                 if i = Columns.Count-1 Then
                  Begin
                    Width:=Self.Width-AWidth;
                    Break;
                  end;
                 Width  := Canvas.TextWidth(Field.DisplayText+'a');
                 if Width > Self.Width div Columns.Count
                  then Width := Self.Width div Columns.Count;
                 inc ( AWidth, Width );
                end;
             end;
            Next;
          if eof Then
            Break;
         end;
     finally
       ActiveRecord:=AActiveRecord;
       EnableControls;
     end;
   end;
   AutoPlace;
   Visible:=True;
End;

{ functions }

// show popup
procedure p_ShowPopup(var FPopup : TListPopupEdit;const AEdit : TCustomEdit; const FSearchSource : TFieldDataLink; const FSearchList : String ; const FFieldSeparator : Char; const FListWidth : Integer );
var i : Integer;
    ABookmark:TBookmark;
Begin
  with AEdit,FSearchSource.DataSet do
  if  ( RecordCount > 1 )
  and ( FSearchList <> '' ) Then
   Begin
     ABookmark:=FSearchSource.DataSet.GetBookmark;
     try
       if not Assigned( FPopup ) Then
        Begin
          FPopup := TListPopupEdit.Create(Owner);
          FPopup.SetPopup ( AEdit,FSearchSource,FSearchList,
                           FFieldSeparator, FListWidth,fli_getComponentProperty (AEdit,CST_PROPERTY_COLOR), fobj_getComponentObjectProperty (AEdit,CST_PROPERTY_FONT) as TFont);
        end;
       FPopup.ShowPopup;
     finally
       FSearchSource.DataSet.GotoBookmark(ABookmark);
       FreeBookmark(ABookmark);
     end;
   End;
End;


// return partially or fully located
function fb_SearchText(const AEdit : TCustomEdit ; const FSearchSource : TFieldDataLink; const FSearchFiltered : Boolean; const FTextSeparator : String ):Boolean;
var LText : String;
    li_pos : Integer;
begin
  with AEdit,FSearchSource,Dataset do
    Begin
      Open ;
      Ltext := Text;
      li_pos := fs_LastString ( FTextSeparator, LText );
      if li_pos>0
        Then
         Begin
          inc ( li_pos, length ( FTextSeparator ));
          LText := copy (LText,li_pos,length ( LText ) - li_pos +1 );
         End;
       // Trouvé ?
      if not assigned ( FindField ( FieldName )) Then Exit;
      if FSearchFiltered Then
       Begin
        Filter := 'LOWER('+ FieldName+') LIKE ''' + LowerCase(fs_stringDbQuote(LText)) +'%''';
        Filtered:=True;
       End;
      if not IsEmpty Then
       Result := fb_Locate ( DataSet, FieldName, LText, [loCaseInsensitive, loPartialKey], True ); // not found : no popup
    end
end;

function fb_SearchLocating(var FPopup : TListPopupEdit; const AEdit : TCustomEdit ; const FSearchSource : TFieldDataLink; const FTextSeparator : String ; const FSearchList : String ; const FFieldSeparator : Char; const FListWidth : Integer ):Boolean;
var li_pos : Integer;
    ls_temp : String;
begin
  p_ShowPopup(FPopup,AEdit,FSearchSource,FSearchList,FFieldSeparator,FListWidth);
  with AEdit do
    Begin
      ls_temp := Text ; // c'est en affectant le texte que l'on passe en mode édition
      li_pos := fs_LastString ( FTextSeparator, Ls_temp );
      if li_pos>0
        Then
         Begin
          inc ( li_pos, length ( FTextSeparator ));
          ls_temp := copy ( ls_temp, 1, li_pos -1 );
         End
        Else ls_temp := '' ;
      li_pos    := SelStart ;
      ls_temp   := ls_temp + FSearchSource.Dataset.FieldByName ( FSearchSource.FieldName ).AsString;
      Text      := ls_temp ; // c'est en affectant le texte que l'on passe en mode édition
      SelStart  := li_pos ;
      SelLength := length ( ls_temp ) - li_pos ;
      Result    := SelLength=0;
    end;
end;



// return Continue
function fb_KeyUp ( const AEdit : TCustomEdit ;var Key : Word ; var Alocated, ASet : Boolean; const APopup : TCustomControl ):Boolean;
Begin
  Result:=True;
  with AEdit do
  case Key of
    VK_ESCAPE:
        SelectAll;
    VK_DELETE :
    Begin
      Alocated:=False;
      ASet := False;
      SelText:='';
      Result:=False;
    end;
    VK_RETURN:
    Begin
      (AEdit as ISearchEdit).ValidateSearch;
      Result:=False;
    End;
    VK_DOWN,VK_UP:
    Begin
      if assigned ( APopup )
      and APopup.Visible Then
       APopup.SetFocus;
      Result:=False;
    End;
  end;
End;

end.


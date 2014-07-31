unit fonctions_search_edit;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

{$I ..\DLCompilers.inc}
{$I ..\extends.inc}

interface

uses Controls, Classes,
     {$IFDEF FPC}
     LCLType,
     {$ELSE}
     Messages, Windows,
     {$ENDIF}
     DBCtrls,
     Graphics, DB,
     {$IFDEF VERSIONS}
     fonctions_version,
     {$ENDIF}
     Forms,
     fonctions_string,
     DBGrids, StdCtrls;

const
{$IFDEF VERSIONS}
    gVer_Tfonctions_SearchEdit : T_Version = ( Component : 'Composant TExtSearchDBEdit' ;
                                          FileUnit : 'U_TExtSearchDBEdit' ;
                                          Owner : 'Matthieu Giroux' ;
                                          Comment : 'Searching in a dbedit.' ;
                                          BugsStory : '1.3.0.0 : Integrating rxpopupform.'
                                                    + '1.2.0.1 : Testing on Delphi.'
                                                    + '1.2.0.0 : Multiple searchs and TListPopupEdit import.'
                                                    + '1.1.0.0 : Adding fb_KeyUp.'
                                                    + '1.0.0.0 : Creating fb_SearchText.';
                                          UnitType : 1 ;
                                          Major : 1 ; Minor : 3 ; Release : 0 ; Build : 0);

{$ENDIF}
  SEARCHEDIT_GRID_DEFAULTS = [dgColumnResize, dgRowSelect, dgColLines, dgConfirmDelete, dgCancelOnExit, dgTabs, dgAlwaysShowSelection];
  SEARCHEDIT_GRID_DEFAULT_SCROLL = {$IFDEF FPC}ssAutoBoth{$ELSE}ssBoth{$ENDIF};
  SEARCHEDIT_GRID_DEFAULT_OPTIONS = [dgColLines, dgRowLines];
  SEARCHEDIT_DEFAULT_FIELD_SEPARATOR = ';';
  SEARCHEDIT_DEFAULT_COUNT = 7;

type ISearchEdit = interface
      ['{34886DAB-F444-41A9-9F76-347109C99273}']
      procedure Locating;
      procedure NotFound;
      procedure p_SearchText;
      procedure ValidateSearch;
      function CanModify:Boolean;
      procedure  SelectKeyValue(ListValue:String);
      procedure ClosePopupEvent;
      procedure FreePopup;
      procedure SetEvent ;
      function GetFieldSearch: String;
     End;

  { TExtPopupGrid }

  TExtPopupGrid = class(TDBGrid)
   private
    WControl:TWinControl;
    FLookupDisplayIndex: integer;
    FLookupDisplayField:string;
    procedure SetLookupDisplayIndex(const AValue: integer);
  protected
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    property LookupDisplayIndex:integer read FLookupDisplayIndex write SetLookupDisplayIndex;
    property  Control:TWinControl read WControl;
  public
    procedure Click; override;
    constructor CreatePopUp(const AControl: TWinControl;
      const AOptions : TDBGridOptions;const ARowCount,AWidth:word); virtual;
    procedure DoSetFieldsFromString(FL,FWidths:string;const AFieldSeparator:Char); virtual;
    property LookupDisplayIndex:integer read FLookupDisplayIndex write SetLookupDisplayIndex;
  end;


  { TExtDBPopup }

  { TExtPopUpForm }

  TExtPopUpForm = class (TForm)
  private
    FGrid:TExtPopupGrid;
  end;

function fb_KeyUp ( const AEdit : TCustomEdit ;var Key : Word ; var Alocated, ASet : Boolean; const APopup : TCustomControl ):Boolean;
function fb_SearchLocating(var FPopup : TExtPopupGrid; var FSearchVisible : Boolean;
                           const AControl : TCustomEdit ; const FSearchSource : TFieldDataLink;
                           const FTextSeparator : String ; const AOptions : TDBGridOptions;
                           const ALookupDisplayIndex : Integer; const ARowCount,AWidth :Word;
                           const FSearchList,FWidths : String ;const FFieldSeparator:Char ):Boolean;
function fb_SearchText(const AEdit : TCustomEdit ; const FSearchSource : TFieldDataLink;
                       const FSearchFiltered : Boolean; const FTextSeparator : String ):Boolean;
procedure p_ShowPopup(var FPopup : TExtPopupGrid;const AControl : TWinControl;
                      const FSearchSource : TFieldDataLink;const FSearchList,FWidths : String;
                      const ALookupDisplayIndex : Integer; const ARowCount,AWidth :Word;
                      const AOptions : TDBGridOptions ;const FFieldSeparator:Char);
implementation

uses dbutils,
     fonctions_db,
     {$IFDEF FPC}
     LazUTF8,
     {$ELSE}
     {$ENDIF}
     fonctions_proprietes,
     Variants,
     sysutils;

// show popup
procedure p_ShowPopup(var FPopup : TExtPopupGrid;const AControl : TWinControl;
                      const FSearchSource : TFieldDataLink;const FSearchList,FWidths : String;
                      const ALookupDisplayIndex : Integer; const ARowCount,AWidth :Word;
                      const AOptions : TDBGridOptions ;const FFieldSeparator:Char);
var i : Integer;
    ABookmark:TBookmark;
Begin
  with AControl,FSearchSource.DataSet do
  if  ( RecordCount > 1 )
  and ( FSearchList > '' ) Then
   Begin
     ABookmark:=FSearchSource.DataSet.GetBookmark;
     try
       if not Assigned( FPopup ) Then
        Begin
          FPopup:=TExtPopupGrid.CreatePopUp(AControl, AOptions,ARowCount,AWidth);
          FPopup.Datasource:=FSearchSource.Datasource;
          FPopup.LookupDisplayIndex:=ALookupDisplayIndex;

          FPopup.ParentColor:=True;
          FPopup.ParentFont:=True;

          FPopup.DoSetFieldsFromString(FSearchList,FWidths,FFieldSeparator);
          FPopup.Loaded;

        end;
       FPopup.Show;
     finally
       FSearchSource.DataSet.GotoBookmark(ABookmark);
       FreeBookmark(ABookmark);
     end;
   End;
End;

{ TExtPopupGrid }


procedure TExtPopupGrid.KeyDown(var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_ESCAPE:Visible:=False;
    VK_RETURN:begin
                Click;
                exit;{In that case we need to exit away.}
              end;
  else
    if  (Key = VK_UP)
    and (Row = FixedRows)
     Then WControl.SetFocus
     Else inherited KeyDown(Key, Shift);
  end;
end;

procedure TExtPopupGrid.DoSetFieldsFromString(FL,FWidths: string;const AFieldSeparator:Char);
var
  FieldName:string;
  GK:TColumn;
  K:integer;
  ANumber : String;
begin
  while (FL<>'') do
  begin
    K:=Pos(AFieldSeparator, FL);
    if K>0 then
    begin
      FieldName:=Copy(FL, 1, K-1);
      Delete(FL, 1, K);
      K:=Pos(AFieldSeparator, FWidths);
      if K>0 then
      begin
        ANumber:=Copy(FWidths, 1, K-1);
        Delete(FWidths, 1, K);
      end;
    end
    else
    begin
      FieldName:=FL;
      Anumber:=FWidths;
      FL:='';
      FWidths:='';
    end;
    GK:=Columns.Add;
    GK.FieldName:=FieldName;
    if ANumber > '' Then
      try
        GK.Width:=StrToInt(ANumber);
      Except
      end;
    GK.Visible:=True;
  end;
end;

constructor TExtPopupGrid.CreatePopUp(const AControl: TWinControl;
      const AOptions : TDBGridOptions;const ARowCount,AWidth:word);
var
  PopupOrigin:TPoint;
begin
  inherited Create(AControl.Owner);
  Parent:=AControl.Owner as TWinControl;
  while Parent.Owner is TWinControl do
   Parent:= Parent.Owner as TWinControl;
  WControl:=AControl;
  Caption:='ExtPopUp';
  ReadOnly:=true;
  Options:=AOptions;
  Options:=Options - [dgEditing];
  Anchors:=[akLeft, akRight, akTop, akBottom];
  Height:=DefaultRowHeight * ARowCount;
  if AWidth > 0 Then
    Width:=AWidth;
  with PopupOrigin do
   Begin
     if Parent=AControl.Parent
      Then
       Begin
        x:=AControl.Left;
        y:=AControl.Height + AControl.Top;
       end
      Else
     {$IFDEF LINUX}
       PopupOrigin:=Parent.ScreenToClient(AControl.Parent.ControlToScreen(Point(AControl.Left, AControl.Height + AControl.Top)));
     {$ELSE}
       PopupOrigin:=Parent.ScreenToClient(TCustomControl(AOwner).ControlToScreen(Point(0, TCustomControl(AOwner).Height)));
     {$ENDIF}

     if y+Height>Parent.ClientHeight Then
      dec(y,AControl.Height+Height);
     if x>Parent.ClientWidth Then
      x:=Parent.ClientWidth-Width;
     Top:=y;
     Left:=x;
   end;
end;

// clik event of datasearch popup
procedure TExtPopupGrid.Click;
begin
 (WControl as ISearchEdit).ClosePopupEvent;
 Visible:=False;
end;

procedure TExtPopupGrid.SetLookupDisplayIndex(const AValue: integer);
begin
  FLookupDisplayIndex:=AValue;
  if FLookupDisplayIndex > -1
   Then FLookupDisplayField:=Columns[FLookupDisplayIndex].FieldName
   Else FLookupDisplayField:='';
end;

{ functions }


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

function fb_SearchLocating(var FPopup : TExtPopupGrid; var FSearchVisible : Boolean;
                           const AControl : TCustomEdit ; const FSearchSource : TFieldDataLink;
                           const FTextSeparator : String ; const AOptions : TDBGridOptions;
                           const ALookupDisplayIndex : Integer; const ARowCount,AWidth :Word;
                           const FSearchList,FWidths : String ;const FFieldSeparator:Char ):Boolean;
var li_pos : Integer;
    ls_temp : String;
begin
  if not FSearchVisible Then
   Begin
    p_ShowPopup(FPopup,AControl,FSearchSource,FSearchList,FWidths,ALookupDisplayIndex,ARowCount,AWidth,AOptions,FFieldSeparator);
    FSearchVisible:=assigned ( FPopup ) and FPopup.Visible;
   end;
  if not FPopup.Focused Then
  with AControl do
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
      Text      := ls_temp; // c'est en affectant le texte que l'on passe en mode édition
      SelStart  := li_pos ;
      SelLength := length ( ls_temp ) - li_pos ;
      Result    := length ( ls_temp )=li_pos;
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
    VK_DOWN:
    Begin
      if assigned ( APopup )
      and APopup.Visible Then
       APopup.SetFocus;
      Result:=False;
    End;
  end;
End;

end.


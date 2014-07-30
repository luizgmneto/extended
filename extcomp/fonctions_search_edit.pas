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
      function ListLines:Integer;
      function ListUp:Boolean;
     End;

  { TExtPopUpGrid }

  TExtPopUpGrid = class(TDBGrid)
  private
    FLookupDisplayIndex: integer;
    FLookupDisplayField:string;
    procedure SetLookupDisplayIndex(const AValue: integer);
  protected
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    property LookupDisplayIndex:integer read FLookupDisplayIndex write SetLookupDisplayIndex;
  end;


  { TExtDBPopup }

  { TExtPopUpForm }

  TExtPopUpForm = class (TForm)
  private
    FGrid:TExtPopUpGrid;
    FRowCount:word;
    WControl:TWinControl;
    function GetLookupDisplayIndex: integer;
    procedure SetLookupDisplayIndex(const AValue: integer);
  protected
    procedure Deactivate; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure GridClickEvent(Column: TColumn); virtual;
    procedure Paint;override;
    procedure CreateWnd;override;
    property  Control:TWinControl read WControl;
  public
    procedure DoClose(var CloseAction: TCloseAction); override;
    procedure Click; override;
    constructor CreatePopUp(const AOwner: TComponent;
      const AOptions : TDBGridOptions;const ARowCount:word); virtual;
    destructor Destroy; override;
    procedure DoSetFieldsFromString(FL,FWidths:string;const AFieldSeparator:Char); virtual;
    property LookupDisplayCount:Word read FRowCount write FRowCount;
    property LookupDisplayIndex:integer read GetLookupDisplayIndex write SetLookupDisplayIndex;
  end;

function fb_KeyUp ( const AEdit : TCustomEdit ;var Key : Word ; var Alocated, ASet : Boolean; const APopup : TCustomControl ):Boolean;
function fb_SearchLocating(var FPopup : TExtPopUpForm; var FSearchVisible : Boolean;
                           const AControl : TCustomEdit ; const FSearchSource : TFieldDataLink;
                           const FTextSeparator : String ; const AOptions : TDBGridOptions;
                           const ALookupDisplayIndex : Integer; const ARowCount :Word;
                           const FSearchList,FWidths : String ;const FFieldSeparator:Char ):Boolean;
function fb_SearchText(const AEdit : TCustomEdit ; const FSearchSource : TFieldDataLink;
                       const FSearchFiltered : Boolean; const FTextSeparator : String ):Boolean;
procedure p_ShowPopup(var FPopup : TExtPopUpForm;const AControl : TWinControl;
                      const FSearchSource : TFieldDataLink;const FSearchList,FWidths : String;
                      const ALookupDisplayIndex : Integer; const ARowCount :Word;
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
procedure p_ShowPopup(var FPopup : TExtPopUpForm;const AControl : TWinControl;
                      const FSearchSource : TFieldDataLink;const FSearchList,FWidths : String;
                      const ALookupDisplayIndex : Integer; const ARowCount :Word;
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
          FPopup:=TExtPopUpForm.CreatePopUp(AControl, AOptions,ARowCount);
          FPopup.FGrid.Datasource:=FSearchSource.Datasource;
          FPopup.LookupDisplayIndex:=ALookupDisplayIndex;

          FPopup.WControl:=AControl;

          if Assigned(Font) then
          begin
            FPopup.FGrid.Font.Assign(Font);
          end;
          FPopup.DoSetFieldsFromString(FSearchList,FWidths,FFieldSeparator);

        end;
       FPopup.Show;
     finally
       FSearchSource.DataSet.GotoBookmark(ABookmark);
       FreeBookmark(ABookmark);
     end;
   End;
End;

{ TExtPopUpForm }

procedure TExtPopUpForm.SetLookupDisplayIndex(const AValue: integer);
begin
  FGrid.LookupDisplayIndex:=AValue;
end;

function TExtPopUpForm.GetLookupDisplayIndex: integer;
begin
  Result:=FGrid.LookupDisplayIndex;
end;

procedure TExtPopUpForm.Deactivate;
begin
  inherited Deactivate;
  Close;
end;

procedure TExtPopUpForm.KeyDown(var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_ESCAPE:Deactivate;
    VK_RETURN:begin
                Key:=0;
                Shift:=[];
                Click;
                exit;{In that case we need to exit away.}
              end;
  else
    inherited KeyDown(Key, Shift);
  end;
  FGrid.KeyDown(Key, Shift);
//  Key:=0;
  Invalidate;
end;

procedure TExtPopUpForm.GridClickEvent(Column: TColumn);
begin
  Click;
end;

procedure TExtPopUpForm.Paint;
var
  CR:TRect;
begin
  inherited Paint;
  Canvas.Pen.Color:=clWindowText;
  Canvas.Pen.Style := psSolid;
  Canvas.Rectangle(0, 0, Width-1, Height-1)
end;

procedure TExtPopUpForm.CreateWnd;
begin
  inherited CreateWnd;
  Height:=FGrid.DefaultRowHeight * FRowCount;
end;

procedure TExtPopUpForm.DoSetFieldsFromString(FL,FWidths: string;const AFieldSeparator:Char);
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
    GK:=FGrid.Columns.Add;
    GK.Field:=FGrid.DataSource.DataSet.FieldByName(FieldName);
    if ANumber > '' Then
    try
      GK.Width:=StrToInt(ANumber);
    Except
    end;
  end;
end;

procedure TExtPopUpForm.DoClose(var CloseAction: TCloseAction);
begin
  inherited DoClose(CloseAction);
  CloseAction:=caHide;
end;

constructor TExtPopUpForm.CreatePopUp(const AOwner: TComponent;
      const AOptions : TDBGridOptions;const ARowCount:word);
var
  PopupOrigin:TPoint;
begin
  inherited CreateNew(nil);
  FRowCount:=ARowCount;
  BorderStyle := bsNone;
  Caption:='ExtPopUp';
  KeyPreview:=true;
  Visible := false;
{$IFDEF LINUX}
  PopupOrigin:=TCustomControl(AOwner).Parent.ControlToScreen(Point(TCustomControl(AOwner).Left, TCustomControl(AOwner).Height + TCustomControl(AOwner).Top));
{$ELSE}
  PopupOrigin:=TCustomControl(AOwner).ControlToScreen(Point(0, TCustomControl(AOwner).Height));
{$ENDIF}
  Top:=PopupOrigin.y;
  Left:=PopupOrigin.x;

  FGrid:=TExtPopUpGrid.Create(Self);
  FGrid.Parent:=Self;
  FGrid.Visible:=True;
  FGrid.ReadOnly:=true;
  FGrid.Options:=AOptions;
  FGrid.Options:=FGrid.Options - [dgEditing];
  FGrid.OnCellClick:={$IFDEF DELPHI}@{$ENDIF}GridClickEvent;
  FGrid.Top:=1;
  FGrid.Left:=1;
  FGrid.Width:=Width - 3;
  FGrid.Height:=Height - 3;
  FGrid.Anchors:=[akLeft, akRight, akTop, akBottom];
end;

destructor TExtPopUpForm.Destroy;
begin
  FGrid.DataSource:=nil;
  inherited Destroy;
end;
{ TExtPopUpForm }

// clik event of datasearch popup
procedure TExtPopUpForm.Click;
begin
 (WControl as ISearchEdit).ClosePopupEvent;
 Close;
end;


{ TExtPopUpGrid }

procedure TExtPopUpGrid.SetLookupDisplayIndex(const AValue: integer);
begin
  FLookupDisplayIndex:=AValue;
  if FLookupDisplayIndex > -1
   Then FLookupDisplayField:=Columns[FLookupDisplayIndex].FieldName
   Else FLookupDisplayField:='';
end;

procedure TExtPopUpGrid.KeyDown(var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
    Click
  else
    inherited KeyDown(Key, Shift);
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

function fb_SearchLocating(var FPopup : TExtPopUpForm; var FSearchVisible : Boolean;
                           const AControl : TCustomEdit ; const FSearchSource : TFieldDataLink;
                           const FTextSeparator : String ; const AOptions : TDBGridOptions;
                           const ALookupDisplayIndex : Integer; const ARowCount :Word;
                           const FSearchList,FWidths : String ;const FFieldSeparator:Char ):Boolean;
var li_pos : Integer;
    ls_temp : String;
begin
  p_ShowPopup(FPopup,AControl,FSearchSource,FSearchList,FWidths,ALookupDisplayIndex,ARowCount,AOptions,FFieldSeparator);
  FSearchVisible:=assigned ( FPopup ) and FPopup.Visible;
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
      Text      := ls_temp ; // c'est en affectant le texte que l'on passe en mode édition
      SelStart  := li_pos ;
      writeln ( 'selection '+ls_temp+' '+SelText+' '+ IntTostr(SelStart) + ' ' + IntTostr(SelLength));
      SelLength := length ( ls_temp ) - li_pos ;
      writeln ( 'selection '+ls_temp+' '+SelText+' '+ IntTostr(SelStart) + ' ' + IntTostr(SelLength));
      Result    := length ( ls_temp )=li_pos;
      writeln ( 'selection '+ls_temp+' '+SelText+' '+ IntTostr(SelStart) + ' ' + IntTostr(SelLength));
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


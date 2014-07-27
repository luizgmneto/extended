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
     {$IFDEF RX}
     RxDBGrid,
     RxPopUpUnit,
     vclutils,
     {$ELSE}
     {$ENDIF}
     Graphics, DB,DBCtrls,
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
                                          Major : 1 ; Minor : 3 ; Release : 0 ; Build : 0 );

{$ENDIF}
  SEARCHEDIT_GRID_DEFAULTS = [dgColumnResize, dgRowSelect, dgColLines, dgConfirmDelete, dgCancelOnExit, dgTabs, dgAlwaysShowSelection];
  SEARCHEDIT_GRID_DEFAULT_SCROLL = {$IFDEF FPC}ssAutoBoth{$ELSE}ssBoth{$ENDIF};

type ISearchEdit = interface
      ['{34886DAB-F444-41A9-9F76-347109C99273}']
      procedure Locating;
      procedure NotFound;
      procedure SearchText;
      procedure ValidateSearch;
      procedure ClosePopupEvent;
      procedure FreePopup;
      procedure SetEvent ;
      function GetFieldSearch: String;
      function ListLines:Integer;
      function ListUp:Boolean;
     End;
  { TPopUpGrid }

  { TExtPopUpGrid }

  TExtPopUpGrid = class(TPopUpGrid)
  public
    procedure SetDBHandlers(Value: boolean);override;
    procedure UTF8KeyPress(var UTF8Key: TUTF8Char); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    property LookupDisplayIndex;
  end;

  { TPopUpForm }
  TPopUpForm = class (TForm)
  private
    FFindResult:boolean;
    FGrid:TExtPopUpGrid;
    FDataSource:TDataSource;
    FOnPopUpCloseEvent:TPopUpCloseEvent;
    FPopUpFormOptions:TPopUpFormOptions;
    FRowCount:word;
    WControl:TWinControl;
    function GetDataSet: TDataSet;
    function GetLookupDisplayIndex: integer;
    procedure SetDataSet(const AValue: TDataSet);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure SetLookupDisplayIndex(const AValue: integer);
  protected
    FFieldList:string;
    procedure KeyUp(var Key: Word; Shift: TShiftState); override;
    procedure Deactivate; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure GridDblClick(Sender: TObject); virtual;
    procedure GridClickEvent(Column: TColumn); virtual;
    procedure CloseOk; virtual;
    procedure Paint;override;
    procedure CreateWnd;override;
    //
    procedure DoSetFieldsFromString(FL:string); virtual;
    procedure DoSetFieldsFromColList; virtual;
    property  Control:TWinControl read WControl;
  public
    procedure Click; override;
    procedure UTF8KeyPress(var UTF8Key: TUTF8Char); override;
    constructor CreatePopUp(const AOwner: TComponent;
      const APopUpFormOptions:TPopUpFormOptions; const AFieldList:string); virtual;
    destructor Destroy; override;
    property DataSet:TDataSet read GetDataSet write SetDataSet;
    property LookupDisplayIndex:integer read GetLookupDisplayIndex write SetLookupDisplayIndex;
  end;


function fb_SearchText(const AEdit : TCustomEdit ; const FSearchSource : TFieldDataLink;
                       const FSearchFiltered : Boolean; const FTextSeparator : String ):Boolean;
function fb_KeyUp ( const AEdit : TCustomEdit ;var Key : Word ; var Alocated, ASet : Boolean; const APopup : TCustomControl ):Boolean;
function fb_SearchLocating(var FPopup : TPopUpForm; const APopUpFormOptions:TPopUpFormOptions;
                           const AControl : TCustomEdit ; const FSearchSource : TFieldDataLink;
                           const FTextSeparator : String ; const FSearchList : String ;
                           const FFieldSeparator : Char; const FListWidth,ALookupDisplayIndex : Integer ):Boolean;
procedure p_ShowPopup(var FPopup : TPopUpForm;const AControl : TWinControl; const APopUpFormOptions:TPopUpFormOptions;
                      const FSearchSource : TFieldDataLink; const FSearchList : String ;
                      const FFieldSeparator : Char; const FListWidth,ALookupDisplayIndex : Integer );

implementation

uses
     fonctions_db,
     fonctions_proprietes,
     sysutils;

{ TExtPopUpGrid }

procedure TExtPopUpGrid.SetDBHandlers(Value: boolean);
begin
  inherited SetDBHandlers(Value);
end;

procedure TExtPopUpGrid.UTF8KeyPress(var UTF8Key: TUTF8Char);
begin
  inherited UTF8KeyPress(UTF8Key);
end;

procedure TExtPopUpGrid.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited KeyDown(Key, Shift);
end;

{ TListPopup }

procedure TPopUpForm.KeyUp(var Key: Word; Shift: TShiftState);
begin
  inherited KeyUp(Key, Shift);
  case Key of
    VK_ESCAPE : Visible:=False;
    VK_RETURN : Click;
    end;
end;

// clik event of datasearch popup
procedure TPopUpForm.Click;
begin
  (WControl as ISearchEdit).ClosePopupEvent;
 Visible:=False;
end;

{ TPopUpForm }
procedure TPopUpForm.SetDataSet(const AValue: TDataSet);
begin
  if FDataSource.DataSet=AValue then exit;
  FDataSource.DataSet:=AValue;
  if FPopUpFormOptions.Columns.Count>0 then
    DoSetFieldsFromColList
  else
    DoSetFieldsFromString(FFieldList);
end;


procedure TPopUpForm.SetLookupDisplayIndex(const AValue: integer);
begin
  FGrid.LookupDisplayIndex:=AValue;
end;

function TPopUpForm.GetDataSet: TDataSet;
begin
  Result:=FDataSource.DataSet;
end;

function TPopUpForm.GetLookupDisplayIndex: integer;
begin
  Result:=FGrid.LookupDisplayIndex;
end;

procedure TPopUpForm.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  CloseAction:=caFree;
  if (ModalResult <> mrOk) and Assigned(FOnPopUpCloseEvent) then
    FOnPopUpCloseEvent(FFindResult);
end;

procedure TPopUpForm.Deactivate;
begin
  inherited Deactivate;
  if (ModalResult = mrOk) and Assigned(FOnPopUpCloseEvent) then
    FOnPopUpCloseEvent(FFindResult);
  Close;
end;

procedure TPopUpForm.KeyDown(var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_ESCAPE:Deactivate;
    VK_RETURN:begin
                Key:=0;
                Shift:=[];
                CloseOk;
                exit;{In that case we need to exit away.}
              end;
  else
    inherited KeyDown(Key, Shift);
  end;
  FGrid.KeyDown(Key, Shift);
//  Key:=0;
  Invalidate;
end;

procedure TPopUpForm.UTF8KeyPress(var UTF8Key: TUTF8Char);
begin
  inherited UTF8KeyPress(UTF8Key);
  FGrid.UTF8KeyPress(UTF8Key);
end;

procedure TPopUpForm.GridDblClick(Sender: TObject);
begin
  CloseOk;
  Click;
end;

procedure TPopUpForm.GridClickEvent(Column: TColumn);
begin
  CloseOk;
  Click;
end;

procedure TPopUpForm.CloseOk;
begin
  FFindResult:=true;
{$IFDEF LINUX}
  ModalResult:=mrOk;
{$ELSE LINUX}
  Deactivate;
{$ENDIF LINUX}
end;

procedure TPopUpForm.Paint;
var
  CR:TRect;
begin
  inherited Paint;
  if FPopUpFormOptions.BorderStyle<>bsNone then
  begin
    CR:=ClientRect;
    RxFrame3D(Canvas, CR, clBtnHighlight, clWindowFrame, 1);
    RxFrame3D(Canvas, CR, clBtnFace, clBtnShadow, 1);
  end
  else
  begin
    Canvas.Pen.Color:=clWindowText;
    Canvas.Pen.Style := psSolid;
    Canvas.Rectangle(0, 0, Width-1, Height-1)
  end;
end;

procedure TPopUpForm.CreateWnd;
begin
  inherited CreateWnd;
  Height:=FGrid.DefaultRowHeight * FRowCount;
end;

procedure TPopUpForm.DoSetFieldsFromString(FL: string);
var
  FieldName:string;
  GK:TRxColumn;
  K:integer;
begin
  while (FL<>'') do
  begin
    K:=Pos(';', FL);
    if K<>0 then
    begin
      FieldName:=Copy(FL, 1, K-1);
      Delete(FL, 1, K);
    end
    else
    begin
      FieldName:=FL;
      FL:='';
    end;
    GK:=FGrid.Columns.Add as TRxColumn;
    GK.Field:=FGrid.DataSource.DataSet.FieldByName(FieldName);
  end;
end;

procedure TPopUpForm.DoSetFieldsFromColList;
var
  GK:TRxColumn;
  i:integer;
  Column:TPopUpColumn;
begin
  FGrid.BeginUpdate;
  for i:=0 to FPopUpFormOptions.Columns.Count - 1 do
  begin
    GK:=FGrid.Columns.Add as TRxColumn;
    Column:=FPopUpFormOptions.Columns[i];
    GK.Field:=FGrid.DataSource.DataSet.FieldByName(Column.FieldName);
    GK.Alignment:=Column.Alignment;
    GK.Color:=Column.Color;
    GK.DisplayFormat:=Column.DisplayFormat;
//    GK.Font:=Column.Font;
    GK.ImageList:=Column.ImageList;
    GK.SizePriority:=Column.SizePriority;
    GK.ValueChecked:=Column.ValueChecked;
    GK.ValueUnchecked:=Column.ValueUnchecked;

    if Column.Width<>0 then
      GK.Width:=Column.Width;

    GK.Title.Color:=Column.Title.Color;
    (GK.Title as TRxColumnTitle).Orientation:=Column.Title.Orientation;
    GK.Title.Alignment:=Column.Title.Alignment;
    GK.Title.Layout:=Column.Title.Layout;
    GK.Title.Caption:=Column.Title.Caption;
  end;
  FGrid.EndUpdate;
end;

constructor TPopUpForm.CreatePopUp(const AOwner: TComponent;
      const APopUpFormOptions:TPopUpFormOptions; const AFieldList:string);
var
  PopupOrigin:TPoint;
begin
  inherited CreateNew(nil);
//  inherited Create(AOwner);
  BorderStyle := bsNone;
  Caption:='ExtPopUp';
  KeyPreview:=true;
  Visible := false;
  FDataSource:=TDataSource.Create(Self);
  FPopUpFormOptions:=APopUpFormOptions;
  FFieldList:=AFieldList;
  OnClose := {$IFDEF DELPHI}@{$ENDIF}FormClose;

{$IFDEF LINUX}
  PopupOrigin:=TCustomControl(AOwner).Parent.ControlToScreen(Point(TCustomControl(AOwner).Left, TCustomControl(AOwner).Height + TCustomControl(AOwner).Top));
{$ELSE}
  PopupOrigin:=TCustomControl(AOwner).ControlToScreen(Point(0, TCustomControl(AOwner).Height));
{$ENDIF}
  Top:=PopupOrigin.y;
  Left:=PopupOrigin.x;

  if FPopUpFormOptions.DropDownWidth = 0 then
    Width:=TCustomControl(AOwner).Width
  else
    Width:=FPopUpFormOptions.DropDownWidth;

  FGrid:=TExtPopUpGrid.Create(Self);
  FGrid.Parent:=Self;
  FGrid.ReadOnly:=true;
  FGrid.Options:=FGrid.Options - [dgEditing];
  FGrid.DataSource:=FDataSource;
  FGrid.OnDblClick:={$IFDEF DELPHI}@{$ENDIF}GridDblClick;
  FGrid.OnCellClick:={$IFDEF DELPHI}@{$ENDIF}GridClickEvent;
  if FPopUpFormOptions.BorderStyle = bsSingle then
  begin
    FGrid.Top:=2;
    FGrid.Left:=2;
    FGrid.Width:=Width - 4;
    FGrid.Height:=Height - 4;
    FGrid.Anchors:=[akLeft, akRight, akTop, akBottom];
  end
  else
  begin
    FGrid.Top:=1;
    FGrid.Left:=1;
    FGrid.Width:=Width - 3;
    FGrid.Height:=Height - 3;
    FGrid.Anchors:=[akLeft, akRight, akTop, akBottom];
  end;
  //Set options
  if not (pfgIndicator in FPopUpFormOptions.Options) then
  begin
    FGrid.Options:=FGrid.Options - [dgIndicator];
    FGrid.FixedCols:=0;
  end;

  if not (pfgColLines in FPopUpFormOptions.Options) then
    FGrid.Options:=FGrid.Options - [dgColLines];

  if not (pfgRowLines in FPopUpFormOptions.Options) then
    FGrid.Options:=FGrid.Options - [dgRowLines];

  if not (pfgColumnResize in FPopUpFormOptions.Options) then
    FGrid.Options:=FGrid.Options - [dgColumnResize];

  if not (pfgColumnMove in FPopUpFormOptions.Options) then
    FGrid.Options:=FGrid.Options - [dgColumnMove];

  if FPopUpFormOptions.ShowTitles then
    FGrid.Options:=FGrid.Options + [dgTitles]
  else
    FGrid.Options:=FGrid.Options - [dgTitles];

  FGrid.AutoSort:=FPopUpFormOptions.AutoSort;
  FGrid.TitleButtons:=FPopUpFormOptions.TitleButtons;
  FGrid.TitleStyle:=FPopUpFormOptions.TitleStyle;
  FGrid.BorderStyle:=FPopUpFormOptions.BorderStyle;
  FGrid.OnGetCellProps:=FPopUpFormOptions.OnGetCellProps;
  FGrid.AutoFillColumns:=FPopUpFormOptions.AutoFillColumns;
  if FPopUpFormOptions.DropDownCount < 1 then
    FRowCount:=10 + ord(dgTitles in FGrid.Options)
  else
    FRowCount:=FPopUpFormOptions.DropDownCount + 2 + ord(dgTitles in FGrid.Options);
end;

destructor TPopUpForm.Destroy;
begin
  FGrid.DataSource:=nil;
  inherited Destroy;
end;

{ functions }

// show popup
procedure p_ShowPopup(var FPopup : TPopUpForm;const AControl : TWinControl; const APopUpFormOptions:TPopUpFormOptions;
                      const FSearchSource : TFieldDataLink; const FSearchList : String ;
                      const FFieldSeparator : Char; const FListWidth,ALookupDisplayIndex : Integer );
var i : Integer;
    ABookmark:TBookmark;
Begin
  with AControl,FSearchSource.DataSet do
  if  ( RecordCount > 1 )
  and ( FSearchList <> '' ) Then
   Begin
     ABookmark:=FSearchSource.DataSet.GetBookmark;
     try
       if not Assigned( FPopup ) Then
        Begin
          FPopup:=TPopUpForm.CreatePopUp(AControl, APopUpFormOptions, FSearchList);
          FPopup.DataSet:=FSearchSource.DataSet;
          FPopup.LookupDisplayIndex:=ALookupDisplayIndex;

          FPopup.WControl:=AControl;

          if Assigned(Font) then
          begin
            FPopup.FGrid.Font.Assign(Font);
          end;             end;
       FPopup.Show;
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

function fb_SearchLocating(var FPopup : TPopUpForm; const APopUpFormOptions:TPopUpFormOptions;
                           const AControl : TCustomEdit ; const FSearchSource : TFieldDataLink;
                           const FTextSeparator : String ; const FSearchList : String ;
                           const FFieldSeparator : Char; const FListWidth,ALookupDisplayIndex : Integer ):Boolean;
var li_pos : Integer;
    ls_temp : String;
begin
  p_ShowPopup(FPopup,AControl,APopUpFormOptions,FSearchSource,FSearchList,FFieldSeparator,FListWidth,ALookupDisplayIndex);
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


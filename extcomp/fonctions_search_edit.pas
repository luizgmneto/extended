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

type ISearchEdit = interface
      ['{34886DAB-F444-41A9-9F76-347109C99273}']
      procedure Locating;
      procedure NotFound;
      procedure p_SearchText;
      procedure ValidateSearch;
      function CanModify:Boolean;
      procedure  SelectKeyValue(ListValue:String);
      procedure ClosePopupEvent;
      procedure ListMouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
      procedure FreePopup;
      procedure SetEvent ;
      function GetFieldSearch: String;
      function ListLines:Integer;
      function ListUp:Boolean;
     End;

  { TExtPopUpGrid }

  TExtPopUpGrid = class(TDBGrid)
  private
    FFindLine:string;
    FLookupDisplayIndex: integer;
    FLookupDisplayField:string;
    procedure ClearFind;
    procedure FindNextChar(var UTF8Key: TUTF8Char);
    procedure FindPriorChar;
    procedure SetLookupDisplayIndex(const AValue: integer);
  protected
    procedure UTF8KeyPress(var UTF8Key: TUTF8Char); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    property LookupDisplayIndex:integer read FLookupDisplayIndex write SetLookupDisplayIndex;
  public
    procedure Click;override;
  end;


  { TExtDBPopup }

  { TExtPopUpForm }

  TExtPopUpForm = class (TForm)
  private
    FFindResult:boolean;
    FGrid:TExtPopUpGrid;
    FDataSource:TDataSource;
    FRowCount:word;
    WControl:TWinControl;
    function GetDataSet: TDataSet;
    function GetLookupDisplayIndex: integer;
    procedure SetDataSet(const AValue: TDataSet);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure SetLookupDisplayIndex(const AValue: integer);
  protected
    FFieldList,FWidths:string;
    FFieldSeparator:Char;
    procedure KeyUp(var Key: Word; Shift: TShiftState); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure Deactivate; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure GridClickEvent(Column: TColumn); virtual;
    procedure CloseOk; virtual;
    procedure Paint;override;
    procedure CreateWnd;override;
    //
    procedure DoSetFieldsFromString(FL,FWidths:string); virtual;
    property  Control:TWinControl read WControl;
  public
    procedure DoClose(var CloseAction: TCloseAction); override;
    procedure Click; override;
    procedure UTF8KeyPress(var UTF8Key: TUTF8Char); override;
    constructor CreatePopUp(const AOwner: TComponent;
      const AFieldList,AWidths:string ;const AOptions : TDBGridOptions;const AFieldSeparator : Char = SEARCHEDIT_DEFAULT_FIELD_SEPARATOR); virtual;
    destructor Destroy; override;
    property DataSet:TDataSet read GetDataSet write SetDataSet;
    property LookupDisplayIndex:integer read GetLookupDisplayIndex write SetLookupDisplayIndex;
  end;

function fb_KeyUp ( const AEdit : TCustomEdit ;var Key : Word ; var Alocated, ASet : Boolean; const APopup : TCustomControl ):Boolean;
function fb_SearchLocating(var FPopup : TExtPopUpForm;
                           const AControl : TCustomEdit ; const FSearchSource : TFieldDataLink;
                           const FTextSeparator : String ; const AOptions : TDBGridOptions;const FSearchList,FWidths : String ;const FFieldSeparator:Char ):Boolean;
function fb_SearchText(const AEdit : TCustomEdit ; const FSearchSource : TFieldDataLink;
                       const FSearchFiltered : Boolean; const FTextSeparator : String ):Boolean;
procedure p_ShowPopup(var FPopup : TExtPopUpForm;const AControl : TWinControl;
                      const FSearchSource : TFieldDataLink;const FSearchList,FWidths : String; const AOptions : TDBGridOptions;const FFieldSeparator:Char );
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
                      const FSearchSource : TFieldDataLink;const FSearchList,FWidths : String; const AOptions : TDBGridOptions ;const FFieldSeparator:Char);
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
          FPopup:=TExtPopUpForm.CreatePopUp(AControl, FSearchList,FWidths,AOptions);
          FPopup.DataSet:=FSearchSource.DataSet;
      //    FPopup.LookupDisplayIndex:=ALookupDisplayIndex;

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

{ TExtPopUpForm }
procedure TExtPopUpForm.SetDataSet(const AValue: TDataSet);
begin
  if FDataSource.DataSet=AValue then exit;
  FDataSource.DataSet:=AValue;
  DoSetFieldsFromString(FFieldList,FWidths);
end;


procedure TExtPopUpForm.SetLookupDisplayIndex(const AValue: integer);
begin
  FGrid.LookupDisplayIndex:=AValue;
end;

function TExtPopUpForm.GetDataSet: TDataSet;
begin
  Result:=FDataSource.DataSet;
end;

function TExtPopUpForm.GetLookupDisplayIndex: integer;
begin
  Result:=FGrid.LookupDisplayIndex;
end;

procedure TExtPopUpForm.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  CloseAction:=caHide;
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

procedure TExtPopUpForm.UTF8KeyPress(var UTF8Key: TUTF8Char);
begin
  inherited UTF8KeyPress(UTF8Key);
  FGrid.UTF8KeyPress(UTF8Key);
end;

procedure TExtPopUpForm.GridClickEvent(Column: TColumn);
begin
  CloseOk;
  Click;
end;

procedure TExtPopUpForm.CloseOk;
begin
  FFindResult:=true;
{$IFDEF LINUX}
  ModalResult:=mrOk;
{$ELSE LINUX}
  Deactivate;
{$ENDIF LINUX}
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

procedure TExtPopUpForm.DoSetFieldsFromString(FL,FWidths: string);
var
  FieldName:string;
  GK:TColumn;
  K:integer;
  ANumber : String;
begin
  while (FL<>'') do
  begin
    K:=Pos(FFieldSeparator, FL);
    if K>0 then
    begin
      FieldName:=Copy(FL, 1, K-1);
      Delete(FL, 1, K);
      K:=Pos(FFieldSeparator, FWidths);
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
      const AFieldList,AWidths:string;const AOptions : TDBGridOptions;const AFieldSeparator : Char = SEARCHEDIT_DEFAULT_FIELD_SEPARATOR);
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
  FFieldList:=AFieldList;
  FWidths:=AWidths;
  FFieldSeparator:=AFieldSeparator;
  OnClose := {$IFDEF DELPHI}@{$ENDIF}FormClose;

{$IFDEF LINUX}
  PopupOrigin:=TCustomControl(AOwner).Parent.ControlToScreen(Point(TCustomControl(AOwner).Left, TCustomControl(AOwner).Height + TCustomControl(AOwner).Top));
{$ELSE}
  PopupOrigin:=TCustomControl(AOwner).ControlToScreen(Point(0, TCustomControl(AOwner).Height));
{$ENDIF}
  Top:=PopupOrigin.y;
  Left:=PopupOrigin.x;

  FGrid:=TExtPopUpGrid.Create(Self);
  FGrid.Parent:=Self;
  FGrid.ReadOnly:=true;
  FGrid.Options:=FGrid.Options - [dgEditing];
  FGrid.DataSource:=FDataSource;
  FGrid.OnCellClick:={$IFDEF DELPHI}@{$ENDIF}GridClickEvent;
  FGrid.Top:=1;
  FGrid.Left:=1;
  FGrid.Width:=Width - 3;
  FGrid.Height:=Height - 3;
  FGrid.Anchors:=[akLeft, akRight, akTop, akBottom];

  FGrid.Options:=AOptions;
end;

destructor TExtPopUpForm.Destroy;
begin
  FGrid.DataSource:=nil;
  inherited Destroy;
end;

procedure TExtPopUpForm.MouseUp(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  (Parent as ISearchEdit).ListMouseUp(Button, Shift, X, Y);
end;

{ TExtPopUpForm }

procedure TExtPopUpForm.KeyUp(var Key: Word; Shift: TShiftState);
begin
  inherited KeyUp(Key, Shift);
  case Key of
    VK_ESCAPE : Visible:=False;
    VK_RETURN : Click;
    end;
end;

// clik event of datasearch popup
procedure TExtPopUpForm.Click;
begin
 (WControl as ISearchEdit).ClosePopupEvent;
 Visible:=False;
end;


{ TExtPopUpGrid }

procedure TExtPopUpGrid.ClearFind;
begin
  TExtPopUpForm(Owner).WControl.Caption:=' ';
  TExtPopUpForm(Owner).WControl.Repaint;
  FFindLine:='';
end;

procedure TExtPopUpGrid.FindNextChar(var UTF8Key: TUTF8Char);
var
  F:TField;
  V:boolean;
begin
  if Datalink.Active then
  begin
    F:=Columns[FLookupDisplayIndex].Field;
    if F.DataType in StringTypes then
      V:=true
    else
    begin
      if Length(UTF8Key) = 1 then
        V:=F.IsValidChar(UTF8Key[1])
      else
        V:=false;
    end;
    if V then
    begin
      if DataSetLocateThrough(DataSource.DataSet, FLookupDisplayField, FFindLine + UTF8Key, [loCaseInsensitive, loPartialKey]) then
      begin
//        TExtPopUpForm(Owner).WControl.Caption:=FFindLine;
//        TExtPopUpForm(Owner).WControl.Repaint;
      end;

      FFindLine:=FFindLine + UTF8Key;
      TExtPopUpForm(Owner).WControl.Caption:=FFindLine;
      TExtPopUpForm(Owner).WControl.Repaint;
    end;
    UTF8Key:='';
  end;
end;

procedure TExtPopUpGrid.FindPriorChar;
var
  F:string;
begin
  if (FFindLine = '') or (not Datalink.Active) then exit;
  F:=FFindLine;
  UTF8Delete(FFindLine, UTF8Length(FFindLine), 1);
  if (FFindLine<>'') then
  begin
    if DataSetLocateThrough(DataSource.DataSet, FLookupDisplayField, FFindLine, [loCaseInsensitive, loPartialKey]) then
    begin
//     TExtPopUpForm(Owner).WControl.Caption:=FFindLine;
//     TExtPopUpForm(Owner).WControl.Repaint;
    end;
//    else
//      FFindLine:=F;

    //FFindLine:=FFindLine + UTF8Key;
    TExtPopUpForm(Owner).WControl.Caption:=FFindLine;
    TExtPopUpForm(Owner).WControl.Repaint;

  end
  else
  begin
    TExtPopUpForm(Owner).WControl.Caption:=' ';
    TExtPopUpForm(Owner).WControl.Repaint;
    DataSource.DataSet.First;
  end;
end;

procedure TExtPopUpGrid.SetLookupDisplayIndex(const AValue: integer);
begin
  FLookupDisplayIndex:=AValue;
  FLookupDisplayField:=Columns[FLookupDisplayIndex].FieldName;
end;

procedure TExtPopUpGrid.UTF8KeyPress(var UTF8Key: TUTF8Char);
begin
  inherited UTF8KeyPress(UTF8Key);
  if UTF8Key>=#32 then
    FindNextChar(UTF8Key)
  else
  if UTF8Key = #8 then
    ClearFind
  else
    exit;
  UTF8Key:='';
end;

procedure TExtPopUpGrid.KeyDown(var Key: Word; Shift: TShiftState);
begin
  if Key = VK_DELETE then
  begin
    ClearFind;
    Key:=0;
  end
  else
  if Key = VK_BACK then
  begin
    FindPriorChar;
    Key:=0;
  end
  else
  if Key = VK_RETURN then
    Click
  else
  begin
    if Key in [VK_UP,VK_DOWN,VK_PRIOR,VK_NEXT] then
    begin
      FFindLine:='';
      TExtPopUpForm(Owner).WControl.Caption:='';
      TExtPopUpForm(Owner).WControl.Repaint;
    end;
    inherited KeyDown(Key, Shift);
  end;
end;

procedure TExtPopUpGrid.Click;
begin
  inherited Click;
  (Owner as TExtPopUpForm).Click;
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

function fb_SearchLocating(var FPopup : TExtPopUpForm;
                           const AControl : TCustomEdit ; const FSearchSource : TFieldDataLink;
                           const FTextSeparator : String ; const AOptions : TDBGridOptions;const FSearchList,FWidths : String ;const FFieldSeparator:Char):Boolean;
var li_pos : Integer;
    ls_temp : String;
begin
  p_ShowPopup(FPopup,AControl,FSearchSource,FSearchList,FWidths,AOptions,FFieldSeparator);
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


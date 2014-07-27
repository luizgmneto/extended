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
      procedure CloseUp(Accept: Boolean);
      procedure SetEvent ;
      function GetFieldSearch: String;
      function ListLines:Integer;
      function ListUp:Boolean;
     End;
  { TPopUpGrid }


  { TPopUpForm }
  TExtDBPopup = class ({$IFDEF FPC}TDBLookup{$ELSE}TPopupDataList{$ENDIF} )
  protected
    procedure KeyUp(var Key: Word; Shift: TShiftState); override;
    procedure MouseUp(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);override;

  public
    procedure Click; override;
  end;


function fb_SearchText(const AEdit : TCustomEdit ; const FSearchSource : TFieldDataLink;
                       const FSearchFiltered : Boolean; const FTextSeparator : String ):Boolean;
function fb_KeyUp ( const AEdit : TCustomEdit ;var Key : Word ; var Alocated, ASet : Boolean; const APopup : TCustomControl ):Boolean;
function fb_SearchLocating(var FPopup : TExtDBPopup;
                           const AControl : TCustomEdit ; const FSearchSource : TFieldDataLink;
                           const FTextSeparator : String ; const FSearchList : String  ):Boolean;
function fpdl_CreateLookup(const AParent :TWinControl):TExtDBPopup;
procedure p_LookupCloseUp(const FDataList:TExtDBPopup;var SearchText : String;const FOnCloseUp: TNotifyEvent;var FListVisible,Accept: Boolean);
implementation

uses
     fonctions_db,
     fonctions_proprietes,
     Variants,
     sysutils;

procedure p_LookupDropDown(const FDataList:TExtDBPopup;var SearchText : String;
                           const FOnDropDown :TNotifyEvent; const FDropDownAlign:TDropDownAlign;
                           var FListVisible,Accept,ListActive: Boolean;
                           var FListDataChanging,FDropDownWidth,FDropDownRows,FListFieldIndex :Integer;
                           const FKeyFieldName: String;const FListFields: TList;
                           const FListField: TField;
                           const AColorList:TColor);
var
  P: TPoint;
  I, Y: Integer;
  S: string;
  ADropDownAlign: TDropDownAlign;
begin
  Inc(FListDataChanging);
  try
    if not FListVisible and ListActive then
    with  FDataList,Parent as TCustomEdit do
    begin
      if Assigned(FOnDropDown) then FOnDropDown(Parent);
      FDataList.Color := AColorList;
      FDataList.Font :=fobj_getComponentObjectProperty(Parent, CST_PROPERTY_FONT)as TFont;
      if FDropDownWidth > 0 then
        FDataList.Width := FDropDownWidth else
        FDataList.Width := Width;
      FDataList.ReadOnly := not CanModify;
      if (ListLink.DataSet.RecordCount > 0) and
         (FDropDownRows > ListLink.DataSet.RecordCount) then
        FDataList.RowCount := ListLink.DataSet.RecordCount else
        FDataList.RowCount := FDropDownRows;
      FDataList.KeyField := FKeyFieldName;
      for I := 0 to ListFields.Count - 1 do
        S := S + TField(ListFields[I]).FieldName + ';';
      FDataList.ListField := S;
      FDataList.ListFieldIndex := FListFields.IndexOf(FListField);
      FDataList.ListSource := ListLink.DataSource;
      FDataList.KeyValue := KeyValue;
      P := Parent.ClientToScreen(Point(Left, Top));
      Y := P.Y + Height;
      if Y + FDataList.Height > Screen.Height then Y := P.Y - FDataList.Height;
      ADropDownAlign := FDropDownAlign;
      { This alignment is for the ListField, not the control }
      if DBUseRightToLeftAlignment(FDataList.Parent, FListField) then
      begin
        if ADropDownAlign = daLeft then
          ADropDownAlign := daRight
        else if ADropDownAlign = daRight then
          ADropDownAlign := daLeft;
      end;
      case ADropDownAlign of
        daRight: Dec(P.X, FDataList.Width - Width);
        daCenter: Dec(P.X, (FDataList.Width - Width) div 2);
      end;
      SetWindowPos(FDataList.Handle, HWND_TOP, P.X, Y, 0, 0,
        SWP_NOSIZE or SWP_NOACTIVATE or SWP_SHOWWINDOW);
      FListVisible := True;
      Repaint;
    end;
  finally
    Dec(FListDataChanging);
  end;
end;

procedure p_LookupUpdateListFields(const FListLink:TListSourceLink;var SearchText : String;
                           const FOnDropDown :TNotifyEvent; const FDropDownAlign:TDropDownAlign;
                           var FListVisible,Accept,FListActive: Boolean;
                           var FListDataChanging,FDropDownWidth,FDropDownRows,FListFieldIndex :Integer;
                           const FKeyFieldName: String;const FListFields: TList;
                           var  FListField: TField);
var
  DataSet: TDataSet;
  ResultField: TField;
begin
  FListActive := False;
  FListField := nil;
  FListFields.Clear;
  if FListLink.Active and (FKeyFieldName <> '') then
  begin
    CheckNotCircular;
    DataSet := FListLink.DataSet;
    FKeyField := GetFieldProperty(DataSet, Self, FKeyFieldName);
    try
      DataSet.GetFieldList(FListFields, FListFieldName);
    except
      DatabaseErrorFmt(SFieldNotFound, [Self.Name, FListFieldName]);
    end;
    if FLookupMode then
    begin
      ResultField := GetFieldProperty(DataSet, Self, FDataField.LookupResultField);
      if FListFields.IndexOf(ResultField) < 0 then
        FListFields.Insert(0, ResultField);
      FListField := ResultField;
    end else
    begin
      if FListFields.Count = 0 then FListFields.Add(FKeyField);
      if (FListFieldIndex >= 0) and (FListFieldIndex < FListFields.Count) then
        FListField := FListFields[FListFieldIndex] else
        FListField := FListFields[0];
    end;
    FListActive := True;
  end;
end;



procedure p_LookupCloseUp(const FDataList:TExtDBPopup;var SearchText : String;const FOnCloseUp: TNotifyEvent;var FListVisible,Accept: Boolean);
var
  ListValue: String;
begin
  if FListVisible then
  with FDataList.Parent as TCustomEdit do
  begin
    if GetCapture <> 0 then SendMessage(GetCapture, WM_CANCELMODE, 0, 0);
    SetFocus;
    ListValue :=VarToStr (FDataList.KeyValue);
    SetWindowPos(FDataList.Handle, 0, 0, 0, 0, 0, SWP_NOZORDER or
      SWP_NOMOVE or SWP_NOSIZE or SWP_NOACTIVATE or SWP_HIDEWINDOW);
    FListVisible := False;
    FDataList.ListSource := nil;
    Invalidate;
    SearchText := '';
    with FDataList.Parent as ISearchEdit do
      if Accept and CanModify then SelectKeyValue(ListValue);
    if Assigned(FOnCloseUp) then FOnCloseUp(FDataList.Parent);
  end;
end;



function fpdl_CreateLookup(const AParent :TWinControl):TExtDBPopup;
Begin
  Result := TExtDBPopup.Create(AParent);
  Result.Visible := False;
  Result.Parent := AParent;
 End;

{ TExtDBPopup }

procedure TExtDBPopup.KeyUp(var Key: Word; Shift: TShiftState);
begin
  inherited KeyUp(Key, Shift);
  case Key of
    VK_ESCAPE : Visible:=False;
    VK_RETURN : Click;
    end;
end;

procedure TExtDBPopup.MouseUp(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  (Parent as ISearchEdit).ListMouseUp(Button, Shift, X, Y);
end;

// clik event of datasearch popup
procedure TExtDBPopup.Click;
begin
  (Parent as ISearchEdit).ClosePopupEvent;
 Visible:=False;
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

function fb_SearchLocating(var FPopup : TExtDBPopup;
                           const AControl : TCustomEdit ; const FSearchSource : TFieldDataLink;
                           const FTextSeparator : String ; const FSearchList : String ):Boolean;
var li_pos : Integer;
    ls_temp : String;
begin
  FPopup.Show;
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


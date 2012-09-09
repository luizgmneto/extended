unit u_reports_components;

{$I ..\DLCompilers.inc}
{$I ..\extends.inc}
{$IFDEF FPC}
{$mode Delphi}
{$ENDIF}

interface

uses
{$IFNDEF FPC}
  Windows, Messages,
{$ENDIF}
  Classes,
{$IFDEF VERSIONS}
  fonctions_version,
{$ENDIF}
  DBGrids,
  u_buttons_appli, RLFilters;

{$IFDEF VERSIONS}
const
  gVer_reports_components: T_Version = (Component: 'Customized Reports Buttons';
    FileUnit: 'u_reports_components';
    Owner: 'Matthieu Giroux';
    Comment: 'Customized Reports Buttons components.';
    BugsStory :  '1.0.1.1 : Renaming DBFilter to Filter.' + #13#10
               + '1.0.1.0 : Putting resize into extdbgrid columns.' + #13#10
               + '1.0.0.0 : Tested.' + #13#10
               + '0.9.0.0 : To test.';
    UnitType: 3;
    Major: 1; Minor: 0; Release: 1; Build: 1);
{$ENDIF}

type
 { TFWPrintGrid }

  TFWPrintGrid = class(TFWPrint)
  private
    FFilter : TRLCustomPrintFilter;
    FDBGrid: TCustomDBGrid;
    FTitle : String;
    procedure SetDBGrid(AValue: TCustomDBGrid);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    procedure Click; override;
  published
    property DBGrid : TCustomDBGrid read FDBGrid write SetDBGrid;
    property Filter : TRLCustomPrintFilter read FFilter write FFilter;
    property DBTitle  : String read FTitle write FTitle;
  end;

implementation

uses fonctions_reports,
     fonctions_proprietes,
     Forms;


{ TFWPrintGrid }

procedure TFWPrintGrid.SetDBGrid(AValue: TCustomDBGrid);
var i : Integer;
    AColumns : TDBGridColumns;
begin
  if AValue  <> FDBGrid Then
    Begin
      FDBGrid:=AValue;
    end;
end;

procedure TFWPrintGrid.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation <> opRemove) Then exit;
  if (AComponent = DBGrid ) then DBGrid := nil;
  if (AComponent = Filter ) then Filter := nil;
end;

procedure TFWPrintGrid.Click;
begin
  inherited Click;
  if assigned ( FDBGrid ) Then
   Begin
     fb_CreateGridReport(FDBGrid,FTitle,FFilter);
   end;
end;

{$IFDEF VERSIONS}
initialization
p_ConcatVersion(gVer_reports_components);
{$ENDIF}
end.

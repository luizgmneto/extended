unit u_scrolldbclones;

{$i ..\extends.inc}
{$IFDEF FPC}
{$Mode Delphi}
{$ENDIF}

interface

uses
  Classes, SysUtils, Forms,
  {$IFDEF VERSIONS}
    fonctions_version,
  {$ENDIF}
  ExtCtrls, DB, Controls,
  fonctions_db,
  u_scrollclones;

{$IFDEF VERSIONS}
const
  gVer_ScrollDBClone: T_Version = (Component: 'Composant TExtDBClonedPanel';
    FileUnit: 'u_scrolldbclones';
    Owner: 'Matthieu Giroux';
    Comment:
    'Gestion de liste d''images dans les données.';
    BugsStory : '0.9.0.0 : Non testée.';
    UnitType: 3;
    Major: 0; Minor: 9; Release: 0; Build: 0);

{$ENDIF}

type
 { TExtDBClonedPanel }

 TExtDBClonedPanel = class ( TExtClonedPanel, IDatalinkOwner )
  private
    FDataLink: TDataLinkOwnered;
    FTag : Integer;
    FOrientation : TScrollBarKind;
    function GetDatasource: TDatasource;
    procedure SetDatasource(AValue: TDatasource);
  protected
    procedure Loaded; override;
    procedure Notification ( AComponent : TComponent ; AOperation : TOperation ); override;
    procedure ActiveChanged; virtual;
    procedure DataSetChanged; virtual;
    procedure EditingChanged; virtual;
    procedure p_BeforePaintPanel(Sender: TObject); virtual;
    procedure AutoCreateColsRows; override;
    procedure ControlEvent ( const AControl : TControl ); override;
    procedure PanelCloningEvent ( const AControl : TPanel ); override;
  public
    constructor Create ( AOwner : TComponent ); override;
    destructor Destroy; override;
    property Cols;
    property Rows;
  published
    property Datasource : TDatasource read GetDatasource write SetDatasource;
    property Orientation : TScrollBarKind read FOrientation write FOrientation default sbVertical;

  End;

implementation

uses fonctions_dbcomponents;

{ TExtClonedPanel }

procedure TExtDBClonedPanel.AutoCreateColsRows;
var i, j, k, ltag : Integer;
    LEndName : String;
    LPanel : TPanel;
Begin
  if not assigned ( PanelCloned ) Then
   Exit;
  if not FDataLink.Active Then
   Begin
     Cols:=1;
     Rows:=1;
     PanelCloned.Visible := False ;
   end
  Else
   Begin
     PanelCloned.Visible := True ;
     FTag:=1;
     case FOrientation of
       sbVertical   : Begin
                       Cols := 1;
                       Rows := FDataLink.RecordCount;
                      End;
       sbHorizontal : Begin
                       Cols := FDataLink.RecordCount;
                       Rows := 1;
                      End;
     end;
     AutoScroll:=True;
   end;
  Inherited;
end;

procedure TExtDBClonedPanel.ControlEvent(const AControl: TControl);
begin
  AControl.Tag:=FTag;
  inherited ControlEvent(AControl);
end;

procedure TExtDBClonedPanel.PanelCloningEvent(const AControl: TPanel);
begin
  AControl.Tag:=FTag;
  inherited;
  inc ( FTag );
  AControl.OnPaint:=p_BeforePaintPanel;
end;

function TExtDBClonedPanel.GetDatasource: TDatasource;
begin
  Result:=FDataLink.DataSource;
end;

procedure TExtDBClonedPanel.SetDatasource(AValue: TDatasource);
begin
  FDataLink.DataSource := AValue;
end;

procedure TExtDBClonedPanel.Loaded;
begin
  inherited Loaded;
  AutoCreateColsRows;
end;

procedure TExtDBClonedPanel.Notification(AComponent: TComponent;
  AOperation: TOperation);
begin
  inherited Notification(AComponent, AOperation);
  if  ( AOperation = opRemove )
  and ( AComponent = FDataLink.DataSource ) Then
   Begin
     FDataLink.DataSource:=nil;
     AutoCreateColsRows;
   end;
end;

procedure TExtDBClonedPanel.ActiveChanged;
begin
  AutoCreateColsRows;

end;

procedure TExtDBClonedPanel.DataSetChanged;
begin
  AutoCreateColsRows;

end;

procedure TExtDBClonedPanel.EditingChanged;
begin

end;

procedure TExtDBClonedPanel.p_BeforePaintPanel(Sender: TObject);
begin
  FDataLink.ActiveRecord:= ( Sender as TControl ).Tag;
end;

constructor TExtDBClonedPanel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDataLink:= TDataLinkOwnered.Create ( Self );
  FOrientation:=sbVertical;
end;

destructor TExtDBClonedPanel.Destroy;
begin
  inherited Destroy;
  FDataLink.Destroy;
end;

{$IFDEF VERSIONS}
initialization
  p_ConcatVersion(gVer_ScrollDBClone);
{$ENDIF}
end.


unit u_scrollclones;

{$i ..\extends.inc}
{$IFDEF FPC}
{$Mode Delphi}
{$ENDIF}

interface

uses
  Classes, SysUtils, Forms, ExtCtrls,
  {$IFDEF VERSIONS}
    fonctions_version,
  {$ENDIF}
  Controls;

const
  {$IFDEF VERSIONS}
    gVer_ScrollClone: T_Version = (Component: 'Composant TExtClonedPanel';
      FileUnit: 'u_scrollclones';
      Owner: 'Matthieu Giroux';
      Comment:
      'Gestion de liste d''images dans les données.';
      BugsStory : '1.0.0.0 : Tested, Reinit procedure.'+#13#10+
                  '0.9.0.0 : Non testée.';
      UnitType: 3;
      Major: 1; Minor: 0; Release: 0; Build: 0);

  {$ENDIF}
    CST_MAX_CLONED_COLS = 1000;

type

{ TExtClonedPanel }

 TExtClonedPanel = class ( TScrollBox )
  private
    FPanelCloned : TPanel;
    FCols, FRows : Word;
    FAutoControls : {$IFDEF FPC}TFPList{$ELSE}TList{$ENDIF};
    FOnClone, FOnCloningControl,
    FOnCloningPanel, FOnBeginClones,
    FOnEndClones : TNotifyEvent;
    function GetAutoControl ( Index : Integer ):TControl;
    function GetAutoControlCount : Integer;
  protected
    procedure Loaded; override;
    procedure SetCols ( const Avalue : Word ); virtual;
    procedure SetRows ( const Avalue : Word ); virtual;
    procedure Notification ( AComponent : TComponent ; AOperation : TOperation ); override;
    procedure AutoSetPanel; virtual;
    procedure ControlEvent ( const AControl : TControl ); virtual;
    procedure PanelClonedEvent ( const Apanel : TPanel ); virtual;
    procedure PanelCloningEvent ( const Apanel : TPanel ); virtual;
    procedure SetPanelCloned ( const Apanel : TPanel ); virtual;
  public
    procedure AutoCreateColsRows; virtual;
    procedure Reinit; virtual;
    constructor Create ( AOwner : TComponent ); override;
    destructor  Destroy; override;
    property AutoControlCount : Integer read GetAutoControlCount;
    property AutoControls [ Index : Integer ] : TControl read GetAutoControl;
  published
      property PanelCloned : TPanel read FPanelCloned write SetPanelCloned;
      property Cols : Word read FCols write SetCols default 1;
      property Rows : Word read FRows write SetRows default 1;
      property OnCloned : TNotifyEvent read FOnClone write FOnClone;
      property OnBeginClones : TNotifyEvent read FOnBeginClones write FOnBeginClones;
      property OnEndClones : TNotifyEvent read FOnEndClones write FOnEndClones;
      property OnCloningControl : TNotifyEvent read FOnCloningControl write FOnCloningControl;
      property OnCloningPanel   : TNotifyEvent read FOnCloningPanel   write FOnCloningPanel;

  End;

implementation

uses fonctions_dbcomponents, fonctions_proprietes;
{ TExtClonedPanel }

procedure TExtClonedPanel.SetCols(const Avalue: Word);
begin
  if  ( FCols <> Avalue )
  and ( Avalue > 0 ) Then
   Begin
    FCols:=Avalue;
    AutoCreateColsRows;
   end;
end;

function TExtClonedPanel.GetAutoControl( Index: Integer):TControl;
begin
  if  ( Index >= 0 )
  and ( Index < FAutoControls.Count )
   Then Result := TControl(FAutoControls [ Index ])
   Else Result := nil;
end;

function TExtClonedPanel.GetAutoControlCount: Integer;
begin
  Result:=FAutoControls.Count;
end;

procedure TExtClonedPanel.Loaded;
begin
  inherited Loaded;
  AutoCreateColsRows;
end;

procedure TExtClonedPanel.SetRows(const Avalue: Word);
begin
  begin
    if  ( FRows <> Avalue )
    and ( Avalue > 0 ) Then
     Begin
      FRows:=Avalue;
      AutoCreateColsRows;
     end;
  end;
end;

procedure TExtClonedPanel.AutoSetPanel;
Begin
  case FPanelCloned.Align of
    alClient :
      Begin
        if ( FCols > 1 ) and ( FRows > 1 ) Then FPanelCloned.Align:= alNone
         else if ( FCols > 1 ) Then FPanelCloned.Align:= alLeft
         Else if ( FRows > 1 ) Then FPanelCloned.Align:= alTop;

      end;
    alLeft : if FRows > 1 Then  FPanelCloned.Align := alNone;
    alTop  : if FCols > 1 Then  FPanelCloned.Align := alNone;
  end;
end;

procedure TExtClonedPanel.ControlEvent(const AControl: TControl);
begin
  if Assigned(FOnCloningControl)
   Then FOnCloningControl ( AControl);
end;

procedure TExtClonedPanel.PanelClonedEvent ( const Apanel : TPanel );
begin
  if Assigned(FOnClone)
   Then FOnClone ( APanel );
end;

procedure TExtClonedPanel.PanelCloningEvent(const Apanel: TPanel);
begin
  if Assigned(FOnCloningPanel) Then
   FOnCloningPanel ( Apanel );
end;

procedure TExtClonedPanel.SetPanelCloned(const Apanel: TPanel);
begin
  if FPanelCloned <> Apanel Then
    Begin
     FPanelCloned:=Apanel;
     AutoCreateColsRows;
    end;
end;

procedure TExtClonedPanel.AutoCreateColsRows;
var i, j, k, ltag : Integer;
    LEndName : String;
    LPanel : TPanel;
    LControl : TControl;
Begin
  if not Assigned(FPanelCloned)
  or ( csDesigning  in ComponentState )
  or ( csDestroying in ComponentState )
  or ( csLoading    in ComponentState   )
   Then
    Exit;
  AutoSetPanel;
  for i := FAutoControls.Count - 1 downto 0 do
   Begin
     (TObject(FAutoControls[i])).Destroy;
   end;
  FAutoControls.Clear;
  if assigned ( FOnBeginClones ) Then
   FOnBeginClones ( Self );
  for i := 1 to FCols do
   for j := 1 to FRows do
    if ( i = 1 ) and ( j = 1 )
    Then Continue
    Else
      Begin
        LPanel := fcon_CloneControlWithDB( FPanelCloned, Owner ) as TPanel;
        FAutoControls.Add(LPanel);
        with LPanel do
          Begin
            Parent := Self;
            Left  := ( i - 1 ) * (FPanelCloned.Width  + FPanelCloned.Left) + 1;
            Top   := ( j - 1 ) * (FPanelCloned.Height + FPanelCloned.Top ) + 1 ;
            LEndName:= IntToStr(i) + '_' + IntToStr(j);
            Name := FPanelCloned.name + '_' + LEndName;
            Caption:=FPanelCloned.Caption;
            lTag := i * CST_MAX_CLONED_COLS + j;
            Tag  := ltag;
            TabOrder:=j*FCols+i;
            PanelCloningEvent ( LPanel );
            for k := 0 to FPanelCloned.ControlCount - 1 do
             Begin
               LControl := fcon_CloneControlWithDB ( FPanelCloned.Controls [ k ], Owner );
               FAutoControls.Add(LControl);
               with LControl do
                 Begin
                  Parent := LPanel;
                  Name := FPanelCloned.Controls [ k ].Name + LEndName;
                  p_SetComponentProperty ( LControl, CST_PROPERTY_CAPTION, fs_getComponentProperty ( FPanelCloned.Controls [ k ], CST_PROPERTY_CAPTION ));
                  Tag  := ltag;
                 end;
               ControlEvent(LControl);
             end;
            PanelClonedEvent ( LPanel );
          end;
      end;

  if assigned ( FOnEndClones ) Then
   FOnEndClones ( Self );
end;

procedure TExtClonedPanel.Reinit;
begin
  Cols := 1;
end;

procedure TExtClonedPanel.Notification(AComponent: TComponent;
  AOperation: TOperation);
begin
  inherited Notification(AComponent, AOperation);
  if  ( AOperation = opRemove )
  and ( AComponent = FPanelCloned ) Then
   Begin
     PanelCloned:=nil;
   end;
end;

constructor TExtClonedPanel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FPanelCloned:=nil;
  FRows:=1;
  FCols:=1;
  FAutoControls := {$IFDEF FPC}TFPList{$ELSE}TList{$ENDIF}.Create;
  FOnBeginClones:=nil;
  FOnClone:=nil;
  FOnCloningControl:=nil;
  FOnCloningPanel:=nil;
end;

destructor TExtClonedPanel.Destroy;
begin
  inherited Destroy;
  FAutoControls.Free;
end;

{$IFDEF VERSIONS}
initialization
  p_ConcatVersion(gVer_ScrollClone);
{$ENDIF}
end.


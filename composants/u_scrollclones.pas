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

const CST_PanelCloned = 'PanelCloned_';
  {$IFDEF VERSIONS}
    gVer_ScrollClone: T_Version = (Component: 'Composant TExtClonedPanel';
      FileUnit: 'u_scrollclones';
      Owner: 'Matthieu Giroux';
      Comment:
      'Gestion de liste d''images dans les données.';
      BugsStory : '0.9.0.0 : Non testée.';
      UnitType: 3;
      Major: 0; Minor: 9; Release: 0; Build: 0);

  {$ENDIF}


type

{ TExtClonedPanel }

 TExtClonedPanel = class ( TScrollBox )
  private
    FPanelCloned : TPanel;
    FCols, FRows : Word;
    FOnClone, FOnCloningControl, FOnCloningPanel : TNotifyEvent;
  protected
    procedure SetCols ( const Avalue : Word ); virtual;
    procedure SetRows ( const Avalue : Word ); virtual;
    procedure Loaded; override;
    procedure Notification ( AComponent : TComponent ; AOperation : TOperation ); override;
    procedure AutoCreatePanel; virtual;
    procedure ControlEvent ( const AControl : TControl ); virtual;
    procedure PanelClonedEvent ( const Apanel : TPanel ); virtual;
    procedure PanelCloningEvent ( const Apanel : TPanel ); virtual;
    procedure AutoCreateColsRows; virtual;
  public
    constructor Create ( AOwner : TComponent ); override;
  published
      property PanelCloned : TPanel read FPanelCloned write FPanelCloned;
      property Cols : Word read FCols write SetCols default 1;
      property Rows : Word read FRows write SetRows default 1;
      property OnCloned : TNotifyEvent read FOnClone write FOnClone;
      property OnCloningControl : TNotifyEvent read FOnCloningControl write FOnCloningControl;
      property OnCloningPanel   : TNotifyEvent read FOnCloningPanel   write FOnCloningPanel;

  End;

implementation

uses fonctions_dbcomponents;
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

procedure TExtClonedPanel.SetRows(const Avalue: Word);
begin
  begin
    if  ( FCols <> Avalue )
    and ( Avalue > 0 ) Then
     Begin
      FCols:=Avalue;
      AutoCreateColsRows;
     end;
  end;
end;

procedure TExtClonedPanel.AutoCreatePanel;
Begin
  if FPanelCloned = nil Then
   Begin
     FPanelCloned:=TPanel.Create ( Owner );
     FPanelCloned.Parent := Self;
     FPanelCloned.Width :=Width;
     FPanelCloned.Height:=Height;
     FPanelCloned.Name := CST_PanelCloned + '0_0';
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

procedure TExtClonedPanel.AutoCreateColsRows;
var i, j, k, ltag : Integer;
    LEndName : String;
    LPanel : TPanel;
    LControl : TControl;
Begin
  if ( csDesigning in ComponentState ) Then
    Exit;
  AutoCreatePanel;
  for i := 0 to ComponentCount - 1 do
   Begin
     Components[i].Destroy;
   end;
  for i := 1 to FCols - 1 do
   for j := 1 to FRows - 1 do
    Begin
      LPanel := TPanel.Create ( Self );
      with LPanel do
        Begin
          Parent := Self;
          Width :=FPanelCloned.Width;
          Height:=FPanelCloned.Height;
          Left  := FCols*FPanelCloned.Left + FCols * FPanelCloned.Width;
          Top   := FRows*FPanelCloned.Top  + FRows * FPanelCloned.Top;
          case FPanelCloned.Align of
            alClient :
              Begin
                if ( FCols > 1 ) and ( FRows > 1 ) Then FPanelCloned.Align:= alNone
                 else if ( FCols > 1 ) Then FPanelCloned.Align:= alLeft
                 Else if ( FRows > 1 ) Then FPanelCloned.Align:= alTop;

              end;
            alLeft : if FCols > 1 Then  FPanelCloned.Align := alNone;
            alTop  : if FRows > 1 Then  FPanelCloned.Align := alNone;
          end;
          Align:=FPanelCloned.Align;
          LEndName:= IntToStr(FCols) + '_' + IntToStr(FRows);
          Name := CST_PanelCloned + LEndName;
          lTag := i * 1000 + j;
          Tag  := ltag;
          PanelCloningEvent ( LPanel );
          for k := 0 to FPanelCloned.ControlCount - 1 do
           Begin
             LControl := fcon_CloneControlWithDB ( FPanelCloned.Controls [ k ], Self );
             with LControl do
               Begin
                Name := FPanelCloned.Controls [ k ].Name + LEndName;
                Tag  := ltag;
               end;
             ControlEvent(LControl);
           end;
          PanelClonedEvent ( LPanel );
        end;
    end;

end;

procedure TExtClonedPanel.Loaded;
begin
  inherited Loaded;
  AutoCreateColsRows;
end;

procedure TExtClonedPanel.Notification(AComponent: TComponent;
  AOperation: TOperation);
begin
  inherited Notification(AComponent, AOperation);
  if  ( AOperation = opRemove )
  and ( AComponent = FPanelCloned ) Then
   Begin
     FPanelCloned:=nil;
     AutoCreateColsRows;
   end;
end;

constructor TExtClonedPanel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FPanelCloned:=nil;
  FRows:=1;
  FCols:=1;
end;

{$IFDEF VERSIONS}
initialization
  p_ConcatVersion(gVer_ScrollClone);
{$ENDIF}
end.


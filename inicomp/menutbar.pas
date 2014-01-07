{September 2010 Suny D.
 Based upon Alexander Obukhov's MenuToolbar. .
 I don't modified his code. I writed the code new and took some things from
 him.
Code-state:
1. Menu Clicks don't executed i think LCL has BUG again.
  LCl-BUG: toollbar.submenu clicks dont executed by lcl

  I used ToolButton.DropdownMenu and now it is ok.

2. It it ToolBar with only one new property.
  Menu: Set it to MainMenu and you have MainMenu on toolbar!<
3. Crossplatform- it can be used under windows and linux(tested with gtk2)
  Under gtk2- menuitems dont autopopup with mousemove.
  Under Linux- I have to find how to catch mouse-events if menus opened.
}

unit menutbar;

{$IFDEF FPC}
{$mode Delphi}
{$ENDIF}

interface

uses
  Classes, SysUtils, ComCtrls, Menus, {$IFDEF LCLwin32}LMessages,{$ENDIF} Controls;

type
  TMenuToolBar = class(TToolBar)
  private
    FMenu : TMenu;
  protected
    procedure SetMenu(Value: TMenu); virtual;
    {$IFDEF LCLwin32}procedure WndProc(var Message: TLMessage); override;{$ENDIF}
  public
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Menu: TMenu read FMenu write SetMenu;
    property EdgeBorders default [];
    property Flat default true;
    property List default true;
    property ShowCaptions default true;
    property AutoSize default true;
  end;

procedure Register;
  
implementation

{$IFDEF LCLwin32}uses Windows;{$ENDIF}


procedure Register;
begin
  RegisterComponents('Ext', [TMenuToolBar]);
end;

{$IFDEF LCLwin32}
var
 HookButton: TToolButton;
 Hook: System.THandle; //HHOOK;


function MTBarHookProc(nCode: Integer; wParam: Longint; var Msg: TMsg): Longint; stdcall;
var Pt: TPoint;
    TB: TToolButton;
    Control: TControl;
    Toolbar: TMenuToolbar;
begin
  if (nCode = MSGF_MENU) and Assigned(HookButton) then
   case Msg.Message of
    WM_MOUSEMOVE:
      begin
        Pt:= SmallPointToPoint(TSmallPoint(Msg.lParam));
        Toolbar:= HookButton.Parent as TMenuToolbar;
        Pt:= Toolbar.ScreenToClient(Pt);
        if Assigned(Toolbar) and PtInRect(Toolbar.ClientRect, Pt) then
         begin
            Control:= Toolbar.ControlAtPos(Pt, False);
            if (Control is TToolButton) then
             begin
                TB:= Control as TToolButton;
                if (TB<>HookButton) then
                  PostMessage(Toolbar.Handle, WM_LBUTTONDOWN, MK_LBUTTON, MakeLong(Pt.x, Pt.y));
            end;
        end;
      end;

   end; //from case

  if Hook<>0 then Result:= CallNextHookEx(Hook, nCode, wParam, Longint(@Msg));
end;
{$ENDIF}

constructor TMenuToolBar.Create(TheOwner: TComponent);
begin
  inherited;
  EdgeBorders := [];
  Flat:=true;
  List:=true;
  ShowCaptions:=true;
  AutoSize:=true;
end;

destructor TMenuToolBar.Destroy;
begin
  {$IFDEF LCLwin32}UnhookWindowsHookEx(Hook);{$ENDIF}
  inherited;
end;

{$IFDEF LCLwin32}
procedure TMenuToolBar.WndProc(var Message: TLMessage);
var TB: TControl;
    Pt: TPoint;
begin
  if (not (csDesigning in ComponentState))then
   case Message.Msg of

   WM_LBUTTONDOWN: begin
        Pt:= SmallPointToPoint(TSmallPoint(Message.lParam));
        TB:= ControlAtPos(Pt, False);
        if (TB is TToolButton) then
         begin
          inherited;
          HookButton:= TB as TToolButton;
          if Assigned(HookButton.OnClick) then DefaultHandler(Message);
          if HookButton.DropdownMenu<>nil then
           begin // MenuItem<>nil; HookButton.MenuHandle ;Tag<>0 then
            if Hook=0 then Hook:= SetWindowsHookEx(WH_MSGFILTER, windows.HOOKPROC(@MTBarHookProc), 0, GetCurrentThreadID);
            Message.Msg:= WM_LBUTTONUP;
            DefaultHandler(Message);
          end;
        end;
      end;

    WM_RBUTTONDOWN: begin
        Pt:= SmallPointToPoint(TSmallPoint(Message.lParam));
        TB:= ControlAtPos(Pt, False);
        if (TB is TToolButton) then
         begin
          inherited;
          HookButton:= TB as TToolButton;
          if Assigned(HookButton.OnClick) then DefaultHandler(Message);
            if HookButton.DropdownMenu<>nil then begin // MenuItem<>nil; HookButton.MenuHandle ;HookButton.Tag<>0
              if Hook=0 then Hook:= SetWindowsHookEx(WH_MSGFILTER, windows.HOOKPROC(@MTBarHookProc), 0, GetCurrentThreadID);
              Message.Msg:= WM_LBUTTONUP;
              DefaultHandler(Message);
            end;
        end;
      end;

   end; //from case

  inherited;
end;
{$ENDIF}

procedure TMenuToolBar.SetMenu(Value: TMenu);

procedure aCreatePopupFromMenu(SrcMenuItem, DestMenuItem: TMenuItem);
 var i: Integer;
     MovingMenuItem: TMenuItem;
 begin
   for i := SrcMenuItem.Count - 1 downto 0 do
    begin
     MovingMenuItem := SrcMenuItem.Items[i];
     SrcMenuItem.Delete(i);
     DestMenuItem.Insert(0, MovingMenuItem);
    end;
 end;

var aTB: TToolButton;
    i: integer;
begin
  if (FMenu=Value) then exit;
  FMenu:=Value;
  while ControlCount>0 do Controls[0].Free; //delete old menubuttons
  if Assigned(FMenu) then
   begin
    Images:=fmenu.Images;
    for I:=0  to FMenu.Items.Count-1 do
     begin
      aTB:= TToolButton.Create(Self);
      with FMenu.Items[I] do
        begin
          aTB.Name:= Name;
          aTB.Tag:= Tag;
          aTB.Caption:= Caption;
          aTB.OnClick:= OnClick;
          aTB.ImageIndex:= ImageIndex;
        end;
      aTB.Style:= tbsButton;
      {Onclick from MenuItem-Submenus don't called by LCL i must use DropDownMenu
      aTB.MenuItem:=FMenu.Items[I]; }
      //create dropdownmenu
      if FMenu.Items[I].Count > 0 Then
        if (not (csDesigning in ComponentState))then
         begin //else MenuItems will be freed
          aTB.DropdownMenu:=TPopupMenu.Create(self);
          aTB.DropdownMenu.Images:=FMenu.Images;
          aCreatePopupFromMenu(FMenu.Items[I], aTB.DropdownMenu.Items);
        end;
      aTB.Parent:= Self;
    end;
  end;
end;

end.

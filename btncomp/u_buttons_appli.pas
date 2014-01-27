unit u_buttons_appli;

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
  Controls, DBGrids,
  u_buttons_defs, Graphics,
  Menus, JvXPButtons;

const
{$IFDEF VERSIONS}
  gVer_buttons_appli: T_Version = (Component: 'Customized Buttons';
    FileUnit: 'u_buttons_appli';
    Owner: 'Matthieu Giroux';
    Comment: 'Customized Buttons components.';
    BugsStory: '1.0.0.3 : Removing auto caption because parasiting.' +
      #13#10 + '1.0.0.2 : Date and Folder Buttons.' +
      #13#10 + '1.0.0.1 : UTF 8.' +
      #13#10 + '1.0.0.0 : Version OK.' +
      #13#10 + '0.8.0.1 : Group view buttons better.' +
      #13#10 + '0.8.0.0 : To test.';
    UnitType: 3;
    Major: 1; Minor: 0; Release: 0; Build: 3);
{$ENDIF}
  CST_FWCANCEL='tfwcancel';
  CST_FWCLOSE='tfwclose';
  CST_FWOK='tfwok';
  CST_FWBASKET = 'tfwbasket';
  CST_FWDATE = 'tfwdate';
  CST_FWDOCUMENT = 'tfwdocument';
  CST_FWFOLDER = 'tfwfolder';
  CST_FWINSERT = 'tfwinsert';
  CST_FWDELETE = 'tfwdelete';
  CST_FWIMPORT = 'tfwimport';
  CST_FWEXPORT = 'tfwexport';
  CST_FWCOPY = 'tfwcopy';
  CST_FWQUIT = 'tfwquit';
  CST_FWERASE = 'tfwerase';
  CST_FWSAVEAS = 'tfwsaveas';
  CST_FWPRINT = 'tfwprint';
  CST_FWPREVIEW = 'tfwpreview';
  CST_FWNEXT = 'tfwnext';
  CST_FWREFRESH = 'tfwrefresh';
  CST_FWPRIOR = 'tfwprior';
  CST_FWINIT = 'tfwinit';
  CST_FWCONFIG = 'tfwconfig';
  CST_FWLOAD = 'tfwload';
  CST_FWSEARCH = 'tfwsearch';
  CST_FWZOOMIN = 'tfwzoomin';
  CST_FWZOOMOUT = 'tfwzoomout';
  CST_FWTRASH = 'tfwTtrash';
{$IFDEF GROUPVIEW}
  CST_FWOUTSELECT = 'tfwoutselect';
  CST_FWINSELECT = 'tfwinselect';
  CST_FWOUTALL = 'tfwoutall';
  CST_FWINALL = 'tfwinall';
{$ENDIF}

type

  { TFWClose }

  TFWClose = class(TFWButton)
  public
    constructor Create(AOwner: TComponent); override;
    procedure Loaded; override;
    procedure Click; override;
  published

    property Width default CST_FWWIDTH_CLOSE_BUTTON;
  end;

  { TFWCancel }
  TFWCancel = class(TFWButton)
  public
    procedure Loaded; override;
  end;


  { TFWOK }
  TFWOK = class(TFWButton)
  public
    procedure Loaded; override;
  published

  end;


  { TFWInsert }
  TFWInsert = class(TFWButton)
  public
    procedure Loaded; override;
  published

  end;

  { TFWAdd }
  TFWAdd = class(TFWButton)
  public
    procedure Loaded; override;
  end;

  { TFWDelete }
  TFWDelete = class(TFWButton)
  public
    procedure Loaded; override;
  end;

  { TFWDocument }
  TFWDocument = class(TFWButton)
  public
    procedure Loaded; override;
  end;

  { TFWFolder }
  TFWFolder = class(TFWButton)
  public
    procedure Loaded; override;
  end;

  { TFWDate }
  TFWDate = class(TFWButton)
  public
    procedure Loaded; override;
  end;

  { TFWQuit }
  TFWQuit = class(TFWButton)
  public
    procedure Loaded; override;
  end;

  { TFWErase }
  TFWErase = class(TFWButton)
  public
    procedure Loaded; override;
  end;

  { TFWSaveAs }
  TFWSaveAs = class(TFWButton)
  public
    procedure Loaded; override;
  end;

  { TFWLoad }
  TFWLoad = class(TFWButton)
  public
    procedure Loaded; override;
  end;

  { TFWPrint }
  TFWPrint = class(TFWButton)
  public
    procedure Loaded; override;
  end;

  { TFWPreview }
  TFWPreview = class(TFWButton)
  public
    procedure Loaded; override;
  end;

  { TFWNext }
  TFWNext = class(TFWButton)
  public
    procedure Loaded; override;
  end;

  { TFWPrior }
  TFWPrior = class(TFWButton)
  public
    procedure Loaded; override;
  end;

  { TFWPrior }
  TFWRefresh = class(TFWButton)
  public
    procedure Loaded; override;
  end;

  { TFWCopy }
  TFWCopy = class(TFWButton)
  public
    procedure Loaded; override;
  end;

  { TFWInit }
  TFWInit = class(TFWButton)
  public
    procedure Loaded; override;
  end;

  { TFWConfig }
  TFWConfig = class(TFWButton)
  public
    procedure Loaded; override;
  end;

  { TFWImport }
  TFWImport = class(TFWButton)
  public
    procedure Loaded; override;
  end;

  { TFWTrash }
  TFWTrash = class(TFWButton)
  public
    procedure Loaded; override;
  end;

  { TFWExport }
  TFWExport = class(TFWButton)
  public
    procedure Loaded; override;
  end;

  { TFWSearch }
  TFWSearch = class(TFWButton)
  public
    procedure Loaded; override;
  end;

  { TFWZoomIn }
  TFWZoomIn = class(TFWButton)
  public
    procedure Loaded; override;
  end;

  { TFWZoomOut }
  TFWZoomOut = class(TFWButton)
  public
    procedure Loaded; override;
  end;

{$IFDEF GROUPVIEW}

  { TFWGroupButton }

  { TFWGroupButtonActions }

  TFWGroupButtonActions = class(TFWButton)
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Width default CST_WIDTH_BUTTONS_ACTIONS;
    property Height default CST_HEIGHT_BUTTONS_ACTIONS;
  end;


  { TFWBasket }

  TFWBasket = class(TFWGroupButtonActions)
  public
    procedure Loaded; override;

  published

    property Caption stored False;
  end;

  { TFWRecord }

  TFWRecord = class(TFWGroupButtonActions)
  public
    procedure Loaded; override;

  published

    property Caption stored False;
  end;

  { TFWGroupButtonMoving }

  TFWGroupButtonMoving = class(TFWButton)
  public
    constructor Create(AOwner: TComponent); override;
  published
    property GlyphSize default CST_SIZE_BUTTONS_MOVING;
    property Width default CST_WIDTH_BUTTONS_MOVING;
    property Height default CST_HEIGHT_BUTTONS_MOVING;
  end;

  { TFWOutSelect }
  TFWOutSelect = class(TFWGroupButtonMoving)
  public
    procedure Loaded; override;
  published

  end;

  { TFWOutAll }


  TFWOutAll = class(TFWGroupButtonMoving)
  public
    procedure Loaded; override;
  published

  end;

  { TFWInSelect }
  TFWInSelect = class(TFWGroupButtonMoving)
  public
    procedure Loaded; override;
  published

  end;

  { TFWInAll }
  TFWInAll = class(TFWGroupButtonMoving)
  public
    procedure Loaded; override;
  published

  end;

{$ENDIF}

implementation

uses {$IFDEF FPC}ObjInspStrConsts, lclstrconsts,
     {$ELSE}Consts, VDBConsts, {$ENDIF}
  {$IFDEF FPC}
  unite_messages,
  {$ELSE}
  unite_messages_delphi,
  {$ENDIF}
  fonctions_images,
  Forms;

{$IFNDEF FPC}
var
  Buttons_Appli_ResInstance: THandle = 0;

{$ENDIF}


{ TFWClose }


procedure TFWClose.Click;
begin
  if not assigned(OnClick) and (Owner is TCustomForm) then
    with Owner as TCustomForm do
    begin
      Close;
      Exit;
    end;
  inherited;

end;

constructor TFWClose.Create(AOwner: TComponent);
begin
  inherited;
  Width := CST_FWWIDTH_CLOSE_BUTTON;
end;

procedure TFWClose.Loaded;
begin
  p_Load_Buttons_Appli(Glyph, CST_FWCLOSE, Self);
  inherited Loaded;
end;


{ TFWCancel }

procedure TFWCancel.Loaded;
begin
  p_Load_Buttons_Appli(Glyph, CST_FWCANCEL, Self);
  inherited Loaded;
end;


{ TFWOK }

procedure TFWOK.Loaded;
begin
  p_Load_Buttons_Appli(Glyph, CST_FWOK, Self);
  inherited Loaded;
end;

{ TFWSearch }

procedure TFWSearch.Loaded;
begin
  p_Load_Buttons_Appli(Glyph, CST_FWSEARCH, Self);
  inherited Loaded;
end;

{ TFWZoomOut }

procedure TFWZoomOut.Loaded;
begin
  p_Load_Buttons_Appli(Glyph, CST_FWZOOMOUT, Self);
  inherited Loaded;
end;

{ TFWZoomIn }

procedure TFWZoomIn.Loaded;
begin
  p_Load_Buttons_Appli(Glyph, CST_FWZOOMIN, Self);
  inherited Loaded;
end;

{ TFWFolder }

procedure TFWFolder.Loaded;
begin
  p_Load_Buttons_Appli(Glyph, CST_FWFOLDER, Self);
  inherited Loaded;
end;

{ TFWTrash }

procedure TFWTrash.Loaded;
begin
  p_Load_Buttons_Appli(Glyph, CST_FWTRASH, Self);
  inherited Loaded;
end;


{ TFWDate }

procedure TFWDate.Loaded;
begin
  p_Load_Buttons_Appli(Glyph, CST_FWDATE, Self);
  inherited Loaded;
end;

{ TFWLoad }

procedure TFWLoad.Loaded;
begin
  p_Load_Buttons_Appli(Glyph, CST_FWLOAD, Self);
  inherited Loaded;
end;

{ TFWDocument }

procedure TFWDocument.Loaded;
begin
  p_Load_Buttons_Appli(Glyph, CST_FWDOCUMENT, Self);
  inherited Loaded;
end;

{ TFWDelete }

procedure TFWDelete.Loaded;
begin
  p_Load_Buttons_Appli(Glyph, CST_FWDELETE, Self);
  inherited Loaded;
end;

{ TFWInsert }

procedure TFWInsert.Loaded;
begin
  p_Load_Buttons_Appli(Glyph, CST_FWINSERT, Self);
  inherited Loaded;
end;

{ TFWAdd }
procedure TFWAdd.Loaded;
begin
  p_Load_Buttons_Appli(Glyph, CST_FWINSERT, Self);
  inherited Loaded;
end;

{ TFWSaveAs }

procedure TFWSaveAs.Loaded;
begin
  p_Load_Buttons_Appli(Glyph, CST_FWSAVEAS, Self);
  inherited Loaded;
end;

{ TFWQuit }

procedure TFWQuit.Loaded;
begin
  p_Load_Buttons_Appli(Glyph, CST_FWQUIT, Self);
  inherited Loaded;
end;


{ TFWerase }

procedure TFWErase.Loaded;
begin
  p_Load_Buttons_Appli(Glyph, CST_FWERASE, Self);
  inherited Loaded;
end;

{ TFWPrint }

procedure TFWPrint.Loaded;
begin
  p_Load_Buttons_Appli(Glyph, CST_FWPRINT, Self);
  inherited Loaded;
end;

{ TFWNext }

procedure TFWNext.Loaded;
begin
  p_Load_Buttons_Appli(Glyph, CST_FWNEXT, Self);
  inherited Loaded;
end;

{ TFWPrior }

procedure TFWPrior.Loaded;
begin
  p_Load_Buttons_Appli(Glyph, CST_FWPRIOR, Self);
  inherited Loaded;
end;

{ TFWRefresh }

procedure TFWRefresh.Loaded;
begin
  p_Load_Buttons_Appli(Glyph, CST_FWREFRESH, Self);
  inherited Loaded;
end;

{ TFWPreview }

procedure TFWPreview.Loaded;
begin
  p_Load_Buttons_Appli(Glyph, CST_FWPREVIEW, Self);
  inherited Loaded;
end;

{ TFWInit }

procedure TFWInit.Loaded;
begin
  p_Load_Buttons_Appli(Glyph, CST_FWINIT, Self);
  inherited Loaded;
end;

{ TFWConfig }

procedure TFWConfig.Loaded;
begin
  p_Load_Buttons_Appli(Glyph, CST_FWCONFIG, Self);
  inherited Loaded;
end;

{ TFWImport }

procedure TFWImport.Loaded;
begin
  p_Load_Buttons_Appli(Glyph, CST_FWIMPORT, Self);
  inherited Loaded;
end;

{ TFWExport }

procedure TFWExport.Loaded;
begin
  p_Load_Buttons_Appli(Glyph, CST_FWEXPORT, Self);
  inherited Loaded;
end;

{ TFWCopy }

procedure TFWCopy.Loaded;
begin
  p_Load_Buttons_Appli(Glyph, CST_FWCOPY, Self);
  inherited Loaded;
end;


{$IFDEF GROUPVIEW}

{ TFWOutSelect }

procedure TFWOutSelect.Loaded;
begin
  p_Load_Buttons_Appli(Glyph, CST_FWOUTSELECT, Self);
  inherited Loaded;
end;

{ TFWBasket }

procedure TFWBasket.Loaded;
begin
  p_Load_Buttons_Appli(Glyph, CST_FWBASKET, Self);
  inherited Loaded;
end;

{ TFWRecord }

procedure TFWRecord.Loaded;
begin
  p_Load_Buttons_Appli(Glyph, CST_FWOK, Self);
  inherited Loaded;
end;


{ TFWOutAll }

procedure TFWOutAll.Loaded;
begin
  p_Load_Buttons_Appli(Glyph, CST_FWOUTALL, Self);
  inherited Loaded;
end;

{ TFWInSelect }

procedure TFWInSelect.Loaded;
begin
  p_Load_Buttons_Appli(Glyph, CST_FWINSELECT, Self);
  inherited Loaded;
end;

{ TFWInAll }

procedure TFWInAll.Loaded;
begin
  p_Load_Buttons_Appli(Glyph, CST_FWINALL, Self);
  inherited Loaded;
end;

{ TFWGroupButtonActions }

constructor TFWGroupButtonActions.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Width := CST_WIDTH_BUTTONS_ACTIONS;
  Height := CST_HEIGHT_BUTTONS_ACTIONS;
end;

{ TFWGroupButtonMoving }

constructor TFWGroupButtonMoving.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  GlyphSize := CST_SIZE_BUTTONS_MOVING;
  Caption := '';
  Height := CST_HEIGHT_BUTTONS_MOVING;
  Width := CST_WIDTH_BUTTONS_MOVING;
end;
{$ENDIF}

initialization
{$IFDEF VERSIONS}
p_ConcatVersion(gVer_buttons_appli);
{$ENDIF}
{$IFDEF MEMBUTTONS}
{$IFDEF FPC}
{$I u_buttons_appli.lrs}
{$ENDIF}
{$ENDIF}

end.

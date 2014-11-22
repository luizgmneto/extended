unit F_Convert;

interface

{$IFDEF FPC}
{$Mode Delphi}
{$R *.lfm}
{$ELSE}
{$R *.dfm}
{$ENDIF}

uses
{$IFDEF FPC}
  EditBtn,
{$ELSE}
  Mask, rxToolEdit,
{$ENDIF}
  SysUtils, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, FileCtrl,
  ExtCtrls, U_OnFormInfoIni;

type

  { TForm1 }

  TForm1 = class(TForm)
    ch_utf8: TCheckBox;
    DirectoryEdit: TDirectoryEdit;
    OnFormInfoIni: TOnFormInfoIni;
    Panel1: TPanel;
    FileListBox: TFileListBox;
    Convertir: TButton;
    FilterComboBox: TFilterComboBox;
    Messages: TMemo;
    Panel2: TPanel;
    procedure ConvertirClick(Sender: TObject);
    procedure DirectoryEditChange(Sender: TObject);
    procedure FilterComboBoxChange(Sender: TObject);
  private
    procedure ConvertirDir(const as_Directory: String);
    procedure ConvertitField(var as_Ligne: String; const ai_LengthBegin: Integer
      );
    procedure ConvertitLigneDFMPAS(var as_Ligne: String);
    procedure DeleteUntilEnd(const ast_Lignes: TStringList ; const ai_pos1, ai_posEnd : LongInt );
    { Déclarations privées }
  public
    procedure ConvertitLignePAS( var ast_Lignes : TStringList; as_Lignes : String ); virtual;
    procedure ConvertitLigneDFM( var ast_Lignes : TStringList; as_Lignes : String ); virtual;
    procedure ConvertitFichier ( const FilePath, FileName  : String );
    { Déclarations publiques }
  end;
var
  Form1: TForm1;

implementation

uses StrUtils, FileUtil, fonctions_file,LConvEncoding;

var gb_Posifndef_fpc : Boolean = False ;
    gb_report        : Boolean = False ;

procedure TForm1.ConvertirClick(Sender: TObject);
var ls_Directory : String;
begin
  Messages.Lines.Clear;
  ls_Directory := DirectoryEdit.{$IFDEF FPC}Directory{$ELSE}Text{$ENDIF};
  ConvertirDir ( DirectoryEdit.{$IFDEF FPC}Directory{$ELSE}Text{$ENDIF} );
  Messages.Lines.Add( '-> Tout est fini .' );
end;

procedure TForm1.DirectoryEditChange(Sender: TObject);
begin
  FileListBox.Directory := DirectoryEdit.{$IFDEF FPC}Directory{$ELSE}Text{$ENDIF} ;
end;

procedure TForm1.FilterComboBoxChange(Sender: TObject);
begin
  FileListBox.Mask := FilterComboBox.Mask;
end;

procedure TForm1.ConvertirDir(const as_Directory : String );
var lstl_StringList : TStringList;
begin
  lstl_StringList := TStringList.Create;
  Messages.Lines.Add( '-> Parcours de ' + as_Directory );
  if fb_FindFiles ( lstl_StringList, as_Directory, True, True, True ) Then
    Begin
      while lstl_StringList.Count > 0 do
       Begin
        if (DirectoryexistsUTF8 ( lstl_StringList [ 0 ] )) then
          Begin
            ConvertirDir(lstl_StringList [ 0 ] );
          End
         else
           if (FileexistsUTF8 ( lstl_StringList [ 0 ] )) then
              ConvertitFichier ( lstl_StringList [ 0 ], ExtractFileName ( lstl_StringList [ 0 ] ));
         lstl_StringList.Delete ( 0 );
       end;

    End;
  Messages.Lines.Add( '-> Fin pour ' + as_Directory + '.' );
  lstl_StringList.free;
end;

procedure TForm1.ConvertitField( var as_Ligne : String ; const ai_LengthBegin : Integer );
var li_i, li_2Maj : Integer ;
    lb_Maj, lb_Maj2 : Boolean ;
begin
  lb_Maj  := False ;
  lb_Maj2 := False ;
  li_2Maj := 0;
  for li_i := ai_LengthBegin to length ( as_Ligne ) do
    Begin
      if ( as_Ligne [ li_i ] = '.' ) Then
        Begin
          if lb_Maj2 Then
            as_Ligne := copy(as_Ligne, 1, li_2Maj-1) +
                        '.FieldByName(''' +
                        copy(as_Ligne, li_2Maj, li_i -li_2Maj) +
                        ''')' +
                        copy(as_Ligne, li_i, length ( as_Ligne ) - li_i +1) ;
          Exit;
        end;
      if ( as_Ligne [ li_i ] in ['A'..'Z','_'] ) Then
        Begin
          if lb_Maj Then
            Begin
              if not lb_Maj2 Then
                li_2Maj := li_i - 1;
              lb_Maj2 := True;
            end;
          lb_Maj := True;
        end
       Else
        if as_Ligne [ li_i ] <> ' ' Then
          Begin
            lb_Maj  := False ;
            lb_Maj2 := False ;
          end;
    end;
End;

procedure p_ReplaceButton ( var as_Ligne : String ; const as_replaceEnd : String );
Begin
  as_Ligne := StringReplace ( as_Ligne, 'TJvXPButton', 'TFW'+as_replaceEnd, [rfIgnoreCase] );
  as_Ligne := StringReplace ( as_Ligne, 'TFlatSpeedButton', 'TFS'+as_replaceEnd, [rfIgnoreCase] );
  as_Ligne := StringReplace ( as_Ligne, 'TFlatButton', 'TFB'+as_replaceEnd, [rfIgnoreCase] );
  as_Ligne := StringReplace ( as_Ligne, 'TBlueFlatSpeedButton', 'TBFS'+as_replaceEnd, [rfIgnoreCase] );
end;

procedure TForm1.ConvertitLigneDFMPAS( var as_Ligne : String );
begin
  as_Ligne := StringReplace ( as_Ligne, 'DropDownMenu', 'PopupMenu', [rfReplaceAll,rfIgnoreCase] );
  Exit;
  if ( pos ( 'ferme', lowercase ( as_Ligne ))> 0 )
  or ( pos ( 'close', lowercase ( as_Ligne ))> 0 ) then
    p_ReplaceButton ( as_Ligne, 'Close');

  if ( pos ( 'btndel', lowercase ( as_Ligne ))> 0 )
  or ( pos ( 'supp', lowercase ( as_Ligne ))> 0 )
  or ( pos ( 'delete', lowercase ( as_Ligne ))> 0 ) then
    p_ReplaceButton ( as_Ligne, 'Delete');
 
  if ( pos ( 'btnadd', lowercase ( as_Ligne ))> 0 )
  or ( pos ( 'ajout' , lowercase ( as_Ligne ))> 0 ) then
    p_ReplaceButton ( as_Ligne, 'Add');

  if ( pos ( 'categ', lowercase ( as_Ligne ))> 0 ) then
    p_ReplaceButton ( as_Ligne, 'MFolder');

  if ( pos ( 'quit', lowercase ( as_Ligne ))> 0 ) then
    p_ReplaceButton ( as_Ligne, 'Quit');

  if ( pos ( 'prec' , lowercase ( as_Ligne ))> 0 )
  or ( pos ( 'prior', lowercase ( as_Ligne ))> 0 ) then
    p_ReplaceButton ( as_Ligne, 'Prior');
 
  if ( pos ( 'suiv' , lowercase ( as_Ligne ))> 0 )
  or ( pos ( 'next', lowercase ( as_Ligne ))> 0 ) then
    p_ReplaceButton ( as_Ligne, 'Next');

  if ( pos ( 'import', lowercase ( as_Ligne ))> 0 ) then
    p_ReplaceButton ( as_Ligne, 'Import');

  if ( pos ( 'export', lowercase ( as_Ligne ))> 0 ) then
    p_ReplaceButton ( as_Ligne, 'Export');

  if ( pos ( 'copie', lowercase ( as_Ligne ))> 0 ) then
    p_ReplaceButton ( as_Ligne, 'Copy');

  if ( pos ( 'aperc', lowercase ( as_Ligne ))> 0 )
  or ( pos ( 'previo' , lowercase ( as_Ligne ))> 0 ) then
    p_ReplaceButton ( as_Ligne, 'Preview');

  if ( pos ( 'enreg', lowercase ( as_Ligne ))> 0 )
  or ( pos ( 'select', lowercase ( as_Ligne ))> 0 )
  or ( pos ( 'appliq', lowercase ( as_Ligne ))> 0 )
  or ( pos ( 'ok' , lowercase ( as_Ligne ))> 0 ) then
    p_ReplaceButton ( as_Ligne, 'OK');

  if ( pos ( 'init', lowercase ( as_Ligne ))> 0 ) then
    p_ReplaceButton ( as_Ligne, 'Init');

  if ( pos ( 'config', lowercase ( as_Ligne ))> 0 ) then
    p_ReplaceButton ( as_Ligne, 'Config');

  if ( pos ( 'inser', lowercase ( as_Ligne ))> 0 ) then
    p_ReplaceButton ( as_Ligne, 'Insert');

  if ( pos ( 'annul', lowercase ( as_Ligne ))> 0 )
  or ( pos ( 'cancel', lowercase ( as_Ligne ))> 0 ) then
    p_ReplaceButton ( as_Ligne, 'Cancel');

  if ( pos ( 'imprim', lowercase ( as_Ligne ))> 0 )
  or ( pos ( 'print', lowercase ( as_Ligne ))> 0 ) then
    p_ReplaceButton ( as_Ligne, 'Print');
  as_Ligne := StringReplace( as_Ligne, 'DataBinding.FieldName', 'FieldName', [] );
  as_Ligne := StringReplace( as_Ligne, 'DataBinding.DataSource', 'DataSource', [] );
  as_Ligne := StringReplace( as_Ligne, 'Style.Color', 'Color', [] );

  as_Ligne := StringReplace( as_Ligne, 'Properties.FieldName', 'FieldName', [] );
  as_Ligne := StringReplace( as_Ligne, 'Properties.KeyFieldNames', 'LookupField', [] );
  as_Ligne := StringReplace( as_Ligne, 'Properties.DropDownRows', 'DropDownCount', [] );
  as_Ligne := StringReplace( as_Ligne, 'Properties.ListSource', 'LookupSource', [] );
  as_Ligne := StringReplace( as_Ligne, 'Properties.Grid.DataController.Values', 'KeyValue', [] );
  as_Ligne := StringReplace( as_Ligne, 'Properties.ReadOnly', 'ReadOnly', [] );
  as_Ligne := StringReplace( as_Ligne, 'Properties.OnChange', 'OnChange', [] );
  as_Ligne := StringReplace( as_Ligne, 'Properties.OnFocus', 'OnFocus', [] );
  as_Ligne := StringReplace( as_Ligne, 'Properties.OnClick', 'OnClick', [] );
  if gb_report Then
    Begin
      as_Ligne := StringReplace( as_Ligne, 'UserName', 'FriendlyName', [rfReplaceAll,rfIgnoreCase] );
      as_Ligne := StringReplace( as_Ligne, 'Border.Color', 'Borders.Color', [rfReplaceAll,rfIgnoreCase] );
      as_Ligne := StringReplace( as_Ligne, 'Border.Style', 'Borders.Style', [rfReplaceAll,rfIgnoreCase] );
    end;
end;




procedure TForm1.ConvertitFichier(const FilePath, FileName : String);
var ls_Ligne, ls_mail,ls_search : WideString ;
    lb_DFM ,
    lb_LFM ,
    lb_Pas ,
    lb_dpr : Boolean ;
    li_pos,
    li_pos3,
    li_pos2,
    li_i : Longint;
    lst_Lignes : TStringList ;
const CST_search = 'a href=""mailto:' ;
begin
  lb_DFM := PosEx ( '.dfm', LowerCase ( FileName ), length ( FileName ) - 5 ) > 0 ;
  lb_LFM := PosEx ( '.lfm', LowerCase ( FileName ), length ( FileName ) - 5 ) > 0 ;
  lb_pas := PosEx ( '.pas', LowerCase ( FileName ), length ( FileName ) - 5 ) > 0 ;
  lb_dpr := PosEx ( '.dpr', LowerCase ( FileName ), length ( FileName ) - 5 ) > 0 ;
  lst_Lignes := TStringList.Create;
  if ( lb_LFM or lb_DFM or lb_pas ) then
    try
     {if ch_utf8.Checked Then
       Begin
         lst_Lignes.LoadFromFile ( FilePath );
         lst_Lignes.text := ISO_8859_1ToUTF8(lst_Lignes.Text);
         lst_Lignes.SaveToFile   ( FilePath );
       end;                                }
      lst_Lignes.LoadFromFile ( FilePath );
      ls_search:=CST_search;
      for li_i := 0 to lst_Lignes.count-1 do
        Begin
          ls_Ligne:=lst_Lignes[li_i];
          li_pos := 1;
          while true do
           Begin
             li_pos:= posex ( ls_search, ls_Ligne, li_pos );
             if li_pos = 0 Then Break;
             li_pos2 :=li_pos +Length(ls_search);
             li_pos3 := posex ( '""', ls_Ligne, li_pos2 );
             ls_mail:=copy ( ls_Ligne, li_pos2, li_pos3 - li_pos2 );
             ls_Ligne:=copy ( ls_Ligne, 1, li_pos - 1 ) + ls_mail + copy ( ls_Ligne, li_pos3+2, Length(ls_Ligne)-li_pos3-2 );
           end;
          StringReplace(ls_Ligne,'mailto:','',[rfReplaceAll]);
          lst_Lignes[li_i]:=ls_Ligne;
        end;

      ls_search:='mailto:';

    { if lb_Pas Then
       ConvertitLignePAS ( lst_Lignes, FilePath )
      else
       ConvertitLigneDFM ( lst_Lignes, FilePath );}
    Application.ProcessMessages;
  finally
   // lst_Lignes.EndUpdate;
      //  if ch_utf8.Checked Then
         // lst_Lignes.Text := AnsiToUtf8 ( lst_Lignes.Text);
    lst_Lignes.SaveToFile   ( FilePath );

    lst_Lignes.Free;
    Messages.Lines.Add ( '  - Fichier ' + FileName + ' converti...' );
  end;

end;

function fb_IsField ( const as_ligne : String ) : Boolean;
Begin
  Result :=
       ( pos ( 'TIBStringField', as_Ligne )> 0 )
    or ( pos ( 'TIBBlobField', as_Ligne )> 0 )
    or ( pos ( 'TIBIntegerField', as_Ligne )> 0 )
    or ( pos ( 'TIBDateTimeField', as_Ligne )> 0 )
    or ( pos ( 'TIBFloatField', as_Ligne )> 0 )
    or ( pos ( 'TBlobField', as_Ligne )> 0 )
    or ( pos ( 'TFMTBCDField', as_Ligne )> 0 )
    or ( pos ( 'TDateTimeField', as_Ligne )> 0 )
    or ( pos ( 'TTimeField', as_Ligne )> 0 )
    or ( pos ( 'TDateField', as_Ligne )> 0 )
    or ( pos ( ': TIdHTTP', as_Ligne )> 0 )
    or ( pos ( ': TIdAntiFreeze', as_Ligne )> 0 )
    or ( pos ( ': TIdEncoderMIME', as_Ligne )> 0 )
    or ( pos ( 'TIntegerField', as_Ligne )> 0 )
    or ( pos ( 'TStringField', as_Ligne )> 0 )
    or ( pos ( 'TFloatField', as_Ligne )> 0 )
    or ( pos ( 'TMemoField', as_Ligne )> 0 );
End;


function fb_posUnwanted ( const as_Begin, as_ligne : String ; const ab_Grid : Boolean ) : Boolean ;
Begin
  Result := ( pos ( as_Begin + 'TExtDBGridBandedTableViewStyleSheet', as_ligne )> 0 )
         or ( pos ( as_Begin + 'TExtDBGridTableViewStyleSheet', as_ligne )> 0 )
         or ( pos ( as_Begin + 'TDBCheckVirtualDBTreeExReportLink', as_ligne )> 0 )
         or ( pos ( as_Begin + 'TDBCheckVirtualDBTreeExStyleSheet', as_ligne )> 0 )
         or ( pos ( as_Begin + 'TdxCustomContainerReportLink', as_ligne )> 0 )
         or ( pos ( as_Begin + 'TdxCustomContainerReportLink', as_ligne )> 0 )
         or ( pos ( as_Begin + 'TExtraOptions', as_ligne )> 0 )
         or ( pos ( as_Begin + 'TRLDetailGrid', as_ligne )> 0 )
         or ( pos ( as_Begin + 'TcxIntlPrintSys3', as_Ligne )> 0 )
         or ( pos ( as_Begin + 'TcxIntlBars', as_Ligne )> 0 )
         or ( pos ( as_Begin + 'TcxIntl', as_Ligne )> 0 )
         or ( pos ( as_Begin + 'TDBCheckVirtualDBTreeExColumn', as_ligne )> 0 )
         or ( pos ( as_Begin + 'TExtDBGridLevel', as_ligne )> 0 )
         or ( pos ( as_Begin + 'TcxEditStyleController', as_ligne )> 0 )
         or ( pos ( as_Begin + 'TWizardTree', as_ligne )> 0 )
         or ( pos ( as_Begin + 'TcxHintStyleController', as_ligne )> 0 )
         or ( pos ( as_Begin + 'TdxPrintStyleManager', as_ligne )> 0 )
         or ( pos ( as_Begin + 'TBasedxPrintStyle', as_ligne )> 0 )

         or ( pos ( as_Begin + 'TcxStyle', as_ligne )> 0 );
  if not Result
  and ab_Grid Then
  Result := ( pos ( as_Begin + 'TExtDBGridDBColumn', as_ligne )> 0 )
         or ( pos ( as_Begin + 'TExtDBGridDBBandedTableView', as_ligne )> 0 )
         or ( pos ( as_Begin + 'TExtDBGridDBTableView', as_ligne )> 0 )
         or ( pos ( as_Begin + 'TExtDBGridDBBandedColumn ', as_ligne )> 0 );

end;


procedure TForm1.ConvertitLignePAS( var ast_Lignes : TStringList; as_Lignes : String );
var li_pos1, li_pos2 : LongInt;
    ls_Ligne : String;

begin
  li_pos1 := -1;
  ast_Lignes.BeginUpdate;
  while li_pos1 < ast_Lignes.Count - 1 do
    Begin
      inc ( li_pos1 );
      Application.ProcessMessages;
      ls_Ligne := ast_Lignes [ li_pos1 ];
      li_pos2 := pos ( '.FieldByName(''', ls_Ligne );
      while ( li_pos2 > 0 ) do
        Begin
          ls_Ligne:=copy(ls_Ligne, 1, li_pos2 -1 )+copy ( ls_Ligne, li_pos2 + 14, length ( ls_Ligne ) - li_pos2 - 13 );
          li_pos2 := PosEx(''')',ls_Ligne,li_pos2);
          if li_pos2 > 0 Then ls_Ligne := copy(ls_Ligne, 1, li_pos2 -1 )+copy ( ls_Ligne, li_pos2 + 2, length ( ls_Ligne ) - li_pos2 - 1 );
          li_pos2 := pos ( '.FieldByName(''', ls_Ligne );
         // ShowMessage(ls_Ligne)
        end;
      ls_Ligne:=StringReplace(ls_Ligne,'TFWDBGrid','TExtDBGrid',[rfReplaceAll,rfIgnoreCase]);
      ast_Lignes [ li_pos1 ] := ls_Ligne;

    End;
end;

procedure TForm1.ConvertitLigneDFM( var ast_Lignes : TStringList; as_Lignes : String );
var li_pos1, li_pos2, li_pos3, li_pos4, li_pos5, li_pos6 : LongInt;
    ls_Ligne, ls_temp : String;
    lb_columns, lb_lookup, lb_end, lb_tree, lb_grid, lb_double : Boolean;

function fb_IsGridColumn ( const as_ligne : String ) : Boolean ;
begin
  Result := ( pos ( 'TExtDBGridDBColumn', as_Ligne  ) > 0 )
            or ( pos ( 'TDBCheckVirtualDBTreeExColumn', as_Ligne  ) > 0 )
            or ( pos ( 'TColumnIndex', as_Ligne  ) > 0 )
            or ( pos ( 'TExtDBGridDBBandedColumn', as_Ligne ) > 0 );
end;

function fb_deleteOtherItem : Boolean;
begin
  if ( pos ( '<', ls_ligne ) > 0 ) Then
   Begin
    repeat
     ls_ligne := ast_Lignes [ li_pos1 ];
     ast_Lignes.delete ( li_pos1 );
    until pos ( '>', ls_ligne ) > 0;
    Result := True;
    dec ( li_pos1 );
    Exit;
   end;
  Result := False;

end;

begin
  li_pos1 := 0;
  li_pos2 := -1;
  li_pos3 := -1;
  li_pos4 := -1;
  lb_columns := False;
  lb_lookup  := False;
  lb_end := True;
  lb_tree := False ;
  lb_double := False ;
  lb_grid:=False;
  ast_Lignes.BeginUpdate;
  while li_pos1 < ast_Lignes.Count - 1 do
    Begin
      if ( pos ( 'TIBQuery', ast_Lignes [ li_pos1 ]) > 0 ) Then
       Exit;
      ast_Lignes.Delete ( li_pos1 );
      {
      ls_Ligne := ast_Lignes [ li_pos1 ];
      Application.ProcessMessages;
      ConvertitLigneDFMPAS ( ls_ligne );
      ast_Lignes [ li_pos1 ] := ls_Ligne;}
    End;
end;

procedure TForm1.DeleteUntilEnd( const ast_Lignes : TStringList ; const ai_pos1, ai_posEnd : LongInt );
var ls_Ligne : String;
Begin
  repeat
  ls_Ligne := ast_Lignes [ ai_pos1 ];
  ast_Lignes.Delete( ai_pos1);
  until ( pos ( 'end', ls_Ligne ) > 0 )
    and (( ai_posEnd = -1 ) or ( ai_posEnd = pos ( 'end', ls_Ligne )));
end;

end.

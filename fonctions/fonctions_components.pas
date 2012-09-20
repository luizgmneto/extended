unit fonctions_components;

interface

{$IFDEF FPC}
{$mode Delphi}
{$ENDIF}

{$I ..\DLCompilers.inc}
{$I ..\extends.inc}

uses SysUtils,
  {$IFDEF VERSIONS}
  fonctions_version,
  {$ENDIF}
  DB,
  Controls, StdCtrls,
  Classes, DBGrids ;

  {$IFDEF VERSIONS}
const
  gVer_fonctions_components : T_Version = ( Component : 'Fonctions de personnalisation des composants' ;
                                         FileUnit : 'fonctions_components' ;
      			                 Owner : 'Matthieu Giroux' ;
      			                 Comment : 'Fonctions de gestion des composants visuels.' ;
      			                 BugsStory : 'Version 1.0.2.0 : CSV and HTML Grid''s Export.'+#10
                                                   + 'Version 1.0.1.0 : Auto combo init.'+#10
                                                   + 'Version 1.0.0.0 : Ajout de fonctions d''automatisation.';
      			                 UnitType : 1 ;
      			                 Major : 1 ; Minor : 0 ; Release : 2 ; Build : 0 );

  {$ENDIF}

type TFieldMethod = function ( const AField : TField ;
                               var IsFirst : Boolean ;
                               const Separator : String; const AReplaceCaption : String = '' ):String;

procedure p_ComponentSelectAll ( const aobj_Component : TObject );
function  fb_AutoComboInit ( const acom_Combo : TComponent ):Boolean;
procedure ExportGridToHTML(const AFileName : String ; const AGrid : TCustomDBGrid;const ab_Header, ab_all : Boolean ; const As_Extension : String = 'html' );
procedure ExportGridToCSV (const AFileName : String ; const AGrid : TCustomDBGrid;const ab_Header, ab_all : Boolean ; const As_Extension : String = 'csv'; const aseparate : Char = ';' );
procedure ExportGridTo ( const AFieldMethod : TFieldMethod; const Afile : TStringList; const AGrid : TCustomDBGrid; const As_beginLine, as_endLine, as_beginCell, as_endCell, as_separator, As_beginHeader, As_EndHeader, As_beginText, As_EndText : String ; const ab_header : Boolean = False );


implementation

uses Variants,  Math, fonctions_erreurs, fonctions_string,
  {$IFDEF FPC}
  unite_messages,
  {$ELSE}
  unite_messages_delphi,
  {$ENDIF}
  fonctions_proprietes,
  fonctions_languages,
  fonctions_init ;

function AddFieldCSV ( const AField : TField ; var IsFirst : Boolean; const Separator : String; const AReplaceCaption : String = '' ):String;
  function AddField : String;
   Begin
     if AReplaceCaption = ''
      Then Result := StringReplace (  StringReplace ( StringReplace(AField.AsString, CST_ENDOFLINE, '\n', [ rfReplaceAll ] ), '\', '\\', [ rfReplaceAll ] ), '"', '\"', [ rfReplaceAll ] )
      Else Result := AReplaceCaption;
   end;

Begin
  if IsFirst Then
   Begin
    IsFirst := False;
    Result := AddField;
   end
  Else
   Begin
     Result := Separator + AddField;
   end;
end;

function AddFieldHTML ( const AField : TField ; var IsFirst : Boolean; const Separator : String; const AReplaceCaption : String = '' ):String;
  function AddField : String;
   Begin
     if AReplaceCaption = ''
      Then Result := StringReplace(AField.AsString, CST_ENDOFLINE, '<BR>'+CST_ENDOFLINE, [ rfReplaceAll ] )
      Else Result := AReplaceCaption;
   end;

Begin
  if IsFirst Then
   Begin
    IsFirst := False;
    Result := AddField;
   end
  Else
   Begin
     Result := Separator + AddField;
   end;
end;

procedure ExportGridTo ( const AFieldMethod : TFieldMethod; const Afile : TStringList; const AGrid : TCustomDBGrid; const As_beginLine, as_endLine, as_beginCell, as_endCell, as_separator, As_beginHeader, As_EndHeader, As_beginText, As_EndText : String ; const ab_header : Boolean = False );
var i : Integer;
    IsFirst : Boolean;
    AString : String ;
    Acolumns : TDBGridColumns;

Begin
  Acolumns := fobj_getComponentObjectProperty( AGrid, 'Columns' ) as TDBGridColumns;

  if ab_header Then
   for i := 0 to Acolumns.count - 1 do
    with Acolumns [ i ] do
     if Visible Then
      Begin
       if  not ( Field is TNumericField )
       and not ( Field is TStringField  )
       and not ( Field is TBooleanField ) then
        Continue;
       AppendStr ( AString, as_beginCell + As_beginHeader + AFieldMethod ( nil, IsFirst, as_separator, Title.Caption ) + As_EndHeader + as_endCell );
      end;

  with AGrid, (fobj_getComponentObjectProperty( AGrid, 'Datasource' ) as TDataSource ).Dataset do
    if not IsEmpty then
     Begin
       DisableControls;
       try
         First;
         repeat
           AString := As_beginLine;
           IsFirst := True;
           for i := 0 to Acolumns.count - 1 do
            with Acolumns [ i ] do
             if Visible Then
              Begin
               if  not ( Field is TNumericField )
               and not ( Field is TStringField  )
               and not ( Field is TBooleanField ) then
                Continue;
               AppendStr ( AString, as_beginCell + As_beginText + AFieldMethod ( Field, IsFirst, as_separator ) + As_EndText + as_endCell );
              end;
           Next;
           Afile.Add (AString+as_endLine);
         until Eof;
       finally
         EnableControls;
       end;
     end;
End;

procedure ExportGridToCSV (const AFileName : String ; const AGrid : TCustomDBGrid;const ab_Header, ab_all : Boolean ; const As_Extension : String = 'csv'; const aseparate : Char = ';' );
var astringlist : TStringList;
Begin
  astringlist := TStringList.Create;
  try
    ExportGridTo ( TFieldMethod (@AddFieldCSV), astringlist, AGrid, '','','','','"','"','"','"',aseparate, ab_Header);
    astringlist.SaveToFile(AFileName);
  finally
    astringlist.Free;
  end;
End;

procedure ExportGridToHTML(const AFileName : String ; const AGrid : TCustomDBGrid;const ab_Header, ab_all : Boolean ; const As_Extension : String = 'html' );
var astringlist : TStringList;
Begin
  astringlist := TStringList.Create;
  try
    astringlist.Add('<HTML><HEAD><meta http-equiv=Content-Type content="text/html; charset='+gs_HtmlCharset+'" /></HEAD><BODY><TABLE>');
    ExportGridTo ( AddFieldHTML, astringlist, AGrid, '<TR>','</TR>','<TD>','</TD>','','<STRONG>','</STRONG>','','', ab_Header);
    astringlist.Add('</TABLE></BODY></HTML>');
    astringlist.SaveToFile(AFileName);
  finally
    astringlist.Free;
  end;
End;

function fb_AutoComboInit ( const acom_Combo : TComponent ):Boolean;
var astl_Items : TStrings;
Begin

  astl_Items:= TStrings( fobj_getComponentObjectProperty ( acom_Combo, CST_INI_ITEMS ));
  if ( astl_Items = nil )
  or ( astl_Items.Count = 0 )
   Then
     Begin
      Result:=False;
      Exit;
     end;
  if ( flin_getComponentProperty( acom_Combo, CST_INI_ITEMINDEX ) < 0 )
   Then
    p_SetComponentProperty( acom_Combo, CST_INI_ITEMINDEX, 0 );
  p_SetComponentProperty( acom_Combo, CST_INI_TEXT, astl_Items[flin_getComponentProperty( acom_Combo, CST_INI_ITEMINDEX )]);
  Result := True;
end;

procedure p_ComponentSelectAll ( const aobj_Component : TObject );
Begin
  if aobj_Component is TCustomEdit Then
    (aobj_Component as TCustomEdit ).SelectAll;
End;

{$IFDEF VERSIONS}
initialization
  p_ConcatVersion ( gVer_fonctions_components );
{$ENDIF}
end.
